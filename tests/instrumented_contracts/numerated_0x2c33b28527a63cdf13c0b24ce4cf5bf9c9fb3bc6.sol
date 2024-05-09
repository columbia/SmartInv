1 /**
2  *Submitted for verification at Etherscan.io on 2021-10-29
3 */
4  
5 /*
6 Website: https://schrondinger.com/
7 Telegram: https://t.me/KITTYDINGER
8 Twitter: 
9  
10 */
11 
12 
13 pragma solidity ^0.8.9;
14 
15 // SPDX-License-Identifier: MIT
16 
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address payable) {
19         return payable(msg.sender);
20     }
21 
22     function _msgData() internal view virtual returns (bytes memory) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 interface IERC20 {
29     function totalSupply() external view returns (uint256);
30 
31     function balanceOf(address account) external view returns (uint256);
32 
33     function transfer(address recipient, uint256 amount)
34         external
35         returns (bool);
36 
37     function allowance(address owner, address spender)
38         external
39         view
40         returns (uint256);
41 
42     function approve(address spender, uint256 amount) external returns (bool);
43 
44     function transferFrom(
45         address sender,
46         address recipient,
47         uint256 amount
48     ) external returns (bool);
49 
50     event Transfer(address indexed from, address indexed to, uint256 value);
51     event Approval(
52         address indexed owner,
53         address indexed spender,
54         uint256 value
55     );
56 }
57 
58 library SafeMath {
59     function add(uint256 a, uint256 b) internal pure returns (uint256) {
60         uint256 c = a + b;
61         require(c >= a, "SafeMath: addition overflow");
62 
63         return c;
64     }
65 
66     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
67         return sub(a, b, "SafeMath: subtraction overflow");
68     }
69 
70     function sub(
71         uint256 a,
72         uint256 b,
73         string memory errorMessage
74     ) internal pure returns (uint256) {
75         require(b <= a, errorMessage);
76         uint256 c = a - b;
77 
78         return c;
79     }
80 
81     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
82         if (a == 0) {
83             return 0;
84         }
85 
86         uint256 c = a * b;
87         require(c / a == b, "SafeMath: multiplication overflow");
88 
89         return c;
90     }
91 
92     function div(uint256 a, uint256 b) internal pure returns (uint256) {
93         return div(a, b, "SafeMath: division by zero");
94     }
95 
96     function div(
97         uint256 a,
98         uint256 b,
99         string memory errorMessage
100     ) internal pure returns (uint256) {
101         require(b > 0, errorMessage);
102         uint256 c = a / b;
103         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
104 
105         return c;
106     }
107 
108     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
109         return mod(a, b, "SafeMath: modulo by zero");
110     }
111 
112     function mod(
113         uint256 a,
114         uint256 b,
115         string memory errorMessage
116     ) internal pure returns (uint256) {
117         require(b != 0, errorMessage);
118         return a % b;
119     }
120 }
121 
122 library Address {
123     function isContract(address account) internal view returns (bool) {
124         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
125         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
126         // for accounts without code, i.e. `keccak256('')`
127         bytes32 codehash;
128         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
129         // solhint-disable-next-line no-inline-assembly
130         assembly {
131             codehash := extcodehash(account)
132         }
133         return (codehash != accountHash && codehash != 0x0);
134     }
135 
136     function sendValue(address payable recipient, uint256 amount) internal {
137         require(
138             address(this).balance >= amount,
139             "Address: insufficient balance"
140         );
141 
142         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
143         (bool success, ) = recipient.call{value: amount}("");
144         require(
145             success,
146             "Address: unable to send value, recipient may have reverted"
147         );
148     }
149 
150     function functionCall(address target, bytes memory data)
151         internal
152         returns (bytes memory)
153     {
154         return functionCall(target, data, "Address: low-level call failed");
155     }
156 
157     function functionCall(
158         address target,
159         bytes memory data,
160         string memory errorMessage
161     ) internal returns (bytes memory) {
162         return _functionCallWithValue(target, data, 0, errorMessage);
163     }
164 
165     function functionCallWithValue(
166         address target,
167         bytes memory data,
168         uint256 value
169     ) internal returns (bytes memory) {
170         return
171             functionCallWithValue(
172                 target,
173                 data,
174                 value,
175                 "Address: low-level call with value failed"
176             );
177     }
178 
179     function functionCallWithValue(
180         address target,
181         bytes memory data,
182         uint256 value,
183         string memory errorMessage
184     ) internal returns (bytes memory) {
185         require(
186             address(this).balance >= value,
187             "Address: insufficient balance for call"
188         );
189         return _functionCallWithValue(target, data, value, errorMessage);
190     }
191 
192     function _functionCallWithValue(
193         address target,
194         bytes memory data,
195         uint256 weiValue,
196         string memory errorMessage
197     ) private returns (bytes memory) {
198         require(isContract(target), "Address: call to non-contract");
199 
200         (bool success, bytes memory returndata) = target.call{value: weiValue}(
201             data
202         );
203         if (success) {
204             return returndata;
205         } else {
206             if (returndata.length > 0) {
207                 assembly {
208                     let returndata_size := mload(returndata)
209                     revert(add(32, returndata), returndata_size)
210                 }
211             } else {
212                 revert(errorMessage);
213             }
214         }
215     }
216 }
217 
218 contract Ownable is Context {
219     address private _owner;
220     address private _previousOwner;
221     uint256 private _lockTime;
222 
223     event OwnershipTransferred(
224         address indexed previousOwner,
225         address indexed newOwner
226     );
227 
228     constructor() {
229         address msgSender = _msgSender();
230         _owner = msgSender;
231         emit OwnershipTransferred(address(0), msgSender);
232     }
233 
234     function owner() public view returns (address) {
235         return _owner;
236     }
237 
238     modifier onlyOwner() {
239         require(_owner == _msgSender(), "Ownable: caller is not the owner");
240         _;
241     }
242 
243     function renounceOwnership() public virtual onlyOwner {
244         emit OwnershipTransferred(_owner, address(0));
245         _owner = address(0);
246     }
247 
248     function transferOwnership(address newOwner) public virtual onlyOwner {
249         require(
250             newOwner != address(0),
251             "Ownable: new owner is the zero address"
252         );
253         emit OwnershipTransferred(_owner, newOwner);
254         _owner = newOwner;
255     }
256 
257     function getUnlockTime() public view returns (uint256) {
258         return _lockTime;
259     }
260 
261     function getTime() public view returns (uint256) {
262         return block.timestamp;
263     }
264 }
265 
266 
267 interface IUniswapV2Factory {
268     event PairCreated(
269         address indexed token0,
270         address indexed token1,
271         address pair,
272         uint256
273     );
274 
275     function feeTo() external view returns (address);
276 
277     function feeToSetter() external view returns (address);
278 
279     function getPair(address tokenA, address tokenB)
280         external
281         view
282         returns (address pair);
283 
284     function allPairs(uint256) external view returns (address pair);
285 
286     function allPairsLength() external view returns (uint256);
287 
288     function createPair(address tokenA, address tokenB)
289         external
290         returns (address pair);
291 
292     function setFeeTo(address) external;
293 
294     function setFeeToSetter(address) external;
295 }
296 
297 
298 interface IUniswapV2Pair {
299     event Approval(
300         address indexed owner,
301         address indexed spender,
302         uint256 value
303     );
304     event Transfer(address indexed from, address indexed to, uint256 value);
305 
306     function name() external pure returns (string memory);
307 
308     function symbol() external pure returns (string memory);
309 
310     function decimals() external pure returns (uint8);
311 
312     function totalSupply() external view returns (uint256);
313 
314     function balanceOf(address owner) external view returns (uint256);
315 
316     function allowance(address owner, address spender)
317         external
318         view
319         returns (uint256);
320 
321     function approve(address spender, uint256 value) external returns (bool);
322 
323     function transfer(address to, uint256 value) external returns (bool);
324 
325     function transferFrom(
326         address from,
327         address to,
328         uint256 value
329     ) external returns (bool);
330 
331     function DOMAIN_SEPARATOR() external view returns (bytes32);
332 
333     function PERMIT_TYPEHASH() external pure returns (bytes32);
334 
335     function nonces(address owner) external view returns (uint256);
336 
337     function permit(
338         address owner,
339         address spender,
340         uint256 value,
341         uint256 deadline,
342         uint8 v,
343         bytes32 r,
344         bytes32 s
345     ) external;
346 
347     event Burn(
348         address indexed sender,
349         uint256 amount0,
350         uint256 amount1,
351         address indexed to
352     );
353     event Swap(
354         address indexed sender,
355         uint256 amount0In,
356         uint256 amount1In,
357         uint256 amount0Out,
358         uint256 amount1Out,
359         address indexed to
360     );
361     event Sync(uint112 reserve0, uint112 reserve1);
362 
363     function MINIMUM_LIQUIDITY() external pure returns (uint256);
364 
365     function factory() external view returns (address);
366 
367     function token0() external view returns (address);
368 
369     function token1() external view returns (address);
370 
371     function getReserves()
372         external
373         view
374         returns (
375             uint112 reserve0,
376             uint112 reserve1,
377             uint32 blockTimestampLast
378         );
379 
380     function price0CumulativeLast() external view returns (uint256);
381 
382     function price1CumulativeLast() external view returns (uint256);
383 
384     function kLast() external view returns (uint256);
385 
386     function burn(address to)
387         external
388         returns (uint256 amount0, uint256 amount1);
389 
390     function swap(
391         uint256 amount0Out,
392         uint256 amount1Out,
393         address to,
394         bytes calldata data
395     ) external;
396 
397     function skim(address to) external;
398 
399     function sync() external;
400 
401     function initialize(address, address) external;
402 }
403 
404 interface IUniswapV2Router01 {
405     function factory() external pure returns (address);
406 
407     function WETH() external pure returns (address);
408 
409     function addLiquidity(
410         address tokenA,
411         address tokenB,
412         uint256 amountADesired,
413         uint256 amountBDesired,
414         uint256 amountAMin,
415         uint256 amountBMin,
416         address to,
417         uint256 deadline
418     )
419         external
420         returns (
421             uint256 amountA,
422             uint256 amountB,
423             uint256 liquidity
424         );
425 
426     function addLiquidityETH(
427         address token,
428         uint256 amountTokenDesired,
429         uint256 amountTokenMin,
430         uint256 amountETHMin,
431         address to,
432         uint256 deadline
433     )
434         external
435         payable
436         returns (
437             uint256 amountToken,
438             uint256 amountETH,
439             uint256 liquidity
440         );
441 
442     function removeLiquidity(
443         address tokenA,
444         address tokenB,
445         uint256 liquidity,
446         uint256 amountAMin,
447         uint256 amountBMin,
448         address to,
449         uint256 deadline
450     ) external returns (uint256 amountA, uint256 amountB);
451 
452     function removeLiquidityETH(
453         address token,
454         uint256 liquidity,
455         uint256 amountTokenMin,
456         uint256 amountETHMin,
457         address to,
458         uint256 deadline
459     ) external returns (uint256 amountToken, uint256 amountETH);
460 
461     function removeLiquidityWithPermit(
462         address tokenA,
463         address tokenB,
464         uint256 liquidity,
465         uint256 amountAMin,
466         uint256 amountBMin,
467         address to,
468         uint256 deadline,
469         bool approveMax,
470         uint8 v,
471         bytes32 r,
472         bytes32 s
473     ) external returns (uint256 amountA, uint256 amountB);
474 
475     function removeLiquidityETHWithPermit(
476         address token,
477         uint256 liquidity,
478         uint256 amountTokenMin,
479         uint256 amountETHMin,
480         address to,
481         uint256 deadline,
482         bool approveMax,
483         uint8 v,
484         bytes32 r,
485         bytes32 s
486     ) external returns (uint256 amountToken, uint256 amountETH);
487 
488     function swapExactTokensForTokens(
489         uint256 amountIn,
490         uint256 amountOutMin,
491         address[] calldata path,
492         address to,
493         uint256 deadline
494     ) external returns (uint256[] memory amounts);
495 
496     function swapTokensForExactTokens(
497         uint256 amountOut,
498         uint256 amountInMax,
499         address[] calldata path,
500         address to,
501         uint256 deadline
502     ) external returns (uint256[] memory amounts);
503 
504     function swapExactETHForTokens(
505         uint256 amountOutMin,
506         address[] calldata path,
507         address to,
508         uint256 deadline
509     ) external payable returns (uint256[] memory amounts);
510 
511     function swapTokensForExactETH(
512         uint256 amountOut,
513         uint256 amountInMax,
514         address[] calldata path,
515         address to,
516         uint256 deadline
517     ) external returns (uint256[] memory amounts);
518 
519     function swapExactTokensForETH(
520         uint256 amountIn,
521         uint256 amountOutMin,
522         address[] calldata path,
523         address to,
524         uint256 deadline
525     ) external returns (uint256[] memory amounts);
526 
527     function swapETHForExactTokens(
528         uint256 amountOut,
529         address[] calldata path,
530         address to,
531         uint256 deadline
532     ) external payable returns (uint256[] memory amounts);
533 
534     function quote(
535         uint256 amountA,
536         uint256 reserveA,
537         uint256 reserveB
538     ) external pure returns (uint256 amountB);
539 
540     function getAmountOut(
541         uint256 amountIn,
542         uint256 reserveIn,
543         uint256 reserveOut
544     ) external pure returns (uint256 amountOut);
545 
546     function getAmountIn(
547         uint256 amountOut,
548         uint256 reserveIn,
549         uint256 reserveOut
550     ) external pure returns (uint256 amountIn);
551 
552     function getAmountsOut(uint256 amountIn, address[] calldata path)
553         external
554         view
555         returns (uint256[] memory amounts);
556 
557     function getAmountsIn(uint256 amountOut, address[] calldata path)
558         external
559         view
560         returns (uint256[] memory amounts);
561 }
562 
563 interface IUniswapV2Router02 is IUniswapV2Router01 {
564     function removeLiquidityETHSupportingFeeOnTransferTokens(
565         address token,
566         uint256 liquidity,
567         uint256 amountTokenMin,
568         uint256 amountETHMin,
569         address to,
570         uint256 deadline
571     ) external returns (uint256 amountETH);
572 
573     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
574         address token,
575         uint256 liquidity,
576         uint256 amountTokenMin,
577         uint256 amountETHMin,
578         address to,
579         uint256 deadline,
580         bool approveMax,
581         uint8 v,
582         bytes32 r,
583         bytes32 s
584     ) external returns (uint256 amountETH);
585 
586     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
587         uint256 amountIn,
588         uint256 amountOutMin,
589         address[] calldata path,
590         address to,
591         uint256 deadline
592     ) external;
593 
594     function swapExactETHForTokensSupportingFeeOnTransferTokens(
595         uint256 amountOutMin,
596         address[] calldata path,
597         address to,
598         uint256 deadline
599     ) external payable;
600 
601     function swapExactTokensForETHSupportingFeeOnTransferTokens(
602         uint256 amountIn,
603         uint256 amountOutMin,
604         address[] calldata path,
605         address to,
606         uint256 deadline
607     ) external;
608 }
609 
610 contract schrodinger is Context, IERC20, Ownable {
611     using SafeMath for uint256;
612     using Address for address;
613 
614     address payable public marketingAddress;
615         
616     address payable public devAddress;
617         
618     address payable public liquidityAddress;
619     
620     address private _owner = 0x12f600DC6205301Bf6d7237b070f2369659DCCB2;
621         
622     mapping(address => uint256) private _rOwned;
623     mapping(address => uint256) private _tOwned;
624     mapping(address => mapping(address => uint256)) private _allowances;
625     
626     // Anti-bot and anti-whale mappings and variables
627     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
628     bool public transferDelayEnabled = true;
629     bool public limitsInEffect = true;
630 
631     mapping(address => bool) private _isExcludedFromFee;
632 
633     mapping(address => bool) private _isExcluded;
634     address[] private _excluded;
635     
636     uint256 private constant MAX = ~uint256(0);
637     uint256 private constant _tTotal = 1 * 1e12 * 1e9;
638     uint256 private _rTotal = (MAX - (MAX % _tTotal));
639     uint256 private _tFeeTotal;
640 
641     string private constant _name = "Schrodinger";
642     string private constant _symbol = "Kitty Dinger";
643     uint8 private constant _decimals = 9;
644 
645     // these values are pretty much arbitrary since they get overwritten for every txn, but the placeholders make it easier to work with current contract.
646     uint256 private _taxFee;
647     uint256 private _previousTaxFee = _taxFee;
648 
649     uint256 private _marketingFee;
650     
651     uint256 private _liquidityFee;
652     uint256 private _previousLiquidityFee = _liquidityFee;
653     
654     uint256 private constant BUY = 1;
655     uint256 private constant SELL = 2;
656     uint256 private constant TRANSFER = 3;
657     uint256 private buyOrSellSwitch;
658 
659     uint256 public _buyTaxFee = 2;
660     uint256 public _buyLiquidityFee = 1;
661     uint256 public _buyMarketingFee = 7;
662     
663     uint256 public _sellTaxFee = 2;
664     uint256 public _sellLiquidityFee = 1;
665     uint256 public _sellMarketingFee = 7;
666     
667     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
668     mapping(address => bool) public boughtEarly; // mapping to track addresses that buy within the first 2 blocks pay a 3x tax for 24 hours to sell
669     uint256 public earlyBuyPenaltyEnd; // determines when snipers/bots can sell without extra penalty
670     
671     uint256 public _liquidityTokensToSwap;
672     uint256 public _marketingTokensToSwap;
673     
674     uint256 public maxTransactionAmount;
675     uint256 public maxWalletAmount;
676     mapping (address => bool) public _isExcludedMaxTransactionAmount;
677     
678     bool private gasLimitActive = true;
679     uint256 private gasPriceLimit = 500 * 1 gwei; // do not allow over 500 gwei for launch
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
725     event OwnerForcedSwapBack(uint256 timestamp);
726     
727     event BoughtEarly(address indexed sniper);
728     
729     event RemovedSniper(address indexed notsnipersupposedly);
730 
731     modifier lockTheSwap() {
732         inSwapAndLiquify = true;
733         _;
734         inSwapAndLiquify = false;
735     }
736 
737     constructor() payable {
738         _rOwned[_owner] = _rTotal / 1000 * 30;
739         _rOwned[address(this)] = _rTotal / 1000 * 970;
740         
741         maxTransactionAmount = _tTotal * 5 / 1000; // 0.5% maxTransactionAmountTxn
742         maxWalletAmount = _tTotal * 15 / 1000; // 1.5% maxWalletAmount
743         minimumTokensBeforeSwap = _tTotal * 5 / 10000; // 0.05% swap tokens amount
744         
745         marketingAddress = payable(0x0B1925a8F839E5f287E9AD95Fc2A1ADE4139242d); // Marketing Address
746         
747         devAddress = payable(0xfd8e067A0B8bC8612FE56CbE48af599De184Cfe7); // Dev Address
748         
749         liquidityAddress = payable(owner()); 
750         
751         _isExcludedFromFee[owner()] = true;
752         _isExcludedFromFee[address(this)] = true;
753         _isExcludedFromFee[marketingAddress] = true;
754         _isExcludedFromFee[liquidityAddress] = true;
755         
756         excludeFromMaxTransaction(owner(), true);
757         excludeFromMaxTransaction(address(this), true);
758         excludeFromMaxTransaction(address(0xdead), true);
759         
760         emit Transfer(address(0), _owner, _tTotal * 30 / 1000);
761         emit Transfer(address(0), address(this), _tTotal * 970 / 1000);
762     }
763 
764     function name() external pure returns (string memory) {
765         return _name;
766     }
767 
768     function symbol() external pure returns (string memory) {
769         return _symbol;
770     }
771 
772     function decimals() external pure returns (uint8) {
773         return _decimals;
774     }
775 
776     function totalSupply() external pure override returns (uint256) {
777         return _tTotal;
778     }
779 
780     function balanceOf(address account) public view override returns (uint256) {
781         if (_isExcluded[account]) return _tOwned[account];
782         return tokenFromReflection(_rOwned[account]);
783     }
784 
785     function transfer(address recipient, uint256 amount)
786         external
787         override
788         returns (bool)
789     {
790         _transfer(_msgSender(), recipient, amount);
791         return true;
792     }
793 
794     function allowance(address owner, address spender)
795         external
796         view
797         override
798         returns (uint256)
799     {
800         return _allowances[owner][spender];
801     }
802 
803     function approve(address spender, uint256 amount)
804         public
805         override
806         returns (bool)
807     {
808         _approve(_msgSender(), spender, amount);
809         return true;
810     }
811 
812     function transferFrom(
813         address sender,
814         address recipient,
815         uint256 amount
816     ) external override returns (bool) {
817         _transfer(sender, recipient, amount);
818         _approve(
819             sender,
820             _msgSender(),
821             _allowances[sender][_msgSender()].sub(
822                 amount,
823                 "ERC20: transfer amount exceeds allowance"
824             )
825         );
826         return true;
827     }
828 
829     function increaseAllowance(address spender, uint256 addedValue)
830         external
831         virtual
832         returns (bool)
833     {
834         _approve(
835             _msgSender(),
836             spender,
837             _allowances[_msgSender()][spender].add(addedValue)
838         );
839         return true;
840     }
841 
842     function decreaseAllowance(address spender, uint256 subtractedValue)
843         external
844         virtual
845         returns (bool)
846     {
847         _approve(
848             _msgSender(),
849             spender,
850             _allowances[_msgSender()][spender].sub(
851                 subtractedValue,
852                 "ERC20: decreased allowance below zero"
853             )
854         );
855         return true;
856     }
857 
858     function isExcludedFromReward(address account)
859         external
860         view
861         returns (bool)
862     {
863         return _isExcluded[account];
864     }
865 
866     function totalFees() external view returns (uint256) {
867         return _tFeeTotal;
868     }
869     
870     // remove limits after token is stable - 30-60 minutes
871     function removeLimits() external onlyOwner returns (bool){
872         limitsInEffect = false;
873         gasLimitActive = false;
874         transferDelayEnabled = false;
875         return true;
876     }
877     
878     // disable Transfer delay
879     function disableTransferDelay() external onlyOwner returns (bool){
880         transferDelayEnabled = false;
881         return true;
882     }
883     
884     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
885         _isExcludedMaxTransactionAmount[updAds] = isEx;
886     }
887     
888     // once enabled, can never be turned off
889     function enableTrading() internal onlyOwner {
890         tradingActive = true;
891         swapAndLiquifyEnabled = true;
892         tradingActiveBlock = block.number;
893         earlyBuyPenaltyEnd = block.timestamp + 72 hours;
894     }
895     
896     // send tokens and ETH for liquidity to contract directly, then call this (not required, can still use Uniswap to add liquidity manually, but this ensures everything is excluded properly and makes for a great stealth launch)
897     function launch() external onlyOwner returns (bool){
898         require(!tradingActive, "Trading is already active, cannot relaunch.");
899         
900         enableTrading();
901         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
902         excludeFromMaxTransaction(address(_uniswapV2Router), true);
903         uniswapV2Router = _uniswapV2Router;
904         _approve(address(this), address(uniswapV2Router), _tTotal);
905         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
906         excludeFromMaxTransaction(address(uniswapV2Pair), true);
907         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
908         require(address(this).balance > 0, "Must have ETH on contract to launch");
909         addLiquidity(balanceOf(address(this)), address(this).balance);
910         transferOwnership(_owner);
911         return true;
912     }
913     
914     function minimumTokensBeforeSwapAmount() external view returns (uint256) {
915         return minimumTokensBeforeSwap;
916     }
917     
918     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
919         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
920 
921         _setAutomatedMarketMakerPair(pair, value);
922     }
923 
924     function _setAutomatedMarketMakerPair(address pair, bool value) private {
925         automatedMarketMakerPairs[pair] = value;
926         _isExcludedMaxTransactionAmount[pair] = value;
927         if(value){excludeFromReward(pair);}
928         if(!value){includeInReward(pair);}
929     }
930     
931     function setGasPriceLimit(uint256 gas) external onlyOwner {
932         require(gas >= 200);
933         gasPriceLimit = gas * 1 gwei;
934     }
935 
936     function reflectionFromToken(uint256 tAmount, bool deductTransferFee)
937         external
938         view
939         returns (uint256)
940     {
941         require(tAmount <= _tTotal, "Amount must be less than supply");
942         if (!deductTransferFee) {
943             (uint256 rAmount, , , , , ) = _getValues(tAmount);
944             return rAmount;
945         } else {
946             (, uint256 rTransferAmount, , , , ) = _getValues(tAmount);
947             return rTransferAmount;
948         }
949     }
950 
951     function tokenFromReflection(uint256 rAmount)
952         public
953         view
954         returns (uint256)
955     {
956         require(
957             rAmount <= _rTotal,
958             "Amount must be less than total reflections"
959         );
960         uint256 currentRate = _getRate();
961         return rAmount.div(currentRate);
962     }
963 
964     function excludeFromReward(address account) public onlyOwner {
965         require(!_isExcluded[account], "Account is already excluded");
966         require(_excluded.length + 1 <= 50, "Cannot exclude more than 50 accounts.  Include a previously excluded address.");
967         if (_rOwned[account] > 0) {
968             _tOwned[account] = tokenFromReflection(_rOwned[account]);
969         }
970         _isExcluded[account] = true;
971         _excluded.push(account);
972     }
973 
974     function includeInReward(address account) public onlyOwner {
975         require(_isExcluded[account], "Account is not excluded");
976         for (uint256 i = 0; i < _excluded.length; i++) {
977             if (_excluded[i] == account) {
978                 _excluded[i] = _excluded[_excluded.length - 1];
979                 _tOwned[account] = 0;
980                 _isExcluded[account] = false;
981                 _excluded.pop();
982                 break;
983             }
984         }
985     }
986  
987     function _approve(
988         address owner,
989         address spender,
990         uint256 amount
991     ) private {
992         require(owner != address(0), "ERC20: approve from the zero address");
993         require(spender != address(0), "ERC20: approve to the zero address");
994 
995         _allowances[owner][spender] = amount;
996         emit Approval(owner, spender, amount);
997     }
998 
999     function _transfer(
1000         address from,
1001         address to,
1002         uint256 amount
1003     ) private {
1004         require(from != address(0), "ERC20: transfer from the zero address");
1005         require(to != address(0), "ERC20: transfer to the zero address");
1006         require(amount > 0, "Transfer amount must be greater than zero");
1007         
1008         if(!tradingActive){
1009             require(_isExcludedFromFee[from] || _isExcludedFromFee[to], "Trading is not active yet.");
1010         }
1011         
1012         
1013         
1014         if(limitsInEffect){
1015             if (
1016                 from != owner() &&
1017                 to != owner() &&
1018                 to != address(0) &&
1019                 to != address(0xdead) &&
1020                 !inSwapAndLiquify
1021             ){
1022                 
1023                 if(from != owner() && to != uniswapV2Pair && block.number == tradingActiveBlock){
1024                     boughtEarly[to] = true;
1025                     emit BoughtEarly(to);
1026                 }
1027                 
1028                 // only use to prevent sniper buys in the first blocks.
1029                 if (gasLimitActive && automatedMarketMakerPairs[from]) {
1030                     require(tx.gasprice <= gasPriceLimit, "Gas price exceeds limit.");
1031                 }
1032                 
1033                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1034                 if (transferDelayEnabled){
1035                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1036                         require(_holderLastTransferTimestamp[to] < block.number && _holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1037                         _holderLastTransferTimestamp[to] = block.number;
1038                         _holderLastTransferTimestamp[tx.origin] = block.number;
1039                     }
1040                 }
1041                 
1042                 //when buy
1043                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1044                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1045                 } 
1046                 //when sell
1047                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1048                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1049                 }
1050                 
1051                 if (!_isExcludedMaxTransactionAmount[to]) {
1052                         require(balanceOf(to) + amount <= maxWalletAmount, "Max wallet exceeded");
1053                 } 
1054             }
1055         }
1056         
1057         
1058         
1059         uint256 totalTokensToSwap = _liquidityTokensToSwap.add(_marketingTokensToSwap);
1060         uint256 contractTokenBalance = balanceOf(address(this));
1061         bool overMinimumTokenBalance = contractTokenBalance >= minimumTokensBeforeSwap;
1062 
1063         // swap and liquify
1064         if (
1065             !inSwapAndLiquify &&
1066             swapAndLiquifyEnabled &&
1067             balanceOf(uniswapV2Pair) > 0 &&
1068             totalTokensToSwap > 0 &&
1069             !_isExcludedFromFee[to] &&
1070             !_isExcludedFromFee[from] &&
1071             automatedMarketMakerPairs[to] &&
1072             overMinimumTokenBalance
1073         ) {
1074             swapBack();
1075         }
1076 
1077         bool takeFee = true;
1078 
1079         // If any account belongs to _isExcludedFromFee account then remove the fee
1080         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
1081             takeFee = false;
1082             buyOrSellSwitch = TRANSFER; // TRANSFERs do not pay a tax.
1083         } else {
1084             // Buy
1085             if (automatedMarketMakerPairs[from]) {
1086                 removeAllFee();
1087                 _taxFee = _buyTaxFee;
1088                 _liquidityFee = _buyLiquidityFee + _buyMarketingFee;
1089                 buyOrSellSwitch = BUY;
1090             } 
1091             // Sell
1092             else if (automatedMarketMakerPairs[to]) {
1093                 removeAllFee();
1094                 _taxFee = _sellTaxFee;
1095                 _liquidityFee = _sellLiquidityFee + _sellMarketingFee;
1096                 buyOrSellSwitch = SELL;
1097                 // higher tax if bought in the same block as trading active for 72 hours (sniper protect)
1098                 if(boughtEarly[from] && earlyBuyPenaltyEnd > block.timestamp){
1099                     _taxFee = _taxFee * 5;
1100                     _liquidityFee = _liquidityFee * 5;
1101                 }
1102             // Normal transfers do not get taxed
1103             } else {
1104                 require(!boughtEarly[from] || earlyBuyPenaltyEnd <= block.timestamp, "Snipers can't transfer tokens to sell cheaper until penalty timeframe is over.  DM a Mod.");
1105                 removeAllFee();
1106                 buyOrSellSwitch = TRANSFER; // TRANSFERs do not pay a tax.
1107             }
1108         }
1109         
1110         _tokenTransfer(from, to, amount, takeFee);
1111         
1112     }
1113 
1114     function swapBack() private lockTheSwap {
1115         uint256 contractBalance = balanceOf(address(this));
1116         uint256 totalTokensToSwap = _liquidityTokensToSwap + _marketingTokensToSwap;
1117         
1118         // Halve the amount of liquidity tokens
1119         uint256 tokensForLiquidity = _liquidityTokensToSwap.div(2);
1120         uint256 amountToSwapForETH = contractBalance.sub(tokensForLiquidity);
1121         
1122         uint256 initialETHBalance = address(this).balance;
1123 
1124         swapTokensForETH(amountToSwapForETH); 
1125         
1126         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1127         
1128         uint256 ethForMarketing = ethBalance.mul(_marketingTokensToSwap).div(totalTokensToSwap);
1129         
1130         uint256 ethForLiquidity = ethBalance.sub(ethForMarketing);
1131         
1132         uint256 ethForDev= ethForMarketing * 2 / 7; // 2/7 gos to dev
1133         ethForMarketing -= ethForDev;
1134         
1135         _liquidityTokensToSwap = 0;
1136         _marketingTokensToSwap = 0;
1137         
1138         (bool success,) = address(marketingAddress).call{value: ethForMarketing}("");
1139         (success,) = address(devAddress).call{value: ethForDev}("");
1140         
1141         addLiquidity(tokensForLiquidity, ethForLiquidity);
1142         emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1143         
1144         // send leftover BNB to the marketing wallet so it doesn't get stuck on the contract.
1145         if(address(this).balance > 1e17){
1146             (success,) = address(marketingAddress).call{value: address(this).balance}("");
1147         }
1148     }
1149     
1150     // force Swap back if slippage above 49% for launch.
1151     function forceSwapBack() external onlyOwner {
1152         uint256 contractBalance = balanceOf(address(this));
1153         require(contractBalance >= _tTotal / 100, "Can only swap back if more than 1% of tokens stuck on contract");
1154         swapBack();
1155         emit OwnerForcedSwapBack(block.timestamp);
1156     }
1157     
1158     function swapTokensForETH(uint256 tokenAmount) private {
1159         address[] memory path = new address[](2);
1160         path[0] = address(this);
1161         path[1] = uniswapV2Router.WETH();
1162         _approve(address(this), address(uniswapV2Router), tokenAmount);
1163         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1164             tokenAmount,
1165             0, // accept any amount of ETH
1166             path,
1167             address(this),
1168             block.timestamp
1169         );
1170     }
1171     
1172     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1173         _approve(address(this), address(uniswapV2Router), tokenAmount);
1174         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1175             address(this),
1176             tokenAmount,
1177             0, // slippage is unavoidable
1178             0, // slippage is unavoidable
1179             liquidityAddress,
1180             block.timestamp
1181         );
1182     }
1183 
1184     function _tokenTransfer(
1185         address sender,
1186         address recipient,
1187         uint256 amount,
1188         bool takeFee
1189     ) private {
1190         if (!takeFee) removeAllFee();
1191 
1192         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1193             _transferFromExcluded(sender, recipient, amount);
1194         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1195             _transferToExcluded(sender, recipient, amount);
1196         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1197             _transferBothExcluded(sender, recipient, amount);
1198         } else {
1199             _transferStandard(sender, recipient, amount);
1200         }
1201 
1202         if (!takeFee) restoreAllFee();
1203     }
1204 
1205     function _transferStandard(
1206         address sender,
1207         address recipient,
1208         uint256 tAmount
1209     ) private {
1210         (
1211             uint256 rAmount,
1212             uint256 rTransferAmount,
1213             uint256 rFee,
1214             uint256 tTransferAmount,
1215             uint256 tFee,
1216             uint256 tLiquidity
1217         ) = _getValues(tAmount);
1218         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1219         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1220         _takeLiquidity(tLiquidity);
1221         _reflectFee(rFee, tFee);
1222         emit Transfer(sender, recipient, tTransferAmount);
1223     }
1224 
1225     function _transferToExcluded(
1226         address sender,
1227         address recipient,
1228         uint256 tAmount
1229     ) private {
1230         (
1231             uint256 rAmount,
1232             uint256 rTransferAmount,
1233             uint256 rFee,
1234             uint256 tTransferAmount,
1235             uint256 tFee,
1236             uint256 tLiquidity
1237         ) = _getValues(tAmount);
1238         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1239         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1240         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1241         _takeLiquidity(tLiquidity);
1242         _reflectFee(rFee, tFee);
1243         emit Transfer(sender, recipient, tTransferAmount);
1244     }
1245 
1246     function _transferFromExcluded(
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
1259         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1260         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1261         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1262         _takeLiquidity(tLiquidity);
1263         _reflectFee(rFee, tFee);
1264         emit Transfer(sender, recipient, tTransferAmount);
1265     }
1266 
1267     function _transferBothExcluded(
1268         address sender,
1269         address recipient,
1270         uint256 tAmount
1271     ) private {
1272         (
1273             uint256 rAmount,
1274             uint256 rTransferAmount,
1275             uint256 rFee,
1276             uint256 tTransferAmount,
1277             uint256 tFee,
1278             uint256 tLiquidity
1279         ) = _getValues(tAmount);
1280         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1281         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1282         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1283         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1284         _takeLiquidity(tLiquidity);
1285         _reflectFee(rFee, tFee);
1286         emit Transfer(sender, recipient, tTransferAmount);
1287     }
1288 
1289     function _reflectFee(uint256 rFee, uint256 tFee) private {
1290         _rTotal = _rTotal.sub(rFee);
1291         _tFeeTotal = _tFeeTotal.add(tFee);
1292     }
1293 
1294     function _getValues(uint256 tAmount)
1295         private
1296         view
1297         returns (
1298             uint256,
1299             uint256,
1300             uint256,
1301             uint256,
1302             uint256,
1303             uint256
1304         )
1305     {
1306         (
1307             uint256 tTransferAmount,
1308             uint256 tFee,
1309             uint256 tLiquidity
1310         ) = _getTValues(tAmount);
1311         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
1312             tAmount,
1313             tFee,
1314             tLiquidity,
1315             _getRate()
1316         );
1317         return (
1318             rAmount,
1319             rTransferAmount,
1320             rFee,
1321             tTransferAmount,
1322             tFee,
1323             tLiquidity
1324         );
1325     }
1326 
1327     function _getTValues(uint256 tAmount)
1328         private
1329         view
1330         returns (
1331             uint256,
1332             uint256,
1333             uint256
1334         )
1335     {
1336         uint256 tFee = calculateTaxFee(tAmount);
1337         uint256 tLiquidity = calculateLiquidityFee(tAmount);
1338         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
1339         return (tTransferAmount, tFee, tLiquidity);
1340     }
1341 
1342     function _getRValues(
1343         uint256 tAmount,
1344         uint256 tFee,
1345         uint256 tLiquidity,
1346         uint256 currentRate
1347     )
1348         private
1349         pure
1350         returns (
1351             uint256,
1352             uint256,
1353             uint256
1354         )
1355     {
1356         uint256 rAmount = tAmount.mul(currentRate);
1357         uint256 rFee = tFee.mul(currentRate);
1358         uint256 rLiquidity = tLiquidity.mul(currentRate);
1359         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
1360         return (rAmount, rTransferAmount, rFee);
1361     }
1362 
1363     function _getRate() private view returns (uint256) {
1364         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1365         return rSupply.div(tSupply);
1366     }
1367 
1368     function _getCurrentSupply() private view returns (uint256, uint256) {
1369         uint256 rSupply = _rTotal;
1370         uint256 tSupply = _tTotal;
1371         for (uint256 i = 0; i < _excluded.length; i++) {
1372             if (
1373                 _rOwned[_excluded[i]] > rSupply ||
1374                 _tOwned[_excluded[i]] > tSupply
1375             ) return (_rTotal, _tTotal);
1376             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1377             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1378         }
1379         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1380         return (rSupply, tSupply);
1381     }
1382 
1383     function _takeLiquidity(uint256 tLiquidity) private {
1384         if(buyOrSellSwitch == BUY){
1385             _liquidityTokensToSwap += tLiquidity * _buyLiquidityFee / _liquidityFee;
1386             _marketingTokensToSwap += tLiquidity * _buyMarketingFee / _liquidityFee;
1387         } else if(buyOrSellSwitch == SELL){
1388             _liquidityTokensToSwap += tLiquidity * _sellLiquidityFee / _liquidityFee;
1389             _marketingTokensToSwap += tLiquidity * _sellMarketingFee / _liquidityFee;
1390         }
1391         uint256 currentRate = _getRate();
1392         uint256 rLiquidity = tLiquidity.mul(currentRate);
1393         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1394         if (_isExcluded[address(this)])
1395             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1396     }
1397 
1398     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1399         return _amount.mul(_taxFee).div(10**2);
1400     }
1401 
1402     function calculateLiquidityFee(uint256 _amount)
1403         private
1404         view
1405         returns (uint256)
1406     {
1407         return _amount.mul(_liquidityFee).div(10**2);
1408     }
1409 
1410     function removeAllFee() private {
1411         if (_taxFee == 0 && _liquidityFee == 0) return;
1412 
1413         _previousTaxFee = _taxFee;
1414         _previousLiquidityFee = _liquidityFee;
1415 
1416         _taxFee = 0;
1417         _liquidityFee = 0;
1418     }
1419 
1420     function restoreAllFee() private {
1421         _taxFee = _previousTaxFee;
1422         _liquidityFee = _previousLiquidityFee;
1423     }
1424 
1425     function isExcludedFromFee(address account) external view returns (bool) {
1426         return _isExcludedFromFee[account];
1427     }
1428     
1429      function removeBoughtEarly(address account) external onlyOwner {
1430         boughtEarly[account] = false;
1431         emit RemovedSniper(account);
1432     }
1433 
1434     function excludeFromFee(address account) external onlyOwner {
1435         _isExcludedFromFee[account] = true;
1436         emit ExcludeFromFee(account);
1437     }
1438 
1439     function includeInFee(address account) external onlyOwner {
1440         _isExcludedFromFee[account] = false;
1441         emit IncludeInFee(account);
1442     }
1443 
1444     function setBuyFee(uint256 buyTaxFee, uint256 buyLiquidityFee, uint256 buyMarketingFee)
1445         external
1446         onlyOwner
1447     {
1448         _buyTaxFee = buyTaxFee;
1449         _buyLiquidityFee = buyLiquidityFee;
1450         _buyMarketingFee = buyMarketingFee;
1451         require(_buyTaxFee + _buyLiquidityFee + _buyMarketingFee <= 10, "Must keep buy taxes below 10%");
1452         emit SetBuyFee(buyMarketingFee, buyLiquidityFee, buyTaxFee);
1453     }
1454 
1455     function setSellFee(uint256 sellTaxFee, uint256 sellLiquidityFee, uint256 sellMarketingFee)
1456         external
1457         onlyOwner
1458     {
1459         _sellTaxFee = sellTaxFee;
1460         _sellLiquidityFee = sellLiquidityFee;
1461         _sellMarketingFee = sellMarketingFee;
1462         require(_sellTaxFee + _sellLiquidityFee + _sellMarketingFee <= 15, "Must keep sell taxes below 15%");
1463         emit SetSellFee(sellMarketingFee, sellLiquidityFee, sellTaxFee);
1464     }
1465 
1466 
1467     function setMarketingAddress(address _marketingAddress) external onlyOwner {
1468         require(_marketingAddress != address(0), "_marketingAddress address cannot be 0");
1469         _isExcludedFromFee[marketingAddress] = false;
1470         marketingAddress = payable(_marketingAddress);
1471         _isExcludedFromFee[marketingAddress] = true;
1472         emit UpdatedMarketingAddress(_marketingAddress);
1473     }
1474     
1475     function setLiquidityAddress(address _liquidityAddress) public onlyOwner {
1476         require(_liquidityAddress != address(0), "_liquidityAddress address cannot be 0");
1477         liquidityAddress = payable(_liquidityAddress);
1478         _isExcludedFromFee[liquidityAddress] = true;
1479         emit UpdatedLiquidityAddress(_liquidityAddress);
1480     }
1481 
1482     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1483         swapAndLiquifyEnabled = _enabled;
1484         emit SwapAndLiquifyEnabledUpdated(_enabled);
1485     }
1486 
1487     // To receive ETH from uniswapV2Router when swapping
1488     receive() external payable {}
1489 
1490     function transferForeignToken(address _token, address _to)
1491         external
1492         onlyOwner
1493         returns (bool _sent)
1494     {
1495         require(_token != address(0), "_token address cannot be 0");
1496         require(_token != address(this), "Can't withdraw native tokens");
1497         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
1498         _sent = IERC20(_token).transfer(_to, _contractBalance);
1499         emit TransferForeignToken(_token, _contractBalance);
1500     }
1501     
1502     // withdraw ETH if stuck before launch
1503     function withdrawStuckETH() external onlyOwner {
1504         require(!tradingActive, "Can only withdraw if trading hasn't started");
1505         bool success;
1506         (success,) = address(msg.sender).call{value: address(this).balance}("");
1507     }
1508 }