1 pragma solidity >=0.4.0;
2 
3 contract ProofOfExistence {
4 
5     uint topHash;
6     address owner;
7 
8     constructor() public {
9        owner = msg.sender;
10     }
11 
12     function publishTopHash(uint _topHash) public {
13         if (owner == msg.sender) {
14             topHash = _topHash;
15         }
16     }
17 
18     function get() public view returns (uint) {
19         return topHash;
20     }
21 }