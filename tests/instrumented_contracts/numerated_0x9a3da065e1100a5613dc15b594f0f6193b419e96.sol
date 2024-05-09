1 pragma solidity ^0.4.0;
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
13         address blockCoinbase,
14         address txOrigin,
15         uint remainingGas,
16         bytes32 sha
17     );
18 
19     event TicketPurchase(
20         uint indexed raffleId,
21         address contestant,
22         uint number
23     );
24 
25     event TicketRefund(
26         uint indexed raffleId,
27         address contestant,
28         uint number
29     );
30 
31     // Constants
32     address public rakeAddress;
33     uint constant public prize = 0.1 ether;
34     uint constant public rake = 0.02 ether;
35     uint constant public totalTickets = 6;
36     uint constant public pricePerTicket = (prize + rake) / totalTickets;
37 
38     // Other internal variables
39     uint public raffleId = 1;
40     uint public nextTicket = 1;
41     mapping (uint => Contestant) public contestants;
42     uint[] public gaps;
43     bool public paused = false;
44 
45     // Initialization
46     function Ethraffle() public {
47         rakeAddress = msg.sender;
48     }
49 
50     // Call buyTickets() when receiving Ether outside a function
51     function () payable public {
52         buyTickets();
53     }
54 
55     function buyTickets() payable public {
56         if (paused) {
57             msg.sender.transfer(msg.value);
58             return;
59         }
60 
61         uint moneySent = msg.value;
62 
63         while (moneySent >= pricePerTicket && nextTicket <= totalTickets) {
64             uint currTicket = 0;
65             if (gaps.length > 0) {
66                 currTicket = gaps[gaps.length-1];
67                 gaps.length--;
68             } else {
69                 currTicket = nextTicket++;
70             }
71 
72             contestants[currTicket] = Contestant(msg.sender, raffleId);
73             TicketPurchase(raffleId, msg.sender, currTicket);
74             moneySent -= pricePerTicket;
75         }
76 
77         // Choose winner if we sold all the tickets
78         if (nextTicket > totalTickets) {
79             chooseWinner();
80         }
81 
82         // Send back leftover money
83         if (moneySent > 0) {
84             msg.sender.transfer(moneySent);
85         }
86     }
87 
88     function chooseWinner() private {
89         // Pseudorandom number generator
90         uint remainingGas = msg.gas;
91         bytes32 sha = sha3(
92             block.coinbase,
93             tx.origin,
94             remainingGas
95         );
96 
97         uint winningNumber = (uint(sha) % totalTickets) + 1;
98         address winningAddress = contestants[winningNumber].addr;
99         RaffleResult(
100             raffleId,
101             winningNumber,
102             winningAddress,
103             block.coinbase,
104             tx.origin,
105             remainingGas,
106             sha
107         );
108 
109         // Start next raffle and distribute prize
110         raffleId++;
111         nextTicket = 1;
112         winningAddress.transfer(prize);
113         rakeAddress.transfer(rake);
114     }
115 
116     // Get your money back before the raffle occurs
117     function getRefund() public {
118         uint refunds = 0;
119         for (uint i = 1; i <= totalTickets; i++) {
120             if (msg.sender == contestants[i].addr && raffleId == contestants[i].raffleId) {
121                 refunds++;
122                 contestants[i] = Contestant(address(0), 0);
123                 gaps.push(i);
124                 TicketRefund(raffleId, msg.sender, i);
125             }
126         }
127 
128         if (refunds > 0) {
129             msg.sender.transfer(refunds * pricePerTicket);
130         }
131     }
132 
133     // Refund everyone's money, start a new raffle, then pause it
134     function endRaffle() public {
135         if (msg.sender == rakeAddress) {
136             paused = true;
137 
138             for (uint i = 1; i <= totalTickets; i++) {
139                 if (raffleId == contestants[i].raffleId) {
140                     TicketRefund(raffleId, contestants[i].addr, i);
141                     contestants[i].addr.transfer(pricePerTicket);
142                 }
143             }
144 
145             RaffleResult(raffleId, 0, address(0), address(0), address(0), 0, 0);
146             raffleId++;
147             nextTicket = 1;
148             gaps.length = 0;
149         }
150     }
151 
152     function togglePause() public {
153         if (msg.sender == rakeAddress) {
154             paused = !paused;
155         }
156     }
157 
158     function kill() public {
159         if (msg.sender == rakeAddress) {
160             selfdestruct(rakeAddress);
161         }
162     }
163 }