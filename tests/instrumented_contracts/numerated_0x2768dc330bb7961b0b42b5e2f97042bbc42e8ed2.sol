1 // File: contracts/PulseCliff.sol
2 
3 /* “It’s not easy to keep Clifford. He eats and drinks a lot.”  */
4 
5 //Max tx: 1%
6 //Max wallet: 2%
7 //Taxes: 10/10 for buybacks & burns only
8 /*
9 
10 // https://t.me/PulseCliffordInu
11 
12          ___
13  __/_  `.  .-"""-.
14  \_,` | \-'  /   )`-')
15   "") `"`    \  ((`"`
16  ___Y  ,    .'7 /|
17 (_,___/...-` (_/_/ 
18 */
19 
20                                                     
21 pragma solidity 0.8.4;
22 
23 abstract contract Context {
24     function _msgSender() internal view virtual returns (address) {
25         return msg.sender;
26     }
27 
28     function _msgData() internal view virtual returns (bytes calldata) {
29         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
30         return msg.data;
31     }
32 }
33 
34 library EnumerableSet {
35 
36     struct Set {
37         bytes32[] _values;
38         mapping(bytes32 => uint256) _indexes;
39     }
40 
41     function _add(Set storage set, bytes32 value) private returns (bool) {
42         if (!_contains(set, value)) {
43             set._values.push(value);
44             set._indexes[value] = set._values.length;
45             return true;
46         } else {
47             return false;
48         }
49     }
50 
51     function _remove(Set storage set, bytes32 value) private returns (bool) {
52         uint256 valueIndex = set._indexes[value];
53 
54         if (valueIndex != 0) {
55             uint256 toDeleteIndex = valueIndex - 1;
56             uint256 lastIndex = set._values.length - 1;
57 
58             if (lastIndex != toDeleteIndex) {
59                 bytes32 lastValue = set._values[lastIndex];
60                 set._values[toDeleteIndex] = lastValue;
61                 set._indexes[lastValue] = valueIndex;
62             }
63 
64             set._values.pop();
65 
66             delete set._indexes[value];
67 
68             return true;
69         } else {
70             return false;
71         }
72     }
73 
74     function _contains(Set storage set, bytes32 value) private view returns (bool) {
75         return set._indexes[value] != 0;
76     }
77 
78     function _length(Set storage set) private view returns (uint256) {
79         return set._values.length;
80     }
81 
82     function _at(Set storage set, uint256 index) private view returns (bytes32) {
83         return set._values[index];
84     }
85 
86     function _values(Set storage set) private view returns (bytes32[] memory) {
87         return set._values;
88     }
89 
90 
91     // AddressSet
92 
93     struct AddressSet {
94         Set _inner;
95     }
96 
97     function add(AddressSet storage set, address value) internal returns (bool) {
98         return _add(set._inner, bytes32(uint256(uint160(value))));
99     }
100 
101     function remove(AddressSet storage set, address value) internal returns (bool) {
102         return _remove(set._inner, bytes32(uint256(uint160(value))));
103     }
104 
105     /**
106      * @dev Returns true if the value is in the set. O(1).
107      */
108     function contains(AddressSet storage set, address value) internal view returns (bool) {
109         return _contains(set._inner, bytes32(uint256(uint160(value))));
110     }
111 
112     /**
113      * @dev Returns the number of values in the set. O(1).
114      */
115     function length(AddressSet storage set) internal view returns (uint256) {
116         return _length(set._inner);
117     }
118 
119     function at(AddressSet storage set, uint256 index) internal view returns (address) {
120         return address(uint160(uint256(_at(set._inner, index))));
121     }
122 
123     function values(AddressSet storage set) internal view returns (address[] memory) {
124         bytes32[] memory store = _values(set._inner);
125         address[] memory result;
126 
127         /// @solidity memory-safe-assembly
128         assembly {
129             result := store
130         }
131 
132         return result;
133     }
134 }
135 
136 interface IERC20 {
137     function totalSupply() external view returns (uint256);
138     function balanceOf(address account) external view returns (uint256);
139     function transfer(address recipient, uint256 amount) external returns (bool);
140     function allowance(address owner, address spender) external view returns (uint256);
141     function approve(address spender, uint256 amount) external returns (bool);
142     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
143 
144     event Transfer(address indexed from, address indexed to, uint256 value);
145     event Approval(address indexed owner, address indexed spender, uint256 value);
146 
147     function name() external view returns (string memory);
148     function symbol() external view returns (string memory);
149     function decimals() external view returns (uint8);
150 }
151 
152 contract ERC20 is Context, IERC20 {
153     mapping(address => uint256) private _balances;
154 
155     mapping(address => mapping(address => uint256)) private _allowances;
156 
157     uint256 private _totalSupply;
158 
159     string private _name;
160     string private _symbol;
161 
162     constructor(string memory name_, string memory symbol_) {
163         _name = name_;
164         _symbol = symbol_;
165     }
166 
167     function name() public view virtual override returns (string memory) {
168         return _name;
169     }
170 
171     function symbol() public view virtual override returns (string memory) {
172         return _symbol;
173     }
174 
175     function decimals() public view virtual override returns (uint8) {
176         return 18;
177     }
178 
179     function totalSupply() public view virtual override returns (uint256) {
180         return _totalSupply;
181     }
182 
183     function balanceOf(address account) public view virtual override returns (uint256) {
184         return _balances[account];
185     }
186 
187     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
188         _transfer(_msgSender(), recipient, amount);
189         return true;
190     }
191 
192     function allowance(address owner, address spender) public view virtual override returns (uint256) {
193         return _allowances[owner][spender];
194     }
195 
196     function approve(address spender, uint256 amount) public virtual override returns (bool) {
197         _approve(_msgSender(), spender, amount);
198         return true;
199     }
200 
201     function transferFrom(
202         address sender,
203         address recipient,
204         uint256 amount
205     ) public virtual override returns (bool) {
206         _transfer(sender, recipient, amount);
207 
208         uint256 currentAllowance = _allowances[sender][_msgSender()];
209         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
210         unchecked {
211             _approve(sender, _msgSender(), currentAllowance - amount);
212         }
213 
214         return true;
215     }
216 
217     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
218         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
219         return true;
220     }
221 
222     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
223         uint256 currentAllowance = _allowances[_msgSender()][spender];
224         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
225         unchecked {
226             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
227         }
228 
229         return true;
230     }
231 
232     function _transfer(
233         address sender,
234         address recipient,
235         uint256 amount
236     ) internal virtual {
237         require(sender != address(0), "ERC20: transfer from the zero address");
238         require(recipient != address(0), "ERC20: transfer to the zero address");
239 
240         uint256 senderBalance = _balances[sender];
241         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
242         unchecked {
243             _balances[sender] = senderBalance - amount;
244         }
245         _balances[recipient] += amount;
246 
247         emit Transfer(sender, recipient, amount);
248     }
249 
250     function _createInitialSupply(address account, uint256 amount) internal virtual {
251         require(account != address(0), "ERC20: to the zero address");
252 
253         _totalSupply += amount;
254         _balances[account] += amount;
255         emit Transfer(address(0), account, amount);
256     }
257 
258     function _approve(
259         address owner,
260         address spender,
261         uint256 amount
262     ) internal virtual {
263         require(owner != address(0), "ERC20: approve from the zero address");
264         require(spender != address(0), "ERC20: approve to the zero address");
265 
266         _allowances[owner][spender] = amount;
267         emit Approval(owner, spender, amount);
268     }
269 }
270 
271 contract Ownable is Context {
272     address private _owner;
273 
274     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
275     
276     constructor () {
277         address msgSender = _msgSender();
278         _owner = msgSender;
279         emit OwnershipTransferred(address(0), msgSender);
280     }
281 
282     function owner() public view returns (address) {
283         return _owner;
284     }
285 
286     modifier onlyOwner() {
287         require(_owner == _msgSender(), "Ownable: caller is not the owner");
288         _;
289     }
290 
291     function renounceOwnership() external virtual onlyOwner {
292         emit OwnershipTransferred(_owner, address(0));
293         _owner = address(0);
294     }
295 
296     function transferOwnership(address newOwner) public virtual onlyOwner {
297         require(newOwner != address(0), "Ownable: new owner is the zero address");
298         emit OwnershipTransferred(_owner, newOwner);
299         _owner = newOwner;
300     }
301 }
302 
303 interface IDexRouter {
304     function factory() external pure returns (address);
305     function WETH() external pure returns (address);
306     
307     function swapExactTokensForETHSupportingFeeOnTransferTokens(
308         uint amountIn,
309         uint amountOutMin,
310         address[] calldata path,
311         address to,
312         uint deadline
313     ) external;
314 
315     function swapExactETHForTokensSupportingFeeOnTransferTokens(
316         uint amountOutMin,
317         address[] calldata path,
318         address to,
319         uint deadline
320     ) external payable;
321 
322     function addLiquidityETH(
323         address token,
324         uint256 amountTokenDesired,
325         uint256 amountTokenMin,
326         uint256 amountETHMin,
327         address to,
328         uint256 deadline
329     )
330         external
331         payable
332         returns (
333             uint256 amountToken,
334             uint256 amountETH,
335             uint256 liquidity
336         );
337 
338     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
339 
340     function removeLiquidityETH(address token, uint liquidity, uint amountTokenMin, uint amountETHMin, address to, uint deadline) external returns (uint amountToken, uint amountETH);
341 
342 }
343 
344 interface IDexFactory {
345     function createPair(address tokenA, address tokenB)
346         external
347         returns (address pair);
348 }
349 
350 interface IDexPair {
351 
352     function name() external pure returns (string memory);
353     function symbol() external pure returns (string memory);
354     function decimals() external pure returns (uint8);
355     function totalSupply() external view returns (uint);
356     function balanceOf(address owner) external view returns (uint);
357     function allowance(address owner, address spender) external view returns (uint);
358 
359     function approve(address spender, uint value) external returns (bool);
360     function transfer(address to, uint value) external returns (bool);
361     function transferFrom(address from, address to, uint value) external returns (bool);
362 
363     function DOMAIN_SEPARATOR() external view returns (bytes32);
364     function PERMIT_TYPEHASH() external pure returns (bytes32);
365     function nonces(address owner) external view returns (uint);
366 
367     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
368 
369     function MINIMUM_LIQUIDITY() external pure returns (uint);
370     function factory() external view returns (address);
371     function token0() external view returns (address);
372     function token1() external view returns (address);
373     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
374     function price0CumulativeLast() external view returns (uint);
375     function price1CumulativeLast() external view returns (uint);
376     function kLast() external view returns (uint);
377 
378     function mint(address to) external returns (uint liquidity);
379     function burn(address to) external returns (uint amount0, uint amount1);
380     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
381     function skim(address to) external;
382     function sync() external;
383 
384     function initialize(address, address) external;
385 }
386 
387 contract PulseCliffordInu is ERC20, Ownable {
388 
389     using EnumerableSet for EnumerableSet.AddressSet;
390 
391     uint256 public maxBuyAmount;
392     uint256 public maxSellAmount;
393     uint256 public maxWalletAmount;
394 
395     EnumerableSet.AddressSet private buyerList;
396     uint256 public nextLotteryTime;
397     uint256 public timeBetweenLotteries = 30 minutes;
398     uint256 public minBuyAmount = .1 ether;
399     bool public minBuyEnforced = true;
400     uint256 public percentForLottery = 100;
401     bool public lotteryEnabled = false;
402 
403     uint256 public lastBurnTimestamp;
404 
405     IDexRouter public dexRouter;
406     address public lpPair;
407 
408     bool private swapping;
409     uint256 public swapTokensAtAmount;
410 
411     address operationsAddress;
412 
413     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
414     uint256 public blockForPenaltyEnd;
415     mapping (address => bool) public restrictedWallet;
416     uint256 public botsCaught;
417 
418     bool public limitsInEffect = true;
419     bool public tradingActive = false;
420     bool public swapEnabled = false;
421     
422     uint256 public buyTotalFees;
423     uint256 public buyOperationsFee;
424     uint256 public buyLiquidityFee;
425     uint256 public buyLotteryFee;
426 
427     uint256 public sellTotalFees;
428     uint256 public sellOperationsFee;
429     uint256 public sellLiquidityFee;
430     uint256 public sellLotteryFee;
431 
432     uint256 public tokensForOperations;
433     uint256 public tokensForLiquidity;
434     uint256 public tokensForLottery;
435 
436     uint256 public FEE_DENOMINATOR = 10000;
437     
438     /******************/
439 
440     // exlcude from fees and max transaction amount
441     mapping (address => bool) public _isExcludedFromFees;
442     mapping (address => bool) public _isExcludedMaxTransactionAmount;
443 
444     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
445     // could be subject to a maximum transfer amount
446     mapping (address => bool) public automatedMarketMakerPairs;
447 
448     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
449 
450     event EnabledTrading();
451 
452     event RemovedLimits();
453 
454     event ExcludeFromFees(address indexed account, bool isExcluded);
455 
456     event UpdatedMaxBuyAmount(uint256 newAmount);
457 
458     event UpdatedMaxSellAmount(uint256 newAmount);
459 
460     event UpdatedMaxWalletAmount(uint256 newAmount);
461 
462     event UpdatedOperationsAddress(address indexed newWallet);
463 
464     event MaxTransactionExclusion(address _address, bool excluded);
465 
466     event BuyBackTriggered(uint256 amount);
467 
468     event OwnerForcedSwapBack(uint256 timestamp);
469 
470     event CaughtBot(address sniper);
471 
472     event TransferForeignToken(address token, uint256 amount);
473 
474     event LotteryTriggered(uint256 indexed amount, address indexed wallet);
475 
476     constructor() ERC20("PulseCliffordInu", "PLSCI") {
477         
478         IDexRouter _dexRouter = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
479         dexRouter = _dexRouter;
480 
481         operationsAddress = address(0x1140Fc164b7830DF4F37B384C8B6ceC1bb94E54e); 
482 
483         // create pair
484         lpPair = IDexFactory(_dexRouter.factory()).createPair(address(this), _dexRouter.WETH());
485         _excludeFromMaxTransaction(address(lpPair), true);
486         _setAutomatedMarketMakerPair(address(lpPair), true);
487 
488         uint256 totalSupply = 5 * 1e6 * 1e18;
489         
490         maxBuyAmount = totalSupply * 1 / 1000;
491         maxSellAmount = totalSupply * 1 / 1000;
492         maxWalletAmount = totalSupply * 2 / 100;
493         swapTokensAtAmount = totalSupply * 25 / 100000;
494 
495         buyOperationsFee = 0;
496         buyLiquidityFee = 1000;
497         buyLotteryFee = 0;
498         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyLotteryFee;
499 
500         sellOperationsFee = 0;
501         sellLiquidityFee = 9000;
502         sellLotteryFee = 0;
503         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellLotteryFee;
504 
505         
506         _excludeFromMaxTransaction(msg.sender, true);
507         _excludeFromMaxTransaction(operationsAddress, true);
508         _excludeFromMaxTransaction(address(this), true);
509         _excludeFromMaxTransaction(address(0xdead), true);
510         _excludeFromMaxTransaction(address(dexRouter), true);
511 
512         
513         excludeFromFees(msg.sender, true);
514         excludeFromFees(operationsAddress, true);
515         excludeFromFees(address(this), true);
516         excludeFromFees(address(0xdead), true);
517         excludeFromFees(address(dexRouter), true);
518 
519         _createInitialSupply(msg.sender, totalSupply);
520         
521     }
522 
523     receive() external payable {}
524 
525     function isWalletLotteryEligible(address account) external view returns (bool){
526         return buyerList.contains(account);
527     }
528     
529     function enableTrading(uint256 blocksForPenalty) external onlyOwner {
530         require(blockForPenaltyEnd == 0);
531         tradingActive = true;
532         swapEnabled = true;
533         tradingActiveBlock = block.number;
534         blockForPenaltyEnd = tradingActiveBlock + blocksForPenalty;
535         nextLotteryTime = block.timestamp + timeBetweenLotteries;
536         emit EnabledTrading();
537     }
538     
539     // remove limits after token is stable
540     function removeLimits() external onlyOwner {
541         limitsInEffect = false;
542         emit RemovedLimits();
543     }
544 
545     function updateTradingActive(bool active) external onlyOwner {
546         tradingActive = active;
547     }
548 
549     function setLotteryEnabled(bool enabled) external onlyOwner {
550         lotteryEnabled = enabled;
551     }
552 
553     function manageRestrictedWallets(address[] calldata wallets, bool restricted) external onlyOwner {
554         for(uint256 i = 0; i < wallets.length; i++){
555             restrictedWallet[wallets[i]] = restricted;
556         }
557     }
558     
559     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
560         require(newNum >= (totalSupply() * 1 / 1000) / (10 ** decimals()));
561         maxBuyAmount = newNum * (10 ** decimals());
562         emit UpdatedMaxBuyAmount(maxBuyAmount);
563     }
564     
565     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
566         require(newNum >= (totalSupply() * 1 / 1000) / (10 ** decimals()));
567         maxSellAmount = newNum * (10 ** decimals());
568         emit UpdatedMaxSellAmount(maxSellAmount);
569     }
570 
571     function updateMaxWallet(uint256 newNum) external onlyOwner {
572         require(newNum >= (totalSupply() * 1 / 100) / (10 ** decimals()));
573         maxWalletAmount = newNum * (10 ** decimals());
574         emit UpdatedMaxWalletAmount(maxWalletAmount);
575     }
576 
577     // change the minimum amount of tokens to sell from fees
578     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
579   	    require(newAmount >= totalSupply() * 1 / 100000);
580   	    require(newAmount <= totalSupply() * 1 / 1000);
581   	    swapTokensAtAmount = newAmount;
582   	}
583     
584     function _excludeFromMaxTransaction(address updAds, bool isExcluded) private {
585         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
586         emit MaxTransactionExclusion(updAds, isExcluded);
587     }
588 
589     function airdropToWallets(address[] memory wallets, uint256[] memory amountsInTokens) external onlyOwner {
590         require(wallets.length == amountsInTokens.length);
591         require(wallets.length < 600); // allows for airdrop + launch at the same exact time, reducing delays and reducing sniper input.
592         for(uint256 i = 0; i < wallets.length; i++){
593             super._transfer(msg.sender, wallets[i], amountsInTokens[i]);
594         }
595     }
596     
597     function excludeFromMaxTransaction(address updAds, bool isEx) external onlyOwner {
598         if(!isEx){
599             require(updAds != lpPair, "Cannot remove uniswap pair from max txn");
600         }
601         _isExcludedMaxTransactionAmount[updAds] = isEx;
602     }
603 
604     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
605         require(pair != lpPair, "The pair cannot be removed from automatedMarketMakerPairs");
606 
607         _setAutomatedMarketMakerPair(pair, value);
608         emit SetAutomatedMarketMakerPair(pair, value);
609     }
610 
611     function _setAutomatedMarketMakerPair(address pair, bool value) private {
612         automatedMarketMakerPairs[pair] = value;
613         
614         _excludeFromMaxTransaction(pair, value);
615 
616         emit SetAutomatedMarketMakerPair(pair, value);
617     }
618 
619     function updateBuyFees(uint256 _operationsFee, uint256 _liquidityFee, uint256 _lotteryFee) external onlyOwner {
620         buyOperationsFee = _operationsFee;
621         buyLiquidityFee = _liquidityFee;
622         buyLotteryFee = _lotteryFee;
623         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyLotteryFee;
624         require(buyTotalFees <= 1500, "Must keep fees at 15% or less");
625     }
626 
627     function updateSellFees(uint256 _operationsFee, uint256 _liquidityFee, uint256 _lotteryFee) external onlyOwner {
628         sellOperationsFee = _operationsFee;
629         sellLiquidityFee = _liquidityFee;
630         sellLotteryFee = _lotteryFee;
631         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellLotteryFee;
632         require(sellTotalFees <= 2000, "Must keep fees at 20% or less");
633     }
634 
635     function excludeFromFees(address account, bool excluded) public onlyOwner {
636         _isExcludedFromFees[account] = excluded;
637         emit ExcludeFromFees(account, excluded);
638     }
639 
640     function _transfer(address from, address to, uint256 amount) internal override {
641 
642         require(from != address(0), "ERC20: transfer from the zero address");
643         require(to != address(0), "ERC20: transfer to the zero address");
644         require(amount > 0, "ERC20: transfer must be greater than 0");
645         
646         if(!tradingActive){
647             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
648         }
649 
650         if(!earlyBuyPenaltyInEffect() && blockForPenaltyEnd > 0){
651             require(!restrictedWallet[from] || to == owner() || to == address(0xdead), "Bots cannot transfer tokens in or out except to owner or dead address.");
652         }
653         
654         if(limitsInEffect){
655             if (from != owner() && to != owner() && to != address(0) && to != address(0xdead) && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]){
656                                
657                 //when buy
658                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
659                         require(amount <= maxBuyAmount);
660                         require(amount + balanceOf(to) <= maxWalletAmount);
661                 } 
662                 //when sell
663                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
664                         require(amount <= maxSellAmount);
665                 } 
666                 else if (!_isExcludedMaxTransactionAmount[to]){
667                     require(amount + balanceOf(to) <= maxWalletAmount);
668                 }
669             }
670         }
671 
672         uint256 contractTokenBalance = balanceOf(address(this));
673         
674         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
675 
676         if(canSwap && swapEnabled && !swapping && !automatedMarketMakerPairs[from] && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
677             swapping = true;
678             swapBack();
679             swapping = false;
680         }
681 
682         if(lotteryEnabled){
683             if(block.timestamp >= nextLotteryTime && address(this).balance >= 0.25 ether && buyerList.length() > 1){
684                 payoutRewards(to);
685             }
686             else {
687                 gasBurn();
688             }
689         }
690 
691         bool takeFee = true;
692         // if any account belongs to _isExcludedFromFee account then remove the fee
693         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
694             takeFee = false;
695         }
696         
697         uint256 fees = 0;
698         // only take fees on buys/sells, do not take on wallet transfers
699         if(takeFee){
700             // bot/sniper penalty.
701             if((earlyBuyPenaltyInEffect() || (amount >= maxBuyAmount - .9 ether && blockForPenaltyEnd + 5 >= block.number)) && automatedMarketMakerPairs[from] && !automatedMarketMakerPairs[to] && buyTotalFees > 0){
702                 
703                 if(!earlyBuyPenaltyInEffect()){
704                     // reduce by 1 wei per max buy over what Uniswap will allow to revert bots as best as possible to limit erroneously blacklisted wallets. First bot will get in and be blacklisted, rest will be reverted (*cross fingers*)
705                     maxBuyAmount -= 1;
706                 }
707 
708                 if(!restrictedWallet[to]){
709                     restrictedWallet[to] = true;
710                     botsCaught += 1;
711                     emit CaughtBot(to);
712                 }
713 
714                 fees = amount * buyTotalFees / FEE_DENOMINATOR;
715         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
716                 tokensForOperations += fees * buyOperationsFee / buyTotalFees;
717                 tokensForLottery += fees * buyLotteryFee / buyTotalFees;
718             }
719 
720             // on sell
721             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
722                 fees = amount * sellTotalFees / FEE_DENOMINATOR;
723                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
724                 tokensForOperations += fees * sellOperationsFee / sellTotalFees;
725                 tokensForLottery += fees * sellLotteryFee / sellTotalFees;
726             }
727 
728             // on buy
729             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
730         	    fees = amount * buyTotalFees / FEE_DENOMINATOR;
731         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
732                 tokensForOperations += fees * buyOperationsFee / buyTotalFees;
733                 tokensForLottery += fees * buyLotteryFee / buyTotalFees;
734                 if(!minBuyEnforced || amount > getPurchaseAmount()){
735                     if(!buyerList.contains(to)){
736                         buyerList.add(to);
737                     }
738                 }
739             }
740             
741             if(fees > 0){    
742                 super._transfer(from, address(this), fees);
743             }
744         	
745         	amount -= fees;
746         }
747 
748         super._transfer(from, to, amount);
749 
750         if(buyerList.contains(from) && takeFee){
751             buyerList.remove(from);
752         }
753     }
754 
755     function earlyBuyPenaltyInEffect() public view returns (bool){
756         return block.number < blockForPenaltyEnd;
757     }
758 
759     // the purpose of this function is to fix Metamask gas estimation issues so it always consumes a similar amount of gas whether there is a payout or not.
760     function gasBurn() private {
761         bool success;
762         nextLotteryTime = nextLotteryTime;
763         uint256 winnings = address(this).balance / 2;
764         address winner = address(this);
765         winnings = 0;
766         (success,) = address(winner).call{value: winnings}("");
767     }
768     
769     function payoutRewards(address to) private {
770         bool success;
771         nextLotteryTime = block.timestamp + timeBetweenLotteries;
772         // get a pseudo random winner
773         address winner = buyerList.at(random(0, buyerList.length()-1, balanceOf(address(this)) + balanceOf(address(0xdead)) + balanceOf(address(to))));
774         uint256 winnings = address(this).balance * percentForLottery / 100;
775         (success,) = address(winner).call{value: winnings}("");
776         if(success){
777             emit LotteryTriggered(winnings, winner);
778         }
779     }
780 
781     function random(uint256 from, uint256 to, uint256 salty) private view returns (uint256) {
782         uint256 seed = uint256(
783             keccak256(
784                 abi.encodePacked(
785                     block.timestamp + block.difficulty +
786                     ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (block.timestamp)) +
787                     block.gaslimit +
788                     ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (block.timestamp)) +
789                     block.number +
790                     salty
791                 )
792             )
793         );
794         return seed % (to - from) + from;
795     }
796 
797     function updateLotteryTimeCooldown(uint256 timeInMinutes) external onlyOwner {
798         require(timeInMinutes >= 1 && timeInMinutes <= 1440);
799         timeBetweenLotteries = timeInMinutes * 1 minutes;
800     }
801 
802     function updatePercentForLottery(uint256 percent) external onlyOwner {
803         require(percent >= 10 && percent <= 100);
804         percentForLottery = percent;
805     }
806 
807     function updateMinBuyToTriggerReward(uint256 minBuy) external onlyOwner {
808         require(minBuy > 0);
809         minBuyAmount = minBuy;
810     }
811 
812     function setMinBuyEnforced(bool enforced) external onlyOwner {
813         minBuyEnforced = enforced;
814     }
815 
816 
817     function swapTokensForEth(uint256 tokenAmount) private {
818 
819         // generate the uniswap pair path of token -> weth
820         address[] memory path = new address[](2);
821         path[0] = address(this);
822         path[1] = dexRouter.WETH();
823 
824         _approve(address(this), address(dexRouter), tokenAmount);
825 
826         // make the swap
827         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
828             tokenAmount,
829             0, // accept any amount of ETH
830             path,
831             address(this),
832             block.timestamp
833         );
834     }
835     
836     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
837         // approve token transfer to cover all possible scenarios
838         _approve(address(this), address(dexRouter), tokenAmount);
839 
840         // add the liquidity
841         dexRouter.addLiquidityETH{value: ethAmount}(
842             address(this),
843             tokenAmount,
844             0, // slippage is unavoidable
845             0, // slippage is unavoidable
846             address(this),
847             block.timestamp
848         );
849     }
850 
851     function splitAndBurnLiquidity(uint256 percent) external onlyOwner {
852         require(percent <=50);
853         require(lastBurnTimestamp <= block.timestamp - 1 hours);
854         lastBurnTimestamp = block.timestamp;
855         uint256 lpBalance = IERC20(lpPair).balanceOf(address(this));
856         uint256 tokenBalance = balanceOf(address(this));
857         uint256 lpAmount = lpBalance * percent / 100;
858         uint256 initialEthBalance = address(this).balance;
859 
860         // approve token transfer to cover all possible scenarios
861         IERC20(lpPair).approve(address(dexRouter), lpAmount);
862 
863         // remove the liquidity
864         dexRouter.removeLiquidityETH(
865             address(this),
866             lpAmount,
867             1, // slippage is unavoidable
868             1, // slippage is unavoidable
869             address(this),
870             block.timestamp
871         );
872 
873         uint256 deltaTokenBalance = balanceOf(address(this)) - tokenBalance;
874         if(deltaTokenBalance > 0){
875             super._transfer(address(this), address(0xdead), deltaTokenBalance);
876         }
877 
878         uint256 deltaEthBalance = address(this).balance - initialEthBalance;
879 
880         if(deltaEthBalance > 0){
881             buyBackTokens(deltaEthBalance);
882         }
883     }
884 
885     function buyBackTokens(uint256 amountInWei) internal {
886         address[] memory path = new address[](2);
887         path[0] = dexRouter.WETH();
888         path[1] = address(this);
889 
890         dexRouter.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amountInWei}(
891             0,
892             path,
893             address(0xdead),
894             block.timestamp
895         );
896     }
897 
898     function swapBack() private {
899 
900         uint256 contractBalance = balanceOf(address(this));
901         uint256 totalTokensToSwap = tokensForLiquidity + tokensForOperations + tokensForLottery;
902         
903         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
904 
905         if(contractBalance > swapTokensAtAmount * 10){
906             contractBalance = swapTokensAtAmount * 10;
907         }
908 
909         bool success;
910         
911         // Halve the amount of liquidity tokens
912         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
913         
914         uint256 initialBalance = address(this).balance;
915         swapTokensForEth(contractBalance - liquidityTokens);
916         
917         uint256 ethBalance = address(this).balance - initialBalance;
918         uint256 ethForLiquidity = ethBalance;
919 
920         uint256 ethForOperations = ethBalance * tokensForOperations / (totalTokensToSwap - (tokensForLiquidity/2));
921         uint256 ethForLottery = ethBalance * tokensForLottery / (totalTokensToSwap - (tokensForLiquidity/2));
922 
923         ethForLiquidity -= ethForOperations + ethForLottery;
924             
925         tokensForLiquidity = 0;
926         tokensForOperations = 0;
927         tokensForLottery = 0;
928         
929         if(liquidityTokens > 0 && ethForLiquidity > 0){
930             addLiquidity(liquidityTokens, ethForLiquidity);
931         }
932 
933         if(ethForOperations > 0){
934             (success,) = address(operationsAddress).call{value: ethForOperations}("");
935         }
936         // remaining tokens stay for Lottery
937     }
938 
939     function getPurchaseAmount() public view returns (uint256){
940         address[] memory path = new address[](2);
941         path[0] = dexRouter.WETH();
942         path[1] = address(this);
943         
944         uint256[] memory amounts = new uint256[](2);
945         amounts = dexRouter.getAmountsOut(minBuyAmount, path);
946         return amounts[1];
947     }
948 
949     function transferForeignToken(address _token, address _to) external onlyOwner returns (bool _sent) {
950         require(_token != address(0));
951         require(_token != address(this));
952         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
953         _sent = IERC20(_token).transfer(_to, _contractBalance);
954         emit TransferForeignToken(_token, _contractBalance);
955     }
956 
957     // withdraw ETH if stuck
958     function withdrawStuckETH() external onlyOwner {
959         bool success;
960         (success,) = address(owner()).call{value: address(this).balance}("");
961     }
962 
963     function setOperationsAddress(address _operationsAddress) external onlyOwner {
964         require(_operationsAddress != address(0));
965         operationsAddress = payable(_operationsAddress);
966     }
967 
968     // force Swap back if slippage issues.
969     function forceSwapBack() external onlyOwner {
970         require(balanceOf(address(this)) >= swapTokensAtAmount, "Can only swap when token amount is at or higher than restriction");
971         swapping = true;
972         swapBack();
973         swapping = false;
974         emit OwnerForcedSwapBack(block.timestamp);
975     }
976 }