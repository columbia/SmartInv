1 // File: solidity-common/contracts/library/SafeMath.sol
2 
3 pragma solidity >=0.5.0 <0.7.0;
4 
5 
6 /**
7  * 算术操作
8  */
9 library SafeMath {
10     uint256 constant WAD = 10 ** 18;
11     uint256 constant RAY = 10 ** 27;
12 
13     function wad() public pure returns (uint256) {
14         return WAD;
15     }
16 
17     function ray() public pure returns (uint256) {
18         return RAY;
19     }
20 
21     function add(uint256 a, uint256 b) internal pure returns (uint256) {
22         uint256 c = a + b;
23         require(c >= a, "SafeMath: addition overflow");
24 
25         return c;
26     }
27 
28     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
29         return sub(a, b, "SafeMath: subtraction overflow");
30     }
31 
32     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
33         require(b <= a, errorMessage);
34         uint256 c = a - b;
35 
36         return c;
37     }
38 
39     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
40         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
41         // benefit is lost if 'b' is also tested.
42         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
43         if (a == 0) {
44             return 0;
45         }
46 
47         uint256 c = a * b;
48         require(c / a == b, "SafeMath: multiplication overflow");
49 
50         return c;
51     }
52 
53     function div(uint256 a, uint256 b) internal pure returns (uint256) {
54         return div(a, b, "SafeMath: division by zero");
55     }
56 
57     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
58         // Solidity only automatically asserts when dividing by 0
59         require(b > 0, errorMessage);
60         uint256 c = a / b;
61         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
62 
63         return c;
64     }
65 
66     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
67         return mod(a, b, "SafeMath: modulo by zero");
68     }
69 
70     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
71         require(b != 0, errorMessage);
72         return a % b;
73     }
74 
75     function min(uint256 a, uint256 b) internal pure returns (uint256) {
76         return a <= b ? a : b;
77     }
78 
79     function max(uint256 a, uint256 b) internal pure returns (uint256) {
80         return a >= b ? a : b;
81     }
82 
83     function sqrt(uint256 a) internal pure returns (uint256 b) {
84         if (a > 3) {
85             b = a;
86             uint256 x = a / 2 + 1;
87             while (x < b) {
88                 b = x;
89                 x = (a / x + x) / 2;
90             }
91         } else if (a != 0) {
92             b = 1;
93         }
94     }
95 
96     function wmul(uint256 a, uint256 b) internal pure returns (uint256) {
97         return mul(a, b) / WAD;
98     }
99 
100     function wmulRound(uint256 a, uint256 b) internal pure returns (uint256) {
101         return add(mul(a, b), WAD / 2) / WAD;
102     }
103 
104     function rmul(uint256 a, uint256 b) internal pure returns (uint256) {
105         return mul(a, b) / RAY;
106     }
107 
108     function rmulRound(uint256 a, uint256 b) internal pure returns (uint256) {
109         return add(mul(a, b), RAY / 2) / RAY;
110     }
111 
112     function wdiv(uint256 a, uint256 b) internal pure returns (uint256) {
113         return div(mul(a, WAD), b);
114     }
115 
116     function wdivRound(uint256 a, uint256 b) internal pure returns (uint256) {
117         return add(mul(a, WAD), b / 2) / b;
118     }
119 
120     function rdiv(uint256 a, uint256 b) internal pure returns (uint256) {
121         return div(mul(a, RAY), b);
122     }
123 
124     function rdivRound(uint256 a, uint256 b) internal pure returns (uint256) {
125         return add(mul(a, RAY), b / 2) / b;
126     }
127 
128     function wpow(uint256 x, uint256 n) internal pure returns (uint256) {
129         uint256 result = WAD;
130         while (n > 0) {
131             if (n % 2 != 0) {
132                 result = wmul(result, x);
133             }
134             x = wmul(x, x);
135             n /= 2;
136         }
137         return result;
138     }
139 
140     function rpow(uint256 x, uint256 n) internal pure returns (uint256) {
141         uint256 result = RAY;
142         while (n > 0) {
143             if (n % 2 != 0) {
144                 result = rmul(result, x);
145             }
146             x = rmul(x, x);
147             n /= 2;
148         }
149         return result;
150     }
151 }
152 
153 // File: solidity-common/contracts/interface/IERC20.sol
154 
155 pragma solidity >=0.5.0 <0.7.0;
156 
157 
158 /**
159  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
160  */
161 interface IERC20 {
162     /**
163     * 可选方法
164     */
165     function name() external view returns (string memory);
166     function symbol() external view returns (string memory);
167     function decimals() external view returns (uint8);
168 
169     /**
170      * 必须方法
171      */
172     function totalSupply() external view returns (uint256);
173     function balanceOf(address account) external view returns (uint256);
174     function transfer(address recipient, uint256 amount) external returns (bool);
175     function allowance(address owner, address spender) external view returns (uint256);
176     function approve(address spender, uint256 amount) external returns (bool);
177     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
178 
179     /**
180      * 事件类型
181      */
182     event Transfer(address indexed from, address indexed to, uint256 value);
183     event Approval(address indexed owner, address indexed spender, uint256 value);
184 }
185 
186 // File: contracts/library/TransferHelper.sol
187 
188 pragma solidity >=0.5.0 <0.7.0;
189 
190 
191 library TransferHelper {
192     function safeApprove(address token, address to, uint256 value) internal {
193         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
194         require(success && (data.length == 0 || abi.decode(data, (bool))), "TransferHelper: APPROVE_FAILED");
195     }
196 
197     function safeTransfer(address token, address to, uint256 value) internal {
198         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
199         require(success && (data.length == 0 || abi.decode(data, (bool))), "TransferHelper: TRANSFER_FAILED");
200     }
201 
202     function safeTransferFrom(address token, address from, address to, uint256 value) internal {
203         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
204         require(success && (data.length == 0 || abi.decode(data, (bool))), "TransferHelper: TRANSFER_FROM_FAILED");
205     }
206 
207     function safeTransferETH(address to, uint256 value) internal {
208         (bool success,) = to.call.value(value)(new bytes(0));
209         require(success, "TransferHelper: ETH_TRANSFER_FAILED");
210     }
211 
212 }
213 
214 // File: contracts/interface/IBtswapETH.sol
215 
216 pragma solidity >=0.5.0 <0.7.0;
217 
218 
219 interface IBtswapETH {
220     function deposit() external payable;
221 
222     function transfer(address to, uint256 value) external returns (bool);
223 
224     function withdraw(uint256) external;
225 
226 }
227 
228 // File: contracts/interface/IBtswapFactory.sol
229 
230 pragma solidity >=0.5.0 <0.7.0;
231 
232 
233 interface IBtswapFactory {
234     function FEE_RATE_DENOMINATOR() external view returns (uint256);
235 
236     function feeTo() external view returns (address);
237 
238     function feeToSetter() external view returns (address);
239 
240     function feeRateNumerator() external view returns (uint256);
241 
242     function initCodeHash() external view returns (bytes32);
243 
244     function getPair(address tokenA, address tokenB) external view returns (address pair);
245 
246     function allPairs(uint256) external view returns (address pair);
247 
248     function allPairsLength() external view returns (uint256);
249 
250     function createPair(address tokenA, address tokenB) external returns (address pair);
251 
252     function setRouter(address) external;
253 
254     function setFeeTo(address) external;
255 
256     function setFeeToSetter(address) external;
257 
258     function setFeeRateNumerator(uint256) external;
259 
260     function setInitCodeHash(bytes32) external;
261 
262     function sortTokens(address tokenA, address tokenB) external pure returns (address token0, address token1);
263 
264     function pairFor(address factory, address tokenA, address tokenB) external view returns (address pair);
265 
266     function getReserves(address factory, address tokenA, address tokenB) external view returns (uint256 reserveA, uint256 reserveB);
267 
268     function quote(uint256 amountA, uint256 reserveA, uint256 reserveB) external pure returns (uint256 amountB);
269 
270     function getAmountOut(uint256 amountIn, uint256 reserveIn, uint256 reserveOut) external view returns (uint256 amountOut);
271 
272     function getAmountIn(uint256 amountOut, uint256 reserveIn, uint256 reserveOut) external view returns (uint256 amountIn);
273 
274     function getAmountsOut(address factory, uint256 amountIn, address[] calldata path) external view returns (uint256[] memory amounts);
275 
276     function getAmountsIn(address factory, uint256 amountOut, address[] calldata path) external view returns (uint256[] memory amounts);
277 
278 
279     event PairCreated(address indexed token0, address indexed token1, address pair, uint256);
280 
281 }
282 
283 // File: contracts/interface/IBtswapPairToken.sol
284 
285 pragma solidity >=0.5.0 <0.7.0;
286 
287 
288 interface IBtswapPairToken {
289     function name() external pure returns (string memory);
290 
291     function symbol() external pure returns (string memory);
292 
293     function decimals() external pure returns (uint8);
294 
295     function totalSupply() external view returns (uint256);
296 
297     function balanceOf(address owner) external view returns (uint256);
298 
299     function allowance(address owner, address spender) external view returns (uint256);
300 
301     function approve(address spender, uint256 value) external returns (bool);
302 
303     function transfer(address to, uint256 value) external returns (bool);
304 
305     function transferFrom(address from, address to, uint256 value) external returns (bool);
306 
307     function DOMAIN_SEPARATOR() external view returns (bytes32);
308 
309     function PERMIT_TYPEHASH() external pure returns (bytes32);
310 
311     function nonces(address owner) external view returns (uint256);
312 
313     function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external;
314 
315     function MINIMUM_LIQUIDITY() external pure returns (uint256);
316 
317     function router() external view returns (address);
318 
319     function factory() external view returns (address);
320 
321     function token0() external view returns (address);
322 
323     function token1() external view returns (address);
324 
325     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
326 
327     function price0CumulativeLast() external view returns (uint256);
328 
329     function price1CumulativeLast() external view returns (uint256);
330 
331     function kLast() external view returns (uint256);
332 
333     function mint(address to) external returns (uint256 liquidity);
334 
335     function burn(address to) external returns (uint256 amount0, uint256 amount1);
336 
337     function swap(uint256 amount0Out, uint256 amount1Out, address to, bytes calldata data) external;
338 
339     function skim(address to) external;
340 
341     function sync() external;
342 
343     function initialize(address, address, address) external;
344 
345     function price(address token) external view returns (uint256);
346 
347 
348     event Approval(address indexed owner, address indexed spender, uint256 value);
349     event Transfer(address indexed from, address indexed to, uint256 value);
350     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
351     event Burn(address indexed sender, uint256 amount0, uint256 amount1, address indexed to);
352     event Swap(address indexed sender, uint256 amount0In, uint256 amount1In, uint256 amount0Out, uint256 amount1Out, address indexed to);
353     event Sync(uint112 reserve0, uint112 reserve1);
354 
355 }
356 
357 // File: contracts/interface/IBtswapRouter02.sol
358 
359 pragma solidity >=0.5.0 <0.7.0;
360 
361 
362 interface IBtswapRouter02 {
363     function factory() external pure returns (address);
364 
365     function WETH() external pure returns (address);
366 
367     function BT() external pure returns (address);
368 
369     function addLiquidity(address tokenA, address tokenB, uint256 amountADesired, uint256 amountBDesired, uint256 amountAMin, uint256 amountBMin, address to, uint256 deadline) external returns (uint256 amountA, uint256 amountB, uint256 liquidity);
370 
371     function addLiquidityETH(address token, uint256 amountTokenDesired, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline) external payable returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
372 
373     function removeLiquidity(address tokenA, address tokenB, uint256 liquidity, uint256 amountAMin, uint256 amountBMin, address to, uint256 deadline) external returns (uint256 amountA, uint256 amountB);
374 
375     function removeLiquidityETH(address token, uint256 liquidity, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline) external returns (uint256 amountToken, uint256 amountETH);
376 
377     function removeLiquidityWithPermit(address tokenA, address tokenB, uint256 liquidity, uint256 amountAMin, uint256 amountBMin, address to, uint256 deadline, bool approveMax, uint8 v, bytes32 r, bytes32 s) external returns (uint256 amountA, uint256 amountB);
378 
379     function removeLiquidityETHWithPermit(address token, uint256 liquidity, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline, bool approveMax, uint8 v, bytes32 r, bytes32 s) external returns (uint256 amountToken, uint256 amountETH);
380 
381     function swapExactTokensForTokens(uint256 amountIn, uint256 amountOutMin, address[] calldata path, address to, uint256 deadline) external returns (uint256[] memory amounts);
382 
383     function swapTokensForExactTokens(uint256 amountOut, uint256 amountInMax, address[] calldata path, address to, uint256 deadline) external returns (uint256[] memory amounts);
384 
385     function swapExactETHForTokens(uint256 amountOutMin, address[] calldata path, address to, uint256 deadline) external payable returns (uint256[] memory amounts);
386 
387     function swapTokensForExactETH(uint256 amountOut, uint256 amountInMax, address[] calldata path, address to, uint256 deadline) external returns (uint256[] memory amounts);
388 
389     function swapExactTokensForETH(uint256 amountIn, uint256 amountOutMin, address[] calldata path, address to, uint256 deadline) external returns (uint256[] memory amounts);
390 
391     function swapETHForExactTokens(uint256 amountOut, address[] calldata path, address to, uint256 deadline) external payable returns (uint256[] memory amounts);
392 
393     function quote(uint256 amountA, uint256 reserveA, uint256 reserveB) external view returns (uint256 amountB);
394 
395     function getAmountOut(uint256 amountIn, uint256 reserveIn, uint256 reserveOut) external view returns (uint256 amountOut);
396 
397     function getAmountIn(uint256 amountOut, uint256 reserveIn, uint256 reserveOut) external view returns (uint256 amountIn);
398 
399     function getAmountsOut(uint256 amountIn, address[] calldata path) external view returns (uint256[] memory amounts);
400 
401     function getAmountsIn(uint256 amountOut, address[] calldata path) external view returns (uint256[] memory amounts);
402 
403     function removeLiquidityETHSupportingFeeOnTransferTokens(address token, uint256 liquidity, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline) external returns (uint256 amountETH);
404 
405     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(address token, uint256 liquidity, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline, bool approveMax, uint8 v, bytes32 r, bytes32 s) external returns (uint256 amountETH);
406 
407     function swapExactTokensForTokensSupportingFeeOnTransferTokens(uint256 amountIn, uint256 amountOutMin, address[] calldata path, address to, uint256 deadline) external;
408 
409     function swapExactETHForTokensSupportingFeeOnTransferTokens(uint256 amountOutMin, address[] calldata path, address to, uint256 deadline) external payable;
410 
411     function swapExactTokensForETHSupportingFeeOnTransferTokens(uint256 amountIn, uint256 amountOutMin, address[] calldata path, address to, uint256 deadline) external;
412 
413     function weth(address token) external view returns (uint256);
414 
415     function onTransfer(address sender, address recipient) external returns (bool);
416 
417 }
418 
419 // File: contracts/interface/IBtswapToken.sol
420 
421 pragma solidity >=0.5.0 <0.7.0;
422 
423 
424 interface IBtswapToken {
425     function swap(address account, address input, uint256 amount, address output) external returns (bool);
426 
427     function liquidity(address account, address pair) external returns (bool);
428 
429 }
430 
431 // File: contracts/interface/IBtswapWhitelistedRole.sol
432 
433 pragma solidity >=0.5.0 <0.7.0;
434 
435 
436 interface IBtswapWhitelistedRole {
437     function getWhitelistedsLength() external view returns (uint256);
438 
439     function isWhitelisted(address) external view returns (bool);
440 
441     function whitelisteds(uint256) external view returns (address);
442 
443 }
444 
445 // File: contracts/biz/BtswapRouter.sol
446 
447 pragma solidity >=0.5.0 <0.7.0;
448 
449 
450 
451 
452 
453 
454 
455 
456 
457 
458 
459 contract BtswapRouter is IBtswapRouter02 {
460     using SafeMath for uint256;
461 
462     address public factory;
463     address public WETH;
464     address public BT;
465 
466     constructor(address _factory, address _WETH, address _BT) public {
467         factory = _factory;
468         WETH = _WETH;
469         BT = _BT;
470     }
471 
472     function() external payable {
473         // only accept ETH via fallback from the WETH contract
474         assert(msg.sender == WETH);
475     }
476 
477     function pairFor(address tokenA, address tokenB) public view returns (address pair){
478         pair = IBtswapFactory(factory).pairFor(factory, tokenA, tokenB);
479     }
480 
481     // **** ADD LIQUIDITY ****
482     function _addLiquidity(
483         address tokenA,
484         address tokenB,
485         uint256 amountADesired,
486         uint256 amountBDesired,
487         uint256 amountAMin,
488         uint256 amountBMin
489     ) internal returns (uint256 amountA, uint256 amountB) {
490         // create the pair if it doesn"t exist yet
491         if (IBtswapFactory(factory).getPair(tokenA, tokenB) == address(0)) {
492             IBtswapFactory(factory).createPair(tokenA, tokenB);
493         }
494         (uint256 reserveA, uint256 reserveB) = IBtswapFactory(factory).getReserves(factory, tokenA, tokenB);
495         if (reserveA == 0 && reserveB == 0) {
496             (amountA, amountB) = (amountADesired, amountBDesired);
497         } else {
498             uint256 amountBOptimal = IBtswapFactory(factory).quote(amountADesired, reserveA, reserveB);
499             if (amountBOptimal <= amountBDesired) {
500                 require(amountBOptimal >= amountBMin, "BtswapRouter: INSUFFICIENT_B_AMOUNT");
501                 (amountA, amountB) = (amountADesired, amountBOptimal);
502             } else {
503                 uint256 amountAOptimal = IBtswapFactory(factory).quote(amountBDesired, reserveB, reserveA);
504                 assert(amountAOptimal <= amountADesired);
505                 require(amountAOptimal >= amountAMin, "BtswapRouter: INSUFFICIENT_A_AMOUNT");
506                 (amountA, amountB) = (amountAOptimal, amountBDesired);
507             }
508         }
509     }
510 
511     function addLiquidity(
512         address tokenA,
513         address tokenB,
514         uint256 amountADesired,
515         uint256 amountBDesired,
516         uint256 amountAMin,
517         uint256 amountBMin,
518         address to,
519         uint256 deadline
520     ) external ensure(deadline) returns (uint256 amountA, uint256 amountB, uint256 liquidity) {
521         (amountA, amountB) = _addLiquidity(tokenA, tokenB, amountADesired, amountBDesired, amountAMin, amountBMin);
522         address pair = pairFor(tokenA, tokenB);
523         TransferHelper.safeTransferFrom(tokenA, msg.sender, pair, amountA);
524         TransferHelper.safeTransferFrom(tokenB, msg.sender, pair, amountB);
525         liquidity = IBtswapPairToken(pair).mint(to);
526         IBtswapToken(BT).liquidity(msg.sender, pair);
527     }
528 
529     function addLiquidityETH(
530         address token,
531         uint256 amountTokenDesired,
532         uint256 amountTokenMin,
533         uint256 amountETHMin,
534         address to,
535         uint256 deadline
536     ) external payable ensure(deadline) returns (uint256 amountToken, uint256 amountETH, uint256 liquidity) {
537         (amountToken, amountETH) = _addLiquidity(
538             token,
539             WETH,
540             amountTokenDesired,
541             msg.value,
542             amountTokenMin,
543             amountETHMin
544         );
545         address pair = pairFor(token, WETH);
546         TransferHelper.safeTransferFrom(token, msg.sender, pair, amountToken);
547         IBtswapETH(WETH).deposit.value(amountETH)();
548         assert(IBtswapETH(WETH).transfer(pair, amountETH));
549         liquidity = IBtswapPairToken(pair).mint(to);
550         IBtswapToken(BT).liquidity(msg.sender, pair);
551         // refund dust eth, if any
552         if (msg.value > amountETH) TransferHelper.safeTransferETH(msg.sender, msg.value - amountETH);
553     }
554 
555     // **** REMOVE LIQUIDITY ****
556     function removeLiquidity(
557         address tokenA,
558         address tokenB,
559         uint256 liquidity,
560         uint256 amountAMin,
561         uint256 amountBMin,
562         address to,
563         uint256 deadline
564     ) public ensure(deadline) returns (uint256 amountA, uint256 amountB) {
565         address pair = pairFor(tokenA, tokenB);
566         // send liquidity to pair
567         IBtswapPairToken(pair).transferFrom(msg.sender, pair, liquidity);
568         (uint256 amount0, uint256 amount1) = IBtswapPairToken(pair).burn(to);
569         IBtswapToken(BT).liquidity(msg.sender, pair);
570         (address token0,) = IBtswapFactory(factory).sortTokens(tokenA, tokenB);
571         (amountA, amountB) = tokenA == token0 ? (amount0, amount1) : (amount1, amount0);
572         require(amountA >= amountAMin, "BtswapRouter: INSUFFICIENT_A_AMOUNT");
573         require(amountB >= amountBMin, "BtswapRouter: INSUFFICIENT_B_AMOUNT");
574     }
575 
576     function removeLiquidityETH(
577         address token,
578         uint256 liquidity,
579         uint256 amountTokenMin,
580         uint256 amountETHMin,
581         address to,
582         uint256 deadline
583     ) public ensure(deadline) returns (uint256 amountToken, uint256 amountETH) {
584         (amountToken, amountETH) = removeLiquidity(
585             token,
586             WETH,
587             liquidity,
588             amountTokenMin,
589             amountETHMin,
590             address(this),
591             deadline
592         );
593         TransferHelper.safeTransfer(token, to, amountToken);
594         IBtswapETH(WETH).withdraw(amountETH);
595         TransferHelper.safeTransferETH(to, amountETH);
596     }
597 
598     function removeLiquidityWithPermit(
599         address tokenA,
600         address tokenB,
601         uint256 liquidity,
602         uint256 amountAMin,
603         uint256 amountBMin,
604         address to,
605         uint256 deadline,
606         bool approveMax, uint8 v, bytes32 r, bytes32 s
607     ) external returns (uint256 amountA, uint256 amountB) {
608         address pair = pairFor(tokenA, tokenB);
609         uint256 value = approveMax ? uint256(- 1) : liquidity;
610         IBtswapPairToken(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
611         (amountA, amountB) = removeLiquidity(tokenA, tokenB, liquidity, amountAMin, amountBMin, to, deadline);
612     }
613 
614     function removeLiquidityETHWithPermit(
615         address token,
616         uint256 liquidity,
617         uint256 amountTokenMin,
618         uint256 amountETHMin,
619         address to,
620         uint256 deadline,
621         bool approveMax, uint8 v, bytes32 r, bytes32 s
622     ) external returns (uint256 amountToken, uint256 amountETH) {
623         address pair = pairFor(token, WETH);
624         uint256 value = approveMax ? uint256(- 1) : liquidity;
625         IBtswapPairToken(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
626         (amountToken, amountETH) = removeLiquidityETH(token, liquidity, amountTokenMin, amountETHMin, to, deadline);
627     }
628 
629     // **** REMOVE LIQUIDITY (supporting fee-on-transfer tokens) ****
630     function removeLiquidityETHSupportingFeeOnTransferTokens(
631         address token,
632         uint256 liquidity,
633         uint256 amountTokenMin,
634         uint256 amountETHMin,
635         address to,
636         uint256 deadline
637     ) public ensure(deadline) returns (uint256 amountETH) {
638         (, amountETH) = removeLiquidity(
639             token,
640             WETH,
641             liquidity,
642             amountTokenMin,
643             amountETHMin,
644             address(this),
645             deadline
646         );
647         TransferHelper.safeTransfer(token, to, IERC20(token).balanceOf(address(this)));
648         IBtswapETH(WETH).withdraw(amountETH);
649         TransferHelper.safeTransferETH(to, amountETH);
650     }
651 
652     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
653         address token,
654         uint256 liquidity,
655         uint256 amountTokenMin,
656         uint256 amountETHMin,
657         address to,
658         uint256 deadline,
659         bool approveMax, uint8 v, bytes32 r, bytes32 s
660     ) external returns (uint256 amountETH) {
661         address pair = pairFor(token, WETH);
662         uint256 value = approveMax ? uint256(- 1) : liquidity;
663         IBtswapPairToken(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
664         amountETH = removeLiquidityETHSupportingFeeOnTransferTokens(token, liquidity, amountTokenMin, amountETHMin, to, deadline);
665     }
666 
667     // **** SWAP ****
668     // requires the initial amount to have already been sent to the first pair
669     function _swap(uint256[] memory amounts, address[] memory path, address _to) internal {
670         for (uint256 i; i < path.length - 1; i++) {
671             (address input, address output) = (path[i], path[i + 1]);
672             (address token0,) = IBtswapFactory(factory).sortTokens(input, output);
673             uint256 amountInput = amounts[i];
674             uint256 amountOut = amounts[i + 1];
675             IBtswapToken(BT).swap(msg.sender, input, amountInput, output);
676             (uint256 amount0Out, uint256 amount1Out) = input == token0 ? (uint256(0), amountOut) : (amountOut, uint256(0));
677             address to = i < path.length - 2 ? pairFor(output, path[i + 2]) : _to;
678             IBtswapPairToken(pairFor(input, output)).swap(amount0Out, amount1Out, to, new bytes(0));
679         }
680     }
681 
682     function swapExactTokensForTokens(
683         uint256 amountIn,
684         uint256 amountOutMin,
685         address[] calldata path,
686         address to,
687         uint256 deadline
688     ) external ensure(deadline) returns (uint256[] memory amounts) {
689         amounts = IBtswapFactory(factory).getAmountsOut(factory, amountIn, path);
690         require(amounts[amounts.length - 1] >= amountOutMin, "BtswapRouter: INSUFFICIENT_OUTPUT_AMOUNT");
691         TransferHelper.safeTransferFrom(path[0], msg.sender, pairFor(path[0], path[1]), amounts[0]);
692         _swap(amounts, path, to);
693     }
694 
695     function swapTokensForExactTokens(
696         uint256 amountOut,
697         uint256 amountInMax,
698         address[] calldata path,
699         address to,
700         uint256 deadline
701     ) external ensure(deadline) returns (uint256[] memory amounts) {
702         amounts = IBtswapFactory(factory).getAmountsIn(factory, amountOut, path);
703         require(amounts[0] <= amountInMax, "BtswapRouter: EXCESSIVE_INPUT_AMOUNT");
704         TransferHelper.safeTransferFrom(path[0], msg.sender, pairFor(path[0], path[1]), amounts[0]);
705         _swap(amounts, path, to);
706     }
707 
708     function swapExactETHForTokens(uint256 amountOutMin, address[] calldata path, address to, uint256 deadline) external payable ensure(deadline) returns (uint256[] memory amounts){
709         require(path[0] == WETH, "BtswapRouter: INVALID_PATH");
710         amounts = IBtswapFactory(factory).getAmountsOut(factory, msg.value, path);
711         require(amounts[amounts.length - 1] >= amountOutMin, "BtswapRouter: INSUFFICIENT_OUTPUT_AMOUNT");
712         IBtswapETH(WETH).deposit.value(amounts[0])();
713         assert(IBtswapETH(WETH).transfer(pairFor(path[0], path[1]), amounts[0]));
714         _swap(amounts, path, to);
715     }
716 
717     function swapTokensForExactETH(uint256 amountOut, uint256 amountInMax, address[] calldata path, address to, uint256 deadline) external ensure(deadline) returns (uint256[] memory amounts){
718         require(path[path.length - 1] == WETH, "BtswapRouter: INVALID_PATH");
719         amounts = IBtswapFactory(factory).getAmountsIn(factory, amountOut, path);
720         require(amounts[0] <= amountInMax, "BtswapRouter: EXCESSIVE_INPUT_AMOUNT");
721         TransferHelper.safeTransferFrom(path[0], msg.sender, pairFor(path[0], path[1]), amounts[0]);
722         _swap(amounts, path, address(this));
723         IBtswapETH(WETH).withdraw(amounts[amounts.length - 1]);
724         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
725     }
726 
727     function swapExactTokensForETH(uint256 amountIn, uint256 amountOutMin, address[] calldata path, address to, uint256 deadline) external ensure(deadline) returns (uint256[] memory amounts){
728         require(path[path.length - 1] == WETH, "BtswapRouter: INVALID_PATH");
729         amounts = IBtswapFactory(factory).getAmountsOut(factory, amountIn, path);
730         require(amounts[amounts.length - 1] >= amountOutMin, "BtswapRouter: INSUFFICIENT_OUTPUT_AMOUNT");
731         TransferHelper.safeTransferFrom(path[0], msg.sender, pairFor(path[0], path[1]), amounts[0]);
732         _swap(amounts, path, address(this));
733         IBtswapETH(WETH).withdraw(amounts[amounts.length - 1]);
734         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
735     }
736 
737     function swapETHForExactTokens(uint256 amountOut, address[] calldata path, address to, uint256 deadline) external payable ensure(deadline) returns (uint256[] memory amounts){
738         require(path[0] == WETH, "BtswapRouter: INVALID_PATH");
739         amounts = IBtswapFactory(factory).getAmountsIn(factory, amountOut, path);
740         require(amounts[0] <= msg.value, "BtswapRouter: EXCESSIVE_INPUT_AMOUNT");
741         IBtswapETH(WETH).deposit.value(amounts[0])();
742         assert(IBtswapETH(WETH).transfer(pairFor(path[0], path[1]), amounts[0]));
743         _swap(amounts, path, to);
744         // refund dust eth, if any
745         if (msg.value > amounts[0]) TransferHelper.safeTransferETH(msg.sender, msg.value - amounts[0]);
746     }
747 
748     // **** SWAP (supporting fee-on-transfer tokens) ****
749     // requires the initial amount to have already been sent to the first pair
750     function _swapSupportingFeeOnTransferTokens(address[] memory path, address _to) internal {
751         for (uint256 i; i < path.length - 1; i++) {
752             (address input, address output) = (path[i], path[i + 1]);
753             (address token0,) = IBtswapFactory(factory).sortTokens(input, output);
754             IBtswapPairToken pair = IBtswapPairToken(pairFor(input, output));
755             uint256 amountInput;
756             uint256 amountOutput;
757             {// scope to avoid stack too deep errors
758                 (uint256 reserve0, uint256 reserve1,) = pair.getReserves();
759                 (uint256 reserveInput, uint256 reserveOutput) = input == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
760                 amountInput = IERC20(input).balanceOf(address(pair)).sub(reserveInput);
761                 amountOutput = IBtswapFactory(factory).getAmountOut(amountInput, reserveInput, reserveOutput);
762             }
763             IBtswapToken(BT).swap(msg.sender, input, amountInput, output);
764             (uint256 amount0Out, uint256 amount1Out) = input == token0 ? (uint256(0), amountOutput) : (amountOutput, uint256(0));
765             address to = i < path.length - 2 ? pairFor(output, path[i + 2]) : _to;
766             pair.swap(amount0Out, amount1Out, to, new bytes(0));
767         }
768     }
769 
770     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
771         uint256 amountIn,
772         uint256 amountOutMin,
773         address[] calldata path,
774         address to,
775         uint256 deadline
776     ) external ensure(deadline) {
777         TransferHelper.safeTransferFrom(path[0], msg.sender, pairFor(path[0], path[1]), amountIn);
778         uint256 balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
779         _swapSupportingFeeOnTransferTokens(path, to);
780         require(IERC20(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin, "BtswapRouter: INSUFFICIENT_OUTPUT_AMOUNT");
781     }
782 
783     function swapExactETHForTokensSupportingFeeOnTransferTokens(
784         uint256 amountOutMin,
785         address[] calldata path,
786         address to,
787         uint256 deadline
788     ) external payable ensure(deadline) {
789         require(path[0] == WETH, "BtswapRouter: INVALID_PATH");
790         uint256 amountIn = msg.value;
791         IBtswapETH(WETH).deposit.value(amountIn)();
792         assert(IBtswapETH(WETH).transfer(pairFor(path[0], path[1]), amountIn));
793         uint256 balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
794         _swapSupportingFeeOnTransferTokens(path, to);
795         require(IERC20(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin, "BtswapRouter: INSUFFICIENT_OUTPUT_AMOUNT");
796     }
797 
798     function swapExactTokensForETHSupportingFeeOnTransferTokens(
799         uint256 amountIn,
800         uint256 amountOutMin,
801         address[] calldata path,
802         address to,
803         uint256 deadline
804     ) external ensure(deadline) {
805         require(path[path.length - 1] == WETH, "BtswapRouter: INVALID_PATH");
806         TransferHelper.safeTransferFrom(path[0], msg.sender, pairFor(path[0], path[1]), amountIn);
807         _swapSupportingFeeOnTransferTokens(path, address(this));
808         uint256 amountOut = IERC20(WETH).balanceOf(address(this));
809         require(amountOut >= amountOutMin, "BtswapRouter: INSUFFICIENT_OUTPUT_AMOUNT");
810         IBtswapETH(WETH).withdraw(amountOut);
811         TransferHelper.safeTransferETH(to, amountOut);
812     }
813 
814     // **** LIBRARY FUNCTIONS ****
815     function quote(uint256 amountA, uint256 reserveA, uint256 reserveB) public view returns (uint256 amountB) {
816         return IBtswapFactory(factory).quote(amountA, reserveA, reserveB);
817     }
818 
819     function getAmountOut(uint256 amountIn, uint256 reserveIn, uint256 reserveOut) public view returns (uint256 amountOut){
820         return IBtswapFactory(factory).getAmountOut(amountIn, reserveIn, reserveOut);
821     }
822 
823     function getAmountIn(uint256 amountOut, uint256 reserveIn, uint256 reserveOut) public view returns (uint256 amountIn){
824         return IBtswapFactory(factory).getAmountIn(amountOut, reserveIn, reserveOut);
825     }
826 
827     function getAmountsOut(uint256 amountIn, address[] memory path) public view returns (uint256[] memory amounts){
828         return IBtswapFactory(factory).getAmountsOut(factory, amountIn, path);
829     }
830 
831     function getAmountsIn(uint256 amountOut, address[] memory path) public view returns (uint256[] memory amounts){
832         return IBtswapFactory(factory).getAmountsIn(factory, amountOut, path);
833     }
834 
835     function weth(address token) public view returns (uint256) {
836         uint256 price = 0;
837 
838         if (WETH == token) {
839             price = SafeMath.wad();
840         }
841         else if (IBtswapFactory(factory).getPair(token, WETH) != address(0)) {
842             price = IBtswapPairToken(IBtswapFactory(factory).getPair(token, WETH)).price(token);
843         }
844         else {
845             uint256 length = IBtswapWhitelistedRole(factory).getWhitelistedsLength();
846             for (uint256 index = 0; index < length; index++) {
847                 address base = IBtswapWhitelistedRole(factory).whitelisteds(index);
848                 if (IBtswapFactory(factory).getPair(token, base) != address(0) && IBtswapFactory(factory).getPair(base, WETH) != address(0)) {
849                     uint256 price0 = IBtswapPairToken(IBtswapFactory(factory).getPair(token, base)).price(token);
850                     uint256 price1 = IBtswapPairToken(IBtswapFactory(factory).getPair(base, WETH)).price(base);
851                     price = price0.wmul(price1);
852                     break;
853                 }
854             }
855         }
856 
857         return price;
858     }
859 
860     function onTransfer(address sender, address recipient) public onlyPair returns (bool) {
861         IBtswapToken(BT).liquidity(sender, msg.sender);
862         IBtswapToken(BT).liquidity(recipient, msg.sender);
863 
864         return true;
865     }
866 
867 
868     function isPair(address pair) public view returns (bool) {
869         return IBtswapFactory(factory).getPair(IBtswapPairToken(pair).token0(), IBtswapPairToken(pair).token1()) == pair;
870     }
871 
872     modifier onlyPair() {
873         require(isPair(msg.sender), "BtswapRouter: caller is not the pair");
874         _;
875     }
876 
877     modifier ensure(uint256 deadline) {
878         require(deadline >= block.timestamp, "BtswapRouter: EXPIRED");
879         _;
880     }
881 
882 }