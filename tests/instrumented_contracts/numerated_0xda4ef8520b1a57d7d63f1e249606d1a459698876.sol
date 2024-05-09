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
16 *	- Owned
17 * Libraries: 
18 *	- SafeDecimalMath
19 *	- SafeMath
20 *	- VestingEntries
21 *
22 * MIT License
23 * ===========
24 *
25 * Copyright (c) 2021 Synthetix
26 *
27 * Permission is hereby granted, free of charge, to any person obtaining a copy
28 * of this software and associated documentation files (the "Software"), to deal
29 * in the Software without restriction, including without limitation the rights
30 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
31 * copies of the Software, and to permit persons to whom the Software is
32 * furnished to do so, subject to the following conditions:
33 *
34 * The above copyright notice and this permission notice shall be included in all
35 * copies or substantial portions of the Software.
36 *
37 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
38 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
39 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
40 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
41 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
42 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
43 */
44 
45 
46 
47 pragma solidity ^0.5.16;
48 
49 
50 // https://docs.synthetix.io/contracts/source/contracts/owned
51 contract Owned {
52     address public owner;
53     address public nominatedOwner;
54 
55     constructor(address _owner) public {
56         require(_owner != address(0), "Owner address cannot be 0");
57         owner = _owner;
58         emit OwnerChanged(address(0), _owner);
59     }
60 
61     function nominateNewOwner(address _owner) external onlyOwner {
62         nominatedOwner = _owner;
63         emit OwnerNominated(_owner);
64     }
65 
66     function acceptOwnership() external {
67         require(msg.sender == nominatedOwner, "You must be nominated before you can accept ownership");
68         emit OwnerChanged(owner, nominatedOwner);
69         owner = nominatedOwner;
70         nominatedOwner = address(0);
71     }
72 
73     modifier onlyOwner {
74         _onlyOwner();
75         _;
76     }
77 
78     function _onlyOwner() private view {
79         require(msg.sender == owner, "Only the contract owner may perform this action");
80     }
81 
82     event OwnerNominated(address newOwner);
83     event OwnerChanged(address oldOwner, address newOwner);
84 }
85 
86 
87 // https://docs.synthetix.io/contracts/source/interfaces/iaddressresolver
88 interface IAddressResolver {
89     function getAddress(bytes32 name) external view returns (address);
90 
91     function getSynth(bytes32 key) external view returns (address);
92 
93     function requireAndGetAddress(bytes32 name, string calldata reason) external view returns (address);
94 }
95 
96 
97 // https://docs.synthetix.io/contracts/source/interfaces/isynth
98 interface ISynth {
99     // Views
100     function currencyKey() external view returns (bytes32);
101 
102     function transferableSynths(address account) external view returns (uint);
103 
104     // Mutative functions
105     function transferAndSettle(address to, uint value) external returns (bool);
106 
107     function transferFromAndSettle(
108         address from,
109         address to,
110         uint value
111     ) external returns (bool);
112 
113     // Restricted: used internally to Synthetix
114     function burn(address account, uint amount) external;
115 
116     function issue(address account, uint amount) external;
117 }
118 
119 
120 // https://docs.synthetix.io/contracts/source/interfaces/iissuer
121 interface IIssuer {
122     // Views
123     function anySynthOrSNXRateIsInvalid() external view returns (bool anyRateInvalid);
124 
125     function availableCurrencyKeys() external view returns (bytes32[] memory);
126 
127     function availableSynthCount() external view returns (uint);
128 
129     function availableSynths(uint index) external view returns (ISynth);
130 
131     function canBurnSynths(address account) external view returns (bool);
132 
133     function collateral(address account) external view returns (uint);
134 
135     function collateralisationRatio(address issuer) external view returns (uint);
136 
137     function collateralisationRatioAndAnyRatesInvalid(address _issuer)
138         external
139         view
140         returns (uint cratio, bool anyRateIsInvalid);
141 
142     function debtBalanceOf(address issuer, bytes32 currencyKey) external view returns (uint debtBalance);
143 
144     function issuanceRatio() external view returns (uint);
145 
146     function lastIssueEvent(address account) external view returns (uint);
147 
148     function maxIssuableSynths(address issuer) external view returns (uint maxIssuable);
149 
150     function minimumStakeTime() external view returns (uint);
151 
152     function remainingIssuableSynths(address issuer)
153         external
154         view
155         returns (
156             uint maxIssuable,
157             uint alreadyIssued,
158             uint totalSystemDebt
159         );
160 
161     function synths(bytes32 currencyKey) external view returns (ISynth);
162 
163     function getSynths(bytes32[] calldata currencyKeys) external view returns (ISynth[] memory);
164 
165     function synthsByAddress(address synthAddress) external view returns (bytes32);
166 
167     function totalIssuedSynths(bytes32 currencyKey, bool excludeEtherCollateral) external view returns (uint);
168 
169     function transferableSynthetixAndAnyRateIsInvalid(address account, uint balance)
170         external
171         view
172         returns (uint transferable, bool anyRateIsInvalid);
173 
174     // Restricted: used internally to Synthetix
175     function issueSynths(address from, uint amount) external;
176 
177     function issueSynthsOnBehalf(
178         address issueFor,
179         address from,
180         uint amount
181     ) external;
182 
183     function issueMaxSynths(address from) external;
184 
185     function issueMaxSynthsOnBehalf(address issueFor, address from) external;
186 
187     function burnSynths(address from, uint amount) external;
188 
189     function burnSynthsOnBehalf(
190         address burnForAddress,
191         address from,
192         uint amount
193     ) external;
194 
195     function burnSynthsToTarget(address from) external;
196 
197     function burnSynthsToTargetOnBehalf(address burnForAddress, address from) external;
198 
199     function liquidateDelinquentAccount(
200         address account,
201         uint susdAmount,
202         address liquidator
203     ) external returns (uint totalRedeemed, uint amountToLiquidate);
204 }
205 
206 
207 // Inheritance
208 
209 
210 // Internal references
211 
212 
213 // https://docs.synthetix.io/contracts/source/contracts/addressresolver
214 contract AddressResolver is Owned, IAddressResolver {
215     mapping(bytes32 => address) public repository;
216 
217     constructor(address _owner) public Owned(_owner) {}
218 
219     /* ========== RESTRICTED FUNCTIONS ========== */
220 
221     function importAddresses(bytes32[] calldata names, address[] calldata destinations) external onlyOwner {
222         require(names.length == destinations.length, "Input lengths must match");
223 
224         for (uint i = 0; i < names.length; i++) {
225             bytes32 name = names[i];
226             address destination = destinations[i];
227             repository[name] = destination;
228             emit AddressImported(name, destination);
229         }
230     }
231 
232     /* ========= PUBLIC FUNCTIONS ========== */
233 
234     function rebuildCaches(MixinResolver[] calldata destinations) external {
235         for (uint i = 0; i < destinations.length; i++) {
236             destinations[i].rebuildCache();
237         }
238     }
239 
240     /* ========== VIEWS ========== */
241 
242     function areAddressesImported(bytes32[] calldata names, address[] calldata destinations) external view returns (bool) {
243         for (uint i = 0; i < names.length; i++) {
244             if (repository[names[i]] != destinations[i]) {
245                 return false;
246             }
247         }
248         return true;
249     }
250 
251     function getAddress(bytes32 name) external view returns (address) {
252         return repository[name];
253     }
254 
255     function requireAndGetAddress(bytes32 name, string calldata reason) external view returns (address) {
256         address _foundAddress = repository[name];
257         require(_foundAddress != address(0), reason);
258         return _foundAddress;
259     }
260 
261     function getSynth(bytes32 key) external view returns (address) {
262         IIssuer issuer = IIssuer(repository["Issuer"]);
263         require(address(issuer) != address(0), "Cannot find Issuer address");
264         return address(issuer.synths(key));
265     }
266 
267     /* ========== EVENTS ========== */
268 
269     event AddressImported(bytes32 name, address destination);
270 }
271 
272 
273 // solhint-disable payable-fallback
274 
275 // https://docs.synthetix.io/contracts/source/contracts/readproxy
276 contract ReadProxy is Owned {
277     address public target;
278 
279     constructor(address _owner) public Owned(_owner) {}
280 
281     function setTarget(address _target) external onlyOwner {
282         target = _target;
283         emit TargetUpdated(target);
284     }
285 
286     function() external {
287         // The basics of a proxy read call
288         // Note that msg.sender in the underlying will always be the address of this contract.
289         assembly {
290             calldatacopy(0, 0, calldatasize)
291 
292             // Use of staticcall - this will revert if the underlying function mutates state
293             let result := staticcall(gas, sload(target_slot), 0, calldatasize, 0, 0)
294             returndatacopy(0, 0, returndatasize)
295 
296             if iszero(result) {
297                 revert(0, returndatasize)
298             }
299             return(0, returndatasize)
300         }
301     }
302 
303     event TargetUpdated(address newTarget);
304 }
305 
306 
307 // Inheritance
308 
309 
310 // Internal references
311 
312 
313 // https://docs.synthetix.io/contracts/source/contracts/mixinresolver
314 contract MixinResolver {
315     AddressResolver public resolver;
316 
317     mapping(bytes32 => address) private addressCache;
318 
319     constructor(address _resolver) internal {
320         resolver = AddressResolver(_resolver);
321     }
322 
323     /* ========== INTERNAL FUNCTIONS ========== */
324 
325     function combineArrays(bytes32[] memory first, bytes32[] memory second)
326         internal
327         pure
328         returns (bytes32[] memory combination)
329     {
330         combination = new bytes32[](first.length + second.length);
331 
332         for (uint i = 0; i < first.length; i++) {
333             combination[i] = first[i];
334         }
335 
336         for (uint j = 0; j < second.length; j++) {
337             combination[first.length + j] = second[j];
338         }
339     }
340 
341     /* ========== PUBLIC FUNCTIONS ========== */
342 
343     // Note: this function is public not external in order for it to be overridden and invoked via super in subclasses
344     function resolverAddressesRequired() public view returns (bytes32[] memory addresses) {}
345 
346     function rebuildCache() public {
347         bytes32[] memory requiredAddresses = resolverAddressesRequired();
348         // The resolver must call this function whenver it updates its state
349         for (uint i = 0; i < requiredAddresses.length; i++) {
350             bytes32 name = requiredAddresses[i];
351             // Note: can only be invoked once the resolver has all the targets needed added
352             address destination = resolver.requireAndGetAddress(
353                 name,
354                 string(abi.encodePacked("Resolver missing target: ", name))
355             );
356             addressCache[name] = destination;
357             emit CacheUpdated(name, destination);
358         }
359     }
360 
361     /* ========== VIEWS ========== */
362 
363     function isResolverCached() external view returns (bool) {
364         bytes32[] memory requiredAddresses = resolverAddressesRequired();
365         for (uint i = 0; i < requiredAddresses.length; i++) {
366             bytes32 name = requiredAddresses[i];
367             // false if our cache is invalid or if the resolver doesn't have the required address
368             if (resolver.getAddress(name) != addressCache[name] || addressCache[name] == address(0)) {
369                 return false;
370             }
371         }
372 
373         return true;
374     }
375 
376     /* ========== INTERNAL FUNCTIONS ========== */
377 
378     function requireAndGetAddress(bytes32 name) internal view returns (address) {
379         address _foundAddress = addressCache[name];
380         require(_foundAddress != address(0), string(abi.encodePacked("Missing address: ", name)));
381         return _foundAddress;
382     }
383 
384     /* ========== EVENTS ========== */
385 
386     event CacheUpdated(bytes32 name, address destination);
387 }
388 
389 
390 // https://docs.synthetix.io/contracts/source/contracts/limitedsetup
391 contract LimitedSetup {
392     uint public setupExpiryTime;
393 
394     /**
395      * @dev LimitedSetup Constructor.
396      * @param setupDuration The time the setup period will last for.
397      */
398     constructor(uint setupDuration) internal {
399         setupExpiryTime = now + setupDuration;
400     }
401 
402     modifier onlyDuringSetup {
403         require(now < setupExpiryTime, "Can only perform this action during setup");
404         _;
405     }
406 }
407 
408 
409 pragma experimental ABIEncoderV2;
410 
411 
412 library VestingEntries {
413     struct VestingEntry {
414         uint64 endTime;
415         uint256 escrowAmount;
416     }
417     struct VestingEntryWithID {
418         uint64 endTime;
419         uint256 escrowAmount;
420         uint256 entryID;
421     }
422 }
423 
424 
425 interface IRewardEscrowV2 {
426     // Views
427     function balanceOf(address account) external view returns (uint);
428 
429     function numVestingEntries(address account) external view returns (uint);
430 
431     function totalEscrowedAccountBalance(address account) external view returns (uint);
432 
433     function totalVestedAccountBalance(address account) external view returns (uint);
434 
435     function getVestingQuantity(address account, uint256[] calldata entryIDs) external view returns (uint);
436 
437     function getVestingSchedules(
438         address account,
439         uint256 index,
440         uint256 pageSize
441     ) external view returns (VestingEntries.VestingEntryWithID[] memory);
442 
443     function getAccountVestingEntryIDs(
444         address account,
445         uint256 index,
446         uint256 pageSize
447     ) external view returns (uint256[] memory);
448 
449     function getVestingEntryClaimable(address account, uint256 entryID) external view returns (uint);
450 
451     function getVestingEntry(address account, uint256 entryID) external view returns (uint64, uint256);
452 
453     // Mutative functions
454     function vest(uint256[] calldata entryIDs) external;
455 
456     function createEscrowEntry(
457         address beneficiary,
458         uint256 deposit,
459         uint256 duration
460     ) external;
461 
462     function appendVestingEntry(
463         address account,
464         uint256 quantity,
465         uint256 duration
466     ) external;
467 
468     function migrateVestingSchedule(address _addressToMigrate) external;
469 
470     function migrateAccountEscrowBalances(
471         address[] calldata accounts,
472         uint256[] calldata escrowBalances,
473         uint256[] calldata vestedBalances
474     ) external;
475 
476     // Account Merging
477     function startMergingWindow() external;
478 
479     function mergeAccount(address accountToMerge, uint256[] calldata entryIDs) external;
480 
481     function nominateAccountToMerge(address account) external;
482 
483     function accountMergingIsOpen() external view returns (bool);
484 
485     // L2 Migration
486     function importVestingEntries(
487         address account,
488         uint256 escrowedAmount,
489         VestingEntries.VestingEntry[] calldata vestingEntries
490     ) external;
491 
492     // Return amount of SNX transfered to SynthetixBridgeToOptimism deposit contract
493     function burnForMigration(address account, uint256[] calldata entryIDs)
494         external
495         returns (uint256 escrowedAccountBalance, VestingEntries.VestingEntry[] memory vestingEntries);
496 }
497 
498 
499 /**
500  * @dev Wrappers over Solidity's arithmetic operations with added overflow
501  * checks.
502  *
503  * Arithmetic operations in Solidity wrap on overflow. This can easily result
504  * in bugs, because programmers usually assume that an overflow raises an
505  * error, which is the standard behavior in high level programming languages.
506  * `SafeMath` restores this intuition by reverting the transaction when an
507  * operation overflows.
508  *
509  * Using this library instead of the unchecked operations eliminates an entire
510  * class of bugs, so it's recommended to use it always.
511  */
512 library SafeMath {
513     /**
514      * @dev Returns the addition of two unsigned integers, reverting on
515      * overflow.
516      *
517      * Counterpart to Solidity's `+` operator.
518      *
519      * Requirements:
520      * - Addition cannot overflow.
521      */
522     function add(uint256 a, uint256 b) internal pure returns (uint256) {
523         uint256 c = a + b;
524         require(c >= a, "SafeMath: addition overflow");
525 
526         return c;
527     }
528 
529     /**
530      * @dev Returns the subtraction of two unsigned integers, reverting on
531      * overflow (when the result is negative).
532      *
533      * Counterpart to Solidity's `-` operator.
534      *
535      * Requirements:
536      * - Subtraction cannot overflow.
537      */
538     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
539         require(b <= a, "SafeMath: subtraction overflow");
540         uint256 c = a - b;
541 
542         return c;
543     }
544 
545     /**
546      * @dev Returns the multiplication of two unsigned integers, reverting on
547      * overflow.
548      *
549      * Counterpart to Solidity's `*` operator.
550      *
551      * Requirements:
552      * - Multiplication cannot overflow.
553      */
554     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
555         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
556         // benefit is lost if 'b' is also tested.
557         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
558         if (a == 0) {
559             return 0;
560         }
561 
562         uint256 c = a * b;
563         require(c / a == b, "SafeMath: multiplication overflow");
564 
565         return c;
566     }
567 
568     /**
569      * @dev Returns the integer division of two unsigned integers. Reverts on
570      * division by zero. The result is rounded towards zero.
571      *
572      * Counterpart to Solidity's `/` operator. Note: this function uses a
573      * `revert` opcode (which leaves remaining gas untouched) while Solidity
574      * uses an invalid opcode to revert (consuming all remaining gas).
575      *
576      * Requirements:
577      * - The divisor cannot be zero.
578      */
579     function div(uint256 a, uint256 b) internal pure returns (uint256) {
580         // Solidity only automatically asserts when dividing by 0
581         require(b > 0, "SafeMath: division by zero");
582         uint256 c = a / b;
583         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
584 
585         return c;
586     }
587 
588     /**
589      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
590      * Reverts when dividing by zero.
591      *
592      * Counterpart to Solidity's `%` operator. This function uses a `revert`
593      * opcode (which leaves remaining gas untouched) while Solidity uses an
594      * invalid opcode to revert (consuming all remaining gas).
595      *
596      * Requirements:
597      * - The divisor cannot be zero.
598      */
599     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
600         require(b != 0, "SafeMath: modulo by zero");
601         return a % b;
602     }
603 }
604 
605 
606 // Libraries
607 
608 
609 // https://docs.synthetix.io/contracts/source/libraries/safedecimalmath
610 library SafeDecimalMath {
611     using SafeMath for uint;
612 
613     /* Number of decimal places in the representations. */
614     uint8 public constant decimals = 18;
615     uint8 public constant highPrecisionDecimals = 27;
616 
617     /* The number representing 1.0. */
618     uint public constant UNIT = 10**uint(decimals);
619 
620     /* The number representing 1.0 for higher fidelity numbers. */
621     uint public constant PRECISE_UNIT = 10**uint(highPrecisionDecimals);
622     uint private constant UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR = 10**uint(highPrecisionDecimals - decimals);
623 
624     /**
625      * @return Provides an interface to UNIT.
626      */
627     function unit() external pure returns (uint) {
628         return UNIT;
629     }
630 
631     /**
632      * @return Provides an interface to PRECISE_UNIT.
633      */
634     function preciseUnit() external pure returns (uint) {
635         return PRECISE_UNIT;
636     }
637 
638     /**
639      * @return The result of multiplying x and y, interpreting the operands as fixed-point
640      * decimals.
641      *
642      * @dev A unit factor is divided out after the product of x and y is evaluated,
643      * so that product must be less than 2**256. As this is an integer division,
644      * the internal division always rounds down. This helps save on gas. Rounding
645      * is more expensive on gas.
646      */
647     function multiplyDecimal(uint x, uint y) internal pure returns (uint) {
648         /* Divide by UNIT to remove the extra factor introduced by the product. */
649         return x.mul(y) / UNIT;
650     }
651 
652     /**
653      * @return The result of safely multiplying x and y, interpreting the operands
654      * as fixed-point decimals of the specified precision unit.
655      *
656      * @dev The operands should be in the form of a the specified unit factor which will be
657      * divided out after the product of x and y is evaluated, so that product must be
658      * less than 2**256.
659      *
660      * Unlike multiplyDecimal, this function rounds the result to the nearest increment.
661      * Rounding is useful when you need to retain fidelity for small decimal numbers
662      * (eg. small fractions or percentages).
663      */
664     function _multiplyDecimalRound(
665         uint x,
666         uint y,
667         uint precisionUnit
668     ) private pure returns (uint) {
669         /* Divide by UNIT to remove the extra factor introduced by the product. */
670         uint quotientTimesTen = x.mul(y) / (precisionUnit / 10);
671 
672         if (quotientTimesTen % 10 >= 5) {
673             quotientTimesTen += 10;
674         }
675 
676         return quotientTimesTen / 10;
677     }
678 
679     /**
680      * @return The result of safely multiplying x and y, interpreting the operands
681      * as fixed-point decimals of a precise unit.
682      *
683      * @dev The operands should be in the precise unit factor which will be
684      * divided out after the product of x and y is evaluated, so that product must be
685      * less than 2**256.
686      *
687      * Unlike multiplyDecimal, this function rounds the result to the nearest increment.
688      * Rounding is useful when you need to retain fidelity for small decimal numbers
689      * (eg. small fractions or percentages).
690      */
691     function multiplyDecimalRoundPrecise(uint x, uint y) internal pure returns (uint) {
692         return _multiplyDecimalRound(x, y, PRECISE_UNIT);
693     }
694 
695     /**
696      * @return The result of safely multiplying x and y, interpreting the operands
697      * as fixed-point decimals of a standard unit.
698      *
699      * @dev The operands should be in the standard unit factor which will be
700      * divided out after the product of x and y is evaluated, so that product must be
701      * less than 2**256.
702      *
703      * Unlike multiplyDecimal, this function rounds the result to the nearest increment.
704      * Rounding is useful when you need to retain fidelity for small decimal numbers
705      * (eg. small fractions or percentages).
706      */
707     function multiplyDecimalRound(uint x, uint y) internal pure returns (uint) {
708         return _multiplyDecimalRound(x, y, UNIT);
709     }
710 
711     /**
712      * @return The result of safely dividing x and y. The return value is a high
713      * precision decimal.
714      *
715      * @dev y is divided after the product of x and the standard precision unit
716      * is evaluated, so the product of x and UNIT must be less than 2**256. As
717      * this is an integer division, the result is always rounded down.
718      * This helps save on gas. Rounding is more expensive on gas.
719      */
720     function divideDecimal(uint x, uint y) internal pure returns (uint) {
721         /* Reintroduce the UNIT factor that will be divided out by y. */
722         return x.mul(UNIT).div(y);
723     }
724 
725     /**
726      * @return The result of safely dividing x and y. The return value is as a rounded
727      * decimal in the precision unit specified in the parameter.
728      *
729      * @dev y is divided after the product of x and the specified precision unit
730      * is evaluated, so the product of x and the specified precision unit must
731      * be less than 2**256. The result is rounded to the nearest increment.
732      */
733     function _divideDecimalRound(
734         uint x,
735         uint y,
736         uint precisionUnit
737     ) private pure returns (uint) {
738         uint resultTimesTen = x.mul(precisionUnit * 10).div(y);
739 
740         if (resultTimesTen % 10 >= 5) {
741             resultTimesTen += 10;
742         }
743 
744         return resultTimesTen / 10;
745     }
746 
747     /**
748      * @return The result of safely dividing x and y. The return value is as a rounded
749      * standard precision decimal.
750      *
751      * @dev y is divided after the product of x and the standard precision unit
752      * is evaluated, so the product of x and the standard precision unit must
753      * be less than 2**256. The result is rounded to the nearest increment.
754      */
755     function divideDecimalRound(uint x, uint y) internal pure returns (uint) {
756         return _divideDecimalRound(x, y, UNIT);
757     }
758 
759     /**
760      * @return The result of safely dividing x and y. The return value is as a rounded
761      * high precision decimal.
762      *
763      * @dev y is divided after the product of x and the high precision unit
764      * is evaluated, so the product of x and the high precision unit must
765      * be less than 2**256. The result is rounded to the nearest increment.
766      */
767     function divideDecimalRoundPrecise(uint x, uint y) internal pure returns (uint) {
768         return _divideDecimalRound(x, y, PRECISE_UNIT);
769     }
770 
771     /**
772      * @dev Convert a standard decimal representation to a high precision one.
773      */
774     function decimalToPreciseDecimal(uint i) internal pure returns (uint) {
775         return i.mul(UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR);
776     }
777 
778     /**
779      * @dev Convert a high precision decimal to a standard decimal representation.
780      */
781     function preciseDecimalToDecimal(uint i) internal pure returns (uint) {
782         uint quotientTimesTen = i / (UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR / 10);
783 
784         if (quotientTimesTen % 10 >= 5) {
785             quotientTimesTen += 10;
786         }
787 
788         return quotientTimesTen / 10;
789     }
790 }
791 
792 
793 // https://docs.synthetix.io/contracts/source/interfaces/ierc20
794 interface IERC20 {
795     // ERC20 Optional Views
796     function name() external view returns (string memory);
797 
798     function symbol() external view returns (string memory);
799 
800     function decimals() external view returns (uint8);
801 
802     // Views
803     function totalSupply() external view returns (uint);
804 
805     function balanceOf(address owner) external view returns (uint);
806 
807     function allowance(address owner, address spender) external view returns (uint);
808 
809     // Mutative functions
810     function transfer(address to, uint value) external returns (bool);
811 
812     function approve(address spender, uint value) external returns (bool);
813 
814     function transferFrom(
815         address from,
816         address to,
817         uint value
818     ) external returns (bool);
819 
820     // Events
821     event Transfer(address indexed from, address indexed to, uint value);
822 
823     event Approval(address indexed owner, address indexed spender, uint value);
824 }
825 
826 
827 // https://docs.synthetix.io/contracts/source/interfaces/ifeepool
828 interface IFeePool {
829     // Views
830 
831     // solhint-disable-next-line func-name-mixedcase
832     function FEE_ADDRESS() external view returns (address);
833 
834     function feesAvailable(address account) external view returns (uint, uint);
835 
836     function feePeriodDuration() external view returns (uint);
837 
838     function isFeesClaimable(address account) external view returns (bool);
839 
840     function targetThreshold() external view returns (uint);
841 
842     function totalFeesAvailable() external view returns (uint);
843 
844     function totalRewardsAvailable() external view returns (uint);
845 
846     // Mutative Functions
847     function claimFees() external returns (bool);
848 
849     function claimOnBehalf(address claimingForAddress) external returns (bool);
850 
851     function closeCurrentFeePeriod() external;
852 
853     // Restricted: used internally to Synthetix
854     function appendAccountIssuanceRecord(
855         address account,
856         uint lockedAmount,
857         uint debtEntryIndex
858     ) external;
859 
860     function recordFeePaid(uint sUSDAmount) external;
861 
862     function setRewardsToDistribute(uint amount) external;
863 }
864 
865 
866 interface IVirtualSynth {
867     // Views
868     function balanceOfUnderlying(address account) external view returns (uint);
869 
870     function rate() external view returns (uint);
871 
872     function readyToSettle() external view returns (bool);
873 
874     function secsLeftInWaitingPeriod() external view returns (uint);
875 
876     function settled() external view returns (bool);
877 
878     function synth() external view returns (ISynth);
879 
880     // Mutative functions
881     function settle(address account) external;
882 }
883 
884 
885 // https://docs.synthetix.io/contracts/source/interfaces/isynthetix
886 interface ISynthetix {
887     // Views
888     function anySynthOrSNXRateIsInvalid() external view returns (bool anyRateInvalid);
889 
890     function availableCurrencyKeys() external view returns (bytes32[] memory);
891 
892     function availableSynthCount() external view returns (uint);
893 
894     function availableSynths(uint index) external view returns (ISynth);
895 
896     function collateral(address account) external view returns (uint);
897 
898     function collateralisationRatio(address issuer) external view returns (uint);
899 
900     function debtBalanceOf(address issuer, bytes32 currencyKey) external view returns (uint);
901 
902     function isWaitingPeriod(bytes32 currencyKey) external view returns (bool);
903 
904     function maxIssuableSynths(address issuer) external view returns (uint maxIssuable);
905 
906     function remainingIssuableSynths(address issuer)
907         external
908         view
909         returns (
910             uint maxIssuable,
911             uint alreadyIssued,
912             uint totalSystemDebt
913         );
914 
915     function synths(bytes32 currencyKey) external view returns (ISynth);
916 
917     function synthsByAddress(address synthAddress) external view returns (bytes32);
918 
919     function totalIssuedSynths(bytes32 currencyKey) external view returns (uint);
920 
921     function totalIssuedSynthsExcludeEtherCollateral(bytes32 currencyKey) external view returns (uint);
922 
923     function transferableSynthetix(address account) external view returns (uint transferable);
924 
925     // Mutative Functions
926     function burnSynths(uint amount) external;
927 
928     function burnSynthsOnBehalf(address burnForAddress, uint amount) external;
929 
930     function burnSynthsToTarget() external;
931 
932     function burnSynthsToTargetOnBehalf(address burnForAddress) external;
933 
934     function exchange(
935         bytes32 sourceCurrencyKey,
936         uint sourceAmount,
937         bytes32 destinationCurrencyKey
938     ) external returns (uint amountReceived);
939 
940     function exchangeOnBehalf(
941         address exchangeForAddress,
942         bytes32 sourceCurrencyKey,
943         uint sourceAmount,
944         bytes32 destinationCurrencyKey
945     ) external returns (uint amountReceived);
946 
947     function exchangeWithTracking(
948         bytes32 sourceCurrencyKey,
949         uint sourceAmount,
950         bytes32 destinationCurrencyKey,
951         address originator,
952         bytes32 trackingCode
953     ) external returns (uint amountReceived);
954 
955     function exchangeOnBehalfWithTracking(
956         address exchangeForAddress,
957         bytes32 sourceCurrencyKey,
958         uint sourceAmount,
959         bytes32 destinationCurrencyKey,
960         address originator,
961         bytes32 trackingCode
962     ) external returns (uint amountReceived);
963 
964     function exchangeWithVirtual(
965         bytes32 sourceCurrencyKey,
966         uint sourceAmount,
967         bytes32 destinationCurrencyKey,
968         bytes32 trackingCode
969     ) external returns (uint amountReceived, IVirtualSynth vSynth);
970 
971     function issueMaxSynths() external;
972 
973     function issueMaxSynthsOnBehalf(address issueForAddress) external;
974 
975     function issueSynths(uint amount) external;
976 
977     function issueSynthsOnBehalf(address issueForAddress, uint amount) external;
978 
979     function mint() external returns (bool);
980 
981     function settle(bytes32 currencyKey)
982         external
983         returns (
984             uint reclaimed,
985             uint refunded,
986             uint numEntries
987         );
988 
989     // Liquidations
990     function liquidateDelinquentAccount(address account, uint susdAmount) external returns (bool);
991 
992     // Restricted Functions
993 
994     function mintSecondary(address account, uint amount) external;
995 
996     function mintSecondaryRewards(uint amount) external;
997 
998     function burnSecondary(address account, uint amount) external;
999 }
1000 
1001 
1002 // Inheritance
1003 
1004 
1005 // Libraries
1006 
1007 
1008 // Internal references
1009 
1010 
1011 // https://docs.synthetix.io/contracts/RewardEscrow
1012 contract BaseRewardEscrowV2 is Owned, IRewardEscrowV2, LimitedSetup(8 weeks), MixinResolver {
1013     using SafeMath for uint;
1014     using SafeDecimalMath for uint;
1015 
1016     mapping(address => mapping(uint256 => VestingEntries.VestingEntry)) public vestingSchedules;
1017 
1018     mapping(address => uint256[]) public accountVestingEntryIDs;
1019 
1020     /*Counter for new vesting entry ids. */
1021     uint256 public nextEntryId;
1022 
1023     /* An account's total escrowed synthetix balance to save recomputing this for fee extraction purposes. */
1024     mapping(address => uint256) public totalEscrowedAccountBalance;
1025 
1026     /* An account's total vested reward synthetix. */
1027     mapping(address => uint256) public totalVestedAccountBalance;
1028 
1029     /* Mapping of nominated address to recieve account merging */
1030     mapping(address => address) public nominatedReceiver;
1031 
1032     /* The total remaining escrowed balance, for verifying the actual synthetix balance of this contract against. */
1033     uint256 public totalEscrowedBalance;
1034 
1035     /* Max escrow duration */
1036     uint public max_duration = 2 * 52 weeks; // Default max 2 years duration
1037 
1038     /* Max account merging duration */
1039     uint public maxAccountMergingDuration = 4 weeks; // Default 4 weeks is max
1040 
1041     /* ========== ACCOUNT MERGING CONFIGURATION ========== */
1042 
1043     uint public accountMergingDuration = 1 weeks;
1044 
1045     uint public accountMergingStartTime;
1046 
1047     /* ========== ADDRESS RESOLVER CONFIGURATION ========== */
1048 
1049     bytes32 private constant CONTRACT_SYNTHETIX = "Synthetix";
1050     bytes32 private constant CONTRACT_ISSUER = "Issuer";
1051     bytes32 private constant CONTRACT_FEEPOOL = "FeePool";
1052 
1053     /* ========== CONSTRUCTOR ========== */
1054 
1055     constructor(address _owner, address _resolver) public Owned(_owner) MixinResolver(_resolver) {
1056         nextEntryId = 1;
1057     }
1058 
1059     /* ========== VIEWS ======================= */
1060 
1061     function feePool() internal view returns (IFeePool) {
1062         return IFeePool(requireAndGetAddress(CONTRACT_FEEPOOL));
1063     }
1064 
1065     function synthetix() internal view returns (ISynthetix) {
1066         return ISynthetix(requireAndGetAddress(CONTRACT_SYNTHETIX));
1067     }
1068 
1069     function issuer() internal view returns (IIssuer) {
1070         return IIssuer(requireAndGetAddress(CONTRACT_ISSUER));
1071     }
1072 
1073     function _notImplemented() internal pure {
1074         revert("Cannot be run on this layer");
1075     }
1076 
1077     /* ========== VIEW FUNCTIONS ========== */
1078 
1079     // Note: use public visibility so that it can be invoked in a subclass
1080     function resolverAddressesRequired() public view returns (bytes32[] memory addresses) {
1081         addresses = new bytes32[](3);
1082         addresses[0] = CONTRACT_SYNTHETIX;
1083         addresses[1] = CONTRACT_FEEPOOL;
1084         addresses[2] = CONTRACT_ISSUER;
1085     }
1086 
1087     /**
1088      * @notice A simple alias to totalEscrowedAccountBalance: provides ERC20 balance integration.
1089      */
1090     function balanceOf(address account) public view returns (uint) {
1091         return totalEscrowedAccountBalance[account];
1092     }
1093 
1094     /**
1095      * @notice The number of vesting dates in an account's schedule.
1096      */
1097     function numVestingEntries(address account) external view returns (uint) {
1098         return accountVestingEntryIDs[account].length;
1099     }
1100 
1101     /**
1102      * @notice Get a particular schedule entry for an account.
1103      * @return The vesting entry object and rate per second emission.
1104      */
1105     function getVestingEntry(address account, uint256 entryID) external view returns (uint64 endTime, uint256 escrowAmount) {
1106         endTime = vestingSchedules[account][entryID].endTime;
1107         escrowAmount = vestingSchedules[account][entryID].escrowAmount;
1108     }
1109 
1110     function getVestingSchedules(
1111         address account,
1112         uint256 index,
1113         uint256 pageSize
1114     ) external view returns (VestingEntries.VestingEntryWithID[] memory) {
1115         uint256 endIndex = index + pageSize;
1116 
1117         // If index starts after the endIndex return no results
1118         if (endIndex <= index) {
1119             return new VestingEntries.VestingEntryWithID[](0);
1120         }
1121 
1122         // If the page extends past the end of the accountVestingEntryIDs, truncate it.
1123         if (endIndex > accountVestingEntryIDs[account].length) {
1124             endIndex = accountVestingEntryIDs[account].length;
1125         }
1126 
1127         uint256 n = endIndex - index;
1128         VestingEntries.VestingEntryWithID[] memory vestingEntries = new VestingEntries.VestingEntryWithID[](n);
1129         for (uint256 i; i < n; i++) {
1130             uint256 entryID = accountVestingEntryIDs[account][i + index];
1131 
1132             VestingEntries.VestingEntry memory entry = vestingSchedules[account][entryID];
1133 
1134             vestingEntries[i] = VestingEntries.VestingEntryWithID({
1135                 endTime: uint64(entry.endTime),
1136                 escrowAmount: entry.escrowAmount,
1137                 entryID: entryID
1138             });
1139         }
1140         return vestingEntries;
1141     }
1142 
1143     function getAccountVestingEntryIDs(
1144         address account,
1145         uint256 index,
1146         uint256 pageSize
1147     ) external view returns (uint256[] memory) {
1148         uint256 endIndex = index + pageSize;
1149 
1150         // If the page extends past the end of the accountVestingEntryIDs, truncate it.
1151         if (endIndex > accountVestingEntryIDs[account].length) {
1152             endIndex = accountVestingEntryIDs[account].length;
1153         }
1154         if (endIndex <= index) {
1155             return new uint256[](0);
1156         }
1157 
1158         uint256 n = endIndex - index;
1159         uint256[] memory page = new uint256[](n);
1160         for (uint256 i; i < n; i++) {
1161             page[i] = accountVestingEntryIDs[account][i + index];
1162         }
1163         return page;
1164     }
1165 
1166     function getVestingQuantity(address account, uint256[] calldata entryIDs) external view returns (uint total) {
1167         for (uint i = 0; i < entryIDs.length; i++) {
1168             VestingEntries.VestingEntry memory entry = vestingSchedules[account][entryIDs[i]];
1169 
1170             /* Skip entry if escrowAmount == 0 */
1171             if (entry.escrowAmount != 0) {
1172                 uint256 quantity = _claimableAmount(entry);
1173 
1174                 /* add quantity to total */
1175                 total = total.add(quantity);
1176             }
1177         }
1178     }
1179 
1180     function getVestingEntryClaimable(address account, uint256 entryID) external view returns (uint) {
1181         VestingEntries.VestingEntry memory entry = vestingSchedules[account][entryID];
1182         return _claimableAmount(entry);
1183     }
1184 
1185     function _claimableAmount(VestingEntries.VestingEntry memory _entry) internal view returns (uint256) {
1186         uint256 quantity;
1187         if (_entry.escrowAmount != 0) {
1188             /* Escrow amounts claimable if block.timestamp equal to or after entry endTime */
1189             quantity = block.timestamp >= _entry.endTime ? _entry.escrowAmount : 0;
1190         }
1191         return quantity;
1192     }
1193 
1194     /* ========== MUTATIVE FUNCTIONS ========== */
1195 
1196     /**
1197      * Vest escrowed amounts that are claimable
1198      * Allows users to vest their vesting entries based on msg.sender
1199      */
1200 
1201     function vest(uint256[] calldata entryIDs) external {
1202         uint256 total;
1203         for (uint i = 0; i < entryIDs.length; i++) {
1204             VestingEntries.VestingEntry storage entry = vestingSchedules[msg.sender][entryIDs[i]];
1205 
1206             /* Skip entry if escrowAmount == 0 already vested */
1207             if (entry.escrowAmount != 0) {
1208                 uint256 quantity = _claimableAmount(entry);
1209 
1210                 /* update entry to remove escrowAmount */
1211                 if (quantity > 0) {
1212                     entry.escrowAmount = 0;
1213                 }
1214 
1215                 /* add quantity to total */
1216                 total = total.add(quantity);
1217             }
1218         }
1219 
1220         /* Transfer vested tokens. Will revert if total > totalEscrowedAccountBalance */
1221         if (total != 0) {
1222             _transferVestedTokens(msg.sender, total);
1223         }
1224     }
1225 
1226     /**
1227      * @notice Create an escrow entry to lock SNX for a given duration in seconds
1228      * @dev This call expects that the depositor (msg.sender) has already approved the Reward escrow contract
1229      to spend the the amount being escrowed.
1230      */
1231     function createEscrowEntry(
1232         address beneficiary,
1233         uint256 deposit,
1234         uint256 duration
1235     ) external {
1236         require(beneficiary != address(0), "Cannot create escrow with address(0)");
1237 
1238         /* Transfer SNX from msg.sender */
1239         require(IERC20(address(synthetix())).transferFrom(msg.sender, address(this), deposit), "token transfer failed");
1240 
1241         /* Append vesting entry for the beneficiary address */
1242         _appendVestingEntry(beneficiary, deposit, duration);
1243     }
1244 
1245     /**
1246      * @notice Add a new vesting entry at a given time and quantity to an account's schedule.
1247      * @dev A call to this should accompany a previous successful call to synthetix.transfer(rewardEscrow, amount),
1248      * to ensure that when the funds are withdrawn, there is enough balance.
1249      * @param account The account to append a new vesting entry to.
1250      * @param quantity The quantity of SNX that will be escrowed.
1251      * @param duration The duration that SNX will be emitted.
1252      */
1253     function appendVestingEntry(
1254         address account,
1255         uint256 quantity,
1256         uint256 duration
1257     ) external onlyFeePool {
1258         _appendVestingEntry(account, quantity, duration);
1259     }
1260 
1261     /* Transfer vested tokens and update totalEscrowedAccountBalance, totalVestedAccountBalance */
1262     function _transferVestedTokens(address _account, uint256 _amount) internal {
1263         _reduceAccountEscrowBalances(_account, _amount);
1264         totalVestedAccountBalance[_account] = totalVestedAccountBalance[_account].add(_amount);
1265         IERC20(address(synthetix())).transfer(_account, _amount);
1266         emit Vested(_account, block.timestamp, _amount);
1267     }
1268 
1269     function _reduceAccountEscrowBalances(address _account, uint256 _amount) internal {
1270         // Reverts if amount being vested is greater than the account's existing totalEscrowedAccountBalance
1271         totalEscrowedBalance = totalEscrowedBalance.sub(_amount);
1272         totalEscrowedAccountBalance[_account] = totalEscrowedAccountBalance[_account].sub(_amount);
1273     }
1274 
1275     /* ========== ACCOUNT MERGING ========== */
1276 
1277     function accountMergingIsOpen() public view returns (bool) {
1278         return accountMergingStartTime.add(accountMergingDuration) > block.timestamp;
1279     }
1280 
1281     function startMergingWindow() external onlyOwner {
1282         accountMergingStartTime = block.timestamp;
1283         emit AccountMergingStarted(accountMergingStartTime, accountMergingStartTime.add(accountMergingDuration));
1284     }
1285 
1286     function setAccountMergingDuration(uint256 duration) external onlyOwner {
1287         require(duration <= maxAccountMergingDuration, "exceeds max merging duration");
1288         accountMergingDuration = duration;
1289         emit AccountMergingDurationUpdated(duration);
1290     }
1291 
1292     function setMaxAccountMergingWindow(uint256 duration) external onlyOwner {
1293         maxAccountMergingDuration = duration;
1294         emit MaxAccountMergingDurationUpdated(duration);
1295     }
1296 
1297     function setMaxEscrowDuration(uint256 duration) external onlyOwner {
1298         max_duration = duration;
1299         emit MaxEscrowDurationUpdated(duration);
1300     }
1301 
1302     /* Nominate an account to merge escrow and vesting schedule */
1303     function nominateAccountToMerge(address account) external {
1304         require(account != msg.sender, "Cannot nominate own account to merge");
1305         require(accountMergingIsOpen(), "Account merging has ended");
1306         require(issuer().debtBalanceOf(msg.sender, "sUSD") == 0, "Cannot merge accounts with debt");
1307         nominatedReceiver[msg.sender] = account;
1308         emit NominateAccountToMerge(msg.sender, account);
1309     }
1310 
1311     function mergeAccount(address accountToMerge, uint256[] calldata entryIDs) external {
1312         require(accountMergingIsOpen(), "Account merging has ended");
1313         require(issuer().debtBalanceOf(accountToMerge, "sUSD") == 0, "Cannot merge accounts with debt");
1314         require(nominatedReceiver[accountToMerge] == msg.sender, "Address is not nominated to merge");
1315 
1316         uint256 totalEscrowAmountMerged;
1317         for (uint i = 0; i < entryIDs.length; i++) {
1318             // retrieve entry
1319             VestingEntries.VestingEntry memory entry = vestingSchedules[accountToMerge][entryIDs[i]];
1320 
1321             /* ignore vesting entries with zero escrowAmount */
1322             if (entry.escrowAmount != 0) {
1323                 /* copy entry to msg.sender (destination address) */
1324                 vestingSchedules[msg.sender][entryIDs[i]] = entry;
1325 
1326                 /* Add the escrowAmount of entry to the totalEscrowAmountMerged */
1327                 totalEscrowAmountMerged = totalEscrowAmountMerged.add(entry.escrowAmount);
1328 
1329                 /* append entryID to list of entries for account */
1330                 accountVestingEntryIDs[msg.sender].push(entryIDs[i]);
1331 
1332                 /* Delete entry from accountToMerge */
1333                 delete vestingSchedules[accountToMerge][entryIDs[i]];
1334             }
1335         }
1336 
1337         /* update totalEscrowedAccountBalance for merged account and accountToMerge */
1338         totalEscrowedAccountBalance[accountToMerge] = totalEscrowedAccountBalance[accountToMerge].sub(
1339             totalEscrowAmountMerged
1340         );
1341         totalEscrowedAccountBalance[msg.sender] = totalEscrowedAccountBalance[msg.sender].add(totalEscrowAmountMerged);
1342 
1343         emit AccountMerged(accountToMerge, msg.sender, totalEscrowAmountMerged, entryIDs, block.timestamp);
1344     }
1345 
1346     /* Internal function for importing vesting entry and creating new entry for escrow liquidations */
1347     function _addVestingEntry(address account, VestingEntries.VestingEntry memory entry) internal returns (uint) {
1348         uint entryID = nextEntryId;
1349         vestingSchedules[account][entryID] = entry;
1350 
1351         /* append entryID to list of entries for account */
1352         accountVestingEntryIDs[account].push(entryID);
1353 
1354         /* Increment the next entry id. */
1355         nextEntryId = nextEntryId.add(1);
1356 
1357         return entryID;
1358     }
1359 
1360     /* ========== MIGRATION OLD ESCROW ========== */
1361 
1362     function migrateVestingSchedule(address) external {
1363         _notImplemented();
1364     }
1365 
1366     function migrateAccountEscrowBalances(
1367         address[] calldata,
1368         uint256[] calldata,
1369         uint256[] calldata
1370     ) external {
1371         _notImplemented();
1372     }
1373 
1374     /* ========== L2 MIGRATION ========== */
1375 
1376     function burnForMigration(address, uint[] calldata) external returns (uint256, VestingEntries.VestingEntry[] memory) {
1377         _notImplemented();
1378     }
1379 
1380     function importVestingEntries(
1381         address,
1382         uint256,
1383         VestingEntries.VestingEntry[] calldata
1384     ) external {
1385         _notImplemented();
1386     }
1387 
1388     /* ========== INTERNALS ========== */
1389 
1390     function _appendVestingEntry(
1391         address account,
1392         uint256 quantity,
1393         uint256 duration
1394     ) internal {
1395         /* No empty or already-passed vesting entries allowed. */
1396         require(quantity != 0, "Quantity cannot be zero");
1397         require(duration > 0 && duration <= max_duration, "Cannot escrow with 0 duration OR above max_duration");
1398 
1399         /* There must be enough balance in the contract to provide for the vesting entry. */
1400         totalEscrowedBalance = totalEscrowedBalance.add(quantity);
1401 
1402         require(
1403             totalEscrowedBalance <= IERC20(address(synthetix())).balanceOf(address(this)),
1404             "Must be enough balance in the contract to provide for the vesting entry"
1405         );
1406 
1407         /* Escrow the tokens for duration. */
1408         uint endTime = block.timestamp + duration;
1409 
1410         /* Add quantity to account's escrowed balance */
1411         totalEscrowedAccountBalance[account] = totalEscrowedAccountBalance[account].add(quantity);
1412 
1413         uint entryID = nextEntryId;
1414         vestingSchedules[account][entryID] = VestingEntries.VestingEntry({endTime: uint64(endTime), escrowAmount: quantity});
1415 
1416         accountVestingEntryIDs[account].push(entryID);
1417 
1418         /* Increment the next entry id. */
1419         nextEntryId = nextEntryId.add(1);
1420 
1421         emit VestingEntryCreated(account, block.timestamp, quantity, duration, entryID);
1422     }
1423 
1424     /* ========== MODIFIERS ========== */
1425     modifier onlyFeePool() {
1426         require(msg.sender == address(feePool()), "Only the FeePool can perform this action");
1427         _;
1428     }
1429 
1430     /* ========== EVENTS ========== */
1431     event Vested(address indexed beneficiary, uint time, uint value);
1432     event VestingEntryCreated(address indexed beneficiary, uint time, uint value, uint duration, uint entryID);
1433     event MaxEscrowDurationUpdated(uint newDuration);
1434     event MaxAccountMergingDurationUpdated(uint newDuration);
1435     event AccountMergingDurationUpdated(uint newDuration);
1436     event AccountMergingStarted(uint time, uint endTime);
1437     event AccountMerged(
1438         address indexed accountToMerge,
1439         address destinationAddress,
1440         uint escrowAmountMerged,
1441         uint[] entryIDs,
1442         uint time
1443     );
1444     event NominateAccountToMerge(address indexed account, address destination);
1445 }
1446 
1447 
1448 // https://docs.synthetix.io/contracts/source/interfaces/irewardescrow
1449 interface IRewardEscrow {
1450     // Views
1451     function balanceOf(address account) external view returns (uint);
1452 
1453     function numVestingEntries(address account) external view returns (uint);
1454 
1455     function totalEscrowedAccountBalance(address account) external view returns (uint);
1456 
1457     function totalVestedAccountBalance(address account) external view returns (uint);
1458 
1459     function getVestingScheduleEntry(address account, uint index) external view returns (uint[2] memory);
1460 
1461     function getNextVestingIndex(address account) external view returns (uint);
1462 
1463     // Mutative functions
1464     function appendVestingEntry(address account, uint quantity) external;
1465 
1466     function vest() external;
1467 }
1468 
1469 
1470 // https://docs.synthetix.io/contracts/source/interfaces/isystemstatus
1471 interface ISystemStatus {
1472     struct Status {
1473         bool canSuspend;
1474         bool canResume;
1475     }
1476 
1477     struct Suspension {
1478         bool suspended;
1479         // reason is an integer code,
1480         // 0 => no reason, 1 => upgrading, 2+ => defined by system usage
1481         uint248 reason;
1482     }
1483 
1484     // Views
1485     function accessControl(bytes32 section, address account) external view returns (bool canSuspend, bool canResume);
1486 
1487     function requireSystemActive() external view;
1488 
1489     function requireIssuanceActive() external view;
1490 
1491     function requireExchangeActive() external view;
1492 
1493     function requireSynthActive(bytes32 currencyKey) external view;
1494 
1495     function requireSynthsActive(bytes32 sourceCurrencyKey, bytes32 destinationCurrencyKey) external view;
1496 
1497     function synthSuspension(bytes32 currencyKey) external view returns (bool suspended, uint248 reason);
1498 
1499     // Restricted functions
1500     function suspendSynth(bytes32 currencyKey, uint256 reason) external;
1501 
1502     function updateAccessControl(
1503         bytes32 section,
1504         address account,
1505         bool canSuspend,
1506         bool canResume
1507     ) external;
1508 }
1509 
1510 
1511 // Inheritance
1512 
1513 
1514 // Internal references
1515 
1516 
1517 // https://docs.synthetix.io/contracts/RewardEscrow
1518 contract RewardEscrowV2 is BaseRewardEscrowV2 {
1519     mapping(address => uint256) public totalBalancePendingMigration;
1520 
1521     uint public migrateEntriesThresholdAmount = SafeDecimalMath.unit() * 1000; // Default 1000 SNX
1522 
1523     /* ========== ADDRESS RESOLVER CONFIGURATION ========== */
1524 
1525     bytes32 private constant CONTRACT_SYNTHETIX_BRIDGE_OPTIMISM = "SynthetixBridgeToOptimism";
1526     bytes32 private constant CONTRACT_REWARD_ESCROW = "RewardEscrow";
1527     bytes32 private constant CONTRACT_SYSTEMSTATUS = "SystemStatus";
1528 
1529     /* ========== CONSTRUCTOR ========== */
1530 
1531     constructor(address _owner, address _resolver) public BaseRewardEscrowV2(_owner, _resolver) {}
1532 
1533     /* ========== VIEWS ======================= */
1534 
1535     function resolverAddressesRequired() public view returns (bytes32[] memory addresses) {
1536         bytes32[] memory existingAddresses = BaseRewardEscrowV2.resolverAddressesRequired();
1537         bytes32[] memory newAddresses = new bytes32[](3);
1538         newAddresses[0] = CONTRACT_SYNTHETIX_BRIDGE_OPTIMISM;
1539         newAddresses[1] = CONTRACT_REWARD_ESCROW;
1540         newAddresses[2] = CONTRACT_SYSTEMSTATUS;
1541         return combineArrays(existingAddresses, newAddresses);
1542     }
1543 
1544     function synthetixBridgeToOptimism() internal view returns (address) {
1545         return requireAndGetAddress(CONTRACT_SYNTHETIX_BRIDGE_OPTIMISM);
1546     }
1547 
1548     function oldRewardEscrow() internal view returns (IRewardEscrow) {
1549         return IRewardEscrow(requireAndGetAddress(CONTRACT_REWARD_ESCROW));
1550     }
1551 
1552     function systemStatus() internal view returns (ISystemStatus) {
1553         return ISystemStatus(requireAndGetAddress(CONTRACT_SYSTEMSTATUS));
1554     }
1555 
1556     /* ========== OLD ESCROW LOOKUP ========== */
1557 
1558     uint internal constant TIME_INDEX = 0;
1559     uint internal constant QUANTITY_INDEX = 1;
1560 
1561     /* ========== MIGRATION OLD ESCROW ========== */
1562 
1563     /* Threshold amount for migrating escrow entries from old RewardEscrow */
1564     function setMigrateEntriesThresholdAmount(uint amount) external onlyOwner {
1565         migrateEntriesThresholdAmount = amount;
1566         emit MigrateEntriesThresholdAmountUpdated(amount);
1567     }
1568 
1569     /* Function to allow any address to migrate vesting entries from previous reward escrow */
1570     function migrateVestingSchedule(address addressToMigrate) external systemActive {
1571         /* Ensure account escrow balance pending migration is not zero */
1572         /* Ensure account escrowed balance is not zero - should have been migrated */
1573         require(totalBalancePendingMigration[addressToMigrate] > 0, "No escrow migration pending");
1574         require(totalEscrowedAccountBalance[addressToMigrate] > 0, "Address escrow balance is 0");
1575 
1576         /* Add a vestable entry for addresses with totalBalancePendingMigration <= migrateEntriesThreshold amount of SNX */
1577         if (totalBalancePendingMigration[addressToMigrate] <= migrateEntriesThresholdAmount) {
1578             _importVestingEntry(
1579                 addressToMigrate,
1580                 VestingEntries.VestingEntry({
1581                     endTime: uint64(block.timestamp),
1582                     escrowAmount: totalBalancePendingMigration[addressToMigrate]
1583                 })
1584             );
1585 
1586             /* Remove totalBalancePendingMigration[addressToMigrate] */
1587             delete totalBalancePendingMigration[addressToMigrate];
1588         } else {
1589             uint numEntries = oldRewardEscrow().numVestingEntries(addressToMigrate);
1590 
1591             /* iterate and migrate old escrow schedules from rewardEscrow.vestingSchedules
1592              * starting from the last entry in each staker's vestingSchedules
1593              */
1594             for (uint i = 1; i <= numEntries; i++) {
1595                 uint[2] memory vestingSchedule = oldRewardEscrow().getVestingScheduleEntry(addressToMigrate, numEntries - i);
1596 
1597                 uint time = vestingSchedule[TIME_INDEX];
1598                 uint amount = vestingSchedule[QUANTITY_INDEX];
1599 
1600                 /* The list is sorted, when we reach the first entry that can be vested stop */
1601                 if (time < block.timestamp) {
1602                     break;
1603                 }
1604 
1605                 /* import vesting entry */
1606                 _importVestingEntry(
1607                     addressToMigrate,
1608                     VestingEntries.VestingEntry({endTime: uint64(time), escrowAmount: amount})
1609                 );
1610 
1611                 /* subtract amount from totalBalancePendingMigration - reverts if insufficient */
1612                 totalBalancePendingMigration[addressToMigrate] = totalBalancePendingMigration[addressToMigrate].sub(amount);
1613             }
1614         }
1615     }
1616 
1617     /**
1618      * Import function for owner to import vesting schedule
1619      * All entries imported should have past their vesting timestamp and will be ready to be vested
1620      * Addresses with totalEscrowedAccountBalance == 0 will not be migrated as they have all vested
1621      */
1622     function importVestingSchedule(address[] calldata accounts, uint256[] calldata escrowAmounts)
1623         external
1624         onlyDuringSetup
1625         onlyOwner
1626     {
1627         require(accounts.length == escrowAmounts.length, "Account and escrowAmounts Length mismatch");
1628 
1629         for (uint i = 0; i < accounts.length; i++) {
1630             address addressToMigrate = accounts[i];
1631             uint256 escrowAmount = escrowAmounts[i];
1632 
1633             // ensure account have escrow migration pending
1634             require(totalEscrowedAccountBalance[addressToMigrate] > 0, "Address escrow balance is 0");
1635             require(totalBalancePendingMigration[addressToMigrate] > 0, "No escrow migration pending");
1636 
1637             /* Import vesting entry with endTime as block.timestamp and escrowAmount */
1638             _importVestingEntry(
1639                 addressToMigrate,
1640                 VestingEntries.VestingEntry({endTime: uint64(block.timestamp), escrowAmount: escrowAmount})
1641             );
1642 
1643             /* update totalBalancePendingMigration - reverts if escrowAmount > remaining balance to migrate */
1644             totalBalancePendingMigration[addressToMigrate] = totalBalancePendingMigration[addressToMigrate].sub(
1645                 escrowAmount
1646             );
1647 
1648             emit ImportedVestingSchedule(addressToMigrate, block.timestamp, escrowAmount);
1649         }
1650     }
1651 
1652     /**
1653      * Migration for owner to migrate escrowed and vested account balances
1654      * Addresses with totalEscrowedAccountBalance == 0 will not be migrated as they have all vested
1655      */
1656     function migrateAccountEscrowBalances(
1657         address[] calldata accounts,
1658         uint256[] calldata escrowBalances,
1659         uint256[] calldata vestedBalances
1660     ) external onlyDuringSetup onlyOwner {
1661         require(accounts.length == escrowBalances.length, "Number of accounts and balances don't match");
1662         require(accounts.length == vestedBalances.length, "Number of accounts and vestedBalances don't match");
1663 
1664         for (uint i = 0; i < accounts.length; i++) {
1665             address account = accounts[i];
1666             uint escrowedAmount = escrowBalances[i];
1667             uint vestedAmount = vestedBalances[i];
1668 
1669             // ensure account doesn't have escrow migration pending / being imported more than once
1670             require(totalBalancePendingMigration[account] == 0, "Account migration is pending already");
1671 
1672             /* Update totalEscrowedBalance for tracking the Synthetix balance of this contract. */
1673             totalEscrowedBalance = totalEscrowedBalance.add(escrowedAmount);
1674 
1675             /* Update totalEscrowedAccountBalance and totalVestedAccountBalance for each account */
1676             totalEscrowedAccountBalance[account] = totalEscrowedAccountBalance[account].add(escrowedAmount);
1677             totalVestedAccountBalance[account] = totalVestedAccountBalance[account].add(vestedAmount);
1678 
1679             /* update totalBalancePendingMigration for account */
1680             totalBalancePendingMigration[account] = escrowedAmount;
1681 
1682             emit MigratedAccountEscrow(account, escrowedAmount, vestedAmount, now);
1683         }
1684     }
1685 
1686     /* Internal function to add entry to vestingSchedules and emit event */
1687     function _importVestingEntry(address account, VestingEntries.VestingEntry memory entry) internal {
1688         /* add vesting entry to account and assign an entryID to it */
1689         uint entryID = BaseRewardEscrowV2._addVestingEntry(account, entry);
1690 
1691         emit ImportedVestingEntry(account, entryID, entry.escrowAmount, entry.endTime);
1692     }
1693 
1694     /* ========== L2 MIGRATION ========== */
1695 
1696     function burnForMigration(address account, uint[] calldata entryIDs)
1697         external
1698         onlySynthetixBridge
1699         returns (uint256 escrowedAccountBalance, VestingEntries.VestingEntry[] memory vestingEntries)
1700     {
1701         require(entryIDs.length > 0, "Entry IDs required");
1702 
1703         vestingEntries = new VestingEntries.VestingEntry[](entryIDs.length);
1704 
1705         for (uint i = 0; i < entryIDs.length; i++) {
1706             VestingEntries.VestingEntry storage entry = vestingSchedules[account][entryIDs[i]];
1707 
1708             if (entry.escrowAmount > 0) {
1709                 vestingEntries[i] = entry;
1710 
1711                 /* add the escrow amount to escrowedAccountBalance */
1712                 escrowedAccountBalance = escrowedAccountBalance.add(entry.escrowAmount);
1713 
1714                 /* Delete the vesting entry being migrated */
1715                 delete vestingSchedules[account][entryIDs[i]];
1716             }
1717         }
1718 
1719         /**
1720          *  update account total escrow balances for migration
1721          *  transfer the escrowed SNX being migrated to the L2 deposit contract
1722          */
1723         if (escrowedAccountBalance > 0) {
1724             _reduceAccountEscrowBalances(account, escrowedAccountBalance);
1725             IERC20(address(synthetix())).transfer(synthetixBridgeToOptimism(), escrowedAccountBalance);
1726         }
1727 
1728         emit BurnedForMigrationToL2(account, entryIDs, escrowedAccountBalance, block.timestamp);
1729 
1730         return (escrowedAccountBalance, vestingEntries);
1731     }
1732 
1733     /* ========== MODIFIERS ========== */
1734 
1735     modifier onlySynthetixBridge() {
1736         require(msg.sender == synthetixBridgeToOptimism(), "Can only be invoked by SynthetixBridgeToOptimism contract");
1737         _;
1738     }
1739 
1740     modifier systemActive() {
1741         systemStatus().requireSystemActive();
1742         _;
1743     }
1744 
1745     /* ========== EVENTS ========== */
1746     event MigratedAccountEscrow(address indexed account, uint escrowedAmount, uint vestedAmount, uint time);
1747     event ImportedVestingSchedule(address indexed account, uint time, uint escrowAmount);
1748     event BurnedForMigrationToL2(address indexed account, uint[] entryIDs, uint escrowedAmountMigrated, uint time);
1749     event ImportedVestingEntry(address indexed account, uint entryID, uint escrowAmount, uint endTime);
1750     event MigrateEntriesThresholdAmountUpdated(uint newAmount);
1751 }
1752 
1753     