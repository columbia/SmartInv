1 pragma solidity ^0.4.16;
2 
3 contract koth_v1b {
4     event NewKoth(
5         uint gameId,
6         uint betNumber,
7         address bettor,
8         uint bet,
9         uint pot,
10         uint lastBlock,
11         uint minBet,
12         uint maxBet
13     );
14 
15     event KothWin(
16         uint gameId,
17         uint totalBets,
18         address winner,
19         uint winningBet,
20         uint pot,
21         uint fee,
22         uint firstBlock,
23         uint lastBlock
24     );
25 
26     // Constants
27     uint public constant minPot = 0.001 ether; // Contract needs to be endowed with this amount
28     uint public constant minRaise = 0.001 ether;
29     address feeAddress;
30 
31     // Other internal variables
32     uint public gameId = 0;
33     uint public betId;
34     uint public highestBet;
35     uint public pot;
36     uint public firstBlock;
37     uint public lastBlock;
38     address public koth;
39 
40     // Initialization
41     function koth_v1b() public {
42         feeAddress = msg.sender;
43         resetKoth();
44     }
45 
46     function () payable public {
47         // We're past the block target, but new game hasn't been activated
48         if (lastBlock > 0 && block.number > lastBlock) {
49             msg.sender.transfer(msg.value);
50             return;
51         }
52 
53         // Check for minimum bet (at least minRaise over current highestBet)
54         uint minBet = highestBet + minRaise;
55         if (msg.value < minBet) {
56             msg.sender.transfer(msg.value);
57             return;
58         }
59 
60         // Check for maximum bet
61         uint maxBet;
62         if (pot < 1 ether) {
63             maxBet = 3 * pot;
64         } else {
65             maxBet = 5 * pot / 4;
66         }
67 
68         // Check for maximum bet
69         if (msg.value > maxBet) {
70             msg.sender.transfer(msg.value);
71             return;
72         }
73 
74         // Bet was successful
75         betId++;
76         highestBet = msg.value;
77         koth = msg.sender;
78         pot += highestBet;
79 
80         uint blocksRemaining = uint( 10 ** ((64-5*pot) / 40) );
81         if (blocksRemaining < 3) {
82             blocksRemaining = 3;
83         }
84 
85         lastBlock = block.number + blocksRemaining;
86 
87         NewKoth(gameId, betId, koth, highestBet, pot, lastBlock, minBet, maxBet);
88     }
89 
90     function resetKoth() private {
91         gameId++;
92         highestBet = 0;
93         koth = address(0);
94         pot = minPot;
95         lastBlock = 0;
96         betId = 0;
97         firstBlock = block.number;
98     }
99 
100     // Called to reward current KOTH winner and start new game
101     function rewardKoth() public {
102         if (msg.sender == feeAddress && lastBlock > 0 && block.number > lastBlock) {
103             uint fee = pot / 20; // 5%
104             KothWin(gameId, betId, koth, highestBet, pot, fee, firstBlock, lastBlock);
105 
106             uint netPot = pot - fee;
107             address winner = koth;
108             resetKoth();
109             winner.transfer(netPot);
110 
111             // Make sure we never go below minPot
112             if (this.balance - fee >= minPot) {
113                 feeAddress.transfer(fee);
114             }
115         }
116     }
117 
118     function addFunds() payable public {
119         if (msg.sender != feeAddress) {
120             msg.sender.transfer(msg.value);
121         }
122     }
123 
124     function kill() public {
125         if (msg.sender == feeAddress) {
126             selfdestruct(feeAddress);
127         }
128     }
129 }