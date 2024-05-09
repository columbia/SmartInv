1 pragma solidity ^0.4.24;
2 import "./../../Libraries/VeriSolContracts.sol";
3 //import "./VeriSolContracts.sol";
4 //import "github.com/microsoft/verisol/blob/master/Libraries/VeriSolContracts.sol";

5 contract LoopFor {

6     // test Loop invariant with for loop
7     constructor(uint n) public {
8         require (n >= 0);
9         uint y = 0;
10         for (uint x = n; x != 0; x --) {
11             y++;
12         }
13     }

14     // test Loop invariant with while loop
15     function Foo(uint n) public {
16         require (n >= 0);
17         uint y = 0;
18         uint x = n;
19         while (x != 0) {
20             y++;
21             x--;
22         }
23     }

24     // test Loop invariant with do-while loop    
25     function Bar(uint n) public {

26         uint y = 0;
27         uint x = n;
28         do {
29             y++;
30             x--;
31         } while (x != 0);
32     }
33 }