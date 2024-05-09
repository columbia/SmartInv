1 // File: contracts/interfaces/IUniswapV2Pair.sol
2 pragma solidity >=0.5.0;
3 
4 interface IUniswapV2Pair {
5     event Approval(address indexed owner, address indexed spender, uint value);
6     event Transfer(address indexed from, address indexed to, uint value);
7 
8     function name() external pure returns (string memory);
9     function symbol() external pure returns (string memory);
10     function decimals() external pure returns (uint8);
11     function totalSupply() external view returns (uint);
12     function balanceOf(address owner) external view returns (uint);
13     function allowance(address owner, address spender) external view returns (uint);
14 
15     function approve(address spender, uint value) external returns (bool);
16     function transfer(address to, uint value) external returns (bool);
17     function transferFrom(address from, address to, uint value) external returns (bool);
18 
19     function DOMAIN_SEPARATOR() external view returns (bytes32);
20     function PERMIT_TYPEHASH() external pure returns (bytes32);
21     function nonces(address owner) external view returns (uint);
22 
23     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
24 
25     event Mint(address indexed sender, uint amount0, uint amount1);
26     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
27     event Swap(
28         address indexed sender,
29         uint amount0In,
30         uint amount1In,
31         uint amount0Out,
32         uint amount1Out,
33         address indexed to
34     );
35     event Sync(uint112 reserve0, uint112 reserve1);
36 
37     function MINIMUM_LIQUIDITY() external pure returns (uint);
38     function factory() external view returns (address);
39     function token0() external view returns (address);
40     function token1() external view returns (address);
41     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
42     function price0CumulativeLast() external view returns (uint);
43     function price1CumulativeLast() external view returns (uint);
44     function kLast() external view returns (uint);
45 
46     function mint(address to) external returns (uint liquidity);
47     function burn(address to) external returns (uint amount0, uint amount1);
48     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
49     function skim(address to) external;
50     function sync() external;
51 
52     function initialize(address, address) external;
53 }
54 
55 // File: contracts/libraries/SafeMath.sol
56 
57 pragma solidity =0.6.12;
58 
59 // a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)
60 
61 library SafeMathUniswap {
62     function add(uint x, uint y) internal pure returns (uint z) {
63         require((z = x + y) >= x, 'ds-math-add-overflow');
64     }
65 
66     function sub(uint x, uint y) internal pure returns (uint z) {
67         require((z = x - y) <= x, 'ds-math-sub-underflow');
68     }
69 
70     function mul(uint x, uint y) internal pure returns (uint z) {
71         require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');
72     }
73 }
74 
75 // File: contracts/libraries/UniswapV2Library.sol
76 
77 pragma solidity >=0.5.0;
78 
79 
80 
81 library UniswapV2Library {
82     using SafeMathUniswap for uint;
83 
84     // returns sorted token addresses, used to handle return values from pairs sorted in this order
85     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
86         require(tokenA != tokenB, 'IDENTICAL_ADDRESSES');
87         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
88         require(token0 != address(0), 'ZERO_ADDRESS');
89     }
90 
91     // calculates the CREATE2 address for a pair without making any external calls
92     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
93         (address token0, address token1) = sortTokens(tokenA, tokenB);
94         pair = address(uint(keccak256(abi.encodePacked(
95                 hex'ff',
96                 factory,
97                 keccak256(abi.encodePacked(token0, token1)),
98                 hex'64cee53af04345e657046908198b9dd4379f9116ba86200f8c27803a78cd8e41' // init code hash
99             ))));
100     }
101 
102     // fetches and sorts the reserves for a pair
103     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
104         (address token0,) = sortTokens(tokenA, tokenB);
105         (uint reserve0, uint reserve1,) = IUniswapV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();
106         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
107     }
108 
109     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
110     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
111         require(amountA > 0, 'INSUFFICIENT_AMOUNT');
112         require(reserveA > 0 && reserveB > 0, 'INSUFFICIENT_LIQUIDITY');
113         amountB = amountA.mul(reserveB) / reserveA;
114     }
115 
116     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
117     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
118         require(amountIn > 0, 'INSUFFICIENT_INPUT_AMOUNT');
119         require(reserveIn > 0 && reserveOut > 0, 'INSUFFICIENT_LIQUIDITY');
120         uint amountInWithFee = amountIn.mul(9975);
121         uint numerator = amountInWithFee.mul(reserveOut);
122         uint denominator = reserveIn.mul(10000).add(amountInWithFee);
123         amountOut = numerator / denominator;
124     }
125 
126     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
127     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {
128         require(amountOut > 0, 'INSUFFICIENT_OUTPUT_AMOUNT');
129         require(reserveIn > 0 && reserveOut > 0, 'INSUFFICIENT_LIQUIDITY');
130         uint numerator = reserveIn.mul(amountOut).mul(10000);
131         uint denominator = reserveOut.sub(amountOut).mul(9975);
132         amountIn = (numerator / denominator).add(1);
133     }
134 
135     // performs chained getAmountOut calculations on any number of pairs
136     function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {
137         require(path.length >= 2, 'INVALID_PATH');
138         amounts = new uint[](path.length);
139         amounts[0] = amountIn;
140         for (uint i; i < path.length - 1; i++) {
141             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);
142             amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
143         }
144     }
145 
146     // performs chained getAmountIn calculations on any number of pairs
147     function getAmountsIn(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {
148         require(path.length >= 2, 'INVALID_PATH');
149         amounts = new uint[](path.length);
150         amounts[amounts.length - 1] = amountOut;
151         for (uint i = path.length - 1; i > 0; i--) {
152             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);
153             amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
154         }
155     }
156 }
157 
158 // File: contracts/libraries/TransferHelper.sol
159 
160 // SPDX-License-Identifier: GPL-3.0-or-later
161 
162 pragma solidity >=0.6.0;
163 
164 // helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
165 library TransferHelper {
166     function safeApprove(address token, address to, uint value) internal {
167         // bytes4(keccak256(bytes('approve(address,uint256)')));
168         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
169         require(success && (data.length == 0 || abi.decode(data, (bool))), 'APPROVE_FAILED');
170     }
171 
172     function safeTransfer(address token, address to, uint value) internal {
173         // bytes4(keccak256(bytes('transfer(address,uint256)')));
174         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
175         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TRANSFER_FAILED');
176     }
177 
178     function safeTransferFrom(address token, address from, address to, uint value) internal {
179         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
180         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
181         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TRANSFER_FROM_FAILED');
182     }
183 
184     function safeTransferETH(address to, uint value) internal {
185         (bool success,) = to.call{value:value}(new bytes(0));
186         require(success, 'BSC_TRANSFER_FAILED');
187     }
188 }
189 
190 // File: contracts/interfaces/IUniswapV2Router01.sol
191 
192 pragma solidity >=0.6.2;
193 
194 interface IUniswapV2Router01 {
195     function factory() external pure returns (address);
196     function WETH() external pure returns (address);
197 
198     function addLiquidity(
199         address tokenA,
200         address tokenB,
201         uint amountADesired,
202         uint amountBDesired,
203         uint amountAMin,
204         uint amountBMin,
205         address to,
206         uint deadline
207     ) external returns (uint amountA, uint amountB, uint liquidity);
208     function addLiquidityETH(
209         address token,
210         uint amountTokenDesired,
211         uint amountTokenMin,
212         uint amountETHMin,
213         address to,
214         uint deadline
215     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
216     function removeLiquidity(
217         address tokenA,
218         address tokenB,
219         uint liquidity,
220         uint amountAMin,
221         uint amountBMin,
222         address to,
223         uint deadline
224     ) external returns (uint amountA, uint amountB);
225     function removeLiquidityETH(
226         address token,
227         uint liquidity,
228         uint amountTokenMin,
229         uint amountETHMin,
230         address to,
231         uint deadline
232     ) external returns (uint amountToken, uint amountETH);
233     function removeLiquidityWithPermit(
234         address tokenA,
235         address tokenB,
236         uint liquidity,
237         uint amountAMin,
238         uint amountBMin,
239         address to,
240         uint deadline,
241         bool approveMax, uint8 v, bytes32 r, bytes32 s
242     ) external returns (uint amountA, uint amountB);
243     function removeLiquidityETHWithPermit(
244         address token,
245         uint liquidity,
246         uint amountTokenMin,
247         uint amountETHMin,
248         address to,
249         uint deadline,
250         bool approveMax, uint8 v, bytes32 r, bytes32 s
251     ) external returns (uint amountToken, uint amountETH);
252     function swapExactTokensForTokens(
253         uint amountIn,
254         uint amountOutMin,
255         address[] calldata path,
256         address to,
257         uint deadline
258     ) external returns (uint[] memory amounts);
259     function swapTokensForExactTokens(
260         uint amountOut,
261         uint amountInMax,
262         address[] calldata path,
263         address to,
264         uint deadline
265     ) external returns (uint[] memory amounts);
266     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
267         external
268         payable
269         returns (uint[] memory amounts);
270     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
271         external
272         returns (uint[] memory amounts);
273     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
274         external
275         returns (uint[] memory amounts);
276     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
277         external
278         payable
279         returns (uint[] memory amounts);
280 
281     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
282     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
283     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
284     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
285     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
286 }
287 
288 // File: contracts/interfaces/IUniswapV2Router02.sol
289 
290 pragma solidity >=0.6.2;
291 
292 
293 interface IUniswapV2Router02 is IUniswapV2Router01 {
294     function removeLiquidityETHSupportingFeeOnTransferTokens(
295         address token,
296         uint liquidity,
297         uint amountTokenMin,
298         uint amountETHMin,
299         address to,
300         uint deadline
301     ) external returns (uint amountETH);
302     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
303         address token,
304         uint liquidity,
305         uint amountTokenMin,
306         uint amountETHMin,
307         address to,
308         uint deadline,
309         bool approveMax, uint8 v, bytes32 r, bytes32 s
310     ) external returns (uint amountETH);
311 
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
332 }
333 
334 // File: contracts/interfaces/IUniswapV2Factory.sol
335 
336 pragma solidity >=0.5.0;
337 
338 interface IUniswapV2Factory {
339     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
340 
341     function feeTo() external view returns (address);
342     function feeToSetter() external view returns (address);
343     function swapfee() external view returns (uint256);
344 
345     function getPair(address tokenA, address tokenB) external view returns (address pair);
346     function allPairs(uint) external view returns (address pair);
347     function allPairsLength() external view returns (uint);
348 
349     function createPair(address tokenA, address tokenB) external returns (address pair);
350 
351     function setFeeTo(address) external;
352     function setFeeToSetter(address) external;
353 }
354 
355 // File: contracts/interfaces/IERC20.sol
356 
357 pragma solidity >=0.5.0;
358 
359 interface IERC20Uniswap {
360     event Approval(address indexed owner, address indexed spender, uint value);
361     event Transfer(address indexed from, address indexed to, uint value);
362 
363     function name() external view returns (string memory);
364     function symbol() external view returns (string memory);
365     function decimals() external view returns (uint8);
366     function totalSupply() external view returns (uint);
367     function balanceOf(address owner) external view returns (uint);
368     function allowance(address owner, address spender) external view returns (uint);
369 
370     function approve(address spender, uint value) external returns (bool);
371     function transfer(address to, uint value) external returns (bool);
372     function transferFrom(address from, address to, uint value) external returns (bool);
373 }
374 
375 // File: contracts/interfaces/IWETH.sol
376 
377 pragma solidity >=0.5.0;
378 
379 interface IWETH {
380     function deposit() external payable;
381     function transfer(address to, uint value) external returns (bool);
382     function withdraw(uint) external;
383 }
384 
385 // File: contracts/Router.sol
386 
387 pragma solidity =0.6.12;
388 
389 contract Router is IUniswapV2Router02 {
390     using SafeMathUniswap for uint;
391 
392     address public immutable override factory;
393     address public immutable override WETH;
394     address public adminFeeAddress;
395     uint256 public swapfee;
396     
397     modifier ensure(uint deadline) {
398         require(deadline >= block.timestamp, 'EXPIRED');
399         _;
400     }
401 
402     constructor(address _factory, address _WETH) public {
403         factory = _factory;
404         WETH = _WETH;
405         adminFeeAddress = IUniswapV2Factory(_factory).feeToSetter();
406         swapfee = IUniswapV2Factory(_factory).swapfee();
407     }
408 
409     receive() external payable {
410         assert(msg.sender == WETH); // only accept ETH via fallback from the WETH contract
411     }
412 
413     // **** ADD LIQUIDITY ****
414     function _addLiquidity(
415         address tokenA,
416         address tokenB,
417         uint amountADesired,
418         uint amountBDesired,
419         uint amountAMin,
420         uint amountBMin
421     ) internal virtual returns (uint amountA, uint amountB) {
422         // create the pair if it doesn't exist yet
423         if (IUniswapV2Factory(factory).getPair(tokenA, tokenB) == address(0)) {
424             IUniswapV2Factory(factory).createPair(tokenA, tokenB);
425         }
426         (uint reserveA, uint reserveB) = UniswapV2Library.getReserves(factory, tokenA, tokenB);
427         if (reserveA == 0 && reserveB == 0) {
428             (amountA, amountB) = (amountADesired, amountBDesired);
429         } else {
430             uint amountBOptimal = UniswapV2Library.quote(amountADesired, reserveA, reserveB);
431             //  0.0648
432             if (amountBOptimal <= amountBDesired) {
433                 require(amountBOptimal >= amountBMin, 'INSUFFICIENT_B_AMOUNT');
434                 (amountA, amountB) = (amountADesired, amountBOptimal);
435             } else {
436                 uint amountAOptimal = UniswapV2Library.quote(amountBDesired, reserveB, reserveA);
437                 assert(amountAOptimal <= amountADesired);
438                 require(amountAOptimal >= amountAMin, 'INSUFFICIENT_A_AMOUNT');
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
499         require(amountA >= amountAMin, 'INSUFFICIENT_A_AMOUNT');
500         require(amountB >= amountBMin, 'INSUFFICIENT_B_AMOUNT');
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
571         TransferHelper.safeTransfer(token, to, IERC20Uniswap(token).balanceOf(address(this)));
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
613         uint adminoutFee = amountIn.mul(swapfee)/10000; 
614         amountIn = amountIn.sub(adminoutFee);
615         address adminAddress = IUniswapV2Factory(factory).feeToSetter();
616         amounts = UniswapV2Library.getAmountsOut(factory, amountIn, path);
617         require(amounts[amounts.length - 1] >= amountOutMin, 'INSUFFICIENT_OUTPUT_AMOUNT');
618         TransferHelper.safeTransferFrom(
619             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
620         );
621          TransferHelper.safeTransferFrom(
622             path[0], msg.sender, adminAddress, adminoutFee
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
633         uint adminFee = amountOut.mul(swapfee)/10000; 
634         amountOut = amountOut.sub(adminFee);
635         address adminAddress = IUniswapV2Factory(factory).feeToSetter();
636         amounts = UniswapV2Library.getAmountsIn(factory, amountOut, path);
637         require(amounts[0] <= amountInMax, 'EXCESSIVE_INPUT_AMOUNT');
638         TransferHelper.safeTransferFrom(
639             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
640         );
641         TransferHelper.safeTransferFrom(
642             path[0], msg.sender, adminAddress, adminFee
643         );
644         //TransferHelper.safeTransfer(path[0], adminAddress, adminFee);
645         _swap(amounts, path, to);
646     }
647     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
648         external
649         virtual
650         override
651         payable
652         ensure(deadline)
653         returns (uint[] memory amounts)
654     {
655         require(path[0] == WETH, 'INVALID_PATH');
656         uint amountin = msg.value;
657         uint adminFee = amountin.mul(swapfee)/10000; 
658         amountin = amountin.sub(adminFee);
659         amounts = UniswapV2Library.getAmountsOut(factory, amountin, path);
660         uint[] memory amountss = UniswapV2Library.getAmountsOut(factory, adminFee, path);
661         amountOutMin = amountOutMin - amountss[1];
662         require(amounts[amounts.length - 1] >= amountOutMin, 'INSUFFICIENT_OUTPUT_AMOUNT');
663         IWETH(WETH).deposit{value: amounts[0]}();
664         assert(IWETH(WETH).transfer(UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]));
665         TransferHelper.safeTransferETH(adminFeeAddress, adminFee);
666         _swap(amounts, path, to);
667     }
668     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
669         external
670         virtual
671         override
672         ensure(deadline)
673         returns (uint[] memory amounts)
674     {
675         require(path[path.length - 1] == WETH, 'INVALID_PATH');
676          uint admoutFee = amountOut.mul(swapfee)/10000; 
677         amountOut = amountOut.sub(admoutFee);
678         address adminAddress = IUniswapV2Factory(factory).feeToSetter();
679         amounts = UniswapV2Library.getAmountsIn(factory, amountOut, path);
680         require(amounts[0] <= amountInMax, 'EXCESSIVE_INPUT_AMOUNT');
681         TransferHelper.safeTransferFrom(
682             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
683         );
684         TransferHelper.safeTransferFrom(
685             path[0], msg.sender, adminAddress, admoutFee
686         );
687         _swap(amounts, path, address(this));
688         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
689         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
690     }
691     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
692         external
693         virtual
694         override
695         ensure(deadline)
696         returns (uint[] memory amounts)
697     {
698         require(path[path.length - 1] == WETH, 'INVALID_PATH');
699         uint admininFee = amountIn.mul(swapfee)/10000; 
700         amountIn = amountIn.sub(admininFee);
701         amounts = UniswapV2Library.getAmountsOut(factory, amountIn, path);
702         require(amounts[amounts.length - 1] >= amountOutMin, 'INSUFFICIENT_OUTPUT_AMOUNT');
703         TransferHelper.safeTransferFrom(
704             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
705         );
706          TransferHelper.safeTransferFrom(
707             path[0], msg.sender, adminFeeAddress, admininFee
708         );
709         _swap(amounts, path, address(this));
710         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
711         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
712     }
713     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
714         external
715         virtual
716         override
717         payable
718         ensure(deadline)
719         returns (uint[] memory amounts)
720     {
721         require(path[0] == WETH, 'INVALID_PATH');
722         amounts = UniswapV2Library.getAmountsIn(factory, amountOut, path);
723         uint adminoutFee = amounts[0].mul(swapfee)/10000; 
724         uint amountin = amounts[0].sub(adminoutFee);
725         require(amountin <= msg.value, 'EXCESSIVE_INPUT_AMOUNT');
726         IWETH(WETH).deposit{value: amountin}();
727         assert(IWETH(WETH).transfer(UniswapV2Library.pairFor(factory, path[0], path[1]), amountin));
728         TransferHelper.safeTransferETH(adminFeeAddress, adminoutFee);
729         uint[] memory amountss = UniswapV2Library.getAmountsOut(factory, amountin, path);
730         _swap(amountss, path, to);
731         // refund dust eth, if any
732         if (msg.value > amounts[0]) TransferHelper.safeTransferETH(msg.sender, msg.value - amounts[0]);
733     }
734 
735     // **** SWAP (supporting fee-on-transfer tokens) ****
736     // requires the initial amount to have already been sent to the first pair
737     function _swapSupportingFeeOnTransferTokens(address[] memory path, address _to) internal virtual {
738         for (uint i; i < path.length - 1; i++) {
739             (address input, address output) = (path[i], path[i + 1]);
740             (address token0,) = UniswapV2Library.sortTokens(input, output);
741             IUniswapV2Pair pair = IUniswapV2Pair(UniswapV2Library.pairFor(factory, input, output));
742             uint amountInput;
743             uint amountOutput;
744             { // scope to avoid stack too deep errors
745             (uint reserve0, uint reserve1,) = pair.getReserves();
746             (uint reserveInput, uint reserveOutput) = input == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
747             amountInput = IERC20Uniswap(input).balanceOf(address(pair)).sub(reserveInput);
748             amountOutput = UniswapV2Library.getAmountOut(amountInput, reserveInput, reserveOutput);
749             }
750             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOutput) : (amountOutput, uint(0));
751             address to = i < path.length - 2 ? UniswapV2Library.pairFor(factory, output, path[i + 2]) : _to;
752             pair.swap(amount0Out, amount1Out, to, new bytes(0));
753         }
754     }
755     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
756         uint amountIn,
757         uint amountOutMin,
758         address[] calldata path,
759         address to,
760         uint deadline
761     ) external virtual override ensure(deadline) {
762          uint admininFee = amountIn.mul(swapfee)/10000; 
763          amountIn = amountIn.sub(admininFee);
764          uint[] memory amount = UniswapV2Library.getAmountsOut(factory, amountIn, path);
765          amountOutMin = amount[1];
766         TransferHelper.safeTransferFrom(
767             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amountIn
768         );
769         uint balanceBefore = IERC20Uniswap(path[path.length - 1]).balanceOf(to);
770         _swapSupportingFeeOnTransferTokens(path, to);
771         require(
772             IERC20Uniswap(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
773             'INSUFFICIENT_OUTPUT_AMOUNT'
774         );
775          TransferHelper.safeTransferFrom(
776              path[0], msg.sender, adminFeeAddress, admininFee
777          );
778     }
779     function swapExactETHForTokensSupportingFeeOnTransferTokens(
780         uint amountOutMin,
781         address[] calldata path,
782         address to,
783         uint deadline
784     )
785         external
786         virtual
787         override
788         payable
789         ensure(deadline)
790     {
791         require(path[0] == WETH, 'INVALID_PATH');
792         uint amountIn = msg.value;
793         uint admininFee = amountIn.mul(swapfee)/10000; 
794         amountIn = amountIn.sub(admininFee);
795         uint[] memory amount = UniswapV2Library.getAmountsOut(factory, amountIn, path);
796         amountOutMin = amount[1];
797         IWETH(WETH).deposit{value: amountIn}();
798         assert(IWETH(WETH).transfer(UniswapV2Library.pairFor(factory, path[0], path[1]), amountIn));
799         TransferHelper.safeTransferETH(adminFeeAddress, admininFee);
800         uint balanceBefore = IERC20Uniswap(path[path.length - 1]).balanceOf(to);
801         _swapSupportingFeeOnTransferTokens(path, to);
802         require(
803             IERC20Uniswap(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
804             'INSUFFICIENT_OUTPUT_AMOUNT'
805         );
806     }
807     function swapExactTokensForETHSupportingFeeOnTransferTokens(
808         uint amountIn,
809         uint amountOutMin,
810         address[] calldata path,
811         address to,
812         uint deadline
813     )
814         external
815         virtual
816         override
817         ensure(deadline)
818     {
819         require(path[path.length - 1] == WETH, 'INVALID_PATH');
820         uint admininFee = amountIn.mul(swapfee)/1000; 
821         amountIn = amountIn.sub(admininFee);
822         uint[] memory amount = UniswapV2Library.getAmountsOut(factory, amountIn, path);
823         amountOutMin = amount[1];
824         TransferHelper.safeTransferFrom(
825             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amountIn
826         );
827         TransferHelper.safeTransferFrom(
828             path[0], msg.sender, adminFeeAddress, admininFee
829         );
830         _swapSupportingFeeOnTransferTokens(path, address(this));
831         uint amountOut = IERC20Uniswap(WETH).balanceOf(address(this));
832         require(amountOut >= amountOutMin, 'INSUFFICIENT_OUTPUT_AMOUNT');
833         IWETH(WETH).withdraw(amountOut);
834         TransferHelper.safeTransferETH(to, amountOut);
835         
836     }
837 
838     // **** LIBRARY FUNCTIONS ****
839     function quote(uint amountA, uint reserveA, uint reserveB) public pure virtual override returns (uint amountB) {
840         return UniswapV2Library.quote(amountA, reserveA, reserveB);
841     }
842 
843     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut)
844         public
845         pure
846         virtual
847         override
848         returns (uint amountOut)
849     {
850         return UniswapV2Library.getAmountOut(amountIn, reserveIn, reserveOut);
851     }
852 
853     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut)
854         public
855         pure
856         virtual
857         override
858         returns (uint amountIn)
859     {
860         return UniswapV2Library.getAmountIn(amountOut, reserveIn, reserveOut);
861     }
862 
863     function getAmountsOut(uint amountIn, address[] memory path)
864         public
865         view
866         virtual
867         override
868         returns (uint[] memory amounts)
869     {
870         return UniswapV2Library.getAmountsOut(factory, amountIn, path);
871     }
872 
873     function getAmountsIn(uint amountOut, address[] memory path)
874         public
875         view
876         virtual
877         override
878         returns (uint[] memory amounts)
879     {
880         return UniswapV2Library.getAmountsIn(factory, amountOut, path);
881     }
882 
883      function updateSwapFee() external {
884         address feeToSetter = IUniswapV2Factory(factory).feeToSetter();
885         require(msg.sender == feeToSetter, 'FORBIDDEN');
886         adminFeeAddress = IUniswapV2Factory(factory).feeToSetter();
887         swapfee = IUniswapV2Factory(factory).swapfee();
888     }
889 
890 }