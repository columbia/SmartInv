1 /*
2 
3  ██████╗ ███████╗██╗
4 ██╔═══██╗██╔════╝██║
5 ██║   ██║█████╗  ██║
6 ██║   ██║██╔══╝  ██║
7 ╚██████╔╝██║     ██║
8  ╚═════╝ ╚═╝     ╚═╝
9 
10 *First Bitcoin Ordinals Lending & Borrow Protocol
11 
12 Website: https://ordin.finance/
13 
14 Discord: https://discord.gg/xY2RQT45Tm 
15 Twitter: https://twitter.com/ordinalsfinance
16 Website: http://ordin.finance/
17 Channel: https://t.me/OFIChannel
18 Telegram: https://t.me/OrdinalsFinance
19 */
20 
21 // SPDX-License-Identifier: MIT
22 
23 pragma solidity 0.8.16;
24 
25 interface IUniswapV2Factory {
26     event PairCreated(
27         address indexed token0,
28         address indexed token1,
29         address pair,
30         uint256
31     );
32 
33     function feeTo() external view returns (address);
34 
35     function feeToSetter() external view returns (address);
36 
37     function allPairsLength() external view returns (uint256);
38 
39     function getPair(address tokenA, address tokenB)
40         external
41         view
42         returns (address pair);
43 
44     function allPairs(uint256) external view returns (address pair);
45 
46     function createPair(address tokenA, address tokenB)
47         external
48         returns (address pair);
49 
50     function setFeeTo(address) external;
51 
52     function setFeeToSetter(address) external;
53 }
54 
55 interface IUniswapV2Pair {
56     event Approval(
57         address indexed owner,
58         address indexed spender,
59         uint256 value
60     );
61     event Transfer(address indexed from, address indexed to, uint256 value);
62 
63     function name() external pure returns (string memory);
64 
65     function symbol() external pure returns (string memory);
66 
67     function decimals() external pure returns (uint8);
68 
69     function totalSupply() external view returns (uint256);
70 
71     function balanceOf(address owner) external view returns (uint256);
72 
73     function allowance(address owner, address spender)
74         external
75         view
76         returns (uint256);
77 
78     function approve(address spender, uint256 value) external returns (bool);
79 
80     function transfer(address to, uint256 value) external returns (bool);
81 
82     function transferFrom(
83         address from,
84         address to,
85         uint256 value
86     ) external returns (bool);
87 
88     function DOMAIN_SEPARATOR() external view returns (bytes32);
89 
90     function PERMIT_TYPEHASH() external pure returns (bytes32);
91 
92     function nonces(address owner) external view returns (uint256);
93 
94     function permit(
95         address owner,
96         address spender,
97         uint256 value,
98         uint256 deadline,
99         uint8 v,
100         bytes32 r,
101         bytes32 s
102     ) external;
103 
104     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
105     event Burn(
106         address indexed sender,
107         uint256 amount0,
108         uint256 amount1,
109         address indexed to
110     );
111     event Swap(
112         address indexed sender,
113         uint256 amount0In,
114         uint256 amount1In,
115         uint256 amount0Out,
116         uint256 amount1Out,
117         address indexed to
118     );
119     event Sync(uint112 reserve0, uint112 reserve1);
120 
121     function MINIMUM_LIQUIDITY() external pure returns (uint256);
122 
123     function factory() external view returns (address);
124 
125     function token0() external view returns (address);
126 
127     function token1() external view returns (address);
128 
129     function getReserves()
130         external
131         view
132         returns (
133             uint112 reserve0,
134             uint112 reserve1,
135             uint32 blockTimestampLast
136         );
137 
138     function price0CumulativeLast() external view returns (uint256);
139 
140     function price1CumulativeLast() external view returns (uint256);
141 
142     function kLast() external view returns (uint256);
143 
144     function mint(address to) external returns (uint256 liquidity);
145 
146     function burn(address to)
147         external
148         returns (uint256 amount0, uint256 amount1);
149 
150     function swap(
151         uint256 amount0Out,
152         uint256 amount1Out,
153         address to,
154         bytes calldata data
155     ) external;
156 
157     function skim(address to) external;
158 
159     function sync() external;
160 
161     function initialize(address, address) external;
162 }
163 
164 interface IUniswapV2Router01 {
165     function factory() external pure returns (address);
166 
167     function WETH() external pure returns (address);
168 
169     function addLiquidity(
170         address tokenA,
171         address tokenB,
172         uint256 amountADesired,
173         uint256 amountBDesired,
174         uint256 amountAMin,
175         uint256 amountBMin,
176         address to,
177         uint256 deadline
178     )
179         external
180         returns (
181             uint256 amountA,
182             uint256 amountB,
183             uint256 liquidity
184         );
185 
186     function addLiquidityETH(
187         address token,
188         uint256 amountTokenDesired,
189         uint256 amountTokenMin,
190         uint256 amountETHMin,
191         address to,
192         uint256 deadline
193     )
194         external
195         payable
196         returns (
197             uint256 amountToken,
198             uint256 amountETH,
199             uint256 liquidity
200         );
201 
202     function removeLiquidity(
203         address tokenA,
204         address tokenB,
205         uint256 liquidity,
206         uint256 amountAMin,
207         uint256 amountBMin,
208         address to,
209         uint256 deadline
210     ) external returns (uint256 amountA, uint256 amountB);
211 
212     function removeLiquidityETH(
213         address token,
214         uint256 liquidity,
215         uint256 amountTokenMin,
216         uint256 amountETHMin,
217         address to,
218         uint256 deadline
219     ) external returns (uint256 amountToken, uint256 amountETH);
220 
221     function removeLiquidityWithPermit(
222         address tokenA,
223         address tokenB,
224         uint256 liquidity,
225         uint256 amountAMin,
226         uint256 amountBMin,
227         address to,
228         uint256 deadline,
229         bool approveMax,
230         uint8 v,
231         bytes32 r,
232         bytes32 s
233     ) external returns (uint256 amountA, uint256 amountB);
234 
235     function removeLiquidityETHWithPermit(
236         address token,
237         uint256 liquidity,
238         uint256 amountTokenMin,
239         uint256 amountETHMin,
240         address to,
241         uint256 deadline,
242         bool approveMax,
243         uint8 v,
244         bytes32 r,
245         bytes32 s
246     ) external returns (uint256 amountToken, uint256 amountETH);
247 
248     function swapExactTokensForTokens(
249         uint256 amountIn,
250         uint256 amountOutMin,
251         address[] calldata path,
252         address to,
253         uint256 deadline
254     ) external returns (uint256[] memory amounts);
255 
256     function swapTokensForExactTokens(
257         uint256 amountOut,
258         uint256 amountInMax,
259         address[] calldata path,
260         address to,
261         uint256 deadline
262     ) external returns (uint256[] memory amounts);
263 
264     function swapExactETHForTokens(
265         uint256 amountOutMin,
266         address[] calldata path,
267         address to,
268         uint256 deadline
269     ) external payable returns (uint256[] memory amounts);
270 
271     function swapTokensForExactETH(
272         uint256 amountOut,
273         uint256 amountInMax,
274         address[] calldata path,
275         address to,
276         uint256 deadline
277     ) external returns (uint256[] memory amounts);
278 
279     function swapExactTokensForETH(
280         uint256 amountIn,
281         uint256 amountOutMin,
282         address[] calldata path,
283         address to,
284         uint256 deadline
285     ) external returns (uint256[] memory amounts);
286 
287     function swapETHForExactTokens(
288         uint256 amountOut,
289         address[] calldata path,
290         address to,
291         uint256 deadline
292     ) external payable returns (uint256[] memory amounts);
293 
294     function quote(
295         uint256 amountA,
296         uint256 reserveA,
297         uint256 reserveB
298     ) external pure returns (uint256 amountB);
299 
300     function getAmountOut(
301         uint256 amountIn,
302         uint256 reserveIn,
303         uint256 reserveOut
304     ) external pure returns (uint256 amountOut);
305 
306     function getAmountIn(
307         uint256 amountOut,
308         uint256 reserveIn,
309         uint256 reserveOut
310     ) external pure returns (uint256 amountIn);
311 
312     function getAmountsOut(uint256 amountIn, address[] calldata path)
313         external
314         view
315         returns (uint256[] memory amounts);
316 
317     function getAmountsIn(uint256 amountOut, address[] calldata path)
318         external
319         view
320         returns (uint256[] memory amounts);
321 }
322 
323 interface IUniswapV2Router02 is IUniswapV2Router01 {
324     function removeLiquidityETHSupportingFeeOnTransferTokens(
325         address token,
326         uint256 liquidity,
327         uint256 amountTokenMin,
328         uint256 amountETHMin,
329         address to,
330         uint256 deadline
331     ) external returns (uint256 amountETH);
332 
333     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
334         address token,
335         uint256 liquidity,
336         uint256 amountTokenMin,
337         uint256 amountETHMin,
338         address to,
339         uint256 deadline,
340         bool approveMax,
341         uint8 v,
342         bytes32 r,
343         bytes32 s
344     ) external returns (uint256 amountETH);
345 
346     function swapExactETHForTokensSupportingFeeOnTransferTokens(
347         uint256 amountOutMin,
348         address[] calldata path,
349         address to,
350         uint256 deadline
351     ) external payable;
352 
353     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
354         uint256 amountIn,
355         uint256 amountOutMin,
356         address[] calldata path,
357         address to,
358         uint256 deadline
359     ) external;
360 
361     function swapExactTokensForETHSupportingFeeOnTransferTokens(
362         uint256 amountIn,
363         uint256 amountOutMin,
364         address[] calldata path,
365         address to,
366         uint256 deadline
367     ) external;
368 }
369 
370 /**
371  * @dev Interface of the ERC20 standard as defined in the EIP.
372  */
373 interface IERC20 {
374     /**
375      * @dev Emitted when `value` tokens are moved from one account (`from`) to
376      * another (`to`).
377      *
378      * Note that `value` may be zero.
379      */
380     event Transfer(address indexed from, address indexed to, uint256 value);
381 
382     /**
383      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
384      * a call to {approve}. `value` is the new allowance.
385      */
386     event Approval(
387         address indexed owner,
388         address indexed spender,
389         uint256 value
390     );
391 
392     /**
393      * @dev Returns the amount of tokens in existence.
394      */
395     function totalSupply() external view returns (uint256);
396 
397     /**
398      * @dev Returns the amount of tokens owned by `account`.
399      */
400     function balanceOf(address account) external view returns (uint256);
401 
402     /**
403      * @dev Moves `amount` tokens from the caller's account to `to`.
404      *
405      * Returns a boolean value indicating whether the operation succeeded.
406      *
407      * Emits a {Transfer} event.
408      */
409     function transfer(address to, uint256 amount) external returns (bool);
410 
411     /**
412      * @dev Returns the remaining number of tokens that `spender` will be
413      * allowed to spend on behalf of `owner` through {transferFrom}. This is
414      * zero by default.
415      *
416      * This value changes when {approve} or {transferFrom} are called.
417      */
418     function allowance(address owner, address spender)
419         external
420         view
421         returns (uint256);
422 
423     /**
424      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
425      *
426      * Returns a boolean value indicating whether the operation succeeded.
427      *
428      * IMPORTANT: Beware that changing an allowance with this method brings the risk
429      * that someone may use both the old and the new allowance by unfortunate
430      * transaction ordering. One possible solution to mitigate this race
431      * condition is to first reduce the spender's allowance to 0 and set the
432      * desired value afterwards:
433      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
434      *
435      * Emits an {Approval} event.
436      */
437     function approve(address spender, uint256 amount) external returns (bool);
438 
439     /**
440      * @dev Moves `amount` tokens from `from` to `to` using the
441      * allowance mechanism. `amount` is then deducted from the caller's
442      * allowance.
443      *
444      * Returns a boolean value indicating whether the operation succeeded.
445      *
446      * Emits a {Transfer} event.
447      */
448     function transferFrom(
449         address from,
450         address to,
451         uint256 amount
452     ) external returns (bool);
453 }
454 
455 /**
456  * @dev Interface for the optional metadata functions from the ERC20 standard.
457  *
458  * _Available since v4.1._
459  */
460 interface IERC20Metadata is IERC20 {
461     /**
462      * @dev Returns the name of the token.
463      */
464     function name() external view returns (string memory);
465 
466     /**
467      * @dev Returns the decimals places of the token.
468      */
469     function decimals() external view returns (uint8);
470 
471     /**
472      * @dev Returns the symbol of the token.
473      */
474     function symbol() external view returns (string memory);
475 }
476 
477 /**
478  * @dev Provides information about the current execution context, including the
479  * sender of the transaction and its data. While these are generally available
480  * via msg.sender and msg.data, they should not be accessed in such a direct
481  * manner, since when dealing with meta-transactions the account sending and
482  * paying for execution may not be the actual sender (as far as an application
483  * is concerned).
484  *
485  * This contract is only required for intermediate, library-like contracts.
486  */
487 abstract contract Context {
488     function _msgSender() internal view virtual returns (address) {
489         return msg.sender;
490     }
491 }
492 
493 /**
494  * @dev Contract module which provides a basic access control mechanism, where
495  * there is an account (an owner) that can be granted exclusive access to
496  * specific functions.
497  *
498  * By default, the owner account will be the one that deploys the contract. This
499  * can later be changed with {transferOwnership}.
500  *
501  * This module is used through inheritance. It will make available the modifier
502  * `onlyOwner`, which can be applied to your functions to restrict their use to
503  * the owner.
504  */
505 abstract contract Ownable is Context {
506     address private _owner;
507 
508     event OwnershipTransferred(
509         address indexed previousOwner,
510         address indexed newOwner
511     );
512 
513     /**
514      * @dev Initializes the contract setting the deployer as the initial owner.
515      */
516     constructor() {
517         _transferOwnership(_msgSender());
518     }
519 
520     /**
521      * @dev Throws if called by any account other than the owner.
522      */
523     modifier onlyOwner() {
524         _checkOwner();
525         _;
526     }
527 
528     /**
529      * @dev Returns the address of the current owner.
530      */
531     function owner() public view virtual returns (address) {
532         return _owner;
533     }
534 
535     /**
536      * @dev Throws if the sender is not the owner.
537      */
538     function _checkOwner() internal view virtual {
539         require(owner() == _msgSender(), "Ownable: caller is not the owner");
540     }
541 
542     /**
543      * @dev Leaves the contract without owner. It will not be possible to call
544      * `onlyOwner` functions anymore. Can only be called by the current owner.
545      *
546      * NOTE: Renouncing ownership will leave the contract without an owner,
547      * thereby removing any functionality that is only available to the owner.
548      */
549     function renounceOwnership() public virtual onlyOwner {
550         _transferOwnership(address(0));
551     }
552 
553     /**
554      * @dev Transfers ownership of the contract to a new account (`newOwner`).
555      * Can only be called by the current owner.
556      */
557     function transferOwnership(address newOwner) public virtual onlyOwner {
558         require(
559             newOwner != address(0),
560             "Ownable: new owner is the zero address"
561         );
562         _transferOwnership(newOwner);
563     }
564 
565     /**
566      * @dev Transfers ownership of the contract to a new account (`newOwner`).
567      * Internal function without access restriction.
568      */
569     function _transferOwnership(address newOwner) internal virtual {
570         address oldOwner = _owner;
571         _owner = newOwner;
572         emit OwnershipTransferred(oldOwner, newOwner);
573     }
574 }
575 
576 /**
577  * @dev Implementation of the {IERC20} interface.
578  *
579  * This implementation is agnostic to the way tokens are created. This means
580  * that a supply mechanism has to be added in a derived contract using {_mint}.
581  * For a generic mechanism see {ERC20PresetMinterPauser}.
582  *
583  * TIP: For a detailed writeup see our guide
584  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
585  * to implement supply mechanisms].
586  *
587  * We have followed general OpenZeppelin Contracts guidelines: functions revert
588  * instead returning `false` on failure. This behavior is nonetheless
589  * conventional and does not conflict with the expectations of ERC20
590  * applications.
591  *
592  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
593  * This allows applications to reconstruct the allowance for all accounts just
594  * by listening to said events. Other implementations of the EIP may not emit
595  * these events, as it isn't required by the specification.
596  *
597  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
598  * functions have been added to mitigate the well-known issues around setting
599  * allowances. See {IERC20-approve}.
600  */
601 contract ERC20 is Context, IERC20, IERC20Metadata {
602     mapping(address => uint256) private _balances;
603     mapping(address => mapping(address => uint256)) private _allowances;
604 
605     uint256 private _totalSupply;
606 
607     string private _name;
608     string private _symbol;
609 
610     constructor(string memory name_, string memory symbol_) {
611         _name = name_;
612         _symbol = symbol_;
613     }
614 
615     /**
616      * @dev Returns the symbol of the token, usually a shorter version of the
617      * name.
618      */
619     function symbol() external view virtual override returns (string memory) {
620         return _symbol;
621     }
622 
623     /**
624      * @dev Returns the name of the token.
625      */
626     function name() external view virtual override returns (string memory) {
627         return _name;
628     }
629 
630     /**
631      * @dev See {IERC20-balanceOf}.
632      */
633     function balanceOf(address account)
634         public
635         view
636         virtual
637         override
638         returns (uint256)
639     {
640         return _balances[account];
641     }
642 
643     /**
644      * @dev Returns the number of decimals used to get its user representation.
645      * For example, if `decimals` equals `2`, a balance of `505` tokens should
646      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
647      *
648      * Tokens usually opt for a value of 18, imitating the relationship between
649      * Ether and Wei. This is the value {ERC20} uses, unless this function is
650      * overridden;
651      *
652      * NOTE: This information is only used for _display_ purposes: it in
653      * no way affects any of the arithmetic of the contract, including
654      * {IERC20-balanceOf} and {IERC20-transfer}.
655      */
656     function decimals() public view virtual override returns (uint8) {
657         return 9;
658     }
659 
660     /**
661      * @dev See {IERC20-totalSupply}.
662      */
663     function totalSupply() external view virtual override returns (uint256) {
664         return _totalSupply;
665     }
666 
667     /**
668      * @dev See {IERC20-allowance}.
669      */
670     function allowance(address owner, address spender)
671         public
672         view
673         virtual
674         override
675         returns (uint256)
676     {
677         return _allowances[owner][spender];
678     }
679 
680     /**
681      * @dev See {IERC20-transfer}.
682      *
683      * Requirements:
684      *
685      * - `to` cannot be the zero address.
686      * - the caller must have a balance of at least `amount`.
687      */
688     function transfer(address to, uint256 amount)
689         external
690         virtual
691         override
692         returns (bool)
693     {
694         address owner = _msgSender();
695         _transfer(owner, to, amount);
696         return true;
697     }
698 
699     /**
700      * @dev See {IERC20-approve}.
701      *
702      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
703      * `transferFrom`. This is semantically equivalent to an infinite approval.
704      *
705      * Requirements:
706      *
707      * - `spender` cannot be the zero address.
708      */
709     function approve(address spender, uint256 amount)
710         external
711         virtual
712         override
713         returns (bool)
714     {
715         address owner = _msgSender();
716         _approve(owner, spender, amount);
717         return true;
718     }
719 
720     /**
721      * @dev See {IERC20-transferFrom}.
722      *
723      * Emits an {Approval} event indicating the updated allowance. This is not
724      * required by the EIP. See the note at the beginning of {ERC20}.
725      *
726      * NOTE: Does not update the allowance if the current allowance
727      * is the maximum `uint256`.
728      *
729      * Requirements:
730      *
731      * - `from` and `to` cannot be the zero address.
732      * - `from` must have a balance of at least `amount`.
733      * - the caller must have allowance for ``from``'s tokens of at least
734      * `amount`.
735      */
736     function transferFrom(
737         address from,
738         address to,
739         uint256 amount
740     ) external virtual override returns (bool) {
741         address spender = _msgSender();
742         _spendAllowance(from, spender, amount);
743         _transfer(from, to, amount);
744         return true;
745     }
746 
747     /**
748      * @dev Atomically decreases the allowance granted to `spender` by the caller.
749      *
750      * This is an alternative to {approve} that can be used as a mitigation for
751      * problems described in {IERC20-approve}.
752      *
753      * Emits an {Approval} event indicating the updated allowance.
754      *
755      * Requirements:
756      *
757      * - `spender` cannot be the zero address.
758      * - `spender` must have allowance for the caller of at least
759      * `subtractedValue`.
760      */
761     function decreaseAllowance(address spender, uint256 subtractedValue)
762         external
763         virtual
764         returns (bool)
765     {
766         address owner = _msgSender();
767         uint256 currentAllowance = allowance(owner, spender);
768         require(
769             currentAllowance >= subtractedValue,
770             "ERC20: decreased allowance below zero"
771         );
772         unchecked {
773             _approve(owner, spender, currentAllowance - subtractedValue);
774         }
775 
776         return true;
777     }
778 
779     /**
780      * @dev Atomically increases the allowance granted to `spender` by the caller.
781      *
782      * This is an alternative to {approve} that can be used as a mitigation for
783      * problems described in {IERC20-approve}.
784      *
785      * Emits an {Approval} event indicating the updated allowance.
786      *
787      * Requirements:
788      *
789      * - `spender` cannot be the zero address.
790      */
791     function increaseAllowance(address spender, uint256 addedValue)
792         external
793         virtual
794         returns (bool)
795     {
796         address owner = _msgSender();
797         _approve(owner, spender, allowance(owner, spender) + addedValue);
798         return true;
799     }
800 
801     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
802      * the total supply.
803      *
804      * Emits a {Transfer} event with `from` set to the zero address.
805      *
806      * Requirements:
807      *
808      * - `account` cannot be the zero address.
809      */
810     function _mint(address account, uint256 amount) internal virtual {
811         require(account != address(0), "ERC20: mint to the zero address");
812 
813         _totalSupply += amount;
814         unchecked {
815             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
816             _balances[account] += amount;
817         }
818         emit Transfer(address(0), account, amount);
819     }
820 
821     /**
822      * @dev Destroys `amount` tokens from `account`, reducing the
823      * total supply.
824      *
825      * Emits a {Transfer} event with `to` set to the zero address.
826      *
827      * Requirements:
828      *
829      * - `account` cannot be the zero address.
830      * - `account` must have at least `amount` tokens.
831      */
832     function _burn(address account, uint256 amount) internal virtual {
833         require(account != address(0), "ERC20: burn from the zero address");
834 
835         uint256 accountBalance = _balances[account];
836         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
837         unchecked {
838             _balances[account] = accountBalance - amount;
839             // Overflow not possible: amount <= accountBalance <= totalSupply.
840             _totalSupply -= amount;
841         }
842 
843         emit Transfer(account, address(0), amount);
844     }
845 
846     /**
847      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
848      *
849      * This internal function is equivalent to `approve`, and can be used to
850      * e.g. set automatic allowances for certain subsystems, etc.
851      *
852      * Emits an {Approval} event.
853      *
854      * Requirements:
855      *
856      * - `owner` cannot be the zero address.
857      * - `spender` cannot be the zero address.
858      */
859     function _approve(
860         address owner,
861         address spender,
862         uint256 amount
863     ) internal virtual {
864         require(owner != address(0), "ERC20: approve from the zero address");
865         require(spender != address(0), "ERC20: approve to the zero address");
866 
867         _allowances[owner][spender] = amount;
868         emit Approval(owner, spender, amount);
869     }
870 
871     /**
872      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
873      *
874      * Does not update the allowance amount in case of infinite allowance.
875      * Revert if not enough allowance is available.
876      *
877      * Might emit an {Approval} event.
878      */
879     function _spendAllowance(
880         address owner,
881         address spender,
882         uint256 amount
883     ) internal virtual {
884         uint256 currentAllowance = allowance(owner, spender);
885         if (currentAllowance != type(uint256).max) {
886             require(
887                 currentAllowance >= amount,
888                 "ERC20: insufficient allowance"
889             );
890             unchecked {
891                 _approve(owner, spender, currentAllowance - amount);
892             }
893         }
894     }
895 
896     function _transfer(
897         address from,
898         address to,
899         uint256 amount
900     ) internal virtual {
901         require(from != address(0), "ERC20: transfer from the zero address");
902         require(to != address(0), "ERC20: transfer to the zero address");
903 
904         uint256 fromBalance = _balances[from];
905         require(
906             fromBalance >= amount,
907             "ERC20: transfer amount exceeds balance"
908         );
909         unchecked {
910             _balances[from] = fromBalance - amount;
911             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
912             // decrementing then incrementing.
913             _balances[to] += amount;
914         }
915 
916         emit Transfer(from, to, amount);
917     }
918 }
919 
920 /**
921  * @dev Implementation of the {IERC20} interface.
922  *
923  * This implementation is agnostic to the way tokens are created. This means
924  * that a supply mechanism has to be added in a derived contract using {_mint}.
925  * For a generic mechanism see {ERC20PresetMinterPauser}.
926  *
927  * TIP: For a detailed writeup see our guide
928  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
929  * to implement supply mechanisms].
930  *
931  * We have followed general OpenZeppelin Contracts guidelines: functions revert
932  * instead returning `false` on failure. This behavior is nonetheless
933  * conventional and does not conflict with the expectations of ERC20
934  * applications.
935  *
936  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
937  * This allows applications to reconstruct the allowance for all accounts just
938  * by listening to said events. Other implementations of the EIP may not emit
939  * these events, as it isn't required by the specification.
940  *
941  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
942  * functions have been added to mitigate the well-known issues around setting
943  * allowances. See {IERC20-approve}.
944  */
945  contract OrdinalsFinance is ERC20, Ownable {
946     string private _name = "Ordinals Finance";
947     string private _symbol = "OFI";
948     uint8 private _decimals = 9;
949     uint256 private _supply = 1000000000;
950     uint256 public taxForLiquidity = 3;
951     uint256 public taxForTreasury = 3;
952 
953     address public treasuryWallet = 0x524570E6427f4264E0f3e0514cE84474eDfa058a;
954     address public DEAD = 0x000000000000000000000000000000000000dEaD;
955     uint256 public _treasuryReserves = 0;
956     mapping(address => bool) public _isExcludedFromFee;
957     uint256 public numTokensSellToAddToLiquidity = 200000 * 10**_decimals;
958     uint256 public numTokensSellToAddToETH = 100000 * 10**_decimals;
959 
960     IUniswapV2Router02 public immutable uniswapV2Router;
961     address public uniswapV2Pair;
962     
963     bool inSwapAndLiquify;
964 
965     event SwapAndLiquify(
966         uint256 tokensSwapped,
967         uint256 ethReceived,
968         uint256 tokensIntoLiqudity
969     );
970 
971     modifier lockTheSwap() {
972         inSwapAndLiquify = true;
973         _;
974         inSwapAndLiquify = false;
975     }
976 
977     /**
978      * @dev Sets the values for {name} and {symbol}.
979      *
980      * The default value of {decimals} is 18. To select a different value for
981      * {decimals} you should overload it.
982      *
983      * All two of these values are immutable: they can only be set once during
984      * construction.
985      */
986     constructor() ERC20(_name, _symbol) {
987         _mint(msg.sender, (_supply * 10**_decimals));
988 
989         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
990         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
991 
992         uniswapV2Router = _uniswapV2Router;
993 
994         _isExcludedFromFee[address(uniswapV2Router)] = true;
995         _isExcludedFromFee[msg.sender] = true;
996         _isExcludedFromFee[treasuryWallet] = true;
997     }
998 
999 
1000     /**
1001      * @dev Moves `amount` of tokens from `from` to `to`.
1002      *
1003      * This internal function is equivalent to {transfer}, and can be used to
1004      * e.g. implement automatic token fees, slashing mechanisms, etc.
1005      *
1006      * Emits a {Transfer} event.
1007      *
1008      * Requirements:
1009      *
1010      *
1011      * - `from` cannot be the zero address.
1012      * - `to` cannot be the zero address.
1013      * - `from` must have a balance of at least `amount`.
1014      */
1015     function _transfer(address from, address to, uint256 amount) internal override {
1016         require(from != address(0), "ERC20: transfer from the zero address");
1017         require(to != address(0), "ERC20: transfer to the zero address");
1018         require(balanceOf(from) >= amount, "ERC20: transfer amount exceeds balance");
1019 
1020         if ((from == uniswapV2Pair || to == uniswapV2Pair) && !inSwapAndLiquify) {
1021             if (from != uniswapV2Pair) {
1022                 uint256 contractLiquidityBalance = balanceOf(address(this)) - _treasuryReserves;
1023                 if (contractLiquidityBalance >= numTokensSellToAddToLiquidity) {
1024                     _swapAndLiquify(numTokensSellToAddToLiquidity);
1025                 }
1026                 if ((_treasuryReserves) >= numTokensSellToAddToETH) {
1027                     _swapTokensForETH(numTokensSellToAddToETH);
1028                     _treasuryReserves -= numTokensSellToAddToETH;
1029                     bool sent = payable(treasuryWallet).send(address(this).balance);
1030                     require(sent, "Failed to send ETH");
1031                 }
1032             }
1033 
1034             uint256 transferAmount;
1035             if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
1036                 transferAmount = amount;
1037             } 
1038             else {
1039                 uint256 treasuryShare = ((amount * taxForTreasury) / 100);
1040                 uint256 liquidityShare = ((amount * taxForLiquidity) / 100);
1041                 transferAmount = amount - (treasuryShare + liquidityShare);
1042                 _treasuryReserves += treasuryShare;
1043 
1044                 super._transfer(from, address(this), (treasuryShare + liquidityShare));
1045             }
1046             super._transfer(from, to, transferAmount);
1047         } 
1048         else {
1049             super._transfer(from, to, amount);
1050         }
1051     }
1052 
1053     function excludeFromFee(address _address, bool _status) external onlyOwner {
1054         _isExcludedFromFee[_address] = _status;
1055     }
1056 
1057     function _swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1058         uint256 half = (contractTokenBalance / 2);
1059         uint256 otherHalf = (contractTokenBalance - half);
1060 
1061         uint256 initialBalance = address(this).balance;
1062 
1063         _swapTokensForETH(half);
1064 
1065         uint256 newBalance = (address(this).balance - initialBalance);
1066 
1067         _addLiquidity(otherHalf, newBalance);
1068 
1069         emit SwapAndLiquify(half, newBalance, otherHalf);
1070     }
1071 
1072     function _swapTokensForETH(uint256 tokenAmount) private lockTheSwap {
1073         address[] memory path = new address[](2);
1074         path[0] = address(this);
1075         path[1] = uniswapV2Router.WETH();
1076 
1077         _approve(address(this), address(uniswapV2Router), tokenAmount);
1078 
1079         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1080             tokenAmount,
1081             0,
1082             path,
1083             address(this),
1084             block.timestamp
1085         );
1086     }
1087 
1088     function _addLiquidity(uint256 tokenAmount, uint256 ethAmount)
1089         private
1090         lockTheSwap
1091     {
1092         _approve(address(this), address(uniswapV2Router), tokenAmount);
1093 
1094         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1095             address(this),
1096             tokenAmount,
1097             0,
1098             0,
1099             treasuryWallet,
1100             block.timestamp
1101         );
1102     }
1103 
1104     function setTreasuryWallet(address newWallet)
1105         public
1106         onlyOwner
1107         returns (bool)
1108     {
1109         require(newWallet != DEAD, "LP Pair cannot be the Dead wallet, or 0!");
1110         require(newWallet != address(0), "LP Pair cannot be the Dead wallet, or 0!");
1111         treasuryWallet = newWallet;
1112         return true;
1113     }
1114 
1115     function setTaxForLiquidityAndTreasury(uint256 _taxForLiquidity, uint256 _taxForTreasury)
1116         public
1117         onlyOwner
1118         returns (bool)
1119     {
1120         require((_taxForLiquidity+_taxForTreasury) <= 10, "ERC20: total tax must not be greater than 10%");
1121         taxForLiquidity = _taxForLiquidity;
1122         taxForTreasury = _taxForTreasury;
1123 
1124         return true;
1125     }
1126 
1127     function setNumTokensSellToAddToLiquidity(uint256 _numTokensSellToAddToLiquidity, uint256 _numTokensSellToAddToETH)
1128         public
1129         onlyOwner
1130         returns (bool)
1131     {
1132         require(_numTokensSellToAddToLiquidity < _supply / 98, "Cannot liquidate more than 2% of the supply at once!");
1133         require(_numTokensSellToAddToETH < _supply / 98, "Cannot liquidate more than 2% of the supply at once!");
1134         numTokensSellToAddToLiquidity = _numTokensSellToAddToLiquidity * 10**_decimals;
1135         numTokensSellToAddToETH = _numTokensSellToAddToETH * 10**_decimals;
1136 
1137         return true;
1138     }
1139 
1140     receive() external payable {}
1141 }