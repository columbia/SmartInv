// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity 0.8.10;

/******************************************************************************\
* Author: Evert Kors <dev@sherlock.xyz> (https://twitter.com/evert0x)
* Sherlock Protocol: https://sherlock.xyz
/******************************************************************************/

import '../managers/Manager.sol';
import '../interfaces/managers/IStrategyManager.sol';

contract StrategyMockGoerli is IStrategyManager, Manager {
  IERC20 public override want;

  constructor(IERC20 _token, address _mock) {}

  function withdrawAll() external override returns (uint256 b) {}

  function withdraw(uint256 _amount) external override {}

  function deposit() external override {}

  function balanceOf() public view override returns (uint256) {}
}
