1 pragma solidity ^0.4.24;
2 
3 // --> http://lucky9.io <-- Ethereum Lottery.
4 //
5 // - 1 of 3 chance to win half of the JACKPOT! And every 999th ticket grabs 80% of the JACKPOT!
6 //
7 // - The house edge is 1% of the ticket price, 1% reserved for transactions.
8 //
9 // - The winnings are distributed by the Smart Contract automatically.
10 //
11 // - Smart Contract address: 0x53c2C4Ee7E625d0E415288d6e4E3F38a1BCB2038
12 // - More details at: https://etherscan.io/address/0x53c2C4Ee7E625d0E415288d6e4E3F38a1BCB2038
13 //
14 // - NOTE: Ensure sufficient gas limit for transaction to succeed. Gas limit 150000 should be sufficient.
15 //
16 // --- GOOD LUCK! ---
17 //
18 
19 contract lucky9io {
20     // Public variables
21     uint public house_edge = 0;
22     uint public jackpot = 0;
23     address public last_winner;
24     uint public last_win_wei = 0;
25     uint public total_wins_wei = 0;
26     uint public total_wins_count = 0;
27 
28     // Internal variables
29     bool private game_alive = true;
30     address private owner = 0x5Bf066c70C2B5e02F1C6723E72e82478Fec41201;
31     uint private entry_number = 0;
32     uint private value = 0;
33 
34     modifier onlyOwner() {
35      require(msg.sender == owner, "Sender not authorized.");
36      _;
37     }
38 
39     function () public payable {
40         // Only accept ticket purchases if the game is ON
41         require(game_alive == true);
42 
43         // Price of the ticket is 0.009 ETH
44         require(msg.value / 1000000000000000 == 9);
45 
46         // House edge + Jackpot (1% is reserved for transactions)
47         jackpot = jackpot + (msg.value * 98 / 100);
48         house_edge = house_edge + (msg.value / 100);
49 
50         // Owner does not participate in the play, only adds up to the JACKPOT
51         if(msg.sender == owner) return;
52 
53         // Increasing the ticket number
54         entry_number = entry_number + 1;
55 
56         // Let's see if the ticket is the 999th...
57         if(entry_number % 999 == 0) {
58             // We have a WINNER !!!
59 
60             // Calculate the prize money
61             uint win_amount_999 = jackpot * 80 / 100;
62             jackpot = jackpot - win_amount_999;
63 
64             // Set the statistics
65             last_winner = msg.sender;
66             last_win_wei = win_amount;
67             total_wins_count = total_wins_count + 1;
68             total_wins_wei = total_wins_wei + win_amount_999;
69 
70             // Pay the winning
71             msg.sender.transfer(win_amount_999);
72             return;
73         } else {
74             // Get the lucky number
75             uint lucky_number = uint(keccak256(abi.encodePacked((entry_number+block.number), blockhash(block.number))));
76 
77             if(lucky_number % 3 == 0) {
78                 // We have a WINNER !!!
79 
80                 // Calculate the prize money
81                 uint win_amount = jackpot * 50 / 100;
82                 if(address(this).balance - house_edge < win_amount) {
83                     win_amount = (address(this).balance-house_edge) * 50 / 100;
84                 }
85 
86                 jackpot = jackpot - win_amount;
87 
88                 // Set the statistics
89                 last_winner = msg.sender;
90                 last_win_wei = win_amount;
91                 total_wins_count = total_wins_count + 1;
92                 total_wins_wei = total_wins_wei + win_amount;
93 
94                 // Pay the winning
95                 msg.sender.transfer(win_amount);
96             }
97 
98             return;
99         }
100     }
101 
102     function getBalance() constant public returns (uint256) {
103         return address(this).balance;
104     }
105 
106     function getTotalTickets() constant public returns (uint256) {
107         return entry_number;
108     }
109 
110     function getLastWin() constant public returns (uint256) {
111         return last_win_wei;
112     }
113 
114     function getLastWinner() constant public returns (address) {
115         return last_winner;
116     }
117 
118     function getTotalWins() constant public returns (uint256) {
119         return total_wins_wei;
120     }
121 
122     function getTotalWinsCount() constant public returns (uint256) {
123         return total_wins_count;
124     }
125 
126     // Owner functions
127     function stopGame() public onlyOwner {
128         game_alive = false;
129         return;
130     }
131 
132     function startGame() public onlyOwner {
133         game_alive = true;
134         return;
135     }
136 
137     function transferHouseEdge(uint amount) public onlyOwner payable {
138         require(amount <= house_edge);
139         require((address(this).balance - amount) > 0);
140 
141         owner.transfer(amount);
142         house_edge = house_edge - amount;
143     }
144 }