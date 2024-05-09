1 /*
2 
3 * revoAI - Artificial Intelligence Revolution
4 
5 * revoAI Bot - https://t.me/revoAI_Bot
6 
7 Website: https://revoai.net/
8 Documents: https://docs.revoai.net/
9 Telegram Channel: https://t.me/revoAIchannel
10 Telegram Group: https://t.me/revoAI
11 Twitter: https://twitter.com/revoAI_net
12 Discord: https://discord.gg/kfXJqw8XvX
13 */
14 
15 // SPDX-License-Identifier: MIT
16 
17 pragma solidity 0.8.16;
18 
19 interface IUniswapV2Factory {
20     event PairCreated(
21         address indexed token0,
22         address indexed token1,
23         address pair,
24         uint256
25     );
26 
27     function feeTo() external view returns (address);
28 
29     function feeToSetter() external view returns (address);
30 
31     function allPairsLength() external view returns (uint256);
32 
33     function getPair(address tokenA, address tokenB)
34         external
35         view
36         returns (address pair);
37 
38     function allPairs(uint256) external view returns (address pair);
39 
40     function createPair(address tokenA, address tokenB)
41         external
42         returns (address pair);
43 
44     function setFeeTo(address) external;
45 
46     function setFeeToSetter(address) external;
47 }
48 
49 interface IUniswapV2Pair {
50     event Approval(
51         address indexed owner,
52         address indexed spender,
53         uint256 value
54     );
55     event Transfer(address indexed from, address indexed to, uint256 value);
56 
57     function name() external pure returns (string memory);
58 
59     function symbol() external pure returns (string memory);
60 
61     function decimals() external pure returns (uint8);
62 
63     function totalSupply() external view returns (uint256);
64 
65     function balanceOf(address owner) external view returns (uint256);
66 
67     function allowance(address owner, address spender)
68         external
69         view
70         returns (uint256);
71 
72     function approve(address spender, uint256 value) external returns (bool);
73 
74     function transfer(address to, uint256 value) external returns (bool);
75 
76     function transferFrom(
77         address from,
78         address to,
79         uint256 value
80     ) external returns (bool);
81 
82     function DOMAIN_SEPARATOR() external view returns (bytes32);
83 
84     function PERMIT_TYPEHASH() external pure returns (bytes32);
85 
86     function nonces(address owner) external view returns (uint256);
87 
88     function permit(
89         address owner,
90         address spender,
91         uint256 value,
92         uint256 deadline,
93         uint8 v,
94         bytes32 r,
95         bytes32 s
96     ) external;
97 
98     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
99     event Burn(
100         address indexed sender,
101         uint256 amount0,
102         uint256 amount1,
103         address indexed to
104     );
105     event Swap(
106         address indexed sender,
107         uint256 amount0In,
108         uint256 amount1In,
109         uint256 amount0Out,
110         uint256 amount1Out,
111         address indexed to
112     );
113     event Sync(uint112 reserve0, uint112 reserve1);
114 
115     function MINIMUM_LIQUIDITY() external pure returns (uint256);
116 
117     function factory() external view returns (address);
118 
119     function token0() external view returns (address);
120 
121     function token1() external view returns (address);
122 
123     function getReserves()
124         external
125         view
126         returns (
127             uint112 reserve0,
128             uint112 reserve1,
129             uint32 blockTimestampLast
130         );
131 
132     function price0CumulativeLast() external view returns (uint256);
133 
134     function price1CumulativeLast() external view returns (uint256);
135 
136     function kLast() external view returns (uint256);
137 
138     function mint(address to) external returns (uint256 liquidity);
139 
140     function burn(address to)
141         external
142         returns (uint256 amount0, uint256 amount1);
143 
144     function swap(
145         uint256 amount0Out,
146         uint256 amount1Out,
147         address to,
148         bytes calldata data
149     ) external;
150 
151     function skim(address to) external;
152 
153     function sync() external;
154 
155     function initialize(address, address) external;
156 }
157 
158 interface IUniswapV2Router01 {
159     function factory() external pure returns (address);
160 
161     function WETH() external pure returns (address);
162 
163     function addLiquidity(
164         address tokenA,
165         address tokenB,
166         uint256 amountADesired,
167         uint256 amountBDesired,
168         uint256 amountAMin,
169         uint256 amountBMin,
170         address to,
171         uint256 deadline
172     )
173         external
174         returns (
175             uint256 amountA,
176             uint256 amountB,
177             uint256 liquidity
178         );
179 
180     function addLiquidityETH(
181         address token,
182         uint256 amountTokenDesired,
183         uint256 amountTokenMin,
184         uint256 amountETHMin,
185         address to,
186         uint256 deadline
187     )
188         external
189         payable
190         returns (
191             uint256 amountToken,
192             uint256 amountETH,
193             uint256 liquidity
194         );
195 
196     function removeLiquidity(
197         address tokenA,
198         address tokenB,
199         uint256 liquidity,
200         uint256 amountAMin,
201         uint256 amountBMin,
202         address to,
203         uint256 deadline
204     ) external returns (uint256 amountA, uint256 amountB);
205 
206     function removeLiquidityETH(
207         address token,
208         uint256 liquidity,
209         uint256 amountTokenMin,
210         uint256 amountETHMin,
211         address to,
212         uint256 deadline
213     ) external returns (uint256 amountToken, uint256 amountETH);
214 
215     function removeLiquidityWithPermit(
216         address tokenA,
217         address tokenB,
218         uint256 liquidity,
219         uint256 amountAMin,
220         uint256 amountBMin,
221         address to,
222         uint256 deadline,
223         bool approveMax,
224         uint8 v,
225         bytes32 r,
226         bytes32 s
227     ) external returns (uint256 amountA, uint256 amountB);
228 
229     function removeLiquidityETHWithPermit(
230         address token,
231         uint256 liquidity,
232         uint256 amountTokenMin,
233         uint256 amountETHMin,
234         address to,
235         uint256 deadline,
236         bool approveMax,
237         uint8 v,
238         bytes32 r,
239         bytes32 s
240     ) external returns (uint256 amountToken, uint256 amountETH);
241 
242     function swapExactTokensForTokens(
243         uint256 amountIn,
244         uint256 amountOutMin,
245         address[] calldata path,
246         address to,
247         uint256 deadline
248     ) external returns (uint256[] memory amounts);
249 
250     function swapTokensForExactTokens(
251         uint256 amountOut,
252         uint256 amountInMax,
253         address[] calldata path,
254         address to,
255         uint256 deadline
256     ) external returns (uint256[] memory amounts);
257 
258     function swapExactETHForTokens(
259         uint256 amountOutMin,
260         address[] calldata path,
261         address to,
262         uint256 deadline
263     ) external payable returns (uint256[] memory amounts);
264 
265     function swapTokensForExactETH(
266         uint256 amountOut,
267         uint256 amountInMax,
268         address[] calldata path,
269         address to,
270         uint256 deadline
271     ) external returns (uint256[] memory amounts);
272 
273     function swapExactTokensForETH(
274         uint256 amountIn,
275         uint256 amountOutMin,
276         address[] calldata path,
277         address to,
278         uint256 deadline
279     ) external returns (uint256[] memory amounts);
280 
281     function swapETHForExactTokens(
282         uint256 amountOut,
283         address[] calldata path,
284         address to,
285         uint256 deadline
286     ) external payable returns (uint256[] memory amounts);
287 
288     function quote(
289         uint256 amountA,
290         uint256 reserveA,
291         uint256 reserveB
292     ) external pure returns (uint256 amountB);
293 
294     function getAmountOut(
295         uint256 amountIn,
296         uint256 reserveIn,
297         uint256 reserveOut
298     ) external pure returns (uint256 amountOut);
299 
300     function getAmountIn(
301         uint256 amountOut,
302         uint256 reserveIn,
303         uint256 reserveOut
304     ) external pure returns (uint256 amountIn);
305 
306     function getAmountsOut(uint256 amountIn, address[] calldata path)
307         external
308         view
309         returns (uint256[] memory amounts);
310 
311     function getAmountsIn(uint256 amountOut, address[] calldata path)
312         external
313         view
314         returns (uint256[] memory amounts);
315 }
316 
317 interface IUniswapV2Router02 is IUniswapV2Router01 {
318     function removeLiquidityETHSupportingFeeOnTransferTokens(
319         address token,
320         uint256 liquidity,
321         uint256 amountTokenMin,
322         uint256 amountETHMin,
323         address to,
324         uint256 deadline
325     ) external returns (uint256 amountETH);
326 
327     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
328         address token,
329         uint256 liquidity,
330         uint256 amountTokenMin,
331         uint256 amountETHMin,
332         address to,
333         uint256 deadline,
334         bool approveMax,
335         uint8 v,
336         bytes32 r,
337         bytes32 s
338     ) external returns (uint256 amountETH);
339 
340     function swapExactETHForTokensSupportingFeeOnTransferTokens(
341         uint256 amountOutMin,
342         address[] calldata path,
343         address to,
344         uint256 deadline
345     ) external payable;
346 
347     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
348         uint256 amountIn,
349         uint256 amountOutMin,
350         address[] calldata path,
351         address to,
352         uint256 deadline
353     ) external;
354 
355     function swapExactTokensForETHSupportingFeeOnTransferTokens(
356         uint256 amountIn,
357         uint256 amountOutMin,
358         address[] calldata path,
359         address to,
360         uint256 deadline
361     ) external;
362 }
363 
364 /**
365  * @dev Interface of the ERC20 standard as defined in the EIP.
366  */
367 interface IERC20 {
368     /**
369      * @dev Emitted when `value` tokens are moved from one account (`from`) to
370      * another (`to`).
371      *
372      * Note that `value` may be zero.
373      */
374     event Transfer(address indexed from, address indexed to, uint256 value);
375 
376     /**
377      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
378      * a call to {approve}. `value` is the new allowance.
379      */
380     event Approval(
381         address indexed owner,
382         address indexed spender,
383         uint256 value
384     );
385 
386     /**
387      * @dev Returns the amount of tokens in existence.
388      */
389     function totalSupply() external view returns (uint256);
390 
391     /**
392      * @dev Returns the amount of tokens owned by `account`.
393      */
394     function balanceOf(address account) external view returns (uint256);
395 
396     /**
397      * @dev Moves `amount` tokens from the caller's account to `to`.
398      *
399      * Returns a boolean value indicating whether the operation succeeded.
400      *
401      * Emits a {Transfer} event.
402      */
403     function transfer(address to, uint256 amount) external returns (bool);
404 
405     /**
406      * @dev Returns the remaining number of tokens that `spender` will be
407      * allowed to spend on behalf of `owner` through {transferFrom}. This is
408      * zero by default.
409      *
410      * This value changes when {approve} or {transferFrom} are called.
411      */
412     function allowance(address owner, address spender)
413         external
414         view
415         returns (uint256);
416 
417     /**
418      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
419      *
420      * Returns a boolean value indicating whether the operation succeeded.
421      *
422      * IMPORTANT: Beware that changing an allowance with this method brings the risk
423      * that someone may use both the old and the new allowance by unfortunate
424      * transaction ordering. One possible solution to mitigate this race
425      * condition is to first reduce the spender's allowance to 0 and set the
426      * desired value afterwards:
427      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
428      *
429      * Emits an {Approval} event.
430      */
431     function approve(address spender, uint256 amount) external returns (bool);
432 
433     /**
434      * @dev Moves `amount` tokens from `from` to `to` using the
435      * allowance mechanism. `amount` is then deducted from the caller's
436      * allowance.
437      *
438      * Returns a boolean value indicating whether the operation succeeded.
439      *
440      * Emits a {Transfer} event.
441      */
442     function transferFrom(
443         address from,
444         address to,
445         uint256 amount
446     ) external returns (bool);
447 }
448 
449 /**
450  * @dev Interface for the optional metadata functions from the ERC20 standard.
451  *
452  * _Available since v4.1._
453  */
454 interface IERC20Metadata is IERC20 {
455     /**
456      * @dev Returns the name of the token.
457      */
458     function name() external view returns (string memory);
459 
460     /**
461      * @dev Returns the decimals places of the token.
462      */
463     function decimals() external view returns (uint8);
464 
465     /**
466      * @dev Returns the symbol of the token.
467      */
468     function symbol() external view returns (string memory);
469 }
470 
471 /**
472  * @dev Provides information about the current execution context, including the
473  * sender of the transaction and its data. While these are generally available
474  * via msg.sender and msg.data, they should not be accessed in such a direct
475  * manner, since when dealing with meta-transactions the account sending and
476  * paying for execution may not be the actual sender (as far as an application
477  * is concerned).
478  *
479  * This contract is only required for intermediate, library-like contracts.
480  */
481 abstract contract Context {
482     function _msgSender() internal view virtual returns (address) {
483         return msg.sender;
484     }
485 }
486 
487 /**
488  * @dev Contract module which provides a basic access control mechanism, where
489  * there is an account (an owner) that can be granted exclusive access to
490  * specific functions.
491  *
492  * By default, the owner account will be the one that deploys the contract. This
493  * can later be changed with {transferOwnership}.
494  *
495  * This module is used through inheritance. It will make available the modifier
496  * `onlyOwner`, which can be applied to your functions to restrict their use to
497  * the owner.
498  */
499 abstract contract Ownable is Context {
500     address private _owner;
501 
502     event OwnershipTransferred(
503         address indexed previousOwner,
504         address indexed newOwner
505     );
506 
507     /**
508      * @dev Initializes the contract setting the deployer as the initial owner.
509      */
510     constructor() {
511         _transferOwnership(_msgSender());
512     }
513 
514     /**
515      * @dev Throws if called by any account other than the owner.
516      */
517     modifier onlyOwner() {
518         _checkOwner();
519         _;
520     }
521 
522     /**
523      * @dev Returns the address of the current owner.
524      */
525     function owner() public view virtual returns (address) {
526         return _owner;
527     }
528 
529     /**
530      * @dev Throws if the sender is not the owner.
531      */
532     function _checkOwner() internal view virtual {
533         require(owner() == _msgSender(), "Ownable: caller is not the owner");
534     }
535 
536     /**
537      * @dev Leaves the contract without owner. It will not be possible to call
538      * `onlyOwner` functions anymore. Can only be called by the current owner.
539      *
540      * NOTE: Renouncing ownership will leave the contract without an owner,
541      * thereby removing any functionality that is only available to the owner.
542      */
543     function renounceOwnership() public virtual onlyOwner {
544         _transferOwnership(address(0));
545     }
546 
547     /**
548      * @dev Transfers ownership of the contract to a new account (`newOwner`).
549      * Can only be called by the current owner.
550      */
551     function transferOwnership(address newOwner) public virtual onlyOwner {
552         require(
553             newOwner != address(0),
554             "Ownable: new owner is the zero address"
555         );
556         _transferOwnership(newOwner);
557     }
558 
559     /**
560      * @dev Transfers ownership of the contract to a new account (`newOwner`).
561      * Internal function without access restriction.
562      */
563     function _transferOwnership(address newOwner) internal virtual {
564         address oldOwner = _owner;
565         _owner = newOwner;
566         emit OwnershipTransferred(oldOwner, newOwner);
567     }
568 }
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
625      * @dev See {IERC20-balanceOf}.
626      */
627     function balanceOf(address account)
628         public
629         view
630         virtual
631         override
632         returns (uint256)
633     {
634         return _balances[account];
635     }
636 
637     /**
638      * @dev Returns the number of decimals used to get its user representation.
639      * For example, if `decimals` equals `2`, a balance of `505` tokens should
640      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
641      *
642      * Tokens usually opt for a value of 18, imitating the relationship between
643      * Ether and Wei. This is the value {ERC20} uses, unless this function is
644      * overridden;
645      *
646      * NOTE: This information is only used for _display_ purposes: it in
647      * no way affects any of the arithmetic of the contract, including
648      * {IERC20-balanceOf} and {IERC20-transfer}.
649      */
650     function decimals() public view virtual override returns (uint8) {
651         return 9;
652     }
653 
654     /**
655      * @dev See {IERC20-totalSupply}.
656      */
657     function totalSupply() external view virtual override returns (uint256) {
658         return _totalSupply;
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
742      * @dev Atomically decreases the allowance granted to `spender` by the caller.
743      *
744      * This is an alternative to {approve} that can be used as a mitigation for
745      * problems described in {IERC20-approve}.
746      *
747      * Emits an {Approval} event indicating the updated allowance.
748      *
749      * Requirements:
750      *
751      * - `spender` cannot be the zero address.
752      * - `spender` must have allowance for the caller of at least
753      * `subtractedValue`.
754      */
755     function decreaseAllowance(address spender, uint256 subtractedValue)
756         external
757         virtual
758         returns (bool)
759     {
760         address owner = _msgSender();
761         uint256 currentAllowance = allowance(owner, spender);
762         require(
763             currentAllowance >= subtractedValue,
764             "ERC20: decreased allowance below zero"
765         );
766         unchecked {
767             _approve(owner, spender, currentAllowance - subtractedValue);
768         }
769 
770         return true;
771     }
772 
773     /**
774      * @dev Atomically increases the allowance granted to `spender` by the caller.
775      *
776      * This is an alternative to {approve} that can be used as a mitigation for
777      * problems described in {IERC20-approve}.
778      *
779      * Emits an {Approval} event indicating the updated allowance.
780      *
781      * Requirements:
782      *
783      * - `spender` cannot be the zero address.
784      */
785     function increaseAllowance(address spender, uint256 addedValue)
786         external
787         virtual
788         returns (bool)
789     {
790         address owner = _msgSender();
791         _approve(owner, spender, allowance(owner, spender) + addedValue);
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
841      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
842      *
843      * This internal function is equivalent to `approve`, and can be used to
844      * e.g. set automatic allowances for certain subsystems, etc.
845      *
846      * Emits an {Approval} event.
847      *
848      * Requirements:
849      *
850      * - `owner` cannot be the zero address.
851      * - `spender` cannot be the zero address.
852      */
853     function _approve(
854         address owner,
855         address spender,
856         uint256 amount
857     ) internal virtual {
858         require(owner != address(0), "ERC20: approve from the zero address");
859         require(spender != address(0), "ERC20: approve to the zero address");
860 
861         _allowances[owner][spender] = amount;
862         emit Approval(owner, spender, amount);
863     }
864 
865     /**
866      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
867      *
868      * Does not update the allowance amount in case of infinite allowance.
869      * Revert if not enough allowance is available.
870      *
871      * Might emit an {Approval} event.
872      */
873     function _spendAllowance(
874         address owner,
875         address spender,
876         uint256 amount
877     ) internal virtual {
878         uint256 currentAllowance = allowance(owner, spender);
879         if (currentAllowance != type(uint256).max) {
880             require(
881                 currentAllowance >= amount,
882                 "ERC20: insufficient allowance"
883             );
884             unchecked {
885                 _approve(owner, spender, currentAllowance - amount);
886             }
887         }
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
914 /**
915  * @dev Implementation of the {IERC20} interface.
916  *
917  * This implementation is agnostic to the way tokens are created. This means
918  * that a supply mechanism has to be added in a derived contract using {_mint}.
919  * For a generic mechanism see {ERC20PresetMinterPauser}.
920  *
921  * TIP: For a detailed writeup see our guide
922  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
923  * to implement supply mechanisms].
924  *
925  * We have followed general OpenZeppelin Contracts guidelines: functions revert
926  * instead returning `false` on failure. This behavior is nonetheless
927  * conventional and does not conflict with the expectations of ERC20
928  * applications.
929  *
930  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
931  * This allows applications to reconstruct the allowance for all accounts just
932  * by listening to said events. Other implementations of the EIP may not emit
933  * these events, as it isn't required by the specification.
934  *
935  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
936  * functions have been added to mitigate the well-known issues around setting
937  * allowances. See {IERC20-approve}.
938  */
939  contract revoAI is ERC20, Ownable {
940     string private _name = "revoAI";
941     string private _symbol = "revoAI";
942     uint8 private _decimals = 9;
943     uint256 private _supply = 100000000;
944     uint256 public taxForLiquidity = 1;
945     uint256 public taxForMarketing = 2;
946 
947     address public marketingWallet = 0xbD350eba15c745a7CFb9Cff16D5bAbcFA9aaE4b7;
948     address public DEAD = 0x000000000000000000000000000000000000dEaD;
949     uint256 public _marketingReserves = 0;
950     mapping(address => bool) public _isExcludedFromFee;
951     uint256 public numTokensSellToAddToLiquidity = 50000 * 10**_decimals;
952     uint256 public numTokensSellToAddToETH = 25000 * 10**_decimals;
953 
954     IUniswapV2Router02 public immutable uniswapV2Router;
955     address public uniswapV2Pair;
956     
957     bool inSwapAndLiquify;
958 
959     event SwapAndLiquify(
960         uint256 tokensSwapped,
961         uint256 ethReceived,
962         uint256 tokensIntoLiqudity
963     );
964 
965     modifier lockTheSwap() {
966         inSwapAndLiquify = true;
967         _;
968         inSwapAndLiquify = false;
969     }
970 
971     /**
972      * @dev Sets the values for {name} and {symbol}.
973      *
974      * The default value of {decimals} is 18. To select a different value for
975      * {decimals} you should overload it.
976      *
977      * All two of these values are immutable: they can only be set once during
978      * construction.
979      */
980     constructor() ERC20(_name, _symbol) {
981         _mint(msg.sender, (_supply * 10**_decimals));
982 
983         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
984         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
985 
986         uniswapV2Router = _uniswapV2Router;
987 
988         _isExcludedFromFee[address(uniswapV2Router)] = true;
989         _isExcludedFromFee[msg.sender] = true;
990         _isExcludedFromFee[marketingWallet] = true;
991     }
992 
993 
994     /**
995      * @dev Moves `amount` of tokens from `from` to `to`.
996      *
997      * This internal function is equivalent to {transfer}, and can be used to
998      * e.g. implement automatic token fees, slashing mechanisms, etc.
999      *
1000      * Emits a {Transfer} event.
1001      *
1002      * Requirements:
1003      *
1004      *
1005      * - `from` cannot be the zero address.
1006      * - `to` cannot be the zero address.
1007      * - `from` must have a balance of at least `amount`.
1008      */
1009     function _transfer(address from, address to, uint256 amount) internal override {
1010         require(from != address(0), "ERC20: transfer from the zero address");
1011         require(to != address(0), "ERC20: transfer to the zero address");
1012         require(balanceOf(from) >= amount, "ERC20: transfer amount exceeds balance");
1013 
1014         if ((from == uniswapV2Pair || to == uniswapV2Pair) && !inSwapAndLiquify) {
1015             if (from != uniswapV2Pair) {
1016                 uint256 contractLiquidityBalance = balanceOf(address(this)) - _marketingReserves;
1017                 if (contractLiquidityBalance >= numTokensSellToAddToLiquidity) {
1018                     _swapAndLiquify(numTokensSellToAddToLiquidity);
1019                 }
1020                 if ((_marketingReserves) >= numTokensSellToAddToETH) {
1021                     _swapTokensForETH(numTokensSellToAddToETH);
1022                     _marketingReserves -= numTokensSellToAddToETH;
1023                     bool sent = payable(marketingWallet).send(address(this).balance);
1024                     require(sent, "Failed to send ETH");
1025                 }
1026             }
1027 
1028             uint256 transferAmount;
1029             if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
1030                 transferAmount = amount;
1031             } 
1032             else {
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
1047     function excludeFromFee(address _address, bool _status) external onlyOwner {
1048         _isExcludedFromFee[_address] = _status;
1049     }
1050 
1051     function _swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1052         uint256 half = (contractTokenBalance / 2);
1053         uint256 otherHalf = (contractTokenBalance - half);
1054 
1055         uint256 initialBalance = address(this).balance;
1056 
1057         _swapTokensForETH(half);
1058 
1059         uint256 newBalance = (address(this).balance - initialBalance);
1060 
1061         _addLiquidity(otherHalf, newBalance);
1062 
1063         emit SwapAndLiquify(half, newBalance, otherHalf);
1064     }
1065 
1066     function _swapTokensForETH(uint256 tokenAmount) private lockTheSwap {
1067         address[] memory path = new address[](2);
1068         path[0] = address(this);
1069         path[1] = uniswapV2Router.WETH();
1070 
1071         _approve(address(this), address(uniswapV2Router), tokenAmount);
1072 
1073         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1074             tokenAmount,
1075             0,
1076             path,
1077             address(this),
1078             block.timestamp
1079         );
1080     }
1081 
1082     function _addLiquidity(uint256 tokenAmount, uint256 ethAmount)
1083         private
1084         lockTheSwap
1085     {
1086         _approve(address(this), address(uniswapV2Router), tokenAmount);
1087 
1088         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1089             address(this),
1090             tokenAmount,
1091             0,
1092             0,
1093             marketingWallet,
1094             block.timestamp
1095         );
1096     }
1097 
1098     function setMarketingWallet(address newWallet)
1099         public
1100         onlyOwner
1101         returns (bool)
1102     {
1103         require(newWallet != DEAD, "LP Pair cannot be the Dead wallet, or 0!");
1104         require(newWallet != address(0), "LP Pair cannot be the Dead wallet, or 0!");
1105         marketingWallet = newWallet;
1106         return true;
1107     }
1108 
1109     function setTaxForLiquidityAndMarketing(uint256 _taxForLiquidity, uint256 _taxForMarketing)
1110         public
1111         onlyOwner
1112         returns (bool)
1113     {
1114         require((_taxForLiquidity+_taxForMarketing) <= 10, "ERC20: total tax must not be greater than 10%");
1115         taxForLiquidity = _taxForLiquidity;
1116         taxForMarketing = _taxForMarketing;
1117 
1118         return true;
1119     }
1120 
1121     function setNumTokensSellToAddToLiquidity(uint256 _numTokensSellToAddToLiquidity, uint256 _numTokensSellToAddToETH)
1122         public
1123         onlyOwner
1124         returns (bool)
1125     {
1126         require(_numTokensSellToAddToLiquidity < _supply / 98, "Cannot liquidate more than 2% of the supply at once!");
1127         require(_numTokensSellToAddToETH < _supply / 98, "Cannot liquidate more than 2% of the supply at once!");
1128         numTokensSellToAddToLiquidity = _numTokensSellToAddToLiquidity * 10**_decimals;
1129         numTokensSellToAddToETH = _numTokensSellToAddToETH * 10**_decimals;
1130 
1131         return true;
1132     }
1133 
1134     receive() external payable {}
1135 }