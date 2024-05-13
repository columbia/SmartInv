1 /*
2 
3     Copyright 2020 DODO ZOO.
4     SPDX-License-Identifier: Apache-2.0
5 
6 */
7 
8 pragma solidity 0.6.9;
9 pragma experimental ABIEncoderV2;
10 
11 interface IDODOCallee {
12     function dodoCall(
13         bool isBuyBaseToken,
14         uint256 baseAmount,
15         uint256 quoteAmount,
16         bytes calldata data
17     ) external;
18 }
