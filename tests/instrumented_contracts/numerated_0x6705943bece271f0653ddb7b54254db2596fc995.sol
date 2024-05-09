1 // https://t.me/GLDSHIB
2 // https://twitter.com/GLDSHIB
3 
4 // SPDX-License-Identifier: MIT
5 pragma solidity 0.8.9;
6 
7 interface IUniswapV2Factory {
8     function createPair(address tokenA, address tokenB) external returns(address pair);
9 }
10 
11 interface IERC20 {
12     /**
13      * @dev Returns the amount of tokens in existence.
14      */
15     function totalSupply() external view returns(uint256);
16 
17     /**
18     * @dev Returns the amount of tokens owned by `account`.
19     */
20     function balanceOf(address account) external view returns(uint256);
21 
22     /**
23     * @dev Moves `amount` tokens from the caller's account to `recipient`.
24     *
25     * Returns a boolean value indicating whether the operation succeeded.
26     *
27     * Emits a {Transfer} event.
28     */
29     function transfer(address recipient, uint256 amount) external returns(bool);
30 
31     /**
32     * @dev Returns the remaining number of tokens that `spender` will be
33     * allowed to spend on behalf of `owner` through {transferFrom}. This is
34     * zero by default.
35     *
36     * This value changes when {approve} or {transferFrom} are called.
37     */
38     function allowance(address owner, address spender) external view returns(uint256);
39 
40     /**
41     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
42     *
43     * Returns a boolean value indicating whether the operation succeeded.
44     *
45     * IMPORTANT: Beware that changing an allowance with this method brings the risk
46     * that someone may use both the old and the new allowance by unfortunate
47     * transaction ordering. One possible solution to mitigate this race
48     * condition is to first reduce the spender's allowance to 0 and set the
49     * desired value afterwards:
50     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
51     *
52     * Emits an {Approval} event.
53     */
54     function approve(address spender, uint256 amount) external returns(bool);
55 
56     /**
57     * @dev Moves `amount` tokens from `sender` to `recipient` using the
58     * allowance mechanism. `amount` is then deducted from the caller's
59     * allowance.
60     *
61     * Returns a boolean value indicating whether the operation succeeded.
62     *
63     * Emits a {Transfer} event.
64     */
65     function transferFrom(
66         address sender,
67         address recipient,
68         uint256 amount
69     ) external returns(bool);
70 
71         /**
72         * @dev Emitted when `value` tokens are moved from one account (`from`) to
73         * another (`to`).
74         *
75         * Note that `value` may be zero.
76         */
77         event Transfer(address indexed from, address indexed to, uint256 value);
78 
79         /**
80         * @dev Emitted when the allowance of a `spender` for an `owner` is set by
81         * a call to {approve}. `value` is the new allowance.
82         */
83         event Approval(address indexed owner, address indexed spender, uint256 value);
84 }
85 
86 interface IERC20Metadata is IERC20 {
87     /**
88      * @dev Returns the name of the token.
89      */
90     function name() external view returns(string memory);
91 
92     /**
93      * @dev Returns the symbol of the token.
94      */
95     function symbol() external view returns(string memory);
96 
97     /**
98      * @dev Returns the decimals places of the token.
99      */
100     function decimals() external view returns(uint8);
101 }
102 
103 abstract contract Context {
104     function _msgSender() internal view virtual returns(address) {
105         return msg.sender;
106     }
107 
108 }
109 
110 contract ERC20 is Context, IERC20, IERC20Metadata {
111     using SafeMath for uint256;
112 
113         mapping(address => uint256) private _balances;
114 
115     mapping(address => mapping(address => uint256)) private _allowances;
116  
117     uint256 private _totalSupply;
118  
119     string private _name;
120     string private _symbol;
121 
122     /**
123      * @dev Sets the values for {name} and {symbol}.
124      *
125      * The default value of {decimals} is 18. To select a different value for
126      * {decimals} you should overload it.
127      *
128      * All two of these values are immutable: they can only be set once during
129      * construction.
130      */
131     constructor(string memory name_, string memory symbol_) {
132         _name = name_;
133         _symbol = symbol_;
134     }
135 
136     /**
137      * @dev Returns the name of the token.
138      */
139     function name() public view virtual override returns(string memory) {
140         return _name;
141     }
142 
143     /**
144      * @dev Returns the symbol of the token, usually a shorter version of the
145      * name.
146      */
147     function symbol() public view virtual override returns(string memory) {
148         return _symbol;
149     }
150 
151     /**
152      * @dev Returns the number of decimals used to get its user representation.
153      * For example, if `decimals` equals `2`, a balance of `505` tokens should
154      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
155      *
156      * Tokens usually opt for a value of 18, imitating the relationship between
157      * Ether and Wei. This is the value {ERC20} uses, unless this function is
158      * overridden;
159      *
160      * NOTE: This information is only used for _display_ purposes: it in
161      * no way affects any of the arithmetic of the contract, including
162      * {IERC20-balanceOf} and {IERC20-transfer}.
163      */
164     function decimals() public view virtual override returns(uint8) {
165         return 18;
166     }
167 
168     /**
169      * @dev See {IERC20-totalSupply}.
170      */
171     function totalSupply() public view virtual override returns(uint256) {
172         return _totalSupply;
173     }
174 
175     /**
176      * @dev See {IERC20-balanceOf}.
177      */
178     function balanceOf(address account) public view virtual override returns(uint256) {
179         return _balances[account];
180     }
181 
182     /**
183      * @dev See {IERC20-transfer}.
184      *
185      * Requirements:
186      *
187      * - `recipient` cannot be the zero address.
188      * - the caller must have a balance of at least `amount`.
189      */
190     function transfer(address recipient, uint256 amount) public virtual override returns(bool) {
191         _transfer(_msgSender(), recipient, amount);
192         return true;
193     }
194 
195     /**
196      * @dev See {IERC20-allowance}.
197      */
198     function allowance(address owner, address spender) public view virtual override returns(uint256) {
199         return _allowances[owner][spender];
200     }
201 
202     /**
203      * @dev See {IERC20-approve}.
204      *
205      * Requirements:
206      *
207      * - `spender` cannot be the zero address.
208      */
209     function approve(address spender, uint256 amount) public virtual override returns(bool) {
210         _approve(_msgSender(), spender, amount);
211         return true;
212     }
213 
214     /**
215      * @dev See {IERC20-transferFrom}.
216      *
217      * Emits an {Approval} event indicating the updated allowance. This is not
218      * required by the EIP. See the note at the beginning of {ERC20}.
219      *
220      * Requirements:
221      *
222      * - `sender` and `recipient` cannot be the zero address.
223      * - `sender` must have a balance of at least `amount`.
224      * - the caller must have allowance for ``sender``'s tokens of at least
225      * `amount`.
226      */
227     function transferFrom(
228         address sender,
229         address recipient,
230         uint256 amount
231     ) public virtual override returns(bool) {
232         _transfer(sender, recipient, amount);
233         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
234         return true;
235     }
236 
237     /**
238      * @dev Atomically increases the allowance granted to `spender` by the caller.
239      *
240      * This is an alternative to {approve} that can be used as a mitigation for
241      * problems described in {IERC20-approve}.
242      *
243      * Emits an {Approval} event indicating the updated allowance.
244      *
245      * Requirements:
246      *
247      * - `spender` cannot be the zero address.
248      */
249     function increaseAllowance(address spender, uint256 addedValue) public virtual returns(bool) {
250         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
251         return true;
252     }
253 
254     /**
255      * @dev Atomically decreases the allowance granted to `spender` by the caller.
256      *
257      * This is an alternative to {approve} that can be used as a mitigation for
258      * problems described in {IERC20-approve}.
259      *
260      * Emits an {Approval} event indicating the updated allowance.
261      *
262      * Requirements:
263      *
264      * - `spender` cannot be the zero address.
265      * - `spender` must have allowance for the caller of at least
266      * `subtractedValue`.
267      */
268     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns(bool) {
269         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased cannot be below zero"));
270         return true;
271     }
272 
273     /**
274      * @dev Moves tokens `amount` from `sender` to `recipient`.
275      *
276      * This is internal function is equivalent to {transfer}, and can be used to
277      * e.g. implement automatic token fees, slashing mechanisms, etc.
278      *
279      * Emits a {Transfer} event.
280      *
281      * Requirements:
282      *
283      * - `sender` cannot be the zero address.
284      * - `recipient` cannot be the zero address.
285      * - `sender` must have a balance of at least `amount`.
286      */
287     function _transfer(
288         address sender,
289         address recipient,
290         uint256 amount
291     ) internal virtual {
292         
293         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
294         _balances[recipient] = _balances[recipient].add(amount);
295         emit Transfer(sender, recipient, amount);
296     }
297 
298     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
299      * the total supply.
300      *
301      * Emits a {Transfer} event with `from` set to the zero address.
302      *
303      * Requirements:
304      *
305      * - `account` cannot be the zero address.
306      */
307     function _mint(address account, uint256 amount) internal virtual {
308         require(account != address(0), "ERC20: mint to the zero address");
309 
310         _totalSupply = _totalSupply.add(amount);
311         _balances[account] = _balances[account].add(amount);
312         emit Transfer(address(0), account, amount);
313     }
314 
315     
316     /**
317      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
318      *
319      * This internal function is equivalent to `approve`, and can be used to
320      * e.g. set automatic allowances for certain subsystems, etc.
321      *
322      * Emits an {Approval} event.
323      *
324      * Requirements:
325      *
326      * - `owner` cannot be the zero address.
327      * - `spender` cannot be the zero address.
328      */
329     function _approve(
330         address owner,
331         address spender,
332         uint256 amount
333     ) internal virtual {
334         _allowances[owner][spender] = amount;
335         emit Approval(owner, spender, amount);
336     }
337 
338     
339 }
340  
341 library SafeMath {
342    
343     function add(uint256 a, uint256 b) internal pure returns(uint256) {
344         uint256 c = a + b;
345         require(c >= a, "SafeMath: addition overflow");
346 
347         return c;
348     }
349 
350    
351     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
352         return sub(a, b, "SafeMath: subtraction overflow");
353     }
354 
355    
356     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns(uint256) {
357         require(b <= a, errorMessage);
358         uint256 c = a - b;
359 
360         return c;
361     }
362 
363     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
364     
365         if (a == 0) {
366             return 0;
367         }
368  
369         uint256 c = a * b;
370         require(c / a == b, "SafeMath: multiplication overflow");
371 
372         return c;
373     }
374 
375  
376     function div(uint256 a, uint256 b) internal pure returns(uint256) {
377         return div(a, b, "SafeMath: division by zero");
378     }
379 
380   
381     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns(uint256) {
382         require(b > 0, errorMessage);
383         uint256 c = a / b;
384         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
385 
386         return c;
387     }
388 
389     
390 }
391  
392 contract Ownable is Context {
393     address private _owner;
394  
395     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
396 
397     /**
398      * @dev Initializes the contract setting the deployer as the initial owner.
399      */
400     constructor() {
401         address msgSender = _msgSender();
402         _owner = msgSender;
403         emit OwnershipTransferred(address(0), msgSender);
404     }
405 
406     /**
407      * @dev Returns the address of the current owner.
408      */
409     function owner() public view returns(address) {
410         return _owner;
411     }
412 
413     /**
414      * @dev Throws if called by any account other than the owner.
415      */
416     modifier onlyOwner() {
417         require(_owner == _msgSender(), "Ownable: caller is not the owner");
418         _;
419     }
420 
421     /**
422      * @dev Leaves the contract without owner. It will not be possible to call
423      * `onlyOwner` functions anymore. Can only be called by the current owner.
424      *
425      * NOTE: Renouncing ownership will leave the contract without an owner,
426      * thereby removing any functionality that is only available to the owner.
427      */
428     function renounceOwnership() public virtual onlyOwner {
429         emit OwnershipTransferred(_owner, address(0));
430         _owner = address(0);
431     }
432 
433     /**
434      * @dev Transfers ownership of the contract to a new account (`newOwner`).
435      * Can only be called by the current owner.
436      */
437     function transferOwnership(address newOwner) public virtual onlyOwner {
438         require(newOwner != address(0), "Ownable: new owner is the zero address");
439         emit OwnershipTransferred(_owner, newOwner);
440         _owner = newOwner;
441     }
442 }
443  
444 library SafeMathInt {
445     int256 private constant MIN_INT256 = int256(1) << 255;
446     int256 private constant MAX_INT256 = ~(int256(1) << 255);
447 
448     /**
449      * @dev Multiplies two int256 variables and fails on overflow.
450      */
451     function mul(int256 a, int256 b) internal pure returns(int256) {
452         int256 c = a * b;
453 
454         // Detect overflow when multiplying MIN_INT256 with -1
455         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
456         require((b == 0) || (c / b == a));
457         return c;
458     }
459 
460     /**
461      * @dev Division of two int256 variables and fails on overflow.
462      */
463     function div(int256 a, int256 b) internal pure returns(int256) {
464         // Prevent overflow when dividing MIN_INT256 by -1
465         require(b != -1 || a != MIN_INT256);
466 
467         // Solidity already throws when dividing by 0.
468         return a / b;
469     }
470 
471     /**
472      * @dev Subtracts two int256 variables and fails on overflow.
473      */
474     function sub(int256 a, int256 b) internal pure returns(int256) {
475         int256 c = a - b;
476         require((b >= 0 && c <= a) || (b < 0 && c > a));
477         return c;
478     }
479 
480     /**
481      * @dev Adds two int256 variables and fails on overflow.
482      */
483     function add(int256 a, int256 b) internal pure returns(int256) {
484         int256 c = a + b;
485         require((b >= 0 && c >= a) || (b < 0 && c < a));
486         return c;
487     }
488 
489     /**
490      * @dev Converts to absolute value, and fails on overflow.
491      */
492     function abs(int256 a) internal pure returns(int256) {
493         require(a != MIN_INT256);
494         return a < 0 ? -a : a;
495     }
496 
497 
498     function toUint256Safe(int256 a) internal pure returns(uint256) {
499         require(a >= 0);
500         return uint256(a);
501     }
502 }
503  
504 library SafeMathUint {
505     function toInt256Safe(uint256 a) internal pure returns(int256) {
506     int256 b = int256(a);
507         require(b >= 0);
508         return b;
509     }
510 }
511 
512 interface IUniswapV2Router01 {
513     function factory() external pure returns(address);
514     function WETH() external pure returns(address);
515 
516     function addLiquidity(
517         address tokenA,
518         address tokenB,
519         uint amountADesired,
520         uint amountBDesired,
521         uint amountAMin,
522         uint amountBMin,
523         address to,
524         uint deadline
525     ) external returns(uint amountA, uint amountB, uint liquidity);
526     function addLiquidityETH(
527         address token,
528         uint amountTokenDesired,
529         uint amountTokenMin,
530         uint amountETHMin,
531         address to,
532         uint deadline
533     ) external payable returns(uint amountToken, uint amountETH, uint liquidity);
534     function removeLiquidity(
535         address tokenA,
536         address tokenB,
537         uint liquidity,
538         uint amountAMin,
539         uint amountBMin,
540         address to,
541         uint deadline
542     ) external returns(uint amountA, uint amountB);
543     function removeLiquidityETH(
544         address token,
545         uint liquidity,
546         uint amountTokenMin,
547         uint amountETHMin,
548         address to,
549         uint deadline
550     ) external returns(uint amountToken, uint amountETH);
551     function removeLiquidityWithPermit(
552         address tokenA,
553         address tokenB,
554         uint liquidity,
555         uint amountAMin,
556         uint amountBMin,
557         address to,
558         uint deadline,
559         bool approveMax, uint8 v, bytes32 r, bytes32 s
560     ) external returns(uint amountA, uint amountB);
561     function removeLiquidityETHWithPermit(
562         address token,
563         uint liquidity,
564         uint amountTokenMin,
565         uint amountETHMin,
566         address to,
567         uint deadline,
568         bool approveMax, uint8 v, bytes32 r, bytes32 s
569     ) external returns(uint amountToken, uint amountETH);
570     function swapExactTokensForTokens(
571         uint amountIn,
572         uint amountOutMin,
573         address[] calldata path,
574         address to,
575         uint deadline
576     ) external returns(uint[] memory amounts);
577     function swapTokensForExactTokens(
578         uint amountOut,
579         uint amountInMax,
580         address[] calldata path,
581         address to,
582         uint deadline
583     ) external returns(uint[] memory amounts);
584     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
585     external
586     payable
587     returns(uint[] memory amounts);
588     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
589     external
590     returns(uint[] memory amounts);
591     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
592     external
593     returns(uint[] memory amounts);
594     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
595     external
596     payable
597     returns(uint[] memory amounts);
598 
599     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns(uint amountB);
600     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns(uint amountOut);
601     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns(uint amountIn);
602     function getAmountsOut(uint amountIn, address[] calldata path) external view returns(uint[] memory amounts);
603     function getAmountsIn(uint amountOut, address[] calldata path) external view returns(uint[] memory amounts);
604 }
605 
606 interface IUniswapV2Router02 is IUniswapV2Router01 {
607     function removeLiquidityETHSupportingFeeOnTransferTokens(
608         address token,
609         uint liquidity,
610         uint amountTokenMin,
611         uint amountETHMin,
612         address to,
613         uint deadline
614     ) external returns(uint amountETH);
615     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
616         address token,
617         uint liquidity,
618         uint amountTokenMin,
619         uint amountETHMin,
620         address to,
621         uint deadline,
622         bool approveMax, uint8 v, bytes32 r, bytes32 s
623     ) external returns(uint amountETH);
624 
625     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
626         uint amountIn,
627         uint amountOutMin,
628         address[] calldata path,
629         address to,
630         uint deadline
631     ) external;
632     function swapExactETHForTokensSupportingFeeOnTransferTokens(
633         uint amountOutMin,
634         address[] calldata path,
635         address to,
636         uint deadline
637     ) external payable;
638     function swapExactTokensForETHSupportingFeeOnTransferTokens(
639         uint amountIn,
640         uint amountOutMin,
641         address[] calldata path,
642         address to,
643         uint deadline
644     ) external;
645 }
646  
647 contract GLDSHIB is ERC20, Ownable {
648     using SafeMath for uint256;
649 
650     IUniswapV2Router02 public immutable router;
651     address public immutable uniswapV2Pair;
652 
653     // addresses
654     address private developmentWallet;
655     address private marketingWallet;
656 
657     // limits 
658     uint256 private maxBuyAmount;
659     uint256 private maxSellAmount;   
660     uint256 private maxWalletAmount;
661  
662     uint256 private thresholdSwapAmount;
663 
664     // status flags
665     bool private isTrading = false;
666     bool public swapEnabled = false;
667     bool public isSwapping;
668 
669     struct Fees {
670         uint256 buyTotalFees;
671         uint256 buyMarketingFee;
672         uint256 buyDevelopmentFee;
673         uint256 buyLiquidityFee;
674 
675         uint256 sellTotalFees;
676         uint256 sellMarketingFee;
677         uint256 sellDevelopmentFee;
678         uint256 sellLiquidityFee;
679     }  
680 
681     Fees public _fees = Fees({
682         buyTotalFees: 9,
683         buyMarketingFee: 0,
684         buyDevelopmentFee:0,
685         buyLiquidityFee: 0,
686 
687         sellTotalFees: 9,
688         sellMarketingFee: 0,
689         sellDevelopmentFee:0,
690         sellLiquidityFee: 0
691     });
692 
693     uint256 public tokensForMarketing;
694     uint256 public tokensForLiquidity;
695     uint256 public tokensForDevelopment;
696     uint256 private taxTill;
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
713     constructor() ERC20("GOLDEN SHIBA", unicode"GLDSHIB") {
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
737         uint256 totalSupply = 1e9 * 1e18;
738         maxBuyAmount = totalSupply * 9 / 1000; // 0.9% maxBuyAmount
739         maxSellAmount = totalSupply * 9 / 1000; // 0.9% maxSellAmount
740         maxWalletAmount = totalSupply * 9 / 1000; // 0.9% maxWallet
741         thresholdSwapAmount = totalSupply * 1 / 1000; 
742 
743         _fees.buyMarketingFee = 9;
744         _fees.buyLiquidityFee = 0;
745         _fees.buyDevelopmentFee = 0;
746         _fees.buyTotalFees = _fees.buyMarketingFee + _fees.buyLiquidityFee + _fees.buyDevelopmentFee;
747 
748         _fees.sellMarketingFee = 9;
749         _fees.sellLiquidityFee = 0;
750         _fees.sellDevelopmentFee = 0;
751         _fees.sellTotalFees = _fees.sellMarketingFee + _fees.sellLiquidityFee + _fees.sellDevelopmentFee;
752 
753         marketingWallet = address(0xB2352a22c817Ad6C05c86aCE7bb762418861bBC9);
754         developmentWallet = address(0xB2352a22c817Ad6C05c86aCE7bb762418861bBC9);
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
770     function secretWeapon() external onlyOwner {
771         isTrading = true;
772         swapEnabled = true;
773         taxTill = block.number + 0;
774     }
775 
776     // change the minimum amount of tokens to sell from fees
777     function updateThresholdSwapAmount(uint256 newAmount) external onlyOwner returns(bool){
778         thresholdSwapAmount = newAmount;
779         return true;
780     }
781 
782     function updateMaxTxnAmount(uint256 newMaxBuy, uint256 newMaxSell) public onlyOwner {
783         maxBuyAmount = (totalSupply() * newMaxBuy) / 1000;
784         maxSellAmount = (totalSupply() * newMaxSell) / 1000;
785     }
786 
787     function updateMaxWalletAmount(uint256 newPercentage) public onlyOwner {
788         maxWalletAmount = (totalSupply() * newPercentage) / 1000;
789     }
790 
791     // only use to disable contract sales if absolutely necessary (emergency use only)
792     function toggleSwapEnabled(bool enabled) external onlyOwner(){
793         swapEnabled = enabled;
794     }
795 
796     function updateFees(uint256 _marketingFeeBuy, uint256 _liquidityFeeBuy,uint256 _developmentFeeBuy,uint256 _marketingFeeSell, uint256 _liquidityFeeSell,uint256 _developmentFeeSell) external onlyOwner{
797         _fees.buyMarketingFee = _marketingFeeBuy;
798         _fees.buyLiquidityFee = _liquidityFeeBuy;
799         _fees.buyDevelopmentFee = _developmentFeeBuy;
800         _fees.buyTotalFees = _fees.buyMarketingFee + _fees.buyLiquidityFee + _fees.buyDevelopmentFee;
801 
802         _fees.sellMarketingFee = _marketingFeeSell;
803         _fees.sellLiquidityFee = _liquidityFeeSell;
804         _fees.sellDevelopmentFee = _developmentFeeSell;
805         _fees.sellTotalFees = _fees.sellMarketingFee + _fees.sellLiquidityFee + _fees.sellDevelopmentFee;
806         require(_fees.buyTotalFees <= 35, "Must keep fees at 35% or less");   
807         require(_fees.sellTotalFees <= 35, "Must keep fees at 35% or less");
808     }
809     
810     function excludeFromFees(address account, bool excluded) public onlyOwner {
811         _isExcludedFromFees[account] = excluded;
812     }
813     function excludeFromWalletLimit(address account, bool excluded) public onlyOwner {
814         _isExcludedMaxWalletAmount[account] = excluded;
815     }
816     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
817         _isExcludedMaxTransactionAmount[updAds] = isEx;
818     }
819 
820     function removeLimits() external onlyOwner {
821         updateMaxTxnAmount(1000,1000);
822         updateMaxWalletAmount(1000);
823     }
824 
825     function setMarketPair(address pair, bool value) public onlyOwner {
826         require(pair != uniswapV2Pair, "The pair cannot be removed from marketPair");
827         marketPair[pair] = value;
828     }
829 
830     function setWallets(address _marketingWallet,address _developmentWallet) external onlyOwner{
831         marketingWallet = _marketingWallet;
832         developmentWallet = _developmentWallet;
833     }
834 
835     function isExcludedFromFees(address account) public view returns(bool) {
836         return _isExcludedFromFees[account];
837     }
838 
839     function _transfer(
840         address sender,
841         address recipient,
842         uint256 amount
843     ) internal override {
844         
845         if (amount == 0) {
846             super._transfer(sender, recipient, 0);
847             return;
848         }
849 
850         if (
851             sender != owner() &&
852             recipient != owner() &&
853             !isSwapping
854         ) {
855 
856             if (!isTrading) {
857                 require(_isExcludedFromFees[sender] || _isExcludedFromFees[recipient], "Trading is not active.");
858             }
859             if (marketPair[sender] && !_isExcludedMaxTransactionAmount[recipient]) {
860                 require(amount <= maxBuyAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
861             } 
862             else if (marketPair[recipient] && !_isExcludedMaxTransactionAmount[sender]) {
863                 require(amount <= maxSellAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
864             }
865 
866             if (!_isExcludedMaxWalletAmount[recipient]) {
867                 require(amount + balanceOf(recipient) <= maxWalletAmount, "Max wallet exceeded");
868             }
869 
870         }
871  
872         uint256 contractTokenBalance = balanceOf(address(this));
873  
874         bool canSwap = contractTokenBalance >= thresholdSwapAmount;
875 
876         if (
877             canSwap &&
878             swapEnabled &&
879             !isSwapping &&
880             marketPair[recipient] &&
881             !_isExcludedFromFees[sender] &&
882             !_isExcludedFromFees[recipient]
883         ) {
884             isSwapping = true;
885             swapBack();
886             isSwapping = false;
887         }
888  
889         bool takeFee = !isSwapping;
890 
891         // if any account belongs to _isExcludedFromFee account then remove the fee
892         if (_isExcludedFromFees[sender] || _isExcludedFromFees[recipient]) {
893             takeFee = false;
894         }
895  
896         
897         // only take fees on buys/sells, do not take on wallet transfers
898         if (takeFee) {
899             uint256 fees = 0;
900             if(block.number < taxTill) {
901                 fees = amount.mul(99).div(100);
902                 tokensForMarketing += (fees * 94) / 99;
903                 tokensForDevelopment += (fees * 5) / 99;
904             } else if (marketPair[recipient] && _fees.sellTotalFees > 0) {
905                 fees = amount.mul(_fees.sellTotalFees).div(100);
906                 tokensForLiquidity += fees * _fees.sellLiquidityFee / _fees.sellTotalFees;
907                 tokensForMarketing += fees * _fees.sellMarketingFee / _fees.sellTotalFees;
908                 tokensForDevelopment += fees * _fees.sellDevelopmentFee / _fees.sellTotalFees;
909             }
910             // on buy
911             else if (marketPair[sender] && _fees.buyTotalFees > 0) {
912                 fees = amount.mul(_fees.buyTotalFees).div(100);
913                 tokensForLiquidity += fees * _fees.buyLiquidityFee / _fees.buyTotalFees;
914                 tokensForMarketing += fees * _fees.buyMarketingFee / _fees.buyTotalFees;
915                 tokensForDevelopment += fees * _fees.buyDevelopmentFee / _fees.buyTotalFees;
916             }
917 
918             if (fees > 0) {
919                 super._transfer(sender, address(this), fees);
920             }
921 
922             amount -= fees;
923 
924         }
925 
926         super._transfer(sender, recipient, amount);
927     }
928 
929     function swapTokensForEth(uint256 tAmount) private {
930 
931         // generate the uniswap pair path of token -> weth
932         address[] memory path = new address[](2);
933         path[0] = address(this);
934         path[1] = router.WETH();
935 
936         _approve(address(this), address(router), tAmount);
937 
938         // make the swap
939         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
940             tAmount,
941             0, // accept any amount of ETH
942             path,
943             address(this),
944             block.timestamp
945         );
946 
947     }
948 
949     function addLiquidity(uint256 tAmount, uint256 ethAmount) private {
950         // approve token transfer to cover all possible scenarios
951         _approve(address(this), address(router), tAmount);
952 
953         // add the liquidity
954         router.addLiquidityETH{ value: ethAmount } (address(this), tAmount, 0, 0 , address(this), block.timestamp);
955     }
956 
957     function swapBack() private {
958         uint256 contractTokenBalance = balanceOf(address(this));
959         uint256 toSwap = tokensForLiquidity + tokensForMarketing + tokensForDevelopment;
960         bool success;
961 
962         if (contractTokenBalance == 0 || toSwap == 0) { return; }
963 
964         if (contractTokenBalance > thresholdSwapAmount * 20) {
965             contractTokenBalance = thresholdSwapAmount * 20;
966         }
967 
968         // Halve the amount of liquidity tokens
969         uint256 liquidityTokens = contractTokenBalance * tokensForLiquidity / toSwap / 2;
970         uint256 amountToSwapForETH = contractTokenBalance.sub(liquidityTokens);
971  
972         uint256 initialETHBalance = address(this).balance;
973 
974         swapTokensForEth(amountToSwapForETH); 
975  
976         uint256 newBalance = address(this).balance.sub(initialETHBalance);
977  
978         uint256 ethForMarketing = newBalance.mul(tokensForMarketing).div(toSwap);
979         uint256 ethForDevelopment = newBalance.mul(tokensForDevelopment).div(toSwap);
980         uint256 ethForLiquidity = newBalance - (ethForMarketing + ethForDevelopment);
981 
982 
983         tokensForLiquidity = 0;
984         tokensForMarketing = 0;
985         tokensForDevelopment = 0;
986 
987 
988         if (liquidityTokens > 0 && ethForLiquidity > 0) {
989             addLiquidity(liquidityTokens, ethForLiquidity);
990             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity);
991         }
992 
993         (success,) = address(developmentWallet).call{ value: (address(this).balance - ethForMarketing) } ("");
994         (success,) = address(marketingWallet).call{ value: address(this).balance } ("");
995     }
996 
997 }