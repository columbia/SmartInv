// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity 0.8.10;

/******************************************************************************\
* Author: Evert Kors <dev@sherlock.xyz> (https://twitter.com/evert0x)
* Sherlock Protocol: https://sherlock.xyz
/******************************************************************************/

import './base/BaseStrategy.sol';

import '../interfaces/truefi/ITrueFiPool2.sol';
import '../interfaces/truefi/ITrueMultiFarm.sol';

// This contract contains logic for depositing staker funds into TrueFi as a yield strategy
// https://github.com/trusttoken/contracts-pre22/blob/main/contracts/truefi2/TrueFiPool2.sol
// https://docs.truefi.io/faq/main-lending-pools/pool#lending-pools-smart-contracts

// TRU farming
// https://docs.truefi.io/faq/main-lending-pools/farming-liquidity-mining

// Joining fee is currently 0, is able to change

/*
Thoughts on adding `liquidExitPenalty` to `balanceOf()`

In the most extreme example where all our money is in TrueFi and we don't assume the exit fee,
people will see balance = 100 USDC, but when actually withdrawing it will be 90 USDC
(because of the exit fee)

In the other most extreme example where all our money is not yet in TrueFi and we do assume the exit fee,
people can see balance = 100 USDC but when we deposit it, it will be 90 USDC (because of the exit fee)
(note: this affects the exit fee in a positive way as it adds liquidity)

^ these extremes assume our deposits/withdraws don't have any effect on the exit fee.
But with the current 180m$ pool it will take 9m$ to move the poolLiquidty 5%,
which is 0.91% -> 10% in the most extreme scenario

Takeaways
- We want to account the exit fee to not 'surprise' people on withdraw with a lower balance
- We want to be a small part of the pool (<=5%?) to keep it liquid and not move the exitFee to 10% on exit.

What happen if we are a large part of the pool?

For example if balanceOf = totalSupply and we have deposited 100 USDC
Only 10 USDC is liquid (10%) which makes the exit fee 0.48%

`balanceOf()` would show 99,52 USDC as the exit fee is applied
If we call `liquidExit()` with 10 USDC, 0% will be liquid and the exit fee jumps up to 10%
`balanceOf()` would show 10 USDC + 81 (90 USDC - 10% exit fee) = 91 USDC
*/

// All tfUSDC will be staked in the farm at any time (except runtime of a transaction)
contract TrueFiStrategy is BaseStrategy {
  using SafeERC20 for IERC20;
  using SafeERC20 for ITrueFiPool2;

  // Value copied from https://github.com/trusttoken/contracts-pre22/blob/main/contracts/truefi2/TrueFiPool2.sol#L487
  uint256 private constant BASIS_PRECISION = 10000;

  // the tfUSDC pool
  ITrueFiPool2 public constant tfUSDC = ITrueFiPool2(0xA991356d261fbaF194463aF6DF8f0464F8f1c742);
  // TrueFi farm, used to stake tfUSDC and earn TrueFi tokens
  ITrueMultiFarm public constant tfFarm =
    ITrueMultiFarm(0xec6c3FD795D6e6f202825Ddb56E01b3c128b0b10);
  // The TrueFi token
  IERC20 public constant rewardToken = IERC20(0x4C19596f5aAfF459fA38B0f7eD92F11AE6543784);

  // Address to receive rewards
  address public constant LIQUIDITY_MINING_RECEIVER = 0x666B8EbFbF4D5f0CE56962a25635CfF563F13161;

  /// @param _initialParent Contract that will be the parent in the tree structure
  constructor(IMaster _initialParent) BaseNode(_initialParent) {
    // Approve tfUSDC max amount of USDC
    want.safeIncreaseAllowance(address(tfUSDC), type(uint256).max);
    // Approve tfFarm max amount of tfUSDC
    tfUSDC.safeIncreaseAllowance(address(tfFarm), type(uint256).max);
  }

  /// @notice Signal if strategy is ready to be used
  /// @return Boolean indicating if strategy is ready
  function setupCompleted() external view override returns (bool) {
    return true;
  }

  /// @notice Deposit all USDC in this contract in TrueFi
  /// @notice Joining fee may apply, this will lower the balance of the system on deposit
  /// @notice Works under the assumption this contract contains USDC
  function _deposit() internal override whenNotPaused {
    // https://github.com/trusttoken/contracts-pre22/blob/main/contracts/truefi2/TrueFiPool2.sol#L469
    tfUSDC.join(want.balanceOf(address(this)));

    // Don't stake in the tfFarm if shares are 0
    // This would make the function call revert
    // https://github.com/trusttoken/contracts-pre22/blob/main/contracts/truefi2/TrueMultiFarm.sol#L101
    if (tfFarm.getShare(tfUSDC) == 0) return;

    // How much tfUSDC is in this contract
    // Could both be tfUSDC that was already in here before the `_deposit()` call
    // And new tfUSDC that was minted in the `tfUSDC.join()` call
    uint256 tfUsdcBalance = tfUSDC.balanceOf(address(this));

    // Stake all tfUSDC in the tfFarm
    tfFarm.stake(tfUSDC, tfUsdcBalance);
  }

  /// @notice Send all USDC in this contract to core
  /// @notice Funds need to be withdrawn using `liquidExit()` first
  /// @return amount Amount of USDC withdrawn
  function _withdrawAll() internal override returns (uint256 amount) {
    // Amount of USDC in the contract
    amount = want.balanceOf(address(this));
    // Transfer USDC to core
    if (amount != 0) want.safeTransfer(core, amount);
  }

  /// @notice Send `_amount` USDC in this contract to core
  /// @notice Funds need to be withdrawn using `liquidExit()` first
  /// @param _amount Amount of USDC to withdraw
  function _withdraw(uint256 _amount) internal override {
    // Transfer USDC to core
    want.safeTransfer(core, _amount);
  }

  /// @notice View how much tfUSDC is staked in the farm
  /// @return Amount of tfUSDC staked
  function _viewTfUsdcStaked() private view returns (uint256) {
    // Amount of tfUSDC staked in the tfFarm
    return tfFarm.staked(tfUSDC, address(this));
  }

  /// @notice View USDC in this contract + USDC in TrueFi
  /// @notice Takes into account exit penalty for liquidating full tfUSDC balance
  /// @return Amount of USDC in this strategy
  function _balanceOf() internal view override returns (uint256) {
    // https://docs.truefi.io/faq/main-lending-pools/developer-guide/truefipool2-contract#calculating-lending-pool-token-prices

    // How much USDC is locked in TrueFi
    // Based on staked tfUSDC + tfUSDC in this contract
    uint256 tfUsdcBalance = (tfUSDC.poolValue() *
      (_viewTfUsdcStaked() + tfUSDC.balanceOf(address(this)))) / tfUSDC.totalSupply();

    // How much USDC we get if we liquidate the full position
    tfUsdcBalance = (tfUsdcBalance * tfUSDC.liquidExitPenalty(tfUsdcBalance)) / BASIS_PRECISION;

    // Return USDC in contract + USDC we can get from TrueFi
    return want.balanceOf(address(this)) + tfUsdcBalance;
  }

  /// @notice Exit `_amount` of tfUSDC (pool LP tokens)
  /// @notice Up to 10% exit fee may apply.
  /// @notice There are two situations in which the pool will not let you withdraw via Liquid Exit:
  /// @notice 1) If there is no liquid asset in the lending pool and no liquid exit is deployed in Curve.
  /// @notice 2) If the pool needs to liquidate its position in Curve and will incur a loss of more than 10 basis points.
  /// @dev Can only be called by owner
  function liquidExit(uint256 _amount) external onlyOwner {
    // https://github.com/trusttoken/contracts-pre22/blob/main/contracts/truefi2/TrueFiPool2.sol#L487
    // here's a spreadsheet that shows the exit penalty at different liquidRatio levels ( = liquidValue / poolValue):
    // https://docs.google.com/spreadsheets/d/1ZXGRxunIwe0eYPu7j4QjCwXxe63tNKtpCvRiJnqK0jo/edit#gid=0

    // Exiting 0 tokens doesn't make sense
    if (_amount == 0) revert ZeroArg();

    // Amount of tfUSDC in this contract
    uint256 tfUsdcBalance = tfUSDC.balanceOf(address(this));
    uint256 tfUsdcStaked = _viewTfUsdcStaked();

    // Exit MAX amount of tokens
    if (_amount == type(uint256).max) {
      _amount = tfUsdcBalance + tfUsdcStaked;
      // Exiting 0 tokens doesn't make sense
      if (_amount == 0) revert InvalidState();
    }
    // We can not withdraw more tfUSDC than we have access to
    else if (_amount > tfUsdcBalance + tfUsdcStaked) revert InvalidArg();

    // Unstake tfUSDC if it isn't in the contract already
    if (_amount > tfUsdcBalance) {
      // Unstake tfUSDC from tfFarm so we are able to exit `_amount`
      tfFarm.unstake(tfUSDC, _amount - tfUsdcBalance);
    }

    // At this point there should be at least `_amount` of tfUSDC in the contract
    // Unstake tfUSDC tokens from the pool, this will send USDC to this contract
    tfUSDC.liquidExit(_amount);
  }

  /// @notice Claim TrueFi tokens earned by farming
  /// @dev TrueFi tokens will be send to LIQUIDITY_MINING_RECEIVER
  function claimReward() external {
    IERC20[] memory tokens = new IERC20[](1);
    tokens[0] = tfUSDC;

    // Claim TrueFi tokens for tfUSDC
    tfFarm.claim(tokens);

    // How much TrueFi tokens does this contract hold
    uint256 rewardBalance = rewardToken.balanceOf(address(this));

    // Send all TrueFi tokens to LIQUIDITY_MINING_RECEIVER
    if (rewardBalance != 0) rewardToken.safeTransfer(LIQUIDITY_MINING_RECEIVER, rewardBalance);
  }
}
