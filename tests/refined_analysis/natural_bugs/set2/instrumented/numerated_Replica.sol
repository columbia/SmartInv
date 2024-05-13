1 // SPDX-License-Identifier: MIT OR Apache-2.0
2 pragma solidity >=0.6.11;
3 
4 // ============ Internal Imports ============
5 import {Version0} from "./Version0.sol";
6 import {NomadBase} from "./NomadBase.sol";
7 import {MerkleLib} from "../libs/Merkle.sol";
8 import {Message} from "../libs/Message.sol";
9 // ============ External Imports ============
10 import {TypedMemView} from "@summa-tx/memview-sol/contracts/TypedMemView.sol";
11 
12 /**
13  * @title Replica
14  * @author Illusory Systems Inc.
15  * @notice Track root updates on Home,
16  * prove and dispatch messages to end recipients.
17  */
18 contract Replica is Version0, NomadBase {
19     // ============ Libraries ============
20 
21     using MerkleLib for MerkleLib.Tree;
22     using TypedMemView for bytes;
23     using TypedMemView for bytes29;
24     using Message for bytes29;
25 
26     // ============ Enums ============
27 
28     // Status of Message:
29     //   0 - None - message has not been proven or processed
30     //   1 - Proven - message inclusion proof has been validated
31     //   2 - Processed - message has been dispatched to recipient
32     enum MessageStatus {
33         None,
34         Proven,
35         Processed
36     }
37 
38     // ============ Immutables ============
39 
40     // Minimum gas for message processing
41     uint256 public immutable PROCESS_GAS;
42     // Reserved gas (to ensure tx completes in case message processing runs out)
43     uint256 public immutable RESERVE_GAS;
44 
45     // ============ Public Storage ============
46 
47     // Domain of home chain
48     uint32 public remoteDomain;
49     // Number of seconds to wait before root becomes confirmable
50     uint256 public optimisticSeconds;
51     // re-entrancy guard
52     uint8 private entered;
53     // Mapping of roots to allowable confirmation times
54     mapping(bytes32 => uint256) public confirmAt;
55     // Mapping of message leaves to MessageStatus
56     mapping(bytes32 => MessageStatus) public messages;
57 
58     // ============ Upgrade Gap ============
59 
60     // gap for upgrade safety
61     uint256[45] private __GAP;
62 
63     // ============ Events ============
64 
65     /**
66      * @notice Emitted when message is processed
67      * @param messageHash Hash of message that failed to process
68      * @param success TRUE if the call was executed successfully, FALSE if the call reverted
69      * @param returnData the return data from the external call
70      */
71     event Process(
72         bytes32 indexed messageHash,
73         bool indexed success,
74         bytes indexed returnData
75     );
76 
77     /**
78      * @notice Emitted when the value for optimisticTimeout is set
79      * @param timeout The new value for optimistic timeout
80      */
81     event SetOptimisticTimeout(uint256 timeout);
82 
83     /**
84      * @notice Emitted when a root's confirmation is modified by governance
85      * @param root The root for which confirmAt has been set
86      * @param previousConfirmAt The previous value of confirmAt
87      * @param newConfirmAt The new value of confirmAt
88      */
89     event SetConfirmation(
90         bytes32 indexed root,
91         uint256 previousConfirmAt,
92         uint256 newConfirmAt
93     );
94 
95     // ============ Constructor ============
96 
97     // solhint-disable-next-line no-empty-blocks
98     constructor(
99         uint32 _localDomain,
100         uint256 _processGas,
101         uint256 _reserveGas
102     ) NomadBase(_localDomain) {
103         require(_processGas >= 850_000, "!process gas");
104         require(_reserveGas >= 15_000, "!reserve gas");
105         PROCESS_GAS = _processGas;
106         RESERVE_GAS = _reserveGas;
107     }
108 
109     // ============ Initializer ============
110 
111     function initialize(
112         uint32 _remoteDomain,
113         address _updater,
114         bytes32 _committedRoot,
115         uint256 _optimisticSeconds
116     ) public initializer {
117         __NomadBase_initialize(_updater);
118         // set storage variables
119         entered = 1;
120         remoteDomain = _remoteDomain;
121         committedRoot = _committedRoot;
122         confirmAt[_committedRoot] = 1;
123         optimisticSeconds = _optimisticSeconds;
124         emit SetOptimisticTimeout(_optimisticSeconds);
125     }
126 
127     // ============ External Functions ============
128 
129     /**
130      * @notice Called by external agent. Submits the signed update's new root,
131      * marks root's allowable confirmation time, and emits an `Update` event.
132      * @dev Reverts if update doesn't build off latest committedRoot
133      * or if signature is invalid.
134      * @param _oldRoot Old merkle root
135      * @param _newRoot New merkle root
136      * @param _signature Updater's signature on `_oldRoot` and `_newRoot`
137      */
138     function update(
139         bytes32 _oldRoot,
140         bytes32 _newRoot,
141         bytes memory _signature
142     ) external notFailed {
143         // ensure that update is building off the last submitted root
144         require(_oldRoot == committedRoot, "not current update");
145         // validate updater signature
146         require(
147             _isUpdaterSignature(_oldRoot, _newRoot, _signature),
148             "!updater sig"
149         );
150         // Hook for future use
151         _beforeUpdate();
152         // set the new root's confirmation timer
153         confirmAt[_newRoot] = block.timestamp + optimisticSeconds;
154         // update committedRoot
155         committedRoot = _newRoot;
156         emit Update(remoteDomain, _oldRoot, _newRoot, _signature);
157     }
158 
159     /**
160      * @notice First attempts to prove the validity of provided formatted
161      * `message`. If the message is successfully proven, then tries to process
162      * message.
163      * @dev Reverts if `prove` call returns false
164      * @param _message Formatted message (refer to NomadBase.sol Message library)
165      * @param _proof Merkle proof of inclusion for message's leaf
166      * @param _index Index of leaf in home's merkle tree
167      */
168     function proveAndProcess(
169         bytes memory _message,
170         bytes32[32] calldata _proof,
171         uint256 _index
172     ) external {
173         require(prove(keccak256(_message), _proof, _index), "!prove");
174         process(_message);
175     }
176 
177     /**
178      * @notice Given formatted message, attempts to dispatch
179      * message payload to end recipient.
180      * @dev Recipient must implement a `handle` method (refer to IMessageRecipient.sol)
181      * Reverts if formatted message's destination domain is not the Replica's domain,
182      * if message has not been proven,
183      * or if not enough gas is provided for the dispatch transaction.
184      * @param _message Formatted message
185      * @return _success TRUE iff dispatch transaction succeeded
186      */
187     function process(bytes memory _message) public returns (bool _success) {
188         bytes29 _m = _message.ref(0);
189         // ensure message was meant for this domain
190         require(_m.destination() == localDomain, "!destination");
191         // ensure message has been proven
192         bytes32 _messageHash = _m.keccak();
193         require(messages[_messageHash] == MessageStatus.Proven, "!proven");
194         // check re-entrancy guard
195         require(entered == 1, "!reentrant");
196         entered = 0;
197         // update message status as processed
198         messages[_messageHash] = MessageStatus.Processed;
199         // A call running out of gas TYPICALLY errors the whole tx. We want to
200         // a) ensure the call has a sufficient amount of gas to make a
201         //    meaningful state change.
202         // b) ensure that if the subcall runs out of gas, that the tx as a whole
203         //    does not revert (i.e. we still mark the message processed)
204         // To do this, we require that we have enough gas to process
205         // and still return. We then delegate only the minimum processing gas.
206         require(gasleft() >= PROCESS_GAS + RESERVE_GAS, "!gas");
207         // get the message recipient
208         address _recipient = _m.recipientAddress();
209         // set up for assembly call
210         uint256 _toCopy;
211         uint256 _maxCopy = 256;
212         uint256 _gas = PROCESS_GAS;
213         // allocate memory for returndata
214         bytes memory _returnData = new bytes(_maxCopy);
215         bytes memory _calldata = abi.encodeWithSignature(
216             "handle(uint32,uint32,bytes32,bytes)",
217             _m.origin(),
218             _m.nonce(),
219             _m.sender(),
220             _m.body().clone()
221         );
222         // dispatch message to recipient
223         // by assembly calling "handle" function
224         // we call via assembly to avoid memcopying a very large returndata
225         // returned by a malicious contract
226         assembly {
227             _success := call(
228                 _gas, // gas
229                 _recipient, // recipient
230                 0, // ether value
231                 add(_calldata, 0x20), // inloc
232                 mload(_calldata), // inlen
233                 0, // outloc
234                 0 // outlen
235             )
236             // limit our copy to 256 bytes
237             _toCopy := returndatasize()
238             if gt(_toCopy, _maxCopy) {
239                 _toCopy := _maxCopy
240             }
241             // Store the length of the copied bytes
242             mstore(_returnData, _toCopy)
243             // copy the bytes from returndata[0:_toCopy]
244             returndatacopy(add(_returnData, 0x20), 0, _toCopy)
245         }
246         // emit process results
247         emit Process(_messageHash, _success, _returnData);
248         // reset re-entrancy guard
249         entered = 1;
250     }
251 
252     // ============ External Owner Functions ============
253 
254     /**
255      * @notice Set optimistic timeout period for new roots
256      * @dev Only callable by owner (Governance)
257      * @param _optimisticSeconds New optimistic timeout period
258      */
259     function setOptimisticTimeout(uint256 _optimisticSeconds)
260         external
261         onlyOwner
262     {
263         optimisticSeconds = _optimisticSeconds;
264         emit SetOptimisticTimeout(_optimisticSeconds);
265     }
266 
267     /**
268      * @notice Set Updater role
269      * @dev MUST ensure that all roots signed by previous Updater have
270      * been relayed before calling. Only callable by owner (Governance)
271      * @param _updater New Updater
272      */
273     function setUpdater(address _updater) external onlyOwner {
274         _setUpdater(_updater);
275     }
276 
277     /**
278      * @notice Set confirmAt for a given root
279      * @dev To be used if in the case that fraud is proven
280      * and roots need to be deleted / added. Only callable by owner (Governance)
281      * @param _root The root for which to modify confirm time
282      * @param _confirmAt The new confirmation time. Set to 0 to "delete" a root.
283      */
284     function setConfirmation(bytes32 _root, uint256 _confirmAt)
285         external
286         onlyOwner
287     {
288         uint256 _previousConfirmAt = confirmAt[_root];
289         confirmAt[_root] = _confirmAt;
290         emit SetConfirmation(_root, _previousConfirmAt, _confirmAt);
291     }
292 
293     // ============ Public Functions ============
294 
295     /**
296      * @notice Check that the root has been submitted
297      * and that the optimistic timeout period has expired,
298      * meaning the root can be processed
299      * @param _root the Merkle root, submitted in an update, to check
300      * @return TRUE iff root has been submitted & timeout has expired
301      */
302     function acceptableRoot(bytes32 _root) public view returns (bool) {
303         uint256 _time = confirmAt[_root];
304         if (_time == 0) {
305             return false;
306         }
307         return block.timestamp >= _time;
308     }
309 
310     /**
311      * @notice Attempts to prove the validity of message given its leaf, the
312      * merkle proof of inclusion for the leaf, and the index of the leaf.
313      * @dev Reverts if message's MessageStatus != None (i.e. if message was
314      * already proven or processed)
315      * @dev For convenience, we allow proving against any previous root.
316      * This means that witnesses never need to be updated for the new root
317      * @param _leaf Leaf of message to prove
318      * @param _proof Merkle proof of inclusion for leaf
319      * @param _index Index of leaf in home's merkle tree
320      * @return Returns true if proof was valid and `prove` call succeeded
321      **/
322     function prove(
323         bytes32 _leaf,
324         bytes32[32] calldata _proof,
325         uint256 _index
326     ) public returns (bool) {
327         // ensure that message has not been proven or processed
328         require(messages[_leaf] == MessageStatus.None, "!MessageStatus.None");
329         // calculate the expected root based on the proof
330         bytes32 _calculatedRoot = MerkleLib.branchRoot(_leaf, _proof, _index);
331         // if the root is valid, change status to Proven
332         if (acceptableRoot(_calculatedRoot)) {
333             messages[_leaf] = MessageStatus.Proven;
334             return true;
335         }
336         return false;
337     }
338 
339     /**
340      * @notice Hash of Home domain concatenated with "NOMAD"
341      */
342     function homeDomainHash() public view override returns (bytes32) {
343         return _homeDomainHash(remoteDomain);
344     }
345 
346     // ============ Internal Functions ============
347 
348     /**
349      * @notice Moves the contract into failed state
350      * @dev Called when a Double Update is submitted
351      */
352     function _fail() internal override {
353         _setFailed();
354     }
355 
356     /// @notice Hook for potential future use
357     // solhint-disable-next-line no-empty-blocks
358     function _beforeUpdate() internal {}
359 }
