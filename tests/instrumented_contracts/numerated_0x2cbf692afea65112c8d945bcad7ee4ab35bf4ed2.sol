1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.16;
4 
5 interface IUniswapV2Factory {
6     event PairCreated(
7         address indexed token0,
8         address indexed token1,
9         address pair,
10         uint256
11     );
12 
13     function feeTo() external view returns (address);
14 
15     function feeToSetter() external view returns (address);
16 
17     function allPairsLength() external view returns (uint256);
18 
19     function getPair(address tokenA, address tokenB)
20         external
21         view
22         returns (address pair);
23 
24     function allPairs(uint256) external view returns (address pair);
25 
26     function createPair(address tokenA, address tokenB)
27         external
28         returns (address pair);
29 
30     function setFeeTo(address) external;
31 
32     function setFeeToSetter(address) external;
33 }
34 
35 interface IUniswapV2Pair {
36     event Approval(
37         address indexed owner,
38         address indexed spender,
39         uint256 value
40     );
41     event Transfer(address indexed from, address indexed to, uint256 value);
42 
43     function name() external pure returns (string memory);
44 
45     function symbol() external pure returns (string memory);
46 
47     function decimals() external pure returns (uint8);
48 
49     function totalSupply() external view returns (uint256);
50 
51     function balanceOf(address owner) external view returns (uint256);
52 
53     function allowance(address owner, address spender)
54         external
55         view
56         returns (uint256);
57 
58     function approve(address spender, uint256 value) external returns (bool);
59 
60     function transfer(address to, uint256 value) external returns (bool);
61 
62     function transferFrom(
63         address from,
64         address to,
65         uint256 value
66     ) external returns (bool);
67 
68     function DOMAIN_SEPARATOR() external view returns (bytes32);
69 
70     function PERMIT_TYPEHASH() external pure returns (bytes32);
71 
72     function nonces(address owner) external view returns (uint256);
73 
74     function permit(
75         address owner,
76         address spender,
77         uint256 value,
78         uint256 deadline,
79         uint8 v,
80         bytes32 r,
81         bytes32 s
82     ) external;
83 
84     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
85     event Burn(
86         address indexed sender,
87         uint256 amount0,
88         uint256 amount1,
89         address indexed to
90     );
91     event Swap(
92         address indexed sender,
93         uint256 amount0In,
94         uint256 amount1In,
95         uint256 amount0Out,
96         uint256 amount1Out,
97         address indexed to
98     );
99     event Sync(uint112 reserve0, uint112 reserve1);
100 
101     function MINIMUM_LIQUIDITY() external pure returns (uint256);
102 
103     function factory() external view returns (address);
104 
105     function token0() external view returns (address);
106 
107     function token1() external view returns (address);
108 
109     function getReserves()
110         external
111         view
112         returns (
113             uint112 reserve0,
114             uint112 reserve1,
115             uint32 blockTimestampLast
116         );
117 
118     function price0CumulativeLast() external view returns (uint256);
119 
120     function price1CumulativeLast() external view returns (uint256);
121 
122     function kLast() external view returns (uint256);
123 
124     function mint(address to) external returns (uint256 liquidity);
125 
126     function burn(address to)
127         external
128         returns (uint256 amount0, uint256 amount1);
129 
130     function swap(
131         uint256 amount0Out,
132         uint256 amount1Out,
133         address to,
134         bytes calldata data
135     ) external;
136 
137     function skim(address to) external;
138 
139     function sync() external;
140 
141     function initialize(address, address) external;
142 }
143 
144 interface IUniswapV2Router01 {
145     function factory() external pure returns (address);
146 
147     function WETH() external pure returns (address);
148 
149     function addLiquidity(
150         address tokenA,
151         address tokenB,
152         uint256 amountADesired,
153         uint256 amountBDesired,
154         uint256 amountAMin,
155         uint256 amountBMin,
156         address to,
157         uint256 deadline
158     )
159         external
160         returns (
161             uint256 amountA,
162             uint256 amountB,
163             uint256 liquidity
164         );
165 
166     function addLiquidityETH(
167         address token,
168         uint256 amountTokenDesired,
169         uint256 amountTokenMin,
170         uint256 amountETHMin,
171         address to,
172         uint256 deadline
173     )
174         external
175         payable
176         returns (
177             uint256 amountToken,
178             uint256 amountETH,
179             uint256 liquidity
180         );
181 
182     function removeLiquidity(
183         address tokenA,
184         address tokenB,
185         uint256 liquidity,
186         uint256 amountAMin,
187         uint256 amountBMin,
188         address to,
189         uint256 deadline
190     ) external returns (uint256 amountA, uint256 amountB);
191 
192     function removeLiquidityETH(
193         address token,
194         uint256 liquidity,
195         uint256 amountTokenMin,
196         uint256 amountETHMin,
197         address to,
198         uint256 deadline
199     ) external returns (uint256 amountToken, uint256 amountETH);
200 
201     function removeLiquidityWithPermit(
202         address tokenA,
203         address tokenB,
204         uint256 liquidity,
205         uint256 amountAMin,
206         uint256 amountBMin,
207         address to,
208         uint256 deadline,
209         bool approveMax,
210         uint8 v,
211         bytes32 r,
212         bytes32 s
213     ) external returns (uint256 amountA, uint256 amountB);
214 
215     function removeLiquidityETHWithPermit(
216         address token,
217         uint256 liquidity,
218         uint256 amountTokenMin,
219         uint256 amountETHMin,
220         address to,
221         uint256 deadline,
222         bool approveMax,
223         uint8 v,
224         bytes32 r,
225         bytes32 s
226     ) external returns (uint256 amountToken, uint256 amountETH);
227 
228     function swapExactTokensForTokens(
229         uint256 amountIn,
230         uint256 amountOutMin,
231         address[] calldata path,
232         address to,
233         uint256 deadline
234     ) external returns (uint256[] memory amounts);
235 
236     function swapTokensForExactTokens(
237         uint256 amountOut,
238         uint256 amountInMax,
239         address[] calldata path,
240         address to,
241         uint256 deadline
242     ) external returns (uint256[] memory amounts);
243 
244     function swapExactETHForTokens(
245         uint256 amountOutMin,
246         address[] calldata path,
247         address to,
248         uint256 deadline
249     ) external payable returns (uint256[] memory amounts);
250 
251     function swapTokensForExactETH(
252         uint256 amountOut,
253         uint256 amountInMax,
254         address[] calldata path,
255         address to,
256         uint256 deadline
257     ) external returns (uint256[] memory amounts);
258 
259     function swapExactTokensForETH(
260         uint256 amountIn,
261         uint256 amountOutMin,
262         address[] calldata path,
263         address to,
264         uint256 deadline
265     ) external returns (uint256[] memory amounts);
266 
267     function swapETHForExactTokens(
268         uint256 amountOut,
269         address[] calldata path,
270         address to,
271         uint256 deadline
272     ) external payable returns (uint256[] memory amounts);
273 
274     function quote(
275         uint256 amountA,
276         uint256 reserveA,
277         uint256 reserveB
278     ) external pure returns (uint256 amountB);
279 
280     function getAmountOut(
281         uint256 amountIn,
282         uint256 reserveIn,
283         uint256 reserveOut
284     ) external pure returns (uint256 amountOut);
285 
286     function getAmountIn(
287         uint256 amountOut,
288         uint256 reserveIn,
289         uint256 reserveOut
290     ) external pure returns (uint256 amountIn);
291 
292     function getAmountsOut(uint256 amountIn, address[] calldata path)
293         external
294         view
295         returns (uint256[] memory amounts);
296 
297     function getAmountsIn(uint256 amountOut, address[] calldata path)
298         external
299         view
300         returns (uint256[] memory amounts);
301 }
302 
303 interface IUniswapV2Router02 is IUniswapV2Router01 {
304     function removeLiquidityETHSupportingFeeOnTransferTokens(
305         address token,
306         uint256 liquidity,
307         uint256 amountTokenMin,
308         uint256 amountETHMin,
309         address to,
310         uint256 deadline
311     ) external returns (uint256 amountETH);
312 
313     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
314         address token,
315         uint256 liquidity,
316         uint256 amountTokenMin,
317         uint256 amountETHMin,
318         address to,
319         uint256 deadline,
320         bool approveMax,
321         uint8 v,
322         bytes32 r,
323         bytes32 s
324     ) external returns (uint256 amountETH);
325 
326     function swapExactETHForTokensSupportingFeeOnTransferTokens(
327         uint256 amountOutMin,
328         address[] calldata path,
329         address to,
330         uint256 deadline
331     ) external payable;
332 
333     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
334         uint256 amountIn,
335         uint256 amountOutMin,
336         address[] calldata path,
337         address to,
338         uint256 deadline
339     ) external;
340 
341     function swapExactTokensForETHSupportingFeeOnTransferTokens(
342         uint256 amountIn,
343         uint256 amountOutMin,
344         address[] calldata path,
345         address to,
346         uint256 deadline
347     ) external;
348 }
349 
350 /**
351  * @dev Interface of the ERC20 standard as defined in the EIP.
352  */
353 interface IERC20 {
354     /**
355      * @dev Emitted when `value` tokens are moved from one account (`from`) to
356      * another (`to`).
357      *
358      * Note that `value` may be zero.
359      */
360     event Transfer(address indexed from, address indexed to, uint256 value);
361 
362     /**
363      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
364      * a call to {approve}. `value` is the new allowance.
365      */
366     event Approval(
367         address indexed owner,
368         address indexed spender,
369         uint256 value
370     );
371 
372     /**
373      * @dev Returns the amount of tokens in existence.
374      */
375     function totalSupply() external view returns (uint256);
376 
377     /**
378      * @dev Returns the amount of tokens owned by `account`.
379      */
380     function balanceOf(address account) external view returns (uint256);
381 
382     /**
383      * @dev Moves `amount` tokens from the caller's account to `to`.
384      *
385      * Returns a boolean value indicating whether the operation succeeded.
386      *
387      * Emits a {Transfer} event.
388      */
389     function transfer(address to, uint256 amount) external returns (bool);
390 
391     /**
392      * @dev Returns the remaining number of tokens that `spender` will be
393      * allowed to spend on behalf of `owner` through {transferFrom}. This is
394      * zero by default.
395      *
396      * This value changes when {approve} or {transferFrom} are called.
397      */
398     function allowance(address owner, address spender)
399         external
400         view
401         returns (uint256);
402 
403     /**
404      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
405      *
406      * Returns a boolean value indicating whether the operation succeeded.
407      *
408      * IMPORTANT: Beware that changing an allowance with this method brings the risk
409      * that someone may use both the old and the new allowance by unfortunate
410      * transaction ordering. One possible solution to mitigate this race
411      * condition is to first reduce the spender's allowance to 0 and set the
412      * desired value afterwards:
413      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
414      *
415      * Emits an {Approval} event.
416      */
417     function approve(address spender, uint256 amount) external returns (bool);
418 
419     /**
420      * @dev Moves `amount` tokens from `from` to `to` using the
421      * allowance mechanism. `amount` is then deducted from the caller's
422      * allowance.
423      *
424      * Returns a boolean value indicating whether the operation succeeded.
425      *
426      * Emits a {Transfer} event.
427      */
428     function transferFrom(
429         address from,
430         address to,
431         uint256 amount
432     ) external returns (bool);
433 }
434 
435 /**
436  * @dev Interface for the optional metadata functions from the ERC20 standard.
437  *
438  * _Available since v4.1._
439  */
440 interface IERC20Metadata is IERC20 {
441     /**
442      * @dev Returns the name of the token.
443      */
444     function name() external view returns (string memory);
445 
446     /**
447      * @dev Returns the decimals places of the token.
448      */
449     function decimals() external view returns (uint8);
450 
451     /**
452      * @dev Returns the symbol of the token.
453      */
454     function symbol() external view returns (string memory);
455 }
456 
457 /**
458  * @dev Provides information about the current execution context, including the
459  * sender of the transaction and its data. While these are generally available
460  * via msg.sender and msg.data, they should not be accessed in such a direct
461  * manner, since when dealing with meta-transactions the account sending and
462  * paying for execution may not be the actual sender (as far as an application
463  * is concerned).
464  *
465  * This contract is only required for intermediate, library-like contracts.
466  */
467 abstract contract Context {
468     function _msgSender() internal view virtual returns (address) {
469         return msg.sender;
470     }
471 }
472 
473 /**
474  * @dev Contract module which provides a basic access control mechanism, where
475  * there is an account (an owner) that can be granted exclusive access to
476  * specific functions.
477  *
478  * By default, the owner account will be the one that deploys the contract. This
479  * can later be changed with {transferOwnership}.
480  *
481  * This module is used through inheritance. It will make available the modifier
482  * `onlyOwner`, which can be applied to your functions to restrict their use to
483  * the owner.
484  */
485 abstract contract Ownable is Context {
486     address private _owner;
487 
488     event OwnershipTransferred(
489         address indexed previousOwner,
490         address indexed newOwner
491     );
492 
493     /**
494      * @dev Initializes the contract setting the deployer as the initial owner.
495      */
496     constructor() {
497         _transferOwnership(_msgSender());
498     }
499 
500     /**
501      * @dev Throws if called by any account other than the owner.
502      */
503     modifier onlyOwner() {
504         _checkOwner();
505         _;
506     }
507 
508     /**
509      * @dev Returns the address of the current owner.
510      */
511     function owner() public view virtual returns (address) {
512         return _owner;
513     }
514 
515     /**
516      * @dev Throws if the sender is not the owner.
517      */
518     function _checkOwner() internal view virtual {
519         require(owner() == _msgSender(), "Ownable: caller is not the owner");
520     }
521 
522     /**
523      * @dev Leaves the contract without owner. It will not be possible to call
524      * `onlyOwner` functions anymore. Can only be called by the current owner.
525      *
526      * NOTE: Renouncing ownership will leave the contract without an owner,
527      * thereby removing any functionality that is only available to the owner.
528      */
529     function renounceOwnership() public virtual onlyOwner {
530         _transferOwnership(address(0));
531     }
532 
533     /**
534      * @dev Transfers ownership of the contract to a new account (`newOwner`).
535      * Can only be called by the current owner.
536      */
537     function transferOwnership(address newOwner) public virtual onlyOwner {
538         require(
539             newOwner != address(0),
540             "Ownable: new owner is the zero address"
541         );
542         _transferOwnership(newOwner);
543     }
544 
545     /**
546      * @dev Transfers ownership of the contract to a new account (`newOwner`).
547      * Internal function without access restriction.
548      */
549     function _transferOwnership(address newOwner) internal virtual {
550         address oldOwner = _owner;
551         _owner = newOwner;
552         emit OwnershipTransferred(oldOwner, newOwner);
553     }
554 }
555 
556 /**
557  * @dev Implementation of the {IERC20} interface.
558  *
559  * This implementation is agnostic to the way tokens are created. This means
560  * that a supply mechanism has to be added in a derived contract using {_mint}.
561  * For a generic mechanism see {ERC20PresetMinterPauser}.
562  *
563  * TIP: For a detailed writeup see our guide
564  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
565  * to implement supply mechanisms].
566  *
567  * We have followed general OpenZeppelin Contracts guidelines: functions revert
568  * instead returning `false` on failure. This behavior is nonetheless
569  * conventional and does not conflict with the expectations of ERC20
570  * applications.
571  *
572  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
573  * This allows applications to reconstruct the allowance for all accounts just
574  * by listening to said events. Other implementations of the EIP may not emit
575  * these events, as it isn't required by the specification.
576  *
577  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
578  * functions have been added to mitigate the well-known issues around setting
579  * allowances. See {IERC20-approve}.
580  */
581 contract ERC20 is Context, IERC20, IERC20Metadata {
582     mapping(address => uint256) private _balances;
583     mapping(address => mapping(address => uint256)) private _allowances;
584 
585     uint256 private _totalSupply;
586 
587     string private _name;
588     string private _symbol;
589 
590     constructor(string memory name_, string memory symbol_) {
591         _name = name_;
592         _symbol = symbol_;
593     }
594 
595     /**
596      * @dev Returns the symbol of the token, usually a shorter version of the
597      * name.
598      */
599     function symbol() external view virtual override returns (string memory) {
600         return _symbol;
601     }
602 
603     /**
604      * @dev Returns the name of the token.
605      */
606     function name() external view virtual override returns (string memory) {
607         return _name;
608     }
609 
610     /**
611      * @dev See {IERC20-balanceOf}.
612      */
613     function balanceOf(address account)
614         public
615         view
616         virtual
617         override
618         returns (uint256)
619     {
620         return _balances[account];
621     }
622 
623     /**
624      * @dev Returns the number of decimals used to get its user representation.
625      * For example, if `decimals` equals `2`, a balance of `505` tokens should
626      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
627      *
628      * Tokens usually opt for a value of 18, imitating the relationship between
629      * Ether and Wei. This is the value {ERC20} uses, unless this function is
630      * overridden;
631      *
632      * NOTE: This information is only used for _display_ purposes: it in
633      * no way affects any of the arithmetic of the contract, including
634      * {IERC20-balanceOf} and {IERC20-transfer}.
635      */
636     function decimals() public view virtual override returns (uint8) {
637         return 9;
638     }
639 
640     /**
641      * @dev See {IERC20-totalSupply}.
642      */
643     function totalSupply() external view virtual override returns (uint256) {
644         return _totalSupply;
645     }
646 
647     /**
648      * @dev See {IERC20-allowance}.
649      */
650     function allowance(address owner, address spender)
651         public
652         view
653         virtual
654         override
655         returns (uint256)
656     {
657         return _allowances[owner][spender];
658     }
659 
660     /**
661      * @dev See {IERC20-transfer}.
662      *
663      * Requirements:
664      *
665      * - `to` cannot be the zero address.
666      * - the caller must have a balance of at least `amount`.
667      */
668     function transfer(address to, uint256 amount)
669         external
670         virtual
671         override
672         returns (bool)
673     {
674         address owner = _msgSender();
675         _transfer(owner, to, amount);
676         return true;
677     }
678 
679     /**
680      * @dev See {IERC20-approve}.
681      *
682      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
683      * `transferFrom`. This is semantically equivalent to an infinite approval.
684      *
685      * Requirements:
686      *
687      * - `spender` cannot be the zero address.
688      */
689     function approve(address spender, uint256 amount)
690         external
691         virtual
692         override
693         returns (bool)
694     {
695         address owner = _msgSender();
696         _approve(owner, spender, amount);
697         return true;
698     }
699 
700     /**
701      * @dev See {IERC20-transferFrom}.
702      *
703      * Emits an {Approval} event indicating the updated allowance. This is not
704      * required by the EIP. See the note at the beginning of {ERC20}.
705      *
706      * NOTE: Does not update the allowance if the current allowance
707      * is the maximum `uint256`.
708      *
709      * Requirements:
710      *
711      * - `from` and `to` cannot be the zero address.
712      * - `from` must have a balance of at least `amount`.
713      * - the caller must have allowance for ``from``'s tokens of at least
714      * `amount`.
715      */
716     function transferFrom(
717         address from,
718         address to,
719         uint256 amount
720     ) external virtual override returns (bool) {
721         address spender = _msgSender();
722         _spendAllowance(from, spender, amount);
723         _transfer(from, to, amount);
724         return true;
725     }
726 
727     /**
728      * @dev Atomically decreases the allowance granted to `spender` by the caller.
729      *
730      * This is an alternative to {approve} that can be used as a mitigation for
731      * problems described in {IERC20-approve}.
732      *
733      * Emits an {Approval} event indicating the updated allowance.
734      *
735      * Requirements:
736      *
737      * - `spender` cannot be the zero address.
738      * - `spender` must have allowance for the caller of at least
739      * `subtractedValue`.
740      */
741     function decreaseAllowance(address spender, uint256 subtractedValue)
742         external
743         virtual
744         returns (bool)
745     {
746         address owner = _msgSender();
747         uint256 currentAllowance = allowance(owner, spender);
748         require(
749             currentAllowance >= subtractedValue,
750             "ERC20: decreased allowance below zero"
751         );
752         unchecked {
753             _approve(owner, spender, currentAllowance - subtractedValue);
754         }
755 
756         return true;
757     }
758 
759     /**
760      * @dev Atomically increases the allowance granted to `spender` by the caller.
761      *
762      * This is an alternative to {approve} that can be used as a mitigation for
763      * problems described in {IERC20-approve}.
764      *
765      * Emits an {Approval} event indicating the updated allowance.
766      *
767      * Requirements:
768      *
769      * - `spender` cannot be the zero address.
770      */
771     function increaseAllowance(address spender, uint256 addedValue)
772         external
773         virtual
774         returns (bool)
775     {
776         address owner = _msgSender();
777         _approve(owner, spender, allowance(owner, spender) + addedValue);
778         return true;
779     }
780 
781     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
782      * the total supply.
783      *
784      * Emits a {Transfer} event with `from` set to the zero address.
785      *
786      * Requirements:
787      *
788      * - `account` cannot be the zero address.
789      */
790     function _mint(address account, uint256 amount) internal virtual {
791         require(account != address(0), "ERC20: mint to the zero address");
792 
793         _totalSupply += amount;
794         unchecked {
795             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
796             _balances[account] += amount;
797         }
798         emit Transfer(address(0), account, amount);
799     }
800 
801     /**
802      * @dev Destroys `amount` tokens from `account`, reducing the
803      * total supply.
804      *
805      * Emits a {Transfer} event with `to` set to the zero address.
806      *
807      * Requirements:
808      *
809      * - `account` cannot be the zero address.
810      * - `account` must have at least `amount` tokens.
811      */
812     function _burn(address account, uint256 amount) internal virtual {
813         require(account != address(0), "ERC20: burn from the zero address");
814 
815         uint256 accountBalance = _balances[account];
816         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
817         unchecked {
818             _balances[account] = accountBalance - amount;
819             // Overflow not possible: amount <= accountBalance <= totalSupply.
820             _totalSupply -= amount;
821         }
822 
823         emit Transfer(account, address(0), amount);
824     }
825 
826     /**
827      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
828      *
829      * This internal function is equivalent to `approve`, and can be used to
830      * e.g. set automatic allowances for certain subsystems, etc.
831      *
832      * Emits an {Approval} event.
833      *
834      * Requirements:
835      *
836      * - `owner` cannot be the zero address.
837      * - `spender` cannot be the zero address.
838      */
839     function _approve(
840         address owner,
841         address spender,
842         uint256 amount
843     ) internal virtual {
844         require(owner != address(0), "ERC20: approve from the zero address");
845         require(spender != address(0), "ERC20: approve to the zero address");
846 
847         _allowances[owner][spender] = amount;
848         emit Approval(owner, spender, amount);
849     }
850 
851     /**
852      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
853      *
854      * Does not update the allowance amount in case of infinite allowance.
855      * Revert if not enough allowance is available.
856      *
857      * Might emit an {Approval} event.
858      */
859     function _spendAllowance(
860         address owner,
861         address spender,
862         uint256 amount
863     ) internal virtual {
864         uint256 currentAllowance = allowance(owner, spender);
865         if (currentAllowance != type(uint256).max) {
866             require(
867                 currentAllowance >= amount,
868                 "ERC20: insufficient allowance"
869             );
870             unchecked {
871                 _approve(owner, spender, currentAllowance - amount);
872             }
873         }
874     }
875 
876     function _transfer(
877         address from,
878         address to,
879         uint256 amount
880     ) internal virtual {
881         require(from != address(0), "ERC20: transfer from the zero address");
882         require(to != address(0), "ERC20: transfer to the zero address");
883 
884         uint256 fromBalance = _balances[from];
885         require(
886             fromBalance >= amount,
887             "ERC20: transfer amount exceeds balance"
888         );
889         unchecked {
890             _balances[from] = fromBalance - amount;
891             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
892             // decrementing then incrementing.
893             _balances[to] += amount;
894         }
895 
896         emit Transfer(from, to, amount);
897     }
898 }
899 
900 /**
901  * @dev Implementation of the {IERC20} interface.
902  *
903  * This implementation is agnostic to the way tokens are created. This means
904  * that a supply mechanism has to be added in a derived contract using {_mint}.
905  * For a generic mechanism see {ERC20PresetMinterPauser}.
906  *
907  * TIP: For a detailed writeup see our guide
908  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
909  * to implement supply mechanisms].
910  *
911  * We have followed general OpenZeppelin Contracts guidelines: functions revert
912  * instead returning `false` on failure. This behavior is nonetheless
913  * conventional and does not conflict with the expectations of ERC20
914  * applications.
915  *
916  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
917  * This allows applications to reconstruct the allowance for all accounts just
918  * by listening to said events. Other implementations of the EIP may not emit
919  * these events, as it isn't required by the specification.
920  *
921  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
922  * functions have been added to mitigate the well-known issues around setting
923  * allowances. See {IERC20-approve}.
924  */
925 contract Koyane is ERC20, Ownable {
926     // TOKENOMICS START ==========================================================>
927     string private _name = "Ame-No-Koyane";
928     string private _symbol = "KOYANE";
929     uint8 private _decimals = 9;
930     uint256 private _supply = 80000;
931     uint256 public taxForLiquidity = 1;
932     uint256 public taxForMarketing = 2;
933     uint256 public maxTxAmount = 800 * 10**_decimals;
934     uint256 public maxWalletAmount = 800 * 10**_decimals;
935     address public marketingWallet = 0xB9cca016E22f5eD51577b91fd2c9B3BFE9f0178b;
936     // TOKENOMICS END ============================================================>
937 
938     IUniswapV2Router02 public immutable uniswapV2Router;
939     address public immutable uniswapV2Pair;
940 
941     uint256 private _marketingReserves = 0;
942     mapping(address => bool) private _isExcludedFromFee;
943     uint256 private _numTokensSellToAddToLiquidity = 500000 * 10**_decimals;
944     uint256 private _numTokensSellToAddToETH = 200000 * 10**_decimals;
945     bool inSwapAndLiquify;
946 
947     event SwapAndLiquify(
948         uint256 tokensSwapped,
949         uint256 ethReceived,
950         uint256 tokensIntoLiqudity
951     );
952 
953     modifier lockTheSwap() {
954         inSwapAndLiquify = true;
955         _;
956         inSwapAndLiquify = false;
957     }
958 
959     /**
960      * @dev Sets the values for {name} and {symbol}.
961      *
962      * The default value of {decimals} is 18. To select a different value for
963      * {decimals} you should overload it.
964      *
965      * All two of these values are immutable: they can only be set once during
966      * construction.
967      */
968     constructor() ERC20(_name, _symbol) {
969         _mint(msg.sender, (_supply * 10**_decimals));
970 
971         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
972         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
973 
974         uniswapV2Router = _uniswapV2Router;
975 
976         _isExcludedFromFee[address(uniswapV2Router)] = true;
977         _isExcludedFromFee[msg.sender] = true;
978         _isExcludedFromFee[marketingWallet] = true;
979     }
980 
981     /**
982      * @dev Moves `amount` of tokens from `from` to `to`.
983      *
984      * This internal function is equivalent to {transfer}, and can be used to
985      * e.g. implement automatic token fees, slashing mechanisms, etc.
986      *
987      * Emits a {Transfer} event.
988      *
989      * Requirements:
990      *
991      *
992      * - `from` cannot be the zero address.
993      * - `to` cannot be the zero address.
994      * - `from` must have a balance of at least `amount`.
995      */
996     function _transfer(address from, address to, uint256 amount) internal override {
997         require(from != address(0), "ERC20: transfer from the zero address");
998         require(to != address(0), "ERC20: transfer to the zero address");
999         require(balanceOf(from) >= amount, "ERC20: transfer amount exceeds balance");
1000 
1001         if ((from == uniswapV2Pair || to == uniswapV2Pair) && !inSwapAndLiquify) {
1002             if (from != uniswapV2Pair) {
1003                 uint256 contractLiquidityBalance = balanceOf(address(this)) - _marketingReserves;
1004                 if (contractLiquidityBalance >= _numTokensSellToAddToLiquidity) {
1005                     _swapAndLiquify(_numTokensSellToAddToLiquidity);
1006                 }
1007                 if ((_marketingReserves) >= _numTokensSellToAddToETH) {
1008                     _swapTokensForEth(_numTokensSellToAddToETH);
1009                     _marketingReserves -= _numTokensSellToAddToETH;
1010                     bool sent = payable(marketingWallet).send(address(this).balance);
1011                     require(sent, "Failed to send ETH");
1012                 }
1013             }
1014 
1015             uint256 transferAmount;
1016             if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
1017                 transferAmount = amount;
1018             } 
1019             else {
1020                 require(amount <= maxTxAmount, "ERC20: transfer amount exceeds the max transaction amount");
1021                 if(from == uniswapV2Pair){
1022                     require((amount + balanceOf(to)) <= maxWalletAmount, "ERC20: balance amount exceeded max wallet amount limit");
1023                 }
1024 
1025                 uint256 marketingShare = ((amount * taxForMarketing) / 100);
1026                 uint256 liquidityShare = ((amount * taxForLiquidity) / 100);
1027                 transferAmount = amount - (marketingShare + liquidityShare);
1028                 _marketingReserves += marketingShare;
1029 
1030                 super._transfer(from, address(this), (marketingShare + liquidityShare));
1031             }
1032             super._transfer(from, to, transferAmount);
1033         } 
1034         else {
1035             super._transfer(from, to, amount);
1036         }
1037     }
1038 
1039     function _swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1040         uint256 half = (contractTokenBalance / 2);
1041         uint256 otherHalf = (contractTokenBalance - half);
1042 
1043         uint256 initialBalance = address(this).balance;
1044 
1045         _swapTokensForEth(half);
1046 
1047         uint256 newBalance = (address(this).balance - initialBalance);
1048 
1049         _addLiquidity(otherHalf, newBalance);
1050 
1051         emit SwapAndLiquify(half, newBalance, otherHalf);
1052     }
1053 
1054     function _swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
1055         address[] memory path = new address[](2);
1056         path[0] = address(this);
1057         path[1] = uniswapV2Router.WETH();
1058 
1059         _approve(address(this), address(uniswapV2Router), tokenAmount);
1060 
1061         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1062             tokenAmount,
1063             0,
1064             path,
1065             address(this),
1066             (block.timestamp + 300)
1067         );
1068     }
1069 
1070     function _addLiquidity(uint256 tokenAmount, uint256 ethAmount)
1071         private
1072         lockTheSwap
1073     {
1074         _approve(address(this), address(uniswapV2Router), tokenAmount);
1075 
1076         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1077             address(this),
1078             tokenAmount,
1079             0,
1080             0,
1081             owner(),
1082             block.timestamp
1083         );
1084     }
1085 
1086     function changeMarketingWallet(address newWallet)
1087         public
1088         onlyOwner
1089         returns (bool)
1090     {
1091         marketingWallet = newWallet;
1092         return true;
1093     }
1094 
1095     function changeTaxForLiquidityAndMarketing(uint256 _taxForLiquidity, uint256 _taxForMarketing)
1096         public
1097         onlyOwner
1098         returns (bool)
1099     {
1100         require((_taxForLiquidity+_taxForMarketing) <= 100, "ERC20: total tax must not be greater than 100");
1101         taxForLiquidity = _taxForLiquidity;
1102         taxForMarketing = _taxForMarketing;
1103 
1104         return true;
1105     }
1106 
1107     function changeMaxTxAmount(uint256 _maxTxAmount)
1108         public
1109         onlyOwner
1110         returns (bool)
1111     {
1112         maxTxAmount = _maxTxAmount;
1113 
1114         return true;
1115     }
1116 
1117     function changeMaxWalletAmount(uint256 _maxWalletAmount)
1118         public
1119         onlyOwner
1120         returns (bool)
1121     {
1122         maxWalletAmount = _maxWalletAmount;
1123 
1124         return true;
1125     }
1126 
1127     receive() external payable {}
1128 }