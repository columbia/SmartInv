1 // SPDX-License-Identifier: GPL-2.0-or-later
2 pragma solidity 0.8.10;
3 
4 /******************************************************************************\
5 * Author: Evert Kors <dev@sherlock.xyz> (https://twitter.com/evert0x)
6 * Sherlock Protocol: https://sherlock.xyz
7 /******************************************************************************/
8 
9 import './base/BaseStrategy.sol';
10 
11 import '../interfaces/euler/IEulerEToken.sol';
12 
13 // This contract contains logic for depositing staker funds into Euler as a yield strategy
14 // https://docs.euler.finance/developers/integration-guide#deposit-and-withdraw
15 
16 // EUL rewards are not integrated as it's only for accounts that borrow.
17 // We don't borrow in this strategy.
18 
19 contract EulerStrategy is BaseStrategy {
20   using SafeERC20 for IERC20;
21 
22   // Sub account used for Euler interactions
23   uint256 private constant SUB_ACCOUNT = 0;
24 
25   // https://docs.euler.finance/protocol/addresses
26   address public constant EULER = 0x27182842E098f60e3D576794A5bFFb0777E025d3;
27   // https://github.com/euler-xyz/euler-contracts/blob/master/contracts/modules/EToken.sol
28   IEulerEToken public constant EUSDC = IEulerEToken(0xEb91861f8A4e1C12333F42DCE8fB0Ecdc28dA716);
29 
30   /// @param _initialParent Contract that will be the parent in the tree structure
31   constructor(IMaster _initialParent) BaseNode(_initialParent) {
32     // Approve Euler max amount of USDC
33     want.safeIncreaseAllowance(EULER, type(uint256).max);
34   }
35 
36   /// @notice Signal if strategy is ready to be used
37   /// @return Boolean indicating if strategy is ready
38   function setupCompleted() external view override returns (bool) {
39     return true;
40   }
41 
42   /// @notice View the current balance of this strategy in USDC
43   /// @dev Will return wrong balance if this contract somehow has USDC instead of only eUSDC
44   /// @return Amount of USDC in this strategy
45   function _balanceOf() internal view override returns (uint256) {
46     return EUSDC.balanceOfUnderlying(address(this));
47   }
48 
49   /// @notice Deposit all USDC in this contract in Euler
50   /// @notice Works under the assumption this contract contains USDC
51   function _deposit() internal override whenNotPaused {
52     // Deposit all current balance into euler
53     // https://github.com/euler-xyz/euler-contracts/blob/master/contracts/modules/EToken.sol#L148
54     EUSDC.deposit(SUB_ACCOUNT, type(uint256).max);
55   }
56 
57   /// @notice Withdraw all USDC from Euler and send all USDC in contract to core
58   /// @return amount Amount of USDC withdrawn
59   function _withdrawAll() internal override returns (uint256 amount) {
60     // If eUSDC.balanceOf(this) != 0, we can start to withdraw the eUSDC
61     if (EUSDC.balanceOf(address(this)) != 0) {
62       // Withdraw all underlying using max, this will translate to the full balance
63       // https://github.com/euler-xyz/euler-contracts/blob/master/contracts/BaseLogic.sol#L387
64       EUSDC.withdraw(SUB_ACCOUNT, type(uint256).max);
65     }
66 
67     // Amount of USDC in the contract
68     // This can be >0 even if eUSDC balance = 0
69     // As it could have been transferred to this contract by accident
70     amount = want.balanceOf(address(this));
71     // Transfer USDC to core
72     if (amount != 0) want.safeTransfer(core, amount);
73   }
74 
75   /// @notice Withdraw `_amount` USDC from Euler and send to core
76   /// @param _amount Amount of USDC to withdraw
77   function _withdraw(uint256 _amount) internal override {
78     // Don't allow to withdraw max (reserved with withdrawAll call)
79     if (_amount == type(uint256).max) revert InvalidArg();
80 
81     // Call withdraw with underlying amount of tokens (USDC instead of eUSDC)
82     // https://github.com/euler-xyz/euler-contracts/blob/master/contracts/modules/EToken.sol#L177
83     EUSDC.withdraw(SUB_ACCOUNT, _amount);
84 
85     // Transfer USDC to core
86     want.safeTransfer(core, _amount);
87   }
88 }
