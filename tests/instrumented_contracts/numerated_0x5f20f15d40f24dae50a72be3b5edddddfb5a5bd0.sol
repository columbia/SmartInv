1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.11;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address payable) {
7         return payable(msg.sender);
8     }
9 
10     function _msgData() internal view virtual returns (bytes memory) {
11         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
12         return msg.data;
13     }
14 }
15 
16 interface IERC20 {
17     function totalSupply() external view returns (uint256);
18 
19     function balanceOf(address account) external view returns (uint256);
20 
21     function transfer(address recipient, uint256 amount)
22         external
23         returns (bool);
24 
25     function allowance(address owner, address spender)
26         external
27         view
28         returns (uint256);
29 
30     function approve(address spender, uint256 amount) external returns (bool);
31 
32     function transferFrom(
33         address sender,
34         address recipient,
35         uint256 amount
36     ) external returns (bool);
37 
38     event Transfer(address indexed from, address indexed to, uint256 value);
39     event Approval(
40         address indexed owner,
41         address indexed spender,
42         uint256 value
43     );
44 }
45 
46 library SafeMath {
47     function add(uint256 a, uint256 b) internal pure returns (uint256) {
48         uint256 c = a + b;
49         require(c >= a, "SafeMath: addition overflow");
50 
51         return c;
52     }
53 
54     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
55         return sub(a, b, "SafeMath: subtraction overflow");
56     }
57 
58     function sub(
59         uint256 a,
60         uint256 b,
61         string memory errorMessage
62     ) internal pure returns (uint256) {
63         require(b <= a, errorMessage);
64         uint256 c = a - b;
65 
66         return c;
67     }
68 
69     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
70         if (a == 0) {
71             return 0;
72         }
73 
74         uint256 c = a * b;
75         require(c / a == b, "SafeMath: multiplication overflow");
76 
77         return c;
78     }
79 
80     function div(uint256 a, uint256 b) internal pure returns (uint256) {
81         return div(a, b, "SafeMath: division by zero");
82     }
83 
84     function div(
85         uint256 a,
86         uint256 b,
87         string memory errorMessage
88     ) internal pure returns (uint256) {
89         require(b > 0, errorMessage);
90         uint256 c = a / b;
91         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
92 
93         return c;
94     }
95 
96     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
97         return mod(a, b, "SafeMath: modulo by zero");
98     }
99 
100     function mod(
101         uint256 a,
102         uint256 b,
103         string memory errorMessage
104     ) internal pure returns (uint256) {
105         require(b != 0, errorMessage);
106         return a % b;
107     }
108 }
109 
110 library Address {
111     function isContract(address account) internal view returns (bool) {
112         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
113         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
114         // for accounts without code, i.e. `keccak256('')`
115         bytes32 codehash;
116         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
117         // solhint-disable-next-line no-inline-assembly
118         assembly {
119             codehash := extcodehash(account)
120         }
121         return (codehash != accountHash && codehash != 0x0);
122     }
123 
124     function sendValue(address payable recipient, uint256 amount) internal {
125         require(
126             address(this).balance >= amount,
127             "Address: insufficient balance"
128         );
129 
130         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
131         (bool success, ) = recipient.call{value: amount}("");
132         require(
133             success,
134             "Address: unable to send value, recipient may have reverted"
135         );
136     }
137 
138     function functionCall(address target, bytes memory data)
139         internal
140         returns (bytes memory)
141     {
142         return functionCall(target, data, "Address: low-level call failed");
143     }
144 
145     function functionCall(
146         address target,
147         bytes memory data,
148         string memory errorMessage
149     ) internal returns (bytes memory) {
150         return _functionCallWithValue(target, data, 0, errorMessage);
151     }
152 
153     function functionCallWithValue(
154         address target,
155         bytes memory data,
156         uint256 value
157     ) internal returns (bytes memory) {
158         return
159             functionCallWithValue(
160                 target,
161                 data,
162                 value,
163                 "Address: low-level call with value failed"
164             );
165     }
166 
167     function functionCallWithValue(
168         address target,
169         bytes memory data,
170         uint256 value,
171         string memory errorMessage
172     ) internal returns (bytes memory) {
173         require(
174             address(this).balance >= value,
175             "Address: insufficient balance for call"
176         );
177         return _functionCallWithValue(target, data, value, errorMessage);
178     }
179 
180     function _functionCallWithValue(
181         address target,
182         bytes memory data,
183         uint256 weiValue,
184         string memory errorMessage
185     ) private returns (bytes memory) {
186         require(isContract(target), "Address: call to non-contract");
187 
188         (bool success, bytes memory returndata) = target.call{value: weiValue}(
189             data
190         );
191         if (success) {
192             return returndata;
193         } else {
194             if (returndata.length > 0) {
195                 assembly {
196                     let returndata_size := mload(returndata)
197                     revert(add(32, returndata), returndata_size)
198                 }
199             } else {
200                 revert(errorMessage);
201             }
202         }
203     }
204 }
205 
206 contract Ownable is Context {
207     address private _owner;
208     address private _previousOwner;
209 
210     event OwnershipTransferred(
211         address indexed previousOwner,
212         address indexed newOwner
213     );
214 
215     constructor() {
216         address msgSender = _msgSender();
217         _owner = msgSender;
218         emit OwnershipTransferred(address(0), msgSender);
219     }
220 
221     function owner() public view returns (address) {
222         return _owner;
223     }
224 
225     modifier onlyOwner() {
226         require(_owner == _msgSender(), "Ownable: caller is not the owner");
227         _;
228     }
229 
230     function renounceOwnership() external virtual onlyOwner {
231         emit OwnershipTransferred(_owner, address(0));
232         _owner = address(0);
233     }
234 
235     function transferOwnership(address newOwner) external virtual onlyOwner {
236         require(
237             newOwner != address(0),
238             "Ownable: new owner is the zero address"
239         );
240         emit OwnershipTransferred(_owner, newOwner);
241         _owner = newOwner;
242     }
243 
244     function getTime() public view returns (uint256) {
245         return block.timestamp;
246     }
247 }
248 
249 
250 interface IDexRouter {
251     function factory() external pure returns (address);
252     function WETH() external pure returns (address);
253     
254     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
255 
256     function swapExactTokensForETHSupportingFeeOnTransferTokens(
257         uint amountIn,
258         uint amountOutMin,
259         address[] calldata path,
260         address to,
261         uint deadline
262     ) external;
263 
264     function swapExactETHForTokensSupportingFeeOnTransferTokens(
265         uint amountOutMin,
266         address[] calldata path,
267         address to,
268         uint deadline
269     ) external payable;
270 
271     function addLiquidityETH(
272         address token,
273         uint256 amountTokenDesired,
274         uint256 amountTokenMin,
275         uint256 amountETHMin,
276         address to,
277         uint256 deadline
278     )
279         external
280         payable
281         returns (
282             uint256 amountToken,
283             uint256 amountETH,
284             uint256 liquidity
285         );
286         
287 }
288 
289 interface IDexFactory {
290     function createPair(address tokenA, address tokenB)
291         external
292         returns (address pair);
293 }
294 
295 contract Bobatama is Context, IERC20, Ownable {
296     using Address for address;
297 
298     address payable public operationsAddress;
299     address payable public devAddress;      
300         
301     mapping(address => uint256) private _rOwned;
302     mapping(address => uint256) private _tOwned;
303     mapping(address => mapping(address => uint256)) private _allowances;
304     
305     // Anti-bot and anti-whale mappings and variables
306     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
307     bool public transferDelayEnabled = true;
308     bool public limitsInEffect = true;
309 
310     mapping(address => bool) private _isExcludedFromFee;
311 
312     mapping(address => bool) private _isExcluded;
313     address[] private _excluded;
314     
315     uint256 private constant MAX = ~uint256(0);
316     uint256 private constant _tTotal = 1 * 1e12 * 1e18;
317     uint256 private _rTotal = (MAX - (MAX % _tTotal));
318     uint256 private _tFeeTotal;
319 
320     string private constant _name = "Bobatama";
321     string private constant _symbol = "BOBA";
322     uint8 private constant _decimals = 18;
323 
324     // these values are pretty much arbitrary since they get overwritten for every txn, but the placeholders make it easier to work with current contract.
325     uint256 private _taxFee;
326     uint256 private _previousTaxFee = _taxFee;
327 
328     uint256 private _operationsFee;
329     
330     uint256 private _liquidityFee;
331     uint256 private _previousLiquidityFee = _liquidityFee;
332     
333     uint256 private constant BUY = 1;
334     uint256 private constant SELL = 2;
335     uint256 private constant TRANSFER = 3;
336     uint256 private buyOrSellSwitch;
337 
338     uint256 public _buyTaxFee = 100;
339     uint256 public _buyLiquidityFee = 600;
340     uint256 public _buyOperationsFee = 500;
341 
342     uint256 public _sellTaxFee = 100;
343     uint256 public _sellLiquidityFee = 600;
344     uint256 public _sellOperationsFee = 700;
345 
346     mapping (address => bool) public privateSaleWallets;
347     mapping (address => uint256) public nextPrivateWalletSellDate;
348     uint256 public maxPrivSaleSell = 0.5 ether;
349 
350     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
351     uint256 public blockForPenaltyEnd;
352     mapping (address => bool) public boughtEarly;
353     uint256 public botsCaught;
354     
355     uint256 public _liquidityTokensToSwap;
356     uint256 public _operationsTokensToSwap;
357     
358     uint256 public maxTransactionAmount;
359     mapping (address => bool) public _isExcludedMaxTransactionAmount;
360     uint256 public maxWallet;
361     
362     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
363     // could be subject to a maximum transfer amount
364     mapping (address => bool) public automatedMarketMakerPairs;
365 
366     uint256 private minimumTokensBeforeSwap;
367 
368     IDexRouter public dexRouter;
369     address public lpPair;
370 
371     bool inSwapAndLiquify;
372     bool public swapAndLiquifyEnabled = false;
373     bool public tradingActive = false;
374 
375     event SwapAndLiquifyEnabledUpdated(bool enabled);
376     event SwapAndLiquify(
377         uint256 tokensSwapped,
378         uint256 ethReceived,
379         uint256 tokensIntoLiquidity
380     );
381 
382     event SwapETHForTokens(uint256 amountIn, address[] path);
383 
384     event SwapTokensForETH(uint256 amountIn, address[] path);
385     
386     event SetAutomatedMarketMakerPair(address pair, bool value);
387     
388     event ExcludeFromReward(address excludedAddress);
389     
390     event IncludeInReward(address includedAddress);
391     
392     event ExcludeFromFee(address excludedAddress);
393     
394     event IncludeInFee(address includedAddress);
395     
396     event SetBuyFee(uint256 operationsFee, uint256 liquidityFee, uint256 reflectFee);
397     
398     event SetSellFee(uint256 operationsFee, uint256 liquidityFee, uint256 reflectFee);
399     
400     event TransferForeignToken(address token, uint256 amount);
401     
402     event UpdatedOperationsAddress(address operations);
403     
404     event OwnerForcedSwapBack(uint256 timestamp);
405 
406     event CaughtEarlyBuyer(address sniper);
407 
408     event EnabledTrading();
409 
410     event RemovedLimits();
411     
412     event TransferDelayDisabled();
413 
414     event UpdatedPrivateMaxSell(uint256 amount);
415 
416 
417     modifier lockTheSwap() {
418         inSwapAndLiquify = true;
419         _;
420         inSwapAndLiquify = false;
421     }
422 
423     constructor() payable {
424         _rOwned[address(this)] = _rTotal/100*45;
425         _rOwned[0x058E3149Ef06F348aC384C3F10c043ae567cC01f] = _rTotal/100*28;
426         _rOwned[0x2941905BC065726d0b5A9b79eA7AF7B01F96C193] = _rTotal/1000*83;
427         _rOwned[0x626C1ddD20b691E441fC8d18398E6Fa8E0DebF3F] = _rTotal/100*5;
428         _rOwned[0x903D52723560543f550828B508eC66fe03ed0ABC] = _rTotal/1000*2;
429         _rOwned[address(0xdead)] = _rTotal/1000*65;
430         _rOwned[msg.sender] = _rTotal/100*7;
431         
432         maxTransactionAmount = _tTotal * 1 / 10000;
433         minimumTokensBeforeSwap = _tTotal * 50 / 100000;
434         
435         operationsAddress = payable(0x4579dd0cF46a192f71fd1be3F5843139E5c67F5c); // Operations Address
436         
437         _isExcludedFromFee[owner()] = true;
438         _isExcludedFromFee[address(this)] = true;
439         _isExcludedFromFee[operationsAddress] = true;
440         _isExcludedFromFee[0x058E3149Ef06F348aC384C3F10c043ae567cC01f] = true;
441         _isExcludedFromFee[0x2941905BC065726d0b5A9b79eA7AF7B01F96C193] = true;
442         _isExcludedFromFee[0x626C1ddD20b691E441fC8d18398E6Fa8E0DebF3F] = true;
443         
444         excludeFromMaxTransaction(owner(), true);
445         excludeFromMaxTransaction(address(this), true);
446         excludeFromMaxTransaction(address(0xdead), true);
447         excludeFromMaxTransaction(operationsAddress, true);
448         
449         excludeFromReward(msg.sender);
450         
451         emit Transfer(address(0), address(this), _tTotal/100*45);
452         emit Transfer(address(0), address(0x058E3149Ef06F348aC384C3F10c043ae567cC01f), _tTotal/100*28);
453         emit Transfer(address(0), address(0x2941905BC065726d0b5A9b79eA7AF7B01F96C193), _tTotal/1000*83);
454         emit Transfer(address(0), address(0x626C1ddD20b691E441fC8d18398E6Fa8E0DebF3F), _tTotal/100*5);
455         emit Transfer(address(0), address(0x903D52723560543f550828B508eC66fe03ed0ABC), _tTotal/1000*2);
456         emit Transfer(address(0), address(0xdead), _tTotal/1000*65);
457         emit Transfer(address(0), address(msg.sender), _tTotal/100*7);
458     }
459 
460     function name() external pure returns (string memory) {
461         return _name;
462     }
463 
464     function symbol() external pure returns (string memory) {
465         return _symbol;
466     }
467 
468     function decimals() external pure returns (uint8) {
469         return _decimals;
470     }
471 
472     function totalSupply() external pure override returns (uint256) {
473         return _tTotal;
474     }
475 
476     function balanceOf(address account) public view override returns (uint256) {
477         if (_isExcluded[account]) return _tOwned[account];
478         return tokenFromReflection(_rOwned[account]);
479     }
480 
481     function transfer(address recipient, uint256 amount)
482         external
483         override
484         returns (bool)
485     {
486         _transfer(_msgSender(), recipient, amount);
487         return true;
488     }
489 
490     function allowance(address owner, address spender)
491         external
492         view
493         override
494         returns (uint256)
495     {
496         return _allowances[owner][spender];
497     }
498 
499     function approve(address spender, uint256 amount)
500         public
501         override
502         returns (bool)
503     {
504         _approve(_msgSender(), spender, amount);
505         return true;
506     }
507 
508     function transferFrom(
509         address sender,
510         address recipient,
511         uint256 amount
512     ) public returns (bool) {
513         _transfer(sender, recipient, amount);
514 
515         uint256 currentAllowance = _allowances[sender][_msgSender()];
516         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
517         unchecked {
518             _approve(sender, _msgSender(), currentAllowance - amount);
519         }
520 
521         return true;
522     }
523 
524     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
525         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
526         return true;
527     }
528 
529     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
530         uint256 currentAllowance = _allowances[_msgSender()][spender];
531         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
532         unchecked {
533             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
534         }
535 
536         return true;
537     }
538 
539     function isExcludedFromReward(address account)
540         external
541         view
542         returns (bool)
543     {
544         return _isExcluded[account];
545     }
546 
547     function totalFees() external view returns (uint256) {
548         return _tFeeTotal;
549     }
550     
551     // remove limits after token is stable - 30-60 minutes
552     function removeLimits() external onlyOwner {
553         limitsInEffect = false;
554         transferDelayEnabled = false;
555         emit RemovedLimits();
556     }
557     
558     // disable Transfer delay
559     function disableTransferDelay() external onlyOwner {
560         transferDelayEnabled = false;
561         emit TransferDelayDisabled();
562     }
563     
564     function removeBoughtEarly(address wallet) external onlyOwner {
565         require(boughtEarly[wallet], "Wallet is already not flagged.");
566         boughtEarly[wallet] = false;
567     }
568 
569     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
570         _isExcludedMaxTransactionAmount[updAds] = isEx;
571     }
572             
573     function minimumTokensBeforeSwapAmount() external view returns (uint256) {
574         return minimumTokensBeforeSwap;
575     }
576 
577     function setPrivateSaleMaxSell(uint256 amount) external onlyOwner{
578         require(amount >= 25 && amount <= 500, "Must set between 0.25 and 50 ETH");
579         maxPrivSaleSell = amount * 1e16;
580         emit UpdatedPrivateMaxSell(amount);
581     }
582 
583      // change the minimum amount of tokens to sell from fees
584     function updateMinimumTokensBeforeSwap(uint256 newAmount) external onlyOwner{
585   	    require(newAmount >= _tTotal * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
586   	    require(newAmount <= _tTotal * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
587   	    minimumTokensBeforeSwap = newAmount;
588   	}
589 
590     function updateMaxAmount(uint256 newNum) external onlyOwner {
591         require(newNum >= (_tTotal * 2 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.2%");
592         maxTransactionAmount = newNum * (1e18);
593     }
594 
595     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
596         require(pair != lpPair, "The pair cannot be removed from automatedMarketMakerPairs");
597 
598         _setAutomatedMarketMakerPair(pair, value);
599     }
600 
601     function _setAutomatedMarketMakerPair(address pair, bool value) private {
602         automatedMarketMakerPairs[pair] = value;
603         _isExcludedMaxTransactionAmount[pair] = value;
604         if(value){excludeFromReward(pair);}
605         if(!value){includeInReward(pair);}
606     }
607 
608     function reflectionFromToken(uint256 tAmount, bool deductTransferFee)
609         external
610         view
611         returns (uint256)
612     {
613         require(tAmount <= _tTotal, "Amount must be less than supply");
614         if (!deductTransferFee) {
615             (uint256 rAmount, , , , , ) = _getValues(tAmount);
616             return rAmount;
617         } else {
618             (, uint256 rTransferAmount, , , , ) = _getValues(tAmount);
619             return rTransferAmount;
620         }
621     }
622 
623     function tokenFromReflection(uint256 rAmount)
624         public
625         view
626         returns (uint256)
627     {
628         require(
629             rAmount <= _rTotal,
630             "Amount must be less than total reflections"
631         );
632         uint256 currentRate = _getRate();
633         return rAmount / (currentRate);
634     }
635 
636     function excludeFromReward(address account) public onlyOwner {
637         require(!_isExcluded[account], "Account is already excluded");
638         require(_excluded.length + 1 <= 50, "Cannot exclude more than 50 accounts.  Include a previously excluded address.");
639         if (_rOwned[account] > 0) {
640             _tOwned[account] = tokenFromReflection(_rOwned[account]);
641         }
642         _isExcluded[account] = true;
643         _excluded.push(account);
644     }
645 
646     function includeInReward(address account) public onlyOwner {
647         require(_isExcluded[account], "Account is not excluded");
648         for (uint256 i = 0; i < _excluded.length; i++) {
649             if (_excluded[i] == account) {
650                 _excluded[i] = _excluded[_excluded.length - 1];
651                 _tOwned[account] = 0;
652                 _isExcluded[account] = false;
653                 _excluded.pop();
654                 break;
655             }
656         }
657     }
658  
659     function _approve(
660         address owner,
661         address spender,
662         uint256 amount
663     ) private {
664         require(owner != address(0), "ERC20: approve from the zero address");
665         require(spender != address(0), "ERC20: approve to the zero address");
666 
667         _allowances[owner][spender] = amount;
668         emit Approval(owner, spender, amount);
669     }
670 
671     function _transfer(
672         address from,
673         address to,
674         uint256 amount
675     ) private {
676         require(from != address(0), "ERC20: transfer from the zero address");
677         require(to != address(0), "ERC20: transfer to the zero address");
678         require(amount > 0, "Transfer amount must be greater than zero");
679         
680         if(!tradingActive){
681             require(_isExcludedFromFee[from] || _isExcludedFromFee[to], "Trading is not active yet.");
682         }
683 
684         if(privateSaleWallets[from]){
685             if(automatedMarketMakerPairs[to]){
686                 //enforce max sell restrictions.
687                 require(nextPrivateWalletSellDate[from] <= block.timestamp, "Cannot sell yet");
688                 require(amount <= getPrivateSaleMaxSell(), "Attempting to sell over max sell amount.  Check max.");
689                 nextPrivateWalletSellDate[from] = block.timestamp + 24 hours;
690             } else if(!_isExcludedFromFee[to]){
691                 revert("Private sale cannot transfer and must sell only or transfer to a whitelisted address.");
692             }
693         }
694 
695         if(!earlyBuyPenaltyInEffect()){
696             require(!boughtEarly[from] || to == owner() || to == address(0xdead), "Bots cannot transfer tokens in or out except to owner or dead address.");
697         }
698 
699         if(limitsInEffect){
700             if (
701                 from != owner() &&
702                 to != owner() &&
703                 to != address(0) &&
704                 to != address(0xdead) &&
705                 !inSwapAndLiquify
706             ){                
707 
708                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
709                 if (transferDelayEnabled){
710                     if (to != address(dexRouter) && to != address(lpPair)){
711                         require(_holderLastTransferTimestamp[tx.origin] < block.number && _holderLastTransferTimestamp[to] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
712                         _holderLastTransferTimestamp[tx.origin] = block.number;
713                         _holderLastTransferTimestamp[to] = block.number;
714                     }
715                 }
716                 
717                 //when buy
718                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
719                     require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
720                 } 
721                 //when sell
722                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
723                     require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
724                 }
725             }
726         }
727 
728         uint256 contractTokenBalance = balanceOf(address(this));
729         bool overMinimumTokenBalance = contractTokenBalance >= minimumTokensBeforeSwap;
730 
731         // swap and liquify
732         if (
733             !inSwapAndLiquify &&
734             swapAndLiquifyEnabled &&
735             balanceOf(lpPair) > 0 &&
736             !_isExcludedFromFee[to] &&
737             !_isExcludedFromFee[from] &&
738             automatedMarketMakerPairs[to] &&
739             overMinimumTokenBalance
740         ) {
741             swapBack();
742         }
743 
744         removeAllFee();
745         
746         buyOrSellSwitch = TRANSFER;
747         
748         if (!_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
749             if(earlyBuyPenaltyInEffect() && automatedMarketMakerPairs[from] && !automatedMarketMakerPairs[to]){
750                 
751                 if(!boughtEarly[to]){
752                     boughtEarly[to] = true;
753                     botsCaught += 1;
754                     emit CaughtEarlyBuyer(to);
755                 }
756 
757                 _taxFee = _buyTaxFee;
758                 _liquidityFee = _buyLiquidityFee + _buyOperationsFee;
759                 if(_liquidityFee > 0){
760                     buyOrSellSwitch = BUY;
761                 }
762             }
763 
764             // Buy
765             if (automatedMarketMakerPairs[from]) {
766                 _taxFee = _buyTaxFee;
767                 _liquidityFee = _buyLiquidityFee + _buyOperationsFee;
768                 if(_liquidityFee > 0){
769                     buyOrSellSwitch = BUY;
770                 }
771             } 
772             // Sell
773             else if (automatedMarketMakerPairs[to]) {
774                 _taxFee = _sellTaxFee;
775                 _liquidityFee = _sellLiquidityFee + _sellOperationsFee;
776                 if(_liquidityFee > 0){
777                     buyOrSellSwitch = SELL;
778                 }
779             }
780         }
781         
782         _tokenTransfer(from, to, amount);
783         
784         restoreAllFee();
785         
786     }
787 
788     function earlyBuyPenaltyInEffect() public view returns (bool){
789         return block.number < blockForPenaltyEnd;
790     }
791 
792     function swapBack() private lockTheSwap {
793 
794         uint256 contractBalance = balanceOf(address(this));
795         uint256 totalTokensToSwap = _liquidityTokensToSwap + _operationsTokensToSwap;
796         bool success;
797 
798         // prevent overly large contract sells.
799         if(contractBalance >= minimumTokensBeforeSwap * 20){
800             contractBalance = minimumTokensBeforeSwap * 20;
801         }
802 
803         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
804         
805         // Halve the amount of liquidity tokens
806         uint256 tokensForLiquidity = contractBalance * _liquidityTokensToSwap / totalTokensToSwap / 2;
807         uint256 amountToSwapForETH = contractBalance-(tokensForLiquidity);
808         
809         swapTokensForETH(amountToSwapForETH);
810         
811         uint256 ethBalance = address(this).balance;
812         
813         uint256 ethForOperations = ethBalance* (_operationsTokensToSwap) / (totalTokensToSwap - (_liquidityTokensToSwap/2));
814         
815         uint256 ethForLiquidity = ethBalance - ethForOperations;
816 
817         _liquidityTokensToSwap = 0;
818         _operationsTokensToSwap = 0;        
819         
820         if(tokensForLiquidity > 0 && ethForLiquidity > 0){
821             addLiquidity(tokensForLiquidity, ethForLiquidity);
822             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
823         }
824         
825         // send remainder to operations
826         (success,) = address(operationsAddress).call{value: address(this).balance}("");
827     }
828     
829     // force Swap back if slippage above 49% for launch.
830     function forceSwapBack() external onlyOwner {
831         uint256 contractBalance = balanceOf(address(this));
832         require(contractBalance >= minimumTokensBeforeSwap, "Can only swap back if above the threshold.");
833         swapBack();
834         emit OwnerForcedSwapBack(block.timestamp);
835     }
836     
837     function swapTokensForETH(uint256 tokenAmount) private {
838         address[] memory path = new address[](2);
839         path[0] = address(this);
840         path[1] = dexRouter.WETH();
841         _approve(address(this), address(dexRouter), tokenAmount);
842         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
843             tokenAmount,
844             0, // accept any amount of ETH
845             path,
846             address(this),
847             block.timestamp
848         );
849     }
850 
851     function getPrivateSaleMaxSell() public view returns (uint256){
852         address[] memory path = new address[](2);
853         path[0] = dexRouter.WETH();
854         path[1] = address(this);
855         
856         uint256[] memory amounts = new uint256[](2);
857         amounts = dexRouter.getAmountsOut(maxPrivSaleSell, path);
858         return amounts[1] + (amounts[1] * (_sellTaxFee + _sellLiquidityFee + _sellOperationsFee))/10000;
859     }
860     
861     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
862         _approve(address(this), address(dexRouter), tokenAmount);
863         dexRouter.addLiquidityETH{value: ethAmount}(
864             address(this),
865             tokenAmount,
866             0, // slippage is unavoidable
867             0, // slippage is unavoidable
868             address(0xdead),
869             block.timestamp
870         );
871     }
872 
873     function _tokenTransfer(
874         address sender,
875         address recipient,
876         uint256 amount
877     ) private {
878 
879         if (_isExcluded[sender] && !_isExcluded[recipient]) {
880             _transferFromExcluded(sender, recipient, amount);
881         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
882             _transferToExcluded(sender, recipient, amount);
883         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
884             _transferBothExcluded(sender, recipient, amount);
885         } else {
886             _transferStandard(sender, recipient, amount);
887         }
888     }
889 
890     function _transferStandard(
891         address sender,
892         address recipient,
893         uint256 tAmount
894     ) private {
895         (
896             uint256 rAmount,
897             uint256 rTransferAmount,
898             uint256 rFee,
899             uint256 tTransferAmount,
900             uint256 tFee,
901             uint256 tLiquidity
902         ) = _getValues(tAmount);
903         _rOwned[sender] = _rOwned[sender] - rAmount;
904         _rOwned[recipient] = _rOwned[recipient] + rTransferAmount;
905         _takeLiquidity(tLiquidity);
906         _reflectFee(rFee, tFee);
907         emit Transfer(sender, recipient, tTransferAmount);
908     }
909 
910     function _transferToExcluded(
911         address sender,
912         address recipient,
913         uint256 tAmount
914     ) private {
915         (
916             uint256 rAmount,
917             uint256 rTransferAmount,
918             uint256 rFee,
919             uint256 tTransferAmount,
920             uint256 tFee,
921             uint256 tLiquidity
922         ) = _getValues(tAmount);
923         _rOwned[sender] = _rOwned[sender] - (rAmount);
924         _tOwned[recipient] = _tOwned[recipient] + (tTransferAmount);
925         _rOwned[recipient] = _rOwned[recipient] + (rTransferAmount);
926         _takeLiquidity(tLiquidity);
927         _reflectFee(rFee, tFee);
928         emit Transfer(sender, recipient, tTransferAmount);
929     }
930 
931     function _transferFromExcluded(
932         address sender,
933         address recipient,
934         uint256 tAmount
935     ) private {
936         (
937             uint256 rAmount,
938             uint256 rTransferAmount,
939             uint256 rFee,
940             uint256 tTransferAmount,
941             uint256 tFee,
942             uint256 tLiquidity
943         ) = _getValues(tAmount);
944         _tOwned[sender] = _tOwned[sender]-(tAmount);
945         _rOwned[sender] = _rOwned[sender]-(rAmount);
946         _rOwned[recipient] = _rOwned[recipient]+(rTransferAmount);
947         _takeLiquidity(tLiquidity);
948         _reflectFee(rFee, tFee);
949         emit Transfer(sender, recipient, tTransferAmount);
950     }
951 
952     function _transferBothExcluded(
953         address sender,
954         address recipient,
955         uint256 tAmount
956     ) private {
957         (
958             uint256 rAmount,
959             uint256 rTransferAmount,
960             uint256 rFee,
961             uint256 tTransferAmount,
962             uint256 tFee,
963             uint256 tLiquidity
964         ) = _getValues(tAmount);
965         _tOwned[sender] = _tOwned[sender]-(tAmount);
966         _rOwned[sender] = _rOwned[sender]-(rAmount);
967         _tOwned[recipient] = _tOwned[recipient]+(tTransferAmount);
968         _rOwned[recipient] = _rOwned[recipient]+(rTransferAmount);
969         _takeLiquidity(tLiquidity);
970         _reflectFee(rFee, tFee);
971         emit Transfer(sender, recipient, tTransferAmount);
972     }
973 
974     function _reflectFee(uint256 rFee, uint256 tFee) private {
975         _rTotal = _rTotal-(rFee);
976         _tFeeTotal = _tFeeTotal+(tFee);
977     }
978 
979     function _getValues(uint256 tAmount)
980         private
981         view
982         returns (
983             uint256,
984             uint256,
985             uint256,
986             uint256,
987             uint256,
988             uint256
989         )
990     {
991         (
992             uint256 tTransferAmount,
993             uint256 tFee,
994             uint256 tLiquidity
995         ) = _getTValues(tAmount);
996         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
997             tAmount,
998             tFee,
999             tLiquidity,
1000             _getRate()
1001         );
1002         return (
1003             rAmount,
1004             rTransferAmount,
1005             rFee,
1006             tTransferAmount,
1007             tFee,
1008             tLiquidity
1009         );
1010     }
1011 
1012     function _getTValues(uint256 tAmount)
1013         private
1014         view
1015         returns (
1016             uint256,
1017             uint256,
1018             uint256
1019         )
1020     {
1021         uint256 tFee = calculateTaxFee(tAmount);
1022         uint256 tLiquidity = calculateLiquidityFee(tAmount);
1023         uint256 tTransferAmount = tAmount-(tFee)-(tLiquidity);
1024         return (tTransferAmount, tFee, tLiquidity);
1025     }
1026 
1027     function _getRValues(
1028         uint256 tAmount,
1029         uint256 tFee,
1030         uint256 tLiquidity,
1031         uint256 currentRate
1032     )
1033         private
1034         pure
1035         returns (
1036             uint256,
1037             uint256,
1038             uint256
1039         )
1040     {
1041         uint256 rAmount = tAmount*(currentRate);
1042         uint256 rFee = tFee*(currentRate);
1043         uint256 rLiquidity = tLiquidity*(currentRate);
1044         uint256 rTransferAmount = rAmount-(rFee)-(rLiquidity);
1045         return (rAmount, rTransferAmount, rFee);
1046     }
1047 
1048     function _getRate() private view returns (uint256) {
1049         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1050         return rSupply / (tSupply);
1051     }
1052 
1053     function _getCurrentSupply() private view returns (uint256, uint256) {
1054         uint256 rSupply = _rTotal;
1055         uint256 tSupply = _tTotal;
1056         for (uint256 i = 0; i < _excluded.length; i++) {
1057             if (
1058                 _rOwned[_excluded[i]] > rSupply ||
1059                 _tOwned[_excluded[i]] > tSupply
1060             ) return (_rTotal, _tTotal);
1061             rSupply = rSupply-(_rOwned[_excluded[i]]);
1062             tSupply = tSupply-(_tOwned[_excluded[i]]);
1063         }
1064         if (rSupply < _rTotal / (_tTotal)) return (_rTotal, _tTotal);
1065         return (rSupply, tSupply);
1066     }
1067 
1068     function _takeLiquidity(uint256 tLiquidity) private {
1069         if(buyOrSellSwitch == BUY){
1070             _liquidityTokensToSwap += tLiquidity * _buyLiquidityFee / _liquidityFee;
1071             _operationsTokensToSwap += tLiquidity * _buyOperationsFee / _liquidityFee;
1072         } else if(buyOrSellSwitch == SELL){
1073             _liquidityTokensToSwap += tLiquidity * _sellLiquidityFee / _liquidityFee;
1074             _operationsTokensToSwap += tLiquidity * _sellOperationsFee / _liquidityFee;
1075         }
1076         uint256 currentRate = _getRate();
1077         uint256 rLiquidity = tLiquidity * (currentRate);
1078         _rOwned[address(this)] = _rOwned[address(this)] + rLiquidity;
1079         if (_isExcluded[address(this)])
1080             _tOwned[address(this)] = _tOwned[address(this)] + tLiquidity;
1081     }
1082 
1083     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1084         return _amount * _taxFee / 10000;
1085     }
1086 
1087     function calculateLiquidityFee(uint256 _amount)
1088         private
1089         view
1090         returns (uint256)
1091     {
1092         return _amount * _liquidityFee / 10000;
1093     }
1094 
1095     function removeAllFee() private {
1096         if (_taxFee == 0 && _liquidityFee == 0) return;
1097 
1098         _previousTaxFee = _taxFee;
1099         _previousLiquidityFee = _liquidityFee;
1100 
1101         _taxFee = 0;
1102         _liquidityFee = 0;
1103     }
1104 
1105     function restoreAllFee() private {
1106         _taxFee = _previousTaxFee;
1107         _liquidityFee = _previousLiquidityFee;
1108     }
1109 
1110     function isExcludedFromFee(address account) external view returns (bool) {
1111         return _isExcludedFromFee[account];
1112     }
1113 
1114     function excludeFromFee(address account) external onlyOwner {
1115         _isExcludedFromFee[account] = true;
1116         emit ExcludeFromFee(account);
1117     }
1118 
1119     function includeInFee(address account) external onlyOwner {
1120         _isExcludedFromFee[account] = false;
1121         emit IncludeInFee(account);
1122     }
1123 
1124     function setBuyFee(uint256 buyTaxFee, uint256 buyLiquidityFee, uint256 buyOperationsFee)
1125         external
1126         onlyOwner
1127     {
1128         _buyTaxFee = buyTaxFee;
1129         _buyLiquidityFee = buyLiquidityFee;
1130         _buyOperationsFee = buyOperationsFee;
1131         require(_buyTaxFee + _buyLiquidityFee + _buyOperationsFee <= 1500, "Must keep buy taxes below 15%");
1132         emit SetBuyFee(buyOperationsFee, buyLiquidityFee, buyTaxFee);
1133     }
1134 
1135     function setSellFee(uint256 sellTaxFee, uint256 sellLiquidityFee, uint256 sellOperationsFee)
1136         external
1137         onlyOwner
1138     {
1139         _sellTaxFee = sellTaxFee;
1140         _sellLiquidityFee = sellLiquidityFee;
1141         _sellOperationsFee = sellOperationsFee;
1142         require(_sellTaxFee + _sellLiquidityFee + _sellOperationsFee <= 2000, "Must keep sell taxes below 20%");
1143         emit SetSellFee(sellOperationsFee, sellLiquidityFee, sellTaxFee);
1144     }
1145     
1146     function setOperationsAddress(address _operationsAddress) external onlyOwner {
1147         require(_operationsAddress != address(0), "_operationsAddress address cannot be 0");
1148         _isExcludedFromFee[operationsAddress] = false;
1149         operationsAddress = payable(_operationsAddress);
1150         _isExcludedFromFee[operationsAddress] = true;
1151         emit UpdatedOperationsAddress(_operationsAddress);
1152     }
1153 
1154     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1155         swapAndLiquifyEnabled = _enabled;
1156         emit SwapAndLiquifyEnabledUpdated(_enabled);
1157     }
1158 
1159     // To receive ETH from dexRouter when swapping
1160     receive() external payable {}
1161 
1162     function transferForeignToken(address _token, address _to)
1163         external
1164         onlyOwner
1165         returns (bool _sent)
1166     {
1167         require(_token != address(0), "_token address cannot be 0");
1168         require(_token != address(this), "Can't withdraw native tokens");
1169         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
1170         _sent = IERC20(_token).transfer(_to, _contractBalance);
1171         emit TransferForeignToken(_token, _contractBalance);
1172     }
1173     
1174     function withdrawStuckETH() external onlyOwner {
1175         bool success;
1176         (success,) = address(msg.sender).call{value: address(this).balance}("");
1177     }
1178 
1179     function launch(address[] memory wallets, uint256[] memory amountsInTokens, uint256 blocksForPenalty) external onlyOwner {
1180         require(!tradingActive, "Trading is already active, cannot relaunch.");
1181         require(blocksForPenalty < 10, "Cannot make penalty blocks more than 10");
1182 
1183         removeAllFee();
1184         require(wallets.length == amountsInTokens.length, "arrays must be the same length");
1185         require(wallets.length < 200, "Can only airdrop 200 wallets per txn due to gas limits"); // allows for airdrop + launch at the same exact time, reducing delays and reducing sniper input.
1186         for(uint256 i = 0; i < wallets.length; i++){
1187             address wallet = wallets[i];
1188             privateSaleWallets[wallet] = true;
1189             nextPrivateWalletSellDate[wallet] = block.timestamp + 24 hours;
1190             uint256 amount = amountsInTokens[i];
1191             _transfer(msg.sender, wallet, amount);
1192         }
1193 
1194         maxTransactionAmount = _tTotal * 25 / 10000;
1195 
1196         //standard enable trading
1197         tradingActive = true;
1198         swapAndLiquifyEnabled = true;
1199         tradingActiveBlock = block.number;
1200         blockForPenaltyEnd = tradingActiveBlock + blocksForPenalty;
1201         emit EnabledTrading();
1202 
1203         // initialize router
1204         IDexRouter _dexRouter = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
1205         dexRouter = _dexRouter;
1206 
1207         // create pair
1208         lpPair = IDexFactory(_dexRouter.factory()).createPair(address(this), _dexRouter.WETH());
1209         excludeFromMaxTransaction(address(lpPair), true);
1210         _setAutomatedMarketMakerPair(address(lpPair), true);
1211    
1212         // add the liquidity
1213 
1214         require(address(this).balance > 0, "Must have ETH on contract to launch");
1215 
1216         require(balanceOf(address(this)) > 0, "Must have Tokens on contract to launch");
1217 
1218         _approve(address(this), address(dexRouter), balanceOf(address(this)));
1219         dexRouter.addLiquidityETH{value: address(this).balance}(
1220             address(this),
1221             balanceOf(address(this)),
1222             0, // slippage is unavoidable
1223             0, // slippage is unavoidable
1224             msg.sender,
1225             block.timestamp
1226         );
1227         restoreAllFee();
1228     }
1229 }