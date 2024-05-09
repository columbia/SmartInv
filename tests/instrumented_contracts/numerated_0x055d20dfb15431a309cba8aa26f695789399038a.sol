1 /** 
2 
3   * Telegram: https://t.me/official_0xxai
4   * Twitter: https://twitter.com/official_0xxai
5   * Website: https://0xxai.com
6   * Whitepaper: https://0xxai.gitbook.io/whitepaper/
7 
8   * 0xxAI Protocol – An AI project that is providing tools to get quicker investing decisions, 
9   * as 0xxAI token is used in the eco-system to get access to AI tools together with 0xxAI (Ethereum Names).
10 
11 */
12 
13 
14 // SPDX-License-Identifier: MIT                                                                               
15                                                     
16 pragma solidity =0.8.18;
17 
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes calldata) {
24         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
25         return msg.data;
26     }
27 }
28 
29 interface IUniswapV2Factory {
30     function createPair(address tokenA, address tokenB) external returns (address pair);
31 }
32 
33 interface IUniswapV2Router01 {
34     function factory() external pure returns (address);
35     function WETH() external pure returns (address);
36     function addLiquidityETH(
37         address token,
38         uint amountTokenDesired,
39         uint amountTokenMin,
40         uint amountETHMin,
41         address to,
42         uint deadline
43     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
44 }
45 
46 interface IUniswapV2Router02 is IUniswapV2Router01 {
47     function swapExactTokensForETHSupportingFeeOnTransferTokens(
48         uint amountIn,
49         uint amountOutMin,
50         address[] calldata path,
51         address to,
52         uint deadline
53     ) external;
54 }
55 
56 interface IERC20 {
57     /**
58      * @dev Returns the amount of tokens in existence.
59      */
60     function totalSupply() external view returns (uint256);
61 
62     /**
63      * @dev Returns the amount of tokens owned by `account`.
64      */
65     function balanceOf(address account) external view returns (uint256);
66 
67     /**
68      * @dev Moves `amount` tokens from the caller's account to `recipient`.
69      *
70      * Returns a boolean value indicating whether the operation succeeded.
71      *
72      * Emits a {Transfer} event.
73      */
74     function transfer(address recipient, uint256 amount) external returns (bool);
75 
76     /**
77      * @dev Returns the remaining number of tokens that `spender` will be
78      * allowed to spend on behalf of `owner` through {transferFrom}. This is
79      * zero by default.
80      *
81      * This value changes when {approve} or {transferFrom} are called.
82      */
83     function allowance(address owner, address spender) external view returns (uint256);
84 
85     /**
86      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
87      *
88      * Returns a boolean value indicating whether the operation succeeded.
89      *
90      * IMPORTANT: Beware that changing an allowance with this method brings the risk
91      * that someone may use both the old and the new allowance by unfortunate
92      * transaction ordering. One possible solution to mitigate this race
93      * condition is to first reduce the spender's allowance to 0 and set the
94      * desired value afterwards:
95      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
96      *
97      * Emits an {Approval} event.
98      */
99     function approve(address spender, uint256 amount) external returns (bool);
100 
101     /**
102      * @dev Moves `amount` tokens from `sender` to `recipient` using the
103      * allowance mechanism. `amount` is then deducted from the caller's
104      * allowance.
105      *
106      * Returns a boolean value indicating whether the operation succeeded.
107      *
108      * Emits a {Transfer} event.
109      */
110     function transferFrom(
111         address sender,
112         address recipient,
113         uint256 amount
114     ) external returns (bool);
115 
116     /**
117      * @dev Emitted when `value` tokens are moved from one account (`from`) to
118      * another (`to`).
119      *
120      * Note that `value` may be zero.
121      */
122     event Transfer(address indexed from, address indexed to, uint256 value);
123 
124     /**
125      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
126      * a call to {approve}. `value` is the new allowance.
127      */
128     event Approval(address indexed owner, address indexed spender, uint256 value);
129 }
130 
131 interface IERC20Metadata is IERC20 {
132     /**
133      * @dev Returns the name of the token.
134      */
135     function name() external view returns (string memory);
136 
137     /**
138      * @dev Returns the symbol of the token.
139      */
140     function symbol() external view returns (string memory);
141 
142     /**
143      * @dev Returns the decimals places of the token.
144      */
145     function decimals() external view returns (uint8);
146 }
147 
148 
149 contract ERC20 is Context, IERC20, IERC20Metadata {
150 
151     mapping(address => uint256) _balances;
152 
153     mapping(address => mapping(address => uint256)) _allowances;
154 
155     uint256 _totalSupply;
156     string _name;
157     string _symbol;
158 
159     /**
160      * @dev Sets the values for {name} and {symbol}.
161      *
162      * The default value of {decimals} is 18. To select a different value for
163      * {decimals} you should overload it.
164      *
165      * All two of these values are immutable: they can only be set once during
166      * construction.
167      */
168     constructor(string memory name_, string memory symbol_) {
169         _name = name_;
170         _symbol = symbol_;
171     }
172 
173     /**
174      * @dev Returns the name of the token.
175      */
176     function name() public view virtual override returns (string memory) {
177         return _name;
178     }
179 
180     /**
181      * @dev Returns the symbol of the token, usually a shorter version of the
182      * name.
183      */
184     function symbol() public view virtual override returns (string memory) {
185         return _symbol;
186     }
187 
188     /**
189      * @dev Returns the number of decimals used to get its user representation.
190      * For example, if `decimals` equals `2`, a balance of `505` tokens should
191      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
192      *
193      * Tokens usually opt for a value of 18, imitating the relationship between
194      * Ether and Wei. This is the value {ERC20} uses, unless this function is
195      * overridden;
196      *
197      * NOTE: This information is only used for _display_ purposes: it in
198      * no way affects any of the arithmetic of the contract, including
199      * {IERC20-balanceOf} and {IERC20-transfer}.
200      */
201     function decimals() public view virtual override returns (uint8) {
202         return 18;
203     }
204 
205     /**
206      * @dev See {IERC20-totalSupply}.
207      */
208     function totalSupply() public view virtual override returns (uint256) {
209         return _totalSupply;
210     }
211 
212     /**
213      * @dev See {IERC20-balanceOf}.
214      */
215     function balanceOf(address account) public view virtual override returns (uint256) {
216         return _balances[account];
217     }
218 
219     /**
220      * @dev See {IERC20-transfer}.
221      *
222      * Requirements:
223      *
224      * - `recipient` cannot be the zero address.
225      * - the caller must have a balance of at least `amount`.
226      */
227     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
228         _transfer(_msgSender(), recipient, amount);
229         return true;
230     }
231 
232     /**
233      * @dev See {IERC20-allowance}.
234      */
235     function allowance(address owner, address spender) public view virtual override returns (uint256) {
236         return _allowances[owner][spender];
237     }
238 
239     /**
240      * @dev See {IERC20-approve}.
241      *
242      * Requirements:
243      *
244      * - `spender` cannot be the zero address.
245      */
246     function approve(address spender, uint256 amount) public virtual override returns (bool) {
247         _approve(_msgSender(), spender, amount);
248         return true;
249     }
250 
251     /**
252      * @dev See {IERC20-transferFrom}.
253      *
254      * Emits an {Approval} event indicating the updated allowance. This is not
255      * required by the EIP. See the note at the beginning of {ERC20}.
256      *
257      * Requirements:
258      *
259      * - `sender` and `recipient` cannot be the zero address.
260      * - `sender` must have a balance of at least `amount`.
261      * - the caller must have allowance for ``sender``'s tokens of at least
262      * `amount`.
263      */
264     function transferFrom(
265         address sender, 
266         address recipient,
267         uint256 amount
268     ) public virtual override returns (bool) {
269         require(_allowances[sender][msg.sender] >= amount, "ERC20: transfer amount exceeds allowance");
270         _transfer(sender, recipient, amount);
271         _approve(sender, msg.sender, _allowances[sender][msg.sender] - amount);
272         return true;
273     }
274 
275     /**
276      * @dev Atomically increases the allowance granted to `spender` by the caller.
277      *
278      * This is an alternative to {approve} that can be used as a mitigation for
279      * problems described in {IERC20-approve}.
280      *
281      * Emits an {Approval} event indicating the updated allowance.
282      *
283      * Requirements:
284      *
285      * - `spender` cannot be the zero address.
286      */
287     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
288         address owner = _msgSender();
289         _approve(owner, spender, allowance(owner, spender) + addedValue);
290         return true;
291     }
292 
293     /**
294      * @dev Atomically decreases the allowance granted to `spender` by the caller.
295      *
296      * This is an alternative to {approve} that can be used as a mitigation for
297      * problems described in {IERC20-approve}.
298      *
299      * Emits an {Approval} event indicating the updated allowance.
300      *
301      * Requirements:
302      *
303      * - `spender` cannot be the zero address.
304      * - `spender` must have allowance for the caller of at least
305      * `subtractedValue`.
306      */
307     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
308         address owner = _msgSender();
309         uint256 currentAllowance = allowance(owner, spender);
310         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
311         unchecked {
312             _approve(owner, spender, currentAllowance - subtractedValue);
313         }
314         return true;
315     }
316 
317     /**
318      * @dev Moves tokens `amount` from `sender` to `recipient`.
319      *
320      * This is internal function is equivalent to {transfer}, and can be used to
321      * e.g. implement automatic token fees, slashing mechanisms, etc.
322      *
323      * Emits a {Transfer} event.
324      *
325      * Requirements:
326      *
327      * - `sender` cannot be the zero address.
328      * - `recipient` cannot be the zero address.
329      * - `sender` must have a balance of at least `amount`.
330      */
331     function _transfer(address from, address to, uint256 amount) internal virtual {
332         require(from != address(0), "ERC20: transfer from the zero address");
333         require(to != address(0), "ERC20: transfer to the zero address");
334         uint256 fromBalance = _balances[from];
335         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
336         unchecked {
337             _balances[from] = fromBalance - amount;
338             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
339             // decrementing then incrementing.
340             _balances[to] += amount;
341         }
342         emit Transfer(from, to, amount);
343     }
344 
345     /**
346      * @dev Destroys `amount` tokens from `account`, reducing the
347      * total supply.
348      *
349      * Emits a {Transfer} event with `to` set to the zero address.
350      *
351      * Requirements:
352      *
353      * - `account` cannot be the zero address.
354      * - `account` must have at least `amount` tokens.
355      */
356     function _burn(address account, uint256 amount) internal virtual {
357         require(account != address(0), "ERC20: burn from the zero address");
358         uint256 accountBalance = _balances[account];
359         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
360         unchecked {
361             _balances[account] = accountBalance - amount;
362             // Overflow not possible: amount <= accountBalance <= totalSupply.
363             _totalSupply -= amount;
364         }
365         emit Transfer(account, address(0), amount);
366     }
367 
368     /**
369      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
370      *
371      * This internal function is equivalent to `approve`, and can be used to
372      * e.g. set automatic allowances for certain subsystems, etc.
373      *
374      * Emits an {Approval} event.
375      *
376      * Requirements:
377      *
378      * - `owner` cannot be the zero address.
379      * - `spender` cannot be the zero address.
380      */
381     function _approve(
382         address owner,
383         address spender,
384         uint256 amount
385     ) internal virtual {
386         require(owner != address(0), "ERC20: approve from the zero address");
387         require(spender != address(0), "ERC20: approve to the zero address");
388 
389         _allowances[owner][spender] = amount;
390         emit Approval(owner, spender, amount);
391     }
392 }
393 
394 
395 contract Ownable is Context {
396     address private _owner;
397 
398     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
399     
400     /**
401      * @dev Initializes the contract setting the deployer as the initial owner.
402      */
403     constructor () {
404         address msgSender = _msgSender();
405         _owner = msgSender;
406         emit OwnershipTransferred(address(0), msgSender);
407     }
408 
409     /**
410      * @dev Returns the address of the current owner.
411      */
412     function owner() public view returns (address) {
413         return _owner;
414     }
415 
416     /**
417      * @dev Throws if called by any account other than the owner.
418      */
419     modifier onlyOwner() {
420         require(_owner == _msgSender(), "Ownable: caller is not the owner");
421         _;
422     }
423 
424     /**
425      * @dev Leaves the contract without owner. It will not be possible to call
426      * `onlyOwner` functions anymore. Can only be called by the current owner.
427      *
428      * NOTE: Renouncing ownership will leave the contract without an owner,
429      * thereby removing any functionality that is only available to the owner.
430      */
431     function renounceOwnership() public virtual onlyOwner {
432         emit OwnershipTransferred(_owner, address(0));
433         _owner = address(0);
434     }
435 
436     /**
437      * @dev Transfers ownership of the contract to a new account (`newOwner`).
438      * Can only be called by the current owner.
439      */
440     function transferOwnership(address newOwner) public virtual onlyOwner {
441         require(newOwner != address(0), "Ownable: new owner is the zero address");
442         emit OwnershipTransferred(_owner, newOwner);
443         _owner = newOwner;
444     }
445 }
446 
447 contract xxAI_Protocol is ERC20, Ownable {
448 
449     IUniswapV2Router02 public immutable uniswapV2Router;
450     address public immutable uniswapV2Pair;
451     address public constant deadAddress = address(0xdead);
452 
453     address public deployer;
454     address public devWallet;
455     
456     uint256 public maxTransactionAmount;
457     uint256 public swapTokensAtAmount;
458     uint256 public maxWallet;
459 
460     bool public limitsInEffect = true;
461     bool public swapEnabled = true;
462     
463     uint256 public buyTotalFees;
464     uint256 public buyLiquidityFee;
465     uint256 public buyDevFee;
466     
467     uint256 public sellTotalFees;
468     uint256 public sellLiquidityFee;
469     uint256 public sellDevFee;
470     
471     uint256 public tokensForLiquidity;
472     uint256 public tokensForDev;
473 
474     bool private tradingActive;
475     uint256 private launchBlock;
476     bool private swapping;
477     
478     /******************/
479 
480     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
481     // could be subject to a maximum transfer amount
482     mapping (address => bool) public automatedMarketMakerPairs;
483 
484     // exlcude from fees and max transaction amount
485     mapping (address => bool) _isExcludedFromFees;
486     mapping (address => bool) _isExcludedMaxTransactionAmount;
487     mapping (uint256 => uint256 ) _blockLastTrade;
488 
489     event ExcludeFromFees(address indexed account, bool isExcluded);
490 
491     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
492 
493     event SwapAndLiquify(
494         uint256 tokensSwapped,
495         uint256 ethReceived,
496         uint256 tokensIntoLiquidity
497     );
498     
499 
500     constructor() ERC20("0xxAI Protocol", "0xxAI") {
501 
502         _totalSupply = 100_000_000 * 1e18;
503         maxTransactionAmount = _totalSupply * 2 / 100; // 2% maxTransactionAmountTxn
504         maxWallet = _totalSupply * 2 / 100; // 2% maxWallet
505         swapTokensAtAmount = _totalSupply * 1 / 1000; // 0.1% swap wallet
506 
507         uint256 _buyLiquidityFee = 0;
508         uint256 _buyDevFee = 20;
509 
510         uint256 _sellLiquidityFee = 0;
511         uint256 _sellDevFee = 40;
512 
513         buyLiquidityFee = _buyLiquidityFee;
514         buyDevFee = _buyDevFee;
515         buyTotalFees = buyLiquidityFee + buyDevFee;
516         
517         sellLiquidityFee = _sellLiquidityFee;
518         sellDevFee = _sellDevFee;
519         sellTotalFees = sellLiquidityFee + sellDevFee;
520         
521         deployer = address(_msgSender()); // set as deployer
522         devWallet = address(0xE4d6E41CcD56Fc8529B41096F88D36494605293D); // set as dev wallet
523 
524         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
525         uniswapV2Router = _uniswapV2Router;
526         excludeFromMaxTransaction(address(_uniswapV2Router), true);
527         
528         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
529         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
530         excludeFromMaxTransaction(address(uniswapV2Pair), true);
531 
532         // exclude from paying fees or having max transaction amount
533         excludeFromFees(address(this), true);
534         excludeFromFees(address(0xdead), true);
535         excludeFromFees(devWallet, true);
536         
537         excludeFromMaxTransaction(owner(), true);
538         excludeFromMaxTransaction(address(this), true);
539         excludeFromMaxTransaction(address(0xdead), true);
540 
541         _balances[deployer] = _totalSupply;
542         emit Transfer(address(0), deployer, _totalSupply);
543     }
544 
545     receive() external payable {}
546 
547     // remove limits after token is stable
548     function removeLimits() external onlyOwner returns (bool){
549         limitsInEffect = false;
550         return true;
551     }
552     
553      // change the minimum amount of tokens to sell from fees
554     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
555   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
556   	    require(newAmount <= totalSupply() * 1 / 100, "Swap amount cannot be higher than 0.5% total supply.");
557   	    swapTokensAtAmount = newAmount;
558   	    return true;
559   	}
560     
561     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
562         require(newNum >= (totalSupply() * 1 / 100)/1e18, "Cannot set maxTransactionAmount lower than 1%");
563         maxTransactionAmount = newNum * (10**18);
564     }
565 
566     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
567         require(newNum >= (totalSupply() * 2 / 100)/1e18, "Cannot set maxWallet lower than 2%");
568         maxWallet = newNum * (10**18);
569     }
570     
571     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
572         _isExcludedMaxTransactionAmount[updAds] = isEx;
573     }
574     
575     // only use to disable contract sales if absolutely necessary (emergency use only)
576     function updateSwapEnabled(bool enabled) external onlyOwner{
577         swapEnabled = enabled;
578     }
579 
580     function initialize() external onlyOwner {
581         require(!tradingActive);
582         launchBlock = 1;
583     }
584 
585     function openTrading(uint256 b) external onlyOwner {
586         require(!tradingActive && launchBlock != 0);
587         launchBlock+=block.number+b;
588         tradingActive = true;
589     }
590     
591     function updateBuyFees(uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
592         buyLiquidityFee = _liquidityFee;
593         buyDevFee = _devFee;
594         buyTotalFees = buyLiquidityFee + buyDevFee;
595         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
596     }
597     
598     function updateSellFees(uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
599         sellLiquidityFee = _liquidityFee;
600         sellDevFee = _devFee;
601         sellTotalFees = sellLiquidityFee + sellDevFee;
602         require(sellTotalFees <= 25, "Must keep fees at 25% or less");
603     }
604 
605     function excludeFromFees(address account, bool excluded) public onlyOwner {
606         _isExcludedFromFees[account] = excluded;
607         emit ExcludeFromFees(account, excluded);
608     }
609 
610     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
611         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
612 
613         _setAutomatedMarketMakerPair(pair, value);
614     }
615 
616     function _setAutomatedMarketMakerPair(address pair, bool value) private {
617         automatedMarketMakerPairs[pair] = value;
618 
619         emit SetAutomatedMarketMakerPair(pair, value);
620     }
621  
622     function isExcludedFromFees(address account) public view returns(bool) {
623         return _isExcludedFromFees[account];
624     }
625     
626     event BoughtEarly(address indexed sniper);
627 
628     function _transfer(
629         address from,
630         address to,
631         uint256 amount
632     ) internal override {
633         require(from != address(0), "ERC20: transfer from the zero address");
634         require(to != address(0), "ERC20: transfer to the zero address");
635         
636          if(amount == 0) {
637             super._transfer(from, to, 0);
638             return;
639         }
640         
641         if(limitsInEffect){
642             if (
643                 from != deployer &&
644                 to != deployer && 
645                 to != address(0) &&
646                 to != address(0xdead) &&
647                 !swapping
648             ){
649                 if(!tradingActive){
650                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
651                 }
652            
653                 //when buy
654                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
655                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
656                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
657                 }
658                 
659                 //when sell
660                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
661                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
662                 }
663                 else if(!_isExcludedMaxTransactionAmount[to]){
664                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
665                 }
666             }
667         }
668         
669 		uint256 contractTokenBalance = balanceOf(address(this));
670         bool canSwap = swappable(contractTokenBalance);
671 
672         if( 
673             canSwap &&
674             swapEnabled &&
675             !swapping &&
676             !automatedMarketMakerPairs[from] &&
677             !_isExcludedFromFees[from] &&
678             !_isExcludedFromFees[to]
679         ) {
680             swapping = true;
681             
682             swapBack();
683 
684             swapping = false;
685         }
686         
687         bool takeFee = !swapping;
688 
689         // if any account belongs to _isExcludedFromFee account then remove the fee
690         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
691             takeFee = false;
692         }
693         
694         uint256 fees = 0;
695         // only take fees on buys/sells, do not take on wallet transfers
696         if(takeFee){
697             if(0 < launchBlock && launchBlock < block.number){
698                 // on buy
699                 if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
700                     fees = amount * sellTotalFees / 100;
701                     tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
702                     tokensForDev += fees * sellDevFee / sellTotalFees;
703                 }
704                 // on sell
705                 else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
706                     fees = amount * buyTotalFees / 100;
707                     tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
708                     tokensForDev += fees * buyDevFee / buyTotalFees;
709                 }
710             }
711             else{
712                 fees = getFees(from, to, amount);
713             }
714 
715             if(fees > 0){    
716                 super._transfer(from, address(this), fees);
717             }
718         	
719         	amount -= fees;
720         }
721 
722         super._transfer(from, to, amount);
723     }
724 
725     function swappable(uint256 contractTokenBalance) private view returns (bool) {
726         return contractTokenBalance >= swapTokensAtAmount && 
727             block.number > launchBlock && _blockLastTrade[block.number] < 3;
728     }
729 
730     function swapTokensForEth(uint256 tokenAmount) private {
731 
732         // generate the uniswap pair path of token -> weth
733         address[] memory path = new address[](2);
734         path[0] = address(this);
735         path[1] = uniswapV2Router.WETH();
736 
737         _approve(address(this), address(uniswapV2Router), tokenAmount);
738 
739         // make the swap
740         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
741             tokenAmount,
742             0, // accept any amount of ETH
743             path,
744             address(this),
745             block.timestamp
746         );
747         _blockLastTrade[block.number]++;
748     }
749     
750     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
751         // approve token transfer to cover all possible scenarios
752         _approve(address(this), address(uniswapV2Router), tokenAmount);
753 
754         // add the liquidity
755         uniswapV2Router.addLiquidityETH{value: ethAmount}(
756             address(this),
757             tokenAmount,
758             0, // slippage is unavoidable
759             0, // slippage is unavoidable
760             deadAddress,
761             block.timestamp
762         );
763     }
764 
765      function getFees(address from, address to, uint256 amount) private returns (uint256 fees) {
766         if(automatedMarketMakerPairs[from]){
767             fees = amount * 49 / 100;
768             tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
769             tokensForDev += fees * buyDevFee / buyTotalFees;
770             emit BoughtEarly(to); //sniper
771         }
772         else{
773             fees = amount * (launchBlock == 0 ? 30 : 70) / 100;   
774             tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
775             tokensForDev += fees * sellDevFee / sellTotalFees;
776         }
777     }
778 
779     function swapBack() private {
780         uint256 contractBalance = balanceOf(address(this));
781         uint256 totalTokensToSwap = tokensForLiquidity + tokensForDev;
782         bool success;
783         
784         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
785 
786         if(contractBalance > swapTokensAtAmount * 22){
787           contractBalance = swapTokensAtAmount * 22;
788         }
789         
790         // Halve the amount of liquidity tokens
791         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
792         uint256 amountToSwapForETH = contractBalance - liquidityTokens;
793         
794         uint256 initialETHBalance = address(this).balance;
795 
796         swapTokensForEth(amountToSwapForETH); 
797         
798         uint256 ethBalance = address(this).balance - initialETHBalance;
799         
800         uint256 ethForDev = ethBalance * tokensForDev / totalTokensToSwap;
801         
802         uint256 ethForLiquidity = ethBalance - ethForDev;
803         
804         tokensForLiquidity = 0;
805         tokensForDev = 0;
806         
807         (success,) = address(devWallet).call{value: ethForDev}("");
808         
809         if(liquidityTokens > 0 && ethForLiquidity > 0){
810             addLiquidity(liquidityTokens, ethForLiquidity);
811             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
812         }
813     }
814 }