1 // File: @openzeppelin/upgrades/contracts/upgradeability/Proxy.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @title Proxy
7  * @dev Implements delegation of calls to other contracts, with proper
8  * forwarding of return values and bubbling of failures.
9  * It defines a fallback function that delegates all calls to the address
10  * returned by the abstract _implementation() internal function.
11  */
12 contract Proxy {
13   /**
14    * @dev Fallback function.
15    * Implemented entirely in `_fallback`.
16    */
17   function () payable external {
18     _fallback();
19   }
20 
21   /**
22    * @return The Address of the implementation.
23    */
24   function _implementation() internal view returns (address);
25 
26   /**
27    * @dev Delegates execution to an implementation contract.
28    * This is a low level function that doesn't return to its internal call site.
29    * It will return to the external caller whatever the implementation returns.
30    * @param implementation Address to delegate.
31    */
32   function _delegate(address implementation) internal {
33     assembly {
34       // Copy msg.data. We take full control of memory in this inline assembly
35       // block because it will not return to Solidity code. We overwrite the
36       // Solidity scratch pad at memory position 0.
37       calldatacopy(0, 0, calldatasize)
38 
39       // Call the implementation.
40       // out and outsize are 0 because we don't know the size yet.
41       let result := delegatecall(gas, implementation, 0, calldatasize, 0, 0)
42 
43       // Copy the returned data.
44       returndatacopy(0, 0, returndatasize)
45 
46       switch result
47       // delegatecall returns 0 on error.
48       case 0 { revert(0, returndatasize) }
49       default { return(0, returndatasize) }
50     }
51   }
52 
53   /**
54    * @dev Function that is run as the first thing in the fallback function.
55    * Can be redefined in derived contracts to add functionality.
56    * Redefinitions must call super._willFallback().
57    */
58   function _willFallback() internal {
59   }
60 
61   /**
62    * @dev fallback implementation.
63    * Extracted to enable manual triggering.
64    */
65   function _fallback() internal {
66     _willFallback();
67     _delegate(_implementation());
68   }
69 }
70 
71 // File: @openzeppelin/upgrades/contracts/utils/Address.sol
72 
73 pragma solidity ^0.5.0;
74 
75 /**
76  * Utility library of inline functions on addresses
77  *
78  * Source https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-solidity/v2.1.3/contracts/utils/Address.sol
79  * This contract is copied here and renamed from the original to avoid clashes in the compiled artifacts
80  * when the user imports a zos-lib contract (that transitively causes this contract to be compiled and added to the
81  * build/artifacts folder) as well as the vanilla Address implementation from an openzeppelin version.
82  */
83 library OpenZeppelinUpgradesAddress {
84     /**
85      * Returns whether the target address is a contract
86      * @dev This function will return false if invoked during the constructor of a contract,
87      * as the code is not actually created until after the constructor finishes.
88      * @param account address of the account to check
89      * @return whether the target address is a contract
90      */
91     function isContract(address account) internal view returns (bool) {
92         uint256 size;
93         // XXX Currently there is no better way to check if there is a contract in an address
94         // than to check the size of the code at that address.
95         // See https://ethereum.stackexchange.com/a/14016/36603
96         // for more details about how this works.
97         // TODO Check this again before the Serenity release, because all addresses will be
98         // contracts then.
99         // solhint-disable-next-line no-inline-assembly
100         assembly { size := extcodesize(account) }
101         return size > 0;
102     }
103 }
104 
105 // File: @openzeppelin/upgrades/contracts/upgradeability/BaseUpgradeabilityProxy.sol
106 
107 pragma solidity ^0.5.0;
108 
109 
110 
111 /**
112  * @title BaseUpgradeabilityProxy
113  * @dev This contract implements a proxy that allows to change the
114  * implementation address to which it will delegate.
115  * Such a change is called an implementation upgrade.
116  */
117 contract BaseUpgradeabilityProxy is Proxy {
118   /**
119    * @dev Emitted when the implementation is upgraded.
120    * @param implementation Address of the new implementation.
121    */
122   event Upgraded(address indexed implementation);
123 
124   /**
125    * @dev Storage slot with the address of the current implementation.
126    * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
127    * validated in the constructor.
128    */
129   bytes32 internal constant IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
130 
131   /**
132    * @dev Returns the current implementation.
133    * @return Address of the current implementation
134    */
135   function _implementation() internal view returns (address impl) {
136     bytes32 slot = IMPLEMENTATION_SLOT;
137     assembly {
138       impl := sload(slot)
139     }
140   }
141 
142   /**
143    * @dev Upgrades the proxy to a new implementation.
144    * @param newImplementation Address of the new implementation.
145    */
146   function _upgradeTo(address newImplementation) internal {
147     _setImplementation(newImplementation);
148     emit Upgraded(newImplementation);
149   }
150 
151   /**
152    * @dev Sets the implementation address of the proxy.
153    * @param newImplementation Address of the new implementation.
154    */
155   function _setImplementation(address newImplementation) internal {
156     require(OpenZeppelinUpgradesAddress.isContract(newImplementation), "Cannot set a proxy implementation to a non-contract address");
157 
158     bytes32 slot = IMPLEMENTATION_SLOT;
159 
160     assembly {
161       sstore(slot, newImplementation)
162     }
163   }
164 }
165 
166 // File: @openzeppelin/upgrades/contracts/upgradeability/UpgradeabilityProxy.sol
167 
168 pragma solidity ^0.5.0;
169 
170 
171 /**
172  * @title UpgradeabilityProxy
173  * @dev Extends BaseUpgradeabilityProxy with a constructor for initializing
174  * implementation and init data.
175  */
176 contract UpgradeabilityProxy is BaseUpgradeabilityProxy {
177   /**
178    * @dev Contract constructor.
179    * @param _logic Address of the initial implementation.
180    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
181    * It should include the signature and the parameters of the function to be called, as described in
182    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
183    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
184    */
185   constructor(address _logic, bytes memory _data) public payable {
186     assert(IMPLEMENTATION_SLOT == bytes32(uint256(keccak256('eip1967.proxy.implementation')) - 1));
187     _setImplementation(_logic);
188     if(_data.length > 0) {
189       (bool success,) = _logic.delegatecall(_data);
190       require(success);
191     }
192   }  
193 }
194 
195 // File: @openzeppelin/contracts/math/SafeMath.sol
196 
197 pragma solidity ^0.5.0;
198 
199 /**
200  * @dev Wrappers over Solidity's arithmetic operations with added overflow
201  * checks.
202  *
203  * Arithmetic operations in Solidity wrap on overflow. This can easily result
204  * in bugs, because programmers usually assume that an overflow raises an
205  * error, which is the standard behavior in high level programming languages.
206  * `SafeMath` restores this intuition by reverting the transaction when an
207  * operation overflows.
208  *
209  * Using this library instead of the unchecked operations eliminates an entire
210  * class of bugs, so it's recommended to use it always.
211  */
212 library SafeMath {
213     /**
214      * @dev Returns the addition of two unsigned integers, reverting on
215      * overflow.
216      *
217      * Counterpart to Solidity's `+` operator.
218      *
219      * Requirements:
220      * - Addition cannot overflow.
221      */
222     function add(uint256 a, uint256 b) internal pure returns (uint256) {
223         uint256 c = a + b;
224         require(c >= a, "SafeMath: addition overflow");
225 
226         return c;
227     }
228 
229     /**
230      * @dev Returns the subtraction of two unsigned integers, reverting on
231      * overflow (when the result is negative).
232      *
233      * Counterpart to Solidity's `-` operator.
234      *
235      * Requirements:
236      * - Subtraction cannot overflow.
237      */
238     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
239         return sub(a, b, "SafeMath: subtraction overflow");
240     }
241 
242     /**
243      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
244      * overflow (when the result is negative).
245      *
246      * Counterpart to Solidity's `-` operator.
247      *
248      * Requirements:
249      * - Subtraction cannot overflow.
250      *
251      * _Available since v2.4.0._
252      */
253     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
254         require(b <= a, errorMessage);
255         uint256 c = a - b;
256 
257         return c;
258     }
259 
260     /**
261      * @dev Returns the multiplication of two unsigned integers, reverting on
262      * overflow.
263      *
264      * Counterpart to Solidity's `*` operator.
265      *
266      * Requirements:
267      * - Multiplication cannot overflow.
268      */
269     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
270         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
271         // benefit is lost if 'b' is also tested.
272         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
273         if (a == 0) {
274             return 0;
275         }
276 
277         uint256 c = a * b;
278         require(c / a == b, "SafeMath: multiplication overflow");
279 
280         return c;
281     }
282 
283     /**
284      * @dev Returns the integer division of two unsigned integers. Reverts on
285      * division by zero. The result is rounded towards zero.
286      *
287      * Counterpart to Solidity's `/` operator. Note: this function uses a
288      * `revert` opcode (which leaves remaining gas untouched) while Solidity
289      * uses an invalid opcode to revert (consuming all remaining gas).
290      *
291      * Requirements:
292      * - The divisor cannot be zero.
293      */
294     function div(uint256 a, uint256 b) internal pure returns (uint256) {
295         return div(a, b, "SafeMath: division by zero");
296     }
297 
298     /**
299      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
300      * division by zero. The result is rounded towards zero.
301      *
302      * Counterpart to Solidity's `/` operator. Note: this function uses a
303      * `revert` opcode (which leaves remaining gas untouched) while Solidity
304      * uses an invalid opcode to revert (consuming all remaining gas).
305      *
306      * Requirements:
307      * - The divisor cannot be zero.
308      *
309      * _Available since v2.4.0._
310      */
311     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
312         // Solidity only automatically asserts when dividing by 0
313         require(b > 0, errorMessage);
314         uint256 c = a / b;
315         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
316 
317         return c;
318     }
319 
320     /**
321      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
322      * Reverts when dividing by zero.
323      *
324      * Counterpart to Solidity's `%` operator. This function uses a `revert`
325      * opcode (which leaves remaining gas untouched) while Solidity uses an
326      * invalid opcode to revert (consuming all remaining gas).
327      *
328      * Requirements:
329      * - The divisor cannot be zero.
330      */
331     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
332         return mod(a, b, "SafeMath: modulo by zero");
333     }
334 
335     /**
336      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
337      * Reverts with custom message when dividing by zero.
338      *
339      * Counterpart to Solidity's `%` operator. This function uses a `revert`
340      * opcode (which leaves remaining gas untouched) while Solidity uses an
341      * invalid opcode to revert (consuming all remaining gas).
342      *
343      * Requirements:
344      * - The divisor cannot be zero.
345      *
346      * _Available since v2.4.0._
347      */
348     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
349         require(b != 0, errorMessage);
350         return a % b;
351     }
352 }
353 
354 // File: contracts/external/Decimal.sol
355 
356 /*
357     Copyright 2019 dYdX Trading Inc.
358     Copyright 2020 Empty Set Squad <emptysetsquad@protonmail.com>
359 
360     Licensed under the Apache License, Version 2.0 (the "License");
361     you may not use this file except in compliance with the License.
362     You may obtain a copy of the License at
363 
364     http://www.apache.org/licenses/LICENSE-2.0
365 
366     Unless required by applicable law or agreed to in writing, software
367     distributed under the License is distributed on an "AS IS" BASIS,
368     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
369     See the License for the specific language governing permissions and
370     limitations under the License.
371 */
372 
373 pragma solidity ^0.5.7;
374 pragma experimental ABIEncoderV2;
375 
376 
377 /**
378  * @title Decimal
379  * @author dYdX
380  *
381  * Library that defines a fixed-point number with 18 decimal places.
382  */
383 library Decimal {
384     using SafeMath for uint256;
385 
386     // ============ Constants ============
387 
388     uint256 constant BASE = 10**18;
389 
390     // ============ Structs ============
391 
392 
393     struct D256 {
394         uint256 value;
395     }
396 
397     // ============ Static Functions ============
398 
399     function zero()
400     internal
401     pure
402     returns (D256 memory)
403     {
404         return D256({ value: 0 });
405     }
406 
407     function one()
408     internal
409     pure
410     returns (D256 memory)
411     {
412         return D256({ value: BASE });
413     }
414 
415     function from(
416         uint256 a
417     )
418     internal
419     pure
420     returns (D256 memory)
421     {
422         return D256({ value: a.mul(BASE) });
423     }
424 
425     function ratio(
426         uint256 a,
427         uint256 b
428     )
429     internal
430     pure
431     returns (D256 memory)
432     {
433         return D256({ value: getPartial(a, BASE, b) });
434     }
435 
436     // ============ Self Functions ============
437 
438     function add(
439         D256 memory self,
440         uint256 b
441     )
442     internal
443     pure
444     returns (D256 memory)
445     {
446         return D256({ value: self.value.add(b.mul(BASE)) });
447     }
448 
449     function sub(
450         D256 memory self,
451         uint256 b
452     )
453     internal
454     pure
455     returns (D256 memory)
456     {
457         return D256({ value: self.value.sub(b.mul(BASE)) });
458     }
459 
460     function mul(
461         D256 memory self,
462         uint256 b
463     )
464     internal
465     pure
466     returns (D256 memory)
467     {
468         return D256({ value: self.value.mul(b) });
469     }
470 
471     function div(
472         D256 memory self,
473         uint256 b
474     )
475     internal
476     pure
477     returns (D256 memory)
478     {
479         return D256({ value: self.value.div(b) });
480     }
481 
482     function pow(
483         D256 memory self,
484         uint256 b
485     )
486     internal
487     pure
488     returns (D256 memory)
489     {
490         if (b == 0) {
491             return from(1);
492         }
493 
494         D256 memory temp = D256({ value: self.value });
495         for (uint256 i = 1; i < b; i++) {
496             temp = mul(temp, self);
497         }
498 
499         return temp;
500     }
501 
502     function add(
503         D256 memory self,
504         D256 memory b
505     )
506     internal
507     pure
508     returns (D256 memory)
509     {
510         return D256({ value: self.value.add(b.value) });
511     }
512 
513     function sub(
514         D256 memory self,
515         D256 memory b
516     )
517     internal
518     pure
519     returns (D256 memory)
520     {
521         return D256({ value: self.value.sub(b.value) });
522     }
523 
524     function mul(
525         D256 memory self,
526         D256 memory b
527     )
528     internal
529     pure
530     returns (D256 memory)
531     {
532         return D256({ value: getPartial(self.value, b.value, BASE) });
533     }
534 
535     function div(
536         D256 memory self,
537         D256 memory b
538     )
539     internal
540     pure
541     returns (D256 memory)
542     {
543         return D256({ value: getPartial(self.value, BASE, b.value) });
544     }
545 
546     function equals(D256 memory self, D256 memory b) internal pure returns (bool) {
547         return self.value == b.value;
548     }
549 
550     function greaterThan(D256 memory self, D256 memory b) internal pure returns (bool) {
551         return compareTo(self, b) == 2;
552     }
553 
554     function lessThan(D256 memory self, D256 memory b) internal pure returns (bool) {
555         return compareTo(self, b) == 0;
556     }
557 
558     function greaterThanOrEqualTo(D256 memory self, D256 memory b) internal pure returns (bool) {
559         return compareTo(self, b) > 0;
560     }
561 
562     function lessThanOrEqualTo(D256 memory self, D256 memory b) internal pure returns (bool) {
563         return compareTo(self, b) < 2;
564     }
565 
566     function isZero(D256 memory self) internal pure returns (bool) {
567         return self.value == 0;
568     }
569 
570     function asUint256(D256 memory self) internal pure returns (uint256) {
571         return self.value.div(BASE);
572     }
573 
574     // ============ Core Methods ============
575 
576     function getPartial(
577         uint256 target,
578         uint256 numerator,
579         uint256 denominator
580     )
581     private
582     pure
583     returns (uint256)
584     {
585         return target.mul(numerator).div(denominator);
586     }
587 
588     function compareTo(
589         D256 memory a,
590         D256 memory b
591     )
592     private
593     pure
594     returns (uint256)
595     {
596         if (a.value == b.value) {
597             return 1;
598         }
599         return a.value > b.value ? 2 : 0;
600     }
601 }
602 
603 // File: contracts/Constants.sol
604 
605 /*
606     Copyright 2020 Empty Set Squad <emptysetsquad@protonmail.com>
607     Copyright 2021 vsdcrew <vsdcrew@protonmail.com>
608 
609     Licensed under the Apache License, Version 2.0 (the "License");
610     you may not use this file except in compliance with the License.
611     You may obtain a copy of the License at
612 
613     http://www.apache.org/licenses/LICENSE-2.0
614 
615     Unless required by applicable law or agreed to in writing, software
616     distributed under the License is distributed on an "AS IS" BASIS,
617     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
618     See the License for the specific language governing permissions and
619     limitations under the License.
620 */
621 
622 pragma solidity ^0.5.16;
623 
624 
625 
626 library Constants {
627     /* Chain */
628     uint256 private constant CHAIN_ID = 1; // Mainnet
629 
630     /* Bootstrapping */
631     uint256 private constant BOOTSTRAPPING_PERIOD = 5;
632 
633     /* Oracle */
634     address private constant USDC = address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
635     uint256 private constant ORACLE_RESERVE_MINIMUM = 1e22; // 10,000 VSD
636     address private constant DAI = address(0x6B175474E89094C44Da98b954EedeAC495271d0F);
637 
638     /* Epoch */
639     struct EpochStrategy {
640         uint256 offset;
641         uint256 start;
642         uint256 period;
643     }
644 
645     uint256 private constant CURRENT_EPOCH_OFFSET = 0;
646     uint256 private constant CURRENT_EPOCH_START = 1612324800;
647     uint256 private constant CURRENT_EPOCH_PERIOD = 28800;
648 
649     /* Governance */
650     uint256 private constant GOVERNANCE_PERIOD = 9; // 9 epochs
651     uint256 private constant GOVERNANCE_EXPIRATION = 2; // 2 + 1 epochs
652     uint256 private constant GOVERNANCE_QUORUM = 10e16; // 10%
653     uint256 private constant GOVERNANCE_PROPOSAL_THRESHOLD = 5e15; // 0.5%
654     uint256 private constant GOVERNANCE_SUPER_MAJORITY = 66e16; // 66%
655     uint256 private constant GOVERNANCE_EMERGENCY_DELAY = 6; // 6 epochs
656 
657     /* DAO */
658     uint256 private constant ADVANCE_INCENTIVE = 1e20; // 100 VSD
659     uint256 private constant DAO_EXIT_LOCKUP_EPOCHS = 15; // 15 epochs fluid
660 
661     /* Market */
662     uint256 private constant COUPON_EXPIRATION = 30; // 10 days
663     uint256 private constant DEBT_RATIO_CAP = 15e16; // 15%
664 
665     /* Regulator */
666     uint256 private constant COUPON_SUPPLY_CHANGE_LIMIT = 6e16; // 6%
667     uint256 private constant SUPPLY_INCREASE_FUND_RATIO = 1500; // 15%
668     uint256 private constant SUPPLY_INCREASE_PRICE_THRESHOLD = 105e16; // 1.05
669     uint256 private constant SUPPLY_INCREASE_PRICE_TARGET = 105e16; // 1.05
670     uint256 private constant SUPPLY_DECREASE_PRICE_THRESHOLD = 95e16; // 0.95
671     uint256 private constant SUPPLY_DECREASE_PRICE_TARGET = 95e16; // 0.95
672 
673     /* Collateral */
674     uint256 private constant REDEMPTION_RATE = 9500; // 95%
675     uint256 private constant FUND_DEV_PCT = 70; // 70%
676     uint256 private constant COLLATERAL_RATIO = 9000; // 90%
677 
678     /* Deployed */
679     address private constant TREASURY_ADDRESS = address(0x4b23854ed531f82Dfc9888aF54076aeC5F92DE07);
680     address private constant DEV_ADDRESS = address(0x5bC47D40F69962d1a9Db65aC88f4b83537AF5Dc2);
681     address private constant MINTER_ADDRESS = address(0x6Ff1DbcF2996D8960E24F16C193EA42853995d32);
682     address private constant GOVERNOR = address(0xB64A5630283CCBe0C3cbF887a9f7B9154aEf38c3);
683 
684     /**
685      * Getters
686      */
687 
688     function getUsdcAddress() internal pure returns (address) {
689         return USDC;
690     }
691 
692     function getDaiAddress() internal pure returns (address) {
693         return DAI;
694     }
695 
696     function getOracleReserveMinimum() internal pure returns (uint256) {
697         return ORACLE_RESERVE_MINIMUM;
698     }
699 
700     function getCurrentEpochStrategy() internal pure returns (EpochStrategy memory) {
701         return EpochStrategy({
702             offset: CURRENT_EPOCH_OFFSET,
703             start: CURRENT_EPOCH_START,
704             period: CURRENT_EPOCH_PERIOD
705         });
706     }
707 
708     function getBootstrappingPeriod() internal pure returns (uint256) {
709         return BOOTSTRAPPING_PERIOD;
710     }
711 
712     function getGovernancePeriod() internal pure returns (uint256) {
713         return GOVERNANCE_PERIOD;
714     }
715 
716     function getGovernanceExpiration() internal pure returns (uint256) {
717         return GOVERNANCE_EXPIRATION;
718     }
719 
720     function getGovernanceQuorum() internal pure returns (Decimal.D256 memory) {
721         return Decimal.D256({value: GOVERNANCE_QUORUM});
722     }
723 
724     function getGovernanceProposalThreshold() internal pure returns (Decimal.D256 memory) {
725         return Decimal.D256({value: GOVERNANCE_PROPOSAL_THRESHOLD});
726     }
727 
728     function getGovernanceSuperMajority() internal pure returns (Decimal.D256 memory) {
729         return Decimal.D256({value: GOVERNANCE_SUPER_MAJORITY});
730     }
731 
732     function getGovernanceEmergencyDelay() internal pure returns (uint256) {
733         return GOVERNANCE_EMERGENCY_DELAY;
734     }
735 
736     function getAdvanceIncentive() internal pure returns (uint256) {
737         return ADVANCE_INCENTIVE;
738     }
739 
740     function getDAOExitLockupEpochs() internal pure returns (uint256) {
741         return DAO_EXIT_LOCKUP_EPOCHS;
742     }
743 
744     function getCouponExpiration() internal pure returns (uint256) {
745         return COUPON_EXPIRATION;
746     }
747 
748     function getDebtRatioCap() internal pure returns (Decimal.D256 memory) {
749         return Decimal.D256({value: DEBT_RATIO_CAP});
750     }
751 
752     function getCouponSupplyChangeLimit() internal pure returns (Decimal.D256 memory) {
753         return Decimal.D256({value: COUPON_SUPPLY_CHANGE_LIMIT});
754     }
755 
756     function getSupplyIncreaseFundRatio() internal pure returns (uint256) {
757         return SUPPLY_INCREASE_FUND_RATIO;
758     }
759 
760     function getSupplyIncreasePriceThreshold() internal pure returns (uint256) {
761         return SUPPLY_INCREASE_PRICE_THRESHOLD;
762     }
763 
764     function getSupplyIncreasePriceTarget() internal pure returns (uint256) {
765         return SUPPLY_INCREASE_PRICE_TARGET;
766     }
767 
768     function getSupplyDecreasePriceThreshold() internal pure returns (uint256) {
769         return SUPPLY_DECREASE_PRICE_THRESHOLD;
770     }
771 
772     function getSupplyDecreasePriceTarget() internal pure returns (uint256) {
773         return SUPPLY_DECREASE_PRICE_TARGET;
774     }
775 
776     function getChainId() internal pure returns (uint256) {
777         return CHAIN_ID;
778     }
779 
780     function getTreasuryAddress() internal pure returns (address) {
781         return TREASURY_ADDRESS;
782     }
783 
784     function getDevAddress() internal pure returns (address) {
785         return DEV_ADDRESS;
786     }
787 
788     function getMinterAddress() internal pure returns (address) {
789         return MINTER_ADDRESS;
790     }
791 
792     function getFundDevPct() internal pure returns (uint256) {
793         return FUND_DEV_PCT;
794     }
795 
796     function getRedemptionRate() internal pure returns (uint256) {
797         return REDEMPTION_RATE;
798     }
799 
800     function getGovernor() internal pure returns (address) {
801         return GOVERNOR;
802     }
803 
804     function getCollateralRatio() internal pure returns (uint256) {
805         return COLLATERAL_RATIO;
806     }
807 }
808 
809 // File: @uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol
810 
811 pragma solidity >=0.5.0;
812 
813 interface IUniswapV2Pair {
814     event Approval(address indexed owner, address indexed spender, uint value);
815     event Transfer(address indexed from, address indexed to, uint value);
816 
817     function name() external pure returns (string memory);
818     function symbol() external pure returns (string memory);
819     function decimals() external pure returns (uint8);
820     function totalSupply() external view returns (uint);
821     function balanceOf(address owner) external view returns (uint);
822     function allowance(address owner, address spender) external view returns (uint);
823 
824     function approve(address spender, uint value) external returns (bool);
825     function transfer(address to, uint value) external returns (bool);
826     function transferFrom(address from, address to, uint value) external returns (bool);
827 
828     function DOMAIN_SEPARATOR() external view returns (bytes32);
829     function PERMIT_TYPEHASH() external pure returns (bytes32);
830     function nonces(address owner) external view returns (uint);
831 
832     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
833 
834     event Mint(address indexed sender, uint amount0, uint amount1);
835     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
836     event Swap(
837         address indexed sender,
838         uint amount0In,
839         uint amount1In,
840         uint amount0Out,
841         uint amount1Out,
842         address indexed to
843     );
844     event Sync(uint112 reserve0, uint112 reserve1);
845 
846     function MINIMUM_LIQUIDITY() external pure returns (uint);
847     function factory() external view returns (address);
848     function token0() external view returns (address);
849     function token1() external view returns (address);
850     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
851     function price0CumulativeLast() external view returns (uint);
852     function price1CumulativeLast() external view returns (uint);
853     function kLast() external view returns (uint);
854 
855     function mint(address to) external returns (uint liquidity);
856     function burn(address to) external returns (uint amount0, uint amount1);
857     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
858     function skim(address to) external;
859     function sync() external;
860 
861     function initialize(address, address) external;
862 }
863 
864 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
865 
866 pragma solidity ^0.5.0;
867 
868 /**
869  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
870  * the optional functions; to access them see {ERC20Detailed}.
871  */
872 interface IERC20 {
873     /**
874      * @dev Returns the amount of tokens in existence.
875      */
876     function totalSupply() external view returns (uint256);
877 
878     /**
879      * @dev Returns the amount of tokens owned by `account`.
880      */
881     function balanceOf(address account) external view returns (uint256);
882 
883     /**
884      * @dev Moves `amount` tokens from the caller's account to `recipient`.
885      *
886      * Returns a boolean value indicating whether the operation succeeded.
887      *
888      * Emits a {Transfer} event.
889      */
890     function transfer(address recipient, uint256 amount) external returns (bool);
891 
892     /**
893      * @dev Returns the remaining number of tokens that `spender` will be
894      * allowed to spend on behalf of `owner` through {transferFrom}. This is
895      * zero by default.
896      *
897      * This value changes when {approve} or {transferFrom} are called.
898      */
899     function allowance(address owner, address spender) external view returns (uint256);
900 
901     /**
902      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
903      *
904      * Returns a boolean value indicating whether the operation succeeded.
905      *
906      * IMPORTANT: Beware that changing an allowance with this method brings the risk
907      * that someone may use both the old and the new allowance by unfortunate
908      * transaction ordering. One possible solution to mitigate this race
909      * condition is to first reduce the spender's allowance to 0 and set the
910      * desired value afterwards:
911      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
912      *
913      * Emits an {Approval} event.
914      */
915     function approve(address spender, uint256 amount) external returns (bool);
916 
917     /**
918      * @dev Moves `amount` tokens from `sender` to `recipient` using the
919      * allowance mechanism. `amount` is then deducted from the caller's
920      * allowance.
921      *
922      * Returns a boolean value indicating whether the operation succeeded.
923      *
924      * Emits a {Transfer} event.
925      */
926     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
927 
928     /**
929      * @dev Emitted when `value` tokens are moved from one account (`from`) to
930      * another (`to`).
931      *
932      * Note that `value` may be zero.
933      */
934     event Transfer(address indexed from, address indexed to, uint256 value);
935 
936     /**
937      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
938      * a call to {approve}. `value` is the new allowance.
939      */
940     event Approval(address indexed owner, address indexed spender, uint256 value);
941 }
942 
943 // File: contracts/token/IDollar.sol
944 
945 /*
946     Copyright 2020 Empty Set Squad <emptysetsquad@protonmail.com>
947 
948     Licensed under the Apache License, Version 2.0 (the "License");
949     you may not use this file except in compliance with the License.
950     You may obtain a copy of the License at
951 
952     http://www.apache.org/licenses/LICENSE-2.0
953 
954     Unless required by applicable law or agreed to in writing, software
955     distributed under the License is distributed on an "AS IS" BASIS,
956     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
957     See the License for the specific language governing permissions and
958     limitations under the License.
959 */
960 
961 pragma solidity ^0.5.16;
962 
963 
964 
965 contract IDollar is IERC20 {
966     function burn(uint256 amount) public;
967     function burnFrom(address account, uint256 amount) public;
968     function mint(address account, uint256 amount) public returns (bool);
969 }
970 
971 // File: contracts/oracle/IOracle.sol
972 
973 /*
974     Copyright 2020 Empty Set Squad <emptysetsquad@protonmail.com>
975 
976     Licensed under the Apache License, Version 2.0 (the "License");
977     you may not use this file except in compliance with the License.
978     You may obtain a copy of the License at
979 
980     http://www.apache.org/licenses/LICENSE-2.0
981 
982     Unless required by applicable law or agreed to in writing, software
983     distributed under the License is distributed on an "AS IS" BASIS,
984     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
985     See the License for the specific language governing permissions and
986     limitations under the License.
987 */
988 
989 pragma solidity ^0.5.16;
990 
991 
992 
993 contract IOracle {
994     function capture() public returns (Decimal.D256 memory, bool);
995 }
996 
997 // File: contracts/dao/State.sol
998 
999 /*
1000     Copyright 2020 Empty Set Squad <emptysetsquad@protonmail.com>
1001     Copyright 2021 vsdcrew <vsdcrew@protonmail.com>
1002 
1003     Licensed under the Apache License, Version 2.0 (the "License");
1004     you may not use this file except in compliance with the License.
1005     You may obtain a copy of the License at
1006 
1007     http://www.apache.org/licenses/LICENSE-2.0
1008 
1009     Unless required by applicable law or agreed to in writing, software
1010     distributed under the License is distributed on an "AS IS" BASIS,
1011     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1012     See the License for the specific language governing permissions and
1013     limitations under the License.
1014 */
1015 
1016 pragma solidity ^0.5.16;
1017 
1018 
1019 
1020 
1021 
1022 
1023 contract Account {
1024     enum Status {
1025         Frozen,
1026         Fluid,
1027         Locked
1028     }
1029 
1030     struct State {
1031         uint256 lockedUntil;
1032 
1033         mapping(uint256 => uint256) coupons;
1034         mapping(address => uint256) couponAllowances;
1035     }
1036 
1037     struct PoolState {
1038         uint256 staged;
1039         uint256 bonded;
1040         uint256 fluidUntil;
1041         uint256 rewardDebt;
1042         uint256 shareDebt;
1043     }
1044 }
1045 
1046 contract Epoch {
1047     struct Global {
1048         uint256 start;
1049         uint256 period;
1050         uint256 current;
1051     }
1052 
1053     struct Coupons {
1054         uint256 outstanding;
1055         uint256 couponRedeemed;
1056         uint256 vsdRedeemable;
1057     }
1058 
1059     struct State {
1060         uint256 totalDollarSupply;
1061         Coupons coupons;
1062     }
1063 }
1064 
1065 contract Candidate {
1066     enum Vote {
1067         UNDECIDED,
1068         APPROVE,
1069         REJECT
1070     }
1071 
1072     struct VoteInfo {
1073         Vote vote;
1074         uint256 bondedVotes;
1075     }
1076 
1077     struct State {
1078         uint256 start;
1079         uint256 period;
1080         uint256 approve;
1081         uint256 reject;
1082         mapping(address => VoteInfo) votes;
1083         bool initialized;
1084     }
1085 }
1086 
1087 contract Storage {
1088     struct Provider {
1089         IDollar dollar;
1090         IOracle oracle;
1091     }
1092 
1093     struct Balance {
1094         uint256 redeemable;
1095         uint256 clippable;
1096         uint256 debt;
1097         uint256 coupons;
1098     }
1099 
1100     struct PoolInfo {
1101         uint256 bonded;
1102         uint256 staged;
1103         mapping (address => Account.PoolState) accounts;
1104         uint256 accDollarPerLP; // Accumulated dollar per LP token, times 1e18.
1105         uint256 accSharePerLP; // Accumulated share per LP token, times 1e18.
1106         uint256 allocPoint;
1107         uint256 flags;
1108     }
1109 
1110     struct State {
1111         Epoch.Global epoch;
1112         Balance balance;
1113         Provider provider;
1114 
1115         /*
1116          * Global state variable
1117          */
1118         uint256 totalAllocPoint;
1119         uint256 collateralRatio;
1120 
1121         mapping(uint256 => Epoch.State) epochs;
1122         mapping(uint256 => Candidate.State) candidates;
1123         mapping(address => Account.State) accounts;
1124 
1125         mapping(address => PoolInfo) pools;
1126         address[] poolList;
1127 
1128         address[] collateralAssetList;
1129     }
1130 }
1131 
1132 contract State {
1133     Storage.State _state;
1134 }
1135 
1136 // File: contracts/dao/Root.sol
1137 
1138 /*
1139     Copyright 2020 Empty Set Squad <emptysetsquad@protonmail.com>
1140     Copyright 2021 vsdcrew <vsdcrew@protonmail.com>
1141 
1142     Licensed under the Apache License, Version 2.0 (the "License");
1143     you may not use this file except in compliance with the License.
1144     You may obtain a copy of the License at
1145 
1146     http://www.apache.org/licenses/LICENSE-2.0
1147 
1148     Unless required by applicable law or agreed to in writing, software
1149     distributed under the License is distributed on an "AS IS" BASIS,
1150     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1151     See the License for the specific language governing permissions and
1152     limitations under the License.
1153 */
1154 
1155 pragma solidity ^0.5.16;
1156 
1157 
1158 
1159 
1160 
1161 
1162 
1163 contract Root is State, UpgradeabilityProxy {
1164     constructor (address implementation, address dollar, address oracle, address[] memory collaterals, address[] memory pools) UpgradeabilityProxy(
1165         implementation,
1166         abi.encodeWithSignature("initialize()")
1167     ) public {
1168         _state.provider.dollar = IDollar(dollar);
1169         _state.provider.oracle = IOracle(oracle);
1170 
1171         _state.collateralAssetList = collaterals;
1172         _state.poolList = pools;
1173         _state.collateralRatio = Constants.getCollateralRatio();
1174     }
1175 }