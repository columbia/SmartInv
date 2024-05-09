1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.6.0 <0.8.0;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address payable) {
7         return msg.sender;
8     }
9 
10     function _msgData() internal view virtual returns (bytes memory) {
11         this;
12         return msg.data;
13     }
14 }
15 
16 interface IERC20 {
17     function totalSupply() external view returns (uint256);
18     function balanceOf(address account) external view returns (uint256);
19     function transfer(address recipient, uint256 amount) external returns (bool);
20     function allowance(address owner, address spender) external view returns (uint256);
21     function approve(address spender, uint256 amount) external returns (bool);
22     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
23     event Transfer(address indexed from, address indexed to, uint256 value);
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 interface TokenInterface is IERC20 {
28     function burnFromVault(uint256 amount) external returns (bool);
29 }
30 
31 abstract contract Ownable is Context {
32     address private _owner;
33 
34     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
35 
36     constructor () {
37         address msgSender = _msgSender();
38         _owner = msgSender;
39         emit OwnershipTransferred(address(0), msgSender);
40     }
41 
42     function owner() public view returns (address) {
43         return _owner;
44     }
45 
46     modifier onlyOwner() {
47         require(_owner == _msgSender(), "Ownable: caller is not the owner");
48         _;
49     }
50 
51     function renounceOwnership() public virtual onlyOwner {
52         emit OwnershipTransferred(_owner, address(0));
53         _owner = address(0);
54     }
55 
56     function transferOwnership(address newOwner) public virtual onlyOwner {
57         require(newOwner != address(0), "Ownable: new owner is the zero address");
58         emit OwnershipTransferred(_owner, newOwner);
59         _owner = newOwner;
60     }
61 }
62 
63 library SafeMath {
64     function add(uint256 a, uint256 b) internal pure returns (uint256) {
65         uint256 c = a + b;
66         require(c >= a, "SafeMath: addition overflow");
67 
68         return c;
69     }
70 
71     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
72         return sub(a, b, "SafeMath: subtraction overflow");
73     }
74 
75     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
76         require(b <= a, errorMessage);
77         uint256 c = a - b;
78 
79         return c;
80     }
81 
82     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
83         if (a == 0) {
84             return 0;
85         }
86 
87         uint256 c = a * b;
88         require(c / a == b, "SafeMath: multiplication overflow");
89 
90         return c;
91     }
92 
93     function div(uint256 a, uint256 b) internal pure returns (uint256) {
94         return div(a, b, "SafeMath: division by zero");
95     }
96 
97     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
98         require(b > 0, errorMessage);
99         uint256 c = a / b;
100 
101         return c;
102     }
103 
104     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
105         return mod(a, b, "SafeMath: modulo by zero");
106     }
107 
108     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
109         require(b != 0, errorMessage);
110         return a % b;
111     }
112 }
113 
114 interface IUniswapV2Pair {
115     event Approval(address indexed owner, address indexed spender, uint256 value);
116     event Transfer(address indexed from, address indexed to, uint256 value);
117 
118     function name() external pure returns (string memory);
119     function symbol() external pure returns (string memory);
120     function decimals() external pure returns (uint8);
121     function totalSupply() external view returns (uint256);
122     function balanceOf(address owner) external view returns (uint256);
123     function allowance(address owner, address spender) external view returns (uint256);
124     function approve(address spender, uint256 value) external returns (bool);
125     function transfer(address to, uint256 value) external returns (bool);
126     function transferFrom(
127         address from,
128         address to,
129         uint256 value
130     ) external returns (bool);
131     function DOMAIN_SEPARATOR() external view returns (bytes32);
132     function PERMIT_TYPEHASH() external pure returns (bytes32);
133     function nonces(address owner) external view returns (uint256);
134     function permit(
135         address owner,
136         address spender,
137         uint256 value,
138         uint256 deadline,
139         uint8 v,
140         bytes32 r,
141         bytes32 s
142     ) external;
143 
144     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
145     event Burn(address indexed sender, uint256 amount0, uint256 amount1, address indexed to);
146     event Swap(
147         address indexed sender,
148         uint256 amount0In,
149         uint256 amount1In,
150         uint256 amount0Out,
151         uint256 amount1Out,
152         address indexed to
153     );
154     event Sync(uint112 reserve0, uint112 reserve1);
155 
156     function MINIMUM_LIQUIDITY() external pure returns (uint256);
157     function factory() external view returns (address);
158     function token0() external view returns (address);
159     function token1() external view returns (address);
160     function getReserves()
161         external
162         view
163         returns (
164             uint112 reserve0,
165             uint112 reserve1,
166             uint32 blockTimestampLast
167         );
168 
169     function price0CumulativeLast() external view returns (uint256);
170     function price1CumulativeLast() external view returns (uint256);
171     function kLast() external view returns (uint256);
172     function mint(address to) external returns (uint256 liquidity);
173     function burn(address to) external returns (uint256 amount0, uint256 amount1);
174     function swap(
175         uint256 amount0Out,
176         uint256 amount1Out,
177         address to,
178         bytes calldata data
179     ) external;
180     function skim(address to) external;
181     function sync() external;
182     function initialize(address, address) external;
183 }
184 
185 interface IUniswapV2Router01 {
186     function factory() external pure returns (address);
187 
188     function WETH() external pure returns (address);
189 
190     function addLiquidity(
191         address tokenA,
192         address tokenB,
193         uint256 amountADesired,
194         uint256 amountBDesired,
195         uint256 amountAMin,
196         uint256 amountBMin,
197         address to,
198         uint256 deadline
199     )
200         external
201         returns (
202             uint256 amountA,
203             uint256 amountB,
204             uint256 liquidity
205         );
206 
207     function addLiquidityETH(
208         address token,
209         uint256 amountTokenDesired,
210         uint256 amountTokenMin,
211         uint256 amountETHMin,
212         address to,
213         uint256 deadline
214     )
215         external
216         payable
217         returns (
218             uint256 amountToken,
219             uint256 amountETH,
220             uint256 liquidity
221         );
222 
223     function getAmountOut(
224         uint256 amountIn,
225         uint256 reserveIn,
226         uint256 reserveOut
227     ) external pure returns (uint256 amountOut);
228 
229     function getAmountIn(
230         uint256 amountOut,
231         uint256 reserveIn,
232         uint256 reserveOut
233     ) external pure returns (uint256 amountIn);
234 
235     function getAmountsOut(uint256 amountIn, address[] calldata path)
236         external
237         view
238         returns (uint256[] memory amounts);
239 
240     function getAmountsIn(uint256 amountOut, address[] calldata path)
241         external
242         view
243         returns (uint256[] memory amounts);
244 }
245 
246 interface IUniswapV2Router02 is IUniswapV2Router01 {
247     function removeLiquidityETHSupportingFeeOnTransferTokens(
248         address token,
249         uint256 liquidity,
250         uint256 amountTokenMin,
251         uint256 amountETHMin,
252         address to,
253         uint256 deadline
254     ) external returns (uint256 amountETH);
255 
256     function swapExactTokensForETHSupportingFeeOnTransferTokens(
257         uint256 amountIn,
258         uint256 amountOutMin,
259         address[] calldata path,
260         address to,
261         uint256 deadline
262     ) external;
263 
264     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
265         uint256 amountIn,
266         uint256 amountOutMin,
267         address[] calldata path,
268         address to,
269         uint256 deadline
270     ) external;
271 
272     function swapExactETHForTokensSupportingFeeOnTransferTokens(
273         uint256 amountOutMin,
274         address[] calldata path,
275         address to,
276         uint256 deadline
277     ) external payable;
278 }
279 
280 contract YZYVault is Context, Ownable {
281     using SafeMath for uint256;
282 
283     TokenInterface public _yzy;
284     TokenInterface public _yfi;
285     TokenInterface public _wbtc;
286     TokenInterface public _weth;
287 
288     IUniswapV2Pair public _yzyETHV2Pair;
289     IUniswapV2Pair public _usdcETHV2Pair;
290 
291     IUniswapV2Router02 private _uniswapV2Router;
292 
293     address public _daoTreasury;
294 
295     uint16 public _allocPointForYZYReward;
296     uint16 public _allocPointForSwapReward;
297 
298     uint16 public _treasuryFee;
299     uint16 public _rewardFee;
300     uint16 public _lotteryFee;
301     uint16 public _swapRewardFee;
302     uint16 public _burnFee;
303     uint16 public _earlyUnstakeFee;
304 
305     uint16 public _allocPointForYFI;
306     uint16 public _allocPointForWBTC;
307     uint16 public _allocPointForWETH;
308 
309     uint256 public _firstRewardPeriod;
310     uint256 public _secondRewardPeriod;
311 
312     uint256 public _firstRewardAmount;
313     uint256 public _secondRewardAmount;
314 
315     uint256 public _claimPeriodForYzyReward;
316     uint256 public _claimPeriodForSwapReward;
317 
318     uint256 public _lockPeriod;
319 
320     uint256 public _minDepositETHAmount;
321 
322     bool public _enabledLock;
323     bool public _enabledLottery;
324 
325     uint256 public _startBlock;
326 
327     uint256 private _lotteryAmount;
328     uint256 public _lotteryLimit;
329 
330     uint256 public _collectedAmountForStakers;
331     uint256 public _collectedAmountForSwap;
332     uint256 public _collectedAmountForLottery;
333 
334     uint256 public _lotteryPaidOut;
335 
336     struct StakerInfo {
337         uint256 stakedAmount;
338         uint256 lastClimedBlockForYzyReward;
339         uint256 lastClimedBlockForSwapReward;
340         uint256 lockedTo;
341     }
342 
343     mapping(address => StakerInfo) public _stakers;
344 
345     // Info of winners for lottery.
346     struct WinnerInfo {
347         address winner;
348         uint256 amount;
349         uint256 timestamp;
350     }
351     WinnerInfo[] private winnerInfo;
352     
353     event ChangedEnabledLock(address indexed owner, bool lock);
354     event ChangedEnabledLottery(address indexed owner, bool lottery);
355     event ChangedLockPeriod(address indexed owner, uint256 period);
356     event ChangedMinimumETHDepositAmount(address indexed owner, uint256 value);
357     event ChangedRewardPeriod(address indexed owner, uint256 firstRewardPeriod, uint256 secondRewardPeriod);
358     event ChangedClaimPeriod(address indexed owner, uint256 claimPeriodForYzyReward, uint256 claimPeriodForSwapReward);
359     event ChangedYzyAddress(address indexed owner, address indexed yzy);
360     event ChangedYzyETHPair(address indexed owner, address indexed yzyETHPair);
361     event ChangedFeeInfo(address indexed owner, uint16 treasuryFee, uint16 rewardFee, uint16 lotteryFee, uint16 swapRewardFee, uint16 burnFee);
362     event ChangedAllocPointsForSwapReward(address indexed owner, uint16 valueForYFI, uint16 valueForWBTC, uint16 valueForWETH);
363     event ChangedBurnFee(address indexed owner, uint16 value);
364     event ChangedEarlyUnstakeFee(address indexed owner, uint16 value);
365     event ChangedLotteryInfo(address indexed owner, uint16 lotteryFee, uint256 lotteryLimit);
366 
367     event ClaimedYzyAvailableReward(address indexed owner, uint256 amount);
368     event ClaimedSwapAvailableReward(address indexed owner, uint256 amount);
369     event ClaimedYzyReward(address indexed owner, uint256 available, uint256 pending);
370     event ClaimedSwapReward(address indexed owner, uint256 amount);
371 
372     event Staked(address indexed account, uint256 amount);
373     event Unstaked(address indexed account, uint256 amount);
374 
375     event SentLotteryAmount(address indexed owner, uint256 amount, bool status);
376     event EmergencyWithdrawToken(address indexed from, address indexed to, uint256 amount);
377     event SwapAndLiquifyForYZY(address indexed msgSender, uint256 totAmount, uint256 ethAmount, uint256 yzyAmount);
378 
379     // Modifier
380 
381     modifier onlyYzy() {
382         require(
383             address(_yzy) == _msgSender(),
384             "Ownable: caller is not the YZY token contract"
385         );
386         _;
387     }
388 
389     constructor(
390         address daoTreasury,
391         address yfi,
392         address wbtc,
393         address weth,
394         address usdcETHV2Pair
395     ) {
396         _daoTreasury = daoTreasury;
397 
398         _yfi = TokenInterface(yfi);
399         _wbtc = TokenInterface(wbtc);
400         _weth = TokenInterface(weth);
401 
402         _usdcETHV2Pair = IUniswapV2Pair(usdcETHV2Pair);
403         _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
404 
405         _firstRewardPeriod = 71500; // around 11 days, could be changed by governance
406         _secondRewardPeriod = 429000; // around 66 days, could be changed by governance
407 
408         _firstRewardAmount = 2000e18; // 2000 yzy tokens, could be changed by governance
409         _secondRewardAmount = 7900e18; // 7900 yzy tokens, could be changed by governance
410 
411         _claimPeriodForYzyReward = 91000; // around 14 days, could be changed by governance
412         _claimPeriodForSwapReward = 585000; // around 90 days, could be changed by governance
413 
414         _allocPointForYZYReward = 8000; // 80% of reward will go to YZY reward, could be changed by governance
415         _allocPointForSwapReward = 2000; // 20% of reward will go to swap(weth, wbtc, yfi) reward, could be changed by governance
416 
417         // Set values divited from taxFee
418         _treasuryFee = 2500; // 25% of taxFee to treasuryFee, could be changed by governance
419         _rewardFee = 5000; // 50% of taxFee to stakers, could be changed by governance
420         _lotteryFee = 500; // 5% of lottery Fee, could be changed by governance
421         _swapRewardFee = 2000; // 20% of taxFee to swap tokens, could be changed by governance
422 
423         _earlyUnstakeFee = 1000; // 10% of early unstake fee, could be changed by governance
424         
425         // set alloc points of YFI, WBTC, WETH in swap rewards, could be changed by governance
426         _allocPointForYFI = 3000; // 30% of fee to buy YFI token, could be changed by governance
427         _allocPointForWBTC = 5000; // 50% of fee to buy WBTC token, could be changed by governance
428         _allocPointForWETH = 2000; // 20% of fee to buy WETH token, could be changed by governance
429 
430         // set the burn fee for withdraw early
431         _burnFee = 2000; // 20% of pending reward to burn when staker request to withdraw pending reward, could be changed by governance
432         
433         _minDepositETHAmount = 1e17; // 0.1 ether, could be changed by governance
434         _lockPeriod = 90 days; // could be changed by governance
435 
436         _enabledLock = true; // could be changed by governance
437         _enabledLottery = true; // could be changed by governance
438 
439         _lotteryLimit = 1200e6; // $1200(1200 usd, decimals 6), could be changed by governance
440         _startBlock = block.number;
441     }
442 
443     /**
444      * @dev Change Minimum Deposit ETH Amount. Call by only Governance.
445      */
446     function changeMinimumDepositETHAmount(uint256 amount) external onlyOwner {
447         _minDepositETHAmount = amount;
448 
449         emit ChangedMinimumETHDepositAmount(_msgSender(), amount);
450     }
451 
452     /**
453      * @dev Change value of reward period. Call by only Governance.
454      */
455     function changeRewardPeriod(uint256 firstRewardPeriod, uint256 secondRewardPeriod) external onlyOwner {
456         _firstRewardPeriod = firstRewardPeriod;
457         _secondRewardPeriod = secondRewardPeriod;
458 
459         emit ChangedRewardPeriod(_msgSender(), firstRewardPeriod, secondRewardPeriod);
460     }
461 
462     /**
463      * @dev Change value of claim period. Call by only Governance.
464      */
465     function changeClaimPeriod(uint256 claimPeriodForYzyReward, uint256 claimPeriodForSwapReward) external onlyOwner {
466         _claimPeriodForYzyReward = claimPeriodForYzyReward;
467         _claimPeriodForSwapReward = claimPeriodForSwapReward;
468 
469         emit ChangedClaimPeriod(_msgSender(), claimPeriodForYzyReward, claimPeriodForSwapReward);
470     }
471 
472     /**
473      * @dev Enable lock functionality. Call by only Governance.
474      */
475     function enableLock(bool isLock) external onlyOwner {
476         _enabledLock = isLock;
477 
478         emit ChangedEnabledLock(_msgSender(), isLock);
479     }
480 
481     /**
482      * @dev Enable lottery functionality. Call by only Governance.
483      */
484     function enableLottery(bool lottery) external onlyOwner {
485         _enabledLottery = lottery;
486 
487         emit ChangedEnabledLottery(_msgSender(), lottery);
488     }
489 
490     /**
491      * @dev Change maximun lock period. Call by only Governance.
492      */
493     function changeLockPeriod(uint256 period) external onlyOwner {
494         _lockPeriod = period;
495         
496         emit ChangedLockPeriod(_msgSender(), _lockPeriod);
497     }
498 
499     function changeYzyAddress(address yzy) external onlyOwner {
500         _yzy = TokenInterface(yzy);
501 
502         emit ChangedYzyAddress(_msgSender(), yzy);
503     }
504 
505     function changeYzyETHPair(address yzyETHPair) external onlyOwner {
506         _yzyETHV2Pair = IUniswapV2Pair(yzyETHPair);
507 
508         emit ChangedYzyETHPair(_msgSender(), yzyETHPair);
509     }
510 
511     /**
512      * @dev Update the treasury fee for this contract
513      * defaults at 25% of taxFee, It can be set on only by YZY governance.
514      * Note contract owner is meant to be a governance contract allowing YZY governance consensus
515      */
516     function changeFeeInfo(
517         uint16 treasuryFee,
518         uint16 rewardFee,
519         uint16 lotteryFee,
520         uint16 swapRewardFee,
521         uint16 burnFee
522     ) external onlyOwner {
523         _treasuryFee = treasuryFee;
524         _rewardFee = rewardFee;
525         _lotteryFee = lotteryFee;
526         _swapRewardFee = swapRewardFee;
527         _burnFee = burnFee;
528 
529         emit ChangedFeeInfo(_msgSender(), treasuryFee, rewardFee, lotteryFee, swapRewardFee, burnFee);
530     }
531 
532     function changeEarlyUnstakeFee(uint16 fee) external onlyOwner {
533         _earlyUnstakeFee = fee;
534 
535         emit ChangedEarlyUnstakeFee(_msgSender(), fee);
536     }
537 
538     /**
539      * @dev Update the dev fee for this contract
540      * defaults at 5% of taxFee, It can be set on only by YZY governance.
541      * Note contract owner is meant to be a governance contract allowing YZY governance consensus
542      */
543     function changeLotteryInfo(uint16 lotteryFee, uint256 lotteryLimit) external onlyOwner {
544         _lotteryFee = lotteryFee;
545         _lotteryLimit = lotteryLimit;
546 
547         emit ChangedLotteryInfo(_msgSender(), lotteryFee, lotteryLimit);
548     }
549 
550     /**
551      * @dev Update the alloc points for yfi, weth, wbtc rewards
552      * defaults at 50, 30, 20 of 
553      * Note contract owner is meant to be a governance contract allowing YZY governance consensus
554      */
555     function changeAllocPointsForSwapReward(
556         uint16 allocPointForYFI_,
557         uint16 allocPointForWBTC_,
558         uint16 allocPointForWETH_
559     ) external onlyOwner {
560         _allocPointForYFI = allocPointForYFI_;
561         _allocPointForWBTC = allocPointForWBTC_;
562         _allocPointForWETH = allocPointForWETH_;
563 
564         emit ChangedAllocPointsForSwapReward(_msgSender(), allocPointForYFI_, allocPointForWBTC_, allocPointForWETH_);
565     }
566 
567     function addTaxFee(uint256 amount) external onlyYzy returns (bool) {
568         uint256 daoTreasuryReward = amount.mul(uint256(_treasuryFee)).div(10000);
569         _yzy.transfer(_daoTreasury, daoTreasuryReward);
570 
571         uint256 stakerReward = amount.mul(uint256(_rewardFee)).div(10000);
572         _collectedAmountForStakers = _collectedAmountForStakers.add(stakerReward);
573 
574         uint256 lotteryReward =  amount.mul(uint256(_lotteryFee)).div(10000);
575         _collectedAmountForLottery = _collectedAmountForLottery.add(lotteryReward);
576 
577         _collectedAmountForSwap = _collectedAmountForSwap.add(amount.sub(daoTreasuryReward).sub(stakerReward).sub(lotteryReward));
578 
579         return true;
580     }
581 
582     function getTotalStakedAmount() public view returns (uint256) {
583         return _yzyETHV2Pair.balanceOf(address(this));
584     }
585     
586     function getWinners() external view returns (uint256) {
587         return winnerInfo.length;
588     }
589 
590     // Get YZY reward per block
591     function getYzyPerBlockForYzyReward() public view returns (uint256) {
592         uint256 multiplier = getMultiplier(_startBlock, block.number);
593         
594         if (multiplier == 0 || getTotalStakedAmount() == 0) {
595             return 0;
596         } else if (multiplier <= _firstRewardPeriod) {
597             return _firstRewardAmount
598                     .mul(uint256(_allocPointForYZYReward))
599                     .mul(1 ether)
600                     .div(getTotalStakedAmount())
601                     .div(_firstRewardPeriod)
602                     .div(10000);
603         } else if (multiplier > _firstRewardPeriod && multiplier <= _secondRewardPeriod) {
604             return _secondRewardAmount
605                     .mul(uint256(_allocPointForYZYReward))
606                     .mul(1 ether)
607                     .div(getTotalStakedAmount())
608                     .div(_secondRewardPeriod)
609                     .div(10000);
610         } else {
611             return _collectedAmountForStakers.mul(1 ether).div(getTotalStakedAmount()).div(multiplier);
612         }
613     }
614 
615     function getYzyPerBlockForSwapReward() public view returns (uint256) {
616         uint256 multiplier = getMultiplier(_startBlock, block.number);
617 
618         if (multiplier == 0 || getTotalStakedAmount() == 0) {
619             return 0;
620         } else if (multiplier <= _firstRewardPeriod) {
621             return _firstRewardAmount
622                     .mul(uint256(_allocPointForSwapReward))
623                     .mul(1 ether)
624                     .div(getTotalStakedAmount())
625                     .div(_firstRewardPeriod)
626                     .div(10000);
627         } else if (multiplier > _firstRewardPeriod && multiplier <= _secondRewardPeriod) {
628             return _secondRewardAmount
629                     .mul(uint256(_allocPointForSwapReward))
630                     .mul(1 ether)
631                     .div(getTotalStakedAmount())
632                     .div(_secondRewardPeriod)
633                     .div(10000);
634         } else {
635             return _collectedAmountForSwap.mul(1 ether).div(getTotalStakedAmount()).div(multiplier);
636         }
637     }
638 
639     // Return reward multiplier over the given _from to _to block.
640     function getMultiplier(uint256 from, uint256 to) public pure returns (uint256) {
641         return to.sub(from);
642     }
643 
644     function _getLastAvailableClaimedBlock(
645         uint256 from,
646         uint256 to,
647         uint256 period
648     ) internal pure returns (uint256) {
649         require(from <= to, "Vault: Invalid parameters for block number.");
650         require(period > 0, "Vault: Invalid period.");
651 
652         uint256 multiplier = getMultiplier(from, to);
653 
654         return from.add(multiplier.sub(multiplier.mod(period)));
655     }
656    
657     function swapETHForTokens(uint256 ethAmount) private {
658         // generate the uniswap pair path of weth -> yzy
659         address[] memory path = new address[](2);
660         path[0] = _uniswapV2Router.WETH();
661         path[1] = address(_yzy);
662 
663         // make the swap
664         _uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{
665             value: ethAmount
666         }(0, path, address(this), block.timestamp);
667     }
668 
669     function addLiquidityForEth(uint256 tokenAmount, uint256 ethAmount)
670         private
671     {
672         _yzy.approve(address(_uniswapV2Router), tokenAmount);
673 
674         // add the liquidity
675         _uniswapV2Router.addLiquidityETH{value: ethAmount}(
676             address(_yzy),
677             tokenAmount,
678             0, // slippage is unavoidable
679             0, // slippage is unavoidable
680             address(this),
681             block.timestamp
682         );
683     }
684 
685     function swapAndLiquifyForYZY(uint256 amount) private returns (bool) {
686         uint256 halfForEth = amount.div(2);
687         uint256 otherHalfForYZY = amount.sub(halfForEth);
688 
689         // capture the contract's current ETH balance.
690         // this is so that we can capture exactly the amount of ETH that the
691         // swap creates, and not make the liquidity event include any ETH that
692         // has been manually sent to the contract
693         uint256 initialBalance = _yzy.balanceOf(address(this));
694 
695         // swap ETH for tokens
696         swapETHForTokens(otherHalfForYZY);
697 
698         // how much YZY did we just swap into?
699         uint256 newBalance = _yzy.balanceOf(address(this)).sub(initialBalance);
700 
701         // add liquidity to uniswap
702         addLiquidityForEth(newBalance, halfForEth);
703 
704         emit SwapAndLiquifyForYZY(_msgSender(), amount, halfForEth, newBalance);
705 
706         return true;
707     }
708 
709     function swapTokensForTokens(
710         address fromTokenAddress,
711         address toTokenAddress,
712         uint256 tokenAmount,
713         address receivedAddress
714     ) private returns (bool) {
715         address[] memory path = new address[](2);
716         path[0] = fromTokenAddress;
717         path[1] = toTokenAddress;
718 
719         IERC20(fromTokenAddress).approve(
720             address(_uniswapV2Router),
721             tokenAmount
722         );
723 
724         // make the swap
725         _uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
726             tokenAmount,
727             0, // accept any amount of pair token
728             path,
729             receivedAddress,
730             block.timestamp
731         );
732 
733         return true;
734     }
735 
736     receive() external payable {}
737 
738     function stake() external payable returns (bool) {
739         require(!isContract(_msgSender()), "Vault: Could not be contract.");
740         require(msg.value >= _minDepositETHAmount, "Vault: insufficient staking amount.");
741 
742         // Check Initial Balance
743         uint256 initialBalance = _yzyETHV2Pair.balanceOf(address(this));
744 
745         // Call swap for YZY&ETH
746         require(swapAndLiquifyForYZY(msg.value), "Vault: Failed to get LP tokens.");
747 
748         uint256 newBalance = _yzyETHV2Pair.balanceOf(address(this)).sub(initialBalance);
749 
750         StakerInfo storage staker = _stakers[_msgSender()];
751 
752         if (staker.stakedAmount > 0) {
753             claimYzyReward();
754             claimSwapReward();
755         } else {
756             staker.lastClimedBlockForYzyReward = block.number;
757             staker.lastClimedBlockForSwapReward = block.number;
758         }
759 
760         staker.stakedAmount = staker.stakedAmount.add(newBalance);
761         staker.lockedTo = _lockPeriod.add(block.timestamp);
762 
763         emit Staked(_msgSender(), newBalance);
764 
765         return _sendLotteryAmount();
766     }
767 
768     /**
769      * @dev Stake LP Token to get YZY-ETH LP tokens
770      */
771     function stakeLPToken(uint256 amount) external returns (bool) {
772         require(!isContract(_msgSender()), "Vault: Could not be contract.");
773 
774         _yzyETHV2Pair.transferFrom(_msgSender(), address(this), amount);
775 
776         StakerInfo storage staker = _stakers[_msgSender()];
777 
778         if (staker.stakedAmount > 0) {
779             claimYzyReward();
780             claimSwapReward();
781         } else {
782             staker.lastClimedBlockForYzyReward = block.number;
783             staker.lastClimedBlockForSwapReward = block.number;
784         }
785 
786         staker.stakedAmount = staker.stakedAmount.add(amount);
787         staker.lockedTo = _lockPeriod.add(block.timestamp);
788 
789         emit Staked(_msgSender(), amount);
790 
791         return _sendLotteryAmount();
792     }
793 
794     /**
795      * @dev Unstake staked YZY-ETH LP tokens
796      */
797     function unstake(uint256 amount) external returns (bool) {
798         require(!isContract(_msgSender()), "Vault: Could not be contract.");
799 
800         StakerInfo storage staker = _stakers[_msgSender()];
801 
802         require(
803             staker.stakedAmount > 0 &&
804             amount > 0 &&
805             amount <= staker.stakedAmount,
806             "Vault: Invalid amount to unstake."
807         );
808 
809         claimYzyReward();
810 
811         claimSwapReward();
812 
813         if (_enabledLock &&
814             _stakers[_msgSender()].lockedTo > 0 &&
815             block.timestamp < _stakers[_msgSender()].lockedTo
816         ) {
817             uint256 feeAmount = amount.mul(uint256(_earlyUnstakeFee)).div(10000);
818             _yzyETHV2Pair.transfer(_daoTreasury, feeAmount); 
819             _yzyETHV2Pair.transfer(_msgSender(), amount.sub(feeAmount));
820         } else {
821            _yzyETHV2Pair.transfer(_msgSender(), amount);
822         }
823 
824         staker.stakedAmount = staker.stakedAmount.sub(amount);
825 
826         emit Unstaked(_msgSender(), amount);
827         
828         return _sendLotteryAmount();
829     }
830 
831     function getYzyReward(address account) public view returns (uint256 available, uint256 pending) {
832         StakerInfo memory staker = _stakers[account];
833         uint256 multiplier = getMultiplier(staker.lastClimedBlockForYzyReward, block.number);
834 
835         if (staker.stakedAmount <= 0 || multiplier <= 0)  {
836             return (0, 0);
837         }
838 
839         uint256 yzyPerblock = getYzyPerBlockForYzyReward();
840         uint256 pendingBlockNum = multiplier.mod(_claimPeriodForYzyReward);
841 
842         pending = yzyPerblock.mul(pendingBlockNum).mul(staker.stakedAmount).div(1 ether);
843         available = yzyPerblock.mul(multiplier.sub(pendingBlockNum)).mul(staker.stakedAmount).div(1 ether);
844     }
845 
846     function getSwapReward(address account) public view returns (uint256 available, uint256 pending) {
847         StakerInfo memory staker = _stakers[account];
848         uint256 multiplier = getMultiplier(staker.lastClimedBlockForSwapReward, block.number);
849 
850         if (staker.stakedAmount <= 0 || multiplier <= 0)  {
851             return (0, 0);
852         }
853 
854         uint256 yzyPerblock = getYzyPerBlockForSwapReward();
855         uint256 pendingBlockNum = multiplier.mod(_claimPeriodForSwapReward);
856 
857         pending = yzyPerblock.mul(pendingBlockNum).mul(staker.stakedAmount).div(1 ether);
858         available = yzyPerblock.mul(multiplier.sub(pendingBlockNum)).mul(staker.stakedAmount).div(1 ether);
859     }
860 
861     function claimYzyAvailableReward() public returns (bool) {
862 
863         (uint256 available, ) = getYzyReward(_msgSender());
864 
865         require(available > 0, "Vault: No available reward.");
866 
867         require(
868             safeYzyTransfer(_msgSender(), available),
869             "Vault: Failed to transfer."
870         );
871 
872         emit ClaimedYzyAvailableReward(_msgSender(), available);
873 
874         StakerInfo storage staker = _stakers[_msgSender()];
875         staker.lastClimedBlockForYzyReward = _getLastAvailableClaimedBlock(
876             staker.lastClimedBlockForYzyReward,
877             block.number,
878             _claimPeriodForYzyReward
879         );
880 
881         return _sendLotteryAmount();
882     }
883 
884     function claimYzyReward() public returns (bool) {
885         (uint256 available, uint256 pending) = getYzyReward(_msgSender());
886 
887         require(available > 0 || pending > 0, "Vault: No rewards");
888 
889         StakerInfo storage staker = _stakers[_msgSender()];
890 
891         if (available > 0) {
892             require(
893                 safeYzyTransfer(_msgSender(), available),
894                 "Vault: Failed to transfer."
895             );
896         }
897 
898         if (pending > 0) {
899             uint256 burnAmount = pending.mul(_burnFee).div(10000);
900             _yzy.burnFromVault(burnAmount);
901             safeYzyTransfer(_msgSender(), pending.sub(burnAmount));
902             staker.lastClimedBlockForYzyReward = block.number;
903         } else if (available > 0) {
904             staker.lastClimedBlockForYzyReward = _getLastAvailableClaimedBlock(
905                 staker.lastClimedBlockForYzyReward,
906                 block.number,
907                 _claimPeriodForYzyReward
908             );
909         }
910 
911         emit ClaimedYzyReward(_msgSender(), available, pending);
912 
913         return _sendLotteryAmount();
914     }
915 
916     function claimSwapAvailableReward() public returns (bool) {
917 
918         (uint256 available, ) = getSwapReward(_msgSender());
919 
920         _swapAndClaimTokens(available);
921 
922         emit ClaimedSwapAvailableReward(_msgSender(), available);
923 
924         StakerInfo storage staker = _stakers[_msgSender()];
925         staker.lastClimedBlockForSwapReward = _getLastAvailableClaimedBlock(
926             staker.lastClimedBlockForSwapReward,
927             block.number,
928             _claimPeriodForSwapReward
929         );
930 
931         return _sendLotteryAmount();
932     }
933 
934     function claimSwapReward() public returns (bool) {
935 
936         (uint256 available, uint256 pending) = getSwapReward(_msgSender());
937 
938         if (pending > 0) {
939             uint256 burnAmount = pending.mul(_burnFee).div(10000);
940             _yzy.burnFromVault(burnAmount);
941             pending = pending.sub(burnAmount);
942         }
943 
944         _swapAndClaimTokens(available.add(pending));
945 
946         emit ClaimedSwapReward(_msgSender(), available.add(pending));
947 
948         StakerInfo storage staker = _stakers[_msgSender()];
949 
950         if (pending > 0) {
951             staker.lastClimedBlockForSwapReward = block.number;
952         } else {
953             staker.lastClimedBlockForSwapReward = _getLastAvailableClaimedBlock(
954                 staker.lastClimedBlockForSwapReward,
955                 block.number,
956                 _claimPeriodForSwapReward
957             );
958         }
959 
960         return _sendLotteryAmount();
961     }
962 
963     /**
964      * @dev Withdraw YZY token from vault wallet to owner when only emergency!
965      *
966      */
967     function emergencyWithdrawToken() external onlyOwner {
968         require(_msgSender() != address(0), "Vault: Invalid address");
969 
970         uint256 tokenAmount = _yzy.balanceOf(address(this));
971         require(tokenAmount > 0, "Vault: Insufficient amount");
972 
973         _yzy.transfer(_msgSender(), tokenAmount);
974         emit EmergencyWithdrawToken(address(this), _msgSender(), tokenAmount);
975     }
976 
977     function _swapAndClaimTokens(uint256 rewards) internal {
978         require(rewards > 0, "Vault: No reward state");
979 
980         uint256 wethOldBalance = IERC20(_weth).balanceOf(address(this));
981 
982         // Swap YZY -> WETH And Get Weth Tokens For Reward
983         require(
984             swapTokensForTokens(
985                 address(_yzy),
986                 address(_weth),
987                 rewards,
988                 address(this)
989             ),
990             "Vault: Failed to swap from YZY to WETH."
991         );
992 
993         // Get New Swaped ETH Amount
994         uint256 wethNewBalance = IERC20(_weth).balanceOf(address(this)).sub(wethOldBalance);
995 
996         require(wethNewBalance > 0, "Vault: Invalid WETH amount.");
997 
998         uint256 yfiTokenReward = wethNewBalance.mul(_allocPointForYFI).div(10000);
999         uint256 wbtcTokenReward = wethNewBalance.mul(_allocPointForWBTC).div(10000);
1000         uint256 wethTokenReward = wethNewBalance.sub(yfiTokenReward).sub(wbtcTokenReward);
1001 
1002         // Transfer Weth Reward Tokens From Contract To Staker
1003         require(
1004             IERC20(_weth).transfer(_msgSender(), wethTokenReward),
1005             "Vault: Faild to WETH"
1006         );
1007 
1008         // Swap WETH -> YFI and give YFI token to User as reward
1009         require(
1010             swapTokensForTokens(
1011                 address(_weth),
1012                 address(_yfi),
1013                 yfiTokenReward,
1014                 _msgSender()
1015             ),
1016             "Vault: Failed to swap YFI."
1017         );
1018 
1019         // Swap YZY -> WBTC and give WBTC token to User as reward
1020         require(
1021             swapTokensForTokens(
1022                 address(_weth),
1023                 address(_wbtc),
1024                 wbtcTokenReward,
1025                 _msgSender()
1026             ),
1027             "Vault: Failed to swap WBTC."
1028         );
1029     }
1030 
1031     /**
1032      * @dev internal function to send lottery rewards
1033      */
1034     function _sendLotteryAmount() internal returns (bool) {
1035         if (!_enabledLottery || _lotteryAmount <= 0)
1036             return false;
1037         
1038         uint256 usdcReserve = 0;
1039         uint256 ethReserve1 = 0;
1040         uint256 yzyReserve = 0;
1041         uint256 ethReserve2 = 0;
1042         address token0 = _usdcETHV2Pair.token0();
1043 
1044         if (token0 == address(_weth)){
1045             (ethReserve1, usdcReserve, ) = _usdcETHV2Pair.getReserves();
1046         } else {
1047             (usdcReserve, ethReserve1, ) = _usdcETHV2Pair.getReserves();
1048         }
1049 
1050         token0 = _yzyETHV2Pair.token0();
1051 
1052         if (token0 == address(_weth)){
1053             (ethReserve2, yzyReserve, ) = _yzyETHV2Pair.getReserves();
1054         } else {
1055             (yzyReserve, ethReserve2, ) = _yzyETHV2Pair.getReserves();
1056         }
1057 
1058         if (ethReserve1 <= 0 || yzyReserve <= 0)
1059             return false;
1060 
1061         uint256 yzyPrice = usdcReserve.mul(1 ether).div(ethReserve1).mul(ethReserve2).div(yzyReserve);
1062         uint256 lotteryValue = yzyPrice.mul(_lotteryAmount).div(1 ether);
1063 
1064         if (lotteryValue > 0 && lotteryValue >= _lotteryLimit) {
1065             uint256 amount = _lotteryLimit.mul(1 ether).div(yzyPrice);
1066 
1067             if (amount > _lotteryAmount)
1068                 amount = _lotteryAmount;
1069 
1070             _yzy.transfer(_msgSender(), amount);
1071             _lotteryAmount = _lotteryAmount.sub(amount);
1072             _lotteryPaidOut = _lotteryPaidOut.add(amount);
1073 
1074             emit SentLotteryAmount(_msgSender(), amount, true);
1075 
1076             winnerInfo.push(
1077                 WinnerInfo({
1078                     winner: _msgSender(),
1079                     amount: amount,
1080                     timestamp: block.timestamp
1081                 })
1082             );
1083         }
1084 
1085         return false;
1086     }
1087 
1088     function safeYzyTransfer(address to, uint256 amount) internal returns (bool) {
1089         uint256 yzyBal = _yzy.balanceOf(address(this));
1090 
1091         if (amount > yzyBal) {
1092             _yzy.transfer(to, yzyBal);
1093         } else {
1094             _yzy.transfer(to, amount);
1095         }
1096 
1097         return true;
1098     }
1099 
1100     function isContract(address account) internal view returns (bool) {
1101         uint256 size;
1102         assembly { size := extcodesize(account) }
1103         return size > 0;
1104     }
1105 }