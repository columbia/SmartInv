1 // SPDX-License-Identifier: GNU-GPL v3.0 or later
2 
3 pragma solidity >=0.8.0;
4 
5 import "../interfaces/IOracleDispatch.sol";
6 import "../utils/RevestAccessControl.sol";
7 import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
8 import '@uniswap/v3-core/contracts/interfaces/pool/IUniswapV3PoolState.sol';
9 
10 
11 interface V3Oracle {
12     function assetToAsset(address, uint, address, uint32) external view returns (uint);
13 }
14 
15 contract UniswapV3CronjeSon is IOracleDispatch, RevestAccessControl {
16 
17     // Hardcoded mainnet deployment, sourced via Andre Cronje
18     V3Oracle constant oracle = V3Oracle(0x0F1f5A87f99f0918e6C81F16E59F3518698221Ff);
19     // Period to measure TWAP over, in seconds
20     uint32 public constant TWAP_PERIOD = 900;
21     // Wrapped ETH address
22     address public immutable WETH;
23     // Mainnet: 0x1F98431c8aD98523631AE4a59f267346ea31F984
24     address public immutable UNIV3_FACTORY;
25     // Mainnet: 3000
26     uint24 public immutable UNIV3_FEE;
27 
28     constructor(address provider, address weth, address uni_v3, uint24 uniFee) RevestAccessControl(provider) {
29         WETH = weth;
30         UNIV3_FACTORY = uni_v3;
31         UNIV3_FEE = uniFee;
32     }
33 
34     // Attempts to update oracle and returns true if successful. Returns true if update unnecessary
35     function updateOracle(address asset, address compareTo) external pure override returns (bool) {
36         return true;
37     }
38 
39     // Will return true if oracle does not need to be poked or if poke was successful
40     function pokeOracle(address asset, address compareTo) external pure override returns (bool) {
41         return true;
42     }
43 
44     // Will return true if oracle already initialized, if oracle has successfully been initialized by this call,
45     // or if oracle does not need to be initialized
46     function initializeOracle(address asset, address compareTo) external override returns (bool) {
47         return true;
48     }
49 
50     // Gets the value of the asset
51     // Oracle = the oracle address in specific. Optional parameter
52     function getValueOfAsset(
53         address asset,
54         address compareTo,
55         bool risingEdge
56     )  external view override returns (uint) {
57         uint decimals = ERC20(asset).decimals();
58         uint price = oracle.assetToAsset(asset, 10**decimals, compareTo, TWAP_PERIOD);
59         return price;
60     }
61 
62     // Does this oracle need to be updated prior to our reading the price?
63     // Return false if we are within desired time period
64     // Or if this type of oracle does not require updates
65     function oracleNeedsUpdates(address asset, address compareTo) external pure override returns (bool) {
66         return false;
67     }
68 
69     // Does this oracle need to be poked prior to update and withdrawal?
70     function oracleNeedsPoking(address asset, address compareTo) external pure override returns (bool) {
71         return false;
72     }
73 
74     function oracleNeedsInitialization(address asset, address compareTo) external view override returns (bool) {
75         return false;
76     }
77 
78     //Only ever called if oracle needs initialization
79     function canOracleBeCreatedForRoute(address asset, address compareTo) external view override returns (bool) {
80         return getPairHasOracle(asset, compareTo);
81     }
82 
83     // How long to wait after poking the oracle before you can update it again and withdraw
84     function getTimePeriodAfterPoke(address asset, address compareTo) external pure override returns (uint) {
85         return 0;
86     }
87 
88     // Returns a direct reference to the address that the specific contract for this pair is registered at
89     function getOracleForPair(address asset, address compareTo) external pure override returns (address) {
90         return 0x0F1f5A87f99f0918e6C81F16E59F3518698221Ff;
91     }
92 
93     // Returns a boolean if this oracle can provide data for the requested pair, used during FNFT creation
94     // If the oracle does not exist, this will revert the transaction
95     function getPairHasOracle(address asset, address compareTo) public view override returns (bool) {
96         //First, check if standard ERC20 with decimals() method
97         uint decimals = ERC20(asset).decimals();
98         uint price = oracle.assetToAsset(asset, 10**decimals, compareTo, TWAP_PERIOD);
99         return true;
100     }
101 
102     //Returns the instantaneous price of asset and the decimals for that price
103     function getInstantPrice(address asset, address compareTo) external view override returns (uint) {
104         uint decimals = ERC20(asset).decimals();
105         return oracle.assetToAsset(asset, 10**decimals, compareTo, TWAP_PERIOD);
106     }
107 
108 }
