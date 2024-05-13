1 // SPDX-License-Identifier: MIT OR Apache-2.0
2 pragma solidity 0.7.6;
3 
4 // ============ Internal Imports ============
5 import {Home} from "./Home.sol";
6 import {Replica} from "./Replica.sol";
7 import {TypeCasts} from "./libs/TypeCasts.sol";
8 // ============ External Imports ============
9 import {ECDSA} from "@openzeppelin/contracts/cryptography/ECDSA.sol";
10 import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
11 
12 /**
13  * @title XAppConnectionManager
14  * @author Illusory Systems Inc.
15  * @notice Manages a registry of local Replica contracts
16  * for remote Home domains. Accepts Watcher signatures
17  * to un-enroll Replicas attached to fraudulent remote Homes
18  */
19 contract XAppConnectionManager is Ownable {
20     // ============ Public Storage ============
21 
22     // Home contract
23     Home public home;
24     // local Replica address => remote Home domain
25     mapping(address => uint32) public replicaToDomain;
26     // remote Home domain => local Replica address
27     mapping(uint32 => address) public domainToReplica;
28     // watcher address => replica remote domain => has/doesn't have permission
29     mapping(address => mapping(uint32 => bool)) private watcherPermissions;
30 
31     // ============ Events ============
32 
33     /**
34      * @notice Emitted when a new Replica is enrolled / added
35      * @param domain the remote domain of the Home contract for the Replica
36      * @param replica the address of the Replica
37      */
38     event ReplicaEnrolled(uint32 indexed domain, address replica);
39 
40     /**
41      * @notice Emitted when a new Replica is un-enrolled / removed
42      * @param domain the remote domain of the Home contract for the Replica
43      * @param replica the address of the Replica
44      */
45     event ReplicaUnenrolled(uint32 indexed domain, address replica);
46 
47     /**
48      * @notice Emitted when Watcher permissions are changed
49      * @param domain the remote domain of the Home contract for the Replica
50      * @param watcher the address of the Watcher
51      * @param access TRUE if the Watcher was given permissions, FALSE if permissions were removed
52      */
53     event WatcherPermissionSet(
54         uint32 indexed domain,
55         address watcher,
56         bool access
57     );
58 
59     // ============ Constructor ============
60 
61     // solhint-disable-next-line no-empty-blocks
62     constructor() Ownable() {}
63 
64     // ============ External Functions ============
65 
66     /**
67      * @notice Un-Enroll a replica contract
68      * in the case that fraud was detected on the Home
69      * @dev in the future, if fraud occurs on the Home contract,
70      * the Watcher will submit their signature directly to the Home
71      * and it can be relayed to all remote chains to un-enroll the Replicas
72      * @param _domain the remote domain of the Home contract for the Replica
73      * @param _updater the address of the Updater for the Home contract (also stored on Replica)
74      * @param _signature signature of watcher on (domain, replica address, updater address)
75      */
76     function unenrollReplica(
77         uint32 _domain,
78         bytes32 _updater,
79         bytes memory _signature
80     ) external {
81         // ensure that the replica is currently set
82         address _replica = domainToReplica[_domain];
83         require(_replica != address(0), "!replica exists");
84         // ensure that the signature is on the proper updater
85         require(
86             Replica(_replica).updater() == TypeCasts.bytes32ToAddress(_updater),
87             "!current updater"
88         );
89         // get the watcher address from the signature
90         // and ensure that the watcher has permission to un-enroll this replica
91         address _watcher = _recoverWatcherFromSig(
92             _domain,
93             TypeCasts.addressToBytes32(_replica),
94             _updater,
95             _signature
96         );
97         require(watcherPermissions[_watcher][_domain], "!valid watcher");
98         // remove the replica from mappings
99         _clearReplica(_replica);
100     }
101 
102     /**
103      * @notice Set the address of the local Home contract
104      * @param _home the address of the local Home contract
105      */
106     function setHome(address _home) external onlyOwner {
107         home = Home(_home);
108     }
109 
110     /**
111      * @notice Allow Owner to enroll Replica contract
112      * @param _replica the address of the Replica
113      * @param _domain the remote domain of the Home contract for the Replica
114      */
115     function ownerEnrollReplica(address _replica, uint32 _domain)
116         external
117         onlyOwner
118     {
119         // un-enroll any existing replica or domain
120         _clearReplica(_replica);
121         _clearDomain(_domain);
122         // add replica and domain to two-way mapping
123         replicaToDomain[_replica] = _domain;
124         domainToReplica[_domain] = _replica;
125         emit ReplicaEnrolled(_domain, _replica);
126     }
127 
128     /**
129      * @notice Allow Owner to un-enroll Replica contract
130      * @param _replica the address of the Replica
131      */
132     function ownerUnenrollReplica(address _replica) external onlyOwner {
133         _clearReplica(_replica);
134     }
135 
136     /**
137      * @notice Allow Owner to set Watcher permissions for a Replica
138      * @param _watcher the address of the Watcher
139      * @param _domain the remote domain of the Home contract for the Replica
140      * @param _access TRUE to give the Watcher permissions, FALSE to remove permissions
141      */
142     function setWatcherPermission(
143         address _watcher,
144         uint32 _domain,
145         bool _access
146     ) external onlyOwner {
147         watcherPermissions[_watcher][_domain] = _access;
148         emit WatcherPermissionSet(_domain, _watcher, _access);
149     }
150 
151     /**
152      * @notice Query local domain from Home
153      * @return local domain
154      */
155     function localDomain() external view returns (uint32) {
156         return home.localDomain();
157     }
158 
159     /**
160      * @notice Get access permissions for the watcher on the domain
161      * @param _watcher the address of the watcher
162      * @param _domain the domain to check for watcher permissions
163      * @return TRUE iff _watcher has permission to un-enroll replicas on _domain
164      */
165     function watcherPermission(address _watcher, uint32 _domain)
166         external
167         view
168         returns (bool)
169     {
170         return watcherPermissions[_watcher][_domain];
171     }
172 
173     // ============ Public Functions ============
174 
175     /**
176      * @notice Check whether _replica is enrolled
177      * @param _replica the replica to check for enrollment
178      * @return TRUE iff _replica is enrolled
179      */
180     function isReplica(address _replica) public view returns (bool) {
181         return replicaToDomain[_replica] != 0;
182     }
183 
184     // ============ Internal Functions ============
185 
186     /**
187      * @notice Remove the replica from the two-way mappings
188      * @param _replica replica to un-enroll
189      */
190     function _clearReplica(address _replica) internal {
191         uint32 _currentDomain = replicaToDomain[_replica];
192         if (_currentDomain != 0) {
193             domainToReplica[_currentDomain] = address(0);
194             replicaToDomain[_replica] = 0;
195             emit ReplicaUnenrolled(_currentDomain, _replica);
196         }
197     }
198 
199     /**
200      * @notice remove the domain from the two-way mapping
201      * @param _domain domain to un-enroll
202      */
203     function _clearDomain(uint32 _domain) internal {
204         address _currentReplica = domainToReplica[_domain];
205         if (_currentReplica != address(0)) {
206             domainToReplica[_domain] = address(0);
207             replicaToDomain[_currentReplica] = 0;
208             emit ReplicaUnenrolled(_domain, _currentReplica);
209         }
210     }
211 
212     /**
213      * @notice Get the Watcher address from the provided signature
214      * @return address of watcher that signed
215      */
216     function _recoverWatcherFromSig(
217         uint32 _domain,
218         bytes32 _replica,
219         bytes32 _updater,
220         bytes memory _signature
221     ) internal view returns (address) {
222         bytes32 _homeDomainHash = Replica(TypeCasts.bytes32ToAddress(_replica))
223             .homeDomainHash();
224         bytes32 _digest = keccak256(
225             abi.encodePacked(_homeDomainHash, _domain, _updater)
226         );
227         _digest = ECDSA.toEthSignedMessageHash(_digest);
228         return ECDSA.recover(_digest, _signature);
229     }
230 
231     /**
232      * @dev should be impossible to renounce ownership;
233      * we override OpenZeppelin Ownable implementation
234      * of renounceOwnership to make it a no-op
235      */
236     function renounceOwnership() public override onlyOwner {
237         // do nothing
238     }
239 }
