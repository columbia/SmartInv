1 // File: @sashimiswap/core/contracts/interfaces/IUniswapV2Factory.sol
2 
3 pragma solidity >=0.5.0;
4 
5 interface IUniswapV2Factory {
6     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
7 
8     function feeTo() external view returns (address);
9     function feeToSetter() external view returns (address);
10     function migrator() external view returns (address);
11 
12     function getPair(address tokenA, address tokenB) external view returns (address pair);
13     function allPairs(uint) external view returns (address pair);
14     function allPairsLength() external view returns (uint);
15 
16     function createPair(address tokenA, address tokenB) external returns (address pair);
17 
18     function setFeeTo(address) external;
19     function setFeeToSetter(address) external;
20     function setMigrator(address) external;
21 }
22 
23 // File: @uniswap/lib/contracts/libraries/TransferHelper.sol
24 
25 pragma solidity >=0.6.0;
26 
27 // helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
28 library TransferHelper {
29     function safeApprove(address token, address to, uint value) internal {
30         // bytes4(keccak256(bytes('approve(address,uint256)')));
31         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
32         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
33     }
34 
35     function safeTransfer(address token, address to, uint value) internal {
36         // bytes4(keccak256(bytes('transfer(address,uint256)')));
37         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
38         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
39     }
40 
41     function safeTransferFrom(address token, address from, address to, uint value) internal {
42         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
43         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
44         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
45     }
46 
47     function safeTransferETH(address to, uint value) internal {
48         (bool success,) = to.call{value:value}(new bytes(0));
49         require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
50     }
51 }
52 
53 // File: contracts/interfaces/IUniswapV2Router01.sol
54 
55 pragma solidity >=0.6.2;
56 
57 interface IUniswapV2Router01 {
58     function factory() external pure returns (address);
59     function WETH() external pure returns (address);
60 
61     function addLiquidity(
62         address tokenA,
63         address tokenB,
64         uint amountADesired,
65         uint amountBDesired,
66         uint amountAMin,
67         uint amountBMin,
68         address to,
69         uint deadline
70     ) external returns (uint amountA, uint amountB, uint liquidity);
71     function addLiquidityETH(
72         address token,
73         uint amountTokenDesired,
74         uint amountTokenMin,
75         uint amountETHMin,
76         address to,
77         uint deadline
78     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
79     function removeLiquidity(
80         address tokenA,
81         address tokenB,
82         uint liquidity,
83         uint amountAMin,
84         uint amountBMin,
85         address to,
86         uint deadline
87     ) external returns (uint amountA, uint amountB);
88     function removeLiquidityETH(
89         address token,
90         uint liquidity,
91         uint amountTokenMin,
92         uint amountETHMin,
93         address to,
94         uint deadline
95     ) external returns (uint amountToken, uint amountETH);
96     function removeLiquidityWithPermit(
97         address tokenA,
98         address tokenB,
99         uint liquidity,
100         uint amountAMin,
101         uint amountBMin,
102         address to,
103         uint deadline,
104         bool approveMax, uint8 v, bytes32 r, bytes32 s
105     ) external returns (uint amountA, uint amountB);
106     function removeLiquidityETHWithPermit(
107         address token,
108         uint liquidity,
109         uint amountTokenMin,
110         uint amountETHMin,
111         address to,
112         uint deadline,
113         bool approveMax, uint8 v, bytes32 r, bytes32 s
114     ) external returns (uint amountToken, uint amountETH);
115     function swapExactTokensForTokens(
116         uint amountIn,
117         uint amountOutMin,
118         address[] calldata path,
119         address to,
120         uint deadline
121     ) external returns (uint[] memory amounts);
122     function swapTokensForExactTokens(
123         uint amountOut,
124         uint amountInMax,
125         address[] calldata path,
126         address to,
127         uint deadline
128     ) external returns (uint[] memory amounts);
129     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
130         external
131         payable
132         returns (uint[] memory amounts);
133     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
134         external
135         returns (uint[] memory amounts);
136     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
137         external
138         returns (uint[] memory amounts);
139     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
140         external
141         payable
142         returns (uint[] memory amounts);
143 
144     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
145     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
146     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
147     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
148     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
149 }
150 
151 // File: contracts/interfaces/IUniswapV2Router02.sol
152 
153 pragma solidity >=0.6.2;
154 
155 
156 interface IUniswapV2Router02 is IUniswapV2Router01 {
157     function vault() external pure returns (address);
158     function owner() external pure returns (address);
159     function removeLiquidityETHSupportingFeeOnTransferTokens(
160         address token,
161         uint liquidity,
162         uint amountTokenMin,
163         uint amountETHMin,
164         address to,
165         uint deadline
166     ) external returns (uint amountETH);
167     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
168         address token,
169         uint liquidity,
170         uint amountTokenMin,
171         uint amountETHMin,
172         address to,
173         uint deadline,
174         bool approveMax, uint8 v, bytes32 r, bytes32 s
175     ) external returns (uint amountETH);
176 
177     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
178         uint amountIn,
179         uint amountOutMin,
180         address[] calldata path,
181         address to,
182         uint deadline
183     ) external;
184     function swapExactETHForTokensSupportingFeeOnTransferTokens(
185         uint amountOutMin,
186         address[] calldata path,
187         address to,
188         uint deadline
189     ) external payable;
190     function swapExactTokensForETHSupportingFeeOnTransferTokens(
191         uint amountIn,
192         uint amountOutMin,
193         address[] calldata path,
194         address to,
195         uint deadline
196     ) external;
197     function changeOwner(
198         address vaultAddress
199     ) external;
200     function setVault(
201         address vaultAddress
202     ) external;
203     function take(
204         address token, 
205         uint amount
206     ) external;
207     function getTokenInPair(address pair, address token) external view returns (uint balance);    
208 }
209 
210 // File: @sashimiswap/core/contracts/interfaces/IUniswapV2Pair.sol
211 
212 pragma solidity >=0.5.0;
213 
214 interface IUniswapV2Pair {
215     event Approval(address indexed owner, address indexed spender, uint value);
216     event Transfer(address indexed from, address indexed to, uint value);
217 
218     function name() external pure returns (string memory);
219     function symbol() external pure returns (string memory);
220     function decimals() external pure returns (uint8);
221     function totalSupply() external view returns (uint);
222     function balanceOf(address owner) external view returns (uint);
223     function allowance(address owner, address spender) external view returns (uint);
224 
225     function approve(address spender, uint value) external returns (bool);
226     function transfer(address to, uint value) external returns (bool);
227     function transferFrom(address from, address to, uint value) external returns (bool);
228 
229     function DOMAIN_SEPARATOR() external view returns (bytes32);
230     function PERMIT_TYPEHASH() external pure returns (bytes32);
231     function nonces(address owner) external view returns (uint);
232 
233     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
234 
235     event Mint(address indexed sender, uint amount0, uint amount1);
236     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
237     event Swap(
238         address indexed sender,
239         uint amount0In,
240         uint amount1In,
241         uint amount0Out,
242         uint amount1Out,
243         address indexed to
244     );
245     event Sync(uint112 reserve0, uint112 reserve1);
246 
247     function MINIMUM_LIQUIDITY() external pure returns (uint);
248     function factory() external view returns (address);
249     function token0() external view returns (address);
250     function token1() external view returns (address);
251     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
252     function price0CumulativeLast() external view returns (uint);
253     function price1CumulativeLast() external view returns (uint);
254     function kLast() external view returns (uint);
255 
256     function mint(address to) external returns (uint liquidity);
257     function burn(address to) external returns (uint amount0, uint amount1);
258     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
259     function skim(address to) external;
260     function sync() external;
261 
262     function initialize(address, address, address) external;
263 }
264 
265 // File: contracts/libraries/SafeMath.sol
266 
267 pragma solidity >=0.6.6;
268 
269 // a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)
270 
271 library SafeMath {
272     function add(uint x, uint y) internal pure returns (uint z) {
273         require((z = x + y) >= x, 'ds-math-add-overflow');
274     }
275 
276     function sub(uint x, uint y) internal pure returns (uint z) {
277         require((z = x - y) <= x, 'ds-math-sub-underflow');
278     }
279 
280     function mul(uint x, uint y) internal pure returns (uint z) {
281         require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');
282     }
283 }
284 
285 // File: contracts/libraries/UniswapV2Library.sol
286 
287 pragma solidity >=0.5.0;
288 
289 
290 
291 library UniswapV2Library {
292     using SafeMath for uint;
293 
294     // returns sorted token addresses, used to handle return values from pairs sorted in this order
295     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
296         require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');
297         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
298         require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');
299     }
300 
301     // calculates the CREATE2 address for a pair without making any external calls
302     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
303         (address token0, address token1) = sortTokens(tokenA, tokenB);
304         pair = address(uint(keccak256(abi.encodePacked(
305                 hex'ff',
306                 factory,
307                 keccak256(abi.encodePacked(token0, token1)),
308                 hex'b465bbe4edb8c9b0da8ff0b2b36ce0065de9fcd5a33f32c6856ea821779c8b72' // init code hash
309             ))));
310     }
311 
312     // fetches and sorts the reserves for a pair
313     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
314         (address token0,) = sortTokens(tokenA, tokenB);
315         (uint reserve0, uint reserve1,) = IUniswapV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();
316         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
317     }
318 
319     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
320     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
321         require(amountA > 0, 'UniswapV2Library: INSUFFICIENT_AMOUNT');
322         require(reserveA > 0 && reserveB > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
323         amountB = amountA.mul(reserveB) / reserveA;
324     }
325 
326     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
327     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
328         require(amountIn > 0, 'UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT');
329         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
330         uint amountInWithFee = amountIn.mul(997);
331         uint numerator = amountInWithFee.mul(reserveOut);
332         uint denominator = reserveIn.mul(1000).add(amountInWithFee);
333         amountOut = numerator / denominator;
334     }
335 
336     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
337     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {
338         require(amountOut > 0, 'UniswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT');
339         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
340         uint numerator = reserveIn.mul(amountOut).mul(1000);
341         uint denominator = reserveOut.sub(amountOut).mul(997);
342         amountIn = (numerator / denominator).add(1);
343     }
344 
345     // performs chained getAmountOut calculations on any number of pairs
346     function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {
347         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
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
358         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
359         amounts = new uint[](path.length);
360         amounts[amounts.length - 1] = amountOut;
361         for (uint i = path.length - 1; i > 0; i--) {
362             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);
363             amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
364         }
365     }
366 }
367 
368 // File: contracts/interfaces/IERC20.sol
369 
370 pragma solidity >=0.5.0;
371 
372 interface IERC20 {
373     event Approval(address indexed owner, address indexed spender, uint value);
374     event Transfer(address indexed from, address indexed to, uint value);
375 
376     function name() external view returns (string memory);
377     function symbol() external view returns (string memory);
378     function decimals() external view returns (uint8);
379     function totalSupply() external view returns (uint);
380     function balanceOf(address owner) external view returns (uint);
381     function allowance(address owner, address spender) external view returns (uint);
382 
383     function approve(address spender, uint value) external returns (bool);
384     function transfer(address to, uint value) external returns (bool);
385     function transferFrom(address from, address to, uint value) external returns (bool);
386 }
387 
388 // File: contracts/interfaces/IWETH.sol
389 
390 pragma solidity >=0.5.0;
391 
392 interface IWETH {
393     function deposit() external payable;
394     function transfer(address to, uint value) external returns (bool);
395     function withdraw(uint) external;
396 }
397 
398 // File: contracts/interfaces/ISashimiInvestment.sol
399 
400 pragma solidity >=0.5.0;
401 
402 interface ISashimiInvestment {
403     function withdraw(address token, uint256 amount) external;
404     function withdrawWithReBalance(address token, uint256 amount) external;
405 }
406 
407 // File: contracts/UniswapV2Router02.sol
408 
409 pragma solidity >=0.6.6;
410 
411 
412 
413 
414 
415 
416 
417 
418 
419 contract UniswapV2Router02 is IUniswapV2Router02 {
420     using SafeMath for uint;
421 
422     address public immutable override factory;
423     address public immutable override WETH;
424     address public override vault;
425     address public override owner;
426     mapping(address => mapping(address => uint)) private _pools;
427 
428     modifier ensure(uint deadline) {
429         require(deadline >= block.timestamp, 'UniswapV2Router: EXPIRED');
430         _;
431     }
432 
433     constructor(address _factory, address _WETH) public {
434         factory = _factory;
435         owner = msg.sender;
436         WETH = _WETH;
437     }
438 
439     receive() external payable {
440         assert(msg.sender == WETH); // only accept ETH via fallback from the WETH contract
441     }
442 
443     function _transferOut(address pair, address token, uint amount, address to) internal returns (bool success){
444         require(_pools[pair][token] >= amount, 'TransferHelper: TRANSFER_OUT_FAILED');
445         _pools[pair][token] = _pools[pair][token].sub(amount);
446         if(to != address(this)){
447             uint balance = IERC20(token).balanceOf(address(this));
448             if(balance < amount){
449                 ISashimiInvestment(vault).withdrawWithReBalance(token, amount.sub(balance));
450             }
451             TransferHelper.safeTransfer(token, to, amount);
452         }
453         return true;
454     }
455     function _safeTransfer(address token, address to, uint amount) internal {
456         uint balance = IERC20(token).balanceOf(address(this));
457         if(balance < amount){
458             ISashimiInvestment(vault).withdrawWithReBalance(token, amount.sub(balance));
459         }
460         TransferHelper.safeTransfer(token, to, amount);
461     }
462     function _transferETH(address to, uint amount) internal {
463         uint balance = IERC20(WETH).balanceOf(address(this));
464         if(balance < amount){
465             ISashimiInvestment(vault).withdrawWithReBalance(WETH, amount.sub(balance));
466         }
467         IWETH(WETH).withdraw(amount);
468         TransferHelper.safeTransferETH(to, amount);
469     }
470 
471     function _transferIn(address from,address pair, address token, uint amount) internal {
472         uint beforeBalance = IERC20(token).balanceOf(address(this));
473         TransferHelper.safeTransferFrom(token, from, address(this), amount);
474         _pools[pair][token] = _pools[pair][token].add(IERC20(token).balanceOf(address(this))).sub(beforeBalance);
475     }
476     function _transferInETH(address pair, uint amount) internal {
477         _pools[pair][WETH] = _pools[pair][WETH].add(amount);
478         IWETH(WETH).deposit{value: amount}();
479     }
480 
481     // **** ADD LIQUIDITY ****
482     function _addLiquidity(
483         address tokenA,
484         address tokenB,
485         uint amountADesired,
486         uint amountBDesired,
487         uint amountAMin,
488         uint amountBMin
489     ) internal virtual returns (uint amountA, uint amountB) {
490         // create the pair if it doesn't exist yet
491         if (IUniswapV2Factory(factory).getPair(tokenA, tokenB) == address(0)) {
492             IUniswapV2Factory(factory).createPair(tokenA, tokenB);
493         }
494         (uint reserveA, uint reserveB) = UniswapV2Library.getReserves(factory, tokenA, tokenB);
495         if (reserveA == 0 && reserveB == 0) {
496             (amountA, amountB) = (amountADesired, amountBDesired);
497         } else {
498             uint amountBOptimal = UniswapV2Library.quote(amountADesired, reserveA, reserveB);
499             if (amountBOptimal <= amountBDesired) {
500                 require(amountBOptimal >= amountBMin, 'UniswapV2Router: INSUFFICIENT_B_AMOUNT');
501                 (amountA, amountB) = (amountADesired, amountBOptimal);
502             } else {
503                 uint amountAOptimal = UniswapV2Library.quote(amountBDesired, reserveB, reserveA);
504                 assert(amountAOptimal <= amountADesired);
505                 require(amountAOptimal >= amountAMin, 'UniswapV2Router: INSUFFICIENT_A_AMOUNT');
506                 (amountA, amountB) = (amountAOptimal, amountBDesired);
507             }
508         }
509     }
510     function addLiquidity(
511         address tokenA,
512         address tokenB,
513         uint amountADesired,
514         uint amountBDesired,
515         uint amountAMin,
516         uint amountBMin,
517         address to,
518         uint deadline
519     ) external virtual override ensure(deadline) returns (uint amountA, uint amountB, uint liquidity) {
520         (amountA, amountB) = _addLiquidity(tokenA, tokenB, amountADesired, amountBDesired, amountAMin, amountBMin);
521         address pair = UniswapV2Library.pairFor(factory, tokenA, tokenB);
522         _transferIn(msg.sender, pair, tokenA, amountA);
523         _transferIn(msg.sender, pair, tokenB, amountB);
524         liquidity = IUniswapV2Pair(pair).mint(to);
525     }
526     function addLiquidityETH(
527         address token,
528         uint amountTokenDesired,
529         uint amountTokenMin,
530         uint amountETHMin,
531         address to,
532         uint deadline
533     ) external virtual override payable ensure(deadline) returns (uint amountToken, uint amountETH, uint liquidity) {
534         (amountToken, amountETH) = _addLiquidity(
535             token,
536             WETH,
537             amountTokenDesired,
538             msg.value,
539             amountTokenMin,
540             amountETHMin
541         );
542         address pair = UniswapV2Library.pairFor(factory, token, WETH);
543         _transferIn(msg.sender,pair,token,amountToken);
544         _transferInETH(pair, amountETH);
545         liquidity = IUniswapV2Pair(pair).mint(to);
546         // refund dust eth, if any
547         if (msg.value > amountETH) TransferHelper.safeTransferETH(msg.sender, msg.value - amountETH);
548     }
549 
550     // **** REMOVE LIQUIDITY ****
551     function removeLiquidity(
552         address tokenA,
553         address tokenB,
554         uint liquidity,
555         uint amountAMin,
556         uint amountBMin,
557         address to,
558         uint deadline
559     ) public virtual override ensure(deadline) returns (uint amountA, uint amountB) {
560         address pair = UniswapV2Library.pairFor(factory, tokenA, tokenB);
561         IUniswapV2Pair(pair).transferFrom(msg.sender, pair, liquidity); // send liquidity to pair
562         (uint amount0, uint amount1) = IUniswapV2Pair(pair).burn(to);
563         (address token0,) = UniswapV2Library.sortTokens(tokenA, tokenB);
564         (amountA, amountB) = tokenA == token0 ? (amount0, amount1) : (amount1, amount0);
565         _transferOut(pair,tokenA,amountA, to);
566         _transferOut(pair,tokenB,amountB, to);
567         require(amountA >= amountAMin, 'UniswapV2Router: INSUFFICIENT_A_AMOUNT');
568         require(amountB >= amountBMin, 'UniswapV2Router: INSUFFICIENT_B_AMOUNT');
569     }
570     function removeLiquidityETH(
571         address token,
572         uint liquidity,
573         uint amountTokenMin,
574         uint amountETHMin,
575         address to,
576         uint deadline
577     ) public virtual override ensure(deadline) returns (uint amountToken, uint amountETH) {
578         (amountToken, amountETH) = removeLiquidity(
579             token,
580             WETH,
581             liquidity,
582             amountTokenMin,
583             amountETHMin,
584             address(this),
585             deadline
586         );
587         _safeTransfer(token, to, amountToken);
588         _transferETH(to,amountETH);
589     }
590     function removeLiquidityWithPermit(
591         address tokenA,
592         address tokenB,
593         uint liquidity,
594         uint amountAMin,
595         uint amountBMin,
596         address to,
597         uint deadline,
598         bool approveMax, uint8 v, bytes32 r, bytes32 s
599     ) external virtual override returns (uint amountA, uint amountB) {
600         address pair = UniswapV2Library.pairFor(factory, tokenA, tokenB);
601         uint value = approveMax ? uint(-1) : liquidity;
602         IUniswapV2Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
603         (amountA, amountB) = removeLiquidity(tokenA, tokenB, liquidity, amountAMin, amountBMin, to, deadline);
604     }
605     function removeLiquidityETHWithPermit(
606         address token,
607         uint liquidity,
608         uint amountTokenMin,
609         uint amountETHMin,
610         address to,
611         uint deadline,
612         bool approveMax, uint8 v, bytes32 r, bytes32 s
613     ) external virtual override returns (uint amountToken, uint amountETH) {
614         address pair = UniswapV2Library.pairFor(factory, token, WETH);
615         uint value = approveMax ? uint(-1) : liquidity;
616         IUniswapV2Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
617         (amountToken, amountETH) = removeLiquidityETH(token, liquidity, amountTokenMin, amountETHMin, to, deadline);
618     }
619 
620     // **** REMOVE LIQUIDITY (supporting fee-on-transfer tokens) ****
621     function removeLiquidityETHSupportingFeeOnTransferTokens(
622         address token,
623         uint liquidity,
624         uint amountTokenMin,
625         uint amountETHMin,
626         address to,
627         uint deadline
628     ) public virtual override ensure(deadline) returns (uint amountETH) {
629         address pair = UniswapV2Library.pairFor(factory, token, WETH);
630         uint beforeBalance = getTokenInPair(pair,token);
631         (, amountETH) = removeLiquidity(
632             token,
633             WETH,
634             liquidity,
635             amountTokenMin,
636             amountETHMin,
637             address(this),
638             deadline
639         );
640         _safeTransfer(token, to, beforeBalance.sub(getTokenInPair(pair,token)));
641         _transferETH(to, amountETH);
642     }
643     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
644         address token,
645         uint liquidity,
646         uint amountTokenMin,
647         uint amountETHMin,
648         address to,
649         uint deadline,
650         bool approveMax, uint8 v, bytes32 r, bytes32 s
651     ) external virtual override returns (uint amountETH) {
652         address pair = UniswapV2Library.pairFor(factory, token, WETH);
653         uint value = approveMax ? uint(-1) : liquidity;
654         IUniswapV2Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
655         amountETH = removeLiquidityETHSupportingFeeOnTransferTokens(
656             token, liquidity, amountTokenMin, amountETHMin, to, deadline
657         );
658     }
659 
660     // **** SWAP ****
661     // requires the initial amount to have already been sent to the first pair
662     function _swap(uint[] memory amounts, address[] memory path, address _to) internal virtual {
663         for (uint i; i < path.length - 1; i++) {
664             (address input, address output) = (path[i], path[i + 1]);
665             (address token0,) = UniswapV2Library.sortTokens(input, output);
666             uint amountOut = amounts[i + 1];
667             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOut) : (amountOut, uint(0));
668             //address to = i < path.length - 2 ? UniswapV2Library.pairFor(factory, output, path[i + 2]) : _to;
669             address to = i < path.length - 2 ? address(this) : _to;
670             address pair = UniswapV2Library.pairFor(factory, input, output);
671             _transferOut(pair, output, amountOut, to);
672             if(i < path.length - 2){
673                 address nextPair = UniswapV2Library.pairFor(factory, output, path[i + 2]);
674                 _pools[nextPair][output]=_pools[nextPair][output].add(amountOut);
675             }
676             IUniswapV2Pair(pair).swap(
677                 amount0Out, amount1Out, to, new bytes(0)
678             );
679         }
680     }
681 
682     function swapExactTokensForTokens(
683         uint amountIn,
684         uint amountOutMin,
685         address[] calldata path,
686         address to,
687         uint deadline
688     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
689         amounts = UniswapV2Library.getAmountsOut(factory, amountIn, path);
690         require(amounts[amounts.length - 1] >= amountOutMin, 'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
691         _transferIn(msg.sender,UniswapV2Library.pairFor(factory, path[0], path[1]),path[0],amounts[0]);
692         _swap(amounts, path, to);
693     }
694     function swapTokensForExactTokens(
695         uint amountOut,
696         uint amountInMax,
697         address[] calldata path,
698         address to,
699         uint deadline
700     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
701         amounts = UniswapV2Library.getAmountsIn(factory, amountOut, path);
702         require(amounts[0] <= amountInMax, 'UniswapV2Router: EXCESSIVE_INPUT_AMOUNT');
703         _transferIn(msg.sender,UniswapV2Library.pairFor(factory, path[0], path[1]),path[0],amounts[0]);
704         _swap(amounts, path, to);
705     }
706     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
707         external
708         virtual
709         override
710         payable
711         ensure(deadline)
712         returns (uint[] memory amounts)
713     {
714         require(path[0] == WETH, 'UniswapV2Router: INVALID_PATH');
715         amounts = UniswapV2Library.getAmountsOut(factory, msg.value, path);
716         require(amounts[amounts.length - 1] >= amountOutMin, 'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
717          _transferInETH(UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]);
718         //assert(IWETH(WETH).transfer(UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]));
719         _swap(amounts, path, to);
720     }
721     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
722         external
723         virtual
724         override
725         ensure(deadline)
726         returns (uint[] memory amounts)
727     {
728         require(path[path.length - 1] == WETH, 'UniswapV2Router: INVALID_PATH');
729         amounts = UniswapV2Library.getAmountsIn(factory, amountOut, path);
730         require(amounts[0] <= amountInMax, 'UniswapV2Router: EXCESSIVE_INPUT_AMOUNT');
731         _transferIn(msg.sender,UniswapV2Library.pairFor(factory, path[0], path[1]),path[0],amounts[0]);
732         _swap(amounts, path, address(this));
733         _transferETH(to,amounts[amounts.length - 1]);
734     }
735     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
736         external
737         virtual
738         override
739         ensure(deadline)
740         returns (uint[] memory amounts)
741     {
742         require(path[path.length - 1] == WETH, 'UniswapV2Router: INVALID_PATH');
743         amounts = UniswapV2Library.getAmountsOut(factory, amountIn, path);
744         require(amounts[amounts.length - 1] >= amountOutMin, 'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
745         _transferIn(msg.sender,UniswapV2Library.pairFor(factory, path[0], path[1]),path[0],amounts[0]);
746         _swap(amounts, path, address(this));
747         _transferETH(to, amounts[amounts.length - 1]);
748     }
749     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
750         external
751         virtual
752         override
753         payable
754         ensure(deadline)
755         returns (uint[] memory amounts)
756     {
757         require(path[0] == WETH, 'UniswapV2Router: INVALID_PATH');
758         amounts = UniswapV2Library.getAmountsIn(factory, amountOut, path);
759         require(amounts[0] <= msg.value, 'UniswapV2Router: EXCESSIVE_INPUT_AMOUNT');
760         _transferInETH(UniswapV2Library.pairFor(factory, path[0], path[1]),amounts[0]);
761         //assert(IWETH(WETH).transfer(UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]));
762         _swap(amounts, path, to);
763         // refund dust eth, if any
764         if (msg.value > amounts[0]) TransferHelper.safeTransferETH(msg.sender, msg.value - amounts[0]);
765     }
766 
767     // **** SWAP (supporting fee-on-transfer tokens) ****
768     // requires the initial amount to have already been sent to the first pair
769     function _swapSupportingFeeOnTransferTokens(address[] memory path, address _to) internal virtual {
770         for (uint i; i < path.length - 1; i++) {
771             (address input, address output) = (path[i], path[i + 1]);
772             (address token0,) = UniswapV2Library.sortTokens(input, output);
773             IUniswapV2Pair pair = IUniswapV2Pair(UniswapV2Library.pairFor(factory, input, output));
774             uint amountInput;
775             uint amountOutput;
776             { // scope to avoid stack too deep errors
777             (uint reserve0, uint reserve1,) = pair.getReserves();
778             (uint reserveInput, uint reserveOutput) = input == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
779             amountInput = getTokenInPair(address(pair),input).sub(reserveInput);
780             amountOutput = UniswapV2Library.getAmountOut(amountInput, reserveInput, reserveOutput);
781             }
782             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOutput) : (amountOutput, uint(0));
783             address to = i < path.length - 2 ? address(this) : _to;
784             _transferOut(address(pair), output, amountOutput, to);
785             if(i < path.length - 2){
786                 address nextPair = UniswapV2Library.pairFor(factory, output, path[i + 2]);
787                 _pools[nextPair][output]=_pools[nextPair][output].add(amountOutput);
788             }
789             pair.swap(amount0Out, amount1Out, to, new bytes(0));
790         }
791     }
792     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
793         uint amountIn,
794         uint amountOutMin,
795         address[] calldata path,
796         address to,
797         uint deadline
798     ) external virtual override ensure(deadline) {
799         _transferIn(msg.sender,UniswapV2Library.pairFor(factory, path[0], path[1]),path[0],amountIn);
800         uint balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
801         _swapSupportingFeeOnTransferTokens(path, to);
802         require(
803             IERC20(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
804             'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT'
805         );
806     }
807     function swapExactETHForTokensSupportingFeeOnTransferTokens(
808         uint amountOutMin,
809         address[] calldata path,
810         address to,
811         uint deadline
812     )
813         external
814         virtual
815         override
816         payable
817         ensure(deadline)
818     {
819         require(path[0] == WETH, 'UniswapV2Router: INVALID_PATH');
820         uint amountIn = msg.value;        
821         _transferInETH(UniswapV2Library.pairFor(factory, path[0], path[1]),amountIn);
822         //assert(IWETH(WETH).transfer(UniswapV2Library.pairFor(factory, path[0], path[1]), amountIn));
823         uint balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
824         _swapSupportingFeeOnTransferTokens(path, to);
825         require(
826             IERC20(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
827             'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT'
828         );
829     }
830     function swapExactTokensForETHSupportingFeeOnTransferTokens(
831         uint amountIn,
832         uint amountOutMin,
833         address[] calldata path,
834         address to,
835         uint deadline
836     )
837         external
838         virtual
839         override
840         ensure(deadline)
841     {
842         require(path[path.length - 1] == WETH, 'UniswapV2Router: INVALID_PATH');
843         address pair = UniswapV2Library.pairFor(factory, path[0], path[1]);
844         _transferIn(msg.sender,pair,path[0],amountIn);
845         uint balanceBefore = getTokenInPair(pair,WETH);
846         _swapSupportingFeeOnTransferTokens(path, address(this));
847         uint balanceAfter = getTokenInPair(pair,WETH);
848         uint amountOut = balanceBefore.sub(balanceAfter);
849         require(amountOut >= amountOutMin, 'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
850         _transferETH(to, amountOut);
851     }
852 
853     function changeOwner(
854         address _owner
855     ) 
856     external
857     override
858     {
859         require(msg.sender == owner,'UniswapV2Router: FORBIDDEN');
860         owner = _owner;
861     }
862 
863     function setVault(
864         address vaultAddress
865     ) 
866         external
867         override
868     {
869         require(msg.sender == owner,'UniswapV2Router: FORBIDDEN');
870         vault = vaultAddress;
871     }
872 
873     function take(address token, uint amount) 
874         external
875         virtual
876         override
877     {
878         require(msg.sender == vault,'UniswapV2Router: FORBIDDEN');
879         TransferHelper.safeTransfer(token, vault, amount);
880     }
881 
882     function getTokenInPair(address pair,address token) 
883         public
884         view
885         virtual
886         override
887         returns (uint balance)
888     {
889         return _pools[pair][token];
890     }
891     // **** LIBRARY FUNCTIONS ****
892     function quote(uint amountA, uint reserveA, uint reserveB) public pure virtual override returns (uint amountB) {
893         return UniswapV2Library.quote(amountA, reserveA, reserveB);
894     }
895 
896     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut)
897         public
898         pure
899         virtual
900         override
901         returns (uint amountOut)
902     {
903         return UniswapV2Library.getAmountOut(amountIn, reserveIn, reserveOut);
904     }
905 
906     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut)
907         public
908         pure
909         virtual
910         override
911         returns (uint amountIn)
912     {
913         return UniswapV2Library.getAmountIn(amountOut, reserveIn, reserveOut);
914     }
915 
916     function getAmountsOut(uint amountIn, address[] memory path)
917         public
918         view
919         virtual
920         override
921         returns (uint[] memory amounts)
922     {
923         return UniswapV2Library.getAmountsOut(factory, amountIn, path);
924     }
925 
926     function getAmountsIn(uint amountOut, address[] memory path)
927         public
928         view
929         virtual
930         override
931         returns (uint[] memory amounts)
932     {
933         return UniswapV2Library.getAmountsIn(factory, amountOut, path);
934     }
935 }