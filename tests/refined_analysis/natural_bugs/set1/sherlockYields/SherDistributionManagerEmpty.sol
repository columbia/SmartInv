// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity 0.8.10;

/******************************************************************************\
* Author: Evert Kors <dev@sherlock.xyz> (https://twitter.com/evert0x)
* Sherlock Protocol: https://sherlock.xyz
/******************************************************************************/

import '../interfaces/managers/ISherDistributionManager.sol';
import './Manager.sol';

/// @dev dummy contract that doesn't distribute SHER
contract SherDistributionManagerEmpty is ISherDistributionManager, Manager {
  constructor() {}

  function pullReward(
    uint256 _amount,
    uint256 _period,
    uint256 _id,
    address _receiver
  ) external override returns (uint256 _sher) {
    return 0;
  }

  function calcReward(
    uint256 _tvl,
    uint256 _amount,
    uint256 _period
  ) external view returns (uint256 _sher) {
    return 0;
  }

  /// @notice Function used to check if this is the current active distribution manager
  /// @return Boolean indicating it's active
  /// @dev Will be checked by calling the sherlock contract
  function isActive() public view override returns (bool) {
    return address(sherlockCore.sherDistributionManager()) == address(this);
  }
}
