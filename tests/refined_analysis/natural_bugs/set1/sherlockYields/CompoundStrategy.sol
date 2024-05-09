// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity 0.8.10;

/******************************************************************************\
* Author: Fran Rimoldi <dev@sherlock.xyz> (https://twitter.com/fran_rimoldi)
* Author: Evert Kors <dev@sherlock.xyz> (https://twitter.com/evert0x)
* Sherlock Protocol: https://sherlock.xyz
/******************************************************************************/

import './base/BaseStrategy.sol';
import '../interfaces/compound/ICToken.sol';
import '../interfaces/compound/IComptroller.sol';
import { FixedPointMathLib } from '@rari-capital/solmate/src/utils/FixedPointMathLib.sol';
import { LibCompound } from './compound/LibCompound.sol';

/**
 *  This contract implements the logic to deposit and withdraw funds from Compound as a yield strategy.
 *  Docs: https://compound.finance/docs
 */

contract CompoundStrategy is BaseStrategy {
  using SafeERC20 for IERC20;
  using FixedPointMathLib for uint256;

  // This is the receipt token Compound gives in exchange for a token deposit (cUSDC)
  // https://compound.finance/docs#protocol-math
  // https://github.com/compound-finance/compound-protocol/blob/master/contracts/CErc20.sol
  // https://github.com/compound-finance/compound-protocol/blob/master/contracts/CToken.sol

  // https://compound.finance/docs#networks
  // CUSDC address
  ICToken public constant CUSDC = ICToken(0x39AA39c021dfbaE8faC545936693aC917d5E7563);
  IComptroller public constant COMPTROLLER =
    IComptroller(0x3d9819210A31b4961b30EF54bE2aeD79B9c9Cd3B);
  IERC20 internal constant COMP = IERC20(0xc00e94Cb662C3520282E6f5717214004A7f26888);

  // Address to receive rewards
  address public constant LIQUIDITY_MINING_RECEIVER = 0x666B8EbFbF4D5f0CE56962a25635CfF563F13161;

  /// @param _initialParent Contract that will be the parent in the tree structure
  constructor(IMaster _initialParent) BaseNode(_initialParent) {
    // Approve max USDC to cUSDC
    want.safeIncreaseAllowance(address(CUSDC), type(uint256).max);
  }

  /// @notice Signal if strategy is ready to be used
  /// @return Boolean indicating if strategy is ready
  function setupCompleted() external view override returns (bool) {
    return true;
  }

  /// @notice View the current balance of this strategy in USDC
  /// @dev Since balanceOf() is pure, we can't use Compound's balanceOfUnderlying(adress) function
  /// @dev We calculate the exchange rate ourselves instead using LibCompound
  /// @dev Will return wrong balance if this contract somehow has USDC instead of only cUSDC
  /// @return Amount of USDC in this strategy
  function _balanceOf() internal view override returns (uint256) {
    return LibCompound.viewUnderlyingBalanceOf(CUSDC, address(this));
  }

  /// @notice Deposit all USDC in this contract into Compound
  /// @notice Works under the assumption this contract contains USDC
  function _deposit() internal override whenNotPaused {
    uint256 amount = want.balanceOf(address(this));

    // https://compound.finance/docs/ctokens#mint
    if (CUSDC.mint(amount) != 0) revert InvalidState();
  }

  /// @notice Withdraw all USDC from Compound and send all USDC in contract to core
  /// @return amount Amount of USDC withdrawn
  function _withdrawAll() internal override returns (uint256 amount) {
    uint256 cUSDCAmount = CUSDC.balanceOf(address(this));

    // If cUSDC.balanceOf(this) != 0, we can start to withdraw the eUSDC
    if (cUSDCAmount != 0) {
      // Revert if redeem function returns error code
      if (CUSDC.redeem(cUSDCAmount) != 0) revert InvalidState();
    }

    // Amount of USDC in the contract
    // This can be >0 even if cUSDC balance = 0
    // As it could have been transferred to this contract by accident
    amount = want.balanceOf(address(this));

    // Transfer USDC to core
    if (amount != 0) want.safeTransfer(core, amount);
  }

  /// @notice Withdraw `_amount` USDC from Compound and send to core
  /// @param _amount Amount of USDC to withdraw
  function _withdraw(uint256 _amount) internal override {
    // Revert if redeem function returns error code
    if (CUSDC.redeemUnderlying(_amount) != 0) revert InvalidState();

    // Transfer USDC to core
    want.safeTransfer(core, _amount);
  }

  /// @notice Claim COMP tokens earned by supplying
  /// @dev COMP tokens will be send to LIQUIDITY_MINING_RECEIVER
  function claimReward() external {
    // Claim COMP for address(this)
    address[] memory holders = new address[](1);
    holders[0] = address(this);

    // Claim COMP for CUSDC
    ICToken[] memory tokens = new ICToken[](1);
    tokens[0] = CUSDC;

    // Claim COMP tokens for CUSDC
    // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Comptroller.sol#L1341
    COMPTROLLER.claimComp(holders, tokens, false, true);

    // How much COMP tokens does this contract hold
    uint256 rewardBalance = COMP.balanceOf(address(this));

    // Send all COMP tokens to LIQUIDITY_MINING_RECEIVER
    if (rewardBalance != 0) COMP.safeTransfer(LIQUIDITY_MINING_RECEIVER, rewardBalance);
  }
}
