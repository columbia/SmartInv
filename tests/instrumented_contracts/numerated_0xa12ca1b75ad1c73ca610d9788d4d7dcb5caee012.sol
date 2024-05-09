1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.9;
3 
4 // https://www.pulseheartbridge.com/
5 // https://twitter.com/HeartBridgeCoin
6 // https://t.me/HeartBridgeCoin
7 
8 interface IUniswapV2Factory {
9     function createPair(address tokenA, address tokenB) external returns(address pair);
10 }
11 
12 interface IERC20 {
13     /**
14      * @dev Returns the amount of tokens in existence.
15      */
16     function totalSupply() external view returns(uint256);
17 
18     /**
19     * @dev Returns the amount of tokens owned by `account`.
20     */
21     function balanceOf(address account) external view returns(uint256);
22 
23     /**
24     * @dev Moves `amount` tokens from the caller's account to `recipient`.
25     *
26     * Returns a boolean value indicating whether the operation succeeded.
27     *
28     * Emits a {Transfer} event.
29     */
30     function transfer(address recipient, uint256 amount) external returns(bool);
31 
32     /**
33     * @dev Returns the remaining number of tokens that `spender` will be
34     * allowed to spend on behalf of `owner` through {transferFrom}. This is
35     * zero by default.
36     *
37     * This value changes when {approve} or {transferFrom} are called.
38     */
39     function allowance(address owner, address spender) external view returns(uint256);
40 
41     /**
42     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
43     *
44     * Returns a boolean value indicating whether the operation succeeded.
45     *
46     * IMPORTANT: Beware that changing an allowance with this method brings the risk
47     * that someone may use both the old and the new allowance by unfortunate
48     * transaction ordering. One possible solution to mitigate this race
49     * condition is to first reduce the spender's allowance to 0 and set the
50     * desired value afterwards:
51     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
52     *
53     * Emits an {Approval} event.
54     */
55     function approve(address spender, uint256 amount) external returns(bool);
56 
57     /**
58     * @dev Moves `amount` tokens from `sender` to `recipient` using the
59     * allowance mechanism. `amount` is then deducted from the caller's
60     * allowance.
61     *
62     * Returns a boolean value indicating whether the operation succeeded.
63     *
64     * Emits a {Transfer} event.
65     */
66     function transferFrom(
67         address sender,
68         address recipient,
69         uint256 amount
70     ) external returns(bool);
71 
72         /**
73         * @dev Emitted when `value` tokens are moved from one account (`from`) to
74         * another (`to`).
75         *
76         * Note that `value` may be zero.
77         */
78         event Transfer(address indexed from, address indexed to, uint256 value);
79 
80         /**
81         * @dev Emitted when the allowance of a `spender` for an `owner` is set by
82         * a call to {approve}. `value` is the new allowance.
83         */
84         event Approval(address indexed owner, address indexed spender, uint256 value);
85 }
86 
87 interface IERC20Metadata is IERC20 {
88     /**
89      * @dev Returns the name of the token.
90      */
91     function name() external view returns(string memory);
92 
93     /**
94      * @dev Returns the symbol of the token.
95      */
96     function symbol() external view returns(string memory);
97 
98     /**
99      * @dev Returns the decimals places of the token.
100      */
101     function decimals() external view returns(uint8);
102 }
103 
104 abstract contract Context {
105     function _msgSender() internal view virtual returns(address) {
106         return msg.sender;
107     }
108 
109 }
110 
111 contract ERC20 is Context, IERC20, IERC20Metadata {
112     using SafeMath for uint256;
113 
114         mapping(address => uint256) private _balances;
115 
116     mapping(address => mapping(address => uint256)) private _allowances;
117  
118     uint256 private _totalSupply;
119  
120     string private _name;
121     string private _symbol;
122 
123     /**
124      * @dev Sets the values for {name} and {symbol}.
125      *
126      * The default value of {decimals} is 18. To select a different value for
127      * {decimals} you should overload it.
128      *
129      * All two of these values are immutable: they can only be set once during
130      * construction.
131      */
132     constructor(string memory name_, string memory symbol_) {
133         _name = name_;
134         _symbol = symbol_;
135     }
136 
137     /**
138      * @dev Returns the name of the token.
139      */
140     function name() public view virtual override returns(string memory) {
141         return _name;
142     }
143 
144     /**
145      * @dev Returns the symbol of the token, usually a shorter version of the
146      * name.
147      */
148     function symbol() public view virtual override returns(string memory) {
149         return _symbol;
150     }
151 
152     /**
153      * @dev Returns the number of decimals used to get its user representation.
154      * For example, if `decimals` equals `2`, a balance of `505` tokens should
155      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
156      *
157      * Tokens usually opt for a value of 18, imitating the relationship between
158      * Ether and Wei. This is the value {ERC20} uses, unless this function is
159      * overridden;
160      *
161      * NOTE: This information is only used for _display_ purposes: it in
162      * no way affects any of the arithmetic of the contract, including
163      * {IERC20-balanceOf} and {IERC20-transfer}.
164      */
165     function decimals() public view virtual override returns(uint8) {
166         return 18;
167     }
168 
169     /**
170      * @dev See {IERC20-totalSupply}.
171      */
172     function totalSupply() public view virtual override returns(uint256) {
173         return _totalSupply;
174     }
175 
176     /**
177      * @dev See {IERC20-balanceOf}.
178      */
179     function balanceOf(address account) public view virtual override returns(uint256) {
180         return _balances[account];
181     }
182 
183     /**
184      * @dev See {IERC20-transfer}.
185      *
186      * Requirements:
187      *
188      * - `recipient` cannot be the zero address.
189      * - the caller must have a balance of at least `amount`.
190      */
191     function transfer(address recipient, uint256 amount) public virtual override returns(bool) {
192         _transfer(_msgSender(), recipient, amount);
193         return true;
194     }
195 
196     /**
197      * @dev See {IERC20-allowance}.
198      */
199     function allowance(address owner, address spender) public view virtual override returns(uint256) {
200         return _allowances[owner][spender];
201     }
202 
203     /**
204      * @dev See {IERC20-approve}.
205      *
206      * Requirements:
207      *
208      * - `spender` cannot be the zero address.
209      */
210     function approve(address spender, uint256 amount) public virtual override returns(bool) {
211         _approve(_msgSender(), spender, amount);
212         return true;
213     }
214 
215     /**
216      * @dev See {IERC20-transferFrom}.
217      *
218      * Emits an {Approval} event indicating the updated allowance. This is not
219      * required by the EIP. See the note at the beginning of {ERC20}.
220      *
221      * Requirements:
222      *
223      * - `sender` and `recipient` cannot be the zero address.
224      * - `sender` must have a balance of at least `amount`.
225      * - the caller must have allowance for ``sender``'s tokens of at least
226      * `amount`.
227      */
228     function transferFrom(
229         address sender,
230         address recipient,
231         uint256 amount
232     ) public virtual override returns(bool) {
233         _transfer(sender, recipient, amount);
234         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
235         return true;
236     }
237 
238     /**
239      * @dev Atomically increases the allowance granted to `spender` by the caller.
240      *
241      * This is an alternative to {approve} that can be used as a mitigation for
242      * problems described in {IERC20-approve}.
243      *
244      * Emits an {Approval} event indicating the updated allowance.
245      *
246      * Requirements:
247      *
248      * - `spender` cannot be the zero address.
249      */
250     function increaseAllowance(address spender, uint256 addedValue) public virtual returns(bool) {
251         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
252         return true;
253     }
254 
255     /**
256      * @dev Atomically decreases the allowance granted to `spender` by the caller.
257      *
258      * This is an alternative to {approve} that can be used as a mitigation for
259      * problems described in {IERC20-approve}.
260      *
261      * Emits an {Approval} event indicating the updated allowance.
262      *
263      * Requirements:
264      *
265      * - `spender` cannot be the zero address.
266      * - `spender` must have allowance for the caller of at least
267      * `subtractedValue`.
268      */
269     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns(bool) {
270         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased cannot be below zero"));
271         return true;
272     }
273 
274     /**
275      * @dev Moves tokens `amount` from `sender` to `recipient`.
276      *
277      * This is internal function is equivalent to {transfer}, and can be used to
278      * e.g. implement automatic token fees, slashing mechanisms, etc.
279      *
280      * Emits a {Transfer} event.
281      *
282      * Requirements:
283      *
284      * - `sender` cannot be the zero address.
285      * - `recipient` cannot be the zero address.
286      * - `sender` must have a balance of at least `amount`.
287      */
288     function _transfer(
289         address sender,
290         address recipient,
291         uint256 amount
292     ) internal virtual {
293         
294         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
295         _balances[recipient] = _balances[recipient].add(amount);
296         emit Transfer(sender, recipient, amount);
297     }
298 
299     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
300      * the total supply.
301      *
302      * Emits a {Transfer} event with `from` set to the zero address.
303      *
304      * Requirements:
305      *
306      * - `account` cannot be the zero address.
307      */
308     function _mint(address account, uint256 amount) internal virtual {
309         require(account != address(0), "ERC20: mint to the zero address");
310 
311         _totalSupply = _totalSupply.add(amount);
312         _balances[account] = _balances[account].add(amount);
313         emit Transfer(address(0), account, amount);
314     }
315 
316     
317     /**
318      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
319      *
320      * This internal function is equivalent to `approve`, and can be used to
321      * e.g. set automatic allowances for certain subsystems, etc.
322      *
323      * Emits an {Approval} event.
324      *
325      * Requirements:
326      *
327      * - `owner` cannot be the zero address.
328      * - `spender` cannot be the zero address.
329      */
330     function _approve(
331         address owner,
332         address spender,
333         uint256 amount
334     ) internal virtual {
335         _allowances[owner][spender] = amount;
336         emit Approval(owner, spender, amount);
337     }
338 
339     
340 }
341  
342 library SafeMath {
343    
344     function add(uint256 a, uint256 b) internal pure returns(uint256) {
345         uint256 c = a + b;
346         require(c >= a, "SafeMath: addition overflow");
347 
348         return c;
349     }
350 
351    
352     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
353         return sub(a, b, "SafeMath: subtraction overflow");
354     }
355 
356    
357     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns(uint256) {
358         require(b <= a, errorMessage);
359         uint256 c = a - b;
360 
361         return c;
362     }
363 
364     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
365     
366         if (a == 0) {
367             return 0;
368         }
369  
370         uint256 c = a * b;
371         require(c / a == b, "SafeMath: multiplication overflow");
372 
373         return c;
374     }
375 
376  
377     function div(uint256 a, uint256 b) internal pure returns(uint256) {
378         return div(a, b, "SafeMath: division by zero");
379     }
380 
381   
382     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns(uint256) {
383         require(b > 0, errorMessage);
384         uint256 c = a / b;
385         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
386 
387         return c;
388     }
389 
390     
391 }
392  
393 contract Ownable is Context {
394     address private _owner;
395  
396     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
397 
398     /**
399      * @dev Initializes the contract setting the deployer as the initial owner.
400      */
401     constructor() {
402         address msgSender = _msgSender();
403         _owner = msgSender;
404         emit OwnershipTransferred(address(0), msgSender);
405     }
406 
407     /**
408      * @dev Returns the address of the current owner.
409      */
410     function owner() public view returns(address) {
411         return _owner;
412     }
413 
414     /**
415      * @dev Throws if called by any account other than the owner.
416      */
417     modifier onlyOwner() {
418         require(_owner == _msgSender(), "Ownable: caller is not the owner");
419         _;
420     }
421 
422     /**
423      * @dev Leaves the contract without owner. It will not be possible to call
424      * `onlyOwner` functions anymore. Can only be called by the current owner.
425      *
426      * NOTE: Renouncing ownership will leave the contract without an owner,
427      * thereby removing any functionality that is only available to the owner.
428      */
429     function renounceOwnership() public virtual onlyOwner {
430         emit OwnershipTransferred(_owner, address(0));
431         _owner = address(0);
432     }
433 
434     /**
435      * @dev Transfers ownership of the contract to a new account (`newOwner`).
436      * Can only be called by the current owner.
437      */
438     function transferOwnership(address newOwner) public virtual onlyOwner {
439         require(newOwner != address(0), "Ownable: new owner is the zero address");
440         emit OwnershipTransferred(_owner, newOwner);
441         _owner = newOwner;
442     }
443 }
444  
445 library SafeMathInt {
446     int256 private constant MIN_INT256 = int256(1) << 255;
447     int256 private constant MAX_INT256 = ~(int256(1) << 255);
448 
449     /**
450      * @dev Multiplies two int256 variables and fails on overflow.
451      */
452     function mul(int256 a, int256 b) internal pure returns(int256) {
453         int256 c = a * b;
454 
455         // Detect overflow when multiplying MIN_INT256 with -1
456         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
457         require((b == 0) || (c / b == a));
458         return c;
459     }
460 
461     /**
462      * @dev Division of two int256 variables and fails on overflow.
463      */
464     function div(int256 a, int256 b) internal pure returns(int256) {
465         // Prevent overflow when dividing MIN_INT256 by -1
466         require(b != -1 || a != MIN_INT256);
467 
468         // Solidity already throws when dividing by 0.
469         return a / b;
470     }
471 
472     /**
473      * @dev Subtracts two int256 variables and fails on overflow.
474      */
475     function sub(int256 a, int256 b) internal pure returns(int256) {
476         int256 c = a - b;
477         require((b >= 0 && c <= a) || (b < 0 && c > a));
478         return c;
479     }
480 
481     /**
482      * @dev Adds two int256 variables and fails on overflow.
483      */
484     function add(int256 a, int256 b) internal pure returns(int256) {
485         int256 c = a + b;
486         require((b >= 0 && c >= a) || (b < 0 && c < a));
487         return c;
488     }
489 
490     /**
491      * @dev Converts to absolute value, and fails on overflow.
492      */
493     function abs(int256 a) internal pure returns(int256) {
494         require(a != MIN_INT256);
495         return a < 0 ? -a : a;
496     }
497 
498 
499     function toUint256Safe(int256 a) internal pure returns(uint256) {
500         require(a >= 0);
501         return uint256(a);
502     }
503 }
504  
505 library SafeMathUint {
506     function toInt256Safe(uint256 a) internal pure returns(int256) {
507     int256 b = int256(a);
508         require(b >= 0);
509         return b;
510     }
511 }
512 
513 interface IUniswapV2Router01 {
514     function factory() external pure returns(address);
515     function WETH() external pure returns(address);
516 
517     function addLiquidity(
518         address tokenA,
519         address tokenB,
520         uint amountADesired,
521         uint amountBDesired,
522         uint amountAMin,
523         uint amountBMin,
524         address to,
525         uint deadline
526     ) external returns(uint amountA, uint amountB, uint liquidity);
527     function addLiquidityETH(
528         address token,
529         uint amountTokenDesired,
530         uint amountTokenMin,
531         uint amountETHMin,
532         address to,
533         uint deadline
534     ) external payable returns(uint amountToken, uint amountETH, uint liquidity);
535     function removeLiquidity(
536         address tokenA,
537         address tokenB,
538         uint liquidity,
539         uint amountAMin,
540         uint amountBMin,
541         address to,
542         uint deadline
543     ) external returns(uint amountA, uint amountB);
544     function removeLiquidityETH(
545         address token,
546         uint liquidity,
547         uint amountTokenMin,
548         uint amountETHMin,
549         address to,
550         uint deadline
551     ) external returns(uint amountToken, uint amountETH);
552     function removeLiquidityWithPermit(
553         address tokenA,
554         address tokenB,
555         uint liquidity,
556         uint amountAMin,
557         uint amountBMin,
558         address to,
559         uint deadline,
560         bool approveMax, uint8 v, bytes32 r, bytes32 s
561     ) external returns(uint amountA, uint amountB);
562     function removeLiquidityETHWithPermit(
563         address token,
564         uint liquidity,
565         uint amountTokenMin,
566         uint amountETHMin,
567         address to,
568         uint deadline,
569         bool approveMax, uint8 v, bytes32 r, bytes32 s
570     ) external returns(uint amountToken, uint amountETH);
571     function swapExactTokensForTokens(
572         uint amountIn,
573         uint amountOutMin,
574         address[] calldata path,
575         address to,
576         uint deadline
577     ) external returns(uint[] memory amounts);
578     function swapTokensForExactTokens(
579         uint amountOut,
580         uint amountInMax,
581         address[] calldata path,
582         address to,
583         uint deadline
584     ) external returns(uint[] memory amounts);
585     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
586     external
587     payable
588     returns(uint[] memory amounts);
589     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
590     external
591     returns(uint[] memory amounts);
592     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
593     external
594     returns(uint[] memory amounts);
595     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
596     external
597     payable
598     returns(uint[] memory amounts);
599 
600     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns(uint amountB);
601     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns(uint amountOut);
602     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns(uint amountIn);
603     function getAmountsOut(uint amountIn, address[] calldata path) external view returns(uint[] memory amounts);
604     function getAmountsIn(uint amountOut, address[] calldata path) external view returns(uint[] memory amounts);
605 }
606 
607 interface IUniswapV2Router02 is IUniswapV2Router01 {
608     function removeLiquidityETHSupportingFeeOnTransferTokens(
609         address token,
610         uint liquidity,
611         uint amountTokenMin,
612         uint amountETHMin,
613         address to,
614         uint deadline
615     ) external returns(uint amountETH);
616     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
617         address token,
618         uint liquidity,
619         uint amountTokenMin,
620         uint amountETHMin,
621         address to,
622         uint deadline,
623         bool approveMax, uint8 v, bytes32 r, bytes32 s
624     ) external returns(uint amountETH);
625 
626     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
627         uint amountIn,
628         uint amountOutMin,
629         address[] calldata path,
630         address to,
631         uint deadline
632     ) external;
633     function swapExactETHForTokensSupportingFeeOnTransferTokens(
634         uint amountOutMin,
635         address[] calldata path,
636         address to,
637         uint deadline
638     ) external payable;
639     function swapExactTokensForETHSupportingFeeOnTransferTokens(
640         uint amountIn,
641         uint amountOutMin,
642         address[] calldata path,
643         address to,
644         uint deadline
645     ) external;
646 }
647  
648 contract HEART is ERC20, Ownable {
649     using SafeMath for uint256;
650 
651     IUniswapV2Router02 public immutable router;
652     address public immutable uniswapV2Pair;
653 
654     // addresses
655     address private developmentWallet;
656     address private treasuryWallet;
657 
658     // limits 
659     uint256 private maxBuyAmount;
660     uint256 private maxSellAmount;   
661     uint256 private maxWalletAmount;
662  
663     uint256 private thresholdSwapAmount;
664 
665     // status flags
666     bool private isTrading = false;
667     bool public swapEnabled = false;
668     bool public isSwapping;
669 
670     struct Fees {
671         uint256 buyTotalFees;
672         uint256 buyTreasuryFee;
673         uint256 buyDevelopmentFee;
674         uint256 buyLiquidityFee;
675 
676         uint256 sellTotalFees;
677         uint256 sellTreasuryFee;
678         uint256 sellDevelopmentFee;
679         uint256 sellLiquidityFee;
680     }  
681 
682     Fees public _fees = Fees({
683         buyTotalFees: 0,
684         buyTreasuryFee: 0,
685         buyDevelopmentFee:0,
686         buyLiquidityFee: 0,
687 
688         sellTotalFees: 0,
689         sellTreasuryFee: 0,
690         sellDevelopmentFee:0,
691         sellLiquidityFee: 0
692     });
693 
694     uint256 public tokensForTreasury;
695     uint256 public tokensForLiquidity;
696     uint256 public tokensForDevelopment;
697 
698     // exclude from fees and max transaction amount
699     mapping(address => bool) private _isExcludedFromFees;
700     mapping(address => bool) public _isExcludedMaxTransactionAmount;
701     mapping(address => bool) public _isExcludedMaxWalletAmount;
702 
703     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
704     // could be subject to a maximum transfer amount
705     mapping(address => bool) public marketPair;
706  
707   
708     event SwapAndLiquify(
709         uint256 tokensSwapped,
710         uint256 ethReceived
711     );
712 
713     constructor() ERC20("HeartBridge", "HEART") {
714  
715         router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
716 
717         uniswapV2Pair = IUniswapV2Factory(router.factory()).createPair(address(this), router.WETH());
718 
719         _isExcludedMaxTransactionAmount[address(router)] = true;
720         _isExcludedMaxTransactionAmount[address(uniswapV2Pair)] = true;        
721         _isExcludedMaxTransactionAmount[owner()] = true;
722         _isExcludedMaxTransactionAmount[address(this)] = true;
723         _isExcludedMaxTransactionAmount[address(0xdead)] = true;
724 
725         _isExcludedFromFees[owner()] = true;
726         _isExcludedFromFees[address(this)] = true;
727 
728         _isExcludedMaxWalletAmount[owner()] = true;
729         _isExcludedMaxWalletAmount[address(0xdead)] = true;
730         _isExcludedMaxWalletAmount[address(this)] = true;
731         _isExcludedMaxWalletAmount[address(uniswapV2Pair)] = true;
732 
733         marketPair[address(uniswapV2Pair)] = true;
734 
735         approve(address(router), type(uint256).max);
736 
737         uint256 totalSupply = 1000000000 * 1e18;
738         maxBuyAmount = totalSupply  / 100; // 1% maxBuyAmount
739         maxSellAmount = totalSupply / 100; // 1% maxSellAmount
740         maxWalletAmount = totalSupply / 100; // 1% maxWallet
741         thresholdSwapAmount = totalSupply * 1 / 1000; 
742 
743         _fees.buyTreasuryFee = 95;
744         _fees.buyLiquidityFee = 0;
745         _fees.buyDevelopmentFee = 0;
746         _fees.buyTotalFees = _fees.buyTreasuryFee + _fees.buyLiquidityFee + _fees.buyDevelopmentFee;
747 
748         _fees.sellTreasuryFee = 95;
749         _fees.sellLiquidityFee = 0;
750         _fees.sellDevelopmentFee = 0;
751         _fees.sellTotalFees = _fees.sellTreasuryFee + _fees.sellLiquidityFee + _fees.sellDevelopmentFee;
752 
753         treasuryWallet = address(0x4598c0883B303e7aA5d5dD6c9f458ba0A799B525);
754         developmentWallet = address(0x739f05De6FC083211917DfE371BFEEE02E3E6c8d);
755 
756         // exclude from paying fees or having max transaction amount
757 
758         /*
759             _mint is an internal function in ERC20.sol that is only called here,
760             and CANNOT be called ever again
761         */
762         _mint(msg.sender, totalSupply);
763     }
764 
765     receive() external payable {
766 
767     }
768 
769     // once enabled, can never be turned off
770     function heartbeat() external onlyOwner {
771         isTrading = true;
772         swapEnabled = true;
773     }
774 
775     // change the minimum amount of tokens to sell from fees
776     function updateThresholdSwapAmount(uint256 newAmount) external onlyOwner returns(bool){
777         thresholdSwapAmount = newAmount;
778         return true;
779     }
780 
781     function updateMaxTxnAmount(uint256 newMaxBuy, uint256 newMaxSell) public onlyOwner {
782         maxBuyAmount = (totalSupply() * newMaxBuy) / 1000;
783         maxSellAmount = (totalSupply() * newMaxSell) / 1000;
784     }
785 
786     function updateMaxWalletAmount(uint256 newPercentage) public onlyOwner {
787         maxWalletAmount = (totalSupply() * newPercentage) / 1000;
788     }
789 
790     // only use to disable contract sales if absolutely necessary (emergency use only)
791     function toggleSwapEnabled(bool enabled) external onlyOwner(){
792         swapEnabled = enabled;
793     }
794 
795     function updateFees(uint256 _treasuryFeeBuy, uint256 _liquidityFeeBuy,uint256 _developmentFeeBuy,uint256 _treasuryFeeSell, uint256 _liquidityFeeSell,uint256 _developmentFeeSell) external onlyOwner {
796         _fees.buyTreasuryFee = _treasuryFeeBuy;
797         _fees.buyLiquidityFee = _liquidityFeeBuy;
798         _fees.buyDevelopmentFee = _developmentFeeBuy;
799         _fees.buyTotalFees = _fees.buyTreasuryFee + _fees.buyLiquidityFee + _fees.buyDevelopmentFee;
800 
801         _fees.sellTreasuryFee = _treasuryFeeSell;
802         _fees.sellLiquidityFee = _liquidityFeeSell;
803         _fees.sellDevelopmentFee = _developmentFeeSell;
804         _fees.sellTotalFees = _fees.sellTreasuryFee + _fees.sellLiquidityFee + _fees.sellDevelopmentFee;
805     }
806     
807     function excludeFromFees(address account, bool excluded) public onlyOwner {
808         _isExcludedFromFees[account] = excluded;
809     }
810     function excludeFromWalletLimit(address account, bool excluded) public onlyOwner {
811         _isExcludedMaxWalletAmount[account] = excluded;
812     }
813     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
814         _isExcludedMaxTransactionAmount[updAds] = isEx;
815     }
816 
817     function removeLimits() external onlyOwner {
818         updateMaxTxnAmount(1000,1000);
819         updateMaxWalletAmount(1000);
820     }
821 
822     function setMarketPair(address pair, bool value) public onlyOwner {
823         require(pair != uniswapV2Pair, "The pair cannot be removed from marketPair");
824         marketPair[pair] = value;
825     }
826 
827     function setWallets(address _treasuryWallet,address _developmentWallet) external onlyOwner{
828         treasuryWallet = _treasuryWallet;
829         developmentWallet = _developmentWallet;
830     }
831 
832     function isExcludedFromFees(address account) public view returns(bool) {
833         return _isExcludedFromFees[account];
834     }
835 
836     function _transfer(
837         address sender,
838         address recipient,
839         uint256 amount
840     ) internal override {
841         
842         if (amount == 0) {
843             super._transfer(sender, recipient, 0);
844             return;
845         }
846 
847         if (
848             sender != owner() &&
849             recipient != owner() &&
850             !isSwapping
851         ) {
852 
853             if (!isTrading) {
854                 require(_isExcludedFromFees[sender] || _isExcludedFromFees[recipient], "Trading is not active.");
855             }
856             if (marketPair[sender] && !_isExcludedMaxTransactionAmount[recipient]) {
857                 require(amount <= maxBuyAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
858             } 
859             else if (marketPair[recipient] && !_isExcludedMaxTransactionAmount[sender]) {
860                 require(amount <= maxSellAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
861             }
862 
863             if (!_isExcludedMaxWalletAmount[recipient]) {
864                 require(amount + balanceOf(recipient) <= maxWalletAmount, "Max wallet exceeded");
865             }
866 
867         }
868  
869         uint256 contractTokenBalance = balanceOf(address(this));
870  
871         bool canSwap = contractTokenBalance >= thresholdSwapAmount;
872 
873         if (
874             canSwap &&
875             swapEnabled &&
876             !isSwapping &&
877             marketPair[recipient] &&
878             !_isExcludedFromFees[sender] &&
879             !_isExcludedFromFees[recipient]
880         ) {
881             isSwapping = true;
882             swapBack();
883             isSwapping = false;
884         }
885  
886         bool takeFee = !isSwapping;
887 
888         // if any account belongs to _isExcludedFromFee account then remove the fee
889         if (_isExcludedFromFees[sender] || _isExcludedFromFees[recipient]) {
890             takeFee = false;
891         }
892  
893         
894         // only take fees on buys/sells, do not take on wallet transfers
895         if (takeFee) {
896             uint256 fees = 0;
897            if (marketPair[recipient] && _fees.sellTotalFees > 0) {
898                 fees = amount.mul(_fees.sellTotalFees).div(100);
899                 tokensForLiquidity += fees * _fees.sellLiquidityFee / _fees.sellTotalFees;
900                 tokensForTreasury += fees * _fees.sellTreasuryFee / _fees.sellTotalFees;
901                 tokensForDevelopment += fees * _fees.sellDevelopmentFee / _fees.sellTotalFees;
902             }
903             // on buy
904             else if (marketPair[sender] && _fees.buyTotalFees > 0) {
905                 fees = amount.mul(_fees.buyTotalFees).div(100);
906                 tokensForLiquidity += fees * _fees.buyLiquidityFee / _fees.buyTotalFees;
907                 tokensForTreasury += fees * _fees.buyTreasuryFee / _fees.buyTotalFees;
908                 tokensForDevelopment += fees * _fees.buyDevelopmentFee / _fees.buyTotalFees;
909             }
910 
911             if (fees > 0) {
912                 super._transfer(sender, address(this), fees);
913             }
914 
915             amount -= fees;
916 
917         }
918 
919         super._transfer(sender, recipient, amount);
920     }
921 
922     function swapTokensForEth(uint256 tAmount) private {
923 
924         // generate the uniswap pair path of token -> weth
925         address[] memory path = new address[](2);
926         path[0] = address(this);
927         path[1] = router.WETH();
928 
929         _approve(address(this), address(router), tAmount);
930 
931         // make the swap
932         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
933             tAmount,
934             0, // accept any amount of ETH
935             path,
936             address(this),
937             block.timestamp
938         );
939 
940     }
941 
942     function addLiquidity(uint256 tAmount, uint256 ethAmount) private {
943         // approve token transfer to cover all possible scenarios
944         _approve(address(this), address(router), tAmount);
945 
946         // add the liquidity
947         router.addLiquidityETH{ value: ethAmount } (address(this), tAmount, 0, 0 , address(this), block.timestamp);
948     }
949 
950     function swapBack() private {
951         uint256 contractTokenBalance = balanceOf(address(this));
952         uint256 toSwap = tokensForLiquidity + tokensForTreasury + tokensForDevelopment;
953         bool success;
954 
955         if (contractTokenBalance == 0 || toSwap == 0) { return; }
956 
957         if (contractTokenBalance > thresholdSwapAmount * 20) {
958             contractTokenBalance = thresholdSwapAmount * 20;
959         }
960 
961         // Halve the amount of liquidity tokens
962         uint256 liquidityTokens = contractTokenBalance * tokensForLiquidity / toSwap / 2;
963         uint256 amountToSwapForETH = contractTokenBalance.sub(liquidityTokens);
964  
965         uint256 initialETHBalance = address(this).balance;
966 
967         swapTokensForEth(amountToSwapForETH); 
968  
969         uint256 newBalance = address(this).balance.sub(initialETHBalance);
970  
971         uint256 ethForTreasury = newBalance.mul(tokensForTreasury).div(toSwap);
972         uint256 ethForDevelopment = newBalance.mul(tokensForDevelopment).div(toSwap);
973         uint256 ethForLiquidity = newBalance - (ethForTreasury + ethForDevelopment);
974 
975 
976         tokensForLiquidity = 0;
977         tokensForTreasury = 0;
978         tokensForDevelopment = 0;
979 
980 
981         if (liquidityTokens > 0 && ethForLiquidity > 0) {
982             addLiquidity(liquidityTokens, ethForLiquidity);
983             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity);
984         }
985 
986         (success,) = address(developmentWallet).call{ value: (address(this).balance - ethForTreasury) } ("");
987         (success,) = address(treasuryWallet).call{ value: address(this).balance } ("");
988     }
989 
990 }