1 1 pragma solidity >=0.4.24 <0.6.0;
2 2 
3 3 contract TestAssert {
4 4 
5 5     function test1() public {
6 6               _;
7 7 
8 8     }
9 9 
10 10     function test2() public {
11 11         assert (!(1 > 5));
12 12     }
13 13 