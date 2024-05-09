1 pragma solidity ^0.4.18;
2 
3 contract ProofOfExistence {
4 
5   event ProofCreated(bytes32 documentHash, uint256 timestamp);
6 
7   address public owner = msg.sender;
8 
9   mapping (bytes32 => uint256) hashesById;
10 
11   modifier onlyOwner() {
12     require(msg.sender == owner);
13     _;
14   }
15 
16   modifier noHashExistsYet(bytes32 documentHash) {
17     require(hashesById[documentHash] == 0);
18     _;
19   }
20 
21   function ProofOfExistence() public {
22     owner = msg.sender;
23   }
24 
25   function notarizeHash(bytes32 documentHash) onlyOwner public {
26     var timestamp = block.timestamp;
27     hashesById[documentHash] = timestamp;
28     ProofCreated(documentHash, timestamp);
29   }
30 
31   function doesProofExist(bytes32 documentHash) public view returns (uint256) {
32     if (hashesById[documentHash] != 0) {
33       return hashesById[documentHash];
34     }
35   }
36 }