1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.5.0;
4 
5 import '../interfaces/IBabyFactory.sol';
6 import '../interfaces/IBabyPair.sol';
7 import "./SafeMath.sol";
8 import "hardhat/console.sol";
9 
10 library BabyLibrarySmartRouter {
11     using SafeMath for uint;
12 
13     uint constant FEE_BASE = 1000000;
14 
15     // returns sorted token addresses, used to handle return values from pairs sorted in this order
16     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
17         require(tokenA != tokenB, 'BabyLibrary: IDENTICAL_ADDRESSES');
18         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
19         require(token0 != address(0), 'BabyLibrary: ZERO_ADDRESS');
20     }
21 
22     // calculates the CREATE2 address for a pair without making any external calls
23     function pairFor(address factory, address tokenA, address tokenB) internal view returns (address pair) {
24         return IBabyFactory(factory).getPair(tokenA, tokenB);
25     }
26 
27     // fetches and sorts the reserves for a pair
28     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
29         (address token0,) = sortTokens(tokenA, tokenB);
30         pairFor(factory, tokenA, tokenB);
31         (uint reserve0, uint reserve1,) = IBabyPair(pairFor(factory, tokenA, tokenB)).getReserves();
32         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
33     }
34 
35     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
36     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
37         require(amountA > 0, 'BabyLibrary: INSUFFICIENT_AMOUNT');
38         require(reserveA > 0 && reserveB > 0, 'BabyLibrary: INSUFFICIENT_LIQUIDITY');
39         amountB = amountA.mul(reserveB) / reserveA;
40     }
41 
42     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
43     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
44         require(amountIn > 0, 'BabyLibrary: INSUFFICIENT_INPUT_AMOUNT');
45         require(reserveIn > 0 && reserveOut > 0, 'BabyLibrary: INSUFFICIENT_LIQUIDITY');
46         uint amountInWithFee = amountIn.mul(997);
47         uint numerator = amountInWithFee.mul(reserveOut);
48         uint denominator = reserveIn.mul(1000).add(amountInWithFee);
49         amountOut = numerator / denominator;
50     }
51 
52     function getAmountOutWithFee(uint amountIn, uint reserveIn, uint reserveOut, uint fee) internal pure returns (uint amountOut) {
53         require(amountIn > 0, 'BabyLibrary: INSUFFICIENT_INPUT_AMOUNT');
54         require(reserveIn > 0 && reserveOut > 0, 'BabyLibrary: INSUFFICIENT_LIQUIDITY');
55         uint amountInWithFee = amountIn.mul(FEE_BASE.sub(fee));
56         uint numerator = amountInWithFee.mul(reserveOut);
57         uint denominator = reserveIn.mul(FEE_BASE).add(amountInWithFee);
58         amountOut = numerator / denominator;
59     }
60 
61     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
62     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {
63         require(amountOut > 0, 'BabyLibrary: INSUFFICIENT_OUTPUT_AMOUNT');
64         require(reserveIn > 0 && reserveOut > 0, 'BabyLibrary: INSUFFICIENT_LIQUIDITY');
65         uint numerator = reserveIn.mul(amountOut).mul(1000);
66         uint denominator = reserveOut.sub(amountOut).mul(997);
67         amountIn = (numerator / denominator).add(1);
68     }
69 
70     function getAmountInWithFee(uint amountOut, uint reserveIn, uint reserveOut, uint fee) internal pure returns (uint amountIn) {
71         require(amountOut > 0, 'BabyLibrary: INSUFFICIENT_OUTPUT_AMOUNT');
72         require(reserveIn > 0 && reserveOut > 0, 'BabyLibrary: INSUFFICIENT_LIQUIDITY');
73         uint numerator = reserveIn.mul(amountOut).mul(FEE_BASE);
74         uint denominator = reserveOut.sub(amountOut).mul(FEE_BASE.sub(fee));
75         amountIn = (numerator / denominator).add(1);
76     }
77 
78     // performs chained getAmountOut calculations on any number of pairs
79     function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {
80         require(path.length >= 2, 'BabyLibrary: INVALID_PATH');
81         amounts = new uint[](path.length);
82         amounts[0] = amountIn;
83         for (uint i; i < path.length - 1; i++) {
84             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);
85             amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
86         }
87     }
88 
89     // performs chained getAmountOut calculations on any number of pairs
90     function getAggregationAmountsOut(address[] memory factories, uint[] memory fees, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {
91         require(path.length >= 2 && path.length - 1 == factories.length && factories.length == fees.length, 'BabyLibrary: INVALID_PATH');
92         amounts = new uint[](path.length);
93         amounts[0] = amountIn;
94         for (uint i; i < path.length - 1; i++) {
95             (uint reserveIn, uint reserveOut) = getReserves(factories[i], path[i], path[i + 1]);
96             amounts[i + 1] = getAmountOutWithFee(amounts[i], reserveIn, reserveOut, fees[i]);
97             console.log("reserveIn, reserveOut", reserveIn, reserveOut);
98         }
99     }
100 
101     // performs chained getAmountIn calculations on any number of pairs
102     function getAmountsIn(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {
103         require(path.length >= 2, 'BabyLibrary: INVALID_PATH');
104         amounts = new uint[](path.length);
105         amounts[amounts.length - 1] = amountOut;
106         for (uint i = path.length - 1; i > 0; i--) {
107             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);
108             amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
109         }
110     }
111 
112     function getAggregationAmountsIn(address[] memory factories, uint[] memory fees, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {
113         require(path.length >= 2 && path.length - 1 == factories.length && factories.length == fees.length, 'BabyLibrary: INVALID_PATH');
114         amounts = new uint[](path.length);
115         amounts[amounts.length - 1] = amountOut;
116         for (uint i = path.length - 1; i > 0; i--) {
117             (uint reserveIn, uint reserveOut) = getReserves(factories[i - 1], path[i - 1], path[i]);
118             amounts[i - 1] = getAmountInWithFee(amounts[i], reserveIn, reserveOut, fees[i - 1]);
119         }
120     }
121 }
