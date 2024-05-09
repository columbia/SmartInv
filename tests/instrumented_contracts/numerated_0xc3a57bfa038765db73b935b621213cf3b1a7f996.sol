1 pragma solidity ^0.4.19;
2 
3 contract MyMap {
4     address public owner;
5     mapping(bytes32=>bytes15) map;
6 
7     function MyMap() public {
8         owner = msg.sender;
9     }
10     
11     function setValue(bytes32 a, bytes15 b) public {
12         if(owner == msg.sender) {
13             map[a] = b;
14         }
15     }
16 }