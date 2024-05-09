1 contract BlockChainEnterprise {
2     
3         uint private BlockBalance = 0; //block balance (0 to BlockSize eth)
4         uint private NumberOfBlockMined = 0; 
5         uint private BlockReward = 0;
6         uint private BlockSize =  10 ether; //a block is size 10 ETH, and with 1.2 multiplier it is paid 12 ETH
7         uint private MaxDeposit = 5 ether;
8         uint private multiplier = 1200; // Multiplier
9         
10         
11         uint private fees = 0;      //Fees are just verly low : 1% !
12         uint private feeFrac = 5;  //Fraction for fees in "thousandth" --> only 0.5% !!
13         uint private RewardFrac = 30;  //Fraction for Reward in "thousandth"
14         
15         
16         uint private Payout_id = 0;
17         
18         address private admin;
19         
20         function BlockChainEnterprise() {
21             admin = msg.sender;
22         }
23 
24         modifier onlyowner {if (msg.sender == admin) _  }
25 
26         struct Miner {
27             address addr;
28             uint payout;
29             bool paid;
30         }
31 
32         Miner[] private miners;
33 
34         //--Fallback function
35         function() {
36             init();
37         }
38 
39         //--initiated function
40         function init() private {
41             uint256 new_deposit=msg.value;
42             //------ Verifications on this new deposit ------
43             if (new_deposit < 100 finney) { //only >0.1 eth participation accepted
44                     msg.sender.send(new_deposit);
45                     return;
46             }
47             
48             if( new_deposit > MaxDeposit ){
49                 msg.sender.send( msg.value - MaxDeposit );
50                 new_deposit= MaxDeposit;
51             }
52             //-- enter the block ! --
53             Participate(new_deposit);
54         }
55 
56         function Participate(uint deposit) private {
57             
58             if( BlockSize  < (deposit + BlockBalance) ){ //if this new deposit is part of 2 blocks
59                 uint256 fragment = BlockSize - BlockBalance;
60                 miners.push(Miner(msg.sender, fragment*multiplier/1000 , false)); //fill the block
61                 miners.push(Miner(msg.sender, (deposit - fragment)*multiplier/1000  , false)); //contruct the next one
62             }
63             else{
64                 miners.push(Miner(msg.sender, deposit*multiplier/1000 , false)); // add this new miner in the block !
65             }
66                 
67             //--- UPDATING CONTRACT STATS ----
68             BlockReward += (deposit * RewardFrac) / 1000; // take some to reward the winner that make the whole block mined !
69             fees += (deposit * feeFrac) / 1000;          // collect small fee
70             BlockBalance += (deposit * (1000 - ( feeFrac + RewardFrac ))) / 1000; //update balance
71 
72             
73             //Mine the block first if possible !
74             if( BlockBalance >= (BlockSize/1000*multiplier) ){// it can be mined now !
75                 PayMiners();
76                 PayWinnerMiner(msg.sender,deposit);
77             }
78         }
79 
80 
81         function PayMiners() private{
82             NumberOfBlockMined +=1;
83             //Classic payout of all participants of the block
84             while ( miners[Payout_id].payout!=0 && BlockBalance >= ( miners[Payout_id].payout )  ) {
85                 miners[Payout_id].addr.send(miners[Payout_id].payout); //pay the man !
86                 
87                 BlockBalance -= miners[Payout_id].payout; //update the balance
88                 miners[Payout_id].paid=true;
89                 
90                 Payout_id += 1;
91             }
92         }
93         
94         function  PayWinnerMiner(address winner, uint256 deposit) private{ //pay the winner accordingly to his deposit !
95             //Globally, EVERYONE CAN WIN by being smart and quick.
96             if(deposit >= 1 ether){ //only 1 ether, and you get it all !
97                 winner.send(BlockReward);
98                 BlockReward =0;
99             }
100             else{ // deposit is between 0.1 and 0.99 ether
101                 uint256 pcent = deposit / 10 finney;
102                 winner.send(BlockReward*pcent/100);
103                 BlockReward -= BlockReward*pcent/100;
104             }
105         }
106     
107 
108     //---Contract management functions
109     function ChangeOwnership(address _owner) onlyowner {
110         admin = _owner;
111     }
112     
113     
114     function CollectAllFees() onlyowner {
115         if (fees == 0) throw;
116         admin.send(fees);
117         fees = 0;
118     }
119     
120     function GetAndReduceFeesByFraction(uint p) onlyowner {
121         if (fees == 0) feeFrac=feeFrac*80/100; //Reduce fees.
122         admin.send(fees / 1000 * p);//send a percent of fees
123         fees -= fees / 1000 * p;
124     }
125         
126 
127 //---Contract informations
128 
129 
130 function WatchBalance() constant returns(uint TotalBalance, string info) {
131     TotalBalance = BlockBalance /  1 finney;
132     info ='Balance in finney';
133 }
134 
135 function WatchBlockSizeInEther() constant returns(uint BlockSizeInEther, string info) {
136     BlockSizeInEther = BlockSize / 1 ether;
137     info ='Balance in ether';
138 }
139 function WatchNextBlockReward() constant returns(uint Reward, string info) {
140     Reward = BlockReward / 1 finney;
141     info ='Current reward collected. The reward when a block is mined is always BlockSize*RewardPercentage/100';
142 }
143 
144 function NumberOfMiners() constant returns(uint NumberOfMiners, string info) {
145     NumberOfMiners = miners.length;
146     info ='Number of participations since the beginning of this wonderful blockchain';
147 }
148 
149 function WatchCurrentMultiplier() constant returns(uint Mult, string info) {
150     Mult = multiplier;
151     info ='Current multiplier';
152 }
153 function NumberOfBlockAlreadyMined() constant returns(uint NumberOfBlockMinedAlready, string info) {
154     NumberOfBlockMinedAlready = NumberOfBlockMined;
155     info ='A block mined is a payout of size BlockSize, multiply this number and you get the sum of all payouts.';
156 }
157 function AmountToForgeTheNextBlock() constant returns(uint ToDeposit, string info) {
158     ToDeposit = ( ( (BlockSize/1000*multiplier) - BlockBalance)*(1000 - ( feeFrac + RewardFrac ))/1000) / 1 finney;
159     info ='This amount in finney in finney required to complete the current block, and to MINE it (trigger the payout).';
160 }
161 function PlayerInfo(uint id) constant returns(address Address, uint Payout, bool UserPaid) {
162     if (id <= miners.length) {
163         Address = miners[id].addr;
164         Payout = (miners[id].payout) / 1 finney;
165         UserPaid=miners[id].paid;
166     }
167 }
168 
169 function WatchCollectedFeesInSzabo() constant returns(uint CollectedFees) {
170     CollectedFees = fees / 1 szabo;
171 }
172 
173 function NumberOfCurrentBlockMiners() constant returns(uint QueueSize, string info) {
174     QueueSize = miners.length - Payout_id;
175     info ='Number of participations in the current block.';
176 }
177 
178 
179 }