1 pragma solidity ^0.4.11;
2 contract FreedomEthereum {
3     event Hodl(address indexed hodler, uint indexed amount);
4     event Party(address indexed hodler, uint indexed amount);
5     mapping (address => uint) public hodlers;
6     uint constant partyTime = 1554098401; //Morning April 1 2019
7     function() payable {
8         hodlers[msg.sender] += msg.value;
9         Hodl(msg.sender, msg.value);
10     }
11     function party() {
12         require (block.timestamp > partyTime && hodlers[msg.sender] > 0);
13         uint value = hodlers[msg.sender];
14         hodlers[msg.sender] = 0;
15         msg.sender.transfer(value);
16         Party(msg.sender, value);
17     }
18 }