1 pragma solidity =0.6.6;
2 
3 //import '@swapx/v1-core/contracts/interfaces/ISwapXV1Factory.sol';
4 
5 interface ISwapXV1Factory {
6     event PairCreated(address indexed token0, address indexed token1, address pair, address pToken, uint);
7 
8     function feeTo() external view returns (address);
9 
10     function setter() external view returns (address);
11 
12     function miner() external view returns (address);
13 
14     function token2Pair(address token) external view returns (address pair);
15 
16     function pair2Token(address pair) external view returns (address pToken);
17 
18     function getPair(address tokenA, address tokenB) external view returns (address pair);
19 
20     function allPairs(uint) external view returns (address pair);
21 
22     function pairTokens(uint) external view returns (address pair);
23 
24     function allPairsLength() external view returns (uint);
25 
26     function createPair(address tokenA, address tokenB) external returns (address pair, address pToken);
27 
28     function setFeeTo(address) external;
29 
30     function setSetter(address) external;
31 
32     function setMiner(address) external;
33 
34 }
35 
36 //import '@swapx/lib/contracts/libraries/TransferHelper.sol';
37 
38 // helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
39 library TransferHelper {
40     function safeApprove(address token, address to, uint value) internal {
41         // bytes4(keccak256(bytes('approve(address,uint256)')));
42         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
43         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
44     }
45 
46     function safeTransfer(address token, address to, uint value) internal {
47         // bytes4(keccak256(bytes('transfer(address,uint256)')));
48         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
49         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
50     }
51 
52     function safeTransferFrom(address token, address from, address to, uint value) internal {
53         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
54         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
55         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
56     }
57 
58     function safeTransferETH(address to, uint value) internal {
59         (bool success,) = to.call{value:value}(new bytes(0));
60         require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
61     }
62 }
63 
64 //import '@swapx/lib/contracts/libraries/PairNamer.sol';
65 
66 //import './SafeERC20Namer.sol';
67 
68 //import './AddressStringUtil.sol';
69 
70 library AddressStringUtil {
71     // converts an address to the uppercase hex string, extracting only len bytes (up to 20, multiple of 2)
72     function toAsciiString(address addr, uint len) pure internal returns (string memory) {
73         require(len % 2 == 0 && len > 0 && len <= 40, "AddressStringUtil: INVALID_LEN");
74 
75         bytes memory s = new bytes(len);
76         uint addrNum = uint(addr);
77         for (uint i = 0; i < len / 2; i++) {
78             // shift right and truncate all but the least significant byte to extract the byte at position 19-i
79             uint8 b = uint8(addrNum >> (8 * (19 - i)));
80             // first hex character is the most significant 4 bits
81             uint8 hi = b >> 4;
82             // second hex character is the least significant 4 bits
83             uint8 lo = b - (hi << 4);
84             s[2 * i] = char(hi);
85             s[2 * i + 1] = char(lo);
86         }
87         return string(s);
88     }
89 
90     // hi and lo are only 4 bits and between 0 and 16
91     // this method converts those values to the unicode/ascii code point for the hex representation
92     // uses upper case for the characters
93     function char(uint8 b) pure private returns (byte c) {
94         if (b < 10) {
95             return byte(b + 0x30);
96         } else {
97             return byte(b + 0x37);
98         }
99     }
100 }
101 
102 
103 // produces token descriptors from inconsistent or absent ERC20 symbol implementations that can return string or bytes32
104 // this library will always produce a string symbol to represent the token
105 library SafeERC20Namer {
106     function bytes32ToString(bytes32 x) pure private returns (string memory) {
107         bytes memory bytesString = new bytes(32);
108         uint charCount = 0;
109         for (uint j = 0; j < 32; j++) {
110             byte char = x[j];
111             if (char != 0) {
112                 bytesString[charCount] = char;
113                 charCount++;
114             }
115         }
116         bytes memory bytesStringTrimmed = new bytes(charCount);
117         for (uint j = 0; j < charCount; j++) {
118             bytesStringTrimmed[j] = bytesString[j];
119         }
120         return string(bytesStringTrimmed);
121     }
122 
123     // assumes the data is in position 2
124     function parseStringData(bytes memory b) pure private returns (string memory) {
125         uint charCount = 0;
126         // first parse the charCount out of the data
127         for (uint i = 32; i < 64; i++) {
128             charCount <<= 8;
129             charCount += uint8(b[i]);
130         }
131 
132         bytes memory bytesStringTrimmed = new bytes(charCount);
133         for (uint i = 0; i < charCount; i++) {
134             bytesStringTrimmed[i] = b[i + 64];
135         }
136 
137         return string(bytesStringTrimmed);
138     }
139 
140     // uses a heuristic to produce a token name from the address
141     // the heuristic returns the full hex of the address string in upper case
142     function addressToName(address token) pure private returns (string memory) {
143         return AddressStringUtil.toAsciiString(token, 40);
144     }
145 
146     // uses a heuristic to produce a token symbol from the address
147     // the heuristic returns the first 6 hex of the address string in upper case
148     function addressToSymbol(address token) pure private returns (string memory) {
149         return AddressStringUtil.toAsciiString(token, 6);
150     }
151 
152     // calls an external view token contract method that returns a symbol or name, and parses the output into a string
153     function callAndParseStringReturn(address token, bytes4 selector) view private returns (string memory) {
154         (bool success, bytes memory data) = token.staticcall(abi.encodeWithSelector(selector));
155         // if not implemented, or returns empty data, return empty string
156         if (!success || data.length == 0) {
157             return "";
158         }
159         // bytes32 data always has length 32
160         if (data.length == 32) {
161             bytes32 decoded = abi.decode(data, (bytes32));
162             return bytes32ToString(decoded);
163         } else if (data.length > 64) {
164             return abi.decode(data, (string));
165         }
166         return "";
167     }
168 
169     // attempts to extract the token symbol. if it does not implement symbol, returns a symbol derived from the address
170     function tokenSymbol(address token) internal view returns (string memory) {
171         // 0x95d89b41 = bytes4(keccak256("symbol()"))
172         string memory symbol = callAndParseStringReturn(token, 0x95d89b41);
173         if (bytes(symbol).length == 0) {
174             // fallback to 6 uppercase hex of address
175             return addressToSymbol(token);
176         }
177         return symbol;
178     }
179 
180     // attempts to extract the token name. if it does not implement name, returns a name derived from the address
181     function tokenName(address token) internal view returns (string memory) {
182         // 0x06fdde03 = bytes4(keccak256("name()"))
183         string memory name = callAndParseStringReturn(token, 0x06fdde03);
184         if (bytes(name).length == 0) {
185             // fallback to full hex of address
186             return addressToName(token);
187         }
188         return name;
189     }
190 }
191 
192 
193 // produces names for pairs of tokens
194 library PairNamer {
195     string private constant TOKEN_SYMBOL_PREFIX = '🔀';
196     string private constant TOKEN_SEPARATOR = ':';
197 
198     // produces a pair descriptor in the format of `${prefix}${name0}:${name1}${suffix}`
199     function pairName(address token0, address token1, string memory prefix, string memory suffix) internal view returns (string memory) {
200         return string(
201             abi.encodePacked(
202                 prefix,
203                 SafeERC20Namer.tokenName(token0),
204                 TOKEN_SEPARATOR,
205                 SafeERC20Namer.tokenName(token1),
206                 suffix
207             )
208         );
209     }
210 
211     // produces a pair symbol in the format of `🔀${symbol0}:${symbol1}${suffix}`
212     function pairSymbol(address token0, address token1, string memory suffix) internal view returns (string memory) {
213         return string(
214             abi.encodePacked(
215                 TOKEN_SYMBOL_PREFIX,
216                 SafeERC20Namer.tokenSymbol(token0),
217                 TOKEN_SEPARATOR,
218                 SafeERC20Namer.tokenSymbol(token1),
219                 suffix
220             )
221         );
222     }
223 
224     // produces a pair symbol in the format of `🔀${symbol0}:${symbol1}${suffix}`
225     function pairPtSymbol(address token0, address token1, string memory suffix) internal view returns (string memory) {
226         return string(
227             abi.encodePacked(
228                 SafeERC20Namer.tokenSymbol(token0),
229                 SafeERC20Namer.tokenSymbol(token1),
230                 suffix
231             )
232         );
233     }
234 }
235 
236 //import './interfaces/IERC20.sol';
237 
238 interface IERC20 {
239     event Approval(address indexed owner, address indexed spender, uint value);
240     event Transfer(address indexed from, address indexed to, uint value);
241 
242     function name() external view returns (string memory);
243     function symbol() external view returns (string memory);
244     function decimals() external view returns (uint8);
245     function totalSupply() external view returns (uint);
246     function balanceOf(address owner) external view returns (uint);
247     function allowance(address owner, address spender) external view returns (uint);
248 
249     function approve(address spender, uint value) external returns (bool);
250     function transfer(address to, uint value) external returns (bool);
251     function transferFrom(address from, address to, uint value) external returns (bool);
252 }
253 
254 
255 //import './interfaces/ISwapXV1Router02.sol';
256 
257 //import './ISwapXV1Router01.sol';
258 
259 interface ISwapXV1Router01 {
260     function factory() external pure returns (address);
261     function WETH() external pure returns (address);
262 
263     function addLiquidity(
264         address tokenA,
265         address tokenB,
266         uint amountADesired,
267         uint amountBDesired,
268         uint amountAMin,
269         uint amountBMin,
270         address to,
271         uint deadline
272     ) external returns (uint amountA, uint amountB, uint liquidity);
273     function addLiquidityETH(
274         address token,
275         uint amountTokenDesired,
276         uint amountTokenMin,
277         uint amountETHMin,
278         address to,
279         uint deadline
280     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
281     function removeLiquidity(
282         address tokenA,
283         address tokenB,
284         uint liquidity,
285         uint amountAMin,
286         uint amountBMin,
287         address to,
288         uint deadline
289     ) external returns (uint amountA, uint amountB);
290     function removeLiquidityETH(
291         address token,
292         uint liquidity,
293         uint amountTokenMin,
294         uint amountETHMin,
295         address to,
296         uint deadline
297     ) external returns (uint amountToken, uint amountETH);
298     function removeLiquidityWithPermit(
299         address tokenA,
300         address tokenB,
301         uint liquidity,
302         uint amountAMin,
303         uint amountBMin,
304         address to,
305         uint deadline,
306         bool approveMax, uint8 v, bytes32 r, bytes32 s
307     ) external returns (uint amountA, uint amountB);
308     function removeLiquidityETHWithPermit(
309         address token,
310         uint liquidity,
311         uint amountTokenMin,
312         uint amountETHMin,
313         address to,
314         uint deadline,
315         bool approveMax, uint8 v, bytes32 r, bytes32 s
316     ) external returns (uint amountToken, uint amountETH);
317     function swapExactTokensForTokens(
318         uint amountIn,
319         uint amountOutMin,
320         address[] calldata path,
321         address to,
322         uint deadline
323     ) external returns (uint[] memory amounts);
324     function swapTokensForExactTokens(
325         uint amountOut,
326         uint amountInMax,
327         address[] calldata path,
328         address to,
329         uint deadline
330     ) external returns (uint[] memory amounts);
331     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
332         external
333         payable
334         returns (uint[] memory amounts);
335     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
336         external
337         returns (uint[] memory amounts);
338     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
339         external
340         returns (uint[] memory amounts);
341     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
342         external
343         payable
344         returns (uint[] memory amounts);
345 
346     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
347     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
348     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
349     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
350     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
351 }
352 
353 
354 interface ISwapXV1Router02 is ISwapXV1Router01 {
355     function removeLiquidityETHSupportingFeeOnTransferTokens(
356         address token,
357         uint liquidity,
358         uint amountTokenMin,
359         uint amountETHMin,
360         address to,
361         uint deadline
362     ) external returns (uint amountETH);
363     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
364         address token,
365         uint liquidity,
366         uint amountTokenMin,
367         uint amountETHMin,
368         address to,
369         uint deadline,
370         bool approveMax, uint8 v, bytes32 r, bytes32 s
371     ) external returns (uint amountETH);
372 
373     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
374         uint amountIn,
375         uint amountOutMin,
376         address[] calldata path,
377         address to,
378         uint deadline
379     ) external;
380     function swapExactETHForTokensSupportingFeeOnTransferTokens(
381         uint amountOutMin,
382         address[] calldata path,
383         address to,
384         uint deadline
385     ) external payable;
386     function swapExactTokensForETHSupportingFeeOnTransferTokens(
387         uint amountIn,
388         uint amountOutMin,
389         address[] calldata path,
390         address to,
391         uint deadline
392     ) external;
393 }
394 
395 //import './libraries/SwapXV1Library.sol';
396 
397 // import '@swapx/v1-core/contracts/interfaces/ISwapXV1Pair.sol';
398 
399 interface ISwapXV1Pair {
400     event Approval(address indexed owner, address indexed spender, uint value);
401     event Transfer(address indexed from, address indexed to, uint value);
402 
403     function name() external pure returns (string memory);
404     function symbol() external pure returns (string memory);
405     function decimals() external pure returns (uint8);
406     function totalSupply() external view returns (uint);
407     function balanceOf(address owner) external view returns (uint);
408     function allowance(address owner, address spender) external view returns (uint);
409 
410     function approve(address spender, uint value) external returns (bool);
411     function transfer(address to, uint value) external returns (bool);
412     function transferFrom(address from, address to, uint value) external returns (bool);
413 
414     function DOMAIN_SEPARATOR() external view returns (bytes32);
415     function PERMIT_TYPEHASH() external pure returns (bytes32);
416     function nonces(address owner) external view returns (uint);
417 
418     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
419 
420     event Mint(address indexed sender, uint amount0, uint amount1);
421     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
422     event Swap(
423         address indexed sender,
424         uint amount0In,
425         uint amount1In,
426         uint amount0Out,
427         uint amount1Out,
428         address indexed to
429     );
430     event Sync(uint112 reserve0, uint112 reserve1);
431 
432     function MINIMUM_LIQUIDITY() external pure returns (uint);
433     function factory() external view returns (address);
434     function token0() external view returns (address);
435     function token1() external view returns (address);
436     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
437     function price0CumulativeLast() external view returns (uint);
438     function price1CumulativeLast() external view returns (uint);
439     function kLast() external view returns (uint);
440 
441     function mint(address to) external returns (uint liquidity);
442     function burn(address to) external returns (uint amount0, uint amount1);
443     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
444     function skim(address to) external;
445     function sync() external;
446 
447     function initialize(address, address) external;
448 }
449 
450 
451 // import "@swapx/v1-core/contracts/interfaces/ISwapXV1Factory.sol";
452 
453 
454 //import "./SafeMath.sol";
455 
456 // a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)
457 
458 library SafeMath {
459     function add(uint x, uint y) internal pure returns (uint z) {
460         require((z = x + y) >= x, 'ds-math-add-overflow');
461     }
462 
463     function sub(uint x, uint y) internal pure returns (uint z) {
464         require((z = x - y) <= x, 'ds-math-sub-underflow');
465     }
466 
467     function mul(uint x, uint y) internal pure returns (uint z) {
468         require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');
469     }
470 }
471 
472 library SwapXV1Library {
473     using SafeMath for uint;
474 
475     // returns sorted token addresses, used to handle return values from pairs sorted in this order
476     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
477         require(tokenA != tokenB, 'SwapXV1Library: IDENTICAL_ADDRESSES');
478         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
479         require(token0 != address(0), 'SwapXV1Library: ZERO_ADDRESS');
480     }
481 
482     // calculates the CREATE2 address for a pair without making any external calls
483     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
484         (address token0, address token1) = sortTokens(tokenA, tokenB);
485         pair = address(uint(keccak256(abi.encodePacked(
486                 hex'ff',
487                 factory,
488                 keccak256(abi.encodePacked(token0, token1)),
489                 hex'8a838d3f197b37a44c61957f48e39c7c4102bc1c5496802ad8473865bb6eb733' // init code hash
490             ))));
491     }
492 
493     // fetches and sorts the reserves for a pair
494     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
495         (address token0,) = sortTokens(tokenA, tokenB);
496         (uint reserve0, uint reserve1,) = ISwapXV1Pair(pairFor(factory, tokenA, tokenB)).getReserves();
497         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
498     }
499 
500     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
501     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
502         require(amountA > 0, 'SwapXV1Library: INSUFFICIENT_AMOUNT');
503         require(reserveA > 0 && reserveB > 0, 'SwapXV1Library: INSUFFICIENT_LIQUIDITY');
504         amountB = amountA.mul(reserveB) / reserveA;
505     }
506 
507     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
508     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
509         require(amountIn > 0, 'SwapXV1Library: INSUFFICIENT_INPUT_AMOUNT');
510         require(reserveIn > 0 && reserveOut > 0, 'SwapXV1Library: INSUFFICIENT_LIQUIDITY');
511         uint amountInWithFee = amountIn.mul(997);
512         uint numerator = amountInWithFee.mul(reserveOut);
513         uint denominator = reserveIn.mul(1000).add(amountInWithFee);
514         amountOut = numerator / denominator;
515     }
516 
517     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
518     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {
519         require(amountOut > 0, 'SwapXV1Library: INSUFFICIENT_OUTPUT_AMOUNT');
520         require(reserveIn > 0 && reserveOut > 0, 'SwapXV1Library: INSUFFICIENT_LIQUIDITY');
521         uint numerator = reserveIn.mul(amountOut).mul(1000);
522         uint denominator = reserveOut.sub(amountOut).mul(997);
523         amountIn = (numerator / denominator).add(1);
524     }
525 
526     // performs chained getAmountOut calculations on any number of pairs
527     function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {
528         require(path.length >= 2, 'SwapXV1Library: INVALID_PATH');
529         amounts = new uint[](path.length);
530         amounts[0] = amountIn;
531         for (uint i; i < path.length - 1; i++) {
532             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);
533             amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
534         }
535     }
536 
537     // performs chained getAmountIn calculations on any number of pairs
538     function getAmountsIn(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {
539         require(path.length >= 2, 'SwapXV1Library: INVALID_PATH');
540         amounts = new uint[](path.length);
541         amounts[amounts.length - 1] = amountOut;
542         for (uint i = path.length - 1; i > 0; i--) {
543             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);
544             amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
545         }
546     }
547 }
548 
549 
550 //import './interfaces/IWETH.sol';
551 
552 interface IWETH {
553     function deposit() external payable;
554     function transfer(address to, uint value) external returns (bool);
555     function withdraw(uint) external;
556 }
557 
558 contract SwapXV1Router02 is ISwapXV1Router02 {
559     using SafeMath for uint;
560 
561     address public immutable override factory;
562     address public immutable override WETH;
563 
564     modifier ensure(uint deadline) {
565         require(deadline >= block.timestamp, 'SwapXV1Router: EXPIRED');
566         _;
567     }
568 
569     constructor(address _factory, address _WETH) public {
570         factory = _factory;
571         WETH = _WETH;
572     }
573 
574     receive() external payable {
575         assert(msg.sender == WETH); // only accept ETH via fallback from the WETH contract
576     }
577 
578     // **** ADD LIQUIDITY ****
579     function _addLiquidity(
580         address tokenA,
581         address tokenB,
582         uint amountADesired,
583         uint amountBDesired,
584         uint amountAMin,
585         uint amountBMin
586     ) internal virtual returns (uint amountA, uint amountB) {
587         // create the pair if it doesn't exist yet
588         if (ISwapXV1Factory(factory).getPair(tokenA, tokenB) == address(0)) {
589             ISwapXV1Factory(factory).createPair(tokenA, tokenB);
590         }
591         (uint reserveA, uint reserveB) = SwapXV1Library.getReserves(factory, tokenA, tokenB);
592         if (reserveA == 0 && reserveB == 0) {
593             (amountA, amountB) = (amountADesired, amountBDesired);
594         } else {
595             uint amountBOptimal = SwapXV1Library.quote(amountADesired, reserveA, reserveB);
596             if (amountBOptimal <= amountBDesired) {
597                 require(amountBOptimal >= amountBMin, 'SwapXV1Router: INSUFFICIENT_B_AMOUNT');
598                 (amountA, amountB) = (amountADesired, amountBOptimal);
599             } else {
600                 uint amountAOptimal = SwapXV1Library.quote(amountBDesired, reserveB, reserveA);
601                 assert(amountAOptimal <= amountADesired);
602                 require(amountAOptimal >= amountAMin, 'SwapXV1Router: INSUFFICIENT_A_AMOUNT');
603                 (amountA, amountB) = (amountAOptimal, amountBDesired);
604             }
605         }
606     }
607     function addLiquidity(
608         address tokenA,
609         address tokenB,
610         uint amountADesired,
611         uint amountBDesired,
612         uint amountAMin,
613         uint amountBMin,
614         address to,
615         uint deadline
616     ) external virtual override ensure(deadline) returns (uint amountA, uint amountB, uint liquidity) {
617         (amountA, amountB) = _addLiquidity(tokenA, tokenB, amountADesired, amountBDesired, amountAMin, amountBMin);
618         address pair = SwapXV1Library.pairFor(factory, tokenA, tokenB);
619         TransferHelper.safeTransferFrom(tokenA, msg.sender, pair, amountA);
620         TransferHelper.safeTransferFrom(tokenB, msg.sender, pair, amountB);
621         liquidity = ISwapXV1Pair(pair).mint(to);
622     }
623     function addLiquidityETH(
624         address token,
625         uint amountTokenDesired,
626         uint amountTokenMin,
627         uint amountETHMin,
628         address to,
629         uint deadline
630     ) external virtual override payable ensure(deadline) returns (uint amountToken, uint amountETH, uint liquidity) {
631         (amountToken, amountETH) = _addLiquidity(
632             token,
633             WETH,
634             amountTokenDesired,
635             msg.value,
636             amountTokenMin,
637             amountETHMin
638         );
639         address pair = SwapXV1Library.pairFor(factory, token, WETH);
640         TransferHelper.safeTransferFrom(token, msg.sender, pair, amountToken);
641         IWETH(WETH).deposit{value: amountETH}();
642         assert(IWETH(WETH).transfer(pair, amountETH));
643         liquidity = ISwapXV1Pair(pair).mint(to);
644         // refund dust eth, if any
645         if (msg.value > amountETH) TransferHelper.safeTransferETH(msg.sender, msg.value - amountETH);
646     }
647 
648     // **** REMOVE LIQUIDITY ****
649     function removeLiquidity(
650         address tokenA,
651         address tokenB,
652         uint liquidity,
653         uint amountAMin,
654         uint amountBMin,
655         address to,
656         uint deadline
657     ) public virtual override ensure(deadline) returns (uint amountA, uint amountB) {
658         address pair = SwapXV1Library.pairFor(factory, tokenA, tokenB);
659         ISwapXV1Pair(pair).transferFrom(msg.sender, pair, liquidity); // send liquidity to pair
660         (uint amount0, uint amount1) = ISwapXV1Pair(pair).burn(to);
661         (address token0,) = SwapXV1Library.sortTokens(tokenA, tokenB);
662         (amountA, amountB) = tokenA == token0 ? (amount0, amount1) : (amount1, amount0);
663         require(amountA >= amountAMin, 'SwapXV1Router: INSUFFICIENT_A_AMOUNT');
664         require(amountB >= amountBMin, 'SwapXV1Router: INSUFFICIENT_B_AMOUNT');
665     }
666     function removeLiquidityETH(
667         address token,
668         uint liquidity,
669         uint amountTokenMin,
670         uint amountETHMin,
671         address to,
672         uint deadline
673     ) public virtual override ensure(deadline) returns (uint amountToken, uint amountETH) {
674         (amountToken, amountETH) = removeLiquidity(
675             token,
676             WETH,
677             liquidity,
678             amountTokenMin,
679             amountETHMin,
680             address(this),
681             deadline
682         );
683         TransferHelper.safeTransfer(token, to, amountToken);
684         IWETH(WETH).withdraw(amountETH);
685         TransferHelper.safeTransferETH(to, amountETH);
686     }
687     function removeLiquidityWithPermit(
688         address tokenA,
689         address tokenB,
690         uint liquidity,
691         uint amountAMin,
692         uint amountBMin,
693         address to,
694         uint deadline,
695         bool approveMax, uint8 v, bytes32 r, bytes32 s
696     ) external virtual override returns (uint amountA, uint amountB) {
697         address pair = SwapXV1Library.pairFor(factory, tokenA, tokenB);
698         uint value = approveMax ? uint(-1) : liquidity;
699         ISwapXV1Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
700         (amountA, amountB) = removeLiquidity(tokenA, tokenB, liquidity, amountAMin, amountBMin, to, deadline);
701     }
702     function removeLiquidityETHWithPermit(
703         address token,
704         uint liquidity,
705         uint amountTokenMin,
706         uint amountETHMin,
707         address to,
708         uint deadline,
709         bool approveMax, uint8 v, bytes32 r, bytes32 s
710     ) external virtual override returns (uint amountToken, uint amountETH) {
711         address pair = SwapXV1Library.pairFor(factory, token, WETH);
712         uint value = approveMax ? uint(-1) : liquidity;
713         ISwapXV1Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
714         (amountToken, amountETH) = removeLiquidityETH(token, liquidity, amountTokenMin, amountETHMin, to, deadline);
715     }
716 
717     // **** REMOVE LIQUIDITY (supporting fee-on-transfer tokens) ****
718     function removeLiquidityETHSupportingFeeOnTransferTokens(
719         address token,
720         uint liquidity,
721         uint amountTokenMin,
722         uint amountETHMin,
723         address to,
724         uint deadline
725     ) public virtual override ensure(deadline) returns (uint amountETH) {
726         (, amountETH) = removeLiquidity(
727             token,
728             WETH,
729             liquidity,
730             amountTokenMin,
731             amountETHMin,
732             address(this),
733             deadline
734         );
735         TransferHelper.safeTransfer(token, to, IERC20(token).balanceOf(address(this)));
736         IWETH(WETH).withdraw(amountETH);
737         TransferHelper.safeTransferETH(to, amountETH);
738     }
739     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
740         address token,
741         uint liquidity,
742         uint amountTokenMin,
743         uint amountETHMin,
744         address to,
745         uint deadline,
746         bool approveMax, uint8 v, bytes32 r, bytes32 s
747     ) external virtual override returns (uint amountETH) {
748         address pair = SwapXV1Library.pairFor(factory, token, WETH);
749         uint value = approveMax ? uint(-1) : liquidity;
750         ISwapXV1Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
751         amountETH = removeLiquidityETHSupportingFeeOnTransferTokens(
752             token, liquidity, amountTokenMin, amountETHMin, to, deadline
753         );
754     }
755 
756     // **** SWAP ****
757     // requires the initial amount to have already been sent to the first pair
758     function _swap(uint[] memory amounts, address[] memory path, address _to) internal virtual {
759         for (uint i; i < path.length - 1; i++) {
760             (address input, address output) = (path[i], path[i + 1]);
761             (address token0,) = SwapXV1Library.sortTokens(input, output);
762             uint amountOut = amounts[i + 1];
763             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOut) : (amountOut, uint(0));
764             address to = i < path.length - 2 ? SwapXV1Library.pairFor(factory, output, path[i + 2]) : _to;
765             ISwapXV1Pair(SwapXV1Library.pairFor(factory, input, output)).swap(
766                 amount0Out, amount1Out, to, new bytes(0)
767             );
768         }
769     }
770     function swapExactTokensForTokens(
771         uint amountIn,
772         uint amountOutMin,
773         address[] calldata path,
774         address to,
775         uint deadline
776     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
777         amounts = SwapXV1Library.getAmountsOut(factory, amountIn, path);
778         require(amounts[amounts.length - 1] >= amountOutMin, 'SwapXV1Router: INSUFFICIENT_OUTPUT_AMOUNT');
779         TransferHelper.safeTransferFrom(
780             path[0], msg.sender, SwapXV1Library.pairFor(factory, path[0], path[1]), amounts[0]
781         );
782         _swap(amounts, path, to);
783     }
784     function swapTokensForExactTokens(
785         uint amountOut,
786         uint amountInMax,
787         address[] calldata path,
788         address to,
789         uint deadline
790     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
791         amounts = SwapXV1Library.getAmountsIn(factory, amountOut, path);
792         require(amounts[0] <= amountInMax, 'SwapXV1Router: EXCESSIVE_INPUT_AMOUNT');
793         TransferHelper.safeTransferFrom(
794             path[0], msg.sender, SwapXV1Library.pairFor(factory, path[0], path[1]), amounts[0]
795         );
796         _swap(amounts, path, to);
797     }
798     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
799         external
800         virtual
801         override
802         payable
803         ensure(deadline)
804         returns (uint[] memory amounts)
805     {
806         require(path[0] == WETH, 'SwapXV1Router: INVALID_PATH');
807         amounts = SwapXV1Library.getAmountsOut(factory, msg.value, path);
808         require(amounts[amounts.length - 1] >= amountOutMin, 'SwapXV1Router: INSUFFICIENT_OUTPUT_AMOUNT');
809         IWETH(WETH).deposit{value: amounts[0]}();
810         assert(IWETH(WETH).transfer(SwapXV1Library.pairFor(factory, path[0], path[1]), amounts[0]));
811         _swap(amounts, path, to);
812     }
813     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
814         external
815         virtual
816         override
817         ensure(deadline)
818         returns (uint[] memory amounts)
819     {
820         require(path[path.length - 1] == WETH, 'SwapXV1Router: INVALID_PATH');
821         amounts = SwapXV1Library.getAmountsIn(factory, amountOut, path);
822         require(amounts[0] <= amountInMax, 'SwapXV1Router: EXCESSIVE_INPUT_AMOUNT');
823         TransferHelper.safeTransferFrom(
824             path[0], msg.sender, SwapXV1Library.pairFor(factory, path[0], path[1]), amounts[0]
825         );
826         _swap(amounts, path, address(this));
827         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
828         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
829     }
830     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
831         external
832         virtual
833         override
834         ensure(deadline)
835         returns (uint[] memory amounts)
836     {
837         require(path[path.length - 1] == WETH, 'SwapXV1Router: INVALID_PATH');
838         amounts = SwapXV1Library.getAmountsOut(factory, amountIn, path);
839         require(amounts[amounts.length - 1] >= amountOutMin, 'SwapXV1Router: INSUFFICIENT_OUTPUT_AMOUNT');
840         TransferHelper.safeTransferFrom(
841             path[0], msg.sender, SwapXV1Library.pairFor(factory, path[0], path[1]), amounts[0]
842         );
843         _swap(amounts, path, address(this));
844         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
845         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
846     }
847     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
848         external
849         virtual
850         override
851         payable
852         ensure(deadline)
853         returns (uint[] memory amounts)
854     {
855         require(path[0] == WETH, 'SwapXV1Router: INVALID_PATH');
856         amounts = SwapXV1Library.getAmountsIn(factory, amountOut, path);
857         require(amounts[0] <= msg.value, 'SwapXV1Router: EXCESSIVE_INPUT_AMOUNT');
858         IWETH(WETH).deposit{value: amounts[0]}();
859         assert(IWETH(WETH).transfer(SwapXV1Library.pairFor(factory, path[0], path[1]), amounts[0]));
860         _swap(amounts, path, to);
861         // refund dust eth, if any
862         if (msg.value > amounts[0]) TransferHelper.safeTransferETH(msg.sender, msg.value - amounts[0]);
863     }
864 
865     // **** SWAP (supporting fee-on-transfer tokens) ****
866     // requires the initial amount to have already been sent to the first pair
867     function _swapSupportingFeeOnTransferTokens(address[] memory path, address _to) internal virtual {
868         for (uint i; i < path.length - 1; i++) {
869             (address input, address output) = (path[i], path[i + 1]);
870             (address token0,) = SwapXV1Library.sortTokens(input, output);
871             ISwapXV1Pair pair = ISwapXV1Pair(SwapXV1Library.pairFor(factory, input, output));
872             uint amountInput;
873             uint amountOutput;
874             { // scope to avoid stack too deep errors
875             (uint reserve0, uint reserve1,) = pair.getReserves();
876             (uint reserveInput, uint reserveOutput) = input == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
877             amountInput = IERC20(input).balanceOf(address(pair)).sub(reserveInput);
878             amountOutput = SwapXV1Library.getAmountOut(amountInput, reserveInput, reserveOutput);
879             }
880             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOutput) : (amountOutput, uint(0));
881             address to = i < path.length - 2 ? SwapXV1Library.pairFor(factory, output, path[i + 2]) : _to;
882             pair.swap(amount0Out, amount1Out, to, new bytes(0));
883         }
884     }
885     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
886         uint amountIn,
887         uint amountOutMin,
888         address[] calldata path,
889         address to,
890         uint deadline
891     ) external virtual override ensure(deadline) {
892         TransferHelper.safeTransferFrom(
893             path[0], msg.sender, SwapXV1Library.pairFor(factory, path[0], path[1]), amountIn
894         );
895         uint balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
896         _swapSupportingFeeOnTransferTokens(path, to);
897         require(
898             IERC20(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
899             'SwapXV1Router: INSUFFICIENT_OUTPUT_AMOUNT'
900         );
901     }
902     function swapExactETHForTokensSupportingFeeOnTransferTokens(
903         uint amountOutMin,
904         address[] calldata path,
905         address to,
906         uint deadline
907     )
908         external
909         virtual
910         override
911         payable
912         ensure(deadline)
913     {
914         require(path[0] == WETH, 'SwapXV1Router: INVALID_PATH');
915         uint amountIn = msg.value;
916         IWETH(WETH).deposit{value: amountIn}();
917         assert(IWETH(WETH).transfer(SwapXV1Library.pairFor(factory, path[0], path[1]), amountIn));
918         uint balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
919         _swapSupportingFeeOnTransferTokens(path, to);
920         require(
921             IERC20(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
922             'SwapXV1Router: INSUFFICIENT_OUTPUT_AMOUNT'
923         );
924     }
925     function swapExactTokensForETHSupportingFeeOnTransferTokens(
926         uint amountIn,
927         uint amountOutMin,
928         address[] calldata path,
929         address to,
930         uint deadline
931     )
932         external
933         virtual
934         override
935         ensure(deadline)
936     {
937         require(path[path.length - 1] == WETH, 'SwapXV1Router: INVALID_PATH');
938         TransferHelper.safeTransferFrom(
939             path[0], msg.sender, SwapXV1Library.pairFor(factory, path[0], path[1]), amountIn
940         );
941         _swapSupportingFeeOnTransferTokens(path, address(this));
942         uint amountOut = IERC20(WETH).balanceOf(address(this));
943         require(amountOut >= amountOutMin, 'SwapXV1Router: INSUFFICIENT_OUTPUT_AMOUNT');
944         IWETH(WETH).withdraw(amountOut);
945         TransferHelper.safeTransferETH(to, amountOut);
946     }
947 
948     // **** LIBRARY FUNCTIONS ****
949     function quote(uint amountA, uint reserveA, uint reserveB) public pure virtual override returns (uint amountB) {
950         return SwapXV1Library.quote(amountA, reserveA, reserveB);
951     }
952 
953     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut)
954         public
955         pure
956         virtual
957         override
958         returns (uint amountOut)
959     {
960         return SwapXV1Library.getAmountOut(amountIn, reserveIn, reserveOut);
961     }
962 
963     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut)
964         public
965         pure
966         virtual
967         override
968         returns (uint amountIn)
969     {
970         return SwapXV1Library.getAmountIn(amountOut, reserveIn, reserveOut);
971     }
972 
973     function getAmountsOut(uint amountIn, address[] memory path)
974         public
975         view
976         virtual
977         override
978         returns (uint[] memory amounts)
979     {
980         return SwapXV1Library.getAmountsOut(factory, amountIn, path);
981     }
982 
983     function getAmountsIn(uint amountOut, address[] memory path)
984         public
985         view
986         virtual
987         override
988         returns (uint[] memory amounts)
989     {
990         return SwapXV1Library.getAmountsIn(factory, amountOut, path);
991     }
992 }