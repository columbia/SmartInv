1 /*
2 
3 
4      ██████   ██████  ██      ██████  ███████ ███    ██     ██████  ███████ ████████ ██████  ██ ███████ ██    ██ ███████ ██████      ██    ██ ██████  
5     ██       ██    ██ ██      ██   ██ ██      ████   ██     ██   ██ ██         ██    ██   ██ ██ ██      ██    ██ ██      ██   ██     ██    ██      ██ 
6     ██   ███ ██    ██ ██      ██   ██ █████   ██ ██  ██     ██████  █████      ██    ██████  ██ █████   ██    ██ █████   ██████      ██    ██  █████  
7     ██    ██ ██    ██ ██      ██   ██ ██      ██  ██ ██     ██   ██ ██         ██    ██   ██ ██ ██       ██  ██  ██      ██   ██      ██  ██  ██      
8      ██████   ██████  ███████ ██████  ███████ ██   ████     ██   ██ ███████    ██    ██   ██ ██ ███████   ████   ███████ ██   ██       ████   ███████ 
9                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
10 
11 This is THE REAL 02 of Golden Retriever Token, Gold Retriever. Two things that have held true since the beginning of time. The first, dogs have given us unconditional love. 
12 The perfect example is The Golden Retriever. If you don’t believe in God go play with one and you will. 
13 The second is that Gold is the only real money.  Put it on the blockchain it’s unstoppable. I have given you both. 
14 A token that Rewards in real gold and a token that harnesses the financial freedom of blockchain all while giving back to the beings that never stopped loving us, dogs. 
15 This contract will be locked for quite some time. 
16 Use it well and save your gold, you will need it as the fiat markets crumble which is NOW.  
17 The gold rewards you receive are redeemable for real physical gold. 
18 
19 
20 
21 https://www.thegoldenretrievertoken.com
22 https://t.me/GLDN_Retriever
23 https://twitter.com/0xGoldRetriever
24 
25 */
26 
27 // SPDX-License-Identifier: MIT
28 
29 pragma solidity ^0.7.4;
30 
31 library SafeMathInt {
32     int256 private constant MIN_INT256 = int256(1) << 255;
33     int256 private constant MAX_INT256 = ~(int256(1) << 255);
34 
35     function mul(int256 a, int256 b) internal pure returns (int256) {
36         int256 c = a * b;
37 
38         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
39         require((b == 0) || (c / b == a));
40         return c;
41     }
42 
43     function div(int256 a, int256 b) internal pure returns (int256) {
44         require(b != -1 || a != MIN_INT256);
45 
46         return a / b;
47     }
48 
49     function sub(int256 a, int256 b) internal pure returns (int256) {
50         int256 c = a - b;
51         require((b >= 0 && c <= a) || (b < 0 && c > a));
52         return c;
53     }
54 
55     function add(int256 a, int256 b) internal pure returns (int256) {
56         int256 c = a + b;
57         require((b >= 0 && c >= a) || (b < 0 && c < a));
58         return c;
59     }
60 
61     function abs(int256 a) internal pure returns (int256) {
62         require(a != MIN_INT256);
63         return a < 0 ? -a : a;
64     }
65 }
66 
67 library SafeMath {
68     function add(uint256 a, uint256 b) internal pure returns (uint256) {
69         uint256 c = a + b;
70         require(c >= a, "SafeMath: addition overflow");
71 
72         return c;
73     }
74 
75     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
76         return sub(a, b, "SafeMath: subtraction overflow");
77     }
78 
79     function sub(
80         uint256 a,
81         uint256 b,
82         string memory errorMessage
83     ) internal pure returns (uint256) {
84         require(b <= a, errorMessage);
85         uint256 c = a - b;
86 
87         return c;
88     }
89 
90     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
91         if (a == 0) {
92             return 0;
93         }
94 
95         uint256 c = a * b;
96         require(c / a == b, "SafeMath: multiplication overflow");
97 
98         return c;
99     }
100 
101     function div(uint256 a, uint256 b) internal pure returns (uint256) {
102         return div(a, b, "SafeMath: division by zero");
103     }
104 
105     function div(
106         uint256 a,
107         uint256 b,
108         string memory errorMessage
109     ) internal pure returns (uint256) {
110         require(b > 0, errorMessage);
111         uint256 c = a / b;
112 
113         return c;
114     }
115 
116     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
117         require(b != 0);
118         return a % b;
119     }
120 }
121 
122 interface IERC20 {
123     function totalSupply() external view returns (uint256);
124 
125     function balanceOf(address who) external view returns (uint256);
126 
127     function allowance(address owner, address spender)
128         external
129         view
130         returns (uint256);
131 
132     function transfer(address to, uint256 value) external returns (bool);
133 
134     function approve(address spender, uint256 value) external returns (bool);
135 
136     function transferFrom(
137         address from,
138         address to,
139         uint256 value
140     ) external returns (bool);
141 
142     event Transfer(address indexed from, address indexed to, uint256 value);
143 
144     event Approval(
145         address indexed owner,
146         address indexed spender,
147         uint256 value
148     );
149 }
150 
151 interface IPancakeSwapPair {
152 		event Approval(address indexed owner, address indexed spender, uint value);
153 		event Transfer(address indexed from, address indexed to, uint value);
154 
155 		function name() external pure returns (string memory);
156 		function symbol() external pure returns (string memory);
157 		function decimals() external pure returns (uint8);
158 		function totalSupply() external view returns (uint);
159 		function balanceOf(address owner) external view returns (uint);
160 		function allowance(address owner, address spender) external view returns (uint);
161 
162 		function approve(address spender, uint value) external returns (bool);
163 		function transfer(address to, uint value) external returns (bool);
164 		function transferFrom(address from, address to, uint value) external returns (bool);
165 
166 		function DOMAIN_SEPARATOR() external view returns (bytes32);
167 		function PERMIT_TYPEHASH() external pure returns (bytes32);
168 		function nonces(address owner) external view returns (uint);
169 
170 		function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
171 
172 		event Mint(address indexed sender, uint amount0, uint amount1);
173 		event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
174 		event Swap(
175 				address indexed sender,
176 				uint amount0In,
177 				uint amount1In,
178 				uint amount0Out,
179 				uint amount1Out,
180 				address indexed to
181 		);
182 		event Sync(uint112 reserve0, uint112 reserve1);
183 
184 		function MINIMUM_LIQUIDITY() external pure returns (uint);
185 		function factory() external view returns (address);
186 		function token0() external view returns (address);
187 		function token1() external view returns (address);
188 		function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
189 		function price0CumulativeLast() external view returns (uint);
190 		function price1CumulativeLast() external view returns (uint);
191 		function kLast() external view returns (uint);
192 
193 		function mint(address to) external returns (uint liquidity);
194 		function burn(address to) external returns (uint amount0, uint amount1);
195 		function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
196 		function skim(address to) external;
197 		function sync() external;
198 
199 		function initialize(address, address) external;
200 }
201 
202 interface IPancakeSwapRouter{
203 		function factory() external pure returns (address);
204 		function WETH() external pure returns (address);
205 
206 		function addLiquidity(
207 				address tokenA,
208 				address tokenB,
209 				uint amountADesired,
210 				uint amountBDesired,
211 				uint amountAMin,
212 				uint amountBMin,
213 				address to,
214 				uint deadline
215 		) external returns (uint amountA, uint amountB, uint liquidity);
216 		function addLiquidityETH(
217 				address token,
218 				uint amountTokenDesired,
219 				uint amountTokenMin,
220 				uint amountETHMin,
221 				address to,
222 				uint deadline
223 		) external payable returns (uint amountToken, uint amountETH, uint liquidity);
224 		function removeLiquidity(
225 				address tokenA,
226 				address tokenB,
227 				uint liquidity,
228 				uint amountAMin,
229 				uint amountBMin,
230 				address to,
231 				uint deadline
232 		) external returns (uint amountA, uint amountB);
233 		function removeLiquidityETH(
234 				address token,
235 				uint liquidity,
236 				uint amountTokenMin,
237 				uint amountETHMin,
238 				address to,
239 				uint deadline
240 		) external returns (uint amountToken, uint amountETH);
241 		function removeLiquidityWithPermit(
242 				address tokenA,
243 				address tokenB,
244 				uint liquidity,
245 				uint amountAMin,
246 				uint amountBMin,
247 				address to,
248 				uint deadline,
249 				bool approveMax, uint8 v, bytes32 r, bytes32 s
250 		) external returns (uint amountA, uint amountB);
251 		function removeLiquidityETHWithPermit(
252 				address token,
253 				uint liquidity,
254 				uint amountTokenMin,
255 				uint amountETHMin,
256 				address to,
257 				uint deadline,
258 				bool approveMax, uint8 v, bytes32 r, bytes32 s
259 		) external returns (uint amountToken, uint amountETH);
260 		function swapExactTokensForTokens(
261 				uint amountIn,
262 				uint amountOutMin,
263 				address[] calldata path,
264 				address to,
265 				uint deadline
266 		) external returns (uint[] memory amounts);
267 		function swapTokensForExactTokens(
268 				uint amountOut,
269 				uint amountInMax,
270 				address[] calldata path,
271 				address to,
272 				uint deadline
273 		) external returns (uint[] memory amounts);
274 		function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
275 				external
276 				payable
277 				returns (uint[] memory amounts);
278 		function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
279 				external
280 				returns (uint[] memory amounts);
281 		function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
282 				external
283 				returns (uint[] memory amounts);
284 		function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
285 				external
286 				payable
287 				returns (uint[] memory amounts);
288 
289 		function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
290 		function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
291 		function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
292 		function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
293 		function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
294 		function removeLiquidityETHSupportingFeeOnTransferTokens(
295 			address token,
296 			uint liquidity,
297 			uint amountTokenMin,
298 			uint amountETHMin,
299 			address to,
300 			uint deadline
301 		) external returns (uint amountETH);
302 		function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
303 			address token,
304 			uint liquidity,
305 			uint amountTokenMin,
306 			uint amountETHMin,
307 			address to,
308 			uint deadline,
309 			bool approveMax, uint8 v, bytes32 r, bytes32 s
310 		) external returns (uint amountETH);
311 	
312 		function swapExactTokensForTokensSupportingFeeOnTransferTokens(
313 			uint amountIn,
314 			uint amountOutMin,
315 			address[] calldata path,
316 			address to,
317 			uint deadline
318 		) external;
319 		function swapExactETHForTokensSupportingFeeOnTransferTokens(
320 			uint amountOutMin,
321 			address[] calldata path,
322 			address to,
323 			uint deadline
324 		) external payable;
325 		function swapExactTokensForETHSupportingFeeOnTransferTokens(
326 			uint amountIn,
327 			uint amountOutMin,
328 			address[] calldata path,
329 			address to,
330 			uint deadline
331 		) external;
332 }
333 
334 interface IPancakeSwapFactory {
335 		event PairCreated(address indexed token0, address indexed token1, address pair, uint);
336 
337 		function feeTo() external view returns (address);
338 		function feeToSetter() external view returns (address);
339 
340 		function getPair(address tokenA, address tokenB) external view returns (address pair);
341 		function allPairs(uint) external view returns (address pair);
342 		function allPairsLength() external view returns (uint);
343 
344 		function createPair(address tokenA, address tokenB) external returns (address pair);
345 
346 		function setFeeTo(address) external;
347 		function setFeeToSetter(address) external;
348 }
349 
350 interface IDividendDistributor {
351     function setDistributionCriteria(uint256 _minPeriod, uint256 _minDistribution) external;
352     function setShare(address shareholder, uint256 amount) external;
353     function deposit() external payable;
354     function process(uint256 gas) external;
355 }
356 
357 contract DividendDistributor is IDividendDistributor {
358     using SafeMath for uint256;
359 
360     address _token;
361 
362     struct Share {
363         uint256 amount;
364         uint256 totalExcluded;
365         uint256 totalRealised;
366     }
367     //Mainnet
368     IERC20 PAX = IERC20(0x45804880De22913dAFE09f4980848ECE6EcbAf78); 
369 
370     //Testnet 
371     //IERC20 PAX = IERC20(0xaD6D458402F60fD3Bd25163575031ACDce07538D);  //DAI TOKEN
372 
373     IPancakeSwapRouter router;
374 
375     address[] shareholders;
376     mapping (address => uint256) shareholderIndexes;
377     mapping (address => uint256) shareholderClaims;
378 
379     mapping (address => Share) public shares;
380 
381     uint256 public totalShares;
382     uint256 public totalDividends;
383     uint256 public totalDistributed;
384     uint256 public dividendsPerShare;
385     uint256 public currentIndex;
386 
387     uint256 public dividendsPerShareAccuracyFactor = 10 ** 36;
388     uint256 public minPeriod = 1 hours;
389     uint256 public minDistribution = 1 * (10 ** 18);
390 
391     bool initialized;
392     modifier initialization() {
393         require(!initialized);
394         _;
395         initialized = true;
396     }
397 
398     modifier onlyToken() {
399         require(msg.sender == _token); _;
400     }
401 
402     constructor (address _router) {
403         router = _router != address(0)
404         ? IPancakeSwapRouter(_router)
405         : IPancakeSwapRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
406         _token = msg.sender;
407     }
408 
409     function setDistributionCriteria(uint256 _minPeriod, uint256 _minDistribution) external override onlyToken {
410         minPeriod = _minPeriod;
411         minDistribution = _minDistribution;
412     }
413 
414     function setShare(address shareholder, uint256 amount) external override onlyToken {
415         if(shares[shareholder].amount > 0){
416             distributeDividend(shareholder);
417         }
418 
419         if(amount > 0 && shares[shareholder].amount == 0){
420             addShareholder(shareholder);
421         }else if(amount == 0 && shares[shareholder].amount > 0){
422             removeShareholder(shareholder);
423         }
424 
425         totalShares = totalShares.sub(shares[shareholder].amount).add(amount);
426         shares[shareholder].amount = amount;
427         shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount);
428     }
429 
430     function rescueToken(address tokenAddress,address _receiver, uint256 tokens) external onlyToken returns (bool success){
431         return IERC20(tokenAddress).transfer(_receiver, tokens);
432     }
433 
434     function deposit() external payable override onlyToken {
435         uint256 balanceBefore = PAX.balanceOf(address(this));
436 
437         address[] memory path = new address[](2);
438         path[0] = router.WETH();
439         path[1] = address(PAX);
440 
441         router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: msg.value}(
442             0,
443             path,
444             address(this),
445             block.timestamp
446         );
447 
448         uint256 amount = PAX.balanceOf(address(this)).sub(balanceBefore);
449 
450         totalDividends = totalDividends.add(amount);
451         dividendsPerShare = dividendsPerShare.add(dividendsPerShareAccuracyFactor.mul(amount).div(totalShares));
452     }
453 
454     function process(uint256 gas) external override onlyToken {
455         uint256 shareholderCount = shareholders.length;
456 
457         if(shareholderCount == 0) { return; }
458 
459         uint256 gasUsed = 0;
460         uint256 gasLeft = gasleft();
461         uint256 iterations = 0;
462 
463         while(gasUsed < gas && iterations < shareholderCount) {
464             if(currentIndex >= shareholderCount){
465                 currentIndex = 0;
466             }
467 
468             if(shouldDistribute(shareholders[currentIndex])){
469                 distributeDividend(shareholders[currentIndex]);
470             }
471 
472             gasUsed = gasUsed.add(gasLeft.sub(gasleft()));
473             gasLeft = gasleft();
474             currentIndex++;
475             iterations++;
476         }
477     }
478 
479     function shouldDistribute(address shareholder) internal view returns (bool) {
480         return shareholderClaims[shareholder] + minPeriod < block.timestamp && getUnpaidEarnings(shareholder) > minDistribution;
481     }
482 
483     function distributeDividend(address shareholder) internal {
484         if(shares[shareholder].amount == 0){ return; }
485 
486         uint256 amount = getUnpaidEarnings(shareholder);
487         if(amount > 0){
488             totalDistributed = totalDistributed.add(amount);
489             PAX.transfer(shareholder, amount);
490             shareholderClaims[shareholder] = block.timestamp;
491             shares[shareholder].totalRealised = shares[shareholder].totalRealised.add(amount);
492             shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount);
493         }
494     }
495 
496     function claimDividend() external {
497         distributeDividend(msg.sender);
498     }
499 
500     function getUnpaidEarnings(address shareholder) public view returns (uint256) {
501         if(shares[shareholder].amount == 0){ return 0; }
502 
503         uint256 shareholderTotalDividends = getCumulativeDividends(shares[shareholder].amount);
504         uint256 shareholderTotalExcluded = shares[shareholder].totalExcluded;
505 
506         if(shareholderTotalDividends <= shareholderTotalExcluded){ return 0; }
507 
508         return shareholderTotalDividends.sub(shareholderTotalExcluded);
509     }
510 
511     function getCumulativeDividends(uint256 share) internal view returns (uint256) {
512         return share.mul(dividendsPerShare).div(dividendsPerShareAccuracyFactor);
513     }
514 
515     function addShareholder(address shareholder) internal {
516         shareholderIndexes[shareholder] = shareholders.length;
517         shareholders.push(shareholder);
518     }
519 
520     function removeShareholder(address shareholder) internal {
521         shareholders[shareholderIndexes[shareholder]] = shareholders[shareholders.length-1];
522         shareholderIndexes[shareholders[shareholders.length-1]] = shareholderIndexes[shareholder];
523         shareholders.pop();
524     }
525 }
526 
527 contract Ownable {
528     address private _owner;
529 
530     event OwnershipRenounced(address indexed previousOwner);
531 
532     event OwnershipTransferred(
533         address indexed previousOwner,
534         address indexed newOwner
535     );
536 
537     constructor() {
538         _owner = msg.sender;
539     }
540 
541     function owner() public view returns (address) {
542         return _owner;
543     }
544 
545     modifier onlyOwner() {
546         require(isOwner());
547         _;
548     }
549 
550     function isOwner() public view returns (bool) {
551         return msg.sender == _owner;
552     }
553 
554     function renounceOwnership() public onlyOwner {
555         emit OwnershipRenounced(_owner);
556         _owner = address(0);
557     }
558 
559     function transferOwnership(address newOwner) public onlyOwner {
560         _transferOwnership(newOwner);
561     }
562 
563     function _transferOwnership(address newOwner) internal {
564         require(newOwner != address(0));
565         emit OwnershipTransferred(_owner, newOwner);
566         _owner = newOwner;
567     }
568 }
569 
570 abstract contract ERC20Detailed is IERC20 {
571     string private _name;
572     string private _symbol;
573     uint8 private _decimals;
574 
575     constructor(
576         string memory name_,
577         string memory symbol_,
578         uint8 decimals_
579     ) {
580         _name = name_;
581         _symbol = symbol_;
582         _decimals = decimals_;
583     }
584 
585     function name() public view returns (string memory) {
586         return _name;
587     }
588 
589     function symbol() public view returns (string memory) {
590         return _symbol;
591     }
592 
593     function decimals() public view returns (uint8) {
594         return _decimals;
595     }
596 }
597 
598 contract GoldenRetrieverV2 is ERC20Detailed, Ownable {
599 
600     using SafeMath for uint256;
601     using SafeMathInt for int256;
602 
603 
604     modifier validRecipient(address to) {
605         require(to != address(0x0));
606         _;
607     }
608 
609     uint256 public buyLiquidityFee = 0;
610     uint256 public buyMarketingFee = 0;
611     uint256 public buyRewardsFee = 0;
612 
613     uint256 public sellLiquidityFee = 40;
614     uint256 public sellMarketingFee = 0;
615     uint256 public sellRewardsFee = 40;
616 
617     uint256 public AmountLiquidityFee;
618     uint256 public AmountMarketingFee;
619     uint256 public AmountRewardsFee;
620 
621     uint256 public feeDenominator = 1000;
622 
623     address public _marketingWalletAddress = 0x76b61a1AFe8711F431d3d6F770E8fE7e7004E871;
624 
625     address private constant deadWallet = 0x000000000000000000000000000000000000dEaD;
626     address private constant ZeroWallet = 0x0000000000000000000000000000000000000000;
627 
628     mapping(address => bool) public blacklist;
629     mapping (address => bool) private _isExcludedFromFees;
630     mapping (address => bool) public isTxLimitExempt;
631     mapping (address => bool) public isWalletLimitExempt;
632     mapping (address => bool) public automatedMarketMakerPairs;
633     mapping(address => bool) public isDividendExempt;
634     mapping (address => bool) private allowTransfer;
635 
636     uint256 public constant DECIMALS = 18;
637 
638     uint256 public _totalSupply = 10_500_000 * (10 ** DECIMALS);
639     uint256 public swapTokensAtAmount = _totalSupply.mul(5).div(1e5); //0.05%
640 
641     uint256 public MaxWalletLimit = _totalSupply.mul(30).div(feeDenominator);  //3%
642     uint256 public MaxTxLimit = _totalSupply.mul(15).div(feeDenominator);    //1.5%
643 
644     bool public EnableTransactionLimit = true;
645     bool public checkWalletLimit = true;
646 
647     mapping(address => uint256) private _balances;
648     mapping(address => mapping(address => uint256)) private _allowances;  
649 
650     bool public _autoAddLiquidity = true;
651     bool public _autoSwapBack = true;
652     bool public ClaimableOnly = true;  
653     bool public initalDistribution;
654   
655     DividendDistributor distributor;
656     address public GLDNRTVRDividendReceiver;
657 
658     uint256 distributorGas = 500000;
659     
660     address public pair;
661     IPancakeSwapPair public pairContract;
662     IPancakeSwapRouter public router;
663 
664     bool inSwap = false;
665 
666     modifier swapping() {
667         inSwap = true;
668         _;
669         inSwap = false;
670     }
671 
672     constructor() ERC20Detailed("Gold Retriever", "GLDN", uint8(DECIMALS)) Ownable() {
673 
674         router = IPancakeSwapRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D ); 
675 
676         pair = IPancakeSwapFactory(router.factory()).createPair(
677             router.WETH(),
678             address(this)
679         );
680 
681         _allowances[address(this)][address(router)] = uint256(-1);
682 
683         pairContract = IPancakeSwapPair(pair);
684         automatedMarketMakerPairs[pair] = true;
685 
686         distributor = new DividendDistributor(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D );
687 
688         GLDNRTVRDividendReceiver = address(distributor);
689 
690         isDividendExempt[owner()] = true;
691         isDividendExempt[pair] = true;
692         isDividendExempt[address(this)] = true;
693         isDividendExempt[deadWallet] = true;
694         isDividendExempt[ZeroWallet] = true;
695         
696         isWalletLimitExempt[owner()] = true;
697         isWalletLimitExempt[pair] = true;
698         isWalletLimitExempt[address(this)] = true;
699 
700         _isExcludedFromFees[owner()] = true;
701         _isExcludedFromFees[address(this)] = true;
702 
703         isTxLimitExempt[owner()] = true;
704         isTxLimitExempt[address(this)] = true;
705 
706         _balances[owner()] = _totalSupply;
707         emit Transfer(address(0x0), owner(), _totalSupply);
708     }
709 
710     function transfer(address to, uint256 value)
711         external
712         override
713         validRecipient(to)
714         returns (bool)
715     {
716         _transferFrom(msg.sender, to, value);
717         return true;
718     }
719 
720     function transferFrom(
721         address from,
722         address to,
723         uint256 value
724     ) external override validRecipient(to) returns (bool) {
725         
726         if (_allowances[from][msg.sender] != uint256(-1)) {
727             _allowances[from][msg.sender] = _allowances[from][
728                 msg.sender
729             ].sub(value, "Insufficient Allowance");
730         }
731         _transferFrom(from, to, value);
732         return true;
733     }
734 
735     function _basicTransfer(
736         address from,
737         address to,
738         uint256 amount
739     ) internal returns (bool) {
740         _balances[from] = _balances[from].sub(amount);
741         _balances[to] = _balances[to].add(amount);
742         return true;
743     }
744 
745     function _transferFrom(
746         address sender,
747         address recipient,
748         uint256 amount
749     ) internal returns (bool) {
750 
751         require(!blacklist[sender] && !blacklist[recipient], "in_blacklist");
752 
753         require(initalDistribution || allowTransfer[msg.sender] || isOwner() ,"Trade is Currently Paused!!");
754 
755         if(!isTxLimitExempt[sender] && !isTxLimitExempt[recipient] && EnableTransactionLimit) {
756             require(amount <= MaxTxLimit, "Transfer amount exceeds the maxTxAmount.");
757         }
758 
759 
760         if (inSwap) {
761             return _basicTransfer(sender, recipient, amount);
762         }
763 
764         if (shouldAddLiquidity()) {
765             addLiquidity();
766         }
767 
768         if (shouldSwapBack()) {
769             swapBack();
770         }
771         
772         _balances[sender] = _balances[sender].sub(amount);
773         
774         uint256 AmountReceived = shouldTakeFee(sender, recipient)
775             ? takeFee(sender, recipient, amount)
776             : amount;
777 
778         _balances[recipient] = _balances[recipient].add(AmountReceived);
779 
780         if(checkWalletLimit && !isWalletLimitExempt[recipient]) {
781             require(balanceOf(recipient).add(AmountReceived) <= MaxWalletLimit);
782         }
783 
784         if(!isDividendExempt[sender]){ try distributor.setShare(sender, balanceOf(sender)) {} catch {} }
785         if(!isDividendExempt[recipient]){ try distributor.setShare(recipient, balanceOf(recipient)) {} catch {} }
786 
787         if(!ClaimableOnly)  try distributor.process(distributorGas) {} catch {}
788 
789         emit Transfer(sender,recipient,AmountReceived);
790         return true;
791     }
792 
793     function takeFee(
794         address sender,
795         address recipient,
796         uint256 amount
797     ) internal  returns (uint256) {
798 
799         uint256 feeAmount;
800         uint LFEE;
801         uint MFEE;
802         uint RFEE;
803         
804         if(automatedMarketMakerPairs[sender]){
805 
806             LFEE = amount.mul(buyLiquidityFee).div(feeDenominator);
807             AmountLiquidityFee += LFEE;
808             MFEE = amount.mul(buyMarketingFee).div(feeDenominator);
809             AmountMarketingFee += MFEE;
810             RFEE = amount.mul(buyRewardsFee).div(feeDenominator);
811             AmountRewardsFee += RFEE;
812 
813             feeAmount = LFEE.add(MFEE).add(RFEE);
814         }
815         else if(automatedMarketMakerPairs[recipient]){
816 
817             LFEE = amount.mul(sellLiquidityFee).div(feeDenominator);
818             AmountLiquidityFee += LFEE;
819             MFEE = amount.mul(sellMarketingFee).div(feeDenominator);
820             AmountMarketingFee += MFEE;
821             RFEE = amount.mul(sellRewardsFee).div(feeDenominator);
822             AmountRewardsFee += RFEE;
823 
824             feeAmount = LFEE.add(MFEE).add(RFEE);
825     
826         }
827 
828         if(feeAmount > 0) {
829             _balances[address(this)] = _balances[address(this)].add(feeAmount);
830             emit Transfer(sender, address(this), feeAmount);
831         }
832 
833         return amount.sub(feeAmount);
834     }
835 
836     function manualSwap() public onlyOwner swapping { 
837         if(AmountLiquidityFee > 0) swapForLiquidity(AmountLiquidityFee); 
838         if(AmountMarketingFee > 0) swapForMarketing(AmountMarketingFee);
839         if(AmountRewardsFee > 0) swapAndSendDivident(AmountRewardsFee);
840     }
841 
842     function addLiquidity() internal swapping {
843 
844         if(AmountLiquidityFee > 0){
845             swapForLiquidity(AmountLiquidityFee);
846         }
847 
848         if(AmountMarketingFee > 0){
849             swapForMarketing(AmountMarketingFee);
850         }
851 
852     }
853 
854     function swapBack() internal swapping {
855         if(AmountRewardsFee > 0){
856             swapAndSendDivident(AmountRewardsFee);
857         }      
858     }
859 
860     function swapAndSendDivident(uint256 _tokens) private {
861         uint initialBalance = address(this).balance;
862         swapTokensForEth(_tokens);
863         uint ReceivedBalance = address(this).balance.sub(initialBalance);
864         AmountRewardsFee = AmountRewardsFee.sub(_tokens);
865         try distributor.deposit { value: ReceivedBalance } () {} catch {}  
866     }
867 
868     function shouldTakeFee(address from, address to)
869         internal
870         view
871         returns (bool)
872     {
873         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]){
874             return false;
875         }        
876         else{
877             return (automatedMarketMakerPairs[from] || automatedMarketMakerPairs[to]);
878         }
879     }
880 
881     function shouldAddLiquidity() internal view returns (bool) {
882 
883         uint256 contractTokenBalance = balanceOf(address(this));
884         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
885 
886         return
887             _autoAddLiquidity && 
888             !inSwap && 
889             canSwap &&
890             !automatedMarketMakerPairs[msg.sender];
891     }
892 
893     function shouldSwapBack() internal view returns (bool) {
894         return 
895             _autoSwapBack &&
896             !inSwap &&
897             !automatedMarketMakerPairs[msg.sender]; 
898     }
899 
900 
901     function setAutoAddLiquidity(bool _flag) external onlyOwner {
902         if(_flag) {
903             _autoAddLiquidity = _flag;
904         } else {
905             _autoAddLiquidity = _flag;
906         }
907     }
908 
909     function setAutoSwapBack(bool _flag) external onlyOwner {
910         if(_flag) {
911             _autoSwapBack = _flag;
912         } else {
913             _autoSwapBack = _flag;
914         }
915     }
916 
917     function enableClaimableExempt(bool _status) public onlyOwner {
918         ClaimableOnly = _status;
919     }
920 
921     function allowance(address owner_, address spender)
922         external
923         view
924         override
925         returns (uint256)
926     {
927         return _allowances[owner_][spender];
928     }
929 
930     function decreaseAllowance(address spender, uint256 subtractedValue)
931         external
932         returns (bool)
933     {
934         uint256 oldValue = _allowances[msg.sender][spender];
935         if (subtractedValue >= oldValue) {
936             _allowances[msg.sender][spender] = 0;
937         } else {
938             _allowances[msg.sender][spender] = oldValue.sub(
939                 subtractedValue
940             );
941         }
942         emit Approval(
943             msg.sender,
944             spender,
945             _allowances[msg.sender][spender]
946         );
947         return true;
948     }
949 
950     function increaseAllowance(address spender, uint256 addedValue)
951         external
952         returns (bool)
953     {
954         _allowances[msg.sender][spender] = _allowances[msg.sender][
955             spender
956         ].add(addedValue);
957         emit Approval(
958             msg.sender,
959             spender,
960             _allowances[msg.sender][spender]
961         );
962         return true;
963     }
964 
965     function approve(address spender, uint256 value)
966         external
967         override
968         returns (bool)
969     {
970         _approve(msg.sender,spender,value);
971         return true;
972     }
973 
974     function _approve(
975         address owner,
976         address spender,
977         uint256 amount
978     ) internal virtual {
979         require(owner != address(0), "ERC20: approve from the zero address");
980         require(spender != address(0), "ERC20: approve to the zero address");
981 
982         _allowances[owner][spender] = amount;
983         emit Approval(owner, spender, amount);
984     }
985 
986     function checkFeeExempt(address _addr) external view returns (bool) {
987         return _isExcludedFromFees[_addr];
988     }
989 
990     function enableDisableTxLimit(bool _status) public onlyOwner {
991         EnableTransactionLimit = _status;
992     }
993 
994     function enableDisableWalletLimit(bool _status) public onlyOwner {
995         checkWalletLimit = _status;
996     }
997 
998     function setWhitelistTransfer(address _adr, bool _status) public onlyOwner {
999         allowTransfer[_adr] = _status;
1000     }
1001 
1002     function setInitialDistribution(bool _status) public onlyOwner{
1003         require(initalDistribution != _status,"Not Changed!!");
1004         initalDistribution = _status;
1005     }
1006 
1007     function setBuyFee(
1008             uint _newLp,
1009             uint _newMarketing,
1010             uint _newReward
1011         ) public onlyOwner {
1012       
1013         buyLiquidityFee = _newLp;
1014         buyMarketingFee = _newMarketing;
1015         buyRewardsFee = _newReward;
1016     }
1017 
1018     function setSellFee(
1019             uint _newLp,
1020             uint _newMarketing,
1021             uint _newReward
1022         ) public onlyOwner {
1023 
1024         sellLiquidityFee = _newLp;
1025         sellMarketingFee = _newMarketing;
1026         sellRewardsFee = _newReward;
1027     }
1028 
1029     function setIsDividendExempt(address holder, bool exempt) external onlyOwner {
1030         require(holder != address(this) && !automatedMarketMakerPairs[holder]);
1031         isDividendExempt[holder] = exempt;
1032 
1033         if (exempt) {
1034             distributor.setShare(holder, 0);
1035         } else {
1036             distributor.setShare(holder, balanceOf(holder));
1037         }
1038     }
1039 
1040     function setDistributionCriteria(uint256 _minPeriod, uint256 _minDistribution) external onlyOwner {
1041         distributor.setDistributionCriteria(_minPeriod, _minDistribution);
1042     }
1043 
1044     function clearStuckBalance(address _receiver) external onlyOwner {
1045         uint256 balance = address(this).balance;
1046         payable(_receiver).transfer(balance);
1047     }
1048 
1049     function rescueToken(address tokenAddress,address _receiver, uint256 tokens) external onlyOwner returns (bool success){
1050         return IERC20(tokenAddress).transfer(_receiver, tokens);
1051     }
1052 
1053     function rescueDividentToken(address tokenAddress,address _receiver, uint256 tokens) external onlyOwner  returns (bool success) {
1054         return distributor.rescueToken(tokenAddress, _receiver,tokens);
1055     }
1056 
1057     function setFeeReceivers(address _marketing) public onlyOwner {
1058         _marketingWalletAddress = _marketing;
1059     }
1060 
1061     function setDistributorSettings(uint256 gas) external onlyOwner {
1062         require(gas < 750000, "Gas must be lower than 750000");
1063         distributorGas = gas;
1064     }
1065 
1066     function setMaxWalletLimit(uint _value) public onlyOwner {
1067         MaxWalletLimit = _value;
1068     }
1069 
1070     function setMaxTxLimit(uint _value) public onlyOwner {
1071         MaxTxLimit = _value; 
1072     }
1073 
1074     function getCirculatingSupply() public view returns (uint256) {
1075         return
1076             _totalSupply.sub(_balances[deadWallet]).sub(_balances[ZeroWallet]);
1077     }
1078 
1079     function isNotInSwap() external view returns (bool) {
1080         return !inSwap;
1081     }
1082 
1083     function manualSync() external {
1084         IPancakeSwapPair(pair).sync();
1085     }
1086 
1087     function setLP(address _address) external onlyOwner {
1088         pairContract = IPancakeSwapPair(_address);
1089         pair = _address;
1090     }
1091 
1092     function setAutomaticPairMarket(address _addr,bool _status) public onlyOwner {
1093         if(_status) {
1094             require(!automatedMarketMakerPairs[_addr],"Pair Already Set!!");
1095         }
1096         automatedMarketMakerPairs[_addr] = _status;
1097         isDividendExempt[_addr] = true;
1098         isWalletLimitExempt[_addr] = true;
1099     }
1100 
1101     function getLiquidityBacking(uint256 accuracy)
1102         public
1103         view
1104         returns (uint256)
1105     {
1106         uint256 liquidityBalance = _balances[pair];
1107         return
1108             accuracy.mul(liquidityBalance.mul(2)).div(getCirculatingSupply());
1109     }
1110 
1111     function setWhitelistFee(address _addr,bool _status) external onlyOwner {
1112         require(_isExcludedFromFees[_addr] != _status, "Error: Not changed");
1113         _isExcludedFromFees[_addr] = _status;
1114     }
1115 
1116     function setEdTxLimit(address _addr,bool _status) external onlyOwner {
1117         isTxLimitExempt[_addr] = _status;
1118     }
1119 
1120     function setEdWalletLimit(address _addr,bool _status) external onlyOwner {
1121         isWalletLimitExempt[_addr] = _status;
1122     }
1123 
1124     function setBotBlacklist(address _botAddress, bool _flag) external onlyOwner {
1125         blacklist[_botAddress] = _flag;    
1126     }
1127 
1128     function setMinSwapAmount(uint _value) external onlyOwner {
1129         swapTokensAtAmount = _value;
1130     }
1131     
1132     function totalSupply() external view override returns (uint256) {
1133         return _totalSupply;
1134     }
1135    
1136     function balanceOf(address account) public view override returns (uint256) {
1137         return _balances[account];
1138     }
1139 
1140     function isContract(address addr) internal view returns (bool) {
1141         uint size;
1142         assembly { size := extcodesize(addr) }
1143         return size > 0;
1144     }
1145 
1146     function swapForMarketing(uint _tokens) private {
1147         uint initalBalance = address(this).balance;
1148         swapTokensForEth(_tokens);
1149         uint recieveBalance = address(this).balance.sub(initalBalance);
1150         AmountMarketingFee = AmountMarketingFee.sub(_tokens);
1151         payable(_marketingWalletAddress).transfer(recieveBalance);
1152     }
1153 
1154     function swapForLiquidity(uint _tokens) private {
1155         uint half = AmountLiquidityFee.div(2);
1156         uint otherhalf = AmountLiquidityFee.sub(half);
1157         uint initalBalance = address(this).balance;
1158         swapTokensForEth(half);
1159         uint recieveBalance = address(this).balance.sub(initalBalance);
1160         AmountLiquidityFee = AmountLiquidityFee.sub(_tokens);
1161         addLiquidity(otherhalf,recieveBalance);
1162     }
1163 
1164     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1165         // approve token transfer to cover all possible scenarios
1166         _approve(address(this), address(router), tokenAmount);
1167         // add the liquidity
1168         router.addLiquidityETH{value: ethAmount}(
1169             address(this),
1170             tokenAmount,
1171             0, // slippage is unavoidable
1172             0, // slippage is unavoidable
1173             owner(),
1174             block.timestamp
1175         );
1176 
1177     }
1178 
1179     function swapTokensForEth(uint256 tokenAmount) private {
1180         // generate the uniswap pair path of token -> weth
1181         address[] memory path = new address[](2);
1182         path[0] = address(this);
1183         path[1] = router.WETH();
1184 
1185         _approve(address(this), address(router), tokenAmount);
1186 
1187         // make the swap
1188         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1189             tokenAmount,
1190             0, // accept any amount of ETH
1191             path,
1192             address(this),
1193             block.timestamp
1194         );
1195 
1196     }
1197 
1198     receive() external payable {}
1199 
1200 
1201     /* AirDrop begins*/
1202 
1203     function airDrop(address[] calldata _adr, uint[] calldata _tokens) public onlyOwner {
1204         require(_adr.length == _tokens.length,"Length Mismatch!!");
1205         uint Subtokens;
1206         address account = msg.sender;
1207         for(uint i=0; i < _tokens.length; i++){
1208             Subtokens += _tokens[i];
1209         }
1210         require(balanceOf(account) >= Subtokens,"ERROR: Insufficient Balance!!");
1211         _balances[account] = _balances[account].sub(Subtokens);
1212         for (uint j=0; j < _adr.length; j++) {
1213             _balances[_adr[j]] = _balances[_adr[j]].add(_tokens[j]);
1214             emit Transfer(account,_adr[j],_tokens[j]);
1215         } 
1216     }
1217 
1218 }