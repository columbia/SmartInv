1 pragma solidity ^0.4.24;
2 contract Hasher{
3     function hashLoop(uint numTimes, bytes32 dataToHash) public returns (bytes32){
4         for(uint i = 0 ; i < numTimes ; i++){
5             dataToHash = keccak256(abi.encodePacked(dataToHash));
6         }
7         return dataToHash;
8     }
9 }