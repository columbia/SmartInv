1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "./MockCoreRef.sol";
5 import "../metagov/utils/VoteEscrowTokenManager.sol";
6 import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
7 
8 contract MockVoteEscrowTokenManager is VoteEscrowTokenManager, MockCoreRef {
9     constructor(
10         address core,
11         address liquidToken,
12         address veToken,
13         uint256 maxTime
14     ) MockCoreRef(core) VoteEscrowTokenManager(IERC20(liquidToken), IVeToken(veToken), maxTime) {}
15 }
