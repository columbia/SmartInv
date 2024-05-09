1 // SPDX-License-Identifier: WTFPL
2 pragma solidity >=0.8.0;
3 
4 //  ██████╗ ███████╗███╗   ███╗███████╗██╗    ██╗ █████╗ ██████╗ 
5 // ██╔════╝ ██╔════╝████╗ ████║██╔════╝██║    ██║██╔══██╗██╔══██╗
6 // ██║  ███╗█████╗  ██╔████╔██║███████╗██║ █╗ ██║███████║██████╔╝
7 // ██║   ██║██╔══╝  ██║╚██╔╝██║╚════██║██║███╗██║██╔══██║██╔═══╝ 
8 // ╚██████╔╝███████╗██║ ╚═╝ ██║███████║╚███╔███╔╝██║  ██║██║     
9 //  ╚═════╝ ╚══════╝╚═╝     ╚═╝╚══════╝ ╚══╝╚══╝ ╚═╝  ╚═╝╚═╝   
10 
11 interface IUniswapV2Pair {
12     event Approval(address indexed owner, address indexed spender, uint value);
13     event Transfer(address indexed from, address indexed to, uint value);
14 
15     function name() external pure returns (string memory);
16     function symbol() external pure returns (string memory);
17     function decimals() external pure returns (uint8);
18     function totalSupply() external view returns (uint);
19     function balanceOf(address owner) external view returns (uint);
20     function allowance(address owner, address spender) external view returns (uint);
21 
22     function approve(address spender, uint value) external returns (bool);
23     function transfer(address to, uint value) external returns (bool);
24     function transferFrom(address from, address to, uint value) external returns (bool);
25 
26     function DOMAIN_SEPARATOR() external view returns (bytes32);
27     function PERMIT_TYPEHASH() external pure returns (bytes32);
28     function nonces(address owner) external view returns (uint);
29 
30     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
31 
32     event Mint(address indexed sender, uint amount0, uint amount1);
33     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
34     event Swap(
35         address indexed sender,
36         uint amount0In,
37         uint amount1In,
38         uint amount0Out,
39         uint amount1Out,
40         address indexed to
41     );
42     event Sync(uint112 reserve0, uint112 reserve1);
43 
44     function MINIMUM_LIQUIDITY() external pure returns (uint);
45     function factory() external view returns (address);
46     function token0() external view returns (address);
47     function token1() external view returns (address);
48     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
49     function price0CumulativeLast() external view returns (uint);
50     function price1CumulativeLast() external view returns (uint);
51     function kLast() external view returns (uint);
52 
53     function mint(address to) external returns (uint liquidity);
54     function burn(address to) external returns (uint amount0, uint amount1);
55     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
56     function skim(address to) external;
57     function sync() external;
58 
59     function initialize(address, address) external;
60 }
61 interface IUniswapV2Factory {
62     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
63 
64     function feeTo() external view returns (address);
65     function feeToSetter() external view returns (address);
66 
67     function getPair(address tokenA, address tokenB) external view returns (address pair);
68     function allPairs(uint) external view returns (address pair);
69     function allPairsLength() external view returns (uint);
70 
71     function createPair(address tokenA, address tokenB) external returns (address pair);
72 
73     function setFeeTo(address) external;
74     function setFeeToSetter(address) external;
75 }
76 interface IWETH {
77     function deposit() external payable;
78     function transfer(address to, uint value) external returns (bool);
79     function withdraw(uint) external;
80 }
81 interface IERC20 {
82     event Approval(address indexed owner, address indexed spender, uint value);
83     event Transfer(address indexed from, address indexed to, uint value);
84 
85     function name() external view returns (string memory);
86     function symbol() external view returns (string memory);
87     function decimals() external view returns (uint8);
88     function totalSupply() external view returns (uint);
89     function balanceOf(address owner) external view returns (uint);
90     function allowance(address owner, address spender) external view returns (uint);
91 
92     function approve(address spender, uint value) external returns (bool);
93     function transfer(address to, uint value) external returns (bool);
94     function transferFrom(address from, address to, uint value) external returns (bool);
95 }
96 // helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
97 library TransferHelper {
98     function safeApprove(address token, address to, uint value) internal {
99         // bytes4(keccak256(bytes('approve(address,uint256)')));
100         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
101         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
102     }
103 
104     function safeTransfer(address token, address to, uint value) internal {
105         // bytes4(keccak256(bytes('transfer(address,uint256)')));
106         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
107         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
108     }
109 
110     function safeTransferFrom(address token, address from, address to, uint value) internal {
111         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
112         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
113         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
114     }
115 
116     function safeTransferETH(address to, uint value) internal {
117         (bool success,) = to.call{value:value}(new bytes(0));
118         require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
119     }
120 }
121 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)
122 
123 
124 
125 /**
126  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
127  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
128  *
129  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
130  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
131  * need to send a transaction, and thus is not required to hold Ether at all.
132  */
133 interface IERC20Permit {
134     /**
135      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
136      * given ``owner``'s signed approval.
137      *
138      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
139      * ordering also apply here.
140      *
141      * Emits an {Approval} event.
142      *
143      * Requirements:
144      *
145      * - `spender` cannot be the zero address.
146      * - `deadline` must be a timestamp in the future.
147      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
148      * over the EIP712-formatted function arguments.
149      * - the signature must use ``owner``'s current nonce (see {nonces}).
150      *
151      * For more information on the signature format, see the
152      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
153      * section].
154      */
155     function permit(
156         address owner,
157         address spender,
158         uint256 value,
159         uint256 deadline,
160         uint8 v,
161         bytes32 r,
162         bytes32 s
163     ) external;
164 
165     /**
166      * @dev Returns the current nonce for `owner`. This value must be
167      * included whenever a signature is generated for {permit}.
168      *
169      * Every successful call to {permit} increases ``owner``'s nonce by one. This
170      * prevents a signature from being used multiple times.
171      */
172     function nonces(address owner) external view returns (uint256);
173 
174     /**
175      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
176      */
177     // solhint-disable-next-line func-name-mixedcase
178     function DOMAIN_SEPARATOR() external view returns (bytes32);
179 }
180 
181 interface IGemswapPair {
182     function getReserves() external view returns (
183         uint112 baseReserves, 
184         uint112 quoteReserves, 
185         uint32 lastUpdate
186     );
187 }
188 
189 library GemswapLibrary {
190 
191     uint256 internal constant BIPS_DIVISOR = 10_000;
192 
193     function uDiv(uint256 x, uint256 y) internal pure returns (uint256 z) {assembly {z := div(x, y)}}
194 
195     // returns sorted token addresses, used to handle return values from pairs sorted in this order
196     function sortTokens(
197         address tokenA, 
198         address tokenB
199     ) internal pure returns (address token0, address token1) {
200         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
201     }
202 
203     function predictDeterministicAddress(
204         address implementation,
205         bytes32 salt,
206         address deployer
207     ) internal pure returns (address predicted) {
208         assembly {
209             let ptr := mload(0x40)
210             mstore(ptr, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
211             mstore(add(ptr, 0x14), shl(0x60, implementation))
212             mstore(add(ptr, 0x28), 0x5af43d82803e903d91602b57fd5bf3ff00000000000000000000000000000000)
213             mstore(add(ptr, 0x38), shl(0x60, deployer))
214             mstore(add(ptr, 0x4c), salt)
215             mstore(add(ptr, 0x6c), keccak256(ptr, 0x37))
216             predicted := keccak256(add(ptr, 0x37), 0x55)
217         }
218     }
219 
220     error NONEXISTENT_PAIR();
221 
222     // calculates the clone address for a pair without making any external calls
223     function pairFor(
224         address factory,
225         address implementation,
226         address tokenA, 
227         address tokenB 
228     ) internal pure returns (address pair) {
229         (address token0, address token1) = sortTokens(tokenA, tokenB);
230         pair = predictDeterministicAddress(implementation, keccak256(abi.encodePacked(token0, token1, uint256(1))), factory);
231     }
232 
233     // fetches and sorts the reserves for a pair
234     function getReserves(
235         address factory,
236         address implementation,
237         address tokenA, 
238         address tokenB
239     ) internal view returns (uint256 reserveA, uint256 reserveB) {
240         (address token0,) = sortTokens(tokenA, tokenB);
241         (uint256 baseReserves, uint256 quoteReserves,) = IGemswapPair(pairFor(factory, implementation, tokenA, tokenB)).getReserves();
242         (reserveA, reserveB) = tokenA == token0 ? (baseReserves, quoteReserves) : (quoteReserves, baseReserves);
243     }
244 
245     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
246     function quote(
247         uint256 amountA, 
248         uint256 reserveA, 
249         uint256 reserveB
250     ) internal pure returns (uint256 amountB) {
251         amountB = uDiv(amountA * reserveB, reserveA);
252     }
253 
254     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
255     function getAmountOut(
256         uint256 amountIn, 
257         uint256 reserveIn, 
258         uint256 reserveOut
259     ) internal pure returns (uint256 amountOut) {
260         uint256 amountInWithFee = amountIn * 9975;
261         amountOut = uDiv(amountInWithFee * reserveOut, reserveIn * BIPS_DIVISOR + amountInWithFee);
262     }
263 
264     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
265     function getAmountIn(
266         uint256 amountOut, 
267         uint256 reserveIn, 
268         uint256 reserveOut
269     ) internal pure returns (uint256 amountIn) {
270         amountIn = uDiv(reserveIn * amountOut * BIPS_DIVISOR, reserveOut - amountOut * 9975) + 1;
271     }
272 
273     /* -------------------------------------------------------------------------- */
274     /*                        SHOULD PROB BE UNCHECKED VVV                        */
275     /* -------------------------------------------------------------------------- */
276 
277     // performs chained getAmountOut calculations on any number of pairs
278     function getAmountsOut(
279         address factory,
280         address implementation,
281         uint256 amountIn,
282         address[] memory path
283     ) internal view returns (uint256[] memory amounts) {
284         unchecked {
285             uint256 pathLength = path.length; // save gas
286             
287             amounts = new uint256[](pathLength);
288             amounts[0] = amountIn;
289             
290             for (uint256 i; i < pathLength - 1; ++i) {
291                 (uint256 reserveIn, uint256 reserveOut) = getReserves(factory, implementation, path[i], path[i + 1]);
292                 amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
293             }
294         }
295     }
296 
297     // performs chained getAmountIn calculations on any number of pairs
298     function getAmountsIn(
299         address factory,
300         address implementation,
301         uint256 amountOut, 
302         address[] memory path
303     ) internal view returns (uint256[] memory amounts) {
304         unchecked {
305             uint256 pathLength = path.length; // save gas
306 
307             amounts = new uint256[](pathLength);
308             amounts[pathLength - 1] = amountOut;
309             
310             for (uint256 i = pathLength - 1; i > 0; --i) {
311                 (uint256 reserveIn, uint256 reserveOut) = getReserves(factory, implementation, path[i - 1], path[i]);
312                 amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
313             }
314         }
315     }
316 }
317 
318 interface IERC20PermitAllowed {
319     function permit(
320         address holder,
321         address spender,
322         uint256 nonce,
323         uint256 expiry,
324         bool allowed,
325         uint8 v,
326         bytes32 r,
327         bytes32 s
328     ) external;
329 }
330 
331 contract GemswapRouter {
332 
333     address public immutable factory;
334     address public immutable implementation;
335     address public immutable WETH;
336 
337     modifier ensure(uint256 deadline) {
338         require(deadline >= block.timestamp, "EXPIRED");
339         _;
340     }
341 
342     constructor(
343         address _factory, 
344         address _implementation, 
345         address _WETH
346     ) {
347         factory = _factory;
348         implementation = _implementation;
349         WETH = _WETH;
350     }
351 
352     receive() external payable {
353         // only accept ETH via fallback from the WETH contract
354         assert(msg.sender == WETH); 
355     }
356 
357     /* -------------------------------------------------------------------------- */
358     /*                             ADD LIQUIDITY LOGIC                            */
359     /* -------------------------------------------------------------------------- */
360 
361     function _addLiquidity(
362         address tokenA,
363         address tokenB,
364         uint amountADesired,
365         uint amountBDesired,
366         uint amountAMin,
367         uint amountBMin
368     ) private returns (uint amountA, uint amountB) {
369         // create the pair if it doesn't exist yet
370         if (IUniswapV2Factory(factory).getPair(tokenA, tokenB) == address(0)) {
371             IUniswapV2Factory(factory).createPair(tokenA, tokenB);
372         }
373         (uint reserveA, uint reserveB) = GemswapLibrary.getReserves(factory, implementation, tokenA, tokenB);
374         if (reserveA == 0 && reserveB == 0) {
375             (amountA, amountB) = (amountADesired, amountBDesired);
376         } else {
377             uint amountBOptimal = GemswapLibrary.quote(amountADesired, reserveA, reserveB);
378             if (amountBOptimal <= amountBDesired) {
379                 require(amountBOptimal >= amountBMin, 'Gemswap: INSUFFICIENT_B_AMOUNT');
380                 (amountA, amountB) = (amountADesired, amountBOptimal);
381             } else {
382                 uint amountAOptimal = GemswapLibrary.quote(amountBDesired, reserveB, reserveA);
383                 assert(amountAOptimal <= amountADesired);
384                 require(amountAOptimal >= amountAMin, 'Gemswap: INSUFFICIENT_A_AMOUNT');
385                 (amountA, amountB) = (amountAOptimal, amountBDesired);
386             }
387         }
388     }
389 
390     function addLiquidity(
391         address tokenA,
392         address tokenB,
393         uint256 amountADesired,
394         uint256 amountBDesired,
395         uint256 amountAMin,
396         uint256 amountBMin,
397         address to,
398         uint256 deadline
399     ) external ensure(deadline) returns (uint256 amountA, uint256 amountB, uint256 liquidity) { 
400         (amountA, amountB) = _addLiquidity(tokenA, tokenB, amountADesired, amountBDesired, amountAMin, amountBMin);
401         address pair = GemswapLibrary.pairFor(factory, implementation, tokenA, tokenB);
402         TransferHelper.safeTransferFrom(tokenA, msg.sender, pair, amountA);
403         TransferHelper.safeTransferFrom(tokenB, msg.sender, pair, amountB);
404         liquidity = IUniswapV2Pair(pair).mint(to);
405     }
406 
407     function addLiquidityETH(
408         address token,
409         uint256 amountTokenDesired,
410         uint256 amountTokenMin,
411         uint256 amountETHMin,
412         address to,
413         uint256 deadline
414     ) external payable ensure(deadline) returns (uint256 amountToken, uint256 amountETH, uint256 liquidity) {
415         (amountToken, amountETH) = _addLiquidity(
416             token, 
417             WETH, 
418             amountTokenDesired, 
419             msg.value, 
420             amountTokenMin, 
421             amountETHMin
422         );
423         address pair = GemswapLibrary.pairFor(factory, implementation, token, WETH);
424         TransferHelper.safeTransferFrom(token, msg.sender, pair, amountToken);
425         IWETH(WETH).deposit{value: amountETH}();
426         assert(IWETH(WETH).transfer(pair, amountETH));
427         liquidity = IUniswapV2Pair(pair).mint(to);
428         // refund dust eth, if any
429         if (msg.value > amountETH) TransferHelper.safeTransferETH(msg.sender, msg.value - amountETH);
430     }
431 
432     // **** REMOVE LIQUIDITY ****
433     function removeLiquidity(
434         address tokenA,
435         address tokenB,
436         uint256 liquidity,
437         uint256 amountAMin,
438         uint256 amountBMin,
439         address to,
440         uint256 deadline
441     ) public ensure(deadline) returns (uint256 amountA, uint256 amountB) {
442         address pair = GemswapLibrary.pairFor(factory, implementation, tokenA, tokenB);
443         IUniswapV2Pair(pair).transferFrom(msg.sender, pair, liquidity); // send liquidity to pair
444         (uint256 amount0, uint256 amount1) = IUniswapV2Pair(pair).burn(to);
445         (address token0,) = GemswapLibrary.sortTokens(tokenA, tokenB);
446         (amountA, amountB) = tokenA == token0 ? (amount0, amount1) : (amount1, amount0);
447         require(amountA >= amountAMin, "INSUFFICIENT_A_AMOUNT");
448         require(amountB >= amountBMin, "INSUFFICIENT_B_AMOUNT");
449     }
450 
451     function removeLiquidityETH(
452         address token,
453         uint256 liquidity,
454         uint256 amountTokenMin,
455         uint256 amountETHMin,
456         address to,
457         uint256 deadline
458     ) public ensure(deadline) returns (uint256 amountToken, uint256 amountETH) {
459         (amountToken, amountETH) = removeLiquidity(
460             token, 
461             WETH, 
462             liquidity, 
463             amountTokenMin, 
464             amountETHMin, 
465             address(this), 
466             deadline
467         );
468         TransferHelper.safeTransfer(token, to, amountToken);
469         IWETH(WETH).withdraw(amountETH);
470         TransferHelper.safeTransferETH(to, amountETH);
471     }
472 
473     function removeLiquidityWithPermit(
474         address tokenA,
475         address tokenB,
476         uint256 liquidity,
477         uint256 amountAMin,
478         uint256 amountBMin,
479         address to,
480         uint256 deadline,
481         bool approveMax, uint8 v, bytes32 r, bytes32 s
482     ) external returns (uint256 amountA, uint256 amountB) {
483         IUniswapV2Pair(GemswapLibrary.pairFor(factory, implementation, tokenA, tokenB)).permit(
484             msg.sender, 
485             address(this), 
486             approveMax ? type(uint256).max : liquidity, 
487             deadline, 
488             v, 
489             r, 
490             s
491         );
492         (amountA, amountB) = removeLiquidity(tokenA, tokenB, liquidity, amountAMin, amountBMin, to, deadline);
493     }
494 
495     function removeLiquidityETHWithPermit(
496         address token,
497         uint256 liquidity,
498         uint256 amountTokenMin,
499         uint256 amountETHMin,
500         address to,
501         uint256 deadline,
502         bool approveMax, uint8 v, bytes32 r, bytes32 s
503     ) external returns (uint256 amountToken, uint256 amountETH) {
504         address pair = GemswapLibrary.pairFor(factory, implementation, token, WETH);
505         uint256 value = approveMax ? type(uint256).max : liquidity;
506         IUniswapV2Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
507         (amountToken, amountETH) = removeLiquidityETH(token, liquidity, amountTokenMin, amountETHMin, to, deadline);
508     }
509 
510     // **** REMOVE LIQUIDITY (supporting fee-on-transfer tokens) ****
511     function removeLiquidityETHSupportingFeeOnTransferTokens(
512         address token,
513         uint256 liquidity,
514         uint256 amountTokenMin,
515         uint256 amountETHMin,
516         address to,
517         uint256 deadline
518     ) public ensure(deadline) returns (uint256 amountETH) {
519         (, amountETH) = removeLiquidity(token, WETH, liquidity, amountTokenMin, amountETHMin, address(this), deadline);
520         TransferHelper.safeTransfer(token, to, IERC20(token).balanceOf(address(this)));
521         IWETH(WETH).withdraw(amountETH);
522         TransferHelper.safeTransferETH(to, amountETH);
523     }
524 
525     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
526         address token,
527         uint256 liquidity,
528         uint256 amountTokenMin,
529         uint256 amountETHMin,
530         address to,
531         uint256 deadline,
532         bool approveMax, uint8 v, bytes32 r, bytes32 s
533     ) external returns (uint256 amountETH) {
534         address pair = GemswapLibrary.pairFor(factory, implementation, token, WETH);
535         uint256 value = approveMax ? type(uint256).max : liquidity;
536         IUniswapV2Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
537         amountETH = removeLiquidityETHSupportingFeeOnTransferTokens(token, liquidity, amountTokenMin, amountETHMin, to, deadline);
538     }
539 
540     /* -------------------------------------------------------------------------- */
541     /*                                 SWAP LOGIC                                 */
542     /* -------------------------------------------------------------------------- */
543 
544     // requires the initial amount to have already been sent to the first pair
545     function _swap(
546         uint256[] memory amounts, 
547         address[] memory path, 
548         address _to
549     ) internal virtual {
550         // unchecked orginally 
551         unchecked {
552             uint256 pathLength = path.length;
553             address _implementation = implementation;
554             for (uint256 i; i < pathLength - 1; ++i) {
555                 (address input, address output) = (path[i], path[i + 1]);
556                 (address token0,) = GemswapLibrary.sortTokens(input, output);
557                 uint256 amountOut = amounts[i + 1];
558                 (uint256 amount0Out, uint256 amount1Out) = input == token0 ? (uint256(0), amountOut) : (amountOut, uint256(0));
559                 address to = i < path.length - 2 ? GemswapLibrary.pairFor(factory, _implementation, output, path[i + 2]) : _to;
560                 IUniswapV2Pair(GemswapLibrary.pairFor(factory, _implementation, input, output)).swap(
561                     amount0Out, 
562                     amount1Out, 
563                     to, 
564                     new bytes(0)
565                 );
566             }
567         }
568     }
569 
570     function swapExactTokensForTokens(
571         uint256 amountIn,
572         uint256 amountOutMin,
573         address[] calldata path,
574         address to,
575         uint256 deadline
576     ) public ensure(deadline) returns (uint256[] memory amounts) {
577         unchecked {
578             address _implementation = implementation;
579             amounts = GemswapLibrary.getAmountsOut(factory, _implementation, amountIn, path);
580             require(amounts[amounts.length - 1] >= amountOutMin, "INSUFFICIENT_OUTPUT_AMOUNT");
581             TransferHelper.safeTransferFrom(
582                 path[0], 
583                 msg.sender, 
584                 GemswapLibrary.pairFor(factory, _implementation, path[0], path[1]), amounts[0]
585             );
586             _swap(amounts, path, to);
587         }
588     }
589 
590     function swapTokensForExactTokens(
591         uint256 amountOut,
592         uint256 amountInMax,
593         address[] calldata path,
594         address to,
595         uint256 deadline
596     ) public ensure(deadline) returns (uint256[] memory amounts) {
597         address _implementation = implementation;
598         amounts = GemswapLibrary.getAmountsIn(factory, implementation, amountOut, path);
599         require(amounts[0] <= amountInMax, "EXCESSIVE_INPUT_AMOUNT");
600         TransferHelper.safeTransferFrom(
601             path[0], 
602             msg.sender, 
603             GemswapLibrary.pairFor(factory, _implementation, path[0], path[1]), 
604             amounts[0]
605         );
606         _swap(amounts, path, to);
607     }
608 
609     function swapExactETHForTokens(
610         uint256 amountOutMin, 
611         address[] calldata path, 
612         address to, 
613         uint256 deadline
614     ) external payable ensure(deadline) returns (uint256[] memory amounts) {
615         require(path[0] == WETH, "INVALID_PATH");
616         address _implementation = implementation;
617         amounts = GemswapLibrary.getAmountsOut(factory, _implementation, msg.value, path);
618         require(amounts[amounts.length - 1] >= amountOutMin, "INSUFFICIENT_OUTPUT_AMOUNT");
619         IWETH(WETH).deposit{value: amounts[0]}();
620         assert(IWETH(WETH).transfer(GemswapLibrary.pairFor(factory, _implementation, path[0], path[1]), amounts[0]));
621         _swap(amounts, path, to);
622     }
623 
624     function swapTokensForExactETH(    
625         uint256 amountOut, 
626         uint256 amountInMax, 
627         address[] calldata path, 
628         address to, 
629         uint256 deadline
630     ) public ensure(deadline) returns (uint256[] memory amounts) {
631         require(path[path.length - 1] == WETH, "INVALID_PATH");
632         address _implementation = implementation;
633         amounts = GemswapLibrary.getAmountsIn(factory, _implementation, amountOut, path);
634         require(amounts[0] <= amountInMax, "EXCESSIVE_INPUT_AMOUNT");
635         TransferHelper.safeTransferFrom(path[0], msg.sender, GemswapLibrary.pairFor(
636             factory, 
637             _implementation, 
638             path[0], 
639             path[1]), 
640             amounts[0]
641         );
642         _swap(amounts, path, address(this));
643         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
644         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
645     }
646 
647     function swapExactTokensForETH(
648         uint256 amountIn, 
649         uint256 amountOutMin, 
650         address[] calldata path, 
651         address to, 
652         uint256 deadline
653     ) public ensure(deadline) returns (uint256[] memory amounts) {
654         require(path[path.length - 1] == WETH, "INVALID_PATH");
655         address _implementation = implementation;
656         amounts = GemswapLibrary.getAmountsOut(factory, _implementation, amountIn, path);
657         require(amounts[amounts.length - 1] >= amountOutMin, "INSUFFICIENT_OUTPUT_AMOUNT");
658         TransferHelper.safeTransferFrom(
659             path[0], 
660             msg.sender, 
661             GemswapLibrary.pairFor(factory, _implementation, path[0], path[1]), 
662             amounts[0]
663         );
664         _swap(amounts, path, address(this));
665         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
666         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
667     }
668 
669     function swapETHForExactTokens(
670         uint256 amountOut, 
671         address[] calldata path, 
672         address to, 
673         uint256 deadline
674     ) external payable ensure(deadline) returns (uint256[] memory amounts) {
675         require(path[0] == WETH, "INVALID_PATH");
676         address _implementation = implementation;
677         amounts = GemswapLibrary.getAmountsIn(factory, _implementation, amountOut, path);
678         require(amounts[0] <= msg.value, "EXCESSIVE_INPUT_AMOUNT");
679         IWETH(WETH).deposit{value: amounts[0]}();
680         assert(IWETH(WETH).transfer(GemswapLibrary.pairFor(factory, _implementation, path[0], path[1]), amounts[0]));
681         _swap(amounts, path, to);
682         // refund dust eth, if any
683         if (msg.value > amounts[0]) TransferHelper.safeTransferETH(msg.sender, msg.value - amounts[0]);
684     }
685 
686     /* -------------------------------------------------------------------------- */
687     /*                              PERMIT SWAP LOGIC                             */
688     /* -------------------------------------------------------------------------- */
689 
690     function swapExactTokensForTokensUsingPermit(
691         uint256 amountIn,
692         uint256 amountOutMin,
693         address[] calldata path,
694         address to,
695         uint256 deadline, uint8 v, bytes32 r, bytes32 s
696     ) external returns (uint256[] memory amounts) {
697         IERC20Permit(path[0]).permit(msg.sender, address(this), amountIn, deadline, v, r, s);
698         amounts = swapExactTokensForTokens(amountIn, amountOutMin, path, to, deadline);
699     }
700 
701     function swapExactTokensForTokensUsingPermitAllowed(
702         uint256 amountIn,
703         uint256 amountOutMin,
704         address[] calldata path,
705         address to,
706         uint256 deadline, uint256 nonce, uint8 v, bytes32 r, bytes32 s
707     ) external returns (uint256[] memory amounts) {
708         IERC20PermitAllowed(path[0]).permit(msg.sender, address(this), nonce, deadline, true, v, r, s);
709         amounts = swapExactTokensForTokens(amountIn, amountOutMin, path, to, deadline);
710     }
711 
712     function swapTokensForExactTokensUsingPermit(
713         uint256 amountOut,
714         uint256 amountInMax,
715         address[] calldata path,
716         address to,
717         uint256 deadline, uint8 v, bytes32 r, bytes32 s
718     ) external returns (uint256[] memory amounts) {
719         IERC20Permit(path[0]).permit(msg.sender, address(this), amountInMax, deadline, v, r, s);
720         amounts = swapTokensForExactTokens(amountOut, amountInMax, path, to, deadline);
721     }
722 
723     function swapTokensForExactTokensUsingPermitAllowed(
724         uint256 amountOut,
725         uint256 amountInMax,
726         address[] calldata path,
727         address to,
728         uint256 deadline, uint256 nonce, uint8 v, bytes32 r, bytes32 s
729     ) external returns (uint256[] memory amounts) {
730         IERC20PermitAllowed(path[0]).permit(msg.sender, address(this), nonce, deadline, true, v, r, s);
731         amounts = swapTokensForExactTokens(amountOut, amountInMax, path, to, deadline);
732     }
733 
734     function swapTokensForExactETHUsingPermit(    
735         uint256 amountOut, 
736         uint256 amountInMax, 
737         address[] calldata path, 
738         address to, 
739         uint256 deadline, uint8 v, bytes32 r, bytes32 s
740     ) external returns (uint256[] memory amounts) {
741         IERC20Permit(path[0]).permit(msg.sender, address(this), amountInMax, deadline, v, r, s);
742         amounts = swapTokensForExactETH(amountOut, amountInMax, path, to, deadline);
743     }
744 
745     function swapTokensForExactETHUsingPermitAllowed(    
746         uint256 amountOut, 
747         uint256 amountInMax, 
748         address[] calldata path, 
749         address to, 
750         uint256 deadline, uint256 nonce, uint8 v, bytes32 r, bytes32 s
751     ) external returns (uint256[] memory amounts) {
752         IERC20PermitAllowed(path[0]).permit(msg.sender, address(this), nonce, deadline, true, v, r, s);
753         amounts = swapTokensForExactETH(amountOut, amountInMax, path, to, deadline);
754     }
755 
756     function swapExactTokensForETHUsingPermit(
757         uint256 amountIn, 
758         uint256 amountOutMin, 
759         address[] calldata path, 
760         address to, 
761         uint256 deadline, uint8 v, bytes32 r, bytes32 s
762     ) external returns (uint256[] memory amounts) {
763         IERC20Permit(path[0]).permit(msg.sender, address(this), amountIn, deadline, v, r, s);
764         amounts = swapExactTokensForETH(amountIn, amountOutMin, path, to, deadline);
765     }
766 
767     function swapExactTokensForETHUsingPermitAllowed(
768         uint256 amountIn, 
769         uint256 amountOutMin, 
770         address[] calldata path, 
771         address to, 
772         uint256 deadline, uint256 nonce, uint8 v, bytes32 r, bytes32 s
773     ) external returns (uint256[] memory amounts) {
774         IERC20PermitAllowed(path[0]).permit(msg.sender, address(this), nonce, deadline, true, v, r, s);
775         amounts = swapExactTokensForETH(amountIn, amountOutMin, path, to, deadline);
776     }
777 
778     /* -------------------------------------------------------------------------- */
779     /*               SWAP (supporting fee-on-transfer tokens) LOGIC               */
780     /* -------------------------------------------------------------------------- */
781     // requires the initial amount to have already been sent to the first pair
782     function _swapSupportingFeeOnTransferTokens(
783         address[] memory path, 
784         address _to
785     ) internal virtual {
786         address _implementation = implementation;
787         // uint256 pathLength = path.length; // removed to avoid stack too deep :(
788 
789         for (uint256 i; i < path.length - 1; ++i) {
790             
791             (address input, address output) = (path[i], path[i + 1]);
792             (address token0,) = GemswapLibrary.sortTokens(input, output);
793             IUniswapV2Pair pair = IUniswapV2Pair(GemswapLibrary.pairFor(factory, _implementation, input, output));
794 
795             uint256 amountOutput;
796             
797             { // scope to avoid stack too deep errors
798                 (uint256 reserve0, uint256 reserve1,) = pair.getReserves();
799                 (uint256 reserveInput, uint256 reserveOutput) = input == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
800                 amountOutput = GemswapLibrary.getAmountOut(
801                     IERC20(input).balanceOf(address(pair)) - reserveInput, 
802                     reserveInput, 
803                     reserveOutput
804                 );
805             }
806             (uint256 amount0Out, uint256 amount1Out) = input == token0 ? (uint256(0), amountOutput) : (amountOutput, uint256(0));
807             address to = i < path.length - 2 ? GemswapLibrary.pairFor(factory, _implementation, output, path[i + 2]) : _to;
808             pair.swap(amount0Out, amount1Out, to, new bytes(0));
809         }
810     }
811 
812     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
813         uint256 amountIn,
814         uint256 amountOutMin,
815         address[] calldata path,
816         address to,
817         uint256 deadline
818     ) external ensure(deadline) {
819         TransferHelper.safeTransferFrom(path[0], msg.sender, GemswapLibrary.pairFor(factory, implementation,path[0], path[1]), amountIn);
820         uint256 balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
821         _swapSupportingFeeOnTransferTokens(path, to);
822         require(IERC20(path[path.length - 1]).balanceOf(to) - (balanceBefore) >= amountOutMin, "INSUFFICIENT_OUTPUT_AMOUNT");
823     }
824 
825     function swapExactETHForTokensSupportingFeeOnTransferTokens(
826         uint256 amountOutMin,
827         address[] calldata path,
828         address to,
829         uint256 deadline
830     ) external payable ensure(deadline) {
831         require(path[0] == WETH, "INVALID_PATH");
832         uint256 amountIn = msg.value;
833         IWETH(WETH).deposit{value: amountIn}();
834         assert(IWETH(WETH).transfer(GemswapLibrary.pairFor(factory, implementation, path[0], path[1]), amountIn));
835         uint256 balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
836         _swapSupportingFeeOnTransferTokens(path, to);
837         require(IERC20(path[path.length - 1]).balanceOf(to) - (balanceBefore) >= amountOutMin, "INSUFFICIENT_OUTPUT_AMOUNT");
838     }
839 
840     function swapExactTokensForETHSupportingFeeOnTransferTokens(
841         uint256 amountIn,
842         uint256 amountOutMin,
843         address[] calldata path,
844         address to,
845         uint256 deadline
846     ) external ensure(deadline) {
847         require(path[path.length - 1] == WETH, "INVALID_PATH");
848         TransferHelper.safeTransferFrom(
849             path[0], 
850             msg.sender, 
851             GemswapLibrary.pairFor(factory, implementation, path[0], path[1]), 
852             amountIn
853         );
854         _swapSupportingFeeOnTransferTokens(path, address(this));
855         uint256 amountOut = IERC20(WETH).balanceOf(address(this));
856         require(amountOut >= amountOutMin, "INSUFFICIENT_OUTPUT_AMOUNT");
857         IWETH(WETH).withdraw(amountOut);
858         TransferHelper.safeTransferETH(to, amountOut);
859     }
860 
861     /* -------------------------------------------------------------------------- */
862     /*                              LIBRARY FUNCTIONS                             */
863     /* -------------------------------------------------------------------------- */
864 
865     function quote(uint256 amountA, uint256 reserveA, uint256 reserveB) public pure returns (uint256 amountB) {
866         return GemswapLibrary.quote(amountA, reserveA, reserveB);
867     }
868 
869     function getAmountOut(uint256 amountIn, uint256 reserveIn, uint256 reserveOut) public pure returns (uint256 amountOut) {
870         return GemswapLibrary.getAmountOut(amountIn, reserveIn, reserveOut);
871     }
872 
873     function getAmountIn(uint256 amountOut, uint256 reserveIn, uint256 reserveOut) public pure returns (uint256 amountIn) {
874         return GemswapLibrary.getAmountIn(amountOut, reserveIn, reserveOut);
875     }
876 
877     function getAmountsOut(uint256 amountIn, address[] memory path) public view returns (uint256[] memory amounts) {
878         return GemswapLibrary.getAmountsOut(factory, implementation, amountIn, path);
879     }
880 
881     function getAmountsIn(uint256 amountOut, address[] memory path) public view returns (uint256[] memory amounts) {
882         return GemswapLibrary.getAmountsIn(factory, implementation, amountOut, path);
883     }
884 }