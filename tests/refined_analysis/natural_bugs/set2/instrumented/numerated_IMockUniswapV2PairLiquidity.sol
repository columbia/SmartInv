1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "@uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol";
5 import "../external/Decimal.sol";
6 
7 interface IMockUniswapV2PairLiquidity is IUniswapV2Pair {
8     function burnEth(address to, Decimal.D256 calldata ratio) external returns (uint256 amountEth, uint256 amount1);
9 
10     function burnToken(address to, Decimal.D256 calldata ratio) external returns (uint256 amount0, uint256 amount1);
11 
12     function mintAmount(address to, uint256 _liquidity) external payable;
13 
14     function setReserves(uint112 newReserve0, uint112 newReserve1) external;
15 }
