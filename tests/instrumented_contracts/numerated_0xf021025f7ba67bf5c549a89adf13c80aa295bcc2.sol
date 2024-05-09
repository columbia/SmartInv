1 // File: contracts/interfaces/IUniswapV2Factory.sol
2 
3 pragma solidity >=0.5.0;
4 
5 interface IUniswapV2Factory {
6     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
7 
8     function feeTo() external view returns (address);
9     function owner() external view returns (address);
10 
11     function getPair(address tokenA, address tokenB) external view returns (address pair);
12     function allPairs(uint) external view returns (address pair);
13     function allPairsLength() external view returns (uint);
14 
15     function createPair(address tokenA, address tokenB) external returns (address pair);
16 
17     function setFeeTo(address) external;
18     function setOwner(address) external;
19 }
20 
21 
22 // helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
23 library TransferHelper {
24     function safeApprove(
25         address token,
26         address to,
27         uint256 value
28     ) internal {
29         // bytes4(keccak256(bytes('approve(address,uint256)')));
30         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
31         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
32     }
33 
34     function safeTransfer(
35         address token,
36         address to,
37         uint256 value
38     ) internal {
39         // bytes4(keccak256(bytes('transfer(address,uint256)')));
40         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
41         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
42     }
43 
44     function safeTransferFrom(
45         address token,
46         address from,
47         address to,
48         uint256 value
49     ) internal {
50         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
51         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
52         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
53     }
54 
55     function safeTransferETH(address to, uint256 value) internal {
56         (bool success, ) = to.call{value: value}(new bytes(0));
57         require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
58     }
59 }
60 
61 
62 interface IUniswapV2Router01 {
63     function factory() external pure returns (address);
64     function WETH() external pure returns (address);
65 
66     function addLiquidity(
67         address tokenA,
68         address tokenB,
69         uint amountADesired,
70         uint amountBDesired,
71         uint amountAMin,
72         uint amountBMin,
73         address to,
74         uint deadline
75     ) external returns (uint amountA, uint amountB, uint liquidity);
76     function addLiquidityETH(
77         address token,
78         uint amountTokenDesired,
79         uint amountTokenMin,
80         uint amountETHMin,
81         address to,
82         uint deadline
83     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
84     function removeLiquidity(
85         address tokenA,
86         address tokenB,
87         uint liquidity,
88         uint amountAMin,
89         uint amountBMin,
90         address to,
91         uint deadline
92     ) external returns (uint amountA, uint amountB);
93     function removeLiquidityETH(
94         address token,
95         uint liquidity,
96         uint amountTokenMin,
97         uint amountETHMin,
98         address to,
99         uint deadline
100     ) external returns (uint amountToken, uint amountETH);
101     function removeLiquidityWithPermit(
102         address tokenA,
103         address tokenB,
104         uint liquidity,
105         uint amountAMin,
106         uint amountBMin,
107         address to,
108         uint deadline,
109         bool approveMax, uint8 v, bytes32 r, bytes32 s
110     ) external returns (uint amountA, uint amountB);
111     function removeLiquidityETHWithPermit(
112         address token,
113         uint liquidity,
114         uint amountTokenMin,
115         uint amountETHMin,
116         address to,
117         uint deadline,
118         bool approveMax, uint8 v, bytes32 r, bytes32 s
119     ) external returns (uint amountToken, uint amountETH);
120     function swapExactTokensForTokens(
121         uint amountIn,
122         uint amountOutMin,
123         address[] calldata path,
124         address to,
125         uint deadline
126     ) external returns (uint[] memory amounts);
127     function swapTokensForExactTokens(
128         uint amountOut,
129         uint amountInMax,
130         address[] calldata path,
131         address to,
132         uint deadline
133     ) external returns (uint[] memory amounts);
134     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
135         external
136         payable
137         returns (uint[] memory amounts);
138     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
139         external
140         returns (uint[] memory amounts);
141     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
142         external
143         returns (uint[] memory amounts);
144     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
145         external
146         payable
147         returns (uint[] memory amounts);
148 
149     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
150     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
151     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
152     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
153     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
154 }
155 
156 
157 interface IUniswapV2Router02 is IUniswapV2Router01 {
158     function removeLiquidityETHSupportingFeeOnTransferTokens(
159         address token,
160         uint liquidity,
161         uint amountTokenMin,
162         uint amountETHMin,
163         address to,
164         uint deadline
165     ) external returns (uint amountETH);
166     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
167         address token,
168         uint liquidity,
169         uint amountTokenMin,
170         uint amountETHMin,
171         address to,
172         uint deadline,
173         bool approveMax, uint8 v, bytes32 r, bytes32 s
174     ) external returns (uint amountETH);
175 
176     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
177         uint amountIn,
178         uint amountOutMin,
179         address[] calldata path,
180         address to,
181         uint deadline
182     ) external;
183     function swapExactETHForTokensSupportingFeeOnTransferTokens(
184         uint amountOutMin,
185         address[] calldata path,
186         address to,
187         uint deadline
188     ) external payable;
189     function swapExactTokensForETHSupportingFeeOnTransferTokens(
190         uint amountIn,
191         uint amountOutMin,
192         address[] calldata path,
193         address to,
194         uint deadline
195     ) external;
196 }
197 
198 // File: contracts/interfaces/IUniswapV2Pair.sol
199 
200 pragma solidity >=0.5.0;
201 
202 interface IUniswapV2Pair {
203     event Approval(address indexed owner, address indexed spender, uint value);
204     event Transfer(address indexed from, address indexed to, uint value);
205 
206     function name() external pure returns (string memory);
207     function symbol() external pure returns (string memory);
208     function decimals() external pure returns (uint8);
209     function totalSupply() external view returns (uint);
210     function balanceOf(address owner) external view returns (uint);
211     function allowance(address owner, address spender) external view returns (uint);
212 
213     function approve(address spender, uint value) external returns (bool);
214     function transfer(address to, uint value) external returns (bool);
215     function transferFrom(address from, address to, uint value) external returns (bool);
216 
217     function DOMAIN_SEPARATOR() external view returns (bytes32);
218     function PERMIT_TYPEHASH() external pure returns (bytes32);
219     function nonces(address owner) external view returns (uint);
220 
221     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
222 
223     event Mint(address indexed sender, uint amount0, uint amount1);
224     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
225     event Swap(
226         address indexed sender,
227         uint amount0In,
228         uint amount1In,
229         uint amount0Out,
230         uint amount1Out,
231         address indexed to
232     );
233     event Sync(uint112 reserve0, uint112 reserve1);
234 
235     function MINIMUM_LIQUIDITY() external pure returns (uint);
236     function factory() external view returns (address);
237     function token0() external view returns (address);
238     function token1() external view returns (address);
239     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
240     function price0CumulativeLast() external view returns (uint);
241     function price1CumulativeLast() external view returns (uint);
242     function kLast() external view returns (uint);
243 
244     function mint(address to) external returns (uint liquidity);
245     function burn(address to) external returns (uint amount0, uint amount1);
246     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
247     function skim(address to) external;
248     function sync() external;
249 
250     function initialize(address, address) external;
251 }
252 
253 
254 
255 // a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)
256 
257 library SafeMath {
258     function add(uint x, uint y) internal pure returns (uint z) {
259         require((z = x + y) >= x, 'ds-math-add-overflow');
260     }
261 
262     function sub(uint x, uint y) internal pure returns (uint z) {
263         require((z = x - y) <= x, 'ds-math-sub-underflow');
264     }
265 
266     function mul(uint x, uint y) internal pure returns (uint z) {
267         require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');
268     }
269 
270     function div(uint256 a, uint256 b) internal pure returns (uint256) {
271         // Solidity only automatically asserts when dividing by 0
272         require(b > 0, 'ds-math-div-overflow');
273         uint256 c = a / b;
274         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
275 
276         return c;
277     }
278 }
279 
280 // File: contracts/libraries/UniswapV2Library.sol
281 
282 pragma solidity >=0.5.0;
283 
284 
285 
286 library UniswapV2Library {
287     using SafeMath for uint;
288 
289     // returns sorted token addresses, used to handle return values from pairs sorted in this order
290     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
291         require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');
292         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
293         require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');
294     }
295 
296     // calculates the CREATE2 address for a pair without making any external calls
297     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
298         (address token0, address token1) = sortTokens(tokenA, tokenB);
299         pair = address(uint(keccak256(abi.encodePacked(
300                 hex'ff',
301                 factory,
302                 keccak256(abi.encodePacked(token0, token1)),
303                 hex'4215dc414d4bd8fb0fc5f34c97341edb4ea6ac4c4b472589257a2c57ddc198e6' // init code hash
304             ))));
305     }
306 
307     // fetches and sorts the reserves for a pair
308     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
309         (address token0,) = sortTokens(tokenA, tokenB);
310         (uint reserve0, uint reserve1,) = IUniswapV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();
311         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
312     }
313 
314     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
315     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
316         require(amountA > 0, 'UniswapV2Library: INSUFFICIENT_AMOUNT');
317         require(reserveA > 0 && reserveB > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
318         amountB = amountA.mul(reserveB) / reserveA;
319     }
320 
321     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
322     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
323         require(amountIn > 0, 'UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT');
324         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
325         uint amountInWithFee = amountIn.mul(997);
326         uint numerator = amountInWithFee.mul(reserveOut);
327         uint denominator = reserveIn.mul(1000).add(amountInWithFee);
328         amountOut = numerator / denominator;
329     }
330 
331     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
332     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {
333         require(amountOut > 0, 'UniswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT');
334         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
335         uint numerator = reserveIn.mul(amountOut).mul(1000);
336         uint denominator = reserveOut.sub(amountOut).mul(997);
337         amountIn = (numerator / denominator).add(1);
338     }
339 
340     // performs chained getAmountOut calculations on any number of pairs
341     function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {
342         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
343         amounts = new uint[](path.length);
344         amounts[0] = amountIn;
345         for (uint i; i < path.length - 1; i++) {
346             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);
347             amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
348         }
349     }
350 
351     // performs chained getAmountIn calculations on any number of pairs
352     function getAmountsIn(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {
353         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
354         amounts = new uint[](path.length);
355         amounts[amounts.length - 1] = amountOut;
356         for (uint i = path.length - 1; i > 0; i--) {
357             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);
358             amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
359         }
360     }
361 }
362 
363 // File: contracts/interfaces/IERC20.sol
364 
365 pragma solidity >=0.5.0;
366 
367 interface IERC20 {
368     event Approval(address indexed owner, address indexed spender, uint value);
369     event Transfer(address indexed from, address indexed to, uint value);
370 
371     function name() external view returns (string memory);
372     function symbol() external view returns (string memory);
373     function decimals() external view returns (uint8);
374     function totalSupply() external view returns (uint);
375     function balanceOf(address owner) external view returns (uint);
376     function allowance(address owner, address spender) external view returns (uint);
377 
378     function approve(address spender, uint value) external returns (bool);
379     function transfer(address to, uint value) external returns (bool);
380     function transferFrom(address from, address to, uint value) external returns (bool);
381 }
382 
383 // File: contracts/interfaces/IWETH.sol
384 
385 pragma solidity >=0.5.0;
386 
387 interface IWETH {
388     function deposit() external payable;
389     function transfer(address to, uint value) external returns (bool);
390     function withdraw(uint) external;
391 }
392 
393 // File: contracts/UniswapV2Router02.sol
394 
395 pragma solidity =0.6.6;
396 
397 
398 
399 
400 
401 
402 
403 
404 contract UniswapV2Router02 is IUniswapV2Router02 {
405     using SafeMath for uint;
406 
407     address public immutable override factory;
408     address public immutable override WETH;
409 
410     modifier ensure(uint deadline) {
411         require(deadline >= block.timestamp, 'UniswapV2Router: EXPIRED');
412         _;
413     }
414 
415     constructor(address _factory, address _WETH) public {
416         factory = _factory;
417         WETH = _WETH;
418     }
419 
420     receive() external payable {
421         assert(msg.sender == WETH); // only accept ETH via fallback from the WETH contract
422     }
423 
424     // **** ADD LIQUIDITY ****
425     function _addLiquidity(
426         address tokenA,
427         address tokenB,
428         uint amountADesired,
429         uint amountBDesired,
430         uint amountAMin,
431         uint amountBMin
432     ) internal virtual returns (uint amountA, uint amountB) {
433         // create the pair if it doesn't exist yet
434         if (IUniswapV2Factory(factory).getPair(tokenA, tokenB) == address(0)) {
435             IUniswapV2Factory(factory).createPair(tokenA, tokenB);
436         }
437         (uint reserveA, uint reserveB) = UniswapV2Library.getReserves(factory, tokenA, tokenB);
438         if (reserveA == 0 && reserveB == 0) {
439             (amountA, amountB) = (amountADesired, amountBDesired);
440         } else {
441             uint amountBOptimal = UniswapV2Library.quote(amountADesired, reserveA, reserveB);
442             if (amountBOptimal <= amountBDesired) {
443                 require(amountBOptimal >= amountBMin, 'UniswapV2Router: INSUFFICIENT_B_AMOUNT');
444                 (amountA, amountB) = (amountADesired, amountBOptimal);
445             } else {
446                 uint amountAOptimal = UniswapV2Library.quote(amountBDesired, reserveB, reserveA);
447                 assert(amountAOptimal <= amountADesired);
448                 require(amountAOptimal >= amountAMin, 'UniswapV2Router: INSUFFICIENT_A_AMOUNT');
449                 (amountA, amountB) = (amountAOptimal, amountBDesired);
450             }
451         }
452     }
453     function addLiquidity(
454         address tokenA,
455         address tokenB,
456         uint amountADesired,
457         uint amountBDesired,
458         uint amountAMin,
459         uint amountBMin,
460         address to,
461         uint deadline
462     ) external virtual override ensure(deadline) returns (uint amountA, uint amountB, uint liquidity) {
463         (amountA, amountB) = _addLiquidity(tokenA, tokenB, amountADesired, amountBDesired, amountAMin, amountBMin);
464         address pair = UniswapV2Library.pairFor(factory, tokenA, tokenB);
465         TransferHelper.safeTransferFrom(tokenA, msg.sender, pair, amountA);
466         TransferHelper.safeTransferFrom(tokenB, msg.sender, pair, amountB);
467         liquidity = IUniswapV2Pair(pair).mint(to);
468     }
469     function addLiquidityETH(
470         address token,
471         uint amountTokenDesired,
472         uint amountTokenMin,
473         uint amountETHMin,
474         address to,
475         uint deadline
476     ) external virtual override payable ensure(deadline) returns (uint amountToken, uint amountETH, uint liquidity) {
477         (amountToken, amountETH) = _addLiquidity(
478             token,
479             WETH,
480             amountTokenDesired,
481             msg.value,
482             amountTokenMin,
483             amountETHMin
484         );
485         address pair = UniswapV2Library.pairFor(factory, token, WETH);
486         TransferHelper.safeTransferFrom(token, msg.sender, pair, amountToken);
487         IWETH(WETH).deposit{value: amountETH}();
488         assert(IWETH(WETH).transfer(pair, amountETH));
489         liquidity = IUniswapV2Pair(pair).mint(to);
490         // refund dust eth, if any
491         if (msg.value > amountETH) TransferHelper.safeTransferETH(msg.sender, msg.value - amountETH);
492     }
493 
494     // **** REMOVE LIQUIDITY ****
495     function removeLiquidity(
496         address tokenA,
497         address tokenB,
498         uint liquidity,
499         uint amountAMin,
500         uint amountBMin,
501         address to,
502         uint deadline
503     ) public virtual override ensure(deadline) returns (uint amountA, uint amountB) {
504         address pair = UniswapV2Library.pairFor(factory, tokenA, tokenB);
505         IUniswapV2Pair(pair).transferFrom(msg.sender, pair, liquidity); // send liquidity to pair
506         (uint amount0, uint amount1) = IUniswapV2Pair(pair).burn(to);
507         (address token0,) = UniswapV2Library.sortTokens(tokenA, tokenB);
508         (amountA, amountB) = tokenA == token0 ? (amount0, amount1) : (amount1, amount0);
509         require(amountA >= amountAMin, 'UniswapV2Router: INSUFFICIENT_A_AMOUNT');
510         require(amountB >= amountBMin, 'UniswapV2Router: INSUFFICIENT_B_AMOUNT');
511     }
512     function removeLiquidityETH(
513         address token,
514         uint liquidity,
515         uint amountTokenMin,
516         uint amountETHMin,
517         address to,
518         uint deadline
519     ) public virtual override ensure(deadline) returns (uint amountToken, uint amountETH) {
520         (amountToken, amountETH) = removeLiquidity(
521             token,
522             WETH,
523             liquidity,
524             amountTokenMin,
525             amountETHMin,
526             address(this),
527             deadline
528         );
529         TransferHelper.safeTransfer(token, to, amountToken);
530         IWETH(WETH).withdraw(amountETH);
531         TransferHelper.safeTransferETH(to, amountETH);
532     }
533     function removeLiquidityWithPermit(
534         address tokenA,
535         address tokenB,
536         uint liquidity,
537         uint amountAMin,
538         uint amountBMin,
539         address to,
540         uint deadline,
541         bool approveMax, uint8 v, bytes32 r, bytes32 s
542     ) external virtual override returns (uint amountA, uint amountB) {
543         address pair = UniswapV2Library.pairFor(factory, tokenA, tokenB);
544         uint value = approveMax ? uint(-1) : liquidity;
545         IUniswapV2Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
546         (amountA, amountB) = removeLiquidity(tokenA, tokenB, liquidity, amountAMin, amountBMin, to, deadline);
547     }
548     function removeLiquidityETHWithPermit(
549         address token,
550         uint liquidity,
551         uint amountTokenMin,
552         uint amountETHMin,
553         address to,
554         uint deadline,
555         bool approveMax, uint8 v, bytes32 r, bytes32 s
556     ) external virtual override returns (uint amountToken, uint amountETH) {
557         address pair = UniswapV2Library.pairFor(factory, token, WETH);
558         uint value = approveMax ? uint(-1) : liquidity;
559         IUniswapV2Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
560         (amountToken, amountETH) = removeLiquidityETH(token, liquidity, amountTokenMin, amountETHMin, to, deadline);
561     }
562 
563     // **** REMOVE LIQUIDITY (supporting fee-on-transfer tokens) ****
564     function removeLiquidityETHSupportingFeeOnTransferTokens(
565         address token,
566         uint liquidity,
567         uint amountTokenMin,
568         uint amountETHMin,
569         address to,
570         uint deadline
571     ) public virtual override ensure(deadline) returns (uint amountETH) {
572         (, amountETH) = removeLiquidity(
573             token,
574             WETH,
575             liquidity,
576             amountTokenMin,
577             amountETHMin,
578             address(this),
579             deadline
580         );
581         TransferHelper.safeTransfer(token, to, IERC20(token).balanceOf(address(this)));
582         IWETH(WETH).withdraw(amountETH);
583         TransferHelper.safeTransferETH(to, amountETH);
584     }
585     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
586         address token,
587         uint liquidity,
588         uint amountTokenMin,
589         uint amountETHMin,
590         address to,
591         uint deadline,
592         bool approveMax, uint8 v, bytes32 r, bytes32 s
593     ) external virtual override returns (uint amountETH) {
594         address pair = UniswapV2Library.pairFor(factory, token, WETH);
595         uint value = approveMax ? uint(-1) : liquidity;
596         IUniswapV2Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
597         amountETH = removeLiquidityETHSupportingFeeOnTransferTokens(
598             token, liquidity, amountTokenMin, amountETHMin, to, deadline
599         );
600     }
601 
602     // **** SWAP ****
603     // requires the initial amount to have already been sent to the first pair
604     function _swap(uint[] memory amounts, address[] memory path, address _to) internal virtual {
605         for (uint i; i < path.length - 1; i++) {
606             (address input, address output) = (path[i], path[i + 1]);
607             (address token0,) = UniswapV2Library.sortTokens(input, output);
608             uint amountOut = amounts[i + 1];
609             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOut) : (amountOut, uint(0));
610             address to = i < path.length - 2 ? UniswapV2Library.pairFor(factory, output, path[i + 2]) : _to;
611             IUniswapV2Pair(UniswapV2Library.pairFor(factory, input, output)).swap(
612                 amount0Out, amount1Out, to, new bytes(0)
613             );
614         }
615     }
616     function swapExactTokensForTokens(
617         uint amountIn,
618         uint amountOutMin,
619         address[] calldata path,
620         address to,
621         uint deadline
622     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
623         amounts = UniswapV2Library.getAmountsOut(factory, amountIn, path);
624         require(amounts[amounts.length - 1] >= amountOutMin, 'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
625         TransferHelper.safeTransferFrom(
626             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
627         );
628         _swap(amounts, path, to);
629     }
630     function swapTokensForExactTokens(
631         uint amountOut,
632         uint amountInMax,
633         address[] calldata path,
634         address to,
635         uint deadline
636     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
637         amounts = UniswapV2Library.getAmountsIn(factory, amountOut, path);
638         require(amounts[0] <= amountInMax, 'UniswapV2Router: EXCESSIVE_INPUT_AMOUNT');
639         TransferHelper.safeTransferFrom(
640             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
641         );
642         _swap(amounts, path, to);
643     }
644     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
645         external
646         virtual
647         override
648         payable
649         ensure(deadline)
650         returns (uint[] memory amounts)
651     {
652         require(path[0] == WETH, 'UniswapV2Router: INVALID_PATH');
653         amounts = UniswapV2Library.getAmountsOut(factory, msg.value, path);
654         require(amounts[amounts.length - 1] >= amountOutMin, 'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
655         IWETH(WETH).deposit{value: amounts[0]}();
656         assert(IWETH(WETH).transfer(UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]));
657         _swap(amounts, path, to);
658     }
659     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
660         external
661         virtual
662         override
663         ensure(deadline)
664         returns (uint[] memory amounts)
665     {
666         require(path[path.length - 1] == WETH, 'UniswapV2Router: INVALID_PATH');
667         amounts = UniswapV2Library.getAmountsIn(factory, amountOut, path);
668         require(amounts[0] <= amountInMax, 'UniswapV2Router: EXCESSIVE_INPUT_AMOUNT');
669         TransferHelper.safeTransferFrom(
670             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
671         );
672         _swap(amounts, path, address(this));
673         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
674         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
675     }
676     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
677         external
678         virtual
679         override
680         ensure(deadline)
681         returns (uint[] memory amounts)
682     {
683         require(path[path.length - 1] == WETH, 'UniswapV2Router: INVALID_PATH');
684         amounts = UniswapV2Library.getAmountsOut(factory, amountIn, path);
685         require(amounts[amounts.length - 1] >= amountOutMin, 'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
686         TransferHelper.safeTransferFrom(
687             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
688         );
689         _swap(amounts, path, address(this));
690         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
691         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
692     }
693     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
694         external
695         virtual
696         override
697         payable
698         ensure(deadline)
699         returns (uint[] memory amounts)
700     {
701         require(path[0] == WETH, 'UniswapV2Router: INVALID_PATH');
702         amounts = UniswapV2Library.getAmountsIn(factory, amountOut, path);
703         require(amounts[0] <= msg.value, 'UniswapV2Router: EXCESSIVE_INPUT_AMOUNT');
704         IWETH(WETH).deposit{value: amounts[0]}();
705         assert(IWETH(WETH).transfer(UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]));
706         _swap(amounts, path, to);
707         // refund dust eth, if any
708         if (msg.value > amounts[0]) TransferHelper.safeTransferETH(msg.sender, msg.value - amounts[0]);
709     }
710 
711     // **** SWAP (supporting fee-on-transfer tokens) ****
712     // requires the initial amount to have already been sent to the first pair
713     function _swapSupportingFeeOnTransferTokens(address[] memory path, address _to) internal virtual {
714         for (uint i; i < path.length - 1; i++) {
715             (address input, address output) = (path[i], path[i + 1]);
716             (address token0,) = UniswapV2Library.sortTokens(input, output);
717             IUniswapV2Pair pair = IUniswapV2Pair(UniswapV2Library.pairFor(factory, input, output));
718             uint amountInput;
719             uint amountOutput;
720             { // scope to avoid stack too deep errors
721             (uint reserve0, uint reserve1,) = pair.getReserves();
722             (uint reserveInput, uint reserveOutput) = input == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
723             amountInput = IERC20(input).balanceOf(address(pair)).sub(reserveInput);
724             amountOutput = UniswapV2Library.getAmountOut(amountInput, reserveInput, reserveOutput);
725             }
726             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOutput) : (amountOutput, uint(0));
727             address to = i < path.length - 2 ? UniswapV2Library.pairFor(factory, output, path[i + 2]) : _to;
728             pair.swap(amount0Out, amount1Out, to, new bytes(0));
729         }
730     }
731     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
732         uint amountIn,
733         uint amountOutMin,
734         address[] calldata path,
735         address to,
736         uint deadline
737     ) external virtual override ensure(deadline) {
738         TransferHelper.safeTransferFrom(
739             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amountIn
740         );
741         uint balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
742         _swapSupportingFeeOnTransferTokens(path, to);
743         require(
744             IERC20(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
745             'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT'
746         );
747     }
748     function swapExactETHForTokensSupportingFeeOnTransferTokens(
749         uint amountOutMin,
750         address[] calldata path,
751         address to,
752         uint deadline
753     )
754         external
755         virtual
756         override
757         payable
758         ensure(deadline)
759     {
760         require(path[0] == WETH, 'UniswapV2Router: INVALID_PATH');
761         uint amountIn = msg.value;
762         IWETH(WETH).deposit{value: amountIn}();
763         assert(IWETH(WETH).transfer(UniswapV2Library.pairFor(factory, path[0], path[1]), amountIn));
764         uint balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
765         _swapSupportingFeeOnTransferTokens(path, to);
766         require(
767             IERC20(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
768             'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT'
769         );
770     }
771     function swapExactTokensForETHSupportingFeeOnTransferTokens(
772         uint amountIn,
773         uint amountOutMin,
774         address[] calldata path,
775         address to,
776         uint deadline
777     )
778         external
779         virtual
780         override
781         ensure(deadline)
782     {
783         require(path[path.length - 1] == WETH, 'UniswapV2Router: INVALID_PATH');
784         TransferHelper.safeTransferFrom(
785             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amountIn
786         );
787         _swapSupportingFeeOnTransferTokens(path, address(this));
788         uint amountOut = IERC20(WETH).balanceOf(address(this));
789         require(amountOut >= amountOutMin, 'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
790         IWETH(WETH).withdraw(amountOut);
791         TransferHelper.safeTransferETH(to, amountOut);
792     }
793 
794     // **** LIBRARY FUNCTIONS ****
795     function quote(uint amountA, uint reserveA, uint reserveB) public pure virtual override returns (uint amountB) {
796         return UniswapV2Library.quote(amountA, reserveA, reserveB);
797     }
798 
799     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut)
800         public
801         pure
802         virtual
803         override
804         returns (uint amountOut)
805     {
806         return UniswapV2Library.getAmountOut(amountIn, reserveIn, reserveOut);
807     }
808 
809     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut)
810         public
811         pure
812         virtual
813         override
814         returns (uint amountIn)
815     {
816         return UniswapV2Library.getAmountIn(amountOut, reserveIn, reserveOut);
817     }
818 
819     function getAmountsOut(uint amountIn, address[] memory path)
820         public
821         view
822         virtual
823         override
824         returns (uint[] memory amounts)
825     {
826         return UniswapV2Library.getAmountsOut(factory, amountIn, path);
827     }
828 
829     function getAmountsIn(uint amountOut, address[] memory path)
830         public
831         view
832         virtual
833         override
834         returns (uint[] memory amounts)
835     {
836         return UniswapV2Library.getAmountsIn(factory, amountOut, path);
837     }
838 }