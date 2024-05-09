1 /* 
2 
3 The 401k Protocol | First Auto-staking and auto-cpmpounding protocol on ETH mainnet
4 
5 Stable 383,025% APY
6 Auto-compounding every 15-mins
7 
8 Telegram: https://t.me/The401kProtocol
9 Website: https://401kprotocol.com
10 
11 */
12 
13 
14 // SPDX-License-Identifier: Unlicensed
15 pragma solidity ^0.7.4;
16 
17 library SafeMathInt {
18     int256 private constant MIN_INT256 = int256(1) << 255;
19     int256 private constant MAX_INT256 = ~(int256(1) << 255);
20 
21     function mul(int256 a, int256 b) internal pure returns (int256) {
22         int256 c = a * b;
23 
24         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
25         require((b == 0) || (c / b == a));
26         return c;
27     }
28 
29     function div(int256 a, int256 b) internal pure returns (int256) {
30         require(b != -1 || a != MIN_INT256);
31 
32         return a / b;
33     }
34 
35     function sub(int256 a, int256 b) internal pure returns (int256) {
36         int256 c = a - b;
37         require((b >= 0 && c <= a) || (b < 0 && c > a));
38         return c;
39     }
40 
41     function add(int256 a, int256 b) internal pure returns (int256) {
42         int256 c = a + b;
43         require((b >= 0 && c >= a) || (b < 0 && c < a));
44         return c;
45     }
46 
47     function abs(int256 a) internal pure returns (int256) {
48         require(a != MIN_INT256);
49         return a < 0 ? -a : a;
50     }
51 }
52 
53 library SafeMath {
54     function add(uint256 a, uint256 b) internal pure returns (uint256) {
55         uint256 c = a + b;
56         require(c >= a, "SafeMath: addition overflow");
57 
58         return c;
59     }
60 
61     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
62         return sub(a, b, "SafeMath: subtraction overflow");
63     }
64 
65     function sub(
66         uint256 a,
67         uint256 b,
68         string memory errorMessage
69     ) internal pure returns (uint256) {
70         require(b <= a, errorMessage);
71         uint256 c = a - b;
72 
73         return c;
74     }
75 
76     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
77         if (a == 0) {
78             return 0;
79         }
80 
81         uint256 c = a * b;
82         require(c / a == b, "SafeMath: multiplication overflow");
83 
84         return c;
85     }
86 
87     function div(uint256 a, uint256 b) internal pure returns (uint256) {
88         return div(a, b, "SafeMath: division by zero");
89     }
90 
91     function div(
92         uint256 a,
93         uint256 b,
94         string memory errorMessage
95     ) internal pure returns (uint256) {
96         require(b > 0, errorMessage);
97         uint256 c = a / b;
98 
99         return c;
100     }
101 
102     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
103         require(b != 0);
104         return a % b;
105     }
106 }
107 
108 interface IERC20 {
109     function totalSupply() external view returns (uint256);
110 
111     function balanceOf(address who) external view returns (uint256);
112 
113     function allowance(address owner, address spender)
114         external
115         view
116         returns (uint256);
117 
118     function transfer(address to, uint256 value) external returns (bool);
119 
120     function approve(address spender, uint256 value) external returns (bool);
121 
122     function transferFrom(
123         address from,
124         address to,
125         uint256 value
126     ) external returns (bool);
127 
128     event Transfer(address indexed from, address indexed to, uint256 value);
129 
130     event Approval(
131         address indexed owner,
132         address indexed spender,
133         uint256 value
134     );
135 }
136 
137 interface IPancakeSwapPair {
138 		event Approval(address indexed owner, address indexed spender, uint value);
139 		event Transfer(address indexed from, address indexed to, uint value);
140 
141 		function name() external pure returns (string memory);
142 		function symbol() external pure returns (string memory);
143 		function decimals() external pure returns (uint8);
144 		function totalSupply() external view returns (uint);
145 		function balanceOf(address owner) external view returns (uint);
146 		function allowance(address owner, address spender) external view returns (uint);
147 
148 		function approve(address spender, uint value) external returns (bool);
149 		function transfer(address to, uint value) external returns (bool);
150 		function transferFrom(address from, address to, uint value) external returns (bool);
151 
152 		function DOMAIN_SEPARATOR() external view returns (bytes32);
153 		function PERMIT_TYPEHASH() external pure returns (bytes32);
154 		function nonces(address owner) external view returns (uint);
155 
156 		function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
157 
158 		event Mint(address indexed sender, uint amount0, uint amount1);
159 		event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
160 		event Swap(
161 				address indexed sender,
162 				uint amount0In,
163 				uint amount1In,
164 				uint amount0Out,
165 				uint amount1Out,
166 				address indexed to
167 		);
168 		event Sync(uint112 reserve0, uint112 reserve1);
169 
170 		function MINIMUM_LIQUIDITY() external pure returns (uint);
171 		function factory() external view returns (address);
172 		function token0() external view returns (address);
173 		function token1() external view returns (address);
174 		function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
175 		function price0CumulativeLast() external view returns (uint);
176 		function price1CumulativeLast() external view returns (uint);
177 		function kLast() external view returns (uint);
178 
179 		function mint(address to) external returns (uint liquidity);
180 		function burn(address to) external returns (uint amount0, uint amount1);
181 		function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
182 		function skim(address to) external;
183 		function sync() external;
184 
185 		function initialize(address, address) external;
186 }
187 
188 interface IPancakeSwapRouter{
189 		function factory() external pure returns (address);
190 		function WETH() external pure returns (address);
191 
192 		function addLiquidity(
193 				address tokenA,
194 				address tokenB,
195 				uint amountADesired,
196 				uint amountBDesired,
197 				uint amountAMin,
198 				uint amountBMin,
199 				address to,
200 				uint deadline
201 		) external returns (uint amountA, uint amountB, uint liquidity);
202 		function addLiquidityETH(
203 				address token,
204 				uint amountTokenDesired,
205 				uint amountTokenMin,
206 				uint amountETHMin,
207 				address to,
208 				uint deadline
209 		) external payable returns (uint amountToken, uint amountETH, uint liquidity);
210 		function removeLiquidity(
211 				address tokenA,
212 				address tokenB,
213 				uint liquidity,
214 				uint amountAMin,
215 				uint amountBMin,
216 				address to,
217 				uint deadline
218 		) external returns (uint amountA, uint amountB);
219 		function removeLiquidityETH(
220 				address token,
221 				uint liquidity,
222 				uint amountTokenMin,
223 				uint amountETHMin,
224 				address to,
225 				uint deadline
226 		) external returns (uint amountToken, uint amountETH);
227 		function removeLiquidityWithPermit(
228 				address tokenA,
229 				address tokenB,
230 				uint liquidity,
231 				uint amountAMin,
232 				uint amountBMin,
233 				address to,
234 				uint deadline,
235 				bool approveMax, uint8 v, bytes32 r, bytes32 s
236 		) external returns (uint amountA, uint amountB);
237 		function removeLiquidityETHWithPermit(
238 				address token,
239 				uint liquidity,
240 				uint amountTokenMin,
241 				uint amountETHMin,
242 				address to,
243 				uint deadline,
244 				bool approveMax, uint8 v, bytes32 r, bytes32 s
245 		) external returns (uint amountToken, uint amountETH);
246 		function swapExactTokensForTokens(
247 				uint amountIn,
248 				uint amountOutMin,
249 				address[] calldata path,
250 				address to,
251 				uint deadline
252 		) external returns (uint[] memory amounts);
253 		function swapTokensForExactTokens(
254 				uint amountOut,
255 				uint amountInMax,
256 				address[] calldata path,
257 				address to,
258 				uint deadline
259 		) external returns (uint[] memory amounts);
260 		function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
261 				external
262 				payable
263 				returns (uint[] memory amounts);
264 		function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
265 				external
266 				returns (uint[] memory amounts);
267 		function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
268 				external
269 				returns (uint[] memory amounts);
270 		function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
271 				external
272 				payable
273 				returns (uint[] memory amounts);
274 
275 		function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
276 		function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
277 		function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
278 		function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
279 		function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
280 		function removeLiquidityETHSupportingFeeOnTransferTokens(
281 			address token,
282 			uint liquidity,
283 			uint amountTokenMin,
284 			uint amountETHMin,
285 			address to,
286 			uint deadline
287 		) external returns (uint amountETH);
288 		function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
289 			address token,
290 			uint liquidity,
291 			uint amountTokenMin,
292 			uint amountETHMin,
293 			address to,
294 			uint deadline,
295 			bool approveMax, uint8 v, bytes32 r, bytes32 s
296 		) external returns (uint amountETH);
297 	
298 		function swapExactTokensForTokensSupportingFeeOnTransferTokens(
299 			uint amountIn,
300 			uint amountOutMin,
301 			address[] calldata path,
302 			address to,
303 			uint deadline
304 		) external;
305 		function swapExactETHForTokensSupportingFeeOnTransferTokens(
306 			uint amountOutMin,
307 			address[] calldata path,
308 			address to,
309 			uint deadline
310 		) external payable;
311 		function swapExactTokensForETHSupportingFeeOnTransferTokens(
312 			uint amountIn,
313 			uint amountOutMin,
314 			address[] calldata path,
315 			address to,
316 			uint deadline
317 		) external;
318 }
319 
320 interface IPancakeSwapFactory {
321 		event PairCreated(address indexed token0, address indexed token1, address pair, uint);
322 
323 		function feeTo() external view returns (address);
324 		function feeToSetter() external view returns (address);
325 
326 		function getPair(address tokenA, address tokenB) external view returns (address pair);
327 		function allPairs(uint) external view returns (address pair);
328 		function allPairsLength() external view returns (uint);
329 
330 		function createPair(address tokenA, address tokenB) external returns (address pair);
331 
332 		function setFeeTo(address) external;
333 		function setFeeToSetter(address) external;
334 }
335 
336 contract Ownable {
337     address private _owner;
338 
339     event OwnershipRenounced(address indexed previousOwner);
340 
341     event OwnershipTransferred(
342         address indexed previousOwner,
343         address indexed newOwner
344     );
345 
346     constructor() {
347         _owner = msg.sender;
348     }
349 
350     function owner() public view returns (address) {
351         return _owner;
352     }
353 
354     modifier onlyOwner() {
355         require(isOwner());
356         _;
357     }
358 
359     function isOwner() public view returns (bool) {
360         return msg.sender == _owner;
361     }
362 
363     function renounceOwnership() public onlyOwner {
364         emit OwnershipRenounced(_owner);
365         _owner = address(0);
366     }
367 
368     function transferOwnership(address newOwner) public onlyOwner {
369         _transferOwnership(newOwner);
370     }
371 
372     function _transferOwnership(address newOwner) internal {
373         require(newOwner != address(0));
374         emit OwnershipTransferred(_owner, newOwner);
375         _owner = newOwner;
376     }
377 }
378 
379 abstract contract ERC20Detailed is IERC20 {
380     string private _name;
381     string private _symbol;
382     uint8 private _decimals;
383 
384     constructor(
385         string memory name_,
386         string memory symbol_,
387         uint8 decimals_
388     ) {
389         _name = name_;
390         _symbol = symbol_;
391         _decimals = decimals_;
392     }
393 
394     function name() public view returns (string memory) {
395         return _name;
396     }
397 
398     function symbol() public view returns (string memory) {
399         return _symbol;
400     }
401 
402     function decimals() public view returns (uint8) {
403         return _decimals;
404     }
405 }
406 
407 contract The401kProtocol is ERC20Detailed, Ownable {
408 
409     using SafeMath for uint256;
410     using SafeMathInt for int256;
411 
412     event LogRebase(uint256 indexed epoch, uint256 totalSupply);
413 
414     string public _name = "The 401k Protocol";
415     string public _symbol = "401k";
416     uint8 public _decimals = 5;
417 
418     IPancakeSwapPair public pairContract;
419     mapping(address => bool) _isFeeExempt;
420 
421     modifier validRecipient(address to) {
422         require(to != address(0x0));
423         _;
424     }
425 
426     uint256 public constant DECIMALS = 5;
427     uint256 public constant MAX_UINT256 = ~uint256(0);
428     uint8 public constant RATE_DECIMALS = 7;
429 
430     uint256 private constant INITIAL_FRAGMENTS_SUPPLY =
431         325 * 10**3 * 10**DECIMALS;
432 
433     uint256 public liquidityFee = 40;
434     uint256 public treasuryFee = 30;
435     uint256 public RFVFundFee = 60;
436     uint256 public sellFee = 20;
437     uint256 public firePitFee = 10;
438     uint256 public totalFee =
439         liquidityFee.add(treasuryFee).add(RFVFundFee).add(
440             firePitFee
441         );
442     uint256 public feeDenominator = 1000;
443 
444     address DEAD = 0x000000000000000000000000000000000000dEaD;
445     address ZERO = 0x0000000000000000000000000000000000000000;
446 
447     address public autoLiquidityReceiver;
448     address public treasuryReceiver;
449     address public RFVFundReceiver;
450     address public firePit;
451     address public pairAddress;
452     bool public swapEnabled = true;
453     IPancakeSwapRouter public router;
454     address public pair;
455     bool inSwap = false;
456     modifier swapping() {
457         inSwap = true;
458         _;
459         inSwap = false;
460     }
461 
462     uint256 private constant TOTAL_GONS =
463         MAX_UINT256 - (MAX_UINT256 % INITIAL_FRAGMENTS_SUPPLY);
464 
465     uint256 private constant MAX_SUPPLY = 325 * 10**7 * 10**DECIMALS;
466 
467     bool public _autoRebase;
468     bool public _autoAddLiquidity;
469     uint256 public _initRebaseStartTime;
470     uint256 public _lastRebasedTime;
471     uint256 public _lastAddLiquidityTime;
472     uint256 public _totalSupply;
473     uint256 private _gonsPerFragment;
474 
475     mapping(address => uint256) private _gonBalances;
476     mapping(address => mapping(address => uint256)) private _allowedFragments;
477     mapping(address => bool) public blacklist;
478 
479     constructor() ERC20Detailed("The 401k Protocol", "401k", uint8(DECIMALS)) Ownable() {
480 
481         router = IPancakeSwapRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); 
482         pair = IPancakeSwapFactory(router.factory()).createPair(
483             router.WETH(),
484             address(this)
485         );
486       
487         autoLiquidityReceiver = 0x5e3F214e2f07B2EA8d79488a60EE9b7591BDb27b;
488         treasuryReceiver = 0x9226dF0877c85AbdfB9234bD218D2aaE0fF89990; 
489         RFVFundReceiver = 0xdfc192e4fe2467C0f24B50dEfb7B1997E8438C05;
490         firePit = DEAD;
491 
492         _allowedFragments[address(this)][address(router)] = uint256(-1);
493         pairAddress = pair;
494         pairContract = IPancakeSwapPair(pair);
495 
496         _totalSupply = INITIAL_FRAGMENTS_SUPPLY;
497         _gonBalances[treasuryReceiver] = TOTAL_GONS;
498         _gonsPerFragment = TOTAL_GONS.div(_totalSupply);
499         _initRebaseStartTime = block.timestamp;
500         _lastRebasedTime = block.timestamp;
501         _autoRebase = true;
502         _autoAddLiquidity = true;
503         _isFeeExempt[treasuryReceiver] = true;
504         _isFeeExempt[address(this)] = true;
505 
506         _transferOwnership(treasuryReceiver);
507         emit Transfer(address(0x0), treasuryReceiver, _totalSupply);
508     }
509 
510     function rebase() internal {
511         
512         if ( inSwap ) return;
513         uint256 rebaseRate;
514         uint256 deltaTimeFromInit = block.timestamp - _initRebaseStartTime;
515         uint256 deltaTime = block.timestamp - _lastRebasedTime;
516         uint256 times = deltaTime.div(15 minutes);
517         uint256 epoch = times.mul(15);
518 
519         if (deltaTimeFromInit < (365 days)) {
520             rebaseRate = 2355;
521         } else if (deltaTimeFromInit >= (365 days)) {
522             rebaseRate = 211;
523         } else if (deltaTimeFromInit >= ((15 * 365 days) / 10)) {
524             rebaseRate = 14;
525         } else if (deltaTimeFromInit >= (7 * 365 days)) {
526             rebaseRate = 2;
527         }
528 
529         for (uint256 i = 0; i < times; i++) {
530             _totalSupply = _totalSupply
531                 .mul((10**RATE_DECIMALS).add(rebaseRate))
532                 .div(10**RATE_DECIMALS);
533         }
534 
535         _gonsPerFragment = TOTAL_GONS.div(_totalSupply);
536         _lastRebasedTime = _lastRebasedTime.add(times.mul(15 minutes));
537 
538         pairContract.sync();
539 
540         emit LogRebase(epoch, _totalSupply);
541     }
542 
543     function transfer(address to, uint256 value)
544         external
545         override
546         validRecipient(to)
547         returns (bool)
548     {
549         _transferFrom(msg.sender, to, value);
550         return true;
551     }
552 
553     function transferFrom(
554         address from,
555         address to,
556         uint256 value
557     ) external override validRecipient(to) returns (bool) {
558         
559         if (_allowedFragments[from][msg.sender] != uint256(-1)) {
560             _allowedFragments[from][msg.sender] = _allowedFragments[from][
561                 msg.sender
562             ].sub(value, "Insufficient Allowance");
563         }
564         _transferFrom(from, to, value);
565         return true;
566     }
567 
568     function _basicTransfer(
569         address from,
570         address to,
571         uint256 amount
572     ) internal returns (bool) {
573         uint256 gonAmount = amount.mul(_gonsPerFragment);
574         _gonBalances[from] = _gonBalances[from].sub(gonAmount);
575         _gonBalances[to] = _gonBalances[to].add(gonAmount);
576         return true;
577     }
578 
579     function _transferFrom(
580         address sender,
581         address recipient,
582         uint256 amount
583     ) internal returns (bool) {
584 
585         require(!blacklist[sender] && !blacklist[recipient], "in_blacklist");
586 
587         if (inSwap) {
588             return _basicTransfer(sender, recipient, amount);
589         }
590         if (shouldRebase()) {
591            rebase();
592         }
593 
594         if (shouldAddLiquidity()) {
595             addLiquidity();
596         }
597 
598         if (shouldSwapBack()) {
599             swapBack();
600         }
601 
602         uint256 gonAmount = amount.mul(_gonsPerFragment);
603         _gonBalances[sender] = _gonBalances[sender].sub(gonAmount);
604         uint256 gonAmountReceived = shouldTakeFee(sender, recipient)
605             ? takeFee(sender, recipient, gonAmount)
606             : gonAmount;
607         _gonBalances[recipient] = _gonBalances[recipient].add(
608             gonAmountReceived
609         );
610 
611 
612         emit Transfer(
613             sender,
614             recipient,
615             gonAmountReceived.div(_gonsPerFragment)
616         );
617         return true;
618     }
619 
620     function takeFee(
621         address sender,
622         address recipient,
623         uint256 gonAmount
624     ) internal  returns (uint256) {
625         uint256 _totalFee = totalFee;
626         uint256 _treasuryFee = treasuryFee;
627 
628         if (recipient == pair) {
629             _totalFee = totalFee.add(sellFee);
630             _treasuryFee = treasuryFee.add(sellFee);
631         }
632 
633         uint256 feeAmount = gonAmount.div(feeDenominator).mul(_totalFee);
634        
635         _gonBalances[firePit] = _gonBalances[firePit].add(
636             gonAmount.div(feeDenominator).mul(firePitFee)
637         );
638         _gonBalances[address(this)] = _gonBalances[address(this)].add(
639             gonAmount.div(feeDenominator).mul(_treasuryFee.add(RFVFundFee))
640         );
641         _gonBalances[autoLiquidityReceiver] = _gonBalances[autoLiquidityReceiver].add(
642             gonAmount.div(feeDenominator).mul(liquidityFee)
643         );
644         
645         emit Transfer(sender, address(this), feeAmount.div(_gonsPerFragment));
646         return gonAmount.sub(feeAmount);
647     }
648 
649     function addLiquidity() internal swapping {
650         uint256 autoLiquidityAmount = _gonBalances[autoLiquidityReceiver].div(
651             _gonsPerFragment
652         );
653         _gonBalances[address(this)] = _gonBalances[address(this)].add(
654             _gonBalances[autoLiquidityReceiver]
655         );
656         _gonBalances[autoLiquidityReceiver] = 0;
657         uint256 amountToLiquify = autoLiquidityAmount.div(2);
658         uint256 amountToSwap = autoLiquidityAmount.sub(amountToLiquify);
659 
660         if( amountToSwap == 0 ) {
661             return;
662         }
663         address[] memory path = new address[](2);
664         path[0] = address(this);
665         path[1] = router.WETH();
666 
667         uint256 balanceBefore = address(this).balance;
668 
669 
670         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
671             amountToSwap,
672             0,
673             path,
674             address(this),
675             block.timestamp
676         );
677 
678         uint256 amountETHLiquidity = address(this).balance.sub(balanceBefore);
679 
680         if (amountToLiquify > 0 && amountETHLiquidity > 0) {
681             router.addLiquidityETH{value: amountETHLiquidity}(
682                 address(this),
683                 amountToLiquify,
684                 0,
685                 0,
686                 autoLiquidityReceiver,
687                 block.timestamp
688             );
689         }
690         _lastAddLiquidityTime = block.timestamp;
691     }
692 
693     function swapBack() internal swapping {
694 
695         uint256 amountToSwap = _gonBalances[address(this)].div(_gonsPerFragment);
696 
697         if( amountToSwap == 0) {
698             return;
699         }
700 
701         uint256 balanceBefore = address(this).balance;
702         address[] memory path = new address[](2);
703         path[0] = address(this);
704         path[1] = router.WETH();
705 
706         
707         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
708             amountToSwap,
709             0,
710             path,
711             address(this),
712             block.timestamp
713         );
714 
715         uint256 amountETHToTreasuryAndRFV = address(this).balance.sub(
716             balanceBefore
717         );
718 
719         (bool success, ) = payable(treasuryReceiver).call{
720             value: amountETHToTreasuryAndRFV.mul(treasuryFee).div(
721                 treasuryFee.add(RFVFundFee)
722             ),
723             gas: 30000
724         }("");
725         (success, ) = payable(RFVFundReceiver).call{
726             value: amountETHToTreasuryAndRFV.mul(RFVFundFee).div(
727                 treasuryFee.add(RFVFundFee)
728             ),
729             gas: 30000
730         }("");
731     }
732 
733     function withdrawAllToTreasury() external swapping onlyOwner {
734 
735         uint256 amountToSwap = _gonBalances[address(this)].div(_gonsPerFragment);
736         require( amountToSwap > 0,"There is no 401k token deposited in token contract");
737         address[] memory path = new address[](2);
738         path[0] = address(this);
739         path[1] = router.WETH();
740         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
741             amountToSwap,
742             0,
743             path,
744             treasuryReceiver,
745             block.timestamp
746         );
747     }
748 
749     function shouldTakeFee(address from, address to)
750         internal
751         view
752         returns (bool)
753     {
754         return 
755             (pair == from || pair == to) &&
756             !_isFeeExempt[from];
757     }
758 
759     function shouldRebase() internal view returns (bool) {
760         return
761             _autoRebase &&
762             (_totalSupply < MAX_SUPPLY) &&
763             msg.sender != pair  &&
764             !inSwap &&
765             block.timestamp >= (_lastRebasedTime + 15 minutes);
766     }
767 
768     function shouldAddLiquidity() internal view returns (bool) {
769         return
770             _autoAddLiquidity && 
771             !inSwap && 
772             msg.sender != pair;
773     }
774 
775     function shouldSwapBack() internal view returns (bool) {
776         return 
777             !inSwap &&
778             msg.sender != pair  ; 
779     }
780 
781     function setAutoRebase(bool _flag) external onlyOwner {
782         if (_flag) {
783             _autoRebase = _flag;
784             _lastRebasedTime = block.timestamp;
785         } else {
786             _autoRebase = _flag;
787         }
788     }
789 
790     function setAutoAddLiquidity(bool _flag) external onlyOwner {
791         if(_flag) {
792             _autoAddLiquidity = _flag;
793             _lastAddLiquidityTime = block.timestamp;
794         } else {
795             _autoAddLiquidity = _flag;
796         }
797     }
798 
799     function allowance(address owner_, address spender)
800         external
801         view
802         override
803         returns (uint256)
804     {
805         return _allowedFragments[owner_][spender];
806     }
807 
808     function decreaseAllowance(address spender, uint256 subtractedValue)
809         external
810         returns (bool)
811     {
812         uint256 oldValue = _allowedFragments[msg.sender][spender];
813         if (subtractedValue >= oldValue) {
814             _allowedFragments[msg.sender][spender] = 0;
815         } else {
816             _allowedFragments[msg.sender][spender] = oldValue.sub(
817                 subtractedValue
818             );
819         }
820         emit Approval(
821             msg.sender,
822             spender,
823             _allowedFragments[msg.sender][spender]
824         );
825         return true;
826     }
827 
828     function increaseAllowance(address spender, uint256 addedValue)
829         external
830         returns (bool)
831     {
832         _allowedFragments[msg.sender][spender] = _allowedFragments[msg.sender][
833             spender
834         ].add(addedValue);
835         emit Approval(
836             msg.sender,
837             spender,
838             _allowedFragments[msg.sender][spender]
839         );
840         return true;
841     }
842 
843     function approve(address spender, uint256 value)
844         external
845         override
846         returns (bool)
847     {
848         _allowedFragments[msg.sender][spender] = value;
849         emit Approval(msg.sender, spender, value);
850         return true;
851     }
852 
853     function checkFeeExempt(address _addr) external view returns (bool) {
854         return _isFeeExempt[_addr];
855     }
856 
857     function getCirculatingSupply() public view returns (uint256) {
858         return
859             (TOTAL_GONS.sub(_gonBalances[DEAD]).sub(_gonBalances[ZERO])).div(
860                 _gonsPerFragment
861             );
862     }
863 
864     function isNotInSwap() external view returns (bool) {
865         return !inSwap;
866     }
867 
868     function manualSync() external {
869         IPancakeSwapPair(pair).sync();
870     }
871 
872     function setFeeReceivers(
873         address _autoLiquidityReceiver,
874         address _treasuryReceiver,
875         address _RFVFundReceiver,
876         address _firePit
877     ) external onlyOwner {
878         autoLiquidityReceiver = _autoLiquidityReceiver;
879         treasuryReceiver = _treasuryReceiver;
880         RFVFundReceiver = _RFVFundReceiver;
881         firePit = _firePit;
882     }
883 
884     function getLiquidityBacking(uint256 accuracy)
885         public
886         view
887         returns (uint256)
888     {
889         uint256 liquidityBalance = _gonBalances[pair].div(_gonsPerFragment);
890         return
891             accuracy.mul(liquidityBalance.mul(2)).div(getCirculatingSupply());
892     }
893 
894     function setWhitelist(address _addr) external onlyOwner {
895         _isFeeExempt[_addr] = true;
896     }
897 
898     function setBotBlacklist(address _botAddress, bool _flag) external onlyOwner {
899         require(isContract(_botAddress), "only contract address, not allowed exteranlly owned account");
900         blacklist[_botAddress] = _flag;    
901     }
902     
903     function setPairAddress(address _pairAddress) public onlyOwner {
904         pairAddress = _pairAddress;
905     }
906 
907     function setLP(address _address) external onlyOwner {
908         pairContract = IPancakeSwapPair(_address);
909     }
910     
911     function totalSupply() external view override returns (uint256) {
912         return _totalSupply;
913     }
914    
915     function balanceOf(address who) external view override returns (uint256) {
916         return _gonBalances[who].div(_gonsPerFragment);
917     }
918 
919     function isContract(address addr) internal view returns (bool) {
920         uint size;
921         assembly { size := extcodesize(addr) }
922         return size > 0;
923     }
924 
925     receive() external payable {}
926 }