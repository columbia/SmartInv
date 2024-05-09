1 pragma solidity ^0.5.0;
2 
3 library Hive1 {
4     function func() public { }
5 }
6 
7 library Hive2 {
8     function func() public {
9         Hive1.func();
10     }
11 }
12 
13 contract Bee {
14     function func() public {
15         Hive2.func();
16     }
17 
18     function die() public {
19         selfdestruct(msg.sender);
20     }
21 }