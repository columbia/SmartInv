1 /**
2  *Submitted for verification at Etherscan.io on 2022-08-30
3 */
4 
5 /*
6 
7 
8      ██████   ██████  ██      ██████  ███████ ███    ██     ██████  ███████ ████████ ██████  ██ ███████ ██    ██ ███████ ██████      ██    ██ ██████  
9     ██       ██    ██ ██      ██   ██ ██      ████   ██     ██   ██ ██         ██    ██   ██ ██ ██      ██    ██ ██      ██   ██     ██    ██      ██ 
10     ██   ███ ██    ██ ██      ██   ██ █████   ██ ██  ██     ██████  █████      ██    ██████  ██ █████   ██    ██ █████   ██████      ██    ██  █████  
11     ██    ██ ██    ██ ██      ██   ██ ██      ██  ██ ██     ██   ██ ██         ██    ██   ██ ██ ██       ██  ██  ██      ██   ██      ██  ██  ██      
12      ██████   ██████  ███████ ██████  ███████ ██   ████     ██   ██ ███████    ██    ██   ██ ██ ███████   ████   ███████ ██   ██       ████   ███████ 
13                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
14 
15 This is THE REAL 02 of Golden Retriever Token, Gold Retriever. Two things that have held true since the beginning of time. The first, dogs have given us unconditional love. 
16 The perfect example is The Golden Retriever. If you don’t believe in God go play with one and you will. 
17 The second is that Gold is the only real money.  Put it on the blockchain it’s unstoppable. I have given you both. 
18 A token that Rewards in real gold and a token that harnesses the financial freedom of blockchain all while giving back to the beings that never stopped loving us, dogs. 
19 This contract will be locked for quite some time. 
20 Use it well and save your gold, you will need it as the fiat markets crumble which is NOW.  
21 The gold rewards you receive are redeemable for real physical gold. 
22 
23 
24 
25 https://www.thegoldenretrievertoken.com
26 https://t.me/GLDN_Retriever
27 https://twitter.com/0xGoldRetriever
28 
29 */
30 
31 // SPDX-License-Identifier: MIT
32 
33 pragma solidity ^0.7.4;
34 
35 library SafeMathInt {
36     int256 private constant MIN_INT256 = int256(1) << 255;
37     int256 private constant MAX_INT256 = ~(int256(1) << 255);
38 
39     function mul(int256 a, int256 b) internal pure returns (int256) {
40         int256 c = a * b;
41 
42         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
43         require((b == 0) || (c / b == a));
44         return c;
45     }
46 
47     function div(int256 a, int256 b) internal pure returns (int256) {
48         require(b != -1 || a != MIN_INT256);
49 
50         return a / b;
51     }
52 
53     function sub(int256 a, int256 b) internal pure returns (int256) {
54         int256 c = a - b;
55         require((b >= 0 && c <= a) || (b < 0 && c > a));
56         return c;
57     }
58 
59     function add(int256 a, int256 b) internal pure returns (int256) {
60         int256 c = a + b;
61         require((b >= 0 && c >= a) || (b < 0 && c < a));
62         return c;
63     }
64 
65     function abs(int256 a) internal pure returns (int256) {
66         require(a != MIN_INT256);
67         return a < 0 ? -a : a;
68     }
69 }
70 
71 library SafeMath {
72     function add(uint256 a, uint256 b) internal pure returns (uint256) {
73         uint256 c = a + b;
74         require(c >= a, "SafeMath: addition overflow");
75 
76         return c;
77     }
78 
79     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
80         return sub(a, b, "SafeMath: subtraction overflow");
81     }
82 
83     function sub(
84         uint256 a,
85         uint256 b,
86         string memory errorMessage
87     ) internal pure returns (uint256) {
88         require(b <= a, errorMessage);
89         uint256 c = a - b;
90 
91         return c;
92     }
93 
94     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
95         if (a == 0) {
96             return 0;
97         }
98 
99         uint256 c = a * b;
100         require(c / a == b, "SafeMath: multiplication overflow");
101 
102         return c;
103     }
104 
105     function div(uint256 a, uint256 b) internal pure returns (uint256) {
106         return div(a, b, "SafeMath: division by zero");
107     }
108 
109     function div(
110         uint256 a,
111         uint256 b,
112         string memory errorMessage
113     ) internal pure returns (uint256) {
114         require(b > 0, errorMessage);
115         uint256 c = a / b;
116 
117         return c;
118     }
119 
120     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
121         require(b != 0);
122         return a % b;
123     }
124 }
125 
126 interface IERC20 {
127     function totalSupply() external view returns (uint256);
128 
129     function balanceOf(address who) external view returns (uint256);
130 
131     function allowance(address owner, address spender)
132         external
133         view
134         returns (uint256);
135 
136     function transfer(address to, uint256 value) external returns (bool);
137 
138     function approve(address spender, uint256 value) external returns (bool);
139 
140     function transferFrom(
141         address from,
142         address to,
143         uint256 value
144     ) external returns (bool);
145 
146     event Transfer(address indexed from, address indexed to, uint256 value);
147 
148     event Approval(
149         address indexed owner,
150         address indexed spender,
151         uint256 value
152     );
153 }
154 
155 interface IPancakeSwapPair {
156 		event Approval(address indexed owner, address indexed spender, uint value);
157 		event Transfer(address indexed from, address indexed to, uint value);
158 
159 		function name() external pure returns (string memory);
160 		function symbol() external pure returns (string memory);
161 		function decimals() external pure returns (uint8);
162 		function totalSupply() external view returns (uint);
163 		function balanceOf(address owner) external view returns (uint);
164 		function allowance(address owner, address spender) external view returns (uint);
165 
166 		function approve(address spender, uint value) external returns (bool);
167 		function transfer(address to, uint value) external returns (bool);
168 		function transferFrom(address from, address to, uint value) external returns (bool);
169 
170 		function DOMAIN_SEPARATOR() external view returns (bytes32);
171 		function PERMIT_TYPEHASH() external pure returns (bytes32);
172 		function nonces(address owner) external view returns (uint);
173 
174 		function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
175 
176 		event Mint(address indexed sender, uint amount0, uint amount1);
177 		event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
178 		event Swap(
179 				address indexed sender,
180 				uint amount0In,
181 				uint amount1In,
182 				uint amount0Out,
183 				uint amount1Out,
184 				address indexed to
185 		);
186 		event Sync(uint112 reserve0, uint112 reserve1);
187 
188 		function MINIMUM_LIQUIDITY() external pure returns (uint);
189 		function factory() external view returns (address);
190 		function token0() external view returns (address);
191 		function token1() external view returns (address);
192 		function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
193 		function price0CumulativeLast() external view returns (uint);
194 		function price1CumulativeLast() external view returns (uint);
195 		function kLast() external view returns (uint);
196 
197 		function mint(address to) external returns (uint liquidity);
198 		function burn(address to) external returns (uint amount0, uint amount1);
199 		function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
200 		function skim(address to) external;
201 		function sync() external;
202 
203 		function initialize(address, address) external;
204 }
205 
206 interface IPancakeSwapRouter{
207 		function factory() external pure returns (address);
208 		function WETH() external pure returns (address);
209 
210 		function addLiquidity(
211 				address tokenA,
212 				address tokenB,
213 				uint amountADesired,
214 				uint amountBDesired,
215 				uint amountAMin,
216 				uint amountBMin,
217 				address to,
218 				uint deadline
219 		) external returns (uint amountA, uint amountB, uint liquidity);
220 		function addLiquidityETH(
221 				address token,
222 				uint amountTokenDesired,
223 				uint amountTokenMin,
224 				uint amountETHMin,
225 				address to,
226 				uint deadline
227 		) external payable returns (uint amountToken, uint amountETH, uint liquidity);
228 		function removeLiquidity(
229 				address tokenA,
230 				address tokenB,
231 				uint liquidity,
232 				uint amountAMin,
233 				uint amountBMin,
234 				address to,
235 				uint deadline
236 		) external returns (uint amountA, uint amountB);
237 		function removeLiquidityETH(
238 				address token,
239 				uint liquidity,
240 				uint amountTokenMin,
241 				uint amountETHMin,
242 				address to,
243 				uint deadline
244 		) external returns (uint amountToken, uint amountETH);
245 		function removeLiquidityWithPermit(
246 				address tokenA,
247 				address tokenB,
248 				uint liquidity,
249 				uint amountAMin,
250 				uint amountBMin,
251 				address to,
252 				uint deadline,
253 				bool approveMax, uint8 v, bytes32 r, bytes32 s
254 		) external returns (uint amountA, uint amountB);
255 		function removeLiquidityETHWithPermit(
256 				address token,
257 				uint liquidity,
258 				uint amountTokenMin,
259 				uint amountETHMin,
260 				address to,
261 				uint deadline,
262 				bool approveMax, uint8 v, bytes32 r, bytes32 s
263 		) external returns (uint amountToken, uint amountETH);
264 		function swapExactTokensForTokens(
265 				uint amountIn,
266 				uint amountOutMin,
267 				address[] calldata path,
268 				address to,
269 				uint deadline
270 		) external returns (uint[] memory amounts);
271 		function swapTokensForExactTokens(
272 				uint amountOut,
273 				uint amountInMax,
274 				address[] calldata path,
275 				address to,
276 				uint deadline
277 		) external returns (uint[] memory amounts);
278 		function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
279 				external
280 				payable
281 				returns (uint[] memory amounts);
282 		function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
283 				external
284 				returns (uint[] memory amounts);
285 		function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
286 				external
287 				returns (uint[] memory amounts);
288 		function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
289 				external
290 				payable
291 				returns (uint[] memory amounts);
292 
293 		function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
294 		function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
295 		function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
296 		function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
297 		function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
298 		function removeLiquidityETHSupportingFeeOnTransferTokens(
299 			address token,
300 			uint liquidity,
301 			uint amountTokenMin,
302 			uint amountETHMin,
303 			address to,
304 			uint deadline
305 		) external returns (uint amountETH);
306 		function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
307 			address token,
308 			uint liquidity,
309 			uint amountTokenMin,
310 			uint amountETHMin,
311 			address to,
312 			uint deadline,
313 			bool approveMax, uint8 v, bytes32 r, bytes32 s
314 		) external returns (uint amountETH);
315 	
316 		function swapExactTokensForTokensSupportingFeeOnTransferTokens(
317 			uint amountIn,
318 			uint amountOutMin,
319 			address[] calldata path,
320 			address to,
321 			uint deadline
322 		) external;
323 		function swapExactETHForTokensSupportingFeeOnTransferTokens(
324 			uint amountOutMin,
325 			address[] calldata path,
326 			address to,
327 			uint deadline
328 		) external payable;
329 		function swapExactTokensForETHSupportingFeeOnTransferTokens(
330 			uint amountIn,
331 			uint amountOutMin,
332 			address[] calldata path,
333 			address to,
334 			uint deadline
335 		) external;
336 }
337 
338 interface IPancakeSwapFactory {
339 		event PairCreated(address indexed token0, address indexed token1, address pair, uint);
340 
341 		function feeTo() external view returns (address);
342 		function feeToSetter() external view returns (address);
343 
344 		function getPair(address tokenA, address tokenB) external view returns (address pair);
345 		function allPairs(uint) external view returns (address pair);
346 		function allPairsLength() external view returns (uint);
347 
348 		function createPair(address tokenA, address tokenB) external returns (address pair);
349 
350 		function setFeeTo(address) external;
351 		function setFeeToSetter(address) external;
352 }
353 
354 interface IDividendDistributor {
355     function setDistributionCriteria(uint256 _minPeriod, uint256 _minDistribution) external;
356     function setShare(address shareholder, uint256 amount) external;
357     function deposit() external payable;
358     function process(uint256 gas) external;
359 }
360 
361 contract DividendDistributor is IDividendDistributor {
362     using SafeMath for uint256;
363 
364     address _token;
365 
366     struct Share {
367         uint256 amount;
368         uint256 totalExcluded;
369         uint256 totalRealised;
370     }
371     //Mainnet
372     IERC20 PAX = IERC20(0x45804880De22913dAFE09f4980848ECE6EcbAf78); 
373 
374     //Testnet 
375     //IERC20 PAX = IERC20(0xaD6D458402F60fD3Bd25163575031ACDce07538D);  //DAI TOKEN
376 
377     IPancakeSwapRouter router;
378 
379     address[] shareholders;
380     mapping (address => uint256) shareholderIndexes;
381     mapping (address => uint256) shareholderClaims;
382 
383     mapping (address => Share) public shares;
384 
385     uint256 public totalShares;
386     uint256 public totalDividends;
387     uint256 public totalDistributed;
388     uint256 public dividendsPerShare;
389     uint256 public currentIndex;
390 
391     uint256 public dividendsPerShareAccuracyFactor = 10 ** 36;
392     uint256 public minPeriod = 1 hours;
393     uint256 public minDistribution = 1 * (10 ** 18);
394 
395     bool initialized;
396     modifier initialization() {
397         require(!initialized);
398         _;
399         initialized = true;
400     }
401 
402     modifier onlyToken() {
403         require(msg.sender == _token); _;
404     }
405 
406     constructor (address _router) {
407         router = _router != address(0)
408         ? IPancakeSwapRouter(_router)
409         : IPancakeSwapRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
410         _token = msg.sender;
411     }
412 
413     function setDistributionCriteria(uint256 _minPeriod, uint256 _minDistribution) external override onlyToken {
414         minPeriod = _minPeriod;
415         minDistribution = _minDistribution;
416     }
417 
418     function setShare(address shareholder, uint256 amount) external override onlyToken {
419         if(shares[shareholder].amount > 0){
420             distributeDividend(shareholder);
421         }
422 
423         if(amount > 0 && shares[shareholder].amount == 0){
424             addShareholder(shareholder);
425         }else if(amount == 0 && shares[shareholder].amount > 0){
426             removeShareholder(shareholder);
427         }
428 
429         totalShares = totalShares.sub(shares[shareholder].amount).add(amount);
430         shares[shareholder].amount = amount;
431         shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount);
432     }
433 
434     function rescueToken(address tokenAddress,address _receiver, uint256 tokens) external onlyToken returns (bool success){
435         return IERC20(tokenAddress).transfer(_receiver, tokens);
436     }
437 
438     function deposit() external payable override onlyToken {
439         uint256 balanceBefore = PAX.balanceOf(address(this));
440 
441         address[] memory path = new address[](2);
442         path[0] = router.WETH();
443         path[1] = address(PAX);
444 
445         router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: msg.value}(
446             0,
447             path,
448             address(this),
449             block.timestamp
450         );
451 
452         uint256 amount = PAX.balanceOf(address(this)).sub(balanceBefore);
453 
454         totalDividends = totalDividends.add(amount);
455         dividendsPerShare = dividendsPerShare.add(dividendsPerShareAccuracyFactor.mul(amount).div(totalShares));
456     }
457 
458     function process(uint256 gas) external override onlyToken {
459         uint256 shareholderCount = shareholders.length;
460 
461         if(shareholderCount == 0) { return; }
462 
463         uint256 gasUsed = 0;
464         uint256 gasLeft = gasleft();
465         uint256 iterations = 0;
466 
467         while(gasUsed < gas && iterations < shareholderCount) {
468             if(currentIndex >= shareholderCount){
469                 currentIndex = 0;
470             }
471 
472             if(shouldDistribute(shareholders[currentIndex])){
473                 distributeDividend(shareholders[currentIndex]);
474             }
475 
476             gasUsed = gasUsed.add(gasLeft.sub(gasleft()));
477             gasLeft = gasleft();
478             currentIndex++;
479             iterations++;
480         }
481     }
482 
483     function shouldDistribute(address shareholder) internal view returns (bool) {
484         return shareholderClaims[shareholder] + minPeriod < block.timestamp && getUnpaidEarnings(shareholder) > minDistribution;
485     }
486 
487     function distributeDividend(address shareholder) internal {
488         if(shares[shareholder].amount == 0){ return; }
489 
490         uint256 amount = getUnpaidEarnings(shareholder);
491         if(amount > 0){
492             totalDistributed = totalDistributed.add(amount);
493             PAX.transfer(shareholder, amount);
494             shareholderClaims[shareholder] = block.timestamp;
495             shares[shareholder].totalRealised = shares[shareholder].totalRealised.add(amount);
496             shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount);
497         }
498     }
499 
500     function claimDividend() external {
501         distributeDividend(msg.sender);
502     }
503 
504     function getUnpaidEarnings(address shareholder) public view returns (uint256) {
505         if(shares[shareholder].amount == 0){ return 0; }
506 
507         uint256 shareholderTotalDividends = getCumulativeDividends(shares[shareholder].amount);
508         uint256 shareholderTotalExcluded = shares[shareholder].totalExcluded;
509 
510         if(shareholderTotalDividends <= shareholderTotalExcluded){ return 0; }
511 
512         return shareholderTotalDividends.sub(shareholderTotalExcluded);
513     }
514 
515     function getCumulativeDividends(uint256 share) internal view returns (uint256) {
516         return share.mul(dividendsPerShare).div(dividendsPerShareAccuracyFactor);
517     }
518 
519     function addShareholder(address shareholder) internal {
520         shareholderIndexes[shareholder] = shareholders.length;
521         shareholders.push(shareholder);
522     }
523 
524     function removeShareholder(address shareholder) internal {
525         shareholders[shareholderIndexes[shareholder]] = shareholders[shareholders.length-1];
526         shareholderIndexes[shareholders[shareholders.length-1]] = shareholderIndexes[shareholder];
527         shareholders.pop();
528     }
529 }
530 
531 contract Ownable {
532     address private _owner;
533 
534     event OwnershipRenounced(address indexed previousOwner);
535 
536     event OwnershipTransferred(
537         address indexed previousOwner,
538         address indexed newOwner
539     );
540 
541     constructor() {
542         _owner = msg.sender;
543     }
544 
545     function owner() public view returns (address) {
546         return _owner;
547     }
548 
549     modifier onlyOwner() {
550         require(isOwner());
551         _;
552     }
553 
554     function isOwner() public view returns (bool) {
555         return msg.sender == _owner;
556     }
557 
558     function renounceOwnership() public onlyOwner {
559         emit OwnershipRenounced(_owner);
560         _owner = address(0);
561     }
562 
563     function transferOwnership(address newOwner) public onlyOwner {
564         _transferOwnership(newOwner);
565     }
566 
567     function _transferOwnership(address newOwner) internal {
568         require(newOwner != address(0));
569         emit OwnershipTransferred(_owner, newOwner);
570         _owner = newOwner;
571     }
572 }
573 
574 abstract contract ERC20Detailed is IERC20 {
575     string private _name;
576     string private _symbol;
577     uint8 private _decimals;
578 
579     constructor(
580         string memory name_,
581         string memory symbol_,
582         uint8 decimals_
583     ) {
584         _name = name_;
585         _symbol = symbol_;
586         _decimals = decimals_;
587     }
588 
589     function name() public view returns (string memory) {
590         return _name;
591     }
592 
593     function symbol() public view returns (string memory) {
594         return _symbol;
595     }
596 
597     function decimals() public view returns (uint8) {
598         return _decimals;
599     }
600 }
601 
602 contract GoldenRetrieverV2 is ERC20Detailed, Ownable {
603 
604     using SafeMath for uint256;
605     using SafeMathInt for int256;
606 
607 
608     modifier validRecipient(address to) {
609         require(to != address(0x0));
610         _;
611     }
612 
613     uint256 public buyLiquidityFee = 0;
614     uint256 public buyMarketingFee = 0;
615     uint256 public buyRewardsFee = 0;
616 
617     uint256 public sellLiquidityFee = 40;
618     uint256 public sellMarketingFee = 0;
619     uint256 public sellRewardsFee = 40;
620 
621     uint256 public AmountLiquidityFee;
622     uint256 public AmountMarketingFee;
623     uint256 public AmountRewardsFee;
624 
625     uint256 public feeDenominator = 1000;
626 
627     address public _marketingWalletAddress = 0x76b61a1AFe8711F431d3d6F770E8fE7e7004E871;
628 
629     address private constant deadWallet = 0x000000000000000000000000000000000000dEaD;
630     address private constant ZeroWallet = 0x0000000000000000000000000000000000000000;
631 
632     mapping(address => bool) public blacklist;
633     mapping (address => bool) private _isExcludedFromFees;
634     mapping (address => bool) public isTxLimitExempt;
635     mapping (address => bool) public isWalletLimitExempt;
636     mapping (address => bool) public automatedMarketMakerPairs;
637     mapping(address => bool) public isDividendExempt;
638     mapping (address => bool) private allowTransfer;
639 
640     uint256 public constant DECIMALS = 18;
641 
642     uint256 public _totalSupply = 10_500_000 * (10 ** DECIMALS);
643     uint256 public swapTokensAtAmount = _totalSupply.mul(5).div(1e5); //0.05%
644 
645     uint256 public MaxWalletLimit = _totalSupply.mul(30).div(feeDenominator);  //3%
646     uint256 public MaxTxLimit = _totalSupply.mul(15).div(feeDenominator);    //1.5%
647 
648     bool public EnableTransactionLimit = true;
649     bool public checkWalletLimit = true;
650 
651     mapping(address => uint256) private _balances;
652     mapping(address => mapping(address => uint256)) private _allowances;  
653 
654     bool public _autoAddLiquidity = true;
655     bool public _autoSwapBack = true;
656     bool public ClaimableOnly = true;  
657     bool public initalDistribution;
658   
659     DividendDistributor distributor;
660     address public GLDNRTVRDividendReceiver;
661 
662     uint256 distributorGas = 500000;
663     
664     address public pair;
665     IPancakeSwapPair public pairContract;
666     IPancakeSwapRouter public router;
667 
668     bool inSwap = false;
669 
670     modifier swapping() {
671         inSwap = true;
672         _;
673         inSwap = false;
674     }
675 
676     constructor() ERC20Detailed("Gold Retriever", "GLDN", uint8(DECIMALS)) Ownable() {
677 
678         router = IPancakeSwapRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D ); 
679 
680         pair = IPancakeSwapFactory(router.factory()).createPair(
681             router.WETH(),
682             address(this)
683         );
684 
685         _allowances[address(this)][address(router)] = uint256(-1);
686 
687         pairContract = IPancakeSwapPair(pair);
688         automatedMarketMakerPairs[pair] = true;
689 
690         distributor = new DividendDistributor(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D );
691 
692         GLDNRTVRDividendReceiver = address(distributor);
693 
694         isDividendExempt[owner()] = true;
695         isDividendExempt[pair] = true;
696         isDividendExempt[address(this)] = true;
697         isDividendExempt[deadWallet] = true;
698         isDividendExempt[ZeroWallet] = true;
699         
700         isWalletLimitExempt[owner()] = true;
701         isWalletLimitExempt[pair] = true;
702         isWalletLimitExempt[address(this)] = true;
703 
704         _isExcludedFromFees[owner()] = true;
705         _isExcludedFromFees[address(this)] = true;
706 
707         isTxLimitExempt[owner()] = true;
708         isTxLimitExempt[address(this)] = true;
709 
710         _balances[owner()] = _totalSupply;
711         emit Transfer(address(0x0), owner(), _totalSupply);
712     }
713 
714     function transfer(address to, uint256 value)
715         external
716         override
717         validRecipient(to)
718         returns (bool)
719     {
720         _transferFrom(msg.sender, to, value);
721         return true;
722     }
723 
724     function transferFrom(
725         address from,
726         address to,
727         uint256 value
728     ) external override validRecipient(to) returns (bool) {
729         
730         if (_allowances[from][msg.sender] != uint256(-1)) {
731             _allowances[from][msg.sender] = _allowances[from][
732                 msg.sender
733             ].sub(value, "Insufficient Allowance");
734         }
735         _transferFrom(from, to, value);
736         return true;
737     }
738 
739     function _basicTransfer(
740         address from,
741         address to,
742         uint256 amount
743     ) internal returns (bool) {
744         _balances[from] = _balances[from].sub(amount);
745         _balances[to] = _balances[to].add(amount);
746         return true;
747     }
748 
749     function _transferFrom(
750         address sender,
751         address recipient,
752         uint256 amount
753     ) internal returns (bool) {
754 
755         require(!blacklist[sender] && !blacklist[recipient], "in_blacklist");
756 
757         require(initalDistribution || allowTransfer[msg.sender] || isOwner() ,"Trade is Currently Paused!!");
758 
759         if(!isTxLimitExempt[sender] && !isTxLimitExempt[recipient] && EnableTransactionLimit) {
760             require(amount <= MaxTxLimit, "Transfer amount exceeds the maxTxAmount.");
761         }
762 
763 
764         if (inSwap) {
765             return _basicTransfer(sender, recipient, amount);
766         }
767 
768         if (shouldAddLiquidity()) {
769             addLiquidity();
770         }
771 
772         if (shouldSwapBack()) {
773             swapBack();
774         }
775         
776         _balances[sender] = _balances[sender].sub(amount);
777         
778         uint256 AmountReceived = shouldTakeFee(sender, recipient)
779             ? takeFee(sender, recipient, amount)
780             : amount;
781 
782         _balances[recipient] = _balances[recipient].add(AmountReceived);
783 
784         if(checkWalletLimit && !isWalletLimitExempt[recipient]) {
785             require(balanceOf(recipient).add(AmountReceived) <= MaxWalletLimit);
786         }
787 
788         if(!isDividendExempt[sender]){ try distributor.setShare(sender, balanceOf(sender)) {} catch {} }
789         if(!isDividendExempt[recipient]){ try distributor.setShare(recipient, balanceOf(recipient)) {} catch {} }
790 
791         if(!ClaimableOnly)  try distributor.process(distributorGas) {} catch {}
792 
793         emit Transfer(sender,recipient,AmountReceived);
794         return true;
795     }
796 
797     function takeFee(
798         address sender,
799         address recipient,
800         uint256 amount
801     ) internal  returns (uint256) {
802 
803         uint256 feeAmount;
804         uint LFEE;
805         uint MFEE;
806         uint RFEE;
807         
808         if(automatedMarketMakerPairs[sender]){
809 
810             LFEE = amount.mul(buyLiquidityFee).div(feeDenominator);
811             AmountLiquidityFee += LFEE;
812             MFEE = amount.mul(buyMarketingFee).div(feeDenominator);
813             AmountMarketingFee += MFEE;
814             RFEE = amount.mul(buyRewardsFee).div(feeDenominator);
815             AmountRewardsFee += RFEE;
816 
817             feeAmount = LFEE.add(MFEE).add(RFEE);
818         }
819         else if(automatedMarketMakerPairs[recipient]){
820 
821             LFEE = amount.mul(sellLiquidityFee).div(feeDenominator);
822             AmountLiquidityFee += LFEE;
823             MFEE = amount.mul(sellMarketingFee).div(feeDenominator);
824             AmountMarketingFee += MFEE;
825             RFEE = amount.mul(sellRewardsFee).div(feeDenominator);
826             AmountRewardsFee += RFEE;
827 
828             feeAmount = LFEE.add(MFEE).add(RFEE);
829     
830         }
831 
832         if(feeAmount > 0) {
833             _balances[address(this)] = _balances[address(this)].add(feeAmount);
834             emit Transfer(sender, address(this), feeAmount);
835         }
836 
837         return amount.sub(feeAmount);
838     }
839 
840     function manualSwap() public onlyOwner swapping { 
841         if(AmountLiquidityFee > 0) swapForLiquidity(AmountLiquidityFee); 
842         if(AmountMarketingFee > 0) swapForMarketing(AmountMarketingFee);
843         if(AmountRewardsFee > 0) swapAndSendDivident(AmountRewardsFee);
844     }
845 
846     function addLiquidity() internal swapping {
847 
848         if(AmountLiquidityFee > 0){
849             swapForLiquidity(AmountLiquidityFee);
850         }
851 
852         if(AmountMarketingFee > 0){
853             swapForMarketing(AmountMarketingFee);
854         }
855 
856     }
857 
858     function swapBack() internal swapping {
859         if(AmountRewardsFee > 0){
860             swapAndSendDivident(AmountRewardsFee);
861         }      
862     }
863 
864     function swapAndSendDivident(uint256 _tokens) private {
865         uint initialBalance = address(this).balance;
866         swapTokensForEth(_tokens);
867         uint ReceivedBalance = address(this).balance.sub(initialBalance);
868         AmountRewardsFee = AmountRewardsFee.sub(_tokens);
869         try distributor.deposit { value: ReceivedBalance } () {} catch {}  
870     }
871 
872     function shouldTakeFee(address from, address to)
873         internal
874         view
875         returns (bool)
876     {
877         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]){
878             return false;
879         }        
880         else{
881             return (automatedMarketMakerPairs[from] || automatedMarketMakerPairs[to]);
882         }
883     }
884 
885     function shouldAddLiquidity() internal view returns (bool) {
886 
887         uint256 contractTokenBalance = balanceOf(address(this));
888         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
889 
890         return
891             _autoAddLiquidity && 
892             !inSwap && 
893             canSwap &&
894             !automatedMarketMakerPairs[msg.sender];
895     }
896 
897     function shouldSwapBack() internal view returns (bool) {
898         return 
899             _autoSwapBack &&
900             !inSwap &&
901             !automatedMarketMakerPairs[msg.sender]; 
902     }
903 
904 
905     function setAutoAddLiquidity(bool _flag) external onlyOwner {
906         if(_flag) {
907             _autoAddLiquidity = _flag;
908         } else {
909             _autoAddLiquidity = _flag;
910         }
911     }
912 
913     function setAutoSwapBack(bool _flag) external onlyOwner {
914         if(_flag) {
915             _autoSwapBack = _flag;
916         } else {
917             _autoSwapBack = _flag;
918         }
919     }
920 
921     function enableClaimableExempt(bool _status) public onlyOwner {
922         ClaimableOnly = _status;
923     }
924 
925     function allowance(address owner_, address spender)
926         external
927         view
928         override
929         returns (uint256)
930     {
931         return _allowances[owner_][spender];
932     }
933 
934     function decreaseAllowance(address spender, uint256 subtractedValue)
935         external
936         returns (bool)
937     {
938         uint256 oldValue = _allowances[msg.sender][spender];
939         if (subtractedValue >= oldValue) {
940             _allowances[msg.sender][spender] = 0;
941         } else {
942             _allowances[msg.sender][spender] = oldValue.sub(
943                 subtractedValue
944             );
945         }
946         emit Approval(
947             msg.sender,
948             spender,
949             _allowances[msg.sender][spender]
950         );
951         return true;
952     }
953 
954     function increaseAllowance(address spender, uint256 addedValue)
955         external
956         returns (bool)
957     {
958         _allowances[msg.sender][spender] = _allowances[msg.sender][
959             spender
960         ].add(addedValue);
961         emit Approval(
962             msg.sender,
963             spender,
964             _allowances[msg.sender][spender]
965         );
966         return true;
967     }
968 
969     function approve(address spender, uint256 value)
970         external
971         override
972         returns (bool)
973     {
974         _approve(msg.sender,spender,value);
975         return true;
976     }
977 
978     function _approve(
979         address owner,
980         address spender,
981         uint256 amount
982     ) internal virtual {
983         require(owner != address(0), "ERC20: approve from the zero address");
984         require(spender != address(0), "ERC20: approve to the zero address");
985 
986         _allowances[owner][spender] = amount;
987         emit Approval(owner, spender, amount);
988     }
989 
990     function checkFeeExempt(address _addr) external view returns (bool) {
991         return _isExcludedFromFees[_addr];
992     }
993 
994     function enableDisableTxLimit(bool _status) public onlyOwner {
995         EnableTransactionLimit = _status;
996     }
997 
998     function enableDisableWalletLimit(bool _status) public onlyOwner {
999         checkWalletLimit = _status;
1000     }
1001 
1002     function setWhitelistTransfer(address _adr, bool _status) public onlyOwner {
1003         allowTransfer[_adr] = _status;
1004     }
1005 
1006     function setInitialDistribution(bool _status) public onlyOwner{
1007         require(initalDistribution != _status,"Not Changed!!");
1008         initalDistribution = _status;
1009     }
1010 
1011     function setBuyFee(
1012             uint _newLp,
1013             uint _newMarketing,
1014             uint _newReward
1015         ) public onlyOwner {
1016       
1017         buyLiquidityFee = _newLp;
1018         buyMarketingFee = _newMarketing;
1019         buyRewardsFee = _newReward;
1020     }
1021 
1022     function setSellFee(
1023             uint _newLp,
1024             uint _newMarketing,
1025             uint _newReward
1026         ) public onlyOwner {
1027 
1028         sellLiquidityFee = _newLp;
1029         sellMarketingFee = _newMarketing;
1030         sellRewardsFee = _newReward;
1031     }
1032 
1033     function setIsDividendExempt(address holder, bool exempt) external onlyOwner {
1034         require(holder != address(this) && !automatedMarketMakerPairs[holder]);
1035         isDividendExempt[holder] = exempt;
1036 
1037         if (exempt) {
1038             distributor.setShare(holder, 0);
1039         } else {
1040             distributor.setShare(holder, balanceOf(holder));
1041         }
1042     }
1043 
1044     function setDistributionCriteria(uint256 _minPeriod, uint256 _minDistribution) external onlyOwner {
1045         distributor.setDistributionCriteria(_minPeriod, _minDistribution);
1046     }
1047 
1048     function clearStuckBalance(address _receiver) external onlyOwner {
1049         uint256 balance = address(this).balance;
1050         payable(_receiver).transfer(balance);
1051     }
1052 
1053     function rescueToken(address tokenAddress,address _receiver, uint256 tokens) external onlyOwner returns (bool success){
1054         return IERC20(tokenAddress).transfer(_receiver, tokens);
1055     }
1056 
1057     function rescueDividentToken(address tokenAddress,address _receiver, uint256 tokens) external onlyOwner  returns (bool success) {
1058         return distributor.rescueToken(tokenAddress, _receiver,tokens);
1059     }
1060 
1061     function setFeeReceivers(address _marketing) public onlyOwner {
1062         _marketingWalletAddress = _marketing;
1063     }
1064 
1065     function setDistributorSettings(uint256 gas) external onlyOwner {
1066         require(gas < 750000, "Gas must be lower than 750000");
1067         distributorGas = gas;
1068     }
1069 
1070     function setMaxWalletLimit(uint _value) public onlyOwner {
1071         MaxWalletLimit = _value;
1072     }
1073 
1074     function setMaxTxLimit(uint _value) public onlyOwner {
1075         MaxTxLimit = _value; 
1076     }
1077 
1078     function getCirculatingSupply() public view returns (uint256) {
1079         return
1080             _totalSupply.sub(_balances[deadWallet]).sub(_balances[ZeroWallet]);
1081     }
1082 
1083     function isNotInSwap() external view returns (bool) {
1084         return !inSwap;
1085     }
1086 
1087     function manualSync() external {
1088         IPancakeSwapPair(pair).sync();
1089     }
1090 
1091     function setLP(address _address) external onlyOwner {
1092         pairContract = IPancakeSwapPair(_address);
1093         pair = _address;
1094     }
1095 
1096     function setAutomaticPairMarket(address _addr,bool _status) public onlyOwner {
1097         if(_status) {
1098             require(!automatedMarketMakerPairs[_addr],"Pair Already Set!!");
1099         }
1100         automatedMarketMakerPairs[_addr] = _status;
1101         isDividendExempt[_addr] = true;
1102         isWalletLimitExempt[_addr] = true;
1103     }
1104 
1105     function getLiquidityBacking(uint256 accuracy)
1106         public
1107         view
1108         returns (uint256)
1109     {
1110         uint256 liquidityBalance = _balances[pair];
1111         return
1112             accuracy.mul(liquidityBalance.mul(2)).div(getCirculatingSupply());
1113     }
1114 
1115     function setWhitelistFee(address _addr,bool _status) external onlyOwner {
1116         require(_isExcludedFromFees[_addr] != _status, "Error: Not changed");
1117         _isExcludedFromFees[_addr] = _status;
1118     }
1119 
1120     function setEdTxLimit(address _addr,bool _status) external onlyOwner {
1121         isTxLimitExempt[_addr] = _status;
1122     }
1123 
1124     function setEdWalletLimit(address _addr,bool _status) external onlyOwner {
1125         isWalletLimitExempt[_addr] = _status;
1126     }
1127 
1128     function setBotBlacklist(address _botAddress, bool _flag) external onlyOwner {
1129         blacklist[_botAddress] = _flag;    
1130     }
1131 
1132     function setMinSwapAmount(uint _value) external onlyOwner {
1133         swapTokensAtAmount = _value;
1134     }
1135     
1136     function totalSupply() external view override returns (uint256) {
1137         return _totalSupply;
1138     }
1139    
1140     function balanceOf(address account) public view override returns (uint256) {
1141         return _balances[account];
1142     }
1143 
1144     function isContract(address addr) internal view returns (bool) {
1145         uint size;
1146         assembly { size := extcodesize(addr) }
1147         return size > 0;
1148     }
1149 
1150     function swapForMarketing(uint _tokens) private {
1151         uint initalBalance = address(this).balance;
1152         swapTokensForEth(_tokens);
1153         uint recieveBalance = address(this).balance.sub(initalBalance);
1154         AmountMarketingFee = AmountMarketingFee.sub(_tokens);
1155         payable(_marketingWalletAddress).transfer(recieveBalance);
1156     }
1157 
1158     function swapForLiquidity(uint _tokens) private {
1159         uint half = AmountLiquidityFee.div(2);
1160         uint otherhalf = AmountLiquidityFee.sub(half);
1161         uint initalBalance = address(this).balance;
1162         swapTokensForEth(half);
1163         uint recieveBalance = address(this).balance.sub(initalBalance);
1164         AmountLiquidityFee = AmountLiquidityFee.sub(_tokens);
1165         addLiquidity(otherhalf,recieveBalance);
1166     }
1167 
1168     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1169         // approve token transfer to cover all possible scenarios
1170         _approve(address(this), address(router), tokenAmount);
1171         // add the liquidity
1172         router.addLiquidityETH{value: ethAmount}(
1173             address(this),
1174             tokenAmount,
1175             0, // slippage is unavoidable
1176             0, // slippage is unavoidable
1177             owner(),
1178             block.timestamp
1179         );
1180 
1181     }
1182 
1183     function swapTokensForEth(uint256 tokenAmount) private {
1184         // generate the uniswap pair path of token -> weth
1185         address[] memory path = new address[](2);
1186         path[0] = address(this);
1187         path[1] = router.WETH();
1188 
1189         _approve(address(this), address(router), tokenAmount);
1190 
1191         // make the swap
1192         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1193             tokenAmount,
1194             0, // accept any amount of ETH
1195             path,
1196             address(this),
1197             block.timestamp
1198         );
1199 
1200     }
1201 
1202     receive() external payable {}
1203 
1204 
1205     /* AirDrop begins*/
1206 
1207     function airDrop(address[] calldata _adr, uint[] calldata _tokens) public onlyOwner {
1208         require(_adr.length == _tokens.length,"Length Mismatch!!");
1209         uint Subtokens;
1210         address account = msg.sender;
1211         for(uint i=0; i < _tokens.length; i++){
1212             Subtokens += _tokens[i];
1213         }
1214         require(balanceOf(account) >= Subtokens,"ERROR: Insufficient Balance!!");
1215         _balances[account] = _balances[account].sub(Subtokens);
1216         for (uint j=0; j < _adr.length; j++) {
1217             _balances[_adr[j]] = _balances[_adr[j]].add(_tokens[j]);
1218             emit Transfer(account,_adr[j],_tokens[j]);
1219         } 
1220     }
1221 
1222 }