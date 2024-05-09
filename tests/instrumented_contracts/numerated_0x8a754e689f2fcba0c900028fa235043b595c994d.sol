1 pragma solidity ^0.4.16;
2 
3 contract Ethraffle_v3b {
4     struct Contestant {
5         address addr;
6         uint raffleId;
7     }
8 
9     event RaffleResult(
10         uint raffleId,
11         uint blockNumber,
12         uint winningNumber,
13         address winningAddress,
14         address seed1,
15         address seed2,
16         uint seed3,
17         bytes32 randHash
18     );
19 
20     event TicketPurchase(
21         uint raffleId,
22         address contestant,
23         uint number
24     );
25 
26     event TicketRefund(
27         uint raffleId,
28         address contestant,
29         uint number
30     );
31 
32     // Constants
33     uint public constant prize = 2.5 ether;
34     uint public constant fee = 0.03 ether;
35     uint public constant totalTickets = 50;
36     uint public constant pricePerTicket = (prize + fee) / totalTickets; // Make sure this divides evenly
37     address feeAddress;
38 
39     // Other internal variables
40     bool public paused = false;
41     uint public raffleId = 1;
42     uint nextTicket = 0;
43     mapping (uint => Contestant) contestants;
44     uint[] gaps;
45 
46     // Initialization
47     function Ethraffle_v3b() public {
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
97         RaffleResult(raffleId, block.number, winningNumber, winningAddress, seed1, seed2, seed3, randHash);
98 
99         // Start next raffle
100         raffleId++;
101         nextTicket = 0;
102 
103         // gaps.length = 0 isn't necessary here,
104         // because buyTickets() eventually clears
105         // the gaps array in the loop itself.
106 
107         // Distribute prize and fee
108         winningAddress.transfer(prize);
109         feeAddress.transfer(fee);
110     }
111 
112     // Get your money back before the raffle occurs
113     function getRefund() public {
114         uint refund = 0;
115         for (uint i = 0; i < totalTickets; i++) {
116             if (msg.sender == contestants[i].addr && raffleId == contestants[i].raffleId) {
117                 refund += pricePerTicket;
118                 contestants[i] = Contestant(address(0), 0);
119                 gaps.push(i);
120                 TicketRefund(raffleId, msg.sender, i);
121             }
122         }
123 
124         if (refund > 0) {
125             msg.sender.transfer(refund);
126         }
127     }
128 
129     // Refund everyone's money, start a new raffle, then pause it
130     function endRaffle() public {
131         if (msg.sender == feeAddress) {
132             paused = true;
133 
134             for (uint i = 0; i < totalTickets; i++) {
135                 if (raffleId == contestants[i].raffleId) {
136                     TicketRefund(raffleId, contestants[i].addr, i);
137                     contestants[i].addr.transfer(pricePerTicket);
138                 }
139             }
140 
141             RaffleResult(raffleId, block.number, totalTickets, address(0), address(0), address(0), 0, 0);
142             raffleId++;
143             nextTicket = 0;
144             gaps.length = 0;
145         }
146     }
147 
148     function togglePause() public {
149         if (msg.sender == feeAddress) {
150             paused = !paused;
151         }
152     }
153 
154     function kill() public {
155         if (msg.sender == feeAddress) {
156             selfdestruct(feeAddress);
157         }
158     }
159 }