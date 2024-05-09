1 // SPDX-License-Identifier: MIT
2 pragma solidity =0.6.6;
3 
4 library TransferHelper {
5     function safeApprove(
6         address token,
7         address to,
8         uint256 value
9     ) internal {
10         // bytes4(keccak256(bytes('approve(address,uint256)')));
11         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
12         require(
13             success && (data.length == 0 || abi.decode(data, (bool))),
14             'TransferHelper::safeApprove: approve failed'
15         );
16     }
17 
18     function safeTransfer(
19         address token,
20         address to,
21         uint256 value
22     ) internal {
23         // bytes4(keccak256(bytes('transfer(address,uint256)')));
24         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
25         require(
26             success && (data.length == 0 || abi.decode(data, (bool))),
27             'TransferHelper::safeTransfer: transfer failed'
28         );
29     }
30 
31     function safeTransferFrom(
32         address token,
33         address from,
34         address to,
35         uint256 value
36     ) internal {
37         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
38         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
39         require(
40             success && (data.length == 0 || abi.decode(data, (bool))),
41             'TransferHelper::transferFrom: transferFrom failed'
42         );
43     }
44 
45     function safeTransferETH(address to, uint256 value) internal {
46         (bool success, ) = to.call{value: value}(new bytes(0));
47         require(success, 'TransferHelper::safeTransferETH: ETH transfer failed');
48     }
49 }
50 
51 library SafeMath {
52     function add(uint x, uint y) internal pure returns (uint z) {
53         require((z = x + y) >= x, 'ds-math-add-overflow');
54     }
55 
56     function sub(uint x, uint y) internal pure returns (uint z) {
57         require((z = x - y) <= x, 'ds-math-sub-underflow');
58     }
59 
60     function mul(uint x, uint y) internal pure returns (uint z) {
61         require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');
62     }
63 
64     function div(uint256 a, uint256 b) internal pure returns (uint256) {
65         return div(a, b, "SafeMath: division by zero");
66     }
67 
68     /**
69      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
70      * division by zero. The result is rounded towards zero.
71      *
72      * Counterpart to Solidity's `/` operator. Note: this function uses a
73      * `revert` opcode (which leaves remaining gas untouched) while Solidity
74      * uses an invalid opcode to revert (consuming all remaining gas).
75      *
76      * Requirements:
77      *
78      * - The divisor cannot be zero.
79      */
80     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
81         require(b > 0, errorMessage);
82         uint256 c = a / b;
83         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
84 
85         return c;
86     }
87 }
88 
89 library SaitamaskV1Library {
90     using SafeMath for uint;
91 
92     // returns sorted token addresses, used to handle return values from pairs sorted in this order
93     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
94         require(tokenA != tokenB, 'SaitamaskV1Library: IDENTICAL_ADDRESSES');
95         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
96         require(token0 != address(0), 'SaitamaskV1Library: ZERO_ADDRESS');
97     }
98 
99     // calculates the CREATE2 address for a pair without making any external calls
100     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
101         (address token0, address token1) = sortTokens(tokenA, tokenB);
102         pair = address(uint(keccak256(abi.encodePacked(
103                 hex'ff',
104                 factory,
105                 keccak256(abi.encodePacked(token0, token1)),
106                 hex'e7d24a15798dcc38719cb073513099adcb6598e2a56da87e6d019195a2a5b346' // init code hash
107             ))));
108     }
109     
110     // fetches and sorts the reserves for a pair
111     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
112         (address token0,) = sortTokens(tokenA, tokenB);
113         (uint reserve0, uint reserve1,) = ISaitamaskV1Pair(pairFor(factory, tokenA, tokenB)).getReserves();
114         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
115     }
116 
117     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
118     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
119         require(amountA > 0, 'SaitamaskV1Library: INSUFFICIENT_AMOUNT');
120         require(reserveA > 0 && reserveB > 0, 'SaitamaskV1Library: INSUFFICIENT_LIQUIDITY');
121         amountB = amountA.mul(reserveB) / reserveA;
122     }
123 
124     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
125     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut, uint feeMultiplier) internal pure returns (uint amountOut) {
126         require(amountIn > 0, 'SaitamaskV1Library: INSUFFICIENT_INPUT_AMOUNT');
127         require(reserveIn > 0 && reserveOut > 0, 'SaitamaskV1Library: INSUFFICIENT_LIQUIDITY');
128         uint amountInWithFee = amountIn.mul(feeMultiplier);
129         uint numerator = amountInWithFee.mul(reserveOut);
130         uint denominator = reserveIn.mul(10000).add(amountInWithFee);
131         amountOut = numerator / denominator;
132     }
133 
134     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
135     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut, uint feeMultiplier) internal pure returns (uint amountIn) {
136         require(amountOut > 0, 'SaitamaskV1Library: INSUFFICIENT_OUTPUT_AMOUNT');
137         require(reserveIn > 0 && reserveOut > 0, 'SaitamaskV1Library: INSUFFICIENT_LIQUIDITY');
138         uint numerator = reserveIn.mul(amountOut).mul(1000);
139         uint denominator = reserveOut.sub(amountOut).mul(feeMultiplier);
140         amountIn = (numerator / denominator).add(1);
141     }
142 
143     // performs chained getAmountOut calculations on any number of pairs
144     function getAmountsOut(address factory, uint amountIn, address[] memory path, uint feeMultiplier) internal view returns (uint[] memory amounts) {
145         require(path.length >= 2, 'SaitamaskV1Library: INVALID_PATH');
146         amounts = new uint[](path.length);
147         amounts[0] = amountIn;
148         for (uint i; i < path.length - 1; i++) {
149             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);
150             amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut, feeMultiplier);
151         }
152     }
153 
154     // performs chained getAmountIn calculations on any number of pairs
155     function getAmountsIn(address factory, uint amountOut, address[] memory path, uint feeMultiplier) internal view returns (uint[] memory amounts) {
156         require(path.length >= 2, 'SaitamaskV1Library: INVALID_PATH');
157         amounts = new uint[](path.length);
158         amounts[amounts.length - 1] = amountOut;
159         for (uint i = path.length - 1; i > 0; i--) {
160             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);
161             amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut, feeMultiplier);
162         }
163     }
164 }
165 
166 interface ISaitamaskV1Factory {
167     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
168 
169     function getExchange(address) external view returns (address);
170 
171     function feeTo() external view returns (address);
172     function feeToSetter() external view returns (address);
173 
174     function getPair(address tokenA, address tokenB) external view returns (address pair);
175     function allPairs(uint) external view returns (address pair);
176     function allPairsLength() external view returns (uint);
177 
178     function createPair(address tokenA, address tokenB) external returns (address pair);
179 
180     function setFeeTo(address) external;
181     function setFeeToSetter(address) external;
182 }
183 
184 interface ISaitamaskV1Router01 {
185     function factory() external pure returns (address);
186     function WETH() external pure returns (address);
187 
188     function addLiquidity(
189         address tokenA,
190         address tokenB,
191         uint amountADesired,
192         uint amountBDesired,
193         uint amountAMin,
194         uint amountBMin,
195         address to,
196         uint deadline
197     ) external returns (uint amountA, uint amountB, uint liquidity);
198     function addLiquidityETH(
199         address token,
200         uint amountTokenDesired,
201         uint amountTokenMin,
202         uint amountETHMin,
203         address to,
204         uint deadline
205     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
206     function removeLiquidity(
207         address tokenA,
208         address tokenB,
209         uint liquidity,
210         uint amountAMin,
211         uint amountBMin,
212         address to,
213         uint deadline
214     ) external returns (uint amountA, uint amountB);
215     function removeLiquidityETH(
216         address token,
217         uint liquidity,
218         uint amountTokenMin,
219         uint amountETHMin,
220         address to,
221         uint deadline,
222         uint reflectionMultiplier,
223         uint reflectionDivider
224     ) external returns (uint amountToken, uint amountETH);
225     /* function removeLiquidityWithPermit(
226         address tokenA,
227         address tokenB,
228         uint liquidity,
229         uint amountAMin,
230         uint amountBMin,
231         address to,
232         uint deadline,
233         bool approveMax, uint8 v, bytes32 r, bytes32 s
234     ) external returns (uint amountA, uint amountB);
235     function removeLiquidityETHWithPermit(
236         address token,
237         uint liquidity,
238         uint amountTokenMin,
239         uint amountETHMin,
240         address to,
241         uint deadline,
242         bool approveMax, uint8 v, bytes32 r, bytes32 s
243     ) external returns (uint amountToken, uint amountETH); */
244     function swapExactTokensForTokens(
245         uint amountIn,
246         uint amountOutMin,
247         address[] calldata path,
248         address to,
249         uint deadline
250     ) external returns (uint[] memory amounts);
251     function swapTokensForExactTokens(
252         uint amountOut,
253         uint amountInMax,
254         address[] calldata path,
255         address to,
256         uint deadline
257     ) external returns (uint[] memory amounts);
258     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
259         external
260         payable
261         returns (uint[] memory amounts);
262     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
263         external
264         returns (uint[] memory amounts);
265     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
266         external
267         returns (uint[] memory amounts);
268     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
269         external
270         payable
271         returns (uint[] memory amounts);
272 
273     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
274     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
275     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
276     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
277 }
278 
279 interface ISaitamaskV1Router02 is ISaitamaskV1Router01 {
280     /* function removeLiquidityETHSupportingFeeOnTransferTokens(
281         address token,
282         uint liquidity,
283         uint amountTokenMin,
284         uint amountETHMin,
285         address to,
286         uint deadline
287     ) external returns (uint amountETH);
288     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
289         address token,
290         uint liquidity,
291         uint amountTokenMin,
292         uint amountETHMin,
293         address to,
294         uint deadline,
295         bool approveMax, uint8 v, bytes32 r, bytes32 s
296     ) external returns (uint amountETH);
297      
298     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
299         uint amountIn,
300         uint amountOutMin,
301         address[] calldata path,
302         address to,
303         uint deadline
304     ) external;
305     function swapExactETHForTokensSupportingFeeOnTransferTokens(
306         uint amountOutMin,
307         address[] calldata path,
308         address to,
309         uint deadline
310     ) external payable;
311     function swapExactTokensForETHSupportingFeeOnTransferTokens(
312         uint amountIn,
313         uint amountOutMin,
314         address[] calldata path,
315         address to,
316         uint deadline
317     ) external; */
318 }
319 
320 interface ISaitamaskV1Pair {
321     event Approval(address indexed owner, address indexed spender, uint value);
322     event Transfer(address indexed from, address indexed to, uint value);
323 
324     function name() external pure returns (string memory);
325     function symbol() external pure returns (string memory);
326     function decimals() external pure returns (uint8);
327     function totalSupply() external view returns (uint);
328     function balanceOf(address owner) external view returns (uint);
329     function allowance(address owner, address spender) external view returns (uint);
330 
331     function approve(address spender, uint value) external returns (bool);
332     function transfer(address to, uint value) external returns (bool);
333     function transferFrom(address from, address to, uint value) external returns (bool);
334 
335     function DOMAIN_SEPARATOR() external view returns (bytes32);
336     function PERMIT_TYPEHASH() external pure returns (bytes32);
337     function nonces(address owner) external view returns (uint);
338 
339     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
340 
341     event Mint(address indexed sender, uint amount0, uint amount1);
342     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
343     event Swap(
344         address indexed sender,
345         uint amount0In,
346         uint amount1In,
347         uint amount0Out,
348         uint amount1Out,
349         address indexed to
350     );
351     event Sync(uint112 reserve0, uint112 reserve1);
352 
353     function MINIMUM_LIQUIDITY() external pure returns (uint);
354     function factory() external view returns (address);
355     function token0() external view returns (address);
356     function token1() external view returns (address);
357     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
358     function price0CumulativeLast() external view returns (uint);
359     function price1CumulativeLast() external view returns (uint);
360     function kLast() external view returns (uint);
361 
362     function mintSaitamask(address to) external returns (uint liquidity);
363     function burnSaitamask(address to) external returns (uint amount0, uint amount1);
364     function swapSaitamask(uint amount0Out, uint amount1Out, address to, bytes calldata data, uint feeMultiplier) external;
365     function skim(address to) external;
366     function sync() external;
367 
368     function initialize(address, address) external;
369 }
370 
371 interface IERC20 {
372     event Approval(address indexed owner, address indexed spender, uint value);
373     event Transfer(address indexed from, address indexed to, uint value);
374 
375     function name() external view returns (string memory);
376     function symbol() external view returns (string memory);
377     function decimals() external view returns (uint8);
378     function totalSupply() external view returns (uint);
379     function balanceOf(address owner) external view returns (uint);
380     function allowance(address owner, address spender) external view returns (uint);
381 
382     function approve(address spender, uint value) external returns (bool);
383     function transfer(address to, uint value) external returns (bool);
384     function transferFrom(address from, address to, uint value) external returns (bool);
385 }
386 
387 interface IWETH {
388     function deposit() external payable;
389     function transfer(address to, uint value) external returns (bool);
390     function withdraw(uint) external;
391 }
392 
393 contract SaitamaskV1Router02 is ISaitamaskV1Router02 {
394     using SafeMath for uint;
395 
396     address public immutable override factory;
397     address public immutable override WETH;
398     address public immutable SAITAMA;
399 
400     modifier ensure(uint deadline) {
401         require(deadline >= block.timestamp, 'SaitamaskV1Router: EXPIRED');
402         _;
403     }
404     
405     event SwapInfo(uint amount0Out, uint amount1Out, address to, bytes);
406     event SwapExactTokens(address pathOut);
407 
408     constructor(address _factory, address _WETH, address _SAITAMA) public {
409         factory = _factory;
410         WETH = _WETH;
411         SAITAMA = _SAITAMA;
412     }
413     
414     receive() external payable {
415         assert(msg.sender == WETH); // only accept ETH via fallback from the WETH contract
416     }
417 
418     // **** ADD LIQUIDITY ****
419     function _addLiquidity(
420         address tokenA,
421         address tokenB,
422         uint amountADesired,
423         uint amountBDesired,
424         uint amountAMin,
425         uint amountBMin
426     ) internal virtual returns (uint amountA, uint amountB) {
427         // create the pair if it doesn't exist yet
428         if (ISaitamaskV1Factory(factory).getPair(tokenA, tokenB) == address(0)) {
429             ISaitamaskV1Factory(factory).createPair(tokenA, tokenB);
430         }
431         (uint reserveA, uint reserveB) = SaitamaskV1Library.getReserves(factory, tokenA, tokenB);
432         if (reserveA == 0 && reserveB == 0) {
433             (amountA, amountB) = (amountADesired, amountBDesired);
434         } else {
435             uint amountBOptimal = SaitamaskV1Library.quote(amountADesired, reserveA, reserveB);
436             if (amountBOptimal <= amountBDesired) {
437                 require(amountBOptimal >= amountBMin, 'SaitamaskV1Router: INSUFFICIENT_B_AMOUNT');
438                 require(amountBDesired >= amountBMin, 'SaitamaskV1Router: INSUFFICIENT_AMOUNT_B_DESIRED');
439                 (amountA, amountB) = (amountADesired, amountBOptimal);
440             } else {
441                 uint amountAOptimal = SaitamaskV1Library.quote(amountBDesired, reserveB, reserveA);
442                 assert(amountAOptimal <= amountADesired);
443                 require(amountAOptimal >= amountAMin, 'SaitamaskV1Router: INSUFFICIENT_A_AMOUNT');
444                 require(amountADesired >= amountAMin, 'SaitamaskV1Router: INSUFFICIENT_AMOUNT_A_DESIRED');
445                 (amountA, amountB) = (amountAOptimal, amountBDesired);
446             }
447         }
448     }
449     function addLiquidity(
450         address tokenA,
451         address tokenB,
452         uint amountADesired,
453         uint amountBDesired,
454         uint amountAMin,
455         uint amountBMin,
456         address to,
457         uint deadline
458     ) external virtual override ensure(deadline) returns (uint amountA, uint amountB, uint liquidity) {
459         (amountA, amountB) = _addLiquidity(tokenA, tokenB, amountADesired, amountBDesired, amountAMin, amountBMin);
460         address pair = SaitamaskV1Library.pairFor(factory, tokenA, tokenB);
461         TransferHelper.safeTransferFrom(tokenA, msg.sender, pair, amountA);
462         TransferHelper.safeTransferFrom(tokenB, msg.sender, pair, amountB);
463         liquidity = ISaitamaskV1Pair(pair).mintSaitamask(to);
464     }
465     function addLiquidityETH(
466         address token,
467         uint amountTokenDesired,
468         uint amountTokenMin,
469         uint amountETHMin,
470         address to,
471         uint deadline
472     ) external virtual override payable ensure(deadline) returns (uint amountToken, uint amountETH, uint liquidity) {
473         (amountToken, amountETH) = _addLiquidity(
474             token,
475             WETH,
476             amountTokenDesired,
477             msg.value,
478             amountTokenMin,
479             amountETHMin
480         );
481         address pair = SaitamaskV1Library.pairFor(factory, token, WETH);
482         TransferHelper.safeTransferFrom(token, msg.sender, pair, amountToken);
483         IWETH(WETH).deposit{value: amountETH}();
484         assert(IWETH(WETH).transfer(pair, amountETH));
485         liquidity = ISaitamaskV1Pair(pair).mintSaitamask(to);
486         // refund dust eth, if any
487         if (msg.value > amountETH) TransferHelper.safeTransferETH(msg.sender, msg.value - amountETH);
488     }
489 
490     // **** REMOVE LIQUIDITY ****
491     function removeLiquidity(
492         address tokenA,
493         address tokenB,
494         uint liquidity,
495         uint amountAMin,
496         uint amountBMin,
497         address to,
498         uint deadline
499     ) public virtual override ensure(deadline) returns (uint amountA, uint amountB) {
500         address pair = SaitamaskV1Library.pairFor(factory, tokenA, tokenB);
501         ISaitamaskV1Pair(pair).transferFrom(msg.sender, pair, liquidity); // send liquidity to pair
502         (uint amount0, uint amount1) = ISaitamaskV1Pair(pair).burnSaitamask(to);
503         (address token0,) = SaitamaskV1Library.sortTokens(tokenA, tokenB);
504         (amountA, amountB) = tokenA == token0 ? (amount0, amount1) : (amount1, amount0);
505         require(amountA >= amountAMin, 'SaitamaskV1Router: INSUFFICIENT_A_AMOUNT');
506         require(amountB >= amountBMin, 'SaitamaskV1Router: INSUFFICIENT_B_AMOUNT');
507     }
508     function removeLiquidityETH(
509         address token,
510         uint liquidity,
511         uint amountTokenMin,
512         uint amountETHMin,
513         address to,
514         uint deadline,
515         uint reflectionMultiplier,
516         uint reflectionDivider
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
527         
528         if (reflectionMultiplier != 0 && reflectionDivider != 0) {
529             amountToken = amountToken - amountToken.div(reflectionDivider).mul(reflectionMultiplier);
530             TransferHelper.safeTransfer(token, to, amountToken);
531         } else {
532             TransferHelper.safeTransfer(token, to, amountToken);
533         }
534         
535         IWETH(WETH).withdraw(amountETH);
536         TransferHelper.safeTransferETH(to, amountETH);
537     }
538     /* function removeLiquidityWithPermit(
539         address tokenA,
540         address tokenB,
541         uint liquidity,
542         uint amountAMin,
543         uint amountBMin,
544         address to,
545         uint deadline,
546         bool approveMax, uint8 v, bytes32 r, bytes32 s
547     ) external virtual override returns (uint amountA, uint amountB) {
548         address pair = SaitamaskV1Library.pairFor(factory, tokenA, tokenB);
549         uint value = approveMax ? uint(-1) : liquidity;
550         ISaitamaskV1Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
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
562         address pair = SaitamaskV1Library.pairFor(factory, token, WETH);
563         uint value = approveMax ? uint(-1) : liquidity;
564         ISaitamaskV1Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
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
599         address pair = SaitamaskV1Library.pairFor(factory, token, WETH);
600         uint value = approveMax ? uint(-1) : liquidity;
601         ISaitamaskV1Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
602         amountETH = removeLiquidityETHSupportingFeeOnTransferTokens(
603             token, liquidity, amountTokenMin, amountETHMin, to, deadline
604         );
605     } */
606 
607     // **** SWAP ****
608     // requires the initial amount to have already been sent to the first pair
609     function _swap(uint[] memory amounts, address[] memory path, address _to, uint feeMultiplier) internal virtual {
610         for (uint i; i < path.length - 1; i++) {
611             (address input, address output) = (path[i], path[i + 1]);
612             (address token0,) = SaitamaskV1Library.sortTokens(input, output);
613             uint amountOut = amounts[i + 1];
614             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOut) : (amountOut, uint(0));
615             address to = i < path.length - 2 ? SaitamaskV1Library.pairFor(factory, output, path[i + 2]) : _to;
616             ISaitamaskV1Pair(SaitamaskV1Library.pairFor(factory, input, output)).swapSaitamask(
617                 amount0Out, amount1Out, to, new bytes(0), feeMultiplier
618             );
619             emit SwapInfo(amount0Out, amount1Out, to, new bytes(0));
620         }
621     }
622     function _getMultipliers(address[] memory path) internal view returns (uint feeMultiplier, uint swapFeeMultiplier) {
623         feeMultiplier = 9975;
624         swapFeeMultiplier = 25;
625         if (path[0] == SAITAMA && path[1] == WETH || path[0] == WETH && path[1] == SAITAMA) {
626             feeMultiplier = 9985;
627             swapFeeMultiplier = 15;
628         }
629     }
630     function swapExactTokensForTokens(
631         uint amountIn,
632         uint amountOutMin,
633         address[] calldata path,
634         address to,
635         uint deadline
636     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
637         (uint feeMultiplier, uint swapFeeMultiplier) = _getMultipliers(path);
638         amounts = SaitamaskV1Library.getAmountsOut(factory, amountIn, path, feeMultiplier);
639         require(amounts[amounts.length - 1] >= amountOutMin, 'SaitamaskV1Router: INSUFFICIENT_OUTPUT_AMOUNT');
640         TransferHelper.safeTransferFrom(
641             path[0], msg.sender, SaitamaskV1Library.pairFor(factory, path[0], path[1]), amounts[0]
642         );
643         _swap(amounts, path, to, swapFeeMultiplier);
644         emit SwapExactTokens(path[path.length - 1]); 
645     }
646     function swapTokensForExactTokens(
647         uint amountOut,
648         uint amountInMax,
649         address[] calldata path,
650         address to,
651         uint deadline
652     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
653         (uint feeMultiplier, uint swapFeeMultiplier) = _getMultipliers(path);
654         amounts = SaitamaskV1Library.getAmountsIn(factory, amountOut, path, feeMultiplier);
655         require(amounts[0] <= amountInMax, 'SaitamaskV1Router: EXCESSIVE_INPUT_AMOUNT');
656         TransferHelper.safeTransferFrom(
657             path[0], msg.sender, SaitamaskV1Library.pairFor(factory, path[0], path[1]), amounts[0]
658         );
659         _swap(amounts, path, to, swapFeeMultiplier);
660     }
661     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
662         external
663         virtual
664         override
665         payable
666         ensure(deadline)
667         returns (uint[] memory amounts)
668     {
669         require(path[0] == WETH, 'SaitamaskV1Router: INVALID_PATH');
670         (uint feeMultiplier, uint swapFeeMultiplier) = _getMultipliers(path);
671         amounts = SaitamaskV1Library.getAmountsOut(factory, msg.value, path, feeMultiplier);
672         require(amounts[amounts.length - 1] >= amountOutMin, 'SaitamaskV1Router: INSUFFICIENT_OUTPUT_AMOUNT');
673         IWETH(WETH).deposit{value: amounts[0]}();
674         assert(IWETH(WETH).transfer(SaitamaskV1Library.pairFor(factory, path[0], path[1]), amounts[0]));
675         _swap(amounts, path, to, swapFeeMultiplier);
676     }
677     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
678         external
679         virtual
680         override
681         ensure(deadline)
682         returns (uint[] memory amounts)
683     {
684         require(path[path.length - 1] == WETH, 'SaitamaskV1Router: INVALID_PATH');
685         (uint feeMultiplier, uint swapFeeMultiplier) = _getMultipliers(path);
686         amounts = SaitamaskV1Library.getAmountsIn(factory, amountOut, path, feeMultiplier);
687         require(amounts[0] <= amountInMax, 'SaitamaskV1Router: EXCESSIVE_INPUT_AMOUNT');
688         TransferHelper.safeTransferFrom(
689             path[0], msg.sender, SaitamaskV1Library.pairFor(factory, path[0], path[1]), amounts[0]
690         );
691         _swap(amounts, path, address(this), swapFeeMultiplier);
692         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
693         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
694     }
695     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
696         external
697         virtual
698         override
699         ensure(deadline)
700         returns (uint[] memory amounts)
701     {
702         require(path[path.length - 1] == WETH, 'SaitamaskV1Router: INVALID_PATH');
703         (uint feeMultiplier, uint swapFeeMultiplier) = _getMultipliers(path);
704         amounts = SaitamaskV1Library.getAmountsOut(factory, amountIn, path, feeMultiplier);
705         require(amounts[amounts.length - 1] >= amountOutMin, 'SaitamaskV1Router: INSUFFICIENT_OUTPUT_AMOUNT');
706         TransferHelper.safeTransferFrom(
707             path[0], msg.sender, SaitamaskV1Library.pairFor(factory, path[0], path[1]), amounts[0]
708         );
709         _swap(amounts, path, address(this), swapFeeMultiplier);
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
721         require(path[0] == WETH, 'SaitamaskV1Router: INVALID_PATH');
722         (uint feeMultiplier, uint swapFeeMultiplier) = _getMultipliers(path);
723         amounts = SaitamaskV1Library.getAmountsIn(factory, amountOut, path, feeMultiplier);
724         require(amounts[0] <= msg.value, 'SaitamaskV1Router: EXCESSIVE_INPUT_AMOUNT');
725         IWETH(WETH).deposit{value: amounts[0]}();
726         assert(IWETH(WETH).transfer(SaitamaskV1Library.pairFor(factory, path[0], path[1]), amounts[0]));
727         _swap(amounts, path, to, swapFeeMultiplier);
728         // refund dust eth, if any
729         if (msg.value > amounts[0]) TransferHelper.safeTransferETH(msg.sender, msg.value - amounts[0]);
730     }
731 
732     // **** SWAP (supporting fee-on-transfer tokens) ****
733     // requires the initial amount to have already been sent to the first pair
734     /* 
735     function _swapSupportingFeeOnTransferTokens(address[] memory path, address _to) internal virtual {
736         for (uint i; i < path.length - 1; i++) {
737             (address input, address output) = (path[i], path[i + 1]);
738             (address token0,) = SaitamaskV1Library.sortTokens(input, output);
739             ISaitamaskV1Pair pair = ISaitamaskV1Pair(SaitamaskV1Library.pairFor(factory, input, output));
740             uint amountInput;
741             uint amountOutput;
742             { // scope to avoid stack too deep errors
743             (uint reserve0, uint reserve1,) = pair.getReserves();
744             (uint reserveInput, uint reserveOutput) = input == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
745             amountInput = IERC20(input).balanceOf(address(pair)).sub(reserveInput);
746             amountOutput = SaitamaskV1Library.getAmountOut(amountInput, reserveInput, reserveOutput);
747             }
748             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOutput) : (amountOutput, uint(0));
749             address to = i < path.length - 2 ? SaitamaskV1Library.pairFor(factory, output, path[i + 2]) : _to;
750             pair.swap(amount0Out, amount1Out, to, new bytes(0));
751         }
752     }
753     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
754         uint amountIn,
755         uint amountOutMin,
756         address[] calldata path,
757         address to,
758         uint deadline
759     ) external virtual override ensure(deadline) {
760         TransferHelper.safeTransferFrom(
761             path[0], msg.sender, SaitamaskV1Library.pairFor(factory, path[0], path[1]), amountIn
762         );
763         uint balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
764         _swapSupportingFeeOnTransferTokens(path, to);
765         require(
766             IERC20(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
767             'SaitamaskV1Router: INSUFFICIENT_OUTPUT_AMOUNT'
768         );
769     }
770     function swapExactETHForTokensSupportingFeeOnTransferTokens(
771         uint amountOutMin,
772         address[] calldata path,
773         address to,
774         uint deadline
775     )
776         external
777         virtual
778         override
779         payable
780         ensure(deadline)
781     {
782         require(path[0] == WETH, 'SaitamaskV1Router: INVALID_PATH');
783         uint amountIn = msg.value;
784         IWETH(WETH).deposit{value: amountIn}();
785         assert(IWETH(WETH).transfer(SaitamaskV1Library.pairFor(factory, path[0], path[1]), amountIn));
786         uint balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
787         _swapSupportingFeeOnTransferTokens(path, to);
788         require(
789             IERC20(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
790             'SaitamaskV1Router: INSUFFICIENT_OUTPUT_AMOUNT'
791         );
792     }
793     99999999999999999
794     98994949366215648
795     function swapExactTokensForETHSupportingFeeOnTransferTokens(
796         uint amountIn,
797         uint amountOutMin,
798         address[] calldata path,
799         address to,
800         uint deadline
801     )
802         external
803         virtual
804         override
805         ensure(deadline)
806     {
807         require(path[path.length - 1] == WETH, 'SaitamaskV1Router: INVALID_PATH');
808         TransferHelper.safeTransferFrom(
809             path[0], msg.sender, SaitamaskV1Library.pairFor(factory, path[0], path[1]), amountIn
810         );
811         _swapSupportingFeeOnTransferTokens(path, address(this));
812         uint amountOut = IERC20(WETH).balanceOf(address(this));
813         require(amountOut >= amountOutMin, 'SaitamaskV1Router: INSUFFICIENT_OUTPUT_AMOUNT');
814         IWETH(WETH).withdraw(amountOut);
815         TransferHelper.safeTransferETH(to, amountOut);
816     } */
817 
818     // **** LIBRARY FUNCTIONS ****
819     function quote(uint amountA, uint reserveA, uint reserveB) public pure virtual override returns (uint amountB) {
820         return SaitamaskV1Library.quote(amountA, reserveA, reserveB);
821     }
822 
823     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut)
824         public
825         pure
826         virtual
827         override
828         returns (uint amountOut)
829     {
830         return SaitamaskV1Library.getAmountOut(amountIn, reserveIn, reserveOut, 997);
831     }
832 
833     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut, address[] memory path)
834         public
835         view
836         virtual
837         returns (uint amountIn)
838     {
839         (uint feeMultiplier, ) = _getMultipliers(path);
840         return SaitamaskV1Library.getAmountIn(amountOut, reserveIn, reserveOut, feeMultiplier);
841     }
842 
843     function getAmountsOut(uint amountIn, address[] memory path)
844         public
845         view
846         virtual
847         override
848         returns (uint[] memory amounts)
849     {
850         return SaitamaskV1Library.getAmountsOut(factory, amountIn, path, 997);
851     }
852 
853     function getAmountsIn(uint amountOut, address[] memory path)
854         public
855         view
856         virtual
857         override
858         returns (uint[] memory amounts)
859     {
860         (uint feeMultiplier, ) = _getMultipliers(path);
861         return SaitamaskV1Library.getAmountsIn(factory, amountOut, path, feeMultiplier);
862     }
863 }