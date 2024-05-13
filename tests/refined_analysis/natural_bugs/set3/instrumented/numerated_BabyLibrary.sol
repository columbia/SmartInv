1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.5.0;
4 
5 import '../interfaces/IBabyPair.sol';
6 import "./SafeMath.sol";
7 
8 library BabyLibrary {
9     using SafeMath for uint;
10 
11     // returns sorted token addresses, used to handle return values from pairs sorted in this order
12     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
13         require(tokenA != tokenB, 'LibraryLibrary: IDENTICAL_ADDRESSES');
14         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
15         require(token0 != address(0), 'LibraryLibrary: ZERO_ADDRESS');
16     }
17 
18     // calculates the CREATE2 address for a pair without making any external calls
19     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
20         (address token0, address token1) = sortTokens(tokenA, tokenB);
21         pair = address(uint(keccak256(abi.encodePacked(
22                 hex'ff',
23                 factory,
24                 keccak256(abi.encodePacked(token0, token1)),
25                 hex'48c8bec5512d397a5d512fbb7d83d515e7b6d91e9838730bd1aa1b16575da7f5'
26             ))));
27     }
28 
29     // fetches and sorts the reserves for a pair
30     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
31         (address token0,) = sortTokens(tokenA, tokenB);
32         (uint reserve0, uint reserve1,) = IBabyPair(pairFor(factory, tokenA, tokenB)).getReserves();
33         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
34     }
35 
36     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
37     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
38         require(amountA > 0, 'LibraryLibrary: INSUFFICIENT_AMOUNT');
39         require(reserveA > 0 && reserveB > 0, 'LibraryLibrary: INSUFFICIENT_LIQUIDITY');
40         amountB = amountA.mul(reserveB) / reserveA;
41     }
42 
43     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
44     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
45         require(amountIn > 0, 'LibraryLibrary: INSUFFICIENT_INPUT_AMOUNT');
46         require(reserveIn > 0 && reserveOut > 0, 'LibraryLibrary: INSUFFICIENT_LIQUIDITY');
47         uint amountInWithFee = amountIn.mul(997);
48         uint numerator = amountInWithFee.mul(reserveOut);
49         uint denominator = reserveIn.mul(1000).add(amountInWithFee);
50         amountOut = numerator / denominator;
51     }
52 
53     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
54     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {
55         require(amountOut > 0, 'LibraryLibrary: INSUFFICIENT_OUTPUT_AMOUNT');
56         require(reserveIn > 0 && reserveOut > 0, 'LibraryLibrary: INSUFFICIENT_LIQUIDITY');
57         uint numerator = reserveIn.mul(amountOut).mul(1000);
58         uint denominator = reserveOut.sub(amountOut).mul(997);
59         amountIn = (numerator / denominator).add(1);
60     }
61 
62     // performs chained getAmountOut calculations on any number of pairs
63     function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {
64         require(path.length >= 2, 'LibraryLibrary: INVALID_PATH');
65         amounts = new uint[](path.length);
66         amounts[0] = amountIn;
67         for (uint i; i < path.length - 1; i++) {
68             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);
69             amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
70         }
71     }
72 
73     // performs chained getAmountIn calculations on any number of pairs
74     function getAmountsIn(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {
75         require(path.length >= 2, 'LibraryLibrary: INVALID_PATH');
76         amounts = new uint[](path.length);
77         amounts[amounts.length - 1] = amountOut;
78         for (uint i = path.length - 1; i > 0; i--) {
79             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);
80             amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
81         }
82     }
83 }
