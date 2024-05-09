1 pragma solidity ^0.4.23;
2 
3 contract Forward {
4 
5   address public destinationAddress;
6   event LogForwarded(address indexed sender, uint amount);
7   event LogFlushed(address indexed sender, uint amount);
8 
9   function constuctor() public {
10     destinationAddress = msg.sender;
11   }
12 
13   function() payable public {
14     emit LogForwarded(msg.sender, msg.value);
15     destinationAddress.transfer(msg.value);
16   }
17 
18   function flush() public {
19     emit LogFlushed(msg.sender, address(this).balance);
20     destinationAddress.transfer(address(this).balance);
21   }
22 
23 }