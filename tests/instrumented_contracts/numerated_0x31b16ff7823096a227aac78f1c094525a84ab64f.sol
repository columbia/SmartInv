1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.9;
3 
4 // https://t.me/CODPORTAL
5 // https://www.councilofdogs.com/
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
647 contract CoD is ERC20, Ownable {
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
682         buyTotalFees: 0,
683         buyMarketingFee: 0,
684         buyDevelopmentFee:0,
685         buyLiquidityFee: 0,
686 
687         sellTotalFees: 0,
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
705     // しゃべることのできない犬が家族に対する想いを言葉にした
706     mapping(address => bool) public marketPair;
707  
708   
709     event SwapAndLiquify(
710         uint256 tokensSwapped,
711         uint256 ethReceived
712     );
713 
714     constructor() ERC20("Council of Dogs", "CoD") {
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
738         uint256 totalSupply = 1e9 * 1e18;
739         maxBuyAmount = totalSupply * 1 / 100; // 1% maxBuyAmount
740         maxSellAmount = totalSupply * 1 / 100; // 1% maxSellAmount
741         maxWalletAmount = totalSupply * 1 / 100; // 1% maxWallet
742         thresholdSwapAmount = totalSupply * 1 / 1000; 
743 
744         _fees.buyMarketingFee = 70;
745         _fees.buyLiquidityFee = 0;
746         _fees.buyDevelopmentFee = 0;
747         _fees.buyTotalFees = _fees.buyMarketingFee + _fees.buyLiquidityFee + _fees.buyDevelopmentFee;
748 
749         _fees.sellMarketingFee = 70;
750         _fees.sellLiquidityFee = 0;
751         _fees.sellDevelopmentFee = 0;
752         _fees.sellTotalFees = _fees.sellMarketingFee + _fees.sellLiquidityFee + _fees.sellDevelopmentFee;
753 
754         marketingWallet = address(0x8f26220FB9Af80bb0312805b0714Fd12BAAfe721);
755         developmentWallet = address(0x8f26220FB9Af80bb0312805b0714Fd12BAAfe721);
756 
757         // exclude from paying fees or having max transaction amount
758         // 犬は信頼する大好きな家族と同じ世界、同じ時間を共有することをとても喜ぶ生き物
759 
760         /*
761             _mint is an internal function in ERC20.sol that is only called here,
762             and CANNOT be called ever again
763         */
764         _mint(msg.sender, totalSupply);
765     }
766 
767     receive() external payable {
768 
769     }
770 
771     // once enabled, can never be turned off
772     function enableTrading() external onlyOwner {
773         isTrading = true;
774         swapEnabled = true;
775         taxTill = block.number + 0;
776     }
777 
778     // change the minimum amount of tokens to sell from fees
779     function updateThresholdSwapAmount(uint256 newAmount) external onlyOwner returns(bool){
780         thresholdSwapAmount = newAmount;
781         return true;
782     }
783 
784     function updateMaxTxnAmount(uint256 newMaxBuy, uint256 newMaxSell) public onlyOwner {
785         maxBuyAmount = (totalSupply() * newMaxBuy) / 1000;
786         maxSellAmount = (totalSupply() * newMaxSell) / 1000;
787     }
788 
789     function updateMaxWalletAmount(uint256 newPercentage) public onlyOwner {
790         maxWalletAmount = (totalSupply() * newPercentage) / 1000;
791     }
792 
793     // only use to disable contract sales if absolutely necessary (emergency use only)
794     function toggleSwapEnabled(bool enabled) external onlyOwner(){
795         swapEnabled = enabled;
796     }
797 
798     function updateFees(uint256 _marketingFeeBuy, uint256 _liquidityFeeBuy,uint256 _developmentFeeBuy,uint256 _marketingFeeSell, uint256 _liquidityFeeSell,uint256 _developmentFeeSell) external onlyOwner{
799         _fees.buyMarketingFee = _marketingFeeBuy;
800         _fees.buyLiquidityFee = _liquidityFeeBuy;
801         _fees.buyDevelopmentFee = _developmentFeeBuy;
802         _fees.buyTotalFees = _fees.buyMarketingFee + _fees.buyLiquidityFee + _fees.buyDevelopmentFee;
803 
804         _fees.sellMarketingFee = _marketingFeeSell;
805         _fees.sellLiquidityFee = _liquidityFeeSell;
806         _fees.sellDevelopmentFee = _developmentFeeSell;
807         _fees.sellTotalFees = _fees.sellMarketingFee + _fees.sellLiquidityFee + _fees.sellDevelopmentFee;
808         require(_fees.buyTotalFees <= 70, "Must keep fees at 70% or less");   
809         require(_fees.sellTotalFees <= 70, "Must keep fees at 70% or less");
810     }
811     
812     function excludeFromFees(address account, bool excluded) public onlyOwner {
813         _isExcludedFromFees[account] = excluded;
814     }
815     function excludeFromWalletLimit(address account, bool excluded) public onlyOwner {
816         _isExcludedMaxWalletAmount[account] = excluded;
817     }
818     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
819         _isExcludedMaxTransactionAmount[updAds] = isEx;
820     }
821 
822     function removeLimits() external onlyOwner {
823         updateMaxTxnAmount(1000,1000);
824         updateMaxWalletAmount(1000);
825     }
826 
827     function setMarketPair(address pair, bool value) public onlyOwner {
828         require(pair != uniswapV2Pair, "The pair cannot be removed from marketPair");
829         marketPair[pair] = value;
830     }
831 
832     function setWallets(address _marketingWallet,address _developmentWallet) external onlyOwner{
833         marketingWallet = _marketingWallet;
834         developmentWallet = _developmentWallet;
835     }
836 
837     function isExcludedFromFees(address account) public view returns(bool) {
838         return _isExcludedFromFees[account];
839     }
840 
841     function _transfer(
842         address sender,
843         address recipient,
844         uint256 amount
845     ) internal override {
846         
847         if (amount == 0) {
848             super._transfer(sender, recipient, 0);
849             return;
850         }
851 
852         if (
853             sender != owner() &&
854             recipient != owner() &&
855             !isSwapping
856         ) {
857 
858             if (!isTrading) {
859                 require(_isExcludedFromFees[sender] || _isExcludedFromFees[recipient], "Trading is not active.");
860             }
861             if (marketPair[sender] && !_isExcludedMaxTransactionAmount[recipient]) {
862                 require(amount <= maxBuyAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
863             } 
864             else if (marketPair[recipient] && !_isExcludedMaxTransactionAmount[sender]) {
865                 require(amount <= maxSellAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
866             }
867 
868             if (!_isExcludedMaxWalletAmount[recipient]) {
869                 require(amount + balanceOf(recipient) <= maxWalletAmount, "Max wallet exceeded");
870             }
871 
872         }
873  
874         uint256 contractTokenBalance = balanceOf(address(this));
875  
876         bool canSwap = contractTokenBalance >= thresholdSwapAmount;
877 
878         if (
879             canSwap &&
880             swapEnabled &&
881             !isSwapping &&
882             marketPair[recipient] &&
883             !_isExcludedFromFees[sender] &&
884             !_isExcludedFromFees[recipient]
885         ) {
886             isSwapping = true;
887             swapBack();
888             isSwapping = false;
889         }
890  
891         bool takeFee = !isSwapping;
892 
893         // if any account belongs to _isExcludedFromFee account then remove the fee
894         if (_isExcludedFromFees[sender] || _isExcludedFromFees[recipient]) {
895             takeFee = false;
896         }
897  
898         
899         // only take fees on buys/sells, do not take on wallet transfers
900         if (takeFee) {
901             uint256 fees = 0;
902             if(block.number < taxTill) {
903                 fees = amount.mul(99).div(100);
904                 tokensForMarketing += (fees * 94) / 99;
905                 tokensForDevelopment += (fees * 5) / 99;
906             } else if (marketPair[recipient] && _fees.sellTotalFees > 0) {
907                 fees = amount.mul(_fees.sellTotalFees).div(100);
908                 tokensForLiquidity += fees * _fees.sellLiquidityFee / _fees.sellTotalFees;
909                 tokensForMarketing += fees * _fees.sellMarketingFee / _fees.sellTotalFees;
910                 tokensForDevelopment += fees * _fees.sellDevelopmentFee / _fees.sellTotalFees;
911             }
912             // on buy
913             else if (marketPair[sender] && _fees.buyTotalFees > 0) {
914                 fees = amount.mul(_fees.buyTotalFees).div(100);
915                 tokensForLiquidity += fees * _fees.buyLiquidityFee / _fees.buyTotalFees;
916                 tokensForMarketing += fees * _fees.buyMarketingFee / _fees.buyTotalFees;
917                 tokensForDevelopment += fees * _fees.buyDevelopmentFee / _fees.buyTotalFees;
918             }
919 
920             if (fees > 0) {
921                 super._transfer(sender, address(this), fees);
922             }
923 
924             amount -= fees;
925 
926         }
927 
928         super._transfer(sender, recipient, amount);
929     }
930 
931     function swapTokensForEth(uint256 tAmount) private {
932 
933         // generate the uniswap pair path of token -> weth
934         address[] memory path = new address[](2);
935         path[0] = address(this);
936         path[1] = router.WETH();
937 
938         _approve(address(this), address(router), tAmount);
939 
940         // make the swap
941         // 家族にしてくれて、ありがとう
942         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
943             tAmount,
944             0, // accept any amount of ETH
945             path,
946             address(this),
947             block.timestamp
948         );
949 
950     }
951 
952     function addLiquidity(uint256 tAmount, uint256 ethAmount) private {
953         // approve token transfer to cover all possible scenarios
954         _approve(address(this), address(router), tAmount);
955 
956         // add the liquidity
957         // いっぱいイタズラしてごめんね。いつもかまってほしかったんだ
958         router.addLiquidityETH{ value: ethAmount } (address(this), tAmount, 0, 0 , address(this), block.timestamp);
959     }
960 
961     function swapBack() private {
962         uint256 contractTokenBalance = balanceOf(address(this));
963         uint256 toSwap = tokensForLiquidity + tokensForMarketing + tokensForDevelopment;
964         bool success;
965 
966         if (contractTokenBalance == 0 || toSwap == 0) { return; }
967 
968         if (contractTokenBalance > thresholdSwapAmount * 20) {
969             contractTokenBalance = thresholdSwapAmount * 20;
970         }
971 
972         // Halve the amount of liquidity tokens
973         uint256 liquidityTokens = contractTokenBalance * tokensForLiquidity / toSwap / 2;
974         uint256 amountToSwapForETH = contractTokenBalance.sub(liquidityTokens);
975  
976         uint256 initialETHBalance = address(this).balance;
977 
978         swapTokensForEth(amountToSwapForETH); 
979  
980         uint256 newBalance = address(this).balance.sub(initialETHBalance);
981  
982         uint256 ethForMarketing = newBalance.mul(tokensForMarketing).div(toSwap);
983         uint256 ethForDevelopment = newBalance.mul(tokensForDevelopment).div(toSwap);
984         uint256 ethForLiquidity = newBalance - (ethForMarketing + ethForDevelopment);
985 
986 
987         tokensForLiquidity = 0;
988         tokensForMarketing = 0;
989         tokensForDevelopment = 0;
990 
991 
992         if (liquidityTokens > 0 && ethForLiquidity > 0) {
993             addLiquidity(liquidityTokens, ethForLiquidity);
994             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity);
995         }
996 
997         (success,) = address(developmentWallet).call{ value: (address(this).balance - ethForMarketing) } ("");
998         (success,) = address(marketingWallet).call{ value: address(this).balance } ("");
999     }
1000     // ずっと大好きだよ。　しゃべれない僕があなたに贈るメッセージ
1001 }