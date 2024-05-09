1 // SPDX-License-Identifier: MIT
2 pragma solidity =0.8.7;
3 
4 /**
5  * @dev Interface of the ERC20 standard as defined in the EIP.
6  */
7 interface IERC20 {
8 	/**
9 	 * @dev Returns the amount of tokens in existence.
10 	 */
11 	function totalSupply() external view returns (uint256);
12 
13 	/**
14 	 * @dev Returns the amount of tokens owned by `account`.
15 	 */
16 	function balanceOf(address account) external view returns (uint256);
17 
18 	/**
19 	 * @dev Moves `amount` tokens from the caller's account to `recipient`.
20 	 *
21 	 * Returns a boolean value indicating whether the operation succeeded.
22 	 *
23 	 * Emits a {Transfer} event.
24 	 */
25 	function transfer(address recipient, uint256 amount)
26 		external
27 		returns (bool);
28 
29 	/**
30 	 * @dev Returns the remaining number of tokens that `spender` will be
31 	 * allowed to spend on behalf of `owner` through {transferFrom}. This is
32 	 * zero by default.
33 	 *
34 	 * This value changes when {approve} or {transferFrom} are called.
35 	 */
36 	function allowance(address owner, address spender)
37 		external
38 		view
39 		returns (uint256);
40 
41 	/**
42 	 * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
43 	 *
44 	 * Returns a boolean value indicating whether the operation succeeded.
45 	 *
46 	 * IMPORTANT: Beware that changing an allowance with this method brings the risk
47 	 * that someone may use both the old and the new allowance by unfortunate
48 	 * transaction ordering. One possible solution to mitigate this race
49 	 * condition is to first reduce the spender's allowance to 0 and set the
50 	 * desired value afterwards:
51 	 * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
52 	 *
53 	 * Emits an {Approval} event.
54 	 */
55 	function approve(address spender, uint256 amount) external returns (bool);
56 
57 	/**
58 	 * @dev Moves `amount` tokens from `sender` to `recipient` using the
59 	 * allowance mechanism. `amount` is then deducted from the caller's
60 	 * allowance.
61 	 *
62 	 * Returns a boolean value indicating whether the operation succeeded.
63 	 *
64 	 * Emits a {Transfer} event.
65 	 */
66 	function transferFrom(
67 		address sender,
68 		address recipient,
69 		uint256 amount
70 	) external returns (bool);
71 
72 	/**
73 	 * @dev Emitted when `value` tokens are moved from one account (`from`) to
74 	 * another (`to`).
75 	 *
76 	 * Note that `value` may be zero.
77 	 */
78 	event Transfer(address indexed from, address indexed to, uint256 value);
79 
80 	/**
81 	 * @dev Emitted when the allowance of a `spender` for an `owner` is set by
82 	 * a call to {approve}. `value` is the new allowance.
83 	 */
84 	event Approval(
85 		address indexed owner,
86 		address indexed spender,
87 		uint256 value
88 	);
89 }
90 
91 /**
92  * @dev Interface for the optional metadata functions from the ERC20 standard.
93  *
94  * _Available since v4.1._
95  */
96 interface IERC20Metadata is IERC20 {
97 	/**
98 	 * @dev Returns the name of the token.
99 	 */
100 	function name() external view returns (string memory);
101 
102 	/**
103 	 * @dev Returns the symbol of the token.
104 	 */
105 	function symbol() external view returns (string memory);
106 
107 	/**
108 	 * @dev Returns the decimals places of the token.
109 	 */
110 	function decimals() external view returns (uint8);
111 }
112 
113 /**
114  * @dev Provides information about the current execution context, including the
115  * sender of the transaction and its data. While these are generally available
116  * via msg.sender and msg.data, they should not be accessed in such a direct
117  * manner, since when dealing with meta-transactions the account sending and
118  * paying for execution may not be the actual sender (as far as an application
119  * is concerned).
120  *
121  * This contract is only required for intermediate, library-like contracts.
122  */
123 abstract contract Context {
124 	function _msgSender() internal view virtual returns (address) {
125 		return msg.sender;
126 	}
127 
128 	function _msgData() internal view virtual returns (bytes calldata) {
129 		return msg.data;
130 	}
131 }
132 
133 /**
134  * @dev Contract module which provides a basic access control mechanism, where
135  * there is an account (an owner) that can be granted exclusive access to
136  * specific functions.
137  *
138  * By default, the owner account will be the one that deploys the contract. This
139  * can later be changed with {transferOwnership}.
140  *
141  * This module is used through inheritance. It will make available the modifier
142  * `onlyOwner`, which can be applied to your functions to restrict their use to
143  * the owner.
144  */
145 abstract contract Ownable is Context {
146 	address private _owner;
147 
148 	event OwnershipTransferred(
149 		address indexed previousOwner,
150 		address indexed newOwner
151 	);
152 
153 	/**
154 	 * @dev Initializes the contract setting the deployer as the initial owner.
155 	 */
156 	constructor() {
157 		_setOwner(_msgSender());
158 	}
159 
160 	/**
161 	 * @dev Returns the address of the current owner.
162 	 */
163 	function owner() public view virtual returns (address) {
164 		return _owner;
165 	}
166 
167 	/**
168 	 * @dev Throws if called by any account other than the owner.
169 	 */
170 	modifier onlyOwner() {
171 		require(owner() == _msgSender(), "Ownable: caller is not the owner");
172 		_;
173 	}
174 
175 	/**
176 	 * @dev Leaves the contract without owner. It will not be possible to call
177 	 * `onlyOwner` functions anymore. Can only be called by the current owner.
178 	 *
179 	 * NOTE: Renouncing ownership will leave the contract without an owner,
180 	 * thereby removing any functionality that is only available to the owner.
181 	 */
182 	function renounceOwnership() public virtual onlyOwner {
183 		_setOwner(address(0));
184 	}
185 
186 	/**
187 	 * @dev Transfers ownership of the contract to a new account (`newOwner`).
188 	 * Can only be called by the current owner.
189 	 */
190 	function transferOwnership(address newOwner) public virtual onlyOwner {
191 		require(
192 			newOwner != address(0),
193 			"Ownable: new owner is the zero address"
194 		);
195 		_setOwner(newOwner);
196 	}
197 
198 	function _setOwner(address newOwner) private {
199 		address oldOwner = _owner;
200 		_owner = newOwner;
201 		emit OwnershipTransferred(oldOwner, newOwner);
202 	}
203 }
204 
205 /**
206  * @dev Implementation of the {IERC20} interface.
207  *
208  * This implementation is agnostic to the way tokens are created. This means
209  * that a supply mechanism has to be added in a derived contract using {_mint}.
210  * For a generic mechanism see {ERC20PresetMinterPauser}.
211  *
212  * TIP: For a detailed writeup see our guide
213  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
214  * to implement supply mechanisms].
215  *
216  * We have followed general OpenZeppelin Contracts guidelines: functions revert
217  * instead returning `false` on failure. This behavior is nonetheless
218  * conventional and does not conflict with the expectations of ERC20
219  * applications.
220  *
221  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
222  * This allows applications to reconstruct the allowance for all accounts just
223  * by listening to said events. Other implementations of the EIP may not emit
224  * these events, as it isn't required by the specification.
225  *
226  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
227  * functions have been added to mitigate the well-known issues around setting
228  * allowances. See {IERC20-approve}.
229  */
230 contract ERC20 is Context, IERC20, IERC20Metadata {
231 	mapping(address => uint256) private _balances;
232 
233 	mapping(address => mapping(address => uint256)) private _allowances;
234 
235 	uint256 private _totalSupply;
236 
237 	string private _name;
238 	string private _symbol;
239 
240 	/**
241 	 * @dev Sets the values for {name} and {symbol}.
242 	 *
243 	 * The default value of {decimals} is 18. To select a different value for
244 	 * {decimals} you should overload it.
245 	 *
246 	 * All two of these values are immutable: they can only be set once during
247 	 * construction.
248 	 */
249 	constructor(string memory name_, string memory symbol_) {
250 		_name = name_;
251 		_symbol = symbol_;
252 	}
253 
254 	/**
255 	 * @dev Returns the name of the token.
256 	 */
257 	function name() public view virtual override returns (string memory) {
258 		return _name;
259 	}
260 
261 	/**
262 	 * @dev Returns the symbol of the token, usually a shorter version of the
263 	 * name.
264 	 */
265 	function symbol() public view virtual override returns (string memory) {
266 		return _symbol;
267 	}
268 
269 	/**
270 	 * @dev Returns the number of decimals used to get its user representation.
271 	 * For example, if `decimals` equals `2`, a balance of `505` tokens should
272 	 * be displayed to a user as `5.05` (`505 / 10 ** 2`).
273 	 *
274 	 * Tokens usually opt for a value of 18, imitating the relationship between
275 	 * Ether and Wei. This is the value {ERC20} uses, unless this function is
276 	 * overridden;
277 	 *
278 	 * NOTE: This information is only used for _display_ purposes: it in
279 	 * no way affects any of the arithmetic of the contract, including
280 	 * {IERC20-balanceOf} and {IERC20-transfer}.
281 	 */
282 	function decimals() public view virtual override returns (uint8) {
283 		return 18;
284 	}
285 
286 	/**
287 	 * @dev See {IERC20-totalSupply}.
288 	 */
289 	function totalSupply() public view virtual override returns (uint256) {
290 		return _totalSupply;
291 	}
292 
293 	/**
294 	 * @dev See {IERC20-balanceOf}.
295 	 */
296 	function balanceOf(address account)
297 		public
298 		view
299 		virtual
300 		override
301 		returns (uint256)
302 	{
303 		return _balances[account];
304 	}
305 
306 	/**
307 	 * @dev See {IERC20-transfer}.
308 	 *
309 	 * Requirements:
310 	 *
311 	 * - `recipient` cannot be the zero address.
312 	 * - the caller must have a balance of at least `amount`.
313 	 */
314 	function transfer(address recipient, uint256 amount)
315 		public
316 		virtual
317 		override
318 		returns (bool)
319 	{
320 		_transfer(_msgSender(), recipient, amount);
321 		return true;
322 	}
323 
324 	/**
325 	 * @dev See {IERC20-allowance}.
326 	 */
327 	function allowance(address owner, address spender)
328 		public
329 		view
330 		virtual
331 		override
332 		returns (uint256)
333 	{
334 		return _allowances[owner][spender];
335 	}
336 
337 	/**
338 	 * @dev See {IERC20-approve}.
339 	 *
340 	 * Requirements:
341 	 *
342 	 * - `spender` cannot be the zero address.
343 	 */
344 	function approve(address spender, uint256 amount)
345 		public
346 		virtual
347 		override
348 		returns (bool)
349 	{
350 		_approve(_msgSender(), spender, amount);
351 		return true;
352 	}
353 
354 	/**
355 	 * @dev See {IERC20-transferFrom}.
356 	 *
357 	 * Emits an {Approval} event indicating the updated allowance. This is not
358 	 * required by the EIP. See the note at the beginning of {ERC20}.
359 	 *
360 	 * Requirements:
361 	 *
362 	 * - `sender` and `recipient` cannot be the zero address.
363 	 * - `sender` must have a balance of at least `amount`.
364 	 * - the caller must have allowance for ``sender``'s tokens of at least
365 	 * `amount`.
366 	 */
367 	function transferFrom(
368 		address sender,
369 		address recipient,
370 		uint256 amount
371 	) public virtual override returns (bool) {
372 		_transfer(sender, recipient, amount);
373 
374 		uint256 currentAllowance = _allowances[sender][_msgSender()];
375 		require(
376 			currentAllowance >= amount,
377 			"ERC20: transfer amount exceeds allowance"
378 		);
379 		unchecked {
380 			_approve(sender, _msgSender(), currentAllowance - amount);
381 		}
382 
383 		return true;
384 	}
385 
386 	/**
387 	 * @dev Atomically increases the allowance granted to `spender` by the caller.
388 	 *
389 	 * This is an alternative to {approve} that can be used as a mitigation for
390 	 * problems described in {IERC20-approve}.
391 	 *
392 	 * Emits an {Approval} event indicating the updated allowance.
393 	 *
394 	 * Requirements:
395 	 *
396 	 * - `spender` cannot be the zero address.
397 	 */
398 	function increaseAllowance(address spender, uint256 addedValue)
399 		public
400 		virtual
401 		returns (bool)
402 	{
403 		_approve(
404 			_msgSender(),
405 			spender,
406 			_allowances[_msgSender()][spender] + addedValue
407 		);
408 		return true;
409 	}
410 
411 	/**
412 	 * @dev Atomically decreases the allowance granted to `spender` by the caller.
413 	 *
414 	 * This is an alternative to {approve} that can be used as a mitigation for
415 	 * problems described in {IERC20-approve}.
416 	 *
417 	 * Emits an {Approval} event indicating the updated allowance.
418 	 *
419 	 * Requirements:
420 	 *
421 	 * - `spender` cannot be the zero address.
422 	 * - `spender` must have allowance for the caller of at least
423 	 * `subtractedValue`.
424 	 */
425 	function decreaseAllowance(address spender, uint256 subtractedValue)
426 		public
427 		virtual
428 		returns (bool)
429 	{
430 		uint256 currentAllowance = _allowances[_msgSender()][spender];
431 		require(
432 			currentAllowance >= subtractedValue,
433 			"ERC20: decreased allowance below zero"
434 		);
435 		unchecked {
436 			_approve(_msgSender(), spender, currentAllowance - subtractedValue);
437 		}
438 
439 		return true;
440 	}
441 
442 	/**
443 	 * @dev Moves `amount` of tokens from `sender` to `recipient`.
444 	 *
445 	 * This internal function is equivalent to {transfer}, and can be used to
446 	 * e.g. implement automatic token fees, slashing mechanisms, etc.
447 	 *
448 	 * Emits a {Transfer} event.
449 	 *
450 	 * Requirements:
451 	 *
452 	 * - `sender` cannot be the zero address.
453 	 * - `recipient` cannot be the zero address.
454 	 * - `sender` must have a balance of at least `amount`.
455 	 */
456 	function _transfer(
457 		address sender,
458 		address recipient,
459 		uint256 amount
460 	) internal virtual {
461 		require(sender != address(0), "ERC20: transfer from the zero address");
462 		require(recipient != address(0), "ERC20: transfer to the zero address");
463 
464 		_beforeTokenTransfer(sender, recipient, amount);
465 
466 		uint256 senderBalance = _balances[sender];
467 		require(
468 			senderBalance >= amount,
469 			"ERC20: transfer amount exceeds balance"
470 		);
471 		unchecked {
472 			_balances[sender] = senderBalance - amount;
473 		}
474 		_balances[recipient] += amount;
475 
476 		emit Transfer(sender, recipient, amount);
477 
478 		_afterTokenTransfer(sender, recipient, amount);
479 	}
480 
481 	/** @dev Creates `amount` tokens and assigns them to `account`, increasing
482 	 * the total supply.
483 	 *
484 	 * Emits a {Transfer} event with `from` set to the zero address.
485 	 *
486 	 * Requirements:
487 	 *
488 	 * - `account` cannot be the zero address.
489 	 */
490 	function _mint(address account, uint256 amount) internal virtual {
491 		require(account != address(0), "ERC20: mint to the zero address");
492 
493 		_beforeTokenTransfer(address(0), account, amount);
494 
495 		_totalSupply += amount;
496 		_balances[account] += amount;
497 		emit Transfer(address(0), account, amount);
498 
499 		_afterTokenTransfer(address(0), account, amount);
500 	}
501 
502 	/**
503 	 * @dev Destroys `amount` tokens from `account`, reducing the
504 	 * total supply.
505 	 *
506 	 * Emits a {Transfer} event with `to` set to the zero address.
507 	 *
508 	 * Requirements:
509 	 *
510 	 * - `account` cannot be the zero address.
511 	 * - `account` must have at least `amount` tokens.
512 	 */
513 	function _burn(address account, uint256 amount) internal virtual {
514 		require(account != address(0), "ERC20: burn from the zero address");
515 
516 		_beforeTokenTransfer(account, address(0), amount);
517 
518 		uint256 accountBalance = _balances[account];
519 		require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
520 		unchecked {
521 			_balances[account] = accountBalance - amount;
522 		}
523 		_totalSupply -= amount;
524 
525 		emit Transfer(account, address(0), amount);
526 
527 		_afterTokenTransfer(account, address(0), amount);
528 	}
529 
530 	/**
531 	 * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
532 	 *
533 	 * This internal function is equivalent to `approve`, and can be used to
534 	 * e.g. set automatic allowances for certain subsystems, etc.
535 	 *
536 	 * Emits an {Approval} event.
537 	 *
538 	 * Requirements:
539 	 *
540 	 * - `owner` cannot be the zero address.
541 	 * - `spender` cannot be the zero address.
542 	 */
543 	function _approve(
544 		address owner,
545 		address spender,
546 		uint256 amount
547 	) internal virtual {
548 		require(owner != address(0), "ERC20: approve from the zero address");
549 		require(spender != address(0), "ERC20: approve to the zero address");
550 
551 		_allowances[owner][spender] = amount;
552 		emit Approval(owner, spender, amount);
553 	}
554 
555 	/**
556 	 * @dev Hook that is called before any transfer of tokens. This includes
557 	 * minting and burning.
558 	 *
559 	 * Calling conditions:
560 	 *
561 	 * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
562 	 * will be transferred to `to`.
563 	 * - when `from` is zero, `amount` tokens will be minted for `to`.
564 	 * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
565 	 * - `from` and `to` are never both zero.
566 	 *
567 	 * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
568 	 */
569 	function _beforeTokenTransfer(
570 		address from,
571 		address to,
572 		uint256 amount
573 	) internal virtual {}
574 
575 	/**
576 	 * @dev Hook that is called after any transfer of tokens. This includes
577 	 * minting and burning.
578 	 *
579 	 * Calling conditions:
580 	 *
581 	 * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
582 	 * has been transferred to `to`.
583 	 * - when `from` is zero, `amount` tokens have been minted for `to`.
584 	 * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
585 	 * - `from` and `to` are never both zero.
586 	 *
587 	 * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
588 	 */
589 	function _afterTokenTransfer(
590 		address from,
591 		address to,
592 		uint256 amount
593 	) internal virtual {}
594 }
595 
596 contract VentToken is Ownable, ERC20 {
597 	constructor() ERC20("VENT", "VENT") {
598 		_mint(msg.sender, 250_000_000 ether);
599 	}
600 
601 	function burn(uint256 _amount) public onlyOwner {
602 		_burn(msg.sender, _amount);
603 	}
604 }