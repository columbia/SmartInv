1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 interface ISquidMulticall {
5     enum CallType {
6         Default,
7         FullTokenBalance,
8         FullNativeBalance,
9         CollectTokenBalance
10     }
11 
12     struct Call {
13         CallType callType;
14         address target;
15         uint256 value;
16         bytes callData;
17         bytes payload;
18     }
19 }
