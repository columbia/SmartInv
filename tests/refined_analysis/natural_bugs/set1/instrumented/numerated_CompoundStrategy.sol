1 // SPDX-License-Identifier: GPL-2.0-or-later
2 pragma solidity 0.8.10;
3 
4 /******************************************************************************\
5 * Author: Fran Rimoldi <dev@sherlock.xyz> (https://twitter.com/fran_rimoldi)
6 * Author: Evert Kors <dev@sherlock.xyz> (https://twitter.com/evert0x)
7 * Sherlock Protocol: https://sherlock.xyz
8 /******************************************************************************/
9 
10 import './base/BaseStrategy.sol';
11 import '../interfaces/compound/ICToken.sol';
12 import '../interfaces/compound/IComptroller.sol';
13 import { FixedPointMathLib } from '@rari-capital/solmate/src/utils/FixedPointMathLib.sol';
14 import { LibCompound } from './compound/LibCompound.sol';
15 
16 /**
17  *  This contract implements the logic to deposit and withdraw funds from Compound as a yield strategy.
18  *  Docs: https://compound.finance/docs
19  */
20 
21 contract CompoundStrategy is BaseStrategy {
22   using SafeERC20 for IERC20;
23   using FixedPointMathLib for uint256;
24 
25   // This is the receipt token Compound gives in exchange for a token deposit (cUSDC)
26   // https://compound.finance/docs#protocol-math
27   // https://github.com/compound-finance/compound-protocol/blob/master/contracts/CErc20.sol
28   // https://github.com/compound-finance/compound-protocol/blob/master/contracts/CToken.sol
29 
30   // https://compound.finance/docs#networks
31   // CUSDC address
32   ICToken public constant CUSDC = ICToken(0x39AA39c021dfbaE8faC545936693aC917d5E7563);
33   IComptroller public constant COMPTROLLER =
34     IComptroller(0x3d9819210A31b4961b30EF54bE2aeD79B9c9Cd3B);
35   IERC20 internal constant COMP = IERC20(0xc00e94Cb662C3520282E6f5717214004A7f26888);
36 
37   // Address to receive rewards
38   address public constant LIQUIDITY_MINING_RECEIVER = 0x666B8EbFbF4D5f0CE56962a25635CfF563F13161;
39 
40   /// @param _initialParent Contract that will be the parent in the tree structure
41   constructor(IMaster _initialParent) BaseNode(_initialParent) {
42     // Approve max USDC to cUSDC
43     want.safeIncreaseAllowance(address(CUSDC), type(uint256).max);
44   }
45 
46   /// @notice Signal if strategy is ready to be used
47   /// @return Boolean indicating if strategy is ready
48   function setupCompleted() external view override returns (bool) {
49     return true;
50   }
51 
52   /// @notice View the current balance of this strategy in USDC
53   /// @dev Since balanceOf() is pure, we can't use Compound's balanceOfUnderlying(adress) function
54   /// @dev We calculate the exchange rate ourselves instead using LibCompound
55   /// @dev Will return wrong balance if this contract somehow has USDC instead of only cUSDC
56   /// @return Amount of USDC in this strategy
57   function _balanceOf() internal view override returns (uint256) {
58     return LibCompound.viewUnderlyingBalanceOf(CUSDC, address(this));
59   }
60 
61   /// @notice Deposit all USDC in this contract into Compound
62   /// @notice Works under the assumption this contract contains USDC
63   function _deposit() internal override whenNotPaused {
64     uint256 amount = want.balanceOf(address(this));
65 
66     // https://compound.finance/docs/ctokens#mint
67     if (CUSDC.mint(amount) != 0) revert InvalidState();
68   }
69 
70   /// @notice Withdraw all USDC from Compound and send all USDC in contract to core
71   /// @return amount Amount of USDC withdrawn
72   function _withdrawAll() internal override returns (uint256 amount) {
73     uint256 cUSDCAmount = CUSDC.balanceOf(address(this));
74 
75     // If cUSDC.balanceOf(this) != 0, we can start to withdraw the eUSDC
76     if (cUSDCAmount != 0) {
77       // Revert if redeem function returns error code
78       if (CUSDC.redeem(cUSDCAmount) != 0) revert InvalidState();
79     }
80 
81     // Amount of USDC in the contract
82     // This can be >0 even if cUSDC balance = 0
83     // As it could have been transferred to this contract by accident
84     amount = want.balanceOf(address(this));
85 
86     // Transfer USDC to core
87     if (amount != 0) want.safeTransfer(core, amount);
88   }
89 
90   /// @notice Withdraw `_amount` USDC from Compound and send to core
91   /// @param _amount Amount of USDC to withdraw
92   function _withdraw(uint256 _amount) internal override {
93     // Revert if redeem function returns error code
94     if (CUSDC.redeemUnderlying(_amount) != 0) revert InvalidState();
95 
96     // Transfer USDC to core
97     want.safeTransfer(core, _amount);
98   }
99 
100   /// @notice Claim COMP tokens earned by supplying
101   /// @dev COMP tokens will be send to LIQUIDITY_MINING_RECEIVER
102   function claimReward() external {
103     // Claim COMP for address(this)
104     address[] memory holders = new address[](1);
105     holders[0] = address(this);
106 
107     // Claim COMP for CUSDC
108     ICToken[] memory tokens = new ICToken[](1);
109     tokens[0] = CUSDC;
110 
111     // Claim COMP tokens for CUSDC
112     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Comptroller.sol#L1341
113     COMPTROLLER.claimComp(holders, tokens, false, true);
114 
115     // How much COMP tokens does this contract hold
116     uint256 rewardBalance = COMP.balanceOf(address(this));
117 
118     // Send all COMP tokens to LIQUIDITY_MINING_RECEIVER
119     if (rewardBalance != 0) COMP.safeTransfer(LIQUIDITY_MINING_RECEIVER, rewardBalance);
120   }
121 }
