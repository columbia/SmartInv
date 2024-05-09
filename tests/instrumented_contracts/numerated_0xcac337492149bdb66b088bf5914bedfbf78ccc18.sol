1 contract theRun {
2         uint private Balance = 0;
3         uint private Payout_id = 0;
4         uint private Last_Payout = 0;
5         uint private WinningPot = 0;
6         uint private Min_multiplier = 1100; //110%
7         
8 
9         //Fees are necessary and set very low, to maintain the website. The fees will decrease each time they are collected.
10         //Fees are just here to maintain the website at beginning, and will progressively go to 0% :)
11         uint private fees = 0;
12         uint private feeFrac = 20; //Fraction for fees in per"thousand", not percent, so 20 is 2%
13         
14         uint private PotFrac = 30; //For the WinningPot ,30=> 3% are collected. This is fixed.
15         
16         
17         address private admin;
18         
19         function theRun() {
20             admin = msg.sender;
21         }
22 
23         modifier onlyowner {if (msg.sender == admin) _  }
24 
25         struct Player {
26             address addr;
27             uint payout;
28             bool paid;
29         }
30 
31         Player[] private players;
32 
33         //--Fallback function
34         function() {
35             init();
36         }
37 
38         //--initiated function
39         function init() private {
40             uint deposit=msg.value;
41             if (msg.value < 500 finney) { //only participation with >1 ether accepted
42                     msg.sender.send(msg.value);
43                     return;
44             }
45             if (msg.value > 20 ether) { //only participation with <20 ether accepted
46                     msg.sender.send(msg.value- (20 ether));
47                     deposit=20 ether;
48             }
49             Participate(deposit);
50         }
51 
52         //------- Core of the game----------
53         function Participate(uint deposit) private {
54                 //calculate the multiplier to apply to the future payout
55                 
56 
57                 uint total_multiplier=Min_multiplier; //initiate total_multiplier
58                 if(Balance < 1 ether && players.length>1){
59                     total_multiplier+=100; // + 10 %
60                 }
61                 if( (players.length % 10)==0 && players.length>1 ){ //Every 10th participant gets a 10% bonus, play smart !
62                     total_multiplier+=100; // + 10 %
63                 }
64                 
65                 //add new player in the queue !
66                 players.push(Player(msg.sender, (deposit * total_multiplier) / 1000, false));
67                 
68                 //--- UPDATING CONTRACT STATS ----
69                 WinningPot += (deposit * PotFrac) / 1000; // take some 3% to add for the winning pot !
70                 fees += (deposit * feeFrac) / 1000; // collect maintenance fees 2%
71                 Balance += (deposit * (1000 - ( feeFrac + PotFrac ))) / 1000; // update balance
72 
73                 // Winning the Pot :) Condition : paying at least 1 people with deposit > 2 ether and having luck !
74                 if(  ( deposit > 1 ether ) && (deposit > players[Payout_id].payout) ){ 
75                     uint roll = random(100); //take a random number between 1 & 100
76                     if( roll % 10 == 0 ){ //if lucky : Chances : 1 out of 10 ! 
77                         msg.sender.send(WinningPot); // Bravo !
78                         WinningPot=0;
79                     }
80                     
81                 }
82                 
83                 //Classic payout for the participants
84                 while ( Balance > players[Payout_id].payout ) {
85                     Last_Payout = players[Payout_id].payout;
86                     players[Payout_id].addr.send(Last_Payout); //pay the man, please !
87                     Balance -= players[Payout_id].payout; //update the balance
88                     players[Payout_id].paid=true;
89                     
90                     Payout_id += 1;
91                 }
92         }
93 
94 
95 
96     uint256 constant private salt =  block.timestamp;
97     
98     function random(uint Max) constant private returns (uint256 result){
99         //get the best seed for randomness
100         uint256 x = salt * 100 / Max;
101         uint256 y = salt * block.number / (salt % 5) ;
102         uint256 seed = block.number/3 + (salt % 300) + Last_Payout +y; 
103         uint256 h = uint256(block.blockhash(seed)); 
104     
105         return uint256((h / x)) % Max + 1; //random number between 1 and Max
106     }
107     
108     
109 
110     //---Contract management functions
111     function ChangeOwnership(address _owner) onlyowner {
112         admin = _owner;
113     }
114     function WatchBalance() constant returns(uint TotalBalance) {
115         TotalBalance = Balance /  1 wei;
116     }
117     
118     function WatchBalanceInEther() constant returns(uint TotalBalanceInEther) {
119         TotalBalanceInEther = Balance /  1 ether;
120     }
121     
122     
123     //Fee functions for creator
124     function CollectAllFees() onlyowner {
125         if (fees == 0) throw;
126         admin.send(fees);
127         feeFrac-=1;
128         fees = 0;
129     }
130     
131     function GetAndReduceFeesByFraction(uint p) onlyowner {
132         if (fees == 0) feeFrac-=1; //Reduce fees.
133         admin.send(fees / 1000 * p);//send a percent of fees
134         fees -= fees / 1000 * p;
135     }
136         
137 
138 //---Contract informations
139 function NextPayout() constant returns(uint NextPayout) {
140     NextPayout = players[Payout_id].payout /  1 wei;
141 }
142 
143 function WatchFees() constant returns(uint CollectedFees) {
144     CollectedFees = fees / 1 wei;
145 }
146 
147 
148 function WatchWinningPot() constant returns(uint WinningPot) {
149     WinningPot = WinningPot / 1 wei;
150 }
151 
152 function WatchLastPayout() constant returns(uint payout) {
153     payout = Last_Payout;
154 }
155 
156 function Total_of_Players() constant returns(uint NumberOfPlayers) {
157     NumberOfPlayers = players.length;
158 }
159 
160 function PlayerInfo(uint id) constant returns(address Address, uint Payout, bool UserPaid) {
161     if (id <= players.length) {
162         Address = players[id].addr;
163         Payout = players[id].payout / 1 wei;
164         UserPaid=players[id].paid;
165     }
166 }
167 
168 function PayoutQueueSize() constant returns(uint QueueSize) {
169     QueueSize = players.length - Payout_id;
170 }
171 
172 
173 }