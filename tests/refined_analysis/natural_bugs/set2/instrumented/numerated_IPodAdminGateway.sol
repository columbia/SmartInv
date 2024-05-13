1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.0;
3 
4 interface IPodAdminGateway {
5     event AddPodMember(uint256 indexed podId, address member);
6     event RemovePodMember(uint256 indexed podId, address member);
7     event UpdatePodAdmin(uint256 indexed podId, address oldPodAdmin, address newPodAdmin);
8     event PodMembershipTransferLock(uint256 indexed podId, bool lock);
9 
10     // Veto functionality
11     event VetoTimelock(uint256 indexed podId, address indexed timelock, bytes32 proposalId);
12 
13     function getSpecificPodAdminRole(uint256 _podId) external pure returns (bytes32);
14 
15     function getSpecificPodGuardianRole(uint256 _podId) external pure returns (bytes32);
16 
17     function addPodMember(uint256 _podId, address _member) external;
18 
19     function batchAddPodMember(uint256 _podId, address[] calldata _members) external;
20 
21     function removePodMember(uint256 _podId, address _member) external;
22 
23     function batchRemovePodMember(uint256 _podId, address[] calldata _members) external;
24 
25     function lockMembershipTransfers(uint256 _podId) external;
26 
27     function unlockMembershipTransfers(uint256 _podId) external;
28 
29     function veto(uint256 _podId, bytes32 proposalId) external;
30 }
