1 // Dependency file: @uniswap/lib/contracts/libraries/TransferHelper.sol
2 
3 // pragma solidity >=0.6.0;
4 
5 // helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
6 library TransferHelper {
7     function safeApprove(address token, address to, uint value) internal {
8         // bytes4(keccak256(bytes('approve(address,uint256)')));
9         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
10         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
11     }
12 
13     function safeTransfer(address token, address to, uint value) internal {
14         // bytes4(keccak256(bytes('transfer(address,uint256)')));
15         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
16         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
17     }
18 
19     function safeTransferFrom(address token, address from, address to, uint value) internal {
20         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
21         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
22         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
23     }
24 
25     function safeTransferETH(address to, uint value) internal {
26         (bool success,) = to.call{value:value}(new bytes(0));
27         require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
28     }
29 }
30 
31 
32 // Dependency file: contracts/interfaces/ITaalRouter01.sol
33 
34 // pragma solidity >=0.6.2;
35 
36 interface ITaalRouter01 {
37     function factory() external pure returns (address);
38     function WETH() external pure returns (address);
39 
40     function addLiquidity(
41         address tokenA,
42         address tokenB,
43         uint amountADesired,
44         uint amountBDesired,
45         uint amountAMin,
46         uint amountBMin,
47         address to,
48         uint deadline
49     ) external returns (uint amountA, uint amountB, uint liquidity);
50     function addLiquidityETH(
51         address token,
52         uint amountTokenDesired,
53         uint amountTokenMin,
54         uint amountETHMin,
55         address to,
56         uint deadline
57     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
58     function removeLiquidity(
59         address tokenA,
60         address tokenB,
61         uint liquidity,
62         uint amountAMin,
63         uint amountBMin,
64         address to,
65         uint deadline
66     ) external returns (uint amountA, uint amountB);
67     function removeLiquidityETH(
68         address token,
69         uint liquidity,
70         uint amountTokenMin,
71         uint amountETHMin,
72         address to,
73         uint deadline
74     ) external returns (uint amountToken, uint amountETH);
75     function removeLiquidityWithPermit(
76         address tokenA,
77         address tokenB,
78         uint liquidity,
79         uint amountAMin,
80         uint amountBMin,
81         address to,
82         uint deadline,
83         bool approveMax, uint8 v, bytes32 r, bytes32 s
84     ) external returns (uint amountA, uint amountB);
85     function removeLiquidityETHWithPermit(
86         address token,
87         uint liquidity,
88         uint amountTokenMin,
89         uint amountETHMin,
90         address to,
91         uint deadline,
92         bool approveMax, uint8 v, bytes32 r, bytes32 s
93     ) external returns (uint amountToken, uint amountETH);
94     function swapExactTokensForTokens(
95         uint amountIn,
96         uint amountOutMin,
97         address[] calldata path,
98         address to,
99         uint deadline
100     ) external returns (uint[] memory amounts);
101     function swapTokensForExactTokens(
102         uint amountOut,
103         uint amountInMax,
104         address[] calldata path,
105         address to,
106         uint deadline
107     ) external returns (uint[] memory amounts);
108     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
109         external
110         payable
111         returns (uint[] memory amounts);
112     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
113         external
114         returns (uint[] memory amounts);
115     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
116         external
117         returns (uint[] memory amounts);
118     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
119         external
120         payable
121         returns (uint[] memory amounts);
122 
123     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
124     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
125     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
126     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
127     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
128 }
129 
130 
131 // Dependency file: contracts/interfaces/ITaalRouter02.sol
132 
133 // pragma solidity >=0.6.2;
134 
135 // import 'contracts/interfaces/ITaalRouter01.sol';
136 
137 interface ITaalRouter02 is ITaalRouter01 {
138     function removeLiquidityETHSupportingFeeOnTransferTokens(
139         address token,
140         uint liquidity,
141         uint amountTokenMin,
142         uint amountETHMin,
143         address to,
144         uint deadline
145     ) external returns (uint amountETH);
146     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
147         address token,
148         uint liquidity,
149         uint amountTokenMin,
150         uint amountETHMin,
151         address to,
152         uint deadline,
153         bool approveMax, uint8 v, bytes32 r, bytes32 s
154     ) external returns (uint amountETH);
155 
156     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
157         uint amountIn,
158         uint amountOutMin,
159         address[] calldata path,
160         address to,
161         uint deadline
162     ) external;
163     function swapExactETHForTokensSupportingFeeOnTransferTokens(
164         uint amountOutMin,
165         address[] calldata path,
166         address to,
167         uint deadline
168     ) external payable;
169     function swapExactTokensForETHSupportingFeeOnTransferTokens(
170         uint amountIn,
171         uint amountOutMin,
172         address[] calldata path,
173         address to,
174         uint deadline
175     ) external;
176 }
177 
178 
179 // Dependency file: taalswap-core/contracts/interfaces/ITaalFactory.sol
180 
181 // pragma solidity >=0.5.0;
182 
183 interface ITaalFactory {
184     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
185 
186     function feeTo() external view returns (address);
187     function feeToSetter() external view returns (address);
188 
189     function getPair(address tokenA, address tokenB) external view returns (address pair);
190     function allPairs(uint) external view returns (address pair);
191     function allPairsLength() external view returns (uint);
192 
193     function createPair(address tokenA, address tokenB) external returns (address pair);
194 
195     function setFeeTo(address) external;
196     function setFeeToSetter(address) external;
197 }
198 
199 
200 // Dependency file: contracts/libraries/SafeMath.sol
201 
202 // pragma solidity =0.6.6;
203 
204 // a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)
205 
206 library SafeMath {
207     function add(uint x, uint y) internal pure returns (uint z) {
208         require((z = x + y) >= x, 'ds-math-add-overflow');
209     }
210 
211     function sub(uint x, uint y) internal pure returns (uint z) {
212         require((z = x - y) <= x, 'ds-math-sub-underflow');
213     }
214 
215     function mul(uint x, uint y) internal pure returns (uint z) {
216         require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');
217     }
218 }
219 
220 
221 // Dependency file: taalswap-core/contracts/interfaces/ITaalPair.sol
222 
223 // pragma solidity >=0.5.0;
224 
225 interface ITaalPair {
226     event Approval(address indexed owner, address indexed spender, uint value);
227     event Transfer(address indexed from, address indexed to, uint value);
228 
229     function name() external pure returns (string memory);
230     function symbol() external pure returns (string memory);
231     function decimals() external pure returns (uint8);
232     function totalSupply() external view returns (uint);
233     function balanceOf(address owner) external view returns (uint);
234     function allowance(address owner, address spender) external view returns (uint);
235 
236     function approve(address spender, uint value) external returns (bool);
237     function transfer(address to, uint value) external returns (bool);
238     function transferFrom(address from, address to, uint value) external returns (bool);
239 
240     function DOMAIN_SEPARATOR() external view returns (bytes32);
241     function PERMIT_TYPEHASH() external pure returns (bytes32);
242     function nonces(address owner) external view returns (uint);
243 
244     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
245 
246     event Mint(address indexed sender, uint amount0, uint amount1);
247     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
248     event Swap(
249         address indexed sender,
250         uint amount0In,
251         uint amount1In,
252         uint amount0Out,
253         uint amount1Out,
254         address indexed to
255     );
256     event Sync(uint112 reserve0, uint112 reserve1);
257 
258     function MINIMUM_LIQUIDITY() external pure returns (uint);
259     function factory() external view returns (address);
260     function token0() external view returns (address);
261     function token1() external view returns (address);
262     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
263     function price0CumulativeLast() external view returns (uint);
264     function price1CumulativeLast() external view returns (uint);
265     function kLast() external view returns (uint);
266 
267     function mint(address to) external returns (uint liquidity);
268     function burn(address to) external returns (uint amount0, uint amount1);
269     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
270     function skim(address to) external;
271     function sync() external;
272 
273     function initialize(address, address) external;
274 }
275 
276 
277 // Dependency file: contracts/libraries/TaalLibrary.sol
278 
279 // pragma solidity >=0.5.0;
280 
281 // import '/Users/peter/Documents/develop/taalswap-periphery/node_modules/taalswap-core/contracts/interfaces/ITaalPair.sol';
282 
283 // import "contracts/libraries/SafeMath.sol";
284 
285 library TaalLibrary {
286     using SafeMath for uint;
287 
288     // returns sorted token addresses, used to handle return values from pairs sorted in this order
289     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
290         require(tokenA != tokenB, 'TaalLibrary: IDENTICAL_ADDRESSES');
291         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
292         require(token0 != address(0), 'TaalLibrary: ZERO_ADDRESS');
293     }
294 
295     // calculates the CREATE2 address for a pair without making any external calls
296     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
297         (address token0, address token1) = sortTokens(tokenA, tokenB);
298         pair = address(uint(keccak256(abi.encodePacked(
299                 hex'ff',
300                 factory,
301                 keccak256(abi.encodePacked(token0, token1)),
302 //                hex'0f3a8b1d98b38326f5633e629cf4c0cc4c7b060d1d895e8758011059941b96c5' // init code hash
303                 hex'e91389f3e161a2ac9db6e5380c1750a30dfe06b6685cb0b61800599094cdfc92'
304             ))));
305     }
306 
307     // fetches and sorts the reserves for a pair
308     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
309         (address token0,) = sortTokens(tokenA, tokenB);
310         pairFor(factory, tokenA, tokenB);
311         (uint reserve0, uint reserve1,) = ITaalPair(pairFor(factory, tokenA, tokenB)).getReserves();
312         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
313     }
314 
315     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
316     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
317         require(amountA > 0, 'TaalLibrary: INSUFFICIENT_AMOUNT');
318         require(reserveA > 0 && reserveB > 0, 'TaalLibrary: INSUFFICIENT_LIQUIDITY');
319         amountB = amountA.mul(reserveB) / reserveA;
320     }
321 
322     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
323     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
324         require(amountIn > 0, 'TaalLibrary: INSUFFICIENT_INPUT_AMOUNT');
325         require(reserveIn > 0 && reserveOut > 0, 'TaalLibrary: INSUFFICIENT_LIQUIDITY');
326 //        uint amountInWithFee = amountIn.mul(998);
327         uint amountInWithFee = amountIn.mul(9975);
328         uint numerator = amountInWithFee.mul(reserveOut);
329 //        uint denominator = reserveIn.mul(1000).add(amountInWithFee);
330         uint denominator = reserveIn.mul(10000).add(amountInWithFee);
331         amountOut = numerator / denominator;
332     }
333 
334     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
335     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {
336         require(amountOut > 0, 'TaalLibrary: INSUFFICIENT_OUTPUT_AMOUNT');
337         require(reserveIn > 0 && reserveOut > 0, 'TaalLibrary: INSUFFICIENT_LIQUIDITY');
338 //        uint numerator = reserveIn.mul(amountOut).mul(1000);
339 //        uint denominator = reserveOut.sub(amountOut).mul(998);
340         uint numerator = reserveIn.mul(amountOut).mul(10000);
341         uint denominator = reserveOut.sub(amountOut).mul(9975);
342         amountIn = (numerator / denominator).add(1);
343     }
344 
345     // performs chained getAmountOut calculations on any number of pairs
346     function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {
347         require(path.length >= 2, 'TaalLibrary: INVALID_PATH');
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
358         require(path.length >= 2, 'TaalLibrary: INVALID_PATH');
359         amounts = new uint[](path.length);
360         amounts[amounts.length - 1] = amountOut;
361         for (uint i = path.length - 1; i > 0; i--) {
362             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);
363             amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
364         }
365     }
366 }
367 
368 
369 // Dependency file: contracts/interfaces/IERC20.sol
370 
371 // pragma solidity >=0.5.0;
372 
373 interface IERC20 {
374     event Approval(address indexed owner, address indexed spender, uint value);
375     event Transfer(address indexed from, address indexed to, uint value);
376 
377     function name() external view returns (string memory);
378     function symbol() external view returns (string memory);
379     function decimals() external view returns (uint8);
380     function totalSupply() external view returns (uint);
381     function balanceOf(address owner) external view returns (uint);
382     function allowance(address owner, address spender) external view returns (uint);
383 
384     function approve(address spender, uint value) external returns (bool);
385     function transfer(address to, uint value) external returns (bool);
386     function transferFrom(address from, address to, uint value) external returns (bool);
387 }
388 
389 
390 // Dependency file: contracts/interfaces/IWETH.sol
391 
392 // pragma solidity >=0.5.0;
393 
394 interface IWETH {
395     function deposit() external payable;
396     function transfer(address to, uint value) external returns (bool);
397     function withdraw(uint) external;
398 }
399 
400 
401 // Root file: contracts/TaalRouter.sol
402 
403 pragma solidity =0.6.6;
404 
405 // import '/Users/peter/Documents/develop/taalswap-periphery/node_modules/@uniswap/lib/contracts/libraries/TransferHelper.sol';
406 // import 'contracts/interfaces/ITaalRouter02.sol';
407 // import '/Users/peter/Documents/develop/taalswap-periphery/node_modules/taalswap-core/contracts/interfaces/ITaalFactory.sol';
408 // import 'contracts/libraries/SafeMath.sol';
409 // import '/Users/peter/Documents/develop/taalswap-periphery/node_modules/taalswap-core/contracts/interfaces/ITaalPair.sol';
410 // import 'contracts/libraries/TaalLibrary.sol';
411 // import 'contracts/interfaces/IERC20.sol';
412 // import 'contracts/interfaces/IWETH.sol';
413 
414 contract TaalRouter is ITaalRouter02 {
415     using SafeMath for uint;
416 
417     address public immutable override factory;
418     address public immutable override WETH;
419 
420     modifier ensure(uint deadline) {
421         require(deadline >= block.timestamp, 'TaalRouter: EXPIRED');
422         _;
423     }
424 
425     constructor(address _factory, address _WETH) public {
426         factory = _factory;
427         WETH = _WETH;
428     }
429 
430     receive() external payable {
431         assert(msg.sender == WETH); // only accept ETH via fallback from the WETH contract
432     }
433 
434     // **** ADD LIQUIDITY ****
435     function _addLiquidity(
436         address tokenA,
437         address tokenB,
438         uint amountADesired,
439         uint amountBDesired,
440         uint amountAMin,
441         uint amountBMin
442     ) internal virtual returns (uint amountA, uint amountB) {
443         // create the pair if it doesn't exist yet
444         if (ITaalFactory(factory).getPair(tokenA, tokenB) == address(0)) {
445             ITaalFactory(factory).createPair(tokenA, tokenB);
446         }
447         (uint reserveA, uint reserveB) = TaalLibrary.getReserves(factory, tokenA, tokenB);
448         if (reserveA == 0 && reserveB == 0) {
449             (amountA, amountB) = (amountADesired, amountBDesired);
450         } else {
451             uint amountBOptimal = TaalLibrary.quote(amountADesired, reserveA, reserveB);
452             if (amountBOptimal <= amountBDesired) {
453                 require(amountBOptimal >= amountBMin, 'TaalRouter: INSUFFICIENT_B_AMOUNT');
454                 (amountA, amountB) = (amountADesired, amountBOptimal);
455             } else {
456                 uint amountAOptimal = TaalLibrary.quote(amountBDesired, reserveB, reserveA);
457                 assert(amountAOptimal <= amountADesired);
458                 require(amountAOptimal >= amountAMin, 'TaalRouter: INSUFFICIENT_A_AMOUNT');
459                 (amountA, amountB) = (amountAOptimal, amountBDesired);
460             }
461         }
462     }
463     function addLiquidity(
464         address tokenA,
465         address tokenB,
466         uint amountADesired,
467         uint amountBDesired,
468         uint amountAMin,
469         uint amountBMin,
470         address to,
471         uint deadline
472     ) external virtual override ensure(deadline) returns (uint amountA, uint amountB, uint liquidity) {
473         (amountA, amountB) = _addLiquidity(tokenA, tokenB, amountADesired, amountBDesired, amountAMin, amountBMin);
474         address pair = TaalLibrary.pairFor(factory, tokenA, tokenB);
475         TransferHelper.safeTransferFrom(tokenA, msg.sender, pair, amountA);
476         TransferHelper.safeTransferFrom(tokenB, msg.sender, pair, amountB);
477         liquidity = ITaalPair(pair).mint(to);
478     }
479     function addLiquidityETH(
480         address token,
481         uint amountTokenDesired,
482         uint amountTokenMin,
483         uint amountETHMin,
484         address to,
485         uint deadline
486     ) external virtual override payable ensure(deadline) returns (uint amountToken, uint amountETH, uint liquidity) {
487         (amountToken, amountETH) = _addLiquidity(
488             token,
489             WETH,
490             amountTokenDesired,
491             msg.value,
492             amountTokenMin,
493             amountETHMin
494         );
495         address pair = TaalLibrary.pairFor(factory, token, WETH);
496         TransferHelper.safeTransferFrom(token, msg.sender, pair, amountToken);
497         IWETH(WETH).deposit{value: amountETH}();
498         assert(IWETH(WETH).transfer(pair, amountETH));
499         liquidity = ITaalPair(pair).mint(to);
500         // refund dust eth, if any
501         if (msg.value > amountETH) TransferHelper.safeTransferETH(msg.sender, msg.value - amountETH);
502     }
503 
504     // **** REMOVE LIQUIDITY ****
505     function removeLiquidity(
506         address tokenA,
507         address tokenB,
508         uint liquidity,
509         uint amountAMin,
510         uint amountBMin,
511         address to,
512         uint deadline
513     ) public virtual override ensure(deadline) returns (uint amountA, uint amountB) {
514         address pair = TaalLibrary.pairFor(factory, tokenA, tokenB);
515         ITaalPair(pair).transferFrom(msg.sender, pair, liquidity); // send liquidity to pair
516         (uint amount0, uint amount1) = ITaalPair(pair).burn(to);
517         (address token0,) = TaalLibrary.sortTokens(tokenA, tokenB);
518         (amountA, amountB) = tokenA == token0 ? (amount0, amount1) : (amount1, amount0);
519         require(amountA >= amountAMin, 'TaalRouter: INSUFFICIENT_A_AMOUNT');
520         require(amountB >= amountBMin, 'TaalRouter: INSUFFICIENT_B_AMOUNT');
521     }
522     function removeLiquidityETH(
523         address token,
524         uint liquidity,
525         uint amountTokenMin,
526         uint amountETHMin,
527         address to,
528         uint deadline
529     ) public virtual override ensure(deadline) returns (uint amountToken, uint amountETH) {
530         (amountToken, amountETH) = removeLiquidity(
531             token,
532             WETH,
533             liquidity,
534             amountTokenMin,
535             amountETHMin,
536             address(this),
537             deadline
538         );
539         TransferHelper.safeTransfer(token, to, amountToken);
540         IWETH(WETH).withdraw(amountETH);
541         TransferHelper.safeTransferETH(to, amountETH);
542     }
543     function removeLiquidityWithPermit(
544         address tokenA,
545         address tokenB,
546         uint liquidity,
547         uint amountAMin,
548         uint amountBMin,
549         address to,
550         uint deadline,
551         bool approveMax, uint8 v, bytes32 r, bytes32 s
552     ) external virtual override returns (uint amountA, uint amountB) {
553         address pair = TaalLibrary.pairFor(factory, tokenA, tokenB);
554         uint value = approveMax ? uint(-1) : liquidity;
555         ITaalPair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
556         (amountA, amountB) = removeLiquidity(tokenA, tokenB, liquidity, amountAMin, amountBMin, to, deadline);
557     }
558     function removeLiquidityETHWithPermit(
559         address token,
560         uint liquidity,
561         uint amountTokenMin,
562         uint amountETHMin,
563         address to,
564         uint deadline,
565         bool approveMax, uint8 v, bytes32 r, bytes32 s
566     ) external virtual override returns (uint amountToken, uint amountETH) {
567         address pair = TaalLibrary.pairFor(factory, token, WETH);
568         uint value = approveMax ? uint(-1) : liquidity;
569         ITaalPair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
570         (amountToken, amountETH) = removeLiquidityETH(token, liquidity, amountTokenMin, amountETHMin, to, deadline);
571     }
572 
573     // **** REMOVE LIQUIDITY (supporting fee-on-transfer tokens) ****
574     function removeLiquidityETHSupportingFeeOnTransferTokens(
575         address token,
576         uint liquidity,
577         uint amountTokenMin,
578         uint amountETHMin,
579         address to,
580         uint deadline
581     ) public virtual override ensure(deadline) returns (uint amountETH) {
582         (, amountETH) = removeLiquidity(
583             token,
584             WETH,
585             liquidity,
586             amountTokenMin,
587             amountETHMin,
588             address(this),
589             deadline
590         );
591         TransferHelper.safeTransfer(token, to, IERC20(token).balanceOf(address(this)));
592         IWETH(WETH).withdraw(amountETH);
593         TransferHelper.safeTransferETH(to, amountETH);
594     }
595     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
596         address token,
597         uint liquidity,
598         uint amountTokenMin,
599         uint amountETHMin,
600         address to,
601         uint deadline,
602         bool approveMax, uint8 v, bytes32 r, bytes32 s
603     ) external virtual override returns (uint amountETH) {
604         address pair = TaalLibrary.pairFor(factory, token, WETH);
605         uint value = approveMax ? uint(-1) : liquidity;
606         ITaalPair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
607         amountETH = removeLiquidityETHSupportingFeeOnTransferTokens(
608             token, liquidity, amountTokenMin, amountETHMin, to, deadline
609         );
610     }
611 
612     // **** SWAP ****
613     // requires the initial amount to have already been sent to the first pair
614     function _swap(uint[] memory amounts, address[] memory path, address _to) internal virtual {
615         for (uint i; i < path.length - 1; i++) {
616             (address input, address output) = (path[i], path[i + 1]);
617             (address token0,) = TaalLibrary.sortTokens(input, output);
618             uint amountOut = amounts[i + 1];
619             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOut) : (amountOut, uint(0));
620             address to = i < path.length - 2 ? TaalLibrary.pairFor(factory, output, path[i + 2]) : _to;
621             ITaalPair(TaalLibrary.pairFor(factory, input, output)).swap(
622                 amount0Out, amount1Out, to, new bytes(0)
623             );
624         }
625     }
626     function swapExactTokensForTokens(
627         uint amountIn,
628         uint amountOutMin,
629         address[] calldata path,
630         address to,
631         uint deadline
632     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
633         amounts = TaalLibrary.getAmountsOut(factory, amountIn, path);
634         require(amounts[amounts.length - 1] >= amountOutMin, 'TaalRouter: INSUFFICIENT_OUTPUT_AMOUNT');
635         TransferHelper.safeTransferFrom(
636             path[0], msg.sender, TaalLibrary.pairFor(factory, path[0], path[1]), amounts[0]
637         );
638         _swap(amounts, path, to);
639     }
640     function swapTokensForExactTokens(
641         uint amountOut,
642         uint amountInMax,
643         address[] calldata path,
644         address to,
645         uint deadline
646     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
647         amounts = TaalLibrary.getAmountsIn(factory, amountOut, path);
648         require(amounts[0] <= amountInMax, 'TaalRouter: EXCESSIVE_INPUT_AMOUNT');
649         TransferHelper.safeTransferFrom(
650             path[0], msg.sender, TaalLibrary.pairFor(factory, path[0], path[1]), amounts[0]
651         );
652         _swap(amounts, path, to);
653     }
654     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
655         external
656         virtual
657         override
658         payable
659         ensure(deadline)
660         returns (uint[] memory amounts)
661     {
662         require(path[0] == WETH, 'TaalRouter: INVALID_PATH');
663         amounts = TaalLibrary.getAmountsOut(factory, msg.value, path);
664         require(amounts[amounts.length - 1] >= amountOutMin, 'TaalRouter: INSUFFICIENT_OUTPUT_AMOUNT');
665         IWETH(WETH).deposit{value: amounts[0]}();
666         assert(IWETH(WETH).transfer(TaalLibrary.pairFor(factory, path[0], path[1]), amounts[0]));
667         _swap(amounts, path, to);
668     }
669     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
670         external
671         virtual
672         override
673         ensure(deadline)
674         returns (uint[] memory amounts)
675     {
676         require(path[path.length - 1] == WETH, 'TaalRouter: INVALID_PATH');
677         amounts = TaalLibrary.getAmountsIn(factory, amountOut, path);
678         require(amounts[0] <= amountInMax, 'TaalRouter: EXCESSIVE_INPUT_AMOUNT');
679         TransferHelper.safeTransferFrom(
680             path[0], msg.sender, TaalLibrary.pairFor(factory, path[0], path[1]), amounts[0]
681         );
682         _swap(amounts, path, address(this));
683         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
684         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
685     }
686     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
687         external
688         virtual
689         override
690         ensure(deadline)
691         returns (uint[] memory amounts)
692     {
693         require(path[path.length - 1] == WETH, 'TaalRouter: INVALID_PATH');
694         amounts = TaalLibrary.getAmountsOut(factory, amountIn, path);
695         require(amounts[amounts.length - 1] >= amountOutMin, 'TaalRouter: INSUFFICIENT_OUTPUT_AMOUNT');
696         TransferHelper.safeTransferFrom(
697             path[0], msg.sender, TaalLibrary.pairFor(factory, path[0], path[1]), amounts[0]
698         );
699         _swap(amounts, path, address(this));
700         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
701         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
702     }
703     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
704         external
705         virtual
706         override
707         payable
708         ensure(deadline)
709         returns (uint[] memory amounts)
710     {
711         require(path[0] == WETH, 'TaalRouter: INVALID_PATH');
712         amounts = TaalLibrary.getAmountsIn(factory, amountOut, path);
713         require(amounts[0] <= msg.value, 'TaalRouter: EXCESSIVE_INPUT_AMOUNT');
714         IWETH(WETH).deposit{value: amounts[0]}();
715         assert(IWETH(WETH).transfer(TaalLibrary.pairFor(factory, path[0], path[1]), amounts[0]));
716         _swap(amounts, path, to);
717         // refund dust eth, if any
718         if (msg.value > amounts[0]) TransferHelper.safeTransferETH(msg.sender, msg.value - amounts[0]);
719     }
720 
721     // **** SWAP (supporting fee-on-transfer tokens) ****
722     // requires the initial amount to have already been sent to the first pair
723     function _swapSupportingFeeOnTransferTokens(address[] memory path, address _to) internal virtual {
724         for (uint i; i < path.length - 1; i++) {
725             (address input, address output) = (path[i], path[i + 1]);
726             (address token0,) = TaalLibrary.sortTokens(input, output);
727             ITaalPair pair = ITaalPair(TaalLibrary.pairFor(factory, input, output));
728             uint amountInput;
729             uint amountOutput;
730             { // scope to avoid stack too deep errors
731             (uint reserve0, uint reserve1,) = pair.getReserves();
732             (uint reserveInput, uint reserveOutput) = input == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
733             amountInput = IERC20(input).balanceOf(address(pair)).sub(reserveInput);
734             amountOutput = TaalLibrary.getAmountOut(amountInput, reserveInput, reserveOutput);
735             }
736             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOutput) : (amountOutput, uint(0));
737             address to = i < path.length - 2 ? TaalLibrary.pairFor(factory, output, path[i + 2]) : _to;
738             pair.swap(amount0Out, amount1Out, to, new bytes(0));
739         }
740     }
741     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
742         uint amountIn,
743         uint amountOutMin,
744         address[] calldata path,
745         address to,
746         uint deadline
747     ) external virtual override ensure(deadline) {
748         TransferHelper.safeTransferFrom(
749             path[0], msg.sender, TaalLibrary.pairFor(factory, path[0], path[1]), amountIn
750         );
751         uint balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
752         _swapSupportingFeeOnTransferTokens(path, to);
753         require(
754             IERC20(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
755             'TaalRouter: INSUFFICIENT_OUTPUT_AMOUNT'
756         );
757     }
758     function swapExactETHForTokensSupportingFeeOnTransferTokens(
759         uint amountOutMin,
760         address[] calldata path,
761         address to,
762         uint deadline
763     )
764         external
765         virtual
766         override
767         payable
768         ensure(deadline)
769     {
770         require(path[0] == WETH, 'TaalRouter: INVALID_PATH');
771         uint amountIn = msg.value;
772         IWETH(WETH).deposit{value: amountIn}();
773         assert(IWETH(WETH).transfer(TaalLibrary.pairFor(factory, path[0], path[1]), amountIn));
774         uint balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
775         _swapSupportingFeeOnTransferTokens(path, to);
776         require(
777             IERC20(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
778             'TaalRouter: INSUFFICIENT_OUTPUT_AMOUNT'
779         );
780     }
781     function swapExactTokensForETHSupportingFeeOnTransferTokens(
782         uint amountIn,
783         uint amountOutMin,
784         address[] calldata path,
785         address to,
786         uint deadline
787     )
788         external
789         virtual
790         override
791         ensure(deadline)
792     {
793         require(path[path.length - 1] == WETH, 'TaalRouter: INVALID_PATH');
794         TransferHelper.safeTransferFrom(
795             path[0], msg.sender, TaalLibrary.pairFor(factory, path[0], path[1]), amountIn
796         );
797         _swapSupportingFeeOnTransferTokens(path, address(this));
798         uint amountOut = IERC20(WETH).balanceOf(address(this));
799         require(amountOut >= amountOutMin, 'TaalRouter: INSUFFICIENT_OUTPUT_AMOUNT');
800         IWETH(WETH).withdraw(amountOut);
801         TransferHelper.safeTransferETH(to, amountOut);
802     }
803 
804     // **** LIBRARY FUNCTIONS ****
805     function quote(uint amountA, uint reserveA, uint reserveB) public pure virtual override returns (uint amountB) {
806         return TaalLibrary.quote(amountA, reserveA, reserveB);
807     }
808 
809     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut)
810         public
811         pure
812         virtual
813         override
814         returns (uint amountOut)
815     {
816         return TaalLibrary.getAmountOut(amountIn, reserveIn, reserveOut);
817     }
818 
819     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut)
820         public
821         pure
822         virtual
823         override
824         returns (uint amountIn)
825     {
826         return TaalLibrary.getAmountIn(amountOut, reserveIn, reserveOut);
827     }
828 
829     function getAmountsOut(uint amountIn, address[] memory path)
830         public
831         view
832         virtual
833         override
834         returns (uint[] memory amounts)
835     {
836         return TaalLibrary.getAmountsOut(factory, amountIn, path);
837     }
838 
839     function getAmountsIn(uint amountOut, address[] memory path)
840         public
841         view
842         virtual
843         override
844         returns (uint[] memory amounts)
845     {
846         return TaalLibrary.getAmountsIn(factory, amountOut, path);
847     }
848 }