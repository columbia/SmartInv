1 // File: localhost/contracts/interfaces/ISwapMining.sol
2 
3 pragma solidity >=0.5.0;
4 
5 interface ISwapMining {
6     function swap(address account, address input, address output, uint256 amount) external returns (bool);
7 }
8 
9 // File: localhost/contracts/interfaces/IWETH.sol
10 
11 pragma solidity >=0.5.0;
12 
13 interface IWETH {
14     function deposit() external payable;
15     function transfer(address to, uint value) external returns (bool);
16     function withdraw(uint) external;
17 }
18 
19 // File: localhost/contracts/interfaces/IERC20.sol
20 
21 pragma solidity >=0.5.0;
22 
23 interface IERC20 {
24     event Approval(address indexed owner, address indexed spender, uint value);
25     event Transfer(address indexed from, address indexed to, uint value);
26 
27     function name() external view returns (string memory);
28     function symbol() external view returns (string memory);
29     function decimals() external view returns (uint8);
30     function totalSupply() external view returns (uint);
31     function balanceOf(address owner) external view returns (uint);
32     function allowance(address owner, address spender) external view returns (uint);
33 
34     function approve(address spender, uint value) external returns (bool);
35     function transfer(address to, uint value) external returns (bool);
36     function transferFrom(address from, address to, uint value) external returns (bool);
37 }
38 
39 // File: localhost/contracts/libraries/SafeMath.sol
40 
41 pragma solidity =0.6.6;
42 
43 // a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)
44 
45 library SafeMath {
46     function add(uint x, uint y) internal pure returns (uint z) {
47         require((z = x + y) >= x, 'ds-math-add-overflow');
48     }
49 
50     function sub(uint x, uint y) internal pure returns (uint z) {
51         require((z = x - y) <= x, 'ds-math-sub-underflow');
52     }
53 
54     function mul(uint x, uint y) internal pure returns (uint z) {
55         require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');
56     }
57 }
58 
59 // File: localhost/contracts/interfaces/IYouSwapPair.sol
60 
61 pragma solidity >=0.5.0;
62 
63 interface IYouSwapPair {
64     event Approval(address indexed owner, address indexed spender, uint value);
65     event Transfer(address indexed from, address indexed to, uint value);
66 
67     function name() external pure returns (string memory);
68     function symbol() external pure returns (string memory);
69     function decimals() external pure returns (uint8);
70     function totalSupply() external view returns (uint);
71     function balanceOf(address owner) external view returns (uint);
72     function allowance(address owner, address spender) external view returns (uint);
73 
74     function approve(address spender, uint value) external returns (bool);
75     function transfer(address to, uint value) external returns (bool);
76     function transferFrom(address from, address to, uint value) external returns (bool);
77 
78     function DOMAIN_SEPARATOR() external view returns (bytes32);
79     function PERMIT_TYPEHASH() external pure returns (bytes32);
80     function nonces(address owner) external view returns (uint);
81 
82     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
83 
84     event Mint(address indexed sender, uint amount0, uint amount1);
85     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
86     event Swap(
87         address indexed sender,
88         uint amount0In,
89         uint amount1In,
90         uint amount0Out,
91         uint amount1Out,
92         address indexed to
93     );
94     event Sync(uint112 reserve0, uint112 reserve1);
95 
96     function MINIMUM_LIQUIDITY() external pure returns (uint);
97     function factory() external view returns (address);
98     function token0() external view returns (address);
99     function token1() external view returns (address);
100     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
101     function price0CumulativeLast() external view returns (uint);
102     function price1CumulativeLast() external view returns (uint);
103     function kLast() external view returns (uint);
104 
105     function mint(address to) external returns (uint liquidity);
106     function burn(address to) external returns (uint amount0, uint amount1);
107     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
108     function skim(address to) external;
109     function sync() external;
110 
111     function initialize(address, address) external;
112 }
113 
114 // File: localhost/contracts/libraries/YouSwapLibrary.sol
115 
116 pragma solidity >=0.5.0;
117 
118 
119 
120 library YouSwapLibrary {
121     using SafeMath for uint;
122 
123     // returns sorted token addresses, used to handle return values from pairs sorted in this order
124     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
125         require(tokenA != tokenB, 'YouSwapLibrary: IDENTICAL_ADDRESSES');
126         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
127         require(token0 != address(0), 'YouSwapLibrary: ZERO_ADDRESS');
128     }
129 
130     // calculates the CREATE2 address for a pair without making any external calls
131     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
132         (address token0, address token1) = sortTokens(tokenA, tokenB);
133         pair = address(uint(keccak256(abi.encodePacked(
134                 hex'ff',
135                 factory,
136                 keccak256(abi.encodePacked(token0, token1)),
137                 hex'8919347964f406fcc7e9a98fd3e05e8ba3e0270039e1e056121a8bffd0f2789e' // init code hash
138             ))));
139     }
140 
141     // fetches and sorts the reserves for a pair
142     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
143         (address token0,) = sortTokens(tokenA, tokenB);
144         (uint reserve0, uint reserve1,) = IYouSwapPair(pairFor(factory, tokenA, tokenB)).getReserves();
145         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
146     }
147 
148     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
149     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
150         require(amountA > 0, 'YouSwapLibrary: INSUFFICIENT_AMOUNT');
151         require(reserveA > 0 && reserveB > 0, 'YouSwapLibrary: INSUFFICIENT_LIQUIDITY');
152         amountB = amountA.mul(reserveB) / reserveA;
153     }
154 
155     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
156     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
157         require(amountIn > 0, 'YouSwapLibrary: INSUFFICIENT_INPUT_AMOUNT');
158         require(reserveIn > 0 && reserveOut > 0, 'YouSwapLibrary: INSUFFICIENT_LIQUIDITY');
159         uint amountInWithFee = amountIn.mul(997);
160         uint numerator = amountInWithFee.mul(reserveOut);
161         uint denominator = reserveIn.mul(1000).add(amountInWithFee);
162         amountOut = numerator / denominator;
163     }
164 
165     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
166     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {
167         require(amountOut > 0, 'YouSwapLibrary: INSUFFICIENT_OUTPUT_AMOUNT');
168         require(reserveIn > 0 && reserveOut > 0, 'YouSwapLibrary: INSUFFICIENT_LIQUIDITY');
169         uint numerator = reserveIn.mul(amountOut).mul(1000);
170         uint denominator = reserveOut.sub(amountOut).mul(997);
171         amountIn = (numerator / denominator).add(1);
172     }
173 
174     // performs chained getAmountOut calculations on any number of pairs
175     function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {
176         require(path.length >= 2, 'YouSwapLibrary: INVALID_PATH');
177         amounts = new uint[](path.length);
178         amounts[0] = amountIn;
179         for (uint i; i < path.length - 1; i++) {
180             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);
181             amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
182         }
183     }
184 
185     // performs chained getAmountIn calculations on any number of pairs
186     function getAmountsIn(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {
187         require(path.length >= 2, 'YouSwapLibrary: INVALID_PATH');
188         amounts = new uint[](path.length);
189         amounts[amounts.length - 1] = amountOut;
190         for (uint i = path.length - 1; i > 0; i--) {
191             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);
192             amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
193         }
194     }
195 }
196 
197 // File: localhost/contracts/interfaces/IYouSwapRouter.sol
198 
199 pragma solidity >=0.6.2;
200 
201 interface IYouSwapRouter {
202     function factory() external pure returns (address);
203     function WETH() external pure returns (address);
204     function swapMining() external pure returns (address);
205 
206     function addLiquidity(
207         address tokenA,
208         address tokenB,
209         uint amountADesired,
210         uint amountBDesired,
211         uint amountAMin,
212         uint amountBMin,
213         address to,
214         uint deadline
215     ) external returns (uint amountA, uint amountB, uint liquidity);
216     function addLiquidityETH(
217         address token,
218         uint amountTokenDesired,
219         uint amountTokenMin,
220         uint amountETHMin,
221         address to,
222         uint deadline
223     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
224     function removeLiquidity(
225         address tokenA,
226         address tokenB,
227         uint liquidity,
228         uint amountAMin,
229         uint amountBMin,
230         address to,
231         uint deadline
232     ) external returns (uint amountA, uint amountB);
233     function removeLiquidityETH(
234         address token,
235         uint liquidity,
236         uint amountTokenMin,
237         uint amountETHMin,
238         address to,
239         uint deadline
240     ) external returns (uint amountToken, uint amountETH);
241     function removeLiquidityWithPermit(
242         address tokenA,
243         address tokenB,
244         uint liquidity,
245         uint amountAMin,
246         uint amountBMin,
247         address to,
248         uint deadline,
249         bool approveMax, uint8 v, bytes32 r, bytes32 s
250     ) external returns (uint amountA, uint amountB);
251     function removeLiquidityETHWithPermit(
252         address token,
253         uint liquidity,
254         uint amountTokenMin,
255         uint amountETHMin,
256         address to,
257         uint deadline,
258         bool approveMax, uint8 v, bytes32 r, bytes32 s
259     ) external returns (uint amountToken, uint amountETH);
260     function swapExactTokensForTokens(
261         uint amountIn,
262         uint amountOutMin,
263         address[] calldata path,
264         address to,
265         uint deadline
266     ) external returns (uint[] memory amounts);
267     function swapTokensForExactTokens(
268         uint amountOut,
269         uint amountInMax,
270         address[] calldata path,
271         address to,
272         uint deadline
273     ) external returns (uint[] memory amounts);
274     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
275         external
276         payable
277         returns (uint[] memory amounts);
278     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
279         external
280         returns (uint[] memory amounts);
281     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
282         external
283         returns (uint[] memory amounts);
284     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
285         external
286         payable
287         returns (uint[] memory amounts);
288 
289     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
290     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
291     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
292     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
293     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
294     
295     function removeLiquidityETHSupportingFeeOnTransferTokens(
296         address token,
297         uint liquidity,
298         uint amountTokenMin,
299         uint amountETHMin,
300         address to,
301         uint deadline
302     ) external returns (uint amountETH);
303     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
304         address token,
305         uint liquidity,
306         uint amountTokenMin,
307         uint amountETHMin,
308         address to,
309         uint deadline,
310         bool approveMax, uint8 v, bytes32 r, bytes32 s
311     ) external returns (uint amountETH);
312 
313     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
314         uint amountIn,
315         uint amountOutMin,
316         address[] calldata path,
317         address to,
318         uint deadline
319     ) external;
320     function swapExactETHForTokensSupportingFeeOnTransferTokens(
321         uint amountOutMin,
322         address[] calldata path,
323         address to,
324         uint deadline
325     ) external payable;
326     function swapExactTokensForETHSupportingFeeOnTransferTokens(
327         uint amountIn,
328         uint amountOutMin,
329         address[] calldata path,
330         address to,
331         uint deadline
332     ) external;
333 }
334 
335 // File: localhost/contracts/libraries/Ownable.sol
336 
337 //SPDX-License-Identifier: SimPL-2.0
338 pragma solidity ^0.6.0;
339 
340 /**
341  * @dev Contract module which provides a basic access control mechanism, where
342  * there is an account (an owner) that can be granted exclusive access to
343  * specific functions.
344  *
345  * By default, the owner account will be the one that deploys the contract. This
346  * can later be changed with {transferOwnership}.
347  *
348  * This module is used through inheritance. It will make available the modifier
349  * `onlyOwner`, which can be applied to your functions to restrict their use to
350  * the owner.
351  */
352 contract Ownable {
353 
354     address private _owner;
355 
356     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
357 
358     /**
359      * @dev Initializes the contract setting the deployer as the initial owner.
360      */
361     constructor () internal {
362         _owner = msg.sender;
363         emit OwnershipTransferred(address(0), msg.sender);
364     }
365 
366     /**
367      * @dev Returns the address of the current owner.
368      */
369     function owner() public view returns (address) {
370         return _owner;
371     }
372 
373     /**
374      * @dev Throws if called by any account other than the owner.
375      */
376     modifier onlyOwner() {
377         require(_owner == msg.sender, "YouSwap: CALLER_IS_NOT_THE_OWNER");
378         _;
379     }
380 
381     /**
382      * @dev Leaves the contract without owner. It will not be possible to call
383      * `onlyOwner` functions anymore. Can only be called by the current owner.
384      *
385      * NOTE: Renouncing ownership will leave the contract without an owner,
386      * thereby removing any functionality that is only available to the owner.
387      */
388     function renounceOwnership() public virtual onlyOwner {
389         emit OwnershipTransferred(_owner, address(0));
390         _owner = address(0);
391     }
392 
393     /**
394      * @dev Transfers ownership of the contract to a new account (`newOwner`).
395      * Can only be called by the current owner.
396      */
397     function transferOwnership(address newOwner) public virtual onlyOwner {
398         require(newOwner != address(0), "YouSwap: NEW_OWNER_IS_THE_ZERO_ADDRESS");
399         emit OwnershipTransferred(_owner, newOwner);
400         _owner = newOwner;
401     }
402 }
403 // File: localhost/contracts/libraries/TransferHelper.sol
404 
405 // SPDX-License-Identifier: GPL-3.0-or-later
406 
407 pragma solidity >=0.6.0;
408 
409 // helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
410 library TransferHelper {
411     function safeApprove(
412         address token,
413         address to,
414         uint256 value
415     ) internal {
416         // bytes4(keccak256(bytes('approve(address,uint256)')));
417         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
418         require(
419             success && (data.length == 0 || abi.decode(data, (bool))),
420             'TransferHelper::safeApprove: approve failed'
421         );
422     }
423 
424     function safeTransfer(
425         address token,
426         address to,
427         uint256 value
428     ) internal {
429         // bytes4(keccak256(bytes('transfer(address,uint256)')));
430         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
431         require(
432             success && (data.length == 0 || abi.decode(data, (bool))),
433             'TransferHelper::safeTransfer: transfer failed'
434         );
435     }
436 
437     function safeTransferFrom(
438         address token,
439         address from,
440         address to,
441         uint256 value
442     ) internal {
443         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
444         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
445         require(
446             success && (data.length == 0 || abi.decode(data, (bool))),
447             'TransferHelper::transferFrom: transferFrom failed'
448         );
449     }
450 
451     function safeTransferETH(address to, uint256 value) internal {
452         (bool success, ) = to.call{value: value}(new bytes(0));
453         require(success, 'TransferHelper::safeTransferETH: ETH transfer failed');
454     }
455 }
456 
457 // File: localhost/contracts/interfaces/IYouSwapFactory.sol
458 
459 pragma solidity >=0.5.0;
460 
461 interface IYouSwapFactory {
462     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
463 
464     function feeTo() external view returns (address);
465     function feeToSetter() external view returns (address);
466 
467     function getPair(address tokenA, address tokenB) external view returns (address pair);
468     function allPairs(uint) external view returns (address pair);
469     function allPairsLength() external view returns (uint);
470 
471     function createPair(address tokenA, address tokenB) external returns (address pair);
472 
473     function setFeeTo(address) external;
474     function setFeeToSetter(address) external;
475 
476     function setFeeToRate(uint256) external;
477     function feeToRate() external view returns (uint256);
478 }
479 
480 // File: localhost/contracts/YouSwapRouter.sol
481 
482 pragma solidity =0.6.6;
483 
484 
485 
486 
487 
488 
489 
490 
491 
492 
493 contract YouSwapRouter is IYouSwapRouter, Ownable {
494     using SafeMath for uint;
495 
496     address public immutable override factory;
497     address public immutable override WETH;
498     address public override swapMining;
499 
500     modifier ensure(uint deadline) {
501         require(deadline >= block.timestamp, 'YouSwapRouter: EXPIRED');
502         _;
503     }
504 
505     constructor(address _factory, address _WETH) public {
506         factory = _factory;
507         WETH = _WETH;
508     }
509 
510     receive() external payable {
511         assert(msg.sender == WETH); // only accept ETH via fallback from the WETH contract
512     }
513 
514     function setSwapMining(address _swapMininng) public onlyOwner {
515         swapMining = _swapMininng;
516     }
517 
518     // **** ADD LIQUIDITY ****
519     function _addLiquidity(
520         address tokenA,
521         address tokenB,
522         uint amountADesired,
523         uint amountBDesired,
524         uint amountAMin,
525         uint amountBMin
526     ) internal virtual returns (uint amountA, uint amountB) {
527         // create the pair if it doesn't exist yet
528         if (IYouSwapFactory(factory).getPair(tokenA, tokenB) == address(0)) {
529             IYouSwapFactory(factory).createPair(tokenA, tokenB);
530         }
531         (uint reserveA, uint reserveB) = YouSwapLibrary.getReserves(factory, tokenA, tokenB);
532         if (reserveA == 0 && reserveB == 0) {
533             (amountA, amountB) = (amountADesired, amountBDesired);
534         } else {
535             uint amountBOptimal = YouSwapLibrary.quote(amountADesired, reserveA, reserveB);
536             if (amountBOptimal <= amountBDesired) {
537                 require(amountBOptimal >= amountBMin, 'YouSwapRouter: INSUFFICIENT_B_AMOUNT');
538                 (amountA, amountB) = (amountADesired, amountBOptimal);
539             } else {
540                 uint amountAOptimal = YouSwapLibrary.quote(amountBDesired, reserveB, reserveA);
541                 assert(amountAOptimal <= amountADesired);
542                 require(amountAOptimal >= amountAMin, 'YouSwapRouter: INSUFFICIENT_A_AMOUNT');
543                 (amountA, amountB) = (amountAOptimal, amountBDesired);
544             }
545         }
546     }
547     function addLiquidity(
548         address tokenA,
549         address tokenB,
550         uint amountADesired,
551         uint amountBDesired,
552         uint amountAMin,
553         uint amountBMin,
554         address to,
555         uint deadline
556     ) external virtual override ensure(deadline) returns (uint amountA, uint amountB, uint liquidity) {
557         (amountA, amountB) = _addLiquidity(tokenA, tokenB, amountADesired, amountBDesired, amountAMin, amountBMin);
558         address pair = YouSwapLibrary.pairFor(factory, tokenA, tokenB);
559         TransferHelper.safeTransferFrom(tokenA, msg.sender, pair, amountA);
560         TransferHelper.safeTransferFrom(tokenB, msg.sender, pair, amountB);
561         liquidity = IYouSwapPair(pair).mint(to);
562     }
563     function addLiquidityETH(
564         address token,
565         uint amountTokenDesired,
566         uint amountTokenMin,
567         uint amountETHMin,
568         address to,
569         uint deadline
570     ) external virtual override payable ensure(deadline) returns (uint amountToken, uint amountETH, uint liquidity) {
571         (amountToken, amountETH) = _addLiquidity(
572             token,
573             WETH,
574             amountTokenDesired,
575             msg.value,
576             amountTokenMin,
577             amountETHMin
578         );
579         address pair = YouSwapLibrary.pairFor(factory, token, WETH);
580         TransferHelper.safeTransferFrom(token, msg.sender, pair, amountToken);
581         IWETH(WETH).deposit{value: amountETH}();
582         assert(IWETH(WETH).transfer(pair, amountETH));
583         liquidity = IYouSwapPair(pair).mint(to);
584         // refund dust eth, if any
585         if (msg.value > amountETH) TransferHelper.safeTransferETH(msg.sender, msg.value - amountETH);
586     }
587 
588     // **** REMOVE LIQUIDITY ****
589     function removeLiquidity(
590         address tokenA,
591         address tokenB,
592         uint liquidity,
593         uint amountAMin,
594         uint amountBMin,
595         address to,
596         uint deadline
597     ) public virtual override ensure(deadline) returns (uint amountA, uint amountB) {
598         address pair = YouSwapLibrary.pairFor(factory, tokenA, tokenB);
599         IYouSwapPair(pair).transferFrom(msg.sender, pair, liquidity); // send liquidity to pair
600         (uint amount0, uint amount1) = IYouSwapPair(pair).burn(to);
601         (address token0,) = YouSwapLibrary.sortTokens(tokenA, tokenB);
602         (amountA, amountB) = tokenA == token0 ? (amount0, amount1) : (amount1, amount0);
603         require(amountA >= amountAMin, 'YouSwapRouter: INSUFFICIENT_A_AMOUNT');
604         require(amountB >= amountBMin, 'YouSwapRouter: INSUFFICIENT_B_AMOUNT');
605     }
606     function removeLiquidityETH(
607         address token,
608         uint liquidity,
609         uint amountTokenMin,
610         uint amountETHMin,
611         address to,
612         uint deadline
613     ) public virtual override ensure(deadline) returns (uint amountToken, uint amountETH) {
614         (amountToken, amountETH) = removeLiquidity(
615             token,
616             WETH,
617             liquidity,
618             amountTokenMin,
619             amountETHMin,
620             address(this),
621             deadline
622         );
623         TransferHelper.safeTransfer(token, to, amountToken);
624         IWETH(WETH).withdraw(amountETH);
625         TransferHelper.safeTransferETH(to, amountETH);
626     }
627     function removeLiquidityWithPermit(
628         address tokenA,
629         address tokenB,
630         uint liquidity,
631         uint amountAMin,
632         uint amountBMin,
633         address to,
634         uint deadline,
635         bool approveMax, uint8 v, bytes32 r, bytes32 s
636     ) external virtual override returns (uint amountA, uint amountB) {
637         address pair = YouSwapLibrary.pairFor(factory, tokenA, tokenB);
638         uint value = approveMax ? uint(-1) : liquidity;
639         IYouSwapPair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
640         (amountA, amountB) = removeLiquidity(tokenA, tokenB, liquidity, amountAMin, amountBMin, to, deadline);
641     }
642     function removeLiquidityETHWithPermit(
643         address token,
644         uint liquidity,
645         uint amountTokenMin,
646         uint amountETHMin,
647         address to,
648         uint deadline,
649         bool approveMax, uint8 v, bytes32 r, bytes32 s
650     ) external virtual override returns (uint amountToken, uint amountETH) {
651         address pair = YouSwapLibrary.pairFor(factory, token, WETH);
652         uint value = approveMax ? uint(-1) : liquidity;
653         IYouSwapPair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
654         (amountToken, amountETH) = removeLiquidityETH(token, liquidity, amountTokenMin, amountETHMin, to, deadline);
655     }
656 
657     // **** REMOVE LIQUIDITY (supporting fee-on-transfer tokens) ****
658     function removeLiquidityETHSupportingFeeOnTransferTokens(
659         address token,
660         uint liquidity,
661         uint amountTokenMin,
662         uint amountETHMin,
663         address to,
664         uint deadline
665     ) public virtual override ensure(deadline) returns (uint amountETH) {
666         (, amountETH) = removeLiquidity(
667             token,
668             WETH,
669             liquidity,
670             amountTokenMin,
671             amountETHMin,
672             address(this),
673             deadline
674         );
675         TransferHelper.safeTransfer(token, to, IERC20(token).balanceOf(address(this)));
676         IWETH(WETH).withdraw(amountETH);
677         TransferHelper.safeTransferETH(to, amountETH);
678     }
679     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
680         address token,
681         uint liquidity,
682         uint amountTokenMin,
683         uint amountETHMin,
684         address to,
685         uint deadline,
686         bool approveMax, uint8 v, bytes32 r, bytes32 s
687     ) external virtual override returns (uint amountETH) {
688         address pair = YouSwapLibrary.pairFor(factory, token, WETH);
689         uint value = approveMax ? uint(-1) : liquidity;
690         IYouSwapPair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
691         amountETH = removeLiquidityETHSupportingFeeOnTransferTokens(
692             token, liquidity, amountTokenMin, amountETHMin, to, deadline
693         );
694     }
695 
696     // **** SWAP ****
697     // requires the initial amount to have already been sent to the first pair
698     function _swap(uint[] memory amounts, address[] memory path, address _to) internal virtual {
699         for (uint i; i < path.length - 1; i++) {
700             (address input, address output) = (path[i], path[i + 1]);
701             (address token0,) = YouSwapLibrary.sortTokens(input, output);
702             uint amountOut = amounts[i + 1];
703             if (swapMining != address(0)) {
704                 ISwapMining(swapMining).swap(msg.sender, input, output, amountOut);
705             }
706             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOut) : (amountOut, uint(0));
707             address to = i < path.length - 2 ? YouSwapLibrary.pairFor(factory, output, path[i + 2]) : _to;
708             IYouSwapPair(YouSwapLibrary.pairFor(factory, input, output)).swap(
709                 amount0Out, amount1Out, to, new bytes(0)
710             );
711         }
712     }
713     function swapExactTokensForTokens(
714         uint amountIn,
715         uint amountOutMin,
716         address[] calldata path,
717         address to,
718         uint deadline
719     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
720         amounts = YouSwapLibrary.getAmountsOut(factory, amountIn, path);
721         require(amounts[amounts.length - 1] >= amountOutMin, 'YouSwapRouter: INSUFFICIENT_OUTPUT_AMOUNT');
722         TransferHelper.safeTransferFrom(
723             path[0], msg.sender, YouSwapLibrary.pairFor(factory, path[0], path[1]), amounts[0]
724         );
725         _swap(amounts, path, to);
726     }
727     function swapTokensForExactTokens(
728         uint amountOut,
729         uint amountInMax,
730         address[] calldata path,
731         address to,
732         uint deadline
733     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
734         amounts = YouSwapLibrary.getAmountsIn(factory, amountOut, path);
735         require(amounts[0] <= amountInMax, 'YouSwapRouter: EXCESSIVE_INPUT_AMOUNT');
736         TransferHelper.safeTransferFrom(
737             path[0], msg.sender, YouSwapLibrary.pairFor(factory, path[0], path[1]), amounts[0]
738         );
739         _swap(amounts, path, to);
740     }
741     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
742         external
743         virtual
744         override
745         payable
746         ensure(deadline)
747         returns (uint[] memory amounts)
748     {
749         require(path[0] == WETH, 'YouSwapRouter: INVALID_PATH');
750         amounts = YouSwapLibrary.getAmountsOut(factory, msg.value, path);
751         require(amounts[amounts.length - 1] >= amountOutMin, 'YouSwapRouter: INSUFFICIENT_OUTPUT_AMOUNT');
752         IWETH(WETH).deposit{value: amounts[0]}();
753         assert(IWETH(WETH).transfer(YouSwapLibrary.pairFor(factory, path[0], path[1]), amounts[0]));
754         _swap(amounts, path, to);
755     }
756     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
757         external
758         virtual
759         override
760         ensure(deadline)
761         returns (uint[] memory amounts)
762     {
763         require(path[path.length - 1] == WETH, 'YouSwapRouter: INVALID_PATH');
764         amounts = YouSwapLibrary.getAmountsIn(factory, amountOut, path);
765         require(amounts[0] <= amountInMax, 'YouSwapRouter: EXCESSIVE_INPUT_AMOUNT');
766         TransferHelper.safeTransferFrom(
767             path[0], msg.sender, YouSwapLibrary.pairFor(factory, path[0], path[1]), amounts[0]
768         );
769         _swap(amounts, path, address(this));
770         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
771         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
772     }
773     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
774         external
775         virtual
776         override
777         ensure(deadline)
778         returns (uint[] memory amounts)
779     {
780         require(path[path.length - 1] == WETH, 'YouSwapRouter: INVALID_PATH');
781         amounts = YouSwapLibrary.getAmountsOut(factory, amountIn, path);
782         require(amounts[amounts.length - 1] >= amountOutMin, 'YouSwapRouter: INSUFFICIENT_OUTPUT_AMOUNT');
783         TransferHelper.safeTransferFrom(
784             path[0], msg.sender, YouSwapLibrary.pairFor(factory, path[0], path[1]), amounts[0]
785         );
786         _swap(amounts, path, address(this));
787         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
788         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
789     }
790     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
791         external
792         virtual
793         override
794         payable
795         ensure(deadline)
796         returns (uint[] memory amounts)
797     {
798         require(path[0] == WETH, 'YouSwapRouter: INVALID_PATH');
799         amounts = YouSwapLibrary.getAmountsIn(factory, amountOut, path);
800         require(amounts[0] <= msg.value, 'YouSwapRouter: EXCESSIVE_INPUT_AMOUNT');
801         IWETH(WETH).deposit{value: amounts[0]}();
802         assert(IWETH(WETH).transfer(YouSwapLibrary.pairFor(factory, path[0], path[1]), amounts[0]));
803         _swap(amounts, path, to);
804         // refund dust eth, if any
805         if (msg.value > amounts[0]) TransferHelper.safeTransferETH(msg.sender, msg.value - amounts[0]);
806     }
807 
808     // **** SWAP (supporting fee-on-transfer tokens) ****
809     // requires the initial amount to have already been sent to the first pair
810     function _swapSupportingFeeOnTransferTokens(address[] memory path, address _to) internal virtual {
811         for (uint i; i < path.length - 1; i++) {
812             (address input, address output) = (path[i], path[i + 1]);
813             (address token0,) = YouSwapLibrary.sortTokens(input, output);
814             IYouSwapPair pair = IYouSwapPair(YouSwapLibrary.pairFor(factory, input, output));
815             uint amountInput;
816             uint amountOutput;
817             { // scope to avoid stack too deep errors
818             (uint reserve0, uint reserve1,) = pair.getReserves();
819             (uint reserveInput, uint reserveOutput) = input == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
820             amountInput = IERC20(input).balanceOf(address(pair)).sub(reserveInput);
821             amountOutput = YouSwapLibrary.getAmountOut(amountInput, reserveInput, reserveOutput);
822             }
823             if (swapMining != address(0)) {
824                 ISwapMining(swapMining).swap(msg.sender, input, output, amountOutput);
825             }
826             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOutput) : (amountOutput, uint(0));
827             address to = i < path.length - 2 ? YouSwapLibrary.pairFor(factory, output, path[i + 2]) : _to;
828             pair.swap(amount0Out, amount1Out, to, new bytes(0));
829         }
830     }
831     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
832         uint amountIn,
833         uint amountOutMin,
834         address[] calldata path,
835         address to,
836         uint deadline
837     ) external virtual override ensure(deadline) {
838         TransferHelper.safeTransferFrom(
839             path[0], msg.sender, YouSwapLibrary.pairFor(factory, path[0], path[1]), amountIn
840         );
841         uint balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
842         _swapSupportingFeeOnTransferTokens(path, to);
843         require(
844             IERC20(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
845             'YouSwapRouter: INSUFFICIENT_OUTPUT_AMOUNT'
846         );
847     }
848     function swapExactETHForTokensSupportingFeeOnTransferTokens(
849         uint amountOutMin,
850         address[] calldata path,
851         address to,
852         uint deadline
853     )
854         external
855         virtual
856         override
857         payable
858         ensure(deadline)
859     {
860         require(path[0] == WETH, 'YouSwapRouter: INVALID_PATH');
861         uint amountIn = msg.value;
862         IWETH(WETH).deposit{value: amountIn}();
863         assert(IWETH(WETH).transfer(YouSwapLibrary.pairFor(factory, path[0], path[1]), amountIn));
864         uint balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
865         _swapSupportingFeeOnTransferTokens(path, to);
866         require(
867             IERC20(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
868             'YouSwapRouter: INSUFFICIENT_OUTPUT_AMOUNT'
869         );
870     }
871     function swapExactTokensForETHSupportingFeeOnTransferTokens(
872         uint amountIn,
873         uint amountOutMin,
874         address[] calldata path,
875         address to,
876         uint deadline
877     )
878         external
879         virtual
880         override
881         ensure(deadline)
882     {
883         require(path[path.length - 1] == WETH, 'YouSwapRouter: INVALID_PATH');
884         TransferHelper.safeTransferFrom(
885             path[0], msg.sender, YouSwapLibrary.pairFor(factory, path[0], path[1]), amountIn
886         );
887         _swapSupportingFeeOnTransferTokens(path, address(this));
888         uint amountOut = IERC20(WETH).balanceOf(address(this));
889         require(amountOut >= amountOutMin, 'YouSwapRouter: INSUFFICIENT_OUTPUT_AMOUNT');
890         IWETH(WETH).withdraw(amountOut);
891         TransferHelper.safeTransferETH(to, amountOut);
892     }
893 
894     // **** LIBRARY FUNCTIONS ****
895     function quote(uint amountA, uint reserveA, uint reserveB) public pure virtual override returns (uint amountB) {
896         return YouSwapLibrary.quote(amountA, reserveA, reserveB);
897     }
898 
899     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut)
900         public
901         pure
902         virtual
903         override
904         returns (uint amountOut)
905     {
906         return YouSwapLibrary.getAmountOut(amountIn, reserveIn, reserveOut);
907     }
908 
909     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut)
910         public
911         pure
912         virtual
913         override
914         returns (uint amountIn)
915     {
916         return YouSwapLibrary.getAmountIn(amountOut, reserveIn, reserveOut);
917     }
918 
919     function getAmountsOut(uint amountIn, address[] memory path)
920         public
921         view
922         virtual
923         override
924         returns (uint[] memory amounts)
925     {
926         return YouSwapLibrary.getAmountsOut(factory, amountIn, path);
927     }
928 
929     function getAmountsIn(uint amountOut, address[] memory path)
930         public
931         view
932         virtual
933         override
934         returns (uint[] memory amounts)
935     {
936         return YouSwapLibrary.getAmountsIn(factory, amountOut, path);
937     }
938 }