1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.10;
3 
4 interface IAggregator {
5     function latestAnswer() external view returns (int256 answer);
6 }
7 
8 interface AggregatorV3Interface {
9   function decimals() external view returns (uint8);
10   function latestRoundData()
11     external
12     view
13     returns (
14       uint80 roundId,
15       int256 answer,
16       uint256 startedAt,
17       uint256 updatedAt,
18       uint80 answeredInRound
19     );
20 }
21 
22 interface IERC20 {
23     function decimals() external pure returns (uint8);
24 }
25 
26 interface IUniswapV2Pair {
27     function totalSupply() external view returns (uint256);
28     function token0() external view returns (address);
29     function token1() external view returns (address);
30     function getReserves()
31         external
32         view
33         returns (
34             uint112 reserve0,
35             uint112 reserve1,
36             uint32 blockTimestampLast
37         );
38 }
39 
40 /// @title LPChainlinkOracleV1
41 /// @author BoringCrypto, 0xCalibur
42 /// @notice Oracle used for getting the price of an LP token
43 /// @dev Optimized version based on https://blog.alphafinance.io/fair-lp-token-pricing/
44 contract LPChainlinkOracleV1 is IAggregator {
45     IUniswapV2Pair public immutable pair;
46     AggregatorV3Interface public immutable tokenOracle;
47     uint8 public immutable token0Decimals;
48     uint8 public immutable token1Decimals;
49     uint8 public immutable oracleDecimals;
50 
51     uint256 public constant WAD = 18;
52 
53     /// @param pair_ The UniswapV2 compatible pair address
54     /// @param tokenOracle_ The token price 1 lp should be denominated with.
55     constructor(IUniswapV2Pair pair_, AggregatorV3Interface tokenOracle_) {
56         pair = pair_;
57         tokenOracle = tokenOracle_;
58 
59         token0Decimals = IERC20(pair_.token0()).decimals();
60         token1Decimals = IERC20(pair_.token1()).decimals();
61 
62         oracleDecimals = tokenOracle_.decimals();
63     }
64 
65     // credit for this implementation goes to
66     // https://github.com/abdk-consulting/abdk-libraries-solidity/blob/master/ABDKMath64x64.sol
67     function sqrt(uint256 x) internal pure returns (uint128) {
68         if (x == 0) return 0;
69         uint256 xx = x;
70         uint256 r = 1;
71         if (xx >= 0x100000000000000000000000000000000) {
72             xx >>= 128;
73             r <<= 64;
74         }
75         if (xx >= 0x10000000000000000) {
76             xx >>= 64;
77             r <<= 32;
78         }
79         if (xx >= 0x100000000) {
80             xx >>= 32;
81             r <<= 16;
82         }
83         if (xx >= 0x10000) {
84             xx >>= 16;
85             r <<= 8;
86         }
87         if (xx >= 0x100) {
88             xx >>= 8;
89             r <<= 4;
90         }
91         if (xx >= 0x10) {
92             xx >>= 4;
93             r <<= 2;
94         }
95         if (xx >= 0x8) {
96             r <<= 1;
97         }
98         r = (r + x / r) >> 1;
99         r = (r + x / r) >> 1;
100         r = (r + x / r) >> 1;
101         r = (r + x / r) >> 1;
102         r = (r + x / r) >> 1;
103         r = (r + x / r) >> 1;
104         r = (r + x / r) >> 1; // Seven iterations should be enough
105         uint256 r1 = x / r;
106         return uint128(r < r1 ? r : r1);
107     }
108 
109     /// Calculates the lastest exchange rate
110     /// @return the price of 1 lp in token price
111     /// Exemple:
112     /// - For 1 AVAX = $82
113     /// - Total LP Value is: $160,000,000
114     /// - LP supply is 8.25
115     /// - latestAnswer() returns 234420638348190662349201 / 1e18 = 234420.63 AVAX
116     /// - 1 LP = 234420.63 AVAX => 234420.63 * 8.25 * 82 = ≈$160,000,000
117     function latestAnswer() external view override returns (int256) {
118         (uint256 reserve0, uint256 reserve1, ) = IUniswapV2Pair(pair).getReserves();
119         uint256 totalSupply = pair.totalSupply();
120 
121         uint256 normalizedReserve0 = reserve0 * (10**(WAD - token0Decimals));
122         uint256 normalizedReserve1 = reserve1 * (10**(WAD - token1Decimals));
123     
124         uint256 k = normalizedReserve0 * normalizedReserve1;
125         (,int256 priceFeed,,,) = tokenOracle.latestRoundData();
126         
127         uint256 normalizedPriceFeed = uint256(priceFeed) * (10**(WAD - oracleDecimals));
128 
129         uint256 totalValue = uint256(sqrt((k / 1e18) * normalizedPriceFeed)) * 2;
130         return int256((totalValue * 1e18) / totalSupply);
131     }
132 }
