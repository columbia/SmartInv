// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity 0.8.10;

/******************************************************************************\
* Author: Evert Kors <dev@sherlock.xyz> (https://twitter.com/evert0x)
* Sherlock Protocol: https://sherlock.xyz
/******************************************************************************/

import './base/BaseStrategy.sol';

import '../interfaces/euler/IEulerEToken.sol';

// This contract contains logic for depositing staker funds into Euler as a yield strategy
// https://docs.euler.finance/developers/integration-guide#deposit-and-withdraw

// EUL rewards are not integrated as it's only for accounts that borrow.
// We don't borrow in this strategy.

contract EulerStrategy is BaseStrategy {
  using SafeERC20 for IERC20;

  // Sub account used for Euler interactions
  uint256 private constant SUB_ACCOUNT = 0;

  // https://docs.euler.finance/protocol/addresses
  address public constant EULER = 0x27182842E098f60e3D576794A5bFFb0777E025d3;
  // https://github.com/euler-xyz/euler-contracts/blob/master/contracts/modules/EToken.sol
  IEulerEToken public constant EUSDC = IEulerEToken(0xEb91861f8A4e1C12333F42DCE8fB0Ecdc28dA716);

  /// @param _initialParent Contract that will be the parent in the tree structure
  constructor(IMaster _initialParent) BaseNode(_initialParent) {
    // Approve Euler max amount of USDC
    want.safeIncreaseAllowance(EULER, type(uint256).max);
  }

  /// @notice Signal if strategy is ready to be used
  /// @return Boolean indicating if strategy is ready
  function setupCompleted() external view override returns (bool) {
    return true;
  }

  /// @notice View the current balance of this strategy in USDC
  /// @dev Will return wrong balance if this contract somehow has USDC instead of only eUSDC
  /// @return Amount of USDC in this strategy
  function _balanceOf() internal view override returns (uint256) {
    return EUSDC.balanceOfUnderlying(address(this));
  }

  /// @notice Deposit all USDC in this contract in Euler
  /// @notice Works under the assumption this contract contains USDC
  function _deposit() internal override whenNotPaused {
    // Deposit all current balance into euler
    // https://github.com/euler-xyz/euler-contracts/blob/master/contracts/modules/EToken.sol#L148
    EUSDC.deposit(SUB_ACCOUNT, type(uint256).max);
  }

  /// @notice Withdraw all USDC from Euler and send all USDC in contract to core
  /// @return amount Amount of USDC withdrawn
  function _withdrawAll() internal override returns (uint256 amount) {
    // If eUSDC.balanceOf(this) != 0, we can start to withdraw the eUSDC
    if (EUSDC.balanceOf(address(this)) != 0) {
      // Withdraw all underlying using max, this will translate to the full balance
      // https://github.com/euler-xyz/euler-contracts/blob/master/contracts/BaseLogic.sol#L387
      EUSDC.withdraw(SUB_ACCOUNT, type(uint256).max);
    }

    // Amount of USDC in the contract
    // This can be >0 even if eUSDC balance = 0
    // As it could have been transferred to this contract by accident
    amount = want.balanceOf(address(this));
    // Transfer USDC to core
    if (amount != 0) want.safeTransfer(core, amount);
  }

  /// @notice Withdraw `_amount` USDC from Euler and send to core
  /// @param _amount Amount of USDC to withdraw
  function _withdraw(uint256 _amount) internal override {
    // Don't allow to withdraw max (reserved with withdrawAll call)
    if (_amount == type(uint256).max) revert InvalidArg();

    // Call withdraw with underlying amount of tokens (USDC instead of eUSDC)
    // https://github.com/euler-xyz/euler-contracts/blob/master/contracts/modules/EToken.sol#L177
    EUSDC.withdraw(SUB_ACCOUNT, _amount);

    // Transfer USDC to core
    want.safeTransfer(core, _amount);
  }
}
