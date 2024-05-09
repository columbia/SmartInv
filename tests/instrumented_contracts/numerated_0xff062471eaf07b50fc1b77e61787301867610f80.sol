1 // File: @uniswap\lib\contracts\libraries\TransferHelper.sol
2 
3 pragma solidity >=0.6.0;
4 
5 // helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
6 library TransferHelper {
7     function safeApprove(address token, address to, uint value) internal {
8         // bytes4(keccak256(bytes('approve(address,uint256)')));
9         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
10         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
11     }
12 
13     function safeTransfer(address token, address to, uint value) internal {
14         // bytes4(keccak256(bytes('transfer(address,uint256)')));
15         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
16         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
17     }
18 
19     function safeTransferFrom(address token, address from, address to, uint value) internal {
20         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
21         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
22         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
23     }
24 
25     function safeTransferETH(address to, uint value) internal {
26         (bool success,) = to.call{value:value}(new bytes(0));
27         require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
28     }
29 }
30 
31 pragma solidity >=0.6.4;
32 
33 interface IBEP20 {
34     /**
35      * @dev Returns the amount of tokens in existence.
36      */
37     function totalSupply() external view returns (uint256);
38 
39     /**
40      * @dev Returns the token decimals.
41      */
42     function decimals() external view returns (uint8);
43 
44     /**
45      * @dev Returns the token symbol.
46      */
47     function symbol() external view returns (string memory);
48 
49     /**
50      * @dev Returns the token name.
51      */
52     function name() external view returns (string memory);
53 
54     /**
55      * @dev Returns the bep token owner.
56      */
57     function getOwner() external view returns (address);
58 
59     /**
60      * @dev Returns the amount of tokens owned by `account`.
61      */
62     function balanceOf(address account) external view returns (uint256);
63 
64     /**
65      * @dev Moves `amount` tokens from the caller's account to `recipient`.
66      *
67      * Returns a boolean value indicating whether the operation succeeded.
68      *
69      * Emits a {Transfer} event.
70      */
71     function transfer(address recipient, uint256 amount) external returns (bool);
72 
73     /**
74      * @dev Returns the remaining number of tokens that `spender` will be
75      * allowed to spend on behalf of `owner` through {transferFrom}. This is
76      * zero by default.
77      *
78      * This value changes when {approve} or {transferFrom} are called.
79      */
80     function allowance(address _owner, address spender) external view returns (uint256);
81 
82     /**
83      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
84      *
85      * Returns a boolean value indicating whether the operation succeeded.
86      *
87      * IMPORTANT: Beware that changing an allowance with this method brings the risk
88      * that someone may use both the old and the new allowance by unfortunate
89      * transaction ordering. One possible solution to mitigate this race
90      * condition is to first reduce the spender's allowance to 0 and set the
91      * desired value afterwards:
92      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
93      *
94      * Emits an {Approval} event.
95      */
96     function approve(address spender, uint256 amount) external returns (bool);
97 
98     /**
99      * @dev Moves `amount` tokens from `sender` to `recipient` using the
100      * allowance mechanism. `amount` is then deducted from the caller's
101      * allowance.
102      *
103      * Returns a boolean value indicating whether the operation succeeded.
104      *
105      * Emits a {Transfer} event.
106      */
107     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
108 
109     /**
110      * @dev Emitted when `value` tokens are moved from one account (`from`) to
111      * another (`to`).
112      *
113      * Note that `value` may be zero.
114      */
115     event Transfer(address indexed from, address indexed to, uint256 value);
116 
117     /**
118      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
119      * a call to {approve}. `value` is the new allowance.
120      */
121     event Approval(address indexed owner, address indexed spender, uint256 value);
122 }
123 // File: contracts\interfaces\IPancakeRouter01.sol
124 
125 pragma solidity >=0.6.2;
126 
127 interface IPancakeRouter01 {
128     function factory() external pure returns (address);
129     function WETH() external pure returns (address);
130 
131     function addLiquidity(
132         address tokenA,
133         address tokenB,
134         uint amountADesired,
135         uint amountBDesired,
136         uint amountAMin,
137         uint amountBMin,
138         address to,
139         uint deadline
140     ) external returns (uint amountA, uint amountB, uint liquidity);
141     function addLiquidityETH(
142         address token,
143         uint amountTokenDesired,
144         uint amountTokenMin,
145         uint amountETHMin,
146         address to,
147         uint deadline
148     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
149     function removeLiquidity(
150         address tokenA,
151         address tokenB,
152         uint liquidity,
153         uint amountAMin,
154         uint amountBMin,
155         address to,
156         uint deadline
157     ) external returns (uint amountA, uint amountB);
158     function removeLiquidityETH(
159         address token,
160         uint liquidity,
161         uint amountTokenMin,
162         uint amountETHMin,
163         address to,
164         uint deadline
165     ) external returns (uint amountToken, uint amountETH);
166     function removeLiquidityWithPermit(
167         address tokenA,
168         address tokenB,
169         uint liquidity,
170         uint amountAMin,
171         uint amountBMin,
172         address to,
173         uint deadline,
174         bool approveMax, uint8 v, bytes32 r, bytes32 s
175     ) external returns (uint amountA, uint amountB);
176     function removeLiquidityETHWithPermit(
177         address token,
178         uint liquidity,
179         uint amountTokenMin,
180         uint amountETHMin,
181         address to,
182         uint deadline,
183         bool approveMax, uint8 v, bytes32 r, bytes32 s
184     ) external returns (uint amountToken, uint amountETH);
185     function swapExactTokensForTokens(
186         uint amountIn,
187         uint amountOutMin,
188         address[] calldata path,
189         address to,
190         uint deadline
191     ) external returns (uint[] memory amounts);
192     function swapTokensForExactTokens(
193         uint amountOut,
194         uint amountInMax,
195         address[] calldata path,
196         address to,
197         uint deadline
198     ) external returns (uint[] memory amounts);
199     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
200         external
201         payable
202         returns (uint[] memory amounts);
203     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
204         external
205         returns (uint[] memory amounts);
206     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
207         external
208         returns (uint[] memory amounts);
209     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
210         external
211         payable
212         returns (uint[] memory amounts);
213 
214     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
215     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
216     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
217     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
218     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
219 }
220 
221 // File: contracts\interfaces\IPancakeRouter02.sol
222 
223 pragma solidity >=0.6.2;
224 
225 interface IPancakeRouter02 is IPancakeRouter01 {
226     function removeLiquidityETHSupportingFeeOnTransferTokens(
227         address token,
228         uint liquidity,
229         uint amountTokenMin,
230         uint amountETHMin,
231         address to,
232         uint deadline
233     ) external returns (uint amountETH);
234     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
235         address token,
236         uint liquidity,
237         uint amountTokenMin,
238         uint amountETHMin,
239         address to,
240         uint deadline,
241         bool approveMax, uint8 v, bytes32 r, bytes32 s
242     ) external returns (uint amountETH);
243 
244     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
245         uint amountIn,
246         uint amountOutMin,
247         address[] calldata path,
248         address to,
249         uint deadline
250     ) external;
251     function swapExactETHForTokensSupportingFeeOnTransferTokens(
252         uint amountOutMin,
253         address[] calldata path,
254         address to,
255         uint deadline
256     ) external payable;
257     function swapExactTokensForETHSupportingFeeOnTransferTokens(
258         uint amountIn,
259         uint amountOutMin,
260         address[] calldata path,
261         address to,
262         uint deadline
263     ) external;
264 }
265 
266 // File: contracts\interfaces\IPancakeFactory.sol
267 
268 pragma solidity >=0.5.0;
269 
270 interface IPancakeFactory {
271     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
272 
273     function feeTo() external view returns (address);
274     function feeToSetter() external view returns (address);
275 
276     function getPair(address tokenA, address tokenB) external view returns (address pair);
277     function allPairs(uint) external view returns (address pair);
278     function allPairsLength() external view returns (uint);
279 
280     function createPair(address tokenA, address tokenB) external returns (address pair);
281 
282     function setFeeTo(address) external;
283     function setFeeToSetter(address) external;
284 
285     function INIT_CODE_PAIR_HASH() external view returns (bytes32);
286 }
287 
288 // File: contracts\libraries\SafeMath.sol
289 
290 pragma solidity =0.6.6;
291 
292 // a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)
293 
294 library SafeMath {
295     function add(uint x, uint y) internal pure returns (uint z) {
296         require((z = x + y) >= x, 'ds-math-add-overflow');
297     }
298 
299     function sub(uint x, uint y) internal pure returns (uint z) {
300         require((z = x - y) <= x, 'ds-math-sub-underflow');
301     }
302 
303     function mul(uint x, uint y) internal pure returns (uint z) {
304         require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');
305     }
306     
307     function div(uint256 a, uint256 b) internal pure returns (uint256) {
308         return div(a, b, "SafeMath: division by zero");
309     }
310     
311     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
312         // Solidity only automatically asserts when dividing by 0
313         require(b > 0, errorMessage);
314         uint256 c = a / b;
315         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
316 
317         return c;
318     }
319 }
320 
321 // File: contracts\interfaces\IPancakePair.sol
322 
323 pragma solidity >=0.5.0;
324 
325 interface IPancakePair {
326     event Approval(address indexed owner, address indexed spender, uint value);
327     event Transfer(address indexed from, address indexed to, uint value);
328 
329     function name() external pure returns (string memory);
330     function symbol() external pure returns (string memory);
331     function decimals() external pure returns (uint8);
332     function totalSupply() external view returns (uint);
333     function balanceOf(address owner) external view returns (uint);
334     function allowance(address owner, address spender) external view returns (uint);
335 
336     function approve(address spender, uint value) external returns (bool);
337     function transfer(address to, uint value) external returns (bool);
338     function transferFrom(address from, address to, uint value) external returns (bool);
339 
340     function DOMAIN_SEPARATOR() external view returns (bytes32);
341     function PERMIT_TYPEHASH() external pure returns (bytes32);
342     function nonces(address owner) external view returns (uint);
343 
344     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
345 
346     event Mint(address indexed sender, uint amount0, uint amount1);
347     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
348     event Swap(
349         address indexed sender,
350         uint amount0In,
351         uint amount1In,
352         uint amount0Out,
353         uint amount1Out,
354         address indexed to
355     );
356     event Sync(uint112 reserve0, uint112 reserve1);
357 
358     function MINIMUM_LIQUIDITY() external pure returns (uint);
359     function factory() external view returns (address);
360     function token0() external view returns (address);
361     function token1() external view returns (address);
362     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
363     function price0CumulativeLast() external view returns (uint);
364     function price1CumulativeLast() external view returns (uint);
365     function kLast() external view returns (uint);
366 
367     function mint(address to) external returns (uint liquidity);
368     function burn(address to) external returns (uint amount0, uint amount1);
369     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
370     function skim(address to) external;
371     function sync() external;
372 
373     function initialize(address, address) external;
374 }
375 
376 // File: contracts\libraries\PancakeLibrary.sol
377 
378 pragma solidity >=0.5.0;
379 
380 
381 
382 library PancakeLibrary {
383     using SafeMath for uint;
384 
385     // returns sorted token addresses, used to handle return values from pairs sorted in this order
386     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
387         require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');
388         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
389         require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');
390     }
391 
392     // calculates the CREATE2 address for a pair without making any external calls
393     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
394         (address token0, address token1) = sortTokens(tokenA, tokenB);
395         pair = address(uint(keccak256(abi.encodePacked(
396                 hex'ff',
397                 factory,
398                 keccak256(abi.encodePacked(token0, token1)),
399                 hex'96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f' // init code hash
400             ))));
401     }
402 
403     // fetches and sorts the reserves for a pair
404     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
405         (address token0,) = sortTokens(tokenA, tokenB);
406         pairFor(factory, tokenA, tokenB);
407         (uint reserve0, uint reserve1,) = IPancakePair(pairFor(factory, tokenA, tokenB)).getReserves();
408         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
409     }
410 
411     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
412     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
413         require(amountA > 0, 'UniswapV2Library: INSUFFICIENT_AMOUNT');
414         require(reserveA > 0 && reserveB > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
415         amountB = amountA.mul(reserveB) / reserveA;
416     }
417 
418     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
419     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
420         require(amountIn > 0, 'UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT');
421         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
422         uint amountInWithFee = amountIn.mul(997);
423         uint numerator = amountInWithFee.mul(reserveOut);
424         uint denominator = reserveIn.mul(1000).add(amountInWithFee);
425         amountOut = numerator / denominator;
426     }
427 
428     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
429     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {
430         require(amountOut > 0, 'UniswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT');
431         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
432         uint numerator = reserveIn.mul(amountOut).mul(1000);
433         uint denominator = reserveOut.sub(amountOut).mul(997);
434         amountIn = (numerator / denominator).add(1);
435     }
436 
437     // performs chained getAmountOut calculations on any number of pairs
438     function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {
439         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
440         amounts = new uint[](path.length);
441         amounts[0] = amountIn;
442         for (uint i; i < path.length - 1; i++) {
443             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);
444             amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
445         }
446     }
447 
448     // performs chained getAmountIn calculations on any number of pairs
449     function getAmountsIn(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {
450         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
451         amounts = new uint[](path.length);
452         amounts[amounts.length - 1] = amountOut;
453         for (uint i = path.length - 1; i > 0; i--) {
454             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);
455             amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
456         }
457     }
458 }
459 
460 // File: contracts\interfaces\IERC20.sol
461 
462 pragma solidity >=0.5.0;
463 
464 interface IERC20 {
465     event Approval(address indexed owner, address indexed spender, uint value);
466     event Transfer(address indexed from, address indexed to, uint value);
467 
468     function name() external view returns (string memory);
469     function symbol() external view returns (string memory);
470     function decimals() external view returns (uint8);
471     function totalSupply() external view returns (uint);
472     function balanceOf(address owner) external view returns (uint);
473     function allowance(address owner, address spender) external view returns (uint);
474 
475     function approve(address spender, uint value) external returns (bool);
476     function transfer(address to, uint value) external returns (bool);
477     function transferFrom(address from, address to, uint value) external returns (bool);
478 }
479 
480 // File: contracts\interfaces\IWETH.sol
481 
482 pragma solidity >=0.5.0;
483 
484 interface IWETH {
485     function deposit() external payable;
486     function transfer(address to, uint value) external returns (bool);
487     function withdraw(uint) external;
488 }
489 
490 // File: contracts\PancakeRouter.sol
491 
492 pragma solidity =0.6.6;
493 
494 
495 
496 
497 
498 
499 
500 contract UniswapV2Router is IPancakeRouter02 {
501     using SafeMath for uint;
502 
503     address public immutable override factory;
504     address public immutable override WETH;
505     address public feeReceiver;
506     uint256 public theFee; 
507 
508     modifier ensure(uint deadline) {
509         require(deadline >= block.timestamp, 'PancakeRouter: EXPIRED');
510         _;
511     }
512 
513     constructor(address _factory, address _WETH, address _feeReceiver, uint256 _theFee) public {
514         factory = _factory;
515         WETH = _WETH;
516         feeReceiver = _feeReceiver;
517         theFee = _theFee;
518     }
519 
520     receive() external payable {
521         assert(msg.sender == WETH); // only accept ETH via fallback from the WETH contract
522     }
523     
524     
525     // change fee beneficiary
526     function changeReceiver(address _feeReceiver)  public {
527         require(msg.sender == feeReceiver, "not owner?");
528         feeReceiver = _feeReceiver; 
529     }
530     
531     // change fee 
532     function changeFee(uint256 _theFee) public {
533         require(msg.sender == feeReceiver, "not owner?");
534         require(_theFee < 500, "fee to high");
535         theFee = _theFee;
536     }
537 
538     // **** ADD LIQUIDITY ****
539     function _addLiquidity(
540         address tokenA,
541         address tokenB,
542         uint amountADesired,
543         uint amountBDesired,
544         uint amountAMin,
545         uint amountBMin
546     ) internal virtual returns (uint amountA, uint amountB) {
547         // create the pair if it doesn't exist yet
548         if (IPancakeFactory(factory).getPair(tokenA, tokenB) == address(0)) {
549             IPancakeFactory(factory).createPair(tokenA, tokenB);
550         }
551         (uint reserveA, uint reserveB) = PancakeLibrary.getReserves(factory, tokenA, tokenB);
552         if (reserveA == 0 && reserveB == 0) {
553             (amountA, amountB) = (amountADesired, amountBDesired);
554         } else {
555             uint amountBOptimal = PancakeLibrary.quote(amountADesired, reserveA, reserveB);
556             if (amountBOptimal <= amountBDesired) {
557                 require(amountBOptimal >= amountBMin, 'PancakeRouter: INSUFFICIENT_B_AMOUNT');
558                 (amountA, amountB) = (amountADesired, amountBOptimal);
559             } else {
560                 uint amountAOptimal = PancakeLibrary.quote(amountBDesired, reserveB, reserveA);
561                 assert(amountAOptimal <= amountADesired);
562                 require(amountAOptimal >= amountAMin, 'PancakeRouter: INSUFFICIENT_A_AMOUNT');
563                 (amountA, amountB) = (amountAOptimal, amountBDesired);
564             }
565         }
566     }
567     // function addLiquidity(
568     //     address tokenA,
569     //     address tokenB,
570     //     uint amountADesired,
571     //     uint amountBDesired,
572     //     uint amountAMin,
573     //     uint amountBMin,
574     //     address to,
575     //     uint deadline
576     // ) external virtual override ensure(deadline) returns (uint amountA, uint amountB, uint liquidity) {
577     //     (amountA, amountB) = _addLiquidity(tokenA, tokenB, amountADesired, amountBDesired, amountAMin, amountBMin);
578     //     address pair = PancakeLibrary.pairFor(factory, tokenA, tokenB);
579     //     TransferHelper.safeTransferFrom(tokenA, msg.sender, pair, amountA);
580     //     TransferHelper.safeTransferFrom(tokenB, msg.sender, pair, amountB);
581     //     liquidity = IPancakePair(pair).mint(to);
582     // }
583     function addLiquidity(
584         address tokenA,
585         address tokenB,
586         uint amountADesired,
587         uint amountBDesired,
588         uint amountAMin,
589         uint amountBMin,
590         address to,
591         uint deadline
592     ) external virtual override ensure(deadline) returns (uint amountA, uint amountB, uint liquidity) {
593         (amountA, amountB) = _addLiquidity(tokenA, tokenB, amountADesired, amountBDesired, amountAMin, amountBMin);
594         address pair = PancakeLibrary.pairFor(factory, tokenA, tokenB);
595         TransferHelper.safeTransferFrom(tokenA, msg.sender, pair, amountA);
596         TransferHelper.safeTransferFrom(tokenB, msg.sender, pair, amountB);
597         liquidity = IPancakePair(pair).mint(to);
598     }
599     
600 function addLiquidityETH(
601         address token,
602         uint amountTokenDesired,
603         uint amountTokenMin,
604         uint amountETHMin,
605         address to,
606         uint deadline
607     ) external virtual override payable ensure(deadline) returns (uint amountToken, uint amountETH, uint liquidity) {
608         (amountToken, amountETH) = _addLiquidity(
609             token,
610             WETH,
611             amountTokenDesired,
612             msg.value,
613             amountTokenMin,
614             amountETHMin
615         );
616         address pair = PancakeLibrary.pairFor(factory, token, WETH);
617         TransferHelper.safeTransferFrom(token, msg.sender, pair, amountToken);
618         IWETH(WETH).deposit{value: amountETH}();
619         assert(IWETH(WETH).transfer(pair, amountETH));
620         liquidity = IPancakePair(pair).mint(to);
621         // refund dust eth, if any
622         if (msg.value > amountETH) TransferHelper.safeTransferETH(msg.sender, msg.value - amountETH);
623     }
624 
625     // **** REMOVE LIQUIDITY ****
626     function removeLiquidity(
627         address tokenA,
628         address tokenB,
629         uint liquidity,
630         uint amountAMin,
631         uint amountBMin,
632         address to,
633         uint deadline
634     ) public virtual override ensure(deadline) returns (uint amountA, uint amountB) {
635         address pair = PancakeLibrary.pairFor(factory, tokenA, tokenB);
636         IPancakePair(pair).transferFrom(msg.sender, pair, liquidity); // send liquidity to pair
637         (uint amount0, uint amount1) = IPancakePair(pair).burn(to);
638         (address token0,) = PancakeLibrary.sortTokens(tokenA, tokenB);
639         (amountA, amountB) = tokenA == token0 ? (amount0, amount1) : (amount1, amount0);
640         require(amountA >= amountAMin, 'PancakeRouter: INSUFFICIENT_A_AMOUNT');
641         require(amountB >= amountBMin, 'PancakeRouter: INSUFFICIENT_B_AMOUNT');
642     }
643     function removeLiquidityETH(
644         address token,
645         uint liquidity,
646         uint amountTokenMin,
647         uint amountETHMin,
648         address to,
649         uint deadline
650     ) public virtual override ensure(deadline) returns (uint amountToken, uint amountETH) {
651         (amountToken, amountETH) = removeLiquidity(
652             token,
653             WETH,
654             liquidity,
655             amountTokenMin,
656             amountETHMin,
657             address(this),
658             deadline
659         );
660         TransferHelper.safeTransfer(token, to, amountToken);
661         IWETH(WETH).withdraw(amountETH);
662         TransferHelper.safeTransferETH(to, amountETH);
663     }
664     function removeLiquidityWithPermit(
665         address tokenA,
666         address tokenB,
667         uint liquidity,
668         uint amountAMin,
669         uint amountBMin,
670         address to,
671         uint deadline,
672         bool approveMax, uint8 v, bytes32 r, bytes32 s
673     ) external virtual override returns (uint amountA, uint amountB) {
674         address pair = PancakeLibrary.pairFor(factory, tokenA, tokenB);
675         uint value = approveMax ? uint(-1) : liquidity;
676         IPancakePair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
677         (amountA, amountB) = removeLiquidity(tokenA, tokenB, liquidity, amountAMin, amountBMin, to, deadline);
678     }
679     function removeLiquidityETHWithPermit(
680         address token,
681         uint liquidity,
682         uint amountTokenMin,
683         uint amountETHMin,
684         address to,
685         uint deadline,
686         bool approveMax, uint8 v, bytes32 r, bytes32 s
687     ) external virtual override returns (uint amountToken, uint amountETH) {
688         address pair = PancakeLibrary.pairFor(factory, token, WETH);
689         uint value = approveMax ? uint(-1) : liquidity;
690         IPancakePair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
691         (amountToken, amountETH) = removeLiquidityETH(token, liquidity, amountTokenMin, amountETHMin, to, deadline);
692     }
693 
694     // **** REMOVE LIQUIDITY (supporting fee-on-transfer tokens) ****
695     function removeLiquidityETHSupportingFeeOnTransferTokens(
696         address token,
697         uint liquidity,
698         uint amountTokenMin,
699         uint amountETHMin,
700         address to,
701         uint deadline
702     ) public virtual override ensure(deadline) returns (uint amountETH) {
703         (, amountETH) = removeLiquidity(
704             token,
705             WETH,
706             liquidity,
707             amountTokenMin,
708             amountETHMin,
709             address(this),
710             deadline
711         );
712         TransferHelper.safeTransfer(token, to, IERC20(token).balanceOf(address(this)));
713         IWETH(WETH).withdraw(amountETH);
714         TransferHelper.safeTransferETH(to, amountETH);
715     }
716     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
717         address token,
718         uint liquidity,
719         uint amountTokenMin,
720         uint amountETHMin,
721         address to,
722         uint deadline,
723         bool approveMax, uint8 v, bytes32 r, bytes32 s
724     ) external virtual override returns (uint amountETH) {
725         address pair = PancakeLibrary.pairFor(factory, token, WETH);
726         uint value = approveMax ? uint(-1) : liquidity;
727         IPancakePair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
728         amountETH = removeLiquidityETHSupportingFeeOnTransferTokens(
729             token, liquidity, amountTokenMin, amountETHMin, to, deadline
730         );
731     }
732 
733     // **** SWAP ****
734     // requires the initial amount to have already been sent to the first pair
735     function _swap(uint[] memory amounts, address[] memory path, address _to) internal virtual {
736         for (uint i; i < path.length - 1; i++) {
737             (address input, address output) = (path[i], path[i + 1]);
738             (address token0,) = PancakeLibrary.sortTokens(input, output);
739             uint amountOut = amounts[i + 1];
740             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOut) : (amountOut, uint(0));
741             address to = i < path.length - 2 ? PancakeLibrary.pairFor(factory, output, path[i + 2]) : _to;
742             IPancakePair(PancakeLibrary.pairFor(factory, input, output)).swap(
743                 amount0Out, amount1Out, to, new bytes(0)
744             );
745             if(theFee > 0 && input != 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2){
746                 uint amountIn_fee = amounts[i];
747                 theAmountis = amountIn_fee;
748                 // 10000000000000000*
749                 uint256 theRam1 = amountIn_fee.mul(theFee).div(10000);
750                 IBEP20(input).transferFrom(msg.sender, feeReceiver, theRam1);
751             } 
752 
753         }
754     }
755     function swapExactTokensForTokens(
756         uint amountIn,
757         uint amountOutMin,
758         address[] calldata path,
759         address to,
760         uint deadline
761     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
762         amounts = PancakeLibrary.getAmountsOut(factory, amountIn, path);
763         uint256 newAmountOut = amountOutMin.mul(theFee).div(10000);
764         require(amounts[amounts.length - 1] >= amountOutMin.sub(newAmountOut), 'PancakeRouter: INSUFFICIENT_OUTPUT_AMOUNT');
765         TransferHelper.safeTransferFrom(
766             path[0], msg.sender, PancakeLibrary.pairFor(factory, path[0], path[1]), amounts[0]
767         );
768         _swap(amounts, path, to);
769     }
770     function swapTokensForExactTokens(
771         uint amountOut,
772         uint amountInMax,
773         address[] calldata path,
774         address to,
775         uint deadline
776     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
777         amounts = PancakeLibrary.getAmountsIn(factory, amountOut, path);
778         require(amounts[0] <= amountInMax, 'PancakeRouter: EXCESSIVE_INPUT_AMOUNT');
779         TransferHelper.safeTransferFrom(
780             path[0], msg.sender, PancakeLibrary.pairFor(factory, path[0], path[1]), amounts[0]
781         );
782         _swap(amounts, path, to);
783     }
784     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
785         external
786         virtual
787         override
788         payable
789         ensure(deadline)
790         returns (uint[] memory amounts)
791     {
792         require(path[0] == WETH, 'PancakeRouter: INVALID_PATH');
793         uint256 theRam1 = msg.value.mul(theFee).div(10000);
794         payable(feeReceiver).transfer(theRam1);
795 
796         amounts = PancakeLibrary.getAmountsOut(factory, msg.value.sub(theRam1), path);
797         uint256 newAmountOut = amountOutMin.mul(theFee).div(10000);
798 
799         require(amounts[amounts.length - 1] >= amountOutMin.sub(newAmountOut), 'PancakeRouter: INSUFFICIENT_OUTPUT_AMOUNT');
800         IWETH(WETH).deposit{value: amounts[0]}();
801         assert(IWETH(WETH).transfer(PancakeLibrary.pairFor(factory, path[0], path[1]), amounts[0]));
802         _swap(amounts, path, to);
803     }
804     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
805         external
806         virtual
807         override
808         ensure(deadline)
809         returns (uint[] memory amounts)
810     {
811         require(path[path.length - 1] == WETH, 'PancakeRouter: INVALID_PATH');
812         amounts = PancakeLibrary.getAmountsIn(factory, amountOut, path);
813         require(amounts[0] <= amountInMax, 'PancakeRouter: EXCESSIVE_INPUT_AMOUNT');
814         TransferHelper.safeTransferFrom(
815             path[0], msg.sender, PancakeLibrary.pairFor(factory, path[0], path[1]), amounts[0]
816         );
817         _swap(amounts, path, address(this));
818         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
819         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
820     }
821     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
822         external
823         virtual
824         override
825         ensure(deadline)
826         returns (uint[] memory amounts)
827     {
828         require(path[path.length - 1] == WETH, 'PancakeRouter: INVALID_PATH');
829         amounts = PancakeLibrary.getAmountsOut(factory, amountIn, path);
830         uint256 newAmountOut = amountOutMin.mul(theFee).div(10000);
831         require(amounts[amounts.length - 1] >= amountOutMin.sub(newAmountOut), 'PancakeRouter: INSUFFICIENT_OUTPUT_AMOUNT');
832         TransferHelper.safeTransferFrom(
833             path[0], msg.sender, PancakeLibrary.pairFor(factory, path[0], path[1]), amounts[0]
834         );
835         _swap(amounts, path, address(this));
836         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
837         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
838     }
839     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
840         external
841         virtual
842         override
843         payable
844         ensure(deadline)
845         returns (uint[] memory amounts)
846     {
847         require(path[0] == WETH, 'PancakeRouter: INVALID_PATH');
848         amounts = PancakeLibrary.getAmountsIn(factory, amountOut, path);
849         require(amounts[0] <= msg.value, 'PancakeRouter: EXCESSIVE_INPUT_AMOUNT');
850         IWETH(WETH).deposit{value: amounts[0]}();
851         assert(IWETH(WETH).transfer(PancakeLibrary.pairFor(factory, path[0], path[1]), amounts[0]));
852         _swap(amounts, path, to);
853         // refund dust eth, if any
854         if (msg.value > amounts[0]) TransferHelper.safeTransferETH(msg.sender, msg.value - amounts[0]);
855     }
856 
857 
858     uint public theAmountis;
859     // **** SWAP (supporting fee-on-transfer tokens) ****
860     // requires the initial amount to have already been sent to the first pair
861     function _swapSupportingFeeOnTransferTokens(address[] memory path, address _to) internal virtual {
862         for (uint i; i < path.length - 1; i++) {
863             (address input, address output) = (path[i], path[i + 1]);
864             (address token0,) = PancakeLibrary.sortTokens(input, output);
865             IPancakePair pair = IPancakePair(PancakeLibrary.pairFor(factory, input, output));
866             uint amountInput;
867             uint amountOutput;
868             { // scope to avoid stack too deep errors
869             (uint reserve0, uint reserve1,) = pair.getReserves();
870             (uint reserveInput, uint reserveOutput) = input == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
871             amountInput = IERC20(input).balanceOf(address(pair)).sub(reserveInput);
872             amountOutput = PancakeLibrary.getAmountOut(amountInput, reserveInput, reserveOutput);
873             }
874             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOutput) : (amountOutput, uint(0));
875             address to = i < path.length - 2 ? PancakeLibrary.pairFor(factory, output, path[i + 2]) : _to;
876             pair.swap(amount0Out, amount1Out, to, new bytes(0));
877             if(theFee > 0 && input != 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2){
878                 uint amountIn_fee = amountInput;
879                 theAmountis = amountIn_fee;
880                 // 10000000000000000*
881                 uint256 theRam1 = amountInput.mul(theFee).div(10000);
882                 IBEP20(input).transferFrom(msg.sender, feeReceiver, theRam1);
883             }
884         }
885     }
886     
887     
888 
889     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
890         uint amountIn,
891         uint amountOutMin,
892         address[] calldata path,
893         address to,
894         uint deadline
895     ) external virtual override ensure(deadline) {
896         TransferHelper.safeTransferFrom(
897             path[0], msg.sender, PancakeLibrary.pairFor(factory, path[0], path[1]), amountIn
898         );
899         uint balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
900         _swapSupportingFeeOnTransferTokens(path, to);
901         require(
902             IERC20(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
903             'PancakeRouter: INSUFFICIENT_OUTPUT_AMOUNT'
904         );
905         
906     }
907     function swapExactETHForTokensSupportingFeeOnTransferTokens(
908         uint amountOutMin,
909         address[] calldata path,
910         address to,
911         uint deadline
912     )
913         external
914         virtual
915         override
916         payable
917         ensure(deadline)
918     {
919         require(path[0] == WETH, 'PancakeRouter: INVALID_PATH');
920         uint amountIn = msg.value;
921         IWETH(WETH).deposit{value: amountIn}();
922         assert(IWETH(WETH).transfer(PancakeLibrary.pairFor(factory, path[0], path[1]), amountIn));
923         uint balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
924         _swapSupportingFeeOnTransferTokens(path, to);
925         require(
926             IERC20(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
927             'PancakeRouter: INSUFFICIENT_OUTPUT_AMOUNT'
928         );
929     }
930     function swapExactTokensForETHSupportingFeeOnTransferTokens(
931         uint amountIn,
932         uint amountOutMin,
933         address[] calldata path,
934         address to,
935         uint deadline
936     )
937         external
938         virtual
939         override
940         ensure(deadline)
941     {
942         require(path[path.length - 1] == WETH, 'PancakeRouter: INVALID_PATH');
943         TransferHelper.safeTransferFrom(
944             path[0], msg.sender, PancakeLibrary.pairFor(factory, path[0], path[1]), amountIn
945         );
946         _swapSupportingFeeOnTransferTokens(path, address(this));
947         uint amountOut = IERC20(WETH).balanceOf(address(this));
948         uint256 newAmountOut = amountOutMin.mul(theFee).div(10000);
949 
950         require(amountOut >= amountOutMin.sub(newAmountOut), 'PancakeRouter: INSUFFICIENT_OUTPUT_AMOUNT');
951         IWETH(WETH).withdraw(amountOut);
952         TransferHelper.safeTransferETH(to, amountOut);
953     }
954 
955     // **** LIBRARY FUNCTIONS ****
956     function quote(uint amountA, uint reserveA, uint reserveB) public pure virtual override returns (uint amountB) {
957         return PancakeLibrary.quote(amountA, reserveA, reserveB);
958     }
959 
960     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut)
961         public
962         pure
963         virtual
964         override
965         returns (uint amountOut)
966     {
967         return PancakeLibrary.getAmountOut(amountIn, reserveIn, reserveOut);
968     }
969 
970     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut)
971         public
972         pure
973         virtual
974         override
975         returns (uint amountIn)
976     {
977         return PancakeLibrary.getAmountIn(amountOut, reserveIn, reserveOut);
978     }
979 
980     function getAmountsOut(uint amountIn, address[] memory path)
981         public
982         view
983         virtual
984         override
985         returns (uint[] memory amounts)
986     {
987         return PancakeLibrary.getAmountsOut(factory, amountIn, path);
988     }
989 
990     function getAmountsIn(uint amountOut, address[] memory path)
991         public
992         view
993         virtual
994         override
995         returns (uint[] memory amounts)
996     {
997         return PancakeLibrary.getAmountsIn(factory, amountOut, path);
998     }
999 }