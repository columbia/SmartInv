1 pragma solidity ^0.5.0;
2 
3 contract Test {
4     
5     uint8 constant N = 16;
6     
7     struct Bet {
8         uint256 blockNumber;
9         uint256 amount;
10         bytes16 bet;
11         uint128 id;
12         address payable gambler;
13     }
14     
15     struct Payout {
16         uint256 amount;
17         bytes32 blockHash;
18         uint128 id;
19         address payable gambler;
20     }
21     
22     Bet[] betArray;
23     
24     address payable private owner;
25 
26     event Result (
27         uint256 amount,
28         bytes32 blockHash,
29         uint128 indexed id,
30         address payable indexed gambler
31     );
32     
33     uint256 constant MIN_BET = 0.01 ether;
34     uint256 constant MAX_BET = 100 ether;
35     uint256 constant PRECISION = 1 ether;
36     
37     constructor() public payable {
38         owner = msg.sender;
39     }
40     
41     function() external payable { }
42     
43     modifier onlyOwner {
44          require(msg.sender == owner);
45          _;
46      }
47     
48     function placeBet(bytes16 bet, uint128 id) external payable {
49         require(msg.value >= MIN_BET, "Bet amount should be greater or equal than minimal amount");
50         require(msg.value <= MAX_BET, "Bet amount should be lesser or equal than maximal amount");
51         require(id != 0, "Id should not be 0");
52         
53         betArray.push(Bet(block.number, msg.value, bet, id, msg.sender));
54     }
55     
56     function settleBets() external {
57         if (betArray.length == 0)
58             return;
59 
60         Payout[] memory payouts = new Payout[](betArray.length);
61         Bet[] memory missedBets = new Bet[](betArray.length);
62         uint256 totalPayout;
63         uint i = betArray.length;
64         do {
65             i--;
66             if(betArray[i].blockNumber >= block.number)
67                 missedBets[i] = betArray[i];
68             else {
69                 bytes32 blockHash = blockhash(betArray[i].blockNumber);
70                 uint256 coefficient = PRECISION;
71                 uint8 markedCount;
72                 uint8 matchesCount;
73                 uint256 divider = 1;
74                 for (uint8 j = 0; j < N; j++) {
75                     if (betArray[i].bet[j] == 0xFF)
76                         continue;
77                     markedCount++;
78                     byte field;
79                     if (j % 2 == 0)
80                         field = blockHash[24 + j / 2] >> 4;
81                     else
82                         field = blockHash[24 + j / 2] & 0x0F;
83                     if (betArray[i].bet[j] < 0x10) {
84                         if (field == betArray[i].bet[j])
85                             matchesCount++;
86                         else
87                             divider *= 15 + N;
88                         continue;
89                     }
90                     if (betArray[i].bet[j] == 0x10) {
91                         if (field > 0x09 && field < 0x10) {
92                             matchesCount++;
93                             divider *= 6;
94                         } else
95                             divider *= 10 + N;
96                         continue;
97                     }
98                     if (betArray[i].bet[j] == 0x11) {
99                         if (field < 0x0A) {
100                             matchesCount++;
101                             divider *= 10;
102                         } else
103                             divider *= 6 + N;
104                         continue;
105                     }
106                     if (betArray[i].bet[j] == 0x12) {
107                         if (field < 0x0A && field & 0x01 == 0x01) {
108                             matchesCount++;
109                             divider *= 5;
110                         } else
111                             divider *= 11 + N;
112                         continue;
113                     }
114                     if (betArray[i].bet[j] == 0x13) {
115                         if (field < 0x0A && field & 0x01 == 0x0) {
116                             matchesCount++;
117                             divider *= 5;
118                         } else
119                             divider *= 11 + N;
120                         continue;
121                     }
122                 }
123             
124                 if (matchesCount == 0)
125                     coefficient = 0;
126                 else {
127                     uint256 missedCount = markedCount - matchesCount;
128                     divider *= missedCount ** missedCount;
129                     coefficient = coefficient * 16**uint256(markedCount) / divider;
130                 }
131                 
132                 uint payoutAmount = betArray[i].amount * coefficient / PRECISION;
133                 if (payoutAmount == 0 && matchesCount > 0)
134                     payoutAmount = matchesCount;
135                 payouts[i] = Payout(payoutAmount, blockHash, betArray[i].id, betArray[i].gambler);
136                 totalPayout += payoutAmount;
137             }
138             betArray.pop();
139         } while (i > 0);
140         
141         i = missedBets.length;
142         do {
143             i--;
144             if (missedBets[i].id != 0)
145                 betArray.push(missedBets[i]);
146         } while (i > 0);
147         
148         uint balance = address(this).balance;
149         for (i = 0; i < payouts.length; i++) {
150             if (payouts[i].id > 0) {
151                 if (totalPayout > balance)
152                     emit Result(balance * payouts[i].amount * PRECISION / totalPayout / PRECISION, payouts[i].blockHash, payouts[i].id, payouts[i].gambler);
153                 else
154                     emit Result(payouts[i].amount, payouts[i].blockHash, payouts[i].id, payouts[i].gambler);
155             }
156         }
157         for (i = 0; i < payouts.length; i++) {
158             if (payouts[i].amount > 0) {
159                 if (totalPayout > balance)
160                     payouts[i].gambler.transfer(balance * payouts[i].amount * PRECISION / totalPayout / PRECISION);
161                 else
162                     payouts[i].gambler.transfer(payouts[i].amount);
163             }
164         }
165     }
166     
167     function withdraw() external onlyOwner {
168         owner.transfer(address(this).balance);
169     }
170 }