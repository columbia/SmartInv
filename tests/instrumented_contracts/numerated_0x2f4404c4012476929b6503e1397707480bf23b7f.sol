1 /*
2 
3 * Welcome To AITravis !
4 
5 * AITravis Bot - https://t.me/AITravis_Bot
6 
7 Website: https://aitravis.com/
8 Twitter: https://twitter.com/AiTravis_Eth
9 Discord: https://discord.gg/rXW52RwAzy
10 Telegram Group: https://t.me/AiTravis
11 Telegram Channel: https://t.me/AiTravis_News
12 */
13 
14 // SPDX-License-Identifier: MIT
15 
16 pragma solidity 0.8.16;
17 
18 interface IUniswapV2Factory {
19     event PairCreated(
20         address indexed token0,
21         address indexed token1,
22         address pair,
23         uint256
24     );
25 
26     function feeTo() external view returns (address);
27 
28     function feeToSetter() external view returns (address);
29 
30     function allPairsLength() external view returns (uint256);
31 
32     function getPair(address tokenA, address tokenB)
33         external
34         view
35         returns (address pair);
36 
37     function allPairs(uint256) external view returns (address pair);
38 
39     function createPair(address tokenA, address tokenB)
40         external
41         returns (address pair);
42 
43     function setFeeTo(address) external;
44 
45     function setFeeToSetter(address) external;
46 }
47 
48 interface IUniswapV2Pair {
49     event Approval(
50         address indexed owner,
51         address indexed spender,
52         uint256 value
53     );
54     event Transfer(address indexed from, address indexed to, uint256 value);
55 
56     function name() external pure returns (string memory);
57 
58     function symbol() external pure returns (string memory);
59 
60     function decimals() external pure returns (uint8);
61 
62     function totalSupply() external view returns (uint256);
63 
64     function balanceOf(address owner) external view returns (uint256);
65 
66     function allowance(address owner, address spender)
67         external
68         view
69         returns (uint256);
70 
71     function approve(address spender, uint256 value) external returns (bool);
72 
73     function transfer(address to, uint256 value) external returns (bool);
74 
75     function transferFrom(
76         address from,
77         address to,
78         uint256 value
79     ) external returns (bool);
80 
81     function DOMAIN_SEPARATOR() external view returns (bytes32);
82 
83     function PERMIT_TYPEHASH() external pure returns (bytes32);
84 
85     function nonces(address owner) external view returns (uint256);
86 
87     function permit(
88         address owner,
89         address spender,
90         uint256 value,
91         uint256 deadline,
92         uint8 v,
93         bytes32 r,
94         bytes32 s
95     ) external;
96 
97     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
98     event Burn(
99         address indexed sender,
100         uint256 amount0,
101         uint256 amount1,
102         address indexed to
103     );
104     event Swap(
105         address indexed sender,
106         uint256 amount0In,
107         uint256 amount1In,
108         uint256 amount0Out,
109         uint256 amount1Out,
110         address indexed to
111     );
112     event Sync(uint112 reserve0, uint112 reserve1);
113 
114     function MINIMUM_LIQUIDITY() external pure returns (uint256);
115 
116     function factory() external view returns (address);
117 
118     function token0() external view returns (address);
119 
120     function token1() external view returns (address);
121 
122     function getReserves()
123         external
124         view
125         returns (
126             uint112 reserve0,
127             uint112 reserve1,
128             uint32 blockTimestampLast
129         );
130 
131     function price0CumulativeLast() external view returns (uint256);
132 
133     function price1CumulativeLast() external view returns (uint256);
134 
135     function kLast() external view returns (uint256);
136 
137     function mint(address to) external returns (uint256 liquidity);
138 
139     function burn(address to)
140         external
141         returns (uint256 amount0, uint256 amount1);
142 
143     function swap(
144         uint256 amount0Out,
145         uint256 amount1Out,
146         address to,
147         bytes calldata data
148     ) external;
149 
150     function skim(address to) external;
151 
152     function sync() external;
153 
154     function initialize(address, address) external;
155 }
156 
157 interface IUniswapV2Router01 {
158     function factory() external pure returns (address);
159 
160     function WETH() external pure returns (address);
161 
162     function addLiquidity(
163         address tokenA,
164         address tokenB,
165         uint256 amountADesired,
166         uint256 amountBDesired,
167         uint256 amountAMin,
168         uint256 amountBMin,
169         address to,
170         uint256 deadline
171     )
172         external
173         returns (
174             uint256 amountA,
175             uint256 amountB,
176             uint256 liquidity
177         );
178 
179     function addLiquidityETH(
180         address token,
181         uint256 amountTokenDesired,
182         uint256 amountTokenMin,
183         uint256 amountETHMin,
184         address to,
185         uint256 deadline
186     )
187         external
188         payable
189         returns (
190             uint256 amountToken,
191             uint256 amountETH,
192             uint256 liquidity
193         );
194 
195     function removeLiquidity(
196         address tokenA,
197         address tokenB,
198         uint256 liquidity,
199         uint256 amountAMin,
200         uint256 amountBMin,
201         address to,
202         uint256 deadline
203     ) external returns (uint256 amountA, uint256 amountB);
204 
205     function removeLiquidityETH(
206         address token,
207         uint256 liquidity,
208         uint256 amountTokenMin,
209         uint256 amountETHMin,
210         address to,
211         uint256 deadline
212     ) external returns (uint256 amountToken, uint256 amountETH);
213 
214     function removeLiquidityWithPermit(
215         address tokenA,
216         address tokenB,
217         uint256 liquidity,
218         uint256 amountAMin,
219         uint256 amountBMin,
220         address to,
221         uint256 deadline,
222         bool approveMax,
223         uint8 v,
224         bytes32 r,
225         bytes32 s
226     ) external returns (uint256 amountA, uint256 amountB);
227 
228     function removeLiquidityETHWithPermit(
229         address token,
230         uint256 liquidity,
231         uint256 amountTokenMin,
232         uint256 amountETHMin,
233         address to,
234         uint256 deadline,
235         bool approveMax,
236         uint8 v,
237         bytes32 r,
238         bytes32 s
239     ) external returns (uint256 amountToken, uint256 amountETH);
240 
241     function swapExactTokensForTokens(
242         uint256 amountIn,
243         uint256 amountOutMin,
244         address[] calldata path,
245         address to,
246         uint256 deadline
247     ) external returns (uint256[] memory amounts);
248 
249     function swapTokensForExactTokens(
250         uint256 amountOut,
251         uint256 amountInMax,
252         address[] calldata path,
253         address to,
254         uint256 deadline
255     ) external returns (uint256[] memory amounts);
256 
257     function swapExactETHForTokens(
258         uint256 amountOutMin,
259         address[] calldata path,
260         address to,
261         uint256 deadline
262     ) external payable returns (uint256[] memory amounts);
263 
264     function swapTokensForExactETH(
265         uint256 amountOut,
266         uint256 amountInMax,
267         address[] calldata path,
268         address to,
269         uint256 deadline
270     ) external returns (uint256[] memory amounts);
271 
272     function swapExactTokensForETH(
273         uint256 amountIn,
274         uint256 amountOutMin,
275         address[] calldata path,
276         address to,
277         uint256 deadline
278     ) external returns (uint256[] memory amounts);
279 
280     function swapETHForExactTokens(
281         uint256 amountOut,
282         address[] calldata path,
283         address to,
284         uint256 deadline
285     ) external payable returns (uint256[] memory amounts);
286 
287     function quote(
288         uint256 amountA,
289         uint256 reserveA,
290         uint256 reserveB
291     ) external pure returns (uint256 amountB);
292 
293     function getAmountOut(
294         uint256 amountIn,
295         uint256 reserveIn,
296         uint256 reserveOut
297     ) external pure returns (uint256 amountOut);
298 
299     function getAmountIn(
300         uint256 amountOut,
301         uint256 reserveIn,
302         uint256 reserveOut
303     ) external pure returns (uint256 amountIn);
304 
305     function getAmountsOut(uint256 amountIn, address[] calldata path)
306         external
307         view
308         returns (uint256[] memory amounts);
309 
310     function getAmountsIn(uint256 amountOut, address[] calldata path)
311         external
312         view
313         returns (uint256[] memory amounts);
314 }
315 
316 interface IUniswapV2Router02 is IUniswapV2Router01 {
317     function removeLiquidityETHSupportingFeeOnTransferTokens(
318         address token,
319         uint256 liquidity,
320         uint256 amountTokenMin,
321         uint256 amountETHMin,
322         address to,
323         uint256 deadline
324     ) external returns (uint256 amountETH);
325 
326     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
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
337     ) external returns (uint256 amountETH);
338 
339     function swapExactETHForTokensSupportingFeeOnTransferTokens(
340         uint256 amountOutMin,
341         address[] calldata path,
342         address to,
343         uint256 deadline
344     ) external payable;
345 
346     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
347         uint256 amountIn,
348         uint256 amountOutMin,
349         address[] calldata path,
350         address to,
351         uint256 deadline
352     ) external;
353 
354     function swapExactTokensForETHSupportingFeeOnTransferTokens(
355         uint256 amountIn,
356         uint256 amountOutMin,
357         address[] calldata path,
358         address to,
359         uint256 deadline
360     ) external;
361 }
362 
363 /**
364  * @dev Interface of the ERC20 standard as defined in the EIP.
365  */
366 interface IERC20 {
367     /**
368      * @dev Emitted when `value` tokens are moved from one account (`from`) to
369      * another (`to`).
370      *
371      * Note that `value` may be zero.
372      */
373     event Transfer(address indexed from, address indexed to, uint256 value);
374 
375     /**
376      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
377      * a call to {approve}. `value` is the new allowance.
378      */
379     event Approval(
380         address indexed owner,
381         address indexed spender,
382         uint256 value
383     );
384 
385     /**
386      * @dev Returns the amount of tokens in existence.
387      */
388     function totalSupply() external view returns (uint256);
389 
390     /**
391      * @dev Returns the amount of tokens owned by `account`.
392      */
393     function balanceOf(address account) external view returns (uint256);
394 
395     /**
396      * @dev Moves `amount` tokens from the caller's account to `to`.
397      *
398      * Returns a boolean value indicating whether the operation succeeded.
399      *
400      * Emits a {Transfer} event.
401      */
402     function transfer(address to, uint256 amount) external returns (bool);
403 
404     /**
405      * @dev Returns the remaining number of tokens that `spender` will be
406      * allowed to spend on behalf of `owner` through {transferFrom}. This is
407      * zero by default.
408      *
409      * This value changes when {approve} or {transferFrom} are called.
410      */
411     function allowance(address owner, address spender)
412         external
413         view
414         returns (uint256);
415 
416     /**
417      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
418      *
419      * Returns a boolean value indicating whether the operation succeeded.
420      *
421      * IMPORTANT: Beware that changing an allowance with this method brings the risk
422      * that someone may use both the old and the new allowance by unfortunate
423      * transaction ordering. One possible solution to mitigate this race
424      * condition is to first reduce the spender's allowance to 0 and set the
425      * desired value afterwards:
426      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
427      *
428      * Emits an {Approval} event.
429      */
430     function approve(address spender, uint256 amount) external returns (bool);
431 
432     /**
433      * @dev Moves `amount` tokens from `from` to `to` using the
434      * allowance mechanism. `amount` is then deducted from the caller's
435      * allowance.
436      *
437      * Returns a boolean value indicating whether the operation succeeded.
438      *
439      * Emits a {Transfer} event.
440      */
441     function transferFrom(
442         address from,
443         address to,
444         uint256 amount
445     ) external returns (bool);
446 }
447 
448 /**
449  * @dev Interface for the optional metadata functions from the ERC20 standard.
450  *
451  * _Available since v4.1._
452  */
453 interface IERC20Metadata is IERC20 {
454     /**
455      * @dev Returns the name of the token.
456      */
457     function name() external view returns (string memory);
458 
459     /**
460      * @dev Returns the decimals places of the token.
461      */
462     function decimals() external view returns (uint8);
463 
464     /**
465      * @dev Returns the symbol of the token.
466      */
467     function symbol() external view returns (string memory);
468 }
469 
470 /**
471  * @dev Provides information about the current execution context, including the
472  * sender of the transaction and its data. While these are generally available
473  * via msg.sender and msg.data, they should not be accessed in such a direct
474  * manner, since when dealing with meta-transactions the account sending and
475  * paying for execution may not be the actual sender (as far as an application
476  * is concerned).
477  *
478  * This contract is only required for intermediate, library-like contracts.
479  */
480 abstract contract Context {
481     function _msgSender() internal view virtual returns (address) {
482         return msg.sender;
483     }
484 }
485 
486 /**
487  * @dev Contract module which provides a basic access control mechanism, where
488  * there is an account (an owner) that can be granted exclusive access to
489  * specific functions.
490  *
491  * By default, the owner account will be the one that deploys the contract. This
492  * can later be changed with {transferOwnership}.
493  *
494  * This module is used through inheritance. It will make available the modifier
495  * `onlyOwner`, which can be applied to your functions to restrict their use to
496  * the owner.
497  */
498 abstract contract Ownable is Context {
499     address private _owner;
500 
501     event OwnershipTransferred(
502         address indexed previousOwner,
503         address indexed newOwner
504     );
505 
506     /**
507      * @dev Initializes the contract setting the deployer as the initial owner.
508      */
509     constructor() {
510         _transferOwnership(_msgSender());
511     }
512 
513     /**
514      * @dev Throws if called by any account other than the owner.
515      */
516     modifier onlyOwner() {
517         _checkOwner();
518         _;
519     }
520 
521     /**
522      * @dev Returns the address of the current owner.
523      */
524     function owner() public view virtual returns (address) {
525         return _owner;
526     }
527 
528     /**
529      * @dev Throws if the sender is not the owner.
530      */
531     function _checkOwner() internal view virtual {
532         require(owner() == _msgSender(), "Ownable: caller is not the owner");
533     }
534 
535     /**
536      * @dev Leaves the contract without owner. It will not be possible to call
537      * `onlyOwner` functions anymore. Can only be called by the current owner.
538      *
539      * NOTE: Renouncing ownership will leave the contract without an owner,
540      * thereby removing any functionality that is only available to the owner.
541      */
542     function renounceOwnership() public virtual onlyOwner {
543         _transferOwnership(address(0));
544     }
545 
546     /**
547      * @dev Transfers ownership of the contract to a new account (`newOwner`).
548      * Can only be called by the current owner.
549      */
550     function transferOwnership(address newOwner) public virtual onlyOwner {
551         require(
552             newOwner != address(0),
553             "Ownable: new owner is the zero address"
554         );
555         _transferOwnership(newOwner);
556     }
557 
558     /**
559      * @dev Transfers ownership of the contract to a new account (`newOwner`).
560      * Internal function without access restriction.
561      */
562     function _transferOwnership(address newOwner) internal virtual {
563         address oldOwner = _owner;
564         _owner = newOwner;
565         emit OwnershipTransferred(oldOwner, newOwner);
566     }
567 }
568 
569 /**
570  * @dev Implementation of the {IERC20} interface.
571  *
572  * This implementation is agnostic to the way tokens are created. This means
573  * that a supply mechanism has to be added in a derived contract using {_mint}.
574  * For a generic mechanism see {ERC20PresetMinterPauser}.
575  *
576  * TIP: For a detailed writeup see our guide
577  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
578  * to implement supply mechanisms].
579  *
580  * We have followed general OpenZeppelin Contracts guidelines: functions revert
581  * instead returning `false` on failure. This behavior is nonetheless
582  * conventional and does not conflict with the expectations of ERC20
583  * applications.
584  *
585  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
586  * This allows applications to reconstruct the allowance for all accounts just
587  * by listening to said events. Other implementations of the EIP may not emit
588  * these events, as it isn't required by the specification.
589  *
590  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
591  * functions have been added to mitigate the well-known issues around setting
592  * allowances. See {IERC20-approve}.
593  */
594 contract ERC20 is Context, IERC20, IERC20Metadata {
595     mapping(address => uint256) private _balances;
596     mapping(address => mapping(address => uint256)) private _allowances;
597 
598     uint256 private _totalSupply;
599 
600     string private _name;
601     string private _symbol;
602 
603     constructor(string memory name_, string memory symbol_) {
604         _name = name_;
605         _symbol = symbol_;
606     }
607 
608     /**
609      * @dev Returns the symbol of the token, usually a shorter version of the
610      * name.
611      */
612     function symbol() external view virtual override returns (string memory) {
613         return _symbol;
614     }
615 
616     /**
617      * @dev Returns the name of the token.
618      */
619     function name() external view virtual override returns (string memory) {
620         return _name;
621     }
622 
623     /**
624      * @dev See {IERC20-balanceOf}.
625      */
626     function balanceOf(address account)
627         public
628         view
629         virtual
630         override
631         returns (uint256)
632     {
633         return _balances[account];
634     }
635 
636     /**
637      * @dev Returns the number of decimals used to get its user representation.
638      * For example, if `decimals` equals `2`, a balance of `505` tokens should
639      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
640      *
641      * Tokens usually opt for a value of 18, imitating the relationship between
642      * Ether and Wei. This is the value {ERC20} uses, unless this function is
643      * overridden;
644      *
645      * NOTE: This information is only used for _display_ purposes: it in
646      * no way affects any of the arithmetic of the contract, including
647      * {IERC20-balanceOf} and {IERC20-transfer}.
648      */
649     function decimals() public view virtual override returns (uint8) {
650         return 9;
651     }
652 
653     /**
654      * @dev See {IERC20-totalSupply}.
655      */
656     function totalSupply() external view virtual override returns (uint256) {
657         return _totalSupply;
658     }
659 
660     /**
661      * @dev See {IERC20-allowance}.
662      */
663     function allowance(address owner, address spender)
664         public
665         view
666         virtual
667         override
668         returns (uint256)
669     {
670         return _allowances[owner][spender];
671     }
672 
673     /**
674      * @dev See {IERC20-transfer}.
675      *
676      * Requirements:
677      *
678      * - `to` cannot be the zero address.
679      * - the caller must have a balance of at least `amount`.
680      */
681     function transfer(address to, uint256 amount)
682         external
683         virtual
684         override
685         returns (bool)
686     {
687         address owner = _msgSender();
688         _transfer(owner, to, amount);
689         return true;
690     }
691 
692     /**
693      * @dev See {IERC20-approve}.
694      *
695      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
696      * `transferFrom`. This is semantically equivalent to an infinite approval.
697      *
698      * Requirements:
699      *
700      * - `spender` cannot be the zero address.
701      */
702     function approve(address spender, uint256 amount)
703         external
704         virtual
705         override
706         returns (bool)
707     {
708         address owner = _msgSender();
709         _approve(owner, spender, amount);
710         return true;
711     }
712 
713     /**
714      * @dev See {IERC20-transferFrom}.
715      *
716      * Emits an {Approval} event indicating the updated allowance. This is not
717      * required by the EIP. See the note at the beginning of {ERC20}.
718      *
719      * NOTE: Does not update the allowance if the current allowance
720      * is the maximum `uint256`.
721      *
722      * Requirements:
723      *
724      * - `from` and `to` cannot be the zero address.
725      * - `from` must have a balance of at least `amount`.
726      * - the caller must have allowance for ``from``'s tokens of at least
727      * `amount`.
728      */
729     function transferFrom(
730         address from,
731         address to,
732         uint256 amount
733     ) external virtual override returns (bool) {
734         address spender = _msgSender();
735         _spendAllowance(from, spender, amount);
736         _transfer(from, to, amount);
737         return true;
738     }
739 
740     /**
741      * @dev Atomically decreases the allowance granted to `spender` by the caller.
742      *
743      * This is an alternative to {approve} that can be used as a mitigation for
744      * problems described in {IERC20-approve}.
745      *
746      * Emits an {Approval} event indicating the updated allowance.
747      *
748      * Requirements:
749      *
750      * - `spender` cannot be the zero address.
751      * - `spender` must have allowance for the caller of at least
752      * `subtractedValue`.
753      */
754     function decreaseAllowance(address spender, uint256 subtractedValue)
755         external
756         virtual
757         returns (bool)
758     {
759         address owner = _msgSender();
760         uint256 currentAllowance = allowance(owner, spender);
761         require(
762             currentAllowance >= subtractedValue,
763             "ERC20: decreased allowance below zero"
764         );
765         unchecked {
766             _approve(owner, spender, currentAllowance - subtractedValue);
767         }
768 
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
784     function increaseAllowance(address spender, uint256 addedValue)
785         external
786         virtual
787         returns (bool)
788     {
789         address owner = _msgSender();
790         _approve(owner, spender, allowance(owner, spender) + addedValue);
791         return true;
792     }
793 
794     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
795      * the total supply.
796      *
797      * Emits a {Transfer} event with `from` set to the zero address.
798      *
799      * Requirements:
800      *
801      * - `account` cannot be the zero address.
802      */
803     function _mint(address account, uint256 amount) internal virtual {
804         require(account != address(0), "ERC20: mint to the zero address");
805 
806         _totalSupply += amount;
807         unchecked {
808             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
809             _balances[account] += amount;
810         }
811         emit Transfer(address(0), account, amount);
812     }
813 
814     /**
815      * @dev Destroys `amount` tokens from `account`, reducing the
816      * total supply.
817      *
818      * Emits a {Transfer} event with `to` set to the zero address.
819      *
820      * Requirements:
821      *
822      * - `account` cannot be the zero address.
823      * - `account` must have at least `amount` tokens.
824      */
825     function _burn(address account, uint256 amount) internal virtual {
826         require(account != address(0), "ERC20: burn from the zero address");
827 
828         uint256 accountBalance = _balances[account];
829         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
830         unchecked {
831             _balances[account] = accountBalance - amount;
832             // Overflow not possible: amount <= accountBalance <= totalSupply.
833             _totalSupply -= amount;
834         }
835 
836         emit Transfer(account, address(0), amount);
837     }
838 
839     /**
840      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
841      *
842      * This internal function is equivalent to `approve`, and can be used to
843      * e.g. set automatic allowances for certain subsystems, etc.
844      *
845      * Emits an {Approval} event.
846      *
847      * Requirements:
848      *
849      * - `owner` cannot be the zero address.
850      * - `spender` cannot be the zero address.
851      */
852     function _approve(
853         address owner,
854         address spender,
855         uint256 amount
856     ) internal virtual {
857         require(owner != address(0), "ERC20: approve from the zero address");
858         require(spender != address(0), "ERC20: approve to the zero address");
859 
860         _allowances[owner][spender] = amount;
861         emit Approval(owner, spender, amount);
862     }
863 
864     /**
865      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
866      *
867      * Does not update the allowance amount in case of infinite allowance.
868      * Revert if not enough allowance is available.
869      *
870      * Might emit an {Approval} event.
871      */
872     function _spendAllowance(
873         address owner,
874         address spender,
875         uint256 amount
876     ) internal virtual {
877         uint256 currentAllowance = allowance(owner, spender);
878         if (currentAllowance != type(uint256).max) {
879             require(
880                 currentAllowance >= amount,
881                 "ERC20: insufficient allowance"
882             );
883             unchecked {
884                 _approve(owner, spender, currentAllowance - amount);
885             }
886         }
887     }
888 
889     function _transfer(
890         address from,
891         address to,
892         uint256 amount
893     ) internal virtual {
894         require(from != address(0), "ERC20: transfer from the zero address");
895         require(to != address(0), "ERC20: transfer to the zero address");
896 
897         uint256 fromBalance = _balances[from];
898         require(
899             fromBalance >= amount,
900             "ERC20: transfer amount exceeds balance"
901         );
902         unchecked {
903             _balances[from] = fromBalance - amount;
904             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
905             // decrementing then incrementing.
906             _balances[to] += amount;
907         }
908 
909         emit Transfer(from, to, amount);
910     }
911 }
912 
913 /**
914  * @dev Implementation of the {IERC20} interface.
915  *
916  * This implementation is agnostic to the way tokens are created. This means
917  * that a supply mechanism has to be added in a derived contract using {_mint}.
918  * For a generic mechanism see {ERC20PresetMinterPauser}.
919  *
920  * TIP: For a detailed writeup see our guide
921  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
922  * to implement supply mechanisms].
923  *
924  * We have followed general OpenZeppelin Contracts guidelines: functions revert
925  * instead returning `false` on failure. This behavior is nonetheless
926  * conventional and does not conflict with the expectations of ERC20
927  * applications.
928  *
929  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
930  * This allows applications to reconstruct the allowance for all accounts just
931  * by listening to said events. Other implementations of the EIP may not emit
932  * these events, as it isn't required by the specification.
933  *
934  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
935  * functions have been added to mitigate the well-known issues around setting
936  * allowances. See {IERC20-approve}.
937  */
938  contract AITravis is ERC20, Ownable {
939     string private _name = "AITravis";
940     string private _symbol = "tAI";
941     uint8 private _decimals = 9;
942     uint256 private _supply = 1000000000;
943     uint256 public taxForLiquidity = 1;
944     uint256 public taxForMarketing = 2;
945 
946     address public marketingWallet = 0x1CF2990E3E9c76920705cd116cE41317E02c7e3F;
947     address public DEAD = 0x000000000000000000000000000000000000dEaD;
948     uint256 public _marketingReserves = 0;
949     mapping(address => bool) public _isExcludedFromFee;
950     uint256 public numTokensSellToAddToLiquidity = 200000 * 10**_decimals;
951     uint256 public numTokensSellToAddToETH = 100000 * 10**_decimals;
952 
953     IUniswapV2Router02 public immutable uniswapV2Router;
954     address public uniswapV2Pair;
955     
956     bool inSwapAndLiquify;
957 
958     event SwapAndLiquify(
959         uint256 tokensSwapped,
960         uint256 ethReceived,
961         uint256 tokensIntoLiqudity
962     );
963 
964     modifier lockTheSwap() {
965         inSwapAndLiquify = true;
966         _;
967         inSwapAndLiquify = false;
968     }
969 
970     /**
971      * @dev Sets the values for {name} and {symbol}.
972      *
973      * The default value of {decimals} is 18. To select a different value for
974      * {decimals} you should overload it.
975      *
976      * All two of these values are immutable: they can only be set once during
977      * construction.
978      */
979     constructor() ERC20(_name, _symbol) {
980         _mint(msg.sender, (_supply * 10**_decimals));
981 
982         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
983         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
984 
985         uniswapV2Router = _uniswapV2Router;
986 
987         _isExcludedFromFee[address(uniswapV2Router)] = true;
988         _isExcludedFromFee[msg.sender] = true;
989         _isExcludedFromFee[marketingWallet] = true;
990     }
991 
992 
993     /**
994      * @dev Moves `amount` of tokens from `from` to `to`.
995      *
996      * This internal function is equivalent to {transfer}, and can be used to
997      * e.g. implement automatic token fees, slashing mechanisms, etc.
998      *
999      * Emits a {Transfer} event.
1000      *
1001      * Requirements:
1002      *
1003      *
1004      * - `from` cannot be the zero address.
1005      * - `to` cannot be the zero address.
1006      * - `from` must have a balance of at least `amount`.
1007      */
1008     function _transfer(address from, address to, uint256 amount) internal override {
1009         require(from != address(0), "ERC20: transfer from the zero address");
1010         require(to != address(0), "ERC20: transfer to the zero address");
1011         require(balanceOf(from) >= amount, "ERC20: transfer amount exceeds balance");
1012 
1013         if ((from == uniswapV2Pair || to == uniswapV2Pair) && !inSwapAndLiquify) {
1014             if (from != uniswapV2Pair) {
1015                 uint256 contractLiquidityBalance = balanceOf(address(this)) - _marketingReserves;
1016                 if (contractLiquidityBalance >= numTokensSellToAddToLiquidity) {
1017                     _swapAndLiquify(numTokensSellToAddToLiquidity);
1018                 }
1019                 if ((_marketingReserves) >= numTokensSellToAddToETH) {
1020                     _swapTokensForETH(numTokensSellToAddToETH);
1021                     _marketingReserves -= numTokensSellToAddToETH;
1022                     bool sent = payable(marketingWallet).send(address(this).balance);
1023                     require(sent, "Failed to send ETH");
1024                 }
1025             }
1026 
1027             uint256 transferAmount;
1028             if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
1029                 transferAmount = amount;
1030             } 
1031             else {
1032                 uint256 marketingShare = ((amount * taxForMarketing) / 100);
1033                 uint256 liquidityShare = ((amount * taxForLiquidity) / 100);
1034                 transferAmount = amount - (marketingShare + liquidityShare);
1035                 _marketingReserves += marketingShare;
1036 
1037                 super._transfer(from, address(this), (marketingShare + liquidityShare));
1038             }
1039             super._transfer(from, to, transferAmount);
1040         } 
1041         else {
1042             super._transfer(from, to, amount);
1043         }
1044     }
1045 
1046     function excludeFromFee(address _address, bool _status) external onlyOwner {
1047         _isExcludedFromFee[_address] = _status;
1048     }
1049 
1050     function _swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1051         uint256 half = (contractTokenBalance / 2);
1052         uint256 otherHalf = (contractTokenBalance - half);
1053 
1054         uint256 initialBalance = address(this).balance;
1055 
1056         _swapTokensForETH(half);
1057 
1058         uint256 newBalance = (address(this).balance - initialBalance);
1059 
1060         _addLiquidity(otherHalf, newBalance);
1061 
1062         emit SwapAndLiquify(half, newBalance, otherHalf);
1063     }
1064 
1065     function _swapTokensForETH(uint256 tokenAmount) private lockTheSwap {
1066         address[] memory path = new address[](2);
1067         path[0] = address(this);
1068         path[1] = uniswapV2Router.WETH();
1069 
1070         _approve(address(this), address(uniswapV2Router), tokenAmount);
1071 
1072         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1073             tokenAmount,
1074             0,
1075             path,
1076             address(this),
1077             block.timestamp
1078         );
1079     }
1080 
1081     function _addLiquidity(uint256 tokenAmount, uint256 ethAmount)
1082         private
1083         lockTheSwap
1084     {
1085         _approve(address(this), address(uniswapV2Router), tokenAmount);
1086 
1087         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1088             address(this),
1089             tokenAmount,
1090             0,
1091             0,
1092             marketingWallet,
1093             block.timestamp
1094         );
1095     }
1096 
1097     function setMarketingWallet(address newWallet)
1098         public
1099         onlyOwner
1100         returns (bool)
1101     {
1102         require(newWallet != DEAD, "LP Pair cannot be the Dead wallet, or 0!");
1103         require(newWallet != address(0), "LP Pair cannot be the Dead wallet, or 0!");
1104         marketingWallet = newWallet;
1105         return true;
1106     }
1107 
1108     function setTaxForLiquidityAndMarketing(uint256 _taxForLiquidity, uint256 _taxForMarketing)
1109         public
1110         onlyOwner
1111         returns (bool)
1112     {
1113         require((_taxForLiquidity+_taxForMarketing) <= 10, "ERC20: total tax must not be greater than 10%");
1114         taxForLiquidity = _taxForLiquidity;
1115         taxForMarketing = _taxForMarketing;
1116 
1117         return true;
1118     }
1119 
1120     function setNumTokensSellToAddToLiquidity(uint256 _numTokensSellToAddToLiquidity, uint256 _numTokensSellToAddToETH)
1121         public
1122         onlyOwner
1123         returns (bool)
1124     {
1125         require(_numTokensSellToAddToLiquidity < _supply / 98, "Cannot liquidate more than 2% of the supply at once!");
1126         require(_numTokensSellToAddToETH < _supply / 98, "Cannot liquidate more than 2% of the supply at once!");
1127         numTokensSellToAddToLiquidity = _numTokensSellToAddToLiquidity * 10**_decimals;
1128         numTokensSellToAddToETH = _numTokensSellToAddToETH * 10**_decimals;
1129 
1130         return true;
1131     }
1132 
1133     receive() external payable {}
1134 }