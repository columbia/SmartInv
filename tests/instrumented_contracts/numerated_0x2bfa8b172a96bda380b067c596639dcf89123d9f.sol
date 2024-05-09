1 pragma solidity ^0.4.24;
2 
3 contract Lottery {
4 
5     uint public lotteryStart;
6     uint public ticketPrice;
7     uint public ticketsAvailable;
8 
9     mapping(uint => address) public owner;
10 
11     modifier lotteryComplete {require(block.timestamp >= (lotteryStart + 7 days), "lottery has not completed"); _;}
12 
13     constructor() public {
14         lotteryStart = 0;
15     }
16 
17     function newLottery() public {
18         if (lotteryStart != 0) {
19             require(block.timestamp >= (lotteryStart + 7 days), "lottery has not completed");
20         }
21 
22         for (uint ticket = 0; ticket < ticketsAvailable; ticket++) {
23             owner[ticket] = address(0);
24         }
25 
26         ticketsAvailable = 100;
27         ticketPrice = 10 finney;
28         lotteryStart = block.timestamp;
29     }
30 
31     function purchaseTicket(uint ticket) public payable {
32         require(owner[ticket] == address(0), "the ticket has been purchased");                    // the ticket hasn't been purchased
33         require(msg.value == ticketPrice, "sent an invalid ticket price");                      // value sent is the ticket price
34 
35         owner[ticket] = msg.sender;
36     }
37 
38     function completeLottery() public lotteryComplete {
39         address winner = owner[block.number % ticketsAvailable];
40 
41         if (winner != address(0)) {
42             address(this).transfer(address(this).balance);
43         }
44     }
45 
46     function getTicketOwner(uint ticket) public view returns(address) {
47         return owner[ticket];
48     }
49 }