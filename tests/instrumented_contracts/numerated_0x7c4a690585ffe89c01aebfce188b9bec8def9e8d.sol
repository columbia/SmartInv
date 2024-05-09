1 contract Honestgamble {
2     
3     //--parameters
4     uint private deposit = 10 ether; //only 10 ETH deposits accepted
5     uint private feeFrac = 10; //1% initially
6     uint constant time_max = 12 * 60 * 60; //12 hours in seconds
7     uint private first_prize = 130;
8     uint private second_prize = 110;
9     uint private third_prize = 60;
10     
11     //--ledger
12     uint private Balance = 0;
13     uint private fees = 0;  
14     uint private Payout_id = 0;
15     uint private number_of_players = 0;
16     
17     uint private last_time ;
18     
19     address private admin;
20     
21     function Honestgamble() {
22         admin = msg.sender;
23         last_time = block.timestamp;
24     }
25 
26     modifier onlyowner {if (msg.sender == admin) _  }
27 
28     struct Player {
29         address addr;
30         uint payout; //filled when round over, just for the stats
31         bool paid;
32     }
33 
34     Player[] private players;
35 
36     //--Fallback function
37     function() {
38         init();
39     }
40 
41     //--initiated function
42     function init() private {
43         //------ Verifications on this new deposit ------
44         if (msg.value < deposit) { 
45             msg.sender.send(msg.value);
46             return;
47         }
48         if(msg.value > deposit){
49             msg.sender.send(msg.value-deposit);
50         }
51         
52         //------ participate ------
53         Balance += (deposit * (1000 - feeFrac )) / 1000; //update balance
54         fees += (deposit * feeFrac) / 1000;          // collect 0.1% fees, thief :p
55 
56     
57         last_time = block.timestamp;
58         players.push(Player(msg.sender,  0 , false));
59         number_of_players++;
60         
61         //-check if end of the round
62         if(number_of_players == 3){ //end of a round
63             Pay();
64         }
65     }
66     
67     function  Pay() private{
68          //---- source of randomness
69         uint256 toss = uint256(sha3(msg.gas)) + uint256(sha3(block.timestamp)); 
70         //indices of players
71         uint i_13;
72         uint i_11;
73         uint i_6;
74         
75         if( toss % 3 == 0 ){
76             i_13=Payout_id;
77             i_11=Payout_id+1;
78             i_6 =Payout_id+2;
79         }
80         else if( toss % 3 == 1){
81             i_13=Payout_id+2;
82             i_11=Payout_id;
83             i_6 =Payout_id+1;
84         }
85         else{
86             i_13=Payout_id+1;
87             i_11=Payout_id+2;
88             i_6 =Payout_id;
89         }
90         uint256 bet=(deposit * (1000 - feeFrac )) / 1000;
91         players[i_13].addr.send(bet*first_prize/100); //gets you 13 ether ! it is good !
92         players[i_11].addr.send(bet*second_prize/100); //gets you 11 ether ! not bad !
93         players[i_6].addr.send(bet*third_prize/100); //gets you 6 ether, it is a loss, sorry !
94         
95         //update stats
96         players[i_13].payout=bet*first_prize/100;
97         players[i_11].payout=bet*second_prize/100;
98         players[i_6].payout=bet*third_prize/100;
99         players[Payout_id].paid=true;
100         players[Payout_id+1].paid=true;
101         players[Payout_id+2].paid=true;
102         Balance=0;
103         number_of_players=0;
104         Payout_id += 3;
105     }
106 
107     
108     function CancelRoundAndRefundAll() { //refund every participants, anyone can call this !
109         if(number_of_players==0) return;
110         
111         if (last_time + time_max < block.timestamp) {
112             for(uint i=Payout_id; i<(Payout_id+number_of_players); i++){
113                 players[i].addr.send((deposit * (1000 - feeFrac )) / 1000 );
114                 players[i].paid=true;
115                 players[i].payout=(deposit * (1000 - feeFrac )) / 1000; //everyone is refunded minus the fee, yeah i am evil.
116             }
117             Payout_id += number_of_players;
118             number_of_players=0;
119         }
120     }
121     
122     //---Contract informations
123     
124     
125     function WatchBalance() constant returns(uint TotalBalance, string info) {
126         TotalBalance = Balance /  1 finney;
127         info ='Balance in finney';
128     }
129     
130     function PlayerInfo(uint id) constant returns(address Address, uint Payout, bool UserPaid) {
131         if (id <= players.length) {
132             Address = players[id].addr;
133             Payout = (players[id].payout) / 1 finney;
134             UserPaid=players[id].paid;
135         }
136     }
137     
138     function WatchLastTime() constant returns(uint LastTimestamp) {
139         LastTimestamp = last_time;
140     }
141 
142     function WatchCollectedFeesInSzabo() constant returns(uint Fees) {
143         Fees = fees / 1 szabo;
144     }
145     
146     function WatchAppliedFeePercentage() constant returns(uint FeePercent) {
147         FeePercent = feeFrac/10;
148     }
149     
150 
151     function WatchNumberOfPlayerInCurrentRound() constant returns(uint N) {
152         N = number_of_players;
153     }
154     //---Contract management functions
155     
156     function ChangeOwnership(address _owner) onlyowner {
157         admin = _owner;
158     }
159     
160     function CollectAllFees() onlyowner {
161         if (fees == 0) throw;
162         admin.send(fees);
163         fees = 0;
164     }
165     
166     function CollectAndReduceFees(uint p) onlyowner {
167         if (fees == 0) feeFrac=feeFrac*50/100; //Reduce fees by half each call !.
168         admin.send(fees / 1000 * p);//send a percent of fees
169         fees -= fees / 1000 * p;
170     }
171 }