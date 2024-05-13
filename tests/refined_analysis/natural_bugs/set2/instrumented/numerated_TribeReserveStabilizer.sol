1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "./ReserveStabilizer.sol";
5 import "./ITribeReserveStabilizer.sol";
6 import "../../tribe/ITribeMinter.sol";
7 import "../../utils/Timed.sol";
8 import "@openzeppelin/contracts/utils/math/Math.sol";
9 
10 /// @title implementation for a TRIBE Reserve Stabilizer
11 /// @author Fei Protocol
12 contract TribeReserveStabilizer is ITribeReserveStabilizer, ReserveStabilizer, Timed {
13     using Decimal for Decimal.D256;
14 
15     /// @notice a collateralization oracle
16     ICollateralizationOracle public override collateralizationOracle;
17 
18     /// @notice the TRIBE minter address
19     ITribeMinter public immutable tribeMinter;
20 
21     Decimal.D256 private _collateralizationThreshold;
22 
23     /// @notice Tribe Reserve Stabilizer constructor
24     /// @param _core Fei Core to reference
25     /// @param _tribeOracle the TRIBE price oracle to reference
26     /// @param _backupOracle the backup oracle to reference
27     /// @param _usdPerFeiBasisPoints the USD price per FEI to sell TRIBE at
28     /// @param _collateralizationOracle the collateralization oracle to reference
29     /// @param _collateralizationThresholdBasisPoints the collateralization ratio below which the stabilizer becomes active. Reported in basis points (1/10000)
30     /// @param _tribeMinter the tribe minter contract
31     /// @param _osmDuration the amount of delay time before the TribeReserveStabilizer begins minting TRIBE
32     constructor(
33         address _core,
34         address _tribeOracle,
35         address _backupOracle,
36         uint256 _usdPerFeiBasisPoints,
37         ICollateralizationOracle _collateralizationOracle,
38         uint256 _collateralizationThresholdBasisPoints,
39         ITribeMinter _tribeMinter,
40         uint256 _osmDuration
41     )
42         ReserveStabilizer(_core, _tribeOracle, _backupOracle, IERC20(address(0)), _usdPerFeiBasisPoints)
43         Timed(_osmDuration)
44     {
45         collateralizationOracle = _collateralizationOracle;
46         emit CollateralizationOracleUpdate(address(0), address(_collateralizationOracle));
47 
48         _collateralizationThreshold = Decimal.ratio(
49             _collateralizationThresholdBasisPoints,
50             Constants.BASIS_POINTS_GRANULARITY
51         );
52         emit CollateralizationThresholdUpdate(0, _collateralizationThresholdBasisPoints);
53 
54         // Setting token here because it isn't available until after CoreRef is constructed
55         // This does skip the _setDecimalsNormalizerFromToken call in ReserveStabilizer constructor, but it isn't needed because TRIBE is 18 decimals
56         token = tribe();
57 
58         tribeMinter = _tribeMinter;
59     }
60 
61     /// @notice exchange FEI for minted TRIBE
62     /// @dev the timer counts down from first time below threshold and opens after window
63     function exchangeFei(uint256 feiAmount) public override afterTime returns (uint256) {
64         require(isCollateralizationBelowThreshold(), "TribeReserveStabilizer: Collateralization ratio above threshold");
65         return super.exchangeFei(feiAmount);
66     }
67 
68     /// @dev reverts. Held TRIBE should only be released by exchangeFei or mint
69     function withdraw(address, uint256) external pure override {
70         revert("TribeReserveStabilizer: can't withdraw TRIBE");
71     }
72 
73     /// @notice check whether collateralization ratio is below the threshold set
74     /// @dev returns false if the oracle is invalid
75     function isCollateralizationBelowThreshold() public view override returns (bool) {
76         (Decimal.D256 memory ratio, bool valid) = collateralizationOracle.read();
77 
78         return valid && ratio.lessThanOrEqualTo(_collateralizationThreshold);
79     }
80 
81     /// @notice delay the opening of the TribeReserveStabilizer until oracle delay duration is met
82     function startOracleDelayCountdown() external override {
83         require(isCollateralizationBelowThreshold(), "TribeReserveStabilizer: Collateralization ratio above threshold");
84         require(!isTimeStarted(), "TribeReserveStabilizer: timer started");
85         _initTimed();
86     }
87 
88     /// @notice reset the opening of the TribeReserveStabilizer oracle delay as soon as above CR target
89     function resetOracleDelayCountdown() external override {
90         require(
91             !isCollateralizationBelowThreshold(),
92             "TribeReserveStabilizer: Collateralization ratio under threshold"
93         );
94         require(isTimeStarted(), "TribeReserveStabilizer: timer started");
95         _pauseTimer();
96     }
97 
98     /// @notice set the Collateralization oracle
99     function setCollateralizationOracle(ICollateralizationOracle newCollateralizationOracle)
100         external
101         override
102         onlyGovernor
103     {
104         require(address(newCollateralizationOracle) != address(0), "TribeReserveStabilizer: zero address");
105         address oldCollateralizationOracle = address(collateralizationOracle);
106         collateralizationOracle = newCollateralizationOracle;
107         emit CollateralizationOracleUpdate(oldCollateralizationOracle, address(newCollateralizationOracle));
108     }
109 
110     /// @notice set the collateralization threshold below which exchanging becomes active
111     function setCollateralizationThreshold(uint256 newCollateralizationThresholdBasisPoints)
112         external
113         override
114         onlyGovernor
115     {
116         uint256 oldCollateralizationThresholdBasisPoints = _collateralizationThreshold
117             .mul(Constants.BASIS_POINTS_GRANULARITY)
118             .asUint256();
119         _collateralizationThreshold = Decimal.ratio(
120             newCollateralizationThresholdBasisPoints,
121             Constants.BASIS_POINTS_GRANULARITY
122         );
123         emit CollateralizationThresholdUpdate(
124             oldCollateralizationThresholdBasisPoints,
125             newCollateralizationThresholdBasisPoints
126         );
127     }
128 
129     /// @notice the collateralization threshold below which exchanging becomes active
130     function collateralizationThreshold() external view override returns (Decimal.D256 memory) {
131         return _collateralizationThreshold;
132     }
133 
134     // Call out to TRIBE minter for transferring
135     function _transfer(address to, uint256 amount) internal override {
136         tribeMinter.mint(to, amount);
137     }
138 
139     function _pauseTimer() internal {
140         // setting start time to 0 means isTimeStarted is false
141         startTime = 0;
142         emit TimerReset(0);
143     }
144 }
