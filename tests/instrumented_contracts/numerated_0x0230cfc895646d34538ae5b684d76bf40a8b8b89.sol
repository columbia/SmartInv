1 pragma solidity ^0.4.4;
2 
3 contract Random {
4   uint64 _seed = 0;
5 
6   // return a pseudo random number between lower and upper bounds
7   // given the number of previous blocks it should hash.
8   function random(uint64 upper) public returns (uint64 randomNumber) {
9     _seed = uint64(sha3(sha3(block.blockhash(block.number), _seed), now));
10     return _seed % upper;
11   }
12 }