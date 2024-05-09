1 pragma solidity ^0.4.25;
2 
3 contract Wallet {
4     event Receive(address from, uint value);
5     event Send(address to, uint value);
6 
7     address public owner;
8 
9     constructor() public {
10         owner = msg.sender;
11     }
12 
13     function() public payable {
14         emit Receive(msg.sender, msg.value);
15     }
16 
17     function transfer(address to, uint value) public {
18         require(msg.sender == owner);
19         to.transfer(value);
20         emit Send(to, value);
21     }
22 }