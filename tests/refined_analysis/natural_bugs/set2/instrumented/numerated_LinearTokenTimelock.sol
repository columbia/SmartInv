1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "./TokenTimelock.sol";
5 
6 contract LinearTokenTimelock is TokenTimelock {
7     constructor(
8         address _beneficiary,
9         uint256 _duration,
10         address _lockedToken,
11         uint256 _cliffDuration,
12         address _clawbackAdmin,
13         uint256 _startTime
14     ) TokenTimelock(_beneficiary, _duration, _cliffDuration, _lockedToken, _clawbackAdmin) {
15         if (_startTime != 0) {
16             startTime = _startTime;
17         }
18     }
19 
20     function _proportionAvailable(
21         uint256 initialBalance,
22         uint256 elapsed,
23         uint256 duration
24     ) internal pure override returns (uint256) {
25         return (initialBalance * elapsed) / duration;
26     }
27 }
