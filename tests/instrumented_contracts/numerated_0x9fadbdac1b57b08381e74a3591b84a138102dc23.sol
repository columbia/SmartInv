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
13         uint blockTimestamp,
14         uint blockNumber,
15         uint gasLimit,
16         uint difficulty,
17         uint gas,
18         uint value,
19         address msgSender,
20         address blockCoinbase,
21         bytes32 sha
22     );
23 
24     event TicketPurchase(
25         uint indexed raffleId,
26         address contestant,
27         uint number
28     );
29 
30     event TicketRefund(
31         uint indexed raffleId,
32         address contestant,
33         uint number
34     );
35 
36     // Constants
37     address public rakeAddress;
38     uint constant public prize = 0.1 ether;
39     uint constant public rake = 0.02 ether;
40     uint constant public totalTickets = 6;
41     uint constant public pricePerTicket = (prize + rake) / totalTickets;
42 
43     // Other internal variables
44     uint public raffleId = 1;
45     uint public nextTicket = 1;
46     mapping (uint => Contestant) public contestants;
47     uint[] public gaps;
48     bool public paused = false;
49 
50     // Initialization
51     function Ethraffle() public {
52         rakeAddress = msg.sender;
53     }
54 
55     // Call buyTickets() when receiving Ether outside a function
56     function () payable public {
57         buyTickets();
58     }
59 
60     function buyTickets() payable public {
61         if (paused) {
62             msg.sender.transfer(msg.value);
63             return;
64         }
65 
66         uint moneySent = msg.value;
67 
68         while (moneySent >= pricePerTicket && nextTicket <= totalTickets) {
69             uint currTicket = 0;
70             if (gaps.length > 0) {
71                 currTicket = gaps[gaps.length-1];
72                 gaps.length--;
73             } else {
74                 currTicket = nextTicket++;
75             }
76 
77             contestants[currTicket] = Contestant(msg.sender, raffleId);
78             TicketPurchase(raffleId, msg.sender, currTicket);
79             moneySent -= pricePerTicket;
80         }
81 
82         // Choose winner if we sold all the tickets
83         if (nextTicket > totalTickets) {
84             chooseWinner();
85         }
86 
87         // Send back leftover money
88         if (moneySent > 0) {
89             msg.sender.transfer(moneySent);
90         }
91     }
92 
93     function chooseWinner() private {
94         // Pseudorandom number generator
95         bytes32 sha = sha3(
96             block.timestamp,
97             block.number,
98             block.gaslimit,
99             block.difficulty,
100             msg.gas,
101             msg.value,
102             msg.sender,
103             block.coinbase
104         );
105 
106         uint winningNumber = (uint(sha) % totalTickets) + 1;
107         address winningAddress = contestants[winningNumber].addr;
108         RaffleResult(
109             raffleId, winningNumber, winningAddress, block.timestamp,
110             block.number, block.gaslimit, block.difficulty, msg.gas,
111             msg.value, msg.sender, block.coinbase, sha
112         );
113 
114         // Start next raffle and distribute prize
115         raffleId++;
116         nextTicket = 1;
117         winningAddress.transfer(prize);
118         rakeAddress.transfer(rake);
119     }
120 
121     // Get your money back before the raffle occurs
122     function getRefund() public {
123         uint refunds = 0;
124         for (uint i = 1; i <= totalTickets; i++) {
125             if (msg.sender == contestants[i].addr && raffleId == contestants[i].raffleId) {
126                 refunds++;
127                 contestants[i] = Contestant(address(0), 0);
128                 gaps.push(i);
129                 TicketRefund(raffleId, msg.sender, i);
130             }
131         }
132 
133         if (refunds > 0) {
134             msg.sender.transfer(refunds * pricePerTicket);
135         }
136     }
137 
138     // Refund everyone's money, start a new raffle, then pause it
139     function endRaffle() public {
140         if (msg.sender == rakeAddress) {
141             paused = true;
142 
143             for (uint i = 1; i <= totalTickets; i++) {
144                 if (raffleId == contestants[i].raffleId) {
145                     TicketRefund(raffleId, contestants[i].addr, i);
146                     contestants[i].addr.transfer(pricePerTicket);
147                 }
148             }
149 
150             RaffleResult(raffleId, 0, address(0), 0, 0, 0, 0, 0, 0, address(0), address(0), 0);
151             raffleId++;
152             nextTicket = 1;
153             gaps.length = 0;
154         }
155     }
156 
157     function togglePause() public {
158         if (msg.sender == rakeAddress) {
159             paused = !paused;
160         }
161     }
162 
163     function kill() public {
164         if (msg.sender == rakeAddress) {
165             selfdestruct(rakeAddress);
166         }
167     }
168 }