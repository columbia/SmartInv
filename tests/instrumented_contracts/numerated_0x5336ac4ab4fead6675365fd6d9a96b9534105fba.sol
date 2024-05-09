1 pragma solidity ^0.5.0;
2 
3 contract DocumentHash {
4     mapping(string => uint) hashToTimestamp;
5     
6     function write(string memory hash) public {
7         require(hashToTimestamp[hash] == 0);
8         
9         hashToTimestamp[hash] = now;
10     }
11     
12     function getTimestamp(string memory hash) public view returns(uint) {
13         return hashToTimestamp[hash];
14     }
15 }