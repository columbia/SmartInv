1 pragma solidity ^0.5.0;
2 
3 contract DocumentHash {
4     mapping(string => uint) hashToBlockNumber;
5 
6     function write(string memory hash) public {
7         // Require the hash to be not set.
8         require(hashToBlockNumber[hash] == 0);
9 
10         hashToBlockNumber[hash] = block.number;
11     }
12 
13     function getBlockNumber(string memory hash) public view returns(uint) {
14         return hashToBlockNumber[hash];
15     }
16 }