1 // File: contracts/vendor/SafeMath.sol
2 
3 pragma solidity ^0.6.0;
4 
5 /**
6  * @dev Wrappers over Solidity's arithmetic operations with added overflow
7  * checks.
8  *
9  * Arithmetic operations in Solidity wrap on overflow. This can easily result
10  * in bugs, because programmers usually assume that an overflow raises an
11  * error, which is the standard behavior in high level programming languages.
12  * `SafeMath` restores this intuition by reverting the transaction when an
13  * operation overflows.
14  *
15  * Using this library instead of the unchecked operations eliminates an entire
16  * class of bugs, so it's recommended to use it always.
17  */
18 library SafeMath {
19   /**
20     * @dev Returns the addition of two unsigned integers, reverting on
21     * overflow.
22     *
23     * Counterpart to Solidity's `+` operator.
24     *
25     * Requirements:
26     * - Addition cannot overflow.
27     */
28   function add(uint256 a, uint256 b) internal pure returns (uint256) {
29     uint256 c = a + b;
30     require(c >= a, "SafeMath: addition overflow");
31 
32     return c;
33   }
34 
35   /**
36     * @dev Returns the subtraction of two unsigned integers, reverting on
37     * overflow (when the result is negative).
38     *
39     * Counterpart to Solidity's `-` operator.
40     *
41     * Requirements:
42     * - Subtraction cannot overflow.
43     */
44   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45     require(b <= a, "SafeMath: subtraction overflow");
46     uint256 c = a - b;
47 
48     return c;
49   }
50 
51   /**
52     * @dev Returns the multiplication of two unsigned integers, reverting on
53     * overflow.
54     *
55     * Counterpart to Solidity's `*` operator.
56     *
57     * Requirements:
58     * - Multiplication cannot overflow.
59     */
60   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
61     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
62     // benefit is lost if 'b' is also tested.
63     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
64     if (a == 0) {
65       return 0;
66     }
67 
68     uint256 c = a * b;
69     require(c / a == b, "SafeMath: multiplication overflow");
70 
71     return c;
72   }
73 
74   /**
75     * @dev Returns the integer division of two unsigned integers. Reverts on
76     * division by zero. The result is rounded towards zero.
77     *
78     * Counterpart to Solidity's `/` operator. Note: this function uses a
79     * `revert` opcode (which leaves remaining gas untouched) while Solidity
80     * uses an invalid opcode to revert (consuming all remaining gas).
81     *
82     * Requirements:
83     * - The divisor cannot be zero.
84     */
85   function div(uint256 a, uint256 b) internal pure returns (uint256) {
86     // Solidity only automatically asserts when dividing by 0
87     require(b > 0, "SafeMath: division by zero");
88     uint256 c = a / b;
89     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
90 
91     return c;
92   }
93 
94   /**
95     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
96     * Reverts when dividing by zero.
97     *
98     * Counterpart to Solidity's `%` operator. This function uses a `revert`
99     * opcode (which leaves remaining gas untouched) while Solidity uses an
100     * invalid opcode to revert (consuming all remaining gas).
101     *
102     * Requirements:
103     * - The divisor cannot be zero.
104     */
105   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
106     require(b != 0, "SafeMath: modulo by zero");
107     return a % b;
108   }
109 }
110 
111 // File: contracts/interfaces/LinkTokenInterface.sol
112 
113 pragma solidity ^0.6.0;
114 
115 interface LinkTokenInterface {
116   function allowance(address owner, address spender) external view returns (uint256 remaining);
117   function approve(address spender, uint256 value) external returns (bool success);
118   function balanceOf(address owner) external view returns (uint256 balance);
119   function decimals() external view returns (uint8 decimalPlaces);
120   function decreaseApproval(address spender, uint256 addedValue) external returns (bool success);
121   function increaseApproval(address spender, uint256 subtractedValue) external;
122   function name() external view returns (string memory tokenName);
123   function symbol() external view returns (string memory tokenSymbol);
124   function totalSupply() external view returns (uint256 totalTokensIssued);
125   function transfer(address to, uint256 value) external returns (bool success);
126   function transferAndCall(address to, uint256 value, bytes calldata data) external returns (bool success);
127   function transferFrom(address from, address to, uint256 value) external returns (bool success);
128 }
129 
130 // File: contracts/interfaces/BlockHashStoreInterface.sol
131 
132 pragma solidity 0.6.6;
133 
134 interface BlockHashStoreInterface {
135   function getBlockhash(uint256 number) external view returns (bytes32);
136 }
137 
138 // File: contracts/VRF.sol
139 
140 pragma solidity 0.6.6;
141 
142 /** ****************************************************************************
143   * @notice Verification of verifiable-random-function (VRF) proofs, following
144   * @notice https://datatracker.ietf.org/doc/html/draft-irtf-cfrg-vrf-05#section-5.3
145   * @notice See https://eprint.iacr.org/2017/099.pdf for security proofs.
146 
147   * @dev Bibliographic references:
148 
149   * @dev Goldberg, et al., "Verifiable Random Functions (VRFs)", Internet Draft
150   * @dev draft-irtf-cfrg-vrf-05, IETF, Aug 11 2019,
151   * @dev https://datatracker.ietf.org/doc/html/draft-irtf-cfrg-vrf-05
152 
153   * @dev Papadopoulos, et al., "Making NSEC5 Practical for DNSSEC", Cryptology
154   * @dev ePrint Archive, Report 2017/099, https://eprint.iacr.org/2017/099.pdf
155   * ****************************************************************************
156   * @dev USAGE
157 
158   * @dev The main entry point is randomValueFromVRFProof. See its docstring.
159   * ****************************************************************************
160   * @dev PURPOSE
161 
162   * @dev Reggie the Random Oracle (not his real job) wants to provide randomness
163   * @dev to Vera the verifier in such a way that Vera can be sure he's not
164   * @dev making his output up to suit himself. Reggie provides Vera a public key
165   * @dev to which he knows the secret key. Each time Vera provides a seed to
166   * @dev Reggie, he gives back a value which is computed completely
167   * @dev deterministically from the seed and the secret key.
168 
169   * @dev Reggie provides a proof by which Vera can verify that the output was
170   * @dev correctly computed once Reggie tells it to her, but without that proof,
171   * @dev the output is computationally indistinguishable to her from a uniform
172   * @dev random sample from the output space.
173 
174   * @dev The purpose of this contract is to perform that verification.
175   * ****************************************************************************
176   * @dev DESIGN NOTES
177 
178   * @dev The VRF algorithm verified here satisfies the full unqiqueness, full
179   * @dev collision resistance, and full pseudorandomness security properties.
180   * @dev See "SECURITY PROPERTIES" below, and
181   * @dev https://datatracker.ietf.org/doc/html/draft-irtf-cfrg-vrf-05#section-3
182 
183   * @dev An elliptic curve point is generally represented in the solidity code
184   * @dev as a uint256[2], corresponding to its affine coordinates in
185   * @dev GF(FIELD_SIZE).
186 
187   * @dev For the sake of efficiency, this implementation deviates from the spec
188   * @dev in some minor ways:
189 
190   * @dev - Keccak hash rather than the SHA256 hash recommended in
191   * @dev   https://datatracker.ietf.org/doc/html/draft-irtf-cfrg-vrf-05#section-5.5
192   * @dev   Keccak costs much less gas on the EVM, and provides similar security.
193 
194   * @dev - Secp256k1 curve instead of the P-256 or ED25519 curves recommended in
195   * @dev   https://datatracker.ietf.org/doc/html/draft-irtf-cfrg-vrf-05#section-5.5
196   * @dev   For curve-point multiplication, it's much cheaper to abuse ECRECOVER
197 
198   * @dev - hashToCurve recursively hashes until it finds a curve x-ordinate. On
199   * @dev   the EVM, this is slightly more efficient than the recommendation in
200   * @dev   https://datatracker.ietf.org/doc/html/draft-irtf-cfrg-vrf-05#section-5.4.1.1
201   * @dev   step 5, to concatenate with a nonce then hash, and rehash with the
202   * @dev   nonce updated until a valid x-ordinate is found.
203 
204   * @dev - hashToCurve does not include a cipher version string or the byte 0x1
205   * @dev   in the hash message, as recommended in step 5.B of the draft
206   * @dev   standard. They are unnecessary here because no variation in the
207   * @dev   cipher suite is allowed.
208 
209   * @dev - Similarly, the hash input in scalarFromCurvePoints does not include a
210   * @dev   commitment to the cipher suite, either, which differs from step 2 of
211   * @dev   https://datatracker.ietf.org/doc/html/draft-irtf-cfrg-vrf-05#section-5.4.3
212   * @dev   . Also, the hash input is the concatenation of the uncompressed
213   * @dev   points, not the compressed points as recommended in step 3.
214 
215   * @dev - In the calculation of the challenge value "c", the "u" value (i.e.
216   * @dev   the value computed by Reggie as the nonce times the secp256k1
217   * @dev   generator point, see steps 5 and 7 of
218   * @dev   https://datatracker.ietf.org/doc/html/draft-irtf-cfrg-vrf-05#section-5.3
219   * @dev   ) is replaced by its ethereum address, i.e. the lower 160 bits of the
220   * @dev   keccak hash of the original u. This is because we only verify the
221   * @dev   calculation of u up to its address, by abusing ECRECOVER.
222   * ****************************************************************************
223   * @dev   SECURITY PROPERTIES
224 
225   * @dev Here are the security properties for this VRF:
226 
227   * @dev Full uniqueness: For any seed and valid VRF public key, there is
228   * @dev   exactly one VRF output which can be proved to come from that seed, in
229   * @dev   the sense that the proof will pass verifyVRFProof.
230 
231   * @dev Full collision resistance: It's cryptographically infeasible to find
232   * @dev   two seeds with same VRF output from a fixed, valid VRF key
233 
234   * @dev Full pseudorandomness: Absent the proofs that the VRF outputs are
235   * @dev   derived from a given seed, the outputs are computationally
236   * @dev   indistinguishable from randomness.
237 
238   * @dev https://eprint.iacr.org/2017/099.pdf, Appendix B contains the proofs
239   * @dev for these properties.
240 
241   * @dev For secp256k1, the key validation described in section
242   * @dev https://datatracker.ietf.org/doc/html/draft-irtf-cfrg-vrf-05#section-5.6
243   * @dev is unnecessary, because secp256k1 has cofactor 1, and the
244   * @dev representation of the public key used here (affine x- and y-ordinates
245   * @dev of the secp256k1 point on the standard y^2=x^3+7 curve) cannot refer to
246   * @dev the point at infinity.
247   * ****************************************************************************
248   * @dev OTHER SECURITY CONSIDERATIONS
249   *
250   * @dev The seed input to the VRF could in principle force an arbitrary amount
251   * @dev of work in hashToCurve, by requiring extra rounds of hashing and
252   * @dev checking whether that's yielded the x ordinate of a secp256k1 point.
253   * @dev However, under the Random Oracle Model the probability of choosing a
254   * @dev point which forces n extra rounds in hashToCurve is 2⁻ⁿ. The base cost
255   * @dev for calling hashToCurve is about 25,000 gas, and each round of checking
256   * @dev for a valid x ordinate costs about 15,555 gas, so to find a seed for
257   * @dev which hashToCurve would cost more than 2,017,000 gas, one would have to
258   * @dev try, in expectation, about 2¹²⁸ seeds, which is infeasible for any
259   * @dev foreseeable computational resources. (25,000 + 128 * 15,555 < 2,017,000.)
260 
261   * @dev Since the gas block limit for the Ethereum main net is 10,000,000 gas,
262   * @dev this means it is infeasible for an adversary to prevent correct
263   * @dev operation of this contract by choosing an adverse seed.
264 
265   * @dev (See TestMeasureHashToCurveGasCost for verification of the gas cost for
266   * @dev hashToCurve.)
267 
268   * @dev It may be possible to make a secure constant-time hashToCurve function.
269   * @dev See notes in hashToCurve docstring.
270 */
271 contract VRF {
272 
273   // See https://www.secg.org/sec2-v2.pdf, section 2.4.1, for these constants.
274   uint256 constant private GROUP_ORDER = // Number of points in Secp256k1
275     // solium-disable-next-line indentation
276     0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141;
277   // Prime characteristic of the galois field over which Secp256k1 is defined
278   uint256 constant private FIELD_SIZE =
279     // solium-disable-next-line indentation
280     0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFC2F;
281   uint256 constant private WORD_LENGTH_BYTES = 0x20;
282 
283   // (base^exponent) % FIELD_SIZE
284   // Cribbed from https://medium.com/@rbkhmrcr/precompiles-solidity-e5d29bd428c4
285   function bigModExp(uint256 base, uint256 exponent)
286     internal view returns (uint256 exponentiation) {
287       uint256 callResult;
288       uint256[6] memory bigModExpContractInputs;
289       bigModExpContractInputs[0] = WORD_LENGTH_BYTES;  // Length of base
290       bigModExpContractInputs[1] = WORD_LENGTH_BYTES;  // Length of exponent
291       bigModExpContractInputs[2] = WORD_LENGTH_BYTES;  // Length of modulus
292       bigModExpContractInputs[3] = base;
293       bigModExpContractInputs[4] = exponent;
294       bigModExpContractInputs[5] = FIELD_SIZE;
295       uint256[1] memory output;
296       assembly { // solhint-disable-line no-inline-assembly
297       callResult := staticcall(
298         not(0),                   // Gas cost: no limit
299         0x05,                     // Bigmodexp contract address
300         bigModExpContractInputs,
301         0xc0,                     // Length of input segment: 6*0x20-bytes
302         output,
303         0x20                      // Length of output segment
304       )
305       }
306       if (callResult == 0) {revert("bigModExp failure!");}
307       return output[0];
308     }
309 
310   // Let q=FIELD_SIZE. q % 4 = 3, ∴ x≡r^2 mod q ⇒ x^SQRT_POWER≡±r mod q.  See
311   // https://en.wikipedia.org/wiki/Modular_square_root#Prime_or_prime_power_modulus
312   uint256 constant private SQRT_POWER = (FIELD_SIZE + 1) >> 2;
313 
314   // Computes a s.t. a^2 = x in the field. Assumes a exists
315   function squareRoot(uint256 x) internal view returns (uint256) {
316     return bigModExp(x, SQRT_POWER);
317   }
318 
319   // The value of y^2 given that (x,y) is on secp256k1.
320   function ySquared(uint256 x) internal pure returns (uint256) {
321     // Curve is y^2=x^3+7. See section 2.4.1 of https://www.secg.org/sec2-v2.pdf
322     uint256 xCubed = mulmod(x, mulmod(x, x, FIELD_SIZE), FIELD_SIZE);
323     return addmod(xCubed, 7, FIELD_SIZE);
324   }
325 
326   // True iff p is on secp256k1
327   function isOnCurve(uint256[2] memory p) internal pure returns (bool) {
328     return ySquared(p[0]) == mulmod(p[1], p[1], FIELD_SIZE);
329   }
330 
331   // Hash x uniformly into {0, ..., FIELD_SIZE-1}.
332   function fieldHash(bytes memory b) internal pure returns (uint256 x_) {
333     x_ = uint256(keccak256(b));
334     // Rejecting if x >= FIELD_SIZE corresponds to step 2.1 in section 2.3.4 of
335     // http://www.secg.org/sec1-v2.pdf , which is part of the definition of
336     // string_to_point in the IETF draft
337     while (x_ >= FIELD_SIZE) {
338       x_ = uint256(keccak256(abi.encodePacked(x_)));
339     }
340   }
341 
342   // Hash b to a random point which hopefully lies on secp256k1. The y ordinate
343   // is always even, due to
344   // https://datatracker.ietf.org/doc/html/draft-irtf-cfrg-vrf-05#section-5.4.1.1
345   // step 5.C, which references arbitrary_string_to_point, defined in
346   // https://datatracker.ietf.org/doc/html/draft-irtf-cfrg-vrf-05#section-5.5 as
347   // returning the point with given x ordinate, and even y ordinate.
348   function newCandidateSecp256k1Point(bytes memory b)
349     internal view returns (uint256[2] memory p) {
350       p[0] = fieldHash(b);
351       p[1] = squareRoot(ySquared(p[0]));
352       if (p[1] % 2 == 1) {
353         p[1] = FIELD_SIZE - p[1];
354       }
355     }
356 
357   // Domain-separation tag for initial hash in hashToCurve. Corresponds to
358   // vrf.go/hashToCurveHashPrefix
359   uint256 constant HASH_TO_CURVE_HASH_PREFIX = 1;
360 
361   // Cryptographic hash function onto the curve.
362   //
363   // Corresponds to algorithm in section 5.4.1.1 of the draft standard. (But see
364   // DESIGN NOTES above for slight differences.)
365   //
366   // TODO(alx): Implement a bounded-computation hash-to-curve, as described in
367   // "Construction of Rational Points on Elliptic Curves over Finite Fields"
368   // http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.831.5299&rep=rep1&type=pdf
369   // and suggested by
370   // https://datatracker.ietf.org/doc/html/draft-irtf-cfrg-hash-to-curve-01#section-5.2.2
371   // (Though we can't used exactly that because secp256k1's j-invariant is 0.)
372   //
373   // This would greatly simplify the analysis in "OTHER SECURITY CONSIDERATIONS"
374   // https://www.pivotaltracker.com/story/show/171120900
375   function hashToCurve(uint256[2] memory pk, uint256 input)
376     internal view returns (uint256[2] memory rv) {
377       rv = newCandidateSecp256k1Point(abi.encodePacked(HASH_TO_CURVE_HASH_PREFIX,
378                                                        pk, input));
379       while (!isOnCurve(rv)) {
380         rv = newCandidateSecp256k1Point(abi.encodePacked(rv[0]));
381       }
382     }
383 
384   /** *********************************************************************
385    * @notice Check that product==scalar*multiplicand
386    *
387    * @dev Based on Vitalik Buterin's idea in ethresear.ch post cited below.
388    *
389    * @param multiplicand: secp256k1 point
390    * @param scalar: non-zero GF(GROUP_ORDER) scalar
391    * @param product: secp256k1 expected to be multiplier * multiplicand
392    * @return verifies true iff product==scalar*multiplicand, with cryptographically high probability
393    */
394   function ecmulVerify(uint256[2] memory multiplicand, uint256 scalar,
395     uint256[2] memory product) internal pure returns(bool verifies)
396   {
397     require(scalar != 0); // Rules out an ecrecover failure case
398     uint256 x = multiplicand[0]; // x ordinate of multiplicand
399     uint8 v = multiplicand[1] % 2 == 0 ? 27 : 28; // parity of y ordinate
400     // https://ethresear.ch/t/you-can-kinda-abuse-ecrecover-to-do-ecmul-in-secp256k1-today/2384/9
401     // Point corresponding to address ecrecover(0, v, x, s=scalar*x) is
402     // (x⁻¹ mod GROUP_ORDER) * (scalar * x * multiplicand - 0 * g), i.e.
403     // scalar*multiplicand. See https://crypto.stackexchange.com/a/18106
404     bytes32 scalarTimesX = bytes32(mulmod(scalar, x, GROUP_ORDER));
405     address actual = ecrecover(bytes32(0), v, bytes32(x), scalarTimesX);
406     // Explicit conversion to address takes bottom 160 bits
407     address expected = address(uint256(keccak256(abi.encodePacked(product))));
408     return (actual == expected);
409   }
410 
411   // Returns x1/z1-x2/z2=(x1z2-x2z1)/(z1z2) in projective coordinates on P¹(𝔽ₙ)
412   function projectiveSub(uint256 x1, uint256 z1, uint256 x2, uint256 z2)
413     internal pure returns(uint256 x3, uint256 z3) {
414       uint256 num1 = mulmod(z2, x1, FIELD_SIZE);
415       uint256 num2 = mulmod(FIELD_SIZE - x2, z1, FIELD_SIZE);
416       (x3, z3) = (addmod(num1, num2, FIELD_SIZE), mulmod(z1, z2, FIELD_SIZE));
417     }
418 
419   // Returns x1/z1*x2/z2=(x1x2)/(z1z2), in projective coordinates on P¹(𝔽ₙ)
420   function projectiveMul(uint256 x1, uint256 z1, uint256 x2, uint256 z2)
421     internal pure returns(uint256 x3, uint256 z3) {
422       (x3, z3) = (mulmod(x1, x2, FIELD_SIZE), mulmod(z1, z2, FIELD_SIZE));
423     }
424 
425   /** **************************************************************************
426       @notice Computes elliptic-curve sum, in projective co-ordinates
427 
428       @dev Using projective coordinates avoids costly divisions
429 
430       @dev To use this with p and q in affine coordinates, call
431       @dev projectiveECAdd(px, py, qx, qy). This will return
432       @dev the addition of (px, py, 1) and (qx, qy, 1), in the
433       @dev secp256k1 group.
434 
435       @dev This can be used to calculate the z which is the inverse to zInv
436       @dev in isValidVRFOutput. But consider using a faster
437       @dev re-implementation such as ProjectiveECAdd in the golang vrf package.
438 
439       @dev This function assumes [px,py,1],[qx,qy,1] are valid projective
440            coordinates of secp256k1 points. That is safe in this contract,
441            because this method is only used by linearCombination, which checks
442            points are on the curve via ecrecover.
443       **************************************************************************
444       @param px The first affine coordinate of the first summand
445       @param py The second affine coordinate of the first summand
446       @param qx The first affine coordinate of the second summand
447       @param qy The second affine coordinate of the second summand
448 
449       (px,py) and (qx,qy) must be distinct, valid secp256k1 points.
450       **************************************************************************
451       Return values are projective coordinates of [px,py,1]+[qx,qy,1] as points
452       on secp256k1, in P²(𝔽ₙ)
453       @return sx 
454       @return sy
455       @return sz
456   */
457   function projectiveECAdd(uint256 px, uint256 py, uint256 qx, uint256 qy)
458     internal pure returns(uint256 sx, uint256 sy, uint256 sz) {
459       // See "Group law for E/K : y^2 = x^3 + ax + b", in section 3.1.2, p. 80,
460       // "Guide to Elliptic Curve Cryptography" by Hankerson, Menezes and Vanstone
461       // We take the equations there for (sx,sy), and homogenize them to
462       // projective coordinates. That way, no inverses are required, here, and we
463       // only need the one inverse in affineECAdd.
464 
465       // We only need the "point addition" equations from Hankerson et al. Can
466       // skip the "point doubling" equations because p1 == p2 is cryptographically
467       // impossible, and require'd not to be the case in linearCombination.
468 
469       // Add extra "projective coordinate" to the two points
470       (uint256 z1, uint256 z2) = (1, 1);
471 
472       // (lx, lz) = (qy-py)/(qx-px), i.e., gradient of secant line.
473       uint256 lx = addmod(qy, FIELD_SIZE - py, FIELD_SIZE);
474       uint256 lz = addmod(qx, FIELD_SIZE - px, FIELD_SIZE);
475 
476       uint256 dx; // Accumulates denominator from sx calculation
477       // sx=((qy-py)/(qx-px))^2-px-qx
478       (sx, dx) = projectiveMul(lx, lz, lx, lz); // ((qy-py)/(qx-px))^2
479       (sx, dx) = projectiveSub(sx, dx, px, z1); // ((qy-py)/(qx-px))^2-px
480       (sx, dx) = projectiveSub(sx, dx, qx, z2); // ((qy-py)/(qx-px))^2-px-qx
481 
482       uint256 dy; // Accumulates denominator from sy calculation
483       // sy=((qy-py)/(qx-px))(px-sx)-py
484       (sy, dy) = projectiveSub(px, z1, sx, dx); // px-sx
485       (sy, dy) = projectiveMul(sy, dy, lx, lz); // ((qy-py)/(qx-px))(px-sx)
486       (sy, dy) = projectiveSub(sy, dy, py, z1); // ((qy-py)/(qx-px))(px-sx)-py
487 
488       if (dx != dy) { // Cross-multiply to put everything over a common denominator
489         sx = mulmod(sx, dy, FIELD_SIZE);
490         sy = mulmod(sy, dx, FIELD_SIZE);
491         sz = mulmod(dx, dy, FIELD_SIZE);
492       } else { // Already over a common denominator, use that for z ordinate
493         sz = dx;
494       }
495     }
496 
497   // p1+p2, as affine points on secp256k1.
498   //
499   // invZ must be the inverse of the z returned by projectiveECAdd(p1, p2).
500   // It is computed off-chain to save gas.
501   //
502   // p1 and p2 must be distinct, because projectiveECAdd doesn't handle
503   // point doubling.
504   function affineECAdd(
505     uint256[2] memory p1, uint256[2] memory p2,
506     uint256 invZ) internal pure returns (uint256[2] memory) {
507     uint256 x;
508     uint256 y;
509     uint256 z;
510     (x, y, z) = projectiveECAdd(p1[0], p1[1], p2[0], p2[1]);
511     require(mulmod(z, invZ, FIELD_SIZE) == 1, "invZ must be inverse of z");
512     // Clear the z ordinate of the projective representation by dividing through
513     // by it, to obtain the affine representation
514     return [mulmod(x, invZ, FIELD_SIZE), mulmod(y, invZ, FIELD_SIZE)];
515   }
516 
517   // True iff address(c*p+s*g) == lcWitness, where g is generator. (With
518   // cryptographically high probability.)
519   function verifyLinearCombinationWithGenerator(
520     uint256 c, uint256[2] memory p, uint256 s, address lcWitness)
521     internal pure returns (bool) {
522       // Rule out ecrecover failure modes which return address 0.
523       require(lcWitness != address(0), "bad witness");
524       uint8 v = (p[1] % 2 == 0) ? 27 : 28; // parity of y-ordinate of p
525       bytes32 pseudoHash = bytes32(GROUP_ORDER - mulmod(p[0], s, GROUP_ORDER)); // -s*p[0]
526       bytes32 pseudoSignature = bytes32(mulmod(c, p[0], GROUP_ORDER)); // c*p[0]
527       // https://ethresear.ch/t/you-can-kinda-abuse-ecrecover-to-do-ecmul-in-secp256k1-today/2384/9
528       // The point corresponding to the address returned by
529       // ecrecover(-s*p[0],v,p[0],c*p[0]) is
530       // (p[0]⁻¹ mod GROUP_ORDER)*(c*p[0]-(-s)*p[0]*g)=c*p+s*g.
531       // See https://crypto.stackexchange.com/a/18106
532       // https://bitcoin.stackexchange.com/questions/38351/ecdsa-v-r-s-what-is-v
533       address computed = ecrecover(pseudoHash, v, bytes32(p[0]), pseudoSignature);
534       return computed == lcWitness;
535     }
536 
537   // c*p1 + s*p2. Requires cp1Witness=c*p1 and sp2Witness=s*p2. Also
538   // requires cp1Witness != sp2Witness (which is fine for this application,
539   // since it is cryptographically impossible for them to be equal. In the
540   // (cryptographically impossible) case that a prover accidentally derives
541   // a proof with equal c*p1 and s*p2, they should retry with a different
542   // proof nonce.) Assumes that all points are on secp256k1
543   // (which is checked in verifyVRFProof below.)
544   function linearCombination(
545     uint256 c, uint256[2] memory p1, uint256[2] memory cp1Witness,
546     uint256 s, uint256[2] memory p2, uint256[2] memory sp2Witness,
547     uint256 zInv)
548     internal pure returns (uint256[2] memory) {
549       require((cp1Witness[0] - sp2Witness[0]) % FIELD_SIZE != 0,
550               "points in sum must be distinct");
551       require(ecmulVerify(p1, c, cp1Witness), "First multiplication check failed");
552       require(ecmulVerify(p2, s, sp2Witness), "Second multiplication check failed");
553       return affineECAdd(cp1Witness, sp2Witness, zInv);
554     }
555 
556   // Domain-separation tag for the hash taken in scalarFromCurvePoints.
557   // Corresponds to scalarFromCurveHashPrefix in vrf.go
558   uint256 constant SCALAR_FROM_CURVE_POINTS_HASH_PREFIX = 2;
559 
560   // Pseudo-random number from inputs. Matches vrf.go/scalarFromCurvePoints, and
561   // https://datatracker.ietf.org/doc/html/draft-irtf-cfrg-vrf-05#section-5.4.3
562   // The draft calls (in step 7, via the definition of string_to_int, in
563   // https://datatracker.ietf.org/doc/html/rfc8017#section-4.2 ) for taking the
564   // first hash without checking that it corresponds to a number less than the
565   // group order, which will lead to a slight bias in the sample.
566   //
567   // TODO(alx): We could save a bit of gas by following the standard here and
568   // using the compressed representation of the points, if we collated the y
569   // parities into a single bytes32.
570   // https://www.pivotaltracker.com/story/show/171120588
571   function scalarFromCurvePoints(
572     uint256[2] memory hash, uint256[2] memory pk, uint256[2] memory gamma,
573     address uWitness, uint256[2] memory v)
574     internal pure returns (uint256 s) {
575       return uint256(
576         keccak256(abi.encodePacked(SCALAR_FROM_CURVE_POINTS_HASH_PREFIX,
577                                    hash, pk, gamma, v, uWitness)));
578     }
579 
580   // True if (gamma, c, s) is a correctly constructed randomness proof from pk
581   // and seed. zInv must be the inverse of the third ordinate from
582   // projectiveECAdd applied to cGammaWitness and sHashWitness. Corresponds to
583   // section 5.3 of the IETF draft.
584   //
585   // TODO(alx): Since I'm only using pk in the ecrecover call, I could only pass
586   // the x ordinate, and the parity of the y ordinate in the top bit of uWitness
587   // (which I could make a uint256 without using any extra space.) Would save
588   // about 2000 gas. https://www.pivotaltracker.com/story/show/170828567
589   function verifyVRFProof(
590     uint256[2] memory pk, uint256[2] memory gamma, uint256 c, uint256 s,
591     uint256 seed, address uWitness, uint256[2] memory cGammaWitness,
592     uint256[2] memory sHashWitness, uint256 zInv)
593     internal view {
594       require(isOnCurve(pk), "public key is not on curve");
595       require(isOnCurve(gamma), "gamma is not on curve");
596       require(isOnCurve(cGammaWitness), "cGammaWitness is not on curve");
597       require(isOnCurve(sHashWitness), "sHashWitness is not on curve");
598       // Step 5. of IETF draft section 5.3 (pk corresponds to 5.3's Y, and here
599       // we use the address of u instead of u itself. Also, here we add the
600       // terms instead of taking the difference, and in the proof consruction in
601       // vrf.GenerateProof, we correspondingly take the difference instead of
602       // taking the sum as they do in step 7 of section 5.1.)
603       require(
604         verifyLinearCombinationWithGenerator(c, pk, s, uWitness),
605         "addr(c*pk+s*g)≠_uWitness"
606       );
607       // Step 4. of IETF draft section 5.3 (pk corresponds to Y, seed to alpha_string)
608       uint256[2] memory hash = hashToCurve(pk, seed);
609       // Step 6. of IETF draft section 5.3, but see note for step 5 about +/- terms
610       uint256[2] memory v = linearCombination(
611         c, gamma, cGammaWitness, s, hash, sHashWitness, zInv);
612       // Steps 7. and 8. of IETF draft section 5.3
613       uint256 derivedC = scalarFromCurvePoints(hash, pk, gamma, uWitness, v);
614       require(c == derivedC, "invalid proof");
615     }
616 
617   // Domain-separation tag for the hash used as the final VRF output.
618   // Corresponds to vrfRandomOutputHashPrefix in vrf.go
619   uint256 constant VRF_RANDOM_OUTPUT_HASH_PREFIX = 3;
620 
621   // Length of proof marshaled to bytes array. Shows layout of proof
622   uint public constant PROOF_LENGTH = 64 + // PublicKey (uncompressed format.)
623     64 + // Gamma
624     32 + // C
625     32 + // S
626     32 + // Seed
627     0 + // Dummy entry: The following elements are included for gas efficiency:
628     32 + // uWitness (gets padded to 256 bits, even though it's only 160)
629     64 + // cGammaWitness
630     64 + // sHashWitness
631     32; // zInv  (Leave Output out, because that can be efficiently calculated)
632 
633   /* ***************************************************************************
634    * @notice Returns proof's output, if proof is valid. Otherwise reverts
635 
636    * @param proof A binary-encoded proof, as output by vrf.Proof.MarshalForSolidityVerifier
637    *
638    * Throws if proof is invalid, otherwise:
639    * @return output i.e., the random output implied by the proof
640    * ***************************************************************************
641    * @dev See the calculation of PROOF_LENGTH for the binary layout of proof.
642    */
643   function randomValueFromVRFProof(bytes memory proof)
644     internal view returns (uint256 output) {
645       require(proof.length == PROOF_LENGTH, "wrong proof length");
646 
647       uint256[2] memory pk; // parse proof contents into these variables
648       uint256[2] memory gamma;
649       // c, s and seed combined (prevents "stack too deep" compilation error)
650       uint256[3] memory cSSeed;
651       address uWitness;
652       uint256[2] memory cGammaWitness;
653       uint256[2] memory sHashWitness;
654       uint256 zInv;
655       (pk, gamma, cSSeed, uWitness, cGammaWitness, sHashWitness, zInv) = abi.decode(
656         proof, (uint256[2], uint256[2], uint256[3], address, uint256[2],
657                 uint256[2], uint256));
658       verifyVRFProof(
659         pk,
660         gamma,
661         cSSeed[0], // c
662         cSSeed[1], // s
663         cSSeed[2], // seed
664         uWitness,
665         cGammaWitness,
666         sHashWitness,
667         zInv
668       );
669       output = uint256(keccak256(abi.encode(VRF_RANDOM_OUTPUT_HASH_PREFIX, gamma)));
670     }
671 }
672 
673 // File: contracts/VRFRequestIDBase.sol
674 
675 pragma solidity ^0.6.0;
676 
677 contract VRFRequestIDBase {
678 
679   /**
680    * @notice returns the seed which is actually input to the VRF coordinator
681    *
682    * @dev To prevent repetition of VRF output due to repetition of the
683    * @dev user-supplied seed, that seed is combined in a hash with the
684    * @dev user-specific nonce, and the address of the consuming contract. The
685    * @dev risk of repetition is mostly mitigated by inclusion of a blockhash in
686    * @dev the final seed, but the nonce does protect against repetition in
687    * @dev requests which are included in a single block.
688    *
689    * @param _userSeed VRF seed input provided by user
690    * @param _requester Address of the requesting contract
691    * @param _nonce User-specific nonce at the time of the request
692    */
693   function makeVRFInputSeed(bytes32 _keyHash, uint256 _userSeed,
694     address _requester, uint256 _nonce)
695     internal pure returns (uint256)
696   {
697     return  uint256(keccak256(abi.encode(_keyHash, _userSeed, _requester, _nonce)));
698   }
699 
700   /**
701    * @notice Returns the id for this request
702    * @param _keyHash The serviceAgreement ID to be used for this request
703    * @param _vRFInputSeed The seed to be passed directly to the VRF
704    * @return The id for this request
705    *
706    * @dev Note that _vRFInputSeed is not the seed passed by the consuming
707    * @dev contract, but the one generated by makeVRFInputSeed
708    */
709   function makeRequestId(
710     bytes32 _keyHash, uint256 _vRFInputSeed) internal pure returns (bytes32) {
711     return keccak256(abi.encodePacked(_keyHash, _vRFInputSeed));
712   }
713 }
714 
715 // File: contracts/VRFConsumerBase.sol
716 
717 pragma solidity ^0.6.0;
718 
719 
720 
721 
722 /** ****************************************************************************
723  * @notice Interface for contracts using VRF randomness
724  * *****************************************************************************
725  * @dev PURPOSE
726  *
727  * @dev Reggie the Random Oracle (not his real job) wants to provide randomness
728  * @dev to Vera the verifier in such a way that Vera can be sure he's not
729  * @dev making his output up to suit himself. Reggie provides Vera a public key
730  * @dev to which he knows the secret key. Each time Vera provides a seed to
731  * @dev Reggie, he gives back a value which is computed completely
732  * @dev deterministically from the seed and the secret key.
733  *
734  * @dev Reggie provides a proof by which Vera can verify that the output was
735  * @dev correctly computed once Reggie tells it to her, but without that proof,
736  * @dev the output is indistinguishable to her from a uniform random sample
737  * @dev from the output space.
738  *
739  * @dev The purpose of this contract is to make it easy for unrelated contracts
740  * @dev to talk to Vera the verifier about the work Reggie is doing, to provide
741  * @dev simple access to a verifiable source of randomness.
742  * *****************************************************************************
743  * @dev USAGE
744  *
745  * @dev Calling contracts must inherit from VRFConsumerInterface, and can
746  * @dev initialize VRFConsumerInterface's attributes in their constructor as
747  * @dev shown:
748  *
749  * @dev   contract VRFConsumer {
750  * @dev     constuctor(<other arguments>, address _vrfCoordinator, address _link)
751  * @dev       VRFConsumerBase(_vrfCoordinator, _link) public {
752  * @dev         <initialization with other arguments goes here>
753  * @dev       }
754  * @dev   }
755  *
756  * @dev The oracle will have given you an ID for the VRF keypair they have
757  * @dev committed to (let's call it keyHash), and have told you the minimum LINK
758  * @dev price for VRF service. Make sure your contract has sufficient LINK, and
759  * @dev call requestRandomness(keyHash, fee, seed), where seed is the input you
760  * @dev want to generate randomness from.
761  *
762  * @dev Once the VRFCoordinator has received and validated the oracle's response
763  * @dev to your request, it will call your contract's fulfillRandomness method.
764  *
765  * @dev The randomness argument to fulfillRandomness is the actual random value
766  * @dev generated from your seed.
767  *
768  * @dev The requestId argument is generated from the keyHash and the seed by
769  * @dev makeRequestId(keyHash, seed). If your contract could have concurrent
770  * @dev requests open, you can use the requestId to track which seed is
771  * @dev associated with which randomness. See VRFRequestIDBase.sol for more
772  * @dev details.
773  *
774  * @dev Colliding `requestId`s are cryptographically impossible as long as seeds
775  * @dev differ. (Which is critical to making unpredictable randomness! See the
776  * @dev next section.)
777  *
778  * *****************************************************************************
779  * @dev SECURITY CONSIDERATIONS
780  *
781  * @dev Since the ultimate input to the VRF is mixed with the block hash of the
782  * @dev block in which the request is made, user-provided seeds have no impact
783  * @dev on its economic security properties. They are only included for API
784  * @dev compatability with previous versions of this contract.
785  *
786  * @dev Since the block hash of the block which contains the requestRandomness()
787  * @dev call is mixed into the input to the VRF *last*, a sufficiently powerful
788  * @dev miner could, in principle, fork the blockchain to evict the block
789  * @dev containing the request, forcing the request to be included in a
790  * @dev different block with a different hash, and therefore a different input
791  * @dev to the VRF. However, such an attack would incur a substantial economic
792  * @dev cost. This cost scales with the number of blocks the VRF oracle waits
793  * @dev until it calls fulfillRandomness().
794  */
795 abstract contract VRFConsumerBase is VRFRequestIDBase {
796 
797   using SafeMath for uint256;
798 
799   /**
800    * @notice fulfillRandomness handles the VRF response. Your contract must
801    * @notice implement it.
802    *
803    * @dev The VRFCoordinator expects a calling contract to have a method with
804    * @dev this signature, and will trigger it once it has verified the proof
805    * @dev associated with the randomness (It is triggered via a call to
806    * @dev rawFulfillRandomness, below.)
807    *
808    * @param requestId The Id initially returned by requestRandomness
809    * @param randomness the VRF output
810    */
811   function fulfillRandomness(bytes32 requestId, uint256 randomness)
812     internal virtual;
813 
814   /**
815    * @notice requestRandomness initiates a request for VRF output given _seed
816    *
817    * @dev See "SECURITY CONSIDERATIONS" above for more information on _seed.
818    *
819    * @dev The fulfillRandomness method receives the output, once it's provided
820    * @dev by the Oracle, and verified by the vrfCoordinator.
821    *
822    * @dev The _keyHash must already be registered with the VRFCoordinator, and
823    * @dev the _fee must exceed the fee specified during registration of the
824    * @dev _keyHash.
825    *
826    * @param _keyHash ID of public key against which randomness is generated
827    * @param _fee The amount of LINK to send with the request
828    * @param _seed seed mixed into the input of the VRF
829    *
830    * @return requestId unique ID for this request
831    *
832    * @dev The returned requestId can be used to distinguish responses to *
833    * @dev concurrent requests. It is passed as the first argument to
834    * @dev fulfillRandomness.
835    */
836   function requestRandomness(bytes32 _keyHash, uint256 _fee, uint256 _seed)
837     public returns (bytes32 requestId)
838   {
839     LINK.transferAndCall(vrfCoordinator, _fee, abi.encode(_keyHash, _seed));
840     // This is the seed passed to VRFCoordinator. The oracle will mix this with
841     // the hash of the block containing this request to obtain the seed/input
842     // which is finally passed to the VRF cryptographic machinery.
843     uint256 vRFSeed  = makeVRFInputSeed(_keyHash, _seed, address(this), nonces[_keyHash]);
844     // nonces[_keyHash] must stay in sync with
845     // VRFCoordinator.nonces[_keyHash][this], which was incremented by the above
846     // successful LINK.transferAndCall (in VRFCoordinator.randomnessRequest).
847     // This provides protection against the user repeating their input
848     // seed, which would result in a predictable/duplicate output.
849     nonces[_keyHash] = nonces[_keyHash].add(1);
850     return makeRequestId(_keyHash, vRFSeed);
851   }
852 
853   LinkTokenInterface immutable internal LINK;
854   address immutable private vrfCoordinator;
855 
856   // Nonces for each VRF key from which randomness has been requested.
857   //
858   // Must stay in sync with VRFCoordinator[_keyHash][this]
859   mapping(bytes32 /* keyHash */ => uint256 /* nonce */) public nonces;
860   constructor(address _vrfCoordinator, address _link) public {
861     vrfCoordinator = _vrfCoordinator;
862     LINK = LinkTokenInterface(_link);
863   }
864 
865   // rawFulfillRandomness is called by VRFCoordinator when it receives a valid VRF
866   // proof. rawFulfillRandomness then calls fulfillRandomness, after validating
867   // the origin of the call
868   function rawFulfillRandomness(bytes32 requestId, uint256 randomness) external {
869     require(msg.sender == vrfCoordinator, "Only VRFCoordinator can fulfill");
870     fulfillRandomness(requestId, randomness);
871   }
872 }
873 
874 // File: contracts/VRFCoordinator.sol
875 
876 pragma solidity 0.6.6;
877 
878 
879 
880 
881 
882 
883 
884 /**
885  * @title VRFCoordinator coordinates on-chain verifiable-randomness requests
886  * @title with off-chain responses
887  */
888 contract VRFCoordinator is VRF, VRFRequestIDBase {
889 
890   using SafeMath for uint256;
891 
892   LinkTokenInterface internal LINK;
893   BlockHashStoreInterface internal blockHashStore;
894 
895   constructor(address _link, address _blockHashStore) public {
896     LINK = LinkTokenInterface(_link);
897     blockHashStore = BlockHashStoreInterface(_blockHashStore);
898   }
899 
900   struct Callback { // Tracks an ongoing request
901     address callbackContract; // Requesting contract, which will receive response
902     // Amount of LINK paid at request time. Total LINK = 1e9 * 1e18 < 2^96, so
903     // this representation is adequate, and saves a word of storage when this
904     // field follows the 160-bit callbackContract address.
905     uint96 randomnessFee;
906     // Commitment to seed passed to oracle by this contract, and the number of
907     // the block in which the request appeared. This is the keccak256 of the
908     // concatenation of those values. Storing this commitment saves a word of
909     // storage.
910     bytes32 seedAndBlockNum;
911   }
912 
913   struct ServiceAgreement { // Tracks oracle commitments to VRF service
914     address vRFOracle; // Oracle committing to respond with VRF service
915     uint96 fee; // Minimum payment for oracle response. Total LINK=1e9*1e18<2^96
916     bytes32 jobID; // ID of corresponding chainlink job in oracle's DB
917   }
918 
919   mapping(bytes32 /* (provingKey, seed) */ => Callback) public callbacks;
920   mapping(bytes32 /* provingKey */ => ServiceAgreement)
921     public serviceAgreements;
922   mapping(address /* oracle */ => uint256 /* LINK balance */)
923     public withdrawableTokens;
924   mapping(bytes32 /* provingKey */ => mapping(address /* consumer */ => uint256))
925     private nonces;
926 
927   // The oracle only needs the jobID to look up the VRF, but specifying public
928   // key as well prevents a malicious oracle from inducing VRF outputs from
929   // another oracle by reusing the jobID.
930   event RandomnessRequest(
931     bytes32 keyHash,
932     uint256 seed,
933     bytes32 indexed jobID,
934     address sender,
935     uint256 fee,
936     bytes32 requestID);
937 
938   event NewServiceAgreement(bytes32 keyHash, uint256 fee);
939 
940   event RandomnessRequestFulfilled(bytes32 requestId, uint256 output);
941 
942   /**
943    * @notice Commits calling address to serve randomness
944    * @param _fee minimum LINK payment required to serve randomness
945    * @param _oracle the address of the Chainlink node with the proving key and job
946    * @param _publicProvingKey public key used to prove randomness
947    * @param _jobID ID of the corresponding chainlink job in the oracle's db
948    */
949   function registerProvingKey(
950     uint256 _fee, address _oracle, uint256[2] calldata _publicProvingKey, bytes32 _jobID
951   )
952     external
953   {
954     bytes32 keyHash = hashOfKey(_publicProvingKey);
955     address oldVRFOracle = serviceAgreements[keyHash].vRFOracle;
956     require(oldVRFOracle == address(0), "please register a new key");
957     require(_oracle != address(0), "_oracle must not be 0x0");
958     serviceAgreements[keyHash].vRFOracle = _oracle;
959     serviceAgreements[keyHash].jobID = _jobID;
960     // Yes, this revert message doesn't fit in a word
961     require(_fee <= 1e9 ether,
962       "you can't charge more than all the LINK in the world, greedy");
963     serviceAgreements[keyHash].fee = uint96(_fee);
964     emit NewServiceAgreement(keyHash, _fee);
965   }
966 
967   /**
968    * @notice Called by LINK.transferAndCall, on successful LINK transfer
969    *
970    * @dev To invoke this, use the requestRandomness method in VRFConsumerBase.
971    *
972    * @dev The VRFCoordinator will call back to the calling contract when the
973    * @dev oracle responds, on the method fulfillRandomness. See
974    * @dev VRFConsumerBase.fulfilRandomness for its signature. Your consuming
975    * @dev contract should inherit from VRFConsumerBase, and implement
976    * @dev fulfilRandomness.
977    *
978    * @param _sender address: who sent the LINK (must be a contract)
979    * @param _fee amount of LINK sent
980    * @param _data abi-encoded call to randomnessRequest
981    */
982   function onTokenTransfer(address _sender, uint256 _fee, bytes memory _data)
983     public
984     onlyLINK
985   {
986     (bytes32 keyHash, uint256 seed) = abi.decode(_data, (bytes32, uint256));
987     randomnessRequest(keyHash, seed, _fee, _sender);
988   }
989 
990   /**
991    * @notice creates the chainlink request for randomness
992    *
993    * @param _keyHash ID of the VRF public key against which to generate output
994    * @param _consumerSeed Input to the VRF, from which randomness is generated
995    * @param _feePaid Amount of LINK sent with request. Must exceed fee for key
996    * @param _sender Requesting contract; to be called back with VRF output
997    *
998    * @dev _consumerSeed is mixed with key hash, sender address and nonce to
999    * @dev obtain preSeed, which is passed to VRF oracle, which mixes it with the
1000    * @dev hash of the block containing this request, to compute the final seed.
1001    *
1002    * @dev The requestId used to store the request data is constructed from the
1003    * @dev preSeed and keyHash.
1004    */
1005   function randomnessRequest(
1006     bytes32 _keyHash,
1007     uint256 _consumerSeed,
1008     uint256 _feePaid,
1009     address _sender
1010   )
1011     internal
1012     sufficientLINK(_feePaid, _keyHash)
1013   {
1014     uint256 nonce = nonces[_keyHash][_sender];
1015     uint256 preSeed = makeVRFInputSeed(_keyHash, _consumerSeed, _sender, nonce);
1016     bytes32 requestId = makeRequestId(_keyHash, preSeed);
1017     // Cryptographically guaranteed by preSeed including an increasing nonce
1018     assert(callbacks[requestId].callbackContract == address(0));
1019     callbacks[requestId].callbackContract = _sender;
1020     assert(_feePaid < 1e27); // Total LINK fits in uint96
1021     callbacks[requestId].randomnessFee = uint96(_feePaid);
1022     callbacks[requestId].seedAndBlockNum = keccak256(abi.encodePacked(
1023       preSeed, block.number));
1024     emit RandomnessRequest(_keyHash, preSeed, serviceAgreements[_keyHash].jobID,
1025       _sender, _feePaid, requestId);
1026     nonces[_keyHash][_sender] = nonces[_keyHash][_sender].add(1);
1027   }
1028 
1029   // Offsets into fulfillRandomnessRequest's _proof of various values
1030   //
1031   // Public key. Skips byte array's length prefix.
1032   uint256 public constant PUBLIC_KEY_OFFSET = 0x20;
1033   // Seed is 7th word in proof, plus word for length, (6+1)*0x20=0xe0
1034   uint256 public constant PRESEED_OFFSET = 0xe0;
1035 
1036   /**
1037    * @notice Called by the chainlink node to fulfill requests
1038    *
1039    * @param _proof the proof of randomness. Actual random output built from this
1040    *
1041    * @dev The structure of _proof corresponds to vrf.MarshaledOnChainResponse,
1042    * @dev in the node source code. I.e., it is a vrf.MarshaledProof with the
1043    * @dev seed replaced by the preSeed, followed by the hash of the requesting
1044    * @dev block.
1045    */
1046   function fulfillRandomnessRequest(bytes memory _proof) public {
1047     (bytes32 currentKeyHash, Callback memory callback, bytes32 requestId,
1048      uint256 randomness) = getRandomnessFromProof(_proof);
1049 
1050     // Pay oracle
1051     address oadd = serviceAgreements[currentKeyHash].vRFOracle;
1052     withdrawableTokens[oadd] = withdrawableTokens[oadd].add(
1053       callback.randomnessFee);
1054 
1055     // Forget request. Must precede callback (prevents reentrancy)
1056     delete callbacks[requestId];
1057     callBackWithRandomness(requestId, randomness, callback.callbackContract);
1058 
1059     emit RandomnessRequestFulfilled(requestId, randomness);
1060   }
1061 
1062   function callBackWithRandomness(bytes32 requestId, uint256 randomness,
1063     address consumerContract) internal {
1064     // Dummy variable; allows access to method selector in next line. See
1065     // https://github.com/ethereum/solidity/issues/3506#issuecomment-553727797
1066     VRFConsumerBase v;
1067     bytes memory resp = abi.encodeWithSelector(
1068       v.rawFulfillRandomness.selector, requestId, randomness);
1069     // The bound b here comes from https://eips.ethereum.org/EIPS/eip-150. The
1070     // actual gas available to the consuming contract will be b-floor(b/64).
1071     // This is chosen to leave the consuming contract ~200k gas, after the cost
1072     // of the call itself.
1073     uint256 b = 206000;
1074     require(gasleft() >= b, "not enough gas for consumer");
1075     // A low-level call is necessary, here, because we don't want the consuming
1076     // contract to be able to revert this execution, and thus deny the oracle
1077     // payment for a valid randomness response. This also necessitates the above
1078     // check on the gasleft, as otherwise there would be no indication if the
1079     // callback method ran out of gas.
1080     //
1081     // solhint-disable-next-line avoid-low-level-calls
1082     (bool success,) = consumerContract.call(resp);
1083     // Avoid unused-local-variable warning. (success is only present to prevent
1084     // a warning that the return value of consumerContract.call is unused.)
1085     (success);
1086   }
1087 
1088   function getRandomnessFromProof(bytes memory _proof)
1089     internal view returns (bytes32 currentKeyHash, Callback memory callback,
1090       bytes32 requestId, uint256 randomness) {
1091     // blockNum follows proof, which follows length word (only direct-number
1092     // constants are allowed in assembly, so have to compute this in code)
1093     uint256 BLOCKNUM_OFFSET = 0x20 + PROOF_LENGTH;
1094     // _proof.length skips the initial length word, so not including the
1095     // blocknum in this length check balances out.
1096     require(_proof.length == BLOCKNUM_OFFSET, "wrong proof length");
1097     uint256[2] memory publicKey;
1098     uint256 preSeed;
1099     uint256 blockNum;
1100     assembly { // solhint-disable-line no-inline-assembly
1101       publicKey := add(_proof, PUBLIC_KEY_OFFSET)
1102       preSeed := mload(add(_proof, PRESEED_OFFSET))
1103       blockNum := mload(add(_proof, BLOCKNUM_OFFSET))
1104     }
1105     currentKeyHash = hashOfKey(publicKey);
1106     requestId = makeRequestId(currentKeyHash, preSeed);
1107     callback = callbacks[requestId];
1108     require(callback.callbackContract != address(0), "no corresponding request");
1109     require(callback.seedAndBlockNum == keccak256(abi.encodePacked(preSeed,
1110       blockNum)), "wrong preSeed or block num");
1111 
1112     bytes32 blockHash = blockhash(blockNum);
1113     if (blockHash == bytes32(0)) {
1114       blockHash = blockHashStore.getBlockhash(blockNum);
1115       require(blockHash != bytes32(0), "please prove blockhash");
1116     }
1117     // The seed actually used by the VRF machinery, mixing in the blockhash
1118     uint256 actualSeed = uint256(keccak256(abi.encodePacked(preSeed, blockHash)));
1119     // solhint-disable-next-line no-inline-assembly
1120     assembly { // Construct the actual proof from the remains of _proof
1121       mstore(add(_proof, PRESEED_OFFSET), actualSeed)
1122       mstore(_proof, PROOF_LENGTH)
1123     }
1124     randomness = VRF.randomValueFromVRFProof(_proof); // Reverts on failure
1125   }
1126 
1127   /**
1128    * @dev Allows the oracle operator to withdraw their LINK
1129    * @param _recipient is the address the funds will be sent to
1130    * @param _amount is the amount of LINK transferred from the Coordinator contract
1131    */
1132   function withdraw(address _recipient, uint256 _amount)
1133     external
1134     hasAvailableFunds(_amount)
1135   {
1136     withdrawableTokens[msg.sender] = withdrawableTokens[msg.sender].sub(_amount);
1137     assert(LINK.transfer(_recipient, _amount));
1138   }
1139 
1140   /**
1141    * @notice Returns the serviceAgreements key associated with this public key
1142    * @param _publicKey the key to return the address for
1143    */
1144   function hashOfKey(uint256[2] memory _publicKey) public pure returns (bytes32) {
1145     return keccak256(abi.encodePacked(_publicKey));
1146   }
1147 
1148   /**
1149    * @dev Reverts if amount is not at least what was agreed upon in the service agreement
1150    * @param _feePaid The payment for the request
1151    * @param _keyHash The key which the request is for
1152    */
1153   modifier sufficientLINK(uint256 _feePaid, bytes32 _keyHash) {
1154     require(_feePaid >= serviceAgreements[_keyHash].fee, "Below agreed payment");
1155     _;
1156   }
1157 
1158 /**
1159    * @dev Reverts if not sent from the LINK token
1160    */
1161   modifier onlyLINK() {
1162     require(msg.sender == address(LINK), "Must use LINK token");
1163     _;
1164   }
1165 
1166   /**
1167    * @dev Reverts if amount requested is greater than withdrawable balance
1168    * @param _amount The given amount to compare to `withdrawableTokens`
1169    */
1170   modifier hasAvailableFunds(uint256 _amount) {
1171     require(withdrawableTokens[msg.sender] >= _amount, "can't withdraw more than balance");
1172     _;
1173   }
1174 
1175 }