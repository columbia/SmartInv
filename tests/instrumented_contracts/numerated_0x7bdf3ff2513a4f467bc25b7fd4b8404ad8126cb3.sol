1 // SPDX-License-Identifier: MIT
2 
3 //telegram: https://t.me/musk_erc
4 //twitter: https://twitter.com/musk_erc
5 // website: https://elonmuskcoin.io
6 pragma solidity 0.8.9;
7  
8 
9 
10 interface IUniswapV2Factory {
11     function createPair(address tokenA, address tokenB) external returns(address pair);
12 }
13 
14 interface IERC20 {
15     /**
16      * @dev Returns the amount of tokens in existence.
17      */
18     function totalSupply() external view returns(uint256);
19 
20     /**
21     * @dev Returns the amount of tokens owned by `account`.
22     */
23     function balanceOf(address account) external view returns(uint256);
24 
25     /**
26     * @dev Moves `amount` tokens from the caller's account to `recipient`.
27     *
28     * Returns a boolean value indicating whether the operation succeeded.
29     *
30     * Emits a {Transfer} event.
31     */
32     function transfer(address recipient, uint256 amount) external returns(bool);
33 
34     /**
35     * @dev Returns the remaining number of tokens that `spender` will be
36     * allowed to spend on behalf of `owner` through {transferFrom}. This is
37     * zero by default.
38     *
39     * This value changes when {approve} or {transferFrom} are called.
40     */
41     function allowance(address owner, address spender) external view returns(uint256);
42 
43     /**
44     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
45     *
46     * Returns a boolean value indicating whether the operation succeeded.
47     *
48     * IMPORTANT: Beware that changing an allowance with this method brings the risk
49     * that someone may use both the old and the new allowance by unfortunate
50     * transaction ordering. One possible solution to mitigate this race
51     * condition is to first reduce the spender's allowance to 0 and set the
52     * desired value afterwards:
53     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
54     *
55     * Emits an {Approval} event.
56     */
57     function approve(address spender, uint256 amount) external returns(bool);
58 
59     /**
60     * @dev Moves `amount` tokens from `sender` to `recipient` using the
61     * allowance mechanism. `amount` is then deducted from the caller's
62     * allowance.
63     *
64     * Returns a boolean value indicating whether the operation succeeded.
65     *
66     * Emits a {Transfer} event.
67     */
68     function transferFrom(
69         address sender,
70         address recipient,
71         uint256 amount
72     ) external returns(bool);
73 
74         /**
75         * @dev Emitted when `value` tokens are moved from one account (`from`) to
76         * another (`to`).
77         *
78         * Note that `value` may be zero.
79         */
80         event Transfer(address indexed from, address indexed to, uint256 value);
81 
82         /**
83         * @dev Emitted when the allowance of a `spender` for an `owner` is set by
84         * a call to {approve}. `value` is the new allowance.
85         */
86         event Approval(address indexed owner, address indexed spender, uint256 value);
87 }
88 
89 interface IERC20Metadata is IERC20 {
90     /**
91      * @dev Returns the name of the token.
92      */
93     function name() external view returns(string memory);
94 
95     /**
96      * @dev Returns the symbol of the token.
97      */
98     function symbol() external view returns(string memory);
99 
100     /**
101      * @dev Returns the decimals places of the token.
102      */
103     function decimals() external view returns(uint8);
104 }
105 
106 abstract contract Context {
107     function _msgSender() internal view virtual returns(address) {
108         return msg.sender;
109     }
110 
111 }
112 
113  
114 contract ERC20 is Context, IERC20, IERC20Metadata {
115     using SafeMath for uint256;
116 
117         mapping(address => uint256) private _balances;
118 
119     mapping(address => mapping(address => uint256)) private _allowances;
120  
121     uint256 private _totalSupply;
122  
123     string private _name;
124     string private _symbol;
125 
126     /**
127      * @dev Sets the values for {name} and {symbol}.
128      *
129      * The default value of {decimals} is 18. To select a different value for
130      * {decimals} you should overload it.
131      *
132      * All two of these values are immutable: they can only be set once during
133      * construction.
134      */
135     constructor(string memory name_, string memory symbol_) {
136         _name = name_;
137         _symbol = symbol_;
138     }
139 
140     /**
141      * @dev Returns the name of the token.
142      */
143     function name() public view virtual override returns(string memory) {
144         return _name;
145     }
146 
147     /**
148      * @dev Returns the symbol of the token, usually a shorter version of the
149      * name.
150      */
151     function symbol() public view virtual override returns(string memory) {
152         return _symbol;
153     }
154 
155     /**
156      * @dev Returns the number of decimals used to get its user representation.
157      * For example, if `decimals` equals `2`, a balance of `505` tokens should
158      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
159      *
160      * Tokens usually opt for a value of 18, imitating the relationship between
161      * Ether and Wei. This is the value {ERC20} uses, unless this function is
162      * overridden;
163      *
164      * NOTE: This information is only used for _display_ purposes: it in
165      * no way affects any of the arithmetic of the contract, including
166      * {IERC20-balanceOf} and {IERC20-transfer}.
167      */
168     function decimals() public view virtual override returns(uint8) {
169         return 18;
170     }
171 
172     /**
173      * @dev See {IERC20-totalSupply}.
174      */
175     function totalSupply() public view virtual override returns(uint256) {
176         return _totalSupply;
177     }
178 
179     /**
180      * @dev See {IERC20-balanceOf}.
181      */
182     function balanceOf(address account) public view virtual override returns(uint256) {
183         return _balances[account];
184     }
185 
186     /**
187      * @dev See {IERC20-transfer}.
188      *
189      * Requirements:
190      *
191      * - `recipient` cannot be the zero address.
192      * - the caller must have a balance of at least `amount`.
193      */
194     function transfer(address recipient, uint256 amount) public virtual override returns(bool) {
195         _transfer(_msgSender(), recipient, amount);
196         return true;
197     }
198 
199     /**
200      * @dev See {IERC20-allowance}.
201      */
202     function allowance(address owner, address spender) public view virtual override returns(uint256) {
203         return _allowances[owner][spender];
204     }
205 
206     /**
207      * @dev See {IERC20-approve}.
208      *
209      * Requirements:
210      *
211      * - `spender` cannot be the zero address.
212      */
213     function approve(address spender, uint256 amount) public virtual override returns(bool) {
214         _approve(_msgSender(), spender, amount);
215         return true;
216     }
217 
218     /**
219      * @dev See {IERC20-transferFrom}.
220      *
221      * Emits an {Approval} event indicating the updated allowance. This is not
222      * required by the EIP. See the note at the beginning of {ERC20}.
223      *
224      * Requirements:
225      *
226      * - `sender` and `recipient` cannot be the zero address.
227      * - `sender` must have a balance of at least `amount`.
228      * - the caller must have allowance for ``sender``'s tokens of at least
229      * `amount`.
230      */
231     function transferFrom(
232         address sender,
233         address recipient,
234         uint256 amount
235     ) public virtual override returns(bool) {
236         _transfer(sender, recipient, amount);
237         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
238         return true;
239     }
240 
241     /**
242      * @dev Atomically increases the allowance granted to `spender` by the caller.
243      *
244      * This is an alternative to {approve} that can be used as a mitigation for
245      * problems described in {IERC20-approve}.
246      *
247      * Emits an {Approval} event indicating the updated allowance.
248      *
249      * Requirements:
250      *
251      * - `spender` cannot be the zero address.
252      */
253     function increaseAllowance(address spender, uint256 addedValue) public virtual returns(bool) {
254         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
255         return true;
256     }
257 
258     /**
259      * @dev Atomically decreases the allowance granted to `spender` by the caller.
260      *
261      * This is an alternative to {approve} that can be used as a mitigation for
262      * problems described in {IERC20-approve}.
263      *
264      * Emits an {Approval} event indicating the updated allowance.
265      *
266      * Requirements:
267      *
268      * - `spender` cannot be the zero address.
269      * - `spender` must have allowance for the caller of at least
270      * `subtractedValue`.
271      */
272     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns(bool) {
273         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased cannot be below zero"));
274         return true;
275     }
276 
277     /**
278      * @dev Moves tokens `amount` from `sender` to `recipient`.
279      *
280      * This is internal function is equivalent to {transfer}, and can be used to
281      * e.g. implement automatic token fees, slashing mechanisms, etc.
282      *
283      * Emits a {Transfer} event.
284      *
285      * Requirements:
286      *
287      * - `sender` cannot be the zero address.
288      * - `recipient` cannot be the zero address.
289      * - `sender` must have a balance of at least `amount`.
290      */
291     function _transfer(
292         address sender,
293         address recipient,
294         uint256 amount
295     ) internal virtual {
296         
297         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
298         _balances[recipient] = _balances[recipient].add(amount);
299         emit Transfer(sender, recipient, amount);
300     }
301 
302     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
303      * the total supply.
304      *
305      * Emits a {Transfer} event with `from` set to the zero address.
306      *
307      * Requirements:
308      *
309      * - `account` cannot be the zero address.
310      */
311     function _mint(address account, uint256 amount) internal virtual {
312         require(account != address(0), "ERC20: mint to the zero address");
313 
314         _totalSupply = _totalSupply.add(amount);
315         _balances[account] = _balances[account].add(amount);
316         emit Transfer(address(0), account, amount);
317     }
318 
319     
320     /**
321      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
322      *
323      * This internal function is equivalent to `approve`, and can be used to
324      * e.g. set automatic allowances for certain subsystems, etc.
325      *
326      * Emits an {Approval} event.
327      *
328      * Requirements:
329      *
330      * - `owner` cannot be the zero address.
331      * - `spender` cannot be the zero address.
332      */
333     function _approve(
334         address owner,
335         address spender,
336         uint256 amount
337     ) internal virtual {
338         _allowances[owner][spender] = amount;
339         emit Approval(owner, spender, amount);
340     }
341 
342     
343 }
344  
345 library SafeMath {
346    
347     function add(uint256 a, uint256 b) internal pure returns(uint256) {
348         uint256 c = a + b;
349         require(c >= a, "SafeMath: addition overflow");
350 
351         return c;
352     }
353 
354    
355     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
356         return sub(a, b, "SafeMath: subtraction overflow");
357     }
358 
359    
360     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns(uint256) {
361         require(b <= a, errorMessage);
362         uint256 c = a - b;
363 
364         return c;
365     }
366 
367     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
368     
369         if (a == 0) {
370             return 0;
371         }
372  
373         uint256 c = a * b;
374         require(c / a == b, "SafeMath: multiplication overflow");
375 
376         return c;
377     }
378 
379  
380     function div(uint256 a, uint256 b) internal pure returns(uint256) {
381         return div(a, b, "SafeMath: division by zero");
382     }
383 
384   
385     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns(uint256) {
386         require(b > 0, errorMessage);
387         uint256 c = a / b;
388         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
389 
390         return c;
391     }
392 
393     
394 }
395  
396 contract Ownable is Context {
397     address private _owner;
398  
399     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
400 
401     /**
402      * @dev Initializes the contract setting the deployer as the initial owner.
403      */
404     constructor() {
405         address msgSender = _msgSender();
406         _owner = msgSender;
407         emit OwnershipTransferred(address(0), msgSender);
408     }
409 
410     /**
411      * @dev Returns the address of the current owner.
412      */
413     function owner() public view returns(address) {
414         return _owner;
415     }
416 
417     /**
418      * @dev Throws if called by any account other than the owner.
419      */
420     modifier onlyOwner() {
421         require(_owner == _msgSender(), "Ownable: caller is not the owner");
422         _;
423     }
424 
425     /**
426      * @dev Leaves the contract without owner. It will not be possible to call
427      * `onlyOwner` functions anymore. Can only be called by the current owner.
428      *
429      * NOTE: Renouncing ownership will leave the contract without an owner,
430      * thereby removing any functionality that is only available to the owner.
431      */
432     function renounceOwnership() public virtual onlyOwner {
433         emit OwnershipTransferred(_owner, address(0));
434         _owner = address(0);
435     }
436 
437     /**
438      * @dev Transfers ownership of the contract to a new account (`newOwner`).
439      * Can only be called by the current owner.
440      */
441     function transferOwnership(address newOwner) public virtual onlyOwner {
442         require(newOwner != address(0), "Ownable: new owner is the zero address");
443         emit OwnershipTransferred(_owner, newOwner);
444         _owner = newOwner;
445     }
446 }
447  
448  
449  
450 library SafeMathInt {
451     int256 private constant MIN_INT256 = int256(1) << 255;
452     int256 private constant MAX_INT256 = ~(int256(1) << 255);
453 
454     /**
455      * @dev Multiplies two int256 variables and fails on overflow.
456      */
457     function mul(int256 a, int256 b) internal pure returns(int256) {
458         int256 c = a * b;
459 
460         // Detect overflow when multiplying MIN_INT256 with -1
461         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
462         require((b == 0) || (c / b == a));
463         return c;
464     }
465 
466     /**
467      * @dev Division of two int256 variables and fails on overflow.
468      */
469     function div(int256 a, int256 b) internal pure returns(int256) {
470         // Prevent overflow when dividing MIN_INT256 by -1
471         require(b != -1 || a != MIN_INT256);
472 
473         // Solidity already throws when dividing by 0.
474         return a / b;
475     }
476 
477     /**
478      * @dev Subtracts two int256 variables and fails on overflow.
479      */
480     function sub(int256 a, int256 b) internal pure returns(int256) {
481         int256 c = a - b;
482         require((b >= 0 && c <= a) || (b < 0 && c > a));
483         return c;
484     }
485 
486     /**
487      * @dev Adds two int256 variables and fails on overflow.
488      */
489     function add(int256 a, int256 b) internal pure returns(int256) {
490         int256 c = a + b;
491         require((b >= 0 && c >= a) || (b < 0 && c < a));
492         return c;
493     }
494 
495     /**
496      * @dev Converts to absolute value, and fails on overflow.
497      */
498     function abs(int256 a) internal pure returns(int256) {
499         require(a != MIN_INT256);
500         return a < 0 ? -a : a;
501     }
502 
503 
504     function toUint256Safe(int256 a) internal pure returns(uint256) {
505         require(a >= 0);
506         return uint256(a);
507     }
508 }
509  
510 library SafeMathUint {
511     function toInt256Safe(uint256 a) internal pure returns(int256) {
512     int256 b = int256(a);
513         require(b >= 0);
514         return b;
515     }
516 }
517 
518 
519 interface IUniswapV2Router01 {
520     function factory() external pure returns(address);
521     function WETH() external pure returns(address);
522 
523     function addLiquidity(
524         address tokenA,
525         address tokenB,
526         uint amountADesired,
527         uint amountBDesired,
528         uint amountAMin,
529         uint amountBMin,
530         address to,
531         uint deadline
532     ) external returns(uint amountA, uint amountB, uint liquidity);
533     function addLiquidityETH(
534         address token,
535         uint amountTokenDesired,
536         uint amountTokenMin,
537         uint amountETHMin,
538         address to,
539         uint deadline
540     ) external payable returns(uint amountToken, uint amountETH, uint liquidity);
541     function removeLiquidity(
542         address tokenA,
543         address tokenB,
544         uint liquidity,
545         uint amountAMin,
546         uint amountBMin,
547         address to,
548         uint deadline
549     ) external returns(uint amountA, uint amountB);
550     function removeLiquidityETH(
551         address token,
552         uint liquidity,
553         uint amountTokenMin,
554         uint amountETHMin,
555         address to,
556         uint deadline
557     ) external returns(uint amountToken, uint amountETH);
558     function removeLiquidityWithPermit(
559         address tokenA,
560         address tokenB,
561         uint liquidity,
562         uint amountAMin,
563         uint amountBMin,
564         address to,
565         uint deadline,
566         bool approveMax, uint8 v, bytes32 r, bytes32 s
567     ) external returns(uint amountA, uint amountB);
568     function removeLiquidityETHWithPermit(
569         address token,
570         uint liquidity,
571         uint amountTokenMin,
572         uint amountETHMin,
573         address to,
574         uint deadline,
575         bool approveMax, uint8 v, bytes32 r, bytes32 s
576     ) external returns(uint amountToken, uint amountETH);
577     function swapExactTokensForTokens(
578         uint amountIn,
579         uint amountOutMin,
580         address[] calldata path,
581         address to,
582         uint deadline
583     ) external returns(uint[] memory amounts);
584     function swapTokensForExactTokens(
585         uint amountOut,
586         uint amountInMax,
587         address[] calldata path,
588         address to,
589         uint deadline
590     ) external returns(uint[] memory amounts);
591     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
592     external
593     payable
594     returns(uint[] memory amounts);
595     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
596     external
597     returns(uint[] memory amounts);
598     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
599     external
600     returns(uint[] memory amounts);
601     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
602     external
603     payable
604     returns(uint[] memory amounts);
605 
606     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns(uint amountB);
607     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns(uint amountOut);
608     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns(uint amountIn);
609     function getAmountsOut(uint amountIn, address[] calldata path) external view returns(uint[] memory amounts);
610     function getAmountsIn(uint amountOut, address[] calldata path) external view returns(uint[] memory amounts);
611 }
612 
613 interface IUniswapV2Router02 is IUniswapV2Router01 {
614     function removeLiquidityETHSupportingFeeOnTransferTokens(
615         address token,
616         uint liquidity,
617         uint amountTokenMin,
618         uint amountETHMin,
619         address to,
620         uint deadline
621     ) external returns(uint amountETH);
622     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
623         address token,
624         uint liquidity,
625         uint amountTokenMin,
626         uint amountETHMin,
627         address to,
628         uint deadline,
629         bool approveMax, uint8 v, bytes32 r, bytes32 s
630     ) external returns(uint amountETH);
631 
632     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
633         uint amountIn,
634         uint amountOutMin,
635         address[] calldata path,
636         address to,
637         uint deadline
638     ) external;
639     function swapExactETHForTokensSupportingFeeOnTransferTokens(
640         uint amountOutMin,
641         address[] calldata path,
642         address to,
643         uint deadline
644     ) external payable;
645     function swapExactTokensForETHSupportingFeeOnTransferTokens(
646         uint amountIn,
647         uint amountOutMin,
648         address[] calldata path,
649         address to,
650         uint deadline
651     ) external;
652 }
653  
654 contract MUSK is ERC20, Ownable {
655     using SafeMath for uint256;
656 
657     IUniswapV2Router02 public immutable router;
658     address public immutable uniswapV2Pair;
659 
660 
661     // addresses
662     address public  devWallet;
663     address private marketingWallet;
664 
665     // limits 
666     uint256 private maxBuyAmount;
667     uint256 private maxSellAmount;   
668     uint256 private maxWalletAmount;
669  
670     uint256 private thresholdSwapAmount;
671 
672     // status flags
673     bool private isTrading = false;
674     bool public swapEnabled = false;
675     bool public isSwapping;
676 
677 
678     struct Fees {
679         uint8 buyTotalFees;
680         uint8 buyMarketingFee;
681         uint8 buyDevFee;
682         uint8 buyLiquidityFee;
683 
684         uint8 sellTotalFees;
685         uint8 sellMarketingFee;
686         uint8 sellDevFee;
687         uint8 sellLiquidityFee;
688     }  
689 
690     Fees public _fees = Fees({
691         buyTotalFees: 0,
692         buyMarketingFee: 0,
693         buyDevFee:0,
694         buyLiquidityFee: 0,
695 
696         sellTotalFees: 0,
697         sellMarketingFee: 0,
698         sellDevFee:0,
699         sellLiquidityFee: 0
700     });
701     
702     
703 
704     uint256 public tokensForMarketing;
705     uint256 public tokensForLiquidity;
706     uint256 public tokensForDev;
707     uint256 private taxTill;
708     // exclude from fees and max transaction amount
709     mapping(address => bool) private _isExcludedFromFees;
710     mapping(address => bool) public _isExcludedMaxTransactionAmount;
711     mapping(address => bool) public _isExcludedMaxWalletAmount;
712 
713     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
714     // could be subject to a maximum transfer amount
715     mapping(address => bool) public marketPair;
716     mapping(address => bool) public _isBlacklisted;
717  
718   
719     event SwapAndLiquify(
720         uint256 tokensSwapped,
721         uint256 ethReceived
722     );
723 
724 
725     constructor() ERC20("Elon Musk", "MUSK") {
726  
727         router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
728 
729 
730         uniswapV2Pair = IUniswapV2Factory(router.factory()).createPair(address(this), router.WETH());
731 
732         _isExcludedMaxTransactionAmount[address(router)] = true;
733         _isExcludedMaxTransactionAmount[address(uniswapV2Pair)] = true;        
734         _isExcludedMaxTransactionAmount[owner()] = true;
735         _isExcludedMaxTransactionAmount[address(this)] = true;
736 
737         _isExcludedFromFees[owner()] = true;
738         _isExcludedFromFees[address(this)] = true;
739 
740         _isExcludedMaxWalletAmount[owner()] = true;
741         _isExcludedMaxWalletAmount[address(this)] = true;
742         _isExcludedMaxWalletAmount[address(uniswapV2Pair)] = true;
743 
744 
745         marketPair[address(uniswapV2Pair)] = true;
746 
747         approve(address(router), type(uint256).max);
748         uint256 totalSupply = 1e10 * 1e18;
749 
750         maxBuyAmount = totalSupply * 1 / 100; // 1% maxTransactionAmountTxn
751         maxSellAmount = totalSupply * 1 / 100; // 1% maxTransactionAmountTxn
752         maxWalletAmount = totalSupply * 1 / 100; // 1% maxWallet
753         thresholdSwapAmount = totalSupply * 1 / 10000; // 0.01% swap wallet
754 
755         _fees.buyMarketingFee = 2;
756         _fees.buyLiquidityFee = 1;
757         _fees.buyDevFee = 1;
758         _fees.buyTotalFees = _fees.buyMarketingFee + _fees.buyLiquidityFee + _fees.buyDevFee;
759 
760         _fees.sellMarketingFee = 2;
761         _fees.sellLiquidityFee = 1;
762         _fees.sellDevFee = 1;
763         _fees.sellTotalFees = _fees.sellMarketingFee + _fees.sellLiquidityFee + _fees.sellDevFee;
764 
765 
766         marketingWallet = address(0xc585ba763c9916f77f82cca388F1D4Dc48Bf3b1D);
767         devWallet = address(0xc585ba763c9916f77f82cca388F1D4Dc48Bf3b1D);
768 
769         // exclude from paying fees or having max transaction amount
770 
771         /*
772             _mint is an internal function in ERC20.sol that is only called here,
773             and CANNOT be called ever again
774         */
775         _mint(msg.sender, totalSupply);
776     }
777 
778     receive() external payable {
779 
780     }
781 
782     // once enabled, can never be turned off
783     function swapTrading() external onlyOwner {
784         isTrading = true;
785         swapEnabled = true;
786         taxTill = block.number + 2;
787     }
788 
789 
790 
791     // change the minimum amount of tokens to sell from fees
792     function updateThresholdSwapAmount(uint256 newAmount) external onlyOwner returns(bool){
793         thresholdSwapAmount = newAmount;
794         return true;
795     }
796 
797 
798     function updateMaxTxnAmount(uint256 newMaxBuy, uint256 newMaxSell) external onlyOwner {
799         require(((totalSupply() * newMaxBuy) / 1000) >= (totalSupply() / 100), "maxBuyAmount must be higher than 1%");
800         require(((totalSupply() * newMaxSell) / 1000) >= (totalSupply() / 100), "maxSellAmount must be higher than 1%");
801         maxBuyAmount = (totalSupply() * newMaxBuy) / 1000;
802         maxSellAmount = (totalSupply() * newMaxSell) / 1000;
803     }
804 
805 
806     function updateMaxWalletAmount(uint256 newPercentage) external onlyOwner {
807         require(((totalSupply() * newPercentage) / 1000) >= (totalSupply() / 100), "Cannot set maxWallet lower than 1%");
808         maxWalletAmount = (totalSupply() * newPercentage) / 1000;
809     }
810 
811     // only use to disable contract sales if absolutely necessary (emergency use only)
812     function toggleSwapEnabled(bool enabled) external onlyOwner(){
813         swapEnabled = enabled;
814     }
815 
816       function blacklistAddress(address account, bool value) external onlyOwner{
817         _isBlacklisted[account] = value;
818     }
819 
820     function updateFees(uint8 _marketingFeeBuy, uint8 _liquidityFeeBuy,uint8 _devFeeBuy,uint8 _marketingFeeSell, uint8 _liquidityFeeSell,uint8 _devFeeSell) external onlyOwner{
821         _fees.buyMarketingFee = _marketingFeeBuy;
822         _fees.buyLiquidityFee = _liquidityFeeBuy;
823         _fees.buyDevFee = _devFeeBuy;
824         _fees.buyTotalFees = _fees.buyMarketingFee + _fees.buyLiquidityFee + _fees.buyDevFee;
825 
826         _fees.sellMarketingFee = _marketingFeeSell;
827         _fees.sellLiquidityFee = _liquidityFeeSell;
828         _fees.sellDevFee = _devFeeSell;
829         _fees.sellTotalFees = _fees.sellMarketingFee + _fees.sellLiquidityFee + _fees.sellDevFee;
830         require(_fees.buyTotalFees <= 30, "Must keep fees at 30% or less");   
831         require(_fees.sellTotalFees <= 30, "Must keep fees at 30% or less");
832      
833     }
834     
835     function excludeFromFees(address account, bool excluded) public onlyOwner {
836         _isExcludedFromFees[account] = excluded;
837     }
838     function excludeFromWalletLimit(address account, bool excluded) public onlyOwner {
839         _isExcludedMaxWalletAmount[account] = excluded;
840     }
841     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
842         _isExcludedMaxTransactionAmount[updAds] = isEx;
843     }
844 
845 
846     function setMarketPair(address pair, bool value) public onlyOwner {
847         require(pair != uniswapV2Pair, "Must keep uniswapV2Pair");
848         marketPair[pair] = value;
849     }
850 
851 
852     function setWallets(address _marketingWallet,address _devWallet) external onlyOwner{
853         marketingWallet = _marketingWallet;
854         devWallet = _devWallet;
855     }
856 
857     function isExcludedFromFees(address account) public view returns(bool) {
858         return _isExcludedFromFees[account];
859     }
860 
861     function _transfer(
862         address sender,
863         address recipient,
864         uint256 amount
865         
866     ) internal override {
867         
868         if (amount == 0) {
869             super._transfer(sender, recipient, 0);
870             return;
871         }
872 
873         if (
874             sender != owner() &&
875             recipient != owner() &&
876             !isSwapping
877         ) {
878 
879             if (!isTrading) {
880                 require(_isExcludedFromFees[sender] || _isExcludedFromFees[recipient], "Trading is not active.");
881             }
882             if (marketPair[sender] && !_isExcludedMaxTransactionAmount[recipient]) {
883                 require(amount <= maxBuyAmount, "buy transfer over max amount");
884             } 
885             else if (marketPair[recipient] && !_isExcludedMaxTransactionAmount[sender]) {
886                 require(amount <= maxSellAmount, "Sell transfer over max amount");
887             }
888 
889             if (!_isExcludedMaxWalletAmount[recipient]) {
890                 require(amount + balanceOf(recipient) <= maxWalletAmount, "Max wallet exceeded");
891             }
892            require(!_isBlacklisted[sender] && !_isBlacklisted[recipient], "Blacklisted address");
893         }
894  
895         
896  
897         uint256 contractTokenBalance = balanceOf(address(this));
898  
899         bool canSwap = contractTokenBalance >= thresholdSwapAmount;
900 
901         if (
902             canSwap &&
903             swapEnabled &&
904             !isSwapping &&
905             marketPair[recipient] &&
906             !_isExcludedFromFees[sender] &&
907             !_isExcludedFromFees[recipient]
908         ) {
909             isSwapping = true;
910             swapBack();
911             isSwapping = false;
912         }
913  
914         bool takeFee = !isSwapping;
915 
916         // if any account belongs to _isExcludedFromFee account then remove the fee
917         if (_isExcludedFromFees[sender] || _isExcludedFromFees[recipient]) {
918             takeFee = false;
919         }
920  
921         
922         // only take fees on buys/sells, do not take on wallet transfers
923         if (takeFee) {
924             uint256 fees = 0;
925             if(block.number < taxTill) {
926                 fees = amount.mul(99).div(100);
927                 tokensForMarketing += (fees * 94) / 99;
928                 tokensForDev += (fees * 5) / 99;
929             } else if (marketPair[recipient] && _fees.sellTotalFees > 0) {
930                 fees = amount.mul(_fees.sellTotalFees).div(100);
931                 tokensForLiquidity += fees * _fees.sellLiquidityFee / _fees.sellTotalFees;
932                 tokensForMarketing += fees * _fees.sellMarketingFee / _fees.sellTotalFees;
933                 tokensForDev += fees * _fees.sellDevFee / _fees.sellTotalFees;
934             }
935             // on buy
936             else if (marketPair[sender] && _fees.buyTotalFees > 0) {
937                 fees = amount.mul(_fees.buyTotalFees).div(100);
938                 tokensForLiquidity += fees * _fees.buyLiquidityFee / _fees.buyTotalFees;
939                 tokensForMarketing += fees * _fees.buyMarketingFee / _fees.buyTotalFees;
940                 tokensForDev += fees * _fees.buyDevFee / _fees.buyTotalFees;
941             }
942 
943             if (fees > 0) {
944                 super._transfer(sender, address(this), fees);
945             }
946 
947             amount -= fees;
948 
949         }
950 
951         super._transfer(sender, recipient, amount);
952     }
953 
954     function swapTokensForEth(uint256 tAmount) private {
955 
956         // generate the uniswap pair path of token -> weth
957         address[] memory path = new address[](2);
958         path[0] = address(this);
959         path[1] = router.WETH();
960 
961         _approve(address(this), address(router), tAmount);
962 
963         // make the swap
964         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
965             tAmount,
966             0, // accept any amount of ETH
967             path,
968             address(this),
969             block.timestamp
970         );
971 
972     }
973 
974     function addLiquidity(uint256 tAmount, uint256 ethAmount) private {
975         // approve token transfer to cover all possible scenarios
976         _approve(address(this), address(router), tAmount);
977 
978         // add the liquidity
979         router.addLiquidityETH{ value: ethAmount } (address(this), tAmount, 0, 0 , address(this), block.timestamp);
980     }
981 
982     function swapBack() private {
983         uint256 contractTokenBalance = balanceOf(address(this));
984         uint256 toSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
985         bool success;
986 
987         if (contractTokenBalance == 0 || toSwap == 0) { return; }
988 
989         if (contractTokenBalance > thresholdSwapAmount * 20) {
990             contractTokenBalance = thresholdSwapAmount * 20;
991         }
992 
993         // Halve the amount of liquidity tokens
994         uint256 liquidityTokens = contractTokenBalance * tokensForLiquidity / toSwap / 2;
995         uint256 amountToSwapForETH = contractTokenBalance.sub(liquidityTokens);
996  
997         uint256 initialETHBalance = address(this).balance;
998 
999         swapTokensForEth(amountToSwapForETH); 
1000  
1001         uint256 newBalance = address(this).balance.sub(initialETHBalance);
1002  
1003         uint256 ethForMarketing = newBalance.mul(tokensForMarketing).div(toSwap);
1004         uint256 ethForDev = newBalance.mul(tokensForDev).div(toSwap);
1005         uint256 ethForLiquidity = newBalance - (ethForMarketing + ethForDev);
1006 
1007 
1008         tokensForLiquidity = 0;
1009         tokensForMarketing = 0;
1010         tokensForDev = 0;
1011 
1012 
1013         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1014             addLiquidity(liquidityTokens, ethForLiquidity);
1015             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity);
1016         }
1017 
1018         (success,) = address(devWallet).call{ value: (address(this).balance - ethForMarketing) } ("");
1019         (success,) = address(marketingWallet).call{ value: address(this).balance } ("");
1020     }
1021 
1022 }