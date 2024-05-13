1 // SPDX-License-Identifier: GPL-2.0-or-later
2 pragma solidity ^0.8.0;
3 
4 // Simplest possible periphery implementation, used for testing integration with the
5 // real uniswap core contracts.
6 
7 // Adapted from uniswap-v3-periphery/contracts/test/TestUniswapV3Callee.sol
8 
9 import "../Interfaces.sol";
10 
11 interface IUniswapV3Pool {
12     function token0() external view returns (address);
13     function token1() external view returns (address);
14     function mint(address recipient, int24 tickLower, int24 tickUpper, uint128 amount, bytes calldata data) external returns (uint256 amount0, uint256 amount1);
15     function swap(address recipient, bool zeroForOne, int256 amountSpecified, uint160 sqrtPriceLimitX96, bytes calldata data) external returns (int256 amount0, int256 amount1);
16 }
17 
18 contract SimpleUniswapPeriphery {
19     function swapExact0For1(
20         address pool,
21         uint256 amount0In,
22         address recipient,
23         uint160 sqrtPriceLimitX96
24     ) external {
25         IUniswapV3Pool(pool).swap(recipient, true, int(amount0In), sqrtPriceLimitX96, abi.encode(msg.sender));
26     }
27 
28     function swap0ForExact1(
29         address pool,
30         uint256 amount1Out,
31         address recipient,
32         uint160 sqrtPriceLimitX96
33     ) external {
34         IUniswapV3Pool(pool).swap(recipient, true, -int(amount1Out), sqrtPriceLimitX96, abi.encode(msg.sender));
35     }
36 
37     function swapExact1For0(
38         address pool,
39         uint256 amount1In,
40         address recipient,
41         uint160 sqrtPriceLimitX96
42     ) external {
43         IUniswapV3Pool(pool).swap(recipient, false, int(amount1In), sqrtPriceLimitX96, abi.encode(msg.sender));
44     }
45 
46     function swap1ForExact0(
47         address pool,
48         uint256 amount0Out,
49         address recipient,
50         uint160 sqrtPriceLimitX96
51     ) external {
52         IUniswapV3Pool(pool).swap(recipient, false, int(amount0Out), sqrtPriceLimitX96, abi.encode(msg.sender));
53     }
54 
55     function swapToLowerSqrtPrice(
56         address pool,
57         uint160 sqrtPriceX96,
58         address recipient
59     ) external {
60         IUniswapV3Pool(pool).swap(recipient, true, type(int256).max, sqrtPriceX96, abi.encode(msg.sender));
61     }
62 
63     function swapToHigherSqrtPrice(
64         address pool,
65         uint160 sqrtPriceX96,
66         address recipient
67     ) external {
68         IUniswapV3Pool(pool).swap(recipient, false, type(int256).max, sqrtPriceX96, abi.encode(msg.sender));
69     }
70 
71     function uniswapV3SwapCallback(
72         int256 amount0Delta,
73         int256 amount1Delta,
74         bytes calldata data
75     ) external {
76         address sender = abi.decode(data, (address));
77 
78         if (amount0Delta > 0) {
79             IERC20(IUniswapV3Pool(msg.sender).token0()).transferFrom(sender, msg.sender, uint256(amount0Delta));
80         } else if (amount1Delta > 0) {
81             IERC20(IUniswapV3Pool(msg.sender).token1()).transferFrom(sender, msg.sender, uint256(amount1Delta));
82         } else {
83             // if both are not gt 0, both must be 0.
84             assert(amount0Delta == 0 && amount1Delta == 0);
85         }
86     }
87 
88     function mint(
89         address pool,
90         address recipient,
91         int24 tickLower,
92         int24 tickUpper,
93         uint128 amount
94     ) external {
95         IUniswapV3Pool(pool).mint(recipient, tickLower, tickUpper, amount, abi.encode(msg.sender));
96     }
97 
98     function uniswapV3MintCallback(
99         uint256 amount0Owed,
100         uint256 amount1Owed,
101         bytes calldata data
102     ) external {
103         address sender = abi.decode(data, (address));
104 
105         if (amount0Owed > 0)
106             IERC20(IUniswapV3Pool(msg.sender).token0()).transferFrom(sender, msg.sender, amount0Owed);
107         if (amount1Owed > 0)
108             IERC20(IUniswapV3Pool(msg.sender).token1()).transferFrom(sender, msg.sender, amount1Owed);
109     }
110 }
