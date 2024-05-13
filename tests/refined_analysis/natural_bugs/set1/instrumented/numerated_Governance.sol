1 // SPDX-License-Identifier: GPL-2.0-or-later
2 
3 pragma solidity ^0.8.0;
4 
5 import "../BaseLogic.sol";
6 import "../BaseIRM.sol";
7 
8 
9 contract Governance is BaseLogic {
10     constructor(bytes32 moduleGitCommit_) BaseLogic(MODULEID__GOVERNANCE, moduleGitCommit_) {}
11 
12     modifier governorOnly {
13         address msgSender = unpackTrailingParamMsgSender();
14 
15         require(msgSender == governorAdmin, "e/gov/unauthorized");
16         _;
17     }
18 
19 
20 
21     // setters
22 
23     function setAssetConfig(address underlying, AssetConfig calldata newConfig) external nonReentrant governorOnly {
24         require(underlyingLookup[underlying].eTokenAddress == newConfig.eTokenAddress, "e/gov/etoken-mismatch");
25         underlyingLookup[underlying] = newConfig;
26 
27         emit GovSetAssetConfig(underlying, newConfig);
28     }
29 
30     function setIRM(address underlying, uint interestRateModel, bytes calldata resetParams) external nonReentrant governorOnly {
31         address eTokenAddr = underlyingLookup[underlying].eTokenAddress;
32         require(eTokenAddr != address(0), "e/gov/underlying-not-activated");
33 
34         AssetStorage storage assetStorage = eTokenLookup[eTokenAddr];
35         AssetCache memory assetCache = loadAssetCache(underlying, assetStorage);
36 
37         callInternalModule(interestRateModel, abi.encodeWithSelector(BaseIRM.reset.selector, underlying, resetParams));
38 
39         assetStorage.interestRateModel = assetCache.interestRateModel = uint32(interestRateModel);
40 
41         updateInterestRate(assetStorage, assetCache);
42 
43         logAssetStatus(assetCache);
44 
45         emit GovSetIRM(underlying, interestRateModel, resetParams);
46     }
47 
48     function setPricingConfig(address underlying, uint16 newPricingType, uint32 newPricingParameter) external nonReentrant governorOnly {
49         address eTokenAddr = underlyingLookup[underlying].eTokenAddress;
50         require(eTokenAddr != address(0), "e/gov/underlying-not-activated");
51         require(newPricingType > 0 && newPricingType < PRICINGTYPE__OUT_OF_BOUNDS, "e/gov/bad-pricing-type");
52 
53         AssetStorage storage assetStorage = eTokenLookup[eTokenAddr];
54         AssetCache memory assetCache = loadAssetCache(underlying, assetStorage);
55 
56         assetStorage.pricingType = assetCache.pricingType = newPricingType;
57         assetStorage.pricingParameters = assetCache.pricingParameters = newPricingParameter;
58 
59         if (newPricingType == PRICINGTYPE__CHAINLINK) {
60             require(chainlinkPriceFeedLookup[underlying] != address(0), "e/gov/chainlink-price-feed-not-initialized");
61         }
62 
63         emit GovSetPricingConfig(underlying, newPricingType, newPricingParameter);
64     }
65 
66     function setReserveFee(address underlying, uint32 newReserveFee) external nonReentrant governorOnly {
67         address eTokenAddr = underlyingLookup[underlying].eTokenAddress;
68         require(eTokenAddr != address(0), "e/gov/underlying-not-activated");
69 
70         require(newReserveFee <= RESERVE_FEE_SCALE || newReserveFee == type(uint32).max, "e/gov/bad-reserve-fee");
71 
72         AssetStorage storage assetStorage = eTokenLookup[eTokenAddr];
73         AssetCache memory assetCache = loadAssetCache(underlying, assetStorage);
74 
75         assetStorage.reserveFee = assetCache.reserveFee = newReserveFee;
76 
77         emit GovSetReserveFee(underlying, newReserveFee);
78     }
79 
80     function convertReserves(address underlying, address recipient, uint amount) external nonReentrant governorOnly {
81         address eTokenAddress = underlyingLookup[underlying].eTokenAddress;
82         require(eTokenAddress != address(0), "e/gov/underlying-not-activated");
83 
84         updateAverageLiquidity(recipient);
85 
86         AssetStorage storage assetStorage = eTokenLookup[eTokenAddress];
87         require(assetStorage.reserveBalance >= INITIAL_RESERVES, "e/gov/reserves-depleted");
88         
89         AssetCache memory assetCache = loadAssetCache(underlying, assetStorage);
90 
91         uint maxAmount = assetCache.reserveBalance - INITIAL_RESERVES;
92         if (amount == type(uint).max) amount = maxAmount;
93         require(amount <= maxAmount, "e/gov/insufficient-reserves");
94 
95         assetStorage.reserveBalance = assetCache.reserveBalance = assetCache.reserveBalance - uint96(amount);
96         // Decrease totalBalances because increaseBalance will increase it by amount
97         assetStorage.totalBalances = assetCache.totalBalances = encodeAmount(assetCache.totalBalances - amount);
98 
99         increaseBalance(assetStorage, assetCache, eTokenAddress, recipient, amount);
100 
101         // Depositing a token to an account with pre-existing debt in that token creates a self-collateralized loan
102         // which may result in borrow isolation violation if other tokens are also borrowed on the account
103         if (assetStorage.users[recipient].owed != 0) checkLiquidity(recipient);
104 
105         logAssetStatus(assetCache);
106 
107         emit GovConvertReserves(underlying, recipient, balanceToUnderlyingAmount(assetCache, amount));
108     }
109 
110     function setChainlinkPriceFeed(address underlying, address chainlinkAggregator) external nonReentrant governorOnly {
111         address eTokenAddr = underlyingLookup[underlying].eTokenAddress;
112         require(eTokenAddr != address(0), "e/gov/underlying-not-activated");
113         require(chainlinkAggregator != address(0), "e/gov/bad-chainlink-address");
114 
115         chainlinkPriceFeedLookup[underlying] = chainlinkAggregator;
116 
117         emit GovSetChainlinkPriceFeed(underlying, chainlinkAggregator);
118     }
119 
120 
121     // getters
122 
123     function getGovernorAdmin() external view returns (address) {
124         return governorAdmin;
125     }
126 }
