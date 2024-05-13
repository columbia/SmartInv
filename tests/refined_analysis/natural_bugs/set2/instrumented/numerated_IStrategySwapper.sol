1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity 0.8.9;
3 
4 import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
5 
6 interface IStrategySwapper {
7     function swapAllForWeth(address token) external;
8 
9     function swapAllWethForToken(address token_) external;
10 
11     function setSlippageTolerance(uint256 _slippageTolerance) external;
12 
13     function setSwapViaUniswap(address token_, bool swapViaUniswap_) external;
14 
15     function swapForWeth(address token, uint256 amount) external;
16 
17     function setCurvePool(address token_, address curvePool_) external;
18 
19     function amountOut(
20         address tokenIn_,
21         address tokenOut_,
22         uint256 amountIn
23     ) external view returns (uint256);
24 }
