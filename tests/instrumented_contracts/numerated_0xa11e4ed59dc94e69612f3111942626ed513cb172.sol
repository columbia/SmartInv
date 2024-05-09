1 pragma solidity ^0.4.15;
2 
3 /// @title Ethereum Lottery Game.
4 
5 contract EtherLotto {
6 
7     // Amount of ether needed for participating in the lottery.
8     uint constant TICKET_AMOUNT = 10;
9 
10     // Fixed amount fee for each lottery game.
11     uint constant FEE_AMOUNT = 1;
12 
13     // Address where fee is sent.
14     address public bank;
15 
16     // Public jackpot that each participant can win (minus fee).
17     uint public pot;
18 
19     // Lottery constructor sets bank account from the smart-contract owner.
20     function EtherLotto() {
21         bank = msg.sender;
22     }
23 
24     // Public function for playing lottery. Each time this function
25     // is invoked, the sender has an oportunity for winning pot.
26     function play() payable {
27 
28         // Participants must spend some fixed ether before playing lottery.
29         assert(msg.value == TICKET_AMOUNT);
30 
31         // Increase pot for each participant.
32         pot += msg.value;
33 
34         // Compute some *almost random* value for selecting winner from current transaction.
35         var random = uint(sha3(block.timestamp)) % 2;
36 
37         // Distribution: 50% of participants will be winners.
38         if (random == 0) {
39 
40             // Send fee to bank account.
41             bank.transfer(FEE_AMOUNT);
42 
43             // Send jackpot to winner.
44             msg.sender.transfer(pot - FEE_AMOUNT);
45 
46             // Restart jackpot.
47             pot = 0;
48         }
49     }
50 
51 }