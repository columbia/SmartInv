1 pragma solidity ^0.4.24;
2 
3 contract R256Basic {
4 
5     event R(uint z);
6 
7     constructor() public {}
8 
9     function addRecord(uint z) public {
10         emit R(z);
11     }
12 
13     function addMultipleRecords(uint[] zz) public {
14         for (uint i; i < zz.length; i++) {
15             emit R(zz[i]);
16         }
17     }
18 
19 }