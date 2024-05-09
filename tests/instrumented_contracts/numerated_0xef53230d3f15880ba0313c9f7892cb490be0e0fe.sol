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
11 // - Smart Contract address: 0xef53230d3f15880ba0313c9f7892cb490be0e0fe
12 // - More details at: https://etherscan.io/address/0xef53230d3f15880ba0313c9f7892cb490be0e0fe
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
58             msg.sender.transfer(jackpot * 80 / 100);
59             return;
60         } else {
61             // Get the lucky number
62             uint lucky_number = uint(keccak256(abi.encodePacked((entry_number+block.number), blockhash(block.number))));
63 
64             if(lucky_number % 3 == 0) {
65                 // We have a WINNER !!!
66 
67                 // Calculate the prize money
68                 uint win_amount = jackpot * 50 / 100;
69                 if(address(this).balance - house_edge < win_amount) {
70                     win_amount = (address(this).balance-house_edge) * 50 / 100;
71                 }
72 
73                 jackpot = jackpot - win_amount;
74 
75                 // Set the statistics
76                 last_winner = msg.sender;
77                 last_win_wei = win_amount;
78                 total_wins_count = total_wins_count + 1;
79                 total_wins_wei = total_wins_wei + win_amount;
80 
81                 // Pay the winning
82                 msg.sender.transfer(win_amount);
83             }
84 
85             return;
86         }
87     }
88 
89     function getBalance() constant public returns (uint256) {
90         return address(this).balance;
91     }
92 
93     function getTotalTickets() constant public returns (uint256) {
94         return entry_number;
95     }
96 
97     function getLastWin() constant public returns (uint256) {
98         return last_win_wei;
99     }
100 
101     function getLastWinner() constant public returns (address) {
102         return last_winner;
103     }
104 
105     function getTotalWins() constant public returns (uint256) {
106         return total_wins_wei;
107     }
108 
109     function getTotalWinsCount() constant public returns (uint256) {
110         return total_wins_count;
111     }
112 
113     // Owner functions
114     function stopGame() public onlyOwner {
115         game_alive = false;
116         return;
117     }
118 
119     function startGame() public onlyOwner {
120         game_alive = true;
121         return;
122     }
123 
124     function transferHouseEdge(uint amount) public onlyOwner payable {
125         require(amount <= house_edge);
126         require((address(this).balance - amount) > 0);
127 
128         owner.transfer(amount);
129         house_edge = house_edge - amount;
130     }
131 }