1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.0;
3 
4 import {TimelockController} from "@openzeppelin/contracts/governance/TimelockController.sol";
5 import {ControllerV1} from "@orcaprotocol/contracts/contracts/ControllerV1.sol";
6 import {MemberToken} from "@orcaprotocol/contracts/contracts/MemberToken.sol";
7 import {IGnosisSafe} from "./interfaces//IGnosisSafe.sol";
8 import {IPodFactory} from "./interfaces/IPodFactory.sol";
9 
10 import {TribeRoles} from "../core/TribeRoles.sol";
11 import {CoreRef} from "../refs/CoreRef.sol";
12 import {ICore} from "../core/ICore.sol";
13 import {PodAdminGateway} from "./PodAdminGateway.sol";
14 import {PodExecutor} from "./PodExecutor.sol";
15 
16 /// @title PodFactory for TRIBE Governance pods
17 /// @notice A factory to create optimistic pods used in the Tribe Governance system
18 /// @dev This contract is primarily a factory contract which can be used to deploy
19 /// more optimistic governance pods. It will create an Orca pod and if specified,
20 /// deploy a timelock alongside it. The timelock and Orca pod are linked.
21 contract PodFactory is CoreRef, IPodFactory {
22     /// @notice Orca membership token for the pods. Handles permissioning pod members
23     MemberToken public immutable memberToken;
24 
25     /// @notice Public contract that has EXECUTOR_ROLE on all pod timelocks, to allow permissionless execution
26     PodExecutor public immutable podExecutor;
27 
28     /// @notice Default podController used to create pods
29     ControllerV1 public override defaultPodController;
30 
31     /// @notice Mapping between podId and it's timelock
32     mapping(uint256 => address) public override getPodTimelock;
33 
34     /// @notice Mapping between timelock and podId
35     mapping(address => uint256) public getPodId;
36 
37     /// @notice Created pod safe addresses
38     address[] private podSafeAddresses;
39 
40     /// @notice Track whether the one time use Council pod was used
41     bool public tribalCouncilDeployed;
42 
43     /// @notice Minimum delay of a pod timelock, if one is to be created with one
44     uint256 public constant MIN_TIMELOCK_DELAY = 1 days;
45 
46     /// @param _core Fei core address
47     /// @param _memberToken Membership token that manages the Orca pod membership
48     /// @param _defaultPodController Default pod controller that will be used to create pods initially
49     /// @param _podExecutor Public contract that will be granted the role to execute transactions on all timelocks
50     constructor(
51         address _core,
52         address _memberToken,
53         address _defaultPodController,
54         address _podExecutor
55     ) CoreRef(_core) {
56         podExecutor = PodExecutor(_podExecutor);
57         defaultPodController = ControllerV1(_defaultPodController);
58         memberToken = MemberToken(_memberToken);
59     }
60 
61     ///////////////////// GETTERS ///////////////////////
62 
63     /// @notice Get the number of pods this factory has created
64     function getNumberOfPods() external view override returns (uint256) {
65         return podSafeAddresses.length;
66     }
67 
68     /// @notice Get the safe addresses of all pods created by this factory
69     function getPodSafeAddresses() external view override returns (address[] memory) {
70         return podSafeAddresses;
71     }
72 
73     /// @notice Get the member token
74     function getMemberToken() external view override returns (MemberToken) {
75         return memberToken;
76     }
77 
78     /// @notice Get the pod controller for a podId
79     function getPodController(uint256 podId) external view override returns (ControllerV1) {
80         return ControllerV1(memberToken.memberController(podId));
81     }
82 
83     /// @notice Get the address of the Gnosis safe that represents a pod
84     /// @param podId Unique id for the orca pod
85     function getPodSafe(uint256 podId) public view override returns (address) {
86         ControllerV1 podController = ControllerV1(memberToken.memberController(podId));
87         return podController.podIdToSafe(podId);
88     }
89 
90     /// @notice Get the number of pod members
91     /// @param podId Unique id for the orca pod
92     function getNumMembers(uint256 podId) external view override returns (uint256) {
93         address safe = getPodSafe(podId);
94         address[] memory members = IGnosisSafe(safe).getOwners();
95         return uint256(members.length);
96     }
97 
98     /// @notice Get all members on the pod
99     /// @param podId Unique id for the orca pod
100     function getPodMembers(uint256 podId) public view override returns (address[] memory) {
101         ControllerV1 podController = ControllerV1(memberToken.memberController(podId));
102         address safeAddress = podController.podIdToSafe(podId);
103         return IGnosisSafe(safeAddress).getOwners();
104     }
105 
106     /// @notice Get the signer threshold on the pod
107     /// @param podId Unique id for the orca pod
108     function getPodThreshold(uint256 podId) external view override returns (uint256) {
109         address safe = getPodSafe(podId);
110         uint256 threshold = uint256(IGnosisSafe(safe).getThreshold());
111         return threshold;
112     }
113 
114     /// @notice Get the next pod id
115     function getNextPodId() external view override returns (uint256) {
116         return memberToken.getNextAvailablePodId();
117     }
118 
119     /// @notice Get the podAdmin from the pod controller
120     /// @param podId Unique id for the orca pod
121     function getPodAdmin(uint256 podId) external view override returns (address) {
122         ControllerV1 podController = ControllerV1(memberToken.memberController(podId));
123         return podController.podAdmin(podId);
124     }
125 
126     /// @notice Get whether membership transfers are enabled for a pod
127     function getIsMembershipTransferLocked(uint256 podId) external view override returns (bool) {
128         ControllerV1 podController = ControllerV1(memberToken.memberController(podId));
129         return podController.isTransferLocked(podId);
130     }
131 
132     //////////////////// STATE-CHANGING API ////////////////////
133 
134     /// @notice Deploy the genesis pod, one time use method. It will not lock membership transfers, has to be done
135     ///         in a seperate call to the PodAdminGateway
136     function deployCouncilPod(PodConfig calldata _config)
137         external
138         override
139         returns (
140             uint256,
141             address,
142             address
143         )
144     {
145         require(!tribalCouncilDeployed, "Genesis pod already deployed");
146         tribalCouncilDeployed = true;
147         return _createOptimisticPod(_config);
148     }
149 
150     /// @notice Create an Orca pod with timelock. Callable by the DAO and the Tribal Council
151     ///         Returns podId, pod timelock address and the Pod Gnosis Safe address
152     ///         This will lock membership transfers by default
153     function createOptimisticPod(PodConfig calldata _config)
154         public
155         override
156         hasAnyOfTwoRoles(TribeRoles.GOVERNOR, TribeRoles.POD_ADMIN)
157         returns (
158             uint256,
159             address,
160             address
161         )
162     {
163         (uint256 podId, address timelock, address safe) = _createOptimisticPod(_config);
164 
165         // Disable membership transfers by default
166         PodAdminGateway(_config.admin).lockMembershipTransfers(podId);
167         return (podId, timelock, safe);
168     }
169 
170     /// @notice Update the default pod controller
171     function updateDefaultPodController(address _newDefaultController)
172         external
173         override
174         hasAnyOfTwoRoles(TribeRoles.GOVERNOR, TribeRoles.POD_ADMIN)
175     {
176         emit UpdateDefaultPodController(address(defaultPodController), _newDefaultController);
177         defaultPodController = ControllerV1(_newDefaultController);
178     }
179 
180     ////////////////////////     INTERNAL          ////////////////////////////
181 
182     /// @notice Internal method to create a child optimistic pod
183     /// @param _config Pod configuraton
184     function _createOptimisticPod(PodConfig calldata _config)
185         internal
186         returns (
187             uint256,
188             address,
189             address
190         )
191     {
192         uint256 podId = memberToken.getNextAvailablePodId();
193 
194         address safeAddress = _createPod(
195             _config.members,
196             _config.threshold,
197             _config.label,
198             _config.ensString,
199             _config.imageUrl,
200             _config.admin,
201             podId
202         );
203 
204         // Timelock will by default be address(0) if no `minDelay` is provided
205         address timelock;
206         if (_config.minDelay != 0) {
207             require(_config.minDelay >= MIN_TIMELOCK_DELAY, "Min delay too small");
208             timelock = address(_createTimelock(safeAddress, _config.minDelay, address(podExecutor), _config.admin));
209             // Set mapping from podId to timelock for reference
210             getPodTimelock[podId] = timelock;
211             getPodId[timelock] = podId;
212         }
213 
214         podSafeAddresses.push(safeAddress);
215         emit CreatePod(podId, safeAddress, timelock);
216         return (podId, timelock, safeAddress);
217     }
218 
219     /// @notice Create an Orca pod - a Gnosis Safe with a membership wrapper
220     function _createPod(
221         address[] calldata _members,
222         uint256 _threshold,
223         bytes32 _label,
224         string calldata _ensString,
225         string calldata _imageUrl,
226         address _admin,
227         uint256 podId
228     ) internal returns (address) {
229         defaultPodController.createPod(_members, _threshold, _admin, _label, _ensString, podId, _imageUrl);
230         return defaultPodController.podIdToSafe(podId);
231     }
232 
233     /// @notice Create a timelock, linking to an Orca pod
234     /// @param safeAddress Address of the Gnosis Safe
235     /// @param minDelay Delay on the timelock
236     /// @param publicExecutor Non-permissioned smart contract that
237     ///        allows any address to execute a ready transaction
238     /// @param podAdmin Address which is the admin of the Orca pods
239     /// @dev Roles that individual addresses are granted on the relevant timelock:
240     //         safeAddress - PROPOSER_ROLE, CANCELLER_ROLE, EXECUTOR_ROLE
241     //         podAdmin - CANCELLER_ROLE
242     //         publicExecutor - EXECUTOR_ROLE
243     function _createTimelock(
244         address safeAddress,
245         uint256 minDelay,
246         address publicExecutor,
247         address podAdmin
248     ) internal returns (address) {
249         address[] memory proposers = new address[](2);
250         proposers[0] = safeAddress;
251         proposers[1] = podAdmin;
252 
253         address[] memory executors = new address[](2);
254         executors[0] = safeAddress;
255         executors[1] = publicExecutor;
256 
257         TimelockController timelock = new TimelockController(minDelay, proposers, executors);
258 
259         // Revoke PROPOSER_ROLE priviledges from podAdmin. Only pod Safe can propose
260         timelock.revokeRole(timelock.PROPOSER_ROLE(), podAdmin);
261 
262         // Revoke TIMELOCK_ADMIN_ROLE priviledges from deployer factory
263         timelock.revokeRole(timelock.TIMELOCK_ADMIN_ROLE(), address(this));
264 
265         emit CreateTimelock(address(timelock));
266         return address(timelock);
267     }
268 }
