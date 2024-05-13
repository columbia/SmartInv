1 // SPDX-License-Identifier: GPL-2.0-or-later
2 pragma solidity ^0.8.0;
3 
4 import "../vendor/TickMath.sol";
5 
6 interface IUniswapV3PoolDeployer {
7     function parameters() external view returns (
8             address factory,
9             address token0,
10             address token1,
11             uint24 fee,
12             int24 tickSpacing
13         );
14 }
15 
16 contract MockUniswapV3Pool {
17     address public immutable factory;
18     address public immutable token0;
19     address public immutable token1;
20     uint24 public immutable fee;
21 
22     constructor() {
23         (factory, token0, token1, fee,) = IUniswapV3PoolDeployer(msg.sender).parameters();
24     }
25 
26 
27 
28 
29 
30     uint160 currSqrtPriceX96;
31     int24 currTwap;
32     bool throwOld;
33     bool throwNotInitiated;
34     bool throwOther;
35     bool throwEmpty;
36 
37     function mockSetTwap(uint160 sqrtPriceX96) public {
38         currSqrtPriceX96 = sqrtPriceX96;
39         currTwap = TickMath.getTickAtSqrtRatio(sqrtPriceX96);
40     }
41 
42     function initialize(uint160 sqrtPriceX96) external {
43         mockSetTwap(sqrtPriceX96);
44     }
45 
46     function mockSetThrowOld(bool val) external {
47         throwOld = val;
48     }
49 
50     function mockSetThrowNotInitiated(bool val) external {
51         throwNotInitiated = val;
52     }
53 
54     function mockSetThrowOther(bool val) external {
55         throwOther = val;
56     }
57 
58     function mockSetThrowEmpty(bool val) external {
59         throwEmpty = val;
60     }
61 
62 
63     function observations(uint256) external pure returns (uint32, int56, uint160, bool) {
64         return (0, 0, 0, true);
65     }
66 
67     function slot0() external view returns (uint160 sqrtPriceX96, int24 tick, uint16 observationIndex, uint16 observationCardinality, uint16 observationCardinalityNext, uint8 feeProtocol, bool unlocked) {
68         sqrtPriceX96 = currSqrtPriceX96;
69 
70         // These fields are tested with the real uniswap core contracts:
71         observationIndex = observationCardinality = observationCardinalityNext = 1;
72 
73         // Not used in Euler tests:
74         tick = 0;
75         feeProtocol = 0;
76         unlocked = false;
77     }
78 
79     function observe(uint32[] calldata secondsAgos) external view returns (int56[] memory tickCumulatives, uint160[] memory liquidityCumulatives) {
80         require(!throwOld, "OLD");
81         require (!throwOther, "OTHER");
82 
83         require(secondsAgos.length == 2, "uniswap-pool-mock/unsupported-args-1");
84         require(secondsAgos[1] == 0, "uniswap-pool-mock/unsupported-args-2");
85         require(secondsAgos[0] > 0, "uniswap-pool-mock/unsupported-args-3");
86 
87         tickCumulatives = new int56[](2);
88         liquidityCumulatives = new uint160[](2);
89 
90         tickCumulatives[0] = 0;
91         tickCumulatives[1] = int56(currTwap) * int56(uint56(secondsAgos[0]));
92         liquidityCumulatives[0] = liquidityCumulatives[1] = 0;
93     }
94 
95 
96 
97     function increaseObservationCardinalityNext(uint16) external {
98         // This function is tested with the real uniswap core contracts
99         require (!throwNotInitiated, "LOK");
100         require (!throwOther, "OTHER");
101         require (!throwEmpty);
102         throwNotInitiated = throwNotInitiated; // suppress visibility warning
103     }
104 
105 
106     uint128 public liquidity = 100;
107 
108     function mockSetLiquidity(uint128 newLiquidity) external {
109         liquidity = newLiquidity;
110     }
111 }
