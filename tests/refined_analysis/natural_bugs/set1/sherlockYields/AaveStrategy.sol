// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity 0.8.10;

/******************************************************************************\
* Author: Evert Kors <dev@sherlock.xyz> (https://twitter.com/evert0x)
* Sherlock Protocol: https://sherlock.xyz
/******************************************************************************/

import './base/BaseStrategy.sol';

import '../interfaces/aaveV2/ILendingPool.sol';
import '../interfaces/aaveV2/ILendingPoolAddressesProvider.sol';
import '../interfaces/aaveV2/IAaveIncentivesController.sol';
import '../interfaces/aaveV2/IStakeAave.sol';
import '../interfaces/aaveV2/IAToken.sol';

// This contract contains logic for depositing staker funds into Aave as a yield strategy

contract AaveStrategy is BaseStrategy {
  using SafeERC20 for IERC20;

  // Need to call a provider because Aave has the ability to change the lending pool address
  ILendingPoolAddressesProvider public constant LP_ADDRESS_PROVIDER =
    ILendingPoolAddressesProvider(0xB53C1a33016B2DC2fF3653530bfF1848a515c8c5);

  // Aave contract that controls stkAAVE rewards
  IAaveIncentivesController public immutable aaveIncentivesController;

  // This is the receipt token Aave gives in exchange for a token deposit (aUSDC)
  IAToken public immutable aWant;

  // Address to receive stkAAVE rewards
  address public immutable aaveLmReceiver;

  // Constructor takes the aUSDC address and the rewards receiver address (a Sherlock address) as args
  /// @param _initialParent Contract that will be the parent in the tree structure
  /// @param _aWant aUSDC addresss
  /// @param _aaveLmReceiver Receiving address of the stkAAVE tokens earned by staking
  constructor(
    IMaster _initialParent,
    IAToken _aWant,
    address _aaveLmReceiver
  ) BaseNode(_initialParent) {
    if (address(_aWant) == address(0)) revert ZeroArg();
    if (_aaveLmReceiver == address(0)) revert ZeroArg();

    aWant = _aWant;
    // Gets the specific rewards controller for this token type
    aaveIncentivesController = _aWant.getIncentivesController();

    aaveLmReceiver = _aaveLmReceiver;
  }

  /// @notice Signal if strategy is ready to be used
  /// @return Boolean indicating if strategy is ready
  function setupCompleted() external view override returns (bool) {
    return true;
  }

  /// @return The current Aave lending pool address that should be used
  function getLp() internal view returns (ILendingPool) {
    return ILendingPool(LP_ADDRESS_PROVIDER.getLendingPool());
  }

  /// @notice View the current balance of this strategy in USDC
  /// @dev Will return wrong balance if this contract somehow has USDC instead of only aUSDC
  /// @return Amount of USDC in this strategy
  function _balanceOf() internal view override returns (uint256) {
    // 1 aUSDC = 1 USDC
    return aWant.balanceOf(address(this));
  }

  /// @notice Deposits all USDC held in this contract into Aave's lending pool
  /// @notice Works under the assumption this contract contains USDC
  function _deposit() internal override whenNotPaused {
    ILendingPool lp = getLp();
    // Checking the USDC balance of this contract
    uint256 amount = want.balanceOf(address(this));
    if (amount == 0) revert InvalidState();

    // If allowance for this contract is too low, approve the max allowance
    // Will occur if the `lp` address changes
    if (want.allowance(address(this), address(lp)) < amount) {
      // `safeIncreaseAllowance` can fail if it adds `type(uint256).max` to a non-zero value
      // This is very unlikely as we have to have an ungodly amount of USDC pass this system for
      // The allowance to reach a human interpretable number
      want.safeIncreaseAllowance(address(lp), type(uint256).max);
    }

    // Deposits the full balance of USDC held in this contract into Aave's lending pool
    lp.deposit(address(want), amount, address(this), 0);
  }

  /// @notice Withdraws all USDC from Aave's lending pool back into core
  /// @return Amount of USDC withdrawn
  function _withdrawAll() internal override returns (uint256) {
    ILendingPool lp = getLp();
    if (_balanceOf() == 0) {
      return 0;
    }
    // Withdraws all USDC from Aave's lending pool and sends it to core
    return lp.withdraw(address(want), type(uint256).max, core);
  }

  /// @notice Withdraws a specific amount of USDC from Aave's lending pool back into core
  /// @param _amount Amount of USDC to withdraw
  function _withdraw(uint256 _amount) internal override {
    // Ensures that it doesn't execute a withdrawAll() call
    // AAVE uses uint256.max as a magic number to withdraw max amount
    if (_amount == type(uint256).max) revert InvalidArg();

    ILendingPool lp = getLp();
    // Withdraws _amount of USDC and sends it to core
    // If the amount withdrawn is not equal to _amount, it reverts
    if (lp.withdraw(address(want), _amount, core) != _amount) revert InvalidState();
  }

  // Claims the stkAAVE rewards and sends them to the receiver address
  function claimReward() external {
    // Creates an array with one slot
    address[] memory assets = new address[](1);
    // Sets the slot equal to the address of aUSDC
    assets[0] = address(aWant);

    // Claims all the rewards on aUSDC and sends them to the aaveLmReceiver (an address controlled by governance)
    // Tokens are NOT meant to be (directly) distributed to stakers.
    aaveIncentivesController.claimRewards(assets, type(uint256).max, aaveLmReceiver);
  }
}
