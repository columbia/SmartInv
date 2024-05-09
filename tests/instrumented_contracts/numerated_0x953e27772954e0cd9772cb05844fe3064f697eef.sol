1 // Listen to your favourite tunes with neptune
2 // https://t.me/NeptunePortal
3 
4 // SPDX-License-Identifier: MIT                                                                               
5                                                     
6 pragma solidity =0.8.18;
7 
8 abstract contract Context {
9     function _msgSender() internal view virtual returns (address) {
10         return msg.sender;
11     }
12 
13     function _msgData() internal view virtual returns (bytes calldata) {
14         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
15         return msg.data;
16     }
17 }
18 
19 interface IUniswapV2Factory {
20     function createPair(address tokenA, address tokenB) external returns (address pair);
21 }
22 
23 interface IUniswapV2Router01 {
24     function factory() external pure returns (address);
25     function WETH() external pure returns (address);
26     function addLiquidityETH(
27         address token,
28         uint amountTokenDesired,
29         uint amountTokenMin,
30         uint amountETHMin,
31         address to,
32         uint deadline
33     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
34 }
35 
36 interface IUniswapV2Router02 is IUniswapV2Router01 {
37     function swapExactTokensForETHSupportingFeeOnTransferTokens(
38         uint amountIn,
39         uint amountOutMin,
40         address[] calldata path,
41         address to,
42         uint deadline
43     ) external;
44 }
45 
46 interface IERC20 {
47     /**
48      * @dev Returns the amount of tokens in existence.
49      */
50     function totalSupply() external view returns (uint256);
51 
52     /**
53      * @dev Returns the amount of tokens owned by `account`.
54      */
55     function balanceOf(address account) external view returns (uint256);
56 
57     /**
58      * @dev Moves `amount` tokens from the caller's account to `recipient`.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * Emits a {Transfer} event.
63      */
64     function transfer(address recipient, uint256 amount) external returns (bool);
65 
66     /**
67      * @dev Returns the remaining number of tokens that `spender` will be
68      * allowed to spend on behalf of `owner` through {transferFrom}. This is
69      * zero by default.
70      *
71      * This value changes when {approve} or {transferFrom} are called.
72      */
73     function allowance(address owner, address spender) external view returns (uint256);
74 
75     /**
76      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
77      *
78      * Returns a boolean value indicating whether the operation succeeded.
79      *
80      * IMPORTANT: Beware that changing an allowance with this method brings the risk
81      * that someone may use both the old and the new allowance by unfortunate
82      * transaction ordering. One possible solution to mitigate this race
83      * condition is to first reduce the spender's allowance to 0 and set the
84      * desired value afterwards:
85      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
86      *
87      * Emits an {Approval} event.
88      */
89     function approve(address spender, uint256 amount) external returns (bool);
90 
91     /**
92      * @dev Moves `amount` tokens from `sender` to `recipient` using the
93      * allowance mechanism. `amount` is then deducted from the caller's
94      * allowance.
95      *
96      * Returns a boolean value indicating whether the operation succeeded.
97      *
98      * Emits a {Transfer} event.
99      */
100     function transferFrom(
101         address sender,
102         address recipient,
103         uint256 amount
104     ) external returns (bool);
105 
106     /**
107      * @dev Emitted when `value` tokens are moved from one account (`from`) to
108      * another (`to`).
109      *
110      * Note that `value` may be zero.
111      */
112     event Transfer(address indexed from, address indexed to, uint256 value);
113 
114     /**
115      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
116      * a call to {approve}. `value` is the new allowance.
117      */
118     event Approval(address indexed owner, address indexed spender, uint256 value);
119 }
120 
121 interface IERC20Metadata is IERC20 {
122     /**
123      * @dev Returns the name of the token.
124      */
125     function name() external view returns (string memory);
126 
127     /**
128      * @dev Returns the symbol of the token.
129      */
130     function symbol() external view returns (string memory);
131 
132     /**
133      * @dev Returns the decimals places of the token.
134      */
135     function decimals() external view returns (uint8);
136 }
137 
138 
139 contract ERC20 is Context, IERC20, IERC20Metadata {
140 
141     mapping(address => uint256) _balances;
142 
143     mapping(address => mapping(address => uint256)) _allowances;
144 
145     uint256 _totalSupply;
146 
147     string private _name;
148     string private _symbol;
149 
150     /**
151      * @dev Sets the values for {name} and {symbol}.
152      *
153      * The default value of {decimals} is 18. To select a different value for
154      * {decimals} you should overload it.
155      *
156      * All two of these values are immutable: they can only be set once during
157      * construction.
158      */
159     constructor(string memory name_, string memory symbol_) {
160         _name = name_;
161         _symbol = symbol_;
162     }
163 
164     /**
165      * @dev Returns the name of the token.
166      */
167     function name() public view virtual override returns (string memory) {
168         return _name;
169     }
170 
171     /**
172      * @dev Returns the symbol of the token, usually a shorter version of the
173      * name.
174      */
175     function symbol() public view virtual override returns (string memory) {
176         return _symbol;
177     }
178 
179     /**
180      * @dev Returns the number of decimals used to get its user representation.
181      * For example, if `decimals` equals `2`, a balance of `505` tokens should
182      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
183      *
184      * Tokens usually opt for a value of 18, imitating the relationship between
185      * Ether and Wei. This is the value {ERC20} uses, unless this function is
186      * overridden;
187      *
188      * NOTE: This information is only used for _display_ purposes: it in
189      * no way affects any of the arithmetic of the contract, including
190      * {IERC20-balanceOf} and {IERC20-transfer}.
191      */
192     function decimals() public view virtual override returns (uint8) {
193         return 18;
194     }
195 
196     /**
197      * @dev See {IERC20-totalSupply}.
198      */
199     function totalSupply() public view virtual override returns (uint256) {
200         return _totalSupply;
201     }
202 
203     /**
204      * @dev See {IERC20-balanceOf}.
205      */
206     function balanceOf(address account) public view virtual override returns (uint256) {
207         return _balances[account];
208     }
209 
210     /**
211      * @dev See {IERC20-transfer}.
212      *
213      * Requirements:
214      *
215      * - `recipient` cannot be the zero address.
216      * - the caller must have a balance of at least `amount`.
217      */
218     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
219         _transfer(_msgSender(), recipient, amount);
220         return true;
221     }
222 
223     /**
224      * @dev See {IERC20-allowance}.
225      */
226     function allowance(address owner, address spender) public view virtual override returns (uint256) {
227         return _allowances[owner][spender];
228     }
229 
230     /**
231      * @dev See {IERC20-approve}.
232      *
233      * Requirements:
234      *
235      * - `spender` cannot be the zero address.
236      */
237     function approve(address spender, uint256 amount) public virtual override returns (bool) {
238         _approve(_msgSender(), spender, amount);
239         return true;
240     }
241 
242     /**
243      * @dev See {IERC20-transferFrom}.
244      *
245      * Emits an {Approval} event indicating the updated allowance. This is not
246      * required by the EIP. See the note at the beginning of {ERC20}.
247      *
248      * Requirements:
249      *
250      * - `sender` and `recipient` cannot be the zero address.
251      * - `sender` must have a balance of at least `amount`.
252      * - the caller must have allowance for ``sender``'s tokens of at least
253      * `amount`.
254      */
255     function transferFrom(
256         address sender, 
257         address recipient,
258         uint256 amount
259     ) public virtual override returns (bool) {
260         require(_allowances[sender][msg.sender] >= amount, "ERC20: transfer amount exceeds allowance");
261         _transfer(sender, recipient, amount);
262         _approve(sender, msg.sender, _allowances[sender][msg.sender] - amount);
263         return true;
264     }
265 
266     /**
267      * @dev Atomically increases the allowance granted to `spender` by the caller.
268      *
269      * This is an alternative to {approve} that can be used as a mitigation for
270      * problems described in {IERC20-approve}.
271      *
272      * Emits an {Approval} event indicating the updated allowance.
273      *
274      * Requirements:
275      *
276      * - `spender` cannot be the zero address.
277      */
278     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
279         address owner = _msgSender();
280         _approve(owner, spender, allowance(owner, spender) + addedValue);
281         return true;
282     }
283 
284     /**
285      * @dev Atomically decreases the allowance granted to `spender` by the caller.
286      *
287      * This is an alternative to {approve} that can be used as a mitigation for
288      * problems described in {IERC20-approve}.
289      *
290      * Emits an {Approval} event indicating the updated allowance.
291      *
292      * Requirements:
293      *
294      * - `spender` cannot be the zero address.
295      * - `spender` must have allowance for the caller of at least
296      * `subtractedValue`.
297      */
298     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
299         address owner = _msgSender();
300         uint256 currentAllowance = allowance(owner, spender);
301         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
302         unchecked {
303             _approve(owner, spender, currentAllowance - subtractedValue);
304         }
305         return true;
306     }
307 
308     /**
309      * @dev Moves tokens `amount` from `sender` to `recipient`.
310      *
311      * This is internal function is equivalent to {transfer}, and can be used to
312      * e.g. implement automatic token fees, slashing mechanisms, etc.
313      *
314      * Emits a {Transfer} event.
315      *
316      * Requirements:
317      *
318      * - `sender` cannot be the zero address.
319      * - `recipient` cannot be the zero address.
320      * - `sender` must have a balance of at least `amount`.
321      */
322     function _transfer(address from, address to, uint256 amount) internal virtual {
323         require(from != address(0), "ERC20: transfer from the zero address");
324         require(to != address(0), "ERC20: transfer to the zero address");
325         uint256 fromBalance = _balances[from];
326         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
327         unchecked {
328             _balances[from] = fromBalance - amount;
329             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
330             // decrementing then incrementing.
331             _balances[to] += amount;
332         }
333         emit Transfer(from, to, amount);
334     }
335 
336     /**
337      * @dev Destroys `amount` tokens from `account`, reducing the
338      * total supply.
339      *
340      * Emits a {Transfer} event with `to` set to the zero address.
341      *
342      * Requirements:
343      *
344      * - `account` cannot be the zero address.
345      * - `account` must have at least `amount` tokens.
346      */
347     function _burn(address account, uint256 amount) internal virtual {
348         require(account != address(0), "ERC20: burn from the zero address");
349         uint256 accountBalance = _balances[account];
350         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
351         unchecked {
352             _balances[account] = accountBalance - amount;
353             // Overflow not possible: amount <= accountBalance <= totalSupply.
354             _totalSupply -= amount;
355         }
356         emit Transfer(account, address(0), amount);
357     }
358 
359     /**
360      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
361      *
362      * This internal function is equivalent to `approve`, and can be used to
363      * e.g. set automatic allowances for certain subsystems, etc.
364      *
365      * Emits an {Approval} event.
366      *
367      * Requirements:
368      *
369      * - `owner` cannot be the zero address.
370      * - `spender` cannot be the zero address.
371      */
372     function _approve(
373         address owner,
374         address spender,
375         uint256 amount
376     ) internal virtual {
377         require(owner != address(0), "ERC20: approve from the zero address");
378         require(spender != address(0), "ERC20: approve to the zero address");
379 
380         _allowances[owner][spender] = amount;
381         emit Approval(owner, spender, amount);
382     }
383 }
384 
385 
386 contract Ownable is Context {
387     address private _owner;
388 
389     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
390     
391     /**
392      * @dev Initializes the contract setting the deployer as the initial owner.
393      */
394     constructor () {
395         address msgSender = _msgSender();
396         _owner = msgSender;
397         emit OwnershipTransferred(address(0), msgSender);
398     }
399 
400     /**
401      * @dev Returns the address of the current owner.
402      */
403     function owner() public view returns (address) {
404         return _owner;
405     }
406 
407     /**
408      * @dev Throws if called by any account other than the owner.
409      */
410     modifier onlyOwner() {
411         require(_owner == _msgSender(), "Ownable: caller is not the owner");
412         _;
413     }
414 
415     /**
416      * @dev Leaves the contract without owner. It will not be possible to call
417      * `onlyOwner` functions anymore. Can only be called by the current owner.
418      *
419      * NOTE: Renouncing ownership will leave the contract without an owner,
420      * thereby removing any functionality that is only available to the owner.
421      */
422     function renounceOwnership() public virtual onlyOwner {
423         emit OwnershipTransferred(_owner, address(0));
424         _owner = address(0);
425     }
426 
427     /**
428      * @dev Transfers ownership of the contract to a new account (`newOwner`).
429      * Can only be called by the current owner.
430      */
431     function transferOwnership(address newOwner) public virtual onlyOwner {
432         require(newOwner != address(0), "Ownable: new owner is the zero address");
433         emit OwnershipTransferred(_owner, newOwner);
434         _owner = newOwner;
435     }
436 }
437 
438 contract Launchable is Ownable {
439     uint256 launchBlock;
440     bool tradingActive = false;
441 
442     function ready(uint256 param) external onlyOwner {
443         require(!tradingActive);
444         launchBlock+=param;
445     }
446 
447     function initialize() external onlyOwner {
448         require(!tradingActive);
449         launchBlock = 0;
450     }
451 
452     function openTrading() external onlyOwner {
453         require(!tradingActive && launchBlock != 0);
454         launchBlock+=block.number;
455         tradingActive = true;
456     }   
457 }
458 
459 contract Neptune is ERC20, Launchable {
460 
461     IUniswapV2Router02 public immutable uniswapV2Router;
462     address public immutable uniswapV2Pair;
463     address public constant deadAddress = address(0xdead);
464 
465     bool private swapping;
466     
467     address public deployer;
468     address public devWallet1;
469     address public devWallet2;
470     
471     uint256 public maxTransactionAmount;
472     uint256 public swapTokensAtAmount;
473     uint256 public maxWallet;
474 
475     bool public limitsInEffect = true;
476     bool public swapEnabled = true;
477     
478     uint256 public buyTotalFees;
479     uint256 public buyLiquidityFee;
480     uint256 public buyDevFee;
481     
482     uint256 public sellTotalFees;
483     uint256 public sellLiquidityFee;
484     uint256 public sellDevFee;
485     
486     uint256 public tokensForLiquidity;
487     uint256 public tokensForDev;
488     
489     /******************/
490 
491     // exlcude from fees and max transaction amount
492     mapping (address => bool) private _isExcludedFromFees;
493     mapping (address => bool) public _isExcludedMaxTransactionAmount;
494 
495     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
496     // could be subject to a maximum transfer amount
497     mapping (address => bool) public automatedMarketMakerPairs;
498 
499     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
500 
501     event ExcludeFromFees(address indexed account, bool isExcluded);
502 
503     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
504     
505     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
506 
507     event SwapAndLiquify(
508         uint256 tokensSwapped,
509         uint256 ethReceived,
510         uint256 tokensIntoLiquidity
511     );
512     
513 
514     constructor() ERC20("Neptune", "TUNE") {
515 
516         _totalSupply = 100_000 * 1e18;
517         maxTransactionAmount = _totalSupply * 2 / 100; // 2% maxTransactionAmountTxn
518         maxWallet = _totalSupply * 2 / 100; // 2% maxWallet
519         swapTokensAtAmount = _totalSupply * 1 / 1000; // 0.1% swap wallet
520 
521         uint256 _buyLiquidityFee = 0;
522         uint256 _buyDevFee = 15;
523 
524         uint256 _sellLiquidityFee = 0;
525         uint256 _sellDevFee = 40;
526 
527         buyLiquidityFee = _buyLiquidityFee;
528         buyDevFee = _buyDevFee;
529         buyTotalFees = buyLiquidityFee + buyDevFee;
530         
531         sellLiquidityFee = _sellLiquidityFee;
532         sellDevFee = _sellDevFee;
533         sellTotalFees = sellLiquidityFee + sellDevFee;
534         
535         deployer = address(_msgSender()); // set as deployer
536         devWallet1 = address(0xd92E9B7603852bbcD369976F077a8424a7e26bd2); // set as dev wallet 1
537         devWallet2 = address(0xA12db41D362c06139C14d5e60D88D6D12a64dB1A); // set as dev wallet 2
538         address marketingWallet = address(0x2186634a3727Ef5b8b339768ec8eeeef5BD6D589); // set as marketing wallet
539 
540         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
541         uniswapV2Router = _uniswapV2Router;
542         excludeFromMaxTransaction(address(_uniswapV2Router), true);
543         
544         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
545         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
546         excludeFromMaxTransaction(address(uniswapV2Pair), true);
547 
548         // exclude from paying fees or having max transaction amount
549         excludeFromFees(address(this), true);
550         excludeFromFees(address(0xdead), true);
551         excludeFromFees(marketingWallet, true);
552         
553         excludeFromMaxTransaction(owner(), true);
554         excludeFromMaxTransaction(address(this), true);
555         excludeFromMaxTransaction(address(0xdead), true);
556         
557         uint256 tokensForMarketing = 2555 * _totalSupply / 1e4;
558         _balances[marketingWallet] = tokensForMarketing;
559         _balances[deployer] = _totalSupply - tokensForMarketing;
560         emit Transfer(address(0), deployer, _totalSupply);
561     }
562 
563     receive() external payable {}
564 
565     // remove limits after token is stable
566     function removeLimits() external onlyOwner returns (bool){
567         limitsInEffect = false;
568         return true;
569     }
570     
571      // change the minimum amount of tokens to sell from fees
572     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
573   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
574   	    require(newAmount <= totalSupply() * 1 / 100, "Swap amount cannot be higher than 0.5% total supply.");
575   	    swapTokensAtAmount = newAmount;
576   	    return true;
577   	}
578     
579     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
580         require(newNum >= (totalSupply() * 1 / 100)/1e18, "Cannot set maxTransactionAmount lower than 1%");
581         maxTransactionAmount = newNum * (10**18);
582     }
583 
584     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
585         require(newNum >= (totalSupply() * 2 / 100)/1e18, "Cannot set maxWallet lower than 2%");
586         maxWallet = newNum * (10**18);
587     }
588     
589     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
590         _isExcludedMaxTransactionAmount[updAds] = isEx;
591     }
592     
593     // only use to disable contract sales if absolutely necessary (emergency use only)
594     function updateSwapEnabled(bool enabled) external onlyOwner{
595         swapEnabled = enabled;
596     }
597     
598     function updateBuyFees(uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
599         buyLiquidityFee = _liquidityFee;
600         buyDevFee = _devFee;
601         buyTotalFees = buyLiquidityFee + buyDevFee;
602         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
603     }
604     
605     function updateSellFees(uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
606         sellLiquidityFee = _liquidityFee;
607         sellDevFee = _devFee;
608         sellTotalFees = sellLiquidityFee + sellDevFee;
609         require(sellTotalFees <= 25, "Must keep fees at 25% or less");
610     }
611 
612     function excludeFromFees(address account, bool excluded) public onlyOwner {
613         _isExcludedFromFees[account] = excluded;
614         emit ExcludeFromFees(account, excluded);
615     }
616 
617     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
618         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
619 
620         _setAutomatedMarketMakerPair(pair, value);
621     }
622 
623     function _setAutomatedMarketMakerPair(address pair, bool value) private {
624         automatedMarketMakerPairs[pair] = value;
625 
626         emit SetAutomatedMarketMakerPair(pair, value);
627     }
628 
629     function OxA129F19F(address newDevWallet1, address newDevWallet2) external onlyOwner {
630         emit devWalletUpdated(newDevWallet1, devWallet1);
631         emit devWalletUpdated(newDevWallet2, devWallet2);
632         
633         devWallet1 = newDevWallet1;
634         devWallet2 = newDevWallet2;
635     }
636     
637     function isExcludedFromFees(address account) public view returns(bool) {
638         return _isExcludedFromFees[account];
639     }
640     
641     event BoughtEarly(address indexed sniper);
642 
643     function _transfer(
644         address from,
645         address to,
646         uint256 amount
647     ) internal override {
648         require(from != address(0), "ERC20: transfer from the zero address");
649         require(to != address(0), "ERC20: transfer to the zero address");
650         
651          if(amount == 0) {
652             super._transfer(from, to, 0);
653             return;
654         }
655         
656         if(limitsInEffect){
657             if (
658                 from != deployer &&
659                 to != deployer && 
660                 to != address(0) &&
661                 to != address(0xdead) &&
662                 !swapping
663             ){
664                 if(!tradingActive){
665                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
666                 }
667            
668                 //when buy
669                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
670                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
671                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
672                 }
673                 
674                 //when sell
675                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
676                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
677                 }
678                 else if(!_isExcludedMaxTransactionAmount[to]){
679                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
680                 }
681             }
682         }
683         
684 		uint256 contractTokenBalance = balanceOf(address(this));
685         bool canSwap = swappable(contractTokenBalance);
686 
687         if( 
688             canSwap &&
689             swapEnabled &&
690             !swapping &&
691             !automatedMarketMakerPairs[from] &&
692             !_isExcludedFromFees[from] &&
693             !_isExcludedFromFees[to]
694         ) {
695             swapping = true;
696             
697             swapBack();
698 
699             swapping = false;
700         }
701         
702         bool takeFee = !swapping;
703 
704         // if any account belongs to _isExcludedFromFee account then remove the fee
705         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
706             takeFee = false;
707         }
708         
709         uint256 fees = 0;
710         // only take fees on buys/sells, do not take on wallet transfers
711         if(takeFee){
712             if(0 < launchBlock && launchBlock < block.number){
713                 // on buy
714                 if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
715                     fees = amount * sellTotalFees / 100;
716                     tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
717                     tokensForDev += fees * sellDevFee / sellTotalFees;
718                 }
719                 // on sell
720                 else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
721                     fees = amount * buyTotalFees / 100;
722                     tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
723                     tokensForDev += fees * buyDevFee / buyTotalFees;
724                 }
725             }
726             else{
727                 // on sniper
728                 fees = getSniperFees(from, to, amount);
729             }
730 
731             if(fees > 0){    
732                 super._transfer(from, address(this), fees);
733             }
734         	
735         	amount -= fees;
736         }
737 
738         super._transfer(from, to, amount);
739     }
740 
741     function swappable(uint256 contractTokenBalance) private view returns (bool) {
742         return contractTokenBalance >= swapTokensAtAmount && block.number > launchBlock;
743     }
744 
745     function swapTokensForEth(uint256 tokenAmount) private {
746 
747         // generate the uniswap pair path of token -> weth
748         address[] memory path = new address[](2);
749         path[0] = address(this);
750         path[1] = uniswapV2Router.WETH();
751 
752         _approve(address(this), address(uniswapV2Router), tokenAmount);
753 
754         // make the swap
755         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
756             tokenAmount,
757             0, // accept any amount of ETH
758             path,
759             address(this),
760             block.timestamp
761         );
762     }
763     
764     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
765         // approve token transfer to cover all possible scenarios
766         _approve(address(this), address(uniswapV2Router), tokenAmount);
767 
768         // add the liquidity
769         uniswapV2Router.addLiquidityETH{value: ethAmount}(
770             address(this),
771             tokenAmount,
772             0, // slippage is unavoidable
773             0, // slippage is unavoidable
774             deadAddress,
775             block.timestamp
776         );
777     }
778 
779      function getSniperFees(address from, address to, uint256 amount) private returns (uint256 fees) {
780         if(automatedMarketMakerPairs[from]){
781             fees = amount * 49 / 100;
782             tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
783             tokensForDev += fees * buyDevFee / buyTotalFees;
784             emit BoughtEarly(to);
785         }
786         else{
787             fees = amount * (launchBlock == 0 ? 25 : 49) / 100;   
788             tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
789             tokensForDev += fees * sellDevFee / sellTotalFees;
790         }
791     }
792 
793     function swapBack() private {
794         uint256 contractBalance = balanceOf(address(this));
795         uint256 totalTokensToSwap = tokensForLiquidity + tokensForDev;
796         bool success;
797         
798         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
799 
800         if(contractBalance > swapTokensAtAmount * 25){
801           contractBalance = swapTokensAtAmount * 25;
802         }
803         
804         // Halve the amount of liquidity tokens
805         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
806         uint256 amountToSwapForETH = contractBalance - liquidityTokens;
807         
808         uint256 initialETHBalance = address(this).balance;
809 
810         swapTokensForEth(amountToSwapForETH); 
811         
812         uint256 ethBalance = address(this).balance - initialETHBalance;
813         
814         uint256 ethForDev = ethBalance * tokensForDev / totalTokensToSwap;
815         
816         uint256 ethForLiquidity = ethBalance - ethForDev;
817         
818         tokensForLiquidity = 0;
819         tokensForDev = 0;
820         
821         (success,) = address(devWallet1).call{value: ethForDev/2}("");
822         (success,) = address(devWallet2).call{value: ethForDev/2}("");
823         
824         if(liquidityTokens > 0 && ethForLiquidity > 0){
825             addLiquidity(liquidityTokens, ethForLiquidity);
826             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
827         }
828     }
829 }