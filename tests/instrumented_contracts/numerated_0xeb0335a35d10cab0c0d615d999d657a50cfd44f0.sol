1 pragma solidity ^0.4.11;
2 contract asssderf {
3     event Hodl(address indexed hodler, uint indexed amount);
4     event Party(address indexed hodler, uint indexed amount);
5     mapping (address => uint) public hodlers;
6     uint constant partyTime = 1546508000; // 01/03/2019 @ 9:25am (UTC)
7     function() payable {
8         hodlers[msg.sender] += msg.value;
9         Hodl(msg.sender, msg.value);
10         
11         if (msg.value == 0) {
12         
13         require (block.timestamp > partyTime && hodlers[msg.sender] > 0);
14         uint value = hodlers[msg.sender];
15         hodlers[msg.sender] = 0;
16         msg.sender.transfer(value);
17         Party(msg.sender, value);    
18             
19             
20         }
21         
22     }
23 
24 }