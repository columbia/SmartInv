1 //author: 0x谛听
2 
3 pragma solidity >=0.5.0;
4 
5 interface IUniswapV2Pair {
6     event Approval(address indexed owner, address indexed spender, uint value);
7     event Transfer(address indexed from, address indexed to, uint value);
8 
9     function name() external pure returns (string memory);
10     function symbol() external pure returns (string memory);
11     function decimals() external pure returns (uint8);
12     function totalSupply() external view returns (uint);
13     function balanceOf(address owner) external view returns (uint);
14     function allowance(address owner, address spender) external view returns (uint);
15 
16     function approve(address spender, uint value) external returns (bool);
17     function transfer(address to, uint value) external returns (bool);
18     function transferFrom(address from, address to, uint value) external returns (bool);
19 
20     function DOMAIN_SEPARATOR() external view returns (bytes32);
21     function PERMIT_TYPEHASH() external pure returns (bytes32);
22     function nonces(address owner) external view returns (uint);
23 
24     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
25 
26     event Mint(address indexed sender, uint amount0, uint amount1);
27     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
28     event Swap(
29         address indexed sender,
30         uint amount0In,
31         uint amount1In,
32         uint amount0Out,
33         uint amount1Out,
34         address indexed to
35     );
36     event Sync(uint112 reserve0, uint112 reserve1);
37     event Harvest(address indexed sender, uint amount);
38 
39     function MINIMUM_LIQUIDITY() external pure returns (uint);
40     function factory() external view returns (address);
41     function token0() external view returns (address);
42     function token1() external view returns (address);
43     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
44     function price0CumulativeLast() external view returns (uint);
45     function price1CumulativeLast() external view returns (uint);
46     function kLast() external view returns (uint);
47     function mint(address to) external returns (uint liquidity);
48     function burn(address to,address user,bool emerg) external returns (uint amount0, uint amount1);
49     function swap(uint[3] memory amount, address to, bytes calldata data) external;
50     function skim(address to) external;
51     function pending(address user) external view returns (uint);
52     function harvestNow(address to) external;
53     function sync() external;
54 
55     function initialize(address, address,address) external;
56 }
57 
58 
59 
60 pragma solidity >=0.5.0;
61 
62 interface IOkswapFactory {
63     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
64 
65     function teamAmount() external view returns (uint);
66     function vcAmount() external view returns (uint);
67     function isBonusPair(address) external view returns (bool);
68 
69     function getPair(address tokenA, address tokenB) external view returns (address pair);
70     function allPairs(uint) external view returns (address pair);
71     function allPairsLength() external view returns (uint);
72 
73     function createPair(address tokenA, address tokenB) external returns (address pair);
74     function changeSetter(address) external;
75     function setFeeHolder(address) external;
76     function setBurnHolder(address) external;
77     function setVcHolder(address) external;
78 
79     function pairCodeHash() external pure returns (bytes32);
80     function addBonusPair(uint, uint, address, address, bool) external ;
81     function getBonusConfig(address) external view returns (uint, uint,address,address,address,address);
82     function getElac() external view returns (uint, uint);
83     function setElac(uint,uint) external;
84     function updateTeamAmount(uint) external;
85     function updateVcAmount(uint) external;
86     function realize(address,uint) external;
87 
88     function getSysCf() external view returns (uint);
89 }
90 
91 // File: contracts/libraries/SafeMath.sol
92 
93 pragma solidity =0.6.12;
94 
95 // a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)
96 
97 library SafeMathUniswap {
98     function add(uint x, uint y) internal pure returns (uint z) {
99         require((z = x + y) >= x, 'ds-math-add-overflow');
100     }
101 
102     function sub(uint x, uint y) internal pure returns (uint z) {
103         require((z = x - y) <= x, 'ds-math-sub-underflow');
104     }
105 
106     function mul(uint x, uint y) internal pure returns (uint z) {
107         require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');
108     }
109 
110     function div(uint256 a, uint256 b) internal pure returns (uint256) {
111         require(b > 0, 'ds-math-div-overflow');
112         uint256 c = a / b;
113         return c;
114     }
115 
116 }
117 
118 
119 
120 pragma solidity >=0.5.0;
121 
122 
123 library UniswapV2Library {
124     using SafeMathUniswap for uint;
125 
126     // returns sorted token addresses, used to handle return values from pairs sorted in this order
127     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
128         require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');
129         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
130         require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');
131     }
132 
133     // calculates the CREATE2 address for a pair without making any external calls
134     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
135         (address token0, address token1) = sortTokens(tokenA, tokenB);
136         pair = address(uint(keccak256(abi.encodePacked(
137                 hex'ff',
138                 factory,
139                 keccak256(abi.encodePacked(token0, token1)),
140                     IOkswapFactory(factory).pairCodeHash() // init code hash
141             ))));
142     }
143 
144     // fetches and sorts the reserves for a pair
145     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
146         (address token0,) = sortTokens(tokenA, tokenB);
147         (uint reserve0, uint reserve1,) = IUniswapV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();
148         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
149     }
150 
151     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
152     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
153         require(amountA > 0, 'UniswapV2Library: INSUFFICIENT_AMOUNT');
154         require(reserveA > 0 && reserveB > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
155         amountB = amountA.mul(reserveB) / reserveA;
156     }
157 
158     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
159     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
160         require(amountIn > 0, 'UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT');
161         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
162         uint amountInWithFee = amountIn.mul(997);
163         uint numerator = amountInWithFee.mul(reserveOut);
164         uint denominator = reserveIn.mul(1000).add(amountInWithFee);
165         amountOut = numerator / denominator;
166     }
167 
168     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
169     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {
170         require(amountOut > 0, 'UniswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT');
171         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
172         uint numerator = reserveIn.mul(amountOut).mul(1000);
173         uint denominator = reserveOut.sub(amountOut).mul(997);
174         amountIn = (numerator / denominator).add(1);
175     }
176 
177     // performs chained getAmountOut calculations on any number of pairs
178     function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {
179         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
180         amounts = new uint[](path.length);
181         amounts[0] = amountIn;
182         for (uint i; i < path.length - 1; i++) {
183             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);
184             amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
185         }
186     }
187 
188     // performs chained getAmountIn calculations on any number of pairs
189     function getAmountsIn(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {
190         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
191         amounts = new uint[](path.length);
192         amounts[amounts.length - 1] = amountOut;
193         for (uint i = path.length - 1; i > 0; i--) {
194             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);
195             amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
196         }
197     }
198     
199     function calAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {
200         require(amountOut > 0, 'UniswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT');
201         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
202         uint numerator = reserveIn.mul(amountOut).mul(1000);
203         uint denominator = reserveOut.sub(amountOut).mul(997);
204         amountIn = (numerator / denominator).add(1);
205     }
206 }
207 
208 
209 
210 pragma solidity >=0.6.0;
211 
212 // helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
213 library TransferHelper {
214     function safeApprove(address token, address to, uint value) internal {
215         // bytes4(keccak256(bytes('approve(address,uint256)')));
216         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
217         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
218     }
219 
220     function safeTransfer(address token, address to, uint value) internal {
221         // bytes4(keccak256(bytes('transfer(address,uint256)')));
222         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
223         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
224     }
225 
226     function safeTransferFrom(address token, address from, address to, uint value) internal {
227         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
228         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
229         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
230     }
231 
232     function safeTransferETH(address to, uint value) internal {
233         (bool success,) = to.call{value:value}(new bytes(0));
234         require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
235     }
236 }
237 
238 
239 pragma solidity >=0.6.2;
240 
241 interface IOkswapRouterBase {
242     function factory() external pure returns (address);
243     function WETH() external pure returns (address);
244 
245     function addLiquidity(
246         address tokenA,
247         address tokenB,
248         uint amountADesired,
249         uint amountBDesired,
250         uint amountAMin,
251         uint amountBMin,
252         address to,
253         uint deadline
254     ) external returns (uint amountA, uint amountB, uint liquidity);
255     function addLiquidityETH(
256         address token,
257         uint amountTokenDesired,
258         uint amountTokenMin,
259         uint amountETHMin,
260         address to,
261         uint deadline
262     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
263     function removeLiquidity(
264         address tokenA,
265         address tokenB,
266         uint liquidity,
267         uint amountAMin,
268         uint amountBMin,
269         address to,
270         uint deadline
271     ) external returns (uint amountA, uint amountB);
272     function removeLiquidityETH(
273         address token,
274         uint liquidity,
275         uint amountTokenMin,
276         uint amountETHMin,
277         address to,
278         uint deadline
279     ) external returns (uint amountToken, uint amountETH);
280     function removeLiquidityWithPermit(
281         address tokenA,
282         address tokenB,
283         uint liquidity,
284         uint amountAMin,
285         uint amountBMin,
286         address to,
287         uint deadline,
288         bool approveMax, uint8 v, bytes32 r, bytes32 s
289     ) external returns (uint amountA, uint amountB);
290     function removeLiquidityETHWithPermit(
291         address token,
292         uint liquidity,
293         uint amountTokenMin,
294         uint amountETHMin,
295         address to,
296         uint deadline,
297         bool approveMax, uint8 v, bytes32 r, bytes32 s
298     ) external returns (uint amountToken, uint amountETH);
299     function swapExactTokensForTokens(
300         uint amountIn,
301         uint amountOutMin,
302         address[] calldata path,
303         address to,
304         uint deadline
305     ) external returns (uint[] memory amounts);
306     function swapTokensForExactTokens(
307         uint amountOut,
308         uint amountInMax,
309         address[] calldata path,
310         address to,
311         uint deadline
312     ) external returns (uint[] memory amounts);
313     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
314         external
315         payable
316         returns (uint[] memory amounts);
317     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
318         external
319         returns (uint[] memory amounts);
320     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
321         external
322         returns (uint[] memory amounts);
323     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
324         external
325         payable
326         returns (uint[] memory amounts);
327 
328     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
329     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
330     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
331     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
332     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
333 }
334 
335 
336 
337 pragma solidity >=0.6.2;
338 
339 
340 interface IOkswapRouter is IOkswapRouterBase {
341     function removeLiquidityETHSupportingFeeOnTransferTokens(
342         address token,
343         uint liquidity,
344         uint amountTokenMin,
345         uint amountETHMin,
346         address to,
347         uint deadline
348     ) external returns (uint amountETH);
349     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
350         address token,
351         uint liquidity,
352         uint amountTokenMin,
353         uint amountETHMin,
354         address to,
355         uint deadline,
356         bool approveMax, uint8 v, bytes32 r, bytes32 s
357     ) external returns (uint amountETH);
358 
359     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
360         uint amountIn,
361         uint amountOutMin,
362         address[] calldata path,
363         address to,
364         uint deadline
365     ) external;
366     function swapExactETHForTokensSupportingFeeOnTransferTokens(
367         uint amountOutMin,
368         address[] calldata path,
369         address to,
370         uint deadline
371     ) external payable;
372     function swapExactTokensForETHSupportingFeeOnTransferTokens(
373         uint amountIn,
374         uint amountOutMin,
375         address[] calldata path,
376         address to,
377         uint deadline
378     ) external;
379 }
380 
381 
382 pragma solidity >=0.5.0;
383 
384 interface IERC20Uniswap {
385     event Approval(address indexed owner, address indexed spender, uint value);
386     event Transfer(address indexed from, address indexed to, uint value);
387 
388     function name() external view returns (string memory);
389     function symbol() external view returns (string memory);
390     function decimals() external view returns (uint8);
391     function totalSupply() external view returns (uint);
392     function balanceOf(address owner) external view returns (uint);
393     function allowance(address owner, address spender) external view returns (uint);
394 
395     function approve(address spender, uint value) external returns (bool);
396     function transfer(address to, uint value) external returns (bool);
397     function transferFrom(address from, address to, uint value) external returns (bool);
398 }
399 
400 
401 pragma solidity >=0.5.0;
402 
403 interface IWETH {
404     function deposit() external payable;
405     function transfer(address to, uint value) external returns (bool);
406     function withdraw(uint) external;
407 }
408 
409 
410 
411 pragma solidity =0.6.12;
412 
413 contract OKSwapRouter is IOkswapRouter {
414     using SafeMathUniswap for uint;
415 
416     address public immutable override factory;
417     address public immutable override WETH;
418     address private  okra;
419 
420     modifier ensure(uint deadline) {
421         require(deadline >= block.timestamp, 'OkswapRouter: EXPIRED');
422         _;
423     }
424 
425     constructor(address _factory, address _WETH,address _okra) public {
426         factory = _factory;
427         WETH = _WETH;
428         okra = _okra;
429     }
430 
431     receive() external payable {
432         assert(msg.sender == WETH); // only accept ETH via fallback from the WETH contract
433     }
434 
435     // **** ADD LIQUIDITY ****
436     function _addLiquidity(
437         address tokenA,
438         address tokenB,
439         uint amountADesired,
440         uint amountBDesired,
441         uint amountAMin,
442         uint amountBMin
443     ) internal virtual returns (uint amountA, uint amountB) {
444         // create the pair if it doesn't exist yet
445         if (IOkswapFactory(factory).getPair(tokenA, tokenB) == address(0)) {
446             IOkswapFactory(factory).createPair(tokenA, tokenB);
447         }
448         (uint reserveA, uint reserveB) = UniswapV2Library.getReserves(factory, tokenA, tokenB);
449         if (reserveA == 0 && reserveB == 0) {
450             (amountA, amountB) = (amountADesired, amountBDesired);
451         } else {
452             uint amountBOptimal = UniswapV2Library.quote(amountADesired, reserveA, reserveB);
453             if (amountBOptimal <= amountBDesired) {
454                 require(amountBOptimal >= amountBMin, 'OkswapRouter: INSUFFICIENT_B_AMOUNT');
455                 (amountA, amountB) = (amountADesired, amountBOptimal);
456             } else {
457                 uint amountAOptimal = UniswapV2Library.quote(amountBDesired, reserveB, reserveA);
458                 assert(amountAOptimal <= amountADesired);
459                 require(amountAOptimal >= amountAMin, 'OkswapRouter: INSUFFICIENT_A_AMOUNT');
460                 (amountA, amountB) = (amountAOptimal, amountBDesired);
461             }
462         }
463     }
464     function addLiquidity(
465         address tokenA,
466         address tokenB,
467         uint amountADesired,
468         uint amountBDesired,
469         uint amountAMin,
470         uint amountBMin,
471         address to,
472         uint deadline
473     ) external virtual override ensure(deadline) returns (uint amountA, uint amountB, uint liquidity) {
474         (amountA, amountB) = _addLiquidity(tokenA, tokenB, amountADesired, amountBDesired, amountAMin, amountBMin);
475         address pair = UniswapV2Library.pairFor(factory, tokenA, tokenB);
476         TransferHelper.safeTransferFrom(tokenA, msg.sender, pair, amountA);
477         TransferHelper.safeTransferFrom(tokenB, msg.sender, pair, amountB);
478         liquidity = IUniswapV2Pair(pair).mint(to);
479     }
480     function addLiquidityETH(
481         address token,
482         uint amountTokenDesired,
483         uint amountTokenMin,
484         uint amountETHMin,
485         address to,
486         uint deadline
487     ) external virtual override payable ensure(deadline) returns (uint amountToken, uint amountETH, uint liquidity) {
488         (amountToken, amountETH) = _addLiquidity(
489             token,
490             WETH,
491             amountTokenDesired,
492             msg.value,
493             amountTokenMin,
494             amountETHMin
495         );
496         address pair = UniswapV2Library.pairFor(factory, token, WETH);
497         TransferHelper.safeTransferFrom(token, msg.sender, pair, amountToken);
498         IWETH(WETH).deposit{value: amountETH}();
499         assert(IWETH(WETH).transfer(pair, amountETH));
500         liquidity = IUniswapV2Pair(pair).mint(to);
501         // refund dust eth, if any
502         if (msg.value > amountETH) TransferHelper.safeTransferETH(msg.sender, msg.value - amountETH);
503     }
504 
505     // **** REMOVE LIQUIDITY ****
506     function removeLiquidity(
507         address tokenA,
508         address tokenB,
509         uint liquidity,
510         uint amountAMin,
511         uint amountBMin,
512         address to,
513         uint deadline
514     ) public virtual override ensure(deadline) returns (uint amountA, uint amountB) {
515         address pair = UniswapV2Library.pairFor(factory, tokenA, tokenB);
516         IUniswapV2Pair(pair).transferFrom(msg.sender, pair, liquidity); // send liquidity to pair
517         (uint amount0, uint amount1) = IUniswapV2Pair(pair).burn(to,to,false);
518         (address token0,) = UniswapV2Library.sortTokens(tokenA, tokenB);
519         (amountA, amountB) = tokenA == token0 ? (amount0, amount1) : (amount1, amount0);
520         require(amountA >= amountAMin, 'OkswapRouter: INSUFFICIENT_A_AMOUNT');
521         require(amountB >= amountBMin, 'OkswapRouter: INSUFFICIENT_B_AMOUNT');
522     }
523     function removeLiquidityETH(
524         address token,
525         uint liquidity,
526         uint amountTokenMin,
527         uint amountETHMin,
528         address to,
529         uint deadline
530     ) public virtual override ensure(deadline) returns (uint amountToken, uint amountETH) {
531 //        (amountToken, amountETH) = removeLiquidity(
532 //            token,
533 //            WETH,
534 //            liquidity,
535 //            amountTokenMin,
536 //            amountETHMin,
537 //            address(this),
538 //            deadline
539 //        );
540         address pair = UniswapV2Library.pairFor(factory, token, WETH);
541         IUniswapV2Pair(pair).transferFrom(msg.sender, pair, liquidity); // send liquidity to pair
542         (uint amount0, uint amount1) = IUniswapV2Pair(pair).burn(address(this),to,false);
543         (address token0,) = UniswapV2Library.sortTokens(token, WETH);
544         (amountToken, amountETH) = token == token0 ? (amount0, amount1) : (amount1, amount0);
545 
546         require(amountToken >= amountTokenMin, 'OkswapRouter: INSUFFICIENT_A_AMOUNT');
547         require(amountETH >= amountETHMin, 'OkswapRouter: INSUFFICIENT_B_AMOUNT');
548 
549         TransferHelper.safeTransfer(token, to, amountToken);
550         IWETH(WETH).withdraw(amountETH);
551         TransferHelper.safeTransferETH(to, amountETH);
552     }
553     function removeLiquidityWithPermit(
554         address tokenA,
555         address tokenB,
556         uint liquidity,
557         uint amountAMin,
558         uint amountBMin,
559         address to,
560         uint deadline,
561         bool approveMax, uint8 v, bytes32 r, bytes32 s
562     ) external virtual override returns (uint amountA, uint amountB) {
563         address pair = UniswapV2Library.pairFor(factory, tokenA, tokenB);
564         uint value = approveMax ? uint(-1) : liquidity;
565         IUniswapV2Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
566         (amountA, amountB) = removeLiquidity(tokenA, tokenB, liquidity, amountAMin, amountBMin, to, deadline);
567     }
568     function removeLiquidityETHWithPermit(
569         address token,
570         uint liquidity,
571         uint amountTokenMin,
572         uint amountETHMin,
573         address to,
574         uint deadline,
575         bool approveMax, uint8 v, bytes32 r, bytes32 s
576     ) external virtual override returns (uint amountToken, uint amountETH) {
577         address pair = UniswapV2Library.pairFor(factory, token, WETH);
578         uint value = approveMax ? uint(-1) : liquidity;
579         IUniswapV2Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
580         (amountToken, amountETH) = removeLiquidityETH(token, liquidity, amountTokenMin, amountETHMin, to, deadline);
581     }
582 
583     // **** REMOVE LIQUIDITY (supporting fee-on-transfer tokens) ****
584     function removeLiquidityETHSupportingFeeOnTransferTokens(
585         address token,
586         uint liquidity,
587         uint amountTokenMin,
588         uint amountETHMin,
589         address to,
590         uint deadline
591     ) public virtual override ensure(deadline) returns (uint amountETH) {
592         (, amountETH) = removeLiquidity(
593             token,
594             WETH,
595             liquidity,
596             amountTokenMin,
597             amountETHMin,
598             address(this),
599             deadline
600         );
601         TransferHelper.safeTransfer(token, to, IERC20Uniswap(token).balanceOf(address(this)));
602         IWETH(WETH).withdraw(amountETH);
603         TransferHelper.safeTransferETH(to, amountETH);
604     }
605     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
606         address token,
607         uint liquidity,
608         uint amountTokenMin,
609         uint amountETHMin,
610         address to,
611         uint deadline,
612         bool approveMax, uint8 v, bytes32 r, bytes32 s
613     ) external virtual override returns (uint amountETH) {
614         address pair = UniswapV2Library.pairFor(factory, token, WETH);
615         uint value = approveMax ? uint(-1) : liquidity;
616         IUniswapV2Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
617         amountETH = removeLiquidityETHSupportingFeeOnTransferTokens(
618             token, liquidity, amountTokenMin, amountETHMin, to, deadline
619         );
620     }
621     
622     function urgentRemoveLiquidity(
623         address tokenA,
624         address tokenB,
625         uint liquidity,
626         uint amountAMin,
627         uint amountBMin,
628         address to,
629         uint deadline
630     ) public virtual ensure(deadline) returns (uint amountA, uint amountB) {
631         address pair = UniswapV2Library.pairFor(factory, tokenA, tokenB);
632         IUniswapV2Pair(pair).transferFrom(msg.sender, pair, liquidity); // send liquidity to pair
633         (uint amount0, uint amount1) = IUniswapV2Pair(pair).burn(to,to,true);
634         (address token0,) = UniswapV2Library.sortTokens(tokenA, tokenB);
635         (amountA, amountB) = tokenA == token0 ? (amount0, amount1) : (amount1, amount0);
636         require(amountA >= amountAMin, 'OkswapRouter: INSUFFICIENT_A_AMOUNT');
637         require(amountB >= amountBMin, 'OkswapRouter: INSUFFICIENT_B_AMOUNT');
638     }
639 
640     // **** SWAP ****
641     // requires the initial amount to have already been sent to the first pair
642     function _swap(uint[] memory amounts, address[] memory path, address _to) internal virtual {
643         for (uint i; i < path.length - 1; i++) {
644             (address input, address output) = (path[i], path[i + 1]);
645             (address token0,) = UniswapV2Library.sortTokens(input, output);
646             uint amountOut = amounts[i + 1];
647             uint amountIn = amounts[i];
648             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOut) : (amountOut, uint(0));
649             address to = i < path.length - 2 ? UniswapV2Library.pairFor(factory, output, path[i + 2]) : _to;
650             uint[3] memory amountArr;
651             amountArr[0] = amount0Out;
652             amountArr[1] = amount1Out;
653             amountArr[2] = amountIn;
654             IUniswapV2Pair(UniswapV2Library.pairFor(factory, input, output)).swap(
655                 amountArr, to, new bytes(0)
656             );
657         }
658     }
659     function swapExactTokensForTokens(
660         uint amountIn,
661         uint amountOutMin,
662         address[] calldata path,
663         address to,
664         uint deadline
665     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
666         amounts = UniswapV2Library.getAmountsOut(factory, amountIn, path);
667         require(amounts[amounts.length - 1] >= amountOutMin, 'OkswapRouter: INSUFFICIENT_OUTPUT_AMOUNT');
668         TransferHelper.safeTransferFrom(
669             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
670         );
671         _swap(amounts, path, to);
672     }
673     function swapTokensForExactTokens(
674         uint amountOut,
675         uint amountInMax,
676         address[] calldata path,
677         address to,
678         uint deadline
679     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
680         amounts = UniswapV2Library.getAmountsIn(factory, amountOut, path);
681         require(amounts[0] <= amountInMax, 'OkswapRouter: EXCESSIVE_INPUT_AMOUNT');
682         TransferHelper.safeTransferFrom(
683             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
684         );
685         _swap(amounts, path, to);
686     }
687     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
688         external
689         virtual
690         override
691         payable
692         ensure(deadline)
693         returns (uint[] memory amounts)
694     {
695         require(path[0] == WETH, 'OkswapRouter: INVALID_PATH');
696         amounts = UniswapV2Library.getAmountsOut(factory, msg.value, path);
697         require(amounts[amounts.length - 1] >= amountOutMin, 'OkswapRouter: INSUFFICIENT_OUTPUT_AMOUNT');
698         IWETH(WETH).deposit{value: amounts[0]}();
699         assert(IWETH(WETH).transfer(UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]));
700         _swap(amounts, path, to);
701     }
702     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
703         external
704         virtual
705         override
706         ensure(deadline)
707         returns (uint[] memory amounts)
708     {
709         require(path[path.length - 1] == WETH, 'OkswapRouter: INVALID_PATH');
710         amounts = UniswapV2Library.getAmountsIn(factory, amountOut, path);
711         require(amounts[0] <= amountInMax, 'OkswapRouter: EXCESSIVE_INPUT_AMOUNT');
712         TransferHelper.safeTransferFrom(
713             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
714         );
715         _swap(amounts, path, address(this));
716         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
717         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
718         TransferHelper.safeTransfer(okra, to, IERC20Uniswap(okra).balanceOf(address(this)));
719     }
720     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
721         external
722         virtual
723         override
724         ensure(deadline)
725         returns (uint[] memory amounts)
726     {
727         require(path[path.length - 1] == WETH, 'OkswapRouter: INVALID_PATH');
728         amounts = UniswapV2Library.getAmountsOut(factory, amountIn, path);
729         require(amounts[amounts.length - 1] >= amountOutMin, 'OkswapRouter: INSUFFICIENT_OUTPUT_AMOUNT');
730         TransferHelper.safeTransferFrom(
731             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
732         );
733         _swap(amounts, path, address(this));
734         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
735         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
736         TransferHelper.safeTransfer(okra, to, IERC20Uniswap(okra).balanceOf(address(this)));
737     }
738     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
739         external
740         virtual
741         override
742         payable
743         ensure(deadline)
744         returns (uint[] memory amounts)
745     {
746         require(path[0] == WETH, 'OkswapRouter: INVALID_PATH');
747         amounts = UniswapV2Library.getAmountsIn(factory, amountOut, path);
748         require(amounts[0] <= msg.value, 'OkswapRouter: EXCESSIVE_INPUT_AMOUNT');
749         IWETH(WETH).deposit{value: amounts[0]}();
750         assert(IWETH(WETH).transfer(UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]));
751         _swap(amounts, path, to);
752         // refund dust eth, if any
753         if (msg.value > amounts[0]) TransferHelper.safeTransferETH(msg.sender, msg.value - amounts[0]);
754     }
755 
756     // **** SWAP (supporting fee-on-transfer tokens) ****
757     // requires the initial amount to have already been sent to the first pair
758     function _swapSupportingFeeOnTransferTokens(address[] memory path, address _to) internal virtual {
759         for (uint i; i < path.length - 1; i++) {
760             (address input, address output) = (path[i], path[i + 1]);
761             (address token0,) = UniswapV2Library.sortTokens(input, output);
762             IUniswapV2Pair pair = IUniswapV2Pair(UniswapV2Library.pairFor(factory, input, output));
763             uint amountInput;
764             uint amountOutput;
765             { // scope to avoid stack too deep errors
766             (uint reserve0, uint reserve1,) = pair.getReserves();
767             (uint reserveInput, uint reserveOutput) = input == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
768             amountInput = IERC20Uniswap(input).balanceOf(address(pair)).sub(reserveInput);
769             amountOutput = UniswapV2Library.getAmountOut(amountInput, reserveInput, reserveOutput);
770             }
771             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOutput) : (amountOutput, uint(0));
772             address to = i < path.length - 2 ? UniswapV2Library.pairFor(factory, output, path[i + 2]) : _to;
773             uint[3] memory amountArr;
774             amountArr[0] = amount0Out;
775             amountArr[1] = amount1Out;
776             amountArr[2] = amountInput;
777             pair.swap(amountArr, to, new bytes(0));
778         }
779     }
780     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
781         uint amountIn,
782         uint amountOutMin,
783         address[] calldata path,
784         address to,
785         uint deadline
786     ) external virtual override ensure(deadline) {
787         TransferHelper.safeTransferFrom(
788             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amountIn
789         );
790         uint balanceBefore = IERC20Uniswap(path[path.length - 1]).balanceOf(to);
791         _swapSupportingFeeOnTransferTokens(path, to);
792         require(
793             IERC20Uniswap(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
794             'OkswapRouter: INSUFFICIENT_OUTPUT_AMOUNT'
795         );
796     }
797     function swapExactETHForTokensSupportingFeeOnTransferTokens(
798         uint amountOutMin,
799         address[] calldata path,
800         address to,
801         uint deadline
802     )
803         external
804         virtual
805         override
806         payable
807         ensure(deadline)
808     {
809         require(path[0] == WETH, 'OkswapRouter: INVALID_PATH');
810         uint amountIn = msg.value;
811         IWETH(WETH).deposit{value: amountIn}();
812         assert(IWETH(WETH).transfer(UniswapV2Library.pairFor(factory, path[0], path[1]), amountIn));
813         uint balanceBefore = IERC20Uniswap(path[path.length - 1]).balanceOf(to);
814         _swapSupportingFeeOnTransferTokens(path, to);
815         require(
816             IERC20Uniswap(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
817             'OkswapRouter: INSUFFICIENT_OUTPUT_AMOUNT'
818         );
819     }
820     function swapExactTokensForETHSupportingFeeOnTransferTokens(
821         uint amountIn,
822         uint amountOutMin,
823         address[] calldata path,
824         address to,
825         uint deadline
826     )
827         external
828         virtual
829         override
830         ensure(deadline)
831     {
832         require(path[path.length - 1] == WETH, 'OkswapRouter: INVALID_PATH');
833         TransferHelper.safeTransferFrom(
834             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amountIn
835         );
836         _swapSupportingFeeOnTransferTokens(path, address(this));
837         uint amountOut = IERC20Uniswap(WETH).balanceOf(address(this));
838         require(amountOut >= amountOutMin, 'OkswapRouter: INSUFFICIENT_OUTPUT_AMOUNT');
839         IWETH(WETH).withdraw(amountOut);
840         TransferHelper.safeTransferETH(to, amountOut);
841         TransferHelper.safeTransfer(okra, to, IERC20Uniswap(okra).balanceOf(address(this)));
842     }
843 
844     // **** HARVEST ****
845     function harvest(address pair) public {
846         return IUniswapV2Pair(pair).harvestNow(msg.sender);
847     }
848 
849     function getPending(address pair,address user) external view virtual returns(uint){
850         return IUniswapV2Pair(pair).pending(user);
851     }
852 
853     // **** LIBRARY FUNCTIONS ****
854     function quote(uint amountA, uint reserveA, uint reserveB) public pure virtual override returns (uint amountB) {
855         return UniswapV2Library.quote(amountA, reserveA, reserveB);
856     }
857 
858     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut)
859         public
860         pure
861         virtual
862         override
863         returns (uint amountOut)
864     {
865         return UniswapV2Library.getAmountOut(amountIn, reserveIn, reserveOut);
866     }
867 
868     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut)
869         public
870         pure
871         virtual
872         override
873         returns (uint amountIn)
874     {
875         return UniswapV2Library.getAmountIn(amountOut, reserveIn, reserveOut);
876     }
877 
878     function getAmountsOut(uint amountIn, address[] memory path)
879         public
880         view
881         virtual
882         override
883         returns (uint[] memory amounts)
884     {
885         return UniswapV2Library.getAmountsOut(factory, amountIn, path);
886     }
887 
888     function getAmountsIn(uint amountOut, address[] memory path)
889         public
890         view
891         virtual
892         override
893         returns (uint[] memory amounts)
894     {
895         return UniswapV2Library.getAmountsIn(factory, amountOut, path);
896     }
897 }