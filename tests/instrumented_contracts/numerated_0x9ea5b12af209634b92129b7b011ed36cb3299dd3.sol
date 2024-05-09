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
21     mapping (uint => Contestant) public contestants;
22     uint[] public gaps;
23 
24     // Initialization
25     function Ethraffle() public {
26         creatorAddress = msg.sender;
27         resetRaffle();
28     }
29 
30     function resetRaffle() private {
31         raffleId++;
32         nextTicket = 1;
33     }
34 
35     // Call buyTickets() when receiving Ether outside a function
36     function () payable public {
37         buyTickets();
38     }
39 
40     function buyTickets() payable public {
41         uint moneySent = msg.value;
42 
43         while (moneySent >= pricePerTicket && nextTicket <= totalTickets) {
44             uint currTicket = 0;
45             if (gaps.length > 0) {
46                 currTicket = gaps[gaps.length-1];
47                 gaps.length--;
48             } else {
49                 currTicket = nextTicket++;
50             }
51 
52             contestants[currTicket] = Contestant(msg.sender, raffleId);
53             moneySent -= pricePerTicket;
54         }
55 
56         // Choose winner if we sold all the tickets
57         if (nextTicket > totalTickets) {
58             chooseWinner();
59         }
60 
61         // Send back leftover money
62         if (moneySent > 0) {
63             msg.sender.transfer(moneySent);
64         }
65     }
66 
67     function chooseWinner() private {
68         uint winningTicket = 1; // TODO: Randomize
69         address winningAddress = contestants[winningTicket].addr;
70         resetRaffle();
71         winningAddress.transfer(prize);
72         rakeAddress.transfer(rake);
73     }
74 
75     function getRefund() public {
76         uint refunds = 0;
77         for (uint i = 1; i <= totalTickets; i++) {
78             if (msg.sender == contestants[i].addr && raffleId == contestants[i].raffleId) {
79                 refunds++;
80                 contestants[i] = Contestant(address(0), 0);
81                 gaps.push(i);
82             }
83         }
84 
85         if (refunds > 0) {
86             msg.sender.transfer(refunds * pricePerTicket);
87         }
88     }
89 
90     function kill() public {
91         if (msg.sender == creatorAddress) {
92             selfdestruct(creatorAddress);
93         }
94     }
95 }