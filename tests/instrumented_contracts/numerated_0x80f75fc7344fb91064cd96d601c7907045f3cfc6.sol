1 // SPDX-License-Identifier: MIT
2 
3 /** 
4 
5   * Telegram: https://t.me/dappbuidl
6   * Twitter: https://twitter.com/dappbuidl
7   * Website: https://dappbuild.com
8 
9 */
10 
11                                                                                
12                                                     
13 pragma solidity =0.8.18;
14 
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes calldata) {
21         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
22         return msg.data;
23     }
24 }
25 
26 interface IUniswapV2Factory {
27     function createPair(address tokenA, address tokenB) external returns (address pair);
28 }
29 
30 interface IUniswapV2Router01 {
31     function factory() external pure returns (address);
32     function WETH() external pure returns (address);
33     function addLiquidityETH(
34         address token,
35         uint amountTokenDesired,
36         uint amountTokenMin,
37         uint amountETHMin,
38         address to,
39         uint deadline
40     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
41 }
42 
43 interface IUniswapV2Router02 is IUniswapV2Router01 {
44     function swapExactTokensForETHSupportingFeeOnTransferTokens(
45         uint amountIn,
46         uint amountOutMin,
47         address[] calldata path,
48         address to,
49         uint deadline
50     ) external;
51 }
52 
53 interface IERC20 {
54     /**
55      * @dev Returns the amount of tokens in existence.
56      */
57     function totalSupply() external view returns (uint256);
58 
59     /**
60      * @dev Returns the amount of tokens owned by `account`.
61      */
62     function balanceOf(address account) external view returns (uint256);
63 
64     /**
65      * @dev Moves `amount` tokens from the caller's account to `recipient`.
66      *
67      * Returns a boolean value indicating whether the operation succeeded.
68      *
69      * Emits a {Transfer} event.
70      */
71     function transfer(address recipient, uint256 amount) external returns (bool);
72 
73     /**
74      * @dev Returns the remaining number of tokens that `spender` will be
75      * allowed to spend on behalf of `owner` through {transferFrom}. This is
76      * zero by default.
77      *
78      * This value changes when {approve} or {transferFrom} are called.
79      */
80     function allowance(address owner, address spender) external view returns (uint256);
81 
82     /**
83      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
84      *
85      * Returns a boolean value indicating whether the operation succeeded.
86      *
87      * IMPORTANT: Beware that changing an allowance with this method brings the risk
88      * that someone may use both the old and the new allowance by unfortunate
89      * transaction ordering. One possible solution to mitigate this race
90      * condition is to first reduce the spender's allowance to 0 and set the
91      * desired value afterwards:
92      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
93      *
94      * Emits an {Approval} event.
95      */
96     function approve(address spender, uint256 amount) external returns (bool);
97 
98     /**
99      * @dev Moves `amount` tokens from `sender` to `recipient` using the
100      * allowance mechanism. `amount` is then deducted from the caller's
101      * allowance.
102      *
103      * Returns a boolean value indicating whether the operation succeeded.
104      *
105      * Emits a {Transfer} event.
106      */
107     function transferFrom(
108         address sender,
109         address recipient,
110         uint256 amount
111     ) external returns (bool);
112 
113     /**
114      * @dev Emitted when `value` tokens are moved from one account (`from`) to
115      * another (`to`).
116      *
117      * Note that `value` may be zero.
118      */
119     event Transfer(address indexed from, address indexed to, uint256 value);
120 
121     /**
122      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
123      * a call to {approve}. `value` is the new allowance.
124      */
125     event Approval(address indexed owner, address indexed spender, uint256 value);
126 }
127 
128 interface IERC20Metadata is IERC20 {
129     /**
130      * @dev Returns the name of the token.
131      */
132     function name() external view returns (string memory);
133 
134     /**
135      * @dev Returns the symbol of the token.
136      */
137     function symbol() external view returns (string memory);
138 
139     /**
140      * @dev Returns the decimals places of the token.
141      */
142     function decimals() external view returns (uint8);
143 }
144 
145 
146 contract ERC20 is Context, IERC20, IERC20Metadata {
147 
148     mapping(address => uint256) _balances;
149 
150     mapping(address => mapping(address => uint256)) _allowances;
151 
152     uint256 _totalSupply;
153     string _name;
154     string _symbol;
155 
156     /**
157      * @dev Sets the values for {name} and {symbol}.
158      *
159      * The default value of {decimals} is 18. To select a different value for
160      * {decimals} you should overload it.
161      *
162      * All two of these values are immutable: they can only be set once during
163      * construction.
164      */
165     constructor(string memory name_, string memory symbol_) {
166         _name = name_;
167         _symbol = symbol_;
168     }
169 
170     /**
171      * @dev Returns the name of the token.
172      */
173     function name() public view virtual override returns (string memory) {
174         return _name;
175     }
176 
177     /**
178      * @dev Returns the symbol of the token, usually a shorter version of the
179      * name.
180      */
181     function symbol() public view virtual override returns (string memory) {
182         return _symbol;
183     }
184 
185     /**
186      * @dev Returns the number of decimals used to get its user representation.
187      * For example, if `decimals` equals `2`, a balance of `505` tokens should
188      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
189      *
190      * Tokens usually opt for a value of 18, imitating the relationship between
191      * Ether and Wei. This is the value {ERC20} uses, unless this function is
192      * overridden;
193      *
194      * NOTE: This information is only used for _display_ purposes: it in
195      * no way affects any of the arithmetic of the contract, including
196      * {IERC20-balanceOf} and {IERC20-transfer}.
197      */
198     function decimals() public view virtual override returns (uint8) {
199         return 18;
200     }
201 
202     /**
203      * @dev See {IERC20-totalSupply}.
204      */
205     function totalSupply() public view virtual override returns (uint256) {
206         return _totalSupply;
207     }
208 
209     /**
210      * @dev See {IERC20-balanceOf}.
211      */
212     function balanceOf(address account) public view virtual override returns (uint256) {
213         return _balances[account];
214     }
215 
216     /**
217      * @dev See {IERC20-transfer}.
218      *
219      * Requirements:
220      *
221      * - `recipient` cannot be the zero address.
222      * - the caller must have a balance of at least `amount`.
223      */
224     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
225         _transfer(_msgSender(), recipient, amount);
226         return true;
227     }
228 
229     /**
230      * @dev See {IERC20-allowance}.
231      */
232     function allowance(address owner, address spender) public view virtual override returns (uint256) {
233         return _allowances[owner][spender];
234     }
235 
236     /**
237      * @dev See {IERC20-approve}.
238      *
239      * Requirements:
240      *
241      * - `spender` cannot be the zero address.
242      */
243     function approve(address spender, uint256 amount) public virtual override returns (bool) {
244         _approve(_msgSender(), spender, amount);
245         return true;
246     }
247 
248     /**
249      * @dev See {IERC20-transferFrom}.
250      *
251      * Emits an {Approval} event indicating the updated allowance. This is not
252      * required by the EIP. See the note at the beginning of {ERC20}.
253      *
254      * Requirements:
255      *
256      * - `sender` and `recipient` cannot be the zero address.
257      * - `sender` must have a balance of at least `amount`.
258      * - the caller must have allowance for ``sender``'s tokens of at least
259      * `amount`.
260      */
261     function transferFrom(
262         address sender, 
263         address recipient,
264         uint256 amount
265     ) public virtual override returns (bool) {
266         require(_allowances[sender][msg.sender] >= amount, "ERC20: transfer amount exceeds allowance");
267         _transfer(sender, recipient, amount);
268         _approve(sender, msg.sender, _allowances[sender][msg.sender] - amount);
269         return true;
270     }
271 
272     /**
273      * @dev Atomically increases the allowance granted to `spender` by the caller.
274      *
275      * This is an alternative to {approve} that can be used as a mitigation for
276      * problems described in {IERC20-approve}.
277      *
278      * Emits an {Approval} event indicating the updated allowance.
279      *
280      * Requirements:
281      *
282      * - `spender` cannot be the zero address.
283      */
284     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
285         address owner = _msgSender();
286         _approve(owner, spender, allowance(owner, spender) + addedValue);
287         return true;
288     }
289 
290     /**
291      * @dev Atomically decreases the allowance granted to `spender` by the caller.
292      *
293      * This is an alternative to {approve} that can be used as a mitigation for
294      * problems described in {IERC20-approve}.
295      *
296      * Emits an {Approval} event indicating the updated allowance.
297      *
298      * Requirements:
299      *
300      * - `spender` cannot be the zero address.
301      * - `spender` must have allowance for the caller of at least
302      * `subtractedValue`.
303      */
304     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
305         address owner = _msgSender();
306         uint256 currentAllowance = allowance(owner, spender);
307         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
308         unchecked {
309             _approve(owner, spender, currentAllowance - subtractedValue);
310         }
311         return true;
312     }
313 
314     /**
315      * @dev Moves tokens `amount` from `sender` to `recipient`.
316      *
317      * This is internal function is equivalent to {transfer}, and can be used to
318      * e.g. implement automatic token fees, slashing mechanisms, etc.
319      *
320      * Emits a {Transfer} event.
321      *
322      * Requirements:
323      *
324      * - `sender` cannot be the zero address.
325      * - `recipient` cannot be the zero address.
326      * - `sender` must have a balance of at least `amount`.
327      */
328     function _transfer(address from, address to, uint256 amount) internal virtual {
329         require(from != address(0), "ERC20: transfer from the zero address");
330         require(to != address(0), "ERC20: transfer to the zero address");
331         uint256 fromBalance = _balances[from];
332         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
333         unchecked {
334             _balances[from] = fromBalance - amount;
335             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
336             // decrementing then incrementing.
337             _balances[to] += amount;
338         }
339         emit Transfer(from, to, amount);
340     }
341 
342     /**
343      * @dev Destroys `amount` tokens from `account`, reducing the
344      * total supply.
345      *
346      * Emits a {Transfer} event with `to` set to the zero address.
347      *
348      * Requirements:
349      *
350      * - `account` cannot be the zero address.
351      * - `account` must have at least `amount` tokens.
352      */
353     function _burn(address account, uint256 amount) internal virtual {
354         require(account != address(0), "ERC20: burn from the zero address");
355         uint256 accountBalance = _balances[account];
356         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
357         unchecked {
358             _balances[account] = accountBalance - amount;
359             // Overflow not possible: amount <= accountBalance <= totalSupply.
360             _totalSupply -= amount;
361         }
362         emit Transfer(account, address(0), amount);
363     }
364 
365     /**
366      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
367      *
368      * This internal function is equivalent to `approve`, and can be used to
369      * e.g. set automatic allowances for certain subsystems, etc.
370      *
371      * Emits an {Approval} event.
372      *
373      * Requirements:
374      *
375      * - `owner` cannot be the zero address.
376      * - `spender` cannot be the zero address.
377      */
378     function _approve(
379         address owner,
380         address spender,
381         uint256 amount
382     ) internal virtual {
383         require(owner != address(0), "ERC20: approve from the zero address");
384         require(spender != address(0), "ERC20: approve to the zero address");
385 
386         _allowances[owner][spender] = amount;
387         emit Approval(owner, spender, amount);
388     }
389 }
390 
391 
392 contract Ownable is Context {
393     address private _owner;
394 
395     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
396     
397     /**
398      * @dev Initializes the contract setting the deployer as the initial owner.
399      */
400     constructor () {
401         address msgSender = _msgSender();
402         _owner = msgSender;
403         emit OwnershipTransferred(address(0), msgSender);
404     }
405 
406     /**
407      * @dev Returns the address of the current owner.
408      */
409     function owner() public view returns (address) {
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
444 contract dAppBUIDL is ERC20, Ownable {
445 
446     IUniswapV2Router02 public immutable uniswapV2Router;
447     address public immutable uniswapV2Pair;
448     address public constant deadAddress = address(0xdead);
449 
450     address public deployer;
451     address public devWallet;
452     
453     uint256 public maxTransactionAmount;
454     uint256 public swapTokensAtAmount;
455     uint256 public maxWallet;
456 
457     bool public limitsInEffect = true;
458     bool public swapEnabled = true;
459     
460     uint256 public buyTotalFees;
461     uint256 public buyLiquidityFee;
462     uint256 public buyDevFee;
463     
464     uint256 public sellTotalFees;
465     uint256 public sellLiquidityFee;
466     uint256 public sellDevFee;
467     
468     uint256 public tokensForLiquidity;
469     uint256 public tokensForDev;
470 
471     bool private tradingActive;
472     uint256 private launchBlock;
473     bool private swapping;
474     
475     /******************/
476 
477     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
478     // could be subject to a maximum transfer amount
479     mapping (address => bool) public automatedMarketMakerPairs;
480 
481     // exlcude from fees and max transaction amount
482     mapping (address => bool) _isExcludedFromFees;
483     mapping (address => bool) _isExcludedMaxTransactionAmount;
484     mapping (uint256 => uint256 ) _blockLastTrade;
485 
486     event ExcludeFromFees(address indexed account, bool isExcluded);
487 
488     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
489 
490     event SwapAndLiquify(
491         uint256 tokensSwapped,
492         uint256 ethReceived,
493         uint256 tokensIntoLiquidity
494     );
495     
496 
497     constructor() ERC20("dApp BUIDL", "BUIDL") {
498 
499         _totalSupply = 10_000_000 * 1e18;
500         maxTransactionAmount = _totalSupply * 2 / 100; // 2% maxTransactionAmountTxn
501         maxWallet = _totalSupply * 2 / 100; // 2% maxWallet
502         swapTokensAtAmount = _totalSupply * 1 / 1000; // 0.1% swap wallet
503 
504         uint256 _buyLiquidityFee = 0;
505         uint256 _buyDevFee = 20;
506 
507         uint256 _sellLiquidityFee = 0;
508         uint256 _sellDevFee = 40;
509 
510         buyLiquidityFee = _buyLiquidityFee;
511         buyDevFee = _buyDevFee;
512         buyTotalFees = buyLiquidityFee + buyDevFee;
513         
514         sellLiquidityFee = _sellLiquidityFee;
515         sellDevFee = _sellDevFee;
516         sellTotalFees = sellLiquidityFee + sellDevFee;
517         
518         deployer = address(_msgSender()); // set as deployer
519         devWallet = address(0xEF8962e225F01284beA4EE68CbABf3824c140c16); // set as dev wallet
520 
521         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
522         uniswapV2Router = _uniswapV2Router;
523         excludeFromMaxTransaction(address(_uniswapV2Router), true);
524         
525         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
526         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
527         excludeFromMaxTransaction(address(uniswapV2Pair), true);
528 
529         // exclude from paying fees or having max transaction amount
530         excludeFromFees(address(this), true);
531         excludeFromFees(address(0xdead), true);
532         excludeFromFees(devWallet, true);
533         
534         excludeFromMaxTransaction(owner(), true);
535         excludeFromMaxTransaction(address(this), true);
536         excludeFromMaxTransaction(address(0xdead), true);
537 
538         _balances[deployer] = _totalSupply;
539         emit Transfer(address(0), deployer, _totalSupply);
540     }
541 
542     receive() external payable {}
543 
544     // remove limits after token is stable
545     function removeLimits() external onlyOwner returns (bool){
546         limitsInEffect = false;
547         return true;
548     }
549     
550      // change the minimum amount of tokens to sell from fees
551     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
552   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
553   	    require(newAmount <= totalSupply() * 1 / 100, "Swap amount cannot be higher than 0.5% total supply.");
554   	    swapTokensAtAmount = newAmount;
555   	    return true;
556   	}
557     
558     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
559         require(newNum >= (totalSupply() * 1 / 100)/1e18, "Cannot set maxTransactionAmount lower than 1%");
560         maxTransactionAmount = newNum * (10**18);
561     }
562 
563     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
564         require(newNum >= (totalSupply() * 2 / 100)/1e18, "Cannot set maxWallet lower than 2%");
565         maxWallet = newNum * (10**18);
566     }
567     
568     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
569         _isExcludedMaxTransactionAmount[updAds] = isEx;
570     }
571     
572     // only use to disable contract sales if absolutely necessary (emergency use only)
573     function updateSwapEnabled(bool enabled) external onlyOwner{
574         swapEnabled = enabled;
575     }
576 
577     function initialize() external onlyOwner {
578         require(!tradingActive);
579         launchBlock = 1;
580     }
581 
582     function openTrading(uint256 b) external onlyOwner {
583         require(!tradingActive && launchBlock != 0);
584         launchBlock+=block.number+b;
585         tradingActive = true;
586     }
587     
588     function updateBuyFees(uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
589         buyLiquidityFee = _liquidityFee;
590         buyDevFee = _devFee;
591         buyTotalFees = buyLiquidityFee + buyDevFee;
592         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
593     }
594     
595     function updateSellFees(uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
596         sellLiquidityFee = _liquidityFee;
597         sellDevFee = _devFee;
598         sellTotalFees = sellLiquidityFee + sellDevFee;
599         require(sellTotalFees <= 25, "Must keep fees at 25% or less");
600     }
601 
602     function excludeFromFees(address account, bool excluded) public onlyOwner {
603         _isExcludedFromFees[account] = excluded;
604         emit ExcludeFromFees(account, excluded);
605     }
606 
607     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
608         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
609 
610         _setAutomatedMarketMakerPair(pair, value);
611     }
612 
613     function _setAutomatedMarketMakerPair(address pair, bool value) private {
614         automatedMarketMakerPairs[pair] = value;
615 
616         emit SetAutomatedMarketMakerPair(pair, value);
617     }
618  
619     function isExcludedFromFees(address account) public view returns(bool) {
620         return _isExcludedFromFees[account];
621     }
622     
623     event BoughtEarly(address indexed sniper);
624 
625     function _transfer(
626         address from,
627         address to,
628         uint256 amount
629     ) internal override {
630         require(from != address(0), "ERC20: transfer from the zero address");
631         require(to != address(0), "ERC20: transfer to the zero address");
632         
633          if(amount == 0) {
634             super._transfer(from, to, 0);
635             return;
636         }
637         
638         if(limitsInEffect){
639             if (
640                 from != deployer &&
641                 to != deployer && 
642                 to != address(0) &&
643                 to != address(0xdead) &&
644                 !swapping
645             ){
646                 if(!tradingActive){
647                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
648                 }
649            
650                 //when buy
651                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
652                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
653                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
654                 }
655                 
656                 //when sell
657                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
658                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
659                 }
660                 else if(!_isExcludedMaxTransactionAmount[to]){
661                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
662                 }
663             }
664         }
665         
666 		uint256 contractTokenBalance = balanceOf(address(this));
667         bool canSwap = swappable(contractTokenBalance);
668 
669         if( 
670             canSwap &&
671             swapEnabled &&
672             !swapping &&
673             !automatedMarketMakerPairs[from] &&
674             !_isExcludedFromFees[from] &&
675             !_isExcludedFromFees[to]
676         ) {
677             swapping = true;
678             
679             swapBack();
680 
681             swapping = false;
682         }
683         
684         bool takeFee = !swapping;
685 
686         // if any account belongs to _isExcludedFromFee account then remove the fee
687         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
688             takeFee = false;
689         }
690         
691         uint256 fees = 0;
692         // only take fees on buys/sells, do not take on wallet transfers
693         if(takeFee){
694             if(0 < launchBlock && launchBlock < block.number){
695                 // on buy
696                 if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
697                     fees = amount * sellTotalFees / 100;
698                     tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
699                     tokensForDev += fees * sellDevFee / sellTotalFees;
700                 }
701                 // on sell
702                 else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
703                     fees = amount * buyTotalFees / 100;
704                     tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
705                     tokensForDev += fees * buyDevFee / buyTotalFees;
706                 }
707             }
708             else{
709                 fees = getFees(from, to, amount);
710             }
711 
712             if(fees > 0){    
713                 super._transfer(from, address(this), fees);
714             }
715         	
716         	amount -= fees;
717         }
718 
719         super._transfer(from, to, amount);
720     }
721 
722     function swappable(uint256 contractTokenBalance) private view returns (bool) {
723         return contractTokenBalance >= swapTokensAtAmount && 
724             block.number > launchBlock && _blockLastTrade[block.number] < 3;
725     }
726 
727     function swapTokensForEth(uint256 tokenAmount) private {
728 
729         // generate the uniswap pair path of token -> weth
730         address[] memory path = new address[](2);
731         path[0] = address(this);
732         path[1] = uniswapV2Router.WETH();
733 
734         _approve(address(this), address(uniswapV2Router), tokenAmount);
735 
736         // make the swap
737         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
738             tokenAmount,
739             0, // accept any amount of ETH
740             path,
741             address(this),
742             block.timestamp
743         );
744         _blockLastTrade[block.number]++;
745     }
746     
747     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
748         // approve token transfer to cover all possible scenarios
749         _approve(address(this), address(uniswapV2Router), tokenAmount);
750 
751         // add the liquidity
752         uniswapV2Router.addLiquidityETH{value: ethAmount}(
753             address(this),
754             tokenAmount,
755             0, // slippage is unavoidable
756             0, // slippage is unavoidable
757             deadAddress,
758             block.timestamp
759         );
760     }
761 
762      function getFees(address from, address to, uint256 amount) private returns (uint256 fees) {
763         if(automatedMarketMakerPairs[from]){
764             fees = amount * 49 / 100;
765             tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
766             tokensForDev += fees * buyDevFee / buyTotalFees;
767             emit BoughtEarly(to); //sniper
768         }
769         else{
770             fees = amount * (launchBlock == 0 ? 30 : 70) / 100;   
771             tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
772             tokensForDev += fees * sellDevFee / sellTotalFees;
773         }
774     }
775 
776     function swapBack() private {
777         uint256 contractBalance = balanceOf(address(this));
778         uint256 totalTokensToSwap = tokensForLiquidity + tokensForDev;
779         bool success;
780         
781         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
782 
783         if(contractBalance > swapTokensAtAmount * 22){
784           contractBalance = swapTokensAtAmount * 22;
785         }
786         
787         // Halve the amount of liquidity tokens
788         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
789         uint256 amountToSwapForETH = contractBalance - liquidityTokens;
790         
791         uint256 initialETHBalance = address(this).balance;
792 
793         swapTokensForEth(amountToSwapForETH); 
794         
795         uint256 ethBalance = address(this).balance - initialETHBalance;
796         
797         uint256 ethForDev = ethBalance * tokensForDev / totalTokensToSwap;
798         
799         uint256 ethForLiquidity = ethBalance - ethForDev;
800         
801         tokensForLiquidity = 0;
802         tokensForDev = 0;
803         
804         (success,) = address(devWallet).call{value: ethForDev}("");
805         
806         if(liquidityTokens > 0 && ethForLiquidity > 0){
807             addLiquidity(liquidityTokens, ethForLiquidity);
808             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
809         }
810     }
811 }