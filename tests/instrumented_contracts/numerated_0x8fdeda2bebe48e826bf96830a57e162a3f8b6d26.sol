1 // File: contracts/interfaces/IDeerfiV1Router01.sol
2 
3 pragma solidity >=0.5.0;
4 
5 interface IDeerfiV1Router01 {
6     function factory() external pure returns (address);
7     function WETH() external pure returns (address);
8 
9     function addLiquidity(
10         address tradeToken,
11         address fromToken,
12         address toToken,
13         uint amountToken,
14         uint liquidityMin,
15         address to,
16         uint deadline
17     ) external returns (uint liquidity);
18     function addLiquidityETH(
19         address fromToken,
20         address toToken,
21         uint amountETH,
22         uint liquidityMin,
23         address to,
24         uint deadline
25     ) external payable returns (uint liquidity);
26     function removeLiquidity(
27         address tradeToken,
28         address fromToken,
29         address toToken,
30         uint liquidity,
31         uint amountTokenMin,
32         address to,
33         uint deadline
34     ) external returns (uint amountTradeToken);
35     function removeLiquidityETH(
36         address fromToken,
37         address toToken,
38         uint liquidity,
39         uint amountETHMin,
40         address to,
41         uint deadline
42     ) external returns (uint amountTradeToken);
43     function removeLiquidityWithPermit(
44         address tradeToken,
45         address fromToken,
46         address toToken,
47         uint liquidity,
48         uint amountTokenMin,
49         address to,
50         uint deadline,
51         bool approveMax, uint8 v, bytes32 r, bytes32 s
52     ) external returns (uint amountTradeToken);
53     function removeLiquidityETHWithPermit(
54         address fromToken,
55         address toToken,
56         uint liquidity,
57         uint amountETHMin,
58         address to,
59         uint deadline,
60         bool approveMax, uint8 v, bytes32 r, bytes32 s
61     ) external returns (uint amountTradeToken);
62     function swapExactTokensForTokens(
63         uint amountIn,
64         uint amountOutMin,
65         address tradeToken,
66         address fromToken,
67         address toToken,
68         address to,
69         uint deadline
70     ) external returns (uint amountOut);
71     function swapTokensForExactTokens(
72         uint amountOut,
73         uint amountInMax,
74         address tradeToken,
75         address fromToken,
76         address toToken,
77         address to,
78         uint deadline
79     ) external returns (uint amountIn);
80     function swapExactETHForTokens(
81         uint amountOutMin,
82         address fromToken,
83         address toToken,
84         address to,
85         uint deadline
86     ) external payable returns (uint amountOut);
87     function swapETHForExactTokens(
88         uint amountOut,
89         address fromToken,
90         address toToken,
91         address to,
92         uint deadline
93     ) external payable returns (uint amountIn);
94     function closeSwapExactTokensForTokens(
95         uint amountIn,
96         uint amountOutMin,
97         address tradeToken,
98         address fromToken,
99         address toToken,
100         address to,
101         uint deadline
102     ) external returns (uint amountOut);
103     function closeSwapTokensForExactTokens(
104         uint amountOut,
105         uint amountInMax,
106         address tradeToken,
107         address fromToken,
108         address toToken,
109         address to,
110         uint deadline
111     ) external returns (uint amountIn);
112     function closeSwapExactTokensForETH(
113         uint amountIn,
114         uint amountOutMin,
115         address fromToken,
116         address toToken,
117         address to,
118         uint deadline
119     ) external returns (uint amountOut);
120     function closeSwapTokensforExactETH(
121         uint amountOut,
122         uint amountInMax,
123         address fromToken,
124         address toToken,
125         address to,
126         uint deadline
127     ) external returns (uint amountIn);
128 }
129 
130 // File: contracts/interfaces/IDeerfiV1Pair.sol
131 
132 pragma solidity >=0.5.0;
133 
134 interface IDeerfiV1Pair {
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
155     event Mint(address indexed sender, uint amountLiqidity);
156     event Burn(address indexed sender, uint amountLiqidity, address indexed to);
157     event LongSwap(
158         address indexed sender,
159         uint amountTradeTokenIn,
160         uint amountLongTokenOut,
161         address indexed to
162     );
163     event CloseSwap(
164         address indexed sender,
165         uint amountLongTokenIn,
166         uint amountTradeTokenOut,
167         address indexed to
168     );
169     event Sync(uint256 reserveTradeToken);
170 
171     function MINIMUM_LIQUIDITY() external pure returns (uint);
172     function factory() external view returns (address);
173     function tradeToken() external view returns (address);
174     function fromToken() external view returns (address);
175     function toToken() external view returns (address);
176     function longToken() external view returns (address);
177 
178     function getReserves() external view returns (uint256 reserveTradeToken);
179     function kLast() external view returns (uint);
180 
181     function mint(address to) external returns (uint liquidity);
182     function burn(address to) external returns (uint amountTradeToken);
183     function swap(address to) external;
184     function closeSwap(address to) external;
185     function skim(address to) external;
186     function sync() external;
187 
188     function initialize(address, address, address, address) external;
189 }
190 
191 // File: contracts/interfaces/IDeerfiV1Factory.sol
192 
193 pragma solidity >=0.5.0;
194 
195 interface IDeerfiV1Factory {
196     event PairCreated(address indexed tradeToken, address indexed fromToken, address indexed toToken, address pair, address longToken, uint);
197     event FeedPairCreated(address indexed tokenA, address indexed tokenB, address indexed feedPair, uint);
198 
199     function feeTo() external view returns (address);
200     function feeToSetter() external view returns (address);
201     function feeFactor() external view returns (uint16);
202 
203     function getPair(address tradeToken, address fromToken, address toToken) external view returns (address pair);
204     function getFeedPair(address tokenA, address tokenB) external view returns (address feedPair);
205     function allPairsLength() external view returns (uint);
206     function allFeedPairsLength() external view returns (uint);
207 
208     function createPair(address tradeToken, address fromToken, address toToken) external returns (address pair);
209     function setFeedPair(address tokenA, address tokenB, uint8 decimalsA, uint8 decimalsB,
210         address aggregator0, address aggregator1, uint8 decimals0, uint8 decimals1, bool isReverse0, bool isReverse1) external returns (address feedPair);
211 
212     function setFeeTo(address) external;
213     function setFeeFactor(uint16) external;
214     function setFeeToSetter(address) external;
215 }
216 
217 // File: contracts/libraries/SafeMath.sol
218 
219 pragma solidity =0.5.16;
220 
221 // a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)
222 
223 library SafeMath {
224     function add(uint x, uint y) internal pure returns (uint z) {
225         require((z = x + y) >= x, 'ds-math-add-overflow');
226     }
227 
228     function sub(uint x, uint y) internal pure returns (uint z) {
229         require((z = x - y) <= x, 'ds-math-sub-underflow');
230     }
231 
232     function mul(uint x, uint y) internal pure returns (uint z) {
233         require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');
234     }
235 }
236 
237 // File: contracts/libraries/DeerfiV1Library.sol
238 
239 pragma solidity =0.5.16;
240 
241 
242 
243 contract DeerfiV1Library {
244     using SafeMath for uint;
245 
246     // calculates the CREATE2 address for a pair without making any external calls
247     function tradePairFor(address factory, address tradeToken, address fromToken, address toToken) internal pure returns (address pair) {
248         pair = address(uint(keccak256(abi.encodePacked(
249             hex'ff',
250             factory,
251             keccak256(abi.encodePacked(tradeToken, fromToken, toToken)),
252             hex'28b8bd36cce8205fb0c9c17963380f8f26142ed072ad39d0d88b3a1bf00939f8' // init code hash
253         ))));
254     }
255 
256     // calculates the CREATE2 address for a long token without making any external calls
257     function longTokenFor(address factory, address tradeToken, address fromToken, address toToken) internal pure returns (address longToken) {
258         longToken = address(uint(keccak256(abi.encodePacked(
259             hex'ff',
260             factory,
261             keccak256(abi.encodePacked(tradeToken, fromToken, toToken)),
262             hex'61c079f73ee96efe1d38f2af801746529c68ff1093c8e700ad1662e4a74e1cf0' // init code hash
263         ))));
264     }
265 
266     // calculates the CREATE2 address for a feed pair without making any external calls
267     function feedPairFor(address factory, address tokenA, address tokenB) internal pure returns (address feedPair) {
268         feedPair = address(uint(keccak256(abi.encodePacked(
269             hex'ff',
270             factory,
271             keccak256(abi.encodePacked(tokenA, tokenB)),
272             hex'b557e6ca017e5e64c7b98af8b844db236b5b74c622e26e209bef1f92d2e5b7df' // init code hash
273         ))));
274     }
275 
276     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
277     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
278         require(amountA >= 0, 'DeerfiV1Library: INSUFFICIENT_AMOUNT');
279         require(reserveA > 0 && reserveB > 0, 'DeerfiV1Library: INSUFFICIENT_LIQUIDITY');
280         amountB = amountA.mul(reserveB) / reserveA;
281     }
282     
283     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
284     function getTradeAmountOut(address factory, uint amountIn, uint reserveIn, uint reserveOut) internal view returns (uint amountOut) {
285         require(amountIn > 0, 'DeerfiV1Library: INSUFFICIENT_INPUT_AMOUNT');
286         require(reserveIn > 0 && reserveOut > 0, 'DeerfiV1Library: INSUFFICIENT_LIQUIDITY');
287         uint amountOutOptimal= quote(amountIn, reserveIn, reserveOut);
288         uint16 feeFactor = IDeerfiV1Factory(factory).feeFactor();
289         require(feeFactor > 0, 'DeerfiV1Library: INSUFFICIENT_FEE_FACTOR');
290         amountOut = amountOutOptimal.mul(feeFactor) / 1000;
291     }
292 
293     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
294     function getTradeAmountIn(address factory, uint amountOut, uint reserveIn, uint reserveOut) internal view returns (uint amountIn) {
295         require(amountOut > 0, 'DeerfiV1Library: INSUFFICIENT_OUTPUT_AMOUNT');
296         require(reserveIn > 0 && reserveOut > 0, 'DeerfiV1Library: INSUFFICIENT_LIQUIDITY');
297         uint amountInOptimal = quote(amountOut, reserveOut, reserveIn);
298         uint16 feeFactor = IDeerfiV1Factory(factory).feeFactor();
299         require(feeFactor > 0, 'DeerfiV1Library: INSUFFICIENT_FEE_FACTOR');
300         amountIn = amountInOptimal.mul(1000) / feeFactor;
301     }
302 }
303 
304 // File: contracts/interfaces/IWETH.sol
305 
306 pragma solidity >=0.5.0;
307 
308 interface IWETH {
309     function deposit() external payable;
310     function transfer(address to, uint value) external returns (bool);
311     function withdraw(uint) external;
312     function balanceOf(address owner) external view returns (uint);
313 }
314 
315 // File: contracts/interfaces/IDeerfiV1FeedPair.sol
316 
317 pragma solidity >=0.5.0;
318 
319 interface IDeerfiV1FeedPair {
320     function factory() external view returns (address);
321     function tokenA() external view returns (address);
322     function tokenB() external view returns (address);
323     function decimalsA() external view returns (uint8);
324     function decimalsB() external view returns (uint8);
325     function aggregator0() external view returns (address);
326     function aggregator1() external view returns (address);
327     function decimals0() external view returns (uint8);
328     function decimals1() external view returns (uint8);
329     function isReverse0() external view returns (bool);
330     function isReverse1() external view returns (bool);
331     function initialize(address, address, uint8, uint8, address, address, uint8, uint8, bool, bool) external;
332     function getReserves() external view returns (uint reserveA, uint reserveB);
333 }
334 
335 // File: contracts/DeerfiV1Router01.sol
336 
337 pragma solidity =0.5.16;
338 
339 
340 
341 
342 
343 
344 
345 contract DeerfiV1Router01 is IDeerfiV1Router01, DeerfiV1Library {
346     bytes4 private constant SELECTOR_TRANSFER = bytes4(keccak256(bytes('transfer(address,uint256)')));
347     bytes4 private constant SELECTOR_TRANSFER_FROM = bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
348 
349     address public factory;
350     address public WETH;
351 
352     // **** TRANSFER HELPERS ****
353     function _safeTransfer(address token, address to, uint value) private {
354         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(SELECTOR_TRANSFER, to, value));
355         require(success && (data.length == 0 || abi.decode(data, (bool))), 'DeerfiV1Router: TRANSFER_FAILED');
356     }
357     function _safeTransferFrom(address token, address from, address to, uint value) private {
358         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(SELECTOR_TRANSFER_FROM, from, to, value));
359         require(success && (data.length == 0 || abi.decode(data, (bool))), 'DeerfiV1Router: TRANSFER_FROM_FAILED');
360     }
361     function _safeTransferETH(address to, uint value) private {
362         (bool success,) = to.call.value(value)(new bytes(0));
363         require(success, 'DeerfiV1Router: ETH_TRANSFER_FAILED');
364     }
365 
366     modifier ensure(uint deadline) {
367         require(deadline >= block.timestamp, 'DeerfiV1Router: EXPIRED');
368         _;
369     }
370 
371     constructor(address _factory, address _WETH) public {
372         factory = _factory;
373         WETH = _WETH;
374     }
375 
376     function() external payable {
377         assert(msg.sender == address(WETH)); // only accept ETH via fallback from the WETH contract
378     }
379 
380     // **** ADD LIQUIDITY ****
381     function addLiquidity(
382         address tradeToken,
383         address fromToken,
384         address toToken,
385         uint amountToken,
386         uint liquidityMin,
387         address to,
388         uint deadline
389     ) external ensure(deadline) returns (uint liquidity) {
390         if (IDeerfiV1Factory(factory).getPair(tradeToken, fromToken, toToken) == address(0)) {
391             IDeerfiV1Factory(factory).createPair(tradeToken, fromToken, toToken);
392         }
393         address pair = tradePairFor(factory, tradeToken, fromToken, toToken);
394         _safeTransferFrom(tradeToken, msg.sender, pair, amountToken);
395         liquidity = IDeerfiV1Pair(pair).mint(to);
396         require(liquidity >= liquidityMin, 'DeerfiV1Router: INSUFFICIENT_A_AMOUNT');
397     }
398     function addLiquidityETH(
399         address fromToken,
400         address toToken,
401         uint amountETH,
402         uint liquidityMin,
403         address to,
404         uint deadline
405     ) external payable ensure(deadline) returns (uint liquidity) {
406         if (IDeerfiV1Factory(factory).getPair(address(WETH), fromToken, toToken) == address(0)) {
407             IDeerfiV1Factory(factory).createPair(address(WETH), fromToken, toToken);
408         }
409         address pair = tradePairFor(factory, address(WETH), fromToken, toToken);
410         IWETH(WETH).deposit.value(amountETH)();
411         assert(IWETH(WETH).transfer(pair, amountETH));
412         liquidity = IDeerfiV1Pair(pair).mint(to);
413         require(liquidity >= liquidityMin, 'DeerfiV1Router: INSUFFICIENT_A_AMOUNT');
414         if (msg.value > amountETH) _safeTransferETH(msg.sender, msg.value - amountETH); // refund dust eth, if any
415     }
416 
417     // **** REMOVE LIQUIDITY ****
418     function removeLiquidity(
419         address tradeToken,
420         address fromToken,
421         address toToken,
422         uint liquidity,
423         uint amountTokenMin,
424         address to,
425         uint deadline
426     ) public ensure(deadline) returns (uint amountTradeToken) {
427         address pair = tradePairFor(factory, tradeToken, fromToken, toToken);
428         IDeerfiV1Pair(pair).transferFrom(msg.sender, pair, liquidity); // send liquidity to pair
429         amountTradeToken = IDeerfiV1Pair(pair).burn(to);
430         require(amountTradeToken >= amountTokenMin, 'DeerfiV1Router: INSUFFICIENT_A_AMOUNT');
431     }
432     function removeLiquidityETH(
433         address fromToken,
434         address toToken,
435         uint liquidity,
436         uint amountETHMin,
437         address to,
438         uint deadline
439     ) public ensure(deadline) returns (uint amountTradeToken) {
440         amountTradeToken = removeLiquidity(
441             address(WETH),
442             fromToken,
443             toToken,
444             liquidity,
445             amountETHMin,
446             address(this),
447             deadline
448         );
449         IWETH(WETH).withdraw(amountTradeToken);
450         _safeTransferETH(to, amountTradeToken);
451     }
452     function removeLiquidityWithPermit(
453         address tradeToken,
454         address fromToken,
455         address toToken,
456         uint liquidity,
457         uint amountTokenMin,
458         address to,
459         uint deadline,
460         bool approveMax, uint8 v, bytes32 r, bytes32 s
461     ) external returns (uint amountTradeToken) {
462         address pair = tradePairFor(factory, tradeToken, fromToken, toToken);
463         uint value = approveMax ? uint(-1) : liquidity;
464         IDeerfiV1Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
465         amountTradeToken = removeLiquidity(tradeToken, fromToken, toToken, liquidity, amountTokenMin, to, deadline);
466     }
467     function removeLiquidityETHWithPermit(
468         address fromToken,
469         address toToken,
470         uint liquidity,
471         uint amountETHMin,
472         address to,
473         uint deadline,
474         bool approveMax, uint8 v, bytes32 r, bytes32 s
475     ) external returns (uint amountTradeToken) {
476         address pair = tradePairFor(factory, address(WETH), fromToken, toToken);
477         uint value = approveMax ? uint(-1) : liquidity;
478         IDeerfiV1Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
479         amountTradeToken = removeLiquidityETH(fromToken, toToken, liquidity, amountETHMin, to, deadline);
480     }
481 
482     // **** SWAP & CLOSE SWAP ****
483     function swapExactTokensForTokens(
484         uint amountIn,
485         uint amountOutMin,
486         address tradeToken,
487         address fromToken,
488         address toToken,
489         address to,
490         uint deadline
491     ) external ensure(deadline) returns (uint amountOut) {
492         {
493         (uint reserveIn, uint reserveOut) = IDeerfiV1FeedPair(feedPairFor(factory, fromToken, toToken)).getReserves();
494         amountOut = getTradeAmountOut(factory, amountIn, reserveIn, reserveOut);
495         }
496         require(amountOut >= amountOutMin, 'DeerfiV1Router: INSUFFICIENT_OUTPUT_AMOUNT');
497         address pair = tradePairFor(factory, tradeToken, fromToken, toToken);
498         _safeTransferFrom(tradeToken, msg.sender, pair, amountIn);
499         IDeerfiV1Pair(pair).swap(to);
500     }
501     function swapTokensForExactTokens(
502         uint amountOut,
503         uint amountInMax,
504         address tradeToken,
505         address fromToken,
506         address toToken,
507         address to,
508         uint deadline
509     ) external ensure(deadline) returns (uint amountIn) {
510         {
511         (uint reserveIn, uint reserveOut) = IDeerfiV1FeedPair(feedPairFor(factory, fromToken, toToken)).getReserves();
512         amountIn = getTradeAmountIn(factory, amountOut, reserveIn, reserveOut);
513         }
514         require(amountIn <= amountInMax, 'DeerfiV1Router: EXCESSIVE_INPUT_AMOUNT');
515         address pair = tradePairFor(factory, tradeToken, fromToken, toToken);
516         _safeTransferFrom(tradeToken, msg.sender, pair, amountIn);
517         IDeerfiV1Pair(pair).swap(to);
518     }
519     function swapExactETHForTokens(
520         uint amountOutMin,
521         address fromToken,
522         address toToken,
523         address to,
524         uint deadline
525     ) external payable ensure(deadline) returns (uint amountOut) {
526         {
527         (uint reserveIn, uint reserveOut) = IDeerfiV1FeedPair(feedPairFor(factory, fromToken, toToken)).getReserves();
528         amountOut = getTradeAmountOut(factory, msg.value, reserveIn, reserveOut);
529         }
530         require(amountOut >= amountOutMin, 'DeerfiV1Router: INSUFFICIENT_OUTPUT_AMOUNT');
531         address pair = tradePairFor(factory, WETH, fromToken, toToken);
532         IWETH(WETH).deposit.value(msg.value)();
533         assert(IWETH(WETH).transfer(pair, msg.value));
534         IDeerfiV1Pair(pair).swap(to);
535     }
536     function swapETHForExactTokens(
537         uint amountOut,
538         address fromToken,
539         address toToken,
540         address to,
541         uint deadline
542     ) external payable ensure(deadline) returns (uint amountIn) {
543         {
544         (uint reserveIn, uint reserveOut) = IDeerfiV1FeedPair(feedPairFor(factory, fromToken, toToken)).getReserves();
545         amountIn = getTradeAmountIn(factory, amountOut, reserveIn, reserveOut);
546         }
547         require(amountIn <= msg.value, 'DeerfiV1Router: EXCESSIVE_INPUT_AMOUNT');
548         address pair = tradePairFor(factory, WETH, fromToken, toToken);
549         IWETH(WETH).deposit.value(amountIn)();
550         assert(IWETH(WETH).transfer(pair, amountIn));
551         IDeerfiV1Pair(pair).swap(to);
552         if (msg.value > amountIn) _safeTransferETH(msg.sender, msg.value - amountIn); // refund dust eth, if any
553     }
554     function closeSwapExactTokensForTokens(
555         uint amountIn,
556         uint amountOutMin,
557         address tradeToken,
558         address fromToken,
559         address toToken,
560         address to,
561         uint deadline
562     ) external ensure(deadline) returns (uint amountOut) {
563         {
564         (uint reserveOut, uint reserveIn) = IDeerfiV1FeedPair(feedPairFor(factory, fromToken, toToken)).getReserves();
565         amountOut = getTradeAmountOut(factory, amountIn, reserveIn, reserveOut);
566         }
567         require(amountOut >= amountOutMin, 'DeerfiV1Router: INSUFFICIENT_OUTPUT_AMOUNT');
568         address pair = tradePairFor(factory, tradeToken, fromToken, toToken);
569         address swapToken = longTokenFor(factory, tradeToken, fromToken, toToken);
570         _safeTransferFrom(swapToken, msg.sender, pair, amountIn);
571         IDeerfiV1Pair(pair).closeSwap(to);
572     }
573     function closeSwapTokensForExactTokens(
574         uint amountOut,
575         uint amountInMax,
576         address tradeToken,
577         address fromToken,
578         address toToken,
579         address to,
580         uint deadline
581     ) external ensure(deadline) returns (uint amountIn) {
582         {
583         (uint reserveOut, uint reserveIn) = IDeerfiV1FeedPair(feedPairFor(factory, fromToken, toToken)).getReserves();
584         amountIn = getTradeAmountIn(factory, amountOut, reserveIn, reserveOut);
585         }
586         require(amountIn <= amountInMax, 'DeerfiV1Router: EXCESSIVE_INPUT_AMOUNT');
587         address pair = tradePairFor(factory, tradeToken, fromToken, toToken);
588         address swapToken = longTokenFor(factory, tradeToken, fromToken, toToken);
589         _safeTransferFrom(swapToken, msg.sender, pair, amountIn);
590         IDeerfiV1Pair(pair).closeSwap(to);
591     }
592     function closeSwapExactTokensForETH(
593         uint amountIn,
594         uint amountOutMin,
595         address fromToken,
596         address toToken,
597         address to,
598         uint deadline
599     ) external ensure(deadline) returns (uint amountOut) {
600         {
601         (uint reserveOut, uint reserveIn) = IDeerfiV1FeedPair(feedPairFor(factory, fromToken, toToken)).getReserves();
602         amountOut = getTradeAmountOut(factory, amountIn, reserveIn, reserveOut);
603         }
604         require(amountOut >= amountOutMin, 'DeerfiV1Router: INSUFFICIENT_OUTPUT_AMOUNT');
605         address pair = tradePairFor(factory, WETH, fromToken, toToken);
606         address swapToken = longTokenFor(factory, WETH, fromToken, toToken);
607         _safeTransferFrom(swapToken, msg.sender, pair, amountIn);
608         IDeerfiV1Pair(pair).closeSwap(address(this));
609         IWETH(WETH).withdraw(amountOut);
610         _safeTransferETH(to, amountOut);
611     }
612     function closeSwapTokensforExactETH(
613         uint amountOut,
614         uint amountInMax,
615         address fromToken,
616         address toToken,
617         address to,
618         uint deadline
619     ) external ensure(deadline) returns (uint amountIn) {
620         {
621         (uint reserveOut, uint reserveIn) = IDeerfiV1FeedPair(feedPairFor(factory, fromToken, toToken)).getReserves();
622         amountIn = getTradeAmountIn(factory, amountOut, reserveIn, reserveOut);
623         }
624         require(amountIn <= amountInMax, 'DeerfiV1Router: EXCESSIVE_INPUT_AMOUNT');
625         address pair = tradePairFor(factory, WETH, fromToken, toToken);
626         address swapToken = longTokenFor(factory, WETH, fromToken, toToken);
627         _safeTransferFrom(swapToken, msg.sender, pair, amountIn);
628         IDeerfiV1Pair(pair).closeSwap(address(this));
629         uint balanceWETH = IWETH(WETH).balanceOf(address(this));
630         IWETH(WETH).withdraw(balanceWETH);
631         _safeTransferETH(to, balanceWETH);
632     }
633 }