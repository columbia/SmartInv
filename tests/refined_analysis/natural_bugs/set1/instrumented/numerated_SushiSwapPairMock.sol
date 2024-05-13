1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.6.12;
3 import "@sushiswap/core/contracts/uniswapv2/UniswapV2Pair.sol";
4 
5 contract SushiSwapPairMock is UniswapV2Pair {
6     constructor() public UniswapV2Pair() {
7         return;
8     }
9 }
