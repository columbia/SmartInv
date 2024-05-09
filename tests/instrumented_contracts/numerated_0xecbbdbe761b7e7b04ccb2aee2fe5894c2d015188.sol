1 pragma solidity ^0.4.25;
2 
3 contract Timestamper {
4     address private owner; 
5     event Timestamp(bytes32 sha256);
6 
7     constructor() public {
8         owner = msg.sender;
9     }
10     function dotimestamp(bytes32 _sha256) public {
11         require(owner==msg.sender);
12         emit Timestamp(_sha256);
13     }
14 }