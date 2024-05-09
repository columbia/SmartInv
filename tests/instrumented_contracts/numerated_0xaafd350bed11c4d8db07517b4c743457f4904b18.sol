1 //    __    _____  __   
2 //   /__\  (  _  )(  )  
3 //  /(__)\  )(_)(  )(__ 
4 // (__)(__)(_____)(____)
5 // https://aolcoin.xyz/
6 // https://twitter.com/aolcoin
7 // https://t.co/MwNyKcButP
8 
9 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
10 
11 pragma solidity ^0.8.0;
12 
13 /**
14  * @dev Interface of the ERC20 standard as defined in the EIP.
15  */
16 interface IERC20 {
17     /**
18      * @dev Emitted when `value` tokens are moved from one account (`from`) to
19      * another (`to`).
20      *
21      * Note that `value` may be zero.
22      */
23     event Transfer(address indexed from, address indexed to, uint256 value);
24 
25     /**
26      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
27      * a call to {approve}. `value` is the new allowance.
28      */
29     event Approval(address indexed owner, address indexed spender, uint256 value);
30 
31     /**
32      * @dev Returns the amount of tokens in existence.
33      */
34     function totalSupply() external view returns (uint256);
35 
36     /**
37      * @dev Returns the amount of tokens owned by `account`.
38      */
39     function balanceOf(address account) external view returns (uint256);
40 
41     /**
42      * @dev Moves `amount` tokens from the caller's account to `to`.
43      *
44      * Returns a boolean value indicating whether the operation succeeded.
45      *
46      * Emits a {Transfer} event.
47      */
48     function transfer(address to, uint256 amount) external returns (bool);
49 
50     /**
51      * @dev Returns the remaining number of tokens that `spender` will be
52      * allowed to spend on behalf of `owner` through {transferFrom}. This is
53      * zero by default.
54      *
55      * This value changes when {approve} or {transferFrom} are called.
56      */
57     function allowance(address owner, address spender) external view returns (uint256);
58 
59     /**
60      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
61      *
62      * Returns a boolean value indicating whether the operation succeeded.
63      *
64      * IMPORTANT: Beware that changing an allowance with this method brings the risk
65      * that someone may use both the old and the new allowance by unfortunate
66      * transaction ordering. One possible solution to mitigate this race
67      * condition is to first reduce the spender's allowance to 0 and set the
68      * desired value afterwards:
69      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
70      *
71      * Emits an {Approval} event.
72      */
73     function approve(address spender, uint256 amount) external returns (bool);
74 
75     /**
76      * @dev Moves `amount` tokens from `from` to `to` using the
77      * allowance mechanism. `amount` is then deducted from the caller's
78      * allowance.
79      *
80      * Returns a boolean value indicating whether the operation succeeded.
81      *
82      * Emits a {Transfer} event.
83      */
84     function transferFrom(
85         address from,
86         address to,
87         uint256 amount
88     ) external returns (bool);
89 }
90 
91 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
92 
93 
94 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
95 
96 pragma solidity ^0.8.0;
97 
98 
99 /**
100  * @dev Interface for the optional metadata functions from the ERC20 standard.
101  *
102  * _Available since v4.1._
103  */
104 interface IERC20Metadata is IERC20 {
105     /**
106      * @dev Returns the name of the token.
107      */
108     function name() external view returns (string memory);
109 
110     /**
111      * @dev Returns the symbol of the token.
112      */
113     function symbol() external view returns (string memory);
114 
115     /**
116      * @dev Returns the decimals places of the token.
117      */
118     function decimals() external view returns (uint8);
119 }
120 
121 // File: @openzeppelin/contracts/utils/Context.sol
122 
123 
124 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
125 
126 pragma solidity ^0.8.0;
127 
128 /**
129  * @dev Provides information about the current execution context, including the
130  * sender of the transaction and its data. While these are generally available
131  * via msg.sender and msg.data, they should not be accessed in such a direct
132  * manner, since when dealing with meta-transactions the account sending and
133  * paying for execution may not be the actual sender (as far as an application
134  * is concerned).
135  *
136  * This contract is only required for intermediate, library-like contracts.
137  */
138 abstract contract Context {
139     function _msgSender() internal view virtual returns (address) {
140         return msg.sender;
141     }
142 
143     function _msgData() internal view virtual returns (bytes calldata) {
144         return msg.data;
145     }
146 }
147 
148 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
149 
150 
151 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
152 
153 pragma solidity ^0.8.0;
154 
155 
156 
157 
158 /**
159  * @dev Implementation of the {IERC20} interface.
160  *
161  * This implementation is agnostic to the way tokens are created. This means
162  * that a supply mechanism has to be added in a derived contract using {_mint}.
163  * For a generic mechanism see {ERC20PresetMinterPauser}.
164  *
165  * TIP: For a detailed writeup see our guide
166  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
167  * to implement supply mechanisms].
168  *
169  * We have followed general OpenZeppelin Contracts guidelines: functions revert
170  * instead returning `false` on failure. This behavior is nonetheless
171  * conventional and does not conflict with the expectations of ERC20
172  * applications.
173  *
174  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
175  * This allows applications to reconstruct the allowance for all accounts just
176  * by listening to said events. Other implementations of the EIP may not emit
177  * these events, as it isn't required by the specification.
178  *
179  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
180  * functions have been added to mitigate the well-known issues around setting
181  * allowances. See {IERC20-approve}.
182  */
183 contract ERC20 is Context, IERC20, IERC20Metadata {
184     mapping(address => uint256) private _balances;
185 
186     mapping(address => mapping(address => uint256)) private _allowances;
187 
188     uint256 private _totalSupply;
189 
190     string private _name;
191     string private _symbol;
192 
193     /**
194      * @dev Sets the values for {name} and {symbol}.
195      *
196      * The default value of {decimals} is 18. To select a different value for
197      * {decimals} you should overload it.
198      *
199      * All two of these values are immutable: they can only be set once during
200      * construction.
201      */
202     constructor(string memory name_, string memory symbol_) {
203         _name = name_;
204         _symbol = symbol_;
205     }
206 
207     /**
208      * @dev Returns the name of the token.
209      */
210     function name() public view virtual override returns (string memory) {
211         return _name;
212     }
213 
214     /**
215      * @dev Returns the symbol of the token, usually a shorter version of the
216      * name.
217      */
218     function symbol() public view virtual override returns (string memory) {
219         return _symbol;
220     }
221 
222     /**
223      * @dev Returns the number of decimals used to get its user representation.
224      * For example, if `decimals` equals `2`, a balance of `505` tokens should
225      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
226      *
227      * Tokens usually opt for a value of 18, imitating the relationship between
228      * Ether and Wei. This is the value {ERC20} uses, unless this function is
229      * overridden;
230      *
231      * NOTE: This information is only used for _display_ purposes: it in
232      * no way affects any of the arithmetic of the contract, including
233      * {IERC20-balanceOf} and {IERC20-transfer}.
234      */
235     function decimals() public view virtual override returns (uint8) {
236         return 18;
237     }
238 
239     /**
240      * @dev See {IERC20-totalSupply}.
241      */
242     function totalSupply() public view virtual override returns (uint256) {
243         return _totalSupply;
244     }
245 
246     /**
247      * @dev See {IERC20-balanceOf}.
248      */
249     function balanceOf(address account) public view virtual override returns (uint256) {
250         return _balances[account];
251     }
252 
253     /**
254      * @dev See {IERC20-transfer}.
255      *
256      * Requirements:
257      *
258      * - `to` cannot be the zero address.
259      * - the caller must have a balance of at least `amount`.
260      */
261     function transfer(address to, uint256 amount) public virtual override returns (bool) {
262         address owner = _msgSender();
263         _transfer(owner, to, amount);
264         return true;
265     }
266 
267     /**
268      * @dev See {IERC20-allowance}.
269      */
270     function allowance(address owner, address spender) public view virtual override returns (uint256) {
271         return _allowances[owner][spender];
272     }
273 
274     /**
275      * @dev See {IERC20-approve}.
276      *
277      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
278      * `transferFrom`. This is semantically equivalent to an infinite approval.
279      *
280      * Requirements:
281      *
282      * - `spender` cannot be the zero address.
283      */
284     function approve(address spender, uint256 amount) public virtual override returns (bool) {
285         address owner = _msgSender();
286         _approve(owner, spender, amount);
287         return true;
288     }
289 
290     /**
291      * @dev See {IERC20-transferFrom}.
292      *
293      * Emits an {Approval} event indicating the updated allowance. This is not
294      * required by the EIP. See the note at the beginning of {ERC20}.
295      *
296      * NOTE: Does not update the allowance if the current allowance
297      * is the maximum `uint256`.
298      *
299      * Requirements:
300      *
301      * - `from` and `to` cannot be the zero address.
302      * - `from` must have a balance of at least `amount`.
303      * - the caller must have allowance for ``from``'s tokens of at least
304      * `amount`.
305      */
306     function transferFrom(
307         address from,
308         address to,
309         uint256 amount
310     ) public virtual override returns (bool) {
311         address spender = _msgSender();
312         _spendAllowance(from, spender, amount);
313         _transfer(from, to, amount);
314         return true;
315     }
316 
317     /**
318      * @dev Atomically increases the allowance granted to `spender` by the caller.
319      *
320      * This is an alternative to {approve} that can be used as a mitigation for
321      * problems described in {IERC20-approve}.
322      *
323      * Emits an {Approval} event indicating the updated allowance.
324      *
325      * Requirements:
326      *
327      * - `spender` cannot be the zero address.
328      */
329     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
330         address owner = _msgSender();
331         _approve(owner, spender, allowance(owner, spender) + addedValue);
332         return true;
333     }
334 
335     /**
336      * @dev Atomically decreases the allowance granted to `spender` by the caller.
337      *
338      * This is an alternative to {approve} that can be used as a mitigation for
339      * problems described in {IERC20-approve}.
340      *
341      * Emits an {Approval} event indicating the updated allowance.
342      *
343      * Requirements:
344      *
345      * - `spender` cannot be the zero address.
346      * - `spender` must have allowance for the caller of at least
347      * `subtractedValue`.
348      */
349     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
350         address owner = _msgSender();
351         uint256 currentAllowance = allowance(owner, spender);
352         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
353         unchecked {
354             _approve(owner, spender, currentAllowance - subtractedValue);
355         }
356 
357         return true;
358     }
359 
360     /**
361      * @dev Moves `amount` of tokens from `from` to `to`.
362      *
363      * This internal function is equivalent to {transfer}, and can be used to
364      * e.g. implement automatic token fees, slashing mechanisms, etc.
365      *
366      * Emits a {Transfer} event.
367      *
368      * Requirements:
369      *
370      * - `from` cannot be the zero address.
371      * - `to` cannot be the zero address.
372      * - `from` must have a balance of at least `amount`.
373      */
374     function _transfer(
375         address from,
376         address to,
377         uint256 amount
378     ) internal virtual {
379         require(from != address(0), "ERC20: transfer from the zero address");
380         require(to != address(0), "ERC20: transfer to the zero address");
381 
382         _beforeTokenTransfer(from, to, amount);
383 
384         uint256 fromBalance = _balances[from];
385         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
386         unchecked {
387             _balances[from] = fromBalance - amount;
388             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
389             // decrementing then incrementing.
390             _balances[to] += amount;
391         }
392 
393         emit Transfer(from, to, amount);
394 
395         _afterTokenTransfer(from, to, amount);
396     }
397 
398     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
399      * the total supply.
400      *
401      * Emits a {Transfer} event with `from` set to the zero address.
402      *
403      * Requirements:
404      *
405      * - `account` cannot be the zero address.
406      */
407     function _mint(address account, uint256 amount) internal virtual {
408         require(account != address(0), "ERC20: mint to the zero address");
409 
410         _beforeTokenTransfer(address(0), account, amount);
411 
412         _totalSupply += amount;
413         unchecked {
414             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
415             _balances[account] += amount;
416         }
417         emit Transfer(address(0), account, amount);
418 
419         _afterTokenTransfer(address(0), account, amount);
420     }
421 
422     /**
423      * @dev Destroys `amount` tokens from `account`, reducing the
424      * total supply.
425      *
426      * Emits a {Transfer} event with `to` set to the zero address.
427      *
428      * Requirements:
429      *
430      * - `account` cannot be the zero address.
431      * - `account` must have at least `amount` tokens.
432      */
433     function _burn(address account, uint256 amount) internal virtual {
434         require(account != address(0), "ERC20: burn from the zero address");
435 
436         _beforeTokenTransfer(account, address(0), amount);
437 
438         uint256 accountBalance = _balances[account];
439         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
440         unchecked {
441             _balances[account] = accountBalance - amount;
442             // Overflow not possible: amount <= accountBalance <= totalSupply.
443             _totalSupply -= amount;
444         }
445 
446         emit Transfer(account, address(0), amount);
447 
448         _afterTokenTransfer(account, address(0), amount);
449     }
450 
451     /**
452      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
453      *
454      * This internal function is equivalent to `approve`, and can be used to
455      * e.g. set automatic allowances for certain subsystems, etc.
456      *
457      * Emits an {Approval} event.
458      *
459      * Requirements:
460      *
461      * - `owner` cannot be the zero address.
462      * - `spender` cannot be the zero address.
463      */
464     function _approve(
465         address owner,
466         address spender,
467         uint256 amount
468     ) internal virtual {
469         require(owner != address(0), "ERC20: approve from the zero address");
470         require(spender != address(0), "ERC20: approve to the zero address");
471 
472         _allowances[owner][spender] = amount;
473         emit Approval(owner, spender, amount);
474     }
475 
476     /**
477      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
478      *
479      * Does not update the allowance amount in case of infinite allowance.
480      * Revert if not enough allowance is available.
481      *
482      * Might emit an {Approval} event.
483      */
484     function _spendAllowance(
485         address owner,
486         address spender,
487         uint256 amount
488     ) internal virtual {
489         uint256 currentAllowance = allowance(owner, spender);
490         if (currentAllowance != type(uint256).max) {
491             require(currentAllowance >= amount, "ERC20: insufficient allowance");
492             unchecked {
493                 _approve(owner, spender, currentAllowance - amount);
494             }
495         }
496     }
497 
498     /**
499      * @dev Hook that is called before any transfer of tokens. This includes
500      * minting and burning.
501      *
502      * Calling conditions:
503      *
504      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
505      * will be transferred to `to`.
506      * - when `from` is zero, `amount` tokens will be minted for `to`.
507      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
508      * - `from` and `to` are never both zero.
509      *
510      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
511      */
512     function _beforeTokenTransfer(
513         address from,
514         address to,
515         uint256 amount
516     ) internal virtual {}
517 
518     /**
519      * @dev Hook that is called after any transfer of tokens. This includes
520      * minting and burning.
521      *
522      * Calling conditions:
523      *
524      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
525      * has been transferred to `to`.
526      * - when `from` is zero, `amount` tokens have been minted for `to`.
527      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
528      * - `from` and `to` are never both zero.
529      *
530      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
531      */
532     function _afterTokenTransfer(
533         address from,
534         address to,
535         uint256 amount
536     ) internal virtual {}
537 }
538 
539 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol
540 
541 
542 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/extensions/ERC20Burnable.sol)
543 
544 pragma solidity ^0.8.0;
545 
546 
547 
548 /**
549  * @dev Extension of {ERC20} that allows token holders to destroy both their own
550  * tokens and those that they have an allowance for, in a way that can be
551  * recognized off-chain (via event analysis).
552  */
553 abstract contract ERC20Burnable is Context, ERC20 {
554     /**
555      * @dev Destroys `amount` tokens from the caller.
556      *
557      * See {ERC20-_burn}.
558      */
559     function burn(uint256 amount) public virtual {
560         _burn(_msgSender(), amount);
561     }
562 
563     /**
564      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
565      * allowance.
566      *
567      * See {ERC20-_burn} and {ERC20-allowance}.
568      *
569      * Requirements:
570      *
571      * - the caller must have allowance for ``accounts``'s tokens of at least
572      * `amount`.
573      */
574     function burnFrom(address account, uint256 amount) public virtual {
575         _spendAllowance(account, _msgSender(), amount);
576         _burn(account, amount);
577     }
578 }
579 
580 // File: @openzeppelin/contracts/access/Ownable.sol
581 
582 
583 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
584 
585 pragma solidity ^0.8.0;
586 
587 
588 /**
589  * @dev Contract module which provides a basic access control mechanism, where
590  * there is an account (an owner) that can be granted exclusive access to
591  * specific functions.
592  *
593  * By default, the owner account will be the one that deploys the contract. This
594  * can later be changed with {transferOwnership}.
595  *
596  * This module is used through inheritance. It will make available the modifier
597  * `onlyOwner`, which can be applied to your functions to restrict their use to
598  * the owner.
599  */
600 abstract contract Ownable is Context {
601     address private _owner;
602 
603     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
604 
605     /**
606      * @dev Initializes the contract setting the deployer as the initial owner.
607      */
608     constructor() {
609         _transferOwnership(_msgSender());
610     }
611 
612     /**
613      * @dev Throws if called by any account other than the owner.
614      */
615     modifier onlyOwner() {
616         _checkOwner();
617         _;
618     }
619 
620     /**
621      * @dev Returns the address of the current owner.
622      */
623     function owner() public view virtual returns (address) {
624         return _owner;
625     }
626 
627     /**
628      * @dev Throws if the sender is not the owner.
629      */
630     function _checkOwner() internal view virtual {
631         require(owner() == _msgSender(), "Ownable: caller is not the owner");
632     }
633 
634     /**
635      * @dev Leaves the contract without owner. It will not be possible to call
636      * `onlyOwner` functions anymore. Can only be called by the current owner.
637      *
638      * NOTE: Renouncing ownership will leave the contract without an owner,
639      * thereby removing any functionality that is only available to the owner.
640      */
641     function renounceOwnership() public virtual onlyOwner {
642         _transferOwnership(address(0));
643     }
644 
645     /**
646      * @dev Transfers ownership of the contract to a new account (`newOwner`).
647      * Can only be called by the current owner.
648      */
649     function transferOwnership(address newOwner) public virtual onlyOwner {
650         require(newOwner != address(0), "Ownable: new owner is the zero address");
651         _transferOwnership(newOwner);
652     }
653 
654     /**
655      * @dev Transfers ownership of the contract to a new account (`newOwner`).
656      * Internal function without access restriction.
657      */
658     function _transferOwnership(address newOwner) internal virtual {
659         address oldOwner = _owner;
660         _owner = newOwner;
661         emit OwnershipTransferred(oldOwner, newOwner);
662     }
663 }
664 
665 // File: AOL.sol
666 
667 
668 
669 
670 
671 
672 pragma solidity ^0.8.0;
673 
674 contract AOLCoin is Ownable, ERC20 {
675     bool public limited;
676     uint256 public maxHoldingAmount;
677     uint256 public minHoldingAmount;
678     address public uniswapV2Pair;
679     mapping(address => bool) public blacklists;
680     
681     constructor() ERC20("AOLCoin", "AOL") {
682         _mint(msg.sender, 420690000000000000000000000000000);
683     }
684     
685     function blacklist(address _address, bool _isBlacklisting) external onlyOwner {
686         blacklists[_address] = _isBlacklisting;
687     }
688 
689     function setRule(bool _limited, address _uniswapV2Pair, uint256 _maxHoldingAmount, uint256 _minHoldingAmount) external onlyOwner {
690         limited = _limited;
691         uniswapV2Pair = _uniswapV2Pair;
692         maxHoldingAmount = _maxHoldingAmount;
693         minHoldingAmount = _minHoldingAmount;
694     }
695 
696     function _beforeTokenTransfer(
697         address from,
698         address to,
699         uint256 amount
700     ) override internal virtual {
701         require(!blacklists[to] && !blacklists[from], "Blacklisted");
702 
703         if (uniswapV2Pair == address(0)) {
704             require(from == owner() || to == owner(), "trading is not started");
705             return;
706         }
707 
708         if (limited && from == uniswapV2Pair) {
709             require(super.balanceOf(to) + amount <= maxHoldingAmount && super.balanceOf(to) + amount >= minHoldingAmount, "Forbid");
710         }
711     }
712 
713     function burn(uint256 value) external {
714         _burn(msg.sender, value);
715     }
716 }