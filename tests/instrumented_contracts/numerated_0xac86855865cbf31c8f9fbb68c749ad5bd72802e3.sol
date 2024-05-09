1 /*
2    ____            __   __        __   _
3   / __/__ __ ___  / /_ / /  ___  / /_ (_)__ __
4  _\ \ / // // _ \/ __// _ \/ -_)/ __// / \ \ /
5 /___/ \_, //_//_/\__//_//_/\__/ \__//_/ /_\_\
6      /___/
7 
8 * Synthetix: RewardEscrowV2.sol
9 *
10 * Latest source (may be newer): https://github.com/Synthetixio/synthetix/blob/master/contracts/RewardEscrowV2.sol
11 * Docs: https://docs.synthetix.io/contracts/RewardEscrowV2
12 *
13 * Contract Dependencies: 
14 *	- BaseRewardEscrowV2
15 *	- IAddressResolver
16 *	- IRewardEscrowV2Storage
17 *	- Owned
18 *	- State
19 * Libraries: 
20 *	- SafeCast
21 *	- SafeDecimalMath
22 *	- SafeMath
23 *	- SignedSafeMath
24 *	- VestingEntries
25 *
26 * MIT License
27 * ===========
28 *
29 * Copyright (c) 2022 Synthetix
30 *
31 * Permission is hereby granted, free of charge, to any person obtaining a copy
32 * of this software and associated documentation files (the "Software"), to deal
33 * in the Software without restriction, including without limitation the rights
34 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
35 * copies of the Software, and to permit persons to whom the Software is
36 * furnished to do so, subject to the following conditions:
37 *
38 * The above copyright notice and this permission notice shall be included in all
39 * copies or substantial portions of the Software.
40 *
41 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
42 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
43 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
44 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
45 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
46 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
47 */
48 
49 
50 
51 pragma solidity ^0.5.16;
52 
53 // https://docs.synthetix.io/contracts/source/contracts/owned
54 contract Owned {
55     address public owner;
56     address public nominatedOwner;
57 
58     constructor(address _owner) public {
59         require(_owner != address(0), "Owner address cannot be 0");
60         owner = _owner;
61         emit OwnerChanged(address(0), _owner);
62     }
63 
64     function nominateNewOwner(address _owner) external onlyOwner {
65         nominatedOwner = _owner;
66         emit OwnerNominated(_owner);
67     }
68 
69     function acceptOwnership() external {
70         require(msg.sender == nominatedOwner, "You must be nominated before you can accept ownership");
71         emit OwnerChanged(owner, nominatedOwner);
72         owner = nominatedOwner;
73         nominatedOwner = address(0);
74     }
75 
76     modifier onlyOwner {
77         _onlyOwner();
78         _;
79     }
80 
81     function _onlyOwner() private view {
82         require(msg.sender == owner, "Only the contract owner may perform this action");
83     }
84 
85     event OwnerNominated(address newOwner);
86     event OwnerChanged(address oldOwner, address newOwner);
87 }
88 
89 
90 // https://docs.synthetix.io/contracts/source/interfaces/iaddressresolver
91 interface IAddressResolver {
92     function getAddress(bytes32 name) external view returns (address);
93 
94     function getSynth(bytes32 key) external view returns (address);
95 
96     function requireAndGetAddress(bytes32 name, string calldata reason) external view returns (address);
97 }
98 
99 
100 // https://docs.synthetix.io/contracts/source/interfaces/isynth
101 interface ISynth {
102     // Views
103     function currencyKey() external view returns (bytes32);
104 
105     function transferableSynths(address account) external view returns (uint);
106 
107     // Mutative functions
108     function transferAndSettle(address to, uint value) external returns (bool);
109 
110     function transferFromAndSettle(
111         address from,
112         address to,
113         uint value
114     ) external returns (bool);
115 
116     // Restricted: used internally to Synthetix
117     function burn(address account, uint amount) external;
118 
119     function issue(address account, uint amount) external;
120 }
121 
122 
123 // https://docs.synthetix.io/contracts/source/interfaces/iissuer
124 interface IIssuer {
125     // Views
126 
127     function allNetworksDebtInfo()
128         external
129         view
130         returns (
131             uint256 debt,
132             uint256 sharesSupply,
133             bool isStale
134         );
135 
136     function anySynthOrSNXRateIsInvalid() external view returns (bool anyRateInvalid);
137 
138     function availableCurrencyKeys() external view returns (bytes32[] memory);
139 
140     function availableSynthCount() external view returns (uint);
141 
142     function availableSynths(uint index) external view returns (ISynth);
143 
144     function canBurnSynths(address account) external view returns (bool);
145 
146     function collateral(address account) external view returns (uint);
147 
148     function collateralisationRatio(address issuer) external view returns (uint);
149 
150     function collateralisationRatioAndAnyRatesInvalid(address _issuer)
151         external
152         view
153         returns (uint cratio, bool anyRateIsInvalid);
154 
155     function debtBalanceOf(address issuer, bytes32 currencyKey) external view returns (uint debtBalance);
156 
157     function issuanceRatio() external view returns (uint);
158 
159     function lastIssueEvent(address account) external view returns (uint);
160 
161     function maxIssuableSynths(address issuer) external view returns (uint maxIssuable);
162 
163     function minimumStakeTime() external view returns (uint);
164 
165     function remainingIssuableSynths(address issuer)
166         external
167         view
168         returns (
169             uint maxIssuable,
170             uint alreadyIssued,
171             uint totalSystemDebt
172         );
173 
174     function synths(bytes32 currencyKey) external view returns (ISynth);
175 
176     function getSynths(bytes32[] calldata currencyKeys) external view returns (ISynth[] memory);
177 
178     function synthsByAddress(address synthAddress) external view returns (bytes32);
179 
180     function totalIssuedSynths(bytes32 currencyKey, bool excludeOtherCollateral) external view returns (uint);
181 
182     function transferableSynthetixAndAnyRateIsInvalid(address account, uint balance)
183         external
184         view
185         returns (uint transferable, bool anyRateIsInvalid);
186 
187     function liquidationAmounts(address account, bool isSelfLiquidation)
188         external
189         view
190         returns (
191             uint totalRedeemed,
192             uint debtToRemove,
193             uint escrowToLiquidate,
194             uint initialDebtBalance
195         );
196 
197     // Restricted: used internally to Synthetix
198     function addSynths(ISynth[] calldata synthsToAdd) external;
199 
200     function issueSynths(address from, uint amount) external;
201 
202     function issueSynthsOnBehalf(
203         address issueFor,
204         address from,
205         uint amount
206     ) external;
207 
208     function issueMaxSynths(address from) external;
209 
210     function issueMaxSynthsOnBehalf(address issueFor, address from) external;
211 
212     function burnSynths(address from, uint amount) external;
213 
214     function burnSynthsOnBehalf(
215         address burnForAddress,
216         address from,
217         uint amount
218     ) external;
219 
220     function burnSynthsToTarget(address from) external;
221 
222     function burnSynthsToTargetOnBehalf(address burnForAddress, address from) external;
223 
224     function burnForRedemption(
225         address deprecatedSynthProxy,
226         address account,
227         uint balance
228     ) external;
229 
230     function setCurrentPeriodId(uint128 periodId) external;
231 
232     function liquidateAccount(address account, bool isSelfLiquidation)
233         external
234         returns (
235             uint totalRedeemed,
236             uint debtRemoved,
237             uint escrowToLiquidate
238         );
239 
240     function issueSynthsWithoutDebt(
241         bytes32 currencyKey,
242         address to,
243         uint amount
244     ) external returns (bool rateInvalid);
245 
246     function burnSynthsWithoutDebt(
247         bytes32 currencyKey,
248         address to,
249         uint amount
250     ) external returns (bool rateInvalid);
251 }
252 
253 
254 // Inheritance
255 
256 
257 // Internal references
258 
259 
260 // https://docs.synthetix.io/contracts/source/contracts/addressresolver
261 contract AddressResolver is Owned, IAddressResolver {
262     mapping(bytes32 => address) public repository;
263 
264     constructor(address _owner) public Owned(_owner) {}
265 
266     /* ========== RESTRICTED FUNCTIONS ========== */
267 
268     function importAddresses(bytes32[] calldata names, address[] calldata destinations) external onlyOwner {
269         require(names.length == destinations.length, "Input lengths must match");
270 
271         for (uint i = 0; i < names.length; i++) {
272             bytes32 name = names[i];
273             address destination = destinations[i];
274             repository[name] = destination;
275             emit AddressImported(name, destination);
276         }
277     }
278 
279     /* ========= PUBLIC FUNCTIONS ========== */
280 
281     function rebuildCaches(MixinResolver[] calldata destinations) external {
282         for (uint i = 0; i < destinations.length; i++) {
283             destinations[i].rebuildCache();
284         }
285     }
286 
287     /* ========== VIEWS ========== */
288 
289     function areAddressesImported(bytes32[] calldata names, address[] calldata destinations) external view returns (bool) {
290         for (uint i = 0; i < names.length; i++) {
291             if (repository[names[i]] != destinations[i]) {
292                 return false;
293             }
294         }
295         return true;
296     }
297 
298     function getAddress(bytes32 name) external view returns (address) {
299         return repository[name];
300     }
301 
302     function requireAndGetAddress(bytes32 name, string calldata reason) external view returns (address) {
303         address _foundAddress = repository[name];
304         require(_foundAddress != address(0), reason);
305         return _foundAddress;
306     }
307 
308     function getSynth(bytes32 key) external view returns (address) {
309         IIssuer issuer = IIssuer(repository["Issuer"]);
310         require(address(issuer) != address(0), "Cannot find Issuer address");
311         return address(issuer.synths(key));
312     }
313 
314     /* ========== EVENTS ========== */
315 
316     event AddressImported(bytes32 name, address destination);
317 }
318 
319 
320 // Internal references
321 
322 
323 // https://docs.synthetix.io/contracts/source/contracts/mixinresolver
324 contract MixinResolver {
325     AddressResolver public resolver;
326 
327     mapping(bytes32 => address) private addressCache;
328 
329     constructor(address _resolver) internal {
330         resolver = AddressResolver(_resolver);
331     }
332 
333     /* ========== INTERNAL FUNCTIONS ========== */
334 
335     function combineArrays(bytes32[] memory first, bytes32[] memory second)
336         internal
337         pure
338         returns (bytes32[] memory combination)
339     {
340         combination = new bytes32[](first.length + second.length);
341 
342         for (uint i = 0; i < first.length; i++) {
343             combination[i] = first[i];
344         }
345 
346         for (uint j = 0; j < second.length; j++) {
347             combination[first.length + j] = second[j];
348         }
349     }
350 
351     /* ========== PUBLIC FUNCTIONS ========== */
352 
353     // Note: this function is public not external in order for it to be overridden and invoked via super in subclasses
354     function resolverAddressesRequired() public view returns (bytes32[] memory addresses) {}
355 
356     function rebuildCache() public {
357         bytes32[] memory requiredAddresses = resolverAddressesRequired();
358         // The resolver must call this function whenver it updates its state
359         for (uint i = 0; i < requiredAddresses.length; i++) {
360             bytes32 name = requiredAddresses[i];
361             // Note: can only be invoked once the resolver has all the targets needed added
362             address destination =
363                 resolver.requireAndGetAddress(name, string(abi.encodePacked("Resolver missing target: ", name)));
364             addressCache[name] = destination;
365             emit CacheUpdated(name, destination);
366         }
367     }
368 
369     /* ========== VIEWS ========== */
370 
371     function isResolverCached() external view returns (bool) {
372         bytes32[] memory requiredAddresses = resolverAddressesRequired();
373         for (uint i = 0; i < requiredAddresses.length; i++) {
374             bytes32 name = requiredAddresses[i];
375             // false if our cache is invalid or if the resolver doesn't have the required address
376             if (resolver.getAddress(name) != addressCache[name] || addressCache[name] == address(0)) {
377                 return false;
378             }
379         }
380 
381         return true;
382     }
383 
384     /* ========== INTERNAL FUNCTIONS ========== */
385 
386     function requireAndGetAddress(bytes32 name) internal view returns (address) {
387         address _foundAddress = addressCache[name];
388         require(_foundAddress != address(0), string(abi.encodePacked("Missing address: ", name)));
389         return _foundAddress;
390     }
391 
392     /* ========== EVENTS ========== */
393 
394     event CacheUpdated(bytes32 name, address destination);
395 }
396 
397 
398 pragma experimental ABIEncoderV2;
399 
400 library VestingEntries {
401     struct VestingEntry {
402         uint64 endTime;
403         uint256 escrowAmount;
404     }
405     struct VestingEntryWithID {
406         uint64 endTime;
407         uint256 escrowAmount;
408         uint256 entryID;
409     }
410 }
411 
412 /// SIP-252: this is the interface for immutable V2 escrow (renamed with suffix Frozen).
413 /// These sources need to exist here and match on-chain frozen contracts for tests and reference.
414 /// the reason for the naming mess is that the immutable LiquidatorRewards expects a working
415 /// RewardEscrowV2 resolver entry for its getReward method, so the "new" (would be V3)
416 /// needs to be found at that entry for liq-rewards to function.
417 interface IRewardEscrowV2Frozen {
418     // Views
419     function balanceOf(address account) external view returns (uint);
420 
421     function numVestingEntries(address account) external view returns (uint);
422 
423     function totalEscrowedBalance() external view returns (uint);
424 
425     function totalEscrowedAccountBalance(address account) external view returns (uint);
426 
427     function totalVestedAccountBalance(address account) external view returns (uint);
428 
429     function getVestingQuantity(address account, uint256[] calldata entryIDs) external view returns (uint);
430 
431     function getVestingSchedules(
432         address account,
433         uint256 index,
434         uint256 pageSize
435     ) external view returns (VestingEntries.VestingEntryWithID[] memory);
436 
437     function getAccountVestingEntryIDs(
438         address account,
439         uint256 index,
440         uint256 pageSize
441     ) external view returns (uint256[] memory);
442 
443     function getVestingEntryClaimable(address account, uint256 entryID) external view returns (uint);
444 
445     function getVestingEntry(address account, uint256 entryID) external view returns (uint64, uint256);
446 
447     // Mutative functions
448     function vest(uint256[] calldata entryIDs) external;
449 
450     function createEscrowEntry(
451         address beneficiary,
452         uint256 deposit,
453         uint256 duration
454     ) external;
455 
456     function appendVestingEntry(
457         address account,
458         uint256 quantity,
459         uint256 duration
460     ) external;
461 
462     function migrateVestingSchedule(address _addressToMigrate) external;
463 
464     function migrateAccountEscrowBalances(
465         address[] calldata accounts,
466         uint256[] calldata escrowBalances,
467         uint256[] calldata vestedBalances
468     ) external;
469 
470     // Account Merging
471     function startMergingWindow() external;
472 
473     function mergeAccount(address accountToMerge, uint256[] calldata entryIDs) external;
474 
475     function nominateAccountToMerge(address account) external;
476 
477     function accountMergingIsOpen() external view returns (bool);
478 
479     // L2 Migration
480     function importVestingEntries(
481         address account,
482         uint256 escrowedAmount,
483         VestingEntries.VestingEntry[] calldata vestingEntries
484     ) external;
485 
486     // Return amount of SNX transfered to SynthetixBridgeToOptimism deposit contract
487     function burnForMigration(address account, uint256[] calldata entryIDs)
488         external
489         returns (uint256 escrowedAccountBalance, VestingEntries.VestingEntry[] memory vestingEntries);
490 
491     function nextEntryId() external view returns (uint);
492 
493     function vestingSchedules(address account, uint256 entryId) external view returns (VestingEntries.VestingEntry memory);
494 
495     function accountVestingEntryIDs(address account, uint256 index) external view returns (uint);
496 
497     //function totalEscrowedAccountBalance(address account) external view returns (uint);
498     //function totalVestedAccountBalance(address account) external view returns (uint);
499 }
500 
501 
502 interface IRewardEscrowV2Storage {
503     /// Views
504     function numVestingEntries(address account) external view returns (uint);
505 
506     function totalEscrowedAccountBalance(address account) external view returns (uint);
507 
508     function totalVestedAccountBalance(address account) external view returns (uint);
509 
510     function totalEscrowedBalance() external view returns (uint);
511 
512     function nextEntryId() external view returns (uint);
513 
514     function vestingSchedules(address account, uint256 entryId) external view returns (VestingEntries.VestingEntry memory);
515 
516     function accountVestingEntryIDs(address account, uint256 index) external view returns (uint);
517 
518     /// Mutative
519     function setZeroAmount(address account, uint entryId) external;
520 
521     function setZeroAmountUntilTarget(
522         address account,
523         uint startIndex,
524         uint targetAmount
525     )
526         external
527         returns (
528             uint total,
529             uint endIndex,
530             uint lastEntryTime
531         );
532 
533     function updateEscrowAccountBalance(address account, int delta) external;
534 
535     function updateVestedAccountBalance(address account, int delta) external;
536 
537     function updateTotalEscrowedBalance(int delta) external;
538 
539     function addVestingEntry(address account, VestingEntries.VestingEntry calldata entry) external returns (uint);
540 
541     // setFallbackRewardEscrow is used for configuration but not used by contracts
542 }
543 
544 /// this should remain backwards compatible to IRewardEscrowV2Frozen
545 /// ideally this would be done by inheriting from that interface
546 /// but solidity v0.5 doesn't support interface inheritance
547 interface IRewardEscrowV2 {
548     // Views
549     function balanceOf(address account) external view returns (uint);
550 
551     function numVestingEntries(address account) external view returns (uint);
552 
553     function totalEscrowedBalance() external view returns (uint);
554 
555     function totalEscrowedAccountBalance(address account) external view returns (uint);
556 
557     function totalVestedAccountBalance(address account) external view returns (uint);
558 
559     function getVestingQuantity(address account, uint256[] calldata entryIDs) external view returns (uint);
560 
561     function getVestingSchedules(
562         address account,
563         uint256 index,
564         uint256 pageSize
565     ) external view returns (VestingEntries.VestingEntryWithID[] memory);
566 
567     function getAccountVestingEntryIDs(
568         address account,
569         uint256 index,
570         uint256 pageSize
571     ) external view returns (uint256[] memory);
572 
573     function getVestingEntryClaimable(address account, uint256 entryID) external view returns (uint);
574 
575     function getVestingEntry(address account, uint256 entryID) external view returns (uint64, uint256);
576 
577     // Mutative functions
578     function vest(uint256[] calldata entryIDs) external;
579 
580     function createEscrowEntry(
581         address beneficiary,
582         uint256 deposit,
583         uint256 duration
584     ) external;
585 
586     function appendVestingEntry(
587         address account,
588         uint256 quantity,
589         uint256 duration
590     ) external;
591 
592     function migrateVestingSchedule(address _addressToMigrate) external;
593 
594     function migrateAccountEscrowBalances(
595         address[] calldata accounts,
596         uint256[] calldata escrowBalances,
597         uint256[] calldata vestedBalances
598     ) external;
599 
600     // Account Merging
601     function startMergingWindow() external;
602 
603     function mergeAccount(address accountToMerge, uint256[] calldata entryIDs) external;
604 
605     function nominateAccountToMerge(address account) external;
606 
607     function accountMergingIsOpen() external view returns (bool);
608 
609     // L2 Migration
610     function importVestingEntries(
611         address account,
612         uint256 escrowedAmount,
613         VestingEntries.VestingEntry[] calldata vestingEntries
614     ) external;
615 
616     // Return amount of SNX transfered to SynthetixBridgeToOptimism deposit contract
617     function burnForMigration(address account, uint256[] calldata entryIDs)
618         external
619         returns (uint256 escrowedAccountBalance, VestingEntries.VestingEntry[] memory vestingEntries);
620 
621     function nextEntryId() external view returns (uint);
622 
623     function vestingSchedules(address account, uint256 entryId) external view returns (VestingEntries.VestingEntry memory);
624 
625     function accountVestingEntryIDs(address account, uint256 index) external view returns (uint);
626 
627     /// below are methods not available in IRewardEscrowV2Frozen
628 
629     // revoke entries for liquidations (access controlled to Synthetix)
630     function revokeFrom(
631         address account,
632         address recipient,
633         uint targetAmount,
634         uint startIndex
635     ) external;
636 }
637 
638 
639 // SPDX-License-Identifier: MIT
640 
641 /*
642 The MIT License (MIT)
643 
644 Copyright (c) 2016-2020 zOS Global Limited
645 
646 Permission is hereby granted, free of charge, to any person obtaining
647 a copy of this software and associated documentation files (the
648 "Software"), to deal in the Software without restriction, including
649 without limitation the rights to use, copy, modify, merge, publish,
650 distribute, sublicense, and/or sell copies of the Software, and to
651 permit persons to whom the Software is furnished to do so, subject to
652 the following conditions:
653 
654 The above copyright notice and this permission notice shall be included
655 in all copies or substantial portions of the Software.
656 
657 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
658 OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
659 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
660 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
661 CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
662 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
663 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
664 */
665 
666 /*
667  * When we upgrade to solidity v0.6.0 or above, we should be able to
668  * just do import `"openzeppelin-solidity-3.0.0/contracts/math/SignedSafeMath.sol";`
669  * wherever this is used.
670  */
671 
672 
673 /**
674  * @title SignedSafeMath
675  * @dev Signed math operations with safety checks that revert on error.
676  */
677 library SignedSafeMath {
678     int256 private constant _INT256_MIN = -2**255;
679 
680     /**
681      * @dev Returns the multiplication of two signed integers, reverting on
682      * overflow.
683      *
684      * Counterpart to Solidity's `*` operator.
685      *
686      * Requirements:
687      *
688      * - Multiplication cannot overflow.
689      */
690     function mul(int256 a, int256 b) internal pure returns (int256) {
691         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
692         // benefit is lost if 'b' is also tested.
693         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
694         if (a == 0) {
695             return 0;
696         }
697 
698         require(!(a == -1 && b == _INT256_MIN), "SignedSafeMath: multiplication overflow");
699 
700         int256 c = a * b;
701         require(c / a == b, "SignedSafeMath: multiplication overflow");
702 
703         return c;
704     }
705 
706     /**
707      * @dev Returns the integer division of two signed integers. Reverts on
708      * division by zero. The result is rounded towards zero.
709      *
710      * Counterpart to Solidity's `/` operator. Note: this function uses a
711      * `revert` opcode (which leaves remaining gas untouched) while Solidity
712      * uses an invalid opcode to revert (consuming all remaining gas).
713      *
714      * Requirements:
715      *
716      * - The divisor cannot be zero.
717      */
718     function div(int256 a, int256 b) internal pure returns (int256) {
719         require(b != 0, "SignedSafeMath: division by zero");
720         require(!(b == -1 && a == _INT256_MIN), "SignedSafeMath: division overflow");
721 
722         int256 c = a / b;
723 
724         return c;
725     }
726 
727     /**
728      * @dev Returns the subtraction of two signed integers, reverting on
729      * overflow.
730      *
731      * Counterpart to Solidity's `-` operator.
732      *
733      * Requirements:
734      *
735      * - Subtraction cannot overflow.
736      */
737     function sub(int256 a, int256 b) internal pure returns (int256) {
738         int256 c = a - b;
739         require((b >= 0 && c <= a) || (b < 0 && c > a), "SignedSafeMath: subtraction overflow");
740 
741         return c;
742     }
743 
744     /**
745      * @dev Returns the addition of two signed integers, reverting on
746      * overflow.
747      *
748      * Counterpart to Solidity's `+` operator.
749      *
750      * Requirements:
751      *
752      * - Addition cannot overflow.
753      */
754     function add(int256 a, int256 b) internal pure returns (int256) {
755         int256 c = a + b;
756         require((b >= 0 && c >= a) || (b < 0 && c < a), "SignedSafeMath: addition overflow");
757 
758         return c;
759     }
760 }
761 
762 
763 /**
764  * @dev Wrappers over Solidity's arithmetic operations with added overflow
765  * checks.
766  *
767  * Arithmetic operations in Solidity wrap on overflow. This can easily result
768  * in bugs, because programmers usually assume that an overflow raises an
769  * error, which is the standard behavior in high level programming languages.
770  * `SafeMath` restores this intuition by reverting the transaction when an
771  * operation overflows.
772  *
773  * Using this library instead of the unchecked operations eliminates an entire
774  * class of bugs, so it's recommended to use it always.
775  */
776 library SafeMath {
777     /**
778      * @dev Returns the addition of two unsigned integers, reverting on
779      * overflow.
780      *
781      * Counterpart to Solidity's `+` operator.
782      *
783      * Requirements:
784      * - Addition cannot overflow.
785      */
786     function add(uint256 a, uint256 b) internal pure returns (uint256) {
787         uint256 c = a + b;
788         require(c >= a, "SafeMath: addition overflow");
789 
790         return c;
791     }
792 
793     /**
794      * @dev Returns the subtraction of two unsigned integers, reverting on
795      * overflow (when the result is negative).
796      *
797      * Counterpart to Solidity's `-` operator.
798      *
799      * Requirements:
800      * - Subtraction cannot overflow.
801      */
802     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
803         require(b <= a, "SafeMath: subtraction overflow");
804         uint256 c = a - b;
805 
806         return c;
807     }
808 
809     /**
810      * @dev Returns the multiplication of two unsigned integers, reverting on
811      * overflow.
812      *
813      * Counterpart to Solidity's `*` operator.
814      *
815      * Requirements:
816      * - Multiplication cannot overflow.
817      */
818     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
819         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
820         // benefit is lost if 'b' is also tested.
821         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
822         if (a == 0) {
823             return 0;
824         }
825 
826         uint256 c = a * b;
827         require(c / a == b, "SafeMath: multiplication overflow");
828 
829         return c;
830     }
831 
832     /**
833      * @dev Returns the integer division of two unsigned integers. Reverts on
834      * division by zero. The result is rounded towards zero.
835      *
836      * Counterpart to Solidity's `/` operator. Note: this function uses a
837      * `revert` opcode (which leaves remaining gas untouched) while Solidity
838      * uses an invalid opcode to revert (consuming all remaining gas).
839      *
840      * Requirements:
841      * - The divisor cannot be zero.
842      */
843     function div(uint256 a, uint256 b) internal pure returns (uint256) {
844         // Solidity only automatically asserts when dividing by 0
845         require(b > 0, "SafeMath: division by zero");
846         uint256 c = a / b;
847         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
848 
849         return c;
850     }
851 
852     /**
853      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
854      * Reverts when dividing by zero.
855      *
856      * Counterpart to Solidity's `%` operator. This function uses a `revert`
857      * opcode (which leaves remaining gas untouched) while Solidity uses an
858      * invalid opcode to revert (consuming all remaining gas).
859      *
860      * Requirements:
861      * - The divisor cannot be zero.
862      */
863     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
864         require(b != 0, "SafeMath: modulo by zero");
865         return a % b;
866     }
867 }
868 
869 
870 // Inheritance
871 
872 
873 // https://docs.synthetix.io/contracts/source/contracts/state
874 contract State is Owned {
875     // the address of the contract that can modify variables
876     // this can only be changed by the owner of this contract
877     address public associatedContract;
878 
879     constructor(address _associatedContract) internal {
880         // This contract is abstract, and thus cannot be instantiated directly
881         require(owner != address(0), "Owner must be set");
882 
883         associatedContract = _associatedContract;
884         emit AssociatedContractUpdated(_associatedContract);
885     }
886 
887     /* ========== SETTERS ========== */
888 
889     // Change the associated contract to a new address
890     function setAssociatedContract(address _associatedContract) external onlyOwner {
891         associatedContract = _associatedContract;
892         emit AssociatedContractUpdated(_associatedContract);
893     }
894 
895     /* ========== MODIFIERS ========== */
896 
897     modifier onlyAssociatedContract {
898         require(msg.sender == associatedContract, "Only the associated contract can perform this action");
899         _;
900     }
901 
902     /* ========== EVENTS ========== */
903 
904     event AssociatedContractUpdated(address associatedContract);
905 }
906 
907 
908 // interface for vesting entries
909 
910 
911 // interface
912 
913 
914 // libraries
915 
916 
917 // inheritance
918 
919 
920 /// A contract for reading and writing to/from storage while falling back to values from
921 /// previous RewardEscrowV2 contract.
922 contract RewardEscrowV2Storage is IRewardEscrowV2Storage, State {
923     using SafeMath for uint;
924     using SignedSafeMath for int;
925 
926     // cheaper storage for L1 compared to original struct, only used for storage
927     // original struct still used in interface for backwards compatibility
928     struct StorageEntry {
929         uint32 endTime;
930         uint224 escrowAmount;
931     }
932 
933     /// INTERNAL storage
934 
935     // accounts => vesting entries
936     mapping(address => mapping(uint => StorageEntry)) internal _vestingSchedules;
937 
938     // accounts => entry ids
939     mapping(address => uint[]) internal _accountVestingEntryIds;
940 
941     // accounts => cache of entry counts in fallback contract
942     // this as an int in order to be able to store ZERO_PLACEHOLDER to only cache once
943     mapping(address => int) internal _fallbackCounts;
944 
945     // account's total escrow SNX balance (still to vest)
946     // this as an int in order to be able to store ZERO_PLACEHOLDER to prevent reading stale values
947     mapping(address => int) internal _totalEscrowedAccountBalance;
948 
949     // account's total vested rewards (vested already)
950     // this as an int in order to be able to store ZERO_PLACEHOLDER to prevent reading stale values
951     mapping(address => int) internal _totalVestedAccountBalance;
952 
953     // The total remaining escrow balance of contract
954     uint internal _totalEscrowedBalance;
955 
956     /// PUBLIC storage
957 
958     // Counter for new vesting entry ids.
959     uint public nextEntryId;
960 
961     // id starting from which the new entries are stored in this contact only (and don't need to be read from fallback)
962     uint public firstNonFallbackId;
963 
964     // -1 wei is a zero value placeholder in the read-through storage.
965     // needed to prevent writing zeros and reading stale values (0 is used to mean uninitialized)
966     // The alternative of explicit flags introduces its own set problems of ensuring they are written and read
967     // correctly (in addition to the values themselves). It adds code complexity, and gas costs, which when optimized
968     // lead to added coupling between different variables and even more complexity and potential for mistakenly
969     // invalidating or not invalidating the cache.
970     int internal constant ZERO_PLACEHOLDER = -1;
971 
972     // previous rewards escrow contract
973     IRewardEscrowV2Frozen public fallbackRewardEscrow;
974 
975     // interface view
976     bytes32 public constant CONTRACT_NAME = "RewardEscrowV2Storage";
977 
978     /* ========== CONSTRUCTOR ========== */
979 
980     constructor(address _owner, address _associatedContract) public Owned(_owner) State(_associatedContract) {}
981 
982     /// this can happen only once and assumes that IRewardEscrowV2Frozen is in fact Frozen both in code and in
983     /// data(!!) with most mutative methods reverting (e.g. due to blocked transfers)
984     function setFallbackRewardEscrow(IRewardEscrowV2Frozen _fallbackRewardEscrow) external onlyOwner {
985         require(address(fallbackRewardEscrow) == address(0), "already set");
986         require(address(_fallbackRewardEscrow) != address(0), "cannot be zero address");
987 
988         fallbackRewardEscrow = _fallbackRewardEscrow;
989         nextEntryId = _fallbackRewardEscrow.nextEntryId();
990         firstNonFallbackId = nextEntryId;
991 
992         // carry over previous balance tracking
993         _totalEscrowedBalance = fallbackRewardEscrow.totalEscrowedBalance();
994     }
995 
996     /* ========== VIEWS ========== */
997 
998     function vestingSchedules(address account, uint entryId)
999         public
1000         view
1001         withFallback
1002         returns (VestingEntries.VestingEntry memory entry)
1003     {
1004         // read stored entry
1005         StorageEntry memory stored = _vestingSchedules[account][entryId];
1006         // convert to previous data size format
1007         entry = VestingEntries.VestingEntry({endTime: stored.endTime, escrowAmount: stored.escrowAmount});
1008         // read from fallback if this entryId was created in the old contract and wasn't written locally
1009         // this assumes that no new entries can be created with endTime = 0 (checked during addVestingEntry)
1010         if (entryId < firstNonFallbackId && entry.endTime == 0) {
1011             entry = fallbackRewardEscrow.vestingSchedules(account, entryId);
1012         }
1013         return entry;
1014     }
1015 
1016     function accountVestingEntryIDs(address account, uint index) public view withFallback returns (uint) {
1017         uint fallbackCount = _fallbackNumVestingEntries(account);
1018 
1019         // this assumes no new entries can be created in the old contract
1020         // any added entries in the old contract after this value is cached will be ignored
1021         if (index < fallbackCount) {
1022             return fallbackRewardEscrow.accountVestingEntryIDs(account, index);
1023         } else {
1024             return _accountVestingEntryIds[account][index - fallbackCount];
1025         }
1026     }
1027 
1028     function totalEscrowedBalance() public view withFallback returns (uint) {
1029         return _totalEscrowedBalance;
1030     }
1031 
1032     function totalEscrowedAccountBalance(address account) public view withFallback returns (uint) {
1033         // this as an int in order to be able to store ZERO_PLACEHOLDER which is -1
1034         int v = _totalEscrowedAccountBalance[account];
1035 
1036         // 0 should never be stored to prevent reading stale value from fallback
1037         if (v == 0) {
1038             return fallbackRewardEscrow.totalEscrowedAccountBalance(account);
1039         } else {
1040             return _readWithZeroPlaceholder(v);
1041         }
1042     }
1043 
1044     function totalVestedAccountBalance(address account) public view withFallback returns (uint) {
1045         // this as an int in order to be able to store ZERO_PLACEHOLDER which is -1
1046         int v = _totalVestedAccountBalance[account];
1047 
1048         // 0 should never be stored to prevent reading stale value from fallback
1049         if (v == 0) {
1050             return fallbackRewardEscrow.totalVestedAccountBalance(account);
1051         } else {
1052             return _readWithZeroPlaceholder(v);
1053         }
1054     }
1055 
1056     /// The number of vesting dates in an account's schedule.
1057     function numVestingEntries(address account) public view withFallback returns (uint) {
1058         /// assumes no enties can be written in frozen contract
1059         return _fallbackNumVestingEntries(account) + _accountVestingEntryIds[account].length;
1060     }
1061 
1062     /* ========== INTERNAL VIEWS ========== */
1063 
1064     function _fallbackNumVestingEntries(address account) internal view returns (uint) {
1065         // cache is used here to prevent external calls during looping
1066         int v = _fallbackCounts[account];
1067         if (v == 0) {
1068             // uninitialized
1069             return fallbackRewardEscrow.numVestingEntries(account);
1070         } else {
1071             return _readWithZeroPlaceholder(v);
1072         }
1073     }
1074 
1075     /* ========== MUTATIVE FUNCTIONS ========== */
1076 
1077     /// zeros out a single entry
1078     function setZeroAmount(address account, uint entryId) public withFallback onlyAssociatedContract {
1079         // load storage entry
1080         StorageEntry storage storedEntry = _vestingSchedules[account][entryId];
1081         // endTime is used for cache invalidation
1082         uint endTime = storedEntry.endTime;
1083         // update endTime from fallback if this is first time this entry is written in this contract
1084         if (endTime == 0) {
1085             // entry should be in fallback, otherwise it would have endTime or be uninitialized
1086             endTime = fallbackRewardEscrow.vestingSchedules(account, entryId).endTime;
1087         }
1088         _setZeroAmountWithEndTime(account, entryId, endTime);
1089     }
1090 
1091     /// zero out multiple entries in order of accountVestingEntryIDs until target is reached (or entries exhausted)
1092     /// @param account: account
1093     /// @param startIndex: index into accountVestingEntryIDs to start with. NOT an entryID.
1094     /// @param targetAmount: amount to try and reach during the iteration, once the amount it reached (and passed)
1095     ///     the iteration stops
1096     /// @return total: total sum reached, may different from targetAmount (higher if sum is a bit more), lower
1097     ///     if target wasn't reached reaching the length of the array
1098     /// @return endIndex: the index of the last revoked entry
1099     /// @return lastEntryTime: the endTime of the last revoked entry
1100     function setZeroAmountUntilTarget(
1101         address account,
1102         uint startIndex,
1103         uint targetAmount
1104     )
1105         external
1106         withFallback
1107         onlyAssociatedContract
1108         returns (
1109             uint total,
1110             uint endIndex,
1111             uint lastEntryTime
1112         )
1113     {
1114         require(targetAmount > 0, "targetAmount is zero");
1115 
1116         // store the count to reduce external calls in accountVestingEntryIDs
1117         _cacheFallbackIDCount(account);
1118 
1119         uint numIds = numVestingEntries(account);
1120         require(numIds > 0, "no entries to iterate");
1121         require(startIndex < numIds, "startIndex too high");
1122 
1123         uint entryID;
1124         uint i;
1125         VestingEntries.VestingEntry memory entry;
1126         for (i = startIndex; i < numIds; i++) {
1127             entryID = accountVestingEntryIDs(account, i);
1128             entry = vestingSchedules(account, entryID);
1129 
1130             // skip vested
1131             if (entry.escrowAmount > 0) {
1132                 total = total.add(entry.escrowAmount);
1133 
1134                 // set to zero, endTime is correct because vestingSchedules will use fallback if needed
1135                 _setZeroAmountWithEndTime(account, entryID, entry.endTime);
1136 
1137                 if (total >= targetAmount) {
1138                     break;
1139                 }
1140             }
1141         }
1142         i = i == numIds ? i - 1 : i; // i was incremented one extra time if there was no break
1143         return (total, i, entry.endTime);
1144     }
1145 
1146     function updateEscrowAccountBalance(address account, int delta) external withFallback onlyAssociatedContract {
1147         // add / subtract to previous balance
1148         int total = int(totalEscrowedAccountBalance(account)).add(delta);
1149         require(total >= 0, "updateEscrowAccountBalance: balance must be positive");
1150         // zero value must never be written, because it is used to signal uninitialized
1151         //  writing an actual 0 will result in stale value being read from fallback
1152         // casting is safe because checked above
1153         _totalEscrowedAccountBalance[account] = _writeWithZeroPlaceholder(uint(total));
1154 
1155         // update the global total
1156         updateTotalEscrowedBalance(delta);
1157     }
1158 
1159     function updateVestedAccountBalance(address account, int delta) external withFallback onlyAssociatedContract {
1160         // add / subtract to previous balance
1161         int total = int(totalVestedAccountBalance(account)).add(delta);
1162         require(total >= 0, "updateVestedAccountBalance: balance must be positive");
1163         // zero value must never be written, because it is used to signal uninitialized
1164         //  writing an actual 0 will result in stale value being read from fallback
1165         // casting is safe because checked above
1166         _totalVestedAccountBalance[account] = _writeWithZeroPlaceholder(uint(total));
1167     }
1168 
1169     /// this method is unused in contracts (because updateEscrowAccountBalance uses it), but it is here
1170     /// for completeness, in case a fix to one of these values is needed (but not the other)
1171     function updateTotalEscrowedBalance(int delta) public withFallback onlyAssociatedContract {
1172         int total = int(totalEscrowedBalance()).add(delta);
1173         require(total >= 0, "updateTotalEscrowedBalance: balance must be positive");
1174         _totalEscrowedBalance = uint(total);
1175     }
1176 
1177     /// append entry for an account
1178     function addVestingEntry(address account, VestingEntries.VestingEntry calldata entry)
1179         external
1180         withFallback
1181         onlyAssociatedContract
1182         returns (uint)
1183     {
1184         // zero time is used as read-miss flag in this contract
1185         require(entry.endTime != 0, "vesting target time zero");
1186 
1187         uint entryId = nextEntryId;
1188         // since this is a completely new entry, it's safe to write it directly without checking fallback data
1189         _vestingSchedules[account][entryId] = StorageEntry({
1190             endTime: uint32(entry.endTime),
1191             escrowAmount: uint224(entry.escrowAmount)
1192         });
1193 
1194         // append entryId to list of entries for account
1195         _accountVestingEntryIds[account].push(entryId);
1196 
1197         // Increment the next entry id.
1198         nextEntryId++;
1199 
1200         return entryId;
1201     }
1202 
1203     /* ========== INTERNAL MUTATIVE ========== */
1204 
1205     /// zeros out a single entry in local contract with provided time while ensuring
1206     /// that endTime is not being stored as zero if it passed as zero
1207     function _setZeroAmountWithEndTime(
1208         address account,
1209         uint entryId,
1210         uint endTime
1211     ) internal {
1212         // load storage entry
1213         StorageEntry storage storedEntry = _vestingSchedules[account][entryId];
1214         // Impossible edge-case: checking that endTime is not zero (in which case the entry will be
1215         // read from fallback again). A zero endTime with non-zero amount is not possible in the old contract
1216         // but it's better to check just for completeness still, and write current timestamp (vestable).
1217         storedEntry.endTime = uint32(endTime != 0 ? endTime : block.timestamp);
1218         storedEntry.escrowAmount = 0;
1219     }
1220 
1221     /// this caching is done to prevent repeatedly calling the old contract for number of entries
1222     /// during looping
1223     function _cacheFallbackIDCount(address account) internal {
1224         if (_fallbackCounts[account] == 0) {
1225             uint fallbackCount = fallbackRewardEscrow.numVestingEntries(account);
1226             // cache the value but don't write zero
1227             _fallbackCounts[account] = _writeWithZeroPlaceholder(fallbackCount);
1228         }
1229     }
1230 
1231     /* ========== HELPER ========== */
1232 
1233     function _writeWithZeroPlaceholder(uint v) internal pure returns (int) {
1234         // 0 is uninitialized value, so a special value is used to store an actual 0 (that is initialized)
1235         return v == 0 ? ZERO_PLACEHOLDER : int(v);
1236     }
1237 
1238     function _readWithZeroPlaceholder(int v) internal pure returns (uint) {
1239         // 0 is uninitialized value, so a special value is used to store an actual 0 (that is initialized)
1240         return uint(v == ZERO_PLACEHOLDER ? 0 : v);
1241     }
1242 
1243     /* ========== Modifier ========== */
1244 
1245     modifier withFallback() {
1246         require(address(fallbackRewardEscrow) != address(0), "fallback not set");
1247         _;
1248     }
1249 }
1250 
1251 
1252 // https://docs.synthetix.io/contracts/source/contracts/limitedsetup
1253 contract LimitedSetup {
1254     uint public setupExpiryTime;
1255 
1256     /**
1257      * @dev LimitedSetup Constructor.
1258      * @param setupDuration The time the setup period will last for.
1259      */
1260     constructor(uint setupDuration) internal {
1261         setupExpiryTime = now + setupDuration;
1262     }
1263 
1264     modifier onlyDuringSetup {
1265         require(now < setupExpiryTime, "Can only perform this action during setup");
1266         _;
1267     }
1268 }
1269 
1270 
1271 // SPDX-License-Identifier: MIT
1272 
1273 
1274 /**
1275  * @dev Wrappers over Solidity's uintXX casting operators with added overflow
1276  * checks.
1277  *
1278  * Downcasting from uint256 in Solidity does not revert on overflow. This can
1279  * easily result in undesired exploitation or bugs, since developers usually
1280  * assume that overflows raise errors. `SafeCast` restores this intuition by
1281  * reverting the transaction when such an operation overflows.
1282  *
1283  * Using this library instead of the unchecked operations eliminates an entire
1284  * class of bugs, so it's recommended to use it always.
1285  *
1286  * Can be combined with {SafeMath} to extend it to smaller types, by performing
1287  * all math on `uint256` and then downcasting.
1288  */
1289 library SafeCast {
1290     /**
1291      * @dev Returns the downcasted uint128 from uint256, reverting on
1292      * overflow (when the input is greater than largest uint128).
1293      *
1294      * Counterpart to Solidity's `uint128` operator.
1295      *
1296      * Requirements:
1297      *
1298      * - input must fit into 128 bits
1299      */
1300     function toUint128(uint256 value) internal pure returns (uint128) {
1301         require(value < 2**128, "SafeCast: value doesn't fit in 128 bits");
1302         return uint128(value);
1303     }
1304 
1305     /**
1306      * @dev Returns the downcasted uint64 from uint256, reverting on
1307      * overflow (when the input is greater than largest uint64).
1308      *
1309      * Counterpart to Solidity's `uint64` operator.
1310      *
1311      * Requirements:
1312      *
1313      * - input must fit into 64 bits
1314      */
1315     function toUint64(uint256 value) internal pure returns (uint64) {
1316         require(value < 2**64, "SafeCast: value doesn't fit in 64 bits");
1317         return uint64(value);
1318     }
1319 
1320     /**
1321      * @dev Returns the downcasted uint32 from uint256, reverting on
1322      * overflow (when the input is greater than largest uint32).
1323      *
1324      * Counterpart to Solidity's `uint32` operator.
1325      *
1326      * Requirements:
1327      *
1328      * - input must fit into 32 bits
1329      */
1330     function toUint32(uint256 value) internal pure returns (uint32) {
1331         require(value < 2**32, "SafeCast: value doesn't fit in 32 bits");
1332         return uint32(value);
1333     }
1334 
1335     /**
1336      * @dev Returns the downcasted uint16 from uint256, reverting on
1337      * overflow (when the input is greater than largest uint16).
1338      *
1339      * Counterpart to Solidity's `uint16` operator.
1340      *
1341      * Requirements:
1342      *
1343      * - input must fit into 16 bits
1344      */
1345     function toUint16(uint256 value) internal pure returns (uint16) {
1346         require(value < 2**16, "SafeCast: value doesn't fit in 16 bits");
1347         return uint16(value);
1348     }
1349 
1350     /**
1351      * @dev Returns the downcasted uint8 from uint256, reverting on
1352      * overflow (when the input is greater than largest uint8).
1353      *
1354      * Counterpart to Solidity's `uint8` operator.
1355      *
1356      * Requirements:
1357      *
1358      * - input must fit into 8 bits.
1359      */
1360     function toUint8(uint256 value) internal pure returns (uint8) {
1361         require(value < 2**8, "SafeCast: value doesn't fit in 8 bits");
1362         return uint8(value);
1363     }
1364 
1365     /**
1366      * @dev Converts a signed int256 into an unsigned uint256.
1367      *
1368      * Requirements:
1369      *
1370      * - input must be greater than or equal to 0.
1371      */
1372     function toUint256(int256 value) internal pure returns (uint256) {
1373         require(value >= 0, "SafeCast: value must be positive");
1374         return uint256(value);
1375     }
1376 
1377     /**
1378      * @dev Converts an unsigned uint256 into a signed int256.
1379      *
1380      * Requirements:
1381      *
1382      * - input must be less than or equal to maxInt256.
1383      */
1384     function toInt256(uint256 value) internal pure returns (int256) {
1385         require(value < 2**255, "SafeCast: value doesn't fit in an int256");
1386         return int256(value);
1387     }
1388 }
1389 
1390 
1391 // Libraries
1392 
1393 
1394 // https://docs.synthetix.io/contracts/source/libraries/safedecimalmath
1395 library SafeDecimalMath {
1396     using SafeMath for uint;
1397 
1398     /* Number of decimal places in the representations. */
1399     uint8 public constant decimals = 18;
1400     uint8 public constant highPrecisionDecimals = 27;
1401 
1402     /* The number representing 1.0. */
1403     uint public constant UNIT = 10**uint(decimals);
1404 
1405     /* The number representing 1.0 for higher fidelity numbers. */
1406     uint public constant PRECISE_UNIT = 10**uint(highPrecisionDecimals);
1407     uint private constant UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR = 10**uint(highPrecisionDecimals - decimals);
1408 
1409     /**
1410      * @return Provides an interface to UNIT.
1411      */
1412     function unit() external pure returns (uint) {
1413         return UNIT;
1414     }
1415 
1416     /**
1417      * @return Provides an interface to PRECISE_UNIT.
1418      */
1419     function preciseUnit() external pure returns (uint) {
1420         return PRECISE_UNIT;
1421     }
1422 
1423     /**
1424      * @return The result of multiplying x and y, interpreting the operands as fixed-point
1425      * decimals.
1426      *
1427      * @dev A unit factor is divided out after the product of x and y is evaluated,
1428      * so that product must be less than 2**256. As this is an integer division,
1429      * the internal division always rounds down. This helps save on gas. Rounding
1430      * is more expensive on gas.
1431      */
1432     function multiplyDecimal(uint x, uint y) internal pure returns (uint) {
1433         /* Divide by UNIT to remove the extra factor introduced by the product. */
1434         return x.mul(y) / UNIT;
1435     }
1436 
1437     /**
1438      * @return The result of safely multiplying x and y, interpreting the operands
1439      * as fixed-point decimals of the specified precision unit.
1440      *
1441      * @dev The operands should be in the form of a the specified unit factor which will be
1442      * divided out after the product of x and y is evaluated, so that product must be
1443      * less than 2**256.
1444      *
1445      * Unlike multiplyDecimal, this function rounds the result to the nearest increment.
1446      * Rounding is useful when you need to retain fidelity for small decimal numbers
1447      * (eg. small fractions or percentages).
1448      */
1449     function _multiplyDecimalRound(
1450         uint x,
1451         uint y,
1452         uint precisionUnit
1453     ) private pure returns (uint) {
1454         /* Divide by UNIT to remove the extra factor introduced by the product. */
1455         uint quotientTimesTen = x.mul(y) / (precisionUnit / 10);
1456 
1457         if (quotientTimesTen % 10 >= 5) {
1458             quotientTimesTen += 10;
1459         }
1460 
1461         return quotientTimesTen / 10;
1462     }
1463 
1464     /**
1465      * @return The result of safely multiplying x and y, interpreting the operands
1466      * as fixed-point decimals of a precise unit.
1467      *
1468      * @dev The operands should be in the precise unit factor which will be
1469      * divided out after the product of x and y is evaluated, so that product must be
1470      * less than 2**256.
1471      *
1472      * Unlike multiplyDecimal, this function rounds the result to the nearest increment.
1473      * Rounding is useful when you need to retain fidelity for small decimal numbers
1474      * (eg. small fractions or percentages).
1475      */
1476     function multiplyDecimalRoundPrecise(uint x, uint y) internal pure returns (uint) {
1477         return _multiplyDecimalRound(x, y, PRECISE_UNIT);
1478     }
1479 
1480     /**
1481      * @return The result of safely multiplying x and y, interpreting the operands
1482      * as fixed-point decimals of a standard unit.
1483      *
1484      * @dev The operands should be in the standard unit factor which will be
1485      * divided out after the product of x and y is evaluated, so that product must be
1486      * less than 2**256.
1487      *
1488      * Unlike multiplyDecimal, this function rounds the result to the nearest increment.
1489      * Rounding is useful when you need to retain fidelity for small decimal numbers
1490      * (eg. small fractions or percentages).
1491      */
1492     function multiplyDecimalRound(uint x, uint y) internal pure returns (uint) {
1493         return _multiplyDecimalRound(x, y, UNIT);
1494     }
1495 
1496     /**
1497      * @return The result of safely dividing x and y. The return value is a high
1498      * precision decimal.
1499      *
1500      * @dev y is divided after the product of x and the standard precision unit
1501      * is evaluated, so the product of x and UNIT must be less than 2**256. As
1502      * this is an integer division, the result is always rounded down.
1503      * This helps save on gas. Rounding is more expensive on gas.
1504      */
1505     function divideDecimal(uint x, uint y) internal pure returns (uint) {
1506         /* Reintroduce the UNIT factor that will be divided out by y. */
1507         return x.mul(UNIT).div(y);
1508     }
1509 
1510     /**
1511      * @return The result of safely dividing x and y. The return value is as a rounded
1512      * decimal in the precision unit specified in the parameter.
1513      *
1514      * @dev y is divided after the product of x and the specified precision unit
1515      * is evaluated, so the product of x and the specified precision unit must
1516      * be less than 2**256. The result is rounded to the nearest increment.
1517      */
1518     function _divideDecimalRound(
1519         uint x,
1520         uint y,
1521         uint precisionUnit
1522     ) private pure returns (uint) {
1523         uint resultTimesTen = x.mul(precisionUnit * 10).div(y);
1524 
1525         if (resultTimesTen % 10 >= 5) {
1526             resultTimesTen += 10;
1527         }
1528 
1529         return resultTimesTen / 10;
1530     }
1531 
1532     /**
1533      * @return The result of safely dividing x and y. The return value is as a rounded
1534      * standard precision decimal.
1535      *
1536      * @dev y is divided after the product of x and the standard precision unit
1537      * is evaluated, so the product of x and the standard precision unit must
1538      * be less than 2**256. The result is rounded to the nearest increment.
1539      */
1540     function divideDecimalRound(uint x, uint y) internal pure returns (uint) {
1541         return _divideDecimalRound(x, y, UNIT);
1542     }
1543 
1544     /**
1545      * @return The result of safely dividing x and y. The return value is as a rounded
1546      * high precision decimal.
1547      *
1548      * @dev y is divided after the product of x and the high precision unit
1549      * is evaluated, so the product of x and the high precision unit must
1550      * be less than 2**256. The result is rounded to the nearest increment.
1551      */
1552     function divideDecimalRoundPrecise(uint x, uint y) internal pure returns (uint) {
1553         return _divideDecimalRound(x, y, PRECISE_UNIT);
1554     }
1555 
1556     /**
1557      * @dev Convert a standard decimal representation to a high precision one.
1558      */
1559     function decimalToPreciseDecimal(uint i) internal pure returns (uint) {
1560         return i.mul(UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR);
1561     }
1562 
1563     /**
1564      * @dev Convert a high precision decimal to a standard decimal representation.
1565      */
1566     function preciseDecimalToDecimal(uint i) internal pure returns (uint) {
1567         uint quotientTimesTen = i / (UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR / 10);
1568 
1569         if (quotientTimesTen % 10 >= 5) {
1570             quotientTimesTen += 10;
1571         }
1572 
1573         return quotientTimesTen / 10;
1574     }
1575 
1576     // Computes `a - b`, setting the value to 0 if b > a.
1577     function floorsub(uint a, uint b) internal pure returns (uint) {
1578         return b >= a ? 0 : a - b;
1579     }
1580 
1581     /* ---------- Utilities ---------- */
1582     /*
1583      * Absolute value of the input, returned as a signed number.
1584      */
1585     function signedAbs(int x) internal pure returns (int) {
1586         return x < 0 ? -x : x;
1587     }
1588 
1589     /*
1590      * Absolute value of the input, returned as an unsigned number.
1591      */
1592     function abs(int x) internal pure returns (uint) {
1593         return uint(signedAbs(x));
1594     }
1595 }
1596 
1597 
1598 // https://docs.synthetix.io/contracts/source/interfaces/ierc20
1599 interface IERC20 {
1600     // ERC20 Optional Views
1601     function name() external view returns (string memory);
1602 
1603     function symbol() external view returns (string memory);
1604 
1605     function decimals() external view returns (uint8);
1606 
1607     // Views
1608     function totalSupply() external view returns (uint);
1609 
1610     function balanceOf(address owner) external view returns (uint);
1611 
1612     function allowance(address owner, address spender) external view returns (uint);
1613 
1614     // Mutative functions
1615     function transfer(address to, uint value) external returns (bool);
1616 
1617     function approve(address spender, uint value) external returns (bool);
1618 
1619     function transferFrom(
1620         address from,
1621         address to,
1622         uint value
1623     ) external returns (bool);
1624 
1625     // Events
1626     event Transfer(address indexed from, address indexed to, uint value);
1627 
1628     event Approval(address indexed owner, address indexed spender, uint value);
1629 }
1630 
1631 
1632 // https://docs.synthetix.io/contracts/source/interfaces/ifeepool
1633 interface IFeePool {
1634     // Views
1635 
1636     // solhint-disable-next-line func-name-mixedcase
1637     function FEE_ADDRESS() external view returns (address);
1638 
1639     function feesAvailable(address account) external view returns (uint, uint);
1640 
1641     function feePeriodDuration() external view returns (uint);
1642 
1643     function isFeesClaimable(address account) external view returns (bool);
1644 
1645     function targetThreshold() external view returns (uint);
1646 
1647     function totalFeesAvailable() external view returns (uint);
1648 
1649     function totalRewardsAvailable() external view returns (uint);
1650 
1651     // Mutative Functions
1652     function claimFees() external returns (bool);
1653 
1654     function claimOnBehalf(address claimingForAddress) external returns (bool);
1655 
1656     function closeCurrentFeePeriod() external;
1657 
1658     function closeSecondary(uint snxBackedDebt, uint debtShareSupply) external;
1659 
1660     function recordFeePaid(uint sUSDAmount) external;
1661 
1662     function setRewardsToDistribute(uint amount) external;
1663 }
1664 
1665 
1666 // Inheritance
1667 
1668 
1669 // Libraries
1670 
1671 
1672 // Internal references
1673 
1674 
1675 // https://docs.synthetix.io/contracts/RewardEscrow
1676 contract BaseRewardEscrowV2 is Owned, IRewardEscrowV2, LimitedSetup(8 weeks), MixinResolver {
1677     using SafeMath for uint;
1678     using SafeDecimalMath for uint;
1679 
1680     /* Mapping of nominated address to recieve account merging */
1681     mapping(address => address) public nominatedReceiver;
1682 
1683     /* Max escrow duration */
1684     uint public max_duration = 2 * 52 weeks; // Default max 2 years duration
1685 
1686     /* Max account merging duration */
1687     uint public maxAccountMergingDuration = 4 weeks; // Default 4 weeks is max
1688 
1689     /* ========== ACCOUNT MERGING CONFIGURATION ========== */
1690 
1691     uint public accountMergingDuration = 1 weeks;
1692 
1693     uint public accountMergingStartTime;
1694 
1695     /* ========== ADDRESS RESOLVER CONFIGURATION ========== */
1696 
1697     bytes32 private constant CONTRACT_SYNTHETIX = "Synthetix";
1698     bytes32 private constant CONTRACT_ISSUER = "Issuer";
1699     bytes32 private constant CONTRACT_FEEPOOL = "FeePool";
1700     bytes32 private constant CONTRACT_REWARDESCROWV2STORAGE = "RewardEscrowV2Storage";
1701 
1702     /* ========== CONSTRUCTOR ========== */
1703 
1704     constructor(address _owner, address _resolver) public Owned(_owner) MixinResolver(_resolver) {}
1705 
1706     /* ========== VIEWS ======================= */
1707 
1708     function feePool() internal view returns (IFeePool) {
1709         return IFeePool(requireAndGetAddress(CONTRACT_FEEPOOL));
1710     }
1711 
1712     function synthetixERC20() internal view returns (IERC20) {
1713         return IERC20(requireAndGetAddress(CONTRACT_SYNTHETIX));
1714     }
1715 
1716     function issuer() internal view returns (IIssuer) {
1717         return IIssuer(requireAndGetAddress(CONTRACT_ISSUER));
1718     }
1719 
1720     function state() internal view returns (IRewardEscrowV2Storage) {
1721         return IRewardEscrowV2Storage(requireAndGetAddress(CONTRACT_REWARDESCROWV2STORAGE));
1722     }
1723 
1724     function _notImplemented() internal pure {
1725         revert("Cannot be run on this layer");
1726     }
1727 
1728     /* ========== VIEW FUNCTIONS ========== */
1729 
1730     // Note: use public visibility so that it can be invoked in a subclass
1731     function resolverAddressesRequired() public view returns (bytes32[] memory addresses) {
1732         addresses = new bytes32[](4);
1733         addresses[0] = CONTRACT_SYNTHETIX;
1734         addresses[1] = CONTRACT_FEEPOOL;
1735         addresses[2] = CONTRACT_ISSUER;
1736         addresses[3] = CONTRACT_REWARDESCROWV2STORAGE;
1737     }
1738 
1739     /// views forwarded from storage contract
1740 
1741     function numVestingEntries(address account) public view returns (uint) {
1742         return state().numVestingEntries(account);
1743     }
1744 
1745     function totalEscrowedBalance() public view returns (uint) {
1746         return state().totalEscrowedBalance();
1747     }
1748 
1749     function totalEscrowedAccountBalance(address account) public view returns (uint) {
1750         return state().totalEscrowedAccountBalance(account);
1751     }
1752 
1753     function totalVestedAccountBalance(address account) external view returns (uint) {
1754         return state().totalVestedAccountBalance(account);
1755     }
1756 
1757     function nextEntryId() external view returns (uint) {
1758         return state().nextEntryId();
1759     }
1760 
1761     function vestingSchedules(address account, uint256 entryId) public view returns (VestingEntries.VestingEntry memory) {
1762         return state().vestingSchedules(account, entryId);
1763     }
1764 
1765     function accountVestingEntryIDs(address account, uint256 index) public view returns (uint) {
1766         return state().accountVestingEntryIDs(account, index);
1767     }
1768 
1769     /**
1770      * @notice A simple alias to totalEscrowedAccountBalance: provides ERC20 balance integration.
1771      */
1772     function balanceOf(address account) public view returns (uint) {
1773         return totalEscrowedAccountBalance(account);
1774     }
1775 
1776     /**
1777      * @notice Get a particular schedule entry for an account.
1778      * @return The vesting entry object and rate per second emission.
1779      */
1780     function getVestingEntry(address account, uint256 entryID) external view returns (uint64 endTime, uint256 escrowAmount) {
1781         VestingEntries.VestingEntry memory entry = vestingSchedules(account, entryID);
1782         return (entry.endTime, entry.escrowAmount);
1783     }
1784 
1785     function getVestingSchedules(
1786         address account,
1787         uint256 index,
1788         uint256 pageSize
1789     ) external view returns (VestingEntries.VestingEntryWithID[] memory) {
1790         uint256 endIndex = index + pageSize;
1791 
1792         // If index starts after the endIndex return no results
1793         if (endIndex <= index) {
1794             return new VestingEntries.VestingEntryWithID[](0);
1795         }
1796 
1797         // If the page extends past the end of the accountVestingEntryIDs, truncate it.
1798         if (endIndex > numVestingEntries(account)) {
1799             endIndex = numVestingEntries(account);
1800         }
1801 
1802         uint256 n = endIndex - index;
1803         uint256 entryID;
1804         VestingEntries.VestingEntry memory entry;
1805         VestingEntries.VestingEntryWithID[] memory vestingEntries = new VestingEntries.VestingEntryWithID[](n);
1806         for (uint256 i; i < n; i++) {
1807             entryID = accountVestingEntryIDs(account, i + index);
1808 
1809             entry = vestingSchedules(account, entryID);
1810 
1811             vestingEntries[i] = VestingEntries.VestingEntryWithID({
1812                 endTime: uint64(entry.endTime),
1813                 escrowAmount: entry.escrowAmount,
1814                 entryID: entryID
1815             });
1816         }
1817         return vestingEntries;
1818     }
1819 
1820     function getAccountVestingEntryIDs(
1821         address account,
1822         uint256 index,
1823         uint256 pageSize
1824     ) external view returns (uint256[] memory) {
1825         uint256 endIndex = index + pageSize;
1826 
1827         // If the page extends past the end of the accountVestingEntryIDs, truncate it.
1828         uint numEntries = numVestingEntries(account);
1829         if (endIndex > numEntries) {
1830             endIndex = numEntries;
1831         }
1832         if (endIndex <= index) {
1833             return new uint256[](0);
1834         }
1835 
1836         uint256 n = endIndex - index;
1837         uint256[] memory page = new uint256[](n);
1838         for (uint256 i; i < n; i++) {
1839             page[i] = accountVestingEntryIDs(account, i + index);
1840         }
1841         return page;
1842     }
1843 
1844     function getVestingQuantity(address account, uint256[] calldata entryIDs) external view returns (uint total) {
1845         VestingEntries.VestingEntry memory entry;
1846         for (uint i = 0; i < entryIDs.length; i++) {
1847             entry = vestingSchedules(account, entryIDs[i]);
1848 
1849             /* Skip entry if escrowAmount == 0 */
1850             if (entry.escrowAmount != 0) {
1851                 uint256 quantity = _claimableAmount(entry);
1852 
1853                 /* add quantity to total */
1854                 total = total.add(quantity);
1855             }
1856         }
1857     }
1858 
1859     function getVestingEntryClaimable(address account, uint256 entryID) external view returns (uint) {
1860         return _claimableAmount(vestingSchedules(account, entryID));
1861     }
1862 
1863     function _claimableAmount(VestingEntries.VestingEntry memory _entry) internal view returns (uint256) {
1864         uint256 quantity;
1865         if (_entry.escrowAmount != 0) {
1866             /* Escrow amounts claimable if block.timestamp equal to or after entry endTime */
1867             quantity = block.timestamp >= _entry.endTime ? _entry.escrowAmount : 0;
1868         }
1869         return quantity;
1870     }
1871 
1872     /* ========== MUTATIVE FUNCTIONS ========== */
1873 
1874     /**
1875      * Vest escrowed amounts that are claimable
1876      * Allows users to vest their vesting entries based on msg.sender
1877      */
1878     function vest(uint256[] calldata entryIDs) external {
1879         // only account can call vest
1880         address account = msg.sender;
1881 
1882         uint256 total;
1883         VestingEntries.VestingEntry memory entry;
1884         uint256 quantity;
1885         for (uint i = 0; i < entryIDs.length; i++) {
1886             entry = vestingSchedules(account, entryIDs[i]);
1887 
1888             /* Skip entry if escrowAmount == 0 already vested */
1889             if (entry.escrowAmount != 0) {
1890                 quantity = _claimableAmount(entry);
1891 
1892                 /* update entry to remove escrowAmount */
1893                 if (quantity > 0) {
1894                     state().setZeroAmount(account, entryIDs[i]);
1895                 }
1896 
1897                 /* add quantity to total */
1898                 total = total.add(quantity);
1899             }
1900         }
1901 
1902         /* Transfer vested tokens. Will revert if total > totalEscrowedAccountBalance */
1903         if (total != 0) {
1904             _subtractAndTransfer(account, account, total);
1905             // update total vested
1906             state().updateVestedAccountBalance(account, SafeCast.toInt256(total));
1907             emit Vested(account, block.timestamp, total);
1908         }
1909     }
1910 
1911     /// method for revoking vesting entries regardless of schedule to be used for liquidations
1912     /// access controlled to only Synthetix contract
1913     /// @param account: account
1914     /// @param recipient: account to transfer the revoked tokens to
1915     /// @param targetAmount: amount of SNX to revoke, when this amount is reached, no more entries are revoked
1916     /// @param startIndex: index into accountVestingEntryIDs[account] to start iterating from
1917     function revokeFrom(
1918         address account,
1919         address recipient,
1920         uint targetAmount,
1921         uint startIndex
1922     ) external onlySynthetix {
1923         require(account != address(0), "account not set");
1924         require(recipient != address(0), "recipient not set");
1925 
1926         // set stored entries to zero
1927         (uint total, uint endIndex, uint lastEntryTime) =
1928             state().setZeroAmountUntilTarget(account, startIndex, targetAmount);
1929 
1930         // check total is indeed enough
1931         // the caller should have checked for the general amount of escrow
1932         // but only here we check that startIndex results in sufficient amount
1933         require(total >= targetAmount, "entries sum less than target");
1934 
1935         // if too much was revoked
1936         if (total > targetAmount) {
1937             // only take the precise amount needed by adding a new entry with the difference from total
1938             uint refund = total.sub(targetAmount);
1939             uint entryID =
1940                 state().addVestingEntry(
1941                     account,
1942                     VestingEntries.VestingEntry({endTime: uint64(lastEntryTime), escrowAmount: refund})
1943                 );
1944             // emit event
1945             uint duration = lastEntryTime > block.timestamp ? lastEntryTime.sub(block.timestamp) : 0;
1946             emit VestingEntryCreated(account, block.timestamp, refund, duration, entryID);
1947         }
1948 
1949         // update the aggregates and move the tokens
1950         _subtractAndTransfer(account, recipient, targetAmount);
1951 
1952         emit Revoked(account, recipient, targetAmount, startIndex, endIndex);
1953     }
1954 
1955     /// remove tokens from vesting aggregates and transfer them to recipient
1956     function _subtractAndTransfer(
1957         address subtractFrom,
1958         address transferTo,
1959         uint256 amount
1960     ) internal {
1961         state().updateEscrowAccountBalance(subtractFrom, -SafeCast.toInt256(amount));
1962         synthetixERC20().transfer(transferTo, amount);
1963     }
1964 
1965     /**
1966      * @notice Create an escrow entry to lock SNX for a given duration in seconds
1967      * @dev This call expects that the depositor (msg.sender) has already approved the Reward escrow contract
1968      to spend the the amount being escrowed.
1969      */
1970     function createEscrowEntry(
1971         address beneficiary,
1972         uint256 deposit,
1973         uint256 duration
1974     ) external {
1975         require(beneficiary != address(0), "Cannot create escrow with address(0)");
1976 
1977         /* Transfer SNX from msg.sender */
1978         require(synthetixERC20().transferFrom(msg.sender, address(this), deposit), "token transfer failed");
1979 
1980         /* Append vesting entry for the beneficiary address */
1981         _appendVestingEntry(beneficiary, deposit, duration);
1982     }
1983 
1984     /**
1985      * @notice Add a new vesting entry at a given time and quantity to an account's schedule.
1986      * @dev A call to this should accompany a previous successful call to synthetix.transfer(rewardEscrow, amount),
1987      * to ensure that when the funds are withdrawn, there is enough balance.
1988      * @param account The account to append a new vesting entry to.
1989      * @param quantity The quantity of SNX that will be escrowed.
1990      * @param duration The duration that SNX will be emitted.
1991      */
1992     function appendVestingEntry(
1993         address account,
1994         uint256 quantity,
1995         uint256 duration
1996     ) external onlyFeePool {
1997         _appendVestingEntry(account, quantity, duration);
1998     }
1999 
2000     function _appendVestingEntry(
2001         address account,
2002         uint256 quantity,
2003         uint256 duration
2004     ) internal {
2005         /* No empty or already-passed vesting entries allowed. */
2006         require(quantity != 0, "Quantity cannot be zero");
2007         require(duration > 0 && duration <= max_duration, "Cannot escrow with 0 duration OR above max_duration");
2008 
2009         // Add quantity to account's escrowed balance to the total balance
2010         state().updateEscrowAccountBalance(account, SafeCast.toInt256(quantity));
2011 
2012         /* There must be enough balance in the contract to provide for the vesting entry. */
2013         require(
2014             totalEscrowedBalance() <= synthetixERC20().balanceOf(address(this)),
2015             "Must be enough balance in the contract to provide for the vesting entry"
2016         );
2017 
2018         /* Escrow the tokens for duration. */
2019         uint endTime = block.timestamp + duration;
2020 
2021         // store vesting entry
2022         uint entryID =
2023             state().addVestingEntry(
2024                 account,
2025                 VestingEntries.VestingEntry({endTime: uint64(endTime), escrowAmount: quantity})
2026             );
2027 
2028         emit VestingEntryCreated(account, block.timestamp, quantity, duration, entryID);
2029     }
2030 
2031     /* ========== ACCOUNT MERGING ========== */
2032 
2033     function accountMergingIsOpen() public view returns (bool) {
2034         return accountMergingStartTime.add(accountMergingDuration) > block.timestamp;
2035     }
2036 
2037     function startMergingWindow() external onlyOwner {
2038         accountMergingStartTime = block.timestamp;
2039         emit AccountMergingStarted(accountMergingStartTime, accountMergingStartTime.add(accountMergingDuration));
2040     }
2041 
2042     function setAccountMergingDuration(uint256 duration) external onlyOwner {
2043         require(duration <= maxAccountMergingDuration, "exceeds max merging duration");
2044         accountMergingDuration = duration;
2045         emit AccountMergingDurationUpdated(duration);
2046     }
2047 
2048     function setMaxAccountMergingWindow(uint256 duration) external onlyOwner {
2049         maxAccountMergingDuration = duration;
2050         emit MaxAccountMergingDurationUpdated(duration);
2051     }
2052 
2053     function setMaxEscrowDuration(uint256 duration) external onlyOwner {
2054         max_duration = duration;
2055         emit MaxEscrowDurationUpdated(duration);
2056     }
2057 
2058     /* Nominate an account to merge escrow and vesting schedule */
2059     function nominateAccountToMerge(address account) external {
2060         require(account != msg.sender, "Cannot nominate own account to merge");
2061         require(accountMergingIsOpen(), "Account merging has ended");
2062         require(issuer().debtBalanceOf(msg.sender, "sUSD") == 0, "Cannot merge accounts with debt");
2063         nominatedReceiver[msg.sender] = account;
2064         emit NominateAccountToMerge(msg.sender, account);
2065     }
2066 
2067     function mergeAccount(address from, uint256[] calldata entryIDs) external {
2068         require(accountMergingIsOpen(), "Account merging has ended");
2069         require(issuer().debtBalanceOf(from, "sUSD") == 0, "Cannot merge accounts with debt");
2070         require(nominatedReceiver[from] == msg.sender, "Address is not nominated to merge");
2071         address to = msg.sender;
2072 
2073         uint256 totalEscrowAmountMerged;
2074         VestingEntries.VestingEntry memory entry;
2075         for (uint i = 0; i < entryIDs.length; i++) {
2076             // retrieve entry
2077             entry = vestingSchedules(from, entryIDs[i]);
2078 
2079             /* ignore vesting entries with zero escrowAmount */
2080             if (entry.escrowAmount != 0) {
2081                 // set previous entry amount to zero
2082                 state().setZeroAmount(from, entryIDs[i]);
2083 
2084                 // append new entry for recipient, the new entry will have new entryID
2085                 state().addVestingEntry(to, entry);
2086 
2087                 /* Add the escrowAmount of entry to the totalEscrowAmountMerged */
2088                 totalEscrowAmountMerged = totalEscrowAmountMerged.add(entry.escrowAmount);
2089             }
2090         }
2091 
2092         // remove from old account
2093         state().updateEscrowAccountBalance(from, -SafeCast.toInt256(totalEscrowAmountMerged));
2094         // add to recipient account
2095         state().updateEscrowAccountBalance(to, SafeCast.toInt256(totalEscrowAmountMerged));
2096 
2097         emit AccountMerged(from, to, totalEscrowAmountMerged, entryIDs, block.timestamp);
2098     }
2099 
2100     /* ========== MIGRATION OLD ESCROW ========== */
2101 
2102     function migrateVestingSchedule(address) external {
2103         _notImplemented();
2104     }
2105 
2106     function migrateAccountEscrowBalances(
2107         address[] calldata,
2108         uint256[] calldata,
2109         uint256[] calldata
2110     ) external {
2111         _notImplemented();
2112     }
2113 
2114     /* ========== L2 MIGRATION ========== */
2115 
2116     function burnForMigration(address, uint[] calldata) external returns (uint256, VestingEntries.VestingEntry[] memory) {
2117         _notImplemented();
2118     }
2119 
2120     function importVestingEntries(
2121         address,
2122         uint256,
2123         VestingEntries.VestingEntry[] calldata
2124     ) external {
2125         _notImplemented();
2126     }
2127 
2128     /* ========== MODIFIERS ========== */
2129     modifier onlyFeePool() {
2130         require(msg.sender == address(feePool()), "Only the FeePool can perform this action");
2131         _;
2132     }
2133 
2134     modifier onlySynthetix() {
2135         require(msg.sender == address(synthetixERC20()), "Only Synthetix");
2136         _;
2137     }
2138 
2139     /* ========== EVENTS ========== */
2140     event Vested(address indexed beneficiary, uint time, uint value);
2141     event VestingEntryCreated(address indexed beneficiary, uint time, uint value, uint duration, uint entryID);
2142     event MaxEscrowDurationUpdated(uint newDuration);
2143     event MaxAccountMergingDurationUpdated(uint newDuration);
2144     event AccountMergingDurationUpdated(uint newDuration);
2145     event AccountMergingStarted(uint time, uint endTime);
2146     event AccountMerged(
2147         address indexed accountToMerge,
2148         address destinationAddress,
2149         uint escrowAmountMerged,
2150         uint[] entryIDs,
2151         uint time
2152     );
2153     event NominateAccountToMerge(address indexed account, address destination);
2154     event Revoked(address indexed account, address indexed recipient, uint targetAmount, uint startIndex, uint endIndex);
2155 }
2156 
2157 
2158 // https://docs.synthetix.io/contracts/source/interfaces/irewardescrow
2159 interface IRewardEscrow {
2160     // Views
2161     function balanceOf(address account) external view returns (uint);
2162 
2163     function numVestingEntries(address account) external view returns (uint);
2164 
2165     function totalEscrowedAccountBalance(address account) external view returns (uint);
2166 
2167     function totalVestedAccountBalance(address account) external view returns (uint);
2168 
2169     function getVestingScheduleEntry(address account, uint index) external view returns (uint[2] memory);
2170 
2171     function getNextVestingIndex(address account) external view returns (uint);
2172 
2173     // Mutative functions
2174     function appendVestingEntry(address account, uint quantity) external;
2175 
2176     function vest() external;
2177 }
2178 
2179 
2180 // Inheritance
2181 
2182 
2183 // Internal references
2184 
2185 
2186 // https://docs.synthetix.io/contracts/RewardEscrow
2187 contract RewardEscrowV2 is BaseRewardEscrowV2 {
2188     /* ========== ADDRESS RESOLVER CONFIGURATION ========== */
2189 
2190     bytes32 private constant CONTRACT_SYNTHETIX_BRIDGE_OPTIMISM = "SynthetixBridgeToOptimism";
2191 
2192     /* ========== CONSTRUCTOR ========== */
2193 
2194     constructor(address _owner, address _resolver) public BaseRewardEscrowV2(_owner, _resolver) {}
2195 
2196     /* ========== VIEWS ======================= */
2197 
2198     function resolverAddressesRequired() public view returns (bytes32[] memory addresses) {
2199         bytes32[] memory existingAddresses = BaseRewardEscrowV2.resolverAddressesRequired();
2200         bytes32[] memory newAddresses = new bytes32[](1);
2201         newAddresses[0] = CONTRACT_SYNTHETIX_BRIDGE_OPTIMISM;
2202         return combineArrays(existingAddresses, newAddresses);
2203     }
2204 
2205     function synthetixBridgeToOptimism() internal view returns (address) {
2206         return requireAndGetAddress(CONTRACT_SYNTHETIX_BRIDGE_OPTIMISM);
2207     }
2208 
2209     /* ========== L2 MIGRATION ========== */
2210 
2211     function burnForMigration(address account, uint[] calldata entryIDs)
2212         external
2213         onlySynthetixBridge
2214         returns (uint256 escrowedAccountBalance, VestingEntries.VestingEntry[] memory vestingEntries)
2215     {
2216         require(entryIDs.length > 0, "Entry IDs required");
2217 
2218         vestingEntries = new VestingEntries.VestingEntry[](entryIDs.length);
2219 
2220         for (uint i = 0; i < entryIDs.length; i++) {
2221             VestingEntries.VestingEntry memory entry = vestingSchedules(account, entryIDs[i]);
2222 
2223             // only unvested
2224             if (entry.escrowAmount > 0) {
2225                 vestingEntries[i] = entry;
2226 
2227                 /* add the escrow amount to escrowedAccountBalance */
2228                 escrowedAccountBalance = escrowedAccountBalance.add(entry.escrowAmount);
2229 
2230                 /* Delete the vesting entry being migrated */
2231                 state().setZeroAmount(account, entryIDs[i]);
2232             }
2233         }
2234 
2235         /**
2236          *  update account total escrow balances for migration
2237          *  transfer the escrowed SNX being migrated to the L2 deposit contract
2238          */
2239         if (escrowedAccountBalance > 0) {
2240             state().updateEscrowAccountBalance(account, -SafeCast.toInt256(escrowedAccountBalance));
2241             synthetixERC20().transfer(synthetixBridgeToOptimism(), escrowedAccountBalance);
2242         }
2243 
2244         emit BurnedForMigrationToL2(account, entryIDs, escrowedAccountBalance, block.timestamp);
2245 
2246         return (escrowedAccountBalance, vestingEntries);
2247     }
2248 
2249     /* ========== MODIFIERS ========== */
2250 
2251     modifier onlySynthetixBridge() {
2252         require(msg.sender == synthetixBridgeToOptimism(), "Can only be invoked by SynthetixBridgeToOptimism contract");
2253         _;
2254     }
2255 
2256     /* ========== EVENTS ========== */
2257     event BurnedForMigrationToL2(address indexed account, uint[] entryIDs, uint escrowedAmountMigrated, uint time);
2258 }
2259 
2260     