1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 interface IUniswapV2Factory {
5     event PairCreated(
6         address indexed token0,
7         address indexed token1,
8         address pair,
9         uint256
10     );
11 
12     function feeTo() external view returns (address);
13 
14     function feeToSetter() external view returns (address);
15 
16     function allPairsLength() external view returns (uint256);
17 
18     function getPair(address tokenA, address tokenB)
19         external
20         view
21         returns (address pair);
22 
23     function allPairs(uint256) external view returns (address pair);
24 
25     function createPair(address tokenA, address tokenB)
26         external
27         returns (address pair);
28 
29     function setFeeTo(address) external;
30 
31     function setFeeToSetter(address) external;
32 }
33 
34 interface IUniswapV2Pair {
35     event Approval(
36         address indexed owner,
37         address indexed spender,
38         uint256 value
39     );
40     event Transfer(address indexed from, address indexed to, uint256 value);
41 
42     function name() external pure returns (string memory);
43 
44     function symbol() external pure returns (string memory);
45 
46     function decimals() external pure returns (uint8);
47 
48     function totalSupply() external view returns (uint256);
49 
50     function balanceOf(address owner) external view returns (uint256);
51 
52     function allowance(address owner, address spender)
53         external
54         view
55         returns (uint256);
56 
57     function approve(address spender, uint256 value) external returns (bool);
58 
59     function transfer(address to, uint256 value) external returns (bool);
60 
61     function transferFrom(
62         address from,
63         address to,
64         uint256 value
65     ) external returns (bool);
66 
67     function DOMAIN_SEPARATOR() external view returns (bytes32);
68 
69     function PERMIT_TYPEHASH() external pure returns (bytes32);
70 
71     function nonces(address owner) external view returns (uint256);
72 
73     function permit(
74         address owner,
75         address spender,
76         uint256 value,
77         uint256 deadline,
78         uint8 v,
79         bytes32 r,
80         bytes32 s
81     ) external;
82 
83     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
84     event Burn(
85         address indexed sender,
86         uint256 amount0,
87         uint256 amount1,
88         address indexed to
89     );
90     event Swap(
91         address indexed sender,
92         uint256 amount0In,
93         uint256 amount1In,
94         uint256 amount0Out,
95         uint256 amount1Out,
96         address indexed to
97     );
98     event Sync(uint112 reserve0, uint112 reserve1);
99 
100     function MINIMUM_LIQUIDITY() external pure returns (uint256);
101 
102     function factory() external view returns (address);
103 
104     function token0() external view returns (address);
105 
106     function token1() external view returns (address);
107 
108     function getReserves()
109         external
110         view
111         returns (
112             uint112 reserve0,
113             uint112 reserve1,
114             uint32 blockTimestampLast
115         );
116 
117     function price0CumulativeLast() external view returns (uint256);
118 
119     function price1CumulativeLast() external view returns (uint256);
120 
121     function kLast() external view returns (uint256);
122 
123     function mint(address to) external returns (uint256 liquidity);
124 
125     function burn(address to)
126         external
127         returns (uint256 amount0, uint256 amount1);
128 
129     function swap(
130         uint256 amount0Out,
131         uint256 amount1Out,
132         address to,
133         bytes calldata data
134     ) external;
135 
136     function skim(address to) external;
137 
138     function sync() external;
139 
140     function initialize(address, address) external;
141 }
142 
143 interface IUniswapV2Router01 {
144     function factory() external pure returns (address);
145 
146     function WETH() external pure returns (address);
147 
148     function addLiquidity(
149         address tokenA,
150         address tokenB,
151         uint256 amountADesired,
152         uint256 amountBDesired,
153         uint256 amountAMin,
154         uint256 amountBMin,
155         address to,
156         uint256 deadline
157     )
158         external
159         returns (
160             uint256 amountA,
161             uint256 amountB,
162             uint256 liquidity
163         );
164 
165     function addLiquidityETH(
166         address token,
167         uint256 amountTokenDesired,
168         uint256 amountTokenMin,
169         uint256 amountETHMin,
170         address to,
171         uint256 deadline
172     )
173         external
174         payable
175         returns (
176             uint256 amountToken,
177             uint256 amountETH,
178             uint256 liquidity
179         );
180 
181     function removeLiquidity(
182         address tokenA,
183         address tokenB,
184         uint256 liquidity,
185         uint256 amountAMin,
186         uint256 amountBMin,
187         address to,
188         uint256 deadline
189     ) external returns (uint256 amountA, uint256 amountB);
190 
191     function removeLiquidityETH(
192         address token,
193         uint256 liquidity,
194         uint256 amountTokenMin,
195         uint256 amountETHMin,
196         address to,
197         uint256 deadline
198     ) external returns (uint256 amountToken, uint256 amountETH);
199 
200     function removeLiquidityWithPermit(
201         address tokenA,
202         address tokenB,
203         uint256 liquidity,
204         uint256 amountAMin,
205         uint256 amountBMin,
206         address to,
207         uint256 deadline,
208         bool approveMax,
209         uint8 v,
210         bytes32 r,
211         bytes32 s
212     ) external returns (uint256 amountA, uint256 amountB);
213 
214     function removeLiquidityETHWithPermit(
215         address token,
216         uint256 liquidity,
217         uint256 amountTokenMin,
218         uint256 amountETHMin,
219         address to,
220         uint256 deadline,
221         bool approveMax,
222         uint8 v,
223         bytes32 r,
224         bytes32 s
225     ) external returns (uint256 amountToken, uint256 amountETH);
226 
227     function swapExactTokensForTokens(
228         uint256 amountIn,
229         uint256 amountOutMin,
230         address[] calldata path,
231         address to,
232         uint256 deadline
233     ) external returns (uint256[] memory amounts);
234 
235     function swapTokensForExactTokens(
236         uint256 amountOut,
237         uint256 amountInMax,
238         address[] calldata path,
239         address to,
240         uint256 deadline
241     ) external returns (uint256[] memory amounts);
242 
243     function swapExactETHForTokens(
244         uint256 amountOutMin,
245         address[] calldata path,
246         address to,
247         uint256 deadline
248     ) external payable returns (uint256[] memory amounts);
249 
250     function swapTokensForExactETH(
251         uint256 amountOut,
252         uint256 amountInMax,
253         address[] calldata path,
254         address to,
255         uint256 deadline
256     ) external returns (uint256[] memory amounts);
257 
258     function swapExactTokensForETH(
259         uint256 amountIn,
260         uint256 amountOutMin,
261         address[] calldata path,
262         address to,
263         uint256 deadline
264     ) external returns (uint256[] memory amounts);
265 
266     function swapETHForExactTokens(
267         uint256 amountOut,
268         address[] calldata path,
269         address to,
270         uint256 deadline
271     ) external payable returns (uint256[] memory amounts);
272 
273     function quote(
274         uint256 amountA,
275         uint256 reserveA,
276         uint256 reserveB
277     ) external pure returns (uint256 amountB);
278 
279     function getAmountOut(
280         uint256 amountIn,
281         uint256 reserveIn,
282         uint256 reserveOut
283     ) external pure returns (uint256 amountOut);
284 
285     function getAmountIn(
286         uint256 amountOut,
287         uint256 reserveIn,
288         uint256 reserveOut
289     ) external pure returns (uint256 amountIn);
290 
291     function getAmountsOut(uint256 amountIn, address[] calldata path)
292         external
293         view
294         returns (uint256[] memory amounts);
295 
296     function getAmountsIn(uint256 amountOut, address[] calldata path)
297         external
298         view
299         returns (uint256[] memory amounts);
300 }
301 
302 interface IUniswapV2Router02 is IUniswapV2Router01 {
303     function removeLiquidityETHSupportingFeeOnTransferTokens(
304         address token,
305         uint256 liquidity,
306         uint256 amountTokenMin,
307         uint256 amountETHMin,
308         address to,
309         uint256 deadline
310     ) external returns (uint256 amountETH);
311 
312     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
313         address token,
314         uint256 liquidity,
315         uint256 amountTokenMin,
316         uint256 amountETHMin,
317         address to,
318         uint256 deadline,
319         bool approveMax,
320         uint8 v,
321         bytes32 r,
322         bytes32 s
323     ) external returns (uint256 amountETH);
324 
325     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
326         uint256 amountIn,
327         uint256 amountOutMin,
328         address[] calldata path,
329         address to,
330         uint256 deadline
331     ) external;
332 
333     function swapExactETHForTokensSupportingFeeOnTransferTokens(
334         uint256 amountOutMin,
335         address[] calldata path,
336         address to,
337         uint256 deadline
338     ) external payable;
339 
340     function swapExactTokensForETHSupportingFeeOnTransferTokens(
341         uint256 amountIn,
342         uint256 amountOutMin,
343         address[] calldata path,
344         address to,
345         uint256 deadline
346     ) external;
347 }
348 
349 /**
350  * @dev Interface of the ERC20 standard as defined in the EIP.
351  */
352 interface IERC20 {
353     /**
354      * @dev Emitted when `value` tokens are moved from one account (`from`) to
355      * another (`to`).
356      *
357      * Note that `value` may be zero.
358      */
359     event Transfer(address indexed from, address indexed to, uint256 value);
360 
361     /**
362      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
363      * a call to {approve}. `value` is the new allowance.
364      */
365     event Approval(
366         address indexed owner,
367         address indexed spender,
368         uint256 value
369     );
370 
371     /**
372      * @dev Returns the amount of tokens in existence.
373      */
374     function totalSupply() external view returns (uint256);
375 
376     /**
377      * @dev Returns the amount of tokens owned by `account`.
378      */
379     function balanceOf(address account) external view returns (uint256);
380 
381     /**
382      * @dev Moves `amount` tokens from the caller's account to `to`.
383      *
384      * Returns a boolean value indicating whether the operation succeeded.
385      *
386      * Emits a {Transfer} event.
387      */
388     function transfer(address to, uint256 amount) external returns (bool);
389 
390     /**
391      * @dev Returns the remaining number of tokens that `spender` will be
392      * allowed to spend on behalf of `owner` through {transferFrom}. This is
393      * zero by default.
394      *
395      * This value changes when {approve} or {transferFrom} are called.
396      */
397     function allowance(address owner, address spender)
398         external
399         view
400         returns (uint256);
401 
402     /**
403      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
404      *
405      * Returns a boolean value indicating whether the operation succeeded.
406      *
407      * IMPORTANT: Beware that changing an allowance with this method brings the risk
408      * that someone may use both the old and the new allowance by unfortunate
409      * transaction ordering. One possible solution to mitigate this race
410      * condition is to first reduce the spender's allowance to 0 and set the
411      * desired value afterwards:
412      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
413      *
414      * Emits an {Approval} event.
415      */
416     function approve(address spender, uint256 amount) external returns (bool);
417 
418     /**
419      * @dev Moves `amount` tokens from `from` to `to` using the
420      * allowance mechanism. `amount` is then deducted from the caller's
421      * allowance.
422      *
423      * Returns a boolean value indicating whether the operation succeeded.
424      *
425      * Emits a {Transfer} event.
426      */
427     function transferFrom(
428         address from,
429         address to,
430         uint256 amount
431     ) external returns (bool);
432 }
433 
434 /**
435  * @dev Interface for the optional metadata functions from the ERC20 standard.
436  *
437  * _Available since v4.1._
438  */
439 interface IERC20Metadata is IERC20 {
440     /**
441      * @dev Returns the name of the token.
442      */
443     function name() external view returns (string memory);
444 
445     /**
446      * @dev Returns the decimals places of the token.
447      */
448     function decimals() external view returns (uint8);
449 
450     /**
451      * @dev Returns the symbol of the token.
452      */
453     function symbol() external view returns (string memory);
454 }
455 
456 /**
457  * @dev Provides information about the current execution context, including the
458  * sender of the transaction and its data. While these are generally available
459  * via msg.sender and msg.data, they should not be accessed in such a direct
460  * manner, since when dealing with meta-transactions the account sending and
461  * paying for execution may not be the actual sender (as far as an application
462  * is concerned).
463  *
464  * This contract is only required for intermediate, library-like contracts.
465  */
466 abstract contract Context {
467     function _msgSender() internal view virtual returns (address) {
468         return msg.sender;
469     }
470 }
471 
472 /**
473  * @dev Contract module which provides a basic access control mechanism, where
474  * there is an account (an owner) that can be granted exclusive access to
475  * specific functions.
476  *
477  * By default, the owner account will be the one that deploys the contract. This
478  * can later be changed with {transferOwnership}.
479  *
480  * This module is used through inheritance. It will make available the modifier
481  * `onlyOwner`, which can be applied to your functions to restrict their use to
482  * the owner.
483  */
484 abstract contract Ownable is Context {
485     address private _owner;
486 
487     event OwnershipTransferred(
488         address indexed previousOwner,
489         address indexed newOwner
490     );
491 
492     /**
493      * @dev Initializes the contract setting the deployer as the initial owner.
494      */
495     constructor() {
496         _transferOwnership(_msgSender());
497     }
498 
499     /**
500      * @dev Throws if called by any account other than the owner.
501      */
502     modifier onlyOwner() {
503         _checkOwner();
504         _;
505     }
506 
507     /**
508      * @dev Returns the address of the current owner.
509      */
510     function owner() public view virtual returns (address) {
511         return _owner;
512     }
513 
514     /**
515      * @dev Throws if the sender is not the owner.
516      */
517     function _checkOwner() internal view virtual {
518         require(owner() == _msgSender(), "Ownable: caller is not the owner");
519     }
520 
521     /**
522      * @dev Leaves the contract without owner. It will not be possible to call
523      * `onlyOwner` functions anymore. Can only be called by the current owner.
524      *
525      * NOTE: Renouncing ownership will leave the contract without an owner,
526      * thereby removing any functionality that is only available to the owner.
527      */
528     function renounceOwnership() public virtual onlyOwner {
529         _transferOwnership(address(0));
530     }
531 
532     /**
533      * @dev Transfers ownership of the contract to a new account (`newOwner`).
534      * Can only be called by the current owner.
535      */
536     function transferOwnership(address newOwner) public virtual onlyOwner {
537         require(
538             newOwner != address(0),
539             "Ownable: new owner is the zero address"
540         );
541         _transferOwnership(newOwner);
542     }
543 
544     /**
545      * @dev Transfers ownership of the contract to a new account (`newOwner`).
546      * Internal function without access restriction.
547      */
548     function _transferOwnership(address newOwner) internal virtual {
549         address oldOwner = _owner;
550         _owner = newOwner;
551         emit OwnershipTransferred(oldOwner, newOwner);
552     }
553 }
554 
555 /**
556  * @dev Implementation of the {IERC20} interface.
557  *
558  * This implementation is agnostic to the way tokens are created. This means
559  * that a supply mechanism has to be added in a derived contract using {_mint}.
560  * For a generic mechanism see {ERC20PresetMinterPauser}.
561  *
562  * TIP: For a detailed writeup see our guide
563  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
564  * to implement supply mechanisms].
565  *
566  * We have followed general OpenZeppelin Contracts guidelines: functions revert
567  * instead returning `false` on failure. This behavior is nonetheless
568  * conventional and does not conflict with the expectations of ERC20
569  * applications.
570  *
571  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
572  * This allows applications to reconstruct the allowance for all accounts just
573  * by listening to said events. Other implementations of the EIP may not emit
574  * these events, as it isn't required by the specification.
575  *
576  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
577  * functions have been added to mitigate the well-known issues around setting
578  * allowances. See {IERC20-approve}.
579  */
580 contract ERC20 is Context, IERC20, IERC20Metadata {
581     mapping(address => uint256) private _balances;
582     mapping(address => mapping(address => uint256)) private _allowances;
583 
584     uint256 internal _totalSupply;
585 
586     string private _name;
587     string private _symbol;
588 
589     constructor(string memory name_, string memory symbol_) {
590         _name = name_;
591         _symbol = symbol_;
592     }
593 
594     /**
595      * @dev Returns the name of the token.
596      */
597     function name() external view virtual override returns (string memory) {
598         return _name;
599     }
600 
601     /**
602      * @dev Returns the symbol of the token, usually a shorter version of the
603      * name.
604      */
605     function symbol() external view virtual override returns (string memory) {
606         return _symbol;
607     }
608 
609     /**
610      * @dev See {IERC20-balanceOf}.
611      */
612     function balanceOf(address account)
613         public
614         view
615         virtual
616         override
617         returns (uint256)
618     {
619         return _balances[account];
620     }
621 
622     /**
623      * @dev Returns the number of decimals used to get its user representation.
624      * For example, if `decimals` equals `2`, a balance of `505` tokens should
625      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
626      *
627      * Tokens usually opt for a value of 18, imitating the relationship between
628      * Ether and Wei. This is the value {ERC20} uses, unless this function is
629      * overridden;
630      *
631      * NOTE: This information is only used for _display_ purposes: it in
632      * no way affects any of the arithmetic of the contract, including
633      * {IERC20-balanceOf} and {IERC20-transfer}.
634      */
635     function decimals() public view virtual override returns (uint8) {
636         return 18;
637     }
638 
639     /**
640      * @dev See {IERC20-totalSupply}.
641      */
642     function totalSupply() external view virtual override returns (uint256) {
643         return _totalSupply;
644     }
645 
646     /**
647      * @dev See {IERC20-allowance}.
648      */
649     function allowance(address owner, address spender)
650         public
651         view
652         virtual
653         override
654         returns (uint256)
655     {
656         return _allowances[owner][spender];
657     }
658 
659     /**
660      * @dev See {IERC20-transfer}.
661      *
662      * Requirements:
663      *
664      * - `to` cannot be the zero address.
665      * - the caller must have a balance of at least `amount`.
666      */
667     function transfer(address to, uint256 amount)
668         external
669         virtual
670         override
671         returns (bool)
672     {
673         address owner = _msgSender();
674         _transfer(owner, to, amount);
675         return true;
676     }
677 
678     /**
679      * @dev See {IERC20-approve}.
680      *
681      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
682      * `transferFrom`. This is semantically equivalent to an infinite approval.
683      *
684      * Requirements:
685      *
686      * - `spender` cannot be the zero address.
687      */
688     function approve(address spender, uint256 amount)
689         external
690         virtual
691         override
692         returns (bool)
693     {
694         address owner = _msgSender();
695         _approve(owner, spender, amount);
696         return true;
697     }
698 
699     /**
700      * @dev See {IERC20-transferFrom}.
701      *
702      * Emits an {Approval} event indicating the updated allowance. This is not
703      * required by the EIP. See the note at the beginning of {ERC20}.
704      *
705      * NOTE: Does not update the allowance if the current allowance
706      * is the maximum `uint256`.
707      *
708      * Requirements:
709      *
710      * - `from` and `to` cannot be the zero address.
711      * - `from` must have a balance of at least `amount`.
712      * - the caller must have allowance for ``from``'s tokens of at least
713      * `amount`.
714      */
715     function transferFrom(
716         address from,
717         address to,
718         uint256 amount
719     ) external virtual override returns (bool) {
720         address spender = _msgSender();
721         _spendAllowance(from, spender, amount);
722         _transfer(from, to, amount);
723         return true;
724     }
725 
726     /**
727      * @dev Atomically decreases the allowance granted to `spender` by the caller.
728      *
729      * This is an alternative to {approve} that can be used as a mitigation for
730      * problems described in {IERC20-approve}.
731      *
732      * Emits an {Approval} event indicating the updated allowance.
733      *
734      * Requirements:
735      *
736      * - `spender` cannot be the zero address.
737      * - `spender` must have allowance for the caller of at least
738      * `subtractedValue`.
739      */
740     function decreaseAllowance(address spender, uint256 subtractedValue)
741         external
742         virtual
743         returns (bool)
744     {
745         address owner = _msgSender();
746         uint256 currentAllowance = allowance(owner, spender);
747         require(
748             currentAllowance >= subtractedValue,
749             "ERC20: decreased allowance below zero"
750         );
751         unchecked {
752             _approve(owner, spender, currentAllowance - subtractedValue);
753         }
754 
755         return true;
756     }
757 
758     /**
759      * @dev Atomically increases the allowance granted to `spender` by the caller.
760      *
761      * This is an alternative to {approve} that can be used as a mitigation for
762      * problems described in {IERC20-approve}.
763      *
764      * Emits an {Approval} event indicating the updated allowance.
765      *
766      * Requirements:
767      *
768      * - `spender` cannot be the zero address.
769      */
770     function increaseAllowance(address spender, uint256 addedValue)
771         external
772         virtual
773         returns (bool)
774     {
775         address owner = _msgSender();
776         _approve(owner, spender, allowance(owner, spender) + addedValue);
777         return true;
778     }
779 
780     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
781      * the total supply.
782      *
783      * Emits a {Transfer} event with `from` set to the zero address.
784      *
785      * Requirements:
786      *
787      * - `account` cannot be the zero address.
788      */
789     function _mint(address account, uint256 amount) internal virtual {
790         require(account != address(0), "ERC20: mint to the zero address");
791 
792         _totalSupply += amount;
793         unchecked {
794             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
795             _balances[account] += amount;
796         }
797         emit Transfer(address(0), account, amount);
798     }
799 
800     /**
801      * @dev Destroys `amount` tokens from `account`, reducing the
802      * total supply.
803      *
804      * Emits a {Transfer} event with `to` set to the zero address.
805      *
806      * Requirements:
807      *
808      * - `account` cannot be the zero address.
809      * - `account` must have at least `amount` tokens.
810      */
811     function _burn(address account, uint256 amount) internal virtual {
812         require(account != address(0), "ERC20: burn from the zero address");
813 
814         uint256 accountBalance = _balances[account];
815         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
816         unchecked {
817             _balances[account] = accountBalance - amount;
818             // Overflow not possible: amount <= accountBalance <= totalSupply.
819             _totalSupply -= amount;
820         }
821 
822         emit Transfer(account, address(0), amount);
823     }
824 
825     /**
826      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
827      *
828      * This internal function is equivalent to `approve`, and can be used to
829      * e.g. set automatic allowances for certain subsystems, etc.
830      *
831      * Emits an {Approval} event.
832      *
833      * Requirements:
834      *
835      * - `owner` cannot be the zero address.
836      * - `spender` cannot be the zero address.
837      */
838     function _approve(
839         address owner,
840         address spender,
841         uint256 amount
842     ) internal virtual {
843         require(owner != address(0), "ERC20: approve from the zero address");
844         require(spender != address(0), "ERC20: approve to the zero address");
845 
846         _allowances[owner][spender] = amount;
847         emit Approval(owner, spender, amount);
848     }
849 
850     /**
851      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
852      *
853      * Does not update the allowance amount in case of infinite allowance.
854      * Revert if not enough allowance is available.
855      *
856      * Might emit an {Approval} event.
857      */
858     function _spendAllowance(
859         address owner,
860         address spender,
861         uint256 amount
862     ) internal virtual {
863         uint256 currentAllowance = allowance(owner, spender);
864         if (currentAllowance != type(uint256).max) {
865             require(
866                 currentAllowance >= amount,
867                 "ERC20: insufficient allowance"
868             );
869             unchecked {
870                 _approve(owner, spender, currentAllowance - amount);
871             }
872         }
873     }
874 
875     function _transfer(
876         address from,
877         address to,
878         uint256 amount
879     ) internal virtual {
880         require(from != address(0), "ERC20: transfer from the zero address");
881         require(to != address(0), "ERC20: transfer to the zero address");
882 
883         uint256 fromBalance = _balances[from];
884         require(
885             fromBalance >= amount,
886             "ERC20: transfer amount exceeds balance"
887         );
888         unchecked {
889             _balances[from] = fromBalance - amount;
890             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
891             // decrementing then incrementing.
892             _balances[to] += amount;
893         }
894 
895         emit Transfer(from, to, amount);
896     }
897 }
898 
899 /**
900  * @dev Implementation of the {IERC20} interface.
901  *
902  * This implementation is agnostic to the way tokens are created. This means
903  * that a supply mechanism has to be added in a derived contract using {_mint}.
904  * For a generic mechanism see {ERC20PresetMinterPauser}.
905  *
906  * TIP: For a detailed writeup see our guide
907  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
908  * to implement supply mechanisms].
909  *
910  * We have followed general OpenZeppelin Contracts guidelines: functions revert
911  * instead returning `false` on failure. This behavior is nonetheless
912  * conventional and does not conflict with the expectations of ERC20
913  * applications.
914  *
915  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
916  * This allows applications to reconstruct the allowance for all accounts just
917  * by listening to said events. Other implementations of the EIP may not emit
918  * these events, as it isn't required by the specification.
919  *
920  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
921  * functions have been added to mitigate the well-known issues around setting
922  * allowances. See {IERC20-approve}.
923  */
924 contract iF is ERC20, Ownable {
925     // TOKENOMICS START ==========================================================>
926     string private _name = "iF Protocol";
927     string private _symbol = "iF";
928     uint8 private _decimals = 18;
929     uint256 private _supply = 1000000000;
930 
931     uint256 public buyTaxForLiquidity = 1;
932     uint256 public buyTaxForMarketing = 3;
933     uint256 public buyTaxForBurning = 1;
934     uint256 public sellTaxForLiquidity = 1;
935     uint256 public sellTaxForMarketing = 3;
936     uint256 public sellTaxForBurning = 1;
937 
938     address public marketingWallet = 0xa593d811c49381b164f447ace27A5F17a77138F5;
939 
940     uint256 public maxTxAmount = 10000000 * 10**_decimals;
941     uint256 public maxWalletAmount = 10000000 * 10**_decimals;
942     uint256 private _numTokensSellToAddToLiquidity = 900000 * 10**_decimals;
943     uint256 private _numTokensSellToAddToETH = 750000 * 10**_decimals;
944     // TOKENOMICS END ============================================================>
945 
946     IUniswapV2Router02 public immutable uniswapV2Router;
947     address public immutable uniswapV2Pair;
948     address _burnAddress = 0x000000000000000000000000000000000000dEaD;
949     uint256 private _marketingReserves = 0;
950     mapping(address => bool) private _isExcludedFromFee;
951     bool inSwapAndLiquify;
952 
953     event SwapAndLiquify(
954         uint256 tokensSwapped,
955         uint256 ethReceived,
956         uint256 tokensIntoLiqudity
957     );
958 
959     modifier lockTheSwap() {
960         inSwapAndLiquify = true;
961         _;
962         inSwapAndLiquify = false;
963     }
964 
965     /**
966      * @dev Sets the values for {name} and {symbol}.
967      *
968      * The default value of {decimals} is 18. To select a different value for
969      * {decimals} you should overload it.
970      *
971      * All two of these values are immutable: they can only be set once during
972      * construction.
973      */
974     constructor() ERC20(_name, _symbol) {
975         _mint(msg.sender, (_supply * 10**_decimals));
976 
977         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
978             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
979         );
980         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
981             .createPair(address(this), _uniswapV2Router.WETH());
982 
983         uniswapV2Router = _uniswapV2Router;
984 
985         _isExcludedFromFee[address(uniswapV2Router)] = true;
986         _isExcludedFromFee[msg.sender] = true;
987         _isExcludedFromFee[marketingWallet] = true;
988     }
989 
990     /**
991      * @dev Moves `amount` of tokens from `from` to `to`.
992      *
993      * This internal function is equivalent to {transfer}, and can be used to
994      * e.g. implement automatic token fees, slashing mechanisms, etc.
995      *
996      * Emits a {Transfer} event.
997      *
998      * Requirements:
999      *
1000      *
1001      * - `from` cannot be the zero address.
1002      * - `to` cannot be the zero address.
1003      * - `from` must have a balance of at least `amount`.
1004      */
1005     function _transfer(
1006         address from,
1007         address to,
1008         uint256 amount
1009     ) internal override {
1010         require(from != address(0), "ERC20: transfer from the zero address");
1011         require(to != address(0), "ERC20: transfer to the zero address");
1012         require(
1013             balanceOf(from) >= amount,
1014             "ERC20: transfer amount exceeds balance"
1015         );
1016 
1017         if (
1018             (from == uniswapV2Pair || to == uniswapV2Pair) && !inSwapAndLiquify
1019         ) {
1020             if (from != uniswapV2Pair) {
1021                 uint256 contractLiquidityBalance = balanceOf(address(this)) -
1022                     _marketingReserves;
1023                 if (
1024                     contractLiquidityBalance >= _numTokensSellToAddToLiquidity
1025                 ) {
1026                     _swapAndLiquify(_numTokensSellToAddToLiquidity);
1027                 }
1028                 if ((_marketingReserves) >= _numTokensSellToAddToETH) {
1029                     _swapTokensForEth(_numTokensSellToAddToETH);
1030                     _marketingReserves -= _numTokensSellToAddToETH;
1031                     bool sent = payable(marketingWallet).send(
1032                         address(this).balance
1033                     );
1034                     require(sent, "Failed to send ETH");
1035                 }
1036             }
1037 
1038             uint256 transferAmount;
1039             if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
1040                 transferAmount = amount;
1041             } else {
1042                 require(
1043                     amount <= maxTxAmount,
1044                     "ERC20: transfer amount exceeds the max transaction amount"
1045                 );
1046 
1047                 uint256 marketingShare;
1048                 uint256 liquidityShare;
1049                 uint256 burningShare;
1050 
1051                 if (from == uniswapV2Pair) {
1052                     require(
1053                         (amount + balanceOf(to)) <= maxWalletAmount,
1054                         "ERC20: balance amount exceeded max wallet amount limit"
1055                     );
1056 
1057                     marketingShare = ((amount * buyTaxForMarketing) / 100);
1058                     liquidityShare = ((amount * buyTaxForLiquidity) / 100);
1059                     burningShare = ((amount * buyTaxForBurning) / 100);
1060                 } else {
1061                     marketingShare = ((amount * sellTaxForMarketing) / 100);
1062                     liquidityShare = ((amount * sellTaxForLiquidity) / 100);
1063                     burningShare = ((amount * sellTaxForBurning) / 100);
1064                 }
1065                 transferAmount =
1066                     amount -
1067                     (marketingShare + liquidityShare + burningShare);
1068                 _marketingReserves += marketingShare;
1069                 _totalSupply -= burningShare;
1070 
1071                 if ((marketingShare + liquidityShare) > 0) {
1072                     super._transfer(
1073                         from,
1074                         address(this),
1075                         (marketingShare + liquidityShare)
1076                     );
1077                 }
1078                 if (burningShare > 0) {
1079                     super._transfer(from, _burnAddress, burningShare);
1080                 }
1081             }
1082             super._transfer(from, to, transferAmount);
1083         } else {
1084             super._transfer(from, to, amount);
1085         }
1086     }
1087 
1088     function _swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1089         uint256 half = (contractTokenBalance / 2);
1090         uint256 otherHalf = (contractTokenBalance - half);
1091 
1092         uint256 initialBalance = address(this).balance;
1093 
1094         _swapTokensForEth(half);
1095 
1096         uint256 newBalance = (address(this).balance - initialBalance);
1097 
1098         _addLiquidity(otherHalf, newBalance);
1099 
1100         emit SwapAndLiquify(half, newBalance, otherHalf);
1101     }
1102 
1103     function _swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
1104         address[] memory path = new address[](2);
1105         path[0] = address(this);
1106         path[1] = uniswapV2Router.WETH();
1107 
1108         _approve(address(this), address(uniswapV2Router), tokenAmount);
1109 
1110         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1111             tokenAmount,
1112             0,
1113             path,
1114             address(this),
1115             (block.timestamp + 300)
1116         );
1117     }
1118 
1119     function _addLiquidity(uint256 tokenAmount, uint256 ethAmount)
1120         private
1121         lockTheSwap
1122     {
1123         _approve(address(this), address(uniswapV2Router), tokenAmount);
1124 
1125         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1126             address(this),
1127             tokenAmount,
1128             0,
1129             0,
1130             owner(),
1131             block.timestamp
1132         );
1133     }
1134 
1135     /**
1136      * @dev Returns the number of decimals used to get its user representation.
1137      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1138      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
1139      *
1140      * Tokens usually opt for a value of 18, imitating the relationship between
1141      * Ether and Wei. This is the value {ERC20} uses, unless this function is
1142      * overridden;
1143      *
1144      * NOTE: This information is only used for _display_ purposes: it in
1145      * no way affects any of the arithmetic of the contract, including
1146      * {IERC20-balanceOf} and {IERC20-transfer}.
1147      */
1148     function decimals() public view override returns (uint8) {
1149         return _decimals;
1150     }
1151 
1152     function changeMarketingWallet(address newWallet)
1153         public
1154         onlyOwner
1155         returns (bool)
1156     {
1157         marketingWallet = newWallet;
1158         return true;
1159     }
1160 
1161     function changeBuyTaxForLiquidityMarketingBurning(
1162         uint256 _buyTaxForLiquidity,
1163         uint256 _buyTaxForMarketing,
1164         uint256 _buyTaxForBurning
1165     ) public onlyOwner returns (bool) {
1166         require(
1167             (_buyTaxForLiquidity + _buyTaxForMarketing + _buyTaxForBurning) <=
1168                 100,
1169             "ERC20: total tax must not be greater than 100"
1170         );
1171         buyTaxForLiquidity = _buyTaxForLiquidity;
1172         buyTaxForMarketing = _buyTaxForMarketing;
1173         buyTaxForBurning = _buyTaxForBurning;
1174 
1175         return true;
1176     }
1177 
1178     function changeSellTaxForLiquidityMarketingBurning(
1179         uint256 _sellTaxForLiquidity,
1180         uint256 _sellTaxForMarketing,
1181         uint256 _sellTaxForBurning
1182     ) public onlyOwner returns (bool) {
1183         require(
1184             (_sellTaxForLiquidity +
1185                 _sellTaxForMarketing +
1186                 _sellTaxForBurning) <= 100,
1187             "ERC20: total tax must not be greater than 100"
1188         );
1189         sellTaxForLiquidity = _sellTaxForLiquidity;
1190         sellTaxForMarketing = _sellTaxForMarketing;
1191         sellTaxForBurning = _sellTaxForBurning;
1192 
1193         return true;
1194     }
1195 
1196     function changeMaxTxAmount(uint256 _maxTxAmount)
1197         public
1198         onlyOwner
1199         returns (bool)
1200     {
1201         maxTxAmount = _maxTxAmount;
1202 
1203         return true;
1204     }
1205 
1206     function changeMaxWalletAmount(uint256 _maxWalletAmount)
1207         public
1208         onlyOwner
1209         returns (bool)
1210     {
1211         maxWalletAmount = _maxWalletAmount;
1212 
1213         return true;
1214     }
1215 
1216     receive() external payable {}
1217 }