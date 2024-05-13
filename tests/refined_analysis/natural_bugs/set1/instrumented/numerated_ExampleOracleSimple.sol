1 pragma solidity =0.6.6;
2 
3 import '@uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol';
4 import '@uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol';
5 import '@uniswap/lib/contracts/libraries/FixedPoint.sol';
6 
7 import '../libraries/UniswapV2OracleLibrary.sol';
8 import '../libraries/UniswapV2Library.sol';
9 
10 // fixed window oracle that recomputes the average price for the entire period once every period
11 // note that the price average is only guaranteed to be over at least 1 period, but may be over a longer period
12 contract ExampleOracleSimple {
13     using FixedPoint for *;
14 
15     uint public constant PERIOD = 24 hours;
16 
17     IUniswapV2Pair immutable pair;
18     address public immutable token0;
19     address public immutable token1;
20 
21     uint    public price0CumulativeLast;
22     uint    public price1CumulativeLast;
23     uint32  public blockTimestampLast;
24     FixedPoint.uq112x112 public price0Average;
25     FixedPoint.uq112x112 public price1Average;
26 
27     constructor(address factory, address tokenA, address tokenB) public {
28         IUniswapV2Pair _pair = IUniswapV2Pair(UniswapV2Library.pairFor(factory, tokenA, tokenB));
29         pair = _pair;
30         token0 = _pair.token0();
31         token1 = _pair.token1();
32         price0CumulativeLast = _pair.price0CumulativeLast(); // fetch the current accumulated price value (1 / 0)
33         price1CumulativeLast = _pair.price1CumulativeLast(); // fetch the current accumulated price value (0 / 1)
34         uint112 reserve0;
35         uint112 reserve1;
36         (reserve0, reserve1, blockTimestampLast) = _pair.getReserves();
37         require(reserve0 != 0 && reserve1 != 0, 'ExampleOracleSimple: NO_RESERVES'); // ensure that there's liquidity in the pair
38     }
39 
40     function update() external {
41         (uint price0Cumulative, uint price1Cumulative, uint32 blockTimestamp) =
42             UniswapV2OracleLibrary.currentCumulativePrices(address(pair));
43         uint32 timeElapsed = blockTimestamp - blockTimestampLast; // overflow is desired
44 
45         // ensure that at least one full period has passed since the last update
46         require(timeElapsed >= PERIOD, 'ExampleOracleSimple: PERIOD_NOT_ELAPSED');
47 
48         // overflow is desired, casting never truncates
49         // cumulative price is in (uq112x112 price * seconds) units so we simply wrap it after division by time elapsed
50         price0Average = FixedPoint.uq112x112(uint224((price0Cumulative - price0CumulativeLast) / timeElapsed));
51         price1Average = FixedPoint.uq112x112(uint224((price1Cumulative - price1CumulativeLast) / timeElapsed));
52 
53         price0CumulativeLast = price0Cumulative;
54         price1CumulativeLast = price1Cumulative;
55         blockTimestampLast = blockTimestamp;
56     }
57 
58     // note this will always return 0 before update has been called successfully for the first time.
59     function consult(address token, uint amountIn) external view returns (uint amountOut) {
60         if (token == token0) {
61             amountOut = price0Average.mul(amountIn).decode144();
62         } else {
63             require(token == token1, 'ExampleOracleSimple: INVALID_TOKEN');
64             amountOut = price1Average.mul(amountIn).decode144();
65         }
66     }
67 }
