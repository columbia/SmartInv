1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.0;
3 
4 import {ControllerV1} from "@orcaprotocol/contracts/contracts/ControllerV1.sol";
5 import {MemberToken} from "@orcaprotocol/contracts/contracts/MemberToken.sol";
6 
7 interface IPodFactory {
8     /// @notice Configuration used when creating a pod
9     /// @param members List of members to be added to the pod
10     /// @param threshold Number of members that need to approve a transaction on the Gnosis safe
11     /// @param label Metadata, Human readable label for the pod
12     /// @param ensString Metadata, ENS name of the pod
13     /// @param imageUrl Metadata, URL to a image to represent the pod in frontends
14     /// @param minDelay Delay on the timelock
15     struct PodConfig {
16         address[] members;
17         uint256 threshold;
18         bytes32 label;
19         string ensString;
20         string imageUrl;
21         address admin;
22         uint256 minDelay;
23     }
24 
25     event CreatePod(uint256 indexed podId, address indexed safeAddress, address indexed timelock);
26     event CreateTimelock(address indexed timelock);
27     event UpdatePodController(address indexed oldController, address indexed newController);
28 
29     event UpdateDefaultPodController(address indexed oldController, address indexed newController);
30 
31     function deployCouncilPod(PodConfig calldata _config)
32         external
33         returns (
34             uint256,
35             address,
36             address
37         );
38 
39     function defaultPodController() external view returns (ControllerV1);
40 
41     function getMemberToken() external view returns (MemberToken);
42 
43     function getPodSafeAddresses() external view returns (address[] memory);
44 
45     function getNumberOfPods() external view returns (uint256);
46 
47     function getPodController(uint256 podId) external view returns (ControllerV1);
48 
49     function getPodSafe(uint256 podId) external view returns (address);
50 
51     function getPodTimelock(uint256 podId) external view returns (address);
52 
53     function getNumMembers(uint256 podId) external view returns (uint256);
54 
55     function getPodMembers(uint256 podId) external view returns (address[] memory);
56 
57     function getPodThreshold(uint256 podId) external view returns (uint256);
58 
59     function getIsMembershipTransferLocked(uint256 podId) external view returns (bool);
60 
61     function getNextPodId() external view returns (uint256);
62 
63     function getPodAdmin(uint256 podId) external view returns (address);
64 
65     function createOptimisticPod(PodConfig calldata _config)
66         external
67         returns (
68             uint256,
69             address,
70             address
71         );
72 
73     function updateDefaultPodController(address _newDefaultController) external;
74 }
