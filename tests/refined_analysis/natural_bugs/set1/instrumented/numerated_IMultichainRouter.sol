1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 interface IMultichainRouter {
5     function anySwapOutUnderlying(
6         address token,
7         address to,
8         uint256 amount,
9         uint256 toChainID
10     ) external;
11 
12     function anySwapOut(
13         address token,
14         address to,
15         uint256 amount,
16         uint256 toChainID
17     ) external;
18 
19     function anySwapOutNative(
20         address token,
21         address to,
22         uint256 toChainID
23     ) external payable;
24 
25     function wNATIVE() external returns (address);
26 }
