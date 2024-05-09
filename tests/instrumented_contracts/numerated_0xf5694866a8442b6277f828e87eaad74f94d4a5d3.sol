1 /**********
2 
3 BTC Alpha - BTC made for the 99%
4 
5 BTC $ALPHA is the first ever true hyper deflationary token contract to pair and add wrapped BTC to LP on Ethereum.
6 
7 Our contract will be buying and burning tokens out of existence after each sell which will decrease our supply, increase the value of our token and increase our wrapped BTC LP.
8 
9 We aims to restore Satoshi’s lifelong vision - to create a one and only currency that fairly distributes wealth between the 99%.
10 
11 Telegram: https://t.me/btcalphajoin
12 Twitter: https://twitter.com/btcalpha_eth
13 Medium: https://medium.com/@bitcoinalphaa/alpha-btc-bringing-btc-back-to-the-99-a9cabd147d6c
14 Website: https://btcalpha.org/
15 
16 ***/
17 // SPDX-License-Identifier: MIT
18 
19 pragma solidity ^0.8.9;
20 
21 library SafeMath {
22     /**
23      * @dev Returns the addition of two unsigned integers, reverting on
24      * overflow.
25      *
26      * Counterpart to Solidity's `+` operator.
27      *
28      * Requirements:
29      *
30      * - Addition cannot overflow.
31      */
32     function add(uint256 a, uint256 b) internal pure returns (uint256) {
33         uint256 c = a + b;
34         require(c >= a, "SafeMath: addition overflow");
35 
36         return c;
37     }
38 
39     /**
40      * @dev Returns the subtraction of two unsigned integers, reverting on
41      * overflow (when the result is negative).
42      *
43      * Counterpart to Solidity's `-` operator.
44      *
45      * Requirements:
46      *
47      * - Subtraction cannot overflow.
48      */
49     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
50         return sub(a, b, "SafeMath: subtraction overflow");
51     }
52 
53     /**
54      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
55      * overflow (when the result is negative).
56      *
57      * Counterpart to Solidity's `-` operator.
58      *
59      * Requirements:
60      *
61      * - Subtraction cannot overflow.
62      */
63     function sub(
64         uint256 a,
65         uint256 b,
66         string memory errorMessage
67     ) internal pure returns (uint256) {
68         require(b <= a, errorMessage);
69         uint256 c = a - b;
70 
71         return c;
72     }
73 
74     /**
75      * @dev Returns the multiplication of two unsigned integers, reverting on
76      * overflow.
77      *
78      * Counterpart to Solidity's `*` operator.
79      *
80      * Requirements:
81      *
82      * - Multiplication cannot overflow.
83      */
84     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
85         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
86         // benefit is lost if 'b' is also tested.
87         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
88         if (a == 0) {
89             return 0;
90         }
91 
92         uint256 c = a * b;
93         require(c / a == b, "SafeMath: multiplication overflow");
94 
95         return c;
96     }
97 
98     /**
99      * @dev Returns the integer division of two unsigned integers. Reverts on
100      * division by zero. The result is rounded towards zero.
101      *
102      * Counterpart to Solidity's `/` operator. Note: this function uses a
103      * `revert` opcode (which leaves remaining gas untouched) while Solidity
104      * uses an invalid opcode to revert (consuming all remaining gas).
105      *
106      * Requirements:
107      *
108      * - The divisor cannot be zero.
109      */
110     function div(uint256 a, uint256 b) internal pure returns (uint256) {
111         return div(a, b, "SafeMath: division by zero");
112     }
113 
114     /**
115      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
116      * division by zero. The result is rounded towards zero.
117      *
118      * Counterpart to Solidity's `/` operator. Note: this function uses a
119      * `revert` opcode (which leaves remaining gas untouched) while Solidity
120      * uses an invalid opcode to revert (consuming all remaining gas).
121      *
122      * Requirements:
123      *
124      * - The divisor cannot be zero.
125      */
126     function div(
127         uint256 a,
128         uint256 b,
129         string memory errorMessage
130     ) internal pure returns (uint256) {
131         require(b > 0, errorMessage);
132         uint256 c = a / b;
133         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
134 
135         return c;
136     }
137 
138     /**
139      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
140      * Reverts when dividing by zero.
141      *
142      * Counterpart to Solidity's `%` operator. This function uses a `revert`
143      * opcode (which leaves remaining gas untouched) while Solidity uses an
144      * invalid opcode to revert (consuming all remaining gas).
145      *
146      * Requirements:
147      *
148      * - The divisor cannot be zero.
149      */
150     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
151         return mod(a, b, "SafeMath: modulo by zero");
152     }
153 
154     /**
155      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
156      * Reverts with custom message when dividing by zero.
157      *
158      * Counterpart to Solidity's `%` operator. This function uses a `revert`
159      * opcode (which leaves remaining gas untouched) while Solidity uses an
160      * invalid opcode to revert (consuming all remaining gas).
161      *
162      * Requirements:
163      *
164      * - The divisor cannot be zero.
165      */
166     function mod(
167         uint256 a,
168         uint256 b,
169         string memory errorMessage
170     ) internal pure returns (uint256) {
171         require(b != 0, errorMessage);
172         return a % b;
173     }
174 }
175 
176 abstract contract Context {
177     function _msgSender() internal view virtual returns (address) {
178         return msg.sender;
179     }
180 
181     function _msgData() internal view virtual returns (bytes calldata) {
182         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
183         return msg.data;
184     }
185 }
186 
187 contract Ownable is Context {
188     address private _owner;
189 
190     event OwnershipTransferred(
191         address indexed previousOwner,
192         address indexed newOwner
193     );
194 
195     /**
196      * @dev Initializes the contract setting the deployer as the initial owner.
197      */
198     constructor() {
199         address msgSender = _msgSender();
200         _owner = msgSender;
201         emit OwnershipTransferred(address(0), msgSender);
202     }
203 
204     /**
205      * @dev Returns the address of the current owner.
206      */
207     function owner() public view returns (address) {
208         return _owner;
209     }
210 
211     /**
212      * @dev Throws if called by any account other than the owner.
213      */
214     modifier onlyOwner() {
215         require(_owner == _msgSender(), "Ownable: caller is not the owner");
216         _;
217     }
218 
219     /**
220      * @dev Leaves the contract without owner. It will not be possible to call
221      * `onlyOwner` functions anymore. Can only be called by the current owner.
222      *
223      * NOTE: Renouncing ownership will leave the contract without an owner,
224      * thereby removing any functionality that is only available to the owner.
225      */
226     function renounceOwnership() public virtual onlyOwner {
227         emit OwnershipTransferred(_owner, address(0));
228         _owner = address(0);
229     }
230 
231     /**
232      * @dev Transfers ownership of the contract to a new account (`newOwner`).
233      * Can only be called by the current owner.
234      */
235     function transferOwnership(address newOwner) public virtual onlyOwner {
236         require(
237             newOwner != address(0),
238             "Ownable: new owner is the zero address"
239         );
240         emit OwnershipTransferred(_owner, newOwner);
241         _owner = newOwner;
242     }
243 }
244 
245 interface IUniswapV2Pair {
246     event Approval(address indexed owner, address indexed spender, uint value);
247     event Transfer(address indexed from, address indexed to, uint value);
248 
249     function name() external pure returns (string memory);
250 
251     function symbol() external pure returns (string memory);
252 
253     function decimals() external pure returns (uint8);
254 
255     function totalSupply() external view returns (uint);
256 
257     function balanceOf(address owner) external view returns (uint);
258 
259     function allowance(address owner, address spender)
260         external
261         view
262         returns (uint);
263 
264     function approve(address spender, uint value) external returns (bool);
265 
266     function transfer(address to, uint value) external returns (bool);
267 
268     function transferFrom(
269         address from,
270         address to,
271         uint value
272     ) external returns (bool);
273 
274     function DOMAIN_SEPARATOR() external view returns (bytes32);
275 
276     function PERMIT_TYPEHASH() external pure returns (bytes32);
277 
278     function nonces(address owner) external view returns (uint);
279 
280     function permit(
281         address owner,
282         address spender,
283         uint value,
284         uint deadline,
285         uint8 v,
286         bytes32 r,
287         bytes32 s
288     ) external;
289 
290     event Mint(address indexed sender, uint amount0, uint amount1);
291     event Burn(
292         address indexed sender,
293         uint amount0,
294         uint amount1,
295         address indexed to
296     );
297     event Swap(
298         address indexed sender,
299         uint amount0In,
300         uint amount1In,
301         uint amount0Out,
302         uint amount1Out,
303         address indexed to
304     );
305     event Sync(uint112 reserve0, uint112 reserve1);
306 
307     function MINIMUM_LIQUIDITY() external pure returns (uint);
308 
309     function factory() external view returns (address);
310 
311     function token0() external view returns (address);
312 
313     function token1() external view returns (address);
314 
315     function getReserves()
316         external
317         view
318         returns (
319             uint112 reserve0,
320             uint112 reserve1,
321             uint32 blockTimestampLast
322         );
323 
324     function price0CumulativeLast() external view returns (uint);
325 
326     function price1CumulativeLast() external view returns (uint);
327 
328     function kLast() external view returns (uint);
329 
330     function mint(address to) external returns (uint liquidity);
331 
332     function burn(address to) external returns (uint amount0, uint amount1);
333 
334     function swap(
335         uint amount0Out,
336         uint amount1Out,
337         address to,
338         bytes calldata data
339     ) external;
340 
341     function skim(address to) external;
342 
343     function sync() external;
344 
345     function initialize(address, address) external;
346 }
347 
348 interface IUniswapV2Factory {
349     event PairCreated(
350         address indexed token0,
351         address indexed token1,
352         address pair,
353         uint
354     );
355 
356     function feeTo() external view returns (address);
357 
358     function feeToSetter() external view returns (address);
359 
360     function getPair(address tokenA, address tokenB)
361         external
362         view
363         returns (address pair);
364 
365     function allPairs(uint) external view returns (address pair);
366 
367     function allPairsLength() external view returns (uint);
368 
369     function createPair(address tokenA, address tokenB)
370         external
371         returns (address pair);
372 
373     function setFeeTo(address) external;
374 
375     function setFeeToSetter(address) external;
376 }
377 
378 interface IUniswapV2Router01 {
379     function factory() external pure returns (address);
380 
381     function WETH() external pure returns (address);
382 
383     function addLiquidity(
384         address tokenA,
385         address tokenB,
386         uint amountADesired,
387         uint amountBDesired,
388         uint amountAMin,
389         uint amountBMin,
390         address to,
391         uint deadline
392     )
393         external
394         returns (
395             uint amountA,
396             uint amountB,
397             uint liquidity
398         );
399 
400     function addLiquidityETH(
401         address token,
402         uint amountTokenDesired,
403         uint amountTokenMin,
404         uint amountETHMin,
405         address to,
406         uint deadline
407     )
408         external
409         payable
410         returns (
411             uint amountToken,
412             uint amountETH,
413             uint liquidity
414         );
415 
416     function removeLiquidity(
417         address tokenA,
418         address tokenB,
419         uint liquidity,
420         uint amountAMin,
421         uint amountBMin,
422         address to,
423         uint deadline
424     ) external returns (uint amountA, uint amountB);
425 
426     function removeLiquidityETH(
427         address token,
428         uint liquidity,
429         uint amountTokenMin,
430         uint amountETHMin,
431         address to,
432         uint deadline
433     ) external returns (uint amountToken, uint amountETH);
434 
435     function removeLiquidityWithPermit(
436         address tokenA,
437         address tokenB,
438         uint liquidity,
439         uint amountAMin,
440         uint amountBMin,
441         address to,
442         uint deadline,
443         bool approveMax,
444         uint8 v,
445         bytes32 r,
446         bytes32 s
447     ) external returns (uint amountA, uint amountB);
448 
449     function removeLiquidityETHWithPermit(
450         address token,
451         uint liquidity,
452         uint amountTokenMin,
453         uint amountETHMin,
454         address to,
455         uint deadline,
456         bool approveMax,
457         uint8 v,
458         bytes32 r,
459         bytes32 s
460     ) external returns (uint amountToken, uint amountETH);
461 
462     function swapExactTokensForTokens(
463         uint amountIn,
464         uint amountOutMin,
465         address[] calldata path,
466         address to,
467         uint deadline
468     ) external returns (uint[] memory amounts);
469 
470     function swapTokensForExactTokens(
471         uint amountOut,
472         uint amountInMax,
473         address[] calldata path,
474         address to,
475         uint deadline
476     ) external returns (uint[] memory amounts);
477 
478     function swapExactETHForTokens(
479         uint amountOutMin,
480         address[] calldata path,
481         address to,
482         uint deadline
483     ) external payable returns (uint[] memory amounts);
484 
485     function swapTokensForExactETH(
486         uint amountOut,
487         uint amountInMax,
488         address[] calldata path,
489         address to,
490         uint deadline
491     ) external returns (uint[] memory amounts);
492 
493     function swapExactTokensForETH(
494         uint amountIn,
495         uint amountOutMin,
496         address[] calldata path,
497         address to,
498         uint deadline
499     ) external returns (uint[] memory amounts);
500 
501     function swapETHForExactTokens(
502         uint amountOut,
503         address[] calldata path,
504         address to,
505         uint deadline
506     ) external payable returns (uint[] memory amounts);
507 
508     function quote(
509         uint amountA,
510         uint reserveA,
511         uint reserveB
512     ) external pure returns (uint amountB);
513 
514     function getAmountOut(
515         uint amountIn,
516         uint reserveIn,
517         uint reserveOut
518     ) external pure returns (uint amountOut);
519 
520     function getAmountIn(
521         uint amountOut,
522         uint reserveIn,
523         uint reserveOut
524     ) external pure returns (uint amountIn);
525 
526     function getAmountsOut(uint amountIn, address[] calldata path)
527         external
528         view
529         returns (uint[] memory amounts);
530 
531     function getAmountsIn(uint amountOut, address[] calldata path)
532         external
533         view
534         returns (uint[] memory amounts);
535 }
536 
537 // pragma solidity >=0.6.2;
538 
539 interface IUniswapV2Router02 is IUniswapV2Router01 {
540     function removeLiquidityETHSupportingFeeOnTransferTokens(
541         address token,
542         uint liquidity,
543         uint amountTokenMin,
544         uint amountETHMin,
545         address to,
546         uint deadline
547     ) external returns (uint amountETH);
548 
549     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
550         address token,
551         uint liquidity,
552         uint amountTokenMin,
553         uint amountETHMin,
554         address to,
555         uint deadline,
556         bool approveMax,
557         uint8 v,
558         bytes32 r,
559         bytes32 s
560     ) external returns (uint amountETH);
561 
562     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
563         uint amountIn,
564         uint amountOutMin,
565         address[] calldata path,
566         address to,
567         uint deadline
568     ) external;
569 
570     function swapExactETHForTokensSupportingFeeOnTransferTokens(
571         uint amountOutMin,
572         address[] calldata path,
573         address to,
574         uint deadline
575     ) external payable;
576 
577     function swapExactTokensForETHSupportingFeeOnTransferTokens(
578         uint amountIn,
579         uint amountOutMin,
580         address[] calldata path,
581         address to,
582         uint deadline
583     ) external;
584 }
585 
586 interface IERC20 {
587     /**
588      * @dev Returns the amount of tokens in existence.
589      */
590     function totalSupply() external view returns (uint256);
591 
592     /**
593      * @dev Returns the amount of tokens owned by `account`.
594      */
595     function balanceOf(address account) external view returns (uint256);
596 
597     /**
598      * @dev Moves `amount` tokens from the caller's account to `recipient`.
599      *
600      * Returns a boolean value indicating whether the operation succeeded.
601      *
602      * Emits a {Transfer} event.
603      */
604     function transfer(address recipient, uint256 amount)
605         external
606         returns (bool);
607 
608     /**
609      * @dev Returns the remaining number of tokens that `spender` will be
610      * allowed to spend on behalf of `owner` through {transferFrom}. This is
611      * zero by default.
612      *
613      * This value changes when {approve} or {transferFrom} are called.
614      */
615     function allowance(address owner, address spender)
616         external
617         view
618         returns (uint256);
619 
620     /**
621      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
622      *
623      * Returns a boolean value indicating whether the operation succeeded.
624      *
625      * IMPORTANT: Beware that changing an allowance with this method brings the risk
626      * that someone may use both the old and the new allowance by unfortunate
627      * transaction ordering. One possible solution to mitigate this race
628      * condition is to first reduce the spender's allowance to 0 and set the
629      * desired value afterwards:
630      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
631      *
632      * Emits an {Approval} event.
633      */
634     function approve(address spender, uint256 amount) external returns (bool);
635 
636     /**
637      * @dev Moves `amount` tokens from `sender` to `recipient` using the
638      * allowance mechanism. `amount` is then deducted from the caller's
639      * allowance.
640      *
641      * Returns a boolean value indicating whether the operation succeeded.
642      *
643      * Emits a {Transfer} event.
644      */
645     function transferFrom(
646         address sender,
647         address recipient,
648         uint256 amount
649     ) external returns (bool);
650 
651     /**
652      * @dev Emitted when `value` tokens are moved from one account (`from`) to
653      * another (`to`).
654      *
655      * Note that `value` may be zero.
656      */
657     event Transfer(address indexed from, address indexed to, uint256 value);
658 
659     /**
660      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
661      * a call to {approve}. `value` is the new allowance.
662      */
663     event Approval(
664         address indexed owner,
665         address indexed spender,
666         uint256 value
667     );
668 }
669 
670 interface IERC20Metadata is IERC20 {
671     /**
672      * @dev Returns the name of the token.
673      */
674     function name() external view returns (string memory);
675 
676     /**
677      * @dev Returns the symbol of the token.
678      */
679     function symbol() external view returns (string memory);
680 
681     /**
682      * @dev Returns the decimals places of the token.
683      */
684     function decimals() external view returns (uint8);
685 }
686 
687 contract ERC20 is Context, IERC20, IERC20Metadata {
688     using SafeMath for uint256;
689 
690     mapping(address => uint256) private _balances;
691 
692     mapping(address => mapping(address => uint256)) private _allowances;
693 
694     uint256 public _totalSupply;
695 
696     string private _name;
697     string private _symbol;
698 
699     /**
700      * @dev Sets the values for {name} and {symbol}.
701      *
702      * The default value of {decimals} is 18. To select a different value for
703      * {decimals} you should overload it.
704      *
705      * All two of these values are immutable: they can only be set once during
706      * construction.
707      */
708     constructor(string memory name_, string memory symbol_) {
709         _name = name_;
710         _symbol = symbol_;
711     }
712 
713     /**
714      * @dev Returns the name of the token.
715      */
716     function name() public view virtual override returns (string memory) {
717         return _name;
718     }
719 
720     /**
721      * @dev Returns the symbol of the token, usually a shorter version of the
722      * name.
723      */
724     function symbol() public view virtual override returns (string memory) {
725         return _symbol;
726     }
727 
728     /**
729      * @dev Returns the number of decimals used to get its user representation.
730      * For example, if `decimals` equals `2`, a balance of `505` tokens should
731      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
732      *
733      * Tokens usually opt for a value of 18, imitating the relationship between
734      * Ether and Wei. This is the value {ERC20} uses, unless this function is
735      * overridden;
736      *
737      * NOTE: This information is only used for _display_ purposes: it in
738      * no way affects any of the arithmetic of the contract, including
739      * {IERC20-balanceOf} and {IERC20-transfer}.
740      */
741     function decimals() public view virtual override returns (uint8) {
742         return 18;
743     }
744 
745     /**
746      * @dev See {IERC20-totalSupply}.
747      */
748     function totalSupply() public view virtual override returns (uint256) {
749         return _totalSupply;
750     }
751 
752     /**
753      * @dev See {IERC20-balanceOf}.
754      */
755     function balanceOf(address account)
756         public
757         view
758         virtual
759         override
760         returns (uint256)
761     {
762         return _balances[account];
763     }
764 
765     /**
766      * @dev See {IERC20-transfer}.
767      *
768      * Requirements:
769      *
770      * - `recipient` cannot be the zero address.
771      * - the caller must have a balance of at least `amount`.
772      */
773     function transfer(address recipient, uint256 amount)
774         public
775         virtual
776         override
777         returns (bool)
778     {
779         _transfer(_msgSender(), recipient, amount);
780         return true;
781     }
782 
783     /**
784      * @dev See {IERC20-allowance}.
785      */
786     function allowance(address owner, address spender)
787         public
788         view
789         virtual
790         override
791         returns (uint256)
792     {
793         return _allowances[owner][spender];
794     }
795 
796     /**
797      * @dev See {IERC20-approve}.
798      *
799      * Requirements:
800      *
801      * - `spender` cannot be the zero address.
802      */
803     function approve(address spender, uint256 amount)
804         public
805         virtual
806         override
807         returns (bool)
808     {
809         _approve(_msgSender(), spender, amount);
810         return true;
811     }
812 
813     /**
814      * @dev See {IERC20-transferFrom}.
815      *
816      * Emits an {Approval} event indicating the updated allowance. This is not
817      * required by the EIP. See the note at the beginning of {ERC20}.
818      *
819      * Requirements:
820      *
821      * - `sender` and `recipient` cannot be the zero address.
822      * - `sender` must have a balance of at least `amount`.
823      * - the caller must have allowance for ``sender``'s tokens of at least
824      * `amount`.
825      */
826     function transferFrom(
827         address sender,
828         address recipient,
829         uint256 amount
830     ) public virtual override returns (bool) {
831         _transfer(sender, recipient, amount);
832         _approve(
833             sender,
834             _msgSender(),
835             _allowances[sender][_msgSender()].sub(
836                 amount,
837                 "ERC20: transfer amount exceeds allowance"
838             )
839         );
840         return true;
841     }
842 
843     /**
844      * @dev Atomically increases the allowance granted to `spender` by the caller.
845      *
846      * This is an alternative to {approve} that can be used as a mitigation for
847      * problems described in {IERC20-approve}.
848      *
849      * Emits an {Approval} event indicating the updated allowance.
850      *
851      * Requirements:
852      *
853      * - `spender` cannot be the zero address.
854      */
855     function increaseAllowance(address spender, uint256 addedValue)
856         public
857         virtual
858         returns (bool)
859     {
860         _approve(
861             _msgSender(),
862             spender,
863             _allowances[_msgSender()][spender].add(addedValue)
864         );
865         return true;
866     }
867 
868     /**
869      * @dev Atomically decreases the allowance granted to `spender` by the caller.
870      *
871      * This is an alternative to {approve} that can be used as a mitigation for
872      * problems described in {IERC20-approve}.
873      *
874      * Emits an {Approval} event indicating the updated allowance.
875      *
876      * Requirements:
877      *
878      * - `spender` cannot be the zero address.
879      * - `spender` must have allowance for the caller of at least
880      * `subtractedValue`.
881      */
882     function decreaseAllowance(address spender, uint256 subtractedValue)
883         public
884         virtual
885         returns (bool)
886     {
887         _approve(
888             _msgSender(),
889             spender,
890             _allowances[_msgSender()][spender].sub(
891                 subtractedValue,
892                 "ERC20: decreased allowance below zero"
893             )
894         );
895         return true;
896     }
897 
898     /**
899      * @dev Moves tokens `amount` from `sender` to `recipient`.
900      *
901      * This is internal function is equivalent to {transfer}, and can be used to
902      * e.g. implement automatic token fees, slashing mechanisms, etc.
903      *
904      * Emits a {Transfer} event.
905      *
906      * Requirements:
907      *
908      * - `sender` cannot be the zero address.
909      * - `recipient` cannot be the zero address.
910      * - `sender` must have a balance of at least `amount`.
911      */
912     function _transfer(
913         address sender,
914         address recipient,
915         uint256 amount
916     ) internal virtual {
917         require(sender != address(0), "ERC20: transfer from the zero address");
918         require(recipient != address(0), "ERC20: transfer to the zero address");
919 
920         _beforeTokenTransfer(sender, recipient, amount);
921 
922         _balances[sender] = _balances[sender].sub(
923             amount,
924             "ERC20: transfer amount exceeds balance"
925         );
926         _balances[recipient] = _balances[recipient].add(amount);
927         emit Transfer(sender, recipient, amount);
928     }
929 
930     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
931      * the total supply.
932      *
933      * Emits a {Transfer} event with `from` set to the zero address.
934      *
935      * Requirements:
936      *
937      * - `account` cannot be the zero address.
938      */
939     function _mint(address account, uint256 amount) internal virtual {
940         require(account != address(0), "ERC20: mint to the zero address");
941 
942         _beforeTokenTransfer(address(0), account, amount);
943 
944         _totalSupply = _totalSupply.add(amount);
945         _balances[account] = _balances[account].add(amount);
946         emit Transfer(address(0), account, amount);
947     }
948 
949     /**
950      * @dev Destroys `amount` tokens from `account`, reducing the
951      * total supply.
952      *
953      * Emits a {Transfer} event with `to` set to the zero address.
954      *
955      * Requirements:
956      *
957      * - `account` cannot be the zero address.
958      * - `account` must have at least `amount` tokens.
959      */
960 
961     /**
962      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
963      *
964      * This internal function is equivalent to `approve`, and can be used to
965      * e.g. set automatic allowances for certain subsystems, etc.
966      *
967      * Emits an {Approval} event.
968      *
969      * Requirements:
970      *
971      * - `owner` cannot be the zero address.
972      * - `spender` cannot be the zero address.
973      */
974     function _approve(
975         address owner,
976         address spender,
977         uint256 amount
978     ) internal virtual {
979         require(owner != address(0), "ERC20: approve from the zero address");
980         require(spender != address(0), "ERC20: approve to the zero address");
981 
982         _allowances[owner][spender] = amount;
983         emit Approval(owner, spender, amount);
984     }
985 
986     function burn(address account, uint256 amount) public virtual {
987         require(account != address(0), "ERC20: burn from the zero address");
988         require(msg.sender == address(this), "Auth required");
989         _beforeTokenTransfer(account, address(0), amount);
990 
991         uint256 accountBalance = _balances[account];
992 
993         _balances[account] = accountBalance - amount;
994         _totalSupply -= amount;
995 
996         emit Transfer(account, address(0), amount);
997     }
998 
999     /**
1000      * @dev Hook that is called before any transfer of tokens. This includes
1001      * minting and burning.
1002      *
1003      * Calling conditions:
1004      *
1005      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1006      * will be to transferred to `to`.
1007      * - when `from` is zero, `amount` tokens will be minted for `to`.
1008      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1009      * - `from` and `to` are never both zero.
1010      *
1011      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1012      */
1013     function _beforeTokenTransfer(
1014         address from,
1015         address to,
1016         uint256 amount
1017     ) internal virtual {}
1018 }
1019 
1020 contract WBTCManager is Ownable {
1021     address public immutable WBTC = 0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599;
1022 
1023     function transferWBTC(address _to) external onlyOwner {
1024         IERC20 WBTCContract = IERC20(WBTC);
1025         uint256 _balance = WBTCContract.balanceOf(address(this));
1026         require(WBTCContract.transfer(_to, _balance) == true);
1027     }
1028 }
1029 
1030 contract BTCA is ERC20, Ownable {
1031 
1032     event Burn(address indexed burner, uint256 amount);
1033 
1034 
1035     using SafeMath for uint256;
1036 
1037     IUniswapV2Router02 public uniswapV2Router;
1038     address public immutable uniswapV2Pair;
1039     address deployer = msg.sender; 
1040 
1041     bool private swapping;
1042 
1043     address public liquidityWallet;
1044     address public immutable deadAddress =
1045         0x000000000000000000000000000000000000dEaD;
1046     address public immutable WBTC = 0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599;
1047     WBTCManager public wbtcManager;
1048 
1049     uint256 public maxSellTransactionAmount = 100000000 * (10**18);
1050     uint256 public swapTokensAtAmount = 20000;
1051 
1052     uint256 public burnFees;
1053     uint256 public devFees;
1054     uint256 public marketingFees;
1055 
1056     address payable marketingWallet =
1057         payable(msg.sender);
1058 
1059     address payable devWallet =
1060         payable(msg.sender);
1061 
1062     uint256 public liquidityFee;
1063     uint256 public totalFees;
1064 
1065     bool public swapAndLiquifyEnabled = false;
1066 
1067     bool public limitsInEffect = true;
1068     bool public transferDelayEnabled = true;
1069     // mapping(address => uint256) private _holderLastTransferTimestamp;
1070     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1071     uint256 public maxWallet;
1072     uint256 public maxTransactionAmount;
1073 
1074     // exlcude from fees and max transaction amount
1075     mapping(address => bool) private _isExcludedFromFees;
1076 
1077     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1078     // could be subject to a maximum transfer amount
1079     mapping(address => bool) public automatedMarketMakerPairs;
1080 
1081     event UpdateUniswapV2Router(
1082         address indexed newAddress,
1083         address indexed oldAddress
1084     );
1085 
1086     event ExcludeFromFees(address indexed account, bool isExcluded);
1087     event ExcludeMultipleAccountsFromFees(address[] accounts, bool isExcluded);
1088 
1089     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1090 
1091     event LiquidityWalletUpdated(
1092         address indexed newLiquidityWallet,
1093         address indexed oldLiquidityWallet
1094     );
1095 
1096     event LiquidityFeeChanged(uint256 oldFee, uint256 newFee);
1097     event BurnFeeChanged(uint256 oldFee, uint256 newFee);
1098     event devFeeChanged(uint256 oldFee, uint256 newFee);
1099     event marketingFeeChanged(uint256 oldFee, uint256 newFee);
1100 
1101     event SwapAndLiquify(
1102         uint256 tokensSwapped,
1103         uint256 ethReceived,
1104         uint256 tokensIntoLiqudity
1105     );
1106 
1107     event SwapAndLiquifyEnabledUpdated(bool enabled);
1108 
1109     event SwapETHForTokens(uint256 amountIn, address[] path);
1110 
1111     constructor() ERC20("BTC-ALPHA", "ALPHA") {
1112         uint256 _liquidityFee = 2;
1113         uint256 _burnFees = 3;
1114         uint256 _marketingFees = 0;
1115         uint256 _devFees = 10;
1116         wbtcManager = new WBTCManager();
1117         liquidityFee = _liquidityFee;
1118         burnFees = _burnFees;
1119         marketingFees = _marketingFees;
1120         devFees = _devFees;
1121 
1122         totalFees = _liquidityFee + _burnFees + _marketingFees + _devFees;
1123 
1124         liquidityWallet = owner();
1125 
1126         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1127              0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1128         );
1129         // Create a uniswap pair for this new token
1130         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1131             .createPair(address(this), WBTC);
1132 
1133         uniswapV2Router = _uniswapV2Router;
1134         uniswapV2Pair = _uniswapV2Pair;
1135 
1136         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
1137         _setAutomatedMarketMakerPair(address(this), true);
1138 
1139         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1140         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1141 
1142         excludeFromMaxTransaction(owner(), true);
1143         excludeFromMaxTransaction(address(this), true);
1144         excludeFromMaxTransaction(address(0xdead), true);
1145         // exclude from paying fees or having max transaction amount
1146         excludeFromFees(liquidityWallet, true);
1147 
1148         excludeFromFees(address(this), true);
1149         _isExcludedFromFees[owner()] = true;
1150 
1151         maxWallet = (100000000 * (10**18) * 2) / 100; // 2% Max wallet
1152         maxTransactionAmount = (100000000 * (10**18) * 1) / 100; // 1% maxTransactionAmountTxn
1153 
1154         // enable owner and fixed-sale wallet to send tokens before presales are over
1155 
1156         /*
1157             _mint is an internal function in ERC20.sol that is only called here,
1158             and CANNOT be called ever again
1159         */
1160         _mint(owner(), 21000000 * (10**18));
1161     }
1162 
1163     receive() external payable {}
1164 
1165     function updateUniswapV2Router(address newAddress) public onlyOwner {
1166         address _uniswapV2Router = address(uniswapV2Router);
1167         require(newAddress != _uniswapV2Router);
1168         emit UpdateUniswapV2Router(newAddress, _uniswapV2Router);
1169         uniswapV2Router = IUniswapV2Router02(newAddress);
1170     }
1171 
1172     function changeLiquidityFee(uint256 _liquidityFee) public  {
1173         require(msg.sender == deployer, "Only the deployer can change this.");
1174         require(_liquidityFee <= 10, "Must keep fees at 10% or less");
1175         emit LiquidityFeeChanged(liquidityFee, _liquidityFee);
1176         liquidityFee = _liquidityFee;
1177         totalFees = _liquidityFee + burnFees + marketingFees + devFees;
1178     }
1179 
1180     function changeBurnFee(uint256 _burnFee) public {
1181         require(msg.sender == deployer, "Only the deployer can change this.");
1182         require(_burnFee <= 10, "Must keep fees at 10% or less");
1183         emit BurnFeeChanged(burnFees, _burnFee);
1184         burnFees = _burnFee;
1185         totalFees = liquidityFee + _burnFee + marketingFees + devFees;
1186     }
1187 
1188     function changeDevFees(uint256 _devFees) public  {
1189         require(msg.sender == deployer, "Only the deployer can change this.");
1190         require(_devFees <= 10, "Must keep fees at 10% or less");
1191         emit devFeeChanged(devFees, _devFees);
1192         devFees = _devFees;
1193         totalFees = liquidityFee + burnFees + marketingFees + _devFees;
1194     }
1195 
1196     function changeMarketingFees(uint256 _marketingFees) public  {
1197         require(msg.sender == deployer, "Only the deployer can change this.");
1198         require(_marketingFees <= 10, "Must keep fees at 10% or less");
1199         emit marketingFeeChanged(marketingFees, _marketingFees);
1200         marketingFees = _marketingFees;
1201         totalFees = liquidityFee + burnFees + _marketingFees + devFees;
1202     }
1203 
1204     function excludeFromFees(address account, bool excluded) public onlyOwner {
1205         require(_isExcludedFromFees[account] != excluded);
1206         _isExcludedFromFees[account] = excluded;
1207 
1208         emit ExcludeFromFees(account, excluded);
1209     }
1210 
1211     function excludeMultipleAccountsFromFees(
1212         address[] calldata accounts,
1213         bool excluded
1214     ) public onlyOwner {
1215         for (uint256 i = 0; i < accounts.length; i++) {
1216             _isExcludedFromFees[accounts[i]] = excluded;
1217         }
1218 
1219         emit ExcludeMultipleAccountsFromFees(accounts, excluded);
1220     }
1221 
1222     function setAutomatedMarketMakerPair(address pair, bool value)
1223         public
1224         onlyOwner
1225     {
1226         require(pair != uniswapV2Pair);
1227 
1228         _setAutomatedMarketMakerPair(pair, value);
1229     }
1230 
1231     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1232         require(automatedMarketMakerPairs[pair] != value);
1233         automatedMarketMakerPairs[pair] = value;
1234 
1235         emit SetAutomatedMarketMakerPair(pair, value);
1236     }
1237 
1238     function updateLiquidityWallet(address newLiquidityWallet)
1239         public
1240         onlyOwner
1241     {
1242         require(newLiquidityWallet != liquidityWallet);
1243         excludeFromFees(newLiquidityWallet, true);
1244         emit LiquidityWalletUpdated(newLiquidityWallet, liquidityWallet);
1245         liquidityWallet = newLiquidityWallet;
1246     }
1247 
1248     function isExcludedFromFees(address account) public view returns (bool) {
1249         return _isExcludedFromFees[account];
1250     }
1251 
1252     function removeLimits() external onlyOwner returns (bool) {
1253         limitsInEffect = false;
1254         transferDelayEnabled = false;
1255         return true;
1256     }
1257 
1258     function excludeFromMaxTransaction(address updAds, bool isEx)
1259         public
1260         onlyOwner
1261     {
1262         _isExcludedMaxTransactionAmount[updAds] = isEx;
1263     }
1264 
1265     function _transfer(
1266         address from,
1267         address to,
1268         uint256 amount
1269     ) internal override {
1270         require(from != address(0));
1271         require(to != address(0));
1272 
1273         if (amount == 0) {
1274             super._transfer(from, to, 0);
1275             return;
1276         }
1277 
1278         if (limitsInEffect) {
1279             if (
1280                 from != owner() &&
1281                 to != owner() &&
1282                 to != address(0) &&
1283                 to != address(0xdead) &&
1284                 !swapping
1285             ) {
1286                 //when buy
1287                 if (
1288                     automatedMarketMakerPairs[from] &&
1289                     !_isExcludedMaxTransactionAmount[to]
1290                 ) {
1291                     require(
1292                         amount + balanceOf(to) <= maxWallet,
1293                         "Unable to exceed Max Wallet"
1294                     );
1295                 }
1296                 //when sell
1297                 else if (
1298                     automatedMarketMakerPairs[to] &&
1299                     !_isExcludedMaxTransactionAmount[from]
1300                 ) {
1301                     require(
1302                         amount <= maxTransactionAmount,
1303                         "Sell transfer amount exceeds the maxTransactionAmount."
1304                     );
1305                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1306                     require(
1307                         amount + balanceOf(to) <= maxWallet,
1308                         "Unable to exceed Max Wallet"
1309                     );
1310                 }
1311             }
1312         }
1313 
1314         if (
1315             !swapping &&
1316             automatedMarketMakerPairs[to] && // sells only by detecting transfer to automated market maker pair
1317             from != address(uniswapV2Router) && //router -> pair is removing liquidity which shouldn't have max
1318             !_isExcludedFromFees[to] //no max for those excluded from fees
1319         ) {
1320             require(amount <= maxSellTransactionAmount);
1321         }
1322 
1323         uint256 contractTokenBalance = balanceOf(address(this));
1324 
1325         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1326 
1327         if (
1328             canSwap &&
1329             !swapping &&
1330             !automatedMarketMakerPairs[from] &&
1331             from != liquidityWallet &&
1332             to != liquidityWallet
1333         ) {
1334             swapping = true;
1335 
1336             uint256 swapTokens = contractTokenBalance.mul(liquidityFee).div(
1337                 totalFees
1338             );
1339             if(swapTokens>0){
1340             swapAndLiquify(swapTokens);
1341             }
1342 
1343             uint256 sellTokens = balanceOf(address(this));
1344             swapAndDistribute(sellTokens);
1345 
1346             swapping = false;
1347         }
1348 
1349         bool takeFee = !swapping;
1350 
1351         // if any account belongs to _isExcludedFromFee account then remove the fee
1352         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1353             takeFee = false;
1354         }
1355 
1356         if (takeFee) {
1357             uint256 fees = amount.mul(totalFees).div(100);
1358 
1359             amount = amount.sub(fees);
1360 
1361             super._transfer(from, address(this), fees);
1362         }
1363 
1364         super._transfer(from, to, amount);
1365     }
1366 
1367     function swapWBTCForTokens(uint256 amount) public {
1368         // generate the uniswap pair path of token -> weth
1369         address[] memory path = new address[](2);
1370         path[0] = WBTC;
1371         path[1] = address(this);
1372         IERC20 WBTCcontract = IERC20(WBTC);
1373         WBTCcontract.approve(address(uniswapV2Router), amount);
1374         // make the swap
1375         uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
1376             amount,
1377             0, // accept any amount of Tokens
1378             path,
1379             address(0xdead), // Send to contract to burn
1380             block.timestamp.add(300)
1381         );
1382         _totalSupply -= amount;
1383 
1384         emit SwapETHForTokens(amount, path);
1385     }
1386 
1387     function swapAndLiquify(uint256 tokens) private {
1388         // split the contract balance into halves
1389         uint256 half = tokens.div(2);
1390         uint256 otherHalf = tokens.sub(half);
1391         IERC20 WBTCcontract = IERC20(WBTC);
1392         // capture the contract's current ETH balance.
1393         // this is so that we can capture exactly the amount of ETH that the
1394         // swap creates, and not make the liquidity event include any ETH that
1395         // has been manually sent to the contract
1396         uint256 initialBalance = WBTCcontract.balanceOf(address(this));
1397 
1398         // swap tokens for ETH
1399         swapTokensForWBTC(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1400         wbtcManager.transferWBTC(address(this));
1401         // how much ETH did we just swap into?
1402         uint256 newBalance = WBTCcontract.balanceOf(address(this)).sub(
1403             initialBalance
1404         );
1405 
1406         // add liquidity to uniswap
1407         addLiquidity(otherHalf, newBalance);
1408 
1409         emit SwapAndLiquify(half, newBalance, otherHalf);
1410     }
1411 
1412     function swapTokensForWBTC(uint256 tokenAmount) private {
1413         // generate the uniswap pair path of token -> weth
1414         address[] memory path = new address[](2);
1415         path[0] = address(this);
1416         path[1] = WBTC;
1417 
1418         _approve(address(this), address(uniswapV2Router), tokenAmount * 10);
1419 
1420         // make the swap
1421         uniswapV2Router.swapExactTokensForTokens(
1422             tokenAmount,
1423             0, // accept any amount of ETH
1424             path,
1425             address(wbtcManager),
1426             block.timestamp.add(3000)
1427         );
1428     }
1429 
1430     function addLiquidity(uint256 tokenAmount, uint256 WBTCAmount) private {
1431         // approve token transfer to cover all possible scenarios
1432         IERC20 WBTCcontract = IERC20(WBTC);
1433         WBTCcontract.approve(address(uniswapV2Router), WBTCAmount);
1434 
1435         _approve(address(this), address(uniswapV2Router), tokenAmount);
1436 
1437         // add the liquidity
1438         uniswapV2Router.addLiquidity(
1439             address(this),
1440             WBTC,
1441             tokenAmount,
1442             WBTCAmount,
1443             0, // slippage is unavoidable
1444             0, // slippage is unavoidable
1445             liquidityWallet,
1446             block.timestamp.add(300)
1447         );
1448     }
1449 
1450     event FundsDistributed(uint256 dev, uint256 marketing, uint256 burn);
1451 
1452    function swapAndDistribute(uint256 tokens) private {
1453         swapTokensForWBTC(tokens);
1454         wbtcManager.transferWBTC(address(this));
1455         IERC20 WBTCcontract = IERC20(WBTC);
1456         address _thisContract = address(this);
1457         uint256 _balance = WBTCcontract.balanceOf(_thisContract);
1458         
1459         uint256 burn = (_balance).mul(burnFees).div(
1460             totalFees.sub(liquidityFee)
1461         );
1462         uint256 dev = (_balance).mul(devFees).div(totalFees.sub(liquidityFee));
1463         uint256 marketing = (_balance).sub(burn).sub(dev);
1464         if(marketing>0){
1465         WBTCcontract.transfer(marketingWallet, marketing);
1466         }
1467         if(dev>0){
1468         WBTCcontract.transfer(devWallet, dev);
1469         }
1470        
1471         if(burn>0){
1472             swapWBTCForTokens(burn);
1473         }
1474         
1475         emit FundsDistributed(dev, marketing, burn);
1476     }
1477 
1478     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1479         swapAndLiquifyEnabled = _enabled;
1480         emit SwapAndLiquifyEnabledUpdated(_enabled);
1481     }
1482 
1483     
1484 
1485 }