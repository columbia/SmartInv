1 // SPDX-License-Identifier: MIT
2 
3 /*
4 Website: https://liquidity.money/
5 Docs: https://docs.liquidity.money/
6 Twitter: https://twitter.com/liquiditymoney
7 Telegram: https://t.me/LiquidityMoney
8 Announcements: https://t.me/LIMAnnouncements
9 */
10 
11 pragma solidity ^0.8.6;
12 
13 interface IStaking {
14     function updateReward(uint256 _amount) external;
15 
16     function init(address _rewardToken, address _stakingToken) external;
17 }
18 
19 pragma solidity ^0.8.6;
20 
21 interface IDividendTracker {
22     function LP_Token() external view returns (address);
23 
24     function accumulativeDividendOf(address _owner)
25         external
26         view
27         returns (uint256);
28 
29     function allowance(address owner, address spender)
30         external
31         view
32         returns (uint256);
33 
34     function approve(address spender, uint256 amount) external returns (bool);
35 
36     function balanceOf(address account) external view returns (uint256);
37 
38     function decimals() external view returns (uint8);
39 
40     function decreaseAllowance(address spender, uint256 subtractedValue)
41         external
42         returns (bool);
43 
44     function distributeLPDividends(uint256 amount) external;
45 
46     function dividendOf(address _owner) external view returns (uint256);
47 
48     function excludeFromDividends(address account, bool value) external;
49 
50     function excludedFromDividends(address) external view returns (bool);
51 
52     function getAccount(address account)
53         external
54         view
55         returns (
56             address,
57             uint256,
58             uint256,
59             uint256,
60             uint256
61         );
62 
63     function increaseAllowance(address spender, uint256 addedValue)
64         external
65         returns (bool);
66 
67     function init() external;
68 
69     function lastClaimTimes(address) external view returns (uint256);
70 
71     function name() external view returns (string memory);
72 
73     function owner() external view returns (address);
74 
75     function processAccount(address account) external returns (bool);
76 
77     function renounceOwnership() external;
78 
79     function setBalance(address account, uint256 newBalance) external;
80 
81     function totalDividendsDistributed() external view returns (uint256);
82 
83     function totalDividendsWithdrawn() external view returns (uint256);
84 
85     function totalSupply() external view returns (uint256);
86 
87     function trackerRescueETH20Tokens(address recipient, address tokenAddress)
88         external;
89 
90     function transfer(address to, uint256 amount) external returns (bool);
91 
92     function transferFrom(
93         address from,
94         address to,
95         uint256 amount
96     ) external returns (bool);
97 
98     function transferOwnership(address newOwner) external;
99 
100     function updateLP_Token(address _lpToken) external;
101 
102     function withdrawDividend() external;
103 
104     function withdrawableDividendOf(address _owner)
105         external
106         view
107         returns (uint256);
108 
109     function withdrawnDividendOf(address _owner)
110         external
111         view
112         returns (uint256);
113 }
114 
115 pragma solidity ^0.8.0;
116 
117 interface IPair {
118     function getReserves()
119         external
120         view
121         returns (
122             uint112 reserve0,
123             uint112 reserve1,
124             uint32 blockTimestampLast
125         );
126 
127     function token0() external view returns (address);
128 }
129 
130 interface IFactory {
131     function createPair(address tokenA, address tokenB)
132         external
133         returns (address pair);
134 
135     function getPair(address tokenA, address tokenB)
136         external
137         view
138         returns (address pair);
139 }
140 
141 interface IUniswapRouter {
142     function factory() external pure returns (address);
143 
144     function WETH() external pure returns (address);
145 
146     function addLiquidityETH(
147         address token,
148         uint256 amountTokenDesired,
149         uint256 amountTokenMin,
150         uint256 amountETHMin,
151         address to,
152         uint256 deadline
153     )
154         external
155         payable
156         returns (
157             uint256 amountToken,
158             uint256 amountETH,
159             uint256 liquidity
160         );
161 
162     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
163         uint256 amountIn,
164         uint256 amountOutMin,
165         address[] calldata path,
166         address to,
167         uint256 deadline
168     ) external;
169 
170     function swapExactETHForTokens(
171         uint256 amountOutMin,
172         address[] calldata path,
173         address to,
174         uint256 deadline
175     ) external payable returns (uint256[] memory amounts);
176 
177     function swapExactTokensForETHSupportingFeeOnTransferTokens(
178         uint256 amountIn,
179         uint256 amountOutMin,
180         address[] calldata path,
181         address to,
182         uint256 deadline
183     ) external;
184 }
185 
186 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)
187 
188 pragma solidity ^0.8.0;
189 
190 /**
191  * @dev Interface of the ERC20 standard as defined in the EIP.
192  */
193 interface IERC20 {
194     /**
195      * @dev Emitted when `value` tokens are moved from one account (`from`) to
196      * another (`to`).
197      *
198      * Note that `value` may be zero.
199      */
200     event Transfer(address indexed from, address indexed to, uint256 value);
201 
202     /**
203      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
204      * a call to {approve}. `value` is the new allowance.
205      */
206     event Approval(
207         address indexed owner,
208         address indexed spender,
209         uint256 value
210     );
211 
212     /**
213      * @dev Returns the amount of tokens in existence.
214      */
215     function totalSupply() external view returns (uint256);
216 
217     /**
218      * @dev Returns the amount of tokens owned by `account`.
219      */
220     function balanceOf(address account) external view returns (uint256);
221 
222     /**
223      * @dev Moves `amount` tokens from the caller's account to `to`.
224      *
225      * Returns a boolean value indicating whether the operation succeeded.
226      *
227      * Emits a {Transfer} event.
228      */
229     function transfer(address to, uint256 amount) external returns (bool);
230 
231     /**
232      * @dev Returns the remaining number of tokens that `spender` will be
233      * allowed to spend on behalf of `owner` through {transferFrom}. This is
234      * zero by default.
235      *
236      * This value changes when {approve} or {transferFrom} are called.
237      */
238     function allowance(address owner, address spender)
239         external
240         view
241         returns (uint256);
242 
243     /**
244      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
245      *
246      * Returns a boolean value indicating whether the operation succeeded.
247      *
248      * IMPORTANT: Beware that changing an allowance with this method brings the risk
249      * that someone may use both the old and the new allowance by unfortunate
250      * transaction ordering. One possible solution to mitigate this race
251      * condition is to first reduce the spender's allowance to 0 and set the
252      * desired value afterwards:
253      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
254      *
255      * Emits an {Approval} event.
256      */
257     function approve(address spender, uint256 amount) external returns (bool);
258 
259     /**
260      * @dev Moves `amount` tokens from `from` to `to` using the
261      * allowance mechanism. `amount` is then deducted from the caller's
262      * allowance.
263      *
264      * Returns a boolean value indicating whether the operation succeeded.
265      *
266      * Emits a {Transfer} event.
267      */
268     function transferFrom(
269         address from,
270         address to,
271         uint256 amount
272     ) external returns (bool);
273 }
274 
275 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
276 
277 pragma solidity ^0.8.0;
278 
279 /**
280  * @dev Interface for the optional metadata functions from the ERC20 standard.
281  *
282  * _Available since v4.1._
283  */
284 interface IERC20Metadata is IERC20 {
285     /**
286      * @dev Returns the name of the token.
287      */
288     function name() external view returns (string memory);
289 
290     /**
291      * @dev Returns the symbol of the token.
292      */
293     function symbol() external view returns (string memory);
294 
295     /**
296      * @dev Returns the decimals places of the token.
297      */
298     function decimals() external view returns (uint8);
299 }
300 
301 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
302 
303 pragma solidity ^0.8.0;
304 
305 /**
306  * @dev Provides information about the current execution context, including the
307  * sender of the transaction and its data. While these are generally available
308  * via msg.sender and msg.data, they should not be accessed in such a direct
309  * manner, since when dealing with meta-transactions the account sending and
310  * paying for execution may not be the actual sender (as far as an application
311  * is concerned).
312  *
313  * This contract is only required for intermediate, library-like contracts.
314  */
315 abstract contract Context {
316     function _msgSender() internal view virtual returns (address) {
317         return msg.sender;
318     }
319 
320     function _msgData() internal view virtual returns (bytes calldata) {
321         return msg.data;
322     }
323 }
324 
325 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/ERC20.sol)
326 
327 pragma solidity ^0.8.0;
328 
329 /**
330  * @dev Implementation of the {IERC20} interface.
331  *
332  * This implementation is agnostic to the way tokens are created. This means
333  * that a supply mechanism has to be added in a derived contract using {_mint}.
334  * For a generic mechanism see {ERC20PresetMinterPauser}.
335  *
336  * TIP: For a detailed writeup see our guide
337  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
338  * to implement supply mechanisms].
339  *
340  * The default value of {decimals} is 18. To change this, you should override
341  * this function so it returns a different value.
342  *
343  * We have followed general OpenZeppelin Contracts guidelines: functions revert
344  * instead returning `false` on failure. This behavior is nonetheless
345  * conventional and does not conflict with the expectations of ERC20
346  * applications.
347  *
348  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
349  * This allows applications to reconstruct the allowance for all accounts just
350  * by listening to said events. Other implementations of the EIP may not emit
351  * these events, as it isn't required by the specification.
352  *
353  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
354  * functions have been added to mitigate the well-known issues around setting
355  * allowances. See {IERC20-approve}.
356  */
357 contract ERC20 is Context, IERC20, IERC20Metadata {
358     mapping(address => uint256) private _balances;
359 
360     mapping(address => mapping(address => uint256)) private _allowances;
361 
362     uint256 private _totalSupply;
363 
364     string private _name;
365     string private _symbol;
366 
367     /**
368      * @dev Sets the values for {name} and {symbol}.
369      *
370      * All two of these values are immutable: they can only be set once during
371      * construction.
372      */
373     constructor(string memory name_, string memory symbol_) {
374         _name = name_;
375         _symbol = symbol_;
376     }
377 
378     /**
379      * @dev Returns the name of the token.
380      */
381     function name() public view virtual override returns (string memory) {
382         return _name;
383     }
384 
385     /**
386      * @dev Returns the symbol of the token, usually a shorter version of the
387      * name.
388      */
389     function symbol() public view virtual override returns (string memory) {
390         return _symbol;
391     }
392 
393     /**
394      * @dev Returns the number of decimals used to get its user representation.
395      * For example, if `decimals` equals `2`, a balance of `505` tokens should
396      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
397      *
398      * Tokens usually opt for a value of 18, imitating the relationship between
399      * Ether and Wei. This is the default value returned by this function, unless
400      * it's overridden.
401      *
402      * NOTE: This information is only used for _display_ purposes: it in
403      * no way affects any of the arithmetic of the contract, including
404      * {IERC20-balanceOf} and {IERC20-transfer}.
405      */
406     function decimals() public view virtual override returns (uint8) {
407         return 18;
408     }
409 
410     /**
411      * @dev See {IERC20-totalSupply}.
412      */
413     function totalSupply() public view virtual override returns (uint256) {
414         return _totalSupply;
415     }
416 
417     /**
418      * @dev See {IERC20-balanceOf}.
419      */
420     function balanceOf(address account)
421         public
422         view
423         virtual
424         override
425         returns (uint256)
426     {
427         return _balances[account];
428     }
429 
430     /**
431      * @dev See {IERC20-transfer}.
432      *
433      * Requirements:
434      *
435      * - `to` cannot be the zero address.
436      * - the caller must have a balance of at least `amount`.
437      */
438     function transfer(address to, uint256 amount)
439         public
440         virtual
441         override
442         returns (bool)
443     {
444         address owner = _msgSender();
445         _transfer(owner, to, amount);
446         return true;
447     }
448 
449     /**
450      * @dev See {IERC20-allowance}.
451      */
452     function allowance(address owner, address spender)
453         public
454         view
455         virtual
456         override
457         returns (uint256)
458     {
459         return _allowances[owner][spender];
460     }
461 
462     /**
463      * @dev See {IERC20-approve}.
464      *
465      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
466      * `transferFrom`. This is semantically equivalent to an infinite approval.
467      *
468      * Requirements:
469      *
470      * - `spender` cannot be the zero address.
471      */
472     function approve(address spender, uint256 amount)
473         public
474         virtual
475         override
476         returns (bool)
477     {
478         address owner = _msgSender();
479         _approve(owner, spender, amount);
480         return true;
481     }
482 
483     /**
484      * @dev See {IERC20-transferFrom}.
485      *
486      * Emits an {Approval} event indicating the updated allowance. This is not
487      * required by the EIP. See the note at the beginning of {ERC20}.
488      *
489      * NOTE: Does not update the allowance if the current allowance
490      * is the maximum `uint256`.
491      *
492      * Requirements:
493      *
494      * - `from` and `to` cannot be the zero address.
495      * - `from` must have a balance of at least `amount`.
496      * - the caller must have allowance for ``from``'s tokens of at least
497      * `amount`.
498      */
499     function transferFrom(
500         address from,
501         address to,
502         uint256 amount
503     ) public virtual override returns (bool) {
504         address spender = _msgSender();
505         _spendAllowance(from, spender, amount);
506         _transfer(from, to, amount);
507         return true;
508     }
509 
510     /**
511      * @dev Atomically increases the allowance granted to `spender` by the caller.
512      *
513      * This is an alternative to {approve} that can be used as a mitigation for
514      * problems described in {IERC20-approve}.
515      *
516      * Emits an {Approval} event indicating the updated allowance.
517      *
518      * Requirements:
519      *
520      * - `spender` cannot be the zero address.
521      */
522     function increaseAllowance(address spender, uint256 addedValue)
523         public
524         virtual
525         returns (bool)
526     {
527         address owner = _msgSender();
528         _approve(owner, spender, allowance(owner, spender) + addedValue);
529         return true;
530     }
531 
532     /**
533      * @dev Atomically decreases the allowance granted to `spender` by the caller.
534      *
535      * This is an alternative to {approve} that can be used as a mitigation for
536      * problems described in {IERC20-approve}.
537      *
538      * Emits an {Approval} event indicating the updated allowance.
539      *
540      * Requirements:
541      *
542      * - `spender` cannot be the zero address.
543      * - `spender` must have allowance for the caller of at least
544      * `subtractedValue`.
545      */
546     function decreaseAllowance(address spender, uint256 subtractedValue)
547         public
548         virtual
549         returns (bool)
550     {
551         address owner = _msgSender();
552         uint256 currentAllowance = allowance(owner, spender);
553         require(
554             currentAllowance >= subtractedValue,
555             "ERC20: decreased allowance below zero"
556         );
557         unchecked {
558             _approve(owner, spender, currentAllowance - subtractedValue);
559         }
560 
561         return true;
562     }
563 
564     /**
565      * @dev Moves `amount` of tokens from `from` to `to`.
566      *
567      * This internal function is equivalent to {transfer}, and can be used to
568      * e.g. implement automatic token fees, slashing mechanisms, etc.
569      *
570      * Emits a {Transfer} event.
571      *
572      * Requirements:
573      *
574      * - `from` cannot be the zero address.
575      * - `to` cannot be the zero address.
576      * - `from` must have a balance of at least `amount`.
577      */
578     function _transfer(
579         address from,
580         address to,
581         uint256 amount
582     ) internal virtual {
583         require(from != address(0), "ERC20: transfer from the zero address");
584         require(to != address(0), "ERC20: transfer to the zero address");
585 
586         _beforeTokenTransfer(from, to, amount);
587 
588         uint256 fromBalance = _balances[from];
589         require(
590             fromBalance >= amount,
591             "ERC20: transfer amount exceeds balance"
592         );
593         unchecked {
594             _balances[from] = fromBalance - amount;
595             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
596             // decrementing then incrementing.
597             _balances[to] += amount;
598         }
599 
600         emit Transfer(from, to, amount);
601 
602         _afterTokenTransfer(from, to, amount);
603     }
604 
605     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
606      * the total supply.
607      *
608      * Emits a {Transfer} event with `from` set to the zero address.
609      *
610      * Requirements:
611      *
612      * - `account` cannot be the zero address.
613      */
614     function _mint(address account, uint256 amount) internal virtual {
615         require(account != address(0), "ERC20: mint to the zero address");
616 
617         _beforeTokenTransfer(address(0), account, amount);
618 
619         _totalSupply += amount;
620         unchecked {
621             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
622             _balances[account] += amount;
623         }
624         emit Transfer(address(0), account, amount);
625 
626         _afterTokenTransfer(address(0), account, amount);
627     }
628 
629     /**
630      * @dev Destroys `amount` tokens from `account`, reducing the
631      * total supply.
632      *
633      * Emits a {Transfer} event with `to` set to the zero address.
634      *
635      * Requirements:
636      *
637      * - `account` cannot be the zero address.
638      * - `account` must have at least `amount` tokens.
639      */
640     function _burn(address account, uint256 amount) internal virtual {
641         require(account != address(0), "ERC20: burn from the zero address");
642 
643         _beforeTokenTransfer(account, address(0), amount);
644 
645         uint256 accountBalance = _balances[account];
646         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
647         unchecked {
648             _balances[account] = accountBalance - amount;
649             // Overflow not possible: amount <= accountBalance <= totalSupply.
650             _totalSupply -= amount;
651         }
652 
653         emit Transfer(account, address(0), amount);
654 
655         _afterTokenTransfer(account, address(0), amount);
656     }
657 
658     /**
659      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
660      *
661      * This internal function is equivalent to `approve`, and can be used to
662      * e.g. set automatic allowances for certain subsystems, etc.
663      *
664      * Emits an {Approval} event.
665      *
666      * Requirements:
667      *
668      * - `owner` cannot be the zero address.
669      * - `spender` cannot be the zero address.
670      */
671     function _approve(
672         address owner,
673         address spender,
674         uint256 amount
675     ) internal virtual {
676         require(owner != address(0), "ERC20: approve from the zero address");
677         require(spender != address(0), "ERC20: approve to the zero address");
678 
679         _allowances[owner][spender] = amount;
680         emit Approval(owner, spender, amount);
681     }
682 
683     /**
684      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
685      *
686      * Does not update the allowance amount in case of infinite allowance.
687      * Revert if not enough allowance is available.
688      *
689      * Might emit an {Approval} event.
690      */
691     function _spendAllowance(
692         address owner,
693         address spender,
694         uint256 amount
695     ) internal virtual {
696         uint256 currentAllowance = allowance(owner, spender);
697         if (currentAllowance != type(uint256).max) {
698             require(
699                 currentAllowance >= amount,
700                 "ERC20: insufficient allowance"
701             );
702             unchecked {
703                 _approve(owner, spender, currentAllowance - amount);
704             }
705         }
706     }
707 
708     /**
709      * @dev Hook that is called before any transfer of tokens. This includes
710      * minting and burning.
711      *
712      * Calling conditions:
713      *
714      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
715      * will be transferred to `to`.
716      * - when `from` is zero, `amount` tokens will be minted for `to`.
717      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
718      * - `from` and `to` are never both zero.
719      *
720      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
721      */
722     function _beforeTokenTransfer(
723         address from,
724         address to,
725         uint256 amount
726     ) internal virtual {}
727 
728     /**
729      * @dev Hook that is called after any transfer of tokens. This includes
730      * minting and burning.
731      *
732      * Calling conditions:
733      *
734      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
735      * has been transferred to `to`.
736      * - when `from` is zero, `amount` tokens have been minted for `to`.
737      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
738      * - `from` and `to` are never both zero.
739      *
740      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
741      */
742     function _afterTokenTransfer(
743         address from,
744         address to,
745         uint256 amount
746     ) internal virtual {}
747 }
748 
749 // OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)
750 
751 pragma solidity ^0.8.0;
752 
753 /**
754  * @dev Contract module which provides a basic access control mechanism, where
755  * there is an account (an owner) that can be granted exclusive access to
756  * specific functions.
757  *
758  * By default, the owner account will be the one that deploys the contract. This
759  * can later be changed with {transferOwnership}.
760  *
761  * This module is used through inheritance. It will make available the modifier
762  * `onlyOwner`, which can be applied to your functions to restrict their use to
763  * the owner.
764  */
765 abstract contract Ownable is Context {
766     address private _owner;
767 
768     event OwnershipTransferred(
769         address indexed previousOwner,
770         address indexed newOwner
771     );
772 
773     /**
774      * @dev Initializes the contract setting the deployer as the initial owner.
775      */
776     constructor() {
777         _transferOwnership(_msgSender());
778     }
779 
780     /**
781      * @dev Throws if called by any account other than the owner.
782      */
783     modifier onlyOwner() {
784         _checkOwner();
785         _;
786     }
787 
788     /**
789      * @dev Returns the address of the current owner.
790      */
791     function owner() public view virtual returns (address) {
792         return _owner;
793     }
794 
795     /**
796      * @dev Throws if the sender is not the owner.
797      */
798     function _checkOwner() internal view virtual {
799         require(owner() == _msgSender(), "Ownable: caller is not the owner");
800     }
801 
802     /**
803      * @dev Leaves the contract without owner. It will not be possible to call
804      * `onlyOwner` functions. Can only be called by the current owner.
805      *
806      * NOTE: Renouncing ownership will leave the contract without an owner,
807      * thereby disabling any functionality that is only available to the owner.
808      */
809     function renounceOwnership() public virtual onlyOwner {
810         _transferOwnership(address(0));
811     }
812 
813     /**
814      * @dev Transfers ownership of the contract to a new account (`newOwner`).
815      * Can only be called by the current owner.
816      */
817     function transferOwnership(address newOwner) public virtual onlyOwner {
818         require(
819             newOwner != address(0),
820             "Ownable: new owner is the zero address"
821         );
822         _transferOwnership(newOwner);
823     }
824 
825     /**
826      * @dev Transfers ownership of the contract to a new account (`newOwner`).
827      * Internal function without access restriction.
828      */
829     function _transferOwnership(address newOwner) internal virtual {
830         address oldOwner = _owner;
831         _owner = newOwner;
832         emit OwnershipTransferred(oldOwner, newOwner);
833     }
834 }
835 
836 pragma solidity ^0.8.21;
837 
838 contract LiquidiyMoney is ERC20, Ownable {
839     IUniswapRouter public router;
840     address public pair;
841 
842     bool private swapping;
843     bool public claimEnabled;
844     bool public tradingEnabled;
845 
846     IDividendTracker public dividendTracker;
847 
848     address public marketingWallet;
849     IStaking public stakingPool;
850 
851     uint256 public swapTokensAtAmount;
852     uint256 public maxBuyAmount;
853     uint256 public maxSellAmount;
854     uint256 public maxWallet;
855 
856     struct Taxes {
857         uint256 liquidity;
858         uint256 dev;
859         uint256 stakingPool;
860     }
861 
862     Taxes public taxes = Taxes(3, 2, 1);
863 
864     uint256 public tax = 6;
865 
866     uint256 private _initialTax = 20;
867     uint256 private _reduceTaxAt = 25;
868     uint256 private _buyCount = 0;
869     uint256 private _sellCount = 0;
870 
871     mapping(address => bool) private _isExcludedFromFees;
872     mapping(address => bool) public automatedMarketMakerPairs;
873     mapping(address => bool) private _isExcludedFromMaxWallet;
874 
875     event ExcludeFromFees(address indexed account, bool isExcluded);
876     event ExcludeMultipleAccountsFromFees(address[] accounts, bool isExcluded);
877     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
878     event GasForProcessingUpdated(
879         uint256 indexed newValue,
880         uint256 indexed oldValue
881     );
882     event SendDividends(uint256 tokensSwapped, uint256 amount);
883 
884     constructor(address _dividendTracker, address _stakingPool)
885         ERC20("liquidity.money", "LIM")
886     {
887         marketingWallet = _msgSender();
888 
889         IUniswapRouter _router = IUniswapRouter(
890             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
891         );
892         address _pair = IFactory(_router.factory()).createPair(
893             address(this),
894             _router.WETH()
895         );
896 
897         router = _router;
898         pair = _pair;
899 
900         dividendTracker = IDividendTracker(_dividendTracker);
901         dividendTracker.init();
902 
903         stakingPool = IStaking(_stakingPool);
904         stakingPool.init(address(this), _pair);
905 
906         setSwapTokensAtAmount(300000);
907         updateMaxWalletAmount(2000000);
908         setMaxBuyAndSell(2000000, 2000000);
909 
910         _setAutomatedMarketMakerPair(_pair, true);
911 
912         dividendTracker.updateLP_Token(pair);
913 
914         dividendTracker.excludeFromDividends(address(dividendTracker), true);
915         dividendTracker.excludeFromDividends(_stakingPool, true);
916         dividendTracker.excludeFromDividends(address(this), true);
917         dividendTracker.excludeFromDividends(owner(), true);
918         dividendTracker.excludeFromDividends(address(0xdead), true);
919         dividendTracker.excludeFromDividends(address(_router), true);
920 
921         setExcludeFromMaxWallet(address(_pair), true);
922         setExcludeFromMaxWallet(address(this), true);
923         setExcludeFromMaxWallet(address(_router), true);
924         setExcludeFromMaxWallet(_stakingPool, true);
925 
926         setExcludeFromFees(owner(), true);
927         setExcludeFromFees(address(this), true);
928         setExcludeFromFees(_stakingPool, true);
929 
930         _mint(owner(), 100000000 * (10**18));
931     }
932 
933     receive() external payable {}
934 
935     function claim() external {
936         require(claimEnabled, "Claim not enabled");
937         dividendTracker.processAccount(payable(msg.sender));
938     }
939 
940     function updateMaxWalletAmount(uint256 newNum) public onlyOwner {
941         require(newNum >= 1000000, "Cannot set maxWallet lower than 1%");
942         maxWallet = newNum * 10**18;
943     }
944 
945     function setMaxBuyAndSell(uint256 maxBuy, uint256 maxSell)
946         public
947         onlyOwner
948     {
949         require(maxBuy >= 1000000, "Can't set maxbuy lower than 1% ");
950         require(maxSell >= 500000, "Can't set maxsell lower than 0.5% ");
951         maxBuyAmount = maxBuy * 10**18;
952         maxSellAmount = maxSell * 10**18;
953     }
954 
955     function setSwapTokensAtAmount(uint256 amount) public onlyOwner {
956         swapTokensAtAmount = amount * 10**18;
957     }
958 
959     function setExcludeFromMaxWallet(address account, bool excluded)
960         public
961         onlyOwner
962     {
963         _isExcludedFromMaxWallet[account] = excluded;
964     }
965 
966     function setExcludeFromFees(address account, bool excluded)
967         public
968         onlyOwner
969     {
970         require(
971             _isExcludedFromFees[account] != excluded,
972             "Account is already the value of 'excluded'"
973         );
974         _isExcludedFromFees[account] = excluded;
975 
976         emit ExcludeFromFees(account, excluded);
977     }
978 
979     function excludeFromDividends(address account, bool value)
980         public
981         onlyOwner
982     {
983         dividendTracker.excludeFromDividends(account, value);
984     }
985 
986     function enableTrading() external onlyOwner {
987         require(!tradingEnabled, "Already enabled");
988         tradingEnabled = true;
989     }
990 
991     function setClaimStatus(bool _status) external onlyOwner {
992         claimEnabled = _status;
993     }
994 
995     function _setAutomatedMarketMakerPair(address newPair, bool value) private {
996         require(
997             automatedMarketMakerPairs[newPair] != value,
998             "Automated market maker pair is already set to that value"
999         );
1000         automatedMarketMakerPairs[newPair] = value;
1001 
1002         if (value) {
1003             dividendTracker.excludeFromDividends(newPair, true);
1004         }
1005 
1006         emit SetAutomatedMarketMakerPair(newPair, value);
1007     }
1008 
1009     function getTotalDividendsDistributed() external view returns (uint256) {
1010         return dividendTracker.totalDividendsDistributed();
1011     }
1012 
1013     function isExcludedFromFees(address account) public view returns (bool) {
1014         return _isExcludedFromFees[account];
1015     }
1016 
1017     function withdrawableDividendOf(address account)
1018         public
1019         view
1020         returns (uint256)
1021     {
1022         return dividendTracker.withdrawableDividendOf(account);
1023     }
1024 
1025     function dividendTokenBalanceOf(address account)
1026         public
1027         view
1028         returns (uint256)
1029     {
1030         return dividendTracker.balanceOf(account);
1031     }
1032 
1033     function getAccountInfo(address account)
1034         external
1035         view
1036         returns (
1037             address,
1038             uint256,
1039             uint256,
1040             uint256,
1041             uint256
1042         )
1043     {
1044         return dividendTracker.getAccount(account);
1045     }
1046 
1047     function _transfer(
1048         address from,
1049         address to,
1050         uint256 amount
1051     ) internal override {
1052         require(from != address(0), "ERC20: transfer from the zero address");
1053         require(to != address(0), "ERC20: transfer to the zero address");
1054 
1055         if (
1056             !_isExcludedFromFees[from] && !_isExcludedFromFees[to] && !swapping
1057         ) {
1058             require(tradingEnabled, "Trading not active");
1059             if (automatedMarketMakerPairs[to]) {
1060                 require(
1061                     amount <= maxSellAmount,
1062                     "You are exceeding maxSellAmount"
1063                 );
1064                 _sellCount++;
1065             } else if (automatedMarketMakerPairs[from]) {
1066                 require(
1067                     amount <= maxBuyAmount,
1068                     "You are exceeding maxBuyAmount"
1069                 );
1070                 _buyCount++;
1071             }
1072             if (!_isExcludedFromMaxWallet[to]) {
1073                 require(
1074                     amount + balanceOf(to) <= maxWallet,
1075                     "Unable to exceed Max Wallet"
1076                 );
1077             }
1078         }
1079 
1080         if (amount == 0) {
1081             super._transfer(from, to, 0);
1082             return;
1083         }
1084 
1085         uint256 contractTokenBalance = balanceOf(address(this));
1086         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1087 
1088         if (
1089             canSwap &&
1090             !swapping &&
1091             automatedMarketMakerPairs[to] &&
1092             !_isExcludedFromFees[from] &&
1093             !_isExcludedFromFees[to]
1094         ) {
1095             swapping = true;
1096 
1097             swapAndLiquify(swapTokensAtAmount);
1098 
1099             swapping = false;
1100         }
1101 
1102         bool takeFee = !swapping;
1103 
1104         // if any account belongs to _isExcludedFromFee account then remove the fee
1105         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1106             takeFee = false;
1107         }
1108 
1109         if (!automatedMarketMakerPairs[to] && !automatedMarketMakerPairs[from])
1110             takeFee = false;
1111 
1112         if (takeFee) {
1113             uint256 feeAmt;
1114             if (automatedMarketMakerPairs[to]) {
1115                 feeAmt =
1116                     (amount * (_sellCount > _reduceTaxAt ? tax : _initialTax)) /
1117                     100;
1118             } else if (automatedMarketMakerPairs[from]) {
1119                 feeAmt =
1120                     (amount * (_buyCount > _reduceTaxAt ? tax : _initialTax)) /
1121                     100;
1122             }
1123 
1124             amount = amount - feeAmt;
1125             super._transfer(from, address(this), feeAmt);
1126         }
1127         super._transfer(from, to, amount);
1128 
1129         try dividendTracker.setBalance(from, balanceOf(from)) {} catch {}
1130         try dividendTracker.setBalance(to, balanceOf(to)) {} catch {}
1131     }
1132 
1133     function swapAndLiquify(uint256 tokens) private {
1134         uint256 toSwapForLiq = ((tokens * taxes.liquidity) / tax) / 2;
1135         uint256 tokensToAddLiquidityWith = ((tokens * taxes.liquidity) / tax) /
1136             2;
1137         uint256 toSwapForDev = (tokens * taxes.dev) / tax;
1138         uint256 toStakingPool = (tokens * taxes.stakingPool) / tax;
1139 
1140         super._transfer(address(this), address(stakingPool), toStakingPool);
1141         try stakingPool.updateReward(toStakingPool) {} catch {}
1142 
1143         swapTokensForETH(toSwapForLiq);
1144 
1145         uint256 currentbalance = address(this).balance;
1146 
1147         if (currentbalance > 0) {
1148             // Add liquidity to uni
1149             addLiquidity(tokensToAddLiquidityWith, currentbalance);
1150         }
1151 
1152         swapTokensForETH(toSwapForDev);
1153 
1154         uint256 EthTaxBalance = address(this).balance;
1155 
1156         // Send ETH to dev
1157         uint256 devAmt = EthTaxBalance;
1158 
1159         if (devAmt > 0) {
1160             (bool success, ) = payable(marketingWallet).call{value: devAmt}("");
1161             require(success, "Failed to send ETH to dev wallet");
1162         }
1163 
1164         uint256 lpBalance = IERC20(pair).balanceOf(address(this));
1165 
1166         //Send LP to dividends
1167         uint256 dividends = lpBalance;
1168 
1169         if (dividends > 0) {
1170             bool success = IERC20(pair).transfer(
1171                 address(dividendTracker),
1172                 dividends
1173             );
1174             if (success) {
1175                 dividendTracker.distributeLPDividends(dividends);
1176                 emit SendDividends(tokens, dividends);
1177             }
1178         }
1179     }
1180 
1181     function distributionLiquidity(uint256 amount) public onlyOwner {
1182         bool success = IERC20(pair).transferFrom(
1183             msg.sender,
1184             address(dividendTracker),
1185             amount
1186         );
1187         if (success) {
1188             dividendTracker.distributeLPDividends(amount);
1189         }
1190     }
1191 
1192     function swapTokensForETH(uint256 tokenAmount) private {
1193         address[] memory path = new address[](2);
1194         path[0] = address(this);
1195         path[1] = router.WETH();
1196 
1197         _approve(address(this), address(router), tokenAmount);
1198         // make the swap
1199         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1200             tokenAmount,
1201             0, // accept any amount of ETH
1202             path,
1203             address(this),
1204             block.timestamp
1205         );
1206     }
1207 
1208     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1209         // approve token transfer to cover all possible scenarios
1210         _approve(address(this), address(router), tokenAmount);
1211 
1212         // add the liquidity
1213         router.addLiquidityETH{value: ethAmount}(
1214             address(this),
1215             tokenAmount,
1216             0, // slippage is unavoidable
1217             0, // slippage is unavoidable
1218             address(this),
1219             block.timestamp
1220         );
1221     }
1222 }
1223 // 1 + 2 + 3 + ⋯ + ∞ = -1/12?