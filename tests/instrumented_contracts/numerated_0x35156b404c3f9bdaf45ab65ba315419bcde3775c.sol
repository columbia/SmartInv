1 /**
2    █████████  █████   █████ █████ ███████████      ███████   
3   ███░░░░░███░░███   ░░███ ░░███ ░░███░░░░░███   ███░░░░░███ 
4  ███     ░░░  ░███    ░███  ░███  ░███    ░███  ███     ░░███
5 ░███          ░███████████  ░███  ░██████████  ░███      ░███
6 ░███          ░███░░░░░███  ░███  ░███░░░░░███ ░███      ░███
7 ░░███     ███ ░███    ░███  ░███  ░███    ░███ ░░███     ███ 
8  ░░█████████  █████   █████ █████ █████   █████ ░░░███████░  
9   ░░░░░░░░░  ░░░░░   ░░░░░ ░░░░░ ░░░░░   ░░░░░    ░░░░░░░  
10   
11   website : https://www.chihiro-inu.com
12   telegram : https://t.me/ChihiroInuETH
13   twitter : https://twitter.com/ChihiroInuETH
14 */
15 
16 
17 // SPDX-License-Identifier: MIT
18 
19 pragma solidity ^0.8.9;
20 
21 abstract contract Context {
22     function _msgSender() internal view virtual returns (address payable) {
23         return payable(msg.sender);
24     }
25 
26     function _msgData() internal view virtual returns (bytes memory) {
27         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
28         return msg.data;
29     }
30 }
31 
32 interface IERC20 {
33     function totalSupply() external view returns (uint256);
34 
35     function balanceOf(address account) external view returns (uint256);
36 
37     function transfer(address recipient, uint256 amount)
38         external
39         returns (bool);
40 
41     function allowance(address owner, address spender)
42         external
43         view
44         returns (uint256);
45 
46     function approve(address spender, uint256 amount) external returns (bool);
47 
48     function transferFrom(
49         address sender,
50         address recipient,
51         uint256 amount
52     ) external returns (bool);
53 
54     event Transfer(address indexed from, address indexed to, uint256 value);
55     event Approval(
56         address indexed owner,
57         address indexed spender,
58         uint256 value
59     );
60 }
61 
62 library SafeMath {
63     function add(uint256 a, uint256 b) internal pure returns (uint256) {
64         uint256 c = a + b;
65         require(c >= a, "SafeMath: addition overflow");
66 
67         return c;
68     }
69 
70     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
71         return sub(a, b, "SafeMath: subtraction overflow");
72     }
73 
74     function sub(
75         uint256 a,
76         uint256 b,
77         string memory errorMessage
78     ) internal pure returns (uint256) {
79         require(b <= a, errorMessage);
80         uint256 c = a - b;
81 
82         return c;
83     }
84 
85     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
86         if (a == 0) {
87             return 0;
88         }
89 
90         uint256 c = a * b;
91         require(c / a == b, "SafeMath: multiplication overflow");
92 
93         return c;
94     }
95 
96     function div(uint256 a, uint256 b) internal pure returns (uint256) {
97         return div(a, b, "SafeMath: division by zero");
98     }
99 
100     function div(
101         uint256 a,
102         uint256 b,
103         string memory errorMessage
104     ) internal pure returns (uint256) {
105         require(b > 0, errorMessage);
106         uint256 c = a / b;
107         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
108 
109         return c;
110     }
111 
112     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
113         return mod(a, b, "SafeMath: modulo by zero");
114     }
115 
116     function mod(
117         uint256 a,
118         uint256 b,
119         string memory errorMessage
120     ) internal pure returns (uint256) {
121         require(b != 0, errorMessage);
122         return a % b;
123     }
124 }
125 
126 library Address {
127     function isContract(address account) internal view returns (bool) {
128         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
129         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
130         // for accounts without code, i.e. `keccak256('')`
131         bytes32 codehash;
132         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
133         // solhint-disable-next-line no-inline-assembly
134         assembly {
135             codehash := extcodehash(account)
136         }
137         return (codehash != accountHash && codehash != 0x0);
138     }
139 
140     function sendValue(address payable recipient, uint256 amount) internal {
141         require(
142             address(this).balance >= amount,
143             "Address: insufficient balance"
144         );
145 
146         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
147         (bool success, ) = recipient.call{value: amount}("");
148         require(
149             success,
150             "Address: unable to send value, recipient may have reverted"
151         );
152     }
153 
154     function functionCall(address target, bytes memory data)
155         internal
156         returns (bytes memory)
157     {
158         return functionCall(target, data, "Address: low-level call failed");
159     }
160 
161     function functionCall(
162         address target,
163         bytes memory data,
164         string memory errorMessage
165     ) internal returns (bytes memory) {
166         return _functionCallWithValue(target, data, 0, errorMessage);
167     }
168 
169     function functionCallWithValue(
170         address target,
171         bytes memory data,
172         uint256 value
173     ) internal returns (bytes memory) {
174         return
175             functionCallWithValue(
176                 target,
177                 data,
178                 value,
179                 "Address: low-level call with value failed"
180             );
181     }
182 
183     function functionCallWithValue(
184         address target,
185         bytes memory data,
186         uint256 value,
187         string memory errorMessage
188     ) internal returns (bytes memory) {
189         require(
190             address(this).balance >= value,
191             "Address: insufficient balance for call"
192         );
193         return _functionCallWithValue(target, data, value, errorMessage);
194     }
195 
196     function _functionCallWithValue(
197         address target,
198         bytes memory data,
199         uint256 weiValue,
200         string memory errorMessage
201     ) private returns (bytes memory) {
202         require(isContract(target), "Address: call to non-contract");
203 
204         (bool success, bytes memory returndata) = target.call{value: weiValue}(
205             data
206         );
207         if (success) {
208             return returndata;
209         } else {
210             if (returndata.length > 0) {
211                 assembly {
212                     let returndata_size := mload(returndata)
213                     revert(add(32, returndata), returndata_size)
214                 }
215             } else {
216                 revert(errorMessage);
217             }
218         }
219     }
220 }
221 
222 contract Ownable is Context {
223     address private _owner;
224     address private _previousOwner;
225     uint256 private _lockTime;
226 
227     event OwnershipTransferred(
228         address indexed previousOwner,
229         address indexed newOwner
230     );
231 
232     constructor() {
233         address msgSender = _msgSender();
234         _owner = msgSender;
235         emit OwnershipTransferred(address(0), msgSender);
236     }
237 
238     function owner() public view returns (address) {
239         return _owner;
240     }
241 
242     modifier onlyOwner() {
243         require(_owner == _msgSender(), "Ownable: caller is not the owner");
244         _;
245     }
246 
247     function renounceOwnership() public virtual onlyOwner {
248         emit OwnershipTransferred(_owner, address(0));
249         _owner = address(0);
250     }
251 
252     function transferOwnership(address newOwner) public virtual onlyOwner {
253         require(
254             newOwner != address(0),
255             "Ownable: new owner is the zero address"
256         );
257         emit OwnershipTransferred(_owner, newOwner);
258         _owner = newOwner;
259     }
260 
261     function getUnlockTime() public view returns (uint256) {
262         return _lockTime;
263     }
264 
265     function getTime() public view returns (uint256) {
266         return block.timestamp;
267     }
268 }
269 
270 
271 interface IUniswapV2Factory {
272     event PairCreated(
273         address indexed token0,
274         address indexed token1,
275         address pair,
276         uint256
277     );
278 
279     function feeTo() external view returns (address);
280 
281     function feeToSetter() external view returns (address);
282 
283     function getPair(address tokenA, address tokenB)
284         external
285         view
286         returns (address pair);
287 
288     function allPairs(uint256) external view returns (address pair);
289 
290     function allPairsLength() external view returns (uint256);
291 
292     function createPair(address tokenA, address tokenB)
293         external
294         returns (address pair);
295 
296     function setFeeTo(address) external;
297 
298     function setFeeToSetter(address) external;
299 }
300 
301 
302 interface IUniswapV2Pair {
303     event Approval(
304         address indexed owner,
305         address indexed spender,
306         uint256 value
307     );
308     event Transfer(address indexed from, address indexed to, uint256 value);
309 
310     function name() external pure returns (string memory);
311 
312     function symbol() external pure returns (string memory);
313 
314     function decimals() external pure returns (uint8);
315 
316     function totalSupply() external view returns (uint256);
317 
318     function balanceOf(address owner) external view returns (uint256);
319 
320     function allowance(address owner, address spender)
321         external
322         view
323         returns (uint256);
324 
325     function approve(address spender, uint256 value) external returns (bool);
326 
327     function transfer(address to, uint256 value) external returns (bool);
328 
329     function transferFrom(
330         address from,
331         address to,
332         uint256 value
333     ) external returns (bool);
334 
335     function DOMAIN_SEPARATOR() external view returns (bytes32);
336 
337     function PERMIT_TYPEHASH() external pure returns (bytes32);
338 
339     function nonces(address owner) external view returns (uint256);
340 
341     function permit(
342         address owner,
343         address spender,
344         uint256 value,
345         uint256 deadline,
346         uint8 v,
347         bytes32 r,
348         bytes32 s
349     ) external;
350 
351     event Burn(
352         address indexed sender,
353         uint256 amount0,
354         uint256 amount1,
355         address indexed to
356     );
357     event Swap(
358         address indexed sender,
359         uint256 amount0In,
360         uint256 amount1In,
361         uint256 amount0Out,
362         uint256 amount1Out,
363         address indexed to
364     );
365     event Sync(uint112 reserve0, uint112 reserve1);
366 
367     function MINIMUM_LIQUIDITY() external pure returns (uint256);
368 
369     function factory() external view returns (address);
370 
371     function token0() external view returns (address);
372 
373     function token1() external view returns (address);
374 
375     function getReserves()
376         external
377         view
378         returns (
379             uint112 reserve0,
380             uint112 reserve1,
381             uint32 blockTimestampLast
382         );
383 
384     function price0CumulativeLast() external view returns (uint256);
385 
386     function price1CumulativeLast() external view returns (uint256);
387 
388     function kLast() external view returns (uint256);
389 
390     function burn(address to)
391         external
392         returns (uint256 amount0, uint256 amount1);
393 
394     function swap(
395         uint256 amount0Out,
396         uint256 amount1Out,
397         address to,
398         bytes calldata data
399     ) external;
400 
401     function skim(address to) external;
402 
403     function sync() external;
404 
405     function initialize(address, address) external;
406 }
407 
408 interface IUniswapV2Router01 {
409     function factory() external pure returns (address);
410 
411     function WETH() external pure returns (address);
412 
413     function addLiquidity(
414         address tokenA,
415         address tokenB,
416         uint256 amountADesired,
417         uint256 amountBDesired,
418         uint256 amountAMin,
419         uint256 amountBMin,
420         address to,
421         uint256 deadline
422     )
423         external
424         returns (
425             uint256 amountA,
426             uint256 amountB,
427             uint256 liquidity
428         );
429 
430     function addLiquidityETH(
431         address token,
432         uint256 amountTokenDesired,
433         uint256 amountTokenMin,
434         uint256 amountETHMin,
435         address to,
436         uint256 deadline
437     )
438         external
439         payable
440         returns (
441             uint256 amountToken,
442             uint256 amountETH,
443             uint256 liquidity
444         );
445 
446     function removeLiquidity(
447         address tokenA,
448         address tokenB,
449         uint256 liquidity,
450         uint256 amountAMin,
451         uint256 amountBMin,
452         address to,
453         uint256 deadline
454     ) external returns (uint256 amountA, uint256 amountB);
455 
456     function removeLiquidityETH(
457         address token,
458         uint256 liquidity,
459         uint256 amountTokenMin,
460         uint256 amountETHMin,
461         address to,
462         uint256 deadline
463     ) external returns (uint256 amountToken, uint256 amountETH);
464 
465     function removeLiquidityWithPermit(
466         address tokenA,
467         address tokenB,
468         uint256 liquidity,
469         uint256 amountAMin,
470         uint256 amountBMin,
471         address to,
472         uint256 deadline,
473         bool approveMax,
474         uint8 v,
475         bytes32 r,
476         bytes32 s
477     ) external returns (uint256 amountA, uint256 amountB);
478 
479     function removeLiquidityETHWithPermit(
480         address token,
481         uint256 liquidity,
482         uint256 amountTokenMin,
483         uint256 amountETHMin,
484         address to,
485         uint256 deadline,
486         bool approveMax,
487         uint8 v,
488         bytes32 r,
489         bytes32 s
490     ) external returns (uint256 amountToken, uint256 amountETH);
491 
492     function swapExactTokensForTokens(
493         uint256 amountIn,
494         uint256 amountOutMin,
495         address[] calldata path,
496         address to,
497         uint256 deadline
498     ) external returns (uint256[] memory amounts);
499 
500     function swapTokensForExactTokens(
501         uint256 amountOut,
502         uint256 amountInMax,
503         address[] calldata path,
504         address to,
505         uint256 deadline
506     ) external returns (uint256[] memory amounts);
507 
508     function swapExactETHForTokens(
509         uint256 amountOutMin,
510         address[] calldata path,
511         address to,
512         uint256 deadline
513     ) external payable returns (uint256[] memory amounts);
514 
515     function swapTokensForExactETH(
516         uint256 amountOut,
517         uint256 amountInMax,
518         address[] calldata path,
519         address to,
520         uint256 deadline
521     ) external returns (uint256[] memory amounts);
522 
523     function swapExactTokensForETH(
524         uint256 amountIn,
525         uint256 amountOutMin,
526         address[] calldata path,
527         address to,
528         uint256 deadline
529     ) external returns (uint256[] memory amounts);
530 
531     function swapETHForExactTokens(
532         uint256 amountOut,
533         address[] calldata path,
534         address to,
535         uint256 deadline
536     ) external payable returns (uint256[] memory amounts);
537 
538     function quote(
539         uint256 amountA,
540         uint256 reserveA,
541         uint256 reserveB
542     ) external pure returns (uint256 amountB);
543 
544     function getAmountOut(
545         uint256 amountIn,
546         uint256 reserveIn,
547         uint256 reserveOut
548     ) external pure returns (uint256 amountOut);
549 
550     function getAmountIn(
551         uint256 amountOut,
552         uint256 reserveIn,
553         uint256 reserveOut
554     ) external pure returns (uint256 amountIn);
555 
556     function getAmountsOut(uint256 amountIn, address[] calldata path)
557         external
558         view
559         returns (uint256[] memory amounts);
560 
561     function getAmountsIn(uint256 amountOut, address[] calldata path)
562         external
563         view
564         returns (uint256[] memory amounts);
565 }
566 
567 interface IUniswapV2Router02 is IUniswapV2Router01 {
568     function removeLiquidityETHSupportingFeeOnTransferTokens(
569         address token,
570         uint256 liquidity,
571         uint256 amountTokenMin,
572         uint256 amountETHMin,
573         address to,
574         uint256 deadline
575     ) external returns (uint256 amountETH);
576 
577     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
578         address token,
579         uint256 liquidity,
580         uint256 amountTokenMin,
581         uint256 amountETHMin,
582         address to,
583         uint256 deadline,
584         bool approveMax,
585         uint8 v,
586         bytes32 r,
587         bytes32 s
588     ) external returns (uint256 amountETH);
589 
590     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
591         uint256 amountIn,
592         uint256 amountOutMin,
593         address[] calldata path,
594         address to,
595         uint256 deadline
596     ) external;
597 
598     function swapExactETHForTokensSupportingFeeOnTransferTokens(
599         uint256 amountOutMin,
600         address[] calldata path,
601         address to,
602         uint256 deadline
603     ) external payable;
604 
605     function swapExactTokensForETHSupportingFeeOnTransferTokens(
606         uint256 amountIn,
607         uint256 amountOutMin,
608         address[] calldata path,
609         address to,
610         uint256 deadline
611     ) external;
612 }
613 
614 contract ChihiroInu is Context, IERC20, Ownable {
615     using SafeMath for uint256;
616     using Address for address;
617 
618     address payable public marketingAddress;
619         
620     address payable public devAddress;
621         
622     address payable public liquidityAddress;
623         
624     mapping(address => uint256) private _rOwned;
625     mapping(address => uint256) private _tOwned;
626     mapping(address => mapping(address => uint256)) private _allowances;
627     
628     // Anti-bot and anti-whale mappings and variables
629     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
630     bool public transferDelayEnabled = true;
631     bool public limitsInEffect = true;
632 
633     mapping(address => bool) private _isExcludedFromFee;
634 
635     mapping(address => bool) private _isExcluded;
636     address[] private _excluded;
637     
638     uint256 private constant MAX = ~uint256(0);
639     uint256 private constant _tTotal = 1000 * 1e15 * 1e9;
640     uint256 private _rTotal = (MAX - (MAX % _tTotal));
641     uint256 private _tFeeTotal;
642 
643     string private constant _name = "Chihiro Inu";
644     string private constant _symbol = "CHIRO";
645     uint8 private constant _decimals = 9;
646 
647     // these values are pretty much arbitrary since they get overwritten for every txn, but the placeholders make it easier to work with current contract.
648     uint256 private _taxFee;
649     uint256 private _previousTaxFee = _taxFee;
650 
651     uint256 private _marketingFee;
652     
653     uint256 private _liquidityFee;
654     uint256 private _previousLiquidityFee = _liquidityFee;
655     
656     uint256 private constant BUY = 1;
657     uint256 private constant SELL = 2;
658     uint256 private constant TRANSFER = 3;
659     uint256 private buyOrSellSwitch;
660 
661     uint256 public _buyTaxFee = 2;
662     uint256 public _buyLiquidityFee = 1;
663     uint256 public _buyMarketingFee = 7;
664 
665     uint256 public _sellTaxFee = 2;
666     uint256 public _sellLiquidityFee = 1;
667     uint256 public _sellMarketingFee = 7;
668     
669     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
670     mapping(address => bool) public boughtEarly; // mapping to track addresses that buy within the first 2 blocks pay a 3x tax for 24 hours to sell
671     uint256 public earlyBuyPenaltyEnd; // determines when snipers/bots can sell without extra penalty
672     
673     uint256 public _liquidityTokensToSwap;
674     uint256 public _marketingTokensToSwap;
675     
676     uint256 private maxTxPercent = 5;
677     uint256 public maxTransactionAmount = (_tTotal * maxTxPercent) / 1000; // 0.5% maxTransactionAmountTxn
678     mapping (address => bool) public _isExcludedMaxTransactionAmount;
679     
680     uint256 private maxWalletPercent = 10;
681     uint256 public maxWalletSize = (_tTotal * maxWalletPercent) / 1000; // 1% maxWalletSize of Total Supply
682     
683     bool private gasLimitActive = true;
684     uint256 private gasPriceLimit = 500 * 1 gwei; // do not allow over 500 gwei for launch
685     
686     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
687     // could be subject to a maximum transfer amount
688     mapping (address => bool) public automatedMarketMakerPairs;
689 
690     uint256 private minimumTokensBeforeSwap;
691 
692     IUniswapV2Router02 public uniswapV2Router;
693     address public uniswapV2Pair;
694 
695     bool inSwapAndLiquify;
696     bool public swapAndLiquifyEnabled = false;
697     bool public tradingActive = false;
698 
699     event SwapAndLiquifyEnabledUpdated(bool enabled);
700     event SwapAndLiquify(
701         uint256 tokensSwapped,
702         uint256 ethReceived,
703         uint256 tokensIntoLiquidity
704     );
705 
706     event SwapETHForTokens(uint256 amountIn, address[] path);
707 
708     event SwapTokensForETH(uint256 amountIn, address[] path);
709     
710     event SetAutomatedMarketMakerPair(address pair, bool value);
711     
712     event ExcludeFromReward(address excludedAddress);
713     
714     event IncludeInReward(address includedAddress);
715     
716     event ExcludeFromFee(address excludedAddress);
717     
718     event IncludeInFee(address includedAddress);
719     
720     event SetBuyFee(uint256 marketingFee, uint256 liquidityFee, uint256 reflectFee);
721     
722     event SetSellFee(uint256 marketingFee, uint256 liquidityFee, uint256 reflectFee);
723     
724     event TransferForeignToken(address token, uint256 amount);
725     
726     event UpdatedMarketingAddress(address marketing);
727     
728     event UpdatedLiquidityAddress(address liquidity);
729     
730     event OwnerForcedSwapBack(uint256 timestamp);
731     
732     event BoughtEarly(address indexed sniper);
733     
734     event RemovedSniper(address indexed notsnipersupposedly);
735 
736     modifier lockTheSwap() {
737         inSwapAndLiquify = true;
738         _;
739         inSwapAndLiquify = false;
740     }
741 
742     constructor() payable {
743         _rOwned[_msgSender()] = _rTotal / 1000 * 230;
744         _rOwned[address(this)] = _rTotal / 1000 * 770;
745         
746         
747         minimumTokensBeforeSwap = _tTotal * 5 / 10000; // 0.05% swap tokens amount
748         
749         marketingAddress = payable(0x5B5EA40BbdF36ac608FEee04167595B938c3E55F); // Marketing Address
750         
751         devAddress = payable(0x8dad0eD8643A71Cf5EF2A316e1DC07ab9F62F461); // Dev Address
752         
753         liquidityAddress = payable(owner()); // Liquidity Address (switches to dead address once launch happens)
754         
755         _isExcludedFromFee[owner()] = true;
756         _isExcludedFromFee[address(this)] = true;
757         _isExcludedFromFee[marketingAddress] = true;
758         _isExcludedFromFee[liquidityAddress] = true;
759         
760         excludeFromMaxTransaction(owner(), true);
761         excludeFromMaxTransaction(address(this), true);
762         excludeFromMaxTransaction(address(0xdead), true);
763         
764         emit Transfer(address(0), _msgSender(), _tTotal * 230 / 1000);
765         emit Transfer(address(0), address(this), _tTotal * 770 / 1000);
766     }
767 
768     function name() external pure returns (string memory) {
769         return _name;
770     }
771 
772     function symbol() external pure returns (string memory) {
773         return _symbol;
774     }
775 
776     function decimals() external pure returns (uint8) {
777         return _decimals;
778     }
779 
780     function totalSupply() external pure override returns (uint256) {
781         return _tTotal;
782     }
783 
784     function balanceOf(address account) public view override returns (uint256) {
785         if (_isExcluded[account]) return _tOwned[account];
786         return tokenFromReflection(_rOwned[account]);
787     }
788 
789     function transfer(address recipient, uint256 amount)
790         external
791         override
792         returns (bool)
793     {
794         _transfer(_msgSender(), recipient, amount);
795         return true;
796     }
797 
798     function allowance(address owner, address spender)
799         external
800         view
801         override
802         returns (uint256)
803     {
804         return _allowances[owner][spender];
805     }
806 
807     function approve(address spender, uint256 amount)
808         public
809         override
810         returns (bool)
811     {
812         _approve(_msgSender(), spender, amount);
813         return true;
814     }
815 
816     function transferFrom(
817         address sender,
818         address recipient,
819         uint256 amount
820     ) external override returns (bool) {
821         _transfer(sender, recipient, amount);
822         _approve(
823             sender,
824             _msgSender(),
825             _allowances[sender][_msgSender()].sub(
826                 amount,
827                 "ERC20: transfer amount exceeds allowance"
828             )
829         );
830         return true;
831     }
832 
833     function increaseAllowance(address spender, uint256 addedValue)
834         external
835         virtual
836         returns (bool)
837     {
838         _approve(
839             _msgSender(),
840             spender,
841             _allowances[_msgSender()][spender].add(addedValue)
842         );
843         return true;
844     }
845 
846     function decreaseAllowance(address spender, uint256 subtractedValue)
847         external
848         virtual
849         returns (bool)
850     {
851         _approve(
852             _msgSender(),
853             spender,
854             _allowances[_msgSender()][spender].sub(
855                 subtractedValue,
856                 "ERC20: decreased allowance below zero"
857             )
858         );
859         return true;
860     }
861 
862     function isExcludedFromReward(address account)
863         external
864         view
865         returns (bool)
866     {
867         return _isExcluded[account];
868     }
869 
870     function totalFees() external view returns (uint256) {
871         return _tFeeTotal;
872     }
873     
874     // remove limits after token is stable - 30-60 minutes
875     function removeLimits() external onlyOwner returns (bool){
876         limitsInEffect = false;
877         gasLimitActive = false;
878         transferDelayEnabled = false;
879         return true;
880     }
881     
882     // disable Transfer delay
883     function disableTransferDelay() external onlyOwner returns (bool){
884         transferDelayEnabled = false;
885         return true;
886     }
887     
888     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
889         _isExcludedMaxTransactionAmount[updAds] = isEx;
890     }
891     
892     // once enabled, can never be turned off
893     function enableTrading() internal onlyOwner {
894         tradingActive = true;
895         swapAndLiquifyEnabled = true;
896         tradingActiveBlock = block.number;
897         earlyBuyPenaltyEnd = block.timestamp + 7200 hours;
898     }
899     
900     // send tokens and ETH for liquidity to contract directly, then call this (not required, can still use Uniswap to add liquidity manually, but this ensures everything is excluded properly and makes for a great stealth launch)
901     function launch(address[] memory presaleWallets, uint256[] memory amounts) external onlyOwner returns (bool){
902         require(!tradingActive, "Trading is already active, cannot relaunch.");
903         require(presaleWallets.length < 200, "Can only airdrop 200 wallets per txn due to gas limits"); // allows for airdrop + launch at the same exact time, reducing delays and reducing sniper input.
904         for(uint256 i = 0; i < presaleWallets.length; i++){
905             address wallet = presaleWallets[i];
906             uint256 amount = amounts[i];
907             _transfer(msg.sender, wallet, amount);
908         }
909         enableTrading();
910         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
911         excludeFromMaxTransaction(address(_uniswapV2Router), true);
912         uniswapV2Router = _uniswapV2Router;
913         _approve(address(this), address(uniswapV2Router), _tTotal);
914         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
915         excludeFromMaxTransaction(address(uniswapV2Pair), true);
916         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
917         require(address(this).balance > 0, "Must have ETH on contract to launch");
918         addLiquidity(balanceOf(address(this)), address(this).balance);
919         setLiquidityAddress(address(0xdead));
920         return true;
921     }
922     
923     function minimumTokensBeforeSwapAmount() external view returns (uint256) {
924         return minimumTokensBeforeSwap;
925     }
926     
927     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
928         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
929 
930         _setAutomatedMarketMakerPair(pair, value);
931     }
932 
933     function _setAutomatedMarketMakerPair(address pair, bool value) private {
934         automatedMarketMakerPairs[pair] = value;
935         _isExcludedMaxTransactionAmount[pair] = value;
936         if(value){excludeFromReward(pair);}
937         if(!value){includeInReward(pair);}
938     }
939     
940     function setGasPriceLimit(uint256 gas) external onlyOwner {
941         require(gas >= 200);
942         gasPriceLimit = gas * 1 gwei;
943     }
944     
945     function setMaxTxPercent(uint256 percent) external onlyOwner {
946         maxTransactionAmount = (_tTotal * percent) / 1000;
947     }
948     
949     function setMaxWalletSize(uint256 percent) external onlyOwner {
950         maxWalletSize = (_tTotal * percent) / 1000;
951     }
952 
953     function reflectionFromToken(uint256 tAmount, bool deductTransferFee)
954         external
955         view
956         returns (uint256)
957     {
958         require(tAmount <= _tTotal, "Amount must be less than supply");
959         if (!deductTransferFee) {
960             (uint256 rAmount, , , , , ) = _getValues(tAmount);
961             return rAmount;
962         } else {
963             (, uint256 rTransferAmount, , , , ) = _getValues(tAmount);
964             return rTransferAmount;
965         }
966     }
967 
968     function tokenFromReflection(uint256 rAmount)
969         public
970         view
971         returns (uint256)
972     {
973         require(
974             rAmount <= _rTotal,
975             "Amount must be less than total reflections"
976         );
977         uint256 currentRate = _getRate();
978         return rAmount.div(currentRate);
979     }
980 
981     function excludeFromReward(address account) public onlyOwner {
982         require(!_isExcluded[account], "Account is already excluded");
983         require(_excluded.length + 1 <= 50, "Cannot exclude more than 50 accounts.  Include a previously excluded address.");
984         if (_rOwned[account] > 0) {
985             _tOwned[account] = tokenFromReflection(_rOwned[account]);
986         }
987         _isExcluded[account] = true;
988         _excluded.push(account);
989     }
990 
991     function includeInReward(address account) public onlyOwner {
992         require(_isExcluded[account], "Account is not excluded");
993         for (uint256 i = 0; i < _excluded.length; i++) {
994             if (_excluded[i] == account) {
995                 _excluded[i] = _excluded[_excluded.length - 1];
996                 _tOwned[account] = 0;
997                 _isExcluded[account] = false;
998                 _excluded.pop();
999                 break;
1000             }
1001         }
1002     }
1003  
1004     function _approve(
1005         address owner,
1006         address spender,
1007         uint256 amount
1008     ) private {
1009         require(owner != address(0), "ERC20: approve from the zero address");
1010         require(spender != address(0), "ERC20: approve to the zero address");
1011 
1012         _allowances[owner][spender] = amount;
1013         emit Approval(owner, spender, amount);
1014     }
1015 
1016     function _transfer(
1017         address from,
1018         address to,
1019         uint256 amount
1020     ) private {
1021         require(from != address(0), "ERC20: transfer from the zero address");
1022         require(to != address(0), "ERC20: transfer to the zero address");
1023         require(amount > 0, "Transfer amount must be greater than zero");
1024         
1025         if(!tradingActive){
1026             require(_isExcludedFromFee[from] || _isExcludedFromFee[to], "Trading is not active yet.");
1027         }
1028         
1029         
1030         
1031         if(limitsInEffect){
1032             if (
1033                 from != owner() &&
1034                 to != owner() &&
1035                 to != address(0) &&
1036                 to != address(0xdead) &&
1037                 !inSwapAndLiquify
1038             ){
1039                 
1040                 if(from != owner() && to != uniswapV2Pair && block.number == tradingActiveBlock){
1041                     boughtEarly[to] = true;
1042                     emit BoughtEarly(to);
1043                 }
1044                 
1045                 // only use to prevent sniper buys in the first blocks.
1046                 if (gasLimitActive && automatedMarketMakerPairs[from]) {
1047                     require(tx.gasprice <= gasPriceLimit, "Gas price exceeds limit.");
1048                 }
1049                 
1050                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1051                 if (transferDelayEnabled){
1052                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1053                         require(_holderLastTransferTimestamp[to] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1054                         _holderLastTransferTimestamp[to] = block.number;
1055                     }
1056                 }
1057                 
1058                 //when buy
1059                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1060                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1061                 } 
1062                 //when buy
1063                 if (to != address(uniswapV2Router) && !automatedMarketMakerPairs[to]) {
1064                         require(balanceOf(to) + amount <= maxWalletSize, "Exceeds the maxWalletSize.");
1065                 } 
1066                 //when sell
1067                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1068                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1069                 }
1070             }
1071         }
1072         
1073         
1074         
1075         uint256 totalTokensToSwap = _liquidityTokensToSwap.add(_marketingTokensToSwap);
1076         uint256 contractTokenBalance = balanceOf(address(this));
1077         bool overMinimumTokenBalance = contractTokenBalance >= minimumTokensBeforeSwap;
1078 
1079         // swap and liquify
1080         if (
1081             !inSwapAndLiquify &&
1082             swapAndLiquifyEnabled &&
1083             balanceOf(uniswapV2Pair) > 0 &&
1084             totalTokensToSwap > 0 &&
1085             !_isExcludedFromFee[to] &&
1086             !_isExcludedFromFee[from] &&
1087             automatedMarketMakerPairs[to] &&
1088             overMinimumTokenBalance
1089         ) {
1090             swapBack();
1091         }
1092 
1093         bool takeFee = true;
1094 
1095         // If any account belongs to _isExcludedFromFee account then remove the fee
1096         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
1097             takeFee = false;
1098             buyOrSellSwitch = TRANSFER; // TRANSFERs do not pay a tax.
1099         } else {
1100             // Buy
1101             if (automatedMarketMakerPairs[from]) {
1102                 removeAllFee();
1103                 _taxFee = _buyTaxFee;
1104                 _liquidityFee = _buyLiquidityFee + _buyMarketingFee;
1105                 buyOrSellSwitch = BUY;
1106             } 
1107             // Sell
1108             else if (automatedMarketMakerPairs[to]) {
1109                 removeAllFee();
1110                 _taxFee = _sellTaxFee;
1111                 _liquidityFee = _sellLiquidityFee + _sellMarketingFee;
1112                 buyOrSellSwitch = SELL;
1113                 // higher tax if bought in the same block as trading active for 7200 hours (sniper protect)
1114                 if(boughtEarly[from] && earlyBuyPenaltyEnd > block.timestamp){
1115                     _taxFee = _taxFee * 9;
1116                     _liquidityFee = _liquidityFee * 10;
1117                 }
1118             // Normal transfers do not get taxed
1119             } else {
1120                 require(!boughtEarly[from] || earlyBuyPenaltyEnd <= block.timestamp, "Snipers can't transfer tokens to sell cheaper until penalty timeframe is over.  DM a Mod.");
1121                 removeAllFee();
1122                 buyOrSellSwitch = TRANSFER; // TRANSFERs do not pay a tax.
1123             }
1124         }
1125         
1126         _tokenTransfer(from, to, amount, takeFee);
1127         
1128     }
1129 
1130     function swapBack() private lockTheSwap {
1131         uint256 contractBalance = balanceOf(address(this));
1132         uint256 totalTokensToSwap = _liquidityTokensToSwap + _marketingTokensToSwap;
1133         
1134         // Halve the amount of liquidity tokens
1135         uint256 tokensForLiquidity = _liquidityTokensToSwap.div(2);
1136         uint256 amountToSwapForETH = contractBalance.sub(tokensForLiquidity);
1137         
1138         uint256 initialETHBalance = address(this).balance;
1139 
1140         swapTokensForETH(amountToSwapForETH); 
1141         
1142         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1143         
1144         uint256 ethForMarketing = ethBalance.mul(_marketingTokensToSwap).div(totalTokensToSwap);
1145         
1146         uint256 ethForLiquidity = ethBalance.sub(ethForMarketing);
1147         
1148         uint256 ethForDev= ethForMarketing * 2 / 7; // 2/7 gos to dev
1149         ethForMarketing -= ethForDev;
1150         
1151         _liquidityTokensToSwap = 0;
1152         _marketingTokensToSwap = 0;
1153         
1154         (bool success,) = address(marketingAddress).call{value: ethForMarketing}("");
1155         (success,) = address(devAddress).call{value: ethForDev}("");
1156         
1157         addLiquidity(tokensForLiquidity, ethForLiquidity);
1158         emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1159         
1160         // send leftover BNB to the marketing wallet so it doesn't get stuck on the contract.
1161         if(address(this).balance > 1e17){
1162             (success,) = address(marketingAddress).call{value: address(this).balance}("");
1163         }
1164     }
1165     
1166     // force Swap back if slippage above 49% for launch.
1167     function forceSwapBack() external onlyOwner {
1168         uint256 contractBalance = balanceOf(address(this));
1169         require(contractBalance >= _tTotal / 100, "Can only swap back if more than 1% of tokens stuck on contract");
1170         swapBack();
1171         emit OwnerForcedSwapBack(block.timestamp);
1172     }
1173     
1174     function swapTokensForETH(uint256 tokenAmount) private {
1175         address[] memory path = new address[](2);
1176         path[0] = address(this);
1177         path[1] = uniswapV2Router.WETH();
1178         _approve(address(this), address(uniswapV2Router), tokenAmount);
1179         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1180             tokenAmount,
1181             0, // accept any amount of ETH
1182             path,
1183             address(this),
1184             block.timestamp
1185         );
1186     }
1187     
1188     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1189         _approve(address(this), address(uniswapV2Router), tokenAmount);
1190         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1191             address(this),
1192             tokenAmount,
1193             0, // slippage is unavoidable
1194             0, // slippage is unavoidable
1195             liquidityAddress,
1196             block.timestamp
1197         );
1198     }
1199 
1200     function _tokenTransfer(
1201         address sender,
1202         address recipient,
1203         uint256 amount,
1204         bool takeFee
1205     ) private {
1206         if (!takeFee) removeAllFee();
1207 
1208         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1209             _transferFromExcluded(sender, recipient, amount);
1210         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1211             _transferToExcluded(sender, recipient, amount);
1212         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1213             _transferBothExcluded(sender, recipient, amount);
1214         } else {
1215             _transferStandard(sender, recipient, amount);
1216         }
1217 
1218         if (!takeFee) restoreAllFee();
1219     }
1220 
1221     function _transferStandard(
1222         address sender,
1223         address recipient,
1224         uint256 tAmount
1225     ) private {
1226         (
1227             uint256 rAmount,
1228             uint256 rTransferAmount,
1229             uint256 rFee,
1230             uint256 tTransferAmount,
1231             uint256 tFee,
1232             uint256 tLiquidity
1233         ) = _getValues(tAmount);
1234         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1235         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1236         _takeLiquidity(tLiquidity);
1237         _reflectFee(rFee, tFee);
1238         emit Transfer(sender, recipient, tTransferAmount);
1239     }
1240 
1241     function _transferToExcluded(
1242         address sender,
1243         address recipient,
1244         uint256 tAmount
1245     ) private {
1246         (
1247             uint256 rAmount,
1248             uint256 rTransferAmount,
1249             uint256 rFee,
1250             uint256 tTransferAmount,
1251             uint256 tFee,
1252             uint256 tLiquidity
1253         ) = _getValues(tAmount);
1254         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1255         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1256         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1257         _takeLiquidity(tLiquidity);
1258         _reflectFee(rFee, tFee);
1259         emit Transfer(sender, recipient, tTransferAmount);
1260     }
1261 
1262     function _transferFromExcluded(
1263         address sender,
1264         address recipient,
1265         uint256 tAmount
1266     ) private {
1267         (
1268             uint256 rAmount,
1269             uint256 rTransferAmount,
1270             uint256 rFee,
1271             uint256 tTransferAmount,
1272             uint256 tFee,
1273             uint256 tLiquidity
1274         ) = _getValues(tAmount);
1275         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1276         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1277         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1278         _takeLiquidity(tLiquidity);
1279         _reflectFee(rFee, tFee);
1280         emit Transfer(sender, recipient, tTransferAmount);
1281     }
1282 
1283     function _transferBothExcluded(
1284         address sender,
1285         address recipient,
1286         uint256 tAmount
1287     ) private {
1288         (
1289             uint256 rAmount,
1290             uint256 rTransferAmount,
1291             uint256 rFee,
1292             uint256 tTransferAmount,
1293             uint256 tFee,
1294             uint256 tLiquidity
1295         ) = _getValues(tAmount);
1296         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1297         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1298         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1299         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1300         _takeLiquidity(tLiquidity);
1301         _reflectFee(rFee, tFee);
1302         emit Transfer(sender, recipient, tTransferAmount);
1303     }
1304 
1305     function _reflectFee(uint256 rFee, uint256 tFee) private {
1306         _rTotal = _rTotal.sub(rFee);
1307         _tFeeTotal = _tFeeTotal.add(tFee);
1308     }
1309 
1310     function _getValues(uint256 tAmount)
1311         private
1312         view
1313         returns (
1314             uint256,
1315             uint256,
1316             uint256,
1317             uint256,
1318             uint256,
1319             uint256
1320         )
1321     {
1322         (
1323             uint256 tTransferAmount,
1324             uint256 tFee,
1325             uint256 tLiquidity
1326         ) = _getTValues(tAmount);
1327         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
1328             tAmount,
1329             tFee,
1330             tLiquidity,
1331             _getRate()
1332         );
1333         return (
1334             rAmount,
1335             rTransferAmount,
1336             rFee,
1337             tTransferAmount,
1338             tFee,
1339             tLiquidity
1340         );
1341     }
1342 
1343     function _getTValues(uint256 tAmount)
1344         private
1345         view
1346         returns (
1347             uint256,
1348             uint256,
1349             uint256
1350         )
1351     {
1352         uint256 tFee = calculateTaxFee(tAmount);
1353         uint256 tLiquidity = calculateLiquidityFee(tAmount);
1354         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
1355         return (tTransferAmount, tFee, tLiquidity);
1356     }
1357 
1358     function _getRValues(
1359         uint256 tAmount,
1360         uint256 tFee,
1361         uint256 tLiquidity,
1362         uint256 currentRate
1363     )
1364         private
1365         pure
1366         returns (
1367             uint256,
1368             uint256,
1369             uint256
1370         )
1371     {
1372         uint256 rAmount = tAmount.mul(currentRate);
1373         uint256 rFee = tFee.mul(currentRate);
1374         uint256 rLiquidity = tLiquidity.mul(currentRate);
1375         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
1376         return (rAmount, rTransferAmount, rFee);
1377     }
1378 
1379     function _getRate() private view returns (uint256) {
1380         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1381         return rSupply.div(tSupply);
1382     }
1383 
1384     function _getCurrentSupply() private view returns (uint256, uint256) {
1385         uint256 rSupply = _rTotal;
1386         uint256 tSupply = _tTotal;
1387         for (uint256 i = 0; i < _excluded.length; i++) {
1388             if (
1389                 _rOwned[_excluded[i]] > rSupply ||
1390                 _tOwned[_excluded[i]] > tSupply
1391             ) return (_rTotal, _tTotal);
1392             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1393             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1394         }
1395         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1396         return (rSupply, tSupply);
1397     }
1398 
1399     function _takeLiquidity(uint256 tLiquidity) private {
1400         if(buyOrSellSwitch == BUY){
1401             _liquidityTokensToSwap += tLiquidity * _buyLiquidityFee / _liquidityFee;
1402             _marketingTokensToSwap += tLiquidity * _buyMarketingFee / _liquidityFee;
1403         } else if(buyOrSellSwitch == SELL){
1404             _liquidityTokensToSwap += tLiquidity * _sellLiquidityFee / _liquidityFee;
1405             _marketingTokensToSwap += tLiquidity * _sellMarketingFee / _liquidityFee;
1406         }
1407         uint256 currentRate = _getRate();
1408         uint256 rLiquidity = tLiquidity.mul(currentRate);
1409         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1410         if (_isExcluded[address(this)])
1411             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1412     }
1413 
1414     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1415         return _amount.mul(_taxFee).div(10**2);
1416     }
1417 
1418     function calculateLiquidityFee(uint256 _amount)
1419         private
1420         view
1421         returns (uint256)
1422     {
1423         return _amount.mul(_liquidityFee).div(10**2);
1424     }
1425 
1426     function removeAllFee() private {
1427         if (_taxFee == 0 && _liquidityFee == 0) return;
1428 
1429         _previousTaxFee = _taxFee;
1430         _previousLiquidityFee = _liquidityFee;
1431 
1432         _taxFee = 0;
1433         _liquidityFee = 0;
1434     }
1435 
1436     function restoreAllFee() private {
1437         _taxFee = _previousTaxFee;
1438         _liquidityFee = _previousLiquidityFee;
1439     }
1440 
1441     function isExcludedFromFee(address account) external view returns (bool) {
1442         return _isExcludedFromFee[account];
1443     }
1444     
1445      function removeBoughtEarly(address account) external onlyOwner {
1446         boughtEarly[account] = false;
1447         emit RemovedSniper(account);
1448     }
1449 
1450     function excludeFromFee(address account) external onlyOwner {
1451         _isExcludedFromFee[account] = true;
1452         emit ExcludeFromFee(account);
1453     }
1454 
1455     function includeInFee(address account) external onlyOwner {
1456         _isExcludedFromFee[account] = false;
1457         emit IncludeInFee(account);
1458     }
1459 
1460     function setBuyFee(uint256 buyTaxFee, uint256 buyLiquidityFee, uint256 buyMarketingFee)
1461         external
1462         onlyOwner
1463     {
1464         _buyTaxFee = buyTaxFee;
1465         _buyLiquidityFee = buyLiquidityFee;
1466         _buyMarketingFee = buyMarketingFee;
1467         require(_buyTaxFee + _buyLiquidityFee + _buyMarketingFee <= 10, "Must keep buy taxes below 10%");
1468         emit SetBuyFee(buyMarketingFee, buyLiquidityFee, buyTaxFee);
1469     }
1470 
1471     function setSellFee(uint256 sellTaxFee, uint256 sellLiquidityFee, uint256 sellMarketingFee)
1472         external
1473         onlyOwner
1474     {
1475         _sellTaxFee = sellTaxFee;
1476         _sellLiquidityFee = sellLiquidityFee;
1477         _sellMarketingFee = sellMarketingFee;
1478         require(_sellTaxFee + _sellLiquidityFee + _sellMarketingFee <= 15, "Must keep sell taxes below 15%");
1479         emit SetSellFee(sellMarketingFee, sellLiquidityFee, sellTaxFee);
1480     }
1481 
1482 
1483     function setMarketingAddress(address _marketingAddress) external onlyOwner {
1484         require(_marketingAddress != address(0), "_marketingAddress address cannot be 0");
1485         _isExcludedFromFee[marketingAddress] = false;
1486         marketingAddress = payable(_marketingAddress);
1487         _isExcludedFromFee[marketingAddress] = true;
1488         emit UpdatedMarketingAddress(_marketingAddress);
1489     }
1490     
1491     function setLiquidityAddress(address _liquidityAddress) public onlyOwner {
1492         require(_liquidityAddress != address(0), "_liquidityAddress address cannot be 0");
1493         liquidityAddress = payable(_liquidityAddress);
1494         _isExcludedFromFee[liquidityAddress] = true;
1495         emit UpdatedLiquidityAddress(_liquidityAddress);
1496     }
1497 
1498     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1499         swapAndLiquifyEnabled = _enabled;
1500         emit SwapAndLiquifyEnabledUpdated(_enabled);
1501     }
1502 
1503     // To receive ETH from uniswapV2Router when swapping
1504     receive() external payable {}
1505 
1506     function transferForeignToken(address _token, address _to)
1507         external
1508         onlyOwner
1509         returns (bool _sent)
1510     {
1511         require(_token != address(0), "_token address cannot be 0");
1512         require(_token != address(this), "Can't withdraw native tokens");
1513         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
1514         _sent = IERC20(_token).transfer(_to, _contractBalance);
1515         emit TransferForeignToken(_token, _contractBalance);
1516     }
1517     
1518     // withdraw ETH if stuck before launch
1519     function withdrawStuckETH() external onlyOwner {
1520         require(!tradingActive, "Can only withdraw if trading hasn't started");
1521         bool success;
1522         (success,) = address(msg.sender).call{value: address(this).balance}("");
1523     }
1524 }