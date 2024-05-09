1 pragma solidity ^0.4.0;
2 
3 contract raffle {
4     // Constants
5     address rakeAddress = 0x15887100f3b3cA0b645F007c6AA11348665c69e5;
6     uint prize = 0.1 ether;
7     uint rake = 0.02 ether;
8     uint totalTickets = 6;
9 
10     // Variables
11     address creatorAddress;
12     uint pricePerTicket;
13     uint nextTicket;
14     mapping(uint => address) purchasers;
15 
16     function raffle() {
17         creatorAddress = msg.sender;
18         pricePerTicket = (prize + rake) / totalTickets;
19         resetRaffle();
20     }
21 
22     function resetRaffle() private {
23         nextTicket = 1;
24     }
25 
26     function chooseWinner() private {
27         uint winningTicket = 1; // TODO: Randomize
28         address winningAddress = purchasers[winningTicket];
29         winningAddress.transfer(prize);
30         rakeAddress.transfer(rake);
31         resetRaffle();
32     }
33 
34     function buyTickets() payable public {
35         uint moneySent = msg.value;
36 
37         while (moneySent >= pricePerTicket && nextTicket <= totalTickets) {
38             purchasers[nextTicket] = msg.sender;
39             moneySent -= pricePerTicket;
40             nextTicket++;
41         }
42 
43         // Send back leftover money
44         if (moneySent > 0) {
45             msg.sender.transfer(moneySent);
46         }
47 
48         // Choose winner if we sold all the tickets
49         if (nextTicket > totalTickets) {
50             chooseWinner();
51         }
52     }
53 
54     // TODO
55     function getRefund() public {
56         return;
57     }
58 
59     function kill() public {
60         if (msg.sender == creatorAddress) {
61             selfdestruct(creatorAddress);
62         }
63     }
64 }