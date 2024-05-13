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
17 //  _____                 _____     _   _ _____                             _         
18 // |     |_ _ ___ _ _ ___|  _  |___| |_|_|     |___ _____ ___ ___ _ _ ___ _| |___ ___ 
19 // |   --| | |  _| | | -_|     |  _| . | |   --| . |     | . | . | | |   | . | -_|  _|
20 // |_____|___|_|  \_/|___|__|__|_| |___|_|_____|___|_|_|_|  _|___|___|_|_|___|___|_|  
21 //                                                       |_|                          
22 
23 // Github - https://github.com/FortressFinance
24 
25 import {AMMCompounderBase, SafeERC20, IERC20, ERC20, Address, IFortressSwap} from "src/shared/compounders/AMMCompounderBase.sol";
26 
27 import {ICurveOperations} from "src/shared/fortress-interfaces/ICurveOperations.sol";
28 import {IConvexBoosterArbi} from "src/arbitrum/interfaces/IConvexBoosterArbi.sol";
29 import {IConvexBasicRewardsArbi} from "src/arbitrum/interfaces/IConvexBasicRewardsArbi.sol";
30 
31 contract CurveArbiCompounder is AMMCompounderBase {
32     
33     using SafeERC20 for IERC20;
34     using Address for address payable;
35 
36     /// @notice The address of the vault's Curve pool
37     address private immutable poolAddress;
38     /// @notice The internal type of pool, used in CurveOperations
39     uint256 private immutable poolType;
40     /// @notice The address of CRV token
41     address private constant CRV = 0x11cDb42B0EB46D95f990BeDD4695A6e3fA034978;
42 
43     /********************************** Constructor **********************************/
44 
45     constructor(
46         ERC20 _asset,
47         string memory _name,
48         string memory _symbol,
49         bytes memory _settingsConfig,
50         bytes memory _boosterConfig,
51         address[] memory _underlyingAssets,
52         uint256 _poolType
53         )
54         AMMCompounderBase(
55             _asset,
56             _name,
57             _symbol,
58             _settingsConfig,
59             _boosterConfig,
60             _underlyingAssets
61         ) {
62             poolType = _poolType;
63             poolAddress = ICurveOperations(settings.ammOperations).getPoolFromLpToken(address(_asset));
64     }
65 
66     /********************************** View Functions **********************************/
67 
68     /// @notice See {AMMConcentratorBase - isPendingRewards}
69     function isPendingRewards() external override view returns (bool) {
70         return IConvexBasicRewardsArbi(boosterData.crvRewards).claimable_reward(CRV, address(this)) > 0;
71     }
72 
73     /********************************** Internal Functions **********************************/
74 
75     function _depositStrategy(uint256 _assets, bool _transfer) internal override {
76         if (_transfer) IERC20(address(asset)).safeTransferFrom(msg.sender, address(this), _assets);
77         Booster memory _boosterData = boosterData;
78         IConvexBoosterArbi(_boosterData.booster).deposit(_boosterData.boosterPoolId, _assets);
79     }
80 
81     function _withdrawStrategy(uint256 _assets, address _receiver, bool _transfer) internal override {
82         IConvexBasicRewardsArbi(boosterData.crvRewards).withdraw(_assets, false);
83         if (_transfer) IERC20(address(asset)).safeTransfer(_receiver, _assets);
84     }
85 
86     function _swapFromUnderlying(address _underlyingAsset, uint256 _underlyingAmount, uint256 _minAmount) internal override returns (uint256 _assets) {
87         address payable _ammOperations = settings.ammOperations;
88         if (_underlyingAsset == ETH) {
89             (bytes memory _result) = _ammOperations.functionCallWithValue(
90                 abi.encodeWithSignature("addLiquidity(address,uint256,address,uint256)", poolAddress, poolType, _underlyingAsset, _underlyingAmount),
91                 _underlyingAmount
92             );
93             _assets = abi.decode(_result, (uint256));
94         } else {
95             _approve(_underlyingAsset, _ammOperations, _underlyingAmount);
96             _assets = ICurveOperations(_ammOperations).addLiquidity(poolAddress, poolType, _underlyingAsset, _underlyingAmount);
97         }
98 
99         if (!(_assets >= _minAmount)) revert InsufficientAmountOut();
100     }
101 
102     function _swapToUnderlying(address _underlyingAsset, uint256 _assets, uint256 _minAmount) internal override returns (uint256 _underlyingAmount) {
103         address _ammOperations = settings.ammOperations;
104         _approve(address(asset), _ammOperations, _assets);
105         _underlyingAmount = ICurveOperations(_ammOperations).removeLiquidity(poolAddress, poolType, _underlyingAsset, _assets);
106         
107         if (!(_underlyingAmount >= _minAmount)) revert InsufficientAmountOut();
108     }
109 
110     function _harvest(address _receiver, address _underlyingAsset, uint256 _minBounty) internal override returns (uint256 _rewards) {
111         Booster memory _boosterData = boosterData;
112 
113         IConvexBasicRewardsArbi(_boosterData.crvRewards).getReward(address(this));
114         
115         Settings memory _settings = settings;
116         address _rewardAsset;
117         address _swap = _settings.swap;
118         address[] memory _rewardAssets = _boosterData.rewardAssets;
119         for (uint256 i = 0; i < _rewardAssets.length; i++) {
120             _rewardAsset = _rewardAssets[i];
121             
122             if (_rewardAsset != _underlyingAsset) {
123                 if (_rewardAsset == ETH) {
124                     payable(_swap).functionCallWithValue(abi.encodeWithSignature("swap(address,address,uint256)", _rewardAsset, _underlyingAsset, address(this).balance), address(this).balance);
125                 } else {
126                     uint256 _balance = IERC20(_rewardAsset).balanceOf(address(this));
127                     if (_balance > 0) {
128                         IFortressSwap(_swap).swap(_rewardAsset, _underlyingAsset, _balance);
129                     }
130                 }
131             }
132         }
133 
134         if (_underlyingAsset == ETH) {
135             _rewards = address(this).balance;
136         } else {
137             _rewards = IERC20(_underlyingAsset).balanceOf(address(this));
138         }
139 
140         if (_rewards > 0) {
141             address _ammOperations = _settings.ammOperations;
142             _approve(_underlyingAsset, _ammOperations, _rewards);
143             _rewards = ICurveOperations(_ammOperations).addLiquidity(poolAddress, poolType, _underlyingAsset, _rewards);
144 
145             Fees memory _fees = fees;
146             uint256 _platformFee = _fees.platformFeePercentage;
147             uint256 _harvestBounty = _fees.harvestBountyPercentage;
148             address _lpToken = address(asset);
149             if (_platformFee > 0) {
150                 _platformFee = (_platformFee * _rewards) / FEE_DENOMINATOR;
151                 _rewards = _rewards - _platformFee;
152                 IERC20(_lpToken).safeTransfer(_settings.platform, _platformFee);
153             }
154             if (_harvestBounty > 0) {
155                 _harvestBounty = (_harvestBounty * _rewards) / FEE_DENOMINATOR;
156                 if (!(_harvestBounty >= _minBounty)) revert InsufficientAmountOut();
157                 _rewards = _rewards - _harvestBounty;
158                 IERC20(_lpToken).safeTransfer(_receiver, _harvestBounty);
159             }
160 
161             IConvexBoosterArbi(_boosterData.booster).deposit(_boosterData.boosterPoolId, _rewards);
162 
163             emit Harvest(msg.sender, _receiver, _rewards, _platformFee);
164 
165             return _rewards;
166         } else {
167             revert NoPendingRewards();
168         }
169     }
170 
171     receive() external payable {}
172 }