1 /**
2  *   _                                _____ 
3  *  (_)                         /\   |_   _|
4  *   _ _ __ ___   __ _ _ __    /  \    | |  
5  *  | | '_ ` _ \ / _` | '_ \  / /\ \   | |  
6  *  | | | | | | | (_| | | | |/ ____ \ _| |_ 
7  *  |_|_| |_| |_|\__, |_| |_/_/    \_\_____|
8  *                __/ |                     
9  *               |___/                      
10  * 
11  * Image Generation AI : Powered by Stability AI's Stable Diffusion
12  * 
13  * Telegram: https://t.me/imgnAI
14  * Twitter: twitter.com/imgnAI
15  * Homepage: https://imgnAI.com
16  * 
17  * Total Supply: 1 Billion Tokens
18  * Unlock rendering & Add our AI Bot to your Telegram channel at our homepage!
19  * 
20  * Set slippage to 3-4% : 1% to LP, 2% tax for Marketing & GPU Hosting costs.
21 */
22 
23 // SPDX-License-Identifier: MIT
24 
25 pragma solidity 0.8.16;
26 
27 interface IUniswapV2Factory {
28     event PairCreated(
29         address indexed token0,
30         address indexed token1,
31         address pair,
32         uint256
33     );
34 
35     function feeTo() external view returns (address);
36 
37     function feeToSetter() external view returns (address);
38 
39     function allPairsLength() external view returns (uint256);
40 
41     function getPair(address tokenA, address tokenB)
42         external
43         view
44         returns (address pair);
45 
46     function allPairs(uint256) external view returns (address pair);
47 
48     function createPair(address tokenA, address tokenB)
49         external
50         returns (address pair);
51 
52     function setFeeTo(address) external;
53 
54     function setFeeToSetter(address) external;
55 }
56 
57 interface IUniswapV2Pair {
58     event Approval(
59         address indexed owner,
60         address indexed spender,
61         uint256 value
62     );
63     event Transfer(address indexed from, address indexed to, uint256 value);
64 
65     function name() external pure returns (string memory);
66 
67     function symbol() external pure returns (string memory);
68 
69     function decimals() external pure returns (uint8);
70 
71     function totalSupply() external view returns (uint256);
72 
73     function balanceOf(address owner) external view returns (uint256);
74 
75     function allowance(address owner, address spender)
76         external
77         view
78         returns (uint256);
79 
80     function approve(address spender, uint256 value) external returns (bool);
81 
82     function transfer(address to, uint256 value) external returns (bool);
83 
84     function transferFrom(
85         address from,
86         address to,
87         uint256 value
88     ) external returns (bool);
89 
90     function DOMAIN_SEPARATOR() external view returns (bytes32);
91 
92     function PERMIT_TYPEHASH() external pure returns (bytes32);
93 
94     function nonces(address owner) external view returns (uint256);
95 
96     function permit(
97         address owner,
98         address spender,
99         uint256 value,
100         uint256 deadline,
101         uint8 v,
102         bytes32 r,
103         bytes32 s
104     ) external;
105 
106     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
107     event Burn(
108         address indexed sender,
109         uint256 amount0,
110         uint256 amount1,
111         address indexed to
112     );
113     event Swap(
114         address indexed sender,
115         uint256 amount0In,
116         uint256 amount1In,
117         uint256 amount0Out,
118         uint256 amount1Out,
119         address indexed to
120     );
121     event Sync(uint112 reserve0, uint112 reserve1);
122 
123     function MINIMUM_LIQUIDITY() external pure returns (uint256);
124 
125     function factory() external view returns (address);
126 
127     function token0() external view returns (address);
128 
129     function token1() external view returns (address);
130 
131     function getReserves()
132         external
133         view
134         returns (
135             uint112 reserve0,
136             uint112 reserve1,
137             uint32 blockTimestampLast
138         );
139 
140     function price0CumulativeLast() external view returns (uint256);
141 
142     function price1CumulativeLast() external view returns (uint256);
143 
144     function kLast() external view returns (uint256);
145 
146     function mint(address to) external returns (uint256 liquidity);
147 
148     function burn(address to)
149         external
150         returns (uint256 amount0, uint256 amount1);
151 
152     function swap(
153         uint256 amount0Out,
154         uint256 amount1Out,
155         address to,
156         bytes calldata data
157     ) external;
158 
159     function skim(address to) external;
160 
161     function sync() external;
162 
163     function initialize(address, address) external;
164 }
165 
166 interface IUniswapV2Router01 {
167     function factory() external pure returns (address);
168 
169     function WETH() external pure returns (address);
170 
171     function addLiquidity(
172         address tokenA,
173         address tokenB,
174         uint256 amountADesired,
175         uint256 amountBDesired,
176         uint256 amountAMin,
177         uint256 amountBMin,
178         address to,
179         uint256 deadline
180     )
181         external
182         returns (
183             uint256 amountA,
184             uint256 amountB,
185             uint256 liquidity
186         );
187 
188     function addLiquidityETH(
189         address token,
190         uint256 amountTokenDesired,
191         uint256 amountTokenMin,
192         uint256 amountETHMin,
193         address to,
194         uint256 deadline
195     )
196         external
197         payable
198         returns (
199             uint256 amountToken,
200             uint256 amountETH,
201             uint256 liquidity
202         );
203 
204     function removeLiquidity(
205         address tokenA,
206         address tokenB,
207         uint256 liquidity,
208         uint256 amountAMin,
209         uint256 amountBMin,
210         address to,
211         uint256 deadline
212     ) external returns (uint256 amountA, uint256 amountB);
213 
214     function removeLiquidityETH(
215         address token,
216         uint256 liquidity,
217         uint256 amountTokenMin,
218         uint256 amountETHMin,
219         address to,
220         uint256 deadline
221     ) external returns (uint256 amountToken, uint256 amountETH);
222 
223     function removeLiquidityWithPermit(
224         address tokenA,
225         address tokenB,
226         uint256 liquidity,
227         uint256 amountAMin,
228         uint256 amountBMin,
229         address to,
230         uint256 deadline,
231         bool approveMax,
232         uint8 v,
233         bytes32 r,
234         bytes32 s
235     ) external returns (uint256 amountA, uint256 amountB);
236 
237     function removeLiquidityETHWithPermit(
238         address token,
239         uint256 liquidity,
240         uint256 amountTokenMin,
241         uint256 amountETHMin,
242         address to,
243         uint256 deadline,
244         bool approveMax,
245         uint8 v,
246         bytes32 r,
247         bytes32 s
248     ) external returns (uint256 amountToken, uint256 amountETH);
249 
250     function swapExactTokensForTokens(
251         uint256 amountIn,
252         uint256 amountOutMin,
253         address[] calldata path,
254         address to,
255         uint256 deadline
256     ) external returns (uint256[] memory amounts);
257 
258     function swapTokensForExactTokens(
259         uint256 amountOut,
260         uint256 amountInMax,
261         address[] calldata path,
262         address to,
263         uint256 deadline
264     ) external returns (uint256[] memory amounts);
265 
266     function swapExactETHForTokens(
267         uint256 amountOutMin,
268         address[] calldata path,
269         address to,
270         uint256 deadline
271     ) external payable returns (uint256[] memory amounts);
272 
273     function swapTokensForExactETH(
274         uint256 amountOut,
275         uint256 amountInMax,
276         address[] calldata path,
277         address to,
278         uint256 deadline
279     ) external returns (uint256[] memory amounts);
280 
281     function swapExactTokensForETH(
282         uint256 amountIn,
283         uint256 amountOutMin,
284         address[] calldata path,
285         address to,
286         uint256 deadline
287     ) external returns (uint256[] memory amounts);
288 
289     function swapETHForExactTokens(
290         uint256 amountOut,
291         address[] calldata path,
292         address to,
293         uint256 deadline
294     ) external payable returns (uint256[] memory amounts);
295 
296     function quote(
297         uint256 amountA,
298         uint256 reserveA,
299         uint256 reserveB
300     ) external pure returns (uint256 amountB);
301 
302     function getAmountOut(
303         uint256 amountIn,
304         uint256 reserveIn,
305         uint256 reserveOut
306     ) external pure returns (uint256 amountOut);
307 
308     function getAmountIn(
309         uint256 amountOut,
310         uint256 reserveIn,
311         uint256 reserveOut
312     ) external pure returns (uint256 amountIn);
313 
314     function getAmountsOut(uint256 amountIn, address[] calldata path)
315         external
316         view
317         returns (uint256[] memory amounts);
318 
319     function getAmountsIn(uint256 amountOut, address[] calldata path)
320         external
321         view
322         returns (uint256[] memory amounts);
323 }
324 
325 interface IUniswapV2Router02 is IUniswapV2Router01 {
326     function removeLiquidityETHSupportingFeeOnTransferTokens(
327         address token,
328         uint256 liquidity,
329         uint256 amountTokenMin,
330         uint256 amountETHMin,
331         address to,
332         uint256 deadline
333     ) external returns (uint256 amountETH);
334 
335     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
336         address token,
337         uint256 liquidity,
338         uint256 amountTokenMin,
339         uint256 amountETHMin,
340         address to,
341         uint256 deadline,
342         bool approveMax,
343         uint8 v,
344         bytes32 r,
345         bytes32 s
346     ) external returns (uint256 amountETH);
347 
348     function swapExactETHForTokensSupportingFeeOnTransferTokens(
349         uint256 amountOutMin,
350         address[] calldata path,
351         address to,
352         uint256 deadline
353     ) external payable;
354 
355     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
356         uint256 amountIn,
357         uint256 amountOutMin,
358         address[] calldata path,
359         address to,
360         uint256 deadline
361     ) external;
362 
363     function swapExactTokensForETHSupportingFeeOnTransferTokens(
364         uint256 amountIn,
365         uint256 amountOutMin,
366         address[] calldata path,
367         address to,
368         uint256 deadline
369     ) external;
370 }
371 
372 /**
373  * @dev Interface of the ERC20 standard as defined in the EIP.
374  */
375 interface IERC20 {
376     /**
377      * @dev Emitted when `value` tokens are moved from one account (`from`) to
378      * another (`to`).
379      *
380      * Note that `value` may be zero.
381      */
382     event Transfer(address indexed from, address indexed to, uint256 value);
383 
384     /**
385      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
386      * a call to {approve}. `value` is the new allowance.
387      */
388     event Approval(
389         address indexed owner,
390         address indexed spender,
391         uint256 value
392     );
393 
394     /**
395      * @dev Returns the amount of tokens in existence.
396      */
397     function totalSupply() external view returns (uint256);
398 
399     /**
400      * @dev Returns the amount of tokens owned by `account`.
401      */
402     function balanceOf(address account) external view returns (uint256);
403 
404     /**
405      * @dev Moves `amount` tokens from the caller's account to `to`.
406      *
407      * Returns a boolean value indicating whether the operation succeeded.
408      *
409      * Emits a {Transfer} event.
410      */
411     function transfer(address to, uint256 amount) external returns (bool);
412 
413     /**
414      * @dev Returns the remaining number of tokens that `spender` will be
415      * allowed to spend on behalf of `owner` through {transferFrom}. This is
416      * zero by default.
417      *
418      * This value changes when {approve} or {transferFrom} are called.
419      */
420     function allowance(address owner, address spender)
421         external
422         view
423         returns (uint256);
424 
425     /**
426      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
427      *
428      * Returns a boolean value indicating whether the operation succeeded.
429      *
430      * IMPORTANT: Beware that changing an allowance with this method brings the risk
431      * that someone may use both the old and the new allowance by unfortunate
432      * transaction ordering. One possible solution to mitigate this race
433      * condition is to first reduce the spender's allowance to 0 and set the
434      * desired value afterwards:
435      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
436      *
437      * Emits an {Approval} event.
438      */
439     function approve(address spender, uint256 amount) external returns (bool);
440 
441     /**
442      * @dev Moves `amount` tokens from `from` to `to` using the
443      * allowance mechanism. `amount` is then deducted from the caller's
444      * allowance.
445      *
446      * Returns a boolean value indicating whether the operation succeeded.
447      *
448      * Emits a {Transfer} event.
449      */
450     function transferFrom(
451         address from,
452         address to,
453         uint256 amount
454     ) external returns (bool);
455 }
456 
457 /**
458  * @dev Interface for the optional metadata functions from the ERC20 standard.
459  *
460  * _Available since v4.1._
461  */
462 interface IERC20Metadata is IERC20 {
463     /**
464      * @dev Returns the name of the token.
465      */
466     function name() external view returns (string memory);
467 
468     /**
469      * @dev Returns the decimals places of the token.
470      */
471     function decimals() external view returns (uint8);
472 
473     /**
474      * @dev Returns the symbol of the token.
475      */
476     function symbol() external view returns (string memory);
477 }
478 
479 /**
480  * @dev Provides information about the current execution context, including the
481  * sender of the transaction and its data. While these are generally available
482  * via msg.sender and msg.data, they should not be accessed in such a direct
483  * manner, since when dealing with meta-transactions the account sending and
484  * paying for execution may not be the actual sender (as far as an application
485  * is concerned).
486  *
487  * This contract is only required for intermediate, library-like contracts.
488  */
489 abstract contract Context {
490     function _msgSender() internal view virtual returns (address) {
491         return msg.sender;
492     }
493 }
494 
495 /**
496  * @dev Contract module which provides a basic access control mechanism, where
497  * there is an account (an owner) that can be granted exclusive access to
498  * specific functions.
499  *
500  * By default, the owner account will be the one that deploys the contract. This
501  * can later be changed with {transferOwnership}.
502  *
503  * This module is used through inheritance. It will make available the modifier
504  * `onlyOwner`, which can be applied to your functions to restrict their use to
505  * the owner.
506  */
507 abstract contract Ownable is Context {
508     address private _owner;
509 
510     event OwnershipTransferred(
511         address indexed previousOwner,
512         address indexed newOwner
513     );
514 
515     /**
516      * @dev Initializes the contract setting the deployer as the initial owner.
517      */
518     constructor() {
519         _transferOwnership(_msgSender());
520     }
521 
522     /**
523      * @dev Throws if called by any account other than the owner.
524      */
525     modifier onlyOwner() {
526         _checkOwner();
527         _;
528     }
529 
530     /**
531      * @dev Returns the address of the current owner.
532      */
533     function owner() public view virtual returns (address) {
534         return _owner;
535     }
536 
537     /**
538      * @dev Throws if the sender is not the owner.
539      */
540     function _checkOwner() internal view virtual {
541         require(owner() == _msgSender(), "Ownable: caller is not the owner");
542     }
543 
544     /**
545      * @dev Leaves the contract without owner. It will not be possible to call
546      * `onlyOwner` functions anymore. Can only be called by the current owner.
547      *
548      * NOTE: Renouncing ownership will leave the contract without an owner,
549      * thereby removing any functionality that is only available to the owner.
550      */
551     function renounceOwnership() public virtual onlyOwner {
552         _transferOwnership(address(0));
553     }
554 
555     /**
556      * @dev Transfers ownership of the contract to a new account (`newOwner`).
557      * Can only be called by the current owner.
558      */
559     function transferOwnership(address newOwner) public virtual onlyOwner {
560         require(
561             newOwner != address(0),
562             "Ownable: new owner is the zero address"
563         );
564         _transferOwnership(newOwner);
565     }
566 
567     /**
568      * @dev Transfers ownership of the contract to a new account (`newOwner`).
569      * Internal function without access restriction.
570      */
571     function _transferOwnership(address newOwner) internal virtual {
572         address oldOwner = _owner;
573         _owner = newOwner;
574         emit OwnershipTransferred(oldOwner, newOwner);
575     }
576 }
577 
578 /**
579  * @dev Implementation of the {IERC20} interface.
580  *
581  * This implementation is agnostic to the way tokens are created. This means
582  * that a supply mechanism has to be added in a derived contract using {_mint}.
583  * For a generic mechanism see {ERC20PresetMinterPauser}.
584  *
585  * TIP: For a detailed writeup see our guide
586  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
587  * to implement supply mechanisms].
588  *
589  * We have followed general OpenZeppelin Contracts guidelines: functions revert
590  * instead returning `false` on failure. This behavior is nonetheless
591  * conventional and does not conflict with the expectations of ERC20
592  * applications.
593  *
594  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
595  * This allows applications to reconstruct the allowance for all accounts just
596  * by listening to said events. Other implementations of the EIP may not emit
597  * these events, as it isn't required by the specification.
598  *
599  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
600  * functions have been added to mitigate the well-known issues around setting
601  * allowances. See {IERC20-approve}.
602  */
603 contract ERC20 is Context, IERC20, IERC20Metadata {
604     mapping(address => uint256) private _balances;
605     mapping(address => mapping(address => uint256)) private _allowances;
606 
607     uint256 private _totalSupply;
608 
609     string private _name;
610     string private _symbol;
611 
612     constructor(string memory name_, string memory symbol_) {
613         _name = name_;
614         _symbol = symbol_;
615     }
616 
617     /**
618      * @dev Returns the symbol of the token, usually a shorter version of the
619      * name.
620      */
621     function symbol() external view virtual override returns (string memory) {
622         return _symbol;
623     }
624 
625     /**
626      * @dev Returns the name of the token.
627      */
628     function name() external view virtual override returns (string memory) {
629         return _name;
630     }
631 
632     /**
633      * @dev See {IERC20-balanceOf}.
634      */
635     function balanceOf(address account)
636         public
637         view
638         virtual
639         override
640         returns (uint256)
641     {
642         return _balances[account];
643     }
644 
645     /**
646      * @dev Returns the number of decimals used to get its user representation.
647      * For example, if `decimals` equals `2`, a balance of `505` tokens should
648      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
649      *
650      * Tokens usually opt for a value of 18, imitating the relationship between
651      * Ether and Wei. This is the value {ERC20} uses, unless this function is
652      * overridden;
653      *
654      * NOTE: This information is only used for _display_ purposes: it in
655      * no way affects any of the arithmetic of the contract, including
656      * {IERC20-balanceOf} and {IERC20-transfer}.
657      */
658     function decimals() public view virtual override returns (uint8) {
659         return 9;
660     }
661 
662     /**
663      * @dev See {IERC20-totalSupply}.
664      */
665     function totalSupply() external view virtual override returns (uint256) {
666         return _totalSupply;
667     }
668 
669     /**
670      * @dev See {IERC20-allowance}.
671      */
672     function allowance(address owner, address spender)
673         public
674         view
675         virtual
676         override
677         returns (uint256)
678     {
679         return _allowances[owner][spender];
680     }
681 
682     /**
683      * @dev See {IERC20-transfer}.
684      *
685      * Requirements:
686      *
687      * - `to` cannot be the zero address.
688      * - the caller must have a balance of at least `amount`.
689      */
690     function transfer(address to, uint256 amount)
691         external
692         virtual
693         override
694         returns (bool)
695     {
696         address owner = _msgSender();
697         _transfer(owner, to, amount);
698         return true;
699     }
700 
701     /**
702      * @dev See {IERC20-approve}.
703      *
704      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
705      * `transferFrom`. This is semantically equivalent to an infinite approval.
706      *
707      * Requirements:
708      *
709      * - `spender` cannot be the zero address.
710      */
711     function approve(address spender, uint256 amount)
712         external
713         virtual
714         override
715         returns (bool)
716     {
717         address owner = _msgSender();
718         _approve(owner, spender, amount);
719         return true;
720     }
721 
722     /**
723      * @dev See {IERC20-transferFrom}.
724      *
725      * Emits an {Approval} event indicating the updated allowance. This is not
726      * required by the EIP. See the note at the beginning of {ERC20}.
727      *
728      * NOTE: Does not update the allowance if the current allowance
729      * is the maximum `uint256`.
730      *
731      * Requirements:
732      *
733      * - `from` and `to` cannot be the zero address.
734      * - `from` must have a balance of at least `amount`.
735      * - the caller must have allowance for ``from``'s tokens of at least
736      * `amount`.
737      */
738     function transferFrom(
739         address from,
740         address to,
741         uint256 amount
742     ) external virtual override returns (bool) {
743         address spender = _msgSender();
744         _spendAllowance(from, spender, amount);
745         _transfer(from, to, amount);
746         return true;
747     }
748 
749     /**
750      * @dev Atomically decreases the allowance granted to `spender` by the caller.
751      *
752      * This is an alternative to {approve} that can be used as a mitigation for
753      * problems described in {IERC20-approve}.
754      *
755      * Emits an {Approval} event indicating the updated allowance.
756      *
757      * Requirements:
758      *
759      * - `spender` cannot be the zero address.
760      * - `spender` must have allowance for the caller of at least
761      * `subtractedValue`.
762      */
763     function decreaseAllowance(address spender, uint256 subtractedValue)
764         external
765         virtual
766         returns (bool)
767     {
768         address owner = _msgSender();
769         uint256 currentAllowance = allowance(owner, spender);
770         require(
771             currentAllowance >= subtractedValue,
772             "ERC20: decreased allowance below zero"
773         );
774         unchecked {
775             _approve(owner, spender, currentAllowance - subtractedValue);
776         }
777 
778         return true;
779     }
780 
781     /**
782      * @dev Atomically increases the allowance granted to `spender` by the caller.
783      *
784      * This is an alternative to {approve} that can be used as a mitigation for
785      * problems described in {IERC20-approve}.
786      *
787      * Emits an {Approval} event indicating the updated allowance.
788      *
789      * Requirements:
790      *
791      * - `spender` cannot be the zero address.
792      */
793     function increaseAllowance(address spender, uint256 addedValue)
794         external
795         virtual
796         returns (bool)
797     {
798         address owner = _msgSender();
799         _approve(owner, spender, allowance(owner, spender) + addedValue);
800         return true;
801     }
802 
803     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
804      * the total supply.
805      *
806      * Emits a {Transfer} event with `from` set to the zero address.
807      *
808      * Requirements:
809      *
810      * - `account` cannot be the zero address.
811      */
812     function _mint(address account, uint256 amount) internal virtual {
813         require(account != address(0), "ERC20: mint to the zero address");
814 
815         _totalSupply += amount;
816         unchecked {
817             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
818             _balances[account] += amount;
819         }
820         emit Transfer(address(0), account, amount);
821     }
822 
823     /**
824      * @dev Destroys `amount` tokens from `account`, reducing the
825      * total supply.
826      *
827      * Emits a {Transfer} event with `to` set to the zero address.
828      *
829      * Requirements:
830      *
831      * - `account` cannot be the zero address.
832      * - `account` must have at least `amount` tokens.
833      */
834     function _burn(address account, uint256 amount) internal virtual {
835         require(account != address(0), "ERC20: burn from the zero address");
836 
837         uint256 accountBalance = _balances[account];
838         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
839         unchecked {
840             _balances[account] = accountBalance - amount;
841             // Overflow not possible: amount <= accountBalance <= totalSupply.
842             _totalSupply -= amount;
843         }
844 
845         emit Transfer(account, address(0), amount);
846     }
847 
848     /**
849      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
850      *
851      * This internal function is equivalent to `approve`, and can be used to
852      * e.g. set automatic allowances for certain subsystems, etc.
853      *
854      * Emits an {Approval} event.
855      *
856      * Requirements:
857      *
858      * - `owner` cannot be the zero address.
859      * - `spender` cannot be the zero address.
860      */
861     function _approve(
862         address owner,
863         address spender,
864         uint256 amount
865     ) internal virtual {
866         require(owner != address(0), "ERC20: approve from the zero address");
867         require(spender != address(0), "ERC20: approve to the zero address");
868 
869         _allowances[owner][spender] = amount;
870         emit Approval(owner, spender, amount);
871     }
872 
873     /**
874      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
875      *
876      * Does not update the allowance amount in case of infinite allowance.
877      * Revert if not enough allowance is available.
878      *
879      * Might emit an {Approval} event.
880      */
881     function _spendAllowance(
882         address owner,
883         address spender,
884         uint256 amount
885     ) internal virtual {
886         uint256 currentAllowance = allowance(owner, spender);
887         if (currentAllowance != type(uint256).max) {
888             require(
889                 currentAllowance >= amount,
890                 "ERC20: insufficient allowance"
891             );
892             unchecked {
893                 _approve(owner, spender, currentAllowance - amount);
894             }
895         }
896     }
897 
898     function _transfer(
899         address from,
900         address to,
901         uint256 amount
902     ) internal virtual {
903         require(from != address(0), "ERC20: transfer from the zero address");
904         require(to != address(0), "ERC20: transfer to the zero address");
905 
906         uint256 fromBalance = _balances[from];
907         require(
908             fromBalance >= amount,
909             "ERC20: transfer amount exceeds balance"
910         );
911         unchecked {
912             _balances[from] = fromBalance - amount;
913             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
914             // decrementing then incrementing.
915             _balances[to] += amount;
916         }
917 
918         emit Transfer(from, to, amount);
919     }
920 }
921 
922 /**
923  * @dev Implementation of the {IERC20} interface.
924  *
925  * This implementation is agnostic to the way tokens are created. This means
926  * that a supply mechanism has to be added in a derived contract using {_mint}.
927  * For a generic mechanism see {ERC20PresetMinterPauser}.
928  *
929  * TIP: For a detailed writeup see our guide
930  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
931  * to implement supply mechanisms].
932  *
933  * We have followed general OpenZeppelin Contracts guidelines: functions revert
934  * instead returning `false` on failure. This behavior is nonetheless
935  * conventional and does not conflict with the expectations of ERC20
936  * applications.
937  *
938  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
939  * This allows applications to reconstruct the allowance for all accounts just
940  * by listening to said events. Other implementations of the EIP may not emit
941  * these events, as it isn't required by the specification.
942  *
943  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
944  * functions have been added to mitigate the well-known issues around setting
945  * allowances. See {IERC20-approve}.
946  */
947  contract Imgnai is ERC20, Ownable {
948     // TOKENOMICS START ==========================================================>
949     string private _name = "Image Generation AI | imgnAI.com";
950     string private _symbol = "imgnAI";
951     uint8 private _decimals = 9;
952     uint256 private _supply = 1000000000;
953     uint256 public taxForLiquidity = 47; //sniper protection, to be lowered to 1% after launch
954     uint256 public taxForMarketing = 47; //sniper protection, to be lowered to 2% after launch
955     uint256 public maxTxAmount = 10000001 * 10**_decimals;
956     uint256 public maxWalletAmount = 10000001 * 10**_decimals;
957     address public marketingWallet = 0xbC14dE74243788c5D934C963c4EAf3b743F1b0C6;
958     address public DEAD = 0x000000000000000000000000000000000000dEaD;
959     uint256 public _marketingReserves = 0;
960     mapping(address => bool) public _isExcludedFromFee;
961     uint256 public numTokensSellToAddToLiquidity = 200000 * 10**_decimals;
962     uint256 public numTokensSellToAddToETH = 100000 * 10**_decimals;
963 
964     function postLaunch() external onlyOwner {
965         taxForLiquidity = 1;
966         taxForMarketing = 2;
967         maxTxAmount = 10000001 * 10**_decimals;
968         maxWalletAmount = 10000001 * 10**_decimals;
969     }
970     // TOKENOMICS END ============================================================>
971 
972     // StableDiffusion Access START ==============================================>
973     struct userUnlock {
974         string tgUserName;
975         bool unlocked;
976         uint256 unlockedAt;
977         uint256 totalEthPaid;
978     }
979 
980     struct channelUnlock {
981         string tgChannel;
982         bool unlocked;
983         uint256 unlockedAt;
984         uint256 totalEthPaid;
985     }
986 
987     mapping(string => userUnlock) public unlockedUsers;
988     mapping(string => channelUnlock) public unlockedChannels;
989 
990     uint public userCostEth = 0.01 ether;
991     uint public userCostTokens = 10000 * 10**_decimals;
992 
993     uint public channelCostEth = 0.1 ether;
994     uint public channelCostTokens = 100000 * 10**_decimals;
995 
996     event UserUnlocked(string tg_username, uint256 unlockTime);
997     event ChannelUnlocked(string tg_channel, uint256 unlockTime);
998     event CostUpdated(bool _isEth, bool _isChannel, uint _cost);
999     event ExcludedFromFeeUpdated(address _address, bool _status);
1000     event AdminModifierSet(string tg_user_chan, bool _isChannel, bool _isUnlocked, 
1001         uint _unlockBlock, uint _amtPaid);
1002     event PairUpdated(address _address);
1003 
1004     //with all eth payments, reserve is held on the contract until the sending threshold is reached.
1005     function unlockUser(string memory tg_username) external payable {
1006         require(msg.value >= userCostEth, "Not enough ETH sent!");
1007         require(msg.sender.balance >= userCostTokens, "Not enough tokens!");
1008         _marketingReserves += msg.value;
1009         _transfer(msg.sender, DEAD, userCostTokens);
1010 
1011         unlockedUsers[tg_username] = userUnlock(
1012             tg_username,
1013             true,
1014             block.timestamp,
1015             unlockedUsers[tg_username].totalEthPaid + msg.value
1016         );
1017         emit UserUnlocked(tg_username, block.timestamp);
1018     }
1019 
1020     function unlockChannel(string memory tg_channel) external payable {
1021         require(msg.value >= userCostEth, "Not enough ETH sent!");
1022         require(msg.sender.balance >= userCostTokens, "Not enough tokens!");
1023         _marketingReserves += msg.value;
1024         _transfer(msg.sender, DEAD, userCostTokens);
1025         
1026         unlockedChannels[tg_channel] = channelUnlock(
1027             tg_channel,
1028             true,
1029             block.timestamp,
1030             unlockedChannels[tg_channel].totalEthPaid + msg.value
1031         );
1032         emit ChannelUnlocked(tg_channel, block.timestamp);
1033     }
1034 
1035     //Some simple ABIv1 getters below
1036     function isUnlocked(string memory tg_user_chan, bool _isChannel) external view returns(bool) {
1037         if (_isChannel) {
1038             return unlockedChannels[tg_user_chan].unlocked;
1039         }
1040         return unlockedUsers[tg_user_chan].unlocked;
1041     }
1042 
1043     function getAmtPaid(string memory tg_user_chan, bool _isChannel) external view returns(uint) {
1044         if (_isChannel) {
1045             return unlockedChannels[tg_user_chan].totalEthPaid;
1046         }
1047         return unlockedUsers[tg_user_chan].totalEthPaid;
1048     }
1049 
1050     function getUnlockBlock(string memory tg_user_chan, bool _isChannel) external view returns(uint) {
1051         if (_isChannel) {
1052             return unlockedChannels[tg_user_chan].unlockedAt;
1053         }
1054         return unlockedUsers[tg_user_chan].unlockedAt;
1055     }
1056 
1057     //Admin modifier function
1058     function setUnlockStatus(string memory tg_user_chan, bool _isChannel, 
1059         bool _isUnlocked, uint _unlockBlock, uint _amtPaid) external onlyOwner {
1060         if (_isChannel) {
1061             unlockedChannels[tg_user_chan] = channelUnlock(
1062                 tg_user_chan,
1063                 _isUnlocked,
1064                 _unlockBlock,
1065                 _amtPaid
1066             );
1067         } else {
1068             unlockedUsers[tg_user_chan] = userUnlock(
1069                 tg_user_chan,
1070                 _isUnlocked,
1071                 _unlockBlock,
1072                 _amtPaid
1073             );
1074         }
1075         emit AdminModifierSet(tg_user_chan, _isChannel, _isUnlocked, _unlockBlock, _amtPaid);
1076     }
1077 
1078     function setCost(bool _isEth, bool _isChannel, uint _cost) external onlyOwner {
1079         if (_isEth) {
1080             if (_isChannel) {
1081                 channelCostEth = _cost;
1082             } else {
1083                 userCostEth = _cost;
1084             }
1085         } else {
1086             if (_isChannel) {
1087                 channelCostTokens = _cost * 10**_decimals;
1088             } else {
1089                 userCostTokens = _cost * 10**_decimals;
1090             }
1091         }
1092         emit CostUpdated(_isEth, _isChannel, _cost);
1093     }
1094     // StableDiffusion Access END ================================================>
1095 
1096     IUniswapV2Router02 public immutable uniswapV2Router;
1097     address public uniswapV2Pair;
1098     
1099     bool inSwapAndLiquify;
1100 
1101     event SwapAndLiquify(
1102         uint256 tokensSwapped,
1103         uint256 ethReceived,
1104         uint256 tokensIntoLiqudity
1105     );
1106 
1107     modifier lockTheSwap() {
1108         inSwapAndLiquify = true;
1109         _;
1110         inSwapAndLiquify = false;
1111     }
1112 
1113     /**
1114      * @dev Sets the values for {name} and {symbol}.
1115      *
1116      * The default value of {decimals} is 18. To select a different value for
1117      * {decimals} you should overload it.
1118      *
1119      * All two of these values are immutable: they can only be set once during
1120      * construction.
1121      */
1122     constructor() ERC20(_name, _symbol) {
1123         _mint(msg.sender, (_supply * 10**_decimals));
1124 
1125         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); //eth mainnet
1126         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
1127 
1128         uniswapV2Router = _uniswapV2Router;
1129 
1130         _isExcludedFromFee[address(uniswapV2Router)] = true;
1131         _isExcludedFromFee[msg.sender] = true;
1132         _isExcludedFromFee[marketingWallet] = true;
1133     }
1134 
1135     function updatePair(address _pair) external onlyOwner {
1136         require(_pair != DEAD, "LP Pair cannot be the Dead wallet, or 0!");
1137         require(_pair != address(0), "LP Pair cannot be the Dead wallet, or 0!");
1138         uniswapV2Pair = _pair;
1139         emit PairUpdated(_pair);
1140     }
1141 
1142     /**
1143      * @dev Moves `amount` of tokens from `from` to `to`.
1144      *
1145      * This internal function is equivalent to {transfer}, and can be used to
1146      * e.g. implement automatic token fees, slashing mechanisms, etc.
1147      *
1148      * Emits a {Transfer} event.
1149      *
1150      * Requirements:
1151      *
1152      *
1153      * - `from` cannot be the zero address.
1154      * - `to` cannot be the zero address.
1155      * - `from` must have a balance of at least `amount`.
1156      */
1157     function _transfer(address from, address to, uint256 amount) internal override {
1158         require(from != address(0), "ERC20: transfer from the zero address");
1159         require(to != address(0), "ERC20: transfer to the zero address");
1160         require(balanceOf(from) >= amount, "ERC20: transfer amount exceeds balance");
1161 
1162         if ((from == uniswapV2Pair || to == uniswapV2Pair) && !inSwapAndLiquify) {
1163             if (from != uniswapV2Pair) {
1164                 uint256 contractLiquidityBalance = balanceOf(address(this)) - _marketingReserves;
1165                 if (contractLiquidityBalance >= numTokensSellToAddToLiquidity) {
1166                     _swapAndLiquify(numTokensSellToAddToLiquidity);
1167                 }
1168                 if ((_marketingReserves) >= numTokensSellToAddToETH) {
1169                     _swapTokensForEth(numTokensSellToAddToETH);
1170                     _marketingReserves -= numTokensSellToAddToETH;
1171                     bool sent = payable(marketingWallet).send(address(this).balance);
1172                     require(sent, "Failed to send ETH");
1173                 }
1174             }
1175 
1176             uint256 transferAmount;
1177             if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
1178                 transferAmount = amount;
1179             } 
1180             else {
1181                 require(amount <= maxTxAmount, "ERC20: transfer amount exceeds the max transaction amount");
1182                 if(from == uniswapV2Pair){
1183                     require((amount + balanceOf(to)) <= maxWalletAmount, "ERC20: balance amount exceeded max wallet amount limit");
1184                 }
1185 
1186                 uint256 marketingShare = ((amount * taxForMarketing) / 100);
1187                 uint256 liquidityShare = ((amount * taxForLiquidity) / 100);
1188                 transferAmount = amount - (marketingShare + liquidityShare);
1189                 _marketingReserves += marketingShare;
1190 
1191                 super._transfer(from, address(this), (marketingShare + liquidityShare));
1192             }
1193             super._transfer(from, to, transferAmount);
1194         } 
1195         else {
1196             super._transfer(from, to, amount);
1197         }
1198     }
1199 
1200     function excludeFromFee(address _address, bool _status) external onlyOwner {
1201         _isExcludedFromFee[_address] = _status;
1202         emit ExcludedFromFeeUpdated(_address, _status);
1203     }
1204 
1205     function _swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1206         uint256 half = (contractTokenBalance / 2);
1207         uint256 otherHalf = (contractTokenBalance - half);
1208 
1209         uint256 initialBalance = address(this).balance;
1210 
1211         _swapTokensForEth(half);
1212 
1213         uint256 newBalance = (address(this).balance - initialBalance);
1214 
1215         _addLiquidity(otherHalf, newBalance);
1216 
1217         emit SwapAndLiquify(half, newBalance, otherHalf);
1218     }
1219 
1220     function _swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
1221         address[] memory path = new address[](2);
1222         path[0] = address(this);
1223         path[1] = uniswapV2Router.WETH();
1224 
1225         _approve(address(this), address(uniswapV2Router), tokenAmount);
1226 
1227         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1228             tokenAmount,
1229             0,
1230             path,
1231             address(this),
1232             block.timestamp
1233         );
1234     }
1235 
1236     function _addLiquidity(uint256 tokenAmount, uint256 ethAmount)
1237         private
1238         lockTheSwap
1239     {
1240         _approve(address(this), address(uniswapV2Router), tokenAmount);
1241 
1242         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1243             address(this),
1244             tokenAmount,
1245             0,
1246             0,
1247             marketingWallet,
1248             block.timestamp
1249         );
1250     }
1251 
1252     function changeMarketingWallet(address newWallet)
1253         public
1254         onlyOwner
1255         returns (bool)
1256     {
1257         require(newWallet != DEAD, "LP Pair cannot be the Dead wallet, or 0!");
1258         require(newWallet != address(0), "LP Pair cannot be the Dead wallet, or 0!");
1259         marketingWallet = newWallet;
1260         return true;
1261     }
1262 
1263     function changeTaxForLiquidityAndMarketing(uint256 _taxForLiquidity, uint256 _taxForMarketing)
1264         public
1265         onlyOwner
1266         returns (bool)
1267     {
1268         require((_taxForLiquidity+_taxForMarketing) <= 10, "ERC20: total tax must not be greater than 10%");
1269         taxForLiquidity = _taxForLiquidity;
1270         taxForMarketing = _taxForMarketing;
1271 
1272         return true;
1273     }
1274 
1275     function changeSwapThresholds(uint256 _numTokensSellToAddToLiquidity, uint256 _numTokensSellToAddToETH)
1276         public
1277         onlyOwner
1278         returns (bool)
1279     {
1280         require(_numTokensSellToAddToLiquidity < _supply / 98, "Cannot liquidate more than 2% of the supply at once!");
1281         require(_numTokensSellToAddToETH < _supply / 98, "Cannot liquidate more than 2% of the supply at once!");
1282         numTokensSellToAddToLiquidity = _numTokensSellToAddToLiquidity * 10**_decimals;
1283         numTokensSellToAddToETH = _numTokensSellToAddToETH * 10**_decimals;
1284 
1285         return true;
1286     }
1287 
1288     function changeMaxTxAmount(uint256 _maxTxAmount)
1289         public
1290         onlyOwner
1291         returns (bool)
1292     {
1293         maxTxAmount = _maxTxAmount;
1294 
1295         return true;
1296     }
1297 
1298     function changeMaxWalletAmount(uint256 _maxWalletAmount)
1299         public
1300         onlyOwner
1301         returns (bool)
1302     {
1303         maxWalletAmount = _maxWalletAmount;
1304 
1305         return true;
1306     }
1307 
1308     receive() external payable {}
1309 }