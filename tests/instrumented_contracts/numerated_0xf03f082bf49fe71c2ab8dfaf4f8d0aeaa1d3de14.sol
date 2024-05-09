1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.9;
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
256     event PairCreated(
257         address indexed token0,
258         address indexed token1,
259         address pair,
260         uint256
261     );
262 
263     function feeTo() external view returns (address);
264 
265     function feeToSetter() external view returns (address);
266 
267     function getPair(address tokenA, address tokenB)
268         external
269         view
270         returns (address pair);
271 
272     function allPairs(uint256) external view returns (address pair);
273 
274     function allPairsLength() external view returns (uint256);
275 
276     function createPair(address tokenA, address tokenB)
277         external
278         returns (address pair);
279 
280     function setFeeTo(address) external;
281 
282     function setFeeToSetter(address) external;
283 }
284 
285 
286 interface IUniswapV2Pair {
287     event Approval(
288         address indexed owner,
289         address indexed spender,
290         uint256 value
291     );
292     event Transfer(address indexed from, address indexed to, uint256 value);
293 
294     function name() external pure returns (string memory);
295 
296     function symbol() external pure returns (string memory);
297 
298     function decimals() external pure returns (uint8);
299 
300     function totalSupply() external view returns (uint256);
301 
302     function balanceOf(address owner) external view returns (uint256);
303 
304     function allowance(address owner, address spender)
305         external
306         view
307         returns (uint256);
308 
309     function approve(address spender, uint256 value) external returns (bool);
310 
311     function transfer(address to, uint256 value) external returns (bool);
312 
313     function transferFrom(
314         address from,
315         address to,
316         uint256 value
317     ) external returns (bool);
318 
319     function DOMAIN_SEPARATOR() external view returns (bytes32);
320 
321     function PERMIT_TYPEHASH() external pure returns (bytes32);
322 
323     function nonces(address owner) external view returns (uint256);
324 
325     function permit(
326         address owner,
327         address spender,
328         uint256 value,
329         uint256 deadline,
330         uint8 v,
331         bytes32 r,
332         bytes32 s
333     ) external;
334 
335     event Burn(
336         address indexed sender,
337         uint256 amount0,
338         uint256 amount1,
339         address indexed to
340     );
341     event Swap(
342         address indexed sender,
343         uint256 amount0In,
344         uint256 amount1In,
345         uint256 amount0Out,
346         uint256 amount1Out,
347         address indexed to
348     );
349     event Sync(uint112 reserve0, uint112 reserve1);
350 
351     function MINIMUM_LIQUIDITY() external pure returns (uint256);
352 
353     function factory() external view returns (address);
354 
355     function token0() external view returns (address);
356 
357     function token1() external view returns (address);
358 
359     function getReserves()
360         external
361         view
362         returns (
363             uint112 reserve0,
364             uint112 reserve1,
365             uint32 blockTimestampLast
366         );
367 
368     function price0CumulativeLast() external view returns (uint256);
369 
370     function price1CumulativeLast() external view returns (uint256);
371 
372     function kLast() external view returns (uint256);
373 
374     function burn(address to)
375         external
376         returns (uint256 amount0, uint256 amount1);
377 
378     function swap(
379         uint256 amount0Out,
380         uint256 amount1Out,
381         address to,
382         bytes calldata data
383     ) external;
384 
385     function skim(address to) external;
386 
387     function sync() external;
388 
389     function initialize(address, address) external;
390 }
391 
392 interface IUniswapV2Router01 {
393     function factory() external pure returns (address);
394 
395     function WETH() external pure returns (address);
396 
397     function addLiquidity(
398         address tokenA,
399         address tokenB,
400         uint256 amountADesired,
401         uint256 amountBDesired,
402         uint256 amountAMin,
403         uint256 amountBMin,
404         address to,
405         uint256 deadline
406     )
407         external
408         returns (
409             uint256 amountA,
410             uint256 amountB,
411             uint256 liquidity
412         );
413 
414     function addLiquidityETH(
415         address token,
416         uint256 amountTokenDesired,
417         uint256 amountTokenMin,
418         uint256 amountETHMin,
419         address to,
420         uint256 deadline
421     )
422         external
423         payable
424         returns (
425             uint256 amountToken,
426             uint256 amountETH,
427             uint256 liquidity
428         );
429 
430     function removeLiquidity(
431         address tokenA,
432         address tokenB,
433         uint256 liquidity,
434         uint256 amountAMin,
435         uint256 amountBMin,
436         address to,
437         uint256 deadline
438     ) external returns (uint256 amountA, uint256 amountB);
439 
440     function removeLiquidityETH(
441         address token,
442         uint256 liquidity,
443         uint256 amountTokenMin,
444         uint256 amountETHMin,
445         address to,
446         uint256 deadline
447     ) external returns (uint256 amountToken, uint256 amountETH);
448 
449     function removeLiquidityWithPermit(
450         address tokenA,
451         address tokenB,
452         uint256 liquidity,
453         uint256 amountAMin,
454         uint256 amountBMin,
455         address to,
456         uint256 deadline,
457         bool approveMax,
458         uint8 v,
459         bytes32 r,
460         bytes32 s
461     ) external returns (uint256 amountA, uint256 amountB);
462 
463     function removeLiquidityETHWithPermit(
464         address token,
465         uint256 liquidity,
466         uint256 amountTokenMin,
467         uint256 amountETHMin,
468         address to,
469         uint256 deadline,
470         bool approveMax,
471         uint8 v,
472         bytes32 r,
473         bytes32 s
474     ) external returns (uint256 amountToken, uint256 amountETH);
475 
476     function swapExactTokensForTokens(
477         uint256 amountIn,
478         uint256 amountOutMin,
479         address[] calldata path,
480         address to,
481         uint256 deadline
482     ) external returns (uint256[] memory amounts);
483 
484     function swapTokensForExactTokens(
485         uint256 amountOut,
486         uint256 amountInMax,
487         address[] calldata path,
488         address to,
489         uint256 deadline
490     ) external returns (uint256[] memory amounts);
491 
492     function swapExactETHForTokens(
493         uint256 amountOutMin,
494         address[] calldata path,
495         address to,
496         uint256 deadline
497     ) external payable returns (uint256[] memory amounts);
498 
499     function swapTokensForExactETH(
500         uint256 amountOut,
501         uint256 amountInMax,
502         address[] calldata path,
503         address to,
504         uint256 deadline
505     ) external returns (uint256[] memory amounts);
506 
507     function swapExactTokensForETH(
508         uint256 amountIn,
509         uint256 amountOutMin,
510         address[] calldata path,
511         address to,
512         uint256 deadline
513     ) external returns (uint256[] memory amounts);
514 
515     function swapETHForExactTokens(
516         uint256 amountOut,
517         address[] calldata path,
518         address to,
519         uint256 deadline
520     ) external payable returns (uint256[] memory amounts);
521 
522     function quote(
523         uint256 amountA,
524         uint256 reserveA,
525         uint256 reserveB
526     ) external pure returns (uint256 amountB);
527 
528     function getAmountOut(
529         uint256 amountIn,
530         uint256 reserveIn,
531         uint256 reserveOut
532     ) external pure returns (uint256 amountOut);
533 
534     function getAmountIn(
535         uint256 amountOut,
536         uint256 reserveIn,
537         uint256 reserveOut
538     ) external pure returns (uint256 amountIn);
539 
540     function getAmountsOut(uint256 amountIn, address[] calldata path)
541         external
542         view
543         returns (uint256[] memory amounts);
544 
545     function getAmountsIn(uint256 amountOut, address[] calldata path)
546         external
547         view
548         returns (uint256[] memory amounts);
549 }
550 
551 interface IUniswapV2Router02 is IUniswapV2Router01 {
552     function removeLiquidityETHSupportingFeeOnTransferTokens(
553         address token,
554         uint256 liquidity,
555         uint256 amountTokenMin,
556         uint256 amountETHMin,
557         address to,
558         uint256 deadline
559     ) external returns (uint256 amountETH);
560 
561     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
562         address token,
563         uint256 liquidity,
564         uint256 amountTokenMin,
565         uint256 amountETHMin,
566         address to,
567         uint256 deadline,
568         bool approveMax,
569         uint8 v,
570         bytes32 r,
571         bytes32 s
572     ) external returns (uint256 amountETH);
573 
574     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
575         uint256 amountIn,
576         uint256 amountOutMin,
577         address[] calldata path,
578         address to,
579         uint256 deadline
580     ) external;
581 
582     function swapExactETHForTokensSupportingFeeOnTransferTokens(
583         uint256 amountOutMin,
584         address[] calldata path,
585         address to,
586         uint256 deadline
587     ) external payable;
588 
589     function swapExactTokensForETHSupportingFeeOnTransferTokens(
590         uint256 amountIn,
591         uint256 amountOutMin,
592         address[] calldata path,
593         address to,
594         uint256 deadline
595     ) external;
596 }
597 
598 contract PonyoInu is Context, IERC20, Ownable {
599     using SafeMath for uint256;
600     using Address for address;
601 
602     address payable public marketingAddress;
603         
604     address payable public devAddress;
605         
606     address payable public liquidityAddress;
607     
608     address payable public charityAddress;
609         
610         
611     mapping(address => uint256) private _rOwned;
612     mapping(address => uint256) private _tOwned;
613     mapping(address => mapping(address => uint256)) private _allowances;
614     
615     // Anti-bot and anti-whale mappings and variables
616     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
617     bool public transferDelayEnabled = true;
618     bool public limitsInEffect = true;
619 
620     mapping(address => bool) private _isExcludedFromFee;
621 
622     mapping(address => bool) private _isExcluded;
623     address[] private _excluded;
624     
625     uint256 private constant MAX = ~uint256(0);
626     uint256 private constant _tTotal = 1 * 1e9 * 1e18;
627     uint256 private _rTotal = (MAX - (MAX % _tTotal));
628     uint256 private _tFeeTotal;
629 
630     string private constant _name = "Ponyo-Inu";
631     string private constant _symbol = "PONYO";
632     uint8 private constant _decimals = 18;
633 
634     // airdrop limits to prevent airdrop dump to protect new investors
635     mapping(address => uint256) public _airDropAddressNextSellDate;
636     mapping(address => uint256) public _airDropTokensRemaining;
637     uint256 public airDropLimitLiftDate;
638     bool public airDropLimitInEffect;
639     mapping (address => bool) public _isAirdoppedWallet;
640     mapping (address => uint256) public _airDroppedTokenAmount;
641     uint256 public airDropDailySellPerc = 5;
642 
643     // these values are pretty much arbitrary since they get overwritten for every txn, but the placeholders make it easier to work with current contract.
644     uint256 private _taxFee;
645     uint256 private _previousTaxFee = _taxFee;
646 
647     uint256 private _marketingFee;
648     
649     uint256 private _liquidityFee;
650     uint256 private _previousLiquidityFee = _liquidityFee;
651     
652     uint256 private constant BUY = 1;
653     uint256 private constant SELL = 2;
654     uint256 private constant TRANSFER = 3;
655     uint256 private buyOrSellSwitch;
656 
657     uint256 public _buyTaxFee = 1;
658     uint256 public _buyLiquidityFee = 2;
659     uint256 public _buyMarketingFee = 5;
660     uint256 public _buyCharityFee = 3;
661 
662     uint256 public _sellTaxFee = 1;
663     uint256 public _sellLiquidityFee = 2;
664     uint256 public _sellMarketingFee = 5;
665     uint256 public _sellCharityFee = 3;
666     
667     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
668     mapping(address => bool) public boughtEarly;
669     uint256 public earlyBuyPenaltyEnd; // determines when snipers/bots can sell without extra penalty
670     
671     uint256 public _liquidityTokensToSwap;
672     uint256 public _marketingTokensToSwap;
673     uint256 public _charityTokensToSwap;
674     
675     uint256 public maxTransactionAmount;
676     mapping (address => bool) public _isExcludedMaxTransactionAmount;
677     
678     bool private gasLimitActive = true;
679     uint256 private gasPriceLimit = 498 * 1 gwei; // do not allow over x gwei for launch
680     
681     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
682     // could be subject to a maximum transfer amount
683     mapping (address => bool) public automatedMarketMakerPairs;
684 
685     uint256 private minimumTokensBeforeSwap;
686 
687     IUniswapV2Router02 public uniswapV2Router;
688     address public uniswapV2Pair;
689 
690     bool inSwapAndLiquify;
691     bool public swapAndLiquifyEnabled = false;
692     bool public tradingActive = false;
693 
694     event SwapAndLiquifyEnabledUpdated(bool enabled);
695     event SwapAndLiquify(
696         uint256 tokensSwapped,
697         uint256 ethReceived,
698         uint256 tokensIntoLiquidity
699     );
700 
701     event SwapETHForTokens(uint256 amountIn, address[] path);
702 
703     event SwapTokensForETH(uint256 amountIn, address[] path);
704     
705     event SetAutomatedMarketMakerPair(address pair, bool value);
706     
707     event ExcludeFromReward(address excludedAddress);
708     
709     event IncludeInReward(address includedAddress);
710     
711     event ExcludeFromFee(address excludedAddress);
712     
713     event IncludeInFee(address includedAddress);
714     
715     event SetBuyFee(uint256 marketingFee, uint256 liquidityFee, uint256 reflectFee);
716     
717     event SetSellFee(uint256 marketingFee, uint256 liquidityFee, uint256 reflectFee);
718     
719     event TransferForeignToken(address token, uint256 amount);
720     
721     event UpdatedMarketingAddress(address marketing);
722     
723     event UpdatedLiquidityAddress(address liquidity);
724     
725     event UpdatedCharityAddress(address charity);
726     
727     event UpdatedDevAddress(address dev);
728     
729     event OwnerForcedSwapBack(uint256 timestamp);
730     
731     event BoughtEarly(address indexed sniper);
732     
733     event RemovedSniper(address indexed notsnipersupposedly);
734 
735     modifier lockTheSwap() {
736         inSwapAndLiquify = true;
737         _;
738         inSwapAndLiquify = false;
739     }
740 
741     constructor() payable {
742         _rOwned[_msgSender()] = _rTotal / 1000 * 250;
743         _rOwned[address(this)] = _rTotal / 1000 * 750;
744 
745         airDropLimitLiftDate = block.timestamp + 14 days;
746         airDropLimitInEffect = true;
747         
748         maxTransactionAmount = _tTotal * 5 / 1000; // 0.5% maxTransactionAmountTxn
749         minimumTokensBeforeSwap = _tTotal * 5 / 10000; // 0.05% swap tokens amount
750         
751         marketingAddress = payable(0x793c894c633FE539f8D226eB41C36C651bE5c67F); // Marketing Address
752         
753         devAddress = payable(0x6B2c5a6df5E51264e31479605b55bD73b727Bbf5); // Dev Address
754         
755         liquidityAddress = payable(owner()); // Liquidity Address (switches to dead address once launch happens)
756         
757         _isExcludedFromFee[owner()] = true;
758         _isExcludedFromFee[address(this)] = true;
759         _isExcludedFromFee[marketingAddress] = true;
760         _isExcludedFromFee[liquidityAddress] = true;
761         
762         excludeFromMaxTransaction(owner(), true);
763         excludeFromMaxTransaction(address(this), true);
764         excludeFromMaxTransaction(address(0xdead), true);
765         
766         emit Transfer(address(0), _msgSender(), _tTotal * 250 / 1000);
767         emit Transfer(address(0), address(this), _tTotal * 750 / 1000);
768     }
769 
770     function name() external pure returns (string memory) {
771         return _name;
772     }
773 
774     function symbol() external pure returns (string memory) {
775         return _symbol;
776     }
777 
778     function decimals() external pure returns (uint8) {
779         return _decimals;
780     }
781 
782     function totalSupply() external pure override returns (uint256) {
783         return _tTotal;
784     }
785 
786     function balanceOf(address account) public view override returns (uint256) {
787         if (_isExcluded[account]) return _tOwned[account];
788         return tokenFromReflection(_rOwned[account]);
789     }
790 
791     function transfer(address recipient, uint256 amount)
792         external
793         override
794         returns (bool)
795     {
796         _transfer(_msgSender(), recipient, amount);
797         return true;
798     }
799 
800     function allowance(address owner, address spender)
801         external
802         view
803         override
804         returns (uint256)
805     {
806         return _allowances[owner][spender];
807     }
808 
809     function approve(address spender, uint256 amount)
810         public
811         override
812         returns (bool)
813     {
814         _approve(_msgSender(), spender, amount);
815         return true;
816     }
817 
818     function transferFrom(
819         address sender,
820         address recipient,
821         uint256 amount
822     ) external override returns (bool) {
823         _transfer(sender, recipient, amount);
824         _approve(
825             sender,
826             _msgSender(),
827             _allowances[sender][_msgSender()].sub(
828                 amount,
829                 "ERC20: transfer amount exceeds allowance"
830             )
831         );
832         return true;
833     }
834 
835     function getWalletMaxAirdropSell(address holder) public view returns (uint256){
836         if(airDropLimitInEffect){
837             return _airDroppedTokenAmount[holder].mul(airDropDailySellPerc).div(100);
838         }
839         return _airDropTokensRemaining[holder];
840     }
841 
842     function increaseAllowance(address spender, uint256 addedValue)
843         external
844         virtual
845         returns (bool)
846     {
847         _approve(
848             _msgSender(),
849             spender,
850             _allowances[_msgSender()][spender].add(addedValue)
851         );
852         return true;
853     }
854 
855     function decreaseAllowance(address spender, uint256 subtractedValue)
856         external
857         virtual
858         returns (bool)
859     {
860         _approve(
861             _msgSender(),
862             spender,
863             _allowances[_msgSender()][spender].sub(
864                 subtractedValue,
865                 "ERC20: decreased allowance below zero"
866             )
867         );
868         return true;
869     }
870 
871     function isExcludedFromReward(address account)
872         external
873         view
874         returns (bool)
875     {
876         return _isExcluded[account];
877     }
878 
879     function totalFees() external view returns (uint256) {
880         return _tFeeTotal;
881     }
882     
883     // remove limits after token is stable - 30-60 minutes
884     function removeLimits() external onlyOwner returns (bool){
885         limitsInEffect = false;
886         gasLimitActive = false;
887         transferDelayEnabled = false;
888         return true;
889     }
890     
891     // disable Transfer delay
892     function disableTransferDelay() external onlyOwner returns (bool){
893         transferDelayEnabled = false;
894         return true;
895     }
896     
897     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
898         _isExcludedMaxTransactionAmount[updAds] = isEx;
899     }
900     
901     // once enabled, can never be turned off
902     function enableTrading() internal onlyOwner {
903         tradingActive = true;
904         swapAndLiquifyEnabled = true;
905         tradingActiveBlock = block.number;
906         earlyBuyPenaltyEnd = block.timestamp + 72 hours;
907     }
908     
909     // send tokens and ETH for liquidity to contract directly, then call this (not required, can still use Uniswap to add liquidity manually, but this ensures everything is excluded properly and makes for a great stealth launch)
910     function launch(address[] memory airdropWallets, uint256[] memory amounts) external onlyOwner returns (bool){
911         require(!tradingActive, "Trading is already active, cannot relaunch.");
912         require(airdropWallets.length < 200, "Can only airdrop 200 wallets per txn due to gas limits"); // allows for airdrop + launch at the same exact time, reducing delays and reducing sniper input.
913         for(uint256 i = 0; i < airdropWallets.length; i++){
914             address wallet = airdropWallets[i];
915             uint256 amount = amounts[i];
916             _isAirdoppedWallet[wallet] = true;
917             _airDroppedTokenAmount[wallet] = amount;
918             _airDropTokensRemaining[wallet] = amount;
919             _airDropAddressNextSellDate[wallet] = block.timestamp.sub(1);
920             _transfer(msg.sender, wallet, amount);
921         }
922         enableTrading();
923         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
924         excludeFromMaxTransaction(address(_uniswapV2Router), true);
925         uniswapV2Router = _uniswapV2Router;
926         _approve(address(this), address(uniswapV2Router), _tTotal);
927         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
928         excludeFromMaxTransaction(address(uniswapV2Pair), true);
929         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
930         require(address(this).balance > 0, "Must have ETH on contract to launch");
931         addLiquidity(balanceOf(address(this)), address(this).balance);
932         setLiquidityAddress(address(0xdead));
933         return true;
934     }
935     
936     function minimumTokensBeforeSwapAmount() external view returns (uint256) {
937         return minimumTokensBeforeSwap;
938     }
939     
940     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
941         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
942 
943         _setAutomatedMarketMakerPair(pair, value);
944     }
945 
946     function _setAutomatedMarketMakerPair(address pair, bool value) private {
947         automatedMarketMakerPairs[pair] = value;
948         _isExcludedMaxTransactionAmount[pair] = value;
949         if(value){excludeFromReward(pair);}
950         if(!value){includeInReward(pair);}
951     }
952     
953     function setGasPriceLimit(uint256 gas) external onlyOwner {
954         require(gas >= 200);
955         gasPriceLimit = gas * 1 gwei;
956     }
957 
958     function reflectionFromToken(uint256 tAmount, bool deductTransferFee)
959         external
960         view
961         returns (uint256)
962     {
963         require(tAmount <= _tTotal, "Amount must be less than supply");
964         if (!deductTransferFee) {
965             (uint256 rAmount, , , , , ) = _getValues(tAmount);
966             return rAmount;
967         } else {
968             (, uint256 rTransferAmount, , , , ) = _getValues(tAmount);
969             return rTransferAmount;
970         }
971     }
972 
973     function tokenFromReflection(uint256 rAmount)
974         public
975         view
976         returns (uint256)
977     {
978         require(
979             rAmount <= _rTotal,
980             "Amount must be less than total reflections"
981         );
982         uint256 currentRate = _getRate();
983         return rAmount.div(currentRate);
984     }
985 
986     function excludeFromReward(address account) public onlyOwner {
987         require(!_isExcluded[account], "Account is already excluded");
988         require(_excluded.length + 1 <= 50, "Cannot exclude more than 50 accounts.  Include a previously excluded address.");
989         if (_rOwned[account] > 0) {
990             _tOwned[account] = tokenFromReflection(_rOwned[account]);
991         }
992         _isExcluded[account] = true;
993         _excluded.push(account);
994     }
995 
996     function includeInReward(address account) public onlyOwner {
997         require(_isExcluded[account], "Account is not excluded");
998         for (uint256 i = 0; i < _excluded.length; i++) {
999             if (_excluded[i] == account) {
1000                 _excluded[i] = _excluded[_excluded.length - 1];
1001                 _tOwned[account] = 0;
1002                 _isExcluded[account] = false;
1003                 _excluded.pop();
1004                 break;
1005             }
1006         }
1007     }
1008  
1009     function _approve(
1010         address owner,
1011         address spender,
1012         uint256 amount
1013     ) private {
1014         require(owner != address(0), "ERC20: approve from the zero address");
1015         require(spender != address(0), "ERC20: approve to the zero address");
1016 
1017         _allowances[owner][spender] = amount;
1018         emit Approval(owner, spender, amount);
1019     }
1020 
1021     function _transfer(
1022         address from,
1023         address to,
1024         uint256 amount
1025     ) private {
1026         require(from != address(0), "ERC20: transfer from the zero address");
1027         require(to != address(0), "ERC20: transfer to the zero address");
1028         require(amount > 0, "Transfer amount must be greater than zero");
1029         
1030         if(!tradingActive){
1031             require(_isExcludedFromFee[from] || _isExcludedFromFee[to], "Trading is not active yet.");
1032         }
1033         
1034         
1035         
1036         if(limitsInEffect){
1037             if (
1038                 from != owner() &&
1039                 to != owner() &&
1040                 to != address(0) &&
1041                 to != address(0xdead) &&
1042                 !inSwapAndLiquify
1043             ){
1044                 
1045                 if(from != owner() && to != uniswapV2Pair && block.number == tradingActiveBlock){
1046                     boughtEarly[to] = true;
1047                     emit BoughtEarly(to);
1048                 }
1049                 
1050                 // only use to prevent sniper buys in the first blocks.
1051                 if (gasLimitActive && automatedMarketMakerPairs[from]) {
1052                     require(tx.gasprice <= gasPriceLimit, "Gas price exceeds limit.");
1053                 }
1054                 
1055                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1056                 if (transferDelayEnabled){
1057                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1058                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1059                         _holderLastTransferTimestamp[tx.origin] = block.number;
1060                     }
1061                 }
1062                 
1063                 //when buy
1064                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1065                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1066                 } 
1067                 //when sell
1068                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1069                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1070                 }
1071             }
1072         }
1073 
1074         // airdrop limits
1075 
1076         if(airDropLimitInEffect){ // Check if Limit is in effect
1077             if(airDropLimitLiftDate <= block.timestamp){
1078                 airDropLimitInEffect = false;  // set the limit to false if the limit date has been exceeded
1079             } else {
1080                 uint256 senderBalance = balanceOf(from); // get total token balance of sender
1081                 if(_isAirdoppedWallet[from] && senderBalance.sub(amount) < _airDropTokensRemaining[from]){
1082                     
1083                     require(_airDropAddressNextSellDate[from] <= block.timestamp && block.timestamp >= airDropLimitLiftDate.sub(9 days), "_transfer:: White List Wallet cannot sell whitelist tokens until next sell date.  Please read the contract for your next sale date.");
1084                     uint256 airDropMaxSell = getWalletMaxAirdropSell(from); // airdrop 10% max sell of total airdropped tokens per day for 10 days
1085                     
1086                     // a bit of strange math here.  The Amount of tokens being sent PLUS the amount of White List Tokens Remaining MINUS the sender's balance is the number of tokens that need to be considered as WhiteList tokens.
1087                     // the check a few lines up ensures no subtraction overflows so it can never be a negative value.
1088 
1089                     uint256 tokensToSubtract = amount.add(_airDropTokensRemaining[from]).sub(senderBalance);
1090 
1091                     require(tokensToSubtract <= airDropMaxSell, "_transfer:: May not sell more than 10% of White List tokens in a single day until the White List Limit is lifted.");
1092                     _airDropTokensRemaining[from] = _airDropTokensRemaining[from].sub(tokensToSubtract);
1093                     _airDropAddressNextSellDate[from] = block.timestamp + (1 days * (tokensToSubtract.mul(100).div(airDropMaxSell)))/100; // Only push out timer as a % of the transfer, so 5% could be sold in 1% chunks over the course of a day, for example.
1094                 }
1095             }
1096         }
1097         
1098         
1099         
1100         uint256 totalTokensToSwap = _liquidityTokensToSwap.add(_marketingTokensToSwap);
1101         uint256 contractTokenBalance = balanceOf(address(this));
1102         bool overMinimumTokenBalance = contractTokenBalance >= minimumTokensBeforeSwap;
1103 
1104         // swap and liquify
1105         if (
1106             !inSwapAndLiquify &&
1107             swapAndLiquifyEnabled &&
1108             balanceOf(uniswapV2Pair) > 0 &&
1109             totalTokensToSwap > 0 &&
1110             !_isExcludedFromFee[to] &&
1111             !_isExcludedFromFee[from] &&
1112             automatedMarketMakerPairs[to] &&
1113             overMinimumTokenBalance
1114         ) {
1115             swapBack();
1116         }
1117 
1118         bool takeFee = true;
1119 
1120         // If any account belongs to _isExcludedFromFee account then remove the fee
1121         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
1122             takeFee = false;
1123             buyOrSellSwitch = TRANSFER; // TRANSFERs do not pay a tax.
1124         } else {
1125             // Buy
1126             if (automatedMarketMakerPairs[from]) {
1127                 removeAllFee();
1128                 _taxFee = _buyTaxFee;
1129                 _liquidityFee = _buyLiquidityFee + _buyMarketingFee + _buyCharityFee;
1130                 buyOrSellSwitch = BUY;
1131             } 
1132             // Sell
1133             else if (automatedMarketMakerPairs[to]) {
1134                 removeAllFee();
1135                 _taxFee = _sellTaxFee;
1136                 _liquidityFee = _sellLiquidityFee + _sellMarketingFee + _sellCharityFee;
1137                 buyOrSellSwitch = SELL;
1138                 // higher tax if bought in the same block as trading active for 72 hours (sniper protect)
1139                 if(boughtEarly[from] && earlyBuyPenaltyEnd > block.timestamp){
1140                     _taxFee = _taxFee * 5;
1141                     _liquidityFee = _liquidityFee * 5;
1142                 }
1143             // Normal transfers do not get taxed
1144             } else {
1145                 require(!boughtEarly[from] || earlyBuyPenaltyEnd <= block.timestamp, "Snipers can't transfer tokens to sell cheaper until penalty timeframe is over.  DM a Mod.");
1146                 removeAllFee();
1147                 buyOrSellSwitch = TRANSFER; // TRANSFERs do not pay a tax.
1148             }
1149         }
1150         
1151         _tokenTransfer(from, to, amount, takeFee);
1152         
1153     }
1154 
1155     function swapBack() private lockTheSwap {
1156         uint256 contractBalance = balanceOf(address(this));
1157         uint256 totalTokensToSwap = _liquidityTokensToSwap + _marketingTokensToSwap;
1158         
1159         // Halve the amount of liquidity tokens
1160         uint256 tokensForLiquidity = _liquidityTokensToSwap.div(2);
1161         uint256 amountToSwapForETH = contractBalance.sub(tokensForLiquidity);
1162         
1163         uint256 initialETHBalance = address(this).balance;
1164 
1165         swapTokensForETH(amountToSwapForETH); 
1166         
1167         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1168         
1169         uint256 ethForMarketing = ethBalance.mul(_marketingTokensToSwap).div(totalTokensToSwap);
1170         
1171         uint256 ethForLiquidity = ethBalance.sub(ethForMarketing);
1172         
1173         uint256 ethForDev= ethForMarketing * 2 / 5;
1174         ethForMarketing -= ethForDev;
1175         
1176         _liquidityTokensToSwap = 0;
1177         _marketingTokensToSwap = 0;
1178         
1179         (bool success,) = address(marketingAddress).call{value: ethForMarketing}("");
1180         (success,) = address(devAddress).call{value: ethForDev}("");
1181         
1182         addLiquidity(tokensForLiquidity, ethForLiquidity);
1183         emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1184         
1185         // send leftover BNB to the marketing wallet so it doesn't get stuck on the contract.
1186         if(address(this).balance > 1e17){
1187             (success,) = address(marketingAddress).call{value: address(this).balance}("");
1188         }
1189     }
1190     
1191     // force Swap back if slippage above 49% for launch.
1192     function forceSwapBack() external onlyOwner {
1193         uint256 contractBalance = balanceOf(address(this));
1194         require(contractBalance >= _tTotal / 100, "Can only swap back if more than 1% of tokens stuck on contract");
1195         swapBack();
1196         emit OwnerForcedSwapBack(block.timestamp);
1197     }
1198     
1199     function swapTokensForETH(uint256 tokenAmount) private {
1200         address[] memory path = new address[](2);
1201         path[0] = address(this);
1202         path[1] = uniswapV2Router.WETH();
1203         _approve(address(this), address(uniswapV2Router), tokenAmount);
1204         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1205             tokenAmount,
1206             0, // accept any amount of ETH
1207             path,
1208             address(this),
1209             block.timestamp
1210         );
1211     }
1212     
1213     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1214         _approve(address(this), address(uniswapV2Router), tokenAmount);
1215         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1216             address(this),
1217             tokenAmount,
1218             0, // slippage is unavoidable
1219             0, // slippage is unavoidable
1220             liquidityAddress,
1221             block.timestamp
1222         );
1223     }
1224 
1225     function _tokenTransfer(
1226         address sender,
1227         address recipient,
1228         uint256 amount,
1229         bool takeFee
1230     ) private {
1231         if (!takeFee) removeAllFee();
1232 
1233         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1234             _transferFromExcluded(sender, recipient, amount);
1235         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1236             _transferToExcluded(sender, recipient, amount);
1237         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1238             _transferBothExcluded(sender, recipient, amount);
1239         } else {
1240             _transferStandard(sender, recipient, amount);
1241         }
1242 
1243         restoreAllFee();
1244     }
1245 
1246     function _transferStandard(
1247         address sender,
1248         address recipient,
1249         uint256 tAmount
1250     ) private {
1251         (
1252             uint256 rAmount,
1253             uint256 rTransferAmount,
1254             uint256 rFee,
1255             uint256 tTransferAmount,
1256             uint256 tFee,
1257             uint256 tLiquidity
1258         ) = _getValues(tAmount);
1259         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1260         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1261         _takeLiquidity(tLiquidity);
1262         _reflectFee(rFee, tFee);
1263         emit Transfer(sender, recipient, tTransferAmount);
1264     }
1265 
1266     function _transferToExcluded(
1267         address sender,
1268         address recipient,
1269         uint256 tAmount
1270     ) private {
1271         (
1272             uint256 rAmount,
1273             uint256 rTransferAmount,
1274             uint256 rFee,
1275             uint256 tTransferAmount,
1276             uint256 tFee,
1277             uint256 tLiquidity
1278         ) = _getValues(tAmount);
1279         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1280         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1281         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1282         _takeLiquidity(tLiquidity);
1283         _reflectFee(rFee, tFee);
1284         emit Transfer(sender, recipient, tTransferAmount);
1285     }
1286 
1287     function _transferFromExcluded(
1288         address sender,
1289         address recipient,
1290         uint256 tAmount
1291     ) private {
1292         (
1293             uint256 rAmount,
1294             uint256 rTransferAmount,
1295             uint256 rFee,
1296             uint256 tTransferAmount,
1297             uint256 tFee,
1298             uint256 tLiquidity
1299         ) = _getValues(tAmount);
1300         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1301         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1302         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1303         _takeLiquidity(tLiquidity);
1304         _reflectFee(rFee, tFee);
1305         emit Transfer(sender, recipient, tTransferAmount);
1306     }
1307 
1308     function _transferBothExcluded(
1309         address sender,
1310         address recipient,
1311         uint256 tAmount
1312     ) private {
1313         (
1314             uint256 rAmount,
1315             uint256 rTransferAmount,
1316             uint256 rFee,
1317             uint256 tTransferAmount,
1318             uint256 tFee,
1319             uint256 tLiquidity
1320         ) = _getValues(tAmount);
1321         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1322         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1323         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1324         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1325         _takeLiquidity(tLiquidity);
1326         _reflectFee(rFee, tFee);
1327         emit Transfer(sender, recipient, tTransferAmount);
1328     }
1329 
1330     function _reflectFee(uint256 rFee, uint256 tFee) private {
1331         _rTotal = _rTotal.sub(rFee);
1332         _tFeeTotal = _tFeeTotal.add(tFee);
1333     }
1334 
1335     function _getValues(uint256 tAmount)
1336         private
1337         view
1338         returns (
1339             uint256,
1340             uint256,
1341             uint256,
1342             uint256,
1343             uint256,
1344             uint256
1345         )
1346     {
1347         (
1348             uint256 tTransferAmount,
1349             uint256 tFee,
1350             uint256 tLiquidity
1351         ) = _getTValues(tAmount);
1352         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
1353             tAmount,
1354             tFee,
1355             tLiquidity,
1356             _getRate()
1357         );
1358         return (
1359             rAmount,
1360             rTransferAmount,
1361             rFee,
1362             tTransferAmount,
1363             tFee,
1364             tLiquidity
1365         );
1366     }
1367 
1368     function _getTValues(uint256 tAmount)
1369         private
1370         view
1371         returns (
1372             uint256,
1373             uint256,
1374             uint256
1375         )
1376     {
1377         uint256 tFee = calculateTaxFee(tAmount);
1378         uint256 tLiquidity = calculateLiquidityFee(tAmount);
1379         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
1380         return (tTransferAmount, tFee, tLiquidity);
1381     }
1382 
1383     function _getRValues(
1384         uint256 tAmount,
1385         uint256 tFee,
1386         uint256 tLiquidity,
1387         uint256 currentRate
1388     )
1389         private
1390         pure
1391         returns (
1392             uint256,
1393             uint256,
1394             uint256
1395         )
1396     {
1397         uint256 rAmount = tAmount.mul(currentRate);
1398         uint256 rFee = tFee.mul(currentRate);
1399         uint256 rLiquidity = tLiquidity.mul(currentRate);
1400         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
1401         return (rAmount, rTransferAmount, rFee);
1402     }
1403 
1404     function _getRate() private view returns (uint256) {
1405         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1406         return rSupply.div(tSupply);
1407     }
1408 
1409     function _getCurrentSupply() private view returns (uint256, uint256) {
1410         uint256 rSupply = _rTotal;
1411         uint256 tSupply = _tTotal;
1412         for (uint256 i = 0; i < _excluded.length; i++) {
1413             if (
1414                 _rOwned[_excluded[i]] > rSupply ||
1415                 _tOwned[_excluded[i]] > tSupply
1416             ) return (_rTotal, _tTotal);
1417             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1418             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1419         }
1420         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1421         return (rSupply, tSupply);
1422     }
1423 
1424     function _takeLiquidity(uint256 tLiquidity) private {
1425         if(buyOrSellSwitch == BUY){
1426             _liquidityTokensToSwap += tLiquidity * _buyLiquidityFee / _liquidityFee;
1427             _marketingTokensToSwap += tLiquidity * _buyMarketingFee / _liquidityFee;
1428             _charityTokensToSwap += tLiquidity * _buyCharityFee / _liquidityFee;
1429         } else if(buyOrSellSwitch == SELL){
1430             _liquidityTokensToSwap += tLiquidity * _sellLiquidityFee / _liquidityFee;
1431             _marketingTokensToSwap += tLiquidity * _sellMarketingFee / _liquidityFee;
1432             _charityTokensToSwap += tLiquidity * _sellCharityFee / _liquidityFee;
1433         }
1434         uint256 currentRate = _getRate();
1435         uint256 rLiquidity = tLiquidity.mul(currentRate);
1436         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1437         if (_isExcluded[address(this)])
1438             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1439     }
1440 
1441     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1442         return _amount.mul(_taxFee).div(10**2);
1443     }
1444 
1445     function calculateLiquidityFee(uint256 _amount)
1446         private
1447         view
1448         returns (uint256)
1449     {
1450         return _amount.mul(_liquidityFee).div(10**2);
1451     }
1452 
1453     function removeAllFee() private {
1454         if (_taxFee == 0 && _liquidityFee == 0) return;
1455 
1456         _previousTaxFee = _taxFee;
1457         _previousLiquidityFee = _liquidityFee;
1458 
1459         _taxFee = 0;
1460         _liquidityFee = 0;
1461     }
1462 
1463     function restoreAllFee() private {
1464         _taxFee = _previousTaxFee;
1465         _liquidityFee = _previousLiquidityFee;
1466     }
1467 
1468     function isExcludedFromFee(address account) external view returns (bool) {
1469         return _isExcludedFromFee[account];
1470     }
1471     
1472      function removeBoughtEarly(address account) external onlyOwner {
1473         boughtEarly[account] = false;
1474         emit RemovedSniper(account);
1475     }
1476 
1477     function excludeFromFee(address account) external onlyOwner {
1478         _isExcludedFromFee[account] = true;
1479         emit ExcludeFromFee(account);
1480     }
1481 
1482     function includeInFee(address account) external onlyOwner {
1483         _isExcludedFromFee[account] = false;
1484         emit IncludeInFee(account);
1485     }
1486 
1487     function setBuyFee(uint256 buyTaxFee, uint256 buyLiquidityFee, uint256 buyMarketingFee, uint256 buyCharityFee)
1488         external
1489         onlyOwner
1490     {
1491         _buyTaxFee = buyTaxFee;
1492         _buyLiquidityFee = buyLiquidityFee;
1493         _buyMarketingFee = buyMarketingFee;
1494         _buyCharityFee = buyCharityFee;
1495         require(_buyTaxFee + _buyLiquidityFee + _buyMarketingFee + _buyCharityFee <= 10, "Must keep buy taxes below 10%");
1496         emit SetBuyFee(buyMarketingFee, buyLiquidityFee, buyTaxFee);
1497     }
1498 
1499     function setSellFee(uint256 sellTaxFee, uint256 sellLiquidityFee, uint256 sellMarketingFee, uint256 sellCharityFee)
1500         external
1501         onlyOwner
1502     {
1503         _sellTaxFee = sellTaxFee;
1504         _sellLiquidityFee = sellLiquidityFee;
1505         _sellMarketingFee = sellMarketingFee;
1506         _sellCharityFee = sellCharityFee;
1507         require(_sellTaxFee + _sellLiquidityFee + _sellMarketingFee + _sellCharityFee <= 15, "Must keep sell taxes below 15%");
1508         emit SetSellFee(sellMarketingFee, sellLiquidityFee, sellTaxFee);
1509     }
1510     
1511     function setMarketingAddress(address _marketingAddress) external onlyOwner {
1512         require(_marketingAddress != address(0), "_marketingAddress address cannot be 0");
1513         _isExcludedFromFee[marketingAddress] = false;
1514         marketingAddress = payable(_marketingAddress);
1515         _isExcludedFromFee[marketingAddress] = true;
1516         emit UpdatedMarketingAddress(_marketingAddress);
1517     }
1518     
1519     function setLiquidityAddress(address _liquidityAddress) public onlyOwner {
1520         require(_liquidityAddress != address(0), "_liquidityAddress address cannot be 0");
1521         liquidityAddress = payable(_liquidityAddress);
1522         _isExcludedFromFee[liquidityAddress] = true;
1523         emit UpdatedLiquidityAddress(_liquidityAddress);
1524     }
1525     
1526     function setCharityAddress(address _charityAddress) public onlyOwner {
1527         require(_charityAddress != address(0), "_liquidityAddress address cannot be 0");
1528         charityAddress = payable(_charityAddress);
1529         emit UpdatedCharityAddress(_charityAddress);
1530     }
1531     
1532     function setDevAddress(address _devAddress) public onlyOwner {
1533         require(_devAddress != address(0), "_liquidityAddress address cannot be 0");
1534         devAddress = payable(_devAddress);
1535         emit UpdatedDevAddress(_devAddress);
1536     }
1537 
1538     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1539         swapAndLiquifyEnabled = _enabled;
1540         emit SwapAndLiquifyEnabledUpdated(_enabled);
1541     }
1542 
1543     // To receive ETH from uniswapV2Router when swapping
1544     receive() external payable {}
1545 
1546     function transferForeignToken(address _token, address _to)
1547         external
1548         onlyOwner
1549         returns (bool _sent)
1550     {
1551         require(_token != address(0), "_token address cannot be 0");
1552         require(_token != address(this), "Can't withdraw native tokens");
1553         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
1554         _sent = IERC20(_token).transfer(_to, _contractBalance);
1555         emit TransferForeignToken(_token, _contractBalance);
1556     }
1557     
1558     // withdraw ETH if stuck before launch
1559     function withdrawStuckETH() external onlyOwner {
1560         require(!tradingActive, "Can only withdraw if trading hasn't started");
1561         bool success;
1562         (success,) = address(msg.sender).call{value: address(this).balance}("");
1563     }
1564 }