1 pragma solidity ^0.4.24;
2 
3 contract Random {
4 
5     address private ownerAddr;
6 
7     uint[] public randoms;
8 
9     constructor() public{
10         ownerAddr = msg.sender;
11     }
12 
13     function getRandomOne(uint range) public returns (uint){
14         require(msg.sender == ownerAddr);
15         require(range > 0);
16 
17         getRandoms(range, 1);
18         return randoms[0];
19     }
20 
21     function getRandoms(uint range, uint num) public returns (uint[]){
22         require(msg.sender == ownerAddr);
23         require(range >= num);
24 
25         randoms = new uint[](num);
26         uint randNonce = 0;
27         for (uint i = 0; i < num; i++) {
28             randNonce++;
29             uint random = uint(keccak256(abi.encodePacked(now, randNonce))) % range + 1;
30             while (!checkUnique(random)) {
31                 randNonce++;
32                 random = uint(keccak256(abi.encodePacked(now, randNonce))) % range + 1;
33             }
34             randoms[i] = random;
35         }
36         return randoms;
37     }
38 
39     function checkUnique(uint random) private view returns (bool){
40         for (uint i = 0; i < randoms.length; i++) {
41             if (randoms[i] == random) {
42                 return false;
43             }
44         }
45         return true;
46     }
47 }