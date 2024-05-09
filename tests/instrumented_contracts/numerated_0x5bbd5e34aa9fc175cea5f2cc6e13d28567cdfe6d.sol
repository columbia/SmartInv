1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Interface of the ERC20 standard as defined in the EIP.
10  */
11 interface IERC20 {
12     /**
13      * @dev Emitted when `value` tokens are moved from one account (`from`) to
14      * another (`to`).
15      *
16      * Note that `value` may be zero.
17      */
18     event Transfer(address indexed from, address indexed to, uint256 value);
19 
20     /**
21      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
22      * a call to {approve}. `value` is the new allowance.
23      */
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 
26     /**
27      * @dev Returns the amount of tokens in existence.
28      */
29     function totalSupply() external view returns (uint256);
30 
31     /**
32      * @dev Returns the amount of tokens owned by `account`.
33      */
34     function balanceOf(address account) external view returns (uint256);
35 
36     /**
37      * @dev Moves `amount` tokens from the caller's account to `to`.
38      *
39      * Returns a boolean value indicating whether the operation succeeded.
40      *
41      * Emits a {Transfer} event.
42      */
43     function transfer(address to, uint256 amount) external returns (bool);
44 
45     /**
46      * @dev Returns the remaining number of tokens that `spender` will be
47      * allowed to spend on behalf of `owner` through {transferFrom}. This is
48      * zero by default.
49      *
50      * This value changes when {approve} or {transferFrom} are called.
51      */
52     function allowance(address owner, address spender) external view returns (uint256);
53 
54     /**
55      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * IMPORTANT: Beware that changing an allowance with this method brings the risk
60      * that someone may use both the old and the new allowance by unfortunate
61      * transaction ordering. One possible solution to mitigate this race
62      * condition is to first reduce the spender's allowance to 0 and set the
63      * desired value afterwards:
64      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
65      *
66      * Emits an {Approval} event.
67      */
68     function approve(address spender, uint256 amount) external returns (bool);
69 
70     /**
71      * @dev Moves `amount` tokens from `from` to `to` using the
72      * allowance mechanism. `amount` is then deducted from the caller's
73      * allowance.
74      *
75      * Returns a boolean value indicating whether the operation succeeded.
76      *
77      * Emits a {Transfer} event.
78      */
79     function transferFrom(address from, address to, uint256 amount) external returns (bool);
80 }
81 
82 // File: @openzeppelin/contracts/utils/Context.sol
83 
84 
85 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
86 
87 pragma solidity ^0.8.0;
88 
89 /**
90  * @dev Provides information about the current execution context, including the
91  * sender of the transaction and its data. While these are generally available
92  * via msg.sender and msg.data, they should not be accessed in such a direct
93  * manner, since when dealing with meta-transactions the account sending and
94  * paying for execution may not be the actual sender (as far as an application
95  * is concerned).
96  *
97  * This contract is only required for intermediate, library-like contracts.
98  */
99 abstract contract Context {
100     function _msgSender() internal view virtual returns (address) {
101         return msg.sender;
102     }
103 
104     function _msgData() internal view virtual returns (bytes calldata) {
105         return msg.data;
106     }
107 }
108 
109 // File: @openzeppelin/contracts/access/Ownable.sol
110 
111 
112 // OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)
113 
114 pragma solidity ^0.8.0;
115 
116 
117 /**
118  * @dev Contract module which provides a basic access control mechanism, where
119  * there is an account (an owner) that can be granted exclusive access to
120  * specific functions.
121  *
122  * By default, the owner account will be the one that deploys the contract. This
123  * can later be changed with {transferOwnership}.
124  *
125  * This module is used through inheritance. It will make available the modifier
126  * `onlyOwner`, which can be applied to your functions to restrict their use to
127  * the owner.
128  */
129 abstract contract Ownable is Context {
130     address private _owner;
131 
132     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
133 
134     /**
135      * @dev Initializes the contract setting the deployer as the initial owner.
136      */
137     constructor() {
138         _transferOwnership(_msgSender());
139     }
140 
141     /**
142      * @dev Throws if called by any account other than the owner.
143      */
144     modifier onlyOwner() {
145         _checkOwner();
146         _;
147     }
148 
149     /**
150      * @dev Returns the address of the current owner.
151      */
152     function owner() public view virtual returns (address) {
153         return _owner;
154     }
155 
156     /**
157      * @dev Throws if the sender is not the owner.
158      */
159     function _checkOwner() internal view virtual {
160         require(owner() == _msgSender(), "Ownable: caller is not the owner");
161     }
162 
163     /**
164      * @dev Leaves the contract without owner. It will not be possible to call
165      * `onlyOwner` functions. Can only be called by the current owner.
166      *
167      * NOTE: Renouncing ownership will leave the contract without an owner,
168      * thereby disabling any functionality that is only available to the owner.
169      */
170     function renounceOwnership() public virtual onlyOwner {
171         _transferOwnership(address(0));
172     }
173 
174     /**
175      * @dev Transfers ownership of the contract to a new account (`newOwner`).
176      * Can only be called by the current owner.
177      */
178     function transferOwnership(address newOwner) public virtual onlyOwner {
179         require(newOwner != address(0), "Ownable: new owner is the zero address");
180         _transferOwnership(newOwner);
181     }
182 
183     /**
184      * @dev Transfers ownership of the contract to a new account (`newOwner`).
185      * Internal function without access restriction.
186      */
187     function _transferOwnership(address newOwner) internal virtual {
188         address oldOwner = _owner;
189         _owner = newOwner;
190         emit OwnershipTransferred(oldOwner, newOwner);
191     }
192 }
193 
194 // File: @openzeppelin/contracts/utils/math/Math.sol
195 
196 
197 // OpenZeppelin Contracts (last updated v4.9.0) (utils/math/Math.sol)
198 
199 pragma solidity ^0.8.0;
200 
201 /**
202  * @dev Standard math utilities missing in the Solidity language.
203  */
204 library Math {
205     enum Rounding {
206         Down, // Toward negative infinity
207         Up, // Toward infinity
208         Zero // Toward zero
209     }
210 
211     /**
212      * @dev Returns the largest of two numbers.
213      */
214     function max(uint256 a, uint256 b) internal pure returns (uint256) {
215         return a > b ? a : b;
216     }
217 
218     /**
219      * @dev Returns the smallest of two numbers.
220      */
221     function min(uint256 a, uint256 b) internal pure returns (uint256) {
222         return a < b ? a : b;
223     }
224 
225     /**
226      * @dev Returns the average of two numbers. The result is rounded towards
227      * zero.
228      */
229     function average(uint256 a, uint256 b) internal pure returns (uint256) {
230         // (a + b) / 2 can overflow.
231         return (a & b) + (a ^ b) / 2;
232     }
233 
234     /**
235      * @dev Returns the ceiling of the division of two numbers.
236      *
237      * This differs from standard division with `/` in that it rounds up instead
238      * of rounding down.
239      */
240     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
241         // (a + b - 1) / b can overflow on addition, so we distribute.
242         return a == 0 ? 0 : (a - 1) / b + 1;
243     }
244 
245     /**
246      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
247      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
248      * with further edits by Uniswap Labs also under MIT license.
249      */
250     function mulDiv(uint256 x, uint256 y, uint256 denominator) internal pure returns (uint256 result) {
251         unchecked {
252             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
253             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
254             // variables such that product = prod1 * 2^256 + prod0.
255             uint256 prod0; // Least significant 256 bits of the product
256             uint256 prod1; // Most significant 256 bits of the product
257             assembly {
258                 let mm := mulmod(x, y, not(0))
259                 prod0 := mul(x, y)
260                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
261             }
262 
263             // Handle non-overflow cases, 256 by 256 division.
264             if (prod1 == 0) {
265                 // Solidity will revert if denominator == 0, unlike the div opcode on its own.
266                 // The surrounding unchecked block does not change this fact.
267                 // See https://docs.soliditylang.org/en/latest/control-structures.html#checked-or-unchecked-arithmetic.
268                 return prod0 / denominator;
269             }
270 
271             // Make sure the result is less than 2^256. Also prevents denominator == 0.
272             require(denominator > prod1, "Math: mulDiv overflow");
273 
274             ///////////////////////////////////////////////
275             // 512 by 256 division.
276             ///////////////////////////////////////////////
277 
278             // Make division exact by subtracting the remainder from [prod1 prod0].
279             uint256 remainder;
280             assembly {
281                 // Compute remainder using mulmod.
282                 remainder := mulmod(x, y, denominator)
283 
284                 // Subtract 256 bit number from 512 bit number.
285                 prod1 := sub(prod1, gt(remainder, prod0))
286                 prod0 := sub(prod0, remainder)
287             }
288 
289             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
290             // See https://cs.stackexchange.com/q/138556/92363.
291 
292             // Does not overflow because the denominator cannot be zero at this stage in the function.
293             uint256 twos = denominator & (~denominator + 1);
294             assembly {
295                 // Divide denominator by twos.
296                 denominator := div(denominator, twos)
297 
298                 // Divide [prod1 prod0] by twos.
299                 prod0 := div(prod0, twos)
300 
301                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
302                 twos := add(div(sub(0, twos), twos), 1)
303             }
304 
305             // Shift in bits from prod1 into prod0.
306             prod0 |= prod1 * twos;
307 
308             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
309             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
310             // four bits. That is, denominator * inv = 1 mod 2^4.
311             uint256 inverse = (3 * denominator) ^ 2;
312 
313             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
314             // in modular arithmetic, doubling the correct bits in each step.
315             inverse *= 2 - denominator * inverse; // inverse mod 2^8
316             inverse *= 2 - denominator * inverse; // inverse mod 2^16
317             inverse *= 2 - denominator * inverse; // inverse mod 2^32
318             inverse *= 2 - denominator * inverse; // inverse mod 2^64
319             inverse *= 2 - denominator * inverse; // inverse mod 2^128
320             inverse *= 2 - denominator * inverse; // inverse mod 2^256
321 
322             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
323             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
324             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
325             // is no longer required.
326             result = prod0 * inverse;
327             return result;
328         }
329     }
330 
331     /**
332      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
333      */
334     function mulDiv(uint256 x, uint256 y, uint256 denominator, Rounding rounding) internal pure returns (uint256) {
335         uint256 result = mulDiv(x, y, denominator);
336         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
337             result += 1;
338         }
339         return result;
340     }
341 
342     /**
343      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
344      *
345      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
346      */
347     function sqrt(uint256 a) internal pure returns (uint256) {
348         if (a == 0) {
349             return 0;
350         }
351 
352         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
353         //
354         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
355         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
356         //
357         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
358         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
359         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
360         //
361         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
362         uint256 result = 1 << (log2(a) >> 1);
363 
364         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
365         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
366         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
367         // into the expected uint128 result.
368         unchecked {
369             result = (result + a / result) >> 1;
370             result = (result + a / result) >> 1;
371             result = (result + a / result) >> 1;
372             result = (result + a / result) >> 1;
373             result = (result + a / result) >> 1;
374             result = (result + a / result) >> 1;
375             result = (result + a / result) >> 1;
376             return min(result, a / result);
377         }
378     }
379 
380     /**
381      * @notice Calculates sqrt(a), following the selected rounding direction.
382      */
383     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
384         unchecked {
385             uint256 result = sqrt(a);
386             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
387         }
388     }
389 
390     /**
391      * @dev Return the log in base 2, rounded down, of a positive value.
392      * Returns 0 if given 0.
393      */
394     function log2(uint256 value) internal pure returns (uint256) {
395         uint256 result = 0;
396         unchecked {
397             if (value >> 128 > 0) {
398                 value >>= 128;
399                 result += 128;
400             }
401             if (value >> 64 > 0) {
402                 value >>= 64;
403                 result += 64;
404             }
405             if (value >> 32 > 0) {
406                 value >>= 32;
407                 result += 32;
408             }
409             if (value >> 16 > 0) {
410                 value >>= 16;
411                 result += 16;
412             }
413             if (value >> 8 > 0) {
414                 value >>= 8;
415                 result += 8;
416             }
417             if (value >> 4 > 0) {
418                 value >>= 4;
419                 result += 4;
420             }
421             if (value >> 2 > 0) {
422                 value >>= 2;
423                 result += 2;
424             }
425             if (value >> 1 > 0) {
426                 result += 1;
427             }
428         }
429         return result;
430     }
431 
432     /**
433      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
434      * Returns 0 if given 0.
435      */
436     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
437         unchecked {
438             uint256 result = log2(value);
439             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
440         }
441     }
442 
443     /**
444      * @dev Return the log in base 10, rounded down, of a positive value.
445      * Returns 0 if given 0.
446      */
447     function log10(uint256 value) internal pure returns (uint256) {
448         uint256 result = 0;
449         unchecked {
450             if (value >= 10 ** 64) {
451                 value /= 10 ** 64;
452                 result += 64;
453             }
454             if (value >= 10 ** 32) {
455                 value /= 10 ** 32;
456                 result += 32;
457             }
458             if (value >= 10 ** 16) {
459                 value /= 10 ** 16;
460                 result += 16;
461             }
462             if (value >= 10 ** 8) {
463                 value /= 10 ** 8;
464                 result += 8;
465             }
466             if (value >= 10 ** 4) {
467                 value /= 10 ** 4;
468                 result += 4;
469             }
470             if (value >= 10 ** 2) {
471                 value /= 10 ** 2;
472                 result += 2;
473             }
474             if (value >= 10 ** 1) {
475                 result += 1;
476             }
477         }
478         return result;
479     }
480 
481     /**
482      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
483      * Returns 0 if given 0.
484      */
485     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
486         unchecked {
487             uint256 result = log10(value);
488             return result + (rounding == Rounding.Up && 10 ** result < value ? 1 : 0);
489         }
490     }
491 
492     /**
493      * @dev Return the log in base 256, rounded down, of a positive value.
494      * Returns 0 if given 0.
495      *
496      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
497      */
498     function log256(uint256 value) internal pure returns (uint256) {
499         uint256 result = 0;
500         unchecked {
501             if (value >> 128 > 0) {
502                 value >>= 128;
503                 result += 16;
504             }
505             if (value >> 64 > 0) {
506                 value >>= 64;
507                 result += 8;
508             }
509             if (value >> 32 > 0) {
510                 value >>= 32;
511                 result += 4;
512             }
513             if (value >> 16 > 0) {
514                 value >>= 16;
515                 result += 2;
516             }
517             if (value >> 8 > 0) {
518                 result += 1;
519             }
520         }
521         return result;
522     }
523 
524     /**
525      * @dev Return the log in base 256, following the selected rounding direction, of a positive value.
526      * Returns 0 if given 0.
527      */
528     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
529         unchecked {
530             uint256 result = log256(value);
531             return result + (rounding == Rounding.Up && 1 << (result << 3) < value ? 1 : 0);
532         }
533     }
534 }
535 
536 // File: supermarket/contracts/stake.sol
537 
538 //SPDX-License-Identifier: MIT
539 pragma solidity 0.8.8;
540 pragma experimental ABIEncoderV2;
541 
542 //import "@openzeppelin/contracts/math/SafeMath.sol";
543 
544 
545 
546 interface IMarket{
547     function claimTrade(uint256 epoch, uint256 amt,uint256 cp,address claimer,bytes memory signature) payable external;
548     function claimMeme(uint256 epoch, uint256 amt,uint256 lp,uint256 cp,bytes memory signature,address cFor) external;
549 }
550 
551 contract StakeFixedAPYDuration is Ownable {
552     //using SafeMath for uint256;
553     //using SafeERC20 for IERC20;
554     IERC20 public stakeToken;
555 
556     uint256 public duration = 0;
557     uint256 public unboundingDuration = 0;
558     uint256 private _totalSupply;
559     uint256 public taxCollectedFromUnstake = 0;
560     uint256 public periodFinish = 0;
561     uint256 public constant DENOMINATOR = 10000;
562     uint256 public constant SECONDS_IN_YEAR = 365 days;
563     uint256 public constant MIN_MAT_PERIOD = 3 days; // set to 3 days.
564     uint256 public beforeMaturityUnstakeTaxNumerator = 500;
565     uint256 public totalEthReward;
566     uint256 private MIN_STAKE = 10000 * 10**18;
567     address public rewardDistribution;
568     address public trade;
569     address public memecoin;
570 
571 
572 
573     bool public isStakingStarted = false;
574 
575     // Represents a single unstake for a user. A user may have multiple.
576     struct Unstake {
577         uint256 unstakingAmount;
578         uint256 unstakingTime;
579     }
580 
581     /**
582 	User Data
583 	 */
584     struct UserData {
585         uint256 stakeToken;
586         uint256 rewards;
587         uint256 lastUpdateTime;
588         //uint256 duration;
589         uint256 stakingTime;
590     }
591 
592     mapping(address => UserData) public users;
593     // The collection of unstakes for each user.
594     mapping(address => Unstake) public userUnstake;
595 
596     // Time Duration & APR
597     //mapping(uint256 => uint256) public monthlyAPR;
598     uint256 private annualAPY;
599 
600     event Staked(address indexed user, uint256 amount);
601     event Unstaked(address indexed user, uint256 amount);
602     event RewardPaid(address indexed user, uint256 reward);
603     event RecoverToken(address indexed token, uint256 indexed amount);
604     event UnstakeAmountClaimed(address indexed user, uint256 amount);
605     event RewardDistributionStarted(uint256 periodFinish);
606     event RewardReInvested(address indexed user, uint256 reward);
607     event UnstakeTaxCollected(uint256 indexed amount);
608     modifier onlyRewardDistributor() {
609         require(
610             _msgSender() == rewardDistribution,
611             "Caller is not reward distribution"
612         );
613         _;
614     }
615 
616     modifier updateReward(address account) {
617         if (account != address(0)) {
618             users[account].rewards = earned(account);
619         }
620         users[account].lastUpdateTime = lastTimeRewardApplicable();
621         _;
622     }
623 
624     constructor(
625         IERC20 _stakeToken,
626         uint256 _duration,
627         uint256 _unboundingDuration,
628         address s,
629         address m
630 
631     )  {
632        // require(_forwarder != address(0), "Forwarder cannot be empty");
633         stakeToken = _stakeToken;
634         duration = _duration;
635         unboundingDuration = _unboundingDuration;
636         //trustedForwarder = _forwarder;
637         trade=s;
638         memecoin=m;
639         annualAPY = 20000;//200% APY
640     }
641 
642     // function _msgSender()
643     //     internal
644     //     view
645     //     virtual
646     //     override(BaseRelayRecipient, Context)
647     //     returns (address payable)
648     // {
649     //     return BaseRelayRecipient._msgSender();
650     // }
651 
652     function versionRecipient()
653         external
654         view
655         virtual
656         returns (string memory)
657     {}
658 
659     function getUserData(address addr)
660         external
661         view
662         returns (UserData memory user)
663     {
664         return users[addr];
665     }
666 
667     function lastTimeRewardApplicable() public view returns (uint256) {
668         return Math.min(block.timestamp, periodFinish);
669     }
670 
671     function earned(address account) public view returns (uint256) {
672         uint256 earnedFromStakeCoin = users[account]
673             .stakeToken * (lastTimeRewardApplicable()-(users[account].lastUpdateTime)) * (getAnnualAPY());
674 
675         return
676             (earnedFromStakeCoin)/(DENOMINATOR)/(SECONDS_IN_YEAR)+(
677                 users[account].rewards
678             );
679     }
680 
681     function stake(uint256 amount)
682         external
683         updateReward(_msgSender())
684     {
685         require(isStakingStarted, "Staking is not started yet");
686         require(amount > 0, "Cannot stake 0");
687         require(block.timestamp<periodFinish,"Staking period over");
688         // require(
689         //     users[_msgSender()].duration <= months,
690         //     "New staking duration must be greater than equal to previous staking duration"
691         // );
692         _totalSupply += (amount);
693 
694         users[_msgSender()].stakeToken = users[_msgSender()].stakeToken+(
695             amount
696         );
697         //users[_msgSender()].duration = months;
698         users[_msgSender()].stakingTime = block.timestamp;
699         stakeToken.transferFrom(_msgSender(), address(this), amount);
700         emit Staked(_msgSender(), amount);
701     }
702 
703     function unstakeFor(address userAddress, uint256 amount, bool taxFlag)
704         external
705         onlyRewardDistributor updateReward(userAddress)
706     {
707         require(amount > 0, "Cannot withdraw 0");
708         require(
709             users[userAddress].stakeToken >= amount,
710             "User does not have sufficient balance"
711         );
712         users[userAddress].stakeToken = users[userAddress].stakeToken -(
713             amount
714         );
715 
716         if (taxFlag == true) {
717             uint256 beforeMaturityUnstakeTax = amount
718                 * (beforeMaturityUnstakeTaxNumerator)
719                 /(DENOMINATOR);
720             amount -= beforeMaturityUnstakeTax;
721             taxCollectedFromUnstake += beforeMaturityUnstakeTax;
722         } else {
723             require(
724                 users[userAddress].stakingTime + (
725                      (MIN_MAT_PERIOD)
726                 ) <= block.timestamp,
727                 "Cannot withdraw before maturity"
728             );
729         }
730         _unstake(userAddress, amount);
731     }
732 
733     function unstake(uint256 amount)
734         public
735         updateReward(_msgSender())
736     {
737         require(amount > 0, "Cannot withdraw 0");
738         require(
739             users[_msgSender()].stakeToken >= amount,
740             "User does not have sufficient balance"
741         );
742         require(
743             users[_msgSender()].stakingTime + (
744                  (MIN_MAT_PERIOD)
745             ) <= block.timestamp,
746             "Cannot withdraw before maturity"
747         );
748         users[_msgSender()].stakeToken = users[_msgSender()].stakeToken -(
749             amount
750         );
751         _unstake(_msgSender(), amount);
752     }
753 
754     function setTradeMemeAddress(address t,address m) onlyRewardDistributor public {
755         trade = t;
756         memecoin=m;
757     }
758 
759     function _unstake(address userAddress, uint256 amount)
760         internal
761     {
762         uint256 myShare = amount*(DENOMINATOR)/_totalSupply;
763         myShare = (totalEthReward*myShare)/(DENOMINATOR);
764         totalEthReward=totalEthReward-myShare;
765         _totalSupply = _totalSupply -(amount);
766 
767         getReward();
768 
769         if (unboundingDuration == 0) {
770             stakeToken.transfer(userAddress, amount);
771             sendETHValue(payable(userAddress), myShare);
772             
773         } else {
774             uint256 unboundingPeriodFinish = block.timestamp + (
775                 unboundingDuration
776             );
777             Unstake storage accountUnstake = userUnstake[userAddress];
778             accountUnstake.unstakingAmount = (accountUnstake.unstakingAmount)
779                 +(amount);
780             accountUnstake.unstakingTime = unboundingPeriodFinish;
781         }
782 
783         emit Unstaked(userAddress, amount);
784     }
785 
786     function reinvest() external {
787         _reinvest(_msgSender());
788     }
789 
790     function reinvestFor(address user) external onlyRewardDistributor {
791         _reinvest(user);
792     }
793 
794     function _reinvest(address user) internal updateReward(user) {
795         uint256 reward = users[user].rewards;
796         if (reward > 0) {
797             users[user].rewards = 0;
798             users[user].stakeToken = users[user].stakeToken+(reward);
799             _totalSupply = _totalSupply+(reward);
800             emit RewardReInvested(user, reward);
801         }
802     }
803 
804     function getAnnualAPY()
805         public
806         view
807         returns (uint256)
808     {
809         //uint256 months = users[account].duration;
810         return annualAPY;
811     }
812 
813     function claimUnstakedAmount() external {
814         Unstake storage accountUnstake = userUnstake[_msgSender()];
815 
816         require(
817             accountUnstake.unstakingAmount > 0,
818             "No unstaked amount to claim"
819         );
820         require(
821             block.timestamp >= accountUnstake.unstakingTime,
822             "Unbounding period not finished"
823         );
824 
825         uint256 _totalUnstakedAmount = accountUnstake.unstakingAmount;
826 
827         accountUnstake.unstakingAmount = 0;
828         accountUnstake.unstakingTime = 0;
829 
830         stakeToken.transfer(_msgSender(), _totalUnstakedAmount);
831         emit UnstakeAmountClaimed(_msgSender(), _totalUnstakedAmount);
832     }
833     //earn by claims
834     function earnClaims(address s,uint256 epoch, uint256 amt,uint256 cp,uint256 lp,address claimer,bytes memory signature) external payable {
835         require(users[msg.sender].stakeToken > MIN_STAKE ,"Min Eligiblity 10k");
836         if(s == memecoin){
837         IMarket(s).claimMeme( epoch, amt, lp, cp, signature, claimer); 
838         }else if(s == trade){
839             IMarket(s).claimTrade(epoch,amt,cp,claimer,signature);
840         }
841         return;
842     }
843 
844     function totalUnstakedAmountReadyToClaim(address user)
845         external
846         view
847         returns (uint256)
848     {
849         if (block.timestamp >= userUnstake[user].unstakingTime) {
850             return userUnstake[user].unstakingAmount;
851         }
852         return 0;
853     }
854 
855     function totalUnstakedAmount(address user) external view returns (uint256) {
856         return userUnstake[user].unstakingAmount;
857     }
858 
859     function getUnboundingTime(address user) external view returns (uint256) {
860         return userUnstake[user].unstakingTime;
861     }
862 
863     function exit() external {
864         unstake(users[_msgSender()].stakeToken);
865         getReward();
866     }
867 
868     function getReward() public updateReward(_msgSender()) {
869         uint256 reward = users[_msgSender()].rewards;
870         if (reward > 0) {
871             users[_msgSender()].rewards = 0;
872             stakeToken.transfer(_msgSender(), reward);
873             emit RewardPaid(_msgSender(), reward);
874         }
875     }
876     //Start Staking
877     function notifyRewardDistribution()
878         external
879         onlyRewardDistributor
880         updateReward(address(0))
881     {
882         require(!isStakingStarted, "Staking is already started");
883         isStakingStarted = true;
884         periodFinish = block.timestamp+(duration);
885         emit RewardDistributionStarted(periodFinish);
886     }
887 
888     function setAPY( uint256 apr)
889         external
890         onlyRewardDistributor
891     {
892         require(apr > 0, "month can not be 0");
893         annualAPY = apr;
894     }
895 
896     function setRewardDistribution(address _rewardDistribution)
897         external
898         onlyOwner
899     {
900         rewardDistribution = _rewardDistribution;
901     }
902 
903     function setDuration(uint256 _duration) external onlyRewardDistributor {
904         duration = _duration;
905         periodFinish = block.timestamp+(duration);
906     }
907 
908     function setUnboundingDuration(uint256 _unboundingDuration)
909         external
910         onlyRewardDistributor
911     {
912         unboundingDuration = _unboundingDuration;
913     }
914 
915     function setBeforeMaturityUnstakeTaxNumerator(
916         uint256 _beforeMaturityUnstakeTaxNumerator
917     ) external onlyRewardDistributor {
918         beforeMaturityUnstakeTaxNumerator = _beforeMaturityUnstakeTaxNumerator;
919     }
920 
921     function stopRewardDistribution() external onlyRewardDistributor {
922         periodFinish = block.timestamp;
923     }
924 
925     function updateRewardFor(
926         address[] memory beneficiary,
927         uint256[] memory rewards
928     ) external onlyRewardDistributor {
929         require(beneficiary.length == rewards.length, "Input length invalid");
930         for (uint256 i = 0; i < beneficiary.length; i++) {
931             users[beneficiary[i]].rewards = (users[beneficiary[i]].rewards)+(
932                 rewards[i]
933             );
934         }
935     }
936 
937     function totalSupply() public view returns (uint256) {
938         return _totalSupply;
939     }
940 
941     function collectUnstakeTax() external onlyRewardDistributor {
942         uint256 tax = taxCollectedFromUnstake;
943         taxCollectedFromUnstake = 0;
944         IERC20(stakeToken).transfer(_msgSender(), tax);
945         emit UnstakeTaxCollected(tax);
946     }
947 
948     function recoverExcessToken(address token, uint256 amount)
949         external
950         onlyRewardDistributor
951     {
952         IERC20(token).transfer(_msgSender(), amount);
953         emit RecoverToken(token, amount);
954     }
955     function sendETHValue(address payable recipient, uint256 amount) internal {
956         require(address(this).balance >= amount, "Address: insufficient balance");
957 
958         (bool success, ) = recipient.call{value: amount}("");
959         require(success, "Address: unable to send value, recipient may have reverted");
960     }
961     receive() payable external{
962         totalEthReward+=msg.value;
963     }
964 }