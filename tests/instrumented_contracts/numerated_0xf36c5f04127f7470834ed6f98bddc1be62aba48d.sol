1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.9;
3  
4 
5 
6 interface IUniswapV2Factory {
7     function createPair(address tokenA, address tokenB) external returns(address pair);
8 }
9 
10 interface IERC20 {
11     /**
12      * @dev Returns the amount of tokens in existence.
13      */
14     function totalSupply() external view returns(uint256);
15 
16     /**
17     * @dev Returns the amount of tokens owned by `account`.
18     */
19     function balanceOf(address account) external view returns(uint256);
20 
21     /**
22     * @dev Moves `amount` tokens from the caller's account to `recipient`.
23     *
24     * Returns a boolean value indicating whether the operation succeeded.
25     *
26     * Emits a {Transfer} event.
27     */
28     function transfer(address recipient, uint256 amount) external returns(bool);
29 
30     /**
31     * @dev Returns the remaining number of tokens that `spender` will be
32     * allowed to spend on behalf of `owner` through {transferFrom}. This is
33     * zero by default.
34     *
35     * This value changes when {approve} or {transferFrom} are called.
36     */
37     function allowance(address owner, address spender) external view returns(uint256);
38 
39     /**
40     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
41     *
42     * Returns a boolean value indicating whether the operation succeeded.
43     *
44     * IMPORTANT: Beware that changing an allowance with this method brings the risk
45     * that someone may use both the old and the new allowance by unfortunate
46     * transaction ordering. One possible solution to mitigate this race
47     * condition is to first reduce the spender's allowance to 0 and set the
48     * desired value afterwards:
49     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
50     *
51     * Emits an {Approval} event.
52     */
53     function approve(address spender, uint256 amount) external returns(bool);
54 
55     /**
56     * @dev Moves `amount` tokens from `sender` to `recipient` using the
57     * allowance mechanism. `amount` is then deducted from the caller's
58     * allowance.
59     *
60     * Returns a boolean value indicating whether the operation succeeded.
61     *
62     * Emits a {Transfer} event.
63     */
64     function transferFrom(
65         address sender,
66         address recipient,
67         uint256 amount
68     ) external returns(bool);
69 
70         /**
71         * @dev Emitted when `value` tokens are moved from one account (`from`) to
72         * another (`to`).
73         *
74         * Note that `value` may be zero.
75         */
76         event Transfer(address indexed from, address indexed to, uint256 value);
77 
78         /**
79         * @dev Emitted when the allowance of a `spender` for an `owner` is set by
80         * a call to {approve}. `value` is the new allowance.
81         */
82         event Approval(address indexed owner, address indexed spender, uint256 value);
83 }
84 
85 interface IERC20Metadata is IERC20 {
86     /**
87      * @dev Returns the name of the token.
88      */
89     function name() external view returns(string memory);
90 
91     /**
92      * @dev Returns the symbol of the token.
93      */
94     function symbol() external view returns(string memory);
95 
96     /**
97      * @dev Returns the decimals places of the token.
98      */
99     function decimals() external view returns(uint8);
100 }
101 
102 abstract contract Context {
103     function _msgSender() internal view virtual returns(address) {
104         return msg.sender;
105     }
106 
107 }
108 
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
444  
445  
446 library SafeMathInt {
447     int256 private constant MIN_INT256 = int256(1) << 255;
448     int256 private constant MAX_INT256 = ~(int256(1) << 255);
449 
450     /**
451      * @dev Multiplies two int256 variables and fails on overflow.
452      */
453     function mul(int256 a, int256 b) internal pure returns(int256) {
454         int256 c = a * b;
455 
456         // Detect overflow when multiplying MIN_INT256 with -1
457         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
458         require((b == 0) || (c / b == a));
459         return c;
460     }
461 
462     /**
463      * @dev Division of two int256 variables and fails on overflow.
464      */
465     function div(int256 a, int256 b) internal pure returns(int256) {
466         // Prevent overflow when dividing MIN_INT256 by -1
467         require(b != -1 || a != MIN_INT256);
468 
469         // Solidity already throws when dividing by 0.
470         return a / b;
471     }
472 
473     /**
474      * @dev Subtracts two int256 variables and fails on overflow.
475      */
476     function sub(int256 a, int256 b) internal pure returns(int256) {
477         int256 c = a - b;
478         require((b >= 0 && c <= a) || (b < 0 && c > a));
479         return c;
480     }
481 
482     /**
483      * @dev Adds two int256 variables and fails on overflow.
484      */
485     function add(int256 a, int256 b) internal pure returns(int256) {
486         int256 c = a + b;
487         require((b >= 0 && c >= a) || (b < 0 && c < a));
488         return c;
489     }
490 
491     /**
492      * @dev Converts to absolute value, and fails on overflow.
493      */
494     function abs(int256 a) internal pure returns(int256) {
495         require(a != MIN_INT256);
496         return a < 0 ? -a : a;
497     }
498 
499 
500     function toUint256Safe(int256 a) internal pure returns(uint256) {
501         require(a >= 0);
502         return uint256(a);
503     }
504 }
505  
506 library SafeMathUint {
507     function toInt256Safe(uint256 a) internal pure returns(int256) {
508     int256 b = int256(a);
509         require(b >= 0);
510         return b;
511     }
512 }
513 
514 
515 interface IUniswapV2Router01 {
516     function factory() external pure returns(address);
517     function WETH() external pure returns(address);
518 
519     function addLiquidity(
520         address tokenA,
521         address tokenB,
522         uint amountADesired,
523         uint amountBDesired,
524         uint amountAMin,
525         uint amountBMin,
526         address to,
527         uint deadline
528     ) external returns(uint amountA, uint amountB, uint liquidity);
529     function addLiquidityETH(
530         address token,
531         uint amountTokenDesired,
532         uint amountTokenMin,
533         uint amountETHMin,
534         address to,
535         uint deadline
536     ) external payable returns(uint amountToken, uint amountETH, uint liquidity);
537     function removeLiquidity(
538         address tokenA,
539         address tokenB,
540         uint liquidity,
541         uint amountAMin,
542         uint amountBMin,
543         address to,
544         uint deadline
545     ) external returns(uint amountA, uint amountB);
546     function removeLiquidityETH(
547         address token,
548         uint liquidity,
549         uint amountTokenMin,
550         uint amountETHMin,
551         address to,
552         uint deadline
553     ) external returns(uint amountToken, uint amountETH);
554     function removeLiquidityWithPermit(
555         address tokenA,
556         address tokenB,
557         uint liquidity,
558         uint amountAMin,
559         uint amountBMin,
560         address to,
561         uint deadline,
562         bool approveMax, uint8 v, bytes32 r, bytes32 s
563     ) external returns(uint amountA, uint amountB);
564     function removeLiquidityETHWithPermit(
565         address token,
566         uint liquidity,
567         uint amountTokenMin,
568         uint amountETHMin,
569         address to,
570         uint deadline,
571         bool approveMax, uint8 v, bytes32 r, bytes32 s
572     ) external returns(uint amountToken, uint amountETH);
573     function swapExactTokensForTokens(
574         uint amountIn,
575         uint amountOutMin,
576         address[] calldata path,
577         address to,
578         uint deadline
579     ) external returns(uint[] memory amounts);
580     function swapTokensForExactTokens(
581         uint amountOut,
582         uint amountInMax,
583         address[] calldata path,
584         address to,
585         uint deadline
586     ) external returns(uint[] memory amounts);
587     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
588     external
589     payable
590     returns(uint[] memory amounts);
591     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
592     external
593     returns(uint[] memory amounts);
594     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
595     external
596     returns(uint[] memory amounts);
597     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
598     external
599     payable
600     returns(uint[] memory amounts);
601 
602     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns(uint amountB);
603     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns(uint amountOut);
604     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns(uint amountIn);
605     function getAmountsOut(uint amountIn, address[] calldata path) external view returns(uint[] memory amounts);
606     function getAmountsIn(uint amountOut, address[] calldata path) external view returns(uint[] memory amounts);
607 }
608 
609 interface IUniswapV2Router02 is IUniswapV2Router01 {
610     function removeLiquidityETHSupportingFeeOnTransferTokens(
611         address token,
612         uint liquidity,
613         uint amountTokenMin,
614         uint amountETHMin,
615         address to,
616         uint deadline
617     ) external returns(uint amountETH);
618     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
619         address token,
620         uint liquidity,
621         uint amountTokenMin,
622         uint amountETHMin,
623         address to,
624         uint deadline,
625         bool approveMax, uint8 v, bytes32 r, bytes32 s
626     ) external returns(uint amountETH);
627 
628     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
629         uint amountIn,
630         uint amountOutMin,
631         address[] calldata path,
632         address to,
633         uint deadline
634     ) external;
635     function swapExactETHForTokensSupportingFeeOnTransferTokens(
636         uint amountOutMin,
637         address[] calldata path,
638         address to,
639         uint deadline
640     ) external payable;
641     function swapExactTokensForETHSupportingFeeOnTransferTokens(
642         uint amountIn,
643         uint amountOutMin,
644         address[] calldata path,
645         address to,
646         uint deadline
647     ) external;
648 }
649  
650 contract CryptoAI is ERC20, Ownable {
651     using SafeMath for uint256;
652 
653     IUniswapV2Router02 public immutable router;
654     address public immutable uniswapV2Pair;
655 
656 
657     // addresses
658     address private contestAIWallet;
659     address private marketingWallet;
660 
661     // limits 
662     uint256 private maxBuyAmount;
663     uint256 private maxSellAmount;   
664     uint256 private maxWalletAmount;
665  
666     uint256 private thresholdSwapAmount;
667 
668     // status flags
669     bool private isTrading = false;
670     bool public swapEnabled = false;
671     bool public isSwapping;
672 
673 
674     struct Fees {
675         uint256 buyTotalFees;
676         uint256 buyMarketingFee;
677         uint256 buyContestAIFee;
678         uint256 buyLiquidityFee;
679 
680         uint256 sellTotalFees;
681         uint256 sellMarketingFee;
682         uint256 sellContestAIFee;
683         uint256 sellLiquidityFee;
684     }  
685 
686     Fees public _fees = Fees({
687         buyTotalFees: 0,
688         buyMarketingFee: 0,
689         buyContestAIFee:0,
690         buyLiquidityFee: 0,
691 
692         sellTotalFees: 0,
693         sellMarketingFee: 0,
694         sellContestAIFee:0,
695         sellLiquidityFee: 0
696     });
697     
698     
699 
700     uint256 public tokensForMarketing;
701     uint256 public tokensForLiquidity;
702     uint256 public tokensForContestAI;
703     uint256 private taxTill;
704     // exclude from fees and max transaction amount
705     mapping(address => bool) private _isExcludedFromFees;
706     mapping(address => bool) public _isExcludedMaxTransactionAmount;
707     mapping(address => bool) public _isExcludedMaxWalletAmount;
708 
709     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
710     // could be subject to a maximum transfer amount
711     mapping(address => bool) public marketPair;
712  
713   
714     event SwapAndLiquify(
715         uint256 tokensSwapped,
716         uint256 ethReceived
717     );
718 
719 
720     constructor() ERC20("CryptoAI", "CAI") {
721  
722         router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
723 
724 
725         uniswapV2Pair = IUniswapV2Factory(router.factory()).createPair(address(this), router.WETH());
726 
727         _isExcludedMaxTransactionAmount[address(router)] = true;
728         _isExcludedMaxTransactionAmount[address(uniswapV2Pair)] = true;        
729         _isExcludedMaxTransactionAmount[owner()] = true;
730         _isExcludedMaxTransactionAmount[address(this)] = true;
731 
732         _isExcludedFromFees[owner()] = true;
733         _isExcludedFromFees[address(this)] = true;
734 
735         _isExcludedMaxWalletAmount[owner()] = true;
736         _isExcludedMaxWalletAmount[address(this)] = true;
737         _isExcludedMaxWalletAmount[address(uniswapV2Pair)] = true;
738 
739 
740         marketPair[address(uniswapV2Pair)] = true;
741 
742         approve(address(router), type(uint256).max);
743         uint256 totalSupply = 1e8 * 1e18;
744 
745         maxBuyAmount = totalSupply / 200; // 0.50% maxTransactionAmountTxn
746         maxSellAmount = totalSupply / 100; // 1% maxTransactionAmountTxn
747         maxWalletAmount = totalSupply * 1 / 100; // 1% maxWallet
748         thresholdSwapAmount = totalSupply * 1 / 10000; // 0.01% swap wallet
749 
750         _fees.buyMarketingFee = 3;
751         _fees.buyLiquidityFee = 1;
752         _fees.buyContestAIFee = 1;
753         _fees.buyTotalFees = _fees.buyMarketingFee + _fees.buyLiquidityFee + _fees.buyContestAIFee;
754 
755         _fees.sellMarketingFee = 3;
756         _fees.sellLiquidityFee = 1;
757         _fees.sellContestAIFee = 1;
758         _fees.sellTotalFees = _fees.sellMarketingFee + _fees.sellLiquidityFee + _fees.sellContestAIFee;
759 
760 
761         marketingWallet = address(0x78c57e6be0886Bd40d40f8AD37f73b6E1c86ED78);
762         contestAIWallet = address(0x0cBc4567E63b8E195a3a0dD683079b2066DDA321);
763 
764         // exclude from paying fees or having max transaction amount
765 
766         /*
767             _mint is an internal function in ERC20.sol that is only called here,
768             and CANNOT be called ever again
769         */
770         _mint(msg.sender, totalSupply);
771     }
772 
773     receive() external payable {
774 
775     }
776 
777     // once enabled, can never be turned off
778     function swapTrading() external onlyOwner {
779         isTrading = true;
780         swapEnabled = true;
781         taxTill = block.number + 2;
782     }
783 
784 
785 
786     // change the minimum amount of tokens to sell from fees
787     function updateThresholdSwapAmount(uint256 newAmount) external onlyOwner returns(bool){
788         thresholdSwapAmount = newAmount;
789         return true;
790     }
791 
792 
793     function updateMaxTxnAmount(uint256 newMaxBuy, uint256 newMaxSell) external onlyOwner {
794         require(((totalSupply() * newMaxBuy) / 1000) >= (totalSupply() / 100), "Cannot set maxTransactionAmounts lower than 1%");
795         require(((totalSupply() * newMaxSell) / 1000) >= (totalSupply() / 100), "Cannot set maxTransactionAmounts lower than 1%");
796         maxBuyAmount = (totalSupply() * newMaxBuy) / 1000;
797         maxSellAmount = (totalSupply() * newMaxSell) / 1000;
798     }
799 
800 
801     function updateMaxWalletAmount(uint256 newPercentage) external onlyOwner {
802         require(((totalSupply() * newPercentage) / 1000) >= (totalSupply() / 100), "Cannot set maxWallet lower than 1%");
803         maxWalletAmount = (totalSupply() * newPercentage) / 1000;
804     }
805 
806     // only use to disable contract sales if absolutely necessary (emergency use only)
807     function toggleSwapEnabled(bool enabled) external onlyOwner(){
808         swapEnabled = enabled;
809     }
810 
811     function updateFees(uint256 _marketingFeeBuy, uint256 _liquidityFeeBuy,uint256 _contestAIFeeBuy,uint256 _marketingFeeSell, uint256 _liquidityFeeSell,uint256 _contestAIFeeSell) external onlyOwner{
812         _fees.buyMarketingFee = _marketingFeeBuy;
813         _fees.buyLiquidityFee = _liquidityFeeBuy;
814         _fees.buyContestAIFee = _contestAIFeeBuy;
815         _fees.buyTotalFees = _fees.buyMarketingFee + _fees.buyLiquidityFee + _fees.buyContestAIFee;
816 
817         _fees.sellMarketingFee = _marketingFeeSell;
818         _fees.sellLiquidityFee = _liquidityFeeSell;
819         _fees.sellContestAIFee = _contestAIFeeSell;
820         _fees.sellTotalFees = _fees.sellMarketingFee + _fees.sellLiquidityFee + _fees.sellContestAIFee;
821         require(_fees.buyTotalFees <= 99, "Must keep fees at 99% or less");   
822         require(_fees.sellTotalFees <= 99, "Must keep fees at 99% or less");
823      
824     }
825     
826     function excludeFromFees(address account, bool excluded) public onlyOwner {
827         _isExcludedFromFees[account] = excluded;
828     }
829     function excludeFromWalletLimit(address account, bool excluded) public onlyOwner {
830         _isExcludedMaxWalletAmount[account] = excluded;
831     }
832     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
833         _isExcludedMaxTransactionAmount[updAds] = isEx;
834     }
835 
836 
837     function setMarketPair(address pair, bool value) public onlyOwner {
838         require(pair != uniswapV2Pair, "The pair cannot be removed from marketPair");
839         marketPair[pair] = value;
840     }
841 
842 
843     function setWallets(address _marketingWallet,address _contestAIWallet) external onlyOwner{
844         marketingWallet = _marketingWallet;
845         contestAIWallet = _contestAIWallet;
846     }
847 
848     function isExcludedFromFees(address account) public view returns(bool) {
849         return _isExcludedFromFees[account];
850     }
851 
852     function _transfer(
853         address sender,
854         address recipient,
855         uint256 amount
856     ) internal override {
857         
858         if (amount == 0) {
859             super._transfer(sender, recipient, 0);
860             return;
861         }
862 
863         if (
864             sender != owner() &&
865             recipient != owner() &&
866             !isSwapping
867         ) {
868 
869             if (!isTrading) {
870                 require(_isExcludedFromFees[sender] || _isExcludedFromFees[recipient], "Trading is not active.");
871             }
872             if (marketPair[sender] && !_isExcludedMaxTransactionAmount[recipient]) {
873                 require(amount <= maxBuyAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
874             } 
875             else if (marketPair[recipient] && !_isExcludedMaxTransactionAmount[sender]) {
876                 require(amount <= maxSellAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
877             }
878 
879             if (!_isExcludedMaxWalletAmount[recipient]) {
880                 require(amount + balanceOf(recipient) <= maxWalletAmount, "Max wallet exceeded");
881             }
882 
883         }
884  
885         
886  
887         uint256 contractTokenBalance = balanceOf(address(this));
888  
889         bool canSwap = contractTokenBalance >= thresholdSwapAmount;
890 
891         if (
892             canSwap &&
893             swapEnabled &&
894             !isSwapping &&
895             marketPair[recipient] &&
896             !_isExcludedFromFees[sender] &&
897             !_isExcludedFromFees[recipient]
898         ) {
899             isSwapping = true;
900             swapBack();
901             isSwapping = false;
902         }
903  
904         bool takeFee = !isSwapping;
905 
906         // if any account belongs to _isExcludedFromFee account then remove the fee
907         if (_isExcludedFromFees[sender] || _isExcludedFromFees[recipient]) {
908             takeFee = false;
909         }
910  
911         
912         // only take fees on buys/sells, do not take on wallet transfers
913         if (takeFee) {
914             uint256 fees = 0;
915             if(block.number < taxTill) {
916                 fees = amount.mul(99).div(100);
917                 tokensForMarketing += (fees * 94) / 99;
918                 tokensForContestAI += (fees * 5) / 99;
919             } else if (marketPair[recipient] && _fees.sellTotalFees > 0) {
920                 fees = amount.mul(_fees.sellTotalFees).div(100);
921                 tokensForLiquidity += fees * _fees.sellLiquidityFee / _fees.sellTotalFees;
922                 tokensForMarketing += fees * _fees.sellMarketingFee / _fees.sellTotalFees;
923                 tokensForContestAI += fees * _fees.sellContestAIFee / _fees.sellTotalFees;
924             }
925             // on buy
926             else if (marketPair[sender] && _fees.buyTotalFees > 0) {
927                 fees = amount.mul(_fees.buyTotalFees).div(100);
928                 tokensForLiquidity += fees * _fees.buyLiquidityFee / _fees.buyTotalFees;
929                 tokensForMarketing += fees * _fees.buyMarketingFee / _fees.buyTotalFees;
930                 tokensForContestAI += fees * _fees.buyContestAIFee / _fees.buyTotalFees;
931             }
932 
933             if (fees > 0) {
934                 super._transfer(sender, address(this), fees);
935             }
936 
937             amount -= fees;
938 
939         }
940 
941         super._transfer(sender, recipient, amount);
942     }
943 
944     function swapTokensForEth(uint256 tAmount) private {
945 
946         // generate the uniswap pair path of token -> weth
947         address[] memory path = new address[](2);
948         path[0] = address(this);
949         path[1] = router.WETH();
950 
951         _approve(address(this), address(router), tAmount);
952 
953         // make the swap
954         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
955             tAmount,
956             0, // accept any amount of ETH
957             path,
958             address(this),
959             block.timestamp
960         );
961 
962     }
963 
964     function addLiquidity(uint256 tAmount, uint256 ethAmount) private {
965         // approve token transfer to cover all possible scenarios
966         _approve(address(this), address(router), tAmount);
967 
968         // add the liquidity
969         router.addLiquidityETH{ value: ethAmount } (address(this), tAmount, 0, 0 , address(this), block.timestamp);
970     }
971 
972     function swapBack() private {
973         uint256 contractTokenBalance = balanceOf(address(this));
974         uint256 toSwap = tokensForLiquidity + tokensForMarketing + tokensForContestAI;
975         bool success;
976 
977         if (contractTokenBalance == 0 || toSwap == 0) { return; }
978 
979         if (contractTokenBalance > thresholdSwapAmount * 20) {
980             contractTokenBalance = thresholdSwapAmount * 20;
981         }
982 
983         // Halve the amount of liquidity tokens
984         uint256 liquidityTokens = contractTokenBalance * tokensForLiquidity / toSwap / 2;
985         uint256 amountToSwapForETH = contractTokenBalance.sub(liquidityTokens);
986  
987         uint256 initialETHBalance = address(this).balance;
988 
989         swapTokensForEth(amountToSwapForETH); 
990  
991         uint256 newBalance = address(this).balance.sub(initialETHBalance);
992  
993         uint256 ethForMarketing = newBalance.mul(tokensForMarketing).div(toSwap);
994         uint256 ethForContestAI = newBalance.mul(tokensForContestAI).div(toSwap);
995         uint256 ethForLiquidity = newBalance - (ethForMarketing + ethForContestAI);
996 
997 
998         tokensForLiquidity = 0;
999         tokensForMarketing = 0;
1000         tokensForContestAI = 0;
1001 
1002 
1003         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1004             addLiquidity(liquidityTokens, ethForLiquidity);
1005             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity);
1006         }
1007 
1008         (success,) = address(contestAIWallet).call{ value: (address(this).balance - ethForMarketing) } ("");
1009         (success,) = address(marketingWallet).call{ value: address(this).balance } ("");
1010     }
1011 
1012 }