1 // The software and documentation available in this repository (the "Software") is protected by copyright law and accessible pursuant to the license set forth below. Copyright © 2020 MRTB Ltd. All rights reserved.
2 //
3 // Permission is hereby granted, free of charge, to any person or organization obtaining the Software (the “Licensee”) to privately study, review, and analyze the Software. Licensee shall not use the Software for any other purpose. Licensee shall not modify, transfer, assign, share, or sub-license the Software or any derivative works of the Software.
4 //
5 // THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, TITLE, AND NON-INFRINGEMENT. IN NO EVENT SHALL THE COPYRIGHT HOLDERS BE LIABLE FOR ANY DAMAGES OR OTHER LIABILITY, WHETHER IN CONTRACT, TORT, OR OTHERWISE, ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE.
6 
7 pragma solidity 0.5.15;
8 pragma experimental ABIEncoderV2;
9 
10 
11 contract ReentrancyGuard {
12     bool private _notEntered;
13 
14     constructor () internal {
15         // Storing an initial non-zero value makes deployment a bit more
16         // expensive, but in exchange the refund on every call to nonReentrant
17         // will be lower in amount. Since refunds are capped to a percetange of
18         // the total transaction's gas, it is best to keep them low in cases
19         // like this one, to increase the likelihood of the full refund coming
20         // into effect.
21         _notEntered = true;
22     }
23 
24     /**
25      * @dev Prevents a contract from calling itself, directly or indirectly.
26      * Calling a `nonReentrant` function from another `nonReentrant`
27      * function is not supported. It is possible to prevent this from happening
28      * by making the `nonReentrant` function external, and make it call a
29      * `private` function that does the actual work.
30      */
31     modifier nonReentrant() {
32         // On the first call to nonReentrant, _notEntered will be true
33         require(_notEntered, "ReentrancyGuard: reentrant call");
34 
35         // Any calls to nonReentrant after this point will fail
36         _notEntered = false;
37 
38         _;
39 
40         // By storing the original value once again, a refund is triggered (see
41         // https://eips.ethereum.org/EIPS/eip-2200)
42         _notEntered = true;
43     }
44 }
45 
46 library LibEIP712 {
47     string internal constant DOMAIN_NAME = "Mai Protocol";
48 
49     /**
50      * Hash of the EIP712 Domain Separator Schema
51      */
52     bytes32 private constant EIP712_DOMAIN_TYPEHASH = keccak256(abi.encodePacked("EIP712Domain(string name)"));
53 
54     bytes32 private constant DOMAIN_SEPARATOR = keccak256(
55         abi.encodePacked(EIP712_DOMAIN_TYPEHASH, keccak256(bytes(DOMAIN_NAME)))
56     );
57 
58     /**
59      * Calculates EIP712 encoding for a hash struct in this EIP712 Domain.
60      *
61      * @param eip712hash The EIP712 hash struct.
62      * @return EIP712 hash applied to this EIP712 Domain.
63      */
64     function hashEIP712Message(bytes32 eip712hash) internal pure returns (bytes32) {
65         return keccak256(abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR, eip712hash));
66     }
67 }
68 
69 library ECDSA {
70     /**
71      * @dev Returns the address that signed a hashed message (`hash`) with
72      * `signature`. This address can then be used for verification purposes.
73      *
74      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
75      * this function rejects them by requiring the `s` value to be in the lower
76      * half order, and the `v` value to be either 27 or 28.
77      *
78      * NOTE: This call _does not revert_ if the signature is invalid, or
79      * if the signer is otherwise unable to be retrieved. In those scenarios,
80      * the zero address is returned.
81      *
82      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
83      * verification to be secure: it is possible to craft signatures that
84      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
85      * this is by receiving a hash of the original message (which may otherwise
86      * be too long), and then calling {toEthSignedMessageHash} on it.
87      */
88     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
89         // Check the signature length
90         if (signature.length != 65) {
91             return (address(0));
92         }
93 
94         // Divide the signature in r, s and v variables
95         bytes32 r;
96         bytes32 s;
97         uint8 v;
98 
99         // ecrecover takes the signature parameters, and the only way to get them
100         // currently is to use assembly.
101         // solhint-disable-next-line no-inline-assembly
102         assembly {
103             r := mload(add(signature, 0x20))
104             s := mload(add(signature, 0x40))
105             v := byte(0, mload(add(signature, 0x60)))
106         }
107 
108         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
109         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
110         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
111         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
112         //
113         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
114         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
115         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
116         // these malleable signatures as well.
117         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
118             return address(0);
119         }
120 
121         if (v != 27 && v != 28) {
122             return address(0);
123         }
124 
125         // If the signature is valid (and not malleable), return the signer address
126         return ecrecover(hash, v, r, s);
127     }
128 
129     /**
130      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
131      * replicates the behavior of the
132      * https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_sign[`eth_sign`]
133      * JSON-RPC method.
134      *
135      * See {recover}.
136      */
137     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
138         // 32 is the length in bytes of hash,
139         // enforced by the type signature above
140         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
141     }
142 }
143 
144 library LibSignature {
145     enum SignatureMethod {ETH_SIGN, EIP712}
146 
147     struct OrderSignature {
148         bytes32 config;
149         bytes32 r;
150         bytes32 s;
151     }
152 
153     /**
154      * Validate a signature given a hash calculated from the order data, the signer, and the
155      * signature data passed in with the order.
156      *
157      * This function will revert the transaction if the signature method is invalid.
158      *
159      * @param signature The signature data passed along with the order to validate against
160      * @param hash Hash bytes calculated by taking the hash of the passed order data
161      * @param signerAddress The address of the signer
162      * @return True if the calculated signature matches the order signature data, false otherwise.
163      */
164     function isValidSignature(OrderSignature memory signature, bytes32 hash, address signerAddress)
165         internal
166         pure
167         returns (bool)
168     {
169         uint8 method = uint8(signature.config[1]);
170         address recovered;
171         uint8 v = uint8(signature.config[0]);
172 
173         if (method == uint8(SignatureMethod.ETH_SIGN)) {
174             recovered = recover(
175                 keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)),
176                 v,
177                 signature.r,
178                 signature.s
179             );
180         } else if (method == uint8(SignatureMethod.EIP712)) {
181             recovered = recover(hash, v, signature.r, signature.s);
182         } else {
183             revert("invalid sign method");
184         }
185 
186         return signerAddress == recovered;
187     }
188 
189     // see "@openzeppelin/contracts/cryptography/ECDSA.sol"
190     function recover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal pure returns (address) {
191         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
192             revert("ECDSA: invalid signature 's' value");
193         }
194 
195         if (v != 27 && v != 28) {
196             revert("ECDSA: invalid signature 'v' value");
197         }
198 
199         // If the signature is valid (and not malleable), return the signer address
200         address signer = ecrecover(hash, v, r, s);
201         require(signer != address(0), "ECDSA: invalid signature");
202 
203         return signer;
204     }
205 }
206 
207 library LibMathSigned {
208     int256 private constant _WAD = 10 ** 18;
209     int256 private constant _INT256_MIN = -2 ** 255;
210 
211     uint8 private constant FIXED_DIGITS = 18;
212     int256 private constant FIXED_1 = 10 ** 18;
213     int256 private constant FIXED_E = 2718281828459045235;
214     uint8 private constant LONGER_DIGITS = 36;
215     int256 private constant LONGER_FIXED_LOG_E_1_5 = 405465108108164381978013115464349137;
216     int256 private constant LONGER_FIXED_1 = 10 ** 36;
217     int256 private constant LONGER_FIXED_LOG_E_10 = 2302585092994045684017991454684364208;
218 
219 
220     function WAD() internal pure returns (int256) {
221         return _WAD;
222     }
223 
224     // additive inverse
225     function neg(int256 a) internal pure returns (int256) {
226         return sub(int256(0), a);
227     }
228 
229     /**
230      * @dev Multiplies two signed integers, reverts on overflow
231      * see https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.0.1/contracts/math/SignedSafeMath.sol#L13
232      */
233     function mul(int256 a, int256 b) internal pure returns (int256) {
234         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
235         // benefit is lost if 'b' is also tested.
236         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
237         if (a == 0) {
238             return 0;
239         }
240         require(!(a == -1 && b == _INT256_MIN), "wmultiplication overflow");
241 
242         int256 c = a * b;
243         require(c / a == b, "wmultiplication overflow");
244 
245         return c;
246     }
247 
248     /**
249      * @dev Integer division of two signed integers truncating the quotient, reverts on division by zero.
250      * see https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.0.1/contracts/math/SignedSafeMath.sol#L32
251      */
252     function div(int256 a, int256 b) internal pure returns (int256) {
253         require(b != 0, "wdivision by zero");
254         require(!(b == -1 && a == _INT256_MIN), "wdivision overflow");
255 
256         int256 c = a / b;
257 
258         return c;
259     }
260 
261     /**
262      * @dev Subtracts two signed integers, reverts on overflow.
263      * see https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.0.1/contracts/math/SignedSafeMath.sol#L44
264      */
265     function sub(int256 a, int256 b) internal pure returns (int256) {
266         int256 c = a - b;
267         require((b >= 0 && c <= a) || (b < 0 && c > a), "subtraction overflow");
268 
269         return c;
270     }
271 
272     /**
273      * @dev Adds two signed integers, reverts on overflow.
274      * see https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.0.1/contracts/math/SignedSafeMath.sol#L54
275      */
276     function add(int256 a, int256 b) internal pure returns (int256) {
277         int256 c = a + b;
278         require((b >= 0 && c >= a) || (b < 0 && c < a), "addition overflow");
279 
280         return c;
281     }
282 
283     function wmul(int256 x, int256 y) internal pure returns (int256 z) {
284         z = roundHalfUp(mul(x, y), _WAD) / _WAD;
285     }
286 
287     // solium-disable-next-line security/no-assign-params
288     function wdiv(int256 x, int256 y) internal pure returns (int256 z) {
289         if (y < 0) {
290             y = -y;
291             x = -x;
292         }
293         z = roundHalfUp(mul(x, _WAD), y) / y;
294     }
295 
296     // solium-disable-next-line security/no-assign-params
297     function wfrac(int256 x, int256 y, int256 z) internal pure returns (int256 r) {
298         int256 t = mul(x, y);
299         if (z < 0) {
300             z = neg(z);
301             t = neg(t);
302         }
303         r = roundHalfUp(t, z) / z;
304     }
305 
306     function min(int256 x, int256 y) internal pure returns (int256) {
307         return x <= y ? x : y;
308     }
309 
310     function max(int256 x, int256 y) internal pure returns (int256) {
311         return x >= y ? x : y;
312     }
313 
314     // see https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.0.1/contracts/utils/SafeCast.sol#L103
315     function toUint256(int256 x) internal pure returns (uint256) {
316         require(x >= 0, "int overflow");
317         return uint256(x);
318     }
319 
320     // x ^ n
321     // NOTE: n is a normal integer, do not shift 18 decimals
322     // solium-disable-next-line security/no-assign-params
323     function wpowi(int256 x, int256 n) internal pure returns (int256 z) {
324         require(n >= 0, "wpowi only supports n >= 0");
325         z = n % 2 != 0 ? x : _WAD;
326 
327         for (n /= 2; n != 0; n /= 2) {
328             x = wmul(x, x);
329 
330             if (n % 2 != 0) {
331                 z = wmul(z, x);
332             }
333         }
334     }
335 
336     // ROUND_HALF_UP rule helper. You have to call roundHalfUp(x, y) / y to finish the rounding operation
337     // 0.5 ≈ 1, 0.4 ≈ 0, -0.5 ≈ -1, -0.4 ≈ 0
338     function roundHalfUp(int256 x, int256 y) internal pure returns (int256) {
339         require(y > 0, "roundHalfUp only supports y > 0");
340         if (x >= 0) {
341             return add(x, y / 2);
342         }
343         return sub(x, y / 2);
344     }
345 
346     // solium-disable-next-line security/no-assign-params
347     function wln(int256 x) internal pure returns (int256) {
348         require(x > 0, "logE of negative number");
349         require(x <= 10000000000000000000000000000000000000000, "logE only accepts v <= 1e22 * 1e18"); // in order to prevent using safe-math
350         int256 r = 0;
351         uint8 extraDigits = LONGER_DIGITS - FIXED_DIGITS;
352         int256 t = int256(uint256(10)**uint256(extraDigits));
353 
354         while (x <= FIXED_1 / 10) {
355             x = x * 10;
356             r -= LONGER_FIXED_LOG_E_10;
357         }
358         while (x >= 10 * FIXED_1) {
359             x = x / 10;
360             r += LONGER_FIXED_LOG_E_10;
361         }
362         while (x < FIXED_1) {
363             x = wmul(x, FIXED_E);
364             r -= LONGER_FIXED_1;
365         }
366         while (x > FIXED_E) {
367             x = wdiv(x, FIXED_E);
368             r += LONGER_FIXED_1;
369         }
370         if (x == FIXED_1) {
371             return roundHalfUp(r, t) / t;
372         }
373         if (x == FIXED_E) {
374             return FIXED_1 + roundHalfUp(r, t) / t;
375         }
376         x *= t;
377 
378         //               x^2   x^3   x^4
379         // Ln(1+x) = x - --- + --- - --- + ...
380         //                2     3     4
381         // when -1 < x < 1, O(x^n) < ε => when n = 36, 0 < x < 0.316
382         //
383         //                    2    x           2    x          2    x
384         // Ln(a+x) = Ln(a) + ---(------)^1  + ---(------)^3 + ---(------)^5 + ...
385         //                    1   2a+x         3   2a+x        5   2a+x
386         //
387         // Let x = v - a
388         //                  2   v-a         2   v-a        2   v-a
389         // Ln(v) = Ln(a) + ---(-----)^1  + ---(-----)^3 + ---(-----)^5 + ...
390         //                  1   v+a         3   v+a        5   v+a
391         // when n = 36, 1 < v < 3.423
392         r = r + LONGER_FIXED_LOG_E_1_5;
393         int256 a1_5 = (3 * LONGER_FIXED_1) / 2;
394         int256 m = (LONGER_FIXED_1 * (x - a1_5)) / (x + a1_5);
395         r = r + 2 * m;
396         int256 m2 = (m * m) / LONGER_FIXED_1;
397         uint8 i = 3;
398         while (true) {
399             m = (m * m2) / LONGER_FIXED_1;
400             r = r + (2 * m) / int256(i);
401             i += 2;
402             if (i >= 3 + 2 * FIXED_DIGITS) {
403                 break;
404             }
405         }
406         return roundHalfUp(r, t) / t;
407     }
408 
409     // Log(b, x)
410     function logBase(int256 base, int256 x) internal pure returns (int256) {
411         return wdiv(wln(x), wln(base));
412     }
413 
414     function ceil(int256 x, int256 m) internal pure returns (int256) {
415         require(x >= 0, "ceil need x >= 0");
416         require(m > 0, "ceil need m > 0");
417         return (sub(add(x, m), 1) / m) * m;
418     }
419 }
420 
421 library LibMathUnsigned {
422     uint256 private constant _WAD = 10**18;
423     uint256 private constant _POSITIVE_INT256_MAX = 2**255 - 1;
424 
425     function WAD() internal pure returns (uint256) {
426         return _WAD;
427     }
428 
429     /**
430      * @dev Returns the addition of two unsigned integers, reverting on overflow.
431      * see https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.0.1/contracts/math/SafeMath.sol#L26
432      */
433     function add(uint256 a, uint256 b) internal pure returns (uint256) {
434         uint256 c = a + b;
435         require(c >= a, "Unaddition overflow");
436 
437         return c;
438     }
439 
440     /**
441      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
442      * overflow (when the result is negative).
443      * see https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.0.1/contracts/math/SafeMath.sol#L55
444      */
445     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
446         require(b <= a, "Unsubtraction overflow");
447         uint256 c = a - b;
448 
449         return c;
450     }
451 
452     /**
453      * @dev Returns the multiplication of two unsigned integers, reverting on
454      * overflow.
455      * see https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.0.1/contracts/math/SafeMath.sol#L71
456      */
457     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
458         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
459         // benefit is lost if 'b' is also tested.
460         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
461         if (a == 0) {
462             return 0;
463         }
464 
465         uint256 c = a * b;
466         require(c / a == b, "Unmultiplication overflow");
467 
468         return c;
469     }
470 
471     /**
472      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
473      * division by zero. The result is rounded towards zero.
474      * see https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.0.1/contracts/math/SafeMath.sol#L111
475      */
476     function div(uint256 a, uint256 b) internal pure returns (uint256) {
477         // Solidity only automatically asserts when dividing by 0
478         require(b > 0, "Undivision by zero");
479         uint256 c = a / b;
480         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
481 
482         return c;
483     }
484 
485     function wmul(uint256 x, uint256 y) internal pure returns (uint256 z) {
486         z = add(mul(x, y), _WAD / 2) / _WAD;
487     }
488 
489     function wdiv(uint256 x, uint256 y) internal pure returns (uint256 z) {
490         z = add(mul(x, _WAD), y / 2) / y;
491     }
492 
493     function wfrac(uint256 x, uint256 y, uint256 z) internal pure returns (uint256 r) {
494         r = mul(x, y) / z;
495     }
496 
497     function min(uint256 x, uint256 y) internal pure returns (uint256) {
498         return x <= y ? x : y;
499     }
500 
501     function max(uint256 x, uint256 y) internal pure returns (uint256) {
502         return x >= y ? x : y;
503     }
504 
505     function toInt256(uint256 x) internal pure returns (int256) {
506         require(x <= _POSITIVE_INT256_MAX, "uint256 overflow");
507         return int256(x);
508     }
509 
510     /**
511      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
512      * Reverts with custom message when dividing by zero.
513      * see https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.0.1/contracts/math/SafeMath.sol#L146
514      */
515     function mod(uint256 x, uint256 m) internal pure returns (uint256) {
516         require(m != 0, "mod by zero");
517         return x % m;
518     }
519 
520     function ceil(uint256 x, uint256 m) internal pure returns (uint256) {
521         require(m > 0, "ceil need m > 0");
522         return (sub(add(x, m), 1) / m) * m;
523     }
524 }
525 
526 library LibTypes {
527     enum Side {FLAT, SHORT, LONG}
528 
529     enum Status {NORMAL, EMERGENCY, SETTLED}
530 
531     function counterSide(Side side) internal pure returns (Side) {
532         if (side == Side.LONG) {
533             return Side.SHORT;
534         } else if (side == Side.SHORT) {
535             return Side.LONG;
536         }
537         return side;
538     }
539 
540     //////////////////////////////////////////////////////////////////////////
541     // Perpetual
542     //////////////////////////////////////////////////////////////////////////
543     struct PerpGovernanceConfig {
544         uint256 initialMarginRate;
545         uint256 maintenanceMarginRate;
546         uint256 liquidationPenaltyRate;
547         uint256 penaltyFundRate;
548         int256 takerDevFeeRate;
549         int256 makerDevFeeRate;
550         uint256 lotSize;
551         uint256 tradingLotSize;
552     }
553 
554     struct MarginAccount {
555         LibTypes.Side side;
556         uint256 size;
557         uint256 entryValue;
558         int256 entrySocialLoss;
559         int256 entryFundingLoss;
560         int256 cashBalance;
561     }
562 
563     //////////////////////////////////////////////////////////////////////////
564     // AMM
565     //////////////////////////////////////////////////////////////////////////
566     struct AMMGovernanceConfig {
567         uint256 poolFeeRate;
568         uint256 poolDevFeeRate;
569         int256 emaAlpha;
570         uint256 updatePremiumPrize;
571         int256 markPremiumLimit;
572         int256 fundingDampener;
573     }
574 
575     struct FundingState {
576         uint256 lastFundingTime;
577         int256 lastPremium;
578         int256 lastEMAPremium;
579         uint256 lastIndexPrice;
580         int256 accumulatedFundingPerContract;
581     }
582 }
583 
584 library LibOrder {
585     using LibMathSigned for int256;
586     using LibMathUnsigned for uint256;
587 
588     bytes32 public constant EIP712_ORDER_TYPE = keccak256(
589         abi.encodePacked(
590             "Order(address trader,address broker,address perpetual,uint256 amount,uint256 price,bytes32 data)"
591         )
592     );
593 
594     int256 public constant FEE_RATE_BASE = 10 ** 5;
595 
596     struct Order {
597         address trader;
598         address broker;
599         address perpetual;
600         uint256 amount;
601         uint256 price;
602         /**
603          * Data contains the following values packed into 32 bytes
604          * ╔════════════════════╤═══════════════════════════════════════════════════════════╗
605          * ║                    │ length(bytes)   desc                                      ║
606          * ╟────────────────────┼───────────────────────────────────────────────────────────╢
607          * ║ version            │ 1               order version                             ║
608          * ║ side               │ 1               0: buy (long), 1: sell (short)            ║
609          * ║ isMarketOrder      │ 1               0: limitOrder, 1: marketOrder             ║
610          * ║ expiredAt          │ 5               order expiration time in seconds          ║
611          * ║ asMakerFeeRate     │ 2               maker fee rate (base 100,000)             ║
612          * ║ asTakerFeeRate     │ 2               taker fee rate (base 100,000)             ║
613          * ║ (d) makerRebateRate│ 2               rebate rate for maker (base 100)          ║
614          * ║ salt               │ 8               salt                                      ║
615          * ║ isMakerOnly        │ 1               is maker only                             ║
616          * ║ isInversed         │ 1               is inversed contract                      ║
617          * ║ chainId            │ 8               chain id                                  ║
618          * ╚════════════════════╧═══════════════════════════════════════════════════════════╝
619          */
620         bytes32 data;
621     }
622 
623     struct OrderParam {
624         address trader;
625         uint256 amount;
626         uint256 price;
627         bytes32 data;
628         LibSignature.OrderSignature signature;
629     }
630 
631     /**
632      * @dev Get order hash from parameters of order. Rebuild order and hash it.
633      *
634      * @param orderParam Order parameters.
635      * @param perpetual  Address of perpetual contract.
636      * @param broker     Address of broker.
637      * @return Hash of the order.
638      */
639     function getOrderHash(
640         OrderParam memory orderParam,
641         address perpetual,
642         address broker
643     ) internal pure returns (bytes32 orderHash) {
644         Order memory order = getOrder(orderParam, perpetual, broker);
645         orderHash = LibEIP712.hashEIP712Message(hashOrder(order));
646     }
647 
648     /**
649      * @dev Get order hash from order.
650      *
651      * @param order Order to hash.
652      * @return Hash of the order.
653      */
654     function getOrderHash(Order memory order) internal pure returns (bytes32 orderHash) {
655         orderHash = LibEIP712.hashEIP712Message(hashOrder(order));
656     }
657 
658     /**
659      * @dev Get order from parameters.
660      *
661      * @param orderParam Order parameters.
662      * @param perpetual  Address of perpetual contract.
663      * @param broker     Address of broker.
664      * @return Order data structure.
665      */
666     function getOrder(
667         OrderParam memory orderParam,
668         address perpetual,
669         address broker
670     ) internal pure returns (LibOrder.Order memory order) {
671         order.trader = orderParam.trader;
672         order.broker = broker;
673         order.perpetual = perpetual;
674         order.amount = orderParam.amount;
675         order.price = orderParam.price;
676         order.data = orderParam.data;
677     }
678 
679     /**
680      * @dev Hash fields in order to generate a hash as identifier.
681      *
682      * @param order Order to hash.
683      * @return Hash of the order.
684      */
685     function hashOrder(Order memory order) internal pure returns (bytes32 result) {
686         bytes32 orderType = EIP712_ORDER_TYPE;
687         // solium-disable-next-line security/no-inline-assembly
688         assembly {
689             // "Order(address trader,address broker,address perpetual,uint256 amount,uint256 price,bytes32 data)"
690             // hash these 6 field to get a hash
691             // address will be extended to 32 bytes.
692             let start := sub(order, 32)
693             let tmp := mload(start)
694             mstore(start, orderType)
695             // [0...32)   bytes: EIP712_ORDER_TYPE, len 32
696             // [32...224) bytes: order, len 6 * 32
697             // 224 = 32 + 192
698             result := keccak256(start, 224)
699             mstore(start, tmp)
700         }
701     }
702 
703     // extract order parameters.
704 
705     function orderVersion(OrderParam memory orderParam) internal pure returns (uint256) {
706         return uint256(uint8(bytes1(orderParam.data)));
707     }
708 
709     function expiredAt(OrderParam memory orderParam) internal pure returns (uint256) {
710         return uint256(uint40(bytes5(orderParam.data << (8 * 3))));
711     }
712 
713     function isSell(OrderParam memory orderParam) internal pure returns (bool) {
714         bool sell = uint8(orderParam.data[1]) == 1;
715         return isInversed(orderParam) ? !sell : sell;
716     }
717 
718     function getPrice(OrderParam memory orderParam) internal pure returns (uint256) {
719         return isInversed(orderParam) ? LibMathUnsigned.WAD().wdiv(orderParam.price) : orderParam.price;
720     }
721 
722     function isMarketOrder(OrderParam memory orderParam) internal pure returns (bool) {
723         return uint8(orderParam.data[2]) > 0;
724     }
725 
726     function isMarketBuy(OrderParam memory orderParam) internal pure returns (bool) {
727         return !isSell(orderParam) && isMarketOrder(orderParam);
728     }
729 
730     function isMakerOnly(OrderParam memory orderParam) internal pure returns (bool) {
731         return uint8(orderParam.data[22]) > 0;
732     }
733 
734     function isInversed(OrderParam memory orderParam) internal pure returns (bool) {
735         return uint8(orderParam.data[23]) > 0;
736     }
737 
738     function side(OrderParam memory orderParam) internal pure returns (LibTypes.Side) {
739         return isSell(orderParam) ? LibTypes.Side.SHORT : LibTypes.Side.LONG;
740     }
741 
742     function makerFeeRate(OrderParam memory orderParam) internal pure returns (int256) {
743         return int256(int16(bytes2(orderParam.data << (8 * 8)))).mul(LibMathSigned.WAD()).div(FEE_RATE_BASE);
744     }
745 
746     function takerFeeRate(OrderParam memory orderParam) internal pure returns (int256) {
747         return int256(int16(bytes2(orderParam.data << (8 * 10)))).mul(LibMathSigned.WAD()).div(FEE_RATE_BASE);
748     }
749 
750     function chainId(OrderParam memory orderParam) internal pure returns (uint256) {
751         return uint256(uint64(bytes8(orderParam.data << (8 * 24))));
752     }
753 }
754 
755 interface IERC20 {
756     /**
757      * @dev Returns the amount of tokens in existence.
758      */
759     function totalSupply() external view returns (uint256);
760 
761     /**
762      * @dev Returns the amount of tokens owned by `account`.
763      */
764     function balanceOf(address account) external view returns (uint256);
765 
766     /**
767      * @dev Moves `amount` tokens from the caller's account to `recipient`.
768      *
769      * Returns a boolean value indicating whether the operation succeeded.
770      *
771      * Emits a {Transfer} event.
772      */
773     function transfer(address recipient, uint256 amount) external returns (bool);
774 
775     /**
776      * @dev Returns the remaining number of tokens that `spender` will be
777      * allowed to spend on behalf of `owner` through {transferFrom}. This is
778      * zero by default.
779      *
780      * This value changes when {approve} or {transferFrom} are called.
781      */
782     function allowance(address owner, address spender) external view returns (uint256);
783 
784     /**
785      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
786      *
787      * Returns a boolean value indicating whether the operation succeeded.
788      *
789      * IMPORTANT: Beware that changing an allowance with this method brings the risk
790      * that someone may use both the old and the new allowance by unfortunate
791      * transaction ordering. One possible solution to mitigate this race
792      * condition is to first reduce the spender's allowance to 0 and set the
793      * desired value afterwards:
794      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
795      *
796      * Emits an {Approval} event.
797      */
798     function approve(address spender, uint256 amount) external returns (bool);
799 
800     /**
801      * @dev Moves `amount` tokens from `sender` to `recipient` using the
802      * allowance mechanism. `amount` is then deducted from the caller's
803      * allowance.
804      *
805      * Returns a boolean value indicating whether the operation succeeded.
806      *
807      * Emits a {Transfer} event.
808      */
809     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
810 
811     /**
812      * @dev Emitted when `value` tokens are moved from one account (`from`) to
813      * another (`to`).
814      *
815      * Note that `value` may be zero.
816      */
817     event Transfer(address indexed from, address indexed to, uint256 value);
818 
819     /**
820      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
821      * a call to {approve}. `value` is the new allowance.
822      */
823     event Approval(address indexed owner, address indexed spender, uint256 value);
824 }
825 
826 library SafeMath {
827     /**
828      * @dev Returns the addition of two unsigned integers, reverting on
829      * overflow.
830      *
831      * Counterpart to Solidity's `+` operator.
832      *
833      * Requirements:
834      * - Addition cannot overflow.
835      */
836     function add(uint256 a, uint256 b) internal pure returns (uint256) {
837         uint256 c = a + b;
838         require(c >= a, "SafeMath: addition overflow");
839 
840         return c;
841     }
842 
843     /**
844      * @dev Returns the subtraction of two unsigned integers, reverting on
845      * overflow (when the result is negative).
846      *
847      * Counterpart to Solidity's `-` operator.
848      *
849      * Requirements:
850      * - Subtraction cannot overflow.
851      */
852     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
853         return sub(a, b, "SafeMath: subtraction overflow");
854     }
855 
856     /**
857      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
858      * overflow (when the result is negative).
859      *
860      * Counterpart to Solidity's `-` operator.
861      *
862      * Requirements:
863      * - Subtraction cannot overflow.
864      *
865      * _Available since v2.4.0._
866      */
867     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
868         require(b <= a, errorMessage);
869         uint256 c = a - b;
870 
871         return c;
872     }
873 
874     /**
875      * @dev Returns the multiplication of two unsigned integers, reverting on
876      * overflow.
877      *
878      * Counterpart to Solidity's `*` operator.
879      *
880      * Requirements:
881      * - Multiplication cannot overflow.
882      */
883     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
884         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
885         // benefit is lost if 'b' is also tested.
886         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
887         if (a == 0) {
888             return 0;
889         }
890 
891         uint256 c = a * b;
892         require(c / a == b, "SafeMath: multiplication overflow");
893 
894         return c;
895     }
896 
897     /**
898      * @dev Returns the integer division of two unsigned integers. Reverts on
899      * division by zero. The result is rounded towards zero.
900      *
901      * Counterpart to Solidity's `/` operator. Note: this function uses a
902      * `revert` opcode (which leaves remaining gas untouched) while Solidity
903      * uses an invalid opcode to revert (consuming all remaining gas).
904      *
905      * Requirements:
906      * - The divisor cannot be zero.
907      */
908     function div(uint256 a, uint256 b) internal pure returns (uint256) {
909         return div(a, b, "SafeMath: division by zero");
910     }
911 
912     /**
913      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
914      * division by zero. The result is rounded towards zero.
915      *
916      * Counterpart to Solidity's `/` operator. Note: this function uses a
917      * `revert` opcode (which leaves remaining gas untouched) while Solidity
918      * uses an invalid opcode to revert (consuming all remaining gas).
919      *
920      * Requirements:
921      * - The divisor cannot be zero.
922      *
923      * _Available since v2.4.0._
924      */
925     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
926         // Solidity only automatically asserts when dividing by 0
927         require(b > 0, errorMessage);
928         uint256 c = a / b;
929         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
930 
931         return c;
932     }
933 
934     /**
935      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
936      * Reverts when dividing by zero.
937      *
938      * Counterpart to Solidity's `%` operator. This function uses a `revert`
939      * opcode (which leaves remaining gas untouched) while Solidity uses an
940      * invalid opcode to revert (consuming all remaining gas).
941      *
942      * Requirements:
943      * - The divisor cannot be zero.
944      */
945     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
946         return mod(a, b, "SafeMath: modulo by zero");
947     }
948 
949     /**
950      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
951      * Reverts with custom message when dividing by zero.
952      *
953      * Counterpart to Solidity's `%` operator. This function uses a `revert`
954      * opcode (which leaves remaining gas untouched) while Solidity uses an
955      * invalid opcode to revert (consuming all remaining gas).
956      *
957      * Requirements:
958      * - The divisor cannot be zero.
959      *
960      * _Available since v2.4.0._
961      */
962     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
963         require(b != 0, errorMessage);
964         return a % b;
965     }
966 }
967 
968 library Address {
969     /**
970      * @dev Returns true if `account` is a contract.
971      *
972      * [IMPORTANT]
973      * ====
974      * It is unsafe to assume that an address for which this function returns
975      * false is an externally-owned account (EOA) and not a contract.
976      *
977      * Among others, `isContract` will return false for the following 
978      * types of addresses:
979      *
980      *  - an externally-owned account
981      *  - a contract in construction
982      *  - an address where a contract will be created
983      *  - an address where a contract lived, but was destroyed
984      * ====
985      */
986     function isContract(address account) internal view returns (bool) {
987         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
988         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
989         // for accounts without code, i.e. `keccak256('')`
990         bytes32 codehash;
991         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
992         // solhint-disable-next-line no-inline-assembly
993         assembly { codehash := extcodehash(account) }
994         return (codehash != accountHash && codehash != 0x0);
995     }
996 
997     /**
998      * @dev Converts an `address` into `address payable`. Note that this is
999      * simply a type cast: the actual underlying value is not changed.
1000      *
1001      * _Available since v2.4.0._
1002      */
1003     function toPayable(address account) internal pure returns (address payable) {
1004         return address(uint160(account));
1005     }
1006 
1007     /**
1008      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1009      * `recipient`, forwarding all available gas and reverting on errors.
1010      *
1011      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1012      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1013      * imposed by `transfer`, making them unable to receive funds via
1014      * `transfer`. {sendValue} removes this limitation.
1015      *
1016      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1017      *
1018      * IMPORTANT: because control is transferred to `recipient`, care must be
1019      * taken to not create reentrancy vulnerabilities. Consider using
1020      * {ReentrancyGuard} or the
1021      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1022      *
1023      * _Available since v2.4.0._
1024      */
1025     function sendValue(address payable recipient, uint256 amount) internal {
1026         require(address(this).balance >= amount, "Address: insufficient balance");
1027 
1028         // solhint-disable-next-line avoid-call-value
1029         (bool success, ) = recipient.call.value(amount)("");
1030         require(success, "Address: unable to send value, recipient may have reverted");
1031     }
1032 }
1033 
1034 library SafeERC20 {
1035     using SafeMath for uint256;
1036     using Address for address;
1037 
1038     function safeTransfer(IERC20 token, address to, uint256 value) internal {
1039         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
1040     }
1041 
1042     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
1043         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
1044     }
1045 
1046     function safeApprove(IERC20 token, address spender, uint256 value) internal {
1047         // safeApprove should only be called when setting an initial allowance,
1048         // or when resetting it to zero. To increase and decrease it, use
1049         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1050         // solhint-disable-next-line max-line-length
1051         require((value == 0) || (token.allowance(address(this), spender) == 0),
1052             "SafeERC20: approve from non-zero to non-zero allowance"
1053         );
1054         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
1055     }
1056 
1057     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
1058         uint256 newAllowance = token.allowance(address(this), spender).add(value);
1059         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1060     }
1061 
1062     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
1063         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
1064         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1065     }
1066 
1067     /**
1068      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1069      * on the return value: the return value is optional (but if data is returned, it must not be false).
1070      * @param token The token targeted by the call.
1071      * @param data The call data (encoded using abi.encode or one of its variants).
1072      */
1073     function callOptionalReturn(IERC20 token, bytes memory data) private {
1074         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1075         // we're implementing it ourselves.
1076 
1077         // A Solidity high level call has three parts:
1078         //  1. The target address is checked to verify it contains contract code
1079         //  2. The call itself is made, and success asserted
1080         //  3. The return value is decoded, which in turn checks the size of the returned data.
1081         // solhint-disable-next-line max-line-length
1082         require(address(token).isContract(), "SafeERC20: call to non-contract");
1083 
1084         // solhint-disable-next-line avoid-low-level-calls
1085         (bool success, bytes memory returndata) = address(token).call(data);
1086         require(success, "SafeERC20: low-level call failed");
1087 
1088         if (returndata.length > 0) { // Return data is optional
1089             // solhint-disable-next-line max-line-length
1090             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1091         }
1092     }
1093 }
1094 
1095 interface IPerpetual {
1096     function devAddress() external view returns (address);
1097 
1098     function getMarginAccount(address trader) external view returns (LibTypes.MarginAccount memory);
1099 
1100     function getGovernance() external view returns (LibTypes.PerpGovernanceConfig memory);
1101 
1102     function status() external view returns (LibTypes.Status);
1103 
1104     function paused() external view returns (bool);
1105 
1106     function withdrawDisabled() external view returns (bool);
1107 
1108     function settlementPrice() external view returns (uint256);
1109 
1110     function globalConfig() external view returns (address);
1111 
1112     function collateral() external view returns (address);
1113 
1114     function amm() external view returns (IAMM);
1115 
1116     function totalSize(LibTypes.Side side) external view returns (uint256);
1117 
1118     function markPrice() external returns (uint256);
1119 
1120     function socialLossPerContract(LibTypes.Side side) external view returns (int256);
1121 
1122     function availableMargin(address trader) external returns (int256);
1123 
1124     function positionMargin(address trader) external view returns (uint256);
1125 
1126     function maintenanceMargin(address trader) external view returns (uint256);
1127 
1128     function isSafe(address trader) external returns (bool);
1129 
1130     function isSafeWithPrice(address trader, uint256 currentMarkPrice) external returns (bool);
1131 
1132     function isIMSafe(address trader) external returns (bool);
1133 
1134     function isIMSafeWithPrice(address trader, uint256 currentMarkPrice) external returns (bool);
1135 
1136     function tradePosition(
1137         address taker,
1138         address maker,
1139         LibTypes.Side side,
1140         uint256 price,
1141         uint256 amount
1142     ) external returns (uint256, uint256);
1143 
1144     function transferCashBalance(
1145         address from,
1146         address to,
1147         uint256 amount
1148     ) external;
1149 
1150     function depositFor(address trader, uint256 amount) external payable;
1151 
1152     function withdrawFor(address payable trader, uint256 amount) external;
1153 
1154     function liquidate(address trader, uint256 amount) external returns (uint256, uint256);
1155 
1156     function insuranceFundBalance() external view returns (int256);
1157 
1158     function beginGlobalSettlement(uint256 price) external;
1159 
1160     function endGlobalSettlement() external;
1161 
1162     function isValidLotSize(uint256 amount) external view returns (bool);
1163 
1164     function isValidTradingLotSize(uint256 amount) external view returns (bool);
1165 }
1166 
1167 interface IAMM {
1168     function shareTokenAddress() external view returns (address);
1169 
1170     function indexPrice() external view returns (uint256 price, uint256 timestamp);
1171 
1172     function positionSize() external returns (uint256);
1173 
1174     function lastFundingState() external view returns (LibTypes.FundingState memory);
1175 
1176     function currentFundingRate() external returns (int256);
1177 
1178     function currentFundingState() external returns (LibTypes.FundingState memory);
1179 
1180     function lastFundingRate() external view returns (int256);
1181 
1182     function getGovernance() external view returns (LibTypes.AMMGovernanceConfig memory);
1183 
1184     function perpetualProxy() external view returns (IPerpetual);
1185 
1186     function currentMarkPrice() external returns (uint256);
1187 
1188     function currentAvailableMargin() external returns (uint256);
1189 
1190     function currentPremiumRate() external returns (int256);
1191 
1192     function currentFairPrice() external returns (uint256);
1193 
1194     function currentPremium() external returns (int256);
1195 
1196     function currentAccumulatedFundingPerContract() external returns (int256);
1197 
1198     function updateIndex() external;
1199 
1200     function createPool(uint256 amount) external;
1201 
1202     function settleShare(uint256 shareAmount) external;
1203 
1204     function buy(uint256 amount, uint256 limitPrice, uint256 deadline) external returns (uint256);
1205 
1206     function sell(uint256 amount, uint256 limitPrice, uint256 deadline) external returns (uint256);
1207 
1208     function buyFromWhitelisted(address trader, uint256 amount, uint256 limitPrice, uint256 deadline)
1209         external
1210         returns (uint256);
1211 
1212     function sellFromWhitelisted(address trader, uint256 amount, uint256 limitPrice, uint256 deadline)
1213         external
1214         returns (uint256);
1215 
1216     function buyFrom(address trader, uint256 amount, uint256 limitPrice, uint256 deadline) external returns (uint256);
1217 
1218     function sellFrom(address trader, uint256 amount, uint256 limitPrice, uint256 deadline) external returns (uint256);
1219 
1220     function depositAndBuy(
1221         uint256 depositAmount,
1222         uint256 tradeAmount,
1223         uint256 limitPrice,
1224         uint256 deadline
1225     ) external payable;
1226 
1227     function depositAndSell(
1228         uint256 depositAmount,
1229         uint256 tradeAmount,
1230         uint256 limitPrice,
1231         uint256 deadline
1232     ) external payable;
1233 
1234     function buyAndWithdraw(
1235         uint256 tradeAmount,
1236         uint256 limitPrice,
1237         uint256 deadline,
1238         uint256 withdrawAmount
1239     ) external;
1240 
1241     function sellAndWithdraw(
1242         uint256 tradeAmount,
1243         uint256 limitPrice,
1244         uint256 deadline,
1245         uint256 withdrawAmount
1246     ) external;
1247 
1248     function depositAndAddLiquidity(uint256 depositAmount, uint256 amount) external payable;
1249 }
1250 
1251 interface IGlobalConfig {
1252 
1253     function owner() external view returns (address);
1254 
1255     function isOwner() external view returns (bool);
1256 
1257     function renounceOwnership() external;
1258 
1259     function transferOwnership(address newOwner) external;
1260 
1261     function brokers(address broker) external view returns (bool);
1262     
1263     function pauseControllers(address broker) external view returns (bool);
1264 
1265     function withdrawControllers(address broker) external view returns (bool);
1266 
1267     function addBroker() external;
1268 
1269     function removeBroker() external;
1270 
1271     function isComponent(address component) external view returns (bool);
1272 
1273     function addComponent(address perpetual, address component) external;
1274 
1275     function removeComponent(address perpetual, address component) external;
1276 
1277     function addPauseController(address controller) external;
1278 
1279     function removePauseController(address controller) external;
1280 
1281     function addWithdrawController(address controller) external;
1282 
1283     function removeWithdrawControllers(address controller) external;
1284 }
1285 
1286 contract PerpetualStorage {
1287     using LibMathSigned for int256;
1288     using LibMathUnsigned for uint256;
1289 
1290     bool public paused = false;
1291     bool public withdrawDisabled = false;
1292 
1293     // Global configuation instance address
1294     IGlobalConfig public globalConfig;
1295     // AMM address
1296     IAMM public amm;
1297     // Address of collateral;
1298     IERC20 public collateral;
1299     // DEV address
1300     address public devAddress;
1301     // Status of perpetual
1302     LibTypes.Status public status;
1303     // Settment price replacing index price in settled status
1304     uint256 public settlementPrice;
1305     // Governance parameters
1306     LibTypes.PerpGovernanceConfig internal governance;
1307     // Insurance balance
1308     int256 public insuranceFundBalance;
1309     // Total size
1310     uint256[3] internal totalSizes;
1311     // Socialloss
1312     int256[3] internal socialLossPerContracts;
1313     // Scaler helps to convert decimals
1314     int256 internal scaler;
1315     // Mapping from owner to its margin account
1316     mapping (address => LibTypes.MarginAccount) internal marginAccounts;
1317 
1318     // TODO: Should be UpdateSocialLoss but to compatible off-chain part
1319     event SocialLoss(LibTypes.Side side, int256 newVal);
1320 
1321     /**
1322      * @dev Helper to access social loss per contract.
1323      *      FLAT is always 0.
1324      *
1325      * @param side Side of position.
1326      * @return Total opened position size of given side.
1327      */
1328     function socialLossPerContract(LibTypes.Side side) public view returns (int256) {
1329         return socialLossPerContracts[uint256(side)];
1330     }
1331 
1332     /**
1333      * @dev Help to get total opend position size of every side.
1334      *      FLAT is always 0 and LONG should always equal to SHORT.
1335      *
1336      * @param side Side of position.
1337      * @return Total opened position size of given side.
1338      */
1339     function totalSize(LibTypes.Side side) public view returns (uint256) {
1340         return totalSizes[uint256(side)];
1341     }
1342 
1343     /**
1344      * @dev Return data structure of current governance parameters.
1345      *
1346      * @return Data structure of current governance parameters.
1347      */
1348     function getGovernance() public view returns (LibTypes.PerpGovernanceConfig memory) {
1349         return governance;
1350     }
1351 
1352     /**
1353      * @dev Get underlaying data structure of a margin account.
1354      *
1355      * @param trader   Address of the account owner.
1356      * @return Margin account data.
1357      */
1358     function getMarginAccount(address trader) public view returns (LibTypes.MarginAccount memory) {
1359         return marginAccounts[trader];
1360     }
1361 }
1362 
1363 contract PerpetualGovernance is PerpetualStorage {
1364 
1365     event UpdateGovernanceParameter(bytes32 indexed key, int256 value);
1366     event UpdateGovernanceAddress(bytes32 indexed key, address value);
1367 
1368     constructor(address _globalConfig) public {
1369         require(_globalConfig != address(0), "invalid global config");
1370         globalConfig = IGlobalConfig(_globalConfig);
1371     }
1372 
1373     // Check if amm address is set.
1374     modifier ammRequired() {
1375         require(address(amm) != address(0), "no automated market maker");
1376         _;
1377     }
1378 
1379     // Check if sender is owner.
1380     modifier onlyOwner() {
1381         require(globalConfig.owner() == msg.sender, "not owner");
1382         _;
1383     }
1384 
1385     // Check if sender is authorized to call some critical functions.
1386     modifier onlyAuthorized() {
1387         require(globalConfig.isComponent(msg.sender), "unauthorized caller");
1388         _;
1389     }
1390 
1391     // Check if system is current paused. 
1392     modifier onlyNotPaused () {
1393         require(!paused, "system paused");
1394         _;
1395     }
1396 
1397     /**
1398      * @dev Set governance parameters.
1399      *
1400      * @param key   Name of parameter.
1401      * @param value Value of parameter.
1402      */
1403     function setGovernanceParameter(bytes32 key, int256 value) public onlyOwner {
1404         if (key == "initialMarginRate") {
1405             governance.initialMarginRate = value.toUint256();
1406             require(governance.initialMarginRate > 0, "require im > 0");
1407             require(governance.initialMarginRate < 10**18, "require im < 1");
1408             require(governance.maintenanceMarginRate < governance.initialMarginRate, "require mm < im");
1409         } else if (key == "maintenanceMarginRate") {
1410             governance.maintenanceMarginRate = value.toUint256();
1411             require(governance.maintenanceMarginRate > 0, "require mm > 0");
1412             require(governance.maintenanceMarginRate < governance.initialMarginRate, "require mm < im");
1413             require(governance.liquidationPenaltyRate < governance.maintenanceMarginRate, "require lpr < mm");
1414             require(governance.penaltyFundRate < governance.maintenanceMarginRate, "require pfr < mm");
1415         } else if (key == "liquidationPenaltyRate") {
1416             governance.liquidationPenaltyRate = value.toUint256();
1417             require(governance.liquidationPenaltyRate < governance.maintenanceMarginRate, "require lpr < mm");
1418         } else if (key == "penaltyFundRate") {
1419             governance.penaltyFundRate = value.toUint256();
1420             require(governance.penaltyFundRate < governance.maintenanceMarginRate, "require pfr < mm");
1421         } else if (key == "takerDevFeeRate") {
1422             governance.takerDevFeeRate = value;
1423         } else if (key == "makerDevFeeRate") {
1424             governance.makerDevFeeRate = value;
1425         } else if (key == "lotSize") {
1426             require(
1427                 governance.tradingLotSize == 0 || governance.tradingLotSize.mod(value.toUint256()) == 0,
1428                 "require tls % ls == 0"
1429             );
1430             governance.lotSize = value.toUint256();
1431         } else if (key == "tradingLotSize") {
1432             require(governance.lotSize == 0 || value.toUint256().mod(governance.lotSize) == 0, "require tls % ls == 0");
1433             governance.tradingLotSize = value.toUint256();
1434         } else if (key == "longSocialLossPerContracts") {
1435             require(status == LibTypes.Status.EMERGENCY, "wrong perpetual status");
1436             socialLossPerContracts[uint256(LibTypes.Side.LONG)] = value;
1437         } else if (key == "shortSocialLossPerContracts") {
1438             require(status == LibTypes.Status.EMERGENCY, "wrong perpetual status");
1439             socialLossPerContracts[uint256(LibTypes.Side.SHORT)] = value;
1440         } else {
1441             revert("key not exists");
1442         }
1443         emit UpdateGovernanceParameter(key, value);
1444     }
1445 
1446     /**
1447      * @dev Set governance address. like set governance parameter.
1448      *
1449      * @param key   Name of parameter.
1450      * @param value Address to set.
1451      */
1452     function setGovernanceAddress(bytes32 key, address value) public onlyOwner {
1453         require(value != address(0), "invalid address");
1454         if (key == "dev") {
1455             devAddress = value;
1456         } else if (key == "amm") {
1457             amm = IAMM(value);
1458         } else if (key == "globalConfig") {
1459             globalConfig = IGlobalConfig(value);
1460         } else {
1461             revert("key not exists");
1462         }
1463         emit UpdateGovernanceAddress(key, value);
1464     }
1465 
1466     /** 
1467      * @dev Check amount with lot size. Amount must be integral multiple of lot size.
1468      */
1469     function isValidLotSize(uint256 amount) public view returns (bool) {
1470         return amount > 0 && amount.mod(governance.lotSize) == 0;
1471     }
1472 
1473     /**
1474      * @dev Check amount with trading lot size. Amount must be integral multiple of trading lot size.
1475      *      This is useful in trading to control minimal trading position size.
1476      */
1477     function isValidTradingLotSize(uint256 amount) public view returns (bool) {
1478         return amount > 0 && amount.mod(governance.tradingLotSize) == 0;
1479     }
1480 }
1481 
1482 contract Collateral is PerpetualGovernance {
1483     using LibMathSigned for int256;
1484     using SafeERC20 for IERC20;
1485 
1486     // Available decimals should be within [0, 18]
1487     uint256 private constant MAX_DECIMALS = 18;
1488 
1489     event Deposit(address indexed trader, int256 wadAmount, int256 balance);
1490     event Withdraw(address indexed trader, int256 wadAmount, int256 balance);
1491 
1492     /**
1493      * @dev Constructor of Collateral contract. Initialize collateral type and decimals.
1494      * @param _collateral   Address of collateral token. 0x0 means using ether instead of erc20 token.
1495      * @param _decimals     Decimals of collateral token. The value should be within range [0, 18].
1496      */
1497     constructor(address _globalConfig, address _collateral, uint256 _decimals)
1498         public
1499         PerpetualGovernance(_globalConfig)
1500     {
1501         require(_decimals <= MAX_DECIMALS, "decimals out of range");
1502         require(_collateral != address(0) || _decimals == 18, "invalid decimals");
1503 
1504         collateral = IERC20(_collateral);
1505         // This statement will cause a 'InternalCompilerError: Assembly exception for bytecode'
1506         // scaler = (_decimals == MAX_DECIMALS ? 1 : 10**(MAX_DECIMALS.sub(_decimals))).toInt256();
1507         // But this will not.
1508         scaler = int256(10**(MAX_DECIMALS - _decimals));
1509     }
1510 
1511     // ** All interface call from upper layer use the decimals of the collateral, called 'rawAmount'.
1512 
1513     /**
1514      * @dev Indicates that whether current collateral is an erc20 token.
1515      * @return True if current collateral is an erc20 token.
1516      */
1517     function isTokenizedCollateral() internal view returns (bool) {
1518         return address(collateral) != address(0);
1519     }
1520 
1521     /**
1522      * @dev Deposit collateral into trader's colleteral account. Decimals of collateral will be converted into internal
1523      *      decimals (18) then.
1524      *      For example:
1525      *          For a USDT-ETH contract, depositing 10 ** 6 USDT will increase the cash balance by 10 ** 18.
1526      *          But for a DAI-ETH contract, the depositing amount should be 10 ** 18 to get the same cash balance.
1527      *
1528      * @param trader    Address of account owner.
1529      * @param rawAmount Amount of collateral to be deposited in its original decimals.
1530      * @return  True if current collateral is an erc20 token.
1531      */
1532     function deposit(address trader, uint256 rawAmount) internal {
1533         int256 wadAmount = pullCollateral(trader, rawAmount);
1534         marginAccounts[trader].cashBalance = marginAccounts[trader].cashBalance.add(wadAmount);
1535         emit Deposit(trader, wadAmount, marginAccounts[trader].cashBalance);
1536     }
1537 
1538     /**
1539      * @dev Withdraw collaterals from trader's margin account to his ethereum address.
1540      *      The amount to withdraw is in its original decimals.
1541      *
1542      * @param trader    Address of account owner.
1543      * @param rawAmount Amount of collateral to be deposited in its original decimals.
1544      */
1545     function withdraw(address payable trader, uint256 rawAmount) internal {
1546         require(rawAmount > 0, "amount must be greater than 0");
1547         int256 wadAmount = toWad(rawAmount);
1548         require(wadAmount <= marginAccounts[trader].cashBalance, "insufficient balance");
1549         marginAccounts[trader].cashBalance = marginAccounts[trader].cashBalance.sub(wadAmount);
1550         pushCollateral(trader, rawAmount);
1551 
1552         emit Withdraw(trader, wadAmount, marginAccounts[trader].cashBalance);
1553     }
1554 
1555     /**
1556      * @dev Transfer collateral from user if collateral is erc20 token.
1557      *
1558      * @param trader    Address of account owner.
1559      * @param rawAmount Amount of collateral to be transferred into contract.
1560      * @return Internal representation of the raw amount.
1561      */
1562     function pullCollateral(address trader, uint256 rawAmount) internal returns (int256 wadAmount) {
1563         require(rawAmount > 0, "amount must be greater than 0");
1564         if (isTokenizedCollateral()) {
1565             collateral.safeTransferFrom(trader, address(this), rawAmount);
1566         }
1567         wadAmount = toWad(rawAmount);
1568     }
1569 
1570     /**
1571      * @dev Transfer collateral to user no matter erc20 token or ether.
1572      *
1573      * @param trader    Address of account owner.
1574      * @param rawAmount Amount of collateral to be transferred to user.
1575      * @return Internal representation of the raw amount.
1576      */
1577     function pushCollateral(address payable trader, uint256 rawAmount) internal returns (int256 wadAmount) {
1578         if (isTokenizedCollateral()) {
1579             collateral.safeTransfer(trader, rawAmount);
1580         } else {
1581             Address.sendValue(trader, rawAmount);
1582         }
1583         return toWad(rawAmount);
1584     }
1585 
1586     /**
1587      * @dev Convert the represention of amount from raw to internal.
1588      *
1589      * @param rawAmount Amount with decimals of collateral.
1590      * @return Amount with internal decimals.
1591      */
1592     function toWad(uint256 rawAmount) internal view returns (int256) {
1593         return rawAmount.toInt256().mul(scaler);
1594     }
1595 
1596     /**
1597      * @dev Convert the represention of amount from internal to raw.
1598      *
1599      * @param amount Amount with internal decimals.
1600      * @return Amount with decimals of collateral.
1601      */
1602     function toCollateral(int256 amount) internal view returns (uint256) {
1603         return amount.div(scaler).toUint256();
1604     }
1605 }
1606 
1607 contract MarginAccount is Collateral {
1608     using LibMathSigned for int256;
1609     using LibMathUnsigned for uint256;
1610     using LibTypes for LibTypes.Side;
1611 
1612     event UpdatePositionAccount(
1613         address indexed trader,
1614         LibTypes.MarginAccount account,
1615         uint256 perpetualTotalSize,
1616         uint256 price
1617     );
1618     event UpdateInsuranceFund(int256 newVal);
1619     event Transfer(address indexed from, address indexed to, int256 wadAmount, int256 balanceFrom, int256 balanceTo);
1620     event InternalUpdateBalance(address indexed trader, int256 wadAmount, int256 balance);
1621 
1622     constructor(address _globalConfig, address _collateral, uint256 _collateralDecimals)
1623         public
1624         Collateral(_globalConfig, _collateral, _collateralDecimals)
1625     {}
1626 
1627     /**
1628       * @dev Calculate max amount can be liquidated to trader's acccount.
1629       *
1630       * @param trader           Address of account owner.
1631       * @param liquidationPrice Markprice used in calculation.
1632       * @return Max liquidatable amount, note this amount is not aligned to lotSize.
1633       */
1634     function calculateLiquidateAmount(address trader, uint256 liquidationPrice) public returns (uint256) {
1635         if (marginAccounts[trader].size == 0) {
1636             return 0;
1637         }
1638         LibTypes.MarginAccount memory account = marginAccounts[trader];
1639         int256 liquidationAmount = account.cashBalance.add(account.entrySocialLoss);
1640         liquidationAmount = liquidationAmount
1641             .sub(marginWithPrice(trader, liquidationPrice).toInt256())
1642             .sub(socialLossPerContract(account.side).wmul(account.size.toInt256()));
1643         int256 tmp = account.entryValue.toInt256()
1644             .sub(account.entryFundingLoss)
1645             .add(amm.currentAccumulatedFundingPerContract().wmul(account.size.toInt256()))
1646             .sub(account.size.wmul(liquidationPrice).toInt256());
1647         if (account.side == LibTypes.Side.LONG) {
1648             liquidationAmount = liquidationAmount.sub(tmp);
1649         } else if (account.side == LibTypes.Side.SHORT) {
1650             liquidationAmount = liquidationAmount.add(tmp);
1651         } else {
1652             return 0;
1653         }
1654         int256 denominator = governance.liquidationPenaltyRate
1655             .add(governance.penaltyFundRate).toInt256()
1656             .sub(governance.initialMarginRate.toInt256())
1657             .wmul(liquidationPrice.toInt256());
1658         liquidationAmount = liquidationAmount.wdiv(denominator);
1659         liquidationAmount = liquidationAmount.max(0);
1660         liquidationAmount = liquidationAmount.min(account.size.toInt256());
1661         return liquidationAmount.toUint256();
1662     }
1663 
1664     /**
1665       * @dev Calculate pnl of an margin account at trade price for given amount.
1666       *
1667       * @param account    Account of account owner.
1668       * @param tradePrice Price used in calculation.
1669       * @param amount     Amount used in calculation.
1670       * @return PNL of given account.
1671       */
1672     function calculatePnl(LibTypes.MarginAccount memory account, uint256 tradePrice, uint256 amount)
1673         internal
1674         returns (int256)
1675     {
1676         if (account.size == 0) {
1677             return 0;
1678         }
1679         int256 p1 = tradePrice.wmul(amount).toInt256();
1680         int256 p2;
1681         if (amount == account.size) {
1682             p2 = account.entryValue.toInt256();
1683         } else {
1684             // p2 = account.entryValue.wmul(amount).wdiv(account.size).toInt256();
1685             p2 = account.entryValue.wfrac(amount, account.size).toInt256();
1686         }
1687         int256 profit = account.side == LibTypes.Side.LONG ? p1.sub(p2) : p2.sub(p1);
1688         // prec error
1689         if (profit != 0) {
1690             profit = profit.sub(1);
1691         }
1692         int256 loss1 = socialLossWithAmount(account, amount);
1693         int256 loss2 = fundingLossWithAmount(account, amount);
1694         return profit.sub(loss1).sub(loss2);
1695     }
1696 
1697     /**
1698       * @dev Calculate margin balance at given mark price:
1699       *         margin balance = cash balance + pnl
1700       *
1701       * @param trader    Address of account owner.
1702       * @param markPrice Price used in calculation.
1703       * @return Value of margin balance.
1704       */
1705     function marginBalanceWithPrice(address trader, uint256 markPrice) internal returns (int256) {
1706         return marginAccounts[trader].cashBalance.add(pnlWithPrice(trader, markPrice));
1707     }
1708 
1709     /**
1710       * @dev Calculate (initial) margin value with initial margin rate at given mark price:
1711       *         margin taken by positon = value of positon * initial margin rate.
1712       *
1713       * @param trader    Address of account owner.
1714       * @param markPrice Price used in calculation.
1715       * @return Value of margin.
1716       */
1717     function marginWithPrice(address trader, uint256 markPrice) internal view returns (uint256) {
1718         return marginAccounts[trader].size.wmul(markPrice).wmul(governance.initialMarginRate);
1719     }
1720 
1721     /**
1722       * @dev Calculate maintenance margin value with maintenance margin rate at given mark price:
1723       *         maintenance margin taken by positon = value of positon * maintenance margin rate.
1724       *         maintenance margin must be lower than (initial) margin (see above)
1725       *
1726       * @param trader    Address of account owner.
1727       * @param markPrice Price used in calculation.
1728       * @return Value of margin.
1729       */
1730     function maintenanceMarginWithPrice(address trader, uint256 markPrice) internal view returns (uint256) {
1731         return marginAccounts[trader].size.wmul(markPrice).wmul(governance.maintenanceMarginRate);
1732     }
1733 
1734     /**
1735       * @dev Calculate available margin balance, which can be used to open new positions, at given mark price:
1736       *      An available margin could be negative:
1737       *         avaiable margin balance = margin balance - margin taken by position
1738       *
1739       * @param trader    Address of account owner.
1740       * @param markPrice Price used in calculation.
1741       * @return Value of available margin balance.
1742       */
1743     function availableMarginWithPrice(address trader, uint256 markPrice) internal returns (int256) {
1744         int256 marginBalance = marginBalanceWithPrice(trader, markPrice);
1745         int256 margin = marginWithPrice(trader, markPrice).toInt256();
1746         return marginBalance.sub(margin);
1747     }
1748 
1749 
1750     /**
1751       * @dev Calculate pnl (profit and loss) of a margin account at given mark price.
1752       *
1753       * @param trader    Address of account owner.
1754       * @param markPrice Price used in calculation.
1755       * @return Value of available margin balance.
1756       */
1757     function pnlWithPrice(address trader, uint256 markPrice) internal returns (int256) {
1758         LibTypes.MarginAccount memory account = marginAccounts[trader];
1759         return calculatePnl(account, markPrice, account.size);
1760     }
1761 
1762     // Internal functions
1763     function increaseTotalSize(LibTypes.Side side, uint256 amount) internal {
1764         totalSizes[uint256(side)] = totalSizes[uint256(side)].add(amount);
1765     }
1766 
1767     function decreaseTotalSize(LibTypes.Side side, uint256 amount) internal {
1768         totalSizes[uint256(side)] = totalSizes[uint256(side)].sub(amount);
1769     }
1770 
1771     function socialLoss(LibTypes.MarginAccount memory account) internal view returns (int256) {
1772         return socialLossWithAmount(account, account.size);
1773     }
1774 
1775     function socialLossWithAmount(LibTypes.MarginAccount memory account, uint256 amount)
1776         internal
1777         view
1778         returns (int256)
1779     {
1780         if (amount == 0) {
1781             return 0;
1782         }
1783         int256 loss = socialLossPerContract(account.side).wmul(amount.toInt256());
1784         if (amount == account.size) {
1785             loss = loss.sub(account.entrySocialLoss);
1786         } else {
1787             // loss = loss.sub(account.entrySocialLoss.wmul(amount).wdiv(account.size));
1788             loss = loss.sub(account.entrySocialLoss.wfrac(amount.toInt256(), account.size.toInt256()));
1789             // prec error
1790             if (loss != 0) {
1791                 loss = loss.add(1);
1792             }
1793         }
1794         return loss;
1795     }
1796 
1797     function fundingLoss(LibTypes.MarginAccount memory account) internal returns (int256) {
1798         return fundingLossWithAmount(account, account.size);
1799     }
1800 
1801     function fundingLossWithAmount(LibTypes.MarginAccount memory account, uint256 amount) internal returns (int256) {
1802         if (amount == 0) {
1803             return 0;
1804         }
1805         int256 loss = amm.currentAccumulatedFundingPerContract().wmul(amount.toInt256());
1806         if (amount == account.size) {
1807             loss = loss.sub(account.entryFundingLoss);
1808         } else {
1809             // loss = loss.sub(account.entryFundingLoss.wmul(amount.toInt256()).wdiv(account.size.toInt256()));
1810             loss = loss.sub(account.entryFundingLoss.wfrac(amount.toInt256(), account.size.toInt256()));
1811         }
1812         if (account.side == LibTypes.Side.SHORT) {
1813             loss = loss.neg();
1814         }
1815         if (loss != 0 && amount != account.size) {
1816             loss = loss.add(1);
1817         }
1818         return loss;
1819     }
1820 
1821     /**
1822       * @dev Recalculate cash balance of a margin account and update the storage.
1823       *
1824       * @param trader    Address of account owner.
1825       * @param markPrice Price used in calculation.
1826       */
1827     function remargin(address trader, uint256 markPrice) internal {
1828         LibTypes.MarginAccount storage account = marginAccounts[trader];
1829         if (account.size == 0) {
1830             return;
1831         }
1832         int256 rpnl = calculatePnl(account, markPrice, account.size);
1833         account.cashBalance = account.cashBalance.add(rpnl);
1834         account.entryValue = markPrice.wmul(account.size);
1835         account.entrySocialLoss = socialLossPerContract(account.side).wmul(account.size.toInt256());
1836         account.entryFundingLoss = amm.currentAccumulatedFundingPerContract().wmul(account.size.toInt256());
1837         emit UpdatePositionAccount(trader, account, totalSize(account.side), markPrice);
1838     }
1839 
1840     /**
1841       * @dev Open new position for a margin account.
1842       *
1843       * @param account Account of account owner.
1844       * @param side    Side of position to open.
1845       * @param price   Price of position to open.
1846       * @param amount  Amount of position to open.
1847       */
1848     function open(LibTypes.MarginAccount memory account, LibTypes.Side side, uint256 price, uint256 amount) internal {
1849         require(amount > 0, "open: invald amount");
1850         if (account.size == 0) {
1851             account.side = side;
1852         }
1853         account.size = account.size.add(amount);
1854         account.entryValue = account.entryValue.add(price.wmul(amount));
1855         account.entrySocialLoss = account.entrySocialLoss.add(socialLossPerContract(side).wmul(amount.toInt256()));
1856         account.entryFundingLoss = account.entryFundingLoss.add(
1857             amm.currentAccumulatedFundingPerContract().wmul(amount.toInt256())
1858         );
1859         increaseTotalSize(side, amount);
1860     }
1861 
1862     /**
1863       * @dev CLose position for a margin account, get collateral back.
1864       *
1865       * @param account Account of account owner.
1866       * @param price   Price of position to close.
1867       * @param amount  Amount of position to close.
1868       */
1869     function close(LibTypes.MarginAccount memory account, uint256 price, uint256 amount) internal returns (int256) {
1870         int256 rpnl = calculatePnl(account, price, amount);
1871         account.cashBalance = account.cashBalance.add(rpnl);
1872         account.entrySocialLoss = account.entrySocialLoss.wmul(account.size.sub(amount).toInt256()).wdiv(
1873             account.size.toInt256()
1874         );
1875         account.entryFundingLoss = account.entryFundingLoss.wmul(account.size.sub(amount).toInt256()).wdiv(
1876             account.size.toInt256()
1877         );
1878         account.entryValue = account.entryValue.wmul(account.size.sub(amount)).wdiv(account.size);
1879         account.size = account.size.sub(amount);
1880         decreaseTotalSize(account.side, amount);
1881         if (account.size == 0) {
1882             account.side = LibTypes.Side.FLAT;
1883         }
1884         return rpnl;
1885     }
1886 
1887     function trade(address trader, LibTypes.Side side, uint256 price, uint256 amount) internal returns (uint256) {
1888         // int256 rpnl;
1889         uint256 opened = amount;
1890         uint256 closed;
1891         LibTypes.MarginAccount memory account = marginAccounts[trader];
1892         LibTypes.Side originalSide = account.side;
1893         if (account.size > 0 && account.side != side) {
1894             closed = account.size.min(amount);
1895             close(account, price, closed);
1896             opened = opened.sub(closed);
1897         }
1898         if (opened > 0) {
1899             open(account, side, price, opened);
1900         }
1901         marginAccounts[trader] = account;
1902         emit UpdatePositionAccount(trader, account, totalSize(originalSide), price);
1903         return opened;
1904     }
1905 
1906     /**
1907      * @dev Liqudate a bankrupt margin account (cash balance cannot cover negative pnl), force to sell its postion
1908      *      at mark price to the liquidator. The liquidated margin account will suffer a penalty.
1909      *      The liquidating process must be initiated from a margin account with enough margin balance.
1910      *      Any loss caused by liquidated account is firstly be recovered by insurance fund, then uncovered part
1911      *      will become socialloss and applied to the side of its couterparty.
1912      *
1913      * @param liquidator        Address who initiate the liquidating process.
1914      * @param trader            Address who is liquidated.
1915      * @param liquidationPrice  Price to liquidate.
1916      * @param liquidationAmount Max amount to liquidate.
1917      * @return Opened position amount for liquidate.
1918      */
1919     function liquidate(address liquidator, address trader, uint256 liquidationPrice, uint256 liquidationAmount)
1920         internal
1921         returns (uint256)
1922     {
1923         // liquidiated trader
1924         LibTypes.MarginAccount memory account = marginAccounts[trader];
1925         require(liquidationAmount <= account.size, "exceeded liquidation amount");
1926 
1927         LibTypes.Side liquidationSide = account.side;
1928         uint256 liquidationValue = liquidationPrice.wmul(liquidationAmount);
1929         int256 penaltyToLiquidator = governance.liquidationPenaltyRate.wmul(liquidationValue).toInt256();
1930         int256 penaltyToFund = governance.penaltyFundRate.wmul(liquidationValue).toInt256();
1931 
1932         // position: trader => liquidator
1933         trade(trader, liquidationSide.counterSide(), liquidationPrice, liquidationAmount);
1934         uint256 opened = trade(liquidator, liquidationSide, liquidationPrice, liquidationAmount);
1935 
1936         // penalty: trader => liquidator, trader => insuranceFundBalance
1937         updateCashBalance(trader, penaltyToLiquidator.add(penaltyToFund).neg());
1938         updateCashBalance(liquidator, penaltyToLiquidator);
1939         insuranceFundBalance = insuranceFundBalance.add(penaltyToFund);
1940 
1941         // loss
1942         int256 liquidationLoss = ensurePositiveBalance(trader).toInt256();
1943         // fund, fund penalty - possible social loss
1944         if (insuranceFundBalance >= liquidationLoss) {
1945             // insurance covers the loss
1946             insuranceFundBalance = insuranceFundBalance.sub(liquidationLoss);
1947         } else {
1948             // insurance cannot covers the loss, overflow part become socialloss of counter side.
1949             int256 newSocialLoss = liquidationLoss.sub(insuranceFundBalance);
1950             insuranceFundBalance = 0;
1951             handleSocialLoss(liquidationSide.counterSide(), newSocialLoss);
1952         }
1953         require(insuranceFundBalance >= 0, "negtive insurance fund");
1954 
1955         emit UpdateInsuranceFund(insuranceFundBalance);
1956         return opened;
1957     }
1958 
1959     /**
1960      * @dev Increase social loss per contract on given side.
1961      *
1962      * @param side Side of position.
1963      * @param loss Amount of loss to handle.
1964      */
1965     function handleSocialLoss(LibTypes.Side side, int256 loss) internal {
1966         require(side != LibTypes.Side.FLAT, "side can't be flat");
1967         require(totalSize(side) > 0, "size cannot be 0");
1968         require(loss >= 0, "loss must be positive");
1969 
1970         int256 newSocialLoss = loss.wdiv(totalSize(side).toInt256());
1971         int256 newLossPerContract = socialLossPerContracts[uint256(side)].add(newSocialLoss);
1972         socialLossPerContracts[uint256(side)] = newLossPerContract;
1973 
1974         emit SocialLoss(side, newLossPerContract);
1975     }
1976 
1977      /**
1978      * @dev Update the cash balance of a collateral account. Depends on the signed of given amount,
1979      *      it could be increasing (for positive amount) or decreasing (for negative amount).
1980      *
1981      * @param trader    Address of account owner.
1982      * @param wadAmount Amount of balance to be update. Both positive and negative are avaiable.
1983      * @return Internal representation of the raw amount.
1984      */
1985     function updateCashBalance(address trader, int256 wadAmount) internal {
1986         if (wadAmount == 0) {
1987             return;
1988         }
1989         marginAccounts[trader].cashBalance = marginAccounts[trader].cashBalance.add(wadAmount);
1990         emit InternalUpdateBalance(trader, wadAmount, marginAccounts[trader].cashBalance);
1991     }
1992 
1993     /**
1994      * @dev Check a trader's cash balance, return the negative part and set the cash balance to 0
1995      *      if possible.
1996      *
1997      * @param trader    Address of account owner.
1998      * @return A loss equals to the negative part of trader's cash balance before operating.
1999      */
2000     function ensurePositiveBalance(address trader) internal returns (uint256 loss) {
2001         if (marginAccounts[trader].cashBalance < 0) {
2002             loss = marginAccounts[trader].cashBalance.neg().toUint256();
2003             marginAccounts[trader].cashBalance = 0;
2004         }
2005     }
2006 
2007     /**
2008      * @dev Like erc20's 'transferFrom', transfer internal balance from one account to another.
2009      *
2010      * @param from      Address of the cash balance transferred from.
2011      * @param to        Address of the cash balance transferred to.
2012      * @param wadAmount Amount of the balance to be transferred.
2013      */
2014     function transferBalance(address from, address to, int256 wadAmount) internal {
2015         if (wadAmount == 0) {
2016             return;
2017         }
2018         require(wadAmount > 0, "amount must be greater than 0");
2019         marginAccounts[from].cashBalance = marginAccounts[from].cashBalance.sub(wadAmount); // may be negative balance
2020         marginAccounts[to].cashBalance = marginAccounts[to].cashBalance.add(wadAmount);
2021         emit Transfer(from, to, wadAmount, marginAccounts[from].cashBalance, marginAccounts[to].cashBalance);
2022     }
2023 }
2024 
2025 contract Perpetual is MarginAccount, ReentrancyGuard {
2026     using LibMathSigned for int256;
2027     using LibMathUnsigned for uint256;
2028     using LibOrder for LibTypes.Side;
2029 
2030     uint256 public totalAccounts;
2031     address[] public accountList;
2032     mapping(address => bool) private accountCreated;
2033 
2034     event CreatePerpetual();
2035     event Paused(address indexed caller);
2036     event Unpaused(address indexed caller);
2037     event DisableWithdraw(address indexed caller);
2038     event EnableWithdraw(address indexed caller);
2039     event CreateAccount(uint256 indexed id, address indexed trader);
2040     event Trade(address indexed trader, LibTypes.Side side, uint256 price, uint256 amount);
2041     event Liquidate(address indexed keeper, address indexed trader, uint256 price, uint256 amount);
2042     event EnterEmergencyStatus(uint256 price);
2043     event EnterSettledStatus(uint256 price);
2044 
2045     constructor(
2046         address _globalConfig,
2047         address _devAddress,
2048         address _collateral,
2049         uint256 _collateralDecimals
2050     )
2051         public
2052         MarginAccount(_globalConfig, _collateral, _collateralDecimals)
2053     {
2054         devAddress = _devAddress;
2055         emit CreatePerpetual();
2056     }
2057 
2058     // disable fallback
2059     function() external payable {
2060         revert("fallback function disabled");
2061     }
2062 
2063     /**
2064      * @dev Called by a pauseControllers, put whole system into paused state.
2065      */
2066     function pause() external {
2067         require(
2068             globalConfig.pauseControllers(msg.sender) || globalConfig.owner() == msg.sender,
2069             "unauthorized caller"
2070         );
2071         require(!paused, "already paused");
2072         paused = true;
2073         emit Paused(msg.sender);
2074     }
2075 
2076     /**
2077      * @dev Called by a pauseControllers, put whole system back to normal.
2078      */
2079     function unpause() external {
2080         require(
2081             globalConfig.pauseControllers(msg.sender) || globalConfig.owner() == msg.sender,
2082             "unauthorized caller"
2083         );
2084         require(paused, "not paused");
2085         paused = false;
2086         emit Unpaused(msg.sender);
2087     }
2088 
2089     /**
2090      * @dev Called by a withdrawControllers disable withdraw function.
2091      */
2092     function disableWithdraw() external {
2093         require(
2094             globalConfig.withdrawControllers(msg.sender) || globalConfig.owner() == msg.sender,
2095             "unauthorized caller"
2096         );
2097         require(!withdrawDisabled, "already disabled");
2098         withdrawDisabled = true;
2099         emit DisableWithdraw(msg.sender);
2100     }
2101 
2102     /**
2103      * @dev Called by a withdrawControllers, enable withdraw function again.
2104      */
2105     function enableWithdraw() external {
2106         require(
2107             globalConfig.withdrawControllers(msg.sender) || globalConfig.owner() == msg.sender,
2108             "unauthorized caller"
2109         );
2110         require(withdrawDisabled, "not disabled");
2111         withdrawDisabled = false;
2112         emit EnableWithdraw(msg.sender);
2113     }
2114 
2115     /**
2116      * @notice Force to set cash balance of margin account. Called by administrator to
2117      *      fix unexpected cash balance.
2118      *
2119      * @param trader Address of account owner.
2120      * @param amount Absolute cash balance value to be set.
2121      */
2122     function increaseCashBalance(address trader, uint256 amount) external onlyOwner {
2123         require(status == LibTypes.Status.EMERGENCY, "wrong perpetual status");
2124         updateCashBalance(trader, amount.toInt256());
2125     }
2126 
2127     /**
2128      * @notice Force to set cash balance of margin account. Called by administrator to
2129      *      fix unexpected cash balance.
2130      *
2131      * @param trader Address of account owner.
2132      * @param amount Absolute cash balance value to be set.
2133      */
2134     function decreaseCashBalance(address trader, uint256 amount) external onlyOwner {
2135         require(status == LibTypes.Status.EMERGENCY, "wrong perpetual status");
2136         updateCashBalance(trader, amount.toInt256().neg());
2137     }
2138 
2139     /**
2140      * @notice Set perpetual status to 'emergency'. It can be called multiple times to set price.
2141      *      In emergency mode, main function like trading / withdrawing is disabled to prevent unexpected loss.
2142      *
2143      * @param price Price used as mark price in emergency mode.
2144      */
2145     function beginGlobalSettlement(uint256 price) external onlyOwner {
2146         require(status != LibTypes.Status.SETTLED, "wrong perpetual status");
2147         status = LibTypes.Status.EMERGENCY;
2148 
2149         settlementPrice = price;
2150         emit EnterEmergencyStatus(price);
2151     }
2152 
2153     /**
2154      * @notice Set perpetual status to 'settled'. It can be call only once in 'emergency' mode.
2155      *         In settled mode, user is expected to closed positions and withdraw all the collateral.
2156      * @notice endGlobalSettlement will also settle all postition belongs to amm.
2157      */
2158     function endGlobalSettlement() external onlyOwner {
2159         require(status == LibTypes.Status.EMERGENCY, "wrong perpetual status");
2160         status = LibTypes.Status.SETTLED;
2161 
2162         address ammTrader = address(amm.perpetualProxy());
2163         settleImplementation(ammTrader);
2164         emit EnterSettledStatus(settlementPrice);
2165     }
2166 
2167     /**
2168      * @notice Deposit collateral to insurance fund to recover social loss. Note that depositing to
2169      *         insurance fund *DOES NOT* profit to depositor and only administrator can withdraw from the fund.
2170      *
2171      * @param rawAmount Amount to deposit.
2172      */
2173     function depositToInsuranceFund(uint256 rawAmount) external payable nonReentrant {
2174         checkDepositingParameter(rawAmount);
2175 
2176         require(rawAmount > 0, "amount must be greater than 0");
2177         int256 wadAmount = pullCollateral(msg.sender, rawAmount);
2178         insuranceFundBalance = insuranceFundBalance.add(wadAmount);
2179         require(insuranceFundBalance >= 0, "negtive insurance fund");
2180 
2181         emit UpdateInsuranceFund(insuranceFundBalance);
2182     }
2183 
2184     /**
2185      * @notice Withdraw collateral from insurance fund. Only administrator can withdraw from it.
2186      *
2187      * @param rawAmount Amount to withdraw.
2188      */
2189     function withdrawFromInsuranceFund(uint256 rawAmount) external onlyOwner nonReentrant {
2190         require(rawAmount > 0, "amount must be greater than 0");
2191         require(insuranceFundBalance > 0, "insufficient funds");
2192 
2193         int256 wadAmount = toWad(rawAmount);
2194         require(wadAmount <= insuranceFundBalance, "insufficient funds");
2195         insuranceFundBalance = insuranceFundBalance.sub(wadAmount);
2196         pushCollateral(msg.sender, rawAmount);
2197         require(insuranceFundBalance >= 0, "negtive insurance fund");
2198 
2199         emit UpdateInsuranceFund(insuranceFundBalance);
2200     }
2201 
2202     // End Admin functions
2203 
2204     // Deposit && Withdraw
2205     /**
2206      * @notice Deposit collateral to sender's margin account.
2207      *         When depositing ether rawAmount must strictly equal to
2208      *
2209      * @dev    Need approval
2210      *
2211      * @param rawAmount Amount to deposit.
2212      */
2213     function deposit(uint256 rawAmount) external payable {
2214         depositImplementation(msg.sender, rawAmount);
2215     }
2216 
2217     /**
2218      * @notice Withdraw collateral from sender's margin account. only available in normal state.
2219      *
2220      * @param rawAmount Amount to withdraw.
2221      */
2222     function withdraw(uint256 rawAmount) external {
2223         withdrawImplementation(msg.sender, rawAmount);
2224     }
2225 
2226     /**
2227      * @notice Close all position and withdraw all collateral remaining in sender's margin account.
2228      *         Settle is only available in settled state and can be called multiple times.
2229      */
2230     function settle() external nonReentrant
2231     {
2232         address payable trader = msg.sender;
2233         settleImplementation(trader);
2234         int256 wadAmount = marginAccounts[trader].cashBalance;
2235         if (wadAmount <= 0) {
2236             return;
2237         }
2238         uint256 rawAmount = toCollateral(wadAmount);
2239         Collateral.withdraw(trader, rawAmount);
2240     }
2241 
2242     // Deposit && Withdraw - Whitelisted Only
2243     /**
2244      * @notice Deposit collateral for trader into the trader's margin account. The collateral will be transfer
2245      *         from the trader's ethereum address.
2246      *         depositFor is only available to administrator.
2247      *
2248      * @dev    Need approval
2249      *
2250      * @param trader    Address of margin account to deposit into.
2251      * @param rawAmount Amount of collateral to deposit.
2252      */
2253     function depositFor(address trader, uint256 rawAmount)
2254         external
2255         payable
2256         onlyAuthorized
2257     {
2258         depositImplementation(trader, rawAmount);
2259     }
2260 
2261     /**
2262      * @notice Withdraw collateral for trader from the trader's margin account. The collateral will be transfer
2263      *         to the trader's ethereum address.
2264      *         withdrawFor is only available to administrator.
2265      *
2266      * @param trader    Address of margin account to deposit into.
2267      * @param rawAmount Amount of collateral to deposit.
2268      */
2269     function withdrawFor(address payable trader, uint256 rawAmount)
2270         external
2271         onlyAuthorized
2272     {
2273         withdrawImplementation(trader, rawAmount);
2274     }
2275 
2276     // Method for public properties
2277     /**
2278      * @notice Price to calculate all price-depended properties of margin account.
2279      *         The price is read from amm in normal status, and will replaced by settlement price
2280      *         in emergency and settled status.
2281      *
2282      * @dev decimals == 18
2283      *
2284      * @return Mark price.
2285      */
2286     function markPrice() public ammRequired returns (uint256) {
2287         return status == LibTypes.Status.NORMAL ? amm.currentMarkPrice() : settlementPrice;
2288     }
2289 
2290     /**
2291      * @notice (initial) Margin value of margin account according to mark price.
2292      *                   See marginWithPrice in MarginAccount.sol.
2293      *
2294      * @param trader Address of account owner.
2295      * @return Initial margin of margin account.
2296      */
2297     function positionMargin(address trader) public returns (uint256) {
2298         return MarginAccount.marginWithPrice(trader, markPrice());
2299     }
2300 
2301     /**
2302      * @notice (maintenance) Margin value of margin account according to mark price.
2303      *         See maintenanceMarginWithPrice in MarginAccount.sol.
2304      *
2305      * @param trader Address of account owner.
2306      * @return Maintanence margin of margin account.
2307      */
2308     function maintenanceMargin(address trader) public returns (uint256) {
2309         return MarginAccount.maintenanceMarginWithPrice(trader, markPrice());
2310     }
2311 
2312     /**
2313      * @notice Margin balance of margin account according to mark price.
2314      *         See marginBalanceWithPrice in MarginAccount.sol.
2315      *
2316      * @param trader Address of account owner.
2317      * @return Margin balance of margin account.
2318      */
2319     function marginBalance(address trader) public returns (int256) {
2320         return MarginAccount.marginBalanceWithPrice(trader, markPrice());
2321     }
2322 
2323     /**
2324      * @notice Profit and loss of margin account according to mark price.
2325      *         See pnlWithPrice in MarginAccount.sol.
2326      *
2327      * @param trader Address of account owner.
2328      * @return Margin balance of margin account.
2329      */
2330     function pnl(address trader) public returns (int256) {
2331         return MarginAccount.pnlWithPrice(trader, markPrice());
2332     }
2333 
2334     /**
2335      * @notice Available margin of margin account according to mark price.
2336      *         See marginBalanceWithPrice in MarginAccount.sol.
2337      *
2338      * @param trader Address of account owner.
2339      * @return Margin balance of margin account.
2340      */
2341     function availableMargin(address trader) public returns (int256) {
2342         return MarginAccount.availableMarginWithPrice(trader, markPrice());
2343     }
2344 
2345     /**
2346      * @notice Test if a margin account is safe, using maintenance margin rate.
2347      *         A unsafe margin account will loss position through liqudating initiated by any other trader,
2348                to make the whole system safe.
2349      *
2350      * @param trader Address of account owner.
2351      * @return True if give trader is safe.
2352      */
2353     function isSafe(address trader) public returns (bool) {
2354         uint256 currentMarkPrice = markPrice();
2355         return isSafeWithPrice(trader, currentMarkPrice);
2356     }
2357 
2358     /**
2359      * @notice Test if a margin account is safe, using maintenance margin rate according to given price.
2360      *
2361      * @param trader           Address of account owner.
2362      * @param currentMarkPrice Mark price.
2363      * @return True if give trader is safe.
2364      */
2365     function isSafeWithPrice(address trader, uint256 currentMarkPrice) public returns (bool) {
2366         return
2367             MarginAccount.marginBalanceWithPrice(trader, currentMarkPrice) >=
2368             MarginAccount.maintenanceMarginWithPrice(trader, currentMarkPrice).toInt256();
2369     }
2370 
2371     /**
2372      * @notice Test if a margin account is bankrupt. Bankrupt is a status indicates the margin account
2373      *         is completely out of collateral.
2374      *
2375      * @param trader           Address of account owner.
2376      * @return True if give trader is safe.
2377      */
2378     function isBankrupt(address trader) public returns (bool) {
2379         return marginBalanceWithPrice(trader, markPrice()) < 0;
2380     }
2381 
2382     /**
2383      * @notice Test if a margin account is safe, using initial margin rate instead of maintenance margin rate.
2384      *
2385      * @param trader Address of account owner.
2386      * @return True if give trader is safe with initial margin rate.
2387      */
2388     function isIMSafe(address trader) public returns (bool) {
2389         uint256 currentMarkPrice = markPrice();
2390         return isIMSafeWithPrice(trader, currentMarkPrice);
2391     }
2392 
2393     /**
2394      * @notice Test if a margin account is safe according to given mark price.
2395      *
2396      * @param trader Address of account owner.
2397      * @param currentMarkPrice Mark price.
2398      * @return True if give trader is safe with initial margin rate.
2399      */
2400     function isIMSafeWithPrice(address trader, uint256 currentMarkPrice) public returns (bool) {
2401         return availableMarginWithPrice(trader, currentMarkPrice) >= 0;
2402     }
2403 
2404     /**
2405      * @notice Test if a margin account is safe according to given mark price.
2406      *
2407      * @param trader    Address of account owner.
2408      * @param maxAmount Mark price.
2409      * @return True if give trader is safe with initial margin rate.
2410      */
2411     function liquidate(
2412         address trader,
2413         uint256 maxAmount
2414     )
2415         public
2416         onlyNotPaused
2417         returns (uint256, uint256)
2418     {
2419         require(msg.sender != trader, "self liquidate");
2420         require(isValidLotSize(maxAmount), "amount must be divisible by lotSize");
2421         require(status != LibTypes.Status.SETTLED, "wrong perpetual status");
2422         require(!isSafe(trader), "safe account");
2423 
2424         uint256 liquidationPrice = markPrice();
2425         require(liquidationPrice > 0, "price must be greater than 0");
2426 
2427         uint256 liquidationAmount = calculateLiquidateAmount(trader, liquidationPrice);
2428         uint256 totalPositionSize = marginAccounts[trader].size;
2429         uint256 liquidatableAmount = totalPositionSize.sub(totalPositionSize.mod(governance.lotSize));
2430         liquidationAmount = liquidationAmount.ceil(governance.lotSize).min(maxAmount).min(liquidatableAmount);
2431         require(liquidationAmount > 0, "nothing to liquidate");
2432 
2433         uint256 opened = MarginAccount.liquidate(msg.sender, trader, liquidationPrice, liquidationAmount);
2434         if (opened > 0) {
2435             require(availableMarginWithPrice(msg.sender, liquidationPrice) >= 0, "liquidator margin");
2436         } else {
2437             require(isSafe(msg.sender), "liquidator unsafe");
2438         }
2439         emit Liquidate(msg.sender, trader, liquidationPrice, liquidationAmount);
2440         return (liquidationPrice, liquidationAmount);
2441     }
2442 
2443     function tradePosition(
2444         address taker,
2445         address maker,
2446         LibTypes.Side side,
2447         uint256 price,
2448         uint256 amount
2449     )
2450         public
2451         onlyNotPaused
2452         onlyAuthorized
2453         returns (uint256 takerOpened, uint256 makerOpened)
2454     {
2455         require(status != LibTypes.Status.EMERGENCY, "wrong perpetual status");
2456         require(side == LibTypes.Side.LONG || side == LibTypes.Side.SHORT, "side must be long or short");
2457         require(isValidLotSize(amount), "amount must be divisible by lotSize");
2458 
2459         takerOpened = MarginAccount.trade(taker, side, price, amount);
2460         makerOpened = MarginAccount.trade(maker, side.counterSide(), price, amount);
2461         require(totalSize(LibTypes.Side.LONG) == totalSize(LibTypes.Side.SHORT), "imbalanced total size");
2462 
2463         emit Trade(taker, side, price, amount);
2464         emit Trade(maker, side.counterSide(), price, amount);
2465     }
2466 
2467     function transferCashBalance(
2468         address from,
2469         address to,
2470         uint256 amount
2471     )
2472         public
2473         onlyNotPaused
2474         onlyAuthorized
2475     {
2476         require(status != LibTypes.Status.EMERGENCY, "wrong perpetual status");
2477         MarginAccount.transferBalance(from, to, amount.toInt256());
2478     }
2479 
2480     function registerNewTrader(address trader) internal {
2481         emit CreateAccount(totalAccounts, trader);
2482         accountList.push(trader);
2483         totalAccounts++;
2484         accountCreated[trader] = true;
2485     }
2486 
2487     /**
2488      * @notice Check type of collateral. If ether, rawAmount must strictly match msg.value.
2489      *
2490      * @param rawAmount Amount to deposit
2491      */
2492     function checkDepositingParameter(uint256 rawAmount) internal view {
2493         bool isToken = isTokenizedCollateral();
2494         require((isToken && msg.value == 0) || (!isToken && msg.value == rawAmount), "incorrect sent value");
2495     }
2496 
2497     /**
2498      * @notice Implementation as underlaying of deposit and depositFor.
2499      *
2500      * @param trader    Address the collateral will be transferred from.
2501      * @param rawAmount Amount to deposit.
2502      */
2503     function depositImplementation(address trader, uint256 rawAmount) internal onlyNotPaused nonReentrant {
2504         checkDepositingParameter(rawAmount);
2505         require(rawAmount > 0, "amount must be greater than 0");
2506         require(trader != address(0), "cannot deposit to 0 address");
2507 
2508         Collateral.deposit(trader, rawAmount);
2509         // append to the account list. make the account trackable
2510         if (!accountCreated[trader]) {
2511             registerNewTrader(trader);
2512         }
2513     }
2514 
2515     /**
2516      * @notice Implementation as underlaying of withdraw and withdrawFor.
2517      *
2518      * @param trader    Address the collateral will be transferred to.
2519      * @param rawAmount Amount to withdraw.
2520      */
2521     function withdrawImplementation(address payable trader, uint256 rawAmount) internal onlyNotPaused nonReentrant {
2522         require(!withdrawDisabled, "withdraw disabled");
2523         require(status == LibTypes.Status.NORMAL, "wrong perpetual status");
2524         require(rawAmount > 0, "amount must be greater than 0");
2525         require(trader != address(0), "cannot withdraw to 0 address");
2526 
2527         uint256 currentMarkPrice = markPrice();
2528         require(isSafeWithPrice(trader, currentMarkPrice), "unsafe before withdraw");
2529 
2530         remargin(trader, currentMarkPrice);
2531         Collateral.withdraw(trader, rawAmount);
2532 
2533         require(isSafeWithPrice(trader, currentMarkPrice), "unsafe after withdraw");
2534         require(availableMarginWithPrice(trader, currentMarkPrice) >= 0, "withdraw margin");
2535     }
2536 
2537     /**
2538      * @notice Implementation as underlaying of settle.
2539      *
2540      * @param trader    Address the collateral will be transferred to.
2541      */
2542     function settleImplementation(address trader) internal onlyNotPaused {
2543         require(status == LibTypes.Status.SETTLED, "wrong perpetual status");
2544         uint256 currentMarkPrice = markPrice();
2545         LibTypes.MarginAccount memory account = marginAccounts[trader];
2546         if (account.size == 0) {
2547             return;
2548         }
2549         LibTypes.Side originalSide = account.side;
2550         close(account, currentMarkPrice, account.size);
2551         marginAccounts[trader] = account;
2552         emit UpdatePositionAccount(trader, account, totalSize(originalSide), currentMarkPrice);
2553     }
2554 }