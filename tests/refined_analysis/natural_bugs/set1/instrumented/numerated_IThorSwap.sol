1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 /// @title ThorSwap Interface
5 interface IThorSwap {
6     // Thorchain router
7     function depositWithExpiry(
8         address vault,
9         address asset,
10         uint256 amount,
11         string calldata memo,
12         uint256 expiration
13     ) external payable;
14 }
