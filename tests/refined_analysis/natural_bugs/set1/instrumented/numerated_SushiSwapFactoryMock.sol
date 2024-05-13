1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.6.12;
3 import "@sushiswap/core/contracts/uniswapv2/interfaces/IUniswapV2Factory.sol";
4 import "@sushiswap/core/contracts/uniswapv2/UniswapV2Factory.sol";
5 
6 contract SushiSwapFactoryMock is UniswapV2Factory {
7     constructor() public UniswapV2Factory(msg.sender) {
8         return;
9     }
10 }
