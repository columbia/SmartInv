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
17 //  _____                 _____ _     _____                     _           _           
18 // |     |_ _ ___ _ _ ___|   __| |___|     |___ ___ ___ ___ ___| |_ ___ ___| |_ ___ ___ 
19 // |   --| | |  _| | | -_|  |  | | . |   --| . |   |  _| -_|   |  _|  _| .'|  _| . |  _|
20 // |_____|___|_|  \_/|___|_____|_|  _|_____|___|_|_|___|___|_|_|_| |_| |__,|_| |___|_|  
21 //                               |_|                                                    
22 
23 // Github - https://github.com/FortressFinance
24 
25 import {AMMConcentratorBase, ERC4626, ERC20, SafeERC20, Address, IERC20, IFortressSwap} from "src/shared/concentrators/AMMConcentratorBase.sol";
26 
27 import {ICurveOperations} from "src/shared/fortress-interfaces/ICurveOperations.sol";
28 import {IConvexBoosterArbi} from "src/arbitrum/interfaces/IConvexBoosterArbi.sol";
29 import {IConvexBasicRewardsArbi} from "src/arbitrum/interfaces/IConvexBasicRewardsArbi.sol";
30 import {IGlpMinter} from "src/arbitrum/interfaces/IGlpMinter.sol";
31 
32 contract CurveGlpConcentrator is AMMConcentratorBase {
33 
34     using SafeERC20 for IERC20;
35     using Address for address payable;
36 
37     struct GmxSettings {
38         /// @notice The address of the contract that mints and stakes GLP
39         address glpHandler;
40         /// @notice The address of the contract that needs an approval before minting GLP
41         address glpManager;
42     }
43 
44     /// @notice The GMX platform settings
45     GmxSettings public gmxSettings;
46 
47     /// @notice The address of the underlying Curve pool
48     address private immutable poolAddress;
49     /// @notice The type of the pool, used in ammOperations
50     uint256 private immutable poolType;
51 
52     /// @notice The address of sGLP token
53     address public constant sGLP = 0x5402B5F40310bDED796c7D0F3FF6683f5C0cFfdf;
54     /// @notice The address of WETH token (Arbitrum)
55     address internal constant WETH = 0x82aF49447D8a07e3bd95BD0d56f35241523fBab1;
56     
57     /********************************** Constructor **********************************/
58 
59     constructor (ERC20 _asset, string memory _name, string memory _symbol, bytes memory _settingsConfig, bytes memory _boosterConfig, address _compounder, address[] memory _underlyingAssets, uint256 _poolType)
60         AMMConcentratorBase (_asset, _name, _symbol, _settingsConfig, _boosterConfig, _compounder, _underlyingAssets) {
61             
62             IERC20(sGLP).safeApprove(_compounder, type(uint256).max);
63 
64             GmxSettings storage _gmxSettings = gmxSettings;
65 
66             _gmxSettings.glpHandler = 0xB95DB5B167D75e6d04227CfFFA61069348d271F5;
67             _gmxSettings.glpManager = 0x3963FfC9dff443c2A94f21b129D429891E32ec18;
68 
69             poolType = _poolType;
70             poolAddress = ICurveOperations(settings.ammOperations).getPoolFromLpToken(address(_asset));
71         }
72     
73     /********************************** View Functions **********************************/
74 
75     /// @notice See {AMMConcentratorBase - isPendingRewards}
76     function isPendingRewards() external override view returns (bool) {
77         /// The address of CRV token on Arbitrum
78         address _crv = address(0x11cDb42B0EB46D95f990BeDD4695A6e3fA034978);
79         return IConvexBasicRewardsArbi(boosterData.crvRewards).claimable_reward(_crv, address(this)) > 0;
80     }
81     
82     /********************************** Mutated Functions **********************************/
83 
84     /// @dev Adds the ability to choose the underlying asset to deposit to the GLP minter
85     /// @dev Harvest the pending rewards and convert to underlying token, then stake
86     /// @param _receiver - The address of account to receive harvest bounty
87     /// @param _minBounty - The minimum amount of harvest bounty _receiver should get
88     function harvest(address _receiver, address _underlyingAsset, uint256 _minBounty) external nonReentrant returns (uint256 _rewards) {
89         if (block.number == lastHarvestBlock) revert HarvestAlreadyCalled();
90         lastHarvestBlock = block.number;
91 
92         _rewards = _harvest(_receiver, _underlyingAsset, _minBounty);
93         accRewardPerShare = accRewardPerShare + ((_rewards * PRECISION) / totalSupply);
94 
95         return _rewards;
96     }
97 
98     /********************************** Restricted Functions **********************************/
99 
100     function updateGlpContracts(address _glpHandler, address _glpManager) external {
101         if (msg.sender != settings.owner) revert Unauthorized();
102 
103         GmxSettings storage _gmxSettings = gmxSettings;
104         _gmxSettings.glpHandler = _glpHandler;
105         _gmxSettings.glpManager = _glpManager;
106     }
107 
108     /********************************** Internal Functions **********************************/
109 
110     function _depositStrategy(uint256 _assets, bool _transfer) internal override {
111         if (_transfer) IERC20(address(asset)).safeTransferFrom(msg.sender, address(this), _assets);
112         Booster memory _boosterData = boosterData;
113         IConvexBoosterArbi(_boosterData.booster).deposit(_boosterData.boosterPoolId, _assets);
114     }
115 
116     function _withdrawStrategy(uint256 _assets, address _receiver, bool _transfer) internal override {
117         IConvexBasicRewardsArbi(boosterData.crvRewards).withdraw(_assets, false);
118         if (_transfer) IERC20(address(asset)).safeTransfer(_receiver, _assets);
119     }
120 
121     function _swapFromUnderlying(address _underlyingAsset, uint256 _underlyingAmount, uint256 _minAmount) internal override returns (uint256 _assets) {
122         address payable _ammOperations = settings.ammOperations;
123         if (_underlyingAsset == ETH) {
124             (bytes memory result) = _ammOperations.functionCallWithValue(
125                 abi.encodeWithSignature("addLiquidity(address,uint256,address,uint256)", poolAddress, poolType, _underlyingAsset, _underlyingAmount),
126                 _underlyingAmount
127             );
128             _assets = abi.decode(result, (uint256));
129         } else {
130             _approve(_underlyingAsset, _ammOperations, _underlyingAmount);
131             _assets = ICurveOperations(_ammOperations).addLiquidity(poolAddress, poolType, _underlyingAsset, _underlyingAmount);
132         }
133 
134         if (!(_assets >= _minAmount)) revert InsufficientAmountOut();
135     }
136 
137     function _swapToUnderlying(address _underlyingAsset, uint256 _assets, uint256 _minAmount) internal override returns (uint256 _underlyingAmount) {
138         address _ammOperations = settings.ammOperations;
139         _approve(address(asset), _ammOperations, _assets);
140         _underlyingAmount = ICurveOperations(_ammOperations).removeLiquidity(poolAddress, poolType, _underlyingAsset, _assets);
141         
142         if (!(_underlyingAmount >= _minAmount)) revert InsufficientAmountOut();
143     }
144 
145     function _harvest(address _receiver, uint256 _minBounty) internal override returns (uint256 _rewards) {
146         return _harvest(_receiver, WETH, _minBounty);
147     }
148 
149     function _harvest(address _receiver, address _underlyingAsset, uint256 _minBounty) internal returns (uint256 _rewards) {
150         Booster memory _boosterData = boosterData;
151         
152         IConvexBasicRewardsArbi(_boosterData.crvRewards).getReward(address(this));
153 
154         Settings memory _settings = settings;
155         address _token;
156         address _swap = _settings.swap;
157         address[] memory _rewardAssets = _boosterData.rewardAssets;
158         for (uint256 i = 0; i < _rewardAssets.length; i++) {
159             _token = _rewardAssets[i];
160             if (_token != _underlyingAsset) {
161                 uint256 _balance = IERC20(_token).balanceOf(address(this));
162                 if (_balance > 0) {
163                     IFortressSwap(_swap).swap(_token, _underlyingAsset, _balance);
164                 }
165             }
166         }
167 
168         _rewards = IERC20(_underlyingAsset).balanceOf(address(this));
169 
170         GmxSettings memory _gmxSettings = gmxSettings;
171         address _sGLP = sGLP;
172         uint256 _startBalance = IERC20(_sGLP).balanceOf(address(this));
173         _approve(_underlyingAsset, _gmxSettings.glpManager, _rewards);
174         IGlpMinter(_gmxSettings.glpHandler).mintAndStakeGlp(_underlyingAsset, _rewards, 0, 0);
175         _rewards = IERC20(_sGLP).balanceOf(address(this)) - _startBalance;
176         
177         if (_rewards > 0) {
178             Fees memory _fees = fees;
179             uint256 _platformFee = _fees.platformFeePercentage;
180             uint256 _harvestBounty = _fees.harvestBountyPercentage;
181             if (_platformFee > 0) {
182                 _platformFee = (_platformFee * _rewards) / FEE_DENOMINATOR;
183                 _rewards = _rewards - _platformFee;
184                 IERC20(_sGLP).safeTransfer(_settings.platform, _platformFee);
185             }
186             if (_harvestBounty > 0) {
187                 _harvestBounty = (_harvestBounty * _rewards) / FEE_DENOMINATOR;
188                 if (!(_harvestBounty >= _minBounty)) revert InsufficientAmountOut();
189 
190                 _rewards = _rewards - _harvestBounty;
191                 IERC20(_sGLP).safeTransfer(_receiver, _harvestBounty);
192             }
193 
194             _rewards = ERC4626(_settings.compounder).deposit(_rewards, address(this));
195             
196             emit Harvest(msg.sender, _receiver, _rewards, _platformFee);
197 
198             return _rewards;
199         } else {
200             revert NoPendingRewards();
201         }
202     }
203 
204     receive() external payable {}
205 }