1 //Kona Community: https://t.me/KonaInuPortal
2   
3   // Elon Tweet: https://twitter.com/heydave7/status/1637544628944601092
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2023-03-06
7 */
8 
9 // SPDX-License-Identifier: MIT
10 pragma solidity 0.8.9;
11 
12 interface IUniswapV2Factory {
13     function createPair(address tokenA, address tokenB) external returns(address pair);
14 }
15 
16 interface IERC20 {
17     /**
18      * @dev Returns the amount of tokens in existence.
19      */
20     function totalSupply() external view returns(uint256);
21 
22     /**
23     * @dev Returns the amount of tokens owned by `account`.
24     */
25     function balanceOf(address account) external view returns(uint256);
26 
27     /**
28     * @dev Moves `amount` tokens from the caller's account to `recipient`.
29     *
30     * Returns a boolean value indicating whether the operation succeeded.
31     *
32     * Emits a {Transfer} event.
33     */
34     function transfer(address recipient, uint256 amount) external returns(bool);
35 
36     /**
37     * @dev Returns the remaining number of tokens that `spender` will be
38     * allowed to spend on behalf of `owner` through {transferFrom}. This is
39     * zero by default.
40     *
41     * This value changes when {approve} or {transferFrom} are called.
42     */
43     function allowance(address owner, address spender) external view returns(uint256);
44 
45     /**
46     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
47     *
48     * Returns a boolean value indicating whether the operation succeeded.
49     *
50     * IMPORTANT: Beware that changing an allowance with this method brings the risk
51     * that someone may use both the old and the new allowance by unfortunate
52     * transaction ordering. One possible solution to mitigate this race
53     * condition is to first reduce the spender's allowance to 0 and set the
54     * desired value afterwards:
55     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
56     *
57     * Emits an {Approval} event.
58     */
59     function approve(address spender, uint256 amount) external returns(bool);
60 
61     /**
62     * @dev Moves `amount` tokens from `sender` to `recipient` using the
63     * allowance mechanism. `amount` is then deducted from the caller's
64     * allowance.
65     *
66     * Returns a boolean value indicating whether the operation succeeded.
67     *
68     * Emits a {Transfer} event.
69     */
70     function transferFrom(
71         address sender,
72         address recipient,
73         uint256 amount
74     ) external returns(bool);
75 
76         /**
77         * @dev Emitted when `value` tokens are moved from one account (`from`) to
78         * another (`to`).
79         *
80         * Note that `value` may be zero.
81         */
82         event Transfer(address indexed from, address indexed to, uint256 value);
83 
84         /**
85         * @dev Emitted when the allowance of a `spender` for an `owner` is set by
86         * a call to {approve}. `value` is the new allowance.
87         */
88         event Approval(address indexed owner, address indexed spender, uint256 value);
89 }
90 
91 interface IERC20Metadata is IERC20 {
92     /**
93      * @dev Returns the name of the token.
94      */
95     function name() external view returns(string memory);
96 
97     /**
98      * @dev Returns the symbol of the token.
99      */
100     function symbol() external view returns(string memory);
101 
102     /**
103      * @dev Returns the decimals places of the token.
104      */
105     function decimals() external view returns(uint8);
106 }
107 
108 abstract contract Context {
109     function _msgSender() internal view virtual returns(address) {
110         return msg.sender;
111     }
112 
113 }
114 
115 contract ERC20 is Context, IERC20, IERC20Metadata {
116     using SafeMath for uint256;
117 
118         mapping(address => uint256) private _balances;
119 
120     mapping(address => mapping(address => uint256)) private _allowances;
121  
122     uint256 private _totalSupply;
123  
124     string private _name;
125     string private _symbol;
126 
127     /**
128      * @dev Sets the values for {name} and {symbol}.
129      *
130      * The default value of {decimals} is 18. To select a different value for
131      * {decimals} you should overload it.
132      *
133      * All two of these values are immutable: they can only be set once during
134      * construction.
135      */
136     constructor(string memory name_, string memory symbol_) {
137         _name = name_;
138         _symbol = symbol_;
139     }
140 
141     /**
142      * @dev Returns the name of the token.
143      */
144     function name() public view virtual override returns(string memory) {
145         return _name;
146     }
147 
148     /**
149      * @dev Returns the symbol of the token, usually a shorter version of the
150      * name.
151      */
152     function symbol() public view virtual override returns(string memory) {
153         return _symbol;
154     }
155 
156     /**
157      * @dev Returns the number of decimals used to get its user representation.
158      * For example, if `decimals` equals `2`, a balance of `505` tokens should
159      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
160      *
161      * Tokens usually opt for a value of 18, imitating the relationship between
162      * Ether and Wei. This is the value {ERC20} uses, unless this function is
163      * overridden;
164      *
165      * NOTE: This information is only used for _display_ purposes: it in
166      * no way affects any of the arithmetic of the contract, including
167      * {IERC20-balanceOf} and {IERC20-transfer}.
168      */
169     function decimals() public view virtual override returns(uint8) {
170         return 18;
171     }
172 
173     /**
174      * @dev See {IERC20-totalSupply}.
175      */
176     function totalSupply() public view virtual override returns(uint256) {
177         return _totalSupply;
178     }
179 
180     /**
181      * @dev See {IERC20-balanceOf}.
182      */
183     function balanceOf(address account) public view virtual override returns(uint256) {
184         return _balances[account];
185     }
186 
187     /**
188      * @dev See {IERC20-transfer}.
189      *
190      * Requirements:
191      *
192      * - `recipient` cannot be the zero address.
193      * - the caller must have a balance of at least `amount`.
194      */
195     function transfer(address recipient, uint256 amount) public virtual override returns(bool) {
196         _transfer(_msgSender(), recipient, amount);
197         return true;
198     }
199 
200     /**
201      * @dev See {IERC20-allowance}.
202      */
203     function allowance(address owner, address spender) public view virtual override returns(uint256) {
204         return _allowances[owner][spender];
205     }
206 
207     /**
208      * @dev See {IERC20-approve}.
209      *
210      * Requirements:
211      *
212      * - `spender` cannot be the zero address.
213      */
214     function approve(address spender, uint256 amount) public virtual override returns(bool) {
215         _approve(_msgSender(), spender, amount);
216         return true;
217     }
218 
219     /**
220      * @dev See {IERC20-transferFrom}.
221      *
222      * Emits an {Approval} event indicating the updated allowance. This is not
223      * required by the EIP. See the note at the beginning of {ERC20}.
224      *
225      * Requirements:
226      *
227      * - `sender` and `recipient` cannot be the zero address.
228      * - `sender` must have a balance of at least `amount`.
229      * - the caller must have allowance for ``sender``'s tokens of at least
230      * `amount`.
231      */
232     function transferFrom(
233         address sender,
234         address recipient,
235         uint256 amount
236     ) public virtual override returns(bool) {
237         _transfer(sender, recipient, amount);
238         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
239         return true;
240     }
241 
242     /**
243      * @dev Atomically increases the allowance granted to `spender` by the caller.
244      *
245      * This is an alternative to {approve} that can be used as a mitigation for
246      * problems described in {IERC20-approve}.
247      *
248      * Emits an {Approval} event indicating the updated allowance.
249      *
250      * Requirements:
251      *
252      * - `spender` cannot be the zero address.
253      */
254     function increaseAllowance(address spender, uint256 addedValue) public virtual returns(bool) {
255         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
256         return true;
257     }
258 
259     /**
260      * @dev Atomically decreases the allowance granted to `spender` by the caller.
261      *
262      * This is an alternative to {approve} that can be used as a mitigation for
263      * problems described in {IERC20-approve}.
264      *
265      * Emits an {Approval} event indicating the updated allowance.
266      *
267      * Requirements:
268      *
269      * - `spender` cannot be the zero address.
270      * - `spender` must have allowance for the caller of at least
271      * `subtractedValue`.
272      */
273     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns(bool) {
274         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased cannot be below zero"));
275         return true;
276     }
277 
278     /**
279      * @dev Moves tokens `amount` from `sender` to `recipient`.
280      *
281      * This is internal function is equivalent to {transfer}, and can be used to
282      * e.g. implement automatic token fees, slashing mechanisms, etc.
283      *
284      * Emits a {Transfer} event.
285      *
286      * Requirements:
287      *
288      * - `sender` cannot be the zero address.
289      * - `recipient` cannot be the zero address.
290      * - `sender` must have a balance of at least `amount`.
291      */
292     function _transfer(
293         address sender,
294         address recipient,
295         uint256 amount
296     ) internal virtual {
297         
298         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
299         _balances[recipient] = _balances[recipient].add(amount);
300         emit Transfer(sender, recipient, amount);
301     }
302 
303     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
304      * the total supply.
305      *
306      * Emits a {Transfer} event with `from` set to the zero address.
307      *
308      * Requirements:
309      *
310      * - `account` cannot be the zero address.
311      */
312     function _mint(address account, uint256 amount) internal virtual {
313         require(account != address(0), "ERC20: mint to the zero address");
314 
315         _totalSupply = _totalSupply.add(amount);
316         _balances[account] = _balances[account].add(amount);
317         emit Transfer(address(0), account, amount);
318     }
319 
320     
321     /**
322      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
323      *
324      * This internal function is equivalent to `approve`, and can be used to
325      * e.g. set automatic allowances for certain subsystems, etc.
326      *
327      * Emits an {Approval} event.
328      *
329      * Requirements:
330      *
331      * - `owner` cannot be the zero address.
332      * - `spender` cannot be the zero address.
333      */
334     function _approve(
335         address owner,
336         address spender,
337         uint256 amount
338     ) internal virtual {
339         _allowances[owner][spender] = amount;
340         emit Approval(owner, spender, amount);
341     }
342 
343     
344 }
345  
346 library SafeMath {
347    
348     function add(uint256 a, uint256 b) internal pure returns(uint256) {
349         uint256 c = a + b;
350         require(c >= a, "SafeMath: addition overflow");
351 
352         return c;
353     }
354 
355    
356     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
357         return sub(a, b, "SafeMath: subtraction overflow");
358     }
359 
360    
361     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns(uint256) {
362         require(b <= a, errorMessage);
363         uint256 c = a - b;
364 
365         return c;
366     }
367 
368     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
369     
370         if (a == 0) {
371             return 0;
372         }
373  
374         uint256 c = a * b;
375         require(c / a == b, "SafeMath: multiplication overflow");
376 
377         return c;
378     }
379 
380  
381     function div(uint256 a, uint256 b) internal pure returns(uint256) {
382         return div(a, b, "SafeMath: division by zero");
383     }
384 
385   
386     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns(uint256) {
387         require(b > 0, errorMessage);
388         uint256 c = a / b;
389         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
390 
391         return c;
392     }
393 
394     
395 }
396  
397 contract Ownable is Context {
398     address private _owner;
399  
400     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
401 
402     /**
403      * @dev Initializes the contract setting the deployer as the initial owner.
404      */
405     constructor() {
406         address msgSender = _msgSender();
407         _owner = msgSender;
408         emit OwnershipTransferred(address(0), msgSender);
409     }
410 
411     /**
412      * @dev Returns the address of the current owner.
413      */
414     function owner() public view returns(address) {
415         return _owner;
416     }
417 
418     /**
419      * @dev Throws if called by any account other than the owner.
420      */
421     modifier onlyOwner() {
422         require(_owner == _msgSender(), "Ownable: caller is not the owner");
423         _;
424     }
425 
426     /**
427      * @dev Leaves the contract without owner. It will not be possible to call
428      * `onlyOwner` functions anymore. Can only be called by the current owner.
429      *
430      * NOTE: Renouncing ownership will leave the contract without an owner,
431      * thereby removing any functionality that is only available to the owner.
432      */
433     function renounceOwnership() public virtual onlyOwner {
434         emit OwnershipTransferred(_owner, address(0));
435         _owner = address(0);
436     }
437 
438     /**
439      * @dev Transfers ownership of the contract to a new account (`newOwner`).
440      * Can only be called by the current owner.
441      */
442     function transferOwnership(address newOwner) public virtual onlyOwner {
443         require(newOwner != address(0), "Ownable: new owner is the zero address");
444         emit OwnershipTransferred(_owner, newOwner);
445         _owner = newOwner;
446     }
447 }
448  
449 library SafeMathInt {
450     int256 private constant MIN_INT256 = int256(1) << 255;
451     int256 private constant MAX_INT256 = ~(int256(1) << 255);
452 
453     /**
454      * @dev Multiplies two int256 variables and fails on overflow.
455      */
456     function mul(int256 a, int256 b) internal pure returns(int256) {
457         int256 c = a * b;
458 
459         // Detect overflow when multiplying MIN_INT256 with -1
460         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
461         require((b == 0) || (c / b == a));
462         return c;
463     }
464 
465     /**
466      * @dev Division of two int256 variables and fails on overflow.
467      */
468     function div(int256 a, int256 b) internal pure returns(int256) {
469         // Prevent overflow when dividing MIN_INT256 by -1
470         require(b != -1 || a != MIN_INT256);
471 
472         // Solidity already throws when dividing by 0.
473         return a / b;
474     }
475 
476     /**
477      * @dev Subtracts two int256 variables and fails on overflow.
478      */
479     function sub(int256 a, int256 b) internal pure returns(int256) {
480         int256 c = a - b;
481         require((b >= 0 && c <= a) || (b < 0 && c > a));
482         return c;
483     }
484 
485     /**
486      * @dev Adds two int256 variables and fails on overflow.
487      */
488     function add(int256 a, int256 b) internal pure returns(int256) {
489         int256 c = a + b;
490         require((b >= 0 && c >= a) || (b < 0 && c < a));
491         return c;
492     }
493 
494     /**
495      * @dev Converts to absolute value, and fails on overflow.
496      */
497     function abs(int256 a) internal pure returns(int256) {
498         require(a != MIN_INT256);
499         return a < 0 ? -a : a;
500     }
501 
502 
503     function toUint256Safe(int256 a) internal pure returns(uint256) {
504         require(a >= 0);
505         return uint256(a);
506     }
507 }
508  
509 library SafeMathUint {
510     function toInt256Safe(uint256 a) internal pure returns(int256) {
511     int256 b = int256(a);
512         require(b >= 0);
513         return b;
514     }
515 }
516 
517 interface IUniswapV2Router01 {
518     function factory() external pure returns(address);
519     function WETH() external pure returns(address);
520 
521     function addLiquidity(
522         address tokenA,
523         address tokenB,
524         uint amountADesired,
525         uint amountBDesired,
526         uint amountAMin,
527         uint amountBMin,
528         address to,
529         uint deadline
530     ) external returns(uint amountA, uint amountB, uint liquidity);
531     function addLiquidityETH(
532         address token,
533         uint amountTokenDesired,
534         uint amountTokenMin,
535         uint amountETHMin,
536         address to,
537         uint deadline
538     ) external payable returns(uint amountToken, uint amountETH, uint liquidity);
539     function removeLiquidity(
540         address tokenA,
541         address tokenB,
542         uint liquidity,
543         uint amountAMin,
544         uint amountBMin,
545         address to,
546         uint deadline
547     ) external returns(uint amountA, uint amountB);
548     function removeLiquidityETH(
549         address token,
550         uint liquidity,
551         uint amountTokenMin,
552         uint amountETHMin,
553         address to,
554         uint deadline
555     ) external returns(uint amountToken, uint amountETH);
556     function removeLiquidityWithPermit(
557         address tokenA,
558         address tokenB,
559         uint liquidity,
560         uint amountAMin,
561         uint amountBMin,
562         address to,
563         uint deadline,
564         bool approveMax, uint8 v, bytes32 r, bytes32 s
565     ) external returns(uint amountA, uint amountB);
566     function removeLiquidityETHWithPermit(
567         address token,
568         uint liquidity,
569         uint amountTokenMin,
570         uint amountETHMin,
571         address to,
572         uint deadline,
573         bool approveMax, uint8 v, bytes32 r, bytes32 s
574     ) external returns(uint amountToken, uint amountETH);
575     function swapExactTokensForTokens(
576         uint amountIn,
577         uint amountOutMin,
578         address[] calldata path,
579         address to,
580         uint deadline
581     ) external returns(uint[] memory amounts);
582     function swapTokensForExactTokens(
583         uint amountOut,
584         uint amountInMax,
585         address[] calldata path,
586         address to,
587         uint deadline
588     ) external returns(uint[] memory amounts);
589     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
590     external
591     payable
592     returns(uint[] memory amounts);
593     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
594     external
595     returns(uint[] memory amounts);
596     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
597     external
598     returns(uint[] memory amounts);
599     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
600     external
601     payable
602     returns(uint[] memory amounts);
603 
604     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns(uint amountB);
605     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns(uint amountOut);
606     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns(uint amountIn);
607     function getAmountsOut(uint amountIn, address[] calldata path) external view returns(uint[] memory amounts);
608     function getAmountsIn(uint amountOut, address[] calldata path) external view returns(uint[] memory amounts);
609 }
610 
611 interface IUniswapV2Router02 is IUniswapV2Router01 {
612     function removeLiquidityETHSupportingFeeOnTransferTokens(
613         address token,
614         uint liquidity,
615         uint amountTokenMin,
616         uint amountETHMin,
617         address to,
618         uint deadline
619     ) external returns(uint amountETH);
620     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
621         address token,
622         uint liquidity,
623         uint amountTokenMin,
624         uint amountETHMin,
625         address to,
626         uint deadline,
627         bool approveMax, uint8 v, bytes32 r, bytes32 s
628     ) external returns(uint amountETH);
629 
630     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
631         uint amountIn,
632         uint amountOutMin,
633         address[] calldata path,
634         address to,
635         uint deadline
636     ) external;
637     function swapExactETHForTokensSupportingFeeOnTransferTokens(
638         uint amountOutMin,
639         address[] calldata path,
640         address to,
641         uint deadline
642     ) external payable;
643     function swapExactTokensForETHSupportingFeeOnTransferTokens(
644         uint amountIn,
645         uint amountOutMin,
646         address[] calldata path,
647         address to,
648         uint deadline
649     ) external;
650 }
651  
652 contract KONAINU is ERC20, Ownable {
653     using SafeMath for uint256;
654 
655     IUniswapV2Router02 public immutable router;
656     address public immutable uniswapV2Pair;
657 
658     // addresses
659     address private developmentWallet;
660     address private marketingWallet;
661 
662     // limits 
663     uint256 private maxBuyAmount;
664     uint256 private maxSellAmount;   
665     uint256 private maxWalletAmount;
666  
667     uint256 private thresholdSwapAmount;
668 
669     // status flags
670     bool private isTrading = false;
671     bool public swapEnabled = false;
672     bool public isSwapping;
673 
674     struct Fees {
675         uint256 buyTotalFees;
676         uint256 buyMarketingFee;
677         uint256 buyDevelopmentFee;
678         uint256 buyLiquidityFee;
679 
680         uint256 sellTotalFees;
681         uint256 sellMarketingFee;
682         uint256 sellDevelopmentFee;
683         uint256 sellLiquidityFee;
684     }  
685 
686     Fees public _fees = Fees({
687         buyTotalFees: 0,
688         buyMarketingFee: 0,
689         buyDevelopmentFee:0,
690         buyLiquidityFee: 0,
691 
692         sellTotalFees: 0,
693         sellMarketingFee: 0,
694         sellDevelopmentFee:0,
695         sellLiquidityFee: 0
696     });
697 
698     uint256 public tokensForMarketing;
699     uint256 public tokensForLiquidity;
700     uint256 public tokensForDevelopment;
701     uint256 private taxTill;
702 
703     // exclude from fees and max transaction amount
704     mapping(address => bool) private _isExcludedFromFees;
705     mapping(address => bool) public _isExcludedMaxTransactionAmount;
706     mapping(address => bool) public _isExcludedMaxWalletAmount;
707 
708     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
709     // could be subject to a maximum transfer amount
710     mapping(address => bool) public marketPair;
711  
712   
713     event SwapAndLiquify(
714         uint256 tokensSwapped,
715         uint256 ethReceived
716     );
717 
718     constructor() ERC20("Kona Inu", "KONA") {
719  
720         router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
721 
722         uniswapV2Pair = IUniswapV2Factory(router.factory()).createPair(address(this), router.WETH());
723 
724         _isExcludedMaxTransactionAmount[address(router)] = true;
725         _isExcludedMaxTransactionAmount[address(uniswapV2Pair)] = true;        
726         _isExcludedMaxTransactionAmount[owner()] = true;
727         _isExcludedMaxTransactionAmount[address(this)] = true;
728         _isExcludedMaxTransactionAmount[address(0xdead)] = true;
729 
730         _isExcludedFromFees[owner()] = true;
731         _isExcludedFromFees[address(this)] = true;
732 
733         _isExcludedMaxWalletAmount[owner()] = true;
734         _isExcludedMaxWalletAmount[address(0xdead)] = true;
735         _isExcludedMaxWalletAmount[address(this)] = true;
736         _isExcludedMaxWalletAmount[address(uniswapV2Pair)] = true;
737 
738         marketPair[address(uniswapV2Pair)] = true;
739 
740         approve(address(router), type(uint256).max);
741 
742         uint256 totalSupply = 1e9 * 1e18;
743         maxBuyAmount = totalSupply * 2 / 100; // 2% maxBuyAmount
744         maxSellAmount = totalSupply * 2 / 100; // 2% maxSellAmount
745         maxWalletAmount = totalSupply * 2 / 100; // 2% maxWallet
746         thresholdSwapAmount = totalSupply * 1 / 1000; 
747 
748         _fees.buyMarketingFee = 40;
749         _fees.buyLiquidityFee = 0;
750         _fees.buyDevelopmentFee = 0;
751         _fees.buyTotalFees = _fees.buyMarketingFee + _fees.buyLiquidityFee + _fees.buyDevelopmentFee;
752 
753         _fees.sellMarketingFee = 40;
754         _fees.sellLiquidityFee = 0;
755         _fees.sellDevelopmentFee = 0;
756         _fees.sellTotalFees = _fees.sellMarketingFee + _fees.sellLiquidityFee + _fees.sellDevelopmentFee;
757 
758         marketingWallet = address(0xE7609B3e408BeE6D6c78F1841793277Ac2ABe8a9);
759         developmentWallet = address(0xE7609B3e408BeE6D6c78F1841793277Ac2ABe8a9);
760 
761         // exclude from paying fees or having max transaction amount
762 
763         /*
764             _mint is an internal function in ERC20.sol that is only called here,
765             and CANNOT be called ever again
766         */
767         _mint(msg.sender, totalSupply);
768     }
769 
770     receive() external payable {
771 
772     }
773 
774     // once enabled, can never be turned off
775     function enableTrading() external onlyOwner {
776         isTrading = true;
777         swapEnabled = true;
778         taxTill = block.number + 0;
779     }
780 
781     // change the minimum amount of tokens to sell from fees
782     function updateThresholdSwapAmount(uint256 newAmount) external onlyOwner returns(bool){
783         thresholdSwapAmount = newAmount;
784         return true;
785     }
786 
787     function updateMaxTxnAmount(uint256 newMaxBuy, uint256 newMaxSell) public onlyOwner {
788         maxBuyAmount = (totalSupply() * newMaxBuy) / 1000;
789         maxSellAmount = (totalSupply() * newMaxSell) / 1000;
790     }
791 
792     function updateMaxWalletAmount(uint256 newPercentage) public onlyOwner {
793         maxWalletAmount = (totalSupply() * newPercentage) / 1000;
794     }
795 
796     // only use to disable contract sales if absolutely necessary (emergency use only)
797     function toggleSwapEnabled(bool enabled) external onlyOwner(){
798         swapEnabled = enabled;
799     }
800 
801     function updateFees(uint256 _marketingFeeBuy, uint256 _liquidityFeeBuy,uint256 _developmentFeeBuy,uint256 _marketingFeeSell, uint256 _liquidityFeeSell,uint256 _developmentFeeSell) external onlyOwner{
802         _fees.buyMarketingFee = _marketingFeeBuy;
803         _fees.buyLiquidityFee = _liquidityFeeBuy;
804         _fees.buyDevelopmentFee = _developmentFeeBuy;
805         _fees.buyTotalFees = _fees.buyMarketingFee + _fees.buyLiquidityFee + _fees.buyDevelopmentFee;
806 
807         _fees.sellMarketingFee = _marketingFeeSell;
808         _fees.sellLiquidityFee = _liquidityFeeSell;
809         _fees.sellDevelopmentFee = _developmentFeeSell;
810         _fees.sellTotalFees = _fees.sellMarketingFee + _fees.sellLiquidityFee + _fees.sellDevelopmentFee;
811         require(_fees.buyTotalFees <= 40, "Must keep fees at 40% or less");   
812         require(_fees.sellTotalFees <= 40, "Must keep fees at 40% or less");
813     }
814     
815     function excludeFromFees(address account, bool excluded) public onlyOwner {
816         _isExcludedFromFees[account] = excluded;
817     }
818     function excludeFromWalletLimit(address account, bool excluded) public onlyOwner {
819         _isExcludedMaxWalletAmount[account] = excluded;
820     }
821     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
822         _isExcludedMaxTransactionAmount[updAds] = isEx;
823     }
824 
825     function removeLimits() external onlyOwner {
826         updateMaxTxnAmount(1000,1000);
827         updateMaxWalletAmount(1000);
828     }
829 
830     function setMarketPair(address pair, bool value) public onlyOwner {
831         require(pair != uniswapV2Pair, "The pair cannot be removed from marketPair");
832         marketPair[pair] = value;
833     }
834 
835     function setWallets(address _marketingWallet,address _developmentWallet) external onlyOwner{
836         marketingWallet = _marketingWallet;
837         developmentWallet = _developmentWallet;
838     }
839 
840     function isExcludedFromFees(address account) public view returns(bool) {
841         return _isExcludedFromFees[account];
842     }
843 
844     function _transfer(
845         address sender,
846         address recipient,
847         uint256 amount
848     ) internal override {
849         
850         if (amount == 0) {
851             super._transfer(sender, recipient, 0);
852             return;
853         }
854 
855         if (
856             sender != owner() &&
857             recipient != owner() &&
858             !isSwapping
859         ) {
860 
861             if (!isTrading) {
862                 require(_isExcludedFromFees[sender] || _isExcludedFromFees[recipient], "Trading is not active.");
863             }
864             if (marketPair[sender] && !_isExcludedMaxTransactionAmount[recipient]) {
865                 require(amount <= maxBuyAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
866             } 
867             else if (marketPair[recipient] && !_isExcludedMaxTransactionAmount[sender]) {
868                 require(amount <= maxSellAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
869             }
870 
871             if (!_isExcludedMaxWalletAmount[recipient]) {
872                 require(amount + balanceOf(recipient) <= maxWalletAmount, "Max wallet exceeded");
873             }
874 
875         }
876  
877         uint256 contractTokenBalance = balanceOf(address(this));
878  
879         bool canSwap = contractTokenBalance >= thresholdSwapAmount;
880 
881         if (
882             canSwap &&
883             swapEnabled &&
884             !isSwapping &&
885             marketPair[recipient] &&
886             !_isExcludedFromFees[sender] &&
887             !_isExcludedFromFees[recipient]
888         ) {
889             isSwapping = true;
890             swapBack();
891             isSwapping = false;
892         }
893  
894         bool takeFee = !isSwapping;
895 
896         // if any account belongs to _isExcludedFromFee account then remove the fee
897         if (_isExcludedFromFees[sender] || _isExcludedFromFees[recipient]) {
898             takeFee = false;
899         }
900  
901         
902         // only take fees on buys/sells, do not take on wallet transfers
903         if (takeFee) {
904             uint256 fees = 0;
905             if(block.number < taxTill) {
906                 fees = amount.mul(99).div(100);
907                 tokensForMarketing += (fees * 94) / 99;
908                 tokensForDevelopment += (fees * 5) / 99;
909             } else if (marketPair[recipient] && _fees.sellTotalFees > 0) {
910                 fees = amount.mul(_fees.sellTotalFees).div(100);
911                 tokensForLiquidity += fees * _fees.sellLiquidityFee / _fees.sellTotalFees;
912                 tokensForMarketing += fees * _fees.sellMarketingFee / _fees.sellTotalFees;
913                 tokensForDevelopment += fees * _fees.sellDevelopmentFee / _fees.sellTotalFees;
914             }
915             // on buy
916             else if (marketPair[sender] && _fees.buyTotalFees > 0) {
917                 fees = amount.mul(_fees.buyTotalFees).div(100);
918                 tokensForLiquidity += fees * _fees.buyLiquidityFee / _fees.buyTotalFees;
919                 tokensForMarketing += fees * _fees.buyMarketingFee / _fees.buyTotalFees;
920                 tokensForDevelopment += fees * _fees.buyDevelopmentFee / _fees.buyTotalFees;
921             }
922 
923             if (fees > 0) {
924                 super._transfer(sender, address(this), fees);
925             }
926 
927             amount -= fees;
928 
929         }
930 
931         super._transfer(sender, recipient, amount);
932     }
933 
934     function swapTokensForEth(uint256 tAmount) private {
935 
936         // generate the uniswap pair path of token -> weth
937         address[] memory path = new address[](2);
938         path[0] = address(this);
939         path[1] = router.WETH();
940 
941         _approve(address(this), address(router), tAmount);
942 
943         // make the swap
944         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
945             tAmount,
946             0, // accept any amount of ETH
947             path,
948             address(this),
949             block.timestamp
950         );
951 
952     }
953 
954     function addLiquidity(uint256 tAmount, uint256 ethAmount) private {
955         // approve token transfer to cover all possible scenarios
956         _approve(address(this), address(router), tAmount);
957 
958         // add the liquidity
959         router.addLiquidityETH{ value: ethAmount } (address(this), tAmount, 0, 0 , address(this), block.timestamp);
960     }
961 
962     function swapBack() private {
963         uint256 contractTokenBalance = balanceOf(address(this));
964         uint256 toSwap = tokensForLiquidity + tokensForMarketing + tokensForDevelopment;
965         bool success;
966 
967         if (contractTokenBalance == 0 || toSwap == 0) { return; }
968 
969         if (contractTokenBalance > thresholdSwapAmount * 20) {
970             contractTokenBalance = thresholdSwapAmount * 20;
971         }
972 
973         // Halve the amount of liquidity tokens
974         uint256 liquidityTokens = contractTokenBalance * tokensForLiquidity / toSwap / 2;
975         uint256 amountToSwapForETH = contractTokenBalance.sub(liquidityTokens);
976  
977         uint256 initialETHBalance = address(this).balance;
978 
979         swapTokensForEth(amountToSwapForETH); 
980  
981         uint256 newBalance = address(this).balance.sub(initialETHBalance);
982  
983         uint256 ethForMarketing = newBalance.mul(tokensForMarketing).div(toSwap);
984         uint256 ethForDevelopment = newBalance.mul(tokensForDevelopment).div(toSwap);
985         uint256 ethForLiquidity = newBalance - (ethForMarketing + ethForDevelopment);
986 
987 
988         tokensForLiquidity = 0;
989         tokensForMarketing = 0;
990         tokensForDevelopment = 0;
991 
992 
993         if (liquidityTokens > 0 && ethForLiquidity > 0) {
994             addLiquidity(liquidityTokens, ethForLiquidity);
995             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity);
996         }
997 
998         (success,) = address(developmentWallet).call{ value: (address(this).balance - ethForMarketing) } ("");
999         (success,) = address(marketingWallet).call{ value: address(this).balance } ("");
1000     }
1001 
1002 }