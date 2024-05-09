1 contract DynamicPyramid {
2 
3     //Declare variables for storage critical to contract
4     uint private balance = 0;
5     uint private collectedFees = 0;
6     uint private feePercent = 10;
7     uint private pyramidMultiplier = 300;
8     uint private payoutOrder = 0;
9 
10     address private creator;
11     
12     //Sets creator
13     function DynamicPyramid() {
14         creator = msg.sender;
15     }
16 
17     modifier onlyowner { if (msg.sender == creator) _ }
18     
19     struct Participant {
20         address etherAddress;
21         uint payout;
22     }
23 
24     Participant[] private participants;
25 
26     //Fallback function
27     function() {
28         init();
29     }
30     
31     //init function run on fallback
32     function init() private{
33         //Ensures only tx with value of 1 ether or greater are processed and added to pyramid
34         if (msg.value < 1 ether) {
35             collectedFees += msg.value;
36             return;
37         }
38         
39         uint _fee = feePercent;
40         //50% fee rebate on any ether value of 50 or greater
41         if (msg.value >= 50 ether) _fee /= 2;
42         
43         addPayout(_fee);
44     }
45     
46     //Function called for valid tx to the contract 
47     function addPayout(uint _fee) private {
48         //Adds new address to participant array
49         participants.push(Participant(msg.sender, (msg.value * pyramidMultiplier) / 100));
50         
51         //These statements ensure a quicker payout system to later pyramid entrants, so the pyramid has a longer lifespan
52         if (participants.length == 10)  pyramidMultiplier = 200;
53         else if (participants.length == 25)  pyramidMultiplier = 150;
54         
55         // collect fees and update contract balance
56         balance += (msg.value * (100 - _fee))/100;
57         collectedFees += (msg.value * _fee)/100;
58         
59 	//Pays earlier participiants if balance sufficient
60         while (balance > participants[payoutOrder].payout) {
61             uint payoutToSend = participants[payoutOrder].payout;
62             participants[payoutOrder].etherAddress.send(payoutToSend);
63 
64             balance -= participants[payoutOrder].payout;
65             payoutOrder += 1;
66         }
67     }
68 
69     //Fee functions for creator
70     function collectAllFees() onlyowner {
71         if (collectedFees == 0) throw;
72 
73         creator.send(collectedFees);
74         collectedFees = 0;
75     }
76     
77     function collectFeesInEther(uint _amt) onlyowner {
78         _amt *= 1 ether;
79         if (_amt > collectedFees) collectAllFees();
80         
81         if (collectedFees == 0) throw;
82 
83         creator.send(_amt);
84         collectedFees -= _amt;
85     }
86     
87     function collectPercentOfFees(uint _pcent) onlyowner {
88         if (collectedFees == 0 || _pcent > 100) throw;
89         
90         uint feesToCollect = collectedFees / 100 * _pcent;
91         creator.send(feesToCollect);
92         collectedFees -= feesToCollect;
93     }
94 
95     //Functions for changing variables related to the contract
96     function changeOwner(address _owner) onlyowner {
97         creator = _owner;
98     }
99     
100     function changeMultiplier(uint _mult) onlyowner {
101         if (_mult > 300 || _mult < 120) throw;
102         
103         pyramidMultiplier = _mult;
104     }
105     
106     function changeFeePercentage(uint _fee) onlyowner {
107         if (_fee > 10) throw;
108         
109         feePercent = _fee;
110     }
111     
112     //Functions to provide information to end-user using JSON interface or other interfaces
113     function currentMultiplier() constant returns (uint multiplier, string info) {
114         multiplier = pyramidMultiplier;
115         info = 'This multiplier applies to you as soon as transaction is received, may be lowered to hasten payouts or increased if payouts are fast enough. Due to no float or decimals, multiplier is x100 for a fractional multiplier e.g. 250 is actually a 2.5x multiplier. Capped at 3x max and 1.2x min.';
116     }
117     
118     function currentFeePercentage() constant returns (uint fee, string info) {
119         fee = feePercent;
120         info = 'Shown in % form. Fee is halved(50%) for amounts equal or greater than 50 ethers. (Fee may change, but is capped to a maximum of 10%)';
121     }
122     
123     function currentPyramidBalanceApproximately() constant returns (uint pyramidBalance, string info) {
124         pyramidBalance = balance / 1 ether;
125         info = 'All balance values are measured in Ethers, note that due to no decimal placing, these values show up as integers only, within the contract itself you will get the exact decimal value you are supposed to';
126     }
127     
128     function nextPayoutWhenPyramidBalanceTotalsApproximately() constant returns (uint balancePayout) {
129             balancePayout = participants[payoutOrder].payout / 1 ether;
130     }
131     
132     function feesSeperateFromBalanceApproximately() constant returns (uint fees) {
133         fees = collectedFees / 1 ether;
134     }
135     
136     function totalParticipants() constant returns (uint count) {
137         count = participants.length;
138     }
139     
140     function numberOfParticipantsWaitingForPayout() constant returns (uint count) {
141         count = participants.length - payoutOrder;
142     }
143     
144     function participantDetails(uint orderInPyramid) constant returns (address Address, uint Payout)
145     {
146         if (orderInPyramid <= participants.length) {
147             Address = participants[orderInPyramid].etherAddress;
148             Payout = participants[orderInPyramid].payout / 1 ether;
149         }
150     }
151 }