1 pragma solidity ^0.4.24;
2 
3 contract R256 {
4 
5     mapping(uint => uint) public record;
6 
7     event R(uint z);
8 
9     constructor() public {}
10 
11     function addRecord(uint z) public {
12         require(record[z] == 0);
13         record[z] = now;
14         emit R(z);
15     }
16 
17     function addMultipleRecords(uint[] zz) public {
18         for (uint i; i < zz.length; i++) {
19             addRecord(zz[i]);
20         }
21     }
22 
23 }