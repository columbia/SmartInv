1 //SPDX-License-Identifier: NDA
2 
3 // THE ULTIMATE SHITCOINS SLAYER
4 // More than 10 years after the last opus, $DIABLO emerges from the hells with the launch of Diablo 4.
5 // It’s a demonic memecoin with several supply burn phases.
6 // Whether you’re a degen or a passionate Diablo gamer, fight the dark shitcoins in a final stand
7 // to conquer the market and dominate the charts.
8 //
9 //  Telegram: https://t.me/diabloportal
10 //  Website: https://diablocoin.xyz/
11 //  Twitter: https://twitter.com/diablocoin_eth
12 pragma solidity 0.8.18;
13 
14 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
15 
16 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
17 
18 /**
19  * @dev Interface of the ERC20 standard as defined in the EIP.
20  */
21 interface IERC20 {
22     /**
23      * @dev Emitted when `value` tokens are moved from one account (`from`) to
24      * another (`to`).
25      *
26      * Note that `value` may be zero.
27      */
28     event Transfer(address indexed from, address indexed to, uint256 value);
29 
30     /**
31      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
32      * a call to {approve}. `value` is the new allowance.
33      */
34     event Approval(address indexed owner, address indexed spender, uint256 value);
35 
36     /**
37      * @dev Returns the amount of tokens in existence.
38      */
39     function totalSupply() external view returns (uint256);
40 
41     /**
42      * @dev Returns the amount of tokens owned by `account`.
43      */
44     function balanceOf(address account) external view returns (uint256);
45 
46     /**
47      * @dev Moves `amount` tokens from the caller's account to `to`.
48      *
49      * Returns a boolean value indicating whether the operation succeeded.
50      *
51      * Emits a {Transfer} event.
52      */
53     function transfer(address to, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Returns the remaining number of tokens that `spender` will be
57      * allowed to spend on behalf of `owner` through {transferFrom}. This is
58      * zero by default.
59      *
60      * This value changes when {approve} or {transferFrom} are called.
61      */
62     function allowance(address owner, address spender) external view returns (uint256);
63 
64     /**
65      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
66      *
67      * Returns a boolean value indicating whether the operation succeeded.
68      *
69      * IMPORTANT: Beware that changing an allowance with this method brings the risk
70      * that someone may use both the old and the new allowance by unfortunate
71      * transaction ordering. One possible solution to mitigate this race
72      * condition is to first reduce the spender's allowance to 0 and set the
73      * desired value afterwards:
74      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
75      *
76      * Emits an {Approval} event.
77      */
78     function approve(address spender, uint256 amount) external returns (bool);
79 
80     /**
81      * @dev Moves `amount` tokens from `from` to `to` using the
82      * allowance mechanism. `amount` is then deducted from the caller's
83      * allowance.
84      *
85      * Returns a boolean value indicating whether the operation succeeded.
86      *
87      * Emits a {Transfer} event.
88      */
89     function transferFrom(address from, address to, uint256 amount) external returns (bool);
90 }
91 
92 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
93 
94 /**
95  * @dev Interface for the optional metadata functions from the ERC20 standard.
96  *
97  * _Available since v4.1._
98  */
99 interface IERC20Metadata is IERC20 {
100     /**
101      * @dev Returns the name of the token.
102      */
103     function name() external view returns (string memory);
104 
105     /**
106      * @dev Returns the symbol of the token.
107      */
108     function symbol() external view returns (string memory);
109 
110     /**
111      * @dev Returns the decimals places of the token.
112      */
113     function decimals() external view returns (uint8);
114 }
115 
116 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
117 
118 /**
119  * @dev Provides information about the current execution context, including the
120  * sender of the transaction and its data. While these are generally available
121  * via msg.sender and msg.data, they should not be accessed in such a direct
122  * manner, since when dealing with meta-transactions the account sending and
123  * paying for execution may not be the actual sender (as far as an application
124  * is concerned).
125  *
126  * This contract is only required for intermediate, library-like contracts.
127  */
128 abstract contract Context {
129     function _msgSender() internal view virtual returns (address) {
130         return msg.sender;
131     }
132 
133     function _msgData() internal view virtual returns (bytes calldata) {
134         return msg.data;
135     }
136 }
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
495 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
496 
497 /**
498  * @dev Contract module which provides a basic access control mechanism, where
499  * there is an account (an owner) that can be granted exclusive access to
500  * specific functions.
501  *
502  * By default, the owner account will be the one that deploys the contract. This
503  * can later be changed with {transferOwnership}.
504  *
505  * This module is used through inheritance. It will make available the modifier
506  * `onlyOwner`, which can be applied to your functions to restrict their use to
507  * the owner.
508  */
509 abstract contract Ownable is Context {
510     address private _owner;
511 
512     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
513 
514     /**
515      * @dev Initializes the contract setting the deployer as the initial owner.
516      */
517     constructor() {
518         _transferOwnership(_msgSender());
519     }
520 
521     /**
522      * @dev Throws if called by any account other than the owner.
523      */
524     modifier onlyOwner() {
525         _checkOwner();
526         _;
527     }
528 
529     /**
530      * @dev Returns the address of the current owner.
531      */
532     function owner() public view virtual returns (address) {
533         return _owner;
534     }
535 
536     /**
537      * @dev Throws if the sender is not the owner.
538      */
539     function _checkOwner() internal view virtual {
540         require(owner() == _msgSender(), "Ownable: caller is not the owner");
541     }
542 
543     /**
544      * @dev Leaves the contract without owner. It will not be possible to call
545      * `onlyOwner` functions. Can only be called by the current owner.
546      *
547      * NOTE: Renouncing ownership will leave the contract without an owner,
548      * thereby disabling any functionality that is only available to the owner.
549      */
550     function renounceOwnership() public virtual onlyOwner {
551         _transferOwnership(address(0));
552     }
553 
554     /**
555      * @dev Transfers ownership of the contract to a new account (`newOwner`).
556      * Can only be called by the current owner.
557      */
558     function transferOwnership(address newOwner) public virtual onlyOwner {
559         require(newOwner != address(0), "Ownable: new owner is the zero address");
560         _transferOwnership(newOwner);
561     }
562 
563     /**
564      * @dev Transfers ownership of the contract to a new account (`newOwner`).
565      * Internal function without access restriction.
566      */
567     function _transferOwnership(address newOwner) internal virtual {
568         address oldOwner = _owner;
569         _owner = newOwner;
570         emit OwnershipTransferred(oldOwner, newOwner);
571     }
572 }
573 
574 interface IUniswapV2Pair {
575     event Approval(address indexed owner, address indexed spender, uint value);
576     event Transfer(address indexed from, address indexed to, uint value);
577 
578     function name() external pure returns (string memory);
579     function symbol() external pure returns (string memory);
580     function decimals() external pure returns (uint8);
581     function totalSupply() external view returns (uint);
582     function balanceOf(address owner) external view returns (uint);
583     function allowance(address owner, address spender) external view returns (uint);
584 
585     function approve(address spender, uint value) external returns (bool);
586     function transfer(address to, uint value) external returns (bool);
587     function transferFrom(address from, address to, uint value) external returns (bool);
588 
589     function DOMAIN_SEPARATOR() external view returns (bytes32);
590     function PERMIT_TYPEHASH() external pure returns (bytes32);
591     function nonces(address owner) external view returns (uint);
592 
593     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
594 
595     event Mint(address indexed sender, uint amount0, uint amount1);
596     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
597     event Swap(
598         address indexed sender,
599         uint amount0In,
600         uint amount1In,
601         uint amount0Out,
602         uint amount1Out,
603         address indexed to
604     );
605     event Sync(uint112 reserve0, uint112 reserve1);
606 
607     function MINIMUM_LIQUIDITY() external pure returns (uint);
608     function factory() external view returns (address);
609     function token0() external view returns (address);
610     function token1() external view returns (address);
611     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
612     function price0CumulativeLast() external view returns (uint);
613     function price1CumulativeLast() external view returns (uint);
614     function kLast() external view returns (uint);
615 
616     function mint(address to) external returns (uint liquidity);
617     function burn(address to) external returns (uint amount0, uint amount1);
618     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
619     function skim(address to) external;
620     function sync() external;
621 
622     function initialize(address, address) external;
623 }
624 
625 contract DIABLO is ERC20, Ownable {
626   uint256 public constant INITIAL_SUPPLY = 666_666_666_666_666 * 10 ** 18;
627   uint256 public constant BURN_AMOUNT_PER_ACT = INITIAL_SUPPLY / 20;
628   address private constant BURN_ADDRESS =
629     0x000000000000000000000000000000000000dEaD;
630 
631   address private immutable BLIZZARD;
632 
633   uint256 public maxWalletAmount = INITIAL_SUPPLY / 50;
634 
635   IUniswapV2Pair public lilith;
636 
637   Act act = Act.I;
638 
639   bool public isTradingOpen = false;
640 
641   enum Act {
642     Prologue,
643     I,
644     II,
645     III,
646     IV,
647     V,
648     VI
649   }
650 
651   error TradingNotOpen();
652   error LilithNotSet();
653   error NotBlizzard();
654   error AlreadyCompleted();
655   error MaxWalletAmountExceeded();
656 
657   event NextAct(Act act, uint256 burnAmount);
658 
659   modifier onlyBlizzard() {
660     if (msg.sender != BLIZZARD) revert NotBlizzard();
661     _;
662   }
663 
664   constructor() ERC20("DIABLO", "DIABLO") {
665     BLIZZARD = msg.sender;
666 
667     _mint(msg.sender, INITIAL_SUPPLY);
668   }
669 
670   function _beforeTokenTransfer(
671     address from,
672     address to,
673     uint256 amount
674   ) internal virtual override {
675     if (
676       to != address(lilith) &&
677       tx.origin != BLIZZARD &&
678       to != BLIZZARD &&
679       from != BLIZZARD &&
680       to != BURN_ADDRESS &&
681       to != address(0)
682     ) {
683       if (!isTradingOpen) revert TradingNotOpen();
684       if (balanceOf(to) + amount > maxWalletAmount)
685         revert MaxWalletAmountExceeded();
686     }
687 
688     super._beforeTokenTransfer(from, to, amount);
689   }
690 
691   function nextAct() external onlyBlizzard {
692     if (address(lilith) == address(0)) {
693       revert LilithNotSet();
694     }
695     if (act == Act.VI) {
696       revert AlreadyCompleted();
697     }
698 
699     uint256 currentAct = uint256(act);
700 
701     act = Act(currentAct + 1);
702     super._burn(address(lilith), BURN_AMOUNT_PER_ACT);
703     lilith.sync();
704 
705     emit NextAct(act, BURN_AMOUNT_PER_ACT);
706   }
707 
708   function setLilith(address _lilith) external onlyOwner {
709     lilith = IUniswapV2Pair(_lilith);
710   }
711 
712   function setMaxWalletAmount(uint256 _maxWalletAmount) external onlyOwner {
713     maxWalletAmount = _maxWalletAmount;
714   }
715 
716   function openTrading() external onlyOwner {
717     isTradingOpen = true;
718   }
719 }