1 pragma solidity ^0.6.1;


2 contract Reentrency {
3     uint frames = 0;
4     A a;

5     function init(uint x) public {
6         if (x*2  - 5 == 39) // x == 22
7             if (a == A(address(0x0)))
8                 a = new A();
9     }

10     function enter(uint x, uint y) public {
11         if (frames > 1)
12             return;

13         frames += 1;
14         if (x*3 + 22 == 25) // x == 1
15             if (a != A(address(0x0)))
16                 a.enter(address(this), x, y);
17         frames -= 1;
18     }

19     function check() public returns (int) {
20         if (frames == 2)
21             return 0; // test::coverage
22         else if (frames == 1)
23             return -1; // test::coverage
24         else
25             return -2; // test::coverage
26     }

27 }

28 // Some dummy contract
29 contract A {

30     function enter(address c, uint x, uint y) public {
31         uint key = 1000000;
32         if (y+10 == key*10)
33             Reentrency(c).check();
34         else
35             Reentrency(c).enter(x, y + key);
36     }
37 }