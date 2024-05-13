1 pragma solidity >=0.5.0;
2 
3 import '@uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol';
4 import '@uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol';
5 import '@uniswap/lib/contracts/libraries/Babylonian.sol';
6 import '@uniswap/lib/contracts/libraries/FullMath.sol';
7 
8 import './SafeMath.sol';
9 import './UniswapV2Library.sol';
10 
11 // library containing some math for dealing with the liquidity shares of a pair, e.g. computing their exact value
12 // in terms of the underlying tokens
13 library UniswapV2LiquidityMathLibrary {
14     using SafeMath for uint256;
15 
16     // computes the direction and magnitude of the profit-maximizing trade
17     function computeProfitMaximizingTrade(
18         uint256 truePriceTokenA,
19         uint256 truePriceTokenB,
20         uint256 reserveA,
21         uint256 reserveB
22     ) pure internal returns (bool aToB, uint256 amountIn) {
23         aToB = FullMath.mulDiv(reserveA, truePriceTokenB, reserveB) < truePriceTokenA;
24 
25         uint256 invariant = reserveA.mul(reserveB);
26 
27         uint256 leftSide = Babylonian.sqrt(
28             FullMath.mulDiv(
29                 invariant.mul(1000),
30                 aToB ? truePriceTokenA : truePriceTokenB,
31                 (aToB ? truePriceTokenB : truePriceTokenA).mul(997)
32             )
33         );
34         uint256 rightSide = (aToB ? reserveA.mul(1000) : reserveB.mul(1000)) / 997;
35 
36         if (leftSide < rightSide) return (false, 0);
37 
38         // compute the amount that must be sent to move the price to the profit-maximizing price
39         amountIn = leftSide.sub(rightSide);
40     }
41 
42     // gets the reserves after an arbitrage moves the price to the profit-maximizing ratio given an externally observed true price
43     function getReservesAfterArbitrage(
44         address factory,
45         address tokenA,
46         address tokenB,
47         uint256 truePriceTokenA,
48         uint256 truePriceTokenB
49     ) view internal returns (uint256 reserveA, uint256 reserveB) {
50         // first get reserves before the swap
51         (reserveA, reserveB) = UniswapV2Library.getReserves(factory, tokenA, tokenB);
52 
53         require(reserveA > 0 && reserveB > 0, 'UniswapV2ArbitrageLibrary: ZERO_PAIR_RESERVES');
54 
55         // then compute how much to swap to arb to the true price
56         (bool aToB, uint256 amountIn) = computeProfitMaximizingTrade(truePriceTokenA, truePriceTokenB, reserveA, reserveB);
57 
58         if (amountIn == 0) {
59             return (reserveA, reserveB);
60         }
61 
62         // now affect the trade to the reserves
63         if (aToB) {
64             uint amountOut = UniswapV2Library.getAmountOut(amountIn, reserveA, reserveB);
65             reserveA += amountIn;
66             reserveB -= amountOut;
67         } else {
68             uint amountOut = UniswapV2Library.getAmountOut(amountIn, reserveB, reserveA);
69             reserveB += amountIn;
70             reserveA -= amountOut;
71         }
72     }
73 
74     // computes liquidity value given all the parameters of the pair
75     function computeLiquidityValue(
76         uint256 reservesA,
77         uint256 reservesB,
78         uint256 totalSupply,
79         uint256 liquidityAmount,
80         bool feeOn,
81         uint kLast
82     ) internal pure returns (uint256 tokenAAmount, uint256 tokenBAmount) {
83         if (feeOn && kLast > 0) {
84             uint rootK = Babylonian.sqrt(reservesA.mul(reservesB));
85             uint rootKLast = Babylonian.sqrt(kLast);
86             if (rootK > rootKLast) {
87                 uint numerator1 = totalSupply;
88                 uint numerator2 = rootK.sub(rootKLast);
89                 uint denominator = rootK.mul(5).add(rootKLast);
90                 uint feeLiquidity = FullMath.mulDiv(numerator1, numerator2, denominator);
91                 totalSupply = totalSupply.add(feeLiquidity);
92             }
93         }
94         return (reservesA.mul(liquidityAmount) / totalSupply, reservesB.mul(liquidityAmount) / totalSupply);
95     }
96 
97     // get all current parameters from the pair and compute value of a liquidity amount
98     // **note this is subject to manipulation, e.g. sandwich attacks**. prefer passing a manipulation resistant price to
99     // #getLiquidityValueAfterArbitrageToPrice
100     function getLiquidityValue(
101         address factory,
102         address tokenA,
103         address tokenB,
104         uint256 liquidityAmount
105     ) internal view returns (uint256 tokenAAmount, uint256 tokenBAmount) {
106         (uint256 reservesA, uint256 reservesB) = UniswapV2Library.getReserves(factory, tokenA, tokenB);
107         IUniswapV2Pair pair = IUniswapV2Pair(UniswapV2Library.pairFor(factory, tokenA, tokenB));
108         bool feeOn = IUniswapV2Factory(factory).feeTo() != address(0);
109         uint kLast = feeOn ? pair.kLast() : 0;
110         uint totalSupply = pair.totalSupply();
111         return computeLiquidityValue(reservesA, reservesB, totalSupply, liquidityAmount, feeOn, kLast);
112     }
113 
114     // given two tokens, tokenA and tokenB, and their "true price", i.e. the observed ratio of value of token A to token B,
115     // and a liquidity amount, returns the value of the liquidity in terms of tokenA and tokenB
116     function getLiquidityValueAfterArbitrageToPrice(
117         address factory,
118         address tokenA,
119         address tokenB,
120         uint256 truePriceTokenA,
121         uint256 truePriceTokenB,
122         uint256 liquidityAmount
123     ) internal view returns (
124         uint256 tokenAAmount,
125         uint256 tokenBAmount
126     ) {
127         bool feeOn = IUniswapV2Factory(factory).feeTo() != address(0);
128         IUniswapV2Pair pair = IUniswapV2Pair(UniswapV2Library.pairFor(factory, tokenA, tokenB));
129         uint kLast = feeOn ? pair.kLast() : 0;
130         uint totalSupply = pair.totalSupply();
131 
132         // this also checks that totalSupply > 0
133         require(totalSupply >= liquidityAmount && liquidityAmount > 0, 'ComputeLiquidityValue: LIQUIDITY_AMOUNT');
134 
135         (uint reservesA, uint reservesB) = getReservesAfterArbitrage(factory, tokenA, tokenB, truePriceTokenA, truePriceTokenB);
136 
137         return computeLiquidityValue(reservesA, reservesB, totalSupply, liquidityAmount, feeOn, kLast);
138     }
139 }
