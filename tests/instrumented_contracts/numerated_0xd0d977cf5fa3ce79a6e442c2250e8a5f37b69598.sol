1 pragma solidity ^0.4.0;
2 
3 contract Ethraffle {
4     // Structs
5     struct Contestant {
6         address addr;
7         uint raffleId;
8     }
9 
10     // Events
11     event RaffleResult(
12         uint raffleId,
13         uint winningNumber,
14         address winningAddress,
15         uint blockTimestamp,
16         uint blockNumber,
17         uint gasLimit,
18         uint difficulty,
19         uint gas,
20         uint value,
21         address msgSender,
22         address blockCoinbase,
23         bytes32 sha
24     );
25 
26     event TicketPurchase(
27         uint raffleId,
28         address contestant,
29         uint number
30     );
31 
32     event TicketRefund(
33         uint raffleId,
34         address contestant,
35         uint number
36     );
37 
38     // Constants
39     address public creatorAddress;
40     address constant public rakeAddress = 0x15887100f3b3cA0b645F007c6AA11348665c69e5;
41     uint constant public prize = 0.1 ether;
42     uint constant public rake = 0.02 ether;
43     uint constant public totalTickets = 6;
44     uint constant public pricePerTicket = (prize + rake) / totalTickets;
45 
46     // Variables
47     uint public raffleId = 0;
48     uint public nextTicket = 0;
49     mapping (uint => Contestant) public contestants;
50     uint[] public gaps;
51 
52     // Initialization
53     function Ethraffle() public {
54         creatorAddress = msg.sender;
55         resetRaffle();
56     }
57 
58     function resetRaffle() private {
59         raffleId++;
60         nextTicket = 1;
61     }
62 
63     // Call buyTickets() when receiving Ether outside a function
64     function () payable public {
65         buyTickets();
66     }
67 
68     function buyTickets() payable public {
69         uint moneySent = msg.value;
70 
71         while (moneySent >= pricePerTicket && nextTicket <= totalTickets) {
72             uint currTicket = 0;
73             if (gaps.length > 0) {
74                 currTicket = gaps[gaps.length-1];
75                 gaps.length--;
76             } else {
77                 currTicket = nextTicket++;
78             }
79 
80             contestants[currTicket] = Contestant(msg.sender, raffleId);
81             TicketPurchase(raffleId, msg.sender, currTicket);
82             moneySent -= pricePerTicket;
83         }
84 
85         // Choose winner if we sold all the tickets
86         if (nextTicket > totalTickets) {
87             chooseWinner();
88         }
89 
90         // Send back leftover money
91         if (moneySent > 0) {
92             msg.sender.transfer(moneySent);
93         }
94     }
95 
96     function chooseWinner() private {
97         uint lastWinningNumber = getRandom();
98         address winningAddress = contestants[lastWinningNumber].addr;
99         RaffleResult(
100             raffleId, lastWinningNumber, winningAddress, block.timestamp,
101             block.number, block.gaslimit, block.difficulty, msg.gas,
102             msg.value, msg.sender, block.coinbase, getSha()
103         );
104         resetRaffle();
105         winningAddress.transfer(prize);
106         rakeAddress.transfer(rake);
107     }
108 
109     // Choose a random int between 1 and totalTickets
110     function getRandom() private returns (uint) {
111         return (uint(getSha()) % totalTickets) + 1;
112     }
113 
114     function getSha() private returns (bytes32) {
115         return sha3(
116             block.timestamp +
117             block.number +
118             block.gaslimit +
119             block.difficulty +
120             msg.gas +
121             msg.value +
122             uint(msg.sender) +
123             uint(block.coinbase)
124         );
125     }
126 
127     function getRefund() public {
128         uint refunds = 0;
129         for (uint i = 1; i <= totalTickets; i++) {
130             if (msg.sender == contestants[i].addr && raffleId == contestants[i].raffleId) {
131                 refunds++;
132                 contestants[i] = Contestant(address(0), 0);
133                 gaps.push(i);
134                 TicketRefund(raffleId, msg.sender, i);
135             }
136         }
137 
138         if (refunds > 0) {
139             msg.sender.transfer(refunds * pricePerTicket);
140         }
141     }
142 
143     function kill() public {
144         if (msg.sender == creatorAddress) {
145             selfdestruct(creatorAddress);
146         }
147     }
148 }