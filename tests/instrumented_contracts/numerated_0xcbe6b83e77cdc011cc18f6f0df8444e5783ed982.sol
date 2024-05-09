1 // Sources flattened with hardhat v2.0.10 https://hardhat.org
2 
3 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v3.4.0
4 
5 // SPDX-License-Identifier: MIXED
6 
7 pragma solidity >=0.6.0 <0.8.0;
8 
9 /**
10  * @dev Interface of the ERC20 standard as defined in the EIP.
11  */
12 interface IERC20 {
13     /**
14      * @dev Returns the amount of tokens in existence.
15      */
16     function totalSupply() external view returns (uint256);
17 
18     /**
19      * @dev Returns the amount of tokens owned by `account`.
20      */
21     function balanceOf(address account) external view returns (uint256);
22 
23     /**
24      * @dev Moves `amount` tokens from the caller's account to `recipient`.
25      *
26      * Returns a boolean value indicating whether the operation succeeded.
27      *
28      * Emits a {Transfer} event.
29      */
30     function transfer(address recipient, uint256 amount) external returns (bool);
31 
32     /**
33      * @dev Returns the remaining number of tokens that `spender` will be
34      * allowed to spend on behalf of `owner` through {transferFrom}. This is
35      * zero by default.
36      *
37      * This value changes when {approve} or {transferFrom} are called.
38      */
39     function allowance(address owner, address spender) external view returns (uint256);
40 
41     /**
42      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
43      *
44      * Returns a boolean value indicating whether the operation succeeded.
45      *
46      * IMPORTANT: Beware that changing an allowance with this method brings the risk
47      * that someone may use both the old and the new allowance by unfortunate
48      * transaction ordering. One possible solution to mitigate this race
49      * condition is to first reduce the spender's allowance to 0 and set the
50      * desired value afterwards:
51      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
52      *
53      * Emits an {Approval} event.
54      */
55     function approve(address spender, uint256 amount) external returns (bool);
56 
57     /**
58      * @dev Moves `amount` tokens from `sender` to `recipient` using the
59      * allowance mechanism. `amount` is then deducted from the caller's
60      * allowance.
61      *
62      * Returns a boolean value indicating whether the operation succeeded.
63      *
64      * Emits a {Transfer} event.
65      */
66     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
67 
68     /**
69      * @dev Emitted when `value` tokens are moved from one account (`from`) to
70      * another (`to`).
71      *
72      * Note that `value` may be zero.
73      */
74     event Transfer(address indexed from, address indexed to, uint256 value);
75 
76     /**
77      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
78      * a call to {approve}. `value` is the new allowance.
79      */
80     event Approval(address indexed owner, address indexed spender, uint256 value);
81 }
82 
83 
84 // File @openzeppelin/contracts/cryptography/MerkleProof.sol@v3.4.0
85 
86 pragma solidity >=0.6.0 <0.8.0;
87 
88 /**
89  * @dev These functions deal with verification of Merkle trees (hash trees),
90  */
91 library MerkleProof {
92     /**
93      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
94      * defined by `root`. For this, a `proof` must be provided, containing
95      * sibling hashes on the branch from the leaf to the root of the tree. Each
96      * pair of leaves and each pair of pre-images are assumed to be sorted.
97      */
98     function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
99         bytes32 computedHash = leaf;
100 
101         for (uint256 i = 0; i < proof.length; i++) {
102             bytes32 proofElement = proof[i];
103 
104             if (computedHash <= proofElement) {
105                 // Hash(current computed hash + current element of the proof)
106                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
107             } else {
108                 // Hash(current element of the proof + current computed hash)
109                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
110             }
111         }
112 
113         // Check if the computed hash (root) is equal to the provided root
114         return computedHash == root;
115     }
116 }
117 
118 
119 // File contracts/interfaces/IMerkleDistributor.sol
120 
121 pragma solidity >=0.5.0;
122 
123 // Allows anyone to claim a token if they exist in a merkle root.
124 interface IMerkleDistributor {
125     // Returns the address of the token distributed by this contract.
126     function token() external view returns (address);
127     // Returns the merkle root of the merkle tree containing account balances available to claim.
128     function merkleRoot() external view returns (bytes32);
129     // Returns the current claiming week
130     function week() external view returns (uint32);
131     // Returns true if the claim function is frozen
132     function frozen() external view returns (bool);
133     // Returns true if the index has been marked claimed.
134     function isClaimed(uint256 index) external view returns (bool);
135     // Claim the given amount of the token to the given address. Reverts if the inputs are invalid.
136     function claim(uint256 index, address account, uint256 amount, bytes32[] calldata merkleProof) external;
137     // Freezes the claim function and allow the merkleRoot to be changed.
138     function freeze() external;
139     // Unfreezes the claim function.
140     function unfreeze() external;
141     // Update the merkle root and increment the week.
142     function updateMerkleRoot(bytes32 newMerkleRoot) external;
143 
144     // This event is triggered whenever a call to #claim succeeds.
145     event Claimed(uint256 index, uint256 amount, address indexed account, uint256 indexed week);
146     // This event is triggered whenever the merkle root gets updated.
147     event MerkleRootUpdated(bytes32 indexed merkleRoot, uint32 indexed week);
148 }
149 
150 
151 // File contracts/Ownable.sol
152 
153 // Audit on 5-Jan-2021 by Keno and BoringCrypto
154 
155 // P1 - P3: OK
156 pragma solidity 0.6.12;
157 
158 // Source: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol + Claimable.sol
159 // Edited by BoringCrypto
160 
161 // T1 - T4: OK
162 contract OwnableData {
163     // V1 - V5: OK
164     address public owner;
165     // V1 - V5: OK
166     address public pendingOwner;
167 }
168 
169 // T1 - T4: OK
170 contract Ownable is OwnableData {
171     // E1: OK
172     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
173 
174     constructor () internal {
175         owner = msg.sender;
176         emit OwnershipTransferred(address(0), msg.sender);
177     }
178 
179     // F1 - F9: OK
180     // C1 - C21: OK
181     function transferOwnership(address newOwner, bool direct, bool renounce) public onlyOwner {
182         if (direct) {
183             // Checks
184             require(newOwner != address(0) || renounce, "Ownable: zero address");
185 
186             // Effects
187             emit OwnershipTransferred(owner, newOwner);
188             owner = newOwner;
189         } else {
190             // Effects
191             pendingOwner = newOwner;
192         }
193     }
194 
195     // F1 - F9: OK
196     // C1 - C21: OK
197     function claimOwnership() public {
198         address _pendingOwner = pendingOwner;
199 
200         // Checks
201         require(msg.sender == _pendingOwner, "Ownable: caller != pending owner");
202 
203         // Effects
204         emit OwnershipTransferred(owner, _pendingOwner);
205         owner = _pendingOwner;
206         pendingOwner = address(0);
207     }
208 
209     // M1 - M5: OK
210     // C1 - C21: OK
211     modifier onlyOwner() {
212         require(msg.sender == owner, "Ownable: caller is not the owner");
213         _;
214     }
215 }
216 
217 
218 // File contracts/MerkleDistributor.sol
219 pragma solidity 0.6.12;
220 
221 contract MerkleDistributor is IMerkleDistributor, Ownable {
222     address public immutable override token;
223     bytes32 public override merkleRoot;
224     uint32 public override week;
225     bool public override frozen;
226 
227     // This is a packed array of booleans.
228     mapping(uint256 => mapping(uint256 => uint256)) private claimedBitMap;
229 
230     constructor(address token_, bytes32 merkleRoot_) public {
231         token = token_;
232         merkleRoot = merkleRoot_;
233         week = 0;
234         frozen = false;
235     }
236 
237     function isClaimed(uint256 index) public view override returns (bool) {
238         uint256 claimedWordIndex = index / 256;
239         uint256 claimedBitIndex = index % 256;
240         uint256 claimedWord = claimedBitMap[week][claimedWordIndex];
241         uint256 mask = (1 << claimedBitIndex);
242         return claimedWord & mask == mask;
243     }
244 
245     function _setClaimed(uint256 index) private {
246         uint256 claimedWordIndex = index / 256;
247         uint256 claimedBitIndex = index % 256;
248         claimedBitMap[week][claimedWordIndex] = claimedBitMap[week][claimedWordIndex] | (1 << claimedBitIndex);
249     }
250 
251     function claim(uint256 index, address account, uint256 amount, bytes32[] calldata merkleProof) external override {
252         require(!frozen, 'MerkleDistributor: Claiming is frozen.');
253         require(!isClaimed(index), 'MerkleDistributor: Drop already claimed.');
254 
255         // Verify the merkle proof.
256         bytes32 node = keccak256(abi.encodePacked(index, account, amount));
257         require(MerkleProof.verify(merkleProof, merkleRoot, node), 'MerkleDistributor: Invalid proof.');
258 
259         // Mark it claimed and send the token.
260         _setClaimed(index);
261         require(IERC20(token).transfer(account, amount), 'MerkleDistributor: Transfer failed.');
262 
263         emit Claimed(index, amount, account, week);
264     }
265 
266     function freeze() public override onlyOwner {
267         frozen = true;
268     }
269 
270     function unfreeze() public override onlyOwner {
271         frozen = false;
272     }
273 
274     function updateMerkleRoot(bytes32 _merkleRoot) public override onlyOwner {
275         require(frozen, 'MerkleDistributor: Contract not frozen.');
276 
277         // Increment the week (simulates the clearing of the claimedBitMap)
278         week = week + 1;
279         // Set the new merkle root
280         merkleRoot = _merkleRoot;
281 
282         emit MerkleRootUpdated(merkleRoot, week);
283     }
284 }
285 
286 
287 // File @openzeppelin/contracts/utils/Context.sol@v3.4.0
288 
289 pragma solidity >=0.6.0 <0.8.0;
290 
291 /*
292  * @dev Provides information about the current execution context, including the
293  * sender of the transaction and its data. While these are generally available
294  * via msg.sender and msg.data, they should not be accessed in such a direct
295  * manner, since when dealing with GSN meta-transactions the account sending and
296  * paying for execution may not be the actual sender (as far as an application
297  * is concerned).
298  *
299  * This contract is only required for intermediate, library-like contracts.
300  */
301 abstract contract Context {
302     function _msgSender() internal view virtual returns (address payable) {
303         return msg.sender;
304     }
305 
306     function _msgData() internal view virtual returns (bytes memory) {
307         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
308         return msg.data;
309     }
310 }
311 
312 
313 // File @openzeppelin/contracts/math/SafeMath.sol@v3.4.0
314 
315 pragma solidity >=0.6.0 <0.8.0;
316 
317 /**
318  * @dev Wrappers over Solidity's arithmetic operations with added overflow
319  * checks.
320  *
321  * Arithmetic operations in Solidity wrap on overflow. This can easily result
322  * in bugs, because programmers usually assume that an overflow raises an
323  * error, which is the standard behavior in high level programming languages.
324  * `SafeMath` restores this intuition by reverting the transaction when an
325  * operation overflows.
326  *
327  * Using this library instead of the unchecked operations eliminates an entire
328  * class of bugs, so it's recommended to use it always.
329  */
330 library SafeMath {
331     /**
332      * @dev Returns the addition of two unsigned integers, with an overflow flag.
333      *
334      * _Available since v3.4._
335      */
336     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
337         uint256 c = a + b;
338         if (c < a) return (false, 0);
339         return (true, c);
340     }
341 
342     /**
343      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
344      *
345      * _Available since v3.4._
346      */
347     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
348         if (b > a) return (false, 0);
349         return (true, a - b);
350     }
351 
352     /**
353      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
354      *
355      * _Available since v3.4._
356      */
357     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
358         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
359         // benefit is lost if 'b' is also tested.
360         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
361         if (a == 0) return (true, 0);
362         uint256 c = a * b;
363         if (c / a != b) return (false, 0);
364         return (true, c);
365     }
366 
367     /**
368      * @dev Returns the division of two unsigned integers, with a division by zero flag.
369      *
370      * _Available since v3.4._
371      */
372     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
373         if (b == 0) return (false, 0);
374         return (true, a / b);
375     }
376 
377     /**
378      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
379      *
380      * _Available since v3.4._
381      */
382     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
383         if (b == 0) return (false, 0);
384         return (true, a % b);
385     }
386 
387     /**
388      * @dev Returns the addition of two unsigned integers, reverting on
389      * overflow.
390      *
391      * Counterpart to Solidity's `+` operator.
392      *
393      * Requirements:
394      *
395      * - Addition cannot overflow.
396      */
397     function add(uint256 a, uint256 b) internal pure returns (uint256) {
398         uint256 c = a + b;
399         require(c >= a, "SafeMath: addition overflow");
400         return c;
401     }
402 
403     /**
404      * @dev Returns the subtraction of two unsigned integers, reverting on
405      * overflow (when the result is negative).
406      *
407      * Counterpart to Solidity's `-` operator.
408      *
409      * Requirements:
410      *
411      * - Subtraction cannot overflow.
412      */
413     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
414         require(b <= a, "SafeMath: subtraction overflow");
415         return a - b;
416     }
417 
418     /**
419      * @dev Returns the multiplication of two unsigned integers, reverting on
420      * overflow.
421      *
422      * Counterpart to Solidity's `*` operator.
423      *
424      * Requirements:
425      *
426      * - Multiplication cannot overflow.
427      */
428     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
429         if (a == 0) return 0;
430         uint256 c = a * b;
431         require(c / a == b, "SafeMath: multiplication overflow");
432         return c;
433     }
434 
435     /**
436      * @dev Returns the integer division of two unsigned integers, reverting on
437      * division by zero. The result is rounded towards zero.
438      *
439      * Counterpart to Solidity's `/` operator. Note: this function uses a
440      * `revert` opcode (which leaves remaining gas untouched) while Solidity
441      * uses an invalid opcode to revert (consuming all remaining gas).
442      *
443      * Requirements:
444      *
445      * - The divisor cannot be zero.
446      */
447     function div(uint256 a, uint256 b) internal pure returns (uint256) {
448         require(b > 0, "SafeMath: division by zero");
449         return a / b;
450     }
451 
452     /**
453      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
454      * reverting when dividing by zero.
455      *
456      * Counterpart to Solidity's `%` operator. This function uses a `revert`
457      * opcode (which leaves remaining gas untouched) while Solidity uses an
458      * invalid opcode to revert (consuming all remaining gas).
459      *
460      * Requirements:
461      *
462      * - The divisor cannot be zero.
463      */
464     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
465         require(b > 0, "SafeMath: modulo by zero");
466         return a % b;
467     }
468 
469     /**
470      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
471      * overflow (when the result is negative).
472      *
473      * CAUTION: This function is deprecated because it requires allocating memory for the error
474      * message unnecessarily. For custom revert reasons use {trySub}.
475      *
476      * Counterpart to Solidity's `-` operator.
477      *
478      * Requirements:
479      *
480      * - Subtraction cannot overflow.
481      */
482     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
483         require(b <= a, errorMessage);
484         return a - b;
485     }
486 
487     /**
488      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
489      * division by zero. The result is rounded towards zero.
490      *
491      * CAUTION: This function is deprecated because it requires allocating memory for the error
492      * message unnecessarily. For custom revert reasons use {tryDiv}.
493      *
494      * Counterpart to Solidity's `/` operator. Note: this function uses a
495      * `revert` opcode (which leaves remaining gas untouched) while Solidity
496      * uses an invalid opcode to revert (consuming all remaining gas).
497      *
498      * Requirements:
499      *
500      * - The divisor cannot be zero.
501      */
502     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
503         require(b > 0, errorMessage);
504         return a / b;
505     }
506 
507     /**
508      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
509      * reverting with custom message when dividing by zero.
510      *
511      * CAUTION: This function is deprecated because it requires allocating memory for the error
512      * message unnecessarily. For custom revert reasons use {tryMod}.
513      *
514      * Counterpart to Solidity's `%` operator. This function uses a `revert`
515      * opcode (which leaves remaining gas untouched) while Solidity uses an
516      * invalid opcode to revert (consuming all remaining gas).
517      *
518      * Requirements:
519      *
520      * - The divisor cannot be zero.
521      */
522     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
523         require(b > 0, errorMessage);
524         return a % b;
525     }
526 }
527 
528 
529 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v3.4.0
530 
531 pragma solidity >=0.6.0 <0.8.0;
532 
533 
534 
535 /**
536  * @dev Implementation of the {IERC20} interface.
537  *
538  * This implementation is agnostic to the way tokens are created. This means
539  * that a supply mechanism has to be added in a derived contract using {_mint}.
540  * For a generic mechanism see {ERC20PresetMinterPauser}.
541  *
542  * TIP: For a detailed writeup see our guide
543  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
544  * to implement supply mechanisms].
545  *
546  * We have followed general OpenZeppelin guidelines: functions revert instead
547  * of returning `false` on failure. This behavior is nonetheless conventional
548  * and does not conflict with the expectations of ERC20 applications.
549  *
550  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
551  * This allows applications to reconstruct the allowance for all accounts just
552  * by listening to said events. Other implementations of the EIP may not emit
553  * these events, as it isn't required by the specification.
554  *
555  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
556  * functions have been added to mitigate the well-known issues around setting
557  * allowances. See {IERC20-approve}.
558  */
559 contract ERC20 is Context, IERC20 {
560     using SafeMath for uint256;
561 
562     mapping (address => uint256) private _balances;
563 
564     mapping (address => mapping (address => uint256)) private _allowances;
565 
566     uint256 private _totalSupply;
567 
568     string private _name;
569     string private _symbol;
570     uint8 private _decimals;
571 
572     /**
573      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
574      * a default value of 18.
575      *
576      * To select a different value for {decimals}, use {_setupDecimals}.
577      *
578      * All three of these values are immutable: they can only be set once during
579      * construction.
580      */
581     constructor (string memory name_, string memory symbol_) public {
582         _name = name_;
583         _symbol = symbol_;
584         _decimals = 18;
585     }
586 
587     /**
588      * @dev Returns the name of the token.
589      */
590     function name() public view virtual returns (string memory) {
591         return _name;
592     }
593 
594     /**
595      * @dev Returns the symbol of the token, usually a shorter version of the
596      * name.
597      */
598     function symbol() public view virtual returns (string memory) {
599         return _symbol;
600     }
601 
602     /**
603      * @dev Returns the number of decimals used to get its user representation.
604      * For example, if `decimals` equals `2`, a balance of `505` tokens should
605      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
606      *
607      * Tokens usually opt for a value of 18, imitating the relationship between
608      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
609      * called.
610      *
611      * NOTE: This information is only used for _display_ purposes: it in
612      * no way affects any of the arithmetic of the contract, including
613      * {IERC20-balanceOf} and {IERC20-transfer}.
614      */
615     function decimals() public view virtual returns (uint8) {
616         return _decimals;
617     }
618 
619     /**
620      * @dev See {IERC20-totalSupply}.
621      */
622     function totalSupply() public view virtual override returns (uint256) {
623         return _totalSupply;
624     }
625 
626     /**
627      * @dev See {IERC20-balanceOf}.
628      */
629     function balanceOf(address account) public view virtual override returns (uint256) {
630         return _balances[account];
631     }
632 
633     /**
634      * @dev See {IERC20-transfer}.
635      *
636      * Requirements:
637      *
638      * - `recipient` cannot be the zero address.
639      * - the caller must have a balance of at least `amount`.
640      */
641     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
642         _transfer(_msgSender(), recipient, amount);
643         return true;
644     }
645 
646     /**
647      * @dev See {IERC20-allowance}.
648      */
649     function allowance(address owner, address spender) public view virtual override returns (uint256) {
650         return _allowances[owner][spender];
651     }
652 
653     /**
654      * @dev See {IERC20-approve}.
655      *
656      * Requirements:
657      *
658      * - `spender` cannot be the zero address.
659      */
660     function approve(address spender, uint256 amount) public virtual override returns (bool) {
661         _approve(_msgSender(), spender, amount);
662         return true;
663     }
664 
665     /**
666      * @dev See {IERC20-transferFrom}.
667      *
668      * Emits an {Approval} event indicating the updated allowance. This is not
669      * required by the EIP. See the note at the beginning of {ERC20}.
670      *
671      * Requirements:
672      *
673      * - `sender` and `recipient` cannot be the zero address.
674      * - `sender` must have a balance of at least `amount`.
675      * - the caller must have allowance for ``sender``'s tokens of at least
676      * `amount`.
677      */
678     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
679         _transfer(sender, recipient, amount);
680         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
681         return true;
682     }
683 
684     /**
685      * @dev Atomically increases the allowance granted to `spender` by the caller.
686      *
687      * This is an alternative to {approve} that can be used as a mitigation for
688      * problems described in {IERC20-approve}.
689      *
690      * Emits an {Approval} event indicating the updated allowance.
691      *
692      * Requirements:
693      *
694      * - `spender` cannot be the zero address.
695      */
696     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
697         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
698         return true;
699     }
700 
701     /**
702      * @dev Atomically decreases the allowance granted to `spender` by the caller.
703      *
704      * This is an alternative to {approve} that can be used as a mitigation for
705      * problems described in {IERC20-approve}.
706      *
707      * Emits an {Approval} event indicating the updated allowance.
708      *
709      * Requirements:
710      *
711      * - `spender` cannot be the zero address.
712      * - `spender` must have allowance for the caller of at least
713      * `subtractedValue`.
714      */
715     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
716         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
717         return true;
718     }
719 
720     /**
721      * @dev Moves tokens `amount` from `sender` to `recipient`.
722      *
723      * This is internal function is equivalent to {transfer}, and can be used to
724      * e.g. implement automatic token fees, slashing mechanisms, etc.
725      *
726      * Emits a {Transfer} event.
727      *
728      * Requirements:
729      *
730      * - `sender` cannot be the zero address.
731      * - `recipient` cannot be the zero address.
732      * - `sender` must have a balance of at least `amount`.
733      */
734     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
735         require(sender != address(0), "ERC20: transfer from the zero address");
736         require(recipient != address(0), "ERC20: transfer to the zero address");
737 
738         _beforeTokenTransfer(sender, recipient, amount);
739 
740         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
741         _balances[recipient] = _balances[recipient].add(amount);
742         emit Transfer(sender, recipient, amount);
743     }
744 
745     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
746      * the total supply.
747      *
748      * Emits a {Transfer} event with `from` set to the zero address.
749      *
750      * Requirements:
751      *
752      * - `to` cannot be the zero address.
753      */
754     function _mint(address account, uint256 amount) internal virtual {
755         require(account != address(0), "ERC20: mint to the zero address");
756 
757         _beforeTokenTransfer(address(0), account, amount);
758 
759         _totalSupply = _totalSupply.add(amount);
760         _balances[account] = _balances[account].add(amount);
761         emit Transfer(address(0), account, amount);
762     }
763 
764     /**
765      * @dev Destroys `amount` tokens from `account`, reducing the
766      * total supply.
767      *
768      * Emits a {Transfer} event with `to` set to the zero address.
769      *
770      * Requirements:
771      *
772      * - `account` cannot be the zero address.
773      * - `account` must have at least `amount` tokens.
774      */
775     function _burn(address account, uint256 amount) internal virtual {
776         require(account != address(0), "ERC20: burn from the zero address");
777 
778         _beforeTokenTransfer(account, address(0), amount);
779 
780         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
781         _totalSupply = _totalSupply.sub(amount);
782         emit Transfer(account, address(0), amount);
783     }
784 
785     /**
786      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
787      *
788      * This internal function is equivalent to `approve`, and can be used to
789      * e.g. set automatic allowances for certain subsystems, etc.
790      *
791      * Emits an {Approval} event.
792      *
793      * Requirements:
794      *
795      * - `owner` cannot be the zero address.
796      * - `spender` cannot be the zero address.
797      */
798     function _approve(address owner, address spender, uint256 amount) internal virtual {
799         require(owner != address(0), "ERC20: approve from the zero address");
800         require(spender != address(0), "ERC20: approve to the zero address");
801 
802         _allowances[owner][spender] = amount;
803         emit Approval(owner, spender, amount);
804     }
805 
806     /**
807      * @dev Sets {decimals} to a value other than the default one of 18.
808      *
809      * WARNING: This function should only be called from the constructor. Most
810      * applications that interact with token contracts will not expect
811      * {decimals} to ever change, and may work incorrectly if it does.
812      */
813     function _setupDecimals(uint8 decimals_) internal virtual {
814         _decimals = decimals_;
815     }
816 
817     /**
818      * @dev Hook that is called before any transfer of tokens. This includes
819      * minting and burning.
820      *
821      * Calling conditions:
822      *
823      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
824      * will be to transferred to `to`.
825      * - when `from` is zero, `amount` tokens will be minted for `to`.
826      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
827      * - `from` and `to` are never both zero.
828      *
829      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
830      */
831     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
832 }