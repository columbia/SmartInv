1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)
3 
4 pragma solidity ^0.8.0;
5 
6 /*
7 
8 ██████╗ ██╗   ██╗ ██████╗ ██████╗ 
9 ██╔══██╗╚██╗ ██╔╝██╔═══██╗██╔══██╗
10 ██║  ██║ ╚████╔╝ ██║   ██║██████╔╝
11 ██║  ██║  ╚██╔╝  ██║   ██║██╔══██╗
12 ██████╔╝   ██║   ╚██████╔╝██║  ██║
13 ╚═════╝    ╚═╝    ╚═════╝ ╚═╝  ╚═╝
14 
15 https://everyoneDYOR.com
16 https://t.me/everyoneDYOR
17 https://twitter.com/everyoneDYOR
18 */
19 
20 /**
21  * @dev Interface of the ERC20 standard as defined in the EIP.
22  */
23 interface IERC20 {
24     /**
25      * @dev Emitted when `value` tokens are moved from one account (`from`) to
26      * another (`to`).
27      *
28      * Note that `value` may be zero.
29      */
30     event Transfer(address indexed from, address indexed to, uint256 value);
31 
32     /**
33      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
34      * a call to {approve}. `value` is the new allowance.
35      */
36     event Approval(address indexed owner, address indexed spender, uint256 value);
37 
38     /**
39      * @dev Returns the amount of tokens in existence.
40      */
41     function totalSupply() external view returns (uint256);
42 
43     /**
44      * @dev Returns the amount of tokens owned by `account`.
45      */
46     function balanceOf(address account) external view returns (uint256);
47 
48     /**
49      * @dev Moves `amount` tokens from the caller's account to `to`.
50      *
51      * Returns a boolean value indicating whether the operation succeeded.
52      *
53      * Emits a {Transfer} event.
54      */
55     function transfer(address to, uint256 amount) external returns (bool);
56 
57     /**
58      * @dev Returns the remaining number of tokens that `spender` will be
59      * allowed to spend on behalf of `owner` through {transferFrom}. This is
60      * zero by default.
61      *
62      * This value changes when {approve} or {transferFrom} are called.
63      */
64     function allowance(address owner, address spender) external view returns (uint256);
65 
66     /**
67      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
68      *
69      * Returns a boolean value indicating whether the operation succeeded.
70      *
71      * IMPORTANT: Beware that changing an allowance with this method brings the risk
72      * that someone may use both the old and the new allowance by unfortunate
73      * transaction ordering. One possible solution to mitigate this race
74      * condition is to first reduce the spender's allowance to 0 and set the
75      * desired value afterwards:
76      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
77      *
78      * Emits an {Approval} event.
79      */
80     function approve(address spender, uint256 amount) external returns (bool);
81 
82     /**
83      * @dev Moves `amount` tokens from `from` to `to` using the
84      * allowance mechanism. `amount` is then deducted from the caller's
85      * allowance.
86      *
87      * Returns a boolean value indicating whether the operation succeeded.
88      *
89      * Emits a {Transfer} event.
90      */
91     function transferFrom(address from, address to, uint256 amount) external returns (bool);
92 }
93 
94 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
95 
96 pragma solidity ^0.8.0;
97 
98 /**
99  * @dev Interface for the optional metadata functions from the ERC20 standard.
100  *
101  * _Available since v4.1._
102  */
103 interface IERC20Metadata is IERC20 {
104     /**
105      * @dev Returns the name of the token.
106      */
107     function name() external view returns (string memory);
108 
109     /**
110      * @dev Returns the symbol of the token.
111      */
112     function symbol() external view returns (string memory);
113 
114     /**
115      * @dev Returns the decimals places of the token.
116      */
117     function decimals() external view returns (uint8);
118 }
119 
120 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
121 
122 pragma solidity ^0.8.0;
123 
124 /**
125  * @dev Provides information about the current execution context, including the
126  * sender of the transaction and its data. While these are generally available
127  * via msg.sender and msg.data, they should not be accessed in such a direct
128  * manner, since when dealing with meta-transactions the account sending and
129  * paying for execution may not be the actual sender (as far as an application
130  * is concerned).
131  *
132  * This contract is only required for intermediate, library-like contracts.
133  */
134 abstract contract Context {
135     function _msgSender() internal view virtual returns (address) {
136         return msg.sender;
137     }
138 
139     function _msgData() internal view virtual returns (bytes calldata) {
140         return msg.data;
141     }
142 }
143 
144 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/ERC20.sol)
145 
146 pragma solidity ^0.8.0;
147 
148 /**
149  * @dev Implementation of the {IERC20} interface.
150  *
151  * This implementation is agnostic to the way tokens are created. This means
152  * that a supply mechanism has to be added in a derived contract using {_mint}.
153  * For a generic mechanism see {ERC20PresetMinterPauser}.
154  *
155  * TIP: For a detailed writeup see our guide
156  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
157  * to implement supply mechanisms].
158  *
159  * The default value of {decimals} is 18. To change this, you should override
160  * this function so it returns a different value.
161  *
162  * We have followed general OpenZeppelin Contracts guidelines: functions revert
163  * instead returning `false` on failure. This behavior is nonetheless
164  * conventional and does not conflict with the expectations of ERC20
165  * applications.
166  *
167  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
168  * This allows applications to reconstruct the allowance for all accounts just
169  * by listening to said events. Other implementations of the EIP may not emit
170  * these events, as it isn't required by the specification.
171  *
172  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
173  * functions have been added to mitigate the well-known issues around setting
174  * allowances. See {IERC20-approve}.
175  */
176 contract ERC20 is Context, IERC20, IERC20Metadata {
177     mapping(address => uint256) private _balances;
178 
179     mapping(address => mapping(address => uint256)) private _allowances;
180 
181     uint256 private _totalSupply;
182 
183     string private _name;
184     string private _symbol;
185 
186     /**
187      * @dev Sets the values for {name} and {symbol}.
188      *
189      * All two of these values are immutable: they can only be set once during
190      * construction.
191      */
192     constructor(string memory name_, string memory symbol_) {
193         _name = name_;
194         _symbol = symbol_;
195     }
196 
197     /**
198      * @dev Returns the name of the token.
199      */
200     function name() public view virtual override returns (string memory) {
201         return _name;
202     }
203 
204     /**
205      * @dev Returns the symbol of the token, usually a shorter version of the
206      * name.
207      */
208     function symbol() public view virtual override returns (string memory) {
209         return _symbol;
210     }
211 
212     /**
213      * @dev Returns the number of decimals used to get its user representation.
214      * For example, if `decimals` equals `2`, a balance of `505` tokens should
215      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
216      *
217      * Tokens usually opt for a value of 18, imitating the relationship between
218      * Ether and Wei. This is the default value returned by this function, unless
219      * it's overridden.
220      *
221      * NOTE: This information is only used for _display_ purposes: it in
222      * no way affects any of the arithmetic of the contract, including
223      * {IERC20-balanceOf} and {IERC20-transfer}.
224      */
225     function decimals() public view virtual override returns (uint8) {
226         return 18;
227     }
228 
229     /**
230      * @dev See {IERC20-totalSupply}.
231      */
232     function totalSupply() public view virtual override returns (uint256) {
233         return _totalSupply;
234     }
235 
236     /**
237      * @dev See {IERC20-balanceOf}.
238      */
239     function balanceOf(address account) public view virtual override returns (uint256) {
240         return _balances[account];
241     }
242 
243     /**
244      * @dev See {IERC20-transfer}.
245      *
246      * Requirements:
247      *
248      * - `to` cannot be the zero address.
249      * - the caller must have a balance of at least `amount`.
250      */
251     function transfer(address to, uint256 amount) public virtual override returns (bool) {
252         address owner = _msgSender();
253         _transfer(owner, to, amount);
254         return true;
255     }
256 
257     /**
258      * @dev See {IERC20-allowance}.
259      */
260     function allowance(address owner, address spender) public view virtual override returns (uint256) {
261         return _allowances[owner][spender];
262     }
263 
264     /**
265      * @dev See {IERC20-approve}.
266      *
267      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
268      * `transferFrom`. This is semantically equivalent to an infinite approval.
269      *
270      * Requirements:
271      *
272      * - `spender` cannot be the zero address.
273      */
274     function approve(address spender, uint256 amount) public virtual override returns (bool) {
275         address owner = _msgSender();
276         _approve(owner, spender, amount);
277         return true;
278     }
279 
280     /**
281      * @dev See {IERC20-transferFrom}.
282      *
283      * Emits an {Approval} event indicating the updated allowance. This is not
284      * required by the EIP. See the note at the beginning of {ERC20}.
285      *
286      * NOTE: Does not update the allowance if the current allowance
287      * is the maximum `uint256`.
288      *
289      * Requirements:
290      *
291      * - `from` and `to` cannot be the zero address.
292      * - `from` must have a balance of at least `amount`.
293      * - the caller must have allowance for ``from``'s tokens of at least
294      * `amount`.
295      */
296     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
297         address spender = _msgSender();
298         _spendAllowance(from, spender, amount);
299         _transfer(from, to, amount);
300         return true;
301     }
302 
303     /**
304      * @dev Atomically increases the allowance granted to `spender` by the caller.
305      *
306      * This is an alternative to {approve} that can be used as a mitigation for
307      * problems described in {IERC20-approve}.
308      *
309      * Emits an {Approval} event indicating the updated allowance.
310      *
311      * Requirements:
312      *
313      * - `spender` cannot be the zero address.
314      */
315     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
316         address owner = _msgSender();
317         _approve(owner, spender, allowance(owner, spender) + addedValue);
318         return true;
319     }
320 
321     /**
322      * @dev Atomically decreases the allowance granted to `spender` by the caller.
323      *
324      * This is an alternative to {approve} that can be used as a mitigation for
325      * problems described in {IERC20-approve}.
326      *
327      * Emits an {Approval} event indicating the updated allowance.
328      *
329      * Requirements:
330      *
331      * - `spender` cannot be the zero address.
332      * - `spender` must have allowance for the caller of at least
333      * `subtractedValue`.
334      */
335     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
336         address owner = _msgSender();
337         uint256 currentAllowance = allowance(owner, spender);
338         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
339         unchecked {
340             _approve(owner, spender, currentAllowance - subtractedValue);
341         }
342 
343         return true;
344     }
345 
346     /**
347      * @dev Moves `amount` of tokens from `from` to `to`.
348      *
349      * This internal function is equivalent to {transfer}, and can be used to
350      * e.g. implement automatic token fees, slashing mechanisms, etc.
351      *
352      * Emits a {Transfer} event.
353      *
354      * Requirements:
355      *
356      * - `from` cannot be the zero address.
357      * - `to` cannot be the zero address.
358      * - `from` must have a balance of at least `amount`.
359      */
360     function _transfer(address from, address to, uint256 amount) internal virtual {
361         require(from != address(0), "ERC20: transfer from the zero address");
362         require(to != address(0), "ERC20: transfer to the zero address");
363 
364         _beforeTokenTransfer(from, to, amount);
365 
366         uint256 fromBalance = _balances[from];
367         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
368         unchecked {
369             _balances[from] = fromBalance - amount;
370             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
371             // decrementing then incrementing.
372             _balances[to] += amount;
373         }
374 
375         emit Transfer(from, to, amount);
376 
377         _afterTokenTransfer(from, to, amount);
378     }
379 
380     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
381      * the total supply.
382      *
383      * Emits a {Transfer} event with `from` set to the zero address.
384      *
385      * Requirements:
386      *
387      * - `account` cannot be the zero address.
388      */
389     function _mint(address account, uint256 amount) internal virtual {
390         require(account != address(0), "ERC20: mint to the zero address");
391 
392         _beforeTokenTransfer(address(0), account, amount);
393 
394         _totalSupply += amount;
395         unchecked {
396             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
397             _balances[account] += amount;
398         }
399         emit Transfer(address(0), account, amount);
400 
401         _afterTokenTransfer(address(0), account, amount);
402     }
403 
404     /**
405      * @dev Destroys `amount` tokens from `account`, reducing the
406      * total supply.
407      *
408      * Emits a {Transfer} event with `to` set to the zero address.
409      *
410      * Requirements:
411      *
412      * - `account` cannot be the zero address.
413      * - `account` must have at least `amount` tokens.
414      */
415     function _burn(address account, uint256 amount) internal virtual {
416         require(account != address(0), "ERC20: burn from the zero address");
417 
418         _beforeTokenTransfer(account, address(0), amount);
419 
420         uint256 accountBalance = _balances[account];
421         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
422         unchecked {
423             _balances[account] = accountBalance - amount;
424             // Overflow not possible: amount <= accountBalance <= totalSupply.
425             _totalSupply -= amount;
426         }
427 
428         emit Transfer(account, address(0), amount);
429 
430         _afterTokenTransfer(account, address(0), amount);
431     }
432 
433     /**
434      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
435      *
436      * This internal function is equivalent to `approve`, and can be used to
437      * e.g. set automatic allowances for certain subsystems, etc.
438      *
439      * Emits an {Approval} event.
440      *
441      * Requirements:
442      *
443      * - `owner` cannot be the zero address.
444      * - `spender` cannot be the zero address.
445      */
446     function _approve(address owner, address spender, uint256 amount) internal virtual {
447         require(owner != address(0), "ERC20: approve from the zero address");
448         require(spender != address(0), "ERC20: approve to the zero address");
449 
450         _allowances[owner][spender] = amount;
451         emit Approval(owner, spender, amount);
452     }
453 
454     /**
455      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
456      *
457      * Does not update the allowance amount in case of infinite allowance.
458      * Revert if not enough allowance is available.
459      *
460      * Might emit an {Approval} event.
461      */
462     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
463         uint256 currentAllowance = allowance(owner, spender);
464         if (currentAllowance != type(uint256).max) {
465             require(currentAllowance >= amount, "ERC20: insufficient allowance");
466             unchecked {
467                 _approve(owner, spender, currentAllowance - amount);
468             }
469         }
470     }
471 
472     /**
473      * @dev Hook that is called before any transfer of tokens. This includes
474      * minting and burning.
475      *
476      * Calling conditions:
477      *
478      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
479      * will be transferred to `to`.
480      * - when `from` is zero, `amount` tokens will be minted for `to`.
481      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
482      * - `from` and `to` are never both zero.
483      *
484      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
485      */
486     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
487 
488     /**
489      * @dev Hook that is called after any transfer of tokens. This includes
490      * minting and burning.
491      *
492      * Calling conditions:
493      *
494      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
495      * has been transferred to `to`.
496      * - when `from` is zero, `amount` tokens have been minted for `to`.
497      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
498      * - `from` and `to` are never both zero.
499      *
500      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
501      */
502     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
503 }
504 
505 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
506 
507 pragma solidity ^0.8.0;
508 
509 /**
510  * @dev Contract module which provides a basic access control mechanism, where
511  * there is an account (an owner) that can be granted exclusive access to
512  * specific functions.
513  *
514  * By default, the owner account will be the one that deploys the contract. This
515  * can later be changed with {transferOwnership}.
516  *
517  * This module is used through inheritance. It will make available the modifier
518  * `onlyOwner`, which can be applied to your functions to restrict their use to
519  * the owner.
520  */
521 abstract contract Ownable is Context {
522     address private _owner;
523 
524     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
525 
526     /**
527      * @dev Initializes the contract setting the deployer as the initial owner.
528      */
529     constructor() {
530         _transferOwnership(_msgSender());
531     }
532 
533     /**
534      * @dev Throws if called by any account other than the owner.
535      */
536     modifier onlyOwner() {
537         _checkOwner();
538         _;
539     }
540 
541     /**
542      * @dev Returns the address of the current owner.
543      */
544     function owner() public view virtual returns (address) {
545         return _owner;
546     }
547 
548     /**
549      * @dev Throws if the sender is not the owner.
550      */
551     function _checkOwner() internal view virtual {
552         require(owner() == _msgSender(), "Ownable: caller is not the owner");
553     }
554 
555     /**
556      * @dev Leaves the contract without owner. It will not be possible to call
557      * `onlyOwner` functions anymore. Can only be called by the current owner.
558      *
559      * NOTE: Renouncing ownership will leave the contract without an owner,
560      * thereby removing any functionality that is only available to the owner.
561      */
562     function renounceOwnership() public virtual onlyOwner {
563         _transferOwnership(address(0));
564     }
565 
566     /**
567      * @dev Transfers ownership of the contract to a new account (`newOwner`).
568      * Can only be called by the current owner.
569      */
570     function transferOwnership(address newOwner) public virtual onlyOwner {
571         require(newOwner != address(0), "Ownable: new owner is the zero address");
572         _transferOwnership(newOwner);
573     }
574 
575     /**
576      * @dev Transfers ownership of the contract to a new account (`newOwner`).
577      * Internal function without access restriction.
578      */
579     function _transferOwnership(address newOwner) internal virtual {
580         address oldOwner = _owner;
581         _owner = newOwner;
582         emit OwnershipTransferred(oldOwner, newOwner);
583     }
584 }
585 
586 contract DYOR is Ownable, ERC20 {
587     bool public limited;
588     uint256 public constant INITIAL_SUPPLY = 100_000_000_000 * 10**18;
589     uint8 public maxBuy;
590     uint8 public buyTax;
591     uint8 public sellTax;
592     address public uniswapV2Pair;
593     address private feesWallet;
594 
595     constructor() ERC20("DYOR", "DYOR") {
596         _mint(msg.sender, INITIAL_SUPPLY);
597         feesWallet = msg.sender;
598     }
599 
600     function setRule(bool _limited, address _uniswapV2Pair, uint8 _buyTax, uint8 _sellTax, uint8 _maxBuy) external onlyOwner {
601         limited = _limited;
602         uniswapV2Pair = _uniswapV2Pair;
603         buyTax = _buyTax;
604         sellTax = _sellTax;
605         maxBuy = _maxBuy;
606     }
607 
608     function setMaxBuy(uint8 newMaxBuy) external onlyOwner() {
609         maxBuy = newMaxBuy;
610     }
611 
612     function setFees(uint8 newBuy, uint8 newSell) external onlyOwner {
613         buyTax = newBuy;
614         sellTax = newSell;
615     }
616 
617     function setFeesWallet(address wallet) external onlyOwner {
618         feesWallet = wallet;
619     }
620 
621     function _beforeTokenTransfer(
622         address from,
623         address to,
624         uint256 amount
625     ) internal virtual override {
626         if (uniswapV2Pair == address(0)) {
627             require(
628                 from == owner() ||
629                     to == owner() ||
630                     msg.sender == owner() ||
631                     tx.origin == owner(),
632                 "Trading is not started"
633             );
634             return;
635         }
636         if (limited && from == uniswapV2Pair) {
637             require(
638                 super.balanceOf(to) + amount <= (maxBuy * INITIAL_SUPPLY) / 100,
639                 "Forbidden"
640             );
641         }
642     }
643 
644     function _transfer(
645         address from,
646         address to,
647         uint256 amount
648     ) internal virtual override {
649         if (limited) {
650             if (from == uniswapV2Pair) {
651                 transferWithFees(from, to, amount, buyTax);
652             } else if (to == uniswapV2Pair) {
653                 transferWithFees(from, to, amount, sellTax);
654             } else {
655             super._transfer(from, to, amount);
656             }
657         } else {
658             super._transfer(from, to, amount);
659         }
660     }
661 
662     function transferWithFees(
663         address from,
664         address to,
665         uint256 amount,
666         uint8 percentage
667     ) internal {
668         uint256 tax = (amount * percentage) / 100;
669         uint256 netAmount = amount - tax;
670         super._transfer(from, to, netAmount);
671         super._transfer(from, feesWallet, tax);
672     }
673 }