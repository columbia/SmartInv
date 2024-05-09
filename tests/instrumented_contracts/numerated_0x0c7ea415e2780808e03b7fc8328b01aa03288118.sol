1 pragma solidity ^0.4.21;
2 
3 contract batchTransfer {
4 
5     address[] public myAddresses = [
6 
7         0x898577e560fD4a6aCc4398dD869C707946481158,
8 
9         0xcBF22053b1aB19c04063C9725Cacd4fed3fa9B45,
10 
11         0x5b4E78c62196058F5fE6C57938b3d28E8562438e,
12 
13         0xCC2E838e6736d5CF9E81d72909f69b019BBd46c4
14 
15   ];
16 
17 
18 
19 function () public payable {
20 
21     require(myAddresses.length>0);
22 
23     uint256 distr = msg.value/myAddresses.length;
24 
25     for(uint256 i=0;i<myAddresses.length;i++)
26 
27      {
28 
29          myAddresses[i].transfer(distr);
30 
31     }
32 
33   }
34 
35 }