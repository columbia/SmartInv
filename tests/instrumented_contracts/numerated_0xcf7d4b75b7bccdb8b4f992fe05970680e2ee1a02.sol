1 pragma solidity >=0.6.0;
2 
3 // helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
4 library TransferHelper {
5   function safeApprove(
6     address token,
7     address to,
8     uint256 value
9 ) internal {
10     // bytes4(keccak256(bytes('approve(address,uint256)')));
11     (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
12     require(
13       success && (data.length == 0 || abi.decode(data, (bool))),
14       'TransferHelper::safeApprove: approve failed'
15     );
16   }
17 
18   function safeTransfer(
19     address token,
20     address to,
21     uint256 value
22 ) internal {
23     // bytes4(keccak256(bytes('transfer(address,uint256)')));
24     (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
25     require(
26       success && (data.length == 0 || abi.decode(data, (bool))),
27       'TransferHelper::safeTransfer: transfer failed'
28     );
29   }
30 
31   function safeTransferFrom(
32     address token,
33     address from,
34     address to,
35     uint256 value
36 ) internal {
37     // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
38     (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
39     require(
40       success && (data.length == 0 || abi.decode(data, (bool))),
41       'TransferHelper::transferFrom: transferFrom failed'
42     );
43   }
44 
45   function safeTransferETH(address to, uint256 value) internal {
46     (bool success, ) = to.call{value: value}(new bytes(0));
47     require(success, 'TransferHelper::safeTransferETH: ETH transfer failed');
48   }
49 }
50 
51 pragma solidity >=0.4.0;
52 
53 // computes square roots using the babylonian method
54 // https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method
55 library Babylonian {
56     // credit for this implementation goes to
57     // https://github.com/abdk-consulting/abdk-libraries-solidity/blob/master/ABDKMath64x64.sol#L687
58     function sqrt(uint256 x) internal pure returns (uint256) {
59         if (x == 0) return 0;
60         // this block is equivalent to r = uint256(1) << (BitMath.mostSignificantBit(x) / 2);
61         // however that code costs significantly more gas
62         uint256 xx = x;
63         uint256 r = 1;
64         if (xx >= 0x100000000000000000000000000000000) {
65             xx >>= 128;
66             r <<= 64;
67         }
68         if (xx >= 0x10000000000000000) {
69             xx >>= 64;
70             r <<= 32;
71         }
72         if (xx >= 0x100000000) {
73             xx >>= 32;
74             r <<= 16;
75         }
76         if (xx >= 0x10000) {
77             xx >>= 16;
78             r <<= 8;
79         }
80         if (xx >= 0x100) {
81             xx >>= 8;
82             r <<= 4;
83         }
84         if (xx >= 0x10) {
85             xx >>= 4;
86             r <<= 2;
87         }
88         if (xx >= 0x8) {
89             r <<= 1;
90         }
91         r = (r + x / r) >> 1;
92         r = (r + x / r) >> 1;
93         r = (r + x / r) >> 1;
94         r = (r + x / r) >> 1;
95         r = (r + x / r) >> 1;
96         r = (r + x / r) >> 1;
97         r = (r + x / r) >> 1; // Seven iterations should be enough
98         uint256 r1 = x / r;
99         return (r < r1 ? r : r1);
100     }
101 }
102 
103 pragma solidity =0.6.6;
104 
105 // a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)
106 
107 library SafeMath {
108     function add(uint x, uint y) internal pure returns (uint z) {
109         require((z = x + y) >= x, 'ds-math-add-overflow');
110     }
111 
112     function sub(uint x, uint y) internal pure returns (uint z) {
113         require((z = x - y) <= x, 'ds-math-sub-underflow');
114     }
115 
116     function mul(uint x, uint y) internal pure returns (uint z) {
117         require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');
118     }
119 }
120 
121 // SPDX-License-Identifier: CC-BY-4.0
122 pragma solidity >=0.4.0;
123 
124 // taken from https://medium.com/coinmonks/math-in-solidity-part-3-percents-and-proportions-4db014e080b1
125 // license is CC-BY-4.0
126 library FullMath {
127     function fullMul(uint256 x, uint256 y) internal pure returns (uint256 l, uint256 h) {
128         uint256 mm = mulmod(x, y, uint256(-1));
129         l = x * y;
130         h = mm - l;
131         if (mm < l) h -= 1;
132     }
133 
134     function fullDiv(
135         uint256 l,
136         uint256 h,
137         uint256 d
138     ) private pure returns (uint256) {
139         uint256 pow2 = d & -d;
140         d /= pow2;
141         l /= pow2;
142         l += h * ((-pow2) / pow2 + 1);
143         uint256 r = 1;
144         r *= 2 - d * r;
145         r *= 2 - d * r;
146         r *= 2 - d * r;
147         r *= 2 - d * r;
148         r *= 2 - d * r;
149         r *= 2 - d * r;
150         r *= 2 - d * r;
151         r *= 2 - d * r;
152         return l * r;
153     }
154 
155     function mulDiv(
156         uint256 x,
157         uint256 y,
158         uint256 d
159     ) internal pure returns (uint256) {
160         (uint256 l, uint256 h) = fullMul(x, y);
161 
162         uint256 mm = mulmod(x, y, d);
163         if (mm > l) h -= 1;
164         l -= mm;
165 
166         if (h == 0) return l / d;
167 
168         require(h < d, 'FullMath: FULLDIV_OVERFLOW');
169         return fullDiv(l, h, d);
170     }
171 }
172 
173 pragma solidity >=0.4.0;
174 
175 // a library for handling binary fixed point numbers (https://en.wikipedia.org/wiki/Q_(number_format))
176 library FixedPoint {
177     // range: [0, 2**112 - 1]
178     // resolution: 1 / 2**112
179     struct uq112x112 {
180         uint224 _x;
181     }
182 
183     // range: [0, 2**144 - 1]
184     // resolution: 1 / 2**112
185     struct uq144x112 {
186         uint256 _x;
187     }
188 
189     uint8 public constant RESOLUTION = 112;
190     uint256 public constant Q112 = 0x10000000000000000000000000000; // 2**112
191     uint256 private constant Q224 = 0x100000000000000000000000000000000000000000000000000000000; // 2**224
192     uint256 private constant LOWER_MASK = 0xffffffffffffffffffffffffffff; // decimal of UQ*x112 (lower 112 bits)
193 
194     // encode a uint112 as a UQ112x112
195     function encode(uint112 x) internal pure returns (uq112x112 memory) {
196         return uq112x112(uint224(x) << RESOLUTION);
197     }
198 
199     // encodes a uint144 as a UQ144x112
200     function encode144(uint144 x) internal pure returns (uq144x112 memory) {
201         return uq144x112(uint256(x) << RESOLUTION);
202     }
203 
204     // decode a UQ112x112 into a uint112 by truncating after the radix point
205     function decode(uq112x112 memory self) internal pure returns (uint112) {
206         return uint112(self._x >> RESOLUTION);
207     }
208 
209     // decode a UQ144x112 into a uint144 by truncating after the radix point
210     function decode144(uq144x112 memory self) internal pure returns (uint144) {
211         return uint144(self._x >> RESOLUTION);
212     }
213 
214     // multiply a UQ112x112 by a uint, returning a UQ144x112
215     // reverts on overflow
216     function mul(uq112x112 memory self, uint256 y) internal pure returns (uq144x112 memory) {
217         uint256 z = 0;
218         require(y == 0 || (z = self._x * y) / y == self._x, 'FixedPoint::mul: overflow');
219         return uq144x112(z);
220     }
221 
222     // multiply a UQ112x112 by an int and decode, returning an int
223     // reverts on overflow
224     function muli(uq112x112 memory self, int256 y) internal pure returns (int256) {
225         uint256 z = FullMath.mulDiv(self._x, uint256(y < 0 ? -y : y), Q112);
226         require(z < 2**255, 'FixedPoint::muli: overflow');
227         return y < 0 ? -int256(z) : int256(z);
228     }
229 
230     // multiply a UQ112x112 by a UQ112x112, returning a UQ112x112
231     // lossy
232     function muluq(uq112x112 memory self, uq112x112 memory other) internal pure returns (uq112x112 memory) {
233         if (self._x == 0 || other._x == 0) {
234             return uq112x112(0);
235         }
236         uint112 upper_self = uint112(self._x >> RESOLUTION); // * 2^0
237         uint112 lower_self = uint112(self._x & LOWER_MASK); // * 2^-112
238         uint112 upper_other = uint112(other._x >> RESOLUTION); // * 2^0
239         uint112 lower_other = uint112(other._x & LOWER_MASK); // * 2^-112
240 
241         // partial products
242         uint224 upper = uint224(upper_self) * upper_other; // * 2^0
243         uint224 lower = uint224(lower_self) * lower_other; // * 2^-224
244         uint224 uppers_lowero = uint224(upper_self) * lower_other; // * 2^-112
245         uint224 uppero_lowers = uint224(upper_other) * lower_self; // * 2^-112
246 
247         // so the bit shift does not overflow
248         require(upper <= uint112(-1), 'FixedPoint::muluq: upper overflow');
249 
250         // this cannot exceed 256 bits, all values are 224 bits
251         uint256 sum = uint256(upper << RESOLUTION) + uppers_lowero + uppero_lowers + (lower >> RESOLUTION);
252 
253         // so the cast does not overflow
254         require(sum <= uint224(-1), 'FixedPoint::muluq: sum overflow');
255 
256         return uq112x112(uint224(sum));
257     }
258 
259     // divide a UQ112x112 by a UQ112x112, returning a UQ112x112
260     function divuq(uq112x112 memory self, uq112x112 memory other) internal pure returns (uq112x112 memory) {
261         require(other._x > 0, 'FixedPoint::divuq: division by zero');
262         if (self._x == other._x) {
263             return uq112x112(uint224(Q112));
264         }
265         if (self._x <= uint144(-1)) {
266             uint256 value = (uint256(self._x) << RESOLUTION) / other._x;
267             require(value <= uint224(-1), 'FixedPoint::divuq: overflow');
268             return uq112x112(uint224(value));
269         }
270 
271         uint256 result = FullMath.mulDiv(Q112, self._x, other._x);
272         require(result <= uint224(-1), 'FixedPoint::divuq: overflow');
273         return uq112x112(uint224(result));
274     }
275 
276     // returns a UQ112x112 which represents the ratio of the numerator to the denominator
277     // can be lossy
278     function fraction(uint256 numerator, uint256 denominator) internal pure returns (uq112x112 memory) {
279         require(denominator > 0, 'FixedPoint::fraction: division by zero');
280         if (numerator == 0) return FixedPoint.uq112x112(0);
281 
282         if (numerator <= uint144(-1)) {
283             uint256 result = (numerator << RESOLUTION) / denominator;
284             require(result <= uint224(-1), 'FixedPoint::fraction: overflow');
285             return uq112x112(uint224(result));
286         } else {
287             uint256 result = FullMath.mulDiv(numerator, Q112, denominator);
288             require(result <= uint224(-1), 'FixedPoint::fraction: overflow');
289             return uq112x112(uint224(result));
290         }
291     }
292 
293     // take the reciprocal of a UQ112x112
294     // reverts on overflow
295     // lossy
296     function reciprocal(uq112x112 memory self) internal pure returns (uq112x112 memory) {
297         require(self._x != 0, 'FixedPoint::reciprocal: reciprocal of zero');
298         require(self._x != 1, 'FixedPoint::reciprocal: overflow');
299         return uq112x112(uint224(Q224 / self._x));
300     }
301 
302     // square root of a UQ112x112
303     // lossy between 0/1 and 40 bits
304     function sqrt(uq112x112 memory self) internal pure returns (uq112x112 memory) {
305         if (self._x <= uint144(-1)) {
306             return uq112x112(uint224(Babylonian.sqrt(uint256(self._x) << 112)));
307         }
308 
309         uint8 safeShiftBits = 255 - BitMath.mostSignificantBit(self._x);
310         safeShiftBits -= safeShiftBits % 2;
311         return uq112x112(uint224(Babylonian.sqrt(uint256(self._x) << safeShiftBits) << ((112 - safeShiftBits) / 2)));
312     }
313 }
314 
315 pragma solidity >=0.5.0;
316 
317 library BitMath {
318     // returns the 0 indexed position of the most significant bit of the input x
319     // s.t. x >= 2**msb and x < 2**(msb+1)
320     function mostSignificantBit(uint256 x) internal pure returns (uint8 r) {
321         require(x > 0, 'BitMath::mostSignificantBit: zero');
322 
323         if (x >= 0x100000000000000000000000000000000) {
324             x >>= 128;
325             r += 128;
326         }
327         if (x >= 0x10000000000000000) {
328             x >>= 64;
329             r += 64;
330         }
331         if (x >= 0x100000000) {
332             x >>= 32;
333             r += 32;
334         }
335         if (x >= 0x10000) {
336             x >>= 16;
337             r += 16;
338         }
339         if (x >= 0x100) {
340             x >>= 8;
341             r += 8;
342         }
343         if (x >= 0x10) {
344             x >>= 4;
345             r += 4;
346         }
347         if (x >= 0x4) {
348             x >>= 2;
349             r += 2;
350         }
351         if (x >= 0x2) r += 1;
352     }
353 
354     // returns the 0 indexed position of the least significant bit of the input x
355     // s.t. (x & 2**lsb) != 0 and (x & (2**(lsb) - 1)) == 0)
356     // i.e. the bit at the index is set and the mask of all lower bits is 0
357     function leastSignificantBit(uint256 x) internal pure returns (uint8 r) {
358         require(x > 0, 'BitMath::leastSignificantBit: zero');
359 
360         r = 255;
361         if (x & uint128(-1) > 0) {
362             r -= 128;
363         } else {
364             x >>= 128;
365         }
366         if (x & uint64(-1) > 0) {
367             r -= 64;
368         } else {
369             x >>= 64;
370         }
371         if (x & uint32(-1) > 0) {
372             r -= 32;
373         } else {
374             x >>= 32;
375         }
376         if (x & uint16(-1) > 0) {
377             r -= 16;
378         } else {
379             x >>= 16;
380         }
381         if (x & uint8(-1) > 0) {
382             r -= 8;
383         } else {
384             x >>= 8;
385         }
386         if (x & 0xf > 0) {
387             r -= 4;
388         } else {
389             x >>= 4;
390         }
391         if (x & 0x3 > 0) {
392             r -= 2;
393         } else {
394             x >>= 2;
395         }
396         if (x & 0x1 > 0) r -= 1;
397     }
398 }
399 
400 pragma solidity >=0.5.0;
401 
402 // library with helper methods for oracles that are concerned with computing average prices
403 library SafeswapOracleLibrary {
404     using FixedPoint for *;
405 
406     // helper function that returns the current block timestamp within the range of uint32, i.e. [0, 2**32 - 1]
407     function currentBlockTimestamp() internal view returns (uint32) {
408         return uint32(block.timestamp % 2 ** 32);
409     }
410 
411     // produces the cumulative price using counterfactuals to save gas and avoid a call to sync.
412     function currentCumulativePrices(
413         address pair
414     ) internal view returns (uint price0Cumulative, uint price1Cumulative, uint32 blockTimestamp) {
415         blockTimestamp = currentBlockTimestamp();
416         price0Cumulative = ISafeswapPair(pair).price0CumulativeLast();
417         price1Cumulative = ISafeswapPair(pair).price1CumulativeLast();
418 
419         // if time has elapsed since the last update on the pair, mock the accumulated price values
420         (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast) = ISafeswapPair(pair).getReserves();
421         if (blockTimestampLast != blockTimestamp) {
422             // subtraction overflow is desired
423             uint32 timeElapsed = blockTimestamp - blockTimestampLast;
424             // addition overflow is desired
425             // counterfactual
426             price0Cumulative += uint(FixedPoint.fraction(reserve1, reserve0)._x) * timeElapsed;
427             // counterfactual
428             price1Cumulative += uint(FixedPoint.fraction(reserve0, reserve1)._x) * timeElapsed;
429         }
430     }
431 }
432 
433 pragma solidity >=0.5.0;
434 
435 library SafeswapLibrary {
436     using SafeMath for uint;
437 
438     // returns sorted token addresses, used to handle return values from pairs sorted in this order
439     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
440         require(tokenA != tokenB, 'SafeswapLibrary: IDENTICAL_ADDRESSES');
441         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
442         require(token0 != address(0), 'SafeswapLibrary: ZERO_ADDRESS');
443     }
444 
445     // calculates the CREATE2 address for a pair without making any external calls
446     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
447         (address token0, address token1) = sortTokens(tokenA, tokenB);
448         pair = address(uint(keccak256(abi.encodePacked(
449                 hex'ff',
450                 factory,
451                 keccak256(abi.encodePacked(token0, token1)),
452                 hex'7fc48862bb659c6079c67f949053514afd141b7fcc1dc2b0a9474d647c51d670' // init code hash
453             ))));
454     }
455 
456     // fetches and sorts the reserves for a pair
457     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
458         (address token0,) = sortTokens(tokenA, tokenB);
459         pairFor(factory, tokenA, tokenB);
460         (uint reserve0, uint reserve1,) = ISafeswapPair(pairFor(factory, tokenA, tokenB)).getReserves();
461         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
462     }
463 
464     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
465     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
466         require(amountA > 0, 'SafeswapLibrary: INSUFFICIENT_AMOUNT');
467         require(reserveA > 0 && reserveB > 0, 'SafeswapLibrary: INSUFFICIENT_LIQUIDITY');
468         amountB = amountA.mul(reserveB) / reserveA;
469     }
470 
471     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
472     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
473         require(amountIn > 0, 'SafeswapLibrary: INSUFFICIENT_INPUT_AMOUNT');
474         require(reserveIn > 0 && reserveOut > 0, 'SafeswapLibrary: INSUFFICIENT_LIQUIDITY');
475         uint amountInWithFee = amountIn.mul(9975);
476         uint numerator = amountInWithFee.mul(reserveOut);
477         uint denominator = reserveIn.mul(10000).add(amountInWithFee);
478         amountOut = numerator / denominator;
479     }
480 
481     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
482     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {
483         require(amountOut > 0, 'SafeswapLibrary: INSUFFICIENT_OUTPUT_AMOUNT');
484         require(reserveIn > 0 && reserveOut > 0, 'SafeswapLibrary: INSUFFICIENT_LIQUIDITY');
485         uint numerator = reserveIn.mul(amountOut).mul(10000);
486         uint denominator = reserveOut.sub(amountOut).mul(9975);
487         amountIn = (numerator / denominator).add(1);
488     }
489 
490     // performs chained getAmountOut calculations on any number of pairs
491     function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {
492         require(path.length >= 2, 'SafeswapLibrary: INVALID_PATH');
493         amounts = new uint[](path.length);
494         amounts[0] = amountIn;
495         for (uint i; i < path.length - 1; i++) {
496             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);
497             amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
498         }
499     }
500 
501     // performs chained getAmountIn calculations on any number of pairs
502     function getAmountsIn(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {
503         require(path.length >= 2, 'SafeswapLibrary: INVALID_PATH');
504         amounts = new uint[](path.length);
505         amounts[amounts.length - 1] = amountOut;
506         for (uint i = path.length - 1; i > 0; i--) {
507             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);
508             amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
509         }
510     }
511 }
512 
513 pragma solidity >=0.5.0;
514 
515 interface ISafeswapFactory {
516     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
517 
518     function feeTo() external view returns (address);
519     function feeToSetter() external view returns (address);
520 
521     function getPair(address tokenA, address tokenB) external view returns (address pair);
522     function allPairs(uint) external view returns (address pair);
523     function allPairsLength() external view returns (uint);
524 
525     function createPair(address tokenA, address tokenB) external returns (address pair);
526 
527     function setFeeTo(address) external;
528     function setFeeToSetter(address) external;
529 }
530 
531 pragma solidity >=0.5.0;
532 
533 interface ISafeswapPair {
534     event Approval(address indexed owner, address indexed spender, uint value);
535     event Transfer(address indexed from, address indexed to, uint value);
536 
537     function name() external pure returns (string memory);
538     function symbol() external pure returns (string memory);
539     function decimals() external pure returns (uint8);
540     function totalSupply() external view returns (uint);
541     function balanceOf(address owner) external view returns (uint);
542     function allowance(address owner, address spender) external view returns (uint);
543 
544     function approve(address spender, uint value) external returns (bool);
545     function transfer(address to, uint value) external returns (bool);
546     function transferFrom(address from, address to, uint value) external returns (bool);
547 
548     function DOMAIN_SEPARATOR() external view returns (bytes32);
549     function PERMIT_TYPEHASH() external pure returns (bytes32);
550     function nonces(address owner) external view returns (uint);
551 
552     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
553 
554     event Mint(address indexed sender, uint amount0, uint amount1);
555     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
556     event Swap(
557         address indexed sender,
558         uint amount0In,
559         uint amount1In,
560         uint amount0Out,
561         uint amount1Out,
562         address indexed to
563     );
564     event Sync(uint112 reserve0, uint112 reserve1);
565 
566     function MINIMUM_LIQUIDITY() external pure returns (uint);
567     function factory() external view returns (address);
568     function token0() external view returns (address);
569     function token1() external view returns (address);
570     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
571     function price0CumulativeLast() external view returns (uint);
572     function price1CumulativeLast() external view returns (uint);
573     function kLast() external view returns (uint);
574 
575     function mint(address to) external returns (uint liquidity);
576     function burn(address to) external returns (uint amount0, uint amount1);
577     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
578     function skim(address to) external;
579     function sync() external;
580 
581     function initialize(address, address) external;
582 }
583 
584 pragma solidity >=0.5.0;
585 
586 interface IERC20 {
587     event Approval(address indexed owner, address indexed spender, uint value);
588     event Transfer(address indexed from, address indexed to, uint value);
589 
590     function name() external view returns (string memory);
591     function symbol() external view returns (string memory);
592     function decimals() external view returns (uint8);
593     function totalSupply() external view returns (uint);
594     function balanceOf(address owner) external view returns (uint);
595     function allowance(address owner, address spender) external view returns (uint);
596 
597     function approve(address spender, uint value) external returns (bool);
598     function transfer(address to, uint value) external returns (bool);
599     function transferFrom(address from, address to, uint value) external returns (bool);
600 }
601 
602 pragma solidity >=0.5.0;
603 
604 interface ISafeswapCallee {
605     function safeswapCall(address sender, uint amount0, uint amount1, bytes calldata data) external;
606 }
607 
608 pragma solidity >=0.5.0;
609 
610 interface ISafeswapMigrator {
611     function migrate(address token, uint amountTokenMin, uint amountETHMin, address to, uint deadline) external;
612 }
613 
614 pragma solidity >=0.6.2;
615 
616 interface ISafeswapRouter01 {
617     function factory() external pure returns (address);
618     function WETH() external pure returns (address);
619 
620     function addLiquidity(
621         address tokenA,
622         address tokenB,
623         uint amountADesired,
624         uint amountBDesired,
625         uint amountAMin,
626         uint amountBMin,
627         address to,
628         uint deadline
629     ) external returns (uint amountA, uint amountB, uint liquidity);
630     function addLiquidityETH(
631         address token,
632         uint amountTokenDesired,
633         uint amountTokenMin,
634         uint amountETHMin,
635         address to,
636         uint deadline
637     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
638     function removeLiquidity(
639         address tokenA,
640         address tokenB,
641         uint liquidity,
642         uint amountAMin,
643         uint amountBMin,
644         address to,
645         uint deadline
646     ) external returns (uint amountA, uint amountB);
647     function removeLiquidityETH(
648         address token,
649         uint liquidity,
650         uint amountTokenMin,
651         uint amountETHMin,
652         address to,
653         uint deadline
654     ) external returns (uint amountToken, uint amountETH);
655     function removeLiquidityWithPermit(
656         address tokenA,
657         address tokenB,
658         uint liquidity,
659         uint amountAMin,
660         uint amountBMin,
661         address to,
662         uint deadline,
663         bool approveMax, uint8 v, bytes32 r, bytes32 s
664     ) external returns (uint amountA, uint amountB);
665     function removeLiquidityETHWithPermit(
666         address token,
667         uint liquidity,
668         uint amountTokenMin,
669         uint amountETHMin,
670         address to,
671         uint deadline,
672         bool approveMax, uint8 v, bytes32 r, bytes32 s
673     ) external returns (uint amountToken, uint amountETH);
674     function swapExactTokensForTokens(
675         uint amountIn,
676         uint amountOutMin,
677         address[] calldata path,
678         address to,
679         uint deadline
680     ) external returns (uint[] memory amounts);
681     function swapTokensForExactTokens(
682         uint amountOut,
683         uint amountInMax,
684         address[] calldata path,
685         address to,
686         uint deadline
687     ) external returns (uint[] memory amounts);
688     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
689         external
690         payable
691         returns (uint[] memory amounts);
692     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
693         external
694         returns (uint[] memory amounts);
695     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
696         external
697         returns (uint[] memory amounts);
698     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
699         external
700         payable
701         returns (uint[] memory amounts);
702 
703     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
704     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
705     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
706     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
707     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
708 }
709 
710 pragma solidity >=0.6.2;
711 
712 interface ISafeswapRouter02 is ISafeswapRouter01 {
713     function removeLiquidityETHSupportingFeeOnTransferTokens(
714         address token,
715         uint liquidity,
716         uint amountTokenMin,
717         uint amountETHMin,
718         address to,
719         uint deadline
720     ) external returns (uint amountETH);
721     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
722         address token,
723         uint liquidity,
724         uint amountTokenMin,
725         uint amountETHMin,
726         address to,
727         uint deadline,
728         bool approveMax, uint8 v, bytes32 r, bytes32 s
729     ) external returns (uint amountETH);
730 
731     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
732         uint amountIn,
733         uint amountOutMin,
734         address[] calldata path,
735         address to,
736         uint deadline
737     ) external;
738     function swapExactETHForTokensSupportingFeeOnTransferTokens(
739         uint amountOutMin,
740         address[] calldata path,
741         address to,
742         uint deadline
743     ) external payable;
744     function swapExactTokensForETHSupportingFeeOnTransferTokens(
745         uint amountIn,
746         uint amountOutMin,
747         address[] calldata path,
748         address to,
749         uint deadline
750     ) external;
751 }
752 
753 pragma solidity >=0.5.0;
754 
755 interface IWETH {
756     function deposit() external payable;
757     function transfer(address to, uint value) external returns (bool);
758     function withdraw(uint) external;
759 }
760 
761 pragma solidity >=0.5.0;
762 
763 interface IUniswapV1Exchange {
764     function balanceOf(address owner) external view returns (uint);
765     function transferFrom(address from, address to, uint value) external returns (bool);
766     function removeLiquidity(uint, uint, uint, uint) external returns (uint, uint);
767     function tokenToEthSwapInput(uint, uint, uint) external returns (uint);
768     function ethToTokenSwapInput(uint, uint) external payable returns (uint);
769 }
770 
771 pragma solidity >=0.5.0;
772 
773 interface IUniswapV1Factory {
774     function getExchange(address) external view returns (address);
775 }
776 
777 // SPDX-License-Identifier: MIT
778 pragma solidity >=0.4.25 <0.7.0;
779 
780 contract Migrations {
781   address public owner;
782   uint public last_completed_migration;
783 
784   modifier restricted() {
785     if (msg.sender == owner) _;
786   }
787 
788   constructor() public {
789     owner = msg.sender;
790   }
791 
792   function setCompleted(uint completed) public restricted {
793     last_completed_migration = completed;
794   }
795 }
796 
797 
798 pragma solidity =0.6.6;
799 
800 contract SafeswapRouter is ISafeswapRouter02 {
801     using SafeMath for uint;
802 
803     address public immutable override factory;
804     address public immutable override WETH;
805 
806     modifier ensure(uint deadline) {
807         require(deadline >= block.timestamp, 'SafeswapRouter: EXPIRED');
808         _;
809     }
810 
811     constructor(address _factory, address _WETH) public {
812         factory = _factory;
813         WETH = _WETH;
814     }
815 
816     receive() external payable {
817         assert(msg.sender == WETH); // only accept ETH via fallback from the WETH contract
818     }
819 
820     // **** ADD LIQUIDITY ****
821     function _addLiquidity(
822         address tokenA,
823         address tokenB,
824         uint amountADesired,
825         uint amountBDesired,
826         uint amountAMin,
827         uint amountBMin
828     ) internal virtual returns (uint amountA, uint amountB) {
829         // create the pair if it doesn't exist yet
830         if (ISafeswapFactory(factory).getPair(tokenA, tokenB) == address(0)) {
831             ISafeswapFactory(factory).createPair(tokenA, tokenB);
832         }
833         (uint reserveA, uint reserveB) = SafeswapLibrary.getReserves(factory, tokenA, tokenB);
834         if (reserveA == 0 && reserveB == 0) {
835             (amountA, amountB) = (amountADesired, amountBDesired);
836         } else {
837             uint amountBOptimal = SafeswapLibrary.quote(amountADesired, reserveA, reserveB);
838             if (amountBOptimal <= amountBDesired) {
839                 require(amountBOptimal >= amountBMin, 'SafeswapRouter: INSUFFICIENT_B_AMOUNT');
840                 (amountA, amountB) = (amountADesired, amountBOptimal);
841             } else {
842                 uint amountAOptimal = SafeswapLibrary.quote(amountBDesired, reserveB, reserveA);
843                 assert(amountAOptimal <= amountADesired);
844                 require(amountAOptimal >= amountAMin, 'SafeswapRouter: INSUFFICIENT_A_AMOUNT');
845                 (amountA, amountB) = (amountAOptimal, amountBDesired);
846             }
847         }
848     }
849     function addLiquidity(
850         address tokenA,
851         address tokenB,
852         uint amountADesired,
853         uint amountBDesired,
854         uint amountAMin,
855         uint amountBMin,
856         address to,
857         uint deadline
858     ) external virtual override ensure(deadline) returns (uint amountA, uint amountB, uint liquidity) {
859         (amountA, amountB) = _addLiquidity(tokenA, tokenB, amountADesired, amountBDesired, amountAMin, amountBMin);
860         address pair = SafeswapLibrary.pairFor(factory, tokenA, tokenB);
861         TransferHelper.safeTransferFrom(tokenA, msg.sender, pair, amountA);
862         TransferHelper.safeTransferFrom(tokenB, msg.sender, pair, amountB);
863         liquidity = ISafeswapPair(pair).mint(to);
864     }
865     function addLiquidityETH(
866         address token,
867         uint amountTokenDesired,
868         uint amountTokenMin,
869         uint amountETHMin,
870         address to,
871         uint deadline
872     ) external virtual override payable ensure(deadline) returns (uint amountToken, uint amountETH, uint liquidity) {
873         (amountToken, amountETH) = _addLiquidity(
874             token,
875             WETH,
876             amountTokenDesired,
877             msg.value,
878             amountTokenMin,
879             amountETHMin
880         );
881         address pair = SafeswapLibrary.pairFor(factory, token, WETH);
882         TransferHelper.safeTransferFrom(token, msg.sender, pair, amountToken);
883         IWETH(WETH).deposit{value: amountETH}();
884         assert(IWETH(WETH).transfer(pair, amountETH));
885         liquidity = ISafeswapPair(pair).mint(to);
886         // refund dust eth, if any
887         if (msg.value > amountETH) TransferHelper.safeTransferETH(msg.sender, msg.value - amountETH);
888     }
889 
890     // **** REMOVE LIQUIDITY ****
891     function removeLiquidity(
892         address tokenA,
893         address tokenB,
894         uint liquidity,
895         uint amountAMin,
896         uint amountBMin,
897         address to,
898         uint deadline
899     ) public virtual override ensure(deadline) returns (uint amountA, uint amountB) {
900         address pair = SafeswapLibrary.pairFor(factory, tokenA, tokenB);
901         ISafeswapPair(pair).transferFrom(msg.sender, pair, liquidity); // send liquidity to pair
902         (uint amount0, uint amount1) = ISafeswapPair(pair).burn(to);
903         (address token0,) = SafeswapLibrary.sortTokens(tokenA, tokenB);
904         (amountA, amountB) = tokenA == token0 ? (amount0, amount1) : (amount1, amount0);
905         require(amountA >= amountAMin, 'SafeswapRouter: INSUFFICIENT_A_AMOUNT');
906         require(amountB >= amountBMin, 'SafeswapRouter: INSUFFICIENT_B_AMOUNT');
907     }
908     function removeLiquidityETH(
909         address token,
910         uint liquidity,
911         uint amountTokenMin,
912         uint amountETHMin,
913         address to,
914         uint deadline
915     ) public virtual override ensure(deadline) returns (uint amountToken, uint amountETH) {
916         (amountToken, amountETH) = removeLiquidity(
917             token,
918             WETH,
919             liquidity,
920             amountTokenMin,
921             amountETHMin,
922             address(this),
923             deadline
924         );
925         TransferHelper.safeTransfer(token, to, amountToken);
926         IWETH(WETH).withdraw(amountETH);
927         TransferHelper.safeTransferETH(to, amountETH);
928     }
929     function removeLiquidityWithPermit(
930         address tokenA,
931         address tokenB,
932         uint liquidity,
933         uint amountAMin,
934         uint amountBMin,
935         address to,
936         uint deadline,
937         bool approveMax, uint8 v, bytes32 r, bytes32 s
938     ) external virtual override returns (uint amountA, uint amountB) {
939         address pair = SafeswapLibrary.pairFor(factory, tokenA, tokenB);
940         uint value = approveMax ? uint(-1) : liquidity;
941         ISafeswapPair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
942         (amountA, amountB) = removeLiquidity(tokenA, tokenB, liquidity, amountAMin, amountBMin, to, deadline);
943     }
944     function removeLiquidityETHWithPermit(
945         address token,
946         uint liquidity,
947         uint amountTokenMin,
948         uint amountETHMin,
949         address to,
950         uint deadline,
951         bool approveMax, uint8 v, bytes32 r, bytes32 s
952     ) external virtual override returns (uint amountToken, uint amountETH) {
953         address pair = SafeswapLibrary.pairFor(factory, token, WETH);
954         uint value = approveMax ? uint(-1) : liquidity;
955         ISafeswapPair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
956         (amountToken, amountETH) = removeLiquidityETH(token, liquidity, amountTokenMin, amountETHMin, to, deadline);
957     }
958 
959     // **** REMOVE LIQUIDITY (supporting fee-on-transfer tokens) ****
960     function removeLiquidityETHSupportingFeeOnTransferTokens(
961         address token,
962         uint liquidity,
963         uint amountTokenMin,
964         uint amountETHMin,
965         address to,
966         uint deadline
967     ) public virtual override ensure(deadline) returns (uint amountETH) {
968         (, amountETH) = removeLiquidity(
969             token,
970             WETH,
971             liquidity,
972             amountTokenMin,
973             amountETHMin,
974             address(this),
975             deadline
976         );
977         TransferHelper.safeTransfer(token, to, IERC20(token).balanceOf(address(this)));
978         IWETH(WETH).withdraw(amountETH);
979         TransferHelper.safeTransferETH(to, amountETH);
980     }
981     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
982         address token,
983         uint liquidity,
984         uint amountTokenMin,
985         uint amountETHMin,
986         address to,
987         uint deadline,
988         bool approveMax, uint8 v, bytes32 r, bytes32 s
989     ) external virtual override returns (uint amountETH) {
990         address pair = SafeswapLibrary.pairFor(factory, token, WETH);
991         uint value = approveMax ? uint(-1) : liquidity;
992         ISafeswapPair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
993         amountETH = removeLiquidityETHSupportingFeeOnTransferTokens(
994             token, liquidity, amountTokenMin, amountETHMin, to, deadline
995         );
996     }
997 
998     // **** SWAP ****
999     // requires the initial amount to have already been sent to the first pair
1000     function _swap(uint[] memory amounts, address[] memory path, address _to) internal virtual {
1001         for (uint i; i < path.length - 1; i++) {
1002             (address input, address output) = (path[i], path[i + 1]);
1003             (address token0,) = SafeswapLibrary.sortTokens(input, output);
1004             uint amountOut = amounts[i + 1];
1005             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOut) : (amountOut, uint(0));
1006             address to = i < path.length - 2 ? SafeswapLibrary.pairFor(factory, output, path[i + 2]) : _to;
1007             ISafeswapPair(SafeswapLibrary.pairFor(factory, input, output)).swap(
1008                 amount0Out, amount1Out, to, new bytes(0)
1009             );
1010         }
1011     }
1012     function swapExactTokensForTokens(
1013         uint amountIn,
1014         uint amountOutMin,
1015         address[] calldata path,
1016         address to,
1017         uint deadline
1018     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
1019         amounts = SafeswapLibrary.getAmountsOut(factory, amountIn, path);
1020         require(amounts[amounts.length - 1] >= amountOutMin, 'SafeswapRouter: INSUFFICIENT_OUTPUT_AMOUNT');
1021         TransferHelper.safeTransferFrom(
1022             path[0], msg.sender, SafeswapLibrary.pairFor(factory, path[0], path[1]), amounts[0]
1023         );
1024         _swap(amounts, path, to);
1025     }
1026     function swapTokensForExactTokens(
1027         uint amountOut,
1028         uint amountInMax,
1029         address[] calldata path,
1030         address to,
1031         uint deadline
1032     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
1033         amounts = SafeswapLibrary.getAmountsIn(factory, amountOut, path);
1034         require(amounts[0] <= amountInMax, 'SafeswapRouter: EXCESSIVE_INPUT_AMOUNT');
1035         TransferHelper.safeTransferFrom(
1036             path[0], msg.sender, SafeswapLibrary.pairFor(factory, path[0], path[1]), amounts[0]
1037         );
1038         _swap(amounts, path, to);
1039     }
1040     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
1041         external
1042         virtual
1043         override
1044         payable
1045         ensure(deadline)
1046         returns (uint[] memory amounts)
1047     {
1048         require(path[0] == WETH, 'SafeswapRouter: INVALID_PATH');
1049         amounts = SafeswapLibrary.getAmountsOut(factory, msg.value, path);
1050         require(amounts[amounts.length - 1] >= amountOutMin, 'SafeswapRouter: INSUFFICIENT_OUTPUT_AMOUNT');
1051         IWETH(WETH).deposit{value: amounts[0]}();
1052         assert(IWETH(WETH).transfer(SafeswapLibrary.pairFor(factory, path[0], path[1]), amounts[0]));
1053         _swap(amounts, path, to);
1054     }
1055     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
1056         external
1057         virtual
1058         override
1059         ensure(deadline)
1060         returns (uint[] memory amounts)
1061     {
1062         require(path[path.length - 1] == WETH, 'SafeswapRouter: INVALID_PATH');
1063         amounts = SafeswapLibrary.getAmountsIn(factory, amountOut, path);
1064         require(amounts[0] <= amountInMax, 'SafeswapRouter: EXCESSIVE_INPUT_AMOUNT');
1065         TransferHelper.safeTransferFrom(
1066             path[0], msg.sender, SafeswapLibrary.pairFor(factory, path[0], path[1]), amounts[0]
1067         );
1068         _swap(amounts, path, address(this));
1069         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
1070         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
1071     }
1072     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
1073         external
1074         virtual
1075         override
1076         ensure(deadline)
1077         returns (uint[] memory amounts)
1078     {
1079         require(path[path.length - 1] == WETH, 'SafeswapRouter: INVALID_PATH');
1080         amounts = SafeswapLibrary.getAmountsOut(factory, amountIn, path);
1081         require(amounts[amounts.length - 1] >= amountOutMin, 'SafeswapRouter: INSUFFICIENT_OUTPUT_AMOUNT');
1082         TransferHelper.safeTransferFrom(
1083             path[0], msg.sender, SafeswapLibrary.pairFor(factory, path[0], path[1]), amounts[0]
1084         );
1085         _swap(amounts, path, address(this));
1086         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
1087         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
1088     }
1089     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
1090         external
1091         virtual
1092         override
1093         payable
1094         ensure(deadline)
1095         returns (uint[] memory amounts)
1096     {
1097         require(path[0] == WETH, 'SafeswapRouter: INVALID_PATH');
1098         amounts = SafeswapLibrary.getAmountsIn(factory, amountOut, path);
1099         require(amounts[0] <= msg.value, 'SafeswapRouter: EXCESSIVE_INPUT_AMOUNT');
1100         IWETH(WETH).deposit{value: amounts[0]}();
1101         assert(IWETH(WETH).transfer(SafeswapLibrary.pairFor(factory, path[0], path[1]), amounts[0]));
1102         _swap(amounts, path, to);
1103         // refund dust eth, if any
1104         if (msg.value > amounts[0]) TransferHelper.safeTransferETH(msg.sender, msg.value - amounts[0]);
1105     }
1106 
1107     // **** SWAP (supporting fee-on-transfer tokens) ****
1108     // requires the initial amount to have already been sent to the first pair
1109     function _swapSupportingFeeOnTransferTokens(address[] memory path, address _to) internal virtual {
1110         for (uint i; i < path.length - 1; i++) {
1111             (address input, address output) = (path[i], path[i + 1]);
1112             (address token0,) = SafeswapLibrary.sortTokens(input, output);
1113             ISafeswapPair pair = ISafeswapPair(SafeswapLibrary.pairFor(factory, input, output));
1114             uint amountInput;
1115             uint amountOutput;
1116             { // scope to avoid stack too deep errors
1117             (uint reserve0, uint reserve1,) = pair.getReserves();
1118             (uint reserveInput, uint reserveOutput) = input == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
1119             amountInput = IERC20(input).balanceOf(address(pair)).sub(reserveInput);
1120             amountOutput = SafeswapLibrary.getAmountOut(amountInput, reserveInput, reserveOutput);
1121             }
1122             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOutput) : (amountOutput, uint(0));
1123             address to = i < path.length - 2 ? SafeswapLibrary.pairFor(factory, output, path[i + 2]) : _to;
1124             pair.swap(amount0Out, amount1Out, to, new bytes(0));
1125         }
1126     }
1127     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1128         uint amountIn,
1129         uint amountOutMin,
1130         address[] calldata path,
1131         address to,
1132         uint deadline
1133     ) external virtual override ensure(deadline) {
1134         TransferHelper.safeTransferFrom(
1135             path[0], msg.sender, SafeswapLibrary.pairFor(factory, path[0], path[1]), amountIn
1136         );
1137         uint balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
1138         _swapSupportingFeeOnTransferTokens(path, to);
1139         require(
1140             IERC20(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
1141             'SafeswapRouter: INSUFFICIENT_OUTPUT_AMOUNT'
1142         );
1143     }
1144     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1145         uint amountOutMin,
1146         address[] calldata path,
1147         address to,
1148         uint deadline
1149     )
1150         external
1151         virtual
1152         override
1153         payable
1154         ensure(deadline)
1155     {
1156         require(path[0] == WETH, 'SafeswapRouter: INVALID_PATH');
1157         uint amountIn = msg.value;
1158         IWETH(WETH).deposit{value: amountIn}();
1159         assert(IWETH(WETH).transfer(SafeswapLibrary.pairFor(factory, path[0], path[1]), amountIn));
1160         uint balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
1161         _swapSupportingFeeOnTransferTokens(path, to);
1162         require(
1163             IERC20(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
1164             'SafeswapRouter: INSUFFICIENT_OUTPUT_AMOUNT'
1165         );
1166     }
1167     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1168         uint amountIn,
1169         uint amountOutMin,
1170         address[] calldata path,
1171         address to,
1172         uint deadline
1173     )
1174         external
1175         virtual
1176         override
1177         ensure(deadline)
1178     {
1179         require(path[path.length - 1] == WETH, 'SafeswapRouter: INVALID_PATH');
1180         TransferHelper.safeTransferFrom(
1181             path[0], msg.sender, SafeswapLibrary.pairFor(factory, path[0], path[1]), amountIn
1182         );
1183         _swapSupportingFeeOnTransferTokens(path, address(this));
1184         uint amountOut = IERC20(WETH).balanceOf(address(this));
1185         require(amountOut >= amountOutMin, 'SafeswapRouter: INSUFFICIENT_OUTPUT_AMOUNT');
1186         IWETH(WETH).withdraw(amountOut);
1187         TransferHelper.safeTransferETH(to, amountOut);
1188     }
1189 
1190     // **** LIBRARY FUNCTIONS ****
1191     function quote(uint amountA, uint reserveA, uint reserveB) public pure virtual override returns (uint amountB) {
1192         return SafeswapLibrary.quote(amountA, reserveA, reserveB);
1193     }
1194 
1195     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut)
1196         public
1197         pure
1198         virtual
1199         override
1200         returns (uint amountOut)
1201     {
1202         return SafeswapLibrary.getAmountOut(amountIn, reserveIn, reserveOut);
1203     }
1204 
1205     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut)
1206         public
1207         pure
1208         virtual
1209         override
1210         returns (uint amountIn)
1211     {
1212         return SafeswapLibrary.getAmountIn(amountOut, reserveIn, reserveOut);
1213     }
1214 
1215     function getAmountsOut(uint amountIn, address[] memory path)
1216         public
1217         view
1218         virtual
1219         override
1220         returns (uint[] memory amounts)
1221     {
1222         return SafeswapLibrary.getAmountsOut(factory, amountIn, path);
1223     }
1224 
1225     function getAmountsIn(uint amountOut, address[] memory path)
1226         public
1227         view
1228         virtual
1229         override
1230         returns (uint[] memory amounts)
1231     {
1232         return SafeswapLibrary.getAmountsIn(factory, amountOut, path);
1233     }
1234 }
1235 
1236 pragma solidity =0.6.6;
1237 
1238 contract SafeswapRouter01 is ISafeswapRouter01 {
1239     address public immutable override factory;
1240     address public immutable override WETH;
1241 
1242     modifier ensure(uint deadline) {
1243         require(deadline >= block.timestamp, 'SafeswapRouter: EXPIRED');
1244         _;
1245     }
1246 
1247     constructor(address _factory, address _WETH) public {
1248         factory = _factory;
1249         WETH = _WETH;
1250     }
1251 
1252     receive() external payable {
1253         assert(msg.sender == WETH); // only accept ETH via fallback from the WETH contract
1254     }
1255 
1256     // **** ADD LIQUIDITY ****
1257     function _addLiquidity(
1258         address tokenA,
1259         address tokenB,
1260         uint amountADesired,
1261         uint amountBDesired,
1262         uint amountAMin,
1263         uint amountBMin
1264     ) private returns (uint amountA, uint amountB) {
1265         // create the pair if it doesn't exist yet
1266         if (ISafeswapFactory(factory).getPair(tokenA, tokenB) == address(0)) {
1267             ISafeswapFactory(factory).createPair(tokenA, tokenB);
1268         }
1269         (uint reserveA, uint reserveB) = SafeswapLibrary.getReserves(factory, tokenA, tokenB);
1270         if (reserveA == 0 && reserveB == 0) {
1271             (amountA, amountB) = (amountADesired, amountBDesired);
1272         } else {
1273             uint amountBOptimal = SafeswapLibrary.quote(amountADesired, reserveA, reserveB);
1274             if (amountBOptimal <= amountBDesired) {
1275                 require(amountBOptimal >= amountBMin, 'SafeswapRouter: INSUFFICIENT_B_AMOUNT');
1276                 (amountA, amountB) = (amountADesired, amountBOptimal);
1277             } else {
1278                 uint amountAOptimal = SafeswapLibrary.quote(amountBDesired, reserveB, reserveA);
1279                 assert(amountAOptimal <= amountADesired);
1280                 require(amountAOptimal >= amountAMin, 'SafeswapRouter: INSUFFICIENT_A_AMOUNT');
1281                 (amountA, amountB) = (amountAOptimal, amountBDesired);
1282             }
1283         }
1284     }
1285     function addLiquidity(
1286         address tokenA,
1287         address tokenB,
1288         uint amountADesired,
1289         uint amountBDesired,
1290         uint amountAMin,
1291         uint amountBMin,
1292         address to,
1293         uint deadline
1294     ) external override ensure(deadline) returns (uint amountA, uint amountB, uint liquidity) {
1295         (amountA, amountB) = _addLiquidity(tokenA, tokenB, amountADesired, amountBDesired, amountAMin, amountBMin);
1296         address pair = SafeswapLibrary.pairFor(factory, tokenA, tokenB);
1297         TransferHelper.safeTransferFrom(tokenA, msg.sender, pair, amountA);
1298         TransferHelper.safeTransferFrom(tokenB, msg.sender, pair, amountB);
1299         liquidity = ISafeswapPair(pair).mint(to);
1300     }
1301     function addLiquidityETH(
1302         address token,
1303         uint amountTokenDesired,
1304         uint amountTokenMin,
1305         uint amountETHMin,
1306         address to,
1307         uint deadline
1308     ) external override payable ensure(deadline) returns (uint amountToken, uint amountETH, uint liquidity) {
1309         (amountToken, amountETH) = _addLiquidity(
1310             token,
1311             WETH,
1312             amountTokenDesired,
1313             msg.value,
1314             amountTokenMin,
1315             amountETHMin
1316         );
1317         address pair = SafeswapLibrary.pairFor(factory, token, WETH);
1318         TransferHelper.safeTransferFrom(token, msg.sender, pair, amountToken);
1319         IWETH(WETH).deposit{value: amountETH}();
1320         assert(IWETH(WETH).transfer(pair, amountETH));
1321         liquidity = ISafeswapPair(pair).mint(to);
1322         if (msg.value > amountETH) TransferHelper.safeTransferETH(msg.sender, msg.value - amountETH); // refund dust eth, if any
1323     }
1324 
1325     // **** REMOVE LIQUIDITY ****
1326     function removeLiquidity(
1327         address tokenA,
1328         address tokenB,
1329         uint liquidity,
1330         uint amountAMin,
1331         uint amountBMin,
1332         address to,
1333         uint deadline
1334     ) public override ensure(deadline) returns (uint amountA, uint amountB) {
1335         address pair = SafeswapLibrary.pairFor(factory, tokenA, tokenB);
1336         ISafeswapPair(pair).transferFrom(msg.sender, pair, liquidity); // send liquidity to pair
1337         (uint amount0, uint amount1) = ISafeswapPair(pair).burn(to);
1338         (address token0,) = SafeswapLibrary.sortTokens(tokenA, tokenB);
1339         (amountA, amountB) = tokenA == token0 ? (amount0, amount1) : (amount1, amount0);
1340         require(amountA >= amountAMin, 'SafeswapRouter: INSUFFICIENT_A_AMOUNT');
1341         require(amountB >= amountBMin, 'SafeswapRouter: INSUFFICIENT_B_AMOUNT');
1342     }
1343     function removeLiquidityETH(
1344         address token,
1345         uint liquidity,
1346         uint amountTokenMin,
1347         uint amountETHMin,
1348         address to,
1349         uint deadline
1350     ) public override ensure(deadline) returns (uint amountToken, uint amountETH) {
1351         (amountToken, amountETH) = removeLiquidity(
1352             token,
1353             WETH,
1354             liquidity,
1355             amountTokenMin,
1356             amountETHMin,
1357             address(this),
1358             deadline
1359         );
1360         TransferHelper.safeTransfer(token, to, amountToken);
1361         IWETH(WETH).withdraw(amountETH);
1362         TransferHelper.safeTransferETH(to, amountETH);
1363     }
1364     function removeLiquidityWithPermit(
1365         address tokenA,
1366         address tokenB,
1367         uint liquidity,
1368         uint amountAMin,
1369         uint amountBMin,
1370         address to,
1371         uint deadline,
1372         bool approveMax, uint8 v, bytes32 r, bytes32 s
1373     ) external override returns (uint amountA, uint amountB) {
1374         address pair = SafeswapLibrary.pairFor(factory, tokenA, tokenB);
1375         uint value = approveMax ? uint(-1) : liquidity;
1376         ISafeswapPair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
1377         (amountA, amountB) = removeLiquidity(tokenA, tokenB, liquidity, amountAMin, amountBMin, to, deadline);
1378     }
1379     function removeLiquidityETHWithPermit(
1380         address token,
1381         uint liquidity,
1382         uint amountTokenMin,
1383         uint amountETHMin,
1384         address to,
1385         uint deadline,
1386         bool approveMax, uint8 v, bytes32 r, bytes32 s
1387     ) external override returns (uint amountToken, uint amountETH) {
1388         address pair = SafeswapLibrary.pairFor(factory, token, WETH);
1389         uint value = approveMax ? uint(-1) : liquidity;
1390         ISafeswapPair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
1391         (amountToken, amountETH) = removeLiquidityETH(token, liquidity, amountTokenMin, amountETHMin, to, deadline);
1392     }
1393 
1394     // **** SWAP ****
1395     // requires the initial amount to have already been sent to the first pair
1396     function _swap(uint[] memory amounts, address[] memory path, address _to) private {
1397         for (uint i; i < path.length - 1; i++) {
1398             (address input, address output) = (path[i], path[i + 1]);
1399             (address token0,) = SafeswapLibrary.sortTokens(input, output);
1400             uint amountOut = amounts[i + 1];
1401             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOut) : (amountOut, uint(0));
1402             address to = i < path.length - 2 ? SafeswapLibrary.pairFor(factory, output, path[i + 2]) : _to;
1403             ISafeswapPair(SafeswapLibrary.pairFor(factory, input, output)).swap(amount0Out, amount1Out, to, new bytes(0));
1404         }
1405     }
1406     function swapExactTokensForTokens(
1407         uint amountIn,
1408         uint amountOutMin,
1409         address[] calldata path,
1410         address to,
1411         uint deadline
1412     ) external override ensure(deadline) returns (uint[] memory amounts) {
1413         amounts = SafeswapLibrary.getAmountsOut(factory, amountIn, path);
1414         require(amounts[amounts.length - 1] >= amountOutMin, 'SafeswapRouter: INSUFFICIENT_OUTPUT_AMOUNT');
1415         TransferHelper.safeTransferFrom(path[0], msg.sender, SafeswapLibrary.pairFor(factory, path[0], path[1]), amounts[0]);
1416         _swap(amounts, path, to);
1417     }
1418     function swapTokensForExactTokens(
1419         uint amountOut,
1420         uint amountInMax,
1421         address[] calldata path,
1422         address to,
1423         uint deadline
1424     ) external override ensure(deadline) returns (uint[] memory amounts) {
1425         amounts = SafeswapLibrary.getAmountsIn(factory, amountOut, path);
1426         require(amounts[0] <= amountInMax, 'SafeswapRouter: EXCESSIVE_INPUT_AMOUNT');
1427         TransferHelper.safeTransferFrom(path[0], msg.sender, SafeswapLibrary.pairFor(factory, path[0], path[1]), amounts[0]);
1428         _swap(amounts, path, to);
1429     }
1430     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
1431         external
1432         override
1433         payable
1434         ensure(deadline)
1435         returns (uint[] memory amounts)
1436     {
1437         require(path[0] == WETH, 'SafeswapRouter: INVALID_PATH');
1438         amounts = SafeswapLibrary.getAmountsOut(factory, msg.value, path);
1439         require(amounts[amounts.length - 1] >= amountOutMin, 'SafeswapRouter: INSUFFICIENT_OUTPUT_AMOUNT');
1440         IWETH(WETH).deposit{value: amounts[0]}();
1441         assert(IWETH(WETH).transfer(SafeswapLibrary.pairFor(factory, path[0], path[1]), amounts[0]));
1442         _swap(amounts, path, to);
1443     }
1444     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
1445         external
1446         override
1447         ensure(deadline)
1448         returns (uint[] memory amounts)
1449     {
1450         require(path[path.length - 1] == WETH, 'SafeswapRouter: INVALID_PATH');
1451         amounts = SafeswapLibrary.getAmountsIn(factory, amountOut, path);
1452         require(amounts[0] <= amountInMax, 'SafeswapRouter: EXCESSIVE_INPUT_AMOUNT');
1453         TransferHelper.safeTransferFrom(path[0], msg.sender, SafeswapLibrary.pairFor(factory, path[0], path[1]), amounts[0]);
1454         _swap(amounts, path, address(this));
1455         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
1456         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
1457     }
1458     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
1459         external
1460         override
1461         ensure(deadline)
1462         returns (uint[] memory amounts)
1463     {
1464         require(path[path.length - 1] == WETH, 'SafeswapRouter: INVALID_PATH');
1465         amounts = SafeswapLibrary.getAmountsOut(factory, amountIn, path);
1466         require(amounts[amounts.length - 1] >= amountOutMin, 'SafeswapRouter: INSUFFICIENT_OUTPUT_AMOUNT');
1467         TransferHelper.safeTransferFrom(path[0], msg.sender, SafeswapLibrary.pairFor(factory, path[0], path[1]), amounts[0]);
1468         _swap(amounts, path, address(this));
1469         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
1470         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
1471     }
1472     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
1473         external
1474         override
1475         payable
1476         ensure(deadline)
1477         returns (uint[] memory amounts)
1478     {
1479         require(path[0] == WETH, 'SafeswapRouter: INVALID_PATH');
1480         amounts = SafeswapLibrary.getAmountsIn(factory, amountOut, path);
1481         require(amounts[0] <= msg.value, 'SafeswapRouter: EXCESSIVE_INPUT_AMOUNT');
1482         IWETH(WETH).deposit{value: amounts[0]}();
1483         assert(IWETH(WETH).transfer(SafeswapLibrary.pairFor(factory, path[0], path[1]), amounts[0]));
1484         _swap(amounts, path, to);
1485         if (msg.value > amounts[0]) TransferHelper.safeTransferETH(msg.sender, msg.value - amounts[0]); // refund dust eth, if any
1486     }
1487 
1488     function quote(uint amountA, uint reserveA, uint reserveB) public pure override returns (uint amountB) {
1489         return SafeswapLibrary.quote(amountA, reserveA, reserveB);
1490     }
1491 
1492     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) public pure override returns (uint amountOut) {
1493         return SafeswapLibrary.getAmountOut(amountIn, reserveIn, reserveOut);
1494     }
1495 
1496     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) public pure override returns (uint amountIn) {
1497         return SafeswapLibrary.getAmountOut(amountOut, reserveIn, reserveOut);
1498     }
1499 
1500     function getAmountsOut(uint amountIn, address[] memory path) public view override returns (uint[] memory amounts) {
1501         return SafeswapLibrary.getAmountsOut(factory, amountIn, path);
1502     }
1503 
1504     function getAmountsIn(uint amountOut, address[] memory path) public view override returns (uint[] memory amounts) {
1505         return SafeswapLibrary.getAmountsIn(factory, amountOut, path);
1506     }
1507 }
1508 
1509 
1510 pragma solidity =0.6.6;
1511 
1512 contract SafeswapMigrator is ISafeswapMigrator {
1513     IUniswapV1Factory immutable factoryV1;
1514     ISafeswapRouter01 immutable router;
1515 
1516     constructor(address _factoryV1, address _router) public {
1517         factoryV1 = IUniswapV1Factory(_factoryV1);
1518         router = ISafeswapRouter01(_router);
1519     }
1520 
1521     // needs to accept ETH from any v1 exchange and the router. ideally this could be enforced, as in the router,
1522     // but it's not possible because it requires a call to the v1 factory, which takes too much gas
1523     receive() external payable {}
1524 
1525     function migrate(address token, uint amountTokenMin, uint amountETHMin, address to, uint deadline)
1526         external
1527         override
1528     {
1529         IUniswapV1Exchange exchangeV1 = IUniswapV1Exchange(factoryV1.getExchange(token));
1530         uint liquidityV1 = exchangeV1.balanceOf(msg.sender);
1531         require(exchangeV1.transferFrom(msg.sender, address(this), liquidityV1), 'TRANSFER_FROM_FAILED');
1532         (uint amountETHV1, uint amountTokenV1) = exchangeV1.removeLiquidity(liquidityV1, 1, 1, uint(-1));
1533         TransferHelper.safeApprove(token, address(router), amountTokenV1);
1534         (uint amountTokenV2, uint amountETHV2,) = router.addLiquidityETH{value: amountETHV1}(
1535             token,
1536             amountTokenV1,
1537             amountTokenMin,
1538             amountETHMin,
1539             to,
1540             deadline
1541         );
1542         if (amountTokenV1 > amountTokenV2) {
1543             TransferHelper.safeApprove(token, address(router), 0); // be a good blockchain citizen, reset allowance to 0
1544             TransferHelper.safeTransfer(token, msg.sender, amountTokenV1 - amountTokenV2);
1545         } else if (amountETHV1 > amountETHV2) {
1546             // addLiquidityETH guarantees that all of amountETHV1 or amountTokenV1 will be used, hence this else is safe
1547             TransferHelper.safeTransferETH(msg.sender, amountETHV1 - amountETHV2);
1548         }
1549     }
1550 }