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
11 // - Smart Contract address: 0x2d7765c44e44b9ec01d30ea367e8403aa4415cb3
12 // - More details at: https://etherscan.io/address/0x2d7765c44e44b9ec01d30ea367e8403aa4415cb3
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
43         // No contract calls
44         require(isContract(msg.sender) != true);
45 
46         // Price of the ticket is 0.009 ETH
47         require(msg.value / 1000000000000000 == 9);
48 
49         // House edge + Jackpot (1% is reserved for transactions)
50         jackpot = jackpot + (msg.value * 98 / 100);
51         house_edge = house_edge + (msg.value / 100);
52 
53         // Owner does not participate in the play, only adds up to the JACKPOT
54         if(msg.sender == owner) return;
55 
56         // Increasing the ticket number
57         entry_number = entry_number + 1;
58 
59         // Let's see if the ticket is the 999th...
60         if(entry_number % 999 == 0) {
61             // We have a WINNER !!!
62 
63             // Calculate the prize money
64             uint win_amount_999 = jackpot * 80 / 100;
65             jackpot = jackpot - win_amount_999;
66 
67             // Set the statistics
68             last_winner = msg.sender;
69             last_win_wei = win_amount;
70             total_wins_count = total_wins_count + 1;
71             total_wins_wei = total_wins_wei + win_amount_999;
72 
73             // Pay the winning
74             msg.sender.transfer(win_amount_999);
75             return;
76         } else {
77             // Get the lucky number
78             uint lucky_number = uint(keccak256(abi.encodePacked((entry_number+block.number), blockhash(block.number))));
79 
80             if(lucky_number % 3 == 0) {
81                 // We have a WINNER !!!
82 
83                 // Calculate the prize money
84                 uint win_amount = jackpot * 50 / 100;
85                 if(address(this).balance - house_edge < win_amount) {
86                     win_amount = (address(this).balance-house_edge) * 50 / 100;
87                 }
88 
89                 jackpot = jackpot - win_amount;
90 
91                 // Set the statistics
92                 last_winner = msg.sender;
93                 last_win_wei = win_amount;
94                 total_wins_count = total_wins_count + 1;
95                 total_wins_wei = total_wins_wei + win_amount;
96 
97                 // Pay the winning
98                 msg.sender.transfer(win_amount);
99             }
100 
101             return;
102         }
103     }
104 
105     function isContract(address addr) private view returns (bool) {
106           uint size;
107           assembly {
108               size := extcodesize(addr)
109 
110           }
111           return size > 0;
112     }
113 
114     function getBalance() constant public returns (uint256) {
115         return address(this).balance;
116     }
117 
118     function getTotalTickets() constant public returns (uint256) {
119         return entry_number;
120     }
121 
122     function getLastWin() constant public returns (uint256) {
123         return last_win_wei;
124     }
125 
126     function getLastWinner() constant public returns (address) {
127         return last_winner;
128     }
129 
130     function getTotalWins() constant public returns (uint256) {
131         return total_wins_wei;
132     }
133 
134     function getTotalWinsCount() constant public returns (uint256) {
135         return total_wins_count;
136     }
137 
138     // Owner functions
139     function stopGame() public onlyOwner {
140         game_alive = false;
141         return;
142     }
143 
144     function startGame() public onlyOwner {
145         game_alive = true;
146         return;
147     }
148 
149     function transferHouseEdge(uint amount) public onlyOwner payable {
150         require(amount <= house_edge);
151         require((address(this).balance - amount) > 0);
152 
153         owner.transfer(amount);
154         house_edge = house_edge - amount;
155     }
156 }