1 // File: swap-contracts-core/contracts/interfaces/ICroDefiSwapFactory.sol
2 
3 pragma solidity >=0.5.0;
4 
5 interface ICroDefiSwapFactory {
6     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
7 
8     function feeTo() external view returns (address);
9     function feeToBasisPoint() external view returns (uint);
10 
11     // technically must be bigger than or equal to feeToBasisPoint
12     function totalFeeBasisPoint() external view returns (uint);
13 
14     function feeSetter() external view returns (address);
15 
16     function getPair(address tokenA, address tokenB) external view returns (address pair);
17     function allPairs(uint) external view returns (address pair);
18     function allPairsLength() external view returns (uint);
19 
20     function createPair(address tokenA, address tokenB) external returns (address pair);
21 
22     function setFeeTo(address) external;
23     function setFeeToBasisPoint(uint) external;
24     function setTotalFeeBasisPoint(uint) external;
25 
26     function setFeeSetter(address) external;
27 }
28 
29 // File: @uniswap/lib/contracts/libraries/TransferHelper.sol
30 
31 pragma solidity >=0.6.0;
32 
33 // helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
34 library TransferHelper {
35     function safeApprove(address token, address to, uint value) internal {
36         // bytes4(keccak256(bytes('approve(address,uint256)')));
37         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
38         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
39     }
40 
41     function safeTransfer(address token, address to, uint value) internal {
42         // bytes4(keccak256(bytes('transfer(address,uint256)')));
43         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
44         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
45     }
46 
47     function safeTransferFrom(address token, address from, address to, uint value) internal {
48         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
49         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
50         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
51     }
52 
53     function safeTransferETH(address to, uint value) internal {
54         (bool success,) = to.call{value:value}(new bytes(0));
55         require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
56     }
57 }
58 
59 // File: contracts/interfaces/ICroDefiSwapRouter01.sol
60 
61 pragma solidity >=0.6.2;
62 
63 interface ICroDefiSwapRouter01 {
64     function factory() external pure returns (address);
65     function WETH() external pure returns (address);
66 
67     function addLiquidity(
68         address tokenA,
69         address tokenB,
70         uint amountADesired,
71         uint amountBDesired,
72         uint amountAMin,
73         uint amountBMin,
74         address to,
75         uint deadline
76     ) external returns (uint amountA, uint amountB, uint liquidity);
77     function addLiquidityETH(
78         address token,
79         uint amountTokenDesired,
80         uint amountTokenMin,
81         uint amountETHMin,
82         address to,
83         uint deadline
84     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
85     function removeLiquidity(
86         address tokenA,
87         address tokenB,
88         uint liquidity,
89         uint amountAMin,
90         uint amountBMin,
91         address to,
92         uint deadline
93     ) external returns (uint amountA, uint amountB);
94     function removeLiquidityETH(
95         address token,
96         uint liquidity,
97         uint amountTokenMin,
98         uint amountETHMin,
99         address to,
100         uint deadline
101     ) external returns (uint amountToken, uint amountETH);
102     function removeLiquidityWithPermit(
103         address tokenA,
104         address tokenB,
105         uint liquidity,
106         uint amountAMin,
107         uint amountBMin,
108         address to,
109         uint deadline,
110         bool approveMax, uint8 v, bytes32 r, bytes32 s
111     ) external returns (uint amountA, uint amountB);
112     function removeLiquidityETHWithPermit(
113         address token,
114         uint liquidity,
115         uint amountTokenMin,
116         uint amountETHMin,
117         address to,
118         uint deadline,
119         bool approveMax, uint8 v, bytes32 r, bytes32 s
120     ) external returns (uint amountToken, uint amountETH);
121     function swapExactTokensForTokens(
122         uint amountIn,
123         uint amountOutMin,
124         address[] calldata path,
125         address to,
126         uint deadline
127     ) external returns (uint[] memory amounts);
128     function swapTokensForExactTokens(
129         uint amountOut,
130         uint amountInMax,
131         address[] calldata path,
132         address to,
133         uint deadline
134     ) external returns (uint[] memory amounts);
135     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
136         external
137         payable
138         returns (uint[] memory amounts);
139     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
140         external
141         returns (uint[] memory amounts);
142     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
143         external
144         returns (uint[] memory amounts);
145     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
146         external
147         payable
148         returns (uint[] memory amounts);
149 
150     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
151     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
152     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
153     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
154     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
155 }
156 
157 // File: contracts/interfaces/ICroDefiSwapRouter02.sol
158 
159 pragma solidity >=0.6.2;
160 
161 
162 interface ICroDefiSwapRouter02 is ICroDefiSwapRouter01 {
163     function removeLiquidityETHSupportingFeeOnTransferTokens(
164         address token,
165         uint liquidity,
166         uint amountTokenMin,
167         uint amountETHMin,
168         address to,
169         uint deadline
170     ) external returns (uint amountETH);
171     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
172         address token,
173         uint liquidity,
174         uint amountTokenMin,
175         uint amountETHMin,
176         address to,
177         uint deadline,
178         bool approveMax, uint8 v, bytes32 r, bytes32 s
179     ) external returns (uint amountETH);
180 
181     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
182         uint amountIn,
183         uint amountOutMin,
184         address[] calldata path,
185         address to,
186         uint deadline
187     ) external;
188     function swapExactETHForTokensSupportingFeeOnTransferTokens(
189         uint amountOutMin,
190         address[] calldata path,
191         address to,
192         uint deadline
193     ) external payable;
194     function swapExactTokensForETHSupportingFeeOnTransferTokens(
195         uint amountIn,
196         uint amountOutMin,
197         address[] calldata path,
198         address to,
199         uint deadline
200     ) external;
201 }
202 
203 // File: swap-contracts-core/contracts/interfaces/ICroDefiSwapPair.sol
204 
205 pragma solidity >=0.5.0;
206 
207 interface ICroDefiSwapPair {
208     event Approval(address indexed owner, address indexed spender, uint value);
209     event Transfer(address indexed from, address indexed to, uint value);
210 
211     function name() external pure returns (string memory);
212     function symbol() external pure returns (string memory);
213     function decimals() external pure returns (uint8);
214     function totalSupply() external view returns (uint);
215     function balanceOf(address owner) external view returns (uint);
216     function allowance(address owner, address spender) external view returns (uint);
217 
218     function approve(address spender, uint value) external returns (bool);
219     function transfer(address to, uint value) external returns (bool);
220     function transferFrom(address from, address to, uint value) external returns (bool);
221 
222     function DOMAIN_SEPARATOR() external view returns (bytes32);
223     function PERMIT_TYPEHASH() external pure returns (bytes32);
224     function nonces(address owner) external view returns (uint);
225 
226     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
227 
228     event Mint(address indexed sender, uint amount0, uint amount1);
229     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
230     event Swap(
231         address indexed sender,
232         uint amount0In,
233         uint amount1In,
234         uint amount0Out,
235         uint amount1Out,
236         address indexed to
237     );
238     event Sync(uint112 reserve0, uint112 reserve1);
239 
240     function MINIMUM_LIQUIDITY() external pure returns (uint);
241     function factory() external view returns (address);
242     function token0() external view returns (address);
243     function token1() external view returns (address);
244     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
245     function price0CumulativeLast() external view returns (uint);
246     function price1CumulativeLast() external view returns (uint);
247     function kLast() external view returns (uint);
248 
249     function mint(address to) external returns (uint liquidity);
250     function burn(address to) external returns (uint amount0, uint amount1);
251     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
252     function skim(address to) external;
253     function sync() external;
254 
255     function initialize(address, address) external;
256 }
257 
258 // File: contracts/libraries/SafeMath.sol
259 
260 pragma solidity =0.6.6;
261 
262 // a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)
263 
264 library SafeMath {
265     function add(uint x, uint y) internal pure returns (uint z) {
266         require((z = x + y) >= x, 'ds-math-add-overflow');
267     }
268 
269     function sub(uint x, uint y) internal pure returns (uint z) {
270         require((z = x - y) <= x, 'ds-math-sub-underflow');
271     }
272 
273     function mul(uint x, uint y) internal pure returns (uint z) {
274         require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');
275     }
276 }
277 
278 // File: contracts/libraries/CroDefiSwapLibrary.sol
279 
280 pragma solidity >=0.5.0;
281 
282 
283 
284 library CroDefiSwapLibrary {
285     using SafeMath for uint;
286 
287     // returns sorted token addresses, used to handle return values from pairs sorted in this order
288     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
289         require(tokenA != tokenB, 'CroDefiSwapLibrary: IDENTICAL_ADDRESSES');
290         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
291         require(token0 != address(0), 'CroDefiSwapLibrary: ZERO_ADDRESS');
292     }
293 
294     // calculates the CREATE2 address for a pair without making any external calls
295     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
296         (address token0, address token1) = sortTokens(tokenA, tokenB);
297         pair = address(uint(keccak256(abi.encodePacked(
298                 hex'ff',
299                 factory,
300                 keccak256(abi.encodePacked(token0, token1)),
301                 hex'69d637e77615df9f235f642acebbdad8963ef35c5523142078c9b8f9d0ceba7e' // init code hash
302             ))));
303     }
304 
305     // fetches and sorts the reserves for a pair
306     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
307         (address token0,) = sortTokens(tokenA, tokenB);
308         (uint reserve0, uint reserve1,) = ICroDefiSwapPair(pairFor(factory, tokenA, tokenB)).getReserves();
309         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
310     }
311 
312     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
313     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
314         require(amountA > 0, 'CroDefiSwapLibrary: INSUFFICIENT_AMOUNT');
315         require(reserveA > 0 && reserveB > 0, 'CroDefiSwapLibrary: INSUFFICIENT_LIQUIDITY');
316         amountB = amountA.mul(reserveB) / reserveA;
317     }
318 
319     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
320     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
321         require(amountIn > 0, 'CroDefiSwapLibrary: INSUFFICIENT_INPUT_AMOUNT');
322         require(reserveIn > 0 && reserveOut > 0, 'CroDefiSwapLibrary: INSUFFICIENT_LIQUIDITY');
323         uint amountInWithFee = amountIn.mul(997);
324         uint numerator = amountInWithFee.mul(reserveOut);
325         uint denominator = reserveIn.mul(1000).add(amountInWithFee);
326         amountOut = numerator / denominator;
327     }
328 
329     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
330     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {
331         require(amountOut > 0, 'CroDefiSwapLibrary: INSUFFICIENT_OUTPUT_AMOUNT');
332         require(reserveIn > 0 && reserveOut > 0, 'CroDefiSwapLibrary: INSUFFICIENT_LIQUIDITY');
333         uint numerator = reserveIn.mul(amountOut).mul(1000);
334         uint denominator = reserveOut.sub(amountOut).mul(997);
335         amountIn = (numerator / denominator).add(1);
336     }
337 
338     // performs chained getAmountOut calculations on any number of pairs
339     function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {
340         require(path.length >= 2, 'CroDefiSwapLibrary: INVALID_PATH');
341         amounts = new uint[](path.length);
342         amounts[0] = amountIn;
343         for (uint i; i < path.length - 1; i++) {
344             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);
345             amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
346         }
347     }
348 
349     // performs chained getAmountIn calculations on any number of pairs
350     function getAmountsIn(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {
351         require(path.length >= 2, 'CroDefiSwapLibrary: INVALID_PATH');
352         amounts = new uint[](path.length);
353         amounts[amounts.length - 1] = amountOut;
354         for (uint i = path.length - 1; i > 0; i--) {
355             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);
356             amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
357         }
358     }
359 }
360 
361 // File: contracts/interfaces/IERC20.sol
362 
363 pragma solidity >=0.5.0;
364 
365 interface IERC20 {
366     event Approval(address indexed owner, address indexed spender, uint value);
367     event Transfer(address indexed from, address indexed to, uint value);
368 
369     function name() external view returns (string memory);
370     function symbol() external view returns (string memory);
371     function decimals() external view returns (uint8);
372     function totalSupply() external view returns (uint);
373     function balanceOf(address owner) external view returns (uint);
374     function allowance(address owner, address spender) external view returns (uint);
375 
376     function approve(address spender, uint value) external returns (bool);
377     function transfer(address to, uint value) external returns (bool);
378     function transferFrom(address from, address to, uint value) external returns (bool);
379 }
380 
381 // File: contracts/interfaces/IWETH.sol
382 
383 pragma solidity >=0.5.0;
384 
385 interface IWETH {
386     function deposit() external payable;
387     function transfer(address to, uint value) external returns (bool);
388     function withdraw(uint) external;
389 }
390 
391 // File: contracts/CroDefiSwapRouter02.sol
392 
393 pragma solidity =0.6.6;
394 
395 
396 
397 
398 
399 
400 
401 
402 contract CroDefiSwapRouter02 is ICroDefiSwapRouter02 {
403     using SafeMath for uint;
404 
405     address public immutable override factory;
406     address public immutable override WETH;
407 
408     modifier ensure(uint deadline) {
409         require(deadline >= block.timestamp, 'CroDefiSwapRouter: EXPIRED');
410         _;
411     }
412 
413     constructor(address _factory, address _WETH) public {
414         factory = _factory;
415         WETH = _WETH;
416     }
417 
418     receive() external payable {
419         assert(msg.sender == WETH); // only accept ETH via fallback from the WETH contract
420     }
421 
422     // **** ADD LIQUIDITY ****
423     function _addLiquidity(
424         address tokenA,
425         address tokenB,
426         uint amountADesired,
427         uint amountBDesired,
428         uint amountAMin,
429         uint amountBMin
430     ) internal virtual returns (uint amountA, uint amountB) {
431         // create the pair if it doesn't exist yet
432         if (ICroDefiSwapFactory(factory).getPair(tokenA, tokenB) == address(0)) {
433             ICroDefiSwapFactory(factory).createPair(tokenA, tokenB);
434         }
435         (uint reserveA, uint reserveB) = CroDefiSwapLibrary.getReserves(factory, tokenA, tokenB);
436         if (reserveA == 0 && reserveB == 0) {
437             (amountA, amountB) = (amountADesired, amountBDesired);
438         } else {
439             uint amountBOptimal = CroDefiSwapLibrary.quote(amountADesired, reserveA, reserveB);
440             if (amountBOptimal <= amountBDesired) {
441                 require(amountBOptimal >= amountBMin, 'CroDefiSwapRouter: INSUFFICIENT_B_AMOUNT');
442                 (amountA, amountB) = (amountADesired, amountBOptimal);
443             } else {
444                 uint amountAOptimal = CroDefiSwapLibrary.quote(amountBDesired, reserveB, reserveA);
445                 assert(amountAOptimal <= amountADesired);
446                 require(amountAOptimal >= amountAMin, 'CroDefiSwapRouter: INSUFFICIENT_A_AMOUNT');
447                 (amountA, amountB) = (amountAOptimal, amountBDesired);
448             }
449         }
450     }
451     function addLiquidity(
452         address tokenA,
453         address tokenB,
454         uint amountADesired,
455         uint amountBDesired,
456         uint amountAMin,
457         uint amountBMin,
458         address to,
459         uint deadline
460     ) external virtual override ensure(deadline) returns (uint amountA, uint amountB, uint liquidity) {
461         (amountA, amountB) = _addLiquidity(tokenA, tokenB, amountADesired, amountBDesired, amountAMin, amountBMin);
462         address pair = CroDefiSwapLibrary.pairFor(factory, tokenA, tokenB);
463         TransferHelper.safeTransferFrom(tokenA, msg.sender, pair, amountA);
464         TransferHelper.safeTransferFrom(tokenB, msg.sender, pair, amountB);
465         liquidity = ICroDefiSwapPair(pair).mint(to);
466     }
467     function addLiquidityETH(
468         address token,
469         uint amountTokenDesired,
470         uint amountTokenMin,
471         uint amountETHMin,
472         address to,
473         uint deadline
474     ) external virtual override payable ensure(deadline) returns (uint amountToken, uint amountETH, uint liquidity) {
475         (amountToken, amountETH) = _addLiquidity(
476             token,
477             WETH,
478             amountTokenDesired,
479             msg.value,
480             amountTokenMin,
481             amountETHMin
482         );
483         address pair = CroDefiSwapLibrary.pairFor(factory, token, WETH);
484         TransferHelper.safeTransferFrom(token, msg.sender, pair, amountToken);
485         IWETH(WETH).deposit{value: amountETH}();
486         assert(IWETH(WETH).transfer(pair, amountETH));
487         liquidity = ICroDefiSwapPair(pair).mint(to);
488         // refund dust eth, if any
489         if (msg.value > amountETH) TransferHelper.safeTransferETH(msg.sender, msg.value - amountETH);
490     }
491 
492     // **** REMOVE LIQUIDITY ****
493     function removeLiquidity(
494         address tokenA,
495         address tokenB,
496         uint liquidity,
497         uint amountAMin,
498         uint amountBMin,
499         address to,
500         uint deadline
501     ) public virtual override ensure(deadline) returns (uint amountA, uint amountB) {
502         address pair = CroDefiSwapLibrary.pairFor(factory, tokenA, tokenB);
503         ICroDefiSwapPair(pair).transferFrom(msg.sender, pair, liquidity); // send liquidity to pair
504         (uint amount0, uint amount1) = ICroDefiSwapPair(pair).burn(to);
505         (address token0,) = CroDefiSwapLibrary.sortTokens(tokenA, tokenB);
506         (amountA, amountB) = tokenA == token0 ? (amount0, amount1) : (amount1, amount0);
507         require(amountA >= amountAMin, 'CroDefiSwapRouter: INSUFFICIENT_A_AMOUNT');
508         require(amountB >= amountBMin, 'CroDefiSwapRouter: INSUFFICIENT_B_AMOUNT');
509     }
510     function removeLiquidityETH(
511         address token,
512         uint liquidity,
513         uint amountTokenMin,
514         uint amountETHMin,
515         address to,
516         uint deadline
517     ) public virtual override ensure(deadline) returns (uint amountToken, uint amountETH) {
518         (amountToken, amountETH) = removeLiquidity(
519             token,
520             WETH,
521             liquidity,
522             amountTokenMin,
523             amountETHMin,
524             address(this),
525             deadline
526         );
527         TransferHelper.safeTransfer(token, to, amountToken);
528         IWETH(WETH).withdraw(amountETH);
529         TransferHelper.safeTransferETH(to, amountETH);
530     }
531     function removeLiquidityWithPermit(
532         address tokenA,
533         address tokenB,
534         uint liquidity,
535         uint amountAMin,
536         uint amountBMin,
537         address to,
538         uint deadline,
539         bool approveMax, uint8 v, bytes32 r, bytes32 s
540     ) external virtual override returns (uint amountA, uint amountB) {
541         address pair = CroDefiSwapLibrary.pairFor(factory, tokenA, tokenB);
542         uint value = approveMax ? uint(-1) : liquidity;
543         ICroDefiSwapPair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
544         (amountA, amountB) = removeLiquidity(tokenA, tokenB, liquidity, amountAMin, amountBMin, to, deadline);
545     }
546     function removeLiquidityETHWithPermit(
547         address token,
548         uint liquidity,
549         uint amountTokenMin,
550         uint amountETHMin,
551         address to,
552         uint deadline,
553         bool approveMax, uint8 v, bytes32 r, bytes32 s
554     ) external virtual override returns (uint amountToken, uint amountETH) {
555         address pair = CroDefiSwapLibrary.pairFor(factory, token, WETH);
556         uint value = approveMax ? uint(-1) : liquidity;
557         ICroDefiSwapPair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
558         (amountToken, amountETH) = removeLiquidityETH(token, liquidity, amountTokenMin, amountETHMin, to, deadline);
559     }
560 
561     // **** REMOVE LIQUIDITY (supporting fee-on-transfer tokens) ****
562     function removeLiquidityETHSupportingFeeOnTransferTokens(
563         address token,
564         uint liquidity,
565         uint amountTokenMin,
566         uint amountETHMin,
567         address to,
568         uint deadline
569     ) public virtual override ensure(deadline) returns (uint amountETH) {
570         (, amountETH) = removeLiquidity(
571             token,
572             WETH,
573             liquidity,
574             amountTokenMin,
575             amountETHMin,
576             address(this),
577             deadline
578         );
579         TransferHelper.safeTransfer(token, to, IERC20(token).balanceOf(address(this)));
580         IWETH(WETH).withdraw(amountETH);
581         TransferHelper.safeTransferETH(to, amountETH);
582     }
583     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
584         address token,
585         uint liquidity,
586         uint amountTokenMin,
587         uint amountETHMin,
588         address to,
589         uint deadline,
590         bool approveMax, uint8 v, bytes32 r, bytes32 s
591     ) external virtual override returns (uint amountETH) {
592         address pair = CroDefiSwapLibrary.pairFor(factory, token, WETH);
593         uint value = approveMax ? uint(-1) : liquidity;
594         ICroDefiSwapPair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
595         amountETH = removeLiquidityETHSupportingFeeOnTransferTokens(
596             token, liquidity, amountTokenMin, amountETHMin, to, deadline
597         );
598     }
599 
600     // **** SWAP ****
601     // requires the initial amount to have already been sent to the first pair
602     function _swap(uint[] memory amounts, address[] memory path, address _to) internal virtual {
603         for (uint i; i < path.length - 1; i++) {
604             (address input, address output) = (path[i], path[i + 1]);
605             (address token0,) = CroDefiSwapLibrary.sortTokens(input, output);
606             uint amountOut = amounts[i + 1];
607             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOut) : (amountOut, uint(0));
608             address to = i < path.length - 2 ? CroDefiSwapLibrary.pairFor(factory, output, path[i + 2]) : _to;
609             ICroDefiSwapPair(CroDefiSwapLibrary.pairFor(factory, input, output)).swap(
610                 amount0Out, amount1Out, to, new bytes(0)
611             );
612         }
613     }
614     function swapExactTokensForTokens(
615         uint amountIn,
616         uint amountOutMin,
617         address[] calldata path,
618         address to,
619         uint deadline
620     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
621         amounts = CroDefiSwapLibrary.getAmountsOut(factory, amountIn, path);
622         require(amounts[amounts.length - 1] >= amountOutMin, 'CroDefiSwapRouter: INSUFFICIENT_OUTPUT_AMOUNT');
623         TransferHelper.safeTransferFrom(
624             path[0], msg.sender, CroDefiSwapLibrary.pairFor(factory, path[0], path[1]), amounts[0]
625         );
626         _swap(amounts, path, to);
627     }
628     function swapTokensForExactTokens(
629         uint amountOut,
630         uint amountInMax,
631         address[] calldata path,
632         address to,
633         uint deadline
634     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
635         amounts = CroDefiSwapLibrary.getAmountsIn(factory, amountOut, path);
636         require(amounts[0] <= amountInMax, 'CroDefiSwapRouter: EXCESSIVE_INPUT_AMOUNT');
637         TransferHelper.safeTransferFrom(
638             path[0], msg.sender, CroDefiSwapLibrary.pairFor(factory, path[0], path[1]), amounts[0]
639         );
640         _swap(amounts, path, to);
641     }
642     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
643         external
644         virtual
645         override
646         payable
647         ensure(deadline)
648         returns (uint[] memory amounts)
649     {
650         require(path[0] == WETH, 'CroDefiSwapRouter: INVALID_PATH');
651         amounts = CroDefiSwapLibrary.getAmountsOut(factory, msg.value, path);
652         require(amounts[amounts.length - 1] >= amountOutMin, 'CroDefiSwapRouter: INSUFFICIENT_OUTPUT_AMOUNT');
653         IWETH(WETH).deposit{value: amounts[0]}();
654         assert(IWETH(WETH).transfer(CroDefiSwapLibrary.pairFor(factory, path[0], path[1]), amounts[0]));
655         _swap(amounts, path, to);
656     }
657     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
658         external
659         virtual
660         override
661         ensure(deadline)
662         returns (uint[] memory amounts)
663     {
664         require(path[path.length - 1] == WETH, 'CroDefiSwapRouter: INVALID_PATH');
665         amounts = CroDefiSwapLibrary.getAmountsIn(factory, amountOut, path);
666         require(amounts[0] <= amountInMax, 'CroDefiSwapRouter: EXCESSIVE_INPUT_AMOUNT');
667         TransferHelper.safeTransferFrom(
668             path[0], msg.sender, CroDefiSwapLibrary.pairFor(factory, path[0], path[1]), amounts[0]
669         );
670         _swap(amounts, path, address(this));
671         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
672         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
673     }
674     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
675         external
676         virtual
677         override
678         ensure(deadline)
679         returns (uint[] memory amounts)
680     {
681         require(path[path.length - 1] == WETH, 'CroDefiSwapRouter: INVALID_PATH');
682         amounts = CroDefiSwapLibrary.getAmountsOut(factory, amountIn, path);
683         require(amounts[amounts.length - 1] >= amountOutMin, 'CroDefiSwapRouter: INSUFFICIENT_OUTPUT_AMOUNT');
684         TransferHelper.safeTransferFrom(
685             path[0], msg.sender, CroDefiSwapLibrary.pairFor(factory, path[0], path[1]), amounts[0]
686         );
687         _swap(amounts, path, address(this));
688         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
689         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
690     }
691     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
692         external
693         virtual
694         override
695         payable
696         ensure(deadline)
697         returns (uint[] memory amounts)
698     {
699         require(path[0] == WETH, 'CroDefiSwapRouter: INVALID_PATH');
700         amounts = CroDefiSwapLibrary.getAmountsIn(factory, amountOut, path);
701         require(amounts[0] <= msg.value, 'CroDefiSwapRouter: EXCESSIVE_INPUT_AMOUNT');
702         IWETH(WETH).deposit{value: amounts[0]}();
703         assert(IWETH(WETH).transfer(CroDefiSwapLibrary.pairFor(factory, path[0], path[1]), amounts[0]));
704         _swap(amounts, path, to);
705         // refund dust eth, if any
706         if (msg.value > amounts[0]) TransferHelper.safeTransferETH(msg.sender, msg.value - amounts[0]);
707     }
708 
709     // **** SWAP (supporting fee-on-transfer tokens) ****
710     // requires the initial amount to have already been sent to the first pair
711     function _swapSupportingFeeOnTransferTokens(address[] memory path, address _to) internal virtual {
712         for (uint i; i < path.length - 1; i++) {
713             (address input, address output) = (path[i], path[i + 1]);
714             (address token0,) = CroDefiSwapLibrary.sortTokens(input, output);
715             ICroDefiSwapPair pair = ICroDefiSwapPair(CroDefiSwapLibrary.pairFor(factory, input, output));
716             uint amountInput;
717             uint amountOutput;
718             { // scope to avoid stack too deep errors
719             (uint reserve0, uint reserve1,) = pair.getReserves();
720             (uint reserveInput, uint reserveOutput) = input == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
721             amountInput = IERC20(input).balanceOf(address(pair)).sub(reserveInput);
722             amountOutput = CroDefiSwapLibrary.getAmountOut(amountInput, reserveInput, reserveOutput);
723             }
724             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOutput) : (amountOutput, uint(0));
725             address to = i < path.length - 2 ? CroDefiSwapLibrary.pairFor(factory, output, path[i + 2]) : _to;
726             pair.swap(amount0Out, amount1Out, to, new bytes(0));
727         }
728     }
729     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
730         uint amountIn,
731         uint amountOutMin,
732         address[] calldata path,
733         address to,
734         uint deadline
735     ) external virtual override ensure(deadline) {
736         TransferHelper.safeTransferFrom(
737             path[0], msg.sender, CroDefiSwapLibrary.pairFor(factory, path[0], path[1]), amountIn
738         );
739         uint balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
740         _swapSupportingFeeOnTransferTokens(path, to);
741         require(
742             IERC20(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
743             'CroDefiSwapRouter: INSUFFICIENT_OUTPUT_AMOUNT'
744         );
745     }
746     function swapExactETHForTokensSupportingFeeOnTransferTokens(
747         uint amountOutMin,
748         address[] calldata path,
749         address to,
750         uint deadline
751     )
752         external
753         virtual
754         override
755         payable
756         ensure(deadline)
757     {
758         require(path[0] == WETH, 'CroDefiSwapRouter: INVALID_PATH');
759         uint amountIn = msg.value;
760         IWETH(WETH).deposit{value: amountIn}();
761         assert(IWETH(WETH).transfer(CroDefiSwapLibrary.pairFor(factory, path[0], path[1]), amountIn));
762         uint balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
763         _swapSupportingFeeOnTransferTokens(path, to);
764         require(
765             IERC20(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
766             'CroDefiSwapRouter: INSUFFICIENT_OUTPUT_AMOUNT'
767         );
768     }
769     function swapExactTokensForETHSupportingFeeOnTransferTokens(
770         uint amountIn,
771         uint amountOutMin,
772         address[] calldata path,
773         address to,
774         uint deadline
775     )
776         external
777         virtual
778         override
779         ensure(deadline)
780     {
781         require(path[path.length - 1] == WETH, 'CroDefiSwapRouter: INVALID_PATH');
782         TransferHelper.safeTransferFrom(
783             path[0], msg.sender, CroDefiSwapLibrary.pairFor(factory, path[0], path[1]), amountIn
784         );
785         _swapSupportingFeeOnTransferTokens(path, address(this));
786         uint amountOut = IERC20(WETH).balanceOf(address(this));
787         require(amountOut >= amountOutMin, 'CroDefiSwapRouter: INSUFFICIENT_OUTPUT_AMOUNT');
788         IWETH(WETH).withdraw(amountOut);
789         TransferHelper.safeTransferETH(to, amountOut);
790     }
791 
792     // **** LIBRARY FUNCTIONS ****
793     function quote(uint amountA, uint reserveA, uint reserveB) public pure virtual override returns (uint amountB) {
794         return CroDefiSwapLibrary.quote(amountA, reserveA, reserveB);
795     }
796 
797     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut)
798         public
799         pure
800         virtual
801         override
802         returns (uint amountOut)
803     {
804         return CroDefiSwapLibrary.getAmountOut(amountIn, reserveIn, reserveOut);
805     }
806 
807     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut)
808         public
809         pure
810         virtual
811         override
812         returns (uint amountIn)
813     {
814         return CroDefiSwapLibrary.getAmountIn(amountOut, reserveIn, reserveOut);
815     }
816 
817     function getAmountsOut(uint amountIn, address[] memory path)
818         public
819         view
820         virtual
821         override
822         returns (uint[] memory amounts)
823     {
824         return CroDefiSwapLibrary.getAmountsOut(factory, amountIn, path);
825     }
826 
827     function getAmountsIn(uint amountOut, address[] memory path)
828         public
829         view
830         virtual
831         override
832         returns (uint[] memory amounts)
833     {
834         return CroDefiSwapLibrary.getAmountsIn(factory, amountOut, path);
835     }
836 }