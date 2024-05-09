1 pragma solidity ^0.4.0;
2 
3 contract SimpleStorage {
4     uint storedData;
5 
6     function set(uint x) public {
7         storedData = x;
8     }
9 
10     function get() public view returns (uint) {
11         return storedData;
12     }
13 }