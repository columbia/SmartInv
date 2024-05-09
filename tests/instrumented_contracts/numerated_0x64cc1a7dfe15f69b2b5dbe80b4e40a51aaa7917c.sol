1 pragma solidity ^0.4.21;
2 
3 contract Auction {
4     uint bidDivisor = 100;
5     uint duration = 20 minutes;
6 
7     address owner;
8     uint public prize;
9 
10     uint public bids;
11     address public leader;
12     uint public deadline;
13     bool public claimed;
14 
15     function Auction() public payable {
16         owner = msg.sender;
17         prize = msg.value;
18         bids = 0;
19         leader = msg.sender;
20         deadline = now + duration;
21         claimed = false;
22     }
23 
24     function getNextBid() public view returns (uint) {
25         return (bids + 1) * prize / bidDivisor;
26     }
27 
28     function bid() public payable {
29         require(now <= deadline);
30         require(msg.value == getNextBid());
31         owner.transfer(msg.value);
32         bids++;
33         leader = msg.sender;
34         deadline = now + duration;
35     }
36 
37     function claim() public {
38         require(now > deadline);
39         require(msg.sender == leader);
40         require(!claimed);
41         claimed = true;
42         msg.sender.transfer(prize);
43     }
44 }