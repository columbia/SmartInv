1 1 pragma solidity ^0.4.24;
2 2 import "./../../Libraries/VeriSolContracts.sol";
3 3 //import "./VeriSolContracts.sol";
4 4 //import "github.com/microsoft/verisol/blob/master/Libraries/VeriSolContracts.sol";
5 
6 5 contract LoopFor {
7 
8 6     // test Loop invariant with for loop
9 7     constructor(uint n) public {
10 8         require (n >= 0);
11 9         uint y = 0;
12 10         for (uint x = n; x != 0; x --) {
13 11             y++;
14 12         }
15 13     }
16 
17 14     // test Loop invariant with while loop
18 15     function Foo(uint n) public {
19 16         require (n >= 0);
20 17         uint y = 0;
21 18         uint x = n;
22 19         while (x != 0) {
23 20             y++;
24 21             x--;
25 22         }
26 23     }
27 
28 24     // test Loop invariant with do-while loop    
29 25     function Bar(uint n) public {
30 
31 26         uint y = 0;
32 27         uint x = n;
33 28         do {
34 29             y++;
35 30             x--;
36 31         } while (x != 0);
37 32     }
38 33 }