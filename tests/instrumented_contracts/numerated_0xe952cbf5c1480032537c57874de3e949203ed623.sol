1 pragma solidity ^0.4.22;
2 
3 
4 contract LastManStanding {
5 
6     uint lastBlock;
7     address owner;
8     modifier onlyowner {
9         require (msg.sender == owner);
10         _;
11     }
12 
13     function LastManStanding() public {
14         owner = msg.sender;
15     }
16 
17     function () public payable {
18         mineIsBigger();
19     }
20 
21     function mineIsBigger() public payable {
22         if (msg.value > this.balance) {
23             owner = msg.sender;
24             lastBlock = now;
25         }
26     }
27 
28     function withdraw() public onlyowner {
29         // if there are no contestants within 5 hours
30         // the winner is allowed to take the money
31         require(now > lastBlock + 5 hours);
32         msg.sender.transfer(this.balance);
33     }
34    
35 }