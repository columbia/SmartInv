1 // SPDX-License-Identifier: MIT OR Apache-2.0
2 pragma solidity >=0.6.11;
3 
4 // ============ Internal Imports ============
5 import {Home} from "./Home.sol";
6 import {Replica} from "./Replica.sol";
7 import {TypeCasts} from "../libs/TypeCasts.sol";
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
59     // ============ Modifiers ============
60 
61     modifier onlyReplica() {
62         require(isReplica(msg.sender), "!replica");
63         _;
64     }
65 
66     // ============ Constructor ============
67 
68     // solhint-disable-next-line no-empty-blocks
69     constructor() Ownable() {}
70 
71     // ============ External Functions ============
72 
73     /**
74      * @notice Un-Enroll a replica contract
75      * in the case that fraud was detected on the Home
76      * @dev in the future, if fraud occurs on the Home contract,
77      * the Watcher will submit their signature directly to the Home
78      * and it can be relayed to all remote chains to un-enroll the Replicas
79      * @param _domain the remote domain of the Home contract for the Replica
80      * @param _updater the address of the Updater for the Home contract (also stored on Replica)
81      * @param _signature signature of watcher on (domain, replica address, updater address)
82      */
83     function unenrollReplica(
84         uint32 _domain,
85         bytes32 _updater,
86         bytes memory _signature
87     ) external {
88         // ensure that the replica is currently set
89         address _replica = domainToReplica[_domain];
90         require(_replica != address(0), "!replica exists");
91         // ensure that the signature is on the proper updater
92         require(
93             Replica(_replica).updater() == TypeCasts.bytes32ToAddress(_updater),
94             "!current updater"
95         );
96         // get the watcher address from the signature
97         // and ensure that the watcher has permission to un-enroll this replica
98         address _watcher = _recoverWatcherFromSig(
99             _domain,
100             TypeCasts.addressToBytes32(_replica),
101             _updater,
102             _signature
103         );
104         require(watcherPermissions[_watcher][_domain], "!valid watcher");
105         // remove the replica from mappings
106         _unenrollReplica(_replica);
107     }
108 
109     /**
110      * @notice Set the address of the local Home contract
111      * @param _home the address of the local Home contract
112      */
113     function setHome(address _home) external onlyOwner {
114         home = Home(_home);
115     }
116 
117     /**
118      * @notice Allow Owner to enroll Replica contract
119      * @param _replica the address of the Replica
120      * @param _domain the remote domain of the Home contract for the Replica
121      */
122     function ownerEnrollReplica(address _replica, uint32 _domain)
123         external
124         onlyOwner
125     {
126         // un-enroll any existing replica
127         _unenrollReplica(_replica);
128         // add replica and domain to two-way mapping
129         replicaToDomain[_replica] = _domain;
130         domainToReplica[_domain] = _replica;
131         emit ReplicaEnrolled(_domain, _replica);
132     }
133 
134     /**
135      * @notice Allow Owner to un-enroll Replica contract
136      * @param _replica the address of the Replica
137      */
138     function ownerUnenrollReplica(address _replica) external onlyOwner {
139         _unenrollReplica(_replica);
140     }
141 
142     /**
143      * @notice Allow Owner to set Watcher permissions for a Replica
144      * @param _watcher the address of the Watcher
145      * @param _domain the remote domain of the Home contract for the Replica
146      * @param _access TRUE to give the Watcher permissions, FALSE to remove permissions
147      */
148     function setWatcherPermission(
149         address _watcher,
150         uint32 _domain,
151         bool _access
152     ) external onlyOwner {
153         watcherPermissions[_watcher][_domain] = _access;
154         emit WatcherPermissionSet(_domain, _watcher, _access);
155     }
156 
157     /**
158      * @notice Query local domain from Home
159      * @return local domain
160      */
161     function localDomain() external view returns (uint32) {
162         return home.localDomain();
163     }
164 
165     /**
166      * @notice Get access permissions for the watcher on the domain
167      * @param _watcher the address of the watcher
168      * @param _domain the domain to check for watcher permissions
169      * @return TRUE iff _watcher has permission to un-enroll replicas on _domain
170      */
171     function watcherPermission(address _watcher, uint32 _domain)
172         external
173         view
174         returns (bool)
175     {
176         return watcherPermissions[_watcher][_domain];
177     }
178 
179     // ============ Public Functions ============
180 
181     /**
182      * @notice Check whether _replica is enrolled
183      * @param _replica the replica to check for enrollment
184      * @return TRUE iff _replica is enrolled
185      */
186     function isReplica(address _replica) public view returns (bool) {
187         return replicaToDomain[_replica] != 0;
188     }
189 
190     // ============ Internal Functions ============
191 
192     /**
193      * @notice Remove the replica from the two-way mappings
194      * @param _replica replica to un-enroll
195      */
196     function _unenrollReplica(address _replica) internal {
197         uint32 _currentDomain = replicaToDomain[_replica];
198         domainToReplica[_currentDomain] = address(0);
199         replicaToDomain[_replica] = 0;
200         emit ReplicaUnenrolled(_currentDomain, _replica);
201     }
202 
203     /**
204      * @notice Get the Watcher address from the provided signature
205      * @return address of watcher that signed
206      */
207     function _recoverWatcherFromSig(
208         uint32 _domain,
209         bytes32 _replica,
210         bytes32 _updater,
211         bytes memory _signature
212     ) internal view returns (address) {
213         bytes32 _homeDomainHash = Replica(TypeCasts.bytes32ToAddress(_replica))
214             .homeDomainHash();
215         bytes32 _digest = keccak256(
216             abi.encodePacked(_homeDomainHash, _domain, _updater)
217         );
218         _digest = ECDSA.toEthSignedMessageHash(_digest);
219         return ECDSA.recover(_digest, _signature);
220     }
221 }
