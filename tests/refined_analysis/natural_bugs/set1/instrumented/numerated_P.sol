1 //SPDX-License-Identifier: MIT
2 pragma solidity =0.7.6;
3 pragma experimental ABIEncoderV2;
4 
5 contract P {
6     struct Pool {
7         address pool;
8         address[2] tokens;
9         uint256[2] balances;
10         uint256 price;
11         uint256 liquidity;
12         int256 deltaB;
13         uint256 lpUsd;
14         uint256 lpBdv;
15     }
16 
17     struct Prices {
18         address pool;
19         address[] tokens;
20         uint256 price;
21         uint256 liquidity;
22         int deltaB;
23         P.Pool[] ps;
24     }
25 }