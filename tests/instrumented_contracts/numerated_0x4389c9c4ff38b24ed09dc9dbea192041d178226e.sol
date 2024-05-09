1 /**
2 
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity 0.8.16;
8 
9 interface IUniswapV2Factory {
10     event PairCreated(
11         address indexed token0,
12         address indexed token1,
13         address pair,
14         uint256
15     );
16 
17     function feeTo() external view returns (address);
18 
19     function feeToSetter() external view returns (address);
20 
21     function allPairsLength() external view returns (uint256);
22 
23     function getPair(address tokenA, address tokenB)
24         external
25         view
26         returns (address pair);
27 
28     function allPairs(uint256) external view returns (address pair);
29 
30     function createPair(address tokenA, address tokenB)
31         external
32         returns (address pair);
33 
34     function setFeeTo(address) external;
35 
36     function setFeeToSetter(address) external;
37 }
38 
39 interface IUniswapV2Pair {
40     event Approval(
41         address indexed owner,
42         address indexed spender,
43         uint256 value
44     );
45     event Transfer(address indexed from, address indexed to, uint256 value);
46 
47     function name() external pure returns (string memory);
48 
49     function symbol() external pure returns (string memory);
50 
51     function decimals() external pure returns (uint8);
52 
53     function totalSupply() external view returns (uint256);
54 
55     function balanceOf(address owner) external view returns (uint256);
56 
57     function allowance(address owner, address spender)
58         external
59         view
60         returns (uint256);
61 
62     function approve(address spender, uint256 value) external returns (bool);
63 
64     function transfer(address to, uint256 value) external returns (bool);
65 
66     function transferFrom(
67         address from,
68         address to,
69         uint256 value
70     ) external returns (bool);
71 
72     function DOMAIN_SEPARATOR() external view returns (bytes32);
73 
74     function PERMIT_TYPEHASH() external pure returns (bytes32);
75 
76     function nonces(address owner) external view returns (uint256);
77 
78     function permit(
79         address owner,
80         address spender,
81         uint256 value,
82         uint256 deadline,
83         uint8 v,
84         bytes32 r,
85         bytes32 s
86     ) external;
87 
88     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
89     event Burn(
90         address indexed sender,
91         uint256 amount0,
92         uint256 amount1,
93         address indexed to
94     );
95     event Swap(
96         address indexed sender,
97         uint256 amount0In,
98         uint256 amount1In,
99         uint256 amount0Out,
100         uint256 amount1Out,
101         address indexed to
102     );
103     event Sync(uint112 reserve0, uint112 reserve1);
104 
105     function MINIMUM_LIQUIDITY() external pure returns (uint256);
106 
107     function factory() external view returns (address);
108 
109     function token0() external view returns (address);
110 
111     function token1() external view returns (address);
112 
113     function getReserves()
114         external
115         view
116         returns (
117             uint112 reserve0,
118             uint112 reserve1,
119             uint32 blockTimestampLast
120         );
121 
122     function price0CumulativeLast() external view returns (uint256);
123 
124     function price1CumulativeLast() external view returns (uint256);
125 
126     function kLast() external view returns (uint256);
127 
128     function mint(address to) external returns (uint256 liquidity);
129 
130     function burn(address to)
131         external
132         returns (uint256 amount0, uint256 amount1);
133 
134     function swap(
135         uint256 amount0Out,
136         uint256 amount1Out,
137         address to,
138         bytes calldata data
139     ) external;
140 
141     function skim(address to) external;
142 
143     function sync() external;
144 
145     function initialize(address, address) external;
146 }
147 
148 interface IUniswapV2Router01 {
149     function factory() external pure returns (address);
150 
151     function WETH() external pure returns (address);
152 
153     function addLiquidity(
154         address tokenA,
155         address tokenB,
156         uint256 amountADesired,
157         uint256 amountBDesired,
158         uint256 amountAMin,
159         uint256 amountBMin,
160         address to,
161         uint256 deadline
162     )
163         external
164         returns (
165             uint256 amountA,
166             uint256 amountB,
167             uint256 liquidity
168         );
169 
170     function addLiquidityETH(
171         address token,
172         uint256 amountTokenDesired,
173         uint256 amountTokenMin,
174         uint256 amountETHMin,
175         address to,
176         uint256 deadline
177     )
178         external
179         payable
180         returns (
181             uint256 amountToken,
182             uint256 amountETH,
183             uint256 liquidity
184         );
185 
186     function removeLiquidity(
187         address tokenA,
188         address tokenB,
189         uint256 liquidity,
190         uint256 amountAMin,
191         uint256 amountBMin,
192         address to,
193         uint256 deadline
194     ) external returns (uint256 amountA, uint256 amountB);
195 
196     function removeLiquidityETH(
197         address token,
198         uint256 liquidity,
199         uint256 amountTokenMin,
200         uint256 amountETHMin,
201         address to,
202         uint256 deadline
203     ) external returns (uint256 amountToken, uint256 amountETH);
204 
205     function removeLiquidityWithPermit(
206         address tokenA,
207         address tokenB,
208         uint256 liquidity,
209         uint256 amountAMin,
210         uint256 amountBMin,
211         address to,
212         uint256 deadline,
213         bool approveMax,
214         uint8 v,
215         bytes32 r,
216         bytes32 s
217     ) external returns (uint256 amountA, uint256 amountB);
218 
219     function removeLiquidityETHWithPermit(
220         address token,
221         uint256 liquidity,
222         uint256 amountTokenMin,
223         uint256 amountETHMin,
224         address to,
225         uint256 deadline,
226         bool approveMax,
227         uint8 v,
228         bytes32 r,
229         bytes32 s
230     ) external returns (uint256 amountToken, uint256 amountETH);
231 
232     function swapExactTokensForTokens(
233         uint256 amountIn,
234         uint256 amountOutMin,
235         address[] calldata path,
236         address to,
237         uint256 deadline
238     ) external returns (uint256[] memory amounts);
239 
240     function swapTokensForExactTokens(
241         uint256 amountOut,
242         uint256 amountInMax,
243         address[] calldata path,
244         address to,
245         uint256 deadline
246     ) external returns (uint256[] memory amounts);
247 
248     function swapExactETHForTokens(
249         uint256 amountOutMin,
250         address[] calldata path,
251         address to,
252         uint256 deadline
253     ) external payable returns (uint256[] memory amounts);
254 
255     function swapTokensForExactETH(
256         uint256 amountOut,
257         uint256 amountInMax,
258         address[] calldata path,
259         address to,
260         uint256 deadline
261     ) external returns (uint256[] memory amounts);
262 
263     function swapExactTokensForETH(
264         uint256 amountIn,
265         uint256 amountOutMin,
266         address[] calldata path,
267         address to,
268         uint256 deadline
269     ) external returns (uint256[] memory amounts);
270 
271     function swapETHForExactTokens(
272         uint256 amountOut,
273         address[] calldata path,
274         address to,
275         uint256 deadline
276     ) external payable returns (uint256[] memory amounts);
277 
278     function quote(
279         uint256 amountA,
280         uint256 reserveA,
281         uint256 reserveB
282     ) external pure returns (uint256 amountB);
283 
284     function getAmountOut(
285         uint256 amountIn,
286         uint256 reserveIn,
287         uint256 reserveOut
288     ) external pure returns (uint256 amountOut);
289 
290     function getAmountIn(
291         uint256 amountOut,
292         uint256 reserveIn,
293         uint256 reserveOut
294     ) external pure returns (uint256 amountIn);
295 
296     function getAmountsOut(uint256 amountIn, address[] calldata path)
297         external
298         view
299         returns (uint256[] memory amounts);
300 
301     function getAmountsIn(uint256 amountOut, address[] calldata path)
302         external
303         view
304         returns (uint256[] memory amounts);
305 }
306 
307 interface IUniswapV2Router02 is IUniswapV2Router01 {
308     function removeLiquidityETHSupportingFeeOnTransferTokens(
309         address token,
310         uint256 liquidity,
311         uint256 amountTokenMin,
312         uint256 amountETHMin,
313         address to,
314         uint256 deadline
315     ) external returns (uint256 amountETH);
316 
317     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
318         address token,
319         uint256 liquidity,
320         uint256 amountTokenMin,
321         uint256 amountETHMin,
322         address to,
323         uint256 deadline,
324         bool approveMax,
325         uint8 v,
326         bytes32 r,
327         bytes32 s
328     ) external returns (uint256 amountETH);
329 
330     function swapExactETHForTokensSupportingFeeOnTransferTokens(
331         uint256 amountOutMin,
332         address[] calldata path,
333         address to,
334         uint256 deadline
335     ) external payable;
336 
337     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
338         uint256 amountIn,
339         uint256 amountOutMin,
340         address[] calldata path,
341         address to,
342         uint256 deadline
343     ) external;
344 
345     function swapExactTokensForETHSupportingFeeOnTransferTokens(
346         uint256 amountIn,
347         uint256 amountOutMin,
348         address[] calldata path,
349         address to,
350         uint256 deadline
351     ) external;
352 }
353 
354 /**
355  * @dev Interface of the ERC20 standard as defined in the EIP.
356  */
357 interface IERC20 {
358     /**
359      * @dev Emitted when `value` tokens are moved from one account (`from`) to
360      * another (`to`).
361      *
362      * Note that `value` may be zero.
363      */
364     event Transfer(address indexed from, address indexed to, uint256 value);
365 
366     /**
367      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
368      * a call to {approve}. `value` is the new allowance.
369      */
370     event Approval(
371         address indexed owner,
372         address indexed spender,
373         uint256 value
374     );
375 
376     /**
377      * @dev Returns the amount of tokens in existence.
378      */
379     function totalSupply() external view returns (uint256);
380 
381     /**
382      * @dev Returns the amount of tokens owned by `account`.
383      */
384     function balanceOf(address account) external view returns (uint256);
385 
386     /**
387      * @dev Moves `amount` tokens from the caller's account to `to`.
388      *
389      * Returns a boolean value indicating whether the operation succeeded.
390      *
391      * Emits a {Transfer} event.
392      */
393     function transfer(address to, uint256 amount) external returns (bool);
394 
395     /**
396      * @dev Returns the remaining number of tokens that `spender` will be
397      * allowed to spend on behalf of `owner` through {transferFrom}. This is
398      * zero by default.
399      *
400      * This value changes when {approve} or {transferFrom} are called.
401      */
402     function allowance(address owner, address spender)
403         external
404         view
405         returns (uint256);
406 
407     /**
408      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
409      *
410      * Returns a boolean value indicating whether the operation succeeded.
411      *
412      * IMPORTANT: Beware that changing an allowance with this method brings the risk
413      * that someone may use both the old and the new allowance by unfortunate
414      * transaction ordering. One possible solution to mitigate this race
415      * condition is to first reduce the spender's allowance to 0 and set the
416      * desired value afterwards:
417      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
418      *
419      * Emits an {Approval} event.
420      */
421     function approve(address spender, uint256 amount) external returns (bool);
422 
423     /**
424      * @dev Moves `amount` tokens from `from` to `to` using the
425      * allowance mechanism. `amount` is then deducted from the caller's
426      * allowance.
427      *
428      * Returns a boolean value indicating whether the operation succeeded.
429      *
430      * Emits a {Transfer} event.
431      */
432     function transferFrom(
433         address from,
434         address to,
435         uint256 amount
436     ) external returns (bool);
437 }
438 
439 /**
440  * @dev Interface for the optional metadata functions from the ERC20 standard.
441  *
442  * _Available since v4.1._
443  */
444 interface IERC20Metadata is IERC20 {
445     /**
446      * @dev Returns the name of the token.
447      */
448     function name() external view returns (string memory);
449 
450     /**
451      * @dev Returns the decimals places of the token.
452      */
453     function decimals() external view returns (uint8);
454 
455     /**
456      * @dev Returns the symbol of the token.
457      */
458     function symbol() external view returns (string memory);
459 }
460 
461 /**
462  * @dev Provides information about the current execution context, including the
463  * sender of the transaction and its data. While these are generally available
464  * via msg.sender and msg.data, they should not be accessed in such a direct
465  * manner, since when dealing with meta-transactions the account sending and
466  * paying for execution may not be the actual sender (as far as an application
467  * is concerned).
468  *
469  * This contract is only required for intermediate, library-like contracts.
470  */
471 abstract contract Context {
472     function _msgSender() internal view virtual returns (address) {
473         return msg.sender;
474     }
475 }
476 
477 /**
478  * @dev Contract module which provides a basic access control mechanism, where
479  * there is an account (an owner) that can be granted exclusive access to
480  * specific functions.
481  *
482  * By default, the owner account will be the one that deploys the contract. This
483  * can later be changed with {transferOwnership}.
484  *
485  * This module is used through inheritance. It will make available the modifier
486  * `onlyOwner`, which can be applied to your functions to restrict their use to
487  * the owner.
488  */
489 abstract contract Ownable is Context {
490     address private _owner;
491 
492     event OwnershipTransferred(
493         address indexed previousOwner,
494         address indexed newOwner
495     );
496 
497     /**
498      * @dev Initializes the contract setting the deployer as the initial owner.
499      */
500     constructor() {
501         _transferOwnership(_msgSender());
502     }
503 
504     /**
505      * @dev Throws if called by any account other than the owner.
506      */
507     modifier onlyOwner() {
508         _checkOwner();
509         _;
510     }
511 
512     /**
513      * @dev Returns the address of the current owner.
514      */
515     function owner() public view virtual returns (address) {
516         return _owner;
517     }
518 
519     /**
520      * @dev Throws if the sender is not the owner.
521      */
522     function _checkOwner() internal view virtual {
523         require(owner() == _msgSender(), "Ownable: caller is not the owner");
524     }
525 
526     /**
527      * @dev Leaves the contract without owner. It will not be possible to call
528      * `onlyOwner` functions anymore. Can only be called by the current owner.
529      *
530      * NOTE: Renouncing ownership will leave the contract without an owner,
531      * thereby removing any functionality that is only available to the owner.
532      */
533     function renounceOwnership() public virtual onlyOwner {
534         _transferOwnership(address(0));
535     }
536 
537     /**
538      * @dev Transfers ownership of the contract to a new account (`newOwner`).
539      * Can only be called by the current owner.
540      */
541     function transferOwnership(address newOwner) public virtual onlyOwner {
542         require(
543             newOwner != address(0),
544             "Ownable: new owner is the zero address"
545         );
546         _transferOwnership(newOwner);
547     }
548 
549     /**
550      * @dev Transfers ownership of the contract to a new account (`newOwner`).
551      * Internal function without access restriction.
552      */
553     function _transferOwnership(address newOwner) internal virtual {
554         address oldOwner = _owner;
555         _owner = newOwner;
556         emit OwnershipTransferred(oldOwner, newOwner);
557     }
558 }
559 
560 /**
561  * @dev Implementation of the {IERC20} interface.
562  *
563  * This implementation is agnostic to the way tokens are created. This means
564  * that a supply mechanism has to be added in a derived contract using {_mint}.
565  * For a generic mechanism see {ERC20PresetMinterPauser}.
566  *
567  * TIP: For a detailed writeup see our guide
568  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
569  * to implement supply mechanisms].
570  *
571  * We have followed general OpenZeppelin Contracts guidelines: functions revert
572  * instead returning `false` on failure. This behavior is nonetheless
573  * conventional and does not conflict with the expectations of ERC20
574  * applications.
575  *
576  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
577  * This allows applications to reconstruct the allowance for all accounts just
578  * by listening to said events. Other implementations of the EIP may not emit
579  * these events, as it isn't required by the specification.
580  *
581  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
582  * functions have been added to mitigate the well-known issues around setting
583  * allowances. See {IERC20-approve}.
584  */
585 contract ERC20 is Context, IERC20, IERC20Metadata {
586     mapping(address => uint256) private _balances;
587     mapping(address => mapping(address => uint256)) private _allowances;
588 
589     uint256 private _totalSupply;
590 
591     string private _name;
592     string private _symbol;
593 
594     constructor(string memory name_, string memory symbol_) {
595         _name = name_;
596         _symbol = symbol_;
597     }
598 
599     /**
600      * @dev Returns the symbol of the token, usually a shorter version of the
601      * name.
602      */
603     function symbol() external view virtual override returns (string memory) {
604         return _symbol;
605     }
606 
607     /**
608      * @dev Returns the name of the token.
609      */
610     function name() external view virtual override returns (string memory) {
611         return _name;
612     }
613 
614     /**
615      * @dev See {IERC20-balanceOf}.
616      */
617     function balanceOf(address account)
618         public
619         view
620         virtual
621         override
622         returns (uint256)
623     {
624         return _balances[account];
625     }
626 
627     /**
628      * @dev Returns the number of decimals used to get its user representation.
629      * For example, if `decimals` equals `2`, a balance of `505` tokens should
630      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
631      *
632      * Tokens usually opt for a value of 18, imitating the relationship between
633      * Ether and Wei. This is the value {ERC20} uses, unless this function is
634      * overridden;
635      *
636      * NOTE: This information is only used for _display_ purposes: it in
637      * no way affects any of the arithmetic of the contract, including
638      * {IERC20-balanceOf} and {IERC20-transfer}.
639      */
640     function decimals() public view virtual override returns (uint8) {
641         return 9;
642     }
643 
644     /**
645      * @dev See {IERC20-totalSupply}.
646      */
647     function totalSupply() external view virtual override returns (uint256) {
648         return _totalSupply;
649     }
650 
651     /**
652      * @dev See {IERC20-allowance}.
653      */
654     function allowance(address owner, address spender)
655         public
656         view
657         virtual
658         override
659         returns (uint256)
660     {
661         return _allowances[owner][spender];
662     }
663 
664     /**
665      * @dev See {IERC20-transfer}.
666      *
667      * Requirements:
668      *
669      * - `to` cannot be the zero address.
670      * - the caller must have a balance of at least `amount`.
671      */
672     function transfer(address to, uint256 amount)
673         external
674         virtual
675         override
676         returns (bool)
677     {
678         address owner = _msgSender();
679         _transfer(owner, to, amount);
680         return true;
681     }
682 
683     /**
684      * @dev See {IERC20-approve}.
685      *
686      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
687      * `transferFrom`. This is semantically equivalent to an infinite approval.
688      *
689      * Requirements:
690      *
691      * - `spender` cannot be the zero address.
692      */
693     function approve(address spender, uint256 amount)
694         external
695         virtual
696         override
697         returns (bool)
698     {
699         address owner = _msgSender();
700         _approve(owner, spender, amount);
701         return true;
702     }
703 
704     /**
705      * @dev See {IERC20-transferFrom}.
706      *
707      * Emits an {Approval} event indicating the updated allowance. This is not
708      * required by the EIP. See the note at the beginning of {ERC20}.
709      *
710      * NOTE: Does not update the allowance if the current allowance
711      * is the maximum `uint256`.
712      *
713      * Requirements:
714      *
715      * - `from` and `to` cannot be the zero address.
716      * - `from` must have a balance of at least `amount`.
717      * - the caller must have allowance for ``from``'s tokens of at least
718      * `amount`.
719      */
720     function transferFrom(
721         address from,
722         address to,
723         uint256 amount
724     ) external virtual override returns (bool) {
725         address spender = _msgSender();
726         _spendAllowance(from, spender, amount);
727         _transfer(from, to, amount);
728         return true;
729     }
730 
731     /**
732      * @dev Atomically decreases the allowance granted to `spender` by the caller.
733      *
734      * This is an alternative to {approve} that can be used as a mitigation for
735      * problems described in {IERC20-approve}.
736      *
737      * Emits an {Approval} event indicating the updated allowance.
738      *
739      * Requirements:
740      *
741      * - `spender` cannot be the zero address.
742      * - `spender` must have allowance for the caller of at least
743      * `subtractedValue`.
744      */
745     function decreaseAllowance(address spender, uint256 subtractedValue)
746         external
747         virtual
748         returns (bool)
749     {
750         address owner = _msgSender();
751         uint256 currentAllowance = allowance(owner, spender);
752         require(
753             currentAllowance >= subtractedValue,
754             "ERC20: decreased allowance below zero"
755         );
756         unchecked {
757             _approve(owner, spender, currentAllowance - subtractedValue);
758         }
759 
760         return true;
761     }
762 
763     /**
764      * @dev Atomically increases the allowance granted to `spender` by the caller.
765      *
766      * This is an alternative to {approve} that can be used as a mitigation for
767      * problems described in {IERC20-approve}.
768      *
769      * Emits an {Approval} event indicating the updated allowance.
770      *
771      * Requirements:
772      *
773      * - `spender` cannot be the zero address.
774      */
775     function increaseAllowance(address spender, uint256 addedValue)
776         external
777         virtual
778         returns (bool)
779     {
780         address owner = _msgSender();
781         _approve(owner, spender, allowance(owner, spender) + addedValue);
782         return true;
783     }
784 
785     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
786      * the total supply.
787      *
788      * Emits a {Transfer} event with `from` set to the zero address.
789      *
790      * Requirements:
791      *
792      * - `account` cannot be the zero address.
793      */
794     function _mint(address account, uint256 amount) internal virtual {
795         require(account != address(0), "ERC20: mint to the zero address");
796 
797         _totalSupply += amount;
798         unchecked {
799             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
800             _balances[account] += amount;
801         }
802         emit Transfer(address(0), account, amount);
803     }
804 
805     /**
806      * @dev Destroys `amount` tokens from `account`, reducing the
807      * total supply.
808      *
809      * Emits a {Transfer} event with `to` set to the zero address.
810      *
811      * Requirements:
812      *
813      * - `account` cannot be the zero address.
814      * - `account` must have at least `amount` tokens.
815      */
816     function _burn(address account, uint256 amount) internal virtual {
817         require(account != address(0), "ERC20: burn from the zero address");
818 
819         uint256 accountBalance = _balances[account];
820         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
821         unchecked {
822             _balances[account] = accountBalance - amount;
823             // Overflow not possible: amount <= accountBalance <= totalSupply.
824             _totalSupply -= amount;
825         }
826 
827         emit Transfer(account, address(0), amount);
828     }
829 
830     /**
831      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
832      *
833      * This internal function is equivalent to `approve`, and can be used to
834      * e.g. set automatic allowances for certain subsystems, etc.
835      *
836      * Emits an {Approval} event.
837      *
838      * Requirements:
839      *
840      * - `owner` cannot be the zero address.
841      * - `spender` cannot be the zero address.
842      */
843     function _approve(
844         address owner,
845         address spender,
846         uint256 amount
847     ) internal virtual {
848         require(owner != address(0), "ERC20: approve from the zero address");
849         require(spender != address(0), "ERC20: approve to the zero address");
850 
851         _allowances[owner][spender] = amount;
852         emit Approval(owner, spender, amount);
853     }
854 
855     /**
856      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
857      *
858      * Does not update the allowance amount in case of infinite allowance.
859      * Revert if not enough allowance is available.
860      *
861      * Might emit an {Approval} event.
862      */
863     function _spendAllowance(
864         address owner,
865         address spender,
866         uint256 amount
867     ) internal virtual {
868         uint256 currentAllowance = allowance(owner, spender);
869         if (currentAllowance != type(uint256).max) {
870             require(
871                 currentAllowance >= amount,
872                 "ERC20: insufficient allowance"
873             );
874             unchecked {
875                 _approve(owner, spender, currentAllowance - amount);
876             }
877         }
878     }
879 
880     function _transfer(
881         address from,
882         address to,
883         uint256 amount
884     ) internal virtual {
885         require(from != address(0), "ERC20: transfer from the zero address");
886         require(to != address(0), "ERC20: transfer to the zero address");
887 
888         uint256 fromBalance = _balances[from];
889         require(
890             fromBalance >= amount,
891             "ERC20: transfer amount exceeds balance"
892         );
893         unchecked {
894             _balances[from] = fromBalance - amount;
895             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
896             // decrementing then incrementing.
897             _balances[to] += amount;
898         }
899 
900         emit Transfer(from, to, amount);
901     }
902 }
903 
904 /**
905  * @dev Implementation of the {IERC20} interface.
906  *
907  * This implementation is agnostic to the way tokens are created. This means
908  * that a supply mechanism has to be added in a derived contract using {_mint}.
909  * For a generic mechanism see {ERC20PresetMinterPauser}.
910  *
911  * TIP: For a detailed writeup see our guide
912  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
913  * to implement supply mechanisms].
914  *
915  * We have followed general OpenZeppelin Contracts guidelines: functions revert
916  * instead returning `false` on failure. This behavior is nonetheless
917  * conventional and does not conflict with the expectations of ERC20
918  * applications.
919  *
920  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
921  * This allows applications to reconstruct the allowance for all accounts just
922  * by listening to said events. Other implementations of the EIP may not emit
923  * these events, as it isn't required by the specification.
924  *
925  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
926  * functions have been added to mitigate the well-known issues around setting
927  * allowances. See {IERC20-approve}.
928  */
929 contract Twige is ERC20, Ownable {
930     // TOKENOMICS START ==========================================================>
931     string private _name = "Twitter Doge";
932     string private _symbol = "Twige";
933     uint8 private _decimals = 9;
934     uint256 private _supply = 1000000000;
935     uint256 public taxForLiquidity = 1;
936     uint256 public taxForMarketing = 4;
937     uint256 public maxTxAmount = 20000000 * 10**_decimals;
938     uint256 public maxWalletAmount = 30000000 * 10**_decimals;
939     address public marketingWallet = 0x303808636400aF0a4932061F70F8c245342b0Dde;
940     // TOKENOMICS END ============================================================>
941 
942     IUniswapV2Router02 public immutable uniswapV2Router;
943     address public immutable uniswapV2Pair;
944 
945     uint256 private _marketingReserves = 0;
946     mapping(address => bool) private _isExcludedFromFee;
947     uint256 private _numTokensSellToAddToLiquidity = 500000 * 10**_decimals;
948     uint256 private _numTokensSellToAddToETH = 200000 * 10**_decimals;
949     bool inSwapAndLiquify;
950 
951     event SwapAndLiquify(
952         uint256 tokensSwapped,
953         uint256 ethReceived,
954         uint256 tokensIntoLiqudity
955     );
956 
957     modifier lockTheSwap() {
958         inSwapAndLiquify = true;
959         _;
960         inSwapAndLiquify = false;
961     }
962 
963     /**
964      * @dev Sets the values for {name} and {symbol}.
965      *
966      * The default value of {decimals} is 18. To select a different value for
967      * {decimals} you should overload it.
968      *
969      * All two of these values are immutable: they can only be set once during
970      * construction.
971      */
972     constructor() ERC20(_name, _symbol) {
973         _mint(msg.sender, (_supply * 10**_decimals));
974 
975         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
976         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
977 
978         uniswapV2Router = _uniswapV2Router;
979 
980         _isExcludedFromFee[address(uniswapV2Router)] = true;
981         _isExcludedFromFee[msg.sender] = true;
982         _isExcludedFromFee[marketingWallet] = true;
983     }
984 
985     /**
986      * @dev Moves `amount` of tokens from `from` to `to`.
987      *
988      * This internal function is equivalent to {transfer}, and can be used to
989      * e.g. implement automatic token fees, slashing mechanisms, etc.
990      *
991      * Emits a {Transfer} event.
992      *
993      * Requirements:
994      *
995      *
996      * - `from` cannot be the zero address.
997      * - `to` cannot be the zero address.
998      * - `from` must have a balance of at least `amount`.
999      */
1000     function _transfer(address from, address to, uint256 amount) internal override {
1001         require(from != address(0), "ERC20: transfer from the zero address");
1002         require(to != address(0), "ERC20: transfer to the zero address");
1003         require(balanceOf(from) >= amount, "ERC20: transfer amount exceeds balance");
1004 
1005         if ((from == uniswapV2Pair || to == uniswapV2Pair) && !inSwapAndLiquify) {
1006             if (from != uniswapV2Pair) {
1007                 uint256 contractLiquidityBalance = balanceOf(address(this)) - _marketingReserves;
1008                 if (contractLiquidityBalance >= _numTokensSellToAddToLiquidity) {
1009                     _swapAndLiquify(_numTokensSellToAddToLiquidity);
1010                 }
1011                 if ((_marketingReserves) >= _numTokensSellToAddToETH) {
1012                     _swapTokensForEth(_numTokensSellToAddToETH);
1013                     _marketingReserves -= _numTokensSellToAddToETH;
1014                     bool sent = payable(marketingWallet).send(address(this).balance);
1015                     require(sent, "Failed to send ETH");
1016                 }
1017             }
1018 
1019             uint256 transferAmount;
1020             if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
1021                 transferAmount = amount;
1022             } 
1023             else {
1024                 require(amount <= maxTxAmount, "ERC20: transfer amount exceeds the max transaction amount");
1025                 if(from == uniswapV2Pair){
1026                     require((amount + balanceOf(to)) <= maxWalletAmount, "ERC20: balance amount exceeded max wallet amount limit");
1027                 }
1028 
1029                 uint256 marketingShare = ((amount * taxForMarketing) / 100);
1030                 uint256 liquidityShare = ((amount * taxForLiquidity) / 100);
1031                 transferAmount = amount - (marketingShare + liquidityShare);
1032                 _marketingReserves += marketingShare;
1033 
1034                 super._transfer(from, address(this), (marketingShare + liquidityShare));
1035             }
1036             super._transfer(from, to, transferAmount);
1037         } 
1038         else {
1039             super._transfer(from, to, amount);
1040         }
1041     }
1042 
1043     function _swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1044         uint256 half = (contractTokenBalance / 2);
1045         uint256 otherHalf = (contractTokenBalance - half);
1046 
1047         uint256 initialBalance = address(this).balance;
1048 
1049         _swapTokensForEth(half);
1050 
1051         uint256 newBalance = (address(this).balance - initialBalance);
1052 
1053         _addLiquidity(otherHalf, newBalance);
1054 
1055         emit SwapAndLiquify(half, newBalance, otherHalf);
1056     }
1057 
1058     function _swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
1059         address[] memory path = new address[](2);
1060         path[0] = address(this);
1061         path[1] = uniswapV2Router.WETH();
1062 
1063         _approve(address(this), address(uniswapV2Router), tokenAmount);
1064 
1065         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1066             tokenAmount,
1067             0,
1068             path,
1069             address(this),
1070             (block.timestamp + 300)
1071         );
1072     }
1073 
1074     function _addLiquidity(uint256 tokenAmount, uint256 ethAmount)
1075         private
1076         lockTheSwap
1077     {
1078         _approve(address(this), address(uniswapV2Router), tokenAmount);
1079 
1080         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1081             address(this),
1082             tokenAmount,
1083             0,
1084             0,
1085             owner(),
1086             block.timestamp
1087         );
1088     }
1089 
1090     function changeMarketingWallet(address newWallet)
1091         public
1092         onlyOwner
1093         returns (bool)
1094     {
1095         marketingWallet = newWallet;
1096         return true;
1097     }
1098 
1099     function changeTaxForLiquidityAndMarketing(uint256 _taxForLiquidity, uint256 _taxForMarketing)
1100         public
1101         onlyOwner
1102         returns (bool)
1103     {
1104         require((_taxForLiquidity+_taxForMarketing) <= 100, "ERC20: total tax must not be greater than 100");
1105         taxForLiquidity = _taxForLiquidity;
1106         taxForMarketing = _taxForMarketing;
1107 
1108         return true;
1109     }
1110 
1111     function changeMaxTxAmount(uint256 _maxTxAmount)
1112         public
1113         onlyOwner
1114         returns (bool)
1115     {
1116         maxTxAmount = _maxTxAmount;
1117 
1118         return true;
1119     }
1120 
1121     function changeMaxWalletAmount(uint256 _maxWalletAmount)
1122         public
1123         onlyOwner
1124         returns (bool)
1125     {
1126         maxWalletAmount = _maxWalletAmount;
1127 
1128         return true;
1129     }
1130 
1131     receive() external payable {}
1132 }