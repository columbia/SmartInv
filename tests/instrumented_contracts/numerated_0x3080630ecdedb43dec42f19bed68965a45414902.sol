1 // Welcome to the source code of the unofficial Etheremon Swap smart contract! This allows MonSeekers to trustlessly trade mons with each other.
2 // You can offer up any specific Etheremon you own in exchange for any other specific mon or any mon of a specific class.
3 // For example, you can offer up your Berrball in exchange for any Dracobra.
4 // Or you can offer it in exchange for some specific mon specified by object ID, like that level 50 Pangrass named "Donny".
5 // You can even keep both offers up at once if you want.
6 // If someone has an offer up that your mon qualifies for (for example if "Donny" belongs to you or you happen to own a Dracobra), you can match that offer to execute the trade, instantly transferring the mons to their new owners.
7 
8 pragma solidity ^0.4.19;
9 
10 contract Ownable
11 {
12     address public owner;
13     
14     modifier onlyOwner
15     {
16         require(msg.sender == owner);
17         _;
18     }
19     
20     function Ownable() public
21     {
22         owner = msg.sender;
23     }
24 }
25 
26 // Interface for the official Etheremon Data contract.
27 contract EtheremonData
28 {
29     function getMonsterObj(uint64 _objId) constant public returns(uint64 objId, uint32 classId, address trainer, uint32 exp, uint32 createIndex, uint32 lastClaimIndex, uint createTime);
30 }
31 
32 // Interface for the official Etheremon Trade contract.
33 contract EtheremonTrade
34 {
35     function freeTransferItem(uint64 _objId, address _receiver) external;
36 }
37 
38 // Deposit contract. Each trader has a unique one which is generated ONCE and never changes.
39 // To trade a mon, it must be deposited in your deposit address. You can't trade mons that aren't deposited!
40 // Each trader has complete control over mons in their deposit address, so only send YOUR mons to YOUR unique deposit address!
41 // Sending a mon to someone else's deposit address is the same as giving them the mon for free.
42 // Finally, make sure you actually GENERATE a deposit address before depositing mons.
43 // If you haven't generated one before then your deposit address will appear to be 0x000... which is NOT A REAL DEPOSIT ADDRESS! Any mons sent to 0x000... will be lost forever!
44 contract EtheremonDepositContract is Ownable
45 {
46     function sendMon(address tradeAddress, address receiver, uint64 mon) external onlyOwner // The "owner" is always the EtheremonSwap contract itself because it created this deposit contract on your behalf.
47     {
48         EtheremonTrade(tradeAddress).freeTransferItem(mon, receiver);
49     }
50 }
51 
52 // This is the main contract. This needs an owner (it's me, hi!) because it is possible for Etheremon's Trade contract to be upgraded. The owner of this contract is responsible for updating the Trade address if/when that happens.
53 // Eventually Etheremon will be fully decentralized and we can be sure the Trade contract will never be changed. After that happens the owner of THIS contract will be set to 0x0, effectively revoking ownership.
54 // The only power the contract owner has is changing the address pointing to the official Etheremon Trade contract.
55 // If the contract owner is compromised, the worst that could happen is you will no longer be able to trade mons through this contract.
56 // It is NOT possible for the contract owner to withdraw anyone else's mons.
57 // It is NOT possible for the contract owner to sever the link between a user and their deposit address.
58 // It is NOT possible for the contract owner to prevent a user from withdrawing their deposited mons.
59 // Even if the contract owner tried to set up his own malicious copy of the Trade contract, only the official Etheremon Trade contract has the authority to transfer mons, so nothing could be accomplished that way.
60 contract EtheremonSwap is Ownable
61 {
62     address public dataAddress = 0xabc1c404424bdf24c19a5cc5ef8f47781d18eb3e;
63     address public tradeAddress = 0x4ba72f0f8dad13709ee28a992869e79d0fe47030;
64     
65     mapping(address => address) public depositAddress;
66     mapping(uint64 => address) public monToTrainer; // Only valid for POSTED mons.
67     mapping(uint64 => uint64) public listedMonForMon;
68     mapping(uint64 => uint32) public listedMonForClass;
69     
70     // Included here instead of Ownable because the Deposit contracts don't need it.
71     function changeOwner(address newOwner) onlyOwner external
72     {
73         owner = newOwner;
74     }
75     
76     function setTradeAddress(address _tradeAddress) onlyOwner external
77     {
78         tradeAddress = _tradeAddress;
79     }
80     
81     // Generates a new deposit address for the sender.
82     function generateDepositAddress() external
83     {
84         require(depositAddress[msg.sender] == 0); // Any given address may only have one deposit address at a time.
85         depositAddress[msg.sender] = new EtheremonDepositContract();
86     }
87     
88     // Withdraws the given mon from your deposit address. Only reason to do this is if someone changed their mind about trading a mon.
89     function withdrawMon(uint64 mon) external
90     {
91         // Only possible to withdraw if you have a deposit address in the first place.
92         require(depositAddress[msg.sender] != 0);
93         // Delist the mon from any posted trades.
94         delist(mon);
95         // Execute the withdrawal. No need to check ownership or anything; Etheremon's official trade contract will revert this transaction for us if there's a problem.
96         EtheremonDepositContract(depositAddress[msg.sender]).sendMon(tradeAddress, msg.sender, mon);
97     }
98     
99     // If the contract owner is compromised or has failed to update the reference to the Trade contract after an Etheremon upgrade,
100     // you can use this function to withdraw any deposited mons by providing the address of the official Etheremon Trade contract.
101     function emergencyWithdraw(address _tradeAddress, uint64 mon) external
102     {
103         // Exactly the same as the regular withdrawal but with a user-provided trade address.
104         require(depositAddress[msg.sender] != 0);
105         delist(mon);
106         EtheremonDepositContract(depositAddress[msg.sender]).sendMon(_tradeAddress, msg.sender, mon);
107     }
108     
109     // Posts a trade offering up your mon for ONLY the given mon.
110     // Will replace this mon's currently listed Mon-for-Mon trade if it exists.
111     // Will NOT replace this mon's currently listed Mon-for-Class trade if it exists!
112     function postMonForMon(uint64 yourMon, uint64 desiredMon) external
113     {
114         // Make sure you own and have deposited the mon you're posting.
115         checkOwnership(yourMon);
116         // Make sure you're requesting a valid mon.
117         require(desiredMon != 0);
118         
119         listedMonForMon[yourMon] = desiredMon;
120         
121         monToTrainer[yourMon] = msg.sender;
122     }
123     
124     // Posts a trade offering up your mon for ANY mon of the given class.
125     // To figure out the class ID, just look at the URL of that mon's page.
126     // For example, Tygloo is class 33: https://www.etheremon.com/#/mons/33
127     // Will replace this mon's currently listed Mon-for-Class trade if it exists.
128     // Will NOT replace this mon's currently listed Mon-for-Mon trade if it exists!
129     function postMonForClass(uint64 yourMon, uint32 desiredClass) external
130     {
131         // Make sure you own and have deposited the mon you're posting.
132         checkOwnership(yourMon);
133         // Make sure you're requesting a valid class.
134         require(desiredClass != 0);
135         
136         listedMonForClass[yourMon] = desiredClass;
137         
138         monToTrainer[yourMon] = msg.sender;
139     }
140     
141     // Delists the given mon from all posted trades. This is only useful if you still want to trade it later.
142     // If you just want to modify your listing, use appropriate the postMon functions instead.
143     // If you just want your mon back, use withdrawMon. Withdrawn mons get delisted automatically.
144     function delistMon(uint64 mon) external
145     {
146         // Make sure the mon is both listed and owned by the sender.
147         require(monToTrainer[mon] == msg.sender);
148         delist(mon);
149     }
150     
151     // Matches a posted trade.
152     function trade(uint64 yourMon, uint64 desiredMon) external
153     {
154         // No need to waste gas checking for weird uncommon situations (like yourMon and desiredMon being owned by
155         // the same address or even being the same mon) because the trade will revert in those situations anyway.
156         
157         // Make sure you own and have deposited the mon you're offering.
158         checkOwnership(yourMon);
159         
160         // If there's no exact match...
161         if(listedMonForMon[desiredMon] != yourMon)
162         {
163             // ...check for a class match.
164             uint32 class;
165             (,class,,,,,) = EtheremonData(dataAddress).getMonsterObj(yourMon);
166             require(listedMonForClass[desiredMon] == class);
167         }
168         
169         // If we reached this point, we have a match. Now we execute the trade.
170         executeTrade(msg.sender, yourMon, monToTrainer[desiredMon], desiredMon);
171         
172         // The trade was successful. Delist all mons involved.
173         delist(yourMon);
174         delist(desiredMon);
175     }
176     
177     // Ensures the sender owns and has deposited the given mon.
178     function checkOwnership(uint64 mon) private view
179     {
180         require(depositAddress[msg.sender] != 0); // Obviously you must have a deposit address in the first place.
181         
182         address trainer;
183         (,,trainer,,,,) = EtheremonData(dataAddress).getMonsterObj(mon);
184         require(trainer == depositAddress[msg.sender]);
185     }
186     
187     // Executes a trade, swapping the mons between trainer A and trainer B.
188     // No withdrawal is necessary: the mons end up in the trainers' actual addresses, NOT their deposit addresses!
189     function executeTrade(address trainerA, uint64 monA, address trainerB, uint64 monB) private
190     {
191         EtheremonDepositContract(depositAddress[trainerA]).sendMon(tradeAddress, trainerB, monA); // Mon A from trainer A to trainer B.
192         EtheremonDepositContract(depositAddress[trainerB]).sendMon(tradeAddress, trainerA, monB); // Mon B from trainer B to trainer A.
193     }
194     
195     // Delists the given mon from any posted trades.
196     function delist(uint64 mon) private
197     {
198         if(listedMonForMon  [mon] != 0){listedMonForMon  [mon] = 0;}
199         if(listedMonForClass[mon] != 0){listedMonForClass[mon] = 0;}
200         if(monToTrainer     [mon] != 0){monToTrainer     [mon] = 0;}
201     }
202 }