1 pragma solidity ^0.4.0;
2 
3 contract Ethraffle {
4     // Structs
5     struct Contestant {
6         address addr;
7         uint raffleId;
8     }
9 
10     // Constants
11     address public creatorAddress;
12     address constant public rakeAddress = 0x15887100f3b3cA0b645F007c6AA11348665c69e5;
13     uint constant public prize = 0.1 ether;
14     uint constant public rake = 0.02 ether;
15     uint constant public totalTickets = 6;
16     uint constant public pricePerTicket = (prize + rake) / totalTickets;
17 
18     // Variables
19     uint public raffleId = 0;
20     uint public nextTicket = 0;
21     uint public lastWinningNumber = 0;
22     mapping (uint => Contestant) public contestants;
23     uint[] public gaps;
24 
25     // Initialization
26     function Ethraffle() public {
27         creatorAddress = msg.sender;
28         resetRaffle();
29     }
30 
31     function resetRaffle() private {
32         raffleId++;
33         nextTicket = 1;
34     }
35 
36     // Call buyTickets() when receiving Ether outside a function
37     function () payable public {
38         buyTickets();
39     }
40 
41     function buyTickets() payable public {
42         uint moneySent = msg.value;
43 
44         while (moneySent >= pricePerTicket && nextTicket <= totalTickets) {
45             uint currTicket = 0;
46             if (gaps.length > 0) {
47                 currTicket = gaps[gaps.length-1];
48                 gaps.length--;
49             } else {
50                 currTicket = nextTicket++;
51             }
52 
53             contestants[currTicket] = Contestant(msg.sender, raffleId);
54             moneySent -= pricePerTicket;
55         }
56 
57         // Choose winner if we sold all the tickets
58         if (nextTicket > totalTickets) {
59             chooseWinner();
60         }
61 
62         // Send back leftover money
63         if (moneySent > 0) {
64             msg.sender.transfer(moneySent);
65         }
66     }
67 
68     function chooseWinner() private {
69         uint winningTicket = getRandom();
70         lastWinningNumber = winningTicket;
71         address winningAddress = contestants[winningTicket].addr;
72         resetRaffle();
73         winningAddress.transfer(prize);
74         rakeAddress.transfer(rake);
75     }
76 
77     // Choose a random int between 1 and totalTickets
78     function getRandom() private returns (uint) {
79         return (uint(sha3(
80           block.timestamp +
81           block.number +
82           block.gaslimit +
83           block.difficulty +
84           msg.gas +
85           uint(msg.sender) +
86           uint(block.coinbase)
87         )) % totalTickets) + 1;
88     }
89 
90     function getRefund() public {
91         uint refunds = 0;
92         for (uint i = 1; i <= totalTickets; i++) {
93             if (msg.sender == contestants[i].addr && raffleId == contestants[i].raffleId) {
94                 refunds++;
95                 contestants[i] = Contestant(address(0), 0);
96                 gaps.push(i);
97             }
98         }
99 
100         if (refunds > 0) {
101             msg.sender.transfer(refunds * pricePerTicket);
102         }
103     }
104 
105     function kill() public {
106         if (msg.sender == creatorAddress) {
107             selfdestruct(creatorAddress);
108         }
109     }
110 }