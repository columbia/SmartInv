1 /**
2  *Submitted for verification at Etherscan.io on 2020-12-19
3 */
4 
5 pragma solidity ^0.5.17;	
6 pragma experimental ABIEncoderV2;
7 
8 /**
9  * @dev Wrappers over Solidity's arithmetic operations with added overflow
10  * checks.
11  *
12  * Arithmetic operations in Solidity wrap on overflow. This can easily result
13  * in bugs, because programmers usually assume that an overflow raises an
14  * error, which is the standard behavior in high level programming languages.
15  * `SafeMath` restores this intuition by reverting the transaction when an
16  * operation overflows.
17  *
18  * Using this library instead of the unchecked operations eliminates an entire
19  * class of bugs, so it's recommended to use it always.
20  */
21 library SafeMath {
22     /**
23      * @dev Returns the addition of two unsigned integers, reverting on
24      * overflow.
25      *
26      * Counterpart to Solidity's `+` operator.
27      *
28      * Requirements:
29      * - Addition cannot overflow.
30      */
31     function add(uint256 a, uint256 b) internal pure returns (uint256) {
32         uint256 c = a + b;
33         require(c >= a, "SafeMath: addition overflow");
34 
35         return c;
36     }
37 
38     /**
39      * @dev Returns the subtraction of two unsigned integers, reverting on
40      * overflow (when the result is negative).
41      *
42      * Counterpart to Solidity's `-` operator.
43      *
44      * Requirements:
45      * - Subtraction cannot overflow.
46      */
47     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
48         return sub(a, b, "SafeMath: subtraction overflow");
49     }
50 
51     /**
52      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
53      * overflow (when the result is negative).
54      *
55      * Counterpart to Solidity's `-` operator.
56      *
57      * Requirements:
58      * - Subtraction cannot overflow.
59      *
60      * _Available since v2.4.0._
61      */
62     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
63         require(b <= a, errorMessage);
64         uint256 c = a - b;
65 
66         return c;
67     }
68 
69     /**
70      * @dev Returns the multiplication of two unsigned integers, reverting on
71      * overflow.
72      *
73      * Counterpart to Solidity's `*` operator.
74      *
75      * Requirements:
76      * - Multiplication cannot overflow.
77      */
78     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
79         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
80         // benefit is lost if 'b' is also tested.
81         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
82         if (a == 0) {
83             return 0;
84         }
85 
86         uint256 c = a * b;
87         require(c / a == b, "SafeMath: multiplication overflow");
88 
89         return c;
90     }
91 
92     /**
93      * @dev Returns the integer division of two unsigned integers. Reverts on
94      * division by zero. The result is rounded towards zero.
95      *
96      * Counterpart to Solidity's `/` operator. Note: this function uses a
97      * `revert` opcode (which leaves remaining gas untouched) while Solidity
98      * uses an invalid opcode to revert (consuming all remaining gas).
99      *
100      * Requirements:
101      * - The divisor cannot be zero.
102      */
103     function div(uint256 a, uint256 b) internal pure returns (uint256) {
104         return div(a, b, "SafeMath: division by zero");
105     }
106 
107     /**
108      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
109      * division by zero. The result is rounded towards zero.
110      *
111      * Counterpart to Solidity's `/` operator. Note: this function uses a
112      * `revert` opcode (which leaves remaining gas untouched) while Solidity
113      * uses an invalid opcode to revert (consuming all remaining gas).
114      *
115      * Requirements:
116      * - The divisor cannot be zero.
117      *
118      * _Available since v2.4.0._
119      */
120     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
121         // Solidity only automatically asserts when dividing by 0
122         require(b > 0, errorMessage);
123         uint256 c = a / b;
124         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
125 
126         return c;
127     }
128 
129     /**
130      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
131      * Reverts when dividing by zero.
132      *
133      * Counterpart to Solidity's `%` operator. This function uses a `revert`
134      * opcode (which leaves remaining gas untouched) while Solidity uses an
135      * invalid opcode to revert (consuming all remaining gas).
136      *
137      * Requirements:
138      * - The divisor cannot be zero.
139      */
140     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
141         return mod(a, b, "SafeMath: modulo by zero");
142     }
143 
144     /**
145      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
146      * Reverts with custom message when dividing by zero.
147      *
148      * Counterpart to Solidity's `%` operator. This function uses a `revert`
149      * opcode (which leaves remaining gas untouched) while Solidity uses an
150      * invalid opcode to revert (consuming all remaining gas).
151      *
152      * Requirements:
153      * - The divisor cannot be zero.
154      *
155      * _Available since v2.4.0._
156      */
157     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
158         require(b != 0, errorMessage);
159         return a % b;
160     }
161 }
162 
163 /*
164     Copyright 2019 dYdX Trading Inc.
165     Copyright 2020 Empty Set Squad <emptysetsquad@protonmail.com>
166 
167     Licensed under the Apache License, Version 2.0 (the "License");
168     you may not use this file except in compliance with the License.
169     You may obtain a copy of the License at
170 
171     http://www.apache.org/licenses/LICENSE-2.0
172 
173     Unless required by applicable law or agreed to in writing, software
174     distributed under the License is distributed on an "AS IS" BASIS,
175     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
176     See the License for the specific language governing permissions and
177     limitations under the License.
178 */
179 
180 
181 /**
182  * @title Decimal
183  * @author dYdX
184  *
185  * Library that defines a fixed-point number with 18 decimal places.
186  */
187 library Decimal {
188     using SafeMath for uint256;
189 
190     // ============ Constants ============
191 
192     uint256 constant BASE = 10**18;
193 
194     // ============ Structs ============
195 
196 
197     struct D256 {
198         uint256 value;
199     }
200 
201     // ============ Static Functions ============
202 
203     function zero()
204     internal
205     pure
206     returns (D256 memory)
207     {
208         return D256({ value: 0 });
209     }
210 
211     function one()
212     internal
213     pure
214     returns (D256 memory)
215     {
216         return D256({ value: BASE });
217     }
218 
219     function from(
220         uint256 a
221     )
222     internal
223     pure
224     returns (D256 memory)
225     {
226         return D256({ value: a.mul(BASE) });
227     }
228 
229     function ratio(
230         uint256 a,
231         uint256 b
232     )
233     internal
234     pure
235     returns (D256 memory)
236     {
237         return D256({ value: getPartial(a, BASE, b) });
238     }
239 
240     // ============ Self Functions ============
241 
242     function add(
243         D256 memory self,
244         uint256 b
245     )
246     internal
247     pure
248     returns (D256 memory)
249     {
250         return D256({ value: self.value.add(b.mul(BASE)) });
251     }
252 
253     function sub(
254         D256 memory self,
255         uint256 b
256     )
257     internal
258     pure
259     returns (D256 memory)
260     {
261         return D256({ value: self.value.sub(b.mul(BASE)) });
262     }
263 
264     function sub(
265         D256 memory self,
266         uint256 b,
267         string memory reason
268     )
269     internal
270     pure
271     returns (D256 memory)
272     {
273         return D256({ value: self.value.sub(b.mul(BASE), reason) });
274     }
275 
276     function mul(
277         D256 memory self,
278         uint256 b
279     )
280     internal
281     pure
282     returns (D256 memory)
283     {
284         return D256({ value: self.value.mul(b) });
285     }
286 
287     function div(
288         D256 memory self,
289         uint256 b
290     )
291     internal
292     pure
293     returns (D256 memory)
294     {
295         return D256({ value: self.value.div(b) });
296     }
297 
298     function pow(
299         D256 memory self,
300         uint256 b
301     )
302     internal
303     pure
304     returns (D256 memory)
305     {
306         if (b == 0) {
307             return from(1);
308         }
309 
310         D256 memory temp = D256({ value: self.value });
311         for (uint256 i = 1; i < b; i++) {
312             temp = mul(temp, self);
313         }
314 
315         return temp;
316     }
317 
318     function add(
319         D256 memory self,
320         D256 memory b
321     )
322     internal
323     pure
324     returns (D256 memory)
325     {
326         return D256({ value: self.value.add(b.value) });
327     }
328 
329     function sub(
330         D256 memory self,
331         D256 memory b
332     )
333     internal
334     pure
335     returns (D256 memory)
336     {
337         return D256({ value: self.value.sub(b.value) });
338     }
339 
340     function sub(
341         D256 memory self,
342         D256 memory b,
343         string memory reason
344     )
345     internal
346     pure
347     returns (D256 memory)
348     {
349         return D256({ value: self.value.sub(b.value, reason) });
350     }
351 
352     function mul(
353         D256 memory self,
354         D256 memory b
355     )
356     internal
357     pure
358     returns (D256 memory)
359     {
360         return D256({ value: getPartial(self.value, b.value, BASE) });
361     }
362 
363     function div(
364         D256 memory self,
365         D256 memory b
366     )
367     internal
368     pure
369     returns (D256 memory)
370     {
371         return D256({ value: getPartial(self.value, BASE, b.value) });
372     }
373 
374     function equals(D256 memory self, D256 memory b) internal pure returns (bool) {
375         return self.value == b.value;
376     }
377 
378     function greaterThan(D256 memory self, D256 memory b) internal pure returns (bool) {
379         return compareTo(self, b) == 2;
380     }
381 
382     function lessThan(D256 memory self, D256 memory b) internal pure returns (bool) {
383         return compareTo(self, b) == 0;
384     }
385 
386     function greaterThanOrEqualTo(D256 memory self, D256 memory b) internal pure returns (bool) {
387         return compareTo(self, b) > 0;
388     }
389 
390     function lessThanOrEqualTo(D256 memory self, D256 memory b) internal pure returns (bool) {
391         return compareTo(self, b) < 2;
392     }
393 
394     function isZero(D256 memory self) internal pure returns (bool) {
395         return self.value == 0;
396     }
397 
398     function asUint256(D256 memory self) internal pure returns (uint256) {
399         return self.value.div(BASE);
400     }
401 
402     // ============ Core Methods ============
403 
404     function getPartial(
405         uint256 target,
406         uint256 numerator,
407         uint256 denominator
408     )
409     private
410     pure
411     returns (uint256)
412     {
413         return target.mul(numerator).div(denominator);
414     }
415 
416     function compareTo(
417         D256 memory a,
418         D256 memory b
419     )
420     private
421     pure
422     returns (uint256)
423     {
424         if (a.value == b.value) {
425             return 1;
426         }
427         return a.value > b.value ? 2 : 0;
428     }
429 }
430 
431 /*
432     Copyright 2020 Empty Set Squad <emptysetsquad@protonmail.com>
433 
434     Licensed under the Apache License, Version 2.0 (the "License");
435     you may not use this file except in compliance with the License.
436     You may obtain a copy of the License at
437 
438     http://www.apache.org/licenses/LICENSE-2.0
439 
440     Unless required by applicable law or agreed to in writing, software
441     distributed under the License is distributed on an "AS IS" BASIS,
442     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
443     See the License for the specific language governing permissions and
444     limitations under the License.
445 */
446 
447 
448 library Constants {
449     /* Chain */
450     uint256 private constant CHAIN_ID = 1; // Mainnet
451 
452     /* Bootstrapping */
453     uint256 private constant BOOTSTRAPPING_PERIOD = 300;
454     uint256 private constant BOOTSTRAPPING_PRICE = 154e16; // 1.54 USDC
455     uint256 private constant BOOTSTRAPPING_SPEEDUP_FACTOR = 3; // 30 days @ 8 hours
456 
457     /* Oracle */
458     uint256 private constant ORACLE_RESERVE_MINIMUM = 1e10; // 10,000 USDC
459 
460     /* Bonding */
461     uint256 private constant INITIAL_STAKE_MULTIPLE = 1e6; // 100 ESD -> 100M ESDS
462 
463     /* Epoch */
464     struct EpochStrategy {
465         uint256 offset;
466         uint256 start;
467         uint256 period;
468     }
469 
470     uint256 private constant PREVIOUS_EPOCH_OFFSET = 91;
471     uint256 private constant PREVIOUS_EPOCH_START = 1600905600;
472     uint256 private constant PREVIOUS_EPOCH_PERIOD = 3600;
473 
474     uint256 private constant CURRENT_EPOCH_OFFSET = 106;
475     uint256 private constant CURRENT_EPOCH_START = 1602201600;
476     uint256 private constant CURRENT_EPOCH_PERIOD = 3600;
477 
478     /* Governance */
479     uint256 private constant GOVERNANCE_PERIOD = 72; // 72 epochs
480     uint256 private constant GOVERNANCE_EXPIRATION = 2; // 2 + 1 epochs
481     uint256 private constant GOVERNANCE_QUORUM = 20e16; // 20%
482     uint256 private constant GOVERNANCE_PROPOSAL_THRESHOLD = 5e15; // 0.5%
483     uint256 private constant GOVERNANCE_SUPER_MAJORITY = 66e16; // 66%
484     uint256 private constant GOVERNANCE_EMERGENCY_DELAY = 12; // 12 epochs
485 
486     /* DAO */
487     uint256 private constant ADVANCE_INCENTIVE = 1e20; // 100 
488     uint256 private constant DAO_EXIT_LOCKUP_EPOCHS = 72; // 72 epochs fluid
489 
490     /* Pool */
491     uint256 private constant POOL_EXIT_LOCKUP_EPOCHS = 24; // 24 epochs fluid
492 
493     /* Market */
494     uint256 private constant COUPON_EXPIRATION = 360;
495     uint256 private constant DEBT_RATIO_CAP = 35e16; // 35%
496 
497     /* Regulator */
498     uint256 private constant SUPPLY_CHANGE_LIMIT = 2e16; // 2%
499     uint256 private constant COUPON_SUPPLY_CHANGE_LIMIT = 5e16; //5%
500     uint256 private constant ORACLE_POOL_RATIO = 50; // 50%
501     uint256 private constant TREASURY_RATIO = 10; // 0.1%
502 
503     /**
504      * Getters
505      */
506 
507     function getOracleReserveMinimum() internal pure returns (uint256) {
508         return ORACLE_RESERVE_MINIMUM;
509     }
510 
511     function getPreviousEpochStrategy() internal pure returns (EpochStrategy memory) {
512         return EpochStrategy({
513             offset: PREVIOUS_EPOCH_OFFSET,
514             start: PREVIOUS_EPOCH_START,
515             period: PREVIOUS_EPOCH_PERIOD
516         });
517     }
518 
519     function getCurrentEpochStrategy() internal pure returns (EpochStrategy memory) {
520         return EpochStrategy({
521             offset: CURRENT_EPOCH_OFFSET,
522             start: CURRENT_EPOCH_START,
523             period: CURRENT_EPOCH_PERIOD
524         });
525     }
526 
527     function getInitialStakeMultiple() internal pure returns (uint256) {
528         return INITIAL_STAKE_MULTIPLE;
529     }
530 
531     function getBootstrappingPeriod() internal pure returns (uint256) {
532         return BOOTSTRAPPING_PERIOD;
533     }
534 
535     function getBootstrappingPrice() internal pure returns (Decimal.D256 memory) {
536         return Decimal.D256({value: BOOTSTRAPPING_PRICE});
537     }
538 
539     function getBootstrappingSpeedupFactor() internal pure returns (uint256) {
540         return BOOTSTRAPPING_SPEEDUP_FACTOR;
541     }
542 
543     function getGovernancePeriod() internal pure returns (uint256) {
544         return GOVERNANCE_PERIOD;
545     }
546 
547     function getGovernanceExpiration() internal pure returns (uint256) {
548         return GOVERNANCE_EXPIRATION;
549     }
550 
551     function getGovernanceQuorum() internal pure returns (Decimal.D256 memory) {
552         return Decimal.D256({value: GOVERNANCE_QUORUM});
553     }
554 
555     function getGovernanceProposalThreshold() internal pure returns (Decimal.D256 memory) {
556         return Decimal.D256({value: GOVERNANCE_PROPOSAL_THRESHOLD});
557     }
558 
559     function getGovernanceSuperMajority() internal pure returns (Decimal.D256 memory) {
560         return Decimal.D256({value: GOVERNANCE_SUPER_MAJORITY});
561     }
562 
563     function getGovernanceEmergencyDelay() internal pure returns (uint256) {
564         return GOVERNANCE_EMERGENCY_DELAY;
565     }
566 
567     function getAdvanceIncentive() internal pure returns (uint256) {
568         return ADVANCE_INCENTIVE;
569     }
570 
571     function getDAOExitLockupEpochs() internal pure returns (uint256) {
572         return DAO_EXIT_LOCKUP_EPOCHS;
573     }
574 
575     function getPoolExitLockupEpochs() internal pure returns (uint256) {
576         return POOL_EXIT_LOCKUP_EPOCHS;
577     }
578 
579     function getCouponExpiration() internal pure returns (uint256) {
580         return COUPON_EXPIRATION;
581     }
582 
583     function getDebtRatioCap() internal pure returns (Decimal.D256 memory) {
584         return Decimal.D256({value: DEBT_RATIO_CAP});
585     }
586 
587     function getSupplyChangeLimit() internal pure returns (Decimal.D256 memory) {
588         return Decimal.D256({value: SUPPLY_CHANGE_LIMIT});
589     }
590 
591     function getCouponSupplyChangeLimit() internal pure returns (Decimal.D256 memory) {
592         return Decimal.D256({value: COUPON_SUPPLY_CHANGE_LIMIT});
593     }
594 
595     function getOraclePoolRatio() internal pure returns (uint256) {
596         return ORACLE_POOL_RATIO;
597     }
598 
599     function getTreasuryRatio() internal pure returns (uint256) {
600         return TREASURY_RATIO;
601     }
602 
603     function getChainId() internal pure returns (uint256) {
604         return CHAIN_ID;
605     }
606 }
607 
608 /*
609     Copyright 2020 Empty Set Squad <emptysetsquad@protonmail.com>
610 
611     Licensed under the Apache License, Version 2.0 (the "License");
612     you may not use this file except in compliance with the License.
613     You may obtain a copy of the License at
614 
615     http://www.apache.org/licenses/LICENSE-2.0
616 
617     Unless required by applicable law or agreed to in writing, software
618     distributed under the License is distributed on an "AS IS" BASIS,
619     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
620     See the License for the specific language governing permissions and
621     limitations under the License.
622 */
623 
624 
625 contract Curve {
626     using SafeMath for uint256;
627     using Decimal for Decimal.D256;
628 
629     function calculateCouponPremium(
630         uint256 totalSupply,
631         uint256 totalDebt,
632         uint256 amount
633     ) internal pure returns (uint256) {
634         return effectivePremium(totalSupply, totalDebt, amount).mul(amount).asUint256();
635     }
636 
637     function effectivePremium(
638         uint256 totalSupply,
639         uint256 totalDebt,
640         uint256 amount
641     ) private pure returns (Decimal.D256 memory) {
642         Decimal.D256 memory debtRatio = Decimal.ratio(totalDebt, totalSupply);
643         Decimal.D256 memory debtRatioUpperBound = Constants.getDebtRatioCap();
644 
645         uint256 totalSupplyEnd = totalSupply.sub(amount);
646         uint256 totalDebtEnd = totalDebt.sub(amount);
647         Decimal.D256 memory debtRatioEnd = Decimal.ratio(totalDebtEnd, totalSupplyEnd);
648 
649         if (debtRatio.greaterThan(debtRatioUpperBound)) {
650             if (debtRatioEnd.greaterThan(debtRatioUpperBound)) {
651                 return curve(debtRatioUpperBound);
652             }
653 
654             Decimal.D256 memory premiumCurve = curveMean(debtRatioEnd, debtRatioUpperBound);
655             Decimal.D256 memory premiumCurveDelta = debtRatioUpperBound.sub(debtRatioEnd);
656             Decimal.D256 memory premiumFlat = curve(debtRatioUpperBound);
657             Decimal.D256 memory premiumFlatDelta = debtRatio.sub(debtRatioUpperBound);
658             return (premiumCurve.mul(premiumCurveDelta)).add(premiumFlat.mul(premiumFlatDelta))
659                 .div(premiumCurveDelta.add(premiumFlatDelta));
660         }
661 
662         return curveMean(debtRatioEnd, debtRatio);
663     }
664 
665     // 1/((1-R)^2)-1
666     function curve(Decimal.D256 memory debtRatio) private pure returns (Decimal.D256 memory) {
667         return Decimal.one().div(
668             (Decimal.one().sub(debtRatio)).pow(2)
669         ).sub(Decimal.one());
670     }
671 
672     // 1/((1-R)(1-R'))-1
673     function curveMean(
674         Decimal.D256 memory lower,
675         Decimal.D256 memory upper
676     ) private pure returns (Decimal.D256 memory) {
677         if (lower.equals(upper)) {
678             return curve(lower);
679         }
680 
681         return Decimal.one().div(
682             (Decimal.one().sub(upper)).mul(Decimal.one().sub(lower))
683         ).sub(Decimal.one());
684     }
685 }
686 
687 interface IUniswapV2Pair {
688     event Approval(address indexed owner, address indexed spender, uint value);
689     event Transfer(address indexed from, address indexed to, uint value);
690 
691     function name() external pure returns (string memory);
692     function symbol() external pure returns (string memory);
693     function decimals() external pure returns (uint8);
694     function totalSupply() external view returns (uint);
695     function balanceOf(address owner) external view returns (uint);
696     function allowance(address owner, address spender) external view returns (uint);
697 
698     function approve(address spender, uint value) external returns (bool);
699     function transfer(address to, uint value) external returns (bool);
700     function transferFrom(address from, address to, uint value) external returns (bool);
701 
702     function DOMAIN_SEPARATOR() external view returns (bytes32);
703     function PERMIT_TYPEHASH() external pure returns (bytes32);
704     function nonces(address owner) external view returns (uint);
705 
706     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
707 
708     event Mint(address indexed sender, uint amount0, uint amount1);
709     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
710     event Swap(
711         address indexed sender,
712         uint amount0In,
713         uint amount1In,
714         uint amount0Out,
715         uint amount1Out,
716         address indexed to
717     );
718     event Sync(uint112 reserve0, uint112 reserve1);
719 
720     function MINIMUM_LIQUIDITY() external pure returns (uint);
721     function factory() external view returns (address);
722     function token0() external view returns (address);
723     function token1() external view returns (address);
724     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
725     function price0CumulativeLast() external view returns (uint);
726     function price1CumulativeLast() external view returns (uint);
727     function kLast() external view returns (uint);
728 
729     function mint(address to) external returns (uint liquidity);
730     function burn(address to) external returns (uint amount0, uint amount1);
731     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
732     function skim(address to) external;
733     function sync() external;
734 
735     function initialize(address, address) external;
736 }
737 
738 /**
739  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
740  * the optional functions; to access them see {ERC20Detailed}.
741  */
742 interface IERC20 {
743     /**
744      * @dev Returns the amount of tokens in existence.
745      */
746     function totalSupply() external view returns (uint256);
747 
748     /**
749      * @dev Returns the amount of tokens owned by `account`.
750      */
751     function balanceOf(address account) external view returns (uint256);
752 
753     /**
754      * @dev Moves `amount` tokens from the caller's account to `recipient`.
755      *
756      * Returns a boolean value indicating whether the operation succeeded.
757      *
758      * Emits a {Transfer} event.
759      */
760     function transfer(address recipient, uint256 amount) external returns (bool);
761 
762     /**
763      * @dev Returns the remaining number of tokens that `spender` will be
764      * allowed to spend on behalf of `owner` through {transferFrom}. This is
765      * zero by default.
766      *
767      * This value changes when {approve} or {transferFrom} are called.
768      */
769     function allowance(address owner, address spender) external view returns (uint256);
770 
771     /**
772      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
773      *
774      * Returns a boolean value indicating whether the operation succeeded.
775      *
776      * IMPORTANT: Beware that changing an allowance with this method brings the risk
777      * that someone may use both the old and the new allowance by unfortunate
778      * transaction ordering. One possible solution to mitigate this race
779      * condition is to first reduce the spender's allowance to 0 and set the
780      * desired value afterwards:
781      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
782      *
783      * Emits an {Approval} event.
784      */
785     function approve(address spender, uint256 amount) external returns (bool);
786 
787     /**
788      * @dev Moves `amount` tokens from `sender` to `recipient` using the
789      * allowance mechanism. `amount` is then deducted from the caller's
790      * allowance.
791      *
792      * Returns a boolean value indicating whether the operation succeeded.
793      *
794      * Emits a {Transfer} event.
795      */
796     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
797 
798     /**
799      * @dev Emitted when `value` tokens are moved from one account (`from`) to
800      * another (`to`).
801      *
802      * Note that `value` may be zero.
803      */
804     event Transfer(address indexed from, address indexed to, uint256 value);
805 
806     /**
807      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
808      * a call to {approve}. `value` is the new allowance.
809      */
810     event Approval(address indexed owner, address indexed spender, uint256 value);
811 }
812 
813 /*
814     Copyright 2020 Empty Set Squad <emptysetsquad@protonmail.com>
815 
816     Licensed under the Apache License, Version 2.0 (the "License");
817     you may not use this file except in compliance with the License.
818     You may obtain a copy of the License at
819 
820     http://www.apache.org/licenses/LICENSE-2.0
821 
822     Unless required by applicable law or agreed to in writing, software
823     distributed under the License is distributed on an "AS IS" BASIS,
824     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
825     See the License for the specific language governing permissions and
826     limitations under the License.
827 */
828 
829 
830 contract IDollar is IERC20 {
831     function burn(uint256 amount) public;
832     function burnFrom(address account, uint256 amount) public;
833     function mint(address account, uint256 amount) public returns (bool);
834 }
835 
836 /*
837     Copyright 2020 Empty Set Squad <emptysetsquad@protonmail.com>
838 
839     Licensed under the Apache License, Version 2.0 (the "License");
840     you may not use this file except in compliance with the License.
841     You may obtain a copy of the License at
842 
843     http://www.apache.org/licenses/LICENSE-2.0
844 
845     Unless required by applicable law or agreed to in writing, software
846     distributed under the License is distributed on an "AS IS" BASIS,
847     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
848     See the License for the specific language governing permissions and
849     limitations under the License.
850 */
851 
852 
853 contract IOracle {
854     function setup() public;
855     function capture() public returns (Decimal.D256 memory, bool);
856     function pair() external view returns (address);
857 }
858 
859 /*
860     Copyright 2020 Empty Set Squad <emptysetsquad@protonmail.com>
861 
862     Licensed under the Apache License, Version 2.0 (the "License");
863     you may not use this file except in compliance with the License.
864     You may obtain a copy of the License at
865 
866     http://www.apache.org/licenses/LICENSE-2.0
867 
868     Unless required by applicable law or agreed to in writing, software
869     distributed under the License is distributed on an "AS IS" BASIS,
870     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
871     See the License for the specific language governing permissions and
872     limitations under the License.
873 */
874 
875 
876 contract Account {
877     enum Status {
878         Frozen,
879         Fluid,
880         Locked
881     }
882 
883     struct State {
884         uint256 staged;
885         uint256 balance;
886         mapping(uint256 => uint256) coupons;
887         mapping(address => uint256) couponAllowances;
888         uint256 fluidUntil;
889         uint256 lockedUntil;
890     }
891 }
892 
893 contract Epoch {
894     struct Global {
895         uint256 start;
896         uint256 period;
897         uint256 current;
898         uint256 lastEpochTime;
899     }
900 
901     struct Coupons {
902         uint256 outstanding;
903         uint256 expiration;
904         uint256[] expiring;
905     }
906 
907     struct State {
908         uint256 bonded;
909         Coupons coupons;
910     }
911 }
912 
913 contract Candidate {
914     enum Vote {
915         UNDECIDED,
916         APPROVE,
917         REJECT
918     }
919 
920     struct State {
921         uint256 start;
922         uint256 period;
923         uint256 approve;
924         uint256 reject;
925         mapping(address => Vote) votes;
926         bool initialized;
927     }
928 }
929 
930 contract Storage {
931     struct Provider {
932         IDollar dollar;
933         IOracle oracle;
934         address pool;
935         address treasury;
936     }
937 
938     struct Balance {
939         uint256 supply;
940         uint256 bonded;
941         uint256 staged;
942         uint256 redeemable;
943         uint256 debt;
944         uint256 coupons;
945     }
946 
947     struct State {
948         Epoch.Global epoch;
949         Balance balance;
950         Provider provider;
951 
952         mapping(address => Account.State) accounts;
953         mapping(uint256 => Epoch.State) epochs;
954         mapping(address => Candidate.State) candidates;
955     }
956 }
957 
958 contract State {
959     Storage.State _state;
960 }
961 
962 /*
963     Copyright 2020 Empty Set Squad <emptysetsquad@protonmail.com>
964 
965     Licensed under the Apache License, Version 2.0 (the "License");
966     you may not use this file except in compliance with the License.
967     You may obtain a copy of the License at
968 
969     http://www.apache.org/licenses/LICENSE-2.0
970 
971     Unless required by applicable law or agreed to in writing, software
972     distributed under the License is distributed on an "AS IS" BASIS,
973     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
974     See the License for the specific language governing permissions and
975     limitations under the License.
976 */
977 
978 contract Getters is State {
979     using SafeMath for uint256;
980     using Decimal for Decimal.D256;
981 
982     bytes32 private constant IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
983 
984     /**
985      * ERC20 Interface
986      */
987 
988     function name() public view returns (string memory) {
989         return "Empty Set Dollar Stake";
990     }
991 
992     function symbol() public view returns (string memory) {
993         return "ESDS";
994     }
995 
996     function decimals() public view returns (uint8) {
997         return 18;
998     }
999 
1000     function balanceOf(address account) public view returns (uint256) {
1001         return _state.accounts[account].balance;
1002     }
1003 
1004     function totalSupply() public view returns (uint256) {
1005         return _state.balance.supply;
1006     }
1007 
1008     function allowance(address owner, address spender) external view returns (uint256) {
1009         return 0;
1010     }
1011 
1012     /**
1013      * Global
1014      */
1015 
1016     function dollar() public view returns (IDollar) {
1017         return _state.provider.dollar;
1018     }
1019     
1020     function treasury() public view returns (address) {
1021         return _state.provider.treasury;
1022     }
1023 
1024     function oracle() public view returns (IOracle) {
1025         return _state.provider.oracle;
1026     }
1027 
1028     function pool() public view returns (address) {
1029         return _state.provider.pool;
1030     }
1031 
1032     function totalBonded() public view returns (uint256) {
1033         return _state.balance.bonded;
1034     }
1035 
1036     function totalStaged() public view returns (uint256) {
1037         return _state.balance.staged;
1038     }
1039 
1040     function totalDebt() public view returns (uint256) {
1041         return _state.balance.debt;
1042     }
1043 
1044     function totalRedeemable() public view returns (uint256) {
1045         return _state.balance.redeemable;
1046     }
1047 
1048     function totalCoupons() public view returns (uint256) {
1049         return _state.balance.coupons;
1050     }
1051 
1052     function totalNet() public view returns (uint256) {
1053         return IDollar(dollar()).totalSupply().sub(totalDebt());
1054     }
1055 
1056     /**
1057      * Account
1058      */
1059 
1060     function balanceOfStaged(address account) public view returns (uint256) {
1061         return _state.accounts[account].staged;
1062     }
1063 
1064     function balanceOfBonded(address account) public view returns (uint256) {
1065         uint256 totalSupply = totalSupply();
1066         if (totalSupply == 0) {
1067             return 0;
1068         }
1069         return totalBonded().mul(balanceOf(account)).div(totalSupply);
1070     }
1071 
1072     function balanceOfCoupons(address account, uint256 epoch) public view returns (uint256) {
1073         if (outstandingCoupons(epoch) == 0) {
1074             return 0;
1075         }
1076         return _state.accounts[account].coupons[epoch];
1077     }
1078 
1079     function statusOf(address account) public view returns (Account.Status) {
1080         if (_state.accounts[account].lockedUntil > epoch()) {
1081             return Account.Status.Locked;
1082         }
1083 
1084         return epoch() >= _state.accounts[account].fluidUntil ? Account.Status.Frozen : Account.Status.Fluid;
1085     }
1086 
1087     function fluidUntil(address account) public view returns (uint256) {
1088         return _state.accounts[account].fluidUntil;
1089     }
1090 
1091     function lockedUntil(address account) public view returns (uint256) {
1092         return _state.accounts[account].lockedUntil;
1093     }
1094 
1095     function allowanceCoupons(address owner, address spender) public view returns (uint256) {
1096         return _state.accounts[owner].couponAllowances[spender];
1097     }
1098 
1099     /**
1100      * Epoch
1101      */
1102 
1103     function epoch() public view returns (uint256) {
1104         return _state.epoch.current;
1105     }
1106 
1107     function epochTime() public view returns (uint256) {
1108         Constants.EpochStrategy memory current = Constants.getCurrentEpochStrategy();
1109         Constants.EpochStrategy memory previous = Constants.getPreviousEpochStrategy();
1110 
1111         return blockTimestamp() < current.start ?
1112             epochTimeWithStrategy(previous) :
1113             epochTimeWithStrategy(current);
1114     }
1115 
1116     function epochTimeWithStrategy(Constants.EpochStrategy memory strategy) private view returns (uint256) {
1117         return blockTimestamp()
1118             .sub(strategy.start)
1119             .div(strategy.period)
1120             .add(strategy.offset);
1121     }
1122 
1123     // Overridable for testing
1124     function blockTimestamp() internal view returns (uint256) {
1125         return block.timestamp;
1126     }
1127 
1128     function outstandingCoupons(uint256 epoch) public view returns (uint256) {
1129         return _state.epochs[epoch].coupons.outstanding;
1130     }
1131 
1132     function couponsExpiration(uint256 epoch) public view returns (uint256) {
1133         return _state.epochs[epoch].coupons.expiration;
1134     }
1135 
1136     function expiringCoupons(uint256 epoch) public view returns (uint256) {
1137         return _state.epochs[epoch].coupons.expiring.length;
1138     }
1139 
1140     function expiringCouponsAtIndex(uint256 epoch, uint256 i) public view returns (uint256) {
1141         return _state.epochs[epoch].coupons.expiring[i];
1142     }
1143 
1144     function totalBondedAt(uint256 epoch) public view returns (uint256) {
1145         return _state.epochs[epoch].bonded;
1146     }
1147 
1148     function bootstrappingAt(uint256 epoch) public view returns (bool) {
1149         return epoch <= Constants.getBootstrappingPeriod();
1150     }
1151     
1152     function lastEpochTime() public view returns (uint256) {
1153         return _state.epoch.lastEpochTime;
1154     }
1155 
1156     /**
1157      * Governance
1158      */
1159 
1160     function recordedVote(address account, address candidate) public view returns (Candidate.Vote) {
1161         return _state.candidates[candidate].votes[account];
1162     }
1163 
1164     function startFor(address candidate) public view returns (uint256) {
1165         return _state.candidates[candidate].start;
1166     }
1167 
1168     function periodFor(address candidate) public view returns (uint256) {
1169         return _state.candidates[candidate].period;
1170     }
1171 
1172     function approveFor(address candidate) public view returns (uint256) {
1173         return _state.candidates[candidate].approve;
1174     }
1175 
1176     function rejectFor(address candidate) public view returns (uint256) {
1177         return _state.candidates[candidate].reject;
1178     }
1179 
1180     function votesFor(address candidate) public view returns (uint256) {
1181         return approveFor(candidate).add(rejectFor(candidate));
1182     }
1183 
1184     function isNominated(address candidate) public view returns (bool) {
1185         return _state.candidates[candidate].start > 0;
1186     }
1187 
1188     function isInitialized(address candidate) public view returns (bool) {
1189         return _state.candidates[candidate].initialized;
1190     }
1191 
1192     function implementation() public view returns (address impl) {
1193         bytes32 slot = IMPLEMENTATION_SLOT;
1194         assembly {
1195             impl := sload(slot)
1196         }
1197     }
1198 }
1199 
1200 /*
1201     Copyright 2020 Empty Set Squad <emptysetsquad@protonmail.com>
1202 
1203     Licensed under the Apache License, Version 2.0 (the "License");
1204     you may not use this file except in compliance with the License.
1205     You may obtain a copy of the License at
1206 
1207     http://www.apache.org/licenses/LICENSE-2.0
1208 
1209     Unless required by applicable law or agreed to in writing, software
1210     distributed under the License is distributed on an "AS IS" BASIS,
1211     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1212     See the License for the specific language governing permissions and
1213     limitations under the License.
1214 */
1215 
1216 contract Setters is State, Getters {
1217     using SafeMath for uint256;
1218 
1219     event Transfer(address indexed from, address indexed to, uint256 value);
1220 
1221     /**
1222      * ERC20 Interface
1223      */
1224 
1225     function transfer(address recipient, uint256 amount) external returns (bool) {
1226         return false;
1227     }
1228 
1229     function approve(address spender, uint256 amount) external returns (bool) {
1230         return false;
1231     }
1232 
1233     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool) {
1234         return false;
1235     }
1236 
1237     /**
1238      * Global
1239      */
1240 
1241     function incrementTotalBonded(uint256 amount) internal {
1242         _state.balance.bonded = _state.balance.bonded.add(amount);
1243     }
1244 
1245     function decrementTotalBonded(uint256 amount, string memory reason) internal {
1246         _state.balance.bonded = _state.balance.bonded.sub(amount, reason);
1247     }
1248 
1249     function incrementTotalDebt(uint256 amount) internal {
1250         _state.balance.debt = _state.balance.debt.add(amount);
1251     }
1252 
1253     function decrementTotalDebt(uint256 amount, string memory reason) internal {
1254         _state.balance.debt = _state.balance.debt.sub(amount, reason);
1255     }
1256 
1257     function incrementTotalRedeemable(uint256 amount) internal {
1258         _state.balance.redeemable = _state.balance.redeemable.add(amount);
1259     }
1260 
1261     function decrementTotalRedeemable(uint256 amount, string memory reason) internal {
1262         _state.balance.redeemable = _state.balance.redeemable.sub(amount, reason);
1263     }
1264     
1265     function updateLastEpochTime(uint256 _lastEpochTime) internal {
1266         _state.epoch.lastEpochTime = _lastEpochTime;
1267     }
1268     
1269     function resetLastEpochTime() internal {
1270         _state.epoch.lastEpochTime = 0;
1271     }
1272 
1273     /**
1274      * Account
1275      */
1276 
1277     function incrementBalanceOf(address account, uint256 amount) internal {
1278         _state.accounts[account].balance = _state.accounts[account].balance.add(amount);
1279         _state.balance.supply = _state.balance.supply.add(amount);
1280 
1281         emit Transfer(address(0), account, amount);
1282     }
1283 
1284     function decrementBalanceOf(address account, uint256 amount, string memory reason) internal {
1285         _state.accounts[account].balance = _state.accounts[account].balance.sub(amount, reason);
1286         _state.balance.supply = _state.balance.supply.sub(amount, reason);
1287 
1288         emit Transfer(account, address(0), amount);
1289     }
1290 
1291     function incrementBalanceOfStaged(address account, uint256 amount) internal {
1292         _state.accounts[account].staged = _state.accounts[account].staged.add(amount);
1293         _state.balance.staged = _state.balance.staged.add(amount);
1294     }
1295 
1296     function decrementBalanceOfStaged(address account, uint256 amount, string memory reason) internal {
1297         _state.accounts[account].staged = _state.accounts[account].staged.sub(amount, reason);
1298         _state.balance.staged = _state.balance.staged.sub(amount, reason);
1299     }
1300 
1301     function incrementBalanceOfCoupons(address account, uint256 epoch, uint256 amount) internal {
1302         _state.accounts[account].coupons[epoch] = _state.accounts[account].coupons[epoch].add(amount);
1303         _state.epochs[epoch].coupons.outstanding = _state.epochs[epoch].coupons.outstanding.add(amount);
1304         _state.balance.coupons = _state.balance.coupons.add(amount);
1305     }
1306 
1307     function decrementBalanceOfCoupons(address account, uint256 epoch, uint256 amount, string memory reason) internal {
1308         _state.accounts[account].coupons[epoch] = _state.accounts[account].coupons[epoch].sub(amount, reason);
1309         _state.epochs[epoch].coupons.outstanding = _state.epochs[epoch].coupons.outstanding.sub(amount, reason);
1310         _state.balance.coupons = _state.balance.coupons.sub(amount, reason);
1311     }
1312 
1313     function unfreeze(address account) internal {
1314         _state.accounts[account].fluidUntil = epoch().add(Constants.getDAOExitLockupEpochs());
1315     }
1316 
1317     function updateAllowanceCoupons(address owner, address spender, uint256 amount) internal {
1318         _state.accounts[owner].couponAllowances[spender] = amount;
1319     }
1320 
1321     function decrementAllowanceCoupons(address owner, address spender, uint256 amount, string memory reason) internal {
1322         _state.accounts[owner].couponAllowances[spender] =
1323             _state.accounts[owner].couponAllowances[spender].sub(amount, reason);
1324     }
1325 
1326     /**
1327      * Epoch
1328      */
1329 
1330     function incrementEpoch() internal {
1331         _state.epoch.current = _state.epoch.current.add(1);
1332     }
1333 
1334     function snapshotTotalBonded() internal {
1335         _state.epochs[epoch()].bonded = totalSupply();
1336     }
1337 
1338     function initializeCouponsExpiration(uint256 epoch, uint256 expiration) internal {
1339         _state.epochs[epoch].coupons.expiration = expiration;
1340         _state.epochs[expiration].coupons.expiring.push(epoch);
1341     }
1342 
1343     function eliminateOutstandingCoupons(uint256 epoch) internal {
1344         uint256 outstandingCouponsForEpoch = outstandingCoupons(epoch);
1345         if(outstandingCouponsForEpoch == 0) {
1346             return;
1347         }
1348         _state.balance.coupons = _state.balance.coupons.sub(outstandingCouponsForEpoch);
1349         _state.epochs[epoch].coupons.outstanding = 0;
1350     }
1351 
1352     /**
1353      * Governance
1354      */
1355 
1356     function createCandidate(address candidate, uint256 period) internal {
1357         _state.candidates[candidate].start = epoch();
1358         _state.candidates[candidate].period = period;
1359     }
1360 
1361     function recordVote(address account, address candidate, Candidate.Vote vote) internal {
1362         _state.candidates[candidate].votes[account] = vote;
1363     }
1364 
1365     function incrementApproveFor(address candidate, uint256 amount) internal {
1366         _state.candidates[candidate].approve = _state.candidates[candidate].approve.add(amount);
1367     }
1368 
1369     function decrementApproveFor(address candidate, uint256 amount, string memory reason) internal {
1370         _state.candidates[candidate].approve = _state.candidates[candidate].approve.sub(amount, reason);
1371     }
1372 
1373     function incrementRejectFor(address candidate, uint256 amount) internal {
1374         _state.candidates[candidate].reject = _state.candidates[candidate].reject.add(amount);
1375     }
1376 
1377     function decrementRejectFor(address candidate, uint256 amount, string memory reason) internal {
1378         _state.candidates[candidate].reject = _state.candidates[candidate].reject.sub(amount, reason);
1379     }
1380 
1381     function placeLock(address account, address candidate) internal {
1382         uint256 currentLock = _state.accounts[account].lockedUntil;
1383         uint256 newLock = startFor(candidate).add(periodFor(candidate));
1384         if (newLock > currentLock) {
1385             _state.accounts[account].lockedUntil = newLock;
1386         }
1387     }
1388 
1389     function initialized(address candidate) internal {
1390         _state.candidates[candidate].initialized = true;
1391     }
1392 }
1393 
1394 /*
1395     Copyright 2019 dYdX Trading Inc.
1396 
1397     Licensed under the Apache License, Version 2.0 (the "License");
1398     you may not use this file except in compliance with the License.
1399     You may obtain a copy of the License at
1400 
1401     http://www.apache.org/licenses/LICENSE-2.0
1402 
1403     Unless required by applicable law or agreed to in writing, software
1404     distributed under the License is distributed on an "AS IS" BASIS,
1405     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1406     See the License for the specific language governing permissions and
1407     limitations under the License.
1408 */
1409 
1410 /**
1411  * @title Require
1412  * @author dYdX
1413  *
1414  * Stringifies parameters to pretty-print revert messages. Costs more gas than regular require()
1415  */
1416 library Require {
1417 
1418     // ============ Constants ============
1419 
1420     uint256 constant ASCII_ZERO = 48; // '0'
1421     uint256 constant ASCII_RELATIVE_ZERO = 87; // 'a' - 10
1422     uint256 constant ASCII_LOWER_EX = 120; // 'x'
1423     bytes2 constant COLON = 0x3a20; // ': '
1424     bytes2 constant COMMA = 0x2c20; // ', '
1425     bytes2 constant LPAREN = 0x203c; // ' <'
1426     byte constant RPAREN = 0x3e; // '>'
1427     uint256 constant FOUR_BIT_MASK = 0xf;
1428 
1429     // ============ Library Functions ============
1430 
1431     function that(
1432         bool must,
1433         bytes32 file,
1434         bytes32 reason
1435     )
1436     internal
1437     pure
1438     {
1439         if (!must) {
1440             revert(
1441                 string(
1442                     abi.encodePacked(
1443                         stringifyTruncated(file),
1444                         COLON,
1445                         stringifyTruncated(reason)
1446                     )
1447                 )
1448             );
1449         }
1450     }
1451 
1452     function that(
1453         bool must,
1454         bytes32 file,
1455         bytes32 reason,
1456         uint256 payloadA
1457     )
1458     internal
1459     pure
1460     {
1461         if (!must) {
1462             revert(
1463                 string(
1464                     abi.encodePacked(
1465                         stringifyTruncated(file),
1466                         COLON,
1467                         stringifyTruncated(reason),
1468                         LPAREN,
1469                         stringify(payloadA),
1470                         RPAREN
1471                     )
1472                 )
1473             );
1474         }
1475     }
1476 
1477     function that(
1478         bool must,
1479         bytes32 file,
1480         bytes32 reason,
1481         uint256 payloadA,
1482         uint256 payloadB
1483     )
1484     internal
1485     pure
1486     {
1487         if (!must) {
1488             revert(
1489                 string(
1490                     abi.encodePacked(
1491                         stringifyTruncated(file),
1492                         COLON,
1493                         stringifyTruncated(reason),
1494                         LPAREN,
1495                         stringify(payloadA),
1496                         COMMA,
1497                         stringify(payloadB),
1498                         RPAREN
1499                     )
1500                 )
1501             );
1502         }
1503     }
1504 
1505     function that(
1506         bool must,
1507         bytes32 file,
1508         bytes32 reason,
1509         address payloadA
1510     )
1511     internal
1512     pure
1513     {
1514         if (!must) {
1515             revert(
1516                 string(
1517                     abi.encodePacked(
1518                         stringifyTruncated(file),
1519                         COLON,
1520                         stringifyTruncated(reason),
1521                         LPAREN,
1522                         stringify(payloadA),
1523                         RPAREN
1524                     )
1525                 )
1526             );
1527         }
1528     }
1529 
1530     function that(
1531         bool must,
1532         bytes32 file,
1533         bytes32 reason,
1534         address payloadA,
1535         uint256 payloadB
1536     )
1537     internal
1538     pure
1539     {
1540         if (!must) {
1541             revert(
1542                 string(
1543                     abi.encodePacked(
1544                         stringifyTruncated(file),
1545                         COLON,
1546                         stringifyTruncated(reason),
1547                         LPAREN,
1548                         stringify(payloadA),
1549                         COMMA,
1550                         stringify(payloadB),
1551                         RPAREN
1552                     )
1553                 )
1554             );
1555         }
1556     }
1557 
1558     function that(
1559         bool must,
1560         bytes32 file,
1561         bytes32 reason,
1562         address payloadA,
1563         uint256 payloadB,
1564         uint256 payloadC
1565     )
1566     internal
1567     pure
1568     {
1569         if (!must) {
1570             revert(
1571                 string(
1572                     abi.encodePacked(
1573                         stringifyTruncated(file),
1574                         COLON,
1575                         stringifyTruncated(reason),
1576                         LPAREN,
1577                         stringify(payloadA),
1578                         COMMA,
1579                         stringify(payloadB),
1580                         COMMA,
1581                         stringify(payloadC),
1582                         RPAREN
1583                     )
1584                 )
1585             );
1586         }
1587     }
1588 
1589     function that(
1590         bool must,
1591         bytes32 file,
1592         bytes32 reason,
1593         bytes32 payloadA
1594     )
1595     internal
1596     pure
1597     {
1598         if (!must) {
1599             revert(
1600                 string(
1601                     abi.encodePacked(
1602                         stringifyTruncated(file),
1603                         COLON,
1604                         stringifyTruncated(reason),
1605                         LPAREN,
1606                         stringify(payloadA),
1607                         RPAREN
1608                     )
1609                 )
1610             );
1611         }
1612     }
1613 
1614     function that(
1615         bool must,
1616         bytes32 file,
1617         bytes32 reason,
1618         bytes32 payloadA,
1619         uint256 payloadB,
1620         uint256 payloadC
1621     )
1622     internal
1623     pure
1624     {
1625         if (!must) {
1626             revert(
1627                 string(
1628                     abi.encodePacked(
1629                         stringifyTruncated(file),
1630                         COLON,
1631                         stringifyTruncated(reason),
1632                         LPAREN,
1633                         stringify(payloadA),
1634                         COMMA,
1635                         stringify(payloadB),
1636                         COMMA,
1637                         stringify(payloadC),
1638                         RPAREN
1639                     )
1640                 )
1641             );
1642         }
1643     }
1644 
1645     // ============ Private Functions ============
1646 
1647     function stringifyTruncated(
1648         bytes32 input
1649     )
1650     private
1651     pure
1652     returns (bytes memory)
1653     {
1654         // put the input bytes into the result
1655         bytes memory result = abi.encodePacked(input);
1656 
1657         // determine the length of the input by finding the location of the last non-zero byte
1658         for (uint256 i = 32; i > 0; ) {
1659             // reverse-for-loops with unsigned integer
1660             /* solium-disable-next-line security/no-modify-for-iter-var */
1661             i--;
1662 
1663             // find the last non-zero byte in order to determine the length
1664             if (result[i] != 0) {
1665                 uint256 length = i + 1;
1666 
1667                 /* solium-disable-next-line security/no-inline-assembly */
1668                 assembly {
1669                     mstore(result, length) // r.length = length;
1670                 }
1671 
1672                 return result;
1673             }
1674         }
1675 
1676         // all bytes are zero
1677         return new bytes(0);
1678     }
1679 
1680     function stringify(
1681         uint256 input
1682     )
1683     private
1684     pure
1685     returns (bytes memory)
1686     {
1687         if (input == 0) {
1688             return "0";
1689         }
1690 
1691         // get the final string length
1692         uint256 j = input;
1693         uint256 length;
1694         while (j != 0) {
1695             length++;
1696             j /= 10;
1697         }
1698 
1699         // allocate the string
1700         bytes memory bstr = new bytes(length);
1701 
1702         // populate the string starting with the least-significant character
1703         j = input;
1704         for (uint256 i = length; i > 0; ) {
1705             // reverse-for-loops with unsigned integer
1706             /* solium-disable-next-line security/no-modify-for-iter-var */
1707             i--;
1708 
1709             // take last decimal digit
1710             bstr[i] = byte(uint8(ASCII_ZERO + (j % 10)));
1711 
1712             // remove the last decimal digit
1713             j /= 10;
1714         }
1715 
1716         return bstr;
1717     }
1718 
1719     function stringify(
1720         address input
1721     )
1722     private
1723     pure
1724     returns (bytes memory)
1725     {
1726         uint256 z = uint256(input);
1727 
1728         // addresses are "0x" followed by 20 bytes of data which take up 2 characters each
1729         bytes memory result = new bytes(42);
1730 
1731         // populate the result with "0x"
1732         result[0] = byte(uint8(ASCII_ZERO));
1733         result[1] = byte(uint8(ASCII_LOWER_EX));
1734 
1735         // for each byte (starting from the lowest byte), populate the result with two characters
1736         for (uint256 i = 0; i < 20; i++) {
1737             // each byte takes two characters
1738             uint256 shift = i * 2;
1739 
1740             // populate the least-significant character
1741             result[41 - shift] = char(z & FOUR_BIT_MASK);
1742             z = z >> 4;
1743 
1744             // populate the most-significant character
1745             result[40 - shift] = char(z & FOUR_BIT_MASK);
1746             z = z >> 4;
1747         }
1748 
1749         return result;
1750     }
1751 
1752     function stringify(
1753         bytes32 input
1754     )
1755     private
1756     pure
1757     returns (bytes memory)
1758     {
1759         uint256 z = uint256(input);
1760 
1761         // bytes32 are "0x" followed by 32 bytes of data which take up 2 characters each
1762         bytes memory result = new bytes(66);
1763 
1764         // populate the result with "0x"
1765         result[0] = byte(uint8(ASCII_ZERO));
1766         result[1] = byte(uint8(ASCII_LOWER_EX));
1767 
1768         // for each byte (starting from the lowest byte), populate the result with two characters
1769         for (uint256 i = 0; i < 32; i++) {
1770             // each byte takes two characters
1771             uint256 shift = i * 2;
1772 
1773             // populate the least-significant character
1774             result[65 - shift] = char(z & FOUR_BIT_MASK);
1775             z = z >> 4;
1776 
1777             // populate the most-significant character
1778             result[64 - shift] = char(z & FOUR_BIT_MASK);
1779             z = z >> 4;
1780         }
1781 
1782         return result;
1783     }
1784 
1785     function char(
1786         uint256 input
1787     )
1788     private
1789     pure
1790     returns (byte)
1791     {
1792         // return ASCII digit (0-9)
1793         if (input < 10) {
1794             return byte(uint8(input + ASCII_ZERO));
1795         }
1796 
1797         // return ASCII letter (a-f)
1798         return byte(uint8(input + ASCII_RELATIVE_ZERO));
1799     }
1800 }
1801 
1802 /*
1803     Copyright 2020 Empty Set Squad <emptysetsquad@protonmail.com>
1804 
1805     Licensed under the Apache License, Version 2.0 (the "License");
1806     you may not use this file except in compliance with the License.
1807     You may obtain a copy of the License at
1808 
1809     http://www.apache.org/licenses/LICENSE-2.0
1810 
1811     Unless required by applicable law or agreed to in writing, software
1812     distributed under the License is distributed on an "AS IS" BASIS,
1813     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1814     See the License for the specific language governing permissions and
1815     limitations under the License.
1816 */
1817 
1818 
1819 contract Comptroller is Setters {
1820     using SafeMath for uint256;
1821 
1822     bytes32 private constant FILE = "Comptroller";
1823 
1824     function mintToAccount(address account, uint256 amount) internal {
1825         IDollar(dollar()).mint(account, amount);
1826         if (!bootstrappingAt(epoch())) {
1827             increaseDebt(amount);
1828         }
1829 
1830         balanceCheck();
1831     }
1832 
1833     function burnFromAccount(address account, uint256 amount) internal {
1834         IDollar(dollar()).transferFrom(account, address(this), amount);
1835         IDollar(dollar()).burn(amount);
1836         decrementTotalDebt(amount, "Comptroller: not enough outstanding debt");
1837 
1838         balanceCheck();
1839     }
1840 
1841     function redeemToAccount(address account, uint256 amount) internal {
1842         IDollar(dollar()).transfer(account, amount);
1843         decrementTotalRedeemable(amount, "Comptroller: not enough redeemable balance");
1844 
1845         balanceCheck();
1846     }
1847 
1848     function burnRedeemable(uint256 amount) internal {
1849         IDollar(dollar()).burn(amount);
1850         decrementTotalRedeemable(amount, "Comptroller: not enough redeemable balance");
1851 
1852         balanceCheck();
1853     }
1854 
1855     function increaseDebt(uint256 amount) internal returns (uint256) {
1856         incrementTotalDebt(amount);
1857         uint256 lessDebt = resetDebt(Constants.getDebtRatioCap());
1858 
1859         balanceCheck();
1860 
1861         return lessDebt > amount ? 0 : amount.sub(lessDebt);
1862     }
1863 
1864     function decreaseDebt(uint256 amount) internal {
1865         decrementTotalDebt(amount, "Comptroller: not enough debt");
1866 
1867         balanceCheck();
1868     }
1869 
1870     function increaseSupply(uint256 newSupply) internal returns (uint256, uint256) {
1871         // 0-a. Pay out to Pool
1872         uint256 poolReward = newSupply.mul(Constants.getOraclePoolRatio()).div(100);
1873         mintToPool(poolReward);
1874 
1875         // 0-b. Pay out to Treasury
1876         uint256 treasuryReward = newSupply.mul(Constants.getTreasuryRatio()).div(10000);
1877         mintToTreasury(treasuryReward);
1878 
1879         uint256 rewards = poolReward.add(treasuryReward);
1880         newSupply = newSupply > rewards ? newSupply.sub(rewards) : 0;
1881 
1882         // 1. True up redeemable pool
1883         uint256 newRedeemable = 0;
1884         uint256 totalRedeemable = totalRedeemable();
1885         uint256 totalCoupons = totalCoupons();
1886         if (totalRedeemable < totalCoupons) {
1887             newRedeemable = totalCoupons.sub(totalRedeemable);
1888             newRedeemable = newRedeemable > newSupply ? newSupply : newRedeemable;
1889             mintToRedeemable(newRedeemable);
1890             newSupply = newSupply.sub(newRedeemable);
1891         }
1892 
1893         // 2. Payout to DAO
1894         if (totalBonded() == 0) {
1895             newSupply = 0;
1896         }
1897         if (newSupply > 0) {
1898             mintToDAO(newSupply);
1899         }
1900 
1901         balanceCheck();
1902 
1903         return (newRedeemable, newSupply.add(rewards));
1904     }
1905 
1906     function resetDebt(Decimal.D256 memory targetDebtRatio) internal returns (uint256) {
1907         uint256 targetDebt = targetDebtRatio.mul(IDollar(dollar()).totalSupply()).asUint256();
1908         uint256 currentDebt = totalDebt();
1909 
1910         if (currentDebt > targetDebt) {
1911             uint256 lessDebt = currentDebt.sub(targetDebt);
1912             decreaseDebt(lessDebt);
1913 
1914             return lessDebt;
1915         }
1916 
1917         return 0;
1918     }
1919 
1920     function balanceCheck() private {
1921         Require.that(
1922             IDollar(dollar()).balanceOf(address(this)) >= totalBonded().add(totalStaged()).add(totalRedeemable()),
1923             FILE,
1924             "Inconsistent balances"
1925         );
1926     }
1927 
1928     function mintToDAO(uint256 amount) private {
1929         if (amount > 0) {
1930             IDollar(dollar()).mint(address(this), amount);
1931             incrementTotalBonded(amount);
1932         }
1933     }
1934 
1935     function mintToPool(uint256 amount) private {
1936         if (amount > 0) {
1937             IDollar(dollar()).mint(pool(), amount);
1938         }
1939     }
1940 
1941     function mintToTreasury(uint256 amount) private {
1942         if (amount > 0) {
1943             IDollar(dollar()).mint(treasury(), amount);
1944         }
1945     }
1946 
1947     function mintToRedeemable(uint256 amount) private {
1948         IDollar(dollar()).mint(address(this), amount);
1949         incrementTotalRedeemable(amount);
1950 
1951         balanceCheck();
1952     }
1953 }
1954 
1955 /*
1956     Copyright 2020 Empty Set Squad <emptysetsquad@protonmail.com>
1957 
1958     Licensed under the Apache License, Version 2.0 (the "License");
1959     you may not use this file except in compliance with the License.
1960     You may obtain a copy of the License at
1961 
1962     http://www.apache.org/licenses/LICENSE-2.0
1963 
1964     Unless required by applicable law or agreed to in writing, software
1965     distributed under the License is distributed on an "AS IS" BASIS,
1966     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1967     See the License for the specific language governing permissions and
1968     limitations under the License.
1969 */
1970 
1971 
1972 contract Market is Comptroller, Curve {
1973     using SafeMath for uint256;
1974 
1975     bytes32 private constant FILE = "Market";
1976 
1977     event CouponExpiration(uint256 indexed epoch, uint256 couponsExpired, uint256 lessRedeemable, uint256 lessDebt, uint256 newBonded);
1978     event CouponPurchase(address indexed account, uint256 indexed epoch, uint256 dollarAmount, uint256 couponAmount);
1979     event CouponRedemption(address indexed account, uint256 indexed epoch, uint256 couponAmount);
1980     event CouponTransfer(address indexed from, address indexed to, uint256 indexed epoch, uint256 value);
1981     event CouponApproval(address indexed owner, address indexed spender, uint256 value);
1982 
1983     function step() internal {
1984         // Expire prior coupons
1985         for (uint256 i = 0; i < expiringCoupons(epoch()); i++) {
1986             expireCouponsForEpoch(expiringCouponsAtIndex(epoch(), i));
1987         }
1988 
1989         // Record expiry for current epoch's coupons
1990         uint256 expirationEpoch = epoch().add(Constants.getCouponExpiration());
1991         initializeCouponsExpiration(epoch(), expirationEpoch);
1992     }
1993 
1994     function expireCouponsForEpoch(uint256 epoch) private {
1995         uint256 couponsForEpoch = outstandingCoupons(epoch);
1996         (uint256 lessRedeemable, uint256 newBonded) = (0, 0);
1997 
1998         eliminateOutstandingCoupons(epoch);
1999 
2000         uint256 totalRedeemable = totalRedeemable();
2001         uint256 totalCoupons = totalCoupons();
2002         if (totalRedeemable > totalCoupons) {
2003             lessRedeemable = totalRedeemable.sub(totalCoupons);
2004             burnRedeemable(lessRedeemable);
2005             (, newBonded) = increaseSupply(lessRedeemable);
2006         }
2007 
2008         emit CouponExpiration(epoch, couponsForEpoch, lessRedeemable, 0, newBonded);
2009     }
2010 
2011     function couponPremium(uint256 amount) public view returns (uint256) {
2012         return calculateCouponPremium(IDollar(dollar()).totalSupply(), totalDebt(), amount);
2013     }
2014     function purchaseCoupons(uint256 dollarAmount) external returns (uint256) {
2015         Require.that(
2016             dollarAmount > 0,
2017             FILE,
2018             "Must purchase non-zero amount"
2019         );
2020 
2021         Require.that(
2022             totalDebt() >= dollarAmount,
2023             FILE,
2024             "Not enough debt"
2025         );
2026 
2027         uint256 epoch = epoch();
2028         uint256 couponAmount = dollarAmount.add(couponPremium(dollarAmount));
2029         burnFromAccount(msg.sender, dollarAmount);
2030         incrementBalanceOfCoupons(msg.sender, epoch, couponAmount);
2031 
2032         emit CouponPurchase(msg.sender, epoch, dollarAmount, couponAmount);
2033 
2034         return couponAmount;
2035     }
2036 
2037     function redeemCoupons(uint256 couponEpoch, uint256 couponAmount) external {
2038         require(epoch().sub(couponEpoch) >= 2, "Market: Too early to redeem");
2039         decrementBalanceOfCoupons(msg.sender, couponEpoch, couponAmount, "Market: Insufficient coupon balance");
2040         redeemToAccount(msg.sender, couponAmount);
2041 
2042         emit CouponRedemption(msg.sender, couponEpoch, couponAmount);
2043     }
2044 
2045     function approveCoupons(address spender, uint256 amount) external {
2046         require(spender != address(0), "Market: Coupon approve to the zero address");
2047 
2048         updateAllowanceCoupons(msg.sender, spender, amount);
2049 
2050         emit CouponApproval(msg.sender, spender, amount);
2051     }
2052 
2053     function transferCoupons(address sender, address recipient, uint256 epoch, uint256 amount) external {
2054         require(sender != address(0), "Market: Coupon transfer from the zero address");
2055         require(recipient != address(0), "Market: Coupon transfer to the zero address");
2056 
2057         decrementBalanceOfCoupons(sender, epoch, amount, "Market: Insufficient coupon balance");
2058         incrementBalanceOfCoupons(recipient, epoch, amount);
2059 
2060         if (msg.sender != sender && allowanceCoupons(sender, msg.sender) != uint256(-1)) {
2061             decrementAllowanceCoupons(sender, msg.sender, amount, "Market: Insufficient coupon approval");
2062         }
2063 
2064         emit CouponTransfer(sender, recipient, epoch, amount);
2065     }
2066 }
2067 
2068 /*
2069     Copyright 2020 Empty Set Squad <emptysetsquad@protonmail.com>
2070 
2071     Licensed under the Apache License, Version 2.0 (the "License");
2072     you may not use this file except in compliance with the License.
2073     You may obtain a copy of the License at
2074 
2075     http://www.apache.org/licenses/LICENSE-2.0
2076 
2077     Unless required by applicable law or agreed to in writing, software
2078     distributed under the License is distributed on an "AS IS" BASIS,
2079     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2080     See the License for the specific language governing permissions and
2081     limitations under the License.
2082 */
2083 
2084 
2085 contract Regulator is Comptroller {
2086     using SafeMath for uint256;
2087     using Decimal for Decimal.D256;
2088 
2089     event SupplyIncrease(uint256 indexed epoch, uint256 price, uint256 newRedeemable, uint256 lessDebt, uint256 newBonded);
2090     event SupplyDecrease(uint256 indexed epoch, uint256 price, uint256 newDebt);
2091     event SupplyNeutral(uint256 indexed epoch);
2092 
2093     function step() internal {
2094         Decimal.D256 memory price = oracleCapture();
2095 
2096         if (price.greaterThan(Decimal.one())) {
2097             growSupply(price);
2098             return;
2099         }
2100 
2101         if (price.lessThan(Decimal.one())) {
2102             shrinkSupply(price);
2103             return;
2104         }
2105 
2106         emit SupplyNeutral(epoch());
2107     }
2108 
2109     function shrinkSupply(Decimal.D256 memory price) private {
2110         Decimal.D256 memory delta = limit(Decimal.one().sub(price), price);
2111         uint256 newDebt = delta.mul(totalNet()).asUint256();
2112         uint256 cappedNewDebt = increaseDebt(newDebt);
2113 
2114         emit SupplyDecrease(epoch(), price.value, cappedNewDebt);
2115         return;
2116     }
2117 
2118     function growSupply(Decimal.D256 memory price) private {
2119         uint256 lessDebt = resetDebt(Decimal.zero());
2120 
2121         Decimal.D256 memory delta = limit(price.sub(Decimal.one()), price);
2122         uint256 newSupply = delta.mul(totalNet()).asUint256();
2123         (uint256 newRedeemable, uint256 newBonded) = increaseSupply(newSupply);
2124         emit SupplyIncrease(epoch(), price.value, newRedeemable, lessDebt, newBonded);
2125     }
2126 
2127     function limit(Decimal.D256 memory delta, Decimal.D256 memory price) private view returns (Decimal.D256 memory) {
2128 
2129         Decimal.D256 memory supplyChangeLimit = Constants.getSupplyChangeLimit();
2130         
2131         uint256 totalRedeemable = totalRedeemable();
2132         uint256 totalCoupons = totalCoupons();
2133         if (price.greaterThan(Decimal.one()) && (totalRedeemable < totalCoupons)) {
2134             supplyChangeLimit = Constants.getCouponSupplyChangeLimit();
2135         }
2136 
2137         return delta.greaterThan(supplyChangeLimit) ? supplyChangeLimit : delta;
2138 
2139     }
2140 
2141     function oracleCapture() private returns (Decimal.D256 memory) {
2142         (Decimal.D256 memory price, bool valid) = oracle().capture();
2143 
2144         if (bootstrappingAt(epoch().sub(1))) {
2145             return Constants.getBootstrappingPrice();
2146         }
2147         if (!valid) {
2148             return Decimal.one();
2149         }
2150 
2151         return price;
2152     }
2153 }
2154 
2155 /*
2156     Copyright 2020 Empty Set Squad <emptysetsquad@protonmail.com>
2157 
2158     Licensed under the Apache License, Version 2.0 (the "License");
2159     you may not use this file except in compliance with the License.
2160     You may obtain a copy of the License at
2161 
2162     http://www.apache.org/licenses/LICENSE-2.0
2163 
2164     Unless required by applicable law or agreed to in writing, software
2165     distributed under the License is distributed on an "AS IS" BASIS,
2166     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2167     See the License for the specific language governing permissions and
2168     limitations under the License.
2169 */
2170 
2171 contract Permission is Setters {
2172 
2173     bytes32 private constant FILE = "Permission";
2174 
2175     // Can modify account state
2176     modifier onlyFrozenOrFluid(address account) {
2177         Require.that(
2178             statusOf(account) != Account.Status.Locked,
2179             FILE,
2180             "Not frozen or fluid"
2181         );
2182 
2183         _;
2184     }
2185 
2186     // Can participate in balance-dependant activities
2187     modifier onlyFrozenOrLocked(address account) {
2188         Require.that(
2189             statusOf(account) != Account.Status.Fluid,
2190             FILE,
2191             "Not frozen or locked"
2192         );
2193 
2194         _;
2195     }
2196 
2197     modifier initializer() {
2198         Require.that(
2199             !isInitialized(implementation()),
2200             FILE,
2201             "Already initialized"
2202         );
2203 
2204         initialized(implementation());
2205 
2206         _;
2207     }
2208 }
2209 
2210 /*
2211     Copyright 2020 Empty Set Squad <emptysetsquad@protonmail.com>
2212 
2213     Licensed under the Apache License, Version 2.0 (the "License");
2214     you may not use this file except in compliance with the License.
2215     You may obtain a copy of the License at
2216 
2217     http://www.apache.org/licenses/LICENSE-2.0
2218 
2219     Unless required by applicable law or agreed to in writing, software
2220     distributed under the License is distributed on an "AS IS" BASIS,
2221     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2222     See the License for the specific language governing permissions and
2223     limitations under the License.
2224 */
2225 
2226 
2227 
2228 contract Bonding is Setters, Permission {
2229     using SafeMath for uint256;
2230 
2231     bytes32 private constant FILE = "Bonding";
2232 
2233     event Deposit(address indexed account, uint256 value);
2234     event Withdraw(address indexed account, uint256 value);
2235     event Bond(address indexed account, uint256 start, uint256 value, uint256 valueUnderlying);
2236     event Unbond(address indexed account, uint256 start, uint256 value, uint256 valueUnderlying);
2237 
2238     function step() internal {
2239         Require.that(
2240             epochTime() > epoch(),
2241             FILE,
2242             "Still current epoch"
2243         );
2244 
2245         snapshotTotalBonded();
2246         incrementEpoch();
2247     }
2248 
2249     function deposit(uint256 value) external onlyFrozenOrLocked(msg.sender) {
2250         IDollar(dollar()).transferFrom(msg.sender, address(this), value);
2251         incrementBalanceOfStaged(msg.sender, value);
2252 
2253         emit Deposit(msg.sender, value);
2254     }
2255 
2256     function withdraw(uint256 value) external onlyFrozenOrLocked(msg.sender) {
2257         IDollar(dollar()).transfer(msg.sender, value);
2258         decrementBalanceOfStaged(msg.sender, value, "Bonding: insufficient staged balance");
2259 
2260         emit Withdraw(msg.sender, value);
2261     }
2262 
2263     function bond(uint256 value) external onlyFrozenOrFluid(msg.sender) {
2264         unfreeze(msg.sender);
2265 
2266         uint256 balance = totalBonded() == 0 ?
2267             value.mul(Constants.getInitialStakeMultiple()) :
2268             value.mul(totalSupply()).div(totalBonded());
2269         incrementBalanceOf(msg.sender, balance);
2270         incrementTotalBonded(value);
2271         decrementBalanceOfStaged(msg.sender, value, "Bonding: insufficient staged balance");
2272 
2273         emit Bond(msg.sender, epoch().add(1), balance, value);
2274     }
2275 
2276     function unbond(uint256 value) external onlyFrozenOrFluid(msg.sender) {
2277         unfreeze(msg.sender);
2278 
2279         uint256 staged = value.mul(balanceOfBonded(msg.sender)).div(balanceOf(msg.sender));
2280         incrementBalanceOfStaged(msg.sender, staged);
2281         decrementTotalBonded(staged, "Bonding: insufficient total bonded");
2282         decrementBalanceOf(msg.sender, value, "Bonding: insufficient balance");
2283 
2284         emit Unbond(msg.sender, epoch().add(1), value, staged);
2285     }
2286 
2287     function unbondUnderlying(uint256 value) external onlyFrozenOrFluid(msg.sender) {
2288         unfreeze(msg.sender);
2289 
2290         uint256 balance = value.mul(totalSupply()).div(totalBonded());
2291         incrementBalanceOfStaged(msg.sender, value);
2292         decrementTotalBonded(value, "Bonding: insufficient total bonded");
2293         decrementBalanceOf(msg.sender, balance, "Bonding: insufficient balance");
2294 
2295         emit Unbond(msg.sender, epoch().add(1), balance, value);
2296     }
2297 }
2298 
2299 
2300 /**
2301  * Utility library of inline functions on addresses
2302  *
2303  * Source https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-solidity/v2.1.3/contracts/utils/Address.sol
2304  * This contract is copied here and renamed from the original to avoid clashes in the compiled artifacts
2305  * when the user imports a zos-lib contract (that transitively causes this contract to be compiled and added to the
2306  * build/artifacts folder) as well as the vanilla Address implementation from an openzeppelin version.
2307  */
2308 library OpenZeppelinUpgradesAddress {
2309     /**
2310      * Returns whether the target address is a contract
2311      * @dev This function will return false if invoked during the constructor of a contract,
2312      * as the code is not actually created until after the constructor finishes.
2313      * @param account address of the account to check
2314      * @return whether the target address is a contract
2315      */
2316     function isContract(address account) internal view returns (bool) {
2317         uint256 size;
2318         // XXX Currently there is no better way to check if there is a contract in an address
2319         // than to check the size of the code at that address.
2320         // See https://ethereum.stackexchange.com/a/14016/36603
2321         // for more details about how this works.
2322         // TODO Check this again before the Serenity release, because all addresses will be
2323         // contracts then.
2324         // solhint-disable-next-line no-inline-assembly
2325         assembly { size := extcodesize(account) }
2326         return size > 0;
2327     }
2328 }
2329 
2330 /*
2331     Copyright 2018-2019 zOS Global Limited
2332     Copyright 2020 Empty Set Squad <emptysetsquad@protonmail.com>
2333 
2334     Licensed under the Apache License, Version 2.0 (the "License");
2335     you may not use this file except in compliance with the License.
2336     You may obtain a copy of the License at
2337 
2338     http://www.apache.org/licenses/LICENSE-2.0
2339 
2340     Unless required by applicable law or agreed to in writing, software
2341     distributed under the License is distributed on an "AS IS" BASIS,
2342     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2343     See the License for the specific language governing permissions and
2344     limitations under the License.
2345 */
2346 
2347 /**
2348  * Based off of, and designed to interface with, openzeppelin/upgrades package
2349  */
2350 contract Upgradeable is State {
2351     /**
2352      * @dev Storage slot with the address of the current implementation.
2353      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
2354      * validated in the constructor.
2355      */
2356     bytes32 private constant IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
2357 
2358     /**
2359      * @dev Emitted when the implementation is upgraded.
2360      * @param implementation Address of the new implementation.
2361      */
2362     event Upgraded(address indexed implementation);
2363 
2364     function initialize() public;
2365 
2366     /**
2367      * @dev Upgrades the proxy to a new implementation.
2368      * @param newImplementation Address of the new implementation.
2369      */
2370     function upgradeTo(address newImplementation) internal {
2371         setImplementation(newImplementation);
2372 
2373         (bool success, bytes memory reason) = newImplementation.delegatecall(abi.encodeWithSignature("initialize()"));
2374         require(success, string(reason));
2375 
2376         emit Upgraded(newImplementation);
2377     }
2378 
2379     /**
2380      * @dev Sets the implementation address of the proxy.
2381      * @param newImplementation Address of the new implementation.
2382      */
2383     function setImplementation(address newImplementation) private {
2384         require(OpenZeppelinUpgradesAddress.isContract(newImplementation), "Cannot set a proxy implementation to a non-contract address");
2385 
2386         bytes32 slot = IMPLEMENTATION_SLOT;
2387 
2388         assembly {
2389             sstore(slot, newImplementation)
2390         }
2391     }
2392 }
2393 
2394 // File: contracts/dao/Govern.sol
2395 
2396 /*
2397     Copyright 2020 Empty Set Squad <emptysetsquad@protonmail.com>
2398 
2399     Licensed under the Apache License, Version 2.0 (the "License");
2400     you may not use this file except in compliance with the License.
2401     You may obtain a copy of the License at
2402 
2403     http://www.apache.org/licenses/LICENSE-2.0
2404 
2405     Unless required by applicable law or agreed to in writing, software
2406     distributed under the License is distributed on an "AS IS" BASIS,
2407     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2408     See the License for the specific language governing permissions and
2409     limitations under the License.
2410 */
2411 
2412 
2413 contract Govern is Setters, Permission, Upgradeable {
2414     using SafeMath for uint256;
2415     using Decimal for Decimal.D256;
2416 
2417     bytes32 private constant FILE = "Govern";
2418 
2419     event Proposal(address indexed candidate, address indexed account, uint256 indexed start, uint256 period);
2420     event Vote(address indexed account, address indexed candidate, Candidate.Vote vote, uint256 bonded);
2421     event Commit(address indexed account, address indexed candidate);
2422 
2423     function vote(address candidate, Candidate.Vote vote) external onlyFrozenOrLocked(msg.sender) {
2424         Require.that(
2425             balanceOf(msg.sender) > 0,
2426             FILE,
2427             "Must have stake"
2428         );
2429 
2430         if (!isNominated(candidate)) {
2431             Require.that(
2432                 canPropose(msg.sender),
2433                 FILE,
2434                 "Not enough stake to propose"
2435             );
2436 
2437             createCandidate(candidate, Constants.getGovernancePeriod());
2438             emit Proposal(candidate, msg.sender, epoch(), Constants.getGovernancePeriod());
2439         }
2440 
2441         Require.that(
2442             epoch() < startFor(candidate).add(periodFor(candidate)),
2443             FILE,
2444             "Ended"
2445         );
2446 
2447         uint256 bonded = balanceOf(msg.sender);
2448         Candidate.Vote recordedVote = recordedVote(msg.sender, candidate);
2449         if (vote == recordedVote) {
2450             return;
2451         }
2452 
2453         if (recordedVote == Candidate.Vote.REJECT) {
2454             decrementRejectFor(candidate, bonded, "Govern: Insufficient reject");
2455         }
2456         if (recordedVote == Candidate.Vote.APPROVE) {
2457             decrementApproveFor(candidate, bonded, "Govern: Insufficient approve");
2458         }
2459         if (vote == Candidate.Vote.REJECT) {
2460             incrementRejectFor(candidate, bonded);
2461         }
2462         if (vote == Candidate.Vote.APPROVE) {
2463             incrementApproveFor(candidate, bonded);
2464         }
2465 
2466         recordVote(msg.sender, candidate, vote);
2467         placeLock(msg.sender, candidate);
2468 
2469         emit Vote(msg.sender, candidate, vote, bonded);
2470     }
2471 
2472     function commit(address candidate) external {
2473         Require.that(
2474             isNominated(candidate),
2475             FILE,
2476             "Not nominated"
2477         );
2478 
2479         uint256 endsAfter = startFor(candidate).add(periodFor(candidate)).sub(1);
2480 
2481         Require.that(
2482             epoch() > endsAfter,
2483             FILE,
2484             "Not ended"
2485         );
2486 
2487         Require.that(
2488             epoch() <= endsAfter.add(1).add(Constants.getGovernanceExpiration()),
2489             FILE,
2490             "Expired"
2491         );
2492 
2493         Require.that(
2494             Decimal.ratio(votesFor(candidate), totalBondedAt(endsAfter)).greaterThan(Constants.getGovernanceQuorum()),
2495             FILE,
2496             "Must have quorom"
2497         );
2498 
2499         Require.that(
2500             approveFor(candidate) > rejectFor(candidate),
2501             FILE,
2502             "Not approved"
2503         );
2504 
2505         upgradeTo(candidate);
2506 
2507         emit Commit(msg.sender, candidate);
2508     }
2509 
2510     function emergencyCommit(address candidate) external {
2511         Require.that(
2512             isNominated(candidate),
2513             FILE,
2514             "Not nominated"
2515         );
2516 
2517         Require.that(
2518             epochTime() > epoch().add(Constants.getGovernanceEmergencyDelay()),
2519             FILE,
2520             "Epoch synced"
2521         );
2522 
2523         Require.that(
2524             Decimal.ratio(approveFor(candidate), totalSupply()).greaterThan(Constants.getGovernanceSuperMajority()),
2525             FILE,
2526             "Must have super majority"
2527         );
2528 
2529         Require.that(
2530             approveFor(candidate) > rejectFor(candidate),
2531             FILE,
2532             "Not approved"
2533         );
2534 
2535         upgradeTo(candidate);
2536 
2537         emit Commit(msg.sender, candidate);
2538     }
2539 
2540     function canPropose(address account) private view returns (bool) {
2541         if (totalBonded() == 0) {
2542             return false;
2543         }
2544 
2545         Decimal.D256 memory stake = Decimal.ratio(balanceOf(account), totalSupply());
2546         return stake.greaterThan(Constants.getGovernanceProposalThreshold());
2547     }
2548 }
2549 
2550 /*
2551     Copyright 2020 Empty Set Squad <emptysetsquad@protonmail.com>
2552 
2553     Licensed under the Apache License, Version 2.0 (the "License");
2554     you may not use this file except in compliance with the License.
2555     You may obtain a copy of the License at
2556 
2557     http://www.apache.org/licenses/LICENSE-2.0
2558 
2559     Unless required by applicable law or agreed to in writing, software
2560     distributed under the License is distributed on an "AS IS" BASIS,
2561     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2562     See the License for the specific language governing permissions and
2563     limitations under the License.
2564 */
2565 
2566 
2567 
2568 contract Implementation is State, Bonding, Market, Regulator, Govern {
2569     using SafeMath for uint256;
2570 
2571     bytes32 private constant FILE = "Implementation";
2572     event Advance(uint256 indexed epoch, uint256 block, uint256 timestamp);
2573     event Incentivization(address indexed account, uint256 amount);
2574     
2575     address public owner;
2576     
2577     constructor(address _oracle, address _dollar, address _pool, address _treasury) public { 
2578         _state.provider.pool = _pool;
2579         _state.provider.oracle = IOracle(_oracle);
2580         _state.provider.dollar = IDollar(_dollar);
2581         _state.provider.treasury = _treasury;
2582         owner = msg.sender;
2583     }
2584 
2585     function initialize() initializer public {
2586         // Reward committer
2587         incentivize(msg.sender, Constants.getAdvanceIncentive());
2588         // Dev rewards
2589         incentivize(msg.sender, 100000e18);
2590 
2591         // Cut the debt to 40% to ease any potential premium shock
2592         // uint256 decreaseAmount = totalDebt().mul(3).div(5);
2593         // decreaseDebt(decreaseAmount);
2594     }
2595 
2596     function advance() external {
2597         uint256 currentTimeStamp = block.timestamp;
2598         uint256 lastEpochTime = lastEpochTime();
2599         if(lastEpochTime !=0 )
2600         {
2601             require(currentTimeStamp.sub(lastEpochTime) > 3600, "Advance will be call after some time");
2602             resetLastEpochTime();
2603             updateLastEpochTime(currentTimeStamp);
2604         }
2605         else{
2606             updateLastEpochTime(currentTimeStamp);
2607         }
2608         
2609         incentivize(msg.sender, Constants.getAdvanceIncentive());
2610 
2611         Bonding.step();
2612         Regulator.step();
2613         Market.step();
2614 
2615         emit Advance(epoch(), block.number, block.timestamp);
2616     }
2617 
2618     function incentivize(address account, uint256 amount) private {
2619         mintToAccount(account, amount);
2620         emit Incentivization(account, amount);
2621     }
2622     
2623         
2624     modifier onlyOwner() {
2625         Require.that(
2626             msg.sender == owner,
2627             FILE,
2628             "Not owner"
2629         );
2630         _;
2631     }
2632 }