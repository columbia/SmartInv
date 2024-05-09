1 pragma solidity ^0.4.16;
2 
3 contract koth_v1b {
4     event NewKoth(
5         uint gameId,
6         uint betNumber,
7         address bettor,
8         uint bet,
9         uint pot,
10         uint lastBlock
11     );
12 
13     event KothWin(
14         uint gameId,
15         uint totalBets,
16         address winner,
17         uint winningBet,
18         uint pot,
19         uint fee,
20         uint firstBlock,
21         uint lastBlock
22     );
23 
24     // Constants
25     uint public constant minPot = 0.001 ether; // Contract needs to be endowed with this amount
26     uint public constant minRaise = 0.001 ether;
27     address feeAddress;
28 
29     // Other internal variables
30     uint public gameId = 0;
31     uint public betId;
32     uint public highestBet;
33     uint public pot;
34     uint public firstBlock;
35     uint public lastBlock;
36     address public koth;
37     uint public minBet;
38     uint public maxBet;
39 
40     // Initialization
41     function koth_v1b() public {
42         feeAddress = msg.sender;
43         resetKoth();
44     }
45 
46     function () payable public {
47         // Current KOTH can't bet over themselves
48         if (msg.sender == koth) {
49             return;
50         }
51 
52         // We're past the block target, but new game hasn't been activated
53         if (lastBlock > 0 && block.number > lastBlock) {
54             msg.sender.transfer(msg.value);
55             return;
56         }
57 
58         // Check for minimum bet (at least minRaise over current highestBet)
59         if (msg.value < minBet) {
60             msg.sender.transfer(msg.value);
61             return;
62         }
63 
64         // Check for maximum bet
65         if (msg.value > maxBet) {
66             msg.sender.transfer(msg.value);
67             return;
68         }
69 
70         // Bet was successful, crown new KOTH
71         betId++;
72         highestBet = msg.value;
73         koth = msg.sender;
74         pot += highestBet;
75 
76         // New bets
77         minBet = highestBet + minRaise;
78         if (pot < 1 ether) {
79             maxBet = 3 * pot;
80         } else {
81             maxBet = 5 * pot / 4;
82         }
83 
84         // Equation expects pot to be in Ether
85         uint potEther = pot/1000000000000000000;
86         uint blocksRemaining = (potEther ** 2)/2 - 8*potEther + 37;
87         if (blocksRemaining < 6) {
88             blocksRemaining = 3;
89         }
90 
91         lastBlock = block.number + blocksRemaining;
92 
93         NewKoth(gameId, betId, koth, highestBet, pot, lastBlock);
94     }
95 
96     function resetKoth() private {
97         gameId++;
98         highestBet = 0;
99         koth = address(0);
100         pot = minPot;
101         lastBlock = 0;
102         betId = 0;
103         firstBlock = block.number;
104         minBet = minRaise;
105         maxBet = 3 * minPot;
106     }
107 
108     // Called to reward current KOTH winner and start new game
109     function rewardKoth() public {
110         if (msg.sender == feeAddress && lastBlock > 0 && block.number > lastBlock) {
111             uint fee = pot / 20; // 5%
112             KothWin(gameId, betId, koth, highestBet, pot, fee, firstBlock, lastBlock);
113 
114             uint netPot = pot - fee;
115             address winner = koth;
116             resetKoth();
117             winner.transfer(netPot);
118 
119             // Make sure we never go below minPot
120             if (this.balance - fee >= minPot) {
121                 feeAddress.transfer(fee);
122             }
123         }
124     }
125 
126     function addFunds() payable public {
127         if (msg.sender != feeAddress) {
128             msg.sender.transfer(msg.value);
129         }
130     }
131 
132     function kill() public {
133         if (msg.sender == feeAddress) {
134             selfdestruct(feeAddress);
135         }
136     }
137 }