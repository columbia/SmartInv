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
37     address public creatorAddress;
38     address constant public rakeAddress = 0x15887100f3b3cA0b645F007c6AA11348665c69e5;
39     uint constant public prize = 0.1 ether;
40     uint constant public rake = 0.02 ether;
41     uint constant public totalTickets = 6;
42     uint constant public pricePerTicket = (prize + rake) / totalTickets;
43 
44     // Variables
45     uint public raffleId = 1;
46     uint public nextTicket = 1;
47     mapping (uint => Contestant) public contestants;
48     uint[] public gaps;
49 
50     // Initialization
51     function Ethraffle() public {
52         creatorAddress = msg.sender;
53     }
54 
55     // Call buyTickets() when receiving Ether outside a function
56     function () payable public {
57         buyTickets();
58     }
59 
60     function buyTickets() payable public {
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
90         bytes32 sha = sha3(
91             block.timestamp +
92             block.number +
93             block.gaslimit +
94             block.difficulty +
95             msg.gas +
96             msg.value +
97             uint(msg.sender) +
98             uint(block.coinbase)
99         );
100 
101         uint winningNumber = (uint(sha) % totalTickets) + 1;
102         address winningAddress = contestants[winningNumber].addr;
103         RaffleResult(
104             raffleId, winningNumber, winningAddress, block.timestamp,
105             block.number, block.gaslimit, block.difficulty, msg.gas,
106             msg.value, msg.sender, block.coinbase, sha
107         );
108 
109         // Start next raffle and distribute prize
110         raffleId++;
111         nextTicket = 1;
112         winningAddress.transfer(prize);
113         rakeAddress.transfer(rake);
114     }
115 
116     function getRefund() public {
117         uint refunds = 0;
118         for (uint i = 1; i <= totalTickets; i++) {
119             if (msg.sender == contestants[i].addr && raffleId == contestants[i].raffleId) {
120                 refunds++;
121                 contestants[i] = Contestant(address(0), 0);
122                 gaps.push(i);
123                 TicketRefund(raffleId, msg.sender, i);
124             }
125         }
126 
127         if (refunds > 0) {
128             msg.sender.transfer(refunds * pricePerTicket);
129         }
130     }
131 
132     function kill() public {
133         if (msg.sender == creatorAddress) {
134             selfdestruct(creatorAddress);
135         }
136     }
137 }