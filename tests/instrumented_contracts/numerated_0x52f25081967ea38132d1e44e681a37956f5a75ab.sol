1 pragma solidity ^0.4.15;
2 
3 contract Parallax {
4     
5     // Mapping of last bid for each price.
6     mapping(uint => address) cup;
7 
8 
9     // Address of creator.
10     address public constant referee = 0x6A0D0eBf1e532840baf224E1bD6A1d4489D5D78d;
11     
12     
13     // Game ends at 2 ether.
14     uint public deadline = 2000 finney;
15     
16     
17     // Min and max initialization.
18     uint public highestBid = 0;
19     uint public lowestBid = deadline*2;
20     
21     
22     // Payable fallback method: Called whenever ether is received by contract.
23     function() payable {
24         
25         // Rule 1: You can only send multiples of 0.002 ether.
26         require(msg.value % 2 finney == 0);
27         
28         // Rule 2: You can't close the game by becoming the highest bidder.
29         if(msg.value > highestBid)
30             require(this.balance - msg.value < deadline);
31         
32         // Reassign limits.
33         if(msg.value < lowestBid)   lowestBid = msg.value;
34         if(msg.value > highestBid)  highestBid = msg.value;
35         
36         
37         // Set the last bidder for the price.
38         cup[msg.value] = msg.sender;
39         
40         // Check if the deadline was reached.
41         if(this.balance >= deadline) {
42             
43             // Winning condition: The last bidder of the average price
44             // get the chicken.
45             uint finderAmount = (highestBid + lowestBid)/2;
46             address finderAddress = cup[finderAmount];
47             
48             // If no one guessed correctly, give the chicken to the
49             // the fattest bidder.
50             if (finderAddress == 0x0)
51                 finderAddress = cup[highestBid];
52             
53             // Reset the limits for the next game.
54             highestBid = 0;
55             lowestBid = deadline*2;
56             
57             // Send the chicken to the winner and pay the commission
58             // to the owner. Fee for a successful game is 0.01 ether. 
59             finderAddress.transfer(this.balance - 100 finney);
60             referee.transfer(100 finney);
61         } 
62         
63     }
64 
65 }