1 // Copyright (c) 2021 EverRise Pte Ltd. All rights reserved.
2 // EverRise licenses this file to you under the MIT license.
3 /*
4 The EverRise token is the keystone in the EverRise Ecosytem of dApps
5  and the overaching key that unlocks multi-blockchain unification via
6  the EverBridge.
7 
8 On EverRise token txns 6% buyback and business development fees are collected
9 * 4% for token Buyback from the market, 
10      with bought back tokens directly distributed as staking rewards
11 * 2% for Business Development (Development, Sustainability and Marketing)
12 
13  ________                              _______   __
14 /        |                            /       \ /  |
15 $$$$$$$$/__     __  ______    ______  $$$$$$$  |$$/   _______   ______
16 $$ |__  /  \   /  |/      \  /      \ $$ |__$$ |/  | /       | /      \
17 $$    | $$  \ /$$//$$$$$$  |/$$$$$$  |$$    $$< $$ |/$$$$$$$/ /$$$$$$  |
18 $$$$$/   $$  /$$/ $$    $$ |$$ |  $$/ $$$$$$$  |$$ |$$      \ $$    $$ |
19 $$ |_____ $$ $$/  $$$$$$$$/ $$ |      $$ |  $$ |$$ | $$$$$$  |$$$$$$$$/
20 $$       | $$$/   $$       |$$ |      $$ |  $$ |$$ |/     $$/ $$       |
21 $$$$$$$$/   $/     $$$$$$$/ $$/       $$/   $$/ $$/ $$$$$$$/   $$$$$$$/
22 
23 Learn more about EverRise and the EverRise Ecosystem of dApps and
24 how our utilities, and our partners, can help protect your investors
25 and help your project grow: https://www.everrise.com
26 */
27 
28 // SPDX-License-Identifier: MIT
29 
30 pragma solidity 0.8.8;
31 
32 interface IERC20 {
33     event Transfer(address indexed from, address indexed to, uint256 value);
34 
35     event Approval(
36         address indexed owner,
37         address indexed spender,
38         uint256 value
39     );
40 
41     function transfer(address recipient, uint256 amount)
42         external
43         returns (bool);
44 
45     function approve(address spender, uint256 amount) external returns (bool);
46 
47     function transferFrom(
48         address sender,
49         address recipient,
50         uint256 amount
51     ) external returns (bool);
52 
53     function transferFromWithPermit(
54         address sender,
55         address recipient,
56         uint256 amount,
57         uint256 deadline,
58         uint8 v,
59         bytes32 r,
60         bytes32 s
61     ) external returns (bool);
62 
63     function totalSupply() external view returns (uint256);
64 
65     function balanceOf(address account) external view returns (uint256);
66 
67     function allowance(address owner, address spender)
68         external
69         view
70         returns (uint256);
71 }
72 
73 interface IUniswapV2Factory {
74     event PairCreated(
75         address indexed token0,
76         address indexed token1,
77         address pair,
78         uint256
79     );
80 
81     function createPair(address tokenA, address tokenB)
82         external
83         returns (address pair);
84 
85     function setFeeTo(address) external;
86 
87     function setFeeToSetter(address) external;
88 
89     function feeTo() external view returns (address);
90 
91     function feeToSetter() external view returns (address);
92 
93     function getPair(address tokenA, address tokenB)
94         external
95         view
96         returns (address pair);
97 
98     function allPairs(uint256) external view returns (address pair);
99 
100     function allPairsLength() external view returns (uint256);
101 }
102 
103 // pragma solidity >=0.5.0;
104 
105 interface IUniswapV2Pair {
106     event Approval(
107         address indexed owner,
108         address indexed spender,
109         uint256 value
110     );
111 
112     event Transfer(address indexed from, address indexed to, uint256 value);
113 
114     event Burn(
115         address indexed sender,
116         uint256 amount0,
117         uint256 amount1,
118         address indexed to
119     );
120 
121     event Swap(
122         address indexed sender,
123         uint256 amount0In,
124         uint256 amount1In,
125         uint256 amount0Out,
126         uint256 amount1Out,
127         address indexed to
128     );
129 
130     event Sync(uint112 reserve0, uint112 reserve1);
131 
132     function approve(address spender, uint256 value) external returns (bool);
133 
134     function transfer(address to, uint256 value) external returns (bool);
135 
136     function transferFrom(
137         address from,
138         address to,
139         uint256 value
140     ) external returns (bool);
141 
142     function burn(address to)
143         external
144         returns (uint256 amount0, uint256 amount1);
145 
146     function swap(
147         uint256 amount0Out,
148         uint256 amount1Out,
149         address to,
150         bytes calldata data
151     ) external;
152 
153     function skim(address to) external;
154 
155     function sync() external;
156 
157     function initialize(address, address) external;
158 
159     function permit(
160         address owner,
161         address spender,
162         uint256 value,
163         uint256 deadline,
164         uint8 v,
165         bytes32 r,
166         bytes32 s
167     ) external;
168 
169     function totalSupply() external view returns (uint256);
170 
171     function balanceOf(address owner) external view returns (uint256);
172 
173     function allowance(address owner, address spender)
174         external
175         view
176         returns (uint256);
177 
178     function DOMAIN_SEPARATOR() external view returns (bytes32);
179 
180     function nonces(address owner) external view returns (uint256);
181 
182     function factory() external view returns (address);
183 
184     function token0() external view returns (address);
185 
186     function token1() external view returns (address);
187 
188     function getReserves()
189         external
190         view
191         returns (
192             uint112 reserve0,
193             uint112 reserve1,
194             uint32 blockTimestampLast
195         );
196 
197     function price0CumulativeLast() external view returns (uint256);
198 
199     function price1CumulativeLast() external view returns (uint256);
200 
201     function kLast() external view returns (uint256);
202 
203     function name() external pure returns (string memory);
204 
205     function symbol() external pure returns (string memory);
206 
207     function decimals() external pure returns (uint8);
208 
209     function PERMIT_TYPEHASH() external pure returns (bytes32);
210 
211     function MINIMUM_LIQUIDITY() external pure returns (uint256);
212 }
213 
214 // pragma solidity >=0.6.2;
215 
216 interface IUniswapV2Router01 {
217     function addLiquidityETH(
218         address token,
219         uint256 amountTokenDesired,
220         uint256 amountTokenMin,
221         uint256 amountETHMin,
222         address to,
223         uint256 deadline
224     )
225         external
226         payable
227         returns (
228             uint256 amountToken,
229             uint256 amountETH,
230             uint256 liquidity
231         );
232 
233     function swapETHForExactTokens(
234         uint256 amountOut,
235         address[] calldata path,
236         address to,
237         uint256 deadline
238     ) external payable returns (uint256[] memory amounts);
239 
240     function swapExactETHForTokens(
241         uint256 amountOutMin,
242         address[] calldata path,
243         address to,
244         uint256 deadline
245     ) external payable returns (uint256[] memory amounts);
246 
247     function addLiquidity(
248         address tokenA,
249         address tokenB,
250         uint256 amountADesired,
251         uint256 amountBDesired,
252         uint256 amountAMin,
253         uint256 amountBMin,
254         address to,
255         uint256 deadline
256     )
257         external
258         returns (
259             uint256 amountA,
260             uint256 amountB,
261             uint256 liquidity
262         );
263 
264     function removeLiquidity(
265         address tokenA,
266         address tokenB,
267         uint256 liquidity,
268         uint256 amountAMin,
269         uint256 amountBMin,
270         address to,
271         uint256 deadline
272     ) external returns (uint256 amountA, uint256 amountB);
273 
274     function removeLiquidityETH(
275         address token,
276         uint256 liquidity,
277         uint256 amountTokenMin,
278         uint256 amountETHMin,
279         address to,
280         uint256 deadline
281     ) external returns (uint256 amountToken, uint256 amountETH);
282 
283     function removeLiquidityWithPermit(
284         address tokenA,
285         address tokenB,
286         uint256 liquidity,
287         uint256 amountAMin,
288         uint256 amountBMin,
289         address to,
290         uint256 deadline,
291         bool approveMax,
292         uint8 v,
293         bytes32 r,
294         bytes32 s
295     ) external returns (uint256 amountA, uint256 amountB);
296 
297     function removeLiquidityETHWithPermit(
298         address token,
299         uint256 liquidity,
300         uint256 amountTokenMin,
301         uint256 amountETHMin,
302         address to,
303         uint256 deadline,
304         bool approveMax,
305         uint8 v,
306         bytes32 r,
307         bytes32 s
308     ) external returns (uint256 amountToken, uint256 amountETH);
309 
310     function swapExactTokensForTokens(
311         uint256 amountIn,
312         uint256 amountOutMin,
313         address[] calldata path,
314         address to,
315         uint256 deadline
316     ) external returns (uint256[] memory amounts);
317 
318     function swapTokensForExactTokens(
319         uint256 amountOut,
320         uint256 amountInMax,
321         address[] calldata path,
322         address to,
323         uint256 deadline
324     ) external returns (uint256[] memory amounts);
325 
326     function swapTokensForExactETH(
327         uint256 amountOut,
328         uint256 amountInMax,
329         address[] calldata path,
330         address to,
331         uint256 deadline
332     ) external returns (uint256[] memory amounts);
333 
334     function swapExactTokensForETH(
335         uint256 amountIn,
336         uint256 amountOutMin,
337         address[] calldata path,
338         address to,
339         uint256 deadline
340     ) external returns (uint256[] memory amounts);
341 
342     function getAmountsOut(uint256 amountIn, address[] calldata path)
343         external
344         view
345         returns (uint256[] memory amounts);
346 
347     function getAmountsIn(uint256 amountOut, address[] calldata path)
348         external
349         view
350         returns (uint256[] memory amounts);
351 
352     function factory() external pure returns (address);
353 
354     function WETH() external pure returns (address);
355 
356     function quote(
357         uint256 amountA,
358         uint256 reserveA,
359         uint256 reserveB
360     ) external pure returns (uint256 amountB);
361 
362     function getAmountOut(
363         uint256 amountIn,
364         uint256 reserveIn,
365         uint256 reserveOut
366     ) external pure returns (uint256 amountOut);
367 
368     function getAmountIn(
369         uint256 amountOut,
370         uint256 reserveIn,
371         uint256 reserveOut
372     ) external pure returns (uint256 amountIn);
373 }
374 
375 // pragma solidity >=0.6.2;
376 
377 interface IUniswapV2Router02 is IUniswapV2Router01 {
378     function removeLiquidityETHSupportingFeeOnTransferTokens(
379         address token,
380         uint256 liquidity,
381         uint256 amountTokenMin,
382         uint256 amountETHMin,
383         address to,
384         uint256 deadline
385     ) external returns (uint256 amountETH);
386 
387     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
388         address token,
389         uint256 liquidity,
390         uint256 amountTokenMin,
391         uint256 amountETHMin,
392         address to,
393         uint256 deadline,
394         bool approveMax,
395         uint8 v,
396         bytes32 r,
397         bytes32 s
398     ) external returns (uint256 amountETH);
399 
400     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
401         uint256 amountIn,
402         uint256 amountOutMin,
403         address[] calldata path,
404         address to,
405         uint256 deadline
406     ) external;
407 
408     function swapExactETHForTokensSupportingFeeOnTransferTokens(
409         uint256 amountOutMin,
410         address[] calldata path,
411         address to,
412         uint256 deadline
413     ) external payable;
414 
415     function swapExactTokensForETHSupportingFeeOnTransferTokens(
416         uint256 amountIn,
417         uint256 amountOutMin,
418         address[] calldata path,
419         address to,
420         uint256 deadline
421     ) external;
422 }
423 
424 interface IEverStake {
425     function createRewards(address acount, uint256 tAmount) external;
426 
427     function deliver(uint256 tAmount) external;
428 
429     function getTotalAmountStaked() external view returns (uint256);
430 
431     function getTotalRewardsDistributed() external view returns (uint256);
432 }
433 
434 library SafeMath {
435     function add(uint256 a, uint256 b) internal pure returns (uint256) {
436         uint256 c = a + b;
437         require(c >= a, "SafeMath: addition overflow");
438 
439         return c;
440     }
441 
442     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
443         return sub(a, b, "SafeMath: subtraction overflow");
444     }
445 
446     function sub(
447         uint256 a,
448         uint256 b,
449         string memory errorMessage
450     ) internal pure returns (uint256) {
451         require(b <= a, errorMessage);
452         uint256 c = a - b;
453 
454         return c;
455     }
456 
457     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
458         if (a == 0) {
459             return 0;
460         }
461 
462         uint256 c = a * b;
463         require(c / a == b, "SafeMath: multiplication overflow");
464 
465         return c;
466     }
467 
468     function div(uint256 a, uint256 b) internal pure returns (uint256) {
469         return div(a, b, "SafeMath: division by zero");
470     }
471 
472     function div(
473         uint256 a,
474         uint256 b,
475         string memory errorMessage
476     ) internal pure returns (uint256) {
477         require(b > 0, errorMessage);
478         uint256 c = a / b;
479         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
480 
481         return c;
482     }
483 
484     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
485         return mod(a, b, "SafeMath: modulo by zero");
486     }
487 
488     function mod(
489         uint256 a,
490         uint256 b,
491         string memory errorMessage
492     ) internal pure returns (uint256) {
493         require(b != 0, errorMessage);
494         return a % b;
495     }
496 }
497 
498 // helper methods for discovering LP pair addresses
499 library PairHelper {
500     bytes private constant token0Selector =
501         abi.encodeWithSelector(IUniswapV2Pair.token0.selector);
502     bytes private constant token1Selector =
503         abi.encodeWithSelector(IUniswapV2Pair.token1.selector);
504 
505     function token0(address pair) internal view returns (address) {
506         return token(pair, token0Selector);
507     }
508 
509     function token1(address pair) internal view returns (address) {
510         return token(pair, token1Selector);
511     }
512 
513     function token(address pair, bytes memory selector)
514         private
515         view
516         returns (address)
517     {
518         // Do not check if pair is not a contract to avoid warning in txn log
519         if (!isContract(pair)) return address(0); 
520 
521         (bool success, bytes memory data) = pair.staticcall(selector);
522 
523         if (success && data.length >= 32) {
524             return abi.decode(data, (address));
525         }
526         
527         return address(0);
528     }
529 
530     function isContract(address account) private view returns (bool) {
531         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
532         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
533         // for accounts without code, i.e. `keccak256('')`
534         bytes32 codehash;
535         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
536         // solhint-disable-next-line no-inline-assembly
537         assembly {
538             codehash := extcodehash(account)
539         }
540 
541         return (codehash != accountHash && codehash != 0x0);
542     }
543 }
544 
545 abstract contract Context {
546     function _msgSender() internal view virtual returns (address payable) {
547         return payable(msg.sender);
548     }
549 
550     function _msgData() internal view virtual returns (bytes memory) {
551         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
552         return msg.data;
553     }
554 }
555 
556 contract Ownable is Context {
557     address private _owner;
558     address private _buybackOwner;
559 
560     event OwnershipTransferred(
561         address indexed previousOwner,
562         address indexed newOwner
563     );
564 
565     modifier onlyOwner() {
566         require(_owner == _msgSender(), "Ownable: caller is not the owner");
567         _;
568     }
569 
570     modifier onlyBuybackOwner() {
571         require(
572             _buybackOwner == _msgSender(),
573             "Ownable: caller is not the buyback owner"
574         );
575         _;
576     }
577 
578     constructor() {
579         address msgSender = _msgSender();
580         _owner = msgSender;
581         _buybackOwner = msgSender;
582         emit OwnershipTransferred(address(0), msgSender);
583     }
584 
585     // Allow contract ownership and access to contract onlyOwner functions
586     // to be locked using EverOwn with control gated by community vote.
587     //
588     // EverRise ($RISE) stakers become voting members of the
589     // decentralized autonomous organization (DAO) that controls access
590     // to the token contract via the EverRise Ecosystem dApp EverOwn
591     function transferOwnership(address newOwner) external virtual onlyOwner {
592         require(newOwner != address(0), "Ownable: new owner is the zero address");
593 
594         emit OwnershipTransferred(_owner, newOwner);
595         _owner = newOwner;
596     }
597 
598     function transferBuybackOwnership(address newOwner)
599         external
600         virtual
601         onlyOwner
602     {
603         require(
604             newOwner != address(0),
605             "Ownable: new owner is the zero address"
606         );
607 
608         emit OwnershipTransferred(_buybackOwner, newOwner);
609         _buybackOwner = newOwner;
610     }
611 
612     function owner() public view returns (address) {
613         return _owner;
614     }
615 
616     function buybackOwner() public view returns (address) {
617         return _buybackOwner;
618     }
619 }
620 
621 contract EverRise is Context, IERC20, Ownable {
622     using SafeMath for uint256;
623     using PairHelper for address;
624 
625     struct TransferDetails {
626         uint112 balance0;
627         uint112 balance1;
628         uint32 blockNumber;
629         address to;
630         address origin;
631     }
632 
633     address payable public businessDevelopmentAddress =
634         payable(0x23F4d6e1072E42e5d25789e3260D19422C2d3674); // Business Development Address
635     address public stakingAddress;
636     address public everMigrateAddress;
637 
638     mapping(address => uint256) private _tOwned;
639     mapping(address => mapping(address => uint256)) private _allowances;
640     mapping(address => uint256) private lastCoolDownTrade;
641 
642     mapping(address => bool) private _isExcludedFromFee;
643     mapping(address => bool) private _isEverRiseEcosystemContract;
644     address[] public allEcosystemContracts;
645 
646     mapping(address => bool) private _isAuthorizedSwapToken;
647     address[] public allAuthorizedSwapTokens;
648 
649     uint256 private constant MAX = ~uint256(0);
650 
651     string private constant _name = "EverRise";
652     string private constant _symbol = "RISE";
653     // Large data type for maths
654     uint256 private constant _decimals = 18;
655     // Short data type for decimals function (no per function conversion)
656     uint8 private constant _decimalsShort = uint8(_decimals);
657     // Golden supply
658     uint256 private constant _tTotal = 7_1_618_033_988 * 10**_decimals;
659 
660     uint256 private _holders = 0;
661 
662     // Fee and max txn are set by setTradingEnabled
663     // to allow upgrading balances to arrange their wallets
664     // and stake their assets before trading start
665     uint256 public liquidityFee = 0;
666     uint256 private _previousLiquidityFee = liquidityFee;
667     uint256 private _maxTxAmount = _tTotal;
668     
669     uint256 private constant _tradeStartLiquidityFee = 6;
670     uint256 private _tradeStartMaxTxAmount = _tTotal.div(1000); // Max txn 0.1% of supply
671 
672     uint256 public businessDevelopmentDivisor = 2;
673 
674     uint256 private minimumTokensBeforeSwap = 5 * 10**6 * 10**_decimals;
675     uint256 private buyBackUpperLimit = 10 * 10**18;
676     uint256 private buyBackTriggerTokenLimit = 1 * 10**6 * 10**_decimals;
677     uint256 private buyBackMinAvailability = 1 * 10**18; //1 BNB
678 
679     uint256 private buyVolume = 0;
680     uint256 private sellVolume = 0;
681     uint256 public totalBuyVolume = 0;
682     uint256 public totalSellVolume = 0;
683     uint256 public totalVolume = 0;
684     uint256 private nextBuybackAmount = 0;
685     uint256 private buyBackTriggerVolume = 100 * 10**6 * 10**_decimals;
686 
687     uint256 private tradingStart = MAX;
688     uint256 private tradingStartCooldown = MAX;
689 
690     // Booleans are more expensive than uint256 or any type that takes up a full
691     // word because each write operation emits an extra SLOAD to first read the
692     // slot's contents, replace the bits taken up by the boolean, and then write
693     // back. This is the compiler's defense against contract upgrades and
694     // pointer aliasing, and it cannot be disabled.
695     uint256 private constant _FALSE = 1;
696     uint256 private constant _TRUE = 2;
697 
698     uint256 private _checkingTokens;
699     uint256 private _inSwapAndLiquify;
700 
701     // Infrequently set booleans
702     bool public swapAndLiquifyEnabled = false;
703     bool public buyBackEnabled = false;
704     bool public liquidityLocked = false;
705 
706     IUniswapV2Router02 public uniswapV2Router;
707     address public uniswapV2Pair;
708 
709     IEverStake stakeToken;
710 
711     bytes32 public immutable DOMAIN_SEPARATOR;
712     // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
713     bytes32 public constant PERMIT_TYPEHASH =
714         0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
715     mapping(address => uint256) public nonces;
716 
717     TransferDetails lastTransfer;
718 
719     event BuyBackEnabledUpdated(bool enabled);
720     event SwapAndLiquifyEnabledUpdated(bool enabled);
721     event SwapAndLiquify(
722         uint256 tokensSwapped,
723         uint256 ethReceived,
724         uint256 tokensIntoLiquidity
725     );
726 
727     event SwapETHForTokens(uint256 amountIn, address[] path);
728     event SwapTokensForETH(uint256 amountIn, address[] path);
729     event SwapTokensForTokens(uint256 amountIn, address[] path);
730 
731     event ExcludeFromFeeUpdated(address account);
732     event IncludeInFeeUpdated(address account);
733 
734     event LiquidityFeeUpdated(uint256 prevValue, uint256 newValue);
735     event MaxTxAmountUpdated(uint256 prevValue, uint256 newValue);
736     event BusinessDevelopmentDivisorUpdated(
737         uint256 prevValue,
738         uint256 newValue
739     );
740     event MinTokensBeforeSwapUpdated(uint256 prevValue, uint256 newValue);
741     event BuybackMinAvailabilityUpdated(uint256 prevValue, uint256 newValue);
742 
743     event TradingEnabled();
744     event BuyBackAndRewardStakers(uint256 amount);
745     event BuybackUpperLimitUpdated(uint256 prevValue, uint256 newValue);
746     event BuyBackTriggerTokenLimitUpdated(uint256 prevValue, uint256 newValue);
747 
748     event RouterAddressUpdated(address prevAddress, address newAddress);
749     event BusinessDevelopmentAddressUpdated(
750         address prevAddress,
751         address newAddress
752     );
753     event StakingAddressUpdated(address prevAddress, address newAddress);
754     event EverMigrateAddressUpdated(address prevAddress, address newAddress);
755 
756     event EverRiseEcosystemContractAdded(address contractAddress);
757     event EverRiseEcosystemContractRemoved(address contractAddress);
758 
759     event HoldersIncreased(uint256 prevValue, uint256 newValue);
760     event HoldersDecreased(uint256 prevValue, uint256 newValue);
761 
762     event AuthorizedSwapTokenAdded(address tokenAddress);
763     event AuthorizedSwapTokenRemoved(address tokenAddress);
764 
765     event LiquidityLocked();
766     event LiquidityUnlocked();
767 
768     event StakingIncreased(uint256 amount);
769     event StakingDecreased(uint256 amount);
770 
771     modifier lockTheSwap() {
772         require(_inSwapAndLiquify != _TRUE);
773         _inSwapAndLiquify = _TRUE;
774         _;
775         // By storing the original value once again, a refund is triggered (see
776         // https://eips.ethereum.org/EIPS/eip-2200)
777         _inSwapAndLiquify = _FALSE;
778     }
779 
780     modifier tokenCheck() {
781         require(_checkingTokens != _TRUE);
782         _checkingTokens = _TRUE;
783         _;
784         // By storing the original value once again, a refund is triggered (see
785         // https://eips.ethereum.org/EIPS/eip-2200)
786         _checkingTokens = _FALSE;
787     }
788 
789     constructor(address _stakingAddress, address routerAddress) {
790         require(
791             _stakingAddress != address(0),
792             "_stakingAddress should not be to the zero address"
793         );
794         require(
795             routerAddress != address(0),
796             "routerAddress should not be the zero address"
797         );
798 
799 
800         // The values being non-zero value makes deployment a bit more expensive,
801         // but in exchange the refund on every call to modifiers will be lower in
802         // amount. Since refunds are capped to a percentage of the total
803         // transaction's gas, it is best to keep them low in cases like this one, to
804         // increase the likelihood of the full refund coming into effect.
805         _checkingTokens = _FALSE;
806         _inSwapAndLiquify = _FALSE;
807 
808         stakingAddress = _stakingAddress;
809         stakeToken = IEverStake(_stakingAddress);
810 
811         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(routerAddress);
812         // IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x10ED43C718714eb63d5aA57B78B54704E256024E); //Pancakeswap router mainnet - BSC
813         // IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0xD99D1c33F9fC3444f8101754aBC46c52416550D1); //Testnet
814         // IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x1b02dA8Cb0d097eB8D57A175b88c7D8b47997506); //Sushiswap router mainnet - Polygon
815         // IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); //Uniswap V2 router mainnet - ETH
816         // IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0xa5e0829caced8ffdd4de3c43696c57f7d7a678ff); //Quickswap V2 router mainnet - Polygon
817         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
818             .createPair(address(this), _uniswapV2Router.WETH());
819 
820         uniswapV2Router = _uniswapV2Router;
821 
822         DOMAIN_SEPARATOR = keccak256(
823             abi.encode(
824                 keccak256(
825                     "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
826                 ),
827                 keccak256(bytes(_name)),
828                 keccak256(bytes("1")),
829                 block.chainid,
830                 address(this)
831             )
832         );
833         _tOwned[_msgSender()] = _tTotal;
834         // Track holder change
835         _holders = 1;
836         emit HoldersIncreased(0, 1);
837 
838         _isExcludedFromFee[owner()] = true;
839         _isExcludedFromFee[address(this)] = true;
840 
841         _everRiseEcosystemContractAdd(_stakingAddress);
842         authorizedSwapTokenAdd(address(this));
843         authorizedSwapTokenAdd(uniswapV2Router.WETH());
844 
845         emit Transfer(address(0), _msgSender(), _tTotal);
846         lockLiquidity();
847     }
848 
849     // Function to receive ETH when msg.data is be empty
850     // Receives ETH from uniswapV2Router when swapping
851     receive() external payable {}
852 
853     // Fallback function to receive ETH when msg.data is not empty
854     fallback() external payable {}
855 
856     function transferBalance() external onlyOwner {
857         _msgSender().transfer(address(this).balance);
858     }
859 
860     function transfer(address recipient, uint256 amount)
861         external
862         override
863         returns (bool)
864     {
865         _transfer(_msgSender(), recipient, amount);
866         return true;
867     }
868 
869     function approve(address spender, uint256 amount)
870         external
871         override
872         returns (bool)
873     {
874         _approve(_msgSender(), spender, amount);
875         return true;
876     }
877 
878     function transferFrom(
879         address sender,
880         address recipient,
881         uint256 amount
882     ) external override returns (bool) {
883         _transfer(sender, recipient, amount);
884         _approve(
885             sender,
886             _msgSender(),
887             _allowances[sender][_msgSender()].sub(
888                 amount,
889                 "ERC20: transfer amount exceeds allowance"
890             )
891         );
892         return true;
893     }
894 
895     function transferFromWithPermit(
896         address sender,
897         address recipient,
898         uint256 amount,
899         uint256 deadline,
900         uint8 v,
901         bytes32 r,
902         bytes32 s
903     ) external returns (bool) {
904         permit(sender, _msgSender(), amount, deadline, v, r, s);
905         _transfer(sender, recipient, amount);
906         _approve(
907             sender,
908             _msgSender(),
909             _allowances[sender][_msgSender()].sub(
910                 amount,
911                 "ERC20: transfer amount exceeds allowance"
912             )
913         );
914         return true;
915     }
916 
917     function increaseAllowance(address spender, uint256 addedValue)
918         external
919         virtual
920         returns (bool)
921     {
922         _approve(
923             _msgSender(),
924             spender,
925             _allowances[_msgSender()][spender].add(addedValue)
926         );
927         return true;
928     }
929 
930     function decreaseAllowance(address spender, uint256 subtractedValue)
931         external
932         virtual
933         returns (bool)
934     {
935         _approve(
936             _msgSender(),
937             spender,
938             _allowances[_msgSender()][spender].sub(
939                 subtractedValue,
940                 "ERC20: decreased allowance below zero"
941             )
942         );
943         return true;
944     }
945 
946     function manualBuyback(uint256 amount, uint256 numOfDecimals)
947         external
948         onlyBuybackOwner
949     {
950         require(amount > 0 && numOfDecimals >= 0, "Invalid Input");
951 
952         uint256 value = amount.mul(10**18).div(10**numOfDecimals);
953 
954         uint256 tokensReceived = swapETHForTokensNoFee(
955             address(this),
956             stakingAddress,
957             value
958         );
959 
960         //Distribute the rewards to the staking pool
961         distributeStakingRewards(tokensReceived);
962     }
963 
964     function swapTokens(
965         address fromToken,
966         address toToken,
967         uint256 amount,
968         uint256 numOfDecimals,
969         uint256 fromTokenDecimals
970     ) external onlyBuybackOwner {
971         require(_isAuthorizedSwapToken[fromToken], "fromToken is not an authorized token");
972         require(_isAuthorizedSwapToken[toToken], "toToken is not an authorized token");
973 
974         uint256 actualAmount = amount
975             .mul(10**fromTokenDecimals)
976             .div(10**numOfDecimals);
977 
978         if (toToken == uniswapV2Router.WETH()) {
979             swapTokensForEth(fromToken, address(this), actualAmount);
980         } else if (fromToken == uniswapV2Router.WETH()) {
981             swapETHForTokens(toToken, address(this), actualAmount);
982         } else {
983             swapTokensForTokens(
984                 fromToken,
985                 toToken,
986                 address(this),
987                 actualAmount
988             );
989         }
990     }
991 
992     function lockLiquidity() public onlyOwner {
993         liquidityLocked = true;
994         emit LiquidityLocked();
995     }
996 
997     function unlockLiquidity() external onlyOwner {
998         liquidityLocked = false;
999         emit LiquidityUnlocked();
1000     }
1001 
1002     function excludeFromFee(address account) external onlyOwner {
1003         require(
1004             !_isExcludedFromFee[account],
1005             "Account is not excluded for fees"
1006         );
1007 
1008         _excludeFromFee(account);
1009     }
1010 
1011     function includeInFee(address account) external onlyOwner {
1012         require(
1013             _isExcludedFromFee[account],
1014             "Account is not included for fees"
1015         );
1016 
1017         _includeInFee(account);
1018     }
1019 
1020     function setLiquidityFeePercent(uint256 liquidityFeeRate) external onlyOwner {
1021         require(liquidityFeeRate <= 10, "liquidityFeeRate should be less than 10%");
1022 
1023         uint256 prevValue = liquidityFee;
1024         liquidityFee = liquidityFeeRate;
1025         emit LiquidityFeeUpdated(prevValue, liquidityFee);
1026     }
1027 
1028     function setMaxTxAmount(uint256 txAmount) external onlyOwner {
1029         uint256 prevValue = _maxTxAmount;
1030         _maxTxAmount = txAmount;
1031         emit MaxTxAmountUpdated(prevValue, txAmount);
1032     }
1033 
1034     function setBusinessDevelopmentDivisor(uint256 divisor) external onlyOwner {
1035         require(
1036             divisor <= liquidityFee,
1037             "Business Development divisor should be less than liquidity fee"
1038         );
1039 
1040         uint256 prevValue = businessDevelopmentDivisor;
1041         businessDevelopmentDivisor = divisor;
1042         emit BusinessDevelopmentDivisorUpdated(
1043             prevValue,
1044             businessDevelopmentDivisor
1045         );
1046     }
1047 
1048     function setNumTokensSellToAddToLiquidity(uint256 _minimumTokensBeforeSwap)
1049         external
1050         onlyOwner
1051     {
1052         uint256 prevValue = minimumTokensBeforeSwap;
1053         minimumTokensBeforeSwap = _minimumTokensBeforeSwap;
1054         emit MinTokensBeforeSwapUpdated(prevValue, minimumTokensBeforeSwap);
1055     }
1056 
1057     function setBuybackUpperLimit(uint256 buyBackLimit, uint256 numOfDecimals)
1058         external
1059         onlyBuybackOwner
1060     {
1061         uint256 prevValue = buyBackUpperLimit;
1062         buyBackUpperLimit = buyBackLimit
1063             .mul(10**18)
1064             .div(10**numOfDecimals);
1065         emit BuybackUpperLimitUpdated(prevValue, buyBackUpperLimit);
1066     }
1067 
1068     function setBuybackTriggerTokenLimit(uint256 buyBackTriggerLimit)
1069         external
1070         onlyBuybackOwner
1071     {
1072         uint256 prevValue = buyBackTriggerTokenLimit;
1073         buyBackTriggerTokenLimit = buyBackTriggerLimit;
1074         emit BuyBackTriggerTokenLimitUpdated(
1075             prevValue,
1076             buyBackTriggerTokenLimit
1077         );
1078     }
1079 
1080     function setBuybackMinAvailability(uint256 amount, uint256 numOfDecimals)
1081         external
1082         onlyBuybackOwner
1083     {
1084         uint256 prevValue = buyBackMinAvailability;
1085         buyBackMinAvailability = amount
1086             .mul(10**18)
1087             .div(10**numOfDecimals);
1088         emit BuybackMinAvailabilityUpdated(prevValue, buyBackMinAvailability);
1089     }
1090 
1091     function setBuyBackEnabled(bool _enabled) public onlyBuybackOwner {
1092         buyBackEnabled = _enabled;
1093         emit BuyBackEnabledUpdated(_enabled);
1094     }
1095 
1096     function setTradingEnabled(uint256 _tradeStartDelay, uint256 _tradeStartCoolDown) external onlyOwner {
1097         require(_tradeStartDelay < 10, "tradeStartDelay should be less than 10 minutes");
1098         require(_tradeStartCoolDown < 120, "tradeStartCoolDown should be less than 120 minutes");
1099         require(_tradeStartDelay < _tradeStartCoolDown, "tradeStartDelay must be less than tradeStartCoolDown");
1100         // Can only be called once
1101         require(tradingStart == MAX && tradingStartCooldown == MAX, "Trading has already started");
1102         // Set initial values
1103         liquidityFee = _tradeStartLiquidityFee;
1104         _previousLiquidityFee = liquidityFee;
1105         _maxTxAmount = _tradeStartMaxTxAmount;
1106 
1107         setBuyBackEnabled(true);
1108         setSwapAndLiquifyEnabled(true);
1109         // Add time buffer to allow switching on trading on every chain
1110         // before announcing to community
1111         tradingStart = block.timestamp + _tradeStartDelay * 1 minutes;
1112         tradingStartCooldown = tradingStart + _tradeStartCoolDown * 1 minutes;
1113         // Announce to blockchain immediately, even though trades
1114         // can't start until delay passes (snipers no sniping)
1115         emit TradingEnabled();
1116     }
1117 
1118     function setBusinessDevelopmentAddress(address _businessDevelopmentAddress)
1119         external
1120         onlyOwner
1121     {
1122         require(
1123             _businessDevelopmentAddress != address(0),
1124             "_businessDevelopmentAddress should not be the zero address"
1125         );
1126 
1127         address prevAddress = businessDevelopmentAddress;
1128         businessDevelopmentAddress = payable(_businessDevelopmentAddress);
1129         emit BusinessDevelopmentAddressUpdated(
1130             prevAddress,
1131             _businessDevelopmentAddress
1132         );
1133     }
1134 
1135     function setEverMigrateAddress(address _everMigrateAddress)
1136         external
1137         onlyOwner
1138     {
1139         require(
1140             _everMigrateAddress != address(0),
1141             "_everMigrateAddress should not be the zero address"
1142         );
1143 
1144         address prevAddress = everMigrateAddress;
1145         everMigrateAddress = _everMigrateAddress;
1146         emit EverMigrateAddressUpdated(prevAddress, _everMigrateAddress);
1147 
1148         _everRiseEcosystemContractAdd(_everMigrateAddress);
1149     }
1150 
1151     function setStakingAddress(address _stakingAddress) external onlyOwner {
1152         require(
1153             _stakingAddress != address(0),
1154             "_stakingAddress should not be to zero address"
1155         );
1156 
1157         address prevAddress = stakingAddress;
1158         stakingAddress = _stakingAddress;
1159         stakeToken = IEverStake(_stakingAddress);
1160         emit StakingAddressUpdated(prevAddress, _stakingAddress);
1161 
1162         _everRiseEcosystemContractAdd(_stakingAddress);
1163     }
1164 
1165     function setRouterAddress(address routerAddress) external onlyOwner {
1166         require(
1167             routerAddress != address(0),
1168             "routerAddress should not be the zero address"
1169         );
1170 
1171         address prevAddress = address(uniswapV2Router);
1172         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(routerAddress); 
1173         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).getPair(
1174             address(this),
1175             _uniswapV2Router.WETH()
1176         );
1177 
1178         uniswapV2Router = _uniswapV2Router;
1179         emit RouterAddressUpdated(prevAddress, routerAddress);
1180     }
1181 
1182     function everRiseEcosystemContractAdd(address contractAddress) external onlyOwner {
1183         require(contractAddress != address(0), "contractAddress should not be the zero address");
1184         require(contractAddress != address(this), "EverRise token should not be added as an Ecosystem contract");
1185         require(
1186             !_isEverRiseEcosystemContract[contractAddress],
1187             "contractAddress is already included as an EverRise Ecosystem contract"
1188         );
1189 
1190         _everRiseEcosystemContractAdd(contractAddress);
1191     }
1192 
1193     function everRiseEcosystemContractRemove(address contractAddress) external onlyOwner {
1194         require(
1195             _isEverRiseEcosystemContract[contractAddress],
1196             "contractAddress is not included as EverRise Ecosystem contract"
1197         );
1198 
1199         _isEverRiseEcosystemContract[contractAddress] = false;
1200 
1201         for (uint256 i = 0; i < allEcosystemContracts.length; i++) {
1202             if (allEcosystemContracts[i] == contractAddress) {
1203                 allEcosystemContracts[i] = allEcosystemContracts[allEcosystemContracts.length - 1];
1204                 allEcosystemContracts.pop();
1205                 break;
1206             }
1207         }
1208 
1209         emit EverRiseEcosystemContractRemoved(contractAddress);
1210         _includeInFee(contractAddress);
1211     }
1212 
1213     function balanceOf(address account)
1214         external
1215         view
1216         override
1217         returns (uint256)
1218     {
1219         uint256 balance0 = _balanceOf(account);
1220         if (
1221             !inSwapAndLiquify() &&
1222             lastTransfer.blockNumber == uint32(block.number) &&
1223             account == lastTransfer.to
1224         ) {
1225             // Balance being checked is same address as last to in _transfer
1226             // check if likely same txn and a Liquidity Add
1227             _validateIfLiquidityAdd(account, uint112(balance0));
1228         }
1229 
1230         return balance0;
1231     }
1232 
1233     function maxTxAmount() external view returns (uint256) {
1234         if (isTradingEnabled() && inTradingStartCoolDown()) {
1235             uint256 maxTxn = maxTxCooldownAmount();
1236             return maxTxn < _maxTxAmount ? maxTxn : _maxTxAmount;
1237         }
1238 
1239         return _maxTxAmount;
1240     }
1241 
1242     function allowance(address owner, address spender)
1243         external
1244         view
1245         override
1246         returns (uint256)
1247     {
1248         return _allowances[owner][spender];
1249     }
1250 
1251     function getTotalAmountStaked() external view returns (uint256)
1252     {
1253         return stakeToken.getTotalAmountStaked();
1254     }
1255 
1256     function getTotalRewardsDistributed() external view returns (uint256)
1257     {
1258         return stakeToken.getTotalRewardsDistributed();
1259     }
1260 
1261     function holders() external view returns (uint256) {
1262         return _holders;
1263     }
1264 
1265     function minimumTokensBeforeSwapAmount() external view returns (uint256) {
1266         return minimumTokensBeforeSwap;
1267     }
1268 
1269     function buyBackUpperLimitAmount() external view returns (uint256) {
1270         return buyBackUpperLimit;
1271     }
1272 
1273     function isExcludedFromFee(address account) external view returns (bool) {
1274         return _isExcludedFromFee[account];
1275     }
1276 
1277     function allEcosystemContractsLength() external view returns (uint) {
1278         return allEcosystemContracts.length;
1279     }
1280 
1281     function allAuthorizedSwapTokensLength() external view returns (uint) {
1282         return allAuthorizedSwapTokens.length;
1283     }
1284 
1285     function totalSupply() external pure override returns (uint256) {
1286         return _tTotal;
1287     }
1288 
1289     function name() external pure returns (string memory) {
1290         return _name;
1291     }
1292 
1293     function symbol() external pure returns (string memory) {
1294         return _symbol;
1295     }
1296 
1297     function decimals() external pure returns (uint8) {
1298         return _decimalsShort;
1299     }
1300 
1301     function authorizedSwapTokenAdd(address tokenAddress) public onlyOwner {
1302         require(tokenAddress != address(0), "tokenAddress should not be the zero address");
1303         require(!_isAuthorizedSwapToken[tokenAddress], "tokenAddress is already an authorized token");
1304 
1305         _isAuthorizedSwapToken[tokenAddress] = true;
1306         allAuthorizedSwapTokens.push(tokenAddress);
1307 
1308         emit AuthorizedSwapTokenAdded(tokenAddress);
1309     }
1310 
1311     function authorizedSwapTokenRemove(address tokenAddress) public onlyOwner {
1312         require(tokenAddress != address(this), "cannot remove this contract from authorized tokens");
1313         require(tokenAddress != uniswapV2Router.WETH(), "cannot remove the WETH type contract from authorized tokens");
1314         require(_isAuthorizedSwapToken[tokenAddress], "tokenAddress is not an authorized token");
1315 
1316         _isAuthorizedSwapToken[tokenAddress] = false;
1317 
1318         for (uint256 i = 0; i < allAuthorizedSwapTokens.length; i++) {
1319             if (allAuthorizedSwapTokens[i] == tokenAddress) {
1320                 allAuthorizedSwapTokens[i] = allAuthorizedSwapTokens[allAuthorizedSwapTokens.length - 1];
1321                 allAuthorizedSwapTokens.pop();
1322                 break;
1323             }
1324         }
1325 
1326         emit AuthorizedSwapTokenRemoved(tokenAddress);
1327     }
1328 
1329     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1330         swapAndLiquifyEnabled = _enabled;
1331         emit SwapAndLiquifyEnabledUpdated(_enabled);
1332     }
1333 
1334     function isTradingEnabled() public view returns (bool) {
1335         // Trading has been set and has time buffer has elapsed
1336         return tradingStart < block.timestamp;
1337     }
1338 
1339     function inTradingStartCoolDown() public view returns (bool) {
1340         // Trading has been started and the cool down period has elapsed
1341         return tradingStartCooldown >= block.timestamp;
1342     }
1343 
1344     function maxTxCooldownAmount() public pure returns (uint256) {
1345         return _tTotal.div(2000);
1346     }
1347 
1348     function _approve(
1349         address owner,
1350         address spender,
1351         uint256 amount
1352     ) private {
1353         require(owner != address(0), "ERC20: approve from the zero address");
1354         require(spender != address(0), "ERC20: approve to the zero address");
1355 
1356         _allowances[owner][spender] = amount;
1357         emit Approval(owner, spender, amount);
1358     }
1359 
1360     function _transfer(
1361         address from,
1362         address to,
1363         uint256 amount
1364     ) private {
1365         require(from != address(0), "ERC20: transfer from the zero address");
1366         require(to != address(0), "ERC20: transfer to the zero address");
1367         require(amount > 0, "Transfer amount must be greater than zero");
1368         require(from != to, "Transfer to and from addresses the same");
1369         require(!inTokenCheck(), "Invalid reentrancy from token0/token1 balanceOf check");
1370 
1371         address _owner = owner();
1372         bool isIgnoredAddress = from == _owner || to == _owner ||
1373              _isEverRiseEcosystemContract[from] || _isEverRiseEcosystemContract[to];
1374         
1375         bool _isTradingEnabled = isTradingEnabled();
1376 
1377         require(amount <= _maxTxAmount || isIgnoredAddress || !_isTradingEnabled,
1378             "Transfer amount exceeds the maxTxAmount");
1379         
1380         address _pair = uniswapV2Pair;
1381         require(_isTradingEnabled || isIgnoredAddress || (from != _pair && to != _pair),
1382             "Trading is not enabled");
1383 
1384         bool notInSwapAndLiquify = !inSwapAndLiquify();
1385         if (_isTradingEnabled && inTradingStartCoolDown() && !isIgnoredAddress && notInSwapAndLiquify) {
1386             validateDuringTradingCoolDown(to, from, amount);
1387         }
1388 
1389         uint256 contractTokenBalance = _balanceOf(address(this));
1390         bool overMinimumTokenBalance = contractTokenBalance >=
1391             minimumTokensBeforeSwap;
1392 
1393         bool contractAction = _isTradingEnabled &&
1394             notInSwapAndLiquify &&
1395             swapAndLiquifyEnabled &&
1396             to == _pair;
1397 
1398         // Following block is for the contract to convert the tokens to ETH and do the buy back
1399         if (contractAction) {
1400             if (overMinimumTokenBalance) {
1401                 contractTokenBalance = minimumTokensBeforeSwap;
1402                 swapTokens(contractTokenBalance);
1403             }
1404             if (buyBackEnabled &&
1405                 address(this).balance > buyBackMinAvailability &&
1406                 buyVolume.add(sellVolume) > buyBackTriggerVolume
1407             ) {
1408                 if (nextBuybackAmount > address(this).balance) {
1409                     // Don't try to buyback more than is available.
1410                     // For example some "ETH" balance may have been
1411                     // temporally switched to stable coin in crypto-market
1412                     // downturn using swapTokens, for switching back later
1413                     nextBuybackAmount = address(this).balance;
1414                 }
1415 
1416                 if (nextBuybackAmount > 0) {
1417                     uint256 tokensReceived = buyBackTokens(nextBuybackAmount);
1418                     //Distribute the rewards to the staking pool
1419                     distributeStakingRewards(tokensReceived);
1420                     nextBuybackAmount = 0; //reset the next buyback amount
1421                     buyVolume = 0; //reset the buy volume
1422                     sellVolume = 0; // reset the sell volume
1423                 }
1424             }
1425         }
1426 
1427         if (_isTradingEnabled) {
1428             // Compute Sell Volume and set the next buyback amount
1429             if (to == _pair) {
1430                 sellVolume = sellVolume.add(amount);
1431                 totalSellVolume = totalSellVolume.add(amount);
1432                 if (amount > buyBackTriggerTokenLimit) {
1433                     uint256 balance = address(this).balance;
1434                     if (balance > buyBackUpperLimit) balance = buyBackUpperLimit;
1435                     nextBuybackAmount = nextBuybackAmount.add(balance.div(100));
1436                 }
1437             }
1438             // Compute Buy Volume
1439             else if (from == _pair) {
1440                 buyVolume = buyVolume.add(amount);
1441                 totalBuyVolume = totalBuyVolume.add(amount);
1442             }
1443             
1444             totalVolume = totalVolume.add(amount);
1445         }
1446 
1447         bool takeFee = true;
1448 
1449         // If any account belongs to _isExcludedFromFee account then remove the fee
1450         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
1451             takeFee = false;
1452         }
1453         
1454         // For safety Liquidity Adds should only be done by an owner, 
1455         // and transfers to and from EverRise Ecosystem contracts
1456         // are not considered LP adds
1457         if (isIgnoredAddress || buybackOwner() == _msgSender()) {
1458             // Clear transfer data
1459             _clearTransferIfNeeded();
1460         } else if (notInSwapAndLiquify) {
1461             // Not in a swap during a LP add, so record the transfer details
1462             _recordPotentialLiquidityAddTransaction(to);
1463         }
1464 
1465         _tokenTransfer(from, to, amount, takeFee);
1466     }
1467 
1468     function _recordPotentialLiquidityAddTransaction(address to)
1469         private
1470         tokenCheck {
1471         uint112 balance0 = uint112(_balanceOf(to));
1472         address token1 = to.token1();
1473         if (token1 == address(this)) {
1474             // Switch token so token1 is always other side of pair
1475             token1 = to.token0();
1476         }
1477 
1478         uint112 balance1;
1479         if (token1 == address(0)) {
1480             // Not a LP pair, or not yet (contract being created)
1481             balance1 = 0;
1482         } else {
1483             balance1 = uint112(IERC20(token1).balanceOf(to));
1484         }
1485 
1486         lastTransfer = TransferDetails({
1487             balance0: balance0,
1488             balance1: balance1,
1489             blockNumber: uint32(block.number),
1490             to: to,
1491             origin: tx.origin
1492         });
1493     }
1494 
1495     function _clearTransferIfNeeded() private {
1496         // Not Liquidity Add or is owner, clear data from same block to allow balanceOf
1497         if (lastTransfer.blockNumber == uint32(block.number)) {
1498             // Don't need to clear if different block
1499             lastTransfer = TransferDetails({
1500                 balance0: 0,
1501                 balance1: 0,
1502                 blockNumber: 0,
1503                 to: address(0),
1504                 origin: address(0)
1505             });
1506         }
1507     }
1508 
1509     function swapTokens(uint256 contractTokenBalance) private lockTheSwap {
1510         uint256 initialBalance = address(this).balance;
1511         swapTokensForEth(address(this), address(this), contractTokenBalance);
1512         uint256 transferredBalance = address(this).balance.sub(initialBalance);
1513 
1514         //Send to Business Development address
1515         transferToAddressETH(
1516             businessDevelopmentAddress,
1517             transferredBalance
1518                 .mul(businessDevelopmentDivisor)
1519                 .div(liquidityFee)
1520         );
1521     }
1522 
1523     function buyBackTokens(uint256 amount)
1524         private
1525         lockTheSwap
1526         returns (uint256)
1527     {
1528         uint256 tokensReceived;
1529         if (amount > 0) {
1530             tokensReceived = swapETHForTokensNoFee(
1531                 address(this),
1532                 stakingAddress,
1533                 amount
1534             );
1535         }
1536         return tokensReceived;
1537     }
1538 
1539     function swapTokensForEth(
1540         address tokenAddress,
1541         address toAddress,
1542         uint256 tokenAmount
1543     ) private {
1544         // generate the uniswap pair path of token -> weth
1545         address[] memory path = new address[](2);
1546         path[0] = tokenAddress;
1547         path[1] = uniswapV2Router.WETH();
1548 
1549         IERC20(tokenAddress).approve(address(uniswapV2Router), tokenAmount);
1550 
1551         // make the swap
1552         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1553             tokenAmount,
1554             0, // accept any amount of ETH
1555             path,
1556             toAddress, // The contract
1557             block.timestamp
1558         );
1559 
1560         emit SwapTokensForETH(tokenAmount, path);
1561     }
1562 
1563     function swapETHForTokensNoFee(
1564         address tokenAddress,
1565         address toAddress,
1566         uint256 amount
1567     ) private returns (uint256) {
1568         // generate the uniswap pair path of token -> weth
1569         address[] memory path = new address[](2);
1570         path[0] = uniswapV2Router.WETH();
1571         path[1] = tokenAddress;
1572 
1573         // make the swap
1574         uint256[] memory amounts = uniswapV2Router.swapExactETHForTokens{
1575             value: amount
1576         }(
1577             0, // accept any amount of Tokens
1578             path,
1579             toAddress, // The contract
1580             block.timestamp.add(300)
1581         );
1582 
1583         emit SwapETHForTokens(amount, path);
1584         return amounts[1];
1585     }
1586 
1587     function swapETHForTokens(
1588         address tokenAddress,
1589         address toAddress,
1590         uint256 amount
1591     ) private {
1592         // generate the uniswap pair path of token -> weth
1593         address[] memory path = new address[](2);
1594         path[0] = uniswapV2Router.WETH();
1595         path[1] = tokenAddress;
1596 
1597         // make the swap
1598         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{
1599             value: amount
1600         }(
1601             0, // accept any amount of Tokens
1602             path,
1603             toAddress, // The contract
1604             block.timestamp.add(300)
1605         );
1606 
1607         emit SwapETHForTokens(amount, path);
1608     }
1609 
1610     function swapTokensForTokens(
1611         address fromTokenAddress,
1612         address toTokenAddress,
1613         address toAddress,
1614         uint256 tokenAmount
1615     ) private {
1616         // generate the uniswap pair path of token -> weth
1617         address[] memory path = new address[](3);
1618         path[0] = fromTokenAddress;
1619         path[1] = uniswapV2Router.WETH();
1620         path[2] = toTokenAddress;
1621 
1622         IERC20(fromTokenAddress).approve(address(uniswapV2Router), tokenAmount);
1623 
1624         // make the swap
1625         uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
1626             tokenAmount,
1627             0, // accept any amount of Tokens
1628             path,
1629             toAddress, // The contract
1630             block.timestamp.add(120)
1631         );
1632 
1633         emit SwapTokensForTokens(tokenAmount, path);
1634     }
1635 
1636     function distributeStakingRewards(uint256 amount) private {
1637         if (amount > 0) {
1638             stakeToken.createRewards(address(this), amount);
1639             stakeToken.deliver(amount);
1640 
1641             emit BuyBackAndRewardStakers(amount);
1642         }
1643     }
1644 
1645     function _tokenTransfer(
1646         address sender,
1647         address recipient,
1648         uint256 amount,
1649         bool takeFee
1650     ) private {
1651         if (!takeFee) removeAllFee();
1652 
1653         _actualTokenTransfer(sender, recipient, amount);
1654 
1655         if (!takeFee) restoreAllFee();
1656     }
1657 
1658     function _actualTokenTransfer(
1659         address sender,
1660         address recipient,
1661         uint256 tAmount
1662     ) private {
1663         (
1664             uint256 tTransferAmount,
1665             uint256 tLiquidity
1666         ) = _getValues(tAmount);
1667 
1668         uint256 senderBefore = _tOwned[sender];
1669         uint256 senderAfter = senderBefore.sub(tAmount);
1670         _tOwned[sender] = senderAfter;
1671 
1672         uint256 recipientBefore = _tOwned[recipient];
1673         uint256 recipientAfter = recipientBefore.add(tTransferAmount);
1674         _tOwned[recipient] = recipientAfter;
1675 
1676         // Track holder change
1677         if (recipientBefore == 0 && recipientAfter > 0) {
1678             uint256 holdersBefore = _holders;
1679             uint256 holdersAfter = holdersBefore.add(1);
1680             _holders = holdersAfter;
1681 
1682             emit HoldersIncreased(holdersBefore, holdersAfter);
1683         }
1684 
1685         if (senderBefore > 0 && senderAfter == 0) {
1686             uint256 holdersBefore = _holders;
1687             uint256 holdersAfter = holdersBefore.sub(1);
1688             _holders = holdersAfter;
1689 
1690             emit HoldersDecreased(holdersBefore, holdersAfter);
1691         }
1692 
1693         _takeLiquidity(tLiquidity);
1694         emit Transfer(sender, recipient, tTransferAmount);
1695 
1696         if (recipient == stakingAddress) {
1697             // Increases by the amount entering staking (transfer - fees)
1698             // Howver, fees should be zero for staking so same as full amount.
1699             emit StakingIncreased(tTransferAmount);
1700         } else if (sender == stakingAddress) {
1701             // Decreases by the amount leaving staking (full amount)
1702             emit StakingDecreased(tAmount);
1703         }
1704     }
1705 
1706     function permit(
1707         address owner,
1708         address spender,
1709         uint256 value,
1710         uint256 deadline,
1711         uint8 v,
1712         bytes32 r,
1713         bytes32 s
1714     ) private {
1715         require(deadline >= block.timestamp, "EverRise: EXPIRED");
1716 
1717         bytes32 digest = keccak256(
1718             abi.encodePacked(
1719                 "\x19\x01",
1720                 DOMAIN_SEPARATOR,
1721                 keccak256(
1722                     abi.encode(
1723                         PERMIT_TYPEHASH,
1724                         owner,
1725                         spender,
1726                         value,
1727                         nonces[owner]++,
1728                         deadline
1729                     )
1730                 )
1731             )
1732         );
1733         if (v < 27) {
1734             v += 27;
1735         } else if (v > 30) {
1736             digest = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", digest));
1737         }
1738         address recoveredAddress = ecrecover(digest, v, r, s);
1739         require(
1740             recoveredAddress != address(0) && recoveredAddress == owner,
1741             "EverRise: INVALID_SIGNATURE"
1742         );
1743         _approve(owner, spender, value);
1744     }
1745 
1746     function _takeLiquidity(uint256 tLiquidity) private {
1747         uint256 beforeAmount = _tOwned[address(this)];
1748         uint256 afterAmount = beforeAmount.add(tLiquidity);
1749         _tOwned[address(this)] = afterAmount;
1750 
1751         // Track holder change
1752         if (beforeAmount == 0 && afterAmount > 0) {
1753             uint256 holdersBefore = _holders;
1754             uint256 holdersAfter = holdersBefore.add(1);
1755             _holders = holdersAfter;
1756 
1757             emit HoldersIncreased(holdersBefore, holdersAfter);
1758         }
1759     }
1760 
1761     function removeAllFee() private {
1762         if (liquidityFee == 0) return;
1763 
1764         _previousLiquidityFee = liquidityFee;
1765 
1766         liquidityFee = 0;
1767     }
1768 
1769     function restoreAllFee() private {
1770         liquidityFee = _previousLiquidityFee;
1771     }
1772 
1773     function transferToAddressETH(address payable recipient, uint256 amount)
1774         private
1775     {
1776         recipient.transfer(amount);
1777     }
1778 
1779     function _everRiseEcosystemContractAdd(address contractAddress) private {
1780         if (_isEverRiseEcosystemContract[contractAddress]) return;
1781 
1782         _isEverRiseEcosystemContract[contractAddress] = true;
1783         allEcosystemContracts.push(contractAddress);
1784 
1785         emit EverRiseEcosystemContractAdded(contractAddress);
1786         _excludeFromFee(contractAddress);
1787     }
1788 
1789     function _excludeFromFee(address account) private {
1790         _isExcludedFromFee[account] = true;
1791         emit ExcludeFromFeeUpdated(account);
1792     }
1793 
1794     function _includeInFee(address account) private {
1795         _isExcludedFromFee[account] = false;
1796         emit IncludeInFeeUpdated(account);
1797     }
1798 
1799     function validateDuringTradingCoolDown(address to, address from, uint256 amount) private {
1800         address pair = uniswapV2Pair;
1801         bool disallow;
1802 
1803         // Disallow multiple same source trades in same block
1804         if (from == pair) {
1805             disallow = lastCoolDownTrade[to] == block.number || lastCoolDownTrade[tx.origin] == block.number;
1806             lastCoolDownTrade[to] = block.number;
1807             lastCoolDownTrade[tx.origin] = block.number;
1808         } else if (to == pair) {
1809             disallow = lastCoolDownTrade[from] == block.number || lastCoolDownTrade[tx.origin] == block.number;
1810             lastCoolDownTrade[from] = block.number;
1811             lastCoolDownTrade[tx.origin] = block.number;
1812         }
1813 
1814         require(!disallow, "Multiple trades in same block from same source are not allowed during trading start cooldown");
1815 
1816         require(amount <= maxTxCooldownAmount(), "Max transaction is 0.05% of total supply during trading start cooldown");
1817     }
1818 
1819     function inSwapAndLiquify() private view returns (bool) {
1820         return _inSwapAndLiquify == _TRUE;
1821     }
1822 
1823     function inTokenCheck() private view returns (bool) {
1824         return _checkingTokens == _TRUE;
1825     }
1826 
1827     function _getValues(uint256 tAmount)
1828         private
1829         view
1830         returns (
1831             uint256,
1832             uint256
1833         )
1834     {
1835         uint256 tLiquidity = calculateLiquidityFee(tAmount);
1836         uint256 tTransferAmount = tAmount.sub(tLiquidity);
1837         return (tTransferAmount, tLiquidity);
1838     }
1839 
1840     function calculateLiquidityFee(uint256 _amount)
1841         private
1842         view
1843         returns (uint256)
1844     {
1845         return _amount.mul(liquidityFee).div(10**2);
1846     }
1847 
1848     function _balanceOf(address account) private view returns (uint256) {
1849         return _tOwned[account];
1850     }
1851 
1852     // account must be recorded in _transfer and same block
1853     function _validateIfLiquidityAdd(address account, uint112 balance0)
1854         private
1855         view
1856     {
1857         // Test to see if this tx is part of a Liquidity Add
1858         // using the data recorded in _transfer
1859         TransferDetails memory _lastTransfer = lastTransfer;
1860         if (_lastTransfer.origin == tx.origin) {
1861             // May be same transaction as _transfer, check LP balances
1862             address token1 = account.token1();
1863 
1864             if (token1 == address(this)) {
1865                 // Switch token so token1 is always other side of pair
1866                 token1 = account.token0();
1867             }
1868 
1869             // Not LP pair
1870             if (token1 == address(0)) return;
1871 
1872             uint112 balance1 = uint112(IERC20(token1).balanceOf(account));
1873 
1874             if (balance0 > _lastTransfer.balance0 &&
1875                 balance1 > _lastTransfer.balance1) {
1876                 // Both pair balances have increased, this is a Liquidty Add
1877                 require(false, "Liquidity can be added by the owner only");
1878             } else if (balance0 < _lastTransfer.balance0 &&
1879                 balance1 < _lastTransfer.balance1)
1880             {
1881                 // Both pair balances have decreased, this is a Liquidty Remove
1882                 require(!liquidityLocked, "Liquidity cannot be removed while locked");
1883             }
1884         }
1885     }
1886 }