1 // SPDX-License-Identifier: GPL-2.0-or-later
2 pragma solidity 0.8.10;
3 
4 /******************************************************************************\
5 * Author: Evert Kors <dev@sherlock.xyz> (https://twitter.com/evert0x)
6 * Sherlock Protocol: https://sherlock.xyz
7 /******************************************************************************/
8 
9 import '../managers/SherlockClaimManager.sol';
10 
11 /// @notice this contract is used for testing to view all storage variables
12 contract SherlockClaimManagerTest is SherlockClaimManager {
13   constructor(address _umaho, address _spcc) SherlockClaimManager(_umaho, _spcc) {}
14 
15   function viewPublicToInternalID(uint256 id) external view returns (bytes32) {
16     return publicToInternalID[id];
17   }
18 
19   function viewInternalToPublicID(bytes32 id) external view returns (uint256) {
20     return internalToPublicID[id];
21   }
22 
23   function viewClaims(bytes32 id) external view returns (Claim memory) {
24     return claims_[id];
25   }
26 
27   function viewLastClaimID() external view returns (uint256) {
28     return lastClaimID;
29   }
30 
31   function isPayoutState(State _oldState, uint256 updated) external view returns (bool) {
32     return _isPayoutState(_oldState, updated);
33   }
34 
35   function isEscalateState(State _oldState, uint256 updated) external view returns (bool) {
36     return _isEscalateState(_oldState, updated);
37   }
38 
39   function isCleanupState(State _oldState) external view returns (bool) {
40     return _isCleanupState(_oldState);
41   }
42 
43   function _setClaimUpdate(uint256 _claimID, uint256 _updated) external {
44     claims_[publicToInternalID[_claimID]].updated = _updated;
45   }
46 }
