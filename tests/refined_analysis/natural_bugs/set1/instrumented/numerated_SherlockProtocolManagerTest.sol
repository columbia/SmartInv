1 // SPDX-License-Identifier: GPL-2.0-or-later
2 pragma solidity 0.8.10;
3 
4 /******************************************************************************\
5 * Author: Evert Kors <dev@sherlock.xyz> (https://twitter.com/evert0x)
6 * Sherlock Protocol: https://sherlock.xyz
7 /******************************************************************************/
8 
9 import '../managers/SherlockProtocolManager.sol';
10 
11 /// @notice this contract is used for testing to view all storage variables
12 contract SherlockProtocolManagerTest is SherlockProtocolManager {
13   constructor(IERC20 _token) SherlockProtocolManager(_token) {}
14 
15   function privateSettleTotalDebt() external {
16     _settleTotalDebt();
17   }
18 
19   function privatesetMinActiveBalance(uint256 _min) external {
20     minActiveBalance = _min;
21   }
22 
23   function viewMinActiveBalance() external view returns (uint256) {
24     return minActiveBalance;
25   }
26 
27   function viewProtocolAgent(bytes32 _protocol) external view returns (address) {
28     return protocolAgent_[_protocol];
29   }
30 
31   function viewRemovedProtocolAgent(bytes32 _protocol) external view returns (address) {
32     return removedProtocolAgent[_protocol];
33   }
34 
35   function viewRemovedProtocolClaimDeadline(bytes32 _protocol) external view returns (uint256) {
36     return removedProtocolClaimDeadline[_protocol];
37   }
38 
39   function viewNonStakersPercentage(bytes32 _protocol) external view returns (uint256) {
40     return nonStakersPercentage[_protocol];
41   }
42 
43   function viewPremium(bytes32 _protocol) external view returns (uint256) {
44     return premiums_[_protocol];
45   }
46 
47   function viewCurrentCoverage(bytes32 _protocol) external view returns (uint256) {
48     return currentCoverage[_protocol];
49   }
50 
51   function viewPreviousCoverage(bytes32 _protocol) external view returns (uint256) {
52     return previousCoverage[_protocol];
53   }
54 
55   function viewLastAccountedEachProtocol(bytes32 _protocol) external view returns (uint256) {
56     return lastAccountedEachProtocol[_protocol];
57   }
58 
59   function viewNonStakersClaimableByProtocol(bytes32 _protocol) external view returns (uint256) {
60     return nonStakersClaimableByProtocol[_protocol];
61   }
62 
63   function viewLastAccountedGlobal() external view returns (uint256) {
64     return lastAccountedGlobal;
65   }
66 
67   function viewAllPremiumsPerSecToStakers() external view returns (uint256) {
68     return allPremiumsPerSecToStakers;
69   }
70 
71   function viewLastClaimablePremiumsForStakers() external view returns (uint256) {
72     return lastClaimablePremiumsForStakers;
73   }
74 
75   function viewActiveBalance(bytes32 _protocol) external view returns (uint256) {
76     return activeBalances[_protocol];
77   }
78 
79   function viewCalcForceRemoveBySecondsOfCoverage(bytes32 _protocol)
80     external
81     view
82     returns (uint256, bool)
83   {
84     return _calcForceRemoveBySecondsOfCoverage(_protocol);
85   }
86 }
