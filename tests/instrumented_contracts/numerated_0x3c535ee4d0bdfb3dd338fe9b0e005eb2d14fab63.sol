1 pragma solidity ^0.4.24;
2 
3 contract Nonce {
4     event IncrementEvent(address indexed _sender, uint256 indexed _newNonce);
5     uint256 value;
6     
7     function increment() public returns (uint256) {
8         value = ++value;
9         emit IncrementEvent(msg.sender, value);
10         return value;
11     }
12     
13     function getValue() public view returns (uint256) {
14         return value;
15     }
16 }