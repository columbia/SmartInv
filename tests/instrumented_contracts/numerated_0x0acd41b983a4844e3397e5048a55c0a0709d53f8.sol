1 /**
2  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
3  *
4  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
5  */
6 pragma solidity ^0.4.6;
7 /**
8  * Safe unsigned safe math.
9  *
10  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
11  *
12  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
13  *
14  * Maintained here until merged to mainline zeppelin-solidity.
15  *
16  */
17 library SafeMathLibExt {
18   function times(uint a, uint b) returns (uint) {
19     uint c = a * b;
20     assert(a == 0 || c / a == b);
21     return c;
22   }
23   function divides(uint a, uint b) returns (uint) {
24     assert(b > 0);
25     uint c = a / b;
26     assert(a == b * c + a % b);
27     return c;
28   }
29   function minus(uint a, uint b) returns (uint) {
30     assert(b <= a);
31     return a - b;
32   }
33   function plus(uint a, uint b) returns (uint) {
34     uint c = a + b;
35     assert(c>=a);
36     return c;
37   }
38 }