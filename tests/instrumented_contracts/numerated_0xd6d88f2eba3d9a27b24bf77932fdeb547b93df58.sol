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
13 // File: contracts/AaveOracle.sol
14 
15 pragma solidity ^0.5.0;
16 
17 
18 contract AaveOracle is IAaveOracle {
19     struct TimestampedProphecy {
20         uint64 timestamp;
21         uint96 sybilProphecy;
22         uint96 oracleProphecy;
23     }
24 
25     event ProphecySubmitted(
26         address indexed _sybil,
27         address indexed _asset,
28         uint96 _sybilProphecy,
29         uint96 _oracleProphecy
30     );
31 
32     event SybilWhitelisted(address sybil);
33 
34     // Asset => price prophecy
35     mapping(address => TimestampedProphecy) public prophecies;
36 
37     // Whitelisted sybils allowed to submit prices
38     mapping(address => bool) private sybils;
39 
40     modifier onlySybil {
41         require(isSybilWhitelisted(msg.sender), "INVALID_SYBIL");
42         _;
43     }
44 
45     constructor(address[] memory _sybils) public {
46         internalWhitelistSybils(_sybils);
47     }
48 
49     /// @notice Internal function to whitelist a list of sybils
50     /// @param _sybils The addresses of the sybils
51     function internalWhitelistSybils(address[] memory _sybils) internal {
52         for (uint256 i = 0; i < _sybils.length; i++) {
53             sybils[_sybils[i]] = true;
54             emit SybilWhitelisted(_sybils[i]);
55         }
56     }
57 
58     /// @notice Submits a new prophecy for an asset
59     /// - Only callable by whitelisted sybils
60     /// @param _asset The asset address
61     /// @param _sybilProphecy The new individual prophecy of the sybil
62     /// @param _oracleProphecy The offchain calculated prophecy from all the currently valid ones
63     function submitProphecy(address _asset, uint96 _sybilProphecy, uint96 _oracleProphecy) external onlySybil {
64         prophecies[_asset] = TimestampedProphecy(uint64(block.timestamp), _sybilProphecy, _oracleProphecy);
65         emit ProphecySubmitted(msg.sender, _asset, _sybilProphecy, _oracleProphecy);
66     }
67 
68     /// @notice Gets the current prophecy for an asset
69     /// @param _asset The asset address
70     function getAssetPrice(address _asset) external view returns (uint256) {
71         return uint256(prophecies[_asset].oracleProphecy);
72     }
73 
74     /// @notice Gets the data of the current prophecy for an asset
75     /// @param _asset The asset address
76     function getProphecy(address _asset) external view returns (uint64, uint96, uint96) {
77         TimestampedProphecy memory _prophecy = prophecies[_asset];
78         return (_prophecy.timestamp, _prophecy.sybilProphecy, _prophecy.oracleProphecy);
79     }
80 
81     /// @notice Return a bool with the whitelisting state of a sybil
82     /// @param _sybil The address of the sybil
83     function isSybilWhitelisted(address _sybil) public view returns (bool) {
84         return sybils[_sybil];
85     }
86 
87 }