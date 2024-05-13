1 // SPDX-License-Identifier: MIT OR Apache-2.0
2 pragma solidity 0.7.6;
3 
4 // ============ Internal Imports ============
5 import {Version0} from "./Version0.sol";
6 import {NomadBase} from "./NomadBase.sol";
7 import {MerkleLib} from "./libs/Merkle.sol";
8 import {Message} from "./libs/Message.sol";
9 import {IMessageRecipient} from "./interfaces/IMessageRecipient.sol";
10 // ============ External Imports ============
11 import {TypedMemView} from "@summa-tx/memview-sol/contracts/TypedMemView.sol";
12 
13 /**
14  * @title Replica
15  * @author Illusory Systems Inc.
16  * @notice Track root updates on Home,
17  * prove and dispatch messages to end recipients.
18  */
19 contract Replica is Version0, NomadBase {
20     // ============ Libraries ============
21 
22     using MerkleLib for MerkleLib.Tree;
23     using TypedMemView for bytes;
24     using TypedMemView for bytes29;
25     using Message for bytes29;
26 
27     // ============ Constants ============
28 
29     bytes32 public constant LEGACY_STATUS_NONE = bytes32(0);
30     bytes32 public constant LEGACY_STATUS_PROVEN = bytes32(uint256(1));
31     bytes32 public constant LEGACY_STATUS_PROCESSED = bytes32(uint256(2));
32 
33     // ============ Public Storage ============
34 
35     // Domain of home chain
36     uint32 public remoteDomain;
37     // Number of seconds to wait before root becomes confirmable
38     uint256 public optimisticSeconds;
39     // re-entrancy guard
40     uint8 private entered;
41     // Mapping of roots to allowable confirmation times
42     mapping(bytes32 => uint256) public confirmAt;
43     // Mapping of message leaves to MessageStatus
44     mapping(bytes32 => bytes32) public messages;
45 
46     // ============ Upgrade Gap ============
47 
48     // gap for upgrade safety
49     uint256[45] private __GAP;
50 
51     // ============ Events ============
52 
53     /**
54      * @notice Emitted when message is processed
55      * @param messageHash The keccak256 hash of the message that was processed
56      * @param success TRUE if the call was executed successfully,
57      * FALSE if the call reverted or threw
58      * @param returnData the return data from the external call
59      */
60     event Process(
61         bytes32 indexed messageHash,
62         bool indexed success,
63         bytes indexed returnData
64     );
65 
66     /**
67      * @notice Emitted when the value for optimisticTimeout is set
68      * @param timeout The new value for optimistic timeout
69      */
70     event SetOptimisticTimeout(uint256 timeout);
71 
72     /**
73      * @notice Emitted when a root's confirmation is modified by governance
74      * @param root The root for which confirmAt has been set
75      * @param previousConfirmAt The previous value of confirmAt
76      * @param newConfirmAt The new value of confirmAt
77      */
78     event SetConfirmation(
79         bytes32 indexed root,
80         uint256 previousConfirmAt,
81         uint256 newConfirmAt
82     );
83 
84     // ============ Constructor ============
85 
86     constructor(uint32 _localDomain) NomadBase(_localDomain) {}
87 
88     // ============ Initializer ============
89 
90     /**
91      * @notice Initialize the replica
92      * @dev Performs the following action:
93      *      - initializes inherited contracts
94      *      - initializes re-entrancy guard
95      *      - sets remote domain
96      *      - sets a trusted root, and pre-approves messages under it
97      *      - sets the optimistic timer
98      * @param _remoteDomain The domain of the Home contract this follows
99      * @param _updater The EVM id of the updater
100      * @param _committedRoot A trusted root from which to start the Replica
101      * @param _optimisticSeconds The time a new root must wait to be confirmed
102      */
103     function initialize(
104         uint32 _remoteDomain,
105         address _updater,
106         bytes32 _committedRoot,
107         uint256 _optimisticSeconds
108     ) public initializer {
109         __NomadBase_initialize(_updater);
110         // set storage variables
111         entered = 1;
112         remoteDomain = _remoteDomain;
113         committedRoot = _committedRoot;
114         // pre-approve the committed root.
115         if (_committedRoot != bytes32(0)) confirmAt[_committedRoot] = 1;
116         _setOptimisticTimeout(_optimisticSeconds);
117     }
118 
119     // ============ External Functions ============
120 
121     /**
122      * @notice Called by external agent. Submits the signed update's new root,
123      * marks root's allowable confirmation time, and emits an `Update` event.
124      * @dev Reverts if update doesn't build off latest committedRoot
125      * or if signature is invalid.
126      * @param _oldRoot Old merkle root
127      * @param _newRoot New merkle root
128      * @param _signature Updater's signature on `_oldRoot` and `_newRoot`
129      */
130     function update(
131         bytes32 _oldRoot,
132         bytes32 _newRoot,
133         bytes memory _signature
134     ) external {
135         // ensure that update is building off the last submitted root
136         require(_oldRoot == committedRoot, "not current update");
137         // validate updater signature
138         require(
139             _isUpdaterSignature(_oldRoot, _newRoot, _signature),
140             "!updater sig"
141         );
142         // Hook for future use
143         _beforeUpdate();
144         // set the new root's confirmation timer
145         confirmAt[_newRoot] = block.timestamp + optimisticSeconds;
146         // update committedRoot
147         committedRoot = _newRoot;
148         emit Update(remoteDomain, _oldRoot, _newRoot, _signature);
149     }
150 
151     /**
152      * @notice If necessary, attempts to prove the validity of provided
153      *         `_message`. If the message is successfully proven, then tries to
154      *         process the message
155      * @dev Reverts if `prove` call returns false
156      * @param _message A Nomad message coming from another chain :)
157      * @param _proof Merkle proof of inclusion for message's leaf (optional if
158      *        the message has already been proven).
159      * @param _index Index of leaf in home's merkle tree (optional if the
160      *        message has already been proven).
161      */
162     function proveAndProcess(
163         bytes memory _message,
164         bytes32[32] calldata _proof,
165         uint256 _index
166     ) external {
167         bytes32 _messageHash = keccak256(_message);
168         require(
169             acceptableRoot(messages[_messageHash]) ||
170                 prove(_messageHash, _proof, _index),
171             "!prove"
172         );
173         process(_message);
174     }
175 
176     /**
177      * @notice Given formatted message, attempts to dispatch
178      * message payload to end recipient.
179      * @dev Recipient must implement a `handle` method (refer to IMessageRecipient.sol)
180      * Reverts if formatted message's destination domain is not the Replica's domain,
181      * if message has not been proven,
182      * or if not enough gas is provided for the dispatch transaction.
183      * @param _message Formatted message
184      * @return _success TRUE iff dispatch transaction succeeded
185      */
186     function process(bytes memory _message) public returns (bool _success) {
187         // ensure message was meant for this domain
188         bytes29 _m = _message.ref(0);
189         require(_m.destination() == localDomain, "!destination");
190         // ensure message has been proven
191         bytes32 _messageHash = _m.keccak();
192         require(acceptableRoot(messages[_messageHash]), "!proven");
193         // check re-entrancy guard
194         require(entered == 1, "!reentrant");
195         entered = 0;
196         // update message status as processed
197         messages[_messageHash] = LEGACY_STATUS_PROCESSED;
198         // call handle function
199         IMessageRecipient(_m.recipientAddress()).handle(
200             _m.origin(),
201             _m.nonce(),
202             _m.sender(),
203             _m.body().clone()
204         );
205         // emit process results
206         emit Process(_messageHash, true, "");
207         // reset re-entrancy guard
208         entered = 1;
209         // return true
210         return true;
211     }
212 
213     // ============ External Owner Functions ============
214 
215     /**
216      * @notice Set optimistic timeout period for new roots
217      * @dev Only callable by owner (Governance)
218      * @param _optimisticSeconds New optimistic timeout period
219      */
220     function setOptimisticTimeout(uint256 _optimisticSeconds)
221         external
222         onlyOwner
223     {
224         _setOptimisticTimeout(_optimisticSeconds);
225     }
226 
227     /**
228      * @notice Set Updater role
229      * @dev MUST ensure that all roots signed by previous Updater have
230      * been relayed before calling. Only callable by owner (Governance)
231      * @param _updater New Updater
232      */
233     function setUpdater(address _updater) external onlyOwner {
234         _setUpdater(_updater);
235     }
236 
237     /**
238      * @notice Set confirmAt for a given root
239      * @dev To be used if in the case that fraud is proven
240      * and roots need to be deleted / added. Only callable by owner (Governance)
241      * @param _root The root for which to modify confirm time
242      * @param _confirmAt The new confirmation time. Set to 0 to "delete" a root.
243      */
244     function setConfirmation(bytes32 _root, uint256 _confirmAt)
245         external
246         onlyOwner
247     {
248         require(_root != bytes32(0) || _confirmAt == 0, "can't set zero root");
249         uint256 _previousConfirmAt = confirmAt[_root];
250         confirmAt[_root] = _confirmAt;
251         emit SetConfirmation(_root, _previousConfirmAt, _confirmAt);
252     }
253 
254     // ============ Public Functions ============
255 
256     /**
257      * @notice Check that the root has been submitted
258      * and that the optimistic timeout period has expired,
259      * meaning the root can be processed
260      * @param _root the Merkle root, submitted in an update, to check
261      * @return TRUE iff root has been submitted & timeout has expired
262      */
263     function acceptableRoot(bytes32 _root) public view returns (bool) {
264         // this is backwards-compatibility for messages proven/processed
265         // under previous versions
266         if (_root == LEGACY_STATUS_PROVEN) return true;
267         if (_root == LEGACY_STATUS_PROCESSED || _root == LEGACY_STATUS_NONE)
268             return false;
269 
270         uint256 _time = confirmAt[_root];
271         if (_time == 0) {
272             return false;
273         }
274         return block.timestamp >= _time;
275     }
276 
277     /**
278      * @notice Attempts to prove the validity of message given its leaf, the
279      * merkle proof of inclusion for the leaf, and the index of the leaf.
280      * @dev Reverts if message's MessageStatus != None (i.e. if message was
281      * already proven or processed)
282      * @dev For convenience, we allow proving against any previous root.
283      * This means that witnesses never need to be updated for the new root
284      * @param _leaf Leaf of message to prove
285      * @param _proof Merkle proof of inclusion for leaf
286      * @param _index Index of leaf in home's merkle tree
287      * @return Returns true if proof was valid and `prove` call succeeded
288      **/
289     function prove(
290         bytes32 _leaf,
291         bytes32[32] calldata _proof,
292         uint256 _index
293     ) public returns (bool) {
294         // ensure that message has not been processed
295         // Note that this allows re-proving under a new root.
296         require(
297             messages[_leaf] != LEGACY_STATUS_PROCESSED,
298             "already processed"
299         );
300         // calculate the expected root based on the proof
301         bytes32 _calculatedRoot = MerkleLib.branchRoot(_leaf, _proof, _index);
302         // if the root is valid, change status to Proven
303         if (acceptableRoot(_calculatedRoot)) {
304             messages[_leaf] = _calculatedRoot;
305             return true;
306         }
307         return false;
308     }
309 
310     /**
311      * @notice Hash of Home domain concatenated with "NOMAD"
312      */
313     function homeDomainHash() public view override returns (bytes32) {
314         return _homeDomainHash(remoteDomain);
315     }
316 
317     // ============ Internal Functions ============
318 
319     /**
320      * @notice Set optimistic timeout period for new roots
321      * @dev Called by owner (Governance) or at initialization
322      * @param _optimisticSeconds New optimistic timeout period
323      */
324     function _setOptimisticTimeout(uint256 _optimisticSeconds) internal {
325         // This allows us to initialize the value to be very low in test envs,
326         // but does not allow governance action to lower a production env below
327         // the safe value
328         uint256 _current = optimisticSeconds;
329         if (_current != 0 && _current > 1500)
330             require(_optimisticSeconds >= 1500, "optimistic timeout too low");
331         // ensure the optimistic timeout is less than 1 year
332         // (prevents overflow when adding block.timestamp)
333         require(_optimisticSeconds < 31536000, "optimistic timeout too high");
334         // set the optimistic timeout
335         optimisticSeconds = _optimisticSeconds;
336         emit SetOptimisticTimeout(_optimisticSeconds);
337     }
338 
339     /// @notice Hook for potential future use
340     // solhint-disable-next-line no-empty-blocks
341     function _beforeUpdate() internal {}
342 }
