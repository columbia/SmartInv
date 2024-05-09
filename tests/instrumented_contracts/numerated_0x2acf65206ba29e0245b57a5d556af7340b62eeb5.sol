1 /*
2 B.PROTOCOL TERMS OF USE
3 =======================
4 
5 THE TERMS OF USE CONTAINED HEREIN (THESE “TERMS”) GOVERN YOUR USE OF B.PROTOCOL, WHICH IS A DECENTRALIZED PROTOCOL ON THE ETHEREUM BLOCKCHAIN (the “PROTOCOL”) THAT enables a backstop liquidity mechanism FOR DECENTRALIZED LENDING PLATFORMS (“DLPs”).  
6 PLEASE READ THESE TERMS CAREFULLY AT https://github.com/backstop-protocol/Terms-and-Conditions, INCLUDING ALL DISCLAIMERS AND RISK FACTORS, BEFORE USING THE PROTOCOL. BY USING THE PROTOCOL, YOU ARE IRREVOCABLY CONSENTING TO BE BOUND BY THESE TERMS. 
7 IF YOU DO NOT AGREE TO ALL OF THESE TERMS, DO NOT USE THE PROTOCOL. YOUR RIGHT TO USE THE PROTOCOL IS SUBJECT AND DEPENDENT BY YOUR AGREEMENT TO ALL TERMS AND CONDITIONS SET FORTH HEREIN, WHICH AGREEMENT SHALL BE EVIDENCED BY YOUR USE OF THE PROTOCOL.
8 Minors Prohibited: The Protocol is not directed to individuals under the age of eighteen (18) or the age of majority in your jurisdiction if the age of majority is greater. If you are under the age of eighteen or the age of majority (if greater), you are not authorized to access or use the Protocol. By using the Protocol, you represent and warrant that you are above such age.
9 
10 License; No Warranties; Limitation of Liability;
11 (a) The software underlying the Protocol is licensed for use in accordance with the 3-clause BSD License, which can be accessed here: https://opensource.org/licenses/BSD-3-Clause.
12 (b) THE PROTOCOL IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS", “WITH ALL FAULTS” and “AS AVAILABLE” AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. 
13 (c) IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. 
14 */
15 // File: contracts/bprotocol/interfaces/IRegistry.sol
16 
17 pragma solidity 0.5.16;
18 
19 
20 interface IRegistry {
21 
22     // Ownable
23     function transferOwnership(address newOwner) external;
24 
25     // Compound contracts
26     function comp() external view returns (address);
27     function comptroller() external view returns (address);
28     function cEther() external view returns (address);
29 
30     // B.Protocol contracts
31     function bComptroller() external view returns (address);
32     function score() external view returns (address);
33     function pool() external view returns (address);
34 
35     // Avatar functions
36     function delegate(address avatar, address delegatee) external view returns (bool);
37     function doesAvatarExist(address avatar) external view returns (bool);
38     function doesAvatarExistFor(address owner) external view returns (bool);
39     function ownerOf(address avatar) external view returns (address);
40     function avatarOf(address owner) external view returns (address);
41     function newAvatar() external returns (address);
42     function getAvatar(address owner) external returns (address);
43     // avatar whitelisted calls
44     function whitelistedAvatarCalls(address target, bytes4 functionSig) external view returns(bool);
45 
46     function setPool(address newPool) external;
47     function setWhitelistAvatarCall(address target, bytes4 functionSig, bool list) external;
48 }
49 
50 // File: contracts/bprotocol/interfaces/IAvatar.sol
51 
52 pragma solidity 0.5.16;
53 
54 contract IAvatarERC20 {
55     function transfer(address cToken, address dst, uint256 amount) external returns (bool);
56     function transferFrom(address cToken, address src, address dst, uint256 amount) external returns (bool);
57     function approve(address cToken, address spender, uint256 amount) public returns (bool);
58 }
59 
60 contract IAvatar is IAvatarERC20 {
61     function initialize(address _registry, address comp, address compVoter) external;
62     function quit() external returns (bool);
63     function canUntop() public returns (bool);
64     function toppedUpCToken() external returns (address);
65     function toppedUpAmount() external returns (uint256);
66     function redeem(address cToken, uint256 redeemTokens, address payable userOrDelegatee) external returns (uint256);
67     function redeemUnderlying(address cToken, uint256 redeemAmount, address payable userOrDelegatee) external returns (uint256);
68     function borrow(address cToken, uint256 borrowAmount, address payable userOrDelegatee) external returns (uint256);
69     function borrowBalanceCurrent(address cToken) external returns (uint256);
70     function collectCToken(address cToken, address from, uint256 cTokenAmt) public;
71     function liquidateBorrow(uint repayAmount, address cTokenCollateral) external payable returns (uint256);
72 
73     // Comptroller functions
74     function enterMarket(address cToken) external returns (uint256);
75     function enterMarkets(address[] calldata cTokens) external returns (uint256[] memory);
76     function exitMarket(address cToken) external returns (uint256);
77     function claimComp() external;
78     function claimComp(address[] calldata bTokens) external;
79     function claimComp(address[] calldata bTokens, bool borrowers, bool suppliers) external;
80     function getAccountLiquidity() external view returns (uint err, uint liquidity, uint shortFall);
81 }
82 
83 // Workaround for issue https://github.com/ethereum/solidity/issues/526
84 // CEther
85 contract IAvatarCEther is IAvatar {
86     function mint() external payable;
87     function repayBorrow() external payable;
88     function repayBorrowBehalf(address borrower) external payable;
89 }
90 
91 // CErc20
92 contract IAvatarCErc20 is IAvatar {
93     function mint(address cToken, uint256 mintAmount) external returns (uint256);
94     function repayBorrow(address cToken, uint256 repayAmount) external returns (uint256);
95     function repayBorrowBehalf(address cToken, address borrower, uint256 repayAmount) external returns (uint256);
96 }
97 
98 contract ICushion {
99     function liquidateBorrow(uint256 underlyingAmtToLiquidate, uint256 amtToDeductFromTopup, address cTokenCollateral) external payable returns (uint256);    
100     function canLiquidate() external returns (bool);
101     function untop(uint amount) external;
102     function toppedUpAmount() external returns (uint);
103     function remainingLiquidationAmount() external returns(uint);
104     function getMaxLiquidationAmount(address debtCToken) public returns (uint256);
105 }
106 
107 contract ICushionCErc20 is ICushion {
108     function topup(address cToken, uint256 topupAmount) external;
109 }
110 
111 contract ICushionCEther is ICushion {
112     function topup() external payable;
113 }
114 
115 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
116 
117 pragma solidity ^0.5.0;
118 
119 /**
120  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
121  * the optional functions; to access them see {ERC20Detailed}.
122  */
123 interface IERC20 {
124     /**
125      * @dev Returns the amount of tokens in existence.
126      */
127     function totalSupply() external view returns (uint256);
128 
129     /**
130      * @dev Returns the amount of tokens owned by `account`.
131      */
132     function balanceOf(address account) external view returns (uint256);
133 
134     /**
135      * @dev Moves `amount` tokens from the caller's account to `recipient`.
136      *
137      * Returns a boolean value indicating whether the operation succeeded.
138      *
139      * Emits a {Transfer} event.
140      */
141     function transfer(address recipient, uint256 amount) external returns (bool);
142 
143     /**
144      * @dev Returns the remaining number of tokens that `spender` will be
145      * allowed to spend on behalf of `owner` through {transferFrom}. This is
146      * zero by default.
147      *
148      * This value changes when {approve} or {transferFrom} are called.
149      */
150     function allowance(address owner, address spender) external view returns (uint256);
151 
152     /**
153      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
154      *
155      * Returns a boolean value indicating whether the operation succeeded.
156      *
157      * IMPORTANT: Beware that changing an allowance with this method brings the risk
158      * that someone may use both the old and the new allowance by unfortunate
159      * transaction ordering. One possible solution to mitigate this race
160      * condition is to first reduce the spender's allowance to 0 and set the
161      * desired value afterwards:
162      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
163      *
164      * Emits an {Approval} event.
165      */
166     function approve(address spender, uint256 amount) external returns (bool);
167 
168     /**
169      * @dev Moves `amount` tokens from `sender` to `recipient` using the
170      * allowance mechanism. `amount` is then deducted from the caller's
171      * allowance.
172      *
173      * Returns a boolean value indicating whether the operation succeeded.
174      *
175      * Emits a {Transfer} event.
176      */
177     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
178 
179     /**
180      * @dev Emitted when `value` tokens are moved from one account (`from`) to
181      * another (`to`).
182      *
183      * Note that `value` may be zero.
184      */
185     event Transfer(address indexed from, address indexed to, uint256 value);
186 
187     /**
188      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
189      * a call to {approve}. `value` is the new allowance.
190      */
191     event Approval(address indexed owner, address indexed spender, uint256 value);
192 }
193 
194 // File: contracts/bprotocol/interfaces/CTokenInterfaces.sol
195 
196 pragma solidity 0.5.16;
197 
198 
199 contract CTokenInterface {
200     /* ERC20 */
201     function transfer(address dst, uint amount) external returns (bool);
202     function transferFrom(address src, address dst, uint amount) external returns (bool);
203     function approve(address spender, uint amount) external returns (bool);
204     function allowance(address owner, address spender) external view returns (uint);
205     function balanceOf(address owner) external view returns (uint);
206     function totalSupply() external view returns (uint256);
207     function name() external view returns (string memory);
208     function symbol() external view returns (string memory);
209     function decimals() external view returns (uint8);
210 
211     /* User Interface */
212     function isCToken() external view returns (bool);
213     function underlying() external view returns (IERC20);
214     function balanceOfUnderlying(address owner) external returns (uint);
215     function getAccountSnapshot(address account) external view returns (uint, uint, uint, uint);
216     function borrowRatePerBlock() external view returns (uint);
217     function supplyRatePerBlock() external view returns (uint);
218     function totalBorrowsCurrent() external returns (uint);
219     function borrowBalanceCurrent(address account) external returns (uint);
220     function borrowBalanceStored(address account) public view returns (uint);
221     function exchangeRateCurrent() public returns (uint);
222     function exchangeRateStored() public view returns (uint);
223     function getCash() external view returns (uint);
224     function accrueInterest() public returns (uint);
225     function seize(address liquidator, address borrower, uint seizeTokens) external returns (uint);
226 
227 }
228 
229 contract ICToken is CTokenInterface {
230 
231     /* User Interface */
232     function redeem(uint redeemTokens) external returns (uint);
233     function redeemUnderlying(uint redeemAmount) external returns (uint);
234     function borrow(uint borrowAmount) external returns (uint);
235 }
236 
237 // Workaround for issue https://github.com/ethereum/solidity/issues/526
238 // Defined separate contract as `mint()` override with `.value()` has issues
239 contract ICErc20 is ICToken {
240     function mint(uint mintAmount) external returns (uint);
241     function repayBorrow(uint repayAmount) external returns (uint);
242     function repayBorrowBehalf(address borrower, uint repayAmount) external returns (uint);
243     function liquidateBorrow(address borrower, uint repayAmount, address cTokenCollateral) external returns (uint);
244 }
245 
246 contract ICEther is ICToken {
247     function mint() external payable;
248     function repayBorrow() external payable;
249     function repayBorrowBehalf(address borrower) external payable;
250     function liquidateBorrow(address borrower, address cTokenCollateral) external payable;
251 }
252 
253 contract IPriceOracle {
254     /**
255       * @notice Get the underlying price of a cToken asset
256       * @param cToken The cToken to get the underlying price of
257       * @return The underlying asset price mantissa (scaled by 1e18).
258       *  Zero means the price is unavailable.
259       */
260     function getUnderlyingPrice(CTokenInterface cToken) external view returns (uint);
261 }
262 
263 // File: contracts/bprotocol/lib/CarefulMath.sol
264 
265 pragma solidity 0.5.16;
266 
267 /**
268   * @title Careful Math
269   * @author Compound
270   * @notice COPY TAKEN FROM COMPOUND FINANCE
271   * @notice Derived from OpenZeppelin's SafeMath library
272   *         https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol
273   */
274 contract CarefulMath {
275 
276     /**
277      * @dev Possible error codes that we can return
278      */
279     enum MathError {
280         NO_ERROR,
281         DIVISION_BY_ZERO,
282         INTEGER_OVERFLOW,
283         INTEGER_UNDERFLOW
284     }
285 
286     /**
287     * @dev Multiplies two numbers, returns an error on overflow.
288     */
289     function mulUInt(uint a, uint b) internal pure returns (MathError, uint) {
290         if (a == 0) {
291             return (MathError.NO_ERROR, 0);
292         }
293 
294         uint c = a * b;
295 
296         if (c / a != b) {
297             return (MathError.INTEGER_OVERFLOW, 0);
298         } else {
299             return (MathError.NO_ERROR, c);
300         }
301     }
302 
303     /**
304     * @dev Integer division of two numbers, truncating the quotient.
305     */
306     function divUInt(uint a, uint b) internal pure returns (MathError, uint) {
307         if (b == 0) {
308             return (MathError.DIVISION_BY_ZERO, 0);
309         }
310 
311         return (MathError.NO_ERROR, a / b);
312     }
313 
314     /**
315     * @dev Subtracts two numbers, returns an error on overflow (i.e. if subtrahend is greater than minuend).
316     */
317     function subUInt(uint a, uint b) internal pure returns (MathError, uint) {
318         if (b <= a) {
319             return (MathError.NO_ERROR, a - b);
320         } else {
321             return (MathError.INTEGER_UNDERFLOW, 0);
322         }
323     }
324 
325     /**
326     * @dev Adds two numbers, returns an error on overflow.
327     */
328     function addUInt(uint a, uint b) internal pure returns (MathError, uint) {
329         uint c = a + b;
330 
331         if (c >= a) {
332             return (MathError.NO_ERROR, c);
333         } else {
334             return (MathError.INTEGER_OVERFLOW, 0);
335         }
336     }
337 
338     /**
339     * @dev add a and b and then subtract c
340     */
341     function addThenSubUInt(uint a, uint b, uint c) internal pure returns (MathError, uint) {
342         (MathError err0, uint sum) = addUInt(a, b);
343 
344         if (err0 != MathError.NO_ERROR) {
345             return (err0, 0);
346         }
347 
348         return subUInt(sum, c);
349     }
350 }
351 
352 // File: contracts/bprotocol/lib/Exponential.sol
353 
354 pragma solidity 0.5.16;
355 
356 
357 /**
358  * @title Exponential module for storing fixed-precision decimals
359  * @author Compound
360  * @notice Exp is a struct which stores decimals with a fixed precision of 18 decimal places.
361  *         Thus, if we wanted to store the 5.1, mantissa would store 5.1e18. That is:
362  *         `Exp({mantissa: 5100000000000000000})`.
363  */
364 contract Exponential is CarefulMath {
365     uint constant expScale = 1e18;
366     uint constant doubleScale = 1e36;
367     uint constant halfExpScale = expScale/2;
368     uint constant mantissaOne = expScale;
369 
370     struct Exp {
371         uint mantissa;
372     }
373 
374     struct Double {
375         uint mantissa;
376     }
377 
378     /**
379      * @dev Creates an exponential from numerator and denominator values.
380      *      Note: Returns an error if (`num` * 10e18) > MAX_INT,
381      *            or if `denom` is zero.
382      */
383     function getExp(uint num, uint denom) pure internal returns (MathError, Exp memory) {
384         (MathError err0, uint scaledNumerator) = mulUInt(num, expScale);
385         if (err0 != MathError.NO_ERROR) {
386             return (err0, Exp({mantissa: 0}));
387         }
388 
389         (MathError err1, uint rational) = divUInt(scaledNumerator, denom);
390         if (err1 != MathError.NO_ERROR) {
391             return (err1, Exp({mantissa: 0}));
392         }
393 
394         return (MathError.NO_ERROR, Exp({mantissa: rational}));
395     }
396 
397     /**
398      * @dev Multiply an Exp by a scalar, returning a new Exp.
399      */
400     function mulScalar(Exp memory a, uint scalar) pure internal returns (MathError, Exp memory) {
401         (MathError err0, uint scaledMantissa) = mulUInt(a.mantissa, scalar);
402         if (err0 != MathError.NO_ERROR) {
403             return (err0, Exp({mantissa: 0}));
404         }
405 
406         return (MathError.NO_ERROR, Exp({mantissa: scaledMantissa}));
407     }
408 
409     /**
410      * @dev Multiply an Exp by a scalar, then truncate to return an unsigned integer.
411      */
412     function mulScalarTruncate(Exp memory a, uint scalar) pure internal returns (MathError, uint) {
413         (MathError err, Exp memory product) = mulScalar(a, scalar);
414         if (err != MathError.NO_ERROR) {
415             return (err, 0);
416         }
417 
418         return (MathError.NO_ERROR, truncate(product));
419     }
420 
421     /**
422      * @dev Divide a scalar by an Exp, returning a new Exp.
423      */
424     function divScalarByExp(uint scalar, Exp memory divisor) pure internal returns (MathError, Exp memory) {
425         /*
426           We are doing this as:
427           getExp(mulUInt(expScale, scalar), divisor.mantissa)
428 
429           How it works:
430           Exp = a / b;
431           Scalar = s;
432           `s / (a / b)` = `b * s / a` and since for an Exp `a = mantissa, b = expScale`
433         */
434         (MathError err0, uint numerator) = mulUInt(expScale, scalar);
435         if (err0 != MathError.NO_ERROR) {
436             return (err0, Exp({mantissa: 0}));
437         }
438         return getExp(numerator, divisor.mantissa);
439     }
440 
441     /**
442      * @dev Multiplies two exponentials, returning a new exponential.
443      */
444     function mulExp(Exp memory a, Exp memory b) pure internal returns (MathError, Exp memory) {
445 
446         (MathError err0, uint doubleScaledProduct) = mulUInt(a.mantissa, b.mantissa);
447         if (err0 != MathError.NO_ERROR) {
448             return (err0, Exp({mantissa: 0}));
449         }
450 
451         // We add half the scale before dividing so that we get rounding instead of truncation.
452         //  See "Listing 6" and text above it at https://accu.org/index.php/journals/1717
453         // Without this change, a result like 6.6...e-19 will be truncated to 0 instead of being rounded to 1e-18.
454         (MathError err1, uint doubleScaledProductWithHalfScale) = addUInt(halfExpScale, doubleScaledProduct);
455         if (err1 != MathError.NO_ERROR) {
456             return (err1, Exp({mantissa: 0}));
457         }
458 
459         (MathError err2, uint product) = divUInt(doubleScaledProductWithHalfScale, expScale);
460         // The only error `div` can return is MathError.DIVISION_BY_ZERO but we control `expScale` and it is not zero.
461         assert(err2 == MathError.NO_ERROR);
462 
463         return (MathError.NO_ERROR, Exp({mantissa: product}));
464     }
465 
466     /**
467      * @dev Multiplies two exponentials given their mantissas, returning a new exponential.
468      */
469     function mulExp(uint a, uint b) pure internal returns (MathError, Exp memory) {
470         return mulExp(Exp({mantissa: a}), Exp({mantissa: b}));
471     }
472 
473 
474     /**
475      * @dev Divides two exponentials, returning a new exponential.
476      *     (a/scale) / (b/scale) = (a/scale) * (scale/b) = a/b,
477      *  which we can scale as an Exp by calling getExp(a.mantissa, b.mantissa)
478      */
479     function divExp(Exp memory a, Exp memory b) pure internal returns (MathError, Exp memory) {
480         return getExp(a.mantissa, b.mantissa);
481     }
482 
483     /**
484      * @dev Truncates the given exp to a whole number value.
485      *      For example, truncate(Exp{mantissa: 15 * expScale}) = 15
486      */
487     function truncate(Exp memory exp) pure internal returns (uint) {
488         // Note: We are not using careful math here as we're performing a division that cannot fail
489         return exp.mantissa / expScale;
490     }
491 
492 
493     function safe224(uint n, string memory errorMessage) pure internal returns (uint224) {
494         require(n < 2**224, errorMessage);
495         return uint224(n);
496     }
497 
498     function add_(Exp memory a, Exp memory b) pure internal returns (Exp memory) {
499         return Exp({mantissa: add_(a.mantissa, b.mantissa)});
500     }
501 
502     function add_(Double memory a, Double memory b) pure internal returns (Double memory) {
503         return Double({mantissa: add_(a.mantissa, b.mantissa)});
504     }
505 
506     function add_(uint a, uint b) pure internal returns (uint) {
507         return add_(a, b, "addition overflow");
508     }
509 
510     function add_(uint a, uint b, string memory errorMessage) pure internal returns (uint) {
511         uint c = a + b;
512         require(c >= a, errorMessage);
513         return c;
514     }
515 
516     function sub_(Exp memory a, Exp memory b) pure internal returns (Exp memory) {
517         return Exp({mantissa: sub_(a.mantissa, b.mantissa)});
518     }
519 
520     function sub_(Double memory a, Double memory b) pure internal returns (Double memory) {
521         return Double({mantissa: sub_(a.mantissa, b.mantissa)});
522     }
523 
524     function sub_(uint a, uint b) pure internal returns (uint) {
525         return sub_(a, b, "subtraction underflow");
526     }
527 
528     function sub_(uint a, uint b, string memory errorMessage) pure internal returns (uint) {
529         require(b <= a, errorMessage);
530         return a - b;
531     }
532 
533     function mul_(Exp memory a, Exp memory b) pure internal returns (Exp memory) {
534         return Exp({mantissa: mul_(a.mantissa, b.mantissa) / expScale});
535     }
536 
537     function mul_(Exp memory a, uint b) pure internal returns (Exp memory) {
538         return Exp({mantissa: mul_(a.mantissa, b)});
539     }
540 
541     function mul_(uint a, Exp memory b) pure internal returns (uint) {
542         return mul_(a, b.mantissa) / expScale;
543     }
544 
545     function mul_(Double memory a, Double memory b) pure internal returns (Double memory) {
546         return Double({mantissa: mul_(a.mantissa, b.mantissa) / doubleScale});
547     }
548 
549     function mul_(Double memory a, uint b) pure internal returns (Double memory) {
550         return Double({mantissa: mul_(a.mantissa, b)});
551     }
552 
553     function mul_(uint a, Double memory b) pure internal returns (uint) {
554         return mul_(a, b.mantissa) / doubleScale;
555     }
556 
557     function mul_(uint a, uint b) pure internal returns (uint) {
558         return mul_(a, b, "multiplication overflow");
559     }
560 
561     function mul_(uint a, uint b, string memory errorMessage) pure internal returns (uint) {
562         if (a == 0 || b == 0) {
563             return 0;
564         }
565         uint c = a * b;
566         require(c / a == b, errorMessage);
567         return c;
568     }
569 
570     function div_(Exp memory a, Exp memory b) pure internal returns (Exp memory) {
571         return Exp({mantissa: div_(mul_(a.mantissa, expScale), b.mantissa)});
572     }
573 
574     function div_(Exp memory a, uint b) pure internal returns (Exp memory) {
575         return Exp({mantissa: div_(a.mantissa, b)});
576     }
577 
578     function div_(uint a, Exp memory b) pure internal returns (uint) {
579         return div_(mul_(a, expScale), b.mantissa);
580     }
581 
582     function div_(Double memory a, Double memory b) pure internal returns (Double memory) {
583         return Double({mantissa: div_(mul_(a.mantissa, doubleScale), b.mantissa)});
584     }
585 
586     function div_(Double memory a, uint b) pure internal returns (Double memory) {
587         return Double({mantissa: div_(a.mantissa, b)});
588     }
589 
590     function div_(uint a, Double memory b) pure internal returns (uint) {
591         return div_(mul_(a, doubleScale), b.mantissa);
592     }
593 
594     function div_(uint a, uint b) pure internal returns (uint) {
595         return div_(a, b, "divide by zero");
596     }
597 
598     function div_(uint a, uint b, string memory errorMessage) pure internal returns (uint) {
599         require(b > 0, errorMessage);
600         return a / b;
601     }
602 
603     function fraction(uint a, uint b) pure internal returns (Double memory) {
604         return Double({mantissa: div_(mul_(a, doubleScale), b)});
605     }
606 
607     // New functions added by BProtocol
608     // =================================
609 
610     function mulTrucate(uint a, uint b) internal pure returns (uint) {
611         return mul_(a, b) / expScale;
612     }
613 }
614 
615 // File: @openzeppelin/contracts/math/SafeMath.sol
616 
617 pragma solidity ^0.5.0;
618 
619 /**
620  * @dev Wrappers over Solidity's arithmetic operations with added overflow
621  * checks.
622  *
623  * Arithmetic operations in Solidity wrap on overflow. This can easily result
624  * in bugs, because programmers usually assume that an overflow raises an
625  * error, which is the standard behavior in high level programming languages.
626  * `SafeMath` restores this intuition by reverting the transaction when an
627  * operation overflows.
628  *
629  * Using this library instead of the unchecked operations eliminates an entire
630  * class of bugs, so it's recommended to use it always.
631  */
632 library SafeMath {
633     /**
634      * @dev Returns the addition of two unsigned integers, reverting on
635      * overflow.
636      *
637      * Counterpart to Solidity's `+` operator.
638      *
639      * Requirements:
640      * - Addition cannot overflow.
641      */
642     function add(uint256 a, uint256 b) internal pure returns (uint256) {
643         uint256 c = a + b;
644         require(c >= a, "SafeMath: addition overflow");
645 
646         return c;
647     }
648 
649     /**
650      * @dev Returns the subtraction of two unsigned integers, reverting on
651      * overflow (when the result is negative).
652      *
653      * Counterpart to Solidity's `-` operator.
654      *
655      * Requirements:
656      * - Subtraction cannot overflow.
657      */
658     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
659         return sub(a, b, "SafeMath: subtraction overflow");
660     }
661 
662     /**
663      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
664      * overflow (when the result is negative).
665      *
666      * Counterpart to Solidity's `-` operator.
667      *
668      * Requirements:
669      * - Subtraction cannot overflow.
670      *
671      * _Available since v2.4.0._
672      */
673     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
674         require(b <= a, errorMessage);
675         uint256 c = a - b;
676 
677         return c;
678     }
679 
680     /**
681      * @dev Returns the multiplication of two unsigned integers, reverting on
682      * overflow.
683      *
684      * Counterpart to Solidity's `*` operator.
685      *
686      * Requirements:
687      * - Multiplication cannot overflow.
688      */
689     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
690         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
691         // benefit is lost if 'b' is also tested.
692         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
693         if (a == 0) {
694             return 0;
695         }
696 
697         uint256 c = a * b;
698         require(c / a == b, "SafeMath: multiplication overflow");
699 
700         return c;
701     }
702 
703     /**
704      * @dev Returns the integer division of two unsigned integers. Reverts on
705      * division by zero. The result is rounded towards zero.
706      *
707      * Counterpart to Solidity's `/` operator. Note: this function uses a
708      * `revert` opcode (which leaves remaining gas untouched) while Solidity
709      * uses an invalid opcode to revert (consuming all remaining gas).
710      *
711      * Requirements:
712      * - The divisor cannot be zero.
713      */
714     function div(uint256 a, uint256 b) internal pure returns (uint256) {
715         return div(a, b, "SafeMath: division by zero");
716     }
717 
718     /**
719      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
720      * division by zero. The result is rounded towards zero.
721      *
722      * Counterpart to Solidity's `/` operator. Note: this function uses a
723      * `revert` opcode (which leaves remaining gas untouched) while Solidity
724      * uses an invalid opcode to revert (consuming all remaining gas).
725      *
726      * Requirements:
727      * - The divisor cannot be zero.
728      *
729      * _Available since v2.4.0._
730      */
731     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
732         // Solidity only automatically asserts when dividing by 0
733         require(b > 0, errorMessage);
734         uint256 c = a / b;
735         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
736 
737         return c;
738     }
739 
740     /**
741      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
742      * Reverts when dividing by zero.
743      *
744      * Counterpart to Solidity's `%` operator. This function uses a `revert`
745      * opcode (which leaves remaining gas untouched) while Solidity uses an
746      * invalid opcode to revert (consuming all remaining gas).
747      *
748      * Requirements:
749      * - The divisor cannot be zero.
750      */
751     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
752         return mod(a, b, "SafeMath: modulo by zero");
753     }
754 
755     /**
756      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
757      * Reverts with custom message when dividing by zero.
758      *
759      * Counterpart to Solidity's `%` operator. This function uses a `revert`
760      * opcode (which leaves remaining gas untouched) while Solidity uses an
761      * invalid opcode to revert (consuming all remaining gas).
762      *
763      * Requirements:
764      * - The divisor cannot be zero.
765      *
766      * _Available since v2.4.0._
767      */
768     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
769         require(b != 0, errorMessage);
770         return a % b;
771     }
772 }
773 
774 // File: @openzeppelin/contracts/utils/Address.sol
775 
776 pragma solidity ^0.5.5;
777 
778 /**
779  * @dev Collection of functions related to the address type
780  */
781 library Address {
782     /**
783      * @dev Returns true if `account` is a contract.
784      *
785      * [IMPORTANT]
786      * ====
787      * It is unsafe to assume that an address for which this function returns
788      * false is an externally-owned account (EOA) and not a contract.
789      *
790      * Among others, `isContract` will return false for the following 
791      * types of addresses:
792      *
793      *  - an externally-owned account
794      *  - a contract in construction
795      *  - an address where a contract will be created
796      *  - an address where a contract lived, but was destroyed
797      * ====
798      */
799     function isContract(address account) internal view returns (bool) {
800         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
801         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
802         // for accounts without code, i.e. `keccak256('')`
803         bytes32 codehash;
804         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
805         // solhint-disable-next-line no-inline-assembly
806         assembly { codehash := extcodehash(account) }
807         return (codehash != accountHash && codehash != 0x0);
808     }
809 
810     /**
811      * @dev Converts an `address` into `address payable`. Note that this is
812      * simply a type cast: the actual underlying value is not changed.
813      *
814      * _Available since v2.4.0._
815      */
816     function toPayable(address account) internal pure returns (address payable) {
817         return address(uint160(account));
818     }
819 
820     /**
821      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
822      * `recipient`, forwarding all available gas and reverting on errors.
823      *
824      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
825      * of certain opcodes, possibly making contracts go over the 2300 gas limit
826      * imposed by `transfer`, making them unable to receive funds via
827      * `transfer`. {sendValue} removes this limitation.
828      *
829      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
830      *
831      * IMPORTANT: because control is transferred to `recipient`, care must be
832      * taken to not create reentrancy vulnerabilities. Consider using
833      * {ReentrancyGuard} or the
834      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
835      *
836      * _Available since v2.4.0._
837      */
838     function sendValue(address payable recipient, uint256 amount) internal {
839         require(address(this).balance >= amount, "Address: insufficient balance");
840 
841         // solhint-disable-next-line avoid-call-value
842         (bool success, ) = recipient.call.value(amount)("");
843         require(success, "Address: unable to send value, recipient may have reverted");
844     }
845 }
846 
847 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
848 
849 pragma solidity ^0.5.0;
850 
851 
852 
853 
854 /**
855  * @title SafeERC20
856  * @dev Wrappers around ERC20 operations that throw on failure (when the token
857  * contract returns false). Tokens that return no value (and instead revert or
858  * throw on failure) are also supported, non-reverting calls are assumed to be
859  * successful.
860  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
861  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
862  */
863 library SafeERC20 {
864     using SafeMath for uint256;
865     using Address for address;
866 
867     function safeTransfer(IERC20 token, address to, uint256 value) internal {
868         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
869     }
870 
871     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
872         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
873     }
874 
875     function safeApprove(IERC20 token, address spender, uint256 value) internal {
876         // safeApprove should only be called when setting an initial allowance,
877         // or when resetting it to zero. To increase and decrease it, use
878         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
879         // solhint-disable-next-line max-line-length
880         require((value == 0) || (token.allowance(address(this), spender) == 0),
881             "SafeERC20: approve from non-zero to non-zero allowance"
882         );
883         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
884     }
885 
886     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
887         uint256 newAllowance = token.allowance(address(this), spender).add(value);
888         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
889     }
890 
891     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
892         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
893         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
894     }
895 
896     /**
897      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
898      * on the return value: the return value is optional (but if data is returned, it must not be false).
899      * @param token The token targeted by the call.
900      * @param data The call data (encoded using abi.encode or one of its variants).
901      */
902     function callOptionalReturn(IERC20 token, bytes memory data) private {
903         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
904         // we're implementing it ourselves.
905 
906         // A Solidity high level call has three parts:
907         //  1. The target address is checked to verify it contains contract code
908         //  2. The call itself is made, and success asserted
909         //  3. The return value is decoded, which in turn checks the size of the returned data.
910         // solhint-disable-next-line max-line-length
911         require(address(token).isContract(), "SafeERC20: call to non-contract");
912 
913         // solhint-disable-next-line avoid-low-level-calls
914         (bool success, bytes memory returndata) = address(token).call(data);
915         require(success, "SafeERC20: low-level call failed");
916 
917         if (returndata.length > 0) { // Return data is optional
918             // solhint-disable-next-line max-line-length
919             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
920         }
921     }
922 }
923 
924 // File: contracts/bprotocol/btoken/AbsBToken.sol
925 
926 pragma solidity 0.5.16;
927 
928 // Interface
929 
930 
931 
932 
933 // Libs
934 
935 
936 
937 
938 /**
939  * @title AbsBToken is BProtocol token contract which represents the Compound's CToken
940  */
941 contract AbsBToken is Exponential {
942     using SafeERC20 for IERC20;
943 
944     // BProtocol Registry contract
945     IRegistry public registry;
946     // Compound's CToken this BToken contract is tied to
947     address public cToken;
948 
949     modifier onlyDelegatee(address _avatar) {
950         // `msg.sender` is delegatee
951         require(registry.delegate(_avatar, msg.sender), "BToken: delegatee-not-authorized");
952         _;
953     }
954 
955     constructor(address _registry, address _cToken) internal {
956         registry = IRegistry(_registry);
957         cToken = _cToken;
958     }
959 
960     function _myAvatar() internal returns (address) {
961         return registry.getAvatar(msg.sender);
962     }
963 
964     // CEther / CErc20
965     // ===============
966     function borrowBalanceCurrent(address account) external returns (uint256) {
967         address _avatar = registry.getAvatar(account);
968         return IAvatar(_avatar).borrowBalanceCurrent(cToken);
969     }
970 
971     // redeem()
972     function redeem(uint256 redeemTokens) external returns (uint256) {
973         return _redeem(_myAvatar(), redeemTokens);
974     }
975 
976     function redeemOnAvatar(address _avatar, uint256 redeemTokens) external onlyDelegatee(_avatar) returns (uint256) {
977         return _redeem(_avatar, redeemTokens);
978     }
979 
980     function _redeem(address _avatar, uint256 redeemTokens) internal returns (uint256) {
981         uint256 result = IAvatar(_avatar).redeem(cToken, redeemTokens, msg.sender);
982         require(result == 0, "BToken: redeem-failed");
983         return result;
984     }
985 
986     // redeemUnderlying()
987     function redeemUnderlying(uint256 redeemAmount) external returns (uint256) {
988         return _redeemUnderlying(_myAvatar(), redeemAmount);
989     }
990 
991     function redeemUnderlyingOnAvatar(address _avatar, uint256 redeemAmount) external onlyDelegatee(_avatar) returns (uint256) {
992         return _redeemUnderlying(_avatar, redeemAmount);
993     }
994 
995     function _redeemUnderlying(address _avatar, uint256 redeemAmount) internal returns (uint256) {
996         uint256 result = IAvatar(_avatar).redeemUnderlying(cToken, redeemAmount, msg.sender);
997         require(result == 0, "BToken: redeemUnderlying-failed");
998         return result;
999     }
1000 
1001     // borrow()
1002     function borrow(uint256 borrowAmount) external returns (uint256) {
1003         return _borrow(_myAvatar(), borrowAmount);
1004     }
1005 
1006     function borrowOnAvatar(address _avatar, uint256 borrowAmount) external onlyDelegatee(_avatar) returns (uint256) {
1007         return _borrow(_avatar, borrowAmount);
1008     }
1009 
1010     function _borrow(address _avatar, uint256 borrowAmount) internal returns (uint256) {
1011         uint256 result = IAvatar(_avatar).borrow(cToken, borrowAmount, msg.sender);
1012         require(result == 0, "BToken: borrow-failed");
1013         return result;
1014     }
1015 
1016     // other functions
1017     function exchangeRateCurrent() public returns (uint256) {
1018         return ICToken(cToken).exchangeRateCurrent();
1019     }
1020 
1021     function exchangeRateStored() public view returns (uint) {
1022         return ICToken(cToken).exchangeRateStored();
1023     }
1024 
1025     // IERC20
1026     // =======
1027     // transfer()
1028     function transfer(address dst, uint256 amount) external returns (bool) {
1029         return _transfer(_myAvatar(), dst, amount);
1030     }
1031 
1032     function transferOnAvatar(address _avatar, address dst, uint256 amount) external onlyDelegatee(_avatar) returns (bool) {
1033         return _transfer(_avatar, dst, amount);
1034     }
1035 
1036     function _transfer(address _avatar, address dst, uint256 amount) internal returns (bool) {
1037         bool result = IAvatar(_avatar).transfer(cToken, dst, amount);
1038         require(result, "BToken: transfer-failed");
1039         return result;
1040     }
1041 
1042     // transferFrom()
1043     function transferFrom(address src, address dst, uint256 amount) external returns (bool) {
1044         return _transferFrom(_myAvatar(), src, dst, amount);
1045     }
1046 
1047     function transferFromOnAvatar(address _avatar, address src, address dst, uint256 amount) external onlyDelegatee(_avatar) returns (bool) {
1048         return _transferFrom(_avatar, src, dst, amount);
1049     }
1050 
1051     function _transferFrom(address _avatar, address src, address dst, uint256 amount) internal returns (bool) {
1052         bool result = IAvatar(_avatar).transferFrom(cToken, src, dst, amount);
1053         require(result, "BToken: transferFrom-failed");
1054         return result;
1055     }
1056 
1057     // approve()
1058     function approve(address spender, uint256 amount) public returns (bool) {
1059         return IAvatar(_myAvatar()).approve(cToken, spender, amount);
1060     }
1061 
1062     function approveOnAvatar(address _avatar, address spender, uint256 amount) public onlyDelegatee(_avatar) returns (bool) {
1063         return IAvatar(_avatar).approve(cToken, spender, amount);
1064     }
1065 
1066     function allowance(address owner, address spender) public view returns (uint256) {
1067         address spenderAvatar = registry.avatarOf(spender);
1068         if(spenderAvatar == address(0)) return 0;
1069         return ICToken(cToken).allowance(registry.avatarOf(owner), spenderAvatar);
1070     }
1071 
1072     function balanceOf(address owner) public view returns (uint256) {
1073         address avatar = registry.avatarOf(owner);
1074         if(avatar == address(0)) return 0;
1075         return ICToken(cToken).balanceOf(avatar);
1076     }
1077 
1078     function balanceOfUnderlying(address owner) external returns (uint) {
1079         address avatar = registry.avatarOf(owner);
1080         if(avatar == address(0)) return 0;
1081         return ICToken(cToken).balanceOfUnderlying(avatar);
1082     }
1083 
1084     function name() public view returns (string memory) {
1085         return ICToken(cToken).name();
1086     }
1087 
1088     function symbol() public view returns (string memory) {
1089         return ICToken(cToken).symbol();
1090     }
1091 
1092     function decimals() public view returns (uint8) {
1093         return ICToken(cToken).decimals();
1094     }
1095 
1096     function totalSupply() public view returns (uint256) {
1097         return ICToken(cToken).totalSupply();
1098     }
1099 }
1100 
1101 // File: contracts/bprotocol/btoken/BEther.sol
1102 
1103 pragma solidity 0.5.16;
1104 
1105 
1106 
1107 contract BEther is AbsBToken {
1108 
1109     constructor(
1110         address _registry,
1111         address _cToken
1112     ) public AbsBToken(_registry, _cToken) {}
1113 
1114     function _myAvatarCEther() internal returns (IAvatarCEther) {
1115         return IAvatarCEther(address(_myAvatar()));
1116     }
1117 
1118     // mint()
1119     function mint() external payable {
1120         // CEther calls requireNoError() to ensure no failures
1121         _myAvatarCEther().mint.value(msg.value)();
1122     }
1123 
1124     function mintOnAvatar(address _avatar) external onlyDelegatee(_avatar) payable {
1125         // CEther calls requireNoError() to ensure no failures
1126         IAvatarCEther(_avatar).mint.value(msg.value)();
1127     }
1128 
1129     // repayBorrow()
1130     function repayBorrow() external payable {
1131         // CEther calls requireNoError() to ensure no failures
1132         _myAvatarCEther().repayBorrow.value(msg.value)();
1133     }
1134 
1135     function repayBorrowOnAvatar(address _avatar) external onlyDelegatee(_avatar) payable {
1136         // CEther calls requireNoError() to ensure no failures
1137         IAvatarCEther(_avatar).repayBorrow.value(msg.value)();
1138     }
1139 }