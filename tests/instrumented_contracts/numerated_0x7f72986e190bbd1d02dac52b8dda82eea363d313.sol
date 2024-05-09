1 // SPDX-License-Identifier: BUSL-1.1
2 // File: https://github.com/overlay-market/v1-core/blob/main/contracts/libraries/uniswap/v3-core/FullMath.sol
3 
4 
5 pragma solidity ^0.8.0;
6 
7 /// COPIED FROM:
8 /// https://github.com/Uniswap/v3-core/blob/0.8/contracts/libraries/FullMath.sol
9 
10 /// @title Contains 512-bit math functions
11 /// @notice Facilitates multiplication and division that can have overflow of
12 /// @notice an intermediate value without any loss of precision
13 /// @dev Handles "phantom overflow" i.e., allows multiplication and division
14 /// @dev where an intermediate value overflows 256 bits
15 library FullMath {
16     /// @notice Calculates floor(a×b÷denominator) with full precision.
17     /// @notice Throws if result overflows a uint256 or denominator == 0
18     /// @param a The multiplicand
19     /// @param b The multiplier
20     /// @param denominator The divisor
21     /// @return result The 256-bit result
22     /// @dev Credit to Remco Bloemen under MIT license https://xn--2-umb.com/21/muldiv
23     function mulDiv(
24         uint256 a,
25         uint256 b,
26         uint256 denominator
27     ) internal pure returns (uint256 result) {
28         unchecked {
29             // 512-bit multiply [prod1 prod0] = a * b
30             // Compute the product mod 2**256 and mod 2**256 - 1
31             // then use the Chinese Remainder Theorem to reconstruct
32             // the 512 bit result. The result is stored in two 256
33             // variables such that product = prod1 * 2**256 + prod0
34             uint256 prod0; // Least significant 256 bits of the product
35             uint256 prod1; // Most significant 256 bits of the product
36             assembly {
37                 let mm := mulmod(a, b, not(0))
38                 prod0 := mul(a, b)
39                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
40             }
41 
42             // Handle non-overflow cases, 256 by 256 division
43             if (prod1 == 0) {
44                 require(denominator > 0);
45                 assembly {
46                     result := div(prod0, denominator)
47                 }
48                 return result;
49             }
50 
51             // Make sure the result is less than 2**256.
52             // Also prevents denominator == 0
53             require(denominator > prod1);
54 
55             ///////////////////////////////////////////////
56             // 512 by 256 division.
57             ///////////////////////////////////////////////
58 
59             // Make division exact by subtracting the remainder from [prod1 prod0]
60             // Compute remainder using mulmod
61             uint256 remainder;
62             assembly {
63                 remainder := mulmod(a, b, denominator)
64             }
65             // Subtract 256 bit number from 512 bit number
66             assembly {
67                 prod1 := sub(prod1, gt(remainder, prod0))
68                 prod0 := sub(prod0, remainder)
69             }
70 
71             // Factor powers of two out of denominator
72             // Compute largest power of two divisor of denominator.
73             // Always >= 1.
74             uint256 twos = (0 - denominator) & denominator;
75             // Divide denominator by power of two
76             assembly {
77                 denominator := div(denominator, twos)
78             }
79 
80             // Divide [prod1 prod0] by the factors of two
81             assembly {
82                 prod0 := div(prod0, twos)
83             }
84             // Shift in bits from prod1 into prod0. For this we need
85             // to flip `twos` such that it is 2**256 / twos.
86             // If twos is zero, then it becomes one
87             assembly {
88                 twos := add(div(sub(0, twos), twos), 1)
89             }
90             prod0 |= prod1 * twos;
91 
92             // Invert denominator mod 2**256
93             // Now that denominator is an odd number, it has an inverse
94             // modulo 2**256 such that denominator * inv = 1 mod 2**256.
95             // Compute the inverse by starting with a seed that is correct
96             // correct for four bits. That is, denominator * inv = 1 mod 2**4
97             uint256 inv = (3 * denominator) ^ 2;
98             // Now use Newton-Raphson iteration to improve the precision.
99             // Thanks to Hensel's lifting lemma, this also works in modular
100             // arithmetic, doubling the correct bits in each step.
101             inv *= 2 - denominator * inv; // inverse mod 2**8
102             inv *= 2 - denominator * inv; // inverse mod 2**16
103             inv *= 2 - denominator * inv; // inverse mod 2**32
104             inv *= 2 - denominator * inv; // inverse mod 2**64
105             inv *= 2 - denominator * inv; // inverse mod 2**128
106             inv *= 2 - denominator * inv; // inverse mod 2**256
107 
108             // Because the division is now exact we can divide by multiplying
109             // with the modular inverse of denominator. This will give us the
110             // correct result modulo 2**256. Since the precoditions guarantee
111             // that the outcome is less than 2**256, this is the final result.
112             // We don't need to compute the high bits of the result and prod1
113             // is no longer required.
114             result = prod0 * inv;
115             return result;
116         }
117     }
118 
119     /// @notice Calculates ceil(a×b÷denominator) with full precision.
120     /// @notice Throws if result overflows a uint256 or denominator == 0
121     /// @param a The multiplicand
122     /// @param b The multiplier
123     /// @param denominator The divisor
124     /// @return result The 256-bit result
125     function mulDivRoundingUp(
126         uint256 a,
127         uint256 b,
128         uint256 denominator
129     ) internal pure returns (uint256 result) {
130         unchecked {
131             result = mulDiv(a, b, denominator);
132             if (mulmod(a, b, denominator) > 0) {
133                 require(result < type(uint256).max);
134                 result++;
135             }
136         }
137     }
138 }
139 
140 // File: https://github.com/overlay-market/v1-core/blob/main/contracts/libraries/FixedCast.sol
141 
142 
143 pragma solidity 0.8.10;
144 
145 library FixedCast {
146     uint256 internal constant ONE_256 = 1e18; // 18 decimal places
147     uint256 internal constant ONE_16 = 1e4; // 4 decimal places
148 
149     /// @dev casts a uint16 to a FixedPoint uint256 with 18 decimals
150     function toUint256Fixed(uint16 value) internal pure returns (uint256) {
151         uint256 multiplier = ONE_256 / ONE_16;
152         return (uint256(value) * multiplier);
153     }
154 
155     /// @dev casts a FixedPoint uint256 to a uint16 with 4 decimals
156     function toUint16Fixed(uint256 value) internal pure returns (uint16) {
157         uint256 divisor = ONE_256 / ONE_16;
158         uint256 ret256 = value / divisor;
159         require(ret256 <= type(uint16).max, "OVLV1: FixedCast out of bounds");
160         return uint16(ret256);
161     }
162 }
163 
164 // File: https://github.com/overlay-market/v1-core/blob/main/contracts/utils/Errors.sol
165 
166 
167 // This program is free software: you can redistribute it and/or modify
168 // it under the terms of the GNU General Public License as published by
169 // the Free Software Foundation, either version 3 of the License, or
170 // (at your option) any later version.
171 
172 // This program is distributed in the hope that it will be useful,
173 // but WITHOUT ANY WARRANTY; without even the implied warranty of
174 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
175 // GNU General Public License for more details.
176 
177 // You should have received a copy of the GNU General Public License
178 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
179 
180 pragma solidity 0.8.10;
181 
182 // solhint-disable
183 
184 /**
185  * @dev Reverts if `condition` is false, with a revert reason containing `errorCode`. Only codes up to 999 are
186  * supported.
187  */
188 function _require(bool condition, uint256 errorCode) pure {
189     if (!condition) _revert(errorCode);
190 }
191 
192 /**
193  * @dev Reverts with a revert reason containing `errorCode`. Only codes up to 999 are supported.
194  */
195 function _revert(uint256 errorCode) pure {
196     // We're going to dynamically create a revert string based on the error code, with the following format:
197     // 'BAL#{errorCode}'
198     // where the code is left-padded with zeroes to three digits (so they range from 000 to 999).
199     //
200     // We don't have revert strings embedded in the contract to save bytecode size: it takes much less space to store a
201     // number (8 to 16 bits) than the individual string characters.
202     //
203     // The dynamic string creation algorithm that follows could be implemented in Solidity, but assembly allows for a
204     // much denser implementation, again saving bytecode size. Given this function unconditionally reverts, this is a
205     // safe place to rely on it without worrying about how its usage might affect e.g. memory contents.
206     assembly {
207         // First, we need to compute the ASCII representation of the error code. We assume that it is in the 0-999
208         // range, so we only need to convert three digits. To convert the digits to ASCII, we add 0x30, the value for
209         // the '0' character.
210 
211         let units := add(mod(errorCode, 10), 0x30)
212 
213         errorCode := div(errorCode, 10)
214         let tenths := add(mod(errorCode, 10), 0x30)
215 
216         errorCode := div(errorCode, 10)
217         let hundreds := add(mod(errorCode, 10), 0x30)
218 
219         // With the individual characters, we can now construct the full string. The "BAL#" part is a known constant
220         // (0x42414c23): we simply shift this by 24 (to provide space for the 3 bytes of the error code), and add the
221         // characters to it, each shifted by a multiple of 8.
222         // The revert reason is then shifted left by 200 bits (256 minus the length of the string, 7 characters * 8 bits
223         // per character = 56) to locate it in the most significant part of the 256 slot (the beginning of a byte
224         // array).
225 
226         let revertReason := shl(
227             200,
228             add(0x42414c23000000, add(add(units, shl(8, tenths)), shl(16, hundreds)))
229         )
230 
231         // We can now encode the reason in memory, which can be safely overwritten as we're about to revert. The encoded
232         // message will have the following layout:
233         // [ revert reason identifier ] [ string location offset ] [ string length ] [ string contents ]
234 
235         // The Solidity revert reason identifier is 0x08c739a0, the function selector of the Error(string) function. We
236         // also write zeroes to the next 28 bytes of memory, but those are about to be overwritten.
237         mstore(0x0, 0x08c379a000000000000000000000000000000000000000000000000000000000)
238         // Next is the offset to the location of the string, which will be placed immediately after (20 bytes away).
239         mstore(0x04, 0x0000000000000000000000000000000000000000000000000000000000000020)
240         // The string length is fixed: 7 characters.
241         mstore(0x24, 7)
242         // Finally, the string itself is stored.
243         mstore(0x44, revertReason)
244 
245         // Even if the string is only 7 bytes long, we need to return a full 32 byte slot containing it. The length of
246         // the encoded message is therefore 4 + 32 + 32 + 32 = 100.
247         revert(0, 100)
248     }
249 }
250 
251 library Errors {
252     // Math
253     uint256 internal constant ADD_OVERFLOW = 0;
254     uint256 internal constant SUB_OVERFLOW = 1;
255     uint256 internal constant SUB_UNDERFLOW = 2;
256     uint256 internal constant MUL_OVERFLOW = 3;
257     uint256 internal constant ZERO_DIVISION = 4;
258     uint256 internal constant DIV_INTERNAL = 5;
259     uint256 internal constant X_OUT_OF_BOUNDS = 6;
260     uint256 internal constant Y_OUT_OF_BOUNDS = 7;
261     uint256 internal constant PRODUCT_OUT_OF_BOUNDS = 8;
262     uint256 internal constant INVALID_EXPONENT = 9;
263 
264     // Input
265     uint256 internal constant OUT_OF_BOUNDS = 100;
266     uint256 internal constant UNSORTED_ARRAY = 101;
267     uint256 internal constant UNSORTED_TOKENS = 102;
268     uint256 internal constant INPUT_LENGTH_MISMATCH = 103;
269     uint256 internal constant ZERO_TOKEN = 104;
270 
271     // Shared pools
272     uint256 internal constant MIN_TOKENS = 200;
273     uint256 internal constant MAX_TOKENS = 201;
274     uint256 internal constant MAX_SWAP_FEE_PERCENTAGE = 202;
275     uint256 internal constant MIN_SWAP_FEE_PERCENTAGE = 203;
276     uint256 internal constant MINIMUM_BPT = 204;
277     uint256 internal constant CALLER_NOT_VAULT = 205;
278     uint256 internal constant UNINITIALIZED = 206;
279     uint256 internal constant BPT_IN_MAX_AMOUNT = 207;
280     uint256 internal constant BPT_OUT_MIN_AMOUNT = 208;
281     uint256 internal constant EXPIRED_PERMIT = 209;
282     uint256 internal constant NOT_TWO_TOKENS = 210;
283     uint256 internal constant DISABLED = 211;
284 
285     // Pools
286     uint256 internal constant MIN_AMP = 300;
287     uint256 internal constant MAX_AMP = 301;
288     uint256 internal constant MIN_WEIGHT = 302;
289     uint256 internal constant MAX_STABLE_TOKENS = 303;
290     uint256 internal constant MAX_IN_RATIO = 304;
291     uint256 internal constant MAX_OUT_RATIO = 305;
292     uint256 internal constant MIN_BPT_IN_FOR_TOKEN_OUT = 306;
293     uint256 internal constant MAX_OUT_BPT_FOR_TOKEN_IN = 307;
294     uint256 internal constant NORMALIZED_WEIGHT_INVARIANT = 308;
295     uint256 internal constant INVALID_TOKEN = 309;
296     uint256 internal constant UNHANDLED_JOIN_KIND = 310;
297     uint256 internal constant ZERO_INVARIANT = 311;
298     uint256 internal constant ORACLE_INVALID_SECONDS_QUERY = 312;
299     uint256 internal constant ORACLE_NOT_INITIALIZED = 313;
300     uint256 internal constant ORACLE_QUERY_TOO_OLD = 314;
301     uint256 internal constant ORACLE_INVALID_INDEX = 315;
302     uint256 internal constant ORACLE_BAD_SECS = 316;
303     uint256 internal constant AMP_END_TIME_TOO_CLOSE = 317;
304     uint256 internal constant AMP_ONGOING_UPDATE = 318;
305     uint256 internal constant AMP_RATE_TOO_HIGH = 319;
306     uint256 internal constant AMP_NO_ONGOING_UPDATE = 320;
307     uint256 internal constant STABLE_INVARIANT_DIDNT_CONVERGE = 321;
308     uint256 internal constant STABLE_GET_BALANCE_DIDNT_CONVERGE = 322;
309     uint256 internal constant RELAYER_NOT_CONTRACT = 323;
310     uint256 internal constant BASE_POOL_RELAYER_NOT_CALLED = 324;
311     uint256 internal constant REBALANCING_RELAYER_REENTERED = 325;
312     uint256 internal constant GRADUAL_UPDATE_TIME_TRAVEL = 326;
313     uint256 internal constant SWAPS_DISABLED = 327;
314     uint256 internal constant CALLER_IS_NOT_LBP_OWNER = 328;
315     uint256 internal constant PRICE_RATE_OVERFLOW = 329;
316     uint256 internal constant INVALID_JOIN_EXIT_KIND_WHILE_SWAPS_DISABLED = 330;
317     uint256 internal constant WEIGHT_CHANGE_TOO_FAST = 331;
318     uint256 internal constant LOWER_GREATER_THAN_UPPER_TARGET = 332;
319     uint256 internal constant UPPER_TARGET_TOO_HIGH = 333;
320     uint256 internal constant UNHANDLED_BY_LINEAR_POOL = 334;
321     uint256 internal constant OUT_OF_TARGET_RANGE = 335;
322     uint256 internal constant UNHANDLED_EXIT_KIND = 336;
323     uint256 internal constant UNAUTHORIZED_EXIT = 337;
324     uint256 internal constant MAX_MANAGEMENT_SWAP_FEE_PERCENTAGE = 338;
325     uint256 internal constant UNHANDLED_BY_MANAGED_POOL = 339;
326     uint256 internal constant UNHANDLED_BY_PHANTOM_POOL = 340;
327     uint256 internal constant TOKEN_DOES_NOT_HAVE_RATE_PROVIDER = 341;
328     uint256 internal constant INVALID_INITIALIZATION = 342;
329     uint256 internal constant OUT_OF_NEW_TARGET_RANGE = 343;
330     uint256 internal constant UNAUTHORIZED_OPERATION = 344;
331     uint256 internal constant UNINITIALIZED_POOL_CONTROLLER = 345;
332 
333     // Lib
334     uint256 internal constant REENTRANCY = 400;
335     uint256 internal constant SENDER_NOT_ALLOWED = 401;
336     uint256 internal constant PAUSED = 402;
337     uint256 internal constant PAUSE_WINDOW_EXPIRED = 403;
338     uint256 internal constant MAX_PAUSE_WINDOW_DURATION = 404;
339     uint256 internal constant MAX_BUFFER_PERIOD_DURATION = 405;
340     uint256 internal constant INSUFFICIENT_BALANCE = 406;
341     uint256 internal constant INSUFFICIENT_ALLOWANCE = 407;
342     uint256 internal constant ERC20_TRANSFER_FROM_ZERO_ADDRESS = 408;
343     uint256 internal constant ERC20_TRANSFER_TO_ZERO_ADDRESS = 409;
344     uint256 internal constant ERC20_MINT_TO_ZERO_ADDRESS = 410;
345     uint256 internal constant ERC20_BURN_FROM_ZERO_ADDRESS = 411;
346     uint256 internal constant ERC20_APPROVE_FROM_ZERO_ADDRESS = 412;
347     uint256 internal constant ERC20_APPROVE_TO_ZERO_ADDRESS = 413;
348     uint256 internal constant ERC20_TRANSFER_EXCEEDS_ALLOWANCE = 414;
349     uint256 internal constant ERC20_DECREASED_ALLOWANCE_BELOW_ZERO = 415;
350     uint256 internal constant ERC20_TRANSFER_EXCEEDS_BALANCE = 416;
351     uint256 internal constant ERC20_BURN_EXCEEDS_ALLOWANCE = 417;
352     uint256 internal constant SAFE_ERC20_CALL_FAILED = 418;
353     uint256 internal constant ADDRESS_INSUFFICIENT_BALANCE = 419;
354     uint256 internal constant ADDRESS_CANNOT_SEND_VALUE = 420;
355     uint256 internal constant SAFE_CAST_VALUE_CANT_FIT_INT256 = 421;
356     uint256 internal constant GRANT_SENDER_NOT_ADMIN = 422;
357     uint256 internal constant REVOKE_SENDER_NOT_ADMIN = 423;
358     uint256 internal constant RENOUNCE_SENDER_NOT_ALLOWED = 424;
359     uint256 internal constant BUFFER_PERIOD_EXPIRED = 425;
360     uint256 internal constant CALLER_IS_NOT_OWNER = 426;
361     uint256 internal constant NEW_OWNER_IS_ZERO = 427;
362     uint256 internal constant CODE_DEPLOYMENT_FAILED = 428;
363     uint256 internal constant CALL_TO_NON_CONTRACT = 429;
364     uint256 internal constant LOW_LEVEL_CALL_FAILED = 430;
365     uint256 internal constant NOT_PAUSED = 431;
366     uint256 internal constant ADDRESS_ALREADY_ALLOWLISTED = 432;
367     uint256 internal constant ADDRESS_NOT_ALLOWLISTED = 433;
368     uint256 internal constant ERC20_BURN_EXCEEDS_BALANCE = 434;
369 
370     // Vault
371     uint256 internal constant INVALID_POOL_ID = 500;
372     uint256 internal constant CALLER_NOT_POOL = 501;
373     uint256 internal constant SENDER_NOT_ASSET_MANAGER = 502;
374     uint256 internal constant USER_DOESNT_ALLOW_RELAYER = 503;
375     uint256 internal constant INVALID_SIGNATURE = 504;
376     uint256 internal constant EXIT_BELOW_MIN = 505;
377     uint256 internal constant JOIN_ABOVE_MAX = 506;
378     uint256 internal constant SWAP_LIMIT = 507;
379     uint256 internal constant SWAP_DEADLINE = 508;
380     uint256 internal constant CANNOT_SWAP_SAME_TOKEN = 509;
381     uint256 internal constant UNKNOWN_AMOUNT_IN_FIRST_SWAP = 510;
382     uint256 internal constant MALCONSTRUCTED_MULTIHOP_SWAP = 511;
383     uint256 internal constant INTERNAL_BALANCE_OVERFLOW = 512;
384     uint256 internal constant INSUFFICIENT_INTERNAL_BALANCE = 513;
385     uint256 internal constant INVALID_ETH_INTERNAL_BALANCE = 514;
386     uint256 internal constant INVALID_POST_LOAN_BALANCE = 515;
387     uint256 internal constant INSUFFICIENT_ETH = 516;
388     uint256 internal constant UNALLOCATED_ETH = 517;
389     uint256 internal constant ETH_TRANSFER = 518;
390     uint256 internal constant CANNOT_USE_ETH_SENTINEL = 519;
391     uint256 internal constant TOKENS_MISMATCH = 520;
392     uint256 internal constant TOKEN_NOT_REGISTERED = 521;
393     uint256 internal constant TOKEN_ALREADY_REGISTERED = 522;
394     uint256 internal constant TOKENS_ALREADY_SET = 523;
395     uint256 internal constant TOKENS_LENGTH_MUST_BE_2 = 524;
396     uint256 internal constant NONZERO_TOKEN_BALANCE = 525;
397     uint256 internal constant BALANCE_TOTAL_OVERFLOW = 526;
398     uint256 internal constant POOL_NO_TOKENS = 527;
399     uint256 internal constant INSUFFICIENT_FLASH_LOAN_BALANCE = 528;
400 
401     // Fees
402     uint256 internal constant SWAP_FEE_PERCENTAGE_TOO_HIGH = 600;
403     uint256 internal constant FLASH_LOAN_FEE_PERCENTAGE_TOO_HIGH = 601;
404     uint256 internal constant INSUFFICIENT_FLASH_LOAN_FEE_AMOUNT = 602;
405 }
406 
407 // File: https://github.com/overlay-market/v1-core/blob/main/contracts/libraries/LogExpMath.sol
408 
409 
410 // Permission is hereby granted, free of charge, to any person obtaining a copy of
411 // this software and associated documentation files (the “Software”), to deal in the
412 // Software without restriction, including without limitation the rights to use,
413 // copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the
414 // Software, and to permit persons to whom the Software is furnished to do so,
415 // subject to the following conditions:
416 
417 // The above copyright notice and this permission notice shall be included in all
418 // copies or substantial portions of the Software.
419 
420 // THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
421 // INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
422 // PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
423 // COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
424 // IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
425 // WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
426 //
427 // COPIED AND MODIFIED FROM:
428 // @balancer-v2-monorepo/pkg/solidity-utils/contracts/math/LogExpMath.sol
429 // XXX for changes
430 
431 // XXX: 0.8.10; unchecked functions
432 pragma solidity 0.8.10;
433 
434 
435 /* solhint-disable */
436 
437 /**
438  * @dev Exponentiation and logarithm functions for 18 decimal fixed point numbers (both base and exponent/argument).
439  *
440  * Exponentiation and logarithm with arbitrary bases (x^y and log_x(y)) are implemented by conversion to natural
441  * exponentiation and logarithm (where the base is Euler's number).
442  *
443  * @author Fernando Martinelli - @fernandomartinelli
444  * @author Sergio Yuhjtman - @sergioyuhjtman
445  * @author Daniel Fernandez - @dmf7z
446  */
447 library LogExpMath {
448     // All fixed point multiplications and divisions are inlined. This means we need to divide by ONE when multiplying
449     // two numbers, and multiply by ONE when dividing them.
450 
451     // All arguments and return values are 18 decimal fixed point numbers.
452     int256 constant ONE_18 = 1e18;
453 
454     // Internally, intermediate values are computed with higher precision as 20 decimal fixed point numbers, and in the
455     // case of ln36, 36 decimals.
456     int256 constant ONE_20 = 1e20;
457     int256 constant ONE_36 = 1e36;
458 
459     // The domain of natural exponentiation is bound by the word size and number of decimals used.
460     //
461     // Because internally the result will be stored using 20 decimals, the largest possible result is
462     // (2^255 - 1) / 10^20, which makes the largest exponent ln((2^255 - 1) / 10^20) = 130.700829182905140221.
463     // The smallest possible result is 10^(-18), which makes largest negative argument
464     // ln(10^(-18)) = -41.446531673892822312.
465     // We use 130.0 and -41.0 to have some safety margin.
466     int256 constant MAX_NATURAL_EXPONENT = 130e18;
467     int256 constant MIN_NATURAL_EXPONENT = -41e18;
468 
469     // Bounds for ln_36's argument. Both ln(0.9) and ln(1.1) can be represented with 36 decimal places in a fixed point
470     // 256 bit integer.
471     int256 constant LN_36_LOWER_BOUND = ONE_18 - 1e17;
472     int256 constant LN_36_UPPER_BOUND = ONE_18 + 1e17;
473 
474     uint256 constant MILD_EXPONENT_BOUND = 2**254 / uint256(ONE_20);
475 
476     // 18 decimal constants
477     int256 constant x0 = 128000000000000000000; // 2ˆ7
478     int256 constant a0 = 38877084059945950922200000000000000000000000000000000000; // eˆ(x0) (no decimals)
479     int256 constant x1 = 64000000000000000000; // 2ˆ6
480     int256 constant a1 = 6235149080811616882910000000; // eˆ(x1) (no decimals)
481 
482     // 20 decimal constants
483     int256 constant x2 = 3200000000000000000000; // 2ˆ5
484     int256 constant a2 = 7896296018268069516100000000000000; // eˆ(x2)
485     int256 constant x3 = 1600000000000000000000; // 2ˆ4
486     int256 constant a3 = 888611052050787263676000000; // eˆ(x3)
487     int256 constant x4 = 800000000000000000000; // 2ˆ3
488     int256 constant a4 = 298095798704172827474000; // eˆ(x4)
489     int256 constant x5 = 400000000000000000000; // 2ˆ2
490     int256 constant a5 = 5459815003314423907810; // eˆ(x5)
491     int256 constant x6 = 200000000000000000000; // 2ˆ1
492     int256 constant a6 = 738905609893065022723; // eˆ(x6)
493     int256 constant x7 = 100000000000000000000; // 2ˆ0
494     int256 constant a7 = 271828182845904523536; // eˆ(x7)
495     int256 constant x8 = 50000000000000000000; // 2ˆ-1
496     int256 constant a8 = 164872127070012814685; // eˆ(x8)
497     int256 constant x9 = 25000000000000000000; // 2ˆ-2
498     int256 constant a9 = 128402541668774148407; // eˆ(x9)
499     int256 constant x10 = 12500000000000000000; // 2ˆ-3
500     int256 constant a10 = 113314845306682631683; // eˆ(x10)
501     int256 constant x11 = 6250000000000000000; // 2ˆ-4
502     int256 constant a11 = 106449445891785942956; // eˆ(x11)
503 
504     /**
505      * @dev Exponentiation (x^y) with unsigned 18 decimal fixed point base and exponent.
506      *
507      * Reverts if ln(x) * y is smaller than `MIN_NATURAL_EXPONENT`, or larger than `MAX_NATURAL_EXPONENT`.
508      */
509     function pow(uint256 x, uint256 y) internal pure returns (uint256) {
510         unchecked {
511             if (y == 0) {
512                 // We solve the 0^0 indetermination by making it equal one.
513                 return uint256(ONE_18);
514             }
515 
516             if (x == 0) {
517                 return 0;
518             }
519 
520             // Instead of computing x^y directly, we instead rely on the properties of logarithms and exponentiation to
521             // arrive at that result. In particular, exp(ln(x)) = x, and ln(x^y) = y * ln(x). This means
522             // x^y = exp(y * ln(x)).
523 
524             // The ln function takes a signed value, so we need to make sure x fits in the signed 256 bit range.
525             _require(x < 2**255, Errors.X_OUT_OF_BOUNDS);
526             int256 x_int256 = int256(x);
527 
528             // We will compute y * ln(x) in a single step. Depending on the value of x, we can either use ln or ln_36. In
529             // both cases, we leave the division by ONE_18 (due to fixed point multiplication) to the end.
530 
531             // This prevents y * ln(x) from overflowing, and at the same time guarantees y fits in the signed 256 bit range.
532             _require(y < MILD_EXPONENT_BOUND, Errors.Y_OUT_OF_BOUNDS);
533             int256 y_int256 = int256(y);
534 
535             int256 logx_times_y;
536             if (LN_36_LOWER_BOUND < x_int256 && x_int256 < LN_36_UPPER_BOUND) {
537                 int256 ln_36_x = _ln_36(x_int256);
538 
539                 // ln_36_x has 36 decimal places, so multiplying by y_int256 isn't as straightforward, since we can't just
540                 // bring y_int256 to 36 decimal places, as it might overflow. Instead, we perform two 18 decimal
541                 // multiplications and add the results: one with the first 18 decimals of ln_36_x, and one with the
542                 // (downscaled) last 18 decimals.
543                 logx_times_y = ((ln_36_x / ONE_18) *
544                     y_int256 +
545                     ((ln_36_x % ONE_18) * y_int256) /
546                     ONE_18);
547             } else {
548                 logx_times_y = _ln(x_int256) * y_int256;
549             }
550             logx_times_y /= ONE_18;
551 
552             // Finally, we compute exp(y * ln(x)) to arrive at x^y
553             _require(
554                 MIN_NATURAL_EXPONENT <= logx_times_y && logx_times_y <= MAX_NATURAL_EXPONENT,
555                 Errors.PRODUCT_OUT_OF_BOUNDS
556             );
557 
558             return uint256(exp(logx_times_y));
559         }
560     }
561 
562     /**
563      * @dev Natural exponentiation (e^x) with signed 18 decimal fixed point exponent.
564      *
565      * Reverts if `x` is smaller than MIN_NATURAL_EXPONENT, or larger than `MAX_NATURAL_EXPONENT`.
566      */
567     function exp(int256 x) internal pure returns (int256) {
568         _require(x >= MIN_NATURAL_EXPONENT && x <= MAX_NATURAL_EXPONENT, Errors.INVALID_EXPONENT);
569 
570         unchecked {
571             if (x < 0) {
572                 // We only handle positive exponents: e^(-x) is computed as 1 / e^x. We can safely make x positive since it
573                 // fits in the signed 256 bit range (as it is larger than MIN_NATURAL_EXPONENT).
574                 // Fixed point division requires multiplying by ONE_18.
575                 return ((ONE_18 * ONE_18) / exp(-x));
576             }
577 
578             // First, we use the fact that e^(x+y) = e^x * e^y to decompose x into a sum of powers of two, which we call x_n,
579             // where x_n == 2^(7 - n), and e^x_n = a_n has been precomputed. We choose the first x_n, x0, to equal 2^7
580             // because all larger powers are larger than MAX_NATURAL_EXPONENT, and therefore not present in the
581             // decomposition.
582             // At the end of this process we will have the product of all e^x_n = a_n that apply, and the remainder of this
583             // decomposition, which will be lower than the smallest x_n.
584             // exp(x) = k_0 * a_0 * k_1 * a_1 * ... + k_n * a_n * exp(remainder), where each k_n equals either 0 or 1.
585             // We mutate x by subtracting x_n, making it the remainder of the decomposition.
586 
587             // The first two a_n (e^(2^7) and e^(2^6)) are too large if stored as 18 decimal numbers, and could cause
588             // intermediate overflows. Instead we store them as plain integers, with 0 decimals.
589             // Additionally, x0 + x1 is larger than MAX_NATURAL_EXPONENT, which means they will not both be present in the
590             // decomposition.
591 
592             // For each x_n, we test if that term is present in the decomposition (if x is larger than it), and if so deduct
593             // it and compute the accumulated product.
594 
595             int256 firstAN;
596             if (x >= x0) {
597                 x -= x0;
598                 firstAN = a0;
599             } else if (x >= x1) {
600                 x -= x1;
601                 firstAN = a1;
602             } else {
603                 firstAN = 1; // One with no decimal places
604             }
605 
606             // We now transform x into a 20 decimal fixed point number, to have enhanced precision when computing the
607             // smaller terms.
608             x *= 100;
609 
610             // `product` is the accumulated product of all a_n (except a0 and a1), which starts at 20 decimal fixed point
611             // one. Recall that fixed point multiplication requires dividing by ONE_20.
612             int256 product = ONE_20;
613 
614             if (x >= x2) {
615                 x -= x2;
616                 product = (product * a2) / ONE_20;
617             }
618             if (x >= x3) {
619                 x -= x3;
620                 product = (product * a3) / ONE_20;
621             }
622             if (x >= x4) {
623                 x -= x4;
624                 product = (product * a4) / ONE_20;
625             }
626             if (x >= x5) {
627                 x -= x5;
628                 product = (product * a5) / ONE_20;
629             }
630             if (x >= x6) {
631                 x -= x6;
632                 product = (product * a6) / ONE_20;
633             }
634             if (x >= x7) {
635                 x -= x7;
636                 product = (product * a7) / ONE_20;
637             }
638             if (x >= x8) {
639                 x -= x8;
640                 product = (product * a8) / ONE_20;
641             }
642             if (x >= x9) {
643                 x -= x9;
644                 product = (product * a9) / ONE_20;
645             }
646 
647             // x10 and x11 are unnecessary here since we have high enough precision already.
648 
649             // Now we need to compute e^x, where x is small (in particular, it is smaller than x9). We use the Taylor series
650             // expansion for e^x: 1 + x + (x^2 / 2!) + (x^3 / 3!) + ... + (x^n / n!).
651 
652             int256 seriesSum = ONE_20; // The initial one in the sum, with 20 decimal places.
653             int256 term; // Each term in the sum, where the nth term is (x^n / n!).
654 
655             // The first term is simply x.
656             term = x;
657             seriesSum += term;
658 
659             // Each term (x^n / n!) equals the previous one times x, divided by n. Since x is a fixed point number,
660             // multiplying by it requires dividing by ONE_20, but dividing by the non-fixed point n values does not.
661 
662             term = ((term * x) / ONE_20) / 2;
663             seriesSum += term;
664 
665             term = ((term * x) / ONE_20) / 3;
666             seriesSum += term;
667 
668             term = ((term * x) / ONE_20) / 4;
669             seriesSum += term;
670 
671             term = ((term * x) / ONE_20) / 5;
672             seriesSum += term;
673 
674             term = ((term * x) / ONE_20) / 6;
675             seriesSum += term;
676 
677             term = ((term * x) / ONE_20) / 7;
678             seriesSum += term;
679 
680             term = ((term * x) / ONE_20) / 8;
681             seriesSum += term;
682 
683             term = ((term * x) / ONE_20) / 9;
684             seriesSum += term;
685 
686             term = ((term * x) / ONE_20) / 10;
687             seriesSum += term;
688 
689             term = ((term * x) / ONE_20) / 11;
690             seriesSum += term;
691 
692             term = ((term * x) / ONE_20) / 12;
693             seriesSum += term;
694 
695             // 12 Taylor terms are sufficient for 18 decimal precision.
696 
697             // We now have the first a_n (with no decimals), and the product of all other a_n present, and the Taylor
698             // approximation of the exponentiation of the remainder (both with 20 decimals). All that remains is to multiply
699             // all three (one 20 decimal fixed point multiplication, dividing by ONE_20, and one integer multiplication),
700             // and then drop two digits to return an 18 decimal value.
701 
702             return (((product * seriesSum) / ONE_20) * firstAN) / 100;
703         }
704     }
705 
706     /**
707      * @dev Logarithm (log(arg, base), with signed 18 decimal fixed point base and argument.
708      */
709     function log(int256 arg, int256 base) internal pure returns (int256) {
710         // This performs a simple base change: log(arg, base) = ln(arg) / ln(base).
711 
712         unchecked {
713             // Both logBase and logArg are computed as 36 decimal fixed point numbers, either by using ln_36, or by
714             // upscaling.
715 
716             int256 logBase;
717             if (LN_36_LOWER_BOUND < base && base < LN_36_UPPER_BOUND) {
718                 logBase = _ln_36(base);
719             } else {
720                 logBase = _ln(base) * ONE_18;
721             }
722 
723             int256 logArg;
724             if (LN_36_LOWER_BOUND < arg && arg < LN_36_UPPER_BOUND) {
725                 logArg = _ln_36(arg);
726             } else {
727                 logArg = _ln(arg) * ONE_18;
728             }
729 
730             // When dividing, we multiply by ONE_18 to arrive at a result with 18 decimal places
731             return (logArg * ONE_18) / logBase;
732         }
733     }
734 
735     /**
736      * @dev Natural logarithm (ln(a)) with signed 18 decimal fixed point argument.
737      */
738     function ln(int256 a) internal pure returns (int256) {
739         // The real natural logarithm is not defined for negative numbers or zero.
740         _require(a > 0, Errors.OUT_OF_BOUNDS);
741 
742         unchecked {
743             if (LN_36_LOWER_BOUND < a && a < LN_36_UPPER_BOUND) {
744                 return _ln_36(a) / ONE_18;
745             } else {
746                 return _ln(a);
747             }
748         }
749     }
750 
751     /**
752      * @dev Internal natural logarithm (ln(a)) with signed 18 decimal fixed point argument.
753      */
754     function _ln(int256 a) private pure returns (int256) {
755         unchecked {
756             if (a < ONE_18) {
757                 // Since ln(a^k) = k * ln(a), we can compute ln(a) as ln(a) = ln((1/a)^(-1)) = - ln((1/a)). If a is less
758                 // than one, 1/a will be greater than one, and this if statement will not be entered in the recursive call.
759                 // Fixed point division requires multiplying by ONE_18.
760                 return (-_ln((ONE_18 * ONE_18) / a));
761             }
762 
763             // First, we use the fact that ln^(a * b) = ln(a) + ln(b) to decompose ln(a) into a sum of powers of two, which
764             // we call x_n, where x_n == 2^(7 - n), which are the natural logarithm of precomputed quantities a_n (that is,
765             // ln(a_n) = x_n). We choose the first x_n, x0, to equal 2^7 because the exponential of all larger powers cannot
766             // be represented as 18 fixed point decimal numbers in 256 bits, and are therefore larger than a.
767             // At the end of this process we will have the sum of all x_n = ln(a_n) that apply, and the remainder of this
768             // decomposition, which will be lower than the smallest a_n.
769             // ln(a) = k_0 * x_0 + k_1 * x_1 + ... + k_n * x_n + ln(remainder), where each k_n equals either 0 or 1.
770             // We mutate a by subtracting a_n, making it the remainder of the decomposition.
771 
772             // For reasons related to how `exp` works, the first two a_n (e^(2^7) and e^(2^6)) are not stored as fixed point
773             // numbers with 18 decimals, but instead as plain integers with 0 decimals, so we need to multiply them by
774             // ONE_18 to convert them to fixed point.
775             // For each a_n, we test if that term is present in the decomposition (if a is larger than it), and if so divide
776             // by it and compute the accumulated sum.
777 
778             int256 sum = 0;
779             if (a >= a0 * ONE_18) {
780                 a /= a0; // Integer, not fixed point division
781                 sum += x0;
782             }
783 
784             if (a >= a1 * ONE_18) {
785                 a /= a1; // Integer, not fixed point division
786                 sum += x1;
787             }
788 
789             // All other a_n and x_n are stored as 20 digit fixed point numbers, so we convert the sum and a to this format.
790             sum *= 100;
791             a *= 100;
792 
793             // Because further a_n are  20 digit fixed point numbers, we multiply by ONE_20 when dividing by them.
794 
795             if (a >= a2) {
796                 a = (a * ONE_20) / a2;
797                 sum += x2;
798             }
799 
800             if (a >= a3) {
801                 a = (a * ONE_20) / a3;
802                 sum += x3;
803             }
804 
805             if (a >= a4) {
806                 a = (a * ONE_20) / a4;
807                 sum += x4;
808             }
809 
810             if (a >= a5) {
811                 a = (a * ONE_20) / a5;
812                 sum += x5;
813             }
814 
815             if (a >= a6) {
816                 a = (a * ONE_20) / a6;
817                 sum += x6;
818             }
819 
820             if (a >= a7) {
821                 a = (a * ONE_20) / a7;
822                 sum += x7;
823             }
824 
825             if (a >= a8) {
826                 a = (a * ONE_20) / a8;
827                 sum += x8;
828             }
829 
830             if (a >= a9) {
831                 a = (a * ONE_20) / a9;
832                 sum += x9;
833             }
834 
835             if (a >= a10) {
836                 a = (a * ONE_20) / a10;
837                 sum += x10;
838             }
839 
840             if (a >= a11) {
841                 a = (a * ONE_20) / a11;
842                 sum += x11;
843             }
844 
845             // a is now a small number (smaller than a_11, which roughly equals 1.06). This means we can use a Taylor series
846             // that converges rapidly for values of `a` close to one - the same one used in ln_36.
847             // Let z = (a - 1) / (a + 1).
848             // ln(a) = 2 * (z + z^3 / 3 + z^5 / 5 + z^7 / 7 + ... + z^(2 * n + 1) / (2 * n + 1))
849 
850             // Recall that 20 digit fixed point division requires multiplying by ONE_20, and multiplication requires
851             // division by ONE_20.
852             int256 z = ((a - ONE_20) * ONE_20) / (a + ONE_20);
853             int256 z_squared = (z * z) / ONE_20;
854 
855             // num is the numerator of the series: the z^(2 * n + 1) term
856             int256 num = z;
857 
858             // seriesSum holds the accumulated sum of each term in the series, starting with the initial z
859             int256 seriesSum = num;
860 
861             // In each step, the numerator is multiplied by z^2
862             num = (num * z_squared) / ONE_20;
863             seriesSum += num / 3;
864 
865             num = (num * z_squared) / ONE_20;
866             seriesSum += num / 5;
867 
868             num = (num * z_squared) / ONE_20;
869             seriesSum += num / 7;
870 
871             num = (num * z_squared) / ONE_20;
872             seriesSum += num / 9;
873 
874             num = (num * z_squared) / ONE_20;
875             seriesSum += num / 11;
876 
877             // 6 Taylor terms are sufficient for 36 decimal precision.
878 
879             // Finally, we multiply by 2 (non fixed point) to compute ln(remainder)
880             seriesSum *= 2;
881 
882             // We now have the sum of all x_n present, and the Taylor approximation of the logarithm of the remainder (both
883             // with 20 decimals). All that remains is to sum these two, and then drop two digits to return a 18 decimal
884             // value.
885 
886             return (sum + seriesSum) / 100;
887         }
888     }
889 
890     /**
891      * @dev Intrnal high precision (36 decimal places) natural logarithm (ln(x)) with signed 18 decimal fixed point argument,
892      * for x close to one.
893      *
894      * Should only be used if x is between LN_36_LOWER_BOUND and LN_36_UPPER_BOUND.
895      */
896     function _ln_36(int256 x) private pure returns (int256) {
897         unchecked {
898             // Since ln(1) = 0, a value of x close to one will yield a very small result, which makes using 36 digits
899             // worthwhile.
900 
901             // First, we transform x to a 36 digit fixed point value.
902             x *= ONE_18;
903 
904             // We will use the following Taylor expansion, which converges very rapidly. Let z = (x - 1) / (x + 1).
905             // ln(x) = 2 * (z + z^3 / 3 + z^5 / 5 + z^7 / 7 + ... + z^(2 * n + 1) / (2 * n + 1))
906 
907             // Recall that 36 digit fixed point division requires multiplying by ONE_36, and multiplication requires
908             // division by ONE_36.
909             int256 z = ((x - ONE_36) * ONE_36) / (x + ONE_36);
910             int256 z_squared = (z * z) / ONE_36;
911 
912             // num is the numerator of the series: the z^(2 * n + 1) term
913             int256 num = z;
914 
915             // seriesSum holds the accumulated sum of each term in the series, starting with the initial z
916             int256 seriesSum = num;
917 
918             // In each step, the numerator is multiplied by z^2
919             num = (num * z_squared) / ONE_36;
920             seriesSum += num / 3;
921 
922             num = (num * z_squared) / ONE_36;
923             seriesSum += num / 5;
924 
925             num = (num * z_squared) / ONE_36;
926             seriesSum += num / 7;
927 
928             num = (num * z_squared) / ONE_36;
929             seriesSum += num / 9;
930 
931             num = (num * z_squared) / ONE_36;
932             seriesSum += num / 11;
933 
934             num = (num * z_squared) / ONE_36;
935             seriesSum += num / 13;
936 
937             num = (num * z_squared) / ONE_36;
938             seriesSum += num / 15;
939 
940             // 8 Taylor terms are sufficient for 36 decimal precision.
941 
942             // All that remains is multiplying by 2 (non fixed point).
943             return seriesSum * 2;
944         }
945     }
946 }
947 
948 // File: https://github.com/overlay-market/v1-core/blob/main/contracts/libraries/FixedPoint.sol
949 
950 
951 // This program is free software: you can redistribute it and/or modify
952 // it under the terms of the GNU General Public License as published by
953 // the Free Software Foundation, either version 3 of the License, or
954 // (at your option) any later version.
955 
956 // This program is distributed in the hope that it will be useful,
957 // but WITHOUT ANY WARRANTY; without even the implied warranty of
958 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
959 // GNU General Public License for more details.
960 
961 // You should have received a copy of the GNU General Public License
962 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
963 //
964 // COPIED AND MODIFIED FROM:
965 // @balancer-v2-monorepo/pkg/solidity-utils/contracts/math/FixedPoint.sol
966 // XXX for changes
967 
968 // XXX: 0.8.10; removed requires for overflow checks
969 pragma solidity 0.8.10;
970 
971 
972 /* solhint-disable private-vars-leading-underscore */
973 
974 library FixedPoint {
975     uint256 internal constant ONE = 1e18; // 18 decimal places
976     uint256 internal constant TWO = 2 * ONE;
977     uint256 internal constant FOUR = 4 * ONE;
978     uint256 internal constant MAX_POW_RELATIVE_ERROR = 10000; // 10^(-14)
979 
980     // Minimum base for the power function when the exponent is 'free' (larger than ONE).
981     uint256 internal constant MIN_POW_BASE_FREE_EXPONENT = 0.7e18;
982 
983     function add(uint256 a, uint256 b) internal pure returns (uint256) {
984         // Fixed Point addition is the same as regular checked addition
985         uint256 c = a + b;
986         return c;
987     }
988 
989     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
990         // Fixed Point addition is the same as regular checked addition
991         uint256 c = a - b;
992         return c;
993     }
994 
995     /// @notice a - b but floors to zero if a <= b
996     /// XXX: subFloor implementation
997     function subFloor(uint256 a, uint256 b) internal pure returns (uint256) {
998         uint256 c = a > b ? a - b : 0;
999         return c;
1000     }
1001 
1002     function mulDown(uint256 a, uint256 b) internal pure returns (uint256) {
1003         uint256 product = a * b;
1004         return product / ONE;
1005     }
1006 
1007     function mulUp(uint256 a, uint256 b) internal pure returns (uint256) {
1008         uint256 product = a * b;
1009         if (product == 0) {
1010             return 0;
1011         } else {
1012             // The traditional divUp formula is:
1013             // divUp(x, y) := (x + y - 1) / y
1014             // To avoid intermediate overflow in the addition, we distribute the division and get:
1015             // divUp(x, y) := (x - 1) / y + 1
1016             // Note that this requires x != 0, which we already tested for.
1017             return ((product - 1) / ONE) + 1;
1018         }
1019     }
1020 
1021     function divDown(uint256 a, uint256 b) internal pure returns (uint256) {
1022         if (a == 0) {
1023             return 0;
1024         } else {
1025             uint256 aInflated = a * ONE;
1026             return aInflated / b;
1027         }
1028     }
1029 
1030     function divUp(uint256 a, uint256 b) internal pure returns (uint256) {
1031         if (a == 0) {
1032             return 0;
1033         } else {
1034             uint256 aInflated = a * ONE;
1035             // The traditional divUp formula is:
1036             // divUp(x, y) := (x + y - 1) / y
1037             // To avoid intermediate overflow in the addition, we distribute the division and get:
1038             // divUp(x, y) := (x - 1) / y + 1
1039             // Note that this requires x != 0, which we already tested for.
1040             return ((aInflated - 1) / b) + 1;
1041         }
1042     }
1043 
1044     /**
1045      * @dev Returns x^y, assuming both are fixed point numbers, rounding down.
1046      * The result is guaranteed to not be above the true value (that is,
1047      * the error function expected - actual is always positive).
1048      */
1049     function powDown(uint256 x, uint256 y) internal pure returns (uint256) {
1050         // Optimize for when y equals 1.0, 2.0 or 4.0, as those are very simple
1051         // to implement and occur often in 50/50 and 80/20 Weighted Pools
1052         // XXX: checks for y == 0, x == ONE, x == 0
1053         if (0 == y || x == ONE) {
1054             return ONE;
1055         } else if (x == 0) {
1056             return 0;
1057         } else if (y == ONE) {
1058             return x;
1059         } else if (y == TWO) {
1060             return mulDown(x, x);
1061         } else if (y == FOUR) {
1062             uint256 square = mulDown(x, x);
1063             return mulDown(square, square);
1064         } else {
1065             uint256 raw = LogExpMath.pow(x, y);
1066             uint256 maxError = add(mulUp(raw, MAX_POW_RELATIVE_ERROR), 1);
1067 
1068             if (raw < maxError) {
1069                 return 0;
1070             } else {
1071                 return sub(raw, maxError);
1072             }
1073         }
1074     }
1075 
1076     /**
1077      * @dev Returns x^y, assuming both are fixed point numbers, rounding up.
1078      * The result is guaranteed to not be below the true value (that is,
1079      * the error function expected - actual is always negative).
1080      */
1081     function powUp(uint256 x, uint256 y) internal pure returns (uint256) {
1082         // Optimize for when y equals 1.0, 2.0 or 4.0, as those are very simple
1083         // to implement and occur often in 50/50 and 80/20 Weighted Pools
1084         // XXX: checks for y == 0, x == ONE, x == 0
1085         if (0 == y || x == ONE) {
1086             return ONE;
1087         } else if (x == 0) {
1088             return 0;
1089         } else if (y == ONE) {
1090             return x;
1091         } else if (y == TWO) {
1092             return mulUp(x, x);
1093         } else if (y == FOUR) {
1094             uint256 square = mulUp(x, x);
1095             return mulUp(square, square);
1096         } else {
1097             uint256 raw = LogExpMath.pow(x, y);
1098             uint256 maxError = add(mulUp(raw, MAX_POW_RELATIVE_ERROR), 1);
1099 
1100             return add(raw, maxError);
1101         }
1102     }
1103 
1104     /**
1105      * @dev Returns e^x, assuming x is a fixed point number, rounding down.
1106      * The result is guaranteed to not be above the true value (that is,
1107      * the error function expected - actual is always positive).
1108      * XXX: expDown implementation
1109      */
1110     function expDown(uint256 x) internal pure returns (uint256) {
1111         if (x == 0) {
1112             return ONE;
1113         }
1114         require(x < 2**255, "FixedPoint: x out of bounds");
1115 
1116         int256 x_int256 = int256(x);
1117         uint256 raw = uint256(LogExpMath.exp(x_int256));
1118         uint256 maxError = add(mulUp(raw, MAX_POW_RELATIVE_ERROR), 1);
1119 
1120         if (raw < maxError) {
1121             return 0;
1122         } else {
1123             return sub(raw, maxError);
1124         }
1125     }
1126 
1127     /**
1128      * @dev Returns e^x, assuming x is a fixed point number, rounding up.
1129      * The result is guaranteed to not be below the true value (that is,
1130      * the error function expected - actual is always negative).
1131      * XXX: expUp implementation
1132      */
1133     function expUp(uint256 x) internal pure returns (uint256) {
1134         if (x == 0) {
1135             return ONE;
1136         }
1137         require(x < 2**255, "FixedPoint: x out of bounds");
1138 
1139         int256 x_int256 = int256(x);
1140         uint256 raw = uint256(LogExpMath.exp(x_int256));
1141         uint256 maxError = add(mulUp(raw, MAX_POW_RELATIVE_ERROR), 1);
1142 
1143         return add(raw, maxError);
1144     }
1145 
1146     /**
1147      * @dev Returns log_b(a), assuming a, b are fixed point numbers, rounding down.
1148      * The result is guaranteed to not be above the true value (that is,
1149      * the error function expected - actual is always positive).
1150      * XXX: logDown implementation
1151      */
1152     function logDown(uint256 a, uint256 b) internal pure returns (int256) {
1153         require(a > 0 && a < 2**255, "FixedPoint: a out of bounds");
1154         require(b > 0 && b < 2**255, "FixedPoint: b out of bounds");
1155 
1156         int256 arg = int256(a);
1157         int256 base = int256(b);
1158         int256 raw = LogExpMath.log(arg, base);
1159 
1160         // NOTE: see @openzeppelin/contracts/utils/math/SignedMath.sol#L37
1161         uint256 rawAbs;
1162         unchecked {
1163             rawAbs = uint256(raw >= 0 ? raw : -raw);
1164         }
1165         uint256 maxError = add(mulUp(rawAbs, MAX_POW_RELATIVE_ERROR), 1);
1166         return raw - int256(maxError);
1167     }
1168 
1169     /**
1170      * @dev Returns log_b(a), assuming a, b are fixed point numbers, rounding up.
1171      * The result is guaranteed to not be below the true value (that is,
1172      * the error function expected - actual is always negative).
1173      * XXX: logUp implementation
1174      */
1175     function logUp(uint256 a, uint256 b) internal pure returns (int256) {
1176         require(a > 0 && a < 2**255, "FixedPoint: a out of bounds");
1177         require(b > 0 && b < 2**255, "FixedPoint: b out of bounds");
1178 
1179         int256 arg = int256(a);
1180         int256 base = int256(b);
1181         int256 raw = LogExpMath.log(arg, base);
1182 
1183         // NOTE: see @openzeppelin/contracts/utils/math/SignedMath.sol#L37
1184         uint256 rawAbs;
1185         unchecked {
1186             rawAbs = uint256(raw >= 0 ? raw : -raw);
1187         }
1188         uint256 maxError = add(mulUp(rawAbs, MAX_POW_RELATIVE_ERROR), 1);
1189         return raw + int256(maxError);
1190     }
1191 
1192     /**
1193      * @dev Returns the complement of a value (1 - x), capped to 0 if x is larger than 1.
1194      *
1195      * Useful when computing the complement for values with some level of relative error,
1196      * as it strips this error and prevents intermediate negative values.
1197      */
1198     function complement(uint256 x) internal pure returns (uint256) {
1199         return (x < ONE) ? (ONE - x) : 0;
1200     }
1201 }
1202 
1203 // File: https://github.com/overlay-market/v1-core/blob/main/contracts/libraries/Cast.sol
1204 
1205 
1206 pragma solidity 0.8.10;
1207 
1208 library Cast {
1209     /// @dev casts an uint256 to an uint32 bounded by uint32 range of values
1210     /// @dev to avoid reverts and overflows
1211     function toUint32Bounded(uint256 value) internal pure returns (uint32) {
1212         uint32 value32 = (value <= type(uint32).max) ? uint32(value) : type(uint32).max;
1213         return value32;
1214     }
1215 
1216     /// @dev casts an int256 to an int192 bounded by int192 range of values
1217     /// @dev to avoid reverts and overflows
1218     function toInt192Bounded(int256 value) internal pure returns (int192) {
1219         int192 value192 = value < type(int192).min
1220             ? type(int192).min
1221             : (value > type(int192).max ? type(int192).max : int192(value));
1222         return value192;
1223     }
1224 }
1225 
1226 // File: @openzeppelin/contracts/utils/math/SignedMath.sol
1227 
1228 
1229 // OpenZeppelin Contracts (last updated v4.5.0) (utils/math/SignedMath.sol)
1230 
1231 pragma solidity ^0.8.0;
1232 
1233 /**
1234  * @dev Standard signed math utilities missing in the Solidity language.
1235  */
1236 library SignedMath {
1237     /**
1238      * @dev Returns the largest of two signed numbers.
1239      */
1240     function max(int256 a, int256 b) internal pure returns (int256) {
1241         return a >= b ? a : b;
1242     }
1243 
1244     /**
1245      * @dev Returns the smallest of two signed numbers.
1246      */
1247     function min(int256 a, int256 b) internal pure returns (int256) {
1248         return a < b ? a : b;
1249     }
1250 
1251     /**
1252      * @dev Returns the average of two signed numbers without overflow.
1253      * The result is rounded towards zero.
1254      */
1255     function average(int256 a, int256 b) internal pure returns (int256) {
1256         // Formula from the book "Hacker's Delight"
1257         int256 x = (a & b) + ((a ^ b) >> 1);
1258         return x + (int256(uint256(x) >> 255) & (a ^ b));
1259     }
1260 
1261     /**
1262      * @dev Returns the absolute unsigned value of a signed value.
1263      */
1264     function abs(int256 n) internal pure returns (uint256) {
1265         unchecked {
1266             // must be unchecked in order to support `n = type(int256).min`
1267             return uint256(n >= 0 ? n : -n);
1268         }
1269     }
1270 }
1271 
1272 // File: https://github.com/overlay-market/v1-core/blob/main/contracts/libraries/Tick.sol
1273 
1274 
1275 pragma solidity 0.8.10;
1276 
1277 
1278 
1279 library Tick {
1280     using FixedPoint for uint256;
1281     using SignedMath for int256;
1282 
1283     uint256 internal constant ONE = 1e18;
1284     uint256 internal constant PRICE_BASE = 1.0001e18;
1285     int256 internal constant MAX_TICK_256 = 120e22;
1286     int256 internal constant MIN_TICK_256 = -41e22;
1287 
1288     /// @notice Computes the tick associated with the given price
1289     /// @notice where price = 1.0001 ** tick
1290     /// @dev FixedPoint lib constraints on min/max natural exponent of
1291     /// @dev -41e18, 130e18 respectively, means min/max tick will be
1292     /// @dev -41e18/ln(1.0001), 130e18/ln(1.0001), respectively (w some buffer)
1293     function priceToTick(uint256 price) internal pure returns (int24) {
1294         int256 tick256 = price.logDown(PRICE_BASE);
1295         require(tick256 >= MIN_TICK_256 && tick256 <= MAX_TICK_256, "OVLV1: tick out of bounds");
1296 
1297         // tick256 is FixedPoint format with 18 decimals. Divide by ONE
1298         // then truncate to int24
1299         return int24(tick256 / int256(ONE));
1300     }
1301 
1302     /// @notice Computes the price associated with the given tick
1303     /// @notice where price = 1.0001 ** tick
1304     /// @dev FixedPoint lib constraints on min/max natural exponent of
1305     /// @dev -41e18, 130e18 respectively, means min/max tick will be
1306     /// @dev -41e18/ln(1.0001), 130e18/ln(1.0001), respectively (w some buffer)
1307     function tickToPrice(int24 tick) internal pure returns (uint256) {
1308         // tick needs to be converted to Fixed point format with 18 decimals
1309         // to use FixedPoint powUp
1310         int256 tick256 = int256(tick) * int256(ONE);
1311         require(tick256 >= MIN_TICK_256 && tick256 <= MAX_TICK_256, "OVLV1: tick out of bounds");
1312 
1313         uint256 pow = uint256(tick256.abs());
1314         return (tick256 >= 0 ? PRICE_BASE.powDown(pow) : ONE.divDown(PRICE_BASE.powUp(pow)));
1315     }
1316 }
1317 
1318 // File: https://github.com/overlay-market/v1-core/blob/main/contracts/libraries/Roller.sol
1319 
1320 
1321 pragma solidity 0.8.10;
1322 
1323 
1324 
1325 
1326 library Roller {
1327     using Cast for uint256;
1328     using Cast for int256;
1329     using FixedPoint for uint256;
1330     using SignedMath for int256;
1331 
1332     struct Snapshot {
1333         uint32 timestamp; // time last snapshot was taken
1334         uint32 window; // window (length of time) over which will decay
1335         int192 accumulator; // accumulator value which will decay to zero over window
1336     }
1337 
1338     /// @dev returns the stored accumulator value as an int256
1339     function cumulative(Snapshot memory self) internal view returns (int256) {
1340         return int256(self.accumulator);
1341     }
1342 
1343     /// @dev adjusts accumulator value downward linearly over time.
1344     /// @dev accumulator should go to zero as one window passes
1345     function transform(
1346         Snapshot memory self,
1347         uint256 timestamp,
1348         uint256 window,
1349         int256 value
1350     ) internal view returns (Snapshot memory) {
1351         uint32 timestamp32 = uint32(timestamp); // truncated by compiler
1352 
1353         // int/uint256 values to use in calculations
1354         uint256 dt = timestamp32 >= self.timestamp
1355             ? uint256(timestamp32 - self.timestamp)
1356             : uint256(2**32) + uint256(timestamp32) - uint256(self.timestamp);
1357         uint256 snapWindow = uint256(self.window);
1358         int256 snapAccumulator = cumulative(self);
1359 
1360         if (dt >= snapWindow || snapWindow == 0) {
1361             // if one window has passed, prior value has decayed to zero
1362             return
1363                 Snapshot({
1364                     timestamp: timestamp32,
1365                     window: window.toUint32Bounded(),
1366                     accumulator: value.toInt192Bounded()
1367                 });
1368         }
1369 
1370         // otherwise, calculate fraction of value remaining given linear decay.
1371         // fraction of value to take off due to decay (linear drift toward zero)
1372         // is fraction of windowLast that has elapsed since timestampLast
1373         snapAccumulator = (snapAccumulator * int256(snapWindow - dt)) / int256(snapWindow);
1374 
1375         // add in the new value for accumulator now
1376         int256 accumulatorNow = snapAccumulator + value;
1377         if (accumulatorNow == 0) {
1378             // if accumulator now is zero, windowNow is simply window
1379             return
1380                 Snapshot({
1381                     timestamp: timestamp32,
1382                     window: window.toUint32Bounded(),
1383                     accumulator: 0
1384                 });
1385         }
1386 
1387         // recalculate windowNow_ for future decay as a value weighted average time
1388         // of time left in windowLast for accumulatorLast and window for value
1389         // vwat = (|accumulatorLastWithDecay| * (windowLast - dt) + |value| * window) /
1390         //        (|accumulatorLastWithDecay| + |value|)
1391         uint256 w1 = snapAccumulator.abs();
1392         uint256 w2 = value.abs();
1393         uint256 windowNow = (w1 * (snapWindow - dt) + w2 * window) / (w1 + w2);
1394         return
1395             Snapshot({
1396                 timestamp: timestamp32,
1397                 window: windowNow.toUint32Bounded(),
1398                 accumulator: accumulatorNow.toInt192Bounded()
1399             });
1400     }
1401 }
1402 
1403 // File: https://github.com/overlay-market/v1-core/blob/main/contracts/libraries/Oracle.sol
1404 
1405 
1406 pragma solidity 0.8.10;
1407 
1408 library Oracle {
1409     struct Data {
1410         uint256 timestamp;
1411         uint256 microWindow;
1412         uint256 macroWindow;
1413         uint256 priceOverMicroWindow; // p(now) averaged over micro
1414         uint256 priceOverMacroWindow; // p(now) averaged over macro
1415         uint256 priceOneMacroWindowAgo; // p(now - macro) avg over macro
1416         uint256 reserveOverMicroWindow; // r(now) in ovl averaged over micro
1417         bool hasReserve; // whether oracle has manipulable reserve pool
1418     }
1419 }
1420 
1421 // File: https://github.com/overlay-market/v1-core/blob/main/contracts/interfaces/feeds/IOverlayV1Feed.sol
1422 
1423 
1424 pragma solidity 0.8.10;
1425 
1426 
1427 interface IOverlayV1Feed {
1428     // immutables
1429     function feedFactory() external view returns (address);
1430 
1431     function microWindow() external view returns (uint256);
1432 
1433     function macroWindow() external view returns (uint256);
1434 
1435     // returns freshest possible data from oracle
1436     function latest() external view returns (Oracle.Data memory);
1437 }
1438 
1439 // File: @openzeppelin/contracts/access/IAccessControl.sol
1440 
1441 
1442 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
1443 
1444 pragma solidity ^0.8.0;
1445 
1446 /**
1447  * @dev External interface of AccessControl declared to support ERC165 detection.
1448  */
1449 interface IAccessControl {
1450     /**
1451      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
1452      *
1453      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
1454      * {RoleAdminChanged} not being emitted signaling this.
1455      *
1456      * _Available since v3.1._
1457      */
1458     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
1459 
1460     /**
1461      * @dev Emitted when `account` is granted `role`.
1462      *
1463      * `sender` is the account that originated the contract call, an admin role
1464      * bearer except when using {AccessControl-_setupRole}.
1465      */
1466     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
1467 
1468     /**
1469      * @dev Emitted when `account` is revoked `role`.
1470      *
1471      * `sender` is the account that originated the contract call:
1472      *   - if using `revokeRole`, it is the admin role bearer
1473      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
1474      */
1475     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
1476 
1477     /**
1478      * @dev Returns `true` if `account` has been granted `role`.
1479      */
1480     function hasRole(bytes32 role, address account) external view returns (bool);
1481 
1482     /**
1483      * @dev Returns the admin role that controls `role`. See {grantRole} and
1484      * {revokeRole}.
1485      *
1486      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
1487      */
1488     function getRoleAdmin(bytes32 role) external view returns (bytes32);
1489 
1490     /**
1491      * @dev Grants `role` to `account`.
1492      *
1493      * If `account` had not been already granted `role`, emits a {RoleGranted}
1494      * event.
1495      *
1496      * Requirements:
1497      *
1498      * - the caller must have ``role``'s admin role.
1499      */
1500     function grantRole(bytes32 role, address account) external;
1501 
1502     /**
1503      * @dev Revokes `role` from `account`.
1504      *
1505      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1506      *
1507      * Requirements:
1508      *
1509      * - the caller must have ``role``'s admin role.
1510      */
1511     function revokeRole(bytes32 role, address account) external;
1512 
1513     /**
1514      * @dev Revokes `role` from the calling account.
1515      *
1516      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1517      * purpose is to provide a mechanism for accounts to lose their privileges
1518      * if they are compromised (such as when a trusted device is misplaced).
1519      *
1520      * If the calling account had been granted `role`, emits a {RoleRevoked}
1521      * event.
1522      *
1523      * Requirements:
1524      *
1525      * - the caller must be `account`.
1526      */
1527     function renounceRole(bytes32 role, address account) external;
1528 }
1529 
1530 // File: @openzeppelin/contracts/access/IAccessControlEnumerable.sol
1531 
1532 
1533 // OpenZeppelin Contracts v4.4.1 (access/IAccessControlEnumerable.sol)
1534 
1535 pragma solidity ^0.8.0;
1536 
1537 
1538 /**
1539  * @dev External interface of AccessControlEnumerable declared to support ERC165 detection.
1540  */
1541 interface IAccessControlEnumerable is IAccessControl {
1542     /**
1543      * @dev Returns one of the accounts that have `role`. `index` must be a
1544      * value between 0 and {getRoleMemberCount}, non-inclusive.
1545      *
1546      * Role bearers are not sorted in any particular way, and their ordering may
1547      * change at any point.
1548      *
1549      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1550      * you perform all queries on the same block. See the following
1551      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1552      * for more information.
1553      */
1554     function getRoleMember(bytes32 role, uint256 index) external view returns (address);
1555 
1556     /**
1557      * @dev Returns the number of accounts that have `role`. Can be used
1558      * together with {getRoleMember} to enumerate all bearers of a role.
1559      */
1560     function getRoleMemberCount(bytes32 role) external view returns (uint256);
1561 }
1562 
1563 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
1564 
1565 
1566 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
1567 
1568 pragma solidity ^0.8.0;
1569 
1570 /**
1571  * @dev Interface of the ERC20 standard as defined in the EIP.
1572  */
1573 interface IERC20 {
1574     /**
1575      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1576      * another (`to`).
1577      *
1578      * Note that `value` may be zero.
1579      */
1580     event Transfer(address indexed from, address indexed to, uint256 value);
1581 
1582     /**
1583      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1584      * a call to {approve}. `value` is the new allowance.
1585      */
1586     event Approval(address indexed owner, address indexed spender, uint256 value);
1587 
1588     /**
1589      * @dev Returns the amount of tokens in existence.
1590      */
1591     function totalSupply() external view returns (uint256);
1592 
1593     /**
1594      * @dev Returns the amount of tokens owned by `account`.
1595      */
1596     function balanceOf(address account) external view returns (uint256);
1597 
1598     /**
1599      * @dev Moves `amount` tokens from the caller's account to `to`.
1600      *
1601      * Returns a boolean value indicating whether the operation succeeded.
1602      *
1603      * Emits a {Transfer} event.
1604      */
1605     function transfer(address to, uint256 amount) external returns (bool);
1606 
1607     /**
1608      * @dev Returns the remaining number of tokens that `spender` will be
1609      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1610      * zero by default.
1611      *
1612      * This value changes when {approve} or {transferFrom} are called.
1613      */
1614     function allowance(address owner, address spender) external view returns (uint256);
1615 
1616     /**
1617      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1618      *
1619      * Returns a boolean value indicating whether the operation succeeded.
1620      *
1621      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1622      * that someone may use both the old and the new allowance by unfortunate
1623      * transaction ordering. One possible solution to mitigate this race
1624      * condition is to first reduce the spender's allowance to 0 and set the
1625      * desired value afterwards:
1626      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1627      *
1628      * Emits an {Approval} event.
1629      */
1630     function approve(address spender, uint256 amount) external returns (bool);
1631 
1632     /**
1633      * @dev Moves `amount` tokens from `from` to `to` using the
1634      * allowance mechanism. `amount` is then deducted from the caller's
1635      * allowance.
1636      *
1637      * Returns a boolean value indicating whether the operation succeeded.
1638      *
1639      * Emits a {Transfer} event.
1640      */
1641     function transferFrom(
1642         address from,
1643         address to,
1644         uint256 amount
1645     ) external returns (bool);
1646 }
1647 
1648 // File: https://github.com/overlay-market/v1-core/blob/main/contracts/interfaces/IOverlayV1Token.sol
1649 
1650 
1651 pragma solidity 0.8.10;
1652 
1653 
1654 
1655 bytes32 constant MINTER_ROLE = keccak256("MINTER");
1656 bytes32 constant BURNER_ROLE = keccak256("BURNER");
1657 bytes32 constant GOVERNOR_ROLE = keccak256("GOVERNOR");
1658 bytes32 constant GUARDIAN_ROLE = keccak256("GUARDIAN");
1659 
1660 interface IOverlayV1Token is IAccessControlEnumerable, IERC20 {
1661     // mint/burn
1662     function mint(address _recipient, uint256 _amount) external;
1663 
1664     function burn(uint256 _amount) external;
1665 }
1666 
1667 // File: https://github.com/overlay-market/v1-core/blob/main/contracts/interfaces/IOverlayV1Deployer.sol
1668 
1669 
1670 pragma solidity 0.8.10;
1671 
1672 interface IOverlayV1Deployer {
1673     function factory() external view returns (address);
1674 
1675     function ovl() external view returns (address);
1676 
1677     function deploy(address feed) external returns (address);
1678 
1679     function parameters()
1680         external
1681         view
1682         returns (
1683             address ovl_,
1684             address feed_,
1685             address factory_
1686         );
1687 }
1688 
1689 // File: https://github.com/overlay-market/v1-core/blob/main/contracts/libraries/Risk.sol
1690 
1691 
1692 pragma solidity 0.8.10;
1693 
1694 library Risk {
1695     enum Parameters {
1696         K, // funding constant
1697         Lmbda, // market impact constant
1698         Delta, // bid-ask static spread constant
1699         CapPayoff, // payoff cap
1700         CapNotional, // initial notional cap
1701         CapLeverage, // initial leverage cap
1702         CircuitBreakerWindow, // trailing window for circuit breaker
1703         CircuitBreakerMintTarget, // target worst case inflation rate over trailing window
1704         MaintenanceMarginFraction, // maintenance margin (mm) constant
1705         MaintenanceMarginBurnRate, // burn rate for mm constant
1706         LiquidationFeeRate, // liquidation fee charged on liquidate
1707         TradingFeeRate, // trading fee charged on build/unwind
1708         MinCollateral, // minimum ovl collateral to open position
1709         PriceDriftUpperLimit, // upper limit for feed price changes since last update
1710         AverageBlockTime // average block time of the respective chain
1711     }
1712 
1713     /// @notice Gets the value associated with the given parameter type
1714     function get(uint256[15] storage self, Parameters name) internal view returns (uint256) {
1715         return self[uint256(name)];
1716     }
1717 
1718     /// @notice Sets the value associated with the given parameter type
1719     function set(
1720         uint256[15] storage self,
1721         Parameters name,
1722         uint256 value
1723     ) internal {
1724         self[uint256(name)] = value;
1725     }
1726 }
1727 
1728 // File: https://github.com/overlay-market/v1-core/blob/main/contracts/interfaces/IOverlayV1Market.sol
1729 
1730 
1731 pragma solidity 0.8.10;
1732 
1733 
1734 
1735 
1736 
1737 interface IOverlayV1Market {
1738     // immutables
1739     function ovl() external view returns (IOverlayV1Token);
1740 
1741     function feed() external view returns (address);
1742 
1743     function factory() external view returns (address);
1744 
1745     // risk params
1746     function params(uint256 idx) external view returns (uint256);
1747 
1748     // oi related quantities
1749     function oiLong() external view returns (uint256);
1750 
1751     function oiShort() external view returns (uint256);
1752 
1753     function oiLongShares() external view returns (uint256);
1754 
1755     function oiShortShares() external view returns (uint256);
1756 
1757     // rollers
1758     function snapshotVolumeBid()
1759         external
1760         view
1761         returns (
1762             uint32 timestamp_,
1763             uint32 window_,
1764             int192 accumulator_
1765         );
1766 
1767     function snapshotVolumeAsk()
1768         external
1769         view
1770         returns (
1771             uint32 timestamp_,
1772             uint32 window_,
1773             int192 accumulator_
1774         );
1775 
1776     function snapshotMinted()
1777         external
1778         view
1779         returns (
1780             uint32 timestamp_,
1781             uint32 window_,
1782             int192 accumulator_
1783         );
1784 
1785     // positions
1786     function positions(bytes32 key)
1787         external
1788         view
1789         returns (
1790             uint96 notionalInitial_,
1791             uint96 debtInitial_,
1792             int24 midTick_,
1793             int24 entryTick_,
1794             bool isLong_,
1795             bool liquidated_,
1796             uint240 oiShares_,
1797             uint16 fractionRemaining_
1798         );
1799 
1800     // update related quantities
1801     function timestampUpdateLast() external view returns (uint256);
1802 
1803     // cached risk calcs
1804     function dpUpperLimit() external view returns (uint256);
1805 
1806     // emergency shutdown
1807     function isShutdown() external view returns (bool);
1808 
1809     // initializes market
1810     function initialize(uint256[15] memory params) external;
1811 
1812     // position altering functions
1813     function build(
1814         uint256 collateral,
1815         uint256 leverage,
1816         bool isLong,
1817         uint256 priceLimit
1818     ) external returns (uint256 positionId_);
1819 
1820     function unwind(
1821         uint256 positionId,
1822         uint256 fraction,
1823         uint256 priceLimit
1824     ) external;
1825 
1826     function liquidate(address owner, uint256 positionId) external;
1827 
1828     // updates market
1829     function update() external returns (Oracle.Data memory);
1830 
1831     // sanity check on data fetched from oracle in case of manipulation
1832     function dataIsValid(Oracle.Data memory) external view returns (bool);
1833 
1834     // current open interest after funding payments transferred
1835     function oiAfterFunding(
1836         uint256 oiOverweight,
1837         uint256 oiUnderweight,
1838         uint256 timeElapsed
1839     ) external view returns (uint256 oiOverweight_, uint256 oiUnderweight_);
1840 
1841     // current open interest cap with adjustments for circuit breaker if market has
1842     // printed a lot in recent past
1843     function capOiAdjustedForCircuitBreaker(uint256 cap) external view returns (uint256);
1844 
1845     // bound on open interest cap from circuit breaker
1846     function circuitBreaker(Roller.Snapshot memory snapshot, uint256 cap)
1847         external
1848         view
1849         returns (uint256);
1850 
1851     // current notional cap with adjustments to prevent front-running
1852     // trade and back-running trade
1853     function capNotionalAdjustedForBounds(Oracle.Data memory data, uint256 cap)
1854         external
1855         view
1856         returns (uint256);
1857 
1858     // bound on open interest cap to mitigate front-running attack
1859     function frontRunBound(Oracle.Data memory data) external view returns (uint256);
1860 
1861     // bound on open interest cap to mitigate back-running attack
1862     function backRunBound(Oracle.Data memory data) external view returns (uint256);
1863 
1864     // transforms notional into number of contracts (open interest)
1865     function oiFromNotional(uint256 notional, uint256 midPrice) external view returns (uint256);
1866 
1867     // bid price given oracle data and recent volume
1868     function bid(Oracle.Data memory data, uint256 volume) external view returns (uint256 bid_);
1869 
1870     // ask price given oracle data and recent volume
1871     function ask(Oracle.Data memory data, uint256 volume) external view returns (uint256 ask_);
1872 
1873     // risk parameter setter
1874     function setRiskParam(Risk.Parameters name, uint256 value) external;
1875 
1876     // emergency shutdown market
1877     function shutdown() external;
1878 
1879     // emergency withdraw collateral after shutdown
1880     function emergencyWithdraw(uint256 positionId) external;
1881 }
1882 
1883 // File: https://github.com/overlay-market/v1-core/blob/main/contracts/interfaces/IOverlayV1Factory.sol
1884 
1885 
1886 pragma solidity 0.8.10;
1887 
1888 
1889 
1890 
1891 interface IOverlayV1Factory {
1892     // risk param bounds
1893     function PARAMS_MIN(uint256 idx) external view returns (uint256);
1894 
1895     function PARAMS_MAX(uint256 idx) external view returns (uint256);
1896 
1897     // immutables
1898     function ovl() external view returns (IOverlayV1Token);
1899 
1900     function deployer() external view returns (IOverlayV1Deployer);
1901 
1902     // global parameter
1903     function feeRecipient() external view returns (address);
1904 
1905     // registry of supported feed factories
1906     function isFeedFactory(address feedFactory) external view returns (bool);
1907 
1908     // registry of markets; for a given feed address, returns associated market
1909     function getMarket(address feed) external view returns (address market_);
1910 
1911     // registry of deployed markets by factory
1912     function isMarket(address market) external view returns (bool);
1913 
1914     // adding feed factory to allowed feed types
1915     function addFeedFactory(address feedFactory) external;
1916 
1917     // removing feed factory from allowed feed types
1918     function removeFeedFactory(address feedFactory) external;
1919 
1920     // deploy new market
1921     function deployMarket(
1922         address feedFactory,
1923         address feed,
1924         uint256[15] calldata params
1925     ) external returns (address market_);
1926 
1927     // per-market risk parameter setters
1928     function setRiskParam(
1929         address feed,
1930         Risk.Parameters name,
1931         uint256 value
1932     ) external;
1933 
1934     // fee repository setter
1935     function setFeeRecipient(address _feeRecipient) external;
1936 }
1937 
1938 // File: @openzeppelin/contracts/utils/math/Math.sol
1939 
1940 
1941 // OpenZeppelin Contracts (last updated v4.7.0) (utils/math/Math.sol)
1942 
1943 pragma solidity ^0.8.0;
1944 
1945 /**
1946  * @dev Standard math utilities missing in the Solidity language.
1947  */
1948 library Math {
1949     enum Rounding {
1950         Down, // Toward negative infinity
1951         Up, // Toward infinity
1952         Zero // Toward zero
1953     }
1954 
1955     /**
1956      * @dev Returns the largest of two numbers.
1957      */
1958     function max(uint256 a, uint256 b) internal pure returns (uint256) {
1959         return a >= b ? a : b;
1960     }
1961 
1962     /**
1963      * @dev Returns the smallest of two numbers.
1964      */
1965     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1966         return a < b ? a : b;
1967     }
1968 
1969     /**
1970      * @dev Returns the average of two numbers. The result is rounded towards
1971      * zero.
1972      */
1973     function average(uint256 a, uint256 b) internal pure returns (uint256) {
1974         // (a + b) / 2 can overflow.
1975         return (a & b) + (a ^ b) / 2;
1976     }
1977 
1978     /**
1979      * @dev Returns the ceiling of the division of two numbers.
1980      *
1981      * This differs from standard division with `/` in that it rounds up instead
1982      * of rounding down.
1983      */
1984     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
1985         // (a + b - 1) / b can overflow on addition, so we distribute.
1986         return a == 0 ? 0 : (a - 1) / b + 1;
1987     }
1988 
1989     /**
1990      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
1991      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
1992      * with further edits by Uniswap Labs also under MIT license.
1993      */
1994     function mulDiv(
1995         uint256 x,
1996         uint256 y,
1997         uint256 denominator
1998     ) internal pure returns (uint256 result) {
1999         unchecked {
2000             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
2001             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
2002             // variables such that product = prod1 * 2^256 + prod0.
2003             uint256 prod0; // Least significant 256 bits of the product
2004             uint256 prod1; // Most significant 256 bits of the product
2005             assembly {
2006                 let mm := mulmod(x, y, not(0))
2007                 prod0 := mul(x, y)
2008                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
2009             }
2010 
2011             // Handle non-overflow cases, 256 by 256 division.
2012             if (prod1 == 0) {
2013                 return prod0 / denominator;
2014             }
2015 
2016             // Make sure the result is less than 2^256. Also prevents denominator == 0.
2017             require(denominator > prod1);
2018 
2019             ///////////////////////////////////////////////
2020             // 512 by 256 division.
2021             ///////////////////////////////////////////////
2022 
2023             // Make division exact by subtracting the remainder from [prod1 prod0].
2024             uint256 remainder;
2025             assembly {
2026                 // Compute remainder using mulmod.
2027                 remainder := mulmod(x, y, denominator)
2028 
2029                 // Subtract 256 bit number from 512 bit number.
2030                 prod1 := sub(prod1, gt(remainder, prod0))
2031                 prod0 := sub(prod0, remainder)
2032             }
2033 
2034             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
2035             // See https://cs.stackexchange.com/q/138556/92363.
2036 
2037             // Does not overflow because the denominator cannot be zero at this stage in the function.
2038             uint256 twos = denominator & (~denominator + 1);
2039             assembly {
2040                 // Divide denominator by twos.
2041                 denominator := div(denominator, twos)
2042 
2043                 // Divide [prod1 prod0] by twos.
2044                 prod0 := div(prod0, twos)
2045 
2046                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
2047                 twos := add(div(sub(0, twos), twos), 1)
2048             }
2049 
2050             // Shift in bits from prod1 into prod0.
2051             prod0 |= prod1 * twos;
2052 
2053             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
2054             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
2055             // four bits. That is, denominator * inv = 1 mod 2^4.
2056             uint256 inverse = (3 * denominator) ^ 2;
2057 
2058             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
2059             // in modular arithmetic, doubling the correct bits in each step.
2060             inverse *= 2 - denominator * inverse; // inverse mod 2^8
2061             inverse *= 2 - denominator * inverse; // inverse mod 2^16
2062             inverse *= 2 - denominator * inverse; // inverse mod 2^32
2063             inverse *= 2 - denominator * inverse; // inverse mod 2^64
2064             inverse *= 2 - denominator * inverse; // inverse mod 2^128
2065             inverse *= 2 - denominator * inverse; // inverse mod 2^256
2066 
2067             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
2068             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
2069             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
2070             // is no longer required.
2071             result = prod0 * inverse;
2072             return result;
2073         }
2074     }
2075 
2076     /**
2077      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
2078      */
2079     function mulDiv(
2080         uint256 x,
2081         uint256 y,
2082         uint256 denominator,
2083         Rounding rounding
2084     ) internal pure returns (uint256) {
2085         uint256 result = mulDiv(x, y, denominator);
2086         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
2087             result += 1;
2088         }
2089         return result;
2090     }
2091 
2092     /**
2093      * @dev Returns the square root of a number. It the number is not a perfect square, the value is rounded down.
2094      *
2095      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
2096      */
2097     function sqrt(uint256 a) internal pure returns (uint256) {
2098         if (a == 0) {
2099             return 0;
2100         }
2101 
2102         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
2103         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
2104         // `msb(a) <= a < 2*msb(a)`.
2105         // We also know that `k`, the position of the most significant bit, is such that `msb(a) = 2**k`.
2106         // This gives `2**k < a <= 2**(k+1)` → `2**(k/2) <= sqrt(a) < 2 ** (k/2+1)`.
2107         // Using an algorithm similar to the msb conmputation, we are able to compute `result = 2**(k/2)` which is a
2108         // good first aproximation of `sqrt(a)` with at least 1 correct bit.
2109         uint256 result = 1;
2110         uint256 x = a;
2111         if (x >> 128 > 0) {
2112             x >>= 128;
2113             result <<= 64;
2114         }
2115         if (x >> 64 > 0) {
2116             x >>= 64;
2117             result <<= 32;
2118         }
2119         if (x >> 32 > 0) {
2120             x >>= 32;
2121             result <<= 16;
2122         }
2123         if (x >> 16 > 0) {
2124             x >>= 16;
2125             result <<= 8;
2126         }
2127         if (x >> 8 > 0) {
2128             x >>= 8;
2129             result <<= 4;
2130         }
2131         if (x >> 4 > 0) {
2132             x >>= 4;
2133             result <<= 2;
2134         }
2135         if (x >> 2 > 0) {
2136             result <<= 1;
2137         }
2138 
2139         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
2140         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
2141         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
2142         // into the expected uint128 result.
2143         unchecked {
2144             result = (result + a / result) >> 1;
2145             result = (result + a / result) >> 1;
2146             result = (result + a / result) >> 1;
2147             result = (result + a / result) >> 1;
2148             result = (result + a / result) >> 1;
2149             result = (result + a / result) >> 1;
2150             result = (result + a / result) >> 1;
2151             return min(result, a / result);
2152         }
2153     }
2154 
2155     /**
2156      * @notice Calculates sqrt(a), following the selected rounding direction.
2157      */
2158     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
2159         uint256 result = sqrt(a);
2160         if (rounding == Rounding.Up && result * result < a) {
2161             result += 1;
2162         }
2163         return result;
2164     }
2165 }
2166 
2167 // File: https://github.com/overlay-market/v1-core/blob/main/contracts/libraries/Position.sol
2168 
2169 
2170 pragma solidity 0.8.10;
2171 
2172 
2173 
2174 
2175 
2176 
2177 library Position {
2178     using FixedCast for uint16;
2179     using FixedCast for uint256;
2180     using FixedPoint for uint256;
2181 
2182     uint256 internal constant ONE = 1e18;
2183 
2184     /// @dev immutables: notionalInitial, debtInitial, midTick, entryTick, isLong
2185     /// @dev mutables: liquidated, oiShares, fractionRemaining
2186     struct Info {
2187         uint96 notionalInitial; // initial notional = collateral * leverage
2188         uint96 debtInitial; // initial debt = notional - collateral
2189         int24 midTick; // midPrice = 1.0001 ** midTick at build
2190         int24 entryTick; // entryPrice = 1.0001 ** entryTick at build
2191         bool isLong; // whether long or short
2192         bool liquidated; // whether has been liquidated (mutable)
2193         uint240 oiShares; // current shares of aggregate open interest on side (mutable)
2194         uint16 fractionRemaining; // fraction of initial position remaining (mutable)
2195     }
2196 
2197     /*///////////////////////////////////////////////////////////////
2198                         POSITIONS MAPPING FUNCTIONS
2199     //////////////////////////////////////////////////////////////*/
2200 
2201     /// @notice Retrieves a position from positions mapping
2202     function get(
2203         mapping(bytes32 => Info) storage self,
2204         address owner,
2205         uint256 id
2206     ) internal view returns (Info memory position_) {
2207         position_ = self[keccak256(abi.encodePacked(owner, id))];
2208     }
2209 
2210     /// @notice Stores a position in positions mapping
2211     function set(
2212         mapping(bytes32 => Info) storage self,
2213         address owner,
2214         uint256 id,
2215         Info memory position
2216     ) internal {
2217         self[keccak256(abi.encodePacked(owner, id))] = position;
2218     }
2219 
2220     /*///////////////////////////////////////////////////////////////
2221                     POSITION CAST GETTER FUNCTIONS
2222     //////////////////////////////////////////////////////////////*/
2223 
2224     /// @notice Computes the position's initial notional cast to uint256
2225     function _notionalInitial(Info memory self) private pure returns (uint256) {
2226         return uint256(self.notionalInitial);
2227     }
2228 
2229     /// @notice Computes the position's initial debt cast to uint256
2230     function _debtInitial(Info memory self) private pure returns (uint256) {
2231         return uint256(self.debtInitial);
2232     }
2233 
2234     /// @notice Computes the position's current shares of open interest
2235     /// @notice cast to uint256
2236     function _oiShares(Info memory self) private pure returns (uint256) {
2237         return uint256(self.oiShares);
2238     }
2239 
2240     /// @notice Computes the fraction remaining of the position cast to uint256
2241     function _fractionRemaining(Info memory self) private pure returns (uint256) {
2242         return self.fractionRemaining.toUint256Fixed();
2243     }
2244 
2245     /*///////////////////////////////////////////////////////////////
2246                      POSITION EXISTENCE FUNCTIONS
2247     //////////////////////////////////////////////////////////////*/
2248 
2249     /// @notice Whether the position exists
2250     /// @dev Is false if position has been liquidated or fraction remaining == 0
2251     function exists(Info memory self) internal pure returns (bool exists_) {
2252         return (!self.liquidated && self.fractionRemaining > 0);
2253     }
2254 
2255     /*///////////////////////////////////////////////////////////////
2256                  POSITION FRACTION REMAINING FUNCTIONS
2257     //////////////////////////////////////////////////////////////*/
2258 
2259     /// @notice Gets the current fraction remaining of the initial position
2260     function getFractionRemaining(Info memory self) internal pure returns (uint256) {
2261         return _fractionRemaining(self);
2262     }
2263 
2264     /// @notice Computes an updated fraction remaining of the initial position
2265     /// @notice given fractionRemoved unwound/liquidated from remaining position
2266     function updatedFractionRemaining(Info memory self, uint256 fractionRemoved)
2267         internal
2268         pure
2269         returns (uint16)
2270     {
2271         require(fractionRemoved <= ONE, "OVLV1:fraction>max");
2272         uint256 fractionRemaining = _fractionRemaining(self).mulDown(ONE - fractionRemoved);
2273         return fractionRemaining.toUint16Fixed();
2274     }
2275 
2276     /*///////////////////////////////////////////////////////////////
2277                       POSITION PRICE FUNCTIONS
2278     //////////////////////////////////////////////////////////////*/
2279 
2280     /// @notice Computes the midPrice of the position at entry cast to uint256
2281     /// @dev Will be slightly different (tol of 1bps) vs actual
2282     /// @dev midPrice at build given tick resolution limited to 1bps
2283     /// @dev Only affects value() calc below and thus PnL slightly
2284     function midPriceAtEntry(Info memory self) internal pure returns (uint256 midPrice_) {
2285         midPrice_ = Tick.tickToPrice(self.midTick);
2286     }
2287 
2288     /// @notice Computes the entryPrice of the position cast to uint256
2289     /// @dev Will be slightly different (tol of 1bps) vs actual
2290     /// @dev entryPrice at build given tick resolution limited to 1bps
2291     /// @dev Only affects value() calc below and thus PnL slightly
2292     function entryPrice(Info memory self) internal pure returns (uint256 entryPrice_) {
2293         entryPrice_ = Tick.tickToPrice(self.entryTick);
2294     }
2295 
2296     /*///////////////////////////////////////////////////////////////
2297                          POSITION OI FUNCTIONS
2298     //////////////////////////////////////////////////////////////*/
2299 
2300     /// @notice Computes the amount of shares of open interest to issue
2301     /// @notice a newly built position
2302     /// @dev use mulDiv
2303     function calcOiShares(
2304         uint256 oi,
2305         uint256 oiTotalOnSide,
2306         uint256 oiTotalSharesOnSide
2307     ) internal pure returns (uint256 oiShares_) {
2308         oiShares_ = (oiTotalOnSide == 0 || oiTotalSharesOnSide == 0)
2309             ? oi
2310             : FullMath.mulDiv(oi, oiTotalSharesOnSide, oiTotalOnSide);
2311     }
2312 
2313     /// @notice Computes the position's initial open interest cast to uint256
2314     /// @dev oiInitial = Q / midPriceAtEntry
2315     /// @dev Will be slightly different (tol of 1bps) vs actual oi at build
2316     /// @dev given midTick resolution limited to 1bps
2317     /// @dev Only affects value() calc below and thus PnL slightly
2318     function _oiInitial(Info memory self) private pure returns (uint256) {
2319         uint256 q = _notionalInitial(self);
2320         uint256 mid = midPriceAtEntry(self);
2321         return q.divDown(mid);
2322     }
2323 
2324     /*///////////////////////////////////////////////////////////////
2325                 POSITION FRACTIONAL GETTER FUNCTIONS
2326     //////////////////////////////////////////////////////////////*/
2327 
2328     /// @notice Computes the initial notional of position when built
2329     /// @notice accounting for amount of position remaining
2330     /// @dev use mulUp to avoid rounding leftovers on unwind
2331     function notionalInitial(Info memory self, uint256 fraction) internal pure returns (uint256) {
2332         uint256 fractionRemaining = _fractionRemaining(self);
2333         uint256 notionalForRemaining = _notionalInitial(self).mulUp(fractionRemaining);
2334         return notionalForRemaining.mulUp(fraction);
2335     }
2336 
2337     /// @notice Computes the initial open interest of position when built
2338     /// @notice accounting for amount of position remaining
2339     /// @dev use mulUp to avoid rounding leftovers on unwind
2340     function oiInitial(Info memory self, uint256 fraction) internal pure returns (uint256) {
2341         uint256 fractionRemaining = _fractionRemaining(self);
2342         uint256 oiInitialForRemaining = _oiInitial(self).mulUp(fractionRemaining);
2343         return oiInitialForRemaining.mulUp(fraction);
2344     }
2345 
2346     /// @notice Computes the current shares of open interest position holds
2347     /// @notice on pos.isLong side of the market
2348     /// @dev use mulDown to avoid giving excess shares to pos owner on unwind
2349     function oiSharesCurrent(Info memory self, uint256 fraction) internal pure returns (uint256) {
2350         uint256 oiSharesForRemaining = _oiShares(self);
2351         // WARNING: must mulDown to avoid giving excess oi shares
2352         return oiSharesForRemaining.mulDown(fraction);
2353     }
2354 
2355     /// @notice Computes the current debt position holds accounting
2356     /// @notice for amount of position remaining
2357     /// @dev use mulUp to avoid rounding leftovers on unwind
2358     function debtInitial(Info memory self, uint256 fraction) internal pure returns (uint256) {
2359         uint256 fractionRemaining = _fractionRemaining(self);
2360         uint256 debtForRemaining = _debtInitial(self).mulUp(fractionRemaining);
2361         return debtForRemaining.mulUp(fraction);
2362     }
2363 
2364     /// @notice Computes the current open interest of remaining position accounting for
2365     /// @notice potential funding payments between long/short sides
2366     /// @dev returns zero when oiShares = oiTotalOnSide = oiTotalSharesOnSide = 0 to avoid
2367     /// @dev div by zero errors
2368     /// @dev use mulDiv
2369     function oiCurrent(
2370         Info memory self,
2371         uint256 fraction,
2372         uint256 oiTotalOnSide,
2373         uint256 oiTotalSharesOnSide
2374     ) internal pure returns (uint256) {
2375         uint256 oiShares = oiSharesCurrent(self, fraction);
2376         if (oiShares == 0 || oiTotalOnSide == 0 || oiTotalSharesOnSide == 0) return 0;
2377         return FullMath.mulDiv(oiShares, oiTotalOnSide, oiTotalSharesOnSide);
2378     }
2379 
2380     /// @notice Computes the remaining position's cost cast to uint256
2381     function cost(Info memory self, uint256 fraction) internal pure returns (uint256) {
2382         uint256 posNotionalInitial = notionalInitial(self, fraction);
2383         uint256 posDebt = debtInitial(self, fraction);
2384 
2385         // should always be > 0 but use subFloor to be safe w reverts
2386         uint256 posCost = posNotionalInitial;
2387         posCost = posCost.subFloor(posDebt);
2388         return posCost;
2389     }
2390 
2391     /*///////////////////////////////////////////////////////////////
2392                         POSITION CALC FUNCTIONS
2393     //////////////////////////////////////////////////////////////*/
2394 
2395     /// @notice Computes the value of remaining position
2396     /// @dev Floors to zero, so won't properly compute if self is underwater
2397     function value(
2398         Info memory self,
2399         uint256 fraction,
2400         uint256 oiTotalOnSide,
2401         uint256 oiTotalSharesOnSide,
2402         uint256 currentPrice,
2403         uint256 capPayoff
2404     ) internal pure returns (uint256 val_) {
2405         uint256 posOiInitial = oiInitial(self, fraction);
2406         uint256 posNotionalInitial = notionalInitial(self, fraction);
2407         uint256 posDebt = debtInitial(self, fraction);
2408 
2409         uint256 posOiCurrent = oiCurrent(self, fraction, oiTotalOnSide, oiTotalSharesOnSide);
2410         uint256 posEntryPrice = entryPrice(self);
2411 
2412         // NOTE: PnL = +/- oiCurrent * [currentPrice - entryPrice]; ... (w/o capPayoff)
2413         // NOTE: fundingPayments = notionalInitial * ( oiCurrent / oiInitial - 1 )
2414         // NOTE: value = collateralInitial + PnL + fundingPayments
2415         // NOTE:       = notionalInitial - debt + PnL + fundingPayments
2416         if (self.isLong) {
2417             // val = notionalInitial * oiCurrent / oiInitial
2418             //       + oiCurrent * min[currentPrice, entryPrice * (1 + capPayoff)]
2419             //       - oiCurrent * entryPrice - debt
2420             val_ =
2421                 posNotionalInitial.mulUp(posOiCurrent).divUp(posOiInitial) +
2422                 Math.min(
2423                     posOiCurrent.mulUp(currentPrice),
2424                     posOiCurrent.mulUp(posEntryPrice).mulUp(ONE + capPayoff)
2425                 );
2426             // floor to 0
2427             val_ = val_.subFloor(posDebt + posOiCurrent.mulUp(posEntryPrice));
2428         } else {
2429             // NOTE: capPayoff >= 1, so no need to include w short
2430             // val = notionalInitial * oiCurrent / oiInitial + oiCurrent * entryPrice
2431             //       - oiCurrent * currentPrice - debt
2432             val_ =
2433                 posNotionalInitial.mulUp(posOiCurrent).divUp(posOiInitial) +
2434                 posOiCurrent.mulUp(posEntryPrice);
2435             // floor to 0
2436             val_ = val_.subFloor(posDebt + posOiCurrent.mulUp(currentPrice));
2437         }
2438     }
2439 
2440     /// @notice Computes the current notional of remaining position including PnL
2441     /// @dev Floors to debt if value <= 0
2442     function notionalWithPnl(
2443         Info memory self,
2444         uint256 fraction,
2445         uint256 oiTotalOnSide,
2446         uint256 oiTotalSharesOnSide,
2447         uint256 currentPrice,
2448         uint256 capPayoff
2449     ) internal pure returns (uint256 notionalWithPnl_) {
2450         uint256 posValue = value(
2451             self,
2452             fraction,
2453             oiTotalOnSide,
2454             oiTotalSharesOnSide,
2455             currentPrice,
2456             capPayoff
2457         );
2458         uint256 posDebt = debtInitial(self, fraction);
2459         notionalWithPnl_ = posValue + posDebt;
2460     }
2461 
2462     /// @notice Computes the trading fees to be imposed on remaining position
2463     /// @notice for build/unwind
2464     function tradingFee(
2465         Info memory self,
2466         uint256 fraction,
2467         uint256 oiTotalOnSide,
2468         uint256 oiTotalSharesOnSide,
2469         uint256 currentPrice,
2470         uint256 capPayoff,
2471         uint256 tradingFeeRate
2472     ) internal pure returns (uint256 tradingFee_) {
2473         uint256 posNotional = notionalWithPnl(
2474             self,
2475             fraction,
2476             oiTotalOnSide,
2477             oiTotalSharesOnSide,
2478             currentPrice,
2479             capPayoff
2480         );
2481         tradingFee_ = posNotional.mulUp(tradingFeeRate);
2482     }
2483 
2484     /// @notice Whether a position can be liquidated
2485     /// @dev is true when value * (1 - liq fee rate) < maintenance margin
2486     /// @dev liq fees are reward given to liquidator
2487     function liquidatable(
2488         Info memory self,
2489         uint256 oiTotalOnSide,
2490         uint256 oiTotalSharesOnSide,
2491         uint256 currentPrice,
2492         uint256 capPayoff,
2493         uint256 maintenanceMarginFraction,
2494         uint256 liquidationFeeRate
2495     ) internal pure returns (bool can_) {
2496         uint256 fraction = ONE;
2497         uint256 posNotionalInitial = notionalInitial(self, fraction);
2498 
2499         if (self.liquidated || self.fractionRemaining == 0) {
2500             // already been liquidated or doesn't exist
2501             // latter covers edge case of val == 0 and MM + liq fee == 0
2502             return false;
2503         }
2504 
2505         uint256 val = value(
2506             self,
2507             fraction,
2508             oiTotalOnSide,
2509             oiTotalSharesOnSide,
2510             currentPrice,
2511             capPayoff
2512         );
2513         uint256 maintenanceMargin = posNotionalInitial.mulUp(maintenanceMarginFraction);
2514         uint256 liquidationFee = val.mulDown(liquidationFeeRate);
2515         can_ = val < maintenanceMargin + liquidationFee;
2516     }
2517 }
2518 
2519 // File: github/overlay-market/v1-core/contracts/OverlayV1Market.sol
2520 
2521 
2522 pragma solidity 0.8.10;
2523 
2524 
2525 
2526 
2527 
2528 
2529 
2530 
2531 
2532 
2533 
2534 
2535 
2536 contract OverlayV1Market is IOverlayV1Market {
2537     using FixedCast for uint16;
2538     using FixedCast for uint256;
2539     using FixedPoint for uint256;
2540     using Oracle for Oracle.Data;
2541     using Position for mapping(bytes32 => Position.Info);
2542     using Position for Position.Info;
2543     using Risk for uint256[15];
2544     using Roller for Roller.Snapshot;
2545 
2546     // internal constants
2547     uint256 internal constant ONE = 1e18; // 18 decimal places
2548 
2549     // cap for euler exponent powers; SEE: ./libraries/LogExpMath.sol::pow
2550     // using ~ 1/2 library max for substantial padding
2551     uint256 internal constant MAX_NATURAL_EXPONENT = 20e18;
2552 
2553     // immutables
2554     IOverlayV1Token public immutable ovl; // ovl token
2555     address public immutable feed; // oracle feed
2556     address public immutable factory; // factory that deployed this market
2557 
2558     // risk params
2559     uint256[15] public params; // params.idx order based on Risk.Parameters enum
2560 
2561     // aggregate oi quantities
2562     uint256 public oiLong;
2563     uint256 public oiShort;
2564     uint256 public oiLongShares;
2565     uint256 public oiShortShares;
2566 
2567     // rollers
2568     Roller.Snapshot public override snapshotVolumeBid; // snapshot of recent volume on bid
2569     Roller.Snapshot public override snapshotVolumeAsk; // snapshot of recent volume on ask
2570     Roller.Snapshot public override snapshotMinted; // snapshot of recent PnL minted/burned
2571 
2572     // positions
2573     mapping(bytes32 => Position.Info) public override positions;
2574     uint256 private _totalPositions;
2575 
2576     // data from last call to update
2577     uint256 public timestampUpdateLast;
2578 
2579     // cached risk calcs
2580     uint256 public dpUpperLimit; // e**(+priceDriftUpperLimit * macroWindow)
2581 
2582     // emergency shutdown
2583     bool public isShutdown;
2584 
2585     // factory modifier for governance sensitive functions
2586     modifier onlyFactory() {
2587         require(msg.sender == factory, "OVLV1: !factory");
2588         _;
2589     }
2590 
2591     // not shutdown modifier for regular functionality
2592     modifier notShutdown() {
2593         require(!isShutdown, "OVLV1: shutdown");
2594         _;
2595     }
2596 
2597     // shutdown modifier for emergencies
2598     modifier hasShutdown() {
2599         require(isShutdown, "OVLV1: !shutdown");
2600         _;
2601     }
2602 
2603     // events for core functions
2604     event Build(
2605         address indexed sender, // address that initiated build (owns position)
2606         uint256 positionId, // id of built position
2607         uint256 oi, // oi of position at build
2608         uint256 debt, // debt of position at build
2609         bool isLong, // whether is long or short
2610         uint256 price // entry price
2611     );
2612     event Unwind(
2613         address indexed sender, // address that initiated unwind (owns position)
2614         uint256 positionId, // id of unwound position
2615         uint256 fraction, // fraction of position unwound
2616         int256 mint, // total amount minted/burned (+/-) at unwind
2617         uint256 price // exit price
2618     );
2619     event Liquidate(
2620         address indexed sender, // address that initiated liquidate
2621         address indexed owner, // address that owned the liquidated position
2622         uint256 positionId, // id of the liquidated position
2623         int256 mint, // total amount burned (-) at liquidate
2624         uint256 price // liquidation price
2625     );
2626     event EmergencyWithdraw(
2627         address indexed sender, // address that initiated withdraw (owns position)
2628         uint256 positionId, // id of withdrawn position
2629         uint256 collateral // total amount of collateral withdrawn
2630     );
2631 
2632     constructor() {
2633         (address _ovl, address _feed, address _factory) = IOverlayV1Deployer(msg.sender)
2634             .parameters();
2635         ovl = IOverlayV1Token(_ovl);
2636         feed = _feed;
2637         factory = _factory;
2638     }
2639 
2640     /// @notice initializes the market and its risk params
2641     /// @notice called only once by factory on deployment
2642     function initialize(uint256[15] memory _params) external onlyFactory {
2643         // initialize update data
2644         Oracle.Data memory data = IOverlayV1Feed(feed).latest();
2645         require(_midFromFeed(data) > 0, "OVLV1:!data");
2646         timestampUpdateLast = block.timestamp;
2647 
2648         // check risk params valid
2649         uint256 _capLeverage = _params[uint256(Risk.Parameters.CapLeverage)];
2650         uint256 _delta = _params[uint256(Risk.Parameters.Delta)];
2651         uint256 _maintenanceMarginFraction = _params[
2652             uint256(Risk.Parameters.MaintenanceMarginFraction)
2653         ];
2654         uint256 _liquidationFeeRate = _params[uint256(Risk.Parameters.LiquidationFeeRate)];
2655         require(
2656             _capLeverage <=
2657                 ONE.divDown(
2658                     2 * _delta + _maintenanceMarginFraction.divDown(ONE - _liquidationFeeRate)
2659                 ),
2660             "OVLV1: max lev immediately liquidatable"
2661         );
2662 
2663         uint256 _priceDriftUpperLimit = _params[uint256(Risk.Parameters.PriceDriftUpperLimit)];
2664         require(
2665             _priceDriftUpperLimit * data.macroWindow < MAX_NATURAL_EXPONENT,
2666             "OVLV1: price drift exceeds max exp"
2667         );
2668         _cacheRiskCalc(Risk.Parameters.PriceDriftUpperLimit, _priceDriftUpperLimit);
2669 
2670         // set the risk params
2671         for (uint256 i = 0; i < _params.length; i++) {
2672             params[i] = _params[i];
2673         }
2674     }
2675 
2676     /// @dev builds a new position
2677     function build(
2678         uint256 collateral,
2679         uint256 leverage,
2680         bool isLong,
2681         uint256 priceLimit
2682     ) external notShutdown returns (uint256 positionId_) {
2683         require(leverage >= ONE, "OVLV1:lev<min");
2684         require(leverage <= params.get(Risk.Parameters.CapLeverage), "OVLV1:lev>max");
2685         require(collateral >= params.get(Risk.Parameters.MinCollateral), "OVLV1:collateral<min");
2686 
2687         uint256 oi;
2688         uint256 debt;
2689         uint256 price;
2690         uint256 tradingFee;
2691         // avoids stack too deep
2692         {
2693             // call to update before any effects
2694             Oracle.Data memory data = update();
2695 
2696             // calculate notional, oi, and trading fees. fees charged on notional
2697             // and added to collateral transferred in
2698             uint256 notional = collateral.mulUp(leverage);
2699             uint256 midPrice = _midFromFeed(data);
2700             oi = oiFromNotional(notional, midPrice);
2701 
2702             // check have more than zero number of contracts built
2703             require(oi > 0, "OVLV1:oi==0");
2704 
2705             // calculate debt and trading fees. fees charged on notional
2706             // and added to collateral transferred in
2707             debt = notional - collateral;
2708             tradingFee = notional.mulUp(params.get(Risk.Parameters.TradingFeeRate));
2709 
2710             // calculate current notional cap adjusted for front run
2711             // and back run bounds. transform into a cap on open interest
2712             uint256 capOi = oiFromNotional(
2713                 capNotionalAdjustedForBounds(data, params.get(Risk.Parameters.CapNotional)),
2714                 midPrice
2715             );
2716 
2717             // longs get the ask and shorts get the bid on build
2718             // register the additional volume on either the ask or bid
2719             // where volume = oi / capOi
2720             price = isLong
2721                 ? ask(data, _registerVolumeAsk(data, oi, capOi))
2722                 : bid(data, _registerVolumeBid(data, oi, capOi));
2723             // check price hasn't changed more than max slippage specified by trader
2724             require(isLong ? price <= priceLimit : price >= priceLimit, "OVLV1:slippage>max");
2725 
2726             // add new position's open interest to the side's aggregate oi value
2727             // and increase number of oi shares issued
2728             uint256 oiShares = _addToOiAggregates(oi, capOi, isLong);
2729 
2730             // assemble position info data
2731             // check position is not immediately liquidatable prior to storing
2732             Position.Info memory pos = Position.Info({
2733                 notionalInitial: uint96(notional), // won't overflow as capNotional max is 8e24
2734                 debtInitial: uint96(debt),
2735                 midTick: Tick.priceToTick(midPrice),
2736                 entryTick: Tick.priceToTick(price),
2737                 isLong: isLong,
2738                 liquidated: false,
2739                 oiShares: uint240(oiShares), // won't overflow as oiShares ~ notional/mid
2740                 fractionRemaining: ONE.toUint16Fixed()
2741             });
2742             require(
2743                 !pos.liquidatable(
2744                     isLong ? oiLong : oiShort,
2745                     isLong ? oiLongShares : oiShortShares,
2746                     midPrice, // mid price used on liquidations
2747                     params.get(Risk.Parameters.CapPayoff),
2748                     params.get(Risk.Parameters.MaintenanceMarginFraction),
2749                     params.get(Risk.Parameters.LiquidationFeeRate)
2750                 ),
2751                 "OVLV1:liquidatable"
2752             );
2753 
2754             // store the position info data
2755             positionId_ = _totalPositions;
2756             positions.set(msg.sender, positionId_, pos);
2757             _totalPositions++;
2758         }
2759 
2760         // emit build event
2761         emit Build(msg.sender, positionId_, oi, debt, isLong, price);
2762 
2763         // transfer in the OVL collateral needed to back the position + fees
2764         // trading fees charged as a percentage on notional size of position
2765         ovl.transferFrom(msg.sender, address(this), collateral + tradingFee);
2766 
2767         // send trading fees to trading fee recipient
2768         ovl.transfer(IOverlayV1Factory(factory).feeRecipient(), tradingFee);
2769     }
2770 
2771     /// @dev unwinds fraction of an existing position
2772     function unwind(
2773         uint256 positionId,
2774         uint256 fraction,
2775         uint256 priceLimit
2776     ) external notShutdown {
2777         require(fraction <= ONE, "OVLV1:fraction>max");
2778         // only keep 4 decimal precision (1 bps) for fraction given
2779         // pos.fractionRemaining only to 4 decimals
2780         fraction = fraction.toUint16Fixed().toUint256Fixed();
2781         require(fraction > 0, "OVLV1:fraction<min");
2782 
2783         uint256 value;
2784         uint256 cost;
2785         uint256 price;
2786         uint256 tradingFee;
2787         // avoids stack too deep
2788         {
2789             // call to update before any effects
2790             Oracle.Data memory data = update();
2791 
2792             // check position exists
2793             Position.Info memory pos = positions.get(msg.sender, positionId);
2794             require(pos.exists(), "OVLV1:!position");
2795 
2796             // cache for gas savings
2797             uint256 oiTotalOnSide = pos.isLong ? oiLong : oiShort;
2798             uint256 oiTotalSharesOnSide = pos.isLong ? oiLongShares : oiShortShares;
2799 
2800             // check position not liquidatable otherwise can't unwind
2801             require(
2802                 !pos.liquidatable(
2803                     oiTotalOnSide,
2804                     oiTotalSharesOnSide,
2805                     _midFromFeed(data), // mid price used on liquidations
2806                     params.get(Risk.Parameters.CapPayoff),
2807                     params.get(Risk.Parameters.MaintenanceMarginFraction),
2808                     params.get(Risk.Parameters.LiquidationFeeRate)
2809                 ),
2810                 "OVLV1:liquidatable"
2811             );
2812 
2813             // longs get the bid and shorts get the ask on unwind
2814             // register the additional volume on either the ask or bid
2815             // where volume = oi / capOi
2816             // current cap only adjusted for bounds (no circuit breaker so traders
2817             // don't get stuck in a position)
2818             uint256 capOi = oiFromNotional(
2819                 capNotionalAdjustedForBounds(data, params.get(Risk.Parameters.CapNotional)),
2820                 _midFromFeed(data)
2821             );
2822             price = pos.isLong
2823                 ? bid(
2824                     data,
2825                     _registerVolumeBid(
2826                         data,
2827                         pos.oiCurrent(fraction, oiTotalOnSide, oiTotalSharesOnSide),
2828                         capOi
2829                     )
2830                 )
2831                 : ask(
2832                     data,
2833                     _registerVolumeAsk(
2834                         data,
2835                         pos.oiCurrent(fraction, oiTotalOnSide, oiTotalSharesOnSide),
2836                         capOi
2837                     )
2838                 );
2839             // check price hasn't changed more than max slippage specified by trader
2840             require(pos.isLong ? price >= priceLimit : price <= priceLimit, "OVLV1:slippage>max");
2841 
2842             // calculate the value and cost of the position for pnl determinations
2843             // and amount to transfer
2844             uint256 capPayoff = params.get(Risk.Parameters.CapPayoff);
2845             value = pos.value(fraction, oiTotalOnSide, oiTotalSharesOnSide, price, capPayoff);
2846             cost = pos.cost(fraction);
2847 
2848             // calculate the trading fee as % on notional
2849             uint256 tradingFeeRate = params.get(Risk.Parameters.TradingFeeRate);
2850             tradingFee = pos.tradingFee(
2851                 fraction,
2852                 oiTotalOnSide,
2853                 oiTotalSharesOnSide,
2854                 price,
2855                 capPayoff,
2856                 tradingFeeRate
2857             );
2858             tradingFee = Math.min(tradingFee, value); // if value < tradingFee
2859 
2860             // subtract unwound open interest from the side's aggregate oi value
2861             // and decrease number of oi shares issued
2862             // NOTE: use subFloor to avoid reverts with oi rounding issues
2863             if (pos.isLong) {
2864                 oiLong = oiLong.subFloor(
2865                     pos.oiCurrent(fraction, oiTotalOnSide, oiTotalSharesOnSide)
2866                 );
2867                 oiLongShares -= pos.oiSharesCurrent(fraction);
2868             } else {
2869                 oiShort = oiShort.subFloor(
2870                     pos.oiCurrent(fraction, oiTotalOnSide, oiTotalSharesOnSide)
2871                 );
2872                 oiShortShares -= pos.oiSharesCurrent(fraction);
2873             }
2874 
2875             // register the amount to be minted/burned
2876             // capPayoff prevents overflow reverts with int256 cast
2877             _registerMintOrBurn(int256(value) - int256(cost));
2878 
2879             // store the updated position info data by reducing the
2880             // oiShares and fraction remaining of initial position
2881             pos.oiShares -= uint240(pos.oiSharesCurrent(fraction));
2882             pos.fractionRemaining = pos.updatedFractionRemaining(fraction);
2883             positions.set(msg.sender, positionId, pos);
2884         }
2885 
2886         // emit unwind event
2887         emit Unwind(msg.sender, positionId, fraction, int256(value) - int256(cost), price);
2888 
2889         // mint or burn the pnl for the position
2890         if (value >= cost) {
2891             ovl.mint(address(this), value - cost);
2892         } else {
2893             ovl.burn(cost - value);
2894         }
2895 
2896         // transfer out the unwound position value less fees to trader
2897         ovl.transfer(msg.sender, value - tradingFee);
2898 
2899         // send trading fees to trading fee recipient
2900         ovl.transfer(IOverlayV1Factory(factory).feeRecipient(), tradingFee);
2901     }
2902 
2903     /// @dev liquidates a liquidatable position
2904     function liquidate(address owner, uint256 positionId) external notShutdown {
2905         uint256 value;
2906         uint256 cost;
2907         uint256 price;
2908         uint256 liquidationFee;
2909         uint256 marginToBurn;
2910         uint256 marginRemaining;
2911         // avoids stack too deep
2912         {
2913             // check position exists
2914             Position.Info memory pos = positions.get(owner, positionId);
2915             require(pos.exists(), "OVLV1:!position");
2916 
2917             // call to update before any effects
2918             Oracle.Data memory data = update();
2919 
2920             // cache for gas savings
2921             uint256 oiTotalOnSide = pos.isLong ? oiLong : oiShort;
2922             uint256 oiTotalSharesOnSide = pos.isLong ? oiLongShares : oiShortShares;
2923             uint256 capPayoff = params.get(Risk.Parameters.CapPayoff);
2924 
2925             // entire position should be liquidated
2926             uint256 fraction = ONE;
2927 
2928             // Use mid price without volume for liquidation (oracle price effectively) to
2929             // prevent market impact manipulation from causing unneccessary liquidations
2930             price = _midFromFeed(data);
2931 
2932             // check position is liquidatable
2933             require(
2934                 pos.liquidatable(
2935                     oiTotalOnSide,
2936                     oiTotalSharesOnSide,
2937                     price,
2938                     capPayoff,
2939                     params.get(Risk.Parameters.MaintenanceMarginFraction),
2940                     params.get(Risk.Parameters.LiquidationFeeRate)
2941                 ),
2942                 "OVLV1:!liquidatable"
2943             );
2944 
2945             // calculate the value and cost of the position for pnl determinations
2946             // and amount to transfer
2947             value = pos.value(fraction, oiTotalOnSide, oiTotalSharesOnSide, price, capPayoff);
2948             cost = pos.cost(fraction);
2949 
2950             // calculate the liquidation fee as % on remaining value
2951             // sent as reward to liquidator
2952             liquidationFee = value.mulDown(params.get(Risk.Parameters.LiquidationFeeRate));
2953             marginRemaining = value - liquidationFee;
2954 
2955             // Reduce burn amount further by the mm burn rate, as insurance
2956             // for cases when not liquidated in time
2957             marginToBurn = marginRemaining.mulDown(
2958                 params.get(Risk.Parameters.MaintenanceMarginBurnRate)
2959             );
2960             marginRemaining -= marginToBurn;
2961 
2962             // subtract liquidated open interest from the side's aggregate oi value
2963             // and decrease number of oi shares issued
2964             // NOTE: use subFloor to avoid reverts with oi rounding issues
2965             if (pos.isLong) {
2966                 oiLong = oiLong.subFloor(
2967                     pos.oiCurrent(fraction, oiTotalOnSide, oiTotalSharesOnSide)
2968                 );
2969                 oiLongShares -= pos.oiSharesCurrent(fraction);
2970             } else {
2971                 oiShort = oiShort.subFloor(
2972                     pos.oiCurrent(fraction, oiTotalOnSide, oiTotalSharesOnSide)
2973                 );
2974                 oiShortShares -= pos.oiSharesCurrent(fraction);
2975             }
2976 
2977             // register the amount to be burned
2978             _registerMintOrBurn(int256(value) - int256(cost) - int256(marginToBurn));
2979 
2980             // store the updated position info data. mark as liquidated
2981             pos.liquidated = true;
2982             pos.oiShares = 0;
2983             pos.fractionRemaining = 0;
2984             positions.set(owner, positionId, pos);
2985         }
2986 
2987         // emit liquidate event
2988         emit Liquidate(
2989             msg.sender,
2990             owner,
2991             positionId,
2992             int256(value) - int256(cost) - int256(marginToBurn),
2993             price
2994         );
2995 
2996         // burn the pnl for the position + insurance margin
2997         ovl.burn(cost - value + marginToBurn);
2998 
2999         // transfer out the liquidation fee to liquidator for reward
3000         ovl.transfer(msg.sender, liquidationFee);
3001 
3002         // send remaining margin to trading fee recipient
3003         ovl.transfer(IOverlayV1Factory(factory).feeRecipient(), marginRemaining);
3004     }
3005 
3006     /// @dev updates market: pays funding and fetches freshest data from feed
3007     /// @dev update is called every time market is interacted with
3008     function update() public returns (Oracle.Data memory) {
3009         // pay funding for time elasped since last interaction w market
3010         _payFunding();
3011 
3012         // fetch new oracle data from feed
3013         // applies sanity check in case of data manipulation
3014         Oracle.Data memory data = IOverlayV1Feed(feed).latest();
3015         require(dataIsValid(data), "OVLV1:!data");
3016 
3017         // return the latest data from feed
3018         return data;
3019     }
3020 
3021     /// @dev sanity check on data fetched from oracle in case of manipulation
3022     /// @dev rough check that log price bounded by +/- priceDriftUpperLimit * dt
3023     /// @dev when comparing priceMacro(now) vs priceMacro(now - macroWindow)
3024     function dataIsValid(Oracle.Data memory data) public view returns (bool) {
3025         // upper and lower limits are e**(+/- priceDriftUpperLimit * dt)
3026         uint256 _dpUpperLimit = dpUpperLimit;
3027         uint256 _dpLowerLimit = ONE.divDown(_dpUpperLimit);
3028 
3029         // compare current price over macro window vs price over macro window
3030         // one macro window in the past
3031         uint256 priceNow = data.priceOverMacroWindow;
3032         uint256 priceLast = data.priceOneMacroWindowAgo;
3033         if (priceLast == 0 || priceNow == 0) {
3034             // data is not valid if price is zero
3035             return false;
3036         }
3037 
3038         // price is valid if within upper and lower limits on drift given
3039         // time elapsed over one macro window
3040         uint256 dp = priceNow.divUp(priceLast);
3041         return (dp >= _dpLowerLimit && dp <= _dpUpperLimit);
3042     }
3043 
3044     /// @notice Current open interest after funding payments transferred
3045     /// @notice from overweight oi side to underweight oi side
3046     /// @dev The value of oiOverweight must be >= oiUnderweight
3047     function oiAfterFunding(
3048         uint256 oiOverweight,
3049         uint256 oiUnderweight,
3050         uint256 timeElapsed
3051     ) public view returns (uint256, uint256) {
3052         uint256 oiTotal = oiOverweight + oiUnderweight;
3053         uint256 oiImbalance = oiOverweight - oiUnderweight;
3054         uint256 oiInvariant = oiUnderweight.mulUp(oiOverweight);
3055 
3056         // If no OI or imbalance, no funding occurs. Handles div by zero case below
3057         if (oiTotal == 0 || oiImbalance == 0) {
3058             return (oiOverweight, oiUnderweight);
3059         }
3060 
3061         // draw down the imbalance by factor of e**(-2*k*t)
3062         // but min to zero if pow = 2*k*t exceeds MAX_NATURAL_EXPONENT
3063         uint256 fundingFactor;
3064         uint256 pow = 2 * params.get(Risk.Parameters.K) * timeElapsed;
3065         if (pow < MAX_NATURAL_EXPONENT) {
3066             fundingFactor = ONE.divDown(pow.expUp()); // e**(-pow)
3067         }
3068 
3069         // Decrease total aggregate open interest (i.e. oiLong + oiShort)
3070         // to compensate protocol for pro-rata share of imbalance liability
3071         // OI_tot(t) = OI_tot(0) * \
3072         //  sqrt( 1 - (OI_imb(0)/OI_tot(0))**2 * (1 - e**(-4*k*t)) )
3073 
3074         // Guaranteed 0 <= underRoot <= 1
3075         uint256 oiImbFraction = oiImbalance.divDown(oiTotal);
3076         uint256 underRoot = ONE -
3077             oiImbFraction.mulDown(oiImbFraction).mulDown(
3078                 ONE - fundingFactor.mulDown(fundingFactor)
3079             );
3080 
3081         // oiTotalNow guaranteed <= oiTotalBefore (burn happens)
3082         oiTotal = oiTotal.mulDown(underRoot.powDown(ONE / 2));
3083 
3084         // Time decay imbalance: OI_imb(t) = OI_imb(0) * e**(-2*k*t)
3085         // oiImbalanceNow guaranteed <= oiImbalanceBefore
3086         oiImbalance = oiImbalance.mulDown(fundingFactor);
3087 
3088         // overweight pays underweight
3089         // use oiOver * oiUnder = invariant for oiUnderNow to avoid any
3090         // potential overflow reverts
3091         oiOverweight = (oiTotal + oiImbalance) / 2;
3092         if (oiOverweight != 0) {
3093             oiUnderweight = oiInvariant.divUp(oiOverweight);
3094         }
3095         return (oiOverweight, oiUnderweight);
3096     }
3097 
3098     /// @dev current oi cap with adjustments to lower in the event
3099     /// @dev market has printed a lot in recent past
3100     function capOiAdjustedForCircuitBreaker(uint256 cap) public view returns (uint256) {
3101         // Adjust cap downward for circuit breaker. Use snapshotMinted
3102         // but transformed to account for decay in magnitude of minted since
3103         // last snapshot taken
3104         Roller.Snapshot memory snapshot = snapshotMinted;
3105         uint256 circuitBreakerWindow = params.get(Risk.Parameters.CircuitBreakerWindow);
3106         snapshot = snapshot.transform(block.timestamp, circuitBreakerWindow, 0);
3107         cap = circuitBreaker(snapshot, cap);
3108         return cap;
3109     }
3110 
3111     /// @dev bound on oi cap from circuit breaker
3112     /// @dev Three cases:
3113     /// @dev 1. minted < 1x target amount over circuitBreakerWindow: return cap
3114     /// @dev 2. minted > 2x target amount over last circuitBreakerWindow: return 0
3115     /// @dev 3. minted between 1x and 2x target amount: return cap * (2 - minted/target)
3116     function circuitBreaker(Roller.Snapshot memory snapshot, uint256 cap)
3117         public
3118         view
3119         returns (uint256)
3120     {
3121         int256 minted = int256(snapshot.cumulative());
3122         uint256 circuitBreakerMintTarget = params.get(Risk.Parameters.CircuitBreakerMintTarget);
3123         if (minted <= int256(circuitBreakerMintTarget)) {
3124             return cap;
3125         } else if (minted >= 2 * int256(circuitBreakerMintTarget)) {
3126             return 0;
3127         }
3128 
3129         // case 3 (circuit breaker adjustment downward)
3130         uint256 adjustment = 2 * ONE - uint256(minted).divDown(circuitBreakerMintTarget);
3131         return cap.mulDown(adjustment);
3132     }
3133 
3134     /// @dev current notional cap with adjustments to prevent
3135     /// @dev front-running trade and back-running trade
3136     function capNotionalAdjustedForBounds(Oracle.Data memory data, uint256 cap)
3137         public
3138         view
3139         returns (uint256)
3140     {
3141         if (data.hasReserve) {
3142             // Adjust cap downward if exceeds bounds from front run attack
3143             cap = Math.min(cap, frontRunBound(data));
3144 
3145             // Adjust cap downward if exceeds bounds from back run attack
3146             cap = Math.min(cap, backRunBound(data));
3147         }
3148         return cap;
3149     }
3150 
3151     /// @dev bound on notional cap to mitigate front-running attack
3152     /// @dev bound = lmbda * reserveInOvl
3153     function frontRunBound(Oracle.Data memory data) public view returns (uint256) {
3154         uint256 lmbda = params.get(Risk.Parameters.Lmbda);
3155         return lmbda.mulDown(data.reserveOverMicroWindow);
3156     }
3157 
3158     /// @dev bound on notional cap to mitigate back-running attack
3159     /// @dev bound = macroWindowInBlocks * reserveInOvl * 2 * delta
3160     function backRunBound(Oracle.Data memory data) public view returns (uint256) {
3161         uint256 averageBlockTime = params.get(Risk.Parameters.AverageBlockTime);
3162         uint256 window = (data.macroWindow * ONE) / averageBlockTime;
3163         uint256 delta = params.get(Risk.Parameters.Delta);
3164         return delta.mulDown(data.reserveOverMicroWindow).mulDown(window).mulDown(2 * ONE);
3165     }
3166 
3167     /// @dev Returns the open interest in number of contracts for a given notional
3168     /// @dev Uses _midFromFeed(data) price to calculate oi: OI = Q / P
3169     function oiFromNotional(uint256 notional, uint256 midPrice) public view returns (uint256) {
3170         return notional.divDown(midPrice);
3171     }
3172 
3173     /// @dev bid price given oracle data and recent volume
3174     function bid(Oracle.Data memory data, uint256 volume) public view returns (uint256 bid_) {
3175         bid_ = Math.min(data.priceOverMicroWindow, data.priceOverMacroWindow);
3176 
3177         // add static spread (delta) and market impact (lmbda * volume)
3178         uint256 delta = params.get(Risk.Parameters.Delta);
3179         uint256 lmbda = params.get(Risk.Parameters.Lmbda);
3180         uint256 pow = delta + lmbda.mulUp(volume);
3181         require(pow < MAX_NATURAL_EXPONENT, "OVLV1:slippage>max");
3182 
3183         bid_ = bid_.mulDown(ONE.divDown(pow.expUp())); // bid * e**(-pow)
3184     }
3185 
3186     /// @dev ask price given oracle data and recent volume
3187     function ask(Oracle.Data memory data, uint256 volume) public view returns (uint256 ask_) {
3188         ask_ = Math.max(data.priceOverMicroWindow, data.priceOverMacroWindow);
3189 
3190         // add static spread (delta) and market impact (lmbda * volume)
3191         uint256 delta = params.get(Risk.Parameters.Delta);
3192         uint256 lmbda = params.get(Risk.Parameters.Lmbda);
3193         uint256 pow = delta + lmbda.mulUp(volume);
3194         require(pow < MAX_NATURAL_EXPONENT, "OVLV1:slippage>max");
3195 
3196         ask_ = ask_.mulUp(pow.expUp()); // ask * e**(pow)
3197     }
3198 
3199     /// @dev mid price without impact/spread given oracle data and recent volume
3200     /// @dev used for gas savings to avoid accessing storage for delta, lmbda
3201     function _midFromFeed(Oracle.Data memory data) private view returns (uint256 mid_) {
3202         mid_ = Math.average(data.priceOverMicroWindow, data.priceOverMacroWindow);
3203     }
3204 
3205     /// @dev Rolling volume adjustments on bid side to be used for market impact.
3206     /// @dev Volume values are normalized with respect to cap
3207     function _registerVolumeBid(
3208         Oracle.Data memory data,
3209         uint256 volume,
3210         uint256 cap
3211     ) private returns (uint256) {
3212         // save gas with snapshot in memory
3213         Roller.Snapshot memory snapshot = snapshotVolumeBid;
3214         int256 value = int256(volume.divUp(cap));
3215 
3216         // calculates the decay in the rolling volume since last snapshot
3217         // and determines new window to decay over
3218         snapshot = snapshot.transform(block.timestamp, data.microWindow, value);
3219 
3220         // store the transformed snapshot
3221         snapshotVolumeBid = snapshot;
3222 
3223         // return the cumulative volume
3224         return uint256(snapshot.cumulative());
3225     }
3226 
3227     /// @dev Rolling volume adjustments on ask side to be used for market impact.
3228     /// @dev Volume values are normalized with respect to cap
3229     function _registerVolumeAsk(
3230         Oracle.Data memory data,
3231         uint256 volume,
3232         uint256 cap
3233     ) private returns (uint256) {
3234         // save gas with snapshot in memory
3235         Roller.Snapshot memory snapshot = snapshotVolumeAsk;
3236         int256 value = int256(volume.divUp(cap));
3237 
3238         // calculates the decay in the rolling volume since last snapshot
3239         // and determines new window to decay over
3240         snapshot = snapshot.transform(block.timestamp, data.microWindow, value);
3241 
3242         // store the transformed snapshot
3243         snapshotVolumeAsk = snapshot;
3244 
3245         // return the cumulative volume
3246         return uint256(snapshot.cumulative());
3247     }
3248 
3249     /// @notice Rolling mint accumulator to be used for circuit breaker
3250     /// @dev value > 0 registers a mint, value <= 0 registers a burn
3251     function _registerMintOrBurn(int256 value) private returns (int256) {
3252         // save gas with snapshot in memory
3253         Roller.Snapshot memory snapshot = snapshotMinted;
3254 
3255         // calculates the decay in the rolling amount minted since last snapshot
3256         // and determines new window to decay over
3257         uint256 circuitBreakerWindow = params.get(Risk.Parameters.CircuitBreakerWindow);
3258         snapshot = snapshot.transform(block.timestamp, circuitBreakerWindow, value);
3259 
3260         // store the transformed snapshot
3261         snapshotMinted = snapshot;
3262 
3263         // return the cumulative mint amount
3264         int256 minted = snapshot.cumulative();
3265         return minted;
3266     }
3267 
3268     /// @notice Updates the market for funding changes to open interest
3269     /// @notice since last time market was interacted with
3270     function _payFunding() private {
3271         // apply funding if at least one block has passed
3272         uint256 timeElapsed = block.timestamp - timestampUpdateLast;
3273         if (timeElapsed > 0) {
3274             // calculate adjustments to oi due to funding
3275             bool isLongOverweight = oiLong > oiShort;
3276             uint256 oiOverweight = isLongOverweight ? oiLong : oiShort;
3277             uint256 oiUnderweight = isLongOverweight ? oiShort : oiLong;
3278             (oiOverweight, oiUnderweight) = oiAfterFunding(
3279                 oiOverweight,
3280                 oiUnderweight,
3281                 timeElapsed
3282             );
3283 
3284             // pay funding
3285             oiLong = isLongOverweight ? oiOverweight : oiUnderweight;
3286             oiShort = isLongOverweight ? oiUnderweight : oiOverweight;
3287 
3288             // set last time market was updated
3289             timestampUpdateLast = block.timestamp;
3290         }
3291     }
3292 
3293     /// @notice Adds open interest and open interest shares to aggregate storage
3294     /// @notice pairs (oiLong, oiLongShares) or (oiShort, oiShortShares)
3295     /// @return oiShares_ as the new position's shares of aggregate open interest
3296     function _addToOiAggregates(
3297         uint256 oi,
3298         uint256 capOi,
3299         bool isLong
3300     ) private returns (uint256 oiShares_) {
3301         // cache for gas savings
3302         uint256 oiTotalOnSide = isLong ? oiLong : oiShort;
3303         uint256 oiTotalSharesOnSide = isLong ? oiLongShares : oiShortShares;
3304 
3305         // calculate oi shares
3306         uint256 oiShares = Position.calcOiShares(oi, oiTotalOnSide, oiTotalSharesOnSide);
3307 
3308         // add oi and oi shares to temp aggregate values
3309         oiTotalOnSide += oi;
3310         oiTotalSharesOnSide += oiShares;
3311 
3312         // check new total oi on side does not exceed capOi after
3313         // adjusted for circuit breaker
3314         uint256 capOiCircuited = capOiAdjustedForCircuitBreaker(capOi);
3315         require(oiTotalOnSide <= capOiCircuited, "OVLV1:oi>cap");
3316 
3317         // update total aggregate oi and oi shares storage vars
3318         if (isLong) {
3319             oiLong = oiTotalOnSide;
3320             oiLongShares = oiTotalSharesOnSide;
3321         } else {
3322             oiShort = oiTotalOnSide;
3323             oiShortShares = oiTotalSharesOnSide;
3324         }
3325 
3326         // return new position's oi shares
3327         oiShares_ = oiShares;
3328     }
3329 
3330     /// @notice Sets the governance per-market risk parameter
3331     /// @dev updates funding state of market but does not fetch from oracle
3332     /// @dev to avoid edge cases when dataIsValid is false
3333     function setRiskParam(Risk.Parameters name, uint256 value) external onlyFactory {
3334         // pay funding to update state of market since last interaction
3335         _payFunding();
3336 
3337         // check then set risk param
3338         _checkRiskParam(name, value);
3339         _cacheRiskCalc(name, value);
3340         params.set(name, value);
3341     }
3342 
3343     /// @notice Checks the governance per-market risk parameter is valid
3344     function _checkRiskParam(Risk.Parameters name, uint256 value) private {
3345         // checks delta won't cause position to be immediately
3346         // liquidatable given current leverage cap (capLeverage),
3347         // liquidation fee rate (liquidationFeeRate), and
3348         // maintenance margin fraction (maintenanceMarginFraction)
3349         if (name == Risk.Parameters.Delta) {
3350             uint256 _delta = value;
3351             uint256 capLeverage = params.get(Risk.Parameters.CapLeverage);
3352             uint256 maintenanceMarginFraction = params.get(
3353                 Risk.Parameters.MaintenanceMarginFraction
3354             );
3355             uint256 liquidationFeeRate = params.get(Risk.Parameters.LiquidationFeeRate);
3356             require(
3357                 capLeverage <=
3358                     ONE.divDown(
3359                         2 * _delta + maintenanceMarginFraction.divDown(ONE - liquidationFeeRate)
3360                     ),
3361                 "OVLV1: max lev immediately liquidatable"
3362             );
3363         }
3364 
3365         // checks capLeverage won't cause position to be immediately
3366         // liquidatable given current spread (delta),
3367         // liquidation fee rate (liquidationFeeRate), and
3368         // maintenance margin fraction (maintenanceMarginFraction)
3369         if (name == Risk.Parameters.CapLeverage) {
3370             uint256 _capLeverage = value;
3371             uint256 delta = params.get(Risk.Parameters.Delta);
3372             uint256 maintenanceMarginFraction = params.get(
3373                 Risk.Parameters.MaintenanceMarginFraction
3374             );
3375             uint256 liquidationFeeRate = params.get(Risk.Parameters.LiquidationFeeRate);
3376             require(
3377                 _capLeverage <=
3378                     ONE.divDown(
3379                         2 * delta + maintenanceMarginFraction.divDown(ONE - liquidationFeeRate)
3380                     ),
3381                 "OVLV1: max lev immediately liquidatable"
3382             );
3383         }
3384 
3385         // checks maintenanceMarginFraction won't cause position
3386         // to be immediately liquidatable given current spread (delta),
3387         // liquidation fee rate (liquidationFeeRate),
3388         // and leverage cap (capLeverage)
3389         if (name == Risk.Parameters.MaintenanceMarginFraction) {
3390             uint256 _maintenanceMarginFraction = value;
3391             uint256 delta = params.get(Risk.Parameters.Delta);
3392             uint256 capLeverage = params.get(Risk.Parameters.CapLeverage);
3393             uint256 liquidationFeeRate = params.get(Risk.Parameters.LiquidationFeeRate);
3394             require(
3395                 capLeverage <=
3396                     ONE.divDown(
3397                         2 * delta + _maintenanceMarginFraction.divDown(ONE - liquidationFeeRate)
3398                     ),
3399                 "OVLV1: max lev immediately liquidatable"
3400             );
3401         }
3402 
3403         // checks liquidationFeeRate won't cause position
3404         // to be immediately liquidatable given current spread (delta),
3405         // leverage cap (capLeverage), and
3406         // maintenance margin fraction (maintenanceMarginFraction)
3407         if (name == Risk.Parameters.LiquidationFeeRate) {
3408             uint256 _liquidationFeeRate = value;
3409             uint256 delta = params.get(Risk.Parameters.Delta);
3410             uint256 capLeverage = params.get(Risk.Parameters.CapLeverage);
3411             uint256 maintenanceMarginFraction = params.get(
3412                 Risk.Parameters.MaintenanceMarginFraction
3413             );
3414             require(
3415                 capLeverage <=
3416                     ONE.divDown(
3417                         2 * delta + maintenanceMarginFraction.divDown(ONE - _liquidationFeeRate)
3418                     ),
3419                 "OVLV1: max lev immediately liquidatable"
3420             );
3421         }
3422 
3423         // checks priceDriftUpperLimit won't cause pow() call in dataIsValid
3424         // to exceed max
3425         if (name == Risk.Parameters.PriceDriftUpperLimit) {
3426             Oracle.Data memory data = IOverlayV1Feed(feed).latest();
3427             uint256 _priceDriftUpperLimit = value;
3428             require(
3429                 _priceDriftUpperLimit * data.macroWindow < MAX_NATURAL_EXPONENT,
3430                 "OVLV1: price drift exceeds max exp"
3431             );
3432         }
3433     }
3434 
3435     /// @notice Caches risk param calculations used in market contract
3436     /// @notice for gas savings
3437     function _cacheRiskCalc(Risk.Parameters name, uint256 value) private {
3438         // caches calculations for dpUpperLimit
3439         // = e**(priceDriftUpperLimit * data.macroWindow)
3440         if (name == Risk.Parameters.PriceDriftUpperLimit) {
3441             Oracle.Data memory data = IOverlayV1Feed(feed).latest();
3442             uint256 _priceDriftUpperLimit = value;
3443             uint256 pow = _priceDriftUpperLimit * data.macroWindow;
3444             dpUpperLimit = pow.expUp(); // e**(pow)
3445         }
3446     }
3447 
3448     /// @notice Irreversibly shuts down the market. Can be triggered by
3449     /// @notice governance through factory contract in the event of an emergency
3450     function shutdown() external notShutdown onlyFactory {
3451         isShutdown = true;
3452     }
3453 
3454     /// @notice Allows emergency withdrawal of remaining collateral
3455     /// @notice associated with position. Ignores any outstanding PnL and
3456     /// @notice funding considerations
3457     function emergencyWithdraw(uint256 positionId) external hasShutdown {
3458         // check position exists
3459         Position.Info memory pos = positions.get(msg.sender, positionId);
3460         require(pos.exists(), "OVLV1:!position");
3461 
3462         // calculate remaining collateral backing position
3463         uint256 fraction = ONE;
3464         uint256 cost = pos.cost(fraction);
3465         cost = Math.min(ovl.balanceOf(address(this)), cost); // if cost > balance
3466 
3467         // set fraction remaining to zero so position no longer exists
3468         pos.fractionRemaining = 0;
3469         positions.set(msg.sender, positionId, pos);
3470 
3471         // emit withdraw event
3472         emit EmergencyWithdraw(msg.sender, positionId, cost);
3473 
3474         // transfer available collateral out to position owner
3475         ovl.transfer(msg.sender, cost);
3476     }
3477 }