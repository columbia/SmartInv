1 contract TheGame {
2     // Based on the open source castle script
3     // Definte the guy player
4     address public first_player;
5     // Last time someone contributed to the game
6     uint public regeneration;
7     // Define jackpot
8     uint public jackpot;
9 
10     // Fees
11     uint public collectedFee;
12 
13     // List of players who contributed
14     address[] public playersAddresses;
15     uint[] public playersAmounts;
16     uint32 public totalplayers;
17     uint32 public lastPlayerPaid;
18     // main Player who made the system work
19     address public mainPlayer;
20     // How many times the game stopped
21     uint32 public round;
22     // ETH paid in this round
23     uint public amountAlreadyPaidBack;
24     // ETH invested in this round
25     uint public amountInvested;
26 
27     uint constant SIX_HOURS = 60 * 60 * 6;
28 
29     function TheGame() {
30         // First game
31         mainPlayer = msg.sender;
32         first_player = msg.sender;
33         regeneration = block.timestamp;
34         amountAlreadyPaidBack = 0;
35         amountInvested = 0;
36         totalplayers = 0;
37     }
38 
39     function contribute_toTheGame() returns(bool) {
40         uint amount = msg.value;
41         // Check if the minimum amount if reached
42         if (amount < 1 / 2 ether) {
43             msg.sender.send(msg.value);
44             return false;
45         }
46         // If the player sends more than 25 ETH it is returned to him
47         if (amount > 25 ether) {
48             msg.sender.send(msg.value - 25 ether);
49             amount = 25 ether;
50         }
51 
52         // Check if the game is still on
53         if (regeneration + SIX_HOURS < block.timestamp) {
54             // Send the jacpot to the last 3 players
55             // If noone send ETH in the last 6 hours nothing happens
56             if (totalplayers == 1) {
57                 // If only one person sent ETH in the last 6 hours he gets 100% of the jacpot
58                 playersAddresses[playersAddresses.length - 1].send(jackpot);
59             } else if (totalplayers == 2) {
60                 // If two players sent ETH the jacpot is split between them
61                 playersAddresses[playersAddresses.length - 1].send(jackpot * 70 / 100);
62                 playersAddresses[playersAddresses.length - 2].send(jackpot * 30 / 100);
63             } else if (totalplayers >= 3) {
64                 // If there is 3 or more players
65                 playersAddresses[playersAddresses.length - 1].send(jackpot * 70 / 100);
66                 playersAddresses[playersAddresses.length - 2].send(jackpot * 20 / 100);
67                 playersAddresses[playersAddresses.length - 3].send(jackpot * 10 / 100);
68             }
69 
70             // Creation of new jackpot
71             jackpot = 0;
72 
73             // Creation of new round of the game
74             first_player = msg.sender;
75             regeneration = block.timestamp;
76             playersAddresses.push(msg.sender);
77             playersAmounts.push(amount * 2);
78             totalplayers += 1;
79             amountInvested += amount;
80 
81             // ETH sent to the jackpot
82             jackpot += amount;
83 
84             // The player takes 3%
85             first_player.send(amount * 3 / 100);
86 
87             // The Player takes 3%
88             collectedFee += amount * 3 / 100;
89 
90             round += 1;
91         } else {
92             // The game is still on
93             regeneration = block.timestamp;
94             playersAddresses.push(msg.sender);
95             playersAmounts.push(amount * 2);
96             totalplayers += 1;
97             amountInvested += amount;
98 
99             // 5% goes to the jackpot
100             jackpot += (amount * 5 / 100);
101 
102             // The player takes 3%
103             first_player.send(amount * 3 / 100);
104 
105             // The player takes 3%
106             collectedFee += amount * 3 / 100;
107 
108 while (playersAmounts[lastPlayerPaid] < (address(this).balance - jackpot - collectedFee) && lastPlayerPaid <= totalplayers) {
109                 playersAddresses[lastPlayerPaid].send(playersAmounts[lastPlayerPaid]);
110                 amountAlreadyPaidBack += playersAmounts[lastPlayerPaid];
111                 lastPlayerPaid += 1;
112             }
113         }
114     }
115 
116     // fallback function
117     function() {
118         contribute_toTheGame();
119     }
120 
121     // When the game stops
122     function restart() {
123         if (msg.sender == mainPlayer) {
124             mainPlayer.send(address(this).balance);
125             selfdestruct(mainPlayer);
126         }
127     }
128 
129     // When the main player wants to transfer his function
130     function new_mainPlayer(address new_mainPlayer) {
131         if (msg.sender == mainPlayer) {
132             mainPlayer = new_mainPlayer;
133         }
134     }
135 
136     // When the main Player decides to collect his fees
137     function collectFee() {
138         if (msg.sender == mainPlayer) {
139             mainPlayer.send(collectedFee);
140         }
141     }
142 
143     // When the guy players wants to transfer his function
144     function newfirst_player(address newfirst_player) {
145         if (msg.sender == first_player) {
146             first_player = newfirst_player;
147         }
148     }       
149 }