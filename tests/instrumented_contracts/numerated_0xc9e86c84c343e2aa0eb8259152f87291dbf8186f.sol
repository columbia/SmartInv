1 // Dependency file: @openzeppelin/contracts/math/SafeMath.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 // pragma solidity >=0.6.0 <0.8.0;
6 
7 /**
8  * @dev Wrappers over Solidity's arithmetic operations with added overflow
9  * checks.
10  *
11  * Arithmetic operations in Solidity wrap on overflow. This can easily result
12  * in bugs, because programmers usually assume that an overflow raises an
13  * error, which is the standard behavior in high level programming languages.
14  * `SafeMath` restores this intuition by reverting the transaction when an
15  * operation overflows.
16  *
17  * Using this library instead of the unchecked operations eliminates an entire
18  * class of bugs, so it's recommended to use it always.
19  */
20 library SafeMath {
21 	/**
22 	 * @dev Returns the addition of two unsigned integers, with an overflow flag.
23 	 *
24 	 * _Available since v3.4._
25 	 */
26 	function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
27 		uint256 c = a + b;
28 		if (c < a) return (false, 0);
29 		return (true, c);
30 	}
31 
32 	/**
33 	 * @dev Returns the substraction of two unsigned integers, with an overflow flag.
34 	 *
35 	 * _Available since v3.4._
36 	 */
37 	function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
38 		if (b > a) return (false, 0);
39 		return (true, a - b);
40 	}
41 
42 	/**
43 	 * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
44 	 *
45 	 * _Available since v3.4._
46 	 */
47 	function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
48 		// Gas optimization: this is cheaper than requiring 'a' not being zero, but the
49 		// benefit is lost if 'b' is also tested.
50 		// See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
51 		if (a == 0) return (true, 0);
52 		uint256 c = a * b;
53 		if (c / a != b) return (false, 0);
54 		return (true, c);
55 	}
56 
57 	/**
58 	 * @dev Returns the division of two unsigned integers, with a division by zero flag.
59 	 *
60 	 * _Available since v3.4._
61 	 */
62 	function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
63 		if (b == 0) return (false, 0);
64 		return (true, a / b);
65 	}
66 
67 	/**
68 	 * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
69 	 *
70 	 * _Available since v3.4._
71 	 */
72 	function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
73 		if (b == 0) return (false, 0);
74 		return (true, a % b);
75 	}
76 
77 	/**
78 	 * @dev Returns the addition of two unsigned integers, reverting on
79 	 * overflow.
80 	 *
81 	 * Counterpart to Solidity's `+` operator.
82 	 *
83 	 * Requirements:
84 	 *
85 	 * - Addition cannot overflow.
86 	 */
87 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
88 		uint256 c = a + b;
89 		require(c >= a, 'SafeMath: addition overflow');
90 		return c;
91 	}
92 
93 	/**
94 	 * @dev Returns the subtraction of two unsigned integers, reverting on
95 	 * overflow (when the result is negative).
96 	 *
97 	 * Counterpart to Solidity's `-` operator.
98 	 *
99 	 * Requirements:
100 	 *
101 	 * - Subtraction cannot overflow.
102 	 */
103 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
104 		require(b <= a, 'SafeMath: subtraction overflow');
105 		return a - b;
106 	}
107 
108 	/**
109 	 * @dev Returns the multiplication of two unsigned integers, reverting on
110 	 * overflow.
111 	 *
112 	 * Counterpart to Solidity's `*` operator.
113 	 *
114 	 * Requirements:
115 	 *
116 	 * - Multiplication cannot overflow.
117 	 */
118 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
119 		if (a == 0) return 0;
120 		uint256 c = a * b;
121 		require(c / a == b, 'SafeMath: multiplication overflow');
122 		return c;
123 	}
124 
125 	/**
126 	 * @dev Returns the integer division of two unsigned integers, reverting on
127 	 * division by zero. The result is rounded towards zero.
128 	 *
129 	 * Counterpart to Solidity's `/` operator. Note: this function uses a
130 	 * `revert` opcode (which leaves remaining gas untouched) while Solidity
131 	 * uses an invalid opcode to revert (consuming all remaining gas).
132 	 *
133 	 * Requirements:
134 	 *
135 	 * - The divisor cannot be zero.
136 	 */
137 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
138 		require(b > 0, 'SafeMath: division by zero');
139 		return a / b;
140 	}
141 
142 	/**
143 	 * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
144 	 * reverting when dividing by zero.
145 	 *
146 	 * Counterpart to Solidity's `%` operator. This function uses a `revert`
147 	 * opcode (which leaves remaining gas untouched) while Solidity uses an
148 	 * invalid opcode to revert (consuming all remaining gas).
149 	 *
150 	 * Requirements:
151 	 *
152 	 * - The divisor cannot be zero.
153 	 */
154 	function mod(uint256 a, uint256 b) internal pure returns (uint256) {
155 		require(b > 0, 'SafeMath: modulo by zero');
156 		return a % b;
157 	}
158 
159 	/**
160 	 * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
161 	 * overflow (when the result is negative).
162 	 *
163 	 * CAUTION: This function is deprecated because it requires allocating memory for the error
164 	 * message unnecessarily. For custom revert reasons use {trySub}.
165 	 *
166 	 * Counterpart to Solidity's `-` operator.
167 	 *
168 	 * Requirements:
169 	 *
170 	 * - Subtraction cannot overflow.
171 	 */
172 	function sub(
173 		uint256 a,
174 		uint256 b,
175 		string memory errorMessage
176 	) internal pure returns (uint256) {
177 		require(b <= a, errorMessage);
178 		return a - b;
179 	}
180 
181 	/**
182 	 * @dev Returns the integer division of two unsigned integers, reverting with custom message on
183 	 * division by zero. The result is rounded towards zero.
184 	 *
185 	 * CAUTION: This function is deprecated because it requires allocating memory for the error
186 	 * message unnecessarily. For custom revert reasons use {tryDiv}.
187 	 *
188 	 * Counterpart to Solidity's `/` operator. Note: this function uses a
189 	 * `revert` opcode (which leaves remaining gas untouched) while Solidity
190 	 * uses an invalid opcode to revert (consuming all remaining gas).
191 	 *
192 	 * Requirements:
193 	 *
194 	 * - The divisor cannot be zero.
195 	 */
196 	function div(
197 		uint256 a,
198 		uint256 b,
199 		string memory errorMessage
200 	) internal pure returns (uint256) {
201 		require(b > 0, errorMessage);
202 		return a / b;
203 	}
204 
205 	/**
206 	 * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
207 	 * reverting with custom message when dividing by zero.
208 	 *
209 	 * CAUTION: This function is deprecated because it requires allocating memory for the error
210 	 * message unnecessarily. For custom revert reasons use {tryMod}.
211 	 *
212 	 * Counterpart to Solidity's `%` operator. This function uses a `revert`
213 	 * opcode (which leaves remaining gas untouched) while Solidity uses an
214 	 * invalid opcode to revert (consuming all remaining gas).
215 	 *
216 	 * Requirements:
217 	 *
218 	 * - The divisor cannot be zero.
219 	 */
220 	function mod(
221 		uint256 a,
222 		uint256 b,
223 		string memory errorMessage
224 	) internal pure returns (uint256) {
225 		require(b > 0, errorMessage);
226 		return a % b;
227 	}
228 }
229 
230 // Dependency file: @openzeppelin/contracts/cryptography/MerkleProof.sol
231 
232 // pragma solidity >=0.6.0 <0.8.0;
233 
234 /**
235  * @dev These functions deal with verification of Merkle trees (hash trees),
236  */
237 library MerkleProof {
238 	/**
239 	 * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
240 	 * defined by `root`. For this, a `proof` must be provided, containing
241 	 * sibling hashes on the branch from the leaf to the root of the tree. Each
242 	 * pair of leaves and each pair of pre-images are assumed to be sorted.
243 	 */
244 	function verify(
245 		bytes32[] memory proof,
246 		bytes32 root,
247 		bytes32 leaf
248 	) internal pure returns (bool) {
249 		bytes32 computedHash = leaf;
250 
251 		for (uint256 i = 0; i < proof.length; i++) {
252 			bytes32 proofElement = proof[i];
253 
254 			if (computedHash <= proofElement) {
255 				// Hash(current computed hash + current element of the proof)
256 				computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
257 			} else {
258 				// Hash(current element of the proof + current computed hash)
259 				computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
260 			}
261 		}
262 
263 		// Check if the computed hash (root) is equal to the provided root
264 		return computedHash == root;
265 	}
266 }
267 
268 // Dependency file: contracts/libraries/Upgradable.sol
269 
270 // pragma solidity >=0.6.5 <0.8.0;
271 
272 contract UpgradableProduct {
273 	address public impl;
274 
275 	event ImplChanged(address indexed _oldImpl, address indexed _newImpl);
276 
277 	constructor() public {
278 		impl = msg.sender;
279 	}
280 
281 	modifier requireImpl() {
282 		require(msg.sender == impl, 'FORBIDDEN');
283 		_;
284 	}
285 
286 	function upgradeImpl(address _newImpl) public requireImpl {
287 		require(_newImpl != address(0), 'INVALID_ADDRESS');
288 		require(_newImpl != impl, 'NO_CHANGE');
289 		address lastImpl = impl;
290 		impl = _newImpl;
291 		emit ImplChanged(lastImpl, _newImpl);
292 	}
293 }
294 
295 contract UpgradableGovernance {
296 	address public governor;
297 
298 	event GovernorChanged(address indexed _oldGovernor, address indexed _newGovernor);
299 
300 	constructor() public {
301 		governor = msg.sender;
302 	}
303 
304 	modifier requireGovernor() {
305 		require(msg.sender == governor, 'FORBIDDEN');
306 		_;
307 	}
308 
309 	function upgradeGovernance(address _newGovernor) public requireGovernor {
310 		require(_newGovernor != address(0), 'INVALID_ADDRESS');
311 		require(_newGovernor != governor, 'NO_CHANGE');
312 		address lastGovernor = governor;
313 		governor = _newGovernor;
314 		emit GovernorChanged(lastGovernor, _newGovernor);
315 	}
316 }
317 
318 // Dependency file: contracts/libraries/TransferHelper.sol
319 
320 // pragma solidity >=0.6.5 <0.8.0;
321 
322 library TransferHelper {
323 	function safeApprove(
324 		address token,
325 		address to,
326 		uint256 value
327 	) internal {
328 		// bytes4(keccak256(bytes('approve(address,uint256)')));
329 		(bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
330 		require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
331 	}
332 
333 	function safeTransfer(
334 		address token,
335 		address to,
336 		uint256 value
337 	) internal {
338 		// bytes4(keccak256(bytes('transfer(address,uint256)')));
339 		(bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
340 		require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
341 	}
342 
343 	function safeTransferFrom(
344 		address token,
345 		address from,
346 		address to,
347 		uint256 value
348 	) internal {
349 		// bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
350 		(bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
351 		require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
352 	}
353 
354 	function safeTransferETH(address to, uint256 value) internal {
355 		(bool success, ) = to.call{ value: value }(new bytes(0));
356 		require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
357 	}
358 }
359 
360 // Dependency file: contracts/libraries/WhiteList.sol
361 
362 // pragma solidity >=0.6.5 <0.8.0;
363 
364 pragma experimental ABIEncoderV2;
365 
366 // import "contracts/libraries/Upgradable.sol";
367 
368 contract WhiteList is UpgradableProduct {
369 	event SetWhitelist(address indexed user, bool state);
370 
371 	mapping(address => bool) public whiteList;
372 
373 	/// This function reverts if the caller is not governance
374 	///
375 	/// @param _toWhitelist the account to mint tokens to.
376 	/// @param _state the whitelist state.
377 	function setWhitelist(address _toWhitelist, bool _state) external requireImpl {
378 		whiteList[_toWhitelist] = _state;
379 		emit SetWhitelist(_toWhitelist, _state);
380 	}
381 
382 	/// @dev A modifier which checks if whitelisted for minting.
383 	modifier onlyWhitelisted() {
384 		require(whiteList[msg.sender], '!whitelisted');
385 		_;
386 	}
387 }
388 
389 // Dependency file: contracts/libraries/ConfigNames.sol
390 
391 // pragma solidity >=0.6.5 <0.8.0;
392 
393 library ConfigNames {
394 	bytes32 public constant FRYER_LTV = bytes32('FRYER_LTV');
395 	bytes32 public constant FRYER_HARVEST_FEE = bytes32('FRYER_HARVEST_FEE');
396 	bytes32 public constant FRYER_VAULT_PERCENTAGE = bytes32('FRYER_VAULT_PERCENTAGE');
397 
398 	bytes32 public constant FRYER_FLASH_FEE_PROPORTION = bytes32('FRYER_FLASH_FEE_PROPORTION');
399 
400 	bytes32 public constant PRIVATE = bytes32('PRIVATE');
401 	bytes32 public constant STAKE = bytes32('STAKE');
402 }
403 
404 // Dependency file: @openzeppelin/contracts/token/ERC20/IERC20.sol
405 
406 // pragma solidity >=0.6.0 <0.8.0;
407 
408 /**
409  * @dev Interface of the ERC20 standard as defined in the EIP.
410  */
411 interface IERC20 {
412 	/**
413 	 * @dev Returns the amount of tokens in existence.
414 	 */
415 	function totalSupply() external view returns (uint256);
416 
417 	/**
418 	 * @dev Returns the amount of tokens owned by `account`.
419 	 */
420 	function balanceOf(address account) external view returns (uint256);
421 
422 	/**
423 	 * @dev Moves `amount` tokens from the caller's account to `recipient`.
424 	 *
425 	 * Returns a boolean value indicating whether the operation succeeded.
426 	 *
427 	 * Emits a {Transfer} event.
428 	 */
429 	function transfer(address recipient, uint256 amount) external returns (bool);
430 
431 	/**
432 	 * @dev Returns the remaining number of tokens that `spender` will be
433 	 * allowed to spend on behalf of `owner` through {transferFrom}. This is
434 	 * zero by default.
435 	 *
436 	 * This value changes when {approve} or {transferFrom} are called.
437 	 */
438 	function allowance(address owner, address spender) external view returns (uint256);
439 
440 	/**
441 	 * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
442 	 *
443 	 * Returns a boolean value indicating whether the operation succeeded.
444 	 *
445 	 * IMPORTANT: Beware that changing an allowance with this method brings the risk
446 	 * that someone may use both the old and the new allowance by unfortunate
447 	 * transaction ordering. One possible solution to mitigate this race
448 	 * condition is to first reduce the spender's allowance to 0 and set the
449 	 * desired value afterwards:
450 	 * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
451 	 *
452 	 * Emits an {Approval} event.
453 	 */
454 	function approve(address spender, uint256 amount) external returns (bool);
455 
456 	/**
457 	 * @dev Moves `amount` tokens from `sender` to `recipient` using the
458 	 * allowance mechanism. `amount` is then deducted from the caller's
459 	 * allowance.
460 	 *
461 	 * Returns a boolean value indicating whether the operation succeeded.
462 	 *
463 	 * Emits a {Transfer} event.
464 	 */
465 	function transferFrom(
466 		address sender,
467 		address recipient,
468 		uint256 amount
469 	) external returns (bool);
470 
471 	/**
472 	 * @dev Emitted when `value` tokens are moved from one account (`from`) to
473 	 * another (`to`).
474 	 *
475 	 * Note that `value` may be zero.
476 	 */
477 	event Transfer(address indexed from, address indexed to, uint256 value);
478 
479 	/**
480 	 * @dev Emitted when the allowance of a `spender` for an `owner` is set by
481 	 * a call to {approve}. `value` is the new allowance.
482 	 */
483 	event Approval(address indexed owner, address indexed spender, uint256 value);
484 }
485 
486 // Dependency file: @openzeppelin/contracts/utils/Context.sol
487 
488 // pragma solidity >=0.6.0 <0.8.0;
489 
490 /*
491  * @dev Provides information about the current execution context, including the
492  * sender of the transaction and its data. While these are generally available
493  * via msg.sender and msg.data, they should not be accessed in such a direct
494  * manner, since when dealing with GSN meta-transactions the account sending and
495  * paying for execution may not be the actual sender (as far as an application
496  * is concerned).
497  *
498  * This contract is only required for intermediate, library-like contracts.
499  */
500 abstract contract Context {
501 	function _msgSender() internal view virtual returns (address payable) {
502 		return msg.sender;
503 	}
504 
505 	function _msgData() internal view virtual returns (bytes memory) {
506 		this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
507 		return msg.data;
508 	}
509 }
510 
511 // Dependency file: @openzeppelin/contracts/token/ERC20/ERC20.sol
512 
513 // pragma solidity >=0.6.0 <0.8.0;
514 
515 // import "@openzeppelin/contracts/utils/Context.sol";
516 // import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
517 // import "@openzeppelin/contracts/math/SafeMath.sol";
518 
519 /**
520  * @dev Implementation of the {IERC20} interface.
521  *
522  * This implementation is agnostic to the way tokens are created. This means
523  * that a supply mechanism has to be added in a derived contract using {_mint}.
524  * For a generic mechanism see {ERC20PresetMinterPauser}.
525  *
526  * TIP: For a detailed writeup see our guide
527  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
528  * to implement supply mechanisms].
529  *
530  * We have followed general OpenZeppelin guidelines: functions revert instead
531  * of returning `false` on failure. This behavior is nonetheless conventional
532  * and does not conflict with the expectations of ERC20 applications.
533  *
534  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
535  * This allows applications to reconstruct the allowance for all accounts just
536  * by listening to said events. Other implementations of the EIP may not emit
537  * these events, as it isn't required by the specification.
538  *
539  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
540  * functions have been added to mitigate the well-known issues around setting
541  * allowances. See {IERC20-approve}.
542  */
543 contract ERC20 is Context, IERC20 {
544 	using SafeMath for uint256;
545 
546 	mapping(address => uint256) private _balances;
547 
548 	mapping(address => mapping(address => uint256)) private _allowances;
549 
550 	uint256 private _totalSupply;
551 
552 	string private _name;
553 	string private _symbol;
554 	uint8 private _decimals;
555 
556 	/**
557 	 * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
558 	 * a default value of 18.
559 	 *
560 	 * To select a different value for {decimals}, use {_setupDecimals}.
561 	 *
562 	 * All three of these values are immutable: they can only be set once during
563 	 * construction.
564 	 */
565 	constructor(string memory name_, string memory symbol_) public {
566 		_name = name_;
567 		_symbol = symbol_;
568 		_decimals = 18;
569 	}
570 
571 	/**
572 	 * @dev Returns the name of the token.
573 	 */
574 	function name() public view virtual returns (string memory) {
575 		return _name;
576 	}
577 
578 	/**
579 	 * @dev Returns the symbol of the token, usually a shorter version of the
580 	 * name.
581 	 */
582 	function symbol() public view virtual returns (string memory) {
583 		return _symbol;
584 	}
585 
586 	/**
587 	 * @dev Returns the number of decimals used to get its user representation.
588 	 * For example, if `decimals` equals `2`, a balance of `505` tokens should
589 	 * be displayed to a user as `5,05` (`505 / 10 ** 2`).
590 	 *
591 	 * Tokens usually opt for a value of 18, imitating the relationship between
592 	 * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
593 	 * called.
594 	 *
595 	 * NOTE: This information is only used for _display_ purposes: it in
596 	 * no way affects any of the arithmetic of the contract, including
597 	 * {IERC20-balanceOf} and {IERC20-transfer}.
598 	 */
599 	function decimals() public view virtual returns (uint8) {
600 		return _decimals;
601 	}
602 
603 	/**
604 	 * @dev See {IERC20-totalSupply}.
605 	 */
606 	function totalSupply() public view virtual override returns (uint256) {
607 		return _totalSupply;
608 	}
609 
610 	/**
611 	 * @dev See {IERC20-balanceOf}.
612 	 */
613 	function balanceOf(address account) public view virtual override returns (uint256) {
614 		return _balances[account];
615 	}
616 
617 	/**
618 	 * @dev See {IERC20-transfer}.
619 	 *
620 	 * Requirements:
621 	 *
622 	 * - `recipient` cannot be the zero address.
623 	 * - the caller must have a balance of at least `amount`.
624 	 */
625 	function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
626 		_transfer(_msgSender(), recipient, amount);
627 		return true;
628 	}
629 
630 	/**
631 	 * @dev See {IERC20-allowance}.
632 	 */
633 	function allowance(address owner, address spender) public view virtual override returns (uint256) {
634 		return _allowances[owner][spender];
635 	}
636 
637 	/**
638 	 * @dev See {IERC20-approve}.
639 	 *
640 	 * Requirements:
641 	 *
642 	 * - `spender` cannot be the zero address.
643 	 */
644 	function approve(address spender, uint256 amount) public virtual override returns (bool) {
645 		_approve(_msgSender(), spender, amount);
646 		return true;
647 	}
648 
649 	/**
650 	 * @dev See {IERC20-transferFrom}.
651 	 *
652 	 * Emits an {Approval} event indicating the updated allowance. This is not
653 	 * required by the EIP. See the note at the beginning of {ERC20}.
654 	 *
655 	 * Requirements:
656 	 *
657 	 * - `sender` and `recipient` cannot be the zero address.
658 	 * - `sender` must have a balance of at least `amount`.
659 	 * - the caller must have allowance for ``sender``'s tokens of at least
660 	 * `amount`.
661 	 */
662 	function transferFrom(
663 		address sender,
664 		address recipient,
665 		uint256 amount
666 	) public virtual override returns (bool) {
667 		_transfer(sender, recipient, amount);
668 		_approve(
669 			sender,
670 			_msgSender(),
671 			_allowances[sender][_msgSender()].sub(amount, 'ERC20: transfer amount exceeds allowance')
672 		);
673 		return true;
674 	}
675 
676 	/**
677 	 * @dev Atomically increases the allowance granted to `spender` by the caller.
678 	 *
679 	 * This is an alternative to {approve} that can be used as a mitigation for
680 	 * problems described in {IERC20-approve}.
681 	 *
682 	 * Emits an {Approval} event indicating the updated allowance.
683 	 *
684 	 * Requirements:
685 	 *
686 	 * - `spender` cannot be the zero address.
687 	 */
688 	function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
689 		_approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
690 		return true;
691 	}
692 
693 	/**
694 	 * @dev Atomically decreases the allowance granted to `spender` by the caller.
695 	 *
696 	 * This is an alternative to {approve} that can be used as a mitigation for
697 	 * problems described in {IERC20-approve}.
698 	 *
699 	 * Emits an {Approval} event indicating the updated allowance.
700 	 *
701 	 * Requirements:
702 	 *
703 	 * - `spender` cannot be the zero address.
704 	 * - `spender` must have allowance for the caller of at least
705 	 * `subtractedValue`.
706 	 */
707 	function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
708 		_approve(
709 			_msgSender(),
710 			spender,
711 			_allowances[_msgSender()][spender].sub(subtractedValue, 'ERC20: decreased allowance below zero')
712 		);
713 		return true;
714 	}
715 
716 	/**
717 	 * @dev Moves tokens `amount` from `sender` to `recipient`.
718 	 *
719 	 * This is internal function is equivalent to {transfer}, and can be used to
720 	 * e.g. implement automatic token fees, slashing mechanisms, etc.
721 	 *
722 	 * Emits a {Transfer} event.
723 	 *
724 	 * Requirements:
725 	 *
726 	 * - `sender` cannot be the zero address.
727 	 * - `recipient` cannot be the zero address.
728 	 * - `sender` must have a balance of at least `amount`.
729 	 */
730 	function _transfer(
731 		address sender,
732 		address recipient,
733 		uint256 amount
734 	) internal virtual {
735 		require(sender != address(0), 'ERC20: transfer from the zero address');
736 		require(recipient != address(0), 'ERC20: transfer to the zero address');
737 
738 		_beforeTokenTransfer(sender, recipient, amount);
739 
740 		_balances[sender] = _balances[sender].sub(amount, 'ERC20: transfer amount exceeds balance');
741 		_balances[recipient] = _balances[recipient].add(amount);
742 		emit Transfer(sender, recipient, amount);
743 	}
744 
745 	/** @dev Creates `amount` tokens and assigns them to `account`, increasing
746 	 * the total supply.
747 	 *
748 	 * Emits a {Transfer} event with `from` set to the zero address.
749 	 *
750 	 * Requirements:
751 	 *
752 	 * - `to` cannot be the zero address.
753 	 */
754 	function _mint(address account, uint256 amount) internal virtual {
755 		require(account != address(0), 'ERC20: mint to the zero address');
756 
757 		_beforeTokenTransfer(address(0), account, amount);
758 
759 		_totalSupply = _totalSupply.add(amount);
760 		_balances[account] = _balances[account].add(amount);
761 		emit Transfer(address(0), account, amount);
762 	}
763 
764 	/**
765 	 * @dev Destroys `amount` tokens from `account`, reducing the
766 	 * total supply.
767 	 *
768 	 * Emits a {Transfer} event with `to` set to the zero address.
769 	 *
770 	 * Requirements:
771 	 *
772 	 * - `account` cannot be the zero address.
773 	 * - `account` must have at least `amount` tokens.
774 	 */
775 	function _burn(address account, uint256 amount) internal virtual {
776 		require(account != address(0), 'ERC20: burn from the zero address');
777 
778 		_beforeTokenTransfer(account, address(0), amount);
779 
780 		_balances[account] = _balances[account].sub(amount, 'ERC20: burn amount exceeds balance');
781 		_totalSupply = _totalSupply.sub(amount);
782 		emit Transfer(account, address(0), amount);
783 	}
784 
785 	/**
786 	 * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
787 	 *
788 	 * This internal function is equivalent to `approve`, and can be used to
789 	 * e.g. set automatic allowances for certain subsystems, etc.
790 	 *
791 	 * Emits an {Approval} event.
792 	 *
793 	 * Requirements:
794 	 *
795 	 * - `owner` cannot be the zero address.
796 	 * - `spender` cannot be the zero address.
797 	 */
798 	function _approve(
799 		address owner,
800 		address spender,
801 		uint256 amount
802 	) internal virtual {
803 		require(owner != address(0), 'ERC20: approve from the zero address');
804 		require(spender != address(0), 'ERC20: approve to the zero address');
805 
806 		_allowances[owner][spender] = amount;
807 		emit Approval(owner, spender, amount);
808 	}
809 
810 	/**
811 	 * @dev Sets {decimals} to a value other than the default one of 18.
812 	 *
813 	 * WARNING: This function should only be called from the constructor. Most
814 	 * applications that interact with token contracts will not expect
815 	 * {decimals} to ever change, and may work incorrectly if it does.
816 	 */
817 	function _setupDecimals(uint8 decimals_) internal virtual {
818 		_decimals = decimals_;
819 	}
820 
821 	/**
822 	 * @dev Hook that is called before any transfer of tokens. This includes
823 	 * minting and burning.
824 	 *
825 	 * Calling conditions:
826 	 *
827 	 * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
828 	 * will be to transferred to `to`.
829 	 * - when `from` is zero, `amount` tokens will be minted for `to`.
830 	 * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
831 	 * - `from` and `to` are never both zero.
832 	 *
833 	 * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
834 	 */
835 	function _beforeTokenTransfer(
836 		address from,
837 		address to,
838 		uint256 amount
839 	) internal virtual {}
840 }
841 
842 // Dependency file: contracts/CheeseToken.sol
843 
844 // pragma solidity >=0.6.5 <0.8.0;
845 
846 // import '/Users/sg99022ml/Desktop/chfry-protocol-internal/node_modules/@openzeppelin/contracts/token/ERC20/IERC20.sol';
847 // import '/Users/sg99022ml/Desktop/chfry-protocol-internal/node_modules/@openzeppelin/contracts/token/ERC20/ERC20.sol';
848 // import '/Users/sg99022ml/Desktop/chfry-protocol-internal/node_modules/@openzeppelin/contracts/math/SafeMath.sol';
849 // import 'contracts/libraries/Upgradable.sol';
850 
851 contract CheeseToken is ERC20, UpgradableProduct {
852 	using SafeMath for uint256;
853 
854 	mapping(address => bool) public whiteList;
855 
856 	constructor(string memory _symbol, string memory _name) public ERC20(_name, _symbol) {
857 		_mint(msg.sender, uint256(2328300).mul(1e18));
858 	}
859 
860 	modifier onlyWhitelisted() {
861 		require(whiteList[msg.sender], '!whitelisted');
862 		_;
863 	}
864 
865 	function setWhitelist(address _toWhitelist, bool _state) external requireImpl {
866 		whiteList[_toWhitelist] = _state;
867 	}
868 
869 	function mint(address account, uint256 amount) external virtual onlyWhitelisted {
870 		require(totalSupply().add(amount) <= cap(), 'ERC20Capped: cap exceeded');
871 		_mint(account, amount);
872 	}
873 
874 	function cap() public pure virtual returns (uint256) {
875 		return 9313200 * 1e18;
876 	}
877 
878 	function burnFrom(address account, uint256 amount) public virtual {
879 		uint256 decreasedAllowance = allowance(account, _msgSender()).sub(
880 			amount,
881 			'ERC20: burn amount exceeds allowance'
882 		);
883 		_approve(account, _msgSender(), decreasedAllowance);
884 		_burn(account, amount);
885 	}
886 
887 	function burn(uint256 amount) external virtual {
888 		_burn(_msgSender(), amount);
889 	}
890 }
891 
892 // Dependency file: @openzeppelin/contracts/utils/ReentrancyGuard.sol
893 
894 // pragma solidity >=0.6.0 <0.8.0;
895 
896 /**
897  * @dev Contract module that helps prevent reentrant calls to a function.
898  *
899  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
900  * available, which can be applied to functions to make sure there are no nested
901  * (reentrant) calls to them.
902  *
903  * Note that because there is a single `nonReentrant` guard, functions marked as
904  * `nonReentrant` may not call one another. This can be worked around by making
905  * those functions `private`, and then adding `external` `nonReentrant` entry
906  * points to them.
907  *
908  * TIP: If you would like to learn more about reentrancy and alternative ways
909  * to protect against it, check out our blog post
910  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
911  */
912 abstract contract ReentrancyGuard {
913 	// Booleans are more expensive than uint256 or any type that takes up a full
914 	// word because each write operation emits an extra SLOAD to first read the
915 	// slot's contents, replace the bits taken up by the boolean, and then write
916 	// back. This is the compiler's defense against contract upgrades and
917 	// pointer aliasing, and it cannot be disabled.
918 
919 	// The values being non-zero value makes deployment a bit more expensive,
920 	// but in exchange the refund on every call to nonReentrant will be lower in
921 	// amount. Since refunds are capped to a percentage of the total
922 	// transaction's gas, it is best to keep them low in cases like this one, to
923 	// increase the likelihood of the full refund coming into effect.
924 	uint256 private constant _NOT_ENTERED = 1;
925 	uint256 private constant _ENTERED = 2;
926 
927 	uint256 private _status;
928 
929 	constructor() internal {
930 		_status = _NOT_ENTERED;
931 	}
932 
933 	/**
934 	 * @dev Prevents a contract from calling itself, directly or indirectly.
935 	 * Calling a `nonReentrant` function from another `nonReentrant`
936 	 * function is not supported. It is possible to prevent this from happening
937 	 * by making the `nonReentrant` function external, and make it call a
938 	 * `private` function that does the actual work.
939 	 */
940 	modifier nonReentrant() {
941 		// On the first call to nonReentrant, _notEntered will be true
942 		require(_status != _ENTERED, 'ReentrancyGuard: reentrant call');
943 
944 		// Any calls to nonReentrant after this point will fail
945 		_status = _ENTERED;
946 
947 		_;
948 
949 		// By storing the original value once again, a refund is triggered (see
950 		// https://eips.ethereum.org/EIPS/eip-2200)
951 		_status = _NOT_ENTERED;
952 	}
953 }
954 
955 // Dependency file: contracts/CheeseFactory.sol
956 
957 // pragma solidity >=0.6.5 <0.8.0;
958 
959 // import '/Users/sg99022ml/Desktop/chfry-protocol-internal/node_modules/@openzeppelin/contracts/math/SafeMath.sol';
960 // import 'contracts/libraries/Upgradable.sol';
961 // import 'contracts/CheeseToken.sol';
962 // import 'contracts/libraries/ConfigNames.sol';
963 // import '/Users/sg99022ml/Desktop/chfry-protocol-internal/node_modules/@openzeppelin/contracts/utils/ReentrancyGuard.sol';
964 
965 //a1 = 75000, n = week, d= -390, week = [0,156]
966 //an=a1+(n-1)*d
967 //Sn=n*a1+(n(n-1)*d)/2
968 contract CheeseFactory is UpgradableProduct, ReentrancyGuard {
969 	using SafeMath for uint256;
970 
971 	uint256 public constant MAX_WEEK = 156;
972 	uint256 public constant d = 390 * 10**18;
973 	uint256 public constant a1 = 75000 * 10**18;
974 	uint256 public constant TOTAL_WEIGHT = 10000;
975 
976 	uint256 public startTimestamp;
977 	uint256 public lastTimestamp;
978 	uint256 public weekTimestamp;
979 	uint256 public totalMintAmount;
980 	CheeseToken public token;
981 	bool public initialized;
982 
983 	struct Pool {
984 		address pool;
985 		uint256 weight;
986 		uint256 minted;
987 	}
988 
989 	mapping(bytes32 => Pool) public poolInfo;
990 
991 	constructor(address token_, uint256 weekTimestamp_) public {
992 		weekTimestamp = weekTimestamp_;
993 		token = CheeseToken(token_);
994 	}
995 
996 	function setCheeseToken(address token_) external requireImpl {
997 		token = CheeseToken(token_);
998 	}
999 
1000 	function setPool(bytes32 poolName_, address poolAddress_) external requireImpl {
1001 		require(poolName_ == ConfigNames.PRIVATE || poolName_ == ConfigNames.STAKE, 'name error');
1002 		Pool storage pool = poolInfo[poolName_];
1003 		pool.pool = poolAddress_;
1004 	}
1005 
1006 	modifier expectInitialized() {
1007 		require(initialized, 'not initialized.');
1008 		_;
1009 	}
1010 
1011 	function initialize(
1012 		address private_,
1013 		address stake_,
1014 		uint256 startTimestamp_
1015 	) external requireImpl {
1016 		require(!initialized, 'already initialized');
1017 		require(startTimestamp_ >= block.timestamp, '!startTime');
1018 		// weight
1019 		poolInfo[ConfigNames.PRIVATE] = Pool(private_, 1000, 0);
1020 		poolInfo[ConfigNames.STAKE] = Pool(stake_, 9000, 0);
1021 		initialized = true;
1022 		startTimestamp = startTimestamp_;
1023 		lastTimestamp = startTimestamp_;
1024 	}
1025 
1026 	function preMint() public view returns (uint256) {
1027 		if (block.timestamp <= startTimestamp) {
1028 			return uint256(0);
1029 		}
1030 
1031 		if (block.timestamp <= lastTimestamp) {
1032 			return uint256(0);
1033 		}
1034 		uint256 time = block.timestamp.sub(startTimestamp);
1035 		uint256 max_week_time = MAX_WEEK.mul(weekTimestamp);
1036 		// time lt 156week
1037 		if (time > max_week_time) {
1038 			time = max_week_time;
1039 		}
1040 
1041 		// gt 1week
1042 		if (time >= weekTimestamp) {
1043 			uint256 n = time.div(weekTimestamp);
1044 
1045 			//an =a1-(n)*d d<0
1046 			//=> a1+(n)*(-d)
1047 			uint256 an = a1.sub(n.mul(d));
1048 
1049 			// gt 1week time stamp
1050 			uint256 otherTimestamp = time.mod(weekTimestamp);
1051 			uint256 other = an.mul(otherTimestamp).div(weekTimestamp);
1052 
1053 			//Sn=n*a1+(n(n-1)*d)/2 d<0
1054 			// => n*a1-(n(n-1)*(-d))/2
1055 
1056 			// fist = n*a1
1057 			uint256 first = n.mul(a1);
1058 			// last = (n(n-1)*(-d))/2
1059 			uint256 last = n.mul(n.sub(1)).mul(d).div(2);
1060 			uint256 sn = first.sub(last);
1061 			return other.add(sn).sub(totalMintAmount);
1062 		} else {
1063 			return a1.mul(time).div(weekTimestamp).sub(totalMintAmount);
1064 		}
1065 	}
1066 
1067 	function _updateTotalAmount() internal returns (uint256) {
1068 		uint256 preMintAmount = preMint();
1069 		totalMintAmount = totalMintAmount.add(preMintAmount);
1070 		lastTimestamp = block.timestamp;
1071 		return preMintAmount;
1072 	}
1073 
1074 	function prePoolMint(bytes32 poolName_) public view returns (uint256) {
1075 		uint256 preMintAmount = preMint();
1076 		Pool memory pool = poolInfo[poolName_];
1077 		uint256 poolTotal = totalMintAmount.add(preMintAmount).mul(pool.weight).div(TOTAL_WEIGHT);
1078 		return poolTotal.sub(pool.minted);
1079 	}
1080 
1081 	function poolMint(bytes32 poolName_) external nonReentrant expectInitialized returns (uint256) {
1082 		Pool storage pool = poolInfo[poolName_];
1083 		require(msg.sender == pool.pool, 'Permission denied');
1084 		_updateTotalAmount();
1085 		uint256 poolTotal = totalMintAmount.mul(pool.weight).div(TOTAL_WEIGHT);
1086 		uint256 amount = poolTotal.sub(pool.minted);
1087 		if (amount > 0) {
1088 			token.mint(msg.sender, amount);
1089 			pool.minted = pool.minted.add(amount);
1090 		}
1091 		return amount;
1092 	}
1093 }
1094 
1095 // Root file: contracts/CheeseStakePool.sol
1096 
1097 pragma solidity >=0.6.5 <0.8.0;
1098 
1099 
1100 contract CheeseStakePool is UpgradableProduct, ReentrancyGuard {
1101 	event AddPoolToken(address indexed pool, uint256 indexed weight);
1102 	event UpdatePoolToken(address indexed pool, uint256 indexed weight);
1103 
1104 	event Stake(address indexed pool, address indexed user, uint256 indexed amount);
1105 	event Withdraw(address indexed pool, address indexed user, uint256 indexed amount);
1106 	event Claimed(address indexed pool, address indexed user, uint256 indexed amount);
1107 	event SetCheeseFactory(address indexed factory);
1108 	event SetCheeseToken(address indexed token);
1109 	event SettleFlashLoan(bytes32 indexed merkleRoot, uint256 indexed index, uint256 amount, uint256 settleBlockNumber);
1110 	using TransferHelper for address;
1111 	using SafeMath for uint256;
1112 
1113 	struct UserInfo {
1114 		uint256 amount;
1115 		uint256 debt;
1116 		uint256 reward;
1117 		uint256 totalIncome;
1118 	}
1119 
1120 	struct PoolInfo {
1121 		uint256 pid;
1122 		address token;
1123 		uint256 weight;
1124 		uint256 rewardPerShare;
1125 		uint256 reward;
1126 		uint256 lastBlockTimeStamp;
1127 		uint256 debt;
1128 		uint256 totalAmount;
1129 	}
1130 
1131 	struct MerkleDistributor {
1132 		bytes32 merkleRoot;
1133 		uint256 index;
1134 		uint256 amount;
1135 		uint256 settleBlocNumber;
1136 	}
1137 
1138 	CheeseToken public token;
1139 	CheeseFactory public cheeseFactory;
1140 	PoolInfo[] public poolInfos;
1141 	PoolInfo public flashloanPool;
1142 
1143 	uint256 public lastBlockTimeStamp;
1144 	uint256 public rewardPerShare;
1145 	uint256 public totalWeight;
1146 
1147 	MerkleDistributor[] public merkleDistributors;
1148 
1149 	mapping(address => uint256) public tokenOfPid;
1150 	mapping(address => bool) public tokenUsed;
1151 
1152 	mapping(uint256 => mapping(address => UserInfo)) public userInfos;
1153 	mapping(uint256 => mapping(address => bool)) claimedFlashLoanState;
1154 
1155 	constructor(address cheeseFactory_, address token_) public {
1156 		cheeseFactory = CheeseFactory(cheeseFactory_);
1157 		token = CheeseToken(token_);
1158 		_initFlashLoanPool(0);
1159 	}
1160 
1161 	function _initFlashLoanPool(uint256 flashloanPoolWeight) internal {
1162 		flashloanPool = PoolInfo(0, address(this), flashloanPoolWeight, 0, 0, block.timestamp, 0, 0);
1163 		totalWeight = totalWeight.add(flashloanPool.weight);
1164 		emit AddPoolToken(address(this), flashloanPool.weight);
1165 	}
1166 
1167 	function setCheeseFactory(address cheeseFactory_) external requireImpl {
1168 		cheeseFactory = CheeseFactory(cheeseFactory_);
1169 		emit SetCheeseFactory(cheeseFactory_);
1170 	}
1171 
1172 	function setCheeseToken(address token_) external requireImpl {
1173 		token = CheeseToken(token_);
1174 		emit SetCheeseToken(token_);
1175 	}
1176 
1177 	modifier verifyPid(uint256 pid) {
1178 		require(poolInfos.length > pid && poolInfos[pid].token != address(0), 'pool does not exist');
1179 		_;
1180 	}
1181 
1182 	modifier updateAllPoolRewardPerShare() {
1183 		if (totalWeight > 0 && block.timestamp > lastBlockTimeStamp) {
1184 			(uint256 _reward, uint256 _perShare) = currentAllPoolRewardShare();
1185 			rewardPerShare = _perShare;
1186 			lastBlockTimeStamp = block.timestamp;
1187 			require(_reward == cheeseFactory.poolMint(ConfigNames.STAKE), 'pool mint error');
1188 		}
1189 		_;
1190 	}
1191 
1192 	modifier updateSinglePoolReward(PoolInfo storage poolInfo) {
1193 		if (poolInfo.weight > 0) {
1194 			uint256 debt = poolInfo.weight.mul(rewardPerShare).div(1e18);
1195 			uint256 poolReward = debt.sub(poolInfo.debt);
1196 			poolInfo.reward = poolInfo.reward.add(poolReward);
1197 			poolInfo.debt = debt;
1198 		}
1199 		_;
1200 	}
1201 
1202 	modifier updateSinglePoolRewardPerShare(PoolInfo storage poolInfo) {
1203 		if (poolInfo.totalAmount > 0 && block.timestamp > poolInfo.lastBlockTimeStamp) {
1204 			(uint256 _reward, uint256 _perShare) = currentSinglePoolRewardShare(poolInfo.pid);
1205 			poolInfo.rewardPerShare = _perShare;
1206 			poolInfo.reward = poolInfo.reward.sub(_reward);
1207 			poolInfo.lastBlockTimeStamp = block.timestamp;
1208 		}
1209 		_;
1210 	}
1211 
1212 	modifier updateUserReward(PoolInfo storage poolInfo, address user) {
1213 		UserInfo storage userInfo = userInfos[poolInfo.pid][user];
1214 		if (userInfo.amount > 0) {
1215 			uint256 debt = userInfo.amount.mul(poolInfo.rewardPerShare).div(1e18);
1216 			uint256 userReward = debt.sub(userInfo.debt);
1217 			userInfo.reward = userInfo.reward.add(userReward);
1218 			userInfo.debt = debt;
1219 		}
1220 		_;
1221 	}
1222 
1223 	function getPoolInfo(uint256 pid)
1224 		external
1225 		view
1226 		virtual
1227 		verifyPid(pid)
1228 		returns (
1229 			uint256 _pid,
1230 			address _token,
1231 			uint256 _weight,
1232 			uint256 _rewardPerShare,
1233 			uint256 _reward,
1234 			uint256 _lastBlockTimeStamp,
1235 			uint256 _debt,
1236 			uint256 _totalAmount
1237 		)
1238 	{
1239 		PoolInfo memory pool = poolInfos[pid];
1240 		return (
1241 			pool.pid,
1242 			pool.token,
1243 			pool.weight,
1244 			pool.rewardPerShare,
1245 			pool.reward,
1246 			pool.lastBlockTimeStamp,
1247 			pool.debt,
1248 			pool.totalAmount
1249 		);
1250 	}
1251 
1252 	function getPoolInfos()
1253 		external
1254 		view
1255 		virtual
1256 		returns (
1257 			uint256 length,
1258 			uint256[] memory _pid,
1259 			address[] memory _token,
1260 			uint256[] memory _weight,
1261 			uint256[] memory _lastBlockTimeStamp,
1262 			uint256[] memory _totalAmount
1263 		)
1264 	{
1265 		length = poolInfos.length;
1266 		_pid = new uint256[](length);
1267 		_token = new address[](length);
1268 		_weight = new uint256[](length);
1269 		_lastBlockTimeStamp = new uint256[](length);
1270 		_totalAmount = new uint256[](length);
1271 
1272 		for (uint256 i = 0; i < length; i++) {
1273 			PoolInfo memory pool = poolInfos[i];
1274 			_pid[i] = pool.pid;
1275 			_token[i] = pool.token;
1276 			_weight[i] = pool.weight;
1277 			_lastBlockTimeStamp[i] = pool.lastBlockTimeStamp;
1278 			_totalAmount[i] = pool.totalAmount;
1279 		}
1280 
1281 		return (length, _pid, _token, _weight, _lastBlockTimeStamp, _totalAmount);
1282 	}
1283 
1284 	function getUserInfo(uint256 pid, address userAddress)
1285 		external
1286 		view
1287 		virtual
1288 		returns (
1289 			uint256 _amount,
1290 			uint256 _debt,
1291 			uint256 _reward,
1292 			uint256 _totalIncome
1293 		)
1294 	{
1295 		UserInfo memory userInfo = userInfos[pid][userAddress];
1296 		return (userInfo.amount, userInfo.debt, userInfo.reward, userInfo.totalIncome);
1297 	}
1298 
1299 	function currentAllPoolRewardShare() public view virtual returns (uint256 _reward, uint256 _perShare) {
1300 		_reward = cheeseFactory.prePoolMint(ConfigNames.STAKE);
1301 		_perShare = rewardPerShare;
1302 
1303 		if (totalWeight > 0) {
1304 			_perShare = _perShare.add(_reward.mul(1e18).div(totalWeight));
1305 		}
1306 		return (_reward, _perShare);
1307 	}
1308 
1309 	function currentSinglePoolRewardShare(uint256 pid)
1310 		public
1311 		view
1312 		virtual
1313 		verifyPid(pid)
1314 		returns (uint256 _reward, uint256 _perShare)
1315 	{
1316 		PoolInfo memory poolInfo = poolInfos[pid];
1317 
1318 		_reward = poolInfo.reward;
1319 		_perShare = poolInfo.rewardPerShare;
1320 
1321 		if (poolInfo.totalAmount > 0) {
1322 			uint256 pendingShare = _reward.mul(1e18).div(poolInfo.totalAmount);
1323 			_perShare = _perShare.add(pendingShare);
1324 		}
1325 		return (_reward, _perShare);
1326 	}
1327 
1328 	function stake(uint256 pid, uint256 amount)
1329 		external
1330 		virtual
1331 		nonReentrant
1332 		verifyPid(pid)
1333 		updateAllPoolRewardPerShare
1334 		updateSinglePoolReward(poolInfos[pid])
1335 		updateSinglePoolRewardPerShare(poolInfos[pid])
1336 		updateUserReward(poolInfos[pid], msg.sender)
1337 	{
1338 		PoolInfo storage poolInfo = poolInfos[pid];
1339 
1340 		if (amount > 0) {
1341 			UserInfo storage userInfo = userInfos[pid][msg.sender];
1342 			userInfo.amount = userInfo.amount.add(amount);
1343 			userInfo.debt = userInfo.amount.mul(poolInfo.rewardPerShare).div(1e18);
1344 			poolInfo.totalAmount = poolInfo.totalAmount.add(amount);
1345 			address(poolInfo.token).safeTransferFrom(msg.sender, address(this), amount);
1346 			emit Stake(poolInfo.token, msg.sender, amount);
1347 		}
1348 	}
1349 
1350 	function withdraw(uint256 pid, uint256 amount)
1351 		external
1352 		virtual
1353 		nonReentrant
1354 		verifyPid(pid)
1355 		updateAllPoolRewardPerShare
1356 		updateSinglePoolReward(poolInfos[pid])
1357 		updateSinglePoolRewardPerShare(poolInfos[pid])
1358 		updateUserReward(poolInfos[pid], msg.sender)
1359 	{
1360 		PoolInfo storage poolInfo = poolInfos[pid];
1361 
1362 		if (amount > 0) {
1363 			UserInfo storage userInfo = userInfos[pid][msg.sender];
1364 			require(userInfo.amount >= amount, 'Insufficient balance');
1365 			userInfo.amount = userInfo.amount.sub(amount);
1366 			userInfo.debt = userInfo.amount.mul(poolInfo.rewardPerShare).div(1e18);
1367 			poolInfo.totalAmount = poolInfo.totalAmount.sub(amount);
1368 			address(poolInfo.token).safeTransfer(msg.sender, amount);
1369 			emit Withdraw(poolInfo.token, msg.sender, amount);
1370 		}
1371 	}
1372 
1373 	function claim(uint256 pid)
1374 		external
1375 		virtual
1376 		nonReentrant
1377 		verifyPid(pid)
1378 		updateAllPoolRewardPerShare
1379 		updateSinglePoolReward(poolInfos[pid])
1380 		updateSinglePoolRewardPerShare(poolInfos[pid])
1381 		updateUserReward(poolInfos[pid], msg.sender)
1382 	{
1383 		PoolInfo storage poolInfo = poolInfos[pid];
1384 		UserInfo storage userInfo = userInfos[pid][msg.sender];
1385 		if (userInfo.reward > 0) {
1386 			uint256 amount = userInfo.reward;
1387 			userInfo.reward = 0;
1388 			userInfo.totalIncome = userInfo.totalIncome.add(amount);
1389 			address(token).safeTransfer(msg.sender, amount);
1390 			emit Claimed(poolInfo.token, msg.sender, amount);
1391 		}
1392 	}
1393 
1394 	function calculateIncome(uint256 pid, address userAddress) external view virtual verifyPid(pid) returns (uint256) {
1395 		PoolInfo storage poolInfo = poolInfos[pid];
1396 		UserInfo storage userInfo = userInfos[pid][userAddress];
1397 
1398 		(uint256 _reward, uint256 _perShare) = currentAllPoolRewardShare();
1399 
1400 		uint256 poolPendingReward = poolInfo.weight.mul(_perShare).div(1e18).sub(poolInfo.debt);
1401 		_reward = poolInfo.reward.add(poolPendingReward);
1402 		_perShare = poolInfo.rewardPerShare;
1403 
1404 		if (block.timestamp > poolInfo.lastBlockTimeStamp && poolInfo.totalAmount > 0) {
1405 			uint256 poolPendingShare = _reward.mul(1e18).div(poolInfo.totalAmount);
1406 			_perShare = _perShare.add(poolPendingShare);
1407 		}
1408 		uint256 userReward = userInfo.amount.mul(_perShare).div(1e18).sub(userInfo.debt);
1409 		return userInfo.reward.add(userReward);
1410 	}
1411 
1412 	function isClaimedFlashLoan(uint256 index, address user) public view returns (bool) {
1413 		return claimedFlashLoanState[index][user];
1414 	}
1415 
1416 	function settleFlashLoan(
1417 		uint256 index,
1418 		uint256 amount,
1419 		uint256 settleBlockNumber,
1420 		bytes32 merkleRoot
1421 	) external requireImpl updateAllPoolRewardPerShare updateSinglePoolReward(flashloanPool) {
1422 		require(index == merkleDistributors.length, 'index already exists');
1423 		require(flashloanPool.reward >= amount, 'Insufficient reward funds');
1424 		require(block.number >= settleBlockNumber, '!blockNumber');
1425 
1426 		if (merkleDistributors.length > 0) {
1427 			MerkleDistributor memory md = merkleDistributors[merkleDistributors.length - 1];
1428 			require(md.settleBlocNumber < settleBlockNumber, '!settleBlocNumber');
1429 		}
1430 
1431 		flashloanPool.reward = flashloanPool.reward.sub(amount);
1432 		merkleDistributors.push(MerkleDistributor(merkleRoot, index, amount, settleBlockNumber));
1433 		emit SettleFlashLoan(merkleRoot, index, amount, settleBlockNumber);
1434 	}
1435 
1436 	function claimFlashLoan(
1437 		uint256 index,
1438 		uint256 amount,
1439 		bytes32[] calldata proof
1440 	) external {
1441 		address user = msg.sender;
1442 		require(merkleDistributors.length > index, 'Invalid index');
1443 		require(!isClaimedFlashLoan(index, user), 'Drop already claimed.');
1444 		MerkleDistributor storage merkleDistributor = merkleDistributors[index];
1445 		require(merkleDistributor.amount >= amount, 'Not sufficient');
1446 		bytes32 leaf = keccak256(abi.encodePacked(index, user, amount));
1447 		require(MerkleProof.verify(proof, merkleDistributor.merkleRoot, leaf), 'Invalid proof.');
1448 		merkleDistributor.amount = merkleDistributor.amount.sub(amount);
1449 		claimedFlashLoanState[index][user] = true;
1450 		address(token).safeTransfer(msg.sender, amount);
1451 		emit Claimed(address(this), user, amount);
1452 	}
1453 
1454 	function addPool(address tokenAddr, uint256 weight) external virtual requireImpl updateAllPoolRewardPerShare {
1455 		require(weight >= 0 && tokenAddr != address(0) && tokenUsed[tokenAddr] == false, 'Check the parameters');
1456 		uint256 pid = poolInfos.length;
1457 		uint256 debt = weight.mul(rewardPerShare).div(1e18);
1458 		poolInfos.push(PoolInfo(pid, tokenAddr, weight, 0, 0, block.timestamp, debt, 0));
1459 		tokenOfPid[tokenAddr] = pid;
1460 		tokenUsed[tokenAddr] = true;
1461 		totalWeight = totalWeight.add(weight);
1462 		emit AddPoolToken(tokenAddr, weight);
1463 	}
1464 
1465 	function _updatePool(PoolInfo storage poolInfo, uint256 weight) internal {
1466 		totalWeight = totalWeight.sub(poolInfo.weight);
1467 		poolInfo.weight = weight;
1468 		poolInfo.debt = poolInfo.weight.mul(rewardPerShare).div(1e18);
1469 		totalWeight = totalWeight.add(weight);
1470 	}
1471 
1472 	function updatePool(address tokenAddr, uint256 weight)
1473 		external
1474 		virtual
1475 		requireImpl
1476 		verifyPid(tokenOfPid[tokenAddr])
1477 		updateAllPoolRewardPerShare
1478 		updateSinglePoolReward(poolInfos[tokenOfPid[tokenAddr]])
1479 		updateSinglePoolRewardPerShare(poolInfos[tokenOfPid[tokenAddr]])
1480 	{
1481 		require(weight >= 0 && tokenAddr != address(0), 'Parameter error');
1482 		PoolInfo storage poolInfo = poolInfos[tokenOfPid[tokenAddr]];
1483 		require(poolInfo.token == tokenAddr, 'pool does not exist');
1484 		_updatePool(poolInfo, weight);
1485 		emit UpdatePoolToken(address(poolInfo.token), weight);
1486 	}
1487 
1488 	function updateFlashloanPool(uint256 weight)
1489 		external
1490 		virtual
1491 		requireImpl
1492 		updateAllPoolRewardPerShare
1493 		updateSinglePoolReward(flashloanPool)
1494 	{
1495 		require(weight >= 0, 'Parameter error');
1496 		_updatePool(flashloanPool, weight);
1497 		emit UpdatePoolToken(address(flashloanPool.token), weight);
1498 	}
1499 }