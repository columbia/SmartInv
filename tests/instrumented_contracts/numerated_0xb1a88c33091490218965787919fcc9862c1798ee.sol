1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.9;
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
598 contract StudioShibli is Context, IERC20, Ownable {
599     using SafeMath for uint256;
600     using Address for address;
601 
602     address payable public marketingAddress = payable(0xcF31195B2C7d618A79962438f00D6D2D726A9950); // Marketing Address
603 
604     address payable public liquidityAddress =
605         payable(0x000000000000000000000000000000000000dEaD); // Liquidity Address
606         
607     address payable public gameAddress =
608         payable(0x29EA5d401615de6eB6321D802EAE4206922FCa79); // Game payout Address
609         
610     address payable public devAddress =
611         payable(0x6358731710985DF37b7a2976a447e41B00FD196C); // Development Address
612 
613         
614     mapping(address => uint256) private _rOwned;
615     mapping(address => uint256) private _tOwned;
616     mapping(address => mapping(address => uint256)) private _allowances;
617 
618     mapping(address => bool) private _isExcludedFromFee;
619 
620     mapping(address => bool) private _isExcluded;
621     address[] private _excluded;
622     
623     uint256 private constant MAX = ~uint256(0);
624     uint256 private constant _tTotal = 1 * 1e15 * 1e9;
625     uint256 private _rTotal = (MAX - (MAX % _tTotal));
626     uint256 private _tFeeTotal;
627 
628     string private constant _name = "Studio Shibli";
629     string private constant _symbol = "SHIBLI";
630     uint8 private constant _decimals = 9;
631     
632     uint256 private constant BUY = 1;
633     uint256 private constant SELL = 2;
634     uint256 private constant TRANSFER = 3;
635     uint256 private buyOrSellSwitch;
636 
637     // these values are pretty much arbitrary since they get overwritten for every txn, but the placeholders make it easier to work with current contract.
638     uint256 private _taxFee;
639     uint256 private _previousTaxFee = _taxFee;
640 
641     uint256 private _liquidityFee;
642     uint256 private _previousLiquidityFee = _liquidityFee;
643 
644     uint256 public _buyTaxFee = 2;
645     uint256 public _buyLiquidityFee = 1;
646     uint256 public _buyMarketingFee = 4;
647     uint256 public _buyDevFee = 2;
648     uint256 public _buyGameFee = 1;
649 
650     uint256 public _sellTaxFee = 1;
651     uint256 public _sellLiquidityFee = 2;
652     uint256 public _sellMarketingFee = 5;
653     uint256 public _sellDevFee = 2;
654     uint256 public _sellGameFee = 1;
655     
656     uint256 public liquidityActiveBlock = 0; // 0 means liquidity is not active yet
657     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
658     mapping(address => bool) public boughtEarly;
659     uint256 public earlyBuyPenaltyEnd; // determines when snipers/bots can sell without extra penalty
660     
661     bool public limitsInEffect = true;
662     bool public tradingActive = false;
663     bool public swapEnabled = false;
664     
665     mapping (address => bool) public _isExcludedMaxTransactionAmount;
666     
667      // Anti-bot and anti-whale mappings and variables
668     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
669     bool public transferDelayEnabled = true;
670     
671     uint256 private _liquidityTokensToSwap;
672     uint256 private _marketingTokensToSwap;
673     uint256 private _devTokensToSwap;
674     uint256 private _gameTokensToSwap;
675     
676     bool private gasLimitActive = true;
677     uint256 private gasPriceLimit = 550 * 1 gwei;
678 
679     // airdrop limits to prevent airdrop dump to protect new investors
680     mapping(address => uint256) public _airDropAddressNextSellDate;
681     mapping(address => uint256) public _airDropTokensRemaining;
682     uint256 public airDropLimitLiftDate;
683     bool public airDropLimitInEffect;
684     mapping (address => bool) public _isAirdoppedWallet;
685     mapping (address => uint256) public _airDroppedTokenAmount;
686     uint256 public airDropDailySellPerc;
687     
688     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
689     // could be subject to a maximum transfer amount
690     mapping (address => bool) public automatedMarketMakerPairs;
691 
692     uint256 public minimumTokensBeforeSwap = _tTotal * 5 / 10000; // 0.05%
693     uint256 public maxTransactionAmount;
694 
695     IUniswapV2Router02 public uniswapV2Router;
696     address public uniswapV2Pair;
697 
698     bool inSwapAndLiquify;
699     bool public swapAndLiquifyEnabled = false;
700 
701     event SwapAndLiquifyEnabledUpdated(bool enabled);
702     event SwapAndLiquify(
703         uint256 tokensSwapped,
704         uint256 ethReceived,
705         uint256 tokensIntoLiqudity
706     );
707 
708     event SwapETHForTokens(uint256 amountIn, address[] path);
709 
710     event SwapTokensForETH(uint256 amountIn, address[] path);
711     
712     event ExcludedMaxTransactionAmount(address indexed account, bool isExcluded);
713 
714     modifier lockTheSwap() {
715         inSwapAndLiquify = true;
716         _;
717         inSwapAndLiquify = false;
718     }
719 
720     constructor() payable {
721         address newOwner = msg.sender;
722 
723         airDropLimitLiftDate = block.timestamp + 10 days;
724         airDropLimitInEffect = true;
725         airDropDailySellPerc = 10;
726         
727         maxTransactionAmount = _tTotal * 25 / 10000; // .25% max txn
728         
729         _rOwned[newOwner] = _rTotal;
730 
731         _isExcludedFromFee[newOwner] = true;
732         _isExcludedFromFee[address(this)] = true;
733         _isExcludedFromFee[marketingAddress] = true;
734         _isExcludedFromFee[liquidityAddress] = true;
735         
736         excludeFromMaxTransaction(newOwner, true);
737         excludeFromMaxTransaction(address(this), true);
738         excludeFromMaxTransaction(address(0xdead), true);
739         
740         emit Transfer(address(0), newOwner, _tTotal);
741     }
742 
743     function name() external pure returns (string memory) {
744         return _name;
745     }
746 
747     function symbol() external pure returns (string memory) {
748         return _symbol;
749     }
750 
751     function decimals() external pure returns (uint8) {
752         return _decimals;
753     }
754 
755     function totalSupply() external pure override returns (uint256) {
756         return _tTotal;
757     }
758 
759     function balanceOf(address account) public view override returns (uint256) {
760         if (_isExcluded[account]) return _tOwned[account];
761         return tokenFromReflection(_rOwned[account]);
762     }
763 
764     function transfer(address recipient, uint256 amount)
765         external
766         override
767         returns (bool)
768     {
769         _transfer(_msgSender(), recipient, amount);
770         return true;
771     }
772 
773     function allowance(address owner, address spender)
774         external
775         view
776         override
777         returns (uint256)
778     {
779         return _allowances[owner][spender];
780     }
781 
782     function approve(address spender, uint256 amount)
783         public
784         override
785         returns (bool)
786     {
787         _approve(_msgSender(), spender, amount);
788         return true;
789     }
790 
791     function transferFrom(
792         address sender,
793         address recipient,
794         uint256 amount
795     ) external override returns (bool) {
796         _transfer(sender, recipient, amount);
797         _approve(
798             sender,
799             _msgSender(),
800             _allowances[sender][_msgSender()].sub(
801                 amount,
802                 "ERC20: transfer amount exceeds allowance"
803             )
804         );
805         return true;
806     }
807 
808     function increaseAllowance(address spender, uint256 addedValue)
809         external
810         virtual
811         returns (bool)
812     {
813         _approve(
814             _msgSender(),
815             spender,
816             _allowances[_msgSender()][spender].add(addedValue)
817         );
818         return true;
819     }
820 
821     function decreaseAllowance(address spender, uint256 subtractedValue)
822         external
823         virtual
824         returns (bool)
825     {
826         _approve(
827             _msgSender(),
828             spender,
829             _allowances[_msgSender()][spender].sub(
830                 subtractedValue,
831                 "ERC20: decreased allowance below zero"
832             )
833         );
834         return true;
835     }
836 
837     function isExcludedFromReward(address account)
838         external
839         view
840         returns (bool)
841     {
842         return _isExcluded[account];
843     }
844 
845     function totalFees() external view returns (uint256) {
846         return _tFeeTotal;
847     }
848     
849     // once enabled, can never be turned off
850     function enableTrading() public onlyOwner {
851         tradingActive = true;
852         swapAndLiquifyEnabled = true;
853         tradingActiveBlock = block.number;
854     }
855 
856     // only use if there is an issue with Airdrop feature, should be ok though!
857     function removeAirdropLimit() external onlyOwner{
858         airDropLimitInEffect = false;
859     }
860     
861     function minimumTokensBeforeSwapAmount() external view returns (uint256) {
862         return minimumTokensBeforeSwap;
863     }
864     
865     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
866         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
867 
868         _setAutomatedMarketMakerPair(pair, value);
869     }
870 
871     function _setAutomatedMarketMakerPair(address pair, bool value) private {
872         automatedMarketMakerPairs[pair] = value;
873         
874         excludeFromMaxTransaction(pair, value);
875         if(value){excludeFromReward(pair);}
876         if(!value){includeInReward(pair);}
877     }
878     
879     function setProtectionSettings(bool antiGas) external onlyOwner() {
880         gasLimitActive = antiGas;
881     }
882     
883     function setGasPriceLimit(uint256 gas) external onlyOwner {
884         require(gas >= 300);
885         gasPriceLimit = gas * 1 gwei;
886     }
887     
888     // disable Transfer delay
889     function disableTransferDelay() external onlyOwner returns (bool){
890         transferDelayEnabled = false;
891         return true;
892     }
893 
894     function reflectionFromToken(uint256 tAmount, bool deductTransferFee)
895         external
896         view
897         returns (uint256)
898     {
899         require(tAmount <= _tTotal, "Amount must be less than supply");
900         if (!deductTransferFee) {
901             (uint256 rAmount, , , , , ) = _getValues(tAmount);
902             return rAmount;
903         } else {
904             (, uint256 rTransferAmount, , , , ) = _getValues(tAmount);
905             return rTransferAmount;
906         }
907     }
908     
909     // for one-time airdrop feature after contract launch
910     function airdropToWallets(address[] memory airdropWallets, uint256[] memory amount) external onlyOwner() {
911         require(airdropWallets.length == amount.length, "airdropToWallets:: Arrays must be the same length");
912         removeAllFee();
913         buyOrSellSwitch = TRANSFER;
914         for(uint256 i = 0; i < airdropWallets.length; i++){
915             address wallet = airdropWallets[i];
916             uint256 airdropAmount = amount[i];
917             _tokenTransfer(msg.sender, wallet, airdropAmount);
918         }
919         restoreAllFee();
920     }
921     
922     // remove limits after token is stable - 30-60 minutes
923     function removeLimits() external onlyOwner returns (bool){
924         limitsInEffect = false;
925         gasLimitActive = false;
926         transferDelayEnabled = false;
927         return true;
928     }
929 
930     function tokenFromReflection(uint256 rAmount)
931         public
932         view
933         returns (uint256)
934     {
935         require(
936             rAmount <= _rTotal,
937             "Amount must be less than total reflections"
938         );
939         uint256 currentRate = _getRate();
940         return rAmount.div(currentRate);
941     }
942 
943     function excludeFromReward(address account) public onlyOwner {
944         require(!_isExcluded[account], "Account is already excluded");
945         require(_excluded.length + 1 <= 50, "Cannot exclude more than 50 accounts.  Include a previously excluded address.");
946         if (_rOwned[account] > 0) {
947             _tOwned[account] = tokenFromReflection(_rOwned[account]);
948         }
949         _isExcluded[account] = true;
950         _excluded.push(account);
951     }
952     
953     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
954         _isExcludedMaxTransactionAmount[updAds] = isEx;
955         emit ExcludedMaxTransactionAmount(updAds, isEx);
956     }
957 
958     function includeInReward(address account) public onlyOwner {
959         require(_isExcluded[account], "Account is not excluded");
960         for (uint256 i = 0; i < _excluded.length; i++) {
961             if (_excluded[i] == account) {
962                 _excluded[i] = _excluded[_excluded.length - 1];
963                 _tOwned[account] = 0;
964                 _isExcluded[account] = false;
965                 _excluded.pop();
966                 break;
967             }
968         }
969     }
970  
971     function _approve(
972         address owner,
973         address spender,
974         uint256 amount
975     ) private {
976         require(owner != address(0), "ERC20: approve from the zero address");
977         require(spender != address(0), "ERC20: approve to the zero address");
978 
979         _allowances[owner][spender] = amount;
980         emit Approval(owner, spender, amount);
981     }
982 
983     function _transfer(
984         address from,
985         address to,
986         uint256 amount
987     ) private {
988         require(from != address(0), "ERC20: transfer from the zero address");
989         require(to != address(0), "ERC20: transfer to the zero address");
990         require(amount > 0, "Transfer amount must be greater than zero");
991         
992         if(!tradingActive){
993             require(_isExcludedFromFee[from] || _isExcludedFromFee[to], "Trading is not active yet.");
994         }
995         
996         if(limitsInEffect){
997             if (
998                 from != owner() &&
999                 to != owner() &&
1000                 to != address(0) &&
1001                 to != address(0xdead) &&
1002                 !inSwapAndLiquify
1003             ){
1004                 
1005                 // only use to prevent sniper buys in the first blocks.
1006                 if (gasLimitActive && automatedMarketMakerPairs[from]) {
1007                     require(tx.gasprice <= gasPriceLimit, "Gas price exceeds limit.");
1008                 }
1009                 
1010                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1011                 if (transferDelayEnabled){
1012                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1013                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1014                         _holderLastTransferTimestamp[tx.origin] = block.number;
1015                     }
1016                 }
1017                 
1018                 //when buy
1019                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1020                     require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1021                 } 
1022                 //when sell
1023                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1024                     require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1025                 }
1026             }
1027         }
1028 
1029         // airdrop limits
1030 
1031         if(airDropLimitInEffect){ // Check if Limit is in effect
1032             if(airDropLimitLiftDate <= block.timestamp){
1033                 airDropLimitInEffect = false;  // set the limit to false if the limit date has been exceeded
1034             } else {
1035                 uint256 senderBalance = balanceOf(from); // get total token balance of sender
1036                 if(_isAirdoppedWallet[from] && senderBalance.sub(amount) < _airDropTokensRemaining[from]){
1037                     
1038                     require(_airDropAddressNextSellDate[from] <= block.timestamp, "_transfer:: Please read the contract for your next sale date.");
1039                     uint256 airDropMaxSell = getWalletMaxAirdropSell(from); // airdrop 10% max sell of total airdropped tokens per day for 10 days
1040                     
1041                     // a bit of strange math here.  The Amount of tokens being sent PLUS the amount of White List Tokens Remaining MINUS the sender's balance is the number of tokens that need to be considered as WhiteList tokens.
1042                     // the check a few lines up ensures no subtraction overflows so it can never be a negative value.
1043 
1044                     uint256 tokensToSubtract = amount.add(_airDropTokensRemaining[from]).sub(senderBalance);
1045 
1046                     require(tokensToSubtract <= airDropMaxSell, "_transfer:: May not sell more than allocated tokens in a single day until the Limit is lifted.");
1047                     _airDropTokensRemaining[from] = _airDropTokensRemaining[from].sub(tokensToSubtract);
1048                     _airDropAddressNextSellDate[from] = block.timestamp + (1 days * (tokensToSubtract.mul(100).div(airDropMaxSell)))/100; // Only push out timer as a % of the transfer, so 5% could be sold in 1% chunks over the course of a day, for example.
1049                 }
1050             }
1051         }
1052    
1053         uint256 contractTokenBalance = balanceOf(address(this));
1054         bool overMinimumTokenBalance = contractTokenBalance >=
1055             minimumTokensBeforeSwap;
1056 
1057         // Sell tokens for ETH
1058         if (
1059             !inSwapAndLiquify &&
1060             swapAndLiquifyEnabled &&
1061             balanceOf(uniswapV2Pair) > 0 &&
1062             overMinimumTokenBalance &&
1063             automatedMarketMakerPairs[to]
1064         ) {
1065             swapBack();
1066         }
1067 
1068         removeAllFee();
1069         
1070         buyOrSellSwitch = TRANSFER;
1071         
1072         // If any account belongs to _isExcludedFromFee account then remove the fee
1073         if (!_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
1074             // Buy
1075             if (!automatedMarketMakerPairs[to]) {
1076                 _taxFee = _buyTaxFee;
1077                 _liquidityFee = _buyLiquidityFee + _buyMarketingFee + _buyDevFee + _buyGameFee;
1078                 if(_liquidityFee > 0){
1079                     buyOrSellSwitch = BUY;
1080                 }
1081             } 
1082             // Sell
1083             else {
1084                 _taxFee = _sellTaxFee;
1085                 _liquidityFee = _sellLiquidityFee + _sellMarketingFee + _sellDevFee + _sellGameFee;
1086                 if(_liquidityFee > 0){
1087                     buyOrSellSwitch = SELL;
1088                 }
1089             }
1090         }
1091         
1092         _tokenTransfer(from, to, amount);
1093         
1094         restoreAllFee();
1095         
1096     }
1097 
1098     function swapBack() private lockTheSwap {
1099         uint256 contractBalance = balanceOf(address(this));
1100         bool success;
1101         uint256 totalTokensToSwap = _liquidityTokensToSwap + _devTokensToSwap + _marketingTokensToSwap + _gameTokensToSwap;
1102         if(totalTokensToSwap == 0 || contractBalance == 0) {return;}
1103 
1104         if(contractBalance >= minimumTokensBeforeSwap * 20){
1105             contractBalance = minimumTokensBeforeSwap * 20;
1106         }
1107         
1108         // Halve the amount of liquidity tokens
1109         uint256 tokensForLiquidity = (contractBalance * _liquidityTokensToSwap / totalTokensToSwap) / 2;
1110         uint256 amountToSwapForBNB = contractBalance.sub(tokensForLiquidity);
1111         
1112         uint256 initialBNBBalance = address(this).balance;
1113 
1114         swapTokensForBNB(amountToSwapForBNB); 
1115         
1116         uint256 bnbBalance = address(this).balance.sub(initialBNBBalance);
1117         
1118         uint256 bnbForMarketing = bnbBalance.mul(_marketingTokensToSwap).div(totalTokensToSwap);
1119         
1120         uint256 bnbForGame = bnbBalance.mul(_gameTokensToSwap).div(totalTokensToSwap);
1121         
1122         uint256 bnbForDev = bnbBalance.mul(_devTokensToSwap).div(totalTokensToSwap);
1123         
1124         uint256 bnbForLiquidity = bnbBalance - bnbForMarketing - bnbForGame - bnbForDev;
1125         
1126         _liquidityTokensToSwap = 0;
1127         _marketingTokensToSwap = 0;
1128         _devTokensToSwap = 0;
1129         _gameTokensToSwap = 0;
1130         
1131         (success,) = address(devAddress).call{value: bnbForDev}("");
1132         (success,) = address(gameAddress).call{value: bnbForGame}("");
1133         
1134         if(tokensForLiquidity > 0 && bnbForLiquidity > 0){
1135             addLiquidity(tokensForLiquidity, bnbForLiquidity);
1136             emit SwapAndLiquify(amountToSwapForBNB, bnbForLiquidity, tokensForLiquidity);
1137         }
1138         
1139         // send leftover to marketing
1140         (success,) = address(marketingAddress).call{value: address(this).balance}("");
1141        
1142     }
1143     
1144     function swapTokensForBNB(uint256 tokenAmount) private {
1145         address[] memory path = new address[](2);
1146         path[0] = address(this);
1147         path[1] = uniswapV2Router.WETH();
1148         _approve(address(this), address(uniswapV2Router), tokenAmount);
1149         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1150             tokenAmount,
1151             0, // accept any amount of ETH
1152             path,
1153             address(this),
1154             block.timestamp
1155         );
1156     }
1157     
1158     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1159         _approve(address(this), address(uniswapV2Router), tokenAmount);
1160         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1161             address(this),
1162             tokenAmount,
1163             0, // slippage is unavoidable
1164             0, // slippage is unavoidable
1165             liquidityAddress,
1166             block.timestamp
1167         );
1168     }
1169 
1170     function _tokenTransfer(
1171         address sender,
1172         address recipient,
1173         uint256 amount
1174     ) private {
1175 
1176         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1177             _transferFromExcluded(sender, recipient, amount);
1178         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1179             _transferToExcluded(sender, recipient, amount);
1180         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1181             _transferBothExcluded(sender, recipient, amount);
1182         } else {
1183             _transferStandard(sender, recipient, amount);
1184         }
1185     }
1186 
1187     function _transferStandard(
1188         address sender,
1189         address recipient,
1190         uint256 tAmount
1191     ) private {
1192         (
1193             uint256 rAmount,
1194             uint256 rTransferAmount,
1195             uint256 rFee,
1196             uint256 tTransferAmount,
1197             uint256 tFee,
1198             uint256 tLiquidity
1199         ) = _getValues(tAmount);
1200         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1201         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1202         _takeLiquidity(tLiquidity);
1203         _reflectFee(rFee, tFee);
1204         emit Transfer(sender, recipient, tTransferAmount);
1205     }
1206 
1207     function _transferToExcluded(
1208         address sender,
1209         address recipient,
1210         uint256 tAmount
1211     ) private {
1212         (
1213             uint256 rAmount,
1214             uint256 rTransferAmount,
1215             uint256 rFee,
1216             uint256 tTransferAmount,
1217             uint256 tFee,
1218             uint256 tLiquidity
1219         ) = _getValues(tAmount);
1220         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1221         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1222         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1223         _takeLiquidity(tLiquidity);
1224         _reflectFee(rFee, tFee);
1225         emit Transfer(sender, recipient, tTransferAmount);
1226     }
1227 
1228     function _transferFromExcluded(
1229         address sender,
1230         address recipient,
1231         uint256 tAmount
1232     ) private {
1233         (
1234             uint256 rAmount,
1235             uint256 rTransferAmount,
1236             uint256 rFee,
1237             uint256 tTransferAmount,
1238             uint256 tFee,
1239             uint256 tLiquidity
1240         ) = _getValues(tAmount);
1241         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1242         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1243         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1244         _takeLiquidity(tLiquidity);
1245         _reflectFee(rFee, tFee);
1246         emit Transfer(sender, recipient, tTransferAmount);
1247     }
1248 
1249     function _transferBothExcluded(
1250         address sender,
1251         address recipient,
1252         uint256 tAmount
1253     ) private {
1254         (
1255             uint256 rAmount,
1256             uint256 rTransferAmount,
1257             uint256 rFee,
1258             uint256 tTransferAmount,
1259             uint256 tFee,
1260             uint256 tLiquidity
1261         ) = _getValues(tAmount);
1262         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1263         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1264         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1265         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1266         _takeLiquidity(tLiquidity);
1267         _reflectFee(rFee, tFee);
1268         emit Transfer(sender, recipient, tTransferAmount);
1269     }
1270 
1271     function _reflectFee(uint256 rFee, uint256 tFee) private {
1272         _rTotal = _rTotal.sub(rFee);
1273         _tFeeTotal = _tFeeTotal.add(tFee);
1274     }
1275 
1276     function _getValues(uint256 tAmount)
1277         private
1278         view
1279         returns (
1280             uint256,
1281             uint256,
1282             uint256,
1283             uint256,
1284             uint256,
1285             uint256
1286         )
1287     {
1288         (
1289             uint256 tTransferAmount,
1290             uint256 tFee,
1291             uint256 tLiquidity
1292         ) = _getTValues(tAmount);
1293         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
1294             tAmount,
1295             tFee,
1296             tLiquidity,
1297             _getRate()
1298         );
1299         return (
1300             rAmount,
1301             rTransferAmount,
1302             rFee,
1303             tTransferAmount,
1304             tFee,
1305             tLiquidity
1306         );
1307     }
1308 
1309     function _getTValues(uint256 tAmount)
1310         private
1311         view
1312         returns (
1313             uint256,
1314             uint256,
1315             uint256
1316         )
1317     {
1318         uint256 tFee = calculateTaxFee(tAmount);
1319         uint256 tLiquidity = calculateLiquidityFee(tAmount);
1320         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
1321         return (tTransferAmount, tFee, tLiquidity);
1322     }
1323 
1324     function _getRValues(
1325         uint256 tAmount,
1326         uint256 tFee,
1327         uint256 tLiquidity,
1328         uint256 currentRate
1329     )
1330         private
1331         pure
1332         returns (
1333             uint256,
1334             uint256,
1335             uint256
1336         )
1337     {
1338         uint256 rAmount = tAmount.mul(currentRate);
1339         uint256 rFee = tFee.mul(currentRate);
1340         uint256 rLiquidity = tLiquidity.mul(currentRate);
1341         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
1342         return (rAmount, rTransferAmount, rFee);
1343     }
1344 
1345     function _getRate() private view returns (uint256) {
1346         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1347         return rSupply.div(tSupply);
1348     }
1349 
1350     function _getCurrentSupply() private view returns (uint256, uint256) {
1351         uint256 rSupply = _rTotal;
1352         uint256 tSupply = _tTotal;
1353         for (uint256 i = 0; i < _excluded.length; i++) {
1354             if (
1355                 _rOwned[_excluded[i]] > rSupply ||
1356                 _tOwned[_excluded[i]] > tSupply
1357             ) return (_rTotal, _tTotal);
1358             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1359             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1360         }
1361         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1362         return (rSupply, tSupply);
1363     }
1364 
1365     function _takeLiquidity(uint256 tLiquidity) private {
1366         if(buyOrSellSwitch == BUY){
1367             _liquidityTokensToSwap += tLiquidity * _buyLiquidityFee / _liquidityFee;
1368             _devTokensToSwap += tLiquidity * _buyDevFee / _liquidityFee;
1369             _gameTokensToSwap += tLiquidity * _buyGameFee / _liquidityFee;
1370             _marketingTokensToSwap += tLiquidity * _buyMarketingFee / _liquidityFee;
1371         } else if(buyOrSellSwitch == SELL){
1372             _liquidityTokensToSwap += tLiquidity * _sellLiquidityFee / _liquidityFee;
1373             _devTokensToSwap += tLiquidity * _sellDevFee / _liquidityFee;
1374             _gameTokensToSwap += tLiquidity * _sellGameFee / _liquidityFee;
1375             _marketingTokensToSwap += tLiquidity * _sellMarketingFee / _liquidityFee;
1376         }
1377         uint256 currentRate = _getRate();
1378         uint256 rLiquidity = tLiquidity.mul(currentRate);
1379         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1380         if (_isExcluded[address(this)])
1381             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1382     }
1383 
1384     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1385         return _amount.mul(_taxFee).div(10**2);
1386     }
1387 
1388     function calculateLiquidityFee(uint256 _amount)
1389         private
1390         view
1391         returns (uint256)
1392     {
1393         return _amount.mul(_liquidityFee).div(10**2);
1394     }
1395 
1396     function removeAllFee() private {
1397         if (_taxFee == 0 && _liquidityFee == 0) return;
1398 
1399         _previousTaxFee = _taxFee;
1400         _previousLiquidityFee = _liquidityFee;
1401 
1402         _taxFee = 0;
1403         _liquidityFee = 0;
1404     }
1405 
1406     function restoreAllFee() private {
1407         _taxFee = _previousTaxFee;
1408         _liquidityFee = _previousLiquidityFee;
1409     }
1410 
1411     function isExcludedFromFee(address account) external view returns (bool) {
1412         return _isExcludedFromFee[account];
1413     }
1414 
1415     function excludeFromFee(address account) external onlyOwner {
1416         _isExcludedFromFee[account] = true;
1417     }
1418 
1419     function includeInFee(address account) external onlyOwner {
1420         _isExcludedFromFee[account] = false;
1421     }
1422 
1423     function setBuyFee(uint256 buyTaxFee, uint256 buyLiquidityFee, uint256 buyMarketingFee, uint256 buyDevFee, uint256 buyGameFee)
1424         external
1425         onlyOwner
1426     {
1427         _buyTaxFee = buyTaxFee;
1428         _buyLiquidityFee = buyLiquidityFee;
1429         _buyMarketingFee = buyMarketingFee;
1430         _buyDevFee = buyDevFee;
1431         _buyGameFee = buyGameFee;
1432         require(_buyTaxFee + _buyLiquidityFee + _buyMarketingFee + _buyDevFee + _buyGameFee <= 20, "Must keep taxes below 20%");
1433     }
1434 
1435     function setSellFee(uint256 sellTaxFee, uint256 sellLiquidityFee, uint256 sellMarketingFee, uint256 sellDevFee, uint256 sellGameFee)
1436         external
1437         onlyOwner
1438     {
1439         _sellTaxFee = sellTaxFee;
1440         _sellLiquidityFee = sellLiquidityFee;
1441         _sellMarketingFee = sellMarketingFee;
1442         _sellDevFee = sellDevFee;
1443         _sellGameFee = sellGameFee;
1444         require(_sellTaxFee + _sellLiquidityFee + _sellMarketingFee + _sellDevFee + _sellGameFee <= 30, "Must keep taxes below 30%");
1445     }
1446 
1447     function setMarketingAddress(address _marketingAddress) external onlyOwner {
1448         marketingAddress = payable(_marketingAddress);
1449         _isExcludedFromFee[marketingAddress] = true;
1450     }
1451     
1452     function setLiquidityAddress(address _liquidityAddress) external onlyOwner {
1453         liquidityAddress = payable(_liquidityAddress);
1454         _isExcludedFromFee[liquidityAddress] = true;
1455     }
1456 
1457     function setDevAddress(address _devAddress) external onlyOwner {
1458         devAddress = payable(_devAddress);
1459     }
1460 
1461     function setGameAddress(address _gameAddress) external onlyOwner {
1462         gameAddress = payable(_gameAddress);
1463     }
1464     
1465     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1466         swapAndLiquifyEnabled = _enabled;
1467         emit SwapAndLiquifyEnabledUpdated(_enabled);
1468     }
1469 
1470     // useful for buybacks or to reclaim any BNB on the contract in a way that helps holders.
1471     function buyBackTokens(uint256 bnbAmountInWei) external onlyOwner {
1472         // generate the uniswap pair path of weth -> eth
1473         address[] memory path = new address[](2);
1474         path[0] = uniswapV2Router.WETH();
1475         path[1] = address(this);
1476 
1477         // make the swap
1478         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: bnbAmountInWei}(
1479             0, // accept any amount of Ethereum
1480             path,
1481             address(0xdead),
1482             block.timestamp
1483         );
1484     }
1485 
1486     function getWalletMaxAirdropSell(address holder) public view returns (uint256){
1487         if(airDropLimitInEffect){
1488             return _airDroppedTokenAmount[holder].mul(airDropDailySellPerc).div(100);
1489         }
1490         return _airDropTokensRemaining[holder];
1491     }
1492     
1493     // send tokens and ETH for liquidity to contract directly, then call this (not required, can still use Uniswap to add liquidity manually, but this ensures everything is excluded properly and makes for a great stealth launch)
1494     function launch(address[] memory airdropWallets) external onlyOwner {
1495         require(!tradingActive, "Trading is already active, cannot relaunch.");
1496         require(airdropWallets.length < 200, "Can only airdrop 200 wallets per txn due to gas limits"); // allows for airdrop + launch at the same exact time, reducing delays and reducing sniper input.
1497         
1498         // airdrop all private sale
1499         removeAllFee();
1500         buyOrSellSwitch = TRANSFER;
1501         for(uint256 i = 0; i < airdropWallets.length; i++){
1502             address wallet = airdropWallets[i];
1503             uint256 amount = _tTotal * 5 / 1000; // each wallet gets 0.5%
1504             _isAirdoppedWallet[wallet] = true;
1505             _airDroppedTokenAmount[wallet] = amount;
1506             _airDropTokensRemaining[wallet] = amount;
1507             _airDropAddressNextSellDate[wallet] = block.timestamp.sub(1);
1508             _tokenTransfer(msg.sender, wallet, amount);
1509         }
1510         
1511         // send remainder of tokens to the contract
1512         _tokenTransfer(msg.sender, address(this), balanceOf(msg.sender));
1513                 
1514         // set liquidity pair and router
1515         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
1516         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1517         uniswapV2Router = _uniswapV2Router;
1518         _approve(address(this), address(uniswapV2Router), balanceOf(address(this)));
1519         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
1520         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1521         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1522         
1523         // add liquidity
1524         require(address(this).balance > 0, "Must have ETH on contract to launch");
1525         liquidityAddress = payable(msg.sender); // send initial liquidity to owner to ensure project is functioning before burning / locking LP.
1526         addLiquidity(balanceOf(address(this)), address(this).balance);
1527         
1528         // all new liquidity goes to the dead address
1529         liquidityAddress = payable(address(0xdead));
1530         restoreAllFee();
1531         // enable trading
1532         enableTrading();
1533     }
1534 
1535     // To receive ETH from uniswapV2Router when swapping
1536     receive() external payable {}
1537 
1538     function transferForeignToken(address _token, address _to)
1539         external
1540         onlyOwner
1541         returns (bool _sent)
1542     {
1543         require(_token != address(this), "Can't withdraw native tokens");
1544         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
1545         _sent = IERC20(_token).transfer(_to, _contractBalance);
1546     }
1547 
1548     // withdraw ETH if stuck before launch
1549     function withdrawStuckETH() external onlyOwner {
1550         require(!tradingActive, "Can only withdraw if trading hasn't started");
1551         bool success;
1552         (success,) = address(msg.sender).call{value: address(this).balance}("");
1553     }
1554 }