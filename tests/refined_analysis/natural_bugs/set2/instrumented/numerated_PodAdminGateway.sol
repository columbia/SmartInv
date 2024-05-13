1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.0;
3 
4 import {MemberToken} from "@orcaprotocol/contracts/contracts/MemberToken.sol";
5 import {ControllerV1} from "@orcaprotocol/contracts/contracts/ControllerV1.sol";
6 import {TimelockController} from "@openzeppelin/contracts/governance/TimelockController.sol";
7 import {CoreRef} from "../refs/CoreRef.sol";
8 import {ICore} from "../core/ICore.sol";
9 import {Core} from "../core/Core.sol";
10 import {TribeRoles} from "../core/TribeRoles.sol";
11 import {IPodAdminGateway} from "./interfaces/IPodAdminGateway.sol";
12 import {IPodFactory} from "./interfaces/IPodFactory.sol";
13 
14 /// @title PodAdminGateway for TRIBE Governance pods
15 /// @notice Acts as a gateway for admin functionality and vetos in the TRIBE governance pod system
16 /// @dev Contract is intended to be set as the podAdmin for all deployed Orca pods. Specifically enables:
17 ///     1. Adding a member to a pod
18 ///     2. Removing a member from a pod
19 ///     3. Transferring a pod member
20 ///     4. Toggling a pod membership transfer switch
21 ///     5. Vetoing a pod proposal
22 contract PodAdminGateway is CoreRef, IPodAdminGateway {
23     /// @notice Orca membership token for the pods. Handles permissioning pod members
24     MemberToken private immutable memberToken;
25 
26     /// @notice Pod factory which creates optimistic pods and acts as a source of information
27     IPodFactory public immutable podFactory;
28 
29     constructor(
30         address _core,
31         address _memberToken,
32         address _podFactory
33     ) CoreRef(_core) {
34         memberToken = MemberToken(_memberToken);
35         podFactory = IPodFactory(_podFactory);
36     }
37 
38     ////////////////////////   GETTERS   ////////////////////////////////
39     /// @notice Calculate the specific pod admin role identifier
40     /// @dev This role is able to add pod members, remove pod members, lock and unlock transfers and veto
41     ///      proposals
42     function getSpecificPodAdminRole(uint256 _podId) public pure override returns (bytes32) {
43         return keccak256(abi.encode(_podId, "_ORCA_POD", "_ADMIN"));
44     }
45 
46     /// @notice Calculate the specific pod guardian role identifier
47     /// @dev This role is able to remove pod members and veto pod proposals
48     function getSpecificPodGuardianRole(uint256 _podId) public pure override returns (bytes32) {
49         return keccak256(abi.encode(_podId, "_ORCA_POD", "_GUARDIAN"));
50     }
51 
52     /////////////////////////    ADMIN PRIVILEDGES       ////////////////////////////
53 
54     /// @notice Admin functionality to add a member to a pod
55     /// @dev Permissioned to GOVERNOR, POD_ADMIN and POD_ADD_MEMBER_ROLE
56     function addPodMember(uint256 _podId, address _member)
57         external
58         override
59         hasAnyOfThreeRoles(TribeRoles.GOVERNOR, TribeRoles.POD_ADMIN, getSpecificPodAdminRole(_podId))
60     {
61         _addMemberToPod(_podId, _member);
62     }
63 
64     /// @notice Internal method to add a member to a pod
65     function _addMemberToPod(uint256 _podId, address _member) internal {
66         emit AddPodMember(_podId, _member);
67         memberToken.mint(_member, _podId, bytes(""));
68     }
69 
70     /// @notice Admin functionality to batch add a member to a pod
71     /// @dev Permissioned to GOVERNOR, POD_ADMIN and POD_ADMIN_REMOVE_MEMBER
72     function batchAddPodMember(uint256 _podId, address[] calldata _members)
73         external
74         override
75         hasAnyOfThreeRoles(TribeRoles.GOVERNOR, TribeRoles.POD_ADMIN, getSpecificPodAdminRole(_podId))
76     {
77         uint256 numMembers = _members.length;
78         for (uint256 i = 0; i < numMembers; ) {
79             _addMemberToPod(_podId, _members[i]);
80             // i is constrained by being < _members.length
81             unchecked {
82                 i += 1;
83             }
84         }
85     }
86 
87     /// @notice Admin functionality to remove a member from a pod.
88     /// @dev Permissioned to GOVERNOR, POD_ADMIN, GUARDIAN and POD_ADMIN_REMOVE_MEMBER
89     function removePodMember(uint256 _podId, address _member)
90         external
91         override
92         hasAnyOfFiveRoles(
93             TribeRoles.GOVERNOR,
94             TribeRoles.POD_ADMIN,
95             TribeRoles.GUARDIAN,
96             getSpecificPodGuardianRole(_podId),
97             getSpecificPodAdminRole(_podId)
98         )
99     {
100         _removePodMember(_podId, _member);
101     }
102 
103     /// @notice Internal method to remove a member from a pod
104     function _removePodMember(uint256 _podId, address _member) internal {
105         emit RemovePodMember(_podId, _member);
106         memberToken.burn(_member, _podId);
107     }
108 
109     /// @notice Admin functionality to batch remove a member from a pod
110     /// @dev Permissioned to GOVERNOR, POD_ADMIN, GUARDIAN and POD_ADMIN_REMOVE_MEMBER
111     function batchRemovePodMember(uint256 _podId, address[] calldata _members)
112         external
113         override
114         hasAnyOfFiveRoles(
115             TribeRoles.GOVERNOR,
116             TribeRoles.POD_ADMIN,
117             TribeRoles.GUARDIAN,
118             getSpecificPodGuardianRole(_podId),
119             getSpecificPodAdminRole(_podId)
120         )
121     {
122         uint256 numMembers = _members.length;
123         for (uint256 i = 0; i < numMembers; ) {
124             _removePodMember(_podId, _members[i]);
125 
126             // i is constrained by being < _members.length
127             unchecked {
128                 i += 1;
129             }
130         }
131     }
132 
133     /// @notice Admin functionality to turn off pod membership transfer
134     /// @dev Permissioned to GOVERNOR, POD_ADMIN and the specific pod admin role
135     function lockMembershipTransfers(uint256 _podId)
136         external
137         override
138         hasAnyOfThreeRoles(TribeRoles.GOVERNOR, TribeRoles.POD_ADMIN, getSpecificPodAdminRole(_podId))
139     {
140         _setMembershipTransferLock(_podId, true);
141     }
142 
143     /// @notice Admin functionality to turn on pod membership transfers
144     /// @dev Permissioned to GOVERNOR, POD_ADMIN and the specific pod admin role
145     function unlockMembershipTransfers(uint256 _podId)
146         external
147         override
148         hasAnyOfThreeRoles(TribeRoles.GOVERNOR, TribeRoles.POD_ADMIN, getSpecificPodAdminRole(_podId))
149     {
150         _setMembershipTransferLock(_podId, false);
151     }
152 
153     /// @notice Internal method to toggle a pod membership transfer lock
154     function _setMembershipTransferLock(uint256 _podId, bool _lock) internal {
155         ControllerV1 podController = ControllerV1(memberToken.memberController(_podId));
156         podController.setPodTransferLock(_podId, _lock);
157         emit PodMembershipTransferLock(_podId, _lock);
158     }
159 
160     /// @notice Transfer the admin of a pod to a new address
161     /// @dev Permissioned to GOVERNOR, POD_ADMIN and the specific pod admin role
162     function transferAdmin(uint256 _podId, address _newAdmin)
163         external
164         hasAnyOfThreeRoles(TribeRoles.GOVERNOR, TribeRoles.POD_ADMIN, getSpecificPodAdminRole(_podId))
165     {
166         ControllerV1 podController = ControllerV1(memberToken.memberController(_podId));
167         address oldPodAdmin = podController.podAdmin(_podId);
168 
169         podController.updatePodAdmin(_podId, _newAdmin);
170         emit UpdatePodAdmin(_podId, oldPodAdmin, _newAdmin);
171     }
172 
173     ///////////////  VETO CONTROLLER /////////////////
174 
175     /// @notice Allow a proposal to be vetoed in a pod timelock
176     /// @dev Permissioned to GOVERNOR, POD_VETO_ADMIN, GUARDIAN, POD_ADMIN and the specific
177     ///      pod admin and guardian roles
178     function veto(uint256 _podId, bytes32 _proposalId)
179         external
180         override
181         hasAnyOfSixRoles(
182             TribeRoles.GOVERNOR,
183             TribeRoles.POD_VETO_ADMIN,
184             TribeRoles.GUARDIAN,
185             TribeRoles.POD_ADMIN,
186             getSpecificPodGuardianRole(_podId),
187             getSpecificPodAdminRole(_podId)
188         )
189     {
190         address _podTimelock = podFactory.getPodTimelock(_podId);
191         emit VetoTimelock(_podId, _podTimelock, _proposalId);
192         TimelockController(payable(_podTimelock)).cancel(_proposalId);
193     }
194 }
