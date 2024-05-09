1 /*
2    ____            __   __        __   _
3   / __/__ __ ___  / /_ / /  ___  / /_ (_)__ __
4  _\ \ / // // _ \/ __// _ \/ -_)/ __// / \ \ /
5 /___/ \_, //_//_/\__//_//_/\__/ \__//_/ /_\_\
6      /___/
7 
8 * Synthetix: DebtCache.sol
9 *
10 * Latest source (may be newer): https://github.com/Synthetixio/synthetix/blob/master/contracts/DebtCache.sol
11 * Docs: https://docs.synthetix.io/contracts/DebtCache
12 *
13 * Contract Dependencies: 
14 *	- BaseDebtCache
15 *	- IAddressResolver
16 *	- IDebtCache
17 *	- MixinResolver
18 *	- MixinSystemSettings
19 *	- Owned
20 * Libraries: 
21 *	- SafeDecimalMath
22 *	- SafeMath
23 *
24 * MIT License
25 * ===========
26 *
27 * Copyright (c) 2022 Synthetix
28 *
29 * Permission is hereby granted, free of charge, to any person obtaining a copy
30 * of this software and associated documentation files (the "Software"), to deal
31 * in the Software without restriction, including without limitation the rights
32 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
33 * copies of the Software, and to permit persons to whom the Software is
34 * furnished to do so, subject to the following conditions:
35 *
36 * The above copyright notice and this permission notice shall be included in all
37 * copies or substantial portions of the Software.
38 *
39 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
40 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
41 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
42 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
43 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
44 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
45 */
46 
47 
48 
49 pragma solidity ^0.5.0;
50 
51 /**
52  * @dev Wrappers over Solidity's arithmetic operations with added overflow
53  * checks.
54  *
55  * Arithmetic operations in Solidity wrap on overflow. This can easily result
56  * in bugs, because programmers usually assume that an overflow raises an
57  * error, which is the standard behavior in high level programming languages.
58  * `SafeMath` restores this intuition by reverting the transaction when an
59  * operation overflows.
60  *
61  * Using this library instead of the unchecked operations eliminates an entire
62  * class of bugs, so it's recommended to use it always.
63  */
64 library SafeMath {
65     /**
66      * @dev Returns the addition of two unsigned integers, reverting on
67      * overflow.
68      *
69      * Counterpart to Solidity's `+` operator.
70      *
71      * Requirements:
72      * - Addition cannot overflow.
73      */
74     function add(uint256 a, uint256 b) internal pure returns (uint256) {
75         uint256 c = a + b;
76         require(c >= a, "SafeMath: addition overflow");
77 
78         return c;
79     }
80 
81     /**
82      * @dev Returns the subtraction of two unsigned integers, reverting on
83      * overflow (when the result is negative).
84      *
85      * Counterpart to Solidity's `-` operator.
86      *
87      * Requirements:
88      * - Subtraction cannot overflow.
89      */
90     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
91         require(b <= a, "SafeMath: subtraction overflow");
92         uint256 c = a - b;
93 
94         return c;
95     }
96 
97     /**
98      * @dev Returns the multiplication of two unsigned integers, reverting on
99      * overflow.
100      *
101      * Counterpart to Solidity's `*` operator.
102      *
103      * Requirements:
104      * - Multiplication cannot overflow.
105      */
106     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
107         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
108         // benefit is lost if 'b' is also tested.
109         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
110         if (a == 0) {
111             return 0;
112         }
113 
114         uint256 c = a * b;
115         require(c / a == b, "SafeMath: multiplication overflow");
116 
117         return c;
118     }
119 
120     /**
121      * @dev Returns the integer division of two unsigned integers. Reverts on
122      * division by zero. The result is rounded towards zero.
123      *
124      * Counterpart to Solidity's `/` operator. Note: this function uses a
125      * `revert` opcode (which leaves remaining gas untouched) while Solidity
126      * uses an invalid opcode to revert (consuming all remaining gas).
127      *
128      * Requirements:
129      * - The divisor cannot be zero.
130      */
131     function div(uint256 a, uint256 b) internal pure returns (uint256) {
132         // Solidity only automatically asserts when dividing by 0
133         require(b > 0, "SafeMath: division by zero");
134         uint256 c = a / b;
135         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
136 
137         return c;
138     }
139 
140     /**
141      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
142      * Reverts when dividing by zero.
143      *
144      * Counterpart to Solidity's `%` operator. This function uses a `revert`
145      * opcode (which leaves remaining gas untouched) while Solidity uses an
146      * invalid opcode to revert (consuming all remaining gas).
147      *
148      * Requirements:
149      * - The divisor cannot be zero.
150      */
151     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
152         require(b != 0, "SafeMath: modulo by zero");
153         return a % b;
154     }
155 }
156 
157 
158 // Libraries
159 
160 
161 // https://docs.synthetix.io/contracts/source/libraries/safedecimalmath
162 library SafeDecimalMath {
163     using SafeMath for uint;
164 
165     /* Number of decimal places in the representations. */
166     uint8 public constant decimals = 18;
167     uint8 public constant highPrecisionDecimals = 27;
168 
169     /* The number representing 1.0. */
170     uint public constant UNIT = 10**uint(decimals);
171 
172     /* The number representing 1.0 for higher fidelity numbers. */
173     uint public constant PRECISE_UNIT = 10**uint(highPrecisionDecimals);
174     uint private constant UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR = 10**uint(highPrecisionDecimals - decimals);
175 
176     /**
177      * @return Provides an interface to UNIT.
178      */
179     function unit() external pure returns (uint) {
180         return UNIT;
181     }
182 
183     /**
184      * @return Provides an interface to PRECISE_UNIT.
185      */
186     function preciseUnit() external pure returns (uint) {
187         return PRECISE_UNIT;
188     }
189 
190     /**
191      * @return The result of multiplying x and y, interpreting the operands as fixed-point
192      * decimals.
193      *
194      * @dev A unit factor is divided out after the product of x and y is evaluated,
195      * so that product must be less than 2**256. As this is an integer division,
196      * the internal division always rounds down. This helps save on gas. Rounding
197      * is more expensive on gas.
198      */
199     function multiplyDecimal(uint x, uint y) internal pure returns (uint) {
200         /* Divide by UNIT to remove the extra factor introduced by the product. */
201         return x.mul(y) / UNIT;
202     }
203 
204     /**
205      * @return The result of safely multiplying x and y, interpreting the operands
206      * as fixed-point decimals of the specified precision unit.
207      *
208      * @dev The operands should be in the form of a the specified unit factor which will be
209      * divided out after the product of x and y is evaluated, so that product must be
210      * less than 2**256.
211      *
212      * Unlike multiplyDecimal, this function rounds the result to the nearest increment.
213      * Rounding is useful when you need to retain fidelity for small decimal numbers
214      * (eg. small fractions or percentages).
215      */
216     function _multiplyDecimalRound(
217         uint x,
218         uint y,
219         uint precisionUnit
220     ) private pure returns (uint) {
221         /* Divide by UNIT to remove the extra factor introduced by the product. */
222         uint quotientTimesTen = x.mul(y) / (precisionUnit / 10);
223 
224         if (quotientTimesTen % 10 >= 5) {
225             quotientTimesTen += 10;
226         }
227 
228         return quotientTimesTen / 10;
229     }
230 
231     /**
232      * @return The result of safely multiplying x and y, interpreting the operands
233      * as fixed-point decimals of a precise unit.
234      *
235      * @dev The operands should be in the precise unit factor which will be
236      * divided out after the product of x and y is evaluated, so that product must be
237      * less than 2**256.
238      *
239      * Unlike multiplyDecimal, this function rounds the result to the nearest increment.
240      * Rounding is useful when you need to retain fidelity for small decimal numbers
241      * (eg. small fractions or percentages).
242      */
243     function multiplyDecimalRoundPrecise(uint x, uint y) internal pure returns (uint) {
244         return _multiplyDecimalRound(x, y, PRECISE_UNIT);
245     }
246 
247     /**
248      * @return The result of safely multiplying x and y, interpreting the operands
249      * as fixed-point decimals of a standard unit.
250      *
251      * @dev The operands should be in the standard unit factor which will be
252      * divided out after the product of x and y is evaluated, so that product must be
253      * less than 2**256.
254      *
255      * Unlike multiplyDecimal, this function rounds the result to the nearest increment.
256      * Rounding is useful when you need to retain fidelity for small decimal numbers
257      * (eg. small fractions or percentages).
258      */
259     function multiplyDecimalRound(uint x, uint y) internal pure returns (uint) {
260         return _multiplyDecimalRound(x, y, UNIT);
261     }
262 
263     /**
264      * @return The result of safely dividing x and y. The return value is a high
265      * precision decimal.
266      *
267      * @dev y is divided after the product of x and the standard precision unit
268      * is evaluated, so the product of x and UNIT must be less than 2**256. As
269      * this is an integer division, the result is always rounded down.
270      * This helps save on gas. Rounding is more expensive on gas.
271      */
272     function divideDecimal(uint x, uint y) internal pure returns (uint) {
273         /* Reintroduce the UNIT factor that will be divided out by y. */
274         return x.mul(UNIT).div(y);
275     }
276 
277     /**
278      * @return The result of safely dividing x and y. The return value is as a rounded
279      * decimal in the precision unit specified in the parameter.
280      *
281      * @dev y is divided after the product of x and the specified precision unit
282      * is evaluated, so the product of x and the specified precision unit must
283      * be less than 2**256. The result is rounded to the nearest increment.
284      */
285     function _divideDecimalRound(
286         uint x,
287         uint y,
288         uint precisionUnit
289     ) private pure returns (uint) {
290         uint resultTimesTen = x.mul(precisionUnit * 10).div(y);
291 
292         if (resultTimesTen % 10 >= 5) {
293             resultTimesTen += 10;
294         }
295 
296         return resultTimesTen / 10;
297     }
298 
299     /**
300      * @return The result of safely dividing x and y. The return value is as a rounded
301      * standard precision decimal.
302      *
303      * @dev y is divided after the product of x and the standard precision unit
304      * is evaluated, so the product of x and the standard precision unit must
305      * be less than 2**256. The result is rounded to the nearest increment.
306      */
307     function divideDecimalRound(uint x, uint y) internal pure returns (uint) {
308         return _divideDecimalRound(x, y, UNIT);
309     }
310 
311     /**
312      * @return The result of safely dividing x and y. The return value is as a rounded
313      * high precision decimal.
314      *
315      * @dev y is divided after the product of x and the high precision unit
316      * is evaluated, so the product of x and the high precision unit must
317      * be less than 2**256. The result is rounded to the nearest increment.
318      */
319     function divideDecimalRoundPrecise(uint x, uint y) internal pure returns (uint) {
320         return _divideDecimalRound(x, y, PRECISE_UNIT);
321     }
322 
323     /**
324      * @dev Convert a standard decimal representation to a high precision one.
325      */
326     function decimalToPreciseDecimal(uint i) internal pure returns (uint) {
327         return i.mul(UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR);
328     }
329 
330     /**
331      * @dev Convert a high precision decimal to a standard decimal representation.
332      */
333     function preciseDecimalToDecimal(uint i) internal pure returns (uint) {
334         uint quotientTimesTen = i / (UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR / 10);
335 
336         if (quotientTimesTen % 10 >= 5) {
337             quotientTimesTen += 10;
338         }
339 
340         return quotientTimesTen / 10;
341     }
342 
343     // Computes `a - b`, setting the value to 0 if b > a.
344     function floorsub(uint a, uint b) internal pure returns (uint) {
345         return b >= a ? 0 : a - b;
346     }
347 
348     /* ---------- Utilities ---------- */
349     /*
350      * Absolute value of the input, returned as a signed number.
351      */
352     function signedAbs(int x) internal pure returns (int) {
353         return x < 0 ? -x : x;
354     }
355 
356     /*
357      * Absolute value of the input, returned as an unsigned number.
358      */
359     function abs(int x) internal pure returns (uint) {
360         return uint(signedAbs(x));
361     }
362 }
363 
364 
365 // https://docs.synthetix.io/contracts/source/contracts/owned
366 contract Owned {
367     address public owner;
368     address public nominatedOwner;
369 
370     constructor(address _owner) public {
371         require(_owner != address(0), "Owner address cannot be 0");
372         owner = _owner;
373         emit OwnerChanged(address(0), _owner);
374     }
375 
376     function nominateNewOwner(address _owner) external onlyOwner {
377         nominatedOwner = _owner;
378         emit OwnerNominated(_owner);
379     }
380 
381     function acceptOwnership() external {
382         require(msg.sender == nominatedOwner, "You must be nominated before you can accept ownership");
383         emit OwnerChanged(owner, nominatedOwner);
384         owner = nominatedOwner;
385         nominatedOwner = address(0);
386     }
387 
388     modifier onlyOwner {
389         _onlyOwner();
390         _;
391     }
392 
393     function _onlyOwner() private view {
394         require(msg.sender == owner, "Only the contract owner may perform this action");
395     }
396 
397     event OwnerNominated(address newOwner);
398     event OwnerChanged(address oldOwner, address newOwner);
399 }
400 
401 
402 // https://docs.synthetix.io/contracts/source/interfaces/iaddressresolver
403 interface IAddressResolver {
404     function getAddress(bytes32 name) external view returns (address);
405 
406     function getSynth(bytes32 key) external view returns (address);
407 
408     function requireAndGetAddress(bytes32 name, string calldata reason) external view returns (address);
409 }
410 
411 
412 // https://docs.synthetix.io/contracts/source/interfaces/isynth
413 interface ISynth {
414     // Views
415     function currencyKey() external view returns (bytes32);
416 
417     function transferableSynths(address account) external view returns (uint);
418 
419     // Mutative functions
420     function transferAndSettle(address to, uint value) external returns (bool);
421 
422     function transferFromAndSettle(
423         address from,
424         address to,
425         uint value
426     ) external returns (bool);
427 
428     // Restricted: used internally to Synthetix
429     function burn(address account, uint amount) external;
430 
431     function issue(address account, uint amount) external;
432 }
433 
434 
435 // https://docs.synthetix.io/contracts/source/interfaces/iissuer
436 interface IIssuer {
437     // Views
438     function anySynthOrSNXRateIsInvalid() external view returns (bool anyRateInvalid);
439 
440     function availableCurrencyKeys() external view returns (bytes32[] memory);
441 
442     function availableSynthCount() external view returns (uint);
443 
444     function availableSynths(uint index) external view returns (ISynth);
445 
446     function canBurnSynths(address account) external view returns (bool);
447 
448     function collateral(address account) external view returns (uint);
449 
450     function collateralisationRatio(address issuer) external view returns (uint);
451 
452     function collateralisationRatioAndAnyRatesInvalid(address _issuer)
453         external
454         view
455         returns (uint cratio, bool anyRateIsInvalid);
456 
457     function debtBalanceOf(address issuer, bytes32 currencyKey) external view returns (uint debtBalance);
458 
459     function issuanceRatio() external view returns (uint);
460 
461     function lastIssueEvent(address account) external view returns (uint);
462 
463     function maxIssuableSynths(address issuer) external view returns (uint maxIssuable);
464 
465     function minimumStakeTime() external view returns (uint);
466 
467     function remainingIssuableSynths(address issuer)
468         external
469         view
470         returns (
471             uint maxIssuable,
472             uint alreadyIssued,
473             uint totalSystemDebt
474         );
475 
476     function synths(bytes32 currencyKey) external view returns (ISynth);
477 
478     function getSynths(bytes32[] calldata currencyKeys) external view returns (ISynth[] memory);
479 
480     function synthsByAddress(address synthAddress) external view returns (bytes32);
481 
482     function totalIssuedSynths(bytes32 currencyKey, bool excludeOtherCollateral) external view returns (uint);
483 
484     function transferableSynthetixAndAnyRateIsInvalid(address account, uint balance)
485         external
486         view
487         returns (uint transferable, bool anyRateIsInvalid);
488 
489     // Restricted: used internally to Synthetix
490     function issueSynths(address from, uint amount) external;
491 
492     function issueSynthsOnBehalf(
493         address issueFor,
494         address from,
495         uint amount
496     ) external;
497 
498     function issueMaxSynths(address from) external;
499 
500     function issueMaxSynthsOnBehalf(address issueFor, address from) external;
501 
502     function burnSynths(address from, uint amount) external;
503 
504     function burnSynthsOnBehalf(
505         address burnForAddress,
506         address from,
507         uint amount
508     ) external;
509 
510     function burnSynthsToTarget(address from) external;
511 
512     function burnSynthsToTargetOnBehalf(address burnForAddress, address from) external;
513 
514     function burnForRedemption(
515         address deprecatedSynthProxy,
516         address account,
517         uint balance
518     ) external;
519 
520     function liquidateDelinquentAccount(
521         address account,
522         uint susdAmount,
523         address liquidator
524     ) external returns (uint totalRedeemed, uint amountToLiquidate);
525 
526     function setCurrentPeriodId(uint128 periodId) external;
527 }
528 
529 
530 // Inheritance
531 
532 
533 // Internal references
534 
535 
536 // https://docs.synthetix.io/contracts/source/contracts/addressresolver
537 contract AddressResolver is Owned, IAddressResolver {
538     mapping(bytes32 => address) public repository;
539 
540     constructor(address _owner) public Owned(_owner) {}
541 
542     /* ========== RESTRICTED FUNCTIONS ========== */
543 
544     function importAddresses(bytes32[] calldata names, address[] calldata destinations) external onlyOwner {
545         require(names.length == destinations.length, "Input lengths must match");
546 
547         for (uint i = 0; i < names.length; i++) {
548             bytes32 name = names[i];
549             address destination = destinations[i];
550             repository[name] = destination;
551             emit AddressImported(name, destination);
552         }
553     }
554 
555     /* ========= PUBLIC FUNCTIONS ========== */
556 
557     function rebuildCaches(MixinResolver[] calldata destinations) external {
558         for (uint i = 0; i < destinations.length; i++) {
559             destinations[i].rebuildCache();
560         }
561     }
562 
563     /* ========== VIEWS ========== */
564 
565     function areAddressesImported(bytes32[] calldata names, address[] calldata destinations) external view returns (bool) {
566         for (uint i = 0; i < names.length; i++) {
567             if (repository[names[i]] != destinations[i]) {
568                 return false;
569             }
570         }
571         return true;
572     }
573 
574     function getAddress(bytes32 name) external view returns (address) {
575         return repository[name];
576     }
577 
578     function requireAndGetAddress(bytes32 name, string calldata reason) external view returns (address) {
579         address _foundAddress = repository[name];
580         require(_foundAddress != address(0), reason);
581         return _foundAddress;
582     }
583 
584     function getSynth(bytes32 key) external view returns (address) {
585         IIssuer issuer = IIssuer(repository["Issuer"]);
586         require(address(issuer) != address(0), "Cannot find Issuer address");
587         return address(issuer.synths(key));
588     }
589 
590     /* ========== EVENTS ========== */
591 
592     event AddressImported(bytes32 name, address destination);
593 }
594 
595 
596 // Internal references
597 
598 
599 // https://docs.synthetix.io/contracts/source/contracts/mixinresolver
600 contract MixinResolver {
601     AddressResolver public resolver;
602 
603     mapping(bytes32 => address) private addressCache;
604 
605     constructor(address _resolver) internal {
606         resolver = AddressResolver(_resolver);
607     }
608 
609     /* ========== INTERNAL FUNCTIONS ========== */
610 
611     function combineArrays(bytes32[] memory first, bytes32[] memory second)
612         internal
613         pure
614         returns (bytes32[] memory combination)
615     {
616         combination = new bytes32[](first.length + second.length);
617 
618         for (uint i = 0; i < first.length; i++) {
619             combination[i] = first[i];
620         }
621 
622         for (uint j = 0; j < second.length; j++) {
623             combination[first.length + j] = second[j];
624         }
625     }
626 
627     /* ========== PUBLIC FUNCTIONS ========== */
628 
629     // Note: this function is public not external in order for it to be overridden and invoked via super in subclasses
630     function resolverAddressesRequired() public view returns (bytes32[] memory addresses) {}
631 
632     function rebuildCache() public {
633         bytes32[] memory requiredAddresses = resolverAddressesRequired();
634         // The resolver must call this function whenver it updates its state
635         for (uint i = 0; i < requiredAddresses.length; i++) {
636             bytes32 name = requiredAddresses[i];
637             // Note: can only be invoked once the resolver has all the targets needed added
638             address destination =
639                 resolver.requireAndGetAddress(name, string(abi.encodePacked("Resolver missing target: ", name)));
640             addressCache[name] = destination;
641             emit CacheUpdated(name, destination);
642         }
643     }
644 
645     /* ========== VIEWS ========== */
646 
647     function isResolverCached() external view returns (bool) {
648         bytes32[] memory requiredAddresses = resolverAddressesRequired();
649         for (uint i = 0; i < requiredAddresses.length; i++) {
650             bytes32 name = requiredAddresses[i];
651             // false if our cache is invalid or if the resolver doesn't have the required address
652             if (resolver.getAddress(name) != addressCache[name] || addressCache[name] == address(0)) {
653                 return false;
654             }
655         }
656 
657         return true;
658     }
659 
660     /* ========== INTERNAL FUNCTIONS ========== */
661 
662     function requireAndGetAddress(bytes32 name) internal view returns (address) {
663         address _foundAddress = addressCache[name];
664         require(_foundAddress != address(0), string(abi.encodePacked("Missing address: ", name)));
665         return _foundAddress;
666     }
667 
668     /* ========== EVENTS ========== */
669 
670     event CacheUpdated(bytes32 name, address destination);
671 }
672 
673 
674 // https://docs.synthetix.io/contracts/source/interfaces/iflexiblestorage
675 interface IFlexibleStorage {
676     // Views
677     function getUIntValue(bytes32 contractName, bytes32 record) external view returns (uint);
678 
679     function getUIntValues(bytes32 contractName, bytes32[] calldata records) external view returns (uint[] memory);
680 
681     function getIntValue(bytes32 contractName, bytes32 record) external view returns (int);
682 
683     function getIntValues(bytes32 contractName, bytes32[] calldata records) external view returns (int[] memory);
684 
685     function getAddressValue(bytes32 contractName, bytes32 record) external view returns (address);
686 
687     function getAddressValues(bytes32 contractName, bytes32[] calldata records) external view returns (address[] memory);
688 
689     function getBoolValue(bytes32 contractName, bytes32 record) external view returns (bool);
690 
691     function getBoolValues(bytes32 contractName, bytes32[] calldata records) external view returns (bool[] memory);
692 
693     function getBytes32Value(bytes32 contractName, bytes32 record) external view returns (bytes32);
694 
695     function getBytes32Values(bytes32 contractName, bytes32[] calldata records) external view returns (bytes32[] memory);
696 
697     // Mutative functions
698     function deleteUIntValue(bytes32 contractName, bytes32 record) external;
699 
700     function deleteIntValue(bytes32 contractName, bytes32 record) external;
701 
702     function deleteAddressValue(bytes32 contractName, bytes32 record) external;
703 
704     function deleteBoolValue(bytes32 contractName, bytes32 record) external;
705 
706     function deleteBytes32Value(bytes32 contractName, bytes32 record) external;
707 
708     function setUIntValue(
709         bytes32 contractName,
710         bytes32 record,
711         uint value
712     ) external;
713 
714     function setUIntValues(
715         bytes32 contractName,
716         bytes32[] calldata records,
717         uint[] calldata values
718     ) external;
719 
720     function setIntValue(
721         bytes32 contractName,
722         bytes32 record,
723         int value
724     ) external;
725 
726     function setIntValues(
727         bytes32 contractName,
728         bytes32[] calldata records,
729         int[] calldata values
730     ) external;
731 
732     function setAddressValue(
733         bytes32 contractName,
734         bytes32 record,
735         address value
736     ) external;
737 
738     function setAddressValues(
739         bytes32 contractName,
740         bytes32[] calldata records,
741         address[] calldata values
742     ) external;
743 
744     function setBoolValue(
745         bytes32 contractName,
746         bytes32 record,
747         bool value
748     ) external;
749 
750     function setBoolValues(
751         bytes32 contractName,
752         bytes32[] calldata records,
753         bool[] calldata values
754     ) external;
755 
756     function setBytes32Value(
757         bytes32 contractName,
758         bytes32 record,
759         bytes32 value
760     ) external;
761 
762     function setBytes32Values(
763         bytes32 contractName,
764         bytes32[] calldata records,
765         bytes32[] calldata values
766     ) external;
767 }
768 
769 
770 // Internal references
771 
772 
773 // https://docs.synthetix.io/contracts/source/contracts/mixinsystemsettings
774 contract MixinSystemSettings is MixinResolver {
775     // must match the one defined SystemSettingsLib, defined in both places due to sol v0.5 limitations
776     bytes32 internal constant SETTING_CONTRACT_NAME = "SystemSettings";
777 
778     bytes32 internal constant SETTING_WAITING_PERIOD_SECS = "waitingPeriodSecs";
779     bytes32 internal constant SETTING_PRICE_DEVIATION_THRESHOLD_FACTOR = "priceDeviationThresholdFactor";
780     bytes32 internal constant SETTING_ISSUANCE_RATIO = "issuanceRatio";
781     bytes32 internal constant SETTING_FEE_PERIOD_DURATION = "feePeriodDuration";
782     bytes32 internal constant SETTING_TARGET_THRESHOLD = "targetThreshold";
783     bytes32 internal constant SETTING_LIQUIDATION_DELAY = "liquidationDelay";
784     bytes32 internal constant SETTING_LIQUIDATION_RATIO = "liquidationRatio";
785     bytes32 internal constant SETTING_LIQUIDATION_PENALTY = "liquidationPenalty";
786     bytes32 internal constant SETTING_RATE_STALE_PERIOD = "rateStalePeriod";
787     /* ========== Exchange Fees Related ========== */
788     bytes32 internal constant SETTING_EXCHANGE_FEE_RATE = "exchangeFeeRate";
789     bytes32 internal constant SETTING_EXCHANGE_DYNAMIC_FEE_THRESHOLD = "exchangeDynamicFeeThreshold";
790     bytes32 internal constant SETTING_EXCHANGE_DYNAMIC_FEE_WEIGHT_DECAY = "exchangeDynamicFeeWeightDecay";
791     bytes32 internal constant SETTING_EXCHANGE_DYNAMIC_FEE_ROUNDS = "exchangeDynamicFeeRounds";
792     bytes32 internal constant SETTING_EXCHANGE_MAX_DYNAMIC_FEE = "exchangeMaxDynamicFee";
793     /* ========== End Exchange Fees Related ========== */
794     bytes32 internal constant SETTING_MINIMUM_STAKE_TIME = "minimumStakeTime";
795     bytes32 internal constant SETTING_AGGREGATOR_WARNING_FLAGS = "aggregatorWarningFlags";
796     bytes32 internal constant SETTING_TRADING_REWARDS_ENABLED = "tradingRewardsEnabled";
797     bytes32 internal constant SETTING_DEBT_SNAPSHOT_STALE_TIME = "debtSnapshotStaleTime";
798     bytes32 internal constant SETTING_CROSS_DOMAIN_DEPOSIT_GAS_LIMIT = "crossDomainDepositGasLimit";
799     bytes32 internal constant SETTING_CROSS_DOMAIN_ESCROW_GAS_LIMIT = "crossDomainEscrowGasLimit";
800     bytes32 internal constant SETTING_CROSS_DOMAIN_REWARD_GAS_LIMIT = "crossDomainRewardGasLimit";
801     bytes32 internal constant SETTING_CROSS_DOMAIN_WITHDRAWAL_GAS_LIMIT = "crossDomainWithdrawalGasLimit";
802     bytes32 internal constant SETTING_CROSS_DOMAIN_FEE_PERIOD_CLOSE_GAS_LIMIT = "crossDomainCloseGasLimit";
803     bytes32 internal constant SETTING_CROSS_DOMAIN_RELAY_GAS_LIMIT = "crossDomainRelayGasLimit";
804     bytes32 internal constant SETTING_ETHER_WRAPPER_MAX_ETH = "etherWrapperMaxETH";
805     bytes32 internal constant SETTING_ETHER_WRAPPER_MINT_FEE_RATE = "etherWrapperMintFeeRate";
806     bytes32 internal constant SETTING_ETHER_WRAPPER_BURN_FEE_RATE = "etherWrapperBurnFeeRate";
807     bytes32 internal constant SETTING_WRAPPER_MAX_TOKEN_AMOUNT = "wrapperMaxTokens";
808     bytes32 internal constant SETTING_WRAPPER_MINT_FEE_RATE = "wrapperMintFeeRate";
809     bytes32 internal constant SETTING_WRAPPER_BURN_FEE_RATE = "wrapperBurnFeeRate";
810     bytes32 internal constant SETTING_INTERACTION_DELAY = "interactionDelay";
811     bytes32 internal constant SETTING_COLLAPSE_FEE_RATE = "collapseFeeRate";
812     bytes32 internal constant SETTING_ATOMIC_MAX_VOLUME_PER_BLOCK = "atomicMaxVolumePerBlock";
813     bytes32 internal constant SETTING_ATOMIC_TWAP_WINDOW = "atomicTwapWindow";
814     bytes32 internal constant SETTING_ATOMIC_EQUIVALENT_FOR_DEX_PRICING = "atomicEquivalentForDexPricing";
815     bytes32 internal constant SETTING_ATOMIC_EXCHANGE_FEE_RATE = "atomicExchangeFeeRate";
816     bytes32 internal constant SETTING_ATOMIC_PRICE_BUFFER = "atomicPriceBuffer";
817     bytes32 internal constant SETTING_ATOMIC_VOLATILITY_CONSIDERATION_WINDOW = "atomicVolConsiderationWindow";
818     bytes32 internal constant SETTING_ATOMIC_VOLATILITY_UPDATE_THRESHOLD = "atomicVolUpdateThreshold";
819 
820     bytes32 internal constant CONTRACT_FLEXIBLESTORAGE = "FlexibleStorage";
821 
822     enum CrossDomainMessageGasLimits {Deposit, Escrow, Reward, Withdrawal, CloseFeePeriod, Relay}
823 
824     struct DynamicFeeConfig {
825         uint threshold;
826         uint weightDecay;
827         uint rounds;
828         uint maxFee;
829     }
830 
831     constructor(address _resolver) internal MixinResolver(_resolver) {}
832 
833     function resolverAddressesRequired() public view returns (bytes32[] memory addresses) {
834         addresses = new bytes32[](1);
835         addresses[0] = CONTRACT_FLEXIBLESTORAGE;
836     }
837 
838     function flexibleStorage() internal view returns (IFlexibleStorage) {
839         return IFlexibleStorage(requireAndGetAddress(CONTRACT_FLEXIBLESTORAGE));
840     }
841 
842     function _getGasLimitSetting(CrossDomainMessageGasLimits gasLimitType) internal pure returns (bytes32) {
843         if (gasLimitType == CrossDomainMessageGasLimits.Deposit) {
844             return SETTING_CROSS_DOMAIN_DEPOSIT_GAS_LIMIT;
845         } else if (gasLimitType == CrossDomainMessageGasLimits.Escrow) {
846             return SETTING_CROSS_DOMAIN_ESCROW_GAS_LIMIT;
847         } else if (gasLimitType == CrossDomainMessageGasLimits.Reward) {
848             return SETTING_CROSS_DOMAIN_REWARD_GAS_LIMIT;
849         } else if (gasLimitType == CrossDomainMessageGasLimits.Withdrawal) {
850             return SETTING_CROSS_DOMAIN_WITHDRAWAL_GAS_LIMIT;
851         } else if (gasLimitType == CrossDomainMessageGasLimits.Relay) {
852             return SETTING_CROSS_DOMAIN_RELAY_GAS_LIMIT;
853         } else if (gasLimitType == CrossDomainMessageGasLimits.CloseFeePeriod) {
854             return SETTING_CROSS_DOMAIN_FEE_PERIOD_CLOSE_GAS_LIMIT;
855         } else {
856             revert("Unknown gas limit type");
857         }
858     }
859 
860     function getCrossDomainMessageGasLimit(CrossDomainMessageGasLimits gasLimitType) internal view returns (uint) {
861         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, _getGasLimitSetting(gasLimitType));
862     }
863 
864     function getTradingRewardsEnabled() internal view returns (bool) {
865         return flexibleStorage().getBoolValue(SETTING_CONTRACT_NAME, SETTING_TRADING_REWARDS_ENABLED);
866     }
867 
868     function getWaitingPeriodSecs() internal view returns (uint) {
869         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_WAITING_PERIOD_SECS);
870     }
871 
872     function getPriceDeviationThresholdFactor() internal view returns (uint) {
873         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_PRICE_DEVIATION_THRESHOLD_FACTOR);
874     }
875 
876     function getIssuanceRatio() internal view returns (uint) {
877         // lookup on flexible storage directly for gas savings (rather than via SystemSettings)
878         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_ISSUANCE_RATIO);
879     }
880 
881     function getFeePeriodDuration() internal view returns (uint) {
882         // lookup on flexible storage directly for gas savings (rather than via SystemSettings)
883         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_FEE_PERIOD_DURATION);
884     }
885 
886     function getTargetThreshold() internal view returns (uint) {
887         // lookup on flexible storage directly for gas savings (rather than via SystemSettings)
888         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_TARGET_THRESHOLD);
889     }
890 
891     function getLiquidationDelay() internal view returns (uint) {
892         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_LIQUIDATION_DELAY);
893     }
894 
895     function getLiquidationRatio() internal view returns (uint) {
896         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_LIQUIDATION_RATIO);
897     }
898 
899     function getLiquidationPenalty() internal view returns (uint) {
900         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_LIQUIDATION_PENALTY);
901     }
902 
903     function getRateStalePeriod() internal view returns (uint) {
904         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_RATE_STALE_PERIOD);
905     }
906 
907     /* ========== Exchange Related Fees ========== */
908     function getExchangeFeeRate(bytes32 currencyKey) internal view returns (uint) {
909         return
910             flexibleStorage().getUIntValue(
911                 SETTING_CONTRACT_NAME,
912                 keccak256(abi.encodePacked(SETTING_EXCHANGE_FEE_RATE, currencyKey))
913             );
914     }
915 
916     /// @notice Get exchange dynamic fee related keys
917     /// @return threshold, weight decay, rounds, and max fee
918     function getExchangeDynamicFeeConfig() internal view returns (DynamicFeeConfig memory) {
919         bytes32[] memory keys = new bytes32[](4);
920         keys[0] = SETTING_EXCHANGE_DYNAMIC_FEE_THRESHOLD;
921         keys[1] = SETTING_EXCHANGE_DYNAMIC_FEE_WEIGHT_DECAY;
922         keys[2] = SETTING_EXCHANGE_DYNAMIC_FEE_ROUNDS;
923         keys[3] = SETTING_EXCHANGE_MAX_DYNAMIC_FEE;
924         uint[] memory values = flexibleStorage().getUIntValues(SETTING_CONTRACT_NAME, keys);
925         return DynamicFeeConfig({threshold: values[0], weightDecay: values[1], rounds: values[2], maxFee: values[3]});
926     }
927 
928     /* ========== End Exchange Related Fees ========== */
929 
930     function getMinimumStakeTime() internal view returns (uint) {
931         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_MINIMUM_STAKE_TIME);
932     }
933 
934     function getAggregatorWarningFlags() internal view returns (address) {
935         return flexibleStorage().getAddressValue(SETTING_CONTRACT_NAME, SETTING_AGGREGATOR_WARNING_FLAGS);
936     }
937 
938     function getDebtSnapshotStaleTime() internal view returns (uint) {
939         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_DEBT_SNAPSHOT_STALE_TIME);
940     }
941 
942     function getEtherWrapperMaxETH() internal view returns (uint) {
943         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_ETHER_WRAPPER_MAX_ETH);
944     }
945 
946     function getEtherWrapperMintFeeRate() internal view returns (uint) {
947         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_ETHER_WRAPPER_MINT_FEE_RATE);
948     }
949 
950     function getEtherWrapperBurnFeeRate() internal view returns (uint) {
951         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_ETHER_WRAPPER_BURN_FEE_RATE);
952     }
953 
954     function getWrapperMaxTokenAmount(address wrapper) internal view returns (uint) {
955         return
956             flexibleStorage().getUIntValue(
957                 SETTING_CONTRACT_NAME,
958                 keccak256(abi.encodePacked(SETTING_WRAPPER_MAX_TOKEN_AMOUNT, wrapper))
959             );
960     }
961 
962     function getWrapperMintFeeRate(address wrapper) internal view returns (int) {
963         return
964             flexibleStorage().getIntValue(
965                 SETTING_CONTRACT_NAME,
966                 keccak256(abi.encodePacked(SETTING_WRAPPER_MINT_FEE_RATE, wrapper))
967             );
968     }
969 
970     function getWrapperBurnFeeRate(address wrapper) internal view returns (int) {
971         return
972             flexibleStorage().getIntValue(
973                 SETTING_CONTRACT_NAME,
974                 keccak256(abi.encodePacked(SETTING_WRAPPER_BURN_FEE_RATE, wrapper))
975             );
976     }
977 
978     function getInteractionDelay(address collateral) internal view returns (uint) {
979         return
980             flexibleStorage().getUIntValue(
981                 SETTING_CONTRACT_NAME,
982                 keccak256(abi.encodePacked(SETTING_INTERACTION_DELAY, collateral))
983             );
984     }
985 
986     function getCollapseFeeRate(address collateral) internal view returns (uint) {
987         return
988             flexibleStorage().getUIntValue(
989                 SETTING_CONTRACT_NAME,
990                 keccak256(abi.encodePacked(SETTING_COLLAPSE_FEE_RATE, collateral))
991             );
992     }
993 
994     function getAtomicMaxVolumePerBlock() internal view returns (uint) {
995         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_ATOMIC_MAX_VOLUME_PER_BLOCK);
996     }
997 
998     function getAtomicTwapWindow() internal view returns (uint) {
999         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_ATOMIC_TWAP_WINDOW);
1000     }
1001 
1002     function getAtomicEquivalentForDexPricing(bytes32 currencyKey) internal view returns (address) {
1003         return
1004             flexibleStorage().getAddressValue(
1005                 SETTING_CONTRACT_NAME,
1006                 keccak256(abi.encodePacked(SETTING_ATOMIC_EQUIVALENT_FOR_DEX_PRICING, currencyKey))
1007             );
1008     }
1009 
1010     function getAtomicExchangeFeeRate(bytes32 currencyKey) internal view returns (uint) {
1011         return
1012             flexibleStorage().getUIntValue(
1013                 SETTING_CONTRACT_NAME,
1014                 keccak256(abi.encodePacked(SETTING_ATOMIC_EXCHANGE_FEE_RATE, currencyKey))
1015             );
1016     }
1017 
1018     function getAtomicPriceBuffer(bytes32 currencyKey) internal view returns (uint) {
1019         return
1020             flexibleStorage().getUIntValue(
1021                 SETTING_CONTRACT_NAME,
1022                 keccak256(abi.encodePacked(SETTING_ATOMIC_PRICE_BUFFER, currencyKey))
1023             );
1024     }
1025 
1026     function getAtomicVolatilityConsiderationWindow(bytes32 currencyKey) internal view returns (uint) {
1027         return
1028             flexibleStorage().getUIntValue(
1029                 SETTING_CONTRACT_NAME,
1030                 keccak256(abi.encodePacked(SETTING_ATOMIC_VOLATILITY_CONSIDERATION_WINDOW, currencyKey))
1031             );
1032     }
1033 
1034     function getAtomicVolatilityUpdateThreshold(bytes32 currencyKey) internal view returns (uint) {
1035         return
1036             flexibleStorage().getUIntValue(
1037                 SETTING_CONTRACT_NAME,
1038                 keccak256(abi.encodePacked(SETTING_ATOMIC_VOLATILITY_UPDATE_THRESHOLD, currencyKey))
1039             );
1040     }
1041 }
1042 
1043 
1044 interface IDebtCache {
1045     // Views
1046 
1047     function cachedDebt() external view returns (uint);
1048 
1049     function cachedSynthDebt(bytes32 currencyKey) external view returns (uint);
1050 
1051     function cacheTimestamp() external view returns (uint);
1052 
1053     function cacheInvalid() external view returns (bool);
1054 
1055     function cacheStale() external view returns (bool);
1056 
1057     function isInitialized() external view returns (bool);
1058 
1059     function currentSynthDebts(bytes32[] calldata currencyKeys)
1060         external
1061         view
1062         returns (
1063             uint[] memory debtValues,
1064             uint futuresDebt,
1065             uint excludedDebt,
1066             bool anyRateIsInvalid
1067         );
1068 
1069     function cachedSynthDebts(bytes32[] calldata currencyKeys) external view returns (uint[] memory debtValues);
1070 
1071     function totalNonSnxBackedDebt() external view returns (uint excludedDebt, bool isInvalid);
1072 
1073     function currentDebt() external view returns (uint debt, bool anyRateIsInvalid);
1074 
1075     function cacheInfo()
1076         external
1077         view
1078         returns (
1079             uint debt,
1080             uint timestamp,
1081             bool isInvalid,
1082             bool isStale
1083         );
1084 
1085     function excludedIssuedDebts(bytes32[] calldata currencyKeys) external view returns (uint[] memory excludedDebts);
1086 
1087     // Mutative functions
1088 
1089     function updateCachedSynthDebts(bytes32[] calldata currencyKeys) external;
1090 
1091     function updateCachedSynthDebtWithRate(bytes32 currencyKey, uint currencyRate) external;
1092 
1093     function updateCachedSynthDebtsWithRates(bytes32[] calldata currencyKeys, uint[] calldata currencyRates) external;
1094 
1095     function updateDebtCacheValidity(bool currentlyInvalid) external;
1096 
1097     function purgeCachedSynthDebt(bytes32 currencyKey) external;
1098 
1099     function takeDebtSnapshot() external;
1100 
1101     function recordExcludedDebtChange(bytes32 currencyKey, int256 delta) external;
1102 
1103     function updateCachedsUSDDebt(int amount) external;
1104 
1105     function importExcludedIssuedDebts(IDebtCache prevDebtCache, IIssuer prevIssuer) external;
1106 }
1107 
1108 
1109 interface IVirtualSynth {
1110     // Views
1111     function balanceOfUnderlying(address account) external view returns (uint);
1112 
1113     function rate() external view returns (uint);
1114 
1115     function readyToSettle() external view returns (bool);
1116 
1117     function secsLeftInWaitingPeriod() external view returns (uint);
1118 
1119     function settled() external view returns (bool);
1120 
1121     function synth() external view returns (ISynth);
1122 
1123     // Mutative functions
1124     function settle(address account) external;
1125 }
1126 
1127 
1128 // https://docs.synthetix.io/contracts/source/interfaces/iexchanger
1129 interface IExchanger {
1130     struct ExchangeEntrySettlement {
1131         bytes32 src;
1132         uint amount;
1133         bytes32 dest;
1134         uint reclaim;
1135         uint rebate;
1136         uint srcRoundIdAtPeriodEnd;
1137         uint destRoundIdAtPeriodEnd;
1138         uint timestamp;
1139     }
1140 
1141     struct ExchangeEntry {
1142         uint sourceRate;
1143         uint destinationRate;
1144         uint destinationAmount;
1145         uint exchangeFeeRate;
1146         uint exchangeDynamicFeeRate;
1147         uint roundIdForSrc;
1148         uint roundIdForDest;
1149     }
1150 
1151     // Views
1152     function calculateAmountAfterSettlement(
1153         address from,
1154         bytes32 currencyKey,
1155         uint amount,
1156         uint refunded
1157     ) external view returns (uint amountAfterSettlement);
1158 
1159     function isSynthRateInvalid(bytes32 currencyKey) external view returns (bool);
1160 
1161     function maxSecsLeftInWaitingPeriod(address account, bytes32 currencyKey) external view returns (uint);
1162 
1163     function settlementOwing(address account, bytes32 currencyKey)
1164         external
1165         view
1166         returns (
1167             uint reclaimAmount,
1168             uint rebateAmount,
1169             uint numEntries
1170         );
1171 
1172     function hasWaitingPeriodOrSettlementOwing(address account, bytes32 currencyKey) external view returns (bool);
1173 
1174     function feeRateForExchange(bytes32 sourceCurrencyKey, bytes32 destinationCurrencyKey) external view returns (uint);
1175 
1176     function dynamicFeeRateForExchange(bytes32 sourceCurrencyKey, bytes32 destinationCurrencyKey)
1177         external
1178         view
1179         returns (uint feeRate, bool tooVolatile);
1180 
1181     function getAmountsForExchange(
1182         uint sourceAmount,
1183         bytes32 sourceCurrencyKey,
1184         bytes32 destinationCurrencyKey
1185     )
1186         external
1187         view
1188         returns (
1189             uint amountReceived,
1190             uint fee,
1191             uint exchangeFeeRate
1192         );
1193 
1194     function priceDeviationThresholdFactor() external view returns (uint);
1195 
1196     function waitingPeriodSecs() external view returns (uint);
1197 
1198     function lastExchangeRate(bytes32 currencyKey) external view returns (uint);
1199 
1200     // Mutative functions
1201     function exchange(
1202         address exchangeForAddress,
1203         address from,
1204         bytes32 sourceCurrencyKey,
1205         uint sourceAmount,
1206         bytes32 destinationCurrencyKey,
1207         address destinationAddress,
1208         bool virtualSynth,
1209         address rewardAddress,
1210         bytes32 trackingCode
1211     ) external returns (uint amountReceived, IVirtualSynth vSynth);
1212 
1213     function exchangeAtomically(
1214         address from,
1215         bytes32 sourceCurrencyKey,
1216         uint sourceAmount,
1217         bytes32 destinationCurrencyKey,
1218         address destinationAddress,
1219         bytes32 trackingCode
1220     ) external returns (uint amountReceived);
1221 
1222     function settle(address from, bytes32 currencyKey)
1223         external
1224         returns (
1225             uint reclaimed,
1226             uint refunded,
1227             uint numEntries
1228         );
1229 
1230     function suspendSynthWithInvalidRate(bytes32 currencyKey) external;
1231 }
1232 
1233 
1234 // https://docs.synthetix.io/contracts/source/interfaces/iexchangerates
1235 interface IExchangeRates {
1236     // Structs
1237     struct RateAndUpdatedTime {
1238         uint216 rate;
1239         uint40 time;
1240     }
1241 
1242     // Views
1243     function aggregators(bytes32 currencyKey) external view returns (address);
1244 
1245     function aggregatorWarningFlags() external view returns (address);
1246 
1247     function anyRateIsInvalid(bytes32[] calldata currencyKeys) external view returns (bool);
1248 
1249     function anyRateIsInvalidAtRound(bytes32[] calldata currencyKeys, uint[] calldata roundIds) external view returns (bool);
1250 
1251     function currenciesUsingAggregator(address aggregator) external view returns (bytes32[] memory);
1252 
1253     function effectiveValue(
1254         bytes32 sourceCurrencyKey,
1255         uint sourceAmount,
1256         bytes32 destinationCurrencyKey
1257     ) external view returns (uint value);
1258 
1259     function effectiveValueAndRates(
1260         bytes32 sourceCurrencyKey,
1261         uint sourceAmount,
1262         bytes32 destinationCurrencyKey
1263     )
1264         external
1265         view
1266         returns (
1267             uint value,
1268             uint sourceRate,
1269             uint destinationRate
1270         );
1271 
1272     function effectiveValueAndRatesAtRound(
1273         bytes32 sourceCurrencyKey,
1274         uint sourceAmount,
1275         bytes32 destinationCurrencyKey,
1276         uint roundIdForSrc,
1277         uint roundIdForDest
1278     )
1279         external
1280         view
1281         returns (
1282             uint value,
1283             uint sourceRate,
1284             uint destinationRate
1285         );
1286 
1287     function effectiveAtomicValueAndRates(
1288         bytes32 sourceCurrencyKey,
1289         uint sourceAmount,
1290         bytes32 destinationCurrencyKey
1291     )
1292         external
1293         view
1294         returns (
1295             uint value,
1296             uint systemValue,
1297             uint systemSourceRate,
1298             uint systemDestinationRate
1299         );
1300 
1301     function getCurrentRoundId(bytes32 currencyKey) external view returns (uint);
1302 
1303     function getLastRoundIdBeforeElapsedSecs(
1304         bytes32 currencyKey,
1305         uint startingRoundId,
1306         uint startingTimestamp,
1307         uint timediff
1308     ) external view returns (uint);
1309 
1310     function lastRateUpdateTimes(bytes32 currencyKey) external view returns (uint256);
1311 
1312     function rateAndTimestampAtRound(bytes32 currencyKey, uint roundId) external view returns (uint rate, uint time);
1313 
1314     function rateAndUpdatedTime(bytes32 currencyKey) external view returns (uint rate, uint time);
1315 
1316     function rateAndInvalid(bytes32 currencyKey) external view returns (uint rate, bool isInvalid);
1317 
1318     function rateForCurrency(bytes32 currencyKey) external view returns (uint);
1319 
1320     function rateIsFlagged(bytes32 currencyKey) external view returns (bool);
1321 
1322     function rateIsInvalid(bytes32 currencyKey) external view returns (bool);
1323 
1324     function rateIsStale(bytes32 currencyKey) external view returns (bool);
1325 
1326     function rateStalePeriod() external view returns (uint);
1327 
1328     function ratesAndUpdatedTimeForCurrencyLastNRounds(
1329         bytes32 currencyKey,
1330         uint numRounds,
1331         uint roundId
1332     ) external view returns (uint[] memory rates, uint[] memory times);
1333 
1334     function ratesAndInvalidForCurrencies(bytes32[] calldata currencyKeys)
1335         external
1336         view
1337         returns (uint[] memory rates, bool anyRateInvalid);
1338 
1339     function ratesForCurrencies(bytes32[] calldata currencyKeys) external view returns (uint[] memory);
1340 
1341     function synthTooVolatileForAtomicExchange(bytes32 currencyKey) external view returns (bool);
1342 }
1343 
1344 
1345 // https://docs.synthetix.io/contracts/source/interfaces/isystemstatus
1346 interface ISystemStatus {
1347     struct Status {
1348         bool canSuspend;
1349         bool canResume;
1350     }
1351 
1352     struct Suspension {
1353         bool suspended;
1354         // reason is an integer code,
1355         // 0 => no reason, 1 => upgrading, 2+ => defined by system usage
1356         uint248 reason;
1357     }
1358 
1359     // Views
1360     function accessControl(bytes32 section, address account) external view returns (bool canSuspend, bool canResume);
1361 
1362     function requireSystemActive() external view;
1363 
1364     function systemSuspended() external view returns (bool);
1365 
1366     function requireIssuanceActive() external view;
1367 
1368     function requireExchangeActive() external view;
1369 
1370     function requireFuturesActive() external view;
1371 
1372     function requireFuturesMarketActive(bytes32 marketKey) external view;
1373 
1374     function requireExchangeBetweenSynthsAllowed(bytes32 sourceCurrencyKey, bytes32 destinationCurrencyKey) external view;
1375 
1376     function requireSynthActive(bytes32 currencyKey) external view;
1377 
1378     function synthSuspended(bytes32 currencyKey) external view returns (bool);
1379 
1380     function requireSynthsActive(bytes32 sourceCurrencyKey, bytes32 destinationCurrencyKey) external view;
1381 
1382     function systemSuspension() external view returns (bool suspended, uint248 reason);
1383 
1384     function issuanceSuspension() external view returns (bool suspended, uint248 reason);
1385 
1386     function exchangeSuspension() external view returns (bool suspended, uint248 reason);
1387 
1388     function futuresSuspension() external view returns (bool suspended, uint248 reason);
1389 
1390     function synthExchangeSuspension(bytes32 currencyKey) external view returns (bool suspended, uint248 reason);
1391 
1392     function synthSuspension(bytes32 currencyKey) external view returns (bool suspended, uint248 reason);
1393 
1394     function futuresMarketSuspension(bytes32 marketKey) external view returns (bool suspended, uint248 reason);
1395 
1396     function getSynthExchangeSuspensions(bytes32[] calldata synths)
1397         external
1398         view
1399         returns (bool[] memory exchangeSuspensions, uint256[] memory reasons);
1400 
1401     function getSynthSuspensions(bytes32[] calldata synths)
1402         external
1403         view
1404         returns (bool[] memory suspensions, uint256[] memory reasons);
1405 
1406     function getFuturesMarketSuspensions(bytes32[] calldata marketKeys)
1407         external
1408         view
1409         returns (bool[] memory suspensions, uint256[] memory reasons);
1410 
1411     // Restricted functions
1412     function suspendIssuance(uint256 reason) external;
1413 
1414     function suspendSynth(bytes32 currencyKey, uint256 reason) external;
1415 
1416     function suspendFuturesMarket(bytes32 marketKey, uint256 reason) external;
1417 
1418     function updateAccessControl(
1419         bytes32 section,
1420         address account,
1421         bool canSuspend,
1422         bool canResume
1423     ) external;
1424 }
1425 
1426 
1427 // https://docs.synthetix.io/contracts/source/interfaces/ierc20
1428 interface IERC20 {
1429     // ERC20 Optional Views
1430     function name() external view returns (string memory);
1431 
1432     function symbol() external view returns (string memory);
1433 
1434     function decimals() external view returns (uint8);
1435 
1436     // Views
1437     function totalSupply() external view returns (uint);
1438 
1439     function balanceOf(address owner) external view returns (uint);
1440 
1441     function allowance(address owner, address spender) external view returns (uint);
1442 
1443     // Mutative functions
1444     function transfer(address to, uint value) external returns (bool);
1445 
1446     function approve(address spender, uint value) external returns (bool);
1447 
1448     function transferFrom(
1449         address from,
1450         address to,
1451         uint value
1452     ) external returns (bool);
1453 
1454     // Events
1455     event Transfer(address indexed from, address indexed to, uint value);
1456 
1457     event Approval(address indexed owner, address indexed spender, uint value);
1458 }
1459 
1460 
1461 interface ICollateralManager {
1462     // Manager information
1463     function hasCollateral(address collateral) external view returns (bool);
1464 
1465     function isSynthManaged(bytes32 currencyKey) external view returns (bool);
1466 
1467     // State information
1468     function long(bytes32 synth) external view returns (uint amount);
1469 
1470     function short(bytes32 synth) external view returns (uint amount);
1471 
1472     function totalLong() external view returns (uint susdValue, bool anyRateIsInvalid);
1473 
1474     function totalShort() external view returns (uint susdValue, bool anyRateIsInvalid);
1475 
1476     function getBorrowRate() external view returns (uint borrowRate, bool anyRateIsInvalid);
1477 
1478     function getShortRate(bytes32 synth) external view returns (uint shortRate, bool rateIsInvalid);
1479 
1480     function getRatesAndTime(uint index)
1481         external
1482         view
1483         returns (
1484             uint entryRate,
1485             uint lastRate,
1486             uint lastUpdated,
1487             uint newIndex
1488         );
1489 
1490     function getShortRatesAndTime(bytes32 currency, uint index)
1491         external
1492         view
1493         returns (
1494             uint entryRate,
1495             uint lastRate,
1496             uint lastUpdated,
1497             uint newIndex
1498         );
1499 
1500     function exceedsDebtLimit(uint amount, bytes32 currency) external view returns (bool canIssue, bool anyRateIsInvalid);
1501 
1502     function areSynthsAndCurrenciesSet(bytes32[] calldata requiredSynthNamesInResolver, bytes32[] calldata synthKeys)
1503         external
1504         view
1505         returns (bool);
1506 
1507     function areShortableSynthsSet(bytes32[] calldata requiredSynthNamesInResolver, bytes32[] calldata synthKeys)
1508         external
1509         view
1510         returns (bool);
1511 
1512     // Loans
1513     function getNewLoanId() external returns (uint id);
1514 
1515     // Manager mutative
1516     function addCollaterals(address[] calldata collaterals) external;
1517 
1518     function removeCollaterals(address[] calldata collaterals) external;
1519 
1520     function addSynths(bytes32[] calldata synthNamesInResolver, bytes32[] calldata synthKeys) external;
1521 
1522     function removeSynths(bytes32[] calldata synths, bytes32[] calldata synthKeys) external;
1523 
1524     function addShortableSynths(bytes32[] calldata requiredSynthNamesInResolver, bytes32[] calldata synthKeys) external;
1525 
1526     function removeShortableSynths(bytes32[] calldata synths) external;
1527 
1528     // State mutative
1529 
1530     function incrementLongs(bytes32 synth, uint amount) external;
1531 
1532     function decrementLongs(bytes32 synth, uint amount) external;
1533 
1534     function incrementShorts(bytes32 synth, uint amount) external;
1535 
1536     function decrementShorts(bytes32 synth, uint amount) external;
1537 
1538     function accrueInterest(
1539         uint interestIndex,
1540         bytes32 currency,
1541         bool isShort
1542     ) external returns (uint difference, uint index);
1543 
1544     function updateBorrowRatesCollateral(uint rate) external;
1545 
1546     function updateShortRatesCollateral(bytes32 currency, uint rate) external;
1547 }
1548 
1549 
1550 interface IWETH {
1551     // ERC20 Optional Views
1552     function name() external view returns (string memory);
1553 
1554     function symbol() external view returns (string memory);
1555 
1556     function decimals() external view returns (uint8);
1557 
1558     // Views
1559     function totalSupply() external view returns (uint);
1560 
1561     function balanceOf(address owner) external view returns (uint);
1562 
1563     function allowance(address owner, address spender) external view returns (uint);
1564 
1565     // Mutative functions
1566     function transfer(address to, uint value) external returns (bool);
1567 
1568     function approve(address spender, uint value) external returns (bool);
1569 
1570     function transferFrom(
1571         address from,
1572         address to,
1573         uint value
1574     ) external returns (bool);
1575 
1576     // WETH-specific functions.
1577     function deposit() external payable;
1578 
1579     function withdraw(uint amount) external;
1580 
1581     // Events
1582     event Transfer(address indexed from, address indexed to, uint value);
1583     event Approval(address indexed owner, address indexed spender, uint value);
1584     event Deposit(address indexed to, uint amount);
1585     event Withdrawal(address indexed to, uint amount);
1586 }
1587 
1588 
1589 // https://docs.synthetix.io/contracts/source/interfaces/ietherwrapper
1590 contract IEtherWrapper {
1591     function mint(uint amount) external;
1592 
1593     function burn(uint amount) external;
1594 
1595     function distributeFees() external;
1596 
1597     function capacity() external view returns (uint);
1598 
1599     function getReserves() external view returns (uint);
1600 
1601     function totalIssuedSynths() external view returns (uint);
1602 
1603     function calculateMintFee(uint amount) public view returns (uint);
1604 
1605     function calculateBurnFee(uint amount) public view returns (uint);
1606 
1607     function maxETH() public view returns (uint256);
1608 
1609     function mintFeeRate() public view returns (uint256);
1610 
1611     function burnFeeRate() public view returns (uint256);
1612 
1613     function weth() public view returns (IWETH);
1614 }
1615 
1616 
1617 // https://docs.synthetix.io/contracts/source/interfaces/iwrapperfactory
1618 interface IWrapperFactory {
1619     function isWrapper(address possibleWrapper) external view returns (bool);
1620 
1621     function createWrapper(
1622         IERC20 token,
1623         bytes32 currencyKey,
1624         bytes32 synthContractName
1625     ) external returns (address);
1626 
1627     function distributeFees() external;
1628 }
1629 
1630 
1631 interface IFuturesMarketManager {
1632     function markets(uint index, uint pageSize) external view returns (address[] memory);
1633 
1634     function numMarkets() external view returns (uint);
1635 
1636     function allMarkets() external view returns (address[] memory);
1637 
1638     function marketForKey(bytes32 marketKey) external view returns (address);
1639 
1640     function marketsForKeys(bytes32[] calldata marketKeys) external view returns (address[] memory);
1641 
1642     function totalDebt() external view returns (uint debt, bool isInvalid);
1643 }
1644 
1645 
1646 // Inheritance
1647 
1648 
1649 // Libraries
1650 
1651 
1652 // Internal references
1653 
1654 
1655 // https://docs.synthetix.io/contracts/source/contracts/debtcache
1656 contract BaseDebtCache is Owned, MixinSystemSettings, IDebtCache {
1657     using SafeMath for uint;
1658     using SafeDecimalMath for uint;
1659 
1660     uint internal _cachedDebt;
1661     mapping(bytes32 => uint) internal _cachedSynthDebt;
1662     mapping(bytes32 => uint) internal _excludedIssuedDebt;
1663     uint internal _cacheTimestamp;
1664     bool internal _cacheInvalid = true;
1665 
1666     // flag to ensure importing excluded debt is invoked only once
1667     bool public isInitialized = false; // public to avoid needing an event
1668 
1669     /* ========== ENCODED NAMES ========== */
1670 
1671     bytes32 internal constant sUSD = "sUSD";
1672     bytes32 internal constant sETH = "sETH";
1673 
1674     /* ========== ADDRESS RESOLVER CONFIGURATION ========== */
1675 
1676     bytes32 private constant CONTRACT_ISSUER = "Issuer";
1677     bytes32 private constant CONTRACT_EXCHANGER = "Exchanger";
1678     bytes32 private constant CONTRACT_EXRATES = "ExchangeRates";
1679     bytes32 private constant CONTRACT_SYSTEMSTATUS = "SystemStatus";
1680     bytes32 private constant CONTRACT_COLLATERALMANAGER = "CollateralManager";
1681     bytes32 private constant CONTRACT_ETHER_WRAPPER = "EtherWrapper";
1682     bytes32 private constant CONTRACT_FUTURESMARKETMANAGER = "FuturesMarketManager";
1683     bytes32 private constant CONTRACT_WRAPPER_FACTORY = "WrapperFactory";
1684 
1685     constructor(address _owner, address _resolver) public Owned(_owner) MixinSystemSettings(_resolver) {}
1686 
1687     /* ========== VIEWS ========== */
1688 
1689     function resolverAddressesRequired() public view returns (bytes32[] memory addresses) {
1690         bytes32[] memory existingAddresses = MixinSystemSettings.resolverAddressesRequired();
1691         bytes32[] memory newAddresses = new bytes32[](8);
1692         newAddresses[0] = CONTRACT_ISSUER;
1693         newAddresses[1] = CONTRACT_EXCHANGER;
1694         newAddresses[2] = CONTRACT_EXRATES;
1695         newAddresses[3] = CONTRACT_SYSTEMSTATUS;
1696         newAddresses[4] = CONTRACT_COLLATERALMANAGER;
1697         newAddresses[5] = CONTRACT_WRAPPER_FACTORY;
1698         newAddresses[6] = CONTRACT_ETHER_WRAPPER;
1699         newAddresses[7] = CONTRACT_FUTURESMARKETMANAGER;
1700         addresses = combineArrays(existingAddresses, newAddresses);
1701     }
1702 
1703     function issuer() internal view returns (IIssuer) {
1704         return IIssuer(requireAndGetAddress(CONTRACT_ISSUER));
1705     }
1706 
1707     function exchanger() internal view returns (IExchanger) {
1708         return IExchanger(requireAndGetAddress(CONTRACT_EXCHANGER));
1709     }
1710 
1711     function exchangeRates() internal view returns (IExchangeRates) {
1712         return IExchangeRates(requireAndGetAddress(CONTRACT_EXRATES));
1713     }
1714 
1715     function systemStatus() internal view returns (ISystemStatus) {
1716         return ISystemStatus(requireAndGetAddress(CONTRACT_SYSTEMSTATUS));
1717     }
1718 
1719     function collateralManager() internal view returns (ICollateralManager) {
1720         return ICollateralManager(requireAndGetAddress(CONTRACT_COLLATERALMANAGER));
1721     }
1722 
1723     function etherWrapper() internal view returns (IEtherWrapper) {
1724         return IEtherWrapper(requireAndGetAddress(CONTRACT_ETHER_WRAPPER));
1725     }
1726 
1727     function futuresMarketManager() internal view returns (IFuturesMarketManager) {
1728         return IFuturesMarketManager(requireAndGetAddress(CONTRACT_FUTURESMARKETMANAGER));
1729     }
1730 
1731     function wrapperFactory() internal view returns (IWrapperFactory) {
1732         return IWrapperFactory(requireAndGetAddress(CONTRACT_WRAPPER_FACTORY));
1733     }
1734 
1735     function debtSnapshotStaleTime() external view returns (uint) {
1736         return getDebtSnapshotStaleTime();
1737     }
1738 
1739     function cachedDebt() external view returns (uint) {
1740         return _cachedDebt;
1741     }
1742 
1743     function cachedSynthDebt(bytes32 currencyKey) external view returns (uint) {
1744         return _cachedSynthDebt[currencyKey];
1745     }
1746 
1747     function cacheTimestamp() external view returns (uint) {
1748         return _cacheTimestamp;
1749     }
1750 
1751     function cacheInvalid() external view returns (bool) {
1752         return _cacheInvalid;
1753     }
1754 
1755     function _cacheStale(uint timestamp) internal view returns (bool) {
1756         // Note a 0 timestamp means that the cache is uninitialised.
1757         // We'll keep the check explicitly in case the stale time is
1758         // ever set to something higher than the current unix time (e.g. to turn off staleness).
1759         return getDebtSnapshotStaleTime() < block.timestamp - timestamp || timestamp == 0;
1760     }
1761 
1762     function cacheStale() external view returns (bool) {
1763         return _cacheStale(_cacheTimestamp);
1764     }
1765 
1766     function _issuedSynthValues(bytes32[] memory currencyKeys, uint[] memory rates)
1767         internal
1768         view
1769         returns (uint[] memory values)
1770     {
1771         uint numValues = currencyKeys.length;
1772         values = new uint[](numValues);
1773         ISynth[] memory synths = issuer().getSynths(currencyKeys);
1774 
1775         for (uint i = 0; i < numValues; i++) {
1776             address synthAddress = address(synths[i]);
1777             require(synthAddress != address(0), "Synth does not exist");
1778             uint supply = IERC20(synthAddress).totalSupply();
1779             values[i] = supply.multiplyDecimalRound(rates[i]);
1780         }
1781 
1782         return (values);
1783     }
1784 
1785     function _currentSynthDebts(bytes32[] memory currencyKeys)
1786         internal
1787         view
1788         returns (
1789             uint[] memory snxIssuedDebts,
1790             uint _futuresDebt,
1791             uint _excludedDebt,
1792             bool anyRateIsInvalid
1793         )
1794     {
1795         (uint[] memory rates, bool isInvalid) = exchangeRates().ratesAndInvalidForCurrencies(currencyKeys);
1796         uint[] memory values = _issuedSynthValues(currencyKeys, rates);
1797         (uint excludedDebt, bool isAnyNonSnxDebtRateInvalid) = _totalNonSnxBackedDebt(currencyKeys, rates, isInvalid);
1798         (uint futuresDebt, bool futuresDebtIsInvalid) = futuresMarketManager().totalDebt();
1799 
1800         return (values, futuresDebt, excludedDebt, isInvalid || futuresDebtIsInvalid || isAnyNonSnxDebtRateInvalid);
1801     }
1802 
1803     function currentSynthDebts(bytes32[] calldata currencyKeys)
1804         external
1805         view
1806         returns (
1807             uint[] memory debtValues,
1808             uint futuresDebt,
1809             uint excludedDebt,
1810             bool anyRateIsInvalid
1811         )
1812     {
1813         return _currentSynthDebts(currencyKeys);
1814     }
1815 
1816     function _cachedSynthDebts(bytes32[] memory currencyKeys) internal view returns (uint[] memory) {
1817         uint numKeys = currencyKeys.length;
1818         uint[] memory debts = new uint[](numKeys);
1819         for (uint i = 0; i < numKeys; i++) {
1820             debts[i] = _cachedSynthDebt[currencyKeys[i]];
1821         }
1822         return debts;
1823     }
1824 
1825     function cachedSynthDebts(bytes32[] calldata currencyKeys) external view returns (uint[] memory snxIssuedDebts) {
1826         return _cachedSynthDebts(currencyKeys);
1827     }
1828 
1829     function _excludedIssuedDebts(bytes32[] memory currencyKeys) internal view returns (uint[] memory) {
1830         uint numKeys = currencyKeys.length;
1831         uint[] memory debts = new uint[](numKeys);
1832         for (uint i = 0; i < numKeys; i++) {
1833             debts[i] = _excludedIssuedDebt[currencyKeys[i]];
1834         }
1835         return debts;
1836     }
1837 
1838     function excludedIssuedDebts(bytes32[] calldata currencyKeys) external view returns (uint[] memory excludedDebts) {
1839         return _excludedIssuedDebts(currencyKeys);
1840     }
1841 
1842     /// used when migrating to new DebtCache instance in order to import the excluded debt records
1843     /// If this method is not run after upgrading the contract, the debt will be
1844     /// incorrect w.r.t to wrapper factory assets until the values are imported from
1845     /// previous instance of the contract
1846     /// Also, in addition to this method it's possible to use recordExcludedDebtChange since
1847     /// it's accessible to owner in case additional adjustments are required
1848     function importExcludedIssuedDebts(IDebtCache prevDebtCache, IIssuer prevIssuer) external onlyOwner {
1849         // this can only be run once so that recorded debt deltas aren't accidentally
1850         // lost or double counted
1851         require(!isInitialized, "already initialized");
1852         isInitialized = true;
1853 
1854         // get the currency keys from **previous** issuer, in case current issuer
1855         // doesn't have all the synths at this point
1856         // warning: if a synth won't be added to the current issuer before the next upgrade of this contract,
1857         // its entry will be lost (because it won't be in the prevIssuer for next time).
1858         // if for some reason this is a problem, it should be possible to use recordExcludedDebtChange() to amend
1859         bytes32[] memory keys = prevIssuer.availableCurrencyKeys();
1860 
1861         require(keys.length > 0, "previous Issuer has no synths");
1862 
1863         // query for previous debt records
1864         uint[] memory debts = prevDebtCache.excludedIssuedDebts(keys);
1865 
1866         // store the values
1867         for (uint i = 0; i < keys.length; i++) {
1868             if (debts[i] > 0) {
1869                 // adding the values instead of overwriting in case some deltas were recorded in this
1870                 // contract already (e.g. if the upgrade was not atomic)
1871                 _excludedIssuedDebt[keys[i]] = _excludedIssuedDebt[keys[i]].add(debts[i]);
1872             }
1873         }
1874     }
1875 
1876     // Returns the total sUSD debt backed by non-SNX collateral.
1877     function totalNonSnxBackedDebt() external view returns (uint excludedDebt, bool isInvalid) {
1878         bytes32[] memory currencyKeys = issuer().availableCurrencyKeys();
1879         (uint[] memory rates, bool ratesAreInvalid) = exchangeRates().ratesAndInvalidForCurrencies(currencyKeys);
1880 
1881         return _totalNonSnxBackedDebt(currencyKeys, rates, ratesAreInvalid);
1882     }
1883 
1884     function _totalNonSnxBackedDebt(
1885         bytes32[] memory currencyKeys,
1886         uint[] memory rates,
1887         bool ratesAreInvalid
1888     ) internal view returns (uint excludedDebt, bool isInvalid) {
1889         // Calculate excluded debt.
1890         // 1. MultiCollateral long debt + short debt.
1891         (uint longValue, bool anyTotalLongRateIsInvalid) = collateralManager().totalLong();
1892         (uint shortValue, bool anyTotalShortRateIsInvalid) = collateralManager().totalShort();
1893         isInvalid = ratesAreInvalid || anyTotalLongRateIsInvalid || anyTotalShortRateIsInvalid;
1894         excludedDebt = longValue.add(shortValue);
1895 
1896         // 2. EtherWrapper.
1897         // Subtract sETH and sUSD issued by EtherWrapper.
1898         excludedDebt = excludedDebt.add(etherWrapper().totalIssuedSynths());
1899 
1900         // 3. WrapperFactory.
1901         // Get the debt issued by the Wrappers.
1902         for (uint i = 0; i < currencyKeys.length; i++) {
1903             excludedDebt = excludedDebt.add(_excludedIssuedDebt[currencyKeys[i]].multiplyDecimalRound(rates[i]));
1904         }
1905 
1906         return (excludedDebt, isInvalid);
1907     }
1908 
1909     function _currentDebt() internal view returns (uint debt, bool anyRateIsInvalid) {
1910         bytes32[] memory currencyKeys = issuer().availableCurrencyKeys();
1911         (uint[] memory rates, bool isInvalid) = exchangeRates().ratesAndInvalidForCurrencies(currencyKeys);
1912 
1913         // Sum all issued synth values based on their supply.
1914         uint[] memory values = _issuedSynthValues(currencyKeys, rates);
1915         (uint excludedDebt, bool isAnyNonSnxDebtRateInvalid) = _totalNonSnxBackedDebt(currencyKeys, rates, isInvalid);
1916 
1917         uint numValues = values.length;
1918         uint total;
1919         for (uint i; i < numValues; i++) {
1920             total = total.add(values[i]);
1921         }
1922 
1923         // Add in the debt accounted for by futures
1924         (uint futuresDebt, bool futuresDebtIsInvalid) = futuresMarketManager().totalDebt();
1925         total = total.add(futuresDebt);
1926 
1927         // Ensure that if the excluded non-SNX debt exceeds SNX-backed debt, no overflow occurs
1928         total = total < excludedDebt ? 0 : total.sub(excludedDebt);
1929 
1930         return (total, isInvalid || futuresDebtIsInvalid || isAnyNonSnxDebtRateInvalid);
1931     }
1932 
1933     function currentDebt() external view returns (uint debt, bool anyRateIsInvalid) {
1934         return _currentDebt();
1935     }
1936 
1937     function cacheInfo()
1938         external
1939         view
1940         returns (
1941             uint debt,
1942             uint timestamp,
1943             bool isInvalid,
1944             bool isStale
1945         )
1946     {
1947         uint time = _cacheTimestamp;
1948         return (_cachedDebt, time, _cacheInvalid, _cacheStale(time));
1949     }
1950 
1951     /* ========== MUTATIVE FUNCTIONS ========== */
1952 
1953     // Stub out all mutative functions as no-ops;
1954     // since they do nothing, there are no restrictions
1955 
1956     function updateCachedSynthDebts(bytes32[] calldata currencyKeys) external {}
1957 
1958     function updateCachedSynthDebtWithRate(bytes32 currencyKey, uint currencyRate) external {}
1959 
1960     function updateCachedSynthDebtsWithRates(bytes32[] calldata currencyKeys, uint[] calldata currencyRates) external {}
1961 
1962     function updateDebtCacheValidity(bool currentlyInvalid) external {}
1963 
1964     function purgeCachedSynthDebt(bytes32 currencyKey) external {}
1965 
1966     function takeDebtSnapshot() external {}
1967 
1968     function recordExcludedDebtChange(bytes32 currencyKey, int256 delta) external {}
1969 
1970     function updateCachedsUSDDebt(int amount) external {}
1971 
1972     /* ========== MODIFIERS ========== */
1973 
1974     function _requireSystemActiveIfNotOwner() internal view {
1975         if (msg.sender != owner) {
1976             systemStatus().requireSystemActive();
1977         }
1978     }
1979 
1980     modifier requireSystemActiveIfNotOwner() {
1981         _requireSystemActiveIfNotOwner();
1982         _;
1983     }
1984 
1985     function _onlyIssuer() internal view {
1986         require(msg.sender == address(issuer()), "Sender is not Issuer");
1987     }
1988 
1989     modifier onlyIssuer() {
1990         _onlyIssuer();
1991         _;
1992     }
1993 
1994     function _onlyIssuerOrExchanger() internal view {
1995         require(msg.sender == address(issuer()) || msg.sender == address(exchanger()), "Sender is not Issuer or Exchanger");
1996     }
1997 
1998     modifier onlyIssuerOrExchanger() {
1999         _onlyIssuerOrExchanger();
2000         _;
2001     }
2002 
2003     function _onlyDebtIssuer() internal view {
2004         bool isWrapper = wrapperFactory().isWrapper(msg.sender);
2005 
2006         // owner included for debugging and fixing in emergency situation
2007         bool isOwner = msg.sender == owner;
2008 
2009         require(isOwner || isWrapper, "Only debt issuers may call this");
2010     }
2011 
2012     modifier onlyDebtIssuer() {
2013         _onlyDebtIssuer();
2014         _;
2015     }
2016 }
2017 
2018 
2019 // Libraries
2020 
2021 
2022 // Inheritance
2023 
2024 
2025 // https://docs.synthetix.io/contracts/source/contracts/debtcache
2026 contract DebtCache is BaseDebtCache {
2027     using SafeDecimalMath for uint;
2028 
2029     bytes32 public constant CONTRACT_NAME = "DebtCache";
2030 
2031     constructor(address _owner, address _resolver) public BaseDebtCache(_owner, _resolver) {}
2032 
2033     bytes32 internal constant EXCLUDED_DEBT_KEY = "EXCLUDED_DEBT";
2034     bytes32 internal constant FUTURES_DEBT_KEY = "FUTURES_DEBT";
2035 
2036     /* ========== MUTATIVE FUNCTIONS ========== */
2037 
2038     // This function exists in case a synth is ever somehow removed without its snapshot being updated.
2039     function purgeCachedSynthDebt(bytes32 currencyKey) external onlyOwner {
2040         require(issuer().synths(currencyKey) == ISynth(0), "Synth exists");
2041         delete _cachedSynthDebt[currencyKey];
2042     }
2043 
2044     function takeDebtSnapshot() external requireSystemActiveIfNotOwner {
2045         bytes32[] memory currencyKeys = issuer().availableCurrencyKeys();
2046         (uint[] memory values, uint futuresDebt, uint excludedDebt, bool isInvalid) = _currentSynthDebts(currencyKeys);
2047 
2048         // The total SNX-backed debt is the debt of futures markets plus the debt of circulating synths.
2049         uint snxCollateralDebt = futuresDebt;
2050         _cachedSynthDebt[FUTURES_DEBT_KEY] = futuresDebt;
2051         uint numValues = values.length;
2052         for (uint i; i < numValues; i++) {
2053             uint value = values[i];
2054             snxCollateralDebt = snxCollateralDebt.add(value);
2055             _cachedSynthDebt[currencyKeys[i]] = value;
2056         }
2057 
2058         // Subtract out the excluded non-SNX backed debt from our total
2059         _cachedSynthDebt[EXCLUDED_DEBT_KEY] = excludedDebt;
2060         uint newDebt = snxCollateralDebt.floorsub(excludedDebt);
2061         _cachedDebt = newDebt;
2062         _cacheTimestamp = block.timestamp;
2063         emit DebtCacheUpdated(newDebt);
2064         emit DebtCacheSnapshotTaken(block.timestamp);
2065 
2066         // (in)validate the cache if necessary
2067         _updateDebtCacheValidity(isInvalid);
2068     }
2069 
2070     function updateCachedSynthDebts(bytes32[] calldata currencyKeys) external requireSystemActiveIfNotOwner {
2071         (uint[] memory rates, bool anyRateInvalid) = exchangeRates().ratesAndInvalidForCurrencies(currencyKeys);
2072         _updateCachedSynthDebtsWithRates(currencyKeys, rates, anyRateInvalid);
2073     }
2074 
2075     function updateCachedSynthDebtWithRate(bytes32 currencyKey, uint currencyRate) external onlyIssuer {
2076         bytes32[] memory synthKeyArray = new bytes32[](1);
2077         synthKeyArray[0] = currencyKey;
2078         uint[] memory synthRateArray = new uint[](1);
2079         synthRateArray[0] = currencyRate;
2080         _updateCachedSynthDebtsWithRates(synthKeyArray, synthRateArray, false);
2081     }
2082 
2083     function updateCachedSynthDebtsWithRates(bytes32[] calldata currencyKeys, uint[] calldata currencyRates)
2084         external
2085         onlyIssuerOrExchanger
2086     {
2087         _updateCachedSynthDebtsWithRates(currencyKeys, currencyRates, false);
2088     }
2089 
2090     function updateDebtCacheValidity(bool currentlyInvalid) external onlyIssuer {
2091         _updateDebtCacheValidity(currentlyInvalid);
2092     }
2093 
2094     function recordExcludedDebtChange(bytes32 currencyKey, int256 delta) external onlyDebtIssuer {
2095         int256 newExcludedDebt = int256(_excludedIssuedDebt[currencyKey]) + delta;
2096 
2097         require(newExcludedDebt >= 0, "Excluded debt cannot become negative");
2098 
2099         _excludedIssuedDebt[currencyKey] = uint(newExcludedDebt);
2100     }
2101 
2102     function updateCachedsUSDDebt(int amount) external onlyIssuer {
2103         uint delta = SafeDecimalMath.abs(amount);
2104         if (amount > 0) {
2105             _cachedSynthDebt[sUSD] = _cachedSynthDebt[sUSD].add(delta);
2106             _cachedDebt = _cachedDebt.add(delta);
2107         } else {
2108             _cachedSynthDebt[sUSD] = _cachedSynthDebt[sUSD].sub(delta);
2109             _cachedDebt = _cachedDebt.sub(delta);
2110         }
2111 
2112         emit DebtCacheUpdated(_cachedDebt);
2113     }
2114 
2115     /* ========== INTERNAL FUNCTIONS ========== */
2116 
2117     function _updateDebtCacheValidity(bool currentlyInvalid) internal {
2118         if (_cacheInvalid != currentlyInvalid) {
2119             _cacheInvalid = currentlyInvalid;
2120             emit DebtCacheValidityChanged(currentlyInvalid);
2121         }
2122     }
2123 
2124     // Updated the global debt according to a rate/supply change in a subset of issued synths.
2125     function _updateCachedSynthDebtsWithRates(
2126         bytes32[] memory currencyKeys,
2127         uint[] memory currentRates,
2128         bool anyRateIsInvalid
2129     ) internal {
2130         uint numKeys = currencyKeys.length;
2131         require(numKeys == currentRates.length, "Input array lengths differ");
2132 
2133         // Compute the cached and current debt sum for the subset of synths provided.
2134         uint cachedSum;
2135         uint currentSum;
2136         uint[] memory currentValues = _issuedSynthValues(currencyKeys, currentRates);
2137 
2138         for (uint i = 0; i < numKeys; i++) {
2139             bytes32 key = currencyKeys[i];
2140             uint currentSynthDebt = currentValues[i];
2141 
2142             cachedSum = cachedSum.add(_cachedSynthDebt[key]);
2143             currentSum = currentSum.add(currentSynthDebt);
2144 
2145             _cachedSynthDebt[key] = currentSynthDebt;
2146         }
2147 
2148         // Apply the debt update.
2149         if (cachedSum != currentSum) {
2150             uint debt = _cachedDebt;
2151             // apply the delta between the cachedSum and currentSum
2152             // add currentSum before sub cachedSum to prevent overflow as cachedSum > debt for large amount of excluded debt
2153             debt = debt.add(currentSum).sub(cachedSum);
2154             _cachedDebt = debt;
2155             emit DebtCacheUpdated(debt);
2156         }
2157 
2158         // Invalidate the cache if necessary
2159         if (anyRateIsInvalid) {
2160             _updateDebtCacheValidity(anyRateIsInvalid);
2161         }
2162     }
2163 
2164     /* ========== EVENTS ========== */
2165 
2166     event DebtCacheUpdated(uint cachedDebt);
2167     event DebtCacheSnapshotTaken(uint timestamp);
2168     event DebtCacheValidityChanged(bool indexed isInvalid);
2169 }
2170 
2171     