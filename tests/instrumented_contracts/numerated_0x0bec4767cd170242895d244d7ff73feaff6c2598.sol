1 pragma solidity ^0.4.2;
2 
3 contract Numa {
4 
5     event NewBatch(
6         bytes32 indexed ipfsHash
7     );
8 
9     function Numa() public { }
10     
11     function newBatch(bytes32 ipfsHash) public {
12         NewBatch(ipfsHash);
13     }
14 }