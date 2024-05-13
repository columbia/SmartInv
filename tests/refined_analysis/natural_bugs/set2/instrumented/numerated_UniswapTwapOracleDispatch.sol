1 // SPDX-License-Identifier: GNU-GPL v3.0 or later
2 
3 pragma solidity >=0.8.0;
4 
5 import "../interfaces/IOracleDispatch.sol";
6 import "../lib/uniswap/IUniswapV2Pair.sol";
7 import "../lib/uniswap/IUniswapV2Factory.sol";
8 import "../utils/RevestAccessControl.sol";
9 import "../lib/FixedPoint.sol";
10 import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
11 
12 /**
13  * TWAPs are uninitialized when created. Then immediately queried for their first datapoint.
14  * On the second updateTwap() call, initialization becomes true.
15  */
16 contract UniswapTwapOracleDispatch is IOracleDispatch, RevestAccessControl {
17 
18     // Maps oracle id to twap oracle struct
19     mapping(uint => TwapLock) public twaps;
20 
21     // 30 seconds
22     uint public constant MIN_UPDATE = 30;
23 
24     address public uniswap;
25 
26     struct TwapLock {
27         // Should conform to IUniswapV2Pair interface
28         address pairAddress;
29         // Handle edge case where price could be 0 at first init
30         bool initialized;
31         uint timestampLatest;
32         uint lastUpdateCumulativePrice;
33         uint lastUpdateTwapPrice;
34     }
35     constructor(address provider, address uni) RevestAccessControl(provider) {
36         uniswap = uni;
37     }
38 
39     //  Will return true if oracle already initialized, if oracle has successfully been initialized by this call,
40     //  or if oracle does not need to be initialized
41     function initializeOracle(address asset, address compareTo) external override returns (bool) {
42         address pair = IUniswapV2Factory(uniswap).getPair(asset, compareTo);
43         IUniswapV2Pair uni_pair = IUniswapV2Pair(pair);
44         bool inverted = uni_pair.token1() == asset;
45         ERC20 metaTest = ERC20(asset);
46         {
47             // Check that the contract supports the decimals() method as a smoke test for ERC20 validity
48             metaTest.decimals();
49         }
50         if(pair == address(0)) {
51             // If pair DNE, cannot create oracle
52             return false;
53         }
54         TwapLock memory twap;
55         (, , twap.timestampLatest) = IUniswapV2Pair(pair).getReserves();
56         twap.lastUpdateCumulativePrice = inverted ?  IUniswapV2Pair(pair).price1CumulativeLast() : IUniswapV2Pair(pair).price0CumulativeLast();
57         twap.pairAddress = pair;
58         twaps[getOracleID(asset, compareTo)] = twap;
59         return true;
60     }
61 
62     //  Attempts to update oracle and returns true if successful. Returns true if update unnecessary
63     function updateOracle(address asset, address compareTo) external override returns (bool) {
64         uint oracleId = getOracleID(asset, compareTo);
65         TwapLock storage twap = twaps[oracleId];
66 
67         if(block.timestamp <= twap.timestampLatest + MIN_UPDATE) {
68             // Wait until safe update period has passed to update TWAP
69             return false;
70         }
71         IUniswapV2Pair pair = IUniswapV2Pair(twap.pairAddress);
72         bool inverted = pair.token1() == asset;
73         uint cumLast = inverted ? pair.price1CumulativeLast() : pair.price0CumulativeLast();
74 
75         uint lastTimeTwapUpdated = twap.timestampLatest;
76         uint lastPrice = twap.lastUpdateCumulativePrice;
77 
78         (, , uint lastTime) = pair.getReserves();
79 
80         if(cumLast - lastPrice <= 0 || lastTime - lastTimeTwapUpdated <= 0) {
81             // There has been no value on the Uniswap pair since the last update
82             // Attempt to force the uni pair to sync
83             pair.sync();
84             // Reset variables
85             cumLast = inverted ? pair.price1CumulativeLast() : pair.price0CumulativeLast();
86             (, , lastTime) = pair.getReserves();
87             if(cumLast - lastPrice <= 0 || lastTime - lastTimeTwapUpdated <= 0) {
88                 // If this has failed, we must return false
89                 return false;
90             }
91         }
92 
93         if(!twap.initialized) {
94             if(twap.timestampLatest == 0) {
95                 twap.timestampLatest = lastTime;
96                 twap.pairAddress = IUniswapV2Factory(uniswap).getPair(asset, compareTo);
97             }
98             else {
99                 twap.lastUpdateTwapPrice = getTwapPrice(asset, cumLast, lastTime, lastTimeTwapUpdated, lastPrice);
100                 twap.lastUpdateCumulativePrice = cumLast;
101                 twap.timestampLatest = lastTime;
102                 twap.initialized = true;
103             }
104         }
105         else {
106             twap.lastUpdateTwapPrice = getTwapPrice(asset, cumLast, lastTime, lastTimeTwapUpdated, lastPrice);
107             twap.lastUpdateCumulativePrice = cumLast;
108             twap.timestampLatest = lastTime;
109         }
110         return true;
111     }
112 
113     //  Return true because no poke is needed
114     function pokeOracle(address asset, address compareTo) external pure override returns (bool) {
115         return true;
116     }
117 
118     //  Gets the value of the asset
119     function getValueOfAsset(
120         address asset,
121         address compareTo,
122         bool risingEdge
123     ) external view override returns (uint) {
124         if(twaps[getOracleID(asset, compareTo)].initialized) {
125             return twaps[getOracleID(asset, compareTo)].lastUpdateTwapPrice;
126         } else {
127             if(risingEdge) {
128                 return 0;
129             } else {
130                 return 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
131             }
132         }
133 
134     }
135 
136     function oracleNeedsInitialization(address asset, address compareTo) external pure override returns (bool) {
137         return true;
138     }
139 
140     //  Oracle will need updatess
141     function oracleNeedsUpdates(address asset, address compareTo) external pure override returns (bool) {
142         return true;
143     }
144 
145 
146     //  Oracle never needs poking
147     function oracleNeedsPoking(address asset, address compareTo) external pure override returns (bool) {
148         return false;
149     }
150 
151     //  Oracle never needs poking
152     function getTimePeriodAfterPoke(address asset, address compareTo) external pure override returns (uint) {
153         return 0;
154     }
155 
156 
157     //  Returns a direct reference to the address that the specific contract for this pair is registered at
158     function getOracleForPair(address asset, address compareTo) public view override returns (address) {
159         return twaps[getOracleID(asset, compareTo)].pairAddress;
160     }
161 
162     //  Returns a boolean if this oracle can provide data for the requested pair, used during FNFT creation
163     function getPairHasOracle(address asset, address compareTo) external view override returns (bool) {
164         return twaps[getOracleID(asset, compareTo)].pairAddress != address(0);
165     }
166 
167     function canOracleBeCreatedForRoute(address asset, address compareTo) external view override returns (bool) {
168         return asset != compareTo && IUniswapV2Factory(uniswap).getPair(asset, compareTo) != address(0);
169     }
170 
171     function getInstantPrice(address asset, address compareTo) external view override returns (uint) {
172         return getAssetPrice(asset, compareTo, address(0));
173     }
174 
175     // INTERNAL FUNCTIONS
176 
177     function getTwapPrice(address asset, uint cumulativeLast, uint timestamp, uint lastTime, uint lastCumPrice) internal view returns (uint) {
178         ERC20 erc20 = ERC20(asset);
179         uint decimals = 10 ** erc20.decimals();
180         FixedPoint.uq144x112 memory priceAverage = FixedPoint.uq144x112(decimals * ((cumulativeLast - lastCumPrice) / (timestamp - lastTime)));
181         uint twapPrice = FixedPoint.decode144(priceAverage);
182         return twapPrice;
183     }
184 
185     function getAssetPrice(address asset, address compareTo, address pairAdd) internal view returns (uint) {
186         IUniswapV2Pair pair = IUniswapV2Pair(pairAdd == address(0) ? getOracleForPair(asset, compareTo) : pairAdd );
187 
188         ERC20 erc20 = ERC20(asset);
189         uint decimals = 10 ** erc20.decimals();
190 
191         (uint reserve0, uint reserve1, ) = pair.getReserves();
192 
193         if (pair.token0() == asset) {
194             return decimals * reserve1 / reserve0;
195         } else if (pair.token1() == asset) {
196             return decimals * reserve0 / reserve1;
197         } else {
198             require(false, "Asset not part of oracle");
199         }
200     }
201 
202     //  Will return 0 if Oracle DNE
203     function getOracleID(address asset, address compareTo) internal pure returns (uint) {
204         return uint(keccak256(abi.encodePacked(asset, compareTo)));
205     }
206 
207 
208 
209 }
