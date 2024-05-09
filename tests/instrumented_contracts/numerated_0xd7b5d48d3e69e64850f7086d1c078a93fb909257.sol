1 // File: contracts/interfaces/ISumswapV2Factory.sol
2 
3 pragma solidity >=0.5.0;
4 
5 interface ISumswapV2Factory {
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
21 // File: contracts/libraries/TransferHelper.sol
22 
23 pragma solidity >=0.6.0;
24 
25 // helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
26 library TransferHelper {
27     function safeApprove(
28         address token,
29         address to,
30         uint256 value
31     ) internal {
32         // bytes4(keccak256(bytes('approve(address,uint256)')));
33         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
34         require(
35             success && (data.length == 0 || abi.decode(data, (bool))),
36             'TransferHelper::safeApprove: approve failed'
37         );
38     }
39 
40     function safeTransfer(
41         address token,
42         address to,
43         uint256 value
44     ) internal {
45         // bytes4(keccak256(bytes('transfer(address,uint256)')));
46         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
47         require(
48             success && (data.length == 0 || abi.decode(data, (bool))),
49             'TransferHelper::safeTransfer: transfer failed'
50         );
51     }
52 
53     function safeTransferFrom(
54         address token,
55         address from,
56         address to,
57         uint256 value
58     ) internal {
59         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
60         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
61         require(
62             success && (data.length == 0 || abi.decode(data, (bool))),
63             'TransferHelper::transferFrom: transferFrom failed'
64         );
65     }
66 
67     function safeTransferETH(address to, uint256 value) internal {
68         (bool success, ) = to.call{value: value}(new bytes(0));
69         require(success, 'TransferHelper::safeTransferETH: ETH transfer failed');
70     }
71 }
72 
73 // File: contracts/interfaces/ISumiswapV2Router01.sol
74 
75 pragma solidity >=0.6.2;
76 
77 interface ISumiswapV2Router01 {
78     function factory() external pure returns (address);
79     function WETH() external pure returns (address);
80 
81     function addLiquidity(
82         address tokenA,
83         address tokenB,
84         uint amountADesired,
85         uint amountBDesired,
86         uint amountAMin,
87         uint amountBMin,
88         address to,
89         uint deadline
90     ) external returns (uint amountA, uint amountB, uint liquidity);
91     function addLiquidityETH(
92         address token,
93         uint amountTokenDesired,
94         uint amountTokenMin,
95         uint amountETHMin,
96         address to,
97         uint deadline
98     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
99     function removeLiquidity(
100         address tokenA,
101         address tokenB,
102         uint liquidity,
103         uint amountAMin,
104         uint amountBMin,
105         address to,
106         uint deadline
107     ) external returns (uint amountA, uint amountB);
108     function removeLiquidityETH(
109         address token,
110         uint liquidity,
111         uint amountTokenMin,
112         uint amountETHMin,
113         address to,
114         uint deadline
115     ) external returns (uint amountToken, uint amountETH);
116     function removeLiquidityWithPermit(
117         address tokenA,
118         address tokenB,
119         uint liquidity,
120         uint amountAMin,
121         uint amountBMin,
122         address to,
123         uint deadline,
124         bool approveMax, uint8 v, bytes32 r, bytes32 s
125     ) external returns (uint amountA, uint amountB);
126     function removeLiquidityETHWithPermit(
127         address token,
128         uint liquidity,
129         uint amountTokenMin,
130         uint amountETHMin,
131         address to,
132         uint deadline,
133         bool approveMax, uint8 v, bytes32 r, bytes32 s
134     ) external returns (uint amountToken, uint amountETH);
135     function swapExactTokensForTokens(
136         uint amountIn,
137         uint amountOutMin,
138         address[] calldata path,
139         address to,
140         uint deadline
141     ) external returns (uint[] memory amounts);
142     function swapTokensForExactTokens(
143         uint amountOut,
144         uint amountInMax,
145         address[] calldata path,
146         address to,
147         uint deadline
148     ) external returns (uint[] memory amounts);
149     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
150         external
151         payable
152         returns (uint[] memory amounts);
153     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
154         external
155         returns (uint[] memory amounts);
156     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
157         external
158         returns (uint[] memory amounts);
159     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
160         external
161         payable
162         returns (uint[] memory amounts);
163 
164     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
165     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
166     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
167     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
168     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
169 }
170 
171 // File: contracts/interfaces/ISumswapV2Router02.sol
172 
173 pragma solidity >=0.6.2;
174 
175 
176 interface ISumswapV2Router02 is ISumiswapV2Router01 {
177     function removeLiquidityETHSupportingFeeOnTransferTokens(
178         address token,
179         uint liquidity,
180         uint amountTokenMin,
181         uint amountETHMin,
182         address to,
183         uint deadline
184     ) external returns (uint amountETH);
185     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
186         address token,
187         uint liquidity,
188         uint amountTokenMin,
189         uint amountETHMin,
190         address to,
191         uint deadline,
192         bool approveMax, uint8 v, bytes32 r, bytes32 s
193     ) external returns (uint amountETH);
194 
195     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
196         uint amountIn,
197         uint amountOutMin,
198         address[] calldata path,
199         address to,
200         uint deadline
201     ) external;
202     function swapExactETHForTokensSupportingFeeOnTransferTokens(
203         uint amountOutMin,
204         address[] calldata path,
205         address to,
206         uint deadline
207     ) external payable;
208     function swapExactTokensForETHSupportingFeeOnTransferTokens(
209         uint amountIn,
210         uint amountOutMin,
211         address[] calldata path,
212         address to,
213         uint deadline
214     ) external;
215 }
216 
217 // File: contracts/interfaces/ISumiswapV2Pair.sol
218 
219 pragma solidity >=0.5.0;
220 
221 interface ISumiswapV2Pair {
222     event Approval(address indexed owner, address indexed spender, uint value);
223     event Transfer(address indexed from, address indexed to, uint value);
224 
225     function name() external pure returns (string memory);
226     function symbol() external pure returns (string memory);
227     function decimals() external pure returns (uint8);
228     function totalSupply() external view returns (uint);
229     function balanceOf(address owner) external view returns (uint);
230     function allowance(address owner, address spender) external view returns (uint);
231 
232     function approve(address spender, uint value) external returns (bool);
233     function transfer(address to, uint value) external returns (bool);
234     function transferFrom(address from, address to, uint value) external returns (bool);
235 
236     function DOMAIN_SEPARATOR() external view returns (bytes32);
237     function PERMIT_TYPEHASH() external pure returns (bytes32);
238     function nonces(address owner) external view returns (uint);
239 
240     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
241 
242     event Mint(address indexed sender, uint amount0, uint amount1);
243     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
244     event Swap(
245         address indexed sender,
246         uint amount0In,
247         uint amount1In,
248         uint amount0Out,
249         uint amount1Out,
250         address indexed to
251     );
252     event Sync(uint112 reserve0, uint112 reserve1);
253 
254     function MINIMUM_LIQUIDITY() external pure returns (uint);
255     function factory() external view returns (address);
256     function token0() external view returns (address);
257     function token1() external view returns (address);
258     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
259     function price0CumulativeLast() external view returns (uint);
260     function price1CumulativeLast() external view returns (uint);
261     function kLast() external view returns (uint);
262 
263     function mint(address to) external returns (uint liquidity);
264     function burn(address to) external returns (uint amount0, uint amount1);
265     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
266     function skim(address to) external;
267     function sync() external;
268 
269     function initialize(address, address) external;
270 }
271 
272 // File: contracts/libraries/SafeMathSumswap.sol
273 
274 pragma solidity >=0.6.6;
275 
276 // a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)
277 
278 library SafeMathSumswap {
279     function add(uint x, uint y) internal pure returns (uint z) {
280         require((z = x + y) >= x, 'ds-math-add-overflow');
281     }
282 
283     function sub(uint x, uint y) internal pure returns (uint z) {
284         require((z = x - y) <= x, 'ds-math-sub-underflow');
285     }
286 
287     function mul(uint x, uint y) internal pure returns (uint z) {
288         require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');
289     }
290 }
291 
292 // File: contracts/libraries/SumswapV2Library.sol
293 
294 pragma solidity >=0.5.0;
295 
296 
297 
298 library SumswapV2Library {
299     using SafeMathSumswap for uint;
300 
301     // returns sorted token addresses, used to handle return values from pairs sorted in this order
302     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
303         require(tokenA != tokenB, 'SumswapV2Library: IDENTICAL_ADDRESSES');
304         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
305         require(token0 != address(0), 'SumswapV2Library: ZERO_ADDRESS');
306     }
307 
308     // calculates the CREATE2 address for a pair without making any external calls
309     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
310         (address token0, address token1) = sortTokens(tokenA, tokenB);
311         pair = address(uint(keccak256(abi.encodePacked(
312                 hex'ff',
313                 factory,
314                 keccak256(abi.encodePacked(token0, token1)),
315                 hex'faac9b01131e6030edb52a46a89c730d78d48f9fefa069bb474360705066e9fb' // init code hash
316             ))));
317     }
318 
319     // fetches and sorts the reserves for a pair
320     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
321         (address token0,) = sortTokens(tokenA, tokenB);
322         (uint reserve0, uint reserve1,) = ISumiswapV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();
323         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
324     }
325 
326     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
327     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
328         require(amountA > 0, 'SumswapV2Library: INSUFFICIENT_AMOUNT');
329         require(reserveA > 0 && reserveB > 0, 'SumswapV2Library: INSUFFICIENT_LIQUIDITY');
330         amountB = amountA.mul(reserveB) / reserveA;
331     }
332 
333     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
334     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
335         require(amountIn > 0, 'SumswapV2Library: INSUFFICIENT_INPUT_AMOUNT');
336         require(reserveIn > 0 && reserveOut > 0, 'SumswapV2Library: INSUFFICIENT_LIQUIDITY');
337         uint amountInWithFee = amountIn.mul(997);
338         uint numerator = amountInWithFee.mul(reserveOut);
339         uint denominator = reserveIn.mul(1000).add(amountInWithFee);
340         amountOut = numerator / denominator;
341     }
342 
343     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
344     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {
345         require(amountOut > 0, 'SumswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT');
346         require(reserveIn > 0 && reserveOut > 0, 'SumswapV2Library: INSUFFICIENT_LIQUIDITY');
347         uint numerator = reserveIn.mul(amountOut).mul(1000);
348         uint denominator = reserveOut.sub(amountOut).mul(997);
349         amountIn = (numerator / denominator).add(1);
350     }
351 
352     // performs chained getAmountOut calculations on any number of pairs
353     function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {
354         require(path.length >= 2, 'SumswapV2Library: INVALID_PATH');
355         amounts = new uint[](path.length);
356         amounts[0] = amountIn;
357         for (uint i; i < path.length - 1; i++) {
358             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);
359             amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
360         }
361     }
362 
363     // performs chained getAmountIn calculations on any number of pairs
364     function getAmountsIn(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {
365         require(path.length >= 2, 'SumswapV2Library: INVALID_PATH');
366         amounts = new uint[](path.length);
367         amounts[amounts.length - 1] = amountOut;
368         for (uint i = path.length - 1; i > 0; i--) {
369             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);
370             amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
371         }
372     }
373 }
374 
375 // File: contracts/interfaces/IERC20Sumswap.sol
376 
377 pragma solidity >=0.5.0;
378 
379 interface IERC20Sumswap{
380     event Approval(address indexed owner, address indexed spender, uint value);
381     event Transfer(address indexed from, address indexed to, uint value);
382 
383     function name() external view returns (string memory);
384     function symbol() external view returns (string memory);
385     function decimals() external view returns (uint8);
386     function totalSupply() external view returns (uint);
387     function balanceOf(address owner) external view returns (uint);
388     function allowance(address owner, address spender) external view returns (uint);
389 
390     function approve(address spender, uint value) external returns (bool);
391     function transfer(address to, uint value) external returns (bool);
392     function transferFrom(address from, address to, uint value) external returns (bool);
393 }
394 
395 // File: contracts/interfaces/IWETH.sol
396 
397 pragma solidity >=0.5.0;
398 
399 interface IWETH {
400     function deposit() external payable;
401     function transfer(address to, uint value) external returns (bool);
402     function withdraw(uint) external;
403 }
404 
405 // File: @openzeppelin/contracts/GSN/Context.sol
406 
407 
408 
409 pragma solidity >=0.6.0 <0.8.0;
410 
411 /*
412  * @dev Provides information about the current execution context, including the
413  * sender of the transaction and its data. While these are generally available
414  * via msg.sender and msg.data, they should not be accessed in such a direct
415  * manner, since when dealing with GSN meta-transactions the account sending and
416  * paying for execution may not be the actual sender (as far as an application
417  * is concerned).
418  *
419  * This contract is only required for intermediate, library-like contracts.
420  */
421 abstract contract Context {
422     function _msgSender() internal view virtual returns (address payable) {
423         return msg.sender;
424     }
425 
426     function _msgData() internal view virtual returns (bytes memory) {
427         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
428         return msg.data;
429     }
430 }
431 
432 // File: @openzeppelin/contracts/access/Ownable.sol
433 
434 
435 
436 pragma solidity >=0.6.0 <0.8.0;
437 
438 /**
439  * @dev Contract module which provides a basic access control mechanism, where
440  * there is an account (an owner) that can be granted exclusive access to
441  * specific functions.
442  *
443  * By default, the owner account will be the one that deploys the contract. This
444  * can later be changed with {transferOwnership}.
445  *
446  * This module is used through inheritance. It will make available the modifier
447  * `onlyOwner`, which can be applied to your functions to restrict their use to
448  * the owner.
449  */
450 abstract contract Ownable is Context {
451     address private _owner;
452 
453     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
454 
455     /**
456      * @dev Initializes the contract setting the deployer as the initial owner.
457      */
458     constructor () internal {
459         address msgSender = _msgSender();
460         _owner = msgSender;
461         emit OwnershipTransferred(address(0), msgSender);
462     }
463 
464     /**
465      * @dev Returns the address of the current owner.
466      */
467     function owner() public view returns (address) {
468         return _owner;
469     }
470 
471     /**
472      * @dev Throws if called by any account other than the owner.
473      */
474     modifier onlyOwner() {
475         require(_owner == _msgSender(), "Ownable: caller is not the owner");
476         _;
477     }
478 
479     /**
480      * @dev Leaves the contract without owner. It will not be possible to call
481      * `onlyOwner` functions anymore. Can only be called by the current owner.
482      *
483      * NOTE: Renouncing ownership will leave the contract without an owner,
484      * thereby removing any functionality that is only available to the owner.
485      */
486     function renounceOwnership() public virtual onlyOwner {
487         emit OwnershipTransferred(_owner, address(0));
488         _owner = address(0);
489     }
490 
491     /**
492      * @dev Transfers ownership of the contract to a new account (`newOwner`).
493      * Can only be called by the current owner.
494      */
495     function transferOwnership(address newOwner) public virtual onlyOwner {
496         require(newOwner != address(0), "Ownable: new owner is the zero address");
497         emit OwnershipTransferred(_owner, newOwner);
498         _owner = newOwner;
499     }
500 }
501 
502 // File: contracts/SumswapV2Router02.sol
503 
504 pragma solidity >=0.6.6;
505 
506 
507 
508 
509 
510 
511 
512 
513 
514 contract SumswapV2Router02 is ISumswapV2Router02,Ownable {
515     using SafeMathSumswap for uint;
516 
517     address public immutable override factory;
518     address public immutable override WETH;
519     bool public open = false;
520 
521     modifier ensure(uint deadline) {
522         require(deadline >= block.timestamp, 'SumswapV2Router: EXPIRED');
523         _;
524     }
525 
526     constructor(address _factory, address _WETH) public {
527         factory = _factory;
528         WETH = _WETH;
529     }
530 
531     receive() external payable {
532         assert(msg.sender == WETH); // only accept ETH via fallback from the WETH contract
533     }
534 
535     // **** ADD LIQUIDITY ****
536     function _addLiquidity(
537         address tokenA,
538         address tokenB,
539         uint amountADesired,
540         uint amountBDesired,
541         uint amountAMin,
542         uint amountBMin
543     ) internal virtual returns (uint amountA, uint amountB) {
544         // create the pair if it doesn't exist yet
545         if (ISumswapV2Factory(factory).getPair(tokenA, tokenB) == address(0)) {
546             if(!open){
547                 require(msg.sender == owner(), 'not owner');
548             }
549             ISumswapV2Factory(factory).createPair(tokenA, tokenB);
550         }
551         (uint reserveA, uint reserveB) = SumswapV2Library.getReserves(factory, tokenA, tokenB);
552         if (reserveA == 0 && reserveB == 0) {
553             (amountA, amountB) = (amountADesired, amountBDesired);
554         } else {
555             uint amountBOptimal = SumswapV2Library.quote(amountADesired, reserveA, reserveB);
556             if (amountBOptimal <= amountBDesired) {
557                 require(amountBOptimal >= amountBMin, 'SumswapV2Router: INSUFFICIENT_B_AMOUNT');
558                 (amountA, amountB) = (amountADesired, amountBOptimal);
559             } else {
560                 uint amountAOptimal = SumswapV2Library.quote(amountBDesired, reserveB, reserveA);
561                 assert(amountAOptimal <= amountADesired);
562                 require(amountAOptimal >= amountAMin, 'SumswapV2Router: INSUFFICIENT_A_AMOUNT');
563                 (amountA, amountB) = (amountAOptimal, amountBDesired);
564             }
565         }
566     }
567     function addLiquidity(
568         address tokenA,
569         address tokenB,
570         uint amountADesired,
571         uint amountBDesired,
572         uint amountAMin,
573         uint amountBMin,
574         address to,
575         uint deadline
576     ) external virtual override ensure(deadline) returns (uint amountA, uint amountB, uint liquidity) {
577         (amountA, amountB) = _addLiquidity(tokenA, tokenB, amountADesired, amountBDesired, amountAMin, amountBMin);
578         address pair = SumswapV2Library.pairFor(factory, tokenA, tokenB);
579         TransferHelper.safeTransferFrom(tokenA, msg.sender, pair, amountA);
580         TransferHelper.safeTransferFrom(tokenB, msg.sender, pair, amountB);
581         liquidity = ISumiswapV2Pair(pair).mint(to);
582     }
583     function addLiquidityETH(
584         address token,
585         uint amountTokenDesired,
586         uint amountTokenMin,
587         uint amountETHMin,
588         address to,
589         uint deadline
590     ) external virtual override payable ensure(deadline) returns (uint amountToken, uint amountETH, uint liquidity) {
591         (amountToken, amountETH) = _addLiquidity(
592             token,
593             WETH,
594             amountTokenDesired,
595             msg.value,
596             amountTokenMin,
597             amountETHMin
598         );
599         address pair = SumswapV2Library.pairFor(factory, token, WETH);
600         TransferHelper.safeTransferFrom(token, msg.sender, pair, amountToken);
601         IWETH(WETH).deposit{value: amountETH}();
602         assert(IWETH(WETH).transfer(pair, amountETH));
603         liquidity = ISumiswapV2Pair(pair).mint(to);
604         // refund dust eth, if any
605         if (msg.value > amountETH) TransferHelper.safeTransferETH(msg.sender, msg.value - amountETH);
606     }
607 
608     // **** REMOVE LIQUIDITY ****
609     function removeLiquidity(
610         address tokenA,
611         address tokenB,
612         uint liquidity,
613         uint amountAMin,
614         uint amountBMin,
615         address to,
616         uint deadline
617     ) public virtual override ensure(deadline) returns (uint amountA, uint amountB) {
618         address pair = SumswapV2Library.pairFor(factory, tokenA, tokenB);
619         ISumiswapV2Pair(pair).transferFrom(msg.sender, pair, liquidity); // send liquidity to pair
620         (uint amount0, uint amount1) = ISumiswapV2Pair(pair).burn(to);
621         (address token0,) = SumswapV2Library.sortTokens(tokenA, tokenB);
622         (amountA, amountB) = tokenA == token0 ? (amount0, amount1) : (amount1, amount0);
623         require(amountA >= amountAMin, 'SumswapV2Router: INSUFFICIENT_A_AMOUNT');
624         require(amountB >= amountBMin, 'SumswapV2Router: INSUFFICIENT_B_AMOUNT');
625     }
626     function removeLiquidityETH(
627         address token,
628         uint liquidity,
629         uint amountTokenMin,
630         uint amountETHMin,
631         address to,
632         uint deadline
633     ) public virtual override ensure(deadline) returns (uint amountToken, uint amountETH) {
634         (amountToken, amountETH) = removeLiquidity(
635             token,
636             WETH,
637             liquidity,
638             amountTokenMin,
639             amountETHMin,
640             address(this),
641             deadline
642         );
643         TransferHelper.safeTransfer(token, to, amountToken);
644         IWETH(WETH).withdraw(amountETH);
645         TransferHelper.safeTransferETH(to, amountETH);
646     }
647     function removeLiquidityWithPermit(
648         address tokenA,
649         address tokenB,
650         uint liquidity,
651         uint amountAMin,
652         uint amountBMin,
653         address to,
654         uint deadline,
655         bool approveMax, uint8 v, bytes32 r, bytes32 s
656     ) external virtual override returns (uint amountA, uint amountB) {
657         address pair = SumswapV2Library.pairFor(factory, tokenA, tokenB);
658         uint value = approveMax ? uint(-1) : liquidity;
659         ISumiswapV2Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
660         (amountA, amountB) = removeLiquidity(tokenA, tokenB, liquidity, amountAMin, amountBMin, to, deadline);
661     }
662     function removeLiquidityETHWithPermit(
663         address token,
664         uint liquidity,
665         uint amountTokenMin,
666         uint amountETHMin,
667         address to,
668         uint deadline,
669         bool approveMax, uint8 v, bytes32 r, bytes32 s
670     ) external virtual override returns (uint amountToken, uint amountETH) {
671         address pair = SumswapV2Library.pairFor(factory, token, WETH);
672         uint value = approveMax ? uint(-1) : liquidity;
673         ISumiswapV2Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
674         (amountToken, amountETH) = removeLiquidityETH(token, liquidity, amountTokenMin, amountETHMin, to, deadline);
675     }
676 
677     // **** REMOVE LIQUIDITY (supporting fee-on-transfer tokens) ****
678     function removeLiquidityETHSupportingFeeOnTransferTokens(
679         address token,
680         uint liquidity,
681         uint amountTokenMin,
682         uint amountETHMin,
683         address to,
684         uint deadline
685     ) public virtual override ensure(deadline) returns (uint amountETH) {
686         (, amountETH) = removeLiquidity(
687             token,
688             WETH,
689             liquidity,
690             amountTokenMin,
691             amountETHMin,
692             address(this),
693             deadline
694         );
695         TransferHelper.safeTransfer(token, to, IERC20Sumswap(token).balanceOf(address(this)));
696         IWETH(WETH).withdraw(amountETH);
697         TransferHelper.safeTransferETH(to, amountETH);
698     }
699     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
700         address token,
701         uint liquidity,
702         uint amountTokenMin,
703         uint amountETHMin,
704         address to,
705         uint deadline,
706         bool approveMax, uint8 v, bytes32 r, bytes32 s
707     ) external virtual override returns (uint amountETH) {
708         address pair = SumswapV2Library.pairFor(factory, token, WETH);
709         uint value = approveMax ? uint(-1) : liquidity;
710         ISumiswapV2Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
711         amountETH = removeLiquidityETHSupportingFeeOnTransferTokens(
712             token, liquidity, amountTokenMin, amountETHMin, to, deadline
713         );
714     }
715 
716     // **** SWAP ****
717     // requires the initial amount to have already been sent to the first pair
718     function _swap(uint[] memory amounts, address[] memory path, address _to) internal virtual {
719         for (uint i; i < path.length - 1; i++) {
720             (address input, address output) = (path[i], path[i + 1]);
721             (address token0,) = SumswapV2Library.sortTokens(input, output);
722             uint amountOut = amounts[i + 1];
723             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOut) : (amountOut, uint(0));
724             address to = i < path.length - 2 ? SumswapV2Library.pairFor(factory, output, path[i + 2]) : _to;
725             ISumiswapV2Pair(SumswapV2Library.pairFor(factory, input, output)).swap(
726                 amount0Out, amount1Out, to, new bytes(0)
727             );
728         }
729     }
730     function swapExactTokensForTokens(
731         uint amountIn,
732         uint amountOutMin,
733         address[] calldata path,
734         address to,
735         uint deadline
736     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
737         amounts = SumswapV2Library.getAmountsOut(factory, amountIn, path);
738         require(amounts[amounts.length - 1] >= amountOutMin, 'SumswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
739         TransferHelper.safeTransferFrom(
740             path[0], msg.sender, SumswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
741         );
742         _swap(amounts, path, to);
743     }
744     function swapTokensForExactTokens(
745         uint amountOut,
746         uint amountInMax,
747         address[] calldata path,
748         address to,
749         uint deadline
750     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
751         amounts = SumswapV2Library.getAmountsIn(factory, amountOut, path);
752         require(amounts[0] <= amountInMax, 'SumswapV2Router: EXCESSIVE_INPUT_AMOUNT');
753         TransferHelper.safeTransferFrom(
754             path[0], msg.sender, SumswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
755         );
756         _swap(amounts, path, to);
757     }
758     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
759         external
760         virtual
761         override
762         payable
763         ensure(deadline)
764         returns (uint[] memory amounts)
765     {
766         require(path[0] == WETH, 'SumswapV2Router: INVALID_PATH');
767         amounts = SumswapV2Library.getAmountsOut(factory, msg.value, path);
768         require(amounts[amounts.length - 1] >= amountOutMin, 'SumswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
769         IWETH(WETH).deposit{value: amounts[0]}();
770         assert(IWETH(WETH).transfer(SumswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]));
771         _swap(amounts, path, to);
772     }
773     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
774         external
775         virtual
776         override
777         ensure(deadline)
778         returns (uint[] memory amounts)
779     {
780         require(path[path.length - 1] == WETH, 'SumswapV2Router: INVALID_PATH');
781         amounts = SumswapV2Library.getAmountsIn(factory, amountOut, path);
782         require(amounts[0] <= amountInMax, 'SumswapV2Router: EXCESSIVE_INPUT_AMOUNT');
783         TransferHelper.safeTransferFrom(
784             path[0], msg.sender, SumswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
785         );
786         _swap(amounts, path, address(this));
787         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
788         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
789     }
790     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
791         external
792         virtual
793         override
794         ensure(deadline)
795         returns (uint[] memory amounts)
796     {
797         require(path[path.length - 1] == WETH, 'SumswapV2Router: INVALID_PATH');
798         amounts = SumswapV2Library.getAmountsOut(factory, amountIn, path);
799         require(amounts[amounts.length - 1] >= amountOutMin, 'SumswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
800         TransferHelper.safeTransferFrom(
801             path[0], msg.sender, SumswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
802         );
803         _swap(amounts, path, address(this));
804         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
805         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
806     }
807     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
808         external
809         virtual
810         override
811         payable
812         ensure(deadline)
813         returns (uint[] memory amounts)
814     {
815         require(path[0] == WETH, 'SumswapV2Router: INVALID_PATH');
816         amounts = SumswapV2Library.getAmountsIn(factory, amountOut, path);
817         require(amounts[0] <= msg.value, 'SumswapV2Router: EXCESSIVE_INPUT_AMOUNT');
818         IWETH(WETH).deposit{value: amounts[0]}();
819         assert(IWETH(WETH).transfer(SumswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]));
820         _swap(amounts, path, to);
821         // refund dust eth, if any
822         if (msg.value > amounts[0]) TransferHelper.safeTransferETH(msg.sender, msg.value - amounts[0]);
823     }
824 
825     // **** SWAP (supporting fee-on-transfer tokens) ****
826     // requires the initial amount to have already been sent to the first pair
827     function _swapSupportingFeeOnTransferTokens(address[] memory path, address _to) internal virtual {
828         for (uint i; i < path.length - 1; i++) {
829             (address input, address output) = (path[i], path[i + 1]);
830             (address token0,) = SumswapV2Library.sortTokens(input, output);
831             ISumiswapV2Pair pair = ISumiswapV2Pair(SumswapV2Library.pairFor(factory, input, output));
832             uint amountInput;
833             uint amountOutput;
834             { // scope to avoid stack too deep errors
835             (uint reserve0, uint reserve1,) = pair.getReserves();
836             (uint reserveInput, uint reserveOutput) = input == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
837             amountInput = IERC20Sumswap(input).balanceOf(address(pair)).sub(reserveInput);
838             amountOutput = SumswapV2Library.getAmountOut(amountInput, reserveInput, reserveOutput);
839             }
840             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOutput) : (amountOutput, uint(0));
841             address to = i < path.length - 2 ? SumswapV2Library.pairFor(factory, output, path[i + 2]) : _to;
842             pair.swap(amount0Out, amount1Out, to, new bytes(0));
843         }
844     }
845     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
846         uint amountIn,
847         uint amountOutMin,
848         address[] calldata path,
849         address to,
850         uint deadline
851     ) external virtual override ensure(deadline) {
852         TransferHelper.safeTransferFrom(
853             path[0], msg.sender, SumswapV2Library.pairFor(factory, path[0], path[1]), amountIn
854         );
855         uint balanceBefore = IERC20Sumswap(path[path.length - 1]).balanceOf(to);
856         _swapSupportingFeeOnTransferTokens(path, to);
857         require(
858             IERC20Sumswap(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
859             'SumswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT'
860         );
861     }
862     function swapExactETHForTokensSupportingFeeOnTransferTokens(
863         uint amountOutMin,
864         address[] calldata path,
865         address to,
866         uint deadline
867     )
868         external
869         virtual
870         override
871         payable
872         ensure(deadline)
873     {
874         require(path[0] == WETH, 'SumswapV2Router: INVALID_PATH');
875         uint amountIn = msg.value;
876         IWETH(WETH).deposit{value: amountIn}();
877         assert(IWETH(WETH).transfer(SumswapV2Library.pairFor(factory, path[0], path[1]), amountIn));
878         uint balanceBefore = IERC20Sumswap(path[path.length - 1]).balanceOf(to);
879         _swapSupportingFeeOnTransferTokens(path, to);
880         require(
881             IERC20Sumswap(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
882             'SumswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT'
883         );
884     }
885     function swapExactTokensForETHSupportingFeeOnTransferTokens(
886         uint amountIn,
887         uint amountOutMin,
888         address[] calldata path,
889         address to,
890         uint deadline
891     )
892         external
893         virtual
894         override
895         ensure(deadline)
896     {
897         require(path[path.length - 1] == WETH, 'SumswapV2Router: INVALID_PATH');
898         TransferHelper.safeTransferFrom(
899             path[0], msg.sender, SumswapV2Library.pairFor(factory, path[0], path[1]), amountIn
900         );
901         _swapSupportingFeeOnTransferTokens(path, address(this));
902         uint amountOut = IERC20Sumswap(WETH).balanceOf(address(this));
903         require(amountOut >= amountOutMin, 'SumswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
904         IWETH(WETH).withdraw(amountOut);
905         TransferHelper.safeTransferETH(to, amountOut);
906     }
907 
908     // **** LIBRARY FUNCTIONS ****
909     function quote(uint amountA, uint reserveA, uint reserveB) public pure virtual override returns (uint amountB) {
910         return SumswapV2Library.quote(amountA, reserveA, reserveB);
911     }
912 
913     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut)
914         public
915         pure
916         virtual
917         override
918         returns (uint amountOut)
919     {
920         return SumswapV2Library.getAmountOut(amountIn, reserveIn, reserveOut);
921     }
922 
923     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut)
924         public
925         pure
926         virtual
927         override
928         returns (uint amountIn)
929     {
930         return SumswapV2Library.getAmountIn(amountOut, reserveIn, reserveOut);
931     }
932 
933     function getAmountsOut(uint amountIn, address[] memory path)
934         public
935         view
936         virtual
937         override
938         returns (uint[] memory amounts)
939     {
940         return SumswapV2Library.getAmountsOut(factory, amountIn, path);
941     }
942 
943     function getAmountsIn(uint amountOut, address[] memory path)
944         public
945         view
946         virtual
947         override
948         returns (uint[] memory amounts)
949     {
950         return SumswapV2Library.getAmountsIn(factory, amountOut, path);
951     }
952 
953     function setOpen() external onlyOwner{
954         open = true;
955     }
956 }