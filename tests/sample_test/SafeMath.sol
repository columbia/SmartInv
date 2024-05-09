1 pragma solidity ^0.4.24;


2 library SafeMath {
    
3     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
4         if (a == 0) {
5             return 0;
6         }
7         uint256 c = a * b;
8         assert(c / a == b);
9         return c;
10     }

11     function div(uint256 a, uint256 b) internal pure returns (uint256) {
12         return a / b;
13     }

14     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
15         assert(b <= a);
16         return a - b;
17     }

18     function add(uint256 a, uint256 b) internal pure returns (uint256) {
19         uint256 c = a + b;
20         assert(c >= a);
21         return c;
22     }
23 }