1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import {LinearTokenTimelock} from "./LinearTokenTimelock.sol";
5 import {CoreRef} from "../refs/CoreRef.sol";
6 
7 /// @title LinearUnlockTimelock
8 /// @notice Linear token timelock with an onlyGovernor unlockLiquidity() method
9 contract LinearUnlockTimelock is LinearTokenTimelock, CoreRef {
10     constructor(
11         address _core,
12         address _beneficiary,
13         uint256 _duration,
14         address _lockedToken,
15         uint256 _cliffDuration,
16         address _clawbackAdmin,
17         uint256 _startTime
18     )
19         LinearTokenTimelock(_beneficiary, _duration, _lockedToken, _cliffDuration, _clawbackAdmin, _startTime)
20         CoreRef(_core)
21     {}
22 
23     /// @notice Unlock the liquidity held by the timelock
24     /// @dev Restricted to onlyGovernor
25     function unlockLiquidity() external onlyGovernor {
26         _release(beneficiary, totalToken());
27     }
28 }
