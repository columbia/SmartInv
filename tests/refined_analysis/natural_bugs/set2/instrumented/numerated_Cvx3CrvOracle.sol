1 // SPDX-License-Identifier: BUSL-1.1
2 pragma solidity 0.8.6;
3 
4 import "@yield-protocol/utils-v2/contracts/access/AccessControl.sol";
5 import "@yield-protocol/vault-interfaces/IOracle.sol";
6 import "@yield-protocol/utils-v2/contracts/cast/CastBytes32Bytes6.sol";
7 
8 import "./interfaces/ICurvePool.sol";
9 import "./interfaces/AggregatorV3Interface.sol";
10 
11 // Oracle Code Inspiration: https://github.com/Abracadabra-money/magic-internet-money/blob/main/contracts/oracles/3CrvOracle.sol
12 /**
13  *@title  Cvx3CrvOracle
14  *@notice Provides current values for Cvx3Crv
15  *@dev    Both peek() (view) and get() (transactional) are provided for convenience
16  */
17 contract Cvx3CrvOracle is IOracle, AccessControl {
18     using CastBytes32Bytes6 for bytes32;
19     ICurvePool public threecrv;
20     AggregatorV3Interface public DAI;
21     AggregatorV3Interface public USDC;
22     AggregatorV3Interface public USDT;
23 
24     bytes32 public cvx3CrvId;
25     bytes32 public ethId;
26 
27     /**
28      *@notice Set threecrv pool and the chainlink sources
29      *@param  cvx3CrvId_ cvx3crv Id
30      *@param  ethId_ ETH ID
31      *@param  threecrv_ The 3CRV pool address
32      *@param  DAI_ DAI/ETH chainlink price feed address
33      *@param  USDC_ USDC/ETH chainlink price feed address
34      *@param  USDT_ USDT/ETH chainlink price feed address
35      */
36     function setSource(
37         bytes32 cvx3CrvId_,
38         bytes32 ethId_,
39         ICurvePool threecrv_,
40         AggregatorV3Interface DAI_,
41         AggregatorV3Interface USDC_,
42         AggregatorV3Interface USDT_
43     ) external auth {
44         cvx3CrvId = cvx3CrvId_;
45         ethId = ethId_;
46         threecrv = threecrv_;
47         DAI = DAI_;
48         USDC = USDC_;
49         USDT = USDT_;
50     }
51 
52     /**
53      * @dev Returns the smallest of two numbers.
54      */
55     function min(uint256 a, uint256 b) internal pure returns (uint256) {
56         return a < b ? a : b;
57     }
58 
59     /**
60      * @notice Retrieve the value of the amount at the latest oracle price.
61      * @dev Only cvx3crvid and ethId are accepted as asset identifiers.
62      * @param base Id of base token
63      * @param quote Id of quoted token
64      * @return quoteAmount Total amount in terms of quoted token
65      * @return updateTime Time quote was last updated
66      */
67     function peek(
68         bytes32 base,
69         bytes32 quote,
70         uint256 baseAmount
71     )
72         external
73         view
74         virtual
75         override
76         returns (uint256 quoteAmount, uint256 updateTime)
77     {
78         return _peek(base.b6(), quote.b6(), baseAmount);
79     }
80 
81     /**
82      * @notice Retrieve the value of the amount at the latest oracle price. Same as `peek` for this oracle.
83      * @dev Only cvx3crvid and ethId are accepted as asset identifiers.
84      * @param base Id of base token
85      * @param quote Id of quoted token
86      * @return quoteAmount Total amount in terms of quoted token
87      * @return updateTime Time quote was last updated
88      */
89     function get(
90         bytes32 base,
91         bytes32 quote,
92         uint256 baseAmount
93     )
94         external
95         virtual
96         override
97         returns (uint256 quoteAmount, uint256 updateTime)
98     {
99         return _peek(base.b6(), quote.b6(), baseAmount);
100     }
101 
102     /**
103      * @notice Retrieve the value of the amount at the latest oracle price.
104      * @dev Only cvx3crvid and ethId are accepted as asset identifiers.
105      * @param base Id of base token
106      * @param quote Id of quoted token
107      * @return quoteAmount Total amount in terms of quoted token
108      * @return updateTime Time quote was last updated
109      */
110     function _peek(
111         bytes6 base,
112         bytes6 quote,
113         uint256 baseAmount
114     ) private view returns (uint256 quoteAmount, uint256 updateTime) {
115         require(
116             (base == ethId && quote == cvx3CrvId) ||
117                 (base == cvx3CrvId && quote == ethId),
118             "Invalid quote or base"
119         );
120         (, int256 daiPrice, , , ) = DAI.latestRoundData();
121         (, int256 usdcPrice, , , ) = USDC.latestRoundData();
122         (, int256 usdtPrice, , , ) = USDT.latestRoundData();
123 
124         require(
125             daiPrice > 0 && usdcPrice > 0 && usdtPrice > 0,
126             "Chainlink pricefeed reporting 0"
127         );
128 
129         // This won't overflow as the max value for int256 is less than the max value for uint256
130         uint256 minStable = min(
131             uint256(daiPrice),
132             min(uint256(usdcPrice), uint256(usdtPrice))
133         );
134 
135         uint256 price = (threecrv.get_virtual_price() * minStable) / 1e18;
136 
137         if (base == cvx3CrvId && quote == ethId) {
138             quoteAmount = (baseAmount * price) / 1e18;
139         } else {
140             quoteAmount = (baseAmount * 1e18) / price;
141         }
142 
143         updateTime = block.timestamp;
144     }
145 }
