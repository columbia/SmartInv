1 // SPDX-License-Identifier: MIT OR Apache-2.0
2 pragma solidity >=0.6.11;
3 
4 // ============ Internal Imports ============
5 import {Version0} from "./Version0.sol";
6 import {NomadBase} from "./NomadBase.sol";
7 import {QueueLib} from "../libs/Queue.sol";
8 import {MerkleLib} from "../libs/Merkle.sol";
9 import {Message} from "../libs/Message.sol";
10 import {MerkleTreeManager} from "./Merkle.sol";
11 import {QueueManager} from "./Queue.sol";
12 import {IUpdaterManager} from "../interfaces/IUpdaterManager.sol";
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
54      * @param leafIndex Index of message's leaf in merkle tree
55      * @param destinationAndNonce Destination and destination-specific
56      * nonce combined in single field ((destination << 32) & nonce)
57      * @param messageHash Hash of message; the leaf inserted to the Merkle tree for the message
58      * @param committedRoot the latest notarized root submitted in the last signed Update
59      * @param message Raw bytes of message
60      */
61     event Dispatch(
62         bytes32 indexed messageHash,
63         uint256 indexed leafIndex,
64         uint64 indexed destinationAndNonce,
65         bytes32 committedRoot,
66         bytes message
67     );
68 
69     /**
70      * @notice Emitted when proof of an improper update is submitted,
71      * which sets the contract to FAILED state
72      * @param oldRoot Old root of the improper update
73      * @param newRoot New root of the improper update
74      * @param signature Signature on `oldRoot` and `newRoot
75      */
76     event ImproperUpdate(bytes32 oldRoot, bytes32 newRoot, bytes signature);
77 
78     /**
79      * @notice Emitted when the Updater is slashed
80      * (should be paired with ImproperUpdater or DoubleUpdate event)
81      * @param updater The address of the updater
82      * @param reporter The address of the entity that reported the updater misbehavior
83      */
84     event UpdaterSlashed(address indexed updater, address indexed reporter);
85 
86     /**
87      * @notice Emitted when the UpdaterManager contract is changed
88      * @param updaterManager The address of the new updaterManager
89      */
90     event NewUpdaterManager(address updaterManager);
91 
92     // ============ Constructor ============
93 
94     constructor(uint32 _localDomain) NomadBase(_localDomain) {} // solhint-disable-line no-empty-blocks
95 
96     // ============ Initializer ============
97 
98     function initialize(IUpdaterManager _updaterManager) public initializer {
99         // initialize queue, set Updater Manager, and initialize
100         __QueueManager_initialize();
101         _setUpdaterManager(_updaterManager);
102         __NomadBase_initialize(updaterManager.updater());
103     }
104 
105     // ============ Modifiers ============
106 
107     /**
108      * @notice Ensures that function is called by the UpdaterManager contract
109      */
110     modifier onlyUpdaterManager() {
111         require(msg.sender == address(updaterManager), "!updaterManager");
112         _;
113     }
114 
115     // ============ External: Updater & UpdaterManager Configuration  ============
116 
117     /**
118      * @notice Set a new Updater
119      * @param _updater the new Updater
120      */
121     function setUpdater(address _updater) external onlyUpdaterManager {
122         _setUpdater(_updater);
123     }
124 
125     /**
126      * @notice Set a new UpdaterManager contract
127      * @dev Home(s) will initially be initialized using a trusted UpdaterManager contract;
128      * we will progressively decentralize by swapping the trusted contract with a new implementation
129      * that implements Updater bonding & slashing, and rules for Updater selection & rotation
130      * @param _updaterManager the new UpdaterManager contract
131      */
132     function setUpdaterManager(address _updaterManager) external onlyOwner {
133         _setUpdaterManager(IUpdaterManager(_updaterManager));
134     }
135 
136     // ============ External Functions  ============
137 
138     /**
139      * @notice Dispatch the message it to the destination domain & recipient
140      * @dev Format the message, insert its hash into Merkle tree,
141      * enqueue the new Merkle root, and emit `Dispatch` event with message information.
142      * @param _destinationDomain Domain of destination chain
143      * @param _recipientAddress Address of recipient on destination chain as bytes32
144      * @param _messageBody Raw bytes content of message
145      */
146     function dispatch(
147         uint32 _destinationDomain,
148         bytes32 _recipientAddress,
149         bytes memory _messageBody
150     ) external notFailed {
151         require(_messageBody.length <= MAX_MESSAGE_BODY_BYTES, "msg too long");
152         // get the next nonce for the destination domain, then increment it
153         uint32 _nonce = nonces[_destinationDomain];
154         nonces[_destinationDomain] = _nonce + 1;
155         // format the message into packed bytes
156         bytes memory _message = Message.formatMessage(
157             localDomain,
158             bytes32(uint256(uint160(msg.sender))),
159             _nonce,
160             _destinationDomain,
161             _recipientAddress,
162             _messageBody
163         );
164         // insert the hashed message into the Merkle tree
165         bytes32 _messageHash = keccak256(_message);
166         tree.insert(_messageHash);
167         // enqueue the new Merkle root after inserting the message
168         queue.enqueue(root());
169         // Emit Dispatch event with message information
170         // note: leafIndex is count() - 1 since new leaf has already been inserted
171         emit Dispatch(
172             _messageHash,
173             count() - 1,
174             _destinationAndNonce(_destinationDomain, _nonce),
175             committedRoot,
176             _message
177         );
178     }
179 
180     /**
181      * @notice Submit a signature from the Updater "notarizing" a root,
182      * which updates the Home contract's `committedRoot`,
183      * and publishes the signature which will be relayed to Replica contracts
184      * @dev emits Update event
185      * @dev If _newRoot is not contained in the queue,
186      * the Update is a fraudulent Improper Update, so
187      * the Updater is slashed & Home is set to FAILED state
188      * @param _committedRoot Current updated merkle root which the update is building off of
189      * @param _newRoot New merkle root to update the contract state to
190      * @param _signature Updater signature on `_committedRoot` and `_newRoot`
191      */
192     function update(
193         bytes32 _committedRoot,
194         bytes32 _newRoot,
195         bytes memory _signature
196     ) external notFailed {
197         // check that the update is not fraudulent;
198         // if fraud is detected, Updater is slashed & Home is set to FAILED state
199         if (improperUpdate(_committedRoot, _newRoot, _signature)) return;
200         // clear all of the intermediate roots contained in this update from the queue
201         while (true) {
202             bytes32 _next = queue.dequeue();
203             if (_next == _newRoot) break;
204         }
205         // update the Home state with the latest signed root & emit event
206         committedRoot = _newRoot;
207         emit Update(localDomain, _committedRoot, _newRoot, _signature);
208     }
209 
210     /**
211      * @notice Suggest an update for the Updater to sign and submit.
212      * @dev If queue is empty, null bytes returned for both
213      * (No update is necessary because no messages have been dispatched since the last update)
214      * @return _committedRoot Latest root signed by the Updater
215      * @return _new Latest enqueued Merkle root
216      */
217     function suggestUpdate()
218         external
219         view
220         returns (bytes32 _committedRoot, bytes32 _new)
221     {
222         if (queue.length() != 0) {
223             _committedRoot = committedRoot;
224             _new = queue.lastItem();
225         }
226     }
227 
228     // ============ Public Functions  ============
229 
230     /**
231      * @notice Hash of Home domain concatenated with "NOMAD"
232      */
233     function homeDomainHash() public view override returns (bytes32) {
234         return _homeDomainHash(localDomain);
235     }
236 
237     /**
238      * @notice Check if an Update is an Improper Update;
239      * if so, slash the Updater and set the contract to FAILED state.
240      *
241      * An Improper Update is an update building off of the Home's `committedRoot`
242      * for which the `_newRoot` does not currently exist in the Home's queue.
243      * This would mean that message(s) that were not truly
244      * dispatched on Home were falsely included in the signed root.
245      *
246      * An Improper Update will only be accepted as valid by the Replica
247      * If an Improper Update is attempted on Home,
248      * the Updater will be slashed immediately.
249      * If an Improper Update is submitted to the Replica,
250      * it should be relayed to the Home contract using this function
251      * in order to slash the Updater with an Improper Update.
252      *
253      * An Improper Update submitted to the Replica is only valid
254      * while the `_oldRoot` is still equal to the `committedRoot` on Home;
255      * if the `committedRoot` on Home has already been updated with a valid Update,
256      * then the Updater should be slashed with a Double Update.
257      * @dev Reverts (and doesn't slash updater) if signature is invalid or
258      * update not current
259      * @param _oldRoot Old merkle tree root (should equal home's committedRoot)
260      * @param _newRoot New merkle tree root
261      * @param _signature Updater signature on `_oldRoot` and `_newRoot`
262      * @return TRUE if update was an Improper Update (implying Updater was slashed)
263      */
264     function improperUpdate(
265         bytes32 _oldRoot,
266         bytes32 _newRoot,
267         bytes memory _signature
268     ) public notFailed returns (bool) {
269         require(
270             _isUpdaterSignature(_oldRoot, _newRoot, _signature),
271             "!updater sig"
272         );
273         require(_oldRoot == committedRoot, "not a current update");
274         // if the _newRoot is not currently contained in the queue,
275         // slash the Updater and set the contract to FAILED state
276         if (!queue.contains(_newRoot)) {
277             _fail();
278             emit ImproperUpdate(_oldRoot, _newRoot, _signature);
279             return true;
280         }
281         // if the _newRoot is contained in the queue,
282         // this is not an improper update
283         return false;
284     }
285 
286     // ============ Internal Functions  ============
287 
288     /**
289      * @notice Set the UpdaterManager
290      * @param _updaterManager Address of the UpdaterManager
291      */
292     function _setUpdaterManager(IUpdaterManager _updaterManager) internal {
293         require(
294             Address.isContract(address(_updaterManager)),
295             "!contract updaterManager"
296         );
297         updaterManager = IUpdaterManager(_updaterManager);
298         emit NewUpdaterManager(address(_updaterManager));
299     }
300 
301     /**
302      * @notice Slash the Updater and set contract state to FAILED
303      * @dev Called when fraud is proven (Improper Update or Double Update)
304      */
305     function _fail() internal override {
306         // set contract to FAILED
307         _setFailed();
308         // slash Updater
309         updaterManager.slashUpdater(msg.sender);
310         emit UpdaterSlashed(updater, msg.sender);
311     }
312 
313     /**
314      * @notice Internal utility function that combines
315      * `_destination` and `_nonce`.
316      * @dev Both destination and nonce should be less than 2^32 - 1
317      * @param _destination Domain of destination chain
318      * @param _nonce Current nonce for given destination chain
319      * @return Returns (`_destination` << 32) & `_nonce`
320      */
321     function _destinationAndNonce(uint32 _destination, uint32 _nonce)
322         internal
323         pure
324         returns (uint64)
325     {
326         return (uint64(_destination) << 32) | _nonce;
327     }
328 }
