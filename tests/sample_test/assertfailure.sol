1 pragma solidity >=0.4.24 <0.6.0;
2 
3 contract TestAssert {
4 
5     function test1() public {
6               _;
7 
8     }
9 
10     function test2() public {
11         assert (!(1 > 5));
12     }
13 