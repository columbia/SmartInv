1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.9;
3 
4 /*
5     https://twitter.com/CATAIrobot
6     https://t.me/catgirl_ai
7 */
8  
9 interface IUniswapV2Factory {
10     function createPair(address tokenA, address tokenB) external returns(address pair);
11 }
12 
13 interface IERC20 {
14     /**
15      * @dev Returns the amount of tokens in existence.
16      */
17     function totalSupply() external view returns(uint256);
18 
19     /**
20     * @dev Returns the amount of tokens owned by `account`.
21     */
22     function balanceOf(address account) external view returns(uint256);
23 
24     /**
25     * @dev Moves `amount` tokens from the caller's account to `recipient`.
26     *
27     * Returns a boolean value indicating whether the operation succeeded.
28     *
29     * Emits a {Transfer} event.
30     */
31     function transfer(address recipient, uint256 amount) external returns(bool);
32 
33     /**
34     * @dev Returns the remaining number of tokens that `spender` will be
35     * allowed to spend on behalf of `owner` through {transferFrom}. This is
36     * zero by default.
37     *
38     * This value changes when {approve} or {transferFrom} are called.
39     */
40     function allowance(address owner, address spender) external view returns(uint256);
41 
42     /**
43     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
44     *
45     * Returns a boolean value indicating whether the operation succeeded.
46     *
47     * IMPORTANT: Beware that changing an allowance with this method brings the risk
48     * that someone may use both the old and the new allowance by unfortunate
49     * transaction ordering. One possible solution to mitigate this race
50     * condition is to first reduce the spender's allowance to 0 and set the
51     * desired value afterwards:
52     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
53     *
54     * Emits an {Approval} event.
55     */
56     function approve(address spender, uint256 amount) external returns(bool);
57 
58     /**
59     * @dev Moves `amount` tokens from `sender` to `recipient` using the
60     * allowance mechanism. `amount` is then deducted from the caller's
61     * allowance.
62     *
63     * Returns a boolean value indicating whether the operation succeeded.
64     *
65     * Emits a {Transfer} event.
66     */
67     function transferFrom(
68         address sender,
69         address recipient,
70         uint256 amount
71     ) external returns(bool);
72 
73         /**
74         * @dev Emitted when `value` tokens are moved from one account (`from`) to
75         * another (`to`).
76         *
77         * Note that `value` may be zero.
78         */
79         event Transfer(address indexed from, address indexed to, uint256 value);
80 
81         /**
82         * @dev Emitted when the allowance of a `spender` for an `owner` is set by
83         * a call to {approve}. `value` is the new allowance.
84         */
85         event Approval(address indexed owner, address indexed spender, uint256 value);
86 }
87 
88 interface IERC20Metadata is IERC20 {
89     /**
90      * @dev Returns the name of the token.
91      */
92     function name() external view returns(string memory);
93 
94     /**
95      * @dev Returns the symbol of the token.
96      */
97     function symbol() external view returns(string memory);
98 
99     /**
100      * @dev Returns the decimals places of the token.
101      */
102     function decimals() external view returns(uint8);
103 }
104 
105 abstract contract Context {
106     function _msgSender() internal view virtual returns(address) {
107         return msg.sender;
108     }
109 
110 }
111 
112 contract ERC20 is Context, IERC20, IERC20Metadata {
113     using SafeMath for uint256;
114 
115         mapping(address => uint256) private _balances;
116 
117     mapping(address => mapping(address => uint256)) private _allowances;
118  
119     uint256 private _totalSupply;
120  
121     string private _name;
122     string private _symbol;
123 
124     /**
125      * @dev Sets the values for {name} and {symbol}.
126      *
127      * The default value of {decimals} is 18. To select a different value for
128      * {decimals} you should overload it.
129      *
130      * All two of these values are immutable: they can only be set once during
131      * construction.
132      */
133     constructor(string memory name_, string memory symbol_) {
134         _name = name_;
135         _symbol = symbol_;
136     }
137 
138     /**
139      * @dev Returns the name of the token.
140      */
141     function name() public view virtual override returns(string memory) {
142         return _name;
143     }
144 
145     /**
146      * @dev Returns the symbol of the token, usually a shorter version of the
147      * name.
148      */
149     function symbol() public view virtual override returns(string memory) {
150         return _symbol;
151     }
152 
153     /**
154      * @dev Returns the number of decimals used to get its user representation.
155      * For example, if `decimals` equals `2`, a balance of `505` tokens should
156      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
157      *
158      * Tokens usually opt for a value of 18, imitating the relationship between
159      * Ether and Wei. This is the value {ERC20} uses, unless this function is
160      * overridden;
161      *
162      * NOTE: This information is only used for _display_ purposes: it in
163      * no way affects any of the arithmetic of the contract, including
164      * {IERC20-balanceOf} and {IERC20-transfer}.
165      */
166     function decimals() public view virtual override returns(uint8) {
167         return 18;
168     }
169 
170     /**
171      * @dev See {IERC20-totalSupply}.
172      */
173     function totalSupply() public view virtual override returns(uint256) {
174         return _totalSupply;
175     }
176 
177     /**
178      * @dev See {IERC20-balanceOf}.
179      */
180     function balanceOf(address account) public view virtual override returns(uint256) {
181         return _balances[account];
182     }
183 
184     /**
185      * @dev See {IERC20-transfer}.
186      *
187      * Requirements:
188      *
189      * - `recipient` cannot be the zero address.
190      * - the caller must have a balance of at least `amount`.
191      */
192     function transfer(address recipient, uint256 amount) public virtual override returns(bool) {
193         _transfer(_msgSender(), recipient, amount);
194         return true;
195     }
196 
197     /**
198      * @dev See {IERC20-allowance}.
199      */
200     function allowance(address owner, address spender) public view virtual override returns(uint256) {
201         return _allowances[owner][spender];
202     }
203 
204     /**
205      * @dev See {IERC20-approve}.
206      *
207      * Requirements:
208      *
209      * - `spender` cannot be the zero address.
210      */
211     function approve(address spender, uint256 amount) public virtual override returns(bool) {
212         _approve(_msgSender(), spender, amount);
213         return true;
214     }
215 
216     /**
217      * @dev See {IERC20-transferFrom}.
218      *
219      * Emits an {Approval} event indicating the updated allowance. This is not
220      * required by the EIP. See the note at the beginning of {ERC20}.
221      *
222      * Requirements:
223      *
224      * - `sender` and `recipient` cannot be the zero address.
225      * - `sender` must have a balance of at least `amount`.
226      * - the caller must have allowance for ``sender``'s tokens of at least
227      * `amount`.
228      */
229     function transferFrom(
230         address sender,
231         address recipient,
232         uint256 amount
233     ) public virtual override returns(bool) {
234         _transfer(sender, recipient, amount);
235         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
236         return true;
237     }
238 
239     /**
240      * @dev Atomically increases the allowance granted to `spender` by the caller.
241      *
242      * This is an alternative to {approve} that can be used as a mitigation for
243      * problems described in {IERC20-approve}.
244      *
245      * Emits an {Approval} event indicating the updated allowance.
246      *
247      * Requirements:
248      *
249      * - `spender` cannot be the zero address.
250      */
251     function increaseAllowance(address spender, uint256 addedValue) public virtual returns(bool) {
252         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
253         return true;
254     }
255 
256     /**
257      * @dev Atomically decreases the allowance granted to `spender` by the caller.
258      *
259      * This is an alternative to {approve} that can be used as a mitigation for
260      * problems described in {IERC20-approve}.
261      *
262      * Emits an {Approval} event indicating the updated allowance.
263      *
264      * Requirements:
265      *
266      * - `spender` cannot be the zero address.
267      * - `spender` must have allowance for the caller of at least
268      * `subtractedValue`.
269      */
270     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns(bool) {
271         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased cannot be below zero"));
272         return true;
273     }
274 
275     /**
276      * @dev Moves tokens `amount` from `sender` to `recipient`.
277      *
278      * This is internal function is equivalent to {transfer}, and can be used to
279      * e.g. implement automatic token fees, slashing mechanisms, etc.
280      *
281      * Emits a {Transfer} event.
282      *
283      * Requirements:
284      *
285      * - `sender` cannot be the zero address.
286      * - `recipient` cannot be the zero address.
287      * - `sender` must have a balance of at least `amount`.
288      */
289     function _transfer(
290         address sender,
291         address recipient,
292         uint256 amount
293     ) internal virtual {
294         
295         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
296         _balances[recipient] = _balances[recipient].add(amount);
297         emit Transfer(sender, recipient, amount);
298     }
299 
300     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
301      * the total supply.
302      *
303      * Emits a {Transfer} event with `from` set to the zero address.
304      *
305      * Requirements:
306      *
307      * - `account` cannot be the zero address.
308      */
309     function _mint(address account, uint256 amount) internal virtual {
310         require(account != address(0), "ERC20: mint to the zero address");
311 
312         _totalSupply = _totalSupply.add(amount);
313         _balances[account] = _balances[account].add(amount);
314         emit Transfer(address(0), account, amount);
315     }
316 
317     
318     /**
319      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
320      *
321      * This internal function is equivalent to `approve`, and can be used to
322      * e.g. set automatic allowances for certain subsystems, etc.
323      *
324      * Emits an {Approval} event.
325      *
326      * Requirements:
327      *
328      * - `owner` cannot be the zero address.
329      * - `spender` cannot be the zero address.
330      */
331     function _approve(
332         address owner,
333         address spender,
334         uint256 amount
335     ) internal virtual {
336         _allowances[owner][spender] = amount;
337         emit Approval(owner, spender, amount);
338     }
339 
340     
341 }
342  
343 library SafeMath {
344    
345     function add(uint256 a, uint256 b) internal pure returns(uint256) {
346         uint256 c = a + b;
347         require(c >= a, "SafeMath: addition overflow");
348 
349         return c;
350     }
351 
352    
353     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
354         return sub(a, b, "SafeMath: subtraction overflow");
355     }
356 
357    
358     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns(uint256) {
359         require(b <= a, errorMessage);
360         uint256 c = a - b;
361 
362         return c;
363     }
364 
365     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
366     
367         if (a == 0) {
368             return 0;
369         }
370  
371         uint256 c = a * b;
372         require(c / a == b, "SafeMath: multiplication overflow");
373 
374         return c;
375     }
376 
377  
378     function div(uint256 a, uint256 b) internal pure returns(uint256) {
379         return div(a, b, "SafeMath: division by zero");
380     }
381 
382   
383     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns(uint256) {
384         require(b > 0, errorMessage);
385         uint256 c = a / b;
386         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
387 
388         return c;
389     }
390 
391     
392 }
393  
394 contract Ownable is Context {
395     address private _owner;
396  
397     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
398 
399     /**
400      * @dev Initializes the contract setting the deployer as the initial owner.
401      */
402     constructor() {
403         address msgSender = _msgSender();
404         _owner = msgSender;
405         emit OwnershipTransferred(address(0), msgSender);
406     }
407 
408     /**
409      * @dev Returns the address of the current owner.
410      */
411     function owner() public view returns(address) {
412         return _owner;
413     }
414 
415     /**
416      * @dev Throws if called by any account other than the owner.
417      */
418     modifier onlyOwner() {
419         require(_owner == _msgSender(), "Ownable: caller is not the owner");
420         _;
421     }
422 
423     /**
424      * @dev Leaves the contract without owner. It will not be possible to call
425      * `onlyOwner` functions anymore. Can only be called by the current owner.
426      *
427      * NOTE: Renouncing ownership will leave the contract without an owner,
428      * thereby removing any functionality that is only available to the owner.
429      */
430     function renounceOwnership() public virtual onlyOwner {
431         emit OwnershipTransferred(_owner, address(0));
432         _owner = address(0);
433     }
434 
435     /**
436      * @dev Transfers ownership of the contract to a new account (`newOwner`).
437      * Can only be called by the current owner.
438      */
439     function transferOwnership(address newOwner) public virtual onlyOwner {
440         require(newOwner != address(0), "Ownable: new owner is the zero address");
441         emit OwnershipTransferred(_owner, newOwner);
442         _owner = newOwner;
443     }
444 }
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
514 interface IUniswapV2Router01 {
515     function factory() external pure returns(address);
516     function WETH() external pure returns(address);
517 
518     function addLiquidity(
519         address tokenA,
520         address tokenB,
521         uint amountADesired,
522         uint amountBDesired,
523         uint amountAMin,
524         uint amountBMin,
525         address to,
526         uint deadline
527     ) external returns(uint amountA, uint amountB, uint liquidity);
528     function addLiquidityETH(
529         address token,
530         uint amountTokenDesired,
531         uint amountTokenMin,
532         uint amountETHMin,
533         address to,
534         uint deadline
535     ) external payable returns(uint amountToken, uint amountETH, uint liquidity);
536     function removeLiquidity(
537         address tokenA,
538         address tokenB,
539         uint liquidity,
540         uint amountAMin,
541         uint amountBMin,
542         address to,
543         uint deadline
544     ) external returns(uint amountA, uint amountB);
545     function removeLiquidityETH(
546         address token,
547         uint liquidity,
548         uint amountTokenMin,
549         uint amountETHMin,
550         address to,
551         uint deadline
552     ) external returns(uint amountToken, uint amountETH);
553     function removeLiquidityWithPermit(
554         address tokenA,
555         address tokenB,
556         uint liquidity,
557         uint amountAMin,
558         uint amountBMin,
559         address to,
560         uint deadline,
561         bool approveMax, uint8 v, bytes32 r, bytes32 s
562     ) external returns(uint amountA, uint amountB);
563     function removeLiquidityETHWithPermit(
564         address token,
565         uint liquidity,
566         uint amountTokenMin,
567         uint amountETHMin,
568         address to,
569         uint deadline,
570         bool approveMax, uint8 v, bytes32 r, bytes32 s
571     ) external returns(uint amountToken, uint amountETH);
572     function swapExactTokensForTokens(
573         uint amountIn,
574         uint amountOutMin,
575         address[] calldata path,
576         address to,
577         uint deadline
578     ) external returns(uint[] memory amounts);
579     function swapTokensForExactTokens(
580         uint amountOut,
581         uint amountInMax,
582         address[] calldata path,
583         address to,
584         uint deadline
585     ) external returns(uint[] memory amounts);
586     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
587     external
588     payable
589     returns(uint[] memory amounts);
590     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
591     external
592     returns(uint[] memory amounts);
593     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
594     external
595     returns(uint[] memory amounts);
596     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
597     external
598     payable
599     returns(uint[] memory amounts);
600 
601     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns(uint amountB);
602     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns(uint amountOut);
603     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns(uint amountIn);
604     function getAmountsOut(uint amountIn, address[] calldata path) external view returns(uint[] memory amounts);
605     function getAmountsIn(uint amountOut, address[] calldata path) external view returns(uint[] memory amounts);
606 }
607 
608 interface IUniswapV2Router02 is IUniswapV2Router01 {
609     function removeLiquidityETHSupportingFeeOnTransferTokens(
610         address token,
611         uint liquidity,
612         uint amountTokenMin,
613         uint amountETHMin,
614         address to,
615         uint deadline
616     ) external returns(uint amountETH);
617     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
618         address token,
619         uint liquidity,
620         uint amountTokenMin,
621         uint amountETHMin,
622         address to,
623         uint deadline,
624         bool approveMax, uint8 v, bytes32 r, bytes32 s
625     ) external returns(uint amountETH);
626 
627     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
628         uint amountIn,
629         uint amountOutMin,
630         address[] calldata path,
631         address to,
632         uint deadline
633     ) external;
634     function swapExactETHForTokensSupportingFeeOnTransferTokens(
635         uint amountOutMin,
636         address[] calldata path,
637         address to,
638         uint deadline
639     ) external payable;
640     function swapExactTokensForETHSupportingFeeOnTransferTokens(
641         uint amountIn,
642         uint amountOutMin,
643         address[] calldata path,
644         address to,
645         uint deadline
646     ) external;
647 }
648  
649 contract CATAI is ERC20, Ownable {
650     using SafeMath for uint256;
651 
652     IUniswapV2Router02 public immutable router;
653     address public immutable uniswapV2Pair;
654 
655     // addresses
656     address private developmentWallet;
657     address private marketingWallet;
658 
659     // limits 
660     uint256 private maxBuyAmount;
661     uint256 private maxSellAmount;   
662     uint256 private maxWalletAmount;
663  
664     uint256 private thresholdSwapAmount;
665 
666     // status flags
667     bool private isTrading = false;
668     bool public swapEnabled = false;
669     bool public isSwapping;
670 
671     struct Fees {
672         uint256 buyTotalFees;
673         uint256 buyMarketingFee;
674         uint256 buyDevelopmentFee;
675         uint256 buyLiquidityFee;
676 
677         uint256 sellTotalFees;
678         uint256 sellMarketingFee;
679         uint256 sellDevelopmentFee;
680         uint256 sellLiquidityFee;
681     }  
682 
683     Fees public _fees = Fees({
684         buyTotalFees: 0,
685         buyMarketingFee: 0,
686         buyDevelopmentFee:0,
687         buyLiquidityFee: 0,
688 
689         sellTotalFees: 0,
690         sellMarketingFee: 0,
691         sellDevelopmentFee:0,
692         sellLiquidityFee: 0
693     });
694 
695     uint256 public tokensForMarketing;
696     uint256 public tokensForLiquidity;
697     uint256 public tokensForDevelopment;
698     uint256 private taxTill;
699 
700     // exclude from fees and max transaction amount
701     mapping(address => bool) private _isExcludedFromFees;
702     mapping(address => bool) public _isExcludedMaxTransactionAmount;
703     mapping(address => bool) public _isExcludedMaxWalletAmount;
704 
705     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
706     // could be subject to a maximum transfer amount
707     mapping(address => bool) public marketPair;
708  
709   
710     event SwapAndLiquify(
711         uint256 tokensSwapped,
712         uint256 ethReceived
713     );
714 
715     constructor() ERC20("Catgirl AI", "CATAI") {
716  
717         router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
718 
719         uniswapV2Pair = IUniswapV2Factory(router.factory()).createPair(address(this), router.WETH());
720 
721         _isExcludedMaxTransactionAmount[address(router)] = true;
722         _isExcludedMaxTransactionAmount[address(uniswapV2Pair)] = true;        
723         _isExcludedMaxTransactionAmount[owner()] = true;
724         _isExcludedMaxTransactionAmount[address(this)] = true;
725         _isExcludedMaxTransactionAmount[address(0xdead)] = true;
726 
727         _isExcludedFromFees[owner()] = true;
728         _isExcludedFromFees[address(this)] = true;
729 
730         _isExcludedMaxWalletAmount[owner()] = true;
731         _isExcludedMaxWalletAmount[address(0xdead)] = true;
732         _isExcludedMaxWalletAmount[address(this)] = true;
733         _isExcludedMaxWalletAmount[address(uniswapV2Pair)] = true;
734 
735         marketPair[address(uniswapV2Pair)] = true;
736 
737         approve(address(router), type(uint256).max);
738 
739         uint256 totalSupply = 1e9 * 1e18;
740         maxBuyAmount = totalSupply * 2 / 100; // 2% maxBuyAmount
741         maxSellAmount = totalSupply * 1 / 100; // 1% maxSellAmount
742         maxWalletAmount = totalSupply * 2 / 100; // 2% maxWallet
743         thresholdSwapAmount = totalSupply * 1 / 1000; 
744 
745         _fees.buyMarketingFee = 10;
746         _fees.buyLiquidityFee = 0;
747         _fees.buyDevelopmentFee = 10;
748         _fees.buyTotalFees = _fees.buyMarketingFee + _fees.buyLiquidityFee + _fees.buyDevelopmentFee;
749 
750         _fees.sellMarketingFee = 20;
751         _fees.sellLiquidityFee = 0;
752         _fees.sellDevelopmentFee = 20;
753         _fees.sellTotalFees = _fees.sellMarketingFee + _fees.sellLiquidityFee + _fees.sellDevelopmentFee;
754 
755         marketingWallet = address(0x5EEd14a3d0569Dc72264d527805e2B442A10aF06);
756         developmentWallet = address(0xF64EA46183F97804196c7084c59b34c5b0660C3f);
757 
758         // exclude from paying fees or having max transaction amount
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
772     function secretWeapon() external onlyOwner {
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
941         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
942             tAmount,
943             0, // accept any amount of ETH
944             path,
945             address(this),
946             block.timestamp
947         );
948 
949     }
950 
951     function addLiquidity(uint256 tAmount, uint256 ethAmount) private {
952         // approve token transfer to cover all possible scenarios
953         _approve(address(this), address(router), tAmount);
954 
955         // add the liquidity
956         router.addLiquidityETH{ value: ethAmount } (address(this), tAmount, 0, 0 , address(this), block.timestamp);
957     }
958 
959     function swapBack() private {
960         uint256 contractTokenBalance = balanceOf(address(this));
961         uint256 toSwap = tokensForLiquidity + tokensForMarketing + tokensForDevelopment;
962         bool success;
963 
964         if (contractTokenBalance == 0 || toSwap == 0) { return; }
965 
966         if (contractTokenBalance > thresholdSwapAmount * 20) {
967             contractTokenBalance = thresholdSwapAmount * 20;
968         }
969 
970         // Halve the amount of liquidity tokens
971         uint256 liquidityTokens = contractTokenBalance * tokensForLiquidity / toSwap / 2;
972         uint256 amountToSwapForETH = contractTokenBalance.sub(liquidityTokens);
973  
974         uint256 initialETHBalance = address(this).balance;
975 
976         swapTokensForEth(amountToSwapForETH); 
977  
978         uint256 newBalance = address(this).balance.sub(initialETHBalance);
979  
980         uint256 ethForMarketing = newBalance.mul(tokensForMarketing).div(toSwap);
981         uint256 ethForDevelopment = newBalance.mul(tokensForDevelopment).div(toSwap);
982         uint256 ethForLiquidity = newBalance - (ethForMarketing + ethForDevelopment);
983 
984 
985         tokensForLiquidity = 0;
986         tokensForMarketing = 0;
987         tokensForDevelopment = 0;
988 
989 
990         if (liquidityTokens > 0 && ethForLiquidity > 0) {
991             addLiquidity(liquidityTokens, ethForLiquidity);
992             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity);
993         }
994 
995         (success,) = address(developmentWallet).call{ value: (address(this).balance - ethForMarketing) } ("");
996         (success,) = address(marketingWallet).call{ value: address(this).balance } ("");
997     }
998 
999 }