1 pragma solidity =0.6.12;
2 
3 library SafeMathUniswap {
4     function add(uint x, uint y) internal pure returns (uint z) {
5         require((z = x + y) >= x, 'ds-math-add-overflow');
6     }
7 
8     function sub(uint x, uint y) internal pure returns (uint z) {
9         require((z = x - y) <= x, 'ds-math-sub-underflow');
10     }
11 
12     function mul(uint x, uint y) internal pure returns (uint z) {
13         require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');
14     }
15 }
16 
17 interface IUniswapV2Pair {
18     event Approval(address indexed owner, address indexed spender, uint value);
19     event Transfer(address indexed from, address indexed to, uint value);
20 
21     function name() external pure returns (string memory);
22     function symbol() external pure returns (string memory);
23     function decimals() external pure returns (uint8);
24     function totalSupply() external view returns (uint);
25     function balanceOf(address owner) external view returns (uint);
26     function allowance(address owner, address spender) external view returns (uint);
27 
28     function approve(address spender, uint value) external returns (bool);
29     function transfer(address to, uint value) external returns (bool);
30     function transferFrom(address from, address to, uint value) external returns (bool);
31 
32     function DOMAIN_SEPARATOR() external view returns (bytes32);
33     function PERMIT_TYPEHASH() external pure returns (bytes32);
34     function nonces(address owner) external view returns (uint);
35 
36     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
37 
38     event Mint(address indexed sender, uint amount0, uint amount1);
39     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
40     event Swap(
41         address indexed sender,
42         uint amount0In,
43         uint amount1In,
44         uint amount0Out,
45         uint amount1Out,
46         address indexed to
47     );
48     event Sync(uint112 reserve0, uint112 reserve1);
49 
50     function MINIMUM_LIQUIDITY() external pure returns (uint);
51     function factory() external view returns (address);
52     function token0() external view returns (address);
53     function token1() external view returns (address);
54     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
55     function price0CumulativeLast() external view returns (uint);
56     function price1CumulativeLast() external view returns (uint);
57     function kLast() external view returns (uint);
58 
59     function mint(address to) external returns (uint liquidity);
60     function burn(address to) external returns (uint amount0, uint amount1);
61     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
62     function skim(address to) external;
63     function sync() external;
64 
65     function initialize(address, address) external;
66 }
67 
68 
69 library UniswapV2Library {
70     using SafeMathUniswap for uint;
71 
72     // returns sorted token addresses, used to handle return values from pairs sorted in this order
73     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
74         require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');
75         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
76         require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');
77     }
78 
79     // calculates the CREATE2 address for a pair without making any external calls
80     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
81         (address token0, address token1) = sortTokens(tokenA, tokenB);
82         pair = address(uint(keccak256(abi.encodePacked(
83                 hex'ff',
84                 factory,
85                 keccak256(abi.encodePacked(token0, token1)),
86                 hex'2e656df6c5f2832282567b32c3e1a3b4eaab00abcc91589374b3ce0f0ae109ee' // init code hash
87             ))));
88     }
89 
90     // fetches and sorts the reserves for a pair
91     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
92         (address token0,) = sortTokens(tokenA, tokenB);
93         (uint reserve0, uint reserve1,) = IUniswapV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();
94         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
95     }
96 
97     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
98     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
99         require(amountA > 0, 'UniswapV2Library: INSUFFICIENT_AMOUNT');
100         require(reserveA > 0 && reserveB > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
101         amountB = amountA.mul(reserveB) / reserveA;
102     }
103 
104     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
105     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
106         require(amountIn > 0, 'UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT');
107         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
108         uint amountInWithFee = amountIn.mul(997);
109         uint numerator = amountInWithFee.mul(reserveOut);
110         uint denominator = reserveIn.mul(1000).add(amountInWithFee);
111         amountOut = numerator / denominator;
112     }
113 
114     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
115     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {
116         require(amountOut > 0, 'UniswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT');
117         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
118         uint numerator = reserveIn.mul(amountOut).mul(1000);
119         uint denominator = reserveOut.sub(amountOut).mul(997);
120         amountIn = (numerator / denominator).add(1);
121     }
122 
123     // performs chained getAmountOut calculations on any number of pairs
124     function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {
125         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
126         amounts = new uint[](path.length);
127         amounts[0] = amountIn;
128         for (uint i; i < path.length - 1; i++) {
129             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);
130             amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
131         }
132     }
133 
134     // performs chained getAmountIn calculations on any number of pairs
135     function getAmountsIn(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {
136         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
137         amounts = new uint[](path.length);
138         amounts[amounts.length - 1] = amountOut;
139         for (uint i = path.length - 1; i > 0; i--) {
140             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);
141             amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
142         }
143     }
144 }
145 
146 // helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
147 library TransferHelper {
148     function safeApprove(address token, address to, uint value) internal {
149         // bytes4(keccak256(bytes('approve(address,uint256)')));
150         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
151         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
152     }
153 
154     function safeTransfer(address token, address to, uint value) internal {
155         // bytes4(keccak256(bytes('transfer(address,uint256)')));
156         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
157         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
158     }
159 
160     function safeTransferFrom(address token, address from, address to, uint value) internal {
161         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
162         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
163         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
164     }
165 
166     function safeTransferETH(address to, uint value) internal {
167         (bool success,) = to.call{value:value}(new bytes(0));
168         require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
169     }
170 }
171 
172 interface IUniswapV2Router01 {
173     function factory() external pure returns (address);
174     function WETH() external pure returns (address);
175 
176     function addLiquidity(
177         address tokenA,
178         address tokenB,
179         uint amountADesired,
180         uint amountBDesired,
181         uint amountAMin,
182         uint amountBMin,
183         address to,
184         uint deadline
185     ) external returns (uint amountA, uint amountB, uint liquidity);
186     function addLiquidityETH(
187         address token,
188         uint amountTokenDesired,
189         uint amountTokenMin,
190         uint amountETHMin,
191         address to,
192         uint deadline
193     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
194     function removeLiquidity(
195         address tokenA,
196         address tokenB,
197         uint liquidity,
198         uint amountAMin,
199         uint amountBMin,
200         address to,
201         uint deadline
202     ) external returns (uint amountA, uint amountB);
203     function removeLiquidityETH(
204         address token,
205         uint liquidity,
206         uint amountTokenMin,
207         uint amountETHMin,
208         address to,
209         uint deadline
210     ) external returns (uint amountToken, uint amountETH);
211     function removeLiquidityWithPermit(
212         address tokenA,
213         address tokenB,
214         uint liquidity,
215         uint amountAMin,
216         uint amountBMin,
217         address to,
218         uint deadline,
219         bool approveMax, uint8 v, bytes32 r, bytes32 s
220     ) external returns (uint amountA, uint amountB);
221     function removeLiquidityETHWithPermit(
222         address token,
223         uint liquidity,
224         uint amountTokenMin,
225         uint amountETHMin,
226         address to,
227         uint deadline,
228         bool approveMax, uint8 v, bytes32 r, bytes32 s
229     ) external returns (uint amountToken, uint amountETH);
230     function swapExactTokensForTokens(
231         uint amountIn,
232         uint amountOutMin,
233         address[] calldata path,
234         address to,
235         uint deadline
236     ) external returns (uint[] memory amounts);
237     function swapTokensForExactTokens(
238         uint amountOut,
239         uint amountInMax,
240         address[] calldata path,
241         address to,
242         uint deadline
243     ) external returns (uint[] memory amounts);
244     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
245         external
246         payable
247         returns (uint[] memory amounts);
248     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
249         external
250         returns (uint[] memory amounts);
251     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
252         external
253         returns (uint[] memory amounts);
254     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
255         external
256         payable
257         returns (uint[] memory amounts);
258 
259     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
260     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
261     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
262     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
263     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
264 }
265 
266 interface IUniswapV2Router02 is IUniswapV2Router01 {
267     function removeLiquidityETHSupportingFeeOnTransferTokens(
268         address token,
269         uint liquidity,
270         uint amountTokenMin,
271         uint amountETHMin,
272         address to,
273         uint deadline
274     ) external returns (uint amountETH);
275     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
276         address token,
277         uint liquidity,
278         uint amountTokenMin,
279         uint amountETHMin,
280         address to,
281         uint deadline,
282         bool approveMax, uint8 v, bytes32 r, bytes32 s
283     ) external returns (uint amountETH);
284 
285     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
286         uint amountIn,
287         uint amountOutMin,
288         address[] calldata path,
289         address to,
290         uint deadline
291     ) external;
292     function swapExactETHForTokensSupportingFeeOnTransferTokens(
293         uint amountOutMin,
294         address[] calldata path,
295         address to,
296         uint deadline
297     ) external payable;
298     function swapExactTokensForETHSupportingFeeOnTransferTokens(
299         uint amountIn,
300         uint amountOutMin,
301         address[] calldata path,
302         address to,
303         uint deadline
304     ) external;
305 }
306 
307 interface IUniswapV2Factory {
308     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
309 
310     function feeTo() external view returns (address);
311     function feeToSetter() external view returns (address);
312     function migrator() external view returns (address);
313 
314     function getPair(address tokenA, address tokenB) external view returns (address pair);
315     function allPairs(uint) external view returns (address pair);
316     function allPairsLength() external view returns (uint);
317 
318     function createPair(address tokenA, address tokenB) external returns (address pair);
319 
320     function setFeeTo(address) external;
321     function setFeeToSetter(address) external;
322     function setMigrator(address) external;
323 }
324 
325 interface IERC20Uniswap {
326     event Approval(address indexed owner, address indexed spender, uint value);
327     event Transfer(address indexed from, address indexed to, uint value);
328 
329     function name() external view returns (string memory);
330     function symbol() external view returns (string memory);
331     function decimals() external view returns (uint8);
332     function totalSupply() external view returns (uint);
333     function balanceOf(address owner) external view returns (uint);
334     function allowance(address owner, address spender) external view returns (uint);
335 
336     function approve(address spender, uint value) external returns (bool);
337     function transfer(address to, uint value) external returns (bool);
338     function transferFrom(address from, address to, uint value) external returns (bool);
339 }
340 
341 interface IWETH {
342     function deposit() external payable;
343     function transfer(address to, uint value) external returns (bool);
344     function withdraw(uint) external;
345 }
346 
347 contract UniswapV2Router02 is IUniswapV2Router02 {
348     using SafeMathUniswap for uint;
349 
350     address public immutable override factory;
351     address public immutable override WETH;
352 
353     modifier ensure(uint deadline) {
354         require(deadline >= block.timestamp, 'UniswapV2Router: EXPIRED');
355         _;
356     }
357 
358     constructor(address _factory, address _WETH) public {
359         factory = _factory;
360         WETH = _WETH;
361     }
362 
363     receive() external payable {
364         assert(msg.sender == WETH); // only accept ETH via fallback from the WETH contract
365     }
366 
367     // **** ADD LIQUIDITY ****
368     function _addLiquidity(
369         address tokenA,
370         address tokenB,
371         uint amountADesired,
372         uint amountBDesired,
373         uint amountAMin,
374         uint amountBMin
375     ) internal virtual returns (uint amountA, uint amountB) {
376         // create the pair if it doesn't exist yet
377         if (IUniswapV2Factory(factory).getPair(tokenA, tokenB) == address(0)) {
378             IUniswapV2Factory(factory).createPair(tokenA, tokenB);
379         }
380         (uint reserveA, uint reserveB) = UniswapV2Library.getReserves(factory, tokenA, tokenB);
381         if (reserveA == 0 && reserveB == 0) {
382             (amountA, amountB) = (amountADesired, amountBDesired);
383         } else {
384             uint amountBOptimal = UniswapV2Library.quote(amountADesired, reserveA, reserveB);
385             if (amountBOptimal <= amountBDesired) {
386                 require(amountBOptimal >= amountBMin, 'UniswapV2Router: INSUFFICIENT_B_AMOUNT');
387                 (amountA, amountB) = (amountADesired, amountBOptimal);
388             } else {
389                 uint amountAOptimal = UniswapV2Library.quote(amountBDesired, reserveB, reserveA);
390                 assert(amountAOptimal <= amountADesired);
391                 require(amountAOptimal >= amountAMin, 'UniswapV2Router: INSUFFICIENT_A_AMOUNT');
392                 (amountA, amountB) = (amountAOptimal, amountBDesired);
393             }
394         }
395     }
396     function addLiquidity(
397         address tokenA,
398         address tokenB,
399         uint amountADesired,
400         uint amountBDesired,
401         uint amountAMin,
402         uint amountBMin,
403         address to,
404         uint deadline
405     ) external virtual override ensure(deadline) returns (uint amountA, uint amountB, uint liquidity) {
406         (amountA, amountB) = _addLiquidity(tokenA, tokenB, amountADesired, amountBDesired, amountAMin, amountBMin);
407         address pair = UniswapV2Library.pairFor(factory, tokenA, tokenB);
408         TransferHelper.safeTransferFrom(tokenA, msg.sender, pair, amountA);
409         TransferHelper.safeTransferFrom(tokenB, msg.sender, pair, amountB);
410         liquidity = IUniswapV2Pair(pair).mint(to);
411     }
412     function addLiquidityETH(
413         address token,
414         uint amountTokenDesired,
415         uint amountTokenMin,
416         uint amountETHMin,
417         address to,
418         uint deadline
419     ) external virtual override payable ensure(deadline) returns (uint amountToken, uint amountETH, uint liquidity) {
420         (amountToken, amountETH) = _addLiquidity(
421             token,
422             WETH,
423             amountTokenDesired,
424             msg.value,
425             amountTokenMin,
426             amountETHMin
427         );
428         address pair = UniswapV2Library.pairFor(factory, token, WETH);
429         TransferHelper.safeTransferFrom(token, msg.sender, pair, amountToken);
430         IWETH(WETH).deposit{value: amountETH}();
431         assert(IWETH(WETH).transfer(pair, amountETH));
432         liquidity = IUniswapV2Pair(pair).mint(to);
433         // refund dust eth, if any
434         if (msg.value > amountETH) TransferHelper.safeTransferETH(msg.sender, msg.value - amountETH);
435     }
436     
437     // **** REMOVE LIQUIDITY ****
438     function removeLiquidity(
439         address tokenA,
440         address tokenB,
441         uint liquidity,
442         uint amountAMin,
443         uint amountBMin,
444         address to,
445         uint deadline
446     ) public virtual override ensure(deadline) returns (uint amountA, uint amountB) {
447         address pair = UniswapV2Library.pairFor(factory, tokenA, tokenB);
448         IUniswapV2Pair(pair).transferFrom(msg.sender, pair, liquidity); // send liquidity to pair
449         (uint amount0, uint amount1) = IUniswapV2Pair(pair).burn(to);
450         (address token0,) = UniswapV2Library.sortTokens(tokenA, tokenB);
451         (amountA, amountB) = tokenA == token0 ? (amount0, amount1) : (amount1, amount0);
452         require(amountA >= amountAMin, 'UniswapV2Router: INSUFFICIENT_A_AMOUNT');
453         require(amountB >= amountBMin, 'UniswapV2Router: INSUFFICIENT_B_AMOUNT');
454     }
455     function removeLiquidityETH(
456         address token,
457         uint liquidity,
458         uint amountTokenMin,
459         uint amountETHMin,
460         address to,
461         uint deadline
462     ) public virtual override ensure(deadline) returns (uint amountToken, uint amountETH) {
463         (amountToken, amountETH) = removeLiquidity(
464             token,
465             WETH,
466             liquidity,
467             amountTokenMin,
468             amountETHMin,
469             address(this),
470             deadline
471         );
472         TransferHelper.safeTransfer(token, to, amountToken);
473         IWETH(WETH).withdraw(amountETH);
474         TransferHelper.safeTransferETH(to, amountETH);
475     }
476     function removeLiquidityWithPermit(
477         address tokenA,
478         address tokenB,
479         uint liquidity,
480         uint amountAMin,
481         uint amountBMin,
482         address to,
483         uint deadline,
484         bool approveMax, uint8 v, bytes32 r, bytes32 s
485     ) external virtual override returns (uint amountA, uint amountB) {
486         address pair = UniswapV2Library.pairFor(factory, tokenA, tokenB);
487         uint value = approveMax ? uint(-1) : liquidity;
488         IUniswapV2Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
489         (amountA, amountB) = removeLiquidity(tokenA, tokenB, liquidity, amountAMin, amountBMin, to, deadline);
490     }
491     function removeLiquidityETHWithPermit(
492         address token,
493         uint liquidity,
494         uint amountTokenMin,
495         uint amountETHMin,
496         address to,
497         uint deadline,
498         bool approveMax, uint8 v, bytes32 r, bytes32 s
499     ) external virtual override returns (uint amountToken, uint amountETH) {
500         address pair = UniswapV2Library.pairFor(factory, token, WETH);
501         uint value = approveMax ? uint(-1) : liquidity;
502         IUniswapV2Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
503         (amountToken, amountETH) = removeLiquidityETH(token, liquidity, amountTokenMin, amountETHMin, to, deadline);
504     }
505 
506     // **** REMOVE LIQUIDITY (supporting fee-on-transfer tokens) ****
507     function removeLiquidityETHSupportingFeeOnTransferTokens(
508         address token,
509         uint liquidity,
510         uint amountTokenMin,
511         uint amountETHMin,
512         address to,
513         uint deadline
514     ) public virtual override ensure(deadline) returns (uint amountETH) {
515         (, amountETH) = removeLiquidity(
516             token,
517             WETH,
518             liquidity,
519             amountTokenMin,
520             amountETHMin,
521             address(this),
522             deadline
523         );
524         TransferHelper.safeTransfer(token, to, IERC20Uniswap(token).balanceOf(address(this)));
525         IWETH(WETH).withdraw(amountETH);
526         TransferHelper.safeTransferETH(to, amountETH);
527     }
528     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
529         address token,
530         uint liquidity,
531         uint amountTokenMin,
532         uint amountETHMin,
533         address to,
534         uint deadline,
535         bool approveMax, uint8 v, bytes32 r, bytes32 s
536     ) external virtual override returns (uint amountETH) {
537         address pair = UniswapV2Library.pairFor(factory, token, WETH);
538         uint value = approveMax ? uint(-1) : liquidity;
539         IUniswapV2Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
540         amountETH = removeLiquidityETHSupportingFeeOnTransferTokens(
541             token, liquidity, amountTokenMin, amountETHMin, to, deadline
542         );
543     }
544 
545     // **** SWAP ****
546     // requires the initial amount to have already been sent to the first pair
547     function _swap(uint[] memory amounts, address[] memory path, address _to) internal virtual {
548         for (uint i; i < path.length - 1; i++) {
549             (address input, address output) = (path[i], path[i + 1]);
550             (address token0,) = UniswapV2Library.sortTokens(input, output);
551             uint amountOut = amounts[i + 1];
552             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOut) : (amountOut, uint(0));
553             address to = i < path.length - 2 ? UniswapV2Library.pairFor(factory, output, path[i + 2]) : _to;
554             IUniswapV2Pair(UniswapV2Library.pairFor(factory, input, output)).swap(
555                 amount0Out, amount1Out, to, new bytes(0)
556             );
557         }
558     }
559     function swapExactTokensForTokens(
560         uint amountIn,
561         uint amountOutMin,
562         address[] calldata path,
563         address to,
564         uint deadline
565     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
566         amounts = UniswapV2Library.getAmountsOut(factory, amountIn, path);
567         require(amounts[amounts.length - 1] >= amountOutMin, 'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
568         TransferHelper.safeTransferFrom(
569             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
570         );
571         _swap(amounts, path, to);
572     }
573     function swapTokensForExactTokens(
574         uint amountOut,
575         uint amountInMax,
576         address[] calldata path,
577         address to,
578         uint deadline
579     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
580         amounts = UniswapV2Library.getAmountsIn(factory, amountOut, path);
581         require(amounts[0] <= amountInMax, 'UniswapV2Router: EXCESSIVE_INPUT_AMOUNT');
582         TransferHelper.safeTransferFrom(
583             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
584         );
585         _swap(amounts, path, to);
586     }
587     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
588         external
589         virtual
590         override
591         payable
592         ensure(deadline)
593         returns (uint[] memory amounts)
594     {
595         require(path[0] == WETH, 'UniswapV2Router: INVALID_PATH');
596         amounts = UniswapV2Library.getAmountsOut(factory, msg.value, path);
597         require(amounts[amounts.length - 1] >= amountOutMin, 'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
598         IWETH(WETH).deposit{value: amounts[0]}();
599         assert(IWETH(WETH).transfer(UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]));
600         _swap(amounts, path, to);
601     }
602     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
603         external
604         virtual
605         override
606         ensure(deadline)
607         returns (uint[] memory amounts)
608     {
609         require(path[path.length - 1] == WETH, 'UniswapV2Router: INVALID_PATH');
610         amounts = UniswapV2Library.getAmountsIn(factory, amountOut, path);
611         require(amounts[0] <= amountInMax, 'UniswapV2Router: EXCESSIVE_INPUT_AMOUNT');
612         TransferHelper.safeTransferFrom(
613             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
614         );
615         _swap(amounts, path, address(this));
616         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
617         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
618     }
619     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
620         external
621         virtual
622         override
623         ensure(deadline)
624         returns (uint[] memory amounts)
625     {
626         require(path[path.length - 1] == WETH, 'UniswapV2Router: INVALID_PATH');
627         amounts = UniswapV2Library.getAmountsOut(factory, amountIn, path);
628         require(amounts[amounts.length - 1] >= amountOutMin, 'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
629         TransferHelper.safeTransferFrom(
630             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
631         );
632         _swap(amounts, path, address(this));
633         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
634         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
635     }
636     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
637         external
638         virtual
639         override
640         payable
641         ensure(deadline)
642         returns (uint[] memory amounts)
643     {
644         require(path[0] == WETH, 'UniswapV2Router: INVALID_PATH');
645         amounts = UniswapV2Library.getAmountsIn(factory, amountOut, path);
646         require(amounts[0] <= msg.value, 'UniswapV2Router: EXCESSIVE_INPUT_AMOUNT');
647         IWETH(WETH).deposit{value: amounts[0]}();
648         assert(IWETH(WETH).transfer(UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]));
649         _swap(amounts, path, to);
650         // refund dust eth, if any
651         if (msg.value > amounts[0]) TransferHelper.safeTransferETH(msg.sender, msg.value - amounts[0]);
652     }
653 
654     // **** SWAP (supporting fee-on-transfer tokens) ****
655     // requires the initial amount to have already been sent to the first pair
656     function _swapSupportingFeeOnTransferTokens(address[] memory path, address _to) internal virtual {
657         for (uint i; i < path.length - 1; i++) {
658             (address input, address output) = (path[i], path[i + 1]);
659             (address token0,) = UniswapV2Library.sortTokens(input, output);
660             IUniswapV2Pair pair = IUniswapV2Pair(UniswapV2Library.pairFor(factory, input, output));
661             uint amountInput;
662             uint amountOutput;
663             { // scope to avoid stack too deep errors
664             (uint reserve0, uint reserve1,) = pair.getReserves();
665             (uint reserveInput, uint reserveOutput) = input == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
666             amountInput = IERC20Uniswap(input).balanceOf(address(pair)).sub(reserveInput);
667             amountOutput = UniswapV2Library.getAmountOut(amountInput, reserveInput, reserveOutput);
668             }
669             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOutput) : (amountOutput, uint(0));
670             address to = i < path.length - 2 ? UniswapV2Library.pairFor(factory, output, path[i + 2]) : _to;
671             pair.swap(amount0Out, amount1Out, to, new bytes(0));
672         }
673     }
674     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
675         uint amountIn,
676         uint amountOutMin,
677         address[] calldata path,
678         address to,
679         uint deadline
680     ) external virtual override ensure(deadline) {
681         TransferHelper.safeTransferFrom(
682             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amountIn
683         );
684         uint balanceBefore = IERC20Uniswap(path[path.length - 1]).balanceOf(to);
685         _swapSupportingFeeOnTransferTokens(path, to);
686         require(
687             IERC20Uniswap(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
688             'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT'
689         );
690     }
691     function swapExactETHForTokensSupportingFeeOnTransferTokens(
692         uint amountOutMin,
693         address[] calldata path,
694         address to,
695         uint deadline
696     )
697         external
698         virtual
699         override
700         payable
701         ensure(deadline)
702     {
703         require(path[0] == WETH, 'UniswapV2Router: INVALID_PATH');
704         uint amountIn = msg.value;
705         IWETH(WETH).deposit{value: amountIn}();
706         assert(IWETH(WETH).transfer(UniswapV2Library.pairFor(factory, path[0], path[1]), amountIn));
707         uint balanceBefore = IERC20Uniswap(path[path.length - 1]).balanceOf(to);
708         _swapSupportingFeeOnTransferTokens(path, to);
709         require(
710             IERC20Uniswap(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
711             'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT'
712         );
713     }
714     function swapExactTokensForETHSupportingFeeOnTransferTokens(
715         uint amountIn,
716         uint amountOutMin,
717         address[] calldata path,
718         address to,
719         uint deadline
720     )
721         external
722         virtual
723         override
724         ensure(deadline)
725     {
726         require(path[path.length - 1] == WETH, 'UniswapV2Router: INVALID_PATH');
727         TransferHelper.safeTransferFrom(
728             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amountIn
729         );
730         _swapSupportingFeeOnTransferTokens(path, address(this));
731         uint amountOut = IERC20Uniswap(WETH).balanceOf(address(this));
732         require(amountOut >= amountOutMin, 'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
733         IWETH(WETH).withdraw(amountOut);
734         TransferHelper.safeTransferETH(to, amountOut);
735     }
736 
737     // **** LIBRARY FUNCTIONS ****
738     function quote(uint amountA, uint reserveA, uint reserveB) public pure virtual override returns (uint amountB) {
739         return UniswapV2Library.quote(amountA, reserveA, reserveB);
740     }
741 
742     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut)
743         public
744         pure
745         virtual
746         override
747         returns (uint amountOut)
748     {
749         return UniswapV2Library.getAmountOut(amountIn, reserveIn, reserveOut);
750     }
751 
752     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut)
753         public
754         pure
755         virtual
756         override
757         returns (uint amountIn)
758     {
759         return UniswapV2Library.getAmountIn(amountOut, reserveIn, reserveOut);
760     }
761 
762     function getAmountsOut(uint amountIn, address[] memory path)
763         public
764         view
765         virtual
766         override
767         returns (uint[] memory amounts)
768     {
769         return UniswapV2Library.getAmountsOut(factory, amountIn, path);
770     }
771 
772     function getAmountsIn(uint amountOut, address[] memory path)
773         public
774         view
775         virtual
776         override
777         returns (uint[] memory amounts)
778     {
779         return UniswapV2Library.getAmountsIn(factory, amountOut, path);
780     }
781 }