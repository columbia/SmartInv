1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 // https://github.com/bcnmy/hyphen-contract/blob/master/contracts/hyphen/LiquidityPool.sol
5 interface IHyphenRouter {
6     function depositErc20(
7         uint256 toChainId,
8         address tokenAddress,
9         address receiver,
10         uint256 amount,
11         string calldata tag
12     ) external;
13 
14     function depositNative(
15         address receiver,
16         uint256 toChainId,
17         string calldata tag
18     ) external payable;
19 }
