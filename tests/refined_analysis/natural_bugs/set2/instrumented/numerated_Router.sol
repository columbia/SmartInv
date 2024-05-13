1 pragma solidity =0.8.0;
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
38     function safeTransferBNB(address to, uint value) internal {
39         (bool success,) = to.call{value:value}(new bytes(0));
40         require(success, 'TransferHelper: BNB_TRANSFER_FAILED');
41     }
42 }
43 
44 interface INimbusRouter01 {
45     function factory() external view returns (address);
46     function NBU_WBNB() external view returns (address);
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
58     function addLiquidityBNB(
59         address token,
60         uint amountTokenDesired,
61         uint amountTokenMin,
62         uint amountBNBMin,
63         address to,
64         uint deadline
65     ) external payable returns (uint amountToken, uint amountBNB, uint liquidity);
66     function removeLiquidity(
67         address tokenA,
68         address tokenB,
69         uint liquidity,
70         uint amountAMin,
71         uint amountBMin,
72         address to,
73         uint deadline
74     ) external returns (uint amountA, uint amountB);
75     function removeLiquidityBNB(
76         address token,
77         uint liquidity,
78         uint amountTokenMin,
79         uint amountBNBMin,
80         address to,
81         uint deadline
82     ) external returns (uint amountToken, uint amountBNB);
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
93     function removeLiquidityBNBWithPermit(
94         address token,
95         uint liquidity,
96         uint amountTokenMin,
97         uint amountBNBMin,
98         address to,
99         uint deadline,
100         bool approveMax, uint8 v, bytes32 r, bytes32 s
101     ) external returns (uint amountToken, uint amountBNB);
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
116     function swapExactBNBForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
117         external
118         payable
119         returns (uint[] memory amounts);
120     function swapTokensForExactBNB(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
121         external
122         returns (uint[] memory amounts);
123     function swapExactTokensForBNB(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
124         external
125         returns (uint[] memory amounts);
126     function swapBNBForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
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
139     function removeLiquidityBNBSupportingFeeOnTransferTokens(
140         address token,
141         uint liquidity,
142         uint amountTokenMin,
143         uint amountBNBMin,
144         address to,
145         uint deadline
146     ) external returns (uint amountBNB);
147     function removeLiquidityBNBWithPermitSupportingFeeOnTransferTokens(
148         address token,
149         uint liquidity,
150         uint amountTokenMin,
151         uint amountBNBMin,
152         address to,
153         uint deadline,
154         bool approveMax, uint8 v, bytes32 r, bytes32 s
155     ) external returns (uint amountBNB);
156 
157     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
158         uint amountIn,
159         uint amountOutMin,
160         address[] calldata path,
161         address to,
162         uint deadline
163     ) external;
164     function swapExactBNBForTokensSupportingFeeOnTransferTokens(
165         uint amountOutMin,
166         address[] calldata path,
167         address to,
168         uint deadline
169     ) external payable;
170     function swapExactTokensForBNBSupportingFeeOnTransferTokens(
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
231     // returns sorted token addresses, used to handle return values from pairs sorted in this order
232     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
233         require(tokenA != tokenB, 'NimbusLibrary: IDENTICAL_ADDRESSES');
234         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
235         require(token0 != address(0), 'NimbusLibrary: ZERO_ADDRESS');
236     }
237 
238     // calculates the CREATE2 address for a pair without making any external calls
239     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
240         (address token0, address token1) = sortTokens(tokenA, tokenB);
241         pair = address(uint160(uint(keccak256(abi.encodePacked(
242                 hex'ff',
243                 factory,
244                 keccak256(abi.encodePacked(token0, token1)),
245                 hex'db30e47fd6e77459fc13f8efdd91fc60b8c891af5954053614d1cc2ca3514ac1' // init code hash
246             )))));
247     }
248 
249     // fetches and sorts the reserves for a pair
250     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
251         (address token0,) = sortTokens(tokenA, tokenB);
252         (uint reserve0, uint reserve1,) = INimbusPair(pairFor(factory, tokenA, tokenB)).getReserves();
253         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
254     }
255 
256     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
257     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
258         require(amountA > 0, 'NimbusLibrary: INSUFFICIENT_AMOUNT');
259         require(reserveA > 0 && reserveB > 0, 'NimbusLibrary: INSUFFICIENT_LIQUIDITY');
260         amountB = amountA * reserveB / reserveA;
261     }
262 
263     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
264     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
265         require(amountIn > 0, 'NimbusLibrary: INSUFFICIENT_INPUT_AMOUNT');
266         require(reserveIn > 0 && reserveOut > 0, 'NimbusLibrary: INSUFFICIENT_LIQUIDITY');
267         uint amountInWithFee = amountIn * 997;
268         uint numerator = amountInWithFee * reserveOut;
269         uint denominator = reserveIn * 1000 + amountInWithFee;
270         amountOut = numerator / denominator;
271     }
272 
273     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
274     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {
275         require(amountOut > 0, 'NimbusLibrary: INSUFFICIENT_OUTPUT_AMOUNT');
276         require(reserveIn > 0 && reserveOut > 0, 'NimbusLibrary: INSUFFICIENT_LIQUIDITY');
277         uint numerator = reserveIn * amountOut * 1000;
278         uint denominator = (reserveOut - amountOut) * 997;
279         amountIn = (numerator / denominator) + 1;
280     }
281 
282     // performs chained getAmountOut calculations on any number of pairs
283     function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {
284         require(path.length >= 2, 'NimbusLibrary: INVALID_PATH');
285         amounts = new uint[](path.length);
286         amounts[0] = amountIn;
287         for (uint i; i < path.length - 1; i++) {
288             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);
289             amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
290         }
291     }
292 
293     // performs chained getAmountIn calculations on any number of pairs
294     function getAmountsIn(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {
295         require(path.length >= 2, 'NimbusLibrary: INVALID_PATH');
296         amounts = new uint[](path.length);
297         amounts[amounts.length - 1] = amountOut;
298         for (uint i = path.length - 1; i > 0; i--) {
299             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);
300             amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
301         }
302     }
303 }
304 
305 interface IBEP20 {
306     event Approval(address indexed owner, address indexed spender, uint value);
307     event Transfer(address indexed from, address indexed to, uint value);
308 
309     function name() external view returns (string memory);
310     function decimals() external view returns (uint8);
311     function symbol() external view returns (string memory);
312     function totalSupply() external view returns (uint);
313     function balanceOf(address owner) external view returns (uint);
314     function allowance(address owner, address spender) external view returns (uint);
315 
316     function approve(address spender, uint value) external returns (bool);
317     function transfer(address to, uint value) external returns (bool);
318     function transferFrom(address from, address to, uint value) external returns (bool);
319 }
320 
321 interface INBU_WBNB {
322     function deposit() external payable;
323     function transfer(address to, uint value) external returns (bool);
324     function withdraw(uint) external;
325 }
326 
327 interface ILPRewards {
328     function recordAddLiquidity(address user, address pair, uint amountA, uint amountB, uint liquidity) external;
329     function recordRemoveLiquidity(address user, address tokenA, address tokenB, uint amountA, uint amountB, uint liquidity) external;
330 }
331 
332 contract NimbusRouter is INimbusRouter {
333     address public immutable override factory;
334     address public immutable override NBU_WBNB;
335     ILPRewards public immutable lpRewards;
336 
337     modifier ensure(uint deadline) {
338         require(deadline >= block.timestamp, 'NimbusRouter: EXPIRED');
339         _;
340     }
341 
342     constructor(address _factory, address _NBU_WBNB, address _lpRewards) {
343         require(_factory != address(0) && _NBU_WBNB != address(0) && _lpRewards != address(0), "NimbusRouter: Zero address(es)");
344         factory = _factory;
345         NBU_WBNB = _NBU_WBNB;
346         lpRewards = ILPRewards(_lpRewards);
347     }
348 
349     receive() external payable {
350         assert(msg.sender == NBU_WBNB); // only accept BNB via fallback from the NBU_WBNB contract
351     }
352 
353     // **** ADD LIQUIDITY ****
354     function _addLiquidity(
355         address tokenA,
356         address tokenB,
357         uint amountADesired,
358         uint amountBDesired,
359         uint amountAMin,
360         uint amountBMin
361     ) internal virtual returns (uint amountA, uint amountB) {
362         // create the pair if it doesn't exist yet
363         if (INimbusFactory(factory).getPair(tokenA, tokenB) == address(0)) {
364             INimbusFactory(factory).createPair(tokenA, tokenB);
365         }
366         (uint reserveA, uint reserveB) = NimbusLibrary.getReserves(factory, tokenA, tokenB);
367         if (reserveA == 0 && reserveB == 0) {
368             (amountA, amountB) = (amountADesired, amountBDesired);
369         } else {
370             uint amountBOptimal = NimbusLibrary.quote(amountADesired, reserveA, reserveB);
371             if (amountBOptimal <= amountBDesired) {
372                 require(amountBOptimal >= amountBMin, 'NimbusRouter: INSUFFICIENT_B_AMOUNT');
373                 (amountA, amountB) = (amountADesired, amountBOptimal);
374             } else {
375                 uint amountAOptimal = NimbusLibrary.quote(amountBDesired, reserveB, reserveA);
376                 assert(amountAOptimal <= amountADesired);
377                 require(amountAOptimal >= amountAMin, 'NimbusRouter: INSUFFICIENT_A_AMOUNT');
378                 (amountA, amountB) = (amountAOptimal, amountBDesired);
379             }
380         }
381     }
382     function addLiquidity(
383         address tokenA,
384         address tokenB,
385         uint amountADesired,
386         uint amountBDesired,
387         uint amountAMin,
388         uint amountBMin,
389         address to,
390         uint deadline
391     ) external virtual override ensure(deadline) returns (uint amountA, uint amountB, uint liquidity) {
392         (amountA, amountB) = _addLiquidity(tokenA, tokenB, amountADesired, amountBDesired, amountAMin, amountBMin);
393         address pair = NimbusLibrary.pairFor(factory, tokenA, tokenB);
394         TransferHelper.safeTransferFrom(tokenA, msg.sender, pair, amountA);
395         TransferHelper.safeTransferFrom(tokenB, msg.sender, pair, amountB);
396         liquidity = INimbusPair(pair).mint(to);
397         lpRewards.recordAddLiquidity(to, pair, amountA, amountB, liquidity);
398     }
399     function addLiquidityBNB(
400         address token,
401         uint amountTokenDesired,
402         uint amountTokenMin,
403         uint amountBNBMin,
404         address to,
405         uint deadline
406     ) external virtual override payable ensure(deadline) returns (uint amountToken, uint amountBNB, uint liquidity) {
407         (amountToken, amountBNB) = _addLiquidity(
408             token,
409             NBU_WBNB,
410             amountTokenDesired,
411             msg.value,
412             amountTokenMin,
413             amountBNBMin
414         );
415         address pair = NimbusLibrary.pairFor(factory, token, NBU_WBNB);
416         TransferHelper.safeTransferFrom(token, msg.sender, pair, amountToken);
417         INBU_WBNB(NBU_WBNB).deposit{value: amountBNB}();
418         assert(INBU_WBNB(NBU_WBNB).transfer(pair, amountBNB));
419         liquidity = INimbusPair(pair).mint(to);
420         // refund dust bnb, if any
421         if (msg.value > amountBNB) TransferHelper.safeTransferBNB(msg.sender, msg.value - amountBNB);
422         lpRewards.recordAddLiquidity(to, pair, amountBNB, amountToken, liquidity);
423     }
424 
425     // **** REMOVE LIQUIDITY ****
426     function removeLiquidity(
427         address tokenA,
428         address tokenB,
429         uint liquidity,
430         uint amountAMin,
431         uint amountBMin,
432         address to,
433         uint deadline
434     ) public virtual override ensure(deadline) returns (uint amountA, uint amountB) {
435         {
436         address pair = NimbusLibrary.pairFor(factory, tokenA, tokenB);
437         require(INimbusPair(pair).transferFrom(msg.sender, pair, liquidity), "NimbusRouter: Error on transfering"); // send liquidity to pair
438         (uint amount0, uint amount1) = INimbusPair(pair).burn(to);
439         (address token0,) = NimbusLibrary.sortTokens(tokenA, tokenB);
440         (amountA, amountB) = tokenA == token0 ? (amount0, amount1) : (amount1, amount0);
441         require(amountA >= amountAMin, 'NimbusRouter: INSUFFICIENT_A_AMOUNT');
442         require(amountB >= amountBMin, 'NimbusRouter: INSUFFICIENT_B_AMOUNT');
443         }
444         lpRewards.recordRemoveLiquidity(to, tokenA, tokenB, amountA, amountB, liquidity);
445     }
446     function removeLiquidityBNB(
447         address token,
448         uint liquidity,
449         uint amountTokenMin,
450         uint amountBNBMin,
451         address to,
452         uint deadline
453     ) public virtual override ensure(deadline) returns (uint amountToken, uint amountBNB) {
454         (amountToken, amountBNB) = removeLiquidity(
455             token,
456             NBU_WBNB,
457             liquidity,
458             amountTokenMin,
459             amountBNBMin,
460             address(this),
461             deadline
462         );
463         TransferHelper.safeTransfer(token, to, amountToken);
464         INBU_WBNB(NBU_WBNB).withdraw(amountBNB);
465         TransferHelper.safeTransferBNB(to, amountBNB);
466     }
467     function removeLiquidityWithPermit(
468         address tokenA,
469         address tokenB,
470         uint liquidity,
471         uint amountAMin,
472         uint amountBMin,
473         address to,
474         uint deadline,
475         bool approveMax, uint8 v, bytes32 r, bytes32 s
476     ) external virtual override returns (uint amountA, uint amountB) {
477         address pair = NimbusLibrary.pairFor(factory, tokenA, tokenB);
478         uint value = approveMax ? type(uint256).max : liquidity;
479         INimbusPair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
480         (amountA, amountB) = removeLiquidity(tokenA, tokenB, liquidity, amountAMin, amountBMin, to, deadline);
481     }
482     function removeLiquidityBNBWithPermit(
483         address token,
484         uint liquidity,
485         uint amountTokenMin,
486         uint amountBNBMin,
487         address to,
488         uint deadline,
489         bool approveMax, uint8 v, bytes32 r, bytes32 s
490     ) external virtual override returns (uint amountToken, uint amountBNB) {
491         address pair = NimbusLibrary.pairFor(factory, token, NBU_WBNB);
492         uint value = approveMax ? type(uint256).max : liquidity;
493         INimbusPair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
494         (amountToken, amountBNB) = removeLiquidityBNB(token, liquidity, amountTokenMin, amountBNBMin, to, deadline);
495     }
496 
497     // **** REMOVE LIQUIDITY (supporting fee-on-transfer tokens) ****
498     function removeLiquidityBNBSupportingFeeOnTransferTokens(
499         address token,
500         uint liquidity,
501         uint amountTokenMin,
502         uint amountBNBMin,
503         address to,
504         uint deadline
505     ) public virtual override ensure(deadline) returns (uint amountBNB) {
506         (, amountBNB) = removeLiquidity(
507             token,
508             NBU_WBNB,
509             liquidity,
510             amountTokenMin,
511             amountBNBMin,
512             address(this),
513             deadline
514         );
515         TransferHelper.safeTransfer(token, to, IBEP20(token).balanceOf(address(this)));
516         INBU_WBNB(NBU_WBNB).withdraw(amountBNB);
517         TransferHelper.safeTransferBNB(to, amountBNB);
518     }
519     function removeLiquidityBNBWithPermitSupportingFeeOnTransferTokens(
520         address token,
521         uint liquidity,
522         uint amountTokenMin,
523         uint amountBNBMin,
524         address to,
525         uint deadline,
526         bool approveMax, uint8 v, bytes32 r, bytes32 s
527     ) external virtual override returns (uint amountBNB) {
528         address pair = NimbusLibrary.pairFor(factory, token, NBU_WBNB);
529         uint value = approveMax ? type(uint256).max : liquidity;
530         INimbusPair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
531         amountBNB = removeLiquidityBNBSupportingFeeOnTransferTokens(
532             token, liquidity, amountTokenMin, amountBNBMin, to, deadline
533         );
534     }
535 
536     // **** SWAP ****
537     // requires the initial amount to have already been sent to the first pair
538     function _swap(uint[] memory amounts, address[] memory path, address _to) internal virtual {
539         for (uint i; i < path.length - 1; i++) {
540             (address input, address output) = (path[i], path[i + 1]);
541             (address token0,) = NimbusLibrary.sortTokens(input, output);
542             uint amountOut = amounts[i + 1];
543             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOut) : (amountOut, uint(0));
544             address to = i < path.length - 2 ? NimbusLibrary.pairFor(factory, output, path[i + 2]) : _to;
545             INimbusPair(NimbusLibrary.pairFor(factory, input, output)).swap(
546                 amount0Out, amount1Out, to, new bytes(0)
547             );
548         }
549     }
550     function swapExactTokensForTokens(
551         uint amountIn,
552         uint amountOutMin,
553         address[] calldata path,
554         address to,
555         uint deadline
556     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
557         amounts = NimbusLibrary.getAmountsOut(factory, amountIn, path);
558         require(amounts[amounts.length - 1] >= amountOutMin, 'NimbusRouter: INSUFFICIENT_OUTPUT_AMOUNT');
559         TransferHelper.safeTransferFrom(
560             path[0], msg.sender, NimbusLibrary.pairFor(factory, path[0], path[1]), amounts[0]
561         );
562         _swap(amounts, path, to);
563     }
564     function swapTokensForExactTokens(
565         uint amountOut,
566         uint amountInMax,
567         address[] calldata path,
568         address to,
569         uint deadline
570     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
571         amounts = NimbusLibrary.getAmountsIn(factory, amountOut, path);
572         require(amounts[0] <= amountInMax, 'NimbusRouter: EXCESSIVE_INPUT_AMOUNT');
573         TransferHelper.safeTransferFrom(
574             path[0], msg.sender, NimbusLibrary.pairFor(factory, path[0], path[1]), amounts[0]
575         );
576         _swap(amounts, path, to);
577     }
578     function swapExactBNBForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
579         external
580         virtual
581         override
582         payable
583         ensure(deadline)
584         returns (uint[] memory amounts)
585     {
586         require(path[0] == NBU_WBNB, 'NimbusRouter: INVALID_PATH');
587         amounts = NimbusLibrary.getAmountsOut(factory, msg.value, path);
588         require(amounts[amounts.length - 1] >= amountOutMin, 'NimbusRouter: INSUFFICIENT_OUTPUT_AMOUNT');
589         INBU_WBNB(NBU_WBNB).deposit{value: amounts[0]}();
590         assert(INBU_WBNB(NBU_WBNB).transfer(NimbusLibrary.pairFor(factory, path[0], path[1]), amounts[0]));
591         _swap(amounts, path, to);
592     }
593     function swapTokensForExactBNB(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
594         external
595         virtual
596         override
597         ensure(deadline)
598         returns (uint[] memory amounts)
599     {
600         require(path[path.length - 1] == NBU_WBNB, 'NimbusRouter: INVALID_PATH');
601         amounts = NimbusLibrary.getAmountsIn(factory, amountOut, path);
602         require(amounts[0] <= amountInMax, 'NimbusRouter: EXCESSIVE_INPUT_AMOUNT');
603         TransferHelper.safeTransferFrom(
604             path[0], msg.sender, NimbusLibrary.pairFor(factory, path[0], path[1]), amounts[0]
605         );
606         _swap(amounts, path, address(this));
607         INBU_WBNB(NBU_WBNB).withdraw(amounts[amounts.length - 1]);
608         TransferHelper.safeTransferBNB(to, amounts[amounts.length - 1]);
609     }
610     function swapExactTokensForBNB(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
611         external
612         virtual
613         override
614         ensure(deadline)
615         returns (uint[] memory amounts)
616     {
617         require(path[path.length - 1] == NBU_WBNB, 'NimbusRouter: INVALID_PATH');
618         amounts = NimbusLibrary.getAmountsOut(factory, amountIn, path);
619         require(amounts[amounts.length - 1] >= amountOutMin, 'NimbusRouter: INSUFFICIENT_OUTPUT_AMOUNT');
620         TransferHelper.safeTransferFrom(
621             path[0], msg.sender, NimbusLibrary.pairFor(factory, path[0], path[1]), amounts[0]
622         );
623         _swap(amounts, path, address(this));
624         INBU_WBNB(NBU_WBNB).withdraw(amounts[amounts.length - 1]);
625         TransferHelper.safeTransferBNB(to, amounts[amounts.length - 1]);
626     }
627     function swapBNBForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
628         external
629         virtual
630         override
631         payable
632         ensure(deadline)
633         returns (uint[] memory amounts)
634     {
635         require(path[0] == NBU_WBNB, 'NimbusRouter: INVALID_PATH');
636         amounts = NimbusLibrary.getAmountsIn(factory, amountOut, path);
637         require(amounts[0] <= msg.value, 'NimbusRouter: EXCESSIVE_INPUT_AMOUNT');
638         INBU_WBNB(NBU_WBNB).deposit{value: amounts[0]}();
639         assert(INBU_WBNB(NBU_WBNB).transfer(NimbusLibrary.pairFor(factory, path[0], path[1]), amounts[0]));
640         _swap(amounts, path, to);
641         // refund dust bnb, if any
642         if (msg.value > amounts[0]) TransferHelper.safeTransferBNB(msg.sender, msg.value - amounts[0]);
643     }
644 
645     // **** SWAP (supporting fee-on-transfer tokens) ****
646     // requires the initial amount to have already been sent to the first pair
647     function _swapSupportingFeeOnTransferTokens(address[] memory path, address _to) internal virtual {
648         for (uint i; i < path.length - 1; i++) {
649             (address input, address output) = (path[i], path[i + 1]);
650             (address token0,) = NimbusLibrary.sortTokens(input, output);
651             INimbusPair pair = INimbusPair(NimbusLibrary.pairFor(factory, input, output));
652             uint amountInput;
653             uint amountOutput;
654             { // scope to avoid stack too deep errors
655             (uint reserve0, uint reserve1,) = pair.getReserves();
656             (uint reserveInput, uint reserveOutput) = input == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
657             amountInput = IBEP20(input).balanceOf(address(pair)) - reserveInput;
658             amountOutput = NimbusLibrary.getAmountOut(amountInput, reserveInput, reserveOutput);
659             }
660             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOutput) : (amountOutput, uint(0));
661             address to = i < path.length - 2 ? NimbusLibrary.pairFor(factory, output, path[i + 2]) : _to;
662             pair.swap(amount0Out, amount1Out, to, new bytes(0));
663         }
664     }
665     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
666         uint amountIn,
667         uint amountOutMin,
668         address[] calldata path,
669         address to,
670         uint deadline
671     ) external virtual override ensure(deadline) {
672         TransferHelper.safeTransferFrom(
673             path[0], msg.sender, NimbusLibrary.pairFor(factory, path[0], path[1]), amountIn
674         );
675         uint balanceBefore = IBEP20(path[path.length - 1]).balanceOf(to);
676         _swapSupportingFeeOnTransferTokens(path, to);
677         require(
678             IBEP20(path[path.length - 1]).balanceOf(to) - balanceBefore >= amountOutMin,
679             'NimbusRouter: INSUFFICIENT_OUTPUT_AMOUNT'
680         );
681     }
682     function swapExactBNBForTokensSupportingFeeOnTransferTokens(
683         uint amountOutMin,
684         address[] calldata path,
685         address to,
686         uint deadline
687     )
688         external
689         virtual
690         override
691         payable
692         ensure(deadline)
693     {
694         require(path[0] == NBU_WBNB, 'NimbusRouter: INVALID_PATH');
695         uint amountIn = msg.value;
696         INBU_WBNB(NBU_WBNB).deposit{value: amountIn}();
697         assert(INBU_WBNB(NBU_WBNB).transfer(NimbusLibrary.pairFor(factory, path[0], path[1]), amountIn));
698         uint balanceBefore = IBEP20(path[path.length - 1]).balanceOf(to);
699         _swapSupportingFeeOnTransferTokens(path, to);
700         require(
701             IBEP20(path[path.length - 1]).balanceOf(to) - balanceBefore >= amountOutMin,
702             'NimbusRouter: INSUFFICIENT_OUTPUT_AMOUNT'
703         );
704     }
705     function swapExactTokensForBNBSupportingFeeOnTransferTokens(
706         uint amountIn,
707         uint amountOutMin,
708         address[] calldata path,
709         address to,
710         uint deadline
711     )
712         external
713         virtual
714         override
715         ensure(deadline)
716     {
717         require(path[path.length - 1] == NBU_WBNB, 'NimbusRouter: INVALID_PATH');
718         TransferHelper.safeTransferFrom(
719             path[0], msg.sender, NimbusLibrary.pairFor(factory, path[0], path[1]), amountIn
720         );
721         _swapSupportingFeeOnTransferTokens(path, address(this));
722         uint amountOut = IBEP20(NBU_WBNB).balanceOf(address(this));
723         require(amountOut >= amountOutMin, 'NimbusRouter: INSUFFICIENT_OUTPUT_AMOUNT');
724         INBU_WBNB(NBU_WBNB).withdraw(amountOut);
725         TransferHelper.safeTransferBNB(to, amountOut);
726     }
727 
728     // **** LIBRARY FUNCTIONS ****
729     function quote(uint amountA, uint reserveA, uint reserveB) public pure virtual override returns (uint amountB) {
730         return NimbusLibrary.quote(amountA, reserveA, reserveB);
731     }
732 
733     function pairFor(address tokenA, address tokenB) external view returns (address) {
734         return NimbusLibrary.pairFor(factory, tokenA, tokenB);
735     }
736 
737     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut)
738         public
739         pure
740         virtual
741         override
742         returns (uint amountOut)
743     {
744         return NimbusLibrary.getAmountOut(amountIn, reserveIn, reserveOut);
745     }
746 
747     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut)
748         public
749         pure
750         virtual
751         override
752         returns (uint amountIn)
753     {
754         return NimbusLibrary.getAmountIn(amountOut, reserveIn, reserveOut);
755     }
756 
757     function getAmountsOut(uint amountIn, address[] memory path)
758         public
759         view
760         virtual
761         override
762         returns (uint[] memory amounts)
763     {
764         return NimbusLibrary.getAmountsOut(factory, amountIn, path);
765     }
766 
767     function getAmountsIn(uint amountOut, address[] memory path)
768         public
769         view
770         virtual
771         override
772         returns (uint[] memory amounts)
773     {
774         return NimbusLibrary.getAmountsIn(factory, amountOut, path);
775     }
776 }