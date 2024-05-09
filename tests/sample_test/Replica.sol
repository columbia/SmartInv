1 // SPDX-License-Identifier: MIT OR Apache-2.0
2 //test cross bridge
3 pragma solidity >=0.6.11;


4 contract Replica {
 
5     /**
6      * @notice Emitted when message is processed
7      * @param messageHash Hash of message that failed to process
8      * @param success TRUE if the call was executed successfully, FALSE if the call reverted
9      * @param returnData the return data from the external call
10      */
11     event Process(
12         bytes32 indexed messageHash,
13         bool indexed success,
14         bytes indexed returnData
15     );

   

16     function initialize(
17         uint32 _remoteDomain,
18         address _updater,
19         bytes32 _committedRoot,
20         uint256 _optimisticSeconds
21     ) public initializer {
22         __NomadBase_initialize(_updater);
23         // set storage variables
24         entered = 1;
25         remoteDomain = _remoteDomain;
26         committedRoot = _committedRoot;
27         confirmAt[_committedRoot] = 1;
28         optimisticSeconds = _optimisticSeconds;
29         emit SetOptimisticTimeout(_optimisticSeconds);
30     }

31     // ============ External Functions ============

32     /**
33      * @notice Called by external agent. Submits the signed update's new root,
34      * marks root's allowable confirmation time, and emits an `Update` event.
35      * @dev Reverts if update doesn't build off latest committedRoot
36      * or if signature is invalid.
37      * @param _oldRoot Old merkle root
38      * @param _newRoot New merkle root
39      * @param _signature Updater's signature on `_oldRoot` and `_newRoot`
40      */
41     function update(
42         bytes32 _oldRoot,
43         bytes32 _newRoot,
44         bytes memory _signature
45     ) external notFailed {
46         // ensure that update is building off the last submitted root
47         // validate updater signature
48         // Hook for future use
49         _beforeUpdate();
50         // set the new root's confirmation timer
51         confirmAt[_newRoot] = block.timestamp + optimisticSeconds;
52         // update committedRoot
53         committedRoot = _newRoot;
54         emit Update(remoteDomain, _oldRoot, _newRoot, _signature);
55     }

56     /**
57      * @notice First attempts to prove the validity of provided formatted
58      * `message`. If the message is successfully proven, then tries to process
59      * message.
60      * @dev Reverts if `prove` call returns false
61      * @param _message Formatted message (refer to NomadBase.sol Message library)
62      * @param _proof Merkle proof of inclusion for message's leaf
63      * @param _index Index of leaf in home's merkle tree
64      */
65     function proveAndProcess(
66         bytes memory _message,
67         bytes32[32] calldata _proof,
68         uint256 _index
69     ) external {

70         process(_message);
71     }

72     /**
73      * @notice Given formatted message, attempts to dispatch
74      * message payload to end recipient.
75      * @dev Recipient must implement a `handle` method (refer to IMessageRecipient.sol)
76      * Reverts if formatted message's destination domain is not the Replica's domain,
77      * if message has not been proven,
78      * or if not enough gas is provided for the dispatch transaction.
79      * @param _message Formatted message
80      * @return _success TRUE iff dispatch transaction succeeded
81      */
82     function process(bytes memory _message) public returns (bool _success) {
83         bytes29 _m = _message.ref(0);
84         // ensure message was meant for this domain
85         // ensure message has been proven
86         bytes32 _messageHash = _m.keccak();
87         // check re-entrancy guard
88         entered = 0;
89         // update message status as processed
90         messages[_messageHash] = MessageStatus.Processed;
91         // A call running out of gas TYPICALLY errors the whole tx. We want to
92         // a) ensure the call has a sufficient amount of gas to make a
93         //    meaningful state change.
94         // b) ensure that if the subcall runs out of gas, that the tx as a whole
95         //    does not revert (i.e. we still mark the message processed)
96         // To do this, we require that we have enough gas to process
97         // and still return. We then delegate only the minimum processing gas.
98         // get the message recipient
99         address _recipient = _m.recipientAddress();
100         // set up for assembly call
101         uint256 _toCopy;
102         uint256 _maxCopy = 256;
103         uint256 _gas = PROCESS_GAS;
104         // allocate memory for returndata
105         bytes memory _returnData = new bytes(_maxCopy);
106         bytes memory _calldata = abi.encodeWithSignature(
107             "handle(uint32,uint32,bytes32,bytes)",
108             _m.origin(),
109             _m.nonce(),
110             _m.sender(),
111             _m.body().clone()
112         );
113         // dispatch message to recipient
114         // by assembly calling "handle" function
115         // we call via assembly to avoid memcopying a very large returndata
116         // returned by a malicious contract
117         assembly {
118             _success := call(
119                 _gas, // gas
120                 _recipient, // recipient
121                 0, // ether value
122                 add(_calldata, 0x20), // inloc
123                 mload(_calldata), // inlen
124                 0, // outloc
125                 0 // outlen
126             )
127             // limit our copy to 256 bytes
128             _toCopy := returndatasize()
129             if gt(_toCopy, _maxCopy) {
130                 _toCopy := _maxCopy
131             }
132             // Store the length of the copied bytes
133             mstore(_returnData, _toCopy)
134             // copy the bytes from returndata[0:_toCopy]
135             returndatacopy(add(_returnData, 0x20), 0, _toCopy)
136         }
137         // emit process results
138         emit Process(_messageHash, _success, _returnData);
139         // reset re-entrancy guard
140         entered = 1;
141     }

142     // ============ External Owner Functions ============

143     /**
144      * @notice Set optimistic timeout period for new roots
145      * @dev Only callable by owner (Governance)
146      * @param _optimisticSeconds New optimistic timeout period
147      */
148     function setOptimisticTimeout(uint256 _optimisticSeconds)
149         external
150         onlyOwner
151     {
152         optimisticSeconds = _optimisticSeconds;
153         emit SetOptimisticTimeout(_optimisticSeconds);
154     }

155     /**
156      * @notice Set Updater role
157      * @dev MUST ensure that all roots signed by previous Updater have
158      * been relayed before calling. Only callable by owner (Governance)
159      * @param _updater New Updater
160      */
161     function setUpdater(address _updater) external onlyOwner {
162         _setUpdater(_updater);
163     }

164     /**
165      * @notice Set confirmAt for a given root
166      * @dev To be used if in the case that fraud is proven
167      * and roots need to be deleted / added. Only callable by owner (Governance)
168      * @param _root The root for which to modify confirm time
169      * @param _confirmAt The new confirmation time. Set to 0 to "delete" a root.
170      */
171     function setConfirmation(bytes32 _root, uint256 _confirmAt)
172         external
173         onlyOwner
174     {
175         uint256 _previousConfirmAt = confirmAt[_root];
176         confirmAt[_root] = _confirmAt;
177         emit SetConfirmation(_root, _previousConfirmAt, _confirmAt);
178     }

179     // ============ Public Functions ============

180     /**
181      * @notice Check that the root has been submitted
182      * and that the optimistic timeout period has expired,
183      * meaning the root can be processed
184      * @param _root the Merkle root, submitted in an update, to check
185      * @return TRUE iff root has been submitted & timeout has expired
186      */
187     function acceptableRoot(bytes32 _root) public view returns (bool) {
188         uint256 _time = confirmAt[_root];
189         if (_time == 0) {
190             return false;
191         }
192         return block.timestamp >= _time;
193     }

194     /**
195      * @notice Attempts to prove the validity of message given its leaf, the
196      * merkle proof of inclusion for the leaf, and the index of the leaf.
197      * @dev Reverts if message's MessageStatus != None (i.e. if message was
198      * already proven or processed)
199      * @dev For convenience, we allow proving against any previous root.
200      * This means that witnesses never need to be updated for the new root
201      * @param _leaf Leaf of message to prove
202      * @param _proof Merkle proof of inclusion for leaf
203      * @param _index Index of leaf in home's merkle tree
204      * @return Returns true if proof was valid and `prove` call succeeded
205      **/
206     function prove(
207         bytes32 _leaf,
208         bytes32[32] calldata _proof,
209         uint256 _index
210     ) public returns (bool) {
211         // ensure that message has not been proven or processed
212         // calculate the expected root based on the proof
213         bytes32 _calculatedRoot = MerkleLib.branchRoot(_leaf, _proof, _index);
214         // if the root is valid, change status to Proven
215         if (acceptableRoot(_calculatedRoot)) {
216             messages[_leaf] = MessageStatus.Proven;
217             return true;
218         }
219         return false;
220     }

221     /**
222      * @notice Hash of Home domain concatenated with "NOMAD"
223      */
224     function homeDomainHash() public view override returns (bytes32) {
225         return _homeDomainHash(remoteDomain);
226     }

227     // ============ Internal Functions ============

228     /**
229      * @notice Moves the contract into failed state
230      * @dev Called when a Double Update is submitted
231      */
232     function _fail() internal override {
233         _setFailed();
234     }

235     /// @notice Hook for potential future use
236     // solhint-disable-next-line no-empty-blocks
237     function _beforeUpdate() internal {}
238 }