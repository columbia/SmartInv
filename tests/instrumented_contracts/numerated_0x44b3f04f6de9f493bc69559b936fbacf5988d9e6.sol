1 // File: @uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol
2 
3 pragma solidity >=0.5.0;
4 
5 interface IUniswapV2Factory {
6     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
7 
8     function feeTo() external view returns (address);
9     function feeToSetter() external view returns (address);
10 
11     function getPair(address tokenA, address tokenB) external view returns (address pair);
12     function allPairs(uint) external view returns (address pair);
13     function allPairsLength() external view returns (uint);
14 
15     function createPair(address tokenA, address tokenB) external returns (address pair);
16 
17     function setFeeTo(address) external;
18     function setFeeToSetter(address) external;
19 }
20 
21 // File: @uniswap/lib/contracts/libraries/TransferHelper.sol
22 
23 pragma solidity >=0.6.0;
24 
25 // helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
26 library TransferHelper {
27     function safeApprove(address token, address to, uint value) internal {
28         // bytes4(keccak256(bytes('approve(address,uint256)')));
29         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
30         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
31     }
32 
33     function safeTransfer(address token, address to, uint value) internal {
34         // bytes4(keccak256(bytes('transfer(address,uint256)')));
35         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
36         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
37     }
38 
39     function safeTransferFrom(address token, address from, address to, uint value) internal {
40         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
41         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
42         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
43     }
44 
45     function safeTransferETH(address to, uint value) internal {
46         (bool success,) = to.call{value:value}(new bytes(0));
47         require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
48     }
49 }
50 
51 // File: contracts/interfaces/IUniswapV2Router01.sol
52 
53 pragma solidity >=0.6.2;
54 
55 interface IUniswapV2Router01 {
56     function factory() external pure returns (address);
57     function WETH() external pure returns (address);
58 
59     function addLiquidity(
60         address tokenA,
61         address tokenB,
62         uint amountADesired,
63         uint amountBDesired,
64         uint amountAMin,
65         uint amountBMin,
66         address to,
67         uint deadline
68     ) external returns (uint amountA, uint amountB, uint liquidity);
69     function addLiquidityETH(
70         address token,
71         uint amountTokenDesired,
72         uint amountTokenMin,
73         uint amountETHMin,
74         address to,
75         uint deadline
76     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
77     function removeLiquidity(
78         address tokenA,
79         address tokenB,
80         uint liquidity,
81         uint amountAMin,
82         uint amountBMin,
83         address to,
84         uint deadline
85     ) external returns (uint amountA, uint amountB);
86     function removeLiquidityETH(
87         address token,
88         uint liquidity,
89         uint amountTokenMin,
90         uint amountETHMin,
91         address to,
92         uint deadline
93     ) external returns (uint amountToken, uint amountETH);
94     function removeLiquidityWithPermit(
95         address tokenA,
96         address tokenB,
97         uint liquidity,
98         uint amountAMin,
99         uint amountBMin,
100         address to,
101         uint deadline,
102         bool approveMax, uint8 v, bytes32 r, bytes32 s
103     ) external returns (uint amountA, uint amountB);
104     function removeLiquidityETHWithPermit(
105         address token,
106         uint liquidity,
107         uint amountTokenMin,
108         uint amountETHMin,
109         address to,
110         uint deadline,
111         bool approveMax, uint8 v, bytes32 r, bytes32 s
112     ) external returns (uint amountToken, uint amountETH);
113     function swapExactTokensForTokens(
114         uint amountIn,
115         uint amountOutMin,
116         address[] calldata path,
117         address to,
118         uint deadline
119     ) external returns (uint[] memory amounts);
120     function swapTokensForExactTokens(
121         uint amountOut,
122         uint amountInMax,
123         address[] calldata path,
124         address to,
125         uint deadline
126     ) external returns (uint[] memory amounts);
127     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
128         external
129         payable
130         returns (uint[] memory amounts);
131     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
132         external
133         returns (uint[] memory amounts);
134     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
135         external
136         returns (uint[] memory amounts);
137     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
138         external
139         payable
140         returns (uint[] memory amounts);
141 
142     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
143     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
144     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
145     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
146     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
147 }
148 
149 // File: contracts/interfaces/IUniswapV2Router02.sol
150 
151 pragma solidity >=0.6.2;
152 
153 
154 interface IUniswapV2Router02 is IUniswapV2Router01 {
155     function removeLiquidityETHSupportingFeeOnTransferTokens(
156         address token,
157         uint liquidity,
158         uint amountTokenMin,
159         uint amountETHMin,
160         address to,
161         uint deadline
162     ) external returns (uint amountETH);
163     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
164         address token,
165         uint liquidity,
166         uint amountTokenMin,
167         uint amountETHMin,
168         address to,
169         uint deadline,
170         bool approveMax, uint8 v, bytes32 r, bytes32 s
171     ) external returns (uint amountETH);
172 
173     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
174         uint amountIn,
175         uint amountOutMin,
176         address[] calldata path,
177         address to,
178         uint deadline
179     ) external;
180     function swapExactETHForTokensSupportingFeeOnTransferTokens(
181         uint amountOutMin,
182         address[] calldata path,
183         address to,
184         uint deadline
185     ) external payable;
186     function swapExactTokensForETHSupportingFeeOnTransferTokens(
187         uint amountIn,
188         uint amountOutMin,
189         address[] calldata path,
190         address to,
191         uint deadline
192     ) external;
193 }
194 
195 // File: @uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol
196 
197 pragma solidity >=0.5.0;
198 
199 interface IUniswapV2Pair {
200     event Approval(address indexed owner, address indexed spender, uint value);
201     event Transfer(address indexed from, address indexed to, uint value);
202 
203     function name() external pure returns (string memory);
204     function symbol() external pure returns (string memory);
205     function decimals() external pure returns (uint8);
206     function totalSupply() external view returns (uint);
207     function balanceOf(address owner) external view returns (uint);
208     function allowance(address owner, address spender) external view returns (uint);
209 
210     function approve(address spender, uint value) external returns (bool);
211     function transfer(address to, uint value) external returns (bool);
212     function transferFrom(address from, address to, uint value) external returns (bool);
213 
214     function DOMAIN_SEPARATOR() external view returns (bytes32);
215     function PERMIT_TYPEHASH() external pure returns (bytes32);
216     function nonces(address owner) external view returns (uint);
217 
218     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
219 
220     event Mint(address indexed sender, uint amount0, uint amount1);
221     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
222     event Swap(
223         address indexed sender,
224         uint amount0In,
225         uint amount1In,
226         uint amount0Out,
227         uint amount1Out,
228         address indexed to
229     );
230     event Sync(uint112 reserve0, uint112 reserve1);
231 
232     function MINIMUM_LIQUIDITY() external pure returns (uint);
233     function factory() external view returns (address);
234     function token0() external view returns (address);
235     function token1() external view returns (address);
236     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
237     function price0CumulativeLast() external view returns (uint);
238     function price1CumulativeLast() external view returns (uint);
239     function kLast() external view returns (uint);
240 
241     function mint(address to) external returns (uint liquidity);
242     function burn(address to) external returns (uint amount0, uint amount1);
243     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
244     function skim(address to) external;
245     function sync() external;
246 
247     function initialize(address, address) external;
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
270 // File: contracts/libraries/UniswapV2Library.sol
271 
272 pragma solidity >=0.5.0;
273 
274 
275 
276 library UniswapV2Library {
277     using SafeMath for uint;
278 
279     // returns sorted token addresses, used to handle return values from pairs sorted in this order
280     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
281         require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');
282         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
283         require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');
284     }
285 
286     // calculates the CREATE2 address for a pair without making any external calls
287     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
288         (address token0, address token1) = sortTokens(tokenA, tokenB);
289         pair = address(uint(keccak256(abi.encodePacked(
290                 hex'ff',
291                 factory,
292                 keccak256(abi.encodePacked(token0, token1)),
293                 hex'a3a05287d2337068ae9d1688aa0b318f60b06c279d5283f2c13e6f4fd24272d0' // init code hash
294             ))));
295     }
296 
297     // fetches and sorts the reserves for a pair
298     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
299         (address token0,) = sortTokens(tokenA, tokenB);
300         (uint reserve0, uint reserve1,) = IUniswapV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();
301         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
302     }
303 
304     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
305     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
306         require(amountA > 0, 'UniswapV2Library: INSUFFICIENT_AMOUNT');
307         require(reserveA > 0 && reserveB > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
308         amountB = amountA.mul(reserveB) / reserveA;
309     }
310 
311     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
312     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
313         require(amountIn > 0, 'UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT');
314         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
315         uint amountInWithFee = amountIn.mul(9985);
316         uint numerator = amountInWithFee.mul(reserveOut);
317         uint denominator = reserveIn.mul(10000).add(amountInWithFee);
318         amountOut = numerator / denominator;
319     }
320 
321     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
322     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {
323         require(amountOut > 0, 'UniswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT');
324         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
325         uint numerator = reserveIn.mul(amountOut).mul(10000);
326         uint denominator = reserveOut.sub(amountOut).mul(9985);
327         amountIn = (numerator / denominator).add(1);
328     }
329 
330     // performs chained getAmountOut calculations on any number of pairs
331     function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {
332         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
333         amounts = new uint[](path.length);
334         amounts[0] = amountIn;
335         for (uint i; i < path.length - 1; i++) {
336             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);
337             amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
338         }
339     }
340 
341     // performs chained getAmountIn calculations on any number of pairs
342     function getAmountsIn(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {
343         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
344         amounts = new uint[](path.length);
345         amounts[amounts.length - 1] = amountOut;
346         for (uint i = path.length - 1; i > 0; i--) {
347             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);
348             amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
349         }
350     }
351 }
352 
353 // File: contracts/interfaces/IERC20.sol
354 
355 pragma solidity >=0.5.0;
356 
357 interface IERC20 {
358     event Approval(address indexed owner, address indexed spender, uint value);
359     event Transfer(address indexed from, address indexed to, uint value);
360 
361     function name() external view returns (string memory);
362     function symbol() external view returns (string memory);
363     function decimals() external view returns (uint8);
364     function totalSupply() external view returns (uint);
365     function balanceOf(address owner) external view returns (uint);
366     function allowance(address owner, address spender) external view returns (uint);
367 
368     function approve(address spender, uint value) external returns (bool);
369     function transfer(address to, uint value) external returns (bool);
370     function transferFrom(address from, address to, uint value) external returns (bool);
371 }
372 
373 // File: contracts/interfaces/IWETH.sol
374 
375 pragma solidity >=0.5.0;
376 
377 interface IWETH {
378     function deposit() external payable;
379     function transfer(address to, uint value) external returns (bool);
380     function withdraw(uint) external;
381 }
382 
383 // File: contracts/UniswapV2Router02.sol
384 
385 pragma solidity =0.6.6;
386 
387 
388 
389 
390 
391 
392 
393 
394 contract UniswapV2Router02 is IUniswapV2Router02 {
395     using SafeMath for uint;
396 
397     address public immutable override factory;
398     address public immutable override WETH;
399 
400     modifier ensure(uint deadline) {
401         require(deadline >= block.timestamp, 'UniswapV2Router: EXPIRED');
402         _;
403     }
404 
405     constructor(address _factory, address _WETH) public {
406         factory = _factory;
407         WETH = _WETH;
408     }
409 
410     receive() external payable {
411         assert(msg.sender == WETH); // only accept ETH via fallback from the WETH contract
412     }
413 
414     // **** ADD LIQUIDITY ****
415     function _addLiquidity(
416         address tokenA,
417         address tokenB,
418         uint amountADesired,
419         uint amountBDesired,
420         uint amountAMin,
421         uint amountBMin
422     ) internal virtual returns (uint amountA, uint amountB) {
423         // create the pair if it doesn't exist yet
424         if (IUniswapV2Factory(factory).getPair(tokenA, tokenB) == address(0)) {
425             IUniswapV2Factory(factory).createPair(tokenA, tokenB);
426         }
427         (uint reserveA, uint reserveB) = UniswapV2Library.getReserves(factory, tokenA, tokenB);
428         if (reserveA == 0 && reserveB == 0) {
429             (amountA, amountB) = (amountADesired, amountBDesired);
430         } else {
431             uint amountBOptimal = UniswapV2Library.quote(amountADesired, reserveA, reserveB);
432             if (amountBOptimal <= amountBDesired) {
433                 require(amountBOptimal >= amountBMin, 'UniswapV2Router: INSUFFICIENT_B_AMOUNT');
434                 (amountA, amountB) = (amountADesired, amountBOptimal);
435             } else {
436                 uint amountAOptimal = UniswapV2Library.quote(amountBDesired, reserveB, reserveA);
437                 assert(amountAOptimal <= amountADesired);
438                 require(amountAOptimal >= amountAMin, 'UniswapV2Router: INSUFFICIENT_A_AMOUNT');
439                 (amountA, amountB) = (amountAOptimal, amountBDesired);
440             }
441         }
442     }
443     function addLiquidity(
444         address tokenA,
445         address tokenB,
446         uint amountADesired,
447         uint amountBDesired,
448         uint amountAMin,
449         uint amountBMin,
450         address to,
451         uint deadline
452     ) external virtual override ensure(deadline) returns (uint amountA, uint amountB, uint liquidity) {
453         (amountA, amountB) = _addLiquidity(tokenA, tokenB, amountADesired, amountBDesired, amountAMin, amountBMin);
454         address pair = UniswapV2Library.pairFor(factory, tokenA, tokenB);
455         TransferHelper.safeTransferFrom(tokenA, msg.sender, pair, amountA);
456         TransferHelper.safeTransferFrom(tokenB, msg.sender, pair, amountB);
457         liquidity = IUniswapV2Pair(pair).mint(to);
458     }
459     function addLiquidityETH(
460         address token,
461         uint amountTokenDesired,
462         uint amountTokenMin,
463         uint amountETHMin,
464         address to,
465         uint deadline
466     ) external virtual override payable ensure(deadline) returns (uint amountToken, uint amountETH, uint liquidity) {
467         (amountToken, amountETH) = _addLiquidity(
468             token,
469             WETH,
470             amountTokenDesired,
471             msg.value,
472             amountTokenMin,
473             amountETHMin
474         );
475         address pair = UniswapV2Library.pairFor(factory, token, WETH);
476         TransferHelper.safeTransferFrom(token, msg.sender, pair, amountToken);
477         IWETH(WETH).deposit{value: amountETH}();
478         assert(IWETH(WETH).transfer(pair, amountETH));
479         liquidity = IUniswapV2Pair(pair).mint(to);
480         // refund dust eth, if any
481         if (msg.value > amountETH) TransferHelper.safeTransferETH(msg.sender, msg.value - amountETH);
482     }
483 
484     // **** REMOVE LIQUIDITY ****
485     function removeLiquidity(
486         address tokenA,
487         address tokenB,
488         uint liquidity,
489         uint amountAMin,
490         uint amountBMin,
491         address to,
492         uint deadline
493     ) public virtual override ensure(deadline) returns (uint amountA, uint amountB) {
494         address pair = UniswapV2Library.pairFor(factory, tokenA, tokenB);
495         IUniswapV2Pair(pair).transferFrom(msg.sender, pair, liquidity); // send liquidity to pair
496         (uint amount0, uint amount1) = IUniswapV2Pair(pair).burn(to);
497         (address token0,) = UniswapV2Library.sortTokens(tokenA, tokenB);
498         (amountA, amountB) = tokenA == token0 ? (amount0, amount1) : (amount1, amount0);
499         require(amountA >= amountAMin, 'UniswapV2Router: INSUFFICIENT_A_AMOUNT');
500         require(amountB >= amountBMin, 'UniswapV2Router: INSUFFICIENT_B_AMOUNT');
501     }
502     function removeLiquidityETH(
503         address token,
504         uint liquidity,
505         uint amountTokenMin,
506         uint amountETHMin,
507         address to,
508         uint deadline
509     ) public virtual override ensure(deadline) returns (uint amountToken, uint amountETH) {
510         (amountToken, amountETH) = removeLiquidity(
511             token,
512             WETH,
513             liquidity,
514             amountTokenMin,
515             amountETHMin,
516             address(this),
517             deadline
518         );
519         TransferHelper.safeTransfer(token, to, amountToken);
520         IWETH(WETH).withdraw(amountETH);
521         TransferHelper.safeTransferETH(to, amountETH);
522     }
523     function removeLiquidityWithPermit(
524         address tokenA,
525         address tokenB,
526         uint liquidity,
527         uint amountAMin,
528         uint amountBMin,
529         address to,
530         uint deadline,
531         bool approveMax, uint8 v, bytes32 r, bytes32 s
532     ) external virtual override returns (uint amountA, uint amountB) {
533         address pair = UniswapV2Library.pairFor(factory, tokenA, tokenB);
534         uint value = approveMax ? uint(-1) : liquidity;
535         IUniswapV2Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
536         (amountA, amountB) = removeLiquidity(tokenA, tokenB, liquidity, amountAMin, amountBMin, to, deadline);
537     }
538     function removeLiquidityETHWithPermit(
539         address token,
540         uint liquidity,
541         uint amountTokenMin,
542         uint amountETHMin,
543         address to,
544         uint deadline,
545         bool approveMax, uint8 v, bytes32 r, bytes32 s
546     ) external virtual override returns (uint amountToken, uint amountETH) {
547         address pair = UniswapV2Library.pairFor(factory, token, WETH);
548         uint value = approveMax ? uint(-1) : liquidity;
549         IUniswapV2Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
550         (amountToken, amountETH) = removeLiquidityETH(token, liquidity, amountTokenMin, amountETHMin, to, deadline);
551     }
552 
553     // **** REMOVE LIQUIDITY (supporting fee-on-transfer tokens) ****
554     function removeLiquidityETHSupportingFeeOnTransferTokens(
555         address token,
556         uint liquidity,
557         uint amountTokenMin,
558         uint amountETHMin,
559         address to,
560         uint deadline
561     ) public virtual override ensure(deadline) returns (uint amountETH) {
562         (, amountETH) = removeLiquidity(
563             token,
564             WETH,
565             liquidity,
566             amountTokenMin,
567             amountETHMin,
568             address(this),
569             deadline
570         );
571         TransferHelper.safeTransfer(token, to, IERC20(token).balanceOf(address(this)));
572         IWETH(WETH).withdraw(amountETH);
573         TransferHelper.safeTransferETH(to, amountETH);
574     }
575     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
576         address token,
577         uint liquidity,
578         uint amountTokenMin,
579         uint amountETHMin,
580         address to,
581         uint deadline,
582         bool approveMax, uint8 v, bytes32 r, bytes32 s
583     ) external virtual override returns (uint amountETH) {
584         address pair = UniswapV2Library.pairFor(factory, token, WETH);
585         uint value = approveMax ? uint(-1) : liquidity;
586         IUniswapV2Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
587         amountETH = removeLiquidityETHSupportingFeeOnTransferTokens(
588             token, liquidity, amountTokenMin, amountETHMin, to, deadline
589         );
590     }
591 
592     // **** SWAP ****
593     // requires the initial amount to have already been sent to the first pair
594     function _swap(uint[] memory amounts, address[] memory path, address _to) internal virtual {
595         for (uint i; i < path.length - 1; i++) {
596             (address input, address output) = (path[i], path[i + 1]);
597             (address token0,) = UniswapV2Library.sortTokens(input, output);
598             uint amountOut = amounts[i + 1];
599             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOut) : (amountOut, uint(0));
600             address to = i < path.length - 2 ? UniswapV2Library.pairFor(factory, output, path[i + 2]) : _to;
601             IUniswapV2Pair(UniswapV2Library.pairFor(factory, input, output)).swap(
602                 amount0Out, amount1Out, to, new bytes(0)
603             );
604         }
605     }
606     function swapExactTokensForTokens(
607         uint amountIn,
608         uint amountOutMin,
609         address[] calldata path,
610         address to,
611         uint deadline
612     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
613         amounts = UniswapV2Library.getAmountsOut(factory, amountIn, path);
614         require(amounts[amounts.length - 1] >= amountOutMin, 'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
615         TransferHelper.safeTransferFrom(
616             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
617         );
618         _swap(amounts, path, to);
619     }
620     function swapTokensForExactTokens(
621         uint amountOut,
622         uint amountInMax,
623         address[] calldata path,
624         address to,
625         uint deadline
626     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
627         amounts = UniswapV2Library.getAmountsIn(factory, amountOut, path);
628         require(amounts[0] <= amountInMax, 'UniswapV2Router: EXCESSIVE_INPUT_AMOUNT');
629         TransferHelper.safeTransferFrom(
630             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
631         );
632         _swap(amounts, path, to);
633     }
634     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
635         external
636         virtual
637         override
638         payable
639         ensure(deadline)
640         returns (uint[] memory amounts)
641     {
642         require(path[0] == WETH, 'UniswapV2Router: INVALID_PATH');
643         amounts = UniswapV2Library.getAmountsOut(factory, msg.value, path);
644         require(amounts[amounts.length - 1] >= amountOutMin, 'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
645         IWETH(WETH).deposit{value: amounts[0]}();
646         assert(IWETH(WETH).transfer(UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]));
647         _swap(amounts, path, to);
648     }
649     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
650         external
651         virtual
652         override
653         ensure(deadline)
654         returns (uint[] memory amounts)
655     {
656         require(path[path.length - 1] == WETH, 'UniswapV2Router: INVALID_PATH');
657         amounts = UniswapV2Library.getAmountsIn(factory, amountOut, path);
658         require(amounts[0] <= amountInMax, 'UniswapV2Router: EXCESSIVE_INPUT_AMOUNT');
659         TransferHelper.safeTransferFrom(
660             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
661         );
662         _swap(amounts, path, address(this));
663         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
664         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
665     }
666     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
667         external
668         virtual
669         override
670         ensure(deadline)
671         returns (uint[] memory amounts)
672     {
673         require(path[path.length - 1] == WETH, 'UniswapV2Router: INVALID_PATH');
674         amounts = UniswapV2Library.getAmountsOut(factory, amountIn, path);
675         require(amounts[amounts.length - 1] >= amountOutMin, 'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
676         TransferHelper.safeTransferFrom(
677             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
678         );
679         _swap(amounts, path, address(this));
680         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
681         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
682     }
683     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
684         external
685         virtual
686         override
687         payable
688         ensure(deadline)
689         returns (uint[] memory amounts)
690     {
691         require(path[0] == WETH, 'UniswapV2Router: INVALID_PATH');
692         amounts = UniswapV2Library.getAmountsIn(factory, amountOut, path);
693         require(amounts[0] <= msg.value, 'UniswapV2Router: EXCESSIVE_INPUT_AMOUNT');
694         IWETH(WETH).deposit{value: amounts[0]}();
695         assert(IWETH(WETH).transfer(UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]));
696         _swap(amounts, path, to);
697         // refund dust eth, if any
698         if (msg.value > amounts[0]) TransferHelper.safeTransferETH(msg.sender, msg.value - amounts[0]);
699     }
700 
701     // **** SWAP (supporting fee-on-transfer tokens) ****
702     // requires the initial amount to have already been sent to the first pair
703     function _swapSupportingFeeOnTransferTokens(address[] memory path, address _to) internal virtual {
704         for (uint i; i < path.length - 1; i++) {
705             (address input, address output) = (path[i], path[i + 1]);
706             (address token0,) = UniswapV2Library.sortTokens(input, output);
707             IUniswapV2Pair pair = IUniswapV2Pair(UniswapV2Library.pairFor(factory, input, output));
708             uint amountInput;
709             uint amountOutput;
710             { // scope to avoid stack too deep errors
711             (uint reserve0, uint reserve1,) = pair.getReserves();
712             (uint reserveInput, uint reserveOutput) = input == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
713             amountInput = IERC20(input).balanceOf(address(pair)).sub(reserveInput);
714             amountOutput = UniswapV2Library.getAmountOut(amountInput, reserveInput, reserveOutput);
715             }
716             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOutput) : (amountOutput, uint(0));
717             address to = i < path.length - 2 ? UniswapV2Library.pairFor(factory, output, path[i + 2]) : _to;
718             pair.swap(amount0Out, amount1Out, to, new bytes(0));
719         }
720     }
721     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
722         uint amountIn,
723         uint amountOutMin,
724         address[] calldata path,
725         address to,
726         uint deadline
727     ) external virtual override ensure(deadline) {
728         TransferHelper.safeTransferFrom(
729             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amountIn
730         );
731         uint balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
732         _swapSupportingFeeOnTransferTokens(path, to);
733         require(
734             IERC20(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
735             'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT'
736         );
737     }
738     function swapExactETHForTokensSupportingFeeOnTransferTokens(
739         uint amountOutMin,
740         address[] calldata path,
741         address to,
742         uint deadline
743     )
744         external
745         virtual
746         override
747         payable
748         ensure(deadline)
749     {
750         require(path[0] == WETH, 'UniswapV2Router: INVALID_PATH');
751         uint amountIn = msg.value;
752         IWETH(WETH).deposit{value: amountIn}();
753         assert(IWETH(WETH).transfer(UniswapV2Library.pairFor(factory, path[0], path[1]), amountIn));
754         uint balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
755         _swapSupportingFeeOnTransferTokens(path, to);
756         require(
757             IERC20(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
758             'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT'
759         );
760     }
761     function swapExactTokensForETHSupportingFeeOnTransferTokens(
762         uint amountIn,
763         uint amountOutMin,
764         address[] calldata path,
765         address to,
766         uint deadline
767     )
768         external
769         virtual
770         override
771         ensure(deadline)
772     {
773         require(path[path.length - 1] == WETH, 'UniswapV2Router: INVALID_PATH');
774         TransferHelper.safeTransferFrom(
775             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amountIn
776         );
777         _swapSupportingFeeOnTransferTokens(path, address(this));
778         uint amountOut = IERC20(WETH).balanceOf(address(this));
779         require(amountOut >= amountOutMin, 'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
780         IWETH(WETH).withdraw(amountOut);
781         TransferHelper.safeTransferETH(to, amountOut);
782     }
783 
784     // **** LIBRARY FUNCTIONS ****
785     function quote(uint amountA, uint reserveA, uint reserveB) public pure virtual override returns (uint amountB) {
786         return UniswapV2Library.quote(amountA, reserveA, reserveB);
787     }
788 
789     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut)
790         public
791         pure
792         virtual
793         override
794         returns (uint amountOut)
795     {
796         return UniswapV2Library.getAmountOut(amountIn, reserveIn, reserveOut);
797     }
798 
799     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut)
800         public
801         pure
802         virtual
803         override
804         returns (uint amountIn)
805     {
806         return UniswapV2Library.getAmountIn(amountOut, reserveIn, reserveOut);
807     }
808 
809     function getAmountsOut(uint amountIn, address[] memory path)
810         public
811         view
812         virtual
813         override
814         returns (uint[] memory amounts)
815     {
816         return UniswapV2Library.getAmountsOut(factory, amountIn, path);
817     }
818 
819     function getAmountsIn(uint amountOut, address[] memory path)
820         public
821         view
822         virtual
823         override
824         returns (uint[] memory amounts)
825     {
826         return UniswapV2Library.getAmountsIn(factory, amountOut, path);
827     }
828 }