1 pragma solidity =0.6.6;
2 
3 import '../libraries/UniswapV2LiquidityMathLibrary.sol';
4 
5 contract ExampleComputeLiquidityValue {
6     using SafeMath for uint256;
7 
8     address public immutable factory;
9 
10     constructor(address factory_) public {
11         factory = factory_;
12     }
13 
14     // see UniswapV2LiquidityMathLibrary#getReservesAfterArbitrage
15     function getReservesAfterArbitrage(
16         address tokenA,
17         address tokenB,
18         uint256 truePriceTokenA,
19         uint256 truePriceTokenB
20     ) external view returns (uint256 reserveA, uint256 reserveB) {
21         return UniswapV2LiquidityMathLibrary.getReservesAfterArbitrage(
22             factory,
23             tokenA,
24             tokenB,
25             truePriceTokenA,
26             truePriceTokenB
27         );
28     }
29 
30     // see UniswapV2LiquidityMathLibrary#getLiquidityValue
31     function getLiquidityValue(
32         address tokenA,
33         address tokenB,
34         uint256 liquidityAmount
35     ) external view returns (
36         uint256 tokenAAmount,
37         uint256 tokenBAmount
38     ) {
39         return UniswapV2LiquidityMathLibrary.getLiquidityValue(
40             factory,
41             tokenA,
42             tokenB,
43             liquidityAmount
44         );
45     }
46 
47     // see UniswapV2LiquidityMathLibrary#getLiquidityValueAfterArbitrageToPrice
48     function getLiquidityValueAfterArbitrageToPrice(
49         address tokenA,
50         address tokenB,
51         uint256 truePriceTokenA,
52         uint256 truePriceTokenB,
53         uint256 liquidityAmount
54     ) external view returns (
55         uint256 tokenAAmount,
56         uint256 tokenBAmount
57     ) {
58         return UniswapV2LiquidityMathLibrary.getLiquidityValueAfterArbitrageToPrice(
59             factory,
60             tokenA,
61             tokenB,
62             truePriceTokenA,
63             truePriceTokenB,
64             liquidityAmount
65         );
66     }
67 
68     // test function to measure the gas cost of the above function
69     function getGasCostOfGetLiquidityValueAfterArbitrageToPrice(
70         address tokenA,
71         address tokenB,
72         uint256 truePriceTokenA,
73         uint256 truePriceTokenB,
74         uint256 liquidityAmount
75     ) external view returns (
76         uint256
77     ) {
78         uint gasBefore = gasleft();
79         UniswapV2LiquidityMathLibrary.getLiquidityValueAfterArbitrageToPrice(
80             factory,
81             tokenA,
82             tokenB,
83             truePriceTokenA,
84             truePriceTokenB,
85             liquidityAmount
86         );
87         uint gasAfter = gasleft();
88         return gasBefore - gasAfter;
89     }
90 }
