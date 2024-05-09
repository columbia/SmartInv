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
209     uint256 private _lockTime;
210 
211     event OwnershipTransferred(
212         address indexed previousOwner,
213         address indexed newOwner
214     );
215 
216     constructor() {
217         address msgSender = _msgSender();
218         _owner = msgSender;
219         emit OwnershipTransferred(address(0), msgSender);
220     }
221 
222     function owner() public view returns (address) {
223         return _owner;
224     }
225 
226     modifier onlyOwner() {
227         require(_owner == _msgSender(), "Ownable: caller is not the owner");
228         _;
229     }
230 
231     function renounceOwnership() public virtual onlyOwner {
232         emit OwnershipTransferred(_owner, address(0));
233         _owner = address(0);
234     }
235 
236     function transferOwnership(address newOwner) public virtual onlyOwner {
237         require(
238             newOwner != address(0),
239             "Ownable: new owner is the zero address"
240         );
241         emit OwnershipTransferred(_owner, newOwner);
242         _owner = newOwner;
243     }
244 
245     function getUnlockTime() public view returns (uint256) {
246         return _lockTime;
247     }
248 
249     function getTime() public view returns (uint256) {
250         return block.timestamp;
251     }
252 }
253 
254 
255 interface IUniswapV2Factory {
256     function createPair(address tokenA, address tokenB)
257         external
258         returns (address pair);
259 }
260 
261 
262 interface IUniswapV2Router02 {
263     function factory() external pure returns (address);
264 
265     function WETH() external pure returns (address);
266 
267     function addLiquidityETH(
268         address token,
269         uint256 amountTokenDesired,
270         uint256 amountTokenMin,
271         uint256 amountETHMin,
272         address to,
273         uint256 deadline
274     )
275         external
276         payable
277         returns (
278             uint256 amountToken,
279             uint256 amountETH,
280             uint256 liquidity
281         );
282 
283     function swapExactETHForTokensSupportingFeeOnTransferTokens(
284         uint256 amountOutMin,
285         address[] calldata path,
286         address to,
287         uint256 deadline
288     ) external payable;
289 
290     function swapExactTokensForETHSupportingFeeOnTransferTokens(
291         uint256 amountIn,
292         uint256 amountOutMin,
293         address[] calldata path,
294         address to,
295         uint256 deadline
296     ) external;
297 }
298 
299 contract NumisMe is Context, IERC20, Ownable {
300     using SafeMath for uint256;
301     using Address for address;
302 
303     address payable public marketingAddress;
304     address payable public devAddress;
305       
306     mapping(address => uint256) private _rOwned;
307     mapping(address => uint256) private _tOwned;
308     mapping(address => mapping(address => uint256)) private _allowances;
309     
310     // Anti-bot and anti-whale mappings and variables
311     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
312     bool public transferDelayEnabled = true;
313     bool public limitsInEffect = true;
314 
315     mapping(address => bool) private _isExcludedFromFee;
316 
317     mapping(address => bool) private _isExcluded;
318     address[] private _excluded;
319     
320     uint256 private constant MAX = ~uint256(0);
321     uint256 private constant _tTotal = 5 * 1e9 * 1e18;
322     uint256 private _rTotal = (MAX - (MAX % _tTotal));
323     uint256 private _tFeeTotal;
324 
325     string private constant _name = "NumisMe Token";
326     string private constant _symbol = "NUME";
327     uint8 private constant _decimals = 18;
328 
329     uint256 private _taxFee;
330     uint256 private _previousTaxFee = _taxFee;
331 
332     uint256 private _liquidityFee;
333     uint256 private _previousLiquidityFee = _liquidityFee;
334     
335     uint256 private constant BUY = 1;
336     uint256 private constant SELL = 2;
337     uint256 private constant TRANSFER = 3;
338     uint256 private buyOrSellSwitch;
339 
340     uint256 public _buyTaxFee = 600;
341     uint256 public _buyLiquidityFee = 100;
342     uint256 public _buyMarketingFee = 100;
343     uint256 public _buyDevFee = 100;
344 
345     uint256 public _sellTaxFee = 600;
346     uint256 public _sellLiquidityFee = 100;
347     uint256 public _sellMarketingFee = 100;
348     uint256 public _sellDevFee = 100;
349     
350     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
351     
352     uint256 public _liquidityTokensToSwap;
353     uint256 public _marketingTokensToSwap;
354     uint256 public _devTokensToSwap;
355     
356     uint256 public maxTransactionAmount;
357     mapping (address => bool) public _isExcludedMaxTransactionAmount;
358     
359     bool private gasLimitActive = true;
360     uint256 private gasPriceLimit = 520 * 1 gwei; // do not allow over x gwei for launch
361     
362     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
363     // could be subject to a maximum transfer amount
364     mapping (address => bool) public automatedMarketMakerPairs;
365 
366     uint256 private minimumTokensBeforeSwap;
367 
368     IUniswapV2Router02 public uniswapV2Router;
369     address public uniswapV2Pair;
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
396     event SetBuyFee(uint256 marketingFee, uint256 liquidityFee, uint256 reflectFee, uint256 devFee);
397     
398     event SetSellFee(uint256 marketingFee, uint256 liquidityFee, uint256 reflectFee, uint256 devFee);
399     
400     event TransferForeignToken(address token, uint256 amount);
401     
402     event UpdatedMarketingAddress(address marketing);
403 
404     event UpdatedDevAddress(address dev);
405 
406     modifier lockTheSwap() {
407         inSwapAndLiquify = true;
408         _;
409         inSwapAndLiquify = false;
410     }
411 
412     constructor() {
413         address newOwner = address(msg.sender);
414         _rOwned[newOwner] = _rTotal / 1000 * 125;
415         _rOwned[0x57a23938B1c5DE38956e8CEE10690F7f510aD1B8] = _rTotal / 1000 * 15;
416         _rOwned[0xeDE21d217E29b0f345AfC9EFcb6018287B7A46fB] = _rTotal / 100 * 10;
417         _rOwned[0x677Bb693cF2c8304902d7d0779041c2C89D4bD48] = _rTotal / 100 * 10;
418         _rOwned[0x6b8fABf3324c3a14F60Ae6EA62aBa8665D498c4F] = _rTotal / 100 * 20;
419         _rOwned[0xe2A7BE7862C657b87587E9e59FCA270b3DDb0A2D] = _rTotal / 100 * 40;
420         _rOwned[0x20678A8aAA215aA66A49a3400CaEfC1d7aa1Ad7c] = _rTotal / 100 * 6;
421 
422         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
423         excludeFromMaxTransaction(address(_uniswapV2Router), true);
424         uniswapV2Router = _uniswapV2Router;
425         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
426         excludeFromMaxTransaction(address(uniswapV2Pair), true);
427         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
428         
429         maxTransactionAmount = _tTotal * 1 / 10000; // 0.01% maxTransactionAmountTxn
430         minimumTokensBeforeSwap = _tTotal * 1 / 1000000; // 0.0001% swap tokens amount
431         
432         marketingAddress = payable(0x677Bb693cF2c8304902d7d0779041c2C89D4bD48); // Marketing Address
433         devAddress = payable(0xeDE21d217E29b0f345AfC9EFcb6018287B7A46fB); // Dev Address
434 
435         _isExcludedFromFee[newOwner] = true;
436         _isExcludedFromFee[address(this)] = true;
437         _isExcludedFromFee[marketingAddress] = true;
438         _isExcludedFromFee[0x094FdbEC9659529F1f2c4F6C51204717384A3E53] = true; // LP Provider
439         
440         excludeFromMaxTransaction(newOwner, true);
441         excludeFromMaxTransaction(address(this), true);
442         excludeFromMaxTransaction(address(0xdead), true);
443         excludeFromMaxTransaction(address(0x094FdbEC9659529F1f2c4F6C51204717384A3E53), true);
444 
445         excludeFromReward(address(this));
446         
447         emit Transfer(address(0), newOwner, _tTotal / 1000 * 125);
448         emit Transfer(address(0), 0x57a23938B1c5DE38956e8CEE10690F7f510aD1B8, _tTotal / 1000 * 15);
449         emit Transfer(address(0), 0xeDE21d217E29b0f345AfC9EFcb6018287B7A46fB, _tTotal / 100 * 10);
450         emit Transfer(address(0), 0x677Bb693cF2c8304902d7d0779041c2C89D4bD48, _tTotal / 100 * 10);
451         emit Transfer(address(0), 0x6b8fABf3324c3a14F60Ae6EA62aBa8665D498c4F, _tTotal / 100 * 20);
452         emit Transfer(address(0), 0xe2A7BE7862C657b87587E9e59FCA270b3DDb0A2D, _tTotal / 100 * 40);
453         emit Transfer(address(0), 0x20678A8aAA215aA66A49a3400CaEfC1d7aa1Ad7c, _tTotal / 100 * 6);
454         transferOwnership(newOwner);
455     }
456 
457     function name() external pure returns (string memory) {
458         return _name;
459     }
460 
461     function symbol() external pure returns (string memory) {
462         return _symbol;
463     }
464 
465     function decimals() external pure returns (uint8) {
466         return _decimals;
467     }
468 
469     function totalSupply() external pure override returns (uint256) {
470         return _tTotal;
471     }
472 
473     function balanceOf(address account) public view override returns (uint256) {
474         if (_isExcluded[account]) return _tOwned[account];
475         return tokenFromReflection(_rOwned[account]);
476     }
477 
478     function transfer(address recipient, uint256 amount)
479         external
480         override
481         returns (bool)
482     {
483         _transfer(_msgSender(), recipient, amount);
484         return true;
485     }
486 
487     function allowance(address owner, address spender)
488         external
489         view
490         override
491         returns (uint256)
492     {
493         return _allowances[owner][spender];
494     }
495 
496     function approve(address spender, uint256 amount)
497         public
498         override
499         returns (bool)
500     {
501         _approve(_msgSender(), spender, amount);
502         return true;
503     }
504 
505     function transferFrom(
506         address sender,
507         address recipient,
508         uint256 amount
509     ) external override returns (bool) {
510         _transfer(sender, recipient, amount);
511         _approve(
512             sender,
513             _msgSender(),
514             _allowances[sender][_msgSender()].sub(
515                 amount,
516                 "ERC20: transfer amount exceeds allowance"
517             )
518         );
519         return true;
520     }
521 
522     function increaseAllowance(address spender, uint256 addedValue)
523         external
524         virtual
525         returns (bool)
526     {
527         _approve(
528             _msgSender(),
529             spender,
530             _allowances[_msgSender()][spender].add(addedValue)
531         );
532         return true;
533     }
534 
535     function decreaseAllowance(address spender, uint256 subtractedValue)
536         external
537         virtual
538         returns (bool)
539     {
540         _approve(
541             _msgSender(),
542             spender,
543             _allowances[_msgSender()][spender].sub(
544                 subtractedValue,
545                 "ERC20: decreased allowance below zero"
546             )
547         );
548         return true;
549     }
550 
551     function isExcludedFromReward(address account)
552         external
553         view
554         returns (bool)
555     {
556         return _isExcluded[account];
557     }
558 
559     function totalFees() external view returns (uint256) {
560         return _tFeeTotal;
561     }
562     
563     // remove limits after token is stable - 30-60 minutes
564     function removeLimits() external onlyOwner returns (bool){
565         limitsInEffect = false;
566         gasLimitActive = false;
567         transferDelayEnabled = false;
568         return true;
569     }
570 
571     // only use if conducting a presale
572     function addPresaleAddressForExclusions(address _presaleAddress) external onlyOwner {
573         excludeFromFee(_presaleAddress);
574         excludeFromMaxTransaction(_presaleAddress, true);
575     }
576     
577     // disable Transfer delay
578     function disableTransferDelay() external onlyOwner returns (bool){
579         transferDelayEnabled = false;
580         return true;
581     }
582     
583     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
584         _isExcludedMaxTransactionAmount[updAds] = isEx;
585     }
586     
587     // once enabled, can never be turned off
588     function enableTrading() external onlyOwner {
589         require(!tradingActive, "Cannot re-enable trading");
590         tradingActive = true;
591         setSwapAndLiquifyEnabled(true);
592         tradingActiveBlock = block.number;
593     }
594         
595     function minimumTokensBeforeSwapAmount() external view returns (uint256) {
596         return minimumTokensBeforeSwap;
597     }
598 
599      // change the minimum amount of tokens to sell from fees
600     function updateMinimumTokensBeforeSwap(uint256 newAmount) external onlyOwner{
601   	    require(newAmount >= _tTotal * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
602   	    require(newAmount <= _tTotal * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
603   	    minimumTokensBeforeSwap = newAmount;
604   	}
605 
606     function updateMaxAmount(uint256 newNum) external onlyOwner {
607         require(newNum >= (_tTotal * 1 / 10000)/1e18, "Cannot set maxTransactionAmount lower than 0.01%");
608         maxTransactionAmount = newNum * (10**18);
609     }
610     
611     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
612         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
613 
614         _setAutomatedMarketMakerPair(pair, value);
615     }
616 
617     function _setAutomatedMarketMakerPair(address pair, bool value) private {
618         automatedMarketMakerPairs[pair] = value;
619         _isExcludedMaxTransactionAmount[pair] = value;
620         if(value){excludeFromReward(pair);}
621     }
622     
623     function setGasPriceLimit(uint256 gas) external onlyOwner {
624         require(gas >= 250, "cannot set gas this low");
625         gasPriceLimit = gas * 1 gwei;
626     }
627 
628     function reflectionFromToken(uint256 tAmount, bool deductTransferFee)
629         external
630         view
631         returns (uint256)
632     {
633         require(tAmount <= _tTotal, "Amount must be less than supply");
634         if (!deductTransferFee) {
635             (uint256 rAmount, , , , , ) = _getValues(tAmount);
636             return rAmount;
637         } else {
638             (, uint256 rTransferAmount, , , , ) = _getValues(tAmount);
639             return rTransferAmount;
640         }
641     }
642 
643     function tokenFromReflection(uint256 rAmount)
644         public
645         view
646         returns (uint256)
647     {
648         require(
649             rAmount <= _rTotal,
650             "Amount must be less than total reflections"
651         );
652         uint256 currentRate = _getRate();
653         return rAmount.div(currentRate);
654     }
655 
656     function excludeFromReward(address account) public onlyOwner {
657         require(!_isExcluded[account], "Account is already excluded");
658         require(_excluded.length + 1 <= 20, "Cannot exclude more than 20 accounts.  Include a previously excluded address.");
659         if (_rOwned[account] > 0) {
660             _tOwned[account] = tokenFromReflection(_rOwned[account]);
661         }
662         _isExcluded[account] = true;
663         _excluded.push(account);
664     }
665 
666     function includeInReward(address account) public onlyOwner {
667         require(_isExcluded[account], "Account is not excluded");
668         for (uint256 i = 0; i < _excluded.length; i++) {
669             if (_excluded[i] == account) {
670                 _excluded[i] = _excluded[_excluded.length - 1];
671                 _tOwned[account] = 0;
672                 _isExcluded[account] = false;
673                 _excluded.pop();
674                 break;
675             }
676         }
677     }
678  
679     function _approve(
680         address owner,
681         address spender,
682         uint256 amount
683     ) private {
684         require(owner != address(0), "ERC20: approve from the zero address");
685         require(spender != address(0), "ERC20: approve to the zero address");
686 
687         _allowances[owner][spender] = amount;
688         emit Approval(owner, spender, amount);
689     }
690 
691     function _transfer(
692         address from,
693         address to,
694         uint256 amount
695     ) private {
696         require(from != address(0), "ERC20: transfer from the zero address");
697         require(to != address(0), "ERC20: transfer to the zero address");
698         require(amount > 0, "Transfer amount must be greater than zero");
699         
700         if(!tradingActive){
701             require(_isExcludedFromFee[from] || _isExcludedFromFee[to], "Trading is not active yet.");
702         }
703  
704         if(limitsInEffect){
705             if (
706                 from != owner() &&
707                 to != owner() &&
708                 to != address(0) &&
709                 to != address(0xdead) &&
710                 !inSwapAndLiquify && 
711                 !_isExcludedFromFee[to] &&
712                 !_isExcludedFromFee[from]
713             ){                
714                 // only use to prevent sniper buys in the first blocks.
715                 if (gasLimitActive && automatedMarketMakerPairs[from]) {
716                     require(tx.gasprice <= gasPriceLimit, "Gas price exceeds limit.");
717                 }
718                 
719                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
720                 if (transferDelayEnabled){
721                     if (to != address(uniswapV2Router) && !automatedMarketMakerPairs[to]){
722                         require(_holderLastTransferTimestamp[tx.origin] < block.number && _holderLastTransferTimestamp[to] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
723                         _holderLastTransferTimestamp[tx.origin] = block.number;
724                         _holderLastTransferTimestamp[to] = block.number;
725                     }
726                 }
727                 
728                 //when buy
729                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
730                     require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
731                 } 
732                 //when sell
733                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
734                     require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
735                 }
736             }
737         }
738 
739         uint256 contractTokenBalance = balanceOf(address(this));
740         bool overMinimumTokenBalance = contractTokenBalance >= minimumTokensBeforeSwap;
741 
742         // swap and liquify
743         if (
744             !inSwapAndLiquify &&
745             swapAndLiquifyEnabled &&
746             balanceOf(uniswapV2Pair) > 0 &&
747             !_isExcludedFromFee[to] &&
748             !_isExcludedFromFee[from] &&
749             automatedMarketMakerPairs[to] &&
750             overMinimumTokenBalance
751         ) {
752             swapBack();
753         }
754 
755         removeAllFee();
756         
757         buyOrSellSwitch = TRANSFER;
758         
759         if (!_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
760             if(tradingActiveBlock == block.number && (automatedMarketMakerPairs[to] || automatedMarketMakerPairs[from])){
761                 _taxFee = 600;
762                 _liquidityFee = 9300;
763                 buyOrSellSwitch = SELL;
764             }
765             // Buy
766             else if (automatedMarketMakerPairs[from]) {
767                 _taxFee = _buyTaxFee;
768                 _liquidityFee = _buyLiquidityFee + _buyMarketingFee + _buyDevFee;
769                 if(_liquidityFee > 0){
770                     buyOrSellSwitch = BUY;
771                 }
772             } 
773             // Sell
774             else if (automatedMarketMakerPairs[to]) {
775                 _taxFee = _sellTaxFee;
776                 _liquidityFee = _sellLiquidityFee + _sellMarketingFee + _sellDevFee;
777                 if(_liquidityFee > 0){
778                     buyOrSellSwitch = SELL;
779                 }
780             }
781         }
782         
783         _tokenTransfer(from, to, amount);
784         
785         restoreAllFee();
786         
787     }
788 
789     function swapBack() private lockTheSwap {
790         uint256 contractBalance = balanceOf(address(this));
791         uint256 totalTokensToSwap = _liquidityTokensToSwap + _marketingTokensToSwap + _devTokensToSwap;
792         bool success;
793 
794         // prevent overly large contract sells.
795         if(contractBalance >= minimumTokensBeforeSwap * 10){
796             contractBalance = minimumTokensBeforeSwap * 10;
797         }
798 
799         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
800         
801         // Halve the amount of liquidity tokens
802         uint256 tokensForLiquidity = contractBalance * _liquidityTokensToSwap / totalTokensToSwap / 2;
803         uint256 amountToSwapForETH = contractBalance.sub(tokensForLiquidity);
804         
805         uint256 initialETHBalance = address(this).balance;
806 
807         swapTokensForETH(amountToSwapForETH); 
808         
809         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
810         
811         uint256 ethForMarketing = ethBalance.mul(_marketingTokensToSwap).div(totalTokensToSwap - (_liquidityTokensToSwap/2));
812         uint256 ethForDev = ethBalance.mul(_devTokensToSwap).div(totalTokensToSwap - (_liquidityTokensToSwap/2));
813         
814         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
815         
816         _liquidityTokensToSwap = 0;
817         _marketingTokensToSwap = 0;
818         _devTokensToSwap = 0;
819                 
820         if(tokensForLiquidity > 0 && ethForLiquidity > 0){
821             addLiquidity(tokensForLiquidity, ethForLiquidity);
822             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
823         }
824 
825         (success,) = address(devAddress).call{value: ethForDev}("");
826 
827         // send remainder to marketing
828         (success,) = address(marketingAddress).call{value: address(this).balance}("");
829     }
830     
831     function swapTokensForETH(uint256 tokenAmount) private {
832         address[] memory path = new address[](2);
833         path[0] = address(this);
834         path[1] = uniswapV2Router.WETH();
835         _approve(address(this), address(uniswapV2Router), tokenAmount);
836         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
837             tokenAmount,
838             0, // accept any amount of ETH
839             path,
840             address(this),
841             block.timestamp
842         );
843     }
844     
845     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
846         _approve(address(this), address(uniswapV2Router), tokenAmount);
847         uniswapV2Router.addLiquidityETH{value: ethAmount}(
848             address(this),
849             tokenAmount,
850             0, // slippage is unavoidable
851             0, // slippage is unavoidable
852             address(0xdead),
853             block.timestamp
854         );
855     }
856 
857     function _tokenTransfer(
858         address sender,
859         address recipient,
860         uint256 amount
861     ) private {
862 
863         if (_isExcluded[sender] && !_isExcluded[recipient]) {
864             _transferFromExcluded(sender, recipient, amount);
865         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
866             _transferToExcluded(sender, recipient, amount);
867         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
868             _transferBothExcluded(sender, recipient, amount);
869         } else {
870             _transferStandard(sender, recipient, amount);
871         }
872     }
873 
874     function _transferStandard(
875         address sender,
876         address recipient,
877         uint256 tAmount
878     ) private {
879         (
880             uint256 rAmount,
881             uint256 rTransferAmount,
882             uint256 rFee,
883             uint256 tTransferAmount,
884             uint256 tFee,
885             uint256 tLiquidity
886         ) = _getValues(tAmount);
887         _rOwned[sender] = _rOwned[sender].sub(rAmount);
888         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
889         _takeLiquidity(tLiquidity);
890         _reflectFee(rFee, tFee);
891         emit Transfer(sender, recipient, tTransferAmount);
892     }
893 
894     function _transferToExcluded(
895         address sender,
896         address recipient,
897         uint256 tAmount
898     ) private {
899         (
900             uint256 rAmount,
901             uint256 rTransferAmount,
902             uint256 rFee,
903             uint256 tTransferAmount,
904             uint256 tFee,
905             uint256 tLiquidity
906         ) = _getValues(tAmount);
907         _rOwned[sender] = _rOwned[sender].sub(rAmount);
908         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
909         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
910         _takeLiquidity(tLiquidity);
911         _reflectFee(rFee, tFee);
912         emit Transfer(sender, recipient, tTransferAmount);
913     }
914 
915     function _transferFromExcluded(
916         address sender,
917         address recipient,
918         uint256 tAmount
919     ) private {
920         (
921             uint256 rAmount,
922             uint256 rTransferAmount,
923             uint256 rFee,
924             uint256 tTransferAmount,
925             uint256 tFee,
926             uint256 tLiquidity
927         ) = _getValues(tAmount);
928         _tOwned[sender] = _tOwned[sender].sub(tAmount);
929         _rOwned[sender] = _rOwned[sender].sub(rAmount);
930         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
931         _takeLiquidity(tLiquidity);
932         _reflectFee(rFee, tFee);
933         emit Transfer(sender, recipient, tTransferAmount);
934     }
935 
936     function _transferBothExcluded(
937         address sender,
938         address recipient,
939         uint256 tAmount
940     ) private {
941         (
942             uint256 rAmount,
943             uint256 rTransferAmount,
944             uint256 rFee,
945             uint256 tTransferAmount,
946             uint256 tFee,
947             uint256 tLiquidity
948         ) = _getValues(tAmount);
949         _tOwned[sender] = _tOwned[sender].sub(tAmount);
950         _rOwned[sender] = _rOwned[sender].sub(rAmount);
951         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
952         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
953         _takeLiquidity(tLiquidity);
954         _reflectFee(rFee, tFee);
955         emit Transfer(sender, recipient, tTransferAmount);
956     }
957 
958     function _reflectFee(uint256 rFee, uint256 tFee) private {
959         _rTotal = _rTotal.sub(rFee);
960         _tFeeTotal = _tFeeTotal.add(tFee);
961     }
962 
963     function _getValues(uint256 tAmount)
964         private
965         view
966         returns (
967             uint256,
968             uint256,
969             uint256,
970             uint256,
971             uint256,
972             uint256
973         )
974     {
975         (
976             uint256 tTransferAmount,
977             uint256 tFee,
978             uint256 tLiquidity
979         ) = _getTValues(tAmount);
980         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
981             tAmount,
982             tFee,
983             tLiquidity,
984             _getRate()
985         );
986         return (
987             rAmount,
988             rTransferAmount,
989             rFee,
990             tTransferAmount,
991             tFee,
992             tLiquidity
993         );
994     }
995 
996     function _getTValues(uint256 tAmount)
997         private
998         view
999         returns (
1000             uint256,
1001             uint256,
1002             uint256
1003         )
1004     {
1005         uint256 tFee = calculateTaxFee(tAmount);
1006         uint256 tLiquidity = calculateLiquidityFee(tAmount);
1007         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
1008         return (tTransferAmount, tFee, tLiquidity);
1009     }
1010 
1011     function _getRValues(
1012         uint256 tAmount,
1013         uint256 tFee,
1014         uint256 tLiquidity,
1015         uint256 currentRate
1016     )
1017         private
1018         pure
1019         returns (
1020             uint256,
1021             uint256,
1022             uint256
1023         )
1024     {
1025         uint256 rAmount = tAmount.mul(currentRate);
1026         uint256 rFee = tFee.mul(currentRate);
1027         uint256 rLiquidity = tLiquidity.mul(currentRate);
1028         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
1029         return (rAmount, rTransferAmount, rFee);
1030     }
1031 
1032     function _getRate() private view returns (uint256) {
1033         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1034         return rSupply.div(tSupply);
1035     }
1036 
1037     function _getCurrentSupply() private view returns (uint256, uint256) {
1038         uint256 rSupply = _rTotal;
1039         uint256 tSupply = _tTotal;
1040         for (uint256 i = 0; i < _excluded.length; i++) {
1041             if (
1042                 _rOwned[_excluded[i]] > rSupply ||
1043                 _tOwned[_excluded[i]] > tSupply
1044             ) return (_rTotal, _tTotal);
1045             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1046             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1047         }
1048         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1049         return (rSupply, tSupply);
1050     }
1051 
1052     function _takeLiquidity(uint256 tLiquidity) private {
1053         if(buyOrSellSwitch == BUY){
1054             _liquidityTokensToSwap += tLiquidity * _buyLiquidityFee / _liquidityFee;
1055             _marketingTokensToSwap += tLiquidity * _buyMarketingFee / _liquidityFee;
1056             _devTokensToSwap += tLiquidity * _buyDevFee / _liquidityFee;
1057         } else if(buyOrSellSwitch == SELL){
1058             _liquidityTokensToSwap += tLiquidity * _sellLiquidityFee / _liquidityFee;
1059             _marketingTokensToSwap += tLiquidity * _sellMarketingFee / _liquidityFee;
1060             _devTokensToSwap += tLiquidity * _sellDevFee / _liquidityFee;
1061         }
1062         uint256 currentRate = _getRate();
1063         uint256 rLiquidity = tLiquidity.mul(currentRate);
1064         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1065         if (_isExcluded[address(this)])
1066             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1067     }
1068 
1069     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1070         return _amount.mul(_taxFee).div(10000);
1071     }
1072 
1073     function calculateLiquidityFee(uint256 _amount)
1074         private
1075         view
1076         returns (uint256)
1077     {
1078         return _amount.mul(_liquidityFee).div(10000);
1079     }
1080 
1081     function removeAllFee() private {
1082         if (_taxFee == 0 && _liquidityFee == 0) return;
1083 
1084         _previousTaxFee = _taxFee;
1085         _previousLiquidityFee = _liquidityFee;
1086 
1087         _taxFee = 0;
1088         _liquidityFee = 0;
1089     }
1090 
1091     function restoreAllFee() private {
1092         _taxFee = _previousTaxFee;
1093         _liquidityFee = _previousLiquidityFee;
1094     }
1095 
1096     function isExcludedFromFee(address account) external view returns (bool) {
1097         return _isExcludedFromFee[account];
1098     }
1099 
1100     function excludeFromFee(address account) public onlyOwner {
1101         _isExcludedFromFee[account] = true;
1102         emit ExcludeFromFee(account);
1103     }
1104 
1105     function includeInFee(address account) external onlyOwner {
1106         _isExcludedFromFee[account] = false;
1107         emit IncludeInFee(account);
1108     }
1109 
1110     function setBuyFee(uint256 buyTaxFee, uint256 buyLiquidityFee, uint256 buyMarketingFee, uint256 buyDevFee)
1111         external
1112         onlyOwner
1113     {
1114         _buyTaxFee = buyTaxFee;
1115         _buyLiquidityFee = buyLiquidityFee;
1116         _buyMarketingFee = buyMarketingFee;
1117         _buyDevFee = buyDevFee;
1118         require(_buyTaxFee + _buyLiquidityFee + _buyMarketingFee + _buyDevFee <= 1000, "Must keep buy taxes below 10%");
1119         emit SetBuyFee(buyMarketingFee, buyLiquidityFee, buyTaxFee, buyDevFee);
1120     }
1121 
1122     function setSellFee(uint256 sellTaxFee, uint256 sellLiquidityFee, uint256 sellMarketingFee, uint256 sellDevFee)
1123         external
1124         onlyOwner
1125     {
1126         _sellTaxFee = sellTaxFee;
1127         _sellLiquidityFee = sellLiquidityFee;
1128         _sellMarketingFee = sellMarketingFee;
1129         _sellDevFee = sellDevFee;
1130         require(_sellTaxFee + _sellLiquidityFee + _sellMarketingFee + _sellDevFee <= 1500, "Must keep sell taxes below 15%");
1131         emit SetSellFee(sellMarketingFee, sellLiquidityFee, sellTaxFee, sellDevFee);
1132     }
1133     
1134     function setMarketingAddress(address _marketingAddress) external onlyOwner {
1135         require(_marketingAddress != address(0), "_marketingAddress address cannot be 0");
1136         _isExcludedFromFee[marketingAddress] = false;
1137         marketingAddress = payable(_marketingAddress);
1138         _isExcludedFromFee[marketingAddress] = true;
1139         emit UpdatedMarketingAddress(_marketingAddress);
1140     }
1141 
1142     function setDevAddress(address _devAddress) public onlyOwner {
1143         require(_devAddress != address(0), "_devAddress address cannot be 0");
1144         devAddress = payable(_devAddress);
1145         emit UpdatedDevAddress(_devAddress);
1146     }
1147     
1148     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1149         swapAndLiquifyEnabled = _enabled;
1150         emit SwapAndLiquifyEnabledUpdated(_enabled);
1151     }
1152 
1153     // To receive ETH from uniswapV2Router when swapping
1154     receive() external payable {}
1155 
1156     function transferForeignToken(address _token, address _to)
1157         external
1158         onlyOwner
1159         returns (bool _sent)
1160     {
1161         require(_token != address(0), "_token address cannot be 0");
1162         require(_token != address(this), "Can't withdraw native tokens");
1163         require(_token != address(uniswapV2Pair), "Can't withdraw Native LP tokens with this method");
1164         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
1165         _sent = IERC20(_token).transfer(_to, _contractBalance);
1166         emit TransferForeignToken(_token, _contractBalance);
1167     }
1168     
1169     // withdraw ETH if stuck before launch
1170     function withdrawStuckETH() external onlyOwner {
1171         bool success;
1172         (success,) = address(msg.sender).call{value: address(this).balance}("");
1173     }
1174 }