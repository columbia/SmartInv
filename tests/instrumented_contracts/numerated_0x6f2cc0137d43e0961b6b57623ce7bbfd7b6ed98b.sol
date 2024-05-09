1 // File: contracts/interfaces/IAaveOracle.sol
2 
3 pragma solidity ^0.5.0;
4 
5 interface IAaveOracle {
6     // TODO rename back to getOracleProphecy
7     function getAssetPrice(address _asset) external view returns (uint256);
8     function prophecies(address _asset) external view returns (uint64, uint96, uint96);
9     function submitProphecy(address _asset, uint96 _sybilProphecy, uint96 _oracleProphecy) external;
10     function isSybilWhitelisted(address _sybil) external view returns (bool);
11 }
12 
13 // File: contracts/interfaces/IChainlinkAggregator.sol
14 
15 pragma solidity ^0.5.0;
16 
17 interface IChainlinkAggregator {
18   function latestAnswer() external view returns (int256);
19 }
20 
21 // File: contracts/AaveOracle.sol
22 
23 pragma solidity ^0.5.0;
24 
25 
26 
27 contract AaveOracle is IAaveOracle {
28     struct TimestampedProphecy {
29         uint64 timestamp;
30         uint96 sybilProphecy;
31         uint96 oracleProphecy;
32     }
33 
34     event ProphecySubmitted(
35         address indexed _sybil,
36         address indexed _asset,
37         uint96 _sybilProphecy,
38         uint96 _oracleProphecy
39     );
40 
41     event SybilWhitelisted(address sybil);
42 
43     address constant public USD_ETH_CHAINLINK_AGGREGATOR = address(0x59b826c214aBa7125bFA52970d97736c105Cc375);
44 
45     address constant public MOCK_USD = address(0x10F7Fc1F91Ba351f9C629c5947AD69bD03C05b96);
46 
47     // Asset => price prophecy
48     mapping(address => TimestampedProphecy) public prophecies;
49 
50     // Whitelisted sybils allowed to submit prices
51     mapping(address => bool) private sybils;
52 
53     modifier onlySybil {
54         require(isSybilWhitelisted(msg.sender), "INVALID_SYBIL");
55         _;
56     }
57 
58     constructor(address[] memory _sybils) public {
59         internalWhitelistSybils(_sybils);
60     }
61 
62     /// @notice Internal function to whitelist a list of sybils
63     /// @param _sybils The addresses of the sybils
64     function internalWhitelistSybils(address[] memory _sybils) internal {
65         for (uint256 i = 0; i < _sybils.length; i++) {
66             sybils[_sybils[i]] = true;
67             emit SybilWhitelisted(_sybils[i]);
68         }
69     }
70 
71     /// @notice Submits a new prophecy for an asset
72     /// - Only callable by whitelisted sybils
73     /// @param _asset The asset address
74     /// @param _sybilProphecy The new individual prophecy of the sybil
75     /// @param _oracleProphecy The offchain calculated prophecy from all the currently valid ones
76     function submitProphecy(address _asset, uint96 _sybilProphecy, uint96 _oracleProphecy) external onlySybil {
77         prophecies[_asset] = TimestampedProphecy(uint64(block.timestamp), _sybilProphecy, _oracleProphecy);
78         emit ProphecySubmitted(msg.sender, _asset, _sybilProphecy, _oracleProphecy);
79     }
80 
81     /// @notice Gets the current prophecy for an asset
82     /// @param _asset The asset address
83     function getAssetPrice(address _asset) external view returns (uint256) {
84         if (_asset == address(MOCK_USD)) {
85             return getUsdPriceFromChainlink();
86         } else {
87             return uint256(prophecies[_asset].oracleProphecy);
88         }
89     }
90 
91     /// @notice Gets the data of the current prophecy for an asset
92     /// @param _asset The asset address
93     function getProphecy(address _asset) external view returns (uint64, uint96, uint96) {
94         // For USD/ETH, use the Chainlink aggregator. The latestAnswer() gives price of ETH in USD,
95         // as we need price of USD in ETH, needs to be reversed, using 1e18. The mult by 1e8 is needed because
96         // the price of ETH in USD is multiplied by 1e8 on Chainlink side
97         if (_asset == address(MOCK_USD)) {
98             uint256 _price = getUsdPriceFromChainlink();
99             return (uint64(block.timestamp), uint96(_price), uint96(_price));
100         } else {
101             TimestampedProphecy memory _prophecy = prophecies[_asset];
102             return (_prophecy.timestamp, _prophecy.sybilProphecy, _prophecy.oracleProphecy);
103         }
104     }
105 
106     /// @notice Return a bool with the whitelisting state of a sybil
107     /// @param _sybil The address of the sybil
108     function isSybilWhitelisted(address _sybil) public view returns (bool) {
109         return sybils[_sybil];
110     }
111 
112     function getUsdPriceFromChainlink() internal view returns (uint256) {
113         return uint256(1e8 * 1e18 / IChainlinkAggregator(USD_ETH_CHAINLINK_AGGREGATOR).latestAnswer());
114     }
115 
116 }