1 // Created using Token Wizard https://github.com/poanetwork/token-wizard by POA Network 
2 /**
3  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
4  *
5  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
6  */
7 
8 pragma solidity ^0.4.6;
9 
10 /**
11  * Safe unsigned safe math.
12  *
13  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
14  *
15  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
16  *
17  * Maintained here until merged to mainline zeppelin-solidity.
18  *
19  */
20 library SafeMathLibExt {
21 
22   function times(uint a, uint b) returns (uint) {
23     uint c = a * b;
24     assert(a == 0 || c / a == b);
25     return c;
26   }
27 
28   function divides(uint a, uint b) returns (uint) {
29     assert(b > 0);
30     uint c = a / b;
31     assert(a == b * c + a % b);
32     return c;
33   }
34 
35   function minus(uint a, uint b) returns (uint) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   function plus(uint a, uint b) returns (uint) {
41     uint c = a + b;
42     assert(c>=a);
43     return c;
44   }
45 
46 }