1 pragma solidity >=0.5.0;
2 
3 import '@uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol';
4 import '@uniswap/lib/contracts/libraries/FixedPoint.sol';
5 
6 // library with helper methods for oracles that are concerned with computing average prices
7 library UniswapV2OracleLibrary {
8     using FixedPoint for *;
9 
10     // helper function that returns the current block timestamp within the range of uint32, i.e. [0, 2**32 - 1]
11     function currentBlockTimestamp() internal view returns (uint32) {
12         return uint32(block.timestamp % 2 ** 32);
13     }
14 
15     // produces the cumulative price using counterfactuals to save gas and avoid a call to sync.
16     function currentCumulativePrices(
17         address pair
18     ) internal view returns (uint price0Cumulative, uint price1Cumulative, uint32 blockTimestamp) {
19         blockTimestamp = currentBlockTimestamp();
20         price0Cumulative = IUniswapV2Pair(pair).price0CumulativeLast();
21         price1Cumulative = IUniswapV2Pair(pair).price1CumulativeLast();
22 
23         // if time has elapsed since the last update on the pair, mock the accumulated price values
24         (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast) = IUniswapV2Pair(pair).getReserves();
25         if (blockTimestampLast != blockTimestamp) {
26             // subtraction overflow is desired
27             uint32 timeElapsed = blockTimestamp - blockTimestampLast;
28             // addition overflow is desired
29             // counterfactual
30             price0Cumulative += uint(FixedPoint.fraction(reserve1, reserve0)._x) * timeElapsed;
31             // counterfactual
32             price1Cumulative += uint(FixedPoint.fraction(reserve0, reserve1)._x) * timeElapsed;
33         }
34     }
35 }
