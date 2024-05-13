1 // SPDX-License-Identifier: MIT
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
17 //  _____     _                     _____                             _         
18 // | __  |___| |___ ___ ___ ___ ___|     |___ _____ ___ ___ _ _ ___ _| |___ ___ 
19 // | __ -| .'| | .'|   |  _| -_|  _|   --| . |     | . | . | | |   | . | -_|  _|
20 // |_____|__,|_|__,|_|_|___|___|_| |_____|___|_|_|_|  _|___|___|_|_|___|___|_|  
21 //                                                 |_|                          
22 
23 // Github - https://github.com/FortressFinance
24 
25 import "src/shared/compounders/AMMCompounderBase.sol";
26 import "src/arbitrum/utils/BalancerArbiOperations.sol";
27 import {IConvexBasicRewardsArbi} from "src/arbitrum/interfaces/IConvexBasicRewardsArbi.sol";
28 import {IConvexBoosterArbi} from "src/arbitrum/interfaces/IAuraBoosterArbi.sol";
29 import {IBalancerOperations} from "src/shared/fortress-interfaces/IBalancerOperations.sol";
30 
31 contract BalancerArbiCompounder is AMMCompounderBase {
32     
33     using SafeERC20 for IERC20;
34 
35     /********************************** Constructor **********************************/
36 
37     constructor(
38         ERC20 _asset,
39         string memory _name,
40         string memory _symbol,
41         bytes memory _settingsConfig,
42         bytes memory _boosterConfig,
43         address[] memory _underlyingAssets
44     )
45         AMMCompounderBase(
46             _asset,
47             _name,
48             _symbol,
49             _settingsConfig,
50             _boosterConfig,
51             _underlyingAssets
52         ) {}
53 
54     /********************************** Internal Functions **********************************/
55 
56     function _swapFromUnderlying(address _underlyingAsset, uint256 _underlyingAmount, uint256 _minAmount) internal override returns (uint256 _assets) {
57         address payable _ammOperations = settings.ammOperations;
58         _approve(_underlyingAsset, _ammOperations, _underlyingAmount);
59         _assets = IBalancerOperations(_ammOperations).addLiquidity(address(asset), _underlyingAsset, _underlyingAmount);
60         
61         if (!(_assets >= _minAmount)) revert InsufficientAmountOut();
62     }
63 
64     function _swapToUnderlying(address _underlyingAsset, uint256 _assets, uint256 _minAmount) internal override returns (uint256 _underlyingAmount) {
65          address payable _ammOperations = settings.ammOperations;
66          _approve(address(asset), _ammOperations, _assets);
67         _underlyingAmount = IBalancerOperations(_ammOperations).removeLiquidity(address(asset), _underlyingAsset, _assets);
68 
69         if (!(_underlyingAmount >= _minAmount)) revert InsufficientAmountOut();
70     }
71 
72     function _harvest(address _receiver, address _underlyingAsset, uint256 _minBounty) internal override returns (uint256 _rewards) {
73         Booster memory _boosterData = boosterData;
74 
75         IConvexBasicRewards(_boosterData.crvRewards).getReward(); 
76 
77         Settings memory _settings = settings;
78         address _rewardAsset;
79         address _swap = _settings.swap;
80         address[] memory _rewardAssets = _boosterData.rewardAssets;
81         for (uint256 i = 0; i < _rewardAssets.length; i++) {
82             _rewardAsset = _rewardAssets[i];
83             if (_rewardAsset != _underlyingAsset) {
84                 if (_rewardAsset == ETH) {
85                     // slither-disable-next-line arbitrary-send-eth
86                     IFortressSwap(_swap).swap{ value: address(this).balance }(_rewardAsset, _underlyingAsset, address(this).balance);
87                 } else {
88                     uint256 _balance = IERC20(_rewardAsset).balanceOf(address(this));
89                     if (_balance > 0) {
90                         IFortressSwap(_swap).swap(_rewardAsset, _underlyingAsset, _balance);
91                     }
92                 }
93             }
94         }
95 
96         if (_underlyingAsset == ETH) {
97             _rewards = address(this).balance;
98         } else {
99             _rewards = IERC20(_underlyingAsset).balanceOf(address(this));
100         }
101 
102         if (_rewards > 0) {
103             address _lpToken = address(asset);
104             address payable _ammOperations = settings.ammOperations;
105             _approve(_underlyingAsset, _ammOperations, _rewards);
106             _rewards = IBalancerOperations(_ammOperations).addLiquidity(_lpToken, _underlyingAsset, _rewards);
107 
108             Fees memory _fees = fees;
109             uint256 _platformFee = _fees.platformFeePercentage;
110             uint256 _harvestBounty = _fees.harvestBountyPercentage;
111             if (_platformFee > 0) {
112                 _platformFee = (_platformFee * _rewards) / FEE_DENOMINATOR;
113                 _rewards = _rewards - _platformFee;
114                 IERC20(_lpToken).safeTransfer(_settings.platform, _platformFee);
115             }
116             if (_harvestBounty > 0) {
117                 _harvestBounty = (_harvestBounty * _rewards) / FEE_DENOMINATOR;
118                 if (!(_harvestBounty >= _minBounty)) revert InsufficientAmountOut();
119                 _rewards = _rewards - _harvestBounty;
120                 IERC20(_lpToken).safeTransfer(_receiver, _harvestBounty);
121             }
122 
123             IConvexBooster(_boosterData.booster).deposit(_boosterData.boosterPoolId, _rewards, true);
124 
125             emit Harvest(msg.sender, _receiver, _rewards, _platformFee);
126 
127             return _rewards;
128         } else {
129             revert NoPendingRewards();
130         }
131     }
132 
133     receive() external payable {}
134 }