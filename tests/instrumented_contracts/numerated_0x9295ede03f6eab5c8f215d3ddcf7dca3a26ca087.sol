1 pragma solidity ^0.4.0;
2 
3 contract SimpleStorage {
4     uint storedData;
5 
6     function set(uint x) {
7         storedData = x;
8     }
9 
10     function get() constant returns (uint storedData) {
11         return storedData;
12     }
13 }