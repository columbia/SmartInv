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
17 //  _____ _     _____                             _         
18 // |   __| |___|     |___ _____ ___ ___ _ _ ___ _| |___ ___ 
19 // |  |  | | . |   --| . |     | . | . | | |   | . | -_|  _|
20 // |_____|_|  _|_____|___|_|_|_|  _|___|___|_|_|___|___|_|  
21 //         |_|                 |_|                          
22 
23 // Github - https://github.com/FortressFinance
24 
25 import {Address} from "lib/openzeppelin-contracts/contracts/utils/Address.sol";
26 
27 import {TokenCompounderBase, ERC20, IERC20, SafeERC20} from "src/shared/compounders/TokenCompounderBase.sol";
28 
29 import {IWETH} from "src/shared/interfaces/IWETH.sol";
30 import {IFortressSwap} from "src/shared/fortress-interfaces/IFortressSwap.sol";
31 import {IGlpRewardHandler} from "src/arbitrum/interfaces/IGlpRewardHandler.sol";
32 import {IGlpMinter} from "src/arbitrum/interfaces/IGlpMinter.sol";
33 import {IGlpRewardTracker} from "src/arbitrum/interfaces/IGlpRewardTracker.sol";
34 
35 contract GlpCompounder is TokenCompounderBase {
36 
37     using SafeERC20 for IERC20;
38     using Address for address payable;
39 
40     /// @notice The address of the contract that handles rewards
41     address public rewardHandler;
42     /// @notice The address of the contract that trackes ETH rewards
43     address public rewardTracker;
44     /// @notice The address of the contract that mints and stakes GLP
45     address public glpHandler;
46     /// @notice The address of the contract that needs an approval before minting GLP
47     address public glpManager;
48 
49     /// @notice The address of sGLP token
50     address public constant sGLP = 0x5402B5F40310bDED796c7D0F3FF6683f5C0cFfdf;
51     /// @notice The address of WETH token.
52     address public constant WETH = 0x82aF49447D8a07e3bd95BD0d56f35241523fBab1;
53     /// @notice The address representing ETH
54     address internal constant ETH = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
55     
56     /********************************** Constructor **********************************/
57     
58     constructor(string memory _description, address _owner, address _platform, address _swap, address[] memory _underlyingAssets)
59         TokenCompounderBase(ERC20(sGLP), "Fortress Compounding GLP", "fcGLP", _description, _owner, _platform, _swap, _underlyingAssets) {
60         
61         IERC20(WETH).safeApprove(_swap, type(uint256).max);
62 
63         rewardHandler = 0xA906F338CB21815cBc4Bc87ace9e68c87eF8d8F1;
64         rewardTracker = 0x4e971a87900b931fF39d1Aad67697F49835400b6;
65         glpHandler = 0xB95DB5B167D75e6d04227CfFFA61069348d271F5;
66         glpManager = 0x3963FfC9dff443c2A94f21b129D429891E32ec18;
67     }
68 
69     /********************************** View Functions **********************************/
70 
71     /// @notice Returns the amount of ETH pending rewards (without accounting for other rewards)
72     function pendingRewards() public view returns (uint256) {
73         return IGlpRewardTracker(rewardTracker).claimable(address(this));
74     }
75 
76     /// @notice See {TokenCompounderBase - isPendingRewards}
77     function isPendingRewards() public view override returns (bool) {
78         return (pendingRewards() > 0);
79     }
80 
81     /********************************** Mutated Functions **********************************/
82 
83     /// @notice See {TokenCompounderBase - depositUnderlying}
84     function depositUnderlying(address _underlyingAsset, address _receiver, uint256 _underlyingAmount, uint256 _minAmount) public override payable nonReentrant returns (uint256 _shares) {
85         if (!(_underlyingAmount > 0)) revert ZeroAmount();
86         if (!_isUnderlyingAsset(_underlyingAsset)) revert NotUnderlyingAsset();
87 
88         if (msg.value > 0) {
89             if (_underlyingAsset != ETH) revert NotUnderlyingAsset();
90             if (msg.value != _underlyingAmount) revert InvalidAmount();
91 
92             _underlyingAsset = WETH;
93             payable(_underlyingAsset).functionCallWithValue(abi.encodeWithSignature("deposit()"), _underlyingAmount);
94         } else {
95             IERC20(_underlyingAsset).safeTransferFrom(msg.sender, address(this), _underlyingAmount);
96         }
97 
98         address _sGLP = sGLP;
99         uint256 _before = IERC20(_sGLP).balanceOf(address(this));
100         _approve(_underlyingAsset, glpManager, _underlyingAmount);
101         IGlpMinter(glpHandler).mintAndStakeGlp(_underlyingAsset, _underlyingAmount, 0, 0);
102         uint256 _assets = IERC20(_sGLP).balanceOf(address(this)) - _before;
103         if (!(_assets >= _minAmount)) revert InsufficientAmountOut();
104 
105         if (_assets >= maxDeposit(msg.sender)) revert InsufficientDepositCap();
106         
107         _shares = previewDeposit(_assets);
108         _deposit(msg.sender, _receiver, _assets, _shares);
109 
110         return _shares;
111     }
112 
113     /// @notice See {TokenCompounderBase - redeemUnderlying}
114     function redeemUnderlying(address _underlyingAsset, address _receiver, address _owner, uint256 _shares, uint256 _minAmount) public override nonReentrant returns (uint256 _underlyingAmount) {
115         if (_shares > maxRedeem(_owner)) revert InsufficientBalance();
116         if (!_isUnderlyingAsset(_underlyingAsset)) revert NotUnderlyingAsset();
117 
118         // If the _owner is whitelisted, we can skip the preview and just convert the shares to assets
119         uint256 _assets = feelessRedeemerWhitelist[_owner] ? convertToAssets(_shares) : previewRedeem(_shares);
120 
121         _withdraw(msg.sender, _receiver, _owner, _assets, _shares);
122 
123         if (_underlyingAsset == ETH) {
124             _underlyingAmount = IGlpMinter(glpHandler).unstakeAndRedeemGlpETH(_assets, 0, payable(_receiver));
125         } else {
126             _underlyingAmount = IGlpMinter(glpHandler).unstakeAndRedeemGlp(_underlyingAsset, _assets, 0, _receiver);
127         }
128         if (!(_underlyingAmount >= _minAmount)) revert InsufficientAmountOut();
129 
130         return _underlyingAmount;
131     }
132 
133     /// @dev Adds the ability to choose the underlying asset to deposit to the base function
134     /// @dev Harvest the pending rewards and convert to underlying token, then stake
135     /// @param _receiver - The address of account to receive harvest bounty
136     /// @param _minBounty - The minimum amount of harvest bounty _receiver should get
137     function harvest(address _receiver, address _underlyingAsset, uint256 _minBounty) external nonReentrant returns (uint256 _rewards) {
138         if (!_isUnderlyingAsset(_underlyingAsset)) revert NotUnderlyingAsset();
139         if (block.number == lastHarvestBlock) revert HarvestAlreadyCalled();
140         lastHarvestBlock = block.number;
141 
142         _rewards = _harvest(_receiver, _underlyingAsset, _minBounty);
143         totalAUM += _rewards;
144 
145         return _rewards;
146     }
147 
148     /********************************** Restricted Functions **********************************/
149 
150     function updateGlpContracts(address _rewardHandler, address _rewardsTracker, address _glpHandler, address _glpManager) external {
151         if (msg.sender != owner) revert Unauthorized();
152 
153         rewardHandler = _rewardHandler;
154         rewardTracker = _rewardsTracker;
155         glpHandler = _glpHandler;
156         glpManager = _glpManager;
157     }
158 
159     /********************************** Internal Functions **********************************/
160 
161     function _harvest(address _receiver, uint256 _minBounty) internal override returns (uint256 _rewards) {
162         return _harvest(_receiver, WETH, _minBounty);
163     }
164 
165     function _harvest(address _receiver, address _underlyingAsset, uint256 _minBounty) internal returns (uint256 _rewards) {
166         address _sGLP = sGLP;
167         uint256 _startBalance = IERC20(_sGLP).balanceOf(address(this));
168         
169         // Claim rewards - compound GMX, esGMX, and MP rewards. Claim ETH rewards as WETH
170         IGlpRewardHandler(rewardHandler).handleRewards(true, false, true, true, true, true, false);
171 
172         address _weth = WETH;
173         uint256 _balance = IERC20(_weth).balanceOf(address(this));
174         
175         if (_underlyingAsset != _weth) {
176             _balance = IFortressSwap(swap).swap(_weth, _underlyingAsset, _balance);
177         }
178 
179         _approve(_underlyingAsset, glpManager, _balance);
180         IGlpMinter(glpHandler).mintAndStakeGlp(_underlyingAsset, _balance, 0, 0);
181         _rewards = IERC20(_sGLP).balanceOf(address(this)) - _startBalance;
182         
183         if (_rewards > 0) {
184             Fees memory _fees = fees;
185             uint256 _platformFee = _fees.platformFeePercentage;
186             uint256 _harvestBounty = _fees.harvestBountyPercentage;
187             if (_platformFee > 0) {
188                 _platformFee = (_platformFee * _rewards) / FEE_DENOMINATOR;
189                 _rewards = _rewards - _platformFee;
190                 IERC20(_sGLP).safeTransfer(platform, _platformFee);
191             }
192             if (_harvestBounty > 0) {
193                 _harvestBounty = (_harvestBounty * _rewards) / FEE_DENOMINATOR;
194                 if (!(_harvestBounty >= _minBounty)) revert InsufficientAmountOut();
195                 
196                 _rewards = _rewards - _harvestBounty;
197                 IERC20(_sGLP).safeTransfer(_receiver, _harvestBounty);
198             }
199             
200             emit Harvest(_receiver, _rewards);
201             return _rewards;
202         } else {
203             revert NoPendingRewards();
204         }
205     }
206 
207     function _approve(address _token, address _spender, uint256 _amount) internal {
208         IERC20(_token).safeApprove(_spender, 0);
209         IERC20(_token).safeApprove(_spender, _amount);
210     }
211 }