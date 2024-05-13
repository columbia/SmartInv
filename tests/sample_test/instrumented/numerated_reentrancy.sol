1 1 pragma solidity ^0.6.1;
2 
3 
4 2 contract Reentrency {
5 3     uint frames = 0;
6 4     A a;
7 
8 5     function init(uint x) public {
9 6         if (x*2  - 5 == 39) // x == 22
10 7             if (a == A(address(0x0)))
11 8                 a = new A();
12 9     }
13 
14 10     function enter(uint x, uint y) public {
15 11         if (frames > 1)
16 12             return;
17 
18 13         frames += 1;
19 14         if (x*3 + 22 == 25) // x == 1
20 15             if (a != A(address(0x0)))
21 16                 a.enter(address(this), x, y);
22 17         frames -= 1;
23 18     }
24 
25 19     function check() public returns (int) {
26 20         if (frames == 2)
27 21             return 0; // test::coverage
28 22         else if (frames == 1)
29 23             return -1; // test::coverage
30 24         else
31 25             return -2; // test::coverage
32 26     }
33 
34 27 }
35 
36 28 // Some dummy contract
37 29 contract A {
38 
39 30     function enter(address c, uint x, uint y) public {
40 31         uint key = 1000000;
41 32         if (y+10 == key*10)
42 33             Reentrency(c).check();
43 34         else
44 35             Reentrency(c).enter(x, y + key);
45 36     }
46 37 }