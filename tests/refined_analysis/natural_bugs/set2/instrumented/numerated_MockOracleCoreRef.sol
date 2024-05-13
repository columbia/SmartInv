1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "./MockOracle.sol";
5 import "./MockCoreRef.sol";
6 
7 contract MockOracleCoreRef is MockOracle, MockCoreRef {
8     constructor(address core, uint256 usdPerEth) MockCoreRef(core) MockOracle(usdPerEth) {}
9 }
