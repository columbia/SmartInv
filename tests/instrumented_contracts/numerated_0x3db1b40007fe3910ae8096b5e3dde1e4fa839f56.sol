1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.9;
3 
4 /*
5     █▀   █░█   █   █▄▄   ▄▀█   █▀█   █   █░█   █▀▄▀█
6     ▄█   █▀█   █   █▄█   █▀█   █▀▄   █   █▄█   █░▀░█
7 
8     █▀▄   █▀█   █▀▀     █▀█   ▄▀█   █▀█   █▄▀
9     █▄▀   █▄█   █▄█     █▀▀   █▀█   █▀▄   █░█
10 
11     ※ https://www.shibariumdogpark.com/
12     ※ https://t.me/ShibariumDogPark
13     ※ https://medium.com/@shibariumdogpark
14     ※ https://twitter.com/Shibarium_PARK
15 */
16 
17 interface IUniswapV2Factory {
18     function createPair(address tokenA, address tokenB) external returns(address pair);
19 }
20 
21 interface IERC20 {
22     /**
23      * @dev Returns the amount of tokens in existence.
24      */
25     function totalSupply() external view returns(uint256);
26 
27     /**
28     * @dev Returns the amount of tokens owned by `account`.
29     */
30     function balanceOf(address account) external view returns(uint256);
31 
32     /**
33     * @dev Moves `amount` tokens from the caller's account to `recipient`.
34     *
35     * Returns a boolean value indicating whether the operation succeeded.
36     *
37     * Emits a {Transfer} event.
38     */
39     function transfer(address recipient, uint256 amount) external returns(bool);
40 
41     /**
42     * @dev Returns the remaining number of tokens that `spender` will be
43     * allowed to spend on behalf of `owner` through {transferFrom}. This is
44     * zero by default.
45     *
46     * This value changes when {approve} or {transferFrom} are called.
47     */
48     function allowance(address owner, address spender) external view returns(uint256);
49 
50     /**
51     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
52     *
53     * Returns a boolean value indicating whether the operation succeeded.
54     *
55     * IMPORTANT: Beware that changing an allowance with this method brings the risk
56     * that someone may use both the old and the new allowance by unfortunate
57     * transaction ordering. One possible solution to mitigate this race
58     * condition is to first reduce the spender's allowance to 0 and set the
59     * desired value afterwards:
60     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
61     *
62     * Emits an {Approval} event.
63     */
64     function approve(address spender, uint256 amount) external returns(bool);
65 
66     /**
67     * @dev Moves `amount` tokens from `sender` to `recipient` using the
68     * allowance mechanism. `amount` is then deducted from the caller's
69     * allowance.
70     *
71     * Returns a boolean value indicating whether the operation succeeded.
72     *
73     * Emits a {Transfer} event.
74     */
75     function transferFrom(
76         address sender,
77         address recipient,
78         uint256 amount
79     ) external returns(bool);
80 
81         /**
82         * @dev Emitted when `value` tokens are moved from one account (`from`) to
83         * another (`to`).
84         *
85         * Note that `value` may be zero.
86         */
87         event Transfer(address indexed from, address indexed to, uint256 value);
88 
89         /**
90         * @dev Emitted when the allowance of a `spender` for an `owner` is set by
91         * a call to {approve}. `value` is the new allowance.
92         */
93         event Approval(address indexed owner, address indexed spender, uint256 value);
94 }
95 
96 interface IERC20Metadata is IERC20 {
97     /**
98      * @dev Returns the name of the token.
99      */
100     function name() external view returns(string memory);
101 
102     /**
103      * @dev Returns the symbol of the token.
104      */
105     function symbol() external view returns(string memory);
106 
107     /**
108      * @dev Returns the decimals places of the token.
109      */
110     function decimals() external view returns(uint8);
111 }
112 
113 abstract contract Context {
114     function _msgSender() internal view virtual returns(address) {
115         return msg.sender;
116     }
117 
118 }
119 
120 contract ERC20 is Context, IERC20, IERC20Metadata {
121     using SafeMath for uint256;
122 
123         mapping(address => uint256) private _balances;
124 
125     mapping(address => mapping(address => uint256)) private _allowances;
126  
127     uint256 private _totalSupply;
128  
129     string private _name;
130     string private _symbol;
131 
132     /**
133      * @dev Sets the values for {name} and {symbol}.
134      *
135      * The default value of {decimals} is 18. To select a different value for
136      * {decimals} you should overload it.
137      *
138      * All two of these values are immutable: they can only be set once during
139      * construction.
140      */
141     constructor(string memory name_, string memory symbol_) {
142         _name = name_;
143         _symbol = symbol_;
144     }
145 
146     /**
147      * @dev Returns the name of the token.
148      */
149     function name() public view virtual override returns(string memory) {
150         return _name;
151     }
152 
153     /**
154      * @dev Returns the symbol of the token, usually a shorter version of the
155      * name.
156      */
157     function symbol() public view virtual override returns(string memory) {
158         return _symbol;
159     }
160 
161     /**
162      * @dev Returns the number of decimals used to get its user representation.
163      * For example, if `decimals` equals `2`, a balance of `505` tokens should
164      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
165      *
166      * Tokens usually opt for a value of 18, imitating the relationship between
167      * Ether and Wei. This is the value {ERC20} uses, unless this function is
168      * overridden;
169      *
170      * NOTE: This information is only used for _display_ purposes: it in
171      * no way affects any of the arithmetic of the contract, including
172      * {IERC20-balanceOf} and {IERC20-transfer}.
173      */
174     function decimals() public view virtual override returns(uint8) {
175         return 18;
176     }
177 
178     /**
179      * @dev See {IERC20-totalSupply}.
180      */
181     function totalSupply() public view virtual override returns(uint256) {
182         return _totalSupply;
183     }
184 
185     /**
186      * @dev See {IERC20-balanceOf}.
187      */
188     function balanceOf(address account) public view virtual override returns(uint256) {
189         return _balances[account];
190     }
191 
192     /**
193      * @dev See {IERC20-transfer}.
194      *
195      * Requirements:
196      *
197      * - `recipient` cannot be the zero address.
198      * - the caller must have a balance of at least `amount`.
199      */
200     function transfer(address recipient, uint256 amount) public virtual override returns(bool) {
201         _transfer(_msgSender(), recipient, amount);
202         return true;
203     }
204 
205     /**
206      * @dev See {IERC20-allowance}.
207      */
208     function allowance(address owner, address spender) public view virtual override returns(uint256) {
209         return _allowances[owner][spender];
210     }
211 
212     /**
213      * @dev See {IERC20-approve}.
214      *
215      * Requirements:
216      *
217      * - `spender` cannot be the zero address.
218      */
219     function approve(address spender, uint256 amount) public virtual override returns(bool) {
220         _approve(_msgSender(), spender, amount);
221         return true;
222     }
223 
224     /**
225      * @dev See {IERC20-transferFrom}.
226      *
227      * Emits an {Approval} event indicating the updated allowance. This is not
228      * required by the EIP. See the note at the beginning of {ERC20}.
229      *
230      * Requirements:
231      *
232      * - `sender` and `recipient` cannot be the zero address.
233      * - `sender` must have a balance of at least `amount`.
234      * - the caller must have allowance for ``sender``'s tokens of at least
235      * `amount`.
236      */
237     function transferFrom(
238         address sender,
239         address recipient,
240         uint256 amount
241     ) public virtual override returns(bool) {
242         _transfer(sender, recipient, amount);
243         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
244         return true;
245     }
246 
247     /**
248      * @dev Atomically increases the allowance granted to `spender` by the caller.
249      *
250      * This is an alternative to {approve} that can be used as a mitigation for
251      * problems described in {IERC20-approve}.
252      *
253      * Emits an {Approval} event indicating the updated allowance.
254      *
255      * Requirements:
256      *
257      * - `spender` cannot be the zero address.
258      */
259     function increaseAllowance(address spender, uint256 addedValue) public virtual returns(bool) {
260         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
261         return true;
262     }
263 
264     /**
265      * @dev Atomically decreases the allowance granted to `spender` by the caller.
266      *
267      * This is an alternative to {approve} that can be used as a mitigation for
268      * problems described in {IERC20-approve}.
269      *
270      * Emits an {Approval} event indicating the updated allowance.
271      *
272      * Requirements:
273      *
274      * - `spender` cannot be the zero address.
275      * - `spender` must have allowance for the caller of at least
276      * `subtractedValue`.
277      */
278     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns(bool) {
279         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased cannot be below zero"));
280         return true;
281     }
282 
283     /**
284      * @dev Moves tokens `amount` from `sender` to `recipient`.
285      *
286      * This is internal function is equivalent to {transfer}, and can be used to
287      * e.g. implement automatic token fees, slashing mechanisms, etc.
288      *
289      * Emits a {Transfer} event.
290      *
291      * Requirements:
292      *
293      * - `sender` cannot be the zero address.
294      * - `recipient` cannot be the zero address.
295      * - `sender` must have a balance of at least `amount`.
296      */
297     function _transfer(
298         address sender,
299         address recipient,
300         uint256 amount
301     ) internal virtual {
302         
303         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
304         _balances[recipient] = _balances[recipient].add(amount);
305         emit Transfer(sender, recipient, amount);
306     }
307 
308     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
309      * the total supply.
310      *
311      * Emits a {Transfer} event with `from` set to the zero address.
312      *
313      * Requirements:
314      *
315      * - `account` cannot be the zero address.
316      */
317     function _mint(address account, uint256 amount) internal virtual {
318         require(account != address(0), "ERC20: mint to the zero address");
319 
320         _totalSupply = _totalSupply.add(amount);
321         _balances[account] = _balances[account].add(amount);
322         emit Transfer(address(0), account, amount);
323     }
324 
325     
326     /**
327      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
328      *
329      * This internal function is equivalent to `approve`, and can be used to
330      * e.g. set automatic allowances for certain subsystems, etc.
331      *
332      * Emits an {Approval} event.
333      *
334      * Requirements:
335      *
336      * - `owner` cannot be the zero address.
337      * - `spender` cannot be the zero address.
338      */
339     function _approve(
340         address owner,
341         address spender,
342         uint256 amount
343     ) internal virtual {
344         _allowances[owner][spender] = amount;
345         emit Approval(owner, spender, amount);
346     }
347 
348     
349 }
350  
351 library SafeMath {
352    
353     function add(uint256 a, uint256 b) internal pure returns(uint256) {
354         uint256 c = a + b;
355         require(c >= a, "SafeMath: addition overflow");
356 
357         return c;
358     }
359 
360    
361     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
362         return sub(a, b, "SafeMath: subtraction overflow");
363     }
364 
365    
366     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns(uint256) {
367         require(b <= a, errorMessage);
368         uint256 c = a - b;
369 
370         return c;
371     }
372 
373     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
374     
375         if (a == 0) {
376             return 0;
377         }
378  
379         uint256 c = a * b;
380         require(c / a == b, "SafeMath: multiplication overflow");
381 
382         return c;
383     }
384 
385  
386     function div(uint256 a, uint256 b) internal pure returns(uint256) {
387         return div(a, b, "SafeMath: division by zero");
388     }
389 
390   
391     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns(uint256) {
392         require(b > 0, errorMessage);
393         uint256 c = a / b;
394         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
395 
396         return c;
397     }
398 
399     
400 }
401  
402 contract Ownable is Context {
403     address private _owner;
404  
405     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
406 
407     /**
408      * @dev Initializes the contract setting the deployer as the initial owner.
409      */
410     constructor() {
411         address msgSender = _msgSender();
412         _owner = msgSender;
413         emit OwnershipTransferred(address(0), msgSender);
414     }
415 
416     /**
417      * @dev Returns the address of the current owner.
418      */
419     function owner() public view returns(address) {
420         return _owner;
421     }
422 
423     /**
424      * @dev Throws if called by any account other than the owner.
425      */
426     modifier onlyOwner() {
427         require(_owner == _msgSender(), "Ownable: caller is not the owner");
428         _;
429     }
430 
431     /**
432      * @dev Leaves the contract without owner. It will not be possible to call
433      * `onlyOwner` functions anymore. Can only be called by the current owner.
434      *
435      * NOTE: Renouncing ownership will leave the contract without an owner,
436      * thereby removing any functionality that is only available to the owner.
437      */
438     function renounceOwnership() public virtual onlyOwner {
439         emit OwnershipTransferred(_owner, address(0));
440         _owner = address(0);
441     }
442 
443     /**
444      * @dev Transfers ownership of the contract to a new account (`newOwner`).
445      * Can only be called by the current owner.
446      */
447     function transferOwnership(address newOwner) public virtual onlyOwner {
448         require(newOwner != address(0), "Ownable: new owner is the zero address");
449         emit OwnershipTransferred(_owner, newOwner);
450         _owner = newOwner;
451     }
452 }
453  
454 library SafeMathInt {
455     int256 private constant MIN_INT256 = int256(1) << 255;
456     int256 private constant MAX_INT256 = ~(int256(1) << 255);
457 
458     /**
459      * @dev Multiplies two int256 variables and fails on overflow.
460      */
461     function mul(int256 a, int256 b) internal pure returns(int256) {
462         int256 c = a * b;
463 
464         // Detect overflow when multiplying MIN_INT256 with -1
465         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
466         require((b == 0) || (c / b == a));
467         return c;
468     }
469 
470     /**
471      * @dev Division of two int256 variables and fails on overflow.
472      */
473     function div(int256 a, int256 b) internal pure returns(int256) {
474         // Prevent overflow when dividing MIN_INT256 by -1
475         require(b != -1 || a != MIN_INT256);
476 
477         // Solidity already throws when dividing by 0.
478         return a / b;
479     }
480 
481     /**
482      * @dev Subtracts two int256 variables and fails on overflow.
483      */
484     function sub(int256 a, int256 b) internal pure returns(int256) {
485         int256 c = a - b;
486         require((b >= 0 && c <= a) || (b < 0 && c > a));
487         return c;
488     }
489 
490     /**
491      * @dev Adds two int256 variables and fails on overflow.
492      */
493     function add(int256 a, int256 b) internal pure returns(int256) {
494         int256 c = a + b;
495         require((b >= 0 && c >= a) || (b < 0 && c < a));
496         return c;
497     }
498 
499     /**
500      * @dev Converts to absolute value, and fails on overflow.
501      */
502     function abs(int256 a) internal pure returns(int256) {
503         require(a != MIN_INT256);
504         return a < 0 ? -a : a;
505     }
506 
507 
508     function toUint256Safe(int256 a) internal pure returns(uint256) {
509         require(a >= 0);
510         return uint256(a);
511     }
512 }
513  
514 library SafeMathUint {
515     function toInt256Safe(uint256 a) internal pure returns(int256) {
516     int256 b = int256(a);
517         require(b >= 0);
518         return b;
519     }
520 }
521 
522 interface IUniswapV2Router01 {
523     function factory() external pure returns(address);
524     function WETH() external pure returns(address);
525 
526     function addLiquidity(
527         address tokenA,
528         address tokenB,
529         uint amountADesired,
530         uint amountBDesired,
531         uint amountAMin,
532         uint amountBMin,
533         address to,
534         uint deadline
535     ) external returns(uint amountA, uint amountB, uint liquidity);
536     function addLiquidityETH(
537         address token,
538         uint amountTokenDesired,
539         uint amountTokenMin,
540         uint amountETHMin,
541         address to,
542         uint deadline
543     ) external payable returns(uint amountToken, uint amountETH, uint liquidity);
544     function removeLiquidity(
545         address tokenA,
546         address tokenB,
547         uint liquidity,
548         uint amountAMin,
549         uint amountBMin,
550         address to,
551         uint deadline
552     ) external returns(uint amountA, uint amountB);
553     function removeLiquidityETH(
554         address token,
555         uint liquidity,
556         uint amountTokenMin,
557         uint amountETHMin,
558         address to,
559         uint deadline
560     ) external returns(uint amountToken, uint amountETH);
561     function removeLiquidityWithPermit(
562         address tokenA,
563         address tokenB,
564         uint liquidity,
565         uint amountAMin,
566         uint amountBMin,
567         address to,
568         uint deadline,
569         bool approveMax, uint8 v, bytes32 r, bytes32 s
570     ) external returns(uint amountA, uint amountB);
571     function removeLiquidityETHWithPermit(
572         address token,
573         uint liquidity,
574         uint amountTokenMin,
575         uint amountETHMin,
576         address to,
577         uint deadline,
578         bool approveMax, uint8 v, bytes32 r, bytes32 s
579     ) external returns(uint amountToken, uint amountETH);
580     function swapExactTokensForTokens(
581         uint amountIn,
582         uint amountOutMin,
583         address[] calldata path,
584         address to,
585         uint deadline
586     ) external returns(uint[] memory amounts);
587     function swapTokensForExactTokens(
588         uint amountOut,
589         uint amountInMax,
590         address[] calldata path,
591         address to,
592         uint deadline
593     ) external returns(uint[] memory amounts);
594     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
595     external
596     payable
597     returns(uint[] memory amounts);
598     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
599     external
600     returns(uint[] memory amounts);
601     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
602     external
603     returns(uint[] memory amounts);
604     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
605     external
606     payable
607     returns(uint[] memory amounts);
608 
609     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns(uint amountB);
610     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns(uint amountOut);
611     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns(uint amountIn);
612     function getAmountsOut(uint amountIn, address[] calldata path) external view returns(uint[] memory amounts);
613     function getAmountsIn(uint amountOut, address[] calldata path) external view returns(uint[] memory amounts);
614 }
615 
616 interface IUniswapV2Router02 is IUniswapV2Router01 {
617     function removeLiquidityETHSupportingFeeOnTransferTokens(
618         address token,
619         uint liquidity,
620         uint amountTokenMin,
621         uint amountETHMin,
622         address to,
623         uint deadline
624     ) external returns(uint amountETH);
625     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
626         address token,
627         uint liquidity,
628         uint amountTokenMin,
629         uint amountETHMin,
630         address to,
631         uint deadline,
632         bool approveMax, uint8 v, bytes32 r, bytes32 s
633     ) external returns(uint amountETH);
634 
635     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
636         uint amountIn,
637         uint amountOutMin,
638         address[] calldata path,
639         address to,
640         uint deadline
641     ) external;
642     function swapExactETHForTokensSupportingFeeOnTransferTokens(
643         uint amountOutMin,
644         address[] calldata path,
645         address to,
646         uint deadline
647     ) external payable;
648     function swapExactTokensForETHSupportingFeeOnTransferTokens(
649         uint amountIn,
650         uint amountOutMin,
651         address[] calldata path,
652         address to,
653         uint deadline
654     ) external;
655 }
656  
657 contract ShibariumDogPark is ERC20, Ownable {
658     using SafeMath for uint256;
659 
660     IUniswapV2Router02 public immutable router;
661     address public immutable uniswapV2Pair;
662 
663     // addresses
664     address private developmentWallet;
665     address private marketingWallet;
666 
667     // limits 
668     uint256 private maxBuyAmount;
669     uint256 private maxSellAmount;   
670     uint256 private maxWalletAmount;
671  
672     uint256 private thresholdSwapAmount;
673 
674     // status flags
675     bool private isTrading = false;
676     bool public swapEnabled = false;
677     bool public isSwapping;
678 
679     struct Fees {
680         uint256 buyTotalFees;
681         uint256 buyMarketingFee;
682         uint256 buyDevelopmentFee;
683         uint256 buyLiquidityFee;
684 
685         uint256 sellTotalFees;
686         uint256 sellMarketingFee;
687         uint256 sellDevelopmentFee;
688         uint256 sellLiquidityFee;
689     }  
690 
691     Fees public _fees = Fees({
692         buyTotalFees: 0,
693         buyMarketingFee: 0,
694         buyDevelopmentFee:0,
695         buyLiquidityFee: 0,
696 
697         sellTotalFees: 0,
698         sellMarketingFee: 0,
699         sellDevelopmentFee:0,
700         sellLiquidityFee: 0
701     });
702 
703     uint256 public tokensForMarketing;
704     uint256 public tokensForLiquidity;
705     uint256 public tokensForDevelopment;
706     uint256 private taxTill;
707 
708     // exclude from fees and max transaction amount
709     mapping(address => bool) private _isExcludedFromFees;
710     mapping(address => bool) public _isExcludedMaxTransactionAmount;
711     mapping(address => bool) public _isExcludedMaxWalletAmount;
712 
713     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
714     // could be subject to a maximum transfer amount
715     mapping(address => bool) public marketPair;
716  
717   
718     event SwapAndLiquify(
719         uint256 tokensSwapped,
720         uint256 ethReceived
721     );
722 
723     constructor() ERC20("Shibarium Dog Park", "SDP") {
724  
725         router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
726 
727         uniswapV2Pair = IUniswapV2Factory(router.factory()).createPair(address(this), router.WETH());
728 
729         _isExcludedMaxTransactionAmount[address(router)] = true;
730         _isExcludedMaxTransactionAmount[address(uniswapV2Pair)] = true;        
731         _isExcludedMaxTransactionAmount[owner()] = true;
732         _isExcludedMaxTransactionAmount[address(this)] = true;
733         _isExcludedMaxTransactionAmount[address(0xdead)] = true;
734 
735         _isExcludedFromFees[owner()] = true;
736         _isExcludedFromFees[address(this)] = true;
737 
738         _isExcludedMaxWalletAmount[owner()] = true;
739         _isExcludedMaxWalletAmount[address(0xdead)] = true;
740         _isExcludedMaxWalletAmount[address(this)] = true;
741         _isExcludedMaxWalletAmount[address(uniswapV2Pair)] = true;
742 
743         marketPair[address(uniswapV2Pair)] = true;
744 
745         approve(address(router), type(uint256).max);
746 
747         uint256 totalSupply = 1e9 * 1e18;
748         maxBuyAmount = totalSupply * 1 / 100; // 1% maxBuyAmount
749         maxSellAmount = totalSupply * 1 / 100; // 1% maxSellAmount
750         maxWalletAmount = totalSupply * 1 / 100; // 1% maxWallet
751         thresholdSwapAmount = totalSupply * 1 / 1000; 
752 
753         _fees.buyMarketingFee = 70;
754         _fees.buyLiquidityFee = 0;
755         _fees.buyDevelopmentFee = 0;
756         _fees.buyTotalFees = _fees.buyMarketingFee + _fees.buyLiquidityFee + _fees.buyDevelopmentFee;
757 
758         _fees.sellMarketingFee = 70;
759         _fees.sellLiquidityFee = 0;
760         _fees.sellDevelopmentFee = 0;
761         _fees.sellTotalFees = _fees.sellMarketingFee + _fees.sellLiquidityFee + _fees.sellDevelopmentFee;
762 
763         marketingWallet = address(0x9e4ffabbbd9A5E448Cbfc47DF612150092E059e7);
764         developmentWallet = address(0x9e4ffabbbd9A5E448Cbfc47DF612150092E059e7);
765 
766         // exclude from paying fees or having max transaction amount
767 
768         /*
769             _mint is an internal function in ERC20.sol that is only called here,
770             and CANNOT be called ever again
771         */
772         _mint(msg.sender, totalSupply);
773     }
774 
775     receive() external payable {
776 
777     }
778 
779     // once enabled, can never be turned off
780     function enableTrading() external onlyOwner {
781         isTrading = true;
782         swapEnabled = true;
783         taxTill = block.number + 0;
784     }
785 
786     // change the minimum amount of tokens to sell from fees
787     function updateThresholdSwapAmount(uint256 newAmount) external onlyOwner returns(bool){
788         thresholdSwapAmount = newAmount;
789         return true;
790     }
791 
792     function updateMaxTxnAmount(uint256 newMaxBuy, uint256 newMaxSell) public onlyOwner {
793         maxBuyAmount = (totalSupply() * newMaxBuy) / 1000;
794         maxSellAmount = (totalSupply() * newMaxSell) / 1000;
795     }
796 
797     function updateMaxWalletAmount(uint256 newPercentage) public onlyOwner {
798         maxWalletAmount = (totalSupply() * newPercentage) / 1000;
799     }
800 
801     // only use to disable contract sales if absolutely necessary (emergency use only)
802     function toggleSwapEnabled(bool enabled) external onlyOwner(){
803         swapEnabled = enabled;
804     }
805 
806     function updateFees(uint256 _marketingFeeBuy, uint256 _liquidityFeeBuy,uint256 _developmentFeeBuy,uint256 _marketingFeeSell, uint256 _liquidityFeeSell,uint256 _developmentFeeSell) external onlyOwner{
807         _fees.buyMarketingFee = _marketingFeeBuy;
808         _fees.buyLiquidityFee = _liquidityFeeBuy;
809         _fees.buyDevelopmentFee = _developmentFeeBuy;
810         _fees.buyTotalFees = _fees.buyMarketingFee + _fees.buyLiquidityFee + _fees.buyDevelopmentFee;
811 
812         _fees.sellMarketingFee = _marketingFeeSell;
813         _fees.sellLiquidityFee = _liquidityFeeSell;
814         _fees.sellDevelopmentFee = _developmentFeeSell;
815         _fees.sellTotalFees = _fees.sellMarketingFee + _fees.sellLiquidityFee + _fees.sellDevelopmentFee;
816         require(_fees.buyTotalFees <= 70, "Must keep fees at 70% or less");   
817         require(_fees.sellTotalFees <= 70, "Must keep fees at 70% or less");
818     }
819     
820     function excludeFromFees(address account, bool excluded) public onlyOwner {
821         _isExcludedFromFees[account] = excluded;
822     }
823     function excludeFromWalletLimit(address account, bool excluded) public onlyOwner {
824         _isExcludedMaxWalletAmount[account] = excluded;
825     }
826     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
827         _isExcludedMaxTransactionAmount[updAds] = isEx;
828     }
829 
830     function removeLimits() external onlyOwner {
831         updateMaxTxnAmount(1000,1000);
832         updateMaxWalletAmount(1000);
833     }
834 
835     function setMarketPair(address pair, bool value) public onlyOwner {
836         require(pair != uniswapV2Pair, "The pair cannot be removed from marketPair");
837         marketPair[pair] = value;
838     }
839 
840     function setWallets(address _marketingWallet,address _developmentWallet) external onlyOwner{
841         marketingWallet = _marketingWallet;
842         developmentWallet = _developmentWallet;
843     }
844 
845     function isExcludedFromFees(address account) public view returns(bool) {
846         return _isExcludedFromFees[account];
847     }
848 
849     function _transfer(
850         address sender,
851         address recipient,
852         uint256 amount
853     ) internal override {
854         
855         if (amount == 0) {
856             super._transfer(sender, recipient, 0);
857             return;
858         }
859 
860         if (
861             sender != owner() &&
862             recipient != owner() &&
863             !isSwapping
864         ) {
865 
866             if (!isTrading) {
867                 require(_isExcludedFromFees[sender] || _isExcludedFromFees[recipient], "Trading is not active.");
868             }
869             if (marketPair[sender] && !_isExcludedMaxTransactionAmount[recipient]) {
870                 require(amount <= maxBuyAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
871             } 
872             else if (marketPair[recipient] && !_isExcludedMaxTransactionAmount[sender]) {
873                 require(amount <= maxSellAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
874             }
875 
876             if (!_isExcludedMaxWalletAmount[recipient]) {
877                 require(amount + balanceOf(recipient) <= maxWalletAmount, "Max wallet exceeded");
878             }
879 
880         }
881  
882         uint256 contractTokenBalance = balanceOf(address(this));
883  
884         bool canSwap = contractTokenBalance >= thresholdSwapAmount;
885 
886         if (
887             canSwap &&
888             swapEnabled &&
889             !isSwapping &&
890             marketPair[recipient] &&
891             !_isExcludedFromFees[sender] &&
892             !_isExcludedFromFees[recipient]
893         ) {
894             isSwapping = true;
895             swapBack();
896             isSwapping = false;
897         }
898  
899         bool takeFee = !isSwapping;
900 
901         // if any account belongs to _isExcludedFromFee account then remove the fee
902         if (_isExcludedFromFees[sender] || _isExcludedFromFees[recipient]) {
903             takeFee = false;
904         }
905  
906         
907         // only take fees on buys/sells, do not take on wallet transfers
908         if (takeFee) {
909             uint256 fees = 0;
910             if(block.number < taxTill) {
911                 fees = amount.mul(99).div(100);
912                 tokensForMarketing += (fees * 94) / 99;
913                 tokensForDevelopment += (fees * 5) / 99;
914             } else if (marketPair[recipient] && _fees.sellTotalFees > 0) {
915                 fees = amount.mul(_fees.sellTotalFees).div(100);
916                 tokensForLiquidity += fees * _fees.sellLiquidityFee / _fees.sellTotalFees;
917                 tokensForMarketing += fees * _fees.sellMarketingFee / _fees.sellTotalFees;
918                 tokensForDevelopment += fees * _fees.sellDevelopmentFee / _fees.sellTotalFees;
919             }
920             // on buy
921             else if (marketPair[sender] && _fees.buyTotalFees > 0) {
922                 fees = amount.mul(_fees.buyTotalFees).div(100);
923                 tokensForLiquidity += fees * _fees.buyLiquidityFee / _fees.buyTotalFees;
924                 tokensForMarketing += fees * _fees.buyMarketingFee / _fees.buyTotalFees;
925                 tokensForDevelopment += fees * _fees.buyDevelopmentFee / _fees.buyTotalFees;
926             }
927 
928             if (fees > 0) {
929                 super._transfer(sender, address(this), fees);
930             }
931 
932             amount -= fees;
933 
934         }
935 
936         super._transfer(sender, recipient, amount);
937     }
938 
939     function swapTokensForEth(uint256 tAmount) private {
940 
941         // generate the uniswap pair path of token -> weth
942         address[] memory path = new address[](2);
943         path[0] = address(this);
944         path[1] = router.WETH();
945 
946         _approve(address(this), address(router), tAmount);
947 
948         // make the swap
949         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
950             tAmount,
951             0, // accept any amount of ETH
952             path,
953             address(this),
954             block.timestamp
955         );
956 
957     }
958 
959     function addLiquidity(uint256 tAmount, uint256 ethAmount) private {
960         // approve token transfer to cover all possible scenarios
961         _approve(address(this), address(router), tAmount);
962 
963         // add the liquidity
964         router.addLiquidityETH{ value: ethAmount } (address(this), tAmount, 0, 0 , address(this), block.timestamp);
965     }
966 
967     function swapBack() private {
968         uint256 contractTokenBalance = balanceOf(address(this));
969         uint256 toSwap = tokensForLiquidity + tokensForMarketing + tokensForDevelopment;
970         bool success;
971 
972         if (contractTokenBalance == 0 || toSwap == 0) { return; }
973 
974         if (contractTokenBalance > thresholdSwapAmount * 20) {
975             contractTokenBalance = thresholdSwapAmount * 20;
976         }
977 
978         // Halve the amount of liquidity tokens
979         uint256 liquidityTokens = contractTokenBalance * tokensForLiquidity / toSwap / 2;
980         uint256 amountToSwapForETH = contractTokenBalance.sub(liquidityTokens);
981  
982         uint256 initialETHBalance = address(this).balance;
983 
984         swapTokensForEth(amountToSwapForETH); 
985  
986         uint256 newBalance = address(this).balance.sub(initialETHBalance);
987  
988         uint256 ethForMarketing = newBalance.mul(tokensForMarketing).div(toSwap);
989         uint256 ethForDevelopment = newBalance.mul(tokensForDevelopment).div(toSwap);
990         uint256 ethForLiquidity = newBalance - (ethForMarketing + ethForDevelopment);
991 
992 
993         tokensForLiquidity = 0;
994         tokensForMarketing = 0;
995         tokensForDevelopment = 0;
996 
997 
998         if (liquidityTokens > 0 && ethForLiquidity > 0) {
999             addLiquidity(liquidityTokens, ethForLiquidity);
1000             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity);
1001         }
1002 
1003         (success,) = address(developmentWallet).call{ value: (address(this).balance - ethForMarketing) } ("");
1004         (success,) = address(marketingWallet).call{ value: address(this).balance } ("");
1005     }
1006 
1007 }