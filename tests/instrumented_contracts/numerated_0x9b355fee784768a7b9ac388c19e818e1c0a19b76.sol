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
295 contract MWS is Context, IERC20, Ownable {
296     using Address for address;
297 
298     address payable public marketingAddress;
299         
300     mapping(address => uint256) private _rOwned;
301     mapping(address => uint256) private _tOwned;
302     mapping(address => mapping(address => uint256)) private _allowances;
303     
304     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
305     bool public transferDelayEnabled = true;
306     bool public limitsInEffect = true;
307 
308     mapping(address => bool) private _isExcludedFromFee;
309 
310     mapping(address => bool) private _isExcluded;
311     address[] private _excluded;
312     
313     uint256 private constant MAX = ~uint256(0);
314     uint256 private constant _tTotal = 1 * 1e6 * 1e18;
315     uint256 private _rTotal = (MAX - (MAX % _tTotal));
316     uint256 private _tFeeTotal;
317 
318     string private constant _name = "MWS";
319     string private constant _symbol = "MWS";
320     uint8 private constant _decimals = 18;
321 
322     // these values are pretty much arbitrary since they get overwritten for every txn, but the placeholders make it easier to work with current contract.
323     uint256 private _taxFee;
324     uint256 private _previousTaxFee = _taxFee;
325 
326     uint256 private _operationsFee;
327     
328     uint256 private _liquidityFee;
329     uint256 private _previousLiquidityFee = _liquidityFee;
330     
331     uint256 private constant BUY = 1;
332     uint256 private constant SELL = 2;
333     uint256 private constant TRANSFER = 3;
334     uint256 private buyOrSellSwitch;
335 
336     uint256 public _buyTaxFee = 0;
337     uint256 public _buyLiquidityFee = 0;
338     uint256 public _buyOperationsFee = 20;
339 
340     uint256 public _sellTaxFee = 0;
341     uint256 public _sellLiquidityFee = 0;
342     uint256 public _sellOperationsFee = 50;
343     
344     uint256 public _liquidityTokensToSwap;
345     uint256 public _marketingTokensToSwap;
346     uint256 public _maxwallet = _tTotal/1000*15;
347 
348     mapping (address => bool) public _isExcludedMaxTransactionAmount;
349     
350     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
351     // could be subject to a maximum transfer amount
352     mapping (address => bool) public automatedMarketMakerPairs;
353 
354     uint256 private minimumTokensBeforeSwap;
355 
356     IDexRouter public dexRouter;
357     address public lpPair;
358 
359     bool inSwapAndLiquify;
360     bool public swapAndLiquifyEnabled = false;
361     bool public tradingActive = false;
362 
363     event SwapAndLiquifyEnabledUpdated(bool enabled);
364     event SwapAndLiquify(
365         uint256 tokensSwapped,
366         uint256 ethReceived,
367         uint256 tokensIntoLiquidity
368     );
369 
370     event SwapETHForTokens(uint256 amountIn, address[] path);
371 
372     event SwapTokensForETH(uint256 amountIn, address[] path);
373     
374     event SetAutomatedMarketMakerPair(address pair, bool value);
375     
376     event ExcludeFromReward(address excludedAddress);
377     
378     event IncludeInReward(address includedAddress);
379     
380     event ExcludeFromFee(address excludedAddress);
381     
382     event IncludeInFee(address includedAddress);
383     
384     event SetBuyFee(uint256 operationsFee, uint256 liquidityFee, uint256 reflectFee);
385     
386     event SetSellFee(uint256 operationsFee, uint256 liquidityFee, uint256 reflectFee);
387     
388     event TransferForeignToken(address token, uint256 amount);
389     
390     event UpdatedOperationsAddress(address operations);
391     
392     event OwnerForcedSwapBack(uint256 timestamp);
393 
394     event EnabledTrading();
395 
396     event RemovedLimits();
397     
398     event TransferDelayDisabled();
399 
400 
401     modifier lockTheSwap() {
402         inSwapAndLiquify = true;
403         _;
404         inSwapAndLiquify = false;
405     }
406 
407     constructor(address _marketAddress) payable {
408         _rOwned[address(this)] = _rTotal/10*9;
409         _rOwned[owner()] = _rTotal/10*1;
410         minimumTokensBeforeSwap = _tTotal * 10 / 10000;
411         
412         marketingAddress = payable(_marketAddress); // marketing Address
413         
414         _isExcludedFromFee[owner()] = true;
415         _isExcludedFromFee[address(this)] = true;
416         _isExcludedFromFee[marketingAddress] = true;
417         
418         excludeFromMaxTransaction(owner(), true);
419         excludeFromMaxTransaction(address(this), true);
420         excludeFromMaxTransaction(address(0xdead), true);
421         excludeFromMaxTransaction(marketingAddress, true);
422         
423         excludeFromReward(msg.sender);
424         
425         emit Transfer(address(0xdead), address(this), _tTotal);
426     }
427 
428     function name() external pure returns (string memory) {
429         return _name;
430     }
431 
432     function symbol() external pure returns (string memory) {
433         return _symbol;
434     }
435 
436     function decimals() external pure returns (uint8) {
437         return _decimals;
438     }
439 
440     function totalSupply() external pure override returns (uint256) {
441         return _tTotal;
442     }
443 
444     function balanceOf(address account) public view override returns (uint256) {
445         if (_isExcluded[account]) return _tOwned[account];
446         return tokenFromReflection(_rOwned[account]);
447     }
448 
449     function transfer(address recipient, uint256 amount)
450         external
451         override
452         returns (bool)
453     {
454         _transfer(_msgSender(), recipient, amount);
455         return true;
456     }
457 
458     function allowance(address owner, address spender)
459         external
460         view
461         override
462         returns (uint256)
463     {
464         return _allowances[owner][spender];
465     }
466 
467     function approve(address spender, uint256 amount)
468         public
469         override
470         returns (bool)
471     {
472         _approve(_msgSender(), spender, amount);
473         return true;
474     }
475 
476     function transferFrom(
477         address sender,
478         address recipient,
479         uint256 amount
480     ) public returns (bool) {
481         _transfer(sender, recipient, amount);
482 
483         uint256 currentAllowance = _allowances[sender][_msgSender()];
484         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
485         unchecked {
486             _approve(sender, _msgSender(), currentAllowance - amount);
487         }
488 
489         return true;
490     }
491 
492     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
493         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
494         return true;
495     }
496 
497     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
498         uint256 currentAllowance = _allowances[_msgSender()][spender];
499         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
500         unchecked {
501             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
502         }
503 
504         return true;
505     }
506 
507     function isExcludedFromReward(address account)
508         external
509         view
510         returns (bool)
511     {
512         return _isExcluded[account];
513     }
514 
515     function totalFees() external view returns (uint256) {
516         return _tFeeTotal;
517     }
518     
519     // remove limits after token is stable - 30-60 minutes
520     function removeLimits() external onlyOwner {
521         limitsInEffect = false;
522         transferDelayEnabled = false;
523         emit RemovedLimits();
524     }
525     
526     // disable Transfer delay
527     function disableTransferDelay() external onlyOwner {
528         transferDelayEnabled = false;
529         emit TransferDelayDisabled();
530     }
531     
532 
533     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
534         _isExcludedMaxTransactionAmount[updAds] = isEx;
535     }
536             
537     function minimumTokensBeforeSwapAmount() external view returns (uint256) {
538         return minimumTokensBeforeSwap;
539     }
540 
541     function updateMarketingWallet(address newWallet) external onlyOwner {
542         marketingAddress = payable(newWallet);
543     }
544 
545     function updateMaxWallet(uint256 max) external onlyOwner {
546         _maxwallet = max*1e18;
547     }
548 
549     function manualswap() external onlyOwner() {
550         uint256 contractBalance = balanceOf(address(this));
551         swapTokensForETH(contractBalance);
552     }
553 
554     function manualsend() external onlyOwner() {
555         uint256 amount = address(this).balance;
556         payable(marketingAddress).transfer(amount);
557     }
558 
559      // change the minimum amount of tokens to sell from fees
560     function updateMinimumTokensBeforeSwap(uint256 newAmount) external onlyOwner{
561   	    require(newAmount >= _tTotal * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
562   	    require(newAmount <= _tTotal * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
563   	    minimumTokensBeforeSwap = newAmount;
564   	}
565 
566 
567     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
568         require(pair != lpPair, "The pair cannot be removed from automatedMarketMakerPairs");
569 
570         _setAutomatedMarketMakerPair(pair, value);
571     }
572 
573     function _setAutomatedMarketMakerPair(address pair, bool value) private {
574         automatedMarketMakerPairs[pair] = value;
575         _isExcludedMaxTransactionAmount[pair] = value;
576         if(value){excludeFromReward(pair);}
577         if(!value){includeInReward(pair);}
578     }
579 
580     function reflectionFromToken(uint256 tAmount, bool deductTransferFee)
581         external
582         view
583         returns (uint256)
584     {
585         require(tAmount <= _tTotal, "Amount must be less than supply");
586         if (!deductTransferFee) {
587             (uint256 rAmount, , , , , ) = _getValues(tAmount);
588             return rAmount;
589         } else {
590             (, uint256 rTransferAmount, , , , ) = _getValues(tAmount);
591             return rTransferAmount;
592         }
593     }
594 
595     function tokenFromReflection(uint256 rAmount)
596         public
597         view
598         returns (uint256)
599     {
600         require(
601             rAmount <= _rTotal,
602             "Amount must be less than total reflections"
603         );
604         uint256 currentRate = _getRate();
605         return rAmount / (currentRate);
606     }
607 
608     function excludeFromReward(address account) public onlyOwner {
609         require(!_isExcluded[account], "Account is already excluded");
610         require(_excluded.length + 1 <= 50, "Cannot exclude more than 50 accounts.  Include a previously excluded address.");
611         if (_rOwned[account] > 0) {
612             _tOwned[account] = tokenFromReflection(_rOwned[account]);
613         }
614         _isExcluded[account] = true;
615         _excluded.push(account);
616     }
617 
618     function includeInReward(address account) public onlyOwner {
619         require(_isExcluded[account], "Account is not excluded");
620         for (uint256 i = 0; i < _excluded.length; i++) {
621             if (_excluded[i] == account) {
622                 _excluded[i] = _excluded[_excluded.length - 1];
623                 _tOwned[account] = 0;
624                 _isExcluded[account] = false;
625                 _excluded.pop();
626                 break;
627             }
628         }
629     }
630  
631     function _approve(
632         address owner,
633         address spender,
634         uint256 amount
635     ) private {
636         require(owner != address(0), "ERC20: approve from the zero address");
637         require(spender != address(0), "ERC20: approve to the zero address");
638 
639         _allowances[owner][spender] = amount;
640         emit Approval(owner, spender, amount);
641     }
642 
643     function _transfer(
644         address from,
645         address to,
646         uint256 amount
647     ) private {
648         require(from != address(0), "ERC20: transfer from the zero address");
649         require(to != address(0), "ERC20: transfer to the zero address");
650         require(amount > 0, "Transfer amount must be greater than zero");
651         
652         if(!tradingActive){
653             require(_isExcludedFromFee[from] || _isExcludedFromFee[to], "Trading is not active yet.");
654         }
655 
656 
657         uint256 contractTokenBalance = balanceOf(address(this));
658         bool overMinimumTokenBalance = contractTokenBalance >= minimumTokensBeforeSwap;
659 
660         // swap and liquify
661         if (
662             !inSwapAndLiquify &&
663             swapAndLiquifyEnabled &&
664             balanceOf(lpPair) > 0 &&
665             !_isExcludedFromFee[to] &&
666             !_isExcludedFromFee[from] &&
667             automatedMarketMakerPairs[to] &&
668             overMinimumTokenBalance
669         ) {
670             swapBack();
671         }
672 
673         removeAllFee();
674         
675         buyOrSellSwitch = TRANSFER;
676         
677         if (!_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
678             // Buy
679             if (automatedMarketMakerPairs[from]) {
680                 _taxFee = _buyTaxFee;
681                 _liquidityFee = _buyLiquidityFee + _buyOperationsFee;
682                 require(balanceOf(to) + amount <= _maxwallet, "Exceeds the maxWalletSize.");
683                 if(_liquidityFee > 0){
684                     buyOrSellSwitch = BUY;
685                 }
686             } 
687             // Sell
688             else if (automatedMarketMakerPairs[to]) {
689                 _taxFee = _sellTaxFee;
690                 _liquidityFee = _sellLiquidityFee + _sellOperationsFee;
691                 if(_liquidityFee > 0){
692                     buyOrSellSwitch = SELL;
693                 }
694             }
695         }
696         
697         _tokenTransfer(from, to, amount);
698         
699         restoreAllFee();
700         
701     }
702 
703 
704     function swapBack() private lockTheSwap {
705 
706         uint256 contractBalance = balanceOf(address(this));
707         uint256 totalTokensToSwap = _liquidityTokensToSwap + _marketingTokensToSwap;
708         bool success;
709 
710         // prevent overly large contract sells.
711         if(contractBalance >= minimumTokensBeforeSwap * 20){
712             contractBalance = minimumTokensBeforeSwap * 20;
713         }
714 
715         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
716         
717         // Halve the amount of liquidity tokens
718         uint256 tokensForLiquidity = contractBalance * _liquidityTokensToSwap / totalTokensToSwap / 2;
719         uint256 amountToSwapForETH = contractBalance-(tokensForLiquidity);
720         
721         swapTokensForETH(amountToSwapForETH);
722         
723         uint256 ethBalance = address(this).balance;
724         
725         uint256 ethForOperations = ethBalance* (_marketingTokensToSwap) / (totalTokensToSwap - (_liquidityTokensToSwap/2));
726         
727         uint256 ethForLiquidity = ethBalance - ethForOperations;
728 
729         _liquidityTokensToSwap = 0;
730         _marketingTokensToSwap = 0;        
731         
732         if(tokensForLiquidity > 0 && ethForLiquidity > 0){
733             addLiquidity(tokensForLiquidity, ethForLiquidity);
734             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
735         }
736         
737         // send remainder to operations
738         (success,) = address(marketingAddress).call{value: address(this).balance}("");
739     }
740     
741     // force Swap back if slippage above 49% for launch.
742     function forceSwapBack() external onlyOwner {
743         uint256 contractBalance = balanceOf(address(this));
744         require(contractBalance >= minimumTokensBeforeSwap, "Can only swap back if above the threshold.");
745         swapBack();
746         emit OwnerForcedSwapBack(block.timestamp);
747     }
748     
749     function swapTokensForETH(uint256 tokenAmount) private {
750         address[] memory path = new address[](2);
751         path[0] = address(this);
752         path[1] = dexRouter.WETH();
753         _approve(address(this), address(dexRouter), tokenAmount);
754         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
755             tokenAmount,
756             0, // accept any amount of ETH
757             path,
758             address(this),
759             block.timestamp
760         );
761     }
762 
763     
764     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
765         _approve(address(this), address(dexRouter), tokenAmount);
766         dexRouter.addLiquidityETH{value: ethAmount}(
767             address(this),
768             tokenAmount,
769             0, // slippage is unavoidable
770             0, // slippage is unavoidable
771             address(0xdead),
772             block.timestamp
773         );
774     }
775 
776     function _tokenTransfer(
777         address sender,
778         address recipient,
779         uint256 amount
780     ) private {
781 
782         if (_isExcluded[sender] && !_isExcluded[recipient]) {
783             _transferFromExcluded(sender, recipient, amount);
784         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
785             _transferToExcluded(sender, recipient, amount);
786         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
787             _transferBothExcluded(sender, recipient, amount);
788         } else {
789             _transferStandard(sender, recipient, amount);
790         }
791     }
792 
793     function _transferStandard(
794         address sender,
795         address recipient,
796         uint256 tAmount
797     ) private {
798         (
799             uint256 rAmount,
800             uint256 rTransferAmount,
801             uint256 rFee,
802             uint256 tTransferAmount,
803             uint256 tFee,
804             uint256 tLiquidity
805         ) = _getValues(tAmount);
806         _rOwned[sender] = _rOwned[sender] - rAmount;
807         _rOwned[recipient] = _rOwned[recipient] + rTransferAmount;
808         _takeLiquidity(tLiquidity);
809         _reflectFee(rFee, tFee);
810         emit Transfer(sender, recipient, tTransferAmount);
811     }
812 
813     function _transferToExcluded(
814         address sender,
815         address recipient,
816         uint256 tAmount
817     ) private {
818         (
819             uint256 rAmount,
820             uint256 rTransferAmount,
821             uint256 rFee,
822             uint256 tTransferAmount,
823             uint256 tFee,
824             uint256 tLiquidity
825         ) = _getValues(tAmount);
826         _rOwned[sender] = _rOwned[sender] - (rAmount);
827         _tOwned[recipient] = _tOwned[recipient] + (tTransferAmount);
828         _rOwned[recipient] = _rOwned[recipient] + (rTransferAmount);
829         _takeLiquidity(tLiquidity);
830         _reflectFee(rFee, tFee);
831         emit Transfer(sender, recipient, tTransferAmount);
832     }
833 
834     function _transferFromExcluded(
835         address sender,
836         address recipient,
837         uint256 tAmount
838     ) private {
839         (
840             uint256 rAmount,
841             uint256 rTransferAmount,
842             uint256 rFee,
843             uint256 tTransferAmount,
844             uint256 tFee,
845             uint256 tLiquidity
846         ) = _getValues(tAmount);
847         _tOwned[sender] = _tOwned[sender]-(tAmount);
848         _rOwned[sender] = _rOwned[sender]-(rAmount);
849         _rOwned[recipient] = _rOwned[recipient]+(rTransferAmount);
850         _takeLiquidity(tLiquidity);
851         _reflectFee(rFee, tFee);
852         emit Transfer(sender, recipient, tTransferAmount);
853     }
854 
855     function _transferBothExcluded(
856         address sender,
857         address recipient,
858         uint256 tAmount
859     ) private {
860         (
861             uint256 rAmount,
862             uint256 rTransferAmount,
863             uint256 rFee,
864             uint256 tTransferAmount,
865             uint256 tFee,
866             uint256 tLiquidity
867         ) = _getValues(tAmount);
868         _tOwned[sender] = _tOwned[sender]-(tAmount);
869         _rOwned[sender] = _rOwned[sender]-(rAmount);
870         _tOwned[recipient] = _tOwned[recipient]+(tTransferAmount);
871         _rOwned[recipient] = _rOwned[recipient]+(rTransferAmount);
872         _takeLiquidity(tLiquidity);
873         _reflectFee(rFee, tFee);
874         emit Transfer(sender, recipient, tTransferAmount);
875     }
876 
877     function _reflectFee(uint256 rFee, uint256 tFee) private {
878         _rTotal = _rTotal-(rFee);
879         _tFeeTotal = _tFeeTotal+(tFee);
880     }
881 
882     function _getValues(uint256 tAmount)
883         private
884         view
885         returns (
886             uint256,
887             uint256,
888             uint256,
889             uint256,
890             uint256,
891             uint256
892         )
893     {
894         (
895             uint256 tTransferAmount,
896             uint256 tFee,
897             uint256 tLiquidity
898         ) = _getTValues(tAmount);
899         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
900             tAmount,
901             tFee,
902             tLiquidity,
903             _getRate()
904         );
905         return (
906             rAmount,
907             rTransferAmount,
908             rFee,
909             tTransferAmount,
910             tFee,
911             tLiquidity
912         );
913     }
914 
915     function _getTValues(uint256 tAmount)
916         private
917         view
918         returns (
919             uint256,
920             uint256,
921             uint256
922         )
923     {
924         uint256 tFee = calculateTaxFee(tAmount);
925         uint256 tLiquidity = calculateLiquidityFee(tAmount);
926         uint256 tTransferAmount = tAmount-(tFee)-(tLiquidity);
927         return (tTransferAmount, tFee, tLiquidity);
928     }
929 
930     function _getRValues(
931         uint256 tAmount,
932         uint256 tFee,
933         uint256 tLiquidity,
934         uint256 currentRate
935     )
936         private
937         pure
938         returns (
939             uint256,
940             uint256,
941             uint256
942         )
943     {
944         uint256 rAmount = tAmount*(currentRate);
945         uint256 rFee = tFee*(currentRate);
946         uint256 rLiquidity = tLiquidity*(currentRate);
947         uint256 rTransferAmount = rAmount-(rFee)-(rLiquidity);
948         return (rAmount, rTransferAmount, rFee);
949     }
950 
951     function _getRate() private view returns (uint256) {
952         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
953         return rSupply / (tSupply);
954     }
955 
956     function _getCurrentSupply() private view returns (uint256, uint256) {
957         uint256 rSupply = _rTotal;
958         uint256 tSupply = _tTotal;
959         for (uint256 i = 0; i < _excluded.length; i++) {
960             if (
961                 _rOwned[_excluded[i]] > rSupply ||
962                 _tOwned[_excluded[i]] > tSupply
963             ) return (_rTotal, _tTotal);
964             rSupply = rSupply-(_rOwned[_excluded[i]]);
965             tSupply = tSupply-(_tOwned[_excluded[i]]);
966         }
967         if (rSupply < _rTotal / (_tTotal)) return (_rTotal, _tTotal);
968         return (rSupply, tSupply);
969     }
970 
971     function _takeLiquidity(uint256 tLiquidity) private {
972         if(buyOrSellSwitch == BUY){
973             _liquidityTokensToSwap += tLiquidity * _buyLiquidityFee / _liquidityFee;
974             _marketingTokensToSwap += tLiquidity * _buyOperationsFee / _liquidityFee;
975         } else if(buyOrSellSwitch == SELL){
976             _liquidityTokensToSwap += tLiquidity * _sellLiquidityFee / _liquidityFee;
977             _marketingTokensToSwap += tLiquidity * _sellOperationsFee / _liquidityFee;
978         }
979         uint256 currentRate = _getRate();
980         uint256 rLiquidity = tLiquidity * (currentRate);
981         _rOwned[address(this)] = _rOwned[address(this)] + rLiquidity;
982         if (_isExcluded[address(this)])
983             _tOwned[address(this)] = _tOwned[address(this)] + tLiquidity;
984     }
985 
986     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
987         return _amount * _taxFee / 10000;
988     }
989 
990     function calculateLiquidityFee(uint256 _amount)
991         private
992         view
993         returns (uint256)
994     {
995         return _amount * _liquidityFee / 10000;
996     }
997 
998     function removeAllFee() private {
999         if (_taxFee == 0 && _liquidityFee == 0) return;
1000 
1001         _previousTaxFee = _taxFee;
1002         _previousLiquidityFee = _liquidityFee;
1003 
1004         _taxFee = 0;
1005         _liquidityFee = 0;
1006     }
1007 
1008     function restoreAllFee() private {
1009         _taxFee = _previousTaxFee;
1010         _liquidityFee = _previousLiquidityFee;
1011     }
1012 
1013     function isExcludedFromFee(address account) external view returns (bool) {
1014         return _isExcludedFromFee[account];
1015     }
1016 
1017     function excludeFromFee(address account) external onlyOwner {
1018         _isExcludedFromFee[account] = true;
1019         emit ExcludeFromFee(account);
1020     }
1021 
1022     function includeInFee(address account) external onlyOwner {
1023         _isExcludedFromFee[account] = false;
1024         emit IncludeInFee(account);
1025     }
1026 
1027     function setBuyFee(uint256 buyTaxFee, uint256 buyLiquidityFee, uint256 buyOperationsFee)
1028         external
1029         onlyOwner
1030     {
1031         _buyTaxFee = buyTaxFee;
1032         _buyLiquidityFee = buyLiquidityFee;
1033         _buyOperationsFee = buyOperationsFee;
1034         require(_buyTaxFee + _buyLiquidityFee + _buyOperationsFee <= 4500, "Must keep buy taxes below 45%");
1035         emit SetBuyFee(buyOperationsFee, buyLiquidityFee, buyTaxFee);
1036     }
1037 
1038     function setSellFee(uint256 sellTaxFee, uint256 sellLiquidityFee, uint256 sellOperationsFee)
1039         external
1040         onlyOwner
1041     {
1042         _sellTaxFee = sellTaxFee;
1043         _sellLiquidityFee = sellLiquidityFee;
1044         _sellOperationsFee = sellOperationsFee;
1045         require(_sellTaxFee + _sellLiquidityFee + _sellOperationsFee <= 5000, "Must keep sell taxes below 50%");
1046         emit SetSellFee(sellOperationsFee, sellLiquidityFee, sellTaxFee);
1047     }
1048     
1049     function setOperationsAddress(address _marketingAddress) external onlyOwner {
1050         require(_marketingAddress != address(0), "_operationsAddress address cannot be 0");
1051         _isExcludedFromFee[marketingAddress] = false;
1052         marketingAddress = payable(_marketingAddress);
1053         _isExcludedFromFee[marketingAddress] = true;
1054         emit UpdatedOperationsAddress(_marketingAddress);
1055     }
1056 
1057     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1058         swapAndLiquifyEnabled = _enabled;
1059         emit SwapAndLiquifyEnabledUpdated(_enabled);
1060     }
1061 
1062     // To receive ETH from dexRouter when swapping
1063     receive() external payable {}
1064 
1065     function transferForeignToken(address _token, address _to)
1066         external
1067         onlyOwner
1068         returns (bool _sent)
1069     {
1070         require(_token != address(0), "_token address cannot be 0");
1071         require(_token != address(this), "Can't withdraw native tokens");
1072         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
1073         _sent = IERC20(_token).transfer(_to, _contractBalance);
1074         emit TransferForeignToken(_token, _contractBalance);
1075     }
1076     
1077     function withdrawStuckETH() external onlyOwner {
1078         bool success;
1079         (success,) = address(msg.sender).call{value: address(this).balance}("");
1080     }
1081 
1082     function addliquidity() external onlyOwner {
1083         require(!tradingActive, "Trading is already active, cannot relaunch.");
1084 
1085         removeAllFee();
1086 
1087         //standard enable trading
1088         tradingActive = true;
1089         swapAndLiquifyEnabled = true;
1090         emit EnabledTrading();
1091 
1092         // initialize router
1093         IDexRouter _dexRouter = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
1094         dexRouter = _dexRouter;
1095 
1096         // create pair
1097         lpPair = IDexFactory(_dexRouter.factory()).createPair(address(this), _dexRouter.WETH());
1098         excludeFromMaxTransaction(address(lpPair), true);
1099         _setAutomatedMarketMakerPair(address(lpPair), true);
1100 
1101         // transfer tokens to deployer
1102 
1103 
1104    
1105         // add the liquidity
1106 
1107         require(address(this).balance > 0, "Must have ETH on contract to launch");
1108 
1109         require(balanceOf(address(this)) > 0, "Must have Tokens on contract to launch");
1110 
1111         _approve(address(this), address(dexRouter), balanceOf(address(this)));
1112         dexRouter.addLiquidityETH{value: address(this).balance}(
1113             address(this),
1114             balanceOf(address(this)),
1115             0, // slippage is unavoidable
1116             0, // slippage is unavoidable
1117             msg.sender,
1118             block.timestamp
1119         );
1120         restoreAllFee();
1121     }
1122 }