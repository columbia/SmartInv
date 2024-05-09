1 /**
2  *Submitted for verification at Etherscan.io on 2021-11-30
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity 0.8.9;
8 
9 abstract contract Context {
10     function _msgSender() internal view virtual returns (address payable) {
11         return payable(msg.sender);
12     }
13 
14     function _msgData() internal view virtual returns (bytes memory) {
15         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
16         return msg.data;
17     }
18 }
19 
20 interface IERC20 {
21     function totalSupply() external view returns (uint256);
22 
23     function balanceOf(address account) external view returns (uint256);
24 
25     function transfer(address recipient, uint256 amount)
26         external
27         returns (bool);
28 
29     function allowance(address owner, address spender)
30         external
31         view
32         returns (uint256);
33 
34     function approve(address spender, uint256 amount) external returns (bool);
35 
36     function transferFrom(
37         address sender,
38         address recipient,
39         uint256 amount
40     ) external returns (bool);
41 
42     event Transfer(address indexed from, address indexed to, uint256 value);
43     event Approval(
44         address indexed owner,
45         address indexed spender,
46         uint256 value
47     );
48 }
49 
50 library SafeMath {
51     function add(uint256 a, uint256 b) internal pure returns (uint256) {
52         uint256 c = a + b;
53         require(c >= a, "SafeMath: addition overflow");
54 
55         return c;
56     }
57 
58     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
59         return sub(a, b, "SafeMath: subtraction overflow");
60     }
61 
62     function sub(
63         uint256 a,
64         uint256 b,
65         string memory errorMessage
66     ) internal pure returns (uint256) {
67         require(b <= a, errorMessage);
68         uint256 c = a - b;
69 
70         return c;
71     }
72 
73     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
74         if (a == 0) {
75             return 0;
76         }
77 
78         uint256 c = a * b;
79         require(c / a == b, "SafeMath: multiplication overflow");
80 
81         return c;
82     }
83 
84     function div(uint256 a, uint256 b) internal pure returns (uint256) {
85         return div(a, b, "SafeMath: division by zero");
86     }
87 
88     function div(
89         uint256 a,
90         uint256 b,
91         string memory errorMessage
92     ) internal pure returns (uint256) {
93         require(b > 0, errorMessage);
94         uint256 c = a / b;
95         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
96 
97         return c;
98     }
99 
100     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
101         return mod(a, b, "SafeMath: modulo by zero");
102     }
103 
104     function mod(
105         uint256 a,
106         uint256 b,
107         string memory errorMessage
108     ) internal pure returns (uint256) {
109         require(b != 0, errorMessage);
110         return a % b;
111     }
112 }
113 
114 library Address {
115     function isContract(address account) internal view returns (bool) {
116         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
117         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
118         // for accounts without code, i.e. `keccak256('')`
119         bytes32 codehash;
120         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
121         // solhint-disable-next-line no-inline-assembly
122         assembly {
123             codehash := extcodehash(account)
124         }
125         return (codehash != accountHash && codehash != 0x0);
126     }
127 
128     function sendValue(address payable recipient, uint256 amount) internal {
129         require(
130             address(this).balance >= amount,
131             "Address: insufficient balance"
132         );
133 
134         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
135         (bool success, ) = recipient.call{value: amount}("");
136         require(
137             success,
138             "Address: unable to send value, recipient may have reverted"
139         );
140     }
141 
142     function functionCall(address target, bytes memory data)
143         internal
144         returns (bytes memory)
145     {
146         return functionCall(target, data, "Address: low-level call failed");
147     }
148 
149     function functionCall(
150         address target,
151         bytes memory data,
152         string memory errorMessage
153     ) internal returns (bytes memory) {
154         return _functionCallWithValue(target, data, 0, errorMessage);
155     }
156 
157     function functionCallWithValue(
158         address target,
159         bytes memory data,
160         uint256 value
161     ) internal returns (bytes memory) {
162         return
163             functionCallWithValue(
164                 target,
165                 data,
166                 value,
167                 "Address: low-level call with value failed"
168             );
169     }
170 
171     function functionCallWithValue(
172         address target,
173         bytes memory data,
174         uint256 value,
175         string memory errorMessage
176     ) internal returns (bytes memory) {
177         require(
178             address(this).balance >= value,
179             "Address: insufficient balance for call"
180         );
181         return _functionCallWithValue(target, data, value, errorMessage);
182     }
183 
184     function _functionCallWithValue(
185         address target,
186         bytes memory data,
187         uint256 weiValue,
188         string memory errorMessage
189     ) private returns (bytes memory) {
190         require(isContract(target), "Address: call to non-contract");
191 
192         (bool success, bytes memory returndata) = target.call{value: weiValue}(
193             data
194         );
195         if (success) {
196             return returndata;
197         } else {
198             if (returndata.length > 0) {
199                 assembly {
200                     let returndata_size := mload(returndata)
201                     revert(add(32, returndata), returndata_size)
202                 }
203             } else {
204                 revert(errorMessage);
205             }
206         }
207     }
208 }
209 
210 contract Ownable is Context {
211     address private _owner;
212     address private _previousOwner;
213     uint256 private _lockTime;
214 
215     event OwnershipTransferred(
216         address indexed previousOwner,
217         address indexed newOwner
218     );
219 
220     constructor() {
221         address msgSender = _msgSender();
222         _owner = msgSender;
223         emit OwnershipTransferred(address(0), msgSender);
224     }
225 
226     function owner() public view returns (address) {
227         return _owner;
228     }
229 
230     modifier onlyOwner() {
231         require(_owner == _msgSender(), "Ownable: caller is not the owner");
232         _;
233     }
234 
235     function renounceOwnership() public virtual onlyOwner {
236         emit OwnershipTransferred(_owner, address(0));
237         _owner = address(0);
238     }
239 
240     function transferOwnership(address newOwner) public virtual onlyOwner {
241         require(
242             newOwner != address(0),
243             "Ownable: new owner is the zero address"
244         );
245         emit OwnershipTransferred(_owner, newOwner);
246         _owner = newOwner;
247     }
248 
249     function getUnlockTime() public view returns (uint256) {
250         return _lockTime;
251     }
252 
253     function getTime() public view returns (uint256) {
254         return block.timestamp;
255     }
256 }
257 
258 
259 interface IUniswapV2Factory {
260     event PairCreated(
261         address indexed token0,
262         address indexed token1,
263         address pair,
264         uint256
265     );
266 
267     function feeTo() external view returns (address);
268 
269     function feeToSetter() external view returns (address);
270 
271     function getPair(address tokenA, address tokenB)
272         external
273         view
274         returns (address pair);
275 
276     function allPairs(uint256) external view returns (address pair);
277 
278     function allPairsLength() external view returns (uint256);
279 
280     function createPair(address tokenA, address tokenB)
281         external
282         returns (address pair);
283 
284     function setFeeTo(address) external;
285 
286     function setFeeToSetter(address) external;
287 }
288 
289 
290 interface IUniswapV2Pair {
291     event Approval(
292         address indexed owner,
293         address indexed spender,
294         uint256 value
295     );
296     event Transfer(address indexed from, address indexed to, uint256 value);
297 
298     function name() external pure returns (string memory);
299 
300     function symbol() external pure returns (string memory);
301 
302     function decimals() external pure returns (uint8);
303 
304     function totalSupply() external view returns (uint256);
305 
306     function balanceOf(address owner) external view returns (uint256);
307 
308     function allowance(address owner, address spender)
309         external
310         view
311         returns (uint256);
312 
313     function approve(address spender, uint256 value) external returns (bool);
314 
315     function transfer(address to, uint256 value) external returns (bool);
316 
317     function transferFrom(
318         address from,
319         address to,
320         uint256 value
321     ) external returns (bool);
322 
323     function DOMAIN_SEPARATOR() external view returns (bytes32);
324 
325     function PERMIT_TYPEHASH() external pure returns (bytes32);
326 
327     function nonces(address owner) external view returns (uint256);
328 
329     function permit(
330         address owner,
331         address spender,
332         uint256 value,
333         uint256 deadline,
334         uint8 v,
335         bytes32 r,
336         bytes32 s
337     ) external;
338 
339     event Burn(
340         address indexed sender,
341         uint256 amount0,
342         uint256 amount1,
343         address indexed to
344     );
345     event Swap(
346         address indexed sender,
347         uint256 amount0In,
348         uint256 amount1In,
349         uint256 amount0Out,
350         uint256 amount1Out,
351         address indexed to
352     );
353     event Sync(uint112 reserve0, uint112 reserve1);
354 
355     function MINIMUM_LIQUIDITY() external pure returns (uint256);
356 
357     function factory() external view returns (address);
358 
359     function token0() external view returns (address);
360 
361     function token1() external view returns (address);
362 
363     function getReserves()
364         external
365         view
366         returns (
367             uint112 reserve0,
368             uint112 reserve1,
369             uint32 blockTimestampLast
370         );
371 
372     function price0CumulativeLast() external view returns (uint256);
373 
374     function price1CumulativeLast() external view returns (uint256);
375 
376     function kLast() external view returns (uint256);
377 
378     function burn(address to)
379         external
380         returns (uint256 amount0, uint256 amount1);
381 
382     function swap(
383         uint256 amount0Out,
384         uint256 amount1Out,
385         address to,
386         bytes calldata data
387     ) external;
388 
389     function skim(address to) external;
390 
391     function sync() external;
392 
393     function initialize(address, address) external;
394 }
395 
396 interface IUniswapV2Router01 {
397     function factory() external pure returns (address);
398 
399     function WETH() external pure returns (address);
400 
401     function addLiquidity(
402         address tokenA,
403         address tokenB,
404         uint256 amountADesired,
405         uint256 amountBDesired,
406         uint256 amountAMin,
407         uint256 amountBMin,
408         address to,
409         uint256 deadline
410     )
411         external
412         returns (
413             uint256 amountA,
414             uint256 amountB,
415             uint256 liquidity
416         );
417 
418     function addLiquidityETH(
419         address token,
420         uint256 amountTokenDesired,
421         uint256 amountTokenMin,
422         uint256 amountETHMin,
423         address to,
424         uint256 deadline
425     )
426         external
427         payable
428         returns (
429             uint256 amountToken,
430             uint256 amountETH,
431             uint256 liquidity
432         );
433 
434     function removeLiquidity(
435         address tokenA,
436         address tokenB,
437         uint256 liquidity,
438         uint256 amountAMin,
439         uint256 amountBMin,
440         address to,
441         uint256 deadline
442     ) external returns (uint256 amountA, uint256 amountB);
443 
444     function removeLiquidityETH(
445         address token,
446         uint256 liquidity,
447         uint256 amountTokenMin,
448         uint256 amountETHMin,
449         address to,
450         uint256 deadline
451     ) external returns (uint256 amountToken, uint256 amountETH);
452 
453     function removeLiquidityWithPermit(
454         address tokenA,
455         address tokenB,
456         uint256 liquidity,
457         uint256 amountAMin,
458         uint256 amountBMin,
459         address to,
460         uint256 deadline,
461         bool approveMax,
462         uint8 v,
463         bytes32 r,
464         bytes32 s
465     ) external returns (uint256 amountA, uint256 amountB);
466 
467     function removeLiquidityETHWithPermit(
468         address token,
469         uint256 liquidity,
470         uint256 amountTokenMin,
471         uint256 amountETHMin,
472         address to,
473         uint256 deadline,
474         bool approveMax,
475         uint8 v,
476         bytes32 r,
477         bytes32 s
478     ) external returns (uint256 amountToken, uint256 amountETH);
479 
480     function swapExactTokensForTokens(
481         uint256 amountIn,
482         uint256 amountOutMin,
483         address[] calldata path,
484         address to,
485         uint256 deadline
486     ) external returns (uint256[] memory amounts);
487 
488     function swapTokensForExactTokens(
489         uint256 amountOut,
490         uint256 amountInMax,
491         address[] calldata path,
492         address to,
493         uint256 deadline
494     ) external returns (uint256[] memory amounts);
495 
496     function swapExactETHForTokens(
497         uint256 amountOutMin,
498         address[] calldata path,
499         address to,
500         uint256 deadline
501     ) external payable returns (uint256[] memory amounts);
502 
503     function swapTokensForExactETH(
504         uint256 amountOut,
505         uint256 amountInMax,
506         address[] calldata path,
507         address to,
508         uint256 deadline
509     ) external returns (uint256[] memory amounts);
510 
511     function swapExactTokensForETH(
512         uint256 amountIn,
513         uint256 amountOutMin,
514         address[] calldata path,
515         address to,
516         uint256 deadline
517     ) external returns (uint256[] memory amounts);
518 
519     function swapETHForExactTokens(
520         uint256 amountOut,
521         address[] calldata path,
522         address to,
523         uint256 deadline
524     ) external payable returns (uint256[] memory amounts);
525 
526     function quote(
527         uint256 amountA,
528         uint256 reserveA,
529         uint256 reserveB
530     ) external pure returns (uint256 amountB);
531 
532     function getAmountOut(
533         uint256 amountIn,
534         uint256 reserveIn,
535         uint256 reserveOut
536     ) external pure returns (uint256 amountOut);
537 
538     function getAmountIn(
539         uint256 amountOut,
540         uint256 reserveIn,
541         uint256 reserveOut
542     ) external pure returns (uint256 amountIn);
543 
544     function getAmountsOut(uint256 amountIn, address[] calldata path)
545         external
546         view
547         returns (uint256[] memory amounts);
548 
549     function getAmountsIn(uint256 amountOut, address[] calldata path)
550         external
551         view
552         returns (uint256[] memory amounts);
553 }
554 
555 interface IUniswapV2Router02 is IUniswapV2Router01 {
556     function removeLiquidityETHSupportingFeeOnTransferTokens(
557         address token,
558         uint256 liquidity,
559         uint256 amountTokenMin,
560         uint256 amountETHMin,
561         address to,
562         uint256 deadline
563     ) external returns (uint256 amountETH);
564 
565     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
566         address token,
567         uint256 liquidity,
568         uint256 amountTokenMin,
569         uint256 amountETHMin,
570         address to,
571         uint256 deadline,
572         bool approveMax,
573         uint8 v,
574         bytes32 r,
575         bytes32 s
576     ) external returns (uint256 amountETH);
577 
578     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
579         uint256 amountIn,
580         uint256 amountOutMin,
581         address[] calldata path,
582         address to,
583         uint256 deadline
584     ) external;
585 
586     function swapExactETHForTokensSupportingFeeOnTransferTokens(
587         uint256 amountOutMin,
588         address[] calldata path,
589         address to,
590         uint256 deadline
591     ) external payable;
592 
593     function swapExactTokensForETHSupportingFeeOnTransferTokens(
594         uint256 amountIn,
595         uint256 amountOutMin,
596         address[] calldata path,
597         address to,
598         uint256 deadline
599     ) external;
600 }
601 
602 contract MetaverseCapital is Context, IERC20, Ownable {
603     using SafeMath for uint256;
604     using Address for address;
605 
606     address payable public treasuryAddress = payable(0x89465e5552bFda9b8482e582ed497aA02aA8CEb7); // Treasury Address
607 
608     address payable public liquidityAddress =
609         payable(0x69f671B159De297358e900e983caA3CB1C2aE019); // Liquidity Address
610                 
611     address payable public devAddress =
612         payable(0x69f671B159De297358e900e983caA3CB1C2aE019); // Buyback Address
613         
614     address public immutable deadAddress =
615         0x000000000000000000000000000000000000dEaD; // dead address
616         
617     mapping(address => uint256) private _rOwned;
618     mapping(address => uint256) private _tOwned;
619     mapping(address => mapping(address => uint256)) private _allowances;
620 
621     mapping(address => bool) private _isExcludedFromFee;
622 
623     mapping(address => bool) private _isExcluded;
624     address[] private _excluded;
625     
626     uint256 private constant MAX = ~uint256(0);
627     uint256 private constant _tTotal = 1 * 1e9 * 1e9;
628     uint256 private _rTotal = (MAX - (MAX % _tTotal));
629     uint256 private _tFeeTotal;
630 
631     string private constant _name = "Metaverse Capital";
632     string private constant _symbol = "MVC";
633     uint8 private constant _decimals = 9;
634     
635     uint256 private constant BUY = 1;
636     uint256 private constant SELL = 2;
637     uint256 private constant TRANSFER = 3;
638     uint256 private buyOrSellSwitch;
639 
640     // these values are pretty much arbitrary since they get overwritten for every txn, but the placeholders make it easier to work with current contract.
641     uint256 private _taxFee;
642     uint256 private _previousTaxFee = _taxFee;
643 
644     uint256 private _liquidityFee;
645     uint256 private _previousLiquidityFee = _liquidityFee;
646 
647     uint256 public _buyTaxFee = 0;
648     uint256 public _buyLiquidityFee = 0;
649     uint256 public _buyTreasuryFee = 10;
650     uint256 public _buyBuybackFee = 0;
651 
652     uint256 public _sellTaxFee = 0;
653     uint256 public _sellLiquidityFee = 0;
654     uint256 public _sellTreasuryFee = 10;
655     uint256 public _sellBuybackFee = 0;
656     
657     uint256 public liquidityActiveBlock = 0; // 0 means liquidity is not active yet
658     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
659     mapping(address => bool) public boughtEarly;
660     uint256 public earlyBuyPenaltyEnd; // determines when snipers/bots can sell without extra penalty
661     
662     bool public limitsInEffect = true;
663     bool public tradingActive = false;
664     bool public swapEnabled = false;
665     
666     mapping (address => bool) public _isExcludedMaxTransactionAmount;
667     
668      // Anti-bot and anti-whale mappings and variables
669     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
670     bool public transferDelayEnabled = true;
671     
672     uint256 private _liquidityTokensToSwap;
673     uint256 private _treasuryTokensToSwap;
674     uint256 private _devTokensToSwap;
675     
676     bool private gasLimitActive = true;
677     uint256 private gasPriceLimit = 200 * 1 gwei;
678     
679     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
680     // could be subject to a maximum transfer amount
681     mapping (address => bool) public automatedMarketMakerPairs;
682 
683     uint256 public minimumTokensBeforeSwap = _tTotal * 5 / 10000; // 0.05%
684     uint256 public maxBuyAmount;
685     uint256 public maxSellAmount;
686     uint256 public maxWallet;
687 
688     IUniswapV2Router02 public uniswapV2Router;
689     address public uniswapV2Pair;
690 
691     bool inSwapAndLiquify;
692     bool public swapAndLiquifyEnabled = false;
693 
694     event RewardLiquidityProviders(uint256 tokenAmount);
695     event SwapAndLiquifyEnabledUpdated(bool enabled);
696     event SwapAndLiquify(
697         uint256 tokensSwapped,
698         uint256 ethReceived,
699         uint256 tokensIntoLiqudity
700     );
701 
702     event SwapETHForTokens(uint256 amountIn, address[] path);
703 
704     event SwapTokensForETH(uint256 amountIn, address[] path);
705     
706     event UpdatedMaxBuyAmount(uint256 newAmount);
707 
708     event UpdatedMaxSellAmount(uint256 newAmount);
709     
710     event ExcludedMaxTransactionAmount(address indexed account, bool isExcluded);
711 
712     modifier lockTheSwap() {
713         inSwapAndLiquify = true;
714         _;
715         inSwapAndLiquify = false;
716     }
717 
718     constructor() payable {
719         address newOwner = msg.sender;
720         address futureOwner = address(msg.sender);
721         
722         maxBuyAmount = _tTotal * 5 / 1000; // 0.5% maxTransactionAmountTxn
723         maxSellAmount = _tTotal * 5 / 1000; // 0.5% maxTransactionAmountTxn
724         maxWallet = _tTotal * 5 / 1000; // 0.5% max txn
725         
726         _rOwned[newOwner] = _rTotal;
727 
728         _isExcludedFromFee[newOwner] = true;
729         _isExcludedFromFee[futureOwner] = true; // pre-exclude future owner wallet
730         _isExcludedFromFee[address(this)] = true;
731         _isExcludedFromFee[treasuryAddress] = true;
732         _isExcludedFromFee[liquidityAddress] = true;
733         _isExcludedFromFee[devAddress] = true;
734         
735         excludeFromMaxTransaction(newOwner, true);
736         excludeFromMaxTransaction(futureOwner, true); // pre-exclude future owner wallet
737         excludeFromMaxTransaction(address(this), true);
738         excludeFromMaxTransaction(address(0xdead), true);
739         excludeFromMaxTransaction(address(liquidityAddress), true);
740         excludeFromMaxTransaction(address(devAddress), true);
741         
742         emit Transfer(address(0), newOwner, _tTotal);
743     }
744 
745     function name() external pure returns (string memory) {
746         return _name;
747     }
748 
749     function symbol() external pure returns (string memory) {
750         return _symbol;
751     }
752 
753     function decimals() external pure returns (uint8) {
754         return _decimals;
755     }
756 
757     function totalSupply() external pure override returns (uint256) {
758         return _tTotal;
759     }
760 
761     function balanceOf(address account) public view override returns (uint256) {
762         if (_isExcluded[account]) return _tOwned[account];
763         return tokenFromReflection(_rOwned[account]);
764     }
765 
766     function transfer(address recipient, uint256 amount)
767         external
768         override
769         returns (bool)
770     {
771         _transfer(_msgSender(), recipient, amount);
772         return true;
773     }
774 
775     function allowance(address owner, address spender)
776         external
777         view
778         override
779         returns (uint256)
780     {
781         return _allowances[owner][spender];
782     }
783 
784     function approve(address spender, uint256 amount)
785         public
786         override
787         returns (bool)
788     {
789         _approve(_msgSender(), spender, amount);
790         return true;
791     }
792 
793     function transferFrom(
794         address sender,
795         address recipient,
796         uint256 amount
797     ) external override returns (bool) {
798         _transfer(sender, recipient, amount);
799         _approve(
800             sender,
801             _msgSender(),
802             _allowances[sender][_msgSender()].sub(
803                 amount,
804                 "ERC20: transfer amount exceeds allowance"
805             )
806         );
807         return true;
808     }
809 
810     function increaseAllowance(address spender, uint256 addedValue)
811         external
812         virtual
813         returns (bool)
814     {
815         _approve(
816             _msgSender(),
817             spender,
818             _allowances[_msgSender()][spender].add(addedValue)
819         );
820         return true;
821     }
822 
823     function decreaseAllowance(address spender, uint256 subtractedValue)
824         external
825         virtual
826         returns (bool)
827     {
828         _approve(
829             _msgSender(),
830             spender,
831             _allowances[_msgSender()][spender].sub(
832                 subtractedValue,
833                 "ERC20: decreased allowance below zero"
834             )
835         );
836         return true;
837     }
838 
839     function isExcludedFromReward(address account)
840         external
841         view
842         returns (bool)
843     {
844         return _isExcluded[account];
845     }
846 
847     function totalFees() external view returns (uint256) {
848         return _tFeeTotal;
849     }
850     
851     // once enabled, can never be turned off
852     function enableTrading() public onlyOwner {
853         tradingActive = true;
854         swapAndLiquifyEnabled = true;
855         tradingActiveBlock = block.number;
856         earlyBuyPenaltyEnd = block.timestamp + 72 hours;
857     }
858     
859     function minimumTokensBeforeSwapAmount() external view returns (uint256) {
860         return minimumTokensBeforeSwap;
861     }
862     
863     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
864         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
865 
866         _setAutomatedMarketMakerPair(pair, value);
867     }
868 
869     function _setAutomatedMarketMakerPair(address pair, bool value) private {
870         automatedMarketMakerPairs[pair] = value;
871         
872         excludeFromMaxTransaction(pair, value);
873         if(value){excludeFromReward(pair);}
874         if(!value){includeInReward(pair);}
875     }
876     
877     function setProtectionSettings(bool antiGas) external onlyOwner() {
878         gasLimitActive = antiGas;
879     }
880     
881     function setGasPriceLimit(uint256 gas) external onlyOwner {
882         require(gas >= 300);
883         gasPriceLimit = gas * 1 gwei;
884     }
885     
886     // disable Transfer delay
887     function disableTransferDelay() external onlyOwner returns (bool){
888         transferDelayEnabled = false;
889         return true;
890     }
891 
892     function reflectionFromToken(uint256 tAmount, bool deductTransferFee)
893         external
894         view
895         returns (uint256)
896     {
897         require(tAmount <= _tTotal, "Amount must be less than supply");
898         if (!deductTransferFee) {
899             (uint256 rAmount, , , , , ) = _getValues(tAmount);
900             return rAmount;
901         } else {
902             (, uint256 rTransferAmount, , , , ) = _getValues(tAmount);
903             return rTransferAmount;
904         }
905     }
906     
907     // for one-time airdrop feature after contract launch
908     function airdropToWallets(address[] memory airdropWallets, uint256[] memory amount) external onlyOwner() {
909         require(airdropWallets.length == amount.length, "airdropToWallets:: Arrays must be the same length");
910         removeAllFee();
911         buyOrSellSwitch = TRANSFER;
912         for(uint256 i = 0; i < airdropWallets.length; i++){
913             address wallet = airdropWallets[i];
914             uint256 airdropAmount = amount[i]  * (10**9);
915             _tokenTransfer(msg.sender, wallet, airdropAmount);
916         }
917         restoreAllFee();
918     }
919     
920     // remove limits after token is stable - 30-60 minutes
921     function removeLimits() external onlyOwner returns (bool){
922         limitsInEffect = false;
923         gasLimitActive = false;
924         transferDelayEnabled = false;
925         return true;
926     }
927 
928     function tokenFromReflection(uint256 rAmount)
929         public
930         view
931         returns (uint256)
932     {
933         require(
934             rAmount <= _rTotal,
935             "Amount must be less than total reflections"
936         );
937         uint256 currentRate = _getRate();
938         return rAmount.div(currentRate);
939     }
940 
941     function excludeFromReward(address account) public onlyOwner {
942         require(!_isExcluded[account], "Account is already excluded");
943         require(_excluded.length + 1 <= 50, "Cannot exclude more than 50 accounts.  Include a previously excluded address.");
944         if (_rOwned[account] > 0) {
945             _tOwned[account] = tokenFromReflection(_rOwned[account]);
946         }
947         _isExcluded[account] = true;
948         _excluded.push(account);
949     }
950     
951     function updateMaxBuyAmount(uint256 newNum) external onlyOwner { 
952         require(newNum >= (_tTotal * 5 / 1000)/1e9, "Cannot set max buy amount lower than 0.5%"); 
953         maxBuyAmount = newNum * (10**9); 
954         emit UpdatedMaxBuyAmount(maxBuyAmount); 
955     } 
956 
957     
958     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
959         require(newNum >= (_tTotal * 5 / 1000)/1e9, "Cannot set max sell amount lower than 0.5%");
960         maxSellAmount = newNum * (10**9);
961         emit UpdatedMaxSellAmount(maxSellAmount);
962     }
963     
964 
965     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
966         _isExcludedMaxTransactionAmount[updAds] = isEx;
967         emit ExcludedMaxTransactionAmount(updAds, isEx);
968     }
969 
970     function includeInReward(address account) public onlyOwner {
971         require(_isExcluded[account], "Account is not excluded");
972         for (uint256 i = 0; i < _excluded.length; i++) {
973             if (_excluded[i] == account) {
974                 _excluded[i] = _excluded[_excluded.length - 1];
975                 _tOwned[account] = 0;
976                 _isExcluded[account] = false;
977                 _excluded.pop();
978                 break;
979             }
980         }
981     }
982  
983     function _approve(
984         address owner,
985         address spender,
986         uint256 amount
987     ) private {
988         require(owner != address(0), "ERC20: approve from the zero address");
989         require(spender != address(0), "ERC20: approve to the zero address");
990 
991         _allowances[owner][spender] = amount;
992         emit Approval(owner, spender, amount);
993     }
994 
995     function _transfer(
996         address from,
997         address to,
998         uint256 amount
999     ) private {
1000         require(from != address(0), "ERC20: transfer from the zero address");
1001         require(to != address(0), "ERC20: transfer to the zero address");
1002         require(amount > 0, "Transfer amount must be greater than zero");
1003         
1004         if(!tradingActive){
1005             require(_isExcludedFromFee[from] || _isExcludedFromFee[to], "Trading is not active yet.");
1006         }
1007         
1008         if(limitsInEffect){
1009             if (
1010                 from != owner() &&
1011                 to != owner() &&
1012                 to != address(0) &&
1013                 to != address(0xdead) &&
1014                 !inSwapAndLiquify
1015             ){
1016                 
1017                 // only use to prevent sniper buys in the first blocks.
1018                 if (gasLimitActive && automatedMarketMakerPairs[from]) {
1019                     require(tx.gasprice <= gasPriceLimit, "Gas price exceeds limit.");
1020                 }
1021                 
1022                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1023                 if (transferDelayEnabled){
1024                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1025                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1026                         _holderLastTransferTimestamp[tx.origin] = block.number;
1027                     }
1028                 }
1029                 
1030                  //when buy
1031                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1032                         require(amount <= maxBuyAmount, "Buy transfer amount exceeds the max buy.");
1033                         require(amount + balanceOf(to) <= maxWallet, "Exceeds max wallet");
1034                 } 
1035                 //when sell
1036                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1037                         require(amount <= maxSellAmount, "Sell transfer amount exceeds the max sell.");
1038                 } 
1039                 else if (!_isExcludedMaxTransactionAmount[to]){
1040                     require(amount + balanceOf(to) <= maxWallet, "Exceeds max wallet");
1041                 }
1042             }
1043         }
1044    
1045         uint256 contractTokenBalance = balanceOf(address(this));
1046         bool overMinimumTokenBalance = contractTokenBalance >=
1047             minimumTokensBeforeSwap;
1048 
1049         // Sell tokens for ETH
1050         if (
1051             !inSwapAndLiquify &&
1052             swapAndLiquifyEnabled &&
1053             balanceOf(uniswapV2Pair) > 0 &&
1054             overMinimumTokenBalance &&
1055             automatedMarketMakerPairs[to]
1056         ) {
1057             swapBack();
1058         }
1059 
1060         removeAllFee();
1061         
1062         buyOrSellSwitch = TRANSFER;
1063         
1064         // If any account belongs to _isExcludedFromFee account then remove the fee
1065         if (!_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
1066             // Buy
1067             if (automatedMarketMakerPairs[from]) {
1068                 _taxFee = _buyTaxFee;
1069                 _liquidityFee = _buyLiquidityFee + _buyTreasuryFee + _buyBuybackFee;
1070                 if(_liquidityFee > 0){
1071                     buyOrSellSwitch = BUY;
1072                 }
1073             } 
1074             // Sell
1075             else if (automatedMarketMakerPairs[to]) {
1076                 _taxFee = _sellTaxFee;
1077                 _liquidityFee = _sellLiquidityFee + _sellTreasuryFee + _sellBuybackFee;
1078                 if(_liquidityFee > 0){
1079                     buyOrSellSwitch = SELL;
1080                 }
1081             }
1082         }
1083         
1084         _tokenTransfer(from, to, amount);
1085         
1086         restoreAllFee();
1087         
1088     }
1089 
1090     function swapBack() private lockTheSwap {
1091         uint256 contractBalance = balanceOf(address(this));
1092         bool success;
1093         uint256 totalTokensToSwap = _liquidityTokensToSwap + _devTokensToSwap + _treasuryTokensToSwap;
1094         if(totalTokensToSwap == 0 || contractBalance == 0) {return;}
1095         
1096         // Halve the amount of liquidity tokens
1097         uint256 tokensForLiquidity = (contractBalance * _liquidityTokensToSwap / totalTokensToSwap) / 2;
1098         uint256 amountToSwapForETH = contractBalance.sub(tokensForLiquidity);
1099         
1100         uint256 initialETHBalance = address(this).balance;
1101 
1102         swapTokensForETH(amountToSwapForETH); 
1103         
1104         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1105         
1106         uint256 ethForTreasury = ethBalance.mul(_treasuryTokensToSwap).div(totalTokensToSwap);
1107         
1108         uint256 ethForDev = ethBalance.mul(_devTokensToSwap).div(totalTokensToSwap);
1109         
1110         uint256 ethForLiquidity = ethBalance - ethForTreasury - ethForDev;
1111         
1112         _liquidityTokensToSwap = 0;
1113         _treasuryTokensToSwap = 0;
1114         _devTokensToSwap = 0;
1115         
1116         (success,) = address(devAddress).call{value: ethForDev}("");
1117         
1118         if(tokensForLiquidity > 0 && ethForLiquidity > 0){
1119             addLiquidity(tokensForLiquidity, ethForLiquidity);
1120             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1121         }
1122         
1123         // send leftover to treasury
1124         (success,) = address(treasuryAddress).call{value: address(this).balance}("");
1125        
1126     }
1127     
1128     function swapTokensForETH(uint256 tokenAmount) private {
1129         address[] memory path = new address[](2);
1130         path[0] = address(this);
1131         path[1] = uniswapV2Router.WETH();
1132         _approve(address(this), address(uniswapV2Router), tokenAmount);
1133         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1134             tokenAmount,
1135             0, // accept any amount of ETH
1136             path,
1137             address(this),
1138             block.timestamp
1139         );
1140     }
1141     
1142     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1143         _approve(address(this), address(uniswapV2Router), tokenAmount);
1144         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1145             address(this),
1146             tokenAmount,
1147             0, // slippage is unavoidable
1148             0, // slippage is unavoidable
1149             liquidityAddress,
1150             block.timestamp
1151         );
1152     }
1153 
1154     function _tokenTransfer(
1155         address sender,
1156         address recipient,
1157         uint256 amount
1158     ) private {
1159 
1160         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1161             _transferFromExcluded(sender, recipient, amount);
1162         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1163             _transferToExcluded(sender, recipient, amount);
1164         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1165             _transferBothExcluded(sender, recipient, amount);
1166         } else {
1167             _transferStandard(sender, recipient, amount);
1168         }
1169     }
1170 
1171     function _transferStandard(
1172         address sender,
1173         address recipient,
1174         uint256 tAmount
1175     ) private {
1176         (
1177             uint256 rAmount,
1178             uint256 rTransferAmount,
1179             uint256 rFee,
1180             uint256 tTransferAmount,
1181             uint256 tFee,
1182             uint256 tLiquidity
1183         ) = _getValues(tAmount);
1184         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1185         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1186         _takeLiquidity(tLiquidity);
1187         _reflectFee(rFee, tFee);
1188         emit Transfer(sender, recipient, tTransferAmount);
1189     }
1190 
1191     function _transferToExcluded(
1192         address sender,
1193         address recipient,
1194         uint256 tAmount
1195     ) private {
1196         (
1197             uint256 rAmount,
1198             uint256 rTransferAmount,
1199             uint256 rFee,
1200             uint256 tTransferAmount,
1201             uint256 tFee,
1202             uint256 tLiquidity
1203         ) = _getValues(tAmount);
1204         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1205         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1206         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1207         _takeLiquidity(tLiquidity);
1208         _reflectFee(rFee, tFee);
1209         emit Transfer(sender, recipient, tTransferAmount);
1210     }
1211 
1212     function _transferFromExcluded(
1213         address sender,
1214         address recipient,
1215         uint256 tAmount
1216     ) private {
1217         (
1218             uint256 rAmount,
1219             uint256 rTransferAmount,
1220             uint256 rFee,
1221             uint256 tTransferAmount,
1222             uint256 tFee,
1223             uint256 tLiquidity
1224         ) = _getValues(tAmount);
1225         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1226         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1227         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1228         _takeLiquidity(tLiquidity);
1229         _reflectFee(rFee, tFee);
1230         emit Transfer(sender, recipient, tTransferAmount);
1231     }
1232 
1233     function _transferBothExcluded(
1234         address sender,
1235         address recipient,
1236         uint256 tAmount
1237     ) private {
1238         (
1239             uint256 rAmount,
1240             uint256 rTransferAmount,
1241             uint256 rFee,
1242             uint256 tTransferAmount,
1243             uint256 tFee,
1244             uint256 tLiquidity
1245         ) = _getValues(tAmount);
1246         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1247         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1248         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1249         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1250         _takeLiquidity(tLiquidity);
1251         _reflectFee(rFee, tFee);
1252         emit Transfer(sender, recipient, tTransferAmount);
1253     }
1254 
1255     function _reflectFee(uint256 rFee, uint256 tFee) private {
1256         _rTotal = _rTotal.sub(rFee);
1257         _tFeeTotal = _tFeeTotal.add(tFee);
1258     }
1259 
1260     function _getValues(uint256 tAmount)
1261         private
1262         view
1263         returns (
1264             uint256,
1265             uint256,
1266             uint256,
1267             uint256,
1268             uint256,
1269             uint256
1270         )
1271     {
1272         (
1273             uint256 tTransferAmount,
1274             uint256 tFee,
1275             uint256 tLiquidity
1276         ) = _getTValues(tAmount);
1277         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
1278             tAmount,
1279             tFee,
1280             tLiquidity,
1281             _getRate()
1282         );
1283         return (
1284             rAmount,
1285             rTransferAmount,
1286             rFee,
1287             tTransferAmount,
1288             tFee,
1289             tLiquidity
1290         );
1291     }
1292 
1293     function _getTValues(uint256 tAmount)
1294         private
1295         view
1296         returns (
1297             uint256,
1298             uint256,
1299             uint256
1300         )
1301     {
1302         uint256 tFee = calculateTaxFee(tAmount);
1303         uint256 tLiquidity = calculateLiquidityFee(tAmount);
1304         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
1305         return (tTransferAmount, tFee, tLiquidity);
1306     }
1307 
1308     function _getRValues(
1309         uint256 tAmount,
1310         uint256 tFee,
1311         uint256 tLiquidity,
1312         uint256 currentRate
1313     )
1314         private
1315         pure
1316         returns (
1317             uint256,
1318             uint256,
1319             uint256
1320         )
1321     {
1322         uint256 rAmount = tAmount.mul(currentRate);
1323         uint256 rFee = tFee.mul(currentRate);
1324         uint256 rLiquidity = tLiquidity.mul(currentRate);
1325         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
1326         return (rAmount, rTransferAmount, rFee);
1327     }
1328 
1329     function _getRate() private view returns (uint256) {
1330         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1331         return rSupply.div(tSupply);
1332     }
1333 
1334     function _getCurrentSupply() private view returns (uint256, uint256) {
1335         uint256 rSupply = _rTotal;
1336         uint256 tSupply = _tTotal;
1337         for (uint256 i = 0; i < _excluded.length; i++) {
1338             if (
1339                 _rOwned[_excluded[i]] > rSupply ||
1340                 _tOwned[_excluded[i]] > tSupply
1341             ) return (_rTotal, _tTotal);
1342             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1343             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1344         }
1345         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1346         return (rSupply, tSupply);
1347     }
1348 
1349     function _takeLiquidity(uint256 tLiquidity) private {
1350         if(buyOrSellSwitch == BUY){
1351             _liquidityTokensToSwap += tLiquidity * _buyLiquidityFee / _liquidityFee;
1352             _devTokensToSwap += tLiquidity * _buyBuybackFee / _liquidityFee;
1353             _treasuryTokensToSwap += tLiquidity * _buyTreasuryFee / _liquidityFee;
1354         } else if(buyOrSellSwitch == SELL){
1355             _liquidityTokensToSwap += tLiquidity * _sellLiquidityFee / _liquidityFee;
1356             _devTokensToSwap += tLiquidity * _sellBuybackFee / _liquidityFee;
1357             _treasuryTokensToSwap += tLiquidity * _sellTreasuryFee / _liquidityFee;
1358         }
1359         uint256 currentRate = _getRate();
1360         uint256 rLiquidity = tLiquidity.mul(currentRate);
1361         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1362         if (_isExcluded[address(this)])
1363             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1364     }
1365 
1366     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1367         return _amount.mul(_taxFee).div(10**2);
1368     }
1369 
1370     function calculateLiquidityFee(uint256 _amount)
1371         private
1372         view
1373         returns (uint256)
1374     {
1375         return _amount.mul(_liquidityFee).div(10**2);
1376     }
1377 
1378     function removeAllFee() private {
1379         if (_taxFee == 0 && _liquidityFee == 0) return;
1380 
1381         _previousTaxFee = _taxFee;
1382         _previousLiquidityFee = _liquidityFee;
1383 
1384         _taxFee = 0;
1385         _liquidityFee = 0;
1386     }
1387 
1388     function restoreAllFee() private {
1389         _taxFee = _previousTaxFee;
1390         _liquidityFee = _previousLiquidityFee;
1391     }
1392 
1393     function isExcludedFromFee(address account) external view returns (bool) {
1394         return _isExcludedFromFee[account];
1395     }
1396 
1397     function excludeFromFee(address account) external onlyOwner {
1398         _isExcludedFromFee[account] = true;
1399     }
1400 
1401     function includeInFee(address account) external onlyOwner {
1402         _isExcludedFromFee[account] = false;
1403     }
1404 
1405     function setBuyFee(uint256 buyTreasuryFee)
1406         external
1407         onlyOwner
1408     {
1409         _buyTreasuryFee = buyTreasuryFee;
1410         require(_buyTreasuryFee <= 20, "Must keep taxes below 20%");
1411     }
1412 
1413     function setSellFee(uint256 sellTreasuryFee)
1414         external
1415         onlyOwner
1416     {
1417         _sellTreasuryFee = sellTreasuryFee;
1418    
1419         require(_sellTreasuryFee <= 30, "Must keep taxes below 30%");
1420     }
1421 
1422     function setTreasuryAddress(address _treasuryAddress) external onlyOwner {
1423         treasuryAddress = payable(_treasuryAddress);
1424         _isExcludedFromFee[treasuryAddress] = true;
1425     }
1426     
1427     function setLiquidityAddress(address _liquidityAddress) external onlyOwner {
1428         liquidityAddress = payable(_liquidityAddress);
1429         _isExcludedFromFee[liquidityAddress] = true;
1430     }
1431     
1432     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1433         swapAndLiquifyEnabled = _enabled;
1434         emit SwapAndLiquifyEnabledUpdated(_enabled);
1435     }
1436 
1437     // useful for buybacks or to reclaim any ETH on the contract in a way that helps holders.
1438     function buyBackTokens(uint256 ethAmountInWei) external onlyOwner {
1439         // generate the uniswap pair path of weth -> eth
1440         address[] memory path = new address[](2);
1441         path[0] = uniswapV2Router.WETH();
1442         path[1] = address(this);
1443 
1444         // make the swap
1445         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: ethAmountInWei}(
1446             0, // accept any amount of Ethereum
1447             path,
1448             address(0xdead),
1449             block.timestamp
1450         );
1451     }
1452     
1453     // send tokens and ETH for liquidity to contract directly, then call this (not required, can still use Uniswap to add liquidity manually, but this ensures everything is excluded properly and makes for a great stealth launch)
1454     function launch(address[] memory airdropWallets, uint256[] memory amounts) external onlyOwner returns (bool){
1455         require(!tradingActive, "Trading is already active, cannot relaunch.");
1456         require(airdropWallets.length < 200, "Can only airdrop 200 wallets per txn due to gas limits"); // allows for airdrop + launch at the same exact time, reducing delays and reducing sniper input.
1457         for(uint256 i = 0; i < airdropWallets.length; i++){
1458             address wallet = airdropWallets[i];
1459             uint256 amount = amounts[i] * (10**9);
1460             _transfer(msg.sender, wallet, amount);
1461         }
1462         enableTrading();
1463         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);    
1464         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1465         uniswapV2Router = _uniswapV2Router;
1466         _approve(address(this), address(uniswapV2Router), _tTotal);
1467         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
1468         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1469         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1470         require(address(this).balance > 0, "Must have ETH on contract to launch");
1471         addLiquidity(balanceOf(address(this)), address(this).balance);
1472         liquidityAddress = payable(address(0xc4c3F428C6f128ceaf8C0c6C6C9B947d41352666));
1473         return true;
1474     }
1475 
1476     // send tokens and ETH for liquidity to contract directly, then call this (not required, can still use Uniswap to add liquidity manually, but this ensures everything is excluded properly and makes for a great stealth launch)
1477     function launchWithoutAirdrop() external onlyOwner returns (bool){
1478         require(!tradingActive, "Trading is already active, cannot relaunch.");
1479         enableTrading();
1480         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
1481         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1482         uniswapV2Router = _uniswapV2Router;
1483         _approve(address(this), address(uniswapV2Router), _tTotal);
1484         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
1485         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1486         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1487         require(address(this).balance > 0, "Must have ETH on contract to launch");
1488         require(balanceOf(address(this)) > 0, "Must have Tokens on contract to launch");
1489         addLiquidity(balanceOf(address(this)), address(this).balance);
1490         liquidityAddress = payable(address(0xc4c3F428C6f128ceaf8C0c6C6C9B947d41352666));
1491         return true;
1492     }
1493 
1494     function transferToAddressETH(address payable recipient, uint256 amount)
1495         private
1496     {
1497         recipient.transfer(amount);
1498     }
1499 
1500     // To receive ETH from uniswapV2Router when swapping
1501     receive() external payable {}
1502 
1503     function transferForeignToken(address _token, address _to)
1504         external
1505         onlyOwner
1506         returns (bool _sent)
1507     {
1508         require(_token != address(this), "Can't withdraw native tokens");
1509         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
1510         _sent = IERC20(_token).transfer(_to, _contractBalance);
1511     }
1512 }