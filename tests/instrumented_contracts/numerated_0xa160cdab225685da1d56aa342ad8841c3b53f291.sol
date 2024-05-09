1 // File: contracts/MerkleTreeWithHistory.sol
2 
3 // https://tornado.cash
4 /*
5 * d888888P                                           dP              a88888b.                   dP
6 *    88                                              88             d8'   `88                   88
7 *    88    .d8888b. 88d888b. 88d888b. .d8888b. .d888b88 .d8888b.    88        .d8888b. .d8888b. 88d888b.
8 *    88    88'  `88 88'  `88 88'  `88 88'  `88 88'  `88 88'  `88    88        88'  `88 Y8ooooo. 88'  `88
9 *    88    88.  .88 88       88    88 88.  .88 88.  .88 88.  .88 dP Y8.   .88 88.  .88       88 88    88
10 *    dP    `88888P' dP       dP    dP `88888P8 `88888P8 `88888P' 88  Y88888P' `88888P8 `88888P' dP    dP
11 * ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
12 */
13 
14 pragma solidity ^0.5.8;
15 
16 library Hasher {
17   function MiMCSponge(uint256 in_xL, uint256 in_xR) public pure returns (uint256 xL, uint256 xR);
18 }
19 
20 contract MerkleTreeWithHistory {
21   uint256 public constant FIELD_SIZE = 21888242871839275222246405745257275088548364400416034343698204186575808495617;
22   uint256 public constant ZERO_VALUE = 21663839004416932945382355908790599225266501822907911457504978515578255421292; // = keccak256("tornado") % FIELD_SIZE
23 
24   uint32 public levels;
25 
26   // the following variables are made public for easier testing and debugging and
27   // are not supposed to be accessed in regular code
28   bytes32[] public filledSubtrees;
29   bytes32[] public zeros;
30   uint32 public currentRootIndex = 0;
31   uint32 public nextIndex = 0;
32   uint32 public constant ROOT_HISTORY_SIZE = 100;
33   bytes32[ROOT_HISTORY_SIZE] public roots;
34 
35   constructor(uint32 _treeLevels) public {
36     require(_treeLevels > 0, "_treeLevels should be greater than zero");
37     require(_treeLevels < 32, "_treeLevels should be less than 32");
38     levels = _treeLevels;
39 
40     bytes32 currentZero = bytes32(ZERO_VALUE);
41     zeros.push(currentZero);
42     filledSubtrees.push(currentZero);
43 
44     for (uint32 i = 1; i < levels; i++) {
45       currentZero = hashLeftRight(currentZero, currentZero);
46       zeros.push(currentZero);
47       filledSubtrees.push(currentZero);
48     }
49 
50     roots[0] = hashLeftRight(currentZero, currentZero);
51   }
52 
53   /**
54     @dev Hash 2 tree leaves, returns MiMC(_left, _right)
55   */
56   function hashLeftRight(bytes32 _left, bytes32 _right) public pure returns (bytes32) {
57     require(uint256(_left) < FIELD_SIZE, "_left should be inside the field");
58     require(uint256(_right) < FIELD_SIZE, "_right should be inside the field");
59     uint256 R = uint256(_left);
60     uint256 C = 0;
61     (R, C) = Hasher.MiMCSponge(R, C);
62     R = addmod(R, uint256(_right), FIELD_SIZE);
63     (R, C) = Hasher.MiMCSponge(R, C);
64     return bytes32(R);
65   }
66 
67   function _insert(bytes32 _leaf) internal returns(uint32 index) {
68     uint32 currentIndex = nextIndex;
69     require(currentIndex != uint32(2)**levels, "Merkle tree is full. No more leafs can be added");
70     nextIndex += 1;
71     bytes32 currentLevelHash = _leaf;
72     bytes32 left;
73     bytes32 right;
74 
75     for (uint32 i = 0; i < levels; i++) {
76       if (currentIndex % 2 == 0) {
77         left = currentLevelHash;
78         right = zeros[i];
79 
80         filledSubtrees[i] = currentLevelHash;
81       } else {
82         left = filledSubtrees[i];
83         right = currentLevelHash;
84       }
85 
86       currentLevelHash = hashLeftRight(left, right);
87 
88       currentIndex /= 2;
89     }
90 
91     currentRootIndex = (currentRootIndex + 1) % ROOT_HISTORY_SIZE;
92     roots[currentRootIndex] = currentLevelHash;
93     return nextIndex - 1;
94   }
95 
96   /**
97     @dev Whether the root is present in the root history
98   */
99   function isKnownRoot(bytes32 _root) public view returns(bool) {
100     if (_root == 0) {
101       return false;
102     }
103     uint32 i = currentRootIndex;
104     do {
105       if (_root == roots[i]) {
106         return true;
107       }
108       if (i == 0) {
109         i = ROOT_HISTORY_SIZE;
110       }
111       i--;
112     } while (i != currentRootIndex);
113     return false;
114   }
115 
116   /**
117     @dev Returns the last root
118   */
119   function getLastRoot() public view returns(bytes32) {
120     return roots[currentRootIndex];
121   }
122 }
123 
124 // File: @openzeppelin/contracts/utils/ReentrancyGuard.sol
125 
126 pragma solidity ^0.5.0;
127 
128 /**
129  * @dev Contract module that helps prevent reentrant calls to a function.
130  *
131  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
132  * available, which can be applied to functions to make sure there are no nested
133  * (reentrant) calls to them.
134  *
135  * Note that because there is a single `nonReentrant` guard, functions marked as
136  * `nonReentrant` may not call one another. This can be worked around by making
137  * those functions `private`, and then adding `external` `nonReentrant` entry
138  * points to them.
139  */
140 contract ReentrancyGuard {
141     // counter to allow mutex lock with only one SSTORE operation
142     uint256 private _guardCounter;
143 
144     constructor () internal {
145         // The counter starts at one to prevent changing it from zero to a non-zero
146         // value, which is a more expensive operation.
147         _guardCounter = 1;
148     }
149 
150     /**
151      * @dev Prevents a contract from calling itself, directly or indirectly.
152      * Calling a `nonReentrant` function from another `nonReentrant`
153      * function is not supported. It is possible to prevent this from happening
154      * by making the `nonReentrant` function external, and make it call a
155      * `private` function that does the actual work.
156      */
157     modifier nonReentrant() {
158         _guardCounter += 1;
159         uint256 localCounter = _guardCounter;
160         _;
161         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
162     }
163 }
164 
165 // File: contracts/Tornado.sol
166 
167 // https://tornado.cash
168 /*
169 * d888888P                                           dP              a88888b.                   dP
170 *    88                                              88             d8'   `88                   88
171 *    88    .d8888b. 88d888b. 88d888b. .d8888b. .d888b88 .d8888b.    88        .d8888b. .d8888b. 88d888b.
172 *    88    88'  `88 88'  `88 88'  `88 88'  `88 88'  `88 88'  `88    88        88'  `88 Y8ooooo. 88'  `88
173 *    88    88.  .88 88       88    88 88.  .88 88.  .88 88.  .88 dP Y8.   .88 88.  .88       88 88    88
174 *    dP    `88888P' dP       dP    dP `88888P8 `88888P8 `88888P' 88  Y88888P' `88888P8 `88888P' dP    dP
175 * ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
176 */
177 
178 pragma solidity ^0.5.8;
179 
180 
181 
182 contract IVerifier {
183   function verifyProof(bytes memory _proof, uint256[6] memory _input) public returns(bool);
184 }
185 
186 contract Tornado is MerkleTreeWithHistory, ReentrancyGuard {
187   uint256 public denomination;
188   mapping(bytes32 => bool) public nullifierHashes;
189   // we store all commitments just to prevent accidental deposits with the same commitment
190   mapping(bytes32 => bool) public commitments;
191   IVerifier public verifier;
192 
193   // operator can update snark verification key
194   // after the final trusted setup ceremony operator rights are supposed to be transferred to zero address
195   address public operator;
196   modifier onlyOperator {
197     require(msg.sender == operator, "Only operator can call this function.");
198     _;
199   }
200 
201   event Deposit(bytes32 indexed commitment, uint32 leafIndex, uint256 timestamp);
202   event Withdrawal(address to, bytes32 nullifierHash, address indexed relayer, uint256 fee);
203 
204   /**
205     @dev The constructor
206     @param _verifier the address of SNARK verifier for this contract
207     @param _denomination transfer amount for each deposit
208     @param _merkleTreeHeight the height of deposits' Merkle Tree
209     @param _operator operator address (see operator comment above)
210   */
211   constructor(
212     IVerifier _verifier,
213     uint256 _denomination,
214     uint32 _merkleTreeHeight,
215     address _operator
216   ) MerkleTreeWithHistory(_merkleTreeHeight) public {
217     require(_denomination > 0, "denomination should be greater than 0");
218     verifier = _verifier;
219     operator = _operator;
220     denomination = _denomination;
221   }
222 
223   /**
224     @dev Deposit funds into the contract. The caller must send (for ETH) or approve (for ERC20) value equal to or `denomination` of this instance.
225     @param _commitment the note commitment, which is PedersenHash(nullifier + secret)
226   */
227   function deposit(bytes32 _commitment) external payable nonReentrant {
228     require(!commitments[_commitment], "The commitment has been submitted");
229 
230     uint32 insertedIndex = _insert(_commitment);
231     commitments[_commitment] = true;
232     _processDeposit();
233 
234     emit Deposit(_commitment, insertedIndex, block.timestamp);
235   }
236 
237   /** @dev this function is defined in a child contract */
238   function _processDeposit() internal;
239 
240   /**
241     @dev Withdraw a deposit from the contract. `proof` is a zkSNARK proof data, and input is an array of circuit public inputs
242     `input` array consists of:
243       - merkle root of all deposits in the contract
244       - hash of unique deposit nullifier to prevent double spends
245       - the recipient of funds
246       - optional fee that goes to the transaction sender (usually a relay)
247   */
248   function withdraw(bytes calldata _proof, bytes32 _root, bytes32 _nullifierHash, address payable _recipient, address payable _relayer, uint256 _fee, uint256 _refund) external payable nonReentrant {
249     require(_fee <= denomination, "Fee exceeds transfer value");
250     require(!nullifierHashes[_nullifierHash], "The note has been already spent");
251     require(isKnownRoot(_root), "Cannot find your merkle root"); // Make sure to use a recent one
252     require(verifier.verifyProof(_proof, [uint256(_root), uint256(_nullifierHash), uint256(_recipient), uint256(_relayer), _fee, _refund]), "Invalid withdraw proof");
253 
254     nullifierHashes[_nullifierHash] = true;
255     _processWithdraw(_recipient, _relayer, _fee, _refund);
256     emit Withdrawal(_recipient, _nullifierHash, _relayer, _fee);
257   }
258 
259   /** @dev this function is defined in a child contract */
260   function _processWithdraw(address payable _recipient, address payable _relayer, uint256 _fee, uint256 _refund) internal;
261 
262   /** @dev whether a note is already spent */
263   function isSpent(bytes32 _nullifierHash) public view returns(bool) {
264     return nullifierHashes[_nullifierHash];
265   }
266 
267   /** @dev whether an array of notes is already spent */
268   function isSpentArray(bytes32[] calldata _nullifierHashes) external view returns(bool[] memory spent) {
269     spent = new bool[](_nullifierHashes.length);
270     for(uint i = 0; i < _nullifierHashes.length; i++) {
271       if (isSpent(_nullifierHashes[i])) {
272         spent[i] = true;
273       }
274     }
275   }
276 
277   /**
278     @dev allow operator to update SNARK verification keys. This is needed to update keys after the final trusted setup ceremony is held.
279     After that operator rights are supposed to be transferred to zero address
280   */
281   function updateVerifier(address _newVerifier) external onlyOperator {
282     verifier = IVerifier(_newVerifier);
283   }
284 
285   /** @dev operator can change his address */
286   function changeOperator(address _newOperator) external onlyOperator {
287     operator = _newOperator;
288   }
289 }
290 
291 // File: contracts/ETHTornado.sol
292 
293 // https://tornado.cash
294 /*
295 * d888888P                                           dP              a88888b.                   dP
296 *    88                                              88             d8'   `88                   88
297 *    88    .d8888b. 88d888b. 88d888b. .d8888b. .d888b88 .d8888b.    88        .d8888b. .d8888b. 88d888b.
298 *    88    88'  `88 88'  `88 88'  `88 88'  `88 88'  `88 88'  `88    88        88'  `88 Y8ooooo. 88'  `88
299 *    88    88.  .88 88       88    88 88.  .88 88.  .88 88.  .88 dP Y8.   .88 88.  .88       88 88    88
300 *    dP    `88888P' dP       dP    dP `88888P8 `88888P8 `88888P' 88  Y88888P' `88888P8 `88888P' dP    dP
301 * ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
302 */
303 
304 pragma solidity ^0.5.8;
305 
306 
307 contract TornadoCash_eth is Tornado {
308   constructor(
309     IVerifier _verifier,
310     uint256 _denomination,
311     uint32 _merkleTreeHeight,
312     address _operator
313   ) Tornado(_verifier, _denomination, _merkleTreeHeight, _operator) public {
314   }
315 
316   function _processDeposit() internal {
317     require(msg.value == denomination, "Please send `mixDenomination` ETH along with transaction");
318   }
319 
320   function _processWithdraw(address payable _recipient, address payable _relayer, uint256 _fee, uint256 _refund) internal {
321     // sanity checks
322     require(msg.value == 0, "Message value is supposed to be zero for ETH instance");
323     require(_refund == 0, "Refund value is supposed to be zero for ETH instance");
324 
325     (bool success, ) = _recipient.call.value(denomination - _fee)("");
326     require(success, "payment to _recipient did not go thru");
327     if (_fee > 0) {
328       (success, ) = _relayer.call.value(_fee)("");
329       require(success, "payment to _relayer did not go thru");
330     }
331   }
332 }