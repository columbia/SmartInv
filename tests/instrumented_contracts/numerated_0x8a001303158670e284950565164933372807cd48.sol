1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 // SPDX-License-Identifier: MIT
4 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Interface of the ERC20 standard as defined in the EIP.
10  */
11 interface IERC20 {
12     /**
13      * @dev Emitted when `value` tokens are moved from one account (`from`) to
14      * another (`to`).
15      *
16      * Note that `value` may be zero.
17      */
18     event Transfer(address indexed from, address indexed to, uint256 value);
19 
20     /**
21      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
22      * a call to {approve}. `value` is the new allowance.
23      */
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 
26     /**
27      * @dev Returns the amount of tokens in existence.
28      */
29     function totalSupply() external view returns (uint256);
30 
31     /**
32      * @dev Returns the amount of tokens owned by `account`.
33      */
34     function balanceOf(address account) external view returns (uint256);
35 
36     /**
37      * @dev Moves `amount` tokens from the caller's account to `to`.
38      *
39      * Returns a boolean value indicating whether the operation succeeded.
40      *
41      * Emits a {Transfer} event.
42      */
43     function transfer(address to, uint256 amount) external returns (bool);
44 
45     /**
46      * @dev Returns the remaining number of tokens that `spender` will be
47      * allowed to spend on behalf of `owner` through {transferFrom}. This is
48      * zero by default.
49      *
50      * This value changes when {approve} or {transferFrom} are called.
51      */
52     function allowance(address owner, address spender) external view returns (uint256);
53 
54     /**
55      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * IMPORTANT: Beware that changing an allowance with this method brings the risk
60      * that someone may use both the old and the new allowance by unfortunate
61      * transaction ordering. One possible solution to mitigate this race
62      * condition is to first reduce the spender's allowance to 0 and set the
63      * desired value afterwards:
64      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
65      *
66      * Emits an {Approval} event.
67      */
68     function approve(address spender, uint256 amount) external returns (bool);
69 
70     /**
71      * @dev Moves `amount` tokens from `from` to `to` using the
72      * allowance mechanism. `amount` is then deducted from the caller's
73      * allowance.
74      *
75      * Returns a boolean value indicating whether the operation succeeded.
76      *
77      * Emits a {Transfer} event.
78      */
79     function transferFrom(
80         address from,
81         address to,
82         uint256 amount
83     ) external returns (bool);
84 }
85 
86 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
87 
88 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
89 
90 pragma solidity ^0.8.0;
91 
92 /**
93  * @dev Interface for the optional metadata functions from the ERC20 standard.
94  *
95  * _Available since v4.1._
96  */
97 interface IERC20Metadata is IERC20 {
98     /**
99      * @dev Returns the name of the token.
100      */
101     function name() external view returns (string memory);
102 
103     /**
104      * @dev Returns the symbol of the token.
105      */
106     function symbol() external view returns (string memory);
107 
108     /**
109      * @dev Returns the decimals places of the token.
110      */
111     function decimals() external view returns (uint8);
112 }
113 
114 // File: @openzeppelin/contracts/utils/Context.sol
115 
116 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
117 
118 pragma solidity ^0.8.0;
119 
120 /**
121  * @dev Provides information about the current execution context, including the
122  * sender of the transaction and its data. While these are generally available
123  * via msg.sender and msg.data, they should not be accessed in such a direct
124  * manner, since when dealing with meta-transactions the account sending and
125  * paying for execution may not be the actual sender (as far as an application
126  * is concerned).
127  *
128  * This contract is only required for intermediate, library-like contracts.
129  */
130 abstract contract Context {
131     function _msgSender() internal view virtual returns (address) {
132         return msg.sender;
133     }
134 
135     function _msgData() internal view virtual returns (bytes calldata) {
136         return msg.data;
137     }
138 }
139 
140 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
141 
142 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
143 
144 pragma solidity ^0.8.0;
145 
146 
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
159  * We have followed general OpenZeppelin Contracts guidelines: functions revert
160  * instead returning `false` on failure. This behavior is nonetheless
161  * conventional and does not conflict with the expectations of ERC20
162  * applications.
163  *
164  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
165  * This allows applications to reconstruct the allowance for all accounts just
166  * by listening to said events. Other implementations of the EIP may not emit
167  * these events, as it isn't required by the specification.
168  *
169  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
170  * functions have been added to mitigate the well-known issues around setting
171  * allowances. See {IERC20-approve}.
172  */
173 contract ERC20 is Context, IERC20, IERC20Metadata {
174     mapping(address => uint256) private _balances;
175 
176     mapping(address => mapping(address => uint256)) private _allowances;
177 
178     uint256 private _totalSupply;
179 
180     string private _name;
181     string private _symbol;
182 
183     /**
184      * @dev Sets the values for {name} and {symbol}.
185      *
186      * The default value of {decimals} is 18. To select a different value for
187      * {decimals} you should overload it.
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
218      * Ether and Wei. This is the value {ERC20} uses, unless this function is
219      * overridden;
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
296     function transferFrom(
297         address from,
298         address to,
299         uint256 amount
300     ) public virtual override returns (bool) {
301         address spender = _msgSender();
302         _spendAllowance(from, spender, amount);
303         _transfer(from, to, amount);
304         return true;
305     }
306 
307     /**
308      * @dev Atomically increases the allowance granted to `spender` by the caller.
309      *
310      * This is an alternative to {approve} that can be used as a mitigation for
311      * problems described in {IERC20-approve}.
312      *
313      * Emits an {Approval} event indicating the updated allowance.
314      *
315      * Requirements:
316      *
317      * - `spender` cannot be the zero address.
318      */
319     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
320         address owner = _msgSender();
321         _approve(owner, spender, allowance(owner, spender) + addedValue);
322         return true;
323     }
324 
325     /**
326      * @dev Atomically decreases the allowance granted to `spender` by the caller.
327      *
328      * This is an alternative to {approve} that can be used as a mitigation for
329      * problems described in {IERC20-approve}.
330      *
331      * Emits an {Approval} event indicating the updated allowance.
332      *
333      * Requirements:
334      *
335      * - `spender` cannot be the zero address.
336      * - `spender` must have allowance for the caller of at least
337      * `subtractedValue`.
338      */
339     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
340         address owner = _msgSender();
341         uint256 currentAllowance = allowance(owner, spender);
342         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
343         unchecked {
344             _approve(owner, spender, currentAllowance - subtractedValue);
345         }
346 
347         return true;
348     }
349 
350     /**
351      * @dev Moves `amount` of tokens from `from` to `to`.
352      *
353      * This internal function is equivalent to {transfer}, and can be used to
354      * e.g. implement automatic token fees, slashing mechanisms, etc.
355      *
356      * Emits a {Transfer} event.
357      *
358      * Requirements:
359      *
360      * - `from` cannot be the zero address.
361      * - `to` cannot be the zero address.
362      * - `from` must have a balance of at least `amount`.
363      */
364     function _transfer(
365         address from,
366         address to,
367         uint256 amount
368     ) internal virtual {
369         require(from != address(0), "ERC20: transfer from the zero address");
370         require(to != address(0), "ERC20: transfer to the zero address");
371 
372         _beforeTokenTransfer(from, to, amount);
373 
374         uint256 fromBalance = _balances[from];
375         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
376         unchecked {
377             _balances[from] = fromBalance - amount;
378             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
379             // decrementing then incrementing.
380             _balances[to] += amount;
381         }
382 
383         emit Transfer(from, to, amount);
384 
385         _afterTokenTransfer(from, to, amount);
386     }
387 
388     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
389      * the total supply.
390      *
391      * Emits a {Transfer} event with `from` set to the zero address.
392      *
393      * Requirements:
394      *
395      * - `account` cannot be the zero address.
396      */
397     function _mint(address account, uint256 amount) internal virtual {
398         require(account != address(0), "ERC20: mint to the zero address");
399 
400         _beforeTokenTransfer(address(0), account, amount);
401 
402         _totalSupply += amount;
403         unchecked {
404             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
405             _balances[account] += amount;
406         }
407         emit Transfer(address(0), account, amount);
408 
409         _afterTokenTransfer(address(0), account, amount);
410     }
411 
412     /**
413      * @dev Destroys `amount` tokens from `account`, reducing the
414      * total supply.
415      *
416      * Emits a {Transfer} event with `to` set to the zero address.
417      *
418      * Requirements:
419      *
420      * - `account` cannot be the zero address.
421      * - `account` must have at least `amount` tokens.
422      */
423     function _burn(address account, uint256 amount) internal virtual {
424         require(account != address(0), "ERC20: burn from the zero address");
425 
426         _beforeTokenTransfer(account, address(0), amount);
427 
428         uint256 accountBalance = _balances[account];
429         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
430         unchecked {
431             _balances[account] = accountBalance - amount;
432             // Overflow not possible: amount <= accountBalance <= totalSupply.
433             _totalSupply -= amount;
434         }
435 
436         emit Transfer(account, address(0), amount);
437 
438         _afterTokenTransfer(account, address(0), amount);
439     }
440 
441     /**
442      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
443      *
444      * This internal function is equivalent to `approve`, and can be used to
445      * e.g. set automatic allowances for certain subsystems, etc.
446      *
447      * Emits an {Approval} event.
448      *
449      * Requirements:
450      *
451      * - `owner` cannot be the zero address.
452      * - `spender` cannot be the zero address.
453      */
454     function _approve(
455         address owner,
456         address spender,
457         uint256 amount
458     ) internal virtual {
459         require(owner != address(0), "ERC20: approve from the zero address");
460         require(spender != address(0), "ERC20: approve to the zero address");
461 
462         _allowances[owner][spender] = amount;
463         emit Approval(owner, spender, amount);
464     }
465 
466     /**
467      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
468      *
469      * Does not update the allowance amount in case of infinite allowance.
470      * Revert if not enough allowance is available.
471      *
472      * Might emit an {Approval} event.
473      */
474     function _spendAllowance(
475         address owner,
476         address spender,
477         uint256 amount
478     ) internal virtual {
479         uint256 currentAllowance = allowance(owner, spender);
480         if (currentAllowance != type(uint256).max) {
481             require(currentAllowance >= amount, "ERC20: insufficient allowance");
482             unchecked {
483                 _approve(owner, spender, currentAllowance - amount);
484             }
485         }
486     }
487 
488     /**
489      * @dev Hook that is called before any transfer of tokens. This includes
490      * minting and burning.
491      *
492      * Calling conditions:
493      *
494      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
495      * will be transferred to `to`.
496      * - when `from` is zero, `amount` tokens will be minted for `to`.
497      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
498      * - `from` and `to` are never both zero.
499      *
500      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
501      */
502     function _beforeTokenTransfer(
503         address from,
504         address to,
505         uint256 amount
506     ) internal virtual {}
507 
508     /**
509      * @dev Hook that is called after any transfer of tokens. This includes
510      * minting and burning.
511      *
512      * Calling conditions:
513      *
514      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
515      * has been transferred to `to`.
516      * - when `from` is zero, `amount` tokens have been minted for `to`.
517      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
518      * - `from` and `to` are never both zero.
519      *
520      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
521      */
522     function _afterTokenTransfer(
523         address from,
524         address to,
525         uint256 amount
526     ) internal virtual {}
527 }
528 
529 // File: @openzeppelin/contracts/access/Ownable.sol
530 
531 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
532 
533 pragma solidity ^0.8.0;
534 
535 /**
536  * @dev Contract module which provides a basic access control mechanism, where
537  * there is an account (an owner) that can be granted exclusive access to
538  * specific functions.
539  *
540  * By default, the owner account will be the one that deploys the contract. This
541  * can later be changed with {transferOwnership}.
542  *
543  * This module is used through inheritance. It will make available the modifier
544  * `onlyOwner`, which can be applied to your functions to restrict their use to
545  * the owner.
546  */
547 abstract contract Ownable is Context {
548     address private _owner;
549 
550     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
551 
552     /**
553      * @dev Initializes the contract setting the deployer as the initial owner.
554      */
555     constructor() {
556         _transferOwnership(_msgSender());
557     }
558 
559     /**
560      * @dev Throws if called by any account other than the owner.
561      */
562     modifier onlyOwner() {
563         _checkOwner();
564         _;
565     }
566 
567     /**
568      * @dev Returns the address of the current owner.
569      */
570     function owner() public view virtual returns (address) {
571         return _owner;
572     }
573 
574     /**
575      * @dev Throws if the sender is not the owner.
576      */
577     function _checkOwner() internal view virtual {
578         require(owner() == _msgSender(), "Ownable: caller is not the owner");
579     }
580 
581     /**
582      * @dev Leaves the contract without owner. It will not be possible to call
583      * `onlyOwner` functions anymore. Can only be called by the current owner.
584      *
585      * NOTE: Renouncing ownership will leave the contract without an owner,
586      * thereby removing any functionality that is only available to the owner.
587      */
588     function renounceOwnership() public virtual onlyOwner {
589         _transferOwnership(address(0));
590     }
591 
592     /**
593      * @dev Transfers ownership of the contract to a new account (`newOwner`).
594      * Can only be called by the current owner.
595      */
596     function transferOwnership(address newOwner) public virtual onlyOwner {
597         require(newOwner != address(0), "Ownable: new owner is the zero address");
598         _transferOwnership(newOwner);
599     }
600 
601     /**
602      * @dev Transfers ownership of the contract to a new account (`newOwner`).
603      * Internal function without access restriction.
604      */
605     function _transferOwnership(address newOwner) internal virtual {
606         address oldOwner = _owner;
607         _owner = newOwner;
608         emit OwnershipTransferred(oldOwner, newOwner);
609     }
610 }
611 
612 // File: contracts/WaifuAIToken.sol
613 
614 pragma solidity ^0.8.0;
615 
616 
617 contract WaifuAIToken is Ownable, ERC20 {
618     bool public limited;
619     uint256 public maxHoldingAmount;
620     uint256 public minHoldingAmount;
621     address public uniswapV2Pair;
622     mapping(address => bool) public blacklists;
623 
624     constructor(
625         uint256 _totalSupply,
626         address _lpWallet,
627         address _airdropWallet,
628         address _burnMemeAirdropWallet,
629         address _ecoWallet
630     ) ERC20("WaifuAI", "WFAI") {
631         _mint(_lpWallet, (_totalSupply * 10 ** 18 * 950) / 1000); // 95% for LP
632         _mint(_airdropWallet, (_totalSupply * 10 ** 18 * 10) / 1000); // 1% for airdrop
633         _mint(_burnMemeAirdropWallet, (_totalSupply * 10 ** 18 * 20) / 1000); // 2% for burning meme airdrop
634         _mint(_ecoWallet, (_totalSupply * 10 ** 18 * 20) / 1000); // 2% for ecosystsem funds
635     }
636 
637     function blacklist(
638         address _address,
639         bool _isBlacklisting
640     ) external onlyOwner {
641         blacklists[_address] = _isBlacklisting;
642     }
643 
644     function setRule(
645         bool _limited,
646         address _uniswapV2Pair,
647         uint256 _maxHoldingAmount,
648         uint256 _minHoldingAmount
649     ) external onlyOwner {
650         limited = _limited;
651         uniswapV2Pair = _uniswapV2Pair;
652         maxHoldingAmount = _maxHoldingAmount;
653         minHoldingAmount = _minHoldingAmount;
654     }
655 
656     function _beforeTokenTransfer(
657         address from,
658         address to,
659         uint256 amount
660     ) internal virtual override {
661         require(
662             !blacklists[to] && !blacklists[from],
663             "Wallet is in the blacklist"
664         );
665 
666         if (limited && from == uniswapV2Pair) {
667             require(
668                 super.balanceOf(to) + amount <= maxHoldingAmount &&
669                     super.balanceOf(to) + amount >= minHoldingAmount,
670                 "Receiver's balance will be out of the limited range after the transfer"
671             );
672         }
673     }
674 
675     function burn(uint256 value) external {
676         _burn(msg.sender, value);
677     }
678 }