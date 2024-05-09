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
51 // File: @uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol
52 
53 pragma solidity >=0.5.0;
54 
55 interface IUniswapV2Pair {
56     event Approval(address indexed owner, address indexed spender, uint value);
57     event Transfer(address indexed from, address indexed to, uint value);
58 
59     function name() external pure returns (string memory);
60     function symbol() external pure returns (string memory);
61     function decimals() external pure returns (uint8);
62     function totalSupply() external view returns (uint);
63     function balanceOf(address owner) external view returns (uint);
64     function allowance(address owner, address spender) external view returns (uint);
65 
66     function approve(address spender, uint value) external returns (bool);
67     function transfer(address to, uint value) external returns (bool);
68     function transferFrom(address from, address to, uint value) external returns (bool);
69 
70     function DOMAIN_SEPARATOR() external view returns (bytes32);
71     function PERMIT_TYPEHASH() external pure returns (bytes32);
72     function nonces(address owner) external view returns (uint);
73 
74     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
75 
76     event Mint(address indexed sender, uint amount0, uint amount1);
77     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
78     event Swap(
79         address indexed sender,
80         uint amount0In,
81         uint amount1In,
82         uint amount0Out,
83         uint amount1Out,
84         address indexed to
85     );
86     event Sync(uint112 reserve0, uint112 reserve1);
87 
88     function MINIMUM_LIQUIDITY() external pure returns (uint);
89     function factory() external view returns (address);
90     function token0() external view returns (address);
91     function token1() external view returns (address);
92     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
93     function price0CumulativeLast() external view returns (uint);
94     function price1CumulativeLast() external view returns (uint);
95     function kLast() external view returns (uint);
96 
97     function mint(address to) external returns (uint liquidity);
98     function burn(address to) external returns (uint amount0, uint amount1);
99     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
100     function skim(address to) external;
101     function sync() external;
102 
103     function initialize(address, address) external;
104 }
105 
106 // File: contracts/libraries/SafeMath.sol
107 
108 pragma solidity =0.6.6;
109 
110 // a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)
111 
112 library SafeMath {
113     function add(uint x, uint y) internal pure returns (uint z) {
114         require((z = x + y) >= x, 'ds-math-add-overflow');
115     }
116 
117     function sub(uint x, uint y) internal pure returns (uint z) {
118         require((z = x - y) <= x, 'ds-math-sub-underflow');
119     }
120 
121     function mul(uint x, uint y) internal pure returns (uint z) {
122         require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');
123     }
124 }
125 
126 // File: contracts/libraries/UniswapV2Library.sol
127 
128 pragma solidity >=0.5.0;
129 
130 
131 
132 library UniswapV2Library {
133     using SafeMath for uint;
134 
135     // returns sorted token addresses, used to handle return values from pairs sorted in this order
136     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
137         require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');
138         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
139         require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');
140     }
141 
142     // calculates the CREATE2 address for a pair without making any external calls
143     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
144         (address token0, address token1) = sortTokens(tokenA, tokenB);
145         pair = address(uint(keccak256(abi.encodePacked(
146                 hex'ff',
147                 factory,
148                 keccak256(abi.encodePacked(token0, token1)),
149                 hex'96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f' // init code hash
150             ))));
151     }
152 
153     // fetches and sorts the reserves for a pair
154     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
155         (address token0,) = sortTokens(tokenA, tokenB);
156         (uint reserve0, uint reserve1,) = IUniswapV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();
157         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
158     }
159 
160     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
161     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
162         require(amountA > 0, 'UniswapV2Library: INSUFFICIENT_AMOUNT');
163         require(reserveA > 0 && reserveB > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
164         amountB = amountA.mul(reserveB) / reserveA;
165     }
166 
167     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
168     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
169         require(amountIn > 0, 'UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT');
170         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
171         uint amountInWithFee = amountIn.mul(997);
172         uint numerator = amountInWithFee.mul(reserveOut);
173         uint denominator = reserveIn.mul(1000).add(amountInWithFee);
174         amountOut = numerator / denominator;
175     }
176 
177     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
178     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {
179         require(amountOut > 0, 'UniswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT');
180         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
181         uint numerator = reserveIn.mul(amountOut).mul(1000);
182         uint denominator = reserveOut.sub(amountOut).mul(997);
183         amountIn = (numerator / denominator).add(1);
184     }
185 
186     // performs chained getAmountOut calculations on any number of pairs
187     function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {
188         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
189         amounts = new uint[](path.length);
190         amounts[0] = amountIn;
191         for (uint i; i < path.length - 1; i++) {
192             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);
193             amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
194         }
195     }
196 
197     // performs chained getAmountIn calculations on any number of pairs
198     function getAmountsIn(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {
199         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
200         amounts = new uint[](path.length);
201         amounts[amounts.length - 1] = amountOut;
202         for (uint i = path.length - 1; i > 0; i--) {
203             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);
204             amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
205         }
206     }
207 }
208 
209 // File: contracts/interfaces/IUniswapV2Router01.sol
210 
211 pragma solidity >=0.6.2;
212 
213 interface IUniswapV2Router01 {
214     function factory() external pure returns (address);
215     function WETH() external pure returns (address);
216 
217     function addLiquidity(
218         address tokenA,
219         address tokenB,
220         uint amountADesired,
221         uint amountBDesired,
222         uint amountAMin,
223         uint amountBMin,
224         address to,
225         uint deadline
226     ) external returns (uint amountA, uint amountB, uint liquidity);
227     function addLiquidityETH(
228         address token,
229         uint amountTokenDesired,
230         uint amountTokenMin,
231         uint amountETHMin,
232         address to,
233         uint deadline
234     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
235     function removeLiquidity(
236         address tokenA,
237         address tokenB,
238         uint liquidity,
239         uint amountAMin,
240         uint amountBMin,
241         address to,
242         uint deadline
243     ) external returns (uint amountA, uint amountB);
244     function removeLiquidityETH(
245         address token,
246         uint liquidity,
247         uint amountTokenMin,
248         uint amountETHMin,
249         address to,
250         uint deadline
251     ) external returns (uint amountToken, uint amountETH);
252     function removeLiquidityWithPermit(
253         address tokenA,
254         address tokenB,
255         uint liquidity,
256         uint amountAMin,
257         uint amountBMin,
258         address to,
259         uint deadline,
260         bool approveMax, uint8 v, bytes32 r, bytes32 s
261     ) external returns (uint amountA, uint amountB);
262     function removeLiquidityETHWithPermit(
263         address token,
264         uint liquidity,
265         uint amountTokenMin,
266         uint amountETHMin,
267         address to,
268         uint deadline,
269         bool approveMax, uint8 v, bytes32 r, bytes32 s
270     ) external returns (uint amountToken, uint amountETH);
271     function swapExactTokensForTokens(
272         uint amountIn,
273         uint amountOutMin,
274         address[] calldata path,
275         address to,
276         uint deadline
277     ) external returns (uint[] memory amounts);
278     function swapTokensForExactTokens(
279         uint amountOut,
280         uint amountInMax,
281         address[] calldata path,
282         address to,
283         uint deadline
284     ) external returns (uint[] memory amounts);
285     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
286         external
287         payable
288         returns (uint[] memory amounts);
289     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
290         external
291         returns (uint[] memory amounts);
292     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
293         external
294         returns (uint[] memory amounts);
295     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
296         external
297         payable
298         returns (uint[] memory amounts);
299 
300     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
301     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
302     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
303     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
304     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
305 }
306 
307 // File: contracts/interfaces/IERC20.sol
308 
309 pragma solidity >=0.5.0;
310 
311 interface IERC20 {
312     event Approval(address indexed owner, address indexed spender, uint value);
313     event Transfer(address indexed from, address indexed to, uint value);
314 
315     function name() external view returns (string memory);
316     function symbol() external view returns (string memory);
317     function decimals() external view returns (uint8);
318     function totalSupply() external view returns (uint);
319     function balanceOf(address owner) external view returns (uint);
320     function allowance(address owner, address spender) external view returns (uint);
321 
322     function approve(address spender, uint value) external returns (bool);
323     function transfer(address to, uint value) external returns (bool);
324     function transferFrom(address from, address to, uint value) external returns (bool);
325 }
326 
327 // File: contracts/interfaces/IWETH.sol
328 
329 pragma solidity >=0.5.0;
330 
331 interface IWETH {
332     function deposit() external payable;
333     function transfer(address to, uint value) external returns (bool);
334     function withdraw(uint) external;
335 }
336 
337 // File: contracts/UniswapV2Router01.sol
338 
339 pragma solidity =0.6.6;
340 
341 
342 
343 
344 
345 
346 
347 contract UniswapV2Router01 is IUniswapV2Router01 {
348     address public immutable override factory;
349     address public immutable override WETH;
350 
351     modifier ensure(uint deadline) {
352         require(deadline >= block.timestamp, 'UniswapV2Router: EXPIRED');
353         _;
354     }
355 
356     constructor(address _factory, address _WETH) public {
357         factory = _factory;
358         WETH = _WETH;
359     }
360 
361     receive() external payable {
362         assert(msg.sender == WETH); // only accept ETH via fallback from the WETH contract
363     }
364 
365     // **** ADD LIQUIDITY ****
366     function _addLiquidity(
367         address tokenA,
368         address tokenB,
369         uint amountADesired,
370         uint amountBDesired,
371         uint amountAMin,
372         uint amountBMin
373     ) private returns (uint amountA, uint amountB) {
374         // create the pair if it doesn't exist yet
375         if (IUniswapV2Factory(factory).getPair(tokenA, tokenB) == address(0)) {
376             IUniswapV2Factory(factory).createPair(tokenA, tokenB);
377         }
378         (uint reserveA, uint reserveB) = UniswapV2Library.getReserves(factory, tokenA, tokenB);
379         if (reserveA == 0 && reserveB == 0) {
380             (amountA, amountB) = (amountADesired, amountBDesired);
381         } else {
382             uint amountBOptimal = UniswapV2Library.quote(amountADesired, reserveA, reserveB);
383             if (amountBOptimal <= amountBDesired) {
384                 require(amountBOptimal >= amountBMin, 'UniswapV2Router: INSUFFICIENT_B_AMOUNT');
385                 (amountA, amountB) = (amountADesired, amountBOptimal);
386             } else {
387                 uint amountAOptimal = UniswapV2Library.quote(amountBDesired, reserveB, reserveA);
388                 assert(amountAOptimal <= amountADesired);
389                 require(amountAOptimal >= amountAMin, 'UniswapV2Router: INSUFFICIENT_A_AMOUNT');
390                 (amountA, amountB) = (amountAOptimal, amountBDesired);
391             }
392         }
393     }
394     function addLiquidity(
395         address tokenA,
396         address tokenB,
397         uint amountADesired,
398         uint amountBDesired,
399         uint amountAMin,
400         uint amountBMin,
401         address to,
402         uint deadline
403     ) external override ensure(deadline) returns (uint amountA, uint amountB, uint liquidity) {
404         (amountA, amountB) = _addLiquidity(tokenA, tokenB, amountADesired, amountBDesired, amountAMin, amountBMin);
405         address pair = UniswapV2Library.pairFor(factory, tokenA, tokenB);
406         TransferHelper.safeTransferFrom(tokenA, msg.sender, pair, amountA);
407         TransferHelper.safeTransferFrom(tokenB, msg.sender, pair, amountB);
408         liquidity = IUniswapV2Pair(pair).mint(to);
409     }
410     function addLiquidityETH(
411         address token,
412         uint amountTokenDesired,
413         uint amountTokenMin,
414         uint amountETHMin,
415         address to,
416         uint deadline
417     ) external override payable ensure(deadline) returns (uint amountToken, uint amountETH, uint liquidity) {
418         (amountToken, amountETH) = _addLiquidity(
419             token,
420             WETH,
421             amountTokenDesired,
422             msg.value,
423             amountTokenMin,
424             amountETHMin
425         );
426         address pair = UniswapV2Library.pairFor(factory, token, WETH);
427         TransferHelper.safeTransferFrom(token, msg.sender, pair, amountToken);
428         IWETH(WETH).deposit{value: amountETH}();
429         assert(IWETH(WETH).transfer(pair, amountETH));
430         liquidity = IUniswapV2Pair(pair).mint(to);
431         if (msg.value > amountETH) TransferHelper.safeTransferETH(msg.sender, msg.value - amountETH); // refund dust eth, if any
432     }
433 
434     // **** REMOVE LIQUIDITY ****
435     function removeLiquidity(
436         address tokenA,
437         address tokenB,
438         uint liquidity,
439         uint amountAMin,
440         uint amountBMin,
441         address to,
442         uint deadline
443     ) public override ensure(deadline) returns (uint amountA, uint amountB) {
444         address pair = UniswapV2Library.pairFor(factory, tokenA, tokenB);
445         IUniswapV2Pair(pair).transferFrom(msg.sender, pair, liquidity); // send liquidity to pair
446         (uint amount0, uint amount1) = IUniswapV2Pair(pair).burn(to);
447         (address token0,) = UniswapV2Library.sortTokens(tokenA, tokenB);
448         (amountA, amountB) = tokenA == token0 ? (amount0, amount1) : (amount1, amount0);
449         require(amountA >= amountAMin, 'UniswapV2Router: INSUFFICIENT_A_AMOUNT');
450         require(amountB >= amountBMin, 'UniswapV2Router: INSUFFICIENT_B_AMOUNT');
451     }
452     function removeLiquidityETH(
453         address token,
454         uint liquidity,
455         uint amountTokenMin,
456         uint amountETHMin,
457         address to,
458         uint deadline
459     ) public override ensure(deadline) returns (uint amountToken, uint amountETH) {
460         (amountToken, amountETH) = removeLiquidity(
461             token,
462             WETH,
463             liquidity,
464             amountTokenMin,
465             amountETHMin,
466             address(this),
467             deadline
468         );
469         TransferHelper.safeTransfer(token, to, amountToken);
470         IWETH(WETH).withdraw(amountETH);
471         TransferHelper.safeTransferETH(to, amountETH);
472     }
473     function removeLiquidityWithPermit(
474         address tokenA,
475         address tokenB,
476         uint liquidity,
477         uint amountAMin,
478         uint amountBMin,
479         address to,
480         uint deadline,
481         bool approveMax, uint8 v, bytes32 r, bytes32 s
482     ) external override returns (uint amountA, uint amountB) {
483         address pair = UniswapV2Library.pairFor(factory, tokenA, tokenB);
484         uint value = approveMax ? uint(-1) : liquidity;
485         IUniswapV2Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
486         (amountA, amountB) = removeLiquidity(tokenA, tokenB, liquidity, amountAMin, amountBMin, to, deadline);
487     }
488     function removeLiquidityETHWithPermit(
489         address token,
490         uint liquidity,
491         uint amountTokenMin,
492         uint amountETHMin,
493         address to,
494         uint deadline,
495         bool approveMax, uint8 v, bytes32 r, bytes32 s
496     ) external override returns (uint amountToken, uint amountETH) {
497         address pair = UniswapV2Library.pairFor(factory, token, WETH);
498         uint value = approveMax ? uint(-1) : liquidity;
499         IUniswapV2Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
500         (amountToken, amountETH) = removeLiquidityETH(token, liquidity, amountTokenMin, amountETHMin, to, deadline);
501     }
502 
503     // **** SWAP ****
504     // requires the initial amount to have already been sent to the first pair
505     function _swap(uint[] memory amounts, address[] memory path, address _to) private {
506         for (uint i; i < path.length - 1; i++) {
507             (address input, address output) = (path[i], path[i + 1]);
508             (address token0,) = UniswapV2Library.sortTokens(input, output);
509             uint amountOut = amounts[i + 1];
510             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOut) : (amountOut, uint(0));
511             address to = i < path.length - 2 ? UniswapV2Library.pairFor(factory, output, path[i + 2]) : _to;
512             IUniswapV2Pair(UniswapV2Library.pairFor(factory, input, output)).swap(amount0Out, amount1Out, to, new bytes(0));
513         }
514     }
515     function swapExactTokensForTokens(
516         uint amountIn,
517         uint amountOutMin,
518         address[] calldata path,
519         address to,
520         uint deadline
521     ) external override ensure(deadline) returns (uint[] memory amounts) {
522         amounts = UniswapV2Library.getAmountsOut(factory, amountIn, path);
523         require(amounts[amounts.length - 1] >= amountOutMin, 'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
524         TransferHelper.safeTransferFrom(path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]);
525         _swap(amounts, path, to);
526     }
527     function swapTokensForExactTokens(
528         uint amountOut,
529         uint amountInMax,
530         address[] calldata path,
531         address to,
532         uint deadline
533     ) external override ensure(deadline) returns (uint[] memory amounts) {
534         amounts = UniswapV2Library.getAmountsIn(factory, amountOut, path);
535         require(amounts[0] <= amountInMax, 'UniswapV2Router: EXCESSIVE_INPUT_AMOUNT');
536         TransferHelper.safeTransferFrom(path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]);
537         _swap(amounts, path, to);
538     }
539     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
540         external
541         override
542         payable
543         ensure(deadline)
544         returns (uint[] memory amounts)
545     {
546         require(path[0] == WETH, 'UniswapV2Router: INVALID_PATH');
547         amounts = UniswapV2Library.getAmountsOut(factory, msg.value, path);
548         require(amounts[amounts.length - 1] >= amountOutMin, 'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
549         IWETH(WETH).deposit{value: amounts[0]}();
550         assert(IWETH(WETH).transfer(UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]));
551         _swap(amounts, path, to);
552     }
553     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
554         external
555         override
556         ensure(deadline)
557         returns (uint[] memory amounts)
558     {
559         require(path[path.length - 1] == WETH, 'UniswapV2Router: INVALID_PATH');
560         amounts = UniswapV2Library.getAmountsIn(factory, amountOut, path);
561         require(amounts[0] <= amountInMax, 'UniswapV2Router: EXCESSIVE_INPUT_AMOUNT');
562         TransferHelper.safeTransferFrom(path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]);
563         _swap(amounts, path, address(this));
564         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
565         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
566     }
567     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
568         external
569         override
570         ensure(deadline)
571         returns (uint[] memory amounts)
572     {
573         require(path[path.length - 1] == WETH, 'UniswapV2Router: INVALID_PATH');
574         amounts = UniswapV2Library.getAmountsOut(factory, amountIn, path);
575         require(amounts[amounts.length - 1] >= amountOutMin, 'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
576         TransferHelper.safeTransferFrom(path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]);
577         _swap(amounts, path, address(this));
578         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
579         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
580     }
581     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
582         external
583         override
584         payable
585         ensure(deadline)
586         returns (uint[] memory amounts)
587     {
588         require(path[0] == WETH, 'UniswapV2Router: INVALID_PATH');
589         amounts = UniswapV2Library.getAmountsIn(factory, amountOut, path);
590         require(amounts[0] <= msg.value, 'UniswapV2Router: EXCESSIVE_INPUT_AMOUNT');
591         IWETH(WETH).deposit{value: amounts[0]}();
592         assert(IWETH(WETH).transfer(UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]));
593         _swap(amounts, path, to);
594         if (msg.value > amounts[0]) TransferHelper.safeTransferETH(msg.sender, msg.value - amounts[0]); // refund dust eth, if any
595     }
596 
597     function quote(uint amountA, uint reserveA, uint reserveB) public pure override returns (uint amountB) {
598         return UniswapV2Library.quote(amountA, reserveA, reserveB);
599     }
600 
601     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) public pure override returns (uint amountOut) {
602         return UniswapV2Library.getAmountOut(amountIn, reserveIn, reserveOut);
603     }
604 
605     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) public pure override returns (uint amountIn) {
606         return UniswapV2Library.getAmountOut(amountOut, reserveIn, reserveOut);
607     }
608 
609     function getAmountsOut(uint amountIn, address[] memory path) public view override returns (uint[] memory amounts) {
610         return UniswapV2Library.getAmountsOut(factory, amountIn, path);
611     }
612 
613     function getAmountsIn(uint amountOut, address[] memory path) public view override returns (uint[] memory amounts) {
614         return UniswapV2Library.getAmountsIn(factory, amountOut, path);
615     }
616 }