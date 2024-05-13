1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "./IOracle.sol";
5 import "../refs/CoreRef.sol";
6 import "../Constants.sol";
7 
8 /// @title Constant oracle
9 /// @author Fei Protocol
10 /// @notice Return a constant oracle price
11 contract ConstantOracle is IOracle, CoreRef {
12     using Decimal for Decimal.D256;
13 
14     Decimal.D256 private price;
15 
16     /// @notice Constant oracle constructor
17     /// @param _core Fei Core for reference
18     /// @param _priceBasisPoints the price to report in basis points
19     constructor(address _core, uint256 _priceBasisPoints) CoreRef(_core) {
20         price = Decimal.ratio(_priceBasisPoints, Constants.BASIS_POINTS_GRANULARITY);
21     }
22 
23     /// @notice updates the oracle price
24     /// @dev no-op, oracle is fixed
25     function update() external pure override {}
26 
27     /// @notice determine if read value is stale
28     /// @dev always false, oracle is fixed
29     function isOutdated() external pure override returns (bool) {
30         return false;
31     }
32 
33     /// @notice read the oracle price
34     /// @return constant oracle price
35     /// @return true if not paused
36     function read() external view override returns (Decimal.D256 memory, bool) {
37         return (price, !paused());
38     }
39 }
