1 pragma solidity ^0.5.0;
2 
3 /*
4  * @dev Provides information about the current execution context, including the
5  * sender of the transaction and its data. While these are generally available
6  * via msg.sender and msg.data, they should not be accessed in such a direct
7  * manner, since when dealing with GSN meta-transactions the account sending and
8  * paying for execution may not be the actual sender (as far as an application
9  * is concerned).
10  *
11  * This contract is only required for intermediate, library-like contracts.
12  */
13 contract Context {
14 	// Empty internal constructor, to prevent people from mistakenly deploying
15 	// an instance of this contract, which should be used via inheritance.
16 	constructor() internal {}
17 
18 	// solhint-disable-previous-line no-empty-blocks
19 
20 	function _msgSender() internal view returns (address payable) {
21 		return msg.sender;
22 	}
23 
24 	function _msgData() internal view returns (bytes memory) {
25 		this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
26 		return msg.data;
27 	}
28 }
29 
30 /**
31  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
32  * the optional functions; to access them see {ERC20Detailed}.
33  */
34 interface IERC20 {
35 	/**
36 	 * @dev Returns the amount of tokens in existence.
37 	 */
38 	function totalSupply() external view returns (uint256);
39 
40 	/**
41 	 * @dev Returns the amount of tokens owned by `account`.
42 	 */
43 	function balanceOf(address account) external view returns (uint256);
44 
45 	/**
46 	 * @dev Moves `amount` tokens from the caller's account to `recipient`.
47 	 *
48 	 * Returns a boolean value indicating whether the operation succeeded.
49 	 *
50 	 * Emits a {Transfer} event.
51 	 */
52 	function transfer(address recipient, uint256 amount)
53 		external
54 		returns (bool);
55 
56 	/**
57 	 * @dev Returns the remaining number of tokens that `spender` will be
58 	 * allowed to spend on behalf of `owner` through {transferFrom}. This is
59 	 * zero by default.
60 	 *
61 	 * This value changes when {approve} or {transferFrom} are called.
62 	 */
63 	function allowance(address owner, address spender)
64 		external
65 		view
66 		returns (uint256);
67 
68 	/**
69 	 * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
70 	 *
71 	 * Returns a boolean value indicating whether the operation succeeded.
72 	 *
73 	 * IMPORTANT: Beware that changing an allowance with this method brings the risk
74 	 * that someone may use both the old and the new allowance by unfortunate
75 	 * transaction ordering. One possible solution to mitigate this race
76 	 * condition is to first reduce the spender's allowance to 0 and set the
77 	 * desired value afterwards:
78 	 * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
79 	 *
80 	 * Emits an {Approval} event.
81 	 */
82 	function approve(address spender, uint256 amount) external returns (bool);
83 
84 	/**
85 	 * @dev Moves `amount` tokens from `sender` to `recipient` using the
86 	 * allowance mechanism. `amount` is then deducted from the caller's
87 	 * allowance.
88 	 *
89 	 * Returns a boolean value indicating whether the operation succeeded.
90 	 *
91 	 * Emits a {Transfer} event.
92 	 */
93 	function transferFrom(
94 		address sender,
95 		address recipient,
96 		uint256 amount
97 	) external returns (bool);
98 
99 	/**
100 	 * @dev Emitted when `value` tokens are moved from one account (`from`) to
101 	 * another (`to`).
102 	 *
103 	 * Note that `value` may be zero.
104 	 */
105 	event Transfer(address indexed from, address indexed to, uint256 value);
106 
107 	/**
108 	 * @dev Emitted when the allowance of a `spender` for an `owner` is set by
109 	 * a call to {approve}. `value` is the new allowance.
110 	 */
111 	event Approval(
112 		address indexed owner,
113 		address indexed spender,
114 		uint256 value
115 	);
116 }
117 
118 /**
119  * @dev Wrappers over Solidity's arithmetic operations with added overflow
120  * checks.
121  *
122  * Arithmetic operations in Solidity wrap on overflow. This can easily result
123  * in bugs, because programmers usually assume that an overflow raises an
124  * error, which is the standard behavior in high level programming languages.
125  * `SafeMath` restores this intuition by reverting the transaction when an
126  * operation overflows.
127  *
128  * Using this library instead of the unchecked operations eliminates an entire
129  * class of bugs, so it's recommended to use it always.
130  */
131 library SafeMath {
132 	/**
133 	 * @dev Returns the addition of two unsigned integers, reverting on
134 	 * overflow.
135 	 *
136 	 * Counterpart to Solidity's `+` operator.
137 	 *
138 	 * Requirements:
139 	 * - Addition cannot overflow.
140 	 */
141 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
142 		uint256 c = a + b;
143 		require(c >= a, "SafeMath: addition overflow");
144 
145 		return c;
146 	}
147 
148 	/**
149 	 * @dev Returns the subtraction of two unsigned integers, reverting on
150 	 * overflow (when the result is negative).
151 	 *
152 	 * Counterpart to Solidity's `-` operator.
153 	 *
154 	 * Requirements:
155 	 * - Subtraction cannot overflow.
156 	 */
157 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
158 		return sub(a, b, "SafeMath: subtraction overflow");
159 	}
160 
161 	/**
162 	 * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
163 	 * overflow (when the result is negative).
164 	 *
165 	 * Counterpart to Solidity's `-` operator.
166 	 *
167 	 * Requirements:
168 	 * - Subtraction cannot overflow.
169 	 *
170 	 * _Available since v2.4.0._
171 	 */
172 	function sub(
173 		uint256 a,
174 		uint256 b,
175 		string memory errorMessage
176 	) internal pure returns (uint256) {
177 		require(b <= a, errorMessage);
178 		uint256 c = a - b;
179 
180 		return c;
181 	}
182 
183 	/**
184 	 * @dev Returns the multiplication of two unsigned integers, reverting on
185 	 * overflow.
186 	 *
187 	 * Counterpart to Solidity's `*` operator.
188 	 *
189 	 * Requirements:
190 	 * - Multiplication cannot overflow.
191 	 */
192 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
193 		// Gas optimization: this is cheaper than requiring 'a' not being zero, but the
194 		// benefit is lost if 'b' is also tested.
195 		// See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
196 		if (a == 0) {
197 			return 0;
198 		}
199 
200 		uint256 c = a * b;
201 		require(c / a == b, "SafeMath: multiplication overflow");
202 
203 		return c;
204 	}
205 
206 	/**
207 	 * @dev Returns the integer division of two unsigned integers. Reverts on
208 	 * division by zero. The result is rounded towards zero.
209 	 *
210 	 * Counterpart to Solidity's `/` operator. Note: this function uses a
211 	 * `revert` opcode (which leaves remaining gas untouched) while Solidity
212 	 * uses an invalid opcode to revert (consuming all remaining gas).
213 	 *
214 	 * Requirements:
215 	 * - The divisor cannot be zero.
216 	 */
217 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
218 		return div(a, b, "SafeMath: division by zero");
219 	}
220 
221 	/**
222 	 * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
223 	 * division by zero. The result is rounded towards zero.
224 	 *
225 	 * Counterpart to Solidity's `/` operator. Note: this function uses a
226 	 * `revert` opcode (which leaves remaining gas untouched) while Solidity
227 	 * uses an invalid opcode to revert (consuming all remaining gas).
228 	 *
229 	 * Requirements:
230 	 * - The divisor cannot be zero.
231 	 *
232 	 * _Available since v2.4.0._
233 	 */
234 	function div(
235 		uint256 a,
236 		uint256 b,
237 		string memory errorMessage
238 	) internal pure returns (uint256) {
239 		// Solidity only automatically asserts when dividing by 0
240 		require(b > 0, errorMessage);
241 		uint256 c = a / b;
242 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
243 
244 		return c;
245 	}
246 
247 	/**
248 	 * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
249 	 * Reverts when dividing by zero.
250 	 *
251 	 * Counterpart to Solidity's `%` operator. This function uses a `revert`
252 	 * opcode (which leaves remaining gas untouched) while Solidity uses an
253 	 * invalid opcode to revert (consuming all remaining gas).
254 	 *
255 	 * Requirements:
256 	 * - The divisor cannot be zero.
257 	 */
258 	function mod(uint256 a, uint256 b) internal pure returns (uint256) {
259 		return mod(a, b, "SafeMath: modulo by zero");
260 	}
261 
262 	/**
263 	 * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
264 	 * Reverts with custom message when dividing by zero.
265 	 *
266 	 * Counterpart to Solidity's `%` operator. This function uses a `revert`
267 	 * opcode (which leaves remaining gas untouched) while Solidity uses an
268 	 * invalid opcode to revert (consuming all remaining gas).
269 	 *
270 	 * Requirements:
271 	 * - The divisor cannot be zero.
272 	 *
273 	 * _Available since v2.4.0._
274 	 */
275 	function mod(
276 		uint256 a,
277 		uint256 b,
278 		string memory errorMessage
279 	) internal pure returns (uint256) {
280 		require(b != 0, errorMessage);
281 		return a % b;
282 	}
283 }
284 
285 /**
286  * @dev Implementation of the {IERC20} interface.
287  *
288  * This implementation is agnostic to the way tokens are created. This means
289  * that a supply mechanism has to be added in a derived contract using {_mint}.
290  * For a generic mechanism see {ERC20Mintable}.
291  *
292  * TIP: For a detailed writeup see our guide
293  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
294  * to implement supply mechanisms].
295  *
296  * We have followed general OpenZeppelin guidelines: functions revert instead
297  * of returning `false` on failure. This behavior is nonetheless conventional
298  * and does not conflict with the expectations of ERC20 applications.
299  *
300  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
301  * This allows applications to reconstruct the allowance for all accounts just
302  * by listening to said events. Other implementations of the EIP may not emit
303  * these events, as it isn't required by the specification.
304  *
305  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
306  * functions have been added to mitigate the well-known issues around setting
307  * allowances. See {IERC20-approve}.
308  */
309 contract ERC20 is Context, IERC20 {
310 	using SafeMath for uint256;
311 
312 	mapping(address => uint256) private _balances;
313 
314 	mapping(address => mapping(address => uint256)) private _allowances;
315 
316 	uint256 private _totalSupply;
317 
318 	/**
319 	 * @dev See {IERC20-totalSupply}.
320 	 */
321 	function totalSupply() public view returns (uint256) {
322 		return _totalSupply;
323 	}
324 
325 	/**
326 	 * @dev See {IERC20-balanceOf}.
327 	 */
328 	function balanceOf(address account) public view returns (uint256) {
329 		return _balances[account];
330 	}
331 
332 	/**
333 	 * @dev See {IERC20-transfer}.
334 	 *
335 	 * Requirements:
336 	 *
337 	 * - `recipient` cannot be the zero address.
338 	 * - the caller must have a balance of at least `amount`.
339 	 */
340 	function transfer(address recipient, uint256 amount) public returns (bool) {
341 		_transfer(_msgSender(), recipient, amount);
342 		return true;
343 	}
344 
345 	/**
346 	 * @dev See {IERC20-allowance}.
347 	 */
348 	function allowance(address owner, address spender)
349 		public
350 		view
351 		returns (uint256)
352 	{
353 		return _allowances[owner][spender];
354 	}
355 
356 	/**
357 	 * @dev See {IERC20-approve}.
358 	 *
359 	 * Requirements:
360 	 *
361 	 * - `spender` cannot be the zero address.
362 	 */
363 	function approve(address spender, uint256 amount) public returns (bool) {
364 		_approve(_msgSender(), spender, amount);
365 		return true;
366 	}
367 
368 	/**
369 	 * @dev See {IERC20-transferFrom}.
370 	 *
371 	 * Emits an {Approval} event indicating the updated allowance. This is not
372 	 * required by the EIP. See the note at the beginning of {ERC20};
373 	 *
374 	 * Requirements:
375 	 * - `sender` and `recipient` cannot be the zero address.
376 	 * - `sender` must have a balance of at least `amount`.
377 	 * - the caller must have allowance for `sender`'s tokens of at least
378 	 * `amount`.
379 	 */
380 	function transferFrom(
381 		address sender,
382 		address recipient,
383 		uint256 amount
384 	) public returns (bool) {
385 		_transfer(sender, recipient, amount);
386 		_approve(
387 			sender,
388 			_msgSender(),
389 			_allowances[sender][_msgSender()].sub(
390 				amount,
391 				"ERC20: transfer amount exceeds allowance"
392 			)
393 		);
394 		return true;
395 	}
396 
397 	/**
398 	 * @dev Atomically increases the allowance granted to `spender` by the caller.
399 	 *
400 	 * This is an alternative to {approve} that can be used as a mitigation for
401 	 * problems described in {IERC20-approve}.
402 	 *
403 	 * Emits an {Approval} event indicating the updated allowance.
404 	 *
405 	 * Requirements:
406 	 *
407 	 * - `spender` cannot be the zero address.
408 	 */
409 	function increaseAllowance(address spender, uint256 addedValue)
410 		public
411 		returns (bool)
412 	{
413 		_approve(
414 			_msgSender(),
415 			spender,
416 			_allowances[_msgSender()][spender].add(addedValue)
417 		);
418 		return true;
419 	}
420 
421 	/**
422 	 * @dev Atomically decreases the allowance granted to `spender` by the caller.
423 	 *
424 	 * This is an alternative to {approve} that can be used as a mitigation for
425 	 * problems described in {IERC20-approve}.
426 	 *
427 	 * Emits an {Approval} event indicating the updated allowance.
428 	 *
429 	 * Requirements:
430 	 *
431 	 * - `spender` cannot be the zero address.
432 	 * - `spender` must have allowance for the caller of at least
433 	 * `subtractedValue`.
434 	 */
435 	function decreaseAllowance(address spender, uint256 subtractedValue)
436 		public
437 		returns (bool)
438 	{
439 		_approve(
440 			_msgSender(),
441 			spender,
442 			_allowances[_msgSender()][spender].sub(
443 				subtractedValue,
444 				"ERC20: decreased allowance below zero"
445 			)
446 		);
447 		return true;
448 	}
449 
450 	/**
451 	 * @dev Moves tokens `amount` from `sender` to `recipient`.
452 	 *
453 	 * This is internal function is equivalent to {transfer}, and can be used to
454 	 * e.g. implement automatic token fees, slashing mechanisms, etc.
455 	 *
456 	 * Emits a {Transfer} event.
457 	 *
458 	 * Requirements:
459 	 *
460 	 * - `sender` cannot be the zero address.
461 	 * - `recipient` cannot be the zero address.
462 	 * - `sender` must have a balance of at least `amount`.
463 	 */
464 	function _transfer(
465 		address sender,
466 		address recipient,
467 		uint256 amount
468 	) internal {
469 		require(sender != address(0), "ERC20: transfer from the zero address");
470 		require(recipient != address(0), "ERC20: transfer to the zero address");
471 
472 		_balances[sender] = _balances[sender].sub(
473 			amount,
474 			"ERC20: transfer amount exceeds balance"
475 		);
476 		_balances[recipient] = _balances[recipient].add(amount);
477 		emit Transfer(sender, recipient, amount);
478 	}
479 
480 	/** @dev Creates `amount` tokens and assigns them to `account`, increasing
481 	 * the total supply.
482 	 *
483 	 * Emits a {Transfer} event with `from` set to the zero address.
484 	 *
485 	 * Requirements
486 	 *
487 	 * - `to` cannot be the zero address.
488 	 */
489 	function _mint(address account, uint256 amount) internal {
490 		require(account != address(0), "ERC20: mint to the zero address");
491 
492 		_totalSupply = _totalSupply.add(amount);
493 		_balances[account] = _balances[account].add(amount);
494 		emit Transfer(address(0), account, amount);
495 	}
496 
497 	/**
498 	 * @dev Destroys `amount` tokens from `account`, reducing the
499 	 * total supply.
500 	 *
501 	 * Emits a {Transfer} event with `to` set to the zero address.
502 	 *
503 	 * Requirements
504 	 *
505 	 * - `account` cannot be the zero address.
506 	 * - `account` must have at least `amount` tokens.
507 	 */
508 	function _burn(address account, uint256 amount) internal {
509 		require(account != address(0), "ERC20: burn from the zero address");
510 
511 		_balances[account] = _balances[account].sub(
512 			amount,
513 			"ERC20: burn amount exceeds balance"
514 		);
515 		_totalSupply = _totalSupply.sub(amount);
516 		emit Transfer(account, address(0), amount);
517 	}
518 
519 	/**
520 	 * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
521 	 *
522 	 * This is internal function is equivalent to `approve`, and can be used to
523 	 * e.g. set automatic allowances for certain subsystems, etc.
524 	 *
525 	 * Emits an {Approval} event.
526 	 *
527 	 * Requirements:
528 	 *
529 	 * - `owner` cannot be the zero address.
530 	 * - `spender` cannot be the zero address.
531 	 */
532 	function _approve(
533 		address owner,
534 		address spender,
535 		uint256 amount
536 	) internal {
537 		require(owner != address(0), "ERC20: approve from the zero address");
538 		require(spender != address(0), "ERC20: approve to the zero address");
539 
540 		_allowances[owner][spender] = amount;
541 		emit Approval(owner, spender, amount);
542 	}
543 
544 	/**
545 	 * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
546 	 * from the caller's allowance.
547 	 *
548 	 * See {_burn} and {_approve}.
549 	 */
550 	function _burnFrom(address account, uint256 amount) internal {
551 		_burn(account, amount);
552 		_approve(
553 			account,
554 			_msgSender(),
555 			_allowances[account][_msgSender()].sub(
556 				amount,
557 				"ERC20: burn amount exceeds allowance"
558 			)
559 		);
560 	}
561 }
562 
563 // prettier-ignore
564 
565 /**
566  * @title Roles
567  * @dev Library for managing addresses assigned to a Role.
568  */
569 library Roles {
570     struct Role {
571         mapping (address => bool) bearer;
572     }
573 
574     /**
575      * @dev Give an account access to this role.
576      */
577     function add(Role storage role, address account) internal {
578         require(!has(role, account), "Roles: account already has role");
579         role.bearer[account] = true;
580     }
581 
582     /**
583      * @dev Remove an account's access to this role.
584      */
585     function remove(Role storage role, address account) internal {
586         require(has(role, account), "Roles: account does not have role");
587         role.bearer[account] = false;
588     }
589 
590     /**
591      * @dev Check if an account has this role.
592      * @return bool
593      */
594     function has(Role storage role, address account) internal view returns (bool) {
595         require(account != address(0), "Roles: account is the zero address");
596         return role.bearer[account];
597     }
598 }
599 
600 contract MinterRole is Context {
601 	using Roles for Roles.Role;
602 
603 	event MinterAdded(address indexed account);
604 	event MinterRemoved(address indexed account);
605 
606 	Roles.Role private _minters;
607 
608 	constructor() internal {
609 		_addMinter(_msgSender());
610 	}
611 
612 	modifier onlyMinter() {
613 		require(
614 			isMinter(_msgSender()),
615 			"MinterRole: caller does not have the Minter role"
616 		);
617 		_;
618 	}
619 
620 	function isMinter(address account) public view returns (bool) {
621 		return _minters.has(account);
622 	}
623 
624 	function addMinter(address account) public onlyMinter {
625 		_addMinter(account);
626 	}
627 
628 	function renounceMinter() public {
629 		_removeMinter(_msgSender());
630 	}
631 
632 	function _addMinter(address account) internal {
633 		_minters.add(account);
634 		emit MinterAdded(account);
635 	}
636 
637 	function _removeMinter(address account) internal {
638 		_minters.remove(account);
639 		emit MinterRemoved(account);
640 	}
641 }
642 
643 /**
644  * @dev Extension of {ERC20} that adds a set of accounts with the {MinterRole},
645  * which have permission to mint (create) new tokens as they see fit.
646  *
647  * At construction, the deployer of the contract is the only minter.
648  */
649 contract ERC20Mintable is ERC20, MinterRole {
650 	/**
651 	 * @dev See {ERC20-_mint}.
652 	 *
653 	 * Requirements:
654 	 *
655 	 * - the caller must have the {MinterRole}.
656 	 */
657 	function mint(address account, uint256 amount)
658 		public
659 		onlyMinter
660 		returns (bool)
661 	{
662 		_mint(account, amount);
663 		return true;
664 	}
665 }
666 
667 contract PauserRole is Context {
668 	using Roles for Roles.Role;
669 
670 	event PauserAdded(address indexed account);
671 	event PauserRemoved(address indexed account);
672 
673 	Roles.Role private _pausers;
674 
675 	constructor() internal {
676 		_addPauser(_msgSender());
677 	}
678 
679 	modifier onlyPauser() {
680 		require(
681 			isPauser(_msgSender()),
682 			"PauserRole: caller does not have the Pauser role"
683 		);
684 		_;
685 	}
686 
687 	function isPauser(address account) public view returns (bool) {
688 		return _pausers.has(account);
689 	}
690 
691 	function addPauser(address account) public onlyPauser {
692 		_addPauser(account);
693 	}
694 
695 	function renouncePauser() public {
696 		_removePauser(_msgSender());
697 	}
698 
699 	function _addPauser(address account) internal {
700 		_pausers.add(account);
701 		emit PauserAdded(account);
702 	}
703 
704 	function _removePauser(address account) internal {
705 		_pausers.remove(account);
706 		emit PauserRemoved(account);
707 	}
708 }
709 
710 /**
711  * @dev Contract module which allows children to implement an emergency stop
712  * mechanism that can be triggered by an authorized account.
713  *
714  * This module is used through inheritance. It will make available the
715  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
716  * the functions of your contract. Note that they will not be pausable by
717  * simply including this module, only once the modifiers are put in place.
718  */
719 contract Pausable is Context, PauserRole {
720 	/**
721 	 * @dev Emitted when the pause is triggered by a pauser (`account`).
722 	 */
723 	event Paused(address account);
724 
725 	/**
726 	 * @dev Emitted when the pause is lifted by a pauser (`account`).
727 	 */
728 	event Unpaused(address account);
729 
730 	bool private _paused;
731 
732 	/**
733 	 * @dev Initializes the contract in unpaused state. Assigns the Pauser role
734 	 * to the deployer.
735 	 */
736 	constructor() internal {
737 		_paused = false;
738 	}
739 
740 	/**
741 	 * @dev Returns true if the contract is paused, and false otherwise.
742 	 */
743 	function paused() public view returns (bool) {
744 		return _paused;
745 	}
746 
747 	/**
748 	 * @dev Modifier to make a function callable only when the contract is not paused.
749 	 */
750 	modifier whenNotPaused() {
751 		require(!_paused, "Pausable: paused");
752 		_;
753 	}
754 
755 	/**
756 	 * @dev Modifier to make a function callable only when the contract is paused.
757 	 */
758 	modifier whenPaused() {
759 		require(_paused, "Pausable: not paused");
760 		_;
761 	}
762 
763 	/**
764 	 * @dev Called by a pauser to pause, triggers stopped state.
765 	 */
766 	function pause() public onlyPauser whenNotPaused {
767 		_paused = true;
768 		emit Paused(_msgSender());
769 	}
770 
771 	/**
772 	 * @dev Called by a pauser to unpause, returns to normal state.
773 	 */
774 	function unpause() public onlyPauser whenPaused {
775 		_paused = false;
776 		emit Unpaused(_msgSender());
777 	}
778 }
779 
780 library Decimals {
781 	using SafeMath for uint256;
782 	uint120 private constant basisValue = 1000000000000000000;
783 
784 	function outOf(uint256 _a, uint256 _b)
785 		internal
786 		pure
787 		returns (uint256 result)
788 	{
789 		if (_a == 0) {
790 			return 0;
791 		}
792 		uint256 a = _a.mul(basisValue);
793 		if (a < _b) {
794 			return 0;
795 		}
796 		return (a.div(_b));
797 	}
798 
799 	function basis() external pure returns (uint120) {
800 		return basisValue;
801 	}
802 }
803 
804 // prettier-ignore
805 
806 contract IGroup {
807 	function isGroup(address _addr) public view returns (bool);
808 
809 	function addGroup(address _addr) external;
810 
811 	function getGroupKey(address _addr) internal pure returns (bytes32) {
812 		return keccak256(abi.encodePacked("_group", _addr));
813 	}
814 }
815 
816 contract AddressValidator {
817 	string constant errorMessage = "this is illegal address";
818 
819 	function validateIllegalAddress(address _addr) external pure {
820 		require(_addr != address(0), errorMessage);
821 	}
822 
823 	function validateGroup(address _addr, address _groupAddr) external view {
824 		require(IGroup(_groupAddr).isGroup(_addr), errorMessage);
825 	}
826 
827 	function validateGroups(
828 		address _addr,
829 		address _groupAddr1,
830 		address _groupAddr2
831 	) external view {
832 		if (IGroup(_groupAddr1).isGroup(_addr)) {
833 			return;
834 		}
835 		require(IGroup(_groupAddr2).isGroup(_addr), errorMessage);
836 	}
837 
838 	function validateAddress(address _addr, address _target) external pure {
839 		require(_addr == _target, errorMessage);
840 	}
841 
842 	function validateAddresses(
843 		address _addr,
844 		address _target1,
845 		address _target2
846 	) external pure {
847 		if (_addr == _target1) {
848 			return;
849 		}
850 		require(_addr == _target2, errorMessage);
851 	}
852 }
853 
854 contract UsingValidator {
855 	AddressValidator private _validator;
856 
857 	constructor() public {
858 		_validator = new AddressValidator();
859 	}
860 
861 	function addressValidator() internal view returns (AddressValidator) {
862 		return _validator;
863 	}
864 }
865 
866 // prettier-ignore
867 
868 /**
869  * @dev Optional functions from the ERC20 standard.
870  */
871 contract ERC20Detailed is IERC20 {
872     string private _name;
873     string private _symbol;
874     uint8 private _decimals;
875 
876     /**
877      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
878      * these values are immutable: they can only be set once during
879      * construction.
880      */
881     constructor (string memory name, string memory symbol, uint8 decimals) public {
882         _name = name;
883         _symbol = symbol;
884         _decimals = decimals;
885     }
886 
887     /**
888      * @dev Returns the name of the token.
889      */
890     function name() public view returns (string memory) {
891         return _name;
892     }
893 
894     /**
895      * @dev Returns the symbol of the token, usually a shorter version of the
896      * name.
897      */
898     function symbol() public view returns (string memory) {
899         return _symbol;
900     }
901 
902     /**
903      * @dev Returns the number of decimals used to get its user representation.
904      * For example, if `decimals` equals `2`, a balance of `505` tokens should
905      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
906      *
907      * Tokens usually opt for a value of 18, imitating the relationship between
908      * Ether and Wei.
909      *
910      * NOTE: This information is only used for _display_ purposes: it in
911      * no way affects any of the arithmetic of the contract, including
912      * {IERC20-balanceOf} and {IERC20-transfer}.
913      */
914     function decimals() public view returns (uint8) {
915         return _decimals;
916     }
917 }
918 
919 contract Killable {
920 	address payable public _owner;
921 
922 	constructor() internal {
923 		_owner = msg.sender;
924 	}
925 
926 	function kill() public {
927 		require(msg.sender == _owner, "only owner method");
928 		selfdestruct(_owner);
929 	}
930 }
931 
932 /**
933  * @dev Contract module which provides a basic access control mechanism, where
934  * there is an account (an owner) that can be granted exclusive access to
935  * specific functions.
936  *
937  * This module is used through inheritance. It will make available the modifier
938  * `onlyOwner`, which can be applied to your functions to restrict their use to
939  * the owner.
940  */
941 contract Ownable is Context {
942 	address private _owner;
943 
944 	event OwnershipTransferred(
945 		address indexed previousOwner,
946 		address indexed newOwner
947 	);
948 
949 	/**
950 	 * @dev Initializes the contract setting the deployer as the initial owner.
951 	 */
952 	constructor() internal {
953 		address msgSender = _msgSender();
954 		_owner = msgSender;
955 		emit OwnershipTransferred(address(0), msgSender);
956 	}
957 
958 	/**
959 	 * @dev Returns the address of the current owner.
960 	 */
961 	function owner() public view returns (address) {
962 		return _owner;
963 	}
964 
965 	/**
966 	 * @dev Throws if called by any account other than the owner.
967 	 */
968 	modifier onlyOwner() {
969 		require(isOwner(), "Ownable: caller is not the owner");
970 		_;
971 	}
972 
973 	/**
974 	 * @dev Returns true if the caller is the current owner.
975 	 */
976 	function isOwner() public view returns (bool) {
977 		return _msgSender() == _owner;
978 	}
979 
980 	/**
981 	 * @dev Leaves the contract without owner. It will not be possible to call
982 	 * `onlyOwner` functions anymore. Can only be called by the current owner.
983 	 *
984 	 * NOTE: Renouncing ownership will leave the contract without an owner,
985 	 * thereby removing any functionality that is only available to the owner.
986 	 */
987 	function renounceOwnership() public onlyOwner {
988 		emit OwnershipTransferred(_owner, address(0));
989 		_owner = address(0);
990 	}
991 
992 	/**
993 	 * @dev Transfers ownership of the contract to a new account (`newOwner`).
994 	 * Can only be called by the current owner.
995 	 */
996 	function transferOwnership(address newOwner) public onlyOwner {
997 		_transferOwnership(newOwner);
998 	}
999 
1000 	/**
1001 	 * @dev Transfers ownership of the contract to a new account (`newOwner`).
1002 	 */
1003 	function _transferOwnership(address newOwner) internal {
1004 		require(
1005 			newOwner != address(0),
1006 			"Ownable: new owner is the zero address"
1007 		);
1008 		emit OwnershipTransferred(_owner, newOwner);
1009 		_owner = newOwner;
1010 	}
1011 }
1012 
1013 contract AddressConfig is Ownable, UsingValidator, Killable {
1014 	address public token = 0x98626E2C9231f03504273d55f397409deFD4a093;
1015 	address public allocator;
1016 	address public allocatorStorage;
1017 	address public withdraw;
1018 	address public withdrawStorage;
1019 	address public marketFactory;
1020 	address public marketGroup;
1021 	address public propertyFactory;
1022 	address public propertyGroup;
1023 	address public metricsGroup;
1024 	address public metricsFactory;
1025 	address public policy;
1026 	address public policyFactory;
1027 	address public policySet;
1028 	address public policyGroup;
1029 	address public lockup;
1030 	address public lockupStorage;
1031 	address public voteTimes;
1032 	address public voteTimesStorage;
1033 	address public voteCounter;
1034 	address public voteCounterStorage;
1035 
1036 	function setAllocator(address _addr) external onlyOwner {
1037 		allocator = _addr;
1038 	}
1039 
1040 	function setAllocatorStorage(address _addr) external onlyOwner {
1041 		allocatorStorage = _addr;
1042 	}
1043 
1044 	function setWithdraw(address _addr) external onlyOwner {
1045 		withdraw = _addr;
1046 	}
1047 
1048 	function setWithdrawStorage(address _addr) external onlyOwner {
1049 		withdrawStorage = _addr;
1050 	}
1051 
1052 	function setMarketFactory(address _addr) external onlyOwner {
1053 		marketFactory = _addr;
1054 	}
1055 
1056 	function setMarketGroup(address _addr) external onlyOwner {
1057 		marketGroup = _addr;
1058 	}
1059 
1060 	function setPropertyFactory(address _addr) external onlyOwner {
1061 		propertyFactory = _addr;
1062 	}
1063 
1064 	function setPropertyGroup(address _addr) external onlyOwner {
1065 		propertyGroup = _addr;
1066 	}
1067 
1068 	function setMetricsFactory(address _addr) external onlyOwner {
1069 		metricsFactory = _addr;
1070 	}
1071 
1072 	function setMetricsGroup(address _addr) external onlyOwner {
1073 		metricsGroup = _addr;
1074 	}
1075 
1076 	function setPolicyFactory(address _addr) external onlyOwner {
1077 		policyFactory = _addr;
1078 	}
1079 
1080 	function setPolicyGroup(address _addr) external onlyOwner {
1081 		policyGroup = _addr;
1082 	}
1083 
1084 	function setPolicySet(address _addr) external onlyOwner {
1085 		policySet = _addr;
1086 	}
1087 
1088 	function setPolicy(address _addr) external {
1089 		addressValidator().validateAddress(msg.sender, policyFactory);
1090 		policy = _addr;
1091 	}
1092 
1093 	function setToken(address _addr) external onlyOwner {
1094 		token = _addr;
1095 	}
1096 
1097 	function setLockup(address _addr) external onlyOwner {
1098 		lockup = _addr;
1099 	}
1100 
1101 	function setLockupStorage(address _addr) external onlyOwner {
1102 		lockupStorage = _addr;
1103 	}
1104 
1105 	function setVoteTimes(address _addr) external onlyOwner {
1106 		voteTimes = _addr;
1107 	}
1108 
1109 	function setVoteTimesStorage(address _addr) external onlyOwner {
1110 		voteTimesStorage = _addr;
1111 	}
1112 
1113 	function setVoteCounter(address _addr) external onlyOwner {
1114 		voteCounter = _addr;
1115 	}
1116 
1117 	function setVoteCounterStorage(address _addr) external onlyOwner {
1118 		voteCounterStorage = _addr;
1119 	}
1120 }
1121 
1122 contract UsingConfig {
1123 	AddressConfig private _config;
1124 
1125 	constructor(address _addressConfig) public {
1126 		_config = AddressConfig(_addressConfig);
1127 	}
1128 
1129 	function config() internal view returns (AddressConfig) {
1130 		return _config;
1131 	}
1132 
1133 	function configAddress() external view returns (address) {
1134 		return address(_config);
1135 	}
1136 }
1137 
1138 contract IAllocator {
1139 	function allocate(address _metrics) external;
1140 
1141 	function calculatedCallback(address _metrics, uint256 _value) external;
1142 
1143 	function beforeBalanceChange(
1144 		address _property,
1145 		address _from,
1146 		address _to
1147 		// solium-disable-next-line indentation
1148 	) external;
1149 
1150 	function getRewardsAmount(address _property)
1151 		external
1152 		view
1153 		returns (uint256);
1154 
1155 	function allocation(
1156 		uint256 _blocks,
1157 		uint256 _mint,
1158 		uint256 _value,
1159 		uint256 _marketValue,
1160 		uint256 _assets,
1161 		uint256 _totalAssets
1162 	)
1163 		public
1164 		pure
1165 		returns (
1166 			// solium-disable-next-line indentation
1167 			uint256
1168 		);
1169 }
1170 
1171 contract EternalStorage {
1172 	address private currentOwner = msg.sender;
1173 
1174 	mapping(bytes32 => uint256) private uIntStorage;
1175 	mapping(bytes32 => string) private stringStorage;
1176 	mapping(bytes32 => address) private addressStorage;
1177 	mapping(bytes32 => bytes32) private bytesStorage;
1178 	mapping(bytes32 => bool) private boolStorage;
1179 	mapping(bytes32 => int256) private intStorage;
1180 
1181 	modifier onlyCurrentOwner() {
1182 		require(msg.sender == currentOwner, "not current owner");
1183 		_;
1184 	}
1185 
1186 	function changeOwner(address _newOwner) external {
1187 		require(msg.sender == currentOwner, "not current owner");
1188 		currentOwner = _newOwner;
1189 	}
1190 
1191 	// *** Getter Methods ***
1192 	function getUint(bytes32 _key) external view returns (uint256) {
1193 		return uIntStorage[_key];
1194 	}
1195 
1196 	function getString(bytes32 _key) external view returns (string memory) {
1197 		return stringStorage[_key];
1198 	}
1199 
1200 	function getAddress(bytes32 _key) external view returns (address) {
1201 		return addressStorage[_key];
1202 	}
1203 
1204 	function getBytes(bytes32 _key) external view returns (bytes32) {
1205 		return bytesStorage[_key];
1206 	}
1207 
1208 	function getBool(bytes32 _key) external view returns (bool) {
1209 		return boolStorage[_key];
1210 	}
1211 
1212 	function getInt(bytes32 _key) external view returns (int256) {
1213 		return intStorage[_key];
1214 	}
1215 
1216 	// *** Setter Methods ***
1217 	function setUint(bytes32 _key, uint256 _value) external onlyCurrentOwner {
1218 		uIntStorage[_key] = _value;
1219 	}
1220 
1221 	function setString(bytes32 _key, string calldata _value)
1222 		external
1223 		onlyCurrentOwner
1224 	{
1225 		stringStorage[_key] = _value;
1226 	}
1227 
1228 	function setAddress(bytes32 _key, address _value)
1229 		external
1230 		onlyCurrentOwner
1231 	{
1232 		addressStorage[_key] = _value;
1233 	}
1234 
1235 	function setBytes(bytes32 _key, bytes32 _value) external onlyCurrentOwner {
1236 		bytesStorage[_key] = _value;
1237 	}
1238 
1239 	function setBool(bytes32 _key, bool _value) external onlyCurrentOwner {
1240 		boolStorage[_key] = _value;
1241 	}
1242 
1243 	function setInt(bytes32 _key, int256 _value) external onlyCurrentOwner {
1244 		intStorage[_key] = _value;
1245 	}
1246 
1247 	// *** Delete Methods ***
1248 	function deleteUint(bytes32 _key) external onlyCurrentOwner {
1249 		delete uIntStorage[_key];
1250 	}
1251 
1252 	function deleteString(bytes32 _key) external onlyCurrentOwner {
1253 		delete stringStorage[_key];
1254 	}
1255 
1256 	function deleteAddress(bytes32 _key) external onlyCurrentOwner {
1257 		delete addressStorage[_key];
1258 	}
1259 
1260 	function deleteBytes(bytes32 _key) external onlyCurrentOwner {
1261 		delete bytesStorage[_key];
1262 	}
1263 
1264 	function deleteBool(bytes32 _key) external onlyCurrentOwner {
1265 		delete boolStorage[_key];
1266 	}
1267 
1268 	function deleteInt(bytes32 _key) external onlyCurrentOwner {
1269 		delete intStorage[_key];
1270 	}
1271 }
1272 
1273 contract UsingStorage is Ownable, Pausable {
1274 	address private _storage;
1275 
1276 	modifier hasStorage() {
1277 		require(_storage != address(0), "storage is not setted");
1278 		_;
1279 	}
1280 
1281 	function eternalStorage()
1282 		internal
1283 		view
1284 		hasStorage
1285 		returns (EternalStorage)
1286 	{
1287 		require(paused() == false, "You cannot use that");
1288 		return EternalStorage(_storage);
1289 	}
1290 
1291 	function getStorageAddress() external view hasStorage returns (address) {
1292 		return _storage;
1293 	}
1294 
1295 	function createStorage() external onlyOwner {
1296 		require(_storage == address(0), "storage is setted");
1297 		EternalStorage tmp = new EternalStorage();
1298 		_storage = address(tmp);
1299 	}
1300 
1301 	function setStorage(address _storageAddress) external onlyOwner {
1302 		_storage = _storageAddress;
1303 	}
1304 
1305 	function changeOwner(address newOwner) external onlyOwner {
1306 		EternalStorage(_storage).changeOwner(newOwner);
1307 	}
1308 }
1309 
1310 contract VoteTimesStorage is
1311 	UsingStorage,
1312 	UsingConfig,
1313 	UsingValidator,
1314 	Killable
1315 {
1316 	// solium-disable-next-line no-empty-blocks
1317 	constructor(address _config) public UsingConfig(_config) {}
1318 
1319 	// Vote Times
1320 	function getVoteTimes() external view returns (uint256) {
1321 		return eternalStorage().getUint(getVoteTimesKey());
1322 	}
1323 
1324 	function setVoteTimes(uint256 times) external {
1325 		addressValidator().validateAddress(msg.sender, config().voteTimes());
1326 
1327 		return eternalStorage().setUint(getVoteTimesKey(), times);
1328 	}
1329 
1330 	function getVoteTimesKey() private pure returns (bytes32) {
1331 		return keccak256(abi.encodePacked("_voteTimes"));
1332 	}
1333 
1334 	//Vote Times By Property
1335 	function getVoteTimesByProperty(address _property)
1336 		external
1337 		view
1338 		returns (uint256)
1339 	{
1340 		return eternalStorage().getUint(getVoteTimesByPropertyKey(_property));
1341 	}
1342 
1343 	function setVoteTimesByProperty(address _property, uint256 times) external {
1344 		addressValidator().validateAddress(msg.sender, config().voteTimes());
1345 
1346 		return
1347 			eternalStorage().setUint(
1348 				getVoteTimesByPropertyKey(_property),
1349 				times
1350 			);
1351 	}
1352 
1353 	function getVoteTimesByPropertyKey(address _property)
1354 		private
1355 		pure
1356 		returns (bytes32)
1357 	{
1358 		return keccak256(abi.encodePacked("_voteTimesByProperty", _property));
1359 	}
1360 }
1361 
1362 contract VoteTimes is UsingConfig, UsingValidator, Killable {
1363 	using SafeMath for uint256;
1364 
1365 	// solium-disable-next-line no-empty-blocks
1366 	constructor(address _config) public UsingConfig(_config) {}
1367 
1368 	function addVoteTime() external {
1369 		addressValidator().validateAddresses(
1370 			msg.sender,
1371 			config().marketFactory(),
1372 			config().policyFactory()
1373 		);
1374 
1375 		uint256 voteTimes = getStorage().getVoteTimes();
1376 		voteTimes = voteTimes.add(1);
1377 		getStorage().setVoteTimes(voteTimes);
1378 	}
1379 
1380 	function addVoteTimesByProperty(address _property) external {
1381 		addressValidator().validateAddress(msg.sender, config().voteCounter());
1382 
1383 		uint256 voteTimesByProperty = getStorage().getVoteTimesByProperty(
1384 			_property
1385 		);
1386 		voteTimesByProperty = voteTimesByProperty.add(1);
1387 		getStorage().setVoteTimesByProperty(_property, voteTimesByProperty);
1388 	}
1389 
1390 	function resetVoteTimesByProperty(address _property) external {
1391 		addressValidator().validateAddresses(
1392 			msg.sender,
1393 			config().allocator(),
1394 			config().propertyFactory()
1395 		);
1396 
1397 		uint256 voteTimes = getStorage().getVoteTimes();
1398 		getStorage().setVoteTimesByProperty(_property, voteTimes);
1399 	}
1400 
1401 	function getAbstentionTimes(address _property)
1402 		external
1403 		view
1404 		returns (uint256)
1405 	{
1406 		uint256 voteTimes = getStorage().getVoteTimes();
1407 		uint256 voteTimesByProperty = getStorage().getVoteTimesByProperty(
1408 			_property
1409 		);
1410 		return voteTimes.sub(voteTimesByProperty);
1411 	}
1412 
1413 	function getStorage() private view returns (VoteTimesStorage) {
1414 		return VoteTimesStorage(config().voteTimesStorage());
1415 	}
1416 }
1417 
1418 // prettier-ignore
1419 
1420 contract VoteCounterStorage is UsingStorage, UsingConfig, UsingValidator {
1421 	// solium-disable-next-line no-empty-blocks
1422 	constructor(address _config) public UsingConfig(_config) {}
1423 
1424 	// Already Vote Flg
1425 	function setAlreadyVoteFlg(
1426 		address _user,
1427 		address _sender,
1428 		address _property
1429 	) external {
1430 		addressValidator().validateAddress(msg.sender, config().voteCounter());
1431 
1432 		bytes32 alreadyVoteKey = getAlreadyVoteKey(_user, _sender, _property);
1433 		return eternalStorage().setBool(alreadyVoteKey, true);
1434 	}
1435 
1436 	function getAlreadyVoteFlg(
1437 		address _user,
1438 		address _sender,
1439 		address _property
1440 	) external view returns (bool) {
1441 		bytes32 alreadyVoteKey = getAlreadyVoteKey(_user, _sender, _property);
1442 		return eternalStorage().getBool(alreadyVoteKey);
1443 	}
1444 
1445 	function getAlreadyVoteKey(
1446 		address _sender,
1447 		address _target,
1448 		address _property
1449 	) private pure returns (bytes32) {
1450 		return
1451 			keccak256(
1452 				abi.encodePacked("_alreadyVote", _sender, _target, _property)
1453 			);
1454 	}
1455 
1456 	// Agree Count
1457 	function getAgreeCount(address _sender) external view returns (uint256) {
1458 		return eternalStorage().getUint(getAgreeVoteCountKey(_sender));
1459 	}
1460 
1461 	function setAgreeCount(address _sender, uint256 count) external {
1462 		addressValidator().validateAddress(msg.sender, config().voteCounter());
1463 
1464 		eternalStorage().setUint(getAgreeVoteCountKey(_sender), count);
1465 	}
1466 
1467 	function getAgreeVoteCountKey(address _sender)
1468 		private
1469 		pure
1470 		returns (bytes32)
1471 	{
1472 		return keccak256(abi.encodePacked(_sender, "_agreeVoteCount"));
1473 	}
1474 
1475 	// Opposite Count
1476 	function getOppositeCount(address _sender) external view returns (uint256) {
1477 		return eternalStorage().getUint(getOppositeVoteCountKey(_sender));
1478 	}
1479 
1480 	function setOppositeCount(address _sender, uint256 count) external {
1481 		addressValidator().validateAddress(msg.sender, config().voteCounter());
1482 
1483 		eternalStorage().setUint(getOppositeVoteCountKey(_sender), count);
1484 	}
1485 
1486 	function getOppositeVoteCountKey(address _sender)
1487 		private
1488 		pure
1489 		returns (bytes32)
1490 	{
1491 		return keccak256(abi.encodePacked(_sender, "_oppositeVoteCount"));
1492 	}
1493 }
1494 
1495 contract VoteCounter is UsingConfig, UsingValidator, Killable {
1496 	using SafeMath for uint256;
1497 
1498 	// solium-disable-next-line no-empty-blocks
1499 	constructor(address _config) public UsingConfig(_config) {}
1500 
1501 	function addVoteCount(
1502 		address _user,
1503 		address _property,
1504 		bool _agree
1505 	) external {
1506 		addressValidator().validateGroups(
1507 			msg.sender,
1508 			config().marketGroup(),
1509 			config().policyGroup()
1510 		);
1511 
1512 		bool alreadyVote = getStorage().getAlreadyVoteFlg(
1513 			_user,
1514 			msg.sender,
1515 			_property
1516 		);
1517 		require(alreadyVote == false, "already vote");
1518 		uint256 voteCount = getVoteCount(_user, _property);
1519 		require(voteCount != 0, "vote count is 0");
1520 		getStorage().setAlreadyVoteFlg(_user, msg.sender, _property);
1521 		if (_agree) {
1522 			addAgreeCount(msg.sender, voteCount);
1523 		} else {
1524 			addOppositeCount(msg.sender, voteCount);
1525 		}
1526 	}
1527 
1528 	function getAgreeCount(address _sender) external view returns (uint256) {
1529 		return getStorage().getAgreeCount(_sender);
1530 	}
1531 
1532 	function getOppositeCount(address _sender) external view returns (uint256) {
1533 		return getStorage().getOppositeCount(_sender);
1534 	}
1535 
1536 	function getVoteCount(address _sender, address _property)
1537 		private
1538 		returns (uint256)
1539 	{
1540 		uint256 voteCount;
1541 		if (Property(_property).author() == _sender) {
1542 			// solium-disable-next-line operator-whitespace
1543 			voteCount = Lockup(config().lockup())
1544 				.getPropertyValue(_property)
1545 				.add(
1546 				Allocator(config().allocator()).getRewardsAmount(_property)
1547 			);
1548 			VoteTimes(config().voteTimes()).addVoteTimesByProperty(_property);
1549 		} else {
1550 			voteCount = Lockup(config().lockup()).getValue(_property, _sender);
1551 		}
1552 		return voteCount;
1553 	}
1554 
1555 	function addAgreeCount(address _target, uint256 _voteCount) private {
1556 		uint256 agreeCount = getStorage().getAgreeCount(_target);
1557 		agreeCount = agreeCount.add(_voteCount);
1558 		getStorage().setAgreeCount(_target, agreeCount);
1559 	}
1560 
1561 	function addOppositeCount(address _target, uint256 _voteCount) private {
1562 		uint256 oppositeCount = getStorage().getOppositeCount(_target);
1563 		oppositeCount = oppositeCount.add(_voteCount);
1564 		getStorage().setOppositeCount(_target, oppositeCount);
1565 	}
1566 
1567 	function getStorage() private view returns (VoteCounterStorage) {
1568 		return VoteCounterStorage(config().voteCounterStorage());
1569 	}
1570 }
1571 
1572 contract IMarket {
1573 	function authenticate(
1574 		address _prop,
1575 		string memory _args1,
1576 		string memory _args2,
1577 		string memory _args3,
1578 		string memory _args4,
1579 		string memory _args5
1580 	)
1581 		public
1582 		returns (
1583 			// solium-disable-next-line indentation
1584 			address
1585 		);
1586 
1587 	function authenticatedCallback(address _property, bytes32 _idHash)
1588 		external
1589 		returns (address);
1590 
1591 	function deauthenticate(address _metrics) external;
1592 
1593 	function vote(address _property, bool _agree) external;
1594 
1595 	function schema() external view returns (string memory);
1596 
1597 	function behavior() external view returns (address);
1598 }
1599 
1600 contract IMarketBehavior {
1601 	string public schema;
1602 
1603 	function authenticate(
1604 		address _prop,
1605 		string memory _args1,
1606 		string memory _args2,
1607 		string memory _args3,
1608 		string memory _args4,
1609 		string memory _args5,
1610 		address market
1611 	)
1612 		public
1613 		returns (
1614 			// solium-disable-next-line indentation
1615 			address
1616 		);
1617 
1618 	function calculate(
1619 		address _metrics,
1620 		uint256 _start,
1621 		uint256 _end
1622 	)
1623 		external
1624 		returns (
1625 			// solium-disable-next-line indentation
1626 			bool
1627 		);
1628 
1629 	function getId(address _metrics) external view returns (string memory);
1630 }
1631 
1632 contract PropertyGroup is
1633 	UsingConfig,
1634 	UsingStorage,
1635 	UsingValidator,
1636 	IGroup,
1637 	Killable
1638 {
1639 	// solium-disable-next-line no-empty-blocks
1640 	constructor(address _config) public UsingConfig(_config) {}
1641 
1642 	function addGroup(address _addr) external {
1643 		addressValidator().validateAddress(
1644 			msg.sender,
1645 			config().propertyFactory()
1646 		);
1647 
1648 		require(isGroup(_addr) == false, "already enabled");
1649 		eternalStorage().setBool(getGroupKey(_addr), true);
1650 	}
1651 
1652 	function isGroup(address _addr) public view returns (bool) {
1653 		return eternalStorage().getBool(getGroupKey(_addr));
1654 	}
1655 }
1656 
1657 contract IPolicy {
1658 	function rewards(uint256 _lockups, uint256 _assets)
1659 		external
1660 		view
1661 		returns (uint256);
1662 
1663 	function holdersShare(uint256 _amount, uint256 _lockups)
1664 		external
1665 		view
1666 		returns (uint256);
1667 
1668 	function assetValue(uint256 _value, uint256 _lockups)
1669 		external
1670 		view
1671 		returns (uint256);
1672 
1673 	function authenticationFee(uint256 _assets, uint256 _propertyAssets)
1674 		external
1675 		view
1676 		returns (uint256);
1677 
1678 	function marketApproval(uint256 _agree, uint256 _opposite)
1679 		external
1680 		view
1681 		returns (bool);
1682 
1683 	function policyApproval(uint256 _agree, uint256 _opposite)
1684 		external
1685 		view
1686 		returns (bool);
1687 
1688 	function marketVotingBlocks() external view returns (uint256);
1689 
1690 	function policyVotingBlocks() external view returns (uint256);
1691 
1692 	function abstentionPenalty(uint256 _count) external view returns (uint256);
1693 
1694 	function lockUpBlocks() external view returns (uint256);
1695 }
1696 
1697 contract MarketGroup is
1698 	UsingConfig,
1699 	UsingStorage,
1700 	IGroup,
1701 	UsingValidator,
1702 	Killable
1703 {
1704 	using SafeMath for uint256;
1705 
1706 	// solium-disable-next-line no-empty-blocks
1707 	constructor(address _config) public UsingConfig(_config) UsingStorage() {}
1708 
1709 	function addGroup(address _addr) external {
1710 		addressValidator().validateAddress(
1711 			msg.sender,
1712 			config().marketFactory()
1713 		);
1714 
1715 		require(isGroup(_addr) == false, "already enabled");
1716 		eternalStorage().setBool(getGroupKey(_addr), true);
1717 		addCount();
1718 	}
1719 
1720 	function isGroup(address _addr) public view returns (bool) {
1721 		return eternalStorage().getBool(getGroupKey(_addr));
1722 	}
1723 
1724 	function addCount() private {
1725 		bytes32 key = getCountKey();
1726 		uint256 number = eternalStorage().getUint(key);
1727 		number = number.add(1);
1728 		eternalStorage().setUint(key, number);
1729 	}
1730 
1731 	function getCount() external view returns (uint256) {
1732 		bytes32 key = getCountKey();
1733 		return eternalStorage().getUint(key);
1734 	}
1735 
1736 	function getCountKey() private pure returns (bytes32) {
1737 		return keccak256(abi.encodePacked("_count"));
1738 	}
1739 }
1740 
1741 contract PolicySet is UsingConfig, UsingStorage, UsingValidator, Killable {
1742 	using SafeMath for uint256;
1743 
1744 	// solium-disable-next-line no-empty-blocks
1745 	constructor(address _config) public UsingConfig(_config) {}
1746 
1747 	function addSet(address _addr) external {
1748 		addressValidator().validateAddress(
1749 			msg.sender,
1750 			config().policyFactory()
1751 		);
1752 
1753 		uint256 index = eternalStorage().getUint(getPlicySetIndexKey());
1754 		bytes32 key = getIndexKey(index);
1755 		eternalStorage().setAddress(key, _addr);
1756 		index = index.add(1);
1757 		eternalStorage().setUint(getPlicySetIndexKey(), index);
1758 	}
1759 
1760 	function deleteAll() external {
1761 		addressValidator().validateAddress(
1762 			msg.sender,
1763 			config().policyFactory()
1764 		);
1765 
1766 		uint256 index = eternalStorage().getUint(getPlicySetIndexKey());
1767 		for (uint256 i = 0; i < index; i++) {
1768 			bytes32 key = getIndexKey(i);
1769 			eternalStorage().setAddress(key, address(0));
1770 		}
1771 		eternalStorage().setUint(getPlicySetIndexKey(), 0);
1772 	}
1773 
1774 	function count() external view returns (uint256) {
1775 		return eternalStorage().getUint(getPlicySetIndexKey());
1776 	}
1777 
1778 	function get(uint256 _index) external view returns (address) {
1779 		bytes32 key = getIndexKey(_index);
1780 		return eternalStorage().getAddress(key);
1781 	}
1782 
1783 	function getIndexKey(uint256 _index) private pure returns (bytes32) {
1784 		return keccak256(abi.encodePacked("_index", _index));
1785 	}
1786 
1787 	function getPlicySetIndexKey() private pure returns (bytes32) {
1788 		return keccak256(abi.encodePacked("_policySetIndex"));
1789 	}
1790 }
1791 
1792 contract PolicyGroup is
1793 	UsingConfig,
1794 	UsingStorage,
1795 	UsingValidator,
1796 	IGroup,
1797 	Killable
1798 {
1799 	// solium-disable-next-line no-empty-blocks
1800 	constructor(address _config) public UsingConfig(_config) {}
1801 
1802 	function addGroup(address _addr) external {
1803 		addressValidator().validateAddress(
1804 			msg.sender,
1805 			config().policyFactory()
1806 		);
1807 
1808 		require(isGroup(_addr) == false, "already enabled");
1809 		eternalStorage().setBool(getGroupKey(_addr), true);
1810 	}
1811 
1812 	function deleteGroup(address _addr) external {
1813 		addressValidator().validateAddress(
1814 			msg.sender,
1815 			config().policyFactory()
1816 		);
1817 
1818 		require(isGroup(_addr), "not enabled");
1819 		return eternalStorage().setBool(getGroupKey(_addr), false);
1820 	}
1821 
1822 	function isGroup(address _addr) public view returns (bool) {
1823 		return eternalStorage().getBool(getGroupKey(_addr));
1824 	}
1825 }
1826 
1827 contract PolicyFactory is Pausable, UsingConfig, UsingValidator, Killable {
1828 	event Create(address indexed _from, address _policy, address _innerPolicy);
1829 
1830 	// solium-disable-next-line no-empty-blocks
1831 	constructor(address _config) public UsingConfig(_config) {}
1832 
1833 	function create(address _newPolicyAddress) external returns (address) {
1834 		require(paused() == false, "You cannot use that");
1835 		addressValidator().validateIllegalAddress(_newPolicyAddress);
1836 
1837 		Policy policy = new Policy(address(config()), _newPolicyAddress);
1838 		address policyAddress = address(policy);
1839 		emit Create(msg.sender, policyAddress, _newPolicyAddress);
1840 		if (config().policy() == address(0)) {
1841 			config().setPolicy(policyAddress);
1842 		} else {
1843 			VoteTimes(config().voteTimes()).addVoteTime();
1844 		}
1845 		PolicyGroup policyGroup = PolicyGroup(config().policyGroup());
1846 		policyGroup.addGroup(policyAddress);
1847 		PolicySet policySet = PolicySet(config().policySet());
1848 		policySet.addSet(policyAddress);
1849 		return policyAddress;
1850 	}
1851 
1852 	function convergePolicy(address _currentPolicyAddress) external {
1853 		addressValidator().validateGroup(msg.sender, config().policyGroup());
1854 
1855 		config().setPolicy(_currentPolicyAddress);
1856 		PolicySet policySet = PolicySet(config().policySet());
1857 		PolicyGroup policyGroup = PolicyGroup(config().policyGroup());
1858 		for (uint256 i = 0; i < policySet.count(); i++) {
1859 			address policyAddress = policySet.get(i);
1860 			if (policyAddress == _currentPolicyAddress) {
1861 				continue;
1862 			}
1863 			Policy(policyAddress).kill();
1864 			policyGroup.deleteGroup(policyAddress);
1865 		}
1866 		policySet.deleteAll();
1867 		policySet.addSet(_currentPolicyAddress);
1868 	}
1869 }
1870 
1871 contract Policy is Killable, UsingConfig, UsingValidator {
1872 	using SafeMath for uint256;
1873 	IPolicy private _policy;
1874 	uint256 private _votingEndBlockNumber;
1875 
1876 	constructor(address _config, address _innerPolicyAddress)
1877 		public
1878 		UsingConfig(_config)
1879 	{
1880 		addressValidator().validateAddress(
1881 			msg.sender,
1882 			config().policyFactory()
1883 		);
1884 
1885 		_policy = IPolicy(_innerPolicyAddress);
1886 		setVotingEndBlockNumber();
1887 	}
1888 
1889 	function voting() public view returns (bool) {
1890 		return block.number <= _votingEndBlockNumber;
1891 	}
1892 
1893 	function rewards(uint256 _lockups, uint256 _assets)
1894 		external
1895 		view
1896 		returns (uint256)
1897 	{
1898 		return _policy.rewards(_lockups, _assets);
1899 	}
1900 
1901 	function holdersShare(uint256 _amount, uint256 _lockups)
1902 		external
1903 		view
1904 		returns (uint256)
1905 	{
1906 		return _policy.holdersShare(_amount, _lockups);
1907 	}
1908 
1909 	function assetValue(uint256 _value, uint256 _lockups)
1910 		external
1911 		view
1912 		returns (uint256)
1913 	{
1914 		return _policy.assetValue(_value, _lockups);
1915 	}
1916 
1917 	function authenticationFee(uint256 _assets, uint256 _propertyAssets)
1918 		external
1919 		view
1920 		returns (uint256)
1921 	{
1922 		return _policy.authenticationFee(_assets, _propertyAssets);
1923 	}
1924 
1925 	function marketApproval(uint256 _agree, uint256 _opposite)
1926 		external
1927 		view
1928 		returns (bool)
1929 	{
1930 		return _policy.marketApproval(_agree, _opposite);
1931 	}
1932 
1933 	function policyApproval(uint256 _agree, uint256 _opposite)
1934 		external
1935 		view
1936 		returns (bool)
1937 	{
1938 		return _policy.policyApproval(_agree, _opposite);
1939 	}
1940 
1941 	function marketVotingBlocks() external view returns (uint256) {
1942 		return _policy.marketVotingBlocks();
1943 	}
1944 
1945 	function policyVotingBlocks() external view returns (uint256) {
1946 		return _policy.policyVotingBlocks();
1947 	}
1948 
1949 	function abstentionPenalty(uint256 _count) external view returns (uint256) {
1950 		return _policy.abstentionPenalty(_count);
1951 	}
1952 
1953 	function lockUpBlocks() external view returns (uint256) {
1954 		return _policy.lockUpBlocks();
1955 	}
1956 
1957 	function vote(address _property, bool _agree) external {
1958 		addressValidator().validateGroup(_property, config().propertyGroup());
1959 
1960 		require(config().policy() != address(this), "this policy is current");
1961 		require(voting(), "voting deadline is over");
1962 		VoteCounter voteCounter = VoteCounter(config().voteCounter());
1963 		voteCounter.addVoteCount(msg.sender, _property, _agree);
1964 		bool result = Policy(config().policy()).policyApproval(
1965 			voteCounter.getAgreeCount(address(this)),
1966 			voteCounter.getOppositeCount(address(this))
1967 		);
1968 		if (result == false) {
1969 			return;
1970 		}
1971 		PolicyFactory(config().policyFactory()).convergePolicy(address(this));
1972 		_votingEndBlockNumber = 0;
1973 	}
1974 
1975 	function setVotingEndBlockNumber() private {
1976 		if (config().policy() == address(0)) {
1977 			return;
1978 		}
1979 		uint256 tmp = Policy(config().policy()).policyVotingBlocks();
1980 		_votingEndBlockNumber = block.number.add(tmp);
1981 	}
1982 }
1983 
1984 contract Metrics {
1985 	address public market;
1986 	address public property;
1987 
1988 	constructor(address _market, address _property) public {
1989 		//Do not validate because there is no AddressConfig
1990 		market = _market;
1991 		property = _property;
1992 	}
1993 }
1994 
1995 contract MetricsGroup is UsingConfig, UsingStorage, UsingValidator, IGroup {
1996 	using SafeMath for uint256;
1997 
1998 	// solium-disable-next-line no-empty-blocks
1999 	constructor(address _config) public UsingConfig(_config) {}
2000 
2001 	function addGroup(address _addr) external {
2002 		require(paused() == false, "You cannot use that");
2003 		addressValidator().validateAddress(
2004 			msg.sender,
2005 			config().metricsFactory()
2006 		);
2007 
2008 		require(isGroup(_addr) == false, "already enabled");
2009 		eternalStorage().setBool(getGroupKey(_addr), true);
2010 		uint256 totalCount = eternalStorage().getUint(getTotalCountKey());
2011 		totalCount = totalCount.add(1);
2012 		eternalStorage().setUint(getTotalCountKey(), totalCount);
2013 	}
2014 
2015 	function removeGroup(address _addr) external {
2016 		require(paused() == false, "You cannot use that");
2017 		addressValidator().validateAddress(
2018 			msg.sender,
2019 			config().metricsFactory()
2020 		);
2021 
2022 		require(isGroup(_addr), "address is not group");
2023 		eternalStorage().setBool(getGroupKey(_addr), false);
2024 		uint256 totalCount = eternalStorage().getUint(getTotalCountKey());
2025 		totalCount = totalCount.sub(1);
2026 		eternalStorage().setUint(getTotalCountKey(), totalCount);
2027 	}
2028 
2029 	function isGroup(address _addr) public view returns (bool) {
2030 		return eternalStorage().getBool(getGroupKey(_addr));
2031 	}
2032 
2033 	function totalIssuedMetrics() external view returns (uint256) {
2034 		return eternalStorage().getUint(getTotalCountKey());
2035 	}
2036 
2037 	function getTotalCountKey() private pure returns (bytes32) {
2038 		return keccak256(abi.encodePacked("_totalCount"));
2039 	}
2040 }
2041 
2042 contract MetricsFactory is Pausable, UsingConfig, UsingValidator {
2043 	event Create(address indexed _from, address _metrics);
2044 	event Destroy(address indexed _from, address _metrics);
2045 
2046 	// solium-disable-next-line no-empty-blocks
2047 	constructor(address _config) public UsingConfig(_config) {}
2048 
2049 	function create(address _property) external returns (address) {
2050 		require(paused() == false, "You cannot use that");
2051 		addressValidator().validateGroup(msg.sender, config().marketGroup());
2052 
2053 		Metrics metrics = new Metrics(msg.sender, _property);
2054 		MetricsGroup metricsGroup = MetricsGroup(config().metricsGroup());
2055 		address metricsAddress = address(metrics);
2056 		metricsGroup.addGroup(metricsAddress);
2057 		emit Create(msg.sender, metricsAddress);
2058 		return metricsAddress;
2059 	}
2060 
2061 	function destroy(address _metrics) external {
2062 		require(paused() == false, "You cannot use that");
2063 
2064 		MetricsGroup metricsGroup = MetricsGroup(config().metricsGroup());
2065 		require(metricsGroup.isGroup(_metrics), "address is not metrics");
2066 		addressValidator().validateGroup(msg.sender, config().marketGroup());
2067 		Metrics metrics = Metrics(_metrics);
2068 		addressValidator().validateAddress(msg.sender, metrics.market());
2069 		metricsGroup.removeGroup(_metrics);
2070 		emit Destroy(msg.sender, _metrics);
2071 	}
2072 }
2073 
2074 // prettier-ignore
2075 // prettier-ignore
2076 // prettier-ignore
2077 
2078 /**
2079  * @dev Extension of {ERC20} that allows token holders to destroy both their own
2080  * tokens and those that they have an allowance for, in a way that can be
2081  * recognized off-chain (via event analysis).
2082  */
2083 contract ERC20Burnable is Context, ERC20 {
2084     /**
2085      * @dev Destroys `amount` tokens from the caller.
2086      *
2087      * See {ERC20-_burn}.
2088      */
2089     function burn(uint256 amount) public {
2090         _burn(_msgSender(), amount);
2091     }
2092 
2093     /**
2094      * @dev See {ERC20-_burnFrom}.
2095      */
2096     function burnFrom(address account, uint256 amount) public {
2097         _burnFrom(account, amount);
2098     }
2099 }
2100 
2101 contract Dev is
2102 	ERC20Detailed,
2103 	ERC20Mintable,
2104 	ERC20Burnable,
2105 	UsingConfig,
2106 	UsingValidator
2107 {
2108 	constructor(address _config)
2109 		public
2110 		ERC20Detailed("Dev", "DEV", 18)
2111 		UsingConfig(_config)
2112 	{}
2113 
2114 	function deposit(address _to, uint256 _amount) external returns (bool) {
2115 		require(transfer(_to, _amount), "dev transfer failed");
2116 		lock(msg.sender, _to, _amount);
2117 		return true;
2118 	}
2119 
2120 	function depositFrom(
2121 		address _from,
2122 		address _to,
2123 		uint256 _amount
2124 	) external returns (bool) {
2125 		require(transferFrom(_from, _to, _amount), "dev transferFrom failed");
2126 		lock(_from, _to, _amount);
2127 		return true;
2128 	}
2129 
2130 	function fee(address _from, uint256 _amount) external returns (bool) {
2131 		addressValidator().validateGroup(msg.sender, config().marketGroup());
2132 		_burn(_from, _amount);
2133 		return true;
2134 	}
2135 
2136 	function lock(
2137 		address _from,
2138 		address _to,
2139 		uint256 _amount
2140 	) private {
2141 		Lockup(config().lockup()).lockup(_from, _to, _amount);
2142 	}
2143 }
2144 
2145 contract Market is UsingConfig, IMarket, UsingValidator {
2146 	using SafeMath for uint256;
2147 	bool public enabled;
2148 	address public behavior;
2149 	uint256 private _votingEndBlockNumber;
2150 	uint256 public issuedMetrics;
2151 	mapping(bytes32 => bool) private idMap;
2152 	mapping(address => bytes32) private idHashMetricsMap;
2153 
2154 	constructor(address _config, address _behavior)
2155 		public
2156 		UsingConfig(_config)
2157 	{
2158 		addressValidator().validateAddress(
2159 			msg.sender,
2160 			config().marketFactory()
2161 		);
2162 
2163 		behavior = _behavior;
2164 		enabled = false;
2165 		uint256 marketVotingBlocks = Policy(config().policy())
2166 			.marketVotingBlocks();
2167 		_votingEndBlockNumber = block.number.add(marketVotingBlocks);
2168 	}
2169 
2170 	function propertyValidation(address _prop) internal view {
2171 		addressValidator().validateAddress(
2172 			msg.sender,
2173 			Property(_prop).author()
2174 		);
2175 		require(enabled, "market is not enabled");
2176 	}
2177 
2178 	modifier onlyPropertyAuthor(address _prop) {
2179 		propertyValidation(_prop);
2180 		_;
2181 	}
2182 
2183 	modifier onlyLinkedPropertyAuthor(address _metrics) {
2184 		address _prop = Metrics(_metrics).property();
2185 		propertyValidation(_prop);
2186 		_;
2187 	}
2188 
2189 	function toEnable() external {
2190 		addressValidator().validateAddress(
2191 			msg.sender,
2192 			config().marketFactory()
2193 		);
2194 		enabled = true;
2195 	}
2196 
2197 	function authenticate(
2198 		address _prop,
2199 		string memory _args1,
2200 		string memory _args2,
2201 		string memory _args3,
2202 		string memory _args4,
2203 		string memory _args5
2204 	) public onlyPropertyAuthor(_prop) returns (address) {
2205 		uint256 len = bytes(_args1).length;
2206 		require(len > 0, "id is required");
2207 
2208 		return
2209 			IMarketBehavior(behavior).authenticate(
2210 				_prop,
2211 				_args1,
2212 				_args2,
2213 				_args3,
2214 				_args4,
2215 				_args5,
2216 				address(this)
2217 			);
2218 	}
2219 
2220 	function getAuthenticationFee(address _property)
2221 		private
2222 		view
2223 		returns (uint256)
2224 	{
2225 		uint256 tokenValue = Lockup(config().lockup()).getPropertyValue(
2226 			_property
2227 		);
2228 		Policy policy = Policy(config().policy());
2229 		MetricsGroup metricsGroup = MetricsGroup(config().metricsGroup());
2230 		return
2231 			policy.authenticationFee(
2232 				metricsGroup.totalIssuedMetrics(),
2233 				tokenValue
2234 			);
2235 	}
2236 
2237 	function authenticatedCallback(address _property, bytes32 _idHash)
2238 		external
2239 		returns (address)
2240 	{
2241 		addressValidator().validateAddress(msg.sender, behavior);
2242 		require(enabled, "market is not enabled");
2243 
2244 		require(idMap[_idHash] == false, "id is duplicated");
2245 		idMap[_idHash] = true;
2246 		address sender = Property(_property).author();
2247 		MetricsFactory metricsFactory = MetricsFactory(
2248 			config().metricsFactory()
2249 		);
2250 		address metrics = metricsFactory.create(_property);
2251 		idHashMetricsMap[metrics] = _idHash;
2252 		uint256 authenticationFee = getAuthenticationFee(_property);
2253 		require(
2254 			Dev(config().token()).fee(sender, authenticationFee),
2255 			"dev fee failed"
2256 		);
2257 		issuedMetrics = issuedMetrics.add(1);
2258 		return metrics;
2259 	}
2260 
2261 	function deauthenticate(address _metrics)
2262 		external
2263 		onlyLinkedPropertyAuthor(_metrics)
2264 	{
2265 		bytes32 idHash = idHashMetricsMap[_metrics];
2266 		require(idMap[idHash], "not authenticated");
2267 		idMap[idHash] = false;
2268 		idHashMetricsMap[_metrics] = bytes32(0);
2269 		MetricsFactory metricsFactory = MetricsFactory(
2270 			config().metricsFactory()
2271 		);
2272 		metricsFactory.destroy(_metrics);
2273 		issuedMetrics = issuedMetrics.sub(1);
2274 	}
2275 
2276 	function vote(address _property, bool _agree) external {
2277 		addressValidator().validateGroup(_property, config().propertyGroup());
2278 		require(enabled == false, "market is already enabled");
2279 		require(
2280 			block.number <= _votingEndBlockNumber,
2281 			"voting deadline is over"
2282 		);
2283 
2284 		VoteCounter voteCounter = VoteCounter(config().voteCounter());
2285 		voteCounter.addVoteCount(msg.sender, _property, _agree);
2286 		enabled = Policy(config().policy()).marketApproval(
2287 			voteCounter.getAgreeCount(address(this)),
2288 			voteCounter.getOppositeCount(address(this))
2289 		);
2290 	}
2291 
2292 	function schema() external view returns (string memory) {
2293 		return IMarketBehavior(behavior).schema();
2294 	}
2295 }
2296 
2297 // prettier-ignore
2298 
2299 contract WithdrawStorage is UsingStorage, UsingConfig, UsingValidator {
2300 	// solium-disable-next-line no-empty-blocks
2301 	constructor(address _config) public UsingConfig(_config) {}
2302 
2303 	// RewardsAmount
2304 	function setRewardsAmount(address _property, uint256 _value) external {
2305 		addressValidator().validateAddress(msg.sender, config().withdraw());
2306 
2307 		eternalStorage().setUint(getRewardsAmountKey(_property), _value);
2308 	}
2309 
2310 	function getRewardsAmount(address _property)
2311 		external
2312 		view
2313 		returns (uint256)
2314 	{
2315 		return eternalStorage().getUint(getRewardsAmountKey(_property));
2316 	}
2317 
2318 	function getRewardsAmountKey(address _property)
2319 		private
2320 		pure
2321 		returns (bytes32)
2322 	{
2323 		return keccak256(abi.encodePacked("_rewardsAmount", _property));
2324 	}
2325 
2326 	// CumulativePrice
2327 	function setCumulativePrice(address _property, uint256 _value) external {
2328 		addressValidator().validateAddress(msg.sender, config().withdraw());
2329 
2330 		eternalStorage().setUint(getCumulativePriceKey(_property), _value);
2331 	}
2332 
2333 	function getCumulativePrice(address _property)
2334 		external
2335 		view
2336 		returns (uint256)
2337 	{
2338 		return eternalStorage().getUint(getCumulativePriceKey(_property));
2339 	}
2340 
2341 	function getCumulativePriceKey(address _property)
2342 		private
2343 		pure
2344 		returns (bytes32)
2345 	{
2346 		return keccak256(abi.encodePacked("_cumulativePrice", _property));
2347 	}
2348 
2349 	// WithdrawalLimitTotal
2350 	function setWithdrawalLimitTotal(
2351 		address _property,
2352 		address _user,
2353 		uint256 _value
2354 	) external {
2355 		addressValidator().validateAddress(msg.sender, config().withdraw());
2356 
2357 		eternalStorage().setUint(
2358 			getWithdrawalLimitTotalKey(_property, _user),
2359 			_value
2360 		);
2361 	}
2362 
2363 	function getWithdrawalLimitTotal(address _property, address _user)
2364 		external
2365 		view
2366 		returns (uint256)
2367 	{
2368 		return
2369 			eternalStorage().getUint(
2370 				getWithdrawalLimitTotalKey(_property, _user)
2371 			);
2372 	}
2373 
2374 	function getWithdrawalLimitTotalKey(address _property, address _user)
2375 		private
2376 		pure
2377 		returns (bytes32)
2378 	{
2379 		return
2380 			keccak256(
2381 				abi.encodePacked("_withdrawalLimitTotal", _property, _user)
2382 			);
2383 	}
2384 
2385 	// WithdrawalLimitBalance
2386 	function setWithdrawalLimitBalance(
2387 		address _property,
2388 		address _user,
2389 		uint256 _value
2390 	) external {
2391 		addressValidator().validateAddress(msg.sender, config().withdraw());
2392 
2393 		eternalStorage().setUint(
2394 			getWithdrawalLimitBalanceKey(_property, _user),
2395 			_value
2396 		);
2397 	}
2398 
2399 	function getWithdrawalLimitBalance(address _property, address _user)
2400 		external
2401 		view
2402 		returns (uint256)
2403 	{
2404 		return
2405 			eternalStorage().getUint(
2406 				getWithdrawalLimitBalanceKey(_property, _user)
2407 			);
2408 	}
2409 
2410 	function getWithdrawalLimitBalanceKey(address _property, address _user)
2411 		private
2412 		pure
2413 		returns (bytes32)
2414 	{
2415 		return
2416 			keccak256(
2417 				abi.encodePacked("_withdrawalLimitBalance", _property, _user)
2418 			);
2419 	}
2420 
2421 	//LastWithdrawalPrice
2422 	function setLastWithdrawalPrice(
2423 		address _property,
2424 		address _user,
2425 		uint256 _value
2426 	) external {
2427 		addressValidator().validateAddress(msg.sender, config().withdraw());
2428 
2429 		eternalStorage().setUint(
2430 			getLastWithdrawalPriceKey(_property, _user),
2431 			_value
2432 		);
2433 	}
2434 
2435 	function getLastWithdrawalPrice(address _property, address _user)
2436 		external
2437 		view
2438 		returns (uint256)
2439 	{
2440 		return
2441 			eternalStorage().getUint(
2442 				getLastWithdrawalPriceKey(_property, _user)
2443 			);
2444 	}
2445 
2446 	function getLastWithdrawalPriceKey(address _property, address _user)
2447 		private
2448 		pure
2449 		returns (bytes32)
2450 	{
2451 		return
2452 			keccak256(
2453 				abi.encodePacked("_lastWithdrawalPrice", _property, _user)
2454 			);
2455 	}
2456 
2457 	//PendingWithdrawal
2458 	function setPendingWithdrawal(
2459 		address _property,
2460 		address _user,
2461 		uint256 _value
2462 	) external {
2463 		addressValidator().validateAddress(msg.sender, config().withdraw());
2464 
2465 		eternalStorage().setUint(
2466 			getPendingWithdrawalKey(_property, _user),
2467 			_value
2468 		);
2469 	}
2470 
2471 	function getPendingWithdrawal(address _property, address _user)
2472 		external
2473 		view
2474 		returns (uint256)
2475 	{
2476 		return
2477 			eternalStorage().getUint(getPendingWithdrawalKey(_property, _user));
2478 	}
2479 
2480 	function getPendingWithdrawalKey(address _property, address _user)
2481 		private
2482 		pure
2483 		returns (bytes32)
2484 	{
2485 		return
2486 			keccak256(abi.encodePacked("_pendingWithdrawal", _property, _user));
2487 	}
2488 }
2489 
2490 contract Withdraw is Pausable, UsingConfig, UsingValidator {
2491 	using SafeMath for uint256;
2492 	using Decimals for uint256;
2493 
2494 	// solium-disable-next-line no-empty-blocks
2495 	constructor(address _config) public UsingConfig(_config) {}
2496 
2497 	function withdraw(address _property) external {
2498 		addressValidator().validateGroup(_property, config().propertyGroup());
2499 
2500 		uint256 value = _calculateWithdrawableAmount(_property, msg.sender);
2501 		require(value != 0, "withdraw value is 0");
2502 		uint256 price = getStorage().getCumulativePrice(_property);
2503 		getStorage().setLastWithdrawalPrice(_property, msg.sender, price);
2504 		getStorage().setPendingWithdrawal(_property, msg.sender, 0);
2505 		ERC20Mintable erc20 = ERC20Mintable(config().token());
2506 		require(erc20.mint(msg.sender, value), "dev mint failed");
2507 	}
2508 
2509 	function beforeBalanceChange(
2510 		address _property,
2511 		address _from,
2512 		address _to
2513 	) external {
2514 		addressValidator().validateAddress(msg.sender, config().allocator());
2515 
2516 		uint256 price = getStorage().getCumulativePrice(_property);
2517 		uint256 amountFrom = _calculateAmount(_property, _from);
2518 		uint256 amountTo = _calculateAmount(_property, _to);
2519 		getStorage().setLastWithdrawalPrice(_property, _from, price);
2520 		getStorage().setLastWithdrawalPrice(_property, _to, price);
2521 		uint256 pendFrom = getStorage().getPendingWithdrawal(_property, _from);
2522 		uint256 pendTo = getStorage().getPendingWithdrawal(_property, _to);
2523 		getStorage().setPendingWithdrawal(
2524 			_property,
2525 			_from,
2526 			pendFrom.add(amountFrom)
2527 		);
2528 		getStorage().setPendingWithdrawal(_property, _to, pendTo.add(amountTo));
2529 		uint256 totalLimit = getStorage().getWithdrawalLimitTotal(
2530 			_property,
2531 			_to
2532 		);
2533 		uint256 total = getStorage().getRewardsAmount(_property);
2534 		if (totalLimit != total) {
2535 			getStorage().setWithdrawalLimitTotal(_property, _to, total);
2536 			getStorage().setWithdrawalLimitBalance(
2537 				_property,
2538 				_to,
2539 				ERC20(_property).balanceOf(_to)
2540 			);
2541 		}
2542 	}
2543 
2544 	function increment(address _property, uint256 _allocationResult) external {
2545 		addressValidator().validateAddress(msg.sender, config().allocator());
2546 		uint256 priceValue = _allocationResult.outOf(
2547 			ERC20(_property).totalSupply()
2548 		);
2549 		uint256 total = getStorage().getRewardsAmount(_property);
2550 		getStorage().setRewardsAmount(_property, total.add(_allocationResult));
2551 		uint256 price = getStorage().getCumulativePrice(_property);
2552 		getStorage().setCumulativePrice(_property, price.add(priceValue));
2553 	}
2554 
2555 	function getRewardsAmount(address _property)
2556 		external
2557 		view
2558 		returns (uint256)
2559 	{
2560 		return getStorage().getRewardsAmount(_property);
2561 	}
2562 
2563 	function _calculateAmount(address _property, address _user)
2564 		private
2565 		view
2566 		returns (uint256)
2567 	{
2568 		uint256 _last = getStorage().getLastWithdrawalPrice(_property, _user);
2569 		uint256 totalLimit = getStorage().getWithdrawalLimitTotal(
2570 			_property,
2571 			_user
2572 		);
2573 		uint256 balanceLimit = getStorage().getWithdrawalLimitBalance(
2574 			_property,
2575 			_user
2576 		);
2577 		uint256 price = getStorage().getCumulativePrice(_property);
2578 		uint256 priceGap = price.sub(_last);
2579 		uint256 balance = ERC20(_property).balanceOf(_user);
2580 		uint256 total = getStorage().getRewardsAmount(_property);
2581 		if (totalLimit == total) {
2582 			balance = balanceLimit;
2583 		}
2584 		uint256 value = priceGap.mul(balance);
2585 		return value.div(Decimals.basis());
2586 	}
2587 
2588 	function calculateAmount(address _property, address _user)
2589 		external
2590 		view
2591 		returns (uint256)
2592 	{
2593 		return _calculateAmount(_property, _user);
2594 	}
2595 
2596 	function _calculateWithdrawableAmount(address _property, address _user)
2597 		private
2598 		view
2599 		returns (uint256)
2600 	{
2601 		uint256 _value = _calculateAmount(_property, _user);
2602 		uint256 value = _value.add(
2603 			getStorage().getPendingWithdrawal(_property, _user)
2604 		);
2605 		return value;
2606 	}
2607 
2608 	function calculateWithdrawableAmount(address _property, address _user)
2609 		external
2610 		view
2611 		returns (uint256)
2612 	{
2613 		return _calculateWithdrawableAmount(_property, _user);
2614 	}
2615 
2616 	function getStorage() private view returns (WithdrawStorage) {
2617 		require(paused() == false, "You cannot use that");
2618 		return WithdrawStorage(config().withdrawStorage());
2619 	}
2620 }
2621 
2622 contract AllocatorStorage is UsingStorage, UsingConfig, UsingValidator {
2623 	constructor(address _config) public UsingConfig(_config) UsingStorage() {}
2624 
2625 	// Last Block Number
2626 	function setLastBlockNumber(address _metrics, uint256 _blocks) external {
2627 		addressValidator().validateAddress(msg.sender, config().allocator());
2628 
2629 		eternalStorage().setUint(getLastBlockNumberKey(_metrics), _blocks);
2630 	}
2631 
2632 	function getLastBlockNumber(address _metrics)
2633 		external
2634 		view
2635 		returns (uint256)
2636 	{
2637 		return eternalStorage().getUint(getLastBlockNumberKey(_metrics));
2638 	}
2639 
2640 	function getLastBlockNumberKey(address _metrics)
2641 		private
2642 		pure
2643 		returns (bytes32)
2644 	{
2645 		return keccak256(abi.encodePacked("_lastBlockNumber", _metrics));
2646 	}
2647 
2648 	// Base Block Number
2649 	function setBaseBlockNumber(uint256 _blockNumber) external {
2650 		addressValidator().validateAddress(msg.sender, config().allocator());
2651 
2652 		eternalStorage().setUint(getBaseBlockNumberKey(), _blockNumber);
2653 	}
2654 
2655 	function getBaseBlockNumber() external view returns (uint256) {
2656 		return eternalStorage().getUint(getBaseBlockNumberKey());
2657 	}
2658 
2659 	function getBaseBlockNumberKey() private pure returns (bytes32) {
2660 		return keccak256(abi.encodePacked("_baseBlockNumber"));
2661 	}
2662 
2663 	// PendingIncrement
2664 	function setPendingIncrement(address _metrics, bool value) external {
2665 		addressValidator().validateAddress(msg.sender, config().allocator());
2666 
2667 		eternalStorage().setBool(getPendingIncrementKey(_metrics), value);
2668 	}
2669 
2670 	function getPendingIncrement(address _metrics)
2671 		external
2672 		view
2673 		returns (bool)
2674 	{
2675 		return eternalStorage().getBool(getPendingIncrementKey(_metrics));
2676 	}
2677 
2678 	function getPendingIncrementKey(address _metrics)
2679 		private
2680 		pure
2681 		returns (bytes32)
2682 	{
2683 		return keccak256(abi.encodePacked("_pendingIncrement", _metrics));
2684 	}
2685 
2686 	// LastAssetValueEachMetrics
2687 	function setLastAssetValueEachMetrics(address _metrics, uint256 value)
2688 		external
2689 	{
2690 		addressValidator().validateAddress(msg.sender, config().allocator());
2691 
2692 		eternalStorage().setUint(
2693 			getLastAssetValueEachMetricsKey(_metrics),
2694 			value
2695 		);
2696 	}
2697 
2698 	function getLastAssetValueEachMetrics(address _metrics)
2699 		external
2700 		view
2701 		returns (uint256)
2702 	{
2703 		return
2704 			eternalStorage().getUint(getLastAssetValueEachMetricsKey(_metrics));
2705 	}
2706 
2707 	function getLastAssetValueEachMetricsKey(address _addr)
2708 		private
2709 		pure
2710 		returns (bytes32)
2711 	{
2712 		return keccak256(abi.encodePacked("_lastAssetValueEachMetrics", _addr));
2713 	}
2714 
2715 	// lastAssetValueEachMarketPerBlock
2716 	function setLastAssetValueEachMarketPerBlock(address _market, uint256 value)
2717 		external
2718 	{
2719 		addressValidator().validateAddress(msg.sender, config().allocator());
2720 
2721 		eternalStorage().setUint(
2722 			getLastAssetValueEachMarketPerBlockKey(_market),
2723 			value
2724 		);
2725 	}
2726 
2727 	function getLastAssetValueEachMarketPerBlock(address _market)
2728 		external
2729 		view
2730 		returns (uint256)
2731 	{
2732 		return
2733 			eternalStorage().getUint(
2734 				getLastAssetValueEachMarketPerBlockKey(_market)
2735 			);
2736 	}
2737 
2738 	function getLastAssetValueEachMarketPerBlockKey(address _addr)
2739 		private
2740 		pure
2741 		returns (bytes32)
2742 	{
2743 		return
2744 			keccak256(
2745 				abi.encodePacked("_lastAssetValueEachMarketPerBlock", _addr)
2746 			);
2747 	}
2748 
2749 	// pendingLastBlockNumber
2750 	function setPendingLastBlockNumber(address _metrics, uint256 value)
2751 		external
2752 	{
2753 		addressValidator().validateAddress(msg.sender, config().allocator());
2754 
2755 		eternalStorage().setUint(getPendingLastBlockNumberKey(_metrics), value);
2756 	}
2757 
2758 	function getPendingLastBlockNumber(address _metrics)
2759 		external
2760 		view
2761 		returns (uint256)
2762 	{
2763 		return eternalStorage().getUint(getPendingLastBlockNumberKey(_metrics));
2764 	}
2765 
2766 	function getPendingLastBlockNumberKey(address _addr)
2767 		private
2768 		pure
2769 		returns (bytes32)
2770 	{
2771 		return keccak256(abi.encodePacked("_pendingLastBlockNumber", _addr));
2772 	}
2773 }
2774 
2775 contract Allocator is Pausable, UsingConfig, IAllocator, UsingValidator {
2776 	using SafeMath for uint256;
2777 	using Decimals for uint256;
2778 
2779 	event BeforeAllocation(
2780 		uint256 _blocks,
2781 		uint256 _mint,
2782 		uint256 _value,
2783 		uint256 _marketValue,
2784 		uint256 _assets,
2785 		uint256 _totalAssets
2786 	);
2787 	event AllocationResult(
2788 		address _metrics,
2789 		uint256 _value,
2790 		address _market,
2791 		address _property,
2792 		uint256 _lockupValue,
2793 		uint256 _result
2794 	);
2795 
2796 	uint64 public constant basis = 1000000000000000000;
2797 
2798 	// solium-disable-next-line no-empty-blocks
2799 	constructor(address _config) public UsingConfig(_config) {}
2800 
2801 	function allocate(address _metrics) external {
2802 		addressValidator().validateGroup(_metrics, config().metricsGroup());
2803 
2804 		validateTargetPeriod(_metrics);
2805 		address market = Metrics(_metrics).market();
2806 		getStorage().setPendingIncrement(_metrics, true);
2807 		getStorage().setPendingLastBlockNumber(_metrics, block.number);
2808 		IMarketBehavior(Market(market).behavior()).calculate(
2809 			_metrics,
2810 			getLastAllocationBlockNumber(_metrics),
2811 			block.number
2812 		);
2813 	}
2814 
2815 	function calculatedCallback(address _metrics, uint256 _value) external {
2816 		addressValidator().validateGroup(_metrics, config().metricsGroup());
2817 
2818 		Metrics metrics = Metrics(_metrics);
2819 		Market market = Market(metrics.market());
2820 		require(
2821 			msg.sender == market.behavior(),
2822 			"don't call from other than market behavior"
2823 		);
2824 		require(
2825 			getStorage().getPendingIncrement(_metrics),
2826 			"not asking for an indicator"
2827 		);
2828 		uint256 totalAssets = MetricsGroup(config().metricsGroup())
2829 			.totalIssuedMetrics();
2830 		uint256 lockupValue = Lockup(config().lockup()).getPropertyValue(
2831 			metrics.property()
2832 		);
2833 		uint256 lastBlock = getStorage().getPendingLastBlockNumber(_metrics);
2834 		uint256 blocks = lastBlock.sub(getLastAllocationBlockNumber(_metrics));
2835 		blocks = blocks > 0 ? blocks : 1;
2836 		uint256 mint = Policy(config().policy()).rewards(
2837 			Lockup(config().lockup()).getAllValue(),
2838 			totalAssets
2839 		);
2840 		uint256 value = (
2841 			Policy(config().policy()).assetValue(_value, lockupValue).mul(basis)
2842 		)
2843 			.div(blocks);
2844 		uint256 marketValue = getStorage()
2845 			.getLastAssetValueEachMarketPerBlock(metrics.market())
2846 			.sub(getStorage().getLastAssetValueEachMetrics(_metrics))
2847 			.add(value);
2848 		uint256 assets = market.issuedMetrics();
2849 		getStorage().setLastAssetValueEachMetrics(_metrics, value);
2850 		getStorage().setLastAssetValueEachMarketPerBlock(
2851 			metrics.market(),
2852 			marketValue
2853 		);
2854 		emit BeforeAllocation(
2855 			blocks,
2856 			mint,
2857 			value,
2858 			marketValue,
2859 			assets,
2860 			totalAssets
2861 		);
2862 		uint256 result = allocation(
2863 			blocks,
2864 			mint,
2865 			value,
2866 			marketValue,
2867 			assets,
2868 			totalAssets
2869 		);
2870 		emit AllocationResult(
2871 			_metrics,
2872 			_value,
2873 			metrics.market(),
2874 			metrics.property(),
2875 			lockupValue,
2876 			result
2877 		);
2878 		increment(metrics.property(), result, lockupValue);
2879 		getStorage().setPendingIncrement(_metrics, false);
2880 		getStorage().setLastBlockNumber(_metrics, lastBlock);
2881 	}
2882 
2883 	function increment(
2884 		address _property,
2885 		uint256 _reward,
2886 		uint256 _lockup
2887 	) private {
2888 		uint256 holders = Policy(config().policy()).holdersShare(
2889 			_reward,
2890 			_lockup
2891 		);
2892 		uint256 interest = _reward.sub(holders);
2893 		Withdraw(config().withdraw()).increment(_property, holders);
2894 		Lockup(config().lockup()).increment(_property, interest);
2895 	}
2896 
2897 	function beforeBalanceChange(
2898 		address _property,
2899 		address _from,
2900 		address _to
2901 	) external {
2902 		addressValidator().validateGroup(msg.sender, config().propertyGroup());
2903 
2904 		Withdraw(config().withdraw()).beforeBalanceChange(
2905 			_property,
2906 			_from,
2907 			_to
2908 		);
2909 	}
2910 
2911 	function getRewardsAmount(address _property)
2912 		external
2913 		view
2914 		returns (uint256)
2915 	{
2916 		return Withdraw(config().withdraw()).getRewardsAmount(_property);
2917 	}
2918 
2919 	function allocation(
2920 		uint256 _blocks,
2921 		uint256 _mint,
2922 		uint256 _value,
2923 		uint256 _marketValue,
2924 		uint256 _assets,
2925 		uint256 _totalAssets
2926 	) public pure returns (uint256) {
2927 		uint256 aShare = _totalAssets > 0
2928 			? _assets.outOf(_totalAssets)
2929 			: Decimals.basis();
2930 		uint256 vShare = _marketValue > 0
2931 			? _value.outOf(_marketValue)
2932 			: Decimals.basis();
2933 		uint256 mint = _mint.mul(_blocks);
2934 		return
2935 			mint.mul(aShare).mul(vShare).div(Decimals.basis()).div(
2936 				Decimals.basis()
2937 			);
2938 	}
2939 
2940 	function validateTargetPeriod(address _metrics) private {
2941 		address property = Metrics(_metrics).property();
2942 		VoteTimes voteTimes = VoteTimes(config().voteTimes());
2943 		uint256 abstentionCount = voteTimes.getAbstentionTimes(property);
2944 		uint256 notTargetPeriod = Policy(config().policy()).abstentionPenalty(
2945 			abstentionCount
2946 		);
2947 		if (notTargetPeriod == 0) {
2948 			return;
2949 		}
2950 		uint256 blockNumber = getLastAllocationBlockNumber(_metrics);
2951 		uint256 notTargetBlockNumber = blockNumber.add(notTargetPeriod);
2952 		require(
2953 			notTargetBlockNumber < block.number,
2954 			"outside the target period"
2955 		);
2956 		getStorage().setLastBlockNumber(_metrics, notTargetBlockNumber);
2957 		voteTimes.resetVoteTimesByProperty(property);
2958 	}
2959 
2960 	function getLastAllocationBlockNumber(address _metrics)
2961 		private
2962 		returns (uint256)
2963 	{
2964 		uint256 blockNumber = getStorage().getLastBlockNumber(_metrics);
2965 		uint256 baseBlockNumber = getStorage().getBaseBlockNumber();
2966 		if (baseBlockNumber == 0) {
2967 			getStorage().setBaseBlockNumber(block.number);
2968 		}
2969 		uint256 lastAllocationBlockNumber = blockNumber > 0
2970 			? blockNumber
2971 			: getStorage().getBaseBlockNumber();
2972 		return lastAllocationBlockNumber;
2973 	}
2974 
2975 	function getStorage() private view returns (AllocatorStorage) {
2976 		require(paused() == false, "You cannot use that");
2977 		return AllocatorStorage(config().allocatorStorage());
2978 	}
2979 }
2980 
2981 contract Property is ERC20, ERC20Detailed, UsingConfig, UsingValidator {
2982 	using SafeMath for uint256;
2983 	uint8 private constant _property_decimals = 18;
2984 	uint256 private constant _supply = 10000000000000000000000000;
2985 	address public author;
2986 
2987 	constructor(
2988 		address _config,
2989 		address _own,
2990 		string memory _name,
2991 		string memory _symbol
2992 	)
2993 		public
2994 		UsingConfig(_config)
2995 		ERC20Detailed(_name, _symbol, _property_decimals)
2996 	{
2997 		addressValidator().validateAddress(
2998 			msg.sender,
2999 			config().propertyFactory()
3000 		);
3001 
3002 		author = _own;
3003 		_mint(author, _supply);
3004 	}
3005 
3006 	function transfer(address _to, uint256 _value) public returns (bool) {
3007 		addressValidator().validateIllegalAddress(_to);
3008 		require(_value != 0, "illegal transfer value");
3009 
3010 		Allocator(config().allocator()).beforeBalanceChange(
3011 			address(this),
3012 			msg.sender,
3013 			_to
3014 		);
3015 		_transfer(msg.sender, _to, _value);
3016 		return true;
3017 	}
3018 
3019 	function transferFrom(
3020 		address _from,
3021 		address _to,
3022 		uint256 _value
3023 	) public returns (bool) {
3024 		addressValidator().validateIllegalAddress(_from);
3025 		addressValidator().validateIllegalAddress(_to);
3026 		require(_value != 0, "illegal transfer value");
3027 
3028 		Allocator(config().allocator()).beforeBalanceChange(
3029 			address(this),
3030 			_from,
3031 			_to
3032 		);
3033 		_transfer(_from, _to, _value);
3034 		uint256 allowanceAmount = allowance(_from, msg.sender);
3035 		_approve(
3036 			_from,
3037 			msg.sender,
3038 			allowanceAmount.sub(
3039 				_value,
3040 				"ERC20: transfer amount exceeds allowance"
3041 			)
3042 		);
3043 		return true;
3044 	}
3045 
3046 	function withdraw(address _sender, uint256 _value) external {
3047 		addressValidator().validateAddress(msg.sender, config().lockup());
3048 
3049 		ERC20 devToken = ERC20(config().token());
3050 		devToken.transfer(_sender, _value);
3051 	}
3052 }
3053 
3054 contract LockupStorage is UsingConfig, UsingStorage, UsingValidator {
3055 	// solium-disable-next-line no-empty-blocks
3056 	constructor(address _config) public UsingConfig(_config) {}
3057 
3058 	//AllValue
3059 	function setAllValue(uint256 _value) external {
3060 		addressValidator().validateAddress(msg.sender, config().lockup());
3061 
3062 		bytes32 key = getAllValueKey();
3063 		eternalStorage().setUint(key, _value);
3064 	}
3065 
3066 	function getAllValue() external view returns (uint256) {
3067 		bytes32 key = getAllValueKey();
3068 		return eternalStorage().getUint(key);
3069 	}
3070 
3071 	function getAllValueKey() private pure returns (bytes32) {
3072 		return keccak256(abi.encodePacked("_allValue"));
3073 	}
3074 
3075 	//Value
3076 	function setValue(
3077 		address _property,
3078 		address _sender,
3079 		uint256 _value
3080 	) external {
3081 		addressValidator().validateAddress(msg.sender, config().lockup());
3082 
3083 		bytes32 key = getValueKey(_property, _sender);
3084 		eternalStorage().setUint(key, _value);
3085 	}
3086 
3087 	function getValue(address _property, address _sender)
3088 		external
3089 		view
3090 		returns (uint256)
3091 	{
3092 		bytes32 key = getValueKey(_property, _sender);
3093 		return eternalStorage().getUint(key);
3094 	}
3095 
3096 	function getValueKey(address _property, address _sender)
3097 		private
3098 		pure
3099 		returns (bytes32)
3100 	{
3101 		return keccak256(abi.encodePacked("_value", _property, _sender));
3102 	}
3103 
3104 	//PropertyValue
3105 	function setPropertyValue(address _property, uint256 _value) external {
3106 		addressValidator().validateAddress(msg.sender, config().lockup());
3107 
3108 		bytes32 key = getPropertyValueKey(_property);
3109 		eternalStorage().setUint(key, _value);
3110 	}
3111 
3112 	function getPropertyValue(address _property)
3113 		external
3114 		view
3115 		returns (uint256)
3116 	{
3117 		bytes32 key = getPropertyValueKey(_property);
3118 		return eternalStorage().getUint(key);
3119 	}
3120 
3121 	function getPropertyValueKey(address _property)
3122 		private
3123 		pure
3124 		returns (bytes32)
3125 	{
3126 		return keccak256(abi.encodePacked("_propertyValue", _property));
3127 	}
3128 
3129 	//WithdrawalStatus
3130 	function setWithdrawalStatus(
3131 		address _property,
3132 		address _from,
3133 		uint256 _value
3134 	) external {
3135 		addressValidator().validateAddress(msg.sender, config().lockup());
3136 
3137 		bytes32 key = getWithdrawalStatusKey(_property, _from);
3138 		eternalStorage().setUint(key, _value);
3139 	}
3140 
3141 	function getWithdrawalStatus(address _property, address _from)
3142 		external
3143 		view
3144 		returns (uint256)
3145 	{
3146 		bytes32 key = getWithdrawalStatusKey(_property, _from);
3147 		return eternalStorage().getUint(key);
3148 	}
3149 
3150 	function getWithdrawalStatusKey(address _property, address _sender)
3151 		private
3152 		pure
3153 		returns (bytes32)
3154 	{
3155 		return
3156 			keccak256(
3157 				abi.encodePacked("_withdrawalStatus", _property, _sender)
3158 			);
3159 	}
3160 
3161 	//InterestPrice
3162 	function setInterestPrice(address _property, uint256 _value) external {
3163 		addressValidator().validateAddress(msg.sender, config().lockup());
3164 
3165 		eternalStorage().setUint(getInterestPriceKey(_property), _value);
3166 	}
3167 
3168 	function getInterestPrice(address _property)
3169 		external
3170 		view
3171 		returns (uint256)
3172 	{
3173 		return eternalStorage().getUint(getInterestPriceKey(_property));
3174 	}
3175 
3176 	function getInterestPriceKey(address _property)
3177 		private
3178 		pure
3179 		returns (bytes32)
3180 	{
3181 		return keccak256(abi.encodePacked("_interestTotals", _property));
3182 	}
3183 
3184 	//LastInterestPrice
3185 	function setLastInterestPrice(
3186 		address _property,
3187 		address _user,
3188 		uint256 _value
3189 	) external {
3190 		addressValidator().validateAddress(msg.sender, config().lockup());
3191 
3192 		eternalStorage().setUint(
3193 			getLastInterestPriceKey(_property, _user),
3194 			_value
3195 		);
3196 	}
3197 
3198 	function getLastInterestPrice(address _property, address _user)
3199 		external
3200 		view
3201 		returns (uint256)
3202 	{
3203 		return
3204 			eternalStorage().getUint(getLastInterestPriceKey(_property, _user));
3205 	}
3206 
3207 	function getLastInterestPriceKey(address _property, address _user)
3208 		private
3209 		pure
3210 		returns (bytes32)
3211 	{
3212 		return
3213 			keccak256(
3214 				abi.encodePacked("_lastLastInterestPrice", _property, _user)
3215 			);
3216 	}
3217 
3218 	//PendingWithdrawal
3219 	function setPendingInterestWithdrawal(
3220 		address _property,
3221 		address _user,
3222 		uint256 _value
3223 	) external {
3224 		addressValidator().validateAddress(msg.sender, config().lockup());
3225 
3226 		eternalStorage().setUint(
3227 			getPendingInterestWithdrawalKey(_property, _user),
3228 			_value
3229 		);
3230 	}
3231 
3232 	function getPendingInterestWithdrawal(address _property, address _user)
3233 		external
3234 		view
3235 		returns (uint256)
3236 	{
3237 		return
3238 			eternalStorage().getUint(
3239 				getPendingInterestWithdrawalKey(_property, _user)
3240 			);
3241 	}
3242 
3243 	function getPendingInterestWithdrawalKey(address _property, address _user)
3244 		private
3245 		pure
3246 		returns (bytes32)
3247 	{
3248 		return
3249 			keccak256(
3250 				abi.encodePacked("_pendingInterestWithdrawal", _property, _user)
3251 			);
3252 	}
3253 }
3254 
3255 contract Lockup is Pausable, UsingConfig, UsingValidator {
3256 	using SafeMath for uint256;
3257 	using Decimals for uint256;
3258 	event Lockedup(address _from, address _property, uint256 _value);
3259 
3260 	// solium-disable-next-line no-empty-blocks
3261 	constructor(address _config) public UsingConfig(_config) {}
3262 
3263 	function lockup(
3264 		address _from,
3265 		address _property,
3266 		uint256 _value
3267 	) external {
3268 		addressValidator().validateAddress(msg.sender, config().token());
3269 		addressValidator().validateGroup(_property, config().propertyGroup());
3270 		require(_value != 0, "illegal lockup value");
3271 
3272 		bool isWaiting = getStorage().getWithdrawalStatus(_property, _from) !=
3273 			0;
3274 		require(isWaiting == false, "lockup is already canceled");
3275 		updatePendingInterestWithdrawal(_property, _from);
3276 		addValue(_property, _from, _value);
3277 		addPropertyValue(_property, _value);
3278 		addAllValue(_value);
3279 		getStorage().setLastInterestPrice(
3280 			_property,
3281 			_from,
3282 			getStorage().getInterestPrice(_property)
3283 		);
3284 		emit Lockedup(_from, _property, _value);
3285 	}
3286 
3287 	function cancel(address _property) external {
3288 		addressValidator().validateGroup(_property, config().propertyGroup());
3289 
3290 		require(hasValue(_property, msg.sender), "dev token is not locked");
3291 		bool isWaiting = getStorage().getWithdrawalStatus(
3292 			_property,
3293 			msg.sender
3294 		) != 0;
3295 		require(isWaiting == false, "lockup is already canceled");
3296 		uint256 blockNumber = Policy(config().policy()).lockUpBlocks();
3297 		blockNumber = blockNumber.add(block.number);
3298 		getStorage().setWithdrawalStatus(_property, msg.sender, blockNumber);
3299 	}
3300 
3301 	function withdraw(address _property) external {
3302 		addressValidator().validateGroup(_property, config().propertyGroup());
3303 
3304 		require(possible(_property, msg.sender), "waiting for release");
3305 		uint256 lockupedValue = getStorage().getValue(_property, msg.sender);
3306 		require(lockupedValue != 0, "dev token is not locked");
3307 		updatePendingInterestWithdrawal(_property, msg.sender);
3308 		Property(_property).withdraw(msg.sender, lockupedValue);
3309 		getStorage().setValue(_property, msg.sender, 0);
3310 		subPropertyValue(_property, lockupedValue);
3311 		subAllValue(lockupedValue);
3312 		getStorage().setWithdrawalStatus(_property, msg.sender, 0);
3313 	}
3314 
3315 	function increment(address _property, uint256 _interestResult) external {
3316 		addressValidator().validateAddress(msg.sender, config().allocator());
3317 
3318 		uint256 priceValue = _interestResult.outOf(
3319 			getStorage().getPropertyValue(_property)
3320 		);
3321 		incrementInterest(_property, priceValue);
3322 	}
3323 
3324 	function _calculateInterestAmount(address _property, address _user)
3325 		private
3326 		view
3327 		returns (uint256)
3328 	{
3329 		uint256 _last = getStorage().getLastInterestPrice(_property, _user);
3330 		uint256 price = getStorage().getInterestPrice(_property);
3331 		uint256 priceGap = price.sub(_last);
3332 		uint256 lockupedValue = getStorage().getValue(_property, _user);
3333 		uint256 value = priceGap.mul(lockupedValue);
3334 		return value.div(Decimals.basis());
3335 	}
3336 
3337 	function calculateInterestAmount(address _property, address _user)
3338 		external
3339 		view
3340 		returns (uint256)
3341 	{
3342 		return _calculateInterestAmount(_property, _user);
3343 	}
3344 
3345 	function _calculateWithdrawableInterestAmount(
3346 		address _property,
3347 		address _user
3348 	) private view returns (uint256) {
3349 		uint256 pending = getStorage().getPendingInterestWithdrawal(
3350 			_property,
3351 			_user
3352 		);
3353 		return _calculateInterestAmount(_property, _user).add(pending);
3354 	}
3355 
3356 	function calculateWithdrawableInterestAmount(
3357 		address _property,
3358 		address _user
3359 	) external view returns (uint256) {
3360 		return _calculateWithdrawableInterestAmount(_property, _user);
3361 	}
3362 
3363 	function withdrawInterest(address _property) external {
3364 		addressValidator().validateGroup(_property, config().propertyGroup());
3365 
3366 		uint256 value = _calculateWithdrawableInterestAmount(
3367 			_property,
3368 			msg.sender
3369 		);
3370 		require(value > 0, "your interest amount is 0");
3371 		getStorage().setLastInterestPrice(
3372 			_property,
3373 			msg.sender,
3374 			getStorage().getInterestPrice(_property)
3375 		);
3376 		getStorage().setPendingInterestWithdrawal(_property, msg.sender, 0);
3377 		ERC20Mintable erc20 = ERC20Mintable(config().token());
3378 		require(erc20.mint(msg.sender, value), "dev mint failed");
3379 	}
3380 
3381 	function getAllValue() external view returns (uint256) {
3382 		return getStorage().getAllValue();
3383 	}
3384 
3385 	function addAllValue(uint256 _value) private {
3386 		uint256 value = getStorage().getAllValue();
3387 		value = value.add(_value);
3388 		getStorage().setAllValue(value);
3389 	}
3390 
3391 	function subAllValue(uint256 _value) private {
3392 		uint256 value = getStorage().getAllValue();
3393 		value = value.sub(_value);
3394 		getStorage().setAllValue(value);
3395 	}
3396 
3397 	function getPropertyValue(address _property)
3398 		external
3399 		view
3400 		returns (uint256)
3401 	{
3402 		return getStorage().getPropertyValue(_property);
3403 	}
3404 
3405 	function getValue(address _property, address _sender)
3406 		external
3407 		view
3408 		returns (uint256)
3409 	{
3410 		return getStorage().getValue(_property, _sender);
3411 	}
3412 
3413 	function addValue(
3414 		address _property,
3415 		address _sender,
3416 		uint256 _value
3417 	) private {
3418 		uint256 value = getStorage().getValue(_property, _sender);
3419 		value = value.add(_value);
3420 		getStorage().setValue(_property, _sender, value);
3421 	}
3422 
3423 	function hasValue(address _property, address _sender)
3424 		private
3425 		view
3426 		returns (bool)
3427 	{
3428 		uint256 value = getStorage().getValue(_property, _sender);
3429 		return value != 0;
3430 	}
3431 
3432 	function addPropertyValue(address _property, uint256 _value) private {
3433 		uint256 value = getStorage().getPropertyValue(_property);
3434 		value = value.add(_value);
3435 		getStorage().setPropertyValue(_property, value);
3436 	}
3437 
3438 	function subPropertyValue(address _property, uint256 _value) private {
3439 		uint256 value = getStorage().getPropertyValue(_property);
3440 		value = value.sub(_value);
3441 		getStorage().setPropertyValue(_property, value);
3442 	}
3443 
3444 	function incrementInterest(address _property, uint256 _priceValue) private {
3445 		uint256 price = getStorage().getInterestPrice(_property);
3446 		getStorage().setInterestPrice(_property, price.add(_priceValue));
3447 	}
3448 
3449 	function updatePendingInterestWithdrawal(address _property, address _user)
3450 		private
3451 	{
3452 		uint256 pending = getStorage().getPendingInterestWithdrawal(
3453 			_property,
3454 			_user
3455 		);
3456 		getStorage().setPendingInterestWithdrawal(
3457 			_property,
3458 			_user,
3459 			_calculateInterestAmount(_property, _user).add(pending)
3460 		);
3461 	}
3462 
3463 	function possible(address _property, address _from)
3464 		private
3465 		view
3466 		returns (bool)
3467 	{
3468 		// The behavior is changing because of a patch for DIP3.
3469 		// uint256 blockNumber = getStorage().getWithdrawalStatus(
3470 		// 	_property,
3471 		// 	_from
3472 		// );
3473 		// if (blockNumber == 0) {
3474 		// 	return false;
3475 		// }
3476 		// return blockNumber <= block.number;
3477 
3478 		uint256 blockNumber = getStorage().getWithdrawalStatus(
3479 			_property,
3480 			_from
3481 		);
3482 		if (blockNumber == 0) {
3483 			return false;
3484 		}
3485 		if (blockNumber <= block.number) {
3486 			return true;
3487 		} else {
3488 			if (Policy(config().policy()).lockUpBlocks() == 1) {
3489 				return true;
3490 			}
3491 		}
3492 		return false;
3493 	}
3494 
3495 	function getStorage() private view returns (LockupStorage) {
3496 		require(paused() == false, "You cannot use that");
3497 		return LockupStorage(config().lockupStorage());
3498 	}
3499 }