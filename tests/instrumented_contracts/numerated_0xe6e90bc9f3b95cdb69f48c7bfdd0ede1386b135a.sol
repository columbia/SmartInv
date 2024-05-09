1 // Dependency file: contracts/interfaces/IUnicSwapV2Pair.sol
2 
3 // pragma solidity >=0.5.0;
4 
5 interface IUnicSwapV2Pair {
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
37 
38     function MINIMUM_LIQUIDITY() external pure returns (uint);
39     function factory() external view returns (address);
40     function token0() external view returns (address);
41     function token1() external view returns (address);
42     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
43     function price0CumulativeLast() external view returns (uint);
44     function price1CumulativeLast() external view returns (uint);
45     function kLast() external view returns (uint);
46 
47     function mint(address to) external returns (uint liquidity);
48     function burn(address to) external returns (uint amount0, uint amount1);
49     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
50     function skim(address to) external;
51     function sync() external;
52 
53     function initialize(address, address) external;
54 }
55 
56 // Dependency file: contracts/interfaces/IUnicSwapV2Router01.sol
57 
58 // pragma solidity >=0.6.2;
59 
60 interface IUnicSwapV2Router01 {
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
148     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
149     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
150     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
151     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
152 }
153 // Dependency file: contracts/interfaces/IWETH.sol
154 
155 // pragma solidity >=0.5.0;
156 
157 interface IWETH {
158     function deposit() external payable;
159     function transfer(address to, uint value) external returns (bool);
160     function withdraw(uint) external;
161 }
162 // Dependency file: contracts/interfaces/IERC20.sol
163 
164 // pragma solidity >=0.5.0;
165 
166 interface IERC20 {
167     event Approval(address indexed owner, address indexed spender, uint value);
168     event Transfer(address indexed from, address indexed to, uint value);
169 
170     function name() external view returns (string memory);
171     function symbol() external view returns (string memory);
172     function decimals() external view returns (uint8);
173     function totalSupply() external view returns (uint);
174     function balanceOf(address owner) external view returns (uint);
175     function allowance(address owner, address spender) external view returns (uint);
176 
177     function approve(address spender, uint value) external returns (bool);
178     function transfer(address to, uint value) external returns (bool);
179     function transferFrom(address from, address to, uint value) external returns (bool);
180 }
181 
182 // Dependency file: contracts/libraries/SafeMath.sol
183 
184 // pragma solidity =0.6.12;
185 
186 // a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)
187 
188 library SafeMath {
189     function add(uint x, uint y) internal pure returns (uint z) {
190         require((z = x + y) >= x, 'ds-math-add-overflow');
191     }
192 
193     function sub(uint x, uint y) internal pure returns (uint z) {
194         require((z = x - y) <= x, 'ds-math-sub-underflow');
195     }
196 
197     function mul(uint x, uint y) internal pure returns (uint z) {
198         require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');
199     }
200 }
201 
202 // Dependency file: contracts/libraries/UnicSwapV2Library.sol
203 
204 // pragma solidity >=0.5.0;
205 
206 // import '../interfaces/IUnicSwapV2Pair.sol';
207 
208 // import "./SafeMath.sol";
209 
210 library UnicSwapV2Library {
211     using SafeMath for uint;
212 
213     // returns sorted token addresses, used to handle return values from pairs sorted in this order
214     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
215         require(tokenA != tokenB, 'UnicSwapV2Library: IDENTICAL_ADDRESSES');
216         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
217         require(token0 != address(0), 'UnicSwapV2Library: ZERO_ADDRESS');
218     }
219 
220     // calculates the CREATE2 address for a pair without making any external calls
221     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
222         (address token0, address token1) = sortTokens(tokenA, tokenB);
223         pair = address(uint(keccak256(abi.encodePacked(
224                 hex'ff',
225                 factory,
226                 keccak256(abi.encodePacked(token0, token1)),
227                 hex'5648dac156e6a11a3e5d8490b7ea082913b6a97a1cd9a2b746dbedb1d922f6a8' // init code hash
228             ))));
229     }
230 
231     // fetches and sorts the reserves for a pair
232     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
233         (address token0,) = sortTokens(tokenA, tokenB);
234         (uint reserve0, uint reserve1,) = IUnicSwapV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();
235         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
236     }
237 
238     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
239     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
240         require(amountA > 0, 'UnicSwapV2Library: INSUFFICIENT_AMOUNT');
241         require(reserveA > 0 && reserveB > 0, 'UnicSwapV2Library: INSUFFICIENT_LIQUIDITY');
242         amountB = amountA.mul(reserveB) / reserveA;
243     }
244 
245     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
246     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
247         require(amountIn > 0, 'UnicSwapV2Library: INSUFFICIENT_INPUT_AMOUNT');
248         require(reserveIn > 0 && reserveOut > 0, 'UnicSwapV2Library: INSUFFICIENT_LIQUIDITY');
249         uint amountInWithFee = amountIn.mul(997);
250         uint numerator = amountInWithFee.mul(reserveOut);
251         uint denominator = reserveIn.mul(1000).add(amountInWithFee);
252         amountOut = numerator / denominator;
253     }
254 
255     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
256     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {
257         require(amountOut > 0, 'UnicSwapV2Library: INSUFFICIENT_OUTPUT_AMOUNT');
258         require(reserveIn > 0 && reserveOut > 0, 'UnicSwapV2Library: INSUFFICIENT_LIQUIDITY');
259         uint numerator = reserveIn.mul(amountOut).mul(1000);
260         uint denominator = reserveOut.sub(amountOut).mul(997);
261         amountIn = (numerator / denominator).add(1);
262     }
263 
264     // performs chained getAmountOut calculations on any number of pairs
265     function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {
266         require(path.length >= 2, 'UnicSwapV2Library: INVALID_PATH');
267         amounts = new uint[](path.length);
268         amounts[0] = amountIn;
269         for (uint i; i < path.length - 1; i++) {
270             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);
271             amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
272         }
273     }
274 
275     // performs chained getAmountIn calculations on any number of pairs
276     function getAmountsIn(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {
277         require(path.length >= 2, 'UnicSwapV2Library: INVALID_PATH');
278         amounts = new uint[](path.length);
279         amounts[amounts.length - 1] = amountOut;
280         for (uint i = path.length - 1; i > 0; i--) {
281             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);
282             amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
283         }
284     }
285 }
286 // Dependency file: contracts/interfaces/IUnicSwapV2Router02.sol
287 
288 // pragma solidity >=0.6.2;
289 
290 // import './IUnicSwapV2Router01.sol';
291 
292 interface IUnicSwapV2Router02 is IUnicSwapV2Router01 {
293     function removeLiquidityETHSupportingFeeOnTransferTokens(
294         address token,
295         uint liquidity,
296         uint amountTokenMin,
297         uint amountETHMin,
298         address to,
299         uint deadline
300     ) external returns (uint amountETH);
301     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
302         address token,
303         uint liquidity,
304         uint amountTokenMin,
305         uint amountETHMin,
306         address to,
307         uint deadline,
308         bool approveMax, uint8 v, bytes32 r, bytes32 s
309     ) external returns (uint amountETH);
310 
311 /*
312     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
313         uint amountIn,
314         uint amountOutMin,
315         address[] calldata path,
316         address to,
317         uint deadline
318     ) external;
319     function swapExactETHForTokensSupportingFeeOnTransferTokens(
320         uint amountOutMin,
321         address[] calldata path,
322         address to,
323         uint deadline
324     ) external payable;
325     function swapExactTokensForETHSupportingFeeOnTransferTokens(
326         uint amountIn,
327         uint amountOutMin,
328         address[] calldata path,
329         address to,
330         uint deadline
331     ) external;
332 */
333 }
334 // Dependency file: contracts/libraries/TransferHelper.sol
335 
336 // SPDX-License-Identifier: GPL-3.0-or-later
337 
338 // pragma solidity >=0.6.0;
339 
340 // helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
341 library TransferHelper {
342     function safeApprove(address token, address to, uint value) internal {
343         // bytes4(keccak256(bytes('approve(address,uint256)')));
344         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
345         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
346     }
347 
348     function safeTransfer(address token, address to, uint value) internal {
349         // bytes4(keccak256(bytes('transfer(address,uint256)')));
350         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
351         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
352     }
353 
354     function safeTransferFrom(address token, address from, address to, uint value) internal {
355         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
356         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
357         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
358     }
359 
360     function safeTransferETH(address to, uint value) internal {
361         (bool success,) = to.call{value:value}(new bytes(0));
362         require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
363     }
364 }
365 // Dependency file: contracts/interfaces/IUnicSwapV2Factory.sol
366 
367 // pragma solidity >=0.5.0;
368 
369 interface IUnicSwapV2Factory {
370     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
371 
372     function feeTo() external view returns (address);
373     function feeToSetter() external view returns (address);
374 
375     function getPair(address tokenA, address tokenB) external view returns (address pair);
376     function allPairs(uint) external view returns (address pair);
377     function allPairsLength() external view returns (uint);
378 
379     function createPair(address tokenA, address tokenB) external returns (address pair);
380 
381     function setFeeTo(address) external;
382     function setFeeToSetter(address) external;
383 }
384 
385 pragma solidity =0.6.12;
386 
387 // import './interfaces/IUnicSwapV2Factory.sol';
388 // import './libraries/TransferHelper.sol';
389 
390 // import './interfaces/IUnicSwapV2Router02.sol';
391 // import './libraries/UnicSwapV2Library.sol';
392 // import './libraries/SafeMath.sol';
393 // import './interfaces/IERC20.sol';
394 // import './interfaces/IWETH.sol';
395 
396 contract UnicSwapV2Router02 is IUnicSwapV2Router02 {
397     using SafeMath for uint;
398 
399     address public immutable override factory;
400     address public immutable override WETH;
401 
402     modifier ensure(uint deadline) {
403         require(deadline >= block.timestamp, 'UnicSwapV2Router: EXPIRED');
404         _;
405     }
406 
407     constructor(address _factory, address _WETH) public {
408         factory = _factory;
409         WETH = _WETH;
410     }
411 
412     receive() external payable {
413         assert(msg.sender == WETH); // only accept ETH via fallback from the WETH contract
414     }
415 
416     // **** ADD LIQUIDITY ****
417     function _addLiquidity(
418         address tokenA,
419         address tokenB,
420         uint amountADesired,
421         uint amountBDesired,
422         uint amountAMin,
423         uint amountBMin
424     ) internal virtual returns (uint amountA, uint amountB) {
425         // create the pair if it doesn't exist yet
426         if (IUnicSwapV2Factory(factory).getPair(tokenA, tokenB) == address(0)) {
427             IUnicSwapV2Factory(factory).createPair(tokenA, tokenB);
428         }
429         (uint reserveA, uint reserveB) = UnicSwapV2Library.getReserves(factory, tokenA, tokenB);
430         if (reserveA == 0 && reserveB == 0) {
431             (amountA, amountB) = (amountADesired, amountBDesired);
432         } else {
433             uint amountBOptimal = UnicSwapV2Library.quote(amountADesired, reserveA, reserveB);
434             if (amountBOptimal <= amountBDesired) {
435                 require(amountBOptimal >= amountBMin, 'UnicSwapV2Router: INSUFFICIENT_B_AMOUNT');
436                 (amountA, amountB) = (amountADesired, amountBOptimal);
437             } else {
438                 uint amountAOptimal = UnicSwapV2Library.quote(amountBDesired, reserveB, reserveA);
439                 assert(amountAOptimal <= amountADesired);
440                 require(amountAOptimal >= amountAMin, 'UnicSwapV2Router: INSUFFICIENT_A_AMOUNT');
441                 (amountA, amountB) = (amountAOptimal, amountBDesired);
442             }
443         }
444     }
445     function addLiquidity(
446         address tokenA,
447         address tokenB,
448         uint amountADesired,
449         uint amountBDesired,
450         uint amountAMin,
451         uint amountBMin,
452         address to,
453         uint deadline
454     ) external virtual override ensure(deadline) returns (uint amountA, uint amountB, uint liquidity) {
455         (amountA, amountB) = _addLiquidity(tokenA, tokenB, amountADesired, amountBDesired, amountAMin, amountBMin);
456         address pair = UnicSwapV2Library.pairFor(factory, tokenA, tokenB);
457         TransferHelper.safeTransferFrom(tokenA, msg.sender, pair, amountA);
458         TransferHelper.safeTransferFrom(tokenB, msg.sender, pair, amountB);
459         liquidity = IUnicSwapV2Pair(pair).mint(to);
460     }
461     function addLiquidityETH(
462         address token,
463         uint amountTokenDesired,
464         uint amountTokenMin,
465         uint amountETHMin,
466         address to,
467         uint deadline
468     ) external virtual override payable ensure(deadline) returns (uint amountToken, uint amountETH, uint liquidity) {
469         (amountToken, amountETH) = _addLiquidity(
470             token,
471             WETH,
472             amountTokenDesired,
473             msg.value,
474             amountTokenMin,
475             amountETHMin
476         );
477         address pair = UnicSwapV2Library.pairFor(factory, token, WETH);
478         TransferHelper.safeTransferFrom(token, msg.sender, pair, amountToken);
479         IWETH(WETH).deposit{value: amountETH}();
480         assert(IWETH(WETH).transfer(pair, amountETH));
481         liquidity = IUnicSwapV2Pair(pair).mint(to);
482         // refund dust eth, if any
483         if (msg.value > amountETH) TransferHelper.safeTransferETH(msg.sender, msg.value - amountETH);
484     }
485 
486     // **** REMOVE LIQUIDITY ****
487     function removeLiquidity(
488         address tokenA,
489         address tokenB,
490         uint liquidity,
491         uint amountAMin,
492         uint amountBMin,
493         address to,
494         uint deadline
495     ) public virtual override ensure(deadline) returns (uint amountA, uint amountB) {
496         address pair = UnicSwapV2Library.pairFor(factory, tokenA, tokenB);
497         IUnicSwapV2Pair(pair).transferFrom(msg.sender, pair, liquidity); // send liquidity to pair
498         (uint amount0, uint amount1) = IUnicSwapV2Pair(pair).burn(to);
499         (address token0,) = UnicSwapV2Library.sortTokens(tokenA, tokenB);
500         (amountA, amountB) = tokenA == token0 ? (amount0, amount1) : (amount1, amount0);
501         require(amountA >= amountAMin, 'UnicSwapV2Router: INSUFFICIENT_A_AMOUNT');
502         require(amountB >= amountBMin, 'UnicSwapV2Router: INSUFFICIENT_B_AMOUNT');
503     }
504     function removeLiquidityETH(
505         address token,
506         uint liquidity,
507         uint amountTokenMin,
508         uint amountETHMin,
509         address to,
510         uint deadline
511     ) public virtual override ensure(deadline) returns (uint amountToken, uint amountETH) {
512         (amountToken, amountETH) = removeLiquidity(
513             token,
514             WETH,
515             liquidity,
516             amountTokenMin,
517             amountETHMin,
518             address(this),
519             deadline
520         );
521         TransferHelper.safeTransfer(token, to, amountToken);
522         IWETH(WETH).withdraw(amountETH);
523         TransferHelper.safeTransferETH(to, amountETH);
524     }
525     function removeLiquidityWithPermit(
526         address tokenA,
527         address tokenB,
528         uint liquidity,
529         uint amountAMin,
530         uint amountBMin,
531         address to,
532         uint deadline,
533         bool approveMax, uint8 v, bytes32 r, bytes32 s
534     ) external virtual override returns (uint amountA, uint amountB) {
535         address pair = UnicSwapV2Library.pairFor(factory, tokenA, tokenB);
536         uint value = approveMax ? uint(-1) : liquidity;
537         IUnicSwapV2Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
538         (amountA, amountB) = removeLiquidity(tokenA, tokenB, liquidity, amountAMin, amountBMin, to, deadline);
539     }
540     function removeLiquidityETHWithPermit(
541         address token,
542         uint liquidity,
543         uint amountTokenMin,
544         uint amountETHMin,
545         address to,
546         uint deadline,
547         bool approveMax, uint8 v, bytes32 r, bytes32 s
548     ) external virtual override returns (uint amountToken, uint amountETH) {
549         address pair = UnicSwapV2Library.pairFor(factory, token, WETH);
550         uint value = approveMax ? uint(-1) : liquidity;
551         IUnicSwapV2Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
552         (amountToken, amountETH) = removeLiquidityETH(token, liquidity, amountTokenMin, amountETHMin, to, deadline);
553     }
554 
555     // **** REMOVE LIQUIDITY (supporting fee-on-transfer tokens) ****
556     function removeLiquidityETHSupportingFeeOnTransferTokens(
557         address token,
558         uint liquidity,
559         uint amountTokenMin,
560         uint amountETHMin,
561         address to,
562         uint deadline
563     ) public virtual override ensure(deadline) returns (uint amountETH) {
564         (, amountETH) = removeLiquidity(
565             token,
566             WETH,
567             liquidity,
568             amountTokenMin,
569             amountETHMin,
570             address(this),
571             deadline
572         );
573         TransferHelper.safeTransfer(token, to, IERC20(token).balanceOf(address(this)));
574         IWETH(WETH).withdraw(amountETH);
575         TransferHelper.safeTransferETH(to, amountETH);
576     }
577     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
578         address token,
579         uint liquidity,
580         uint amountTokenMin,
581         uint amountETHMin,
582         address to,
583         uint deadline,
584         bool approveMax, uint8 v, bytes32 r, bytes32 s
585     ) external virtual override returns (uint amountETH) {
586         address pair = UnicSwapV2Library.pairFor(factory, token, WETH);
587         uint value = approveMax ? uint(-1) : liquidity;
588         IUnicSwapV2Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
589         amountETH = removeLiquidityETHSupportingFeeOnTransferTokens(
590             token, liquidity, amountTokenMin, amountETHMin, to, deadline
591         );
592     }
593 
594     // **** SWAP ****
595     // requires the initial amount to have already been sent to the first pair
596     function _swap(uint[] memory amounts, address[] memory path, address _to) internal virtual {
597         for (uint i; i < path.length - 1; i++) {
598             (address input, address output) = (path[i], path[i + 1]);
599             (address token0,) = UnicSwapV2Library.sortTokens(input, output);
600             uint amountOut = amounts[i + 1];
601             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOut) : (amountOut, uint(0));
602             address to = i < path.length - 2 ? UnicSwapV2Library.pairFor(factory, output, path[i + 2]) : _to;
603             IUnicSwapV2Pair(UnicSwapV2Library.pairFor(factory, input, output)).swap(
604                 amount0Out, amount1Out, to, new bytes(0)
605             );
606         }
607     }
608     function swapExactTokensForTokens(
609         uint amountIn,
610         uint amountOutMin,
611         address[] calldata path,
612         address to,
613         uint deadline
614     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
615         amounts = UnicSwapV2Library.getAmountsOut(factory, amountIn, path);
616         require(amounts[amounts.length - 1] >= amountOutMin, 'UnicSwapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
617         TransferHelper.safeTransferFrom(
618             path[0], msg.sender, UnicSwapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
619         );
620         _swap(amounts, path, to);
621     }
622     function swapTokensForExactTokens(
623         uint amountOut,
624         uint amountInMax,
625         address[] calldata path,
626         address to,
627         uint deadline
628     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
629         amounts = UnicSwapV2Library.getAmountsIn(factory, amountOut, path);
630         require(amounts[0] <= amountInMax, 'UnicSwapV2Router: EXCESSIVE_INPUT_AMOUNT');
631         TransferHelper.safeTransferFrom(
632             path[0], msg.sender, UnicSwapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
633         );
634         _swap(amounts, path, to);
635     }
636     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
637         external
638         virtual
639         override
640         payable
641         ensure(deadline)
642         returns (uint[] memory amounts)
643     {
644         require(path[0] == WETH, 'UnicSwapV2Router: INVALID_PATH');
645         amounts = UnicSwapV2Library.getAmountsOut(factory, msg.value, path);
646         require(amounts[amounts.length - 1] >= amountOutMin, 'UnicSwapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
647         IWETH(WETH).deposit{value: amounts[0]}();
648         assert(IWETH(WETH).transfer(UnicSwapV2Library.pairFor(factory, path[0], path[1]), amounts[0]));
649         _swap(amounts, path, to);
650     }
651     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
652         external
653         virtual
654         override
655         ensure(deadline)
656         returns (uint[] memory amounts)
657     {
658         require(path[path.length - 1] == WETH, 'UnicSwapV2Router: INVALID_PATH');
659         amounts = UnicSwapV2Library.getAmountsIn(factory, amountOut, path);
660         require(amounts[0] <= amountInMax, 'UnicSwapV2Router: EXCESSIVE_INPUT_AMOUNT');
661         TransferHelper.safeTransferFrom(
662             path[0], msg.sender, UnicSwapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
663         );
664         _swap(amounts, path, address(this));
665         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
666         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
667     }
668     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
669         external
670         virtual
671         override
672         ensure(deadline)
673         returns (uint[] memory amounts)
674     {
675         require(path[path.length - 1] == WETH, 'UnicSwapV2Router: INVALID_PATH');
676         amounts = UnicSwapV2Library.getAmountsOut(factory, amountIn, path);
677         require(amounts[amounts.length - 1] >= amountOutMin, 'UnicSwapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
678         TransferHelper.safeTransferFrom(
679             path[0], msg.sender, UnicSwapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
680         );
681         _swap(amounts, path, address(this));
682         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
683         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
684     }
685     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
686         external
687         virtual
688         override
689         payable
690         ensure(deadline)
691         returns (uint[] memory amounts)
692     {
693         require(path[0] == WETH, 'UnicSwapV2Router: INVALID_PATH');
694         amounts = UnicSwapV2Library.getAmountsIn(factory, amountOut, path);
695         require(amounts[0] <= msg.value, 'UnicSwapV2Router: EXCESSIVE_INPUT_AMOUNT');
696         IWETH(WETH).deposit{value: amounts[0]}();
697         assert(IWETH(WETH).transfer(UnicSwapV2Library.pairFor(factory, path[0], path[1]), amounts[0]));
698         _swap(amounts, path, to);
699         // refund dust eth, if any
700         if (msg.value > amounts[0]) TransferHelper.safeTransferETH(msg.sender, msg.value - amounts[0]);
701     }
702 /*
703     // **** SWAP (supporting fee-on-transfer tokens) ****
704     // requires the initial amount to have already been sent to the first pair
705     function _swapSupportingFeeOnTransferTokens(address[] memory path, address _to) internal virtual {
706         for (uint i; i < path.length - 1; i++) {
707             (address input, address output) = (path[i], path[i + 1]);
708             (address token0,) = UnicSwapV2Library.sortTokens(input, output);
709             IUnicSwapV2Pair pair = IUnicSwapV2Pair(UnicSwapV2Library.pairFor(factory, input, output));
710             uint amountInput;
711             uint amountOutput;
712             { // scope to avoid stack too deep errors
713             (uint reserve0, uint reserve1,) = pair.getReserves();
714             (uint reserveInput, uint reserveOutput) = input == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
715             amountInput = IERC20(input).balanceOf(address(pair)).sub(reserveInput);
716             amountOutput = UnicSwapV2Library.getAmountOut(amountInput, reserveInput, reserveOutput);
717             }
718             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOutput) : (amountOutput, uint(0));
719             address to = i < path.length - 2 ? UnicSwapV2Library.pairFor(factory, output, path[i + 2]) : _to;
720             pair.swap(amount0Out, amount1Out, to, new bytes(0));
721         }
722     }
723     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
724         uint amountIn,
725         uint amountOutMin,
726         address[] calldata path,
727         address to,
728         uint deadline
729     ) external virtual override ensure(deadline) {
730         TransferHelper.safeTransferFrom(
731             path[0], msg.sender, UnicSwapV2Library.pairFor(factory, path[0], path[1]), amountIn
732         );
733         uint balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
734         _swapSupportingFeeOnTransferTokens(path, to);
735         require(
736             IERC20(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
737             'UnicSwapV2Router: INSUFFICIENT_OUTPUT_AMOUNT'
738         );
739     }
740     function swapExactETHForTokensSupportingFeeOnTransferTokens(
741         uint amountOutMin,
742         address[] calldata path,
743         address to,
744         uint deadline
745     )
746         external
747         virtual
748         override
749         payable
750         ensure(deadline)
751     {
752         require(path[0] == WETH, 'UnicSwapV2Router: INVALID_PATH');
753         uint amountIn = msg.value;
754         IWETH(WETH).deposit{value: amountIn}();
755         assert(IWETH(WETH).transfer(UnicSwapV2Library.pairFor(factory, path[0], path[1]), amountIn));
756         uint balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
757         _swapSupportingFeeOnTransferTokens(path, to);
758         require(
759             IERC20(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
760             'UnicSwapV2Router: INSUFFICIENT_OUTPUT_AMOUNT'
761         );
762     }
763     function swapExactTokensForETHSupportingFeeOnTransferTokens(
764         uint amountIn,
765         uint amountOutMin,
766         address[] calldata path,
767         address to,
768         uint deadline
769     )
770         external
771         virtual
772         override
773         ensure(deadline)
774     {
775         require(path[path.length - 1] == WETH, 'UnicSwapV2Router: INVALID_PATH');
776         TransferHelper.safeTransferFrom(
777             path[0], msg.sender, UnicSwapV2Library.pairFor(factory, path[0], path[1]), amountIn
778         );
779         _swapSupportingFeeOnTransferTokens(path, address(this));
780         uint amountOut = IERC20(WETH).balanceOf(address(this));
781         require(amountOut >= amountOutMin, 'UnicSwapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
782         IWETH(WETH).withdraw(amountOut);
783         TransferHelper.safeTransferETH(to, amountOut);
784     }
785 */
786     // **** LIBRARY FUNCTIONS ****
787     function quote(uint amountA, uint reserveA, uint reserveB) public pure virtual override returns (uint amountB) {
788         return UnicSwapV2Library.quote(amountA, reserveA, reserveB);
789     }
790 
791     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut)
792         public
793         pure
794         virtual
795         override
796         returns (uint amountOut)
797     {
798         return UnicSwapV2Library.getAmountOut(amountIn, reserveIn, reserveOut);
799     }
800 
801     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut)
802         public
803         pure
804         virtual
805         override
806         returns (uint amountIn)
807     {
808         return UnicSwapV2Library.getAmountIn(amountOut, reserveIn, reserveOut);
809     }
810 
811     function getAmountsOut(uint amountIn, address[] memory path)
812         public
813         view
814         virtual
815         override
816         returns (uint[] memory amounts)
817     {
818         return UnicSwapV2Library.getAmountsOut(factory, amountIn, path);
819     }
820 
821     function getAmountsIn(uint amountOut, address[] memory path)
822         public
823         view
824         virtual
825         override
826         returns (uint[] memory amounts)
827     {
828         return UnicSwapV2Library.getAmountsIn(factory, amountOut, path);
829     }
830 }