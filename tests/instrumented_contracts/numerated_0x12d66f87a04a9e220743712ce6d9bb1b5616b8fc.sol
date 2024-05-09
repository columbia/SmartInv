1 // https://tornado.cash
2 /*
3 * d888888P                                           dP              a88888b.                   dP
4 *    88                                              88             d8'   `88                   88
5 *    88    .d8888b. 88d888b. 88d888b. .d8888b. .d888b88 .d8888b.    88        .d8888b. .d8888b. 88d888b.
6 *    88    88'  `88 88'  `88 88'  `88 88'  `88 88'  `88 88'  `88    88        88'  `88 Y8ooooo. 88'  `88
7 *    88    88.  .88 88       88    88 88.  .88 88.  .88 88.  .88 dP Y8.   .88 88.  .88       88 88    88
8 *    dP    `88888P' dP       dP    dP `88888P8 `88888P8 `88888P' 88  Y88888P' `88888P8 `88888P' dP    dP
9 * ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
10 */
11 
12 pragma solidity ^0.5.8;
13 
14 library Hasher {
15   function MiMCSponge(uint256 in_xL, uint256 in_xR) public pure returns (uint256 xL, uint256 xR);
16 }
17 
18 contract MerkleTreeWithHistory {
19   uint256 public constant FIELD_SIZE = 21888242871839275222246405745257275088548364400416034343698204186575808495617;
20   uint256 public constant ZERO_VALUE = 21663839004416932945382355908790599225266501822907911457504978515578255421292; // = keccak256("tornado") % FIELD_SIZE
21 
22   uint32 public levels;
23 
24   // the following variables are made public for easier testing and debugging and
25   // are not supposed to be accessed in regular code
26   bytes32[] public filledSubtrees;
27   bytes32[] public zeros;
28   uint32 public currentRootIndex = 0;
29   uint32 public nextIndex = 0;
30   uint32 public constant ROOT_HISTORY_SIZE = 100;
31   bytes32[ROOT_HISTORY_SIZE] public roots;
32 
33   constructor(uint32 _treeLevels) public {
34     require(_treeLevels > 0, "_treeLevels should be greater than zero");
35     require(_treeLevels < 32, "_treeLevels should be less than 32");
36     levels = _treeLevels;
37 
38     bytes32 currentZero = bytes32(ZERO_VALUE);
39     zeros.push(currentZero);
40     filledSubtrees.push(currentZero);
41 
42     for (uint32 i = 1; i < levels; i++) {
43       currentZero = hashLeftRight(currentZero, currentZero);
44       zeros.push(currentZero);
45       filledSubtrees.push(currentZero);
46     }
47 
48     roots[0] = hashLeftRight(currentZero, currentZero);
49   }
50 
51   /**
52     @dev Hash 2 tree leaves, returns MiMC(_left, _right)
53   */
54   function hashLeftRight(bytes32 _left, bytes32 _right) public pure returns (bytes32) {
55     require(uint256(_left) < FIELD_SIZE, "_left should be inside the field");
56     require(uint256(_right) < FIELD_SIZE, "_right should be inside the field");
57     uint256 R = uint256(_left);
58     uint256 C = 0;
59     (R, C) = Hasher.MiMCSponge(R, C);
60     R = addmod(R, uint256(_right), FIELD_SIZE);
61     (R, C) = Hasher.MiMCSponge(R, C);
62     return bytes32(R);
63   }
64 
65   function _insert(bytes32 _leaf) internal returns(uint32 index) {
66     uint32 currentIndex = nextIndex;
67     require(currentIndex != uint32(2)**levels, "Merkle tree is full. No more leafs can be added");
68     nextIndex += 1;
69     bytes32 currentLevelHash = _leaf;
70     bytes32 left;
71     bytes32 right;
72 
73     for (uint32 i = 0; i < levels; i++) {
74       if (currentIndex % 2 == 0) {
75         left = currentLevelHash;
76         right = zeros[i];
77 
78         filledSubtrees[i] = currentLevelHash;
79       } else {
80         left = filledSubtrees[i];
81         right = currentLevelHash;
82       }
83 
84       currentLevelHash = hashLeftRight(left, right);
85 
86       currentIndex /= 2;
87     }
88 
89     currentRootIndex = (currentRootIndex + 1) % ROOT_HISTORY_SIZE;
90     roots[currentRootIndex] = currentLevelHash;
91     return nextIndex - 1;
92   }
93 
94   /**
95     @dev Whether the root is present in the root history
96   */
97   function isKnownRoot(bytes32 _root) public view returns(bool) {
98     if (_root == 0) {
99       return false;
100     }
101     uint32 i = currentRootIndex;
102     do {
103       if (_root == roots[i]) {
104         return true;
105       }
106       if (i == 0) {
107         i = ROOT_HISTORY_SIZE;
108       }
109       i--;
110     } while (i != currentRootIndex);
111     return false;
112   }
113 
114   /**
115     @dev Returns the last root
116   */
117   function getLastRoot() public view returns(bytes32) {
118     return roots[currentRootIndex];
119   }
120 }
121 
122 // File: @openzeppelin/contracts/utils/ReentrancyGuard.sol
123 
124 pragma solidity ^0.5.0;
125 
126 /**
127  * @dev Contract module that helps prevent reentrant calls to a function.
128  *
129  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
130  * available, which can be applied to functions to make sure there are no nested
131  * (reentrant) calls to them.
132  *
133  * Note that because there is a single `nonReentrant` guard, functions marked as
134  * `nonReentrant` may not call one another. This can be worked around by making
135  * those functions `private`, and then adding `external` `nonReentrant` entry
136  * points to them.
137  */
138 contract ReentrancyGuard {
139     // counter to allow mutex lock with only one SSTORE operation
140     uint256 private _guardCounter;
141 
142     constructor () internal {
143         // The counter starts at one to prevent changing it from zero to a non-zero
144         // value, which is a more expensive operation.
145         _guardCounter = 1;
146     }
147 
148     /**
149      * @dev Prevents a contract from calling itself, directly or indirectly.
150      * Calling a `nonReentrant` function from another `nonReentrant`
151      * function is not supported. It is possible to prevent this from happening
152      * by making the `nonReentrant` function external, and make it call a
153      * `private` function that does the actual work.
154      */
155     modifier nonReentrant() {
156         _guardCounter += 1;
157         uint256 localCounter = _guardCounter;
158         _;
159         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
160     }
161 }
162 
163 // File: contracts/Tornado.sol
164 
165 // https://tornado.cash
166 /*
167 * d888888P                                           dP              a88888b.                   dP
168 *    88                                              88             d8'   `88                   88
169 *    88    .d8888b. 88d888b. 88d888b. .d8888b. .d888b88 .d8888b.    88        .d8888b. .d8888b. 88d888b.
170 *    88    88'  `88 88'  `88 88'  `88 88'  `88 88'  `88 88'  `88    88        88'  `88 Y8ooooo. 88'  `88
171 *    88    88.  .88 88       88    88 88.  .88 88.  .88 88.  .88 dP Y8.   .88 88.  .88       88 88    88
172 *    dP    `88888P' dP       dP    dP `88888P8 `88888P8 `88888P' 88  Y88888P' `88888P8 `88888P' dP    dP
173 * ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
174 */
175 
176 pragma solidity ^0.5.8;
177 
178 
179 
180 contract IVerifier {
181   function verifyProof(bytes memory _proof, uint256[6] memory _input) public returns(bool);
182 }
183 
184 contract Tornado is MerkleTreeWithHistory, ReentrancyGuard {
185   uint256 public denomination;
186   mapping(bytes32 => bool) public nullifierHashes;
187   // we store all commitments just to prevent accidental deposits with the same commitment
188   mapping(bytes32 => bool) public commitments;
189   IVerifier public verifier;
190 
191   // operator can update snark verification key
192   // after the final trusted setup ceremony operator rights are supposed to be transferred to zero address
193   address public operator;
194   modifier onlyOperator {
195     require(msg.sender == operator, "Only operator can call this function.");
196     _;
197   }
198 
199   event Deposit(bytes32 indexed commitment, uint32 leafIndex, uint256 timestamp);
200   event Withdrawal(address to, bytes32 nullifierHash, address indexed relayer, uint256 fee);
201 
202   /**
203     @dev The constructor
204     @param _verifier the address of SNARK verifier for this contract
205     @param _denomination transfer amount for each deposit
206     @param _merkleTreeHeight the height of deposits' Merkle Tree
207     @param _operator operator address (see operator comment above)
208   */
209   constructor(
210     IVerifier _verifier,
211     uint256 _denomination,
212     uint32 _merkleTreeHeight,
213     address _operator
214   ) MerkleTreeWithHistory(_merkleTreeHeight) public {
215     require(_denomination > 0, "denomination should be greater than 0");
216     verifier = _verifier;
217     operator = _operator;
218     denomination = _denomination;
219   }
220 
221   /**
222     @dev Deposit funds into the contract. The caller must send (for ETH) or approve (for ERC20) value equal to or `denomination` of this instance.
223     @param _commitment the note commitment, which is PedersenHash(nullifier + secret)
224   */
225   function deposit(bytes32 _commitment) external payable nonReentrant {
226     require(!commitments[_commitment], "The commitment has been submitted");
227 
228     uint32 insertedIndex = _insert(_commitment);
229     commitments[_commitment] = true;
230     _processDeposit();
231 
232     emit Deposit(_commitment, insertedIndex, block.timestamp);
233   }
234 
235   /** @dev this function is defined in a child contract */
236   function _processDeposit() internal;
237 
238   /**
239     @dev Withdraw a deposit from the contract. `proof` is a zkSNARK proof data, and input is an array of circuit public inputs
240     `input` array consists of:
241       - merkle root of all deposits in the contract
242       - hash of unique deposit nullifier to prevent double spends
243       - the recipient of funds
244       - optional fee that goes to the transaction sender (usually a relay)
245   */
246   function withdraw(bytes calldata _proof, bytes32 _root, bytes32 _nullifierHash, address payable _recipient, address payable _relayer, uint256 _fee, uint256 _refund) external payable nonReentrant {
247     require(_fee <= denomination, "Fee exceeds transfer value");
248     require(!nullifierHashes[_nullifierHash], "The note has been already spent");
249     require(isKnownRoot(_root), "Cannot find your merkle root"); // Make sure to use a recent one
250     require(verifier.verifyProof(_proof, [uint256(_root), uint256(_nullifierHash), uint256(_recipient), uint256(_relayer), _fee, _refund]), "Invalid withdraw proof");
251 
252     nullifierHashes[_nullifierHash] = true;
253     _processWithdraw(_recipient, _relayer, _fee, _refund);
254     emit Withdrawal(_recipient, _nullifierHash, _relayer, _fee);
255   }
256 
257   /** @dev this function is defined in a child contract */
258   function _processWithdraw(address payable _recipient, address payable _relayer, uint256 _fee, uint256 _refund) internal;
259 
260   /** @dev whether a note is already spent */
261   function isSpent(bytes32 _nullifierHash) public view returns(bool) {
262     return nullifierHashes[_nullifierHash];
263   }
264 
265   /** @dev whether an array of notes is already spent */
266   function isSpentArray(bytes32[] calldata _nullifierHashes) external view returns(bool[] memory spent) {
267     spent = new bool[](_nullifierHashes.length);
268     for(uint i = 0; i < _nullifierHashes.length; i++) {
269       if (isSpent(_nullifierHashes[i])) {
270         spent[i] = true;
271       }
272     }
273   }
274 
275   /**
276     @dev allow operator to update SNARK verification keys. This is needed to update keys after the final trusted setup ceremony is held.
277     After that operator rights are supposed to be transferred to zero address
278   */
279   function updateVerifier(address _newVerifier) external onlyOperator {
280     verifier = IVerifier(_newVerifier);
281   }
282 
283   /** @dev operator can change his address */
284   function changeOperator(address _newOperator) external onlyOperator {
285     operator = _newOperator;
286   }
287 }
288 
289 // File: contracts/ETHTornado.sol
290 
291 // https://tornado.cash
292 /*
293 * d888888P                                           dP              a88888b.                   dP
294 *    88                                              88             d8'   `88                   88
295 *    88    .d8888b. 88d888b. 88d888b. .d8888b. .d888b88 .d8888b.    88        .d8888b. .d8888b. 88d888b.
296 *    88    88'  `88 88'  `88 88'  `88 88'  `88 88'  `88 88'  `88    88        88'  `88 Y8ooooo. 88'  `88
297 *    88    88.  .88 88       88    88 88.  .88 88.  .88 88.  .88 dP Y8.   .88 88.  .88       88 88    88
298 *    dP    `88888P' dP       dP    dP `88888P8 `88888P8 `88888P' 88  Y88888P' `88888P8 `88888P' dP    dP
299 * ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
300 */
301 
302 pragma solidity ^0.5.8;
303 
304 
305 contract ETHTornado is Tornado {
306   constructor(
307     IVerifier _verifier,
308     uint256 _denomination,
309     uint32 _merkleTreeHeight,
310     address _operator
311   ) Tornado(_verifier, _denomination, _merkleTreeHeight, _operator) public {
312   }
313 
314   function _processDeposit() internal {
315     require(msg.value == denomination, "Please send `mixDenomination` ETH along with transaction");
316   }
317 
318   function _processWithdraw(address payable _recipient, address payable _relayer, uint256 _fee, uint256 _refund) internal {
319     // sanity checks
320     require(msg.value == 0, "Message value is supposed to be zero for ETH instance");
321     require(_refund == 0, "Refund value is supposed to be zero for ETH instance");
322 
323     (bool success, ) = _recipient.call.value(denomination - _fee)("");
324     require(success, "payment to _recipient did not go thru");
325     if (_fee > 0) {
326       (success, ) = _relayer.call.value(_fee)("");
327       require(success, "payment to _relayer did not go thru");
328     }
329   }
330 }
331 
332 // File: contracts/MigratableETHTornado.sol
333 
334 pragma solidity ^0.5.8;
335 
336 
337 contract TornadoCash_Eth_01 is ETHTornado {
338   bool public isMigrated = false;
339 
340   constructor(
341     IVerifier _verifier,
342     uint256 _denomination,
343     uint32 _merkleTreeHeight,
344     address _operator
345   ) ETHTornado(_verifier, _denomination, _merkleTreeHeight, _operator) public {
346   }
347 
348   /**
349     @dev Migrate state from old v1 tornado.cash instance to this contract.
350     @dev only applies to eth 0.1 deposits
351     @param _commitments deposited commitments from previous contract
352     @param _nullifierHashes spent nullifiers from previous contract
353   */
354   function migrateState(bytes32[] calldata _commitments, bytes32[] calldata _nullifierHashes) external onlyOperator {
355     require(!isMigrated, "Migration is disabled");
356     for (uint32 i = 0; i < _commitments.length; i++) {
357       commitments[_commitments[i]] = true;
358       emit Deposit(_commitments[i], nextIndex + i, block.timestamp);
359     }
360 
361     nextIndex += uint32(_commitments.length);
362 
363     for (uint256 i = 0; i < _nullifierHashes.length; i++) {
364       nullifierHashes[_nullifierHashes[i]] = true;
365       emit Withdrawal(address(0), _nullifierHashes[i], address(0), 0);
366     }
367   }
368 
369   function initializeTreeForMigration(bytes32[] calldata _filledSubtrees, bytes32 _root) external onlyOperator {
370     require(!isMigrated, "already migrated");
371     filledSubtrees = _filledSubtrees;
372     roots[0] = _root;
373   }
374 
375   function finishMigration() external payable onlyOperator {
376     isMigrated = true;
377   }
378 }