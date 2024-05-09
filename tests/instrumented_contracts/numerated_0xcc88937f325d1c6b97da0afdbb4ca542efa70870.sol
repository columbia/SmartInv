1 pragma solidity ^0.4.16;
2 
3 contract Ethraffle_v4b {
4     struct Contestant {
5         address addr;
6         uint raffleId;
7     }
8 
9     event RaffleResult(
10         uint raffleId,
11         uint winningNumber,
12         address winningAddress,
13         address seed1,
14         address seed2,
15         uint seed3,
16         bytes32 randHash
17     );
18 
19     event TicketPurchase(
20         uint raffleId,
21         address contestant,
22         uint number
23     );
24 
25     event TicketRefund(
26         uint raffleId,
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
41     uint public blockNumber = block.number;
42     uint nextTicket = 0;
43     mapping (uint => Contestant) contestants;
44     uint[] gaps;
45 
46     // Initialization
47     function Ethraffle_v4b() public {
48         feeAddress = msg.sender;
49     }
50 
51     // Call buyTickets() when receiving Ether outside a function
52     function () payable public {
53         buyTickets();
54     }
55 
56     function buyTickets() payable public {
57         if (paused) {
58             msg.sender.transfer(msg.value);
59             return;
60         }
61 
62         uint moneySent = msg.value;
63 
64         while (moneySent >= pricePerTicket && nextTicket < totalTickets) {
65             uint currTicket = 0;
66             if (gaps.length > 0) {
67                 currTicket = gaps[gaps.length-1];
68                 gaps.length--;
69             } else {
70                 currTicket = nextTicket++;
71             }
72 
73             contestants[currTicket] = Contestant(msg.sender, raffleId);
74             TicketPurchase(raffleId, msg.sender, currTicket);
75             moneySent -= pricePerTicket;
76         }
77 
78         // Choose winner if we sold all the tickets
79         if (nextTicket == totalTickets) {
80             chooseWinner();
81         }
82 
83         // Send back leftover money
84         if (moneySent > 0) {
85             msg.sender.transfer(moneySent);
86         }
87     }
88 
89     function chooseWinner() private {
90         address seed1 = contestants[uint(block.coinbase) % totalTickets].addr;
91         address seed2 = contestants[uint(msg.sender) % totalTickets].addr;
92         uint seed3 = block.difficulty;
93         bytes32 randHash = keccak256(seed1, seed2, seed3);
94 
95         uint winningNumber = uint(randHash) % totalTickets;
96         address winningAddress = contestants[winningNumber].addr;
97         RaffleResult(raffleId, winningNumber, winningAddress, seed1, seed2, seed3, randHash);
98 
99         // Start next raffle
100         raffleId++;
101         nextTicket = 0;
102         blockNumber = block.number;
103 
104         // gaps.length = 0 isn't necessary here,
105         // because buyTickets() eventually clears
106         // the gaps array in the loop itself.
107 
108         // Distribute prize and fee
109         winningAddress.transfer(prize);
110         feeAddress.transfer(fee);
111     }
112 
113     // Get your money back before the raffle occurs
114     function getRefund() public {
115         uint refund = 0;
116         for (uint i = 0; i < totalTickets; i++) {
117             if (msg.sender == contestants[i].addr && raffleId == contestants[i].raffleId) {
118                 refund += pricePerTicket;
119                 contestants[i] = Contestant(address(0), 0);
120                 gaps.push(i);
121                 TicketRefund(raffleId, msg.sender, i);
122             }
123         }
124 
125         if (refund > 0) {
126             msg.sender.transfer(refund);
127         }
128     }
129 
130     // Refund everyone's money, start a new raffle, then pause it
131     function endRaffle() public {
132         if (msg.sender == feeAddress) {
133             paused = true;
134 
135             for (uint i = 0; i < totalTickets; i++) {
136                 if (raffleId == contestants[i].raffleId) {
137                     TicketRefund(raffleId, contestants[i].addr, i);
138                     contestants[i].addr.transfer(pricePerTicket);
139                 }
140             }
141 
142             RaffleResult(raffleId, totalTickets, address(0), address(0), address(0), 0, 0);
143             raffleId++;
144             nextTicket = 0;
145             blockNumber = block.number;
146             gaps.length = 0;
147         }
148     }
149 
150     function togglePause() public {
151         if (msg.sender == feeAddress) {
152             paused = !paused;
153         }
154     }
155 
156     function kill() public {
157         if (msg.sender == feeAddress) {
158             selfdestruct(feeAddress);
159         }
160     }
161 }