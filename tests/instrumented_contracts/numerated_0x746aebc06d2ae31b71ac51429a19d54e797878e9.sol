1 /**
2 * https://tornado.cash
3 *
4 * d888888P                                           dP              a88888b.                   dP
5 *    88                                              88             d8'   `88                   88
6 *    88    .d8888b. 88d888b. 88d888b. .d8888b. .d888b88 .d8888b.    88        .d8888b. .d8888b. 88d888b.
7 *    88    88'  `88 88'  `88 88'  `88 88'  `88 88'  `88 88'  `88    88        88'  `88 Y8ooooo. 88'  `88
8 *    88    88.  .88 88       88    88 88.  .88 88.  .88 88.  .88 dP Y8.   .88 88.  .88       88 88    88
9 *    dP    `88888P' dP       dP    dP `88888P8 `88888P8 `88888P' 88  Y88888P' `88888P8 `88888P' dP    dP
10 * ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
11 */
12 
13 // File: contracts/interfaces/IVerifier.sol
14 
15 // SPDX-License-Identifier: MIT
16 
17 pragma solidity ^0.6.0;
18 pragma experimental ABIEncoderV2;
19 
20 interface IVerifier {
21   function verifyProof(bytes calldata proof, uint256[4] calldata input) external view returns (bool);
22 
23   function verifyProof(bytes calldata proof, uint256[7] calldata input) external view returns (bool);
24 
25   function verifyProof(bytes calldata proof, uint256[12] calldata input) external view returns (bool);
26 }
27 
28 // File: contracts/interfaces/IRewardSwap.sol
29 
30 
31 
32 pragma solidity ^0.6.0;
33 
34 interface IRewardSwap {
35   function swap(address recipient, uint256 amount) external returns (uint256);
36 
37   function setPoolWeight(uint256 newWeight) external;
38 }
39 
40 // File: torn-token/contracts/ENS.sol
41 
42 
43 
44 pragma solidity ^0.6.0;
45 
46 interface ENS {
47   function resolver(bytes32 node) external view returns (Resolver);
48 }
49 
50 interface Resolver {
51   function addr(bytes32 node) external view returns (address);
52 }
53 
54 contract EnsResolve {
55   function resolve(bytes32 node) public view virtual returns (address) {
56     ENS Registry = ENS(
57       getChainId() == 1 ? 0x00000000000C2E074eC69A0dFb2997BA6C7d2e1e : 0x8595bFb0D940DfEDC98943FA8a907091203f25EE
58     );
59     return Registry.resolver(node).addr(node);
60   }
61 
62   function bulkResolve(bytes32[] memory domains) public view returns (address[] memory result) {
63     result = new address[](domains.length);
64     for (uint256 i = 0; i < domains.length; i++) {
65       result[i] = resolve(domains[i]);
66     }
67   }
68 
69   function getChainId() internal pure returns (uint256) {
70     uint256 chainId;
71     assembly {
72       chainId := chainid()
73     }
74     return chainId;
75   }
76 }
77 
78 // File: @openzeppelin/contracts/GSN/Context.sol
79 
80 
81 
82 pragma solidity ^0.6.0;
83 
84 /*
85  * @dev Provides information about the current execution context, including the
86  * sender of the transaction and its data. While these are generally available
87  * via msg.sender and msg.data, they should not be accessed in such a direct
88  * manner, since when dealing with GSN meta-transactions the account sending and
89  * paying for execution may not be the actual sender (as far as an application
90  * is concerned).
91  *
92  * This contract is only required for intermediate, library-like contracts.
93  */
94 abstract contract Context {
95     function _msgSender() internal view virtual returns (address payable) {
96         return msg.sender;
97     }
98 
99     function _msgData() internal view virtual returns (bytes memory) {
100         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
101         return msg.data;
102     }
103 }
104 
105 // File: @openzeppelin/contracts/access/Ownable.sol
106 
107 
108 
109 pragma solidity ^0.6.0;
110 
111 /**
112  * @dev Contract module which provides a basic access control mechanism, where
113  * there is an account (an owner) that can be granted exclusive access to
114  * specific functions.
115  *
116  * By default, the owner account will be the one that deploys the contract. This
117  * can later be changed with {transferOwnership}.
118  *
119  * This module is used through inheritance. It will make available the modifier
120  * `onlyOwner`, which can be applied to your functions to restrict their use to
121  * the owner.
122  */
123 contract Ownable is Context {
124     address private _owner;
125 
126     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
127 
128     /**
129      * @dev Initializes the contract setting the deployer as the initial owner.
130      */
131     constructor () internal {
132         address msgSender = _msgSender();
133         _owner = msgSender;
134         emit OwnershipTransferred(address(0), msgSender);
135     }
136 
137     /**
138      * @dev Returns the address of the current owner.
139      */
140     function owner() public view returns (address) {
141         return _owner;
142     }
143 
144     /**
145      * @dev Throws if called by any account other than the owner.
146      */
147     modifier onlyOwner() {
148         require(_owner == _msgSender(), "Ownable: caller is not the owner");
149         _;
150     }
151 
152     /**
153      * @dev Leaves the contract without owner. It will not be possible to call
154      * `onlyOwner` functions anymore. Can only be called by the current owner.
155      *
156      * NOTE: Renouncing ownership will leave the contract without an owner,
157      * thereby removing any functionality that is only available to the owner.
158      */
159     function renounceOwnership() public virtual onlyOwner {
160         emit OwnershipTransferred(_owner, address(0));
161         _owner = address(0);
162     }
163 
164     /**
165      * @dev Transfers ownership of the contract to a new account (`newOwner`).
166      * Can only be called by the current owner.
167      */
168     function transferOwnership(address newOwner) public virtual onlyOwner {
169         require(newOwner != address(0), "Ownable: new owner is the zero address");
170         emit OwnershipTransferred(_owner, newOwner);
171         _owner = newOwner;
172     }
173 }
174 
175 // File: contracts/interfaces/IHasher.sol
176 
177 
178 
179 pragma solidity ^0.6.0;
180 
181 interface IHasher {
182   function poseidon(bytes32[2] calldata inputs) external pure returns (bytes32);
183 
184   function poseidon(bytes32[3] calldata inputs) external pure returns (bytes32);
185 }
186 
187 // File: contracts/utils/MerkleTreeWithHistory.sol
188 
189 
190 
191 pragma solidity ^0.6.0;
192 
193 
194 contract MerkleTreeWithHistory {
195   uint256 public constant FIELD_SIZE = 21888242871839275222246405745257275088548364400416034343698204186575808495617;
196   uint256 public constant ZERO_VALUE = 21663839004416932945382355908790599225266501822907911457504978515578255421292; // = keccak256("tornado") % FIELD_SIZE
197 
198   uint32 public immutable levels;
199   IHasher public hasher; // todo immutable
200 
201   bytes32[] public filledSubtrees;
202   bytes32[] public zeros;
203   uint32 public currentRootIndex = 0;
204   uint32 public nextIndex = 0;
205   uint32 public constant ROOT_HISTORY_SIZE = 10;
206   bytes32[ROOT_HISTORY_SIZE] public roots;
207 
208   constructor(uint32 _treeLevels, IHasher _hasher) public {
209     require(_treeLevels > 0, "_treeLevels should be greater than zero");
210     require(_treeLevels < 32, "_treeLevels should be less than 32");
211     levels = _treeLevels;
212     hasher = _hasher;
213 
214     bytes32 currentZero = bytes32(ZERO_VALUE);
215     zeros.push(currentZero);
216     filledSubtrees.push(currentZero);
217 
218     for (uint32 i = 1; i < _treeLevels; i++) {
219       currentZero = hashLeftRight(currentZero, currentZero);
220       zeros.push(currentZero);
221       filledSubtrees.push(currentZero);
222     }
223 
224     filledSubtrees.push(hashLeftRight(currentZero, currentZero));
225     roots[0] = filledSubtrees[_treeLevels];
226   }
227 
228   /**
229     @dev Hash 2 tree leaves, returns poseidon(_left, _right)
230   */
231   function hashLeftRight(bytes32 _left, bytes32 _right) public view returns (bytes32) {
232     return hasher.poseidon([_left, _right]);
233   }
234 
235   function _insert(bytes32 _leaf) internal returns (uint32 index) {
236     uint32 currentIndex = nextIndex;
237     require(currentIndex != uint32(2)**levels, "Merkle tree is full. No more leaves can be added");
238     nextIndex = currentIndex + 1;
239     bytes32 currentLevelHash = _leaf;
240     bytes32 left;
241     bytes32 right;
242 
243     for (uint32 i = 0; i < levels; i++) {
244       if (currentIndex % 2 == 0) {
245         left = currentLevelHash;
246         right = zeros[i];
247         filledSubtrees[i] = currentLevelHash;
248       } else {
249         left = filledSubtrees[i];
250         right = currentLevelHash;
251       }
252 
253       currentLevelHash = hashLeftRight(left, right);
254       currentIndex /= 2;
255     }
256 
257     currentRootIndex = (currentRootIndex + 1) % ROOT_HISTORY_SIZE;
258     roots[currentRootIndex] = currentLevelHash;
259     return nextIndex - 1;
260   }
261 
262   function _bulkInsert(bytes32[] memory _leaves) internal {
263     uint32 insertIndex = nextIndex;
264     require(insertIndex + _leaves.length <= uint32(2)**levels, "Merkle doesn't have enough capacity to add specified leaves");
265 
266     bytes32[] memory subtrees = new bytes32[](levels);
267     bool[] memory modifiedSubtrees = new bool[](levels);
268     for (uint32 j = 0; j < _leaves.length - 1; j++) {
269       uint256 index = insertIndex + j;
270       bytes32 currentLevelHash = _leaves[j];
271 
272       for (uint32 i = 0; ; i++) {
273         if (index % 2 == 0) {
274           modifiedSubtrees[i] = true;
275           subtrees[i] = currentLevelHash;
276           break;
277         }
278 
279         if(subtrees[i] == bytes32(0)) {
280           subtrees[i] = filledSubtrees[i];
281         }
282         currentLevelHash = hashLeftRight(subtrees[i], currentLevelHash);
283         index /= 2;
284       }
285     }
286 
287     for (uint32 i = 0; i < levels; i++) {
288       // using local map to save on gas on writes if elements were not modified
289       if (modifiedSubtrees[i]) {
290         filledSubtrees[i] = subtrees[i];
291       }
292     }
293 
294     nextIndex = uint32(insertIndex + _leaves.length - 1);
295     _insert(_leaves[_leaves.length - 1]);
296   }
297 
298   /**
299     @dev Whether the root is present in the root history
300   */
301   function isKnownRoot(bytes32 _root) public view returns (bool) {
302     if (_root == 0) {
303       return false;
304     }
305     uint32 i = currentRootIndex;
306     do {
307       if (_root == roots[i]) {
308         return true;
309       }
310       if (i == 0) {
311         i = ROOT_HISTORY_SIZE;
312       }
313       i--;
314     } while (i != currentRootIndex);
315     return false;
316   }
317 
318   /**
319     @dev Returns the last root
320   */
321   function getLastRoot() public view returns (bytes32) {
322     return roots[currentRootIndex];
323   }
324 }
325 
326 // File: contracts/utils/OwnableMerkleTree.sol
327 
328 
329 
330 pragma solidity ^0.6.0;
331 
332 
333 
334 contract OwnableMerkleTree is Ownable, MerkleTreeWithHistory {
335   constructor(uint32 _treeLevels, IHasher _hasher) public MerkleTreeWithHistory(_treeLevels, _hasher) {}
336 
337   function insert(bytes32 _leaf) external onlyOwner returns (uint32 index) {
338     return _insert(_leaf);
339   }
340 
341   function bulkInsert(bytes32[] calldata _leaves) external onlyOwner {
342     _bulkInsert(_leaves);
343   }
344 }
345 
346 // File: contracts/interfaces/ITornadoTrees.sol
347 
348 
349 
350 pragma solidity ^0.6.0;
351 
352 interface ITornadoTrees {
353   function registerDeposit(address instance, bytes32 commitment) external;
354 
355   function registerWithdrawal(address instance, bytes32 nullifier) external;
356 }
357 
358 // File: contracts/TornadoTrees.sol
359 
360 
361 
362 pragma solidity ^0.6.0;
363 
364 
365 
366 
367 
368 contract TornadoTrees is ITornadoTrees, EnsResolve {
369   OwnableMerkleTree public immutable depositTree;
370   OwnableMerkleTree public immutable withdrawalTree;
371   IHasher public immutable hasher;
372   address public immutable tornadoProxy;
373 
374   bytes32[] public deposits;
375   uint256 public lastProcessedDepositLeaf;
376 
377   bytes32[] public withdrawals;
378   uint256 public lastProcessedWithdrawalLeaf;
379 
380   event DepositData(address instance, bytes32 indexed hash, uint256 block, uint256 index);
381   event WithdrawalData(address instance, bytes32 indexed hash, uint256 block, uint256 index);
382 
383   struct TreeLeaf {
384     address instance;
385     bytes32 hash;
386     uint256 block;
387   }
388 
389   modifier onlyTornadoProxy {
390     require(msg.sender == tornadoProxy, "Not authorized");
391     _;
392   }
393 
394   constructor(
395     bytes32 _tornadoProxy,
396     bytes32 _hasher2,
397     bytes32 _hasher3,
398     uint32 _levels
399   ) public {
400     tornadoProxy = resolve(_tornadoProxy);
401     hasher = IHasher(resolve(_hasher3));
402     depositTree = new OwnableMerkleTree(_levels, IHasher(resolve(_hasher2)));
403     withdrawalTree = new OwnableMerkleTree(_levels, IHasher(resolve(_hasher2)));
404   }
405 
406   function registerDeposit(address _instance, bytes32 _commitment) external override onlyTornadoProxy {
407     deposits.push(keccak256(abi.encode(_instance, _commitment, blockNumber())));
408   }
409 
410   function registerWithdrawal(address _instance, bytes32 _nullifier) external override onlyTornadoProxy {
411     withdrawals.push(keccak256(abi.encode(_instance, _nullifier, blockNumber())));
412   }
413 
414   function updateRoots(TreeLeaf[] calldata _deposits, TreeLeaf[] calldata _withdrawals) external {
415     if (_deposits.length > 0) updateDepositTree(_deposits);
416     if (_withdrawals.length > 0) updateWithdrawalTree(_withdrawals);
417   }
418 
419   function updateDepositTree(TreeLeaf[] calldata _deposits) public {
420     bytes32[] memory leaves = new bytes32[](_deposits.length);
421     uint256 offset = lastProcessedDepositLeaf;
422 
423     for (uint256 i = 0; i < _deposits.length; i++) {
424       TreeLeaf memory deposit = _deposits[i];
425       bytes32 leafHash = keccak256(abi.encode(deposit.instance, deposit.hash, deposit.block));
426       require(deposits[offset + i] == leafHash, "Incorrect deposit");
427 
428       leaves[i] = hasher.poseidon([bytes32(uint256(deposit.instance)), deposit.hash, bytes32(deposit.block)]);
429       delete deposits[offset + i];
430 
431       emit DepositData(deposit.instance, deposit.hash, deposit.block, offset + i);
432     }
433 
434     lastProcessedDepositLeaf = offset + _deposits.length;
435     depositTree.bulkInsert(leaves);
436   }
437 
438   function updateWithdrawalTree(TreeLeaf[] calldata _withdrawals) public {
439     bytes32[] memory leaves = new bytes32[](_withdrawals.length);
440     uint256 offset = lastProcessedWithdrawalLeaf;
441 
442     for (uint256 i = 0; i < _withdrawals.length; i++) {
443       TreeLeaf memory withdrawal = _withdrawals[i];
444       bytes32 leafHash = keccak256(abi.encode(withdrawal.instance, withdrawal.hash, withdrawal.block));
445       require(withdrawals[offset + i] == leafHash, "Incorrect withdrawal");
446 
447       leaves[i] = hasher.poseidon([bytes32(uint256(withdrawal.instance)), withdrawal.hash, bytes32(withdrawal.block)]);
448       delete withdrawals[offset + i];
449 
450       emit WithdrawalData(withdrawal.instance, withdrawal.hash, withdrawal.block, offset + i);
451     }
452 
453     lastProcessedWithdrawalLeaf = offset + _withdrawals.length;
454     withdrawalTree.bulkInsert(leaves);
455   }
456 
457   function validateRoots(bytes32 _depositRoot, bytes32 _withdrawalRoot) public view {
458     require(depositTree.isKnownRoot(_depositRoot), "Incorrect deposit tree root");
459     require(withdrawalTree.isKnownRoot(_withdrawalRoot), "Incorrect withdrawal tree root");
460   }
461 
462   function depositRoot() external view returns (bytes32) {
463     return depositTree.getLastRoot();
464   }
465 
466   function withdrawalRoot() external view returns (bytes32) {
467     return withdrawalTree.getLastRoot();
468   }
469 
470   function getRegisteredDeposits() external view returns (bytes32[] memory _deposits) {
471     uint256 count = deposits.length - lastProcessedDepositLeaf;
472     _deposits = new bytes32[](count);
473     for (uint256 i = 0; i < count; i++) {
474       _deposits[i] = deposits[lastProcessedDepositLeaf + i];
475     }
476   }
477 
478   function getRegisteredWithdrawals() external view returns (bytes32[] memory _withdrawals) {
479     uint256 count = withdrawals.length - lastProcessedWithdrawalLeaf;
480     _withdrawals = new bytes32[](count);
481     for (uint256 i = 0; i < count; i++) {
482       _withdrawals[i] = withdrawals[lastProcessedWithdrawalLeaf + i];
483     }
484   }
485 
486   function blockNumber() public view virtual returns (uint256) {
487     return block.number;
488   }
489 }
490 
491 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
492 
493 
494 
495 pragma solidity ^0.6.0;
496 
497 /**
498  * @dev Interface of the ERC20 standard as defined in the EIP.
499  */
500 interface IERC20 {
501     /**
502      * @dev Returns the amount of tokens in existence.
503      */
504     function totalSupply() external view returns (uint256);
505 
506     /**
507      * @dev Returns the amount of tokens owned by `account`.
508      */
509     function balanceOf(address account) external view returns (uint256);
510 
511     /**
512      * @dev Moves `amount` tokens from the caller's account to `recipient`.
513      *
514      * Returns a boolean value indicating whether the operation succeeded.
515      *
516      * Emits a {Transfer} event.
517      */
518     function transfer(address recipient, uint256 amount) external returns (bool);
519 
520     /**
521      * @dev Returns the remaining number of tokens that `spender` will be
522      * allowed to spend on behalf of `owner` through {transferFrom}. This is
523      * zero by default.
524      *
525      * This value changes when {approve} or {transferFrom} are called.
526      */
527     function allowance(address owner, address spender) external view returns (uint256);
528 
529     /**
530      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
531      *
532      * Returns a boolean value indicating whether the operation succeeded.
533      *
534      * IMPORTANT: Beware that changing an allowance with this method brings the risk
535      * that someone may use both the old and the new allowance by unfortunate
536      * transaction ordering. One possible solution to mitigate this race
537      * condition is to first reduce the spender's allowance to 0 and set the
538      * desired value afterwards:
539      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
540      *
541      * Emits an {Approval} event.
542      */
543     function approve(address spender, uint256 amount) external returns (bool);
544 
545     /**
546      * @dev Moves `amount` tokens from `sender` to `recipient` using the
547      * allowance mechanism. `amount` is then deducted from the caller's
548      * allowance.
549      *
550      * Returns a boolean value indicating whether the operation succeeded.
551      *
552      * Emits a {Transfer} event.
553      */
554     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
555 
556     /**
557      * @dev Emitted when `value` tokens are moved from one account (`from`) to
558      * another (`to`).
559      *
560      * Note that `value` may be zero.
561      */
562     event Transfer(address indexed from, address indexed to, uint256 value);
563 
564     /**
565      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
566      * a call to {approve}. `value` is the new allowance.
567      */
568     event Approval(address indexed owner, address indexed spender, uint256 value);
569 }
570 
571 // File: @openzeppelin/contracts/math/SafeMath.sol
572 
573 
574 
575 pragma solidity ^0.6.0;
576 
577 /**
578  * @dev Wrappers over Solidity's arithmetic operations with added overflow
579  * checks.
580  *
581  * Arithmetic operations in Solidity wrap on overflow. This can easily result
582  * in bugs, because programmers usually assume that an overflow raises an
583  * error, which is the standard behavior in high level programming languages.
584  * `SafeMath` restores this intuition by reverting the transaction when an
585  * operation overflows.
586  *
587  * Using this library instead of the unchecked operations eliminates an entire
588  * class of bugs, so it's recommended to use it always.
589  */
590 library SafeMath {
591     /**
592      * @dev Returns the addition of two unsigned integers, reverting on
593      * overflow.
594      *
595      * Counterpart to Solidity's `+` operator.
596      *
597      * Requirements:
598      *
599      * - Addition cannot overflow.
600      */
601     function add(uint256 a, uint256 b) internal pure returns (uint256) {
602         uint256 c = a + b;
603         require(c >= a, "SafeMath: addition overflow");
604 
605         return c;
606     }
607 
608     /**
609      * @dev Returns the subtraction of two unsigned integers, reverting on
610      * overflow (when the result is negative).
611      *
612      * Counterpart to Solidity's `-` operator.
613      *
614      * Requirements:
615      *
616      * - Subtraction cannot overflow.
617      */
618     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
619         return sub(a, b, "SafeMath: subtraction overflow");
620     }
621 
622     /**
623      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
624      * overflow (when the result is negative).
625      *
626      * Counterpart to Solidity's `-` operator.
627      *
628      * Requirements:
629      *
630      * - Subtraction cannot overflow.
631      */
632     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
633         require(b <= a, errorMessage);
634         uint256 c = a - b;
635 
636         return c;
637     }
638 
639     /**
640      * @dev Returns the multiplication of two unsigned integers, reverting on
641      * overflow.
642      *
643      * Counterpart to Solidity's `*` operator.
644      *
645      * Requirements:
646      *
647      * - Multiplication cannot overflow.
648      */
649     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
650         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
651         // benefit is lost if 'b' is also tested.
652         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
653         if (a == 0) {
654             return 0;
655         }
656 
657         uint256 c = a * b;
658         require(c / a == b, "SafeMath: multiplication overflow");
659 
660         return c;
661     }
662 
663     /**
664      * @dev Returns the integer division of two unsigned integers. Reverts on
665      * division by zero. The result is rounded towards zero.
666      *
667      * Counterpart to Solidity's `/` operator. Note: this function uses a
668      * `revert` opcode (which leaves remaining gas untouched) while Solidity
669      * uses an invalid opcode to revert (consuming all remaining gas).
670      *
671      * Requirements:
672      *
673      * - The divisor cannot be zero.
674      */
675     function div(uint256 a, uint256 b) internal pure returns (uint256) {
676         return div(a, b, "SafeMath: division by zero");
677     }
678 
679     /**
680      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
681      * division by zero. The result is rounded towards zero.
682      *
683      * Counterpart to Solidity's `/` operator. Note: this function uses a
684      * `revert` opcode (which leaves remaining gas untouched) while Solidity
685      * uses an invalid opcode to revert (consuming all remaining gas).
686      *
687      * Requirements:
688      *
689      * - The divisor cannot be zero.
690      */
691     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
692         require(b > 0, errorMessage);
693         uint256 c = a / b;
694         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
695 
696         return c;
697     }
698 
699     /**
700      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
701      * Reverts when dividing by zero.
702      *
703      * Counterpart to Solidity's `%` operator. This function uses a `revert`
704      * opcode (which leaves remaining gas untouched) while Solidity uses an
705      * invalid opcode to revert (consuming all remaining gas).
706      *
707      * Requirements:
708      *
709      * - The divisor cannot be zero.
710      */
711     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
712         return mod(a, b, "SafeMath: modulo by zero");
713     }
714 
715     /**
716      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
717      * Reverts with custom message when dividing by zero.
718      *
719      * Counterpart to Solidity's `%` operator. This function uses a `revert`
720      * opcode (which leaves remaining gas untouched) while Solidity uses an
721      * invalid opcode to revert (consuming all remaining gas).
722      *
723      * Requirements:
724      *
725      * - The divisor cannot be zero.
726      */
727     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
728         require(b != 0, errorMessage);
729         return a % b;
730     }
731 }
732 
733 // File: contracts/Miner.sol
734 
735 
736 
737 pragma solidity ^0.6.0;
738 
739 
740 
741 
742 
743 
744 
745 contract Miner is EnsResolve {
746   using SafeMath for uint256;
747 
748   IVerifier public rewardVerifier;
749   IVerifier public withdrawVerifier;
750   IVerifier public treeUpdateVerifier;
751   IRewardSwap public immutable rewardSwap;
752   address public immutable governance;
753   TornadoTrees public tornadoTrees;
754 
755   mapping(bytes32 => bool) public accountNullifiers;
756   mapping(bytes32 => bool) public rewardNullifiers;
757   mapping(address => uint256) public rates;
758 
759   uint256 public accountCount;
760   uint256 public constant ACCOUNT_ROOT_HISTORY_SIZE = 100;
761   bytes32[ACCOUNT_ROOT_HISTORY_SIZE] public accountRoots;
762 
763   event NewAccount(bytes32 commitment, bytes32 nullifier, bytes encryptedAccount, uint256 index);
764   event RateChanged(address instance, uint256 value);
765   event VerifiersUpdated(address reward, address withdraw, address treeUpdate);
766 
767   struct TreeUpdateArgs {
768     bytes32 oldRoot;
769     bytes32 newRoot;
770     bytes32 leaf;
771     uint256 pathIndices;
772   }
773 
774   struct AccountUpdate {
775     bytes32 inputRoot;
776     bytes32 inputNullifierHash;
777     bytes32 outputRoot;
778     uint256 outputPathIndices;
779     bytes32 outputCommitment;
780   }
781 
782   struct RewardExtData {
783     address relayer;
784     bytes encryptedAccount;
785   }
786 
787   struct RewardArgs {
788     uint256 rate;
789     uint256 fee;
790     address instance;
791     bytes32 rewardNullifier;
792     bytes32 extDataHash;
793     bytes32 depositRoot;
794     bytes32 withdrawalRoot;
795     RewardExtData extData;
796     AccountUpdate account;
797   }
798 
799   struct WithdrawExtData {
800     uint256 fee;
801     address recipient;
802     address relayer;
803     bytes encryptedAccount;
804   }
805 
806   struct WithdrawArgs {
807     uint256 amount;
808     bytes32 extDataHash;
809     WithdrawExtData extData;
810     AccountUpdate account;
811   }
812 
813   struct Rate {
814     bytes32 instance;
815     uint256 value;
816   }
817 
818   modifier onlyGovernance() {
819     require(msg.sender == governance, "Only governance can perform this action");
820     _;
821   }
822 
823   constructor(
824     bytes32 _rewardSwap,
825     bytes32 _governance,
826     bytes32 _tornadoTrees,
827     bytes32[3] memory _verifiers,
828     bytes32 _accountRoot,
829     Rate[] memory _rates
830   ) public {
831     rewardSwap = IRewardSwap(resolve(_rewardSwap));
832     governance = resolve(_governance);
833     tornadoTrees = TornadoTrees(resolve(_tornadoTrees));
834 
835     // insert empty tree root without incrementing accountCount counter
836     accountRoots[0] = _accountRoot;
837 
838     _setRates(_rates);
839     // prettier-ignore
840     _setVerifiers([
841       IVerifier(resolve(_verifiers[0])),
842       IVerifier(resolve(_verifiers[1])),
843       IVerifier(resolve(_verifiers[2]))
844     ]);
845   }
846 
847   function reward(bytes memory _proof, RewardArgs memory _args) public {
848     reward(_proof, _args, new bytes(0), TreeUpdateArgs(0, 0, 0, 0));
849   }
850 
851   function batchReward(bytes[] calldata _rewardArgs) external {
852     for (uint256 i = 0; i < _rewardArgs.length; i++) {
853       (bytes memory proof, RewardArgs memory args) = abi.decode(_rewardArgs[i], (bytes, RewardArgs));
854       reward(proof, args);
855     }
856   }
857 
858   function reward(
859     bytes memory _proof,
860     RewardArgs memory _args,
861     bytes memory _treeUpdateProof,
862     TreeUpdateArgs memory _treeUpdateArgs
863   ) public {
864     validateAccountUpdate(_args.account, _treeUpdateProof, _treeUpdateArgs);
865     tornadoTrees.validateRoots(_args.depositRoot, _args.withdrawalRoot);
866     require(_args.extDataHash == keccak248(abi.encode(_args.extData)), "Incorrect external data hash");
867     require(_args.fee < 2**248, "Fee value out of range");
868     require(_args.rate == rates[_args.instance] && _args.rate > 0, "Invalid reward rate");
869     require(!rewardNullifiers[_args.rewardNullifier], "Reward has been already spent");
870     require(
871       rewardVerifier.verifyProof(
872         _proof,
873         [
874           uint256(_args.rate),
875           uint256(_args.fee),
876           uint256(_args.instance),
877           uint256(_args.rewardNullifier),
878           uint256(_args.extDataHash),
879           uint256(_args.account.inputRoot),
880           uint256(_args.account.inputNullifierHash),
881           uint256(_args.account.outputRoot),
882           uint256(_args.account.outputPathIndices),
883           uint256(_args.account.outputCommitment),
884           uint256(_args.depositRoot),
885           uint256(_args.withdrawalRoot)
886         ]
887       ),
888       "Invalid reward proof"
889     );
890 
891     accountNullifiers[_args.account.inputNullifierHash] = true;
892     rewardNullifiers[_args.rewardNullifier] = true;
893     insertAccountRoot(_args.account.inputRoot == getLastAccountRoot() ? _args.account.outputRoot : _treeUpdateArgs.newRoot);
894     if (_args.fee > 0) {
895       rewardSwap.swap(_args.extData.relayer, _args.fee);
896     }
897 
898     emit NewAccount(
899       _args.account.outputCommitment,
900       _args.account.inputNullifierHash,
901       _args.extData.encryptedAccount,
902       accountCount - 1
903     );
904   }
905 
906   function withdraw(bytes memory _proof, WithdrawArgs memory _args) public {
907     withdraw(_proof, _args, new bytes(0), TreeUpdateArgs(0, 0, 0, 0));
908   }
909 
910   function withdraw(
911     bytes memory _proof,
912     WithdrawArgs memory _args,
913     bytes memory _treeUpdateProof,
914     TreeUpdateArgs memory _treeUpdateArgs
915   ) public {
916     validateAccountUpdate(_args.account, _treeUpdateProof, _treeUpdateArgs);
917     require(_args.extDataHash == keccak248(abi.encode(_args.extData)), "Incorrect external data hash");
918     require(_args.amount < 2**248, "Amount value out of range");
919     require(
920       withdrawVerifier.verifyProof(
921         _proof,
922         [
923           uint256(_args.amount),
924           uint256(_args.extDataHash),
925           uint256(_args.account.inputRoot),
926           uint256(_args.account.inputNullifierHash),
927           uint256(_args.account.outputRoot),
928           uint256(_args.account.outputPathIndices),
929           uint256(_args.account.outputCommitment)
930         ]
931       ),
932       "Invalid withdrawal proof"
933     );
934 
935     insertAccountRoot(_args.account.inputRoot == getLastAccountRoot() ? _args.account.outputRoot : _treeUpdateArgs.newRoot);
936     accountNullifiers[_args.account.inputNullifierHash] = true;
937     // allow submitting noop withdrawals (amount == 0)
938     uint256 amount = _args.amount.sub(_args.extData.fee, "Amount should be greater than fee");
939     if (amount > 0) {
940       rewardSwap.swap(_args.extData.recipient, amount);
941     }
942     // Note. The relayer swap rate always will be worse than estimated
943     if (_args.extData.fee > 0) {
944       rewardSwap.swap(_args.extData.relayer, _args.extData.fee);
945     }
946 
947     emit NewAccount(
948       _args.account.outputCommitment,
949       _args.account.inputNullifierHash,
950       _args.extData.encryptedAccount,
951       accountCount - 1
952     );
953   }
954 
955   function setRates(Rate[] memory _rates) external onlyGovernance {
956     _setRates(_rates);
957   }
958 
959   function setVerifiers(IVerifier[3] calldata _verifiers) external onlyGovernance {
960     _setVerifiers(_verifiers);
961   }
962 
963   function setTornadoTreesContract(TornadoTrees _tornadoTrees) external onlyGovernance {
964     tornadoTrees = _tornadoTrees;
965   }
966 
967   function setPoolWeight(uint256 _newWeight) external onlyGovernance {
968     rewardSwap.setPoolWeight(_newWeight);
969   }
970 
971   // ------VIEW-------
972 
973   /**
974     @dev Whether the root is present in the root history
975     */
976   function isKnownAccountRoot(bytes32 _root, uint256 _index) public view returns (bool) {
977     return _root != 0 && accountRoots[_index % ACCOUNT_ROOT_HISTORY_SIZE] == _root;
978   }
979 
980   /**
981     @dev Returns the last root
982     */
983   function getLastAccountRoot() public view returns (bytes32) {
984     return accountRoots[accountCount % ACCOUNT_ROOT_HISTORY_SIZE];
985   }
986 
987   // -----INTERNAL-------
988 
989   function keccak248(bytes memory _data) internal pure returns (bytes32) {
990     return keccak256(_data) & 0x00ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
991   }
992 
993   function validateTreeUpdate(
994     bytes memory _proof,
995     TreeUpdateArgs memory _args,
996     bytes32 _commitment
997   ) internal view {
998     require(_proof.length > 0, "Outdated account merkle root");
999     require(_args.oldRoot == getLastAccountRoot(), "Outdated tree update merkle root");
1000     require(_args.leaf == _commitment, "Incorrect commitment inserted");
1001     require(_args.pathIndices == accountCount, "Incorrect account insert index");
1002     require(
1003       treeUpdateVerifier.verifyProof(
1004         _proof,
1005         [uint256(_args.oldRoot), uint256(_args.newRoot), uint256(_args.leaf), uint256(_args.pathIndices)]
1006       ),
1007       "Invalid tree update proof"
1008     );
1009   }
1010 
1011   function validateAccountUpdate(
1012     AccountUpdate memory _account,
1013     bytes memory _treeUpdateProof,
1014     TreeUpdateArgs memory _treeUpdateArgs
1015   ) internal view {
1016     require(!accountNullifiers[_account.inputNullifierHash], "Outdated account state");
1017     if (_account.inputRoot != getLastAccountRoot()) {
1018       // _account.outputPathIndices (= last tree leaf index) is always equal to root index in the history mapping
1019       // because we always generate a new root for each new leaf
1020       require(isKnownAccountRoot(_account.inputRoot, _account.outputPathIndices), "Invalid account root");
1021       validateTreeUpdate(_treeUpdateProof, _treeUpdateArgs, _account.outputCommitment);
1022     } else {
1023       require(_account.outputPathIndices == accountCount, "Incorrect account insert index");
1024     }
1025   }
1026 
1027   function insertAccountRoot(bytes32 _root) internal {
1028     accountRoots[++accountCount % ACCOUNT_ROOT_HISTORY_SIZE] = _root;
1029   }
1030 
1031   function _setRates(Rate[] memory _rates) internal {
1032     for (uint256 i = 0; i < _rates.length; i++) {
1033       require(_rates[i].value < 2**128, "Incorrect rate");
1034       address instance = resolve(_rates[i].instance);
1035       rates[instance] = _rates[i].value;
1036       emit RateChanged(instance, _rates[i].value);
1037     }
1038   }
1039 
1040   function _setVerifiers(IVerifier[3] memory _verifiers) internal {
1041     rewardVerifier = _verifiers[0];
1042     withdrawVerifier = _verifiers[1];
1043     treeUpdateVerifier = _verifiers[2];
1044     emit VerifiersUpdated(address(_verifiers[0]), address(_verifiers[1]), address(_verifiers[2]));
1045   }
1046 }