// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity 0.8.10;

/******************************************************************************\
* Author: Evert Kors <dev@sherlock.xyz> (https://twitter.com/evert0x)
* Sherlock Protocol: https://sherlock.xyz
/******************************************************************************/

import '../managers/Manager.sol';

contract AllowanceErrorTest is Manager {
  using SafeERC20 for IERC20;

  constructor(IERC20 _token) {
    _token.safeIncreaseAllowance(address(0x1), 1);
    _token.safeIncreaseAllowance(address(0x1), type(uint256).max);
  }
}
