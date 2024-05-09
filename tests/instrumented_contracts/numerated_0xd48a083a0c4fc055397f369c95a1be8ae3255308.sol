1 /**
2 P2E Coin Wars | Shooting FPS Game. Earn and Play
3 
4 https://t.me/cryptoshootofficial
5 
6 https://www.cryptoshoot.net/
7 
8 */
9 
10 // SPDX-License-Identifier: MIT
11 
12 pragma solidity 0.8.16;
13 
14 interface IUniswapV2Factory {
15     event PairCreated(
16         address indexed token0,
17         address indexed token1,
18         address pair,
19         uint256
20     );
21 
22     function feeTo() external view returns (address);
23 
24     function feeToSetter() external view returns (address);
25 
26     function allPairsLength() external view returns (uint256);
27 
28     function getPair(address tokenA, address tokenB)
29         external
30         view
31         returns (address pair);
32 
33     function allPairs(uint256) external view returns (address pair);
34 
35     function createPair(address tokenA, address tokenB)
36         external
37         returns (address pair);
38 
39     function setFeeTo(address) external;
40 
41     function setFeeToSetter(address) external;
42 }
43 
44 interface IUniswapV2Pair {
45     event Approval(
46         address indexed owner,
47         address indexed spender,
48         uint256 value
49     );
50     event Transfer(address indexed from, address indexed to, uint256 value);
51 
52     function name() external pure returns (string memory);
53 
54     function symbol() external pure returns (string memory);
55 
56     function decimals() external pure returns (uint8);
57 
58     function totalSupply() external view returns (uint256);
59 
60     function balanceOf(address owner) external view returns (uint256);
61 
62     function allowance(address owner, address spender)
63         external
64         view
65         returns (uint256);
66 
67     function approve(address spender, uint256 value) external returns (bool);
68 
69     function transfer(address to, uint256 value) external returns (bool);
70 
71     function transferFrom(
72         address from,
73         address to,
74         uint256 value
75     ) external returns (bool);
76 
77     function DOMAIN_SEPARATOR() external view returns (bytes32);
78 
79     function PERMIT_TYPEHASH() external pure returns (bytes32);
80 
81     function nonces(address owner) external view returns (uint256);
82 
83     function permit(
84         address owner,
85         address spender,
86         uint256 value,
87         uint256 deadline,
88         uint8 v,
89         bytes32 r,
90         bytes32 s
91     ) external;
92 
93     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
94     event Burn(
95         address indexed sender,
96         uint256 amount0,
97         uint256 amount1,
98         address indexed to
99     );
100     event Swap(
101         address indexed sender,
102         uint256 amount0In,
103         uint256 amount1In,
104         uint256 amount0Out,
105         uint256 amount1Out,
106         address indexed to
107     );
108     event Sync(uint112 reserve0, uint112 reserve1);
109 
110     function MINIMUM_LIQUIDITY() external pure returns (uint256);
111 
112     function factory() external view returns (address);
113 
114     function token0() external view returns (address);
115 
116     function token1() external view returns (address);
117 
118     function getReserves()
119         external
120         view
121         returns (
122             uint112 reserve0,
123             uint112 reserve1,
124             uint32 blockTimestampLast
125         );
126 
127     function price0CumulativeLast() external view returns (uint256);
128 
129     function price1CumulativeLast() external view returns (uint256);
130 
131     function kLast() external view returns (uint256);
132 
133     function mint(address to) external returns (uint256 liquidity);
134 
135     function burn(address to)
136         external
137         returns (uint256 amount0, uint256 amount1);
138 
139     function swap(
140         uint256 amount0Out,
141         uint256 amount1Out,
142         address to,
143         bytes calldata data
144     ) external;
145 
146     function skim(address to) external;
147 
148     function sync() external;
149 
150     function initialize(address, address) external;
151 }
152 
153 interface IUniswapV2Router01 {
154     function factory() external pure returns (address);
155 
156     function WETH() external pure returns (address);
157 
158     function addLiquidity(
159         address tokenA,
160         address tokenB,
161         uint256 amountADesired,
162         uint256 amountBDesired,
163         uint256 amountAMin,
164         uint256 amountBMin,
165         address to,
166         uint256 deadline
167     )
168         external
169         returns (
170             uint256 amountA,
171             uint256 amountB,
172             uint256 liquidity
173         );
174 
175     function addLiquidityETH(
176         address token,
177         uint256 amountTokenDesired,
178         uint256 amountTokenMin,
179         uint256 amountETHMin,
180         address to,
181         uint256 deadline
182     )
183         external
184         payable
185         returns (
186             uint256 amountToken,
187             uint256 amountETH,
188             uint256 liquidity
189         );
190 
191     function removeLiquidity(
192         address tokenA,
193         address tokenB,
194         uint256 liquidity,
195         uint256 amountAMin,
196         uint256 amountBMin,
197         address to,
198         uint256 deadline
199     ) external returns (uint256 amountA, uint256 amountB);
200 
201     function removeLiquidityETH(
202         address token,
203         uint256 liquidity,
204         uint256 amountTokenMin,
205         uint256 amountETHMin,
206         address to,
207         uint256 deadline
208     ) external returns (uint256 amountToken, uint256 amountETH);
209 
210     function removeLiquidityWithPermit(
211         address tokenA,
212         address tokenB,
213         uint256 liquidity,
214         uint256 amountAMin,
215         uint256 amountBMin,
216         address to,
217         uint256 deadline,
218         bool approveMax,
219         uint8 v,
220         bytes32 r,
221         bytes32 s
222     ) external returns (uint256 amountA, uint256 amountB);
223 
224     function removeLiquidityETHWithPermit(
225         address token,
226         uint256 liquidity,
227         uint256 amountTokenMin,
228         uint256 amountETHMin,
229         address to,
230         uint256 deadline,
231         bool approveMax,
232         uint8 v,
233         bytes32 r,
234         bytes32 s
235     ) external returns (uint256 amountToken, uint256 amountETH);
236 
237     function swapExactTokensForTokens(
238         uint256 amountIn,
239         uint256 amountOutMin,
240         address[] calldata path,
241         address to,
242         uint256 deadline
243     ) external returns (uint256[] memory amounts);
244 
245     function swapTokensForExactTokens(
246         uint256 amountOut,
247         uint256 amountInMax,
248         address[] calldata path,
249         address to,
250         uint256 deadline
251     ) external returns (uint256[] memory amounts);
252 
253     function swapExactETHForTokens(
254         uint256 amountOutMin,
255         address[] calldata path,
256         address to,
257         uint256 deadline
258     ) external payable returns (uint256[] memory amounts);
259 
260     function swapTokensForExactETH(
261         uint256 amountOut,
262         uint256 amountInMax,
263         address[] calldata path,
264         address to,
265         uint256 deadline
266     ) external returns (uint256[] memory amounts);
267 
268     function swapExactTokensForETH(
269         uint256 amountIn,
270         uint256 amountOutMin,
271         address[] calldata path,
272         address to,
273         uint256 deadline
274     ) external returns (uint256[] memory amounts);
275 
276     function swapETHForExactTokens(
277         uint256 amountOut,
278         address[] calldata path,
279         address to,
280         uint256 deadline
281     ) external payable returns (uint256[] memory amounts);
282 
283     function quote(
284         uint256 amountA,
285         uint256 reserveA,
286         uint256 reserveB
287     ) external pure returns (uint256 amountB);
288 
289     function getAmountOut(
290         uint256 amountIn,
291         uint256 reserveIn,
292         uint256 reserveOut
293     ) external pure returns (uint256 amountOut);
294 
295     function getAmountIn(
296         uint256 amountOut,
297         uint256 reserveIn,
298         uint256 reserveOut
299     ) external pure returns (uint256 amountIn);
300 
301     function getAmountsOut(uint256 amountIn, address[] calldata path)
302         external
303         view
304         returns (uint256[] memory amounts);
305 
306     function getAmountsIn(uint256 amountOut, address[] calldata path)
307         external
308         view
309         returns (uint256[] memory amounts);
310 }
311 
312 interface IUniswapV2Router02 is IUniswapV2Router01 {
313     function removeLiquidityETHSupportingFeeOnTransferTokens(
314         address token,
315         uint256 liquidity,
316         uint256 amountTokenMin,
317         uint256 amountETHMin,
318         address to,
319         uint256 deadline
320     ) external returns (uint256 amountETH);
321 
322     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
323         address token,
324         uint256 liquidity,
325         uint256 amountTokenMin,
326         uint256 amountETHMin,
327         address to,
328         uint256 deadline,
329         bool approveMax,
330         uint8 v,
331         bytes32 r,
332         bytes32 s
333     ) external returns (uint256 amountETH);
334 
335     function swapExactETHForTokensSupportingFeeOnTransferTokens(
336         uint256 amountOutMin,
337         address[] calldata path,
338         address to,
339         uint256 deadline
340     ) external payable;
341 
342     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
343         uint256 amountIn,
344         uint256 amountOutMin,
345         address[] calldata path,
346         address to,
347         uint256 deadline
348     ) external;
349 
350     function swapExactTokensForETHSupportingFeeOnTransferTokens(
351         uint256 amountIn,
352         uint256 amountOutMin,
353         address[] calldata path,
354         address to,
355         uint256 deadline
356     ) external;
357 }
358 
359 /**
360  * @dev Interface of the ERC20 standard as defined in the EIP.
361  */
362 interface IERC20 {
363     /**
364      * @dev Emitted when `value` tokens are moved from one account (`from`) to
365      * another (`to`).
366      *
367      * Note that `value` may be zero.
368      */
369     event Transfer(address indexed from, address indexed to, uint256 value);
370 
371     /**
372      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
373      * a call to {approve}. `value` is the new allowance.
374      */
375     event Approval(
376         address indexed owner,
377         address indexed spender,
378         uint256 value
379     );
380 
381     /**
382      * @dev Returns the amount of tokens in existence.
383      */
384     function totalSupply() external view returns (uint256);
385 
386     /**
387      * @dev Returns the amount of tokens owned by `account`.
388      */
389     function balanceOf(address account) external view returns (uint256);
390 
391     /**
392      * @dev Moves `amount` tokens from the caller's account to `to`.
393      *
394      * Returns a boolean value indicating whether the operation succeeded.
395      *
396      * Emits a {Transfer} event.
397      */
398     function transfer(address to, uint256 amount) external returns (bool);
399 
400     /**
401      * @dev Returns the remaining number of tokens that `spender` will be
402      * allowed to spend on behalf of `owner` through {transferFrom}. This is
403      * zero by default.
404      *
405      * This value changes when {approve} or {transferFrom} are called.
406      */
407     function allowance(address owner, address spender)
408         external
409         view
410         returns (uint256);
411 
412     /**
413      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
414      *
415      * Returns a boolean value indicating whether the operation succeeded.
416      *
417      * IMPORTANT: Beware that changing an allowance with this method brings the risk
418      * that someone may use both the old and the new allowance by unfortunate
419      * transaction ordering. One possible solution to mitigate this race
420      * condition is to first reduce the spender's allowance to 0 and set the
421      * desired value afterwards:
422      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
423      *
424      * Emits an {Approval} event.
425      */
426     function approve(address spender, uint256 amount) external returns (bool);
427 
428     /**
429      * @dev Moves `amount` tokens from `from` to `to` using the
430      * allowance mechanism. `amount` is then deducted from the caller's
431      * allowance.
432      *
433      * Returns a boolean value indicating whether the operation succeeded.
434      *
435      * Emits a {Transfer} event.
436      */
437     function transferFrom(
438         address from,
439         address to,
440         uint256 amount
441     ) external returns (bool);
442 }
443 
444 /**
445  * @dev Interface for the optional metadata functions from the ERC20 standard.
446  *
447  * _Available since v4.1._
448  */
449 interface IERC20Metadata is IERC20 {
450     /**
451      * @dev Returns the name of the token.
452      */
453     function name() external view returns (string memory);
454 
455     /**
456      * @dev Returns the decimals places of the token.
457      */
458     function decimals() external view returns (uint8);
459 
460     /**
461      * @dev Returns the symbol of the token.
462      */
463     function symbol() external view returns (string memory);
464 }
465 
466 /**
467  * @dev Provides information about the current execution context, including the
468  * sender of the transaction and its data. While these are generally available
469  * via msg.sender and msg.data, they should not be accessed in such a direct
470  * manner, since when dealing with meta-transactions the account sending and
471  * paying for execution may not be the actual sender (as far as an application
472  * is concerned).
473  *
474  * This contract is only required for intermediate, library-like contracts.
475  */
476 abstract contract Context {
477     function _msgSender() internal view virtual returns (address) {
478         return msg.sender;
479     }
480 }
481 
482 /**
483  * @dev Contract module which provides a basic access control mechanism, where
484  * there is an account (an owner) that can be granted exclusive access to
485  * specific functions.
486  *
487  * By default, the owner account will be the one that deploys the contract. This
488  * can later be changed with {transferOwnership}.
489  *
490  * This module is used through inheritance. It will make available the modifier
491  * `onlyOwner`, which can be applied to your functions to restrict their use to
492  * the owner.
493  */
494 abstract contract Ownable is Context {
495     address private _owner;
496 
497     event OwnershipTransferred(
498         address indexed previousOwner,
499         address indexed newOwner
500     );
501 
502     /**
503      * @dev Initializes the contract setting the deployer as the initial owner.
504      */
505     constructor() {
506         _transferOwnership(_msgSender());
507     }
508 
509     /**
510      * @dev Throws if called by any account other than the owner.
511      */
512     modifier onlyOwner() {
513         _checkOwner();
514         _;
515     }
516 
517     /**
518      * @dev Returns the address of the current owner.
519      */
520     function owner() public view virtual returns (address) {
521         return _owner;
522     }
523 
524     /**
525      * @dev Throws if the sender is not the owner.
526      */
527     function _checkOwner() internal view virtual {
528         require(owner() == _msgSender(), "Ownable: caller is not the owner");
529     }
530 
531     /**
532      * @dev Leaves the contract without owner. It will not be possible to call
533      * `onlyOwner` functions anymore. Can only be called by the current owner.
534      *
535      * NOTE: Renouncing ownership will leave the contract without an owner,
536      * thereby removing any functionality that is only available to the owner.
537      */
538     function renounceOwnership() public virtual onlyOwner {
539         _transferOwnership(address(0));
540     }
541 
542     /**
543      * @dev Transfers ownership of the contract to a new account (`newOwner`).
544      * Can only be called by the current owner.
545      */
546     function transferOwnership(address newOwner) public virtual onlyOwner {
547         require(
548             newOwner != address(0),
549             "Ownable: new owner is the zero address"
550         );
551         _transferOwnership(newOwner);
552     }
553 
554     /**
555      * @dev Transfers ownership of the contract to a new account (`newOwner`).
556      * Internal function without access restriction.
557      */
558     function _transferOwnership(address newOwner) internal virtual {
559         address oldOwner = _owner;
560         _owner = newOwner;
561         emit OwnershipTransferred(oldOwner, newOwner);
562     }
563 }
564 
565 /**
566  * @dev Implementation of the {IERC20} interface.
567  *
568  * This implementation is agnostic to the way tokens are created. This means
569  * that a supply mechanism has to be added in a derived contract using {_mint}.
570  * For a generic mechanism see {ERC20PresetMinterPauser}.
571  *
572  * TIP: For a detailed writeup see our guide
573  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
574  * to implement supply mechanisms].
575  *
576  * We have followed general OpenZeppelin Contracts guidelines: functions revert
577  * instead returning `false` on failure. This behavior is nonetheless
578  * conventional and does not conflict with the expectations of ERC20
579  * applications.
580  *
581  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
582  * This allows applications to reconstruct the allowance for all accounts just
583  * by listening to said events. Other implementations of the EIP may not emit
584  * these events, as it isn't required by the specification.
585  *
586  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
587  * functions have been added to mitigate the well-known issues around setting
588  * allowances. See {IERC20-approve}.
589  */
590 contract ERC20 is Context, IERC20, IERC20Metadata {
591     mapping(address => uint256) private _balances;
592     mapping(address => mapping(address => uint256)) private _allowances;
593 
594     uint256 private _totalSupply;
595 
596     string private _name;
597     string private _symbol;
598 
599     constructor(string memory name_, string memory symbol_) {
600         _name = name_;
601         _symbol = symbol_;
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
613      * @dev Returns the name of the token.
614      */
615     function name() external view virtual override returns (string memory) {
616         return _name;
617     }
618 
619     /**
620      * @dev See {IERC20-balanceOf}.
621      */
622     function balanceOf(address account)
623         public
624         view
625         virtual
626         override
627         returns (uint256)
628     {
629         return _balances[account];
630     }
631 
632     /**
633      * @dev Returns the number of decimals used to get its user representation.
634      * For example, if `decimals` equals `2`, a balance of `505` tokens should
635      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
636      *
637      * Tokens usually opt for a value of 18, imitating the relationship between
638      * Ether and Wei. This is the value {ERC20} uses, unless this function is
639      * overridden;
640      *
641      * NOTE: This information is only used for _display_ purposes: it in
642      * no way affects any of the arithmetic of the contract, including
643      * {IERC20-balanceOf} and {IERC20-transfer}.
644      */
645     function decimals() public view virtual override returns (uint8) {
646         return 9;
647     }
648 
649     /**
650      * @dev See {IERC20-totalSupply}.
651      */
652     function totalSupply() external view virtual override returns (uint256) {
653         return _totalSupply;
654     }
655 
656     /**
657      * @dev See {IERC20-allowance}.
658      */
659     function allowance(address owner, address spender)
660         public
661         view
662         virtual
663         override
664         returns (uint256)
665     {
666         return _allowances[owner][spender];
667     }
668 
669     /**
670      * @dev See {IERC20-transfer}.
671      *
672      * Requirements:
673      *
674      * - `to` cannot be the zero address.
675      * - the caller must have a balance of at least `amount`.
676      */
677     function transfer(address to, uint256 amount)
678         external
679         virtual
680         override
681         returns (bool)
682     {
683         address owner = _msgSender();
684         _transfer(owner, to, amount);
685         return true;
686     }
687 
688     /**
689      * @dev See {IERC20-approve}.
690      *
691      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
692      * `transferFrom`. This is semantically equivalent to an infinite approval.
693      *
694      * Requirements:
695      *
696      * - `spender` cannot be the zero address.
697      */
698     function approve(address spender, uint256 amount)
699         external
700         virtual
701         override
702         returns (bool)
703     {
704         address owner = _msgSender();
705         _approve(owner, spender, amount);
706         return true;
707     }
708 
709     /**
710      * @dev See {IERC20-transferFrom}.
711      *
712      * Emits an {Approval} event indicating the updated allowance. This is not
713      * required by the EIP. See the note at the beginning of {ERC20}.
714      *
715      * NOTE: Does not update the allowance if the current allowance
716      * is the maximum `uint256`.
717      *
718      * Requirements:
719      *
720      * - `from` and `to` cannot be the zero address.
721      * - `from` must have a balance of at least `amount`.
722      * - the caller must have allowance for ``from``'s tokens of at least
723      * `amount`.
724      */
725     function transferFrom(
726         address from,
727         address to,
728         uint256 amount
729     ) external virtual override returns (bool) {
730         address spender = _msgSender();
731         _spendAllowance(from, spender, amount);
732         _transfer(from, to, amount);
733         return true;
734     }
735 
736     /**
737      * @dev Atomically decreases the allowance granted to `spender` by the caller.
738      *
739      * This is an alternative to {approve} that can be used as a mitigation for
740      * problems described in {IERC20-approve}.
741      *
742      * Emits an {Approval} event indicating the updated allowance.
743      *
744      * Requirements:
745      *
746      * - `spender` cannot be the zero address.
747      * - `spender` must have allowance for the caller of at least
748      * `subtractedValue`.
749      */
750     function decreaseAllowance(address spender, uint256 subtractedValue)
751         external
752         virtual
753         returns (bool)
754     {
755         address owner = _msgSender();
756         uint256 currentAllowance = allowance(owner, spender);
757         require(
758             currentAllowance >= subtractedValue,
759             "ERC20: decreased allowance below zero"
760         );
761         unchecked {
762             _approve(owner, spender, currentAllowance - subtractedValue);
763         }
764 
765         return true;
766     }
767 
768     /**
769      * @dev Atomically increases the allowance granted to `spender` by the caller.
770      *
771      * This is an alternative to {approve} that can be used as a mitigation for
772      * problems described in {IERC20-approve}.
773      *
774      * Emits an {Approval} event indicating the updated allowance.
775      *
776      * Requirements:
777      *
778      * - `spender` cannot be the zero address.
779      */
780     function increaseAllowance(address spender, uint256 addedValue)
781         external
782         virtual
783         returns (bool)
784     {
785         address owner = _msgSender();
786         _approve(owner, spender, allowance(owner, spender) + addedValue);
787         return true;
788     }
789 
790     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
791      * the total supply.
792      *
793      * Emits a {Transfer} event with `from` set to the zero address.
794      *
795      * Requirements:
796      *
797      * - `account` cannot be the zero address.
798      */
799     function _mint(address account, uint256 amount) internal virtual {
800         require(account != address(0), "ERC20: mint to the zero address");
801 
802         _totalSupply += amount;
803         unchecked {
804             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
805             _balances[account] += amount;
806         }
807         emit Transfer(address(0), account, amount);
808     }
809 
810     /**
811      * @dev Destroys `amount` tokens from `account`, reducing the
812      * total supply.
813      *
814      * Emits a {Transfer} event with `to` set to the zero address.
815      *
816      * Requirements:
817      *
818      * - `account` cannot be the zero address.
819      * - `account` must have at least `amount` tokens.
820      */
821     function _burn(address account, uint256 amount) internal virtual {
822         require(account != address(0), "ERC20: burn from the zero address");
823 
824         uint256 accountBalance = _balances[account];
825         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
826         unchecked {
827             _balances[account] = accountBalance - amount;
828             // Overflow not possible: amount <= accountBalance <= totalSupply.
829             _totalSupply -= amount;
830         }
831 
832         emit Transfer(account, address(0), amount);
833     }
834 
835     /**
836      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
837      *
838      * This internal function is equivalent to `approve`, and can be used to
839      * e.g. set automatic allowances for certain subsystems, etc.
840      *
841      * Emits an {Approval} event.
842      *
843      * Requirements:
844      *
845      * - `owner` cannot be the zero address.
846      * - `spender` cannot be the zero address.
847      */
848     function _approve(
849         address owner,
850         address spender,
851         uint256 amount
852     ) internal virtual {
853         require(owner != address(0), "ERC20: approve from the zero address");
854         require(spender != address(0), "ERC20: approve to the zero address");
855 
856         _allowances[owner][spender] = amount;
857         emit Approval(owner, spender, amount);
858     }
859 
860     /**
861      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
862      *
863      * Does not update the allowance amount in case of infinite allowance.
864      * Revert if not enough allowance is available.
865      *
866      * Might emit an {Approval} event.
867      */
868     function _spendAllowance(
869         address owner,
870         address spender,
871         uint256 amount
872     ) internal virtual {
873         uint256 currentAllowance = allowance(owner, spender);
874         if (currentAllowance != type(uint256).max) {
875             require(
876                 currentAllowance >= amount,
877                 "ERC20: insufficient allowance"
878             );
879             unchecked {
880                 _approve(owner, spender, currentAllowance - amount);
881             }
882         }
883     }
884 
885     function _transfer(
886         address from,
887         address to,
888         uint256 amount
889     ) internal virtual {
890         require(from != address(0), "ERC20: transfer from the zero address");
891         require(to != address(0), "ERC20: transfer to the zero address");
892 
893         uint256 fromBalance = _balances[from];
894         require(
895             fromBalance >= amount,
896             "ERC20: transfer amount exceeds balance"
897         );
898         unchecked {
899             _balances[from] = fromBalance - amount;
900             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
901             // decrementing then incrementing.
902             _balances[to] += amount;
903         }
904 
905         emit Transfer(from, to, amount);
906     }
907 }
908 
909 /**
910  * @dev Implementation of the {IERC20} interface.
911  *
912  * This implementation is agnostic to the way tokens are created. This means
913  * that a supply mechanism has to be added in a derived contract using {_mint}.
914  * For a generic mechanism see {ERC20PresetMinterPauser}.
915  *
916  * TIP: For a detailed writeup see our guide
917  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
918  * to implement supply mechanisms].
919  *
920  * We have followed general OpenZeppelin Contracts guidelines: functions revert
921  * instead returning `false` on failure. This behavior is nonetheless
922  * conventional and does not conflict with the expectations of ERC20
923  * applications.
924  *
925  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
926  * This allows applications to reconstruct the allowance for all accounts just
927  * by listening to said events. Other implementations of the EIP may not emit
928  * these events, as it isn't required by the specification.
929  *
930  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
931  * functions have been added to mitigate the well-known issues around setting
932  * allowances. See {IERC20-approve}.
933  */
934  contract CryptoShoot is ERC20, Ownable {
935     // TOKENOMICS START ==========================================================>
936     string private _name = "Crypto Shoot";
937     string private _symbol = "CS";
938     uint8 private _decimals = 9;
939     uint256 private _supply = 100000000;
940     uint256 public taxForLiquidity = 0;
941     uint256 public taxForMarketing = 25;
942     uint256 public maxTxAmount = 1000000 * 10**_decimals;
943     uint256 public maxWalletAmount = 1000000 * 10**_decimals;
944     address public marketingWallet = 0xE8A130CDEc06E6ef21b2F5352d90F42CbA9C56f6;
945     // TOKENOMICS END ============================================================>
946 
947     IUniswapV2Router02 public immutable uniswapV2Router;
948     address public immutable uniswapV2Pair;
949 
950     uint256 private _marketingReserves = 0;
951     mapping(address => bool) private _isExcludedFromFee;
952     uint256 private _numTokensSellToAddToLiquidity = 1000000 * 10**_decimals;
953     uint256 private _numTokensSellToAddToETH = 200000 * 10**_decimals;
954     bool inSwapAndLiquify;
955 
956     event SwapAndLiquify(
957         uint256 tokensSwapped,
958         uint256 ethReceived,
959         uint256 tokensIntoLiqudity
960     );
961 
962     modifier lockTheSwap() {
963         inSwapAndLiquify = true;
964         _;
965         inSwapAndLiquify = false;
966     }
967 
968     /**
969      * @dev Sets the values for {name} and {symbol}.
970      *
971      * The default value of {decimals} is 18. To select a different value for
972      * {decimals} you should overload it.
973      *
974      * All two of these values are immutable: they can only be set once during
975      * construction.
976      */
977     constructor() ERC20(_name, _symbol) {
978         _mint(msg.sender, (_supply * 10**_decimals));
979 
980         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
981         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
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
1005     function _transfer(address from, address to, uint256 amount) internal override {
1006         require(from != address(0), "ERC20: transfer from the zero address");
1007         require(to != address(0), "ERC20: transfer to the zero address");
1008         require(balanceOf(from) >= amount, "ERC20: transfer amount exceeds balance");
1009 
1010         if ((from == uniswapV2Pair || to == uniswapV2Pair) && !inSwapAndLiquify) {
1011             if (from != uniswapV2Pair) {
1012                 uint256 contractLiquidityBalance = balanceOf(address(this)) - _marketingReserves;
1013                 if (contractLiquidityBalance >= _numTokensSellToAddToLiquidity) {
1014                     _swapAndLiquify(_numTokensSellToAddToLiquidity);
1015                 }
1016                 if ((_marketingReserves) >= _numTokensSellToAddToETH) {
1017                     _swapTokensForEth(_numTokensSellToAddToETH);
1018                     _marketingReserves -= _numTokensSellToAddToETH;
1019                     bool sent = payable(marketingWallet).send(address(this).balance);
1020                     require(sent, "Failed to send ETH");
1021                 }
1022             }
1023 
1024             uint256 transferAmount;
1025             if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
1026                 transferAmount = amount;
1027             } 
1028             else {
1029                 require(amount <= maxTxAmount, "ERC20: transfer amount exceeds the max transaction amount");
1030                 if(from == uniswapV2Pair){
1031                     require((amount + balanceOf(to)) <= maxWalletAmount, "ERC20: balance amount exceeded max wallet amount limit");
1032                 }
1033 
1034                 uint256 marketingShare = ((amount * taxForMarketing) / 100);
1035                 uint256 liquidityShare = ((amount * taxForLiquidity) / 100);
1036                 transferAmount = amount - (marketingShare + liquidityShare);
1037                 _marketingReserves += marketingShare;
1038 
1039                 super._transfer(from, address(this), (marketingShare + liquidityShare));
1040             }
1041             super._transfer(from, to, transferAmount);
1042         } 
1043         else {
1044             super._transfer(from, to, amount);
1045         }
1046     }
1047 
1048     function _swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1049         uint256 half = (contractTokenBalance / 2);
1050         uint256 otherHalf = (contractTokenBalance - half);
1051 
1052         uint256 initialBalance = address(this).balance;
1053 
1054         _swapTokensForEth(half);
1055 
1056         uint256 newBalance = (address(this).balance - initialBalance);
1057 
1058         _addLiquidity(otherHalf, newBalance);
1059 
1060         emit SwapAndLiquify(half, newBalance, otherHalf);
1061     }
1062 
1063     function _swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
1064         address[] memory path = new address[](2);
1065         path[0] = address(this);
1066         path[1] = uniswapV2Router.WETH();
1067 
1068         _approve(address(this), address(uniswapV2Router), tokenAmount);
1069 
1070         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1071             tokenAmount,
1072             0,
1073             path,
1074             address(this),
1075             (block.timestamp + 300)
1076         );
1077     }
1078 
1079     function _addLiquidity(uint256 tokenAmount, uint256 ethAmount)
1080         private
1081         lockTheSwap
1082     {
1083         _approve(address(this), address(uniswapV2Router), tokenAmount);
1084 
1085         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1086             address(this),
1087             tokenAmount,
1088             0,
1089             0,
1090             owner(),
1091             block.timestamp
1092         );
1093     }
1094 
1095     function changeMarketingWallet(address newWallet)
1096         public
1097         onlyOwner
1098         returns (bool)
1099     {
1100         marketingWallet = newWallet;
1101         return true;
1102     }
1103 
1104     function changeTaxForLiquidityAndMarketing(uint256 _taxForLiquidity, uint256 _taxForMarketing)
1105         public
1106         onlyOwner
1107         returns (bool)
1108     {
1109         require((_taxForLiquidity+_taxForMarketing) <= 100, "ERC20: total tax must not be greater than 100");
1110         taxForLiquidity = _taxForLiquidity;
1111         taxForMarketing = _taxForMarketing;
1112 
1113         return true;
1114     }
1115 
1116     function changeMaxTxAmount(uint256 _maxTxAmount)
1117         public
1118         onlyOwner
1119         returns (bool)
1120     {
1121         maxTxAmount = _maxTxAmount;
1122 
1123         return true;
1124     }
1125 
1126     function changeMaxWalletAmount(uint256 _maxWalletAmount)
1127         public
1128         onlyOwner
1129         returns (bool)
1130     {
1131         maxWalletAmount = _maxWalletAmount;
1132 
1133         return true;
1134     }
1135 
1136     receive() external payable {}
1137 }