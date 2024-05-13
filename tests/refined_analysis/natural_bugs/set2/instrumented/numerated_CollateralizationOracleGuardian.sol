1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "./ICollateralizationOracleWrapper.sol";
5 import "../../refs/CoreRef.sol";
6 import "../../utils/Timed.sol";
7 import "../../Constants.sol";
8 import "@openzeppelin/contracts/utils/math/SafeCast.sol";
9 
10 /** 
11     @title Fei Protocol's Collateralization Oracle Guardian
12     @author Fei Protocol
13     This contract needs to be granted the ORACLE_ADMIN role
14     The guardian can leverage this contract to make small bounded changes to CR
15     This is intended to be used only in emergencies when the base CollateralizationOracle is compromised
16     The guardian should be able to approximate manual changes to CR via this contract without retaining too much power
17 */
18 contract CollateralizationOracleGuardian is CoreRef, Timed {
19     using SafeCast for uint256;
20 
21     event DeviationThresholdUpdate(uint256 oldDeviationThresholdBasisPoints, uint256 newDeviationThresholdBasisPoints);
22 
23     /// @notice the oracle wrapper to update
24     ICollateralizationOracleWrapper public immutable oracleWrapper;
25 
26     /// @notice the maximum update size relative to current, measured in basis points (1/10000)
27     uint256 public deviationThresholdBasisPoints;
28 
29     /**
30         @notice The constructor for CollateralizationOracleGuardian
31         @param _core the core address to reference
32         @param _oracleWrapper the instance of CollateralizationOracleWrapper
33         @param _frequency the maximum frequency a guardian can update the cache
34         @param _deviationThresholdBasisPoints the maximum percent change in a cache value for a given update
35      */
36     constructor(
37         address _core,
38         ICollateralizationOracleWrapper _oracleWrapper,
39         uint256 _frequency,
40         uint256 _deviationThresholdBasisPoints
41     ) CoreRef(_core) Timed(_frequency) {
42         oracleWrapper = _oracleWrapper;
43 
44         _setDeviationThresholdBasisPoints(_deviationThresholdBasisPoints);
45 
46         _initTimed();
47     }
48 
49     /// @notice guardian set the cache values on collateralization oracle
50     /// @param protocolControlledValue new PCV value
51     /// @param userCirculatingFei new user FEI value
52     /// @dev make sure to pause the CR oracle wrapper or else the set value would be overwritten on next update
53     function setCache(uint256 protocolControlledValue, uint256 userCirculatingFei)
54         external
55         onlyGuardianOrGovernor
56         afterTime
57     {
58         // Reset timer
59         _initTimed();
60 
61         // Check boundaries on new update values
62         uint256 cachedPCV = oracleWrapper.cachedProtocolControlledValue();
63         require(
64             calculateDeviationThresholdBasisPoints(protocolControlledValue, cachedPCV) <= deviationThresholdBasisPoints,
65             "CollateralizationOracleGuardian: Cached PCV exceeds deviation"
66         );
67 
68         uint256 cachedUserFei = oracleWrapper.cachedUserCirculatingFei();
69         require(
70             calculateDeviationThresholdBasisPoints(userCirculatingFei, cachedUserFei) <= deviationThresholdBasisPoints,
71             "CollateralizationOracleGuardian: Cached User FEI exceeds deviation"
72         );
73 
74         // Set the new cache values
75         int256 equity = protocolControlledValue.toInt256() - userCirculatingFei.toInt256();
76         oracleWrapper.setCache(protocolControlledValue, userCirculatingFei, equity);
77 
78         assert(oracleWrapper.cachedProtocolEquity() == equity);
79     }
80 
81     /// @notice return the percent deviation between a and b in basis points terms
82     function calculateDeviationThresholdBasisPoints(uint256 a, uint256 b) public pure returns (uint256) {
83         uint256 delta = (a < b) ? (b - a) : (a - b);
84         return (delta * Constants.BASIS_POINTS_GRANULARITY) / a;
85     }
86 
87     /// @notice governance setter for maximum deviation the guardian can change per update
88     function setDeviationThresholdBasisPoints(uint256 newDeviationThresholdBasisPoints) external onlyGovernor {
89         _setDeviationThresholdBasisPoints(newDeviationThresholdBasisPoints);
90     }
91 
92     function _setDeviationThresholdBasisPoints(uint256 newDeviationThresholdBasisPoints) internal {
93         require(
94             newDeviationThresholdBasisPoints <= Constants.BASIS_POINTS_GRANULARITY,
95             "CollateralizationOracleGuardian: deviation exceeds granularity"
96         );
97 
98         uint256 oldDeviationThresholdBasisPoints = deviationThresholdBasisPoints;
99         deviationThresholdBasisPoints = newDeviationThresholdBasisPoints;
100 
101         emit DeviationThresholdUpdate(oldDeviationThresholdBasisPoints, newDeviationThresholdBasisPoints);
102     }
103 }
