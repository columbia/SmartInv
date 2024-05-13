1 pragma solidity =0.6.6;
2 
3 import '@uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol';
4 import '@uniswap/lib/contracts/libraries/Babylonian.sol';
5 import '@uniswap/lib/contracts/libraries/TransferHelper.sol';
6 
7 import '../libraries/UniswapV2LiquidityMathLibrary.sol';
8 import '../interfaces/IERC20.sol';
9 import '../interfaces/IUniswapV2Router01.sol';
10 import '../libraries/SafeMath.sol';
11 import '../libraries/UniswapV2Library.sol';
12 
13 contract ExampleSwapToPrice {
14     using SafeMath for uint256;
15 
16     IUniswapV2Router01 public immutable router;
17     address public immutable factory;
18 
19     constructor(address factory_, IUniswapV2Router01 router_) public {
20         factory = factory_;
21         router = router_;
22     }
23 
24     // swaps an amount of either token such that the trade is profit-maximizing, given an external true price
25     // true price is expressed in the ratio of token A to token B
26     // caller must approve this contract to spend whichever token is intended to be swapped
27     function swapToPrice(
28         address tokenA,
29         address tokenB,
30         uint256 truePriceTokenA,
31         uint256 truePriceTokenB,
32         uint256 maxSpendTokenA,
33         uint256 maxSpendTokenB,
34         address to,
35         uint256 deadline
36     ) public {
37         // true price is expressed as a ratio, so both values must be non-zero
38         require(truePriceTokenA != 0 && truePriceTokenB != 0, "ExampleSwapToPrice: ZERO_PRICE");
39         // caller can specify 0 for either if they wish to swap in only one direction, but not both
40         require(maxSpendTokenA != 0 || maxSpendTokenB != 0, "ExampleSwapToPrice: ZERO_SPEND");
41 
42         bool aToB;
43         uint256 amountIn;
44         {
45             (uint256 reserveA, uint256 reserveB) = UniswapV2Library.getReserves(factory, tokenA, tokenB);
46             (aToB, amountIn) = UniswapV2LiquidityMathLibrary.computeProfitMaximizingTrade(
47                 truePriceTokenA, truePriceTokenB,
48                 reserveA, reserveB
49             );
50         }
51 
52         require(amountIn > 0, 'ExampleSwapToPrice: ZERO_AMOUNT_IN');
53 
54         // spend up to the allowance of the token in
55         uint256 maxSpend = aToB ? maxSpendTokenA : maxSpendTokenB;
56         if (amountIn > maxSpend) {
57             amountIn = maxSpend;
58         }
59 
60         address tokenIn = aToB ? tokenA : tokenB;
61         address tokenOut = aToB ? tokenB : tokenA;
62         TransferHelper.safeTransferFrom(tokenIn, msg.sender, address(this), amountIn);
63         TransferHelper.safeApprove(tokenIn, address(router), amountIn);
64 
65         address[] memory path = new address[](2);
66         path[0] = tokenIn;
67         path[1] = tokenOut;
68 
69         router.swapExactTokensForTokens(
70             amountIn,
71             0, // amountOutMin: we can skip computing this number because the math is tested
72             path,
73             to,
74             deadline
75         );
76     }
77 }
