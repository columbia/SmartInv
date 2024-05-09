1 /**
2 
3 https://medium.com/@humanrace100/the-truth-f1979f4eecda
4 
5 */
6 
7 // SPDX-License-Identifier: MIT
8 pragma solidity ^0.8.0;
9 abstract contract Context {
10     function _msgSender() internal view virtual returns (address) {
11         return msg.sender;
12     }
13 
14     function _msgData() internal view virtual returns (bytes calldata) {
15         return msg.data;
16     }
17 }
18 
19 
20 interface IERC20 {
21     
22     function totalSupply() external view returns (uint256);
23    
24     function balanceOf(address account) external view returns (uint256);
25    
26     function transfer(address recipient, uint256 amount) external returns (bool);
27    
28     function allowance(address owner, address spender) external view returns (uint256);
29  
30     function approve(address spender, uint256 amount) external returns (bool);
31 
32     function transferFrom(address sender,address recipient,uint256 amount) external returns (bool); 
33     event Transfer(address indexed from, address indexed to, uint256 value);
34 
35     event Approval(address indexed owner, address indexed spender, uint256 value);
36 }
37 
38 library Address {
39 
40     function isContract(address account) internal view returns (bool) {
41         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
42         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
43         // for accounts without code, i.e. `keccak256('')`
44         bytes32 codehash;
45         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
46         // solhint-disable-next-line no-inline-assembly
47         assembly { codehash := extcodehash(account) }
48         return (codehash != accountHash && codehash != 0x0);
49     }
50 
51     function sendValue(address payable recipient, uint256 amount) internal {
52         require(address(this).balance >= amount, "Address: insufficient balance");
53 
54         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
55         (bool success, ) = recipient.call{ value: amount }("");
56         require(success, "Address: unable to send value, recipient may have reverted");
57     }
58 
59 
60     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
61       return functionCall(target, data, "Address: low-level call failed");
62     }
63 
64     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
65         return _functionCallWithValue(target, data, 0, errorMessage);
66     }
67 
68     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
69         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
70     }
71 
72     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
73         require(address(this).balance >= value, "Address: insufficient balance for call");
74         return _functionCallWithValue(target, data, value, errorMessage);
75     }
76 
77     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
78         require(isContract(target), "Address: call to non-contract");
79 
80         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
81         if (success) {
82             return returndata;
83         } else {
84             
85             if (returndata.length > 0) {
86                 assembly {
87                     let returndata_size := mload(returndata)
88                     revert(add(32, returndata), returndata_size)
89                 }
90             } else {
91                 revert(errorMessage);
92             }
93         }
94     }
95 }
96 
97 
98 abstract contract Ownable is Context {
99     address private _owner;
100 
101     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
102 
103     /**
104      * @dev Initializes the contract setting the deployer as the initial owner.
105      */
106     constructor() {
107         _setOwner(_msgSender());
108     }
109 
110     /**
111      * @dev Returns the address of the current owner.
112      */
113     function owner() public view virtual returns (address) {
114         return _owner;
115     }
116 
117     /**
118      * @dev Throws if called by any account other than the owner.
119      */
120     modifier onlyOwner() {
121         require(owner() == _msgSender(), "Ownable: caller is not the owner");
122         _;
123     }
124 
125     /**
126      * @dev Leaves the contract without owner. It will not be possible to call
127      * `onlyOwner` functions anymore. Can only be called by the current owner.
128      *
129      * NOTE: Renouncing ownership will leave the contract without an owner,
130      * thereby removing any functionality that is only available to the owner.
131      */
132     function renounceOwnership() public virtual onlyOwner {
133         _setOwner(address(0));
134     }
135 
136     /**
137      * @dev Transfers ownership of the contract to a new account (`newOwner`).
138      * Can only be called by the current owner.
139      */
140     function transferOwnership(address newOwner) public virtual onlyOwner {
141         require(newOwner != address(0), "Ownable: new owner is the zero address");
142         _setOwner(newOwner);
143     }
144 
145     function _setOwner(address newOwner) private {
146         address oldOwner = _owner;
147         _owner = newOwner;
148         emit OwnershipTransferred(oldOwner, newOwner);
149     }
150 }
151 
152 
153 
154 
155 contract HUMANRACE is Context,IERC20, Ownable{
156     using Address for address;
157 
158     string private _name = "HUMAN RACE";
159     string private _symbol = "HU";
160     uint8 private _decimals = 18;
161     uint256 totalFeeFortx = 0;
162     uint256 maxWalletTreshold = 2;
163     uint256 maxTxTreshold = 2;
164     uint256 private swapTreshold =2;
165     bool public limitsInEffect = true;
166 
167     uint256 private currentThreshold = 20; //Once the token value goes up this number can be decreased (To reduce price impact on asset)
168     uint256 private _totalSupply = 1_000_000_000 * 10**_decimals; 
169     uint256 public requiredTokensToSwap = _totalSupply * swapTreshold /1000;
170     mapping (address => uint256) private _balances;
171     mapping (address => bool) private _excludedFromFees;
172     mapping (address => mapping (address => uint256)) private _allowances;
173     mapping (address => bool) _isExcludedMaxTransactionAmount;
174     mapping (address => bool) public automatedMarketMakerPairs;
175     address _owner;
176     address payable public marketingAddress = payable(0xbd0C4634b094275F90bc3376Dd79a3156D5282E3);
177     
178     uint256 maxWalletAmount = _totalSupply*maxWalletTreshold/100; 
179     uint256 maxTxAmount = _totalSupply*maxTxTreshold/100;
180     mapping (address => bool) botWallets;
181     bool botTradeEnabled = false;
182     bool checkWalletSize = true;
183     mapping (address => bool) private _liquidityHolders;
184     mapping (address => bool) private presaleAddresses;
185     uint256 private buyliqFee = 2; 
186     uint256 private buyprevLiqFee = 2;
187     uint256 private buymktFee = 5;
188     uint256 private buyPrevmktFee = 5;
189     
190     
191     bool private tradeEnabled = false;
192 
193     
194     uint256 private sellliqFee = 95;
195     uint256 private sellprevLiqFee = 95;
196     uint256 private sellmktFee = 5;
197     uint256 private sellPrevmktFee = 5;
198 
199 
200     bool public inSwapAndLiquify;
201     bool public swapAndLiquifyEnabled = true;
202     address public immutable deadAddress = 0x000000000000000000000000000000000000dEaD;
203     uint256 private mktTokens = 0;
204   
205     uint256 private liqTokens = 0;
206 
207     
208     event SwapAndLiquify(uint256 tokensSwapped,
209 		uint256 ethReceived,
210 		uint256 tokensIntoLiquidity
211 	);
212     event tokensSwappedDuringTokenomics(uint256 amount);
213     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
214     
215     // 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
216     IUniswapV2Router02 _router;
217     address public uniswapV2Pair;
218 
219     //Balances tracker
220 
221     modifier lockTheSwap{
222 		inSwapAndLiquify = true;
223 		_;
224 		inSwapAndLiquify = false;
225 	}
226     
227 
228     constructor(){
229         _balances[_msgSender()] = _totalSupply;
230         //0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D mainnet and all networks
231         IUniswapV2Router02 _uniRouter = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
232         
233         uniswapV2Pair = IUniswapV2Factory(_uniRouter.factory())
234             .createPair(address(this), _uniRouter.WETH());
235         
236         _excludedFromFees[owner()] = true;         
237         _excludedFromFees[address(this)] = true;// exclude owner and contract instance from fees
238         _router = _uniRouter;
239         _liquidityHolders[address(_router)] = true;
240         _liquidityHolders[owner()] = true;
241         _liquidityHolders[address(this)] = true;
242         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
243         emit Transfer(address(0),_msgSender(),_totalSupply);
244  
245     }
246     receive() external payable{}
247 
248 
249     //general token data and tracking of balances to be swapped.
250     function getOwner()external view returns(address){
251             return owner();
252     }
253     function currentmktTokens() external view returns (uint256){
254             return mktTokens;
255      }
256    
257      function currentLiqTokens() external view returns (uint256){
258             return liqTokens;
259      }
260 
261      function totalSupply() external view override returns (uint256){
262             return _totalSupply;
263      }
264    
265     function balanceOf(address account) public view override returns (uint256){
266         return _balances[account];
267     }
268    
269     function transfer(address recipient, uint256 amount) external override returns (bool){
270             _transfer(_msgSender(),recipient,amount);
271             return true;
272 
273     }
274    
275     function allowance(address owner, address spender) external view override returns (uint256){
276             return _allowances[owner][spender];
277     }
278  
279     function approve(address spender, uint256 amount) external override returns (bool){
280             _approve(_msgSender(),spender,amount);
281             return true;
282     }
283     function removeLimits() public onlyOwner{
284         limitsInEffect = false;
285     }
286 
287     function decimals()external view returns(uint256){
288         return _decimals;
289     }
290     function name() external view returns (string memory) {
291 		return _name;
292 	}
293     function symbol() external view returns (string memory){
294         return _symbol;
295     }
296         function updateMaxTxTreshold(uint256 newVal) public onlyOwner{
297         maxTxTreshold = newVal;
298         maxTxAmount = _totalSupply*maxTxTreshold/100;// 1%
299 
300     }
301      function updateMaxWalletTreshold(uint256 newVal) public onlyOwner{
302         maxWalletTreshold = newVal;
303         maxWalletAmount = _totalSupply*maxWalletTreshold/100;
304 
305     }
306     
307 
308     function transferFrom(
309         address sender,
310         address recipient,
311         uint256 amount
312     ) public override returns (bool){
313         require(amount <= _allowances[sender][_msgSender()], "ERC20: transfer amount exceeds allowance");
314 		_transfer(sender, recipient, amount);
315 		_approve(sender, _msgSender(), _allowances[sender][_msgSender()] - amount);
316 		return true;
317     }
318 
319     function addBotWallet (address payable detectedBot, bool isBot) public onlyOwner{
320         botWallets[detectedBot] = isBot;
321     }
322     function currentbuyliqFee() public view returns (uint256){
323             return buyliqFee;
324     }
325     function currentbuymktfee() public view returns (uint256){
326             return buymktFee;
327     }
328    
329 
330       function currentsellLiqFee() public view returns (uint256){
331             return sellliqFee;
332     }
333     function currentsellmktfee() public view returns (uint256){
334             return sellmktFee;
335     }
336     
337     function currentThresholdInt()public view returns (uint256){
338         return currentThreshold;
339     }
340     function isExcluded(address toCheck)public view returns (bool){
341             return _excludedFromFees[toCheck];
342     }
343 
344     function _transfer(address from, address to, uint256 amount) internal{
345         
346         require(from != address(0), "ERC20: transfer from the zero address");
347 		require(to != address(0), "ERC20: transfer to the zero address");
348         require(amount > 0,"ERC20: transfered amount must be greater than zero");
349         uint256 senderBalance = _balances[from];
350         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
351         if(tradeEnabled == false){
352             require(_liquidityHolders[to] || _liquidityHolders[from],"Cant trade, trade is disabled");
353         }
354         
355        
356          
357           if(limitsInEffect){
358             if (
359                 from != owner() &&
360                 to != owner() &&
361                 to != address(0) &&
362                 to != address(0xdead)
363             ){
364 
365                 
366                 //when buy
367                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
368                     require(amount <= maxTxAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
369                     require(amount + balanceOf(to) <= maxWalletAmount, "Unable to exceed Max Wallet");
370                     
371 
372                 } 
373                 //when sell
374                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
375                     require(amount <= maxTxAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
376                 }
377                 else if(!_isExcludedMaxTransactionAmount[to]) {
378                     require(amount + balanceOf(to) <= maxWalletAmount, "Unable to exceed Max Wallet");
379                 }
380             }
381         }
382          uint256 inContractBalance = balanceOf(address(this));
383 
384         if(inContractBalance >=requiredTokensToSwap && 
385 			!inSwapAndLiquify && 
386 			from != uniswapV2Pair && 
387 			swapAndLiquifyEnabled){
388                 if(inContractBalance >= requiredTokensToSwap ){
389                     inContractBalance = requiredTokensToSwap;
390                     swapForTokenomics(inContractBalance);
391                 }
392             }
393 
394             bool takeFees = true;
395             
396             
397             if(_excludedFromFees[from] || _excludedFromFees[to]) {
398                 totalFeeFortx = 0;
399                 takeFees = false;
400                
401 
402             }
403             uint256 mktAmount = 0;
404            
405 		    uint256 liqAmount = 0;  // Amount to be added to liquidity.
406 
407             if(takeFees){
408                 
409                 //bot fees
410                 if(botWallets[from] == true||botWallets[to]==true){
411                     revert("No bots allowed to trade");
412                 }
413                 //Selling fees
414                 if (automatedMarketMakerPairs[to] && to != address(_router) ){
415                         totalFeeFortx = 0;
416                         mktAmount = amount * sellmktFee/100;
417                         liqAmount = amount * sellliqFee/100;
418                         
419                         totalFeeFortx = mktAmount + liqAmount ;
420                 }
421                 //Buy Fees
422                 else if(automatedMarketMakerPairs[from] && from != address(_router)) {
423                     
424                     totalFeeFortx = 0;
425                     mktAmount = amount * buymktFee/100;
426                     liqAmount = amount * buyliqFee/100;
427                     
428                     totalFeeFortx = mktAmount + liqAmount ;
429                 }
430 
431                 
432             }
433 
434             _balances[from] = senderBalance - amount;
435             _balances[to] += amount - mktAmount - liqAmount;
436 
437           if(liqAmount != 0) {
438 			_balances[address(this)] += totalFeeFortx;
439 			//tLiqTotal += liqAmount;
440             liqTokens += liqAmount;
441             mktTokens += mktAmount;
442 			emit Transfer(from, address(this), totalFeeFortx);
443             
444 		    }
445             emit Transfer(from, to,amount-totalFeeFortx);
446             
447         
448     }
449     function swapForTokenomics(uint256 balanceToswap) private lockTheSwap{
450         swapAndLiquify(liqTokens);
451         swapTokensForETHmkt(mktTokens);
452         emit tokensSwappedDuringTokenomics(balanceToswap);
453         mktTokens = 0;
454         liqTokens = 0;
455     }
456      function addLimitExempt(address newAddress)external onlyOwner{
457         _liquidityHolders[newAddress] = true;
458      
459     }
460     function swapTokensForETHmkt(uint256 amount)private {
461         address[] memory path = new address[](2);
462 		path[0] = address(this);
463 		path[1] = _router.WETH();
464 		_approve(address(this), address(_router), amount);
465 
466 		
467 		_router.swapExactTokensForETHSupportingFeeOnTransferTokens(
468 			amount,
469 			0, // Accept any amount of ETH.
470 			path,
471 			marketingAddress,
472 			block.timestamp
473 		);
474 
475     }
476   
477 
478 
479     function unstuckTokens (IERC20 tokenToClear, address payable destination, uint256 amount) public onlyOwner{
480         //uint256 contractBalance = tokenToClear.balanceOf(address(this));
481         tokenToClear.transfer(destination, amount);
482     }
483 
484     function unstuckETH(address payable destination) public onlyOwner{
485         uint256 ethBalance = address(this).balance;
486         payable(destination).transfer(ethBalance);
487     }
488 
489     function tradeStatus(bool status) public onlyOwner{
490         tradeEnabled = status;
491     }
492 
493     function swapAndLiquify(uint256 liqTokensPassed) private {
494 		uint256 half = liqTokensPassed / 2;
495 		uint256 otherHalf = liqTokensPassed - half;
496 		uint256 initialBalance = address(this).balance;
497 
498 		swapTokensForETH(half);
499 		uint256 newBalance = address(this).balance - (initialBalance); 
500 
501 		addLiquidity(otherHalf, newBalance);
502 		emit SwapAndLiquify(half,newBalance,otherHalf);
503 	}
504 
505     function swapTokensForETH(uint256 tokenAmount) private{
506 		address[] memory path = new address[](2);
507 		path[0] = address(this);
508 		path[1] = _router.WETH();
509 		_approve(address(this), address(_router), tokenAmount);
510 
511 		
512 		_router.swapExactTokensForETHSupportingFeeOnTransferTokens(
513 			tokenAmount,
514 			0, // Accept any amount of ETH.
515 			path,
516 			address(this),
517 			block.timestamp
518 		);
519 	}
520     
521     function addLiquidity(uint256 tokenAmount,uint256 ethAmount) private{
522 		_approve(address(this), address(_router), tokenAmount);
523 
524 		_router.addLiquidityETH{value:ethAmount}(
525 			address(this),
526 			tokenAmount,
527 			0,
528 			0,
529 			deadAddress,// tr
530 			block.timestamp
531 		);
532 	}
533 
534     function _approve(address owner,address spender, uint256 amount) internal{
535         require(owner != address(0), "ERC20: approve from the zero address");
536 		require(spender != address(0), "ERC20: approve to the zero address");
537 
538 		_allowances[owner][spender] = amount;
539 		emit Approval(owner, spender, amount);
540 
541 
542     }
543 
544 
545 
546 
547     //Fees related functions
548 
549     function addToExcluded(address toExclude) public onlyOwner{  
550         _excludedFromFees[toExclude] = true;
551     }
552 
553     function removeFromExcluded(address toRemove) public onlyOwner{
554         _excludedFromFees[toRemove] = false;
555     }
556       function excludePresaleAddresses(address router, address presale) external onlyOwner {
557         
558         _liquidityHolders[address(router)] = true;
559         _liquidityHolders[presale] = true;
560         presaleAddresses[address(router)] = true;
561         presaleAddresses[presale] = true;
562        
563     }
564 
565     function startPresaleStatus()public onlyOwner{
566         
567         buymktFee = 5;
568         sellmktFee =5;
569         buyliqFee =2;
570         sellliqFee =2;
571         
572         setSwapAndLiquify(false);
573 
574     }
575     function endPresaleStatus() public onlyOwner{
576         buymktFee = 5;
577         buyliqFee = 2;
578       
579 
580         sellmktFee = 5;
581         sellliqFee = 2;
582         
583         setSwapAndLiquify(true);
584     }
585 
586     function updateThreshold(uint newThreshold) public onlyOwner{
587         currentThreshold = newThreshold;
588 
589     }
590 
591     function setSwapAndLiquify(bool _enabled) public onlyOwner{
592             swapAndLiquifyEnabled = _enabled;
593     }
594 
595 
596     //Marketing related 
597 
598     function setMktAddress(address newAddress) external onlyOwner{
599         marketingAddress = payable(newAddress);
600     }
601    
602     function transferAssetsETH(address payable to, uint256 amount) internal{
603             to.transfer(amount);
604     }
605    
606     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
607         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
608         _setAutomatedMarketMakerPair(pair, value);
609     }
610     function _setAutomatedMarketMakerPair(address pair, bool value) private {
611         automatedMarketMakerPairs[pair] = value;
612 
613         emit SetAutomatedMarketMakerPair(pair, value);
614     }
615 
616     function updatecurrentbuyliqFee(uint256 newAmount) public onlyOwner{
617             buyliqFee = newAmount;
618     }
619     function updatecurrentbuymktfee(uint256 newAmount) public onlyOwner{
620              buymktFee= newAmount;
621     }
622    
623 
624       function updatecurrentsellLiqFee(uint256 newAmount) public onlyOwner{
625              sellliqFee= newAmount;
626     }
627     function updatecurrentsellmktfee(uint256 newAmount)public onlyOwner{
628              sellmktFee= newAmount;
629     }
630     
631   
632     function currentMaxWallet() public view returns(uint256){
633         return maxWalletAmount;
634     }
635     function currentMaxTx() public view returns(uint256){
636         return maxTxAmount;
637     }
638     function updateSwapTreshold(uint256 newVal) public onlyOwner{
639         swapTreshold = newVal;
640         requiredTokensToSwap = _totalSupply*swapTreshold/1000;
641         
642     }
643     function currentTradeStatus() public view returns (bool){
644         return tradeEnabled;   
645     }
646     function currentSwapTreshold() public view returns(uint256){
647         return swapTreshold;
648     }
649     function currentTokensToSwap() public view returns(uint256){
650         return requiredTokensToSwap;
651     }
652 }
653 
654 
655 interface IUniswapV2Factory {
656     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
657     function feeTo() external view returns (address);
658     function feeToSetter() external view returns (address);
659     function getPair(address tokenA, address tokenB) external view returns (address pair);
660     function allPairs(uint) external view returns (address pair);
661     function allPairsLength() external view returns (uint);
662     function createPair(address tokenA, address tokenB) external returns (address pair);
663     function setFeeTo(address) external;
664     function setFeeToSetter(address) external;
665 }
666 
667 interface IUniswapV2Pair {
668     event Approval(address indexed owner, address indexed spender, uint value);
669     event Transfer(address indexed from, address indexed to, uint value);
670     function name() external pure returns (string memory);
671     function symbol() external pure returns (string memory);
672     function decimals() external pure returns (uint8);
673     function totalSupply() external view returns (uint);
674     function balanceOf(address owner) external view returns (uint);
675     function allowance(address owner, address spender) external view returns (uint);
676     function approve(address spender, uint value) external returns (bool);
677     function transfer(address to, uint value) external returns (bool);
678     function transferFrom(address from, address to, uint value) external returns (bool);
679     function DOMAIN_SEPARATOR() external view returns (bytes32);
680     function PERMIT_TYPEHASH() external pure returns (bytes32);
681     function nonces(address owner) external view returns (uint);
682     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
683     event Mint(address indexed sender, uint amount0, uint amount1);
684     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
685     event Swap(
686         address indexed sender,
687         uint amount0In,
688         uint amount1In,
689         uint amount0Out,
690         uint amount1Out,
691         address indexed to
692     );
693     event Sync(uint112 reserve0, uint112 reserve1);
694     function MINIMUM_LIQUIDITY() external pure returns (uint);
695     function factory() external view returns (address);
696     function token0() external view returns (address);
697     function token1() external view returns (address);
698     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
699     function price0CumulativeLast() external view returns (uint);
700     function price1CumulativeLast() external view returns (uint);
701     function kLast() external view returns (uint);
702     function mint(address to) external returns (uint liquidity);
703     function burn(address to) external returns (uint amount0, uint amount1);
704     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
705     function skim(address to) external;
706     function sync() external;
707     function initialize(address, address) external;
708 }
709 
710 interface IUniswapV2Router01 {
711     function factory() external pure returns (address);
712     function WETH() external pure returns (address);
713     function addLiquidity(
714         address tokenA,
715         address tokenB,
716         uint amountADesired,
717         uint amountBDesired,
718         uint amountAMin,
719         uint amountBMin,
720         address to,
721         uint deadline
722     ) external returns (uint amountA, uint amountB, uint liquidity);
723     function addLiquidityETH(
724         address token,
725         uint amountTokenDesired,
726         uint amountTokenMin,
727         uint amountETHMin,
728         address to,
729         uint deadline
730     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
731     function removeLiquidity(
732         address tokenA,
733         address tokenB,
734         uint liquidity,
735         uint amountAMin,
736         uint amountBMin,
737         address to,
738         uint deadline
739     ) external returns (uint amountA, uint amountB);
740     function removeLiquidityETH(
741         address token,
742         uint liquidity,
743         uint amountTokenMin,
744         uint amountETHMin,
745         address to,
746         uint deadline
747     ) external returns (uint amountToken, uint amountETH);
748     function removeLiquidityWithPermit(
749         address tokenA,
750         address tokenB,
751         uint liquidity,
752         uint amountAMin,
753         uint amountBMin,
754         address to,
755         uint deadline,
756         bool approveMax, uint8 v, bytes32 r, bytes32 s
757     ) external returns (uint amountA, uint amountB);
758     function removeLiquidityETHWithPermit(
759         address token,
760         uint liquidity,
761         uint amountTokenMin,
762         uint amountETHMin,
763         address to,
764         uint deadline,
765         bool approveMax, uint8 v, bytes32 r, bytes32 s
766     ) external returns (uint amountToken, uint amountETH);
767     function swapExactTokensForTokens(
768         uint amountIn,
769         uint amountOutMin,
770         address[] calldata path,
771         address to,
772         uint deadline
773     ) external returns (uint[] memory amounts);
774     function swapTokensForExactTokens(
775         uint amountOut,
776         uint amountInMax,
777         address[] calldata path,
778         address to,
779         uint deadline
780     ) external returns (uint[] memory amounts);
781     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
782         external
783         payable
784         returns (uint[] memory amounts);
785     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
786         external
787         returns (uint[] memory amounts);
788     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
789         external
790         returns (uint[] memory amounts);
791     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
792         external
793         payable
794         returns (uint[] memory amounts);
795 
796     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
797     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
798     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
799     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
800     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
801 }
802 
803 interface IUniswapV2Router02 is IUniswapV2Router01 {
804     function removeLiquidityETHSupportingFeeOnTransferTokens(
805         address token,
806         uint liquidity,
807         uint amountTokenMin,
808         uint amountETHMin,
809         address to,
810         uint deadline
811     ) external returns (uint amountETH);
812     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
813         address token,
814         uint liquidity,
815         uint amountTokenMin,
816         uint amountETHMin,
817         address to,
818         uint deadline,
819         bool approveMax, uint8 v, bytes32 r, bytes32 s
820     ) external returns (uint amountETH);
821 
822     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
823         uint amountIn,
824         uint amountOutMin,
825         address[] calldata path,
826         address to,
827         uint deadline
828     ) external;
829     function swapExactETHForTokensSupportingFeeOnTransferTokens(
830         uint amountOutMin,
831         address[] calldata path,
832         address to,
833         uint deadline
834     ) external payable;
835     function swapExactTokensForETHSupportingFeeOnTransferTokens(
836         uint amountIn,
837         uint amountOutMin,
838         address[] calldata path,
839         address to,
840         uint deadline
841     ) external;
842 }