1 pragma solidity ^0.4.0;
2 
3 contract SimpleStorage
4 {
5     uint storedData;
6     
7     function set(uint x) public
8     {
9         storedData = x;
10     }
11 
12     function get() public view returns (uint)
13     {
14         return storedData;
15     }
16 }