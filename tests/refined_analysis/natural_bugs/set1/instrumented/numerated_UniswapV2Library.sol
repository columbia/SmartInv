1 // SPDX-License-Identifier: GPL-3.0
2 
3 pragma solidity >=0.5.0;
4 
5 import "@sushiswap/core/contracts/uniswapv2/interfaces/IUniswapV2Pair.sol";
6 
7 import "@sushiswap/core/contracts/uniswapv2/libraries/SafeMath.sol";
8 
9 library UniswapV2Library {
10     using SafeMathUniswap for uint256;
11 
12     // returns sorted token addresses, used to handle return values from pairs sorted in this order
13     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
14         require(tokenA != tokenB, "UniswapV2Library: IDENTICAL_ADDRESSES");
15         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
16         require(token0 != address(0), "UniswapV2Library: ZERO_ADDRESS");
17     }
18 
19     // calculates the CREATE2 address for a pair without making any external calls
20     function pairFor(
21         address factory,
22         address tokenA,
23         address tokenB,
24         bytes32 pairCodeHash
25     ) internal pure returns (address pair) {
26         (address token0, address token1) = sortTokens(tokenA, tokenB);
27         pair = address(
28             uint256(
29                 keccak256(
30                     abi.encodePacked(
31                         hex"ff",
32                         factory,
33                         keccak256(abi.encodePacked(token0, token1)),
34                         pairCodeHash // init code hash
35                     )
36                 )
37             )
38         );
39     }
40 
41     // fetches and sorts the reserves for a pair
42     function getReserves(
43         address factory,
44         address tokenA,
45         address tokenB,
46         bytes32 pairCodeHash
47     ) internal view returns (uint256 reserveA, uint256 reserveB) {
48         (address token0, ) = sortTokens(tokenA, tokenB);
49         (uint256 reserve0, uint256 reserve1, ) = IUniswapV2Pair(pairFor(factory, tokenA, tokenB, pairCodeHash)).getReserves();
50         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
51     }
52 
53     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
54     function quote(
55         uint256 amountA,
56         uint256 reserveA,
57         uint256 reserveB
58     ) internal pure returns (uint256 amountB) {
59         require(amountA > 0, "UniswapV2Library: INSUFFICIENT_AMOUNT");
60         require(reserveA > 0 && reserveB > 0, "UniswapV2Library: INSUFFICIENT_LIQUIDITY");
61         amountB = amountA.mul(reserveB) / reserveA;
62     }
63 
64     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
65     function getAmountOut(
66         uint256 amountIn,
67         uint256 reserveIn,
68         uint256 reserveOut
69     ) internal pure returns (uint256 amountOut) {
70         require(amountIn > 0, "UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT");
71         require(reserveIn > 0 && reserveOut > 0, "UniswapV2Library: INSUFFICIENT_LIQUIDITY");
72         uint256 amountInWithFee = amountIn.mul(997);
73         uint256 numerator = amountInWithFee.mul(reserveOut);
74         uint256 denominator = reserveIn.mul(1000).add(amountInWithFee);
75         amountOut = numerator / denominator;
76     }
77 
78     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
79     function getAmountIn(
80         uint256 amountOut,
81         uint256 reserveIn,
82         uint256 reserveOut
83     ) internal pure returns (uint256 amountIn) {
84         require(amountOut > 0, "UniswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT");
85         require(reserveIn > 0 && reserveOut > 0, "UniswapV2Library: INSUFFICIENT_LIQUIDITY");
86         uint256 numerator = reserveIn.mul(amountOut).mul(1000);
87         uint256 denominator = reserveOut.sub(amountOut).mul(997);
88         amountIn = (numerator / denominator).add(1);
89     }
90 
91     // performs chained getAmountOut calculations on any number of pairs
92     function getAmountsOut(
93         address factory,
94         uint256 amountIn,
95         address[] memory path,
96         bytes32 pairCodeHash
97     ) internal view returns (uint256[] memory amounts) {
98         require(path.length >= 2, "UniswapV2Library: INVALID_PATH");
99         amounts = new uint256[](path.length);
100         amounts[0] = amountIn;
101         for (uint256 i; i < path.length - 1; i++) {
102             (uint256 reserveIn, uint256 reserveOut) = getReserves(factory, path[i], path[i + 1], pairCodeHash);
103             amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
104         }
105     }
106 
107     // performs chained getAmountIn calculations on any number of pairs
108     function getAmountsIn(
109         address factory,
110         uint256 amountOut,
111         address[] memory path,
112         bytes32 pairCodeHash
113     ) internal view returns (uint256[] memory amounts) {
114         require(path.length >= 2, "UniswapV2Library: INVALID_PATH");
115         amounts = new uint256[](path.length);
116         amounts[amounts.length - 1] = amountOut;
117         for (uint256 i = path.length - 1; i > 0; i--) {
118             (uint256 reserveIn, uint256 reserveOut) = getReserves(factory, path[i - 1], path[i], pairCodeHash);
119             amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
120         }
121     }
122 }
