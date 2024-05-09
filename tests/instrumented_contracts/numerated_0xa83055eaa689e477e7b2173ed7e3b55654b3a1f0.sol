1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 abstract contract Context {
4     function _msgSender() internal view virtual returns (address) {
5         return msg.sender;
6     }
7 
8     function _msgData() internal view virtual returns (bytes calldata) {
9         return msg.data;
10     }
11 }
12 
13 
14 interface IERC20 {
15     
16     function totalSupply() external view returns (uint256);
17    
18     function balanceOf(address account) external view returns (uint256);
19    
20     function transfer(address recipient, uint256 amount) external returns (bool);
21    
22     function allowance(address owner, address spender) external view returns (uint256);
23  
24     function approve(address spender, uint256 amount) external returns (bool);
25 
26     function transferFrom(address sender,address recipient,uint256 amount) external returns (bool); 
27     event Transfer(address indexed from, address indexed to, uint256 value);
28 
29     event Approval(address indexed owner, address indexed spender, uint256 value);
30 }
31 
32 library Address {
33 
34     function isContract(address account) internal view returns (bool) {
35         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
36         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
37         // for accounts without code, i.e. `keccak256('')`
38         bytes32 codehash;
39         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
40         // solhint-disable-next-line no-inline-assembly
41         assembly { codehash := extcodehash(account) }
42         return (codehash != accountHash && codehash != 0x0);
43     }
44 
45     function sendValue(address payable recipient, uint256 amount) internal {
46         require(address(this).balance >= amount, "Address: insufficient balance");
47 
48         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
49         (bool success, ) = recipient.call{ value: amount }("");
50         require(success, "Address: unable to send value, recipient may have reverted");
51     }
52 
53 
54     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
55       return functionCall(target, data, "Address: low-level call failed");
56     }
57 
58     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
59         return _functionCallWithValue(target, data, 0, errorMessage);
60     }
61 
62     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
63         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
64     }
65 
66     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
67         require(address(this).balance >= value, "Address: insufficient balance for call");
68         return _functionCallWithValue(target, data, value, errorMessage);
69     }
70 
71     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
72         require(isContract(target), "Address: call to non-contract");
73 
74         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
75         if (success) {
76             return returndata;
77         } else {
78             
79             if (returndata.length > 0) {
80                 assembly {
81                     let returndata_size := mload(returndata)
82                     revert(add(32, returndata), returndata_size)
83                 }
84             } else {
85                 revert(errorMessage);
86             }
87         }
88     }
89 }
90 
91 
92 abstract contract Ownable is Context {
93     address private _owner;
94 
95     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
96 
97     /**
98      * @dev Initializes the contract setting the deployer as the initial owner.
99      */
100     constructor() {
101         _setOwner(_msgSender());
102     }
103 
104     /**
105      * @dev Returns the address of the current owner.
106      */
107     function owner() public view virtual returns (address) {
108         return _owner;
109     }
110 
111     /**
112      * @dev Throws if called by any account other than the owner.
113      */
114     modifier onlyOwner() {
115         require(owner() == _msgSender(), "Ownable: caller is not the owner");
116         _;
117     }
118 
119     /**
120      * @dev Leaves the contract without owner. It will not be possible to call
121      * `onlyOwner` functions anymore. Can only be called by the current owner.
122      *
123      * NOTE: Renouncing ownership will leave the contract without an owner,
124      * thereby removing any functionality that is only available to the owner.
125      */
126     function renounceOwnership() public virtual onlyOwner {
127         _setOwner(address(0));
128     }
129 
130     /**
131      * @dev Transfers ownership of the contract to a new account (`newOwner`).
132      * Can only be called by the current owner.
133      */
134     function transferOwnership(address newOwner) public virtual onlyOwner {
135         require(newOwner != address(0), "Ownable: new owner is the zero address");
136         _setOwner(newOwner);
137     }
138 
139     function _setOwner(address newOwner) private {
140         address oldOwner = _owner;
141         _owner = newOwner;
142         emit OwnershipTransferred(oldOwner, newOwner);
143     }
144 }
145 
146 
147 
148 
149 contract SheebaInu is Context,IERC20, Ownable{
150     using Address for address;
151 
152     string private _name = "Sheeba Inu";
153     string private _symbol = "SHEEB";
154     uint8 private _decimals = 18;
155     uint256 totalFeeFortx = 0;
156       uint256 maxWalletTreshold = 5;
157     uint256 maxTxTreshold = 5;
158     uint256 private swapTreshold =2;
159 
160     uint256 private currentThreshold = 20; //Once the token value goes up this number can be decreased (To reduce price impact on asset)
161     uint256 private _totalSupply = (100000000 * 10**4) * 10**_decimals; //1T supply
162     uint256 public requiredTokensToSwap = _totalSupply * swapTreshold /1000;
163     mapping (address => uint256) private _balances;
164     mapping (address => bool) private _excludedFromFees;
165     mapping (address => mapping (address => uint256)) private _allowances;
166     mapping (address => bool) public automatedMarketMakerPairs;
167     address _owner;
168     address payable public marketingAddress = payable(0x910Ad70E105224f503067DAe10b518F73B07b5cD);
169     address payable public prizePoolAddress = payable(0x0d5cC40d34243ae68519f6d10D0e0B61Cd297DFE);
170     uint256 maxWalletAmount = _totalSupply*maxWalletTreshold/100; // starting 3%
171     uint256 maxTxAmount = _totalSupply*maxTxTreshold/100;
172     mapping (address => bool) botWallets;
173     bool botTradeEnabled = false;
174     bool checkWalletSize = true;
175     mapping (address => bool) private _liquidityHolders;
176     mapping (address => bool) private presaleAddresses;
177     //15% buy tax 20% sell tax
178 
179     uint256 private buyliqFee = 0; //10
180     uint256 private buyprevLiqFee = 10;
181     uint256 private buymktFee = 0;//4
182     uint256 private buyPrevmktFee = 4;
183     uint256 private buyprizePool = 0;//1
184     uint256 private buyprevPrizePool = 1;
185     uint256 GoldenDaycooldown = 0;
186 
187     
188     uint256 private sellliqFee = 13;
189     uint256 private sellprevLiqFee = 13;
190     uint256 private sellmktFee = 5;
191     uint256 private sellPrevmktFee = 5;
192     uint256 private sellprizePool = 2;
193     uint256 private sellprevPrizePool = 2;
194 
195 
196     bool public inSwapAndLiquify;
197     bool public swapAndLiquifyEnabled = true;
198     address public immutable deadAddress = 0x000000000000000000000000000000000000dEaD;
199     uint256 private mktTokens = 0;
200     uint256 private prizepoolTokens = 0;
201     uint256 private liqTokens = 0;
202 
203     
204     event SwapAndLiquify(uint256 tokensSwapped,
205 		uint256 ethReceived,
206 		uint256 tokensIntoLiquidity
207 	);
208     event tokensSwappedDuringTokenomics(uint256 amount);
209     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
210     
211     // 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
212     IUniswapV2Router02 _router;
213     address public uniswapV2Pair;
214 
215     //Balances tracker
216 
217     modifier lockTheSwap{
218 		inSwapAndLiquify = true;
219 		_;
220 		inSwapAndLiquify = false;
221 	}
222     
223 
224     constructor(){
225         _balances[_msgSender()] = _totalSupply;
226         //0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D mainnet and all networks
227         IUniswapV2Router02 _uniRouter = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
228         
229         uniswapV2Pair = IUniswapV2Factory(_uniRouter.factory())
230             .createPair(address(this), _uniRouter.WETH());
231         
232         _excludedFromFees[owner()] = true;         
233         _excludedFromFees[address(this)] = true;// exclude owner and contract instance from fees
234         _router = _uniRouter;
235         _liquidityHolders[address(_router)] = true;
236         _liquidityHolders[owner()] = true;
237         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
238         emit Transfer(address(0),_msgSender(),_totalSupply);
239 
240 
241 
242 
243     }
244     receive() external payable{}
245 
246 
247     //general token data and tracking of balances to be swapped.
248     function getOwner()external view returns(address){
249             return owner();
250     }
251     function currentmktTokens() external view returns (uint256){
252             return mktTokens;
253      }
254      function currentPZTokens() external view returns (uint256){
255             return prizepoolTokens;
256      }
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
283 
284     function decimals()external view returns(uint256){
285         return _decimals;
286     }
287     function name() external view returns (string memory) {
288 		return _name;
289 	}
290     function symbol() external view returns (string memory){
291         return _symbol;
292     }
293         function updateMaxTxTreshold(uint256 newVal) public onlyOwner{
294         maxTxTreshold = newVal;
295         maxTxAmount = _totalSupply*maxTxTreshold/100;// 1%
296 
297     }
298      function updateMaxWalletTreshold(uint256 newVal) public onlyOwner{
299         maxWalletTreshold = newVal;
300         maxWalletAmount = _totalSupply*maxWalletTreshold/100;
301 
302     }
303     
304 
305     function transferFrom(
306         address sender,
307         address recipient,
308         uint256 amount
309     ) public override returns (bool){
310         require(amount <= _allowances[sender][_msgSender()], "BEP20: transfer amount exceeds allowance");
311 		_transfer(sender, recipient, amount);
312 		_approve(sender, _msgSender(), _allowances[sender][_msgSender()] - amount);
313 		return true;
314     }
315 
316 
317 
318     //Tokenomics related functions
319     
320     function goldenDay() public onlyOwner{
321          require(block.timestamp > GoldenDaycooldown, "You cant call golden Day more than once per day");
322          buyPrevmktFee = buymktFee;
323          buyprevLiqFee = buyliqFee;
324          buyprevPrizePool = buyprizePool;
325          
326          buyliqFee = 0;
327          buymktFee = 0;
328          buyprizePool = 0;
329     }
330     function goldenDayOver() public onlyOwner{
331          buyliqFee = buyprevLiqFee;
332          buymktFee = buyPrevmktFee;
333          buyprizePool = buyprevPrizePool;
334          GoldenDaycooldown = block.timestamp + 86400;
335     }
336 
337     function addBotWallet (address payable detectedBot, bool isBot) public onlyOwner{
338         botWallets[detectedBot] = isBot;
339     }
340     function currentbuyliqFee() public view returns (uint256){
341             return buyliqFee;
342     }
343     function currentbuymktfee() public view returns (uint256){
344             return buymktFee;
345     }
346     function currentbuyprizepoolfee() public view returns (uint256){
347             return buymktFee;
348     }
349 
350       function currentsellLiqFee() public view returns (uint256){
351             return sellliqFee;
352     }
353     function currentsellmktfee() public view returns (uint256){
354             return sellmktFee;
355     }
356     function currentsellyprizepoolfee() public view returns (uint256){
357             return sellprizePool;
358     }
359     function currentThresholdInt()public view returns (uint256){
360         return currentThreshold;
361     }
362     function isExcluded(address toCheck)public view returns (bool){
363             return _excludedFromFees[toCheck];
364     }
365 
366     function _transfer(address from, address to, uint256 amount) internal{
367         require(from != address(0), "BEP20: transfer from the zero address");
368 		require(to != address(0), "BEP20: transfer to the zero address");
369         require(amount > 0,"BEP20: transfered amount must be greater than zero");
370         uint256 senderBalance = _balances[from];
371         require(senderBalance >= amount, "BEP20: transfer amount exceeds balance");
372         if(_liquidityHolders[to]==false && _liquidityHolders[from]==false){
373         require(amount <= maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
374         }
375         uint256 inContractBalance = balanceOf(address(this));
376 
377         if(inContractBalance >=requiredTokensToSwap && 
378 			!inSwapAndLiquify && 
379 			from != uniswapV2Pair && 
380 			swapAndLiquifyEnabled){
381                 if(inContractBalance >= requiredTokensToSwap ){
382                     inContractBalance = requiredTokensToSwap;
383                     swapForTokenomics(inContractBalance);
384                 }
385             }
386 
387             bool takeFees = true;
388             
389             
390             if(_excludedFromFees[from] || _excludedFromFees[to]) {
391                 totalFeeFortx = 0;
392                 takeFees = false;
393                
394 
395             }
396             uint256 mktAmount = 0;
397             uint256 prizePoolAmount = 0; // Amount to be added to prize pool.
398 		    uint256 liqAmount = 0;  // Amount to be added to liquidity.
399 
400             if(takeFees){
401                 
402                 
403                 //bot fees
404                 if(botWallets[from] == true||botWallets[to]==true){
405                     totalFeeFortx = 0;
406                     mktAmount = amount * 15/100;
407                     liqAmount = amount * 75/100;
408                     prizePoolAmount = amount * 5/100;
409                     totalFeeFortx = mktAmount + liqAmount + prizePoolAmount;
410                 }
411                 //Selling fees
412                 if (automatedMarketMakerPairs[to] && to != address(_router) ){
413                         totalFeeFortx = 0;
414                         mktAmount = amount * sellmktFee/100;
415                         liqAmount = amount * sellliqFee/100;
416                         prizePoolAmount = amount * sellprizePool/100;
417                         totalFeeFortx = mktAmount + liqAmount + prizePoolAmount;
418                 }
419                 //Buy Fees
420                 else if(automatedMarketMakerPairs[from] && from != address(_router)) {
421                 
422                     totalFeeFortx = 0;
423                     mktAmount = amount * buymktFee/100;
424                     liqAmount = amount * buyliqFee/100;
425                     prizePoolAmount = amount * buyprizePool/100;
426                     totalFeeFortx = mktAmount + liqAmount + prizePoolAmount;
427                 }
428 
429                 
430             }
431 
432             _balances[from] = senderBalance - amount;
433             _balances[to] += amount - mktAmount - prizePoolAmount - liqAmount;
434 
435           if(liqAmount != 0) {
436 			_balances[address(this)] += totalFeeFortx;
437 			//tLiqTotal += liqAmount;
438             liqTokens += liqAmount;
439             prizepoolTokens += prizePoolAmount;
440             mktTokens += mktAmount;
441 			emit Transfer(from, address(this), totalFeeFortx);
442             
443 		    }
444             emit Transfer(from, to,amount-totalFeeFortx);
445             
446         
447     }
448     function swapForTokenomics(uint256 balanceToswap) private lockTheSwap{
449         swapAndLiquify(liqTokens);
450         swapTokensForETHmkt(mktTokens);
451         sendToPrizePool(prizepoolTokens);
452         emit tokensSwappedDuringTokenomics(balanceToswap);
453         mktTokens = 0;
454         prizepoolTokens = 0;
455         liqTokens = 0;
456     }
457      function addLimitExempt(address newAddress)external onlyOwner{
458         _liquidityHolders[newAddress] = true;
459      
460     }
461     function swapTokensForETHmkt(uint256 amount)private {
462         address[] memory path = new address[](2);
463 		path[0] = address(this);
464 		path[1] = _router.WETH();
465 		_approve(address(this), address(_router), amount);
466 
467 		
468 		_router.swapExactTokensForETHSupportingFeeOnTransferTokens(
469 			amount,
470 			0, // Accept any amount of ETH.
471 			path,
472 			marketingAddress,
473 			block.timestamp
474 		);
475 
476     }
477       function sendToPrizePool(uint256 amount)private {
478       _transfer(address(this), prizePoolAddress, amount);
479 
480     }
481     function swapAndLiquify(uint256 liqTokensPassed) private {
482 		uint256 half = liqTokensPassed / 2;
483 		uint256 otherHalf = liqTokensPassed - half;
484 		uint256 initialBalance = address(this).balance;
485 
486 		swapTokensForETH(half);
487 		uint256 newBalance = address(this).balance - (initialBalance); 
488 
489 		addLiquidity(otherHalf, newBalance);
490 		emit SwapAndLiquify(half,newBalance,otherHalf);
491 	}
492 
493     function swapTokensForETH(uint256 tokenAmount) private{
494 		address[] memory path = new address[](2);
495 		path[0] = address(this);
496 		path[1] = _router.WETH();
497 		_approve(address(this), address(_router), tokenAmount);
498 
499 		
500 		_router.swapExactTokensForETHSupportingFeeOnTransferTokens(
501 			tokenAmount,
502 			0, // Accept any amount of ETH.
503 			path,
504 			address(this),
505 			block.timestamp
506 		);
507 	}
508     
509     function addLiquidity(uint256 tokenAmount,uint256 ethAmount) private{
510 		_approve(address(this), address(_router), tokenAmount);
511 
512 		_router.addLiquidityETH{value:ethAmount}(
513 			address(this),
514 			tokenAmount,
515 			0,
516 			0,
517 			deadAddress,
518 			block.timestamp
519 		);
520 	}
521 
522     function _approve(address owner,address spender, uint256 amount) internal{
523         require(owner != address(0), "BEP20: approve from the zero address");
524 		require(spender != address(0), "BEP20: approve to the zero address");
525 
526 		_allowances[owner][spender] = amount;
527 		emit Approval(owner, spender, amount);
528 
529 
530     }
531 
532 
533 
534     //Fees related functions
535 
536     function addToExcluded(address toExclude) public onlyOwner{  
537         _excludedFromFees[toExclude] = true;
538     }
539 
540     function removeFromExcluded(address toRemove) public onlyOwner{
541         _excludedFromFees[toRemove] = false;
542     }
543       function excludePresaleAddresses(address router, address presale) external onlyOwner {
544         
545         _liquidityHolders[address(router)] = true;
546         _liquidityHolders[presale] = true;
547         presaleAddresses[address(router)] = true;
548         presaleAddresses[presale] = true;
549        
550     }
551 
552     function startPresaleStatus()public onlyOwner{
553         
554         buymktFee = 0;
555         sellmktFee =0;
556         buyliqFee =0;
557         sellliqFee =0;
558         buyprizePool =0;
559         sellprizePool = 0;
560         setSwapAndLiquify(false);
561 
562     }
563     function endPresaleStatus() public onlyOwner{
564         buymktFee = 4;
565         buyliqFee = 10;
566         buyprizePool = 1;
567 
568         sellmktFee = 5;
569         sellliqFee = 13;
570         sellprizePool = 2;
571         setSwapAndLiquify(true);
572     }
573 
574     function updateThreshold(uint newThreshold) public onlyOwner{
575         currentThreshold = newThreshold;
576 
577     }
578 
579     function setSwapAndLiquify(bool _enabled) public onlyOwner{
580             swapAndLiquifyEnabled = _enabled;
581     }
582 
583 
584     //Marketing related 
585 
586     function setMktAddress(address newAddress) external onlyOwner{
587         marketingAddress = payable(newAddress);
588     }
589     function transferAssetsETH(address payable to, uint256 amount) internal{
590             to.transfer(amount);
591     }
592     function setPrizePoolAddress(address newAddress) external onlyOwner{
593         prizePoolAddress = payable(newAddress);
594     }
595     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
596         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
597         _setAutomatedMarketMakerPair(pair, value);
598     }
599     function _setAutomatedMarketMakerPair(address pair, bool value) private {
600         automatedMarketMakerPairs[pair] = value;
601 
602         emit SetAutomatedMarketMakerPair(pair, value);
603     }
604     function updatecurrentbuyliqFee(uint256 newAmount) public onlyOwner{
605             buyliqFee = newAmount;
606     }
607     function updatecurrentbuymktfee(uint256 newAmount) public onlyOwner{
608              buymktFee= newAmount;
609     }
610     function updatecurrentbuyprizepoolfee(uint256 newAmount) public onlyOwner{
611              buymktFee= newAmount;
612     }
613 
614       function updatecurrentsellLiqFee(uint256 newAmount) public onlyOwner{
615              sellliqFee= newAmount;
616     }
617     function updatecurrentsellmktfee(uint256 newAmount)public onlyOwner{
618              sellmktFee= newAmount;
619     }
620     
621     function updatecurrentsellyprizepoolfee(uint256 newAmount) public onlyOwner{
622              sellprizePool= newAmount;
623     }
624         function updatecurrentsellDevfee(uint256 newAmount) public onlyOwner{
625              sellprizePool= newAmount;
626     }
627     function currentMaxWallet() public view returns(uint256){
628         return maxWalletAmount;
629     }
630     function currentMaxTx() public view returns(uint256){
631         return maxTxAmount;
632     }
633     function updateSwapTreshold(uint256 newVal) public onlyOwner{
634         swapTreshold = newVal;
635         requiredTokensToSwap = _totalSupply*swapTreshold/1000;
636         
637     }
638     function currentSwapTreshold() public view returns(uint256){
639         return swapTreshold;
640     }
641     function currentTokensToSwap() public view returns(uint256){
642         return requiredTokensToSwap;
643     }
644 }
645 
646 
647 interface IUniswapV2Factory {
648     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
649     function feeTo() external view returns (address);
650     function feeToSetter() external view returns (address);
651     function getPair(address tokenA, address tokenB) external view returns (address pair);
652     function allPairs(uint) external view returns (address pair);
653     function allPairsLength() external view returns (uint);
654     function createPair(address tokenA, address tokenB) external returns (address pair);
655     function setFeeTo(address) external;
656     function setFeeToSetter(address) external;
657 }
658 
659 interface IUniswapV2Pair {
660     event Approval(address indexed owner, address indexed spender, uint value);
661     event Transfer(address indexed from, address indexed to, uint value);
662     function name() external pure returns (string memory);
663     function symbol() external pure returns (string memory);
664     function decimals() external pure returns (uint8);
665     function totalSupply() external view returns (uint);
666     function balanceOf(address owner) external view returns (uint);
667     function allowance(address owner, address spender) external view returns (uint);
668     function approve(address spender, uint value) external returns (bool);
669     function transfer(address to, uint value) external returns (bool);
670     function transferFrom(address from, address to, uint value) external returns (bool);
671     function DOMAIN_SEPARATOR() external view returns (bytes32);
672     function PERMIT_TYPEHASH() external pure returns (bytes32);
673     function nonces(address owner) external view returns (uint);
674     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
675     event Mint(address indexed sender, uint amount0, uint amount1);
676     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
677     event Swap(
678         address indexed sender,
679         uint amount0In,
680         uint amount1In,
681         uint amount0Out,
682         uint amount1Out,
683         address indexed to
684     );
685     event Sync(uint112 reserve0, uint112 reserve1);
686     function MINIMUM_LIQUIDITY() external pure returns (uint);
687     function factory() external view returns (address);
688     function token0() external view returns (address);
689     function token1() external view returns (address);
690     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
691     function price0CumulativeLast() external view returns (uint);
692     function price1CumulativeLast() external view returns (uint);
693     function kLast() external view returns (uint);
694     function mint(address to) external returns (uint liquidity);
695     function burn(address to) external returns (uint amount0, uint amount1);
696     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
697     function skim(address to) external;
698     function sync() external;
699     function initialize(address, address) external;
700 }
701 
702 interface IUniswapV2Router01 {
703     function factory() external pure returns (address);
704     function WETH() external pure returns (address);
705     function addLiquidity(
706         address tokenA,
707         address tokenB,
708         uint amountADesired,
709         uint amountBDesired,
710         uint amountAMin,
711         uint amountBMin,
712         address to,
713         uint deadline
714     ) external returns (uint amountA, uint amountB, uint liquidity);
715     function addLiquidityETH(
716         address token,
717         uint amountTokenDesired,
718         uint amountTokenMin,
719         uint amountETHMin,
720         address to,
721         uint deadline
722     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
723     function removeLiquidity(
724         address tokenA,
725         address tokenB,
726         uint liquidity,
727         uint amountAMin,
728         uint amountBMin,
729         address to,
730         uint deadline
731     ) external returns (uint amountA, uint amountB);
732     function removeLiquidityETH(
733         address token,
734         uint liquidity,
735         uint amountTokenMin,
736         uint amountETHMin,
737         address to,
738         uint deadline
739     ) external returns (uint amountToken, uint amountETH);
740     function removeLiquidityWithPermit(
741         address tokenA,
742         address tokenB,
743         uint liquidity,
744         uint amountAMin,
745         uint amountBMin,
746         address to,
747         uint deadline,
748         bool approveMax, uint8 v, bytes32 r, bytes32 s
749     ) external returns (uint amountA, uint amountB);
750     function removeLiquidityETHWithPermit(
751         address token,
752         uint liquidity,
753         uint amountTokenMin,
754         uint amountETHMin,
755         address to,
756         uint deadline,
757         bool approveMax, uint8 v, bytes32 r, bytes32 s
758     ) external returns (uint amountToken, uint amountETH);
759     function swapExactTokensForTokens(
760         uint amountIn,
761         uint amountOutMin,
762         address[] calldata path,
763         address to,
764         uint deadline
765     ) external returns (uint[] memory amounts);
766     function swapTokensForExactTokens(
767         uint amountOut,
768         uint amountInMax,
769         address[] calldata path,
770         address to,
771         uint deadline
772     ) external returns (uint[] memory amounts);
773     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
774         external
775         payable
776         returns (uint[] memory amounts);
777     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
778         external
779         returns (uint[] memory amounts);
780     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
781         external
782         returns (uint[] memory amounts);
783     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
784         external
785         payable
786         returns (uint[] memory amounts);
787 
788     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
789     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
790     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
791     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
792     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
793 }
794 
795 interface IUniswapV2Router02 is IUniswapV2Router01 {
796     function removeLiquidityETHSupportingFeeOnTransferTokens(
797         address token,
798         uint liquidity,
799         uint amountTokenMin,
800         uint amountETHMin,
801         address to,
802         uint deadline
803     ) external returns (uint amountETH);
804     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
805         address token,
806         uint liquidity,
807         uint amountTokenMin,
808         uint amountETHMin,
809         address to,
810         uint deadline,
811         bool approveMax, uint8 v, bytes32 r, bytes32 s
812     ) external returns (uint amountETH);
813 
814     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
815         uint amountIn,
816         uint amountOutMin,
817         address[] calldata path,
818         address to,
819         uint deadline
820     ) external;
821     function swapExactETHForTokensSupportingFeeOnTransferTokens(
822         uint amountOutMin,
823         address[] calldata path,
824         address to,
825         uint deadline
826     ) external payable;
827     function swapExactTokensForETHSupportingFeeOnTransferTokens(
828         uint amountIn,
829         uint amountOutMin,
830         address[] calldata path,
831         address to,
832         uint deadline
833     ) external;
834 }