1 // // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 // ███████╗░█████╗░██████╗░████████╗██████╗░███████╗░██████╗░██████╗
5 // ██╔════╝██╔══██╗██╔══██╗╚══██╔══╝██╔══██╗██╔════╝██╔════╝██╔════╝
6 // █████╗░░██║░░██║██████╔╝░░░██║░░░██████╔╝█████╗░░╚█████╗░╚█████╗░
7 // ██╔══╝░░██║░░██║██╔══██╗░░░██║░░░██╔══██╗██╔══╝░░░╚═══██╗░╚═══██╗
8 // ██║░░░░░╚█████╔╝██║░░██║░░░██║░░░██║░░██║███████╗██████╔╝██████╔╝
9 // ╚═╝░░░░░░╚════╝░╚═╝░░╚═╝░░░╚═╝░░░╚═╝░░╚═╝╚══════╝╚═════╝░╚═════╝░
10 // ███████╗██╗███╗░░██╗░█████╗░███╗░░██╗░█████╗░███████╗
11 // ██╔════╝██║████╗░██║██╔══██╗████╗░██║██╔══██╗██╔════╝
12 // █████╗░░██║██╔██╗██║███████║██╔██╗██║██║░░╚═╝█████╗░░
13 // ██╔══╝░░██║██║╚████║██╔══██║██║╚████║██║░░██╗██╔══╝░░
14 // ██║░░░░░██║██║░╚███║██║░░██║██║░╚███║╚█████╔╝███████╗
15 // ╚═╝░░░░░╚═╝╚═╝░░╚══╝╚═╝░░╚═╝╚═╝░░╚══╝░╚════╝░╚══════╝
16 
17 //  _____         _                   ___ _____         _ _____             _     
18 // |   __|___ ___| |_ ___ ___ ___ ___|_  |  _  |___ ___| |     |___ ___ ___| |___ 
19 // |   __| . |  _|  _|  _| -_|_ -|_ -|  _|   __| . | . | |  |  |  _| .'|  _| | -_|
20 // |__|  |___|_| |_| |_| |___|___|___|___|__|  |___|___|_|_____|_| |__,|___|_|___|
21 
22 // Github - https://github.com/FortressFinance
23 
24 import {Math} from '@openzeppelin/contracts/utils/math/Math.sol';
25 import {ICurveV2Pool} from "../interfaces/ICurveV2Pool.sol";
26 import {IChainlinkAggregator} from "../interfaces/IChainlinkAggregator.sol"; 
27 
28 import "./BaseOracle.sol";
29 
30 contract Fortress2PoolOracle is BaseOracle {
31 
32     using SafeCast for uint256;
33 
34     IChainlinkAggregator public USDC = IChainlinkAggregator(address(0x50834F3163758fcC1Df9973b6e91f0F0F0434aD3));
35     IChainlinkAggregator public USDT = IChainlinkAggregator(address(0x3f3f5dF88dC9F13eac63DF89EC16ef6e7E25DdE7));
36 
37     /********************************** Constructor **********************************/
38 
39     constructor(address _owner, address _vault) BaseOracle(_owner, _vault) {}
40 
41     /********************************** External Functions **********************************/
42 
43     function description() external pure override returns (string memory) {
44         return "fc2Pool USD Oracle";
45     }
46 
47     /********************************** Internal Functions **********************************/
48 
49     function _getPrice() internal view override returns (int256) {
50         address _twoPool = address(0x7f90122BF0700F9E7e1F688fe926940E8839F353);
51         uint256 minAssetPrice = uint256(_getMinAssetPrice());
52         uint256 _assetPrice = ICurveV2Pool(_twoPool).get_virtual_price() * minAssetPrice;
53 
54         uint256 _sharePrice = ((ERC4626(vault).convertToAssets(_assetPrice) * DECIMAL_DIFFERENCE) / BASE);
55 
56         // check that vault share price deviation did not exceed the configured bounds
57         if (isCheckPriceDeviation) _checkPriceDeviation(_sharePrice);
58         _checkVaultSpread();
59 
60         return _sharePrice.toInt256();
61     }
62 
63     function _getMinAssetPrice() internal view returns (uint256) {
64         (, int256 usdcPrice, ,uint256 usdcUpdatedAt, ) = USDC.latestRoundData();
65         if (usdcPrice == 0) revert zeroPrice();
66         if (usdcUpdatedAt < block.timestamp - (24 * 3600)) revert stalePrice();
67 
68         (, int256 usdtPrice, ,uint256 usdtUpdatedAt, ) = USDT.latestRoundData();
69         if (usdtPrice == 0) revert zeroPrice();
70         if (usdtUpdatedAt < block.timestamp - (24 * 3600)) revert stalePrice();
71         
72         return Math.min(uint256(usdcPrice), uint256(usdtPrice));
73     }
74 
75     /********************************** Owner Functions **********************************/
76 
77     /// @notice this function needs to be called periodically to update the last share price
78     function updateLastSharePrice() external override onlyOwner {
79         address _twoPool = address(0x7f90122BF0700F9E7e1F688fe926940E8839F353);
80         uint256 minAssetPrice = uint256(_getMinAssetPrice());
81         uint256 _assetPrice = ICurveV2Pool(_twoPool).get_virtual_price() * minAssetPrice;
82 
83         lastSharePrice = ((ERC4626(vault).convertToAssets(_assetPrice) * DECIMAL_DIFFERENCE) / BASE);
84 
85         emit LastSharePriceUpdated(lastSharePrice);
86     }
87 
88     function updatePriceFeed(address _usdtPriceFeed, address _usdcPriceFeed) external onlyOwner {
89         USDC = IChainlinkAggregator(_usdcPriceFeed);
90         USDT = IChainlinkAggregator(_usdtPriceFeed);
91 
92         emit PriceFeedUpdated(_usdtPriceFeed, _usdcPriceFeed);
93     }
94 }