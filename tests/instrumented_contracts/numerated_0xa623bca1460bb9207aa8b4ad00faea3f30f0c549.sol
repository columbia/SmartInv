1 contract CSGOBets {
2 
3         struct Bets {
4                 address etherAddress;
5                 uint amount;
6         }
7 
8         Bets[] public voteA;
9         Bets[] public voteB;
10         uint public balanceA = 0; // balance of all bets on teamA
11         uint public balanceB = 0; // balance of all bets on teamB
12         uint8 public house_edge = 6; // percent
13         uint public betLockTime = 0; // block
14         uint public lastTransactionRec = 0; // block
15         address public owner;
16 
17         modifier onlyowner {
18                 if (msg.sender == owner) _
19         }
20 
21         function CSGOBets() {
22                 owner = msg.sender;
23                 lastTransactionRec = block.number;
24         }
25 
26         function() {
27                 enter();
28         }
29 
30         function enter() {
31                 // if less than 0.25 ETH or bet locked return money
32                 // If bet is locked for more than 28 days allow users to return all the money
33                 if (msg.value < 250 finney ||
34                         (block.number >= betLockTime && betLockTime != 0 && block.number < betLockTime + 161280)) {
35                         msg.sender.send(msg.value);
36                         return;
37                 }
38 
39                 uint amount;
40                 // max 100 ETH
41                 if (msg.value > 100 ether) {
42                         msg.sender.send(msg.value - 100 ether);
43                         amount = 100 ether;
44                 } else {
45                         amount = msg.value;
46                 }
47 
48                 if (lastTransactionRec + 161280 < block.number) { // 28 days after last transaction
49                         returnAll();
50                         betLockTime = block.number;
51                         lastTransactionRec = block.number;
52                         msg.sender.send(msg.value);
53                         return;
54                 }
55                 lastTransactionRec = block.number;
56 
57                 uint cidx;
58                 //vote with finney (even = team A, odd = team B)
59                 if ((amount / 1000000000000000) % 2 == 0) {
60                         balanceA += amount;
61                         cidx = voteA.length;
62                         voteA.length += 1;
63                         voteA[cidx].etherAddress = msg.sender;
64                         voteA[cidx].amount = amount;
65                 } else {
66                         balanceB += amount;
67                         cidx = voteB.length;
68                         voteB.length += 1;
69                         voteB[cidx].etherAddress = msg.sender;
70                         voteB[cidx].amount = amount;
71                 }
72         }
73 
74         // no further ether will be accepted (fe match is now live)
75         function lockBet(uint blocknumber) onlyowner {
76                 betLockTime = blocknumber;
77         }
78 
79         // init payout
80         function payout(uint winner) onlyowner {
81                 var winPot = (winner == 0) ? balanceA : balanceB;
82                 var losePot_ = (winner == 0) ? balanceB : balanceA;
83                 uint losePot = losePot_ * (100 - house_edge) / 100; // substract housecut
84                 uint collectedFees = losePot_ * house_edge / 100;
85                 var winners = (winner == 0) ? voteA : voteB;
86                 for (uint idx = 0; idx < winners.length; idx += 1) {
87                         uint winAmount = winners[idx].amount + (winners[idx].amount * losePot / winPot);
88                         winners[idx].etherAddress.send(winAmount);
89                 }
90 
91                 // pay housecut & reset for next bet
92                 if (collectedFees != 0) {
93                         owner.send(collectedFees);
94                 }
95                 clear();
96         }
97 
98         // basically private (only called if last transaction was 4 weeks ago)
99         // If a match is fixed or a party cheated, I will return all transactions manually.
100         function returnAll() onlyowner {
101                 for (uint idx = 0; idx < voteA.length; idx += 1) {
102                         voteA[idx].etherAddress.send(voteA[idx].amount);
103                 }
104                 for (uint idxB = 0; idxB < voteB.length; idxB += 1) {
105                         voteB[idxB].etherAddress.send(voteB[idxB].amount);
106                 }
107                 clear();
108         }
109 
110         function clear() private {
111                 balanceA = 0;
112                 balanceB = 0;
113                 betLockTime = 0;
114                 lastTransactionRec = block.number;
115                 delete voteA;
116                 delete voteB;
117         }
118 
119         function changeHouseedge(uint8 cut) onlyowner {
120                 // houseedge boundaries
121                 if (cut <= 20 && cut > 0)
122                         house_edge = cut;
123         }
124 
125         function setOwner(address _owner) onlyowner {
126                 owner = _owner;
127         }
128 
129 }