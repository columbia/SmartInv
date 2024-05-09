1 // Website: https://rickpepe.com
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity 0.8.17;
6 
7 interface IUniswapV2Factory {
8     event PairCreated(
9         address indexed token0,
10         address indexed token1,
11         address pair,
12         uint256
13     );
14 
15     function feeTo() external view returns (address);
16 
17     function feeToSetter() external view returns (address);
18 
19     function allPairsLength() external view returns (uint256);
20 
21     function createPair(address tokenA, address tokenB)
22         external
23         returns (address pair);
24 
25     function setFeeTo(address) external;
26 
27     function getPair(address tokenA, address tokenB)
28         external
29         view
30         returns (address pair);
31 
32     function allPairs(uint256) external view returns (address pair);
33 
34     function setFeeToSetter(address) external;
35 }
36 
37 interface IUniswapV2Pair {
38     event Approval(
39         address indexed owner,
40         address indexed spender,
41         uint256 value
42     );
43     event Transfer(address indexed from, address indexed to, uint256 value);
44 
45     function name() external pure returns (string memory);
46 
47     function symbol() external pure returns (string memory);
48 
49     function decimals() external pure returns (uint8);
50 
51     function totalSupply() external view returns (uint256);
52 
53     function balanceOf(address owner) external view returns (uint256);
54 
55     function allowance(address owner, address spender)
56         external
57         view
58         returns (uint256);
59 
60     function approve(address spender, uint256 value) external returns (bool);
61 
62     function transfer(address to, uint256 value) external returns (bool);
63 
64     function transferFrom(
65         address from,
66         address to,
67         uint256 value
68     ) external returns (bool);
69 
70     function DOMAIN_SEPARATOR() external view returns (bytes32);
71 
72     function PERMIT_TYPEHASH() external pure returns (bytes32);
73 
74     function nonces(address owner) external view returns (uint256);
75 
76     function permit(
77         address owner,
78         address spender,
79         uint256 value,
80         uint256 deadline,
81         uint8 v,
82         bytes32 r,
83         bytes32 s
84     ) external;
85 
86     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
87     event Burn(
88         address indexed sender,
89         uint256 amount0,
90         uint256 amount1,
91         address indexed to
92     );
93     event Swap(
94         address indexed sender,
95         uint256 amount0In,
96         uint256 amount1In,
97         uint256 amount0Out,
98         uint256 amount1Out,
99         address indexed to
100     );
101     event Sync(uint112 reserve0, uint112 reserve1);
102 
103     function MINIMUM_LIQUIDITY() external pure returns (uint256);
104 
105     function factory() external view returns (address);
106 
107     function token0() external view returns (address);
108 
109     function token1() external view returns (address);
110 
111     function getReserves()
112         external
113         view
114         returns (
115             uint112 reserve0,
116             uint112 reserve1,
117             uint32 blockTimestampLast
118         );
119 
120     function price0CumulativeLast() external view returns (uint256);
121 
122     function price1CumulativeLast() external view returns (uint256);
123 
124     function kLast() external view returns (uint256);
125 
126     function mint(address to) external returns (uint256 liquidity);
127 
128     function burn(address to)
129         external
130         returns (uint256 amount0, uint256 amount1);
131 
132     function swap(
133         uint256 amount0Out,
134         uint256 amount1Out,
135         address to,
136         bytes calldata data
137     ) external;
138 
139     function skim(address to) external;
140 
141     function sync() external;
142 
143     function initialize(address, address) external;
144 }
145 
146 interface IUniswapV2Router01 {
147     function factory() external pure returns (address);
148 
149     function WETH() external pure returns (address);
150 
151     function addLiquidity(
152         address tokenA,
153         address tokenB,
154         uint256 amountADesired,
155         uint256 amountBDesired,
156         uint256 amountAMin,
157         uint256 amountBMin,
158         address to,
159         uint256 deadline
160     )
161         external
162         returns (
163             uint256 amountA,
164             uint256 amountB,
165             uint256 liquidity
166         );
167 
168     function addLiquidityETH(
169         address token,
170         uint256 amountTokenDesired,
171         uint256 amountTokenMin,
172         uint256 amountETHMin,
173         address to,
174         uint256 deadline
175     )
176         external
177         payable
178         returns (
179             uint256 amountToken,
180             uint256 amountETH,
181             uint256 liquidity
182         );
183 
184     function removeLiquidity(
185         address tokenA,
186         address tokenB,
187         uint256 liquidity,
188         uint256 amountAMin,
189         uint256 amountBMin,
190         address to,
191         uint256 deadline
192     ) external returns (uint256 amountA, uint256 amountB);
193 
194     function removeLiquidityETH(
195         address token,
196         uint256 liquidity,
197         uint256 amountTokenMin,
198         uint256 amountETHMin,
199         address to,
200         uint256 deadline
201     ) external returns (uint256 amountToken, uint256 amountETH);
202 
203     function removeLiquidityWithPermit(
204         address tokenA,
205         address tokenB,
206         uint256 liquidity,
207         uint256 amountAMin,
208         uint256 amountBMin,
209         address to,
210         uint256 deadline,
211         bool approveMax,
212         uint8 v,
213         bytes32 r,
214         bytes32 s
215     ) external returns (uint256 amountA, uint256 amountB);
216 
217     function removeLiquidityETHWithPermit(
218         address token,
219         uint256 liquidity,
220         uint256 amountTokenMin,
221         uint256 amountETHMin,
222         address to,
223         uint256 deadline,
224         bool approveMax,
225         uint8 v,
226         bytes32 r,
227         bytes32 s
228     ) external returns (uint256 amountToken, uint256 amountETH);
229 
230     function swapExactTokensForTokens(
231         uint256 amountIn,
232         uint256 amountOutMin,
233         address[] calldata path,
234         address to,
235         uint256 deadline
236     ) external returns (uint256[] memory amounts);
237 
238     function swapTokensForExactTokens(
239         uint256 amountOut,
240         uint256 amountInMax,
241         address[] calldata path,
242         address to,
243         uint256 deadline
244     ) external returns (uint256[] memory amounts);
245 
246     function swapExactETHForTokens(
247         uint256 amountOutMin,
248         address[] calldata path,
249         address to,
250         uint256 deadline
251     ) external payable returns (uint256[] memory amounts);
252 
253     function swapTokensForExactETH(
254         uint256 amountOut,
255         uint256 amountInMax,
256         address[] calldata path,
257         address to,
258         uint256 deadline
259     ) external returns (uint256[] memory amounts);
260 
261     function swapExactTokensForETH(
262         uint256 amountIn,
263         uint256 amountOutMin,
264         address[] calldata path,
265         address to,
266         uint256 deadline
267     ) external returns (uint256[] memory amounts);
268 
269     function swapETHForExactTokens(
270         uint256 amountOut,
271         address[] calldata path,
272         address to,
273         uint256 deadline
274     ) external payable returns (uint256[] memory amounts);
275 
276     function quote(
277         uint256 amountA,
278         uint256 reserveA,
279         uint256 reserveB
280     ) external pure returns (uint256 amountB);
281 
282     function getAmountOut(
283         uint256 amountIn,
284         uint256 reserveIn,
285         uint256 reserveOut
286     ) external pure returns (uint256 amountOut);
287 
288     function getAmountIn(
289         uint256 amountOut,
290         uint256 reserveIn,
291         uint256 reserveOut
292     ) external pure returns (uint256 amountIn);
293 
294     function getAmountsOut(uint256 amountIn, address[] calldata path)
295         external
296         view
297         returns (uint256[] memory amounts);
298 
299     function getAmountsIn(uint256 amountOut, address[] calldata path)
300         external
301         view
302         returns (uint256[] memory amounts);
303 }
304 
305 interface IUniswapV2Router02 is IUniswapV2Router01 {
306     function removeLiquidityETHSupportingFeeOnTransferTokens(
307         address token,
308         uint256 liquidity,
309         uint256 amountTokenMin,
310         uint256 amountETHMin,
311         address to,
312         uint256 deadline
313     ) external returns (uint256 amountETH);
314 
315     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
316         address token,
317         uint256 liquidity,
318         uint256 amountTokenMin,
319         uint256 amountETHMin,
320         address to,
321         uint256 deadline,
322         bool approveMax,
323         uint8 v,
324         bytes32 r,
325         bytes32 s
326     ) external returns (uint256 amountETH);
327 
328     function swapExactETHForTokensSupportingFeeOnTransferTokens(
329         uint256 amountOutMin,
330         address[] calldata path,
331         address to,
332         uint256 deadline
333     ) external payable;
334 
335     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
336         uint256 amountIn,
337         uint256 amountOutMin,
338         address[] calldata path,
339         address to,
340         uint256 deadline
341     ) external;
342 
343     function swapExactTokensForETHSupportingFeeOnTransferTokens(
344         uint256 amountIn,
345         uint256 amountOutMin,
346         address[] calldata path,
347         address to,
348         uint256 deadline
349     ) external;
350 }
351 
352 /**
353  * @dev Interface of the ERC20 standard as defined in the EIP.
354  */
355 interface IERC20 {
356     /**
357      * @dev Emitted when `value` tokens are moved from one account (`from`) to
358      * another (`to`).
359      *
360      * Note that `value` may be zero.
361      */
362     event Transfer(address indexed from, address indexed to, uint256 value);
363 
364     /**
365      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
366      * a call to {approve}. `value` is the new allowance.
367      */
368     event Approval(
369         address indexed owner,
370         address indexed spender,
371         uint256 value
372     );
373 
374     /**
375      * @dev Returns the amount of tokens in existence.
376      */
377     function totalSupply() external view returns (uint256);
378 
379     /**
380      * @dev Returns the amount of tokens owned by `account`.
381      */
382     function balanceOf(address account) external view returns (uint256);
383 
384     /**
385      * @dev Moves `amount` tokens from the caller's account to `to`.
386      *
387      * Returns a boolean value indicating whether the operation succeeded.
388      *
389      * Emits a {Transfer} event.
390      */
391     function transfer(address to, uint256 amount) external returns (bool);
392 
393     /**
394      * @dev Returns the remaining number of tokens that `spender` will be
395      * allowed to spend on behalf of `owner` through {transferFrom}. This is
396      * zero by default.
397      *
398      * This value changes when {approve} or {transferFrom} are called.
399      */
400     function allowance(address owner, address spender)
401         external
402         view
403         returns (uint256);
404 
405     /**
406      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
407      *
408      * Returns a boolean value indicating whether the operation succeeded.
409      *
410      * IMPORTANT: Beware that changing an allowance with this method brings the risk
411      * that someone may use both the old and the new allowance by unfortunate
412      * transaction ordering. One possible solution to mitigate this race
413      * condition is to first reduce the spender's allowance to 0 and set the
414      * desired value afterwards:
415      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
416      *
417      * Emits an {Approval} event.
418      */
419     function approve(address spender, uint256 amount) external returns (bool);
420 
421     /**
422      * @dev Moves `amount` tokens from `from` to `to` using the
423      * allowance mechanism. `amount` is then deducted from the caller's
424      * allowance.
425      *
426      * Returns a boolean value indicating whether the operation succeeded.
427      *
428      * Emits a {Transfer} event.
429      */
430     function transferFrom(
431         address from,
432         address to,
433         uint256 amount
434     ) external returns (bool);
435 }
436 
437 /**
438  * @dev Interface for the optional metadata functions from the ERC20 standard.
439  *
440  * _Available since v4.1._
441  */
442 interface IERC20Metadata is IERC20 {
443     /**
444      * @dev Returns the name of the token.
445      */
446     function name() external view returns (string memory);
447 
448     /**
449      * @dev Returns the decimals places of the token.
450      */
451     function decimals() external view returns (uint8);
452 
453     /**
454      * @dev Returns the symbol of the token.
455      */
456     function symbol() external view returns (string memory);
457 }
458 
459 /**
460  * @dev Provides information about the current execution context, including the
461  * sender of the transaction and its data. While these are generally available
462  * via msg.sender and msg.data, they should not be accessed in such a direct
463  * manner, since when dealing with meta-transactions the account sending and
464  * paying for execution may not be the actual sender (as far as an application
465  * is concerned).
466  *
467  * This contract is only required for intermediate, library-like contracts.
468  */
469 abstract contract Context {
470     function _msgSender() internal view virtual returns (address) {
471         return msg.sender;
472     }
473 }
474 
475 /**
476  * @dev Contract module which provides a basic access control mechanism, where
477  * there is an account (an owner) that can be granted exclusive access to
478  * specific functions.
479  *
480  * By default, the owner account will be the one that deploys the contract. This
481  * can later be changed with {transferOwnership}.
482  *
483  * This module is used through inheritance. It will make available the modifier
484  * `onlyOwner`, which can be applied to your functions to restrict their use to
485  * the owner.
486  */
487 abstract contract Ownable is Context {
488     address private _owner;
489 
490     event OwnershipTransferred(
491         address indexed previousOwner,
492         address indexed newOwner
493     );
494 
495     /**
496      * @dev Initializes the contract setting the deployer as the initial owner.
497      */
498     constructor() {
499         _transferOwnership(_msgSender());
500     }
501 
502     /**
503      * @dev Throws if called by any account other than the owner.
504      */
505     modifier onlyOwner() {
506         _checkOwner();
507         _;
508     }
509 
510     /**
511      * @dev Returns the address of the current owner.
512      */
513     function owner() public view virtual returns (address) {
514         return _owner;
515     }
516 
517     /**
518      * @dev Throws if the sender is not the owner.
519      */
520     function _checkOwner() internal view virtual {
521         require(owner() == _msgSender(), "Ownable: caller is not the owner");
522     }
523 
524     /**
525      * @dev Leaves the contract without owner. It will not be possible to call
526      * `onlyOwner` functions anymore. Can only be called by the current owner.
527      *
528      * NOTE: Renouncing ownership will leave the contract without an owner,
529      * thereby removing any functionality that is only available to the owner.
530      */
531     function renounceOwnership() public virtual onlyOwner {
532         _transferOwnership(address(0));
533     }
534 
535     /**
536      * @dev Transfers ownership of the contract to a new account (`newOwner`).
537      * Can only be called by the current owner.
538      */
539     function transferOwnership(address newOwner) public virtual onlyOwner {
540         require(
541             newOwner != address(0),
542             "Ownable: new owner is the zero address"
543         );
544         _transferOwnership(newOwner);
545     }
546 
547     /**
548      * @dev Transfers ownership of the contract to a new account (`newOwner`).
549      * Internal function without access restriction.
550      */
551     function _transferOwnership(address newOwner) internal virtual {
552         address oldOwner = _owner;
553         _owner = newOwner;
554         emit OwnershipTransferred(oldOwner, newOwner);
555     }
556 }
557 
558 /**
559  * @dev Implementation of the {IERC20} interface.
560  *
561  * This implementation is agnostic to the way tokens are created. This means
562  * that a supply mechanism has to be added in a derived contract using {_mint}.
563  * For a generic mechanism see {ERC20PresetMinterPauser}.
564  *
565  * TIP: For a detailed writeup see our guide
566  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
567  * to implement supply mechanisms].
568  *
569  * We have followed general OpenZeppelin Contracts guidelines: functions revert
570  * instead returning `false` on failure. This behavior is nonetheless
571  * conventional and does not conflict with the expectations of ERC20
572  * applications.
573  *
574  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
575  * This allows applications to reconstruct the allowance for all accounts just
576  * by listening to said events. Other implementations of the EIP may not emit
577  * these events, as it isn't required by the specification.
578  *
579  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
580  * functions have been added to mitigate the well-known issues around setting
581  * allowances. See {IERC20-approve}.
582  */
583 contract ERC20 is Context, IERC20, IERC20Metadata {
584     mapping(address => uint256) private _balances;
585     mapping(address => mapping(address => uint256)) private _allowances;
586 
587     uint256 private _totalSupply;
588 
589     string private _name;
590     string private _symbol;
591 
592     constructor(string memory name_, string memory symbol_) {
593         _name = name_;
594         _symbol = symbol_;
595     }
596 
597     /**
598      * @dev Returns the name of the token.
599      */
600     function name() external view virtual override returns (string memory) {
601         return _name;
602     }
603 
604     /**
605      * @dev Returns the symbol of the token, usually a shorter version of the
606      * name.
607      */
608     function symbol() external view virtual override returns (string memory) {
609         return _symbol;
610     }
611 
612     /**
613      * @dev See {IERC20-balanceOf}.
614      */
615     function balanceOf(address account)
616         public
617         view
618         virtual
619         override
620         returns (uint256)
621     {
622         return _balances[account];
623     }
624 
625     /**
626      * @dev Returns the number of decimals used to get its user representation.
627      * For example, if `decimals` equals `2`, a balance of `505` tokens should
628      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
629      *
630      * Tokens usually opt for a value of 18, imitating the relationship between
631      * Ether and Wei. This is the value {ERC20} uses, unless this function is
632      * overridden;
633      *
634      * NOTE: This information is only used for _display_ purposes: it in
635      * no way affects any of the arithmetic of the contract, including
636      * {IERC20-balanceOf} and {IERC20-transfer}.
637      */
638     function decimals() public view virtual override returns (uint8) {
639         return 18;
640     }
641 
642     /**
643      * @dev See {IERC20-totalSupply}.
644      */
645     function totalSupply() external view virtual override returns (uint256) {
646         return _totalSupply;
647     }
648 
649     /**
650      * @dev See {IERC20-allowance}.
651      */
652     function allowance(address owner, address spender)
653         public
654         view
655         virtual
656         override
657         returns (uint256)
658     {
659         return _allowances[owner][spender];
660     }
661 
662     /**
663      * @dev See {IERC20-transfer}.
664      *
665      * Requirements:
666      *
667      * - `to` cannot be the zero address.
668      * - the caller must have a balance of at least `amount`.
669      */
670     function transfer(address to, uint256 amount)
671         external
672         virtual
673         override
674         returns (bool)
675     {
676         address owner = _msgSender();
677         _transfer(owner, to, amount);
678         return true;
679     }
680 
681     /**
682      * @dev See {IERC20-approve}.
683      *
684      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
685      * `transferFrom`. This is semantically equivalent to an infinite approval.
686      *
687      * Requirements:
688      *
689      * - `spender` cannot be the zero address.
690      */
691     function approve(address spender, uint256 amount)
692         external
693         virtual
694         override
695         returns (bool)
696     {
697         address owner = _msgSender();
698         _approve(owner, spender, amount);
699         return true;
700     }
701 
702     /**
703      * @dev See {IERC20-transferFrom}.
704      *
705      * Emits an {Approval} event indicating the updated allowance. This is not
706      * required by the EIP. See the note at the beginning of {ERC20}.
707      *
708      * NOTE: Does not update the allowance if the current allowance
709      * is the maximum `uint256`.
710      *
711      * Requirements:
712      *
713      * - `from` and `to` cannot be the zero address.
714      * - `from` must have a balance of at least `amount`.
715      * - the caller must have allowance for ``from``'s tokens of at least
716      * `amount`.
717      */
718     function transferFrom(
719         address from,
720         address to,
721         uint256 amount
722     ) external virtual override returns (bool) {
723         address spender = _msgSender();
724         _spendAllowance(from, spender, amount);
725         _transfer(from, to, amount);
726         return true;
727     }
728 
729     /**
730      * @dev Atomically decreases the allowance granted to `spender` by the caller.
731      *
732      * This is an alternative to {approve} that can be used as a mitigation for
733      * problems described in {IERC20-approve}.
734      *
735      * Emits an {Approval} event indicating the updated allowance.
736      *
737      * Requirements:
738      *
739      * - `spender` cannot be the zero address.
740      * - `spender` must have allowance for the caller of at least
741      * `subtractedValue`.
742      */
743     function decreaseAllowance(address spender, uint256 subtractedValue)
744         external
745         virtual
746         returns (bool)
747     {
748         address owner = _msgSender();
749         uint256 currentAllowance = allowance(owner, spender);
750         require(
751             currentAllowance >= subtractedValue,
752             "ERC20: decreased allowance below zero"
753         );
754         unchecked {
755             _approve(owner, spender, currentAllowance - subtractedValue);
756         }
757 
758         return true;
759     }
760 
761     /**
762      * @dev Atomically increases the allowance granted to `spender` by the caller.
763      *
764      * This is an alternative to {approve} that can be used as a mitigation for
765      * problems described in {IERC20-approve}.
766      *
767      * Emits an {Approval} event indicating the updated allowance.
768      *
769      * Requirements:
770      *
771      * - `spender` cannot be the zero address.
772      */
773     function increaseAllowance(address spender, uint256 addedValue)
774         external
775         virtual
776         returns (bool)
777     {
778         address owner = _msgSender();
779         _approve(owner, spender, allowance(owner, spender) + addedValue);
780         return true;
781     }
782 
783     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
784      * the total supply.
785      *
786      * Emits a {Transfer} event with `from` set to the zero address.
787      *
788      * Requirements:
789      *
790      * - `account` cannot be the zero address.
791      */
792     function _mint(address account, uint256 amount) internal virtual {
793         require(account != address(0), "ERC20: mint to the zero address");
794 
795         _totalSupply += amount;
796         unchecked {
797             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
798             _balances[account] += amount;
799         }
800         emit Transfer(address(0), account, amount);
801     }
802 
803     /**
804      * @dev Destroys `amount` tokens from `account`, reducing the
805      * total supply.
806      *
807      * Emits a {Transfer} event with `to` set to the zero address.
808      *
809      * Requirements:
810      *
811      * - `account` cannot be the zero address.
812      * - `account` must have at least `amount` tokens.
813      */
814     function _burn(address account, uint256 amount) internal virtual {
815         require(account != address(0), "ERC20: burn from the zero address");
816 
817         uint256 accountBalance = _balances[account];
818         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
819         unchecked {
820             _balances[account] = accountBalance - amount;
821             // Overflow not possible: amount <= accountBalance <= totalSupply.
822             _totalSupply -= amount;
823         }
824 
825         emit Transfer(account, address(0), amount);
826     }
827 
828     /**
829      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
830      *
831      * This internal function is equivalent to `approve`, and can be used to
832      * e.g. set automatic allowances for certain subsystems, etc.
833      *
834      * Emits an {Approval} event.
835      *
836      * Requirements:
837      *
838      * - `owner` cannot be the zero address.
839      * - `spender` cannot be the zero address.
840      */
841     function _approve(
842         address owner,
843         address spender,
844         uint256 amount
845     ) internal virtual {
846         require(owner != address(0), "ERC20: approve from the zero address");
847         require(spender != address(0), "ERC20: approve to the zero address");
848 
849         _allowances[owner][spender] = amount;
850         emit Approval(owner, spender, amount);
851     }
852 
853     /**
854      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
855      *
856      * Does not update the allowance amount in case of infinite allowance.
857      * Revert if not enough allowance is available.
858      *
859      * Might emit an {Approval} event.
860      */
861     function _spendAllowance(
862         address owner,
863         address spender,
864         uint256 amount
865     ) internal virtual {
866         uint256 currentAllowance = allowance(owner, spender);
867         if (currentAllowance != type(uint256).max) {
868             require(
869                 currentAllowance >= amount,
870                 "ERC20: insufficient allowance"
871             );
872             unchecked {
873                 _approve(owner, spender, currentAllowance - amount);
874             }
875         }
876     }
877 
878     function _transfer(
879         address from,
880         address to,
881         uint256 amount
882     ) internal virtual {
883         require(from != address(0), "ERC20: transfer from the zero address");
884         require(to != address(0), "ERC20: transfer to the zero address");
885 
886         uint256 fromBalance = _balances[from];
887         require(
888             fromBalance >= amount,
889             "ERC20: transfer amount exceeds balance"
890         );
891         unchecked {
892             _balances[from] = fromBalance - amount;
893             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
894             // decrementing then incrementing.
895             _balances[to] += amount;
896         }
897 
898         emit Transfer(from, to, amount);
899     }
900 }
901 
902 /**
903  * @dev Implementation of the {IERC20} interface.
904  *
905  * This implementation is agnostic to the way tokens are created. This means
906  * that a supply mechanism has to be added in a derived contract using {_mint}.
907  * For a generic mechanism see {ERC20PresetMinterPauser}.
908  *
909  * TIP: For a detailed writeup see our guide
910  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
911  * to implement supply mechanisms].
912  *
913  * We have followed general OpenZeppelin Contracts guidelines: functions revert
914  * instead returning `false` on failure. This behavior is nonetheless
915  * conventional and does not conflict with the expectations of ERC20
916  * applications.
917  *
918  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
919  * This allows applications to reconstruct the allowance for all accounts just
920  * by listening to said events. Other implementations of the EIP may not emit
921  * these events, as it isn't required by the specification.
922  *
923  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
924  * functions have been added to mitigate the well-known issues around setting
925  * allowances. See {IERC20-approve}.
926  */
927 contract RickPepe is ERC20, Ownable {
928     // TOKENOMICS START ==========================================================>
929     string private _name = "Rick Pepe";
930     string private _symbol = "$RICK";
931     uint8 private _decimals = 18;
932     uint256 private _supply = 69000000000;
933     uint256 public taxForLiquidity = 2;
934     uint256 public taxForMarketing = 25;
935     uint256 public maxTxAmount = 2 * 10**_decimals;
936     uint256 public maxWalletAmount = 2 * 10**_decimals;
937     address public marketingWallet = 0x88C1052FD4eE78ca9B255FDAc35A2DFD7302ae58;
938     // TOKENOMICS END ============================================================>
939 
940     IUniswapV2Router02 public immutable uniswapV2Router;
941     address public immutable uniswapV2Pair;
942 
943     uint256 private _marketingReserves = 0;
944     mapping(address => bool) private _isExcludedFromFee;
945     uint256 private _numTokensSellToAddToLiquidity = 1725000000 * 10**_decimals;
946     uint256 private _numTokensSellToAddToETH = 690000000 * 10**_decimals;
947     bool inSwapAndLiquify;
948 
949     event SwapAndLiquify(
950         uint256 tokensSwapped,
951         uint256 ethReceived,
952         uint256 tokensIntoLiqudity
953     );
954 
955     modifier lockTheSwap() {
956         inSwapAndLiquify = true;
957         _;
958         inSwapAndLiquify = false;
959     }
960 
961     /**
962      * @dev Sets the values for {name} and {symbol}.
963      *
964      * The default value of {decimals} is 18. To select a different value for
965      * {decimals} you should overload it.
966      *
967      * All two of these values are immutable: they can only be set once during
968      * construction.
969      */
970     constructor() ERC20(_name, _symbol) {
971         _mint(msg.sender, (_supply * 10**_decimals));
972 
973         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
974             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
975         );
976         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
977             .createPair(address(this), _uniswapV2Router.WETH());
978 
979         uniswapV2Router = _uniswapV2Router;
980 
981         _isExcludedFromFee[address(uniswapV2Router)] = true;
982         _isExcludedFromFee[msg.sender] = true;
983         _isExcludedFromFee[marketingWallet] = true;
984     }
985 
986     /**
987      * @dev Returns the number of decimals used to get its user representation.
988      * For example, if `decimals` equals `2`, a balance of `505` tokens should
989      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
990      *
991      * Tokens usually opt for a value of 18, imitating the relationship between
992      * Ether and Wei. This is the value {ERC20} uses, unless this function is
993      * overridden;
994      *
995      * NOTE: This information is only used for _display_ purposes: it in
996      * no way affects any of the arithmetic of the contract, including
997      * {IERC20-balanceOf} and {IERC20-transfer}.
998      */
999     function decimals() public view override returns (uint8) {
1000         return _decimals;
1001     }
1002 
1003     /**
1004      * @dev Moves `amount` of tokens from `from` to `to`.
1005      *
1006      * This internal function is equivalent to {transfer}, and can be used to
1007      * e.g. implement automatic token fees, slashing mechanisms, etc.
1008      *
1009      * Emits a {Transfer} event.
1010      *
1011      * Requirements:
1012      *
1013      *
1014      * - `from` cannot be the zero address.
1015      * - `to` cannot be the zero address.
1016      * - `from` must have a balance of at least `amount`.
1017      */
1018     function _transfer(
1019         address from,
1020         address to,
1021         uint256 amount
1022     ) internal override {
1023         require(from != address(0), "ERC20: transfer from the zero address");
1024         require(to != address(0), "ERC20: transfer to the zero address");
1025         require(
1026             balanceOf(from) >= amount,
1027             "ERC20: transfer amount exceeds balance"
1028         );
1029 
1030         if (
1031             (from == uniswapV2Pair || to == uniswapV2Pair) && !inSwapAndLiquify
1032         ) {
1033             if (from != uniswapV2Pair) {
1034                 uint256 contractLiquidityBalance = balanceOf(address(this)) -
1035                     _marketingReserves;
1036                 if (
1037                     contractLiquidityBalance >= _numTokensSellToAddToLiquidity
1038                 ) {
1039                     _swapAndLiquify(_numTokensSellToAddToLiquidity);
1040                 }
1041                 if ((_marketingReserves) >= _numTokensSellToAddToETH) {
1042                     _swapTokensForEth(_numTokensSellToAddToETH);
1043                     _marketingReserves -= _numTokensSellToAddToETH;
1044                     bool sent = payable(marketingWallet).send(
1045                         address(this).balance
1046                     );
1047                     require(sent, "Failed to send ETH");
1048                 }
1049             }
1050 
1051             uint256 transferAmount;
1052             if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
1053                 transferAmount = amount;
1054             } else {
1055                 require(
1056                     amount <= maxTxAmount,
1057                     "ERC20: transfer amount exceeds the max transaction amount"
1058                 );
1059                 if (from == uniswapV2Pair) {
1060                     require(
1061                         (amount + balanceOf(to)) <= maxWalletAmount,
1062                         "ERC20: balance amount exceeded max wallet amount limit"
1063                     );
1064                 }
1065 
1066                 uint256 marketingShare = ((amount * taxForMarketing) / 100);
1067                 uint256 liquidityShare = ((amount * taxForLiquidity) / 100);
1068                 transferAmount = amount - (marketingShare + liquidityShare);
1069                 _marketingReserves += marketingShare;
1070 
1071                 super._transfer(
1072                     from,
1073                     address(this),
1074                     (marketingShare + liquidityShare)
1075                 );
1076             }
1077             super._transfer(from, to, transferAmount);
1078         } else {
1079             super._transfer(from, to, amount);
1080         }
1081     }
1082 
1083     function _swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1084         uint256 half = (contractTokenBalance / 2);
1085         uint256 otherHalf = (contractTokenBalance - half);
1086 
1087         uint256 initialBalance = address(this).balance;
1088 
1089         _swapTokensForEth(half);
1090 
1091         uint256 newBalance = (address(this).balance - initialBalance);
1092 
1093         _addLiquidity(otherHalf, newBalance);
1094 
1095         emit SwapAndLiquify(half, newBalance, otherHalf);
1096     }
1097 
1098     function _swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
1099         address[] memory path = new address[](2);
1100         path[0] = address(this);
1101         path[1] = uniswapV2Router.WETH();
1102 
1103         _approve(address(this), address(uniswapV2Router), tokenAmount);
1104 
1105         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1106             tokenAmount,
1107             0,
1108             path,
1109             address(this),
1110             (block.timestamp + 300)
1111         );
1112     }
1113 
1114     function _addLiquidity(uint256 tokenAmount, uint256 ethAmount)
1115         private
1116         lockTheSwap
1117     {
1118         _approve(address(this), address(uniswapV2Router), tokenAmount);
1119 
1120         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1121             address(this),
1122             tokenAmount,
1123             0,
1124             0,
1125             owner(),
1126             block.timestamp
1127         );
1128     }
1129 
1130     function changeTaxForLiquidityAndMarketing(
1131         uint256 _taxForLiquidity,
1132         uint256 _taxForMarketing
1133     ) public onlyOwner returns (bool) {
1134         require(
1135             (_taxForLiquidity + _taxForMarketing) <= 100,
1136             "ERC20: total tax must not be greater than 100"
1137         );
1138         taxForLiquidity = _taxForLiquidity;
1139         taxForMarketing = _taxForMarketing;
1140 
1141         return true;
1142     }
1143 
1144     function changeMarketingWallet(address newWallet)
1145         public
1146         onlyOwner
1147         returns (bool)
1148     {
1149         marketingWallet = newWallet;
1150         return true;
1151     }
1152 
1153     function changeMaxTxAmount(uint256 _maxTxAmount)
1154         public
1155         onlyOwner
1156         returns (bool)
1157     {
1158         maxTxAmount = _maxTxAmount;
1159 
1160         return true;
1161     }
1162 
1163     function changeMaxWalletAmount(uint256 _maxWalletAmount)
1164         public
1165         onlyOwner
1166         returns (bool)
1167     {
1168         maxWalletAmount = _maxWalletAmount;
1169 
1170         return true;
1171     }
1172 
1173     receive() external payable {}
1174 }