1 //SPDX-License-Identifier: Unlicensed
2 pragma solidity >=0.5.0 <0.9.0;
3 /**
4        d8888 8888888b.  8888888888 Y88b   d88P                                             
5       d88888 888   Y88b 888         Y88b d88P                                              
6      d88P888 888    888 888          Y88o88P                                               
7     d88P 888 888   d88P 8888888       Y888P                                                
8    d88P  888 8888888P"  888           d888b                                                
9   d88P   888 888        888          d88888b                                               
10  d8888888888 888        888         d88P Y88b                                              
11 d88P     888 888        8888888888 d88P   Y88b                                             
12                                                                                                                                                                                   
13                                                                                            
14 888     888 8888888888 888b    888 88888888888 888     888 8888888b.  8888888888 .d8888b.  
15 888     888 888        8888b   888     888     888     888 888   Y88b 888       d88P  Y88b 
16 888     888 888        88888b  888     888     888     888 888    888 888       Y88b.      
17 Y88b   d88P 8888888    888Y88b 888     888     888     888 888   d88P 8888888    "Y888b.   
18  Y88b d88P  888        888 Y88b888     888     888     888 8888888P"  888           "Y88b. 
19   Y88o88P   888        888  Y88888     888     888     888 888 T88b   888             "888 
20    Y888P    888        888   Y8888     888     Y88b. .d88P 888  T88b  888       Y88b  d88P 
21     Y8P     8888888888 888    Y888     888      "Y88888P"  888   T88b 8888888888 "Y8888P"  
22 
23 
24 
25 $APEX IS THE FIRST PROTOCOL TO ENSURE FUNDAMENTAL SUSTAINABILITY AND FAIRNESS IN REWARD DISTRIBUTION!
26 
27 
28 https://www.apexventureseth.com/
29 https://t.me/ApexVenturesOfficial
30 
31 
32 Welcome to APEX Ventures...  If you're reading these contract notes you're either a gem hunter watching new pairs, 
33 or you're a savvy investor who "Does YOR" and consumes all documentation before making a decision.  Perhaps we 
34 should address both audiences. The recent bear market has changed the crypto landscape as we know it, 
35 entire sub-industries like Defi 2.0 and FaaS we're brought to their knees.  We watched as giants tumbled one by one.
36 Strong, Ohm, Time, Mim, MCC, Luna, UST, Three Arrows.. the list goes on.  As the dust settled we looked around 
37 and asked ourselves one VERY SIMPLE question... who was actually left making profits?  
38 
39 It was a simple question with a simple answer; the people getting their hands dirty and physically operating
40 the miners processing the transactions were the ones earning consistent reliable profits. That's why were 
41 introducing a totally unique and brand new utility that's never been tried as a layer-2 on Ethereum blockchain,
42 we're it calling MaaS, Mining as a service! Our innovative protocol will revolutionise the defi world and
43 offer truly sustainable yield generation to our holders and unlike our predecessors there won’t be a 
44 requirement to sell your $Apex tokens to materialise these rewards. 
45 
46 Furthermore, Apex Ventures will offer our second brand new innovative utility to the Apex ecosystem which we 
47 are calling NaaS, NFTs as a service! Combining the protocols of MaaS and NaaS will allow us to offer exclusive 
48 yields to our NFT holders!    
49 
50 You don’t want to miss this! Come check us out for yourself.... https://t.me/ApexVenturesOfficial
51 
52 */
53 abstract contract Context {
54     function _msgSender() internal view returns (address payable) {
55         return payable(msg.sender);
56     }
57 
58     function _msgData() internal view returns (bytes memory) {
59         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
60         return msg.data;
61     }
62 }
63 
64 library SafeMath {
65     function add(uint256 a, uint256 b) internal pure returns (uint256) {
66         uint256 c = a + b;
67         require(c >= a, "SafeMath: addition overflow");
68     
69         return c;
70     }
71     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
72         return sub(a, b, "SafeMath: subtraction overflow");
73     }
74     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
75         require(b <= a, errorMessage);
76         uint256 c = a - b;
77     
78         return c;
79     }
80     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
81         if (a == 0) {
82             return 0;
83         }
84     
85         uint256 c = a * b;
86         require(c / a == b, "SafeMath: multiplication overflow");
87     
88         return c;
89     }
90     function div(uint256 a, uint256 b) internal pure returns (uint256) {
91         return div(a, b, "SafeMath: division by zero");
92     }
93     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
94         // Solidity only automatically asserts when dividing by 0
95         require(b > 0, errorMessage);
96         uint256 c = a / b;
97         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
98     
99         return c;
100     }
101 }
102 
103 interface IERC20 {
104     function totalSupply() external view returns (uint256);
105     function decimals() external view returns (uint8);
106     function symbol() external view returns (string memory);
107     function name() external view returns (string memory);
108     function getOwner() external view returns (address);
109     function balanceOf(address account) external view returns (uint256);
110     function transfer(address recipient, uint256 amount) external returns (bool);
111     function allowance(address _owner, address spender) external view returns (uint256);
112     function approve(address spender, uint256 amount) external returns (bool);
113     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
114     event Transfer(address indexed from, address indexed to, uint256 value);
115     event Approval(address indexed owner, address indexed spender, uint256 value);
116 }
117 
118 interface IUniswapV2Factory {
119     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
120 
121     function feeTo() external view returns (address);
122     function feeToSetter() external view returns (address);
123 
124     function getPair(address tokenA, address tokenB) external view returns (address pair);
125     function allPairs(uint) external view returns (address pair);
126     function allPairsLength() external view returns (uint);
127 
128     function createPair(address tokenA, address tokenB) external returns (address pair);
129 
130     function setFeeTo(address) external;
131     function setFeeToSetter(address) external;
132 }
133 
134 interface IUniswapV2Pair {
135     event Approval(address indexed owner, address indexed spender, uint value);
136     event Transfer(address indexed from, address indexed to, uint value);
137 
138     function name() external pure returns (string memory);
139     function symbol() external pure returns (string memory);
140     function decimals() external pure returns (uint8);
141     function totalSupply() external view returns (uint);
142     function balanceOf(address owner) external view returns (uint);
143     function allowance(address owner, address spender) external view returns (uint);
144 
145     function approve(address spender, uint value) external returns (bool);
146     function transfer(address to, uint value) external returns (bool);
147     function transferFrom(address from, address to, uint value) external returns (bool);
148 
149     function DOMAIN_SEPARATOR() external view returns (bytes32);
150     function PERMIT_TYPEHASH() external pure returns (bytes32);
151     function nonces(address owner) external view returns (uint);
152 
153     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
154 
155     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
156     event Swap(
157         address indexed sender,
158         uint amount0In,
159         uint amount1In,
160         uint amount0Out,
161         uint amount1Out,
162         address indexed to
163     );
164     event Sync(uint112 reserve0, uint112 reserve1);
165 
166     function MINIMUM_LIQUIDITY() external pure returns (uint);
167     function factory() external view returns (address);
168     function token0() external view returns (address);
169     function token1() external view returns (address);
170     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
171     function price0CumulativeLast() external view returns (uint);
172     function price1CumulativeLast() external view returns (uint);
173     function kLast() external view returns (uint);
174 
175     function burn(address to) external returns (uint amount0, uint amount1);
176     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
177     function skim(address to) external;
178     function sync() external;
179 
180     function initialize(address, address) external;
181 }
182 
183 interface IUniswapV2Router01 {
184     function factory() external pure returns (address);
185     function WETH() external pure returns (address);
186 
187     function addLiquidity(
188         address tokenA,
189         address tokenB,
190         uint amountADesired,
191         uint amountBDesired,
192         uint amountAMin,
193         uint amountBMin,
194         address to,
195         uint deadline
196     ) external returns (uint amountA, uint amountB, uint liquidity);
197     function addLiquidityETH(
198         address token,
199         uint amountTokenDesired,
200         uint amountTokenMin,
201         uint amountETHMin,
202         address to,
203         uint deadline
204     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
205     function removeLiquidity(
206         address tokenA,
207         address tokenB,
208         uint liquidity,
209         uint amountAMin,
210         uint amountBMin,
211         address to,
212         uint deadline
213     ) external returns (uint amountA, uint amountB);
214     function removeLiquidityETH(
215         address token,
216         uint liquidity,
217         uint amountTokenMin,
218         uint amountETHMin,
219         address to,
220         uint deadline
221     ) external returns (uint amountToken, uint amountETH);
222     function removeLiquidityWithPermit(
223         address tokenA,
224         address tokenB,
225         uint liquidity,
226         uint amountAMin,
227         uint amountBMin,
228         address to,
229         uint deadline,
230         bool approveMax, uint8 v, bytes32 r, bytes32 s
231     ) external returns (uint amountA, uint amountB);
232     function removeLiquidityETHWithPermit(
233         address token,
234         uint liquidity,
235         uint amountTokenMin,
236         uint amountETHMin,
237         address to,
238         uint deadline,
239         bool approveMax, uint8 v, bytes32 r, bytes32 s
240     ) external returns (uint amountToken, uint amountETH);
241     function swapExactTokensForTokens(
242         uint amountIn,
243         uint amountOutMin,
244         address[] calldata path,
245         address to,
246         uint deadline
247     ) external returns (uint[] memory amounts);
248     function swapTokensForExactTokens(
249         uint amountOut,
250         uint amountInMax,
251         address[] calldata path,
252         address to,
253         uint deadline
254     ) external returns (uint[] memory amounts);
255     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
256         external
257         payable
258         returns (uint[] memory amounts);
259     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
260         external
261         returns (uint[] memory amounts);
262     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
263         external
264         returns (uint[] memory amounts);
265     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
266         external
267         payable
268         returns (uint[] memory amounts);
269 
270     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
271     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
272     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
273     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
274     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
275 }
276 
277 interface IUniswapV2Router02 is IUniswapV2Router01 {
278     function removeLiquidityETHSupportingFeeOnTransferTokens(
279         address token,
280         uint liquidity,
281         uint amountTokenMin,
282         uint amountETHMin,
283         address to,
284         uint deadline
285     ) external returns (uint amountETH);
286     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
287         address token,
288         uint liquidity,
289         uint amountTokenMin,
290         uint amountETHMin,
291         address to,
292         uint deadline,
293         bool approveMax, uint8 v, bytes32 r, bytes32 s
294     ) external returns (uint amountETH);
295 
296     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
297         uint amountIn,
298         uint amountOutMin,
299         address[] calldata path,
300         address to,
301         uint deadline
302     ) external;
303     function swapExactETHForTokensSupportingFeeOnTransferTokens(
304         uint amountOutMin,
305         address[] calldata path,
306         address to,
307         uint deadline
308     ) external payable;
309     function swapExactTokensForETHSupportingFeeOnTransferTokens(
310         uint amountIn,
311         uint amountOutMin,
312         address[] calldata path,
313         address to,
314         uint deadline
315     ) external;
316 }
317 
318 interface IDividendDistributor {
319     function setDistributionCriteria(uint256 _minPeriod, uint256 _minDistribution,uint256 _minHoldReq) external;
320     function setShare(address shareholder, uint256 amount) external;
321     function deposit() external payable;
322     function process(uint256 gas) external;        
323     function claimDividendFor(address shareholder) external;
324     function holdReq() external view returns(uint256);
325     function getShareholderInfo(address shareholder) external view returns (uint256, uint256, uint256, uint256);
326     function getAccountInfo(address shareholder) external view returns (uint256, uint256, uint256, uint256);
327 }
328 
329 contract DividendDistributor is IDividendDistributor {
330     using SafeMath for uint256;
331     
332     address _token;
333     
334     struct Share {
335         uint256 amount;
336         uint256 totalExcluded;
337         uint256 totalRealised;
338     }
339     
340     address[] shareholders;
341     mapping (address => uint256) shareholderIndexes;
342     mapping (address => uint256) shareholderClaims;
343     mapping (address => Share) public shares;
344     uint256 public totalShares;
345     uint256 public totalDividends;
346     uint256 public totalDistributed;
347     uint256 public dividendsPerShare;
348     uint256 public dividendsPerShareAccuracyFactor = 10 ** 36;
349     
350     uint256 public minPeriod = 24*60 minutes; // amount of time for min distribution to accumalate, once over it sends after x amount automatically.
351     uint256 public minHoldReq = 100 * (10**9); // 100 tokens for rewards
352     uint256 public minDistribution = 0.01 * (10 ** 18); // .01 token with 18 decimals reward for auto claim
353     
354     uint256 currentIndex;
355     
356     bool initialized;
357     modifier initialization() {
358         require(!initialized);
359         _;
360         initialized = true;
361     }
362     
363     modifier onlyToken() {
364         require(msg.sender == _token); _;
365     }
366 
367     constructor () {
368         _token = msg.sender;
369     }
370 
371     function getShareholderInfo(address shareholder) external view override returns (uint256, uint256, uint256, uint256) {
372         return (
373             totalShares,
374             totalDistributed,
375             shares[shareholder].amount,
376             shares[shareholder].totalRealised             
377         );
378     }
379 
380     function holdReq() external view override returns(uint256) {
381         return minHoldReq;
382     }
383 
384     function getAccountInfo(address shareholder) external view override returns(
385         uint256 pendingReward,
386         uint256 lastClaimTime,
387         uint256 nextClaimTime,
388         uint256 secondsUntilAutoClaimAvailable){
389             
390         pendingReward = getUnpaidEarnings(shareholder);
391         lastClaimTime = shareholderClaims[shareholder];
392         nextClaimTime = lastClaimTime + minPeriod;
393         secondsUntilAutoClaimAvailable = nextClaimTime > block.timestamp ? nextClaimTime.sub(block.timestamp) : 0;
394     }
395 
396     function setDistributionCriteria(uint256 _minPeriod, uint256 _minDistribution, uint256 _minHoldReq) external override onlyToken {
397         minPeriod = _minPeriod;
398         minDistribution = _minDistribution;
399         minHoldReq = _minHoldReq * (10**9);
400         emit DistributionCriteriaUpdated(minPeriod, minDistribution, minHoldReq);
401     }
402     
403     function setShare(address shareholder, uint256 amount) external override onlyToken {
404         if(shares[shareholder].amount > 0){
405             distributeDividend(shareholder);
406         }
407     
408         if(amount >= minHoldReq && shares[shareholder].amount == 0){
409             addShareholder(shareholder);
410         }else if(amount < minHoldReq && shares[shareholder].amount > 0){
411             removeShareholder(shareholder);
412         }
413     
414         if(amount < minHoldReq) amount = 1;
415         totalShares = totalShares.sub(shares[shareholder].amount).add(amount);
416         shares[shareholder].amount = amount;
417         shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount);
418             
419         emit ShareUpdated(shareholder, amount);
420     }
421     
422     function deposit() external payable override {
423 
424         uint256 amount = msg.value;
425     
426         totalDividends = totalDividends.add(amount);
427         dividendsPerShare = dividendsPerShare.add(dividendsPerShareAccuracyFactor.mul(amount).div(totalShares));
428             
429         emit Deposit(amount);
430     }
431     
432     function process(uint256 gas) external override onlyToken {
433         uint256 shareholderCount = shareholders.length;
434     
435         if(shareholderCount == 0) { return; }
436     
437         uint256 gasUsed = 0;
438         uint256 gasLeft = gasleft();
439     
440         uint256 iterations = 0;
441         uint256 count = 0;
442     
443         while(gasUsed < gas && iterations < shareholderCount) {
444             if(currentIndex >= shareholderCount){
445                 currentIndex = 0;
446             }
447     
448             if(shouldDistribute(shareholders[currentIndex])){
449                 distributeDividend(shareholders[currentIndex]);
450                 count++;
451             }
452     
453             gasUsed = gasUsed.add(gasLeft.sub(gasleft()));
454             gasLeft = gasleft();
455             currentIndex++;
456             iterations++;
457         }
458             
459         emit DividendsProcessed(iterations, count, currentIndex);
460     }
461     
462     function shouldDistribute(address shareholder) internal view returns (bool) {
463         return shareholderClaims[shareholder] + minPeriod < block.timestamp
464         && getUnpaidEarnings(shareholder) > minDistribution;
465     }
466     
467     function distributeDividend(address shareholder) internal {
468         if(shares[shareholder].amount == 0){ return; }
469         uint256 amount = getUnpaidEarnings(shareholder);
470         if(amount > 0){
471             totalDistributed = totalDistributed.add(amount);
472             payable(shareholder).transfer(amount);
473             shareholderClaims[shareholder] = block.timestamp;
474             shares[shareholder].totalRealised = shares[shareholder].totalRealised.add(amount);
475             shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount);
476                         
477             emit Distribution(shareholder, amount);
478         }
479     }
480 
481     function claimDividend() public {
482         distributeDividend(msg.sender);
483     }
484     
485     function claimDividendFor(address shareholder) public override {
486         distributeDividend(shareholder);
487     }
488 
489     function getUnpaidEarnings(address shareholder) public view returns (uint256) {
490         if(shares[shareholder].amount == 0){ return 0; }
491     
492         uint256 shareholderTotalDividends = getCumulativeDividends(shares[shareholder].amount);
493         uint256 shareholderTotalExcluded = shares[shareholder].totalExcluded;
494     
495         if(shareholderTotalDividends <= shareholderTotalExcluded){ return 0; }
496     
497         return shareholderTotalDividends.sub(shareholderTotalExcluded);
498     }
499     
500     function getCumulativeDividends(uint256 share) internal view returns (uint256) {
501         return share.mul(dividendsPerShare).div(dividendsPerShareAccuracyFactor);
502     }
503     
504     function addShareholder(address shareholder) internal {
505         shareholderIndexes[shareholder] = shareholders.length;
506         shareholders.push(shareholder);
507     }
508     
509     function removeShareholder(address shareholder) internal {
510         shareholders[shareholderIndexes[shareholder]] = shareholders[shareholders.length-1];
511         shareholderIndexes[shareholders[shareholders.length-1]] = shareholderIndexes[shareholder];
512         shareholders.pop();
513     }
514         
515     event DistributionCriteriaUpdated(uint256 minPeriod, uint256 minDistribution, uint256 minHoldReq);
516     event ShareUpdated(address shareholder, uint256 amount);
517     event Deposit(uint256 amountETH);
518     event Distribution(address shareholder, uint256 amount);
519     event DividendsProcessed(uint256 iterations, uint256 count, uint256 index);
520 }
521 
522 contract av is IERC20, Context {
523     address public owner;
524     address public autoLiquidityReceiver;
525     address public treasuryFeeReceiver;
526     address public pair;
527 
528     string constant _name = "Apex Ventures";
529     string constant _symbol = "Apex";
530 
531     uint256 public constant _initialSupply = 1_000_000; // put supply amount here
532     uint256 _totalSupply = _initialSupply * (10**_decimals); // total supply amount
533     uint256 treasuryFees;
534     uint256 feeAmount;
535     uint256 liquidityAmount;
536     uint32 distributorGas = 500000;
537     uint16 feeDenominator = 100;
538     uint16 totalFee;
539     uint8 constant _decimals = 9;
540 
541     bool public autoClaimEnabled;
542     bool public feeEnabled;
543     bool public fundRewards;
544     mapping(address => mapping(address => uint256)) _allowances;
545     mapping(address => bool) authorizations;
546     mapping(address => bool) public bannedUsers;
547     mapping(address => uint256) _balances;
548     mapping(address => uint256) cooldown;
549     mapping(address => bool) isDividendExempt;
550     mapping(address => bool) isFeeExempt;
551     mapping(address => bool) public lpHolder;
552     mapping(address => bool) public lpPairs;    
553     mapping(address => bool) maxWalletExempt;
554     struct IFees {
555         uint16 liquidityFee;
556         uint16 treasuryFee;
557         uint16 reflectionFee;
558         uint16 totalFee;
559     }
560     struct ICooldown {
561         bool buycooldownEnabled;
562         bool sellcooldownEnabled;
563         uint8 cooldownLimit;
564         uint8 cooldownTime;
565     }
566     struct ILiquiditySettings {
567         uint256 liquidityFeeAccumulator;
568         uint256 numTokensToSwap;
569         uint256 lastSwap;
570         uint8 swapInterval;
571         bool swapEnabled;
572         bool inSwap;
573         bool autoLiquifyEnabled;
574     }
575     struct ILaunch {
576         uint256 launchBlock;
577         uint256 launchedAt;
578         uint8 sniperBlocks;
579         uint8 snipersCaught;
580         bool tradingOpen;
581         bool launchProtection;
582         bool earlySellFee;
583     }
584     struct ITransactionSettings {
585         uint256 maxTxAmount;
586         uint256 maxWalletAmount;
587         bool txLimits;
588     }        
589     IUniswapV2Router02 public router;
590     IDividendDistributor public distributor;
591     ILiquiditySettings public LiquiditySettings;
592     ICooldown public cooldownInfo;    
593     ILaunch public Launch;
594     ITransactionSettings public TransactionSettings;
595     IFees public BuyFees;
596     IFees public SellFees;
597     IFees public MaxFees;
598     IFees public TransferFees;
599     modifier swapping() {
600         LiquiditySettings.inSwap = true;
601         _;
602         LiquiditySettings.inSwap = false;
603     }
604     modifier onlyOwner() {
605         require(isOwner(msg.sender), "!OWNER");
606         _;
607     }
608     modifier authorized() {
609         require(isAuthorized(msg.sender), "!AUTHORIZED");
610         _;
611     }
612 
613     constructor() {
614         owner = _msgSender();
615         authorizations[owner] = true;
616         router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
617         pair = IUniswapV2Factory(router.factory()).createPair(router.WETH(), address(this));
618         lpPairs[pair] = true;
619         lpHolder[_msgSender()] = true;
620         _allowances[address(this)][address(router)] = type(uint256).max;
621         _allowances[_msgSender()][address(router)] = type(uint256).max;
622 
623         distributor = new DividendDistributor();
624 
625         isFeeExempt[address(this)] = true;
626         isFeeExempt[_msgSender()] = true;
627 
628         maxWalletExempt[_msgSender()] = true;
629         maxWalletExempt[address(this)] = true;
630         maxWalletExempt[pair] = true;
631 
632         isDividendExempt[pair] = true;
633         isDividendExempt[address(this)] = true;
634         isDividendExempt[address(0xDead)] = true;
635         setFeeReceivers(0x3f2A0733bF10526b635535667AA51a5d9e59953C,0x8f3625575254dC6A6C52043D8Ac7E2A48C7A4497);
636         cooldownInfo.cooldownLimit = 60; // cooldown cannot go over 60 seconds
637         MaxFees.totalFee = 20; // 20%
638         BuyFees = IFees({
639             liquidityFee: 1,
640             reflectionFee: 3,
641             treasuryFee: 5,
642             totalFee: 2 + 3 + 5
643         });
644         SellFees = IFees({
645             liquidityFee: 2,
646             reflectionFee: 6,
647             treasuryFee: 12,
648             totalFee: 2 + 6 + 12
649         });     
650         cooldownInfo = ICooldown ({
651             buycooldownEnabled: true,
652             sellcooldownEnabled: true,
653             cooldownLimit: 60, // cooldown cannot go over 60 seconds
654             cooldownTime: 30
655         });
656         TransactionSettings.maxTxAmount = _totalSupply / 100;
657         TransactionSettings.maxWalletAmount = _totalSupply / 50;
658         TransactionSettings.txLimits = true;     
659         LiquiditySettings.autoLiquifyEnabled = true;   
660         LiquiditySettings.swapEnabled = true;
661         LiquiditySettings.numTokensToSwap = (_totalSupply * 10) / (10000);
662         feeEnabled = true;
663         fundRewards = true;
664         autoClaimEnabled = true;
665         _balances[_msgSender()] = _totalSupply;
666         emit Transfer(address(0), _msgSender(), _totalSupply);
667     }
668     receive() external payable {}
669     // =============================================================
670     //                      OWNERSHIP OPERATIONS
671     // =============================================================    
672     function transferOwnership(address payable adr) external onlyOwner {
673         isFeeExempt[owner] = false;
674         maxWalletExempt[owner] = false;
675         lpHolder[owner] = false;
676         authorizations[owner] = false;        
677         isFeeExempt[adr] = true;
678         maxWalletExempt[adr] = true;
679         lpHolder[adr] = true;
680         owner = adr;
681         authorizations[adr] = true;
682         emit OwnershipTransferred(adr);
683     }
684     
685     function renounceOwnership() external onlyOwner {
686         isFeeExempt[owner] = false;
687         maxWalletExempt[owner] = false;
688         lpHolder[owner] = false;
689         authorizations[owner] = false; 
690         owner = address(0);
691         emit OwnershipRenounced();
692 
693     }
694 
695     function authorize(address adr) external onlyOwner {
696         authorizations[adr] = true;
697         emit Authorized(adr);
698     }
699 
700     function unauthorize(address adr) external onlyOwner {
701         authorizations[adr] = false;
702         emit Unauthorized(adr);
703     }
704     
705     // =============================================================
706     //                      ADMIN OPERATIONS
707     // =============================================================
708     function clearStuckBalance(uint256 amountPercentage) external onlyOwner {
709         require(amountPercentage <= 100);
710         uint256 amountEth = address(this).balance;
711         payable(treasuryFeeReceiver).transfer(
712             (amountEth * amountPercentage) / 100
713         );
714         treasuryFees += amountEth * amountPercentage;
715     }
716 
717     function clearStuckTokens(address _token, address _to) external onlyOwner returns (bool _sent) {
718         require(_token != address(0) && _token != address(this));
719         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
720         _sent = IERC20(_token).transfer(_to, _contractBalance);
721     }
722 
723     function airDropTokens(address[] memory addresses, uint256[] memory amounts) external onlyOwner{
724         require(addresses.length == amounts.length, "Lengths do not match.");
725         for (uint8 i = 0; i < addresses.length; i++) {
726             require(balanceOf(msg.sender) >= amounts[i]);
727             _basicTransfer(msg.sender, addresses[i], amounts[i]*10**_decimals);
728         }
729     }
730 
731     function setLpPair(address _pair, bool enabled) external onlyOwner{
732         lpPairs[_pair] = enabled;
733     }
734 
735     function setLpHolder(address holder, bool enabled) public onlyOwner{
736         lpHolder[holder] = enabled;
737     }
738 
739     function fundReward(bool rewards) external authorized {
740         fundRewards = rewards;
741     }
742 
743     function manualDeposit(uint256 amount) external authorized {
744         require(amount <= address(this).balance);
745         try distributor.deposit{value: amount}() {} catch {}
746     }
747 
748     function launch(uint8 sniperBlocks) external onlyOwner {
749         require(sniperBlocks <= 5);
750         require(!Launch.tradingOpen);
751         if(!Launch.tradingOpen) {
752             Launch.sniperBlocks = sniperBlocks;
753             Launch.launchedAt = block.timestamp;
754             Launch.launchBlock = block.number; 
755             Launch.earlySellFee = false;
756             Launch.launchProtection = true;
757             Launch.tradingOpen = true;
758         }        
759         emit Launched();
760     }
761 
762     function setTransactionLimits(bool enabled) external onlyOwner {
763         TransactionSettings.txLimits = enabled;
764     }
765 
766     function setTxLimit(uint256 percent, uint256 divisor) external authorized {
767         require(percent >= 1 && divisor <= 1000);
768         TransactionSettings.maxTxAmount = (_totalSupply * (percent)) / (divisor);
769         emit TxLimitUpdated(TransactionSettings.maxTxAmount);
770     }
771 
772     function setMaxWallet(uint256 percent, uint256 divisor) external authorized {
773         require(percent >= 1 && divisor <= 100);
774         TransactionSettings.maxWalletAmount = (_totalSupply * percent) / divisor;
775         emit WalletLimitUpdated(TransactionSettings.maxWalletAmount);
776     }
777 
778     function setIsDividendExempt(address holder, bool exempt) external authorized{
779         require(holder != address(this) && holder != pair);
780         isDividendExempt[holder] = exempt;
781         if (exempt) {
782             distributor.setShare(holder, 0);
783         } else {
784             distributor.setShare(holder, _balances[holder]);
785         }
786         emit DividendExemptUpdated(holder, exempt);
787     }
788 
789     function setIsFeeExempt(address holder, bool exempt) external onlyOwner {
790         isFeeExempt[holder] = exempt;
791         emit FeeExemptUpdated(holder, exempt);
792     }
793 
794     function setWalletBanStatus(address[] memory user, bool banned) external onlyOwner {
795         for(uint256 i; i < user.length; i++) {
796             _setBlacklistStatus(user[i], banned);
797             emit WalletBanStatusUpdated(user[i], banned);
798         }
799     }
800 
801     function setMaxWalletExempt(address holder, bool exempt) external authorized {
802         maxWalletExempt[holder] = exempt;
803         emit TxLimitExemptUpdated(holder, exempt);
804     }
805 
806     function setBuyFees(uint16 _liquidityFee, uint16 _reflectionFee, uint16 _treasuryFee) external authorized {
807         require(_liquidityFee + _treasuryFee + _reflectionFee <= MaxFees.totalFee);
808         BuyFees = IFees({
809             liquidityFee: _liquidityFee,
810             treasuryFee: _treasuryFee,
811             reflectionFee: _reflectionFee,
812             totalFee: _liquidityFee + _treasuryFee
813         });
814     }
815     
816     function setTransferFees(uint16 _liquidityFee, uint16 _reflectionFee, uint16 _treasuryFee) external authorized {
817         require(_liquidityFee + _treasuryFee + _reflectionFee <= MaxFees.totalFee);
818         TransferFees = IFees({
819             liquidityFee: _liquidityFee,
820             treasuryFee: _treasuryFee,
821             reflectionFee: _reflectionFee,
822             totalFee: _liquidityFee + _treasuryFee
823         });
824     }
825 
826     function setSellFees(uint16 _liquidityFee, uint16 _reflectionFee, uint16 _treasuryFee) external authorized {
827         require(_liquidityFee + _treasuryFee + _reflectionFee <= MaxFees.totalFee);
828         SellFees = IFees({
829             liquidityFee: _liquidityFee,
830             treasuryFee: _treasuryFee,
831             reflectionFee: _reflectionFee,
832             totalFee: _liquidityFee + _treasuryFee
833         });
834     } 
835 
836     function setMaxFees(uint16 _totalFee) external onlyOwner {
837         require(_totalFee <= MaxFees.totalFee);
838         MaxFees.totalFee = _totalFee;
839     }
840 
841     function FeesEnabled(bool _enabled) external onlyOwner {
842         feeEnabled = _enabled;
843         emit AreFeesEnabled(_enabled);
844     }
845 
846     function setFeeReceivers(address _autoLiquidityReceiver, address _treasuryFeeReceiver) public onlyOwner {
847         autoLiquidityReceiver = _autoLiquidityReceiver;
848         treasuryFeeReceiver = _treasuryFeeReceiver;
849         emit FeeReceiversUpdated(_autoLiquidityReceiver, _treasuryFeeReceiver);
850     }
851 
852     function setCooldownEnabled(bool buy, bool sell, uint8 _cooldown) external authorized {
853         require(_cooldown <= cooldownInfo.cooldownLimit);
854         cooldownInfo.cooldownTime = _cooldown;
855         cooldownInfo.buycooldownEnabled = buy;
856         cooldownInfo.sellcooldownEnabled = sell;
857     }
858 
859     function setSwapBackSettings(bool _enabled, uint256 _amount) external authorized{
860         LiquiditySettings.swapEnabled = _enabled;
861         LiquiditySettings.numTokensToSwap = (_totalSupply * (_amount)) / (10000);
862         emit SwapBackSettingsUpdated(_enabled, _amount);
863     }
864 
865    function setAutoLiquifyEnabled(bool _enabled) public authorized {
866         LiquiditySettings.autoLiquifyEnabled = _enabled;
867         emit AutoLiquifyUpdated(_enabled);
868     }
869 
870     function setDistributionCriteria(uint256 _minPeriod, uint256 _minDistribution, uint256 _minHoldReq) external authorized {
871         distributor.setDistributionCriteria(
872             _minPeriod,
873             _minDistribution,
874             _minHoldReq
875         );
876     }
877 
878     function setDistributorSettings(uint32 gas, bool _autoClaim) external authorized {
879         require(gas <= 1000000);
880         distributorGas = gas;
881         autoClaimEnabled = _autoClaim;
882         emit DistributorSettingsUpdated(gas, _autoClaim);
883     }
884 
885     // =============================================================
886     //                      INTERNAL OPERATIONS
887     // =============================================================
888     function approveMax(address sender, address spender, uint256 amount) private {
889         _allowances[sender][spender] = amount;
890         emit Approval(sender, spender, amount);
891     }
892 
893     function limits(address from, address to) private view returns (bool) {
894         return !isOwner(from)
895             && !isOwner(to)
896             && tx.origin != owner
897             && !isAuthorized(from)
898             && !isAuthorized(to)
899             && !lpHolder[from]
900             && !lpHolder[to]
901             && to != address(0xdead)
902             && to != address(0)
903             && from != address(this);
904     }
905 
906     function _transferFrom(address sender, address recipient, uint256 amount ) internal returns (bool) {
907         if (LiquiditySettings.inSwap) {
908             return _basicTransfer(sender, recipient, amount);
909         }
910         require(!bannedUsers[sender]);
911         require(!bannedUsers[recipient]);
912         if(limits(sender, recipient)){
913             if(!Launch.tradingOpen) checkLaunched(sender);
914             if(Launch.tradingOpen && TransactionSettings.txLimits){
915                 if(!maxWalletExempt[recipient]){
916                     require(amount <= TransactionSettings.maxTxAmount && balanceOf(recipient) + amount <= TransactionSettings.maxWalletAmount, "TOKEN: Amount exceeds Transaction size");
917                 }
918                 if (lpPairs[sender] && recipient != address(router) && !isFeeExempt[recipient] && cooldownInfo.buycooldownEnabled) {
919                     require(cooldown[recipient] < block.timestamp);
920                     cooldown[recipient] = block.timestamp + (cooldownInfo.cooldownTime);
921                 } else if (!lpPairs[sender] && !isFeeExempt[sender] && cooldownInfo.sellcooldownEnabled){
922                     require(cooldown[sender] <= block.timestamp);
923                     cooldown[sender] = block.timestamp + (cooldownInfo.cooldownTime);
924                 } 
925 
926                 if(Launch.tradingOpen && Launch.launchProtection){
927                     setBlacklistStatus(recipient);
928                 }
929             }
930         }
931 
932         if (shouldSwapBack()) {
933             swapBack();
934         }
935 
936         if(Launch.tradingOpen && autoClaimEnabled){
937             try distributor.process(distributorGas) {} catch {}
938         }
939 
940         uint256 amountReceived = shouldTakeFee(sender) ? takeFee(sender, recipient, amount) : amount;
941         _basicTransfer(sender, recipient, amountReceived);
942 
943         return true;
944     }
945 
946     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
947         _balances[sender] = _balances[sender] - amount;
948         _balances[recipient] = _balances[recipient] + amount;
949         emit Transfer(sender, recipient, amount);
950         if (!isDividendExempt[sender]) {
951             try distributor.setShare(sender, _balances[sender]) {} catch {}
952         }
953         if (!isDividendExempt[recipient]) {
954             try distributor.setShare(recipient, _balances[recipient]){} catch {}
955         }
956         return true;
957     }
958 
959     function checkLaunched(address sender) internal view {
960         require(Launch.tradingOpen || isAuthorized(sender), "Pre-Launch Protection");
961     }
962 
963     function shouldTakeFee(address sender) internal view returns (bool) {
964         return feeEnabled && !isFeeExempt[sender];
965     }
966 
967     function takeFee(address sender, address receiver, uint256 amount) internal returns (uint256) {
968         if (isFeeExempt[receiver]) {
969             return amount;
970         }
971         if(block.timestamp >= Launch.launchedAt + 24 hours && Launch.earlySellFee){
972             SellFees = IFees({
973                 liquidityFee: 2,
974                 treasuryFee: 5,
975                 reflectionFee: 3,
976                 totalFee: 2 + 5 + 3
977             });
978             Launch.earlySellFee = false;
979         }
980         if(lpPairs[receiver]) {            
981             totalFee = SellFees.totalFee;         
982         } else if(lpPairs[sender]){
983             totalFee = BuyFees.totalFee;
984         } else {
985             totalFee = TransferFees.totalFee;
986         }
987 
988         if(block.number == Launch.launchBlock){
989             totalFee = 99;
990         }
991         feeAmount = (amount * totalFee) / feeDenominator;
992 
993         if (LiquiditySettings.autoLiquifyEnabled) {
994             liquidityAmount = (feeAmount * (BuyFees.liquidityFee + SellFees.liquidityFee)) / ((BuyFees.totalFee + SellFees.totalFee) + (BuyFees.liquidityFee + SellFees.liquidityFee));
995             if(block.number == Launch.launchBlock) liquidityAmount = feeAmount;
996             LiquiditySettings.liquidityFeeAccumulator += liquidityAmount;
997         }
998         _basicTransfer(sender, address(this), feeAmount); 
999         return amount - feeAmount;
1000     }
1001 
1002     function shouldSwapBack() internal view returns (bool) {
1003         return
1004             !lpPairs[_msgSender()] &&
1005             !LiquiditySettings.inSwap &&
1006             LiquiditySettings.swapEnabled &&
1007             block.timestamp >= LiquiditySettings.lastSwap + LiquiditySettings.swapInterval &&
1008             _balances[address(this)] >= LiquiditySettings.numTokensToSwap;
1009     }
1010  
1011     function swapBack() internal swapping {
1012         LiquiditySettings.lastSwap = block.timestamp;
1013         if (LiquiditySettings.liquidityFeeAccumulator >= LiquiditySettings.numTokensToSwap && LiquiditySettings.autoLiquifyEnabled) {
1014             LiquiditySettings.liquidityFeeAccumulator -= LiquiditySettings.numTokensToSwap;
1015             uint256 amountToLiquify = LiquiditySettings.numTokensToSwap / 2;
1016 
1017             address[] memory path = new address[](2);
1018             path[0] = address(this);
1019             path[1] = router.WETH();
1020 
1021             uint256 balanceBefore = address(this).balance;
1022 
1023             router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1024                 amountToLiquify,
1025                 0,
1026                 path,
1027                 address(this),
1028                 block.timestamp
1029             );
1030 
1031             uint256 amountEth = address(this).balance - (balanceBefore);
1032 
1033             router.addLiquidityETH{value: amountEth}(
1034                 address(this),
1035                 amountToLiquify,
1036                 0,
1037                 0,
1038                 autoLiquidityReceiver,
1039                 block.timestamp
1040             );
1041 
1042             emit AutoLiquify(amountEth, amountToLiquify);
1043         } else {
1044             address[] memory path = new address[](2);
1045             path[0] = address(this);
1046             path[1] = router.WETH();
1047 
1048             uint256 balanceBefore = address(this).balance;
1049 
1050             router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1051                 LiquiditySettings.numTokensToSwap,
1052                 0,
1053                 path,
1054                 address(this),
1055                 block.timestamp
1056             );
1057 
1058             uint256 amountEth = address(this).balance - (balanceBefore);
1059 
1060             uint256 amountEthTreasury = (amountEth *
1061                 (BuyFees.treasuryFee + SellFees.treasuryFee)) /
1062                 (BuyFees.totalFee + SellFees.totalFee);
1063 
1064             uint256 amountEthReflection = (amountEth *
1065                 (BuyFees.reflectionFee + SellFees.reflectionFee)) /
1066                 (BuyFees.totalFee + SellFees.totalFee);
1067 
1068             if(fundRewards) {
1069                 try distributor.deposit{value: amountEthReflection}() {} catch {}
1070                 (bool treasury, ) = payable(treasuryFeeReceiver).call{ value: amountEthTreasury, gas: 30000}("");
1071                 if(treasury) treasuryFees += amountEthTreasury;
1072             } else {
1073                 (bool treasury, ) = payable(treasuryFeeReceiver).call{ value: amountEthTreasury, gas: 30000}("");
1074                 if(treasury) treasuryFees += amountEthTreasury;
1075             }
1076 
1077             emit SwapBack(LiquiditySettings.numTokensToSwap, amountEth);
1078         }
1079     }
1080 
1081     function setBlacklistStatus(address account) internal {
1082         Launch.launchBlock + Launch.sniperBlocks > block.number 
1083         ? _setBlacklistStatus(account, true)
1084         : turnOff();
1085         if(Launch.launchProtection){
1086             Launch.snipersCaught++;
1087             isDividendExempt[account] = true;
1088         }
1089     }
1090 
1091     function turnOff() internal {
1092         Launch.launchProtection = false;
1093     }
1094 
1095     function _setBlacklistStatus(address account, bool blacklisted) internal {
1096         if (blacklisted) {
1097             bannedUsers[account] = true;
1098         } else {
1099             bannedUsers[account] = false;
1100         }           
1101     }
1102 
1103     // =============================================================
1104     //                      EXTERNAL OPERATIONS
1105     // =============================================================
1106 
1107     function totalSupply() external view override returns (uint256) {
1108         return _totalSupply;
1109     }
1110 
1111     function decimals() external pure override returns (uint8) {
1112         return _decimals;
1113     }
1114 
1115     function symbol() external pure override returns (string memory) {
1116         return _symbol;
1117     }
1118 
1119     function name() external pure override returns (string memory) {
1120         return _name;
1121     }
1122 
1123     function getOwner() external view override returns (address) {
1124         return owner;
1125     }
1126 
1127     function balanceOf(address account) public view override returns (uint256) {
1128         return _balances[account];
1129     }
1130 
1131     function allowance(address holder, address spender) external view override returns (uint256) {
1132         return _allowances[holder][spender];
1133     }
1134 
1135     function approve(address spender, uint256 amount) public override returns (bool) {
1136         _allowances[msg.sender][spender] = amount;
1137         emit Approval(msg.sender, spender, amount);
1138         return true;
1139     }
1140 
1141     function transfer(address recipient, uint256 amount) external override returns (bool){
1142         return _transferFrom(msg.sender, recipient, amount);
1143     }
1144 
1145     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
1146         if (_allowances[sender][msg.sender] != type(uint256).max) {
1147             _allowances[sender][msg.sender] -= amount;
1148         }
1149 
1150         return _transferFrom(sender, recipient, amount);
1151     }
1152 
1153     function getAccumulatedFees() external view returns (uint256 collectedFees, uint256 currentBalance) {
1154         collectedFees = treasuryFees;
1155         currentBalance = treasuryFeeReceiver.balance;
1156     }
1157 
1158     function isOwner(address account) public view returns (bool) {
1159         return account == owner;
1160     }
1161 
1162     function isAuthorized(address adr) public view returns (bool) {
1163         return authorizations[adr];
1164     }
1165 
1166     function processDividends(uint256 gas) external {
1167         if(gas == 0) gas = distributorGas;
1168         try distributor.process(gas) {} catch {}
1169     }
1170 
1171     function getShareholderInfo(address shareholder) external view returns (uint256, uint256, uint256, uint256) {
1172         return distributor.getShareholderInfo(shareholder);
1173     }
1174 
1175     function getAccountInfo(address shareholder) external view returns (uint256, uint256, uint256, uint256) {
1176         return distributor.getAccountInfo(shareholder);
1177     }
1178 
1179     function holdReq() external view returns(uint256) {
1180         return distributor.holdReq();
1181     }
1182 
1183     function claimDividendFor(address shareholder) external {
1184         distributor.claimDividendFor(shareholder);
1185     }
1186 
1187     function claimDividend() external {
1188         distributor.claimDividendFor(msg.sender);
1189     }
1190 
1191     event AreFeesEnabled(bool enabled);
1192     event Authorized(address adr);
1193     event AutoLiquify(uint256 amountEth, uint256 amountToken);
1194     event AutoLiquifyUpdated(bool enabled);
1195     event DistributorSettingsUpdated(uint256 gas, bool _autoClaim);
1196     event DividendExemptUpdated(address holder, bool exempt);
1197     event FeeExemptUpdated(address holder, bool exempt);
1198     event FeeReceiversUpdated(address autoLiquidityReceiver, address treasuryFeeReceiver);
1199     event Launched();
1200     event OwnershipRenounced();
1201     event OwnershipTransferred(address owner);
1202     event SwapBack(uint256 amountToken, uint256 amountEth);
1203     event SwapBackSettingsUpdated(bool enabled, uint256 amount);
1204     event TxLimitExemptUpdated(address holder, bool exempt);
1205     event TxLimitUpdated(uint256 amount);
1206     event Unauthorized(address adr);
1207     event WalletLimitUpdated(uint256 amount);
1208     event WalletBanStatusUpdated(address user, bool banned);
1209 }