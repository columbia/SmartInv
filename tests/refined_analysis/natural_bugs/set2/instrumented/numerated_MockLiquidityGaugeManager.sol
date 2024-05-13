1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "./MockCoreRef.sol";
5 import "../metagov/utils/LiquidityGaugeManager.sol";
6 
7 contract MockLiquidityGaugeManager is LiquidityGaugeManager, MockCoreRef {
8     constructor(address core, address gaugeController) MockCoreRef(core) LiquidityGaugeManager(gaugeController) {}
9 }
