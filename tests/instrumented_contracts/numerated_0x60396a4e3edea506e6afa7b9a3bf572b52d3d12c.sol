1 // File: @eliteswap/v2-core/contracts/interfaces/IEliteswapV2Factory.sol
2 
3 pragma solidity >=0.5.0;
4 
5 interface IEliteswapV2Factory {
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
21 // File: @eliteswap/lib/contracts/libraries/TransferHelper.sol
22 
23 // SPDX-License-Identifier: GPL-3.0-or-later
24 
25 pragma solidity >=0.6.0;
26 
27 // helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
28 library TransferHelper {
29     function safeApprove(
30         address token,
31         address to,
32         uint256 value
33     ) internal {
34         // bytes4(keccak256(bytes('approve(address,uint256)')));
35         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
36         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
37     }
38 
39     function safeTransfer(
40         address token,
41         address to,
42         uint256 value
43     ) internal {
44         // bytes4(keccak256(bytes('transfer(address,uint256)')));
45         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
46         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
47     }
48 
49     function safeTransferFrom(
50         address token,
51         address from,
52         address to,
53         uint256 value
54     ) internal {
55         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
56         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
57         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
58     }
59 
60     function safeTransferETH(address to, uint256 value) internal {
61         (bool success, ) = to.call{value: value}(new bytes(0));
62         require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
63     }
64 }
65 
66 // File: contracts/interfaces/IEliteswapV2Router01.sol
67 
68 pragma solidity >=0.6.2;
69 
70 interface IEliteswapV2Router01 {
71     function factory() external pure returns (address);
72     function WETH() external pure returns (address);
73 
74     function addLiquidity(
75         address tokenA,
76         address tokenB,
77         uint amountADesired,
78         uint amountBDesired,
79         uint amountAMin,
80         uint amountBMin,
81         address to,
82         uint deadline
83     ) external returns (uint amountA, uint amountB, uint liquidity);
84     function addLiquidityETH(
85         address token,
86         uint amountTokenDesired,
87         uint amountTokenMin,
88         uint amountETHMin,
89         address to,
90         uint deadline
91     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
92     function removeLiquidity(
93         address tokenA,
94         address tokenB,
95         uint liquidity,
96         uint amountAMin,
97         uint amountBMin,
98         address to,
99         uint deadline
100     ) external returns (uint amountA, uint amountB);
101     function removeLiquidityETH(
102         address token,
103         uint liquidity,
104         uint amountTokenMin,
105         uint amountETHMin,
106         address to,
107         uint deadline
108     ) external returns (uint amountToken, uint amountETH);
109     function removeLiquidityWithPermit(
110         address tokenA,
111         address tokenB,
112         uint liquidity,
113         uint amountAMin,
114         uint amountBMin,
115         address to,
116         uint deadline,
117         bool approveMax, uint8 v, bytes32 r, bytes32 s
118     ) external returns (uint amountA, uint amountB);
119     function removeLiquidityETHWithPermit(
120         address token,
121         uint liquidity,
122         uint amountTokenMin,
123         uint amountETHMin,
124         address to,
125         uint deadline,
126         bool approveMax, uint8 v, bytes32 r, bytes32 s
127     ) external returns (uint amountToken, uint amountETH);
128     function swapExactTokensForTokens(
129         uint amountIn,
130         uint amountOutMin,
131         address[] calldata path,
132         address to,
133         uint deadline
134     ) external returns (uint[] memory amounts);
135     function swapTokensForExactTokens(
136         uint amountOut,
137         uint amountInMax,
138         address[] calldata path,
139         address to,
140         uint deadline
141     ) external returns (uint[] memory amounts);
142     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
143         external
144         payable
145         returns (uint[] memory amounts);
146     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
147         external
148         returns (uint[] memory amounts);
149     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
150         external
151         returns (uint[] memory amounts);
152     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
153         external
154         payable
155         returns (uint[] memory amounts);
156 
157     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
158     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
159     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
160     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
161     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
162 }
163 
164 // File: contracts/interfaces/IEliteswapV2Router02.sol
165 
166 pragma solidity >=0.6.2;
167 
168 
169 interface IEliteswapV2Router02 is IEliteswapV2Router01 {
170     function removeLiquidityETHSupportingFeeOnTransferTokens(
171         address token,
172         uint liquidity,
173         uint amountTokenMin,
174         uint amountETHMin,
175         address to,
176         uint deadline
177     ) external returns (uint amountETH);
178     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
179         address token,
180         uint liquidity,
181         uint amountTokenMin,
182         uint amountETHMin,
183         address to,
184         uint deadline,
185         bool approveMax, uint8 v, bytes32 r, bytes32 s
186     ) external returns (uint amountETH);
187 
188     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
189         uint amountIn,
190         uint amountOutMin,
191         address[] calldata path,
192         address to,
193         uint deadline
194     ) external;
195     function swapExactETHForTokensSupportingFeeOnTransferTokens(
196         uint amountOutMin,
197         address[] calldata path,
198         address to,
199         uint deadline
200     ) external payable;
201     function swapExactTokensForETHSupportingFeeOnTransferTokens(
202         uint amountIn,
203         uint amountOutMin,
204         address[] calldata path,
205         address to,
206         uint deadline
207     ) external;
208 }
209 
210 // File: @eliteswap/v2-core/contracts/interfaces/IEliteswapV2Pair.sol
211 
212 pragma solidity >=0.5.0;
213 
214 interface IEliteswapV2Pair {
215     event Approval(address indexed owner, address indexed spender, uint value);
216     event Transfer(address indexed from, address indexed to, uint value);
217 
218     function name() external pure returns (string memory);
219     function symbol() external pure returns (string memory);
220     function decimals() external pure returns (uint8);
221     function totalSupply() external view returns (uint);
222     function balanceOf(address owner) external view returns (uint);
223     function allowance(address owner, address spender) external view returns (uint);
224 
225     function approve(address spender, uint value) external returns (bool);
226     function transfer(address to, uint value) external returns (bool);
227     function transferFrom(address from, address to, uint value) external returns (bool);
228 
229     function DOMAIN_SEPARATOR() external view returns (bytes32);
230     function PERMIT_TYPEHASH() external pure returns (bytes32);
231     function nonces(address owner) external view returns (uint);
232 
233     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
234 
235     event Mint(address indexed sender, uint amount0, uint amount1);
236     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
237     event Swap(
238         address indexed sender,
239         uint amount0In,
240         uint amount1In,
241         uint amount0Out,
242         uint amount1Out,
243         address indexed to
244     );
245     event Sync(uint112 reserve0, uint112 reserve1);
246 
247     function MINIMUM_LIQUIDITY() external pure returns (uint);
248     function factory() external view returns (address);
249     function token0() external view returns (address);
250     function token1() external view returns (address);
251     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
252     function price0CumulativeLast() external view returns (uint);
253     function price1CumulativeLast() external view returns (uint);
254     function kLast() external view returns (uint);
255 
256     function mint(address to) external returns (uint liquidity);
257     function burn(address to) external returns (uint amount0, uint amount1);
258     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
259     function skim(address to) external;
260     function sync() external;
261 
262     function initialize(address, address) external;
263 }
264 
265 // File: contracts/libraries/SafeMath.sol
266 
267 pragma solidity =0.6.6;
268 
269 // a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)
270 
271 library SafeMath {
272     function add(uint x, uint y) internal pure returns (uint z) {
273         require((z = x + y) >= x, 'ds-math-add-overflow');
274     }
275 
276     function sub(uint x, uint y) internal pure returns (uint z) {
277         require((z = x - y) <= x, 'ds-math-sub-underflow');
278     }
279 
280     function mul(uint x, uint y) internal pure returns (uint z) {
281         require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');
282     }
283 }
284 
285 // File: contracts/libraries/EliteswapV2Library.sol
286 
287 pragma solidity >=0.5.0;
288 
289 
290 
291 library EliteswapV2Library {
292     using SafeMath for uint;
293 
294     // returns sorted token addresses, used to handle return values from pairs sorted in this order
295     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
296         require(tokenA != tokenB, 'EliteswapV2Library: IDENTICAL_ADDRESSES');
297         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
298         require(token0 != address(0), 'EliteswapV2Library: ZERO_ADDRESS');
299     }
300 
301     // calculates the CREATE2 address for a pair without making any external calls
302     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
303         (address token0, address token1) = sortTokens(tokenA, tokenB);
304         pair = address(uint(keccak256(abi.encodePacked(
305                 hex'ff',
306                 factory,
307                 keccak256(abi.encodePacked(token0, token1)),
308                 hex'64f97409dbeefccef0bb9f1a9040b723d266b70ef5ae1769cb7e3457f8d0542a' // init code hash
309             ))));
310     }
311 
312     // fetches and sorts the reserves for a pair
313     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
314         (address token0,) = sortTokens(tokenA, tokenB);
315         (uint reserve0, uint reserve1,) = IEliteswapV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();
316         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
317     }
318 
319     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
320     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
321         require(amountA > 0, 'EliteswapV2Library: INSUFFICIENT_AMOUNT');
322         require(reserveA > 0 && reserveB > 0, 'EliteswapV2Library: INSUFFICIENT_LIQUIDITY');
323         amountB = amountA.mul(reserveB) / reserveA;
324     }
325 
326     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
327     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
328         require(amountIn > 0, 'EliteswapV2Library: INSUFFICIENT_INPUT_AMOUNT');
329         require(reserveIn > 0 && reserveOut > 0, 'EliteswapV2Library: INSUFFICIENT_LIQUIDITY');
330         uint amountInWithFee = amountIn.mul(997);
331         uint numerator = amountInWithFee.mul(reserveOut);
332         uint denominator = reserveIn.mul(1000).add(amountInWithFee);
333         amountOut = numerator / denominator;
334     }
335 
336     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
337     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {
338         require(amountOut > 0, 'EliteswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT');
339         require(reserveIn > 0 && reserveOut > 0, 'EliteswapV2Library: INSUFFICIENT_LIQUIDITY');
340         uint numerator = reserveIn.mul(amountOut).mul(1000);
341         uint denominator = reserveOut.sub(amountOut).mul(997);
342         amountIn = (numerator / denominator).add(1);
343     }
344 
345     // performs chained getAmountOut calculations on any number of pairs
346     function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {
347         require(path.length >= 2, 'EliteswapV2Library: INVALID_PATH');
348         amounts = new uint[](path.length);
349         amounts[0] = amountIn;
350         for (uint i; i < path.length - 1; i++) {
351             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);
352             amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
353         }
354     }
355 
356     // performs chained getAmountIn calculations on any number of pairs
357     function getAmountsIn(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {
358         require(path.length >= 2, 'EliteswapV2Library: INVALID_PATH');
359         amounts = new uint[](path.length);
360         amounts[amounts.length - 1] = amountOut;
361         for (uint i = path.length - 1; i > 0; i--) {
362             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);
363             amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
364         }
365     }
366 }
367 
368 // File: contracts/interfaces/IERC20.sol
369 
370 pragma solidity >=0.5.0;
371 
372 interface IERC20 {
373     event Approval(address indexed owner, address indexed spender, uint value);
374     event Transfer(address indexed from, address indexed to, uint value);
375 
376     function name() external view returns (string memory);
377     function symbol() external view returns (string memory);
378     function decimals() external view returns (uint8);
379     function totalSupply() external view returns (uint);
380     function balanceOf(address owner) external view returns (uint);
381     function allowance(address owner, address spender) external view returns (uint);
382 
383     function approve(address spender, uint value) external returns (bool);
384     function transfer(address to, uint value) external returns (bool);
385     function transferFrom(address from, address to, uint value) external returns (bool);
386 }
387 
388 // File: contracts/interfaces/IWETH.sol
389 
390 pragma solidity >=0.5.0;
391 
392 interface IWETH {
393     function deposit() external payable;
394     function transfer(address to, uint value) external returns (bool);
395     function withdraw(uint) external;
396 }
397 
398 // File: contracts/EliteswapV2Router02.sol
399 
400 pragma solidity =0.6.6;
401 
402 
403 
404 
405 
406 
407 
408 
409 contract EliteswapV2Router02 is IEliteswapV2Router02 {
410     using SafeMath for uint;
411 
412     address public immutable override factory;
413     address public immutable override WETH;
414 
415     modifier ensure(uint deadline) {
416         require(deadline >= block.timestamp, 'EliteswapV2Router: EXPIRED');
417         _;
418     }
419 
420     constructor(address _factory, address _WETH) public {
421         factory = _factory;
422         WETH = _WETH;
423     }
424 
425     receive() external payable {
426         assert(msg.sender == WETH); // only accept ETH via fallback from the WETH contract
427     }
428 
429     // **** ADD LIQUIDITY ****
430     function _addLiquidity(
431         address tokenA,
432         address tokenB,
433         uint amountADesired,
434         uint amountBDesired,
435         uint amountAMin,
436         uint amountBMin
437     ) internal virtual returns (uint amountA, uint amountB) {
438         // create the pair if it doesn't exist yet
439         if (IEliteswapV2Factory(factory).getPair(tokenA, tokenB) == address(0)) {
440             IEliteswapV2Factory(factory).createPair(tokenA, tokenB);
441         }
442         (uint reserveA, uint reserveB) = EliteswapV2Library.getReserves(factory, tokenA, tokenB);
443         if (reserveA == 0 && reserveB == 0) {
444             (amountA, amountB) = (amountADesired, amountBDesired);
445         } else {
446             uint amountBOptimal = EliteswapV2Library.quote(amountADesired, reserveA, reserveB);
447             if (amountBOptimal <= amountBDesired) {
448                 require(amountBOptimal >= amountBMin, 'EliteswapV2Router: INSUFFICIENT_B_AMOUNT');
449                 (amountA, amountB) = (amountADesired, amountBOptimal);
450             } else {
451                 uint amountAOptimal = EliteswapV2Library.quote(amountBDesired, reserveB, reserveA);
452                 assert(amountAOptimal <= amountADesired);
453                 require(amountAOptimal >= amountAMin, 'EliteswapV2Router: INSUFFICIENT_A_AMOUNT');
454                 (amountA, amountB) = (amountAOptimal, amountBDesired);
455             }
456         }
457     }
458     function addLiquidity(
459         address tokenA,
460         address tokenB,
461         uint amountADesired,
462         uint amountBDesired,
463         uint amountAMin,
464         uint amountBMin,
465         address to,
466         uint deadline
467     ) external virtual override ensure(deadline) returns (uint amountA, uint amountB, uint liquidity) {
468         (amountA, amountB) = _addLiquidity(tokenA, tokenB, amountADesired, amountBDesired, amountAMin, amountBMin);
469         address pair = EliteswapV2Library.pairFor(factory, tokenA, tokenB);
470         TransferHelper.safeTransferFrom(tokenA, msg.sender, pair, amountA);
471         TransferHelper.safeTransferFrom(tokenB, msg.sender, pair, amountB);
472         liquidity = IEliteswapV2Pair(pair).mint(to);
473     }
474     function addLiquidityETH(
475         address token,
476         uint amountTokenDesired,
477         uint amountTokenMin,
478         uint amountETHMin,
479         address to,
480         uint deadline
481     ) external virtual override payable ensure(deadline) returns (uint amountToken, uint amountETH, uint liquidity) {
482         (amountToken, amountETH) = _addLiquidity(
483             token,
484             WETH,
485             amountTokenDesired,
486             msg.value,
487             amountTokenMin,
488             amountETHMin
489         );
490         address pair = EliteswapV2Library.pairFor(factory, token, WETH);
491         TransferHelper.safeTransferFrom(token, msg.sender, pair, amountToken);
492         IWETH(WETH).deposit{value: amountETH}();
493         assert(IWETH(WETH).transfer(pair, amountETH));
494         liquidity = IEliteswapV2Pair(pair).mint(to);
495         // refund dust eth, if any
496         if (msg.value > amountETH) TransferHelper.safeTransferETH(msg.sender, msg.value - amountETH);
497     }
498 
499     // **** REMOVE LIQUIDITY ****
500     function removeLiquidity(
501         address tokenA,
502         address tokenB,
503         uint liquidity,
504         uint amountAMin,
505         uint amountBMin,
506         address to,
507         uint deadline
508     ) public virtual override ensure(deadline) returns (uint amountA, uint amountB) {
509         address pair = EliteswapV2Library.pairFor(factory, tokenA, tokenB);
510         IEliteswapV2Pair(pair).transferFrom(msg.sender, pair, liquidity); // send liquidity to pair
511         (uint amount0, uint amount1) = IEliteswapV2Pair(pair).burn(to);
512         (address token0,) = EliteswapV2Library.sortTokens(tokenA, tokenB);
513         (amountA, amountB) = tokenA == token0 ? (amount0, amount1) : (amount1, amount0);
514         require(amountA >= amountAMin, 'EliteswapV2Router: INSUFFICIENT_A_AMOUNT');
515         require(amountB >= amountBMin, 'EliteswapV2Router: INSUFFICIENT_B_AMOUNT');
516     }
517     function removeLiquidityETH(
518         address token,
519         uint liquidity,
520         uint amountTokenMin,
521         uint amountETHMin,
522         address to,
523         uint deadline
524     ) public virtual override ensure(deadline) returns (uint amountToken, uint amountETH) {
525         (amountToken, amountETH) = removeLiquidity(
526             token,
527             WETH,
528             liquidity,
529             amountTokenMin,
530             amountETHMin,
531             address(this),
532             deadline
533         );
534         TransferHelper.safeTransfer(token, to, amountToken);
535         IWETH(WETH).withdraw(amountETH);
536         TransferHelper.safeTransferETH(to, amountETH);
537     }
538     function removeLiquidityWithPermit(
539         address tokenA,
540         address tokenB,
541         uint liquidity,
542         uint amountAMin,
543         uint amountBMin,
544         address to,
545         uint deadline,
546         bool approveMax, uint8 v, bytes32 r, bytes32 s
547     ) external virtual override returns (uint amountA, uint amountB) {
548         address pair = EliteswapV2Library.pairFor(factory, tokenA, tokenB);
549         uint value = approveMax ? uint(-1) : liquidity;
550         IEliteswapV2Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
551         (amountA, amountB) = removeLiquidity(tokenA, tokenB, liquidity, amountAMin, amountBMin, to, deadline);
552     }
553     function removeLiquidityETHWithPermit(
554         address token,
555         uint liquidity,
556         uint amountTokenMin,
557         uint amountETHMin,
558         address to,
559         uint deadline,
560         bool approveMax, uint8 v, bytes32 r, bytes32 s
561     ) external virtual override returns (uint amountToken, uint amountETH) {
562         address pair = EliteswapV2Library.pairFor(factory, token, WETH);
563         uint value = approveMax ? uint(-1) : liquidity;
564         IEliteswapV2Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
565         (amountToken, amountETH) = removeLiquidityETH(token, liquidity, amountTokenMin, amountETHMin, to, deadline);
566     }
567 
568     // **** REMOVE LIQUIDITY (supporting fee-on-transfer tokens) ****
569     function removeLiquidityETHSupportingFeeOnTransferTokens(
570         address token,
571         uint liquidity,
572         uint amountTokenMin,
573         uint amountETHMin,
574         address to,
575         uint deadline
576     ) public virtual override ensure(deadline) returns (uint amountETH) {
577         (, amountETH) = removeLiquidity(
578             token,
579             WETH,
580             liquidity,
581             amountTokenMin,
582             amountETHMin,
583             address(this),
584             deadline
585         );
586         TransferHelper.safeTransfer(token, to, IERC20(token).balanceOf(address(this)));
587         IWETH(WETH).withdraw(amountETH);
588         TransferHelper.safeTransferETH(to, amountETH);
589     }
590     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
591         address token,
592         uint liquidity,
593         uint amountTokenMin,
594         uint amountETHMin,
595         address to,
596         uint deadline,
597         bool approveMax, uint8 v, bytes32 r, bytes32 s
598     ) external virtual override returns (uint amountETH) {
599         address pair = EliteswapV2Library.pairFor(factory, token, WETH);
600         uint value = approveMax ? uint(-1) : liquidity;
601         IEliteswapV2Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
602         amountETH = removeLiquidityETHSupportingFeeOnTransferTokens(
603             token, liquidity, amountTokenMin, amountETHMin, to, deadline
604         );
605     }
606 
607     // **** SWAP ****
608     // requires the initial amount to have already been sent to the first pair
609     function _swap(uint[] memory amounts, address[] memory path, address _to) internal virtual {
610         for (uint i; i < path.length - 1; i++) {
611             (address input, address output) = (path[i], path[i + 1]);
612             (address token0,) = EliteswapV2Library.sortTokens(input, output);
613             uint amountOut = amounts[i + 1];
614             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOut) : (amountOut, uint(0));
615             address to = i < path.length - 2 ? EliteswapV2Library.pairFor(factory, output, path[i + 2]) : _to;
616             IEliteswapV2Pair(EliteswapV2Library.pairFor(factory, input, output)).swap(
617                 amount0Out, amount1Out, to, new bytes(0)
618             );
619         }
620     }
621     function swapExactTokensForTokens(
622         uint amountIn,
623         uint amountOutMin,
624         address[] calldata path,
625         address to,
626         uint deadline
627     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
628         amounts = EliteswapV2Library.getAmountsOut(factory, amountIn, path);
629         require(amounts[amounts.length - 1] >= amountOutMin, 'EliteswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
630         TransferHelper.safeTransferFrom(
631             path[0], msg.sender, EliteswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
632         );
633         _swap(amounts, path, to);
634     }
635     function swapTokensForExactTokens(
636         uint amountOut,
637         uint amountInMax,
638         address[] calldata path,
639         address to,
640         uint deadline
641     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
642         amounts = EliteswapV2Library.getAmountsIn(factory, amountOut, path);
643         require(amounts[0] <= amountInMax, 'EliteswapV2Router: EXCESSIVE_INPUT_AMOUNT');
644         TransferHelper.safeTransferFrom(
645             path[0], msg.sender, EliteswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
646         );
647         _swap(amounts, path, to);
648     }
649     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
650         external
651         virtual
652         override
653         payable
654         ensure(deadline)
655         returns (uint[] memory amounts)
656     {
657         require(path[0] == WETH, 'EliteswapV2Router: INVALID_PATH');
658         amounts = EliteswapV2Library.getAmountsOut(factory, msg.value, path);
659         require(amounts[amounts.length - 1] >= amountOutMin, 'EliteswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
660         IWETH(WETH).deposit{value: amounts[0]}();
661         assert(IWETH(WETH).transfer(EliteswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]));
662         _swap(amounts, path, to);
663     }
664     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
665         external
666         virtual
667         override
668         ensure(deadline)
669         returns (uint[] memory amounts)
670     {
671         require(path[path.length - 1] == WETH, 'EliteswapV2Router: INVALID_PATH');
672         amounts = EliteswapV2Library.getAmountsIn(factory, amountOut, path);
673         require(amounts[0] <= amountInMax, 'EliteswapV2Router: EXCESSIVE_INPUT_AMOUNT');
674         TransferHelper.safeTransferFrom(
675             path[0], msg.sender, EliteswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
676         );
677         _swap(amounts, path, address(this));
678         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
679         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
680     }
681     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
682         external
683         virtual
684         override
685         ensure(deadline)
686         returns (uint[] memory amounts)
687     {
688         require(path[path.length - 1] == WETH, 'EliteswapV2Router: INVALID_PATH');
689         amounts = EliteswapV2Library.getAmountsOut(factory, amountIn, path);
690         require(amounts[amounts.length - 1] >= amountOutMin, 'EliteswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
691         TransferHelper.safeTransferFrom(
692             path[0], msg.sender, EliteswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
693         );
694         _swap(amounts, path, address(this));
695         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
696         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
697     }
698     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
699         external
700         virtual
701         override
702         payable
703         ensure(deadline)
704         returns (uint[] memory amounts)
705     {
706         require(path[0] == WETH, 'EliteswapV2Router: INVALID_PATH');
707         amounts = EliteswapV2Library.getAmountsIn(factory, amountOut, path);
708         require(amounts[0] <= msg.value, 'EliteswapV2Router: EXCESSIVE_INPUT_AMOUNT');
709         IWETH(WETH).deposit{value: amounts[0]}();
710         assert(IWETH(WETH).transfer(EliteswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]));
711         _swap(amounts, path, to);
712         // refund dust eth, if any
713         if (msg.value > amounts[0]) TransferHelper.safeTransferETH(msg.sender, msg.value - amounts[0]);
714     }
715 
716     // **** SWAP (supporting fee-on-transfer tokens) ****
717     // requires the initial amount to have already been sent to the first pair
718     function _swapSupportingFeeOnTransferTokens(address[] memory path, address _to) internal virtual {
719         for (uint i; i < path.length - 1; i++) {
720             (address input, address output) = (path[i], path[i + 1]);
721             (address token0,) = EliteswapV2Library.sortTokens(input, output);
722             IEliteswapV2Pair pair = IEliteswapV2Pair(EliteswapV2Library.pairFor(factory, input, output));
723             uint amountInput;
724             uint amountOutput;
725             { // scope to avoid stack too deep errors
726             (uint reserve0, uint reserve1,) = pair.getReserves();
727             (uint reserveInput, uint reserveOutput) = input == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
728             amountInput = IERC20(input).balanceOf(address(pair)).sub(reserveInput);
729             amountOutput = EliteswapV2Library.getAmountOut(amountInput, reserveInput, reserveOutput);
730             }
731             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOutput) : (amountOutput, uint(0));
732             address to = i < path.length - 2 ? EliteswapV2Library.pairFor(factory, output, path[i + 2]) : _to;
733             pair.swap(amount0Out, amount1Out, to, new bytes(0));
734         }
735     }
736     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
737         uint amountIn,
738         uint amountOutMin,
739         address[] calldata path,
740         address to,
741         uint deadline
742     ) external virtual override ensure(deadline) {
743         TransferHelper.safeTransferFrom(
744             path[0], msg.sender, EliteswapV2Library.pairFor(factory, path[0], path[1]), amountIn
745         );
746         uint balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
747         _swapSupportingFeeOnTransferTokens(path, to);
748         require(
749             IERC20(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
750             'EliteswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT'
751         );
752     }
753     function swapExactETHForTokensSupportingFeeOnTransferTokens(
754         uint amountOutMin,
755         address[] calldata path,
756         address to,
757         uint deadline
758     )
759         external
760         virtual
761         override
762         payable
763         ensure(deadline)
764     {
765         require(path[0] == WETH, 'EliteswapV2Router: INVALID_PATH');
766         uint amountIn = msg.value;
767         IWETH(WETH).deposit{value: amountIn}();
768         assert(IWETH(WETH).transfer(EliteswapV2Library.pairFor(factory, path[0], path[1]), amountIn));
769         uint balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
770         _swapSupportingFeeOnTransferTokens(path, to);
771         require(
772             IERC20(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
773             'EliteswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT'
774         );
775     }
776     function swapExactTokensForETHSupportingFeeOnTransferTokens(
777         uint amountIn,
778         uint amountOutMin,
779         address[] calldata path,
780         address to,
781         uint deadline
782     )
783         external
784         virtual
785         override
786         ensure(deadline)
787     {
788         require(path[path.length - 1] == WETH, 'EliteswapV2Router: INVALID_PATH');
789         TransferHelper.safeTransferFrom(
790             path[0], msg.sender, EliteswapV2Library.pairFor(factory, path[0], path[1]), amountIn
791         );
792         _swapSupportingFeeOnTransferTokens(path, address(this));
793         uint amountOut = IERC20(WETH).balanceOf(address(this));
794         require(amountOut >= amountOutMin, 'EliteswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
795         IWETH(WETH).withdraw(amountOut);
796         TransferHelper.safeTransferETH(to, amountOut);
797     }
798 
799     // **** LIBRARY FUNCTIONS ****
800     function quote(uint amountA, uint reserveA, uint reserveB) public pure virtual override returns (uint amountB) {
801         return EliteswapV2Library.quote(amountA, reserveA, reserveB);
802     }
803 
804     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut)
805         public
806         pure
807         virtual
808         override
809         returns (uint amountOut)
810     {
811         return EliteswapV2Library.getAmountOut(amountIn, reserveIn, reserveOut);
812     }
813 
814     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut)
815         public
816         pure
817         virtual
818         override
819         returns (uint amountIn)
820     {
821         return EliteswapV2Library.getAmountIn(amountOut, reserveIn, reserveOut);
822     }
823 
824     function getAmountsOut(uint amountIn, address[] memory path)
825         public
826         view
827         virtual
828         override
829         returns (uint[] memory amounts)
830     {
831         return EliteswapV2Library.getAmountsOut(factory, amountIn, path);
832     }
833 
834     function getAmountsIn(uint amountOut, address[] memory path)
835         public
836         view
837         virtual
838         override
839         returns (uint[] memory amounts)
840     {
841         return EliteswapV2Library.getAmountsIn(factory, amountOut, path);
842     }
843 }