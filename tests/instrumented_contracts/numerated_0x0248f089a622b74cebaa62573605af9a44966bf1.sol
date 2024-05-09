1 pragma solidity ^0.4.15;
2 
3 contract Ethraffle {
4     struct Contestant {
5         address addr;
6         uint raffleId;
7     }
8 
9     event RaffleResult(
10         uint indexed raffleId,
11         uint winningNumber,
12         address winningAddress,
13         uint remainingGas,
14         uint gasPrice,
15         bytes32 sha
16     );
17 
18     event TicketPurchase(
19         uint indexed raffleId,
20         address contestant,
21         uint number
22     );
23 
24     event TicketRefund(
25         uint indexed raffleId,
26         address contestant,
27         uint number
28     );
29 
30     // Constants
31     address public rakeAddress;
32     uint constant public prize = 0.1 ether;
33     uint constant public rake = 0.02 ether;
34     uint constant public totalTickets = 6;
35     uint constant public pricePerTicket = (prize + rake) / totalTickets;
36 
37     // Other internal variables
38     uint public raffleId = 1;
39     uint public nextTicket = 1;
40     mapping (uint => Contestant) public contestants;
41     uint[] public gaps;
42     bool public paused = false;
43 
44     // Initialization
45     function Ethraffle() public {
46         rakeAddress = msg.sender;
47     }
48 
49     // Call buyTickets() when receiving Ether outside a function
50     function () payable public {
51         buyTickets();
52     }
53 
54     function buyTickets() payable public {
55         if (paused) {
56             msg.sender.transfer(msg.value);
57             return;
58         }
59 
60         uint moneySent = msg.value;
61 
62         while (moneySent >= pricePerTicket && nextTicket <= totalTickets) {
63             uint currTicket = 0;
64             if (gaps.length > 0) {
65                 currTicket = gaps[gaps.length-1];
66                 gaps.length--;
67             } else {
68                 currTicket = nextTicket++;
69             }
70 
71             contestants[currTicket] = Contestant(msg.sender, raffleId);
72             TicketPurchase(raffleId, msg.sender, currTicket);
73             moneySent -= pricePerTicket;
74         }
75 
76         // Choose winner if we sold all the tickets
77         if (nextTicket > totalTickets) {
78             chooseWinner();
79         }
80 
81         // Send back leftover money
82         if (moneySent > 0) {
83             msg.sender.transfer(moneySent);
84         }
85     }
86 
87     function chooseWinner() private {
88         // Pseudorandom number generator
89         uint remainingGas = msg.gas;
90         uint gasPrice = tx.gasprice;
91 
92         bytes32 sha = sha3(
93             block.coinbase,
94             msg.sender,
95             remainingGas,
96             gasPrice
97         );
98 
99         uint winningNumber = (uint(sha) % totalTickets) + 1;
100         address winningAddress = contestants[winningNumber].addr;
101         RaffleResult(
102             raffleId,
103             winningNumber,
104             winningAddress,
105             remainingGas,
106             gasPrice,
107             sha
108         );
109 
110         // Start next raffle and distribute prize
111         raffleId++;
112         nextTicket = 1;
113         winningAddress.transfer(prize);
114         rakeAddress.transfer(rake);
115     }
116 
117     // Get your money back before the raffle occurs
118     function getRefund() public {
119         uint refunds = 0;
120         for (uint i = 1; i <= totalTickets; i++) {
121             if (msg.sender == contestants[i].addr && raffleId == contestants[i].raffleId) {
122                 refunds++;
123                 contestants[i] = Contestant(address(0), 0);
124                 gaps.push(i);
125                 TicketRefund(raffleId, msg.sender, i);
126             }
127         }
128 
129         if (refunds > 0) {
130             msg.sender.transfer(refunds * pricePerTicket);
131         }
132     }
133 
134     // Refund everyone's money, start a new raffle, then pause it
135     function endRaffle() public {
136         if (msg.sender == rakeAddress) {
137             paused = true;
138 
139             for (uint i = 1; i <= totalTickets; i++) {
140                 if (raffleId == contestants[i].raffleId) {
141                     TicketRefund(raffleId, contestants[i].addr, i);
142                     contestants[i].addr.transfer(pricePerTicket);
143                 }
144             }
145 
146             RaffleResult(raffleId, 0, address(0), 0, 0, 0);
147             raffleId++;
148             nextTicket = 1;
149             gaps.length = 0;
150         }
151     }
152 
153     function togglePause() public {
154         if (msg.sender == rakeAddress) {
155             paused = !paused;
156         }
157     }
158 
159     function kill() public {
160         if (msg.sender == rakeAddress) {
161             selfdestruct(rakeAddress);
162         }
163     }
164 }