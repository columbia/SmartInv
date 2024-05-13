1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "./IOracle.sol";
5 import "../refs/CoreRef.sol";
6 import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";
7 
8 /// @title Chainlink oracle wrapper
9 /// @author eswak
10 /// @notice Reads a Chainlink oracle value & wrap it under the standard Fei oracle interface
11 contract ChainlinkOracleWrapper is IOracle, CoreRef {
12     using Decimal for Decimal.D256;
13 
14     /// @notice the referenced chainlink oracle
15     AggregatorV3Interface public chainlinkOracle;
16     uint256 public oracleDecimalsNormalizer;
17 
18     /// @notice ChainlinkOracleWrapper constructor
19     /// @param _core Fei Core for reference
20     /// @param _chainlinkOracle reference to the target Chainlink oracle
21     constructor(address _core, address _chainlinkOracle) CoreRef(_core) {
22         chainlinkOracle = AggregatorV3Interface(_chainlinkOracle);
23 
24         _init();
25     }
26 
27     // @dev: decimals of the oracle are expected to never change, if Chainlink
28     // updates that behavior in the future, we might consider reading the
29     // oracle decimals() on every read() call.
30     function _init() internal {
31         uint8 oracleDecimals = chainlinkOracle.decimals();
32         oracleDecimalsNormalizer = 10**uint256(oracleDecimals);
33     }
34 
35     /// @notice updates the oracle price
36     /// @dev no-op, Chainlink is updated automatically
37     function update() external view override whenNotPaused {}
38 
39     /// @notice determine if read value is stale
40     /// @return true if read value is stale
41     function isOutdated() external view override returns (bool) {
42         (uint80 roundId, , , , uint80 answeredInRound) = chainlinkOracle.latestRoundData();
43         return answeredInRound != roundId;
44     }
45 
46     /// @notice read the oracle price
47     /// @return oracle price
48     /// @return true if price is valid
49     function read() external view override returns (Decimal.D256 memory, bool) {
50         (uint80 roundId, int256 price, , , uint80 answeredInRound) = chainlinkOracle.latestRoundData();
51         bool valid = !paused() && price > 0 && answeredInRound == roundId;
52 
53         Decimal.D256 memory value = Decimal.from(uint256(price)).div(oracleDecimalsNormalizer);
54         return (value, valid);
55     }
56 }
