1 pragma solidity =0.7.6;
2 
3 interface INimbusFactory {
4     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
5 
6     function feeTo() external view returns (address);
7     function feeToSetter() external view returns (address);
8 
9     function getPair(address tokenA, address tokenB) external view returns (address pair);
10     function allPairs(uint) external view returns (address pair);
11     function allPairsLength() external view returns (uint);
12 
13     function createPair(address tokenA, address tokenB) external returns (address pair);
14 
15     function setFeeTo(address) external;
16     function setFeeToSetter(address) external;
17 }
18 
19 library TransferHelper {
20     function safeApprove(address token, address to, uint value) internal {
21         // bytes4(keccak256(bytes('approve(address,uint256)')));
22         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
23         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
24     }
25 
26     function safeTransfer(address token, address to, uint value) internal {
27         // bytes4(keccak256(bytes('transfer(address,uint256)')));
28         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
29         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
30     }
31 
32     function safeTransferFrom(address token, address from, address to, uint value) internal {
33         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
34         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
35         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
36     }
37 
38     function safeTransferETH(address to, uint value) internal {
39         (bool success,) = to.call{value:value}(new bytes(0));
40         require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
41     }
42 }
43 
44 interface INimbusRouter01 {
45     function factory() external view returns (address);
46     function NUS_WETH() external view returns (address);
47 
48     function addLiquidity(
49         address tokenA,
50         address tokenB,
51         uint amountADesired,
52         uint amountBDesired,
53         uint amountAMin,
54         uint amountBMin,
55         address to,
56         uint deadline
57     ) external returns (uint amountA, uint amountB, uint liquidity);
58     function addLiquidityETH(
59         address token,
60         uint amountTokenDesired,
61         uint amountTokenMin,
62         uint amountETHMin,
63         address to,
64         uint deadline
65     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
66     function removeLiquidity(
67         address tokenA,
68         address tokenB,
69         uint liquidity,
70         uint amountAMin,
71         uint amountBMin,
72         address to,
73         uint deadline
74     ) external returns (uint amountA, uint amountB);
75     function removeLiquidityETH(
76         address token,
77         uint liquidity,
78         uint amountTokenMin,
79         uint amountETHMin,
80         address to,
81         uint deadline
82     ) external returns (uint amountToken, uint amountETH);
83     function removeLiquidityWithPermit(
84         address tokenA,
85         address tokenB,
86         uint liquidity,
87         uint amountAMin,
88         uint amountBMin,
89         address to,
90         uint deadline,
91         bool approveMax, uint8 v, bytes32 r, bytes32 s
92     ) external returns (uint amountA, uint amountB);
93     function removeLiquidityETHWithPermit(
94         address token,
95         uint liquidity,
96         uint amountTokenMin,
97         uint amountETHMin,
98         address to,
99         uint deadline,
100         bool approveMax, uint8 v, bytes32 r, bytes32 s
101     ) external returns (uint amountToken, uint amountETH);
102     function swapExactTokensForTokens(
103         uint amountIn,
104         uint amountOutMin,
105         address[] calldata path,
106         address to,
107         uint deadline
108     ) external returns (uint[] memory amounts);
109     function swapTokensForExactTokens(
110         uint amountOut,
111         uint amountInMax,
112         address[] calldata path,
113         address to,
114         uint deadline
115     ) external returns (uint[] memory amounts);
116     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
117         external
118         payable
119         returns (uint[] memory amounts);
120     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
121         external
122         returns (uint[] memory amounts);
123     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
124         external
125         returns (uint[] memory amounts);
126     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
127         external
128         payable
129         returns (uint[] memory amounts);
130 
131     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
132     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
133     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
134     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
135     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
136 }
137 
138 interface INimbusRouter is INimbusRouter01 {
139     function removeLiquidityETHSupportingFeeOnTransferTokens(
140         address token,
141         uint liquidity,
142         uint amountTokenMin,
143         uint amountETHMin,
144         address to,
145         uint deadline
146     ) external returns (uint amountETH);
147     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
148         address token,
149         uint liquidity,
150         uint amountTokenMin,
151         uint amountETHMin,
152         address to,
153         uint deadline,
154         bool approveMax, uint8 v, bytes32 r, bytes32 s
155     ) external returns (uint amountETH);
156 
157     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
158         uint amountIn,
159         uint amountOutMin,
160         address[] calldata path,
161         address to,
162         uint deadline
163     ) external;
164     function swapExactETHForTokensSupportingFeeOnTransferTokens(
165         uint amountOutMin,
166         address[] calldata path,
167         address to,
168         uint deadline
169     ) external payable;
170     function swapExactTokensForETHSupportingFeeOnTransferTokens(
171         uint amountIn,
172         uint amountOutMin,
173         address[] calldata path,
174         address to,
175         uint deadline
176     ) external;
177 }
178 
179 interface INimbusPair {
180     event Approval(address indexed owner, address indexed spender, uint value);
181     event Transfer(address indexed from, address indexed to, uint value);
182 
183     function name() external pure returns (string memory);
184     function symbol() external pure returns (string memory);
185     function decimals() external pure returns (uint8);
186     function totalSupply() external view returns (uint);
187     function balanceOf(address owner) external view returns (uint);
188     function allowance(address owner, address spender) external view returns (uint);
189 
190     function approve(address spender, uint value) external returns (bool);
191     function transfer(address to, uint value) external returns (bool);
192     function transferFrom(address from, address to, uint value) external returns (bool);
193 
194     function DOMAIN_SEPARATOR() external view returns (bytes32);
195     function PERMIT_TYPEHASH() external pure returns (bytes32);
196     function nonces(address owner) external view returns (uint);
197 
198     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
199 
200     event Mint(address indexed sender, uint amount0, uint amount1);
201     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
202     event Swap(
203         address indexed sender,
204         uint amount0In,
205         uint amount1In,
206         uint amount0Out,
207         uint amount1Out,
208         address indexed to
209     );
210     event Sync(uint112 reserve0, uint112 reserve1);
211 
212     function MINIMUM_LIQUIDITY() external pure returns (uint);
213     function factory() external view returns (address);
214     function token0() external view returns (address);
215     function token1() external view returns (address);
216     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
217     function price0CumulativeLast() external view returns (uint);
218     function price1CumulativeLast() external view returns (uint);
219     function kLast() external view returns (uint);
220 
221     function mint(address to) external returns (uint liquidity);
222     function burn(address to) external returns (uint amount0, uint amount1);
223     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
224     function skim(address to) external;
225     function sync() external;
226 
227     function initialize(address, address) external;
228 }
229 
230 library NimbusLibrary {
231     using SafeMath for uint;
232 
233     // returns sorted token addresses, used to handle return values from pairs sorted in this order
234     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
235         require(tokenA != tokenB, 'NimbusLibrary: IDENTICAL_ADDRESSES');
236         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
237         require(token0 != address(0), 'NimbusLibrary: ZERO_ADDRESS');
238     }
239 
240     // calculates the CREATE2 address for a pair without making any external calls
241     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
242         (address token0, address token1) = sortTokens(tokenA, tokenB);
243         pair = address(uint(keccak256(abi.encodePacked(
244                 hex'ff',
245                 factory,
246                 keccak256(abi.encodePacked(token0, token1)),
247                 hex'9caea71a4e9798d7bbdf720c7f8b2d9b63e1f0522376b899ba0c8f6c9737c731' // init code hash
248             ))));
249     }
250 
251     // fetches and sorts the reserves for a pair
252     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
253         (address token0,) = sortTokens(tokenA, tokenB);
254         (uint reserve0, uint reserve1,) = INimbusPair(pairFor(factory, tokenA, tokenB)).getReserves();
255         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
256     }
257 
258     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
259     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
260         require(amountA > 0, 'NimbusLibrary: INSUFFICIENT_AMOUNT');
261         require(reserveA > 0 && reserveB > 0, 'NimbusLibrary: INSUFFICIENT_LIQUIDITY');
262         amountB = amountA.mul(reserveB) / reserveA;
263     }
264 
265     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
266     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
267         require(amountIn > 0, 'NimbusLibrary: INSUFFICIENT_INPUT_AMOUNT');
268         require(reserveIn > 0 && reserveOut > 0, 'NimbusLibrary: INSUFFICIENT_LIQUIDITY');
269         uint amountInWithFee = amountIn.mul(997);
270         uint numerator = amountInWithFee.mul(reserveOut);
271         uint denominator = reserveIn.mul(1000).add(amountInWithFee);
272         amountOut = numerator / denominator;
273     }
274 
275     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
276     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {
277         require(amountOut > 0, 'NimbusLibrary: INSUFFICIENT_OUTPUT_AMOUNT');
278         require(reserveIn > 0 && reserveOut > 0, 'NimbusLibrary: INSUFFICIENT_LIQUIDITY');
279         uint numerator = reserveIn.mul(amountOut).mul(1000);
280         uint denominator = reserveOut.sub(amountOut).mul(997);
281         amountIn = (numerator / denominator).add(1);
282     }
283 
284     // performs chained getAmountOut calculations on any number of pairs
285     function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {
286         require(path.length >= 2, 'NimbusLibrary: INVALID_PATH');
287         amounts = new uint[](path.length);
288         amounts[0] = amountIn;
289         for (uint i; i < path.length - 1; i++) {
290             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);
291             amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
292         }
293     }
294 
295     // performs chained getAmountIn calculations on any number of pairs
296     function getAmountsIn(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {
297         require(path.length >= 2, 'NimbusLibrary: INVALID_PATH');
298         amounts = new uint[](path.length);
299         amounts[amounts.length - 1] = amountOut;
300         for (uint i = path.length - 1; i > 0; i--) {
301             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);
302             amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
303         }
304     }
305 }
306 
307 library SafeMath {
308     function add(uint x, uint y) internal pure returns (uint z) {
309         require((z = x + y) >= x, 'ds-math-add-overflow');
310     }
311 
312     function sub(uint x, uint y) internal pure returns (uint z) {
313         require((z = x - y) <= x, 'ds-math-sub-underflow');
314     }
315 
316     function mul(uint x, uint y) internal pure returns (uint z) {
317         require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');
318     }
319 }
320 
321 interface IERC20 {
322     event Approval(address indexed owner, address indexed spender, uint value);
323     event Transfer(address indexed from, address indexed to, uint value);
324 
325     function name() external view returns (string memory);
326     function symbol() external view returns (string memory);
327     function decimals() external view returns (uint8);
328     function totalSupply() external view returns (uint);
329     function balanceOf(address owner) external view returns (uint);
330     function allowance(address owner, address spender) external view returns (uint);
331 
332     function approve(address spender, uint value) external returns (bool);
333     function transfer(address to, uint value) external returns (bool);
334     function transferFrom(address from, address to, uint value) external returns (bool);
335 }
336 
337 interface INUS_WETH {
338     function deposit() external payable;
339     function transfer(address to, uint value) external returns (bool);
340     function withdraw(uint) external;
341 }
342 
343 interface ILPRewards {
344     function recordAddLiquidity(address user, address pair, uint amountA, uint amountB, uint liquidity) external;
345     function recordRemoveLiquidity(address user, address tokenA, address tokenB, uint amountA, uint amountB, uint liquidity) external;
346 }
347 
348 contract NimbusRouter is INimbusRouter {
349     using SafeMath for uint;
350 
351     address public immutable override factory;
352     address public immutable override NUS_WETH;
353     ILPRewards public lpRewards;
354 
355     modifier ensure(uint deadline) {
356         require(deadline >= block.timestamp, 'NimbusRouter: EXPIRED');
357         _;
358     }
359 
360     constructor(address _factory, address _NUS_WETH, address _lpRewards) {
361         factory = _factory;
362         NUS_WETH = _NUS_WETH;
363         lpRewards = ILPRewards(_lpRewards);
364     }
365 
366     receive() external payable {
367         assert(msg.sender == NUS_WETH); // only accept ETH via fallback from the NUS_WETH contract
368     }
369 
370     // **** ADD LIQUIDITY ****
371     function _addLiquidity(
372         address tokenA,
373         address tokenB,
374         uint amountADesired,
375         uint amountBDesired,
376         uint amountAMin,
377         uint amountBMin
378     ) internal virtual returns (uint amountA, uint amountB) {
379         // create the pair if it doesn't exist yet
380         if (INimbusFactory(factory).getPair(tokenA, tokenB) == address(0)) {
381             INimbusFactory(factory).createPair(tokenA, tokenB);
382         }
383         (uint reserveA, uint reserveB) = NimbusLibrary.getReserves(factory, tokenA, tokenB);
384         if (reserveA == 0 && reserveB == 0) {
385             (amountA, amountB) = (amountADesired, amountBDesired);
386         } else {
387             uint amountBOptimal = NimbusLibrary.quote(amountADesired, reserveA, reserveB);
388             if (amountBOptimal <= amountBDesired) {
389                 require(amountBOptimal >= amountBMin, 'NimbusRouter: INSUFFICIENT_B_AMOUNT');
390                 (amountA, amountB) = (amountADesired, amountBOptimal);
391             } else {
392                 uint amountAOptimal = NimbusLibrary.quote(amountBDesired, reserveB, reserveA);
393                 assert(amountAOptimal <= amountADesired);
394                 require(amountAOptimal >= amountAMin, 'NimbusRouter: INSUFFICIENT_A_AMOUNT');
395                 (amountA, amountB) = (amountAOptimal, amountBDesired);
396             }
397         }
398     }
399     function addLiquidity(
400         address tokenA,
401         address tokenB,
402         uint amountADesired,
403         uint amountBDesired,
404         uint amountAMin,
405         uint amountBMin,
406         address to,
407         uint deadline
408     ) external virtual override ensure(deadline) returns (uint amountA, uint amountB, uint liquidity) {
409         (amountA, amountB) = _addLiquidity(tokenA, tokenB, amountADesired, amountBDesired, amountAMin, amountBMin);
410         address pair = NimbusLibrary.pairFor(factory, tokenA, tokenB);
411         TransferHelper.safeTransferFrom(tokenA, msg.sender, pair, amountA);
412         TransferHelper.safeTransferFrom(tokenB, msg.sender, pair, amountB);
413         liquidity = INimbusPair(pair).mint(to);
414         lpRewards.recordAddLiquidity(to, pair, amountA, amountB, liquidity);
415     }
416     function addLiquidityETH(
417         address token,
418         uint amountTokenDesired,
419         uint amountTokenMin,
420         uint amountETHMin,
421         address to,
422         uint deadline
423     ) external virtual override payable ensure(deadline) returns (uint amountToken, uint amountETH, uint liquidity) {
424         (amountToken, amountETH) = _addLiquidity(
425             token,
426             NUS_WETH,
427             amountTokenDesired,
428             msg.value,
429             amountTokenMin,
430             amountETHMin
431         );
432         address pair = NimbusLibrary.pairFor(factory, token, NUS_WETH);
433         TransferHelper.safeTransferFrom(token, msg.sender, pair, amountToken);
434         INUS_WETH(NUS_WETH).deposit{value: amountETH}();
435         assert(INUS_WETH(NUS_WETH).transfer(pair, amountETH));
436         liquidity = INimbusPair(pair).mint(to);
437         // refund dust eth, if any
438         if (msg.value > amountETH) TransferHelper.safeTransferETH(msg.sender, msg.value - amountETH);
439         lpRewards.recordAddLiquidity(to, pair, amountETH, amountToken, liquidity);
440     }
441 
442     // **** REMOVE LIQUIDITY ****
443     function removeLiquidity(
444         address tokenA,
445         address tokenB,
446         uint liquidity,
447         uint amountAMin,
448         uint amountBMin,
449         address to,
450         uint deadline
451     ) public virtual override ensure(deadline) returns (uint amountA, uint amountB) {
452         {
453         address pair = NimbusLibrary.pairFor(factory, tokenA, tokenB);
454         INimbusPair(pair).transferFrom(msg.sender, pair, liquidity); // send liquidity to pair
455         (uint amount0, uint amount1) = INimbusPair(pair).burn(to);
456         (address token0,) = NimbusLibrary.sortTokens(tokenA, tokenB);
457         (amountA, amountB) = tokenA == token0 ? (amount0, amount1) : (amount1, amount0);
458         require(amountA >= amountAMin, 'NimbusRouter: INSUFFICIENT_A_AMOUNT');
459         require(amountB >= amountBMin, 'NimbusRouter: INSUFFICIENT_B_AMOUNT');
460         }
461         lpRewards.recordRemoveLiquidity(to, tokenA, tokenB, amountA, amountB, liquidity);
462     }
463     function removeLiquidityETH(
464         address token,
465         uint liquidity,
466         uint amountTokenMin,
467         uint amountETHMin,
468         address to,
469         uint deadline
470     ) public virtual override ensure(deadline) returns (uint amountToken, uint amountETH) {
471         (amountToken, amountETH) = removeLiquidity(
472             token,
473             NUS_WETH,
474             liquidity,
475             amountTokenMin,
476             amountETHMin,
477             address(this),
478             deadline
479         );
480         TransferHelper.safeTransfer(token, to, amountToken);
481         INUS_WETH(NUS_WETH).withdraw(amountETH);
482         TransferHelper.safeTransferETH(to, amountETH);
483     }
484     function removeLiquidityWithPermit(
485         address tokenA,
486         address tokenB,
487         uint liquidity,
488         uint amountAMin,
489         uint amountBMin,
490         address to,
491         uint deadline,
492         bool approveMax, uint8 v, bytes32 r, bytes32 s
493     ) external virtual override returns (uint amountA, uint amountB) {
494         address pair = NimbusLibrary.pairFor(factory, tokenA, tokenB);
495         uint value = approveMax ? uint(-1) : liquidity;
496         INimbusPair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
497         (amountA, amountB) = removeLiquidity(tokenA, tokenB, liquidity, amountAMin, amountBMin, to, deadline);
498     }
499     function removeLiquidityETHWithPermit(
500         address token,
501         uint liquidity,
502         uint amountTokenMin,
503         uint amountETHMin,
504         address to,
505         uint deadline,
506         bool approveMax, uint8 v, bytes32 r, bytes32 s
507     ) external virtual override returns (uint amountToken, uint amountETH) {
508         address pair = NimbusLibrary.pairFor(factory, token, NUS_WETH);
509         uint value = approveMax ? uint(-1) : liquidity;
510         INimbusPair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
511         (amountToken, amountETH) = removeLiquidityETH(token, liquidity, amountTokenMin, amountETHMin, to, deadline);
512     }
513 
514     // **** REMOVE LIQUIDITY (supporting fee-on-transfer tokens) ****
515     function removeLiquidityETHSupportingFeeOnTransferTokens(
516         address token,
517         uint liquidity,
518         uint amountTokenMin,
519         uint amountETHMin,
520         address to,
521         uint deadline
522     ) public virtual override ensure(deadline) returns (uint amountETH) {
523         (, amountETH) = removeLiquidity(
524             token,
525             NUS_WETH,
526             liquidity,
527             amountTokenMin,
528             amountETHMin,
529             address(this),
530             deadline
531         );
532         TransferHelper.safeTransfer(token, to, IERC20(token).balanceOf(address(this)));
533         INUS_WETH(NUS_WETH).withdraw(amountETH);
534         TransferHelper.safeTransferETH(to, amountETH);
535     }
536     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
537         address token,
538         uint liquidity,
539         uint amountTokenMin,
540         uint amountETHMin,
541         address to,
542         uint deadline,
543         bool approveMax, uint8 v, bytes32 r, bytes32 s
544     ) external virtual override returns (uint amountETH) {
545         address pair = NimbusLibrary.pairFor(factory, token, NUS_WETH);
546         uint value = approveMax ? uint(-1) : liquidity;
547         INimbusPair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
548         amountETH = removeLiquidityETHSupportingFeeOnTransferTokens(
549             token, liquidity, amountTokenMin, amountETHMin, to, deadline
550         );
551     }
552 
553     // **** SWAP ****
554     // requires the initial amount to have already been sent to the first pair
555     function _swap(uint[] memory amounts, address[] memory path, address _to) internal virtual {
556         for (uint i; i < path.length - 1; i++) {
557             (address input, address output) = (path[i], path[i + 1]);
558             (address token0,) = NimbusLibrary.sortTokens(input, output);
559             uint amountOut = amounts[i + 1];
560             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOut) : (amountOut, uint(0));
561             address to = i < path.length - 2 ? NimbusLibrary.pairFor(factory, output, path[i + 2]) : _to;
562             INimbusPair(NimbusLibrary.pairFor(factory, input, output)).swap(
563                 amount0Out, amount1Out, to, new bytes(0)
564             );
565         }
566     }
567     function swapExactTokensForTokens(
568         uint amountIn,
569         uint amountOutMin,
570         address[] calldata path,
571         address to,
572         uint deadline
573     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
574         amounts = NimbusLibrary.getAmountsOut(factory, amountIn, path);
575         require(amounts[amounts.length - 1] >= amountOutMin, 'NimbusRouter: INSUFFICIENT_OUTPUT_AMOUNT');
576         TransferHelper.safeTransferFrom(
577             path[0], msg.sender, NimbusLibrary.pairFor(factory, path[0], path[1]), amounts[0]
578         );
579         _swap(amounts, path, to);
580     }
581     function swapTokensForExactTokens(
582         uint amountOut,
583         uint amountInMax,
584         address[] calldata path,
585         address to,
586         uint deadline
587     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
588         amounts = NimbusLibrary.getAmountsIn(factory, amountOut, path);
589         require(amounts[0] <= amountInMax, 'NimbusRouter: EXCESSIVE_INPUT_AMOUNT');
590         TransferHelper.safeTransferFrom(
591             path[0], msg.sender, NimbusLibrary.pairFor(factory, path[0], path[1]), amounts[0]
592         );
593         _swap(amounts, path, to);
594     }
595     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
596         external
597         virtual
598         override
599         payable
600         ensure(deadline)
601         returns (uint[] memory amounts)
602     {
603         require(path[0] == NUS_WETH, 'NimbusRouter: INVALID_PATH');
604         amounts = NimbusLibrary.getAmountsOut(factory, msg.value, path);
605         require(amounts[amounts.length - 1] >= amountOutMin, 'NimbusRouter: INSUFFICIENT_OUTPUT_AMOUNT');
606         INUS_WETH(NUS_WETH).deposit{value: amounts[0]}();
607         assert(INUS_WETH(NUS_WETH).transfer(NimbusLibrary.pairFor(factory, path[0], path[1]), amounts[0]));
608         _swap(amounts, path, to);
609     }
610     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
611         external
612         virtual
613         override
614         ensure(deadline)
615         returns (uint[] memory amounts)
616     {
617         require(path[path.length - 1] == NUS_WETH, 'NimbusRouter: INVALID_PATH');
618         amounts = NimbusLibrary.getAmountsIn(factory, amountOut, path);
619         require(amounts[0] <= amountInMax, 'NimbusRouter: EXCESSIVE_INPUT_AMOUNT');
620         TransferHelper.safeTransferFrom(
621             path[0], msg.sender, NimbusLibrary.pairFor(factory, path[0], path[1]), amounts[0]
622         );
623         _swap(amounts, path, address(this));
624         INUS_WETH(NUS_WETH).withdraw(amounts[amounts.length - 1]);
625         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
626     }
627     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
628         external
629         virtual
630         override
631         ensure(deadline)
632         returns (uint[] memory amounts)
633     {
634         require(path[path.length - 1] == NUS_WETH, 'NimbusRouter: INVALID_PATH');
635         amounts = NimbusLibrary.getAmountsOut(factory, amountIn, path);
636         require(amounts[amounts.length - 1] >= amountOutMin, 'NimbusRouter: INSUFFICIENT_OUTPUT_AMOUNT');
637         TransferHelper.safeTransferFrom(
638             path[0], msg.sender, NimbusLibrary.pairFor(factory, path[0], path[1]), amounts[0]
639         );
640         _swap(amounts, path, address(this));
641         INUS_WETH(NUS_WETH).withdraw(amounts[amounts.length - 1]);
642         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
643     }
644     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
645         external
646         virtual
647         override
648         payable
649         ensure(deadline)
650         returns (uint[] memory amounts)
651     {
652         require(path[0] == NUS_WETH, 'NimbusRouter: INVALID_PATH');
653         amounts = NimbusLibrary.getAmountsIn(factory, amountOut, path);
654         require(amounts[0] <= msg.value, 'NimbusRouter: EXCESSIVE_INPUT_AMOUNT');
655         INUS_WETH(NUS_WETH).deposit{value: amounts[0]}();
656         assert(INUS_WETH(NUS_WETH).transfer(NimbusLibrary.pairFor(factory, path[0], path[1]), amounts[0]));
657         _swap(amounts, path, to);
658         // refund dust eth, if any
659         if (msg.value > amounts[0]) TransferHelper.safeTransferETH(msg.sender, msg.value - amounts[0]);
660     }
661 
662     // **** SWAP (supporting fee-on-transfer tokens) ****
663     // requires the initial amount to have already been sent to the first pair
664     function _swapSupportingFeeOnTransferTokens(address[] memory path, address _to) internal virtual {
665         for (uint i; i < path.length - 1; i++) {
666             (address input, address output) = (path[i], path[i + 1]);
667             (address token0,) = NimbusLibrary.sortTokens(input, output);
668             INimbusPair pair = INimbusPair(NimbusLibrary.pairFor(factory, input, output));
669             uint amountInput;
670             uint amountOutput;
671             { // scope to avoid stack too deep errors
672             (uint reserve0, uint reserve1,) = pair.getReserves();
673             (uint reserveInput, uint reserveOutput) = input == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
674             amountInput = IERC20(input).balanceOf(address(pair)).sub(reserveInput);
675             amountOutput = NimbusLibrary.getAmountOut(amountInput, reserveInput, reserveOutput);
676             }
677             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOutput) : (amountOutput, uint(0));
678             address to = i < path.length - 2 ? NimbusLibrary.pairFor(factory, output, path[i + 2]) : _to;
679             pair.swap(amount0Out, amount1Out, to, new bytes(0));
680         }
681     }
682     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
683         uint amountIn,
684         uint amountOutMin,
685         address[] calldata path,
686         address to,
687         uint deadline
688     ) external virtual override ensure(deadline) {
689         TransferHelper.safeTransferFrom(
690             path[0], msg.sender, NimbusLibrary.pairFor(factory, path[0], path[1]), amountIn
691         );
692         uint balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
693         _swapSupportingFeeOnTransferTokens(path, to);
694         require(
695             IERC20(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
696             'NimbusRouter: INSUFFICIENT_OUTPUT_AMOUNT'
697         );
698     }
699     function swapExactETHForTokensSupportingFeeOnTransferTokens(
700         uint amountOutMin,
701         address[] calldata path,
702         address to,
703         uint deadline
704     )
705         external
706         virtual
707         override
708         payable
709         ensure(deadline)
710     {
711         require(path[0] == NUS_WETH, 'NimbusRouter: INVALID_PATH');
712         uint amountIn = msg.value;
713         INUS_WETH(NUS_WETH).deposit{value: amountIn}();
714         assert(INUS_WETH(NUS_WETH).transfer(NimbusLibrary.pairFor(factory, path[0], path[1]), amountIn));
715         uint balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
716         _swapSupportingFeeOnTransferTokens(path, to);
717         require(
718             IERC20(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
719             'NimbusRouter: INSUFFICIENT_OUTPUT_AMOUNT'
720         );
721     }
722     function swapExactTokensForETHSupportingFeeOnTransferTokens(
723         uint amountIn,
724         uint amountOutMin,
725         address[] calldata path,
726         address to,
727         uint deadline
728     )
729         external
730         virtual
731         override
732         ensure(deadline)
733     {
734         require(path[path.length - 1] == NUS_WETH, 'NimbusRouter: INVALID_PATH');
735         TransferHelper.safeTransferFrom(
736             path[0], msg.sender, NimbusLibrary.pairFor(factory, path[0], path[1]), amountIn
737         );
738         _swapSupportingFeeOnTransferTokens(path, address(this));
739         uint amountOut = IERC20(NUS_WETH).balanceOf(address(this));
740         require(amountOut >= amountOutMin, 'NimbusRouter: INSUFFICIENT_OUTPUT_AMOUNT');
741         INUS_WETH(NUS_WETH).withdraw(amountOut);
742         TransferHelper.safeTransferETH(to, amountOut);
743     }
744 
745     // **** LIBRARY FUNCTIONS ****
746     function quote(uint amountA, uint reserveA, uint reserveB) public pure virtual override returns (uint amountB) {
747         return NimbusLibrary.quote(amountA, reserveA, reserveB);
748     }
749 
750     function pairFor(address tokenA, address tokenB) external view returns (address) {
751         return NimbusLibrary.pairFor(factory, tokenA, tokenB);
752     }
753 
754     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut)
755         public
756         pure
757         virtual
758         override
759         returns (uint amountOut)
760     {
761         return NimbusLibrary.getAmountOut(amountIn, reserveIn, reserveOut);
762     }
763 
764     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut)
765         public
766         pure
767         virtual
768         override
769         returns (uint amountIn)
770     {
771         return NimbusLibrary.getAmountIn(amountOut, reserveIn, reserveOut);
772     }
773 
774     function getAmountsOut(uint amountIn, address[] memory path)
775         public
776         view
777         virtual
778         override
779         returns (uint[] memory amounts)
780     {
781         return NimbusLibrary.getAmountsOut(factory, amountIn, path);
782     }
783 
784     function getAmountsIn(uint amountOut, address[] memory path)
785         public
786         view
787         virtual
788         override
789         returns (uint[] memory amounts)
790     {
791         return NimbusLibrary.getAmountsIn(factory, amountOut, path);
792     }
793 }