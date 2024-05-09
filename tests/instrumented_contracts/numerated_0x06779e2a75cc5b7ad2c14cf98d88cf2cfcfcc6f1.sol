1 pragma solidity ^0.4.24;
2 
3 // --> http://lucky9.io <-- Ethereum Lottery.
4 //
5 // - 1 of 3 chance to win a portion of the JACKPOT! Winners are selected and payouts made every day @ 18:00 GMT.
6 //
7 // - The winnings are calculated on FIFO basis - first purchased winning tickets receive the biggest stake, while
8 //   the last - smallest. Therefore, be quick to buy the tickets for the day.
9 //
10 // - 85% of the ticket price goes to current JACKPOT of the day.
11 // - The house edge is 15% of the ticket price. This includes the transactions and pay-out costs.
12 //
13 // - Smart Contract address: 0x06779e2a75cc5b7ad2c14cf98d88cf2cfcfcc6f1
14 // - More details at: https://etherscan.io/address/0x06779e2a75cc5b7ad2c14cf98d88cf2cfcfcc6f1
15 //
16 // - NOTE: Ensure sufficient gas limit for transaction to succeed. Gas limit 200,000 should be sufficient.
17 //
18 // --- GOOD LUCK! ---
19 //
20 
21 contract lucky9io {
22     // Public variables
23     uint public house_edge = 0;
24     uint public jackpot = 0;
25     uint public total_wins_wei = 0;
26     uint public total_wins_count = 0;
27     uint public total_tickets = 0;
28 
29     // Internal variables
30     bool private game_alive = true;
31     address private owner = 0x5Bf066c70C2B5e02F1C6723E72e82478Fec41201;
32     address[] private entries_addresses;
33     bytes32[] private entries_blockhash;
34     uint private entries_count = 0;
35 
36     modifier onlyOwner() {
37      require(msg.sender == owner, "Sender not authorized.");
38      _;
39     }
40 
41     function () public payable {
42         // Only accept ticket purchases if the game is ON
43         require(game_alive == true);
44 
45         // Price of the ticket is 0.009 ETH
46         require(msg.value / 1000000000000000 == 9);
47 
48         // House edge (15%) + Jackpot (85%)
49         jackpot = jackpot + (msg.value * 85 / 100);
50         house_edge = house_edge + (msg.value * 15 / 100);
51 
52         // Owner does not participate in the play, only adds up to the JACKPOT
53         if(msg.sender == owner) return;
54 
55         // Add the ticket entry to the daily game
56         if(entries_count >= entries_addresses.length) {
57             entries_addresses.push(msg.sender);
58             entries_blockhash.push(blockhash(block.number));
59         } else {
60             entries_addresses[entries_count] = msg.sender;
61             entries_blockhash[entries_count] = blockhash(block.number);
62         }
63         entries_count++;
64         total_tickets++;
65 
66         return;
67     }
68 
69     function pickWinners(uint random_seed) payable public onlyOwner {
70         require(entries_count > 0);
71 
72         for (uint i=0; i<entries_count; i++) {
73             uint lucky_number = uint(keccak256(abi.encodePacked(abi.encodePacked(i+random_seed+uint(entries_addresses[i]), blockhash(block.number)), entries_blockhash[i])));
74 
75             if(((lucky_number % 99) % 9) % 3 == 1) {
76                 // We have a WINNER !!!
77 
78                 // Calculate the prize money
79                 uint win_amount = jackpot * 30 / 100;
80                 if(address(this).balance - house_edge < win_amount) {
81                     win_amount = (address(this).balance-house_edge) * 30 / 100;
82                 }
83 
84                 jackpot = jackpot - win_amount;
85 
86                 // Set the statistics
87                 total_wins_count = total_wins_count + 1;
88                 total_wins_wei = total_wins_wei + win_amount;
89 
90                 // Pay the winning
91                 entries_addresses[i].transfer(win_amount);
92             }
93         }
94 
95         entries_count = 0;
96         return;
97     }
98 
99     function getBalance() constant public returns (uint256) {
100         return address(this).balance;
101     }
102 
103     // Owner functions
104     function getEntriesCount() view public onlyOwner returns (uint) {
105         return entries_count;
106     }
107 
108     function stopGame() public onlyOwner {
109         game_alive = false;
110         return;
111     }
112 
113     function startGame() public onlyOwner {
114         game_alive = true;
115         return;
116     }
117 
118     function transferHouseEdge(uint amount) public onlyOwner payable {
119         require(amount <= house_edge);
120         require((address(this).balance - amount) > 0);
121 
122         owner.transfer(amount);
123         house_edge = house_edge - amount;
124     }
125 }