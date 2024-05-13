1 // SPDX-License-Identifier: MIT OR Apache-2.0
2 pragma solidity 0.7.6;
3 
4 // ============ Internal Imports ============
5 import {Version0} from "./Version0.sol";
6 import {NomadBase} from "./NomadBase.sol";
7 import {QueueLib} from "./libs/Queue.sol";
8 import {MerkleLib} from "./libs/Merkle.sol";
9 import {Message} from "./libs/Message.sol";
10 import {MerkleTreeManager} from "./Merkle.sol";
11 import {QueueManager} from "./Queue.sol";
12 import {IUpdaterManager} from "./interfaces/IUpdaterManager.sol";
13 // ============ External Imports ============
14 import {Address} from "@openzeppelin/contracts/utils/Address.sol";
15 
16 /**
17  * @title Home
18  * @author Illusory Systems Inc.
19  * @notice Accepts messages to be dispatched to remote chains,
20  * constructs a Merkle tree of the messages,
21  * and accepts signatures from a bonded Updater
22  * which notarize the Merkle tree roots.
23  * Accepts submissions of fraudulent signatures
24  * by the Updater and slashes the Updater in this case.
25  */
26 contract Home is Version0, QueueManager, MerkleTreeManager, NomadBase {
27     // ============ Libraries ============
28 
29     using QueueLib for QueueLib.Queue;
30     using MerkleLib for MerkleLib.Tree;
31 
32     // ============ Constants ============
33 
34     // Maximum bytes per message = 2 KiB
35     // (somewhat arbitrarily set to begin)
36     uint256 public constant MAX_MESSAGE_BODY_BYTES = 2 * 2**10;
37 
38     // ============ Public Storage Variables ============
39 
40     // domain => next available nonce for the domain
41     mapping(uint32 => uint32) public nonces;
42     // contract responsible for Updater bonding, slashing and rotation
43     IUpdaterManager public updaterManager;
44 
45     // ============ Upgrade Gap ============
46 
47     // gap for upgrade safety
48     uint256[48] private __GAP;
49 
50     // ============ Events ============
51 
52     /**
53      * @notice Emitted when a new message is dispatched via Nomad
54      * @param messageHash Hash of message; the leaf inserted to the Merkle tree
55      *        for the message
56      * @param leafIndex Index of message's leaf in merkle tree
57      * @param destinationAndNonce Destination and destination-specific
58      *        nonce combined in single field ((destination << 32) & nonce)
59      * @param committedRoot the latest notarized root submitted in the last
60      *        signed Update
61      * @param message Raw bytes of message
62      */
63     event Dispatch(
64         bytes32 indexed messageHash,
65         uint256 indexed leafIndex,
66         uint64 indexed destinationAndNonce,
67         bytes32 committedRoot,
68         bytes message
69     );
70 
71     /**
72      * @notice Emitted when proof of an improper update is submitted,
73      * which sets the contract to FAILED state
74      * @param oldRoot Old root of the improper update
75      * @param newRoot New root of the improper update
76      * @param signature Signature on `oldRoot` and `newRoot
77      */
78     event ImproperUpdate(bytes32 oldRoot, bytes32 newRoot, bytes signature);
79 
80     /**
81      * @notice Emitted when proof of a double update is submitted,
82      * which sets the contract to FAILED state
83      * @param oldRoot Old root shared between two conflicting updates
84      * @param newRoot Array containing two conflicting new roots
85      * @param signature Signature on `oldRoot` and `newRoot`[0]
86      * @param signature2 Signature on `oldRoot` and `newRoot`[1]
87      */
88     event DoubleUpdate(
89         bytes32 oldRoot,
90         bytes32[2] newRoot,
91         bytes signature,
92         bytes signature2
93     );
94 
95     /**
96      * @notice Emitted when the Updater is slashed
97      * (should be paired with ImproperUpdater or DoubleUpdate event)
98      * @param updater The address of the updater
99      * @param reporter The address of the entity that reported the updater misbehavior
100      */
101     event UpdaterSlashed(address indexed updater, address indexed reporter);
102 
103     /**
104      * @notice Emitted when the UpdaterManager contract is changed
105      * @param updaterManager The address of the new updaterManager
106      */
107     event NewUpdaterManager(address updaterManager);
108 
109     // ============ Constructor ============
110 
111     constructor(uint32 _localDomain) NomadBase(_localDomain) {} // solhint-disable-line no-empty-blocks
112 
113     // ============ Initializer ============
114 
115     function initialize(IUpdaterManager _updaterManager) public initializer {
116         // initialize queue, set Updater Manager, and initialize
117         __QueueManager_initialize();
118         _setUpdaterManager(_updaterManager);
119         __NomadBase_initialize(updaterManager.updater());
120     }
121 
122     // ============ Modifiers ============
123 
124     /**
125      * @notice Ensures that function is called by the UpdaterManager contract
126      */
127     modifier onlyUpdaterManager() {
128         require(msg.sender == address(updaterManager), "!updaterManager");
129         _;
130     }
131 
132     /**
133      * @notice Ensures that contract state != FAILED when the function is called
134      */
135     modifier notFailed() {
136         require(state != States.Failed, "failed state");
137         _;
138     }
139 
140     // ============ External: Updater & UpdaterManager Configuration  ============
141 
142     /**
143      * @notice Set a new Updater
144      * @dev To be set when rotating Updater after Fraud
145      * @param _updater the new Updater
146      */
147     function setUpdater(address _updater) external onlyUpdaterManager {
148         _setUpdater(_updater);
149         // set the Home state to Active
150         // now that Updater has been rotated
151         state = States.Active;
152     }
153 
154     /**
155      * @notice Set a new UpdaterManager contract
156      * @dev Home(s) will initially be initialized using a trusted UpdaterManager contract;
157      * we will progressively decentralize by swapping the trusted contract with a new implementation
158      * that implements Updater bonding & slashing, and rules for Updater selection & rotation
159      * @param _updaterManager the new UpdaterManager contract
160      */
161     function setUpdaterManager(address _updaterManager) external onlyOwner {
162         _setUpdaterManager(IUpdaterManager(_updaterManager));
163         _setUpdater(IUpdaterManager(_updaterManager).updater());
164     }
165 
166     // ============ External Functions  ============
167 
168     /**
169      * @notice Dispatch the message to the destination domain & recipient
170      * @dev Format the message, insert its hash into Merkle tree,
171      * enqueue the new Merkle root, and emit `Dispatch` event with message information.
172      * @param _destinationDomain Domain of destination chain
173      * @param _recipientAddress Address of recipient on destination chain as bytes32
174      * @param _messageBody Raw bytes content of message
175      */
176     function dispatch(
177         uint32 _destinationDomain,
178         bytes32 _recipientAddress,
179         bytes memory _messageBody
180     ) external notFailed {
181         require(_messageBody.length <= MAX_MESSAGE_BODY_BYTES, "msg too long");
182         // get the next nonce for the destination domain, then increment it
183         uint32 _nonce = nonces[_destinationDomain];
184         nonces[_destinationDomain] = _nonce + 1;
185         // format the message into packed bytes
186         bytes memory _message = Message.formatMessage(
187             localDomain,
188             bytes32(uint256(uint160(msg.sender))),
189             _nonce,
190             _destinationDomain,
191             _recipientAddress,
192             _messageBody
193         );
194         // insert the hashed message into the Merkle tree
195         bytes32 _messageHash = keccak256(_message);
196         tree.insert(_messageHash);
197         // enqueue the new Merkle root after inserting the message
198         queue.enqueue(root());
199         // Emit Dispatch event with message information
200         // note: leafIndex is count() - 1 since new leaf has already been inserted
201         emit Dispatch(
202             _messageHash,
203             count() - 1,
204             _destinationAndNonce(_destinationDomain, _nonce),
205             committedRoot,
206             _message
207         );
208     }
209 
210     /**
211      * @notice Submit a signature from the Updater "notarizing" a root,
212      * which updates the Home contract's `committedRoot`,
213      * and publishes the signature which will be relayed to Replica contracts
214      * @dev emits Update event
215      * @dev If _newRoot is not contained in the queue,
216      * the Update is a fraudulent Improper Update, so
217      * the Updater is slashed & Home is set to FAILED state
218      * @param _committedRoot Current updated merkle root which the update is building off of
219      * @param _newRoot New merkle root to update the contract state to
220      * @param _signature Updater signature on `_committedRoot` and `_newRoot`
221      */
222     function update(
223         bytes32 _committedRoot,
224         bytes32 _newRoot,
225         bytes memory _signature
226     ) external notFailed {
227         // check that the update is not fraudulent;
228         // if fraud is detected, Updater is slashed & Home is set to FAILED state
229         if (improperUpdate(_committedRoot, _newRoot, _signature)) return;
230         // clear all of the intermediate roots contained in this update from the queue
231         while (true) {
232             bytes32 _next = queue.dequeue();
233             if (_next == _newRoot) break;
234         }
235         // update the Home state with the latest signed root & emit event
236         committedRoot = _newRoot;
237         emit Update(localDomain, _committedRoot, _newRoot, _signature);
238     }
239 
240     /**
241      * @notice Suggest an update for the Updater to sign and submit.
242      * @dev If queue is empty, null bytes returned for both
243      * (No update is necessary because no messages have been dispatched since the last update)
244      * @return _committedRoot Latest root signed by the Updater
245      * @return _new Latest enqueued Merkle root
246      */
247     function suggestUpdate()
248         external
249         view
250         returns (bytes32 _committedRoot, bytes32 _new)
251     {
252         if (queue.length() != 0) {
253             _committedRoot = committedRoot;
254             _new = queue.lastItem();
255         }
256     }
257 
258     /**
259      * @notice Called by external agent. Checks that signatures on two sets of
260      * roots are valid and that the new roots conflict with each other. If both
261      * cases hold true, the contract is failed and a `DoubleUpdate` event is
262      * emitted.
263      * @dev When `fail()` is called on Home, updater is slashed.
264      * @param _oldRoot Old root shared between two conflicting updates
265      * @param _newRoot Array containing two conflicting new roots
266      * @param _signature Signature on `_oldRoot` and `_newRoot`[0]
267      * @param _signature2 Signature on `_oldRoot` and `_newRoot`[1]
268      */
269     function doubleUpdate(
270         bytes32 _oldRoot,
271         bytes32[2] calldata _newRoot,
272         bytes calldata _signature,
273         bytes calldata _signature2
274     ) external notFailed {
275         if (
276             NomadBase._isUpdaterSignature(_oldRoot, _newRoot[0], _signature) &&
277             NomadBase._isUpdaterSignature(_oldRoot, _newRoot[1], _signature2) &&
278             _newRoot[0] != _newRoot[1]
279         ) {
280             _fail();
281             emit DoubleUpdate(_oldRoot, _newRoot, _signature, _signature2);
282         }
283     }
284 
285     // ============ Public Functions  ============
286 
287     /**
288      * @notice Hash of Home domain concatenated with "NOMAD"
289      */
290     function homeDomainHash() public view override returns (bytes32) {
291         return _homeDomainHash(localDomain);
292     }
293 
294     /**
295      * @notice Check if an Update is an Improper Update;
296      * if so, slash the Updater and set the contract to FAILED state.
297      *
298      * An Improper Update is an update building off of the Home's `committedRoot`
299      * for which the `_newRoot` does not currently exist in the Home's queue.
300      * This would mean that message(s) that were not truly
301      * dispatched on Home were falsely included in the signed root.
302      *
303      * An Improper Update will only be accepted as valid by the Replica
304      * If an Improper Update is attempted on Home,
305      * the Updater will be slashed immediately.
306      * If an Improper Update is submitted to the Replica,
307      * it should be relayed to the Home contract using this function
308      * in order to slash the Updater with an Improper Update.
309      *
310      * An Improper Update submitted to the Replica is only valid
311      * while the `_oldRoot` is still equal to the `committedRoot` on Home;
312      * if the `committedRoot` on Home has already been updated with a valid Update,
313      * then the Updater should be slashed with a Double Update.
314      * @dev Reverts (and doesn't slash updater) if signature is invalid or
315      * update not current
316      * @param _oldRoot Old merkle tree root (should equal home's committedRoot)
317      * @param _newRoot New merkle tree root
318      * @param _signature Updater signature on `_oldRoot` and `_newRoot`
319      * @return TRUE if update was an Improper Update (implying Updater was slashed)
320      */
321     function improperUpdate(
322         bytes32 _oldRoot,
323         bytes32 _newRoot,
324         bytes memory _signature
325     ) public notFailed returns (bool) {
326         require(
327             _isUpdaterSignature(_oldRoot, _newRoot, _signature),
328             "!updater sig"
329         );
330         require(_oldRoot == committedRoot, "not a current update");
331         // if the _newRoot is not currently contained in the queue,
332         // slash the Updater and set the contract to FAILED state
333         if (!queue.contains(_newRoot)) {
334             _fail();
335             emit ImproperUpdate(_oldRoot, _newRoot, _signature);
336             return true;
337         }
338         // if the _newRoot is contained in the queue,
339         // this is not an improper update
340         return false;
341     }
342 
343     // ============ Internal Functions  ============
344 
345     /**
346      * @notice Set the UpdaterManager
347      * @param _updaterManager Address of the UpdaterManager
348      */
349     function _setUpdaterManager(IUpdaterManager _updaterManager) internal {
350         require(
351             Address.isContract(address(_updaterManager)),
352             "!contract updaterManager"
353         );
354         updaterManager = IUpdaterManager(_updaterManager);
355         emit NewUpdaterManager(address(_updaterManager));
356     }
357 
358     /**
359      * @notice Slash the Updater and set contract state to FAILED
360      * @dev Called when fraud is proven (Improper Update or Double Update)
361      */
362     function _fail() internal {
363         // set contract to FAILED
364         state = States.Failed;
365         // slash Updater
366         updaterManager.slashUpdater(msg.sender);
367         emit UpdaterSlashed(updater, msg.sender);
368     }
369 
370     /**
371      * @notice Internal utility function that combines
372      * `_destination` and `_nonce`.
373      * @dev Both destination and nonce should be less than 2^32 - 1
374      * @param _destination Domain of destination chain
375      * @param _nonce Current nonce for given destination chain
376      * @return Returns (`_destination` << 32) & `_nonce`
377      */
378     function _destinationAndNonce(uint32 _destination, uint32 _nonce)
379         internal
380         pure
381         returns (uint64)
382     {
383         return (uint64(_destination) << 32) | _nonce;
384     }
385 }
