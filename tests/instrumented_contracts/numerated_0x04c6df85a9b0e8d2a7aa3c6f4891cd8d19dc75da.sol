1 pragma solidity ^0.4.21;
2 
3 contract NanoLedger{
4     
5     mapping (uint => string) data;
6 
7     
8     function saveCode(uint256 id, string dataMasuk) public{
9         data[id] = dataMasuk;
10     }
11     
12     function verify(uint8 id) view public returns (string){
13         return (data[id]);
14     }
15 }