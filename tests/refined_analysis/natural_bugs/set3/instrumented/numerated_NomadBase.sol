1 // SPDX-License-Identifier: MIT OR Apache-2.0
2 pragma solidity 0.7.6;
3 
4 // ============ Internal Imports ============
5 import {Message} from "./libs/Message.sol";
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
68      * @notice Emitted when Updater is rotated
69      * @param oldUpdater The address of the old updater
70      * @param newUpdater The address of the new updater
71      */
72     event NewUpdater(address oldUpdater, address newUpdater);
73 
74     // ============ Constructor ============
75 
76     constructor(uint32 _localDomain) {
77         localDomain = _localDomain;
78     }
79 
80     // ============ Initializer ============
81 
82     function __NomadBase_initialize(address _updater) internal initializer {
83         __Ownable_init();
84         _setUpdater(_updater);
85         state = States.Active;
86     }
87 
88     // ============ Public Functions ============
89 
90     /**
91      * @notice Hash of Home domain concatenated with "NOMAD"
92      */
93     function homeDomainHash() public view virtual returns (bytes32);
94 
95     // ============ Internal Functions ============
96 
97     /**
98      * @notice Hash of Home domain concatenated with "NOMAD"
99      * @param _homeDomain the Home domain to hash
100      */
101     function _homeDomainHash(uint32 _homeDomain)
102         internal
103         pure
104         returns (bytes32)
105     {
106         return keccak256(abi.encodePacked(_homeDomain, "NOMAD"));
107     }
108 
109     /**
110      * @notice Set the Updater
111      * @param _newUpdater Address of the new Updater
112      */
113     function _setUpdater(address _newUpdater) internal {
114         address _oldUpdater = updater;
115         updater = _newUpdater;
116         emit NewUpdater(_oldUpdater, _newUpdater);
117     }
118 
119     /**
120      * @notice Checks that signature was signed by Updater
121      * @param _oldRoot Old merkle root
122      * @param _newRoot New merkle root
123      * @param _signature Signature on `_oldRoot` and `_newRoot`
124      * @return TRUE iff signature is valid signed by updater
125      **/
126     function _isUpdaterSignature(
127         bytes32 _oldRoot,
128         bytes32 _newRoot,
129         bytes memory _signature
130     ) internal view returns (bool) {
131         bytes32 _digest = keccak256(
132             abi.encodePacked(homeDomainHash(), _oldRoot, _newRoot)
133         );
134         _digest = ECDSA.toEthSignedMessageHash(_digest);
135         return (ECDSA.recover(_digest, _signature) == updater);
136     }
137 
138     /**
139      * @dev should be impossible to renounce ownership;
140      * we override OpenZeppelin OwnableUpgradeable's
141      * implementation of renounceOwnership to make it a no-op
142      */
143     function renounceOwnership() public override onlyOwner {
144         // do nothing
145     }
146 }
