1 // File: interfaces/IUniswapV2Factory.sol
2 
3 
4 
5 pragma solidity ^0.7.4;
6 
7 interface IUniswapV2Factory {
8     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
9 
10     function feeTo() external view returns (address);
11     function feeToSetter() external view returns (address);
12 
13     function getPair(address tokenA, address tokenB) external view returns (address pair);
14     function allPairs(uint) external view returns (address pair);
15     function allPairsLength() external view returns (uint);
16 
17     function createPair(address tokenA, address tokenB) external returns (address pair);
18 
19     function setFeeTo(address) external;
20     function setFeeToSetter(address) external;
21 }
22 // File: interfaces/IUniswapV2Router01.sol
23 
24 
25 
26 pragma solidity ^0.7.4;
27 
28 interface IUniswapV2Router01 {
29     function factory() external pure returns (address);
30     function WETH() external pure returns (address);
31 
32     function addLiquidity(
33         address tokenA,
34         address tokenB,
35         uint amountADesired,
36         uint amountBDesired,
37         uint amountAMin,
38         uint amountBMin,
39         address to,
40         uint deadline
41     ) external returns (uint amountA, uint amountB, uint liquidity);
42     function addLiquidityETH(
43         address token,
44         uint amountTokenDesired,
45         uint amountTokenMin,
46         uint amountETHMin,
47         address to,
48         uint deadline
49     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
50     function removeLiquidity(
51         address tokenA,
52         address tokenB,
53         uint liquidity,
54         uint amountAMin,
55         uint amountBMin,
56         address to,
57         uint deadline
58     ) external returns (uint amountA, uint amountB);
59     function removeLiquidityETH(
60         address token,
61         uint liquidity,
62         uint amountTokenMin,
63         uint amountETHMin,
64         address to,
65         uint deadline
66     ) external returns (uint amountToken, uint amountETH);
67     function removeLiquidityWithPermit(
68         address tokenA,
69         address tokenB,
70         uint liquidity,
71         uint amountAMin,
72         uint amountBMin,
73         address to,
74         uint deadline,
75         bool approveMax, uint8 v, bytes32 r, bytes32 s
76     ) external returns (uint amountA, uint amountB);
77     function removeLiquidityETHWithPermit(
78         address token,
79         uint liquidity,
80         uint amountTokenMin,
81         uint amountETHMin,
82         address to,
83         uint deadline,
84         bool approveMax, uint8 v, bytes32 r, bytes32 s
85     ) external returns (uint amountToken, uint amountETH);
86     function swapExactTokensForTokens(
87         uint amountIn,
88         uint amountOutMin,
89         address[] calldata path,
90         address to,
91         uint deadline
92     ) external returns (uint[] memory amounts);
93     function swapTokensForExactTokens(
94         uint amountOut,
95         uint amountInMax,
96         address[] calldata path,
97         address to,
98         uint deadline
99     ) external returns (uint[] memory amounts);
100     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
101         external
102         payable
103         returns (uint[] memory amounts);
104     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
105         external
106         returns (uint[] memory amounts);
107     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
108         external
109         returns (uint[] memory amounts);
110     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
111         external
112         payable
113         returns (uint[] memory amounts);
114 
115     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
116     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
117     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
118     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
119     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
120 }
121 // File: interfaces/IUniswapV2Router02.sol
122 
123 
124 
125 pragma solidity ^0.7.4;
126 
127 
128 interface IUniswapV2Router02 is IUniswapV2Router01 {
129     function removeLiquidityETHSupportingFeeOnTransferTokens(
130         address token,
131         uint liquidity,
132         uint amountTokenMin,
133         uint amountETHMin,
134         address to,
135         uint deadline
136     ) external returns (uint amountETH);
137     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
138         address token,
139         uint liquidity,
140         uint amountTokenMin,
141         uint amountETHMin,
142         address to,
143         uint deadline,
144         bool approveMax, uint8 v, bytes32 r, bytes32 s
145     ) external returns (uint amountETH);
146 
147     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
148         uint amountIn,
149         uint amountOutMin,
150         address[] calldata path,
151         address to,
152         uint deadline
153     ) external;
154     function swapExactETHForTokensSupportingFeeOnTransferTokens(
155         uint amountOutMin,
156         address[] calldata path,
157         address to,
158         uint deadline
159     ) external payable;
160     function swapExactTokensForETHSupportingFeeOnTransferTokens(
161         uint amountIn,
162         uint amountOutMin,
163         address[] calldata path,
164         address to,
165         uint deadline
166     ) external;
167 }
168 // File: interfaces/IUniswapV2Pair.sol
169 
170 
171 
172 pragma solidity ^0.7.4;
173 
174 interface IUniswapV2Pair {
175     event Approval(address indexed owner, address indexed spender, uint value);
176     event Transfer(address indexed from, address indexed to, uint value);
177 
178     function name() external pure returns (string memory);
179     function symbol() external pure returns (string memory);
180     function decimals() external pure returns (uint8);
181     function totalSupply() external view returns (uint);
182     function balanceOf(address owner) external view returns (uint);
183     function allowance(address owner, address spender) external view returns (uint);
184 
185     function approve(address spender, uint value) external returns (bool);
186     function transfer(address to, uint value) external returns (bool);
187     function transferFrom(address from, address to, uint value) external returns (bool);
188 
189     function DOMAIN_SEPARATOR() external view returns (bytes32);
190     function PERMIT_TYPEHASH() external pure returns (bytes32);
191     function nonces(address owner) external view returns (uint);
192 
193     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
194 
195     event Mint(address indexed sender, uint amount0, uint amount1);
196     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
197     event Swap(
198         address indexed sender,
199         uint amount0In,
200         uint amount1In,
201         uint amount0Out,
202         uint amount1Out,
203         address indexed to
204     );
205     event Sync(uint112 reserve0, uint112 reserve1);
206 
207     function MINIMUM_LIQUIDITY() external pure returns (uint);
208     function factory() external view returns (address);
209     function token0() external view returns (address);
210     function token1() external view returns (address);
211     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
212     function price0CumulativeLast() external view returns (uint);
213     function price1CumulativeLast() external view returns (uint);
214     function kLast() external view returns (uint);
215 
216     function mint(address to) external returns (uint liquidity);
217     function burn(address to) external returns (uint amount0, uint amount1);
218     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
219     function skim(address to) external;
220     function sync() external;
221 
222     function initialize(address, address) external;
223 }
224 // File: libraries/SafeMathInt.sol
225 
226 
227 
228 
229 pragma solidity ^0.7.4;
230 
231 library SafeMathInt {
232     int256 private constant MIN_INT256 = int256(1) << 255;
233     int256 private constant MAX_INT256 = ~(int256(1) << 255);
234 
235     function mul(int256 a, int256 b) internal pure returns (int256) {
236         int256 c = a * b;
237 
238         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
239         require((b == 0) || (c / b == a));
240         return c;
241     }
242 
243     function div(int256 a, int256 b) internal pure returns (int256) {
244         require(b != -1 || a != MIN_INT256);
245 
246         return a / b;
247     }
248 
249     function sub(int256 a, int256 b) internal pure returns (int256) {
250         int256 c = a - b;
251         require((b >= 0 && c <= a) || (b < 0 && c > a));
252         return c;
253     }
254 
255     function add(int256 a, int256 b) internal pure returns (int256) {
256         int256 c = a + b;
257         require((b >= 0 && c >= a) || (b < 0 && c < a));
258         return c;
259     }
260 
261     function abs(int256 a) internal pure returns (int256) {
262         require(a != MIN_INT256);
263         return a < 0 ? -a : a;
264     }
265 }
266 // File: libraries/SafeMath.sol
267 
268 
269 
270 pragma solidity ^0.7.4;
271 
272 library SafeMath {
273     function add(uint256 a, uint256 b) internal pure returns (uint256) {
274         uint256 c = a + b;
275         require(c >= a, "SafeMath: addition overflow");
276 
277         return c;
278     }
279 
280     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
281         return sub(a, b, "SafeMath: subtraction overflow");
282     }
283 
284     function sub(
285         uint256 a,
286         uint256 b,
287         string memory errorMessage
288     ) internal pure returns (uint256) {
289         require(b <= a, errorMessage);
290         uint256 c = a - b;
291 
292         return c;
293     }
294 
295     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
296         if (a == 0) {
297             return 0;
298         }
299 
300         uint256 c = a * b;
301         require(c / a == b, "SafeMath: multiplication overflow");
302 
303         return c;
304     }
305 
306     function div(uint256 a, uint256 b) internal pure returns (uint256) {
307         return div(a, b, "SafeMath: division by zero");
308     }
309 
310     function div(
311         uint256 a,
312         uint256 b,
313         string memory errorMessage
314     ) internal pure returns (uint256) {
315         require(b > 0, errorMessage);
316         uint256 c = a / b;
317 
318         return c;
319     }
320 
321     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
322         require(b != 0);
323         return a % b;
324     }
325 }
326 // File: contracts/Ownable.sol
327 
328 
329 
330 pragma solidity ^0.7.4;
331 
332 contract Ownable {
333     address private _owner;
334 
335     event OwnershipRenounced(address indexed previousOwner);
336 
337     event OwnershipTransferred(
338         address indexed previousOwner,
339         address indexed newOwner
340     );
341 
342     constructor() {
343         _owner = msg.sender;
344     }
345 
346     function owner() public view returns (address) {
347         return _owner;
348     }
349 
350     modifier onlyOwner() {
351         require(isOwner(), "Only owner can call this function");
352         _;
353     }
354 
355     function isOwner() public view returns (bool) {
356         return msg.sender == _owner;
357     }
358 
359     function renounceOwnership() public onlyOwner {
360         emit OwnershipRenounced(_owner);
361         _owner = address(0);
362     }
363 
364     function transferOwnership(address newOwner) public onlyOwner {
365         _transferOwnership(newOwner);
366     }
367 
368     function _transferOwnership(address newOwner) internal {
369         require(newOwner != address(0));
370         emit OwnershipTransferred(_owner, newOwner);
371         _owner = newOwner;
372     }
373 }
374 // File: contracts/IERC20.sol
375 
376 
377 
378 pragma solidity ^0.7.4;
379 
380 interface IERC20 {
381     function totalSupply() external view returns (uint256);
382 
383     function balanceOf(address who) external view returns (uint256);
384 
385     function allowance(address owner, address spender)
386         external
387         view
388         returns (uint256);
389 
390     function transfer(address to, uint256 value) external returns (bool);
391 
392     function approve(address spender, uint256 value) external returns (bool);
393 
394     function transferFrom(
395         address from,
396         address to,
397         uint256 value
398     ) external returns (bool);
399 
400     event Transfer(address indexed from, address indexed to, uint256 value);
401 
402     event Approval(
403         address indexed owner,
404         address indexed spender,
405         uint256 value
406     );
407 }
408 // File: contracts/ERC20Detailed.sol
409 
410 
411 
412 pragma solidity ^0.7.4;
413 
414 
415 abstract contract ERC20Detailed is IERC20 {
416     string private _name;
417     string private _symbol;
418     uint8 private _decimals;
419 
420     constructor(
421         string memory name_,
422         string memory symbol_,
423         uint8 decimals_
424     ) {
425         _name = name_;
426         _symbol = symbol_;
427         _decimals = decimals_;
428     }
429 
430     function name() public view returns (string memory) {
431         return _name;
432     }
433 
434     function symbol() public view returns (string memory) {
435         return _symbol;
436     }
437 
438     function decimals() public view returns (uint8) {
439         return _decimals;
440     }
441 }
442 // File: contracts/HinasanInuV5.sol
443 
444 
445 
446 pragma solidity ^0.7.4;
447 
448 
449 
450 
451 
452 
453 
454 
455 
456 contract HinasanInuV5 is ERC20Detailed, Ownable {
457 
458     using SafeMath for uint256;
459     using SafeMathInt for int256;
460 
461     uint8 public _decimals = 5;
462 
463     IUniswapV2Pair public pairContract;
464     mapping(address => bool) _isFeeExempt;
465 
466     modifier validRecipient(address to) {
467         require(to != address(0x0));
468         _;
469     }
470 
471     uint256 public constant DECIMALS = 18;
472 
473     //buy fees
474     uint256 public buyTreasuryFee = 40;
475     uint256 public buyLiquidityFee = 30;
476     uint256 public buyBurnerTokenFee = 20;
477     uint256 public totalBuyFee = buyTreasuryFee.add(buyBurnerTokenFee).add(buyLiquidityFee); // 9%
478 
479     //sell fees
480     uint256 public sellTreasuryFee = 40;
481     uint256 public sellLiquidityFee = 30;
482     uint256 public sellBurnerTokenFee = 20;
483     uint256 public totalSellFee = sellTreasuryFee.add(sellLiquidityFee).add(sellBurnerTokenFee); // 9%
484     uint256 public feeDenominator = 1000;
485 
486     //counters
487     uint256 internal buyTreasuryFeeAmount = 0;
488     uint256 internal buyBurnerTokenFeeAmount = 0;
489     uint256 internal buyLiquidityFeeAmount = 0;
490     uint256 internal sellTreasuryFeeAmount = 0;
491     uint256 internal sellLiquidityFeeAmount = 0;
492     uint256 internal sellBurnerTokenFeeAmount = 0;
493 
494     //burnerToken
495     address[] tokens;
496     address activeToken = DEAD;
497     IERC20 activeTokenContract;
498     mapping (address => uint256) tokensBoughtAndBurned;
499     mapping (address => uint256) ethSpentOnToken;
500     uint256 totalEthSpent = 0;
501 
502     uint256 public startTime;
503     uint256 public sellLimit = 25;
504     uint256 public holdLimit = 25;
505     uint256 public limitDenominator = 10000;
506     uint256 public constant TIME_STEP = 1 days;
507 
508     address DEAD = 0x000000000000000000000000000000000000dEaD;
509     address ZERO = 0x0000000000000000000000000000000000000000;
510 
511     address public treasuryReceiver;
512     address public pairAddress;
513     bool public swapBackEnabled = true;
514     IUniswapV2Router02 public router;
515     address public pair;
516     bool inSwap = false;
517     modifier swapping() {
518         inSwap = true;
519         _;
520         inSwap = false;
521     }
522 
523     uint256 public _totalSupply = 1 * 10**9 * 10**DECIMALS;
524 
525     mapping(address => uint256) private _balances;
526     mapping(address => mapping(address => uint256)) private _allowances;
527     mapping(address => bool) public blacklist;
528     mapping(address => mapping(uint256 => uint256)) public sold;
529     mapping(address => bool) public _excludeFromLimit;
530     mapping(address => bool) public authorized;
531 
532     bool public transferEnabled = false;
533     bool public autoAddLiquidity = true;
534     bool public autoBuyAndBurnToken = true;
535 
536     modifier checkLimit(address from, address to, uint256 value) {
537         if(!_excludeFromLimit[from]) {
538             require(sold[from][getCurrentDay()] + value <= getUserSellLimit(), "Cannot sell or transfer more than limit.");
539         }
540         _;
541         if(!_excludeFromLimit[to]) {
542             require(_balances[to] <= getUserHoldLimit(), "Cannot buy more than limit.");
543         }
544     }
545 
546     constructor(address _treasury, address _router) 
547         ERC20Detailed("Hinasan Inu", "HINU", uint8(DECIMALS)) Ownable() 
548     {
549         router = IUniswapV2Router02(_router); 
550         pair = IUniswapV2Factory(router.factory()).createPair(
551             router.WETH(),
552             address(this)
553         );
554       
555         treasuryReceiver = _treasury;
556         
557         _allowances[address(this)][address(router)] = uint256(-1);
558         pairAddress = pair;
559         pairContract = IUniswapV2Pair(pair);
560 
561         _excludeFromLimit[address(this)] = true;
562         _excludeFromLimit[pair] = true;
563         _excludeFromLimit[treasuryReceiver] = true;
564 
565         _balances[treasuryReceiver] = _totalSupply;
566         _allowances[treasuryReceiver][address(router)] = _totalSupply;
567         _isFeeExempt[treasuryReceiver] = true;
568         _isFeeExempt[address(this)] = true;
569         authorized[address(this)] = true;
570         authorized[treasuryReceiver] = true;
571 
572         //First token active is KIBA ETH
573         activeToken = 0x005D1123878Fc55fbd56b54C73963b234a64af3c;
574         tokens.push(activeToken);
575         activeTokenContract = IERC20(activeToken);
576 
577         _transferOwnership(_treasury);
578         emit Transfer(address(0x0), treasuryReceiver, _totalSupply);
579     }
580 
581     function transfer(address to, uint256 value)
582         external
583         override
584         validRecipient(to)
585         returns (bool)
586     {
587         _transferFrom(msg.sender, to, value);
588         return true;
589     }
590 
591     function transferFrom(
592         address from,
593         address to,
594         uint256 value
595     ) external override validRecipient(to) returns (bool) {
596         
597         if (_allowances[from][msg.sender] != uint256(-1)) {
598             _allowances[from][msg.sender] = _allowances[from][
599                 msg.sender
600             ].sub(value, "Insufficient Allowance");
601         }
602         _transferFrom(from, to, value);
603         return true;
604     }
605 
606     function _basicTransfer(
607         address from,
608         address to,
609         uint256 amount
610     ) internal returns (bool) {
611 
612         _balances[from] = _balances[from].sub(amount);
613         _balances[to] = _balances[to].add(amount);
614 
615         return true;
616     }
617 
618     function _transferFrom(
619         address sender,
620         address recipient,
621         uint256 amount
622     ) 
623         internal 
624         checkLimit(sender, recipient, amount) 
625         returns (bool)
626     {
627 
628         require(!blacklist[sender] && !blacklist[recipient], "in_blacklist");
629         require(transferEnabled || authorized[sender] || authorized[recipient], "Transfer not yet enabled");
630 
631         if (inSwap) {
632             return _basicTransfer(sender, recipient, amount);
633         }
634 
635         if (shouldSwapBack()) {
636             swapBack();
637         }
638 
639         _balances[sender] = _balances[sender].sub(amount);
640         uint256 amountReceived = shouldTakeFee(sender, recipient) ? takeFee(sender, amount) : amount;
641         _balances[recipient] = _balances[recipient].add(amountReceived);
642 
643         emit Transfer(sender, recipient, amountReceived);
644         return true;
645     }
646 
647     function takeFee(address sender, uint256 amount) internal  returns (uint256) {
648         uint256 feeAmount = 0;
649         if(sender==pair){   //buy
650             feeAmount = amount.mul(totalBuyFee).div(feeDenominator);
651             _balances[address(this)] = _balances[address(this)].add(amount.mul(totalBuyFee).div(feeDenominator));
652 
653             buyBurnerTokenFeeAmount = buyBurnerTokenFeeAmount.add(feeAmount.mul(buyBurnerTokenFee).div(totalBuyFee));
654             buyTreasuryFeeAmount = buyTreasuryFeeAmount.add(feeAmount.mul(buyTreasuryFee).div(totalBuyFee));
655             buyLiquidityFeeAmount = buyLiquidityFeeAmount.add(feeAmount.mul(buyLiquidityFee).div(totalBuyFee));
656         } 
657         else {  //sell
658             feeAmount = amount.mul(totalSellFee).div(feeDenominator);
659             _balances[address(this)] = _balances[address(this)].add(amount.mul(totalSellFee).div(feeDenominator));
660 
661             sellBurnerTokenFeeAmount = sellBurnerTokenFeeAmount.add(feeAmount.mul(sellBurnerTokenFee).div(totalSellFee));
662             sellTreasuryFeeAmount = sellTreasuryFeeAmount.add(feeAmount.mul(sellTreasuryFee).div(totalSellFee));
663             sellLiquidityFeeAmount = sellLiquidityFeeAmount.add(feeAmount.mul(sellLiquidityFee).div(totalSellFee));
664         }
665         
666         emit Transfer(sender, address(this), feeAmount);
667         return amount.sub(feeAmount);
668     }
669 
670     function swapBack() internal swapping {
671         uint256 amount = _balances[address(this)];
672 
673         uint256 totalCollectedAmount = 
674             buyBurnerTokenFeeAmount
675             .add(buyTreasuryFeeAmount)
676             .add(buyLiquidityFeeAmount)
677             .add(sellBurnerTokenFeeAmount)
678             .add(sellTreasuryFeeAmount)
679             .add(sellLiquidityFeeAmount);
680 
681         uint256 totalCollectedAmountToSwap = totalCollectedAmount.sub(sellLiquidityFeeAmount.add(buyLiquidityFeeAmount));
682 
683         if( totalCollectedAmount == 0) {
684             return;
685         }
686 
687         uint256 amountToLiq = amount.mul(sellLiquidityFeeAmount.add(buyLiquidityFeeAmount)).div(totalCollectedAmount);
688 
689         //add liquidity
690         if(autoAddLiquidity){
691             addLiquidity(amountToLiq);
692         }
693 
694         //Swap back
695         uint256 amountToSwap = _balances[address(this)];
696         uint256 balanceBefore = address(this).balance;
697         address[] memory path = new address[](2);
698         path[0] = address(this);
699         path[1] = router.WETH();
700 
701         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
702             amountToSwap,
703             0,
704             path,
705             address(this),
706             block.timestamp
707         );
708 
709         uint256 amountETH = address(this).balance.sub(
710             balanceBefore
711         );
712 
713         //send taxed fee to treasury
714         (bool success, ) = payable(treasuryReceiver).call{
715             value: amountETH.mul(buyTreasuryFeeAmount.add(sellTreasuryFeeAmount)).div(totalCollectedAmountToSwap),
716             gas: 30000
717         }("");
718 
719         //buy and burn tokens
720         if(autoBuyAndBurnToken) {
721             _buyAndBurnTokens(amountETH.mul(buyBurnerTokenFeeAmount.add(sellBurnerTokenFeeAmount)).div(totalCollectedAmountToSwap));
722         }
723 
724         //reset counters
725         buyBurnerTokenFeeAmount = 0;
726         buyTreasuryFeeAmount = 0;
727         buyLiquidityFeeAmount = 0;
728         sellBurnerTokenFeeAmount = 0;
729         sellTreasuryFeeAmount = 0;
730         sellLiquidityFeeAmount = 0;
731     }
732 
733     function addLiquidity(uint256 _amount) internal {
734 
735         uint256 amountToLiquify = _amount.div(2);
736         uint256 amountToSwap = _amount.sub(amountToLiquify);
737 
738         if( amountToSwap == 0 ) {
739             return;
740         }
741         address[] memory path = new address[](2);
742         path[0] = address(this);
743         path[1] = router.WETH();
744 
745         uint256 balanceBefore = address(this).balance;
746 
747         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
748             amountToSwap,
749             0,
750             path,
751             address(this),
752             block.timestamp
753         );
754 
755         uint256 amountETHLiquidity = address(this).balance.sub(balanceBefore);
756 
757         if (amountToLiquify > 0&&amountETHLiquidity > 0) {
758             router.addLiquidityETH{value: amountETHLiquidity}(
759                 address(this),
760                 amountToLiquify,
761                 0,
762                 0,
763                 DEAD,
764                 block.timestamp
765             );
766         }
767     }
768 
769     function _buyAndBurnTokens(uint256 amountEth) internal {
770 
771         //set path variable
772         address[] memory path = new address[](2);
773         path[0] = router.WETH();
774         path[1] = activeToken;
775 
776         //buy tokens
777         router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amountEth}(
778             0,
779             path,
780             address(this),
781             block.timestamp
782         );
783 
784         //update info
785         uint256 activeTokenBalance = activeTokenContract.balanceOf(address(this));
786         tokensBoughtAndBurned[activeToken] = tokensBoughtAndBurned[activeToken].add(activeTokenBalance);
787         ethSpentOnToken[activeToken] = ethSpentOnToken[activeToken].add(amountEth);
788         totalEthSpent = totalEthSpent.add(amountEth);
789 
790         //burn tokens
791         activeTokenContract.approve(address(router), activeTokenBalance);
792         activeTokenContract.transfer(DEAD, activeTokenBalance);
793     }
794 
795     function buyAndBurnTokens(uint256 amountEth) external onlyOwner() {
796         require(address(this).balance >= amountEth, "Not enough balance");
797         require(inSwap==false, "Currently in swap");
798         _buyAndBurnTokens(amountEth);
799     }
800 
801     function setToken(address _token) external onlyOwner() {
802         activeToken = _token;
803 
804         if(!findToken(_token)){
805             tokens.push(_token);
806         }
807 
808         activeTokenContract = IERC20(_token);
809     }
810 
811     function findToken(address _token) internal view returns(bool){
812         for(uint256 i=0; i<tokens.length; i++){
813             if(tokens[i]==_token){
814                 return true;
815             }
816         }
817         return false;
818     }
819 
820     function getActiveToken() external view returns (address){
821         return activeToken;
822     }
823 
824     //Testing purposes
825     function readBalance() external view returns(uint256) {
826         return address(this).balance;
827     }
828 
829     //Testing purposes
830     function readTokenBalance(address _token) external view returns (uint256){
831         IERC20 _tokenContract = IERC20(_token);
832         return _tokenContract.balanceOf(address(this));
833     }
834 
835     //Testing purposes
836     function readTokenBalanceDeadAddress(address _token) external view returns (uint256){
837         IERC20 _tokenContract = IERC20(_token);
838         return _tokenContract.balanceOf(DEAD);
839     }
840 
841     function getTokensBoughtAddresses() external view returns(address[] memory){
842         return tokens;
843     }
844 
845     function getTokenAmountBought(address _token) external view returns(uint256){
846         return tokensBoughtAndBurned[_token];
847     }
848 
849     function getEthAmountSpentOnToken(address _token) external view returns(uint256){
850         return ethSpentOnToken[_token];
851     }
852 
853     function getTotalEthSpent() external view returns (uint256){
854         return totalEthSpent;
855     }
856 
857     function getTokensAmountBought() external view returns(uint256[] memory){
858         uint256[] memory _amounts = new uint256[](tokens.length);
859 
860         for(uint256 i=0;i<tokens.length;i++){
861             _amounts[i] = tokensBoughtAndBurned[tokens[i]];
862         }
863 
864         return _amounts;
865     }
866 
867     function getEthAmountsSpentOnToken() external view returns(uint256[] memory){
868         uint256[] memory _amounts = new uint256[](tokens.length);
869 
870         for(uint256 i=0;i<tokens.length;i++){
871             _amounts[i] = ethSpentOnToken[tokens[i]];
872         }
873 
874         return _amounts;
875     }
876 
877     function minZero(uint a, uint b) private pure returns(uint) {
878         if (a > b) {
879            return a - b; 
880         } else {
881            return 0;    
882         }    
883     }
884 
885     function getCurrentDay() internal view returns (uint256) {
886         return minZero(block.timestamp, startTime).div(TIME_STEP);
887     }
888 
889     function getUserHoldLimit() internal view returns (uint256) {
890         return getCirculatingSupply().mul(holdLimit).div(limitDenominator);
891     }
892 
893     function getUserSellLimit() internal view returns (uint256) {
894         return getCirculatingSupply().mul(sellLimit).div(limitDenominator);
895     }
896 
897     function shouldTakeFee(address from, address to) internal view returns (bool){
898         return (pair == from || pair == to) && !_isFeeExempt[from];
899     }
900 
901     function shouldSwapBack() internal view returns (bool) {
902         return 
903             !inSwap &&
904             msg.sender != pair &&
905             transferEnabled &&
906             swapBackEnabled; 
907     }
908 
909     //Can only be activated, not deactivated
910     function setTransferEnabled() external onlyOwner{
911         authorized[pair] = true;
912         transferEnabled = true;
913     }
914 
915     function setSwapBackEnabled(bool flag) external onlyOwner{
916         swapBackEnabled = flag;
917     }
918 
919     function setAuthorized(address[] memory _addr, bool _flag) external onlyOwner() {
920         for(uint256 i=0; i<_addr.length; i++){
921             authorized[_addr[i]] = _flag;
922         }
923     }
924 
925     function setAutoAddMechanisms(bool _autoAddLiq, bool _autoBuyAndBurnToken) external onlyOwner(){
926         autoAddLiquidity = _autoAddLiq;
927         autoBuyAndBurnToken = _autoBuyAndBurnToken;
928     }
929 
930     function allowance(address owner_, address spender)
931         external
932         view
933         override
934         returns (uint256) {
935         return _allowances[owner_][spender];
936     }
937 
938     function decreaseAllowance(address spender, uint256 subtractedValue) external returns (bool) {
939         uint256 oldValue = _allowances[msg.sender][spender];
940         if (subtractedValue >= oldValue) {
941             _allowances[msg.sender][spender] = 0;
942         } else {
943             _allowances[msg.sender][spender] = oldValue.sub(
944                 subtractedValue
945             );
946         }
947         emit Approval(
948             msg.sender,
949             spender,
950             _allowances[msg.sender][spender]
951         );
952         return true;
953     }
954 
955     function increaseAllowance(address spender, uint256 addedValue) external returns (bool) {
956         _allowances[msg.sender][spender] = _allowances[msg.sender][
957             spender
958         ].add(addedValue);
959         emit Approval(
960             msg.sender,
961             spender,
962             _allowances[msg.sender][spender]
963         );
964         return true;
965     }
966 
967     function approve(address spender, uint256 value) external override returns (bool) {
968         _allowances[msg.sender][spender] = value;
969         emit Approval(msg.sender, spender, value);
970         return true;
971     }
972 
973     function checkFeeExempt(address _addr) external view returns (bool) {
974         return _isFeeExempt[_addr];
975     }
976 
977     function getCirculatingSupply() public view returns (uint256) {
978         return
979             (_totalSupply.sub(_balances[DEAD]).sub(_balances[ZERO]));
980     }
981 
982     function getPair() external view returns (address) {
983         return pair;
984     }
985 
986     function isNotInSwap() external view returns (bool) {
987         return !inSwap;
988     }
989 
990     function manualSync() external onlyOwner {
991         IUniswapV2Pair(pair).sync();
992     }
993 
994     function setLimit(uint256 _holdLimit, uint256 _sellLimit) public onlyOwner {
995         require(_holdLimit >= 1 && _holdLimit <= 1000, "Invalid hold limit");
996         require(_sellLimit >= 1 && _sellLimit <= 1000, "Invalid sell limit");
997         holdLimit = _holdLimit;
998         sellLimit = _sellLimit;
999     }
1000 
1001     function setFees (uint256 buytreasf,uint256 buyburnertokenf, uint256 selltreasf, uint256 sellburnertokenf, uint256 sellliqf) external onlyOwner{
1002         buyTreasuryFee = buytreasf;
1003         buyBurnerTokenFee = buyburnertokenf;
1004         totalBuyFee = buyTreasuryFee.add(buyBurnerTokenFee);
1005         sellTreasuryFee = selltreasf;
1006         sellBurnerTokenFee = sellburnertokenf;
1007         sellLiquidityFee = sellliqf;
1008         totalSellFee = sellTreasuryFee.add(sellBurnerTokenFee).add(sellLiquidityFee);
1009         require(totalBuyFee.add(totalSellFee) <= 300, "Total buy+sell fee can't ever be above 30%");
1010     }
1011 
1012     function setWhitelist(address[] memory addr, bool flag) external onlyOwner {
1013         for(uint256 i=0; i<addr.length; i++){
1014             authorized[addr[i]] = flag;
1015             _isFeeExempt[addr[i]] = flag;
1016             _excludeFromLimit[addr[i]] = flag;
1017         }
1018     }
1019 
1020     function setExcludeFromLimit(address _address, bool _bool) public onlyOwner {
1021         _excludeFromLimit[_address] = _bool;
1022     }
1023 
1024     function setBotBlacklist(address _botAddress, bool _flag) external onlyOwner {
1025         require(isContract(_botAddress), "Only contract address, not allowed exteranlly owned account");
1026         blacklist[_botAddress] = _flag;    
1027     }
1028 
1029     function setPairAddress(address _pairAddress) public onlyOwner {
1030         pairAddress = _pairAddress;
1031     }
1032 
1033     function setLP(address _address) external onlyOwner {
1034         pairContract = IUniswapV2Pair(_address);
1035     }
1036     
1037     function totalSupply() external view override returns (uint256) {
1038         return _totalSupply;
1039     }
1040    
1041     function balanceOf(address who) external view override returns (uint256) {
1042         return _balances[who];
1043     }
1044 
1045     function isContract(address addr) internal view returns (bool) {
1046         uint size;
1047         assembly { size := extcodesize(addr) }
1048         return size > 0;
1049     }
1050 
1051     receive() external payable {}
1052 }