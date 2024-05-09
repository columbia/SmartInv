1 // File: dxswap-core/contracts/interfaces/IDXswapFactory.sol
2 
3 pragma solidity >=0.5.0;
4 
5 interface IDXswapFactory {
6     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
7 
8     function INIT_CODE_PAIR_HASH() external pure returns (bytes32);
9     function feeTo() external view returns (address);
10     function protocolFeeDenominator() external view returns (uint8);
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
21     function setProtocolFee(uint8 _protocolFee) external;
22     function setSwapFee(address pair, uint32 swapFee) external;
23 }
24 
25 // File: contracts/libraries/TransferHelper.sol
26 
27 pragma solidity >=0.6.0;
28 
29 // helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
30 library TransferHelper {
31     function safeApprove(address token, address to, uint value) internal {
32         // bytes4(keccak256(bytes('approve(address,uint256)')));
33         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
34         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
35     }
36 
37     function safeTransfer(address token, address to, uint value) internal {
38         // bytes4(keccak256(bytes('transfer(address,uint256)')));
39         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
40         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
41     }
42 
43     function safeTransferFrom(address token, address from, address to, uint value) internal {
44         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
45         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
46         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
47     }
48 
49     function safeTransferETH(address to, uint value) internal {
50         (bool success,) = to.call{value:value}(new bytes(0));
51         require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
52     }
53 }
54 
55 // File: contracts/interfaces/IDXswapRouter.sol
56 
57 pragma solidity >=0.6.2;
58 
59 
60 interface IDXswapRouter {
61     function factory() external pure returns (address);
62     function WETH() external pure returns (address);
63 
64     function addLiquidity(
65         address tokenA,
66         address tokenB,
67         uint amountADesired,
68         uint amountBDesired,
69         uint amountAMin,
70         uint amountBMin,
71         address to,
72         uint deadline
73     ) external returns (uint amountA, uint amountB, uint liquidity);
74     function addLiquidityETH(
75         address token,
76         uint amountTokenDesired,
77         uint amountTokenMin,
78         uint amountETHMin,
79         address to,
80         uint deadline
81     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
82     function removeLiquidity(
83         address tokenA,
84         address tokenB,
85         uint liquidity,
86         uint amountAMin,
87         uint amountBMin,
88         address to,
89         uint deadline
90     ) external returns (uint amountA, uint amountB);
91     function removeLiquidityETH(
92         address token,
93         uint liquidity,
94         uint amountTokenMin,
95         uint amountETHMin,
96         address to,
97         uint deadline
98     ) external returns (uint amountToken, uint amountETH);
99     function removeLiquidityWithPermit(
100         address tokenA,
101         address tokenB,
102         uint liquidity,
103         uint amountAMin,
104         uint amountBMin,
105         address to,
106         uint deadline,
107         bool approveMax, uint8 v, bytes32 r, bytes32 s
108     ) external returns (uint amountA, uint amountB);
109     function removeLiquidityETHWithPermit(
110         address token,
111         uint liquidity,
112         uint amountTokenMin,
113         uint amountETHMin,
114         address to,
115         uint deadline,
116         bool approveMax, uint8 v, bytes32 r, bytes32 s
117     ) external returns (uint amountToken, uint amountETH);
118     function swapExactTokensForTokens(
119         uint amountIn,
120         uint amountOutMin,
121         address[] calldata path,
122         address to,
123         uint deadline
124     ) external returns (uint[] memory amounts);
125     function swapTokensForExactTokens(
126         uint amountOut,
127         uint amountInMax,
128         address[] calldata path,
129         address to,
130         uint deadline
131     ) external returns (uint[] memory amounts);
132     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
133         external
134         payable
135         returns (uint[] memory amounts);
136     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
137         external
138         returns (uint[] memory amounts);
139     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
140         external
141         returns (uint[] memory amounts);
142     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
143         external
144         payable
145         returns (uint[] memory amounts);
146 
147     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
148     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut, uint swapFee) external pure returns (uint amountOut);
149     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut, uint swapFee) external pure returns (uint amountIn);
150     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
151     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
152 
153     function removeLiquidityETHSupportingFeeOnTransferTokens(
154         address token,
155         uint liquidity,
156         uint amountTokenMin,
157         uint amountETHMin,
158         address to,
159         uint deadline
160     ) external returns (uint amountETH);
161     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
162         address token,
163         uint liquidity,
164         uint amountTokenMin,
165         uint amountETHMin,
166         address to,
167         uint deadline,
168         bool approveMax, uint8 v, bytes32 r, bytes32 s
169     ) external returns (uint amountETH);
170 
171     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
172         uint amountIn,
173         uint amountOutMin,
174         address[] calldata path,
175         address to,
176         uint deadline
177     ) external;
178     function swapExactETHForTokensSupportingFeeOnTransferTokens(
179         uint amountOutMin,
180         address[] calldata path,
181         address to,
182         uint deadline
183     ) external payable;
184     function swapExactTokensForETHSupportingFeeOnTransferTokens(
185         uint amountIn,
186         uint amountOutMin,
187         address[] calldata path,
188         address to,
189         uint deadline
190     ) external;
191 }
192 
193 // File: dxswap-core/contracts/interfaces/IDXswapPair.sol
194 
195 pragma solidity >=0.5.0;
196 
197 interface IDXswapPair {
198     event Approval(address indexed owner, address indexed spender, uint value);
199     event Transfer(address indexed from, address indexed to, uint value);
200 
201     function name() external pure returns (string memory);
202     function symbol() external pure returns (string memory);
203     function decimals() external pure returns (uint8);
204     function totalSupply() external view returns (uint);
205     function balanceOf(address owner) external view returns (uint);
206     function allowance(address owner, address spender) external view returns (uint);
207 
208     function approve(address spender, uint value) external returns (bool);
209     function transfer(address to, uint value) external returns (bool);
210     function transferFrom(address from, address to, uint value) external returns (bool);
211 
212     function DOMAIN_SEPARATOR() external view returns (bytes32);
213     function PERMIT_TYPEHASH() external pure returns (bytes32);
214     function nonces(address owner) external view returns (uint);
215 
216     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
217 
218     event Mint(address indexed sender, uint amount0, uint amount1);
219     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
220     event Swap(
221         address indexed sender,
222         uint amount0In,
223         uint amount1In,
224         uint amount0Out,
225         uint amount1Out,
226         address indexed to
227     );
228     event Sync(uint112 reserve0, uint112 reserve1);
229 
230     function MINIMUM_LIQUIDITY() external pure returns (uint);
231     function factory() external view returns (address);
232     function token0() external view returns (address);
233     function token1() external view returns (address);
234     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
235     function price0CumulativeLast() external view returns (uint);
236     function price1CumulativeLast() external view returns (uint);
237     function kLast() external view returns (uint);
238     function swapFee() external view returns (uint32);
239 
240     function mint(address to) external returns (uint liquidity);
241     function burn(address to) external returns (uint amount0, uint amount1);
242     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
243     function skim(address to) external;
244     function sync() external;
245 
246     function initialize(address, address) external;
247     function setSwapFee(uint32) external;
248 }
249 
250 // File: contracts/libraries/SafeMath.sol
251 
252 pragma solidity =0.6.6;
253 
254 // a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)
255 
256 library SafeMath {
257     function add(uint x, uint y) internal pure returns (uint z) {
258         require((z = x + y) >= x, 'ds-math-add-overflow');
259     }
260 
261     function sub(uint x, uint y) internal pure returns (uint z) {
262         require((z = x - y) <= x, 'ds-math-sub-underflow');
263     }
264 
265     function mul(uint x, uint y) internal pure returns (uint z) {
266         require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');
267     }
268 }
269 
270 // File: contracts/libraries/DXswapLibrary.sol
271 
272 pragma solidity >=0.5.0;
273 
274 
275 
276 library DXswapLibrary {
277     using SafeMath for uint;
278 
279     // returns sorted token addresses, used to handle return values from pairs sorted in this order
280     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
281         require(tokenA != tokenB, 'DXswapLibrary: IDENTICAL_ADDRESSES');
282         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
283         require(token0 != address(0), 'DXswapLibrary: ZERO_ADDRESS');
284     }
285 
286     // calculates the CREATE2 address for a pair without making any external calls
287     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
288         (address token0, address token1) = sortTokens(tokenA, tokenB);
289         pair = address(uint(keccak256(abi.encodePacked(
290             hex'ff',
291             factory,
292             keccak256(abi.encodePacked(token0, token1)),
293             hex'd306a548755b9295ee49cc729e13ca4a45e00199bbd890fa146da43a50571776' // init code hash
294         ))));
295     }
296 
297     // fetches and sorts the reserves for a pair
298     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
299         (address token0,) = sortTokens(tokenA, tokenB);
300         (uint reserve0, uint reserve1,) = IDXswapPair(pairFor(factory, tokenA, tokenB)).getReserves();
301         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
302     }
303     
304     // fetches and sorts the reserves for a pair
305     function getSwapFee(address factory, address tokenA, address tokenB) internal view returns (uint swapFee) {
306         (address token0,) = sortTokens(tokenA, tokenB);
307         swapFee = IDXswapPair(pairFor(factory, tokenA, tokenB)).swapFee();
308     }
309 
310     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
311     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
312         require(amountA > 0, 'DXswapLibrary: INSUFFICIENT_AMOUNT');
313         require(reserveA > 0 && reserveB > 0, 'DXswapLibrary: INSUFFICIENT_LIQUIDITY');
314         amountB = amountA.mul(reserveB) / reserveA;
315     }
316 
317     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
318     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut, uint swapFee) internal pure returns (uint amountOut) {
319         require(amountIn > 0, 'DXswapLibrary: INSUFFICIENT_INPUT_AMOUNT');
320         require(reserveIn > 0 && reserveOut > 0, 'DXswapLibrary: INSUFFICIENT_LIQUIDITY');
321         uint amountInWithFee = amountIn.mul(uint(10000).sub(swapFee));
322         uint numerator = amountInWithFee.mul(reserveOut);
323         uint denominator = reserveIn.mul(10000).add(amountInWithFee);
324         amountOut = numerator / denominator;
325     }
326 
327     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
328     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut, uint swapFee) internal pure returns (uint amountIn) {
329         require(amountOut > 0, 'DXswapLibrary: INSUFFICIENT_OUTPUT_AMOUNT');
330         require(reserveIn > 0 && reserveOut > 0, 'DXswapLibrary: INSUFFICIENT_LIQUIDITY');
331         uint numerator = reserveIn.mul(amountOut).mul(10000);
332         uint denominator = reserveOut.sub(amountOut).mul(uint(10000).sub(swapFee));
333         amountIn = (numerator / denominator).add(1);
334     }
335 
336     // performs chained getAmountOut calculations on any number of pairs
337     function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {
338         require(path.length >= 2, 'DXswapLibrary: INVALID_PATH');
339         amounts = new uint[](path.length);
340         amounts[0] = amountIn;
341         for (uint i; i < path.length - 1; i++) {
342             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);
343             amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut, getSwapFee(factory, path[i], path[i + 1]));
344         }
345     }
346 
347     // performs chained getAmountIn calculations on any number of pairs
348     function getAmountsIn(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {
349         require(path.length >= 2, 'DXswapLibrary: INVALID_PATH');
350         amounts = new uint[](path.length);
351         amounts[amounts.length - 1] = amountOut;
352         for (uint i = path.length - 1; i > 0; i--) {
353             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);
354             amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut, getSwapFee(factory, path[i - 1], path[i]));
355         }
356     }
357 }
358 
359 // File: contracts/interfaces/IERC20.sol
360 
361 pragma solidity >=0.5.0;
362 
363 interface IERC20 {
364     event Approval(address indexed owner, address indexed spender, uint value);
365     event Transfer(address indexed from, address indexed to, uint value);
366 
367     function name() external view returns (string memory);
368     function symbol() external view returns (string memory);
369     function decimals() external view returns (uint8);
370     function totalSupply() external view returns (uint);
371     function balanceOf(address owner) external view returns (uint);
372     function allowance(address owner, address spender) external view returns (uint);
373 
374     function approve(address spender, uint value) external returns (bool);
375     function transfer(address to, uint value) external returns (bool);
376     function transferFrom(address from, address to, uint value) external returns (bool);
377 }
378 
379 // File: contracts/interfaces/IWETH.sol
380 
381 pragma solidity >=0.5.0;
382 
383 interface IWETH {
384     function deposit() external payable;
385     function transfer(address to, uint value) external returns (bool);
386     function withdraw(uint) external;
387 }
388 
389 // File: contracts/DXswapRouter.sol
390 
391 pragma solidity =0.6.6;
392 
393 
394 
395 
396 
397 
398 
399 
400 contract DXswapRouter is IDXswapRouter {
401     using SafeMath for uint;
402 
403     address public immutable override factory;
404     address public immutable override WETH;
405 
406     modifier ensure(uint deadline) {
407         require(deadline >= block.timestamp, 'DXswapRouter: EXPIRED');
408         _;
409     }
410 
411     constructor(address _factory, address _WETH) public {
412         factory = _factory;
413         WETH = _WETH;
414     }
415 
416     receive() external payable {
417         assert(msg.sender == WETH); // only accept ETH via fallback from the WETH contract
418     }
419 
420     // **** ADD LIQUIDITY ****
421     function _addLiquidity(
422         address tokenA,
423         address tokenB,
424         uint amountADesired,
425         uint amountBDesired,
426         uint amountAMin,
427         uint amountBMin
428     ) internal virtual returns (uint amountA, uint amountB) {
429         // create the pair if it doesn't exist yet
430         if (IDXswapFactory(factory).getPair(tokenA, tokenB) == address(0)) {
431             IDXswapFactory(factory).createPair(tokenA, tokenB);
432         }
433         (uint reserveA, uint reserveB) = DXswapLibrary.getReserves(factory, tokenA, tokenB);
434         if (reserveA == 0 && reserveB == 0) {
435             (amountA, amountB) = (amountADesired, amountBDesired);
436         } else {
437             uint amountBOptimal = DXswapLibrary.quote(amountADesired, reserveA, reserveB);
438             if (amountBOptimal <= amountBDesired) {
439                 require(amountBOptimal >= amountBMin, 'DXswapRouter: INSUFFICIENT_B_AMOUNT');
440                 (amountA, amountB) = (amountADesired, amountBOptimal);
441             } else {
442                 uint amountAOptimal = DXswapLibrary.quote(amountBDesired, reserveB, reserveA);
443                 assert(amountAOptimal <= amountADesired);
444                 require(amountAOptimal >= amountAMin, 'DXswapRouter: INSUFFICIENT_A_AMOUNT');
445                 (amountA, amountB) = (amountAOptimal, amountBDesired);
446             }
447         }
448     }
449     function addLiquidity(
450         address tokenA,
451         address tokenB,
452         uint amountADesired,
453         uint amountBDesired,
454         uint amountAMin,
455         uint amountBMin,
456         address to,
457         uint deadline
458     ) external virtual override ensure(deadline) returns (uint amountA, uint amountB, uint liquidity) {
459         (amountA, amountB) = _addLiquidity(tokenA, tokenB, amountADesired, amountBDesired, amountAMin, amountBMin);
460         address pair = DXswapLibrary.pairFor(factory, tokenA, tokenB);
461         TransferHelper.safeTransferFrom(tokenA, msg.sender, pair, amountA);
462         TransferHelper.safeTransferFrom(tokenB, msg.sender, pair, amountB);
463         liquidity = IDXswapPair(pair).mint(to);
464     }
465     function addLiquidityETH(
466         address token,
467         uint amountTokenDesired,
468         uint amountTokenMin,
469         uint amountETHMin,
470         address to,
471         uint deadline
472     ) external virtual override payable ensure(deadline) returns (uint amountToken, uint amountETH, uint liquidity) {
473         (amountToken, amountETH) = _addLiquidity(
474             token,
475             WETH,
476             amountTokenDesired,
477             msg.value,
478             amountTokenMin,
479             amountETHMin
480         );
481         address pair = DXswapLibrary.pairFor(factory, token, WETH);
482         TransferHelper.safeTransferFrom(token, msg.sender, pair, amountToken);
483         IWETH(WETH).deposit{value: amountETH}();
484         assert(IWETH(WETH).transfer(pair, amountETH));
485         liquidity = IDXswapPair(pair).mint(to);
486         // refund dust eth, if any
487         if (msg.value > amountETH) TransferHelper.safeTransferETH(msg.sender, msg.value - amountETH);
488     }
489 
490     // **** REMOVE LIQUIDITY ****
491     function removeLiquidity(
492         address tokenA,
493         address tokenB,
494         uint liquidity,
495         uint amountAMin,
496         uint amountBMin,
497         address to,
498         uint deadline
499     ) public virtual override ensure(deadline) returns (uint amountA, uint amountB) {
500         address pair = DXswapLibrary.pairFor(factory, tokenA, tokenB);
501         IDXswapPair(pair).transferFrom(msg.sender, pair, liquidity); // send liquidity to pair
502         (uint amount0, uint amount1) = IDXswapPair(pair).burn(to);
503         (address token0,) = DXswapLibrary.sortTokens(tokenA, tokenB);
504         (amountA, amountB) = tokenA == token0 ? (amount0, amount1) : (amount1, amount0);
505         require(amountA >= amountAMin, 'DXswapRouter: INSUFFICIENT_A_AMOUNT');
506         require(amountB >= amountBMin, 'DXswapRouter: INSUFFICIENT_B_AMOUNT');
507     }
508     function removeLiquidityETH(
509         address token,
510         uint liquidity,
511         uint amountTokenMin,
512         uint amountETHMin,
513         address to,
514         uint deadline
515     ) public virtual override ensure(deadline) returns (uint amountToken, uint amountETH) {
516         (amountToken, amountETH) = removeLiquidity(
517             token,
518             WETH,
519             liquidity,
520             amountTokenMin,
521             amountETHMin,
522             address(this),
523             deadline
524         );
525         TransferHelper.safeTransfer(token, to, amountToken);
526         IWETH(WETH).withdraw(amountETH);
527         TransferHelper.safeTransferETH(to, amountETH);
528     }
529     function removeLiquidityWithPermit(
530         address tokenA,
531         address tokenB,
532         uint liquidity,
533         uint amountAMin,
534         uint amountBMin,
535         address to,
536         uint deadline,
537         bool approveMax, uint8 v, bytes32 r, bytes32 s
538     ) external virtual override returns (uint amountA, uint amountB) {
539         address pair = DXswapLibrary.pairFor(factory, tokenA, tokenB);
540         uint value = approveMax ? uint(-1) : liquidity;
541         IDXswapPair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
542         (amountA, amountB) = removeLiquidity(tokenA, tokenB, liquidity, amountAMin, amountBMin, to, deadline);
543     }
544     function removeLiquidityETHWithPermit(
545         address token,
546         uint liquidity,
547         uint amountTokenMin,
548         uint amountETHMin,
549         address to,
550         uint deadline,
551         bool approveMax, uint8 v, bytes32 r, bytes32 s
552     ) external virtual override returns (uint amountToken, uint amountETH) {
553         address pair = DXswapLibrary.pairFor(factory, token, WETH);
554         uint value = approveMax ? uint(-1) : liquidity;
555         IDXswapPair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
556         (amountToken, amountETH) = removeLiquidityETH(token, liquidity, amountTokenMin, amountETHMin, to, deadline);
557     }
558 
559     // **** REMOVE LIQUIDITY (supporting fee-on-transfer tokens) ****
560     function removeLiquidityETHSupportingFeeOnTransferTokens(
561         address token,
562         uint liquidity,
563         uint amountTokenMin,
564         uint amountETHMin,
565         address to,
566         uint deadline
567     ) public virtual override ensure(deadline) returns (uint amountETH) {
568         (, amountETH) = removeLiquidity(
569             token,
570             WETH,
571             liquidity,
572             amountTokenMin,
573             amountETHMin,
574             address(this),
575             deadline
576         );
577         TransferHelper.safeTransfer(token, to, IERC20(token).balanceOf(address(this)));
578         IWETH(WETH).withdraw(amountETH);
579         TransferHelper.safeTransferETH(to, amountETH);
580     }
581     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
582         address token,
583         uint liquidity,
584         uint amountTokenMin,
585         uint amountETHMin,
586         address to,
587         uint deadline,
588         bool approveMax, uint8 v, bytes32 r, bytes32 s
589     ) external virtual override returns (uint amountETH) {
590         address pair = DXswapLibrary.pairFor(factory, token, WETH);
591         uint value = approveMax ? uint(-1) : liquidity;
592         IDXswapPair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
593         amountETH = removeLiquidityETHSupportingFeeOnTransferTokens(
594             token, liquidity, amountTokenMin, amountETHMin, to, deadline
595         );
596     }
597 
598     // **** SWAP ****
599     // requires the initial amount to have already been sent to the first pair
600     function _swap(uint[] memory amounts, address[] memory path, address _to) internal virtual {
601         for (uint i; i < path.length - 1; i++) {
602             (address input, address output) = (path[i], path[i + 1]);
603             (address token0,) = DXswapLibrary.sortTokens(input, output);
604             uint amountOut = amounts[i + 1];
605             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOut) : (amountOut, uint(0));
606             address to = i < path.length - 2 ? DXswapLibrary.pairFor(factory, output, path[i + 2]) : _to;
607             IDXswapPair(DXswapLibrary.pairFor(factory, input, output)).swap(
608                 amount0Out, amount1Out, to, new bytes(0)
609             );
610         }
611     }
612     function swapExactTokensForTokens(
613         uint amountIn,
614         uint amountOutMin,
615         address[] calldata path,
616         address to,
617         uint deadline
618     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
619         amounts = DXswapLibrary.getAmountsOut(factory, amountIn, path);
620         require(amounts[amounts.length - 1] >= amountOutMin, 'DXswapRouter: INSUFFICIENT_OUTPUT_AMOUNT');
621         TransferHelper.safeTransferFrom(
622             path[0], msg.sender, DXswapLibrary.pairFor(factory, path[0], path[1]), amounts[0]
623         );
624         _swap(amounts, path, to);
625     }
626     function swapTokensForExactTokens(
627         uint amountOut,
628         uint amountInMax,
629         address[] calldata path,
630         address to,
631         uint deadline
632     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
633         amounts = DXswapLibrary.getAmountsIn(factory, amountOut, path);
634         require(amounts[0] <= amountInMax, 'DXswapRouter: EXCESSIVE_INPUT_AMOUNT');
635         TransferHelper.safeTransferFrom(
636             path[0], msg.sender, DXswapLibrary.pairFor(factory, path[0], path[1]), amounts[0]
637         );
638         _swap(amounts, path, to);
639     }
640     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
641         external
642         virtual
643         override
644         payable
645         ensure(deadline)
646         returns (uint[] memory amounts)
647     {
648         require(path[0] == WETH, 'DXswapRouter: INVALID_PATH');
649         amounts = DXswapLibrary.getAmountsOut(factory, msg.value, path);
650         require(amounts[amounts.length - 1] >= amountOutMin, 'DXswapRouter: INSUFFICIENT_OUTPUT_AMOUNT');
651         IWETH(WETH).deposit{value: amounts[0]}();
652         assert(IWETH(WETH).transfer(DXswapLibrary.pairFor(factory, path[0], path[1]), amounts[0]));
653         _swap(amounts, path, to);
654     }
655     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
656         external
657         virtual
658         override
659         ensure(deadline)
660         returns (uint[] memory amounts)
661     {
662         require(path[path.length - 1] == WETH, 'DXswapRouter: INVALID_PATH');
663         amounts = DXswapLibrary.getAmountsIn(factory, amountOut, path);
664         require(amounts[0] <= amountInMax, 'DXswapRouter: EXCESSIVE_INPUT_AMOUNT');
665         TransferHelper.safeTransferFrom(
666             path[0], msg.sender, DXswapLibrary.pairFor(factory, path[0], path[1]), amounts[0]
667         );
668         _swap(amounts, path, address(this));
669         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
670         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
671     }
672     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
673         external
674         virtual
675         override
676         ensure(deadline)
677         returns (uint[] memory amounts)
678     {
679         require(path[path.length - 1] == WETH, 'DXswapRouter: INVALID_PATH');
680         amounts = DXswapLibrary.getAmountsOut(factory, amountIn, path);
681         require(amounts[amounts.length - 1] >= amountOutMin, 'DXswapRouter: INSUFFICIENT_OUTPUT_AMOUNT');
682         TransferHelper.safeTransferFrom(
683             path[0], msg.sender, DXswapLibrary.pairFor(factory, path[0], path[1]), amounts[0]
684         );
685         _swap(amounts, path, address(this));
686         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
687         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
688     }
689     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
690         external
691         virtual
692         override
693         payable
694         ensure(deadline)
695         returns (uint[] memory amounts)
696     {
697         require(path[0] == WETH, 'DXswapRouter: INVALID_PATH');
698         amounts = DXswapLibrary.getAmountsIn(factory, amountOut, path);
699         require(amounts[0] <= msg.value, 'DXswapRouter: EXCESSIVE_INPUT_AMOUNT');
700         IWETH(WETH).deposit{value: amounts[0]}();
701         assert(IWETH(WETH).transfer(DXswapLibrary.pairFor(factory, path[0], path[1]), amounts[0]));
702         _swap(amounts, path, to);
703         // refund dust eth, if any
704         if (msg.value > amounts[0]) TransferHelper.safeTransferETH(msg.sender, msg.value - amounts[0]);
705     }
706 
707     // **** SWAP (supporting fee-on-transfer tokens) ****
708     // requires the initial amount to have already been sent to the first pair
709     function _swapSupportingFeeOnTransferTokens(address[] memory path, address _to) internal virtual {
710         for (uint i; i < path.length - 1; i++) {
711             (address input, address output) = (path[i], path[i + 1]);
712             (address token0,) = DXswapLibrary.sortTokens(input, output);
713             IDXswapPair pair = IDXswapPair(DXswapLibrary.pairFor(factory, input, output));
714             uint amountInput;
715             uint amountOutput;
716             { // scope to avoid stack too deep errors
717             (uint reserve0, uint reserve1,) = pair.getReserves();
718             (uint reserveInput, uint reserveOutput) = input == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
719             amountInput = IERC20(input).balanceOf(address(pair)).sub(reserveInput);
720             amountOutput = DXswapLibrary.getAmountOut(amountInput, reserveInput, reserveOutput, pair.swapFee());
721             }
722             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOutput) : (amountOutput, uint(0));
723             address to = i < path.length - 2 ? DXswapLibrary.pairFor(factory, output, path[i + 2]) : _to;
724             pair.swap(amount0Out, amount1Out, to, new bytes(0));
725         }
726     }
727     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
728         uint amountIn,
729         uint amountOutMin,
730         address[] calldata path,
731         address to,
732         uint deadline
733     ) external virtual override ensure(deadline) {
734         TransferHelper.safeTransferFrom(
735             path[0], msg.sender, DXswapLibrary.pairFor(factory, path[0], path[1]), amountIn
736         );
737         uint balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
738         _swapSupportingFeeOnTransferTokens(path, to);
739         require(
740             IERC20(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
741             'DXswapRouter: INSUFFICIENT_OUTPUT_AMOUNT'
742         );
743     }
744     function swapExactETHForTokensSupportingFeeOnTransferTokens(
745         uint amountOutMin,
746         address[] calldata path,
747         address to,
748         uint deadline
749     )
750         external
751         virtual
752         override
753         payable
754         ensure(deadline)
755     {
756         require(path[0] == WETH, 'DXswapRouter: INVALID_PATH');
757         uint amountIn = msg.value;
758         IWETH(WETH).deposit{value: amountIn}();
759         assert(IWETH(WETH).transfer(DXswapLibrary.pairFor(factory, path[0], path[1]), amountIn));
760         uint balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
761         _swapSupportingFeeOnTransferTokens(path, to);
762         require(
763             IERC20(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
764             'DXswapRouter: INSUFFICIENT_OUTPUT_AMOUNT'
765         );
766     }
767     function swapExactTokensForETHSupportingFeeOnTransferTokens(
768         uint amountIn,
769         uint amountOutMin,
770         address[] calldata path,
771         address to,
772         uint deadline
773     )
774         external
775         virtual
776         override
777         ensure(deadline)
778     {
779         require(path[path.length - 1] == WETH, 'DXswapRouter: INVALID_PATH');
780         TransferHelper.safeTransferFrom(
781             path[0], msg.sender, DXswapLibrary.pairFor(factory, path[0], path[1]), amountIn
782         );
783         _swapSupportingFeeOnTransferTokens(path, address(this));
784         uint amountOut = IERC20(WETH).balanceOf(address(this));
785         require(amountOut >= amountOutMin, 'DXswapRouter: INSUFFICIENT_OUTPUT_AMOUNT');
786         IWETH(WETH).withdraw(amountOut);
787         TransferHelper.safeTransferETH(to, amountOut);
788     }
789 
790     // **** LIBRARY FUNCTIONS ****
791     function quote(uint amountA, uint reserveA, uint reserveB) public pure virtual override returns (uint amountB) {
792         return DXswapLibrary.quote(amountA, reserveA, reserveB);
793     }
794 
795     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut, uint swapFee)
796         public
797         pure
798         virtual
799         override
800         returns (uint amountOut)
801     {
802         return DXswapLibrary.getAmountOut(amountIn, reserveIn, reserveOut, swapFee);
803     }
804 
805     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut, uint swapFee)
806         public
807         pure
808         virtual
809         override
810         returns (uint amountIn)
811     {
812         return DXswapLibrary.getAmountIn(amountOut, reserveIn, reserveOut, swapFee);
813     }
814 
815     function getAmountsOut(uint amountIn, address[] memory path)
816         public
817         view
818         virtual
819         override
820         returns (uint[] memory amounts)
821     {
822         return DXswapLibrary.getAmountsOut(factory, amountIn, path);
823     }
824 
825     function getAmountsIn(uint amountOut, address[] memory path)
826         public
827         view
828         virtual
829         override
830         returns (uint[] memory amounts)
831     {
832         return DXswapLibrary.getAmountsIn(factory, amountOut, path);
833     }
834 }