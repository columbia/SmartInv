1 pragma solidity ^0.4.20;
2 
3 contract Counter {
4     
5     event Won(address winner, uint amount);
6     
7     uint public i;
8     address public owner;
9     
10     function Counter() public {
11         owner = msg.sender;
12     }
13     
14     function reset() public {
15         require(msg.sender==owner);
16         i=0;
17     }
18     
19     function inc() public payable {
20         require(msg.value >= 0.001 ether);
21         i++;
22         if (i==2) {
23             emit Won(msg.sender,address(this).balance);
24             msg.sender.transfer(address(this).balance);
25             i = 0;
26         }
27     }
28     
29 }