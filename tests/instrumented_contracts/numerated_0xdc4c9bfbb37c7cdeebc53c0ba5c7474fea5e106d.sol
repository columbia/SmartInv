1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
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
16 contract Ownable is Context {
17     address private _owner;
18     address private _previousOwner;
19     uint256 private _lockTime;
20 
21     event OwnershipTransferred(
22         address indexed previousOwner,
23         address indexed newOwner
24     );
25 
26     constructor() {
27         address msgSender = _msgSender();
28         _owner = msgSender;
29         emit OwnershipTransferred(address(0), msgSender);
30     }
31 
32     function owner() public view returns (address) {
33         return _owner;
34     }
35 
36     modifier onlyOwner() {
37         require(_owner == _msgSender(), "Ownable: caller is not the owner");
38         _;
39     }
40 
41     function renounceOwnership() public virtual onlyOwner {
42         emit OwnershipTransferred(_owner, address(0));
43         _owner = address(0);
44     }
45 
46     function transferOwnership(address newOwner) public virtual onlyOwner {
47         require(
48             newOwner != address(0),
49             "Ownable: new owner is the zero address"
50         );
51         emit OwnershipTransferred(_owner, newOwner);
52         _owner = newOwner;
53     }
54 
55     function getUnlockTime() public view returns (uint256) {
56         return _lockTime;
57     }
58 
59     function getTime() public view returns (uint256) {
60         return block.timestamp;
61     }
62 }
63 
64 interface IERC20 {
65     function totalSupply() external view returns (uint256);
66 
67     function balanceOf(address account) external view returns (uint256);
68 
69     function transfer(address recipient, uint256 amount)
70         external
71         returns (bool);
72 
73     function allowance(address owner, address spender)
74         external
75         view
76         returns (uint256);
77 
78     function approve(address spender, uint256 amount) external returns (bool);
79 
80     function transferFrom(
81         address sender,
82         address recipient,
83         uint256 amount
84     ) external returns (bool);
85 
86     event Transfer(address indexed from, address indexed to, uint256 value);
87     event Approval(
88         address indexed owner,
89         address indexed spender,
90         uint256 value
91     );
92 }
93 
94 interface IUniswapV2Factory {
95     event PairCreated(
96         address indexed token0,
97         address indexed token1,
98         address pair,
99         uint256
100     );
101 
102     function getPair(address tokenA, address tokenB)
103         external
104         view
105         returns (address pair);
106 
107     function createPair(address tokenA, address tokenB)
108         external
109         returns (address pair);
110 }
111 
112 interface IUniswapV2Pair {
113     function factory() external view returns (address);
114 }
115 
116 interface IUniswapV2Router {
117     function factory() external pure returns (address);
118 
119     function WETH() external pure returns (address);
120 
121     function addLiquidityETH(
122         address token,
123         uint256 amountTokenDesired,
124         uint256 amountTokenMin,
125         uint256 amountETHMin,
126         address to,
127         uint256 deadline
128     )
129         external
130         payable
131         returns (
132             uint256 amountToken,
133             uint256 amountETH,
134             uint256 liquidity
135         );
136 
137     function swapExactETHForTokensSupportingFeeOnTransferTokens(
138         uint256 amountOutMin,
139         address[] calldata path,
140         address to,
141         uint256 deadline
142     ) external payable;
143 
144     function swapExactTokensForETHSupportingFeeOnTransferTokens(
145         uint256 amountIn,
146         uint256 amountOutMin,
147         address[] calldata path,
148         address to,
149         uint256 deadline
150     ) external;
151 }
152 
153 library Address {
154     function isContract(address account) internal view returns (bool) {
155         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
156         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
157         // for accounts without code, i.e. `keccak256('')`
158         bytes32 codehash;
159         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
160         // solhint-disable-next-line no-inline-assembly
161         assembly {
162             codehash := extcodehash(account)
163         }
164         return (codehash != accountHash && codehash != 0x0);
165     }
166 
167     function sendValue(address payable recipient, uint256 amount) internal {
168         require(
169             address(this).balance >= amount,
170             "Address: insufficient balance"
171         );
172 
173         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
174         (bool success, ) = recipient.call{value: amount}("");
175         require(
176             success,
177             "Address: unable to send value, recipient may have reverted"
178         );
179     }
180 
181     function functionCall(address target, bytes memory data)
182         internal
183         returns (bytes memory)
184     {
185         return functionCall(target, data, "Address: low-level call failed");
186     }
187 
188     function functionCall(
189         address target,
190         bytes memory data,
191         string memory errorMessage
192     ) internal returns (bytes memory) {
193         return _functionCallWithValue(target, data, 0, errorMessage);
194     }
195 
196     function functionCallWithValue(
197         address target,
198         bytes memory data,
199         uint256 value
200     ) internal returns (bytes memory) {
201         return
202             functionCallWithValue(
203                 target,
204                 data,
205                 value,
206                 "Address: low-level call with value failed"
207             );
208     }
209 
210     function functionCallWithValue(
211         address target,
212         bytes memory data,
213         uint256 value,
214         string memory errorMessage
215     ) internal returns (bytes memory) {
216         require(
217             address(this).balance >= value,
218             "Address: insufficient balance for call"
219         );
220         return _functionCallWithValue(target, data, value, errorMessage);
221     }
222 
223     function _functionCallWithValue(
224         address target,
225         bytes memory data,
226         uint256 weiValue,
227         string memory errorMessage
228     ) private returns (bytes memory) {
229         require(isContract(target), "Address: call to non-contract");
230 
231         (bool success, bytes memory returndata) = target.call{value: weiValue}(
232             data
233         );
234         if (success) {
235             return returndata;
236         } else {
237             if (returndata.length > 0) {
238                 assembly {
239                     let returndata_size := mload(returndata)
240                     revert(add(32, returndata), returndata_size)
241                 }
242             } else {
243                 revert(errorMessage);
244             }
245         }
246     }
247 }
248 
249 library SafeMath {
250     function add(uint256 a, uint256 b) internal pure returns (uint256) {
251         uint256 c = a + b;
252         require(c >= a, "SafeMath: addition overflow");
253 
254         return c;
255     }
256 
257     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
258         return sub(a, b, "SafeMath: subtraction overflow");
259     }
260 
261     function sub(
262         uint256 a,
263         uint256 b,
264         string memory errorMessage
265     ) internal pure returns (uint256) {
266         require(b <= a, errorMessage);
267         uint256 c = a - b;
268 
269         return c;
270     }
271 
272     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
273         if (a == 0) {
274             return 0;
275         }
276 
277         uint256 c = a * b;
278         require(c / a == b, "SafeMath: multiplication overflow");
279 
280         return c;
281     }
282 
283     function div(uint256 a, uint256 b) internal pure returns (uint256) {
284         return div(a, b, "SafeMath: division by zero");
285     }
286 
287     function div(
288         uint256 a,
289         uint256 b,
290         string memory errorMessage
291     ) internal pure returns (uint256) {
292         require(b > 0, errorMessage);
293         uint256 c = a / b;
294         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
295 
296         return c;
297     }
298 
299     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
300         return mod(a, b, "SafeMath: modulo by zero");
301     }
302 
303     function mod(
304         uint256 a,
305         uint256 b,
306         string memory errorMessage
307     ) internal pure returns (uint256) {
308         require(b != 0, errorMessage);
309         return a % b;
310     }
311 }
312 
313 // solhint-disable
314 contract FrankInuToken is Context, IERC20, Ownable {
315     using SafeMath for uint256;
316     using Address for address;
317 
318     address payable public marketingAddress =
319         payable(0xBc1edb05DbD63b86562385C15385342Bf197d553);
320     address payable public devAddress =
321         payable(0xc614FA09453Ba08c61a2Bda9C51d58B17f8cF5Db);
322     address payable public liquidityAddress =
323         payable(0x2A3205E74b9703724c4d1334C2C786A855565726);
324     address payable public treasuryAddress =
325         payable(0xb279Cc7949ab30D04E61d746e355ab83d848F13B);
326 
327     address private _owner;
328 
329     mapping(address => uint256) private _rOwned;
330     mapping(address => uint256) private _tOwned;
331     mapping(address => mapping(address => uint256)) private _allowances;
332 
333     // Anti-whale limits
334     bool public limitsInEffect = true;
335     mapping(address => bool) public blacklist;
336 
337     mapping(address => bool) private _isExcludedFromFee;
338 
339     mapping(address => bool) private _isExcluded;
340     address[] private _excluded;
341 
342     uint256 private constant MAX = ~uint256(0);
343     uint256 private constant _tTotal = 100_000_000_000 * 1e9;
344     uint256 private _rTotal = (MAX - (MAX % _tTotal));
345     uint256 private _tFeeTotal;
346 
347     string private constant _name = "Frank Inu";
348     string private constant _symbol = "FRANK";
349     uint8 private constant _decimals = 9;
350 
351     // these values are pretty much arbitrary since they get overwritten for every txn, but the placeholders make it easier to work with current contract.
352     uint256 private _taxFee;
353     uint256 private _previousTaxFee = _taxFee;
354 
355     uint256 private _teamFee;
356 
357     uint256 private _liquidityFee;
358     uint256 private _previousLiquidityFee = _liquidityFee;
359 
360     uint256 private constant BUY = 1;
361     uint256 private constant SELL = 2;
362     uint256 private constant TRANSFER = 3;
363     uint256 private buyOrSellSwitch;
364 
365     // Here is where you set the fee breakdown
366 
367     uint256 public _buyTaxFee = 1;
368     uint256 public _buyLiquidityFee = 2;
369     uint256 public _buyTeamFee = 9;
370 
371     uint256 public _sellTaxFee = 1;
372     uint256 public _sellLiquidityFee = 2;
373     uint256 public _sellTeamFee = 9;
374 
375     // These values are % of team fees to distribute (add extra 0: 333 = 33.3%)
376     // These combined values must be lower than 1000 (aka 100%)
377     // Any leftover goes to marketing address
378     uint256 public _percentTeamFundsToDev = 333;
379     uint256 public _percentTeamFundsToTreasury = 333;
380 
381     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
382 
383     uint256 public _liquidityTokensToSwap;
384     uint256 public _teamTokensToSwap;
385 
386     uint256 public maxTransactionAmount;
387     uint256 public maxWalletAmount;
388     mapping(address => bool) public _isExcludedMaxTransactionAmount;
389 
390     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
391     // could be subject to a maximum transfer amount
392     mapping(address => bool) public automatedMarketMakerPairs;
393 
394     uint256 private minimumTokensBeforeSwap;
395 
396     IUniswapV2Router public uniswapV2Router;
397     address public uniswapV2Pair;
398 
399     bool private inSwapAndLiquify;
400     bool public swapAndLiquifyEnabled = false;
401     bool public tradingActive = false;
402 
403     event SwapAndLiquifyEnabledUpdated(bool enabled);
404     event SwapAndLiquify(
405         uint256 tokensSwapped,
406         uint256 ethReceived,
407         uint256 tokensIntoLiquidity
408     );
409 
410     event SwapETHForTokens(uint256 amountIn, address[] path);
411 
412     event SwapTokensForETH(uint256 amountIn, address[] path);
413 
414     event SetAutomatedMarketMakerPair(address pair, bool value);
415 
416     event ExcludeFromReward(address excludedAddress);
417 
418     event IncludeInReward(address includedAddress);
419 
420     event ExcludeFromFee(address excludedAddress);
421 
422     event IncludeInFee(address includedAddress);
423 
424     event SetBuyFee(uint256 teamFee, uint256 liquidityFee, uint256 reflectFee);
425 
426     event SetSellFee(uint256 teamFee, uint256 liquidityFee, uint256 reflectFee);
427 
428     event TransferForeignToken(address token, uint256 amount);
429 
430     event UpdatedTeamAddress(address team);
431 
432     event UpdatedLiquidityAddress(address liquidity);
433 
434     event OwnerForcedSwapBack(uint256 timestamp);
435 
436     event BoughtEarly(address indexed sniper);
437 
438     event RemovedSniper(address indexed notsnipersupposedly);
439 
440     modifier lockTheSwap() {
441         inSwapAndLiquify = true;
442         _;
443         inSwapAndLiquify = false;
444     }
445 
446     constructor() payable {
447         _owner = msg.sender;
448         _rOwned[_owner] = (_rTotal / 1000) * 350;
449         _rOwned[address(this)] = (_rTotal / 1000) * 650;
450 
451         maxTransactionAmount = (_tTotal * 3) / 1000; // 0.3% maxTransactionAmountTxn
452         maxWalletAmount = (_tTotal * 5) / 1000; // 0.5% maxWalletAmount
453         minimumTokensBeforeSwap = (_tTotal * 5) / 10000; // 0.05% swap tokens amount
454 
455         _isExcludedFromFee[owner()] = true;
456         _isExcludedFromFee[address(this)] = true;
457         _isExcludedFromFee[marketingAddress] = true;
458         _isExcludedFromFee[liquidityAddress] = true;
459         _isExcludedFromFee[treasuryAddress] = true;
460         _isExcludedFromFee[devAddress] = true;
461 
462         excludeFromMaxTransaction(owner(), true);
463         excludeFromMaxTransaction(address(this), true);
464         excludeFromMaxTransaction(address(0xdead), true);
465         excludeFromMaxTransaction(marketingAddress, true);
466         excludeFromMaxTransaction(liquidityAddress, true);
467         excludeFromMaxTransaction(devAddress, true);
468         excludeFromMaxTransaction(treasuryAddress, true);
469 
470         emit Transfer(address(0), _owner, (_tTotal * 350) / 1000);
471         emit Transfer(address(0), address(this), (_tTotal * 650) / 1000);
472     }
473 
474     function name() external pure returns (string memory) {
475         return _name;
476     }
477 
478     function symbol() external pure returns (string memory) {
479         return _symbol;
480     }
481 
482     function decimals() external pure returns (uint8) {
483         return _decimals;
484     }
485 
486     function totalSupply() external pure override returns (uint256) {
487         return _tTotal;
488     }
489 
490     function balanceOf(address account) public view override returns (uint256) {
491         if (_isExcluded[account]) return _tOwned[account];
492         return tokenFromReflection(_rOwned[account]);
493     }
494 
495     function transfer(address recipient, uint256 amount)
496         external
497         override
498         returns (bool)
499     {
500         _transfer(_msgSender(), recipient, amount);
501         return true;
502     }
503 
504     function allowance(address owner, address spender)
505         external
506         view
507         override
508         returns (uint256)
509     {
510         return _allowances[owner][spender];
511     }
512 
513     function approve(address spender, uint256 amount)
514         public
515         override
516         returns (bool)
517     {
518         _approve(_msgSender(), spender, amount);
519         return true;
520     }
521 
522     function transferFrom(
523         address sender,
524         address recipient,
525         uint256 amount
526     ) external override returns (bool) {
527         _transfer(sender, recipient, amount);
528         _approve(
529             sender,
530             _msgSender(),
531             _allowances[sender][_msgSender()].sub(
532                 amount,
533                 "ERC20: transfer amount exceeds allowance"
534             )
535         );
536         return true;
537     }
538 
539     function increaseAllowance(address spender, uint256 addedValue)
540         external
541         virtual
542         returns (bool)
543     {
544         _approve(
545             _msgSender(),
546             spender,
547             _allowances[_msgSender()][spender].add(addedValue)
548         );
549         return true;
550     }
551 
552     function decreaseAllowance(address spender, uint256 subtractedValue)
553         external
554         virtual
555         returns (bool)
556     {
557         _approve(
558             _msgSender(),
559             spender,
560             _allowances[_msgSender()][spender].sub(
561                 subtractedValue,
562                 "ERC20: decreased allowance below zero"
563             )
564         );
565         return true;
566     }
567 
568     function isExcludedFromReward(address account)
569         external
570         view
571         returns (bool)
572     {
573         return _isExcluded[account];
574     }
575 
576     function totalFees() external view returns (uint256) {
577         return _tFeeTotal;
578     }
579 
580     // remove limits after token is stable - 30-60 minutes
581     function removeLimits() external onlyOwner returns (bool) {
582         limitsInEffect = false;
583         return true;
584     }
585 
586     function excludeFromMaxTransaction(address updAds, bool isEx)
587         public
588         onlyOwner
589     {
590         _isExcludedMaxTransactionAmount[updAds] = isEx;
591     }
592 
593     // once enabled, can never be turned off
594     function enableTrading() internal onlyOwner {
595         tradingActive = true;
596         swapAndLiquifyEnabled = true;
597         tradingActiveBlock = block.number;
598     }
599 
600     // send tokens and ETH for liquidity to contract directly, then call this (not required, can still use Uniswap to add liquidity manually, but this ensures everything is excluded properly and makes for a great stealth launch)
601     function launch() external onlyOwner returns (bool) {
602         require(!tradingActive, "Trading is already active, cannot relaunch.");
603 
604         enableTrading();
605         IUniswapV2Router _uniswapV2Router = IUniswapV2Router(
606             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
607         );
608         excludeFromMaxTransaction(address(_uniswapV2Router), true);
609         uniswapV2Router = _uniswapV2Router;
610         _approve(address(this), address(uniswapV2Router), _tTotal);
611         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
612             .createPair(address(this), _uniswapV2Router.WETH());
613         excludeFromMaxTransaction(address(uniswapV2Pair), true);
614         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
615         require(
616             address(this).balance > 0,
617             "Must have ETH on contract to launch"
618         );
619         addLiquidity(balanceOf(address(this)), address(this).balance);
620         transferOwnership(_owner);
621         return true;
622     }
623 
624     function minimumTokensBeforeSwapAmount() external view returns (uint256) {
625         return minimumTokensBeforeSwap;
626     }
627 
628     function setAutomatedMarketMakerPair(address pair, bool value)
629         public
630         onlyOwner
631     {
632         require(
633             pair != uniswapV2Pair,
634             "The pair cannot be removed from automatedMarketMakerPairs"
635         );
636 
637         _setAutomatedMarketMakerPair(pair, value);
638     }
639 
640     function _setAutomatedMarketMakerPair(address pair, bool value) private {
641         automatedMarketMakerPairs[pair] = value;
642         _isExcludedMaxTransactionAmount[pair] = value;
643         if (value) {
644             excludeFromReward(pair);
645         }
646         if (!value) {
647             includeInReward(pair);
648         }
649     }
650 
651     function reflectionFromToken(uint256 tAmount, bool deductTransferFee)
652         external
653         view
654         returns (uint256)
655     {
656         require(tAmount <= _tTotal, "Amount must be less than supply");
657         if (!deductTransferFee) {
658             (uint256 rAmount, , , , , ) = _getValues(tAmount);
659             return rAmount;
660         } else {
661             (, uint256 rTransferAmount, , , , ) = _getValues(tAmount);
662             return rTransferAmount;
663         }
664     }
665 
666     function tokenFromReflection(uint256 rAmount)
667         public
668         view
669         returns (uint256)
670     {
671         require(
672             rAmount <= _rTotal,
673             "Amount must be less than total reflections"
674         );
675         uint256 currentRate = _getRate();
676         return rAmount.div(currentRate);
677     }
678 
679     function excludeFromReward(address account) public onlyOwner {
680         require(!_isExcluded[account], "Account is already excluded");
681         require(
682             _excluded.length + 1 <= 50,
683             "Cannot exclude more than 50 accounts.  Include a previously excluded address."
684         );
685         if (_rOwned[account] > 0) {
686             _tOwned[account] = tokenFromReflection(_rOwned[account]);
687         }
688         _isExcluded[account] = true;
689         _excluded.push(account);
690     }
691 
692     function includeInReward(address account) public onlyOwner {
693         require(_isExcluded[account], "Account is not excluded");
694         for (uint256 i = 0; i < _excluded.length; i++) {
695             if (_excluded[i] == account) {
696                 _excluded[i] = _excluded[_excluded.length - 1];
697                 _tOwned[account] = 0;
698                 _isExcluded[account] = false;
699                 _excluded.pop();
700                 break;
701             }
702         }
703     }
704 
705     function _approve(
706         address owner,
707         address spender,
708         uint256 amount
709     ) private {
710         require(owner != address(0), "ERC20: approve from the zero address");
711         require(spender != address(0), "ERC20: approve to the zero address");
712 
713         _allowances[owner][spender] = amount;
714         emit Approval(owner, spender, amount);
715     }
716 
717     function _transfer(
718         address from,
719         address to,
720         uint256 amount
721     ) private {
722         require(from != address(0), "ERC20: transfer from the zero address");
723         require(to != address(0), "ERC20: transfer to the zero address");
724         require(amount > 0, "Transfer amount must be greater than zero");
725         require(!blacklist[from], "From address blacklist. Contact admin");
726         require(!blacklist[to], "To address blacklist. Contact admin");
727 
728         if (!tradingActive) {
729             require(
730                 _isExcludedFromFee[from] || _isExcludedFromFee[to],
731                 "Trading is not active yet."
732             );
733         }
734 
735         if (limitsInEffect) {
736             if (
737                 from != owner() &&
738                 to != owner() &&
739                 to != address(0) &&
740                 to != address(0xdead) &&
741                 !inSwapAndLiquify
742             ) {
743                 //when buy
744                 if (
745                     automatedMarketMakerPairs[from] &&
746                     !_isExcludedMaxTransactionAmount[to]
747                 ) {
748                     require(
749                         amount <= maxTransactionAmount,
750                         "Buy transfer amount exceeds the maxTransactionAmount."
751                     );
752                 }
753                 //when sell
754                 else if (
755                     automatedMarketMakerPairs[to] &&
756                     !_isExcludedMaxTransactionAmount[from]
757                 ) {
758                     require(
759                         amount <= maxTransactionAmount,
760                         "Sell transfer amount exceeds the maxTransactionAmount."
761                     );
762                 }
763 
764                 if (!_isExcludedMaxTransactionAmount[to]) {
765                     require(
766                         balanceOf(to) + amount <= maxWalletAmount,
767                         "Max wallet exceeded"
768                     );
769                 }
770             }
771         }
772 
773         uint256 totalTokensToSwap = _liquidityTokensToSwap.add(
774             _teamTokensToSwap
775         );
776         uint256 contractTokenBalance = balanceOf(address(this));
777         bool overMinimumTokenBalance = contractTokenBalance >=
778             minimumTokensBeforeSwap;
779 
780         // swap and liquify
781         if (
782             !inSwapAndLiquify &&
783             swapAndLiquifyEnabled &&
784             balanceOf(uniswapV2Pair) > 0 &&
785             totalTokensToSwap > 0 &&
786             !_isExcludedFromFee[to] &&
787             !_isExcludedFromFee[from] &&
788             automatedMarketMakerPairs[to] &&
789             overMinimumTokenBalance
790         ) {
791             swapBack();
792         }
793 
794         bool takeFee = true;
795 
796         // If any account belongs to _isExcludedFromFee account then remove the fee
797         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
798             takeFee = false;
799             buyOrSellSwitch = TRANSFER; // TRANSFERs do not pay a tax.
800         } else {
801             // Buy
802             if (automatedMarketMakerPairs[from]) {
803                 removeAllFee();
804                 buyOrSellSwitch = BUY;
805                 if (block.number == tradingActiveBlock) {
806                     _taxFee = 0;
807                     _liquidityFee = 90;
808                 } else if (block.number == tradingActiveBlock + 1) {
809                     _taxFee = 0;
810                     _liquidityFee = 50;
811                 } else {
812                     _taxFee = _buyTaxFee;
813                     _liquidityFee = _buyLiquidityFee + _buyTeamFee;
814                 }
815             }
816             // Sell
817             else if (automatedMarketMakerPairs[to]) {
818                 removeAllFee();
819                 buyOrSellSwitch = SELL;
820                 // higher tax if bought in the same block as trading active for 72 hours (sniper protect)
821                 if (block.number == tradingActiveBlock) {
822                     _taxFee = 0;
823                     _liquidityFee = 90;
824                 } else if (block.number == tradingActiveBlock + 1) {
825                     _taxFee = 0;
826                     _liquidityFee = 50;
827                 } else {
828                     _taxFee = _sellTaxFee;
829                     _liquidityFee = _sellLiquidityFee + _sellTeamFee;
830                 }
831                 // Normal transfers do not get taxed
832             } else {
833                 removeAllFee();
834                 buyOrSellSwitch = TRANSFER; // TRANSFERs do not pay a tax.
835             }
836         }
837 
838         _tokenTransfer(from, to, amount, takeFee);
839     }
840 
841     function swapBack() private lockTheSwap {
842         uint256 contractBalance = balanceOf(address(this));
843         uint256 totalTokensToSwap = _liquidityTokensToSwap + _teamTokensToSwap;
844 
845         // Halve the amount of liquidity tokens
846         uint256 tokensForLiquidity = _liquidityTokensToSwap.div(2);
847         uint256 amountToSwapForETH = contractBalance.sub(tokensForLiquidity);
848 
849         uint256 initialETHBalance = address(this).balance;
850 
851         swapTokensForETH(amountToSwapForETH);
852 
853         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
854 
855         uint256 ethForMarketing = ethBalance.mul(_teamTokensToSwap).div(
856             totalTokensToSwap
857         );
858 
859         uint256 ethForLiquidity = ethBalance.sub(ethForMarketing);
860 
861         uint256 ethForDev = ethForMarketing.mul(_percentTeamFundsToDev).div(
862             1000
863         );
864         uint256 ethForTreasury = ethForMarketing
865             .mul(_percentTeamFundsToTreasury)
866             .div(1000);
867         ethForMarketing -= ethForDev;
868         ethForMarketing -= ethForTreasury;
869 
870         _liquidityTokensToSwap = 0;
871         _teamTokensToSwap = 0;
872 
873         (bool success, ) = address(marketingAddress).call{
874             value: ethForMarketing
875         }("");
876         (success, ) = address(devAddress).call{ value: ethForDev }("");
877         (success, ) = address(treasuryAddress).call{ value: ethForTreasury }(
878             ""
879         );
880 
881         addLiquidity(tokensForLiquidity, ethForLiquidity);
882         emit SwapAndLiquify(
883             amountToSwapForETH,
884             ethForLiquidity,
885             tokensForLiquidity
886         );
887 
888         // send leftover to the marketing wallet so it doesn't get stuck on the contract.
889         if (address(this).balance > 1e17) {
890             (success, ) = address(marketingAddress).call{
891                 value: address(this).balance
892             }("");
893         }
894     }
895 
896     // force Swap back if slippage above 49% for launch.
897     function forceSwapBack() external onlyOwner {
898         uint256 contractBalance = balanceOf(address(this));
899         require(
900             contractBalance >= _tTotal / 100,
901             "Can only swap back if more than 1% of tokens stuck on contract"
902         );
903         swapBack();
904         emit OwnerForcedSwapBack(block.timestamp);
905     }
906 
907     // Add to blacklist
908     function addToBlacklist(address account) external onlyOwner {
909         require(account != address(0), "Cannot blacklist 0 address");
910         blacklist[account] = true;
911     }
912 
913     // Remove from blacklist
914     function removeFromBlacklist(address account) external onlyOwner {
915         require(account != address(0), "Cannot use 0 address");
916         blacklist[account] = false;
917     }
918 
919     function swapTokensForETH(uint256 tokenAmount) private {
920         address[] memory path = new address[](2);
921         path[0] = address(this);
922         path[1] = uniswapV2Router.WETH();
923         _approve(address(this), address(uniswapV2Router), tokenAmount);
924         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
925             tokenAmount,
926             0, // accept any amount of ETH
927             path,
928             address(this),
929             block.timestamp
930         );
931     }
932 
933     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
934         _approve(address(this), address(uniswapV2Router), tokenAmount);
935         uniswapV2Router.addLiquidityETH{ value: ethAmount }(
936             address(this),
937             tokenAmount,
938             0, // slippage is unavoidable
939             0, // slippage is unavoidable
940             liquidityAddress,
941             block.timestamp
942         );
943     }
944 
945     function _tokenTransfer(
946         address sender,
947         address recipient,
948         uint256 amount,
949         bool takeFee
950     ) private {
951         if (!takeFee) removeAllFee();
952 
953         if (_isExcluded[sender] && !_isExcluded[recipient]) {
954             _transferFromExcluded(sender, recipient, amount);
955         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
956             _transferToExcluded(sender, recipient, amount);
957         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
958             _transferBothExcluded(sender, recipient, amount);
959         } else {
960             _transferStandard(sender, recipient, amount);
961         }
962 
963         if (!takeFee) restoreAllFee();
964     }
965 
966     function _transferStandard(
967         address sender,
968         address recipient,
969         uint256 tAmount
970     ) private {
971         (
972             uint256 rAmount,
973             uint256 rTransferAmount,
974             uint256 rFee,
975             uint256 tTransferAmount,
976             uint256 tFee,
977             uint256 tLiquidity
978         ) = _getValues(tAmount);
979         _rOwned[sender] = _rOwned[sender].sub(rAmount);
980         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
981         _takeLiquidity(tLiquidity);
982         _reflectFee(rFee, tFee);
983         emit Transfer(sender, recipient, tTransferAmount);
984     }
985 
986     function _transferToExcluded(
987         address sender,
988         address recipient,
989         uint256 tAmount
990     ) private {
991         (
992             uint256 rAmount,
993             uint256 rTransferAmount,
994             uint256 rFee,
995             uint256 tTransferAmount,
996             uint256 tFee,
997             uint256 tLiquidity
998         ) = _getValues(tAmount);
999         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1000         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1001         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1002         _takeLiquidity(tLiquidity);
1003         _reflectFee(rFee, tFee);
1004         emit Transfer(sender, recipient, tTransferAmount);
1005     }
1006 
1007     function _transferFromExcluded(
1008         address sender,
1009         address recipient,
1010         uint256 tAmount
1011     ) private {
1012         (
1013             uint256 rAmount,
1014             uint256 rTransferAmount,
1015             uint256 rFee,
1016             uint256 tTransferAmount,
1017             uint256 tFee,
1018             uint256 tLiquidity
1019         ) = _getValues(tAmount);
1020         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1021         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1022         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1023         _takeLiquidity(tLiquidity);
1024         _reflectFee(rFee, tFee);
1025         emit Transfer(sender, recipient, tTransferAmount);
1026     }
1027 
1028     function _transferBothExcluded(
1029         address sender,
1030         address recipient,
1031         uint256 tAmount
1032     ) private {
1033         (
1034             uint256 rAmount,
1035             uint256 rTransferAmount,
1036             uint256 rFee,
1037             uint256 tTransferAmount,
1038             uint256 tFee,
1039             uint256 tLiquidity
1040         ) = _getValues(tAmount);
1041         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1042         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1043         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1044         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1045         _takeLiquidity(tLiquidity);
1046         _reflectFee(rFee, tFee);
1047         emit Transfer(sender, recipient, tTransferAmount);
1048     }
1049 
1050     function _reflectFee(uint256 rFee, uint256 tFee) private {
1051         _rTotal = _rTotal.sub(rFee);
1052         _tFeeTotal = _tFeeTotal.add(tFee);
1053     }
1054 
1055     function _getValues(uint256 tAmount)
1056         private
1057         view
1058         returns (
1059             uint256,
1060             uint256,
1061             uint256,
1062             uint256,
1063             uint256,
1064             uint256
1065         )
1066     {
1067         (
1068             uint256 tTransferAmount,
1069             uint256 tFee,
1070             uint256 tLiquidity
1071         ) = _getTValues(tAmount);
1072         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
1073             tAmount,
1074             tFee,
1075             tLiquidity,
1076             _getRate()
1077         );
1078         return (
1079             rAmount,
1080             rTransferAmount,
1081             rFee,
1082             tTransferAmount,
1083             tFee,
1084             tLiquidity
1085         );
1086     }
1087 
1088     function _getTValues(uint256 tAmount)
1089         private
1090         view
1091         returns (
1092             uint256,
1093             uint256,
1094             uint256
1095         )
1096     {
1097         uint256 tFee = calculateTaxFee(tAmount);
1098         uint256 tLiquidity = calculateLiquidityFee(tAmount);
1099         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
1100         return (tTransferAmount, tFee, tLiquidity);
1101     }
1102 
1103     function _getRValues(
1104         uint256 tAmount,
1105         uint256 tFee,
1106         uint256 tLiquidity,
1107         uint256 currentRate
1108     )
1109         private
1110         pure
1111         returns (
1112             uint256,
1113             uint256,
1114             uint256
1115         )
1116     {
1117         uint256 rAmount = tAmount.mul(currentRate);
1118         uint256 rFee = tFee.mul(currentRate);
1119         uint256 rLiquidity = tLiquidity.mul(currentRate);
1120         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
1121         return (rAmount, rTransferAmount, rFee);
1122     }
1123 
1124     function _getRate() private view returns (uint256) {
1125         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1126         return rSupply.div(tSupply);
1127     }
1128 
1129     function _getCurrentSupply() private view returns (uint256, uint256) {
1130         uint256 rSupply = _rTotal;
1131         uint256 tSupply = _tTotal;
1132         for (uint256 i = 0; i < _excluded.length; i++) {
1133             if (
1134                 _rOwned[_excluded[i]] > rSupply ||
1135                 _tOwned[_excluded[i]] > tSupply
1136             ) return (_rTotal, _tTotal);
1137             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1138             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1139         }
1140         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1141         return (rSupply, tSupply);
1142     }
1143 
1144     function _takeLiquidity(uint256 tLiquidity) private {
1145         if (buyOrSellSwitch == BUY) {
1146             _liquidityTokensToSwap +=
1147                 (tLiquidity * _buyLiquidityFee) /
1148                 _liquidityFee;
1149             _teamTokensToSwap += (tLiquidity * _buyTeamFee) / _liquidityFee;
1150         } else if (buyOrSellSwitch == SELL) {
1151             _liquidityTokensToSwap +=
1152                 (tLiquidity * _sellLiquidityFee) /
1153                 _liquidityFee;
1154             _teamTokensToSwap += (tLiquidity * _sellTeamFee) / _liquidityFee;
1155         }
1156         uint256 currentRate = _getRate();
1157         uint256 rLiquidity = tLiquidity.mul(currentRate);
1158         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1159         if (_isExcluded[address(this)])
1160             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1161     }
1162 
1163     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1164         return _amount.mul(_taxFee).div(10**2);
1165     }
1166 
1167     function calculateLiquidityFee(uint256 _amount)
1168         private
1169         view
1170         returns (uint256)
1171     {
1172         return _amount.mul(_liquidityFee).div(10**2);
1173     }
1174 
1175     function removeAllFee() private {
1176         if (_taxFee == 0 && _liquidityFee == 0) return;
1177 
1178         _previousTaxFee = _taxFee;
1179         _previousLiquidityFee = _liquidityFee;
1180 
1181         _taxFee = 0;
1182         _liquidityFee = 0;
1183     }
1184 
1185     function restoreAllFee() private {
1186         _taxFee = _previousTaxFee;
1187         _liquidityFee = _previousLiquidityFee;
1188     }
1189 
1190     function isExcludedFromFee(address account) external view returns (bool) {
1191         return _isExcludedFromFee[account];
1192     }
1193 
1194     function excludeFromFee(address account) external onlyOwner {
1195         _isExcludedFromFee[account] = true;
1196         emit ExcludeFromFee(account);
1197     }
1198 
1199     function includeInFee(address account) external onlyOwner {
1200         _isExcludedFromFee[account] = false;
1201         emit IncludeInFee(account);
1202     }
1203 
1204     function setMaxTransactionAmount(uint256 newMaxBuy) external onlyOwner {
1205         require(newMaxBuy > 0, "Cannot be 0");
1206         maxTransactionAmount = (_tTotal * newMaxBuy) / 1000;
1207     }
1208 
1209     function setMaxWallet(uint256 newMaxWallet) external onlyOwner {
1210         require(newMaxWallet > 0, "Cannot be 0");
1211         maxWalletAmount = (_tTotal * newMaxWallet) / 1000;
1212     }
1213 
1214     function setBuyFee(
1215         uint256 buyTaxFee,
1216         uint256 buyLiquidityFee,
1217         uint256 buyTeamFee
1218     ) external onlyOwner {
1219         _buyTaxFee = buyTaxFee;
1220         _buyLiquidityFee = buyLiquidityFee;
1221         _buyTeamFee = buyTeamFee;
1222         require(
1223             _buyTaxFee + _buyLiquidityFee + _buyTeamFee <= 100,
1224             "Must keep buy taxes below 100%"
1225         );
1226         emit SetBuyFee(buyTeamFee, buyLiquidityFee, buyTaxFee);
1227     }
1228 
1229     function setSellFee(
1230         uint256 sellTaxFee,
1231         uint256 sellLiquidityFee,
1232         uint256 sellTeamFee
1233     ) external onlyOwner {
1234         _sellTaxFee = sellTaxFee;
1235         _sellLiquidityFee = sellLiquidityFee;
1236         _sellTeamFee = sellTeamFee;
1237         require(
1238             _sellTaxFee + _sellLiquidityFee + _sellTeamFee <= 100,
1239             "Must keep sell taxes below 100%"
1240         );
1241         emit SetSellFee(sellTeamFee, sellLiquidityFee, sellTaxFee);
1242     }
1243 
1244     function setTeamSplit(uint256 treasurySplit, uint256 devSplit)
1245         external
1246         onlyOwner
1247     {
1248         require(treasurySplit + devSplit < 1000, "Split over 100%");
1249         _percentTeamFundsToTreasury = treasurySplit;
1250         _percentTeamFundsToDev = devSplit;
1251     }
1252 
1253     function setMarketingAddress(address _marketingAddress) external onlyOwner {
1254         require(
1255             _marketingAddress != address(0),
1256             "_marketingAddress address cannot be 0"
1257         );
1258         _isExcludedFromFee[marketingAddress] = false;
1259         marketingAddress = payable(_marketingAddress);
1260         _isExcludedFromFee[marketingAddress] = true;
1261         emit UpdatedTeamAddress(_marketingAddress);
1262     }
1263 
1264     function setLiquidityAddress(address _liquidityAddress) public onlyOwner {
1265         require(
1266             _liquidityAddress != address(0),
1267             "_liquidityAddress address cannot be 0"
1268         );
1269         liquidityAddress = payable(_liquidityAddress);
1270         _isExcludedFromFee[liquidityAddress] = true;
1271         emit UpdatedLiquidityAddress(_liquidityAddress);
1272     }
1273 
1274     function setDeveloperAddress(address _devAddress) external onlyOwner {
1275         require(_devAddress != address(0), "Cannot be 0 address");
1276         devAddress = payable(_devAddress);
1277         _isExcludedFromFee[devAddress] = true;
1278     }
1279 
1280     function setTreasuryAddress(address _treasuryAddress) external onlyOwner {
1281         require(_treasuryAddress != address(0), "Cannot be 0 address");
1282         treasuryAddress = payable(_treasuryAddress);
1283         _isExcludedFromFee[treasuryAddress] = true;
1284     }
1285 
1286     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1287         swapAndLiquifyEnabled = _enabled;
1288         emit SwapAndLiquifyEnabledUpdated(_enabled);
1289     }
1290 
1291     // To receive ETH from uniswapV2Router when swapping
1292     receive() external payable {}
1293 
1294     function transferForeignToken(address _token, address _to)
1295         external
1296         onlyOwner
1297         returns (bool _sent)
1298     {
1299         require(_token != address(0), "_token address cannot be 0");
1300         require(_token != address(this), "Can't withdraw native tokens");
1301         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
1302         _sent = IERC20(_token).transfer(_to, _contractBalance);
1303         emit TransferForeignToken(_token, _contractBalance);
1304     }
1305 
1306     // withdraw ETH if stuck before launch
1307     function withdrawStuckETH() external onlyOwner {
1308         require(!tradingActive, "Can only withdraw if trading hasn't started");
1309         bool success;
1310         (success, ) = address(msg.sender).call{ value: address(this).balance }(
1311             ""
1312         );
1313     }
1314 }