1 //SPDX-License-Identifier: MIT 
2 // File: @openzeppelin/contracts/utils/Context.sol
3 
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes calldata) {
25         return msg.data;
26     }
27 }
28 
29 // File: @openzeppelin/contracts/access/Ownable.sol
30 
31 
32 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
33 
34 pragma solidity ^0.8.0;
35 
36 
37 /**
38  * @dev Contract module which provides a basic access control mechanism, where
39  * there is an account (an owner) that can be granted exclusive access to
40  * specific functions.
41  *
42  * By default, the owner account will be the one that deploys the contract. This
43  * can later be changed with {transferOwnership}.
44  *
45  * This module is used through inheritance. It will make available the modifier
46  * `onlyOwner`, which can be applied to your functions to restrict their use to
47  * the owner.
48  */
49 abstract contract Ownable is Context {
50     address private _owner;
51 
52     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
53 
54     /**
55      * @dev Initializes the contract setting the deployer as the initial owner.
56      */
57     constructor() {
58         _transferOwnership(_msgSender());
59     }
60 
61     /**
62      * @dev Returns the address of the current owner.
63      */
64     function owner() public view virtual returns (address) {
65         return _owner;
66     }
67 
68     /**
69      * @dev Throws if called by any account other than the owner.
70      */
71     modifier onlyOwner() {
72         require(owner() == _msgSender(), "Ownable: caller is not the owner");
73         _;
74     }
75 
76     /**
77      * @dev Leaves the contract without owner. It will not be possible to call
78      * `onlyOwner` functions anymore. Can only be called by the current owner.
79      *
80      * NOTE: Renouncing ownership will leave the contract without an owner,
81      * thereby removing any functionality that is only available to the owner.
82      */
83     function renounceOwnership() public virtual onlyOwner {
84         _transferOwnership(address(0));
85     }
86 
87     /**
88      * @dev Transfers ownership of the contract to a new account (`newOwner`).
89      * Can only be called by the current owner.
90      */
91     function transferOwnership(address newOwner) public virtual onlyOwner {
92         require(newOwner != address(0), "Ownable: new owner is the zero address");
93         _transferOwnership(newOwner);
94     }
95 
96     /**
97      * @dev Transfers ownership of the contract to a new account (`newOwner`).
98      * Internal function without access restriction.
99      */
100     function _transferOwnership(address newOwner) internal virtual {
101         address oldOwner = _owner;
102         _owner = newOwner;
103         emit OwnershipTransferred(oldOwner, newOwner);
104     }
105 }
106 
107 
108 pragma solidity 0.8.16;
109 
110 interface IUniswapV2Factory {
111     event PairCreated(
112         address indexed token0,
113         address indexed token1,
114         address pair,
115         uint256
116     );
117 
118     function feeTo() external view returns (address);
119 
120     function feeToSetter() external view returns (address);
121 
122     function getPair(address tokenA, address tokenB)
123         external
124         view
125         returns (address pair);
126 
127     function allPairs(uint256) external view returns (address pair);
128 
129     function createPair(address tokenA, address tokenB)
130         external
131         returns (address pair);
132 
133     function setFeeTo(address) external;
134 
135     function allPairsLength() external view returns (uint256);
136 
137     function setFeeToSetter(address) external;
138 }
139 
140 interface IUniswapV2Pair {
141     event Approval(
142         address indexed owner,
143         address indexed spender,
144         uint256 value
145     );
146     event Transfer(address indexed from, address indexed to, uint256 value);
147 
148     function name() external pure returns (string memory);
149 
150     function symbol() external pure returns (string memory);
151 
152     function decimals() external pure returns (uint8);
153 
154     function totalSupply() external view returns (uint256);
155 
156     function balanceOf(address owner) external view returns (uint256);
157 
158     function allowance(address owner, address spender)
159         external
160         view
161         returns (uint256);
162 
163     function approve(address spender, uint256 value) external returns (bool);
164 
165     function transfer(address to, uint256 value) external returns (bool);
166 
167     function transferFrom(
168         address from,
169         address to,
170         uint256 value
171     ) external returns (bool);
172 
173     function DOMAIN_SEPARATOR() external view returns (bytes32);
174 
175     function PERMIT_TYPEHASH() external pure returns (bytes32);
176 
177     function nonces(address owner) external view returns (uint256);
178 
179     function permit(
180         address owner,
181         address spender,
182         uint256 value,
183         uint256 deadline,
184         uint8 v,
185         bytes32 r,
186         bytes32 s
187     ) external;
188 
189     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
190     event Burn(
191         address indexed sender,
192         uint256 amount0,
193         uint256 amount1,
194         address indexed to
195     );
196     event Swap(
197         address indexed sender,
198         uint256 amount0In,
199         uint256 amount1In,
200         uint256 amount0Out,
201         uint256 amount1Out,
202         address indexed to
203     );
204     event Sync(uint112 reserve0, uint112 reserve1);
205 
206     function MINIMUM_LIQUIDITY() external pure returns (uint256);
207 
208     function factory() external view returns (address);
209 
210     function token0() external view returns (address);
211 
212     function token1() external view returns (address);
213 
214     function getReserves()
215         external
216         view
217         returns (
218             uint112 reserve0,
219             uint112 reserve1,
220             uint32 blockTimestampLast
221         );
222 
223     function price0CumulativeLast() external view returns (uint256);
224 
225     function price1CumulativeLast() external view returns (uint256);
226 
227     function kLast() external view returns (uint256);
228 
229     function mint(address to) external returns (uint256 liquidity);
230 
231     function burn(address to)
232         external
233         returns (uint256 amount0, uint256 amount1);
234 
235     function swap(
236         uint256 amount0Out,
237         uint256 amount1Out,
238         address to,
239         bytes calldata data
240     ) external;
241 
242     function skim(address to) external;
243 
244     function sync() external;
245 
246     function initialize(address, address) external;
247 }
248 
249 interface IUniswapV2Router01 {
250     function factory() external pure returns (address);
251 
252     function WETH() external pure returns (address);
253 
254     function addLiquidity(
255         address tokenA,
256         address tokenB,
257         uint256 amountADesired,
258         uint256 amountBDesired,
259         uint256 amountAMin,
260         uint256 amountBMin,
261         address to,
262         uint256 deadline
263     )
264         external
265         returns (
266             uint256 amountA,
267             uint256 amountB,
268             uint256 liquidity
269         );
270 
271     function addLiquidityETH(
272         address token,
273         uint256 amountTokenDesired,
274         uint256 amountTokenMin,
275         uint256 amountETHMin,
276         address to,
277         uint256 deadline
278     )
279         external
280         payable
281         returns (
282             uint256 amountToken,
283             uint256 amountETH,
284             uint256 liquidity
285         );
286 
287     function removeLiquidity(
288         address tokenA,
289         address tokenB,
290         uint256 liquidity,
291         uint256 amountAMin,
292         uint256 amountBMin,
293         address to,
294         uint256 deadline
295     ) external returns (uint256 amountA, uint256 amountB);
296 
297     function removeLiquidityETH(
298         address token,
299         uint256 liquidity,
300         uint256 amountTokenMin,
301         uint256 amountETHMin,
302         address to,
303         uint256 deadline
304     ) external returns (uint256 amountToken, uint256 amountETH);
305 
306     function removeLiquidityWithPermit(
307         address tokenA,
308         address tokenB,
309         uint256 liquidity,
310         uint256 amountAMin,
311         uint256 amountBMin,
312         address to,
313         uint256 deadline,
314         bool approveMax,
315         uint8 v,
316         bytes32 r,
317         bytes32 s
318     ) external returns (uint256 amountA, uint256 amountB);
319 
320     function removeLiquidityETHWithPermit(
321         address token,
322         uint256 liquidity,
323         uint256 amountTokenMin,
324         uint256 amountETHMin,
325         address to,
326         uint256 deadline,
327         bool approveMax,
328         uint8 v,
329         bytes32 r,
330         bytes32 s
331     ) external returns (uint256 amountToken, uint256 amountETH);
332 
333     function swapExactTokensForTokens(
334         uint256 amountIn,
335         uint256 amountOutMin,
336         address[] calldata path,
337         address to,
338         uint256 deadline
339     ) external returns (uint256[] memory amounts);
340 
341     function swapTokensForExactTokens(
342         uint256 amountOut,
343         uint256 amountInMax,
344         address[] calldata path,
345         address to,
346         uint256 deadline
347     ) external returns (uint256[] memory amounts);
348 
349     function swapExactETHForTokens(
350         uint256 amountOutMin,
351         address[] calldata path,
352         address to,
353         uint256 deadline
354     ) external payable returns (uint256[] memory amounts);
355 
356     function swapTokensForExactETH(
357         uint256 amountOut,
358         uint256 amountInMax,
359         address[] calldata path,
360         address to,
361         uint256 deadline
362     ) external returns (uint256[] memory amounts);
363 
364     function swapExactTokensForETH(
365         uint256 amountIn,
366         uint256 amountOutMin,
367         address[] calldata path,
368         address to,
369         uint256 deadline
370     ) external returns (uint256[] memory amounts);
371 
372     function swapETHForExactTokens(
373         uint256 amountOut,
374         address[] calldata path,
375         address to,
376         uint256 deadline
377     ) external payable returns (uint256[] memory amounts);
378 
379     function quote(
380         uint256 amountA,
381         uint256 reserveA,
382         uint256 reserveB
383     ) external pure returns (uint256 amountB);
384 
385     function getAmountOut(
386         uint256 amountIn,
387         uint256 reserveIn,
388         uint256 reserveOut
389     ) external pure returns (uint256 amountOut);
390 
391     function getAmountIn(
392         uint256 amountOut,
393         uint256 reserveIn,
394         uint256 reserveOut
395     ) external pure returns (uint256 amountIn);
396 
397     function getAmountsOut(uint256 amountIn, address[] calldata path)
398         external
399         view
400         returns (uint256[] memory amounts);
401 
402     function getAmountsIn(uint256 amountOut, address[] calldata path)
403         external
404         view
405         returns (uint256[] memory amounts);
406 }
407 
408 interface IUniswapV2Router02 is IUniswapV2Router01 {
409     function removeLiquidityETHSupportingFeeOnTransferTokens(
410         address token,
411         uint256 liquidity,
412         uint256 amountTokenMin,
413         uint256 amountETHMin,
414         address to,
415         uint256 deadline
416     ) external returns (uint256 amountETH);
417 
418     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
419         address token,
420         uint256 liquidity,
421         uint256 amountTokenMin,
422         uint256 amountETHMin,
423         address to,
424         uint256 deadline,
425         bool approveMax,
426         uint8 v,
427         bytes32 r,
428         bytes32 s
429     ) external returns (uint256 amountETH);
430 
431     function swapExactETHForTokensSupportingFeeOnTransferTokens(
432         uint256 amountOutMin,
433         address[] calldata path,
434         address to,
435         uint256 deadline
436     ) external payable;
437 
438     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
439         uint256 amountIn,
440         uint256 amountOutMin,
441         address[] calldata path,
442         address to,
443         uint256 deadline
444     ) external;
445 
446     function swapExactTokensForETHSupportingFeeOnTransferTokens(
447         uint256 amountIn,
448         uint256 amountOutMin,
449         address[] calldata path,
450         address to,
451         uint256 deadline
452     ) external;
453 }
454 
455 /**
456  * @dev Interface of the ERC20 standard as defined in the EIP.
457  */
458 interface IERC20 {
459     /**
460      * @dev Emitted when `value` tokens are moved from one account (`from`) to
461      * another (`to`).
462      *
463      * Note that `value` may be zero.
464      */
465     event Transfer(address indexed from, address indexed to, uint256 value);
466 
467     /**
468      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
469      * a call to {approve}. `value` is the new allowance.
470      */
471     event Approval(
472         address indexed owner,
473         address indexed spender,
474         uint256 value
475     );
476 
477     /**
478      * @dev Returns the amount of tokens in existence.
479      */
480     function totalSupply() external view returns (uint256);
481 
482     /**
483      * @dev Returns the amount of tokens owned by `account`.
484      */
485     function balanceOf(address account) external view returns (uint256);
486 
487     /**
488      * @dev Moves `amount` tokens from the caller's account to `to`.
489      *
490      * Returns a boolean value indicating whether the operation succeeded.
491      *
492      * Emits a {Transfer} event.
493      */
494     function transfer(address to, uint256 amount) external returns (bool);
495 
496     /**
497      * @dev Returns the remaining number of tokens that `spender` will be
498      * allowed to spend on behalf of `owner` through {transferFrom}. This is
499      * zero by default.
500      *
501      * This value changes when {approve} or {transferFrom} are called.
502      */
503     function allowance(address owner, address spender)
504         external
505         view
506         returns (uint256);
507 
508     /**
509      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
510      *
511      * Returns a boolean value indicating whether the operation succeeded.
512      *
513      * IMPORTANT: Beware that changing an allowance with this method brings the risk
514      * that someone may use both the old and the new allowance by unfortunate
515      * transaction ordering. One possible solution to mitigate this race
516      * condition is to first reduce the spender's allowance to 0 and set the
517      * desired value afterwards:
518      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
519      *
520      * Emits an {Approval} event.
521      */
522     function approve(address spender, uint256 amount) external returns (bool);
523 
524     /**
525      * @dev Moves `amount` tokens from `from` to `to` using the
526      * allowance mechanism. `amount` is then deducted from the caller's
527      * allowance.
528      *
529      * Returns a boolean value indicating whether the operation succeeded.
530      *
531      * Emits a {Transfer} event.
532      */
533     function transferFrom(
534         address from,
535         address to,
536         uint256 amount
537     ) external returns (bool);
538 }
539 
540 /**
541  * @dev Interface for the optional metadata functions from the ERC20 standard.
542  *
543  * _Available since v4.1._
544  */
545 interface IERC20Metadata is IERC20 {
546     /**
547      * @dev Returns the name of the token.
548      */
549     function name() external view returns (string memory);
550 
551     /**
552      * @dev Returns the decimals places of the token.
553      */
554     function decimals() external view returns (uint8);
555 
556     /**
557      * @dev Returns the symbol of the token.
558      */
559     function symbol() external view returns (string memory);
560 }
561 
562 
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
619      * @dev See {IERC20-totalSupply}.
620      */
621     function totalSupply() external view virtual override returns (uint256) {
622         return _totalSupply;
623     }
624 
625     /**
626      * @dev See {IERC20-balanceOf}.
627      */
628     function balanceOf(address account)
629         public
630         view
631         virtual
632         override
633         returns (uint256)
634     {
635         return _balances[account];
636     }
637 
638     /**
639      * @dev Returns the number of decimals used to get its user representation.
640      * For example, if `decimals` equals `2`, a balance of `505` tokens should
641      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
642      *
643      * Tokens usually opt for a value of 18, imitating the relationship between
644      * Ether and Wei. This is the value {ERC20} uses, unless this function is
645      * overridden;
646      *
647      * NOTE: This information is only used for _display_ purposes: it in
648      * no way affects any of the arithmetic of the contract, including
649      * {IERC20-balanceOf} and {IERC20-transfer}.
650      */
651     function decimals() public view virtual override returns (uint8) {
652         return 18;
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
736      * @dev Atomically increases the allowance granted to `spender` by the caller.
737      *
738      * This is an alternative to {approve} that can be used as a mitigation for
739      * problems described in {IERC20-approve}.
740      *
741      * Emits an {Approval} event indicating the updated allowance.
742      *
743      * Requirements:
744      *
745      * - `spender` cannot be the zero address.
746      */
747     function increaseAllowance(address spender, uint256 addedValue)
748         external
749         virtual
750         returns (bool)
751     {
752         address owner = _msgSender();
753         _approve(owner, spender, allowance(owner, spender) + addedValue);
754         return true;
755     }
756 
757     /**
758      * @dev Atomically decreases the allowance granted to `spender` by the caller.
759      *
760      * This is an alternative to {approve} that can be used as a mitigation for
761      * problems described in {IERC20-approve}.
762      *
763      * Emits an {Approval} event indicating the updated allowance.
764      *
765      * Requirements:
766      *
767      * - `spender` cannot be the zero address.
768      * - `spender` must have allowance for the caller of at least
769      * `subtractedValue`.
770      */
771     function decreaseAllowance(address spender, uint256 subtractedValue)
772         external
773         virtual
774         returns (bool)
775     {
776         address owner = _msgSender();
777         uint256 currentAllowance = allowance(owner, spender);
778         require(
779             currentAllowance >= subtractedValue,
780             "ERC20: decreased allowance below zero"
781         );
782         unchecked {
783             _approve(owner, spender, currentAllowance - subtractedValue);
784         }
785 
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
835      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
836      *
837      * Does not update the allowance amount in case of infinite allowance.
838      * Revert if not enough allowance is available.
839      *
840      * Might emit an {Approval} event.
841      */
842     function _spendAllowance(
843         address owner,
844         address spender,
845         uint256 amount
846     ) internal virtual {
847         uint256 currentAllowance = allowance(owner, spender);
848         if (currentAllowance != type(uint256).max) {
849             require(
850                 currentAllowance >= amount,
851                 "ERC20: insufficient allowance"
852             );
853             unchecked {
854                 _approve(owner, spender, currentAllowance - amount);
855             }
856         }
857     }
858 
859     /**
860      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
861      *
862      * This internal function is equivalent to `approve`, and can be used to
863      * e.g. set automatic allowances for certain subsystems, etc.
864      *
865      * Emits an {Approval} event.
866      *
867      * Requirements:
868      *
869      * - `owner` cannot be the zero address.
870      * - `spender` cannot be the zero address.
871      */
872     function _approve(
873         address owner,
874         address spender,
875         uint256 amount
876     ) internal virtual {
877         require(owner != address(0), "ERC20: approve from the zero address");
878         require(spender != address(0), "ERC20: approve to the zero address");
879 
880         _allowances[owner][spender] = amount;
881         emit Approval(owner, spender, amount);
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
908 contract TOSHIKO is Ownable, ERC20 {
909     uint256 private _numTokensSellToAddToSwap = 100000 * (10**decimals());
910     bool inSwapAndLiquify;
911 
912     // 1% buy/sell tax
913     uint256 public constant buySellLiquidityTax = 1;
914     uint256 public constant sellDevelopmentTax = 1;
915     address public developmentWallet =
916         0xD6F1859294357290261ba9598d65D9883C8C9539;
917     address public constant  DEAD = address(0xdead);// burn LP to dead address    
918 
919     IUniswapV2Router02 public immutable uniswapV2Router;
920     address public immutable uniswapV2Pair;
921     mapping(address => bool) private _isExcludedFromFee;
922 
923     event SwapAndLiquify(
924         uint256 tokensSwapped,
925         uint256 ethReceived,
926         uint256 tokensIntoLiqudity
927     );
928 
929     modifier lockTheSwap() {
930         inSwapAndLiquify = true;
931         _;
932         inSwapAndLiquify = false;
933     }
934 
935     /**
936      * @dev Sets the values for {name} and {symbol}.
937      *
938      * The default value of {decimals} is 18. To select a different value for
939      * {decimals} you should overload it.
940      *
941      * All two of these values are immutable: they can only be set once during
942      * construction.
943      */
944     constructor() ERC20("Go-Sakuramachi", "TOSHIKO") {
945         _mint(msg.sender, (969369969369 * 10**decimals()));
946 
947         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
948             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
949         );
950         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
951             .createPair(address(this), _uniswapV2Router.WETH());
952 
953         uniswapV2Router = _uniswapV2Router;
954         _isExcludedFromFee[msg.sender] = true;
955         _isExcludedFromFee[address(uniswapV2Router)] = true;
956     }
957 
958     function _swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
959        
960         uint256 half = (contractTokenBalance / 2);
961         uint256 otherHalf = (contractTokenBalance - half);
962 
963         uint256 initialBalance = address(this).balance;
964 
965         _swapTokensForEth(half);
966 
967         uint256 newBalance = (address(this).balance - initialBalance);
968 
969         _addLiquidity(otherHalf, newBalance);
970 
971         emit SwapAndLiquify(half, newBalance, otherHalf);
972     }
973 
974     function excludeFromFee (address _user, bool value) external onlyOwner {
975         _isExcludedFromFee[_user]= value;
976     }
977 
978     function swapAndSendToMarketing (uint256 tokens) private lockTheSwap {
979         uint256 initialBalance = address(this).balance;
980         _swapTokensForEth(tokens);
981         uint256 newBalance = address(this).balance - initialBalance;
982         payable (developmentWallet).transfer(newBalance);
983 
984     }
985 
986     function _swapTokensForEth(uint256 tokenAmount) private {
987         address[] memory path = new address[](2);
988         path[0] = address(this);
989         path[1] = uniswapV2Router.WETH();
990 
991         _approve(address(this), address(uniswapV2Router), tokenAmount);
992 
993         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
994             tokenAmount,
995             0,
996             path,
997             address(this),
998             (block.timestamp + 300)
999         );
1000     }
1001 
1002     function _addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1003         _approve(address(this), address(uniswapV2Router), tokenAmount);
1004 
1005         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1006             address(this),
1007             tokenAmount,
1008             0,
1009             0,
1010             DEAD,
1011             block.timestamp
1012         );
1013     }
1014 
1015     /**
1016      * @dev Moves `amount` of tokens from `from` to `to`.
1017      *
1018      * This internal function is equivalent to {transfer}, and can be used to
1019      * e.g. implement automatic token fees, slashing mechanisms, etc.
1020      *
1021      * Emits a {Transfer} event.
1022      *
1023      * Requirements:
1024      *
1025      * - `from` cannot be the zero address.
1026      * - `to` cannot be the zero address.
1027      * - `from` must have a balance of at least `amount`.
1028      */
1029     function _transfer(
1030         address from,
1031         address to,
1032         uint256 amount
1033     ) internal override {
1034         require(from != address(0), "ERC20: transfer from the zero address");
1035         require(to != address(0), "ERC20: transfer to the zero address");
1036         require(
1037             balanceOf(from) >= amount,
1038             "ERC20: transfer amount exceeds balance"
1039         );
1040 
1041         uint256 transferAmount;
1042         if (
1043             (from == uniswapV2Pair || to == uniswapV2Pair) && !inSwapAndLiquify
1044         ) {
1045             // DEX transaction
1046             if (
1047                 from != uniswapV2Pair &&
1048                 ((balanceOf(address(this))) >= _numTokensSellToAddToSwap)
1049 
1050             ) {
1051                     uint256 totalfee = 2*(buySellLiquidityTax)+sellDevelopmentTax;
1052                     _numTokensSellToAddToSwap = balanceOf(address(this));
1053 
1054                     uint256 marketingTokens = _numTokensSellToAddToSwap * sellDevelopmentTax / totalfee;
1055                     swapAndSendToMarketing(marketingTokens); 
1056 
1057                     uint256 liquidityTokens = _numTokensSellToAddToSwap - marketingTokens;
1058 
1059                 // sell transaction with threshold to swap
1060                 _swapAndLiquify(liquidityTokens);
1061             }
1062             if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
1063                 // no tax on excluded account
1064                 transferAmount = amount;
1065             } else {
1066                 // 1% buy tax to LP, 2% sell tax (1% to LP, 1% to dev wallet)
1067                 uint256 liquidityAmount = ((amount * buySellLiquidityTax) /
1068                     100);
1069                 if (from == uniswapV2Pair) {
1070                     // buy transaction
1071                     transferAmount = amount - liquidityAmount;
1072                 } else {
1073                     // sell transaction
1074                     uint256 developmentAmount = ((amount * sellDevelopmentTax) /
1075                         100);
1076 
1077                     transferAmount =
1078                         amount -
1079                         liquidityAmount -
1080                         developmentAmount;
1081                     super._transfer(from, address(this), developmentAmount); // only on sell transaction
1082                 }
1083                 super._transfer(from, address(this), liquidityAmount); // on buy/sell both transactions
1084             }
1085         } else {
1086             // normal wallet transaction
1087             transferAmount = amount;
1088         }
1089         super._transfer(from, to, transferAmount);
1090     }
1091 
1092     receive() external payable {}
1093 }