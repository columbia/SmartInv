1 // SPDX-License-Identifier: GPL-3.0
2 
3 pragma solidity 0.8.15;
4 
5 /// @title Math library for computing sqrt prices from ticks and vice versa
6 /// @notice Computes sqrt price for ticks of size 1.0001, i.e. sqrt(1.0001^tick) as fixed point Q64.96 numbers. Supports
7 /// prices between 2**-128 and 2**128
8 library TickMath {
9     error T();
10     error R();
11 
12     /// @dev The minimum tick that may be passed to #getSqrtRatioAtTick computed from log base 1.0001 of 2**-128
13     int24 internal constant MIN_TICK = -887272;
14     /// @dev The maximum tick that may be passed to #getSqrtRatioAtTick computed from log base 1.0001 of 2**128
15     int24 internal constant MAX_TICK = -MIN_TICK;
16 
17     /// @dev The minimum value that can be returned from #getSqrtRatioAtTick. Equivalent to getSqrtRatioAtTick(MIN_TICK)
18     uint160 internal constant MIN_SQRT_RATIO = 4295128739;
19     /// @dev The maximum value that can be returned from #getSqrtRatioAtTick. Equivalent to getSqrtRatioAtTick(MAX_TICK)
20     uint160 internal constant MAX_SQRT_RATIO = 1461446703485210103287273052203988822378723970342;
21 
22     /// @notice Calculates sqrt(1.0001^tick) * 2^96
23     /// @dev Throws if |tick| > max tick
24     /// @param tick The input tick for the above formula
25     /// @return sqrtPriceX96 A Fixed point Q64.96 number representing the sqrt of the ratio of the two assets (token1/token0)
26     /// at the given tick
27     function getSqrtRatioAtTick(int24 tick) internal pure returns (uint160 sqrtPriceX96) {
28         unchecked {
29             uint256 absTick = tick < 0 ? uint256(-int256(tick)) : uint256(int256(tick));
30             if (absTick > uint256(int256(MAX_TICK))) revert T();
31 
32             uint256 ratio = absTick & 0x1 != 0
33                 ? 0xfffcb933bd6fad37aa2d162d1a594001
34                 : 0x100000000000000000000000000000000;
35             if (absTick & 0x2 != 0) ratio = (ratio * 0xfff97272373d413259a46990580e213a) >> 128;
36             if (absTick & 0x4 != 0) ratio = (ratio * 0xfff2e50f5f656932ef12357cf3c7fdcc) >> 128;
37             if (absTick & 0x8 != 0) ratio = (ratio * 0xffe5caca7e10e4e61c3624eaa0941cd0) >> 128;
38             if (absTick & 0x10 != 0) ratio = (ratio * 0xffcb9843d60f6159c9db58835c926644) >> 128;
39             if (absTick & 0x20 != 0) ratio = (ratio * 0xff973b41fa98c081472e6896dfb254c0) >> 128;
40             if (absTick & 0x40 != 0) ratio = (ratio * 0xff2ea16466c96a3843ec78b326b52861) >> 128;
41             if (absTick & 0x80 != 0) ratio = (ratio * 0xfe5dee046a99a2a811c461f1969c3053) >> 128;
42             if (absTick & 0x100 != 0) ratio = (ratio * 0xfcbe86c7900a88aedcffc83b479aa3a4) >> 128;
43             if (absTick & 0x200 != 0) ratio = (ratio * 0xf987a7253ac413176f2b074cf7815e54) >> 128;
44             if (absTick & 0x400 != 0) ratio = (ratio * 0xf3392b0822b70005940c7a398e4b70f3) >> 128;
45             if (absTick & 0x800 != 0) ratio = (ratio * 0xe7159475a2c29b7443b29c7fa6e889d9) >> 128;
46             if (absTick & 0x1000 != 0) ratio = (ratio * 0xd097f3bdfd2022b8845ad8f792aa5825) >> 128;
47             if (absTick & 0x2000 != 0) ratio = (ratio * 0xa9f746462d870fdf8a65dc1f90e061e5) >> 128;
48             if (absTick & 0x4000 != 0) ratio = (ratio * 0x70d869a156d2a1b890bb3df62baf32f7) >> 128;
49             if (absTick & 0x8000 != 0) ratio = (ratio * 0x31be135f97d08fd981231505542fcfa6) >> 128;
50             if (absTick & 0x10000 != 0) ratio = (ratio * 0x9aa508b5b7a84e1c677de54f3e99bc9) >> 128;
51             if (absTick & 0x20000 != 0) ratio = (ratio * 0x5d6af8dedb81196699c329225ee604) >> 128;
52             if (absTick & 0x40000 != 0) ratio = (ratio * 0x2216e584f5fa1ea926041bedfe98) >> 128;
53             if (absTick & 0x80000 != 0) ratio = (ratio * 0x48a170391f7dc42444e8fa2) >> 128;
54 
55             if (tick > 0) ratio = type(uint256).max / ratio;
56 
57             // this divides by 1<<32 rounding up to go from a Q128.128 to a Q128.96.
58             // we then downcast because we know the result always fits within 160 bits due to our tick input constraint
59             // we round up in the division so getTickAtSqrtRatio of the output price is always consistent
60             sqrtPriceX96 = uint160((ratio >> 32) + (ratio % (1 << 32) == 0 ? 0 : 1));
61         }
62     }
63 
64     /// @notice Calculates the greatest tick value such that getRatioAtTick(tick) <= ratio
65     /// @dev Throws in case sqrtPriceX96 < MIN_SQRT_RATIO, as MIN_SQRT_RATIO is the lowest value getRatioAtTick may
66     /// ever return.
67     /// @param sqrtPriceX96 The sqrt ratio for which to compute the tick as a Q64.96
68     /// @return tick The greatest tick for which the ratio is less than or equal to the input ratio
69     function getTickAtSqrtRatio(uint160 sqrtPriceX96) internal pure returns (int24 tick) {
70         unchecked {
71             // second inequality must be < because the price can never reach the price at the max tick
72             if (!(sqrtPriceX96 >= MIN_SQRT_RATIO && sqrtPriceX96 < MAX_SQRT_RATIO)) revert R();
73             uint256 ratio = uint256(sqrtPriceX96) << 32;
74 
75             uint256 r = ratio;
76             uint256 msb = 0;
77 
78             assembly {
79                 let f := shl(7, gt(r, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF))
80                 msb := or(msb, f)
81                 r := shr(f, r)
82             }
83             assembly {
84                 let f := shl(6, gt(r, 0xFFFFFFFFFFFFFFFF))
85                 msb := or(msb, f)
86                 r := shr(f, r)
87             }
88             assembly {
89                 let f := shl(5, gt(r, 0xFFFFFFFF))
90                 msb := or(msb, f)
91                 r := shr(f, r)
92             }
93             assembly {
94                 let f := shl(4, gt(r, 0xFFFF))
95                 msb := or(msb, f)
96                 r := shr(f, r)
97             }
98             assembly {
99                 let f := shl(3, gt(r, 0xFF))
100                 msb := or(msb, f)
101                 r := shr(f, r)
102             }
103             assembly {
104                 let f := shl(2, gt(r, 0xF))
105                 msb := or(msb, f)
106                 r := shr(f, r)
107             }
108             assembly {
109                 let f := shl(1, gt(r, 0x3))
110                 msb := or(msb, f)
111                 r := shr(f, r)
112             }
113             assembly {
114                 let f := gt(r, 0x1)
115                 msb := or(msb, f)
116             }
117 
118             if (msb >= 128) r = ratio >> (msb - 127);
119             else r = ratio << (127 - msb);
120 
121             int256 log_2 = (int256(msb) - 128) << 64;
122 
123             assembly {
124                 r := shr(127, mul(r, r))
125                 let f := shr(128, r)
126                 log_2 := or(log_2, shl(63, f))
127                 r := shr(f, r)
128             }
129             assembly {
130                 r := shr(127, mul(r, r))
131                 let f := shr(128, r)
132                 log_2 := or(log_2, shl(62, f))
133                 r := shr(f, r)
134             }
135             assembly {
136                 r := shr(127, mul(r, r))
137                 let f := shr(128, r)
138                 log_2 := or(log_2, shl(61, f))
139                 r := shr(f, r)
140             }
141             assembly {
142                 r := shr(127, mul(r, r))
143                 let f := shr(128, r)
144                 log_2 := or(log_2, shl(60, f))
145                 r := shr(f, r)
146             }
147             assembly {
148                 r := shr(127, mul(r, r))
149                 let f := shr(128, r)
150                 log_2 := or(log_2, shl(59, f))
151                 r := shr(f, r)
152             }
153             assembly {
154                 r := shr(127, mul(r, r))
155                 let f := shr(128, r)
156                 log_2 := or(log_2, shl(58, f))
157                 r := shr(f, r)
158             }
159             assembly {
160                 r := shr(127, mul(r, r))
161                 let f := shr(128, r)
162                 log_2 := or(log_2, shl(57, f))
163                 r := shr(f, r)
164             }
165             assembly {
166                 r := shr(127, mul(r, r))
167                 let f := shr(128, r)
168                 log_2 := or(log_2, shl(56, f))
169                 r := shr(f, r)
170             }
171             assembly {
172                 r := shr(127, mul(r, r))
173                 let f := shr(128, r)
174                 log_2 := or(log_2, shl(55, f))
175                 r := shr(f, r)
176             }
177             assembly {
178                 r := shr(127, mul(r, r))
179                 let f := shr(128, r)
180                 log_2 := or(log_2, shl(54, f))
181                 r := shr(f, r)
182             }
183             assembly {
184                 r := shr(127, mul(r, r))
185                 let f := shr(128, r)
186                 log_2 := or(log_2, shl(53, f))
187                 r := shr(f, r)
188             }
189             assembly {
190                 r := shr(127, mul(r, r))
191                 let f := shr(128, r)
192                 log_2 := or(log_2, shl(52, f))
193                 r := shr(f, r)
194             }
195             assembly {
196                 r := shr(127, mul(r, r))
197                 let f := shr(128, r)
198                 log_2 := or(log_2, shl(51, f))
199                 r := shr(f, r)
200             }
201             assembly {
202                 r := shr(127, mul(r, r))
203                 let f := shr(128, r)
204                 log_2 := or(log_2, shl(50, f))
205             }
206 
207             int256 log_sqrt10001 = log_2 * 255738958999603826347141; // 128.128 number
208 
209             int24 tickLow = int24((log_sqrt10001 - 3402992956809132418596140100660247210) >> 128);
210             int24 tickHi = int24((log_sqrt10001 + 291339464771989622907027621153398088495) >> 128);
211 
212             tick = tickLow == tickHi ? tickLow : getSqrtRatioAtTick(tickHi) <= sqrtPriceX96 ? tickHi : tickLow;
213         }
214     }
215 }
216 
217 /// @title Contains 512-bit math functions
218 /// @notice Facilitates multiplication and division that can have overflow of an intermediate value without any loss of precision
219 /// @dev Handles "phantom overflow" i.e., allows multiplication and division where an intermediate value overflows 256 bits
220 library FullMath {
221     /// @notice Calculates floor(a×b÷denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
222     /// @param a The multiplicand
223     /// @param b The multiplier
224     /// @param denominator The divisor
225     /// @return result The 256-bit result
226     /// @dev Credit to Remco Bloemen under MIT license https://xn--2-umb.com/21/muldiv
227     function mulDiv(
228         uint256 a,
229         uint256 b,
230         uint256 denominator
231     ) internal pure returns (uint256 result) {
232         unchecked {
233             // 512-bit multiply [prod1 prod0] = a * b
234             // Compute the product mod 2**256 and mod 2**256 - 1
235             // then use the Chinese Remainder Theorem to reconstruct
236             // the 512 bit result. The result is stored in two 256
237             // variables such that product = prod1 * 2**256 + prod0
238             uint256 prod0; // Least significant 256 bits of the product
239             uint256 prod1; // Most significant 256 bits of the product
240             assembly {
241                 let mm := mulmod(a, b, not(0))
242                 prod0 := mul(a, b)
243                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
244             }
245 
246             // Handle non-overflow cases, 256 by 256 division
247             if (prod1 == 0) {
248                 require(denominator > 0);
249                 assembly {
250                     result := div(prod0, denominator)
251                 }
252                 return result;
253             }
254 
255             // Make sure the result is less than 2**256.
256             // Also prevents denominator == 0
257             require(denominator > prod1);
258 
259             ///////////////////////////////////////////////
260             // 512 by 256 division.
261             ///////////////////////////////////////////////
262 
263             // Make division exact by subtracting the remainder from [prod1 prod0]
264             // Compute remainder using mulmod
265             uint256 remainder;
266             assembly {
267                 remainder := mulmod(a, b, denominator)
268             }
269             // Subtract 256 bit number from 512 bit number
270             assembly {
271                 prod1 := sub(prod1, gt(remainder, prod0))
272                 prod0 := sub(prod0, remainder)
273             }
274 
275             // Factor powers of two out of denominator
276             // Compute largest power of two divisor of denominator.
277             // Always >= 1.
278             uint256 twos = (0 - denominator) & denominator;
279             // Divide denominator by power of two
280             assembly {
281                 denominator := div(denominator, twos)
282             }
283 
284             // Divide [prod1 prod0] by the factors of two
285             assembly {
286                 prod0 := div(prod0, twos)
287             }
288             // Shift in bits from prod1 into prod0. For this we need
289             // to flip `twos` such that it is 2**256 / twos.
290             // If twos is zero, then it becomes one
291             assembly {
292                 twos := add(div(sub(0, twos), twos), 1)
293             }
294             prod0 |= prod1 * twos;
295 
296             // Invert denominator mod 2**256
297             // Now that denominator is an odd number, it has an inverse
298             // modulo 2**256 such that denominator * inv = 1 mod 2**256.
299             // Compute the inverse by starting with a seed that is correct
300             // correct for four bits. That is, denominator * inv = 1 mod 2**4
301             uint256 inv = (3 * denominator) ^ 2;
302             // Now use Newton-Raphson iteration to improve the precision.
303             // Thanks to Hensel's lifting lemma, this also works in modular
304             // arithmetic, doubling the correct bits in each step.
305             inv *= 2 - denominator * inv; // inverse mod 2**8
306             inv *= 2 - denominator * inv; // inverse mod 2**16
307             inv *= 2 - denominator * inv; // inverse mod 2**32
308             inv *= 2 - denominator * inv; // inverse mod 2**64
309             inv *= 2 - denominator * inv; // inverse mod 2**128
310             inv *= 2 - denominator * inv; // inverse mod 2**256
311 
312             // Because the division is now exact we can divide by multiplying
313             // with the modular inverse of denominator. This will give us the
314             // correct result modulo 2**256. Since the precoditions guarantee
315             // that the outcome is less than 2**256, this is the final result.
316             // We don't need to compute the high bits of the result and prod1
317             // is no longer required.
318             result = prod0 * inv;
319             return result;
320         }
321     }
322 
323     /// @notice Calculates ceil(a×b÷denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
324     /// @param a The multiplicand
325     /// @param b The multiplier
326     /// @param denominator The divisor
327     /// @return result The 256-bit result
328     function mulDivRoundingUp(
329         uint256 a,
330         uint256 b,
331         uint256 denominator
332     ) internal pure returns (uint256 result) {
333         unchecked {
334             result = mulDiv(a, b, denominator);
335             if (mulmod(a, b, denominator) > 0) {
336                 require(result < type(uint256).max);
337                 result++;
338             }
339         }
340     }
341 }
342 
343 /// @title The interface for the Uniswap V3 Factory
344 /// @notice The Uniswap V3 Factory facilitates creation of Uniswap V3 pools and control over the protocol fees
345 interface IUniswapV3Factory {
346     /// @notice Emitted when the owner of the factory is changed
347     /// @param oldOwner The owner before the owner was changed
348     /// @param newOwner The owner after the owner was changed
349     event OwnerChanged(address indexed oldOwner, address indexed newOwner);
350 
351     /// @notice Emitted when a pool is created
352     /// @param token0 The first token of the pool by address sort order
353     /// @param token1 The second token of the pool by address sort order
354     /// @param fee The fee collected upon every swap in the pool, denominated in hundredths of a bip
355     /// @param tickSpacing The minimum number of ticks between initialized ticks
356     /// @param pool The address of the created pool
357     event PoolCreated(
358         address indexed token0,
359         address indexed token1,
360         uint24 indexed fee,
361         int24 tickSpacing,
362         address pool
363     );
364 
365     /// @notice Emitted when a new fee amount is enabled for pool creation via the factory
366     /// @param fee The enabled fee, denominated in hundredths of a bip
367     /// @param tickSpacing The minimum number of ticks between initialized ticks for pools created with the given fee
368     event FeeAmountEnabled(uint24 indexed fee, int24 indexed tickSpacing);
369 
370     /// @notice Returns the current owner of the factory
371     /// @dev Can be changed by the current owner via setOwner
372     /// @return The address of the factory owner
373     function owner() external view returns (address);
374 
375     /// @notice Returns the tick spacing for a given fee amount, if enabled, or 0 if not enabled
376     /// @dev A fee amount can never be removed, so this value should be hard coded or cached in the calling context
377     /// @param fee The enabled fee, denominated in hundredths of a bip. Returns 0 in case of unenabled fee
378     /// @return The tick spacing
379     function feeAmountTickSpacing(uint24 fee) external view returns (int24);
380 
381     /// @notice Returns the pool address for a given pair of tokens and a fee, or address 0 if it does not exist
382     /// @dev tokenA and tokenB may be passed in either token0/token1 or token1/token0 order
383     /// @param tokenA The contract address of either token0 or token1
384     /// @param tokenB The contract address of the other token
385     /// @param fee The fee collected upon every swap in the pool, denominated in hundredths of a bip
386     /// @return pool The pool address
387     function getPool(
388         address tokenA,
389         address tokenB,
390         uint24 fee
391     ) external view returns (address pool);
392 
393     /// @notice Creates a pool for the given two tokens and fee
394     /// @param tokenA One of the two tokens in the desired pool
395     /// @param tokenB The other of the two tokens in the desired pool
396     /// @param fee The desired fee for the pool
397     /// @dev tokenA and tokenB may be passed in either order: token0/token1 or token1/token0. tickSpacing is retrieved
398     /// from the fee. The call will revert if the pool already exists, the fee is invalid, or the token arguments
399     /// are invalid.
400     /// @return pool The address of the newly created pool
401     function createPool(
402         address tokenA,
403         address tokenB,
404         uint24 fee
405     ) external returns (address pool);
406 
407     /// @notice Updates the owner of the factory
408     /// @dev Must be called by the current owner
409     /// @param _owner The new owner of the factory
410     function setOwner(address _owner) external;
411 
412     /// @notice Enables a fee amount with the given tickSpacing
413     /// @dev Fee amounts may never be removed once enabled
414     /// @param fee The fee amount to enable, denominated in hundredths of a bip (i.e. 1e-6)
415     /// @param tickSpacing The spacing between ticks to be enforced for all pools created with the given fee amount
416     function enableFeeAmount(uint24 fee, int24 tickSpacing) external;
417 }
418 
419 pragma abicoder v2;
420 
421 /// @title Multicall interface
422 /// @notice Enables calling multiple methods in a single call to the contract
423 interface IMulticall {
424     /// @notice Call multiple functions in the current contract and return the data from all of them if they all succeed
425     /// @dev The `msg.value` should not be trusted for any method callable from multicall.
426     /// @param data The encoded function data for each of the calls to make to this contract
427     /// @return results The results from each of the calls passed in via data
428     function multicall(bytes[] calldata data) external payable returns (bytes[] memory results);
429 }
430 
431 /// @title Multicall
432 /// @notice Enables calling multiple methods in a single call to the contract
433 abstract contract Multicall is IMulticall {
434     /// @inheritdoc IMulticall
435     function multicall(bytes[] calldata data) public payable override returns (bytes[] memory results) {
436         results = new bytes[](data.length);
437         for (uint256 i = 0; i < data.length; i++) {
438             (bool success, bytes memory result) = address(this).delegatecall(data[i]);
439 
440             if (!success) {
441                 // Next 5 lines from https://ethereum.stackexchange.com/a/83577
442                 if (result.length < 68) revert();
443                 assembly {
444                     result := add(result, 0x04)
445                 }
446                 revert(abi.decode(result, (string)));
447             }
448 
449             results[i] = result;
450         }
451     }
452 }
453 
454 
455 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)
456 
457 /**
458  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
459  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
460  *
461  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
462  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
463  * need to send a transaction, and thus is not required to hold Ether at all.
464  */
465 interface IERC20Permit {
466     /**
467      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
468      * given ``owner``'s signed approval.
469      *
470      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
471      * ordering also apply here.
472      *
473      * Emits an {Approval} event.
474      *
475      * Requirements:
476      *
477      * - `spender` cannot be the zero address.
478      * - `deadline` must be a timestamp in the future.
479      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
480      * over the EIP712-formatted function arguments.
481      * - the signature must use ``owner``'s current nonce (see {nonces}).
482      *
483      * For more information on the signature format, see the
484      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
485      * section].
486      */
487     function permit(
488         address owner,
489         address spender,
490         uint256 value,
491         uint256 deadline,
492         uint8 v,
493         bytes32 r,
494         bytes32 s
495     ) external;
496 
497     /**
498      * @dev Returns the current nonce for `owner`. This value must be
499      * included whenever a signature is generated for {permit}.
500      *
501      * Every successful call to {permit} increases ``owner``'s nonce by one. This
502      * prevents a signature from being used multiple times.
503      */
504     function nonces(address owner) external view returns (uint256);
505 
506     /**
507      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
508      */
509     // solhint-disable-next-line func-name-mixedcase
510     function DOMAIN_SEPARATOR() external view returns (bytes32);
511 }
512 
513 /// @title Self Permit
514 /// @notice Functionality to call permit on any EIP-2612-compliant token for use in the route
515 interface ISelfPermit {
516     /// @notice Permits this contract to spend a given token from `msg.sender`
517     /// @dev The `owner` is always msg.sender and the `spender` is always address(this).
518     /// @param token The address of the token spent
519     /// @param value The amount that can be spent of token
520     /// @param deadline A timestamp, the current blocktime must be less than or equal to this timestamp
521     /// @param v Must produce valid secp256k1 signature from the holder along with `r` and `s`
522     /// @param r Must produce valid secp256k1 signature from the holder along with `v` and `s`
523     /// @param s Must produce valid secp256k1 signature from the holder along with `r` and `v`
524     function selfPermit(
525         address token,
526         uint256 value,
527         uint256 deadline,
528         uint8 v,
529         bytes32 r,
530         bytes32 s
531     ) external payable;
532 
533     /// @notice Permits this contract to spend a given token from `msg.sender`
534     /// @dev The `owner` is always msg.sender and the `spender` is always address(this).
535     /// Can be used instead of #selfPermit to prevent calls from failing due to a frontrun of a call to #selfPermit
536     /// @param token The address of the token spent
537     /// @param value The amount that can be spent of token
538     /// @param deadline A timestamp, the current blocktime must be less than or equal to this timestamp
539     /// @param v Must produce valid secp256k1 signature from the holder along with `r` and `s`
540     /// @param r Must produce valid secp256k1 signature from the holder along with `v` and `s`
541     /// @param s Must produce valid secp256k1 signature from the holder along with `r` and `v`
542     function selfPermitIfNecessary(
543         address token,
544         uint256 value,
545         uint256 deadline,
546         uint8 v,
547         bytes32 r,
548         bytes32 s
549     ) external payable;
550 
551     /// @notice Permits this contract to spend the sender's tokens for permit signatures that have the `allowed` parameter
552     /// @dev The `owner` is always msg.sender and the `spender` is always address(this)
553     /// @param token The address of the token spent
554     /// @param nonce The current nonce of the owner
555     /// @param expiry The timestamp at which the permit is no longer valid
556     /// @param v Must produce valid secp256k1 signature from the holder along with `r` and `s`
557     /// @param r Must produce valid secp256k1 signature from the holder along with `v` and `s`
558     /// @param s Must produce valid secp256k1 signature from the holder along with `r` and `v`
559     function selfPermitAllowed(
560         address token,
561         uint256 nonce,
562         uint256 expiry,
563         uint8 v,
564         bytes32 r,
565         bytes32 s
566     ) external payable;
567 
568     /// @notice Permits this contract to spend the sender's tokens for permit signatures that have the `allowed` parameter
569     /// @dev The `owner` is always msg.sender and the `spender` is always address(this)
570     /// Can be used instead of #selfPermitAllowed to prevent calls from failing due to a frontrun of a call to #selfPermitAllowed.
571     /// @param token The address of the token spent
572     /// @param nonce The current nonce of the owner
573     /// @param expiry The timestamp at which the permit is no longer valid
574     /// @param v Must produce valid secp256k1 signature from the holder along with `r` and `s`
575     /// @param r Must produce valid secp256k1 signature from the holder along with `v` and `s`
576     /// @param s Must produce valid secp256k1 signature from the holder along with `r` and `v`
577     function selfPermitAllowedIfNecessary(
578         address token,
579         uint256 nonce,
580         uint256 expiry,
581         uint8 v,
582         bytes32 r,
583         bytes32 s
584     ) external payable;
585 }
586 
587 /// @title Interface for permit
588 /// @notice Interface used by DAI/CHAI for permit
589 interface IERC20PermitAllowed {
590     /// @notice Approve the spender to spend some tokens via the holder signature
591     /// @dev This is the permit interface used by DAI and CHAI
592     /// @param holder The address of the token holder, the token owner
593     /// @param spender The address of the token spender
594     /// @param nonce The holder's nonce, increases at each call to permit
595     /// @param expiry The timestamp at which the permit is no longer valid
596     /// @param allowed Boolean that sets approval amount, true for type(uint256).max and false for 0
597     /// @param v Must produce valid secp256k1 signature from the holder along with `r` and `s`
598     /// @param r Must produce valid secp256k1 signature from the holder along with `v` and `s`
599     /// @param s Must produce valid secp256k1 signature from the holder along with `r` and `v`
600     function permit(
601         address holder,
602         address spender,
603         uint256 nonce,
604         uint256 expiry,
605         bool allowed,
606         uint8 v,
607         bytes32 r,
608         bytes32 s
609     ) external;
610 }
611 
612 /// @title Self Permit
613 /// @notice Functionality to call permit on any EIP-2612-compliant token for use in the route
614 /// @dev These functions are expected to be embedded in multicalls to allow EOAs to approve a contract and call a function
615 /// that requires an approval in a single transaction.
616 abstract contract SelfPermit is ISelfPermit {
617     /// @inheritdoc ISelfPermit
618     function selfPermit(
619         address token,
620         uint256 value,
621         uint256 deadline,
622         uint8 v,
623         bytes32 r,
624         bytes32 s
625     ) public payable override {
626         IERC20Permit(token).permit(msg.sender, address(this), value, deadline, v, r, s);
627     }
628 
629     /// @inheritdoc ISelfPermit
630     function selfPermitIfNecessary(
631         address token,
632         uint256 value,
633         uint256 deadline,
634         uint8 v,
635         bytes32 r,
636         bytes32 s
637     ) external payable override {
638         if (IERC20(token).allowance(msg.sender, address(this)) < value) selfPermit(token, value, deadline, v, r, s);
639     }
640 
641     /// @inheritdoc ISelfPermit
642     function selfPermitAllowed(
643         address token,
644         uint256 nonce,
645         uint256 expiry,
646         uint8 v,
647         bytes32 r,
648         bytes32 s
649     ) public payable override {
650         IERC20PermitAllowed(token).permit(msg.sender, address(this), nonce, expiry, true, v, r, s);
651     }
652 
653     /// @inheritdoc ISelfPermit
654     function selfPermitAllowedIfNecessary(
655         address token,
656         uint256 nonce,
657         uint256 expiry,
658         uint8 v,
659         bytes32 r,
660         bytes32 s
661     ) external payable override {
662         if (IERC20(token).allowance(msg.sender, address(this)) < type(uint256).max)
663             selfPermitAllowed(token, nonce, expiry, v, r, s);
664     }
665 }
666 
667 /// @title FixedPoint96
668 /// @notice A library for handling binary fixed point numbers, see https://en.wikipedia.org/wiki/Q_(number_format)
669 /// @dev Used in SqrtPriceMath.sol
670 library FixedPoint96 {
671     uint8 internal constant RESOLUTION = 96;
672     uint256 internal constant Q96 = 0x1000000000000000000000000;
673 }
674 
675 /// @title Liquidity amount functions
676 /// @notice Provides functions for computing liquidity amounts from token amounts and prices
677 library LiquidityAmounts {
678     /// @notice Downcasts uint256 to uint128
679     /// @param x The uint258 to be downcasted
680     /// @return y The passed value, downcasted to uint128
681     function toUint128(uint256 x) private pure returns (uint128 y) {
682         require((y = uint128(x)) == x);
683     }
684 
685     /// @notice Computes the amount of liquidity received for a given amount of token0 and price range
686     /// @dev Calculates amount0 * (sqrt(upper) * sqrt(lower)) / (sqrt(upper) - sqrt(lower))
687     /// @param sqrtRatioAX96 A sqrt price representing the first tick boundary
688     /// @param sqrtRatioBX96 A sqrt price representing the second tick boundary
689     /// @param amount0 The amount0 being sent in
690     /// @return liquidity The amount of returned liquidity
691     function getLiquidityForAmount0(
692         uint160 sqrtRatioAX96,
693         uint160 sqrtRatioBX96,
694         uint256 amount0
695     ) internal pure returns (uint128 liquidity) {
696         if (sqrtRatioAX96 > sqrtRatioBX96) (sqrtRatioAX96, sqrtRatioBX96) = (sqrtRatioBX96, sqrtRatioAX96);
697         uint256 intermediate = FullMath.mulDiv(sqrtRatioAX96, sqrtRatioBX96, FixedPoint96.Q96);
698         unchecked {
699             return toUint128(FullMath.mulDiv(amount0, intermediate, sqrtRatioBX96 - sqrtRatioAX96));
700         }
701     }
702 
703     /// @notice Computes the amount of liquidity received for a given amount of token1 and price range
704     /// @dev Calculates amount1 / (sqrt(upper) - sqrt(lower)).
705     /// @param sqrtRatioAX96 A sqrt price representing the first tick boundary
706     /// @param sqrtRatioBX96 A sqrt price representing the second tick boundary
707     /// @param amount1 The amount1 being sent in
708     /// @return liquidity The amount of returned liquidity
709     function getLiquidityForAmount1(
710         uint160 sqrtRatioAX96,
711         uint160 sqrtRatioBX96,
712         uint256 amount1
713     ) internal pure returns (uint128 liquidity) {
714         if (sqrtRatioAX96 > sqrtRatioBX96) (sqrtRatioAX96, sqrtRatioBX96) = (sqrtRatioBX96, sqrtRatioAX96);
715         unchecked {
716             return toUint128(FullMath.mulDiv(amount1, FixedPoint96.Q96, sqrtRatioBX96 - sqrtRatioAX96));
717         }
718     }
719 
720     /// @notice Computes the maximum amount of liquidity received for a given amount of token0, token1, the current
721     /// pool prices and the prices at the tick boundaries
722     /// @param sqrtRatioX96 A sqrt price representing the current pool prices
723     /// @param sqrtRatioAX96 A sqrt price representing the first tick boundary
724     /// @param sqrtRatioBX96 A sqrt price representing the second tick boundary
725     /// @param amount0 The amount of token0 being sent in
726     /// @param amount1 The amount of token1 being sent in
727     /// @return liquidity The maximum amount of liquidity received
728     function getLiquidityForAmounts(
729         uint160 sqrtRatioX96,
730         uint160 sqrtRatioAX96,
731         uint160 sqrtRatioBX96,
732         uint256 amount0,
733         uint256 amount1
734     ) internal pure returns (uint128 liquidity) {
735         if (sqrtRatioAX96 > sqrtRatioBX96) (sqrtRatioAX96, sqrtRatioBX96) = (sqrtRatioBX96, sqrtRatioAX96);
736 
737         if (sqrtRatioX96 <= sqrtRatioAX96) {
738             liquidity = getLiquidityForAmount0(sqrtRatioAX96, sqrtRatioBX96, amount0);
739         } else if (sqrtRatioX96 < sqrtRatioBX96) {
740             uint128 liquidity0 = getLiquidityForAmount0(sqrtRatioX96, sqrtRatioBX96, amount0);
741             uint128 liquidity1 = getLiquidityForAmount1(sqrtRatioAX96, sqrtRatioX96, amount1);
742 
743             liquidity = liquidity0 < liquidity1 ? liquidity0 : liquidity1;
744         } else {
745             liquidity = getLiquidityForAmount1(sqrtRatioAX96, sqrtRatioBX96, amount1);
746         }
747     }
748 
749     /// @notice Computes the amount of token0 for a given amount of liquidity and a price range
750     /// @param sqrtRatioAX96 A sqrt price representing the first tick boundary
751     /// @param sqrtRatioBX96 A sqrt price representing the second tick boundary
752     /// @param liquidity The liquidity being valued
753     /// @return amount0 The amount of token0
754     function getAmount0ForLiquidity(
755         uint160 sqrtRatioAX96,
756         uint160 sqrtRatioBX96,
757         uint128 liquidity
758     ) internal pure returns (uint256 amount0) {
759         unchecked {
760             if (sqrtRatioAX96 > sqrtRatioBX96) (sqrtRatioAX96, sqrtRatioBX96) = (sqrtRatioBX96, sqrtRatioAX96);
761 
762             return
763                 FullMath.mulDiv(
764                     uint256(liquidity) << FixedPoint96.RESOLUTION,
765                     sqrtRatioBX96 - sqrtRatioAX96,
766                     sqrtRatioBX96
767                 ) / sqrtRatioAX96;
768         }
769     }
770 
771     /// @notice Computes the amount of token1 for a given amount of liquidity and a price range
772     /// @param sqrtRatioAX96 A sqrt price representing the first tick boundary
773     /// @param sqrtRatioBX96 A sqrt price representing the second tick boundary
774     /// @param liquidity The liquidity being valued
775     /// @return amount1 The amount of token1
776     function getAmount1ForLiquidity(
777         uint160 sqrtRatioAX96,
778         uint160 sqrtRatioBX96,
779         uint128 liquidity
780     ) internal pure returns (uint256 amount1) {
781         if (sqrtRatioAX96 > sqrtRatioBX96) (sqrtRatioAX96, sqrtRatioBX96) = (sqrtRatioBX96, sqrtRatioAX96);
782 
783         unchecked {
784             return FullMath.mulDiv(liquidity, sqrtRatioBX96 - sqrtRatioAX96, FixedPoint96.Q96);
785         }
786     }
787 
788     /// @notice Computes the token0 and token1 value for a given amount of liquidity, the current
789     /// pool prices and the prices at the tick boundaries
790     /// @param sqrtRatioX96 A sqrt price representing the current pool prices
791     /// @param sqrtRatioAX96 A sqrt price representing the first tick boundary
792     /// @param sqrtRatioBX96 A sqrt price representing the second tick boundary
793     /// @param liquidity The liquidity being valued
794     /// @return amount0 The amount of token0
795     /// @return amount1 The amount of token1
796     function getAmountsForLiquidity(
797         uint160 sqrtRatioX96,
798         uint160 sqrtRatioAX96,
799         uint160 sqrtRatioBX96,
800         uint128 liquidity
801     ) internal pure returns (uint256 amount0, uint256 amount1) {
802         if (sqrtRatioAX96 > sqrtRatioBX96) (sqrtRatioAX96, sqrtRatioBX96) = (sqrtRatioBX96, sqrtRatioAX96);
803 
804         if (sqrtRatioX96 <= sqrtRatioAX96) {
805             amount0 = getAmount0ForLiquidity(sqrtRatioAX96, sqrtRatioBX96, liquidity);
806         } else if (sqrtRatioX96 < sqrtRatioBX96) {
807             amount0 = getAmount0ForLiquidity(sqrtRatioX96, sqrtRatioBX96, liquidity);
808             amount1 = getAmount1ForLiquidity(sqrtRatioAX96, sqrtRatioX96, liquidity);
809         } else {
810             amount1 = getAmount1ForLiquidity(sqrtRatioAX96, sqrtRatioBX96, liquidity);
811         }
812     }
813 }
814 
815 /// @notice Simple single owner authorization mixin.
816 /// @author Solmate (https://github.com/transmissions11/solmate/blob/main/src/auth/Owned.sol)
817 abstract contract Owned {
818     /*//////////////////////////////////////////////////////////////
819                                  EVENTS
820     //////////////////////////////////////////////////////////////*/
821 
822     event OwnerUpdated(address indexed user, address indexed newOwner);
823 
824     /*//////////////////////////////////////////////////////////////
825                             OWNERSHIP STORAGE
826     //////////////////////////////////////////////////////////////*/
827 
828     address public owner;
829 
830     modifier onlyOwner() virtual {
831         require(msg.sender == owner, "UNAUTHORIZED");
832 
833         _;
834     }
835 
836     /*//////////////////////////////////////////////////////////////
837                                CONSTRUCTOR
838     //////////////////////////////////////////////////////////////*/
839 
840     constructor(address _owner) {
841         owner = _owner;
842 
843         emit OwnerUpdated(address(0), _owner);
844     }
845 
846     /*//////////////////////////////////////////////////////////////
847                              OWNERSHIP LOGIC
848     //////////////////////////////////////////////////////////////*/
849 
850     function setOwner(address newOwner) public virtual onlyOwner {
851         owner = newOwner;
852 
853         emit OwnerUpdated(msg.sender, newOwner);
854     }
855 }
856 
857 /// @notice Library for converting between addresses and bytes32 values.
858 /// @author Solmate (https://github.com/transmissions11/solmate/blob/main/src/utils/Bytes32AddressLib.sol)
859 library Bytes32AddressLib {
860     function fromLast20Bytes(bytes32 bytesValue) internal pure returns (address) {
861         return address(uint160(uint256(bytesValue)));
862     }
863 
864     function fillLast12Bytes(address addressValue) internal pure returns (bytes32) {
865         return bytes32(bytes20(addressValue));
866     }
867 }
868 
869 /// @notice Deploy to deterministic addresses without an initcode factor.
870 /// @author Solmate (https://github.com/transmissions11/solmate/blob/main/src/utils/CREATE3.sol)
871 /// @author Modified from 0xSequence (https://github.com/0xSequence/create3/blob/master/contracts/Create3.sol)
872 library CREATE3 {
873     using Bytes32AddressLib for bytes32;
874 
875     //--------------------------------------------------------------------------------//
876     // Opcode     | Opcode + Arguments    | Description      | Stack View             //
877     //--------------------------------------------------------------------------------//
878     // 0x36       |  0x36                 | CALLDATASIZE     | size                   //
879     // 0x3d       |  0x3d                 | RETURNDATASIZE   | 0 size                 //
880     // 0x3d       |  0x3d                 | RETURNDATASIZE   | 0 0 size               //
881     // 0x37       |  0x37                 | CALLDATACOPY     |                        //
882     // 0x36       |  0x36                 | CALLDATASIZE     | size                   //
883     // 0x3d       |  0x3d                 | RETURNDATASIZE   | 0 size                 //
884     // 0x34       |  0x34                 | CALLVALUE        | value 0 size           //
885     // 0xf0       |  0xf0                 | CREATE           | newContract            //
886     //--------------------------------------------------------------------------------//
887     // Opcode     | Opcode + Arguments    | Description      | Stack View             //
888     //--------------------------------------------------------------------------------//
889     // 0x67       |  0x67XXXXXXXXXXXXXXXX | PUSH8 bytecode   | bytecode               //
890     // 0x3d       |  0x3d                 | RETURNDATASIZE   | 0 bytecode             //
891     // 0x52       |  0x52                 | MSTORE           |                        //
892     // 0x60       |  0x6008               | PUSH1 08         | 8                      //
893     // 0x60       |  0x6018               | PUSH1 18         | 24 8                   //
894     // 0xf3       |  0xf3                 | RETURN           |                        //
895     //--------------------------------------------------------------------------------//
896     bytes internal constant PROXY_BYTECODE = hex"67_36_3d_3d_37_36_3d_34_f0_3d_52_60_08_60_18_f3";
897 
898     bytes32 internal constant PROXY_BYTECODE_HASH = keccak256(PROXY_BYTECODE);
899 
900     function deploy(
901         bytes32 salt,
902         bytes memory creationCode,
903         uint256 value
904     ) internal returns (address deployed) {
905         bytes memory proxyChildBytecode = PROXY_BYTECODE;
906 
907         address proxy;
908         assembly {
909             // Deploy a new contract with our pre-made bytecode via CREATE2.
910             // We start 32 bytes into the code to avoid copying the byte length.
911             proxy := create2(0, add(proxyChildBytecode, 32), mload(proxyChildBytecode), salt)
912         }
913         require(proxy != address(0), "DEPLOYMENT_FAILED");
914 
915         deployed = getDeployed(salt);
916         (bool success, ) = proxy.call{value: value}(creationCode);
917         require(success && deployed.code.length != 0, "INITIALIZATION_FAILED");
918     }
919 
920     function getDeployed(bytes32 salt) internal view returns (address) {
921         address proxy = keccak256(
922             abi.encodePacked(
923                 // Prefix:
924                 bytes1(0xFF),
925                 // Creator:
926                 address(this),
927                 // Salt:
928                 salt,
929                 // Bytecode hash:
930                 PROXY_BYTECODE_HASH
931             )
932         ).fromLast20Bytes();
933 
934         return
935             keccak256(
936                 abi.encodePacked(
937                     // 0xd6 = 0xc0 (short RLP prefix) + 0x16 (length of: 0x94 ++ proxy ++ 0x01)
938                     // 0x94 = 0x80 + 0x14 (0x14 = the length of an address, 20 bytes, in hex)
939                     hex"d6_94",
940                     proxy,
941                     hex"01" // Nonce of the proxy contract (1)
942                 )
943             ).fromLast20Bytes();
944     }
945 }
946 
947 
948 /// @title Pool state that never changes
949 /// @notice These parameters are fixed for a pool forever, i.e., the methods will always return the same values
950 interface IUniswapV3PoolImmutables {
951     /// @notice The contract that deployed the pool, which must adhere to the IUniswapV3Factory interface
952     /// @return The contract address
953     function factory() external view returns (address);
954 
955     /// @notice The first of the two tokens of the pool, sorted by address
956     /// @return The token contract address
957     function token0() external view returns (address);
958 
959     /// @notice The second of the two tokens of the pool, sorted by address
960     /// @return The token contract address
961     function token1() external view returns (address);
962 
963     /// @notice The pool's fee in hundredths of a bip, i.e. 1e-6
964     /// @return The fee
965     function fee() external view returns (uint24);
966 
967     /// @notice The pool tick spacing
968     /// @dev Ticks can only be used at multiples of this value, minimum of 1 and always positive
969     /// e.g.: a tickSpacing of 3 means ticks can be initialized every 3rd tick, i.e., ..., -6, -3, 0, 3, 6, ...
970     /// This value is an int24 to avoid casting even though it is always positive.
971     /// @return The tick spacing
972     function tickSpacing() external view returns (int24);
973 
974     /// @notice The maximum amount of position liquidity that can use any tick in the range
975     /// @dev This parameter is enforced per tick to prevent liquidity from overflowing a uint128 at any point, and
976     /// also prevents out-of-range liquidity from being used to prevent adding in-range liquidity to a pool
977     /// @return The max amount of liquidity per tick
978     function maxLiquidityPerTick() external view returns (uint128);
979 }
980 
981 /// @title Pool state that can change
982 /// @notice These methods compose the pool's state, and can change with any frequency including multiple times
983 /// per transaction
984 interface IUniswapV3PoolState {
985     /// @notice The 0th storage slot in the pool stores many values, and is exposed as a single method to save gas
986     /// when accessed externally.
987     /// @return sqrtPriceX96 The current price of the pool as a sqrt(token1/token0) Q64.96 value
988     /// @return tick The current tick of the pool, i.e. according to the last tick transition that was run.
989     /// This value may not always be equal to SqrtTickMath.getTickAtSqrtRatio(sqrtPriceX96) if the price is on a tick
990     /// boundary.
991     /// @return observationIndex The index of the last oracle observation that was written,
992     /// @return observationCardinality The current maximum number of observations stored in the pool,
993     /// @return observationCardinalityNext The next maximum number of observations, to be updated when the observation.
994     /// @return feeProtocol The protocol fee for both tokens of the pool.
995     /// Encoded as two 4 bit values, where the protocol fee of token1 is shifted 4 bits and the protocol fee of token0
996     /// is the lower 4 bits. Used as the denominator of a fraction of the swap fee, e.g. 4 means 1/4th of the swap fee.
997     /// unlocked Whether the pool is currently locked to reentrancy
998     function slot0()
999         external
1000         view
1001         returns (
1002             uint160 sqrtPriceX96,
1003             int24 tick,
1004             uint16 observationIndex,
1005             uint16 observationCardinality,
1006             uint16 observationCardinalityNext,
1007             uint8 feeProtocol,
1008             bool unlocked
1009         );
1010 
1011     /// @notice The fee growth as a Q128.128 fees of token0 collected per unit of liquidity for the entire life of the pool
1012     /// @dev This value can overflow the uint256
1013     function feeGrowthGlobal0X128() external view returns (uint256);
1014 
1015     /// @notice The fee growth as a Q128.128 fees of token1 collected per unit of liquidity for the entire life of the pool
1016     /// @dev This value can overflow the uint256
1017     function feeGrowthGlobal1X128() external view returns (uint256);
1018 
1019     /// @notice The amounts of token0 and token1 that are owed to the protocol
1020     /// @dev Protocol fees will never exceed uint128 max in either token
1021     function protocolFees() external view returns (uint128 token0, uint128 token1);
1022 
1023     /// @notice The currently in range liquidity available to the pool
1024     /// @dev This value has no relationship to the total liquidity across all ticks
1025     /// @return The liquidity at the current price of the pool
1026     function liquidity() external view returns (uint128);
1027 
1028     /// @notice Look up information about a specific tick in the pool
1029     /// @param tick The tick to look up
1030     /// @return liquidityGross the total amount of position liquidity that uses the pool either as tick lower or
1031     /// tick upper
1032     /// @return liquidityNet how much liquidity changes when the pool price crosses the tick,
1033     /// @return feeGrowthOutside0X128 the fee growth on the other side of the tick from the current tick in token0,
1034     /// @return feeGrowthOutside1X128 the fee growth on the other side of the tick from the current tick in token1,
1035     /// @return tickCumulativeOutside the cumulative tick value on the other side of the tick from the current tick
1036     /// @return secondsPerLiquidityOutsideX128 the seconds spent per liquidity on the other side of the tick from the current tick,
1037     /// @return secondsOutside the seconds spent on the other side of the tick from the current tick,
1038     /// @return initialized Set to true if the tick is initialized, i.e. liquidityGross is greater than 0, otherwise equal to false.
1039     /// Outside values can only be used if the tick is initialized, i.e. if liquidityGross is greater than 0.
1040     /// In addition, these values are only relative and must be used only in comparison to previous snapshots for
1041     /// a specific position.
1042     function ticks(int24 tick)
1043         external
1044         view
1045         returns (
1046             uint128 liquidityGross,
1047             int128 liquidityNet,
1048             uint256 feeGrowthOutside0X128,
1049             uint256 feeGrowthOutside1X128,
1050             int56 tickCumulativeOutside,
1051             uint160 secondsPerLiquidityOutsideX128,
1052             uint32 secondsOutside,
1053             bool initialized
1054         );
1055 
1056     /// @notice Returns 256 packed tick initialized boolean values. See TickBitmap for more information
1057     function tickBitmap(int16 wordPosition) external view returns (uint256);
1058 
1059     /// @notice Returns the information about a position by the position's key
1060     /// @param key The position's key is a hash of a preimage composed by the owner, tickLower and tickUpper
1061     /// @return liquidity The amount of liquidity in the position,
1062     /// @return feeGrowthInside0LastX128 fee growth of token0 inside the tick range as of the last mint/burn/poke,
1063     /// @return feeGrowthInside1LastX128 fee growth of token1 inside the tick range as of the last mint/burn/poke,
1064     /// @return tokensOwed0 the computed amount of token0 owed to the position as of the last mint/burn/poke,
1065     /// @return tokensOwed1 the computed amount of token1 owed to the position as of the last mint/burn/poke
1066     function positions(bytes32 key)
1067         external
1068         view
1069         returns (
1070             uint128 liquidity,
1071             uint256 feeGrowthInside0LastX128,
1072             uint256 feeGrowthInside1LastX128,
1073             uint128 tokensOwed0,
1074             uint128 tokensOwed1
1075         );
1076 
1077     /// @notice Returns data about a specific observation index
1078     /// @param index The element of the observations array to fetch
1079     /// @dev You most likely want to use #observe() instead of this method to get an observation as of some amount of time
1080     /// ago, rather than at a specific index in the array.
1081     /// @return blockTimestamp The timestamp of the observation,
1082     /// @return tickCumulative the tick multiplied by seconds elapsed for the life of the pool as of the observation timestamp,
1083     /// @return secondsPerLiquidityCumulativeX128 the seconds per in range liquidity for the life of the pool as of the observation timestamp,
1084     /// @return initialized whether the observation has been initialized and the values are safe to use
1085     function observations(uint256 index)
1086         external
1087         view
1088         returns (
1089             uint32 blockTimestamp,
1090             int56 tickCumulative,
1091             uint160 secondsPerLiquidityCumulativeX128,
1092             bool initialized
1093         );
1094 }
1095 
1096 /// @title Pool state that is not stored
1097 /// @notice Contains view functions to provide information about the pool that is computed rather than stored on the
1098 /// blockchain. The functions here may have variable gas costs.
1099 interface IUniswapV3PoolDerivedState {
1100     /// @notice Returns the cumulative tick and liquidity as of each timestamp `secondsAgo` from the current block timestamp
1101     /// @dev To get a time weighted average tick or liquidity-in-range, you must call this with two values, one representing
1102     /// the beginning of the period and another for the end of the period. E.g., to get the last hour time-weighted average tick,
1103     /// you must call it with secondsAgos = [3600, 0].
1104     /// @dev The time weighted average tick represents the geometric time weighted average price of the pool, in
1105     /// log base sqrt(1.0001) of token1 / token0. The TickMath library can be used to go from a tick value to a ratio.
1106     /// @param secondsAgos From how long ago each cumulative tick and liquidity value should be returned
1107     /// @return tickCumulatives Cumulative tick values as of each `secondsAgos` from the current block timestamp
1108     /// @return secondsPerLiquidityCumulativeX128s Cumulative seconds per liquidity-in-range value as of each `secondsAgos` from the current block
1109     /// timestamp
1110     function observe(uint32[] calldata secondsAgos)
1111         external
1112         view
1113         returns (int56[] memory tickCumulatives, uint160[] memory secondsPerLiquidityCumulativeX128s);
1114 
1115     /// @notice Returns a snapshot of the tick cumulative, seconds per liquidity and seconds inside a tick range
1116     /// @dev Snapshots must only be compared to other snapshots, taken over a period for which a position existed.
1117     /// I.e., snapshots cannot be compared if a position is not held for the entire period between when the first
1118     /// snapshot is taken and the second snapshot is taken.
1119     /// @param tickLower The lower tick of the range
1120     /// @param tickUpper The upper tick of the range
1121     /// @return tickCumulativeInside The snapshot of the tick accumulator for the range
1122     /// @return secondsPerLiquidityInsideX128 The snapshot of seconds per liquidity for the range
1123     /// @return secondsInside The snapshot of seconds per liquidity for the range
1124     function snapshotCumulativesInside(int24 tickLower, int24 tickUpper)
1125         external
1126         view
1127         returns (
1128             int56 tickCumulativeInside,
1129             uint160 secondsPerLiquidityInsideX128,
1130             uint32 secondsInside
1131         );
1132 }
1133 
1134 /// @title Permissionless pool actions
1135 /// @notice Contains pool methods that can be called by anyone
1136 interface IUniswapV3PoolActions {
1137     /// @notice Sets the initial price for the pool
1138     /// @dev Price is represented as a sqrt(amountToken1/amountToken0) Q64.96 value
1139     /// @param sqrtPriceX96 the initial sqrt price of the pool as a Q64.96
1140     function initialize(uint160 sqrtPriceX96) external;
1141 
1142     /// @notice Adds liquidity for the given recipient/tickLower/tickUpper position
1143     /// @dev The caller of this method receives a callback in the form of IUniswapV3MintCallback#uniswapV3MintCallback
1144     /// in which they must pay any token0 or token1 owed for the liquidity. The amount of token0/token1 due depends
1145     /// on tickLower, tickUpper, the amount of liquidity, and the current price.
1146     /// @param recipient The address for which the liquidity will be created
1147     /// @param tickLower The lower tick of the position in which to add liquidity
1148     /// @param tickUpper The upper tick of the position in which to add liquidity
1149     /// @param amount The amount of liquidity to mint
1150     /// @param data Any data that should be passed through to the callback
1151     /// @return amount0 The amount of token0 that was paid to mint the given amount of liquidity. Matches the value in the callback
1152     /// @return amount1 The amount of token1 that was paid to mint the given amount of liquidity. Matches the value in the callback
1153     function mint(
1154         address recipient,
1155         int24 tickLower,
1156         int24 tickUpper,
1157         uint128 amount,
1158         bytes calldata data
1159     ) external returns (uint256 amount0, uint256 amount1);
1160 
1161     /// @notice Collects tokens owed to a position
1162     /// @dev Does not recompute fees earned, which must be done either via mint or burn of any amount of liquidity.
1163     /// Collect must be called by the position owner. To withdraw only token0 or only token1, amount0Requested or
1164     /// amount1Requested may be set to zero. To withdraw all tokens owed, caller may pass any value greater than the
1165     /// actual tokens owed, e.g. type(uint128).max. Tokens owed may be from accumulated swap fees or burned liquidity.
1166     /// @param recipient The address which should receive the fees collected
1167     /// @param tickLower The lower tick of the position for which to collect fees
1168     /// @param tickUpper The upper tick of the position for which to collect fees
1169     /// @param amount0Requested How much token0 should be withdrawn from the fees owed
1170     /// @param amount1Requested How much token1 should be withdrawn from the fees owed
1171     /// @return amount0 The amount of fees collected in token0
1172     /// @return amount1 The amount of fees collected in token1
1173     function collect(
1174         address recipient,
1175         int24 tickLower,
1176         int24 tickUpper,
1177         uint128 amount0Requested,
1178         uint128 amount1Requested
1179     ) external returns (uint128 amount0, uint128 amount1);
1180 
1181     /// @notice Burn liquidity from the sender and account tokens owed for the liquidity to the position
1182     /// @dev Can be used to trigger a recalculation of fees owed to a position by calling with an amount of 0
1183     /// @dev Fees must be collected separately via a call to #collect
1184     /// @param tickLower The lower tick of the position for which to burn liquidity
1185     /// @param tickUpper The upper tick of the position for which to burn liquidity
1186     /// @param amount How much liquidity to burn
1187     /// @return amount0 The amount of token0 sent to the recipient
1188     /// @return amount1 The amount of token1 sent to the recipient
1189     function burn(
1190         int24 tickLower,
1191         int24 tickUpper,
1192         uint128 amount
1193     ) external returns (uint256 amount0, uint256 amount1);
1194 
1195     /// @notice Swap token0 for token1, or token1 for token0
1196     /// @dev The caller of this method receives a callback in the form of IUniswapV3SwapCallback#uniswapV3SwapCallback
1197     /// @param recipient The address to receive the output of the swap
1198     /// @param zeroForOne The direction of the swap, true for token0 to token1, false for token1 to token0
1199     /// @param amountSpecified The amount of the swap, which implicitly configures the swap as exact input (positive), or exact output (negative)
1200     /// @param sqrtPriceLimitX96 The Q64.96 sqrt price limit. If zero for one, the price cannot be less than this
1201     /// value after the swap. If one for zero, the price cannot be greater than this value after the swap
1202     /// @param data Any data to be passed through to the callback
1203     /// @return amount0 The delta of the balance of token0 of the pool, exact when negative, minimum when positive
1204     /// @return amount1 The delta of the balance of token1 of the pool, exact when negative, minimum when positive
1205     function swap(
1206         address recipient,
1207         bool zeroForOne,
1208         int256 amountSpecified,
1209         uint160 sqrtPriceLimitX96,
1210         bytes calldata data
1211     ) external returns (int256 amount0, int256 amount1);
1212 
1213     /// @notice Receive token0 and/or token1 and pay it back, plus a fee, in the callback
1214     /// @dev The caller of this method receives a callback in the form of IUniswapV3FlashCallback#uniswapV3FlashCallback
1215     /// @dev Can be used to donate underlying tokens pro-rata to currently in-range liquidity providers by calling
1216     /// with 0 amount{0,1} and sending the donation amount(s) from the callback
1217     /// @param recipient The address which will receive the token0 and token1 amounts
1218     /// @param amount0 The amount of token0 to send
1219     /// @param amount1 The amount of token1 to send
1220     /// @param data Any data to be passed through to the callback
1221     function flash(
1222         address recipient,
1223         uint256 amount0,
1224         uint256 amount1,
1225         bytes calldata data
1226     ) external;
1227 
1228     /// @notice Increase the maximum number of price and liquidity observations that this pool will store
1229     /// @dev This method is no-op if the pool already has an observationCardinalityNext greater than or equal to
1230     /// the input observationCardinalityNext.
1231     /// @param observationCardinalityNext The desired minimum number of observations for the pool to store
1232     function increaseObservationCardinalityNext(uint16 observationCardinalityNext) external;
1233 }
1234 
1235 /// @title Permissioned pool actions
1236 /// @notice Contains pool methods that may only be called by the factory owner
1237 interface IUniswapV3PoolOwnerActions {
1238     /// @notice Set the denominator of the protocol's % share of the fees
1239     /// @param feeProtocol0 new protocol fee for token0 of the pool
1240     /// @param feeProtocol1 new protocol fee for token1 of the pool
1241     function setFeeProtocol(uint8 feeProtocol0, uint8 feeProtocol1) external;
1242 
1243     /// @notice Collect the protocol fee accrued to the pool
1244     /// @param recipient The address to which collected protocol fees should be sent
1245     /// @param amount0Requested The maximum amount of token0 to send, can be 0 to collect fees in only token1
1246     /// @param amount1Requested The maximum amount of token1 to send, can be 0 to collect fees in only token0
1247     /// @return amount0 The protocol fee collected in token0
1248     /// @return amount1 The protocol fee collected in token1
1249     function collectProtocol(
1250         address recipient,
1251         uint128 amount0Requested,
1252         uint128 amount1Requested
1253     ) external returns (uint128 amount0, uint128 amount1);
1254 }
1255 
1256 /// @title Errors emitted by a pool
1257 /// @notice Contains all events emitted by the pool
1258 interface IUniswapV3PoolErrors {
1259     error LOK();
1260     error TLU();
1261     error TLM();
1262     error TUM();
1263     error AI();
1264     error M0();
1265     error M1();
1266     error AS();
1267     error IIA();
1268     error L();
1269     error F0();
1270     error F1();
1271 }
1272 
1273 /// @title Events emitted by a pool
1274 /// @notice Contains all events emitted by the pool
1275 interface IUniswapV3PoolEvents {
1276     /// @notice Emitted exactly once by a pool when #initialize is first called on the pool
1277     /// @dev Mint/Burn/Swap cannot be emitted by the pool before Initialize
1278     /// @param sqrtPriceX96 The initial sqrt price of the pool, as a Q64.96
1279     /// @param tick The initial tick of the pool, i.e. log base 1.0001 of the starting price of the pool
1280     event Initialize(uint160 sqrtPriceX96, int24 tick);
1281 
1282     /// @notice Emitted when liquidity is minted for a given position
1283     /// @param sender The address that minted the liquidity
1284     /// @param owner The owner of the position and recipient of any minted liquidity
1285     /// @param tickLower The lower tick of the position
1286     /// @param tickUpper The upper tick of the position
1287     /// @param amount The amount of liquidity minted to the position range
1288     /// @param amount0 How much token0 was required for the minted liquidity
1289     /// @param amount1 How much token1 was required for the minted liquidity
1290     event Mint(
1291         address sender,
1292         address indexed owner,
1293         int24 indexed tickLower,
1294         int24 indexed tickUpper,
1295         uint128 amount,
1296         uint256 amount0,
1297         uint256 amount1
1298     );
1299 
1300     /// @notice Emitted when fees are collected by the owner of a position
1301     /// @dev Collect events may be emitted with zero amount0 and amount1 when the caller chooses not to collect fees
1302     /// @param owner The owner of the position for which fees are collected
1303     /// @param tickLower The lower tick of the position
1304     /// @param tickUpper The upper tick of the position
1305     /// @param amount0 The amount of token0 fees collected
1306     /// @param amount1 The amount of token1 fees collected
1307     event Collect(
1308         address indexed owner,
1309         address recipient,
1310         int24 indexed tickLower,
1311         int24 indexed tickUpper,
1312         uint128 amount0,
1313         uint128 amount1
1314     );
1315 
1316     /// @notice Emitted when a position's liquidity is removed
1317     /// @dev Does not withdraw any fees earned by the liquidity position, which must be withdrawn via #collect
1318     /// @param owner The owner of the position for which liquidity is removed
1319     /// @param tickLower The lower tick of the position
1320     /// @param tickUpper The upper tick of the position
1321     /// @param amount The amount of liquidity to remove
1322     /// @param amount0 The amount of token0 withdrawn
1323     /// @param amount1 The amount of token1 withdrawn
1324     event Burn(
1325         address indexed owner,
1326         int24 indexed tickLower,
1327         int24 indexed tickUpper,
1328         uint128 amount,
1329         uint256 amount0,
1330         uint256 amount1
1331     );
1332 
1333     /// @notice Emitted by the pool for any swaps between token0 and token1
1334     /// @param sender The address that initiated the swap call, and that received the callback
1335     /// @param recipient The address that received the output of the swap
1336     /// @param amount0 The delta of the token0 balance of the pool
1337     /// @param amount1 The delta of the token1 balance of the pool
1338     /// @param sqrtPriceX96 The sqrt(price) of the pool after the swap, as a Q64.96
1339     /// @param liquidity The liquidity of the pool after the swap
1340     /// @param tick The log base 1.0001 of price of the pool after the swap
1341     event Swap(
1342         address indexed sender,
1343         address indexed recipient,
1344         int256 amount0,
1345         int256 amount1,
1346         uint160 sqrtPriceX96,
1347         uint128 liquidity,
1348         int24 tick
1349     );
1350 
1351     /// @notice Emitted by the pool for any flashes of token0/token1
1352     /// @param sender The address that initiated the swap call, and that received the callback
1353     /// @param recipient The address that received the tokens from flash
1354     /// @param amount0 The amount of token0 that was flashed
1355     /// @param amount1 The amount of token1 that was flashed
1356     /// @param paid0 The amount of token0 paid for the flash, which can exceed the amount0 plus the fee
1357     /// @param paid1 The amount of token1 paid for the flash, which can exceed the amount1 plus the fee
1358     event Flash(
1359         address indexed sender,
1360         address indexed recipient,
1361         uint256 amount0,
1362         uint256 amount1,
1363         uint256 paid0,
1364         uint256 paid1
1365     );
1366 
1367     /// @notice Emitted by the pool for increases to the number of observations that can be stored
1368     /// @dev observationCardinalityNext is not the observation cardinality until an observation is written at the index
1369     /// just before a mint/swap/burn.
1370     /// @param observationCardinalityNextOld The previous value of the next observation cardinality
1371     /// @param observationCardinalityNextNew The updated value of the next observation cardinality
1372     event IncreaseObservationCardinalityNext(
1373         uint16 observationCardinalityNextOld,
1374         uint16 observationCardinalityNextNew
1375     );
1376 
1377     /// @notice Emitted when the protocol fee is changed by the pool
1378     /// @param feeProtocol0Old The previous value of the token0 protocol fee
1379     /// @param feeProtocol1Old The previous value of the token1 protocol fee
1380     /// @param feeProtocol0New The updated value of the token0 protocol fee
1381     /// @param feeProtocol1New The updated value of the token1 protocol fee
1382     event SetFeeProtocol(uint8 feeProtocol0Old, uint8 feeProtocol1Old, uint8 feeProtocol0New, uint8 feeProtocol1New);
1383 
1384     /// @notice Emitted when the collected protocol fees are withdrawn by the factory owner
1385     /// @param sender The address that collects the protocol fees
1386     /// @param recipient The address that receives the collected protocol fees
1387     /// @param amount0 The amount of token0 protocol fees that is withdrawn
1388     /// @param amount0 The amount of token1 protocol fees that is withdrawn
1389     event CollectProtocol(address indexed sender, address indexed recipient, uint128 amount0, uint128 amount1);
1390 }
1391 
1392 /// @title The interface for a Uniswap V3 Pool
1393 /// @notice A Uniswap pool facilitates swapping and automated market making between any two assets that strictly conform
1394 /// to the ERC20 specification
1395 /// @dev The pool interface is broken up into many smaller pieces
1396 interface IUniswapV3Pool is
1397     IUniswapV3PoolImmutables,
1398     IUniswapV3PoolState,
1399     IUniswapV3PoolDerivedState,
1400     IUniswapV3PoolActions,
1401     IUniswapV3PoolOwnerActions,
1402     IUniswapV3PoolErrors,
1403     IUniswapV3PoolEvents
1404 {
1405 
1406 }
1407 
1408 /// @param pool The Uniswap V3 pool
1409 /// @param tickLower The lower tick of the Bunni's UniV3 LP position
1410 /// @param tickUpper The upper tick of the Bunni's UniV3 LP position
1411 struct BunniKey {
1412     IUniswapV3Pool pool;
1413     int24 tickLower;
1414     int24 tickUpper;
1415 }
1416 
1417 /**
1418  * @dev Interface of the ERC20 standard as defined in the EIP.
1419  * Modified from OpenZeppelin's IERC20 contract
1420  */
1421 interface IERC20 {
1422     /**
1423      * @dev Returns the amount of tokens in existence.
1424      */
1425     function totalSupply() external view returns (uint256);
1426 
1427     /**
1428      * @dev Returns the amount of tokens owned by `account`.
1429      */
1430     function balanceOf(address account) external view returns (uint256);
1431 
1432     /**
1433      * @dev Moves `amount` tokens from the caller's account to `recipient`.
1434      *
1435      * Returns a boolean value indicating whether the operation succeeded.
1436      *
1437      * Emits a {Transfer} event.
1438      */
1439     function transfer(address recipient, uint256 amount)
1440         external
1441         returns (bool);
1442 
1443     /**
1444      * @dev Returns the remaining number of tokens that `spender` will be
1445      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1446      * zero by default.
1447      *
1448      * This value changes when {approve} or {transferFrom} are called.
1449      */
1450     function allowance(address owner, address spender)
1451         external
1452         view
1453         returns (uint256);
1454 
1455     /**
1456      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1457      *
1458      * Returns a boolean value indicating whether the operation succeeded.
1459      *
1460      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1461      * that someone may use both the old and the new allowance by unfortunate
1462      * transaction ordering. One possible solution to mitigate this race
1463      * condition is to first reduce the spender's allowance to 0 and set the
1464      * desired value afterwards:
1465      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1466      *
1467      * Emits an {Approval} event.
1468      */
1469     function approve(address spender, uint256 amount) external returns (bool);
1470 
1471     /**
1472      * @dev Moves `amount` tokens from `sender` to `recipient` using the
1473      * allowance mechanism. `amount` is then deducted from the caller's
1474      * allowance.
1475      *
1476      * Returns a boolean value indicating whether the operation succeeded.
1477      *
1478      * Emits a {Transfer} event.
1479      */
1480     function transferFrom(
1481         address sender,
1482         address recipient,
1483         uint256 amount
1484     ) external returns (bool);
1485 
1486     /**
1487      * @return The name of the token
1488      */
1489     function name() external view returns (string memory);
1490 
1491     /**
1492      * @return The symbol of the token
1493      */
1494     function symbol() external view returns (string memory);
1495 
1496     /**
1497      * @return The number of decimal places the token has
1498      */
1499     function decimals() external view returns (uint8);
1500 
1501     function nonces(address account) external view returns (uint256);
1502 
1503     function permit(
1504         address owner,
1505         address spender,
1506         uint256 value,
1507         uint256 deadline,
1508         uint8 v,
1509         bytes32 r,
1510         bytes32 s
1511     ) external;
1512 
1513     function DOMAIN_SEPARATOR() external view returns (bytes32);
1514 
1515     /**
1516      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1517      * another (`to`).
1518      *
1519      * Note that `value` may be zero.
1520      */
1521     event Transfer(address indexed from, address indexed to, uint256 value);
1522 
1523     /**
1524      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1525      * a call to {approve}. `value` is the new allowance.
1526      */
1527     event Approval(
1528         address indexed owner,
1529         address indexed spender,
1530         uint256 value
1531     );
1532 }
1533 
1534 /// @notice Modern and gas efficient ERC20 + EIP-2612 implementation.
1535 /// @author Solmate (https://github.com/transmissions11/solmate/blob/main/src/tokens/ERC20.sol)
1536 /// @author Modified from Uniswap (https://github.com/Uniswap/uniswap-v2-core/blob/master/contracts/UniswapV2ERC20.sol)
1537 /// @dev Do not manually set balances without updating totalSupply, as the sum of all user balances must not exceed it.
1538 abstract contract ERC20 is IERC20 {
1539     /*//////////////////////////////////////////////////////////////
1540                             METADATA STORAGE
1541     //////////////////////////////////////////////////////////////*/
1542 
1543     string public override name;
1544 
1545     string public override symbol;
1546 
1547     uint8 public immutable override decimals;
1548 
1549     /*//////////////////////////////////////////////////////////////
1550                               ERC20 STORAGE
1551     //////////////////////////////////////////////////////////////*/
1552 
1553     uint256 public override totalSupply;
1554 
1555     mapping(address => uint256) public override balanceOf;
1556 
1557     mapping(address => mapping(address => uint256)) public override allowance;
1558 
1559     /*//////////////////////////////////////////////////////////////
1560                             EIP-2612 STORAGE
1561     //////////////////////////////////////////////////////////////*/
1562 
1563     uint256 internal immutable INITIAL_CHAIN_ID;
1564 
1565     bytes32 internal immutable INITIAL_DOMAIN_SEPARATOR;
1566 
1567     mapping(address => uint256) public override nonces;
1568 
1569     /*//////////////////////////////////////////////////////////////
1570                                CONSTRUCTOR
1571     //////////////////////////////////////////////////////////////*/
1572 
1573     constructor(
1574         string memory _name,
1575         string memory _symbol,
1576         uint8 _decimals
1577     ) {
1578         name = _name;
1579         symbol = _symbol;
1580         decimals = _decimals;
1581 
1582         INITIAL_CHAIN_ID = block.chainid;
1583         INITIAL_DOMAIN_SEPARATOR = computeDomainSeparator();
1584     }
1585 
1586     /*//////////////////////////////////////////////////////////////
1587                                ERC20 LOGIC
1588     //////////////////////////////////////////////////////////////*/
1589 
1590     function approve(address spender, uint256 amount)
1591         public
1592         virtual
1593         override
1594         returns (bool)
1595     {
1596         allowance[msg.sender][spender] = amount;
1597 
1598         emit Approval(msg.sender, spender, amount);
1599 
1600         return true;
1601     }
1602 
1603     function transfer(address to, uint256 amount)
1604         public
1605         virtual
1606         override
1607         returns (bool)
1608     {
1609         balanceOf[msg.sender] -= amount;
1610 
1611         // Cannot overflow because the sum of all user
1612         // balances can't exceed the max uint256 value.
1613         unchecked {
1614             balanceOf[to] += amount;
1615         }
1616 
1617         emit Transfer(msg.sender, to, amount);
1618 
1619         return true;
1620     }
1621 
1622     function transferFrom(
1623         address from,
1624         address to,
1625         uint256 amount
1626     ) public virtual override returns (bool) {
1627         uint256 allowed = allowance[from][msg.sender]; // Saves gas for limited approvals.
1628 
1629         if (allowed != type(uint256).max)
1630             allowance[from][msg.sender] = allowed - amount;
1631 
1632         balanceOf[from] -= amount;
1633 
1634         // Cannot overflow because the sum of all user
1635         // balances can't exceed the max uint256 value.
1636         unchecked {
1637             balanceOf[to] += amount;
1638         }
1639 
1640         emit Transfer(from, to, amount);
1641 
1642         return true;
1643     }
1644 
1645     /*//////////////////////////////////////////////////////////////
1646                              EIP-2612 LOGIC
1647     //////////////////////////////////////////////////////////////*/
1648 
1649     function permit(
1650         address owner,
1651         address spender,
1652         uint256 value,
1653         uint256 deadline,
1654         uint8 v,
1655         bytes32 r,
1656         bytes32 s
1657     ) public virtual override {
1658         require(deadline >= block.timestamp, "PERMIT_DEADLINE_EXPIRED");
1659 
1660         // Unchecked because the only math done is incrementing
1661         // the owner's nonce which cannot realistically overflow.
1662         unchecked {
1663             address recoveredAddress = ecrecover(
1664                 keccak256(
1665                     abi.encodePacked(
1666                         "\x19\x01",
1667                         DOMAIN_SEPARATOR(),
1668                         keccak256(
1669                             abi.encode(
1670                                 keccak256(
1671                                     "Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)"
1672                                 ),
1673                                 owner,
1674                                 spender,
1675                                 value,
1676                                 nonces[owner]++,
1677                                 deadline
1678                             )
1679                         )
1680                     )
1681                 ),
1682                 v,
1683                 r,
1684                 s
1685             );
1686 
1687             require(
1688                 recoveredAddress != address(0) && recoveredAddress == owner,
1689                 "INVALID_SIGNER"
1690             );
1691 
1692             allowance[recoveredAddress][spender] = value;
1693         }
1694 
1695         emit Approval(owner, spender, value);
1696     }
1697 
1698     function DOMAIN_SEPARATOR() public view virtual override returns (bytes32) {
1699         return
1700             block.chainid == INITIAL_CHAIN_ID
1701                 ? INITIAL_DOMAIN_SEPARATOR
1702                 : computeDomainSeparator();
1703     }
1704 
1705     function computeDomainSeparator() internal view virtual returns (bytes32) {
1706         return
1707             keccak256(
1708                 abi.encode(
1709                     keccak256(
1710                         "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
1711                     ),
1712                     keccak256(bytes(name)),
1713                     keccak256("1"),
1714                     block.chainid,
1715                     address(this)
1716                 )
1717             );
1718     }
1719 
1720     /*//////////////////////////////////////////////////////////////
1721                         INTERNAL MINT/BURN LOGIC
1722     //////////////////////////////////////////////////////////////*/
1723 
1724     function _mint(address to, uint256 amount) internal virtual {
1725         totalSupply += amount;
1726 
1727         // Cannot overflow because the sum of all user
1728         // balances can't exceed the max uint256 value.
1729         unchecked {
1730             balanceOf[to] += amount;
1731         }
1732 
1733         emit Transfer(address(0), to, amount);
1734     }
1735 
1736     function _burn(address from, uint256 amount) internal virtual {
1737         balanceOf[from] -= amount;
1738 
1739         // Cannot underflow because a user's balance
1740         // will never be larger than the total supply.
1741         unchecked {
1742             totalSupply -= amount;
1743         }
1744 
1745         emit Transfer(from, address(0), amount);
1746     }
1747 }
1748 
1749 
1750 /// @title BunniToken
1751 /// @author zefram.eth
1752 /// @notice ERC20 token that represents a user's LP position
1753 interface IBunniToken is IERC20 {
1754     function pool() external view returns (IUniswapV3Pool);
1755 
1756     function tickLower() external view returns (int24);
1757 
1758     function tickUpper() external view returns (int24);
1759 
1760     function hub() external view returns (IBunniHub);
1761 
1762     function mint(address to, uint256 amount) external;
1763 
1764     function burn(address from, uint256 amount) external;
1765 }
1766 
1767 /// @title Callback for IUniswapV3PoolActions#mint
1768 /// @notice Any contract that calls IUniswapV3PoolActions#mint must implement this interface
1769 interface IUniswapV3MintCallback {
1770     /// @notice Called to `msg.sender` after minting liquidity to a position from IUniswapV3Pool#mint.
1771     /// @dev In the implementation you must pay the pool tokens owed for the minted liquidity.
1772     /// The caller of this method must be checked to be a UniswapV3Pool deployed by the canonical UniswapV3Factory.
1773     /// @param amount0Owed The amount of token0 due to the pool for the minted liquidity
1774     /// @param amount1Owed The amount of token1 due to the pool for the minted liquidity
1775     /// @param data Any data passed through by the caller via the IUniswapV3PoolActions#mint call
1776     function uniswapV3MintCallback(
1777         uint256 amount0Owed,
1778         uint256 amount1Owed,
1779         bytes calldata data
1780     ) external;
1781 }
1782 
1783 /// @title Liquidity management functions
1784 /// @notice Internal functions for safely managing liquidity in Uniswap V3
1785 interface ILiquidityManagement is IUniswapV3MintCallback {
1786     function factory() external view returns (IUniswapV3Factory);
1787 }
1788 
1789 /// @title BunniHub
1790 /// @author zefram.eth
1791 /// @notice The main contract LPs interact with. Each BunniKey corresponds to a BunniToken,
1792 /// which is the ERC20 LP token for the Uniswap V3 position specified by the BunniKey.
1793 /// Use deposit()/withdraw() to mint/burn LP tokens, and use compound() to compound the swap fees
1794 /// back into the LP position.
1795 interface IBunniHub is IMulticall, ISelfPermit, ILiquidityManagement {
1796     /// @notice Emitted when liquidity is increased via deposit
1797     /// @param sender The msg.sender address
1798     /// @param recipient The address of the account that received the share tokens
1799     /// @param bunniKeyHash The hash of the Bunni position's key
1800     /// @param liquidity The amount by which liquidity was increased
1801     /// @param amount0 The amount of token0 that was paid for the increase in liquidity
1802     /// @param amount1 The amount of token1 that was paid for the increase in liquidity
1803     /// @param shares The amount of share tokens minted to the recipient
1804     event Deposit(
1805         address indexed sender,
1806         address indexed recipient,
1807         bytes32 indexed bunniKeyHash,
1808         uint128 liquidity,
1809         uint256 amount0,
1810         uint256 amount1,
1811         uint256 shares
1812     );
1813     /// @notice Emitted when liquidity is decreased via withdrawal
1814     /// @param sender The msg.sender address
1815     /// @param recipient The address of the account that received the collected tokens
1816     /// @param bunniKeyHash The hash of the Bunni position's key
1817     /// @param liquidity The amount by which liquidity was decreased
1818     /// @param amount0 The amount of token0 that was accounted for the decrease in liquidity
1819     /// @param amount1 The amount of token1 that was accounted for the decrease in liquidity
1820     /// @param shares The amount of share tokens burnt from the sender
1821     event Withdraw(
1822         address indexed sender,
1823         address indexed recipient,
1824         bytes32 indexed bunniKeyHash,
1825         uint128 liquidity,
1826         uint256 amount0,
1827         uint256 amount1,
1828         uint256 shares
1829     );
1830     /// @notice Emitted when fees are compounded back into liquidity
1831     /// @param sender The msg.sender address
1832     /// @param bunniKeyHash The hash of the Bunni position's key
1833     /// @param liquidity The amount by which liquidity was increased
1834     /// @param amount0 The amount of token0 added to the liquidity position
1835     /// @param amount1 The amount of token1 added to the liquidity position
1836     event Compound(
1837         address indexed sender,
1838         bytes32 indexed bunniKeyHash,
1839         uint128 liquidity,
1840         uint256 amount0,
1841         uint256 amount1
1842     );
1843     /// @notice Emitted when a new IBunniToken is created
1844     /// @param bunniKeyHash The hash of the Bunni position's key
1845     /// @param pool The Uniswap V3 pool
1846     /// @param tickLower The lower tick of the Bunni's UniV3 LP position
1847     /// @param tickUpper The upper tick of the Bunni's UniV3 LP position
1848     event NewBunni(
1849         IBunniToken indexed token,
1850         bytes32 indexed bunniKeyHash,
1851         IUniswapV3Pool indexed pool,
1852         int24 tickLower,
1853         int24 tickUpper
1854     );
1855     /// @notice Emitted when protocol fees are paid to the factory
1856     /// @param amount0 The amount of token0 protocol fees that is withdrawn
1857     /// @param amount1 The amount of token1 protocol fees that is withdrawn
1858     event PayProtocolFee(uint256 amount0, uint256 amount1);
1859     /// @notice Emitted when the protocol fee has been updated
1860     /// @param newProtocolFee The new protocol fee
1861     event SetProtocolFee(uint256 newProtocolFee);
1862 
1863     /// @param key The Bunni position's key
1864     /// @param amount0Desired The desired amount of token0 to be spent,
1865     /// @param amount1Desired The desired amount of token1 to be spent,
1866     /// @param amount0Min The minimum amount of token0 to spend, which serves as a slippage check,
1867     /// @param amount1Min The minimum amount of token1 to spend, which serves as a slippage check,
1868     /// @param deadline The time by which the transaction must be included to effect the change
1869     /// @param recipient The recipient of the minted share tokens
1870     struct DepositParams {
1871         BunniKey key;
1872         uint256 amount0Desired;
1873         uint256 amount1Desired;
1874         uint256 amount0Min;
1875         uint256 amount1Min;
1876         uint256 deadline;
1877         address recipient;
1878     }
1879 
1880     /// @notice Increases the amount of liquidity in a position, with tokens paid by the `msg.sender`
1881     /// @dev Must be called after the corresponding BunniToken has been deployed via deployBunniToken()
1882     /// @param params The input parameters
1883     /// key The Bunni position's key
1884     /// amount0Desired The desired amount of token0 to be spent,
1885     /// amount1Desired The desired amount of token1 to be spent,
1886     /// amount0Min The minimum amount of token0 to spend, which serves as a slippage check,
1887     /// amount1Min The minimum amount of token1 to spend, which serves as a slippage check,
1888     /// deadline The time by which the transaction must be included to effect the change
1889     /// @return shares The new share tokens minted to the sender
1890     /// @return addedLiquidity The new liquidity amount as a result of the increase
1891     /// @return amount0 The amount of token0 to acheive resulting liquidity
1892     /// @return amount1 The amount of token1 to acheive resulting liquidity
1893     function deposit(DepositParams calldata params)
1894         external
1895         payable
1896         returns (
1897             uint256 shares,
1898             uint128 addedLiquidity,
1899             uint256 amount0,
1900             uint256 amount1
1901         );
1902 
1903     /// @param key The Bunni position's key
1904     /// @param recipient The user if not withdrawing ETH, address(0) if withdrawing ETH
1905     /// @param shares The amount of ERC20 tokens (this) to burn,
1906     /// @param amount0Min The minimum amount of token0 that should be accounted for the burned liquidity,
1907     /// @param amount1Min The minimum amount of token1 that should be accounted for the burned liquidity,
1908     /// @param deadline The time by which the transaction must be included to effect the change
1909     struct WithdrawParams {
1910         BunniKey key;
1911         address recipient;
1912         uint256 shares;
1913         uint256 amount0Min;
1914         uint256 amount1Min;
1915         uint256 deadline;
1916     }
1917 
1918     /// @notice Decreases the amount of liquidity in the position and sends the tokens to the sender.
1919     /// If withdrawing ETH, need to follow up with unwrapWETH9() and sweepToken()
1920     /// @dev Must be called after the corresponding BunniToken has been deployed via deployBunniToken()
1921     /// @param params The input parameters
1922     /// key The Bunni position's key
1923     /// recipient The user if not withdrawing ETH, address(0) if withdrawing ETH
1924     /// shares The amount of share tokens to burn,
1925     /// amount0Min The minimum amount of token0 that should be accounted for the burned liquidity,
1926     /// amount1Min The minimum amount of token1 that should be accounted for the burned liquidity,
1927     /// deadline The time by which the transaction must be included to effect the change
1928     /// @return removedLiquidity The amount of liquidity decrease
1929     /// @return amount0 The amount of token0 withdrawn to the recipient
1930     /// @return amount1 The amount of token1 withdrawn to the recipient
1931     function withdraw(WithdrawParams calldata params)
1932         external
1933         returns (
1934             uint128 removedLiquidity,
1935             uint256 amount0,
1936             uint256 amount1
1937         );
1938 
1939     /// @notice Claims the trading fees earned and uses it to add liquidity.
1940     /// @dev Must be called after the corresponding BunniToken has been deployed via deployBunniToken()
1941     /// @param key The Bunni position's key
1942     /// @return addedLiquidity The new liquidity amount as a result of the increase
1943     /// @return amount0 The amount of token0 added to the liquidity position
1944     /// @return amount1 The amount of token1 added to the liquidity position
1945     function compound(BunniKey calldata key)
1946         external
1947         returns (
1948             uint128 addedLiquidity,
1949             uint256 amount0,
1950             uint256 amount1
1951         );
1952 
1953     /// @notice Deploys the BunniToken contract for a Bunni position. This token
1954     /// represents a user's share in the Uniswap V3 LP position.
1955     /// @param key The Bunni position's key
1956     /// @return token The deployed BunniToken
1957     function deployBunniToken(BunniKey calldata key)
1958         external
1959         returns (IBunniToken token);
1960 
1961     /// @notice Returns the BunniToken contract for a Bunni position. This token
1962     /// represents a user's share in the Uniswap V3 LP position.
1963     /// If the contract hasn't been created yet, returns 0.
1964     /// @param key The Bunni position's key
1965     /// @return token The BunniToken contract
1966     function getBunniToken(BunniKey calldata key)
1967         external
1968         view
1969         returns (IBunniToken token);
1970 
1971     /// @notice Sweeps ERC20 token balances to a recipient. Mainly used for extracting protocol fees.
1972     /// Only callable by the owner.
1973     /// @param tokenList The list of ERC20 tokens to sweep
1974     /// @param recipient The token recipient address
1975     function sweepTokens(IERC20[] calldata tokenList, address recipient)
1976         external;
1977 
1978     /// @notice Updates the protocol fee value. Scaled by 1e18. Only callable by the owner.
1979     /// @param value The new protocol fee value
1980     function setProtocolFee(uint256 value) external;
1981 
1982     /// @notice Returns the protocol fee value. Decimal value <1, scaled by 1e18.
1983     function protocolFee() external returns (uint256);
1984 }
1985 
1986 /// @title BunniToken
1987 /// @author zefram.eth
1988 /// @notice ERC20 token that represents a user's LP position
1989 contract BunniToken is IBunniToken, ERC20 {
1990     IUniswapV3Pool public immutable override pool;
1991     int24 public immutable override tickLower;
1992     int24 public immutable override tickUpper;
1993     IBunniHub public immutable override hub;
1994 
1995     constructor(IBunniHub hub_, BunniKey memory key_)
1996         ERC20(
1997             string(
1998                 abi.encodePacked(
1999                     "Bunni ",
2000                     IERC20(key_.pool.token0()).symbol(),
2001                     "/",
2002                     IERC20(key_.pool.token1()).symbol(),
2003                     " LP"
2004                 )
2005             ),
2006             "BUNNI-LP",
2007             18
2008         )
2009     {
2010         pool = key_.pool;
2011         tickLower = key_.tickLower;
2012         tickUpper = key_.tickUpper;
2013         hub = hub_;
2014     }
2015 
2016     function mint(address to, uint256 amount) external override {
2017         require(msg.sender == address(hub), "WHO");
2018 
2019         _mint(to, amount);
2020     }
2021 
2022     function burn(address from, uint256 amount) external override {
2023         require(msg.sender == address(hub), "WHO");
2024 
2025         _burn(from, amount);
2026     }
2027 }
2028 
2029 /// @notice Safe ETH and ERC20 transfer library that gracefully handles missing return values.
2030 /// @author Solmate (https://github.com/transmissions11/solmate/blob/main/src/utils/SafeTransferLib.sol)
2031 /// @dev Use with caution! Some functions in this library knowingly create dirty bits at the destination of the free memory pointer.
2032 /// @dev Note that none of the functions in this library check that a token has code at all! That responsibility is delegated to the caller.
2033 library SafeTransferLib {
2034     /*//////////////////////////////////////////////////////////////
2035                              ETH OPERATIONS
2036     //////////////////////////////////////////////////////////////*/
2037 
2038     function safeTransferETH(address to, uint256 amount) internal {
2039         bool success;
2040 
2041         assembly {
2042             // Transfer the ETH and store if it succeeded or not.
2043             success := call(gas(), to, amount, 0, 0, 0, 0)
2044         }
2045 
2046         require(success, "ETH_TRANSFER_FAILED");
2047     }
2048 
2049     /*//////////////////////////////////////////////////////////////
2050                             ERC20 OPERATIONS
2051     //////////////////////////////////////////////////////////////*/
2052 
2053     function safeTransferFrom(
2054         IERC20 token,
2055         address from,
2056         address to,
2057         uint256 amount
2058     ) internal {
2059         bool success;
2060 
2061         assembly {
2062             // Get a pointer to some free memory.
2063             let freeMemoryPointer := mload(0x40)
2064 
2065             // Write the abi-encoded calldata into memory, beginning with the function selector.
2066             mstore(
2067                 freeMemoryPointer,
2068                 0x23b872dd00000000000000000000000000000000000000000000000000000000
2069             )
2070             mstore(add(freeMemoryPointer, 4), from) // Append the "from" argument.
2071             mstore(add(freeMemoryPointer, 36), to) // Append the "to" argument.
2072             mstore(add(freeMemoryPointer, 68), amount) // Append the "amount" argument.
2073 
2074             success := and(
2075                 // Set success to whether the call reverted, if not we check it either
2076                 // returned exactly 1 (can't just be non-zero data), or had no return data.
2077                 or(
2078                     and(eq(mload(0), 1), gt(returndatasize(), 31)),
2079                     iszero(returndatasize())
2080                 ),
2081                 // We use 100 because the length of our calldata totals up like so: 4 + 32 * 3.
2082                 // We use 0 and 32 to copy up to 32 bytes of return data into the scratch space.
2083                 // Counterintuitively, this call must be positioned second to the or() call in the
2084                 // surrounding and() call or else returndatasize() will be zero during the computation.
2085                 call(gas(), token, 0, freeMemoryPointer, 100, 0, 32)
2086             )
2087         }
2088 
2089         require(success, "TRANSFER_FROM_FAILED");
2090     }
2091 
2092     function safeTransfer(
2093         IERC20 token,
2094         address to,
2095         uint256 amount
2096     ) internal {
2097         bool success;
2098 
2099         assembly {
2100             // Get a pointer to some free memory.
2101             let freeMemoryPointer := mload(0x40)
2102 
2103             // Write the abi-encoded calldata into memory, beginning with the function selector.
2104             mstore(
2105                 freeMemoryPointer,
2106                 0xa9059cbb00000000000000000000000000000000000000000000000000000000
2107             )
2108             mstore(add(freeMemoryPointer, 4), to) // Append the "to" argument.
2109             mstore(add(freeMemoryPointer, 36), amount) // Append the "amount" argument.
2110 
2111             success := and(
2112                 // Set success to whether the call reverted, if not we check it either
2113                 // returned exactly 1 (can't just be non-zero data), or had no return data.
2114                 or(
2115                     and(eq(mload(0), 1), gt(returndatasize(), 31)),
2116                     iszero(returndatasize())
2117                 ),
2118                 // We use 68 because the length of our calldata totals up like so: 4 + 32 * 2.
2119                 // We use 0 and 32 to copy up to 32 bytes of return data into the scratch space.
2120                 // Counterintuitively, this call must be positioned second to the or() call in the
2121                 // surrounding and() call or else returndatasize() will be zero during the computation.
2122                 call(gas(), token, 0, freeMemoryPointer, 68, 0, 32)
2123             )
2124         }
2125 
2126         require(success, "TRANSFER_FAILED");
2127     }
2128 
2129     function safeApprove(
2130         IERC20 token,
2131         address to,
2132         uint256 amount
2133     ) internal {
2134         bool success;
2135 
2136         assembly {
2137             // Get a pointer to some free memory.
2138             let freeMemoryPointer := mload(0x40)
2139 
2140             // Write the abi-encoded calldata into memory, beginning with the function selector.
2141             mstore(
2142                 freeMemoryPointer,
2143                 0x095ea7b300000000000000000000000000000000000000000000000000000000
2144             )
2145             mstore(add(freeMemoryPointer, 4), to) // Append the "to" argument.
2146             mstore(add(freeMemoryPointer, 36), amount) // Append the "amount" argument.
2147 
2148             success := and(
2149                 // Set success to whether the call reverted, if not we check it either
2150                 // returned exactly 1 (can't just be non-zero data), or had no return data.
2151                 or(
2152                     and(eq(mload(0), 1), gt(returndatasize(), 31)),
2153                     iszero(returndatasize())
2154                 ),
2155                 // We use 68 because the length of our calldata totals up like so: 4 + 32 * 2.
2156                 // We use 0 and 32 to copy up to 32 bytes of return data into the scratch space.
2157                 // Counterintuitively, this call must be positioned second to the or() call in the
2158                 // surrounding and() call or else returndatasize() will be zero during the computation.
2159                 call(gas(), token, 0, freeMemoryPointer, 68, 0, 32)
2160             )
2161         }
2162 
2163         require(success, "APPROVE_FAILED");
2164     }
2165 }
2166 
2167 /// @title Liquidity management functions
2168 /// @notice Internal functions for safely managing liquidity in Uniswap V3
2169 abstract contract LiquidityManagement is ILiquidityManagement {
2170     using SafeTransferLib for IERC20;
2171 
2172     /// @param token0 The token0 of the Uniswap pool
2173     /// @param token1 The token1 of the Uniswap pool
2174     /// @param fee The fee tier of the Uniswap pool
2175     /// @param payer The address to pay for the required tokens
2176     struct MintCallbackData {
2177         address token0;
2178         address token1;
2179         uint24 fee;
2180         address payer;
2181     }
2182 
2183     IUniswapV3Factory public immutable override factory;
2184 
2185     constructor(IUniswapV3Factory factory_) {
2186         factory = factory_;
2187     }
2188 
2189     /// @inheritdoc IUniswapV3MintCallback
2190     function uniswapV3MintCallback(
2191         uint256 amount0Owed,
2192         uint256 amount1Owed,
2193         bytes calldata data
2194     ) external override {
2195         MintCallbackData memory decodedData = abi.decode(
2196             data,
2197             (MintCallbackData)
2198         );
2199 
2200         // verify caller
2201         address computedPool = factory.getPool(
2202             decodedData.token0,
2203             decodedData.token1,
2204             decodedData.fee
2205         );
2206         require(msg.sender == computedPool, "WHO");
2207 
2208         if (amount0Owed > 0)
2209             pay(decodedData.token0, decodedData.payer, msg.sender, amount0Owed);
2210         if (amount1Owed > 0)
2211             pay(decodedData.token1, decodedData.payer, msg.sender, amount1Owed);
2212     }
2213 
2214     /// @param key The Bunni position's key
2215     /// @param recipient The recipient of the liquidity position
2216     /// @param payer The address that will pay the tokens
2217     /// @param amount0Desired The token0 amount to use
2218     /// @param amount1Desired The token1 amount to use
2219     /// @param amount0Min The minimum token0 amount to use
2220     /// @param amount1Min The minimum token1 amount to use
2221     struct AddLiquidityParams {
2222         BunniKey key;
2223         address recipient;
2224         address payer;
2225         uint256 amount0Desired;
2226         uint256 amount1Desired;
2227         uint256 amount0Min;
2228         uint256 amount1Min;
2229     }
2230 
2231     /// @notice Add liquidity to an initialized pool
2232     function _addLiquidity(AddLiquidityParams memory params)
2233         internal
2234         returns (
2235             uint128 liquidity,
2236             uint256 amount0,
2237             uint256 amount1
2238         )
2239     {
2240         if (params.amount0Desired == 0 && params.amount1Desired == 0) {
2241             return (0, 0, 0);
2242         }
2243 
2244         // compute the liquidity amount
2245         {
2246             (uint160 sqrtPriceX96, , , , , , ) = params.key.pool.slot0();
2247             uint160 sqrtRatioAX96 = TickMath.getSqrtRatioAtTick(
2248                 params.key.tickLower
2249             );
2250             uint160 sqrtRatioBX96 = TickMath.getSqrtRatioAtTick(
2251                 params.key.tickUpper
2252             );
2253 
2254             liquidity = LiquidityAmounts.getLiquidityForAmounts(
2255                 sqrtPriceX96,
2256                 sqrtRatioAX96,
2257                 sqrtRatioBX96,
2258                 params.amount0Desired,
2259                 params.amount1Desired
2260             );
2261         }
2262 
2263         (amount0, amount1) = params.key.pool.mint(
2264             params.recipient,
2265             params.key.tickLower,
2266             params.key.tickUpper,
2267             liquidity,
2268             abi.encode(
2269                 MintCallbackData({
2270                     token0: params.key.pool.token0(),
2271                     token1: params.key.pool.token1(),
2272                     fee: params.key.pool.fee(),
2273                     payer: params.payer
2274                 })
2275             )
2276         );
2277 
2278         require(
2279             amount0 >= params.amount0Min && amount1 >= params.amount1Min,
2280             "SLIP"
2281         );
2282     }
2283 
2284     /// @param token The token to pay
2285     /// @param payer The entity that must pay
2286     /// @param recipient The entity that will receive payment
2287     /// @param value The amount to pay
2288     function pay(
2289         address token,
2290         address payer,
2291         address recipient,
2292         uint256 value
2293     ) internal {
2294         if (payer == address(this)) {
2295             // pay with tokens already in the contract (for the exact input multihop case)
2296             IERC20(token).safeTransfer(recipient, value);
2297         } else {
2298             // pull payment
2299             IERC20(token).safeTransferFrom(payer, recipient, value);
2300         }
2301     }
2302 }
2303 
2304 /// @title BunniHub
2305 /// @author zefram.eth
2306 /// @notice The main contract LPs interact with. Each BunniKey corresponds to a BunniToken,
2307 /// which is the ERC20 LP token for the Uniswap V3 position specified by the BunniKey.
2308 /// Use deposit()/withdraw() to mint/burn LP tokens, and use compound() to compound the swap fees
2309 /// back into the LP position.
2310 contract BunniHub is
2311     IBunniHub,
2312     Owned,
2313     Multicall,
2314     SelfPermit,
2315     LiquidityManagement
2316 {
2317     uint256 internal constant WAD = 1e18;
2318     uint256 internal constant MAX_PROTOCOL_FEE = 5e17;
2319     uint256 internal constant MIN_INITIAL_SHARES = 1e9;
2320 
2321     /// -----------------------------------------------------------
2322     /// Storage variables
2323     /// -----------------------------------------------------------
2324 
2325     uint256 public override protocolFee;
2326 
2327     /// -----------------------------------------------------------
2328     /// Modifiers
2329     /// -----------------------------------------------------------
2330 
2331     modifier checkDeadline(uint256 deadline) {
2332         require(block.timestamp <= deadline, "OLD");
2333         _;
2334     }
2335 
2336     /// -----------------------------------------------------------
2337     /// Constructor
2338     /// -----------------------------------------------------------
2339 
2340     constructor(
2341         IUniswapV3Factory factory_,
2342         address owner_,
2343         uint256 protocolFee_
2344     ) Owned(owner_) LiquidityManagement(factory_) {
2345         protocolFee = protocolFee_;
2346     }
2347 
2348     /// -----------------------------------------------------------
2349     /// External functions
2350     /// -----------------------------------------------------------
2351 
2352     /// @inheritdoc IBunniHub
2353     function deposit(DepositParams calldata params)
2354         external
2355         payable
2356         virtual
2357         override
2358         checkDeadline(params.deadline)
2359         returns (
2360             uint256 shares,
2361             uint128 addedLiquidity,
2362             uint256 amount0,
2363             uint256 amount1
2364         )
2365     {
2366         (uint128 existingLiquidity, , , , ) = params.key.pool.positions(
2367             keccak256(
2368                 abi.encodePacked(
2369                     address(this),
2370                     params.key.tickLower,
2371                     params.key.tickUpper
2372                 )
2373             )
2374         );
2375         (addedLiquidity, amount0, amount1) = _addLiquidity(
2376             LiquidityManagement.AddLiquidityParams({
2377                 key: params.key,
2378                 recipient: address(this),
2379                 payer: msg.sender,
2380                 amount0Desired: params.amount0Desired,
2381                 amount1Desired: params.amount1Desired,
2382                 amount0Min: params.amount0Min,
2383                 amount1Min: params.amount1Min
2384             })
2385         );
2386         shares = _mintShares(
2387             params.key,
2388             params.recipient,
2389             addedLiquidity,
2390             existingLiquidity
2391         );
2392 
2393         emit Deposit(
2394             msg.sender,
2395             params.recipient,
2396             keccak256(abi.encode(params.key)),
2397             addedLiquidity,
2398             amount0,
2399             amount1,
2400             shares
2401         );
2402     }
2403 
2404     /// @inheritdoc IBunniHub
2405     function withdraw(WithdrawParams calldata params)
2406         external
2407         virtual
2408         override
2409         checkDeadline(params.deadline)
2410         returns (
2411             uint128 removedLiquidity,
2412             uint256 amount0,
2413             uint256 amount1
2414         )
2415     {
2416         IBunniToken shareToken = getBunniToken(params.key);
2417         require(address(shareToken) != address(0), "WHAT");
2418 
2419         uint256 currentTotalSupply = shareToken.totalSupply();
2420         (uint128 existingLiquidity, , , , ) = params.key.pool.positions(
2421             keccak256(
2422                 abi.encodePacked(
2423                     address(this),
2424                     params.key.tickLower,
2425                     params.key.tickUpper
2426                 )
2427             )
2428         );
2429 
2430         // burn shares
2431         require(params.shares > 0, "0");
2432         shareToken.burn(msg.sender, params.shares);
2433         // at this point of execution we know param.shares <= currentTotalSupply
2434         // since otherwise the burn() call would've reverted
2435 
2436         // burn liquidity from pool
2437         // type cast is safe because we know removedLiquidity <= existingLiquidity
2438         removedLiquidity = uint128(
2439             FullMath.mulDiv(
2440                 existingLiquidity,
2441                 params.shares,
2442                 currentTotalSupply
2443             )
2444         );
2445         // burn liquidity
2446         // tokens are now collectable in the pool
2447         (amount0, amount1) = params.key.pool.burn(
2448             params.key.tickLower,
2449             params.key.tickUpper,
2450             removedLiquidity
2451         );
2452         // collect tokens and give to msg.sender
2453         (amount0, amount1) = params.key.pool.collect(
2454             params.recipient,
2455             params.key.tickLower,
2456             params.key.tickUpper,
2457             uint128(amount0),
2458             uint128(amount1)
2459         );
2460         require(
2461             amount0 >= params.amount0Min && amount1 >= params.amount1Min,
2462             "SLIP"
2463         );
2464 
2465         emit Withdraw(
2466             msg.sender,
2467             params.recipient,
2468             keccak256(abi.encode(params.key)),
2469             removedLiquidity,
2470             amount0,
2471             amount1,
2472             params.shares
2473         );
2474     }
2475 
2476     /// @inheritdoc IBunniHub
2477     function compound(BunniKey calldata key)
2478         external
2479         virtual
2480         override
2481         returns (
2482             uint128 addedLiquidity,
2483             uint256 amount0,
2484             uint256 amount1
2485         )
2486     {
2487         uint256 protocolFee_ = protocolFee;
2488 
2489         // trigger an update of the position fees owed snapshots if it has any liquidity
2490         key.pool.burn(key.tickLower, key.tickUpper, 0);
2491         (, , , uint128 cachedFeesOwed0, uint128 cachedFeesOwed1) = key
2492             .pool
2493             .positions(
2494                 keccak256(
2495                     abi.encodePacked(
2496                         address(this),
2497                         key.tickLower,
2498                         key.tickUpper
2499                     )
2500                 )
2501             );
2502 
2503         /// -----------------------------------------------------------
2504         /// amount0, amount1 are multi-purposed, see comments below
2505         /// -----------------------------------------------------------
2506         amount0 = cachedFeesOwed0;
2507         amount1 = cachedFeesOwed1;
2508 
2509         /// -----------------------------------------------------------
2510         /// amount0, amount1 now store the updated amounts of fee owed
2511         /// -----------------------------------------------------------
2512 
2513         // the fee is likely not balanced (i.e. tokens will be left over after adding liquidity)
2514         // so here we compute which token to fully claim and which token to partially claim
2515         // so that we only claim the amounts we need
2516 
2517         {
2518             (uint160 sqrtRatioX96, , , , , , ) = key.pool.slot0();
2519             uint160 sqrtRatioAX96 = TickMath.getSqrtRatioAtTick(key.tickLower);
2520             uint160 sqrtRatioBX96 = TickMath.getSqrtRatioAtTick(key.tickUpper);
2521 
2522             // compute the maximum liquidity addable using the accrued fees
2523             uint128 maxAddLiquidity = LiquidityAmounts.getLiquidityForAmounts(
2524                 sqrtRatioX96,
2525                 sqrtRatioAX96,
2526                 sqrtRatioBX96,
2527                 amount0,
2528                 amount1
2529             );
2530 
2531             // compute the token amounts corresponding to the max addable liquidity
2532             (amount0, amount1) = LiquidityAmounts.getAmountsForLiquidity(
2533                 sqrtRatioX96,
2534                 sqrtRatioAX96,
2535                 sqrtRatioBX96,
2536                 maxAddLiquidity
2537             );
2538         }
2539 
2540         /// -----------------------------------------------------------
2541         /// amount0, amount1 now store the amount of fees to claim
2542         /// -----------------------------------------------------------
2543 
2544         // the actual amounts collected are returned
2545         // tokens are transferred to address(this)
2546         (amount0, amount1) = key.pool.collect(
2547             address(this),
2548             key.tickLower,
2549             key.tickUpper,
2550             uint128(amount0),
2551             uint128(amount1)
2552         );
2553 
2554         /// -----------------------------------------------------------
2555         /// amount0, amount1 now store the fees claimed
2556         /// -----------------------------------------------------------
2557 
2558         if (protocolFee_ > 0) {
2559             // take fee from amount0 and amount1 and transfer to factory
2560             // amount0 uses 128 bits, protocolFee uses 60 bits
2561             // so amount0 * protocolFee can't overflow 256 bits
2562             uint256 fee0 = (amount0 * protocolFee_) / WAD;
2563             uint256 fee1 = (amount1 * protocolFee_) / WAD;
2564 
2565             // add fees (minus protocol fees) to Uniswap pool
2566             (addedLiquidity, amount0, amount1) = _addLiquidity(
2567                 LiquidityManagement.AddLiquidityParams({
2568                     key: key,
2569                     recipient: address(this),
2570                     payer: address(this),
2571                     amount0Desired: amount0 - fee0,
2572                     amount1Desired: amount1 - fee1,
2573                     amount0Min: 0,
2574                     amount1Min: 0
2575                 })
2576             );
2577 
2578             // the protocol fees are now stored in the factory itself
2579             // and can be withdrawn by the owner via sweepTokens()
2580 
2581             // emit event
2582             emit PayProtocolFee(fee0, fee1);
2583         } else {
2584             // add fees to Uniswap pool
2585             (addedLiquidity, amount0, amount1) = _addLiquidity(
2586                 LiquidityManagement.AddLiquidityParams({
2587                     key: key,
2588                     recipient: address(this),
2589                     payer: address(this),
2590                     amount0Desired: amount0,
2591                     amount1Desired: amount1,
2592                     amount0Min: 0,
2593                     amount1Min: 0
2594                 })
2595             );
2596         }
2597 
2598         /// -----------------------------------------------------------
2599         /// amount0, amount1 now store the tokens added as liquidity
2600         /// -----------------------------------------------------------
2601 
2602         emit Compound(
2603             msg.sender,
2604             keccak256(abi.encode(key)),
2605             addedLiquidity,
2606             amount0,
2607             amount1
2608         );
2609     }
2610 
2611     /// @inheritdoc IBunniHub
2612     function deployBunniToken(BunniKey calldata key)
2613         public
2614         override
2615         returns (IBunniToken token)
2616     {
2617         bytes32 bunniKeyHash = keccak256(abi.encode(key));
2618 
2619         token = IBunniToken(
2620             CREATE3.deploy(
2621                 bunniKeyHash,
2622                 abi.encodePacked(
2623                     type(BunniToken).creationCode,
2624                     abi.encode(this, key)
2625                 ),
2626                 0
2627             )
2628         );
2629 
2630         emit NewBunni(
2631             token,
2632             bunniKeyHash,
2633             key.pool,
2634             key.tickLower,
2635             key.tickUpper
2636         );
2637     }
2638 
2639     /// -----------------------------------------------------------------------
2640     /// View functions
2641     /// -----------------------------------------------------------------------
2642 
2643     /// @inheritdoc IBunniHub
2644     function getBunniToken(BunniKey calldata key)
2645         public
2646         view
2647         override
2648         returns (IBunniToken token)
2649     {
2650         token = IBunniToken(CREATE3.getDeployed(keccak256(abi.encode(key))));
2651 
2652         uint256 tokenCodeLength;
2653         assembly {
2654             tokenCodeLength := extcodesize(token)
2655         }
2656 
2657         if (tokenCodeLength == 0) {
2658             return IBunniToken(address(0));
2659         }
2660     }
2661 
2662     /// -----------------------------------------------------------------------
2663     /// Owner functions
2664     /// -----------------------------------------------------------------------
2665 
2666     /// @inheritdoc IBunniHub
2667     function sweepTokens(IERC20[] calldata tokenList, address recipient)
2668         external
2669         override
2670         onlyOwner
2671     {
2672         uint256 tokenListLength = tokenList.length;
2673         for (uint256 i; i < tokenListLength; ) {
2674             SafeTransferLib.safeTransfer(
2675                 tokenList[i],
2676                 recipient,
2677                 tokenList[i].balanceOf(address(this))
2678             );
2679 
2680             unchecked {
2681                 ++i;
2682             }
2683         }
2684     }
2685 
2686     /// @inheritdoc IBunniHub
2687     function setProtocolFee(uint256 value) external override onlyOwner {
2688         require(value <= MAX_PROTOCOL_FEE, "MAX");
2689         protocolFee = value;
2690         emit SetProtocolFee(value);
2691     }
2692 
2693     /// -----------------------------------------------------------
2694     /// Internal functions
2695     /// -----------------------------------------------------------
2696 
2697     /// @notice Mints share tokens to the recipient based on the amount of liquidity added.
2698     /// @param key The Bunni position's key
2699     /// @param recipient The recipient of the share tokens
2700     /// @param addedLiquidity The amount of liquidity added
2701     /// @param existingLiquidity The amount of existing liquidity before the add
2702     /// @return shares The amount of share tokens minted to the sender.
2703     function _mintShares(
2704         BunniKey calldata key,
2705         address recipient,
2706         uint128 addedLiquidity,
2707         uint128 existingLiquidity
2708     ) internal virtual returns (uint256 shares) {
2709         IBunniToken shareToken = getBunniToken(key);
2710         require(address(shareToken) != address(0), "WHAT");
2711 
2712         uint256 existingShareSupply = shareToken.totalSupply();
2713         if (existingShareSupply == 0) {
2714             // no existing shares, bootstrap at rate 1:1
2715             shares = addedLiquidity;
2716             // prevent first staker from stealing funds of subsequent stakers
2717             // see https://code4rena.com/reports/2022-01-sherlock/#h-01-first-user-can-steal-everyone-elses-tokens
2718             require(shares > MIN_INITIAL_SHARES, "SMOL");
2719         } else {
2720             // shares = existingShareSupply * addedLiquidity / existingLiquidity;
2721             shares = FullMath.mulDiv(
2722                 existingShareSupply,
2723                 addedLiquidity,
2724                 existingLiquidity
2725             );
2726             require(shares != 0, "0");
2727         }
2728 
2729         // mint shares to sender
2730         shareToken.mint(recipient, shares);
2731     }
2732 }