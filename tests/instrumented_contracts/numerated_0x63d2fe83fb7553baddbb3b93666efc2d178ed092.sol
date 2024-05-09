1 // SPDX-License-Identifier: MIT
2 
3 //With the Pepe + the Frog tandem, we'll create the unbeatable Pepe the Frog, ruling the meme market, and make MEME GREAT AGAIN!
4 
5 //Twitter: https://twitter.com/thefrog_erc
6 //Telegram: https://t.me/thefrog_erc
7 //Website: https://thefrog.vip
8 
9 
10 pragma solidity 0.8.9;
11  
12 
13 
14 interface IUniswapV2Factory {
15     function createPair(address tokenA, address tokenB) external returns(address pair);
16 }
17 
18 interface IERC20 {
19     /**
20      * @dev Returns the amount of tokens in existence.
21      */
22     function totalSupply() external view returns(uint256);
23 
24     /**
25     * @dev Returns the amount of tokens owned by `account`.
26     */
27     function balanceOf(address account) external view returns(uint256);
28 
29     /**
30     * @dev Moves `amount` tokens from the caller's account to `recipient`.
31     *
32     * Returns a boolean value indicating whether the operation succeeded.
33     *
34     * Emits a {Transfer} event.
35     */
36     function transfer(address recipient, uint256 amount) external returns(bool);
37 
38     /**
39     * @dev Returns the remaining number of tokens that `spender` will be
40     * allowed to spend on behalf of `owner` through {transferFrom}. This is
41     * zero by default.
42     *
43     * This value changes when {approve} or {transferFrom} are called.
44     */
45     function allowance(address owner, address spender) external view returns(uint256);
46 
47     /**
48     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
49     *
50     * Returns a boolean value indicating whether the operation succeeded.
51     *
52     * IMPORTANT: Beware that changing an allowance with this method brings the risk
53     * that someone may use both the old and the new allowance by unfortunate
54     * transaction ordering. One possible solution to mitigate this race
55     * condition is to first reduce the spender's allowance to 0 and set the
56     * desired value afterwards:
57     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
58     *
59     * Emits an {Approval} event.
60     */
61     function approve(address spender, uint256 amount) external returns(bool);
62 
63     /**
64     * @dev Moves `amount` tokens from `sender` to `recipient` using the
65     * allowance mechanism. `amount` is then deducted from the caller's
66     * allowance.
67     *
68     * Returns a boolean value indicating whether the operation succeeded.
69     *
70     * Emits a {Transfer} event.
71     */
72     function transferFrom(
73         address sender,
74         address recipient,
75         uint256 amount
76     ) external returns(bool);
77 
78         /**
79         * @dev Emitted when `value` tokens are moved from one account (`from`) to
80         * another (`to`).
81         *
82         * Note that `value` may be zero.
83         */
84         event Transfer(address indexed from, address indexed to, uint256 value);
85 
86         /**
87         * @dev Emitted when the allowance of a `spender` for an `owner` is set by
88         * a call to {approve}. `value` is the new allowance.
89         */
90         event Approval(address indexed owner, address indexed spender, uint256 value);
91 }
92 
93 interface IERC20Metadata is IERC20 {
94     /**
95      * @dev Returns the name of the token.
96      */
97     function name() external view returns(string memory);
98 
99     /**
100      * @dev Returns the symbol of the token.
101      */
102     function symbol() external view returns(string memory);
103 
104     /**
105      * @dev Returns the decimals places of the token.
106      */
107     function decimals() external view returns(uint8);
108 }
109 
110 abstract contract Context {
111     function _msgSender() internal view virtual returns(address) {
112         return msg.sender;
113     }
114 
115 }
116 
117  
118 contract ERC20 is Context, IERC20, IERC20Metadata {
119     using SafeMath for uint256;
120 
121         mapping(address => uint256) private _balances;
122 
123     mapping(address => mapping(address => uint256)) private _allowances;
124  
125     uint256 private _totalSupply;
126  
127     string private _name;
128     string private _symbol;
129 
130     /**
131      * @dev Sets the values for {name} and {symbol}.
132      *
133      * The default value of {decimals} is 18. To select a different value for
134      * {decimals} you should overload it.
135      *
136      * All two of these values are immutable: they can only be set once during
137      * construction.
138      */
139     constructor(string memory name_, string memory symbol_) {
140         _name = name_;
141         _symbol = symbol_;
142     }
143 
144     /**
145      * @dev Returns the name of the token.
146      */
147     function name() public view virtual override returns(string memory) {
148         return _name;
149     }
150 
151     /**
152      * @dev Returns the symbol of the token, usually a shorter version of the
153      * name.
154      */
155     function symbol() public view virtual override returns(string memory) {
156         return _symbol;
157     }
158 
159     /**
160      * @dev Returns the number of decimals used to get its user representation.
161      * For example, if `decimals` equals `2`, a balance of `505` tokens should
162      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
163      *
164      * Tokens usually opt for a value of 18, imitating the relationship between
165      * Ether and Wei. This is the value {ERC20} uses, unless this function is
166      * overridden;
167      *
168      * NOTE: This information is only used for _display_ purposes: it in
169      * no way affects any of the arithmetic of the contract, including
170      * {IERC20-balanceOf} and {IERC20-transfer}.
171      */
172     function decimals() public view virtual override returns(uint8) {
173         return 18;
174     }
175 
176     /**
177      * @dev See {IERC20-totalSupply}.
178      */
179     function totalSupply() public view virtual override returns(uint256) {
180         return _totalSupply;
181     }
182 
183     /**
184      * @dev See {IERC20-balanceOf}.
185      */
186     function balanceOf(address account) public view virtual override returns(uint256) {
187         return _balances[account];
188     }
189 
190     /**
191      * @dev See {IERC20-transfer}.
192      *
193      * Requirements:
194      *
195      * - `recipient` cannot be the zero address.
196      * - the caller must have a balance of at least `amount`.
197      */
198     function transfer(address recipient, uint256 amount) public virtual override returns(bool) {
199         _transfer(_msgSender(), recipient, amount);
200         return true;
201     }
202 
203     /**
204      * @dev See {IERC20-allowance}.
205      */
206     function allowance(address owner, address spender) public view virtual override returns(uint256) {
207         return _allowances[owner][spender];
208     }
209 
210     /**
211      * @dev See {IERC20-approve}.
212      *
213      * Requirements:
214      *
215      * - `spender` cannot be the zero address.
216      */
217     function approve(address spender, uint256 amount) public virtual override returns(bool) {
218         _approve(_msgSender(), spender, amount);
219         return true;
220     }
221 
222     /**
223      * @dev See {IERC20-transferFrom}.
224      *
225      * Emits an {Approval} event indicating the updated allowance. This is not
226      * required by the EIP. See the note at the beginning of {ERC20}.
227      *
228      * Requirements:
229      *
230      * - `sender` and `recipient` cannot be the zero address.
231      * - `sender` must have a balance of at least `amount`.
232      * - the caller must have allowance for ``sender``'s tokens of at least
233      * `amount`.
234      */
235     function transferFrom(
236         address sender,
237         address recipient,
238         uint256 amount
239     ) public virtual override returns(bool) {
240         _transfer(sender, recipient, amount);
241         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
242         return true;
243     }
244 
245     /**
246      * @dev Atomically increases the allowance granted to `spender` by the caller.
247      *
248      * This is an alternative to {approve} that can be used as a mitigation for
249      * problems described in {IERC20-approve}.
250      *
251      * Emits an {Approval} event indicating the updated allowance.
252      *
253      * Requirements:
254      *
255      * - `spender` cannot be the zero address.
256      */
257     function increaseAllowance(address spender, uint256 addedValue) public virtual returns(bool) {
258         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
259         return true;
260     }
261 
262     /**
263      * @dev Atomically decreases the allowance granted to `spender` by the caller.
264      *
265      * This is an alternative to {approve} that can be used as a mitigation for
266      * problems described in {IERC20-approve}.
267      *
268      * Emits an {Approval} event indicating the updated allowance.
269      *
270      * Requirements:
271      *
272      * - `spender` cannot be the zero address.
273      * - `spender` must have allowance for the caller of at least
274      * `subtractedValue`.
275      */
276     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns(bool) {
277         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased cannot be below zero"));
278         return true;
279     }
280 
281     /**
282      * @dev Moves tokens `amount` from `sender` to `recipient`.
283      *
284      * This is internal function is equivalent to {transfer}, and can be used to
285      * e.g. implement automatic token fees, slashing mechanisms, etc.
286      *
287      * Emits a {Transfer} event.
288      *
289      * Requirements:
290      *
291      * - `sender` cannot be the zero address.
292      * - `recipient` cannot be the zero address.
293      * - `sender` must have a balance of at least `amount`.
294      */
295     function _transfer(
296         address sender,
297         address recipient,
298         uint256 amount
299     ) internal virtual {
300         
301         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
302         _balances[recipient] = _balances[recipient].add(amount);
303         emit Transfer(sender, recipient, amount);
304     }
305 
306     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
307      * the total supply.
308      *
309      * Emits a {Transfer} event with `from` set to the zero address.
310      *
311      * Requirements:
312      *
313      * - `account` cannot be the zero address.
314      */
315     function _mint(address account, uint256 amount) internal virtual {
316         require(account != address(0), "ERC20: mint to the zero address");
317 
318         _totalSupply = _totalSupply.add(amount);
319         _balances[account] = _balances[account].add(amount);
320         emit Transfer(address(0), account, amount);
321     }
322 
323     
324     /**
325      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
326      *
327      * This internal function is equivalent to `approve`, and can be used to
328      * e.g. set automatic allowances for certain subsystems, etc.
329      *
330      * Emits an {Approval} event.
331      *
332      * Requirements:
333      *
334      * - `owner` cannot be the zero address.
335      * - `spender` cannot be the zero address.
336      */
337     function _approve(
338         address owner,
339         address spender,
340         uint256 amount
341     ) internal virtual {
342         _allowances[owner][spender] = amount;
343         emit Approval(owner, spender, amount);
344     }
345 
346     
347 }
348  
349 library SafeMath {
350    
351     function add(uint256 a, uint256 b) internal pure returns(uint256) {
352         uint256 c = a + b;
353         require(c >= a, "SafeMath: addition overflow");
354 
355         return c;
356     }
357 
358    
359     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
360         return sub(a, b, "SafeMath: subtraction overflow");
361     }
362 
363    
364     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns(uint256) {
365         require(b <= a, errorMessage);
366         uint256 c = a - b;
367 
368         return c;
369     }
370 
371     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
372     
373         if (a == 0) {
374             return 0;
375         }
376  
377         uint256 c = a * b;
378         require(c / a == b, "SafeMath: multiplication overflow");
379 
380         return c;
381     }
382 
383  
384     function div(uint256 a, uint256 b) internal pure returns(uint256) {
385         return div(a, b, "SafeMath: division by zero");
386     }
387 
388   
389     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns(uint256) {
390         require(b > 0, errorMessage);
391         uint256 c = a / b;
392         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
393 
394         return c;
395     }
396 
397     
398 }
399  
400 contract Ownable is Context {
401     address private _owner;
402  
403     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
404 
405     /**
406      * @dev Initializes the contract setting the deployer as the initial owner.
407      */
408     constructor() {
409         address msgSender = _msgSender();
410         _owner = msgSender;
411         emit OwnershipTransferred(address(0), msgSender);
412     }
413 
414     /**
415      * @dev Returns the address of the current owner.
416      */
417     function owner() public view returns(address) {
418         return _owner;
419     }
420 
421     /**
422      * @dev Throws if called by any account other than the owner.
423      */
424     modifier onlyOwner() {
425         require(_owner == _msgSender(), "Ownable: caller is not the owner");
426         _;
427     }
428 
429     /**
430      * @dev Leaves the contract without owner. It will not be possible to call
431      * `onlyOwner` functions anymore. Can only be called by the current owner.
432      *
433      * NOTE: Renouncing ownership will leave the contract without an owner,
434      * thereby removing any functionality that is only available to the owner.
435      */
436     function renounceOwnership() public virtual onlyOwner {
437         emit OwnershipTransferred(_owner, address(0));
438         _owner = address(0);
439     }
440 
441     /**
442      * @dev Transfers ownership of the contract to a new account (`newOwner`).
443      * Can only be called by the current owner.
444      */
445     function transferOwnership(address newOwner) public virtual onlyOwner {
446         require(newOwner != address(0), "Ownable: new owner is the zero address");
447         emit OwnershipTransferred(_owner, newOwner);
448         _owner = newOwner;
449     }
450 }
451  
452  
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
522 
523 interface IUniswapV2Router01 {
524     function factory() external pure returns(address);
525     function WETH() external pure returns(address);
526 
527     function addLiquidity(
528         address tokenA,
529         address tokenB,
530         uint amountADesired,
531         uint amountBDesired,
532         uint amountAMin,
533         uint amountBMin,
534         address to,
535         uint deadline
536     ) external returns(uint amountA, uint amountB, uint liquidity);
537     function addLiquidityETH(
538         address token,
539         uint amountTokenDesired,
540         uint amountTokenMin,
541         uint amountETHMin,
542         address to,
543         uint deadline
544     ) external payable returns(uint amountToken, uint amountETH, uint liquidity);
545     function removeLiquidity(
546         address tokenA,
547         address tokenB,
548         uint liquidity,
549         uint amountAMin,
550         uint amountBMin,
551         address to,
552         uint deadline
553     ) external returns(uint amountA, uint amountB);
554     function removeLiquidityETH(
555         address token,
556         uint liquidity,
557         uint amountTokenMin,
558         uint amountETHMin,
559         address to,
560         uint deadline
561     ) external returns(uint amountToken, uint amountETH);
562     function removeLiquidityWithPermit(
563         address tokenA,
564         address tokenB,
565         uint liquidity,
566         uint amountAMin,
567         uint amountBMin,
568         address to,
569         uint deadline,
570         bool approveMax, uint8 v, bytes32 r, bytes32 s
571     ) external returns(uint amountA, uint amountB);
572     function removeLiquidityETHWithPermit(
573         address token,
574         uint liquidity,
575         uint amountTokenMin,
576         uint amountETHMin,
577         address to,
578         uint deadline,
579         bool approveMax, uint8 v, bytes32 r, bytes32 s
580     ) external returns(uint amountToken, uint amountETH);
581     function swapExactTokensForTokens(
582         uint amountIn,
583         uint amountOutMin,
584         address[] calldata path,
585         address to,
586         uint deadline
587     ) external returns(uint[] memory amounts);
588     function swapTokensForExactTokens(
589         uint amountOut,
590         uint amountInMax,
591         address[] calldata path,
592         address to,
593         uint deadline
594     ) external returns(uint[] memory amounts);
595     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
596     external
597     payable
598     returns(uint[] memory amounts);
599     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
600     external
601     returns(uint[] memory amounts);
602     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
603     external
604     returns(uint[] memory amounts);
605     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
606     external
607     payable
608     returns(uint[] memory amounts);
609 
610     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns(uint amountB);
611     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns(uint amountOut);
612     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns(uint amountIn);
613     function getAmountsOut(uint amountIn, address[] calldata path) external view returns(uint[] memory amounts);
614     function getAmountsIn(uint amountOut, address[] calldata path) external view returns(uint[] memory amounts);
615 }
616 
617 interface IUniswapV2Router02 is IUniswapV2Router01 {
618     function removeLiquidityETHSupportingFeeOnTransferTokens(
619         address token,
620         uint liquidity,
621         uint amountTokenMin,
622         uint amountETHMin,
623         address to,
624         uint deadline
625     ) external returns(uint amountETH);
626     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
627         address token,
628         uint liquidity,
629         uint amountTokenMin,
630         uint amountETHMin,
631         address to,
632         uint deadline,
633         bool approveMax, uint8 v, bytes32 r, bytes32 s
634     ) external returns(uint amountETH);
635 
636     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
637         uint amountIn,
638         uint amountOutMin,
639         address[] calldata path,
640         address to,
641         uint deadline
642     ) external;
643     function swapExactETHForTokensSupportingFeeOnTransferTokens(
644         uint amountOutMin,
645         address[] calldata path,
646         address to,
647         uint deadline
648     ) external payable;
649     function swapExactTokensForETHSupportingFeeOnTransferTokens(
650         uint amountIn,
651         uint amountOutMin,
652         address[] calldata path,
653         address to,
654         uint deadline
655     ) external;
656 }
657  
658 contract TheFrog is ERC20, Ownable {
659     using SafeMath for uint256;
660 
661     IUniswapV2Router02 public immutable router;
662     address public immutable uniswapV2Pair;
663 
664 
665     // addresses
666     address public  devWallet;
667     address private marketingWallet;
668 
669     // limits 
670     uint256 private maxBuyAmount;
671     uint256 private maxSellAmount;   
672     uint256 private maxWalletAmount;
673  
674     uint256 private thresholdSwapAmount;
675 
676     // status flags
677     bool private isTrading = false;
678     bool public swapEnabled = false;
679     bool public isSwapping;
680 
681 
682     struct Fees {
683         uint8 buyTotalFees;
684         uint8 buyMarketingFee;
685         uint8 buyDevFee;
686         uint8 buyLiquidityFee;
687 
688         uint8 sellTotalFees;
689         uint8 sellMarketingFee;
690         uint8 sellDevFee;
691         uint8 sellLiquidityFee;
692     }  
693 
694     Fees public _fees = Fees({
695         buyTotalFees: 0,
696         buyMarketingFee: 0,
697         buyDevFee:0,
698         buyLiquidityFee: 0,
699 
700         sellTotalFees: 0,
701         sellMarketingFee: 0,
702         sellDevFee:0,
703         sellLiquidityFee: 0
704     });
705     
706     
707 
708     uint256 public tokensForMarketing;
709     uint256 public tokensForLiquidity;
710     uint256 public tokensForDev;
711     uint256 private taxTill;
712     // exclude from fees and max transaction amount
713     mapping(address => bool) private _isExcludedFromFees;
714     mapping(address => bool) public _isExcludedMaxTransactionAmount;
715     mapping(address => bool) public _isExcludedMaxWalletAmount;
716 
717     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
718     // could be subject to a maximum transfer amount
719     mapping(address => bool) public marketPair;
720     mapping(address => bool) public _isBlacklisted;
721  
722   
723     event SwapAndLiquify(
724         uint256 tokensSwapped,
725         uint256 ethReceived
726     );
727 
728 
729     constructor() ERC20("The Frog", "FROG") {
730  
731         router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
732 
733 
734         uniswapV2Pair = IUniswapV2Factory(router.factory()).createPair(address(this), router.WETH());
735 
736         _isExcludedMaxTransactionAmount[address(router)] = true;
737         _isExcludedMaxTransactionAmount[address(uniswapV2Pair)] = true;        
738         _isExcludedMaxTransactionAmount[owner()] = true;
739         _isExcludedMaxTransactionAmount[address(this)] = true;
740 
741         _isExcludedFromFees[owner()] = true;
742         _isExcludedFromFees[address(this)] = true;
743 
744         _isExcludedMaxWalletAmount[owner()] = true;
745         _isExcludedMaxWalletAmount[address(this)] = true;
746         _isExcludedMaxWalletAmount[address(uniswapV2Pair)] = true;
747 
748 
749         marketPair[address(uniswapV2Pair)] = true;
750 
751         approve(address(router), type(uint256).max);
752         uint256 totalSupply = 1e6 * 1e18;
753 
754         maxBuyAmount = totalSupply * 2 / 100; // 2% maxTransactionAmountTxn
755         maxSellAmount = totalSupply * 2 / 100; // 2% maxTransactionAmountTxn
756         maxWalletAmount = totalSupply * 2 / 100; // 2% maxWallet
757         thresholdSwapAmount = totalSupply * 1 / 10000; // 0.01% swap wallet
758 
759         _fees.buyMarketingFee = 2;
760         _fees.buyLiquidityFee = 1;
761         _fees.buyDevFee = 2;
762         _fees.buyTotalFees = _fees.buyMarketingFee + _fees.buyLiquidityFee + _fees.buyDevFee;
763 
764         _fees.sellMarketingFee = 2;
765         _fees.sellLiquidityFee = 1;
766         _fees.sellDevFee = 2;
767         _fees.sellTotalFees = _fees.sellMarketingFee + _fees.sellLiquidityFee + _fees.sellDevFee;
768 
769 
770         marketingWallet = address(0xf0A612a7F429Bb549535d77F96A8016eF6B6d997);
771         devWallet = address(0xfbfEaF0DA0F2fdE5c66dF570133aE35f3eB58c9A);
772 
773         // exclude from paying fees or having max transaction amount
774 
775         /*
776             _mint is an internal function in ERC20.sol that is only called here,
777             and CANNOT be called ever again
778         */
779         _mint(msg.sender, totalSupply);
780     }
781 
782     receive() external payable {
783 
784     }
785 
786     // once enabled, can never be turned off
787     function swapTrading() external onlyOwner {
788         isTrading = true;
789         swapEnabled = true;
790         taxTill = block.number + 2;
791     }
792 
793 
794 
795     // change the minimum amount of tokens to sell from fees
796     function updateThresholdSwapAmount(uint256 newAmount) external onlyOwner returns(bool){
797         thresholdSwapAmount = newAmount;
798         return true;
799     }
800 
801 
802     function updateMaxTxnAmount(uint256 newMaxBuy, uint256 newMaxSell) external onlyOwner {
803         require(((totalSupply() * newMaxBuy) / 1000) >= (totalSupply() / 100), "maxBuyAmount must be higher than 1%");
804         require(((totalSupply() * newMaxSell) / 1000) >= (totalSupply() / 100), "maxSellAmount must be higher than 1%");
805         maxBuyAmount = (totalSupply() * newMaxBuy) / 1000;
806         maxSellAmount = (totalSupply() * newMaxSell) / 1000;
807     }
808 
809 
810     function updateMaxWalletAmount(uint256 newPercentage) external onlyOwner {
811         require(((totalSupply() * newPercentage) / 1000) >= (totalSupply() / 100), "Cannot set maxWallet lower than 1%");
812         maxWalletAmount = (totalSupply() * newPercentage) / 1000;
813     }
814 
815     // only use to disable contract sales if absolutely necessary (emergency use only)
816     function toggleSwapEnabled(bool enabled) external onlyOwner(){
817         swapEnabled = enabled;
818     }
819 
820       function blacklistAddress(address account, bool value) external onlyOwner{
821         _isBlacklisted[account] = value;
822     }
823 
824     function updateFees(uint8 _marketingFeeBuy, uint8 _liquidityFeeBuy,uint8 _devFeeBuy,uint8 _marketingFeeSell, uint8 _liquidityFeeSell,uint8 _devFeeSell) external onlyOwner{
825         _fees.buyMarketingFee = _marketingFeeBuy;
826         _fees.buyLiquidityFee = _liquidityFeeBuy;
827         _fees.buyDevFee = _devFeeBuy;
828         _fees.buyTotalFees = _fees.buyMarketingFee + _fees.buyLiquidityFee + _fees.buyDevFee;
829 
830         _fees.sellMarketingFee = _marketingFeeSell;
831         _fees.sellLiquidityFee = _liquidityFeeSell;
832         _fees.sellDevFee = _devFeeSell;
833         _fees.sellTotalFees = _fees.sellMarketingFee + _fees.sellLiquidityFee + _fees.sellDevFee;
834         require(_fees.buyTotalFees <= 30, "Must keep fees at 30% or less");   
835         require(_fees.sellTotalFees <= 30, "Must keep fees at 30% or less");
836      
837     }
838     
839     function excludeFromFees(address account, bool excluded) public onlyOwner {
840         _isExcludedFromFees[account] = excluded;
841     }
842     function excludeFromWalletLimit(address account, bool excluded) public onlyOwner {
843         _isExcludedMaxWalletAmount[account] = excluded;
844     }
845     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
846         _isExcludedMaxTransactionAmount[updAds] = isEx;
847     }
848 
849 
850     function setMarketPair(address pair, bool value) public onlyOwner {
851         require(pair != uniswapV2Pair, "Must keep uniswapV2Pair");
852         marketPair[pair] = value;
853     }
854 
855 
856     function setWallets(address _marketingWallet,address _devWallet) external onlyOwner{
857         marketingWallet = _marketingWallet;
858         devWallet = _devWallet;
859     }
860 
861     function isExcludedFromFees(address account) public view returns(bool) {
862         return _isExcludedFromFees[account];
863     }
864 
865     function _transfer(
866         address sender,
867         address recipient,
868         uint256 amount
869         
870     ) internal override {
871         
872         if (amount == 0) {
873             super._transfer(sender, recipient, 0);
874             return;
875         }
876 
877         if (
878             sender != owner() &&
879             recipient != owner() &&
880             !isSwapping
881         ) {
882 
883             if (!isTrading) {
884                 require(_isExcludedFromFees[sender] || _isExcludedFromFees[recipient], "Trading is not active.");
885             }
886             if (marketPair[sender] && !_isExcludedMaxTransactionAmount[recipient]) {
887                 require(amount <= maxBuyAmount, "buy transfer over max amount");
888             } 
889             else if (marketPair[recipient] && !_isExcludedMaxTransactionAmount[sender]) {
890                 require(amount <= maxSellAmount, "Sell transfer over max amount");
891             }
892 
893             if (!_isExcludedMaxWalletAmount[recipient]) {
894                 require(amount + balanceOf(recipient) <= maxWalletAmount, "Max wallet exceeded");
895             }
896            require(!_isBlacklisted[sender] && !_isBlacklisted[recipient], "Blacklisted address");
897         }
898  
899         
900  
901         uint256 contractTokenBalance = balanceOf(address(this));
902  
903         bool canSwap = contractTokenBalance >= thresholdSwapAmount;
904 
905         if (
906             canSwap &&
907             swapEnabled &&
908             !isSwapping &&
909             marketPair[recipient] &&
910             !_isExcludedFromFees[sender] &&
911             !_isExcludedFromFees[recipient]
912         ) {
913             isSwapping = true;
914             swapBack();
915             isSwapping = false;
916         }
917  
918         bool takeFee = !isSwapping;
919 
920         // if any account belongs to _isExcludedFromFee account then remove the fee
921         if (_isExcludedFromFees[sender] || _isExcludedFromFees[recipient]) {
922             takeFee = false;
923         }
924  
925         
926         // only take fees on buys/sells, do not take on wallet transfers
927         if (takeFee) {
928             uint256 fees = 0;
929             if(block.number < taxTill) {
930                 fees = amount.mul(99).div(100);
931                 tokensForMarketing += (fees * 94) / 99;
932                 tokensForDev += (fees * 5) / 99;
933             } else if (marketPair[recipient] && _fees.sellTotalFees > 0) {
934                 fees = amount.mul(_fees.sellTotalFees).div(100);
935                 tokensForLiquidity += fees * _fees.sellLiquidityFee / _fees.sellTotalFees;
936                 tokensForMarketing += fees * _fees.sellMarketingFee / _fees.sellTotalFees;
937                 tokensForDev += fees * _fees.sellDevFee / _fees.sellTotalFees;
938             }
939             // on buy
940             else if (marketPair[sender] && _fees.buyTotalFees > 0) {
941                 fees = amount.mul(_fees.buyTotalFees).div(100);
942                 tokensForLiquidity += fees * _fees.buyLiquidityFee / _fees.buyTotalFees;
943                 tokensForMarketing += fees * _fees.buyMarketingFee / _fees.buyTotalFees;
944                 tokensForDev += fees * _fees.buyDevFee / _fees.buyTotalFees;
945             }
946 
947             if (fees > 0) {
948                 super._transfer(sender, address(this), fees);
949             }
950 
951             amount -= fees;
952 
953         }
954 
955         super._transfer(sender, recipient, amount);
956     }
957 
958     function swapTokensForEth(uint256 tAmount) private {
959 
960         // generate the uniswap pair path of token -> weth
961         address[] memory path = new address[](2);
962         path[0] = address(this);
963         path[1] = router.WETH();
964 
965         _approve(address(this), address(router), tAmount);
966 
967         // make the swap
968         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
969             tAmount,
970             0, // accept any amount of ETH
971             path,
972             address(this),
973             block.timestamp
974         );
975 
976     }
977 
978     function addLiquidity(uint256 tAmount, uint256 ethAmount) private {
979         // approve token transfer to cover all possible scenarios
980         _approve(address(this), address(router), tAmount);
981 
982         // add the liquidity
983         router.addLiquidityETH{ value: ethAmount } (address(this), tAmount, 0, 0 , address(this), block.timestamp);
984     }
985 
986     function swapBack() private {
987         uint256 contractTokenBalance = balanceOf(address(this));
988         uint256 toSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
989         bool success;
990 
991         if (contractTokenBalance == 0 || toSwap == 0) { return; }
992 
993         if (contractTokenBalance > thresholdSwapAmount * 20) {
994             contractTokenBalance = thresholdSwapAmount * 20;
995         }
996 
997         // Halve the amount of liquidity tokens
998         uint256 liquidityTokens = contractTokenBalance * tokensForLiquidity / toSwap / 2;
999         uint256 amountToSwapForETH = contractTokenBalance.sub(liquidityTokens);
1000  
1001         uint256 initialETHBalance = address(this).balance;
1002 
1003         swapTokensForEth(amountToSwapForETH); 
1004  
1005         uint256 newBalance = address(this).balance.sub(initialETHBalance);
1006  
1007         uint256 ethForMarketing = newBalance.mul(tokensForMarketing).div(toSwap);
1008         uint256 ethForDev = newBalance.mul(tokensForDev).div(toSwap);
1009         uint256 ethForLiquidity = newBalance - (ethForMarketing + ethForDev);
1010 
1011 
1012         tokensForLiquidity = 0;
1013         tokensForMarketing = 0;
1014         tokensForDev = 0;
1015 
1016 
1017         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1018             addLiquidity(liquidityTokens, ethForLiquidity);
1019             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity);
1020         }
1021 
1022         (success,) = address(devWallet).call{ value: (address(this).balance - ethForMarketing) } ("");
1023         (success,) = address(marketingWallet).call{ value: address(this).balance } ("");
1024     }
1025 
1026 }