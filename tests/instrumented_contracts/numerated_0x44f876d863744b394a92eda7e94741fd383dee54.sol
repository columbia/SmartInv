1 /*
2 $BOOMER Coin: Older generation's #1 choice for wealth storage
3 
4 As banks begin dropping like flies, Boomers search for a safe haven in the digital world
5 
6 Investors are encouraged to bring in as many Boomer investors as possible, teach them how to buy
7 and let them figure out themselves how to sell
8 
9 
10 Final tax: 1/1 LP
11 
12 
13 Website: https://boomercoinerc.com/
14 Telegram: @BoomerCoinERC
15 Twitter: https://twitter.com/BoomerERC
16 */
17 
18 // SPDX-License-Identifier: MIT
19 pragma solidity ^0.8.11;
20 
21 interface IUniswapV2Factory {
22     function createPair(address tokenA, address tokenB) external returns(address pair);
23 }
24 
25 interface IERC20 {
26     /**
27      * @dev Returns the amount of tokens in existence.
28      */
29     function totalSupply() external view returns(uint256);
30 
31     /**
32     * @dev Returns the amount of tokens owned by `account`.
33     */
34     function balanceOf(address account) external view returns(uint256);
35 
36     /**
37     * @dev Moves `amount` tokens from the caller's account to `recipient`.
38     *
39     * Returns a boolean value indicating whether the operation succeeded.
40     *
41     * Emits a {Transfer} event.
42     */
43     function transfer(address recipient, uint256 amount) external returns(bool);
44 
45     /**
46     * @dev Returns the remaining number of tokens that `spender` will be
47     * allowed to spend on behalf of `owner` through {transferFrom}. This is
48     * zero by default.
49     *
50     * This value changes when {approve} or {transferFrom} are called.
51     */
52     function allowance(address owner, address spender) external view returns(uint256);
53 
54     /**
55     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
56     *
57     * Returns a boolean value indicating whether the operation succeeded.
58     *
59     * IMPORTANT: Beware that changing an allowance with this method brings the risk
60     * that someone may use both the old and the new allowance by unfortunate
61     * transaction ordering. One possible solution to mitigate this race
62     * condition is to first reduce the spender's allowance to 0 and set the
63     * desired value afterwards:
64     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
65     *
66     * Emits an {Approval} event.
67     */
68     function approve(address spender, uint256 amount) external returns(bool);
69 
70     /**
71     * @dev Moves `amount` tokens from `sender` to `recipient` using the
72     * allowance mechanism. `amount` is then deducted from the caller's
73     * allowance.
74     *
75     * Returns a boolean value indicating whether the operation succeeded.
76     *
77     * Emits a {Transfer} event.
78     */
79     function transferFrom(
80         address sender,
81         address recipient,
82         uint256 amount
83     ) external returns(bool);
84 
85         /**
86         * @dev Emitted when `value` tokens are moved from one account (`from`) to
87         * another (`to`).
88         *
89         * Note that `value` may be zero.
90         */
91         event Transfer(address indexed from, address indexed to, uint256 value);
92 
93         /**
94         * @dev Emitted when the allowance of a `spender` for an `owner` is set by
95         * a call to {approve}. `value` is the new allowance.
96         */
97         event Approval(address indexed owner, address indexed spender, uint256 value);
98 }
99 
100 interface IERC20Metadata is IERC20 {
101     /**
102      * @dev Returns the name of the token.
103      */
104     function name() external view returns(string memory);
105 
106     /**
107      * @dev Returns the symbol of the token.
108      */
109     function symbol() external view returns(string memory);
110 
111     /**
112      * @dev Returns the decimals places of the token.
113      */
114     function decimals() external view returns(uint8);
115 }
116 
117 abstract contract Context {
118     function _msgSender() internal view virtual returns(address) {
119         return msg.sender;
120     }
121 
122 }
123 
124 contract ERC20 is Context, IERC20, IERC20Metadata {
125     using SafeMath for uint256;
126 
127         mapping(address => uint256) private _balances;
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
153     function name() public view virtual override returns(string memory) {
154         return _name;
155     }
156 
157     /**
158      * @dev Returns the symbol of the token, usually a shorter version of the
159      * name.
160      */
161     function symbol() public view virtual override returns(string memory) {
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
178     function decimals() public view virtual override returns(uint8) {
179         return 18;
180     }
181 
182     /**
183      * @dev See {IERC20-totalSupply}.
184      */
185     function totalSupply() public view virtual override returns(uint256) {
186         return _totalSupply;
187     }
188 
189     /**
190      * @dev See {IERC20-balanceOf}.
191      */
192     function balanceOf(address account) public view virtual override returns(uint256) {
193         return _balances[account];
194     }
195 
196     /**
197      * @dev See {IERC20-transfer}.
198      *
199      * Requirements:
200      *
201      * - `recipient` cannot be the zero address.
202      * - the caller must have a balance of at least `amount`.
203      */
204     function transfer(address recipient, uint256 amount) public virtual override returns(bool) {
205         _transfer(_msgSender(), recipient, amount);
206         return true;
207     }
208 
209     /**
210      * @dev See {IERC20-allowance}.
211      */
212     function allowance(address owner, address spender) public view virtual override returns(uint256) {
213         return _allowances[owner][spender];
214     }
215 
216     /**
217      * @dev See {IERC20-approve}.
218      *
219      * Requirements:
220      *
221      * - `spender` cannot be the zero address.
222      */
223     function approve(address spender, uint256 amount) public virtual override returns(bool) {
224         _approve(_msgSender(), spender, amount);
225         return true;
226     }
227 
228     /**
229      * @dev See {IERC20-transferFrom}.
230      *
231      * Emits an {Approval} event indicating the updated allowance. This is not
232      * required by the EIP. See the note at the beginning of {ERC20}.
233      *
234      * Requirements:
235      *
236      * - `sender` and `recipient` cannot be the zero address.
237      * - `sender` must have a balance of at least `amount`.
238      * - the caller must have allowance for ``sender``'s tokens of at least
239      * `amount`.
240      */
241     function transferFrom(
242         address sender,
243         address recipient,
244         uint256 amount
245     ) public virtual override returns(bool) {
246         _transfer(sender, recipient, amount);
247         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
248         return true;
249     }
250 
251     /**
252      * @dev Atomically increases the allowance granted to `spender` by the caller.
253      *
254      * This is an alternative to {approve} that can be used as a mitigation for
255      * problems described in {IERC20-approve}.
256      *
257      * Emits an {Approval} event indicating the updated allowance.
258      *
259      * Requirements:
260      *
261      * - `spender` cannot be the zero address.
262      */
263     function increaseAllowance(address spender, uint256 addedValue) public virtual returns(bool) {
264         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
265         return true;
266     }
267 
268     /**
269      * @dev Atomically decreases the allowance granted to `spender` by the caller.
270      *
271      * This is an alternative to {approve} that can be used as a mitigation for
272      * problems described in {IERC20-approve}.
273      *
274      * Emits an {Approval} event indicating the updated allowance.
275      *
276      * Requirements:
277      *
278      * - `spender` cannot be the zero address.
279      * - `spender` must have allowance for the caller of at least
280      * `subtractedValue`.
281      */
282     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns(bool) {
283         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased cannot be below zero"));
284         return true;
285     }
286 
287     /**
288      * @dev Moves tokens `amount` from `sender` to `recipient`.
289      *
290      * This is internal function is equivalent to {transfer}, and can be used to
291      * e.g. implement automatic token fees, slashing mechanisms, etc.
292      *
293      * Emits a {Transfer} event.
294      *
295      * Requirements:
296      *
297      * - `sender` cannot be the zero address.
298      * - `recipient` cannot be the zero address.
299      * - `sender` must have a balance of at least `amount`.
300      */
301     function _transfer(
302         address sender,
303         address recipient,
304         uint256 amount
305     ) internal virtual {
306         
307         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
308         _balances[recipient] = _balances[recipient].add(amount);
309         emit Transfer(sender, recipient, amount);
310     }
311 
312     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
313      * the total supply.
314      *
315      * Emits a {Transfer} event with `from` set to the zero address.
316      *
317      * Requirements:
318      *
319      * - `account` cannot be the zero address.
320      */
321     function _mint(address account, uint256 amount) internal virtual {
322         require(account != address(0), "ERC20: mint to the zero address");
323 
324         _totalSupply = _totalSupply.add(amount);
325         _balances[account] = _balances[account].add(amount);
326         emit Transfer(address(0), account, amount);
327     }
328 
329     
330     /**
331      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
332      *
333      * This internal function is equivalent to `approve`, and can be used to
334      * e.g. set automatic allowances for certain subsystems, etc.
335      *
336      * Emits an {Approval} event.
337      *
338      * Requirements:
339      *
340      * - `owner` cannot be the zero address.
341      * - `spender` cannot be the zero address.
342      */
343     function _approve(
344         address owner,
345         address spender,
346         uint256 amount
347     ) internal virtual {
348         _allowances[owner][spender] = amount;
349         emit Approval(owner, spender, amount);
350     }
351 
352     
353 }
354  
355 library SafeMath {
356    
357     function add(uint256 a, uint256 b) internal pure returns(uint256) {
358         uint256 c = a + b;
359         require(c >= a, "SafeMath: addition overflow");
360 
361         return c;
362     }
363 
364    
365     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
366         return sub(a, b, "SafeMath: subtraction overflow");
367     }
368 
369    
370     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns(uint256) {
371         require(b <= a, errorMessage);
372         uint256 c = a - b;
373 
374         return c;
375     }
376 
377     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
378     
379         if (a == 0) {
380             return 0;
381         }
382  
383         uint256 c = a * b;
384         require(c / a == b, "SafeMath: multiplication overflow");
385 
386         return c;
387     }
388 
389  
390     function div(uint256 a, uint256 b) internal pure returns(uint256) {
391         return div(a, b, "SafeMath: division by zero");
392     }
393 
394   
395     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns(uint256) {
396         require(b > 0, errorMessage);
397         uint256 c = a / b;
398         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
399 
400         return c;
401     }
402 
403     
404 }
405  
406 contract Ownable is Context {
407     address private _owner;
408  
409     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
410 
411     /**
412      * @dev Initializes the contract setting the deployer as the initial owner.
413      */
414     constructor() {
415         address msgSender = _msgSender();
416         _owner = msgSender;
417         emit OwnershipTransferred(address(0), msgSender);
418     }
419 
420     /**
421      * @dev Returns the address of the current owner.
422      */
423     function owner() public view returns(address) {
424         return _owner;
425     }
426 
427     /**
428      * @dev Throws if called by any account other than the owner.
429      */
430     modifier onlyOwner() {
431         require(_owner == _msgSender(), "Ownable: caller is not the owner");
432         _;
433     }
434 
435     /**
436      * @dev Leaves the contract without owner. It will not be possible to call
437      * `onlyOwner` functions anymore. Can only be called by the current owner.
438      *
439      * NOTE: Renouncing ownership will leave the contract without an owner,
440      * thereby removing any functionality that is only available to the owner.
441      */
442     function renounceOwnership() public virtual onlyOwner {
443         emit OwnershipTransferred(_owner, address(0));
444         _owner = address(0);
445     }
446 
447     /**
448      * @dev Transfers ownership of the contract to a new account (`newOwner`).
449      * Can only be called by the current owner.
450      */
451     function transferOwnership(address newOwner) public virtual onlyOwner {
452         require(newOwner != address(0), "Ownable: new owner is the zero address");
453         emit OwnershipTransferred(_owner, newOwner);
454         _owner = newOwner;
455     }
456 }
457  
458 library SafeMathInt {
459     int256 private constant MIN_INT256 = int256(1) << 255;
460     int256 private constant MAX_INT256 = ~(int256(1) << 255);
461 
462     /**
463      * @dev Multiplies two int256 variables and fails on overflow.
464      */
465     function mul(int256 a, int256 b) internal pure returns(int256) {
466         int256 c = a * b;
467 
468         // Detect overflow when multiplying MIN_INT256 with -1
469         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
470         require((b == 0) || (c / b == a));
471         return c;
472     }
473 
474     /**
475      * @dev Division of two int256 variables and fails on overflow.
476      */
477     function div(int256 a, int256 b) internal pure returns(int256) {
478         // Prevent overflow when dividing MIN_INT256 by -1
479         require(b != -1 || a != MIN_INT256);
480 
481         // Solidity already throws when dividing by 0.
482         return a / b;
483     }
484 
485     /**
486      * @dev Subtracts two int256 variables and fails on overflow.
487      */
488     function sub(int256 a, int256 b) internal pure returns(int256) {
489         int256 c = a - b;
490         require((b >= 0 && c <= a) || (b < 0 && c > a));
491         return c;
492     }
493 
494     /**
495      * @dev Adds two int256 variables and fails on overflow.
496      */
497     function add(int256 a, int256 b) internal pure returns(int256) {
498         int256 c = a + b;
499         require((b >= 0 && c >= a) || (b < 0 && c < a));
500         return c;
501     }
502 
503     /**
504      * @dev Converts to absolute value, and fails on overflow.
505      */
506     function abs(int256 a) internal pure returns(int256) {
507         require(a != MIN_INT256);
508         return a < 0 ? -a : a;
509     }
510 
511 
512     function toUint256Safe(int256 a) internal pure returns(uint256) {
513         require(a >= 0);
514         return uint256(a);
515     }
516 }
517  
518 library SafeMathUint {
519     function toInt256Safe(uint256 a) internal pure returns(int256) {
520     int256 b = int256(a);
521         require(b >= 0);
522         return b;
523     }
524 }
525 
526 interface IUniswapV2Router01 {
527     function factory() external pure returns(address);
528     function WETH() external pure returns(address);
529 
530     function addLiquidity(
531         address tokenA,
532         address tokenB,
533         uint amountADesired,
534         uint amountBDesired,
535         uint amountAMin,
536         uint amountBMin,
537         address to,
538         uint deadline
539     ) external returns(uint amountA, uint amountB, uint liquidity);
540     function addLiquidityETH(
541         address token,
542         uint amountTokenDesired,
543         uint amountTokenMin,
544         uint amountETHMin,
545         address to,
546         uint deadline
547     ) external payable returns(uint amountToken, uint amountETH, uint liquidity);
548     function removeLiquidity(
549         address tokenA,
550         address tokenB,
551         uint liquidity,
552         uint amountAMin,
553         uint amountBMin,
554         address to,
555         uint deadline
556     ) external returns(uint amountA, uint amountB);
557     function removeLiquidityETH(
558         address token,
559         uint liquidity,
560         uint amountTokenMin,
561         uint amountETHMin,
562         address to,
563         uint deadline
564     ) external returns(uint amountToken, uint amountETH);
565     function removeLiquidityWithPermit(
566         address tokenA,
567         address tokenB,
568         uint liquidity,
569         uint amountAMin,
570         uint amountBMin,
571         address to,
572         uint deadline,
573         bool approveMax, uint8 v, bytes32 r, bytes32 s
574     ) external returns(uint amountA, uint amountB);
575     function removeLiquidityETHWithPermit(
576         address token,
577         uint liquidity,
578         uint amountTokenMin,
579         uint amountETHMin,
580         address to,
581         uint deadline,
582         bool approveMax, uint8 v, bytes32 r, bytes32 s
583     ) external returns(uint amountToken, uint amountETH);
584     function swapExactTokensForTokens(
585         uint amountIn,
586         uint amountOutMin,
587         address[] calldata path,
588         address to,
589         uint deadline
590     ) external returns(uint[] memory amounts);
591     function swapTokensForExactTokens(
592         uint amountOut,
593         uint amountInMax,
594         address[] calldata path,
595         address to,
596         uint deadline
597     ) external returns(uint[] memory amounts);
598     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
599     external
600     payable
601     returns(uint[] memory amounts);
602     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
603     external
604     returns(uint[] memory amounts);
605     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
606     external
607     returns(uint[] memory amounts);
608     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
609     external
610     payable
611     returns(uint[] memory amounts);
612 
613     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns(uint amountB);
614     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns(uint amountOut);
615     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns(uint amountIn);
616     function getAmountsOut(uint amountIn, address[] calldata path) external view returns(uint[] memory amounts);
617     function getAmountsIn(uint amountOut, address[] calldata path) external view returns(uint[] memory amounts);
618 }
619 
620 interface IUniswapV2Router02 is IUniswapV2Router01 {
621     function removeLiquidityETHSupportingFeeOnTransferTokens(
622         address token,
623         uint liquidity,
624         uint amountTokenMin,
625         uint amountETHMin,
626         address to,
627         uint deadline
628     ) external returns(uint amountETH);
629     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
630         address token,
631         uint liquidity,
632         uint amountTokenMin,
633         uint amountETHMin,
634         address to,
635         uint deadline,
636         bool approveMax, uint8 v, bytes32 r, bytes32 s
637     ) external returns(uint amountETH);
638 
639     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
640         uint amountIn,
641         uint amountOutMin,
642         address[] calldata path,
643         address to,
644         uint deadline
645     ) external;
646     function swapExactETHForTokensSupportingFeeOnTransferTokens(
647         uint amountOutMin,
648         address[] calldata path,
649         address to,
650         uint deadline
651     ) external payable;
652     function swapExactTokensForETHSupportingFeeOnTransferTokens(
653         uint amountIn,
654         uint amountOutMin,
655         address[] calldata path,
656         address to,
657         uint deadline
658     ) external;
659 }
660  
661 contract BOOMER is ERC20, Ownable { 
662     using SafeMath for uint256;
663 
664     IUniswapV2Router02 public immutable router;
665     address public immutable uniswapV2Pair;
666 
667     address private developmentWallet;
668     address private marketingWallet;
669 
670     uint256 private maxBuyAmount;
671     uint256 private maxSellAmount;   
672     uint256 private maxWalletAmount;
673  
674     uint256 private thresholdSwapAmount;
675 
676     bool private isTrading = false;
677     bool public swapEnabled = false;
678     bool public isSwapping;
679 
680     struct Fees {
681         uint256 buyTotalFees;
682         uint256 buyMarketingFee;
683         uint256 buyDevelopmentFee;
684         uint256 buyLiquidityFee;
685 
686         uint256 sellTotalFees;
687         uint256 sellMarketingFee;
688         uint256 sellDevelopmentFee;
689         uint256 sellLiquidityFee;
690     }  
691 
692     Fees public _fees = Fees({
693         buyTotalFees: 0,
694         buyMarketingFee: 0,
695         buyDevelopmentFee:0,
696         buyLiquidityFee: 0,
697 
698         sellTotalFees: 0,
699         sellMarketingFee: 0,
700         sellDevelopmentFee:0,
701         sellLiquidityFee: 0
702     });
703 
704     uint256 public tokensForMarketing;
705     uint256 public tokensForLiquidity;
706     uint256 public tokensForDevelopment;
707     uint256 private taxTill;
708 
709     mapping(address => bool) private _isExcludedFromFees;
710     mapping(address => bool) public _isExcludedMaxTransactionAmount;
711     mapping(address => bool) public _isExcludedMaxWalletAmount;
712 
713     mapping(address => bool) public marketPair;
714  
715   
716     event SwapAndLiquify(
717         uint256 tokensSwapped,
718         uint256 ethReceived
719     );
720 
721     constructor() ERC20("Boomer Coin", "BOOMER") { 
722  
723         router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
724 
725         uniswapV2Pair = IUniswapV2Factory(router.factory()).createPair(address(this), router.WETH());
726 
727         _isExcludedMaxTransactionAmount[address(router)] = true;
728         _isExcludedMaxTransactionAmount[address(uniswapV2Pair)] = true;        
729         _isExcludedMaxTransactionAmount[owner()] = true;
730         _isExcludedMaxTransactionAmount[address(this)] = true;
731         _isExcludedMaxTransactionAmount[address(0xdead)] = true;
732 
733         _isExcludedFromFees[owner()] = true;
734         _isExcludedFromFees[address(this)] = true;
735 
736         _isExcludedMaxWalletAmount[owner()] = true;
737         _isExcludedMaxWalletAmount[address(0xdead)] = true;
738         _isExcludedMaxWalletAmount[address(this)] = true;
739         _isExcludedMaxWalletAmount[address(uniswapV2Pair)] = true;
740 
741         marketPair[address(uniswapV2Pair)] = true;
742 
743         approve(address(router), type(uint256).max);
744 
745         uint256 totalSupply = 1e9 * 1e18;
746         maxBuyAmount = totalSupply * 1 / 100; // 1% maxBuyAmount
747         maxSellAmount = totalSupply * 1 / 100; // 1% maxSellAmount
748         maxWalletAmount = totalSupply * 2 / 100; // 2% maxWallet
749         thresholdSwapAmount = totalSupply * 1 / 1000; 
750 
751         _fees.buyMarketingFee = 25; 
752         _fees.buyLiquidityFee = 5;  
753         _fees.buyDevelopmentFee = 0; 
754         _fees.buyTotalFees = _fees.buyMarketingFee + _fees.buyLiquidityFee + _fees.buyDevelopmentFee;
755 
756         _fees.sellMarketingFee = 45; 
757         _fees.sellLiquidityFee = 5; 
758         _fees.sellDevelopmentFee = 0; 
759         _fees.sellTotalFees = _fees.sellMarketingFee + _fees.sellLiquidityFee + _fees.sellDevelopmentFee;
760 
761         marketingWallet = address(0x7C41fCADe4991A63CD39c2939925FBFA689f8395); 
762         developmentWallet = address(0x7C41fCADe4991A63CD39c2939925FBFA689f8395); 
763 
764         // exclude from paying fees or having max transaction amount
765 
766         /*
767             _mint is an internal function in ERC20.sol that is only called here,
768             and CANNOT be called ever again
769         */
770 
771         _mint(msg.sender, totalSupply);
772     }
773 
774     receive() external payable {
775 
776     }
777 
778     // once enabled, can never be turned off
779     function startTrading() external onlyOwner {
780         isTrading = true;
781         swapEnabled = true;
782         taxTill = block.number + 0;
783     }
784 
785     // change the minimum amount of tokens to sell from fees
786     function updateThresholdSwapAmount(uint256 newAmount) external onlyOwner returns(bool){
787         thresholdSwapAmount = newAmount;
788         return true;
789     }
790 
791     function updateMaxTxnAmount(uint256 newMaxBuy, uint256 newMaxSell) public onlyOwner {
792         maxBuyAmount = (totalSupply() * newMaxBuy) / 1000;
793         maxSellAmount = (totalSupply() * newMaxSell) / 1000;
794     }
795 
796     function updateMaxWalletAmount(uint256 newPercentage) public onlyOwner {
797         maxWalletAmount = (totalSupply() * newPercentage) / 1000;
798     }
799 
800     // only use to disable contract sales if absolutely necessary (emergency use only)
801     function toggleSwapEnabled(bool enabled) external onlyOwner(){
802         swapEnabled = enabled;
803     }
804 
805     function updateFees(uint256 _marketingFeeBuy, uint256 _liquidityFeeBuy,uint256 _developmentFeeBuy,uint256 _marketingFeeSell, uint256 _liquidityFeeSell,uint256 _developmentFeeSell) external onlyOwner{
806         _fees.buyMarketingFee = _marketingFeeBuy;
807         _fees.buyLiquidityFee = _liquidityFeeBuy;
808         _fees.buyDevelopmentFee = _developmentFeeBuy;
809         _fees.buyTotalFees = _fees.buyMarketingFee + _fees.buyLiquidityFee + _fees.buyDevelopmentFee;
810 
811         _fees.sellMarketingFee = _marketingFeeSell;
812         _fees.sellLiquidityFee = _liquidityFeeSell;
813         _fees.sellDevelopmentFee = _developmentFeeSell;
814         _fees.sellTotalFees = _fees.sellMarketingFee + _fees.sellLiquidityFee + _fees.sellDevelopmentFee;
815     }
816     
817     function excludeFromFees(address account, bool excluded) public onlyOwner {
818         _isExcludedFromFees[account] = excluded;
819     }
820     function excludeFromWalletLimit(address account, bool excluded) public onlyOwner {
821         _isExcludedMaxWalletAmount[account] = excluded;
822     }
823     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
824         _isExcludedMaxTransactionAmount[updAds] = isEx;
825     }
826 
827     function removeLimits() external onlyOwner {
828         updateMaxTxnAmount(1000,1000);
829         updateMaxWalletAmount(1000);
830     }
831 
832     function setMarketPair(address pair, bool value) public onlyOwner {
833         require(pair != uniswapV2Pair, "The pair cannot be removed from marketPair");
834         marketPair[pair] = value;
835     }
836 
837     function setWallets(address _marketingWallet,address _developmentWallet) external onlyOwner{
838         marketingWallet = _marketingWallet;
839         developmentWallet = _developmentWallet;
840     }
841 
842     function isExcludedFromFees(address account) public view returns(bool) {
843         return _isExcludedFromFees[account];
844     }
845 
846     function _transfer(
847         address sender,
848         address recipient,
849         uint256 amount
850     ) internal override {
851         
852         if (amount == 0) {
853             super._transfer(sender, recipient, 0);
854             return;
855         }
856 
857         if (
858             sender != owner() &&
859             recipient != owner() &&
860             !isSwapping
861         ) {
862 
863             if (!isTrading) {
864                 require(_isExcludedFromFees[sender] || _isExcludedFromFees[recipient], "Trading is not active.");
865             }
866             if (marketPair[sender] && !_isExcludedMaxTransactionAmount[recipient]) {
867                 require(amount <= maxBuyAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
868             } 
869             else if (marketPair[recipient] && !_isExcludedMaxTransactionAmount[sender]) {
870                 require(amount <= maxSellAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
871             }
872 
873             if (!_isExcludedMaxWalletAmount[recipient]) {
874                 require(amount + balanceOf(recipient) <= maxWalletAmount, "Max wallet exceeded");
875             }
876 
877         }
878  
879         uint256 contractTokenBalance = balanceOf(address(this));
880  
881         bool canSwap = contractTokenBalance >= thresholdSwapAmount;
882 
883         if (
884             canSwap &&
885             swapEnabled &&
886             !isSwapping &&
887             marketPair[recipient] &&
888             !_isExcludedFromFees[sender] &&
889             !_isExcludedFromFees[recipient]
890         ) {
891             isSwapping = true;
892             swapBack();
893             isSwapping = false;
894         }
895  
896         bool takeFee = !isSwapping;
897 
898         // if any account belongs to _isExcludedFromFee account then remove the fee
899         if (_isExcludedFromFees[sender] || _isExcludedFromFees[recipient]) {
900             takeFee = false;
901         }
902  
903         
904         // only take fees on buys/sells, do not take on wallet transfers
905         if (takeFee) {
906             uint256 fees = 0;
907             if(block.number < taxTill) {
908                 fees = amount.mul(99).div(100);
909                 tokensForMarketing += (fees * 94) / 99;
910                 tokensForDevelopment += (fees * 5) / 99;
911             } else if (marketPair[recipient] && _fees.sellTotalFees > 0) {
912                 fees = amount.mul(_fees.sellTotalFees).div(100);
913                 tokensForLiquidity += fees * _fees.sellLiquidityFee / _fees.sellTotalFees;
914                 tokensForMarketing += fees * _fees.sellMarketingFee / _fees.sellTotalFees;
915                 tokensForDevelopment += fees * _fees.sellDevelopmentFee / _fees.sellTotalFees;
916             }
917             // on buy
918             else if (marketPair[sender] && _fees.buyTotalFees > 0) {
919                 fees = amount.mul(_fees.buyTotalFees).div(100);
920                 tokensForLiquidity += fees * _fees.buyLiquidityFee / _fees.buyTotalFees;
921                 tokensForMarketing += fees * _fees.buyMarketingFee / _fees.buyTotalFees;
922                 tokensForDevelopment += fees * _fees.buyDevelopmentFee / _fees.buyTotalFees;
923             }
924 
925             if (fees > 0) {
926                 super._transfer(sender, address(this), fees);
927             }
928 
929             amount -= fees;
930 
931         }
932 
933         super._transfer(sender, recipient, amount);
934     }
935 
936     function swapTokensForEth(uint256 tAmount) private {
937 
938         // generate the uniswap pair path of token -> weth
939         address[] memory path = new address[](2);
940         path[0] = address(this);
941         path[1] = router.WETH();
942 
943         _approve(address(this), address(router), tAmount);
944 
945         // make the swap
946         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
947             tAmount,
948             0, // accept any amount of ETH
949             path,
950             address(this),
951             block.timestamp
952         );
953 
954     }
955 
956     function addLiquidity(uint256 tAmount, uint256 ethAmount) private {
957         // approve token transfer to cover all possible scenarios
958         _approve(address(this), address(router), tAmount);
959 
960         // add the liquidity
961         router.addLiquidityETH{ value: ethAmount } (address(this), tAmount, 0, 0 , address(this), block.timestamp);
962     }
963 
964     function swapBack() private {
965         uint256 contractTokenBalance = balanceOf(address(this));
966         uint256 toSwap = tokensForLiquidity + tokensForMarketing + tokensForDevelopment;
967         bool success;
968 
969         if (contractTokenBalance == 0 || toSwap == 0) { return; }
970 
971         if (contractTokenBalance > thresholdSwapAmount * 20) {
972             contractTokenBalance = thresholdSwapAmount * 20;
973         }
974 
975         // Halve the amount of liquidity tokens
976         uint256 liquidityTokens = contractTokenBalance * tokensForLiquidity / toSwap / 2;
977         uint256 amountToSwapForETH = contractTokenBalance.sub(liquidityTokens);
978  
979         uint256 initialETHBalance = address(this).balance;
980 
981         swapTokensForEth(amountToSwapForETH); 
982  
983         uint256 newBalance = address(this).balance.sub(initialETHBalance);
984  
985         uint256 ethForMarketing = newBalance.mul(tokensForMarketing).div(toSwap);
986         uint256 ethForDevelopment = newBalance.mul(tokensForDevelopment).div(toSwap);
987         uint256 ethForLiquidity = newBalance - (ethForMarketing + ethForDevelopment);
988 
989 
990         tokensForLiquidity = 0;
991         tokensForMarketing = 0;
992         tokensForDevelopment = 0;
993 
994 
995         if (liquidityTokens > 0 && ethForLiquidity > 0) {
996             addLiquidity(liquidityTokens, ethForLiquidity);
997             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity);
998         }
999 
1000         (success,) = address(developmentWallet).call{ value: (address(this).balance - ethForMarketing) } ("");
1001         (success,) = address(marketingWallet).call{ value: address(this).balance } ("");
1002     }
1003 
1004 }