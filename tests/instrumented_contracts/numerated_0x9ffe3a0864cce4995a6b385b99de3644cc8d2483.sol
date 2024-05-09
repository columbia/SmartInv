1 pragma solidity ^0.4.16;
2 
3 contract Ethraffle_v2b {
4     struct Contestant {
5         address addr;
6         uint raffleId;
7     }
8 
9     event RaffleResult(
10         uint indexed raffleId,
11         uint winningNumber,
12         address winningAddress,
13         address seed1,
14         address seed2,
15         uint seed3,
16         bytes32 randHash
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
32     uint public constant prize = 2.5 ether;
33     uint public constant fee = 0.03 ether;
34     uint public constant totalTickets = 50;
35     uint public constant pricePerTicket = (prize + fee) / totalTickets; // Make sure this divides evenly
36     address feeAddress;
37 
38     // Other internal variables
39     bool public paused = false;
40     uint public raffleId = 1;
41     uint nextTicket = 0;
42     mapping (uint => Contestant) contestants;
43     uint[] gaps;
44 
45     // Initialization
46     function Ethraffle_v2b() public {
47         feeAddress = msg.sender;
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
72             contestants[currTicket] = Contestant(msg.sender, raffleId);
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
89         address seed1 = contestants[uint(block.coinbase) % totalTickets].addr;
90         address seed2 = contestants[uint(msg.sender) % totalTickets].addr;
91         uint seed3 = block.difficulty;
92         bytes32 randHash = keccak256(seed1, seed2, seed3);
93 
94         uint winningNumber = uint(randHash) % totalTickets;
95         address winningAddress = contestants[winningNumber].addr;
96         RaffleResult(raffleId, winningNumber, winningAddress, seed1, seed2, seed3, randHash);
97 
98         // Start next raffle
99         raffleId++;
100         nextTicket = 0;
101 
102         // gaps.length = 0 isn't necessary here,
103         // because buyTickets() eventually clears
104         // the gaps array in the loop itself.
105 
106         // Distribute prize and fee
107         winningAddress.transfer(prize);
108         feeAddress.transfer(fee);
109     }
110 
111     // Get your money back before the raffle occurs
112     function getRefund() public {
113         uint refund = 0;
114         for (uint i = 0; i < totalTickets; i++) {
115             if (msg.sender == contestants[i].addr && raffleId == contestants[i].raffleId) {
116                 refund += pricePerTicket;
117                 contestants[i] = Contestant(address(0), 0);
118                 gaps.push(i);
119                 TicketRefund(raffleId, msg.sender, i);
120             }
121         }
122 
123         if (refund > 0) {
124             msg.sender.transfer(refund);
125         }
126     }
127 
128     // Refund everyone's money, start a new raffle, then pause it
129     function endRaffle() public {
130         if (msg.sender == feeAddress) {
131             paused = true;
132 
133             for (uint i = 0; i < totalTickets; i++) {
134                 if (raffleId == contestants[i].raffleId) {
135                     TicketRefund(raffleId, contestants[i].addr, i);
136                     contestants[i].addr.transfer(pricePerTicket);
137                 }
138             }
139 
140             RaffleResult(raffleId, totalTickets, address(0), address(0), address(0), 0, 0);
141             raffleId++;
142             nextTicket = 0;
143             gaps.length = 0;
144         }
145     }
146 
147     function togglePause() public {
148         if (msg.sender == feeAddress) {
149             paused = !paused;
150         }
151     }
152 
153     function kill() public {
154         if (msg.sender == feeAddress) {
155             selfdestruct(feeAddress);
156         }
157     }
158 }