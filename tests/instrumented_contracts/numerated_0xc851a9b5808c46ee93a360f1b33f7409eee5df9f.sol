1 /* 
2     Nausicaa-Inu - NAUSICAA
3     
4     Telegram: https://t.me/nausicaainu
5     Twitter: https://twitter.com/NausicaaInu
6     
7     1 Quadrillion supply
8     2% Dev tax
9     5% marketing
10     1% liquidity
11     2% Reflection to Holders
12     
13 */
14 
15 // SPDX-License-Identifier: MIT
16 
17 pragma solidity ^0.8.9;
18 
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address payable) {
21         return payable(msg.sender);
22     }
23 
24     function _msgData() internal view virtual returns (bytes memory) {
25         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
26         return msg.data;
27     }
28 }
29 
30 interface IERC20 {
31     function totalSupply() external view returns (uint256);
32 
33     function balanceOf(address account) external view returns (uint256);
34 
35     function transfer(address recipient, uint256 amount)
36         external
37         returns (bool);
38 
39     function allowance(address owner, address spender)
40         external
41         view
42         returns (uint256);
43 
44     function approve(address spender, uint256 amount) external returns (bool);
45 
46     function transferFrom(
47         address sender,
48         address recipient,
49         uint256 amount
50     ) external returns (bool);
51 
52     event Transfer(address indexed from, address indexed to, uint256 value);
53     event Approval(
54         address indexed owner,
55         address indexed spender,
56         uint256 value
57     );
58 }
59 
60 library SafeMath {
61     function add(uint256 a, uint256 b) internal pure returns (uint256) {
62         uint256 c = a + b;
63         require(c >= a, "SafeMath: addition overflow");
64 
65         return c;
66     }
67 
68     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
69         return sub(a, b, "SafeMath: subtraction overflow");
70     }
71 
72     function sub(
73         uint256 a,
74         uint256 b,
75         string memory errorMessage
76     ) internal pure returns (uint256) {
77         require(b <= a, errorMessage);
78         uint256 c = a - b;
79 
80         return c;
81     }
82 
83     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
84         if (a == 0) {
85             return 0;
86         }
87 
88         uint256 c = a * b;
89         require(c / a == b, "SafeMath: multiplication overflow");
90 
91         return c;
92     }
93 
94     function div(uint256 a, uint256 b) internal pure returns (uint256) {
95         return div(a, b, "SafeMath: division by zero");
96     }
97 
98     function div(
99         uint256 a,
100         uint256 b,
101         string memory errorMessage
102     ) internal pure returns (uint256) {
103         require(b > 0, errorMessage);
104         uint256 c = a / b;
105         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
106 
107         return c;
108     }
109 
110     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
111         return mod(a, b, "SafeMath: modulo by zero");
112     }
113 
114     function mod(
115         uint256 a,
116         uint256 b,
117         string memory errorMessage
118     ) internal pure returns (uint256) {
119         require(b != 0, errorMessage);
120         return a % b;
121     }
122 }
123 
124 library Address {
125     function isContract(address account) internal view returns (bool) {
126         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
127         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
128         // for accounts without code, i.e. `keccak256('')`
129         bytes32 codehash;
130         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
131         // solhint-disable-next-line no-inline-assembly
132         assembly {
133             codehash := extcodehash(account)
134         }
135         return (codehash != accountHash && codehash != 0x0);
136     }
137 
138     function sendValue(address payable recipient, uint256 amount) internal {
139         require(
140             address(this).balance >= amount,
141             "Address: insufficient balance"
142         );
143 
144         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
145         (bool success, ) = recipient.call{value: amount}("");
146         require(
147             success,
148             "Address: unable to send value, recipient may have reverted"
149         );
150     }
151 
152     function functionCall(address target, bytes memory data)
153         internal
154         returns (bytes memory)
155     {
156         return functionCall(target, data, "Address: low-level call failed");
157     }
158 
159     function functionCall(
160         address target,
161         bytes memory data,
162         string memory errorMessage
163     ) internal returns (bytes memory) {
164         return _functionCallWithValue(target, data, 0, errorMessage);
165     }
166 
167     function functionCallWithValue(
168         address target,
169         bytes memory data,
170         uint256 value
171     ) internal returns (bytes memory) {
172         return
173             functionCallWithValue(
174                 target,
175                 data,
176                 value,
177                 "Address: low-level call with value failed"
178             );
179     }
180 
181     function functionCallWithValue(
182         address target,
183         bytes memory data,
184         uint256 value,
185         string memory errorMessage
186     ) internal returns (bytes memory) {
187         require(
188             address(this).balance >= value,
189             "Address: insufficient balance for call"
190         );
191         return _functionCallWithValue(target, data, value, errorMessage);
192     }
193 
194     function _functionCallWithValue(
195         address target,
196         bytes memory data,
197         uint256 weiValue,
198         string memory errorMessage
199     ) private returns (bytes memory) {
200         require(isContract(target), "Address: call to non-contract");
201 
202         (bool success, bytes memory returndata) = target.call{value: weiValue}(
203             data
204         );
205         if (success) {
206             return returndata;
207         } else {
208             if (returndata.length > 0) {
209                 assembly {
210                     let returndata_size := mload(returndata)
211                     revert(add(32, returndata), returndata_size)
212                 }
213             } else {
214                 revert(errorMessage);
215             }
216         }
217     }
218 }
219 
220 contract Ownable is Context {
221     address private _owner;
222     address private _previousOwner;
223     uint256 private _lockTime;
224 
225     event OwnershipTransferred(
226         address indexed previousOwner,
227         address indexed newOwner
228     );
229 
230     constructor() {
231         address msgSender = _msgSender();
232         _owner = msgSender;
233         emit OwnershipTransferred(address(0), msgSender);
234     }
235 
236     function owner() public view returns (address) {
237         return _owner;
238     }
239 
240     modifier onlyOwner() {
241         require(_owner == _msgSender(), "Ownable: caller is not the owner");
242         _;
243     }
244 
245     function renounceOwnership() public virtual onlyOwner {
246         emit OwnershipTransferred(_owner, address(0));
247         _owner = address(0);
248     }
249 
250     function transferOwnership(address newOwner) public virtual onlyOwner {
251         require(
252             newOwner != address(0),
253             "Ownable: new owner is the zero address"
254         );
255         emit OwnershipTransferred(_owner, newOwner);
256         _owner = newOwner;
257     }
258 
259     function getUnlockTime() public view returns (uint256) {
260         return _lockTime;
261     }
262 
263     function getTime() public view returns (uint256) {
264         return block.timestamp;
265     }
266 }
267 
268 
269 interface IUniswapV2Factory {
270     event PairCreated(
271         address indexed token0,
272         address indexed token1,
273         address pair,
274         uint256
275     );
276 
277     function feeTo() external view returns (address);
278 
279     function feeToSetter() external view returns (address);
280 
281     function getPair(address tokenA, address tokenB)
282         external
283         view
284         returns (address pair);
285 
286     function allPairs(uint256) external view returns (address pair);
287 
288     function allPairsLength() external view returns (uint256);
289 
290     function createPair(address tokenA, address tokenB)
291         external
292         returns (address pair);
293 
294     function setFeeTo(address) external;
295 
296     function setFeeToSetter(address) external;
297 }
298 
299 
300 interface IUniswapV2Pair {
301     event Approval(
302         address indexed owner,
303         address indexed spender,
304         uint256 value
305     );
306     event Transfer(address indexed from, address indexed to, uint256 value);
307 
308     function name() external pure returns (string memory);
309 
310     function symbol() external pure returns (string memory);
311 
312     function decimals() external pure returns (uint8);
313 
314     function totalSupply() external view returns (uint256);
315 
316     function balanceOf(address owner) external view returns (uint256);
317 
318     function allowance(address owner, address spender)
319         external
320         view
321         returns (uint256);
322 
323     function approve(address spender, uint256 value) external returns (bool);
324 
325     function transfer(address to, uint256 value) external returns (bool);
326 
327     function transferFrom(
328         address from,
329         address to,
330         uint256 value
331     ) external returns (bool);
332 
333     function DOMAIN_SEPARATOR() external view returns (bytes32);
334 
335     function PERMIT_TYPEHASH() external pure returns (bytes32);
336 
337     function nonces(address owner) external view returns (uint256);
338 
339     function permit(
340         address owner,
341         address spender,
342         uint256 value,
343         uint256 deadline,
344         uint8 v,
345         bytes32 r,
346         bytes32 s
347     ) external;
348 
349     event Burn(
350         address indexed sender,
351         uint256 amount0,
352         uint256 amount1,
353         address indexed to
354     );
355     event Swap(
356         address indexed sender,
357         uint256 amount0In,
358         uint256 amount1In,
359         uint256 amount0Out,
360         uint256 amount1Out,
361         address indexed to
362     );
363     event Sync(uint112 reserve0, uint112 reserve1);
364 
365     function MINIMUM_LIQUIDITY() external pure returns (uint256);
366 
367     function factory() external view returns (address);
368 
369     function token0() external view returns (address);
370 
371     function token1() external view returns (address);
372 
373     function getReserves()
374         external
375         view
376         returns (
377             uint112 reserve0,
378             uint112 reserve1,
379             uint32 blockTimestampLast
380         );
381 
382     function price0CumulativeLast() external view returns (uint256);
383 
384     function price1CumulativeLast() external view returns (uint256);
385 
386     function kLast() external view returns (uint256);
387 
388     function burn(address to)
389         external
390         returns (uint256 amount0, uint256 amount1);
391 
392     function swap(
393         uint256 amount0Out,
394         uint256 amount1Out,
395         address to,
396         bytes calldata data
397     ) external;
398 
399     function skim(address to) external;
400 
401     function sync() external;
402 
403     function initialize(address, address) external;
404 }
405 
406 interface IUniswapV2Router01 {
407     function factory() external pure returns (address);
408 
409     function WETH() external pure returns (address);
410 
411     function addLiquidity(
412         address tokenA,
413         address tokenB,
414         uint256 amountADesired,
415         uint256 amountBDesired,
416         uint256 amountAMin,
417         uint256 amountBMin,
418         address to,
419         uint256 deadline
420     )
421         external
422         returns (
423             uint256 amountA,
424             uint256 amountB,
425             uint256 liquidity
426         );
427 
428     function addLiquidityETH(
429         address token,
430         uint256 amountTokenDesired,
431         uint256 amountTokenMin,
432         uint256 amountETHMin,
433         address to,
434         uint256 deadline
435     )
436         external
437         payable
438         returns (
439             uint256 amountToken,
440             uint256 amountETH,
441             uint256 liquidity
442         );
443 
444     function removeLiquidity(
445         address tokenA,
446         address tokenB,
447         uint256 liquidity,
448         uint256 amountAMin,
449         uint256 amountBMin,
450         address to,
451         uint256 deadline
452     ) external returns (uint256 amountA, uint256 amountB);
453 
454     function removeLiquidityETH(
455         address token,
456         uint256 liquidity,
457         uint256 amountTokenMin,
458         uint256 amountETHMin,
459         address to,
460         uint256 deadline
461     ) external returns (uint256 amountToken, uint256 amountETH);
462 
463     function removeLiquidityWithPermit(
464         address tokenA,
465         address tokenB,
466         uint256 liquidity,
467         uint256 amountAMin,
468         uint256 amountBMin,
469         address to,
470         uint256 deadline,
471         bool approveMax,
472         uint8 v,
473         bytes32 r,
474         bytes32 s
475     ) external returns (uint256 amountA, uint256 amountB);
476 
477     function removeLiquidityETHWithPermit(
478         address token,
479         uint256 liquidity,
480         uint256 amountTokenMin,
481         uint256 amountETHMin,
482         address to,
483         uint256 deadline,
484         bool approveMax,
485         uint8 v,
486         bytes32 r,
487         bytes32 s
488     ) external returns (uint256 amountToken, uint256 amountETH);
489 
490     function swapExactTokensForTokens(
491         uint256 amountIn,
492         uint256 amountOutMin,
493         address[] calldata path,
494         address to,
495         uint256 deadline
496     ) external returns (uint256[] memory amounts);
497 
498     function swapTokensForExactTokens(
499         uint256 amountOut,
500         uint256 amountInMax,
501         address[] calldata path,
502         address to,
503         uint256 deadline
504     ) external returns (uint256[] memory amounts);
505 
506     function swapExactETHForTokens(
507         uint256 amountOutMin,
508         address[] calldata path,
509         address to,
510         uint256 deadline
511     ) external payable returns (uint256[] memory amounts);
512 
513     function swapTokensForExactETH(
514         uint256 amountOut,
515         uint256 amountInMax,
516         address[] calldata path,
517         address to,
518         uint256 deadline
519     ) external returns (uint256[] memory amounts);
520 
521     function swapExactTokensForETH(
522         uint256 amountIn,
523         uint256 amountOutMin,
524         address[] calldata path,
525         address to,
526         uint256 deadline
527     ) external returns (uint256[] memory amounts);
528 
529     function swapETHForExactTokens(
530         uint256 amountOut,
531         address[] calldata path,
532         address to,
533         uint256 deadline
534     ) external payable returns (uint256[] memory amounts);
535 
536     function quote(
537         uint256 amountA,
538         uint256 reserveA,
539         uint256 reserveB
540     ) external pure returns (uint256 amountB);
541 
542     function getAmountOut(
543         uint256 amountIn,
544         uint256 reserveIn,
545         uint256 reserveOut
546     ) external pure returns (uint256 amountOut);
547 
548     function getAmountIn(
549         uint256 amountOut,
550         uint256 reserveIn,
551         uint256 reserveOut
552     ) external pure returns (uint256 amountIn);
553 
554     function getAmountsOut(uint256 amountIn, address[] calldata path)
555         external
556         view
557         returns (uint256[] memory amounts);
558 
559     function getAmountsIn(uint256 amountOut, address[] calldata path)
560         external
561         view
562         returns (uint256[] memory amounts);
563 }
564 
565 interface IUniswapV2Router02 is IUniswapV2Router01 {
566     function removeLiquidityETHSupportingFeeOnTransferTokens(
567         address token,
568         uint256 liquidity,
569         uint256 amountTokenMin,
570         uint256 amountETHMin,
571         address to,
572         uint256 deadline
573     ) external returns (uint256 amountETH);
574 
575     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
576         address token,
577         uint256 liquidity,
578         uint256 amountTokenMin,
579         uint256 amountETHMin,
580         address to,
581         uint256 deadline,
582         bool approveMax,
583         uint8 v,
584         bytes32 r,
585         bytes32 s
586     ) external returns (uint256 amountETH);
587 
588     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
589         uint256 amountIn,
590         uint256 amountOutMin,
591         address[] calldata path,
592         address to,
593         uint256 deadline
594     ) external;
595 
596     function swapExactETHForTokensSupportingFeeOnTransferTokens(
597         uint256 amountOutMin,
598         address[] calldata path,
599         address to,
600         uint256 deadline
601     ) external payable;
602 
603     function swapExactTokensForETHSupportingFeeOnTransferTokens(
604         uint256 amountIn,
605         uint256 amountOutMin,
606         address[] calldata path,
607         address to,
608         uint256 deadline
609     ) external;
610 }
611 
612 contract NausicaaInu is Context, IERC20, Ownable {
613     using SafeMath for uint256;
614     using Address for address;
615 
616     address payable public marketingAddress;
617         
618     address payable public devAddress;
619         
620     address payable public liquidityAddress;
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
637     uint256 private constant _tTotal = 1 * 1e15 * 1e9;
638     uint256 private _rTotal = (MAX - (MAX % _tTotal));
639     uint256 private _tFeeTotal;
640 
641     string private constant _name = "Nausicaa-Inu";
642     string private constant _symbol = "NAUSICAA";
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
675     mapping (address => bool) public _isExcludedMaxTransactionAmount;
676     
677     bool private gasLimitActive = true;
678     uint256 private gasPriceLimit = 500 * 1 gwei; // do not allow over 500 gwei for launch
679     
680     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
681     // could be subject to a maximum transfer amount
682     mapping (address => bool) public automatedMarketMakerPairs;
683 
684     uint256 private minimumTokensBeforeSwap;
685 
686     IUniswapV2Router02 public uniswapV2Router;
687     address public uniswapV2Pair;
688 
689     bool inSwapAndLiquify;
690     bool public swapAndLiquifyEnabled = false;
691     bool public tradingActive = false;
692 
693     event SwapAndLiquifyEnabledUpdated(bool enabled);
694     event SwapAndLiquify(
695         uint256 tokensSwapped,
696         uint256 ethReceived,
697         uint256 tokensIntoLiquidity
698     );
699 
700     event SwapETHForTokens(uint256 amountIn, address[] path);
701 
702     event SwapTokensForETH(uint256 amountIn, address[] path);
703     
704     event SetAutomatedMarketMakerPair(address pair, bool value);
705     
706     event ExcludeFromReward(address excludedAddress);
707     
708     event IncludeInReward(address includedAddress);
709     
710     event ExcludeFromFee(address excludedAddress);
711     
712     event IncludeInFee(address includedAddress);
713     
714     event SetBuyFee(uint256 marketingFee, uint256 liquidityFee, uint256 reflectFee);
715     
716     event SetSellFee(uint256 marketingFee, uint256 liquidityFee, uint256 reflectFee);
717     
718     event TransferForeignToken(address token, uint256 amount);
719     
720     event UpdatedMarketingAddress(address marketing);
721     
722     event UpdatedLiquidityAddress(address liquidity);
723     
724     event OwnerForcedSwapBack(uint256 timestamp);
725     
726     event BoughtEarly(address indexed sniper);
727     
728     event RemovedSniper(address indexed notsnipersupposedly);
729 
730     modifier lockTheSwap() {
731         inSwapAndLiquify = true;
732         _;
733         inSwapAndLiquify = false;
734     }
735 
736     constructor() payable {
737         _rOwned[_msgSender()] = _rTotal / 1000 * 405;
738         _rOwned[address(this)] = _rTotal / 1000 * 595;
739         
740         maxTransactionAmount = _tTotal * 5 / 1000; // 0.5% maxTransactionAmountTxn
741         minimumTokensBeforeSwap = _tTotal * 5 / 10000; // 0.05% swap tokens amount
742         
743         marketingAddress = payable(0x5A8db19e7624dE0A6088d8B81938f04f17954A0D); // Marketing Address
744         
745         devAddress = payable(0x5ec88028f92B993d0ecb0E19DCD09FB003B5a6AB); // Dev Address
746         
747         liquidityAddress = payable(owner()); // Liquidity Address (switches to dead address once launch happens)
748         
749         _isExcludedFromFee[owner()] = true;
750         _isExcludedFromFee[address(this)] = true;
751         _isExcludedFromFee[marketingAddress] = true;
752         _isExcludedFromFee[liquidityAddress] = true;
753         
754         excludeFromMaxTransaction(owner(), true);
755         excludeFromMaxTransaction(address(this), true);
756         excludeFromMaxTransaction(address(0xdead), true);
757         
758         emit Transfer(address(0), _msgSender(), _tTotal * 405 / 1000);
759         emit Transfer(address(0), address(this), _tTotal * 595 / 1000);
760     }
761 
762     function name() external pure returns (string memory) {
763         return _name;
764     }
765 
766     function symbol() external pure returns (string memory) {
767         return _symbol;
768     }
769 
770     function decimals() external pure returns (uint8) {
771         return _decimals;
772     }
773 
774     function totalSupply() external pure override returns (uint256) {
775         return _tTotal;
776     }
777 
778     function balanceOf(address account) public view override returns (uint256) {
779         if (_isExcluded[account]) return _tOwned[account];
780         return tokenFromReflection(_rOwned[account]);
781     }
782 
783     function transfer(address recipient, uint256 amount)
784         external
785         override
786         returns (bool)
787     {
788         _transfer(_msgSender(), recipient, amount);
789         return true;
790     }
791 
792     function allowance(address owner, address spender)
793         external
794         view
795         override
796         returns (uint256)
797     {
798         return _allowances[owner][spender];
799     }
800 
801     function approve(address spender, uint256 amount)
802         public
803         override
804         returns (bool)
805     {
806         _approve(_msgSender(), spender, amount);
807         return true;
808     }
809 
810     function transferFrom(
811         address sender,
812         address recipient,
813         uint256 amount
814     ) external override returns (bool) {
815         _transfer(sender, recipient, amount);
816         _approve(
817             sender,
818             _msgSender(),
819             _allowances[sender][_msgSender()].sub(
820                 amount,
821                 "ERC20: transfer amount exceeds allowance"
822             )
823         );
824         return true;
825     }
826 
827     function increaseAllowance(address spender, uint256 addedValue)
828         external
829         virtual
830         returns (bool)
831     {
832         _approve(
833             _msgSender(),
834             spender,
835             _allowances[_msgSender()][spender].add(addedValue)
836         );
837         return true;
838     }
839 
840     function decreaseAllowance(address spender, uint256 subtractedValue)
841         external
842         virtual
843         returns (bool)
844     {
845         _approve(
846             _msgSender(),
847             spender,
848             _allowances[_msgSender()][spender].sub(
849                 subtractedValue,
850                 "ERC20: decreased allowance below zero"
851             )
852         );
853         return true;
854     }
855 
856     function isExcludedFromReward(address account)
857         external
858         view
859         returns (bool)
860     {
861         return _isExcluded[account];
862     }
863 
864     function totalFees() external view returns (uint256) {
865         return _tFeeTotal;
866     }
867     
868     // remove limits after token is stable - 30-60 minutes
869     function removeLimits() external onlyOwner returns (bool){
870         limitsInEffect = false;
871         gasLimitActive = false;
872         transferDelayEnabled = false;
873         return true;
874     }
875     
876     // disable Transfer delay
877     function disableTransferDelay() external onlyOwner returns (bool){
878         transferDelayEnabled = false;
879         return true;
880     }
881     
882     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
883         _isExcludedMaxTransactionAmount[updAds] = isEx;
884     }
885     
886     // once enabled, can never be turned off
887     function enableTrading() internal onlyOwner {
888         tradingActive = true;
889         swapAndLiquifyEnabled = true;
890         tradingActiveBlock = block.number;
891         earlyBuyPenaltyEnd = block.timestamp + 72 hours;
892     }
893     
894     // send tokens and ETH for liquidity to contract directly, then call this (not required, can still use Uniswap to add liquidity manually, but this ensures everything is excluded properly and makes for a great stealth launch)
895     function launch(address[] memory airdropWallets, uint256[] memory amounts) external onlyOwner returns (bool){
896         require(!tradingActive, "Trading is already active, cannot relaunch.");
897         require(airdropWallets.length < 200, "Can only airdrop 200 wallets per txn due to gas limits"); // allows for airdrop + launch at the same exact time, reducing delays and reducing sniper input.
898         for(uint256 i = 0; i < airdropWallets.length; i++){
899             address wallet = airdropWallets[i];
900             uint256 amount = amounts[i];
901             _transfer(msg.sender, wallet, amount);
902         }
903         enableTrading();
904         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
905         excludeFromMaxTransaction(address(_uniswapV2Router), true);
906         uniswapV2Router = _uniswapV2Router;
907         _approve(address(this), address(uniswapV2Router), _tTotal);
908         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
909         excludeFromMaxTransaction(address(uniswapV2Pair), true);
910         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
911         require(address(this).balance > 0, "Must have ETH on contract to launch");
912         addLiquidity(balanceOf(address(this)), address(this).balance);
913         setLiquidityAddress(address(0xdead));
914         return true;
915     }
916     
917     function minimumTokensBeforeSwapAmount() external view returns (uint256) {
918         return minimumTokensBeforeSwap;
919     }
920     
921     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
922         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
923 
924         _setAutomatedMarketMakerPair(pair, value);
925     }
926 
927     function _setAutomatedMarketMakerPair(address pair, bool value) private {
928         automatedMarketMakerPairs[pair] = value;
929         _isExcludedMaxTransactionAmount[pair] = value;
930         if(value){excludeFromReward(pair);}
931         if(!value){includeInReward(pair);}
932     }
933     
934     function setGasPriceLimit(uint256 gas) external onlyOwner {
935         require(gas >= 200);
936         gasPriceLimit = gas * 1 gwei;
937     }
938 
939     function reflectionFromToken(uint256 tAmount, bool deductTransferFee)
940         external
941         view
942         returns (uint256)
943     {
944         require(tAmount <= _tTotal, "Amount must be less than supply");
945         if (!deductTransferFee) {
946             (uint256 rAmount, , , , , ) = _getValues(tAmount);
947             return rAmount;
948         } else {
949             (, uint256 rTransferAmount, , , , ) = _getValues(tAmount);
950             return rTransferAmount;
951         }
952     }
953 
954     function tokenFromReflection(uint256 rAmount)
955         public
956         view
957         returns (uint256)
958     {
959         require(
960             rAmount <= _rTotal,
961             "Amount must be less than total reflections"
962         );
963         uint256 currentRate = _getRate();
964         return rAmount.div(currentRate);
965     }
966 
967     function excludeFromReward(address account) public onlyOwner {
968         require(!_isExcluded[account], "Account is already excluded");
969         require(_excluded.length + 1 <= 50, "Cannot exclude more than 50 accounts.  Include a previously excluded address.");
970         if (_rOwned[account] > 0) {
971             _tOwned[account] = tokenFromReflection(_rOwned[account]);
972         }
973         _isExcluded[account] = true;
974         _excluded.push(account);
975     }
976 
977     function includeInReward(address account) public onlyOwner {
978         require(_isExcluded[account], "Account is not excluded");
979         for (uint256 i = 0; i < _excluded.length; i++) {
980             if (_excluded[i] == account) {
981                 _excluded[i] = _excluded[_excluded.length - 1];
982                 _tOwned[account] = 0;
983                 _isExcluded[account] = false;
984                 _excluded.pop();
985                 break;
986             }
987         }
988     }
989  
990     function _approve(
991         address owner,
992         address spender,
993         uint256 amount
994     ) private {
995         require(owner != address(0), "ERC20: approve from the zero address");
996         require(spender != address(0), "ERC20: approve to the zero address");
997 
998         _allowances[owner][spender] = amount;
999         emit Approval(owner, spender, amount);
1000     }
1001 
1002     function _transfer(
1003         address from,
1004         address to,
1005         uint256 amount
1006     ) private {
1007         require(from != address(0), "ERC20: transfer from the zero address");
1008         require(to != address(0), "ERC20: transfer to the zero address");
1009         require(amount > 0, "Transfer amount must be greater than zero");
1010         
1011         if(!tradingActive){
1012             require(_isExcludedFromFee[from] || _isExcludedFromFee[to], "Trading is not active yet.");
1013         }
1014         
1015         
1016         
1017         if(limitsInEffect){
1018             if (
1019                 from != owner() &&
1020                 to != owner() &&
1021                 to != address(0) &&
1022                 to != address(0xdead) &&
1023                 !inSwapAndLiquify
1024             ){
1025                 
1026                 if(from != owner() && to != uniswapV2Pair && block.number == tradingActiveBlock){
1027                     boughtEarly[to] = true;
1028                     emit BoughtEarly(to);
1029                 }
1030                 
1031                 // only use to prevent sniper buys in the first blocks.
1032                 if (gasLimitActive && automatedMarketMakerPairs[from]) {
1033                     require(tx.gasprice <= gasPriceLimit, "Gas price exceeds limit.");
1034                 }
1035                 
1036                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1037                 if (transferDelayEnabled){
1038                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1039                         require(_holderLastTransferTimestamp[to] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1040                         _holderLastTransferTimestamp[to] = block.number;
1041                     }
1042                 }
1043                 
1044                 //when buy
1045                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1046                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1047                 } 
1048                 //when sell
1049                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1050                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1051                 }
1052             }
1053         }
1054         
1055         
1056         
1057         uint256 totalTokensToSwap = _liquidityTokensToSwap.add(_marketingTokensToSwap);
1058         uint256 contractTokenBalance = balanceOf(address(this));
1059         bool overMinimumTokenBalance = contractTokenBalance >= minimumTokensBeforeSwap;
1060 
1061         // swap and liquify
1062         if (
1063             !inSwapAndLiquify &&
1064             swapAndLiquifyEnabled &&
1065             balanceOf(uniswapV2Pair) > 0 &&
1066             totalTokensToSwap > 0 &&
1067             !_isExcludedFromFee[to] &&
1068             !_isExcludedFromFee[from] &&
1069             automatedMarketMakerPairs[to] &&
1070             overMinimumTokenBalance
1071         ) {
1072             swapBack();
1073         }
1074 
1075         bool takeFee = true;
1076 
1077         // If any account belongs to _isExcludedFromFee account then remove the fee
1078         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
1079             takeFee = false;
1080             buyOrSellSwitch = TRANSFER; // TRANSFERs do not pay a tax.
1081         } else {
1082             // Buy
1083             if (automatedMarketMakerPairs[from]) {
1084                 removeAllFee();
1085                 _taxFee = _buyTaxFee;
1086                 _liquidityFee = _buyLiquidityFee + _buyMarketingFee;
1087                 buyOrSellSwitch = BUY;
1088             } 
1089             // Sell
1090             else if (automatedMarketMakerPairs[to]) {
1091                 removeAllFee();
1092                 _taxFee = _sellTaxFee;
1093                 _liquidityFee = _sellLiquidityFee + _sellMarketingFee;
1094                 buyOrSellSwitch = SELL;
1095                 // higher tax if bought in the same block as trading active for 72 hours (sniper protect)
1096                 if(boughtEarly[from] && earlyBuyPenaltyEnd > block.timestamp){
1097                     _taxFee = _taxFee * 5;
1098                     _liquidityFee = _liquidityFee * 5;
1099                 }
1100             // Normal transfers do not get taxed
1101             } else {
1102                 require(!boughtEarly[from] || earlyBuyPenaltyEnd <= block.timestamp, "Snipers can't transfer tokens to sell cheaper until penalty timeframe is over.  DM a Mod.");
1103                 removeAllFee();
1104                 buyOrSellSwitch = TRANSFER; // TRANSFERs do not pay a tax.
1105             }
1106         }
1107         
1108         _tokenTransfer(from, to, amount, takeFee);
1109         
1110     }
1111 
1112     function swapBack() private lockTheSwap {
1113         uint256 contractBalance = balanceOf(address(this));
1114         uint256 totalTokensToSwap = _liquidityTokensToSwap + _marketingTokensToSwap;
1115         
1116         // Halve the amount of liquidity tokens
1117         uint256 tokensForLiquidity = _liquidityTokensToSwap.div(2);
1118         uint256 amountToSwapForETH = contractBalance.sub(tokensForLiquidity);
1119         
1120         uint256 initialETHBalance = address(this).balance;
1121 
1122         swapTokensForETH(amountToSwapForETH); 
1123         
1124         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1125         
1126         uint256 ethForMarketing = ethBalance.mul(_marketingTokensToSwap).div(totalTokensToSwap);
1127         
1128         uint256 ethForLiquidity = ethBalance.sub(ethForMarketing);
1129         
1130         uint256 ethForDev= ethForMarketing * 2 / 7; // 2/7 gos to dev
1131         ethForMarketing -= ethForDev;
1132         
1133         _liquidityTokensToSwap = 0;
1134         _marketingTokensToSwap = 0;
1135         
1136         (bool success,) = address(marketingAddress).call{value: ethForMarketing}("");
1137         (success,) = address(devAddress).call{value: ethForDev}("");
1138         
1139         addLiquidity(tokensForLiquidity, ethForLiquidity);
1140         emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1141         
1142         // send leftover BNB to the marketing wallet so it doesn't get stuck on the contract.
1143         if(address(this).balance > 1e17){
1144             (success,) = address(marketingAddress).call{value: address(this).balance}("");
1145         }
1146     }
1147     
1148     // force Swap back if slippage above 49% for launch.
1149     function forceSwapBack() external onlyOwner {
1150         uint256 contractBalance = balanceOf(address(this));
1151         require(contractBalance >= _tTotal / 100, "Can only swap back if more than 1% of tokens stuck on contract");
1152         swapBack();
1153         emit OwnerForcedSwapBack(block.timestamp);
1154     }
1155     
1156     function swapTokensForETH(uint256 tokenAmount) private {
1157         address[] memory path = new address[](2);
1158         path[0] = address(this);
1159         path[1] = uniswapV2Router.WETH();
1160         _approve(address(this), address(uniswapV2Router), tokenAmount);
1161         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1162             tokenAmount,
1163             0, // accept any amount of ETH
1164             path,
1165             address(this),
1166             block.timestamp
1167         );
1168     }
1169     
1170     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1171         _approve(address(this), address(uniswapV2Router), tokenAmount);
1172         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1173             address(this),
1174             tokenAmount,
1175             0, // slippage is unavoidable
1176             0, // slippage is unavoidable
1177             liquidityAddress,
1178             block.timestamp
1179         );
1180     }
1181 
1182     function _tokenTransfer(
1183         address sender,
1184         address recipient,
1185         uint256 amount,
1186         bool takeFee
1187     ) private {
1188         if (!takeFee) removeAllFee();
1189 
1190         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1191             _transferFromExcluded(sender, recipient, amount);
1192         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1193             _transferToExcluded(sender, recipient, amount);
1194         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1195             _transferBothExcluded(sender, recipient, amount);
1196         } else {
1197             _transferStandard(sender, recipient, amount);
1198         }
1199 
1200         if (!takeFee) restoreAllFee();
1201     }
1202 
1203     function _transferStandard(
1204         address sender,
1205         address recipient,
1206         uint256 tAmount
1207     ) private {
1208         (
1209             uint256 rAmount,
1210             uint256 rTransferAmount,
1211             uint256 rFee,
1212             uint256 tTransferAmount,
1213             uint256 tFee,
1214             uint256 tLiquidity
1215         ) = _getValues(tAmount);
1216         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1217         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1218         _takeLiquidity(tLiquidity);
1219         _reflectFee(rFee, tFee);
1220         emit Transfer(sender, recipient, tTransferAmount);
1221     }
1222 
1223     function _transferToExcluded(
1224         address sender,
1225         address recipient,
1226         uint256 tAmount
1227     ) private {
1228         (
1229             uint256 rAmount,
1230             uint256 rTransferAmount,
1231             uint256 rFee,
1232             uint256 tTransferAmount,
1233             uint256 tFee,
1234             uint256 tLiquidity
1235         ) = _getValues(tAmount);
1236         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1237         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1238         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1239         _takeLiquidity(tLiquidity);
1240         _reflectFee(rFee, tFee);
1241         emit Transfer(sender, recipient, tTransferAmount);
1242     }
1243 
1244     function _transferFromExcluded(
1245         address sender,
1246         address recipient,
1247         uint256 tAmount
1248     ) private {
1249         (
1250             uint256 rAmount,
1251             uint256 rTransferAmount,
1252             uint256 rFee,
1253             uint256 tTransferAmount,
1254             uint256 tFee,
1255             uint256 tLiquidity
1256         ) = _getValues(tAmount);
1257         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1258         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1259         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1260         _takeLiquidity(tLiquidity);
1261         _reflectFee(rFee, tFee);
1262         emit Transfer(sender, recipient, tTransferAmount);
1263     }
1264 
1265     function _transferBothExcluded(
1266         address sender,
1267         address recipient,
1268         uint256 tAmount
1269     ) private {
1270         (
1271             uint256 rAmount,
1272             uint256 rTransferAmount,
1273             uint256 rFee,
1274             uint256 tTransferAmount,
1275             uint256 tFee,
1276             uint256 tLiquidity
1277         ) = _getValues(tAmount);
1278         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1279         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1280         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1281         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1282         _takeLiquidity(tLiquidity);
1283         _reflectFee(rFee, tFee);
1284         emit Transfer(sender, recipient, tTransferAmount);
1285     }
1286 
1287     function _reflectFee(uint256 rFee, uint256 tFee) private {
1288         _rTotal = _rTotal.sub(rFee);
1289         _tFeeTotal = _tFeeTotal.add(tFee);
1290     }
1291 
1292     function _getValues(uint256 tAmount)
1293         private
1294         view
1295         returns (
1296             uint256,
1297             uint256,
1298             uint256,
1299             uint256,
1300             uint256,
1301             uint256
1302         )
1303     {
1304         (
1305             uint256 tTransferAmount,
1306             uint256 tFee,
1307             uint256 tLiquidity
1308         ) = _getTValues(tAmount);
1309         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
1310             tAmount,
1311             tFee,
1312             tLiquidity,
1313             _getRate()
1314         );
1315         return (
1316             rAmount,
1317             rTransferAmount,
1318             rFee,
1319             tTransferAmount,
1320             tFee,
1321             tLiquidity
1322         );
1323     }
1324 
1325     function _getTValues(uint256 tAmount)
1326         private
1327         view
1328         returns (
1329             uint256,
1330             uint256,
1331             uint256
1332         )
1333     {
1334         uint256 tFee = calculateTaxFee(tAmount);
1335         uint256 tLiquidity = calculateLiquidityFee(tAmount);
1336         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
1337         return (tTransferAmount, tFee, tLiquidity);
1338     }
1339 
1340     function _getRValues(
1341         uint256 tAmount,
1342         uint256 tFee,
1343         uint256 tLiquidity,
1344         uint256 currentRate
1345     )
1346         private
1347         pure
1348         returns (
1349             uint256,
1350             uint256,
1351             uint256
1352         )
1353     {
1354         uint256 rAmount = tAmount.mul(currentRate);
1355         uint256 rFee = tFee.mul(currentRate);
1356         uint256 rLiquidity = tLiquidity.mul(currentRate);
1357         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
1358         return (rAmount, rTransferAmount, rFee);
1359     }
1360 
1361     function _getRate() private view returns (uint256) {
1362         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1363         return rSupply.div(tSupply);
1364     }
1365 
1366     function _getCurrentSupply() private view returns (uint256, uint256) {
1367         uint256 rSupply = _rTotal;
1368         uint256 tSupply = _tTotal;
1369         for (uint256 i = 0; i < _excluded.length; i++) {
1370             if (
1371                 _rOwned[_excluded[i]] > rSupply ||
1372                 _tOwned[_excluded[i]] > tSupply
1373             ) return (_rTotal, _tTotal);
1374             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1375             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1376         }
1377         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1378         return (rSupply, tSupply);
1379     }
1380 
1381     function _takeLiquidity(uint256 tLiquidity) private {
1382         if(buyOrSellSwitch == BUY){
1383             _liquidityTokensToSwap += tLiquidity * _buyLiquidityFee / _liquidityFee;
1384             _marketingTokensToSwap += tLiquidity * _buyMarketingFee / _liquidityFee;
1385         } else if(buyOrSellSwitch == SELL){
1386             _liquidityTokensToSwap += tLiquidity * _sellLiquidityFee / _liquidityFee;
1387             _marketingTokensToSwap += tLiquidity * _sellMarketingFee / _liquidityFee;
1388         }
1389         uint256 currentRate = _getRate();
1390         uint256 rLiquidity = tLiquidity.mul(currentRate);
1391         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1392         if (_isExcluded[address(this)])
1393             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1394     }
1395 
1396     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1397         return _amount.mul(_taxFee).div(10**2);
1398     }
1399 
1400     function calculateLiquidityFee(uint256 _amount)
1401         private
1402         view
1403         returns (uint256)
1404     {
1405         return _amount.mul(_liquidityFee).div(10**2);
1406     }
1407 
1408     function removeAllFee() private {
1409         if (_taxFee == 0 && _liquidityFee == 0) return;
1410 
1411         _previousTaxFee = _taxFee;
1412         _previousLiquidityFee = _liquidityFee;
1413 
1414         _taxFee = 0;
1415         _liquidityFee = 0;
1416     }
1417 
1418     function restoreAllFee() private {
1419         _taxFee = _previousTaxFee;
1420         _liquidityFee = _previousLiquidityFee;
1421     }
1422 
1423     function isExcludedFromFee(address account) external view returns (bool) {
1424         return _isExcludedFromFee[account];
1425     }
1426     
1427      function removeBoughtEarly(address account) external onlyOwner {
1428         boughtEarly[account] = false;
1429         emit RemovedSniper(account);
1430     }
1431 
1432     function excludeFromFee(address account) external onlyOwner {
1433         _isExcludedFromFee[account] = true;
1434         emit ExcludeFromFee(account);
1435     }
1436 
1437     function includeInFee(address account) external onlyOwner {
1438         _isExcludedFromFee[account] = false;
1439         emit IncludeInFee(account);
1440     }
1441 
1442     function setBuyFee(uint256 buyTaxFee, uint256 buyLiquidityFee, uint256 buyMarketingFee)
1443         external
1444         onlyOwner
1445     {
1446         _buyTaxFee = buyTaxFee;
1447         _buyLiquidityFee = buyLiquidityFee;
1448         _buyMarketingFee = buyMarketingFee;
1449         require(_buyTaxFee + _buyLiquidityFee + _buyMarketingFee <= 10, "Must keep buy taxes below 10%");
1450         emit SetBuyFee(buyMarketingFee, buyLiquidityFee, buyTaxFee);
1451     }
1452 
1453     function setSellFee(uint256 sellTaxFee, uint256 sellLiquidityFee, uint256 sellMarketingFee)
1454         external
1455         onlyOwner
1456     {
1457         _sellTaxFee = sellTaxFee;
1458         _sellLiquidityFee = sellLiquidityFee;
1459         _sellMarketingFee = sellMarketingFee;
1460         require(_sellTaxFee + _sellLiquidityFee + _sellMarketingFee <= 15, "Must keep sell taxes below 15%");
1461         emit SetSellFee(sellMarketingFee, sellLiquidityFee, sellTaxFee);
1462     }
1463 
1464 
1465     function setMarketingAddress(address _marketingAddress) external onlyOwner {
1466         require(_marketingAddress != address(0), "_marketingAddress address cannot be 0");
1467         _isExcludedFromFee[marketingAddress] = false;
1468         marketingAddress = payable(_marketingAddress);
1469         _isExcludedFromFee[marketingAddress] = true;
1470         emit UpdatedMarketingAddress(_marketingAddress);
1471     }
1472     
1473     function setLiquidityAddress(address _liquidityAddress) public onlyOwner {
1474         require(_liquidityAddress != address(0), "_liquidityAddress address cannot be 0");
1475         liquidityAddress = payable(_liquidityAddress);
1476         _isExcludedFromFee[liquidityAddress] = true;
1477         emit UpdatedLiquidityAddress(_liquidityAddress);
1478     }
1479 
1480     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1481         swapAndLiquifyEnabled = _enabled;
1482         emit SwapAndLiquifyEnabledUpdated(_enabled);
1483     }
1484 
1485     // To receive ETH from uniswapV2Router when swapping
1486     receive() external payable {}
1487 
1488     function transferForeignToken(address _token, address _to)
1489         external
1490         onlyOwner
1491         returns (bool _sent)
1492     {
1493         require(_token != address(0), "_token address cannot be 0");
1494         require(_token != address(this), "Can't withdraw native tokens");
1495         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
1496         _sent = IERC20(_token).transfer(_to, _contractBalance);
1497         emit TransferForeignToken(_token, _contractBalance);
1498     }
1499     
1500     // withdraw ETH if stuck before launch
1501     function withdrawStuckETH() external onlyOwner {
1502         require(!tradingActive, "Can only withdraw if trading hasn't started");
1503         bool success;
1504         (success,) = address(msg.sender).call{value: address(this).balance}("");
1505     }
1506 }