1 pragma solidity 0.8.16;
2 // SPDX-License-Identifier: MIT
3 interface IUniswapV2Factory {
4     event PairCreated(
5         address indexed token0,
6         address indexed token1,
7         address pair,
8         uint256
9     );
10 
11     function feeTo() external view returns (address);
12 
13     function feeToSetter() external view returns (address);
14 
15     function allPairsLength() external view returns (uint256);
16 
17     function getPair(address tokenA, address tokenB)
18         external
19         view
20         returns (address pair);
21 
22     function allPairs(uint256) external view returns (address pair);
23 
24     function createPair(address tokenA, address tokenB)
25         external
26         returns (address pair);
27 
28     function setFeeTo(address) external;
29 
30     function setFeeToSetter(address) external;
31 }
32 
33 interface IUniswapV2Pair {
34     event Approval(
35         address indexed owner,
36         address indexed spender,
37         uint256 value
38     );
39     event Transfer(address indexed from, address indexed to, uint256 value);
40 
41     function name() external pure returns (string memory);
42 
43     function symbol() external pure returns (string memory);
44 
45     function decimals() external pure returns (uint8);
46 
47     function totalSupply() external view returns (uint256);
48 
49     function balanceOf(address owner) external view returns (uint256);
50 
51     function allowance(address owner, address spender)
52         external
53         view
54         returns (uint256);
55 
56     function approve(address spender, uint256 value) external returns (bool);
57 
58     function transfer(address to, uint256 value) external returns (bool);
59 
60     function transferFrom(
61         address from,
62         address to,
63         uint256 value
64     ) external returns (bool);
65 
66     function DOMAIN_SEPARATOR() external view returns (bytes32);
67 
68     function PERMIT_TYPEHASH() external pure returns (bytes32);
69 
70     function nonces(address owner) external view returns (uint256);
71 
72     function permit(
73         address owner,
74         address spender,
75         uint256 value,
76         uint256 deadline,
77         uint8 v,
78         bytes32 r,
79         bytes32 s
80     ) external;
81 
82     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
83     event Burn(
84         address indexed sender,
85         uint256 amount0,
86         uint256 amount1,
87         address indexed to
88     );
89     event Swap(
90         address indexed sender,
91         uint256 amount0In,
92         uint256 amount1In,
93         uint256 amount0Out,
94         uint256 amount1Out,
95         address indexed to
96     );
97     event Sync(uint112 reserve0, uint112 reserve1);
98 
99     function MINIMUM_LIQUIDITY() external pure returns (uint256);
100 
101     function factory() external view returns (address);
102 
103     function token0() external view returns (address);
104 
105     function token1() external view returns (address);
106 
107     function getReserves()
108         external
109         view
110         returns (
111             uint112 reserve0,
112             uint112 reserve1,
113             uint32 blockTimestampLast
114         );
115 
116     function price0CumulativeLast() external view returns (uint256);
117 
118     function price1CumulativeLast() external view returns (uint256);
119 
120     function kLast() external view returns (uint256);
121 
122     function mint(address to) external returns (uint256 liquidity);
123 
124     function burn(address to)
125         external
126         returns (uint256 amount0, uint256 amount1);
127 
128     function swap(
129         uint256 amount0Out,
130         uint256 amount1Out,
131         address to,
132         bytes calldata data
133     ) external;
134 
135     function skim(address to) external;
136 
137     function sync() external;
138 
139     function initialize(address, address) external;
140 }
141 
142 interface IUniswapV2Router01 {
143     function factory() external pure returns (address);
144 
145     function WETH() external pure returns (address);
146 
147     function addLiquidity(
148         address tokenA,
149         address tokenB,
150         uint256 amountADesired,
151         uint256 amountBDesired,
152         uint256 amountAMin,
153         uint256 amountBMin,
154         address to,
155         uint256 deadline
156     )
157         external
158         returns (
159             uint256 amountA,
160             uint256 amountB,
161             uint256 liquidity
162         );
163 
164     function addLiquidityETH(
165         address token,
166         uint256 amountTokenDesired,
167         uint256 amountTokenMin,
168         uint256 amountETHMin,
169         address to,
170         uint256 deadline
171     )
172         external
173         payable
174         returns (
175             uint256 amountToken,
176             uint256 amountETH,
177             uint256 liquidity
178         );
179 
180     function removeLiquidity(
181         address tokenA,
182         address tokenB,
183         uint256 liquidity,
184         uint256 amountAMin,
185         uint256 amountBMin,
186         address to,
187         uint256 deadline
188     ) external returns (uint256 amountA, uint256 amountB);
189 
190     function removeLiquidityETH(
191         address token,
192         uint256 liquidity,
193         uint256 amountTokenMin,
194         uint256 amountETHMin,
195         address to,
196         uint256 deadline
197     ) external returns (uint256 amountToken, uint256 amountETH);
198 
199     function removeLiquidityWithPermit(
200         address tokenA,
201         address tokenB,
202         uint256 liquidity,
203         uint256 amountAMin,
204         uint256 amountBMin,
205         address to,
206         uint256 deadline,
207         bool approveMax,
208         uint8 v,
209         bytes32 r,
210         bytes32 s
211     ) external returns (uint256 amountA, uint256 amountB);
212 
213     function removeLiquidityETHWithPermit(
214         address token,
215         uint256 liquidity,
216         uint256 amountTokenMin,
217         uint256 amountETHMin,
218         address to,
219         uint256 deadline,
220         bool approveMax,
221         uint8 v,
222         bytes32 r,
223         bytes32 s
224     ) external returns (uint256 amountToken, uint256 amountETH);
225 
226     function swapExactTokensForTokens(
227         uint256 amountIn,
228         uint256 amountOutMin,
229         address[] calldata path,
230         address to,
231         uint256 deadline
232     ) external returns (uint256[] memory amounts);
233 
234     function swapTokensForExactTokens(
235         uint256 amountOut,
236         uint256 amountInMax,
237         address[] calldata path,
238         address to,
239         uint256 deadline
240     ) external returns (uint256[] memory amounts);
241 
242     function swapExactETHForTokens(
243         uint256 amountOutMin,
244         address[] calldata path,
245         address to,
246         uint256 deadline
247     ) external payable returns (uint256[] memory amounts);
248 
249     function swapTokensForExactETH(
250         uint256 amountOut,
251         uint256 amountInMax,
252         address[] calldata path,
253         address to,
254         uint256 deadline
255     ) external returns (uint256[] memory amounts);
256 
257     function swapExactTokensForETH(
258         uint256 amountIn,
259         uint256 amountOutMin,
260         address[] calldata path,
261         address to,
262         uint256 deadline
263     ) external returns (uint256[] memory amounts);
264 
265     function swapETHForExactTokens(
266         uint256 amountOut,
267         address[] calldata path,
268         address to,
269         uint256 deadline
270     ) external payable returns (uint256[] memory amounts);
271 
272     function quote(
273         uint256 amountA,
274         uint256 reserveA,
275         uint256 reserveB
276     ) external pure returns (uint256 amountB);
277 
278     function getAmountOut(
279         uint256 amountIn,
280         uint256 reserveIn,
281         uint256 reserveOut
282     ) external pure returns (uint256 amountOut);
283 
284     function getAmountIn(
285         uint256 amountOut,
286         uint256 reserveIn,
287         uint256 reserveOut
288     ) external pure returns (uint256 amountIn);
289 
290     function getAmountsOut(uint256 amountIn, address[] calldata path)
291         external
292         view
293         returns (uint256[] memory amounts);
294 
295     function getAmountsIn(uint256 amountOut, address[] calldata path)
296         external
297         view
298         returns (uint256[] memory amounts);
299 }
300 
301 interface IUniswapV2Router02 is IUniswapV2Router01 {
302     function removeLiquidityETHSupportingFeeOnTransferTokens(
303         address token,
304         uint256 liquidity,
305         uint256 amountTokenMin,
306         uint256 amountETHMin,
307         address to,
308         uint256 deadline
309     ) external returns (uint256 amountETH);
310 
311     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
312         address token,
313         uint256 liquidity,
314         uint256 amountTokenMin,
315         uint256 amountETHMin,
316         address to,
317         uint256 deadline,
318         bool approveMax,
319         uint8 v,
320         bytes32 r,
321         bytes32 s
322     ) external returns (uint256 amountETH);
323 
324     function swapExactETHForTokensSupportingFeeOnTransferTokens(
325         uint256 amountOutMin,
326         address[] calldata path,
327         address to,
328         uint256 deadline
329     ) external payable;
330 
331     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
332         uint256 amountIn,
333         uint256 amountOutMin,
334         address[] calldata path,
335         address to,
336         uint256 deadline
337     ) external;
338 
339     function swapExactTokensForETHSupportingFeeOnTransferTokens(
340         uint256 amountIn,
341         uint256 amountOutMin,
342         address[] calldata path,
343         address to,
344         uint256 deadline
345     ) external;
346 }
347 
348 /**
349  * @dev Interface of the ERC20 standard as defined in the EIP.
350  */
351 interface IERC20 {
352     /**
353      * @dev Emitted when `value` tokens are moved from one account (`from`) to
354      * another (`to`).
355      *
356      * Note that `value` may be zero.
357      */
358     event Transfer(address indexed from, address indexed to, uint256 value);
359 
360     /**
361      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
362      * a call to {approve}. `value` is the new allowance.
363      */
364     event Approval(
365         address indexed owner,
366         address indexed spender,
367         uint256 value
368     );
369 
370     /**
371      * @dev Returns the amount of tokens in existence.
372      */
373     function totalSupply() external view returns (uint256);
374 
375     /**
376      * @dev Returns the amount of tokens owned by `account`.
377      */
378     function balanceOf(address account) external view returns (uint256);
379 
380     /**
381      * @dev Moves `amount` tokens from the caller's account to `to`.
382      *
383      * Returns a boolean value indicating whether the operation succeeded.
384      *
385      * Emits a {Transfer} event.
386      */
387     function transfer(address to, uint256 amount) external returns (bool);
388 
389     /**
390      * @dev Returns the remaining number of tokens that `spender` will be
391      * allowed to spend on behalf of `owner` through {transferFrom}. This is
392      * zero by default.
393      *
394      * This value changes when {approve} or {transferFrom} are called.
395      */
396     function allowance(address owner, address spender)
397         external
398         view
399         returns (uint256);
400 
401     /**
402      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
403      *
404      * Returns a boolean value indicating whether the operation succeeded.
405      *
406      * IMPORTANT: Beware that changing an allowance with this method brings the risk
407      * that someone may use both the old and the new allowance by unfortunate
408      * transaction ordering. One possible solution to mitigate this race
409      * condition is to first reduce the spender's allowance to 0 and set the
410      * desired value afterwards:
411      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
412      *
413      * Emits an {Approval} event.
414      */
415     function approve(address spender, uint256 amount) external returns (bool);
416 
417     /**
418      * @dev Moves `amount` tokens from `from` to `to` using the
419      * allowance mechanism. `amount` is then deducted from the caller's
420      * allowance.
421      *
422      * Returns a boolean value indicating whether the operation succeeded.
423      *
424      * Emits a {Transfer} event.
425      */
426     function transferFrom(
427         address from,
428         address to,
429         uint256 amount
430     ) external returns (bool);
431 }
432 
433 /**
434  * @dev Interface for the optional metadata functions from the ERC20 standard.
435  *
436  * _Available since v4.1._
437  */
438 interface IERC20Metadata is IERC20 {
439     /**
440      * @dev Returns the name of the token.
441      */
442     function name() external view returns (string memory);
443 
444     /**
445      * @dev Returns the decimals places of the token.
446      */
447     function decimals() external view returns (uint8);
448 
449     /**
450      * @dev Returns the symbol of the token.
451      */
452     function symbol() external view returns (string memory);
453 }
454 
455 /**
456  * @dev Provides information about the current execution context, including the
457  * sender of the transaction and its data. While these are generally available
458  * via msg.sender and msg.data, they should not be accessed in such a direct
459  * manner, since when dealing with meta-transactions the account sending and
460  * paying for execution may not be the actual sender (as far as an application
461  * is concerned).
462  *
463  * This contract is only required for intermediate, library-like contracts.
464  */
465 abstract contract Context {
466     function _msgSender() internal view virtual returns (address) {
467         return msg.sender;
468     }
469 }
470 
471 /**
472  * @dev Contract module which provides a basic access control mechanism, where
473  * there is an account (an owner) that can be granted exclusive access to
474  * specific functions.
475  *
476  * By default, the owner account will be the one that deploys the contract. This
477  * can later be changed with {transferOwnership}.
478  *
479  * This module is used through inheritance. It will make available the modifier
480  * `onlyOwner`, which can be applied to your functions to restrict their use to
481  * the owner.
482  */
483 abstract contract Ownable is Context {
484     address private _owner;
485 
486     event OwnershipTransferred(
487         address indexed previousOwner,
488         address indexed newOwner
489     );
490 
491     /**
492      * @dev Initializes the contract setting the deployer as the initial owner.
493      */
494     constructor() {
495         _transferOwnership(_msgSender());
496     }
497 
498     /**
499      * @dev Throws if called by any account other than the owner.
500      */
501     modifier onlyOwner() {
502         _checkOwner();
503         _;
504     }
505 
506     /**
507      * @dev Returns the address of the current owner.
508      */
509     function owner() public view virtual returns (address) {
510         return _owner;
511     }
512 
513     /**
514      * @dev Throws if the sender is not the owner.
515      */
516     function _checkOwner() internal view virtual {
517         require(owner() == _msgSender(), "Ownable: caller is not the owner");
518     }
519 
520     /**
521      * @dev Leaves the contract without owner. It will not be possible to call
522      * `onlyOwner` functions anymore. Can only be called by the current owner.
523      *
524      * NOTE: Renouncing ownership will leave the contract without an owner,
525      * thereby removing any functionality that is only available to the owner.
526      */
527     function renounceOwnership() public virtual onlyOwner {
528         _transferOwnership(address(0));
529     }
530 
531     /**
532      * @dev Transfers ownership of the contract to a new account (`newOwner`).
533      * Can only be called by the current owner.
534      */
535     function transferOwnership(address newOwner) public virtual onlyOwner {
536         require(
537             newOwner != address(0),
538             "Ownable: new owner is the zero address"
539         );
540         _transferOwnership(newOwner);
541     }
542 
543     /**
544      * @dev Transfers ownership of the contract to a new account (`newOwner`).
545      * Internal function without access restriction.
546      */
547     function _transferOwnership(address newOwner) internal virtual {
548         address oldOwner = _owner;
549         _owner = newOwner;
550         emit OwnershipTransferred(oldOwner, newOwner);
551     }
552 }
553 
554 /**
555  * @dev Implementation of the {IERC20} interface.
556  *
557  * This implementation is agnostic to the way tokens are created. This means
558  * that a supply mechanism has to be added in a derived contract using {_mint}.
559  * For a generic mechanism see {ERC20PresetMinterPauser}.
560  *
561  * TIP: For a detailed writeup see our guide
562  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
563  * to implement supply mechanisms].
564  *
565  * We have followed general OpenZeppelin Contracts guidelines: functions revert
566  * instead returning `false` on failure. This behavior is nonetheless
567  * conventional and does not conflict with the expectations of ERC20
568  * applications.
569  *
570  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
571  * This allows applications to reconstruct the allowance for all accounts just
572  * by listening to said events. Other implementations of the EIP may not emit
573  * these events, as it isn't required by the specification.
574  *
575  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
576  * functions have been added to mitigate the well-known issues around setting
577  * allowances. See {IERC20-approve}.
578  */
579 contract ERC20 is Context, IERC20, IERC20Metadata {
580     mapping(address => uint256) private _balances;
581     mapping(address => mapping(address => uint256)) private _allowances;
582 
583     uint256 private _totalSupply;
584 
585     string private _name;
586     string private _symbol;
587 
588     constructor(string memory name_, string memory symbol_) {
589         _name = name_;
590         _symbol = symbol_;
591     }
592 
593     /**
594      * @dev Returns the symbol of the token, usually a shorter version of the
595      * name.
596      */
597     function symbol() external view virtual override returns (string memory) {
598         return _symbol;
599     }
600 
601     /**
602      * @dev Returns the name of the token.
603      */
604     function name() external view virtual override returns (string memory) {
605         return _name;
606     }
607 
608     /**
609      * @dev See {IERC20-balanceOf}.
610      */
611     function balanceOf(address account)
612         public
613         view
614         virtual
615         override
616         returns (uint256)
617     {
618         return _balances[account];
619     }
620 
621     /**
622      * @dev Returns the number of decimals used to get its user representation.
623      * For example, if `decimals` equals `2`, a balance of `505` tokens should
624      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
625      *
626      * Tokens usually opt for a value of 18, imitating the relationship between
627      * Ether and Wei. This is the value {ERC20} uses, unless this function is
628      * overridden;
629      *
630      * NOTE: This information is only used for _display_ purposes: it in
631      * no way affects any of the arithmetic of the contract, including
632      * {IERC20-balanceOf} and {IERC20-transfer}.
633      */
634     function decimals() public view virtual override returns (uint8) {
635         return 9;
636     }
637 
638     /**
639      * @dev See {IERC20-totalSupply}.
640      */
641     function totalSupply() external view virtual override returns (uint256) {
642         return _totalSupply;
643     }
644 
645     /**
646      * @dev See {IERC20-allowance}.
647      */
648     function allowance(address owner, address spender)
649         public
650         view
651         virtual
652         override
653         returns (uint256)
654     {
655         return _allowances[owner][spender];
656     }
657 
658     /**
659      * @dev See {IERC20-transfer}.
660      *
661      * Requirements:
662      *
663      * - `to` cannot be the zero address.
664      * - the caller must have a balance of at least `amount`.
665      */
666     function transfer(address to, uint256 amount)
667         external
668         virtual
669         override
670         returns (bool)
671     {
672         address owner = _msgSender();
673         _transfer(owner, to, amount);
674         return true;
675     }
676 
677     /**
678      * @dev See {IERC20-approve}.
679      *
680      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
681      * `transferFrom`. This is semantically equivalent to an infinite approval.
682      *
683      * Requirements:
684      *
685      * - `spender` cannot be the zero address.
686      */
687     function approve(address spender, uint256 amount)
688         external
689         virtual
690         override
691         returns (bool)
692     {
693         address owner = _msgSender();
694         _approve(owner, spender, amount);
695         return true;
696     }
697 
698     /**
699      * @dev See {IERC20-transferFrom}.
700      *
701      * Emits an {Approval} event indicating the updated allowance. This is not
702      * required by the EIP. See the note at the beginning of {ERC20}.
703      *
704      * NOTE: Does not update the allowance if the current allowance
705      * is the maximum `uint256`.
706      *
707      * Requirements:
708      *
709      * - `from` and `to` cannot be the zero address.
710      * - `from` must have a balance of at least `amount`.
711      * - the caller must have allowance for ``from``'s tokens of at least
712      * `amount`.
713      */
714     function transferFrom(
715         address from,
716         address to,
717         uint256 amount
718     ) external virtual override returns (bool) {
719         address spender = _msgSender();
720         _spendAllowance(from, spender, amount);
721         _transfer(from, to, amount);
722         return true;
723     }
724 
725     /**
726      * @dev Atomically decreases the allowance granted to `spender` by the caller.
727      *
728      * This is an alternative to {approve} that can be used as a mitigation for
729      * problems described in {IERC20-approve}.
730      *
731      * Emits an {Approval} event indicating the updated allowance.
732      *
733      * Requirements:
734      *
735      * - `spender` cannot be the zero address.
736      * - `spender` must have allowance for the caller of at least
737      * `subtractedValue`.
738      */
739     function decreaseAllowance(address spender, uint256 subtractedValue)
740         external
741         virtual
742         returns (bool)
743     {
744         address owner = _msgSender();
745         uint256 currentAllowance = allowance(owner, spender);
746         require(
747             currentAllowance >= subtractedValue,
748             "ERC20: decreased allowance below zero"
749         );
750         unchecked {
751             _approve(owner, spender, currentAllowance - subtractedValue);
752         }
753 
754         return true;
755     }
756 
757     /**
758      * @dev Atomically increases the allowance granted to `spender` by the caller.
759      *
760      * This is an alternative to {approve} that can be used as a mitigation for
761      * problems described in {IERC20-approve}.
762      *
763      * Emits an {Approval} event indicating the updated allowance.
764      *
765      * Requirements:
766      *
767      * - `spender` cannot be the zero address.
768      */
769     function increaseAllowance(address spender, uint256 addedValue)
770         external
771         virtual
772         returns (bool)
773     {
774         address owner = _msgSender();
775         _approve(owner, spender, allowance(owner, spender) + addedValue);
776         return true;
777     }
778 
779     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
780      * the total supply.
781      *
782      * Emits a {Transfer} event with `from` set to the zero address.
783      *
784      * Requirements:
785      *
786      * - `account` cannot be the zero address.
787      */
788     function _mint(address account, uint256 amount) internal virtual {
789         require(account != address(0), "ERC20: mint to the zero address");
790 
791         _totalSupply += amount;
792         unchecked {
793             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
794             _balances[account] += amount;
795         }
796         emit Transfer(address(0), account, amount);
797     }
798 
799     /**
800      * @dev Destroys `amount` tokens from `account`, reducing the
801      * total supply.
802      *
803      * Emits a {Transfer} event with `to` set to the zero address.
804      *
805      * Requirements:
806      *
807      * - `account` cannot be the zero address.
808      * - `account` must have at least `amount` tokens.
809      */
810     function _burn(address account, uint256 amount) internal virtual {
811         require(account != address(0), "ERC20: burn from the zero address");
812 
813         uint256 accountBalance = _balances[account];
814         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
815         unchecked {
816             _balances[account] = accountBalance - amount;
817             // Overflow not possible: amount <= accountBalance <= totalSupply.
818             _totalSupply -= amount;
819         }
820 
821         emit Transfer(account, address(0), amount);
822     }
823 
824     /**
825      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
826      *
827      * This internal function is equivalent to `approve`, and can be used to
828      * e.g. set automatic allowances for certain subsystems, etc.
829      *
830      * Emits an {Approval} event.
831      *
832      * Requirements:
833      *
834      * - `owner` cannot be the zero address.
835      * - `spender` cannot be the zero address.
836      */
837     function _approve(
838         address owner,
839         address spender,
840         uint256 amount
841     ) internal virtual {
842         require(owner != address(0), "ERC20: approve from the zero address");
843         require(spender != address(0), "ERC20: approve to the zero address");
844 
845         _allowances[owner][spender] = amount;
846         emit Approval(owner, spender, amount);
847     }
848 
849     /**
850      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
851      *
852      * Does not update the allowance amount in case of infinite allowance.
853      * Revert if not enough allowance is available.
854      *
855      * Might emit an {Approval} event.
856      */
857     function _spendAllowance(
858         address owner,
859         address spender,
860         uint256 amount
861     ) internal virtual {
862         uint256 currentAllowance = allowance(owner, spender);
863         if (currentAllowance != type(uint256).max) {
864             require(
865                 currentAllowance >= amount,
866                 "ERC20: insufficient allowance"
867             );
868             unchecked {
869                 _approve(owner, spender, currentAllowance - amount);
870             }
871         }
872     }
873 
874     function _transfer(
875         address from,
876         address to,
877         uint256 amount
878     ) internal virtual {
879         require(from != address(0), "ERC20: transfer from the zero address");
880         require(to != address(0), "ERC20: transfer to the zero address");
881 
882         uint256 fromBalance = _balances[from];
883         require(
884             fromBalance >= amount,
885             "ERC20: transfer amount exceeds balance"
886         );
887         unchecked {
888             _balances[from] = fromBalance - amount;
889             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
890             // decrementing then incrementing.
891             _balances[to] += amount;
892         }
893 
894         emit Transfer(from, to, amount);
895     }
896 }
897 
898 /**
899  * @dev Implementation of the {IERC20} interface.
900  *
901  * This implementation is agnostic to the way tokens are created. This means
902  * that a supply mechanism has to be added in a derived contract using {_mint}.
903  * For a generic mechanism see {ERC20PresetMinterPauser}.
904  *
905  * TIP: For a detailed writeup see our guide
906  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
907  * to implement supply mechanisms].
908  *
909  * We have followed general OpenZeppelin Contracts guidelines: functions revert
910  * instead returning `false` on failure. This behavior is nonetheless
911  * conventional and does not conflict with the expectations of ERC20
912  * applications.
913  *
914  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
915  * This allows applications to reconstruct the allowance for all accounts just
916  * by listening to said events. Other implementations of the EIP may not emit
917  * these events, as it isn't required by the specification.
918  *
919  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
920  * functions have been added to mitigate the well-known issues around setting
921  * allowances. See {IERC20-approve}.
922  */
923  contract PepePal is ERC20, Ownable {
924     // TOKENOMICS START ==========================================================>
925     string private _name = "PepePal";
926     string private _symbol = "PEPL";
927     uint8 private _decimals = 9;
928     uint256 private _supply = 6666666;
929     uint256 public taxForLiquidity = 1;
930     uint256 public taxForMarketing = 1;
931     uint256 public maxTxAmount = 66666 * 10**_decimals;
932     uint256 public maxWalletAmount = 133332 * 10**_decimals;
933     address public marketingWallet = 0xd5d8F9ec5EBc83402f5e08A9F2B02FC765979671;
934     // TOKENOMICS END ============================================================>
935 
936     IUniswapV2Router02 public immutable uniswapV2Router;
937     address public immutable uniswapV2Pair;
938 
939     uint256 private _marketingReserves = 0;
940     mapping(address => bool) private _isExcludedFromFee;
941     uint256 private _numTokensSellToAddToLiquidity = 5000 * 10**_decimals;
942     uint256 private _numTokensSellToAddToETH = 2000 * 10**_decimals;
943     bool inSwapAndLiquify;
944 
945     event SwapAndLiquify(
946         uint256 tokensSwapped,
947         uint256 ethReceived,
948         uint256 tokensIntoLiqudity
949     );
950 
951     modifier lockTheSwap() {
952         inSwapAndLiquify = true;
953         _;
954         inSwapAndLiquify = false;
955     }
956 
957     /**
958      * @dev Sets the values for {name} and {symbol}.
959      *
960      * The default value of {decimals} is 18. To select a different value for
961      * {decimals} you should overload it.
962      *
963      * All two of these values are immutable: they can only be set once during
964      * construction.
965      */
966     constructor() ERC20(_name, _symbol) {
967         _mint(msg.sender, (_supply * 10**_decimals));
968 
969         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
970         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
971 
972         uniswapV2Router = _uniswapV2Router;
973 
974         _isExcludedFromFee[address(uniswapV2Router)] = true;
975         _isExcludedFromFee[msg.sender] = true;
976         _isExcludedFromFee[marketingWallet] = true;
977     }
978 
979     /**
980      * @dev Moves `amount` of tokens from `from` to `to`.
981      *
982      * This internal function is equivalent to {transfer}, and can be used to
983      * e.g. implement automatic token fees, slashing mechanisms, etc.
984      *
985      * Emits a {Transfer} event.
986      *
987      * Requirements:
988      *
989      *
990      * - `from` cannot be the zero address.
991      * - `to` cannot be the zero address.
992      * - `from` must have a balance of at least `amount`.
993      */
994     function _transfer(address from, address to, uint256 amount) internal override {
995         require(from != address(0), "ERC20: transfer from the zero address");
996         require(to != address(0), "ERC20: transfer to the zero address");
997         require(balanceOf(from) >= amount, "ERC20: transfer amount exceeds balance");
998 
999         if ((from == uniswapV2Pair || to == uniswapV2Pair) && !inSwapAndLiquify) {
1000             if (from != uniswapV2Pair) {
1001                 uint256 contractLiquidityBalance = balanceOf(address(this)) - _marketingReserves;
1002                 if (contractLiquidityBalance >= _numTokensSellToAddToLiquidity) {
1003                     _swapAndLiquify(_numTokensSellToAddToLiquidity);
1004                 }
1005                 if ((_marketingReserves) >= _numTokensSellToAddToETH) {
1006                     _swapTokensForEth(_numTokensSellToAddToETH);
1007                     _marketingReserves -= _numTokensSellToAddToETH;
1008                     bool sent = payable(marketingWallet).send(address(this).balance);
1009                     require(sent, "Failed to send ETH");
1010                 }
1011             }
1012 
1013             uint256 transferAmount;
1014             if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
1015                 transferAmount = amount;
1016             } 
1017             else {
1018                 require(amount <= maxTxAmount, "ERC20: transfer amount exceeds the max transaction amount");
1019                 if(from == uniswapV2Pair){
1020                     require((amount + balanceOf(to)) <= maxWalletAmount, "ERC20: balance amount exceeded max wallet amount limit");
1021                 }
1022 
1023                 uint256 marketingShare = ((amount * taxForMarketing) / 100);
1024                 uint256 liquidityShare = ((amount * taxForLiquidity) / 100);
1025                 transferAmount = amount - (marketingShare + liquidityShare);
1026                 _marketingReserves += marketingShare;
1027 
1028                 super._transfer(from, address(this), (marketingShare + liquidityShare));
1029             }
1030             super._transfer(from, to, transferAmount);
1031         } 
1032         else {
1033             super._transfer(from, to, amount);
1034         }
1035     }
1036 
1037     function _swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1038         uint256 half = (contractTokenBalance / 2);
1039         uint256 otherHalf = (contractTokenBalance - half);
1040 
1041         uint256 initialBalance = address(this).balance;
1042 
1043         _swapTokensForEth(half);
1044 
1045         uint256 newBalance = (address(this).balance - initialBalance);
1046 
1047         _addLiquidity(otherHalf, newBalance);
1048 
1049         emit SwapAndLiquify(half, newBalance, otherHalf);
1050     }
1051 
1052     function _swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
1053         address[] memory path = new address[](2);
1054         path[0] = address(this);
1055         path[1] = uniswapV2Router.WETH();
1056 
1057         _approve(address(this), address(uniswapV2Router), tokenAmount);
1058 
1059         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1060             tokenAmount,
1061             0,
1062             path,
1063             address(this),
1064             (block.timestamp + 300)
1065         );
1066     }
1067 
1068     function _addLiquidity(uint256 tokenAmount, uint256 ethAmount)
1069         private
1070         lockTheSwap
1071     {
1072         _approve(address(this), address(uniswapV2Router), tokenAmount);
1073 
1074         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1075             address(this),
1076             tokenAmount,
1077             0,
1078             0,
1079             owner(),
1080             block.timestamp
1081         );
1082     }
1083 
1084     function changeMarketingWallet(address newWallet)
1085         public
1086         onlyOwner
1087         returns (bool)
1088     {
1089         marketingWallet = newWallet;
1090         return true;
1091     }
1092 
1093     function changeTaxForLiquidityAndMarketing(uint256 _taxForLiquidity, uint256 _taxForMarketing)
1094         public
1095         onlyOwner
1096         returns (bool)
1097     {
1098         require((_taxForLiquidity+_taxForMarketing) <= 100, "ERC20: total tax must not be greater than 100");
1099         taxForLiquidity = _taxForLiquidity;
1100         taxForMarketing = _taxForMarketing;
1101 
1102         return true;
1103     }
1104 
1105     function changeMaxTxAmount(uint256 _maxTxAmount)
1106         public
1107         onlyOwner
1108         returns (bool)
1109     {
1110         maxTxAmount = _maxTxAmount;
1111 
1112         return true;
1113     }
1114 
1115     function changeMaxWalletAmount(uint256 _maxWalletAmount)
1116         public
1117         onlyOwner
1118         returns (bool)
1119     {
1120         maxWalletAmount = _maxWalletAmount;
1121 
1122         return true;
1123     }
1124 
1125     receive() external payable {}
1126 }