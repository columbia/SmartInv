1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "./MockCoreRef.sol";
5 import "../metagov/utils/GovernorVoter.sol";
6 
7 contract MockGovernorVoter is GovernorVoter, MockCoreRef {
8     constructor(address core) MockCoreRef(core) GovernorVoter() {}
9 }
