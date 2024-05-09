1 contract Rubixi {
2 
3         //Declare variables for storage critical to contract
4         uint private balance = 0;
5         uint private collectedFees = 0;
6         uint private feePercent = 10;
7         uint private pyramidMultiplier = 300;
8         uint private payoutOrder = 0;
9 
10         address private creator;
11 
12         //Sets creator
13         function DynamicPyramid() {
14                 creator = msg.sender;
15         }
16 
17         modifier onlyowner {
18                 if (msg.sender == creator) _
19         }
20 
21         struct Participant {
22                 address etherAddress;
23                 uint payout;
24         }
25 
26         Participant[] private participants;
27 
28         //Fallback function
29         function() {
30                 init();
31         }
32 
33         //init function run on fallback
34         function init() private {
35                 //Ensures only tx with value of 1 ether or greater are processed and added to pyramid
36                 if (msg.value < 1 ether) {
37                         collectedFees += msg.value;
38                         return;
39                 }
40 
41                 uint _fee = feePercent;
42                 //50% fee rebate on any ether value of 50 or greater
43                 if (msg.value >= 50 ether) _fee /= 2;
44 
45                 addPayout(_fee);
46         }
47 
48         //Function called for valid tx to the contract 
49         function addPayout(uint _fee) private {
50                 //Adds new address to participant array
51                 participants.push(Participant(msg.sender, (msg.value * pyramidMultiplier) / 100));
52 
53                 //These statements ensure a quicker payout system to later pyramid entrants, so the pyramid has a longer lifespan
54                 if (participants.length == 10) pyramidMultiplier = 200;
55                 else if (participants.length == 25) pyramidMultiplier = 150;
56 
57                 // collect fees and update contract balance
58                 balance += (msg.value * (100 - _fee)) / 100;
59                 collectedFees += (msg.value * _fee) / 100;
60 
61                 //Pays earlier participiants if balance sufficient
62                 while (balance > participants[payoutOrder].payout) {
63                         uint payoutToSend = participants[payoutOrder].payout;
64                         participants[payoutOrder].etherAddress.send(payoutToSend);
65 
66                         balance -= participants[payoutOrder].payout;
67                         payoutOrder += 1;
68                 }
69         }
70 
71         //Fee functions for creator
72         function collectAllFees() onlyowner {
73                 if (collectedFees == 0) throw;
74 
75                 creator.send(collectedFees);
76                 collectedFees = 0;
77         }
78 
79         function collectFeesInEther(uint _amt) onlyowner {
80                 _amt *= 1 ether;
81                 if (_amt > collectedFees) collectAllFees();
82 
83                 if (collectedFees == 0) throw;
84 
85                 creator.send(_amt);
86                 collectedFees -= _amt;
87         }
88 
89         function collectPercentOfFees(uint _pcent) onlyowner {
90                 if (collectedFees == 0 || _pcent > 100) throw;
91 
92                 uint feesToCollect = collectedFees / 100 * _pcent;
93                 creator.send(feesToCollect);
94                 collectedFees -= feesToCollect;
95         }
96 
97         //Functions for changing variables related to the contract
98         function changeOwner(address _owner) onlyowner {
99                 creator = _owner;
100         }
101 
102         function changeMultiplier(uint _mult) onlyowner {
103                 if (_mult > 300 || _mult < 120) throw;
104 
105                 pyramidMultiplier = _mult;
106         }
107 
108         function changeFeePercentage(uint _fee) onlyowner {
109                 if (_fee > 10) throw;
110 
111                 feePercent = _fee;
112         }
113 
114         //Functions to provide information to end-user using JSON interface or other interfaces
115         function currentMultiplier() constant returns(uint multiplier, string info) {
116                 multiplier = pyramidMultiplier;
117                 info = 'This multiplier applies to you as soon as transaction is received, may be lowered to hasten payouts or increased if payouts are fast enough. Due to no float or decimals, multiplier is x100 for a fractional multiplier e.g. 250 is actually a 2.5x multiplier. Capped at 3x max and 1.2x min.';
118         }
119 
120         function currentFeePercentage() constant returns(uint fee, string info) {
121                 fee = feePercent;
122                 info = 'Shown in % form. Fee is halved(50%) for amounts equal or greater than 50 ethers. (Fee may change, but is capped to a maximum of 10%)';
123         }
124 
125         function currentPyramidBalanceApproximately() constant returns(uint pyramidBalance, string info) {
126                 pyramidBalance = balance / 1 ether;
127                 info = 'All balance values are measured in Ethers, note that due to no decimal placing, these values show up as integers only, within the contract itself you will get the exact decimal value you are supposed to';
128         }
129 
130         function nextPayoutWhenPyramidBalanceTotalsApproximately() constant returns(uint balancePayout) {
131                 balancePayout = participants[payoutOrder].payout / 1 ether;
132         }
133 
134         function feesSeperateFromBalanceApproximately() constant returns(uint fees) {
135                 fees = collectedFees / 1 ether;
136         }
137 
138         function totalParticipants() constant returns(uint count) {
139                 count = participants.length;
140         }
141 
142         function numberOfParticipantsWaitingForPayout() constant returns(uint count) {
143                 count = participants.length - payoutOrder;
144         }
145 
146         function participantDetails(uint orderInPyramid) constant returns(address Address, uint Payout) {
147                 if (orderInPyramid <= participants.length) {
148                         Address = participants[orderInPyramid].etherAddress;
149                         Payout = participants[orderInPyramid].payout / 1 ether;
150                 }
151         }
152 }