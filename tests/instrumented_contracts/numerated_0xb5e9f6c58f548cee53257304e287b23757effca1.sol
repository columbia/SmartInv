1 // Sources flattened with hardhat v2.6.6 https://hardhat.org
2 
3 // File contracts/elk-core/interfaces/IElkFactory.sol
4 
5 pragma solidity >=0.5.0;
6 
7 interface IElkFactory {
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
22 
23 
24 // File contracts/elk-lib/libraries/TransferHelper.sol
25 
26 
27 pragma solidity >=0.6.0;
28 
29 // helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
30 library TransferHelper {
31     function safeApprove(
32         address token,
33         address to,
34         uint256 value
35     ) internal {
36         // bytes4(keccak256(bytes('approve(address,uint256)')));
37         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
38         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
39     }
40 
41     function safeTransfer(
42         address token,
43         address to,
44         uint256 value
45     ) internal {
46         // bytes4(keccak256(bytes('transfer(address,uint256)')));
47         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
48         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
49     }
50 
51     function safeTransferFrom(
52         address token,
53         address from,
54         address to,
55         uint256 value
56     ) internal {
57         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
58         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
59         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
60     }
61 
62     function safeTransferETH(address to, uint256 value) internal {
63         (bool success, ) = to.call{value: value}(new bytes(0));
64         require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
65     }
66 }
67 
68 
69 // File contracts/elk-periphery/interfaces/IElkRouter.sol
70 
71 pragma solidity >=0.6.2;
72 
73 interface IElkRouter {
74     function factory() external pure returns (address);
75     function WETH() external pure returns (address);
76 
77     function addLiquidity(
78         address tokenA,
79         address tokenB,
80         uint amountADesired,
81         uint amountBDesired,
82         uint amountAMin,
83         uint amountBMin,
84         address to,
85         uint deadline
86     ) external returns (uint amountA, uint amountB, uint liquidity);
87     function addLiquidityETH(
88         address token,
89         uint amountTokenDesired,
90         uint amountTokenMin,
91         uint amountETHMin,
92         address to,
93         uint deadline
94     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
95     function removeLiquidity(
96         address tokenA,
97         address tokenB,
98         uint liquidity,
99         uint amountAMin,
100         uint amountBMin,
101         address to,
102         uint deadline
103     ) external returns (uint amountA, uint amountB);
104     function removeLiquidityETH(
105         address token,
106         uint liquidity,
107         uint amountTokenMin,
108         uint amountETHMin,
109         address to,
110         uint deadline
111     ) external returns (uint amountToken, uint amountETH);
112     function removeLiquidityWithPermit(
113         address tokenA,
114         address tokenB,
115         uint liquidity,
116         uint amountAMin,
117         uint amountBMin,
118         address to,
119         uint deadline,
120         bool approveMax, uint8 v, bytes32 r, bytes32 s
121     ) external returns (uint amountA, uint amountB);
122     function removeLiquidityETHWithPermit(
123         address token,
124         uint liquidity,
125         uint amountTokenMin,
126         uint amountETHMin,
127         address to,
128         uint deadline,
129         bool approveMax, uint8 v, bytes32 r, bytes32 s
130     ) external returns (uint amountToken, uint amountETH);
131     function swapExactTokensForTokens(
132         uint amountIn,
133         uint amountOutMin,
134         address[] calldata path,
135         address to,
136         uint deadline
137     ) external returns (uint[] memory amounts);
138     function swapTokensForExactTokens(
139         uint amountOut,
140         uint amountInMax,
141         address[] calldata path,
142         address to,
143         uint deadline
144     ) external returns (uint[] memory amounts);
145     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
146         external
147         payable
148         returns (uint[] memory amounts);
149     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
150         external
151         returns (uint[] memory amounts);
152     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
153         external
154         returns (uint[] memory amounts);
155     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
156         external
157         payable
158         returns (uint[] memory amounts);
159 
160     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
161     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
162     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
163     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
164     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
165 
166     function removeLiquidityETHSupportingFeeOnTransferTokens(
167         address token,
168         uint liquidity,
169         uint amountTokenMin,
170         uint amountETHMin,
171         address to,
172         uint deadline
173     ) external returns (uint amountETH);
174     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
175         address token,
176         uint liquidity,
177         uint amountTokenMin,
178         uint amountETHMin,
179         address to,
180         uint deadline,
181         bool approveMax, uint8 v, bytes32 r, bytes32 s
182     ) external returns (uint amountETH);
183 
184     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
185         uint amountIn,
186         uint amountOutMin,
187         address[] calldata path,
188         address to,
189         uint deadline
190     ) external;
191     function swapExactETHForTokensSupportingFeeOnTransferTokens(
192         uint amountOutMin,
193         address[] calldata path,
194         address to,
195         uint deadline
196     ) external payable;
197     function swapExactTokensForETHSupportingFeeOnTransferTokens(
198         uint amountIn,
199         uint amountOutMin,
200         address[] calldata path,
201         address to,
202         uint deadline
203     ) external;
204 }
205 
206 
207 // File contracts/elk-core/interfaces/IElkPair.sol
208 
209 pragma solidity >=0.5.0;
210 
211 interface IElkPair {
212     event Approval(address indexed owner, address indexed spender, uint value);
213     event Transfer(address indexed from, address indexed to, uint value);
214 
215     function name() external pure returns (string memory);
216     function symbol() external pure returns (string memory);
217     function decimals() external pure returns (uint8);
218     function totalSupply() external view returns (uint);
219     function balanceOf(address owner) external view returns (uint);
220     function allowance(address owner, address spender) external view returns (uint);
221 
222     function approve(address spender, uint value) external returns (bool);
223     function transfer(address to, uint value) external returns (bool);
224     function transferFrom(address from, address to, uint value) external returns (bool);
225 
226     function DOMAIN_SEPARATOR() external view returns (bytes32);
227     function PERMIT_TYPEHASH() external pure returns (bytes32);
228     function nonces(address owner) external view returns (uint);
229 
230     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
231 
232     event Mint(address indexed sender, uint amount0, uint amount1);
233     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
234     event Swap(
235         address indexed sender,
236         uint amount0In,
237         uint amount1In,
238         uint amount0Out,
239         uint amount1Out,
240         address indexed to
241     );
242     event Sync(uint112 reserve0, uint112 reserve1);
243 
244     function MINIMUM_LIQUIDITY() external pure returns (uint);
245     function factory() external view returns (address);
246     function token0() external view returns (address);
247     function token1() external view returns (address);
248     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
249     function price0CumulativeLast() external view returns (uint);
250     function price1CumulativeLast() external view returns (uint);
251     function kLast() external view returns (uint);
252 
253     function mint(address to) external returns (uint liquidity);
254     function burn(address to) external returns (uint amount0, uint amount1);
255     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
256     function skim(address to) external;
257     function sync() external;
258 
259     function initialize(address, address) external;
260 }
261 
262 
263 // File contracts/elk-periphery/libraries/SafeMath.sol
264 
265 pragma solidity =0.6.6;
266 
267 // a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)
268 
269 library SafeMath {
270     function add(uint x, uint y) internal pure returns (uint z) {
271         require((z = x + y) >= x, 'ds-math-add-overflow');
272     }
273 
274     function sub(uint x, uint y) internal pure returns (uint z) {
275         require((z = x - y) <= x, 'ds-math-sub-underflow');
276     }
277 
278     function mul(uint x, uint y) internal pure returns (uint z) {
279         require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');
280     }
281 }
282 
283 
284 // File contracts/elk-periphery/libraries/ElkLibrary.sol
285 
286 pragma solidity >=0.5.0;
287 
288 
289 library ElkLibrary {
290     using SafeMath for uint;
291 
292     // returns sorted token addresses, used to handle return values from pairs sorted in this order
293     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
294         require(tokenA != tokenB, 'ElkLibrary: IDENTICAL_ADDRESSES');
295         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
296         require(token0 != address(0), 'ElkLibrary: ZERO_ADDRESS');
297     }
298 
299     // calculates the CREATE2 address for a pair without making any external calls
300     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
301         (address token0, address token1) = sortTokens(tokenA, tokenB);
302         pair = address(uint(keccak256(abi.encodePacked(
303                 hex'ff',
304                 factory,
305                 keccak256(abi.encodePacked(token0, token1)),
306                 hex'84845e7ccb283dec564acfcd3d9287a491dec6d675705545a2ab8be22ad78f31' // init code hash
307             ))));
308     }
309 
310     // fetches and sorts the reserves for a pair
311     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
312         (address token0,) = sortTokens(tokenA, tokenB);
313         (uint reserve0, uint reserve1,) = IElkPair(pairFor(factory, tokenA, tokenB)).getReserves();
314         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
315     }
316 
317     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
318     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
319         require(amountA > 0, 'ElkLibrary: INSUFFICIENT_AMOUNT');
320         require(reserveA > 0 && reserveB > 0, 'ElkLibrary: INSUFFICIENT_LIQUIDITY');
321         amountB = amountA.mul(reserveB) / reserveA;
322     }
323 
324     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
325     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
326         require(amountIn > 0, 'ElkLibrary: INSUFFICIENT_INPUT_AMOUNT');
327         require(reserveIn > 0 && reserveOut > 0, 'ElkLibrary: INSUFFICIENT_LIQUIDITY');
328         uint amountInWithFee = amountIn.mul(997);
329         uint numerator = amountInWithFee.mul(reserveOut);
330         uint denominator = reserveIn.mul(1000).add(amountInWithFee);
331         amountOut = numerator / denominator;
332     }
333 
334     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
335     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {
336         require(amountOut > 0, 'ElkLibrary: INSUFFICIENT_OUTPUT_AMOUNT');
337         require(reserveIn > 0 && reserveOut > 0, 'ElkLibrary: INSUFFICIENT_LIQUIDITY');
338         uint numerator = reserveIn.mul(amountOut).mul(1000);
339         uint denominator = reserveOut.sub(amountOut).mul(997);
340         amountIn = (numerator / denominator).add(1);
341     }
342 
343     // performs chained getAmountOut calculations on any number of pairs
344     function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {
345         require(path.length >= 2, 'ElkLibrary: INVALID_PATH');
346         amounts = new uint[](path.length);
347         amounts[0] = amountIn;
348         for (uint i; i < path.length - 1; i++) {
349             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);
350             amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
351         }
352     }
353 
354     // performs chained getAmountIn calculations on any number of pairs
355     function getAmountsIn(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {
356         require(path.length >= 2, 'ElkLibrary: INVALID_PATH');
357         amounts = new uint[](path.length);
358         amounts[amounts.length - 1] = amountOut;
359         for (uint i = path.length - 1; i > 0; i--) {
360             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);
361             amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
362         }
363     }
364 }
365 
366 
367 // File contracts/elk-periphery/interfaces/IERC20.sol
368 
369 pragma solidity >=0.5.0;
370 
371 interface IERC20 {
372     event Approval(address indexed owner, address indexed spender, uint value);
373     event Transfer(address indexed from, address indexed to, uint value);
374 
375     function name() external view returns (string memory);
376     function symbol() external view returns (string memory);
377     function decimals() external view returns (uint8);
378     function totalSupply() external view returns (uint);
379     function balanceOf(address owner) external view returns (uint);
380     function allowance(address owner, address spender) external view returns (uint);
381 
382     function approve(address spender, uint value) external returns (bool);
383     function transfer(address to, uint value) external returns (bool);
384     function transferFrom(address from, address to, uint value) external returns (bool);
385 }
386 
387 
388 // File contracts/elk-periphery/interfaces/IWETH.sol
389 
390 pragma solidity >=0.5.0;
391 
392 interface IWETH {
393     function deposit() external payable;
394     function transfer(address to, uint value) external returns (bool);
395     function withdraw(uint) external;
396 }
397 
398 
399 // File contracts/elk-periphery/ElkRouter.sol
400 
401 pragma solidity =0.6.6;
402 
403 
404 
405 
406 
407 
408 contract ElkRouter is IElkRouter {
409     using SafeMath for uint;
410 
411     address public immutable override factory;
412     address public immutable override WETH;
413 
414     modifier ensure(uint deadline) {
415         require(deadline >= block.timestamp, 'ElkRouter: EXPIRED');
416         _;
417     }
418 
419     constructor(address _factory, address _WETH) public {
420         factory = _factory;
421         WETH = _WETH;
422     }
423 
424     receive() external payable {
425         assert(msg.sender == WETH); // only accept ETH via fallback from the WETH contract
426     }
427 
428     // **** ADD LIQUIDITY ****
429     function _addLiquidity(
430         address tokenA,
431         address tokenB,
432         uint amountADesired,
433         uint amountBDesired,
434         uint amountAMin,
435         uint amountBMin
436     ) internal virtual returns (uint amountA, uint amountB) {
437         // create the pair if it doesn't exist yet
438         if (IElkFactory(factory).getPair(tokenA, tokenB) == address(0)) {
439             IElkFactory(factory).createPair(tokenA, tokenB);
440         }
441         (uint reserveA, uint reserveB) = ElkLibrary.getReserves(factory, tokenA, tokenB);
442         if (reserveA == 0 && reserveB == 0) {
443             (amountA, amountB) = (amountADesired, amountBDesired);
444         } else {
445             uint amountBOptimal = ElkLibrary.quote(amountADesired, reserveA, reserveB);
446             if (amountBOptimal <= amountBDesired) {
447                 require(amountBOptimal >= amountBMin, 'ElkRouter: INSUFFICIENT_B_AMOUNT');
448                 (amountA, amountB) = (amountADesired, amountBOptimal);
449             } else {
450                 uint amountAOptimal = ElkLibrary.quote(amountBDesired, reserveB, reserveA);
451                 assert(amountAOptimal <= amountADesired);
452                 require(amountAOptimal >= amountAMin, 'ElkRouter: INSUFFICIENT_A_AMOUNT');
453                 (amountA, amountB) = (amountAOptimal, amountBDesired);
454             }
455         }
456     }
457     function addLiquidity(
458         address tokenA,
459         address tokenB,
460         uint amountADesired,
461         uint amountBDesired,
462         uint amountAMin,
463         uint amountBMin,
464         address to,
465         uint deadline
466     ) external virtual override ensure(deadline) returns (uint amountA, uint amountB, uint liquidity) {
467         (amountA, amountB) = _addLiquidity(tokenA, tokenB, amountADesired, amountBDesired, amountAMin, amountBMin);
468         address pair = ElkLibrary.pairFor(factory, tokenA, tokenB);
469         TransferHelper.safeTransferFrom(tokenA, msg.sender, pair, amountA);
470         TransferHelper.safeTransferFrom(tokenB, msg.sender, pair, amountB);
471         liquidity = IElkPair(pair).mint(to);
472     }
473     function addLiquidityETH(
474         address token,
475         uint amountTokenDesired,
476         uint amountTokenMin,
477         uint amountETHMin,
478         address to,
479         uint deadline
480     ) external virtual override payable ensure(deadline) returns (uint amountToken, uint amountETH, uint liquidity) {
481         (amountToken, amountETH) = _addLiquidity(
482             token,
483             WETH,
484             amountTokenDesired,
485             msg.value,
486             amountTokenMin,
487             amountETHMin
488         );
489         address pair = ElkLibrary.pairFor(factory, token, WETH);
490         TransferHelper.safeTransferFrom(token, msg.sender, pair, amountToken);
491         IWETH(WETH).deposit{value: amountETH}();
492         assert(IWETH(WETH).transfer(pair, amountETH));
493         liquidity = IElkPair(pair).mint(to);
494         // refund dust ETH, if any
495         if (msg.value > amountETH) TransferHelper.safeTransferETH(msg.sender, msg.value - amountETH);
496     }
497 
498     // **** REMOVE LIQUIDITY ****
499     function removeLiquidity(
500         address tokenA,
501         address tokenB,
502         uint liquidity,
503         uint amountAMin,
504         uint amountBMin,
505         address to,
506         uint deadline
507     ) public virtual override ensure(deadline) returns (uint amountA, uint amountB) {
508         address pair = ElkLibrary.pairFor(factory, tokenA, tokenB);
509         IElkPair(pair).transferFrom(msg.sender, pair, liquidity); // send liquidity to pair
510         (uint amount0, uint amount1) = IElkPair(pair).burn(to);
511         (address token0,) = ElkLibrary.sortTokens(tokenA, tokenB);
512         (amountA, amountB) = tokenA == token0 ? (amount0, amount1) : (amount1, amount0);
513         require(amountA >= amountAMin, 'ElkRouter: INSUFFICIENT_A_AMOUNT');
514         require(amountB >= amountBMin, 'ElkRouter: INSUFFICIENT_B_AMOUNT');
515     }
516     function removeLiquidityETH(
517         address token,
518         uint liquidity,
519         uint amountTokenMin,
520         uint amountETHMin,
521         address to,
522         uint deadline
523     ) public virtual override ensure(deadline) returns (uint amountToken, uint amountETH) {
524         (amountToken, amountETH) = removeLiquidity(
525             token,
526             WETH,
527             liquidity,
528             amountTokenMin,
529             amountETHMin,
530             address(this),
531             deadline
532         );
533         TransferHelper.safeTransfer(token, to, amountToken);
534         IWETH(WETH).withdraw(amountETH);
535         TransferHelper.safeTransferETH(to, amountETH);
536     }
537     function removeLiquidityWithPermit(
538         address tokenA,
539         address tokenB,
540         uint liquidity,
541         uint amountAMin,
542         uint amountBMin,
543         address to,
544         uint deadline,
545         bool approveMax, uint8 v, bytes32 r, bytes32 s
546     ) external virtual override returns (uint amountA, uint amountB) {
547         address pair = ElkLibrary.pairFor(factory, tokenA, tokenB);
548         uint value = approveMax ? uint(-1) : liquidity;
549         IElkPair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
550         (amountA, amountB) = removeLiquidity(tokenA, tokenB, liquidity, amountAMin, amountBMin, to, deadline);
551     }
552     function removeLiquidityETHWithPermit(
553         address token,
554         uint liquidity,
555         uint amountTokenMin,
556         uint amountETHMin,
557         address to,
558         uint deadline,
559         bool approveMax, uint8 v, bytes32 r, bytes32 s
560     ) external virtual override returns (uint amountToken, uint amountETH) {
561         address pair = ElkLibrary.pairFor(factory, token, WETH);
562         uint value = approveMax ? uint(-1) : liquidity;
563         IElkPair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
564         (amountToken, amountETH) = removeLiquidityETH(token, liquidity, amountTokenMin, amountETHMin, to, deadline);
565     }
566 
567     // **** REMOVE LIQUIDITY (supporting fee-on-transfer tokens) ****
568     function removeLiquidityETHSupportingFeeOnTransferTokens(
569         address token,
570         uint liquidity,
571         uint amountTokenMin,
572         uint amountETHMin,
573         address to,
574         uint deadline
575     ) public virtual override ensure(deadline) returns (uint amountETH) {
576         (, amountETH) = removeLiquidity(
577             token,
578             WETH,
579             liquidity,
580             amountTokenMin,
581             amountETHMin,
582             address(this),
583             deadline
584         );
585         TransferHelper.safeTransfer(token, to, IERC20(token).balanceOf(address(this)));
586         IWETH(WETH).withdraw(amountETH);
587         TransferHelper.safeTransferETH(to, amountETH);
588     }
589     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
590         address token,
591         uint liquidity,
592         uint amountTokenMin,
593         uint amountETHMin,
594         address to,
595         uint deadline,
596         bool approveMax, uint8 v, bytes32 r, bytes32 s
597     ) external virtual override returns (uint amountETH) {
598         address pair = ElkLibrary.pairFor(factory, token, WETH);
599         uint value = approveMax ? uint(-1) : liquidity;
600         IElkPair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
601         amountETH = removeLiquidityETHSupportingFeeOnTransferTokens(
602             token, liquidity, amountTokenMin, amountETHMin, to, deadline
603         );
604     }
605 
606     // **** SWAP ****
607     // requires the initial amount to have already been sent to the first pair
608     function _swap(uint[] memory amounts, address[] memory path, address _to) internal virtual {
609         for (uint i; i < path.length - 1; i++) {
610             (address input, address output) = (path[i], path[i + 1]);
611             (address token0,) = ElkLibrary.sortTokens(input, output);
612             uint amountOut = amounts[i + 1];
613             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOut) : (amountOut, uint(0));
614             address to = i < path.length - 2 ? ElkLibrary.pairFor(factory, output, path[i + 2]) : _to;
615             IElkPair(ElkLibrary.pairFor(factory, input, output)).swap(
616                 amount0Out, amount1Out, to, new bytes(0)
617             );
618         }
619     }
620     function swapExactTokensForTokens(
621         uint amountIn,
622         uint amountOutMin,
623         address[] calldata path,
624         address to,
625         uint deadline
626     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
627         amounts = ElkLibrary.getAmountsOut(factory, amountIn, path);
628         require(amounts[amounts.length - 1] >= amountOutMin, 'ElkRouter: INSUFFICIENT_OUTPUT_AMOUNT');
629         TransferHelper.safeTransferFrom(
630             path[0], msg.sender, ElkLibrary.pairFor(factory, path[0], path[1]), amounts[0]
631         );
632         _swap(amounts, path, to);
633     }
634     function swapTokensForExactTokens(
635         uint amountOut,
636         uint amountInMax,
637         address[] calldata path,
638         address to,
639         uint deadline
640     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
641         amounts = ElkLibrary.getAmountsIn(factory, amountOut, path);
642         require(amounts[0] <= amountInMax, 'ElkRouter: EXCESSIVE_INPUT_AMOUNT');
643         TransferHelper.safeTransferFrom(
644             path[0], msg.sender, ElkLibrary.pairFor(factory, path[0], path[1]), amounts[0]
645         );
646         _swap(amounts, path, to);
647     }
648     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
649         external
650         virtual
651         override
652         payable
653         ensure(deadline)
654         returns (uint[] memory amounts)
655     {
656         require(path[0] == WETH, 'ElkRouter: INVALID_PATH');
657         amounts = ElkLibrary.getAmountsOut(factory, msg.value, path);
658         require(amounts[amounts.length - 1] >= amountOutMin, 'ElkRouter: INSUFFICIENT_OUTPUT_AMOUNT');
659         IWETH(WETH).deposit{value: amounts[0]}();
660         assert(IWETH(WETH).transfer(ElkLibrary.pairFor(factory, path[0], path[1]), amounts[0]));
661         _swap(amounts, path, to);
662     }
663     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
664         external
665         virtual
666         override
667         ensure(deadline)
668         returns (uint[] memory amounts)
669     {
670         require(path[path.length - 1] == WETH, 'ElkRouter: INVALID_PATH');
671         amounts = ElkLibrary.getAmountsIn(factory, amountOut, path);
672         require(amounts[0] <= amountInMax, 'ElkRouter: EXCESSIVE_INPUT_AMOUNT');
673         TransferHelper.safeTransferFrom(
674             path[0], msg.sender, ElkLibrary.pairFor(factory, path[0], path[1]), amounts[0]
675         );
676         _swap(amounts, path, address(this));
677         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
678         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
679     }
680     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
681         external
682         virtual
683         override
684         ensure(deadline)
685         returns (uint[] memory amounts)
686     {
687         require(path[path.length - 1] == WETH, 'ElkRouter: INVALID_PATH');
688         amounts = ElkLibrary.getAmountsOut(factory, amountIn, path);
689         require(amounts[amounts.length - 1] >= amountOutMin, 'ElkRouter: INSUFFICIENT_OUTPUT_AMOUNT');
690         TransferHelper.safeTransferFrom(
691             path[0], msg.sender, ElkLibrary.pairFor(factory, path[0], path[1]), amounts[0]
692         );
693         _swap(amounts, path, address(this));
694         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
695         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
696     }
697     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
698         external
699         virtual
700         override
701         payable
702         ensure(deadline)
703         returns (uint[] memory amounts)
704     {
705         require(path[0] == WETH, 'ElkRouter: INVALID_PATH');
706         amounts = ElkLibrary.getAmountsIn(factory, amountOut, path);
707         require(amounts[0] <= msg.value, 'ElkRouter: EXCESSIVE_INPUT_AMOUNT');
708         IWETH(WETH).deposit{value: amounts[0]}();
709         assert(IWETH(WETH).transfer(ElkLibrary.pairFor(factory, path[0], path[1]), amounts[0]));
710         _swap(amounts, path, to);
711         // refund dust ETH, if any
712         if (msg.value > amounts[0]) TransferHelper.safeTransferETH(msg.sender, msg.value - amounts[0]);
713     }
714 
715     // **** SWAP (supporting fee-on-transfer tokens) ****
716     // requires the initial amount to have already been sent to the first pair
717     function _swapSupportingFeeOnTransferTokens(address[] memory path, address _to) internal virtual {
718         for (uint i; i < path.length - 1; i++) {
719             (address input, address output) = (path[i], path[i + 1]);
720             (address token0,) = ElkLibrary.sortTokens(input, output);
721             IElkPair pair = IElkPair(ElkLibrary.pairFor(factory, input, output));
722             uint amountInput;
723             uint amountOutput;
724             { // scope to avoid stack too deep errors
725             (uint reserve0, uint reserve1,) = pair.getReserves();
726             (uint reserveInput, uint reserveOutput) = input == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
727             amountInput = IERC20(input).balanceOf(address(pair)).sub(reserveInput);
728             amountOutput = ElkLibrary.getAmountOut(amountInput, reserveInput, reserveOutput);
729             }
730             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOutput) : (amountOutput, uint(0));
731             address to = i < path.length - 2 ? ElkLibrary.pairFor(factory, output, path[i + 2]) : _to;
732             pair.swap(amount0Out, amount1Out, to, new bytes(0));
733         }
734     }
735     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
736         uint amountIn,
737         uint amountOutMin,
738         address[] calldata path,
739         address to,
740         uint deadline
741     ) external virtual override ensure(deadline) {
742         TransferHelper.safeTransferFrom(
743             path[0], msg.sender, ElkLibrary.pairFor(factory, path[0], path[1]), amountIn
744         );
745         uint balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
746         _swapSupportingFeeOnTransferTokens(path, to);
747         require(
748             IERC20(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
749             'ElkRouter: INSUFFICIENT_OUTPUT_AMOUNT'
750         );
751     }
752     function swapExactETHForTokensSupportingFeeOnTransferTokens(
753         uint amountOutMin,
754         address[] calldata path,
755         address to,
756         uint deadline
757     )
758         external
759         virtual
760         override
761         payable
762         ensure(deadline)
763     {
764         require(path[0] == WETH, 'ElkRouter: INVALID_PATH');
765         uint amountIn = msg.value;
766         IWETH(WETH).deposit{value: amountIn}();
767         assert(IWETH(WETH).transfer(ElkLibrary.pairFor(factory, path[0], path[1]), amountIn));
768         uint balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
769         _swapSupportingFeeOnTransferTokens(path, to);
770         require(
771             IERC20(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
772             'ElkRouter: INSUFFICIENT_OUTPUT_AMOUNT'
773         );
774     }
775     function swapExactTokensForETHSupportingFeeOnTransferTokens(
776         uint amountIn,
777         uint amountOutMin,
778         address[] calldata path,
779         address to,
780         uint deadline
781     )
782         external
783         virtual
784         override
785         ensure(deadline)
786     {
787         require(path[path.length - 1] == WETH, 'ElkRouter: INVALID_PATH');
788         TransferHelper.safeTransferFrom(
789             path[0], msg.sender, ElkLibrary.pairFor(factory, path[0], path[1]), amountIn
790         );
791         _swapSupportingFeeOnTransferTokens(path, address(this));
792         uint amountOut = IERC20(WETH).balanceOf(address(this));
793         require(amountOut >= amountOutMin, 'ElkRouter: INSUFFICIENT_OUTPUT_AMOUNT');
794         IWETH(WETH).withdraw(amountOut);
795         TransferHelper.safeTransferETH(to, amountOut);
796     }
797 
798     // **** LIBRARY FUNCTIONS ****
799     function quote(uint amountA, uint reserveA, uint reserveB) public pure virtual override returns (uint amountB) {
800         return ElkLibrary.quote(amountA, reserveA, reserveB);
801     }
802 
803     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut)
804         public
805         pure
806         virtual
807         override
808         returns (uint amountOut)
809     {
810         return ElkLibrary.getAmountOut(amountIn, reserveIn, reserveOut);
811     }
812 
813     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut)
814         public
815         pure
816         virtual
817         override
818         returns (uint amountIn)
819     {
820         return ElkLibrary.getAmountIn(amountOut, reserveIn, reserveOut);
821     }
822 
823     function getAmountsOut(uint amountIn, address[] memory path)
824         public
825         view
826         virtual
827         override
828         returns (uint[] memory amounts)
829     {
830         return ElkLibrary.getAmountsOut(factory, amountIn, path);
831     }
832 
833     function getAmountsIn(uint amountOut, address[] memory path)
834         public
835         view
836         virtual
837         override
838         returns (uint[] memory amounts)
839     {
840         return ElkLibrary.getAmountsIn(factory, amountOut, path);
841     }
842 }