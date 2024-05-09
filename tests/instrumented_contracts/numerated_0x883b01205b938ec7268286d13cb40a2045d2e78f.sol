1 pragma solidity ^0.5.17;
2 pragma experimental ABIEncoderV2;
3 
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
19     /**
20      * @dev Returns the addition of two unsigned integers, reverting on
21      * overflow.
22      *
23      * Counterpart to Solidity's `+` operator.
24      *
25      * Requirements:
26      * - Addition cannot overflow.
27      */
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         require(c >= a, "SafeMath: addition overflow");
31 
32         return c;
33     }
34 
35     /**
36      * @dev Returns the subtraction of two unsigned integers, reverting on
37      * overflow (when the result is negative).
38      *
39      * Counterpart to Solidity's `-` operator.
40      *
41      * Requirements:
42      * - Subtraction cannot overflow.
43      */
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         return sub(a, b, "SafeMath: subtraction overflow");
46     }
47 
48     /**
49      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
50      * overflow (when the result is negative).
51      *
52      * Counterpart to Solidity's `-` operator.
53      *
54      * Requirements:
55      * - Subtraction cannot overflow.
56      *
57      * _Available since v2.4.0._
58      */
59     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
60         require(b <= a, errorMessage);
61         uint256 c = a - b;
62 
63         return c;
64     }
65 
66     /**
67      * @dev Returns the multiplication of two unsigned integers, reverting on
68      * overflow.
69      *
70      * Counterpart to Solidity's `*` operator.
71      *
72      * Requirements:
73      * - Multiplication cannot overflow.
74      */
75     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
76         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
77         // benefit is lost if 'b' is also tested.
78         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
79         if (a == 0) {
80             return 0;
81         }
82 
83         uint256 c = a * b;
84         require(c / a == b, "SafeMath: multiplication overflow");
85 
86         return c;
87     }
88 
89     /**
90      * @dev Returns the integer division of two unsigned integers. Reverts on
91      * division by zero. The result is rounded towards zero.
92      *
93      * Counterpart to Solidity's `/` operator. Note: this function uses a
94      * `revert` opcode (which leaves remaining gas untouched) while Solidity
95      * uses an invalid opcode to revert (consuming all remaining gas).
96      *
97      * Requirements:
98      * - The divisor cannot be zero.
99      */
100     function div(uint256 a, uint256 b) internal pure returns (uint256) {
101         return div(a, b, "SafeMath: division by zero");
102     }
103 
104     /**
105      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
106      * division by zero. The result is rounded towards zero.
107      *
108      * Counterpart to Solidity's `/` operator. Note: this function uses a
109      * `revert` opcode (which leaves remaining gas untouched) while Solidity
110      * uses an invalid opcode to revert (consuming all remaining gas).
111      *
112      * Requirements:
113      * - The divisor cannot be zero.
114      *
115      * _Available since v2.4.0._
116      */
117     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
118         // Solidity only automatically asserts when dividing by 0
119         require(b > 0, errorMessage);
120         uint256 c = a / b;
121         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
122 
123         return c;
124     }
125 
126     /**
127      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
128      * Reverts when dividing by zero.
129      *
130      * Counterpart to Solidity's `%` operator. This function uses a `revert`
131      * opcode (which leaves remaining gas untouched) while Solidity uses an
132      * invalid opcode to revert (consuming all remaining gas).
133      *
134      * Requirements:
135      * - The divisor cannot be zero.
136      */
137     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
138         return mod(a, b, "SafeMath: modulo by zero");
139     }
140 
141     /**
142      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
143      * Reverts with custom message when dividing by zero.
144      *
145      * Counterpart to Solidity's `%` operator. This function uses a `revert`
146      * opcode (which leaves remaining gas untouched) while Solidity uses an
147      * invalid opcode to revert (consuming all remaining gas).
148      *
149      * Requirements:
150      * - The divisor cannot be zero.
151      *
152      * _Available since v2.4.0._
153      */
154     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
155         require(b != 0, errorMessage);
156         return a % b;
157     }
158 }
159 
160 /*
161  * @dev Provides information about the current execution context, including the
162  * sender of the transaction and its data. While these are generally available
163  * via msg.sender and msg.data, they should not be accessed in such a direct
164  * manner, since when dealing with GSN meta-transactions the account sending and
165  * paying for execution may not be the actual sender (as far as an application
166  * is concerned).
167  *
168  * This contract is only required for intermediate, library-like contracts.
169  */
170 contract Context {
171     // Empty internal constructor, to prevent people from mistakenly deploying
172     // an instance of this contract, which should be used via inheritance.
173     constructor () internal { }
174     // solhint-disable-previous-line no-empty-blocks
175 
176     function _msgSender() internal view returns (address payable) {
177         return msg.sender;
178     }
179 
180     function _msgData() internal view returns (bytes memory) {
181         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
182         return msg.data;
183     }
184 }
185 
186 /**
187  * @dev Contract module which provides a basic access control mechanism, where
188  * there is an account (an owner) that can be granted exclusive access to
189  * specific functions.
190  *
191  * This module is used through inheritance. It will make available the modifier
192  * `onlyOwner`, which can be applied to your functions to restrict their use to
193  * the owner.
194  */
195 contract Ownable is Context {
196     address private _owner;
197 
198     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
199 
200     /**
201      * @dev Initializes the contract setting the deployer as the initial owner.
202      */
203     constructor () internal {
204         address msgSender = _msgSender();
205         _owner = msgSender;
206         emit OwnershipTransferred(address(0), msgSender);
207     }
208 
209     /**
210      * @dev Returns the address of the current owner.
211      */
212     function owner() public view returns (address) {
213         return _owner;
214     }
215 
216     /**
217      * @dev Throws if called by any account other than the owner.
218      */
219     modifier onlyOwner() {
220         require(isOwner(), "Ownable: caller is not the owner");
221         _;
222     }
223 
224     /**
225      * @dev Returns true if the caller is the current owner.
226      */
227     function isOwner() public view returns (bool) {
228         return _msgSender() == _owner;
229     }
230 
231     /**
232      * @dev Leaves the contract without owner. It will not be possible to call
233      * `onlyOwner` functions anymore. Can only be called by the current owner.
234      *
235      * NOTE: Renouncing ownership will leave the contract without an owner,
236      * thereby removing any functionality that is only available to the owner.
237      */
238     function renounceOwnership() public onlyOwner {
239         emit OwnershipTransferred(_owner, address(0));
240         _owner = address(0);
241     }
242 
243     /**
244      * @dev Transfers ownership of the contract to a new account (`newOwner`).
245      * Can only be called by the current owner.
246      */
247     function transferOwnership(address newOwner) public onlyOwner {
248         _transferOwnership(newOwner);
249     }
250 
251     /**
252      * @dev Transfers ownership of the contract to a new account (`newOwner`).
253      */
254     function _transferOwnership(address newOwner) internal {
255         require(newOwner != address(0), "Ownable: new owner is the zero address");
256         emit OwnershipTransferred(_owner, newOwner);
257         _owner = newOwner;
258     }
259 }
260 
261 /**
262  * @title Decimal
263  * @author dYdX
264  *
265  * Library that defines a fixed-point number with 18 decimal places.
266  */
267 library Decimal {
268     using SafeMath for uint256;
269 
270     // ============ Constants ============
271 
272     uint256 constant BASE = 10**18;
273 
274     // ============ Structs ============
275 
276     struct D256 {
277         uint256 value;
278     }
279 
280     // ============ Static Functions ============
281 
282     function zero() internal pure returns (D256 memory) {
283         return D256({value: 0});
284     }
285 
286     function one() internal pure returns (D256 memory) {
287         return D256({value: BASE});
288     }
289 
290     function from(uint256 a) internal pure returns (D256 memory) {
291         return D256({value: a.mul(BASE)});
292     }
293 
294     function ratio(uint256 a, uint256 b) internal pure returns (D256 memory) {
295         return D256({value: getPartial(a, BASE, b)});
296     }
297 
298     // ============ Self Functions ============
299 
300     function add(D256 memory self, uint256 b)
301         internal
302         pure
303         returns (D256 memory)
304     {
305         return D256({value: self.value.add(b.mul(BASE))});
306     }
307 
308     function sub(D256 memory self, uint256 b)
309         internal
310         pure
311         returns (D256 memory)
312     {
313         return D256({value: self.value.sub(b.mul(BASE))});
314     }
315 
316     function sub(
317         D256 memory self,
318         uint256 b,
319         string memory reason
320     ) internal pure returns (D256 memory) {
321         return D256({value: self.value.sub(b.mul(BASE), reason)});
322     }
323 
324     function mul(D256 memory self, uint256 b)
325         internal
326         pure
327         returns (D256 memory)
328     {
329         return D256({value: self.value.mul(b)});
330     }
331 
332     function div(D256 memory self, uint256 b)
333         internal
334         pure
335         returns (D256 memory)
336     {
337         return D256({value: self.value.div(b)});
338     }
339 
340     function pow(D256 memory self, uint256 b)
341         internal
342         pure
343         returns (D256 memory)
344     {
345         if (b == 0) {
346             return from(1);
347         }
348 
349         D256 memory temp = D256({value: self.value});
350         for (uint256 i = 1; i < b; i++) {
351             temp = mul(temp, self);
352         }
353 
354         return temp;
355     }
356 
357     function add(D256 memory self, D256 memory b)
358         internal
359         pure
360         returns (D256 memory)
361     {
362         return D256({value: self.value.add(b.value)});
363     }
364 
365     function sub(D256 memory self, D256 memory b)
366         internal
367         pure
368         returns (D256 memory)
369     {
370         return D256({value: self.value.sub(b.value)});
371     }
372 
373     function sub(
374         D256 memory self,
375         D256 memory b,
376         string memory reason
377     ) internal pure returns (D256 memory) {
378         return D256({value: self.value.sub(b.value, reason)});
379     }
380 
381     function mul(D256 memory self, D256 memory b)
382         internal
383         pure
384         returns (D256 memory)
385     {
386         return D256({value: getPartial(self.value, b.value, BASE)});
387     }
388 
389     function div(D256 memory self, D256 memory b)
390         internal
391         pure
392         returns (D256 memory)
393     {
394         return D256({value: getPartial(self.value, BASE, b.value)});
395     }
396 
397     function equals(D256 memory self, D256 memory b)
398         internal
399         pure
400         returns (bool)
401     {
402         return self.value == b.value;
403     }
404 
405     function greaterThan(D256 memory self, D256 memory b)
406         internal
407         pure
408         returns (bool)
409     {
410         return compareTo(self, b) == 2;
411     }
412 
413     function lessThan(D256 memory self, D256 memory b)
414         internal
415         pure
416         returns (bool)
417     {
418         return compareTo(self, b) == 0;
419     }
420 
421     function greaterThanOrEqualTo(D256 memory self, D256 memory b)
422         internal
423         pure
424         returns (bool)
425     {
426         return compareTo(self, b) > 0;
427     }
428 
429     function lessThanOrEqualTo(D256 memory self, D256 memory b)
430         internal
431         pure
432         returns (bool)
433     {
434         return compareTo(self, b) < 2;
435     }
436 
437     function isZero(D256 memory self) internal pure returns (bool) {
438         return self.value == 0;
439     }
440 
441     function asUint256(D256 memory self) internal pure returns (uint256) {
442         return self.value.div(BASE);
443     }
444 
445     // ============ Core Methods ============
446 
447     function getPartial(
448         uint256 target,
449         uint256 numerator,
450         uint256 denominator
451     ) private pure returns (uint256) {
452         return target.mul(numerator).div(denominator);
453     }
454 
455     function compareTo(D256 memory a, D256 memory b)
456         private
457         pure
458         returns (uint256)
459     {
460         if (a.value == b.value) {
461             return 1;
462         }
463         return a.value > b.value ? 2 : 0;
464     }
465 }
466 
467 library Constants {
468     /* Chain */
469     uint256 private constant CHAIN_ID = 1; // Mainnet
470 
471     /* Bootstrapping */
472     uint256 private constant BOOTSTRAPPING_PERIOD = 672; // 14 days
473     uint256 private constant BOOTSTRAPPING_PRICE = 1078280614764947472; // Should be 0.1 difference between peg
474 
475     /* Oracle */
476     address private constant CRV3 =
477         address(0x6c3F90f043a72FA612cbac8115EE7e52BDe6E490); // Anywhere the term CRV3 is refernenced, consider that as "peg", really
478     uint256 private constant ORACLE_RESERVE_MINIMUM = 1e22; // 10,000 T
479 
480     /* Bonding */
481     uint256 private constant INITIAL_STAKE_MULTIPLE = 1e6; // 100 T -> 100M TS
482 
483     /* Epoch */
484     struct EpochStrategy {
485         uint256 offset;
486         uint256 start;
487         uint256 period;
488     }
489 
490     uint256 private constant CURRENT_EPOCH_OFFSET = 0;
491     uint256 private constant CURRENT_EPOCH_START = 1667790000;
492     uint256 private constant CURRENT_EPOCH_PERIOD = 1800;
493 
494     /* Forge */
495     uint256 private constant ADVANCE_INCENTIVE_IN_3CRV = 75 * 10**18; // 75 3CRV
496     uint256 private constant ADVANCE_INCENTIVE_IN_T_MAX = 5000 * 10**18; // 5000 T
497 
498     uint256 private constant FORGE_EXIT_LOCKUP_EPOCHS = 240; // 5 days fluid
499 
500     /* Pool */
501     uint256 private constant POOL_EXIT_LOCKUP_EPOCHS = 144; // 3 days fluid
502 
503     /* Market */
504     uint256 private constant COUPON_EXPIRATION = 8640; // 180 days
505     uint256 private constant DEBT_RATIO_CAP = 20e16; // 20%
506 
507     /* Regulator */
508     uint256 private constant SUPPLY_CHANGE_LIMIT = 1e16; // 1%
509     uint256 private constant COUPON_SUPPLY_CHANGE_LIMIT = 2e16; // 2%
510     uint256 private constant ORACLE_POOL_RATIO = 50; // 50%
511     uint256 private constant TREASURY_RATIO = 0; // 0%
512 
513     /* Deployed */
514     address private constant TREASURY_ADDRESS =
515         address(0x0000000000000000000000000000000000000000);
516 
517     /**
518      * Getters
519      */
520 
521     function getCrv3Address() internal pure returns (address) {
522         return CRV3;
523     }
524 
525     function getOracleReserveMinimum() internal pure returns (uint256) {
526         return ORACLE_RESERVE_MINIMUM;
527     }
528 
529     function getCurrentEpochStrategy()
530         internal
531         pure
532         returns (EpochStrategy memory)
533     {
534         return
535             EpochStrategy({
536                 offset: CURRENT_EPOCH_OFFSET,
537                 start: CURRENT_EPOCH_START,
538                 period: CURRENT_EPOCH_PERIOD
539             });
540     }
541 
542     function getInitialStakeMultiple() internal pure returns (uint256) {
543         return INITIAL_STAKE_MULTIPLE;
544     }
545 
546     function getBootstrappingPeriod() internal pure returns (uint256) {
547         return BOOTSTRAPPING_PERIOD;
548     }
549 
550     function getBootstrappingPrice()
551         internal
552         pure
553         returns (Decimal.D256 memory)
554     {
555         return Decimal.D256({value: BOOTSTRAPPING_PRICE});
556     }
557 
558     function getAdvanceIncentive() internal pure returns (uint256) {
559         return ADVANCE_INCENTIVE_IN_3CRV;
560     }
561 
562     function getMaxAdvanceTIncentive() internal pure returns (uint256) {
563         return ADVANCE_INCENTIVE_IN_T_MAX;
564     }
565 
566     function getForgeExitLockupEpochs() internal pure returns (uint256) {
567         return FORGE_EXIT_LOCKUP_EPOCHS;
568     }
569 
570     function getPoolExitLockupEpochs() internal pure returns (uint256) {
571         return POOL_EXIT_LOCKUP_EPOCHS;
572     }
573 
574     function getCouponExpiration() internal pure returns (uint256) {
575         return COUPON_EXPIRATION;
576     }
577 
578     function getDebtRatioCap() internal pure returns (Decimal.D256 memory) {
579         return Decimal.D256({value: DEBT_RATIO_CAP});
580     }
581 
582     function getSupplyChangeLimit()
583         internal
584         pure
585         returns (Decimal.D256 memory)
586     {
587         return Decimal.D256({value: SUPPLY_CHANGE_LIMIT});
588     }
589 
590     function getCouponSupplyChangeLimit()
591         internal
592         pure
593         returns (Decimal.D256 memory)
594     {
595         return Decimal.D256({value: COUPON_SUPPLY_CHANGE_LIMIT});
596     }
597 
598     function getOraclePoolRatio() internal pure returns (uint256) {
599         return ORACLE_POOL_RATIO;
600     }
601 
602     function getTreasuryRatio() internal pure returns (uint256) {
603         return TREASURY_RATIO;
604     }
605 
606     function getChainId() internal pure returns (uint256) {
607         return CHAIN_ID;
608     }
609 
610     function getTreasuryAddress() internal pure returns (address) {
611         return TREASURY_ADDRESS;
612     }
613 }
614 
615 contract Curve {
616     using SafeMath for uint256;
617     using Decimal for Decimal.D256;
618 
619     function calculateCouponPremium(
620         uint256 totalSupply,
621         uint256 totalDebt,
622         uint256 amount
623     ) internal pure returns (uint256) {
624         return
625             effectivePremium(totalSupply, totalDebt, amount)
626                 .mul(amount)
627                 .asUint256();
628     }
629 
630     function effectivePremium(
631         uint256 totalSupply,
632         uint256 totalDebt,
633         uint256 amount
634     ) private pure returns (Decimal.D256 memory) {
635         Decimal.D256 memory debtRatio = Decimal.ratio(totalDebt, totalSupply);
636         Decimal.D256 memory debtRatioUpperBound = Constants.getDebtRatioCap();
637 
638         uint256 totalSupplyEnd = totalSupply.sub(amount);
639         uint256 totalDebtEnd = totalDebt.sub(amount);
640         Decimal.D256 memory debtRatioEnd = Decimal.ratio(
641             totalDebtEnd,
642             totalSupplyEnd
643         );
644 
645         if (debtRatio.greaterThan(debtRatioUpperBound)) {
646             if (debtRatioEnd.greaterThan(debtRatioUpperBound)) {
647                 return curve(debtRatioUpperBound);
648             }
649 
650             Decimal.D256 memory premiumCurve = curveMean(
651                 debtRatioEnd,
652                 debtRatioUpperBound
653             );
654             Decimal.D256 memory premiumCurveDelta = debtRatioUpperBound.sub(
655                 debtRatioEnd
656             );
657             Decimal.D256 memory premiumFlat = curve(debtRatioUpperBound);
658             Decimal.D256 memory premiumFlatDelta = debtRatio.sub(
659                 debtRatioUpperBound
660             );
661             return
662                 (premiumCurve.mul(premiumCurveDelta))
663                     .add(premiumFlat.mul(premiumFlatDelta))
664                     .div(premiumCurveDelta.add(premiumFlatDelta));
665         }
666 
667         return curveMean(debtRatioEnd, debtRatio);
668     }
669 
670     // 1/(3(1-R)^2)-1/3
671     function curve(Decimal.D256 memory debtRatio)
672         private
673         pure
674         returns (Decimal.D256 memory)
675     {
676         return
677             Decimal
678                 .one()
679                 .div(Decimal.from(3).mul((Decimal.one().sub(debtRatio)).pow(2)))
680                 .sub(Decimal.ratio(1, 3));
681     }
682 
683     // 1/(3(1-R)(1-R'))-1/3
684     function curveMean(Decimal.D256 memory lower, Decimal.D256 memory upper)
685         private
686         pure
687         returns (Decimal.D256 memory)
688     {
689         if (lower.equals(upper)) {
690             return curve(lower);
691         }
692 
693         return
694             Decimal
695                 .one()
696                 .div(
697                     Decimal.from(3).mul(Decimal.one().sub(upper)).mul(
698                         Decimal.one().sub(lower)
699                     )
700                 )
701                 .sub(Decimal.ratio(1, 3));
702     }
703 }
704 
705 interface IUniswapV2Pair {
706     event Approval(address indexed owner, address indexed spender, uint value);
707     event Transfer(address indexed from, address indexed to, uint value);
708 
709     function name() external pure returns (string memory);
710     function symbol() external pure returns (string memory);
711     function decimals() external pure returns (uint8);
712     function totalSupply() external view returns (uint);
713     function balanceOf(address owner) external view returns (uint);
714     function allowance(address owner, address spender) external view returns (uint);
715 
716     function approve(address spender, uint value) external returns (bool);
717     function transfer(address to, uint value) external returns (bool);
718     function transferFrom(address from, address to, uint value) external returns (bool);
719 
720     function DOMAIN_SEPARATOR() external view returns (bytes32);
721     function PERMIT_TYPEHASH() external pure returns (bytes32);
722     function nonces(address owner) external view returns (uint);
723 
724     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
725 
726     event Mint(address indexed sender, uint amount0, uint amount1);
727     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
728     event Swap(
729         address indexed sender,
730         uint amount0In,
731         uint amount1In,
732         uint amount0Out,
733         uint amount1Out,
734         address indexed to
735     );
736     event Sync(uint112 reserve0, uint112 reserve1);
737 
738     function MINIMUM_LIQUIDITY() external pure returns (uint);
739     function factory() external view returns (address);
740     function token0() external view returns (address);
741     function token1() external view returns (address);
742     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
743     function price0CumulativeLast() external view returns (uint);
744     function price1CumulativeLast() external view returns (uint);
745     function kLast() external view returns (uint);
746 
747     function mint(address to) external returns (uint liquidity);
748     function burn(address to) external returns (uint amount0, uint amount1);
749     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
750     function skim(address to) external;
751     function sync() external;
752 
753     function initialize(address, address) external;
754 }
755 
756 /**
757  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
758  * the optional functions; to access them see {ERC20Detailed}.
759  */
760 interface IERC20 {
761     /**
762      * @dev Returns the amount of tokens in existence.
763      */
764     function totalSupply() external view returns (uint256);
765 
766     /**
767      * @dev Returns the amount of tokens owned by `account`.
768      */
769     function balanceOf(address account) external view returns (uint256);
770 
771     /**
772      * @dev Moves `amount` tokens from the caller's account to `recipient`.
773      *
774      * Returns a boolean value indicating whether the operation succeeded.
775      *
776      * Emits a {Transfer} event.
777      */
778     function transfer(address recipient, uint256 amount) external returns (bool);
779 
780     /**
781      * @dev Returns the remaining number of tokens that `spender` will be
782      * allowed to spend on behalf of `owner` through {transferFrom}. This is
783      * zero by default.
784      *
785      * This value changes when {approve} or {transferFrom} are called.
786      */
787     function allowance(address owner, address spender) external view returns (uint256);
788 
789     /**
790      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
791      *
792      * Returns a boolean value indicating whether the operation succeeded.
793      *
794      * IMPORTANT: Beware that changing an allowance with this method brings the risk
795      * that someone may use both the old and the new allowance by unfortunate
796      * transaction ordering. One possible solution to mitigate this race
797      * condition is to first reduce the spender's allowance to 0 and set the
798      * desired value afterwards:
799      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
800      *
801      * Emits an {Approval} event.
802      */
803     function approve(address spender, uint256 amount) external returns (bool);
804 
805     /**
806      * @dev Moves `amount` tokens from `sender` to `recipient` using the
807      * allowance mechanism. `amount` is then deducted from the caller's
808      * allowance.
809      *
810      * Returns a boolean value indicating whether the operation succeeded.
811      *
812      * Emits a {Transfer} event.
813      */
814     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
815 
816     /**
817      * @dev Emitted when `value` tokens are moved from one account (`from`) to
818      * another (`to`).
819      *
820      * Note that `value` may be zero.
821      */
822     event Transfer(address indexed from, address indexed to, uint256 value);
823 
824     /**
825      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
826      * a call to {approve}. `value` is the new allowance.
827      */
828     event Approval(address indexed owner, address indexed spender, uint256 value);
829 }
830 
831 contract IDollar is IERC20 {
832     function burn(uint256 amount) public;
833 
834     function burnFrom(address account, uint256 amount) public;
835 
836     function mint(address account, uint256 amount) public returns (bool);
837 }
838 
839 contract IOracle {
840 
841     function update() public;
842     function consult() public returns (Decimal.D256 memory, bool);
843     function averageDollarPrice() public returns (Decimal.D256 memory, bool);
844 
845     function pair() external view returns (address);
846 }
847 
848 contract Account {
849     enum Status {
850         Frozen,
851         Fluid,
852         Locked
853     }
854 
855     struct State {
856         uint256 staged;
857         uint256 balance;
858         mapping(uint256 => uint256) coupons;
859         mapping(address => uint256) couponAllowances;
860         uint256 fluidUntil;
861         uint256 lockedUntil;
862     }
863 }
864 
865 contract Epoch {
866     struct Global {
867         uint256 start;
868         uint256 period;
869         uint256 current;
870     }
871 
872     struct Coupons {
873         uint256 outstanding;
874         uint256 expiration;
875         uint256[] expiring;
876     }
877 
878     struct State {
879         uint256 bonded;
880         Coupons coupons;
881     }
882 }
883 
884 contract Candidate {
885     enum Vote {
886         UNDECIDED,
887         APPROVE,
888         REJECT
889     }
890 
891     struct State {
892         uint256 start;
893         uint256 period;
894         uint256 approve;
895         uint256 reject;
896         mapping(address => Vote) votes;
897         bool initialized;
898     }
899 }
900 
901 contract Storage {
902     struct Provider {
903         IDollar dollar;
904         IOracle oracle;
905         address pool;
906     }
907 
908     struct Balance {
909         uint256 supply;
910         uint256 bonded;
911         uint256 staged;
912         uint256 redeemable;
913         uint256 debt;
914         uint256 coupons;
915     }
916 
917     struct State {
918         Epoch.Global epoch;
919         Balance balance;
920         Provider provider;
921         mapping(address => Account.State) accounts;
922         mapping(uint256 => Epoch.State) epochs;
923         mapping(address => Candidate.State) candidates;
924     }
925 }
926 
927 contract State {
928     Storage.State _state;
929 }
930 
931 contract Getters is State {
932     using SafeMath for uint256;
933     using Decimal for Decimal.D256;
934 
935     bytes32 private constant IMPLEMENTATION_SLOT =
936         0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
937 
938     /**
939      * ERC20 Interface
940      */
941 
942     function name() public view returns (string memory) {
943         return "Titanium Shares";
944     }
945 
946     function symbol() public view returns (string memory) {
947         return "TS";
948     }
949 
950     function decimals() public view returns (uint8) {
951         return 18;
952     }
953 
954     function balanceOf(address account) public view returns (uint256) {
955         return _state.accounts[account].balance;
956     }
957 
958     function totalSupply() public view returns (uint256) {
959         return _state.balance.supply;
960     }
961 
962     function allowance(address owner, address spender)
963         external
964         view
965         returns (uint256)
966     {
967         return 0;
968     }
969 
970     /**
971      * Global
972      */
973 
974     function dollar() public view returns (IDollar) {
975         return _state.provider.dollar;
976     }
977 
978     function oracle() public view returns (IOracle) {
979         return _state.provider.oracle;
980     }
981 
982     function pool() public view returns (address) {
983         return _state.provider.pool;
984     }
985 
986     function totalBonded() public view returns (uint256) {
987         return _state.balance.bonded;
988     }
989 
990     function totalStaged() public view returns (uint256) {
991         return _state.balance.staged;
992     }
993 
994     function totalDebt() public view returns (uint256) {
995         return _state.balance.debt;
996     }
997 
998     function totalRedeemable() public view returns (uint256) {
999         return _state.balance.redeemable;
1000     }
1001 
1002     function totalCoupons() public view returns (uint256) {
1003         return _state.balance.coupons;
1004     }
1005 
1006     function totalNet() public view returns (uint256) {
1007         return dollar().totalSupply().sub(totalDebt());
1008     }
1009 
1010     /**
1011      * Account
1012      */
1013 
1014     function balanceOfStaged(address account) public view returns (uint256) {
1015         return _state.accounts[account].staged;
1016     }
1017 
1018     function balanceOfBonded(address account) public view returns (uint256) {
1019         uint256 totalSupply = totalSupply();
1020         if (totalSupply == 0) {
1021             return 0;
1022         }
1023         return totalBonded().mul(balanceOf(account)).div(totalSupply);
1024     }
1025 
1026     function balanceOfCoupons(address account, uint256 epoch)
1027         public
1028         view
1029         returns (uint256)
1030     {
1031         if (outstandingCoupons(epoch) == 0) {
1032             return 0;
1033         }
1034         return _state.accounts[account].coupons[epoch];
1035     }
1036 
1037     function statusOf(address account) public view returns (Account.Status) {
1038         if (_state.accounts[account].lockedUntil > epoch()) {
1039             return Account.Status.Locked;
1040         }
1041 
1042         return
1043             epoch() >= _state.accounts[account].fluidUntil
1044                 ? Account.Status.Frozen
1045                 : Account.Status.Fluid;
1046     }
1047 
1048     function fluidUntil(address account) public view returns (uint256) {
1049         return _state.accounts[account].fluidUntil;
1050     }
1051 
1052     function lockedUntil(address account) public view returns (uint256) {
1053         return _state.accounts[account].lockedUntil;
1054     }
1055 
1056     function allowanceCoupons(address owner, address spender)
1057         public
1058         view
1059         returns (uint256)
1060     {
1061         return _state.accounts[owner].couponAllowances[spender];
1062     }
1063 
1064     /**
1065      * Epoch
1066      */
1067 
1068     function epoch() public view returns (uint256) {
1069         return _state.epoch.current;
1070     }
1071 
1072     function epochTime() public view returns (uint256) {
1073         Constants.EpochStrategy memory current = Constants
1074             .getCurrentEpochStrategy();
1075 
1076         return epochTimeWithStrategy(current);
1077     }
1078 
1079     function epochTimeWithStrategy(Constants.EpochStrategy memory strategy)
1080         private
1081         view
1082         returns (uint256)
1083     {
1084         return
1085             blockTimestamp().sub(strategy.start).div(strategy.period).add(
1086                 strategy.offset
1087             );
1088     }
1089 
1090     // Overridable for testing
1091     function blockTimestamp() internal view returns (uint256) {
1092         return block.timestamp;
1093     }
1094 
1095     function outstandingCoupons(uint256 epoch) public view returns (uint256) {
1096         return _state.epochs[epoch].coupons.outstanding;
1097     }
1098 
1099     function couponsExpiration(uint256 epoch) public view returns (uint256) {
1100         return _state.epochs[epoch].coupons.expiration;
1101     }
1102 
1103     function expiringCoupons(uint256 epoch) public view returns (uint256) {
1104         return _state.epochs[epoch].coupons.expiring.length;
1105     }
1106 
1107     function expiringCouponsAtIndex(uint256 epoch, uint256 i)
1108         public
1109         view
1110         returns (uint256)
1111     {
1112         return _state.epochs[epoch].coupons.expiring[i];
1113     }
1114 
1115     function totalBondedAt(uint256 epoch) public view returns (uint256) {
1116         return _state.epochs[epoch].bonded;
1117     }
1118 
1119     function bootstrappingAt(uint256 epoch) public view returns (bool) {
1120         return epoch <= Constants.getBootstrappingPeriod();
1121     }
1122 }
1123 
1124 contract Setters is State, Getters {
1125     using SafeMath for uint256;
1126 
1127     event Transfer(address indexed from, address indexed to, uint256 value);
1128 
1129     /**
1130      * ERC20 Interface
1131      */
1132 
1133     function transfer(address recipient, uint256 amount)
1134         external
1135         returns (bool)
1136     {
1137         return false;
1138     }
1139 
1140     function approve(address spender, uint256 amount) external returns (bool) {
1141         return false;
1142     }
1143 
1144     function transferFrom(
1145         address sender,
1146         address recipient,
1147         uint256 amount
1148     ) external returns (bool) {
1149         return false;
1150     }
1151 
1152     /**
1153      * Global
1154      */
1155 
1156     function incrementTotalBonded(uint256 amount) internal {
1157         _state.balance.bonded = _state.balance.bonded.add(amount);
1158     }
1159 
1160     function decrementTotalBonded(uint256 amount, string memory reason)
1161         internal
1162     {
1163         _state.balance.bonded = _state.balance.bonded.sub(amount, reason);
1164     }
1165 
1166     function incrementTotalDebt(uint256 amount) internal {
1167         _state.balance.debt = _state.balance.debt.add(amount);
1168     }
1169 
1170     function decrementTotalDebt(uint256 amount, string memory reason) internal {
1171         _state.balance.debt = _state.balance.debt.sub(amount, reason);
1172     }
1173 
1174     function incrementTotalRedeemable(uint256 amount) internal {
1175         _state.balance.redeemable = _state.balance.redeemable.add(amount);
1176     }
1177 
1178     function decrementTotalRedeemable(uint256 amount, string memory reason)
1179         internal
1180     {
1181         _state.balance.redeemable = _state.balance.redeemable.sub(
1182             amount,
1183             reason
1184         );
1185     }
1186 
1187     /**
1188      * Account
1189      */
1190 
1191     function incrementBalanceOf(address account, uint256 amount) internal {
1192         _state.accounts[account].balance = _state.accounts[account].balance.add(
1193             amount
1194         );
1195         _state.balance.supply = _state.balance.supply.add(amount);
1196 
1197         emit Transfer(address(0), account, amount);
1198     }
1199 
1200     function decrementBalanceOf(
1201         address account,
1202         uint256 amount,
1203         string memory reason
1204     ) internal {
1205         _state.accounts[account].balance = _state.accounts[account].balance.sub(
1206             amount,
1207             reason
1208         );
1209         _state.balance.supply = _state.balance.supply.sub(amount, reason);
1210 
1211         emit Transfer(account, address(0), amount);
1212     }
1213 
1214     function incrementBalanceOfStaged(address account, uint256 amount)
1215         internal
1216     {
1217         _state.accounts[account].staged = _state.accounts[account].staged.add(
1218             amount
1219         );
1220         _state.balance.staged = _state.balance.staged.add(amount);
1221     }
1222 
1223     function decrementBalanceOfStaged(
1224         address account,
1225         uint256 amount,
1226         string memory reason
1227     ) internal {
1228         _state.accounts[account].staged = _state.accounts[account].staged.sub(
1229             amount,
1230             reason
1231         );
1232         _state.balance.staged = _state.balance.staged.sub(amount, reason);
1233     }
1234 
1235     function incrementBalanceOfCoupons(
1236         address account,
1237         uint256 epoch,
1238         uint256 amount
1239     ) internal {
1240         _state.accounts[account].coupons[epoch] = _state
1241             .accounts[account]
1242             .coupons[epoch]
1243             .add(amount);
1244         _state.epochs[epoch].coupons.outstanding = _state
1245             .epochs[epoch]
1246             .coupons
1247             .outstanding
1248             .add(amount);
1249         _state.balance.coupons = _state.balance.coupons.add(amount);
1250     }
1251 
1252     function decrementBalanceOfCoupons(
1253         address account,
1254         uint256 epoch,
1255         uint256 amount,
1256         string memory reason
1257     ) internal {
1258         _state.accounts[account].coupons[epoch] = _state
1259             .accounts[account]
1260             .coupons[epoch]
1261             .sub(amount, reason);
1262         _state.epochs[epoch].coupons.outstanding = _state
1263             .epochs[epoch]
1264             .coupons
1265             .outstanding
1266             .sub(amount, reason);
1267         _state.balance.coupons = _state.balance.coupons.sub(amount, reason);
1268     }
1269 
1270     function unfreeze(address account) internal {
1271         _state.accounts[account].fluidUntil = epoch().add(
1272             Constants.getForgeExitLockupEpochs()
1273         );
1274     }
1275 
1276     function updateAllowanceCoupons(
1277         address owner,
1278         address spender,
1279         uint256 amount
1280     ) internal {
1281         _state.accounts[owner].couponAllowances[spender] = amount;
1282     }
1283 
1284     function decrementAllowanceCoupons(
1285         address owner,
1286         address spender,
1287         uint256 amount,
1288         string memory reason
1289     ) internal {
1290         _state.accounts[owner].couponAllowances[spender] = _state
1291             .accounts[owner]
1292             .couponAllowances[spender]
1293             .sub(amount, reason);
1294     }
1295 
1296     /**
1297      * Epoch
1298      */
1299 
1300     function incrementEpoch() internal {
1301         _state.epoch.current = _state.epoch.current.add(1);
1302     }
1303 
1304     function snapshotTotalBonded() internal {
1305         _state.epochs[epoch()].bonded = totalSupply();
1306     }
1307 
1308     function initializeCouponsExpiration(uint256 epoch, uint256 expiration)
1309         internal
1310     {
1311         _state.epochs[epoch].coupons.expiration = expiration;
1312         _state.epochs[expiration].coupons.expiring.push(epoch);
1313     }
1314 
1315     function eliminateOutstandingCoupons(uint256 epoch) internal {
1316         uint256 outstandingCouponsForEpoch = outstandingCoupons(epoch);
1317         if (outstandingCouponsForEpoch == 0) {
1318             return;
1319         }
1320         _state.balance.coupons = _state.balance.coupons.sub(
1321             outstandingCouponsForEpoch
1322         );
1323         _state.epochs[epoch].coupons.outstanding = 0;
1324     }
1325 }
1326 
1327 /*
1328     Copyright 2019 dYdX Trading Inc.
1329 
1330     Licensed under the Apache License, Version 2.0 (the "License");
1331     you may not use this file except in compliance with the License.
1332     You may obtain a copy of the License at
1333 
1334     http://www.apache.org/licenses/LICENSE-2.0
1335 
1336     Unless required by applicable law or agreed to in writing, software
1337     distributed under the License is distributed on an "AS IS" BASIS,
1338     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1339     See the License for the specific language governing permissions and
1340     limitations under the License.
1341 */
1342 /**
1343  * @title Require
1344  * @author dYdX
1345  *
1346  * Stringifies parameters to pretty-print revert messages. Costs more gas than regular require()
1347  */
1348 library Require {
1349 
1350     // ============ Constants ============
1351 
1352     uint256 constant ASCII_ZERO = 48; // '0'
1353     uint256 constant ASCII_RELATIVE_ZERO = 87; // 'a' - 10
1354     uint256 constant ASCII_LOWER_EX = 120; // 'x'
1355     bytes2 constant COLON = 0x3a20; // ': '
1356     bytes2 constant COMMA = 0x2c20; // ', '
1357     bytes2 constant LPAREN = 0x203c; // ' <'
1358     byte constant RPAREN = 0x3e; // '>'
1359     uint256 constant FOUR_BIT_MASK = 0xf;
1360 
1361     // ============ Library Functions ============
1362 
1363     function that(
1364         bool must,
1365         bytes32 file,
1366         bytes32 reason
1367     )
1368     internal
1369     pure
1370     {
1371         if (!must) {
1372             revert(
1373                 string(
1374                     abi.encodePacked(
1375                         stringifyTruncated(file),
1376                         COLON,
1377                         stringifyTruncated(reason)
1378                     )
1379                 )
1380             );
1381         }
1382     }
1383 
1384     function that(
1385         bool must,
1386         bytes32 file,
1387         bytes32 reason,
1388         uint256 payloadA
1389     )
1390     internal
1391     pure
1392     {
1393         if (!must) {
1394             revert(
1395                 string(
1396                     abi.encodePacked(
1397                         stringifyTruncated(file),
1398                         COLON,
1399                         stringifyTruncated(reason),
1400                         LPAREN,
1401                         stringify(payloadA),
1402                         RPAREN
1403                     )
1404                 )
1405             );
1406         }
1407     }
1408 
1409     function that(
1410         bool must,
1411         bytes32 file,
1412         bytes32 reason,
1413         uint256 payloadA,
1414         uint256 payloadB
1415     )
1416     internal
1417     pure
1418     {
1419         if (!must) {
1420             revert(
1421                 string(
1422                     abi.encodePacked(
1423                         stringifyTruncated(file),
1424                         COLON,
1425                         stringifyTruncated(reason),
1426                         LPAREN,
1427                         stringify(payloadA),
1428                         COMMA,
1429                         stringify(payloadB),
1430                         RPAREN
1431                     )
1432                 )
1433             );
1434         }
1435     }
1436 
1437     function that(
1438         bool must,
1439         bytes32 file,
1440         bytes32 reason,
1441         address payloadA
1442     )
1443     internal
1444     pure
1445     {
1446         if (!must) {
1447             revert(
1448                 string(
1449                     abi.encodePacked(
1450                         stringifyTruncated(file),
1451                         COLON,
1452                         stringifyTruncated(reason),
1453                         LPAREN,
1454                         stringify(payloadA),
1455                         RPAREN
1456                     )
1457                 )
1458             );
1459         }
1460     }
1461 
1462     function that(
1463         bool must,
1464         bytes32 file,
1465         bytes32 reason,
1466         address payloadA,
1467         uint256 payloadB
1468     )
1469     internal
1470     pure
1471     {
1472         if (!must) {
1473             revert(
1474                 string(
1475                     abi.encodePacked(
1476                         stringifyTruncated(file),
1477                         COLON,
1478                         stringifyTruncated(reason),
1479                         LPAREN,
1480                         stringify(payloadA),
1481                         COMMA,
1482                         stringify(payloadB),
1483                         RPAREN
1484                     )
1485                 )
1486             );
1487         }
1488     }
1489 
1490     function that(
1491         bool must,
1492         bytes32 file,
1493         bytes32 reason,
1494         address payloadA,
1495         uint256 payloadB,
1496         uint256 payloadC
1497     )
1498     internal
1499     pure
1500     {
1501         if (!must) {
1502             revert(
1503                 string(
1504                     abi.encodePacked(
1505                         stringifyTruncated(file),
1506                         COLON,
1507                         stringifyTruncated(reason),
1508                         LPAREN,
1509                         stringify(payloadA),
1510                         COMMA,
1511                         stringify(payloadB),
1512                         COMMA,
1513                         stringify(payloadC),
1514                         RPAREN
1515                     )
1516                 )
1517             );
1518         }
1519     }
1520 
1521     function that(
1522         bool must,
1523         bytes32 file,
1524         bytes32 reason,
1525         bytes32 payloadA
1526     )
1527     internal
1528     pure
1529     {
1530         if (!must) {
1531             revert(
1532                 string(
1533                     abi.encodePacked(
1534                         stringifyTruncated(file),
1535                         COLON,
1536                         stringifyTruncated(reason),
1537                         LPAREN,
1538                         stringify(payloadA),
1539                         RPAREN
1540                     )
1541                 )
1542             );
1543         }
1544     }
1545 
1546     function that(
1547         bool must,
1548         bytes32 file,
1549         bytes32 reason,
1550         bytes32 payloadA,
1551         uint256 payloadB,
1552         uint256 payloadC
1553     )
1554     internal
1555     pure
1556     {
1557         if (!must) {
1558             revert(
1559                 string(
1560                     abi.encodePacked(
1561                         stringifyTruncated(file),
1562                         COLON,
1563                         stringifyTruncated(reason),
1564                         LPAREN,
1565                         stringify(payloadA),
1566                         COMMA,
1567                         stringify(payloadB),
1568                         COMMA,
1569                         stringify(payloadC),
1570                         RPAREN
1571                     )
1572                 )
1573             );
1574         }
1575     }
1576 
1577     // ============ Private Functions ============
1578 
1579     function stringifyTruncated(
1580         bytes32 input
1581     )
1582     private
1583     pure
1584     returns (bytes memory)
1585     {
1586         // put the input bytes into the result
1587         bytes memory result = abi.encodePacked(input);
1588 
1589         // determine the length of the input by finding the location of the last non-zero byte
1590         for (uint256 i = 32; i > 0; ) {
1591             // reverse-for-loops with unsigned integer
1592             /* solium-disable-next-line security/no-modify-for-iter-var */
1593             i--;
1594 
1595             // find the last non-zero byte in order to determine the length
1596             if (result[i] != 0) {
1597                 uint256 length = i + 1;
1598 
1599                 /* solium-disable-next-line security/no-inline-assembly */
1600                 assembly {
1601                     mstore(result, length) // r.length = length;
1602                 }
1603 
1604                 return result;
1605             }
1606         }
1607 
1608         // all bytes are zero
1609         return new bytes(0);
1610     }
1611 
1612     function stringify(
1613         uint256 input
1614     )
1615     private
1616     pure
1617     returns (bytes memory)
1618     {
1619         if (input == 0) {
1620             return "0";
1621         }
1622 
1623         // get the final string length
1624         uint256 j = input;
1625         uint256 length;
1626         while (j != 0) {
1627             length++;
1628             j /= 10;
1629         }
1630 
1631         // allocate the string
1632         bytes memory bstr = new bytes(length);
1633 
1634         // populate the string starting with the least-significant character
1635         j = input;
1636         for (uint256 i = length; i > 0; ) {
1637             // reverse-for-loops with unsigned integer
1638             /* solium-disable-next-line security/no-modify-for-iter-var */
1639             i--;
1640 
1641             // take last decimal digit
1642             bstr[i] = byte(uint8(ASCII_ZERO + (j % 10)));
1643 
1644             // remove the last decimal digit
1645             j /= 10;
1646         }
1647 
1648         return bstr;
1649     }
1650 
1651     function stringify(
1652         address input
1653     )
1654     private
1655     pure
1656     returns (bytes memory)
1657     {
1658         uint256 z = uint256(input);
1659 
1660         // addresses are "0x" followed by 20 bytes of data which take up 2 characters each
1661         bytes memory result = new bytes(42);
1662 
1663         // populate the result with "0x"
1664         result[0] = byte(uint8(ASCII_ZERO));
1665         result[1] = byte(uint8(ASCII_LOWER_EX));
1666 
1667         // for each byte (starting from the lowest byte), populate the result with two characters
1668         for (uint256 i = 0; i < 20; i++) {
1669             // each byte takes two characters
1670             uint256 shift = i * 2;
1671 
1672             // populate the least-significant character
1673             result[41 - shift] = char(z & FOUR_BIT_MASK);
1674             z = z >> 4;
1675 
1676             // populate the most-significant character
1677             result[40 - shift] = char(z & FOUR_BIT_MASK);
1678             z = z >> 4;
1679         }
1680 
1681         return result;
1682     }
1683 
1684     function stringify(
1685         bytes32 input
1686     )
1687     private
1688     pure
1689     returns (bytes memory)
1690     {
1691         uint256 z = uint256(input);
1692 
1693         // bytes32 are "0x" followed by 32 bytes of data which take up 2 characters each
1694         bytes memory result = new bytes(66);
1695 
1696         // populate the result with "0x"
1697         result[0] = byte(uint8(ASCII_ZERO));
1698         result[1] = byte(uint8(ASCII_LOWER_EX));
1699 
1700         // for each byte (starting from the lowest byte), populate the result with two characters
1701         for (uint256 i = 0; i < 32; i++) {
1702             // each byte takes two characters
1703             uint256 shift = i * 2;
1704 
1705             // populate the least-significant character
1706             result[65 - shift] = char(z & FOUR_BIT_MASK);
1707             z = z >> 4;
1708 
1709             // populate the most-significant character
1710             result[64 - shift] = char(z & FOUR_BIT_MASK);
1711             z = z >> 4;
1712         }
1713 
1714         return result;
1715     }
1716 
1717     function char(
1718         uint256 input
1719     )
1720     private
1721     pure
1722     returns (byte)
1723     {
1724         // return ASCII digit (0-9)
1725         if (input < 10) {
1726             return byte(uint8(input + ASCII_ZERO));
1727         }
1728 
1729         // return ASCII letter (a-f)
1730         return byte(uint8(input + ASCII_RELATIVE_ZERO));
1731     }
1732 }
1733 
1734 contract Comptroller is Setters {
1735     using SafeMath for uint256;
1736 
1737     bytes32 private constant FILE = "Comptroller";
1738 
1739     function mintToAccount(address account, uint256 amount) internal {
1740         dollar().mint(account, amount);
1741         if (!bootstrappingAt(epoch())) {
1742             increaseDebt(amount);
1743         }
1744 
1745         balanceCheck();
1746     }
1747 
1748     function burnFromAccount(address account, uint256 amount) internal {
1749         dollar().transferFrom(account, address(this), amount);
1750         dollar().burn(amount);
1751         decrementTotalDebt(amount, "Comptroller: not enough outstanding debt");
1752 
1753         balanceCheck();
1754     }
1755 
1756     function redeemToAccount(address account, uint256 amount) internal {
1757         dollar().transfer(account, amount);
1758         decrementTotalRedeemable(
1759             amount,
1760             "Comptroller: not enough redeemable balance"
1761         );
1762 
1763         balanceCheck();
1764     }
1765 
1766     function burnRedeemable(uint256 amount) internal {
1767         dollar().burn(amount);
1768         decrementTotalRedeemable(
1769             amount,
1770             "Comptroller: not enough redeemable balance"
1771         );
1772 
1773         balanceCheck();
1774     }
1775 
1776     function increaseDebt(uint256 amount) internal returns (uint256) {
1777         incrementTotalDebt(amount);
1778         uint256 lessDebt = resetDebt(Constants.getDebtRatioCap());
1779 
1780         balanceCheck();
1781 
1782         return lessDebt > amount ? 0 : amount.sub(lessDebt);
1783     }
1784 
1785     function decreaseDebt(uint256 amount) internal {
1786         decrementTotalDebt(amount, "Comptroller: not enough debt");
1787 
1788         balanceCheck();
1789     }
1790 
1791     function increaseSupply(uint256 newSupply)
1792         internal
1793         returns (uint256, uint256)
1794     {
1795         // 0-a. Pay out to Pool
1796         uint256 poolReward = newSupply.mul(Constants.getOraclePoolRatio()).div(
1797             100
1798         );
1799         mintToPool(poolReward);
1800 
1801         // 0-b. Pay out to Treasury
1802         uint256 treasuryReward = newSupply
1803             .mul(Constants.getTreasuryRatio())
1804             .div(10000);
1805         mintToTreasury(treasuryReward);
1806 
1807         uint256 rewards = poolReward.add(treasuryReward);
1808         newSupply = newSupply > rewards ? newSupply.sub(rewards) : 0;
1809 
1810         // 1. True up redeemable pool
1811         uint256 newRedeemable = 0;
1812         uint256 totalRedeemable = totalRedeemable();
1813         uint256 totalCoupons = totalCoupons();
1814         if (totalRedeemable < totalCoupons) {
1815             newRedeemable = totalCoupons.sub(totalRedeemable);
1816             newRedeemable = newRedeemable > newSupply
1817                 ? newSupply
1818                 : newRedeemable;
1819             mintToRedeemable(newRedeemable);
1820             newSupply = newSupply.sub(newRedeemable);
1821         }
1822 
1823         // 2. Payout to DAO
1824         if (totalBonded() == 0) {
1825             newSupply = 0;
1826         }
1827         if (newSupply > 0) {
1828             mintToDAO(newSupply);
1829         }
1830 
1831         balanceCheck();
1832 
1833         return (newRedeemable, newSupply.add(rewards));
1834     }
1835 
1836     function resetDebt(Decimal.D256 memory targetDebtRatio)
1837         internal
1838         returns (uint256)
1839     {
1840         uint256 targetDebt = targetDebtRatio
1841             .mul(dollar().totalSupply())
1842             .asUint256();
1843         uint256 currentDebt = totalDebt();
1844 
1845         if (currentDebt > targetDebt) {
1846             uint256 lessDebt = currentDebt.sub(targetDebt);
1847             decreaseDebt(lessDebt);
1848 
1849             return lessDebt;
1850         }
1851 
1852         return 0;
1853     }
1854 
1855     function balanceCheck() private {
1856         Require.that(
1857             dollar().balanceOf(address(this)) >=
1858                 totalBonded().add(totalStaged()).add(totalRedeemable()),
1859             FILE,
1860             "Inconsistent balances"
1861         );
1862     }
1863 
1864     function mintToDAO(uint256 amount) private {
1865         if (amount > 0) {
1866             dollar().mint(address(this), amount);
1867             incrementTotalBonded(amount);
1868         }
1869     }
1870 
1871     function mintToPool(uint256 amount) private {
1872         if (amount > 0) {
1873             dollar().mint(pool(), amount);
1874         }
1875     }
1876 
1877     function mintToTreasury(uint256 amount) private {
1878         if (amount > 0) {
1879             dollar().mint(Constants.getTreasuryAddress(), amount);
1880         }
1881     }
1882 
1883     function mintToRedeemable(uint256 amount) private {
1884         dollar().mint(address(this), amount);
1885         incrementTotalRedeemable(amount);
1886 
1887         balanceCheck();
1888     }
1889 }
1890 
1891 contract Market is Comptroller, Curve {
1892     using SafeMath for uint256;
1893 
1894     bytes32 private constant FILE = "Market";
1895 
1896     event CouponExpiration(
1897         uint256 indexed epoch,
1898         uint256 couponsExpired,
1899         uint256 lessRedeemable,
1900         uint256 lessDebt,
1901         uint256 newBonded
1902     );
1903     event CouponPurchase(
1904         address indexed account,
1905         uint256 indexed epoch,
1906         uint256 dollarAmount,
1907         uint256 couponAmount
1908     );
1909     event CouponRedemption(
1910         address indexed account,
1911         uint256 indexed epoch,
1912         uint256 couponAmount
1913     );
1914     event CouponTransfer(
1915         address indexed from,
1916         address indexed to,
1917         uint256 indexed epoch,
1918         uint256 value
1919     );
1920     event CouponApproval(
1921         address indexed owner,
1922         address indexed spender,
1923         uint256 value
1924     );
1925 
1926     function step() internal {
1927         // Expire prior coupons
1928         for (uint256 i = 0; i < expiringCoupons(epoch()); i++) {
1929             expireCouponsForEpoch(expiringCouponsAtIndex(epoch(), i));
1930         }
1931 
1932         // Record expiry for current epoch's coupons
1933         uint256 expirationEpoch = epoch().add(Constants.getCouponExpiration());
1934         initializeCouponsExpiration(epoch(), expirationEpoch);
1935     }
1936 
1937     function expireCouponsForEpoch(uint256 epoch) private {
1938         uint256 couponsForEpoch = outstandingCoupons(epoch);
1939         (uint256 lessRedeemable, uint256 newBonded) = (0, 0);
1940 
1941         eliminateOutstandingCoupons(epoch);
1942 
1943         uint256 totalRedeemable = totalRedeemable();
1944         uint256 totalCoupons = totalCoupons();
1945         if (totalRedeemable > totalCoupons) {
1946             lessRedeemable = totalRedeemable.sub(totalCoupons);
1947             burnRedeemable(lessRedeemable);
1948             (, newBonded) = increaseSupply(lessRedeemable);
1949         }
1950 
1951         emit CouponExpiration(
1952             epoch,
1953             couponsForEpoch,
1954             lessRedeemable,
1955             0,
1956             newBonded
1957         );
1958     }
1959 
1960     function couponPremium(uint256 amount) public view returns (uint256) {
1961         return
1962             calculateCouponPremium(dollar().totalSupply(), totalDebt(), amount);
1963     }
1964 
1965     function purchaseCoupons(uint256 dollarAmount) external returns (uint256) {
1966         Require.that(dollarAmount > 0, FILE, "Must purchase non-zero amount");
1967 
1968         Require.that(totalDebt() >= dollarAmount, FILE, "Not enough debt");
1969 
1970         uint256 epoch = epoch();
1971         uint256 couponAmount = dollarAmount.add(couponPremium(dollarAmount));
1972         burnFromAccount(msg.sender, dollarAmount);
1973         incrementBalanceOfCoupons(msg.sender, epoch, couponAmount);
1974 
1975         emit CouponPurchase(msg.sender, epoch, dollarAmount, couponAmount);
1976 
1977         return couponAmount;
1978     }
1979 
1980     function redeemCoupons(uint256 couponEpoch, uint256 couponAmount) external {
1981         require(epoch().sub(couponEpoch) >= 4, "Market: Too early to redeem");
1982         decrementBalanceOfCoupons(
1983             msg.sender,
1984             couponEpoch,
1985             couponAmount,
1986             "Market: Insufficient coupon balance"
1987         );
1988         redeemToAccount(msg.sender, couponAmount);
1989 
1990         emit CouponRedemption(msg.sender, couponEpoch, couponAmount);
1991     }
1992 
1993     function approveCoupons(address spender, uint256 amount) external {
1994         require(
1995             spender != address(0),
1996             "Market: Coupon approve to the zero address"
1997         );
1998 
1999         updateAllowanceCoupons(msg.sender, spender, amount);
2000 
2001         emit CouponApproval(msg.sender, spender, amount);
2002     }
2003 
2004     function transferCoupons(
2005         address sender,
2006         address recipient,
2007         uint256 epoch,
2008         uint256 amount
2009     ) external {
2010         require(
2011             sender != address(0),
2012             "Market: Coupon transfer from the zero address"
2013         );
2014         require(
2015             recipient != address(0),
2016             "Market: Coupon transfer to the zero address"
2017         );
2018 
2019         decrementBalanceOfCoupons(
2020             sender,
2021             epoch,
2022             amount,
2023             "Market: Insufficient coupon balance"
2024         );
2025         incrementBalanceOfCoupons(recipient, epoch, amount);
2026 
2027         if (
2028             msg.sender != sender &&
2029             allowanceCoupons(sender, msg.sender) != uint256(-1)
2030         ) {
2031             decrementAllowanceCoupons(
2032                 sender,
2033                 msg.sender,
2034                 amount,
2035                 "Market: Insufficient coupon approval"
2036             );
2037         }
2038 
2039         emit CouponTransfer(sender, recipient, epoch, amount);
2040     }
2041 }
2042 
2043 contract Regulator is Comptroller {
2044     using SafeMath for uint256;
2045     using Decimal for Decimal.D256;
2046 
2047     Decimal.D256 public threeCRVPeg = Decimal.D256({value: 978280614764947472}); // 3CRV peg = $1
2048 
2049     event SupplyIncrease(
2050         uint256 indexed epoch,
2051         uint256 price,
2052         uint256 newRedeemable,
2053         uint256 lessDebt,
2054         uint256 newBonded
2055     );
2056     event SupplyDecrease(uint256 indexed epoch, uint256 price, uint256 newDebt);
2057     event SupplyNeutral(uint256 indexed epoch);
2058 
2059     function step() internal {
2060         Decimal.D256 memory price = oracleCapture();
2061 
2062         if (price.greaterThan(threeCRVPeg)) {
2063             growSupply(price);
2064             return;
2065         }
2066 
2067         if (price.lessThan(threeCRVPeg)) {
2068             shrinkSupply(price);
2069             return;
2070         }
2071 
2072         emit SupplyNeutral(epoch());
2073     }
2074 
2075     function shrinkSupply(Decimal.D256 memory price) private {
2076         Decimal.D256 memory delta = limit(threeCRVPeg.sub(price), price);
2077         uint256 newDebt = delta.mul(totalNet()).asUint256();
2078         uint256 cappedNewDebt = increaseDebt(newDebt);
2079 
2080         emit SupplyDecrease(epoch(), price.value, cappedNewDebt);
2081         return;
2082     }
2083 
2084     function growSupply(Decimal.D256 memory price) private {
2085         uint256 lessDebt = resetDebt(Decimal.zero());
2086 
2087         Decimal.D256 memory delta = limit(price.sub(threeCRVPeg), price);
2088         uint256 newSupply = delta.mul(totalNet()).asUint256();
2089         (uint256 newRedeemable, uint256 newBonded) = increaseSupply(newSupply);
2090         emit SupplyIncrease(
2091             epoch(),
2092             price.value,
2093             newRedeemable,
2094             lessDebt,
2095             newBonded
2096         );
2097     }
2098 
2099     function limit(Decimal.D256 memory delta, Decimal.D256 memory price)
2100         private
2101         view
2102         returns (Decimal.D256 memory)
2103     {
2104         Decimal.D256 memory supplyChangeLimit = Constants
2105             .getSupplyChangeLimit();
2106 
2107         uint256 totalRedeemable = totalRedeemable();
2108         uint256 totalCoupons = totalCoupons();
2109         if (
2110             price.greaterThan(threeCRVPeg) && (totalRedeemable < totalCoupons)
2111         ) {
2112             supplyChangeLimit = Constants.getCouponSupplyChangeLimit();
2113         }
2114 
2115         return delta.greaterThan(supplyChangeLimit) ? supplyChangeLimit : delta;
2116     }
2117 
2118     function oracleCapture() private returns (Decimal.D256 memory) {
2119         (Decimal.D256 memory price, bool valid) = oracle().averageDollarPrice();
2120 
2121         if (bootstrappingAt(epoch().sub(1))) {
2122             return Constants.getBootstrappingPrice();
2123         }
2124         if (!valid) {
2125             return threeCRVPeg;
2126         }
2127 
2128         return price;
2129     }
2130 }
2131 
2132 contract Permission is Setters {
2133     bytes32 private constant FILE = "Permission";
2134 
2135     // Can modify account state
2136     modifier onlyFrozenOrFluid(address account) {
2137         Require.that(
2138             statusOf(account) != Account.Status.Locked,
2139             FILE,
2140             "Not frozen or fluid"
2141         );
2142 
2143         _;
2144     }
2145 
2146     // Can participate in balance-dependant activities
2147     modifier onlyFrozenOrLocked(address account) {
2148         Require.that(
2149             statusOf(account) != Account.Status.Fluid,
2150             FILE,
2151             "Not frozen or locked"
2152         );
2153 
2154         _;
2155     }
2156 }
2157 
2158 contract Bonding is Setters, Permission {
2159     using SafeMath for uint256;
2160 
2161     bytes32 private constant FILE = "Bonding";
2162 
2163     event Deposit(address indexed account, uint256 value);
2164     event Withdraw(address indexed account, uint256 value);
2165     event Bond(
2166         address indexed account,
2167         uint256 start,
2168         uint256 value,
2169         uint256 valueUnderlying
2170     );
2171     event Unbond(
2172         address indexed account,
2173         uint256 start,
2174         uint256 value,
2175         uint256 valueUnderlying
2176     );
2177 
2178     function step() internal {
2179         Require.that(epochTime() > epoch(), FILE, "Still current epoch");
2180 
2181         snapshotTotalBonded();
2182         incrementEpoch();
2183     }
2184 
2185     function deposit(uint256 value) external onlyFrozenOrLocked(msg.sender) {
2186         dollar().transferFrom(msg.sender, address(this), value);
2187         incrementBalanceOfStaged(msg.sender, value);
2188 
2189         emit Deposit(msg.sender, value);
2190     }
2191 
2192     function withdraw(uint256 value) external onlyFrozenOrLocked(msg.sender) {
2193         dollar().transfer(msg.sender, value);
2194         decrementBalanceOfStaged(
2195             msg.sender,
2196             value,
2197             "Bonding: insufficient staged balance"
2198         );
2199 
2200         emit Withdraw(msg.sender, value);
2201     }
2202 
2203     function bond(uint256 value) external onlyFrozenOrFluid(msg.sender) {
2204         unfreeze(msg.sender);
2205 
2206         uint256 balance = totalBonded() == 0
2207             ? value.mul(Constants.getInitialStakeMultiple())
2208             : value.mul(totalSupply()).div(totalBonded());
2209         incrementBalanceOf(msg.sender, balance);
2210         incrementTotalBonded(value);
2211         decrementBalanceOfStaged(
2212             msg.sender,
2213             value,
2214             "Bonding: insufficient staged balance"
2215         );
2216 
2217         emit Bond(msg.sender, epoch().add(1), balance, value);
2218     }
2219 
2220     function unbond(uint256 value) external onlyFrozenOrFluid(msg.sender) {
2221         unfreeze(msg.sender);
2222 
2223         uint256 staged = value.mul(balanceOfBonded(msg.sender)).div(
2224             balanceOf(msg.sender)
2225         );
2226         incrementBalanceOfStaged(msg.sender, staged);
2227         decrementTotalBonded(staged, "Bonding: insufficient total bonded");
2228         decrementBalanceOf(msg.sender, value, "Bonding: insufficient balance");
2229 
2230         emit Unbond(msg.sender, epoch().add(1), value, staged);
2231     }
2232 
2233     function unbondUnderlying(uint256 value)
2234         external
2235         onlyFrozenOrFluid(msg.sender)
2236     {
2237         unfreeze(msg.sender);
2238 
2239         uint256 balance = value.mul(totalSupply()).div(totalBonded());
2240         incrementBalanceOfStaged(msg.sender, value);
2241         decrementTotalBonded(value, "Bonding: insufficient total bonded");
2242         decrementBalanceOf(
2243             msg.sender,
2244             balance,
2245             "Bonding: insufficient balance"
2246         );
2247 
2248         emit Unbond(msg.sender, epoch().add(1), balance, value);
2249     }
2250 }
2251 
2252 contract Forge is State, Bonding, Market, Regulator, Ownable {
2253     using SafeMath for uint256;
2254 
2255     event Advance(uint256 indexed epoch, uint256 block, uint256 timestamp);
2256     event Incentivization(address indexed account, uint256 amount);
2257 
2258     function setup(
2259         IDollar _dollar,
2260         IOracle _oracle,
2261         address _pool
2262     ) external onlyOwner {
2263         _state.provider.dollar = _dollar;
2264         _state.provider.oracle = _oracle;
2265         _state.provider.pool = _pool;
2266 
2267         incentivize(msg.sender, advanceIncentive());
2268     }
2269 
2270     function TMultiplier() internal returns (Decimal.D256 memory) {
2271         (Decimal.D256 memory price, bool valid) = oracle().averageDollarPrice();
2272 
2273         if (!valid) {
2274             // we assume 1 T == 0.25$
2275             price = Decimal.one().div(4);
2276         }
2277 
2278         return Decimal.one().div(price);
2279     }
2280 
2281     function advanceIncentive() public returns (uint256) {
2282         uint256 reward = TMultiplier()
2283             .mul(Constants.getAdvanceIncentive())
2284             .asUint256();
2285         return
2286             reward > Constants.getMaxAdvanceTIncentive()
2287                 ? Constants.getMaxAdvanceTIncentive()
2288                 : reward;
2289     }
2290 
2291     function advance(uint256 key) external {
2292         require(key == uint256(uint160(msg.sender)) * (epoch()**2));
2293         oracle().update();
2294         incentivize(msg.sender, advanceIncentive());
2295 
2296         Bonding.step();
2297         Regulator.step();
2298         Market.step();
2299 
2300         emit Advance(epoch(), block.number, block.timestamp);
2301     }
2302 
2303     function incentivize(address account, uint256 amount) private {
2304         mintToAccount(account, amount);
2305         emit Incentivization(account, amount);
2306     }
2307 }