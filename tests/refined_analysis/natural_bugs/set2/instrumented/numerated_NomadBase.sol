1 // SPDX-License-Identifier: MIT OR Apache-2.0
2 pragma solidity >=0.6.11;
3 
4 // ============ Internal Imports ============
5 import {Message} from "../libs/Message.sol";
6 // ============ External Imports ============
7 import {ECDSA} from "@openzeppelin/contracts/cryptography/ECDSA.sol";
8 import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/Initializable.sol";
9 import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
10 
11 /**
12  * @title NomadBase
13  * @author Illusory Systems Inc.
14  * @notice Shared utilities between Home and Replica.
15  */
16 abstract contract NomadBase is Initializable, OwnableUpgradeable {
17     // ============ Enums ============
18 
19     // States:
20     //   0 - UnInitialized - before initialize function is called
21     //   note: the contract is initialized at deploy time, so it should never be in this state
22     //   1 - Active - as long as the contract has not become fraudulent
23     //   2 - Failed - after a valid fraud proof has been submitted;
24     //   contract will no longer accept updates or new messages
25     enum States {
26         UnInitialized,
27         Active,
28         Failed
29     }
30 
31     // ============ Immutable Variables ============
32 
33     // Domain of chain on which the contract is deployed
34     uint32 public immutable localDomain;
35 
36     // ============ Public Variables ============
37 
38     // Address of bonded Updater
39     address public updater;
40     // Current state of contract
41     States public state;
42     // The latest root that has been signed by the Updater
43     bytes32 public committedRoot;
44 
45     // ============ Upgrade Gap ============
46 
47     // gap for upgrade safety
48     uint256[47] private __GAP;
49 
50     // ============ Events ============
51 
52     /**
53      * @notice Emitted when update is made on Home
54      * or unconfirmed update root is submitted on Replica
55      * @param homeDomain Domain of home contract
56      * @param oldRoot Old merkle root
57      * @param newRoot New merkle root
58      * @param signature Updater's signature on `oldRoot` and `newRoot`
59      */
60     event Update(
61         uint32 indexed homeDomain,
62         bytes32 indexed oldRoot,
63         bytes32 indexed newRoot,
64         bytes signature
65     );
66 
67     /**
68      * @notice Emitted when proof of a double update is submitted,
69      * which sets the contract to FAILED state
70      * @param oldRoot Old root shared between two conflicting updates
71      * @param newRoot Array containing two conflicting new roots
72      * @param signature Signature on `oldRoot` and `newRoot`[0]
73      * @param signature2 Signature on `oldRoot` and `newRoot`[1]
74      */
75     event DoubleUpdate(
76         bytes32 oldRoot,
77         bytes32[2] newRoot,
78         bytes signature,
79         bytes signature2
80     );
81 
82     /**
83      * @notice Emitted when Updater is rotated
84      * @param oldUpdater The address of the old updater
85      * @param newUpdater The address of the new updater
86      */
87     event NewUpdater(address oldUpdater, address newUpdater);
88 
89     // ============ Modifiers ============
90 
91     /**
92      * @notice Ensures that contract state != FAILED when the function is called
93      */
94     modifier notFailed() {
95         require(state != States.Failed, "failed state");
96         _;
97     }
98 
99     // ============ Constructor ============
100 
101     constructor(uint32 _localDomain) {
102         localDomain = _localDomain;
103     }
104 
105     // ============ Initializer ============
106 
107     function __NomadBase_initialize(address _updater) internal initializer {
108         __Ownable_init();
109         _setUpdater(_updater);
110         state = States.Active;
111     }
112 
113     // ============ External Functions ============
114 
115     /**
116      * @notice Called by external agent. Checks that signatures on two sets of
117      * roots are valid and that the new roots conflict with each other. If both
118      * cases hold true, the contract is failed and a `DoubleUpdate` event is
119      * emitted.
120      * @dev When `fail()` is called on Home, updater is slashed.
121      * @param _oldRoot Old root shared between two conflicting updates
122      * @param _newRoot Array containing two conflicting new roots
123      * @param _signature Signature on `_oldRoot` and `_newRoot`[0]
124      * @param _signature2 Signature on `_oldRoot` and `_newRoot`[1]
125      */
126     function doubleUpdate(
127         bytes32 _oldRoot,
128         bytes32[2] calldata _newRoot,
129         bytes calldata _signature,
130         bytes calldata _signature2
131     ) external notFailed {
132         if (
133             NomadBase._isUpdaterSignature(_oldRoot, _newRoot[0], _signature) &&
134             NomadBase._isUpdaterSignature(_oldRoot, _newRoot[1], _signature2) &&
135             _newRoot[0] != _newRoot[1]
136         ) {
137             _fail();
138             emit DoubleUpdate(_oldRoot, _newRoot, _signature, _signature2);
139         }
140     }
141 
142     // ============ Public Functions ============
143 
144     /**
145      * @notice Hash of Home domain concatenated with "NOMAD"
146      */
147     function homeDomainHash() public view virtual returns (bytes32);
148 
149     // ============ Internal Functions ============
150 
151     /**
152      * @notice Hash of Home domain concatenated with "NOMAD"
153      * @param _homeDomain the Home domain to hash
154      */
155     function _homeDomainHash(uint32 _homeDomain)
156         internal
157         pure
158         returns (bytes32)
159     {
160         return keccak256(abi.encodePacked(_homeDomain, "NOMAD"));
161     }
162 
163     /**
164      * @notice Set contract state to FAILED
165      * @dev Called when a valid fraud proof is submitted
166      */
167     function _setFailed() internal {
168         state = States.Failed;
169     }
170 
171     /**
172      * @notice Moves the contract into failed state
173      * @dev Called when fraud is proven
174      * (Double Update is submitted on Home or Replica,
175      * or Improper Update is submitted on Home)
176      */
177     function _fail() internal virtual;
178 
179     /**
180      * @notice Set the Updater
181      * @param _newUpdater Address of the new Updater
182      */
183     function _setUpdater(address _newUpdater) internal {
184         address _oldUpdater = updater;
185         updater = _newUpdater;
186         emit NewUpdater(_oldUpdater, _newUpdater);
187     }
188 
189     /**
190      * @notice Checks that signature was signed by Updater
191      * @param _oldRoot Old merkle root
192      * @param _newRoot New merkle root
193      * @param _signature Signature on `_oldRoot` and `_newRoot`
194      * @return TRUE iff signature is valid signed by updater
195      **/
196     function _isUpdaterSignature(
197         bytes32 _oldRoot,
198         bytes32 _newRoot,
199         bytes memory _signature
200     ) internal view returns (bool) {
201         bytes32 _digest = keccak256(
202             abi.encodePacked(homeDomainHash(), _oldRoot, _newRoot)
203         );
204         _digest = ECDSA.toEthSignedMessageHash(_digest);
205         return (ECDSA.recover(_digest, _signature) == updater);
206     }
207 }
