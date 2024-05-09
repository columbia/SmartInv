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
15 
16 // File: contracts/bprotocol/interfaces/IRegistry.sol
17 
18 pragma solidity 0.5.16;
19 
20 
21 interface IRegistry {
22 
23     // Ownable
24     function transferOwnership(address newOwner) external;
25 
26     // Compound contracts
27     function comp() external view returns (address);
28     function comptroller() external view returns (address);
29     function cEther() external view returns (address);
30 
31     // B.Protocol contracts
32     function bComptroller() external view returns (address);
33     function score() external view returns (address);
34     function pool() external view returns (address);
35 
36     // Avatar functions
37     function delegate(address avatar, address delegatee) external view returns (bool);
38     function doesAvatarExist(address avatar) external view returns (bool);
39     function doesAvatarExistFor(address owner) external view returns (bool);
40     function ownerOf(address avatar) external view returns (address);
41     function avatarOf(address owner) external view returns (address);
42     function newAvatar() external returns (address);
43     function getAvatar(address owner) external returns (address);
44     // avatar whitelisted calls
45     function whitelistedAvatarCalls(address target, bytes4 functionSig) external view returns(bool);
46 
47     function setPool(address newPool) external;
48     function setWhitelistAvatarCall(address target, bytes4 functionSig, bool list) external;
49 }
50 
51 // File: contracts/bprotocol/interfaces/IAvatar.sol
52 
53 pragma solidity 0.5.16;
54 
55 contract IAvatarERC20 {
56     function transfer(address cToken, address dst, uint256 amount) external returns (bool);
57     function transferFrom(address cToken, address src, address dst, uint256 amount) external returns (bool);
58     function approve(address cToken, address spender, uint256 amount) public returns (bool);
59 }
60 
61 contract IAvatar is IAvatarERC20 {
62     function initialize(address _registry, address comp, address compVoter) external;
63     function quit() external returns (bool);
64     function canUntop() public returns (bool);
65     function toppedUpCToken() external returns (address);
66     function toppedUpAmount() external returns (uint256);
67     function redeem(address cToken, uint256 redeemTokens, address payable userOrDelegatee) external returns (uint256);
68     function redeemUnderlying(address cToken, uint256 redeemAmount, address payable userOrDelegatee) external returns (uint256);
69     function borrow(address cToken, uint256 borrowAmount, address payable userOrDelegatee) external returns (uint256);
70     function borrowBalanceCurrent(address cToken) external returns (uint256);
71     function collectCToken(address cToken, address from, uint256 cTokenAmt) public;
72     function liquidateBorrow(uint repayAmount, address cTokenCollateral) external payable returns (uint256);
73 
74     // Comptroller functions
75     function enterMarket(address cToken) external returns (uint256);
76     function enterMarkets(address[] calldata cTokens) external returns (uint256[] memory);
77     function exitMarket(address cToken) external returns (uint256);
78     function claimComp() external;
79     function claimComp(address[] calldata bTokens) external;
80     function claimComp(address[] calldata bTokens, bool borrowers, bool suppliers) external;
81     function getAccountLiquidity() external view returns (uint err, uint liquidity, uint shortFall);
82 }
83 
84 // Workaround for issue https://github.com/ethereum/solidity/issues/526
85 // CEther
86 contract IAvatarCEther is IAvatar {
87     function mint() external payable;
88     function repayBorrow() external payable;
89     function repayBorrowBehalf(address borrower) external payable;
90 }
91 
92 // CErc20
93 contract IAvatarCErc20 is IAvatar {
94     function mint(address cToken, uint256 mintAmount) external returns (uint256);
95     function repayBorrow(address cToken, uint256 repayAmount) external returns (uint256);
96     function repayBorrowBehalf(address cToken, address borrower, uint256 repayAmount) external returns (uint256);
97 }
98 
99 contract ICushion {
100     function liquidateBorrow(uint256 underlyingAmtToLiquidate, uint256 amtToDeductFromTopup, address cTokenCollateral) external payable returns (uint256);    
101     function canLiquidate() external returns (bool);
102     function untop(uint amount) external;
103     function toppedUpAmount() external returns (uint);
104     function remainingLiquidationAmount() external returns(uint);
105     function getMaxLiquidationAmount(address debtCToken) public returns (uint256);
106 }
107 
108 contract ICushionCErc20 is ICushion {
109     function topup(address cToken, uint256 topupAmount) external;
110 }
111 
112 contract ICushionCEther is ICushion {
113     function topup() external payable;
114 }
115 
116 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
117 
118 pragma solidity ^0.5.0;
119 
120 /**
121  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
122  * the optional functions; to access them see {ERC20Detailed}.
123  */
124 interface IERC20 {
125     /**
126      * @dev Returns the amount of tokens in existence.
127      */
128     function totalSupply() external view returns (uint256);
129 
130     /**
131      * @dev Returns the amount of tokens owned by `account`.
132      */
133     function balanceOf(address account) external view returns (uint256);
134 
135     /**
136      * @dev Moves `amount` tokens from the caller's account to `recipient`.
137      *
138      * Returns a boolean value indicating whether the operation succeeded.
139      *
140      * Emits a {Transfer} event.
141      */
142     function transfer(address recipient, uint256 amount) external returns (bool);
143 
144     /**
145      * @dev Returns the remaining number of tokens that `spender` will be
146      * allowed to spend on behalf of `owner` through {transferFrom}. This is
147      * zero by default.
148      *
149      * This value changes when {approve} or {transferFrom} are called.
150      */
151     function allowance(address owner, address spender) external view returns (uint256);
152 
153     /**
154      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
155      *
156      * Returns a boolean value indicating whether the operation succeeded.
157      *
158      * IMPORTANT: Beware that changing an allowance with this method brings the risk
159      * that someone may use both the old and the new allowance by unfortunate
160      * transaction ordering. One possible solution to mitigate this race
161      * condition is to first reduce the spender's allowance to 0 and set the
162      * desired value afterwards:
163      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
164      *
165      * Emits an {Approval} event.
166      */
167     function approve(address spender, uint256 amount) external returns (bool);
168 
169     /**
170      * @dev Moves `amount` tokens from `sender` to `recipient` using the
171      * allowance mechanism. `amount` is then deducted from the caller's
172      * allowance.
173      *
174      * Returns a boolean value indicating whether the operation succeeded.
175      *
176      * Emits a {Transfer} event.
177      */
178     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
179 
180     /**
181      * @dev Emitted when `value` tokens are moved from one account (`from`) to
182      * another (`to`).
183      *
184      * Note that `value` may be zero.
185      */
186     event Transfer(address indexed from, address indexed to, uint256 value);
187 
188     /**
189      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
190      * a call to {approve}. `value` is the new allowance.
191      */
192     event Approval(address indexed owner, address indexed spender, uint256 value);
193 }
194 
195 // File: contracts/bprotocol/interfaces/CTokenInterfaces.sol
196 
197 pragma solidity 0.5.16;
198 
199 
200 contract CTokenInterface {
201     /* ERC20 */
202     function transfer(address dst, uint amount) external returns (bool);
203     function transferFrom(address src, address dst, uint amount) external returns (bool);
204     function approve(address spender, uint amount) external returns (bool);
205     function allowance(address owner, address spender) external view returns (uint);
206     function balanceOf(address owner) external view returns (uint);
207     function totalSupply() external view returns (uint256);
208     function name() external view returns (string memory);
209     function symbol() external view returns (string memory);
210     function decimals() external view returns (uint8);
211 
212     /* User Interface */
213     function isCToken() external view returns (bool);
214     function underlying() external view returns (IERC20);
215     function balanceOfUnderlying(address owner) external returns (uint);
216     function getAccountSnapshot(address account) external view returns (uint, uint, uint, uint);
217     function borrowRatePerBlock() external view returns (uint);
218     function supplyRatePerBlock() external view returns (uint);
219     function totalBorrowsCurrent() external returns (uint);
220     function borrowBalanceCurrent(address account) external returns (uint);
221     function borrowBalanceStored(address account) public view returns (uint);
222     function exchangeRateCurrent() public returns (uint);
223     function exchangeRateStored() public view returns (uint);
224     function getCash() external view returns (uint);
225     function accrueInterest() public returns (uint);
226     function seize(address liquidator, address borrower, uint seizeTokens) external returns (uint);
227 
228 }
229 
230 contract ICToken is CTokenInterface {
231 
232     /* User Interface */
233     function redeem(uint redeemTokens) external returns (uint);
234     function redeemUnderlying(uint redeemAmount) external returns (uint);
235     function borrow(uint borrowAmount) external returns (uint);
236 }
237 
238 // Workaround for issue https://github.com/ethereum/solidity/issues/526
239 // Defined separate contract as `mint()` override with `.value()` has issues
240 contract ICErc20 is ICToken {
241     function mint(uint mintAmount) external returns (uint);
242     function repayBorrow(uint repayAmount) external returns (uint);
243     function repayBorrowBehalf(address borrower, uint repayAmount) external returns (uint);
244     function liquidateBorrow(address borrower, uint repayAmount, address cTokenCollateral) external returns (uint);
245 }
246 
247 contract ICEther is ICToken {
248     function mint() external payable;
249     function repayBorrow() external payable;
250     function repayBorrowBehalf(address borrower) external payable;
251     function liquidateBorrow(address borrower, address cTokenCollateral) external payable;
252 }
253 
254 contract IPriceOracle {
255     /**
256       * @notice Get the underlying price of a cToken asset
257       * @param cToken The cToken to get the underlying price of
258       * @return The underlying asset price mantissa (scaled by 1e18).
259       *  Zero means the price is unavailable.
260       */
261     function getUnderlyingPrice(CTokenInterface cToken) external view returns (uint);
262 }
263 
264 // File: contracts/bprotocol/lib/CarefulMath.sol
265 
266 pragma solidity 0.5.16;
267 
268 /**
269   * @title Careful Math
270   * @author Compound
271   * @notice COPY TAKEN FROM COMPOUND FINANCE
272   * @notice Derived from OpenZeppelin's SafeMath library
273   *         https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol
274   */
275 contract CarefulMath {
276 
277     /**
278      * @dev Possible error codes that we can return
279      */
280     enum MathError {
281         NO_ERROR,
282         DIVISION_BY_ZERO,
283         INTEGER_OVERFLOW,
284         INTEGER_UNDERFLOW
285     }
286 
287     /**
288     * @dev Multiplies two numbers, returns an error on overflow.
289     */
290     function mulUInt(uint a, uint b) internal pure returns (MathError, uint) {
291         if (a == 0) {
292             return (MathError.NO_ERROR, 0);
293         }
294 
295         uint c = a * b;
296 
297         if (c / a != b) {
298             return (MathError.INTEGER_OVERFLOW, 0);
299         } else {
300             return (MathError.NO_ERROR, c);
301         }
302     }
303 
304     /**
305     * @dev Integer division of two numbers, truncating the quotient.
306     */
307     function divUInt(uint a, uint b) internal pure returns (MathError, uint) {
308         if (b == 0) {
309             return (MathError.DIVISION_BY_ZERO, 0);
310         }
311 
312         return (MathError.NO_ERROR, a / b);
313     }
314 
315     /**
316     * @dev Subtracts two numbers, returns an error on overflow (i.e. if subtrahend is greater than minuend).
317     */
318     function subUInt(uint a, uint b) internal pure returns (MathError, uint) {
319         if (b <= a) {
320             return (MathError.NO_ERROR, a - b);
321         } else {
322             return (MathError.INTEGER_UNDERFLOW, 0);
323         }
324     }
325 
326     /**
327     * @dev Adds two numbers, returns an error on overflow.
328     */
329     function addUInt(uint a, uint b) internal pure returns (MathError, uint) {
330         uint c = a + b;
331 
332         if (c >= a) {
333             return (MathError.NO_ERROR, c);
334         } else {
335             return (MathError.INTEGER_OVERFLOW, 0);
336         }
337     }
338 
339     /**
340     * @dev add a and b and then subtract c
341     */
342     function addThenSubUInt(uint a, uint b, uint c) internal pure returns (MathError, uint) {
343         (MathError err0, uint sum) = addUInt(a, b);
344 
345         if (err0 != MathError.NO_ERROR) {
346             return (err0, 0);
347         }
348 
349         return subUInt(sum, c);
350     }
351 }
352 
353 // File: contracts/bprotocol/lib/Exponential.sol
354 
355 pragma solidity 0.5.16;
356 
357 
358 /**
359  * @title Exponential module for storing fixed-precision decimals
360  * @author Compound
361  * @notice Exp is a struct which stores decimals with a fixed precision of 18 decimal places.
362  *         Thus, if we wanted to store the 5.1, mantissa would store 5.1e18. That is:
363  *         `Exp({mantissa: 5100000000000000000})`.
364  */
365 contract Exponential is CarefulMath {
366     uint constant expScale = 1e18;
367     uint constant doubleScale = 1e36;
368     uint constant halfExpScale = expScale/2;
369     uint constant mantissaOne = expScale;
370 
371     struct Exp {
372         uint mantissa;
373     }
374 
375     struct Double {
376         uint mantissa;
377     }
378 
379     /**
380      * @dev Creates an exponential from numerator and denominator values.
381      *      Note: Returns an error if (`num` * 10e18) > MAX_INT,
382      *            or if `denom` is zero.
383      */
384     function getExp(uint num, uint denom) pure internal returns (MathError, Exp memory) {
385         (MathError err0, uint scaledNumerator) = mulUInt(num, expScale);
386         if (err0 != MathError.NO_ERROR) {
387             return (err0, Exp({mantissa: 0}));
388         }
389 
390         (MathError err1, uint rational) = divUInt(scaledNumerator, denom);
391         if (err1 != MathError.NO_ERROR) {
392             return (err1, Exp({mantissa: 0}));
393         }
394 
395         return (MathError.NO_ERROR, Exp({mantissa: rational}));
396     }
397 
398     /**
399      * @dev Multiply an Exp by a scalar, returning a new Exp.
400      */
401     function mulScalar(Exp memory a, uint scalar) pure internal returns (MathError, Exp memory) {
402         (MathError err0, uint scaledMantissa) = mulUInt(a.mantissa, scalar);
403         if (err0 != MathError.NO_ERROR) {
404             return (err0, Exp({mantissa: 0}));
405         }
406 
407         return (MathError.NO_ERROR, Exp({mantissa: scaledMantissa}));
408     }
409 
410     /**
411      * @dev Multiply an Exp by a scalar, then truncate to return an unsigned integer.
412      */
413     function mulScalarTruncate(Exp memory a, uint scalar) pure internal returns (MathError, uint) {
414         (MathError err, Exp memory product) = mulScalar(a, scalar);
415         if (err != MathError.NO_ERROR) {
416             return (err, 0);
417         }
418 
419         return (MathError.NO_ERROR, truncate(product));
420     }
421 
422     /**
423      * @dev Divide a scalar by an Exp, returning a new Exp.
424      */
425     function divScalarByExp(uint scalar, Exp memory divisor) pure internal returns (MathError, Exp memory) {
426         /*
427           We are doing this as:
428           getExp(mulUInt(expScale, scalar), divisor.mantissa)
429 
430           How it works:
431           Exp = a / b;
432           Scalar = s;
433           `s / (a / b)` = `b * s / a` and since for an Exp `a = mantissa, b = expScale`
434         */
435         (MathError err0, uint numerator) = mulUInt(expScale, scalar);
436         if (err0 != MathError.NO_ERROR) {
437             return (err0, Exp({mantissa: 0}));
438         }
439         return getExp(numerator, divisor.mantissa);
440     }
441 
442     /**
443      * @dev Multiplies two exponentials, returning a new exponential.
444      */
445     function mulExp(Exp memory a, Exp memory b) pure internal returns (MathError, Exp memory) {
446 
447         (MathError err0, uint doubleScaledProduct) = mulUInt(a.mantissa, b.mantissa);
448         if (err0 != MathError.NO_ERROR) {
449             return (err0, Exp({mantissa: 0}));
450         }
451 
452         // We add half the scale before dividing so that we get rounding instead of truncation.
453         //  See "Listing 6" and text above it at https://accu.org/index.php/journals/1717
454         // Without this change, a result like 6.6...e-19 will be truncated to 0 instead of being rounded to 1e-18.
455         (MathError err1, uint doubleScaledProductWithHalfScale) = addUInt(halfExpScale, doubleScaledProduct);
456         if (err1 != MathError.NO_ERROR) {
457             return (err1, Exp({mantissa: 0}));
458         }
459 
460         (MathError err2, uint product) = divUInt(doubleScaledProductWithHalfScale, expScale);
461         // The only error `div` can return is MathError.DIVISION_BY_ZERO but we control `expScale` and it is not zero.
462         assert(err2 == MathError.NO_ERROR);
463 
464         return (MathError.NO_ERROR, Exp({mantissa: product}));
465     }
466 
467     /**
468      * @dev Multiplies two exponentials given their mantissas, returning a new exponential.
469      */
470     function mulExp(uint a, uint b) pure internal returns (MathError, Exp memory) {
471         return mulExp(Exp({mantissa: a}), Exp({mantissa: b}));
472     }
473 
474 
475     /**
476      * @dev Divides two exponentials, returning a new exponential.
477      *     (a/scale) / (b/scale) = (a/scale) * (scale/b) = a/b,
478      *  which we can scale as an Exp by calling getExp(a.mantissa, b.mantissa)
479      */
480     function divExp(Exp memory a, Exp memory b) pure internal returns (MathError, Exp memory) {
481         return getExp(a.mantissa, b.mantissa);
482     }
483 
484     /**
485      * @dev Truncates the given exp to a whole number value.
486      *      For example, truncate(Exp{mantissa: 15 * expScale}) = 15
487      */
488     function truncate(Exp memory exp) pure internal returns (uint) {
489         // Note: We are not using careful math here as we're performing a division that cannot fail
490         return exp.mantissa / expScale;
491     }
492 
493 
494     function safe224(uint n, string memory errorMessage) pure internal returns (uint224) {
495         require(n < 2**224, errorMessage);
496         return uint224(n);
497     }
498 
499     function add_(Exp memory a, Exp memory b) pure internal returns (Exp memory) {
500         return Exp({mantissa: add_(a.mantissa, b.mantissa)});
501     }
502 
503     function add_(Double memory a, Double memory b) pure internal returns (Double memory) {
504         return Double({mantissa: add_(a.mantissa, b.mantissa)});
505     }
506 
507     function add_(uint a, uint b) pure internal returns (uint) {
508         return add_(a, b, "addition overflow");
509     }
510 
511     function add_(uint a, uint b, string memory errorMessage) pure internal returns (uint) {
512         uint c = a + b;
513         require(c >= a, errorMessage);
514         return c;
515     }
516 
517     function sub_(Exp memory a, Exp memory b) pure internal returns (Exp memory) {
518         return Exp({mantissa: sub_(a.mantissa, b.mantissa)});
519     }
520 
521     function sub_(Double memory a, Double memory b) pure internal returns (Double memory) {
522         return Double({mantissa: sub_(a.mantissa, b.mantissa)});
523     }
524 
525     function sub_(uint a, uint b) pure internal returns (uint) {
526         return sub_(a, b, "subtraction underflow");
527     }
528 
529     function sub_(uint a, uint b, string memory errorMessage) pure internal returns (uint) {
530         require(b <= a, errorMessage);
531         return a - b;
532     }
533 
534     function mul_(Exp memory a, Exp memory b) pure internal returns (Exp memory) {
535         return Exp({mantissa: mul_(a.mantissa, b.mantissa) / expScale});
536     }
537 
538     function mul_(Exp memory a, uint b) pure internal returns (Exp memory) {
539         return Exp({mantissa: mul_(a.mantissa, b)});
540     }
541 
542     function mul_(uint a, Exp memory b) pure internal returns (uint) {
543         return mul_(a, b.mantissa) / expScale;
544     }
545 
546     function mul_(Double memory a, Double memory b) pure internal returns (Double memory) {
547         return Double({mantissa: mul_(a.mantissa, b.mantissa) / doubleScale});
548     }
549 
550     function mul_(Double memory a, uint b) pure internal returns (Double memory) {
551         return Double({mantissa: mul_(a.mantissa, b)});
552     }
553 
554     function mul_(uint a, Double memory b) pure internal returns (uint) {
555         return mul_(a, b.mantissa) / doubleScale;
556     }
557 
558     function mul_(uint a, uint b) pure internal returns (uint) {
559         return mul_(a, b, "multiplication overflow");
560     }
561 
562     function mul_(uint a, uint b, string memory errorMessage) pure internal returns (uint) {
563         if (a == 0 || b == 0) {
564             return 0;
565         }
566         uint c = a * b;
567         require(c / a == b, errorMessage);
568         return c;
569     }
570 
571     function div_(Exp memory a, Exp memory b) pure internal returns (Exp memory) {
572         return Exp({mantissa: div_(mul_(a.mantissa, expScale), b.mantissa)});
573     }
574 
575     function div_(Exp memory a, uint b) pure internal returns (Exp memory) {
576         return Exp({mantissa: div_(a.mantissa, b)});
577     }
578 
579     function div_(uint a, Exp memory b) pure internal returns (uint) {
580         return div_(mul_(a, expScale), b.mantissa);
581     }
582 
583     function div_(Double memory a, Double memory b) pure internal returns (Double memory) {
584         return Double({mantissa: div_(mul_(a.mantissa, doubleScale), b.mantissa)});
585     }
586 
587     function div_(Double memory a, uint b) pure internal returns (Double memory) {
588         return Double({mantissa: div_(a.mantissa, b)});
589     }
590 
591     function div_(uint a, Double memory b) pure internal returns (uint) {
592         return div_(mul_(a, doubleScale), b.mantissa);
593     }
594 
595     function div_(uint a, uint b) pure internal returns (uint) {
596         return div_(a, b, "divide by zero");
597     }
598 
599     function div_(uint a, uint b, string memory errorMessage) pure internal returns (uint) {
600         require(b > 0, errorMessage);
601         return a / b;
602     }
603 
604     function fraction(uint a, uint b) pure internal returns (Double memory) {
605         return Double({mantissa: div_(mul_(a, doubleScale), b)});
606     }
607 
608     // New functions added by BProtocol
609     // =================================
610 
611     function mulTrucate(uint a, uint b) internal pure returns (uint) {
612         return mul_(a, b) / expScale;
613     }
614 }
615 
616 // File: @openzeppelin/contracts/math/SafeMath.sol
617 
618 pragma solidity ^0.5.0;
619 
620 /**
621  * @dev Wrappers over Solidity's arithmetic operations with added overflow
622  * checks.
623  *
624  * Arithmetic operations in Solidity wrap on overflow. This can easily result
625  * in bugs, because programmers usually assume that an overflow raises an
626  * error, which is the standard behavior in high level programming languages.
627  * `SafeMath` restores this intuition by reverting the transaction when an
628  * operation overflows.
629  *
630  * Using this library instead of the unchecked operations eliminates an entire
631  * class of bugs, so it's recommended to use it always.
632  */
633 library SafeMath {
634     /**
635      * @dev Returns the addition of two unsigned integers, reverting on
636      * overflow.
637      *
638      * Counterpart to Solidity's `+` operator.
639      *
640      * Requirements:
641      * - Addition cannot overflow.
642      */
643     function add(uint256 a, uint256 b) internal pure returns (uint256) {
644         uint256 c = a + b;
645         require(c >= a, "SafeMath: addition overflow");
646 
647         return c;
648     }
649 
650     /**
651      * @dev Returns the subtraction of two unsigned integers, reverting on
652      * overflow (when the result is negative).
653      *
654      * Counterpart to Solidity's `-` operator.
655      *
656      * Requirements:
657      * - Subtraction cannot overflow.
658      */
659     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
660         return sub(a, b, "SafeMath: subtraction overflow");
661     }
662 
663     /**
664      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
665      * overflow (when the result is negative).
666      *
667      * Counterpart to Solidity's `-` operator.
668      *
669      * Requirements:
670      * - Subtraction cannot overflow.
671      *
672      * _Available since v2.4.0._
673      */
674     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
675         require(b <= a, errorMessage);
676         uint256 c = a - b;
677 
678         return c;
679     }
680 
681     /**
682      * @dev Returns the multiplication of two unsigned integers, reverting on
683      * overflow.
684      *
685      * Counterpart to Solidity's `*` operator.
686      *
687      * Requirements:
688      * - Multiplication cannot overflow.
689      */
690     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
691         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
692         // benefit is lost if 'b' is also tested.
693         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
694         if (a == 0) {
695             return 0;
696         }
697 
698         uint256 c = a * b;
699         require(c / a == b, "SafeMath: multiplication overflow");
700 
701         return c;
702     }
703 
704     /**
705      * @dev Returns the integer division of two unsigned integers. Reverts on
706      * division by zero. The result is rounded towards zero.
707      *
708      * Counterpart to Solidity's `/` operator. Note: this function uses a
709      * `revert` opcode (which leaves remaining gas untouched) while Solidity
710      * uses an invalid opcode to revert (consuming all remaining gas).
711      *
712      * Requirements:
713      * - The divisor cannot be zero.
714      */
715     function div(uint256 a, uint256 b) internal pure returns (uint256) {
716         return div(a, b, "SafeMath: division by zero");
717     }
718 
719     /**
720      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
721      * division by zero. The result is rounded towards zero.
722      *
723      * Counterpart to Solidity's `/` operator. Note: this function uses a
724      * `revert` opcode (which leaves remaining gas untouched) while Solidity
725      * uses an invalid opcode to revert (consuming all remaining gas).
726      *
727      * Requirements:
728      * - The divisor cannot be zero.
729      *
730      * _Available since v2.4.0._
731      */
732     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
733         // Solidity only automatically asserts when dividing by 0
734         require(b > 0, errorMessage);
735         uint256 c = a / b;
736         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
737 
738         return c;
739     }
740 
741     /**
742      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
743      * Reverts when dividing by zero.
744      *
745      * Counterpart to Solidity's `%` operator. This function uses a `revert`
746      * opcode (which leaves remaining gas untouched) while Solidity uses an
747      * invalid opcode to revert (consuming all remaining gas).
748      *
749      * Requirements:
750      * - The divisor cannot be zero.
751      */
752     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
753         return mod(a, b, "SafeMath: modulo by zero");
754     }
755 
756     /**
757      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
758      * Reverts with custom message when dividing by zero.
759      *
760      * Counterpart to Solidity's `%` operator. This function uses a `revert`
761      * opcode (which leaves remaining gas untouched) while Solidity uses an
762      * invalid opcode to revert (consuming all remaining gas).
763      *
764      * Requirements:
765      * - The divisor cannot be zero.
766      *
767      * _Available since v2.4.0._
768      */
769     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
770         require(b != 0, errorMessage);
771         return a % b;
772     }
773 }
774 
775 // File: @openzeppelin/contracts/utils/Address.sol
776 
777 pragma solidity ^0.5.5;
778 
779 /**
780  * @dev Collection of functions related to the address type
781  */
782 library Address {
783     /**
784      * @dev Returns true if `account` is a contract.
785      *
786      * [IMPORTANT]
787      * ====
788      * It is unsafe to assume that an address for which this function returns
789      * false is an externally-owned account (EOA) and not a contract.
790      *
791      * Among others, `isContract` will return false for the following 
792      * types of addresses:
793      *
794      *  - an externally-owned account
795      *  - a contract in construction
796      *  - an address where a contract will be created
797      *  - an address where a contract lived, but was destroyed
798      * ====
799      */
800     function isContract(address account) internal view returns (bool) {
801         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
802         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
803         // for accounts without code, i.e. `keccak256('')`
804         bytes32 codehash;
805         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
806         // solhint-disable-next-line no-inline-assembly
807         assembly { codehash := extcodehash(account) }
808         return (codehash != accountHash && codehash != 0x0);
809     }
810 
811     /**
812      * @dev Converts an `address` into `address payable`. Note that this is
813      * simply a type cast: the actual underlying value is not changed.
814      *
815      * _Available since v2.4.0._
816      */
817     function toPayable(address account) internal pure returns (address payable) {
818         return address(uint160(account));
819     }
820 
821     /**
822      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
823      * `recipient`, forwarding all available gas and reverting on errors.
824      *
825      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
826      * of certain opcodes, possibly making contracts go over the 2300 gas limit
827      * imposed by `transfer`, making them unable to receive funds via
828      * `transfer`. {sendValue} removes this limitation.
829      *
830      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
831      *
832      * IMPORTANT: because control is transferred to `recipient`, care must be
833      * taken to not create reentrancy vulnerabilities. Consider using
834      * {ReentrancyGuard} or the
835      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
836      *
837      * _Available since v2.4.0._
838      */
839     function sendValue(address payable recipient, uint256 amount) internal {
840         require(address(this).balance >= amount, "Address: insufficient balance");
841 
842         // solhint-disable-next-line avoid-call-value
843         (bool success, ) = recipient.call.value(amount)("");
844         require(success, "Address: unable to send value, recipient may have reverted");
845     }
846 }
847 
848 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
849 
850 pragma solidity ^0.5.0;
851 
852 
853 
854 
855 /**
856  * @title SafeERC20
857  * @dev Wrappers around ERC20 operations that throw on failure (when the token
858  * contract returns false). Tokens that return no value (and instead revert or
859  * throw on failure) are also supported, non-reverting calls are assumed to be
860  * successful.
861  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
862  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
863  */
864 library SafeERC20 {
865     using SafeMath for uint256;
866     using Address for address;
867 
868     function safeTransfer(IERC20 token, address to, uint256 value) internal {
869         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
870     }
871 
872     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
873         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
874     }
875 
876     function safeApprove(IERC20 token, address spender, uint256 value) internal {
877         // safeApprove should only be called when setting an initial allowance,
878         // or when resetting it to zero. To increase and decrease it, use
879         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
880         // solhint-disable-next-line max-line-length
881         require((value == 0) || (token.allowance(address(this), spender) == 0),
882             "SafeERC20: approve from non-zero to non-zero allowance"
883         );
884         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
885     }
886 
887     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
888         uint256 newAllowance = token.allowance(address(this), spender).add(value);
889         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
890     }
891 
892     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
893         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
894         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
895     }
896 
897     /**
898      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
899      * on the return value: the return value is optional (but if data is returned, it must not be false).
900      * @param token The token targeted by the call.
901      * @param data The call data (encoded using abi.encode or one of its variants).
902      */
903     function callOptionalReturn(IERC20 token, bytes memory data) private {
904         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
905         // we're implementing it ourselves.
906 
907         // A Solidity high level call has three parts:
908         //  1. The target address is checked to verify it contains contract code
909         //  2. The call itself is made, and success asserted
910         //  3. The return value is decoded, which in turn checks the size of the returned data.
911         // solhint-disable-next-line max-line-length
912         require(address(token).isContract(), "SafeERC20: call to non-contract");
913 
914         // solhint-disable-next-line avoid-low-level-calls
915         (bool success, bytes memory returndata) = address(token).call(data);
916         require(success, "SafeERC20: low-level call failed");
917 
918         if (returndata.length > 0) { // Return data is optional
919             // solhint-disable-next-line max-line-length
920             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
921         }
922     }
923 }
924 
925 // File: contracts/bprotocol/btoken/AbsBToken.sol
926 
927 pragma solidity 0.5.16;
928 
929 // Interface
930 
931 
932 
933 
934 // Libs
935 
936 
937 
938 
939 /**
940  * @title AbsBToken is BProtocol token contract which represents the Compound's CToken
941  */
942 contract AbsBToken is Exponential {
943     using SafeERC20 for IERC20;
944 
945     // BProtocol Registry contract
946     IRegistry public registry;
947     // Compound's CToken this BToken contract is tied to
948     address public cToken;
949 
950     modifier onlyDelegatee(address _avatar) {
951         // `msg.sender` is delegatee
952         require(registry.delegate(_avatar, msg.sender), "BToken: delegatee-not-authorized");
953         _;
954     }
955 
956     constructor(address _registry, address _cToken) internal {
957         registry = IRegistry(_registry);
958         cToken = _cToken;
959     }
960 
961     function _myAvatar() internal returns (address) {
962         return registry.getAvatar(msg.sender);
963     }
964 
965     // CEther / CErc20
966     // ===============
967     function borrowBalanceCurrent(address account) external returns (uint256) {
968         address _avatar = registry.getAvatar(account);
969         return IAvatar(_avatar).borrowBalanceCurrent(cToken);
970     }
971 
972     // redeem()
973     function redeem(uint256 redeemTokens) external returns (uint256) {
974         return _redeem(_myAvatar(), redeemTokens);
975     }
976 
977     function redeemOnAvatar(address _avatar, uint256 redeemTokens) external onlyDelegatee(_avatar) returns (uint256) {
978         return _redeem(_avatar, redeemTokens);
979     }
980 
981     function _redeem(address _avatar, uint256 redeemTokens) internal returns (uint256) {
982         uint256 result = IAvatar(_avatar).redeem(cToken, redeemTokens, msg.sender);
983         require(result == 0, "BToken: redeem-failed");
984         return result;
985     }
986 
987     // redeemUnderlying()
988     function redeemUnderlying(uint256 redeemAmount) external returns (uint256) {
989         return _redeemUnderlying(_myAvatar(), redeemAmount);
990     }
991 
992     function redeemUnderlyingOnAvatar(address _avatar, uint256 redeemAmount) external onlyDelegatee(_avatar) returns (uint256) {
993         return _redeemUnderlying(_avatar, redeemAmount);
994     }
995 
996     function _redeemUnderlying(address _avatar, uint256 redeemAmount) internal returns (uint256) {
997         uint256 result = IAvatar(_avatar).redeemUnderlying(cToken, redeemAmount, msg.sender);
998         require(result == 0, "BToken: redeemUnderlying-failed");
999         return result;
1000     }
1001 
1002     // borrow()
1003     function borrow(uint256 borrowAmount) external returns (uint256) {
1004         return _borrow(_myAvatar(), borrowAmount);
1005     }
1006 
1007     function borrowOnAvatar(address _avatar, uint256 borrowAmount) external onlyDelegatee(_avatar) returns (uint256) {
1008         return _borrow(_avatar, borrowAmount);
1009     }
1010 
1011     function _borrow(address _avatar, uint256 borrowAmount) internal returns (uint256) {
1012         uint256 result = IAvatar(_avatar).borrow(cToken, borrowAmount, msg.sender);
1013         require(result == 0, "BToken: borrow-failed");
1014         return result;
1015     }
1016 
1017     // other functions
1018     function exchangeRateCurrent() public returns (uint256) {
1019         return ICToken(cToken).exchangeRateCurrent();
1020     }
1021 
1022     function exchangeRateStored() public view returns (uint) {
1023         return ICToken(cToken).exchangeRateStored();
1024     }
1025 
1026     // IERC20
1027     // =======
1028     // transfer()
1029     function transfer(address dst, uint256 amount) external returns (bool) {
1030         return _transfer(_myAvatar(), dst, amount);
1031     }
1032 
1033     function transferOnAvatar(address _avatar, address dst, uint256 amount) external onlyDelegatee(_avatar) returns (bool) {
1034         return _transfer(_avatar, dst, amount);
1035     }
1036 
1037     function _transfer(address _avatar, address dst, uint256 amount) internal returns (bool) {
1038         bool result = IAvatar(_avatar).transfer(cToken, dst, amount);
1039         require(result, "BToken: transfer-failed");
1040         return result;
1041     }
1042 
1043     // transferFrom()
1044     function transferFrom(address src, address dst, uint256 amount) external returns (bool) {
1045         return _transferFrom(_myAvatar(), src, dst, amount);
1046     }
1047 
1048     function transferFromOnAvatar(address _avatar, address src, address dst, uint256 amount) external onlyDelegatee(_avatar) returns (bool) {
1049         return _transferFrom(_avatar, src, dst, amount);
1050     }
1051 
1052     function _transferFrom(address _avatar, address src, address dst, uint256 amount) internal returns (bool) {
1053         bool result = IAvatar(_avatar).transferFrom(cToken, src, dst, amount);
1054         require(result, "BToken: transferFrom-failed");
1055         return result;
1056     }
1057 
1058     // approve()
1059     function approve(address spender, uint256 amount) public returns (bool) {
1060         return IAvatar(_myAvatar()).approve(cToken, spender, amount);
1061     }
1062 
1063     function approveOnAvatar(address _avatar, address spender, uint256 amount) public onlyDelegatee(_avatar) returns (bool) {
1064         return IAvatar(_avatar).approve(cToken, spender, amount);
1065     }
1066 
1067     function allowance(address owner, address spender) public view returns (uint256) {
1068         address spenderAvatar = registry.avatarOf(spender);
1069         if(spenderAvatar == address(0)) return 0;
1070         return ICToken(cToken).allowance(registry.avatarOf(owner), spenderAvatar);
1071     }
1072 
1073     function balanceOf(address owner) public view returns (uint256) {
1074         address avatar = registry.avatarOf(owner);
1075         if(avatar == address(0)) return 0;
1076         return ICToken(cToken).balanceOf(avatar);
1077     }
1078 
1079     function balanceOfUnderlying(address owner) external returns (uint) {
1080         address avatar = registry.avatarOf(owner);
1081         if(avatar == address(0)) return 0;
1082         return ICToken(cToken).balanceOfUnderlying(avatar);
1083     }
1084 
1085     function name() public view returns (string memory) {
1086         return ICToken(cToken).name();
1087     }
1088 
1089     function symbol() public view returns (string memory) {
1090         return ICToken(cToken).symbol();
1091     }
1092 
1093     function decimals() public view returns (uint8) {
1094         return ICToken(cToken).decimals();
1095     }
1096 
1097     function totalSupply() public view returns (uint256) {
1098         return ICToken(cToken).totalSupply();
1099     }
1100 }
1101 
1102 // File: contracts/bprotocol/btoken/BErc20.sol
1103 
1104 pragma solidity 0.5.16;
1105 
1106 
1107 
1108 
1109 
1110 contract BErc20 is AbsBToken {
1111 
1112     IERC20 public underlying;
1113 
1114     constructor(
1115         address _registry,
1116         address _cToken
1117     ) public AbsBToken(_registry, _cToken) {
1118         underlying = ICToken(cToken).underlying();
1119     }
1120 
1121     // mint()
1122     function mint(uint256 mintAmount) external returns (uint256) {
1123         return _mint(_myAvatar(), mintAmount);
1124     }
1125 
1126     function mintOnAvatar(address _avatar, uint256 mintAmount) external onlyDelegatee(_avatar) returns (uint256) {
1127         return _mint(_avatar, mintAmount);
1128     }
1129 
1130     function _mint(address _avatar, uint256 mintAmount) internal returns (uint256) {
1131         underlying.safeTransferFrom(msg.sender, _avatar, mintAmount);
1132         uint256 result = IAvatarCErc20(_avatar).mint(cToken, mintAmount);
1133         require(result == 0, "BErc20: mint-failed");
1134         return result;
1135     }
1136 
1137     // repayBorrow()
1138     function repayBorrow(uint256 repayAmount) external returns (uint256) {
1139         return _repayBorrow(_myAvatar(), repayAmount);
1140     }
1141 
1142     function repayBorrowOnAvatar(address _avatar, uint256 repayAmount) external onlyDelegatee(_avatar) returns (uint256) {
1143         return _repayBorrow(_avatar, repayAmount);
1144     }
1145 
1146     function _repayBorrow(address _avatar, uint256 repayAmount) internal returns (uint256) {
1147         uint256 actualRepayAmount = repayAmount;
1148         if(repayAmount == uint256(-1)) {
1149             actualRepayAmount = IAvatarCErc20(_avatar).borrowBalanceCurrent(cToken);
1150         }
1151         underlying.safeTransferFrom(msg.sender, _avatar, actualRepayAmount);
1152         uint256 result = IAvatarCErc20(_avatar).repayBorrow(cToken, actualRepayAmount);
1153         require(result == 0, "BErc20: repayBorrow-failed");
1154         return result;
1155     }
1156 }