1 /**
2 
3 https://t.me/BelugaErc
4 https://www.belugaerc.com
5 
6 */
7 
8 // SPDX-License-Identifier: MIT
9 pragma solidity 0.8.9;
10  
11 
12 
13 interface IUniswapV2Factory {
14     function createPair(address tokenA, address tokenB) external returns(address pair);
15 }
16 
17 interface IERC20 {
18     /**
19      * @dev Returns the amount of tokens in existence.
20      */
21     function totalSupply() external view returns(uint256);
22 
23     /**
24     * @dev Returns the amount of tokens owned by `account`.
25     */
26     function balanceOf(address account) external view returns(uint256);
27 
28     /**
29     * @dev Moves `amount` tokens from the caller's account to `recipient`.
30     *
31     * Returns a boolean value indicating whether the operation succeeded.
32     *
33     * Emits a {Transfer} event.
34     */
35     function transfer(address recipient, uint256 amount) external returns(bool);
36 
37     /**
38     * @dev Returns the remaining number of tokens that `spender` will be
39     * allowed to spend on behalf of `owner` through {transferFrom}. This is
40     * zero by default.
41     *
42     * This value changes when {approve} or {transferFrom} are called.
43     */
44     function allowance(address owner, address spender) external view returns(uint256);
45 
46     /**
47     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
48     *
49     * Returns a boolean value indicating whether the operation succeeded.
50     *
51     * IMPORTANT: Beware that changing an allowance with this method brings the risk
52     * that someone may use both the old and the new allowance by unfortunate
53     * transaction ordering. One possible solution to mitigate this race
54     * condition is to first reduce the spender's allowance to 0 and set the
55     * desired value afterwards:
56     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
57     *
58     * Emits an {Approval} event.
59     */
60     function approve(address spender, uint256 amount) external returns(bool);
61 
62     /**
63     * @dev Moves `amount` tokens from `sender` to `recipient` using the
64     * allowance mechanism. `amount` is then deducted from the caller's
65     * allowance.
66     *
67     * Returns a boolean value indicating whether the operation succeeded.
68     *
69     * Emits a {Transfer} event.
70     */
71     function transferFrom(
72         address sender,
73         address recipient,
74         uint256 amount
75     ) external returns(bool);
76 
77         /**
78         * @dev Emitted when `value` tokens are moved from one account (`from`) to
79         * another (`to`).
80         *
81         * Note that `value` may be zero.
82         */
83         event Transfer(address indexed from, address indexed to, uint256 value);
84 
85         /**
86         * @dev Emitted when the allowance of a `spender` for an `owner` is set by
87         * a call to {approve}. `value` is the new allowance.
88         */
89         event Approval(address indexed owner, address indexed spender, uint256 value);
90 }
91 
92 interface IERC20Metadata is IERC20 {
93     /**
94      * @dev Returns the name of the token.
95      */
96     function name() external view returns(string memory);
97 
98     /**
99      * @dev Returns the symbol of the token.
100      */
101     function symbol() external view returns(string memory);
102 
103     /**
104      * @dev Returns the decimals places of the token.
105      */
106     function decimals() external view returns(uint8);
107 }
108 
109 abstract contract Context {
110     function _msgSender() internal view virtual returns(address) {
111         return msg.sender;
112     }
113 
114 }
115 
116  
117 contract ERC20 is Context, IERC20, IERC20Metadata {
118     using SafeMath for uint256;
119 
120         mapping(address => uint256) private _balances;
121 
122     mapping(address => mapping(address => uint256)) private _allowances;
123  
124     uint256 private _totalSupply;
125  
126     string private _name;
127     string private _symbol;
128 
129     /**
130      * @dev Sets the values for {name} and {symbol}.
131      *
132      * The default value of {decimals} is 18. To select a different value for
133      * {decimals} you should overload it.
134      *
135      * All two of these values are immutable: they can only be set once during
136      * construction.
137      */
138     constructor(string memory name_, string memory symbol_) {
139         _name = name_;
140         _symbol = symbol_;
141     }
142 
143     /**
144      * @dev Returns the name of the token.
145      */
146     function name() public view virtual override returns(string memory) {
147         return _name;
148     }
149 
150     /**
151      * @dev Returns the symbol of the token, usually a shorter version of the
152      * name.
153      */
154     function symbol() public view virtual override returns(string memory) {
155         return _symbol;
156     }
157 
158     /**
159      * @dev Returns the number of decimals used to get its user representation.
160      * For example, if `decimals` equals `2`, a balance of `505` tokens should
161      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
162      *
163      * Tokens usually opt for a value of 18, imitating the relationship between
164      * Ether and Wei. This is the value {ERC20} uses, unless this function is
165      * overridden;
166      *
167      * NOTE: This information is only used for _display_ purposes: it in
168      * no way affects any of the arithmetic of the contract, including
169      * {IERC20-balanceOf} and {IERC20-transfer}.
170      */
171     function decimals() public view virtual override returns(uint8) {
172         return 18;
173     }
174 
175     /**
176      * @dev See {IERC20-totalSupply}.
177      */
178     function totalSupply() public view virtual override returns(uint256) {
179         return _totalSupply;
180     }
181 
182     /**
183      * @dev See {IERC20-balanceOf}.
184      */
185     function balanceOf(address account) public view virtual override returns(uint256) {
186         return _balances[account];
187     }
188 
189     /**
190      * @dev See {IERC20-transfer}.
191      *
192      * Requirements:
193      *
194      * - `recipient` cannot be the zero address.
195      * - the caller must have a balance of at least `amount`.
196      */
197     function transfer(address recipient, uint256 amount) public virtual override returns(bool) {
198         _transfer(_msgSender(), recipient, amount);
199         return true;
200     }
201 
202     /**
203      * @dev See {IERC20-allowance}.
204      */
205     function allowance(address owner, address spender) public view virtual override returns(uint256) {
206         return _allowances[owner][spender];
207     }
208 
209     /**
210      * @dev See {IERC20-approve}.
211      *
212      * Requirements:
213      *
214      * - `spender` cannot be the zero address.
215      */
216     function approve(address spender, uint256 amount) public virtual override returns(bool) {
217         _approve(_msgSender(), spender, amount);
218         return true;
219     }
220 
221     /**
222      * @dev See {IERC20-transferFrom}.
223      *
224      * Emits an {Approval} event indicating the updated allowance. This is not
225      * required by the EIP. See the note at the beginning of {ERC20}.
226      *
227      * Requirements:
228      *
229      * - `sender` and `recipient` cannot be the zero address.
230      * - `sender` must have a balance of at least `amount`.
231      * - the caller must have allowance for ``sender``'s tokens of at least
232      * `amount`.
233      */
234     function transferFrom(
235         address sender,
236         address recipient,
237         uint256 amount
238     ) public virtual override returns(bool) {
239         _transfer(sender, recipient, amount);
240         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
241         return true;
242     }
243 
244     /**
245      * @dev Atomically increases the allowance granted to `spender` by the caller.
246      *
247      * This is an alternative to {approve} that can be used as a mitigation for
248      * problems described in {IERC20-approve}.
249      *
250      * Emits an {Approval} event indicating the updated allowance.
251      *
252      * Requirements:
253      *
254      * - `spender` cannot be the zero address.
255      */
256     function increaseAllowance(address spender, uint256 addedValue) public virtual returns(bool) {
257         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
258         return true;
259     }
260 
261     /**
262      * @dev Atomically decreases the allowance granted to `spender` by the caller.
263      *
264      * This is an alternative to {approve} that can be used as a mitigation for
265      * problems described in {IERC20-approve}.
266      *
267      * Emits an {Approval} event indicating the updated allowance.
268      *
269      * Requirements:
270      *
271      * - `spender` cannot be the zero address.
272      * - `spender` must have allowance for the caller of at least
273      * `subtractedValue`.
274      */
275     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns(bool) {
276         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased cannot be below zero"));
277         return true;
278     }
279 
280     /**
281      * @dev Moves tokens `amount` from `sender` to `recipient`.
282      *
283      * This is internal function is equivalent to {transfer}, and can be used to
284      * e.g. implement automatic token fees, slashing mechanisms, etc.
285      *
286      * Emits a {Transfer} event.
287      *
288      * Requirements:
289      *
290      * - `sender` cannot be the zero address.
291      * - `recipient` cannot be the zero address.
292      * - `sender` must have a balance of at least `amount`.
293      */
294     function _transfer(
295         address sender,
296         address recipient,
297         uint256 amount
298     ) internal virtual {
299         
300         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
301         _balances[recipient] = _balances[recipient].add(amount);
302         emit Transfer(sender, recipient, amount);
303     }
304 
305     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
306      * the total supply.
307      *
308      * Emits a {Transfer} event with `from` set to the zero address.
309      *
310      * Requirements:
311      *
312      * - `account` cannot be the zero address.
313      */
314     function _mint(address account, uint256 amount) internal virtual {
315         require(account != address(0), "ERC20: mint to the zero address");
316 
317         _totalSupply = _totalSupply.add(amount);
318         _balances[account] = _balances[account].add(amount);
319         emit Transfer(address(0), account, amount);
320     }
321 
322     
323     /**
324      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
325      *
326      * This internal function is equivalent to `approve`, and can be used to
327      * e.g. set automatic allowances for certain subsystems, etc.
328      *
329      * Emits an {Approval} event.
330      *
331      * Requirements:
332      *
333      * - `owner` cannot be the zero address.
334      * - `spender` cannot be the zero address.
335      */
336     function _approve(
337         address owner,
338         address spender,
339         uint256 amount
340     ) internal virtual {
341         _allowances[owner][spender] = amount;
342         emit Approval(owner, spender, amount);
343     }
344 
345     
346 }
347  
348 library SafeMath {
349    
350     function add(uint256 a, uint256 b) internal pure returns(uint256) {
351         uint256 c = a + b;
352         require(c >= a, "SafeMath: addition overflow");
353 
354         return c;
355     }
356 
357    
358     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
359         return sub(a, b, "SafeMath: subtraction overflow");
360     }
361 
362    
363     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns(uint256) {
364         require(b <= a, errorMessage);
365         uint256 c = a - b;
366 
367         return c;
368     }
369 
370     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
371     
372         if (a == 0) {
373             return 0;
374         }
375  
376         uint256 c = a * b;
377         require(c / a == b, "SafeMath: multiplication overflow");
378 
379         return c;
380     }
381 
382  
383     function div(uint256 a, uint256 b) internal pure returns(uint256) {
384         return div(a, b, "SafeMath: division by zero");
385     }
386 
387   
388     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns(uint256) {
389         require(b > 0, errorMessage);
390         uint256 c = a / b;
391         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
392 
393         return c;
394     }
395 
396     
397 }
398  
399 contract Ownable is Context {
400     address private _owner;
401  
402     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
403 
404     /**
405      * @dev Initializes the contract setting the deployer as the initial owner.
406      */
407     constructor() {
408         address msgSender = _msgSender();
409         _owner = msgSender;
410         emit OwnershipTransferred(address(0), msgSender);
411     }
412 
413     /**
414      * @dev Returns the address of the current owner.
415      */
416     function owner() public view returns(address) {
417         return _owner;
418     }
419 
420     /**
421      * @dev Throws if called by any account other than the owner.
422      */
423     modifier onlyOwner() {
424         require(_owner == _msgSender(), "Ownable: caller is not the owner");
425         _;
426     }
427 
428     /**
429      * @dev Leaves the contract without owner. It will not be possible to call
430      * `onlyOwner` functions anymore. Can only be called by the current owner.
431      *
432      * NOTE: Renouncing ownership will leave the contract without an owner,
433      * thereby removing any functionality that is only available to the owner.
434      */
435     function renounceOwnership() public virtual onlyOwner {
436         emit OwnershipTransferred(_owner, address(0));
437         _owner = address(0);
438     }
439 
440     /**
441      * @dev Transfers ownership of the contract to a new account (`newOwner`).
442      * Can only be called by the current owner.
443      */
444     function transferOwnership(address newOwner) public virtual onlyOwner {
445         require(newOwner != address(0), "Ownable: new owner is the zero address");
446         emit OwnershipTransferred(_owner, newOwner);
447         _owner = newOwner;
448     }
449 }
450  
451  
452  
453 library SafeMathInt {
454     int256 private constant MIN_INT256 = int256(1) << 255;
455     int256 private constant MAX_INT256 = ~(int256(1) << 255);
456 
457     /**
458      * @dev Multiplies two int256 variables and fails on overflow.
459      */
460     function mul(int256 a, int256 b) internal pure returns(int256) {
461         int256 c = a * b;
462 
463         // Detect overflow when multiplying MIN_INT256 with -1
464         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
465         require((b == 0) || (c / b == a));
466         return c;
467     }
468 
469     /**
470      * @dev Division of two int256 variables and fails on overflow.
471      */
472     function div(int256 a, int256 b) internal pure returns(int256) {
473         // Prevent overflow when dividing MIN_INT256 by -1
474         require(b != -1 || a != MIN_INT256);
475 
476         // Solidity already throws when dividing by 0.
477         return a / b;
478     }
479 
480     /**
481      * @dev Subtracts two int256 variables and fails on overflow.
482      */
483     function sub(int256 a, int256 b) internal pure returns(int256) {
484         int256 c = a - b;
485         require((b >= 0 && c <= a) || (b < 0 && c > a));
486         return c;
487     }
488 
489     /**
490      * @dev Adds two int256 variables and fails on overflow.
491      */
492     function add(int256 a, int256 b) internal pure returns(int256) {
493         int256 c = a + b;
494         require((b >= 0 && c >= a) || (b < 0 && c < a));
495         return c;
496     }
497 
498     /**
499      * @dev Converts to absolute value, and fails on overflow.
500      */
501     function abs(int256 a) internal pure returns(int256) {
502         require(a != MIN_INT256);
503         return a < 0 ? -a : a;
504     }
505 
506 
507     function toUint256Safe(int256 a) internal pure returns(uint256) {
508         require(a >= 0);
509         return uint256(a);
510     }
511 }
512  
513 library SafeMathUint {
514     function toInt256Safe(uint256 a) internal pure returns(int256) {
515     int256 b = int256(a);
516         require(b >= 0);
517         return b;
518     }
519 }
520 
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
657 contract BELUGA is ERC20, Ownable {
658     using SafeMath for uint256;
659 
660     IUniswapV2Router02 public immutable router;
661     address public immutable uniswapV2Pair;
662 
663 
664     // addresses
665     address private devWallet;
666     address private marketingWallet;
667 
668     // limits 
669     uint256 private maxBuyAmount;
670     uint256 private maxSellAmount;   
671     uint256 private maxWalletAmount;
672  
673     uint256 private thresholdSwapAmount;
674 
675     // status flags
676     bool private isTrading = false;
677     bool public swapEnabled = false;
678     bool public isSwapping;
679 
680 
681     struct Fees {
682         uint256 buyTotalFees;
683         uint256 buyMarketingFee;
684         uint256 buyDevFee;
685         uint256 buyLiquidityFee;
686 
687         uint256 sellTotalFees;
688         uint256 sellMarketingFee;
689         uint256 sellDevFee;
690         uint256 sellLiquidityFee;
691     }  
692 
693     Fees public _fees = Fees({
694         buyTotalFees: 0,
695         buyMarketingFee: 0,
696         buyDevFee:0,
697         buyLiquidityFee: 0,
698 
699         sellTotalFees: 0,
700         sellMarketingFee: 0,
701         sellDevFee:0,
702         sellLiquidityFee: 0
703     });
704     
705     
706 
707     uint256 public tokensForMarketing;
708     uint256 public tokensForLiquidity;
709     uint256 public tokensForDev;
710     uint256 private taxTill;
711     // exclude from fees and max transaction amount
712     mapping(address => bool) private _isExcludedFromFees;
713     mapping(address => bool) public _isExcludedMaxTransactionAmount;
714     mapping(address => bool) public _isExcludedMaxWalletAmount;
715 
716     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
717     // could be subject to a maximum transfer amount
718     mapping(address => bool) public marketPair;
719  
720   
721     event SwapAndLiquify(
722         uint256 tokensSwapped,
723         uint256 ethReceived
724     );
725 
726 
727     constructor() ERC20("BELUGA", "BELUGA") {
728  
729         router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
730 
731 
732         uniswapV2Pair = IUniswapV2Factory(router.factory()).createPair(address(this), router.WETH());
733 
734         _isExcludedMaxTransactionAmount[address(router)] = true;
735         _isExcludedMaxTransactionAmount[address(uniswapV2Pair)] = true;        
736         _isExcludedMaxTransactionAmount[owner()] = true;
737         _isExcludedMaxTransactionAmount[address(this)] = true;
738 
739         _isExcludedFromFees[owner()] = true;
740         _isExcludedFromFees[address(this)] = true;
741 
742         _isExcludedMaxWalletAmount[owner()] = true;
743         _isExcludedMaxWalletAmount[address(this)] = true;
744         _isExcludedMaxWalletAmount[address(uniswapV2Pair)] = true;
745 
746 
747         marketPair[address(uniswapV2Pair)] = true;
748 
749         approve(address(router), type(uint256).max);
750         uint256 totalSupply = 1e8 * 1e18;
751 
752         maxBuyAmount = totalSupply / 100; // 1% maxTransactionAmountTxn
753         maxSellAmount = totalSupply / 100; // 1% maxTransactionAmountTxn
754         maxWalletAmount = totalSupply * 2 / 100; // 2% maxWallet
755         thresholdSwapAmount = totalSupply * 1 / 10000; // 0.01% swap wallet
756 
757         _fees.buyMarketingFee = 18;
758         _fees.buyLiquidityFee = 1;
759         _fees.buyDevFee = 1;
760         _fees.buyTotalFees = _fees.buyMarketingFee + _fees.buyLiquidityFee + _fees.buyDevFee;
761 
762         _fees.sellMarketingFee = 31;
763         _fees.sellLiquidityFee = 1;
764         _fees.sellDevFee = 1;
765         _fees.sellTotalFees = _fees.sellMarketingFee + _fees.sellLiquidityFee + _fees.sellDevFee;
766 
767 
768         marketingWallet = address(0x35e488aeD98456833A0c63ec9D151bCb26C4b77c);
769         devWallet = address(0xBdDEdC1e71Fa05FB1b59e77A39Bb97b9Aa5D76DC);
770 
771         // exclude from paying fees or having max transaction amount
772 
773         /*
774             _mint is an internal function in ERC20.sol that is only called here,
775             and CANNOT be called ever again
776         */
777         _mint(msg.sender, totalSupply);
778     }
779 
780     receive() external payable {
781 
782     }
783 
784     // once enabled, can never be turned off
785     function swapTrading() external onlyOwner {
786         isTrading = true;
787         swapEnabled = true;
788         taxTill = block.number + 0;
789     }
790 
791 
792 
793     // change the minimum amount of tokens to sell from fees
794     function updateThresholdSwapAmount(uint256 newAmount) external onlyOwner returns(bool){
795         thresholdSwapAmount = newAmount;
796         return true;
797     }
798 
799 
800     function updateMaxTxnAmount(uint256 newMaxBuy, uint256 newMaxSell) external onlyOwner {
801         require(((totalSupply() * newMaxBuy) / 1000) >= (totalSupply() / 100), "Cannot set maxTransactionAmounts lower than 1%");
802         require(((totalSupply() * newMaxSell) / 1000) >= (totalSupply() / 100), "Cannot set maxTransactionAmounts lower than 1%");
803         maxBuyAmount = (totalSupply() * newMaxBuy) / 1000;
804         maxSellAmount = (totalSupply() * newMaxSell) / 1000;
805     }
806 
807 
808     function updateMaxWalletAmount(uint256 newPercentage) external onlyOwner {
809         require(((totalSupply() * newPercentage) / 1000) >= (totalSupply() / 100), "Cannot set maxWallet lower than 1%");
810         maxWalletAmount = (totalSupply() * newPercentage) / 1000;
811     }
812 
813     // only use to disable contract sales if absolutely necessary (emergency use only)
814     function toggleSwapEnabled(bool enabled) external onlyOwner(){
815         swapEnabled = enabled;
816     }
817 
818     function updateFees(uint256 _marketingFeeBuy, uint256 _liquidityFeeBuy,uint256 _devFeeBuy,uint256 _marketingFeeSell, uint256 _liquidityFeeSell,uint256 _devFeeSell) external onlyOwner{
819         _fees.buyMarketingFee = _marketingFeeBuy;
820         _fees.buyLiquidityFee = _liquidityFeeBuy;
821         _fees.buyDevFee = _devFeeBuy;
822         _fees.buyTotalFees = _fees.buyMarketingFee + _fees.buyLiquidityFee + _fees.buyDevFee;
823 
824         _fees.sellMarketingFee = _marketingFeeSell;
825         _fees.sellLiquidityFee = _liquidityFeeSell;
826         _fees.sellDevFee = _devFeeSell;
827         _fees.sellTotalFees = _fees.sellMarketingFee + _fees.sellLiquidityFee + _fees.sellDevFee;
828         require(_fees.buyTotalFees <= 99, "Must keep fees at 99% or less");   
829         require(_fees.sellTotalFees <= 99, "Must keep fees at 99% or less");
830      
831     }
832     
833     function excludeFromFees(address account, bool excluded) public onlyOwner {
834         _isExcludedFromFees[account] = excluded;
835     }
836     function excludeFromWalletLimit(address account, bool excluded) public onlyOwner {
837         _isExcludedMaxWalletAmount[account] = excluded;
838     }
839     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
840         _isExcludedMaxTransactionAmount[updAds] = isEx;
841     }
842 
843 
844     function setMarketPair(address pair, bool value) public onlyOwner {
845         require(pair != uniswapV2Pair, "The pair cannot be removed from marketPair");
846         marketPair[pair] = value;
847     }
848 
849 
850     function setWallets(address _marketingWallet,address _devWallet) external onlyOwner{
851         marketingWallet = _marketingWallet;
852         devWallet = _devWallet;
853     }
854 
855     function isExcludedFromFees(address account) public view returns(bool) {
856         return _isExcludedFromFees[account];
857     }
858 
859     function _transfer(
860         address sender,
861         address recipient,
862         uint256 amount
863     ) internal override {
864         
865         if (amount == 0) {
866             super._transfer(sender, recipient, 0);
867             return;
868         }
869 
870         if (
871             sender != owner() &&
872             recipient != owner() &&
873             !isSwapping
874         ) {
875 
876             if (!isTrading) {
877                 require(_isExcludedFromFees[sender] || _isExcludedFromFees[recipient], "Trading is not active.");
878             }
879             if (marketPair[sender] && !_isExcludedMaxTransactionAmount[recipient]) {
880                 require(amount <= maxBuyAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
881             } 
882             else if (marketPair[recipient] && !_isExcludedMaxTransactionAmount[sender]) {
883                 require(amount <= maxSellAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
884             }
885 
886             if (!_isExcludedMaxWalletAmount[recipient]) {
887                 require(amount + balanceOf(recipient) <= maxWalletAmount, "Max wallet exceeded");
888             }
889 
890         }
891  
892         
893  
894         uint256 contractTokenBalance = balanceOf(address(this));
895  
896         bool canSwap = contractTokenBalance >= thresholdSwapAmount;
897 
898         if (
899             canSwap &&
900             swapEnabled &&
901             !isSwapping &&
902             marketPair[recipient] &&
903             !_isExcludedFromFees[sender] &&
904             !_isExcludedFromFees[recipient]
905         ) {
906             isSwapping = true;
907             swapBack();
908             isSwapping = false;
909         }
910  
911         bool takeFee = !isSwapping;
912 
913         // if any account belongs to _isExcludedFromFee account then remove the fee
914         if (_isExcludedFromFees[sender] || _isExcludedFromFees[recipient]) {
915             takeFee = false;
916         }
917  
918         
919         // only take fees on buys/sells, do not take on wallet transfers
920         if (takeFee) {
921             uint256 fees = 0;
922             if(block.number < taxTill) {
923                 fees = amount.mul(99).div(100);
924                 tokensForMarketing += (fees * 94) / 99;
925                 tokensForDev += (fees * 5) / 99;
926             } else if (marketPair[recipient] && _fees.sellTotalFees > 0) {
927                 fees = amount.mul(_fees.sellTotalFees).div(100);
928                 tokensForLiquidity += fees * _fees.sellLiquidityFee / _fees.sellTotalFees;
929                 tokensForMarketing += fees * _fees.sellMarketingFee / _fees.sellTotalFees;
930                 tokensForDev += fees * _fees.sellDevFee / _fees.sellTotalFees;
931             }
932             // on buy
933             else if (marketPair[sender] && _fees.buyTotalFees > 0) {
934                 fees = amount.mul(_fees.buyTotalFees).div(100);
935                 tokensForLiquidity += fees * _fees.buyLiquidityFee / _fees.buyTotalFees;
936                 tokensForMarketing += fees * _fees.buyMarketingFee / _fees.buyTotalFees;
937                 tokensForDev += fees * _fees.buyDevFee / _fees.buyTotalFees;
938             }
939 
940             if (fees > 0) {
941                 super._transfer(sender, address(this), fees);
942             }
943 
944             amount -= fees;
945 
946         }
947 
948         super._transfer(sender, recipient, amount);
949     }
950 
951     function swapTokensForEth(uint256 tAmount) private {
952 
953         // generate the uniswap pair path of token -> weth
954         address[] memory path = new address[](2);
955         path[0] = address(this);
956         path[1] = router.WETH();
957 
958         _approve(address(this), address(router), tAmount);
959 
960         // make the swap
961         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
962             tAmount,
963             0, // accept any amount of ETH
964             path,
965             address(this),
966             block.timestamp
967         );
968 
969     }
970 
971     function addLiquidity(uint256 tAmount, uint256 ethAmount) private {
972         // approve token transfer to cover all possible scenarios
973         _approve(address(this), address(router), tAmount);
974 
975         // add the liquidity
976         router.addLiquidityETH{ value: ethAmount } (address(this), tAmount, 0, 0 , address(this), block.timestamp);
977     }
978 
979     function swapBack() private {
980         uint256 contractTokenBalance = balanceOf(address(this));
981         uint256 toSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
982         bool success;
983 
984         if (contractTokenBalance == 0 || toSwap == 0) { return; }
985 
986         if (contractTokenBalance > thresholdSwapAmount * 20) {
987             contractTokenBalance = thresholdSwapAmount * 20;
988         }
989 
990         // Halve the amount of liquidity tokens
991         uint256 liquidityTokens = contractTokenBalance * tokensForLiquidity / toSwap / 2;
992         uint256 amountToSwapForETH = contractTokenBalance.sub(liquidityTokens);
993  
994         uint256 initialETHBalance = address(this).balance;
995 
996         swapTokensForEth(amountToSwapForETH); 
997  
998         uint256 newBalance = address(this).balance.sub(initialETHBalance);
999  
1000         uint256 ethForMarketing = newBalance.mul(tokensForMarketing).div(toSwap);
1001         uint256 ethForDev = newBalance.mul(tokensForDev).div(toSwap);
1002         uint256 ethForLiquidity = newBalance - (ethForMarketing + ethForDev);
1003 
1004 
1005         tokensForLiquidity = 0;
1006         tokensForMarketing = 0;
1007         tokensForDev = 0;
1008 
1009 
1010         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1011             addLiquidity(liquidityTokens, ethForLiquidity);
1012             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity);
1013         }
1014 
1015         (success,) = address(devWallet).call{ value: (address(this).balance - ethForMarketing) } ("");
1016         (success,) = address(marketingWallet).call{ value: address(this).balance } ("");
1017     }
1018 
1019 }