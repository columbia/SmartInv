1 pragma solidity ^0.4.8;
2 contract KeberuntunganAcak {
3 //##########################################################
4 //##Payout ialah acak dan tidak mengikut antrian####
5 //##Keacakan berdasarkan random hashblock oleh miner####
6 //#### Deposit 0.05 ETHER + fee gas utk partisipasi ####
7 //#### 2% dari 0.05 Ether akan diperuntukkan utk fee kepada owner ####
8 //#### Jika transfer lebih dari 0.05Ether maka sisanya akan dikembalikan ####
9 //###Jika beruntung maka bisa lgs dapat payout##########
10 //###Jika gak beruntung maka harus wait ##########
11 //###payout ialah 125% ##########
12 //###payout ialah otomatis dan contract tidak dapat dimodif lagi setelah deploy oleh sesiapapun termasuk owner ##########
13 //COPYRIGHT 2017 hadioneyesoneno
14 //Edukasi dan eksperimen purpose only
15 
16 
17     address private owner;
18     
19     //Stored variables
20     uint private balance = 0;
21     uint private fee = 2;
22     uint private multiplier = 125;
23 
24     mapping (address => User) private users;
25     Entry[] private entries;
26     uint[] private unpaidEntries;
27     
28     //Set owner on contract creation
29     function KeberuntunganAcak() {
30         owner = msg.sender;
31     }
32 
33     modifier onlyowner { if (msg.sender == owner) _ ;}
34     
35     struct User {
36         address id;
37         uint deposits;
38         uint payoutsReceived;
39     }
40     
41     struct Entry {
42         address entryAddress;
43         uint deposit;
44         uint payout;
45         bool paid;
46     }
47 
48     //Fallback function
49     function() {
50         init();
51     }
52     
53     function init() private{
54         
55         if (msg.value < 50 finney) {
56              (msg.sender.send(msg.value));
57             return;
58         }
59         
60         join();
61     }
62     
63     function join() public payable {
64         
65         //Limit deposits to 0.05ETH
66         uint dValue = 50 finney;
67         
68         if (msg.value > 50 finney) {
69             
70         	(msg.sender.send(msg.value - 50 finney));	
71         	dValue = 50 finney;
72         }
73       
74         //Add new users to the users array
75         if (users[msg.sender].id == address(0))
76         {
77             users[msg.sender].id = msg.sender;
78             users[msg.sender].deposits = 0;
79             users[msg.sender].payoutsReceived = 0;
80         }
81         
82         //Add new entry to the entries array
83         entries.push(Entry(msg.sender, dValue, (dValue * (multiplier) / 100), false));
84         users[msg.sender].deposits++;
85         unpaidEntries.push(entries.length -1);
86         
87         //Collect fees and update contract balance
88         balance += (dValue * (100 - fee)) / 100;
89         
90         uint index = unpaidEntries.length > 1 ? rand(unpaidEntries.length) : 0;
91         Entry theEntry = entries[unpaidEntries[index]];
92         
93         //Pay pending entries if the new balance allows for it
94         if (balance > theEntry.payout) {
95             
96             uint payout = theEntry.payout;
97             
98             (theEntry.entryAddress.send(payout));
99             theEntry.paid = true;
100             users[theEntry.entryAddress].payoutsReceived++;
101 
102             balance -= payout;
103             
104             if (index < unpaidEntries.length - 1)
105                 unpaidEntries[index] = unpaidEntries[unpaidEntries.length - 1];
106            
107             unpaidEntries.length--;
108             
109         }
110         
111         //Collect money from fees and possible leftovers from errors (actual balance untouched)
112         uint fees = this.balance - balance;
113         if (fees > 0)
114         {
115                 (owner.send(fees));
116         }      
117        
118     }
119     
120     //Generate random number between 0 & max
121     uint256 constant private FACTOR =  1157920892373161954235709850086879078532699846656405640394575840079131296399;
122     function rand(uint max) constant private returns (uint256 result){
123         uint256 factor = FACTOR * 100 / max;
124         uint256 lastBlockNumber = block.number - 1;
125         uint256 hashVal = uint256(block.blockhash(lastBlockNumber));
126     
127         return uint256((uint256(hashVal) / factor)) % max;
128     }
129     
130     
131     //Contract management
132     function changeOwner(address newOwner) onlyowner private {
133         owner = newOwner;
134     }
135     
136     function changeMultiplier(uint multi) onlyowner private {
137         if (multi < 110 || multi > 150) throw;
138         
139         multiplier = multi;
140     }
141     
142     function changeFee(uint newFee) onlyowner private {
143         if (fee > 2) 
144             throw;
145         fee = newFee;
146     }
147     
148     
149     //JSON functions
150     function multiplierFactor() constant returns (uint factor, string info) {
151         factor = multiplier;
152         info = 'multipliyer ialah 125%'; 
153     }
154     
155     function currentFee() constant returns (uint feePercentage, string info) {
156         feePercentage = fee;
157         info = 'fee ialah 2%.';
158     }
159     
160     function totalEntries() constant returns (uint count, string info) {
161         count = entries.length;
162         info = 'seberapa banyak deposit';
163     }
164     
165     function userStats(address user) constant returns (uint deposits, uint payouts, string info)
166     {
167         if (users[user].id != address(0x0))
168         {
169             deposits = users[user].deposits;
170             payouts = users[user].payoutsReceived;
171             info = 'Users stats: total deposits, payouts diterima.';
172         }
173     }
174     
175     function entryDetails(uint index) constant returns (address user, uint payout, bool paid, string info)
176     {
177         if (index < entries.length) {
178             user = entries[index].entryAddress;
179             payout = entries[index].payout / 1 finney;
180             paid = entries[index].paid;
181             info = 'Entry info: user address, expected payout in Finneys, payout status.';
182         }
183     }
184     
185     
186 }