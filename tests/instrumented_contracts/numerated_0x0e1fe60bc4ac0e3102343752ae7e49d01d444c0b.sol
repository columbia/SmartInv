1 /*
2  * Sharing blockchain knowledge with newbies.
3  * Join a growing worldwide community. 
4  * Share ideas and discuss projects.
5  *
6  * https://havensnook.com/
7  */
8 
9 // SPDX-License-Identifier: MIT
10 pragma solidity ^0.6.0;
11 
12 /*
13  * @dev Provides information about the current execution context, including the
14  * sender of the transaction and its data. While these are generally available
15  * via msg.sender and msg.data, they should not be accessed in such a direct
16  * manner, since when dealing with GSN meta-transactions the account sending and
17  * paying for execution may not be the actual sender (as far as an application
18  * is concerned).
19  *
20  * This contract is only required for intermediate, library-like contracts.
21  */
22 abstract contract Context {
23 	function _msgSender() internal virtual view returns (address payable) {
24 		return msg.sender;
25 	}
26 
27 	function _msgData() internal virtual view returns (bytes memory) {
28 		this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
29 		return msg.data;
30 	}
31 }
32 
33 /**
34  * @dev Interface of the ERC20 standard as defined in the EIP.
35  */
36 interface IERC20 {
37 	/**
38 	 * @dev Returns the amount of tokens in existence.
39 	 */
40 	function totalSupply() external view returns (uint256);
41 
42 	/**
43 	 * @dev Returns the amount of tokens owned by `account`.
44 	 */
45 	function balanceOf(address account) external view returns (uint256);
46 
47 	/**
48 	 * @dev Moves `amount` tokens from the caller's account to `recipient`.
49 	 *
50 	 * Returns a boolean value indicating whether the operation succeeded.
51 	 *
52 	 * Emits a {Transfer} event.
53 	 */
54 	function transfer(address recipient, uint256 amount)
55 		external
56 		returns (bool);
57 
58 	/**
59 	 * @dev Returns the remaining number of tokens that `spender` will be
60 	 * allowed to spend on behalf of `owner` through {transferFrom}. This is
61 	 * zero by default.
62 	 *
63 	 * This value changes when {approve} or {transferFrom} are called.
64 	 */
65 	function allowance(address owner, address spender)
66 		external
67 		view
68 		returns (uint256);
69 
70 	/**
71 	 * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
72 	 *
73 	 * Returns a boolean value indicating whether the operation succeeded.
74 	 *
75 	 * IMPORTANT: Beware that changing an allowance with this method brings the risk
76 	 * that someone may use both the old and the new allowance by unfortunate
77 	 * transaction ordering. One possible solution to mitigate this race
78 	 * condition is to first reduce the spender's allowance to 0 and set the
79 	 * desired value afterwards:
80 	 * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
81 	 *
82 	 * Emits an {Approval} event.
83 	 */
84 	function approve(address spender, uint256 amount) external returns (bool);
85 
86 	/**
87 	 * @dev Moves `amount` tokens from `sender` to `recipient` using the
88 	 * allowance mechanism. `amount` is then deducted from the caller's
89 	 * allowance.
90 	 *
91 	 * Returns a boolean value indicating whether the operation succeeded.
92 	 *
93 	 * Emits a {Transfer} event.
94 	 */
95 	function transferFrom(
96 		address sender,
97 		address recipient,
98 		uint256 amount
99 	) external returns (bool);
100 
101 	/**
102 	 * @dev Emitted when `value` tokens are moved from one account (`from`) to
103 	 * another (`to`).
104 	 *
105 	 * Note that `value` may be zero.
106 	 */
107 	event Transfer(address indexed from, address indexed to, uint256 value);
108 
109 	/**
110 	 * @dev Emitted when the allowance of a `spender` for an `owner` is set by
111 	 * a call to {approve}. `value` is the new allowance.
112 	 */
113 	event Approval(
114 		address indexed owner,
115 		address indexed spender,
116 		uint256 value
117 	);
118 }
119 
120 /**
121  * @dev Wrappers over Solidity's arithmetic operations with added overflow
122  * checks.
123  *
124  * Arithmetic operations in Solidity wrap on overflow. This can easily result
125  * in bugs, because programmers usually assume that an overflow raises an
126  * error, which is the standard behavior in high level programming languages.
127  * `SafeMath` restores this intuition by reverting the transaction when an
128  * operation overflows.
129  *
130  * Using this library instead of the unchecked operations eliminates an entire
131  * class of bugs, so it's recommended to use it always.
132  */
133 library SafeMath {
134 	/**
135 	 * @dev Returns the addition of two unsigned integers, reverting on
136 	 * overflow.
137 	 *
138 	 * Counterpart to Solidity's `+` operator.
139 	 *
140 	 * Requirements:
141 	 *
142 	 * - Addition cannot overflow.
143 	 */
144 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
145 		uint256 c = a + b;
146 		require(c >= a, "SafeMath: addition overflow");
147 
148 		return c;
149 	}
150 
151 	/**
152 	 * @dev Returns the subtraction of two unsigned integers, reverting on
153 	 * overflow (when the result is negative).
154 	 *
155 	 * Counterpart to Solidity's `-` operator.
156 	 *
157 	 * Requirements:
158 	 *
159 	 * - Subtraction cannot overflow.
160 	 */
161 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
162 		return sub(a, b, "SafeMath: subtraction overflow");
163 	}
164 
165 	/**
166 	 * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
167 	 * overflow (when the result is negative).
168 	 *
169 	 * Counterpart to Solidity's `-` operator.
170 	 *
171 	 * Requirements:
172 	 *
173 	 * - Subtraction cannot overflow.
174 	 */
175 	function sub(
176 		uint256 a,
177 		uint256 b,
178 		string memory errorMessage
179 	) internal pure returns (uint256) {
180 		require(b <= a, errorMessage);
181 		uint256 c = a - b;
182 
183 		return c;
184 	}
185 
186 	/**
187 	 * @dev Returns the multiplication of two unsigned integers, reverting on
188 	 * overflow.
189 	 *
190 	 * Counterpart to Solidity's `*` operator.
191 	 *
192 	 * Requirements:
193 	 *
194 	 * - Multiplication cannot overflow.
195 	 */
196 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
197 		// Gas optimization: this is cheaper than requiring 'a' not being zero, but the
198 		// benefit is lost if 'b' is also tested.
199 		// See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
200 		if (a == 0) {
201 			return 0;
202 		}
203 
204 		uint256 c = a * b;
205 		require(c / a == b, "SafeMath: multiplication overflow");
206 
207 		return c;
208 	}
209 
210 	/**
211 	 * @dev Returns the integer division of two unsigned integers. Reverts on
212 	 * division by zero. The result is rounded towards zero.
213 	 *
214 	 * Counterpart to Solidity's `/` operator. Note: this function uses a
215 	 * `revert` opcode (which leaves remaining gas untouched) while Solidity
216 	 * uses an invalid opcode to revert (consuming all remaining gas).
217 	 *
218 	 * Requirements:
219 	 *
220 	 * - The divisor cannot be zero.
221 	 */
222 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
223 		return div(a, b, "SafeMath: division by zero");
224 	}
225 
226 	/**
227 	 * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
228 	 * division by zero. The result is rounded towards zero.
229 	 *
230 	 * Counterpart to Solidity's `/` operator. Note: this function uses a
231 	 * `revert` opcode (which leaves remaining gas untouched) while Solidity
232 	 * uses an invalid opcode to revert (consuming all remaining gas).
233 	 *
234 	 * Requirements:
235 	 *
236 	 * - The divisor cannot be zero.
237 	 */
238 	function div(
239 		uint256 a,
240 		uint256 b,
241 		string memory errorMessage
242 	) internal pure returns (uint256) {
243 		require(b > 0, errorMessage);
244 		uint256 c = a / b;
245 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
246 
247 		return c;
248 	}
249 
250 	/**
251 	 * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
252 	 * Reverts when dividing by zero.
253 	 *
254 	 * Counterpart to Solidity's `%` operator. This function uses a `revert`
255 	 * opcode (which leaves remaining gas untouched) while Solidity uses an
256 	 * invalid opcode to revert (consuming all remaining gas).
257 	 *
258 	 * Requirements:
259 	 *
260 	 * - The divisor cannot be zero.
261 	 */
262 	function mod(uint256 a, uint256 b) internal pure returns (uint256) {
263 		return mod(a, b, "SafeMath: modulo by zero");
264 	}
265 
266 	/**
267 	 * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
268 	 * Reverts with custom message when dividing by zero.
269 	 *
270 	 * Counterpart to Solidity's `%` operator. This function uses a `revert`
271 	 * opcode (which leaves remaining gas untouched) while Solidity uses an
272 	 * invalid opcode to revert (consuming all remaining gas).
273 	 *
274 	 * Requirements:
275 	 *
276 	 * - The divisor cannot be zero.
277 	 */
278 	function mod(
279 		uint256 a,
280 		uint256 b,
281 		string memory errorMessage
282 	) internal pure returns (uint256) {
283 		require(b != 0, errorMessage);
284 		return a % b;
285 	}
286 }
287 
288 /**
289  * @dev Collection of functions related to the address type
290  */
291 library Address {
292 	/**
293 	 * @dev Returns true if `account` is a contract.
294 	 *
295 	 * [IMPORTANT]
296 	 * ====
297 	 * It is unsafe to assume that an address for which this function returns
298 	 * false is an externally-owned account (EOA) and not a contract.
299 	 *
300 	 * Among others, `isContract` will return false for the following
301 	 * types of addresses:
302 	 *
303 	 *  - an externally-owned account
304 	 *  - a contract in construction
305 	 *  - an address where a contract will be created
306 	 *  - an address where a contract lived, but was destroyed
307 	 * ====
308 	 */
309 	function isContract(address account) internal view returns (bool) {
310 		// According to EIP-1052, 0x0 is the value returned for not-yet created accounts
311 		// and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
312 		// for accounts without code, i.e. `keccak256('')`
313 		bytes32 codehash;
314 
315 
316 			bytes32 accountHash
317 		 = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
318 		// solhint-disable-next-line no-inline-assembly
319 		assembly {
320 			codehash := extcodehash(account)
321 		}
322 		return (codehash != accountHash && codehash != 0x0);
323 	}
324 
325 	/**
326 	 * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
327 	 * `recipient`, forwarding all available gas and reverting on errors.
328 	 *
329 	 * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
330 	 * of certain opcodes, possibly making contracts go over the 2300 gas limit
331 	 * imposed by `transfer`, making them unable to receive funds via
332 	 * `transfer`. {sendValue} removes this limitation.
333 	 *
334 	 * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
335 	 *
336 	 * IMPORTANT: because control is transferred to `recipient`, care must be
337 	 * taken to not create reentrancy vulnerabilities. Consider using
338 	 * {ReentrancyGuard} or the
339 	 * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
340 	 */
341 	function sendValue(address payable recipient, uint256 amount) internal {
342 		require(
343 			address(this).balance >= amount,
344 			"Address: insufficient balance"
345 		);
346 
347 		// solhint-disable-next-line avoid-low-level-calls, avoid-call-value
348 		(bool success, ) = recipient.call{ value: amount }("");
349 		require(
350 			success,
351 			"Address: unable to send value, recipient may have reverted"
352 		);
353 	}
354 
355 	/**
356 	 * @dev Performs a Solidity function call using a low level `call`. A
357 	 * plain`call` is an unsafe replacement for a function call: use this
358 	 * function instead.
359 	 *
360 	 * If `target` reverts with a revert reason, it is bubbled up by this
361 	 * function (like regular Solidity function calls).
362 	 *
363 	 * Returns the raw returned data. To convert to the expected return value,
364 	 * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
365 	 *
366 	 * Requirements:
367 	 *
368 	 * - `target` must be a contract.
369 	 * - calling `target` with `data` must not revert.
370 	 *
371 	 * _Available since v3.1._
372 	 */
373 	function functionCall(address target, bytes memory data)
374 		internal
375 		returns (bytes memory)
376 	{
377 		return functionCall(target, data, "Address: low-level call failed");
378 	}
379 
380 	/**
381 	 * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
382 	 * `errorMessage` as a fallback revert reason when `target` reverts.
383 	 *
384 	 * _Available since v3.1._
385 	 */
386 	function functionCall(
387 		address target,
388 		bytes memory data,
389 		string memory errorMessage
390 	) internal returns (bytes memory) {
391 		return _functionCallWithValue(target, data, 0, errorMessage);
392 	}
393 
394 	/**
395 	 * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
396 	 * but also transferring `value` wei to `target`.
397 	 *
398 	 * Requirements:
399 	 *
400 	 * - the calling contract must have an ETH balance of at least `value`.
401 	 * - the called Solidity function must be `payable`.
402 	 *
403 	 * _Available since v3.1._
404 	 */
405 	function functionCallWithValue(
406 		address target,
407 		bytes memory data,
408 		uint256 value
409 	) internal returns (bytes memory) {
410 		return
411 			functionCallWithValue(
412 				target,
413 				data,
414 				value,
415 				"Address: low-level call with value failed"
416 			);
417 	}
418 
419 	/**
420 	 * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
421 	 * with `errorMessage` as a fallback revert reason when `target` reverts.
422 	 *
423 	 * _Available since v3.1._
424 	 */
425 	function functionCallWithValue(
426 		address target,
427 		bytes memory data,
428 		uint256 value,
429 		string memory errorMessage
430 	) internal returns (bytes memory) {
431 		require(
432 			address(this).balance >= value,
433 			"Address: insufficient balance for call"
434 		);
435 		return _functionCallWithValue(target, data, value, errorMessage);
436 	}
437 
438 	function _functionCallWithValue(
439 		address target,
440 		bytes memory data,
441 		uint256 weiValue,
442 		string memory errorMessage
443 	) private returns (bytes memory) {
444 		require(isContract(target), "Address: call to non-contract");
445 
446 		// solhint-disable-next-line avoid-low-level-calls
447 		(bool success, bytes memory returndata) = target.call{
448 			value: weiValue
449 		}(data);
450 		if (success) {
451 			return returndata;
452 		} else {
453 			// Look for revert reason and bubble it up if present
454 			if (returndata.length > 0) {
455 				// The easiest way to bubble the revert reason is using memory via assembly
456 
457 				// solhint-disable-next-line no-inline-assembly
458 				assembly {
459 					let returndata_size := mload(returndata)
460 					revert(add(32, returndata), returndata_size)
461 				}
462 			} else {
463 				revert(errorMessage);
464 			}
465 		}
466 	}
467 }
468 
469 /**
470  * @dev Implementation of the {IERC20} interface.
471  *
472  * This implementation is agnostic to the way tokens are created. This means
473  * that a supply mechanism has to be added in a derived contract using {_mint}.
474  * For a generic mechanism see {ERC20PresetMinterPauser}.
475  *
476  * TIP: For a detailed writeup see our guide
477  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
478  * to implement supply mechanisms].
479  *
480  * We have followed general OpenZeppelin guidelines: functions revert instead
481  * of returning `false` on failure. This behavior is nonetheless conventional
482  * and does not conflict with the expectations of ERC20 applications.
483  *
484  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
485  * This allows applications to reconstruct the allowance for all accounts just
486  * by listening to said events. Other implementations of the EIP may not emit
487  * these events, as it isn't required by the specification.
488  *
489  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
490  * functions have been added to mitigate the well-known issues around setting
491  * allowances. See {IERC20-approve}.
492  */
493 contract ERC20 is Context, IERC20 {
494 	using SafeMath for uint256;
495 	using Address for address;
496 
497 	mapping(address => uint256) private _balances;
498 
499 	mapping(address => mapping(address => uint256)) private _allowances;
500 
501 	uint256 private _totalSupply;
502 
503 	string private _name;
504 	string private _symbol;
505 	uint8 private _decimals;
506 
507 	/**
508 	 * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
509 	 * a default value of 18.
510 	 *
511 	 * To select a different value for {decimals}, use {_setupDecimals}.
512 	 *
513 	 * All three of these values are immutable: they can only be set once during
514 	 * construction.
515 	 */
516 	constructor(string memory name, string memory symbol) public {
517 		_name = name;
518 		_symbol = symbol;
519 		_decimals = 18;
520 	}
521 
522 	/**
523 	 * @dev Returns the name of the token.
524 	 */
525 	function name() public view returns (string memory) {
526 		return _name;
527 	}
528 
529 	/**
530 	 * @dev Returns the symbol of the token, usually a shorter version of the
531 	 * name.
532 	 */
533 	function symbol() public view returns (string memory) {
534 		return _symbol;
535 	}
536 
537 	/**
538 	 * @dev Returns the number of decimals used to get its user representation.
539 	 * For example, if `decimals` equals `2`, a balance of `505` tokens should
540 	 * be displayed to a user as `5,05` (`505 / 10 ** 2`).
541 	 *
542 	 * Tokens usually opt for a value of 18, imitating the relationship between
543 	 * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
544 	 * called.
545 	 *
546 	 * NOTE: This information is only used for _display_ purposes: it in
547 	 * no way affects any of the arithmetic of the contract, including
548 	 * {IERC20-balanceOf} and {IERC20-transfer}.
549 	 */
550 	function decimals() public view returns (uint8) {
551 		return _decimals;
552 	}
553 
554 	/**
555 	 * @dev See {IERC20-totalSupply}.
556 	 */
557 	function totalSupply() public override view returns (uint256) {
558 		return _totalSupply;
559 	}
560 
561 	/**
562 	 * @dev See {IERC20-balanceOf}.
563 	 */
564 	function balanceOf(address account) public override view returns (uint256) {
565 		return _balances[account];
566 	}
567 
568 	/**
569 	 * @dev See {IERC20-transfer}.
570 	 *
571 	 * Requirements:
572 	 *
573 	 * - `recipient` cannot be the zero address.
574 	 * - the caller must have a balance of at least `amount`.
575 	 */
576 	function transfer(address recipient, uint256 amount)
577 		public
578 		virtual
579 		override
580 		returns (bool)
581 	{
582 		_transfer(_msgSender(), recipient, amount);
583 		return true;
584 	}
585 
586 	/**
587 	 * @dev See {IERC20-allowance}.
588 	 */
589 	function allowance(address owner, address spender)
590 		public
591 		virtual
592 		override
593 		view
594 		returns (uint256)
595 	{
596 		return _allowances[owner][spender];
597 	}
598 
599 	/**
600 	 * @dev See {IERC20-approve}.
601 	 *
602 	 * Requirements:
603 	 *
604 	 * - `spender` cannot be the zero address.
605 	 */
606 	function approve(address spender, uint256 amount)
607 		public
608 		virtual
609 		override
610 		returns (bool)
611 	{
612 		_approve(_msgSender(), spender, amount);
613 		return true;
614 	}
615 
616 	/**
617 	 * @dev See {IERC20-transferFrom}.
618 	 *
619 	 * Emits an {Approval} event indicating the updated allowance. This is not
620 	 * required by the EIP. See the note at the beginning of {ERC20};
621 	 *
622 	 * Requirements:
623 	 * - `sender` and `recipient` cannot be the zero address.
624 	 * - `sender` must have a balance of at least `amount`.
625 	 * - the caller must have allowance for ``sender``'s tokens of at least
626 	 * `amount`.
627 	 */
628 	function transferFrom(
629 		address sender,
630 		address recipient,
631 		uint256 amount
632 	) public virtual override returns (bool) {
633 		_transfer(sender, recipient, amount);
634 		_approve(
635 			sender,
636 			_msgSender(),
637 			_allowances[sender][_msgSender()].sub(
638 				amount,
639 				"ERC20: transfer amount exceeds allowance"
640 			)
641 		);
642 		return true;
643 	}
644 
645 	/**
646 	 * @dev Atomically increases the allowance granted to `spender` by the caller.
647 	 *
648 	 * This is an alternative to {approve} that can be used as a mitigation for
649 	 * problems described in {IERC20-approve}.
650 	 *
651 	 * Emits an {Approval} event indicating the updated allowance.
652 	 *
653 	 * Requirements:
654 	 *
655 	 * - `spender` cannot be the zero address.
656 	 */
657 	function increaseAllowance(address spender, uint256 addedValue)
658 		public
659 		virtual
660 		returns (bool)
661 	{
662 		_approve(
663 			_msgSender(),
664 			spender,
665 			_allowances[_msgSender()][spender].add(addedValue)
666 		);
667 		return true;
668 	}
669 
670 	/**
671 	 * @dev Atomically decreases the allowance granted to `spender` by the caller.
672 	 *
673 	 * This is an alternative to {approve} that can be used as a mitigation for
674 	 * problems described in {IERC20-approve}.
675 	 *
676 	 * Emits an {Approval} event indicating the updated allowance.
677 	 *
678 	 * Requirements:
679 	 *
680 	 * - `spender` cannot be the zero address.
681 	 * - `spender` must have allowance for the caller of at least
682 	 * `subtractedValue`.
683 	 */
684 	function decreaseAllowance(address spender, uint256 subtractedValue)
685 		public
686 		virtual
687 		returns (bool)
688 	{
689 		_approve(
690 			_msgSender(),
691 			spender,
692 			_allowances[_msgSender()][spender].sub(
693 				subtractedValue,
694 				"ERC20: decreased allowance below zero"
695 			)
696 		);
697 		return true;
698 	}
699 
700 	/**
701 	 * @dev Moves tokens `amount` from `sender` to `recipient`.
702 	 *
703 	 * This is internal function is equivalent to {transfer}, and can be used to
704 	 * e.g. implement automatic token fees, slashing mechanisms, etc.
705 	 *
706 	 * Emits a {Transfer} event.
707 	 *
708 	 * Requirements:
709 	 *
710 	 * - `sender` cannot be the zero address.
711 	 * - `recipient` cannot be the zero address.
712 	 * - `sender` must have a balance of at least `amount`.
713 	 */
714 	function _transfer(
715 		address sender,
716 		address recipient,
717 		uint256 amount
718 	) internal virtual {
719 		require(sender != address(0), "ERC20: transfer from the zero address");
720 		require(recipient != address(0), "ERC20: transfer to the zero address");
721 
722 		_beforeTokenTransfer(sender, recipient, amount);
723 
724 		_balances[sender] = _balances[sender].sub(
725 			amount,
726 			"ERC20: transfer amount exceeds balance"
727 		);
728 		_balances[recipient] = _balances[recipient].add(amount);
729 		emit Transfer(sender, recipient, amount);
730 	}
731 
732 	/** @dev Creates `amount` tokens and assigns them to `account`, increasing
733 	 * the total supply.
734 	 *
735 	 * Emits a {Transfer} event with `from` set to the zero address.
736 	 *
737 	 * Requirements
738 	 *
739 	 * - `to` cannot be the zero address.
740 	 */
741 	function _mint(address account, uint256 amount) internal virtual {
742 		require(account != address(0), "ERC20: mint to the zero address");
743 
744 		_beforeTokenTransfer(address(0), account, amount);
745 
746 		_totalSupply = _totalSupply.add(amount);
747 		_balances[account] = _balances[account].add(amount);
748 		emit Transfer(address(0), account, amount);
749 	}
750 
751 	/**
752 	 * @dev Destroys `amount` tokens from `account`, reducing the
753 	 * total supply.
754 	 *
755 	 * Emits a {Transfer} event with `to` set to the zero address.
756 	 *
757 	 * Requirements
758 	 *
759 	 * - `account` cannot be the zero address.
760 	 * - `account` must have at least `amount` tokens.
761 	 */
762 	function _burn(address account, uint256 amount) internal virtual {
763 		require(account != address(0), "ERC20: burn from the zero address");
764 
765 		_beforeTokenTransfer(account, address(0), amount);
766 
767 		_balances[account] = _balances[account].sub(
768 			amount,
769 			"ERC20: burn amount exceeds balance"
770 		);
771 		_totalSupply = _totalSupply.sub(amount);
772 		emit Transfer(account, address(0), amount);
773 	}
774 
775 	/**
776 	 * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
777 	 *
778 	 * This is internal function is equivalent to `approve`, and can be used to
779 	 * e.g. set automatic allowances for certain subsystems, etc.
780 	 *
781 	 * Emits an {Approval} event.
782 	 *
783 	 * Requirements:
784 	 *
785 	 * - `owner` cannot be the zero address.
786 	 * - `spender` cannot be the zero address.
787 	 */
788 	function _approve(
789 		address owner,
790 		address spender,
791 		uint256 amount
792 	) internal virtual {
793 		require(owner != address(0), "ERC20: approve from the zero address");
794 		require(spender != address(0), "ERC20: approve to the zero address");
795 
796 		_allowances[owner][spender] = amount;
797 		emit Approval(owner, spender, amount);
798 	}
799 
800 	/**
801 	 * @dev Sets {decimals} to a value other than the default one of 18.
802 	 *
803 	 * WARNING: This function should only be called from the constructor. Most
804 	 * applications that interact with token contracts will not expect
805 	 * {decimals} to ever change, and may work incorrectly if it does.
806 	 */
807 	function _setupDecimals(uint8 decimals_) internal {
808 		_decimals = decimals_;
809 	}
810 
811 	/**
812 	 * @dev Hook that is called before any transfer of tokens. This includes
813 	 * minting and burning.
814 	 *
815 	 * Calling conditions:
816 	 *
817 	 * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
818 	 * will be to transferred to `to`.
819 	 * - when `from` is zero, `amount` tokens will be minted for `to`.
820 	 * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
821 	 * - `from` and `to` are never both zero.
822 	 *
823 	 * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
824 	 */
825 	function _beforeTokenTransfer(
826 		address from,
827 		address to,
828 		uint256 amount
829 	) internal virtual {}
830 }
831 
832 /**
833  * @dev Extension of {ERC20} that allows token holders to destroy both their own
834  * tokens and those that they have an allowance for, in a way that can be
835  * recognized off-chain (via event analysis).
836  */
837 abstract contract ERC20Burnable is Context, ERC20 {
838 	/**
839 	 * @dev Destroys `amount` tokens from the caller.
840 	 *
841 	 * See {ERC20-_burn}.
842 	 */
843 	function burn(uint256 amount) public virtual {
844 		_burn(_msgSender(), amount);
845 	}
846 
847 	/**
848 	 * @dev Destroys `amount` tokens from `account`, deducting from the caller's
849 	 * allowance.
850 	 *
851 	 * See {ERC20-_burn} and {ERC20-allowance}.
852 	 *
853 	 * Requirements:
854 	 *
855 	 * - the caller must have allowance for ``accounts``'s tokens of at least
856 	 * `amount`.
857 	 */
858 	function burnFrom(address account, uint256 amount) public virtual {
859 		uint256 decreasedAllowance = allowance(account, _msgSender()).sub(
860 			amount,
861 			"ERC20: burn amount exceeds allowance"
862 		);
863 
864 		_approve(account, _msgSender(), decreasedAllowance);
865 		_burn(account, amount);
866 	}
867 }
868 
869 contract HavensNook is ERC20Burnable {
870 	constructor(
871 		string memory name,
872 		string memory symbol,
873 		address initialAccount,
874 		uint256 initialBalance
875 	) public ERC20(name, symbol) {
876 		_mint(initialAccount, initialBalance);
877 	}
878 }