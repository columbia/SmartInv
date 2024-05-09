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
48 
49     // Initialization
50     function Ethraffle() public {
51         rakeAddress = msg.sender;
52     }
53 
54     // Call buyTickets() when receiving Ether outside a function
55     function () payable public {
56         buyTickets();
57     }
58 
59     function buyTickets() payable public {
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
89         bytes32 sha = sha3(
90             block.timestamp,
91             block.number,
92             block.gaslimit,
93             block.difficulty,
94             msg.gas,
95             msg.value,
96             msg.sender,
97             block.coinbase
98         );
99 
100         uint winningNumber = (uint(sha) % totalTickets) + 1;
101         address winningAddress = contestants[winningNumber].addr;
102         RaffleResult(
103             raffleId, winningNumber, winningAddress, block.timestamp,
104             block.number, block.gaslimit, block.difficulty, msg.gas,
105             msg.value, msg.sender, block.coinbase, sha
106         );
107 
108         // Start next raffle and distribute prize
109         raffleId++;
110         nextTicket = 1;
111         winningAddress.transfer(prize);
112         rakeAddress.transfer(rake);
113     }
114 
115     function getRefund() public {
116         uint refunds = 0;
117         for (uint i = 1; i <= totalTickets; i++) {
118             if (msg.sender == contestants[i].addr && raffleId == contestants[i].raffleId) {
119                 refunds++;
120                 contestants[i] = Contestant(address(0), 0);
121                 gaps.push(i);
122                 TicketRefund(raffleId, msg.sender, i);
123             }
124         }
125 
126         if (refunds > 0) {
127             msg.sender.transfer(refunds * pricePerTicket);
128         }
129     }
130 
131     function kill() public {
132         if (msg.sender == rakeAddress) {
133             selfdestruct(rakeAddress);
134         }
135     }
136 }