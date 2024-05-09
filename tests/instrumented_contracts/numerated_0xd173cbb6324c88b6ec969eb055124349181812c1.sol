1 pragma solidity ^0.4.15;
2 
3 contract Ethraffle {
4     struct Contestant {
5         address addr;
6         uint raffleId;
7         uint remainingGas;
8     }
9 
10     event RaffleResult(
11         uint indexed raffleId,
12         uint winningNumber,
13         address winningAddress
14     );
15 
16     event TicketPurchase(
17         uint indexed raffleId,
18         address contestant,
19         uint number
20     );
21 
22     event TicketRefund(
23         uint indexed raffleId,
24         address contestant,
25         uint number
26     );
27 
28     // Constants
29     address public rakeAddress;
30     uint constant public prize = 0.1 ether;
31     uint constant public rake = 0.02 ether;
32     uint constant public totalTickets = 6;
33     uint constant public pricePerTicket = (prize + rake) / totalTickets;
34 
35     // Other internal variables
36     uint public raffleId = 1;
37     uint public nextTicket = 0;
38     mapping (uint => Contestant) public contestants;
39     uint[] public gaps;
40     bool public paused = false;
41     Contestant randCt1;
42     Contestant randCt2;
43     Contestant randCt3;
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
63         while (moneySent >= pricePerTicket && nextTicket < totalTickets) {
64             uint currTicket = 0;
65             if (gaps.length > 0) {
66                 currTicket = gaps[gaps.length-1];
67                 gaps.length--;
68             } else {
69                 currTicket = nextTicket++;
70             }
71 
72             contestants[currTicket] = Contestant(msg.sender, raffleId, msg.gas);
73             TicketPurchase(raffleId, msg.sender, currTicket);
74             moneySent -= pricePerTicket;
75         }
76 
77         // Choose winner if we sold all the tickets
78         if (nextTicket == totalTickets) {
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
90         randCt1 = contestants[uint(msg.gas) % totalTickets];
91         randCt2 = contestants[uint(block.coinbase) % totalTickets];
92         randCt3 = contestants[(randCt1.remainingGas + randCt2.remainingGas) % totalTickets];
93         bytes32 sha = sha3(randCt1.addr, randCt2.addr, randCt3.addr, randCt3.remainingGas);
94 
95         uint winningNumber = uint(sha) % totalTickets;
96         address winningAddress = contestants[winningNumber].addr;
97         RaffleResult(raffleId, winningNumber, winningAddress);
98 
99         // Start next raffle and distribute prize
100         raffleId++;
101         nextTicket = 0;
102         winningAddress.transfer(prize);
103         rakeAddress.transfer(rake);
104     }
105 
106     // Get your money back before the raffle occurs
107     function getRefund() public {
108         uint refunds = 0;
109         for (uint i = 0; i < totalTickets; i++) {
110             if (msg.sender == contestants[i].addr && raffleId == contestants[i].raffleId) {
111                 refunds++;
112                 contestants[i] = Contestant(address(0), 0, 0);
113                 gaps.push(i);
114                 TicketRefund(raffleId, msg.sender, i);
115             }
116         }
117 
118         if (refunds > 0) {
119             msg.sender.transfer(refunds * pricePerTicket);
120         }
121     }
122 
123     // Refund everyone's money, start a new raffle, then pause it
124     function endRaffle() public {
125         if (msg.sender == rakeAddress) {
126             paused = true;
127 
128             for (uint i = 0; i < totalTickets; i++) {
129                 if (raffleId == contestants[i].raffleId) {
130                     TicketRefund(raffleId, contestants[i].addr, i);
131                     contestants[i].addr.transfer(pricePerTicket);
132                 }
133             }
134 
135             RaffleResult(raffleId, totalTickets + 1, address(0));
136             raffleId++;
137             nextTicket = 0;
138             gaps.length = 0;
139         }
140     }
141 
142     function togglePause() public {
143         if (msg.sender == rakeAddress) {
144             paused = !paused;
145         }
146     }
147 
148     function kill() public {
149         if (msg.sender == rakeAddress) {
150             selfdestruct(rakeAddress);
151         }
152     }
153 }