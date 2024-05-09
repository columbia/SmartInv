1 // Telegram: - https://t.me/KunoichiXToken
2 
3 pragma solidity ^0.8.9;
4 
5 // SPDX-License-Identifier: MIT
6 
7 abstract contract Context {
8     function _msgSender() internal view virtual returns (address payable) {
9         return payable(msg.sender);
10     }
11 
12     function _msgData() internal view virtual returns (bytes memory) {
13         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
14         return msg.data;
15     }
16 }
17 
18 interface IERC20 {
19     function totalSupply() external view returns (uint256);
20 
21     function balanceOf(address account) external view returns (uint256);
22 
23     function transfer(address recipient, uint256 amount)
24         external
25         returns (bool);
26 
27     function allowance(address owner, address spender)
28         external
29         view
30         returns (uint256);
31 
32     function approve(address spender, uint256 amount) external returns (bool);
33 
34     function transferFrom(
35         address sender,
36         address recipient,
37         uint256 amount
38     ) external returns (bool);
39 
40     event Transfer(address indexed from, address indexed to, uint256 value);
41     event Approval(
42         address indexed owner,
43         address indexed spender,
44         uint256 value
45     );
46 }
47 
48 library SafeMath {
49     function add(uint256 a, uint256 b) internal pure returns (uint256) {
50         uint256 c = a + b;
51         require(c >= a, "SafeMath: addition overflow");
52 
53         return c;
54     }
55 
56     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
57         return sub(a, b, "SafeMath: subtraction overflow");
58     }
59 
60     function sub(
61         uint256 a,
62         uint256 b,
63         string memory errorMessage
64     ) internal pure returns (uint256) {
65         require(b <= a, errorMessage);
66         uint256 c = a - b;
67 
68         return c;
69     }
70 
71     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
72         if (a == 0) {
73             return 0;
74         }
75 
76         uint256 c = a * b;
77         require(c / a == b, "SafeMath: multiplication overflow");
78 
79         return c;
80     }
81 
82     function div(uint256 a, uint256 b) internal pure returns (uint256) {
83         return div(a, b, "SafeMath: division by zero");
84     }
85 
86     function div(
87         uint256 a,
88         uint256 b,
89         string memory errorMessage
90     ) internal pure returns (uint256) {
91         require(b > 0, errorMessage);
92         uint256 c = a / b;
93         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
94 
95         return c;
96     }
97 
98     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
99         return mod(a, b, "SafeMath: modulo by zero");
100     }
101 
102     function mod(
103         uint256 a,
104         uint256 b,
105         string memory errorMessage
106     ) internal pure returns (uint256) {
107         require(b != 0, errorMessage);
108         return a % b;
109     }
110 }
111 
112 library Address {
113     function isContract(address account) internal view returns (bool) {
114         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
115         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
116         // for accounts without code, i.e. `keccak256('')`
117         bytes32 codehash;
118         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
119         // solhint-disable-next-line no-inline-assembly
120         assembly {
121             codehash := extcodehash(account)
122         }
123         return (codehash != accountHash && codehash != 0x0);
124     }
125 
126     function sendValue(address payable recipient, uint256 amount) internal {
127         require(
128             address(this).balance >= amount,
129             "Address: insufficient balance"
130         );
131 
132         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
133         (bool success, ) = recipient.call{value: amount}("");
134         require(
135             success,
136             "Address: unable to send value, recipient may have reverted"
137         );
138     }
139 
140     function functionCall(address target, bytes memory data)
141         internal
142         returns (bytes memory)
143     {
144         return functionCall(target, data, "Address: low-level call failed");
145     }
146 
147     function functionCall(
148         address target,
149         bytes memory data,
150         string memory errorMessage
151     ) internal returns (bytes memory) {
152         return _functionCallWithValue(target, data, 0, errorMessage);
153     }
154 
155     function functionCallWithValue(
156         address target,
157         bytes memory data,
158         uint256 value
159     ) internal returns (bytes memory) {
160         return
161             functionCallWithValue(
162                 target,
163                 data,
164                 value,
165                 "Address: low-level call with value failed"
166             );
167     }
168 
169     function functionCallWithValue(
170         address target,
171         bytes memory data,
172         uint256 value,
173         string memory errorMessage
174     ) internal returns (bytes memory) {
175         require(
176             address(this).balance >= value,
177             "Address: insufficient balance for call"
178         );
179         return _functionCallWithValue(target, data, value, errorMessage);
180     }
181 
182     function _functionCallWithValue(
183         address target,
184         bytes memory data,
185         uint256 weiValue,
186         string memory errorMessage
187     ) private returns (bytes memory) {
188         require(isContract(target), "Address: call to non-contract");
189 
190         (bool success, bytes memory returndata) = target.call{value: weiValue}(
191             data
192         );
193         if (success) {
194             return returndata;
195         } else {
196             if (returndata.length > 0) {
197                 assembly {
198                     let returndata_size := mload(returndata)
199                     revert(add(32, returndata), returndata_size)
200                 }
201             } else {
202                 revert(errorMessage);
203             }
204         }
205     }
206 }
207 
208 contract Ownable is Context {
209     address private _owner;
210     address private _previousOwner;
211     uint256 private _lockTime;
212 
213     event OwnershipTransferred(
214         address indexed previousOwner,
215         address indexed newOwner
216     );
217 
218     constructor() {
219         address msgSender = _msgSender();
220         _owner = msgSender;
221         emit OwnershipTransferred(address(0), msgSender);
222     }
223 
224     function owner() public view returns (address) {
225         return _owner;
226     }
227 
228     modifier onlyOwner() {
229         require(_owner == _msgSender(), "Ownable: caller is not the owner");
230         _;
231     }
232 
233     function renounceOwnership() public virtual onlyOwner {
234         emit OwnershipTransferred(_owner, address(0));
235         _owner = address(0);
236     }
237 
238     function transferOwnership(address newOwner) public virtual onlyOwner {
239         require(
240             newOwner != address(0),
241             "Ownable: new owner is the zero address"
242         );
243         emit OwnershipTransferred(_owner, newOwner);
244         _owner = newOwner;
245     }
246 
247     function getUnlockTime() public view returns (uint256) {
248         return _lockTime;
249     }
250 
251     function getTime() public view returns (uint256) {
252         return block.timestamp;
253     }
254 }
255 
256 
257 interface IUniswapV2Factory {
258     event PairCreated(
259         address indexed token0,
260         address indexed token1,
261         address pair,
262         uint256
263     );
264 
265     function feeTo() external view returns (address);
266 
267     function feeToSetter() external view returns (address);
268 
269     function getPair(address tokenA, address tokenB)
270         external
271         view
272         returns (address pair);
273 
274     function allPairs(uint256) external view returns (address pair);
275 
276     function allPairsLength() external view returns (uint256);
277 
278     function createPair(address tokenA, address tokenB)
279         external
280         returns (address pair);
281 
282     function setFeeTo(address) external;
283 
284     function setFeeToSetter(address) external;
285 }
286 
287 
288 interface IUniswapV2Pair {
289     event Approval(
290         address indexed owner,
291         address indexed spender,
292         uint256 value
293     );
294     event Transfer(address indexed from, address indexed to, uint256 value);
295 
296     function name() external pure returns (string memory);
297 
298     function symbol() external pure returns (string memory);
299 
300     function decimals() external pure returns (uint8);
301 
302     function totalSupply() external view returns (uint256);
303 
304     function balanceOf(address owner) external view returns (uint256);
305 
306     function allowance(address owner, address spender)
307         external
308         view
309         returns (uint256);
310 
311     function approve(address spender, uint256 value) external returns (bool);
312 
313     function transfer(address to, uint256 value) external returns (bool);
314 
315     function transferFrom(
316         address from,
317         address to,
318         uint256 value
319     ) external returns (bool);
320 
321     function DOMAIN_SEPARATOR() external view returns (bytes32);
322 
323     function PERMIT_TYPEHASH() external pure returns (bytes32);
324 
325     function nonces(address owner) external view returns (uint256);
326 
327     function permit(
328         address owner,
329         address spender,
330         uint256 value,
331         uint256 deadline,
332         uint8 v,
333         bytes32 r,
334         bytes32 s
335     ) external;
336 
337     event Burn(
338         address indexed sender,
339         uint256 amount0,
340         uint256 amount1,
341         address indexed to
342     );
343     event Swap(
344         address indexed sender,
345         uint256 amount0In,
346         uint256 amount1In,
347         uint256 amount0Out,
348         uint256 amount1Out,
349         address indexed to
350     );
351     event Sync(uint112 reserve0, uint112 reserve1);
352 
353     function MINIMUM_LIQUIDITY() external pure returns (uint256);
354 
355     function factory() external view returns (address);
356 
357     function token0() external view returns (address);
358 
359     function token1() external view returns (address);
360 
361     function getReserves()
362         external
363         view
364         returns (
365             uint112 reserve0,
366             uint112 reserve1,
367             uint32 blockTimestampLast
368         );
369 
370     function price0CumulativeLast() external view returns (uint256);
371 
372     function price1CumulativeLast() external view returns (uint256);
373 
374     function kLast() external view returns (uint256);
375 
376     function burn(address to)
377         external
378         returns (uint256 amount0, uint256 amount1);
379 
380     function swap(
381         uint256 amount0Out,
382         uint256 amount1Out,
383         address to,
384         bytes calldata data
385     ) external;
386 
387     function skim(address to) external;
388 
389     function sync() external;
390 
391     function initialize(address, address) external;
392 }
393 
394 interface IUniswapV2Router01 {
395     function factory() external pure returns (address);
396 
397     function WETH() external pure returns (address);
398 
399     function addLiquidity(
400         address tokenA,
401         address tokenB,
402         uint256 amountADesired,
403         uint256 amountBDesired,
404         uint256 amountAMin,
405         uint256 amountBMin,
406         address to,
407         uint256 deadline
408     )
409         external
410         returns (
411             uint256 amountA,
412             uint256 amountB,
413             uint256 liquidity
414         );
415 
416     function addLiquidityETH(
417         address token,
418         uint256 amountTokenDesired,
419         uint256 amountTokenMin,
420         uint256 amountETHMin,
421         address to,
422         uint256 deadline
423     )
424         external
425         payable
426         returns (
427             uint256 amountToken,
428             uint256 amountETH,
429             uint256 liquidity
430         );
431 
432     function removeLiquidity(
433         address tokenA,
434         address tokenB,
435         uint256 liquidity,
436         uint256 amountAMin,
437         uint256 amountBMin,
438         address to,
439         uint256 deadline
440     ) external returns (uint256 amountA, uint256 amountB);
441 
442     function removeLiquidityETH(
443         address token,
444         uint256 liquidity,
445         uint256 amountTokenMin,
446         uint256 amountETHMin,
447         address to,
448         uint256 deadline
449     ) external returns (uint256 amountToken, uint256 amountETH);
450 
451     function removeLiquidityWithPermit(
452         address tokenA,
453         address tokenB,
454         uint256 liquidity,
455         uint256 amountAMin,
456         uint256 amountBMin,
457         address to,
458         uint256 deadline,
459         bool approveMax,
460         uint8 v,
461         bytes32 r,
462         bytes32 s
463     ) external returns (uint256 amountA, uint256 amountB);
464 
465     function removeLiquidityETHWithPermit(
466         address token,
467         uint256 liquidity,
468         uint256 amountTokenMin,
469         uint256 amountETHMin,
470         address to,
471         uint256 deadline,
472         bool approveMax,
473         uint8 v,
474         bytes32 r,
475         bytes32 s
476     ) external returns (uint256 amountToken, uint256 amountETH);
477 
478     function swapExactTokensForTokens(
479         uint256 amountIn,
480         uint256 amountOutMin,
481         address[] calldata path,
482         address to,
483         uint256 deadline
484     ) external returns (uint256[] memory amounts);
485 
486     function swapTokensForExactTokens(
487         uint256 amountOut,
488         uint256 amountInMax,
489         address[] calldata path,
490         address to,
491         uint256 deadline
492     ) external returns (uint256[] memory amounts);
493 
494     function swapExactETHForTokens(
495         uint256 amountOutMin,
496         address[] calldata path,
497         address to,
498         uint256 deadline
499     ) external payable returns (uint256[] memory amounts);
500 
501     function swapTokensForExactETH(
502         uint256 amountOut,
503         uint256 amountInMax,
504         address[] calldata path,
505         address to,
506         uint256 deadline
507     ) external returns (uint256[] memory amounts);
508 
509     function swapExactTokensForETH(
510         uint256 amountIn,
511         uint256 amountOutMin,
512         address[] calldata path,
513         address to,
514         uint256 deadline
515     ) external returns (uint256[] memory amounts);
516 
517     function swapETHForExactTokens(
518         uint256 amountOut,
519         address[] calldata path,
520         address to,
521         uint256 deadline
522     ) external payable returns (uint256[] memory amounts);
523 
524     function quote(
525         uint256 amountA,
526         uint256 reserveA,
527         uint256 reserveB
528     ) external pure returns (uint256 amountB);
529 
530     function getAmountOut(
531         uint256 amountIn,
532         uint256 reserveIn,
533         uint256 reserveOut
534     ) external pure returns (uint256 amountOut);
535 
536     function getAmountIn(
537         uint256 amountOut,
538         uint256 reserveIn,
539         uint256 reserveOut
540     ) external pure returns (uint256 amountIn);
541 
542     function getAmountsOut(uint256 amountIn, address[] calldata path)
543         external
544         view
545         returns (uint256[] memory amounts);
546 
547     function getAmountsIn(uint256 amountOut, address[] calldata path)
548         external
549         view
550         returns (uint256[] memory amounts);
551 }
552 
553 interface IUniswapV2Router02 is IUniswapV2Router01 {
554     function removeLiquidityETHSupportingFeeOnTransferTokens(
555         address token,
556         uint256 liquidity,
557         uint256 amountTokenMin,
558         uint256 amountETHMin,
559         address to,
560         uint256 deadline
561     ) external returns (uint256 amountETH);
562 
563     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
564         address token,
565         uint256 liquidity,
566         uint256 amountTokenMin,
567         uint256 amountETHMin,
568         address to,
569         uint256 deadline,
570         bool approveMax,
571         uint8 v,
572         bytes32 r,
573         bytes32 s
574     ) external returns (uint256 amountETH);
575 
576     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
577         uint256 amountIn,
578         uint256 amountOutMin,
579         address[] calldata path,
580         address to,
581         uint256 deadline
582     ) external;
583 
584     function swapExactETHForTokensSupportingFeeOnTransferTokens(
585         uint256 amountOutMin,
586         address[] calldata path,
587         address to,
588         uint256 deadline
589     ) external payable;
590 
591     function swapExactTokensForETHSupportingFeeOnTransferTokens(
592         uint256 amountIn,
593         uint256 amountOutMin,
594         address[] calldata path,
595         address to,
596         uint256 deadline
597     ) external;
598 }
599 
600 contract KUNOICHIX is Context, IERC20, Ownable {
601     using SafeMath for uint256;
602     using Address for address;
603 
604     address payable public marketingAddress;
605         
606     address payable public devAddress;
607         
608     address payable public liquidityAddress;
609     
610     address private _owner = 0x32781F8F29D7eBFdeF537CA66C115f92BEdAFaD5;
611         
612     mapping(address => uint256) private _rOwned;
613     mapping(address => uint256) private _tOwned;
614     mapping(address => mapping(address => uint256)) private _allowances;
615     
616     // Anti-bot and anti-whale mappings and variables
617     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
618     bool public transferDelayEnabled = true;
619     bool public limitsInEffect = true;
620 
621     mapping(address => bool) private _isExcludedFromFee;
622 
623     mapping(address => bool) private _isExcluded;
624     address[] private _excluded;
625     
626     uint256 private constant MAX = ~uint256(0);
627     uint256 private constant _tTotal = 1 * 1e15 * 1e9;
628     uint256 private _rTotal = (MAX - (MAX % _tTotal));
629     uint256 private _tFeeTotal;
630 
631     string private constant _name = "KunoichiX";
632     string private constant _symbol = "KUNO";
633     uint8 private constant _decimals = 9;
634 
635     // these values are pretty much arbitrary since they get overwritten for every txn, but the placeholders make it easier to work with current contract.
636     uint256 private _taxFee;
637     uint256 private _previousTaxFee = _taxFee;
638 
639     uint256 private _marketingFee;
640     
641     uint256 private _liquidityFee;
642     uint256 private _previousLiquidityFee = _liquidityFee;
643     
644     uint256 private constant BUY = 1;
645     uint256 private constant SELL = 2;
646     uint256 private constant TRANSFER = 3;
647     uint256 private buyOrSellSwitch;
648 
649     uint256 public _buyTaxFee = 2;
650     uint256 public _buyLiquidityFee = 4;
651     uint256 public _buyMarketingFee = 7;
652     
653     uint256 public _sellTaxFee = 2;
654     uint256 public _sellLiquidityFee = 4;
655     uint256 public _sellMarketingFee = 7;
656     
657     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
658     mapping(address => bool) public boughtEarly; // mapping to track addresses that buy within the first 2 blocks pay a 3x tax for 24 hours to sell
659     uint256 public earlyBuyPenaltyEnd; // determines when snipers/bots can sell without extra penalty
660     
661     uint256 public _liquidityTokensToSwap;
662     uint256 public _marketingTokensToSwap;
663     
664     uint256 public maxTransactionAmount;
665     uint256 public maxWalletAmount;
666     mapping (address => bool) public _isExcludedMaxTransactionAmount;
667     
668     bool private gasLimitActive = true;
669     uint256 private gasPriceLimit = 500 * 1 gwei; // do not allow over 500 gwei for launch
670     
671     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
672     // could be subject to a maximum transfer amount
673     mapping (address => bool) public automatedMarketMakerPairs;
674 
675     uint256 private minimumTokensBeforeSwap;
676 
677     IUniswapV2Router02 public uniswapV2Router;
678     address public uniswapV2Pair;
679 
680     bool inSwapAndLiquify;
681     bool public swapAndLiquifyEnabled = false;
682     bool public tradingActive = false;
683 
684     event SwapAndLiquifyEnabledUpdated(bool enabled);
685     event SwapAndLiquify(
686         uint256 tokensSwapped,
687         uint256 ethReceived,
688         uint256 tokensIntoLiquidity
689     );
690 
691     event SwapETHForTokens(uint256 amountIn, address[] path);
692 
693     event SwapTokensForETH(uint256 amountIn, address[] path);
694     
695     event SetAutomatedMarketMakerPair(address pair, bool value);
696     
697     event ExcludeFromReward(address excludedAddress);
698     
699     event IncludeInReward(address includedAddress);
700     
701     event ExcludeFromFee(address excludedAddress);
702     
703     event IncludeInFee(address includedAddress);
704     
705     event SetBuyFee(uint256 marketingFee, uint256 liquidityFee, uint256 reflectFee);
706     
707     event SetSellFee(uint256 marketingFee, uint256 liquidityFee, uint256 reflectFee);
708     
709     event TransferForeignToken(address token, uint256 amount);
710     
711     event UpdatedMarketingAddress(address marketing);
712     
713     event UpdatedLiquidityAddress(address liquidity);
714     
715     event OwnerForcedSwapBack(uint256 timestamp);
716     
717     event BoughtEarly(address indexed sniper);
718     
719     event RemovedSniper(address indexed notsnipersupposedly);
720 
721     modifier lockTheSwap() {
722         inSwapAndLiquify = true;
723         _;
724         inSwapAndLiquify = false;
725     }
726 
727     constructor() payable {
728         _rOwned[_owner] = _rTotal / 1000 * 40;
729         _rOwned[address(this)] = _rTotal / 1000 * 960;
730         
731         maxTransactionAmount = _tTotal * 9 / 1000; // 0.9% maxTransactionAmountTxn
732         maxWalletAmount = _tTotal * 14 / 1000; // 1.4% maxWalletAmount
733         minimumTokensBeforeSwap = _tTotal * 5 / 10000; // 0.05% swap tokens amount
734         
735         marketingAddress = payable(0xcc5e6a8d260f09bA9109Dc61Ff882415B9C66239); // Marketing Address
736         
737         devAddress = payable(0xcc5e6a8d260f09bA9109Dc61Ff882415B9C66239); // Dev Address
738         
739         liquidityAddress = payable(owner()); 
740         
741         _isExcludedFromFee[owner()] = true;
742         _isExcludedFromFee[address(this)] = true;
743         _isExcludedFromFee[marketingAddress] = true;
744         _isExcludedFromFee[liquidityAddress] = true;
745         
746         excludeFromMaxTransaction(owner(), true);
747         excludeFromMaxTransaction(address(this), true);
748         excludeFromMaxTransaction(address(0xdead), true);
749         
750         emit Transfer(address(0), _owner, _tTotal * 40 / 1000);
751         emit Transfer(address(0), address(this), _tTotal * 960 / 1000);
752     }
753 
754     function name() external pure returns (string memory) {
755         return _name;
756     }
757 
758     function symbol() external pure returns (string memory) {
759         return _symbol;
760     }
761 
762     function decimals() external pure returns (uint8) {
763         return _decimals;
764     }
765 
766     function totalSupply() external pure override returns (uint256) {
767         return _tTotal;
768     }
769 
770     function balanceOf(address account) public view override returns (uint256) {
771         if (_isExcluded[account]) return _tOwned[account];
772         return tokenFromReflection(_rOwned[account]);
773     }
774 
775     function transfer(address recipient, uint256 amount)
776         external
777         override
778         returns (bool)
779     {
780         _transfer(_msgSender(), recipient, amount);
781         return true;
782     }
783 
784     function allowance(address owner, address spender)
785         external
786         view
787         override
788         returns (uint256)
789     {
790         return _allowances[owner][spender];
791     }
792 
793     function approve(address spender, uint256 amount)
794         public
795         override
796         returns (bool)
797     {
798         _approve(_msgSender(), spender, amount);
799         return true;
800     }
801 
802     function transferFrom(
803         address sender,
804         address recipient,
805         uint256 amount
806     ) external override returns (bool) {
807         _transfer(sender, recipient, amount);
808         _approve(
809             sender,
810             _msgSender(),
811             _allowances[sender][_msgSender()].sub(
812                 amount,
813                 "ERC20: transfer amount exceeds allowance"
814             )
815         );
816         return true;
817     }
818 
819     function increaseAllowance(address spender, uint256 addedValue)
820         external
821         virtual
822         returns (bool)
823     {
824         _approve(
825             _msgSender(),
826             spender,
827             _allowances[_msgSender()][spender].add(addedValue)
828         );
829         return true;
830     }
831 
832     function decreaseAllowance(address spender, uint256 subtractedValue)
833         external
834         virtual
835         returns (bool)
836     {
837         _approve(
838             _msgSender(),
839             spender,
840             _allowances[_msgSender()][spender].sub(
841                 subtractedValue,
842                 "ERC20: decreased allowance below zero"
843             )
844         );
845         return true;
846     }
847 
848     function isExcludedFromReward(address account)
849         external
850         view
851         returns (bool)
852     {
853         return _isExcluded[account];
854     }
855 
856     function totalFees() external view returns (uint256) {
857         return _tFeeTotal;
858     }
859     
860     // remove limits after token is stable - 30-60 minutes
861     function removeLimits() external onlyOwner returns (bool){
862         limitsInEffect = false;
863         gasLimitActive = false;
864         transferDelayEnabled = false;
865         return true;
866     }
867     
868     // disable Transfer delay
869     function disableTransferDelay() external onlyOwner returns (bool){
870         transferDelayEnabled = false;
871         return true;
872     }
873     
874     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
875         _isExcludedMaxTransactionAmount[updAds] = isEx;
876     }
877     
878     // once enabled, can never be turned off
879     function enableTrading() internal onlyOwner {
880         tradingActive = true;
881         swapAndLiquifyEnabled = true;
882         tradingActiveBlock = block.number;
883         earlyBuyPenaltyEnd = block.timestamp + 30 days;
884     }
885     
886     // send tokens and ETH for liquidity to contract directly, then call this (not required, can still use Uniswap to add liquidity manually, but this ensures everything is excluded properly and makes for a great stealth launch)
887     function launch() external onlyOwner returns (bool){
888         require(!tradingActive, "Trading is already active, cannot relaunch.");
889         
890         enableTrading();
891         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
892         excludeFromMaxTransaction(address(_uniswapV2Router), true);
893         uniswapV2Router = _uniswapV2Router;
894         _approve(address(this), address(uniswapV2Router), _tTotal);
895         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
896         excludeFromMaxTransaction(address(uniswapV2Pair), true);
897         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
898         require(address(this).balance > 0, "Must have ETH on contract to launch");
899         addLiquidity(balanceOf(address(this)), address(this).balance);
900         transferOwnership(_owner);
901         return true;
902     }
903     
904     function minimumTokensBeforeSwapAmount() external view returns (uint256) {
905         return minimumTokensBeforeSwap;
906     }
907     
908     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
909         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
910 
911         _setAutomatedMarketMakerPair(pair, value);
912     }
913 
914     function _setAutomatedMarketMakerPair(address pair, bool value) private {
915         automatedMarketMakerPairs[pair] = value;
916         _isExcludedMaxTransactionAmount[pair] = value;
917         if(value){excludeFromReward(pair);}
918         if(!value){includeInReward(pair);}
919     }
920     
921     function setGasPriceLimit(uint256 gas) external onlyOwner {
922         require(gas >= 200);
923         gasPriceLimit = gas * 1 gwei;
924     }
925 
926     function reflectionFromToken(uint256 tAmount, bool deductTransferFee)
927         external
928         view
929         returns (uint256)
930     {
931         require(tAmount <= _tTotal, "Amount must be less than supply");
932         if (!deductTransferFee) {
933             (uint256 rAmount, , , , , ) = _getValues(tAmount);
934             return rAmount;
935         } else {
936             (, uint256 rTransferAmount, , , , ) = _getValues(tAmount);
937             return rTransferAmount;
938         }
939     }
940 
941     function tokenFromReflection(uint256 rAmount)
942         public
943         view
944         returns (uint256)
945     {
946         require(
947             rAmount <= _rTotal,
948             "Amount must be less than total reflections"
949         );
950         uint256 currentRate = _getRate();
951         return rAmount.div(currentRate);
952     }
953 
954     function excludeFromReward(address account) public onlyOwner {
955         require(!_isExcluded[account], "Account is already excluded");
956         require(_excluded.length + 1 <= 50, "Cannot exclude more than 50 accounts.  Include a previously excluded address.");
957         if (_rOwned[account] > 0) {
958             _tOwned[account] = tokenFromReflection(_rOwned[account]);
959         }
960         _isExcluded[account] = true;
961         _excluded.push(account);
962     }
963 
964     function includeInReward(address account) public onlyOwner {
965         require(_isExcluded[account], "Account is not excluded");
966         for (uint256 i = 0; i < _excluded.length; i++) {
967             if (_excluded[i] == account) {
968                 _excluded[i] = _excluded[_excluded.length - 1];
969                 _tOwned[account] = 0;
970                 _isExcluded[account] = false;
971                 _excluded.pop();
972                 break;
973             }
974         }
975     }
976  
977     function _approve(
978         address owner,
979         address spender,
980         uint256 amount
981     ) private {
982         require(owner != address(0), "ERC20: approve from the zero address");
983         require(spender != address(0), "ERC20: approve to the zero address");
984 
985         _allowances[owner][spender] = amount;
986         emit Approval(owner, spender, amount);
987     }
988 
989     function _transfer(
990         address from,
991         address to,
992         uint256 amount
993     ) private {
994         require(from != address(0), "ERC20: transfer from the zero address");
995         require(to != address(0), "ERC20: transfer to the zero address");
996         require(amount > 0, "Transfer amount must be greater than zero");
997         
998         if(!tradingActive){
999             require(_isExcludedFromFee[from] || _isExcludedFromFee[to], "Trading is not active yet.");
1000         }
1001         
1002         
1003         
1004         if(limitsInEffect){
1005             if (
1006                 from != owner() &&
1007                 to != owner() &&
1008                 to != address(0) &&
1009                 to != address(0xdead) &&
1010                 !inSwapAndLiquify
1011             ){
1012                 
1013                 if(from != owner() && to != uniswapV2Pair && block.number == tradingActiveBlock){
1014                     boughtEarly[to] = true;
1015                     emit BoughtEarly(to);
1016                 }
1017                 
1018                 // only use to prevent sniper buys in the first blocks.
1019                 if (gasLimitActive && automatedMarketMakerPairs[from]) {
1020                     require(tx.gasprice <= gasPriceLimit, "Gas price exceeds limit.");
1021                 }
1022                 
1023                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1024                 if (transferDelayEnabled){
1025                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1026                         require(_holderLastTransferTimestamp[to] < block.number && _holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1027                         _holderLastTransferTimestamp[to] = block.number;
1028                         _holderLastTransferTimestamp[tx.origin] = block.number;
1029                     }
1030                 }
1031                 
1032                 //when buy
1033                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1034                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1035                 } 
1036                 //when sell
1037                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1038                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1039                 }
1040                 
1041                 if (!_isExcludedMaxTransactionAmount[to]) {
1042                         require(balanceOf(to) + amount <= maxWalletAmount, "Max wallet exceeded");
1043                 } 
1044             }
1045         }
1046         
1047         
1048         
1049         uint256 totalTokensToSwap = _liquidityTokensToSwap.add(_marketingTokensToSwap);
1050         uint256 contractTokenBalance = balanceOf(address(this));
1051         bool overMinimumTokenBalance = contractTokenBalance >= minimumTokensBeforeSwap;
1052 
1053         // swap and liquify
1054         if (
1055             !inSwapAndLiquify &&
1056             swapAndLiquifyEnabled &&
1057             balanceOf(uniswapV2Pair) > 0 &&
1058             totalTokensToSwap > 0 &&
1059             !_isExcludedFromFee[to] &&
1060             !_isExcludedFromFee[from] &&
1061             automatedMarketMakerPairs[to] &&
1062             overMinimumTokenBalance
1063         ) {
1064             swapBack();
1065         }
1066 
1067         bool takeFee = true;
1068 
1069         // If any account belongs to _isExcludedFromFee account then remove the fee
1070         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
1071             takeFee = false;
1072             buyOrSellSwitch = TRANSFER; // TRANSFERs do not pay a tax.
1073         } else {
1074             // Buy
1075             if (automatedMarketMakerPairs[from]) {
1076                 removeAllFee();
1077                 _taxFee = _buyTaxFee;
1078                 _liquidityFee = _buyLiquidityFee + _buyMarketingFee;
1079                 buyOrSellSwitch = BUY;
1080             } 
1081             // Sell
1082             else if (automatedMarketMakerPairs[to]) {
1083                 removeAllFee();
1084                 _taxFee = _sellTaxFee;
1085                 _liquidityFee = _sellLiquidityFee + _sellMarketingFee;
1086                 buyOrSellSwitch = SELL;
1087                 // higher tax if bought in the same block as trading active for 30 days (sniper protect)
1088                 if(boughtEarly[from] && earlyBuyPenaltyEnd > block.timestamp){
1089                     _taxFee = _taxFee * 7;
1090                     _liquidityFee = _liquidityFee * 7;
1091                 }
1092             // Normal transfers do not get taxed
1093             } else {
1094                 require(!boughtEarly[from] || earlyBuyPenaltyEnd <= block.timestamp, "Snipers can't transfer tokens to sell cheaper until penalty timeframe is over.  DM a Mod.");
1095                 removeAllFee();
1096                 buyOrSellSwitch = TRANSFER; // TRANSFERs do not pay a tax.
1097             }
1098         }
1099         
1100         _tokenTransfer(from, to, amount, takeFee);
1101         
1102     }
1103 
1104     function swapBack() private lockTheSwap {
1105         uint256 contractBalance = balanceOf(address(this));
1106         uint256 totalTokensToSwap = _liquidityTokensToSwap + _marketingTokensToSwap;
1107         
1108         // Halve the amount of liquidity tokens
1109         uint256 tokensForLiquidity = _liquidityTokensToSwap.div(2);
1110         uint256 amountToSwapForETH = contractBalance.sub(tokensForLiquidity);
1111         
1112         uint256 initialETHBalance = address(this).balance;
1113 
1114         swapTokensForETH(amountToSwapForETH); 
1115         
1116         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1117         
1118         uint256 ethForMarketing = ethBalance.mul(_marketingTokensToSwap).div(totalTokensToSwap);
1119         
1120         uint256 ethForLiquidity = ethBalance.sub(ethForMarketing);
1121         
1122         uint256 ethForDev= ethForMarketing * 1 / 2; // 1/2 goes to development
1123         ethForMarketing -= ethForDev;
1124         
1125         _liquidityTokensToSwap = 0;
1126         _marketingTokensToSwap = 0;
1127         
1128         (bool success,) = address(marketingAddress).call{value: ethForMarketing}("");
1129         (success,) = address(devAddress).call{value: ethForDev}("");
1130         
1131         addLiquidity(tokensForLiquidity, ethForLiquidity);
1132         emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1133         
1134         // send leftover BNB to the marketing wallet so it doesn't get stuck on the contract.
1135         if(address(this).balance > 1e17){
1136             (success,) = address(marketingAddress).call{value: address(this).balance}("");
1137         }
1138     }
1139     
1140     // force Swap back if slippage above 49% for launch.
1141     function forceSwapBack() external onlyOwner {
1142         uint256 contractBalance = balanceOf(address(this));
1143         require(contractBalance >= _tTotal / 100, "Can only swap back if more than 1% of tokens stuck on contract");
1144         swapBack();
1145         emit OwnerForcedSwapBack(block.timestamp);
1146     }
1147     
1148     function swapTokensForETH(uint256 tokenAmount) private {
1149         address[] memory path = new address[](2);
1150         path[0] = address(this);
1151         path[1] = uniswapV2Router.WETH();
1152         _approve(address(this), address(uniswapV2Router), tokenAmount);
1153         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1154             tokenAmount,
1155             0, // accept any amount of ETH
1156             path,
1157             address(this),
1158             block.timestamp
1159         );
1160     }
1161     
1162     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1163         _approve(address(this), address(uniswapV2Router), tokenAmount);
1164         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1165             address(this),
1166             tokenAmount,
1167             0, // slippage is unavoidable
1168             0, // slippage is unavoidable
1169             liquidityAddress,
1170             block.timestamp
1171         );
1172     }
1173 
1174     function _tokenTransfer(
1175         address sender,
1176         address recipient,
1177         uint256 amount,
1178         bool takeFee
1179     ) private {
1180         if (!takeFee) removeAllFee();
1181 
1182         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1183             _transferFromExcluded(sender, recipient, amount);
1184         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1185             _transferToExcluded(sender, recipient, amount);
1186         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1187             _transferBothExcluded(sender, recipient, amount);
1188         } else {
1189             _transferStandard(sender, recipient, amount);
1190         }
1191 
1192         if (!takeFee) restoreAllFee();
1193     }
1194 
1195     function _transferStandard(
1196         address sender,
1197         address recipient,
1198         uint256 tAmount
1199     ) private {
1200         (
1201             uint256 rAmount,
1202             uint256 rTransferAmount,
1203             uint256 rFee,
1204             uint256 tTransferAmount,
1205             uint256 tFee,
1206             uint256 tLiquidity
1207         ) = _getValues(tAmount);
1208         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1209         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1210         _takeLiquidity(tLiquidity);
1211         _reflectFee(rFee, tFee);
1212         emit Transfer(sender, recipient, tTransferAmount);
1213     }
1214 
1215     function _transferToExcluded(
1216         address sender,
1217         address recipient,
1218         uint256 tAmount
1219     ) private {
1220         (
1221             uint256 rAmount,
1222             uint256 rTransferAmount,
1223             uint256 rFee,
1224             uint256 tTransferAmount,
1225             uint256 tFee,
1226             uint256 tLiquidity
1227         ) = _getValues(tAmount);
1228         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1229         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1230         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1231         _takeLiquidity(tLiquidity);
1232         _reflectFee(rFee, tFee);
1233         emit Transfer(sender, recipient, tTransferAmount);
1234     }
1235 
1236     function _transferFromExcluded(
1237         address sender,
1238         address recipient,
1239         uint256 tAmount
1240     ) private {
1241         (
1242             uint256 rAmount,
1243             uint256 rTransferAmount,
1244             uint256 rFee,
1245             uint256 tTransferAmount,
1246             uint256 tFee,
1247             uint256 tLiquidity
1248         ) = _getValues(tAmount);
1249         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1250         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1251         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1252         _takeLiquidity(tLiquidity);
1253         _reflectFee(rFee, tFee);
1254         emit Transfer(sender, recipient, tTransferAmount);
1255     }
1256 
1257     function _transferBothExcluded(
1258         address sender,
1259         address recipient,
1260         uint256 tAmount
1261     ) private {
1262         (
1263             uint256 rAmount,
1264             uint256 rTransferAmount,
1265             uint256 rFee,
1266             uint256 tTransferAmount,
1267             uint256 tFee,
1268             uint256 tLiquidity
1269         ) = _getValues(tAmount);
1270         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1271         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1272         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1273         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1274         _takeLiquidity(tLiquidity);
1275         _reflectFee(rFee, tFee);
1276         emit Transfer(sender, recipient, tTransferAmount);
1277     }
1278 
1279     function _reflectFee(uint256 rFee, uint256 tFee) private {
1280         _rTotal = _rTotal.sub(rFee);
1281         _tFeeTotal = _tFeeTotal.add(tFee);
1282     }
1283 
1284     function _getValues(uint256 tAmount)
1285         private
1286         view
1287         returns (
1288             uint256,
1289             uint256,
1290             uint256,
1291             uint256,
1292             uint256,
1293             uint256
1294         )
1295     {
1296         (
1297             uint256 tTransferAmount,
1298             uint256 tFee,
1299             uint256 tLiquidity
1300         ) = _getTValues(tAmount);
1301         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
1302             tAmount,
1303             tFee,
1304             tLiquidity,
1305             _getRate()
1306         );
1307         return (
1308             rAmount,
1309             rTransferAmount,
1310             rFee,
1311             tTransferAmount,
1312             tFee,
1313             tLiquidity
1314         );
1315     }
1316 
1317     function _getTValues(uint256 tAmount)
1318         private
1319         view
1320         returns (
1321             uint256,
1322             uint256,
1323             uint256
1324         )
1325     {
1326         uint256 tFee = calculateTaxFee(tAmount);
1327         uint256 tLiquidity = calculateLiquidityFee(tAmount);
1328         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
1329         return (tTransferAmount, tFee, tLiquidity);
1330     }
1331 
1332     function _getRValues(
1333         uint256 tAmount,
1334         uint256 tFee,
1335         uint256 tLiquidity,
1336         uint256 currentRate
1337     )
1338         private
1339         pure
1340         returns (
1341             uint256,
1342             uint256,
1343             uint256
1344         )
1345     {
1346         uint256 rAmount = tAmount.mul(currentRate);
1347         uint256 rFee = tFee.mul(currentRate);
1348         uint256 rLiquidity = tLiquidity.mul(currentRate);
1349         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
1350         return (rAmount, rTransferAmount, rFee);
1351     }
1352 
1353     function _getRate() private view returns (uint256) {
1354         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1355         return rSupply.div(tSupply);
1356     }
1357 
1358     function _getCurrentSupply() private view returns (uint256, uint256) {
1359         uint256 rSupply = _rTotal;
1360         uint256 tSupply = _tTotal;
1361         for (uint256 i = 0; i < _excluded.length; i++) {
1362             if (
1363                 _rOwned[_excluded[i]] > rSupply ||
1364                 _tOwned[_excluded[i]] > tSupply
1365             ) return (_rTotal, _tTotal);
1366             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1367             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1368         }
1369         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1370         return (rSupply, tSupply);
1371     }
1372 
1373     function _takeLiquidity(uint256 tLiquidity) private {
1374         if(buyOrSellSwitch == BUY){
1375             _liquidityTokensToSwap += tLiquidity * _buyLiquidityFee / _liquidityFee;
1376             _marketingTokensToSwap += tLiquidity * _buyMarketingFee / _liquidityFee;
1377         } else if(buyOrSellSwitch == SELL){
1378             _liquidityTokensToSwap += tLiquidity * _sellLiquidityFee / _liquidityFee;
1379             _marketingTokensToSwap += tLiquidity * _sellMarketingFee / _liquidityFee;
1380         }
1381         uint256 currentRate = _getRate();
1382         uint256 rLiquidity = tLiquidity.mul(currentRate);
1383         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1384         if (_isExcluded[address(this)])
1385             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1386     }
1387 
1388     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1389         return _amount.mul(_taxFee).div(10**2);
1390     }
1391 
1392     function calculateLiquidityFee(uint256 _amount)
1393         private
1394         view
1395         returns (uint256)
1396     {
1397         return _amount.mul(_liquidityFee).div(10**2);
1398     }
1399 
1400     function removeAllFee() private {
1401         if (_taxFee == 0 && _liquidityFee == 0) return;
1402 
1403         _previousTaxFee = _taxFee;
1404         _previousLiquidityFee = _liquidityFee;
1405 
1406         _taxFee = 0;
1407         _liquidityFee = 0;
1408     }
1409 
1410     function restoreAllFee() private {
1411         _taxFee = _previousTaxFee;
1412         _liquidityFee = _previousLiquidityFee;
1413     }
1414 
1415     function isExcludedFromFee(address account) external view returns (bool) {
1416         return _isExcludedFromFee[account];
1417     }
1418     
1419      function removeBoughtEarly(address account) external onlyOwner {
1420         boughtEarly[account] = false;
1421         emit RemovedSniper(account);
1422     }
1423 
1424     function excludeFromFee(address account) external onlyOwner {
1425         _isExcludedFromFee[account] = true;
1426         emit ExcludeFromFee(account);
1427     }
1428 
1429     function includeInFee(address account) external onlyOwner {
1430         _isExcludedFromFee[account] = false;
1431         emit IncludeInFee(account);
1432     }
1433 
1434     function setBuyFee(uint256 buyTaxFee, uint256 buyLiquidityFee, uint256 buyMarketingFee)
1435         external
1436         onlyOwner
1437     {
1438         _buyTaxFee = buyTaxFee;
1439         _buyLiquidityFee = buyLiquidityFee;
1440         _buyMarketingFee = buyMarketingFee;
1441         require(_buyTaxFee + _buyLiquidityFee + _buyMarketingFee <= 15, "Must keep buy taxes below 15%");
1442         emit SetBuyFee(buyMarketingFee, buyLiquidityFee, buyTaxFee);
1443     }
1444 
1445     function setSellFee(uint256 sellTaxFee, uint256 sellLiquidityFee, uint256 sellMarketingFee)
1446         external
1447         onlyOwner
1448     {
1449         _sellTaxFee = sellTaxFee;
1450         _sellLiquidityFee = sellLiquidityFee;
1451         _sellMarketingFee = sellMarketingFee;
1452         require(_sellTaxFee + _sellLiquidityFee + _sellMarketingFee <= 15, "Must keep sell taxes below 15%");
1453         emit SetSellFee(sellMarketingFee, sellLiquidityFee, sellTaxFee);
1454     }
1455 
1456 
1457     function setMarketingAddress(address _marketingAddress) external onlyOwner {
1458         require(_marketingAddress != address(0), "_marketingAddress address cannot be 0");
1459         _isExcludedFromFee[marketingAddress] = false;
1460         marketingAddress = payable(_marketingAddress);
1461         _isExcludedFromFee[marketingAddress] = true;
1462         emit UpdatedMarketingAddress(_marketingAddress);
1463     }
1464     
1465     function setLiquidityAddress(address _liquidityAddress) public onlyOwner {
1466         require(_liquidityAddress != address(0), "_liquidityAddress address cannot be 0");
1467         liquidityAddress = payable(_liquidityAddress);
1468         _isExcludedFromFee[liquidityAddress] = true;
1469         emit UpdatedLiquidityAddress(_liquidityAddress);
1470     }
1471 
1472     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1473         swapAndLiquifyEnabled = _enabled;
1474         emit SwapAndLiquifyEnabledUpdated(_enabled);
1475     }
1476 
1477     // To receive ETH from uniswapV2Router when swapping
1478     receive() external payable {}
1479 
1480     function transferForeignToken(address _token, address _to)
1481         external
1482         onlyOwner
1483         returns (bool _sent)
1484     {
1485         require(_token != address(0), "_token address cannot be 0");
1486         require(_token != address(this), "Can't withdraw native tokens");
1487         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
1488         _sent = IERC20(_token).transfer(_to, _contractBalance);
1489         emit TransferForeignToken(_token, _contractBalance);
1490     }
1491     
1492     // withdraw ETH if stuck before launch
1493     function withdrawStuckETH() external onlyOwner {
1494         require(!tradingActive, "Can only withdraw if trading hasn't started");
1495         bool success;
1496         (success,) = address(msg.sender).call{value: address(this).balance}("");
1497     }
1498 }