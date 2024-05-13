1 1 pragma solidity ^0.4.24;
2 
3 
4 2 library SafeMath {
5     
6 3     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
7 4         if (a == 0) {
8 5             return 0;
9 6         }
10 7         uint256 c = a * b;
11 8         assert(c / a == b);
12 9         return c;
13 10     }
14 
15 11     function div(uint256 a, uint256 b) internal pure returns (uint256) {
16 12         return a / b;
17 13     }
18 
19 14     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20 15         assert(b <= a);
21 16         return a - b;
22 17     }
23 
24 18     function add(uint256 a, uint256 b) internal pure returns (uint256) {
25 19         uint256 c = a + b;
26 20         assert(c >= a);
27 21         return c;
28 22     }
29 23 }