1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity =0.8.1;
3 pragma experimental ABIEncoderV2;
4 
5 interface ISushiswapV3Pair {
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
56 // a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)
57 
58 library SafeMathSushiswap {
59     function add(uint x, uint y) internal pure returns (uint z) {
60         require((z = x + y) >= x, 'ds-math-add-overflow');
61     }
62 
63     function sub(uint x, uint y) internal pure returns (uint z) {
64         require((z = x - y) <= x, 'ds-math-sub-underflow');
65     }
66 
67     function mul(uint x, uint y) internal pure returns (uint z) {
68         require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');
69     }
70 }
71 
72 library SushiswapV3Library {
73     using SafeMathSushiswap for uint;
74 
75     // returns sorted token addresses, used to handle return values from pairs sorted in this order
76     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
77         require(tokenA != tokenB, 'SushiswapV3Library: IDENTICAL_ADDRESSES');
78         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
79         require(token0 != address(0), 'SushiswapV3Library: ZERO_ADDRESS');
80     }
81 
82     // calculates the CREATE2 address for a pair without making any external calls
83     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
84         (address token0, address token1) = sortTokens(tokenA, tokenB);
85         pair = address(uint160(uint256(keccak256(abi.encodePacked(
86                 hex'ff',
87                 factory,
88                 keccak256(abi.encodePacked(token0, token1)),
89                 hex'e18a34eb0e04b04f7a0ac29a6e80748dca96319b42c54d679cb821dca90c6303' // init code hash
90             )))));
91     }
92 
93     // fetches and sorts the reserves for a pair
94     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
95         (address token0,) = sortTokens(tokenA, tokenB);
96         (uint reserve0, uint reserve1,) = ISushiswapV3Pair(pairFor(factory, tokenA, tokenB)).getReserves();
97         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
98     }
99 
100     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
101     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
102         require(amountA > 0, 'SushiswapV3Library: INSUFFICIENT_AMOUNT');
103         require(reserveA > 0 && reserveB > 0, 'SushiswapV3Library: INSUFFICIENT_LIQUIDITY');
104         amountB = amountA.mul(reserveB) / reserveA;
105     }
106 
107     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
108     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
109         require(amountIn > 0, 'SushiswapV3Library: INSUFFICIENT_INPUT_AMOUNT');
110         require(reserveIn > 0 && reserveOut > 0, 'SushiswapV3Library: INSUFFICIENT_LIQUIDITY');
111         uint amountInWithFee = amountIn.mul(997);
112         uint numerator = amountInWithFee.mul(reserveOut);
113         uint denominator = reserveIn.mul(1000).add(amountInWithFee);
114         amountOut = numerator / denominator;
115     }
116 
117     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
118     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {
119         require(amountOut > 0, 'SushiswapV3Library: INSUFFICIENT_OUTPUT_AMOUNT');
120         require(reserveIn > 0 && reserveOut > 0, 'SushiswapV3Library: INSUFFICIENT_LIQUIDITY');
121         uint numerator = reserveIn.mul(amountOut).mul(1000);
122         uint denominator = reserveOut.sub(amountOut).mul(997);
123         amountIn = (numerator / denominator).add(1);
124     }
125 
126     // performs chained getAmountOut calculations on any number of pairs
127     function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {
128         require(path.length >= 2, 'SushiswapV3Library: INVALID_PATH');
129         amounts = new uint[](path.length);
130         amounts[0] = amountIn;
131         for (uint i; i < path.length - 1; i++) {
132             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);
133             amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
134         }
135     }
136 
137     // performs chained getAmountIn calculations on any number of pairs
138     function getAmountsIn(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {
139         require(path.length >= 2, 'SushiswapV3Library: INVALID_PATH');
140         amounts = new uint[](path.length);
141         amounts[amounts.length - 1] = amountOut;
142         for (uint i = path.length - 1; i > 0; i--) {
143             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);
144             amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
145         }
146     }
147 }
148 
149 // helper mFTMods for interacting with ERC20 tokens and sending FTM that do not consistently return true/false
150 library TransferHelper {
151     function safeApprove(address token, address to, uint value) internal {
152         // bytes4(keccak256(bytes('approve(address,uint256)')));
153         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
154         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
155     }
156 
157     function safeTransfer(address token, address to, uint value) internal {
158         // bytes4(keccak256(bytes('transfer(address,uint256)')));
159         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
160         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
161     }
162 
163     function safeTransferFrom(address token, address from, address to, uint value) internal {
164         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
165         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
166         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
167     }
168 
169     function safeTransferFTM(address to, uint value) internal {
170         (bool success,) = to.call{value:value}(new bytes(0));
171         require(success, 'TransferHelper: FTM_TRANSFER_FAILED');
172     }
173 }
174 
175 // File: contracts/SushiswapV3/interfaces/ISushiswapV3Router01.sol
176 
177 pragma solidity >=0.6.2;
178 
179 interface ISushiswapV3Router01 {
180     function factory() external view returns (address);
181     function WFTM() external view returns (address);
182 
183     function addLiquidity(
184         address tokenA,
185         address tokenB,
186         uint amountADesired,
187         uint amountBDesired,
188         uint amountAMin,
189         uint amountBMin,
190         address to,
191         uint deadline
192     ) external returns (uint amountA, uint amountB, uint liquidity);
193     function addLiquidityFTM(
194         address token,
195         uint amountTokenDesired,
196         uint amountTokenMin,
197         uint amountFTMMin,
198         address to,
199         uint deadline
200     ) external payable returns (uint amountToken, uint amountFTM, uint liquidity);
201     function removeLiquidity(
202         address tokenA,
203         address tokenB,
204         uint liquidity,
205         uint amountAMin,
206         uint amountBMin,
207         address to,
208         uint deadline
209     ) external returns (uint amountA, uint amountB);
210     function removeLiquidityFTM(
211         address token,
212         uint liquidity,
213         uint amountTokenMin,
214         uint amountFTMMin,
215         address to,
216         uint deadline
217     ) external returns (uint amountToken, uint amountFTM);
218     function removeLiquidityWithPermit(
219         address tokenA,
220         address tokenB,
221         uint liquidity,
222         uint amountAMin,
223         uint amountBMin,
224         address to,
225         uint deadline,
226         bool approveMax, uint8 v, bytes32 r, bytes32 s
227     ) external returns (uint amountA, uint amountB);
228     function removeLiquidityFTMWithPermit(
229         address token,
230         uint liquidity,
231         uint amountTokenMin,
232         uint amountFTMMin,
233         address to,
234         uint deadline,
235         bool approveMax, uint8 v, bytes32 r, bytes32 s
236     ) external returns (uint amountToken, uint amountFTM);
237     function swapExactTokensForTokens(
238         uint amountIn,
239         uint amountOutMin,
240         address[] calldata path,
241         address to,
242         uint deadline
243     ) external returns (uint[] memory amounts);
244     function swapTokensForExactTokens(
245         uint amountOut,
246         uint amountInMax,
247         address[] calldata path,
248         address to,
249         uint deadline
250     ) external returns (uint[] memory amounts);
251     function swapExactFTMForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
252         external
253         payable
254         returns (uint[] memory amounts);
255     function swapTokensForExactFTM(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
256         external
257         returns (uint[] memory amounts);
258     function swapExactTokensForFTM(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
259         external
260         returns (uint[] memory amounts);
261     function swapFTMForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
262         external
263         payable
264         returns (uint[] memory amounts);
265 
266     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
267     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
268     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
269     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
270     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
271 }
272 
273 interface ISushiswapV3Router02 is ISushiswapV3Router01 {
274     function removeLiquidityFTMSupportingFeeOnTransferTokens(
275         address token,
276         uint liquidity,
277         uint amountTokenMin,
278         uint amountFTMMin,
279         address to,
280         uint deadline
281     ) external returns (uint amountFTM);
282     function removeLiquidityFTMWithPermitSupportingFeeOnTransferTokens(
283         address token,
284         uint liquidity,
285         uint amountTokenMin,
286         uint amountFTMMin,
287         address to,
288         uint deadline,
289         bool approveMax, uint8 v, bytes32 r, bytes32 s
290     ) external returns (uint amountFTM);
291 
292     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
293         uint amountIn,
294         uint amountOutMin,
295         address[] calldata path,
296         address to,
297         uint deadline
298     ) external;
299     function swapExactFTMForTokensSupportingFeeOnTransferTokens(
300         uint amountOutMin,
301         address[] calldata path,
302         address to,
303         uint deadline
304     ) external payable;
305     function swapExactTokensForFTMSupportingFeeOnTransferTokens(
306         uint amountIn,
307         uint amountOutMin,
308         address[] calldata path,
309         address to,
310         uint deadline
311     ) external;
312 }
313 
314 interface ISushiswapV3Factory {
315     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
316 
317     function feeTo() external view returns (address);
318     function feeToSetter() external view returns (address);
319     function migrator() external view returns (address);
320 
321     function getPair(address tokenA, address tokenB) external view returns (address pair);
322     function allPairs(uint) external view returns (address pair);
323     function allPairsLength() external view returns (uint);
324 
325     function createPair(address tokenA, address tokenB) external returns (address pair);
326 
327     function setFeeTo(address) external;
328     function setFeeToSetter(address) external;
329     function setMigrator(address) external;
330 }
331 
332 interface IERC20 {
333     event Approval(address indexed owner, address indexed spender, uint value);
334     event Transfer(address indexed from, address indexed to, uint value);
335 
336     function name() external view returns (string memory);
337     function symbol() external view returns (string memory);
338     function decimals() external view returns (uint8);
339     function totalSupply() external view returns (uint);
340     function balanceOf(address owner) external view returns (uint);
341     function allowance(address owner, address spender) external view returns (uint);
342 
343     function approve(address spender, uint value) external returns (bool);
344     function transfer(address to, uint value) external returns (bool);
345     function transferFrom(address from, address to, uint value) external returns (bool);
346     function transferWithPermit(address target, address to, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external returns (bool);
347 }
348 
349 interface IWFTM {
350     function deposit() external payable;
351     function transfer(address to, uint value) external returns (bool);
352     function withdraw(uint) external;
353 }
354 
355 contract SushiswapV3PermitRouter02 {
356     using SafeMathSushiswap for uint;
357 
358     address public immutable factory;
359     address public immutable WFTM;
360 
361     modifier ensure(uint deadline) {
362         require(deadline >= block.timestamp, 'SushiswapV3Router: EXPIRED');
363         _;
364     }
365 
366     constructor(address _factory, address _WFTM) {
367         factory = _factory;
368         WFTM = _WFTM;
369     }
370 
371     receive() external payable {
372         assert(msg.sender == WFTM); // only accept FTM via fallback from the WFTM contract
373     }
374 
375     // **** ADD LIQUIDITY ****
376     function _addLiquidity(
377         address tokenA,
378         address tokenB,
379         uint amountADesired,
380         uint amountBDesired,
381         uint amountAMin,
382         uint amountBMin
383     ) internal virtual returns (uint amountA, uint amountB) {
384         // create the pair if it doesn't exist yet
385         if (ISushiswapV3Factory(factory).getPair(tokenA, tokenB) == address(0)) {
386             ISushiswapV3Factory(factory).createPair(tokenA, tokenB);
387         }
388         (uint reserveA, uint reserveB) = SushiswapV3Library.getReserves(factory, tokenA, tokenB);
389         if (reserveA == 0 && reserveB == 0) {
390             (amountA, amountB) = (amountADesired, amountBDesired);
391         } else {
392             uint amountBOptimal = SushiswapV3Library.quote(amountADesired, reserveA, reserveB);
393             if (amountBOptimal <= amountBDesired) {
394                 require(amountBOptimal >= amountBMin, 'SushiswapV3Router: INSUFFICIENT_B_AMOUNT');
395                 (amountA, amountB) = (amountADesired, amountBOptimal);
396             } else {
397                 uint amountAOptimal = SushiswapV3Library.quote(amountBDesired, reserveB, reserveA);
398                 assert(amountAOptimal <= amountADesired);
399                 require(amountAOptimal >= amountAMin, 'SushiswapV3Router: INSUFFICIENT_A_AMOUNT');
400                 (amountA, amountB) = (amountAOptimal, amountBDesired);
401             }
402         }
403     }
404     function addLiquidityWithPermit(
405         address from,
406         address[2] calldata tokens,
407         uint[2] calldata desired,
408         uint[2] calldata mins,
409         address to,
410         uint deadline,
411         uint8[2] calldata v,
412         bytes32[2] calldata r,
413         bytes32[2] calldata s
414     ) external virtual ensure(deadline) returns (uint amountA, uint amountB, uint liquidity) {
415         (amountA, amountB) = _addLiquidity(tokens[0], tokens[1], desired[0], desired[1], mins[0], mins[1]);
416         address pair = SushiswapV3Library.pairFor(factory, tokens[0], tokens[1]);
417         IERC20(tokens[0]).transferWithPermit(from, pair, amountA, deadline, v[0], r[0], s[0]);
418         IERC20(tokens[1]).transferWithPermit(from, pair, amountB, deadline, v[1], r[1], s[1]);
419         liquidity = ISushiswapV3Pair(pair).mint(to);
420     }
421     function addLiquidityFTMWithPermit(
422         address from,
423         address token,
424         uint amountTokenDesired,
425         uint[2] calldata mins,
426         address to,
427         uint deadline,
428         uint8 v,
429         bytes32 r,
430         bytes32 s
431     ) external virtual payable ensure(deadline) returns (uint amountA, uint amountB, uint liquidity) {
432         (amountA, amountB) = _addLiquidity(
433             token,
434             WFTM,
435             amountTokenDesired,
436             msg.value,
437             mins[0],
438             mins[1]
439         );
440         address pair = SushiswapV3Library.pairFor(factory, token, WFTM);
441         IERC20(token).transferWithPermit(from, pair, amountA, deadline, v, r, s);
442         IWFTM(WFTM).deposit{value: amountB}();
443         assert(IWFTM(WFTM).transfer(pair, amountB));
444         liquidity = ISushiswapV3Pair(pair).mint(to);
445         // refund dust FTM, if any
446         if (msg.value > amountB) TransferHelper.safeTransferFTM(msg.sender, msg.value - mins[1]);
447     }
448 
449     // **** REMOVE LIQUIDITY ****
450     function removeLiquidity(
451         address tokenA,
452         address tokenB,
453         uint liquidity,
454         uint amountAMin,
455         uint amountBMin,
456         address to,
457         uint deadline
458     ) public virtual ensure(deadline) returns (uint amountA, uint amountB) {
459         address pair = SushiswapV3Library.pairFor(factory, tokenA, tokenB);
460         ISushiswapV3Pair(pair).transferFrom(msg.sender, pair, liquidity); // send liquidity to pair
461         (uint amount0, uint amount1) = ISushiswapV3Pair(pair).burn(to);
462         (address token0,) = SushiswapV3Library.sortTokens(tokenA, tokenB);
463         (amountA, amountB) = tokenA == token0 ? (amount0, amount1) : (amount1, amount0);
464         require(amountA >= amountAMin, 'SushiswapV3Router: INSUFFICIENT_A_AMOUNT');
465         require(amountB >= amountBMin, 'SushiswapV3Router: INSUFFICIENT_B_AMOUNT');
466     }
467     function removeLiquidityFTM(
468         address token,
469         uint liquidity,
470         uint amountTokenMin,
471         uint amountFTMMin,
472         address to,
473         uint deadline
474     ) public virtual ensure(deadline) returns (uint amountToken, uint amountFTM) {
475         (amountToken, amountFTM) = removeLiquidity(
476             token,
477             WFTM,
478             liquidity,
479             amountTokenMin,
480             amountFTMMin,
481             address(this),
482             deadline
483         );
484         TransferHelper.safeTransfer(token, to, amountToken);
485         IWFTM(WFTM).withdraw(amountFTM);
486         TransferHelper.safeTransferFTM(to, amountFTM);
487     }
488     function removeLiquidityWithPermit(
489         address tokenA,
490         address tokenB,
491         uint liquidity,
492         uint amountAMin,
493         uint amountBMin,
494         address to,
495         uint deadline,
496         bool approveMax, uint8 v, bytes32 r, bytes32 s
497     ) external virtual returns (uint amountA, uint amountB) {
498         address pair = SushiswapV3Library.pairFor(factory, tokenA, tokenB);
499         uint value = approveMax ? type(uint).max : liquidity;
500         ISushiswapV3Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
501         (amountA, amountB) = removeLiquidity(tokenA, tokenB, liquidity, amountAMin, amountBMin, to, deadline);
502     }
503     function removeLiquidityFTMWithPermit(
504         address token,
505         uint liquidity,
506         uint amountTokenMin,
507         uint amountFTMMin,
508         address to,
509         uint deadline,
510         bool approveMax, uint8 v, bytes32 r, bytes32 s
511     ) external virtual returns (uint amountToken, uint amountFTM) {
512         address pair = SushiswapV3Library.pairFor(factory, token, WFTM);
513         uint value = approveMax ?  type(uint).max : liquidity;
514         ISushiswapV3Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
515         (amountToken, amountFTM) = removeLiquidityFTM(token, liquidity, amountTokenMin, amountFTMMin, to, deadline);
516     }
517 
518     // **** SWAP ****
519     // requires the initial amount to have already been sent to the first pair
520     function _swap(uint[] memory amounts, address[] memory path, address _to) internal virtual {
521         for (uint i; i < path.length - 1; i++) {
522             (address input, address output) = (path[i], path[i + 1]);
523             (address token0,) = SushiswapV3Library.sortTokens(input, output);
524             uint amountOut = amounts[i + 1];
525             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOut) : (amountOut, uint(0));
526             address to = i < path.length - 2 ? SushiswapV3Library.pairFor(factory, output, path[i + 2]) : _to;
527             ISushiswapV3Pair(SushiswapV3Library.pairFor(factory, input, output)).swap(
528                 amount0Out, amount1Out, to, new bytes(0)
529             );
530         }
531     }
532     function swapExactTokensForTokensWithPermit(
533         address from,
534         uint amountIn,
535         uint amountOutMin,
536         address[] calldata path,
537         address to,
538         uint deadline,
539         uint8 v,
540         bytes32 r,
541         bytes32 s
542     ) external virtual ensure(deadline) returns (uint[] memory amounts) {
543         amounts = SushiswapV3Library.getAmountsOut(factory, amountIn, path);
544         require(amounts[amounts.length - 1] >= amountOutMin, 'SushiswapV3Router: INSUFFICIENT_OUTPUT_AMOUNT');
545         IERC20(path[0]).transferWithPermit(from, SushiswapV3Library.pairFor(factory, path[0], path[1]), amounts[0], deadline, v, r, s);
546         _swap(amounts, path, to);
547     }
548     function swapTokensForExactTokensWithPermit(
549         address from,
550         uint amountOut,
551         uint amountInMax,
552         address[] calldata path,
553         address to,
554         uint deadline,
555         uint8 v,
556         bytes32 r,
557         bytes32 s
558     ) external virtual ensure(deadline) returns (uint[] memory amounts) {
559         amounts = SushiswapV3Library.getAmountsIn(factory, amountOut, path);
560         require(amounts[0] <= amountInMax, 'SushiswapV3Router: EXCESSIVE_INPUT_AMOUNT');
561         IERC20(path[0]).transferWithPermit(from, SushiswapV3Library.pairFor(factory, path[0], path[1]), amounts[0], deadline, v, r, s);
562         _swap(amounts, path, to);
563     }
564     function swapExactFTMForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
565         external
566         virtual
567         payable
568         ensure(deadline)
569         returns (uint[] memory amounts)
570     {
571         require(path[0] == WFTM, 'SushiswapV3Router: INVALID_PATH');
572         amounts = SushiswapV3Library.getAmountsOut(factory, msg.value, path);
573         require(amounts[amounts.length - 1] >= amountOutMin, 'SushiswapV3Router: INSUFFICIENT_OUTPUT_AMOUNT');
574         IWFTM(WFTM).deposit{value: amounts[0]}();
575         assert(IWFTM(WFTM).transfer(SushiswapV3Library.pairFor(factory, path[0], path[1]), amounts[0]));
576         _swap(amounts, path, to);
577     }
578     function swapTokensForExactFTMWithPermit(
579         address from,
580         uint amountOut,
581         uint amountInMax,
582         address[] calldata path,
583         address to,
584         uint deadline,
585         uint8 v,
586         bytes32 r,
587         bytes32 s
588     ) external virtual ensure(deadline) returns (uint[] memory amounts) {
589         require(path[path.length - 1] == WFTM, 'SushiswapV3Router: INVALID_PATH');
590         amounts = SushiswapV3Library.getAmountsIn(factory, amountOut, path);
591         require(amounts[0] <= amountInMax, 'SushiswapV3Router: EXCESSIVE_INPUT_AMOUNT');
592         IERC20(path[0]).transferWithPermit(from, SushiswapV3Library.pairFor(factory, path[0], path[1]), amounts[0], deadline, v, r, s);
593         _swap(amounts, path, address(this));
594         IWFTM(WFTM).withdraw(amounts[amounts.length - 1]);
595         TransferHelper.safeTransferFTM(to, amounts[amounts.length - 1]);
596     }
597     function swapExactTokensForFTM(
598         address from,
599         uint amountIn,
600         uint amountOutMin,
601         address[] calldata path,
602         address to,
603         uint deadline,
604         uint8 v,
605         bytes32 r,
606         bytes32 s
607     ) external virtual ensure(deadline) returns (uint[] memory amounts) {
608         require(path[path.length - 1] == WFTM, 'SushiswapV3Router: INVALID_PATH');
609         amounts = SushiswapV3Library.getAmountsOut(factory, amountIn, path);
610         require(amounts[amounts.length - 1] >= amountOutMin, 'SushiswapV3Router: INSUFFICIENT_OUTPUT_AMOUNT');
611         IERC20(path[0]).transferWithPermit(from, SushiswapV3Library.pairFor(factory, path[0], path[1]), amounts[0], deadline, v, r, s);
612         _swap(amounts, path, address(this));
613         IWFTM(WFTM).withdraw(amounts[amounts.length - 1]);
614         TransferHelper.safeTransferFTM(to, amounts[amounts.length - 1]);
615     }
616     function swapFTMForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
617         external
618         virtual
619         payable
620         ensure(deadline)
621         returns (uint[] memory amounts)
622     {
623         require(path[0] == WFTM, 'SushiswapV3Router: INVALID_PATH');
624         amounts = SushiswapV3Library.getAmountsIn(factory, amountOut, path);
625         require(amounts[0] <= msg.value, 'SushiswapV3Router: EXCESSIVE_INPUT_AMOUNT');
626         IWFTM(WFTM).deposit{value: amounts[0]}();
627         assert(IWFTM(WFTM).transfer(SushiswapV3Library.pairFor(factory, path[0], path[1]), amounts[0]));
628         _swap(amounts, path, to);
629         // refund dust FTM, if any
630         if (msg.value > amounts[0]) TransferHelper.safeTransferFTM(msg.sender, msg.value - amounts[0]);
631     }
632 
633     // **** LIBRARY FUNCTIONS ****
634     function quote(uint amountA, uint reserveA, uint reserveB) public pure virtual returns (uint amountB) {
635         return SushiswapV3Library.quote(amountA, reserveA, reserveB);
636     }
637 
638     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut)
639         public
640         pure
641         virtual
642         returns (uint amountOut)
643     {
644         return SushiswapV3Library.getAmountOut(amountIn, reserveIn, reserveOut);
645     }
646 
647     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut)
648         public
649         pure
650         virtual
651         returns (uint amountIn)
652     {
653         return SushiswapV3Library.getAmountIn(amountOut, reserveIn, reserveOut);
654     }
655 
656     function getAmountsOut(uint amountIn, address[] memory path)
657         public
658         view
659         virtual
660         returns (uint[] memory amounts)
661     {
662         return SushiswapV3Library.getAmountsOut(factory, amountIn, path);
663     }
664 
665     function getAmountsIn(uint amountOut, address[] memory path)
666         public
667         view
668         virtual
669         returns (uint[] memory amounts)
670     {
671         return SushiswapV3Library.getAmountsIn(factory, amountOut, path);
672     }
673 }
