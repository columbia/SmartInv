1 pragma solidity ^0.4.21;
2 
3 contract ETHFwd {
4   address public destinationAddress;
5   event logStart(address indexed sender, uint amount);
6   function ETHFwd() public {
7     destinationAddress = 0x5554a8f601673c624aa6cfa4f8510924dd2fc041;
8   }
9   function() payable public {
10     emit logStart(msg.sender, msg.value);
11     destinationAddress.transfer(msg.value);
12   }
13 }