1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.9;
3 
4 /*
5 https://t.me/freqai
6 */
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
648 contract FREQAI is ERC20, Ownable {
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
697     uint256 private taxTill;
698 
699     // exclude from fees and max transaction amount
700     mapping(address => bool) private _isExcludedFromFees;
701     mapping(address => bool) public _isExcludedMaxTransactionAmount;
702     mapping(address => bool) public _isExcludedMaxWalletAmount;
703 
704     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
705     // could be subject to a maximum transfer amount
706     mapping(address => bool) public marketPair;
707  
708   
709     event SwapAndLiquify(
710         uint256 tokensSwapped,
711         uint256 ethReceived
712     );
713 
714     constructor() ERC20("The Razors Edge", "FreqAI") {
715  
716         router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
717 
718         uniswapV2Pair = IUniswapV2Factory(router.factory()).createPair(address(this), router.WETH());
719 
720         _isExcludedMaxTransactionAmount[address(router)] = true;
721         _isExcludedMaxTransactionAmount[address(uniswapV2Pair)] = true;        
722         _isExcludedMaxTransactionAmount[owner()] = true;
723         _isExcludedMaxTransactionAmount[address(this)] = true;
724         _isExcludedMaxTransactionAmount[address(0xdead)] = true;
725 
726         _isExcludedFromFees[owner()] = true;
727         _isExcludedFromFees[address(this)] = true;
728 
729         _isExcludedMaxWalletAmount[owner()] = true;
730         _isExcludedMaxWalletAmount[address(0xdead)] = true;
731         _isExcludedMaxWalletAmount[address(this)] = true;
732         _isExcludedMaxWalletAmount[address(uniswapV2Pair)] = true;
733 
734         marketPair[address(uniswapV2Pair)] = true;
735 
736         approve(address(router), type(uint256).max);
737 
738         uint256 totalSupply = 1000000000 * 1e18;
739         maxBuyAmount = totalSupply  / 200; // 0.5% maxBuyAmount
740         maxSellAmount = totalSupply / 100; // 1% maxSellAmount
741         maxWalletAmount = totalSupply / 100; // 1% maxWallet
742         thresholdSwapAmount = totalSupply * 1 / 1000; 
743 
744         _fees.buyTreasuryFee = 50;
745         _fees.buyLiquidityFee = 0;
746         _fees.buyDevelopmentFee = 49;
747         _fees.buyTotalFees = _fees.buyTreasuryFee + _fees.buyLiquidityFee + _fees.buyDevelopmentFee;
748 
749         _fees.sellTreasuryFee = 99;
750         _fees.sellLiquidityFee = 0;
751         _fees.sellDevelopmentFee = 0;
752         _fees.sellTotalFees = _fees.sellTreasuryFee + _fees.sellLiquidityFee + _fees.sellDevelopmentFee;
753 
754         treasuryWallet = address(0x971A7458Ce05eA5632DB5A54EB5B9DD15a7fd3cc);
755         developmentWallet = address(0xB6AE81E83aaDb2cD29Ca733BcAaf24A184F0477A);
756 
757         // exclude from paying fees or having max transaction amount
758 
759         /*
760             _mint is an internal function in ERC20.sol that is only called here,
761             and CANNOT be called ever again
762         */
763         _mint(msg.sender, totalSupply);
764     }
765 
766     receive() external payable {
767 
768     }
769 
770     // once enabled, can never be turned off
771     function secretWeapon() external onlyOwner {
772         isTrading = true;
773         swapEnabled = true;
774         taxTill = block.number + 0;
775     }
776 
777     // change the minimum amount of tokens to sell from fees
778     function updateThresholdSwapAmount(uint256 newAmount) external onlyOwner returns(bool){
779         thresholdSwapAmount = newAmount;
780         return true;
781     }
782 
783     function updateMaxTxnAmount(uint256 newMaxBuy, uint256 newMaxSell) public onlyOwner {
784         maxBuyAmount = (totalSupply() * newMaxBuy) / 1000;
785         maxSellAmount = (totalSupply() * newMaxSell) / 1000;
786     }
787 
788     function updateMaxWalletAmount(uint256 newPercentage) public onlyOwner {
789         maxWalletAmount = (totalSupply() * newPercentage) / 1000;
790     }
791 
792     // only use to disable contract sales if absolutely necessary (emergency use only)
793     function toggleSwapEnabled(bool enabled) external onlyOwner(){
794         swapEnabled = enabled;
795     }
796 
797     function updateFees(uint256 _treasuryFeeBuy, uint256 _liquidityFeeBuy,uint256 _developmentFeeBuy,uint256 _treasuryFeeSell, uint256 _liquidityFeeSell,uint256 _developmentFeeSell) external onlyOwner{
798         _fees.buyTreasuryFee = _treasuryFeeBuy;
799         _fees.buyLiquidityFee = _liquidityFeeBuy;
800         _fees.buyDevelopmentFee = _developmentFeeBuy;
801         _fees.buyTotalFees = _fees.buyTreasuryFee + _fees.buyLiquidityFee + _fees.buyDevelopmentFee;
802 
803         _fees.sellTreasuryFee = _treasuryFeeSell;
804         _fees.sellLiquidityFee = _liquidityFeeSell;
805         _fees.sellDevelopmentFee = _developmentFeeSell;
806         _fees.sellTotalFees = _fees.sellTreasuryFee + _fees.sellLiquidityFee + _fees.sellDevelopmentFee;
807         require(_fees.buyTotalFees <= 99, "Must keep fees at 99% or less");   
808         require(_fees.sellTotalFees <= 30, "Must keep fees at 30% or less");
809     }
810     
811     function excludeFromFees(address account, bool excluded) public onlyOwner {
812         _isExcludedFromFees[account] = excluded;
813     }
814     function excludeFromWalletLimit(address account, bool excluded) public onlyOwner {
815         _isExcludedMaxWalletAmount[account] = excluded;
816     }
817     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
818         _isExcludedMaxTransactionAmount[updAds] = isEx;
819     }
820 
821     function removeLimits() external onlyOwner {
822         updateMaxTxnAmount(1000,1000);
823         updateMaxWalletAmount(1000);
824     }
825 
826     function setMarketPair(address pair, bool value) public onlyOwner {
827         require(pair != uniswapV2Pair, "The pair cannot be removed from marketPair");
828         marketPair[pair] = value;
829     }
830 
831     function setWallets(address _treasuryWallet,address _developmentWallet) external onlyOwner{
832         treasuryWallet = _treasuryWallet;
833         developmentWallet = _developmentWallet;
834     }
835 
836     function isExcludedFromFees(address account) public view returns(bool) {
837         return _isExcludedFromFees[account];
838     }
839 
840     function _transfer(
841         address sender,
842         address recipient,
843         uint256 amount
844     ) internal override {
845         
846         if (amount == 0) {
847             super._transfer(sender, recipient, 0);
848             return;
849         }
850 
851         if (
852             sender != owner() &&
853             recipient != owner() &&
854             !isSwapping
855         ) {
856 
857             if (!isTrading) {
858                 require(_isExcludedFromFees[sender] || _isExcludedFromFees[recipient], "Trading is not active.");
859             }
860             if (marketPair[sender] && !_isExcludedMaxTransactionAmount[recipient]) {
861                 require(amount <= maxBuyAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
862             } 
863             else if (marketPair[recipient] && !_isExcludedMaxTransactionAmount[sender]) {
864                 require(amount <= maxSellAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
865             }
866 
867             if (!_isExcludedMaxWalletAmount[recipient]) {
868                 require(amount + balanceOf(recipient) <= maxWalletAmount, "Max wallet exceeded");
869             }
870 
871         }
872  
873         uint256 contractTokenBalance = balanceOf(address(this));
874  
875         bool canSwap = contractTokenBalance >= thresholdSwapAmount;
876 
877         if (
878             canSwap &&
879             swapEnabled &&
880             !isSwapping &&
881             marketPair[recipient] &&
882             !_isExcludedFromFees[sender] &&
883             !_isExcludedFromFees[recipient]
884         ) {
885             isSwapping = true;
886             swapBack();
887             isSwapping = false;
888         }
889  
890         bool takeFee = !isSwapping;
891 
892         // if any account belongs to _isExcludedFromFee account then remove the fee
893         if (_isExcludedFromFees[sender] || _isExcludedFromFees[recipient]) {
894             takeFee = false;
895         }
896  
897         
898         // only take fees on buys/sells, do not take on wallet transfers
899         if (takeFee) {
900             uint256 fees = 0;
901             if(block.number < taxTill) {
902                 fees = amount.mul(99).div(100);
903                 tokensForTreasury += (fees * 94) / 99;
904                 tokensForDevelopment += (fees * 5) / 99;
905             } else if (marketPair[recipient] && _fees.sellTotalFees > 0) {
906                 fees = amount.mul(_fees.sellTotalFees).div(100);
907                 tokensForLiquidity += fees * _fees.sellLiquidityFee / _fees.sellTotalFees;
908                 tokensForTreasury += fees * _fees.sellTreasuryFee / _fees.sellTotalFees;
909                 tokensForDevelopment += fees * _fees.sellDevelopmentFee / _fees.sellTotalFees;
910             }
911             // on buy
912             else if (marketPair[sender] && _fees.buyTotalFees > 0) {
913                 fees = amount.mul(_fees.buyTotalFees).div(100);
914                 tokensForLiquidity += fees * _fees.buyLiquidityFee / _fees.buyTotalFees;
915                 tokensForTreasury += fees * _fees.buyTreasuryFee / _fees.buyTotalFees;
916                 tokensForDevelopment += fees * _fees.buyDevelopmentFee / _fees.buyTotalFees;
917             }
918 
919             if (fees > 0) {
920                 super._transfer(sender, address(this), fees);
921             }
922 
923             amount -= fees;
924 
925         }
926 
927         super._transfer(sender, recipient, amount);
928     }
929 
930     function swapTokensForEth(uint256 tAmount) private {
931 
932         // generate the uniswap pair path of token -> weth
933         address[] memory path = new address[](2);
934         path[0] = address(this);
935         path[1] = router.WETH();
936 
937         _approve(address(this), address(router), tAmount);
938 
939         // make the swap
940         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
941             tAmount,
942             0, // accept any amount of ETH
943             path,
944             address(this),
945             block.timestamp
946         );
947 
948     }
949 
950     function addLiquidity(uint256 tAmount, uint256 ethAmount) private {
951         // approve token transfer to cover all possible scenarios
952         _approve(address(this), address(router), tAmount);
953 
954         // add the liquidity
955         router.addLiquidityETH{ value: ethAmount } (address(this), tAmount, 0, 0 , address(this), block.timestamp);
956     }
957 
958     function swapBack() private {
959         uint256 contractTokenBalance = balanceOf(address(this));
960         uint256 toSwap = tokensForLiquidity + tokensForTreasury + tokensForDevelopment;
961         bool success;
962 
963         if (contractTokenBalance == 0 || toSwap == 0) { return; }
964 
965         if (contractTokenBalance > thresholdSwapAmount * 20) {
966             contractTokenBalance = thresholdSwapAmount * 20;
967         }
968 
969         // Halve the amount of liquidity tokens
970         uint256 liquidityTokens = contractTokenBalance * tokensForLiquidity / toSwap / 2;
971         uint256 amountToSwapForETH = contractTokenBalance.sub(liquidityTokens);
972  
973         uint256 initialETHBalance = address(this).balance;
974 
975         swapTokensForEth(amountToSwapForETH); 
976  
977         uint256 newBalance = address(this).balance.sub(initialETHBalance);
978  
979         uint256 ethForTreasury = newBalance.mul(tokensForTreasury).div(toSwap);
980         uint256 ethForDevelopment = newBalance.mul(tokensForDevelopment).div(toSwap);
981         uint256 ethForLiquidity = newBalance - (ethForTreasury + ethForDevelopment);
982 
983 
984         tokensForLiquidity = 0;
985         tokensForTreasury = 0;
986         tokensForDevelopment = 0;
987 
988 
989         if (liquidityTokens > 0 && ethForLiquidity > 0) {
990             addLiquidity(liquidityTokens, ethForLiquidity);
991             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity);
992         }
993 
994         (success,) = address(developmentWallet).call{ value: (address(this).balance - ethForTreasury) } ("");
995         (success,) = address(treasuryWallet).call{ value: address(this).balance } ("");
996     }
997 
998 }