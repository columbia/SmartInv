1 pragma solidity ^0.4.16;
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
32     // uint public constant prize = 1.25 ether;
33     // uint public constant fee = 0.015 ether;
34     // uint public constant totalTickets = 50;
35     uint public constant prize = 0.05 ether;
36     uint public constant fee = 0.0005 ether;
37     uint public constant totalTickets = 10;
38     uint public constant pricePerTicket = (prize + fee) / totalTickets;
39     address feeAddress;
40 
41     // Other internal variables
42     bool public paused = false;
43     uint public raffleId = 1;
44     uint nextTicket = 0;
45     mapping (uint => Contestant) contestants;
46     uint[] gaps;
47 
48     // Initialization
49     function Ethraffle() public {
50         feeAddress = msg.sender;
51     }
52 
53     // Call buyTickets() when receiving Ether outside a function
54     function () payable public {
55         buyTickets();
56     }
57 
58     function buyTickets() payable public {
59         if (paused) {
60             msg.sender.transfer(msg.value);
61             return;
62         }
63 
64         uint moneySent = msg.value;
65 
66         while (moneySent >= pricePerTicket && nextTicket < totalTickets) {
67             uint currTicket = 0;
68             if (gaps.length > 0) {
69                 currTicket = gaps[gaps.length-1];
70                 gaps.length--;
71             } else {
72                 currTicket = nextTicket++;
73             }
74 
75             contestants[currTicket] = Contestant(msg.sender, raffleId);
76             TicketPurchase(raffleId, msg.sender, currTicket);
77             moneySent -= pricePerTicket;
78         }
79 
80         // Choose winner if we sold all the tickets
81         if (nextTicket == totalTickets) {
82             chooseWinner();
83         }
84 
85         // Send back leftover money
86         if (moneySent > 0) {
87             msg.sender.transfer(moneySent);
88         }
89     }
90 
91     function chooseWinner() private {
92         address seed1 = contestants[uint(block.coinbase) % totalTickets].addr;
93         address seed2 = contestants[uint(msg.sender) % totalTickets].addr;
94         uint seed3 = block.difficulty;
95         bytes32 randHash = keccak256(seed1, seed2, seed3);
96 
97         uint winningNumber = uint(randHash) % totalTickets;
98         address winningAddress = contestants[winningNumber].addr;
99         RaffleResult(raffleId, winningNumber, winningAddress, seed1, seed2, seed3, randHash);
100 
101         // Start next raffle
102         raffleId++;
103         nextTicket = 0;
104 
105         // gaps.length = 0 isn't necessary here,
106         // because buyTickets() eventually clears
107         // the gaps array in the loop itself.
108 
109         // Distribute prize and fee
110         winningAddress.transfer(prize);
111         feeAddress.transfer(fee);
112     }
113 
114     // Get your money back before the raffle occurs
115     function getRefund() public {
116         uint refund = 0;
117         for (uint i = 0; i < totalTickets; i++) {
118             if (msg.sender == contestants[i].addr && raffleId == contestants[i].raffleId) {
119                 refund += pricePerTicket;
120                 contestants[i] = Contestant(address(0), 0);
121                 gaps.push(i);
122                 TicketRefund(raffleId, msg.sender, i);
123             }
124         }
125 
126         if (refund > 0) {
127             msg.sender.transfer(refund);
128         }
129     }
130 
131     // Refund everyone's money, start a new raffle, then pause it
132     function endRaffle() public {
133         if (msg.sender == feeAddress) {
134             paused = true;
135 
136             for (uint i = 0; i < totalTickets; i++) {
137                 if (raffleId == contestants[i].raffleId) {
138                     TicketRefund(raffleId, contestants[i].addr, i);
139                     contestants[i].addr.transfer(pricePerTicket);
140                 }
141             }
142 
143             RaffleResult(raffleId, totalTickets, address(0), address(0), address(0), 0, 0);
144             raffleId++;
145             nextTicket = 0;
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