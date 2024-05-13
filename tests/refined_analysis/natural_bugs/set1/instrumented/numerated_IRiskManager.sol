1 // SPDX-License-Identifier: GPL-2.0-or-later
2 
3 pragma solidity ^0.8.0;
4 
5 import "./Storage.sol";
6 
7 // This interface is used to avoid a circular dependency between BaseLogic and RiskManager
8 
9 interface IRiskManager {
10     struct NewMarketParameters {
11         uint16 pricingType;
12         uint32 pricingParameters;
13 
14         Storage.AssetConfig config;
15     }
16 
17     struct LiquidityStatus {
18         uint collateralValue;
19         uint liabilityValue;
20         uint numBorrows;
21         bool borrowIsolated;
22     }
23 
24     struct AssetLiquidity {
25         address underlying;
26         LiquidityStatus status;
27     }
28 
29     function getNewMarketParameters(address underlying) external returns (NewMarketParameters memory);
30 
31     function requireLiquidity(address account) external view;
32     function computeLiquidity(address account) external view returns (LiquidityStatus memory status);
33     function computeAssetLiquidities(address account) external view returns (AssetLiquidity[] memory assets);
34 
35     function getPrice(address underlying) external view returns (uint twap, uint twapPeriod);
36     function getPriceFull(address underlying) external view returns (uint twap, uint twapPeriod, uint currPrice);
37 }
