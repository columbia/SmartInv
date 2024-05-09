1 /**
2 Puffy the cloud.
3 
4 Website: https://puffy.vip/
5 Twitter: https://twitter.com/bidencloud
6 
7 */
8 
9 // SPDX-License-Identifier: MIT
10 
11 pragma solidity 0.8.16;
12 
13 interface IUniswapV2Factory {
14     event PairCreated(
15         address indexed token0,
16         address indexed token1,
17         address pair,
18         uint256
19     );
20 
21     function feeTo() external view returns (address);
22 
23     function feeToSetter() external view returns (address);
24 
25     function allPairsLength() external view returns (uint256);
26 
27     function getPair(address tokenA, address tokenB)
28         external
29         view
30         returns (address pair);
31 
32     function allPairs(uint256) external view returns (address pair);
33 
34     function createPair(address tokenA, address tokenB)
35         external
36         returns (address pair);
37 
38     function setFeeTo(address) external;
39 
40     function setFeeToSetter(address) external;
41 }
42 
43 interface IUniswapV2Pair {
44     event Approval(
45         address indexed owner,
46         address indexed spender,
47         uint256 value
48     );
49     event Transfer(address indexed from, address indexed to, uint256 value);
50 
51     function name() external pure returns (string memory);
52 
53     function symbol() external pure returns (string memory);
54 
55     function decimals() external pure returns (uint8);
56 
57     function totalSupply() external view returns (uint256);
58 
59     function balanceOf(address owner) external view returns (uint256);
60 
61     function allowance(address owner, address spender)
62         external
63         view
64         returns (uint256);
65 
66     function approve(address spender, uint256 value) external returns (bool);
67 
68     function transfer(address to, uint256 value) external returns (bool);
69 
70     function transferFrom(
71         address from,
72         address to,
73         uint256 value
74     ) external returns (bool);
75 
76     function DOMAIN_SEPARATOR() external view returns (bytes32);
77 
78     function PERMIT_TYPEHASH() external pure returns (bytes32);
79 
80     function nonces(address owner) external view returns (uint256);
81 
82     function permit(
83         address owner,
84         address spender,
85         uint256 value,
86         uint256 deadline,
87         uint8 v,
88         bytes32 r,
89         bytes32 s
90     ) external;
91 
92     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
93     event Burn(
94         address indexed sender,
95         uint256 amount0,
96         uint256 amount1,
97         address indexed to
98     );
99     event Swap(
100         address indexed sender,
101         uint256 amount0In,
102         uint256 amount1In,
103         uint256 amount0Out,
104         uint256 amount1Out,
105         address indexed to
106     );
107     event Sync(uint112 reserve0, uint112 reserve1);
108 
109     function MINIMUM_LIQUIDITY() external pure returns (uint256);
110 
111     function factory() external view returns (address);
112 
113     function token0() external view returns (address);
114 
115     function token1() external view returns (address);
116 
117     function getReserves()
118         external
119         view
120         returns (
121             uint112 reserve0,
122             uint112 reserve1,
123             uint32 blockTimestampLast
124         );
125 
126     function price0CumulativeLast() external view returns (uint256);
127 
128     function price1CumulativeLast() external view returns (uint256);
129 
130     function kLast() external view returns (uint256);
131 
132     function mint(address to) external returns (uint256 liquidity);
133 
134     function burn(address to)
135         external
136         returns (uint256 amount0, uint256 amount1);
137 
138     function swap(
139         uint256 amount0Out,
140         uint256 amount1Out,
141         address to,
142         bytes calldata data
143     ) external;
144 
145     function skim(address to) external;
146 
147     function sync() external;
148 
149     function initialize(address, address) external;
150 }
151 
152 interface IUniswapV2Router01 {
153     function factory() external pure returns (address);
154 
155     function WETH() external pure returns (address);
156 
157     function addLiquidity(
158         address tokenA,
159         address tokenB,
160         uint256 amountADesired,
161         uint256 amountBDesired,
162         uint256 amountAMin,
163         uint256 amountBMin,
164         address to,
165         uint256 deadline
166     )
167         external
168         returns (
169             uint256 amountA,
170             uint256 amountB,
171             uint256 liquidity
172         );
173 
174     function addLiquidityETH(
175         address token,
176         uint256 amountTokenDesired,
177         uint256 amountTokenMin,
178         uint256 amountETHMin,
179         address to,
180         uint256 deadline
181     )
182         external
183         payable
184         returns (
185             uint256 amountToken,
186             uint256 amountETH,
187             uint256 liquidity
188         );
189 
190     function removeLiquidity(
191         address tokenA,
192         address tokenB,
193         uint256 liquidity,
194         uint256 amountAMin,
195         uint256 amountBMin,
196         address to,
197         uint256 deadline
198     ) external returns (uint256 amountA, uint256 amountB);
199 
200     function removeLiquidityETH(
201         address token,
202         uint256 liquidity,
203         uint256 amountTokenMin,
204         uint256 amountETHMin,
205         address to,
206         uint256 deadline
207     ) external returns (uint256 amountToken, uint256 amountETH);
208 
209     function removeLiquidityWithPermit(
210         address tokenA,
211         address tokenB,
212         uint256 liquidity,
213         uint256 amountAMin,
214         uint256 amountBMin,
215         address to,
216         uint256 deadline,
217         bool approveMax,
218         uint8 v,
219         bytes32 r,
220         bytes32 s
221     ) external returns (uint256 amountA, uint256 amountB);
222 
223     function removeLiquidityETHWithPermit(
224         address token,
225         uint256 liquidity,
226         uint256 amountTokenMin,
227         uint256 amountETHMin,
228         address to,
229         uint256 deadline,
230         bool approveMax,
231         uint8 v,
232         bytes32 r,
233         bytes32 s
234     ) external returns (uint256 amountToken, uint256 amountETH);
235 
236     function swapExactTokensForTokens(
237         uint256 amountIn,
238         uint256 amountOutMin,
239         address[] calldata path,
240         address to,
241         uint256 deadline
242     ) external returns (uint256[] memory amounts);
243 
244     function swapTokensForExactTokens(
245         uint256 amountOut,
246         uint256 amountInMax,
247         address[] calldata path,
248         address to,
249         uint256 deadline
250     ) external returns (uint256[] memory amounts);
251 
252     function swapExactETHForTokens(
253         uint256 amountOutMin,
254         address[] calldata path,
255         address to,
256         uint256 deadline
257     ) external payable returns (uint256[] memory amounts);
258 
259     function swapTokensForExactETH(
260         uint256 amountOut,
261         uint256 amountInMax,
262         address[] calldata path,
263         address to,
264         uint256 deadline
265     ) external returns (uint256[] memory amounts);
266 
267     function swapExactTokensForETH(
268         uint256 amountIn,
269         uint256 amountOutMin,
270         address[] calldata path,
271         address to,
272         uint256 deadline
273     ) external returns (uint256[] memory amounts);
274 
275     function swapETHForExactTokens(
276         uint256 amountOut,
277         address[] calldata path,
278         address to,
279         uint256 deadline
280     ) external payable returns (uint256[] memory amounts);
281 
282     function quote(
283         uint256 amountA,
284         uint256 reserveA,
285         uint256 reserveB
286     ) external pure returns (uint256 amountB);
287 
288     function getAmountOut(
289         uint256 amountIn,
290         uint256 reserveIn,
291         uint256 reserveOut
292     ) external pure returns (uint256 amountOut);
293 
294     function getAmountIn(
295         uint256 amountOut,
296         uint256 reserveIn,
297         uint256 reserveOut
298     ) external pure returns (uint256 amountIn);
299 
300     function getAmountsOut(uint256 amountIn, address[] calldata path)
301         external
302         view
303         returns (uint256[] memory amounts);
304 
305     function getAmountsIn(uint256 amountOut, address[] calldata path)
306         external
307         view
308         returns (uint256[] memory amounts);
309 }
310 
311 interface IUniswapV2Router02 is IUniswapV2Router01 {
312     function removeLiquidityETHSupportingFeeOnTransferTokens(
313         address token,
314         uint256 liquidity,
315         uint256 amountTokenMin,
316         uint256 amountETHMin,
317         address to,
318         uint256 deadline
319     ) external returns (uint256 amountETH);
320 
321     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
322         address token,
323         uint256 liquidity,
324         uint256 amountTokenMin,
325         uint256 amountETHMin,
326         address to,
327         uint256 deadline,
328         bool approveMax,
329         uint8 v,
330         bytes32 r,
331         bytes32 s
332     ) external returns (uint256 amountETH);
333 
334     function swapExactETHForTokensSupportingFeeOnTransferTokens(
335         uint256 amountOutMin,
336         address[] calldata path,
337         address to,
338         uint256 deadline
339     ) external payable;
340 
341     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
342         uint256 amountIn,
343         uint256 amountOutMin,
344         address[] calldata path,
345         address to,
346         uint256 deadline
347     ) external;
348 
349     function swapExactTokensForETHSupportingFeeOnTransferTokens(
350         uint256 amountIn,
351         uint256 amountOutMin,
352         address[] calldata path,
353         address to,
354         uint256 deadline
355     ) external;
356 }
357 
358 /**
359  * @dev Interface of the ERC20 standard as defined in the EIP.
360  */
361 interface IERC20 {
362     /**
363      * @dev Emitted when `value` tokens are moved from one account (`from`) to
364      * another (`to`).
365      *
366      * Note that `value` may be zero.
367      */
368     event Transfer(address indexed from, address indexed to, uint256 value);
369 
370     /**
371      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
372      * a call to {approve}. `value` is the new allowance.
373      */
374     event Approval(
375         address indexed owner,
376         address indexed spender,
377         uint256 value
378     );
379 
380     /**
381      * @dev Returns the amount of tokens in existence.
382      */
383     function totalSupply() external view returns (uint256);
384 
385     /**
386      * @dev Returns the amount of tokens owned by `account`.
387      */
388     function balanceOf(address account) external view returns (uint256);
389 
390     /**
391      * @dev Moves `amount` tokens from the caller's account to `to`.
392      *
393      * Returns a boolean value indicating whether the operation succeeded.
394      *
395      * Emits a {Transfer} event.
396      */
397     function transfer(address to, uint256 amount) external returns (bool);
398 
399     /**
400      * @dev Returns the remaining number of tokens that `spender` will be
401      * allowed to spend on behalf of `owner` through {transferFrom}. This is
402      * zero by default.
403      *
404      * This value changes when {approve} or {transferFrom} are called.
405      */
406     function allowance(address owner, address spender)
407         external
408         view
409         returns (uint256);
410 
411     /**
412      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
413      *
414      * Returns a boolean value indicating whether the operation succeeded.
415      *
416      * IMPORTANT: Beware that changing an allowance with this method brings the risk
417      * that someone may use both the old and the new allowance by unfortunate
418      * transaction ordering. One possible solution to mitigate this race
419      * condition is to first reduce the spender's allowance to 0 and set the
420      * desired value afterwards:
421      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
422      *
423      * Emits an {Approval} event.
424      */
425     function approve(address spender, uint256 amount) external returns (bool);
426 
427     /**
428      * @dev Moves `amount` tokens from `from` to `to` using the
429      * allowance mechanism. `amount` is then deducted from the caller's
430      * allowance.
431      *
432      * Returns a boolean value indicating whether the operation succeeded.
433      *
434      * Emits a {Transfer} event.
435      */
436     function transferFrom(
437         address from,
438         address to,
439         uint256 amount
440     ) external returns (bool);
441 }
442 
443 /**
444  * @dev Interface for the optional metadata functions from the ERC20 standard.
445  *
446  * _Available since v4.1._
447  */
448 interface IERC20Metadata is IERC20 {
449     /**
450      * @dev Returns the name of the token.
451      */
452     function name() external view returns (string memory);
453 
454     /**
455      * @dev Returns the decimals places of the token.
456      */
457     function decimals() external view returns (uint8);
458 
459     /**
460      * @dev Returns the symbol of the token.
461      */
462     function symbol() external view returns (string memory);
463 }
464 
465 /**
466  * @dev Provides information about the current execution context, including the
467  * sender of the transaction and its data. While these are generally available
468  * via msg.sender and msg.data, they should not be accessed in such a direct
469  * manner, since when dealing with meta-transactions the account sending and
470  * paying for execution may not be the actual sender (as far as an application
471  * is concerned).
472  *
473  * This contract is only required for intermediate, library-like contracts.
474  */
475 abstract contract Context {
476     function _msgSender() internal view virtual returns (address) {
477         return msg.sender;
478     }
479 }
480 
481 /**
482  * @dev Contract module which provides a basic access control mechanism, where
483  * there is an account (an owner) that can be granted exclusive access to
484  * specific functions.
485  *
486  * By default, the owner account will be the one that deploys the contract. This
487  * can later be changed with {transferOwnership}.
488  *
489  * This module is used through inheritance. It will make available the modifier
490  * `onlyOwner`, which can be applied to your functions to restrict their use to
491  * the owner.
492  */
493 abstract contract Ownable is Context {
494     address private _owner;
495 
496     event OwnershipTransferred(
497         address indexed previousOwner,
498         address indexed newOwner
499     );
500 
501     /**
502      * @dev Initializes the contract setting the deployer as the initial owner.
503      */
504     constructor() {
505         _transferOwnership(_msgSender());
506     }
507 
508     /**
509      * @dev Throws if called by any account other than the owner.
510      */
511     modifier onlyOwner() {
512         _checkOwner();
513         _;
514     }
515 
516     /**
517      * @dev Returns the address of the current owner.
518      */
519     function owner() public view virtual returns (address) {
520         return _owner;
521     }
522 
523     /**
524      * @dev Throws if the sender is not the owner.
525      */
526     function _checkOwner() internal view virtual {
527         require(owner() == _msgSender(), "Ownable: caller is not the owner");
528     }
529 
530     /**
531      * @dev Leaves the contract without owner. It will not be possible to call
532      * `onlyOwner` functions anymore. Can only be called by the current owner.
533      *
534      * NOTE: Renouncing ownership will leave the contract without an owner,
535      * thereby removing any functionality that is only available to the owner.
536      */
537     function renounceOwnership() public virtual onlyOwner {
538         _transferOwnership(address(0));
539     }
540 
541     /**
542      * @dev Transfers ownership of the contract to a new account (`newOwner`).
543      * Can only be called by the current owner.
544      */
545     function transferOwnership(address newOwner) public virtual onlyOwner {
546         require(
547             newOwner != address(0),
548             "Ownable: new owner is the zero address"
549         );
550         _transferOwnership(newOwner);
551     }
552 
553     /**
554      * @dev Transfers ownership of the contract to a new account (`newOwner`).
555      * Internal function without access restriction.
556      */
557     function _transferOwnership(address newOwner) internal virtual {
558         address oldOwner = _owner;
559         _owner = newOwner;
560         emit OwnershipTransferred(oldOwner, newOwner);
561     }
562 }
563 
564 /**
565  * @dev Implementation of the {IERC20} interface.
566  *
567  * This implementation is agnostic to the way tokens are created. This means
568  * that a supply mechanism has to be added in a derived contract using {_mint}.
569  * For a generic mechanism see {ERC20PresetMinterPauser}.
570  *
571  * TIP: For a detailed writeup see our guide
572  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
573  * to implement supply mechanisms].
574  *
575  * We have followed general OpenZeppelin Contracts guidelines: functions revert
576  * instead returning `false` on failure. This behavior is nonetheless
577  * conventional and does not conflict with the expectations of ERC20
578  * applications.
579  *
580  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
581  * This allows applications to reconstruct the allowance for all accounts just
582  * by listening to said events. Other implementations of the EIP may not emit
583  * these events, as it isn't required by the specification.
584  *
585  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
586  * functions have been added to mitigate the well-known issues around setting
587  * allowances. See {IERC20-approve}.
588  */
589 contract ERC20 is Context, IERC20, IERC20Metadata {
590     mapping(address => uint256) private _balances;
591     mapping(address => mapping(address => uint256)) private _allowances;
592 
593     uint256 private _totalSupply;
594 
595     string private _name;
596     string private _symbol;
597 
598     constructor(string memory name_, string memory symbol_) {
599         _name = name_;
600         _symbol = symbol_;
601     }
602 
603     /**
604      * @dev Returns the symbol of the token, usually a shorter version of the
605      * name.
606      */
607     function symbol() external view virtual override returns (string memory) {
608         return _symbol;
609     }
610 
611     /**
612      * @dev Returns the name of the token.
613      */
614     function name() external view virtual override returns (string memory) {
615         return _name;
616     }
617 
618     /**
619      * @dev See {IERC20-balanceOf}.
620      */
621     function balanceOf(address account)
622         public
623         view
624         virtual
625         override
626         returns (uint256)
627     {
628         return _balances[account];
629     }
630 
631     /**
632      * @dev Returns the number of decimals used to get its user representation.
633      * For example, if `decimals` equals `2`, a balance of `505` tokens should
634      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
635      *
636      * Tokens usually opt for a value of 18, imitating the relationship between
637      * Ether and Wei. This is the value {ERC20} uses, unless this function is
638      * overridden;
639      *
640      * NOTE: This information is only used for _display_ purposes: it in
641      * no way affects any of the arithmetic of the contract, including
642      * {IERC20-balanceOf} and {IERC20-transfer}.
643      */
644     function decimals() public view virtual override returns (uint8) {
645         return 9;
646     }
647 
648     /**
649      * @dev See {IERC20-totalSupply}.
650      */
651     function totalSupply() external view virtual override returns (uint256) {
652         return _totalSupply;
653     }
654 
655     /**
656      * @dev See {IERC20-allowance}.
657      */
658     function allowance(address owner, address spender)
659         public
660         view
661         virtual
662         override
663         returns (uint256)
664     {
665         return _allowances[owner][spender];
666     }
667 
668     /**
669      * @dev See {IERC20-transfer}.
670      *
671      * Requirements:
672      *
673      * - `to` cannot be the zero address.
674      * - the caller must have a balance of at least `amount`.
675      */
676     function transfer(address to, uint256 amount)
677         external
678         virtual
679         override
680         returns (bool)
681     {
682         address owner = _msgSender();
683         _transfer(owner, to, amount);
684         return true;
685     }
686 
687     /**
688      * @dev See {IERC20-approve}.
689      *
690      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
691      * `transferFrom`. This is semantically equivalent to an infinite approval.
692      *
693      * Requirements:
694      *
695      * - `spender` cannot be the zero address.
696      */
697     function approve(address spender, uint256 amount)
698         external
699         virtual
700         override
701         returns (bool)
702     {
703         address owner = _msgSender();
704         _approve(owner, spender, amount);
705         return true;
706     }
707 
708     /**
709      * @dev See {IERC20-transferFrom}.
710      *
711      * Emits an {Approval} event indicating the updated allowance. This is not
712      * required by the EIP. See the note at the beginning of {ERC20}.
713      *
714      * NOTE: Does not update the allowance if the current allowance
715      * is the maximum `uint256`.
716      *
717      * Requirements:
718      *
719      * - `from` and `to` cannot be the zero address.
720      * - `from` must have a balance of at least `amount`.
721      * - the caller must have allowance for ``from``'s tokens of at least
722      * `amount`.
723      */
724     function transferFrom(
725         address from,
726         address to,
727         uint256 amount
728     ) external virtual override returns (bool) {
729         address spender = _msgSender();
730         _spendAllowance(from, spender, amount);
731         _transfer(from, to, amount);
732         return true;
733     }
734 
735     /**
736      * @dev Atomically decreases the allowance granted to `spender` by the caller.
737      *
738      * This is an alternative to {approve} that can be used as a mitigation for
739      * problems described in {IERC20-approve}.
740      *
741      * Emits an {Approval} event indicating the updated allowance.
742      *
743      * Requirements:
744      *
745      * - `spender` cannot be the zero address.
746      * - `spender` must have allowance for the caller of at least
747      * `subtractedValue`.
748      */
749     function decreaseAllowance(address spender, uint256 subtractedValue)
750         external
751         virtual
752         returns (bool)
753     {
754         address owner = _msgSender();
755         uint256 currentAllowance = allowance(owner, spender);
756         require(
757             currentAllowance >= subtractedValue,
758             "ERC20: decreased allowance below zero"
759         );
760         unchecked {
761             _approve(owner, spender, currentAllowance - subtractedValue);
762         }
763 
764         return true;
765     }
766 
767     /**
768      * @dev Atomically increases the allowance granted to `spender` by the caller.
769      *
770      * This is an alternative to {approve} that can be used as a mitigation for
771      * problems described in {IERC20-approve}.
772      *
773      * Emits an {Approval} event indicating the updated allowance.
774      *
775      * Requirements:
776      *
777      * - `spender` cannot be the zero address.
778      */
779     function increaseAllowance(address spender, uint256 addedValue)
780         external
781         virtual
782         returns (bool)
783     {
784         address owner = _msgSender();
785         _approve(owner, spender, allowance(owner, spender) + addedValue);
786         return true;
787     }
788 
789     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
790      * the total supply.
791      *
792      * Emits a {Transfer} event with `from` set to the zero address.
793      *
794      * Requirements:
795      *
796      * - `account` cannot be the zero address.
797      */
798     function _mint(address account, uint256 amount) internal virtual {
799         require(account != address(0), "ERC20: mint to the zero address");
800 
801         _totalSupply += amount;
802         unchecked {
803             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
804             _balances[account] += amount;
805         }
806         emit Transfer(address(0), account, amount);
807     }
808 
809     /**
810      * @dev Destroys `amount` tokens from `account`, reducing the
811      * total supply.
812      *
813      * Emits a {Transfer} event with `to` set to the zero address.
814      *
815      * Requirements:
816      *
817      * - `account` cannot be the zero address.
818      * - `account` must have at least `amount` tokens.
819      */
820     function _burn(address account, uint256 amount) internal virtual {
821         require(account != address(0), "ERC20: burn from the zero address");
822 
823         uint256 accountBalance = _balances[account];
824         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
825         unchecked {
826             _balances[account] = accountBalance - amount;
827             // Overflow not possible: amount <= accountBalance <= totalSupply.
828             _totalSupply -= amount;
829         }
830 
831         emit Transfer(account, address(0), amount);
832     }
833 
834     /**
835      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
836      *
837      * This internal function is equivalent to `approve`, and can be used to
838      * e.g. set automatic allowances for certain subsystems, etc.
839      *
840      * Emits an {Approval} event.
841      *
842      * Requirements:
843      *
844      * - `owner` cannot be the zero address.
845      * - `spender` cannot be the zero address.
846      */
847     function _approve(
848         address owner,
849         address spender,
850         uint256 amount
851     ) internal virtual {
852         require(owner != address(0), "ERC20: approve from the zero address");
853         require(spender != address(0), "ERC20: approve to the zero address");
854 
855         _allowances[owner][spender] = amount;
856         emit Approval(owner, spender, amount);
857     }
858 
859     /**
860      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
861      *
862      * Does not update the allowance amount in case of infinite allowance.
863      * Revert if not enough allowance is available.
864      *
865      * Might emit an {Approval} event.
866      */
867     function _spendAllowance(
868         address owner,
869         address spender,
870         uint256 amount
871     ) internal virtual {
872         uint256 currentAllowance = allowance(owner, spender);
873         if (currentAllowance != type(uint256).max) {
874             require(
875                 currentAllowance >= amount,
876                 "ERC20: insufficient allowance"
877             );
878             unchecked {
879                 _approve(owner, spender, currentAllowance - amount);
880             }
881         }
882     }
883 
884     function _transfer(
885         address from,
886         address to,
887         uint256 amount
888     ) internal virtual {
889         require(from != address(0), "ERC20: transfer from the zero address");
890         require(to != address(0), "ERC20: transfer to the zero address");
891 
892         uint256 fromBalance = _balances[from];
893         require(
894             fromBalance >= amount,
895             "ERC20: transfer amount exceeds balance"
896         );
897         unchecked {
898             _balances[from] = fromBalance - amount;
899             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
900             // decrementing then incrementing.
901             _balances[to] += amount;
902         }
903 
904         emit Transfer(from, to, amount);
905     }
906 }
907 
908 /**
909  * @dev Implementation of the {IERC20} interface.
910  *
911  * This implementation is agnostic to the way tokens are created. This means
912  * that a supply mechanism has to be added in a derived contract using {_mint}.
913  * For a generic mechanism see {ERC20PresetMinterPauser}.
914  *
915  * TIP: For a detailed writeup see our guide
916  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
917  * to implement supply mechanisms].
918  *
919  * We have followed general OpenZeppelin Contracts guidelines: functions revert
920  * instead returning `false` on failure. This behavior is nonetheless
921  * conventional and does not conflict with the expectations of ERC20
922  * applications.
923  *
924  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
925  * This allows applications to reconstruct the allowance for all accounts just
926  * by listening to said events. Other implementations of the EIP may not emit
927  * these events, as it isn't required by the specification.
928  *
929  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
930  * functions have been added to mitigate the well-known issues around setting
931  * allowances. See {IERC20-approve}.
932  */
933  contract PuffyToken is ERC20, Ownable {
934     // TOKENOMICS START ==========================================================>
935     string private _name = "Puffy Token";
936     string private _symbol = "PUFFY";
937     uint8 private _decimals = 9;
938     uint256 private _supply = 420690000000000;
939     uint256 public taxForLiquidity = 0;
940     uint256 public taxForMarketing = 5;
941     uint256 public maxTxAmount = 6306900000000 * 10**_decimals;
942     uint256 public maxWalletAmount = 6306900000000 * 10**_decimals;
943     address public marketingWallet = 0x2b9a3227b7ef7cA41Dd378F7a3be412F2bCCB49D;
944     // TOKENOMICS END ============================================================>
945 
946     IUniswapV2Router02 public immutable uniswapV2Router;
947     address public immutable uniswapV2Pair;
948 
949     uint256 private _marketingReserves = 0;
950     mapping(address => bool) private _isExcludedFromFee;
951     uint256 private _numTokensSellToAddToLiquidity = 1020690000000 * 10**_decimals;
952     uint256 private _numTokensSellToAddToETH = 1020690000000 * 10**_decimals;
953     bool inSwapAndLiquify;
954 
955     event SwapAndLiquify(
956         uint256 tokensSwapped,
957         uint256 ethReceived,
958         uint256 tokensIntoLiqudity
959     );
960 
961     modifier lockTheSwap() {
962         inSwapAndLiquify = true;
963         _;
964         inSwapAndLiquify = false;
965     }
966 
967     /**
968      * @dev Sets the values for {name} and {symbol}.
969      *
970      * The default value of {decimals} is 18. To select a different value for
971      * {decimals} you should overload it.
972      *
973      * All two of these values are immutable: they can only be set once during
974      * construction.
975      */
976     constructor() ERC20(_name, _symbol) {
977         _mint(msg.sender, (_supply * 10**_decimals));
978 
979         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
980         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
981 
982         uniswapV2Router = _uniswapV2Router;
983 
984         _isExcludedFromFee[address(uniswapV2Router)] = true;
985         _isExcludedFromFee[msg.sender] = true;
986         _isExcludedFromFee[marketingWallet] = true;
987     }
988 
989     /**
990      * @dev Moves `amount` of tokens from `from` to `to`.
991      *
992      * This internal function is equivalent to {transfer}, and can be used to
993      * e.g. implement automatic token fees, slashing mechanisms, etc.
994      *
995      * Emits a {Transfer} event.
996      *
997      * Requirements:
998      *
999      *
1000      * - `from` cannot be the zero address.
1001      * - `to` cannot be the zero address.
1002      * - `from` must have a balance of at least `amount`.
1003      */
1004     function _transfer(address from, address to, uint256 amount) internal override {
1005         require(from != address(0), "ERC20: transfer from the zero address");
1006         require(to != address(0), "ERC20: transfer to the zero address");
1007         require(balanceOf(from) >= amount, "ERC20: transfer amount exceeds balance");
1008 
1009         if ((from == uniswapV2Pair || to == uniswapV2Pair) && !inSwapAndLiquify) {
1010             if (from != uniswapV2Pair) {
1011                 uint256 contractLiquidityBalance = balanceOf(address(this)) - _marketingReserves;
1012                 if (contractLiquidityBalance >= _numTokensSellToAddToLiquidity) {
1013                     _swapAndLiquify(_numTokensSellToAddToLiquidity);
1014                 }
1015                 if ((_marketingReserves) >= _numTokensSellToAddToETH) {
1016                     _swapTokensForEth(_numTokensSellToAddToETH);
1017                     _marketingReserves -= _numTokensSellToAddToETH;
1018                     bool sent = payable(marketingWallet).send(address(this).balance);
1019                     require(sent, "Failed to send ETH");
1020                 }
1021             }
1022 
1023             uint256 transferAmount;
1024             if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
1025                 transferAmount = amount;
1026             } 
1027             else {
1028                 require(amount <= maxTxAmount, "ERC20: transfer amount exceeds the max transaction amount");
1029                 if(from == uniswapV2Pair){
1030                     require((amount + balanceOf(to)) <= maxWalletAmount, "ERC20: balance amount exceeded max wallet amount limit");
1031                 }
1032 
1033                 uint256 marketingShare = ((amount * taxForMarketing) / 100);
1034                 uint256 liquidityShare = ((amount * taxForLiquidity) / 100);
1035                 transferAmount = amount - (marketingShare + liquidityShare);
1036                 _marketingReserves += marketingShare;
1037 
1038                 super._transfer(from, address(this), (marketingShare + liquidityShare));
1039             }
1040             super._transfer(from, to, transferAmount);
1041         } 
1042         else {
1043             super._transfer(from, to, amount);
1044         }
1045     }
1046 
1047     function _swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1048         uint256 half = (contractTokenBalance / 2);
1049         uint256 otherHalf = (contractTokenBalance - half);
1050 
1051         uint256 initialBalance = address(this).balance;
1052 
1053         _swapTokensForEth(half);
1054 
1055         uint256 newBalance = (address(this).balance - initialBalance);
1056 
1057         _addLiquidity(otherHalf, newBalance);
1058 
1059         emit SwapAndLiquify(half, newBalance, otherHalf);
1060     }
1061 
1062     function _swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
1063         address[] memory path = new address[](2);
1064         path[0] = address(this);
1065         path[1] = uniswapV2Router.WETH();
1066 
1067         _approve(address(this), address(uniswapV2Router), tokenAmount);
1068 
1069         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1070             tokenAmount,
1071             0,
1072             path,
1073             address(this),
1074             (block.timestamp + 300)
1075         );
1076     }
1077 
1078     function _addLiquidity(uint256 tokenAmount, uint256 ethAmount)
1079         private
1080         lockTheSwap
1081     {
1082         _approve(address(this), address(uniswapV2Router), tokenAmount);
1083 
1084         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1085             address(this),
1086             tokenAmount,
1087             0,
1088             0,
1089             owner(),
1090             block.timestamp
1091         );
1092     }
1093 
1094     function changeMarketingWallet(address newWallet)
1095         public
1096         onlyOwner
1097         returns (bool)
1098     {
1099         marketingWallet = newWallet;
1100         return true;
1101     }
1102 
1103     function changeTaxForLiquidityAndMarketing(uint256 _taxForLiquidity, uint256 _taxForMarketing)
1104         public
1105         onlyOwner
1106         returns (bool)
1107     {
1108         require((_taxForLiquidity+_taxForMarketing) <= 100, "ERC20: total tax must not be greater than 100");
1109         taxForLiquidity = _taxForLiquidity;
1110         taxForMarketing = _taxForMarketing;
1111 
1112         return true;
1113     }
1114 
1115     function changeMaxTxAmount(uint256 _maxTxAmount)
1116         public
1117         onlyOwner
1118         returns (bool)
1119     {
1120         maxTxAmount = _maxTxAmount;
1121 
1122         return true;
1123     }
1124 
1125     function changeMaxWalletAmount(uint256 _maxWalletAmount)
1126         public
1127         onlyOwner
1128         returns (bool)
1129     {
1130         maxWalletAmount = _maxWalletAmount;
1131 
1132         return true;
1133     }
1134 
1135     receive() external payable {}
1136 }