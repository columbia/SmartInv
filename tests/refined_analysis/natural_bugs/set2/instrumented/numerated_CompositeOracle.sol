1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "../refs/CoreRef.sol";
5 import "./IOracle.sol";
6 
7 /// @title A composite oracle
8 /// @author Fei Protocol
9 /// @notice Reads two oracles and returns their product
10 contract CompositeOracle is IOracle, CoreRef {
11     using Decimal for Decimal.D256;
12 
13     /// @notice the first referenced oracle
14     IOracle public oracleA;
15     /// @notice the second referenced oracle
16     IOracle public oracleB;
17     /// @notice if true, result is A/B, otherwise A*B
18     bool public immutable invertOracleB;
19 
20     /// @notice CompositeOracle constructor
21     /// @param _oracleA first referenced oracle
22     /// @param _oracleB second referenced oracle
23     /// @param _invertOracleB invert second referenced oracle (returns A/B instead of A*B)
24     constructor(
25         address _core,
26         IOracle _oracleA,
27         IOracle _oracleB,
28         bool _invertOracleB
29     ) CoreRef(_core) {
30         oracleA = _oracleA;
31         oracleB = _oracleB;
32         invertOracleB = _invertOracleB;
33     }
34 
35     /// @notice updates the oracle price
36     function update() external override whenNotPaused {
37         oracleA.update();
38         oracleB.update();
39     }
40 
41     /// @notice determine if read value is stale
42     /// @return true if read value is stale
43     function isOutdated() external view override returns (bool) {
44         return oracleA.isOutdated() || oracleB.isOutdated();
45     }
46 
47     /// @notice read the oracle price
48     /// @return oracle price
49     /// @return true if price is valid
50     function read() external view override returns (Decimal.D256 memory, bool) {
51         (Decimal.D256 memory priceA, bool validA) = oracleA.read();
52         (Decimal.D256 memory priceB, bool validB) = oracleB.read();
53         bool valid = !paused() && validA && validB;
54 
55         if (invertOracleB) return (priceA.div(priceB), valid);
56         else return (priceA.mul(priceB), valid);
57     }
58 }
