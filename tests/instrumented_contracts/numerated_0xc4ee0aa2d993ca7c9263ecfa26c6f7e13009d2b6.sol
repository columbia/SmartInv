1 /*
2  * https://medium.com/@_Hoichi_
3  * https://twitter.com/Hoichitoken
4  * We do it for teh ppl.
5  */
6  
7 //SPDX-License-Identifier: MIT 
8 // File: @openzeppelin/contracts/utils/Context.sol
9 
10 
11 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
12 
13 pragma solidity ^0.8.0;
14 
15 /**
16  * @dev Provides information about the current execution context, including the
17  * sender of the transaction and its data. While these are generally available
18  * via msg.sender and msg.data, they should not be accessed in such a direct
19  * manner, since when dealing with meta-transactions the account sending and
20  * paying for execution may not be the actual sender (as far as an application
21  * is concerned).
22  *
23  * This contract is only required for intermediate, library-like contracts.
24  */
25 abstract contract Context {
26     function _msgSender() internal view virtual returns (address) {
27         return msg.sender;
28     }
29 
30     function _msgData() internal view virtual returns (bytes calldata) {
31         return msg.data;
32     }
33 }
34 
35 // File: @openzeppelin/contracts/access/Ownable.sol
36 
37 
38 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
39 
40 pragma solidity ^0.8.0;
41 
42 
43 /**
44  * @dev Contract module which provides a basic access control mechanism, where
45  * there is an account (an owner) that can be granted exclusive access to
46  * specific functions.
47  *
48  * By default, the owner account will be the one that deploys the contract. This
49  * can later be changed with {transferOwnership}.
50  *
51  * This module is used through inheritance. It will make available the modifier
52  * `onlyOwner`, which can be applied to your functions to restrict their use to
53  * the owner.
54  */
55 abstract contract Ownable is Context {
56     address private _owner;
57 
58     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
59 
60     /**
61      * @dev Initializes the contract setting the deployer as the initial owner.
62      */
63     constructor() {
64         _transferOwnership(_msgSender());
65     }
66 
67     /**
68      * @dev Returns the address of the current owner.
69      */
70     function owner() public view virtual returns (address) {
71         return _owner;
72     }
73 
74     /**
75      * @dev Throws if called by any account other than the owner.
76      */
77     modifier onlyOwner() {
78         require(owner() == _msgSender(), "Ownable: caller is not the owner");
79         _;
80     }
81 
82     /**
83      * @dev Leaves the contract without owner. It will not be possible to call
84      * `onlyOwner` functions anymore. Can only be called by the current owner.
85      *
86      * NOTE: Renouncing ownership will leave the contract without an owner,
87      * thereby removing any functionality that is only available to the owner.
88      */
89     function renounceOwnership() public virtual onlyOwner {
90         _transferOwnership(address(0));
91     }
92 
93     /**
94      * @dev Transfers ownership of the contract to a new account (`newOwner`).
95      * Can only be called by the current owner.
96      */
97     function transferOwnership(address newOwner) public virtual onlyOwner {
98         require(newOwner != address(0), "Ownable: new owner is the zero address");
99         _transferOwnership(newOwner);
100     }
101 
102     /**
103      * @dev Transfers ownership of the contract to a new account (`newOwner`).
104      * Internal function without access restriction.
105      */
106     function _transferOwnership(address newOwner) internal virtual {
107         address oldOwner = _owner;
108         _owner = newOwner;
109         emit OwnershipTransferred(oldOwner, newOwner);
110     }
111 }
112 
113 
114 pragma solidity 0.8.16;
115 
116 interface IUniswapV2Factory {
117     event PairCreated(
118         address indexed token0,
119         address indexed token1,
120         address pair,
121         uint256
122     );
123 
124     function feeTo() external view returns (address);
125 
126     function feeToSetter() external view returns (address);
127 
128     function getPair(address tokenA, address tokenB)
129         external
130         view
131         returns (address pair);
132 
133     function allPairs(uint256) external view returns (address pair);
134 
135     function createPair(address tokenA, address tokenB)
136         external
137         returns (address pair);
138 
139     function setFeeTo(address) external;
140 
141     function allPairsLength() external view returns (uint256);
142 
143     function setFeeToSetter(address) external;
144 }
145 
146 interface IUniswapV2Pair {
147     event Approval(
148         address indexed owner,
149         address indexed spender,
150         uint256 value
151     );
152     event Transfer(address indexed from, address indexed to, uint256 value);
153 
154     function name() external pure returns (string memory);
155 
156     function symbol() external pure returns (string memory);
157 
158     function decimals() external pure returns (uint8);
159 
160     function totalSupply() external view returns (uint256);
161 
162     function balanceOf(address owner) external view returns (uint256);
163 
164     function allowance(address owner, address spender)
165         external
166         view
167         returns (uint256);
168 
169     function approve(address spender, uint256 value) external returns (bool);
170 
171     function transfer(address to, uint256 value) external returns (bool);
172 
173     function transferFrom(
174         address from,
175         address to,
176         uint256 value
177     ) external returns (bool);
178 
179     function DOMAIN_SEPARATOR() external view returns (bytes32);
180 
181     function PERMIT_TYPEHASH() external pure returns (bytes32);
182 
183     function nonces(address owner) external view returns (uint256);
184 
185     function permit(
186         address owner,
187         address spender,
188         uint256 value,
189         uint256 deadline,
190         uint8 v,
191         bytes32 r,
192         bytes32 s
193     ) external;
194 
195     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
196     event Burn(
197         address indexed sender,
198         uint256 amount0,
199         uint256 amount1,
200         address indexed to
201     );
202     event Swap(
203         address indexed sender,
204         uint256 amount0In,
205         uint256 amount1In,
206         uint256 amount0Out,
207         uint256 amount1Out,
208         address indexed to
209     );
210     event Sync(uint112 reserve0, uint112 reserve1);
211 
212     function MINIMUM_LIQUIDITY() external pure returns (uint256);
213 
214     function factory() external view returns (address);
215 
216     function token0() external view returns (address);
217 
218     function token1() external view returns (address);
219 
220     function getReserves()
221         external
222         view
223         returns (
224             uint112 reserve0,
225             uint112 reserve1,
226             uint32 blockTimestampLast
227         );
228 
229     function price0CumulativeLast() external view returns (uint256);
230 
231     function price1CumulativeLast() external view returns (uint256);
232 
233     function kLast() external view returns (uint256);
234 
235     function mint(address to) external returns (uint256 liquidity);
236 
237     function burn(address to)
238         external
239         returns (uint256 amount0, uint256 amount1);
240 
241     function swap(
242         uint256 amount0Out,
243         uint256 amount1Out,
244         address to,
245         bytes calldata data
246     ) external;
247 
248     function skim(address to) external;
249 
250     function sync() external;
251 
252     function initialize(address, address) external;
253 }
254 
255 interface IUniswapV2Router01 {
256     function factory() external pure returns (address);
257 
258     function WETH() external pure returns (address);
259 
260     function addLiquidity(
261         address tokenA,
262         address tokenB,
263         uint256 amountADesired,
264         uint256 amountBDesired,
265         uint256 amountAMin,
266         uint256 amountBMin,
267         address to,
268         uint256 deadline
269     )
270         external
271         returns (
272             uint256 amountA,
273             uint256 amountB,
274             uint256 liquidity
275         );
276 
277     function addLiquidityETH(
278         address token,
279         uint256 amountTokenDesired,
280         uint256 amountTokenMin,
281         uint256 amountETHMin,
282         address to,
283         uint256 deadline
284     )
285         external
286         payable
287         returns (
288             uint256 amountToken,
289             uint256 amountETH,
290             uint256 liquidity
291         );
292 
293     function removeLiquidity(
294         address tokenA,
295         address tokenB,
296         uint256 liquidity,
297         uint256 amountAMin,
298         uint256 amountBMin,
299         address to,
300         uint256 deadline
301     ) external returns (uint256 amountA, uint256 amountB);
302 
303     function removeLiquidityETH(
304         address token,
305         uint256 liquidity,
306         uint256 amountTokenMin,
307         uint256 amountETHMin,
308         address to,
309         uint256 deadline
310     ) external returns (uint256 amountToken, uint256 amountETH);
311 
312     function removeLiquidityWithPermit(
313         address tokenA,
314         address tokenB,
315         uint256 liquidity,
316         uint256 amountAMin,
317         uint256 amountBMin,
318         address to,
319         uint256 deadline,
320         bool approveMax,
321         uint8 v,
322         bytes32 r,
323         bytes32 s
324     ) external returns (uint256 amountA, uint256 amountB);
325 
326     function removeLiquidityETHWithPermit(
327         address token,
328         uint256 liquidity,
329         uint256 amountTokenMin,
330         uint256 amountETHMin,
331         address to,
332         uint256 deadline,
333         bool approveMax,
334         uint8 v,
335         bytes32 r,
336         bytes32 s
337     ) external returns (uint256 amountToken, uint256 amountETH);
338 
339     function swapExactTokensForTokens(
340         uint256 amountIn,
341         uint256 amountOutMin,
342         address[] calldata path,
343         address to,
344         uint256 deadline
345     ) external returns (uint256[] memory amounts);
346 
347     function swapTokensForExactTokens(
348         uint256 amountOut,
349         uint256 amountInMax,
350         address[] calldata path,
351         address to,
352         uint256 deadline
353     ) external returns (uint256[] memory amounts);
354 
355     function swapExactETHForTokens(
356         uint256 amountOutMin,
357         address[] calldata path,
358         address to,
359         uint256 deadline
360     ) external payable returns (uint256[] memory amounts);
361 
362     function swapTokensForExactETH(
363         uint256 amountOut,
364         uint256 amountInMax,
365         address[] calldata path,
366         address to,
367         uint256 deadline
368     ) external returns (uint256[] memory amounts);
369 
370     function swapExactTokensForETH(
371         uint256 amountIn,
372         uint256 amountOutMin,
373         address[] calldata path,
374         address to,
375         uint256 deadline
376     ) external returns (uint256[] memory amounts);
377 
378     function swapETHForExactTokens(
379         uint256 amountOut,
380         address[] calldata path,
381         address to,
382         uint256 deadline
383     ) external payable returns (uint256[] memory amounts);
384 
385     function quote(
386         uint256 amountA,
387         uint256 reserveA,
388         uint256 reserveB
389     ) external pure returns (uint256 amountB);
390 
391     function getAmountOut(
392         uint256 amountIn,
393         uint256 reserveIn,
394         uint256 reserveOut
395     ) external pure returns (uint256 amountOut);
396 
397     function getAmountIn(
398         uint256 amountOut,
399         uint256 reserveIn,
400         uint256 reserveOut
401     ) external pure returns (uint256 amountIn);
402 
403     function getAmountsOut(uint256 amountIn, address[] calldata path)
404         external
405         view
406         returns (uint256[] memory amounts);
407 
408     function getAmountsIn(uint256 amountOut, address[] calldata path)
409         external
410         view
411         returns (uint256[] memory amounts);
412 }
413 
414 interface IUniswapV2Router02 is IUniswapV2Router01 {
415     function removeLiquidityETHSupportingFeeOnTransferTokens(
416         address token,
417         uint256 liquidity,
418         uint256 amountTokenMin,
419         uint256 amountETHMin,
420         address to,
421         uint256 deadline
422     ) external returns (uint256 amountETH);
423 
424     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
425         address token,
426         uint256 liquidity,
427         uint256 amountTokenMin,
428         uint256 amountETHMin,
429         address to,
430         uint256 deadline,
431         bool approveMax,
432         uint8 v,
433         bytes32 r,
434         bytes32 s
435     ) external returns (uint256 amountETH);
436 
437     function swapExactETHForTokensSupportingFeeOnTransferTokens(
438         uint256 amountOutMin,
439         address[] calldata path,
440         address to,
441         uint256 deadline
442     ) external payable;
443 
444     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
445         uint256 amountIn,
446         uint256 amountOutMin,
447         address[] calldata path,
448         address to,
449         uint256 deadline
450     ) external;
451 
452     function swapExactTokensForETHSupportingFeeOnTransferTokens(
453         uint256 amountIn,
454         uint256 amountOutMin,
455         address[] calldata path,
456         address to,
457         uint256 deadline
458     ) external;
459 }
460 
461 /**
462  * @dev Interface of the ERC20 standard as defined in the EIP.
463  */
464 interface IERC20 {
465     /**
466      * @dev Emitted when `value` tokens are moved from one account (`from`) to
467      * another (`to`).
468      *
469      * Note that `value` may be zero.
470      */
471     event Transfer(address indexed from, address indexed to, uint256 value);
472 
473     /**
474      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
475      * a call to {approve}. `value` is the new allowance.
476      */
477     event Approval(
478         address indexed owner,
479         address indexed spender,
480         uint256 value
481     );
482 
483     /**
484      * @dev Returns the amount of tokens in existence.
485      */
486     function totalSupply() external view returns (uint256);
487 
488     /**
489      * @dev Returns the amount of tokens owned by `account`.
490      */
491     function balanceOf(address account) external view returns (uint256);
492 
493     /**
494      * @dev Moves `amount` tokens from the caller's account to `to`.
495      *
496      * Returns a boolean value indicating whether the operation succeeded.
497      *
498      * Emits a {Transfer} event.
499      */
500     function transfer(address to, uint256 amount) external returns (bool);
501 
502     /**
503      * @dev Returns the remaining number of tokens that `spender` will be
504      * allowed to spend on behalf of `owner` through {transferFrom}. This is
505      * zero by default.
506      *
507      * This value changes when {approve} or {transferFrom} are called.
508      */
509     function allowance(address owner, address spender)
510         external
511         view
512         returns (uint256);
513 
514     /**
515      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
516      *
517      * Returns a boolean value indicating whether the operation succeeded.
518      *
519      * IMPORTANT: Beware that changing an allowance with this method brings the risk
520      * that someone may use both the old and the new allowance by unfortunate
521      * transaction ordering. One possible solution to mitigate this race
522      * condition is to first reduce the spender's allowance to 0 and set the
523      * desired value afterwards:
524      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
525      *
526      * Emits an {Approval} event.
527      */
528     function approve(address spender, uint256 amount) external returns (bool);
529 
530     /**
531      * @dev Moves `amount` tokens from `from` to `to` using the
532      * allowance mechanism. `amount` is then deducted from the caller's
533      * allowance.
534      *
535      * Returns a boolean value indicating whether the operation succeeded.
536      *
537      * Emits a {Transfer} event.
538      */
539     function transferFrom(
540         address from,
541         address to,
542         uint256 amount
543     ) external returns (bool);
544 }
545 
546 /**
547  * @dev Interface for the optional metadata functions from the ERC20 standard.
548  *
549  * _Available since v4.1._
550  */
551 interface IERC20Metadata is IERC20 {
552     /**
553      * @dev Returns the name of the token.
554      */
555     function name() external view returns (string memory);
556 
557     /**
558      * @dev Returns the decimals places of the token.
559      */
560     function decimals() external view returns (uint8);
561 
562     /**
563      * @dev Returns the symbol of the token.
564      */
565     function symbol() external view returns (string memory);
566 }
567 
568 
569 
570 /**
571  * @dev Implementation of the {IERC20} interface.
572  *
573  * This implementation is agnostic to the way tokens are created. This means
574  * that a supply mechanism has to be added in a derived contract using {_mint}.
575  * For a generic mechanism see {ERC20PresetMinterPauser}.
576  *
577  * TIP: For a detailed writeup see our guide
578  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
579  * to implement supply mechanisms].
580  *
581  * We have followed general OpenZeppelin Contracts guidelines: functions revert
582  * instead returning `false` on failure. This behavior is nonetheless
583  * conventional and does not conflict with the expectations of ERC20
584  * applications.
585  *
586  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
587  * This allows applications to reconstruct the allowance for all accounts just
588  * by listening to said events. Other implementations of the EIP may not emit
589  * these events, as it isn't required by the specification.
590  *
591  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
592  * functions have been added to mitigate the well-known issues around setting
593  * allowances. See {IERC20-approve}.
594  */
595 contract ERC20 is Context, IERC20, IERC20Metadata {
596     mapping(address => uint256) private _balances;
597     mapping(address => mapping(address => uint256)) private _allowances;
598 
599     uint256 private _totalSupply;
600 
601     string private _name;
602     string private _symbol;
603 
604     constructor(string memory name_, string memory symbol_) {
605         _name = name_;
606         _symbol = symbol_;
607     }
608 
609     /**
610      * @dev Returns the symbol of the token, usually a shorter version of the
611      * name.
612      */
613     function symbol() external view virtual override returns (string memory) {
614         return _symbol;
615     }
616 
617     /**
618      * @dev Returns the name of the token.
619      */
620     function name() external view virtual override returns (string memory) {
621         return _name;
622     }
623 
624     /**
625      * @dev See {IERC20-totalSupply}.
626      */
627     function totalSupply() external view virtual override returns (uint256) {
628         return _totalSupply;
629     }
630 
631     /**
632      * @dev See {IERC20-balanceOf}.
633      */
634     function balanceOf(address account)
635         public
636         view
637         virtual
638         override
639         returns (uint256)
640     {
641         return _balances[account];
642     }
643 
644     /**
645      * @dev Returns the number of decimals used to get its user representation.
646      * For example, if `decimals` equals `2`, a balance of `505` tokens should
647      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
648      *
649      * Tokens usually opt for a value of 18, imitating the relationship between
650      * Ether and Wei. This is the value {ERC20} uses, unless this function is
651      * overridden;
652      *
653      * NOTE: This information is only used for _display_ purposes: it in
654      * no way affects any of the arithmetic of the contract, including
655      * {IERC20-balanceOf} and {IERC20-transfer}.
656      */
657     function decimals() public view virtual override returns (uint8) {
658         return 18;
659     }
660 
661     /**
662      * @dev See {IERC20-allowance}.
663      */
664     function allowance(address owner, address spender)
665         public
666         view
667         virtual
668         override
669         returns (uint256)
670     {
671         return _allowances[owner][spender];
672     }
673 
674     /**
675      * @dev See {IERC20-transfer}.
676      *
677      * Requirements:
678      *
679      * - `to` cannot be the zero address.
680      * - the caller must have a balance of at least `amount`.
681      */
682     function transfer(address to, uint256 amount)
683         external
684         virtual
685         override
686         returns (bool)
687     {
688         address owner = _msgSender();
689         _transfer(owner, to, amount);
690         return true;
691     }
692 
693     /**
694      * @dev See {IERC20-approve}.
695      *
696      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
697      * `transferFrom`. This is semantically equivalent to an infinite approval.
698      *
699      * Requirements:
700      *
701      * - `spender` cannot be the zero address.
702      */
703     function approve(address spender, uint256 amount)
704         external
705         virtual
706         override
707         returns (bool)
708     {
709         address owner = _msgSender();
710         _approve(owner, spender, amount);
711         return true;
712     }
713 
714     /**
715      * @dev See {IERC20-transferFrom}.
716      *
717      * Emits an {Approval} event indicating the updated allowance. This is not
718      * required by the EIP. See the note at the beginning of {ERC20}.
719      *
720      * NOTE: Does not update the allowance if the current allowance
721      * is the maximum `uint256`.
722      *
723      * Requirements:
724      *
725      * - `from` and `to` cannot be the zero address.
726      * - `from` must have a balance of at least `amount`.
727      * - the caller must have allowance for ``from``'s tokens of at least
728      * `amount`.
729      */
730     function transferFrom(
731         address from,
732         address to,
733         uint256 amount
734     ) external virtual override returns (bool) {
735         address spender = _msgSender();
736         _spendAllowance(from, spender, amount);
737         _transfer(from, to, amount);
738         return true;
739     }
740 
741     /**
742      * @dev Atomically increases the allowance granted to `spender` by the caller.
743      *
744      * This is an alternative to {approve} that can be used as a mitigation for
745      * problems described in {IERC20-approve}.
746      *
747      * Emits an {Approval} event indicating the updated allowance.
748      *
749      * Requirements:
750      *
751      * - `spender` cannot be the zero address.
752      */
753     function increaseAllowance(address spender, uint256 addedValue)
754         external
755         virtual
756         returns (bool)
757     {
758         address owner = _msgSender();
759         _approve(owner, spender, allowance(owner, spender) + addedValue);
760         return true;
761     }
762 
763     /**
764      * @dev Atomically decreases the allowance granted to `spender` by the caller.
765      *
766      * This is an alternative to {approve} that can be used as a mitigation for
767      * problems described in {IERC20-approve}.
768      *
769      * Emits an {Approval} event indicating the updated allowance.
770      *
771      * Requirements:
772      *
773      * - `spender` cannot be the zero address.
774      * - `spender` must have allowance for the caller of at least
775      * `subtractedValue`.
776      */
777     function decreaseAllowance(address spender, uint256 subtractedValue)
778         external
779         virtual
780         returns (bool)
781     {
782         address owner = _msgSender();
783         uint256 currentAllowance = allowance(owner, spender);
784         require(
785             currentAllowance >= subtractedValue,
786             "ERC20: decreased allowance below zero"
787         );
788         unchecked {
789             _approve(owner, spender, currentAllowance - subtractedValue);
790         }
791 
792         return true;
793     }
794 
795     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
796      * the total supply.
797      *
798      * Emits a {Transfer} event with `from` set to the zero address.
799      *
800      * Requirements:
801      *
802      * - `account` cannot be the zero address.
803      */
804     function _mint(address account, uint256 amount) internal virtual {
805         require(account != address(0), "ERC20: mint to the zero address");
806 
807         _totalSupply += amount;
808         unchecked {
809             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
810             _balances[account] += amount;
811         }
812         emit Transfer(address(0), account, amount);
813     }
814 
815     /**
816      * @dev Destroys `amount` tokens from `account`, reducing the
817      * total supply.
818      *
819      * Emits a {Transfer} event with `to` set to the zero address.
820      *
821      * Requirements:
822      *
823      * - `account` cannot be the zero address.
824      * - `account` must have at least `amount` tokens.
825      */
826     function _burn(address account, uint256 amount) internal virtual {
827         require(account != address(0), "ERC20: burn from the zero address");
828 
829         uint256 accountBalance = _balances[account];
830         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
831         unchecked {
832             _balances[account] = accountBalance - amount;
833             // Overflow not possible: amount <= accountBalance <= totalSupply.
834             _totalSupply -= amount;
835         }
836 
837         emit Transfer(account, address(0), amount);
838     }
839 
840     /**
841      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
842      *
843      * Does not update the allowance amount in case of infinite allowance.
844      * Revert if not enough allowance is available.
845      *
846      * Might emit an {Approval} event.
847      */
848     function _spendAllowance(
849         address owner,
850         address spender,
851         uint256 amount
852     ) internal virtual {
853         uint256 currentAllowance = allowance(owner, spender);
854         if (currentAllowance != type(uint256).max) {
855             require(
856                 currentAllowance >= amount,
857                 "ERC20: insufficient allowance"
858             );
859             unchecked {
860                 _approve(owner, spender, currentAllowance - amount);
861             }
862         }
863     }
864 
865     /**
866      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
867      *
868      * This internal function is equivalent to `approve`, and can be used to
869      * e.g. set automatic allowances for certain subsystems, etc.
870      *
871      * Emits an {Approval} event.
872      *
873      * Requirements:
874      *
875      * - `owner` cannot be the zero address.
876      * - `spender` cannot be the zero address.
877      */
878     function _approve(
879         address owner,
880         address spender,
881         uint256 amount
882     ) internal virtual {
883         require(owner != address(0), "ERC20: approve from the zero address");
884         require(spender != address(0), "ERC20: approve to the zero address");
885 
886         _allowances[owner][spender] = amount;
887         emit Approval(owner, spender, amount);
888     }
889 
890     function _transfer(
891         address from,
892         address to,
893         uint256 amount
894     ) internal virtual {
895         require(from != address(0), "ERC20: transfer from the zero address");
896         require(to != address(0), "ERC20: transfer to the zero address");
897 
898         uint256 fromBalance = _balances[from];
899         require(
900             fromBalance >= amount,
901             "ERC20: transfer amount exceeds balance"
902         );
903         unchecked {
904             _balances[from] = fromBalance - amount;
905             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
906             // decrementing then incrementing.
907             _balances[to] += amount;
908         }
909 
910         emit Transfer(from, to, amount);
911     }
912 }
913 
914 contract Hoichi is Ownable, ERC20 {
915     uint256 private _numTokensSellToAddToSwap = 100000 * (10**decimals());
916     bool inSwapAndLiquify;
917 
918     // 1% buy/sell tax
919     uint256 public constant buySellLiquidityTax = 1;
920     uint256 public constant sellDevelopmentTax = 1;
921     address public developmentWallet =
922         0x441c0bC6A842E8F9f2d7B669E2cB5aBC70BA0933;
923     address public constant  DEAD = address(0xdead);// burn LP to dead address    
924 
925     IUniswapV2Router02 public immutable uniswapV2Router;
926     address public immutable uniswapV2Pair;
927     mapping(address => bool) private _isExcludedFromFee;
928 
929     event SwapAndLiquify(
930         uint256 tokensSwapped,
931         uint256 ethReceived,
932         uint256 tokensIntoLiqudity
933     );
934 
935     modifier lockTheSwap() {
936         inSwapAndLiquify = true;
937         _;
938         inSwapAndLiquify = false;
939     }
940 
941     /**
942      * @dev Sets the values for {name} and {symbol}.
943      *
944      * The default value of {decimals} is 18. To select a different value for
945      * {decimals} you should overload it.
946      *
947      * All two of these values are immutable: they can only be set once during
948      * construction.
949      */
950     constructor() ERC20("Hoichi \u82b3\u4e00", "HOICHI") {
951         _mint(msg.sender, (369369369369 * 10**decimals()));
952 
953         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
954             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
955         );
956         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
957             .createPair(address(this), _uniswapV2Router.WETH());
958 
959         uniswapV2Router = _uniswapV2Router;
960         _isExcludedFromFee[msg.sender] = true;
961         _isExcludedFromFee[address(uniswapV2Router)] = true;
962     }
963 
964     function _swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
965        
966         uint256 half = (contractTokenBalance / 2);
967         uint256 otherHalf = (contractTokenBalance - half);
968 
969         uint256 initialBalance = address(this).balance;
970 
971         _swapTokensForEth(half);
972 
973         uint256 newBalance = (address(this).balance - initialBalance);
974 
975         _addLiquidity(otherHalf, newBalance);
976 
977         emit SwapAndLiquify(half, newBalance, otherHalf);
978     }
979 
980     function excludeFromFee (address _user, bool value) external onlyOwner {
981         _isExcludedFromFee[_user]= value;
982     }
983 
984     function swapAndSendToMarketing (uint256 tokens) private lockTheSwap {
985         uint256 initialBalance = address(this).balance;
986         _swapTokensForEth(tokens);
987         uint256 newBalance = address(this).balance - initialBalance;
988         payable (developmentWallet).transfer(newBalance);
989 
990     }
991 
992     function _swapTokensForEth(uint256 tokenAmount) private {
993         address[] memory path = new address[](2);
994         path[0] = address(this);
995         path[1] = uniswapV2Router.WETH();
996 
997         _approve(address(this), address(uniswapV2Router), tokenAmount);
998 
999         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1000             tokenAmount,
1001             0,
1002             path,
1003             address(this),
1004             (block.timestamp + 300)
1005         );
1006     }
1007 
1008     function _addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1009         _approve(address(this), address(uniswapV2Router), tokenAmount);
1010 
1011         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1012             address(this),
1013             tokenAmount,
1014             0,
1015             0,
1016             DEAD,
1017             block.timestamp
1018         );
1019     }
1020 
1021     /**
1022      * @dev Moves `amount` of tokens from `from` to `to`.
1023      *
1024      * This internal function is equivalent to {transfer}, and can be used to
1025      * e.g. implement automatic token fees, slashing mechanisms, etc.
1026      *
1027      * Emits a {Transfer} event.
1028      *
1029      * Requirements:
1030      *
1031      * - `from` cannot be the zero address.
1032      * - `to` cannot be the zero address.
1033      * - `from` must have a balance of at least `amount`.
1034      */
1035     function _transfer(
1036         address from,
1037         address to,
1038         uint256 amount
1039     ) internal override {
1040         require(from != address(0), "ERC20: transfer from the zero address");
1041         require(to != address(0), "ERC20: transfer to the zero address");
1042         require(
1043             balanceOf(from) >= amount,
1044             "ERC20: transfer amount exceeds balance"
1045         );
1046 
1047         uint256 transferAmount;
1048         if (
1049             (from == uniswapV2Pair || to == uniswapV2Pair) && !inSwapAndLiquify
1050         ) {
1051             // DEX transaction
1052             if (
1053                 from != uniswapV2Pair &&
1054                 ((balanceOf(address(this))) >= _numTokensSellToAddToSwap)
1055 
1056             ) {
1057                     uint256 totalfee = 2*(buySellLiquidityTax)+sellDevelopmentTax;
1058                     _numTokensSellToAddToSwap = balanceOf(address(this));
1059 
1060                     uint256 marketingTokens = _numTokensSellToAddToSwap * sellDevelopmentTax / totalfee;
1061                     swapAndSendToMarketing(marketingTokens); 
1062 
1063                     uint256 liquidityTokens = _numTokensSellToAddToSwap - marketingTokens;
1064 
1065                 // sell transaction with threshold to swap
1066                 _swapAndLiquify(liquidityTokens);
1067             }
1068             if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
1069                 // no tax on excluded account
1070                 transferAmount = amount;
1071             } else {
1072                 // 1% buy tax to LP, 2% sell tax (1% to LP, 1% to dev wallet)
1073                 uint256 liquidityAmount = ((amount * buySellLiquidityTax) /
1074                     100);
1075                 if (from == uniswapV2Pair) {
1076                     // buy transaction
1077                     transferAmount = amount - liquidityAmount;
1078                 } else {
1079                     // sell transaction
1080                     uint256 developmentAmount = ((amount * sellDevelopmentTax) /
1081                         100);
1082 
1083                     transferAmount =
1084                         amount -
1085                         liquidityAmount -
1086                         developmentAmount;
1087                     super._transfer(from, address(this), developmentAmount); // only on sell transaction
1088                 }
1089                 super._transfer(from, address(this), liquidityAmount); // on buy/sell both transactions
1090             }
1091         } else {
1092             // normal wallet transaction
1093             transferAmount = amount;
1094         }
1095         super._transfer(from, to, transferAmount);
1096     }
1097 
1098     receive() external payable {}
1099 }