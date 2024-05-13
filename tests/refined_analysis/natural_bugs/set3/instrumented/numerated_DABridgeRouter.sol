1 // SPDX-License-Identifier: MIT OR Apache-2.0
2 pragma solidity 0.7.6;
3 
4 // ============ External Imports ============
5 import {TypedMemView} from "@summa-tx/memview-sol/contracts/TypedMemView.sol";
6 // ============ Internal Imports ============
7 import {DABridgeMessage} from "./DABridgeMessage.sol";
8 import {XAppConnectionClient} from "@nomad-xyz/contracts-router/contracts/XAppConnectionClient.sol";
9 import {Router} from "@nomad-xyz/contracts-router/contracts/Router.sol";
10 import {Version0} from "@nomad-xyz/contracts-core/contracts/Version0.sol";
11 
12 /**
13  * @title DABridgeRouter
14  */
15 contract DABridgeRouter is Version0, Router {
16     // ============ Libraries ============
17 
18     using TypedMemView for bytes;
19     using TypedMemView for bytes29;
20     using DABridgeMessage for bytes29;
21 
22     // ============ Public Storage ============
23 
24     mapping(uint32 => bytes32) public roots;
25     uint32 private _availDomain;
26 
27     // ============ Upgrade Gap ============
28 
29     // gap for upgrade safety
30     uint256[50] private __GAP;
31 
32     // ============ Events ============
33 
34     /**
35      * @notice emitted when a new data root is received
36      * @param originAndNonce Domain where the transfer originated and the
37      *        unique identifier for the message from origin to destination,
38      *        combined in a single field ((origin << 32) & nonce)
39      * @param blockNumber for data root
40      * @param root data root
41      */
42     event DataRootReceived(
43         uint64 indexed originAndNonce,
44         uint32 indexed blockNumber,
45         bytes32 root
46     );
47 
48     // ============ Initializer ============
49 
50     function initialize(address _xAppConnectionManager, uint32 availDomain)
51         public
52         initializer
53     {
54         __XAppConnectionClient_initialize(_xAppConnectionManager);
55         _availDomain = availDomain;
56     }
57 
58     // ============ Handle message functions ============
59 
60     /**
61      * @notice Receive messages sent via Nomad from other remote xApp Routers;
62      * parse the contents of the message and enact the message's effects on the local chain
63      * @dev Called by an Nomad Replica contract while processing a message sent via Nomad
64      * @param _origin The domain the message is coming from
65      * @param _nonce The unique identifier for the message from origin to destination
66      * @param _sender The address the message is coming from
67      * @param _message The message in the form of raw bytes
68      */
69     function handle(
70         uint32 _origin,
71         uint32 _nonce,
72         bytes32 _sender,
73         bytes memory _message
74     ) external override onlyReplica onlyRemoteRouter(_origin, _sender) {
75         require(_origin == _availDomain, "!valid domain");
76         bytes29 _view = _message.ref(0).getTypedView();
77         if (_view.isValidDataRoot()) {
78             _handleDataRoot(_origin, _nonce, _view);
79         } else {
80             revert("!valid message");
81         }
82     }
83 
84     /**
85      * @notice Once the Router has parsed a message in the handle function,
86      * call this internal function to parse and store the `blockNumber`
87      * and `root` from the message.
88      * @param _origin The domain the message is coming from
89      * @param _nonce The unique identifier for the message from origin to destination
90      * @param _message The message in the form of raw bytes
91      */
92     function _handleDataRoot(
93         uint32 _origin,
94         uint32 _nonce,
95         bytes29 _message
96     ) internal {
97         (uint32 blockNumber, bytes32 dataRoot) = _parse(_message);
98         assert(roots[blockNumber] == 0);
99         roots[blockNumber] = dataRoot;
100         emit DataRootReceived(
101             _originAndNonce(_origin, _nonce),
102             blockNumber,
103             dataRoot
104         );
105     }
106 
107     /**
108      * @notice parse blockNumber and root from message and emit event
109      * @param _message The message in the form of raw bytes
110      */
111     function _parse(bytes29 _message)
112         internal
113         pure
114         returns (uint32 blockNumber, bytes32 dataRoot)
115     {
116         blockNumber = _message.blockNumber();
117         dataRoot = _message.dataRoot();
118     }
119 
120     // ============ Internal: Utils ============
121 
122     /**
123      * @notice Internal utility function that combines
124      *         `_origin` and `_nonce`.
125      * @dev Both origin and nonce should be less than 2^32 - 1
126      * @param _origin Domain of chain where the transfer originated
127      * @param _nonce The unique identifier for the message from origin to
128               destination
129      * @return Returns (`_origin` << 32) & `_nonce`
130      */
131     function _originAndNonce(uint32 _origin, uint32 _nonce)
132         internal
133         pure
134         returns (uint64)
135     {
136         return (uint64(_origin) << 32) | _nonce;
137     }
138 }
