1 // SPDX-License-Identifier: MIT
2 
3 //telegram: https://t.me/
4 //twitter: https://twitter.com/
5 //website: 
6 
7 pragma solidity 0.8.9;
8 
9 interface IUniswapV2Factory {
10     function createPair(
11         address tokenA,
12         address tokenB
13     ) external returns (address pair);
14 }
15 
16 interface IERC20 {
17     /**
18      * @dev Returns the amount of tokens in existence.
19      */
20     function totalSupply() external view returns (uint256);
21 
22     /**
23      * @dev Returns the amount of tokens owned by `account`.
24      */
25     function balanceOf(address account) external view returns (uint256);
26 
27     /**
28      * @dev Moves `amount` tokens from the caller's account to `recipient`.
29      *
30      * Returns a boolean value indicating whether the operation succeeded.
31      *
32      * Emits a {Transfer} event.
33      */
34     function transfer(
35         address recipient,
36         uint256 amount
37     ) external returns (bool);
38 
39     /**
40      * @dev Returns the remaining number of tokens that `spender` will be
41      * allowed to spend on behalf of `owner` through {transferFrom}. This is
42      * zero by default.
43      *
44      * This value changes when {approve} or {transferFrom} are called.
45      */
46     function allowance(
47         address owner,
48         address spender
49     ) external view returns (uint256);
50 
51     /**
52      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
53      *
54      * Returns a boolean value indicating whether the operation succeeded.
55      *
56      * IMPORTANT: Beware that changing an allowance with this method brings the risk
57      * that someone may use both the old and the new allowance by unfortunate
58      * transaction ordering. One possible solution to mitigate this race
59      * condition is to first reduce the spender's allowance to 0 and set the
60      * desired value afterwards:
61      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
62      *
63      * Emits an {Approval} event.
64      */
65     function approve(address spender, uint256 amount) external returns (bool);
66 
67     /**
68      * @dev Moves `amount` tokens from `sender` to `recipient` using the
69      * allowance mechanism. `amount` is then deducted from the caller's
70      * allowance.
71      *
72      * Returns a boolean value indicating whether the operation succeeded.
73      *
74      * Emits a {Transfer} event.
75      */
76     function transferFrom(
77         address sender,
78         address recipient,
79         uint256 amount
80     ) external returns (bool);
81 
82     /**
83      * @dev Emitted when `value` tokens are moved from one account (`from`) to
84      * another (`to`).
85      *
86      * Note that `value` may be zero.
87      */
88     event Transfer(address indexed from, address indexed to, uint256 value);
89 
90     /**
91      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
92      * a call to {approve}. `value` is the new allowance.
93      */
94     event Approval(
95         address indexed owner,
96         address indexed spender,
97         uint256 value
98     );
99 }
100 
101 interface IERC20Metadata is IERC20 {
102     /**
103      * @dev Returns the name of the token.
104      */
105     function name() external view returns (string memory);
106 
107     /**
108      * @dev Returns the symbol of the token.
109      */
110     function symbol() external view returns (string memory);
111 
112     /**
113      * @dev Returns the decimals places of the token.
114      */
115     function decimals() external view returns (uint8);
116 }
117 
118 abstract contract Context {
119     function _msgSender() internal view virtual returns (address) {
120         return msg.sender;
121     }
122 }
123 
124 contract ERC20 is Context, IERC20, IERC20Metadata {
125     using SafeMath for uint256;
126 
127     mapping(address => uint256) private _balances;
128 
129     mapping(address => mapping(address => uint256)) private _allowances;
130 
131     uint256 private _totalSupply;
132 
133     string private _name;
134     string private _symbol;
135 
136     /**
137      * @dev Sets the values for {name} and {symbol}.
138      *
139      * The default value of {decimals} is 18. To select a different value for
140      * {decimals} you should overload it.
141      *
142      * All two of these values are immutable: they can only be set once during
143      * construction.
144      */
145     constructor(string memory name_, string memory symbol_) {
146         _name = name_;
147         _symbol = symbol_;
148     }
149 
150     /**
151      * @dev Returns the name of the token.
152      */
153     function name() public view virtual override returns (string memory) {
154         return _name;
155     }
156 
157     /**
158      * @dev Returns the symbol of the token, usually a shorter version of the
159      * name.
160      */
161     function symbol() public view virtual override returns (string memory) {
162         return _symbol;
163     }
164 
165     /**
166      * @dev Returns the number of decimals used to get its user representation.
167      * For example, if `decimals` equals `2`, a balance of `505` tokens should
168      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
169      *
170      * Tokens usually opt for a value of 18, imitating the relationship between
171      * Ether and Wei. This is the value {ERC20} uses, unless this function is
172      * overridden;
173      *
174      * NOTE: This information is only used for _display_ purposes: it in
175      * no way affects any of the arithmetic of the contract, including
176      * {IERC20-balanceOf} and {IERC20-transfer}.
177      */
178     function decimals() public view virtual override returns (uint8) {
179         return 18;
180     }
181 
182     /**
183      * @dev See {IERC20-totalSupply}.
184      */
185     function totalSupply() public view virtual override returns (uint256) {
186         return _totalSupply;
187     }
188 
189     /**
190      * @dev See {IERC20-balanceOf}.
191      */
192     function balanceOf(
193         address account
194     ) public view virtual override returns (uint256) {
195         return _balances[account];
196     }
197 
198     /**
199      * @dev See {IERC20-transfer}.
200      *
201      * Requirements:
202      *
203      * - `recipient` cannot be the zero address.
204      * - the caller must have a balance of at least `amount`.
205      */
206     function transfer(
207         address recipient,
208         uint256 amount
209     ) public virtual override returns (bool) {
210         _transfer(_msgSender(), recipient, amount);
211         return true;
212     }
213 
214     /**
215      * @dev See {IERC20-allowance}.
216      */
217     function allowance(
218         address owner,
219         address spender
220     ) public view virtual override returns (uint256) {
221         return _allowances[owner][spender];
222     }
223 
224     /**
225      * @dev See {IERC20-approve}.
226      *
227      * Requirements:
228      *
229      * - `spender` cannot be the zero address.
230      */
231     function approve(
232         address spender,
233         uint256 amount
234     ) public virtual override returns (bool) {
235         _approve(_msgSender(), spender, amount);
236         return true;
237     }
238 
239     /**
240      * @dev See {IERC20-transferFrom}.
241      *
242      * Emits an {Approval} event indicating the updated allowance. This is not
243      * required by the EIP. See the note at the beginning of {ERC20}.
244      *
245      * Requirements:
246      *
247      * - `sender` and `recipient` cannot be the zero address.
248      * - `sender` must have a balance of at least `amount`.
249      * - the caller must have allowance for ``sender``'s tokens of at least
250      * `amount`.
251      */
252     function transferFrom(
253         address sender,
254         address recipient,
255         uint256 amount
256     ) public virtual override returns (bool) {
257         _transfer(sender, recipient, amount);
258         _approve(
259             sender,
260             _msgSender(),
261             _allowances[sender][_msgSender()].sub(
262                 amount,
263                 "ERC20: transfer amount exceeds allowance"
264             )
265         );
266         return true;
267     }
268 
269     /**
270      * @dev Atomically increases the allowance granted to `spender` by the caller.
271      *
272      * This is an alternative to {approve} that can be used as a mitigation for
273      * problems described in {IERC20-approve}.
274      *
275      * Emits an {Approval} event indicating the updated allowance.
276      *
277      * Requirements:
278      *
279      * - `spender` cannot be the zero address.
280      */
281     function increaseAllowance(
282         address spender,
283         uint256 addedValue
284     ) public virtual returns (bool) {
285         _approve(
286             _msgSender(),
287             spender,
288             _allowances[_msgSender()][spender].add(addedValue)
289         );
290         return true;
291     }
292 
293     /**
294      * @dev Atomically decreases the allowance granted to `spender` by the caller.
295      *
296      * This is an alternative to {approve} that can be used as a mitigation for
297      * problems described in {IERC20-approve}.
298      *
299      * Emits an {Approval} event indicating the updated allowance.
300      *
301      * Requirements:
302      *
303      * - `spender` cannot be the zero address.
304      * - `spender` must have allowance for the caller of at least
305      * `subtractedValue`.
306      */
307     function decreaseAllowance(
308         address spender,
309         uint256 subtractedValue
310     ) public virtual returns (bool) {
311         _approve(
312             _msgSender(),
313             spender,
314             _allowances[_msgSender()][spender].sub(
315                 subtractedValue,
316                 "ERC20: decreased cannot be below zero"
317             )
318         );
319         return true;
320     }
321 
322     /**
323      * @dev Moves tokens `amount` from `sender` to `recipient`.
324      *
325      * This is internal function is equivalent to {transfer}, and can be used to
326      * e.g. implement automatic token fees, slashing mechanisms, etc.
327      *
328      * Emits a {Transfer} event.
329      *
330      * Requirements:
331      *
332      * - `sender` cannot be the zero address.
333      * - `recipient` cannot be the zero address.
334      * - `sender` must have a balance of at least `amount`.
335      */
336     function _transfer(
337         address sender,
338         address recipient,
339         uint256 amount
340     ) internal virtual {
341         _balances[sender] = _balances[sender].sub(
342             amount,
343             "ERC20: transfer amount exceeds balance"
344         );
345         _balances[recipient] = _balances[recipient].add(amount);
346         emit Transfer(sender, recipient, amount);
347     }
348 
349     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
350      * the total supply.
351      *
352      * Emits a {Transfer} event with `from` set to the zero address.
353      *
354      * Requirements:
355      *
356      * - `account` cannot be the zero address.
357      */
358     function _mint(address account, uint256 amount) internal virtual {
359         require(account != address(0), "ERC20: mint to the zero address");
360 
361         _totalSupply = _totalSupply.add(amount);
362         _balances[account] = _balances[account].add(amount);
363         emit Transfer(address(0), account, amount);
364     }
365 
366     /**
367      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
368      *
369      * This internal function is equivalent to `approve`, and can be used to
370      * e.g. set automatic allowances for certain subsystems, etc.
371      *
372      * Emits an {Approval} event.
373      *
374      * Requirements:
375      *
376      * - `owner` cannot be the zero address.
377      * - `spender` cannot be the zero address.
378      */
379     function _approve(
380         address owner,
381         address spender,
382         uint256 amount
383     ) internal virtual {
384         _allowances[owner][spender] = amount;
385         emit Approval(owner, spender, amount);
386     }
387 }
388 
389 library SafeMath {
390     function add(uint256 a, uint256 b) internal pure returns (uint256) {
391         uint256 c = a + b;
392         require(c >= a, "SafeMath: addition overflow");
393 
394         return c;
395     }
396 
397     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
398         return sub(a, b, "SafeMath: subtraction overflow");
399     }
400 
401     function sub(
402         uint256 a,
403         uint256 b,
404         string memory errorMessage
405     ) internal pure returns (uint256) {
406         require(b <= a, errorMessage);
407         uint256 c = a - b;
408 
409         return c;
410     }
411 
412     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
413         if (a == 0) {
414             return 0;
415         }
416 
417         uint256 c = a * b;
418         require(c / a == b, "SafeMath: multiplication overflow");
419 
420         return c;
421     }
422 
423     function div(uint256 a, uint256 b) internal pure returns (uint256) {
424         return div(a, b, "SafeMath: division by zero");
425     }
426 
427     function div(
428         uint256 a,
429         uint256 b,
430         string memory errorMessage
431     ) internal pure returns (uint256) {
432         require(b > 0, errorMessage);
433         uint256 c = a / b;
434         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
435 
436         return c;
437     }
438 }
439 
440 contract Ownable is Context {
441     address private _owner;
442 
443     event OwnershipTransferred(
444         address indexed previousOwner,
445         address indexed newOwner
446     );
447 
448     /**
449      * @dev Initializes the contract setting the deployer as the initial owner.
450      */
451     constructor() {
452         address msgSender = _msgSender();
453         _owner = msgSender;
454         emit OwnershipTransferred(address(0), msgSender);
455     }
456 
457     /**
458      * @dev Returns the address of the current owner.
459      */
460     function owner() public view returns (address) {
461         return _owner;
462     }
463 
464     /**
465      * @dev Throws if called by any account other than the owner.
466      */
467     modifier onlyOwner() {
468         require(_owner == _msgSender(), "Ownable: caller is not the owner");
469         _;
470     }
471 
472     /**
473      * @dev Leaves the contract without owner. It will not be possible to call
474      * `onlyOwner` functions anymore. Can only be called by the current owner.
475      *
476      * NOTE: Renouncing ownership will leave the contract without an owner,
477      * thereby removing any functionality that is only available to the owner.
478      */
479     function renounceOwnership() public virtual onlyOwner {
480         emit OwnershipTransferred(_owner, address(0));
481         _owner = address(0);
482     }
483 
484     /**
485      * @dev Transfers ownership of the contract to a new account (`newOwner`).
486      * Can only be called by the current owner.
487      */
488     function transferOwnership(address newOwner) public virtual onlyOwner {
489         require(
490             newOwner != address(0),
491             "Ownable: new owner is the zero address"
492         );
493         emit OwnershipTransferred(_owner, newOwner);
494         _owner = newOwner;
495     }
496 }
497 
498 library SafeMathInt {
499     int256 private constant MIN_INT256 = int256(1) << 255;
500     int256 private constant MAX_INT256 = ~(int256(1) << 255);
501 
502     /**
503      * @dev Multiplies two int256 variables and fails on overflow.
504      */
505     function mul(int256 a, int256 b) internal pure returns (int256) {
506         int256 c = a * b;
507 
508         // Detect overflow when multiplying MIN_INT256 with -1
509         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
510         require((b == 0) || (c / b == a));
511         return c;
512     }
513 
514     /**
515      * @dev Division of two int256 variables and fails on overflow.
516      */
517     function div(int256 a, int256 b) internal pure returns (int256) {
518         // Prevent overflow when dividing MIN_INT256 by -1
519         require(b != -1 || a != MIN_INT256);
520 
521         // Solidity already throws when dividing by 0.
522         return a / b;
523     }
524 
525     /**
526      * @dev Subtracts two int256 variables and fails on overflow.
527      */
528     function sub(int256 a, int256 b) internal pure returns (int256) {
529         int256 c = a - b;
530         require((b >= 0 && c <= a) || (b < 0 && c > a));
531         return c;
532     }
533 
534     /**
535      * @dev Adds two int256 variables and fails on overflow.
536      */
537     function add(int256 a, int256 b) internal pure returns (int256) {
538         int256 c = a + b;
539         require((b >= 0 && c >= a) || (b < 0 && c < a));
540         return c;
541     }
542 
543     /**
544      * @dev Converts to absolute value, and fails on overflow.
545      */
546     function abs(int256 a) internal pure returns (int256) {
547         require(a != MIN_INT256);
548         return a < 0 ? -a : a;
549     }
550 
551     function toUint256Safe(int256 a) internal pure returns (uint256) {
552         require(a >= 0);
553         return uint256(a);
554     }
555 }
556 
557 library SafeMathUint {
558     function toInt256Safe(uint256 a) internal pure returns (int256) {
559         int256 b = int256(a);
560         require(b >= 0);
561         return b;
562     }
563 }
564 
565 interface IUniswapV2Router01 {
566     function factory() external pure returns (address);
567 
568     function WETH() external pure returns (address);
569 
570     function addLiquidity(
571         address tokenA,
572         address tokenB,
573         uint amountADesired,
574         uint amountBDesired,
575         uint amountAMin,
576         uint amountBMin,
577         address to,
578         uint deadline
579     ) external returns (uint amountA, uint amountB, uint liquidity);
580 
581     function addLiquidityETH(
582         address token,
583         uint amountTokenDesired,
584         uint amountTokenMin,
585         uint amountETHMin,
586         address to,
587         uint deadline
588     )
589         external
590         payable
591         returns (uint amountToken, uint amountETH, uint liquidity);
592 
593     function removeLiquidity(
594         address tokenA,
595         address tokenB,
596         uint liquidity,
597         uint amountAMin,
598         uint amountBMin,
599         address to,
600         uint deadline
601     ) external returns (uint amountA, uint amountB);
602 
603     function removeLiquidityETH(
604         address token,
605         uint liquidity,
606         uint amountTokenMin,
607         uint amountETHMin,
608         address to,
609         uint deadline
610     ) external returns (uint amountToken, uint amountETH);
611 
612     function removeLiquidityWithPermit(
613         address tokenA,
614         address tokenB,
615         uint liquidity,
616         uint amountAMin,
617         uint amountBMin,
618         address to,
619         uint deadline,
620         bool approveMax,
621         uint8 v,
622         bytes32 r,
623         bytes32 s
624     ) external returns (uint amountA, uint amountB);
625 
626     function removeLiquidityETHWithPermit(
627         address token,
628         uint liquidity,
629         uint amountTokenMin,
630         uint amountETHMin,
631         address to,
632         uint deadline,
633         bool approveMax,
634         uint8 v,
635         bytes32 r,
636         bytes32 s
637     ) external returns (uint amountToken, uint amountETH);
638 
639     function swapExactTokensForTokens(
640         uint amountIn,
641         uint amountOutMin,
642         address[] calldata path,
643         address to,
644         uint deadline
645     ) external returns (uint[] memory amounts);
646 
647     function swapTokensForExactTokens(
648         uint amountOut,
649         uint amountInMax,
650         address[] calldata path,
651         address to,
652         uint deadline
653     ) external returns (uint[] memory amounts);
654 
655     function swapExactETHForTokens(
656         uint amountOutMin,
657         address[] calldata path,
658         address to,
659         uint deadline
660     ) external payable returns (uint[] memory amounts);
661 
662     function swapTokensForExactETH(
663         uint amountOut,
664         uint amountInMax,
665         address[] calldata path,
666         address to,
667         uint deadline
668     ) external returns (uint[] memory amounts);
669 
670     function swapExactTokensForETH(
671         uint amountIn,
672         uint amountOutMin,
673         address[] calldata path,
674         address to,
675         uint deadline
676     ) external returns (uint[] memory amounts);
677 
678     function swapETHForExactTokens(
679         uint amountOut,
680         address[] calldata path,
681         address to,
682         uint deadline
683     ) external payable returns (uint[] memory amounts);
684 
685     function quote(
686         uint amountA,
687         uint reserveA,
688         uint reserveB
689     ) external pure returns (uint amountB);
690 
691     function getAmountOut(
692         uint amountIn,
693         uint reserveIn,
694         uint reserveOut
695     ) external pure returns (uint amountOut);
696 
697     function getAmountIn(
698         uint amountOut,
699         uint reserveIn,
700         uint reserveOut
701     ) external pure returns (uint amountIn);
702 
703     function getAmountsOut(
704         uint amountIn,
705         address[] calldata path
706     ) external view returns (uint[] memory amounts);
707 
708     function getAmountsIn(
709         uint amountOut,
710         address[] calldata path
711     ) external view returns (uint[] memory amounts);
712 }
713 
714 interface IUniswapV2Router02 is IUniswapV2Router01 {
715     function removeLiquidityETHSupportingFeeOnTransferTokens(
716         address token,
717         uint liquidity,
718         uint amountTokenMin,
719         uint amountETHMin,
720         address to,
721         uint deadline
722     ) external returns (uint amountETH);
723 
724     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
725         address token,
726         uint liquidity,
727         uint amountTokenMin,
728         uint amountETHMin,
729         address to,
730         uint deadline,
731         bool approveMax,
732         uint8 v,
733         bytes32 r,
734         bytes32 s
735     ) external returns (uint amountETH);
736 
737     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
738         uint amountIn,
739         uint amountOutMin,
740         address[] calldata path,
741         address to,
742         uint deadline
743     ) external;
744 
745     function swapExactETHForTokensSupportingFeeOnTransferTokens(
746         uint amountOutMin,
747         address[] calldata path,
748         address to,
749         uint deadline
750     ) external payable;
751 
752     function swapExactTokensForETHSupportingFeeOnTransferTokens(
753         uint amountIn,
754         uint amountOutMin,
755         address[] calldata path,
756         address to,
757         uint deadline
758     ) external;
759 }
760 
761 interface IUniswapV2Pair {
762     event Approval(address indexed owner, address indexed spender, uint value);
763     event Transfer(address indexed from, address indexed to, uint value);
764  
765     function name() external pure returns (string memory);
766     function symbol() external pure returns (string memory);
767     function decimals() external pure returns (uint8);
768     function totalSupply() external view returns (uint);
769     function balanceOf(address owner) external view returns (uint);
770     function allowance(address owner, address spender) external view returns (uint);
771  
772     function approve(address spender, uint value) external returns (bool);
773     function transfer(address to, uint value) external returns (bool);
774     function transferFrom(address from, address to, uint value) external returns (bool);
775  
776     function DOMAIN_SEPARATOR() external view returns (bytes32);
777     function PERMIT_TYPEHASH() external pure returns (bytes32);
778     function nonces(address owner) external view returns (uint);
779  
780     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
781  
782     event Mint(address indexed sender, uint amount0, uint amount1);
783     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
784     event Swap(
785         address indexed sender,
786         uint amount0In,
787         uint amount1In,
788         uint amount0Out,
789         uint amount1Out,
790         address indexed to
791     );
792     event Sync(uint112 reserve0, uint112 reserve1);
793  
794     function MINIMUM_LIQUIDITY() external pure returns (uint);
795     function factory() external view returns (address);
796     function token0() external view returns (address);
797     function token1() external view returns (address);
798     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
799     function price0CumulativeLast() external view returns (uint);
800     function price1CumulativeLast() external view returns (uint);
801     function kLast() external view returns (uint);
802  
803     function mint(address to) external returns (uint liquidity);
804     function burn(address to) external returns (uint amount0, uint amount1);
805     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
806     function skim(address to) external;
807     function sync() external;
808  
809     function initialize(address, address) external;
810 }
811 
812 contract BOBCHAIN is ERC20, Ownable {
813     using SafeMath for uint256;
814 
815     IUniswapV2Router02 public immutable router;
816     address public uniswapV2Pair;
817 
818     // addresses
819     address public devWallet;
820     address private marketingWallet;
821 
822     // limits
823     uint256 private maxBuyAmount;
824     uint256 private maxSellAmount;
825     uint256 private maxWalletAmount;
826 
827     uint256 private thresholdSwapAmount;
828 
829     // status flags
830     bool private isTrading = false;
831     bool public swapEnabled = false;
832     bool public isSwapping;
833 
834     bool public lpBurnEnabled = false;
835     uint256 public percentForLPBurn = 10; //0.1%
836     uint256 public lpBurnFrequency = 7200 seconds;
837     uint256 public lastLpBurnTime;
838     uint256 public manualBurnFrequency = 30 minutes;
839     uint256 public lastManualLpBurnTime;
840 
841     struct Fees {
842         uint8 buyTotalFees;
843         uint8 buyMarketingFee;
844         uint8 buyDevFee;
845         uint8 buyLiquidityFee;
846         uint8 sellTotalFees;
847         uint8 sellMarketingFee;
848         uint8 sellDevFee;
849         uint8 sellLiquidityFee;
850     }
851 
852     Fees public _fees =
853         Fees({
854             buyTotalFees: 0,
855             buyMarketingFee: 0,
856             buyDevFee: 0,
857             buyLiquidityFee: 0,
858             sellTotalFees: 0,
859             sellMarketingFee: 0,
860             sellDevFee: 0,
861             sellLiquidityFee: 0
862         });
863 
864     uint256 public tokensForMarketing;
865     uint256 public tokensForLiquidity;
866     uint256 public tokensForDev;
867     uint256 private taxTill;
868     // exclude from fees and max transaction amount
869     mapping(address => bool) private _isExcludedFromFees;
870     mapping(address => bool) public _isExcludedMaxTransactionAmount;
871     mapping(address => bool) public _isExcludedMaxWalletAmount;
872 
873     // Anti-bot and anti-whale mappings and variables
874     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
875 
876     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
877     // could be subject to a maximum transfer amount
878     mapping(address => bool) public marketPair;
879     mapping(address => bool) public _isBlacklisted;
880 
881     event SwapAndLiquify(uint256 tokensSwapped, uint256 ethReceived);
882 
883     constructor() ERC20("BOBCHAIN.NETWORK", "BCN") payable {
884         router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
885 
886         _isExcludedMaxTransactionAmount[address(router)] = true;
887         _isExcludedMaxTransactionAmount[owner()] = true;
888         _isExcludedMaxTransactionAmount[address(this)] = true;
889 
890         _isExcludedFromFees[owner()] = true;
891         _isExcludedFromFees[address(this)] = true;
892 
893         _isExcludedMaxWalletAmount[owner()] = true;
894         _isExcludedMaxWalletAmount[address(this)] = true;
895 
896         approve(address(router), type(uint256).max);
897         uint256 totalSupply = 1e9 * 1e18;
898 
899         maxBuyAmount = (totalSupply * 1) / 100; // 1% maxTransactionAmountTxn
900         maxSellAmount = (totalSupply * 1) / 100; // 1% maxTransactionAmountTxn
901         maxWalletAmount = (totalSupply * 1) / 100; // 1% maxWallet
902         thresholdSwapAmount = (totalSupply * 1) / 10000; // 0.01% swap wallet
903 
904         _fees.buyMarketingFee = 2;
905         _fees.buyLiquidityFee = 1;
906         _fees.buyDevFee = 1;
907         _fees.buyTotalFees =
908             _fees.buyMarketingFee +
909             _fees.buyLiquidityFee +
910             _fees.buyDevFee;
911 
912         _fees.sellMarketingFee = 2;
913         _fees.sellLiquidityFee = 1;
914         _fees.sellDevFee = 1;
915         _fees.sellTotalFees =
916             _fees.sellMarketingFee +
917             _fees.sellLiquidityFee +
918             _fees.sellDevFee;
919 
920         marketingWallet = address(0xDBC95bd68D5BC3e93258Aa63CECA26E12d15B206);
921         devWallet = address(0x26bD9d08B399d590721476C3bC8C0cbd9aEff098);
922 
923         /*
924             _mint is an internal function in ERC20.sol that is only called here,
925             and CANNOT be called ever again
926         */
927         _mint(msg.sender, (totalSupply * 50 / 100)); //50% Liquidity
928         _mint(address(this), (totalSupply * 50 / 100)); //30% Validators, 20% CEX
929     }
930 
931     receive() external payable {}
932 
933     function launchToken() external onlyOwner {
934         require(!isTrading, "Trades already Live!");
935 
936         uniswapV2Pair = IUniswapV2Factory(router.factory())
937             .createPair(address(this), router.WETH());
938         _isExcludedMaxTransactionAmount[address(uniswapV2Pair)] = true;
939         _isExcludedMaxWalletAmount[address(uniswapV2Pair)] = true;
940         marketPair[address(uniswapV2Pair)] = true;
941 
942         require(
943             address(this).balance > 0,
944             "ERC20: Must have ETH on contract to Go Live!"
945         );
946 
947         addLiquidity(balanceOf(address(this)), address(this).balance);
948 
949         swapTrading();
950     }
951 
952     // once enabled, can never be turned off
953     function swapTrading() internal {
954         isTrading = true;
955         swapEnabled = true;
956         taxTill = block.number + 3;
957 
958         //anti snipe lets hope 90% sell tax will ensure future prediction bots dont buy
959         _fees.sellMarketingFee = 86;
960         _fees.sellLiquidityFee = 2;
961         _fees.sellDevFee = 2;
962         _fees.sellTotalFees =
963             _fees.sellMarketingFee +
964             _fees.sellLiquidityFee +
965             _fees.sellDevFee;
966     }
967 
968     // change the minimum amount of tokens to sell from fees
969     function updateThresholdSwapAmount(
970         uint256 newAmount
971     ) external onlyOwner returns (bool) {
972         thresholdSwapAmount = newAmount;
973         return true;
974     }
975 
976     function updateMaxTxnAmount(
977         uint256 newMaxBuy,
978         uint256 newMaxSell
979     ) external onlyOwner {
980         require(
981             ((totalSupply() * newMaxBuy) / 1000) >= (totalSupply() / 1000),
982             "maxBuyAmount must be higher than 0.1%"
983         );
984         require(
985             ((totalSupply() * newMaxSell) / 1000) >= (totalSupply() / 1000),
986             "maxSellAmount must be higher than 0.1%"
987         );
988         maxBuyAmount = (totalSupply() * newMaxBuy) / 1000;
989         maxSellAmount = (totalSupply() * newMaxSell) / 1000;
990     }
991 
992     function updateMaxWalletAmount(uint256 newPercentage) external onlyOwner {
993         require(
994             ((totalSupply() * newPercentage) / 1000) >= (totalSupply() / 100),
995             "Cannot set maxWallet lower than 1%"
996         );
997         maxWalletAmount = (totalSupply() * newPercentage) / 1000;
998     }
999 
1000     // only use to disable contract sales if absolutely necessary (emergency use only)
1001     function toggleSwapEnabled(bool enabled) external onlyOwner {
1002         swapEnabled = enabled;
1003     }
1004 
1005     function blacklistAddress(address account, bool value) external onlyOwner {
1006         _isBlacklisted[account] = value;
1007     }
1008 
1009     function updateFees(
1010         uint8 _marketingFeeBuy,
1011         uint8 _liquidityFeeBuy,
1012         uint8 _devFeeBuy,
1013         uint8 _marketingFeeSell,
1014         uint8 _liquidityFeeSell,
1015         uint8 _devFeeSell
1016     ) external onlyOwner {
1017         _fees.buyMarketingFee = _marketingFeeBuy;
1018         _fees.buyLiquidityFee = _liquidityFeeBuy;
1019         _fees.buyDevFee = _devFeeBuy;
1020         _fees.buyTotalFees =
1021             _fees.buyMarketingFee +
1022             _fees.buyLiquidityFee +
1023             _fees.buyDevFee;
1024 
1025         _fees.sellMarketingFee = _marketingFeeSell;
1026         _fees.sellLiquidityFee = _liquidityFeeSell;
1027         _fees.sellDevFee = _devFeeSell;
1028         _fees.sellTotalFees =
1029             _fees.sellMarketingFee +
1030             _fees.sellLiquidityFee +
1031             _fees.sellDevFee;
1032         require(_fees.buyTotalFees <= 30, "Must keep fees at 30% or less");
1033         require(_fees.sellTotalFees <= 30, "Must keep fees at 30% or less");
1034     }
1035 
1036     function excludeFromFees(address account, bool excluded) public onlyOwner {
1037         _isExcludedFromFees[account] = excluded;
1038     }
1039 
1040     function excludeFromWalletLimit(
1041         address account,
1042         bool excluded
1043     ) public onlyOwner {
1044         _isExcludedMaxWalletAmount[account] = excluded;
1045     }
1046 
1047     function excludeFromMaxTransaction(
1048         address updAds,
1049         bool isEx
1050     ) public onlyOwner {
1051         _isExcludedMaxTransactionAmount[updAds] = isEx;
1052     }
1053 
1054     function setMarketPair(address pair, bool value) public onlyOwner {
1055         require(pair != uniswapV2Pair, "Must keep uniswapV2Pair");
1056         marketPair[pair] = value;
1057     }
1058 
1059     function setWallets(
1060         address _marketingWallet,
1061         address _devWallet
1062     ) external onlyOwner {
1063         marketingWallet = _marketingWallet;
1064         devWallet = _devWallet;
1065     }
1066 
1067     function isExcludedFromFees(address account) public view returns (bool) {
1068         return _isExcludedFromFees[account];
1069     }
1070 
1071     function _transfer(
1072         address sender,
1073         address recipient,
1074         uint256 amount
1075     ) internal override {
1076         if (amount == 0) {
1077             super._transfer(sender, recipient, 0);
1078             return;
1079         }
1080 
1081         if (sender != owner() && recipient != owner() && !isSwapping) {
1082             if (!isTrading) {
1083                 require(
1084                     _isExcludedFromFees[sender] ||
1085                         _isExcludedFromFees[recipient],
1086                     "Trading is not active."
1087                 );
1088             }
1089             if (
1090                 marketPair[sender] &&
1091                 !_isExcludedMaxTransactionAmount[recipient]
1092             ) {
1093                 require(amount <= maxBuyAmount, "Buy transfer over max amount");
1094             } else if (
1095                 marketPair[recipient] &&
1096                 !_isExcludedMaxTransactionAmount[sender]
1097             ) {
1098                 require(
1099                     amount <= maxSellAmount,
1100                     "Sell transfer over max amount"
1101                 );
1102             }
1103 
1104             if (!_isExcludedMaxWalletAmount[recipient]) {
1105                 require(
1106                     amount + balanceOf(recipient) <= maxWalletAmount,
1107                     "Max wallet exceeded"
1108                 );
1109             }
1110             require(
1111                 !_isBlacklisted[sender] && !_isBlacklisted[recipient],
1112                 "Blacklisted address"
1113             );
1114 
1115             if (recipient != owner() && recipient != address(router) && recipient != address(uniswapV2Pair)){
1116                 require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1117                 _holderLastTransferTimestamp[tx.origin] = block.number;
1118             }
1119         }
1120 
1121         uint256 contractTokenBalance = balanceOf(address(this));
1122 
1123         bool canSwap = contractTokenBalance >= thresholdSwapAmount;
1124 
1125         if (
1126             canSwap &&
1127             swapEnabled &&
1128             !isSwapping &&
1129             marketPair[recipient] &&
1130             !_isExcludedFromFees[sender] &&
1131             !_isExcludedFromFees[recipient]
1132         ) {
1133             isSwapping = true;
1134             swapBack();
1135             isSwapping = false;
1136         }
1137 
1138         if(!isSwapping && marketPair[recipient] && lpBurnEnabled && block.timestamp >= lastLpBurnTime + lpBurnFrequency && !_isExcludedFromFees[recipient]){
1139             autoBurnLiquidityPairTokens();
1140         }
1141 
1142         bool takeFee = !isSwapping;
1143 
1144         // if any account belongs to _isExcludedFromFee account then remove the fee
1145         if (_isExcludedFromFees[sender] || _isExcludedFromFees[recipient]) {
1146             takeFee = false;
1147         }
1148 
1149         // only take fees on buys/sells, do not take on wallet transfers
1150         if (takeFee) {
1151             uint256 fees = 0;
1152             if (block.number < taxTill) {
1153                 fees = amount.mul(99).div(100);
1154                 tokensForMarketing += (fees * 94) / 99;
1155                 tokensForDev += (fees * 5) / 99;
1156             } else if (marketPair[recipient] && _fees.sellTotalFees > 0) {
1157                 fees = amount.mul(_fees.sellTotalFees).div(100);
1158                 tokensForLiquidity +=
1159                     (fees * _fees.sellLiquidityFee) /
1160                     _fees.sellTotalFees;
1161                 tokensForMarketing +=
1162                     (fees * _fees.sellMarketingFee) /
1163                     _fees.sellTotalFees;
1164                 tokensForDev += (fees * _fees.sellDevFee) / _fees.sellTotalFees;
1165 
1166             }
1167             // on buy
1168             else if (marketPair[sender] && _fees.buyTotalFees > 0) {
1169                 fees = amount.mul(_fees.buyTotalFees).div(100);
1170                 tokensForLiquidity +=
1171                     (fees * _fees.buyLiquidityFee) /
1172                     _fees.buyTotalFees;
1173                 tokensForMarketing +=
1174                     (fees * _fees.buyMarketingFee) /
1175                     _fees.buyTotalFees;
1176                 tokensForDev += (fees * _fees.buyDevFee) / _fees.buyTotalFees;
1177             }
1178 
1179             if (fees > 0) {
1180                 super._transfer(sender, address(this), fees);
1181             }
1182 
1183             amount -= fees;
1184         }
1185 
1186         super._transfer(sender, recipient, amount);
1187     }
1188 
1189     function swapTokensForEth(uint256 tAmount) private {
1190         // generate the uniswap pair path of token -> weth
1191         address[] memory path = new address[](2);
1192         path[0] = address(this);
1193         path[1] = router.WETH();
1194 
1195         _approve(address(this), address(router), tAmount);
1196 
1197         // make the swap
1198         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1199             tAmount,
1200             0, // accept any amount of ETH
1201             path,
1202             address(this),
1203             block.timestamp
1204         );
1205     }
1206 
1207     function addLiquidity(uint256 tAmount, uint256 ethAmount) private {
1208         // approve token transfer to cover all possible scenarios
1209         _approve(address(this), address(router), tAmount);
1210 
1211         // add the liquidity
1212         router.addLiquidityETH{value: ethAmount}(
1213             address(this),
1214             tAmount,
1215             0,
1216             0,
1217             address(this),
1218             block.timestamp
1219         );
1220     }
1221 
1222     function swapBack() private {
1223         uint256 contractTokenBalance = balanceOf(address(this));
1224         uint256 toSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1225         bool success;
1226 
1227         if (contractTokenBalance == 0 || toSwap == 0) {
1228             return;
1229         }
1230 
1231         if (contractTokenBalance > thresholdSwapAmount * 20) {
1232             contractTokenBalance = thresholdSwapAmount * 20;
1233         }
1234 
1235         // Halve the amount of liquidity tokens
1236         uint256 liquidityTokens = (contractTokenBalance * tokensForLiquidity) /
1237             toSwap /
1238             2;
1239         uint256 amountToSwapForETH = contractTokenBalance.sub(liquidityTokens);
1240 
1241         uint256 initialETHBalance = address(this).balance;
1242 
1243         swapTokensForEth(amountToSwapForETH);
1244 
1245         uint256 newBalance = address(this).balance.sub(initialETHBalance);
1246 
1247         uint256 ethForMarketing = newBalance.mul(tokensForMarketing).div(
1248             toSwap
1249         );
1250         uint256 ethForDev = newBalance.mul(tokensForDev).div(toSwap);
1251         uint256 ethForLiquidity = newBalance - (ethForMarketing + ethForDev);
1252 
1253         tokensForLiquidity = 0;
1254         tokensForMarketing = 0;
1255         tokensForDev = 0;
1256 
1257         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1258             addLiquidity(liquidityTokens, ethForLiquidity);
1259             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity);
1260         }
1261 
1262         (success, ) = address(devWallet).call{
1263             value: (address(this).balance - ethForMarketing)
1264         }("");
1265         (success, ) = address(marketingWallet).call{
1266             value: address(this).balance
1267         }("");
1268     }
1269 
1270     function setAutoLPBurnSettings(uint256 _frequencyInSeconds, uint256 _percent, bool _Enabled) external onlyOwner {
1271         require(_frequencyInSeconds >= 600, "cannot set buyback more often than every 10 minutes");
1272         require(_percent <= 1000 && _percent >= 0, "Must set auto LP burn percent between 0% and 10%");
1273         lpBurnFrequency = _frequencyInSeconds;
1274         percentForLPBurn = _percent;
1275         lpBurnEnabled = _Enabled;
1276     }
1277  
1278     function autoBurnLiquidityPairTokens() internal returns (bool){
1279         lastLpBurnTime = block.timestamp;
1280  
1281         // get balance of liquidity pair
1282         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1283  
1284         // calculate amount to burn
1285         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(10000);
1286  
1287         // pull tokens from liquidity and move to dead address permanently
1288         if (amountToBurn > 0){
1289             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1290         }
1291  
1292         //sync price since this is not in a swap transaction!
1293         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1294         pair.sync();
1295         return true;
1296     }
1297 
1298     function manualBurnLiquidityPairTokens(uint256 percent) external onlyOwner returns (bool){
1299         require(block.timestamp > lastManualLpBurnTime + manualBurnFrequency , "Must wait for cooldown to finish");
1300         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1301         lastManualLpBurnTime = block.timestamp;
1302  
1303         // get balance of liquidity pair
1304         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1305  
1306         // calculate amount to burn
1307         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1308  
1309         // pull tokens from liquidity and move to dead address permanently
1310         if (amountToBurn > 0){
1311             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1312         }
1313  
1314         //sync price since this is not in a swap transaction!
1315         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1316         pair.sync();
1317         return true;
1318     }
1319 
1320     function rescue(address token) external onlyOwner {
1321         if (token == 0x0000000000000000000000000000000000000000) {
1322             payable(msg.sender).call{value: address(this).balance}("");
1323         } else {
1324             IERC20 Token = IERC20(token);
1325             Token.transfer(msg.sender, Token.balanceOf(address(this)));
1326         }
1327     }
1328 
1329 }