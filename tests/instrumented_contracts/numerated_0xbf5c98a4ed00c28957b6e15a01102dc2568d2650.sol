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
11 library LibMathSigned {
12     int256 private constant _WAD = 10 ** 18;
13     int256 private constant _INT256_MIN = -2 ** 255;
14 
15     uint8 private constant FIXED_DIGITS = 18;
16     int256 private constant FIXED_1 = 10 ** 18;
17     int256 private constant FIXED_E = 2718281828459045235;
18     uint8 private constant LONGER_DIGITS = 36;
19     int256 private constant LONGER_FIXED_LOG_E_1_5 = 405465108108164381978013115464349137;
20     int256 private constant LONGER_FIXED_1 = 10 ** 36;
21     int256 private constant LONGER_FIXED_LOG_E_10 = 2302585092994045684017991454684364208;
22 
23 
24     function WAD() internal pure returns (int256) {
25         return _WAD;
26     }
27 
28     // additive inverse
29     function neg(int256 a) internal pure returns (int256) {
30         return sub(int256(0), a);
31     }
32 
33     /**
34      * @dev Multiplies two signed integers, reverts on overflow
35      * see https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.0.1/contracts/math/SignedSafeMath.sol#L13
36      */
37     function mul(int256 a, int256 b) internal pure returns (int256) {
38         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
39         // benefit is lost if 'b' is also tested.
40         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
41         if (a == 0) {
42             return 0;
43         }
44         require(!(a == -1 && b == _INT256_MIN), "wmultiplication overflow");
45 
46         int256 c = a * b;
47         require(c / a == b, "wmultiplication overflow");
48 
49         return c;
50     }
51 
52     /**
53      * @dev Integer division of two signed integers truncating the quotient, reverts on division by zero.
54      * see https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.0.1/contracts/math/SignedSafeMath.sol#L32
55      */
56     function div(int256 a, int256 b) internal pure returns (int256) {
57         require(b != 0, "wdivision by zero");
58         require(!(b == -1 && a == _INT256_MIN), "wdivision overflow");
59 
60         int256 c = a / b;
61 
62         return c;
63     }
64 
65     /**
66      * @dev Subtracts two signed integers, reverts on overflow.
67      * see https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.0.1/contracts/math/SignedSafeMath.sol#L44
68      */
69     function sub(int256 a, int256 b) internal pure returns (int256) {
70         int256 c = a - b;
71         require((b >= 0 && c <= a) || (b < 0 && c > a), "subtraction overflow");
72 
73         return c;
74     }
75 
76     /**
77      * @dev Adds two signed integers, reverts on overflow.
78      * see https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.0.1/contracts/math/SignedSafeMath.sol#L54
79      */
80     function add(int256 a, int256 b) internal pure returns (int256) {
81         int256 c = a + b;
82         require((b >= 0 && c >= a) || (b < 0 && c < a), "addition overflow");
83 
84         return c;
85     }
86 
87     function wmul(int256 x, int256 y) internal pure returns (int256 z) {
88         z = roundHalfUp(mul(x, y), _WAD) / _WAD;
89     }
90 
91     // solium-disable-next-line security/no-assign-params
92     function wdiv(int256 x, int256 y) internal pure returns (int256 z) {
93         if (y < 0) {
94             y = -y;
95             x = -x;
96         }
97         z = roundHalfUp(mul(x, _WAD), y) / y;
98     }
99 
100     // solium-disable-next-line security/no-assign-params
101     function wfrac(int256 x, int256 y, int256 z) internal pure returns (int256 r) {
102         int256 t = mul(x, y);
103         if (z < 0) {
104             z = neg(z);
105             t = neg(t);
106         }
107         r = roundHalfUp(t, z) / z;
108     }
109 
110     function min(int256 x, int256 y) internal pure returns (int256) {
111         return x <= y ? x : y;
112     }
113 
114     function max(int256 x, int256 y) internal pure returns (int256) {
115         return x >= y ? x : y;
116     }
117 
118     // see https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.0.1/contracts/utils/SafeCast.sol#L103
119     function toUint256(int256 x) internal pure returns (uint256) {
120         require(x >= 0, "int overflow");
121         return uint256(x);
122     }
123 
124     // x ^ n
125     // NOTE: n is a normal integer, do not shift 18 decimals
126     // solium-disable-next-line security/no-assign-params
127     function wpowi(int256 x, int256 n) internal pure returns (int256 z) {
128         require(n >= 0, "wpowi only supports n >= 0");
129         z = n % 2 != 0 ? x : _WAD;
130 
131         for (n /= 2; n != 0; n /= 2) {
132             x = wmul(x, x);
133 
134             if (n % 2 != 0) {
135                 z = wmul(z, x);
136             }
137         }
138     }
139 
140     // ROUND_HALF_UP rule helper. You have to call roundHalfUp(x, y) / y to finish the rounding operation
141     // 0.5 ≈ 1, 0.4 ≈ 0, -0.5 ≈ -1, -0.4 ≈ 0
142     function roundHalfUp(int256 x, int256 y) internal pure returns (int256) {
143         require(y > 0, "roundHalfUp only supports y > 0");
144         if (x >= 0) {
145             return add(x, y / 2);
146         }
147         return sub(x, y / 2);
148     }
149 
150     // solium-disable-next-line security/no-assign-params
151     function wln(int256 x) internal pure returns (int256) {
152         require(x > 0, "logE of negative number");
153         require(x <= 10000000000000000000000000000000000000000, "logE only accepts v <= 1e22 * 1e18"); // in order to prevent using safe-math
154         int256 r = 0;
155         uint8 extraDigits = LONGER_DIGITS - FIXED_DIGITS;
156         int256 t = int256(uint256(10)**uint256(extraDigits));
157 
158         while (x <= FIXED_1 / 10) {
159             x = x * 10;
160             r -= LONGER_FIXED_LOG_E_10;
161         }
162         while (x >= 10 * FIXED_1) {
163             x = x / 10;
164             r += LONGER_FIXED_LOG_E_10;
165         }
166         while (x < FIXED_1) {
167             x = wmul(x, FIXED_E);
168             r -= LONGER_FIXED_1;
169         }
170         while (x > FIXED_E) {
171             x = wdiv(x, FIXED_E);
172             r += LONGER_FIXED_1;
173         }
174         if (x == FIXED_1) {
175             return roundHalfUp(r, t) / t;
176         }
177         if (x == FIXED_E) {
178             return FIXED_1 + roundHalfUp(r, t) / t;
179         }
180         x *= t;
181 
182         //               x^2   x^3   x^4
183         // Ln(1+x) = x - --- + --- - --- + ...
184         //                2     3     4
185         // when -1 < x < 1, O(x^n) < ε => when n = 36, 0 < x < 0.316
186         //
187         //                    2    x           2    x          2    x
188         // Ln(a+x) = Ln(a) + ---(------)^1  + ---(------)^3 + ---(------)^5 + ...
189         //                    1   2a+x         3   2a+x        5   2a+x
190         //
191         // Let x = v - a
192         //                  2   v-a         2   v-a        2   v-a
193         // Ln(v) = Ln(a) + ---(-----)^1  + ---(-----)^3 + ---(-----)^5 + ...
194         //                  1   v+a         3   v+a        5   v+a
195         // when n = 36, 1 < v < 3.423
196         r = r + LONGER_FIXED_LOG_E_1_5;
197         int256 a1_5 = (3 * LONGER_FIXED_1) / 2;
198         int256 m = (LONGER_FIXED_1 * (x - a1_5)) / (x + a1_5);
199         r = r + 2 * m;
200         int256 m2 = (m * m) / LONGER_FIXED_1;
201         uint8 i = 3;
202         while (true) {
203             m = (m * m2) / LONGER_FIXED_1;
204             r = r + (2 * m) / int256(i);
205             i += 2;
206             if (i >= 3 + 2 * FIXED_DIGITS) {
207                 break;
208             }
209         }
210         return roundHalfUp(r, t) / t;
211     }
212 
213     // Log(b, x)
214     function logBase(int256 base, int256 x) internal pure returns (int256) {
215         return wdiv(wln(x), wln(base));
216     }
217 
218     function ceil(int256 x, int256 m) internal pure returns (int256) {
219         require(x >= 0, "ceil need x >= 0");
220         require(m > 0, "ceil need m > 0");
221         return (sub(add(x, m), 1) / m) * m;
222     }
223 }
224 
225 library LibMathUnsigned {
226     uint256 private constant _WAD = 10**18;
227     uint256 private constant _POSITIVE_INT256_MAX = 2**255 - 1;
228 
229     function WAD() internal pure returns (uint256) {
230         return _WAD;
231     }
232 
233     /**
234      * @dev Returns the addition of two unsigned integers, reverting on overflow.
235      * see https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.0.1/contracts/math/SafeMath.sol#L26
236      */
237     function add(uint256 a, uint256 b) internal pure returns (uint256) {
238         uint256 c = a + b;
239         require(c >= a, "Unaddition overflow");
240 
241         return c;
242     }
243 
244     /**
245      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
246      * overflow (when the result is negative).
247      * see https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.0.1/contracts/math/SafeMath.sol#L55
248      */
249     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
250         require(b <= a, "Unsubtraction overflow");
251         uint256 c = a - b;
252 
253         return c;
254     }
255 
256     /**
257      * @dev Returns the multiplication of two unsigned integers, reverting on
258      * overflow.
259      * see https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.0.1/contracts/math/SafeMath.sol#L71
260      */
261     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
262         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
263         // benefit is lost if 'b' is also tested.
264         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
265         if (a == 0) {
266             return 0;
267         }
268 
269         uint256 c = a * b;
270         require(c / a == b, "Unmultiplication overflow");
271 
272         return c;
273     }
274 
275     /**
276      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
277      * division by zero. The result is rounded towards zero.
278      * see https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.0.1/contracts/math/SafeMath.sol#L111
279      */
280     function div(uint256 a, uint256 b) internal pure returns (uint256) {
281         // Solidity only automatically asserts when dividing by 0
282         require(b > 0, "Undivision by zero");
283         uint256 c = a / b;
284         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
285 
286         return c;
287     }
288 
289     function wmul(uint256 x, uint256 y) internal pure returns (uint256 z) {
290         z = add(mul(x, y), _WAD / 2) / _WAD;
291     }
292 
293     function wdiv(uint256 x, uint256 y) internal pure returns (uint256 z) {
294         z = add(mul(x, _WAD), y / 2) / y;
295     }
296 
297     function wfrac(uint256 x, uint256 y, uint256 z) internal pure returns (uint256 r) {
298         r = mul(x, y) / z;
299     }
300 
301     function min(uint256 x, uint256 y) internal pure returns (uint256) {
302         return x <= y ? x : y;
303     }
304 
305     function max(uint256 x, uint256 y) internal pure returns (uint256) {
306         return x >= y ? x : y;
307     }
308 
309     function toInt256(uint256 x) internal pure returns (int256) {
310         require(x <= _POSITIVE_INT256_MAX, "uint256 overflow");
311         return int256(x);
312     }
313 
314     /**
315      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
316      * Reverts with custom message when dividing by zero.
317      * see https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.0.1/contracts/math/SafeMath.sol#L146
318      */
319     function mod(uint256 x, uint256 m) internal pure returns (uint256) {
320         require(m != 0, "mod by zero");
321         return x % m;
322     }
323 
324     function ceil(uint256 x, uint256 m) internal pure returns (uint256) {
325         require(m > 0, "ceil need m > 0");
326         return (sub(add(x, m), 1) / m) * m;
327     }
328 }
329 
330 library LibEIP712 {
331     string internal constant DOMAIN_NAME = "Mai Protocol";
332 
333     /**
334      * Hash of the EIP712 Domain Separator Schema
335      */
336     bytes32 private constant EIP712_DOMAIN_TYPEHASH = keccak256(abi.encodePacked("EIP712Domain(string name)"));
337 
338     bytes32 private constant DOMAIN_SEPARATOR = keccak256(
339         abi.encodePacked(EIP712_DOMAIN_TYPEHASH, keccak256(bytes(DOMAIN_NAME)))
340     );
341 
342     /**
343      * Calculates EIP712 encoding for a hash struct in this EIP712 Domain.
344      *
345      * @param eip712hash The EIP712 hash struct.
346      * @return EIP712 hash applied to this EIP712 Domain.
347      */
348     function hashEIP712Message(bytes32 eip712hash) internal pure returns (bytes32) {
349         return keccak256(abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR, eip712hash));
350     }
351 }
352 
353 library ECDSA {
354     /**
355      * @dev Returns the address that signed a hashed message (`hash`) with
356      * `signature`. This address can then be used for verification purposes.
357      *
358      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
359      * this function rejects them by requiring the `s` value to be in the lower
360      * half order, and the `v` value to be either 27 or 28.
361      *
362      * NOTE: This call _does not revert_ if the signature is invalid, or
363      * if the signer is otherwise unable to be retrieved. In those scenarios,
364      * the zero address is returned.
365      *
366      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
367      * verification to be secure: it is possible to craft signatures that
368      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
369      * this is by receiving a hash of the original message (which may otherwise
370      * be too long), and then calling {toEthSignedMessageHash} on it.
371      */
372     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
373         // Check the signature length
374         if (signature.length != 65) {
375             return (address(0));
376         }
377 
378         // Divide the signature in r, s and v variables
379         bytes32 r;
380         bytes32 s;
381         uint8 v;
382 
383         // ecrecover takes the signature parameters, and the only way to get them
384         // currently is to use assembly.
385         // solhint-disable-next-line no-inline-assembly
386         assembly {
387             r := mload(add(signature, 0x20))
388             s := mload(add(signature, 0x40))
389             v := byte(0, mload(add(signature, 0x60)))
390         }
391 
392         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
393         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
394         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
395         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
396         //
397         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
398         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
399         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
400         // these malleable signatures as well.
401         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
402             return address(0);
403         }
404 
405         if (v != 27 && v != 28) {
406             return address(0);
407         }
408 
409         // If the signature is valid (and not malleable), return the signer address
410         return ecrecover(hash, v, r, s);
411     }
412 
413     /**
414      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
415      * replicates the behavior of the
416      * https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_sign[`eth_sign`]
417      * JSON-RPC method.
418      *
419      * See {recover}.
420      */
421     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
422         // 32 is the length in bytes of hash,
423         // enforced by the type signature above
424         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
425     }
426 }
427 
428 library LibSignature {
429     enum SignatureMethod {ETH_SIGN, EIP712}
430 
431     struct OrderSignature {
432         bytes32 config;
433         bytes32 r;
434         bytes32 s;
435     }
436 
437     /**
438      * Validate a signature given a hash calculated from the order data, the signer, and the
439      * signature data passed in with the order.
440      *
441      * This function will revert the transaction if the signature method is invalid.
442      *
443      * @param signature The signature data passed along with the order to validate against
444      * @param hash Hash bytes calculated by taking the hash of the passed order data
445      * @param signerAddress The address of the signer
446      * @return True if the calculated signature matches the order signature data, false otherwise.
447      */
448     function isValidSignature(OrderSignature memory signature, bytes32 hash, address signerAddress)
449         internal
450         pure
451         returns (bool)
452     {
453         uint8 method = uint8(signature.config[1]);
454         address recovered;
455         uint8 v = uint8(signature.config[0]);
456 
457         if (method == uint8(SignatureMethod.ETH_SIGN)) {
458             recovered = recover(
459                 keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)),
460                 v,
461                 signature.r,
462                 signature.s
463             );
464         } else if (method == uint8(SignatureMethod.EIP712)) {
465             recovered = recover(hash, v, signature.r, signature.s);
466         } else {
467             revert("invalid sign method");
468         }
469 
470         return signerAddress == recovered;
471     }
472 
473     // see "@openzeppelin/contracts/cryptography/ECDSA.sol"
474     function recover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal pure returns (address) {
475         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
476             revert("ECDSA: invalid signature 's' value");
477         }
478 
479         if (v != 27 && v != 28) {
480             revert("ECDSA: invalid signature 'v' value");
481         }
482 
483         // If the signature is valid (and not malleable), return the signer address
484         address signer = ecrecover(hash, v, r, s);
485         require(signer != address(0), "ECDSA: invalid signature");
486 
487         return signer;
488     }
489 }
490 
491 library LibTypes {
492     enum Side {FLAT, SHORT, LONG}
493 
494     enum Status {NORMAL, EMERGENCY, SETTLED}
495 
496     function counterSide(Side side) internal pure returns (Side) {
497         if (side == Side.LONG) {
498             return Side.SHORT;
499         } else if (side == Side.SHORT) {
500             return Side.LONG;
501         }
502         return side;
503     }
504 
505     //////////////////////////////////////////////////////////////////////////
506     // Perpetual
507     //////////////////////////////////////////////////////////////////////////
508     struct PerpGovernanceConfig {
509         uint256 initialMarginRate;
510         uint256 maintenanceMarginRate;
511         uint256 liquidationPenaltyRate;
512         uint256 penaltyFundRate;
513         int256 takerDevFeeRate;
514         int256 makerDevFeeRate;
515         uint256 lotSize;
516         uint256 tradingLotSize;
517     }
518 
519     struct MarginAccount {
520         LibTypes.Side side;
521         uint256 size;
522         uint256 entryValue;
523         int256 entrySocialLoss;
524         int256 entryFundingLoss;
525         int256 cashBalance;
526     }
527 
528     //////////////////////////////////////////////////////////////////////////
529     // AMM
530     //////////////////////////////////////////////////////////////////////////
531     struct AMMGovernanceConfig {
532         uint256 poolFeeRate;
533         uint256 poolDevFeeRate;
534         int256 emaAlpha;
535         uint256 updatePremiumPrize;
536         int256 markPremiumLimit;
537         int256 fundingDampener;
538     }
539 
540     struct FundingState {
541         uint256 lastFundingTime;
542         int256 lastPremium;
543         int256 lastEMAPremium;
544         uint256 lastIndexPrice;
545         int256 accumulatedFundingPerContract;
546     }
547 }
548 
549 library LibOrder {
550     using LibMathSigned for int256;
551     using LibMathUnsigned for uint256;
552 
553     bytes32 public constant EIP712_ORDER_TYPE = keccak256(
554         abi.encodePacked(
555             "Order(address trader,address broker,address perpetual,uint256 amount,uint256 price,bytes32 data)"
556         )
557     );
558 
559     int256 public constant FEE_RATE_BASE = 10 ** 5;
560 
561     struct Order {
562         address trader;
563         address broker;
564         address perpetual;
565         uint256 amount;
566         uint256 price;
567         /**
568          * Data contains the following values packed into 32 bytes
569          * ╔════════════════════╤═══════════════════════════════════════════════════════════╗
570          * ║                    │ length(bytes)   desc                                      ║
571          * ╟────────────────────┼───────────────────────────────────────────────────────────╢
572          * ║ version            │ 1               order version                             ║
573          * ║ side               │ 1               0: buy (long), 1: sell (short)            ║
574          * ║ isMarketOrder      │ 1               0: limitOrder, 1: marketOrder             ║
575          * ║ expiredAt          │ 5               order expiration time in seconds          ║
576          * ║ asMakerFeeRate     │ 2               maker fee rate (base 100,000)             ║
577          * ║ asTakerFeeRate     │ 2               taker fee rate (base 100,000)             ║
578          * ║ (d) makerRebateRate│ 2               rebate rate for maker (base 100)          ║
579          * ║ salt               │ 8               salt                                      ║
580          * ║ isMakerOnly        │ 1               is maker only                             ║
581          * ║ isInversed         │ 1               is inversed contract                      ║
582          * ║ chainId            │ 8               chain id                                  ║
583          * ╚════════════════════╧═══════════════════════════════════════════════════════════╝
584          */
585         bytes32 data;
586     }
587 
588     struct OrderParam {
589         address trader;
590         uint256 amount;
591         uint256 price;
592         bytes32 data;
593         LibSignature.OrderSignature signature;
594     }
595 
596     /**
597      * @dev Get order hash from parameters of order. Rebuild order and hash it.
598      *
599      * @param orderParam Order parameters.
600      * @param perpetual  Address of perpetual contract.
601      * @param broker     Address of broker.
602      * @return Hash of the order.
603      */
604     function getOrderHash(
605         OrderParam memory orderParam,
606         address perpetual,
607         address broker
608     ) internal pure returns (bytes32 orderHash) {
609         Order memory order = getOrder(orderParam, perpetual, broker);
610         orderHash = LibEIP712.hashEIP712Message(hashOrder(order));
611     }
612 
613     /**
614      * @dev Get order hash from order.
615      *
616      * @param order Order to hash.
617      * @return Hash of the order.
618      */
619     function getOrderHash(Order memory order) internal pure returns (bytes32 orderHash) {
620         orderHash = LibEIP712.hashEIP712Message(hashOrder(order));
621     }
622 
623     /**
624      * @dev Get order from parameters.
625      *
626      * @param orderParam Order parameters.
627      * @param perpetual  Address of perpetual contract.
628      * @param broker     Address of broker.
629      * @return Order data structure.
630      */
631     function getOrder(
632         OrderParam memory orderParam,
633         address perpetual,
634         address broker
635     ) internal pure returns (LibOrder.Order memory order) {
636         order.trader = orderParam.trader;
637         order.broker = broker;
638         order.perpetual = perpetual;
639         order.amount = orderParam.amount;
640         order.price = orderParam.price;
641         order.data = orderParam.data;
642     }
643 
644     /**
645      * @dev Hash fields in order to generate a hash as identifier.
646      *
647      * @param order Order to hash.
648      * @return Hash of the order.
649      */
650     function hashOrder(Order memory order) internal pure returns (bytes32 result) {
651         bytes32 orderType = EIP712_ORDER_TYPE;
652         // solium-disable-next-line security/no-inline-assembly
653         assembly {
654             // "Order(address trader,address broker,address perpetual,uint256 amount,uint256 price,bytes32 data)"
655             // hash these 6 field to get a hash
656             // address will be extended to 32 bytes.
657             let start := sub(order, 32)
658             let tmp := mload(start)
659             mstore(start, orderType)
660             // [0...32)   bytes: EIP712_ORDER_TYPE, len 32
661             // [32...224) bytes: order, len 6 * 32
662             // 224 = 32 + 192
663             result := keccak256(start, 224)
664             mstore(start, tmp)
665         }
666     }
667 
668     // extract order parameters.
669 
670     function orderVersion(OrderParam memory orderParam) internal pure returns (uint256) {
671         return uint256(uint8(bytes1(orderParam.data)));
672     }
673 
674     function expiredAt(OrderParam memory orderParam) internal pure returns (uint256) {
675         return uint256(uint40(bytes5(orderParam.data << (8 * 3))));
676     }
677 
678     function isSell(OrderParam memory orderParam) internal pure returns (bool) {
679         bool sell = uint8(orderParam.data[1]) == 1;
680         return isInversed(orderParam) ? !sell : sell;
681     }
682 
683     function getPrice(OrderParam memory orderParam) internal pure returns (uint256) {
684         return isInversed(orderParam) ? LibMathUnsigned.WAD().wdiv(orderParam.price) : orderParam.price;
685     }
686 
687     function isMarketOrder(OrderParam memory orderParam) internal pure returns (bool) {
688         return uint8(orderParam.data[2]) > 0;
689     }
690 
691     function isMarketBuy(OrderParam memory orderParam) internal pure returns (bool) {
692         return !isSell(orderParam) && isMarketOrder(orderParam);
693     }
694 
695     function isMakerOnly(OrderParam memory orderParam) internal pure returns (bool) {
696         return uint8(orderParam.data[22]) > 0;
697     }
698 
699     function isInversed(OrderParam memory orderParam) internal pure returns (bool) {
700         return uint8(orderParam.data[23]) > 0;
701     }
702 
703     function side(OrderParam memory orderParam) internal pure returns (LibTypes.Side) {
704         return isSell(orderParam) ? LibTypes.Side.SHORT : LibTypes.Side.LONG;
705     }
706 
707     function makerFeeRate(OrderParam memory orderParam) internal pure returns (int256) {
708         return int256(int16(bytes2(orderParam.data << (8 * 8)))).mul(LibMathSigned.WAD()).div(FEE_RATE_BASE);
709     }
710 
711     function takerFeeRate(OrderParam memory orderParam) internal pure returns (int256) {
712         return int256(int16(bytes2(orderParam.data << (8 * 10)))).mul(LibMathSigned.WAD()).div(FEE_RATE_BASE);
713     }
714 
715     function chainId(OrderParam memory orderParam) internal pure returns (uint256) {
716         return uint256(uint64(bytes8(orderParam.data << (8 * 24))));
717     }
718 }
719 
720 interface IGlobalConfig {
721 
722     function owner() external view returns (address);
723 
724     function isOwner() external view returns (bool);
725 
726     function renounceOwnership() external;
727 
728     function transferOwnership(address newOwner) external;
729 
730     function brokers(address broker) external view returns (bool);
731     
732     function pauseControllers(address broker) external view returns (bool);
733 
734     function withdrawControllers(address broker) external view returns (bool);
735 
736     function addBroker() external;
737 
738     function removeBroker() external;
739 
740     function isComponent(address component) external view returns (bool);
741 
742     function addComponent(address perpetual, address component) external;
743 
744     function removeComponent(address perpetual, address component) external;
745 
746     function addPauseController(address controller) external;
747 
748     function removePauseController(address controller) external;
749 
750     function addWithdrawController(address controller) external;
751 
752     function removeWithdrawControllers(address controller) external;
753 }
754 
755 interface IAMM {
756     function shareTokenAddress() external view returns (address);
757 
758     function indexPrice() external view returns (uint256 price, uint256 timestamp);
759 
760     function positionSize() external returns (uint256);
761 
762     function lastFundingState() external view returns (LibTypes.FundingState memory);
763 
764     function currentFundingRate() external returns (int256);
765 
766     function currentFundingState() external returns (LibTypes.FundingState memory);
767 
768     function lastFundingRate() external view returns (int256);
769 
770     function getGovernance() external view returns (LibTypes.AMMGovernanceConfig memory);
771 
772     function perpetualProxy() external view returns (IPerpetual);
773 
774     function currentMarkPrice() external returns (uint256);
775 
776     function currentAvailableMargin() external returns (uint256);
777 
778     function currentPremiumRate() external returns (int256);
779 
780     function currentFairPrice() external returns (uint256);
781 
782     function currentPremium() external returns (int256);
783 
784     function currentAccumulatedFundingPerContract() external returns (int256);
785 
786     function updateIndex() external;
787 
788     function createPool(uint256 amount) external;
789 
790     function settleShare(uint256 shareAmount) external;
791 
792     function buy(uint256 amount, uint256 limitPrice, uint256 deadline) external returns (uint256);
793 
794     function sell(uint256 amount, uint256 limitPrice, uint256 deadline) external returns (uint256);
795 
796     function buyFromWhitelisted(address trader, uint256 amount, uint256 limitPrice, uint256 deadline)
797         external
798         returns (uint256);
799 
800     function sellFromWhitelisted(address trader, uint256 amount, uint256 limitPrice, uint256 deadline)
801         external
802         returns (uint256);
803 
804     function buyFrom(address trader, uint256 amount, uint256 limitPrice, uint256 deadline) external returns (uint256);
805 
806     function sellFrom(address trader, uint256 amount, uint256 limitPrice, uint256 deadline) external returns (uint256);
807 
808     function depositAndBuy(
809         uint256 depositAmount,
810         uint256 tradeAmount,
811         uint256 limitPrice,
812         uint256 deadline
813     ) external payable;
814 
815     function depositAndSell(
816         uint256 depositAmount,
817         uint256 tradeAmount,
818         uint256 limitPrice,
819         uint256 deadline
820     ) external payable;
821 
822     function buyAndWithdraw(
823         uint256 tradeAmount,
824         uint256 limitPrice,
825         uint256 deadline,
826         uint256 withdrawAmount
827     ) external;
828 
829     function sellAndWithdraw(
830         uint256 tradeAmount,
831         uint256 limitPrice,
832         uint256 deadline,
833         uint256 withdrawAmount
834     ) external;
835 
836     function depositAndAddLiquidity(uint256 depositAmount, uint256 amount) external payable;
837 }
838 
839 interface IPerpetual {
840     function devAddress() external view returns (address);
841 
842     function getMarginAccount(address trader) external view returns (LibTypes.MarginAccount memory);
843 
844     function getGovernance() external view returns (LibTypes.PerpGovernanceConfig memory);
845 
846     function status() external view returns (LibTypes.Status);
847 
848     function paused() external view returns (bool);
849 
850     function withdrawDisabled() external view returns (bool);
851 
852     function settlementPrice() external view returns (uint256);
853 
854     function globalConfig() external view returns (address);
855 
856     function collateral() external view returns (address);
857 
858     function amm() external view returns (IAMM);
859 
860     function totalSize(LibTypes.Side side) external view returns (uint256);
861 
862     function markPrice() external returns (uint256);
863 
864     function socialLossPerContract(LibTypes.Side side) external view returns (int256);
865 
866     function availableMargin(address trader) external returns (int256);
867 
868     function positionMargin(address trader) external view returns (uint256);
869 
870     function maintenanceMargin(address trader) external view returns (uint256);
871 
872     function isSafe(address trader) external returns (bool);
873 
874     function isSafeWithPrice(address trader, uint256 currentMarkPrice) external returns (bool);
875 
876     function isIMSafe(address trader) external returns (bool);
877 
878     function isIMSafeWithPrice(address trader, uint256 currentMarkPrice) external returns (bool);
879 
880     function tradePosition(
881         address taker,
882         address maker,
883         LibTypes.Side side,
884         uint256 price,
885         uint256 amount
886     ) external returns (uint256, uint256);
887 
888     function transferCashBalance(
889         address from,
890         address to,
891         uint256 amount
892     ) external;
893 
894     function depositFor(address trader, uint256 amount) external payable;
895 
896     function withdrawFor(address payable trader, uint256 amount) external;
897 
898     function liquidate(address trader, uint256 amount) external returns (uint256, uint256);
899 
900     function insuranceFundBalance() external view returns (int256);
901 
902     function beginGlobalSettlement(uint256 price) external;
903 
904     function endGlobalSettlement() external;
905 
906     function isValidLotSize(uint256 amount) external view returns (bool);
907 
908     function isValidTradingLotSize(uint256 amount) external view returns (bool);
909 }
910 
911 contract Exchange {
912     using LibMathSigned for int256;
913     using LibMathUnsigned for uint256;
914     using LibOrder for LibOrder.Order;
915     using LibOrder for LibOrder.OrderParam;
916     using LibSignature for LibSignature.OrderSignature;
917 
918     // to verify the field in order data, increase if there are incompatible update in order's data.
919     uint256 public constant SUPPORTED_ORDER_VERSION = 2;
920 
921     IGlobalConfig public globalConfig;
922 
923     // order status
924     mapping(bytes32 => uint256) public filled;
925     mapping(bytes32 => bool) public cancelled;
926 
927     event MatchWithOrders(
928         address perpetual,
929         LibOrder.OrderParam takerOrderParam,
930         LibOrder.OrderParam makerOrderParam,
931         uint256 amount
932     );
933     event MatchWithAMM(address perpetual, LibOrder.OrderParam takerOrderParam, uint256 amount);
934     event Cancel(bytes32 indexed orderHash);
935 
936     constructor(address _globalConfig) public {
937         globalConfig = IGlobalConfig(_globalConfig);
938     }
939 
940     /**
941      * Match orders from one taker and multiple makers.
942      *
943      * @param takerOrderParam   Taker's order to match.
944      * @param makerOrderParams  Array of maker's order to match with.
945      * @param _perpetual        Address of perpetual contract.
946      * @param amounts           Array of matching amounts of each taker/maker pair.
947      */
948     function matchOrders(
949         LibOrder.OrderParam memory takerOrderParam,
950         LibOrder.OrderParam[] memory makerOrderParams,
951         address _perpetual,
952         uint256[] memory amounts
953     ) public {
954         require(globalConfig.brokers(msg.sender), "unauthorized broker");
955         require(amounts.length > 0 && makerOrderParams.length == amounts.length, "no makers to match");
956         require(!takerOrderParam.isMakerOnly(), "taker order is maker only");
957 
958         IPerpetual perpetual = IPerpetual(_perpetual);
959         require(perpetual.status() == LibTypes.Status.NORMAL, "wrong perpetual status");
960 
961         uint256 tradingLotSize = perpetual.getGovernance().tradingLotSize;
962         bytes32 takerOrderHash = validateOrderParam(perpetual, takerOrderParam);
963         uint256 takerFilledAmount = filled[takerOrderHash];
964         uint256 takerOpened;
965 
966         for (uint256 i = 0; i < makerOrderParams.length; i++) {
967             if (amounts[i] == 0) {
968                 continue;
969             }
970 
971             require(takerOrderParam.trader != makerOrderParams[i].trader, "self trade");
972             require(takerOrderParam.isInversed() == makerOrderParams[i].isInversed(), "invalid inversed pair");
973             require(takerOrderParam.isSell() != makerOrderParams[i].isSell(), "side must be long or short");
974             require(!makerOrderParams[i].isMarketOrder(), "market order cannot be maker");
975 
976             validatePrice(takerOrderParam, makerOrderParams[i]);
977 
978             bytes32 makerOrderHash = validateOrderParam(perpetual, makerOrderParams[i]);
979             uint256 makerFilledAmount = filled[makerOrderHash];
980 
981             require(amounts[i] <= takerOrderParam.amount.sub(takerFilledAmount), "taker overfilled");
982             require(amounts[i] <= makerOrderParams[i].amount.sub(makerFilledAmount), "maker overfilled");
983             require(amounts[i].mod(tradingLotSize) == 0, "amount must be divisible by tradingLotSize");
984 
985             uint256 opened = fillOrder(perpetual, takerOrderParam, makerOrderParams[i], amounts[i]);
986 
987             takerOpened = takerOpened.add(opened);
988             filled[makerOrderHash] = makerFilledAmount.add(amounts[i]);
989             takerFilledAmount = takerFilledAmount.add(amounts[i]);
990         }
991 
992         // all trades done, check taker safe.
993         if (takerOpened > 0) {
994             require(perpetual.isIMSafe(takerOrderParam.trader), "taker initial margin unsafe");
995         } else {
996             require(perpetual.isSafe(takerOrderParam.trader), "maker unsafe");
997         }
998         require(perpetual.isSafe(msg.sender), "broker unsafe");
999 
1000         filled[takerOrderHash] = takerFilledAmount;
1001     }
1002 
1003     /**
1004      * @dev Match orders from taker with amm. It is exactly same with directly trading from amm.
1005      *
1006      * @param takerOrderParam  Taker's order to match.
1007      * @param _perpetual        Address of perpetual contract.
1008      * @param amount           Amount to fiil.
1009      * @return Opened position amount of taker.
1010      */
1011     function matchOrderWithAMM(
1012         LibOrder.OrderParam memory takerOrderParam,
1013         address _perpetual,
1014         uint256 amount
1015     ) public {
1016         require(globalConfig.brokers(msg.sender), "unauthorized broker");
1017         require(amount > 0, "amount must be greater than 0");
1018         require(!takerOrderParam.isMakerOnly(), "taker order is maker only");
1019 
1020         IPerpetual perpetual = IPerpetual(_perpetual);
1021         IAMM amm = IAMM(perpetual.amm());
1022 
1023         bytes32 takerOrderHash = validateOrderParam(perpetual, takerOrderParam);
1024         uint256 takerFilledAmount = filled[takerOrderHash];
1025         require(amount <= takerOrderParam.amount.sub(takerFilledAmount), "taker overfilled");
1026 
1027         // trading with pool
1028         uint256 takerOpened;
1029         uint256 price = takerOrderParam.getPrice();
1030         uint256 expired = takerOrderParam.expiredAt();
1031         if (takerOrderParam.isSell()) {
1032             takerOpened = amm.sellFromWhitelisted(
1033                 takerOrderParam.trader,
1034                 amount,
1035                 price,
1036                 expired
1037             );
1038         } else {
1039             takerOpened = amm.buyFromWhitelisted(takerOrderParam.trader, amount, price, expired);
1040         }
1041         filled[takerOrderHash] = filled[takerOrderHash].add(amount);
1042 
1043         emit MatchWithAMM(_perpetual, takerOrderParam, amount);
1044     }
1045 
1046     /**
1047      * @dev Cancel order.
1048      *
1049      * @param order Order to cancel.
1050      */
1051     function cancelOrder(LibOrder.Order memory order) public {
1052         require(msg.sender == order.trader || msg.sender == order.broker, "invalid caller");
1053 
1054         bytes32 orderHash = order.getOrderHash();
1055         cancelled[orderHash] = true;
1056 
1057         emit Cancel(orderHash);
1058     }
1059 
1060     /**
1061      * @dev Get current chain id. need istanbul hardfork.
1062      *
1063      * @return Current chain id.
1064      */
1065     function getChainId() public pure returns (uint256 id) {
1066         assembly {
1067             id := chainid()
1068         }
1069     }
1070 
1071     /**
1072      * @dev Fill order at the maker's price, then claim trading and dev fee from both side.
1073      *
1074      * @param perpetual        Address of perpetual contract.
1075      * @param takerOrderParam  Taker's order to match.
1076      * @param makerOrderParam  Maker's order to match.
1077      * @param amount           Amount to fiil.
1078      * @return Opened position amount of taker.
1079      */
1080     function fillOrder(
1081         IPerpetual perpetual,
1082         LibOrder.OrderParam memory takerOrderParam,
1083         LibOrder.OrderParam memory makerOrderParam,
1084         uint256 amount
1085     ) internal returns (uint256) {
1086         uint256 price = makerOrderParam.getPrice();
1087         (uint256 takerOpened, uint256 makerOpened) = perpetual.tradePosition(
1088             takerOrderParam.trader,
1089             makerOrderParam.trader,
1090             takerOrderParam.side(),
1091             price,
1092             amount
1093         );
1094 
1095         // trading fee
1096         int256 takerTradingFee = amount.wmul(price).toInt256().wmul(takerOrderParam.takerFeeRate());
1097         claimTradingFee(perpetual, takerOrderParam.trader, takerTradingFee);
1098         int256 makerTradingFee = amount.wmul(price).toInt256().wmul(makerOrderParam.makerFeeRate());
1099         claimTradingFee(perpetual, makerOrderParam.trader, makerTradingFee);
1100 
1101         // dev fee
1102         claimTakerDevFee(perpetual, takerOrderParam.trader, price, takerOpened, amount.sub(takerOpened));
1103         claimMakerDevFee(perpetual, makerOrderParam.trader, price, makerOpened, amount.sub(makerOpened));
1104         if (makerOpened > 0) {
1105             require(perpetual.isIMSafe(makerOrderParam.trader), "maker initial margin unsafe");
1106         } else {
1107             require(perpetual.isSafe(makerOrderParam.trader), "maker unsafe");
1108         }
1109 
1110         emit MatchWithOrders(address(perpetual), takerOrderParam, makerOrderParam, amount);
1111 
1112         return takerOpened;
1113     }
1114 
1115     /**
1116      * @dev Check prices are meet.
1117      *
1118      * @param takerOrderParam  Taker's order.
1119      * @param takerOrderParam  Maker's order.
1120      * @return Opened position amount of taker.
1121      */
1122     function validatePrice(LibOrder.OrderParam memory takerOrderParam, LibOrder.OrderParam memory makerOrderParam)
1123         internal
1124         pure
1125     {
1126         if (takerOrderParam.isMarketOrder()) {
1127             return;
1128         }
1129         uint256 takerPrice = takerOrderParam.getPrice();
1130         uint256 makerPrice = makerOrderParam.getPrice();
1131         require(takerOrderParam.isSell() ? takerPrice <= makerPrice : takerPrice >= makerPrice, "price not match");
1132     }
1133 
1134 
1135     /**
1136      * @dev Validate fields of order.
1137      *
1138      * @param perpetual  Instance of perpetual contract.
1139      * @param orderParam Order parameter.
1140      * @return Valid order hash.
1141      */
1142     function validateOrderParam(IPerpetual perpetual, LibOrder.OrderParam memory orderParam)
1143         internal
1144         view
1145         returns (bytes32)
1146     {
1147         require(orderParam.orderVersion() == SUPPORTED_ORDER_VERSION, "unsupported version");
1148         require(orderParam.expiredAt() >= block.timestamp, "order expired");
1149         require(orderParam.chainId() == getChainId(), "unmatched chainid");
1150 
1151         bytes32 orderHash = orderParam.getOrderHash(address(perpetual), msg.sender);
1152         require(!cancelled[orderHash], "cancelled order");
1153         require(orderParam.signature.isValidSignature(orderHash, orderParam.trader), "invalid signature");
1154         require(filled[orderHash] < orderParam.amount, "fullfilled order");
1155 
1156         return orderHash;
1157     }
1158 
1159     /**
1160      * @dev Claim trading fee. Fee goes to brokers margin account.
1161      *
1162      * @param perpetual Address of perpetual contract.
1163      * @param trader    Address of account who will pay fee out.
1164      * @param fee       Amount of fee, decimals = 18.
1165      */
1166     function claimTradingFee(
1167         IPerpetual perpetual,
1168         address trader,
1169         int256 fee
1170     )
1171         internal
1172     {
1173         if (fee > 0) {
1174             perpetual.transferCashBalance(trader, msg.sender, fee.toUint256());
1175         } else if (fee < 0) {
1176             perpetual.transferCashBalance(msg.sender, trader, fee.neg().toUint256());
1177         }
1178     }
1179 
1180 
1181     /**
1182      * @dev Claim dev fee. Especially, for fee from closing positon
1183      *
1184      * @param perpetual     Address of perpetual.
1185      * @param trader        Address of margin account.
1186      * @param price         Price of position.
1187      * @param openedAmount  Opened position amount.
1188      * @param closedAmount  Closed position amount.
1189      * @param feeRate       Maker's order.
1190      */
1191     function claimDevFee(
1192         IPerpetual perpetual,
1193         address trader,
1194         uint256 price,
1195         uint256 openedAmount,
1196         uint256 closedAmount,
1197         int256 feeRate
1198     )
1199         internal
1200     {
1201         if (feeRate == 0) {
1202             return;
1203         }
1204         int256 hard = price.wmul(openedAmount).toInt256().wmul(feeRate);
1205         int256 soft = price.wmul(closedAmount).toInt256().wmul(feeRate);
1206         int256 fee = hard.add(soft);
1207         address devAddress = perpetual.devAddress();
1208         if (fee > 0) {
1209             int256 available = perpetual.availableMargin(trader);
1210             require(available >= hard, "available margin too low for fee");
1211             fee = fee.min(available);
1212             perpetual.transferCashBalance(trader, devAddress, fee.toUint256());
1213         } else if (fee < 0) {
1214             perpetual.transferCashBalance(devAddress, trader, fee.neg().toUint256());
1215             require(perpetual.isSafe(devAddress), "dev unsafe");
1216         }
1217     }
1218 
1219     /**
1220      * @dev Claim dev fee in taker fee rate set by perpetual governacne.
1221      *
1222      * @param perpetual     Address of perpetual.
1223      * @param trader        Taker's order.
1224      * @param price         Maker's order.
1225      * @param openedAmount  Maker's order.
1226      * @param closedAmount  Maker's order.
1227      */
1228     function claimTakerDevFee(
1229         IPerpetual perpetual,
1230         address trader,
1231         uint256 price,
1232         uint256 openedAmount,
1233         uint256 closedAmount
1234     )
1235         internal
1236     {
1237         int256 rate = perpetual.getGovernance().takerDevFeeRate;
1238         claimDevFee(perpetual, trader, price, openedAmount, closedAmount, rate);
1239     }
1240 
1241     /**
1242      * @dev Claim dev fee in maker fee rate set by perpetual governacne.
1243      *
1244      * @param perpetual     Address of perpetual.
1245      * @param trader        Taker's order.
1246      * @param price         Maker's order.
1247      * @param openedAmount  Maker's order.
1248      * @param closedAmount  Maker's order.
1249      */
1250     function claimMakerDevFee(
1251         IPerpetual perpetual,
1252         address trader,
1253         uint256 price,
1254         uint256 openedAmount,
1255         uint256 closedAmount
1256     )
1257         internal
1258     {
1259         int256 rate = perpetual.getGovernance().makerDevFeeRate;
1260         claimDevFee(perpetual, trader, price, openedAmount, closedAmount, rate);
1261     }
1262 }