1 // File: @openzeppelin/contracts/GSN/Context.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with GSN meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 contract Context {
16 	// Empty internal constructor, to prevent people from mistakenly deploying
17 	// an instance of this contract, which should be used via inheritance.
18 	constructor() internal {}
19 
20 	// solhint-disable-previous-line no-empty-blocks
21 
22 	function _msgSender() internal view returns (address payable) {
23 		return msg.sender;
24 	}
25 
26 	function _msgData() internal view returns (bytes memory) {
27 		this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
28 		return msg.data;
29 	}
30 }
31 
32 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
33 
34 pragma solidity ^0.5.0;
35 
36 /**
37  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
38  * the optional functions; to access them see {ERC20Detailed}.
39  */
40 interface IERC20 {
41 	/**
42 	 * @dev Returns the amount of tokens in existence.
43 	 */
44 	function totalSupply() external view returns (uint256);
45 
46 	/**
47 	 * @dev Returns the amount of tokens owned by `account`.
48 	 */
49 	function balanceOf(address account) external view returns (uint256);
50 
51 	/**
52 	 * @dev Moves `amount` tokens from the caller's account to `recipient`.
53 	 *
54 	 * Returns a boolean value indicating whether the operation succeeded.
55 	 *
56 	 * Emits a {Transfer} event.
57 	 */
58 	function transfer(address recipient, uint256 amount)
59 		external
60 		returns (bool);
61 
62 	/**
63 	 * @dev Returns the remaining number of tokens that `spender` will be
64 	 * allowed to spend on behalf of `owner` through {transferFrom}. This is
65 	 * zero by default.
66 	 *
67 	 * This value changes when {approve} or {transferFrom} are called.
68 	 */
69 	function allowance(address owner, address spender)
70 		external
71 		view
72 		returns (uint256);
73 
74 	/**
75 	 * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
76 	 *
77 	 * Returns a boolean value indicating whether the operation succeeded.
78 	 *
79 	 * IMPORTANT: Beware that changing an allowance with this method brings the risk
80 	 * that someone may use both the old and the new allowance by unfortunate
81 	 * transaction ordering. One possible solution to mitigate this race
82 	 * condition is to first reduce the spender's allowance to 0 and set the
83 	 * desired value afterwards:
84 	 * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
85 	 *
86 	 * Emits an {Approval} event.
87 	 */
88 	function approve(address spender, uint256 amount) external returns (bool);
89 
90 	/**
91 	 * @dev Moves `amount` tokens from `sender` to `recipient` using the
92 	 * allowance mechanism. `amount` is then deducted from the caller's
93 	 * allowance.
94 	 *
95 	 * Returns a boolean value indicating whether the operation succeeded.
96 	 *
97 	 * Emits a {Transfer} event.
98 	 */
99 	function transferFrom(
100 		address sender,
101 		address recipient,
102 		uint256 amount
103 	) external returns (bool);
104 
105 	/**
106 	 * @dev Emitted when `value` tokens are moved from one account (`from`) to
107 	 * another (`to`).
108 	 *
109 	 * Note that `value` may be zero.
110 	 */
111 	event Transfer(address indexed from, address indexed to, uint256 value);
112 
113 	/**
114 	 * @dev Emitted when the allowance of a `spender` for an `owner` is set by
115 	 * a call to {approve}. `value` is the new allowance.
116 	 */
117 	event Approval(
118 		address indexed owner,
119 		address indexed spender,
120 		uint256 value
121 	);
122 }
123 
124 // File: @openzeppelin/contracts/math/SafeMath.sol
125 
126 pragma solidity ^0.5.0;
127 
128 /**
129  * @dev Wrappers over Solidity's arithmetic operations with added overflow
130  * checks.
131  *
132  * Arithmetic operations in Solidity wrap on overflow. This can easily result
133  * in bugs, because programmers usually assume that an overflow raises an
134  * error, which is the standard behavior in high level programming languages.
135  * `SafeMath` restores this intuition by reverting the transaction when an
136  * operation overflows.
137  *
138  * Using this library instead of the unchecked operations eliminates an entire
139  * class of bugs, so it's recommended to use it always.
140  */
141 library SafeMath {
142 	/**
143 	 * @dev Returns the addition of two unsigned integers, reverting on
144 	 * overflow.
145 	 *
146 	 * Counterpart to Solidity's `+` operator.
147 	 *
148 	 * Requirements:
149 	 * - Addition cannot overflow.
150 	 */
151 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
152 		uint256 c = a + b;
153 		require(c >= a, "SafeMath: addition overflow");
154 
155 		return c;
156 	}
157 
158 	/**
159 	 * @dev Returns the subtraction of two unsigned integers, reverting on
160 	 * overflow (when the result is negative).
161 	 *
162 	 * Counterpart to Solidity's `-` operator.
163 	 *
164 	 * Requirements:
165 	 * - Subtraction cannot overflow.
166 	 */
167 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
168 		return sub(a, b, "SafeMath: subtraction overflow");
169 	}
170 
171 	/**
172 	 * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
173 	 * overflow (when the result is negative).
174 	 *
175 	 * Counterpart to Solidity's `-` operator.
176 	 *
177 	 * Requirements:
178 	 * - Subtraction cannot overflow.
179 	 *
180 	 * _Available since v2.4.0._
181 	 */
182 	function sub(
183 		uint256 a,
184 		uint256 b,
185 		string memory errorMessage
186 	) internal pure returns (uint256) {
187 		require(b <= a, errorMessage);
188 		uint256 c = a - b;
189 
190 		return c;
191 	}
192 
193 	/**
194 	 * @dev Returns the multiplication of two unsigned integers, reverting on
195 	 * overflow.
196 	 *
197 	 * Counterpart to Solidity's `*` operator.
198 	 *
199 	 * Requirements:
200 	 * - Multiplication cannot overflow.
201 	 */
202 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
203 		// Gas optimization: this is cheaper than requiring 'a' not being zero, but the
204 		// benefit is lost if 'b' is also tested.
205 		// See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
206 		if (a == 0) {
207 			return 0;
208 		}
209 
210 		uint256 c = a * b;
211 		require(c / a == b, "SafeMath: multiplication overflow");
212 
213 		return c;
214 	}
215 
216 	/**
217 	 * @dev Returns the integer division of two unsigned integers. Reverts on
218 	 * division by zero. The result is rounded towards zero.
219 	 *
220 	 * Counterpart to Solidity's `/` operator. Note: this function uses a
221 	 * `revert` opcode (which leaves remaining gas untouched) while Solidity
222 	 * uses an invalid opcode to revert (consuming all remaining gas).
223 	 *
224 	 * Requirements:
225 	 * - The divisor cannot be zero.
226 	 */
227 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
228 		return div(a, b, "SafeMath: division by zero");
229 	}
230 
231 	/**
232 	 * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
233 	 * division by zero. The result is rounded towards zero.
234 	 *
235 	 * Counterpart to Solidity's `/` operator. Note: this function uses a
236 	 * `revert` opcode (which leaves remaining gas untouched) while Solidity
237 	 * uses an invalid opcode to revert (consuming all remaining gas).
238 	 *
239 	 * Requirements:
240 	 * - The divisor cannot be zero.
241 	 *
242 	 * _Available since v2.4.0._
243 	 */
244 	function div(
245 		uint256 a,
246 		uint256 b,
247 		string memory errorMessage
248 	) internal pure returns (uint256) {
249 		// Solidity only automatically asserts when dividing by 0
250 		require(b > 0, errorMessage);
251 		uint256 c = a / b;
252 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
253 
254 		return c;
255 	}
256 
257 	/**
258 	 * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
259 	 * Reverts when dividing by zero.
260 	 *
261 	 * Counterpart to Solidity's `%` operator. This function uses a `revert`
262 	 * opcode (which leaves remaining gas untouched) while Solidity uses an
263 	 * invalid opcode to revert (consuming all remaining gas).
264 	 *
265 	 * Requirements:
266 	 * - The divisor cannot be zero.
267 	 */
268 	function mod(uint256 a, uint256 b) internal pure returns (uint256) {
269 		return mod(a, b, "SafeMath: modulo by zero");
270 	}
271 
272 	/**
273 	 * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
274 	 * Reverts with custom message when dividing by zero.
275 	 *
276 	 * Counterpart to Solidity's `%` operator. This function uses a `revert`
277 	 * opcode (which leaves remaining gas untouched) while Solidity uses an
278 	 * invalid opcode to revert (consuming all remaining gas).
279 	 *
280 	 * Requirements:
281 	 * - The divisor cannot be zero.
282 	 *
283 	 * _Available since v2.4.0._
284 	 */
285 	function mod(
286 		uint256 a,
287 		uint256 b,
288 		string memory errorMessage
289 	) internal pure returns (uint256) {
290 		require(b != 0, errorMessage);
291 		return a % b;
292 	}
293 }
294 
295 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
296 
297 pragma solidity ^0.5.0;
298 
299 /**
300  * @dev Implementation of the {IERC20} interface.
301  *
302  * This implementation is agnostic to the way tokens are created. This means
303  * that a supply mechanism has to be added in a derived contract using {_mint}.
304  * For a generic mechanism see {ERC20Mintable}.
305  *
306  * TIP: For a detailed writeup see our guide
307  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
308  * to implement supply mechanisms].
309  *
310  * We have followed general OpenZeppelin guidelines: functions revert instead
311  * of returning `false` on failure. This behavior is nonetheless conventional
312  * and does not conflict with the expectations of ERC20 applications.
313  *
314  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
315  * This allows applications to reconstruct the allowance for all accounts just
316  * by listening to said events. Other implementations of the EIP may not emit
317  * these events, as it isn't required by the specification.
318  *
319  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
320  * functions have been added to mitigate the well-known issues around setting
321  * allowances. See {IERC20-approve}.
322  */
323 contract ERC20 is Context, IERC20 {
324 	using SafeMath for uint256;
325 
326 	mapping(address => uint256) private _balances;
327 
328 	mapping(address => mapping(address => uint256)) private _allowances;
329 
330 	uint256 private _totalSupply;
331 
332 	/**
333 	 * @dev See {IERC20-totalSupply}.
334 	 */
335 	function totalSupply() public view returns (uint256) {
336 		return _totalSupply;
337 	}
338 
339 	/**
340 	 * @dev See {IERC20-balanceOf}.
341 	 */
342 	function balanceOf(address account) public view returns (uint256) {
343 		return _balances[account];
344 	}
345 
346 	/**
347 	 * @dev See {IERC20-transfer}.
348 	 *
349 	 * Requirements:
350 	 *
351 	 * - `recipient` cannot be the zero address.
352 	 * - the caller must have a balance of at least `amount`.
353 	 */
354 	function transfer(address recipient, uint256 amount) public returns (bool) {
355 		_transfer(_msgSender(), recipient, amount);
356 		return true;
357 	}
358 
359 	/**
360 	 * @dev See {IERC20-allowance}.
361 	 */
362 	function allowance(address owner, address spender)
363 		public
364 		view
365 		returns (uint256)
366 	{
367 		return _allowances[owner][spender];
368 	}
369 
370 	/**
371 	 * @dev See {IERC20-approve}.
372 	 *
373 	 * Requirements:
374 	 *
375 	 * - `spender` cannot be the zero address.
376 	 */
377 	function approve(address spender, uint256 amount) public returns (bool) {
378 		_approve(_msgSender(), spender, amount);
379 		return true;
380 	}
381 
382 	/**
383 	 * @dev See {IERC20-transferFrom}.
384 	 *
385 	 * Emits an {Approval} event indicating the updated allowance. This is not
386 	 * required by the EIP. See the note at the beginning of {ERC20};
387 	 *
388 	 * Requirements:
389 	 * - `sender` and `recipient` cannot be the zero address.
390 	 * - `sender` must have a balance of at least `amount`.
391 	 * - the caller must have allowance for `sender`'s tokens of at least
392 	 * `amount`.
393 	 */
394 	function transferFrom(
395 		address sender,
396 		address recipient,
397 		uint256 amount
398 	) public returns (bool) {
399 		_transfer(sender, recipient, amount);
400 		_approve(
401 			sender,
402 			_msgSender(),
403 			_allowances[sender][_msgSender()].sub(
404 				amount,
405 				"ERC20: transfer amount exceeds allowance"
406 			)
407 		);
408 		return true;
409 	}
410 
411 	/**
412 	 * @dev Atomically increases the allowance granted to `spender` by the caller.
413 	 *
414 	 * This is an alternative to {approve} that can be used as a mitigation for
415 	 * problems described in {IERC20-approve}.
416 	 *
417 	 * Emits an {Approval} event indicating the updated allowance.
418 	 *
419 	 * Requirements:
420 	 *
421 	 * - `spender` cannot be the zero address.
422 	 */
423 	function increaseAllowance(address spender, uint256 addedValue)
424 		public
425 		returns (bool)
426 	{
427 		_approve(
428 			_msgSender(),
429 			spender,
430 			_allowances[_msgSender()][spender].add(addedValue)
431 		);
432 		return true;
433 	}
434 
435 	/**
436 	 * @dev Atomically decreases the allowance granted to `spender` by the caller.
437 	 *
438 	 * This is an alternative to {approve} that can be used as a mitigation for
439 	 * problems described in {IERC20-approve}.
440 	 *
441 	 * Emits an {Approval} event indicating the updated allowance.
442 	 *
443 	 * Requirements:
444 	 *
445 	 * - `spender` cannot be the zero address.
446 	 * - `spender` must have allowance for the caller of at least
447 	 * `subtractedValue`.
448 	 */
449 	function decreaseAllowance(address spender, uint256 subtractedValue)
450 		public
451 		returns (bool)
452 	{
453 		_approve(
454 			_msgSender(),
455 			spender,
456 			_allowances[_msgSender()][spender].sub(
457 				subtractedValue,
458 				"ERC20: decreased allowance below zero"
459 			)
460 		);
461 		return true;
462 	}
463 
464 	/**
465 	 * @dev Moves tokens `amount` from `sender` to `recipient`.
466 	 *
467 	 * This is internal function is equivalent to {transfer}, and can be used to
468 	 * e.g. implement automatic token fees, slashing mechanisms, etc.
469 	 *
470 	 * Emits a {Transfer} event.
471 	 *
472 	 * Requirements:
473 	 *
474 	 * - `sender` cannot be the zero address.
475 	 * - `recipient` cannot be the zero address.
476 	 * - `sender` must have a balance of at least `amount`.
477 	 */
478 	function _transfer(
479 		address sender,
480 		address recipient,
481 		uint256 amount
482 	) internal {
483 		require(sender != address(0), "ERC20: transfer from the zero address");
484 		require(recipient != address(0), "ERC20: transfer to the zero address");
485 
486 		_balances[sender] = _balances[sender].sub(
487 			amount,
488 			"ERC20: transfer amount exceeds balance"
489 		);
490 		_balances[recipient] = _balances[recipient].add(amount);
491 		emit Transfer(sender, recipient, amount);
492 	}
493 
494 	/** @dev Creates `amount` tokens and assigns them to `account`, increasing
495 	 * the total supply.
496 	 *
497 	 * Emits a {Transfer} event with `from` set to the zero address.
498 	 *
499 	 * Requirements
500 	 *
501 	 * - `to` cannot be the zero address.
502 	 */
503 	function _mint(address account, uint256 amount) internal {
504 		require(account != address(0), "ERC20: mint to the zero address");
505 
506 		_totalSupply = _totalSupply.add(amount);
507 		_balances[account] = _balances[account].add(amount);
508 		emit Transfer(address(0), account, amount);
509 	}
510 
511 	/**
512 	 * @dev Destroys `amount` tokens from `account`, reducing the
513 	 * total supply.
514 	 *
515 	 * Emits a {Transfer} event with `to` set to the zero address.
516 	 *
517 	 * Requirements
518 	 *
519 	 * - `account` cannot be the zero address.
520 	 * - `account` must have at least `amount` tokens.
521 	 */
522 	function _burn(address account, uint256 amount) internal {
523 		require(account != address(0), "ERC20: burn from the zero address");
524 
525 		_balances[account] = _balances[account].sub(
526 			amount,
527 			"ERC20: burn amount exceeds balance"
528 		);
529 		_totalSupply = _totalSupply.sub(amount);
530 		emit Transfer(account, address(0), amount);
531 	}
532 
533 	/**
534 	 * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
535 	 *
536 	 * This is internal function is equivalent to `approve`, and can be used to
537 	 * e.g. set automatic allowances for certain subsystems, etc.
538 	 *
539 	 * Emits an {Approval} event.
540 	 *
541 	 * Requirements:
542 	 *
543 	 * - `owner` cannot be the zero address.
544 	 * - `spender` cannot be the zero address.
545 	 */
546 	function _approve(
547 		address owner,
548 		address spender,
549 		uint256 amount
550 	) internal {
551 		require(owner != address(0), "ERC20: approve from the zero address");
552 		require(spender != address(0), "ERC20: approve to the zero address");
553 
554 		_allowances[owner][spender] = amount;
555 		emit Approval(owner, spender, amount);
556 	}
557 
558 	/**
559 	 * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
560 	 * from the caller's allowance.
561 	 *
562 	 * See {_burn} and {_approve}.
563 	 */
564 	function _burnFrom(address account, uint256 amount) internal {
565 		_burn(account, amount);
566 		_approve(
567 			account,
568 			_msgSender(),
569 			_allowances[account][_msgSender()].sub(
570 				amount,
571 				"ERC20: burn amount exceeds allowance"
572 			)
573 		);
574 	}
575 }
576 
577 // File: @openzeppelin/contracts/access/Roles.sol
578 
579 pragma solidity ^0.5.0;
580 
581 /**
582  * @title Roles
583  * @dev Library for managing addresses assigned to a Role.
584  */
585 library Roles {
586 	struct Role {
587 		mapping(address => bool) bearer;
588 	}
589 
590 	/**
591 	 * @dev Give an account access to this role.
592 	 */
593 	function add(Role storage role, address account) internal {
594 		require(!has(role, account), "Roles: account already has role");
595 		role.bearer[account] = true;
596 	}
597 
598 	/**
599 	 * @dev Remove an account's access to this role.
600 	 */
601 	function remove(Role storage role, address account) internal {
602 		require(has(role, account), "Roles: account does not have role");
603 		role.bearer[account] = false;
604 	}
605 
606 	/**
607 	 * @dev Check if an account has this role.
608 	 * @return bool
609 	 */
610 	function has(Role storage role, address account)
611 		internal
612 		view
613 		returns (bool)
614 	{
615 		require(account != address(0), "Roles: account is the zero address");
616 		return role.bearer[account];
617 	}
618 }
619 
620 // File: @openzeppelin/contracts/access/roles/MinterRole.sol
621 
622 pragma solidity ^0.5.0;
623 
624 contract MinterRole is Context {
625 	using Roles for Roles.Role;
626 
627 	event MinterAdded(address indexed account);
628 	event MinterRemoved(address indexed account);
629 
630 	Roles.Role private _minters;
631 
632 	constructor() internal {
633 		_addMinter(_msgSender());
634 	}
635 
636 	modifier onlyMinter() {
637 		require(
638 			isMinter(_msgSender()),
639 			"MinterRole: caller does not have the Minter role"
640 		);
641 		_;
642 	}
643 
644 	function isMinter(address account) public view returns (bool) {
645 		return _minters.has(account);
646 	}
647 
648 	function addMinter(address account) public onlyMinter {
649 		_addMinter(account);
650 	}
651 
652 	function renounceMinter() public {
653 		_removeMinter(_msgSender());
654 	}
655 
656 	function _addMinter(address account) internal {
657 		_minters.add(account);
658 		emit MinterAdded(account);
659 	}
660 
661 	function _removeMinter(address account) internal {
662 		_minters.remove(account);
663 		emit MinterRemoved(account);
664 	}
665 }
666 
667 // File: @openzeppelin/contracts/token/ERC20/ERC20Mintable.sol
668 
669 pragma solidity ^0.5.0;
670 
671 /**
672  * @dev Extension of {ERC20} that adds a set of accounts with the {MinterRole},
673  * which have permission to mint (create) new tokens as they see fit.
674  *
675  * At construction, the deployer of the contract is the only minter.
676  */
677 contract ERC20Mintable is ERC20, MinterRole {
678 	/**
679 	 * @dev See {ERC20-_mint}.
680 	 *
681 	 * Requirements:
682 	 *
683 	 * - the caller must have the {MinterRole}.
684 	 */
685 	function mint(address account, uint256 amount)
686 		public
687 		onlyMinter
688 		returns (bool)
689 	{
690 		_mint(account, amount);
691 		return true;
692 	}
693 }
694 
695 // File: contracts/src/common/libs/Decimals.sol
696 
697 pragma solidity ^0.5.0;
698 
699 /**
700  * Library for emulating calculations involving decimals.
701  */
702 library Decimals {
703 	using SafeMath for uint256;
704 	uint120 private constant basisValue = 1000000000000000000;
705 
706 	/**
707 	 * Returns the ratio of the first argument to the second argument.
708 	 */
709 	function outOf(uint256 _a, uint256 _b)
710 		internal
711 		pure
712 		returns (uint256 result)
713 	{
714 		if (_a == 0) {
715 			return 0;
716 		}
717 		uint256 a = _a.mul(basisValue);
718 		if (a < _b) {
719 			return 0;
720 		}
721 		return (a.div(_b));
722 	}
723 
724 	/**
725 	 * Returns multiplied the number by 10^18.
726 	 * This is used when there is a very large difference between the two numbers passed to the `outOf` function.
727 	 */
728 	function mulBasis(uint256 _a) internal pure returns (uint256) {
729 		return _a.mul(basisValue);
730 	}
731 
732 	/**
733 	 * Returns by changing the numerical value being emulated to the original number of digits.
734 	 */
735 	function divBasis(uint256 _a) internal pure returns (uint256) {
736 		return _a.div(basisValue);
737 	}
738 }
739 
740 // File: contracts/src/common/interface/IGroup.sol
741 
742 pragma solidity ^0.5.0;
743 
744 contract IGroup {
745 	function isGroup(address _addr) public view returns (bool);
746 
747 	function addGroup(address _addr) external;
748 
749 	function getGroupKey(address _addr) internal pure returns (bytes32) {
750 		return keccak256(abi.encodePacked("_group", _addr));
751 	}
752 }
753 
754 // File: contracts/src/common/validate/AddressValidator.sol
755 
756 pragma solidity ^0.5.0;
757 
758 /**
759  * A module that provides common validations patterns.
760  */
761 contract AddressValidator {
762 	string constant errorMessage = "this is illegal address";
763 
764 	/**
765 	 * Validates passed address is not a zero address.
766 	 */
767 	function validateIllegalAddress(address _addr) external pure {
768 		require(_addr != address(0), errorMessage);
769 	}
770 
771 	/**
772 	 * Validates passed address is included in an address set.
773 	 */
774 	function validateGroup(address _addr, address _groupAddr) external view {
775 		require(IGroup(_groupAddr).isGroup(_addr), errorMessage);
776 	}
777 
778 	/**
779 	 * Validates passed address is included in two address sets.
780 	 */
781 	function validateGroups(
782 		address _addr,
783 		address _groupAddr1,
784 		address _groupAddr2
785 	) external view {
786 		if (IGroup(_groupAddr1).isGroup(_addr)) {
787 			return;
788 		}
789 		require(IGroup(_groupAddr2).isGroup(_addr), errorMessage);
790 	}
791 
792 	/**
793 	 * Validates that the address of the first argument is equal to the address of the second argument.
794 	 */
795 	function validateAddress(address _addr, address _target) external pure {
796 		require(_addr == _target, errorMessage);
797 	}
798 
799 	/**
800 	 * Validates passed address equals to the two addresses.
801 	 */
802 	function validateAddresses(
803 		address _addr,
804 		address _target1,
805 		address _target2
806 	) external pure {
807 		if (_addr == _target1) {
808 			return;
809 		}
810 		require(_addr == _target2, errorMessage);
811 	}
812 
813 	/**
814 	 * Validates passed address equals to the three addresses.
815 	 */
816 	function validate3Addresses(
817 		address _addr,
818 		address _target1,
819 		address _target2,
820 		address _target3
821 	) external pure {
822 		if (_addr == _target1) {
823 			return;
824 		}
825 		if (_addr == _target2) {
826 			return;
827 		}
828 		require(_addr == _target3, errorMessage);
829 	}
830 }
831 
832 // File: contracts/src/common/validate/UsingValidator.sol
833 
834 pragma solidity ^0.5.0;
835 
836 // prettier-ignore
837 
838 /**
839  * Module for contrast handling AddressValidator.
840  */
841 contract UsingValidator {
842 	AddressValidator private _validator;
843 
844 	/**
845 	 * Create a new AddressValidator contract when initialize.
846 	 */
847 	constructor() public {
848 		_validator = new AddressValidator();
849 	}
850 
851 	/**
852 	 * Returns the set AddressValidator address.
853 	 */
854 	function addressValidator() internal view returns (AddressValidator) {
855 		return _validator;
856 	}
857 }
858 
859 // File: contracts/src/property/IProperty.sol
860 
861 pragma solidity ^0.5.0;
862 
863 contract IProperty {
864 	function author() external view returns (address);
865 
866 	function withdraw(address _sender, uint256 _value) external;
867 }
868 
869 // File: contracts/src/common/lifecycle/Killable.sol
870 
871 pragma solidity ^0.5.0;
872 
873 /**
874  * A module that allows contracts to self-destruct.
875  */
876 contract Killable {
877 	address payable public _owner;
878 
879 	/**
880 	 * Initialized with the deployer as the owner.
881 	 */
882 	constructor() internal {
883 		_owner = msg.sender;
884 	}
885 
886 	/**
887 	 * Self-destruct the contract.
888 	 * This function can only be executed by the owner.
889 	 */
890 	function kill() public {
891 		require(msg.sender == _owner, "only owner method");
892 		selfdestruct(_owner);
893 	}
894 }
895 
896 // File: @openzeppelin/contracts/ownership/Ownable.sol
897 
898 pragma solidity ^0.5.0;
899 
900 /**
901  * @dev Contract module which provides a basic access control mechanism, where
902  * there is an account (an owner) that can be granted exclusive access to
903  * specific functions.
904  *
905  * This module is used through inheritance. It will make available the modifier
906  * `onlyOwner`, which can be applied to your functions to restrict their use to
907  * the owner.
908  */
909 contract Ownable is Context {
910 	address private _owner;
911 
912 	event OwnershipTransferred(
913 		address indexed previousOwner,
914 		address indexed newOwner
915 	);
916 
917 	/**
918 	 * @dev Initializes the contract setting the deployer as the initial owner.
919 	 */
920 	constructor() internal {
921 		address msgSender = _msgSender();
922 		_owner = msgSender;
923 		emit OwnershipTransferred(address(0), msgSender);
924 	}
925 
926 	/**
927 	 * @dev Returns the address of the current owner.
928 	 */
929 	function owner() public view returns (address) {
930 		return _owner;
931 	}
932 
933 	/**
934 	 * @dev Throws if called by any account other than the owner.
935 	 */
936 	modifier onlyOwner() {
937 		require(isOwner(), "Ownable: caller is not the owner");
938 		_;
939 	}
940 
941 	/**
942 	 * @dev Returns true if the caller is the current owner.
943 	 */
944 	function isOwner() public view returns (bool) {
945 		return _msgSender() == _owner;
946 	}
947 
948 	/**
949 	 * @dev Leaves the contract without owner. It will not be possible to call
950 	 * `onlyOwner` functions anymore. Can only be called by the current owner.
951 	 *
952 	 * NOTE: Renouncing ownership will leave the contract without an owner,
953 	 * thereby removing any functionality that is only available to the owner.
954 	 */
955 	function renounceOwnership() public onlyOwner {
956 		emit OwnershipTransferred(_owner, address(0));
957 		_owner = address(0);
958 	}
959 
960 	/**
961 	 * @dev Transfers ownership of the contract to a new account (`newOwner`).
962 	 * Can only be called by the current owner.
963 	 */
964 	function transferOwnership(address newOwner) public onlyOwner {
965 		_transferOwnership(newOwner);
966 	}
967 
968 	/**
969 	 * @dev Transfers ownership of the contract to a new account (`newOwner`).
970 	 */
971 	function _transferOwnership(address newOwner) internal {
972 		require(
973 			newOwner != address(0),
974 			"Ownable: new owner is the zero address"
975 		);
976 		emit OwnershipTransferred(_owner, newOwner);
977 		_owner = newOwner;
978 	}
979 }
980 
981 // File: contracts/src/common/config/AddressConfig.sol
982 
983 pragma solidity ^0.5.0;
984 
985 /**
986  * A registry contract to hold the latest contract addresses.
987  * Dev Protocol will be upgradeable by this contract.
988  */
989 contract AddressConfig is Ownable, UsingValidator, Killable {
990 	address public token = 0x98626E2C9231f03504273d55f397409deFD4a093;
991 	address public allocator;
992 	address public allocatorStorage;
993 	address public withdraw;
994 	address public withdrawStorage;
995 	address public marketFactory;
996 	address public marketGroup;
997 	address public propertyFactory;
998 	address public propertyGroup;
999 	address public metricsGroup;
1000 	address public metricsFactory;
1001 	address public policy;
1002 	address public policyFactory;
1003 	address public policySet;
1004 	address public policyGroup;
1005 	address public lockup;
1006 	address public lockupStorage;
1007 	address public voteTimes;
1008 	address public voteTimesStorage;
1009 	address public voteCounter;
1010 	address public voteCounterStorage;
1011 
1012 	/**
1013 	 * Set the latest Allocator contract address.
1014 	 * Only the owner can execute this function.
1015 	 */
1016 	function setAllocator(address _addr) external onlyOwner {
1017 		allocator = _addr;
1018 	}
1019 
1020 	/**
1021 	 * Set the latest AllocatorStorage contract address.
1022 	 * Only the owner can execute this function.
1023 	 * NOTE: But currently, the AllocatorStorage contract is not used.
1024 	 */
1025 	function setAllocatorStorage(address _addr) external onlyOwner {
1026 		allocatorStorage = _addr;
1027 	}
1028 
1029 	/**
1030 	 * Set the latest Withdraw contract address.
1031 	 * Only the owner can execute this function.
1032 	 */
1033 	function setWithdraw(address _addr) external onlyOwner {
1034 		withdraw = _addr;
1035 	}
1036 
1037 	/**
1038 	 * Set the latest WithdrawStorage contract address.
1039 	 * Only the owner can execute this function.
1040 	 */
1041 	function setWithdrawStorage(address _addr) external onlyOwner {
1042 		withdrawStorage = _addr;
1043 	}
1044 
1045 	/**
1046 	 * Set the latest MarketFactory contract address.
1047 	 * Only the owner can execute this function.
1048 	 */
1049 	function setMarketFactory(address _addr) external onlyOwner {
1050 		marketFactory = _addr;
1051 	}
1052 
1053 	/**
1054 	 * Set the latest MarketGroup contract address.
1055 	 * Only the owner can execute this function.
1056 	 */
1057 	function setMarketGroup(address _addr) external onlyOwner {
1058 		marketGroup = _addr;
1059 	}
1060 
1061 	/**
1062 	 * Set the latest PropertyFactory contract address.
1063 	 * Only the owner can execute this function.
1064 	 */
1065 	function setPropertyFactory(address _addr) external onlyOwner {
1066 		propertyFactory = _addr;
1067 	}
1068 
1069 	/**
1070 	 * Set the latest PropertyGroup contract address.
1071 	 * Only the owner can execute this function.
1072 	 */
1073 	function setPropertyGroup(address _addr) external onlyOwner {
1074 		propertyGroup = _addr;
1075 	}
1076 
1077 	/**
1078 	 * Set the latest MetricsFactory contract address.
1079 	 * Only the owner can execute this function.
1080 	 */
1081 	function setMetricsFactory(address _addr) external onlyOwner {
1082 		metricsFactory = _addr;
1083 	}
1084 
1085 	/**
1086 	 * Set the latest MetricsGroup contract address.
1087 	 * Only the owner can execute this function.
1088 	 */
1089 	function setMetricsGroup(address _addr) external onlyOwner {
1090 		metricsGroup = _addr;
1091 	}
1092 
1093 	/**
1094 	 * Set the latest PolicyFactory contract address.
1095 	 * Only the owner can execute this function.
1096 	 */
1097 	function setPolicyFactory(address _addr) external onlyOwner {
1098 		policyFactory = _addr;
1099 	}
1100 
1101 	/**
1102 	 * Set the latest PolicyGroup contract address.
1103 	 * Only the owner can execute this function.
1104 	 */
1105 	function setPolicyGroup(address _addr) external onlyOwner {
1106 		policyGroup = _addr;
1107 	}
1108 
1109 	/**
1110 	 * Set the latest PolicySet contract address.
1111 	 * Only the owner can execute this function.
1112 	 */
1113 	function setPolicySet(address _addr) external onlyOwner {
1114 		policySet = _addr;
1115 	}
1116 
1117 	/**
1118 	 * Set the latest Policy contract address.
1119 	 * Only the latest PolicyFactory contract can execute this function.
1120 	 */
1121 	function setPolicy(address _addr) external {
1122 		addressValidator().validateAddress(msg.sender, policyFactory);
1123 		policy = _addr;
1124 	}
1125 
1126 	/**
1127 	 * Set the latest Dev contract address.
1128 	 * Only the owner can execute this function.
1129 	 */
1130 	function setToken(address _addr) external onlyOwner {
1131 		token = _addr;
1132 	}
1133 
1134 	/**
1135 	 * Set the latest Lockup contract address.
1136 	 * Only the owner can execute this function.
1137 	 */
1138 	function setLockup(address _addr) external onlyOwner {
1139 		lockup = _addr;
1140 	}
1141 
1142 	/**
1143 	 * Set the latest LockupStorage contract address.
1144 	 * Only the owner can execute this function.
1145 	 * NOTE: But currently, the LockupStorage contract is not used as a stand-alone because it is inherited from the Lockup contract.
1146 	 */
1147 	function setLockupStorage(address _addr) external onlyOwner {
1148 		lockupStorage = _addr;
1149 	}
1150 
1151 	/**
1152 	 * Set the latest VoteTimes contract address.
1153 	 * Only the owner can execute this function.
1154 	 * NOTE: But currently, the VoteTimes contract is not used.
1155 	 */
1156 	function setVoteTimes(address _addr) external onlyOwner {
1157 		voteTimes = _addr;
1158 	}
1159 
1160 	/**
1161 	 * Set the latest VoteTimesStorage contract address.
1162 	 * Only the owner can execute this function.
1163 	 * NOTE: But currently, the VoteTimesStorage contract is not used.
1164 	 */
1165 	function setVoteTimesStorage(address _addr) external onlyOwner {
1166 		voteTimesStorage = _addr;
1167 	}
1168 
1169 	/**
1170 	 * Set the latest VoteCounter contract address.
1171 	 * Only the owner can execute this function.
1172 	 */
1173 	function setVoteCounter(address _addr) external onlyOwner {
1174 		voteCounter = _addr;
1175 	}
1176 
1177 	/**
1178 	 * Set the latest VoteCounterStorage contract address.
1179 	 * Only the owner can execute this function.
1180 	 * NOTE: But currently, the VoteCounterStorage contract is not used as a stand-alone because it is inherited from the VoteCounter contract.
1181 	 */
1182 	function setVoteCounterStorage(address _addr) external onlyOwner {
1183 		voteCounterStorage = _addr;
1184 	}
1185 }
1186 
1187 // File: contracts/src/common/config/UsingConfig.sol
1188 
1189 pragma solidity ^0.5.0;
1190 
1191 /**
1192  * Module for using AddressConfig contracts.
1193  */
1194 contract UsingConfig {
1195 	AddressConfig private _config;
1196 
1197 	/**
1198 	 * Initialize the argument as AddressConfig address.
1199 	 */
1200 	constructor(address _addressConfig) public {
1201 		_config = AddressConfig(_addressConfig);
1202 	}
1203 
1204 	/**
1205 	 * Returns the latest AddressConfig instance.
1206 	 */
1207 	function config() internal view returns (AddressConfig) {
1208 		return _config;
1209 	}
1210 
1211 	/**
1212 	 * Returns the latest AddressConfig address.
1213 	 */
1214 	function configAddress() external view returns (address) {
1215 		return address(_config);
1216 	}
1217 }
1218 
1219 // File: contracts/src/common/storage/EternalStorage.sol
1220 
1221 pragma solidity ^0.5.0;
1222 
1223 /**
1224  * Module for persisting states.
1225  * Stores a map for `uint256`, `string`, `address`, `bytes32`, `bool`, and `int256` type with `bytes32` type as a key.
1226  */
1227 contract EternalStorage {
1228 	address private currentOwner = msg.sender;
1229 
1230 	mapping(bytes32 => uint256) private uIntStorage;
1231 	mapping(bytes32 => string) private stringStorage;
1232 	mapping(bytes32 => address) private addressStorage;
1233 	mapping(bytes32 => bytes32) private bytesStorage;
1234 	mapping(bytes32 => bool) private boolStorage;
1235 	mapping(bytes32 => int256) private intStorage;
1236 
1237 	/**
1238 	 * Modifiers to validate that only the owner can execute.
1239 	 */
1240 	modifier onlyCurrentOwner() {
1241 		require(msg.sender == currentOwner, "not current owner");
1242 		_;
1243 	}
1244 
1245 	/**
1246 	 * Transfer the owner.
1247 	 * Only the owner can execute this function.
1248 	 */
1249 	function changeOwner(address _newOwner) external {
1250 		require(msg.sender == currentOwner, "not current owner");
1251 		currentOwner = _newOwner;
1252 	}
1253 
1254 	// *** Getter Methods ***
1255 
1256 	/**
1257 	 * Returns the value of the `uint256` type that mapped to the given key.
1258 	 */
1259 	function getUint(bytes32 _key) external view returns (uint256) {
1260 		return uIntStorage[_key];
1261 	}
1262 
1263 	/**
1264 	 * Returns the value of the `string` type that mapped to the given key.
1265 	 */
1266 	function getString(bytes32 _key) external view returns (string memory) {
1267 		return stringStorage[_key];
1268 	}
1269 
1270 	/**
1271 	 * Returns the value of the `address` type that mapped to the given key.
1272 	 */
1273 	function getAddress(bytes32 _key) external view returns (address) {
1274 		return addressStorage[_key];
1275 	}
1276 
1277 	/**
1278 	 * Returns the value of the `bytes32` type that mapped to the given key.
1279 	 */
1280 	function getBytes(bytes32 _key) external view returns (bytes32) {
1281 		return bytesStorage[_key];
1282 	}
1283 
1284 	/**
1285 	 * Returns the value of the `bool` type that mapped to the given key.
1286 	 */
1287 	function getBool(bytes32 _key) external view returns (bool) {
1288 		return boolStorage[_key];
1289 	}
1290 
1291 	/**
1292 	 * Returns the value of the `int256` type that mapped to the given key.
1293 	 */
1294 	function getInt(bytes32 _key) external view returns (int256) {
1295 		return intStorage[_key];
1296 	}
1297 
1298 	// *** Setter Methods ***
1299 
1300 	/**
1301 	 * Maps a value of `uint256` type to a given key.
1302 	 * Only the owner can execute this function.
1303 	 */
1304 	function setUint(bytes32 _key, uint256 _value) external onlyCurrentOwner {
1305 		uIntStorage[_key] = _value;
1306 	}
1307 
1308 	/**
1309 	 * Maps a value of `string` type to a given key.
1310 	 * Only the owner can execute this function.
1311 	 */
1312 	function setString(bytes32 _key, string calldata _value)
1313 		external
1314 		onlyCurrentOwner
1315 	{
1316 		stringStorage[_key] = _value;
1317 	}
1318 
1319 	/**
1320 	 * Maps a value of `address` type to a given key.
1321 	 * Only the owner can execute this function.
1322 	 */
1323 	function setAddress(bytes32 _key, address _value)
1324 		external
1325 		onlyCurrentOwner
1326 	{
1327 		addressStorage[_key] = _value;
1328 	}
1329 
1330 	/**
1331 	 * Maps a value of `bytes32` type to a given key.
1332 	 * Only the owner can execute this function.
1333 	 */
1334 	function setBytes(bytes32 _key, bytes32 _value) external onlyCurrentOwner {
1335 		bytesStorage[_key] = _value;
1336 	}
1337 
1338 	/**
1339 	 * Maps a value of `bool` type to a given key.
1340 	 * Only the owner can execute this function.
1341 	 */
1342 	function setBool(bytes32 _key, bool _value) external onlyCurrentOwner {
1343 		boolStorage[_key] = _value;
1344 	}
1345 
1346 	/**
1347 	 * Maps a value of `int256` type to a given key.
1348 	 * Only the owner can execute this function.
1349 	 */
1350 	function setInt(bytes32 _key, int256 _value) external onlyCurrentOwner {
1351 		intStorage[_key] = _value;
1352 	}
1353 
1354 	// *** Delete Methods ***
1355 
1356 	/**
1357 	 * Deletes the value of the `uint256` type that mapped to the given key.
1358 	 * Only the owner can execute this function.
1359 	 */
1360 	function deleteUint(bytes32 _key) external onlyCurrentOwner {
1361 		delete uIntStorage[_key];
1362 	}
1363 
1364 	/**
1365 	 * Deletes the value of the `string` type that mapped to the given key.
1366 	 * Only the owner can execute this function.
1367 	 */
1368 	function deleteString(bytes32 _key) external onlyCurrentOwner {
1369 		delete stringStorage[_key];
1370 	}
1371 
1372 	/**
1373 	 * Deletes the value of the `address` type that mapped to the given key.
1374 	 * Only the owner can execute this function.
1375 	 */
1376 	function deleteAddress(bytes32 _key) external onlyCurrentOwner {
1377 		delete addressStorage[_key];
1378 	}
1379 
1380 	/**
1381 	 * Deletes the value of the `bytes32` type that mapped to the given key.
1382 	 * Only the owner can execute this function.
1383 	 */
1384 	function deleteBytes(bytes32 _key) external onlyCurrentOwner {
1385 		delete bytesStorage[_key];
1386 	}
1387 
1388 	/**
1389 	 * Deletes the value of the `bool` type that mapped to the given key.
1390 	 * Only the owner can execute this function.
1391 	 */
1392 	function deleteBool(bytes32 _key) external onlyCurrentOwner {
1393 		delete boolStorage[_key];
1394 	}
1395 
1396 	/**
1397 	 * Deletes the value of the `int256` type that mapped to the given key.
1398 	 * Only the owner can execute this function.
1399 	 */
1400 	function deleteInt(bytes32 _key) external onlyCurrentOwner {
1401 		delete intStorage[_key];
1402 	}
1403 }
1404 
1405 // File: contracts/src/common/storage/UsingStorage.sol
1406 
1407 pragma solidity ^0.5.0;
1408 
1409 /**
1410  * Module for contrast handling EternalStorage.
1411  */
1412 contract UsingStorage is Ownable {
1413 	address private _storage;
1414 
1415 	/**
1416 	 * Modifier to verify that EternalStorage is set.
1417 	 */
1418 	modifier hasStorage() {
1419 		require(_storage != address(0), "storage is not set");
1420 		_;
1421 	}
1422 
1423 	/**
1424 	 * Returns the set EternalStorage instance.
1425 	 */
1426 	function eternalStorage()
1427 		internal
1428 		view
1429 		hasStorage
1430 		returns (EternalStorage)
1431 	{
1432 		return EternalStorage(_storage);
1433 	}
1434 
1435 	/**
1436 	 * Returns the set EternalStorage address.
1437 	 */
1438 	function getStorageAddress() external view hasStorage returns (address) {
1439 		return _storage;
1440 	}
1441 
1442 	/**
1443 	 * Create a new EternalStorage contract.
1444 	 * This function call will fail if the EternalStorage contract is already set.
1445 	 * Also, only the owner can execute it.
1446 	 */
1447 	function createStorage() external onlyOwner {
1448 		require(_storage == address(0), "storage is set");
1449 		EternalStorage tmp = new EternalStorage();
1450 		_storage = address(tmp);
1451 	}
1452 
1453 	/**
1454 	 * Assigns the EternalStorage contract that has already been created.
1455 	 * Only the owner can execute this function.
1456 	 */
1457 	function setStorage(address _storageAddress) external onlyOwner {
1458 		_storage = _storageAddress;
1459 	}
1460 
1461 	/**
1462 	 * Delegates the owner of the current EternalStorage contract.
1463 	 * Only the owner can execute this function.
1464 	 */
1465 	function changeOwner(address newOwner) external onlyOwner {
1466 		EternalStorage(_storage).changeOwner(newOwner);
1467 	}
1468 }
1469 
1470 // File: contracts/src/lockup/LockupStorage.sol
1471 
1472 pragma solidity ^0.5.0;
1473 
1474 contract LockupStorage is UsingStorage {
1475 	using SafeMath for uint256;
1476 
1477 	uint256 public constant basis = 100000000000000000000000000000000;
1478 
1479 	//AllValue
1480 	function setStorageAllValue(uint256 _value) internal {
1481 		bytes32 key = getStorageAllValueKey();
1482 		eternalStorage().setUint(key, _value);
1483 	}
1484 
1485 	function getStorageAllValue() public view returns (uint256) {
1486 		bytes32 key = getStorageAllValueKey();
1487 		return eternalStorage().getUint(key);
1488 	}
1489 
1490 	function getStorageAllValueKey() private pure returns (bytes32) {
1491 		return keccak256(abi.encodePacked("_allValue"));
1492 	}
1493 
1494 	//Value
1495 	function setStorageValue(
1496 		address _property,
1497 		address _sender,
1498 		uint256 _value
1499 	) internal {
1500 		bytes32 key = getStorageValueKey(_property, _sender);
1501 		eternalStorage().setUint(key, _value);
1502 	}
1503 
1504 	function getStorageValue(address _property, address _sender)
1505 		public
1506 		view
1507 		returns (uint256)
1508 	{
1509 		bytes32 key = getStorageValueKey(_property, _sender);
1510 		return eternalStorage().getUint(key);
1511 	}
1512 
1513 	function getStorageValueKey(address _property, address _sender)
1514 		private
1515 		pure
1516 		returns (bytes32)
1517 	{
1518 		return keccak256(abi.encodePacked("_value", _property, _sender));
1519 	}
1520 
1521 	//PropertyValue
1522 	function setStoragePropertyValue(address _property, uint256 _value)
1523 		internal
1524 	{
1525 		bytes32 key = getStoragePropertyValueKey(_property);
1526 		eternalStorage().setUint(key, _value);
1527 	}
1528 
1529 	function getStoragePropertyValue(address _property)
1530 		public
1531 		view
1532 		returns (uint256)
1533 	{
1534 		bytes32 key = getStoragePropertyValueKey(_property);
1535 		return eternalStorage().getUint(key);
1536 	}
1537 
1538 	function getStoragePropertyValueKey(address _property)
1539 		private
1540 		pure
1541 		returns (bytes32)
1542 	{
1543 		return keccak256(abi.encodePacked("_propertyValue", _property));
1544 	}
1545 
1546 	//WithdrawalStatus
1547 	function setStorageWithdrawalStatus(
1548 		address _property,
1549 		address _from,
1550 		uint256 _value
1551 	) internal {
1552 		bytes32 key = getStorageWithdrawalStatusKey(_property, _from);
1553 		eternalStorage().setUint(key, _value);
1554 	}
1555 
1556 	function getStorageWithdrawalStatus(address _property, address _from)
1557 		public
1558 		view
1559 		returns (uint256)
1560 	{
1561 		bytes32 key = getStorageWithdrawalStatusKey(_property, _from);
1562 		return eternalStorage().getUint(key);
1563 	}
1564 
1565 	function getStorageWithdrawalStatusKey(address _property, address _sender)
1566 		private
1567 		pure
1568 		returns (bytes32)
1569 	{
1570 		return
1571 			keccak256(
1572 				abi.encodePacked("_withdrawalStatus", _property, _sender)
1573 			);
1574 	}
1575 
1576 	//InterestPrice
1577 	function setStorageInterestPrice(address _property, uint256 _value)
1578 		internal
1579 	{
1580 		// The previously used function
1581 		// This function is only used in testing
1582 		eternalStorage().setUint(getStorageInterestPriceKey(_property), _value);
1583 	}
1584 
1585 	function getStorageInterestPrice(address _property)
1586 		public
1587 		view
1588 		returns (uint256)
1589 	{
1590 		return eternalStorage().getUint(getStorageInterestPriceKey(_property));
1591 	}
1592 
1593 	function getStorageInterestPriceKey(address _property)
1594 		private
1595 		pure
1596 		returns (bytes32)
1597 	{
1598 		return keccak256(abi.encodePacked("_interestTotals", _property));
1599 	}
1600 
1601 	//LastInterestPrice
1602 	function setStorageLastInterestPrice(
1603 		address _property,
1604 		address _user,
1605 		uint256 _value
1606 	) internal {
1607 		eternalStorage().setUint(
1608 			getStorageLastInterestPriceKey(_property, _user),
1609 			_value
1610 		);
1611 	}
1612 
1613 	function getStorageLastInterestPrice(address _property, address _user)
1614 		public
1615 		view
1616 		returns (uint256)
1617 	{
1618 		return
1619 			eternalStorage().getUint(
1620 				getStorageLastInterestPriceKey(_property, _user)
1621 			);
1622 	}
1623 
1624 	function getStorageLastInterestPriceKey(address _property, address _user)
1625 		private
1626 		pure
1627 		returns (bytes32)
1628 	{
1629 		return
1630 			keccak256(
1631 				abi.encodePacked("_lastLastInterestPrice", _property, _user)
1632 			);
1633 	}
1634 
1635 	//LastSameRewardsAmountAndBlock
1636 	function setStorageLastSameRewardsAmountAndBlock(
1637 		uint256 _amount,
1638 		uint256 _block
1639 	) internal {
1640 		uint256 record = _amount.mul(basis).add(_block);
1641 		eternalStorage().setUint(
1642 			getStorageLastSameRewardsAmountAndBlockKey(),
1643 			record
1644 		);
1645 	}
1646 
1647 	function getStorageLastSameRewardsAmountAndBlock()
1648 		public
1649 		view
1650 		returns (uint256 _amount, uint256 _block)
1651 	{
1652 		uint256 record = eternalStorage().getUint(
1653 			getStorageLastSameRewardsAmountAndBlockKey()
1654 		);
1655 		uint256 amount = record.div(basis);
1656 		uint256 blockNumber = record.sub(amount.mul(basis));
1657 		return (amount, blockNumber);
1658 	}
1659 
1660 	function getStorageLastSameRewardsAmountAndBlockKey()
1661 		private
1662 		pure
1663 		returns (bytes32)
1664 	{
1665 		return keccak256(abi.encodePacked("_LastSameRewardsAmountAndBlock"));
1666 	}
1667 
1668 	//CumulativeGlobalRewards
1669 	function setStorageCumulativeGlobalRewards(uint256 _value) internal {
1670 		eternalStorage().setUint(
1671 			getStorageCumulativeGlobalRewardsKey(),
1672 			_value
1673 		);
1674 	}
1675 
1676 	function getStorageCumulativeGlobalRewards() public view returns (uint256) {
1677 		return eternalStorage().getUint(getStorageCumulativeGlobalRewardsKey());
1678 	}
1679 
1680 	function getStorageCumulativeGlobalRewardsKey()
1681 		private
1682 		pure
1683 		returns (bytes32)
1684 	{
1685 		return keccak256(abi.encodePacked("_cumulativeGlobalRewards"));
1686 	}
1687 
1688 	//LastCumulativeGlobalReward
1689 	function setStorageLastCumulativeGlobalReward(
1690 		address _property,
1691 		address _user,
1692 		uint256 _value
1693 	) internal {
1694 		eternalStorage().setUint(
1695 			getStorageLastCumulativeGlobalRewardKey(_property, _user),
1696 			_value
1697 		);
1698 	}
1699 
1700 	function getStorageLastCumulativeGlobalReward(
1701 		address _property,
1702 		address _user
1703 	) public view returns (uint256) {
1704 		return
1705 			eternalStorage().getUint(
1706 				getStorageLastCumulativeGlobalRewardKey(_property, _user)
1707 			);
1708 	}
1709 
1710 	function getStorageLastCumulativeGlobalRewardKey(
1711 		address _property,
1712 		address _user
1713 	) private pure returns (bytes32) {
1714 		return
1715 			keccak256(
1716 				abi.encodePacked(
1717 					"_LastCumulativeGlobalReward",
1718 					_property,
1719 					_user
1720 				)
1721 			);
1722 	}
1723 
1724 	//LastCumulativePropertyInterest
1725 	function setStorageLastCumulativePropertyInterest(
1726 		address _property,
1727 		address _user,
1728 		uint256 _value
1729 	) internal {
1730 		eternalStorage().setUint(
1731 			getStorageLastCumulativePropertyInterestKey(_property, _user),
1732 			_value
1733 		);
1734 	}
1735 
1736 	function getStorageLastCumulativePropertyInterest(
1737 		address _property,
1738 		address _user
1739 	) public view returns (uint256) {
1740 		return
1741 			eternalStorage().getUint(
1742 				getStorageLastCumulativePropertyInterestKey(_property, _user)
1743 			);
1744 	}
1745 
1746 	function getStorageLastCumulativePropertyInterestKey(
1747 		address _property,
1748 		address _user
1749 	) private pure returns (bytes32) {
1750 		return
1751 			keccak256(
1752 				abi.encodePacked(
1753 					"_lastCumulativePropertyInterest",
1754 					_property,
1755 					_user
1756 				)
1757 			);
1758 	}
1759 
1760 	//CumulativeLockedUpUnitAndBlock
1761 	function setStorageCumulativeLockedUpUnitAndBlock(
1762 		address _addr,
1763 		uint256 _unit,
1764 		uint256 _block
1765 	) internal {
1766 		uint256 record = _unit.mul(basis).add(_block);
1767 		eternalStorage().setUint(
1768 			getStorageCumulativeLockedUpUnitAndBlockKey(_addr),
1769 			record
1770 		);
1771 	}
1772 
1773 	function getStorageCumulativeLockedUpUnitAndBlock(address _addr)
1774 		public
1775 		view
1776 		returns (uint256 _unit, uint256 _block)
1777 	{
1778 		uint256 record = eternalStorage().getUint(
1779 			getStorageCumulativeLockedUpUnitAndBlockKey(_addr)
1780 		);
1781 		uint256 unit = record.div(basis);
1782 		uint256 blockNumber = record.sub(unit.mul(basis));
1783 		return (unit, blockNumber);
1784 	}
1785 
1786 	function getStorageCumulativeLockedUpUnitAndBlockKey(address _addr)
1787 		private
1788 		pure
1789 		returns (bytes32)
1790 	{
1791 		return
1792 			keccak256(
1793 				abi.encodePacked("_cumulativeLockedUpUnitAndBlock", _addr)
1794 			);
1795 	}
1796 
1797 	//CumulativeLockedUpValue
1798 	function setStorageCumulativeLockedUpValue(address _addr, uint256 _value)
1799 		internal
1800 	{
1801 		eternalStorage().setUint(
1802 			getStorageCumulativeLockedUpValueKey(_addr),
1803 			_value
1804 		);
1805 	}
1806 
1807 	function getStorageCumulativeLockedUpValue(address _addr)
1808 		public
1809 		view
1810 		returns (uint256)
1811 	{
1812 		return
1813 			eternalStorage().getUint(
1814 				getStorageCumulativeLockedUpValueKey(_addr)
1815 			);
1816 	}
1817 
1818 	function getStorageCumulativeLockedUpValueKey(address _addr)
1819 		private
1820 		pure
1821 		returns (bytes32)
1822 	{
1823 		return keccak256(abi.encodePacked("_cumulativeLockedUpValue", _addr));
1824 	}
1825 
1826 	//PendingWithdrawal
1827 	function setStoragePendingInterestWithdrawal(
1828 		address _property,
1829 		address _user,
1830 		uint256 _value
1831 	) internal {
1832 		eternalStorage().setUint(
1833 			getStoragePendingInterestWithdrawalKey(_property, _user),
1834 			_value
1835 		);
1836 	}
1837 
1838 	function getStoragePendingInterestWithdrawal(
1839 		address _property,
1840 		address _user
1841 	) public view returns (uint256) {
1842 		return
1843 			eternalStorage().getUint(
1844 				getStoragePendingInterestWithdrawalKey(_property, _user)
1845 			);
1846 	}
1847 
1848 	function getStoragePendingInterestWithdrawalKey(
1849 		address _property,
1850 		address _user
1851 	) private pure returns (bytes32) {
1852 		return
1853 			keccak256(
1854 				abi.encodePacked("_pendingInterestWithdrawal", _property, _user)
1855 			);
1856 	}
1857 
1858 	//DIP4GenesisBlock
1859 	function setStorageDIP4GenesisBlock(uint256 _block) internal {
1860 		eternalStorage().setUint(getStorageDIP4GenesisBlockKey(), _block);
1861 	}
1862 
1863 	function getStorageDIP4GenesisBlock() public view returns (uint256) {
1864 		return eternalStorage().getUint(getStorageDIP4GenesisBlockKey());
1865 	}
1866 
1867 	function getStorageDIP4GenesisBlockKey() private pure returns (bytes32) {
1868 		return keccak256(abi.encodePacked("_dip4GenesisBlock"));
1869 	}
1870 
1871 	//LastCumulativeLockedUpAndBlock
1872 	function setStorageLastCumulativeLockedUpAndBlock(
1873 		address _property,
1874 		address _user,
1875 		uint256 _cLocked,
1876 		uint256 _block
1877 	) internal {
1878 		uint256 record = _cLocked.mul(basis).add(_block);
1879 		eternalStorage().setUint(
1880 			getStorageLastCumulativeLockedUpAndBlockKey(_property, _user),
1881 			record
1882 		);
1883 	}
1884 
1885 	function getStorageLastCumulativeLockedUpAndBlock(
1886 		address _property,
1887 		address _user
1888 	) public view returns (uint256 _cLocked, uint256 _block) {
1889 		uint256 record = eternalStorage().getUint(
1890 			getStorageLastCumulativeLockedUpAndBlockKey(_property, _user)
1891 		);
1892 		uint256 cLocked = record.div(basis);
1893 		uint256 blockNumber = record.sub(cLocked.mul(basis));
1894 
1895 		return (cLocked, blockNumber);
1896 	}
1897 
1898 	function getStorageLastCumulativeLockedUpAndBlockKey(
1899 		address _property,
1900 		address _user
1901 	) private pure returns (bytes32) {
1902 		return
1903 			keccak256(
1904 				abi.encodePacked(
1905 					"_lastCumulativeLockedUpAndBlock",
1906 					_property,
1907 					_user
1908 				)
1909 			);
1910 	}
1911 }
1912 
1913 // File: contracts/src/policy/IPolicy.sol
1914 
1915 pragma solidity ^0.5.0;
1916 
1917 contract IPolicy {
1918 	function rewards(uint256 _lockups, uint256 _assets)
1919 		external
1920 		view
1921 		returns (uint256);
1922 
1923 	function holdersShare(uint256 _amount, uint256 _lockups)
1924 		external
1925 		view
1926 		returns (uint256);
1927 
1928 	function assetValue(uint256 _value, uint256 _lockups)
1929 		external
1930 		view
1931 		returns (uint256);
1932 
1933 	function authenticationFee(uint256 _assets, uint256 _propertyAssets)
1934 		external
1935 		view
1936 		returns (uint256);
1937 
1938 	function marketApproval(uint256 _agree, uint256 _opposite)
1939 		external
1940 		view
1941 		returns (bool);
1942 
1943 	function policyApproval(uint256 _agree, uint256 _opposite)
1944 		external
1945 		view
1946 		returns (bool);
1947 
1948 	function marketVotingBlocks() external view returns (uint256);
1949 
1950 	function policyVotingBlocks() external view returns (uint256);
1951 
1952 	function abstentionPenalty(uint256 _count) external view returns (uint256);
1953 
1954 	function lockUpBlocks() external view returns (uint256);
1955 }
1956 
1957 // File: contracts/src/allocator/IAllocator.sol
1958 
1959 pragma solidity ^0.5.0;
1960 
1961 contract IAllocator {
1962 	function calculateMaxRewardsPerBlock() public view returns (uint256);
1963 
1964 	function beforeBalanceChange(
1965 		address _property,
1966 		address _from,
1967 		address _to
1968 		// solium-disable-next-line indentation
1969 	) external;
1970 }
1971 
1972 // File: contracts/src/lockup/ILockup.sol
1973 
1974 pragma solidity ^0.5.0;
1975 
1976 contract ILockup {
1977 	function lockup(
1978 		address _from,
1979 		address _property,
1980 		uint256 _value
1981 		// solium-disable-next-line indentation
1982 	) external;
1983 
1984 	function update() public;
1985 
1986 	function cancel(address _property) external;
1987 
1988 	function withdraw(address _property) external;
1989 
1990 	function difference(address _property, uint256 _lastReward)
1991 		public
1992 		view
1993 		returns (
1994 			uint256 _reward,
1995 			uint256 _holdersAmount,
1996 			uint256 _holdersPrice,
1997 			uint256 _interestAmount,
1998 			uint256 _interestPrice
1999 		);
2000 
2001 	function getPropertyValue(address _property)
2002 		external
2003 		view
2004 		returns (uint256);
2005 
2006 	function getAllValue() external view returns (uint256);
2007 
2008 	function getValue(address _property, address _sender)
2009 		external
2010 		view
2011 		returns (uint256);
2012 
2013 	function calculateWithdrawableInterestAmount(
2014 		address _property,
2015 		address _user
2016 	)
2017 		public
2018 		view
2019 		returns (
2020 			// solium-disable-next-line indentation
2021 			uint256
2022 		);
2023 
2024 	function withdrawInterest(address _property) external;
2025 }
2026 
2027 // File: contracts/src/metrics/IMetricsGroup.sol
2028 
2029 pragma solidity ^0.5.0;
2030 
2031 contract IMetricsGroup is IGroup {
2032 	function removeGroup(address _addr) external;
2033 
2034 	function totalIssuedMetrics() external view returns (uint256);
2035 
2036 	function getMetricsCountPerProperty(address _property)
2037 		public
2038 		view
2039 		returns (uint256);
2040 
2041 	function hasAssets(address _property) public view returns (bool);
2042 }
2043 
2044 // File: contracts/src/lockup/Lockup.sol
2045 
2046 pragma solidity ^0.5.0;
2047 
2048 // prettier-ignore
2049 
2050 /**
2051  * A contract that manages the staking of DEV tokens and calculates rewards.
2052  * Staking and the following mechanism determines that reward calculation.
2053  *
2054  * Variables:
2055  * -`M`: Maximum mint amount per block determined by Allocator contract
2056  * -`B`: Number of blocks during staking
2057  * -`P`: Total number of staking locked up in a Property contract
2058  * -`S`: Total number of staking locked up in all Property contracts
2059  * -`U`: Number of staking per account locked up in a Property contract
2060  *
2061  * Formula:
2062  * Staking Rewards = M * B * (P / S) * (U / P)
2063  *
2064  * Note:
2065  * -`M`, `P` and `S` vary from block to block, and the variation cannot be predicted.
2066  * -`B` is added every time the Ethereum block is created.
2067  * - Only `U` and `B` are predictable variables.
2068  * - As `M`, `P` and `S` cannot be observed from a staker, the "cumulative sum" is often used to calculate ratio variation with history.
2069  * - Reward withdrawal always withdraws the total withdrawable amount.
2070  *
2071  * Scenario:
2072  * - Assume `M` is fixed at 500
2073  * - Alice stakes 100 DEV on Property-A (Alice's staking state on Property-A: `M`=500, `B`=0, `P`=100, `S`=100, `U`=100)
2074  * - After 10 blocks, Bob stakes 60 DEV on Property-B (Alice's staking state on Property-A: `M`=500, `B`=10, `P`=100, `S`=160, `U`=100)
2075  * - After 10 blocks, Carol stakes 40 DEV on Property-A (Alice's staking state on Property-A: `M`=500, `B`=20, `P`=140, `S`=200, `U`=100)
2076  * - After 10 blocks, Alice withdraws Property-A staking reward. The reward at this time is 5000 DEV (10 blocks * 500 DEV) + 3125 DEV (10 blocks * 62.5% * 500 DEV) + 2500 DEV (10 blocks * 50% * 500 DEV).
2077  */
2078 contract Lockup is ILockup, UsingConfig, UsingValidator, LockupStorage {
2079 	using SafeMath for uint256;
2080 	using Decimals for uint256;
2081 	event Lockedup(address _from, address _property, uint256 _value);
2082 
2083 	/**
2084 	 * Initialize the passed address as AddressConfig address.
2085 	 */
2086 	// solium-disable-next-line no-empty-blocks
2087 	constructor(address _config) public UsingConfig(_config) {}
2088 
2089 	/**
2090 	 * Adds staking.
2091 	 * Only the Dev contract can execute this function.
2092 	 */
2093 	function lockup(
2094 		address _from,
2095 		address _property,
2096 		uint256 _value
2097 	) external {
2098 		/**
2099 		 * Validates the sender is Dev contract.
2100 		 */
2101 		addressValidator().validateAddress(msg.sender, config().token());
2102 
2103 		/**
2104 		 * Validates the target of staking is included Property set.
2105 		 */
2106 		addressValidator().validateGroup(_property, config().propertyGroup());
2107 		require(_value != 0, "illegal lockup value");
2108 
2109 		/**
2110 		 * Validates the passed Property has greater than 1 asset.
2111 		 */
2112 		require(
2113 			IMetricsGroup(config().metricsGroup()).hasAssets(_property),
2114 			"unable to stake to unauthenticated property"
2115 		);
2116 
2117 		/**
2118 		 * Refuses new staking when after cancel staking and until release it.
2119 		 */
2120 		bool isWaiting = getStorageWithdrawalStatus(_property, _from) != 0;
2121 		require(isWaiting == false, "lockup is already canceled");
2122 
2123 		/**
2124 		 * Since the reward per block that can be withdrawn will change with the addition of staking,
2125 		 * saves the undrawn withdrawable reward before addition it.
2126 		 */
2127 		updatePendingInterestWithdrawal(_property, _from);
2128 
2129 		/**
2130 		 * Saves the variables at the time of staking to prepare for reward calculation.
2131 		 */
2132 		(, , , uint256 interest, ) = difference(_property, 0);
2133 		updateStatesAtLockup(_property, _from, interest);
2134 
2135 		/**
2136 		 * Saves variables that should change due to the addition of staking.
2137 		 */
2138 		updateValues(true, _from, _property, _value);
2139 		emit Lockedup(_from, _property, _value);
2140 	}
2141 
2142 	/**
2143 	 * Cancel staking.
2144 	 * The staking amount can be withdrawn after the blocks specified by `Policy.lockUpBlocks` have passed.
2145 	 */
2146 	function cancel(address _property) external {
2147 		/**
2148 		 * Validates the target of staked is included Property set.
2149 		 */
2150 		addressValidator().validateGroup(_property, config().propertyGroup());
2151 
2152 		/**
2153 		 * Validates the sender is staking to the target Property.
2154 		 */
2155 		require(hasValue(_property, msg.sender), "dev token is not locked");
2156 
2157 		/**
2158 		 * Validates not already been canceled.
2159 		 */
2160 		bool isWaiting = getStorageWithdrawalStatus(_property, msg.sender) != 0;
2161 		require(isWaiting == false, "lockup is already canceled");
2162 
2163 		/**
2164 		 * Get `Policy.lockUpBlocks`, add it to the current block number, and saves that block number in `WithdrawalStatus`.
2165 		 * Staking is cannot release until the block number saved in `WithdrawalStatus` is reached.
2166 		 */
2167 		uint256 blockNumber = IPolicy(config().policy()).lockUpBlocks();
2168 		blockNumber = blockNumber.add(block.number);
2169 		setStorageWithdrawalStatus(_property, msg.sender, blockNumber);
2170 	}
2171 
2172 	/**
2173 	 * Withdraw staking.
2174 	 * Releases canceled staking and transfer the staked amount to the sender.
2175 	 */
2176 	function withdraw(address _property) external {
2177 		/**
2178 		 * Validates the target of staked is included Property set.
2179 		 */
2180 		addressValidator().validateGroup(_property, config().propertyGroup());
2181 
2182 		/**
2183 		 * Validates the block number reaches the block number where staking can be released.
2184 		 */
2185 		require(possible(_property, msg.sender), "waiting for release");
2186 
2187 		/**
2188 		 * Validates the sender is staking to the target Property.
2189 		 */
2190 		uint256 lockedUpValue = getStorageValue(_property, msg.sender);
2191 		require(lockedUpValue != 0, "dev token is not locked");
2192 
2193 		/**
2194 		 * Since the increase of rewards will stop with the release of the staking,
2195 		 * saves the undrawn withdrawable reward before releasing it.
2196 		 */
2197 		updatePendingInterestWithdrawal(_property, msg.sender);
2198 
2199 		/**
2200 		 * Transfer the staked amount to the sender.
2201 		 */
2202 		IProperty(_property).withdraw(msg.sender, lockedUpValue);
2203 
2204 		/**
2205 		 * Saves variables that should change due to the canceling staking..
2206 		 */
2207 		updateValues(false, msg.sender, _property, lockedUpValue);
2208 
2209 		/**
2210 		 * Sets the staked amount to 0.
2211 		 */
2212 		setStorageValue(_property, msg.sender, 0);
2213 
2214 		/**
2215 		 * Sets the cancellation status to not have.
2216 		 */
2217 		setStorageWithdrawalStatus(_property, msg.sender, 0);
2218 	}
2219 
2220 	/**
2221 	 * Returns the current staking amount, and the block number in which the recorded last.
2222 	 * These values are used to calculate the cumulative sum of the staking.
2223 	 */
2224 	function getCumulativeLockedUpUnitAndBlock(address _property)
2225 		private
2226 		view
2227 		returns (uint256 _unit, uint256 _block)
2228 	{
2229 		/**
2230 		 * Get the current staking amount and the last recorded block number from the `CumulativeLockedUpUnitAndBlock` storage.
2231 		 * If the last recorded block number is not 0, it is returns as it is.
2232 		 */
2233 		(
2234 			uint256 unit,
2235 			uint256 lastBlock
2236 		) = getStorageCumulativeLockedUpUnitAndBlock(_property);
2237 		if (lastBlock > 0) {
2238 			return (unit, lastBlock);
2239 		}
2240 
2241 		/**
2242 		 * If the last recorded block number is 0, this function falls back as already staked before the current specs (before DIP4).
2243 		 * More detail for DIP4: https://github.com/dev-protocol/DIPs/issues/4
2244 		 *
2245 		 * When the passed address is 0, the caller wants to know the total staking amount on the protocol,
2246 		 * so gets the total staking amount from `AllValue` storage.
2247 		 * When the address is other than 0, the caller wants to know the staking amount of a Property,
2248 		 * so gets the staking amount from the `PropertyValue` storage.
2249 		 */
2250 		unit = _property == address(0)
2251 			? getStorageAllValue()
2252 			: getStoragePropertyValue(_property);
2253 
2254 		/**
2255 		 * Staking pre-DIP4 will be treated as staked simultaneously with the DIP4 release.
2256 		 * Therefore, the last recorded block number is the same as the DIP4 release block.
2257 		 */
2258 		lastBlock = getStorageDIP4GenesisBlock();
2259 		return (unit, lastBlock);
2260 	}
2261 
2262 	/**
2263 	 * Returns the cumulative sum of the staking on passed address, the current staking amount,
2264 	 * and the block number in which the recorded last.
2265 	 * The latest cumulative sum can be calculated using the following formula:
2266 	 * (current staking amount) * (current block number - last recorded block number) + (last cumulative sum)
2267 	 */
2268 	function getCumulativeLockedUp(address _property)
2269 		public
2270 		view
2271 		returns (
2272 			uint256 _value,
2273 			uint256 _unit,
2274 			uint256 _block
2275 		)
2276 	{
2277 		/**
2278 		 * Gets the current staking amount and the last recorded block number from the `getCumulativeLockedUpUnitAndBlock` function.
2279 		 */
2280 		(uint256 unit, uint256 lastBlock) = getCumulativeLockedUpUnitAndBlock(
2281 			_property
2282 		);
2283 
2284 		/**
2285 		 * Gets the last cumulative sum of the staking from `CumulativeLockedUpValue` storage.
2286 		 */
2287 		uint256 lastValue = getStorageCumulativeLockedUpValue(_property);
2288 
2289 		/**
2290 		 * Returns the latest cumulative sum, current staking amount as a unit, and last recorded block number.
2291 		 */
2292 		return (
2293 			lastValue.add(unit.mul(block.number.sub(lastBlock))),
2294 			unit,
2295 			lastBlock
2296 		);
2297 	}
2298 
2299 	/**
2300 	 * Returns the cumulative sum of the staking on the protocol totally, the current staking amount,
2301 	 * and the block number in which the recorded last.
2302 	 */
2303 	function getCumulativeLockedUpAll()
2304 		public
2305 		view
2306 		returns (
2307 			uint256 _value,
2308 			uint256 _unit,
2309 			uint256 _block
2310 		)
2311 	{
2312 		/**
2313 		 * If the 0 address is passed as a key, it indicates the entire protocol.
2314 		 */
2315 		return getCumulativeLockedUp(address(0));
2316 	}
2317 
2318 	/**
2319 	 * Updates the `CumulativeLockedUpValue` and `CumulativeLockedUpUnitAndBlock` storage.
2320 	 * This function expected to executes when the amount of staking as a unit changes.
2321 	 */
2322 	function updateCumulativeLockedUp(
2323 		bool _addition,
2324 		address _property,
2325 		uint256 _unit
2326 	) private {
2327 		address zero = address(0);
2328 
2329 		/**
2330 		 * Gets the cumulative sum of the staking amount, staking amount, and last recorded block number for the passed Property address.
2331 		 */
2332 		(uint256 lastValue, uint256 lastUnit, ) = getCumulativeLockedUp(
2333 			_property
2334 		);
2335 
2336 		/**
2337 		 * Gets the cumulative sum of the staking amount, staking amount, and last recorded block number for the protocol total.
2338 		 */
2339 		(uint256 lastValueAll, uint256 lastUnitAll, ) = getCumulativeLockedUp(
2340 			zero
2341 		);
2342 
2343 		/**
2344 		 * Adds or subtracts the staking amount as a new unit to the cumulative sum of the staking for the passed Property address.
2345 		 */
2346 		setStorageCumulativeLockedUpValue(
2347 			_property,
2348 			_addition ? lastValue.add(_unit) : lastValue.sub(_unit)
2349 		);
2350 
2351 		/**
2352 		 * Adds or subtracts the staking amount as a new unit to the cumulative sum of the staking for the protocol total.
2353 		 */
2354 		setStorageCumulativeLockedUpValue(
2355 			zero,
2356 			_addition ? lastValueAll.add(_unit) : lastValueAll.sub(_unit)
2357 		);
2358 
2359 		/**
2360 		 * Adds or subtracts the staking amount to the staking unit for the passed Property address.
2361 		 * Also, record the latest block number.
2362 		 */
2363 		setStorageCumulativeLockedUpUnitAndBlock(
2364 			_property,
2365 			_addition ? lastUnit.add(_unit) : lastUnit.sub(_unit),
2366 			block.number
2367 		);
2368 
2369 		/**
2370 		 * Adds or subtracts the staking amount to the staking unit for the protocol total.
2371 		 * Also, record the latest block number.
2372 		 */
2373 		setStorageCumulativeLockedUpUnitAndBlock(
2374 			zero,
2375 			_addition ? lastUnitAll.add(_unit) : lastUnitAll.sub(_unit),
2376 			block.number
2377 		);
2378 	}
2379 
2380 	/**
2381 	 * Updates cumulative sum of the maximum mint amount calculated by Allocator contract, the latest maximum mint amount per block,
2382 	 * and the last recorded block number.
2383 	 * The cumulative sum of the maximum mint amount is always added.
2384 	 * By recording that value when the staker last stakes, the difference from the when the staker stakes can be calculated.
2385 	 */
2386 	function update() public {
2387 		/**
2388 		 * Gets the cumulative sum of the maximum mint amount and the maximum mint number per block.
2389 		 */
2390 		(uint256 _nextRewards, uint256 _amount) = dry();
2391 
2392 		/**
2393 		 * Records each value and the latest block number.
2394 		 */
2395 		setStorageCumulativeGlobalRewards(_nextRewards);
2396 		setStorageLastSameRewardsAmountAndBlock(_amount, block.number);
2397 	}
2398 
2399 	/**
2400 	 * Updates the cumulative sum of the maximum mint amount when staking, the cumulative sum of staker reward as an interest of the target Property
2401 	 * and the cumulative staking amount, and the latest block number.
2402 	 */
2403 	function updateStatesAtLockup(
2404 		address _property,
2405 		address _user,
2406 		uint256 _interest
2407 	) private {
2408 		/**
2409 		 * Gets the cumulative sum of the maximum mint amount.
2410 		 */
2411 		(uint256 _reward, ) = dry();
2412 
2413 		/**
2414 		 * Records each value and the latest block number.
2415 		 */
2416 		if (isSingle(_property, _user)) {
2417 			setStorageLastCumulativeGlobalReward(_property, _user, _reward);
2418 		}
2419 		setStorageLastCumulativePropertyInterest(_property, _user, _interest);
2420 		(uint256 cLocked, , ) = getCumulativeLockedUp(_property);
2421 		setStorageLastCumulativeLockedUpAndBlock(
2422 			_property,
2423 			_user,
2424 			cLocked,
2425 			block.number
2426 		);
2427 	}
2428 
2429 	/**
2430 	 * Returns the last cumulative staking amount of the passed Property address and the last recorded block number.
2431 	 */
2432 	function getLastCumulativeLockedUpAndBlock(address _property, address _user)
2433 		private
2434 		view
2435 		returns (uint256 _cLocked, uint256 _block)
2436 	{
2437 		/**
2438 		 * Gets the values from `LastCumulativeLockedUpAndBlock` storage.
2439 		 */
2440 		(
2441 			uint256 cLocked,
2442 			uint256 blockNumber
2443 		) = getStorageLastCumulativeLockedUpAndBlock(_property, _user);
2444 
2445 		/**
2446 		 * When the last recorded block number is 0, the block number at the time of the DIP4 release is returned as being staked at the same time as the DIP4 release.
2447 		 * More detail for DIP4: https://github.com/dev-protocol/DIPs/issues/4
2448 		 */
2449 		if (blockNumber == 0) {
2450 			blockNumber = getStorageDIP4GenesisBlock();
2451 		}
2452 		return (cLocked, blockNumber);
2453 	}
2454 
2455 	/**
2456 	 * Referring to the values recorded in each storage to returns the latest cumulative sum of the maximum mint amount and the latest maximum mint amount per block.
2457 	 */
2458 	function dry()
2459 		private
2460 		view
2461 		returns (uint256 _nextRewards, uint256 _amount)
2462 	{
2463 		/**
2464 		 * Gets the latest mint amount per block from Allocator contract.
2465 		 */
2466 		uint256 rewardsAmount = IAllocator(config().allocator())
2467 			.calculateMaxRewardsPerBlock();
2468 
2469 		/**
2470 		 * Gets the maximum mint amount per block, and the last recorded block number from `LastSameRewardsAmountAndBlock` storage.
2471 		 */
2472 		(
2473 			uint256 lastAmount,
2474 			uint256 lastBlock
2475 		) = getStorageLastSameRewardsAmountAndBlock();
2476 
2477 		/**
2478 		 * If the recorded maximum mint amount per block and the result of the Allocator contract are different,
2479 		 * the result of the Allocator contract takes precedence as a maximum mint amount per block.
2480 		 */
2481 		uint256 lastMaxRewards = lastAmount == rewardsAmount
2482 			? rewardsAmount
2483 			: lastAmount;
2484 
2485 		/**
2486 		 * Calculates the difference between the latest block number and the last recorded block number.
2487 		 */
2488 		uint256 blocks = lastBlock > 0 ? block.number.sub(lastBlock) : 0;
2489 
2490 		/**
2491 		 * Adds the calculated new cumulative maximum mint amount to the recorded cumulative maximum mint amount.
2492 		 */
2493 		uint256 additionalRewards = lastMaxRewards.mul(blocks);
2494 		uint256 nextRewards = getStorageCumulativeGlobalRewards().add(
2495 			additionalRewards
2496 		);
2497 
2498 		/**
2499 		 * Returns the latest theoretical cumulative sum of maximum mint amount and maximum mint amount per block.
2500 		 */
2501 		return (nextRewards, rewardsAmount);
2502 	}
2503 
2504 	/**
2505 	 * Returns the latest theoretical cumulative sum of maximum mint amount, the holder's reward of the passed Property address and its unit price,
2506 	 * and the staker's reward as interest and its unit price.
2507 	 * The latest theoretical cumulative sum of maximum mint amount is got from `dry` function.
2508 	 * The Holder's reward is a staking(delegation) reward received by the holder of the Property contract(token) according to the share.
2509 	 * The unit price of the holder's reward is the reward obtained per 1 piece of Property contract(token).
2510 	 * The staker rewards are rewards for staking users.
2511 	 * The unit price of the staker reward is the reward per DEV token 1 piece that is staking.
2512 	 */
2513 	function difference(address _property, uint256 _lastReward)
2514 		public
2515 		view
2516 		returns (
2517 			uint256 _reward,
2518 			uint256 _holdersAmount,
2519 			uint256 _holdersPrice,
2520 			uint256 _interestAmount,
2521 			uint256 _interestPrice
2522 		)
2523 	{
2524 		/**
2525 		 * Gets the cumulative sum of the maximum mint amount.
2526 		 */
2527 		(uint256 rewards, ) = dry();
2528 
2529 		/**
2530 		 * Gets the cumulative sum of the staking amount of the passed Property address and
2531 		 * the cumulative sum of the staking amount of the protocol total.
2532 		 */
2533 		(uint256 valuePerProperty, , ) = getCumulativeLockedUp(_property);
2534 		(uint256 valueAll, , ) = getCumulativeLockedUpAll();
2535 
2536 		/**
2537 		 * Calculates the amount of reward that can be received by the Property from the ratio of the cumulative sum of the staking amount of the Property address
2538 		 * and the cumulative sum of the staking amount of the protocol total.
2539 		 * If the past cumulative sum of the maximum mint amount passed as the second argument is 1 or more,
2540 		 * this result is the difference from that cumulative sum.
2541 		 */
2542 		uint256 propertyRewards = rewards.sub(_lastReward).mul(
2543 			valuePerProperty.mulBasis().outOf(valueAll)
2544 		);
2545 
2546 		/**
2547 		 * Gets the staking amount and total supply of the Property and calls `Policy.holdersShare` function to calculates
2548 		 * the holder's reward amount out of the total reward amount.
2549 		 */
2550 		uint256 lockedUpPerProperty = getStoragePropertyValue(_property);
2551 		uint256 totalSupply = ERC20Mintable(_property).totalSupply();
2552 		uint256 holders = IPolicy(config().policy()).holdersShare(
2553 			propertyRewards,
2554 			lockedUpPerProperty
2555 		);
2556 
2557 		/**
2558 		 * The total rewards amount minus the holder reward amount is the staker rewards as an interest.
2559 		 */
2560 		uint256 interest = propertyRewards.sub(holders);
2561 
2562 		/**
2563 		 * Returns each value and a unit price of each reward.
2564 		 */
2565 		return (
2566 			rewards,
2567 			holders,
2568 			holders.div(totalSupply),
2569 			interest,
2570 			lockedUpPerProperty > 0 ? interest.div(lockedUpPerProperty) : 0
2571 		);
2572 	}
2573 
2574 	/**
2575 	 * Returns the staker reward as interest.
2576 	 */
2577 	function _calculateInterestAmount(address _property, address _user)
2578 		private
2579 		view
2580 		returns (uint256)
2581 	{
2582 		/**
2583 		 * Gets the cumulative sum of the staking amount, current staking amount, and last recorded block number of the Property.
2584 		 */
2585 		(
2586 			uint256 cLockProperty,
2587 			uint256 unit,
2588 			uint256 lastBlock
2589 		) = getCumulativeLockedUp(_property);
2590 
2591 		/**
2592 		 * Gets the cumulative sum of staking amount and block number of Property when the user staked.
2593 		 */
2594 		(
2595 			uint256 lastCLocked,
2596 			uint256 lastBlockUser
2597 		) = getLastCumulativeLockedUpAndBlock(_property, _user);
2598 
2599 		/**
2600 		 * Get the amount the user is staking for the Property.
2601 		 */
2602 		uint256 lockedUpPerAccount = getStorageValue(_property, _user);
2603 
2604 		/**
2605 		 * Gets the cumulative sum of the Property's staker reward when the user staked.
2606 		 */
2607 		uint256 lastInterest = getStorageLastCumulativePropertyInterest(
2608 			_property,
2609 			_user
2610 		);
2611 
2612 		/**
2613 		 * Calculates the cumulative sum of the staking amount from the time the user staked to the present.
2614 		 * It can be calculated by multiplying the staking amount by the number of elapsed blocks.
2615 		 */
2616 		uint256 cLockUser = lockedUpPerAccount.mul(
2617 			block.number.sub(lastBlockUser)
2618 		);
2619 
2620 		/**
2621 		 * Determines if the user is the only staker to the Property.
2622 		 */
2623 		bool isOnly = unit == lockedUpPerAccount && lastBlock <= lastBlockUser;
2624 
2625 		/**
2626 		 * If the user is the Property's only staker and the first staker, and the only staker on the protocol:
2627 		 */
2628 		if (isSingle(_property, _user)) {
2629 			/**
2630 			 * Passing the cumulative sum of the maximum mint amount when staked, to the `difference` function,
2631 			 * gets the staker reward amount that the user can receive from the time of staking to the present.
2632 			 * In the case of the staking is single, the ratio of the Property and the user account for 100% of the cumulative sum of the maximum mint amount,
2633 			 * so the difference cannot be calculated with the value of `LastCumulativePropertyInterest`.
2634 			 * Therefore, it is necessary to calculate the difference using the cumulative sum of the maximum mint amounts at the time of staked.
2635 			 */
2636 			(, , , , uint256 interestPrice) = difference(
2637 				_property,
2638 				getStorageLastCumulativeGlobalReward(_property, _user)
2639 			);
2640 
2641 			/**
2642 			 * Returns the result after adjusted decimals to 10^18.
2643 			 */
2644 			uint256 result = interestPrice
2645 				.mul(lockedUpPerAccount)
2646 				.divBasis()
2647 				.divBasis();
2648 			return result;
2649 
2650 			/**
2651 			 * If not the single but the only staker:
2652 			 */
2653 		} else if (isOnly) {
2654 			/**
2655 			 * Pass 0 to the `difference` function to gets the Property's cumulative sum of the staker reward.
2656 			 */
2657 			(, , , uint256 interest, ) = difference(_property, 0);
2658 
2659 			/**
2660 			 * Calculates the difference in rewards that can be received by subtracting the Property's cumulative sum of staker rewards at the time of staking.
2661 			 */
2662 			uint256 result = interest >= lastInterest
2663 				? interest.sub(lastInterest).divBasis().divBasis()
2664 				: 0;
2665 			return result;
2666 		}
2667 
2668 		/**
2669 		 * If the user is the Property's not the first staker and not the only staker:
2670 		 */
2671 
2672 		/**
2673 		 * Pass 0 to the `difference` function to gets the Property's cumulative sum of the staker reward.
2674 		 */
2675 		(, , , uint256 interest, ) = difference(_property, 0);
2676 
2677 		/**
2678 		 * Calculates the share of rewards that can be received by the user among Property's staker rewards.
2679 		 * "Cumulative sum of the staking amount of the Property at the time of staking" is subtracted from "cumulative sum of the staking amount of the Property",
2680 		 * and calculates the cumulative sum of staking amounts from the time of staking to the present.
2681 		 * The ratio of the "cumulative sum of staking amount from the time the user staked to the present" to that value is the share.
2682 		 */
2683 		uint256 share = cLockUser.outOf(cLockProperty.sub(lastCLocked));
2684 
2685 		/**
2686 		 * If the Property's staker reward is greater than the value of the `CumulativePropertyInterest` storage,
2687 		 * calculates the difference and multiply by the share.
2688 		 * Otherwise, it returns 0.
2689 		 */
2690 		uint256 result = interest >= lastInterest
2691 			? interest
2692 				.sub(lastInterest)
2693 				.mul(share)
2694 				.divBasis()
2695 				.divBasis()
2696 				.divBasis()
2697 			: 0;
2698 		return result;
2699 	}
2700 
2701 	/**
2702 	 * Returns the total rewards currently available for withdrawal. (For calling from inside the contract)
2703 	 */
2704 	function _calculateWithdrawableInterestAmount(
2705 		address _property,
2706 		address _user
2707 	) private view returns (uint256) {
2708 		/**
2709 		 * If the passed Property has not authenticated, returns always 0.
2710 		 */
2711 		if (
2712 			IMetricsGroup(config().metricsGroup()).hasAssets(_property) == false
2713 		) {
2714 			return 0;
2715 		}
2716 
2717 		/**
2718 		 * Gets the reward amount in saved without withdrawal.
2719 		 */
2720 		uint256 pending = getStoragePendingInterestWithdrawal(_property, _user);
2721 
2722 		/**
2723 		 * Gets the reward amount of before DIP4.
2724 		 */
2725 		uint256 legacy = __legacyWithdrawableInterestAmount(_property, _user);
2726 
2727 		/**
2728 		 * Gets the latest withdrawal reward amount.
2729 		 */
2730 		uint256 amount = _calculateInterestAmount(_property, _user);
2731 
2732 		/**
2733 		 * Returns the sum of all values.
2734 		 */
2735 		uint256 withdrawableAmount = amount
2736 			.add(pending) // solium-disable-next-line indentation
2737 			.add(legacy);
2738 		return withdrawableAmount;
2739 	}
2740 
2741 	/**
2742 	 * Returns the total rewards currently available for withdrawal. (For calling from external of the contract)
2743 	 */
2744 	function calculateWithdrawableInterestAmount(
2745 		address _property,
2746 		address _user
2747 	) public view returns (uint256) {
2748 		uint256 amount = _calculateWithdrawableInterestAmount(_property, _user);
2749 		return amount;
2750 	}
2751 
2752 	/**
2753 	 * Withdraws staking reward as an interest.
2754 	 */
2755 	function withdrawInterest(address _property) external {
2756 		/**
2757 		 * Validates the target of staking is included Property set.
2758 		 */
2759 		addressValidator().validateGroup(_property, config().propertyGroup());
2760 
2761 		/**
2762 		 * Gets the withdrawable amount.
2763 		 */
2764 		uint256 value = _calculateWithdrawableInterestAmount(
2765 			_property,
2766 			msg.sender
2767 		);
2768 
2769 		/**
2770 		 * Gets the cumulative sum of staker rewards of the passed Property address.
2771 		 */
2772 		(, , , uint256 interest, ) = difference(_property, 0);
2773 
2774 		/**
2775 		 * Validates rewards amount there are 1 or more.
2776 		 */
2777 		require(value > 0, "your interest amount is 0");
2778 
2779 		/**
2780 		 * Sets the unwithdrawn reward amount to 0.
2781 		 */
2782 		setStoragePendingInterestWithdrawal(_property, msg.sender, 0);
2783 
2784 		/**
2785 		 * Creates a Dev token instance.
2786 		 */
2787 		ERC20Mintable erc20 = ERC20Mintable(config().token());
2788 
2789 		/**
2790 		 * Updates the staking status to avoid double rewards.
2791 		 */
2792 		updateStatesAtLockup(_property, msg.sender, interest);
2793 		__updateLegacyWithdrawableInterestAmount(_property, msg.sender);
2794 
2795 		/**
2796 		 * Mints the reward.
2797 		 */
2798 		require(erc20.mint(msg.sender, value), "dev mint failed");
2799 
2800 		/**
2801 		 * Since the total supply of tokens has changed, updates the latest maximum mint amount.
2802 		 */
2803 		update();
2804 	}
2805 
2806 	/**
2807 	 * Status updates with the addition or release of staking.
2808 	 */
2809 	function updateValues(
2810 		bool _addition,
2811 		address _account,
2812 		address _property,
2813 		uint256 _value
2814 	) private {
2815 		/**
2816 		 * If added staking:
2817 		 */
2818 		if (_addition) {
2819 			/**
2820 			 * Updates the cumulative sum of the staking amount of the passed Property and the cumulative amount of the staking amount of the protocol total.
2821 			 */
2822 			updateCumulativeLockedUp(true, _property, _value);
2823 
2824 			/**
2825 			 * Updates the current staking amount of the protocol total.
2826 			 */
2827 			addAllValue(_value);
2828 
2829 			/**
2830 			 * Updates the current staking amount of the Property.
2831 			 */
2832 			addPropertyValue(_property, _value);
2833 
2834 			/**
2835 			 * Updates the user's current staking amount in the Property.
2836 			 */
2837 			addValue(_property, _account, _value);
2838 
2839 			/**
2840 			 * If released staking:
2841 			 */
2842 		} else {
2843 			/**
2844 			 * Updates the cumulative sum of the staking amount of the passed Property and the cumulative amount of the staking amount of the protocol total.
2845 			 */
2846 			updateCumulativeLockedUp(false, _property, _value);
2847 
2848 			/**
2849 			 * Updates the current staking amount of the protocol total.
2850 			 */
2851 			subAllValue(_value);
2852 
2853 			/**
2854 			 * Updates the current staking amount of the Property.
2855 			 */
2856 			subPropertyValue(_property, _value);
2857 		}
2858 
2859 		/**
2860 		 * Since each staking amount has changed, updates the latest maximum mint amount.
2861 		 */
2862 		update();
2863 	}
2864 
2865 	/**
2866 	 * Returns the staking amount of the protocol total.
2867 	 */
2868 	function getAllValue() external view returns (uint256) {
2869 		return getStorageAllValue();
2870 	}
2871 
2872 	/**
2873 	 * Adds the staking amount of the protocol total.
2874 	 */
2875 	function addAllValue(uint256 _value) private {
2876 		uint256 value = getStorageAllValue();
2877 		value = value.add(_value);
2878 		setStorageAllValue(value);
2879 	}
2880 
2881 	/**
2882 	 * Subtracts the staking amount of the protocol total.
2883 	 */
2884 	function subAllValue(uint256 _value) private {
2885 		uint256 value = getStorageAllValue();
2886 		value = value.sub(_value);
2887 		setStorageAllValue(value);
2888 	}
2889 
2890 	/**
2891 	 * Returns the user's staking amount in the Property.
2892 	 */
2893 	function getValue(address _property, address _sender)
2894 		external
2895 		view
2896 		returns (uint256)
2897 	{
2898 		return getStorageValue(_property, _sender);
2899 	}
2900 
2901 	/**
2902 	 * Adds the user's staking amount in the Property.
2903 	 */
2904 	function addValue(
2905 		address _property,
2906 		address _sender,
2907 		uint256 _value
2908 	) private {
2909 		uint256 value = getStorageValue(_property, _sender);
2910 		value = value.add(_value);
2911 		setStorageValue(_property, _sender, value);
2912 	}
2913 
2914 	/**
2915 	 * Returns whether the user is staking in the Property.
2916 	 */
2917 	function hasValue(address _property, address _sender)
2918 		private
2919 		view
2920 		returns (bool)
2921 	{
2922 		uint256 value = getStorageValue(_property, _sender);
2923 		return value != 0;
2924 	}
2925 
2926 	/**
2927 	 * Returns whether a single user has all staking share.
2928 	 * This value is true when only one Property and one user is historically the only staker.
2929 	 */
2930 	function isSingle(address _property, address _user)
2931 		private
2932 		view
2933 		returns (bool)
2934 	{
2935 		uint256 perAccount = getStorageValue(_property, _user);
2936 		(uint256 cLockProperty, uint256 unitProperty, ) = getCumulativeLockedUp(
2937 			_property
2938 		);
2939 		(uint256 cLockTotal, , ) = getCumulativeLockedUpAll();
2940 		return perAccount == unitProperty && cLockProperty == cLockTotal;
2941 	}
2942 
2943 	/**
2944 	 * Returns the staking amount of the Property.
2945 	 */
2946 	function getPropertyValue(address _property)
2947 		external
2948 		view
2949 		returns (uint256)
2950 	{
2951 		return getStoragePropertyValue(_property);
2952 	}
2953 
2954 	/**
2955 	 * Adds the staking amount of the Property.
2956 	 */
2957 	function addPropertyValue(address _property, uint256 _value) private {
2958 		uint256 value = getStoragePropertyValue(_property);
2959 		value = value.add(_value);
2960 		setStoragePropertyValue(_property, value);
2961 	}
2962 
2963 	/**
2964 	 * Subtracts the staking amount of the Property.
2965 	 */
2966 	function subPropertyValue(address _property, uint256 _value) private {
2967 		uint256 value = getStoragePropertyValue(_property);
2968 		uint256 nextValue = value.sub(_value);
2969 		setStoragePropertyValue(_property, nextValue);
2970 	}
2971 
2972 	/**
2973 	 * Saves the latest reward amount as an undrawn amount.
2974 	 */
2975 	function updatePendingInterestWithdrawal(address _property, address _user)
2976 		private
2977 	{
2978 		/**
2979 		 * Gets the latest reward amount.
2980 		 */
2981 		uint256 withdrawableAmount = _calculateWithdrawableInterestAmount(
2982 			_property,
2983 			_user
2984 		);
2985 
2986 		/**
2987 		 * Saves the amount to `PendingInterestWithdrawal` storage.
2988 		 */
2989 		setStoragePendingInterestWithdrawal(
2990 			_property,
2991 			_user,
2992 			withdrawableAmount
2993 		);
2994 
2995 		/**
2996 		 * Updates the reward amount of before DIP4 to prevent further addition it.
2997 		 */
2998 		__updateLegacyWithdrawableInterestAmount(_property, _user);
2999 	}
3000 
3001 	/**
3002 	 * Returns whether the staking can be released.
3003 	 */
3004 	function possible(address _property, address _from)
3005 		private
3006 		view
3007 		returns (bool)
3008 	{
3009 		uint256 blockNumber = getStorageWithdrawalStatus(_property, _from);
3010 		if (blockNumber == 0) {
3011 			return false;
3012 		}
3013 		if (blockNumber <= block.number) {
3014 			return true;
3015 		} else {
3016 			if (IPolicy(config().policy()).lockUpBlocks() == 1) {
3017 				return true;
3018 			}
3019 		}
3020 		return false;
3021 	}
3022 
3023 	/**
3024 	 * Returns the reward amount of the calculation model before DIP4.
3025 	 * It can be calculated by subtracting "the last cumulative sum of reward unit price" from
3026 	 * "the current cumulative sum of reward unit price," and multiplying by the staking amount.
3027 	 */
3028 	function __legacyWithdrawableInterestAmount(
3029 		address _property,
3030 		address _user
3031 	) private view returns (uint256) {
3032 		uint256 _last = getStorageLastInterestPrice(_property, _user);
3033 		uint256 price = getStorageInterestPrice(_property);
3034 		uint256 priceGap = price.sub(_last);
3035 		uint256 lockedUpValue = getStorageValue(_property, _user);
3036 		uint256 value = priceGap.mul(lockedUpValue);
3037 		return value.divBasis();
3038 	}
3039 
3040 	/**
3041 	 * Updates and treats the reward of before DIP4 as already received.
3042 	 */
3043 	function __updateLegacyWithdrawableInterestAmount(
3044 		address _property,
3045 		address _user
3046 	) private {
3047 		uint256 interestPrice = getStorageInterestPrice(_property);
3048 		if (getStorageLastInterestPrice(_property, _user) != interestPrice) {
3049 			setStorageLastInterestPrice(_property, _user, interestPrice);
3050 		}
3051 	}
3052 
3053 	/**
3054 	 * Updates the block number of the time of DIP4 release.
3055 	 */
3056 	function setDIP4GenesisBlock(uint256 _block) external onlyOwner {
3057 		/**
3058 		 * Validates the value is not set.
3059 		 */
3060 		require(getStorageDIP4GenesisBlock() == 0, "already set the value");
3061 
3062 		/**
3063 		 * Sets the value.
3064 		 */
3065 		setStorageDIP4GenesisBlock(_block);
3066 	}
3067 }