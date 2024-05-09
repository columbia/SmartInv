1 // File: ../dmswap-core/contracts/interfaces/IUniswapV2Factory.sol
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
19 
20     function setFeeWeights(uint8[2] calldata weights) external;
21     function getFeeWeights() view external returns(uint8[2] memory weights);
22 
23     function getCodeHash() external pure returns (bytes32);
24 
25 }
26 
27 // File: ../dmswap-lib/contracts/libraries/TransferHelper.sol
28 
29 // SPDX-License-Identifier: GPL-3.0-or-later
30 
31 pragma solidity >=0.6.0;
32 
33 // helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
34 library TransferHelper {
35     function safeApprove(
36         address token,
37         address to,
38         uint256 value
39     ) internal {
40         // bytes4(keccak256(bytes('approve(address,uint256)')));
41         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
42         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
43     }
44 
45     function safeTransfer(
46         address token,
47         address to,
48         uint256 value
49     ) internal {
50         // bytes4(keccak256(bytes('transfer(address,uint256)')));
51         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
52         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
53     }
54 
55     function safeTransferFrom(
56         address token,
57         address from,
58         address to,
59         uint256 value
60     ) internal {
61         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
62         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
63         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
64     }
65 
66     function safeTransferETH(address to, uint256 value) internal {
67         (bool success, ) = to.call{value: value}(new bytes(0));
68         require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
69     }
70 }
71 
72 // File: contracts/interfaces/IPlayerBook.sol
73 
74 pragma solidity ^0.6.0;
75 
76 
77 interface IPlayerBook {
78     function settleReward( address from,uint256 amount ) external returns (uint256);
79     function bindRefer( address from,string calldata  affCode )  external returns (bool);
80     function hasRefer(address from) external returns(bool);
81 
82 }
83 
84 // File: contracts/interfaces/IUniswapV2Router01.sol
85 
86 pragma solidity >=0.6.2;
87 
88 interface IUniswapV2Router01 {
89     function factory() external pure returns (address);
90     function WETH() external pure returns (address);
91 
92     function addLiquidityInvter(
93         address tokenA,
94         address tokenB,
95         uint amountADesired,
96         uint amountBDesired,
97         address to,
98         string calldata inviter,
99         uint deadline
100     ) external returns (uint amountA, uint amountB, uint liquidity);
101     function addLiquidity(
102         address tokenA,
103         address tokenB,
104         uint amountADesired,
105         uint amountBDesired,
106         uint amountAMin,
107         uint amountBMin,
108         address to,
109         uint deadline
110     ) external returns (uint amountA, uint amountB, uint liquidity);
111     function addLiquidityETHInvter(
112         address token,
113         uint amountTokenDesired,
114         uint amountTokenMin,
115         uint amountETHMin,
116         address to,
117         string calldata inviter,
118         uint deadline
119     ) external  payable returns (uint amountToken, uint amountETH, uint liquidity);
120     function addLiquidityETH(
121         address token,
122         uint amountTokenDesired,
123         uint amountTokenMin,
124         uint amountETHMin,
125         address to,
126         uint deadline
127     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
128     function removeLiquidity(
129         address tokenA,
130         address tokenB,
131         uint liquidity,
132         uint amountAMin,
133         uint amountBMin,
134         address to,
135         uint deadline
136     ) external returns (uint amountA, uint amountB);
137     function removeLiquidityETH(
138         address token,
139         uint liquidity,
140         uint amountTokenMin,
141         uint amountETHMin,
142         address to,
143         uint deadline
144     ) external returns (uint amountToken, uint amountETH);
145     function removeLiquidityWithPermit(
146         address tokenA,
147         address tokenB,
148         uint liquidity,
149         uint amountAMin,
150         uint amountBMin,
151         address to,
152         uint deadline,
153         bool approveMax, uint8 v, bytes32 r, bytes32 s
154     ) external returns (uint amountA, uint amountB);
155     function removeLiquidityETHWithPermit(
156         address token,
157         uint liquidity,
158         uint amountTokenMin,
159         uint amountETHMin,
160         address to,
161         uint deadline,
162         bool approveMax, uint8 v, bytes32 r, bytes32 s
163     ) external returns (uint amountToken, uint amountETH);
164     function swapExactTokensForTokensInviter(
165         uint amountIn,
166         uint amountOutMin,
167         address[] calldata path,
168         address to,
169         string calldata inviter,
170         uint deadline
171     ) external returns (uint[] memory amounts);
172     function swapExactTokensForTokens(
173         uint amountIn,
174         uint amountOutMin,
175         address[] calldata path,
176         address to,
177         uint deadline
178     ) external returns (uint[] memory amounts);
179     function swapTokensForExactTokensInviter(
180         uint amountOut,
181         uint amountInMax,
182         address[] calldata path,
183         address to,
184         string calldata inviter,
185         uint deadline
186     ) external returns (uint[] memory amounts);
187     function swapTokensForExactTokens(
188         uint amountOut,
189         uint amountInMax,
190         address[] calldata path,
191         address to,
192         uint deadline
193     ) external returns (uint[] memory amounts);
194     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
195         external
196         payable
197         returns (uint[] memory amounts);
198     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
199         external
200         returns (uint[] memory amounts);
201     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
202         external
203         returns (uint[] memory amounts);
204     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
205         external
206         payable
207         returns (uint[] memory amounts);
208 
209     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
210     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
211     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
212     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
213     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
214 }
215 
216 // File: contracts/interfaces/IUniswapV2Router02.sol
217 
218 pragma solidity >=0.6.2;
219 
220 
221 interface IUniswapV2Router02 is IUniswapV2Router01 {
222     function removeLiquidityETHSupportingFeeOnTransferTokens(
223         address token,
224         uint liquidity,
225         uint amountTokenMin,
226         uint amountETHMin,
227         address to,
228         uint deadline
229     ) external returns (uint amountETH);
230     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
231         address token,
232         uint liquidity,
233         uint amountTokenMin,
234         uint amountETHMin,
235         address to,
236         uint deadline,
237         bool approveMax, uint8 v, bytes32 r, bytes32 s
238     ) external returns (uint amountETH);
239 
240     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
241         uint amountIn,
242         uint amountOutMin,
243         address[] calldata path,
244         address to,
245         uint deadline
246     ) external;
247     function swapExactETHForTokensSupportingFeeOnTransferTokens(
248         uint amountOutMin,
249         address[] calldata path,
250         address to,
251         uint deadline
252     ) external payable;
253     function swapExactTokensForETHSupportingFeeOnTransferTokens(
254         uint amountIn,
255         uint amountOutMin,
256         address[] calldata path,
257         address to,
258         uint deadline
259     ) external;
260     function swapExactTokensForTokensSupportingFeeOnTransferTokensInviter(
261         uint amountIn,
262         uint amountOutMin,
263         address[] calldata path,
264         address to,
265         string calldata inviter,
266         uint deadline
267     ) external;
268 }
269 
270 // File: ../dmswap-core/contracts/interfaces/IUniswapV2Pair.sol
271 
272 pragma solidity >=0.5.0;
273 
274 interface IUniswapV2Pair {
275     event Approval(address indexed owner, address indexed spender, uint value);
276     event Transfer(address indexed from, address indexed to, uint value);
277 
278     function name() external pure returns (string memory);
279     function symbol() external pure returns (string memory);
280     function decimals() external pure returns (uint8);
281     function totalSupply() external view returns (uint);
282     function balanceOf(address owner) external view returns (uint);
283     function allowance(address owner, address spender) external view returns (uint);
284 
285     function approve(address spender, uint value) external returns (bool);
286     function transfer(address to, uint value) external returns (bool);
287     function transferFrom(address from, address to, uint value) external returns (bool);
288 
289     function DOMAIN_SEPARATOR() external view returns (bytes32);
290     function PERMIT_TYPEHASH() external pure returns (bytes32);
291     function nonces(address owner) external view returns (uint);
292 
293     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
294 
295     event Mint(address indexed sender, uint amount0, uint amount1);
296     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
297     event Swap(
298         address indexed sender,
299         uint amount0In,
300         uint amount1In,
301         uint amount0Out,
302         uint amount1Out,
303         address indexed to
304     );
305     event Sync(uint112 reserve0, uint112 reserve1);
306 
307     function MINIMUM_LIQUIDITY() external pure returns (uint);
308     function factory() external view returns (address);
309     function token0() external view returns (address);
310     function token1() external view returns (address);
311     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
312     function price0CumulativeLast() external view returns (uint);
313     function price1CumulativeLast() external view returns (uint);
314     function kLast() external view returns (uint);
315 
316     function mint(address to) external returns (uint liquidity);
317     function burn(address to) external returns (uint amount0, uint amount1);
318     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
319     function skim(address to) external;
320     function sync() external;
321 
322     function initialize(address _token0, address _token1,string calldata _pairName,string calldata _pairSymbol) external;
323     function setFeeRatio(uint16 _feeRatio) external;
324     function getFeeRatio() view external returns(uint16);
325     function unlockedFeeRatio() view external returns(uint);
326 }
327 
328 // File: contracts/libraries/UniswapV2Library.sol
329 
330 pragma solidity >=0.5.0;
331 
332 
333 //import "./SafeMath.sol";
334 
335 library UniswapV2Library {
336     using SafeMath for uint;
337 
338     // returns sorted token addresses, used to handle return values from pairs sorted in this order
339     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
340         require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');
341         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
342         require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');
343     }
344 
345     // calculates the CREATE2 address for a pair without making any external calls
346     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
347         (address token0, address token1) = sortTokens(tokenA, tokenB);
348         pair = address(uint(keccak256(abi.encodePacked(
349                 hex'ff',
350                 factory,
351                 keccak256(abi.encodePacked(token0, token1)),
352                 hex'9f38e1239a766080b4cb163ac9f4d51542115079ea5bdfee852617e3a43af0ec' // init code hash
353             ))));
354     }
355 
356     // fetches and sorts the reserves for a pair
357     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
358         (address token0,) = sortTokens(tokenA, tokenB);
359         (uint reserve0, uint reserve1,) = IUniswapV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();
360         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
361     }
362 
363     // fetches and sorts the getFeeRatio for a pair
364     function getFeeRatio(address factory, address tokenA, address tokenB) internal view returns (uint16) {
365         return IUniswapV2Pair(pairFor(factory, tokenA, tokenB)).getFeeRatio();
366     }
367 
368     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
369     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
370         require(amountA > 0, 'UniswapV2Library: INSUFFICIENT_AMOUNT');
371         require(reserveA > 0 && reserveB > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
372         amountB = amountA.mul(reserveB) / reserveA;
373     }
374 
375     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
376     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
377         require(amountIn > 0, 'UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT');
378         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
379         uint amountInWithFee = amountIn.mul(996);
380         uint numerator = amountInWithFee.mul(reserveOut);
381         uint denominator = reserveIn.mul(1000).add(amountInWithFee);
382         amountOut = numerator / denominator;
383     }
384 
385     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
386     function getAmountOutWithFee(uint amountIn, uint reserveIn, uint reserveOut,uint16 feeRatio) internal pure returns (uint amountOut) {
387         require(amountIn > 0, 'UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT');
388         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
389         uint amountInWithFee = amountIn.mul(1000-feeRatio);
390         uint numerator = amountInWithFee.mul(reserveOut);
391         uint denominator = reserveIn.mul(1000).add(amountInWithFee);
392         amountOut = numerator / denominator;
393     }
394 
395     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
396     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {
397         require(amountOut > 0, 'UniswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT');
398         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
399         uint numerator = reserveIn.mul(amountOut).mul(1000);
400         uint denominator = reserveOut.sub(amountOut).mul(996);
401         amountIn = (numerator / denominator).add(1);
402     }
403 
404     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
405     function getAmountInWithFee(uint amountOut, uint reserveIn, uint reserveOut,uint16 feeRatio) internal pure returns (uint amountIn) {
406         require(amountOut > 0, 'UniswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT');
407         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
408         uint numerator = reserveIn.mul(amountOut).mul(1000);
409         uint denominator = reserveOut.sub(amountOut).mul(1000-feeRatio);
410         amountIn = (numerator / denominator).add(1);
411     }
412 
413     // performs chained getAmountOut calculations on any number of pairs
414     function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {
415         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
416         amounts = new uint[](path.length);
417         amounts[0] = amountIn;
418         for (uint i; i < path.length - 1; i++) {
419             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);
420             uint16 feeRatio = getFeeRatio(factory, path[i], path[i + 1]);
421             amounts[i + 1] = getAmountOutWithFee(amounts[i], reserveIn, reserveOut,feeRatio);
422         }
423     }
424 
425     // performs chained getAmountIn calculations on any number of pairs
426     function getAmountsIn(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {
427         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
428         amounts = new uint[](path.length);
429         amounts[amounts.length - 1] = amountOut;
430         for (uint i = path.length - 1; i > 0; i--) {
431             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);
432             uint16 feeRatio = getFeeRatio(factory, path[i - 1], path[i]);
433             amounts[i - 1] = getAmountInWithFee(amounts[i], reserveIn, reserveOut,feeRatio);
434         }
435     }
436 }
437 
438 // File: contracts/libraries/SafeMath.sol
439 
440 pragma solidity =0.6.6;
441 
442 // a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)
443 
444 library SafeMath {
445     function add(uint x, uint y) internal pure returns (uint z) {
446         require((z = x + y) >= x, 'ds-math-add-overflow');
447     }
448 
449     function sub(uint x, uint y) internal pure returns (uint z) {
450         require((z = x - y) <= x, 'ds-math-sub-underflow');
451     }
452 
453     function mul(uint x, uint y) internal pure returns (uint z) {
454         require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');
455     }
456 }
457 
458 // File: contracts/libraries/owner.sol
459 
460 pragma solidity >=0.4.22 <0.7.0;
461 
462 /**
463  * @dev Contract module which provides a basic access control mechanism, where
464  * there is an account (an owner) that can be granted exclusive access to
465  * specific functions.
466  *
467  * This module is used through inheritance. It will make available the modifier
468  * `onlyOwner`, which can be aplied to your functions to restrict their use to
469  * the owner.
470  */
471 contract Ownable {
472     address private _owner;
473 
474     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
475 
476     /**
477      * @dev Initializes the contract setting the deployer as the initial owner.
478      */
479     constructor () internal {
480         _owner = msg.sender;
481         emit OwnershipTransferred(address(0), _owner);
482     }
483 
484     /**
485      * @dev Returns the address of the current owner.
486      */
487     function owner() public view returns (address) {
488         return _owner;
489     }
490 
491     /**
492      * @dev Throws if called by any account other than the owner.
493      */
494     modifier onlyOwner() {
495         require(isOwner(), "Ownable: caller is not the owner");
496         _;
497     }
498 
499     /**
500      * @dev Returns true if the caller is the current owner.
501      */
502     function isOwner() public view returns (bool) {
503         return msg.sender == _owner;
504     }
505 
506     /**
507      * @dev Leaves the contract without owner. It will not be possible to call
508      * `onlyOwner` functions anymore. Can only be called by the current owner.
509      *
510      * > Note: Renouncing ownership will leave the contract without an owner,
511      * thereby removing any functionality that is only available to the owner.
512      */
513     function renounceOwnership() public onlyOwner {
514         emit OwnershipTransferred(_owner, address(0));
515         _owner = address(0);
516     }
517 
518     /**
519      * @dev Transfers ownership of the contract to a new account (`newOwner`).
520      * Can only be called by the current owner.
521      */
522     function transferOwnership(address newOwner) public onlyOwner {
523         _transferOwnership(newOwner);
524     }
525 
526     /**
527      * @dev Transfers ownership of the contract to a new account (`newOwner`).
528      */
529     function _transferOwnership(address newOwner) internal {
530         require(newOwner != address(0), "Ownable: new owner is the zero address");
531         emit OwnershipTransferred(_owner, newOwner);
532         _owner = newOwner;
533     }
534 }
535 
536 // File: contracts/interfaces/IERC20.sol
537 
538 pragma solidity >=0.5.0;
539 
540 interface IERC20 {
541     event Approval(address indexed owner, address indexed spender, uint value);
542     event Transfer(address indexed from, address indexed to, uint value);
543 
544     function name() external view returns (string memory);
545     function symbol() external view returns (string memory);
546     function decimals() external view returns (uint8);
547     function totalSupply() external view returns (uint);
548     function balanceOf(address owner) external view returns (uint);
549     function allowance(address owner, address spender) external view returns (uint);
550 
551     function approve(address spender, uint value) external returns (bool);
552     function transfer(address to, uint value) external returns (bool);
553     function transferFrom(address from, address to, uint value) external returns (bool);
554 }
555 
556 // File: contracts/interfaces/IWETH.sol
557 
558 pragma solidity >=0.5.0;
559 
560 interface IWETH {
561     function deposit() external payable;
562     function transfer(address to, uint value) external returns (bool);
563     function withdraw(uint) external;
564 }
565 
566 // File: contracts/DMSwapV2Router02.sol
567 
568 pragma solidity =0.6.6;
569 
570 
571 
572 
573 
574 
575 
576 
577 
578 
579 contract UniswapV2Router02 is IUniswapV2Router02 ,Ownable{
580     using SafeMath for uint;
581 
582     address public immutable override factory;
583     address public immutable override WETH;
584 
585     address public _playerBook = address(0x178f005e3BB10604a47c4F8212C8959caC9c94aA);
586 
587     modifier ensure(uint deadline) {
588         require(deadline >= block.timestamp, 'UniswapV2Router: EXPIRED');
589         _;
590     }
591 
592     constructor(address _factory, address _WETH) public {
593         factory = _factory;
594         WETH = _WETH;
595     }
596 
597     receive() external payable {
598         assert(msg.sender == WETH); // only accept ETH via fallback from the WETH contract
599     }
600 
601     // **** ADD LIQUIDITY ****
602     function _addLiquidity(
603         address tokenA,
604         address tokenB,
605         uint amountADesired,
606         uint amountBDesired,
607         uint amountAMin,
608         uint amountBMin
609     ) internal virtual returns (uint amountA, uint amountB) {
610         // create the pair if it doesn't exist yet
611         if (IUniswapV2Factory(factory).getPair(tokenA, tokenB) == address(0)) {
612             IUniswapV2Factory(factory).createPair(tokenA, tokenB);
613         }
614         (uint reserveA, uint reserveB) = UniswapV2Library.getReserves(factory, tokenA, tokenB);
615         if (reserveA == 0 && reserveB == 0) {
616             (amountA, amountB) = (amountADesired, amountBDesired);
617         } else {
618             uint amountBOptimal = UniswapV2Library.quote(amountADesired, reserveA, reserveB);
619             if (amountBOptimal <= amountBDesired) {
620                 require(amountBOptimal >= amountBMin, 'UniswapV2Router: INSUFFICIENT_B_AMOUNT');
621                 (amountA, amountB) = (amountADesired, amountBOptimal);
622             } else {
623                 uint amountAOptimal = UniswapV2Library.quote(amountBDesired, reserveB, reserveA);
624                 assert(amountAOptimal <= amountADesired);
625                 require(amountAOptimal >= amountAMin, 'UniswapV2Router: INSUFFICIENT_A_AMOUNT');
626                 (amountA, amountB) = (amountAOptimal, amountBDesired);
627             }
628         }
629     }
630     function addLiquidityInvter(
631         address tokenA,
632         address tokenB,
633         uint amountADesired,
634         uint amountBDesired,
635         address to,
636         string calldata inviter,
637         uint deadline
638     ) external virtual override ensure(deadline) returns (uint amountA, uint amountB, uint liquidity) {
639         if (bytes(inviter).length != 0){
640             AddInvter(msg.sender,inviter);
641         }
642         (amountA, amountB) = _addLiquidity(tokenA, tokenB, amountADesired, amountBDesired, 0, 0);
643         address pair = UniswapV2Library.pairFor(factory, tokenA, tokenB);
644         TransferHelper.safeTransferFrom(tokenA, msg.sender, pair, amountA);
645         TransferHelper.safeTransferFrom(tokenB, msg.sender, pair, amountB);
646         liquidity = IUniswapV2Pair(pair).mint(to);
647     }
648 
649     function addLiquidity(
650         address tokenA,
651         address tokenB,
652         uint amountADesired,
653         uint amountBDesired,
654         uint amountAMin,
655         uint amountBMin,
656         address to,
657         uint deadline
658     ) external virtual override ensure(deadline) returns (uint amountA, uint amountB, uint liquidity) {
659         (amountA, amountB) = _addLiquidity(tokenA, tokenB, amountADesired, amountBDesired, amountAMin, amountBMin);
660         address pair = UniswapV2Library.pairFor(factory, tokenA, tokenB);
661         TransferHelper.safeTransferFrom(tokenA, msg.sender, pair, amountA);
662         TransferHelper.safeTransferFrom(tokenB, msg.sender, pair, amountB);
663         liquidity = IUniswapV2Pair(pair).mint(to);
664     }
665     function addLiquidityETHInvter(
666         address token,
667         uint amountTokenDesired,
668         uint amountTokenMin,
669         uint amountETHMin,
670         address to,
671         string calldata inviter,
672         uint deadline
673     ) external virtual override payable ensure(deadline) returns (uint amountToken, uint amountETH, uint liquidity) {
674         if (bytes(inviter).length != 0){
675             AddInvter(msg.sender,inviter);
676         }
677         (amountToken, amountETH) = _addLiquidity(
678             token,
679             WETH,
680             amountTokenDesired,
681             msg.value,
682             amountTokenMin,
683             amountETHMin
684         );
685         address pair = UniswapV2Library.pairFor(factory, token, WETH);
686         TransferHelper.safeTransferFrom(token, msg.sender, pair, amountToken);
687         IWETH(WETH).deposit{value: amountETH}();
688         assert(IWETH(WETH).transfer(pair, amountETH));
689         liquidity = IUniswapV2Pair(pair).mint(to);
690         // refund dust eth, if any
691         if (msg.value > amountETH) TransferHelper.safeTransferETH(msg.sender, msg.value - amountETH);
692     }
693 
694     function addLiquidityETH(
695         address token,
696         uint amountTokenDesired,
697         uint amountTokenMin,
698         uint amountETHMin,
699         address to,
700         uint deadline
701     ) external virtual override payable ensure(deadline) returns (uint amountToken, uint amountETH, uint liquidity) {
702         (amountToken, amountETH) = _addLiquidity(
703             token,
704             WETH,
705             amountTokenDesired,
706             msg.value,
707             amountTokenMin,
708             amountETHMin
709         );
710         address pair = UniswapV2Library.pairFor(factory, token, WETH);
711         TransferHelper.safeTransferFrom(token, msg.sender, pair, amountToken);
712         IWETH(WETH).deposit{value: amountETH}();
713         assert(IWETH(WETH).transfer(pair, amountETH));
714         liquidity = IUniswapV2Pair(pair).mint(to);
715         // refund dust eth, if any
716         if (msg.value > amountETH) TransferHelper.safeTransferETH(msg.sender, msg.value - amountETH);
717     }
718 
719     // **** REMOVE LIQUIDITY ****
720     function removeLiquidity(
721         address tokenA,
722         address tokenB,
723         uint liquidity,
724         uint amountAMin,
725         uint amountBMin,
726         address to,
727         uint deadline
728     ) public virtual override ensure(deadline) returns (uint amountA, uint amountB) {
729         address pair = UniswapV2Library.pairFor(factory, tokenA, tokenB);
730         IUniswapV2Pair(pair).transferFrom(msg.sender, pair, liquidity); // send liquidity to pair
731         (uint amount0, uint amount1) = IUniswapV2Pair(pair).burn(to);
732         (address token0,) = UniswapV2Library.sortTokens(tokenA, tokenB);
733         (amountA, amountB) = tokenA == token0 ? (amount0, amount1) : (amount1, amount0);
734         require(amountA >= amountAMin, 'UniswapV2Router: INSUFFICIENT_A_AMOUNT');
735         require(amountB >= amountBMin, 'UniswapV2Router: INSUFFICIENT_B_AMOUNT');
736     }
737     function removeLiquidityETH(
738         address token,
739         uint liquidity,
740         uint amountTokenMin,
741         uint amountETHMin,
742         address to,
743         uint deadline
744     ) public virtual override ensure(deadline) returns (uint amountToken, uint amountETH) {
745         (amountToken, amountETH) = removeLiquidity(
746             token,
747             WETH,
748             liquidity,
749             amountTokenMin,
750             amountETHMin,
751             address(this),
752             deadline
753         );
754         TransferHelper.safeTransfer(token, to, amountToken);
755         IWETH(WETH).withdraw(amountETH);
756         TransferHelper.safeTransferETH(to, amountETH);
757     }
758     function removeLiquidityWithPermit(
759         address tokenA,
760         address tokenB,
761         uint liquidity,
762         uint amountAMin,
763         uint amountBMin,
764         address to,
765         uint deadline,
766         bool approveMax, uint8 v, bytes32 r, bytes32 s
767     ) external virtual override returns (uint amountA, uint amountB) {
768         address pair = UniswapV2Library.pairFor(factory, tokenA, tokenB);
769         uint value = approveMax ? uint(-1) : liquidity;
770         IUniswapV2Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
771         (amountA, amountB) = removeLiquidity(tokenA, tokenB, liquidity, amountAMin, amountBMin, to, deadline);
772     }
773     function removeLiquidityETHWithPermit(
774         address token,
775         uint liquidity,
776         uint amountTokenMin,
777         uint amountETHMin,
778         address to,
779         uint deadline,
780         bool approveMax, uint8 v, bytes32 r, bytes32 s
781     ) external virtual override returns (uint amountToken, uint amountETH) {
782         address pair = UniswapV2Library.pairFor(factory, token, WETH);
783         uint value = approveMax ? uint(-1) : liquidity;
784         IUniswapV2Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
785         (amountToken, amountETH) = removeLiquidityETH(token, liquidity, amountTokenMin, amountETHMin, to, deadline);
786     }
787 
788     // **** REMOVE LIQUIDITY (supporting fee-on-transfer tokens) ****
789     function removeLiquidityETHSupportingFeeOnTransferTokens(
790         address token,
791         uint liquidity,
792         uint amountTokenMin,
793         uint amountETHMin,
794         address to,
795         uint deadline
796     ) public virtual override ensure(deadline) returns (uint amountETH) {
797         (, amountETH) = removeLiquidity(
798             token,
799             WETH,
800             liquidity,
801             amountTokenMin,
802             amountETHMin,
803             address(this),
804             deadline
805         );
806         TransferHelper.safeTransfer(token, to, IERC20(token).balanceOf(address(this)));
807         IWETH(WETH).withdraw(amountETH);
808         TransferHelper.safeTransferETH(to, amountETH);
809     }
810     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
811         address token,
812         uint liquidity,
813         uint amountTokenMin,
814         uint amountETHMin,
815         address to,
816         uint deadline,
817         bool approveMax, uint8 v, bytes32 r, bytes32 s
818     ) external virtual override returns (uint amountETH) {
819         address pair = UniswapV2Library.pairFor(factory, token, WETH);
820         uint value = approveMax ? uint(-1) : liquidity;
821         IUniswapV2Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
822         amountETH = removeLiquidityETHSupportingFeeOnTransferTokens(
823             token, liquidity, amountTokenMin, amountETHMin, to, deadline
824         );
825     }
826 
827     // **** SWAP ****
828     // requires the initial amount to have already been sent to the first pair
829     function _swap(uint[] memory amounts, address[] memory path, address _to) internal virtual {
830         for (uint i; i < path.length - 1; i++) {
831             (address input, address output) = (path[i], path[i + 1]);
832             (address token0,) = UniswapV2Library.sortTokens(input, output);
833             uint amountOut = amounts[i + 1];
834             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOut) : (amountOut, uint(0));
835             address to = i < path.length - 2 ? UniswapV2Library.pairFor(factory, output, path[i + 2]) : _to;
836             IUniswapV2Pair(UniswapV2Library.pairFor(factory, input, output)).swap(
837                 amount0Out, amount1Out, to, new bytes(0)
838             );
839         }
840     }
841 
842     function swapExactTokensForTokensInviter(
843         uint amountIn,
844         uint amountOutMin,
845         address[] calldata path,
846         address to,
847         string calldata inviter,
848         uint deadline
849     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
850         if (bytes(inviter).length != 0){
851             AddInvter(msg.sender,inviter);
852         }
853         amounts = UniswapV2Library.getAmountsOut(factory, amountIn, path);
854         require(amounts[amounts.length - 1] >= amountOutMin, 'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
855         TransferHelper.safeTransferFrom(
856             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
857         );
858         _swap(amounts, path, to);
859     }
860 
861     function swapExactTokensForTokens(
862         uint amountIn,
863         uint amountOutMin,
864         address[] calldata path,
865         address to,
866         uint deadline
867     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
868         amounts = UniswapV2Library.getAmountsOut(factory, amountIn, path);
869         require(amounts[amounts.length - 1] >= amountOutMin, 'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
870         TransferHelper.safeTransferFrom(
871             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
872         );
873         _swap(amounts, path, to);
874     }
875     function swapTokensForExactTokensInviter(
876         uint amountOut,
877         uint amountInMax,
878         address[] calldata path,
879         address to,
880         string calldata inviter,
881         uint deadline
882     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
883         if (bytes(inviter).length != 0){
884             AddInvter(msg.sender,inviter);
885         }
886         amounts = UniswapV2Library.getAmountsIn(factory, amountOut, path);
887         require(amounts[0] <= amountInMax, 'UniswapV2Router: EXCESSIVE_INPUT_AMOUNT');
888         TransferHelper.safeTransferFrom(
889             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
890         );
891         _swap(amounts, path, to);
892     }
893     function swapTokensForExactTokens(
894         uint amountOut,
895         uint amountInMax,
896         address[] calldata path,
897         address to,
898         uint deadline
899     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
900         amounts = UniswapV2Library.getAmountsIn(factory, amountOut, path);
901         require(amounts[0] <= amountInMax, 'UniswapV2Router: EXCESSIVE_INPUT_AMOUNT');
902         TransferHelper.safeTransferFrom(
903             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
904         );
905         _swap(amounts, path, to);
906     }
907     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
908         external
909         virtual
910         override
911         payable
912         ensure(deadline)
913         returns (uint[] memory amounts)
914     {
915         require(path[0] == WETH, 'UniswapV2Router: INVALID_PATH');
916         amounts = UniswapV2Library.getAmountsOut(factory, msg.value, path);
917         require(amounts[amounts.length - 1] >= amountOutMin, 'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
918         IWETH(WETH).deposit{value: amounts[0]}();
919         assert(IWETH(WETH).transfer(UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]));
920         _swap(amounts, path, to);
921     }
922     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
923         external
924         virtual
925         override
926         ensure(deadline)
927         returns (uint[] memory amounts)
928     {
929         require(path[path.length - 1] == WETH, 'UniswapV2Router: INVALID_PATH');
930         amounts = UniswapV2Library.getAmountsIn(factory, amountOut, path);
931         require(amounts[0] <= amountInMax, 'UniswapV2Router: EXCESSIVE_INPUT_AMOUNT');
932         TransferHelper.safeTransferFrom(
933             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
934         );
935         _swap(amounts, path, address(this));
936         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
937         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
938     }
939     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
940         external
941         virtual
942         override
943         ensure(deadline)
944         returns (uint[] memory amounts)
945     {
946         require(path[path.length - 1] == WETH, 'UniswapV2Router: INVALID_PATH');
947         amounts = UniswapV2Library.getAmountsOut(factory, amountIn, path);
948         require(amounts[amounts.length - 1] >= amountOutMin, 'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
949         TransferHelper.safeTransferFrom(
950             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
951         );
952         _swap(amounts, path, address(this));
953         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
954         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
955     }
956     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
957         external
958         virtual
959         override
960         payable
961         ensure(deadline)
962         returns (uint[] memory amounts)
963     {
964         require(path[0] == WETH, 'UniswapV2Router: INVALID_PATH');
965         amounts = UniswapV2Library.getAmountsIn(factory, amountOut, path);
966         require(amounts[0] <= msg.value, 'UniswapV2Router: EXCESSIVE_INPUT_AMOUNT');
967         IWETH(WETH).deposit{value: amounts[0]}();
968         assert(IWETH(WETH).transfer(UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]));
969         _swap(amounts, path, to);
970         // refund dust eth, if any
971         if (msg.value > amounts[0]) TransferHelper.safeTransferETH(msg.sender, msg.value - amounts[0]);
972     }
973 
974     // **** SWAP (supporting fee-on-transfer tokens) ****
975     // requires the initial amount to have already been sent to the first pair
976     function _swapSupportingFeeOnTransferTokens(address[] memory path, address _to) internal virtual {
977         for (uint i; i < path.length - 1; i++) {
978             (address input, address output) = (path[i], path[i + 1]);
979             (address token0,) = UniswapV2Library.sortTokens(input, output);
980             IUniswapV2Pair pair = IUniswapV2Pair(UniswapV2Library.pairFor(factory, input, output));
981             uint amountInput;
982             uint amountOutput;
983             { // scope to avoid stack too deep errors
984             (uint reserve0, uint reserve1,) = pair.getReserves();
985             (uint reserveInput, uint reserveOutput) = input == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
986             amountInput = IERC20(input).balanceOf(address(pair)).sub(reserveInput);
987             uint16 feeRatio = pair.getFeeRatio();
988             amountOutput = UniswapV2Library.getAmountOutWithFee(amountInput, reserveInput, reserveOutput,feeRatio);
989             }
990             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOutput) : (amountOutput, uint(0));
991             address to = i < path.length - 2 ? UniswapV2Library.pairFor(factory, output, path[i + 2]) : _to;
992             pair.swap(amount0Out, amount1Out, to, new bytes(0));
993         }
994     }
995     function swapExactTokensForTokensSupportingFeeOnTransferTokensInviter(
996         uint amountIn,
997         uint amountOutMin,
998         address[] calldata path,
999         address to,
1000         string calldata inviter,
1001         uint deadline
1002     ) external virtual override ensure(deadline) {
1003         if (bytes(inviter).length != 0){
1004             AddInvter(msg.sender,inviter);
1005         }
1006         TransferHelper.safeTransferFrom(
1007             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amountIn
1008         );
1009         uint balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
1010         _swapSupportingFeeOnTransferTokens(path, to);
1011         require(
1012             IERC20(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
1013             'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT'
1014         );
1015     }
1016     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1017         uint amountIn,
1018         uint amountOutMin,
1019         address[] calldata path,
1020         address to,
1021         uint deadline
1022     ) external virtual override ensure(deadline) {
1023         TransferHelper.safeTransferFrom(
1024             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amountIn
1025         );
1026         uint balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
1027         _swapSupportingFeeOnTransferTokens(path, to);
1028         require(
1029             IERC20(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
1030             'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT'
1031         );
1032     }
1033     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1034         uint amountOutMin,
1035         address[] calldata path,
1036         address to,
1037         uint deadline
1038     )
1039         external
1040         virtual
1041         override
1042         payable
1043         ensure(deadline)
1044     {
1045         require(path[0] == WETH, 'UniswapV2Router: INVALID_PATH');
1046         uint amountIn = msg.value;
1047         IWETH(WETH).deposit{value: amountIn}();
1048         assert(IWETH(WETH).transfer(UniswapV2Library.pairFor(factory, path[0], path[1]), amountIn));
1049         uint balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
1050         _swapSupportingFeeOnTransferTokens(path, to);
1051         require(
1052             IERC20(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
1053             'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT'
1054         );
1055     }
1056     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1057         uint amountIn,
1058         uint amountOutMin,
1059         address[] calldata path,
1060         address to,
1061         uint deadline
1062     )
1063         external
1064         virtual
1065         override
1066         ensure(deadline)
1067     {
1068         require(path[path.length - 1] == WETH, 'UniswapV2Router: INVALID_PATH');
1069         TransferHelper.safeTransferFrom(
1070             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amountIn
1071         );
1072         _swapSupportingFeeOnTransferTokens(path, address(this));
1073         uint amountOut = IERC20(WETH).balanceOf(address(this));
1074         require(amountOut >= amountOutMin, 'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
1075         IWETH(WETH).withdraw(amountOut);
1076         TransferHelper.safeTransferETH(to, amountOut);
1077     }
1078 
1079     // **** LIBRARY FUNCTIONS ****
1080     function quote(uint amountA, uint reserveA, uint reserveB) public pure virtual override returns (uint amountB) {
1081         return UniswapV2Library.quote(amountA, reserveA, reserveB);
1082     }
1083 
1084     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut)
1085         public
1086         pure
1087         virtual
1088         override
1089         returns (uint amountOut)
1090     {
1091         return UniswapV2Library.getAmountOut(amountIn, reserveIn, reserveOut);
1092     }
1093 
1094     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut)
1095         public
1096         pure
1097         virtual
1098         override
1099         returns (uint amountIn)
1100     {
1101         return UniswapV2Library.getAmountIn(amountOut, reserveIn, reserveOut);
1102     }
1103 
1104     function getAmountsOut(uint amountIn, address[] memory path)
1105         public
1106         view
1107         virtual
1108         override
1109         returns (uint[] memory amounts)
1110     {
1111         return UniswapV2Library.getAmountsOut(factory, amountIn, path);
1112     }
1113 
1114     function getAmountsIn(uint amountOut, address[] memory path)
1115         public
1116         view
1117         virtual
1118         override
1119         returns (uint[] memory amounts)
1120     {
1121         return UniswapV2Library.getAmountsIn(factory, amountOut, path);
1122     }
1123 
1124     function AddInvter(address account, string memory affCode) public
1125     {
1126         if (!IPlayerBook(_playerBook).hasRefer(account)) {
1127             IPlayerBook(_playerBook).bindRefer(account, affCode);
1128         }
1129     }
1130 
1131     function SetPlayerBook(address playerbook) public onlyOwner{
1132         _playerBook = playerbook;
1133     }
1134 }