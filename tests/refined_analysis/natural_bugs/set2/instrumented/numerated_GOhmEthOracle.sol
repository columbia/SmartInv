1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";
5 import {Decimal, IOracle} from "./IOracle.sol";
6 import {CoreRef} from "../refs/CoreRef.sol";
7 
8 interface IgOHM {
9     function mint(address _to, uint256 _amount) external;
10 
11     function burn(address _from, uint256 _amount) external;
12 
13     function index() external view returns (uint256);
14 
15     function balanceFrom(uint256 _amount) external view returns (uint256);
16 
17     function balanceTo(uint256 _amount) external view returns (uint256);
18 
19     function migrate(address _staking, address _sOHM) external;
20 }
21 
22 /// @title GOHM Eth Oracle
23 /// @notice Report the gOHM price in units of ETH. Calculated by reading a Chainlink OHM V2
24 ///         oracle price and multiplying that by the queried OHM index
25 contract GOhmEthOracle is IOracle, CoreRef {
26     using Decimal for Decimal.D256;
27 
28     /// @notice the referenced chainlink oracle
29     AggregatorV3Interface public immutable chainlinkOHMETHOracle;
30 
31     /// @notice Oracle decimals normalizer
32     uint256 public oracleDecimalsNormalizer;
33 
34     /// @notice gOHM token address.
35     IgOHM public constant GOHM = IgOHM(0x0ab87046fBb341D058F17CBC4c1133F25a20a52f);
36 
37     /// @notice Maximum time since last update that the Chainlink oracle is considered valid
38     uint256 public constant MAX_ORACLE_UPDATE_TIME = 1 weeks;
39 
40     /// @param _core Fei Core for reference
41     /// @param _chainlinkOHMETHOracle Chainlink OHM V2 oracle reporting in terms of ETH
42     constructor(address _core, address _chainlinkOHMETHOracle) CoreRef(_core) {
43         chainlinkOHMETHOracle = AggregatorV3Interface(_chainlinkOHMETHOracle);
44         _init();
45     }
46 
47     // @dev: decimals of the oracle are expected to never change, if Chainlink
48     // updates that behavior in the future, we might consider reading the
49     // oracle decimals() on every read() call.
50     function _init() internal {
51         uint8 oracleDecimals = chainlinkOHMETHOracle.decimals();
52         oracleDecimalsNormalizer = 10**uint256(oracleDecimals);
53     }
54 
55     /// @notice Update the oracle price
56     /// No-op, Chainlink is updated automatically. Price is multiplied by OHM index at runtime
57     function update() external override whenNotPaused {}
58 
59     /// @notice determine if read value is stale
60     /// @return true if read value is stale
61     function isOutdated() external view override returns (bool) {
62         (uint80 roundId, , , , uint80 answeredInRound) = chainlinkOHMETHOracle.latestRoundData();
63         return answeredInRound != roundId;
64     }
65 
66     /// @notice Determine the gOHM price. Report in units of ETH.
67     /// @return oracle gOHM price in units of ETH
68     /// @return true if price is valid
69     function read() external view override returns (Decimal.D256 memory, bool) {
70         (uint80 roundId, int256 ohmEthPrice, , uint256 updatedAt, uint80 answeredInRound) = chainlinkOHMETHOracle
71             .latestRoundData();
72         // Valid if not paused, price is greater than 0, Chainlink price answered in this round
73         // and the Chainlink price updated happened at least within the last 24 hours.
74         bool valid = !paused() &&
75             ohmEthPrice > 0 &&
76             answeredInRound == roundId &&
77             updatedAt >= block.timestamp - MAX_ORACLE_UPDATE_TIME;
78 
79         // Fetch the OHM price and normalise for number of decimals
80         // OHMV2 chainlink reports in ETH terms
81         Decimal.D256 memory ohmEthValue = Decimal.from(uint256(ohmEthPrice)).div(oracleDecimalsNormalizer);
82 
83         // Multiple decimal by Index
84         Decimal.D256 memory gOHMIndex = Decimal.from(GOHM.index());
85 
86         Decimal.D256 memory gOhmEthValue = ohmEthValue.mul(gOHMIndex).div(1e9); // 1e9 = OHM base unit and therefore also gOHM/OHM index base unit
87         return (gOhmEthValue, valid);
88     }
89 }
