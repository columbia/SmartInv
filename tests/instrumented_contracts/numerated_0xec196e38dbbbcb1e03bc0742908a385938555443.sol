1 /**
2  *  SourceUnit: /Users/jmf/dev/dappsAI/contracts/dappsAI.sol
3  */
4 
5 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
6 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Provides information about the current execution context, including the
12  * sender of the transaction and its data. While these are generally available
13  * via msg.sender and msg.data, they should not be accessed in such a direct
14  * manner, since when dealing with meta-transactions the account sending and
15  * paying for execution may not be the actual sender (as far as an application
16  * is concerned).
17  *
18  * This contract is only required for intermediate, library-like contracts.
19  */
20 abstract contract Context {
21     function _msgSender() internal view virtual returns (address) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view virtual returns (bytes calldata) {
26         return msg.data;
27     }
28 }
29 
30 /**
31  *  SourceUnit: /Users/jmf/dev/dappsAI/contracts/dappsAI.sol
32  */
33 
34 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
35 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
36 
37 pragma solidity ^0.8.0;
38 
39 /**
40  * @dev Interface of the ERC20 standard as defined in the EIP.
41  */
42 interface IERC20 {
43     /**
44      * @dev Emitted when `value` tokens are moved from one account (`from`) to
45      * another (`to`).
46      *
47      * Note that `value` may be zero.
48      */
49     event Transfer(address indexed from, address indexed to, uint256 value);
50 
51     /**
52      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
53      * a call to {approve}. `value` is the new allowance.
54      */
55     event Approval(
56         address indexed owner,
57         address indexed spender,
58         uint256 value
59     );
60 
61     /**
62      * @dev Returns the amount of tokens in existence.
63      */
64     function totalSupply() external view returns (uint256);
65 
66     /**
67      * @dev Returns the amount of tokens owned by `account`.
68      */
69     function balanceOf(address account) external view returns (uint256);
70 
71     /**
72      * @dev Moves `amount` tokens from the caller's account to `to`.
73      *
74      * Returns a boolean value indicating whether the operation succeeded.
75      *
76      * Emits a {Transfer} event.
77      */
78     function transfer(address to, uint256 amount) external returns (bool);
79 
80     /**
81      * @dev Returns the remaining number of tokens that `spender` will be
82      * allowed to spend on behalf of `owner` through {transferFrom}. This is
83      * zero by default.
84      *
85      * This value changes when {approve} or {transferFrom} are called.
86      */
87     function allowance(
88         address owner,
89         address spender
90     ) external view returns (uint256);
91 
92     /**
93      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
94      *
95      * Returns a boolean value indicating whether the operation succeeded.
96      *
97      * ////IMPORTANT: Beware that changing an allowance with this method brings the risk
98      * that someone may use both the old and the new allowance by unfortunate
99      * transaction ordering. One possible solution to mitigate this race
100      * condition is to first reduce the spender's allowance to 0 and set the
101      * desired value afterwards:
102      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
103      *
104      * Emits an {Approval} event.
105      */
106     function approve(address spender, uint256 amount) external returns (bool);
107 
108     /**
109      * @dev Moves `amount` tokens from `from` to `to` using the
110      * allowance mechanism. `amount` is then deducted from the caller's
111      * allowance.
112      *
113      * Returns a boolean value indicating whether the operation succeeded.
114      *
115      * Emits a {Transfer} event.
116      */
117     function transferFrom(
118         address from,
119         address to,
120         uint256 amount
121     ) external returns (bool);
122 }
123 
124 /**
125  *  SourceUnit: /Users/jmf/dev/dappsAI/contracts/dappsAI.sol
126  */
127 
128 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
129 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
130 
131 pragma solidity ^0.8.0;
132 
133 ////import "../IERC20.sol";
134 
135 /**
136  * @dev Interface for the optional metadata functions from the ERC20 standard.
137  *
138  * _Available since v4.1._
139  */
140 interface IERC20Metadata is IERC20 {
141     /**
142      * @dev Returns the name of the token.
143      */
144     function name() external view returns (string memory);
145 
146     /**
147      * @dev Returns the symbol of the token.
148      */
149     function symbol() external view returns (string memory);
150 
151     /**
152      * @dev Returns the decimals places of the token.
153      */
154     function decimals() external view returns (uint8);
155 }
156 
157 /**
158  *  SourceUnit: /Users/jmf/dev/dappsAI/contracts/dappsAI.sol
159  */
160 
161 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
162 pragma solidity 0.8.19;
163 
164 interface IUniswapV2Factory {
165     event PairCreated(
166         address indexed token0,
167         address indexed token1,
168         address pair,
169         uint256
170     );
171 
172     function feeTo() external view returns (address);
173 
174     function feeToSetter() external view returns (address);
175 
176     function getPair(
177         address tokenA,
178         address tokenB
179     ) external view returns (address pair);
180 
181     function allPairs(uint256) external view returns (address pair);
182 
183     function allPairsLength() external view returns (uint256);
184 
185     function createPair(
186         address tokenA,
187         address tokenB
188     ) external returns (address pair);
189 
190     function setFeeTo(address) external;
191 
192     function setFeeToSetter(address) external;
193 }
194 
195 interface IUniswapV2Pair {
196     event Approval(
197         address indexed owner,
198         address indexed spender,
199         uint256 value
200     );
201     event Transfer(address indexed from, address indexed to, uint256 value);
202 
203     function name() external pure returns (string memory);
204 
205     function symbol() external pure returns (string memory);
206 
207     function decimals() external pure returns (uint8);
208 
209     function totalSupply() external view returns (uint256);
210 
211     function balanceOf(address owner) external view returns (uint256);
212 
213     function allowance(
214         address owner,
215         address spender
216     ) external view returns (uint256);
217 
218     function approve(address spender, uint256 value) external returns (bool);
219 
220     function transfer(address to, uint256 value) external returns (bool);
221 
222     function transferFrom(
223         address from,
224         address to,
225         uint256 value
226     ) external returns (bool);
227 
228     function DOMAIN_SEPARATOR() external view returns (bytes32);
229 
230     function PERMIT_TYPEHASH() external pure returns (bytes32);
231 
232     function nonces(address owner) external view returns (uint256);
233 
234     function permit(
235         address owner,
236         address spender,
237         uint256 value,
238         uint256 deadline,
239         uint8 v,
240         bytes32 r,
241         bytes32 s
242     ) external;
243 
244     event Burn(
245         address indexed sender,
246         uint256 amount0,
247         uint256 amount1,
248         address indexed to
249     );
250     event Swap(
251         address indexed sender,
252         uint256 amount0In,
253         uint256 amount1In,
254         uint256 amount0Out,
255         uint256 amount1Out,
256         address indexed to
257     );
258     event Sync(uint112 reserve0, uint112 reserve1);
259 
260     function MINIMUM_LIQUIDITY() external pure returns (uint256);
261 
262     function factory() external view returns (address);
263 
264     function token0() external view returns (address);
265 
266     function token1() external view returns (address);
267 
268     function getReserves()
269         external
270         view
271         returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
272 
273     function price0CumulativeLast() external view returns (uint256);
274 
275     function price1CumulativeLast() external view returns (uint256);
276 
277     function kLast() external view returns (uint256);
278 
279     function burn(
280         address to
281     ) external returns (uint256 amount0, uint256 amount1);
282 
283     function swap(
284         uint256 amount0Out,
285         uint256 amount1Out,
286         address to,
287         bytes calldata data
288     ) external;
289 
290     function skim(address to) external;
291 
292     function sync() external;
293 
294     function initialize(address, address) external;
295 }
296 
297 // pragma solidity >=0.6.2;
298 
299 interface IUniswapV2Router01 {
300     function factory() external pure returns (address);
301 
302     function WETH() external pure returns (address);
303 
304     function addLiquidity(
305         address tokenA,
306         address tokenB,
307         uint256 amountADesired,
308         uint256 amountBDesired,
309         uint256 amountAMin,
310         uint256 amountBMin,
311         address to,
312         uint256 deadline
313     ) external returns (uint256 amountA, uint256 amountB, uint256 liquidity);
314 
315     function addLiquidityETH(
316         address token,
317         uint256 amountTokenDesired,
318         uint256 amountTokenMin,
319         uint256 amountETHMin,
320         address to,
321         uint256 deadline
322     )
323         external
324         payable
325         returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
326 
327     function removeLiquidity(
328         address tokenA,
329         address tokenB,
330         uint256 liquidity,
331         uint256 amountAMin,
332         uint256 amountBMin,
333         address to,
334         uint256 deadline
335     ) external returns (uint256 amountA, uint256 amountB);
336 
337     function removeLiquidityETH(
338         address token,
339         uint256 liquidity,
340         uint256 amountTokenMin,
341         uint256 amountETHMin,
342         address to,
343         uint256 deadline
344     ) external returns (uint256 amountToken, uint256 amountETH);
345 
346     function removeLiquidityWithPermit(
347         address tokenA,
348         address tokenB,
349         uint256 liquidity,
350         uint256 amountAMin,
351         uint256 amountBMin,
352         address to,
353         uint256 deadline,
354         bool approveMax,
355         uint8 v,
356         bytes32 r,
357         bytes32 s
358     ) external returns (uint256 amountA, uint256 amountB);
359 
360     function removeLiquidityETHWithPermit(
361         address token,
362         uint256 liquidity,
363         uint256 amountTokenMin,
364         uint256 amountETHMin,
365         address to,
366         uint256 deadline,
367         bool approveMax,
368         uint8 v,
369         bytes32 r,
370         bytes32 s
371     ) external returns (uint256 amountToken, uint256 amountETH);
372 
373     function swapExactTokensForTokens(
374         uint256 amountIn,
375         uint256 amountOutMin,
376         address[] calldata path,
377         address to,
378         uint256 deadline
379     ) external returns (uint256[] memory amounts);
380 
381     function swapTokensForExactTokens(
382         uint256 amountOut,
383         uint256 amountInMax,
384         address[] calldata path,
385         address to,
386         uint256 deadline
387     ) external returns (uint256[] memory amounts);
388 
389     function swapExactETHForTokens(
390         uint256 amountOutMin,
391         address[] calldata path,
392         address to,
393         uint256 deadline
394     ) external payable returns (uint256[] memory amounts);
395 
396     function swapTokensForExactETH(
397         uint256 amountOut,
398         uint256 amountInMax,
399         address[] calldata path,
400         address to,
401         uint256 deadline
402     ) external returns (uint256[] memory amounts);
403 
404     function swapExactTokensForETH(
405         uint256 amountIn,
406         uint256 amountOutMin,
407         address[] calldata path,
408         address to,
409         uint256 deadline
410     ) external returns (uint256[] memory amounts);
411 
412     function swapETHForExactTokens(
413         uint256 amountOut,
414         address[] calldata path,
415         address to,
416         uint256 deadline
417     ) external payable returns (uint256[] memory amounts);
418 
419     function quote(
420         uint256 amountA,
421         uint256 reserveA,
422         uint256 reserveB
423     ) external pure returns (uint256 amountB);
424 
425     function getAmountOut(
426         uint256 amountIn,
427         uint256 reserveIn,
428         uint256 reserveOut
429     ) external pure returns (uint256 amountOut);
430 
431     function getAmountIn(
432         uint256 amountOut,
433         uint256 reserveIn,
434         uint256 reserveOut
435     ) external pure returns (uint256 amountIn);
436 
437     function getAmountsOut(
438         uint256 amountIn,
439         address[] calldata path
440     ) external view returns (uint256[] memory amounts);
441 
442     function getAmountsIn(
443         uint256 amountOut,
444         address[] calldata path
445     ) external view returns (uint256[] memory amounts);
446 }
447 
448 interface IUniswapV2Router02 is IUniswapV2Router01 {
449     function removeLiquidityETHSupportingFeeOnTransferTokens(
450         address token,
451         uint256 liquidity,
452         uint256 amountTokenMin,
453         uint256 amountETHMin,
454         address to,
455         uint256 deadline
456     ) external returns (uint256 amountETH);
457 
458     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
459         address token,
460         uint256 liquidity,
461         uint256 amountTokenMin,
462         uint256 amountETHMin,
463         address to,
464         uint256 deadline,
465         bool approveMax,
466         uint8 v,
467         bytes32 r,
468         bytes32 s
469     ) external returns (uint256 amountETH);
470 
471     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
472         uint256 amountIn,
473         uint256 amountOutMin,
474         address[] calldata path,
475         address to,
476         uint256 deadline
477     ) external;
478 
479     function swapExactETHForTokensSupportingFeeOnTransferTokens(
480         uint256 amountOutMin,
481         address[] calldata path,
482         address to,
483         uint256 deadline
484     ) external payable;
485 
486     function swapExactTokensForETHSupportingFeeOnTransferTokens(
487         uint256 amountIn,
488         uint256 amountOutMin,
489         address[] calldata path,
490         address to,
491         uint256 deadline
492     ) external;
493 }
494 
495 /**
496  *  SourceUnit: /Users/jmf/dev/dappsAI/contracts/dappsAI.sol
497  */
498 
499 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
500 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
501 
502 pragma solidity ^0.8.0;
503 
504 ////import "../utils/Context.sol";
505 
506 /**
507  * @dev Contract module which provides a basic access control mechanism, where
508  * there is an account (an owner) that can be granted exclusive access to
509  * specific functions.
510  *
511  * By default, the owner account will be the one that deploys the contract. This
512  * can later be changed with {transferOwnership}.
513  *
514  * This module is used through inheritance. It will make available the modifier
515  * `onlyOwner`, which can be applied to your functions to restrict their use to
516  * the owner.
517  */
518 abstract contract Ownable is Context {
519     address private _owner;
520 
521     event OwnershipTransferred(
522         address indexed previousOwner,
523         address indexed newOwner
524     );
525 
526     /**
527      * @dev Initializes the contract setting the deployer as the initial owner.
528      */
529     constructor() {
530         _transferOwnership(_msgSender());
531     }
532 
533     /**
534      * @dev Throws if called by any account other than the owner.
535      */
536     modifier onlyOwner() {
537         _checkOwner();
538         _;
539     }
540 
541     /**
542      * @dev Returns the address of the current owner.
543      */
544     function owner() public view virtual returns (address) {
545         return _owner;
546     }
547 
548     /**
549      * @dev Throws if the sender is not the owner.
550      */
551     function _checkOwner() internal view virtual {
552         require(owner() == _msgSender(), "Ownable: caller is not the owner");
553     }
554 
555     /**
556      * @dev Leaves the contract without owner. It will not be possible to call
557      * `onlyOwner` functions anymore. Can only be called by the current owner.
558      *
559      * NOTE: Renouncing ownership will leave the contract without an owner,
560      * thereby removing any functionality that is only available to the owner.
561      */
562     function renounceOwnership() public virtual onlyOwner {
563         _transferOwnership(address(0));
564     }
565 
566     /**
567      * @dev Transfers ownership of the contract to a new account (`newOwner`).
568      * Can only be called by the current owner.
569      */
570     function transferOwnership(address newOwner) public virtual onlyOwner {
571         require(
572             newOwner != address(0),
573             "Ownable: new owner is the zero address"
574         );
575         _transferOwnership(newOwner);
576     }
577 
578     /**
579      * @dev Transfers ownership of the contract to a new account (`newOwner`).
580      * Internal function without access restriction.
581      */
582     function _transferOwnership(address newOwner) internal virtual {
583         address oldOwner = _owner;
584         _owner = newOwner;
585         emit OwnershipTransferred(oldOwner, newOwner);
586     }
587 }
588 
589 /**
590  *  SourceUnit: /Users/jmf/dev/dappsAI/contracts/dappsAI.sol
591  */
592 
593 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
594 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
595 
596 pragma solidity ^0.8.0;
597 
598 ////import "./IERC20.sol";
599 ////import "./extensions/IERC20Metadata.sol";
600 ////import "../../utils/Context.sol";
601 
602 /**
603  * @dev Implementation of the {IERC20} interface.
604  *
605  * This implementation is agnostic to the way tokens are created. This means
606  * that a supply mechanism has to be added in a derived contract using {_mint}.
607  * For a generic mechanism see {ERC20PresetMinterPauser}.
608  *
609  * TIP: For a detailed writeup see our guide
610  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
611  * to implement supply mechanisms].
612  *
613  * We have followed general OpenZeppelin Contracts guidelines: functions revert
614  * instead returning `false` on failure. This behavior is nonetheless
615  * conventional and does not conflict with the expectations of ERC20
616  * applications.
617  *
618  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
619  * This allows applications to reconstruct the allowance for all accounts just
620  * by listening to said events. Other implementations of the EIP may not emit
621  * these events, as it isn't required by the specification.
622  *
623  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
624  * functions have been added to mitigate the well-known issues around setting
625  * allowances. See {IERC20-approve}.
626  */
627 contract ERC20 is Context, IERC20, IERC20Metadata {
628     mapping(address => uint256) private _balances;
629 
630     mapping(address => mapping(address => uint256)) private _allowances;
631 
632     uint256 private _totalSupply;
633 
634     string private _name;
635     string private _symbol;
636 
637     /**
638      * @dev Sets the values for {name} and {symbol}.
639      *
640      * The default value of {decimals} is 18. To select a different value for
641      * {decimals} you should overload it.
642      *
643      * All two of these values are immutable: they can only be set once during
644      * construction.
645      */
646     constructor(string memory name_, string memory symbol_) {
647         _name = name_;
648         _symbol = symbol_;
649     }
650 
651     /**
652      * @dev Returns the name of the token.
653      */
654     function name() public view virtual override returns (string memory) {
655         return _name;
656     }
657 
658     /**
659      * @dev Returns the symbol of the token, usually a shorter version of the
660      * name.
661      */
662     function symbol() public view virtual override returns (string memory) {
663         return _symbol;
664     }
665 
666     /**
667      * @dev Returns the number of decimals used to get its user representation.
668      * For example, if `decimals` equals `2`, a balance of `505` tokens should
669      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
670      *
671      * Tokens usually opt for a value of 18, imitating the relationship between
672      * Ether and Wei. This is the value {ERC20} uses, unless this function is
673      * overridden;
674      *
675      * NOTE: This information is only used for _display_ purposes: it in
676      * no way affects any of the arithmetic of the contract, including
677      * {IERC20-balanceOf} and {IERC20-transfer}.
678      */
679     function decimals() public view virtual override returns (uint8) {
680         return 18;
681     }
682 
683     /**
684      * @dev See {IERC20-totalSupply}.
685      */
686     function totalSupply() public view virtual override returns (uint256) {
687         return _totalSupply;
688     }
689 
690     /**
691      * @dev See {IERC20-balanceOf}.
692      */
693     function balanceOf(
694         address account
695     ) public view virtual override returns (uint256) {
696         return _balances[account];
697     }
698 
699     /**
700      * @dev See {IERC20-transfer}.
701      *
702      * Requirements:
703      *
704      * - `to` cannot be the zero address.
705      * - the caller must have a balance of at least `amount`.
706      */
707     function transfer(
708         address to,
709         uint256 amount
710     ) public virtual override returns (bool) {
711         address owner = _msgSender();
712         _transfer(owner, to, amount);
713         return true;
714     }
715 
716     /**
717      * @dev See {IERC20-allowance}.
718      */
719     function allowance(
720         address owner,
721         address spender
722     ) public view virtual override returns (uint256) {
723         return _allowances[owner][spender];
724     }
725 
726     /**
727      * @dev See {IERC20-approve}.
728      *
729      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
730      * `transferFrom`. This is semantically equivalent to an infinite approval.
731      *
732      * Requirements:
733      *
734      * - `spender` cannot be the zero address.
735      */
736     function approve(
737         address spender,
738         uint256 amount
739     ) public virtual override returns (bool) {
740         address owner = _msgSender();
741         _approve(owner, spender, amount);
742         return true;
743     }
744 
745     /**
746      * @dev See {IERC20-transferFrom}.
747      *
748      * Emits an {Approval} event indicating the updated allowance. This is not
749      * required by the EIP. See the note at the beginning of {ERC20}.
750      *
751      * NOTE: Does not update the allowance if the current allowance
752      * is the maximum `uint256`.
753      *
754      * Requirements:
755      *
756      * - `from` and `to` cannot be the zero address.
757      * - `from` must have a balance of at least `amount`.
758      * - the caller must have allowance for ``from``'s tokens of at least
759      * `amount`.
760      */
761     function transferFrom(
762         address from,
763         address to,
764         uint256 amount
765     ) public virtual override returns (bool) {
766         address spender = _msgSender();
767         _spendAllowance(from, spender, amount);
768         _transfer(from, to, amount);
769         return true;
770     }
771 
772     /**
773      * @dev Atomically increases the allowance granted to `spender` by the caller.
774      *
775      * This is an alternative to {approve} that can be used as a mitigation for
776      * problems described in {IERC20-approve}.
777      *
778      * Emits an {Approval} event indicating the updated allowance.
779      *
780      * Requirements:
781      *
782      * - `spender` cannot be the zero address.
783      */
784     function increaseAllowance(
785         address spender,
786         uint256 addedValue
787     ) public virtual returns (bool) {
788         address owner = _msgSender();
789         _approve(owner, spender, allowance(owner, spender) + addedValue);
790         return true;
791     }
792 
793     /**
794      * @dev Atomically decreases the allowance granted to `spender` by the caller.
795      *
796      * This is an alternative to {approve} that can be used as a mitigation for
797      * problems described in {IERC20-approve}.
798      *
799      * Emits an {Approval} event indicating the updated allowance.
800      *
801      * Requirements:
802      *
803      * - `spender` cannot be the zero address.
804      * - `spender` must have allowance for the caller of at least
805      * `subtractedValue`.
806      */
807     function decreaseAllowance(
808         address spender,
809         uint256 subtractedValue
810     ) public virtual returns (bool) {
811         address owner = _msgSender();
812         uint256 currentAllowance = allowance(owner, spender);
813         require(
814             currentAllowance >= subtractedValue,
815             "ERC20: decreased allowance below zero"
816         );
817         unchecked {
818             _approve(owner, spender, currentAllowance - subtractedValue);
819         }
820 
821         return true;
822     }
823 
824     /**
825      * @dev Moves `amount` of tokens from `from` to `to`.
826      *
827      * This internal function is equivalent to {transfer}, and can be used to
828      * e.g. implement automatic token fees, slashing mechanisms, etc.
829      *
830      * Emits a {Transfer} event.
831      *
832      * Requirements:
833      *
834      * - `from` cannot be the zero address.
835      * - `to` cannot be the zero address.
836      * - `from` must have a balance of at least `amount`.
837      */
838     function _transfer(
839         address from,
840         address to,
841         uint256 amount
842     ) internal virtual {
843         require(from != address(0), "ERC20: transfer from the zero address");
844         require(to != address(0), "ERC20: transfer to the zero address");
845 
846         _beforeTokenTransfer(from, to, amount);
847 
848         uint256 fromBalance = _balances[from];
849         require(
850             fromBalance >= amount,
851             "ERC20: transfer amount exceeds balance"
852         );
853         unchecked {
854             _balances[from] = fromBalance - amount;
855             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
856             // decrementing then incrementing.
857             _balances[to] += amount;
858         }
859 
860         emit Transfer(from, to, amount);
861 
862         _afterTokenTransfer(from, to, amount);
863     }
864 
865     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
866      * the total supply.
867      *
868      * Emits a {Transfer} event with `from` set to the zero address.
869      *
870      * Requirements:
871      *
872      * - `account` cannot be the zero address.
873      */
874     function _mint(address account, uint256 amount) internal virtual {
875         require(account != address(0), "ERC20: mint to the zero address");
876 
877         _beforeTokenTransfer(address(0), account, amount);
878 
879         _totalSupply += amount;
880         unchecked {
881             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
882             _balances[account] += amount;
883         }
884         emit Transfer(address(0), account, amount);
885 
886         _afterTokenTransfer(address(0), account, amount);
887     }
888 
889     /**
890      * @dev Destroys `amount` tokens from `account`, reducing the
891      * total supply.
892      *
893      * Emits a {Transfer} event with `to` set to the zero address.
894      *
895      * Requirements:
896      *
897      * - `account` cannot be the zero address.
898      * - `account` must have at least `amount` tokens.
899      */
900     function _burn(address account, uint256 amount) internal virtual {
901         require(account != address(0), "ERC20: burn from the zero address");
902 
903         _beforeTokenTransfer(account, address(0), amount);
904 
905         uint256 accountBalance = _balances[account];
906         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
907         unchecked {
908             _balances[account] = accountBalance - amount;
909             // Overflow not possible: amount <= accountBalance <= totalSupply.
910             _totalSupply -= amount;
911         }
912 
913         emit Transfer(account, address(0), amount);
914 
915         _afterTokenTransfer(account, address(0), amount);
916     }
917 
918     /**
919      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
920      *
921      * This internal function is equivalent to `approve`, and can be used to
922      * e.g. set automatic allowances for certain subsystems, etc.
923      *
924      * Emits an {Approval} event.
925      *
926      * Requirements:
927      *
928      * - `owner` cannot be the zero address.
929      * - `spender` cannot be the zero address.
930      */
931     function _approve(
932         address owner,
933         address spender,
934         uint256 amount
935     ) internal virtual {
936         require(owner != address(0), "ERC20: approve from the zero address");
937         require(spender != address(0), "ERC20: approve to the zero address");
938 
939         _allowances[owner][spender] = amount;
940         emit Approval(owner, spender, amount);
941     }
942 
943     /**
944      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
945      *
946      * Does not update the allowance amount in case of infinite allowance.
947      * Revert if not enough allowance is available.
948      *
949      * Might emit an {Approval} event.
950      */
951     function _spendAllowance(
952         address owner,
953         address spender,
954         uint256 amount
955     ) internal virtual {
956         uint256 currentAllowance = allowance(owner, spender);
957         if (currentAllowance != type(uint256).max) {
958             require(
959                 currentAllowance >= amount,
960                 "ERC20: insufficient allowance"
961             );
962             unchecked {
963                 _approve(owner, spender, currentAllowance - amount);
964             }
965         }
966     }
967 
968     /**
969      * @dev Hook that is called before any transfer of tokens. This includes
970      * minting and burning.
971      *
972      * Calling conditions:
973      *
974      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
975      * will be transferred to `to`.
976      * - when `from` is zero, `amount` tokens will be minted for `to`.
977      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
978      * - `from` and `to` are never both zero.
979      *
980      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
981      */
982     function _beforeTokenTransfer(
983         address from,
984         address to,
985         uint256 amount
986     ) internal virtual {}
987 
988     /**
989      * @dev Hook that is called after any transfer of tokens. This includes
990      * minting and burning.
991      *
992      * Calling conditions:
993      *
994      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
995      * has been transferred to `to`.
996      * - when `from` is zero, `amount` tokens have been minted for `to`.
997      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
998      * - `from` and `to` are never both zero.
999      *
1000      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1001      */
1002     function _afterTokenTransfer(
1003         address from,
1004         address to,
1005         uint256 amount
1006     ) internal virtual {}
1007 }
1008 
1009 /**
1010  *  SourceUnit: /Users/jmf/dev/dappsAI/contracts/dappsAI.sol
1011  */
1012 
1013 //  SPDX-License-Identifier: MIT
1014 pragma solidity 0.8.19;
1015 
1016 ////import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
1017 ////import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
1018 ////import "@openzeppelin/contracts/access/Ownable.sol";
1019 ////import "./interfaces/IUniswap.sol";
1020 
1021 contract dAppsAI is ERC20, Ownable {
1022     mapping(address => bool) public blacklist;
1023     mapping(address => bool) public feeExempt;
1024     mapping(address => bool) public maxTxExempt;
1025     mapping(address => uint) private lastTx;
1026     mapping(address => bool) private cooldownWhitelist;
1027     mapping(address => bool) public preExemption;
1028     mapping(address => bool) public maxWalletExempt;
1029 
1030     uint8 public constant blockCooldown = 5;
1031 
1032     address public marketing;
1033     address public stakingPool;
1034 
1035     uint public totalBuyFee;
1036     uint public totalSellFee;
1037 
1038     uint public maxWalletAmount;
1039     uint public maxTxAmount;
1040     uint public maxBuyTxAmount;
1041     uint public maxSellTxAmount;
1042 
1043     uint public marketingFees;
1044     uint public stakingFees;
1045     uint public liquidityFees;
1046 
1047     uint public totalMarketingFees;
1048     uint public totalStakingFees;
1049     uint public totalLiquidityFees;
1050 
1051     uint public swapThreshold = 10 ether;
1052 
1053     uint8[3] public buyFees;
1054     uint8[3] public sellFees;
1055     uint256 public constant BASE = 100;
1056     address public constant DEAD_WALLET =
1057         0x000000000000000000000000000000000000dEaD;
1058 
1059     bool public tradingOpen = false;
1060     bool public limitsRemoved = false;
1061     bool private swapping = false;
1062 
1063     IUniswapV2Pair public pair;
1064     IUniswapV2Router02 public router;
1065 
1066     event SwapAndLiquify(
1067         uint256 tokensSwapped,
1068         uint256 ethReceived,
1069         uint256 tokensIntoLiqudity
1070     );
1071 
1072     /// @notice Modifier to check if this is an internal swap
1073     modifier swapExecuting() {
1074         swapping = true;
1075         _;
1076         swapping = false;
1077     }
1078 
1079     constructor(address _mkt, address _stk) ERC20("Dapps AI", "DAPPSAI") {
1080         require(_mkt != address(0) && _stk != address(0), "Invalid address");
1081         marketing = _mkt;
1082         stakingPool = _stk;
1083         // 100 million tokens
1084         _mint(msg.sender, 100_000_000 ether);
1085         // max Tx amount is 1% of total supply
1086         maxTxAmount = 100_000_000 ether / 100;
1087         maxBuyTxAmount = maxTxAmount;
1088         maxSellTxAmount = maxTxAmount;
1089         // max wallet amount is 3% of total supply
1090         maxWalletAmount = maxTxAmount * 3;
1091 
1092         buyFees[0] = 5;
1093         buyFees[1] = 2;
1094         buyFees[2] = 1;
1095         sellFees[0] = 5;
1096         sellFees[1] = 2;
1097         sellFees[2] = 1;
1098 
1099         totalBuyFee = buyFees[0] + buyFees[1] + buyFees[2];
1100         totalSellFee = sellFees[0] + sellFees[1] + sellFees[2];
1101 
1102         // Set Uniswap V2 Router for both ETH and ARBITRUM
1103         if (block.chainid == 1) {
1104             router = IUniswapV2Router02(
1105                 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1106             );
1107         } else if (block.chainid == 42161) {
1108             // need to double check this address on ARBITRUM
1109             router = IUniswapV2Router02(
1110                 0xE54Ca86531e17Ef3616d22Ca28b0D458b6C89106
1111             );
1112         } else revert("Chain not supported");
1113 
1114         IUniswapV2Factory factory = IUniswapV2Factory(router.factory());
1115         pair = IUniswapV2Pair(factory.createPair(address(this), router.WETH()));
1116 
1117         setFeeExempt(address(this), true);
1118         setFeeExempt(owner(), true);
1119         setMaxTxExempt(address(this), true);
1120         setMaxTxExempt(owner(), true);
1121         setCooldownWhitelist(address(this), true);
1122         setCooldownWhitelist(owner(), true);
1123         setCooldownWhitelist(marketing, true);
1124         setCooldownWhitelist(address(pair), true);
1125         setCooldownWhitelist(address(router), true);
1126         setMaxWalletExempt(address(this), true);
1127         setMaxWalletExempt(owner(), true);
1128         setMaxWalletExempt(marketing, true);
1129         setMaxWalletExempt(address(pair), true);
1130         setMaxWalletExempt(address(router), true);
1131         setPreExemption(address(this), true);
1132         setPreExemption(owner(), true);
1133     }
1134 
1135     /// @notice Allowed to receive ETH
1136     receive() external payable {}
1137 
1138     /// @notice Checks before Token Transfer
1139     /// @param from Address of sender
1140     /// @param to Address of receiver
1141     /// @param amount Amount of tokens to transfer
1142     /// @dev Checks if the sender and receiver are blacklisted or if amounts are within limits
1143     function _beforeTransfer(
1144         address from,
1145         address to,
1146         uint256 amount
1147     ) internal {
1148         if (limitsRemoved || from == address(0) || to == address(0) || swapping)
1149             return;
1150         require(
1151             !blacklist[from] && !blacklist[to],
1152             "BUNAI: Blacklisted address"
1153         );
1154         // Only Owner can transfer tokens before trading is open
1155         if (!tradingOpen) require(preExemption[from], "BUNAI: Trading blocked");
1156 
1157         if (!maxTxExempt[from]) {
1158             if (from == address(pair)) {
1159                 require(
1160                     amount <= maxBuyTxAmount,
1161                     "BUNAI: Max buy amount exceeded"
1162                 );
1163             } else if (to == address(pair)) {
1164                 require(
1165                     amount <= maxSellTxAmount,
1166                     "BUNAI: Max sell amount exceeded"
1167                 );
1168             }
1169         }
1170         if (!maxWalletExempt[to]) {
1171             require(
1172                 balanceOf(to) + amount <= maxWalletAmount,
1173                 "BUNAI: Max wallet amount exceeded"
1174             );
1175         }
1176         if (!cooldownWhitelist[from]) {
1177             require(lastTx[from] <= block.number, "BUNAI: Bot?");
1178             lastTx[from] = block.number + blockCooldown;
1179         }
1180     }
1181 
1182     /// @notice Burn tokens from sender address
1183     /// @param amount Amount of tokens to burn
1184     function burn(uint256 amount) external {
1185         _burn(msg.sender, amount);
1186     }
1187 
1188     /// @notice Burn tokens from other owners as long as it is approved
1189     /// @param account Address of owner
1190     /// @param amount Amount of tokens to burn
1191     function burnFrom(address account, uint256 amount) external {
1192         require(
1193             amount <= allowance(account, msg.sender),
1194             "BUNAI: Not enough allowance"
1195         );
1196         uint256 decreasedAllowance = allowance(account, msg.sender) - amount;
1197         _approve(account, msg.sender, decreasedAllowance);
1198         _burn(account, amount);
1199     }
1200 
1201     /// @notice Internal transfer tokens
1202     /// @param sender Address of receiver
1203     /// @param recipient Address of receiver
1204     /// @param amount Amount of tokens to transfer
1205     /// @dev calls _beforeTokenTransfer, manages taxes and transfers tokens
1206     function _transfer(
1207         address sender,
1208         address recipient,
1209         uint256 amount
1210     ) internal override {
1211         _beforeTransfer(sender, recipient, amount);
1212         if (!swapping) {
1213             uint currentTokensHeld = balanceOf(address(this));
1214             if (
1215                 currentTokensHeld >= swapThreshold &&
1216                 sender != address(pair) &&
1217                 sender != address(router)
1218             ) {
1219                 _handleSwapAndDistribute(currentTokensHeld);
1220             }
1221 
1222             if (
1223                 ((sender == address(pair) && !feeExempt[recipient]) ||
1224                     (recipient == address(pair) && !feeExempt[sender]))
1225             ) {
1226                 uint totalFee = takeFee(amount, sender == address(pair));
1227                 super._transfer(sender, address(this), totalFee);
1228                 amount -= totalFee;
1229             }
1230         }
1231 
1232         super._transfer(sender, recipient, amount);
1233     }
1234 
1235     /// @notice Set the fee for a specific transaction type
1236     /// @param amount Amount of transaction
1237     /// @param isBuy True if transaction is a buy, false if transaction is a sell
1238     /// @return totalFee Total fee taken in this transaction
1239     function takeFee(
1240         uint256 amount,
1241         bool isBuy
1242     ) internal returns (uint256 totalFee) {
1243         uint selectedFee = isBuy ? totalBuyFee : totalSellFee;
1244         totalFee = (selectedFee * amount) / BASE;
1245 
1246         uint8[3] storage fees = isBuy ? buyFees : sellFees;
1247 
1248         uint marketingFee = (fees[0] * totalFee) / selectedFee;
1249         uint poolFee = (fees[1] * totalFee) / selectedFee;
1250         uint liqFee = totalFee - marketingFee - poolFee;
1251 
1252         marketingFees += marketingFee;
1253         stakingFees += poolFee;
1254         liquidityFees += liqFee;
1255     }
1256 
1257     /// @notice Swap tokens for ETH and distribute to marketing, liquidity and staking
1258     /// @param tokensHeld Amount of tokens held in contract to swap
1259     /// @dev to make the most out of the liquidity that is added, the contract will swap and add liquidity before swapping the amount to distribute
1260     function _handleSwapAndDistribute(uint tokensHeld) private swapExecuting {
1261         uint totalFees = marketingFees + stakingFees + liquidityFees;
1262 
1263         uint mkt = marketingFees;
1264         uint stk = stakingFees;
1265         uint liq = liquidityFees;
1266 
1267         if (totalFees != tokensHeld) {
1268             mkt = (marketingFees * tokensHeld) / totalFees;
1269             stk = (stakingFees * tokensHeld) / totalFees;
1270             liq = tokensHeld - mkt - stk;
1271         }
1272         if (liq > 0) _swapAndLiquify(liq);
1273 
1274         if (mkt + stk > 0) {
1275             swapTokensForEth(mkt + stk);
1276             uint ethBalance = address(this).balance;
1277             bool succ;
1278             if (mkt > 0) {
1279                 mkt = (mkt * ethBalance) / (mkt + stk);
1280                 (succ, ) = payable(marketing).call{value: mkt}("");
1281                 require(succ);
1282                 totalMarketingFees += mkt;
1283             }
1284             if (stk > 0) {
1285                 stk = ethBalance - mkt;
1286                 (succ, ) = payable(stakingPool).call{value: stk}("");
1287                 require(succ);
1288                 totalStakingFees += stk;
1289             }
1290         }
1291         marketingFees = 0;
1292         stakingFees = 0;
1293         liquidityFees = 0;
1294     }
1295 
1296     /// @notice Swap half of tokens for ETH and create liquidity from an external call
1297     function swapAndLiquify() public swapExecuting {
1298         require(
1299             liquidityFees >= balanceOf(address(this)),
1300             "BUNAI: Not enough tokens"
1301         );
1302         _swapAndLiquify(liquidityFees);
1303         liquidityFees = 0;
1304     }
1305 
1306     /// @notice Swap half tokens for ETH and create liquidity internally
1307     /// @param tokens Amount of tokens to swap
1308     function _swapAndLiquify(uint tokens) private {
1309         uint half = tokens / 2;
1310         uint otherHalf = tokens - half;
1311 
1312         uint initialBalance = address(this).balance;
1313 
1314         swapTokensForEth(half);
1315 
1316         uint newBalance = address(this).balance - initialBalance;
1317 
1318         _approve(address(this), address(router), otherHalf);
1319         (, , uint liquidity) = router.addLiquidityETH{value: newBalance}(
1320             address(this),
1321             otherHalf,
1322             0,
1323             0,
1324             DEAD_WALLET,
1325             block.timestamp
1326         );
1327 
1328         totalLiquidityFees += liquidity;
1329 
1330         emit SwapAndLiquify(half, newBalance, liquidity);
1331     }
1332 
1333     /// @notice Swap tokens for ETH
1334     function swapTokensForEth(uint tokens) private {
1335         address[] memory path = new address[](2);
1336         path[0] = address(this);
1337         path[1] = router.WETH();
1338 
1339         _approve(address(this), address(router), tokens);
1340 
1341         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1342             tokens,
1343             0,
1344             path,
1345             address(this),
1346             block.timestamp
1347         );
1348     }
1349 
1350     // Only Owner section
1351     ///@notice Set the fee for buy transactions
1352     ///@param _marketing Marketing fee
1353     ///@param _pool Staking Pool fee
1354     ///@param _liq Liquidity fee
1355     ///@dev Fees are in percentage and cant be more than 25%
1356     function setBuyFees(
1357         uint8 _marketing,
1358         uint8 _pool,
1359         uint8 _liq
1360     ) external onlyOwner {
1361         totalBuyFee = _marketing + _pool + _liq;
1362         require(totalBuyFee <= 25, "Fees cannot be more than 25%");
1363         buyFees = [_marketing, _pool, _liq];
1364     }
1365 
1366     ///@notice Set the fee for sell transactions
1367     ///@param _marketing Marketing fee
1368     ///@param _pool Staking Pool fee
1369     ///@param _liq Liquidity fee
1370     ///@dev Fees are in percentage and cant be more than 25%
1371     function setSellFees(
1372         uint8 _marketing,
1373         uint8 _pool,
1374         uint8 _liq
1375     ) external onlyOwner {
1376         totalSellFee = _marketing + _pool + _liq;
1377         require(totalSellFee <= 25, "Fees cannot be more than 25%");
1378         sellFees = [_marketing, _pool, _liq];
1379     }
1380 
1381     ///@notice set address to be exempt from fees
1382     ///@param _address Address to be exempt
1383     ///@param exempt true or false
1384     function setFeeExempt(address _address, bool exempt) public onlyOwner {
1385         feeExempt[_address] = exempt;
1386     }
1387 
1388     ///@notice set address to be blacklisted
1389     ///@param _address Address to be blacklisted
1390     ///@param _blacklist true or false
1391     function setBlacklist(
1392         address _address,
1393         bool _blacklist
1394     ) external onlyOwner {
1395         blacklist[_address] = _blacklist;
1396     }
1397 
1398     ///@notice allow token trading to start
1399     function openTrade() external onlyOwner {
1400         tradingOpen = true;
1401     }
1402 
1403     ///@notice get tokens sent "mistakenly" to the contract
1404     ///@param _token Address of the token to be recovered
1405     function recoverToken(address _token) external onlyOwner {
1406         require(_token != address(this), "Cannot withdraw BUNAI");
1407         uint256 balance = IERC20(_token).balanceOf(address(this));
1408         IERC20(_token).transfer(msg.sender, balance);
1409     }
1410 
1411     /// @notice recover ETH sent to the contract
1412     function recoverETH() external onlyOwner {
1413         (bool succ, ) = payable(msg.sender).call{value: address(this).balance}(
1414             ""
1415         );
1416         require(succ, "Transfer failed");
1417     }
1418 
1419     ///@notice set the marketing wallet address
1420     ///@param _marketing Address of the new marketing wallet
1421     ///@dev Marketing wallet address cannot be 0x0 or the current marketing wallet address
1422     function setMarketingWallet(address _marketing) external onlyOwner {
1423         require(
1424             _marketing != address(0) && _marketing != marketing,
1425             "Invalid address"
1426         );
1427         marketing = _marketing;
1428     }
1429 
1430     ///@notice set the staking pool address
1431     ///@param _stakingPool Address of the new staking pool
1432     ///@dev Staking pool address cannot be 0x0 or the current staking pool address
1433     function setStakingPool(address _stakingPool) external onlyOwner {
1434         require(
1435             _stakingPool != address(0) && _stakingPool != stakingPool,
1436             "Invalid address"
1437         );
1438         stakingPool = _stakingPool;
1439     }
1440 
1441     ///@notice set address to be exempt from max buys and sells
1442     ///@param _address Address to be exempt
1443     ///@param exempt true or false
1444     function setMaxTxExempt(address _address, bool exempt) public onlyOwner {
1445         maxTxExempt[_address] = exempt;
1446     }
1447 
1448     function setMaxBuy(uint256 _amount) external onlyOwner {
1449         require(_amount >= maxTxAmount, "Invalid Max Buy Amount");
1450         maxBuyTxAmount = _amount;
1451     }
1452 
1453     function setMaxSell(uint256 _amount) external onlyOwner {
1454         require(_amount >= maxTxAmount, "Invalid Max Sell Amount");
1455         maxSellTxAmount = _amount;
1456     }
1457 
1458     function setMaxTxAmount(uint256 _amount) external onlyOwner {
1459         require(_amount >= totalSupply() / 100, "Invalid Max Tx Amount");
1460         maxTxAmount = _amount;
1461     }
1462 
1463     function setMaxWalletAmount(uint256 _amount) external onlyOwner {
1464         require(_amount >= totalSupply() / 100, "Invalid Max Wallet Amount");
1465         maxWalletAmount = _amount;
1466     }
1467 
1468     function setSwapThreshold(uint256 _amount) external onlyOwner {
1469         require(_amount >= 0, "Invalid Min Token Swap Amount");
1470         swapThreshold = _amount;
1471     }
1472 
1473     function setCooldownWhitelist(
1474         address _address,
1475         bool _whitelist
1476     ) public onlyOwner {
1477         cooldownWhitelist[_address] = _whitelist;
1478     }
1479 
1480     function setPreExemption(address _address, bool _exempt) public onlyOwner {
1481         preExemption[_address] = _exempt;
1482     }
1483 
1484     function setMaxWalletExempt(
1485         address _address,
1486         bool _exempt
1487     ) public onlyOwner {
1488         maxWalletExempt[_address] = _exempt;
1489     }
1490 
1491     function removeAllLimits() external onlyOwner {
1492         limitsRemoved = true;
1493     }
1494 }