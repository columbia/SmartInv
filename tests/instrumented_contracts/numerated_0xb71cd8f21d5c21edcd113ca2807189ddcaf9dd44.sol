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
80         // Equation expects pot to be in Ether
81         uint potEther = pot/1000000000000000000;
82         uint blocksRemaining = (potEther ** 2)/2 - 8*potEther + 37;
83         if (blocksRemaining < 6) {
84             blocksRemaining = 3;
85         }
86 
87         lastBlock = block.number + blocksRemaining;
88 
89         NewKoth(gameId, betId, koth, highestBet, pot, lastBlock, minBet, maxBet);
90     }
91 
92     function resetKoth() private {
93         gameId++;
94         highestBet = 0;
95         koth = address(0);
96         pot = minPot;
97         lastBlock = 0;
98         betId = 0;
99         firstBlock = block.number;
100     }
101 
102     // Called to reward current KOTH winner and start new game
103     function rewardKoth() public {
104         if (msg.sender == feeAddress && lastBlock > 0 && block.number > lastBlock) {
105             uint fee = pot / 20; // 5%
106             KothWin(gameId, betId, koth, highestBet, pot, fee, firstBlock, lastBlock);
107 
108             uint netPot = pot - fee;
109             address winner = koth;
110             resetKoth();
111             winner.transfer(netPot);
112 
113             // Make sure we never go below minPot
114             if (this.balance - fee >= minPot) {
115                 feeAddress.transfer(fee);
116             }
117         }
118     }
119 
120     function addFunds() payable public {
121         if (msg.sender != feeAddress) {
122             msg.sender.transfer(msg.value);
123         }
124     }
125 
126     function kill() public {
127         if (msg.sender == feeAddress) {
128             selfdestruct(feeAddress);
129         }
130     }
131 }