1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.11;
3 
4 abstract contract Context {
5     function _msgSender() internal view virtual returns (address payable) {
6         return payable(msg.sender);
7     }
8 
9     function _msgData() internal view virtual returns (bytes memory) {
10         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
11         return msg.data;
12     }
13 }
14 
15 interface IERC20 {
16     function totalSupply() external view returns (uint256);
17 
18     function balanceOf(address account) external view returns (uint256);
19 
20     function transfer(address recipient, uint256 amount)
21         external
22         returns (bool);
23 
24     function allowance(address owner, address spender)
25         external
26         view
27         returns (uint256);
28 
29     function approve(address spender, uint256 amount) external returns (bool);
30 
31     function transferFrom(
32         address sender,
33         address recipient,
34         uint256 amount
35     ) external returns (bool);
36 
37     event Transfer(address indexed from, address indexed to, uint256 value);
38     event Approval(
39         address indexed owner,
40         address indexed spender,
41         uint256 value
42     );
43 }
44 
45 library SafeMath {
46     function add(uint256 a, uint256 b) internal pure returns (uint256) {
47         uint256 c = a + b;
48         require(c >= a, "SafeMath: addition overflow");
49 
50         return c;
51     }
52 
53     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
54         return sub(a, b, "SafeMath: subtraction overflow");
55     }
56 
57     function sub(
58         uint256 a,
59         uint256 b,
60         string memory errorMessage
61     ) internal pure returns (uint256) {
62         require(b <= a, errorMessage);
63         uint256 c = a - b;
64 
65         return c;
66     }
67 
68     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
69         if (a == 0) {
70             return 0;
71         }
72 
73         uint256 c = a * b;
74         require(c / a == b, "SafeMath: multiplication overflow");
75 
76         return c;
77     }
78 
79     function div(uint256 a, uint256 b) internal pure returns (uint256) {
80         return div(a, b, "SafeMath: division by zero");
81     }
82 
83     function div(
84         uint256 a,
85         uint256 b,
86         string memory errorMessage
87     ) internal pure returns (uint256) {
88         require(b > 0, errorMessage);
89         uint256 c = a / b;
90         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
91 
92         return c;
93     }
94 
95     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
96         return mod(a, b, "SafeMath: modulo by zero");
97     }
98 
99     function mod(
100         uint256 a,
101         uint256 b,
102         string memory errorMessage
103     ) internal pure returns (uint256) {
104         require(b != 0, errorMessage);
105         return a % b;
106     }
107 }
108 
109 library Address {
110     function isContract(address account) internal view returns (bool) {
111         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
112         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
113         // for accounts without code, i.e. `keccak256('')`
114         bytes32 codehash;
115         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
116         // solhint-disable-next-line no-inline-assembly
117         assembly {
118             codehash := extcodehash(account)
119         }
120         return (codehash != accountHash && codehash != 0x0);
121     }
122 
123     function sendValue(address payable recipient, uint256 amount) internal {
124         require(
125             address(this).balance >= amount,
126             "Address: insufficient balance"
127         );
128 
129         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
130         (bool success, ) = recipient.call{value: amount}("");
131         require(
132             success,
133             "Address: unable to send value, recipient may have reverted"
134         );
135     }
136 
137     function functionCall(address target, bytes memory data)
138         internal
139         returns (bytes memory)
140     {
141         return functionCall(target, data, "Address: low-level call failed");
142     }
143 
144     function functionCall(
145         address target,
146         bytes memory data,
147         string memory errorMessage
148     ) internal returns (bytes memory) {
149         return _functionCallWithValue(target, data, 0, errorMessage);
150     }
151 
152     function functionCallWithValue(
153         address target,
154         bytes memory data,
155         uint256 value
156     ) internal returns (bytes memory) {
157         return
158             functionCallWithValue(
159                 target,
160                 data,
161                 value,
162                 "Address: low-level call with value failed"
163             );
164     }
165 
166     function functionCallWithValue(
167         address target,
168         bytes memory data,
169         uint256 value,
170         string memory errorMessage
171     ) internal returns (bytes memory) {
172         require(
173             address(this).balance >= value,
174             "Address: insufficient balance for call"
175         );
176         return _functionCallWithValue(target, data, value, errorMessage);
177     }
178 
179     function _functionCallWithValue(
180         address target,
181         bytes memory data,
182         uint256 weiValue,
183         string memory errorMessage
184     ) private returns (bytes memory) {
185         require(isContract(target), "Address: call to non-contract");
186 
187         (bool success, bytes memory returndata) = target.call{value: weiValue}(
188             data
189         );
190         if (success) {
191             return returndata;
192         } else {
193             if (returndata.length > 0) {
194                 assembly {
195                     let returndata_size := mload(returndata)
196                     revert(add(32, returndata), returndata_size)
197                 }
198             } else {
199                 revert(errorMessage);
200             }
201         }
202     }
203 }
204 
205 contract Ownable is Context {
206     address private _owner;
207     address private _previousOwner;
208 
209     event OwnershipTransferred(
210         address indexed previousOwner,
211         address indexed newOwner
212     );
213 
214     constructor() {
215         address msgSender = _msgSender();
216         _owner = msgSender;
217         emit OwnershipTransferred(address(0), msgSender);
218     }
219 
220     function owner() public view returns (address) {
221         return _owner;
222     }
223 
224     modifier onlyOwner() {
225         require(_owner == _msgSender(), "Ownable: caller is not the owner");
226         _;
227     }
228 
229     function renounceOwnership() external virtual onlyOwner {
230         emit OwnershipTransferred(_owner, address(0));
231         _owner = address(0);
232     }
233 
234     function transferOwnership(address newOwner) external virtual onlyOwner {
235         require(
236             newOwner != address(0),
237             "Ownable: new owner is the zero address"
238         );
239         emit OwnershipTransferred(_owner, newOwner);
240         _owner = newOwner;
241     }
242 
243     function getTime() public view returns (uint256) {
244         return block.timestamp;
245     }
246 }
247 
248 
249 interface IDexRouter {
250     function factory() external pure returns (address);
251     function WETH() external pure returns (address);
252     
253     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
254 
255     function swapExactTokensForETHSupportingFeeOnTransferTokens(
256         uint amountIn,
257         uint amountOutMin,
258         address[] calldata path,
259         address to,
260         uint deadline
261     ) external;
262 
263     function swapExactETHForTokensSupportingFeeOnTransferTokens(
264         uint amountOutMin,
265         address[] calldata path,
266         address to,
267         uint deadline
268     ) external payable;
269 
270     function addLiquidityETH(
271         address token,
272         uint256 amountTokenDesired,
273         uint256 amountTokenMin,
274         uint256 amountETHMin,
275         address to,
276         uint256 deadline
277     )
278         external
279         payable
280         returns (
281             uint256 amountToken,
282             uint256 amountETH,
283             uint256 liquidity
284         );
285         
286 }
287 
288 interface IDexFactory {
289     function createPair(address tokenA, address tokenB)
290         external
291         returns (address pair);
292 }
293 
294 contract KZN is Context, IERC20, Ownable {
295     using Address for address;
296 
297     address payable public operationsAddress;
298     address payable public devAddress;      
299         
300     mapping(address => uint256) private _rOwned;
301     mapping(address => uint256) private _tOwned;
302     mapping(address => mapping(address => uint256)) private _allowances;
303     
304     // Anti-bot and anti-whale mappings and variables
305     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
306     bool public transferDelayEnabled = true;
307     bool public limitsInEffect = true;
308 
309     mapping(address => bool) private _isExcludedFromFee;
310 
311     mapping(address => bool) private _isExcluded;
312     address[] private _excluded;
313     
314     uint256 private constant MAX = ~uint256(0);
315     uint256 private constant _tTotal = 100 * 1e6 * 1e18;
316     uint256 private _rTotal = (MAX - (MAX % _tTotal));
317     uint256 private _tFeeTotal;
318 
319     string private constant _name = "Kaizen Corp";
320     string private constant _symbol = "KZN";
321     uint8 private constant _decimals = 18;
322 
323     // these values are pretty much arbitrary since they get overwritten for every txn, but the placeholders make it easier to work with current contract.
324     uint256 private _taxFee;
325     uint256 private _previousTaxFee = _taxFee;
326 
327     uint256 private _operationsFee;
328     
329     uint256 private _liquidityFee;
330     uint256 private _previousLiquidityFee = _liquidityFee;
331     
332     uint256 private constant BUY = 1;
333     uint256 private constant SELL = 2;
334     uint256 private constant TRANSFER = 3;
335     uint256 private buyOrSellSwitch;
336 
337     uint256 public _buyTaxFee = 100;
338     uint256 public _buyLiquidityFee = 0;
339     uint256 public _buyOperationsFee = 3400;
340 
341     uint256 public _sellTaxFee = 100;
342     uint256 public _sellLiquidityFee = 0;
343     uint256 public _sellOperationsFee = 3400;
344 
345     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
346     uint256 public blockForPenaltyEnd;
347     mapping (address => bool) public boughtEarly;
348     uint256 public botsCaught;
349     
350     uint256 public _liquidityTokensToSwap;
351     uint256 public _operationsTokensToSwap;
352     
353     uint256 public maxTransactionAmount;
354     mapping (address => bool) public _isExcludedMaxTransactionAmount;
355     uint256 public maxWallet;
356     
357     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
358     // could be subject to a maximum transfer amount
359     mapping (address => bool) public automatedMarketMakerPairs;
360 
361     uint256 private minimumTokensBeforeSwap;
362 
363     IDexRouter public dexRouter;
364     address public lpPair;
365 
366     bool inSwapAndLiquify;
367     bool public swapAndLiquifyEnabled = false;
368     bool public tradingActive = false;
369     bool public highTaxModeEnabled = true;
370     bool public flagBotsEnabled = true;
371 
372     event SwapAndLiquifyEnabledUpdated(bool enabled);
373     event SwapAndLiquify(
374         uint256 tokensSwapped,
375         uint256 ethReceived,
376         uint256 tokensIntoLiquidity
377     );
378 
379     event SwapETHForTokens(uint256 amountIn, address[] path);
380 
381     event SwapTokensForETH(uint256 amountIn, address[] path);
382     
383     event SetAutomatedMarketMakerPair(address pair, bool value);
384     
385     event ExcludeFromReward(address excludedAddress);
386     
387     event IncludeInReward(address includedAddress);
388     
389     event ExcludeFromFee(address excludedAddress);
390     
391     event IncludeInFee(address includedAddress);
392     
393     event SetBuyFee(uint256 operationsFee, uint256 liquidityFee, uint256 reflectFee);
394     
395     event SetSellFee(uint256 operationsFee, uint256 liquidityFee, uint256 reflectFee);
396     
397     event TransferForeignToken(address token, uint256 amount);
398     
399     event UpdatedOperationsAddress(address operations);
400     
401     event OwnerForcedSwapBack(uint256 timestamp);
402 
403     event CaughtEarlyBuyer(address sniper);
404 
405     event EnabledTrading();
406 
407     event RemovedLimits();
408 
409     event EnabledLimits();
410     
411     event TransferDelayDisabled();
412 
413     event DisabledHighTaxModeForever();
414     event DisabledMarkBotModeForever();
415 
416     modifier lockTheSwap() {
417         inSwapAndLiquify = true;
418         _;
419         inSwapAndLiquify = false;
420     }
421 
422     constructor() payable {
423         _rOwned[address(this)] = _rTotal/100*3;
424         _rOwned[msg.sender] = _rTotal/100*97;
425         
426         maxTransactionAmount = _tTotal * 3 / 10000;
427         minimumTokensBeforeSwap = _tTotal * 50 / 100000;
428         
429         operationsAddress = payable(msg.sender); // Operations Address
430         
431         _isExcludedFromFee[owner()] = true;
432         _isExcludedFromFee[address(this)] = true;
433         _isExcludedFromFee[operationsAddress] = true;
434         
435         excludeFromMaxTransaction(owner(), true);
436         excludeFromMaxTransaction(address(this), true);
437         excludeFromMaxTransaction(address(0xdead), true);
438         excludeFromMaxTransaction(operationsAddress, true);
439         
440         excludeFromReward(msg.sender);
441         
442         emit Transfer(address(0), address(this), _tTotal/100*3);
443         emit Transfer(address(0), address(msg.sender), _tTotal/100*97);
444     }
445 
446     function name() external pure returns (string memory) {
447         return _name;
448     }
449 
450     function symbol() external pure returns (string memory) {
451         return _symbol;
452     }
453 
454     function decimals() external pure returns (uint8) {
455         return _decimals;
456     }
457 
458     function totalSupply() external pure override returns (uint256) {
459         return _tTotal;
460     }
461 
462     function balanceOf(address account) public view override returns (uint256) {
463         if (_isExcluded[account]) return _tOwned[account];
464         return tokenFromReflection(_rOwned[account]);
465     }
466 
467     function transfer(address recipient, uint256 amount)
468         external
469         override
470         returns (bool)
471     {
472         _transfer(_msgSender(), recipient, amount);
473         return true;
474     }
475 
476     function allowance(address owner, address spender)
477         external
478         view
479         override
480         returns (uint256)
481     {
482         return _allowances[owner][spender];
483     }
484 
485     function approve(address spender, uint256 amount)
486         public
487         override
488         returns (bool)
489     {
490         _approve(_msgSender(), spender, amount);
491         return true;
492     }
493 
494     function transferFrom(
495         address sender,
496         address recipient,
497         uint256 amount
498     ) public returns (bool) {
499         _transfer(sender, recipient, amount);
500 
501         uint256 currentAllowance = _allowances[sender][_msgSender()];
502         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
503         unchecked {
504             _approve(sender, _msgSender(), currentAllowance - amount);
505         }
506 
507         return true;
508     }
509 
510     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
511         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
512         return true;
513     }
514 
515     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
516         uint256 currentAllowance = _allowances[_msgSender()][spender];
517         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
518         unchecked {
519             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
520         }
521 
522         return true;
523     }
524 
525     function isExcludedFromReward(address account)
526         external
527         view
528         returns (bool)
529     {
530         return _isExcluded[account];
531     }
532 
533     function totalFees() external view returns (uint256) {
534         return _tFeeTotal;
535     }
536     
537     // remove limits after token is stable - 30-60 minutes
538     function removeLimits() external onlyOwner {
539         limitsInEffect = false;
540         transferDelayEnabled = false;
541         emit RemovedLimits();
542     }
543 
544     // enableLimits...just in case it will be needed
545     function enableLimits() external onlyOwner {
546         limitsInEffect = true;    
547         emit EnabledLimits();
548     }    
549     
550     // disable Transfer delay
551     function disableTransferDelay() external onlyOwner {
552         transferDelayEnabled = false;
553         emit TransferDelayDisabled();
554     }
555 
556     function disableFlagBotsForever() external onlyOwner {
557         require(
558             flagBotsEnabled,
559             "Flag bot functionality already disabled forever!!"
560         );
561 
562         flagBotsEnabled = false;
563 
564         emit DisabledMarkBotModeForever();
565     }
566     
567     function addBoughtEarly(address wallet) external onlyOwner {
568         require(
569             flagBotsEnabled,
570             "Flag bot functionality has been disabled forever!"
571         );        
572         require(!boughtEarly[wallet], "Wallet is already flagged.");
573         boughtEarly[wallet] = true;
574     }
575 
576     function removeBoughtEarly(address wallet) external onlyOwner {
577         require(boughtEarly[wallet], "Wallet is already not flagged.");
578         boughtEarly[wallet] = false;
579     }    
580 
581     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
582         _isExcludedMaxTransactionAmount[updAds] = isEx;
583     }
584             
585     function minimumTokensBeforeSwapAmount() external view returns (uint256) {
586         return minimumTokensBeforeSwap;
587     }
588 
589      // change the minimum amount of tokens to sell from fees
590     function updateMinimumTokensBeforeSwap(uint256 newAmount) external onlyOwner{
591   	    require(newAmount >= _tTotal * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
592   	    require(newAmount <= _tTotal * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
593   	    minimumTokensBeforeSwap = newAmount;
594   	}
595 
596     function updateMaxAmount(uint256 newNum) external onlyOwner {
597         require(newNum >= (_tTotal * 2 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.2%");
598         maxTransactionAmount = newNum * (1e18);
599     }
600 
601     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
602         require(pair != lpPair, "The pair cannot be removed from automatedMarketMakerPairs");
603 
604         _setAutomatedMarketMakerPair(pair, value);
605     }
606 
607     function _setAutomatedMarketMakerPair(address pair, bool value) private {
608         automatedMarketMakerPairs[pair] = value;
609         _isExcludedMaxTransactionAmount[pair] = value;
610         if(value){excludeFromReward(pair);}
611         if(!value){includeInReward(pair);}
612     }
613 
614     function reflectionFromToken(uint256 tAmount, bool deductTransferFee)
615         external
616         view
617         returns (uint256)
618     {
619         require(tAmount <= _tTotal, "Amount must be less than supply");
620         if (!deductTransferFee) {
621             (uint256 rAmount, , , , , ) = _getValues(tAmount);
622             return rAmount;
623         } else {
624             (, uint256 rTransferAmount, , , , ) = _getValues(tAmount);
625             return rTransferAmount;
626         }
627     }
628 
629     function tokenFromReflection(uint256 rAmount)
630         public
631         view
632         returns (uint256)
633     {
634         require(
635             rAmount <= _rTotal,
636             "Amount must be less than total reflections"
637         );
638         uint256 currentRate = _getRate();
639         return rAmount / (currentRate);
640     }
641 
642     function excludeFromReward(address account) public onlyOwner {
643         require(!_isExcluded[account], "Account is already excluded");
644         require(_excluded.length + 1 <= 50, "Cannot exclude more than 50 accounts.  Include a previously excluded address.");
645         if (_rOwned[account] > 0) {
646             _tOwned[account] = tokenFromReflection(_rOwned[account]);
647         }
648         _isExcluded[account] = true;
649         _excluded.push(account);
650     }
651 
652     function includeInReward(address account) public onlyOwner {
653         require(_isExcluded[account], "Account is not excluded");
654         for (uint256 i = 0; i < _excluded.length; i++) {
655             if (_excluded[i] == account) {
656                 _excluded[i] = _excluded[_excluded.length - 1];
657                 _tOwned[account] = 0;
658                 _isExcluded[account] = false;
659                 _excluded.pop();
660                 break;
661             }
662         }
663     }
664  
665     function _approve(
666         address owner,
667         address spender,
668         uint256 amount
669     ) private {
670         require(owner != address(0), "ERC20: approve from the zero address");
671         require(spender != address(0), "ERC20: approve to the zero address");
672 
673         _allowances[owner][spender] = amount;
674         emit Approval(owner, spender, amount);
675     }
676 
677     function _transfer(
678         address from,
679         address to,
680         uint256 amount
681     ) private {
682         require(from != address(0), "ERC20: transfer from the zero address");
683         require(to != address(0), "ERC20: transfer to the zero address");
684         require(amount > 0, "Transfer amount must be greater than zero");
685         
686         if(!tradingActive){
687             require(_isExcludedFromFee[from] || _isExcludedFromFee[to], "Trading is not active yet.");
688         }
689 
690         if(!earlyBuyPenaltyInEffect()){
691             require(!boughtEarly[from] || to == owner() || to == address(0xdead), "Bots cannot transfer tokens in or out except to owner or dead address.");
692         }
693 
694         if(limitsInEffect){
695             if (
696                 from != owner() &&
697                 to != owner() &&
698                 to != address(0) &&
699                 to != address(0xdead) &&
700                 !inSwapAndLiquify
701             ){                
702 
703                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
704                 if (transferDelayEnabled){
705                     if (to != address(dexRouter) && to != address(lpPair)){
706                         require(_holderLastTransferTimestamp[tx.origin] < block.number && _holderLastTransferTimestamp[to] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
707                         _holderLastTransferTimestamp[tx.origin] = block.number;
708                         _holderLastTransferTimestamp[to] = block.number;
709                     }
710                 }
711                 
712                 //when buy
713                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
714                     require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
715                 } 
716                 //when sell
717                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
718                     require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
719                 }
720             }
721         }
722 
723         uint256 contractTokenBalance = balanceOf(address(this));
724         bool overMinimumTokenBalance = contractTokenBalance >= minimumTokensBeforeSwap;
725 
726         // swap and liquify
727         if (
728             !inSwapAndLiquify &&
729             swapAndLiquifyEnabled &&
730             balanceOf(lpPair) > 0 &&
731             !_isExcludedFromFee[to] &&
732             !_isExcludedFromFee[from] &&
733             automatedMarketMakerPairs[to] &&
734             overMinimumTokenBalance
735         ) {
736             swapBack();
737         }
738 
739         removeAllFee();
740         
741         buyOrSellSwitch = TRANSFER;
742         
743         if (!_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
744             if(earlyBuyPenaltyInEffect() && automatedMarketMakerPairs[from] && !automatedMarketMakerPairs[to]){
745                 
746                 if(!boughtEarly[to]){
747                     boughtEarly[to] = true;
748                     botsCaught += 1;
749                     emit CaughtEarlyBuyer(to);
750                 }
751 
752                 _taxFee = _buyTaxFee;
753                 _liquidityFee = _buyLiquidityFee + _buyOperationsFee;
754                 if(_liquidityFee > 0){
755                     buyOrSellSwitch = BUY;
756                 }
757             }
758 
759             // Buy
760             if (automatedMarketMakerPairs[from]) {
761                 _taxFee = _buyTaxFee;
762                 _liquidityFee = _buyLiquidityFee + _buyOperationsFee;
763                 if(_liquidityFee > 0){
764                     buyOrSellSwitch = BUY;
765                 }
766             } 
767             // Sell
768             else if (automatedMarketMakerPairs[to]) {
769                 _taxFee = _sellTaxFee;
770                 _liquidityFee = _sellLiquidityFee + _sellOperationsFee;
771                 if(_liquidityFee > 0){
772                     buyOrSellSwitch = SELL;
773                 }
774             }
775         }
776         
777         _tokenTransfer(from, to, amount);
778         
779         restoreAllFee();
780         
781     }
782 
783     function earlyBuyPenaltyInEffect() public view returns (bool){
784         return block.number < blockForPenaltyEnd;
785     }
786 
787     function swapBack() private lockTheSwap {
788 
789         uint256 contractBalance = balanceOf(address(this));
790         uint256 totalTokensToSwap = _liquidityTokensToSwap + _operationsTokensToSwap;
791         bool success;
792 
793         // prevent overly large contract sells.
794         if(contractBalance >= minimumTokensBeforeSwap * 20){
795             contractBalance = minimumTokensBeforeSwap * 20;
796         }
797 
798         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
799         
800         // Halve the amount of liquidity tokens
801         uint256 tokensForLiquidity = contractBalance * _liquidityTokensToSwap / totalTokensToSwap / 2;
802         uint256 amountToSwapForETH = contractBalance-(tokensForLiquidity);
803         
804         swapTokensForETH(amountToSwapForETH);
805         
806         uint256 ethBalance = address(this).balance;
807         
808         uint256 ethForOperations = ethBalance* (_operationsTokensToSwap) / (totalTokensToSwap - (_liquidityTokensToSwap/2));
809         
810         uint256 ethForLiquidity = ethBalance - ethForOperations;
811 
812         _liquidityTokensToSwap = 0;
813         _operationsTokensToSwap = 0;        
814         
815         if(tokensForLiquidity > 0 && ethForLiquidity > 0){
816             addLiquidity(tokensForLiquidity, ethForLiquidity);
817             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
818         }
819         
820         // send remainder to operations
821         (success,) = address(operationsAddress).call{value: address(this).balance}("");
822     }
823     
824     // force Swap back if slippage above 49% for launch.
825     function forceSwapBack() external onlyOwner {
826         uint256 contractBalance = balanceOf(address(this));
827         require(contractBalance >= minimumTokensBeforeSwap, "Can only swap back if above the threshold.");
828         swapBack();
829         emit OwnerForcedSwapBack(block.timestamp);
830     }
831     
832     function swapTokensForETH(uint256 tokenAmount) private {
833         address[] memory path = new address[](2);
834         path[0] = address(this);
835         path[1] = dexRouter.WETH();
836         _approve(address(this), address(dexRouter), tokenAmount);
837         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
838             tokenAmount,
839             0, // accept any amount of ETH
840             path,
841             address(this),
842             block.timestamp
843         );
844     }
845     
846     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
847         _approve(address(this), address(dexRouter), tokenAmount);
848         dexRouter.addLiquidityETH{value: ethAmount}(
849             address(this),
850             tokenAmount,
851             0, // slippage is unavoidable
852             0, // slippage is unavoidable
853             address(0xdead),
854             block.timestamp
855         );
856     }
857 
858     function _tokenTransfer(
859         address sender,
860         address recipient,
861         uint256 amount
862     ) private {
863 
864         if (_isExcluded[sender] && !_isExcluded[recipient]) {
865             _transferFromExcluded(sender, recipient, amount);
866         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
867             _transferToExcluded(sender, recipient, amount);
868         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
869             _transferBothExcluded(sender, recipient, amount);
870         } else {
871             _transferStandard(sender, recipient, amount);
872         }
873     }
874 
875     function _transferStandard(
876         address sender,
877         address recipient,
878         uint256 tAmount
879     ) private {
880         (
881             uint256 rAmount,
882             uint256 rTransferAmount,
883             uint256 rFee,
884             uint256 tTransferAmount,
885             uint256 tFee,
886             uint256 tLiquidity
887         ) = _getValues(tAmount);
888         _rOwned[sender] = _rOwned[sender] - rAmount;
889         _rOwned[recipient] = _rOwned[recipient] + rTransferAmount;
890         _takeLiquidity(tLiquidity);
891         _reflectFee(rFee, tFee);
892         emit Transfer(sender, recipient, tTransferAmount);
893     }
894 
895     function _transferToExcluded(
896         address sender,
897         address recipient,
898         uint256 tAmount
899     ) private {
900         (
901             uint256 rAmount,
902             uint256 rTransferAmount,
903             uint256 rFee,
904             uint256 tTransferAmount,
905             uint256 tFee,
906             uint256 tLiquidity
907         ) = _getValues(tAmount);
908         _rOwned[sender] = _rOwned[sender] - (rAmount);
909         _tOwned[recipient] = _tOwned[recipient] + (tTransferAmount);
910         _rOwned[recipient] = _rOwned[recipient] + (rTransferAmount);
911         _takeLiquidity(tLiquidity);
912         _reflectFee(rFee, tFee);
913         emit Transfer(sender, recipient, tTransferAmount);
914     }
915 
916     function _transferFromExcluded(
917         address sender,
918         address recipient,
919         uint256 tAmount
920     ) private {
921         (
922             uint256 rAmount,
923             uint256 rTransferAmount,
924             uint256 rFee,
925             uint256 tTransferAmount,
926             uint256 tFee,
927             uint256 tLiquidity
928         ) = _getValues(tAmount);
929         _tOwned[sender] = _tOwned[sender]-(tAmount);
930         _rOwned[sender] = _rOwned[sender]-(rAmount);
931         _rOwned[recipient] = _rOwned[recipient]+(rTransferAmount);
932         _takeLiquidity(tLiquidity);
933         _reflectFee(rFee, tFee);
934         emit Transfer(sender, recipient, tTransferAmount);
935     }
936 
937     function _transferBothExcluded(
938         address sender,
939         address recipient,
940         uint256 tAmount
941     ) private {
942         (
943             uint256 rAmount,
944             uint256 rTransferAmount,
945             uint256 rFee,
946             uint256 tTransferAmount,
947             uint256 tFee,
948             uint256 tLiquidity
949         ) = _getValues(tAmount);
950         _tOwned[sender] = _tOwned[sender]-(tAmount);
951         _rOwned[sender] = _rOwned[sender]-(rAmount);
952         _tOwned[recipient] = _tOwned[recipient]+(tTransferAmount);
953         _rOwned[recipient] = _rOwned[recipient]+(rTransferAmount);
954         _takeLiquidity(tLiquidity);
955         _reflectFee(rFee, tFee);
956         emit Transfer(sender, recipient, tTransferAmount);
957     }
958 
959     function _reflectFee(uint256 rFee, uint256 tFee) private {
960         _rTotal = _rTotal-(rFee);
961         _tFeeTotal = _tFeeTotal+(tFee);
962     }
963 
964     function _getValues(uint256 tAmount)
965         private
966         view
967         returns (
968             uint256,
969             uint256,
970             uint256,
971             uint256,
972             uint256,
973             uint256
974         )
975     {
976         (
977             uint256 tTransferAmount,
978             uint256 tFee,
979             uint256 tLiquidity
980         ) = _getTValues(tAmount);
981         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
982             tAmount,
983             tFee,
984             tLiquidity,
985             _getRate()
986         );
987         return (
988             rAmount,
989             rTransferAmount,
990             rFee,
991             tTransferAmount,
992             tFee,
993             tLiquidity
994         );
995     }
996 
997     function _getTValues(uint256 tAmount)
998         private
999         view
1000         returns (
1001             uint256,
1002             uint256,
1003             uint256
1004         )
1005     {
1006         uint256 tFee = calculateTaxFee(tAmount);
1007         uint256 tLiquidity = calculateLiquidityFee(tAmount);
1008         uint256 tTransferAmount = tAmount-(tFee)-(tLiquidity);
1009         return (tTransferAmount, tFee, tLiquidity);
1010     }
1011 
1012     function _getRValues(
1013         uint256 tAmount,
1014         uint256 tFee,
1015         uint256 tLiquidity,
1016         uint256 currentRate
1017     )
1018         private
1019         pure
1020         returns (
1021             uint256,
1022             uint256,
1023             uint256
1024         )
1025     {
1026         uint256 rAmount = tAmount*(currentRate);
1027         uint256 rFee = tFee*(currentRate);
1028         uint256 rLiquidity = tLiquidity*(currentRate);
1029         uint256 rTransferAmount = rAmount-(rFee)-(rLiquidity);
1030         return (rAmount, rTransferAmount, rFee);
1031     }
1032 
1033     function _getRate() private view returns (uint256) {
1034         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1035         return rSupply / (tSupply);
1036     }
1037 
1038     function _getCurrentSupply() private view returns (uint256, uint256) {
1039         uint256 rSupply = _rTotal;
1040         uint256 tSupply = _tTotal;
1041         for (uint256 i = 0; i < _excluded.length; i++) {
1042             if (
1043                 _rOwned[_excluded[i]] > rSupply ||
1044                 _tOwned[_excluded[i]] > tSupply
1045             ) return (_rTotal, _tTotal);
1046             rSupply = rSupply-(_rOwned[_excluded[i]]);
1047             tSupply = tSupply-(_tOwned[_excluded[i]]);
1048         }
1049         if (rSupply < _rTotal / (_tTotal)) return (_rTotal, _tTotal);
1050         return (rSupply, tSupply);
1051     }
1052 
1053     function _takeLiquidity(uint256 tLiquidity) private {
1054         if(buyOrSellSwitch == BUY){
1055             _liquidityTokensToSwap += tLiquidity * _buyLiquidityFee / _liquidityFee;
1056             _operationsTokensToSwap += tLiquidity * _buyOperationsFee / _liquidityFee;
1057         } else if(buyOrSellSwitch == SELL){
1058             _liquidityTokensToSwap += tLiquidity * _sellLiquidityFee / _liquidityFee;
1059             _operationsTokensToSwap += tLiquidity * _sellOperationsFee / _liquidityFee;
1060         }
1061         uint256 currentRate = _getRate();
1062         uint256 rLiquidity = tLiquidity * (currentRate);
1063         _rOwned[address(this)] = _rOwned[address(this)] + rLiquidity;
1064         if (_isExcluded[address(this)])
1065             _tOwned[address(this)] = _tOwned[address(this)] + tLiquidity;
1066     }
1067 
1068     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1069         return _amount * _taxFee / 10000;
1070     }
1071 
1072     function calculateLiquidityFee(uint256 _amount)
1073         private
1074         view
1075         returns (uint256)
1076     {
1077         return _amount * _liquidityFee / 10000;
1078     }
1079 
1080     function removeAllFee() private {
1081         if (_taxFee == 0 && _liquidityFee == 0) return;
1082 
1083         _previousTaxFee = _taxFee;
1084         _previousLiquidityFee = _liquidityFee;
1085 
1086         _taxFee = 0;
1087         _liquidityFee = 0;
1088     }
1089 
1090     function restoreAllFee() private {
1091         _taxFee = _previousTaxFee;
1092         _liquidityFee = _previousLiquidityFee;
1093     }
1094 
1095     function isExcludedFromFee(address account) external view returns (bool) {
1096         return _isExcludedFromFee[account];
1097     }
1098 
1099     function excludeFromFee(address account) external onlyOwner {
1100         _isExcludedFromFee[account] = true;
1101         emit ExcludeFromFee(account);
1102     }
1103 
1104     function includeInFee(address account) external onlyOwner {
1105         _isExcludedFromFee[account] = false;
1106         emit IncludeInFee(account);
1107     }
1108 
1109     function setBuyFee(uint256 buyTaxFee, uint256 buyLiquidityFee, uint256 buyOperationsFee)
1110         external
1111         onlyOwner
1112     {
1113         _buyTaxFee = buyTaxFee;
1114         _buyLiquidityFee = buyLiquidityFee;
1115         _buyOperationsFee = buyOperationsFee;
1116         require(_buyTaxFee + _buyLiquidityFee + _buyOperationsFee <= 1500, "Must keep buy taxes below 15%");
1117         emit SetBuyFee(buyOperationsFee, buyLiquidityFee, buyTaxFee);
1118     }
1119 
1120     function setSellFee(uint256 sellTaxFee, uint256 sellLiquidityFee, uint256 sellOperationsFee)
1121         external
1122         onlyOwner
1123     {
1124         _sellTaxFee = sellTaxFee;
1125         _sellLiquidityFee = sellLiquidityFee;
1126         _sellOperationsFee = sellOperationsFee;
1127         require(_sellTaxFee + _sellLiquidityFee + _sellOperationsFee <= 2000, "Must keep sell taxes below 20%");
1128         emit SetSellFee(sellOperationsFee, sellLiquidityFee, sellTaxFee);
1129     }
1130 
1131     function setBuyAndSellFees(uint256 buyFee, uint256 sellFee)
1132         external
1133         onlyOwner
1134     {
1135          require(highTaxModeEnabled, "High tax mode disabled for ever!");
1136 
1137         _buyTaxFee = 100;
1138         _buyLiquidityFee = 0;
1139         _buyOperationsFee = buyFee;
1140 
1141         _sellTaxFee = 100;
1142         _sellLiquidityFee = 0;
1143         _sellOperationsFee = sellFee;
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
1174     function setHighTaxModeDisabledForever() external onlyOwner {
1175         require(highTaxModeEnabled, "High tax mode already disabled!!");
1176 
1177         highTaxModeEnabled = false;
1178         emit DisabledHighTaxModeForever();
1179     }
1180     
1181     function withdrawStuckETH() external onlyOwner {
1182         bool success;
1183         (success,) = address(msg.sender).call{value: address(this).balance}("");
1184     }
1185 
1186     function launch(address[] memory wallets, uint256[] memory amountsInTokens, uint256 blocksForPenalty) external onlyOwner {
1187         require(!tradingActive, "Trading is already active, cannot relaunch.");
1188         require(blocksForPenalty < 10, "Cannot make penalty blocks more than 10");
1189 
1190         removeAllFee();
1191         require(wallets.length == amountsInTokens.length, "arrays must be the same length");
1192         require(wallets.length < 200, "Can only airdrop 200 wallets per txn due to gas limits"); // allows for airdrop + launch at the same exact time, reducing delays and reducing sniper input.
1193         for(uint256 i = 0; i < wallets.length; i++){
1194             address wallet = wallets[i];
1195             uint256 amount = amountsInTokens[i];
1196             _transfer(msg.sender, wallet, amount);
1197         }
1198 
1199         maxTransactionAmount = _tTotal  * 3 / 10000;
1200 
1201         //standard enable trading
1202         tradingActive = true;
1203         swapAndLiquifyEnabled = true;
1204         tradingActiveBlock = block.number;
1205         blockForPenaltyEnd = tradingActiveBlock + blocksForPenalty;
1206         emit EnabledTrading();
1207 
1208         // initialize router
1209         IDexRouter _dexRouter = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
1210         dexRouter = _dexRouter;
1211 
1212         // create pair
1213         lpPair = IDexFactory(_dexRouter.factory()).createPair(address(this), _dexRouter.WETH());
1214         excludeFromMaxTransaction(address(lpPair), true);
1215         _setAutomatedMarketMakerPair(address(lpPair), true);
1216    
1217         // add the liquidity
1218 
1219         require(address(this).balance > 0, "Must have ETH on contract to launch");
1220 
1221         require(balanceOf(address(this)) > 0, "Must have Tokens on contract to launch");
1222 
1223         _approve(address(this), address(dexRouter), balanceOf(address(this)));
1224         dexRouter.addLiquidityETH{value: address(this).balance}(
1225             address(this),
1226             balanceOf(address(this)),
1227             0, // slippage is unavoidable
1228             0, // slippage is unavoidable
1229             msg.sender,
1230             block.timestamp
1231         );
1232         restoreAllFee();
1233     }
1234 }