1 // SPDX-License-Identifier: MIT
2 
3 /*
4                      
5 ██╗         ██╗     ██████╗     ██╗    ██╗    ██████╗      █████╗     ██████╗ 
6 ██║         ██║    ██╔═══██╗    ██║    ██║    ██╔══██╗    ██╔══██╗    ██╔══██╗
7 ██║         ██║    ██║   ██║    ██║ █╗ ██║    ██████╔╝    ███████║    ██████╔╝
8 ██║         ██║    ██║▄▄ ██║    ██║███╗██║    ██╔══██╗    ██╔══██║    ██╔═══╝ 
9 ███████╗    ██║    ╚██████╔╝    ╚███╔███╔╝    ██║  ██║    ██║  ██║    ██║     
10 ╚══════╝    ╚═╝     ╚══▀▀═╝      ╚══╝╚══╝     ╚═╝  ╚═╝    ╚═╝  ╚═╝    ╚═╝     
11                                                                                                                
12 $LQW solves the limitations that current Decentralized Liquidity projects are facing.
13 
14 Website: https://liqwrap.com/
15 Docs: https://docs.liqwrap.com/
16 Twitter: https://twitter.com/LiqWrap
17 Telegram: https://t.me/LiqWrap
18 Channel: https://t.me/LiqWrapChannel
19 
20 */
21 
22 pragma solidity ^0.8.6;
23 
24 interface IWrapper {
25     function accumulativeDividendOf(
26         address _owner
27     ) external view returns (uint256);
28 
29     function allowance(
30         address owner,
31         address spender
32     ) external view returns (uint256);
33 
34     function approve(address spender, uint256 amount) external returns (bool);
35 
36     function balanceOf(address account) external view returns (uint256);
37 
38     function decimals() external view returns (uint8);
39 
40     function decreaseAllowance(
41         address spender,
42         uint256 subtractedValue
43     ) external returns (bool);
44 
45     function distributeReward(uint256 amount) external;
46 
47     function dividendOf(address _owner) external view returns (uint256);
48 
49     function excludeFromWraper(address account, bool value) external;
50 
51     function excludedFromWrapper(address) external view returns (bool);
52 
53     function getAccount(
54         address account
55     ) external view returns (address, uint256, uint256, uint256, uint256);
56 
57     function increaseAllowance(
58         address spender,
59         uint256 addedValue
60     ) external returns (bool);
61 
62     function initializeWrapper(
63         address _pairAddress,
64         address _liqwrapAddress
65     ) external;
66 
67     function isWraperEnabled() external view returns (bool);
68 
69     function lastClaimTimes(address) external view returns (uint256);
70 
71     function liqwrapAddress() external view returns (address);
72 
73     function name() external view returns (string memory);
74 
75     function owner() external view returns (address);
76 
77     function processAccount(address account) external returns (bool);
78 
79     function renounceOwnership() external;
80 
81     function symbol() external view returns (string memory);
82 
83     function totalDividendsDistributed() external view returns (uint256);
84 
85     function totalDividendsWithdrawn() external view returns (uint256);
86 
87     function totalSupply() external view returns (uint256);
88 
89     function transfer(address to, uint256 amount) external returns (bool);
90 
91     function transferFrom(
92         address from,
93         address to,
94         uint256 amount
95     ) external returns (bool);
96 
97     function transferOwnership(address newOwner) external;
98 
99     function unwrap() external;
100 
101     function unwrapEnabled() external view returns (bool);
102 
103     function updateUnWrapperStatus(bool _status) external;
104 
105     function withdrawDividend() external;
106 
107     function withdrawableDividendOf(
108         address _owner
109     ) external view returns (uint256);
110 
111     function withdrawnDividendOf(
112         address _owner
113     ) external view returns (uint256);
114 
115     function wrap(uint256 amouunt) external;
116 
117     function wrapInternal(address account, uint256 newBalance) external;
118 }
119 
120 pragma solidity ^0.8.0;
121 
122 interface IPair {
123     function getReserves()
124         external
125         view
126         returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
127 
128     function token0() external view returns (address);
129 }
130 
131 interface IFactory {
132     function createPair(
133         address tokenA,
134         address tokenB
135     ) external returns (address pair);
136 
137     function getPair(
138         address tokenA,
139         address tokenB
140     ) external view returns (address pair);
141 }
142 
143 interface IUniswapRouter {
144     function factory() external pure returns (address);
145 
146     function WETH() external pure returns (address);
147 
148     function addLiquidityETH(
149         address token,
150         uint256 amountTokenDesired,
151         uint256 amountTokenMin,
152         uint256 amountETHMin,
153         address to,
154         uint256 deadline
155     )
156         external
157         payable
158         returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
159 
160     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
161         uint256 amountIn,
162         uint256 amountOutMin,
163         address[] calldata path,
164         address to,
165         uint256 deadline
166     ) external;
167 
168     function swapExactETHForTokens(
169         uint256 amountOutMin,
170         address[] calldata path,
171         address to,
172         uint256 deadline
173     ) external payable returns (uint256[] memory amounts);
174 
175     function swapExactTokensForETHSupportingFeeOnTransferTokens(
176         uint256 amountIn,
177         uint256 amountOutMin,
178         address[] calldata path,
179         address to,
180         uint256 deadline
181     ) external;
182 }
183 
184 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)
185 
186 pragma solidity ^0.8.0;
187 
188 /**
189  * @dev Interface of the ERC20 standard as defined in the EIP.
190  */
191 interface IERC20 {
192     /**
193      * @dev Emitted when `value` tokens are moved from one account (`from`) to
194      * another (`to`).
195      *
196      * Note that `value` may be zero.
197      */
198     event Transfer(address indexed from, address indexed to, uint256 value);
199 
200     /**
201      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
202      * a call to {approve}. `value` is the new allowance.
203      */
204     event Approval(
205         address indexed owner,
206         address indexed spender,
207         uint256 value
208     );
209 
210     /**
211      * @dev Returns the amount of tokens in existence.
212      */
213     function totalSupply() external view returns (uint256);
214 
215     /**
216      * @dev Returns the amount of tokens owned by `account`.
217      */
218     function balanceOf(address account) external view returns (uint256);
219 
220     /**
221      * @dev Moves `amount` tokens from the caller's account to `to`.
222      *
223      * Returns a boolean value indicating whether the operation succeeded.
224      *
225      * Emits a {Transfer} event.
226      */
227     function transfer(address to, uint256 amount) external returns (bool);
228 
229     /**
230      * @dev Returns the remaining number of tokens that `spender` will be
231      * allowed to spend on behalf of `owner` through {transferFrom}. This is
232      * zero by default.
233      *
234      * This value changes when {approve} or {transferFrom} are called.
235      */
236     function allowance(
237         address owner,
238         address spender
239     ) external view returns (uint256);
240 
241     /**
242      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
243      *
244      * Returns a boolean value indicating whether the operation succeeded.
245      *
246      * IMPORTANT: Beware that changing an allowance with this method brings the risk
247      * that someone may use both the old and the new allowance by unfortunate
248      * transaction ordering. One possible solution to mitigate this race
249      * condition is to first reduce the spender's allowance to 0 and set the
250      * desired value afterwards:
251      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
252      *
253      * Emits an {Approval} event.
254      */
255     function approve(address spender, uint256 amount) external returns (bool);
256 
257     /**
258      * @dev Moves `amount` tokens from `from` to `to` using the
259      * allowance mechanism. `amount` is then deducted from the caller's
260      * allowance.
261      *
262      * Returns a boolean value indicating whether the operation succeeded.
263      *
264      * Emits a {Transfer} event.
265      */
266     function transferFrom(
267         address from,
268         address to,
269         uint256 amount
270     ) external returns (bool);
271 }
272 
273 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
274 
275 pragma solidity ^0.8.0;
276 
277 /**
278  * @dev Interface for the optional metadata functions from the ERC20 standard.
279  *
280  * _Available since v4.1._
281  */
282 interface IERC20Metadata is IERC20 {
283     /**
284      * @dev Returns the name of the token.
285      */
286     function name() external view returns (string memory);
287 
288     /**
289      * @dev Returns the symbol of the token.
290      */
291     function symbol() external view returns (string memory);
292 
293     /**
294      * @dev Returns the decimals places of the token.
295      */
296     function decimals() external view returns (uint8);
297 }
298 
299 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
300 
301 pragma solidity ^0.8.0;
302 
303 /**
304  * @dev Provides information about the current execution context, including the
305  * sender of the transaction and its data. While these are generally available
306  * via msg.sender and msg.data, they should not be accessed in such a direct
307  * manner, since when dealing with meta-transactions the account sending and
308  * paying for execution may not be the actual sender (as far as an application
309  * is concerned).
310  *
311  * This contract is only required for intermediate, library-like contracts.
312  */
313 abstract contract Context {
314     function _msgSender() internal view virtual returns (address) {
315         return msg.sender;
316     }
317 
318     function _msgData() internal view virtual returns (bytes calldata) {
319         return msg.data;
320     }
321 }
322 
323 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/ERC20.sol)
324 
325 pragma solidity ^0.8.0;
326 
327 /**
328  * @dev Implementation of the {IERC20} interface.
329  *
330  * This implementation is agnostic to the way tokens are created. This means
331  * that a supply mechanism has to be added in a derived contract using {_mint}.
332  * For a generic mechanism see {ERC20PresetMinterPauser}.
333  *
334  * TIP: For a detailed writeup see our guide
335  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
336  * to implement supply mechanisms].
337  *
338  * The default value of {decimals} is 18. To change this, you should override
339  * this function so it returns a different value.
340  *
341  * We have followed general OpenZeppelin Contracts guidelines: functions revert
342  * instead returning `false` on failure. This behavior is nonetheless
343  * conventional and does not conflict with the expectations of ERC20
344  * applications.
345  *
346  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
347  * This allows applications to reconstruct the allowance for all accounts just
348  * by listening to said events. Other implementations of the EIP may not emit
349  * these events, as it isn't required by the specification.
350  *
351  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
352  * functions have been added to mitigate the well-known issues around setting
353  * allowances. See {IERC20-approve}.
354  */
355 contract ERC20 is Context, IERC20, IERC20Metadata {
356     mapping(address => uint256) private _balances;
357 
358     mapping(address => mapping(address => uint256)) private _allowances;
359 
360     uint256 private _totalSupply;
361 
362     string private _name;
363     string private _symbol;
364 
365     /**
366      * @dev Sets the values for {name} and {symbol}.
367      *
368      * All two of these values are immutable: they can only be set once during
369      * construction.
370      */
371     constructor(string memory name_, string memory symbol_) {
372         _name = name_;
373         _symbol = symbol_;
374     }
375 
376     /**
377      * @dev Returns the name of the token.
378      */
379     function name() public view virtual override returns (string memory) {
380         return _name;
381     }
382 
383     /**
384      * @dev Returns the symbol of the token, usually a shorter version of the
385      * name.
386      */
387     function symbol() public view virtual override returns (string memory) {
388         return _symbol;
389     }
390 
391     /**
392      * @dev Returns the number of decimals used to get its user representation.
393      * For example, if `decimals` equals `2`, a balance of `505` tokens should
394      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
395      *
396      * Tokens usually opt for a value of 18, imitating the relationship between
397      * Ether and Wei. This is the default value returned by this function, unless
398      * it's overridden.
399      *
400      * NOTE: This information is only used for _display_ purposes: it in
401      * no way affects any of the arithmetic of the contract, including
402      * {IERC20-balanceOf} and {IERC20-transfer}.
403      */
404     function decimals() public view virtual override returns (uint8) {
405         return 18;
406     }
407 
408     /**
409      * @dev See {IERC20-totalSupply}.
410      */
411     function totalSupply() public view virtual override returns (uint256) {
412         return _totalSupply;
413     }
414 
415     /**
416      * @dev See {IERC20-balanceOf}.
417      */
418     function balanceOf(
419         address account
420     ) public view virtual override returns (uint256) {
421         return _balances[account];
422     }
423 
424     /**
425      * @dev See {IERC20-transfer}.
426      *
427      * Requirements:
428      *
429      * - `to` cannot be the zero address.
430      * - the caller must have a balance of at least `amount`.
431      */
432     function transfer(
433         address to,
434         uint256 amount
435     ) public virtual override returns (bool) {
436         address owner = _msgSender();
437         _transfer(owner, to, amount);
438         return true;
439     }
440 
441     /**
442      * @dev See {IERC20-allowance}.
443      */
444     function allowance(
445         address owner,
446         address spender
447     ) public view virtual override returns (uint256) {
448         return _allowances[owner][spender];
449     }
450 
451     /**
452      * @dev See {IERC20-approve}.
453      *
454      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
455      * `transferFrom`. This is semantically equivalent to an infinite approval.
456      *
457      * Requirements:
458      *
459      * - `spender` cannot be the zero address.
460      */
461     function approve(
462         address spender,
463         uint256 amount
464     ) public virtual override returns (bool) {
465         address owner = _msgSender();
466         _approve(owner, spender, amount);
467         return true;
468     }
469 
470     /**
471      * @dev See {IERC20-transferFrom}.
472      *
473      * Emits an {Approval} event indicating the updated allowance. This is not
474      * required by the EIP. See the note at the beginning of {ERC20}.
475      *
476      * NOTE: Does not update the allowance if the current allowance
477      * is the maximum `uint256`.
478      *
479      * Requirements:
480      *
481      * - `from` and `to` cannot be the zero address.
482      * - `from` must have a balance of at least `amount`.
483      * - the caller must have allowance for ``from``'s tokens of at least
484      * `amount`.
485      */
486     function transferFrom(
487         address from,
488         address to,
489         uint256 amount
490     ) public virtual override returns (bool) {
491         address spender = _msgSender();
492         _spendAllowance(from, spender, amount);
493         _transfer(from, to, amount);
494         return true;
495     }
496 
497     /**
498      * @dev Atomically increases the allowance granted to `spender` by the caller.
499      *
500      * This is an alternative to {approve} that can be used as a mitigation for
501      * problems described in {IERC20-approve}.
502      *
503      * Emits an {Approval} event indicating the updated allowance.
504      *
505      * Requirements:
506      *
507      * - `spender` cannot be the zero address.
508      */
509     function increaseAllowance(
510         address spender,
511         uint256 addedValue
512     ) public virtual returns (bool) {
513         address owner = _msgSender();
514         _approve(owner, spender, allowance(owner, spender) + addedValue);
515         return true;
516     }
517 
518     /**
519      * @dev Atomically decreases the allowance granted to `spender` by the caller.
520      *
521      * This is an alternative to {approve} that can be used as a mitigation for
522      * problems described in {IERC20-approve}.
523      *
524      * Emits an {Approval} event indicating the updated allowance.
525      *
526      * Requirements:
527      *
528      * - `spender` cannot be the zero address.
529      * - `spender` must have allowance for the caller of at least
530      * `subtractedValue`.
531      */
532     function decreaseAllowance(
533         address spender,
534         uint256 subtractedValue
535     ) public virtual returns (bool) {
536         address owner = _msgSender();
537         uint256 currentAllowance = allowance(owner, spender);
538         require(
539             currentAllowance >= subtractedValue,
540             "ERC20: decreased allowance below zero"
541         );
542         unchecked {
543             _approve(owner, spender, currentAllowance - subtractedValue);
544         }
545 
546         return true;
547     }
548 
549     /**
550      * @dev Moves `amount` of tokens from `from` to `to`.
551      *
552      * This internal function is equivalent to {transfer}, and can be used to
553      * e.g. implement automatic token fees, slashing mechanisms, etc.
554      *
555      * Emits a {Transfer} event.
556      *
557      * Requirements:
558      *
559      * - `from` cannot be the zero address.
560      * - `to` cannot be the zero address.
561      * - `from` must have a balance of at least `amount`.
562      */
563     function _transfer(
564         address from,
565         address to,
566         uint256 amount
567     ) internal virtual {
568         require(from != address(0), "ERC20: transfer from the zero address");
569         require(to != address(0), "ERC20: transfer to the zero address");
570 
571         _beforeTokenTransfer(from, to, amount);
572 
573         uint256 fromBalance = _balances[from];
574         require(
575             fromBalance >= amount,
576             "ERC20: transfer amount exceeds balance"
577         );
578         unchecked {
579             _balances[from] = fromBalance - amount;
580             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
581             // decrementing then incrementing.
582             _balances[to] += amount;
583         }
584 
585         emit Transfer(from, to, amount);
586 
587         _afterTokenTransfer(from, to, amount);
588     }
589 
590     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
591      * the total supply.
592      *
593      * Emits a {Transfer} event with `from` set to the zero address.
594      *
595      * Requirements:
596      *
597      * - `account` cannot be the zero address.
598      */
599     function _mint(address account, uint256 amount) internal virtual {
600         require(account != address(0), "ERC20: mint to the zero address");
601 
602         _beforeTokenTransfer(address(0), account, amount);
603 
604         _totalSupply += amount;
605         unchecked {
606             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
607             _balances[account] += amount;
608         }
609         emit Transfer(address(0), account, amount);
610 
611         _afterTokenTransfer(address(0), account, amount);
612     }
613 
614     /**
615      * @dev Destroys `amount` tokens from `account`, reducing the
616      * total supply.
617      *
618      * Emits a {Transfer} event with `to` set to the zero address.
619      *
620      * Requirements:
621      *
622      * - `account` cannot be the zero address.
623      * - `account` must have at least `amount` tokens.
624      */
625     function _burn(address account, uint256 amount) internal virtual {
626         require(account != address(0), "ERC20: burn from the zero address");
627 
628         _beforeTokenTransfer(account, address(0), amount);
629 
630         uint256 accountBalance = _balances[account];
631         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
632         unchecked {
633             _balances[account] = accountBalance - amount;
634             // Overflow not possible: amount <= accountBalance <= totalSupply.
635             _totalSupply -= amount;
636         }
637 
638         emit Transfer(account, address(0), amount);
639 
640         _afterTokenTransfer(account, address(0), amount);
641     }
642 
643     /**
644      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
645      *
646      * This internal function is equivalent to `approve`, and can be used to
647      * e.g. set automatic allowances for certain subsystems, etc.
648      *
649      * Emits an {Approval} event.
650      *
651      * Requirements:
652      *
653      * - `owner` cannot be the zero address.
654      * - `spender` cannot be the zero address.
655      */
656     function _approve(
657         address owner,
658         address spender,
659         uint256 amount
660     ) internal virtual {
661         require(owner != address(0), "ERC20: approve from the zero address");
662         require(spender != address(0), "ERC20: approve to the zero address");
663 
664         _allowances[owner][spender] = amount;
665         emit Approval(owner, spender, amount);
666     }
667 
668     /**
669      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
670      *
671      * Does not update the allowance amount in case of infinite allowance.
672      * Revert if not enough allowance is available.
673      *
674      * Might emit an {Approval} event.
675      */
676     function _spendAllowance(
677         address owner,
678         address spender,
679         uint256 amount
680     ) internal virtual {
681         uint256 currentAllowance = allowance(owner, spender);
682         if (currentAllowance != type(uint256).max) {
683             require(
684                 currentAllowance >= amount,
685                 "ERC20: insufficient allowance"
686             );
687             unchecked {
688                 _approve(owner, spender, currentAllowance - amount);
689             }
690         }
691     }
692 
693     /**
694      * @dev Hook that is called before any transfer of tokens. This includes
695      * minting and burning.
696      *
697      * Calling conditions:
698      *
699      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
700      * will be transferred to `to`.
701      * - when `from` is zero, `amount` tokens will be minted for `to`.
702      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
703      * - `from` and `to` are never both zero.
704      *
705      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
706      */
707     function _beforeTokenTransfer(
708         address from,
709         address to,
710         uint256 amount
711     ) internal virtual {}
712 
713     /**
714      * @dev Hook that is called after any transfer of tokens. This includes
715      * minting and burning.
716      *
717      * Calling conditions:
718      *
719      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
720      * has been transferred to `to`.
721      * - when `from` is zero, `amount` tokens have been minted for `to`.
722      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
723      * - `from` and `to` are never both zero.
724      *
725      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
726      */
727     function _afterTokenTransfer(
728         address from,
729         address to,
730         uint256 amount
731     ) internal virtual {}
732 }
733 
734 // OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)
735 
736 pragma solidity ^0.8.0;
737 
738 /**
739  * @dev Contract module which provides a basic access control mechanism, where
740  * there is an account (an owner) that can be granted exclusive access to
741  * specific functions.
742  *
743  * By default, the owner account will be the one that deploys the contract. This
744  * can later be changed with {transferOwnership}.
745  *
746  * This module is used through inheritance. It will make available the modifier
747  * `onlyOwner`, which can be applied to your functions to restrict their use to
748  * the owner.
749  */
750 abstract contract Ownable is Context {
751     address private _owner;
752 
753     event OwnershipTransferred(
754         address indexed previousOwner,
755         address indexed newOwner
756     );
757 
758     /**
759      * @dev Initializes the contract setting the deployer as the initial owner.
760      */
761     constructor() {
762         _transferOwnership(_msgSender());
763     }
764 
765     /**
766      * @dev Throws if called by any account other than the owner.
767      */
768     modifier onlyOwner() {
769         _checkOwner();
770         _;
771     }
772 
773     /**
774      * @dev Returns the address of the current owner.
775      */
776     function owner() public view virtual returns (address) {
777         return _owner;
778     }
779 
780     /**
781      * @dev Throws if the sender is not the owner.
782      */
783     function _checkOwner() internal view virtual {
784         require(owner() == _msgSender(), "Ownable: caller is not the owner");
785     }
786 
787     /**
788      * @dev Leaves the contract without owner. It will not be possible to call
789      * `onlyOwner` functions. Can only be called by the current owner.
790      *
791      * NOTE: Renouncing ownership will leave the contract without an owner,
792      * thereby disabling any functionality that is only available to the owner.
793      */
794     function renounceOwnership() public virtual onlyOwner {
795         _transferOwnership(address(0));
796     }
797 
798     /**
799      * @dev Transfers ownership of the contract to a new account (`newOwner`).
800      * Can only be called by the current owner.
801      */
802     function transferOwnership(address newOwner) public virtual onlyOwner {
803         require(
804             newOwner != address(0),
805             "Ownable: new owner is the zero address"
806         );
807         _transferOwnership(newOwner);
808     }
809 
810     /**
811      * @dev Transfers ownership of the contract to a new account (`newOwner`).
812      * Internal function without access restriction.
813      */
814     function _transferOwnership(address newOwner) internal virtual {
815         address oldOwner = _owner;
816         _owner = newOwner;
817         emit OwnershipTransferred(oldOwner, newOwner);
818     }
819 }
820 
821 pragma solidity ^0.8.21;
822 
823 contract LiqWrap is ERC20, Ownable {
824     IUniswapRouter public router;
825     address public pair;
826 
827     bool private swapping;
828     bool public claimStatus;
829     bool public tradingStatus;
830 
831     IWrapper public wrapper;
832 
833     address public marketingWallet;
834 
835     uint256 public swapTokensAtAmount;
836     uint256 public maxBuyAmount;
837     uint256 public maxSellAmount;
838     uint256 public maxWallet;
839 
840     struct Fees {
841         uint256 rewards;
842         uint256 dev;
843     }
844 
845     Fees public fees = Fees(3, 2);
846 
847     uint256 public tax = 5;
848 
849     uint256 private _initialTax = 25;
850     uint256 private _reduceTaxAt = 40;
851     uint256 private _buyCount = 0;
852     uint256 private _sellCount = 0;
853 
854     mapping(address => bool) private _isExcludedFromFees;
855     mapping(address => bool) public automatedMarketMakerPairs;
856     mapping(address => bool) private _isExcludedFromMaxWallet;
857 
858     event ExcludeFromFees(address indexed account, bool isExcluded);
859     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
860 
861     constructor(address _wrapper) ERC20("LiqWrap", "LQW") {
862         marketingWallet = _msgSender();
863 
864         IUniswapRouter _router = IUniswapRouter(
865             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
866         );
867         address _pair = IFactory(_router.factory()).createPair(
868             address(this),
869             _router.WETH()
870         );
871 
872         router = _router;
873         pair = _pair;
874 
875         wrapper = IWrapper(_wrapper);
876 
877         wrapper.initializeWrapper(_pair, address(this));
878 
879         wrapper.excludeFromWraper(address(wrapper), true);
880         wrapper.excludeFromWraper(address(this), true);
881         wrapper.excludeFromWraper(owner(), true);
882         wrapper.excludeFromWraper(address(0xdead), true);
883         wrapper.excludeFromWraper(address(router), true);
884 
885         _approve(address(this), address(router), type(uint256).max);
886 
887         setSwapTokensAtAmount(250000);
888         setMaxWallet(2000000);
889         setMaxBuySell(2000000, 2000000);
890 
891         _setAutomatedMarketMakerPair(_pair, true);
892 
893         setExcludeFromMaxWallet(address(_pair), true);
894         setExcludeFromMaxWallet(address(this), true);
895         setExcludeFromMaxWallet(address(_router), true);
896 
897         setExcludeFromFees(owner(), true);
898         setExcludeFromFees(address(this), true);
899 
900         _mint(owner(), 100000000 * (10 ** 18));
901     }
902 
903     receive() external payable {}
904 
905     function setMaxWallet(uint256 newNum) public onlyOwner {
906         require(newNum >= 1000000, "Cannot set maxWallet lower than 1%");
907         maxWallet = newNum * 10 ** 18;
908     }
909 
910     function claim() external {
911         require(claimStatus, "Claim not enabled");
912         wrapper.processAccount(payable(_msgSender()));
913     }
914 
915     function setClaimStatus(bool _status) external onlyOwner {
916         claimStatus = _status;
917     }
918 
919     function setMaxBuySell(uint256 maxBuy, uint256 maxSell) public onlyOwner {
920         require(maxBuy >= 1000000, "Can't set maxbuy lower than 1% ");
921         require(maxSell >= 500000, "Can't set maxsell lower than 0.5% ");
922         maxBuyAmount = maxBuy * 10 ** 18;
923         maxSellAmount = maxSell * 10 ** 18;
924     }
925 
926     function setSwapTokensAtAmount(uint256 amount) public onlyOwner {
927         swapTokensAtAmount = amount * 10 ** 18;
928     }
929 
930     function setExcludeFromMaxWallet(
931         address account,
932         bool excluded
933     ) public onlyOwner {
934         _isExcludedFromMaxWallet[account] = excluded;
935     }
936 
937     function setExcludeFromFees(
938         address account,
939         bool excluded
940     ) public onlyOwner {
941         require(
942             _isExcludedFromFees[account] != excluded,
943             "Account is already the value of 'excluded'"
944         );
945         _isExcludedFromFees[account] = excluded;
946 
947         emit ExcludeFromFees(account, excluded);
948     }
949 
950     function enableTrading() external onlyOwner {
951         require(!tradingStatus, "Already enabled");
952         tradingStatus = true;
953     }
954 
955     function _setAutomatedMarketMakerPair(address newPair, bool value) private {
956         require(
957             automatedMarketMakerPairs[newPair] != value,
958             "Automated market maker pair is already set to that value"
959         );
960         automatedMarketMakerPairs[newPair] = value;
961 
962         emit SetAutomatedMarketMakerPair(newPair, value);
963     }
964 
965     function isExcludedFromFees(address account) public view returns (bool) {
966         return _isExcludedFromFees[account];
967     }
968 
969     function _transfer(
970         address from,
971         address to,
972         uint256 amount
973     ) internal override {
974         require(from != address(0), "ERC20: transfer from the zero address");
975         require(to != address(0), "ERC20: transfer to the zero address");
976 
977         if (
978             !_isExcludedFromFees[from] && !_isExcludedFromFees[to] && !swapping
979         ) {
980             require(tradingStatus, "Trading not active");
981             if (automatedMarketMakerPairs[to]) {
982                 require(
983                     amount <= maxSellAmount,
984                     "You are exceeding maxSellAmount"
985                 );
986                 _sellCount++;
987             } else if (automatedMarketMakerPairs[from]) {
988                 require(
989                     amount <= maxBuyAmount,
990                     "You are exceeding maxBuyAmount"
991                 );
992                 _buyCount++;
993             }
994             if (!_isExcludedFromMaxWallet[to]) {
995                 require(
996                     amount + balanceOf(to) <= maxWallet,
997                     "Unable to exceed Max Wallet"
998                 );
999             }
1000         }
1001 
1002         if (amount == 0) {
1003             super._transfer(from, to, 0);
1004             return;
1005         }
1006 
1007         uint256 contractTokenBalance = balanceOf(address(this));
1008         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1009 
1010         if (
1011             canSwap &&
1012             !swapping &&
1013             automatedMarketMakerPairs[to] &&
1014             !_isExcludedFromFees[from] &&
1015             !_isExcludedFromFees[to]
1016         ) {
1017             swapping = true;
1018 
1019             swap(swapTokensAtAmount);
1020 
1021             swapping = false;
1022         }
1023 
1024         bool takeFee = !swapping;
1025 
1026         // if any account belongs to _isExcludedFromFee account then remove the fee
1027         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1028             takeFee = false;
1029         }
1030 
1031         if (!automatedMarketMakerPairs[to] && !automatedMarketMakerPairs[from])
1032             takeFee = false;
1033 
1034         if (takeFee) {
1035             uint256 feeAmt;
1036             if (automatedMarketMakerPairs[to]) {
1037                 feeAmt =
1038                     (amount * (_sellCount > _reduceTaxAt ? tax : _initialTax)) /
1039                     100;
1040             } else if (automatedMarketMakerPairs[from]) {
1041                 feeAmt =
1042                     (amount * (_buyCount > _reduceTaxAt ? tax : _initialTax)) /
1043                     100;
1044             }
1045 
1046             amount = amount - feeAmt;
1047             super._transfer(from, address(this), feeAmt);
1048         }
1049         super._transfer(from, to, amount);
1050 
1051         if (address(wrapper) == address(0)) return;
1052 
1053         try wrapper.wrapInternal(from, balanceOf(from)) {} catch {}
1054         try wrapper.wrapInternal(to, balanceOf(to)) {} catch {}
1055     }
1056 
1057     function swap(uint256 tokens) private {
1058         uint256 currentbalance = address(this).balance;
1059 
1060         swapTokensForETH(tokens);
1061 
1062         uint256 balance = address(this).balance;
1063 
1064         uint256 ethToReward = (((balance - currentbalance) * fees.rewards) /
1065             tax);
1066         uint256 ethForDev = balance - ethToReward;
1067 
1068         if (ethForDev > 0) {
1069             (bool success, ) = payable(marketingWallet).call{value: ethForDev}(
1070                 ""
1071             );
1072             require(success, "Failed to send ETH to dev wallet");
1073         }
1074         if (ethToReward > 0) {
1075             (bool success, ) = payable(address(wrapper)).call{
1076                 value: ethToReward
1077             }("");
1078             require(success, "Failed to send ETH to wrapper");
1079             try wrapper.distributeReward(ethToReward) {} catch {}
1080         }
1081     }
1082 
1083     function swapTokensForETH(uint256 tokenAmount) private {
1084         address[] memory path = new address[](2);
1085         path[0] = address(this);
1086         path[1] = router.WETH();
1087 
1088         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1089             tokenAmount,
1090             0, // accept any amount of ETH
1091             path,
1092             address(this),
1093             block.timestamp
1094         );
1095     }
1096 
1097     // GETTERS
1098 
1099     function getTotalDividendsDistributed() external view returns (uint256) {
1100         return wrapper.totalDividendsDistributed();
1101     }
1102 
1103     function withdrawableDividendOf(
1104         address account
1105     ) public view returns (uint256) {
1106         return wrapper.withdrawableDividendOf(account);
1107     }
1108 
1109     function dividendTokenBalanceOf(
1110         address account
1111     ) public view returns (uint256) {
1112         return wrapper.balanceOf(account);
1113     }
1114 
1115     function getAccountInfo(
1116         address account
1117     ) external view returns (address, uint256, uint256, uint256, uint256) {
1118         return wrapper.getAccount(account);
1119     }
1120 }