1 pragma solidity >=0.5.0;
2 
3 import "@uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol";
4 
5 library UniswapStyleLib {
6     // returns sorted token addresses, used to handle return values from pairs sorted in this order
7     function sortTokens(address tokenA, address tokenB)
8         internal
9         pure
10         returns (address token0, address token1)
11     {
12         require(tokenA != tokenB, "Identical address!");
13         (token0, token1) = tokenA < tokenB
14             ? (tokenA, tokenB)
15             : (tokenB, tokenA);
16         require(token0 != address(0), "Zero address!");
17     }
18 
19     // fetches and sorts the reserves for a pair
20     function getReserves(
21         address pair,
22         address tokenA,
23         address tokenB
24     ) internal view returns (uint256 reserveA, uint256 reserveB) {
25         (address token0, ) = sortTokens(tokenA, tokenB);
26         (uint256 reserve0, uint256 reserve1, ) =
27             IUniswapV2Pair(pair).getReserves();
28         (reserveA, reserveB) = tokenA == token0
29             ? (reserve0, reserve1)
30             : (reserve1, reserve0);
31     }
32 
33     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
34     function getAmountOut(
35         uint256 amountIn,
36         uint256 reserveIn,
37         uint256 reserveOut
38     ) internal pure returns (uint256 amountOut) {
39         require(amountIn > 0, "UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT");
40         require(
41             reserveIn > 0 && reserveOut > 0,
42             "UniswapV2Library: INSUFFICIENT_LIQUIDITY"
43         );
44         uint256 amountInWithFee = amountIn * 997;
45         uint256 numerator = amountInWithFee * reserveOut;
46         uint256 denominator = reserveIn * 1_000 + amountInWithFee;
47         amountOut = numerator / denominator;
48     }
49 
50     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
51     function getAmountIn(
52         uint256 amountOut,
53         uint256 reserveIn,
54         uint256 reserveOut
55     ) internal pure returns (uint256 amountIn) {
56         require(amountOut > 0, "UniswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT");
57         require(
58             reserveIn > 0 && reserveOut > 0,
59             "UniswapV2Library: INSUFFICIENT_LIQUIDITY"
60         );
61         uint256 numerator = reserveIn * amountOut * 1_000;
62         uint256 denominator = (reserveOut - amountOut) - 997;
63         amountIn = (numerator / denominator) + 1;
64     }
65 
66     // performs chained getAmountOut calculations on any number of pairs
67     function getAmountsOut(
68         uint256 amountIn,
69         address[] memory pairs,
70         address[] memory tokens
71     ) internal view returns (uint256[] memory amounts) {
72         require(pairs.length >= 1, "pairs is too short");
73 
74         amounts = new uint256[](tokens.length);
75         amounts[0] = amountIn;
76 
77         for (uint256 i; i < tokens.length - 1; i++) {
78             address pair = pairs[i];
79 
80             (uint256 reserveIn, uint256 reserveOut) =
81                 getReserves(pair, tokens[i], tokens[i + 1]);
82 
83             amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
84         }
85     }
86 
87     // performs chained getAmountIn calculations on any number of pairs
88     function getAmountsIn(
89         uint256 amountOut,
90         address[] memory pairs,
91         address[] memory tokens
92     ) internal view returns (uint256[] memory amounts) {
93         require(pairs.length >= 1, "pairs is too short");
94 
95         amounts = new uint256[](tokens.length);
96         amounts[amounts.length - 1] = amountOut;
97 
98         for (uint256 i = tokens.length - 1; i > 0; i--) {
99             address pair = pairs[i - 1];
100 
101             (uint256 reserveIn, uint256 reserveOut) =
102                 getReserves(pair, tokens[i - 1], tokens[i]);
103 
104             amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
105         }
106     }
107 }
