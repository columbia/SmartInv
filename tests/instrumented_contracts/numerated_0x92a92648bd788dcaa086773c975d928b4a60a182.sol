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
81         uint blocksRemaining = uint( 10 ** ((64-5*pot/1000000000000000000) / 40) );
82         if (blocksRemaining < 3) {
83             blocksRemaining = 3;
84         }
85 
86         lastBlock = block.number + blocksRemaining;
87 
88         NewKoth(gameId, betId, koth, highestBet, pot, lastBlock, minBet, maxBet);
89     }
90 
91     function resetKoth() private {
92         gameId++;
93         highestBet = 0;
94         koth = address(0);
95         pot = minPot;
96         lastBlock = 0;
97         betId = 0;
98         firstBlock = block.number;
99     }
100 
101     // Called to reward current KOTH winner and start new game
102     function rewardKoth() public {
103         if (msg.sender == feeAddress && lastBlock > 0 && block.number > lastBlock) {
104             uint fee = pot / 20; // 5%
105             KothWin(gameId, betId, koth, highestBet, pot, fee, firstBlock, lastBlock);
106 
107             uint netPot = pot - fee;
108             address winner = koth;
109             resetKoth();
110             winner.transfer(netPot);
111 
112             // Make sure we never go below minPot
113             if (this.balance - fee >= minPot) {
114                 feeAddress.transfer(fee);
115             }
116         }
117     }
118 
119     function addFunds() payable public {
120         if (msg.sender != feeAddress) {
121             msg.sender.transfer(msg.value);
122         }
123     }
124 
125     function kill() public {
126         if (msg.sender == feeAddress) {
127             selfdestruct(feeAddress);
128         }
129     }
130 }