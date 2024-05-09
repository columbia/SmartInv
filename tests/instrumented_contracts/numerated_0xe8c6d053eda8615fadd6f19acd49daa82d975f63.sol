1 //https://haroldtoken.vip/
2 //https://t.me/HaroldPortal
3 
4 pragma solidity ^0.8.0;
5 
6 interface IERC20 {
7     event Transfer(address indexed from, address indexed to, uint256 value);
8 
9     /**
10      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
11      * a call to {approve}. `value` is the new allowance.
12      */
13     event Approval(address indexed owner, address indexed spender, uint256 value);
14 
15     /**
16      * @dev Returns the amount of tokens in existence.
17      */
18     function totalSupply() external view returns (uint256);
19 
20     /**
21      * @dev Returns the amount of tokens owned by `account`.
22      */
23     function balanceOf(address account) external view returns (uint256);
24 
25     /**
26      * @dev Moves `amount` tokens from the caller's account to `to`.
27      *
28      * Returns a boolean value indicating whether the operation succeeded.
29      *
30      * Emits a {Transfer} event.
31      */
32     function transfer(address to, uint256 amount) external returns (bool);
33 
34     /**
35      * @dev Returns the remaining number of tokens that `spender` will be
36      * allowed to spend on behalf of `owner` through {transferFrom}. This is
37      * zero by default.
38      *
39      * This value changes when {approve} or {transferFrom} are called.
40      */
41     function allowance(address owner, address spender) external view returns (uint256);
42 
43     /**
44      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
45      *
46      * Returns a boolean value indicating whether the operation succeeded.
47      *
48      * IMPORTANT: Beware that changing an allowance with this method brings the risk
49      * that someone may use both the old and the new allowance by unfortunate
50      * transaction ordering. One possible solution to mitigate this race
51      * condition is to first reduce the spender's allowance to 0 and set the
52      * desired value afterwards:
53      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
54      *
55      * Emits an {Approval} event.
56      */
57     function approve(address spender, uint256 amount) external returns (bool);
58 
59     /**
60      * @dev Moves `amount` tokens from `from` to `to` using the
61      * allowance mechanism. `amount` is then deducted from the caller's
62      * allowance.
63      *
64      * Returns a boolean value indicating whether the operation succeeded.
65      *
66      * Emits a {Transfer} event.
67      */
68     function transferFrom(address from, address to, uint256 amount) external returns (bool);
69 }
70 
71 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
72 
73 
74 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
75 
76 pragma solidity ^0.8.0;
77 
78 
79 /**
80  * @dev Interface for the optional metadata functions from the ERC20 standard.
81  *
82  * _Available since v4.1._
83  */
84 interface IERC20Metadata is IERC20 {
85     /**
86      * @dev Returns the name of the token.
87      */
88     function name() external view returns (string memory);
89 
90     /**
91      * @dev Returns the symbol of the token.
92      */
93     function symbol() external view returns (string memory);
94 
95     /**
96      * @dev Returns the decimals places of the token.
97      */
98     function decimals() external view returns (uint8);
99 }
100 
101 // File: @openzeppelin/contracts/utils/Context.sol
102 
103 
104 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
105 
106 pragma solidity ^0.8.0;
107 
108 /**
109  * @dev Provides information about the current execution context, including the
110  * sender of the transaction and its data. While these are generally available
111  * via msg.sender and msg.data, they should not be accessed in such a direct
112  * manner, since when dealing with meta-transactions the account sending and
113  * paying for execution may not be the actual sender (as far as an application
114  * is concerned).
115  *
116  * This contract is only required for intermediate, library-like contracts.
117  */
118 abstract contract Context {
119     function _msgSender() internal view virtual returns (address) {
120         return msg.sender;
121     }
122 
123     function _msgData() internal view virtual returns (bytes calldata) {
124         return msg.data;
125     }
126 }
127 
128 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
129 
130 
131 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/ERC20.sol)
132 
133 pragma solidity ^0.8.0;
134 
135 
136 
137 
138 /**
139  * @dev Implementation of the {IERC20} interface.
140  *
141  * This implementation is agnostic to the way tokens are created. This means
142  * that a supply mechanism has to be added in a derived contract using {_mint}.
143  * For a generic mechanism see {ERC20PresetMinterPauser}.
144  *
145  * TIP: For a detailed writeup see our guide
146  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
147  * to implement supply mechanisms].
148  *
149  * The default value of {decimals} is 18. To change this, you should override
150  * this function so it returns a different value.
151  *
152  * We have followed general OpenZeppelin Contracts guidelines: functions revert
153  * instead returning `false` on failure. This behavior is nonetheless
154  * conventional and does not conflict with the expectations of ERC20
155  * applications.
156  *
157  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
158  * This allows applications to reconstruct the allowance for all accounts just
159  * by listening to said events. Other implementations of the EIP may not emit
160  * these events, as it isn't required by the specification.
161  *
162  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
163  * functions have been added to mitigate the well-known issues around setting
164  * allowances. See {IERC20-approve}.
165  */
166 contract ERC20 is Context, IERC20, IERC20Metadata {
167     mapping(address => uint256) private _balances;
168 
169     mapping(address => mapping(address => uint256)) private _allowances;
170 
171     uint256 private _totalSupply;
172 
173     string private _name;
174     string private _symbol;
175 
176     /**
177      * @dev Sets the values for {name} and {symbol}.
178      *
179      * All two of these values are immutable: they can only be set once during
180      * construction.
181      */
182     constructor(string memory name_, string memory symbol_) {
183         _name = name_;
184         _symbol = symbol_;
185     }
186 
187     /**
188      * @dev Returns the name of the token.
189      */
190     function name() public view virtual override returns (string memory) {
191         return _name;
192     }
193 
194     /**
195      * @dev Returns the symbol of the token, usually a shorter version of the
196      * name.
197      */
198     function symbol() public view virtual override returns (string memory) {
199         return _symbol;
200     }
201 
202     /**
203      * @dev Returns the number of decimals used to get its user representation.
204      * For example, if `decimals` equals `2`, a balance of `505` tokens should
205      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
206      *
207      * Tokens usually opt for a value of 18, imitating the relationship between
208      * Ether and Wei. This is the default value returned by this function, unless
209      * it's overridden.
210      *
211      * NOTE: This information is only used for _display_ purposes: it in
212      * no way affects any of the arithmetic of the contract, including
213      * {IERC20-balanceOf} and {IERC20-transfer}.
214      */
215     function decimals() public view virtual override returns (uint8) {
216         return 18;
217     }
218 
219     /**
220      * @dev See {IERC20-totalSupply}.
221      */
222     function totalSupply() public view virtual override returns (uint256) {
223         return _totalSupply;
224     }
225 
226     /**
227      * @dev See {IERC20-balanceOf}.
228      */
229     function balanceOf(address account) public view virtual override returns (uint256) {
230         return _balances[account];
231     }
232 
233     /**
234      * @dev See {IERC20-transfer}.
235      *
236      * Requirements:
237      *
238      * - `to` cannot be the zero address.
239      * - the caller must have a balance of at least `amount`.
240      */
241     function transfer(address to, uint256 amount) public virtual override returns (bool) {
242         address owner = _msgSender();
243         _transfer(owner, to, amount);
244         return true;
245     }
246 
247     /**
248      * @dev See {IERC20-allowance}.
249      */
250     function allowance(address owner, address spender) public view virtual override returns (uint256) {
251         return _allowances[owner][spender];
252     }
253 
254     /**
255      * @dev See {IERC20-approve}.
256      *
257      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
258      * `transferFrom`. This is semantically equivalent to an infinite approval.
259      *
260      * Requirements:
261      *
262      * - `spender` cannot be the zero address.
263      */
264     function approve(address spender, uint256 amount) public virtual override returns (bool) {
265         address owner = _msgSender();
266         _approve(owner, spender, amount);
267         return true;
268     }
269 
270     /**
271      * @dev See {IERC20-transferFrom}.
272      *
273      * Emits an {Approval} event indicating the updated allowance. This is not
274      * required by the EIP. See the note at the beginning of {ERC20}.
275      *
276      * NOTE: Does not update the allowance if the current allowance
277      * is the maximum `uint256`.
278      *
279      * Requirements:
280      *
281      * - `from` and `to` cannot be the zero address.
282      * - `from` must have a balance of at least `amount`.
283      * - the caller must have allowance for ``from``'s tokens of at least
284      * `amount`.
285      */
286     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
287         address spender = _msgSender();
288         _spendAllowance(from, spender, amount);
289         _transfer(from, to, amount);
290         return true;
291     }
292 
293     /**
294      * @dev Atomically increases the allowance granted to `spender` by the caller.
295      *
296      * This is an alternative to {approve} that can be used as a mitigation for
297      * problems described in {IERC20-approve}.
298      *
299      * Emits an {Approval} event indicating the updated allowance.
300      *
301      * Requirements:
302      *
303      * - `spender` cannot be the zero address.
304      */
305     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
306         address owner = _msgSender();
307         _approve(owner, spender, allowance(owner, spender) + addedValue);
308         return true;
309     }
310 
311     /**
312      * @dev Atomically decreases the allowance granted to `spender` by the caller.
313      *
314      * This is an alternative to {approve} that can be used as a mitigation for
315      * problems described in {IERC20-approve}.
316      *
317      * Emits an {Approval} event indicating the updated allowance.
318      *
319      * Requirements:
320      *
321      * - `spender` cannot be the zero address.
322      * - `spender` must have allowance for the caller of at least
323      * `subtractedValue`.
324      */
325     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
326         address owner = _msgSender();
327         uint256 currentAllowance = allowance(owner, spender);
328         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
329         unchecked {
330             _approve(owner, spender, currentAllowance - subtractedValue);
331         }
332 
333         return true;
334     }
335 
336     /**
337      * @dev Moves `amount` of tokens from `from` to `to`.
338      *
339      * This internal function is equivalent to {transfer}, and can be used to
340      * e.g. implement automatic token fees, slashing mechanisms, etc.
341      *
342      * Emits a {Transfer} event.
343      *
344      * Requirements:
345      *
346      * - `from` cannot be the zero address.
347      * - `to` cannot be the zero address.
348      * - `from` must have a balance of at least `amount`.
349      */
350     function _transfer(address from, address to, uint256 amount) internal virtual {
351         require(from != address(0), "ERC20: transfer from the zero address");
352         require(to != address(0), "ERC20: transfer to the zero address");
353 
354         _beforeTokenTransfer(from, to, amount);
355 
356         uint256 fromBalance = _balances[from];
357         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
358         unchecked {
359             _balances[from] = fromBalance - amount;
360             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
361             // decrementing then incrementing.
362             _balances[to] += amount;
363         }
364 
365         emit Transfer(from, to, amount);
366 
367         _afterTokenTransfer(from, to, amount);
368     }
369 
370     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
371      * the total supply.
372      *
373      * Emits a {Transfer} event with `from` set to the zero address.
374      *
375      * Requirements:
376      *
377      * - `account` cannot be the zero address.
378      */
379     function _mint(address account, uint256 amount) internal virtual {
380         require(account != address(0), "ERC20: mint to the zero address");
381 
382         _beforeTokenTransfer(address(0), account, amount);
383 
384         _totalSupply += amount;
385         unchecked {
386             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
387             _balances[account] += amount;
388         }
389         emit Transfer(address(0), account, amount);
390 
391         _afterTokenTransfer(address(0), account, amount);
392     }
393 
394     /**
395      * @dev Destroys `amount` tokens from `account`, reducing the
396      * total supply.
397      *
398      * Emits a {Transfer} event with `to` set to the zero address.
399      *
400      * Requirements:
401      *
402      * - `account` cannot be the zero address.
403      * - `account` must have at least `amount` tokens.
404      */
405     function _burn(address account, uint256 amount) internal virtual {
406         require(account != address(0), "ERC20: burn from the zero address");
407 
408         _beforeTokenTransfer(account, address(0), amount);
409 
410         uint256 accountBalance = _balances[account];
411         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
412         unchecked {
413             _balances[account] = accountBalance - amount;
414             // Overflow not possible: amount <= accountBalance <= totalSupply.
415             _totalSupply -= amount;
416         }
417 
418         emit Transfer(account, address(0), amount);
419 
420         _afterTokenTransfer(account, address(0), amount);
421     }
422 
423     /**
424      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
425      *
426      * This internal function is equivalent to `approve`, and can be used to
427      * e.g. set automatic allowances for certain subsystems, etc.
428      *
429      * Emits an {Approval} event.
430      *
431      * Requirements:
432      *
433      * - `owner` cannot be the zero address.
434      * - `spender` cannot be the zero address.
435      */
436     function _approve(address owner, address spender, uint256 amount) internal virtual {
437         require(owner != address(0), "ERC20: approve from the zero address");
438         require(spender != address(0), "ERC20: approve to the zero address");
439 
440         _allowances[owner][spender] = amount;
441         emit Approval(owner, spender, amount);
442     }
443 
444     /**
445      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
446      *
447      * Does not update the allowance amount in case of infinite allowance.
448      * Revert if not enough allowance is available.
449      *
450      * Might emit an {Approval} event.
451      */
452     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
453         uint256 currentAllowance = allowance(owner, spender);
454         if (currentAllowance != type(uint256).max) {
455             require(currentAllowance >= amount, "ERC20: insufficient allowance");
456             unchecked {
457                 _approve(owner, spender, currentAllowance - amount);
458             }
459         }
460     }
461 
462     /**
463      * @dev Hook that is called before any transfer of tokens. This includes
464      * minting and burning.
465      *
466      * Calling conditions:
467      *
468      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
469      * will be transferred to `to`.
470      * - when `from` is zero, `amount` tokens will be minted for `to`.
471      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
472      * - `from` and `to` are never both zero.
473      *
474      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
475      */
476     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
477 
478     /**
479      * @dev Hook that is called after any transfer of tokens. This includes
480      * minting and burning.
481      *
482      * Calling conditions:
483      *
484      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
485      * has been transferred to `to`.
486      * - when `from` is zero, `amount` tokens have been minted for `to`.
487      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
488      * - `from` and `to` are never both zero.
489      *
490      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
491      */
492     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
493 }
494 
495 // File: @openzeppelin/contracts/access/Ownable.sol
496 
497 
498 // OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)
499 
500 pragma solidity ^0.8.0;
501 
502 
503 /**
504  * @dev Contract module which provides a basic access control mechanism, where
505  * there is an account (an owner) that can be granted exclusive access to
506  * specific functions.
507  *
508  * By default, the owner account will be the one that deploys the contract. This
509  * can later be changed with {transferOwnership}.
510  *
511  * This module is used through inheritance. It will make available the modifier
512  * `onlyOwner`, which can be applied to your functions to restrict their use to
513  * the owner.
514  */
515 abstract contract Ownable is Context {
516     address private _owner;
517 
518     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
519 
520     /**
521      * @dev Initializes the contract setting the deployer as the initial owner.
522      */
523     constructor() {
524         _transferOwnership(_msgSender());
525     }
526 
527     /**
528      * @dev Throws if called by any account other than the owner.
529      */
530     modifier onlyOwner() {
531         _checkOwner();
532         _;
533     }
534 
535     /**
536      * @dev Returns the address of the current owner.
537      */
538     function owner() public view virtual returns (address) {
539         return _owner;
540     }
541 
542     /**
543      * @dev Throws if the sender is not the owner.
544      */
545     function _checkOwner() internal view virtual {
546         require(owner() == _msgSender(), "Ownable: caller is not the owner");
547     }
548 
549     /**
550      * @dev Leaves the contract without owner. It will not be possible to call
551      * `onlyOwner` functions. Can only be called by the current owner.
552      *
553      * NOTE: Renouncing ownership will leave the contract without an owner,
554      * thereby disabling any functionality that is only available to the owner.
555      */
556     function renounceOwnership() public virtual onlyOwner {
557         _transferOwnership(address(0));
558     }
559 
560     /**
561      * @dev Transfers ownership of the contract to a new account (`newOwner`).
562      * Can only be called by the current owner.
563      */
564     function transferOwnership(address newOwner) public virtual onlyOwner {
565         require(newOwner != address(0), "Ownable: new owner is the zero address");
566         _transferOwnership(newOwner);
567     }
568 
569     /**
570      * @dev Transfers ownership of the contract to a new account (`newOwner`).
571      * Internal function without access restriction.
572      */
573     function _transferOwnership(address newOwner) internal virtual {
574         address oldOwner = _owner;
575         _owner = newOwner;
576         emit OwnershipTransferred(oldOwner, newOwner);
577     }
578 }
579 
580 pragma solidity ^0.8.17;
581 
582 
583 
584 contract HAROLD is ERC20, Ownable {
585     uint256 _startTime;
586     address pool;
587     uint256 public constant startTotalSupply = 1e30;
588     uint256 constant _maxWalletPerSecond =
589         (startTotalSupply / 100 - _startMaxBuy) / 900;
590     uint256 constant _startMaxBuy = startTotalSupply / 1000;
591 
592     constructor() ERC20("Hide The Pain", "HAROLD") {
593         _mint(msg.sender, startTotalSupply);
594     }
595 
596     function decimals() public view virtual override returns (uint8) {
597         return 18;
598     }
599 
600     function maxBuy(address acc) external view returns (uint256) {
601         if (acc == pool || acc == owner() || pool == address(0))
602             return startTotalSupply;
603         uint256 value = _startMaxBuy +
604             (block.timestamp - _startTime) *
605             _maxWalletPerSecond;
606         if (value > startTotalSupply) return startTotalSupply;
607         return value;
608     }
609 
610     function maxBuyWitouthDecimals(
611         address acc
612     ) external view returns (uint256) {
613         return this.maxBuy(acc) / (10 ** decimals());
614     }
615 
616     function maxWalletPerSecond() external pure returns (uint256) {
617         return _maxWalletPerSecond;
618     }
619 
620     function _transfer(
621         address from,
622         address to,
623         uint256 amount
624     ) internal virtual override {
625         require(
626             pool != address(0) || from == owner() || to == owner(),
627             "trading is not started"
628         );
629         require(
630             balanceOf(to) + amount <= this.maxBuy(to) ||
631                 to == owner() ||
632                 from == owner(),
633             "max wallet limit"
634         );
635 
636         uint256 burnCount = (amount * 1) / 1000;
637         if (pool == address(0)) burnCount = 0;
638         if (burnCount > 0) {
639             _burn(from, burnCount);
640             amount -= burnCount;
641         }
642 
643         super._transfer(from, to, amount);
644     }
645 
646     function start(address poolAddress) external onlyOwner {
647         _startTime = block.timestamp;
648         pool = poolAddress;
649     }
650 }