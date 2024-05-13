1 // SPDX-License-Identifier: GNU-GPL v3.0 or later
2 
3 pragma solidity >=0.8.0;
4 
5 import "../interfaces/IOracleDispatch.sol";
6 import "../interfaces/ILockManager.sol";
7 import "../utils/RevestAccessControl.sol";
8 import "../lib/chainlink/AggregatorV3Interface.sol";
9 import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
10 import "../lib/chainlink/Denominations.sol";
11 
12 /**
13  * @title Provider interface for Revest FNFTs
14  * @dev Address locks MUST be non-upgradeable to be considered for trusted status
15  *
16  */
17 contract ChainlinkOracleDispatch is IOracleDispatch, RevestAccessControl {
18 
19 
20     constructor(address provider) RevestAccessControl(provider) {}
21 
22     mapping(uint => address) public priceFeeds;
23 
24     //  Attempts to update oracle and returns true if successful. Returns true if update unnecessary
25     function updateOracle(address asset, address compareTo) external pure override returns (bool) {
26         return true;
27     }
28 
29     //  Return true because no poke is needed
30     function pokeOracle(address asset, address compareTo) external pure override returns (bool) {
31         return true;
32     }
33 
34     //  Will return true if oracle already initialized, if oracle has successfully been initialized by this call,
35     //  or if oracle does not need to be initialized
36     function initializeOracle(address asset, address compareTo) external pure override returns (bool) {
37         return true;
38     }
39 
40 
41     //  Gets the value of the asset
42     //  Oracle = the oracle address in specific. Optional parameter
43     //  Inverted pair = whether or not this call represents an inversion of typical type (ERC20 underlying, USDC compareTo) to (USDC underlying, ERC20 compareTo)
44     //  Must take inverse of value in this case to get REAL value
45     function getValueOfAsset(
46         address asset,
47         address compareTo,
48         bool risingEdge
49     ) public view override returns (uint) {
50         //This will never be called if there IS NOT a pair available
51         //Implicit assumption for this function to be called is that getPairHasOracle has returned true
52 
53 
54         return getPriceForOracle(asset, compareTo);
55     }
56 
57     //  Oracle will never need updates
58     function oracleNeedsUpdates(address asset, address compareTo) external pure override returns (bool) {
59         return false;
60     }
61 
62     function oracleNeedsInitialization(address asset, address compareTo) external pure override returns (bool) {
63         return false;
64     }
65 
66     function canOracleBeCreatedForRoute(address asset, address compareTo) external view override returns (bool) {
67         return getPairHasOracle(asset, compareTo);
68     }
69 
70     //  Oracle never needs poking
71     function oracleNeedsPoking(address asset, address compareTo) external pure override returns (bool) {
72         return false;
73     }
74 
75     //  Oracle never needs poking
76     function getTimePeriodAfterPoke(address asset, address compareTo) external pure override returns (uint) {
77         return 0;
78     }
79 
80     //  Returns a direct reference to the address that the specific contract for this pair is registered at
81     function getOracleForPair(address asset, address compareTo) public view override returns (address) {
82         return priceFeeds[getOracleID(asset, compareTo)];
83     }
84 
85     // Returns a boolean if this oracle can provide data for the requested pair, used during FNFT creation
86     function getPairHasOracle(address asset, address compareTo) public view override returns (bool) {
87 
88         return asset != compareTo && getOracleForPair(asset, compareTo) != address(0);
89     }
90 
91     // Not terribly important for non-updateable oracles like Chainlink
92     function getInstantPrice(address asset, address compareTo) external view override returns (uint) {
93         return getValueOfAsset(asset, compareTo, true);
94     }
95 
96     // INTERNAL FUNCTIONS
97 
98 
99     //  Returns price and decimal precision
100     function getPriceForOracle(address asset, address compareTo) internal view returns (uint) {
101         uint id = getOracleID(asset, compareTo);
102         address oracle = priceFeeds[id];
103         AggregatorV3Interface priceFeed = AggregatorV3Interface(oracle);
104         (, int256 answer, , , ) = priceFeed.latestRoundData();
105         uint castAnswer = answer >= int256(0) ? uint(answer) : 0;
106         uint linkDecimals = priceFeed.decimals();
107         uint realDecimals = linkDecimals;
108 
109         if(isStandardAsset(compareTo)) {
110             realDecimals = ERC20(compareTo).decimals();
111         }
112         // Standardize price to native precision
113         return castAnswer * (10 ** realDecimals) / (10 ** linkDecimals);
114     }
115 
116     function batchAddOracles(
117         address[] memory asset1,
118         address[] memory asset2,
119         address[] memory oracle
120     ) external onlyOwner {
121         for (uint i = 0; i < asset1.length; i++) {
122             priceFeeds[getOracleID(asset1[i], asset2[i])] = oracle[i];
123         }
124     }
125 
126     function addOracle(
127         address asset1,
128         address asset2,
129         address oracle
130     ) external onlyOwner {
131         // Token will always be the first ID, followed by the address to compare to
132         uint id = getOracleID(asset1, asset2);
133         priceFeeds[id] = oracle;
134     }
135 
136 
137 
138     //  Will return 0 if Oracle DNE
139     function getOracleID(address asset, address compareTo) internal pure returns (uint) {
140         return uint(keccak256(abi.encodePacked(asset, compareTo)));
141     }
142 
143     //  Is the asset a real token or a denomination?
144     function isStandardAsset(address asset) private pure returns (bool) {
145         return asset != Denominations.USD &&
146                asset != Denominations.ETH &&
147                asset != Denominations.BTC &&
148                asset != Denominations.GBP &&
149                asset != Denominations.EUR;
150     }
151 
152 }
