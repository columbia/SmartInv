1 pragma solidity ^0.4.0;
2 
3 contract TestRevert {
4     function test_require() public {
5         require(now < 1000);
6     }
7 
8     function test_assert() public {
9         assert(now < 1000);
10     }
11 }