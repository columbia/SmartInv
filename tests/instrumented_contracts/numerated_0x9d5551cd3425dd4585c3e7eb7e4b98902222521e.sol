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
27 * Copyright (c) 2021 Synthetix
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
525 }
526 
527 
528 // Inheritance
529 
530 
531 // Internal references
532 
533 
534 // https://docs.synthetix.io/contracts/source/contracts/addressresolver
535 contract AddressResolver is Owned, IAddressResolver {
536     mapping(bytes32 => address) public repository;
537 
538     constructor(address _owner) public Owned(_owner) {}
539 
540     /* ========== RESTRICTED FUNCTIONS ========== */
541 
542     function importAddresses(bytes32[] calldata names, address[] calldata destinations) external onlyOwner {
543         require(names.length == destinations.length, "Input lengths must match");
544 
545         for (uint i = 0; i < names.length; i++) {
546             bytes32 name = names[i];
547             address destination = destinations[i];
548             repository[name] = destination;
549             emit AddressImported(name, destination);
550         }
551     }
552 
553     /* ========= PUBLIC FUNCTIONS ========== */
554 
555     function rebuildCaches(MixinResolver[] calldata destinations) external {
556         for (uint i = 0; i < destinations.length; i++) {
557             destinations[i].rebuildCache();
558         }
559     }
560 
561     /* ========== VIEWS ========== */
562 
563     function areAddressesImported(bytes32[] calldata names, address[] calldata destinations) external view returns (bool) {
564         for (uint i = 0; i < names.length; i++) {
565             if (repository[names[i]] != destinations[i]) {
566                 return false;
567             }
568         }
569         return true;
570     }
571 
572     function getAddress(bytes32 name) external view returns (address) {
573         return repository[name];
574     }
575 
576     function requireAndGetAddress(bytes32 name, string calldata reason) external view returns (address) {
577         address _foundAddress = repository[name];
578         require(_foundAddress != address(0), reason);
579         return _foundAddress;
580     }
581 
582     function getSynth(bytes32 key) external view returns (address) {
583         IIssuer issuer = IIssuer(repository["Issuer"]);
584         require(address(issuer) != address(0), "Cannot find Issuer address");
585         return address(issuer.synths(key));
586     }
587 
588     /* ========== EVENTS ========== */
589 
590     event AddressImported(bytes32 name, address destination);
591 }
592 
593 
594 // Internal references
595 
596 
597 // https://docs.synthetix.io/contracts/source/contracts/mixinresolver
598 contract MixinResolver {
599     AddressResolver public resolver;
600 
601     mapping(bytes32 => address) private addressCache;
602 
603     constructor(address _resolver) internal {
604         resolver = AddressResolver(_resolver);
605     }
606 
607     /* ========== INTERNAL FUNCTIONS ========== */
608 
609     function combineArrays(bytes32[] memory first, bytes32[] memory second)
610         internal
611         pure
612         returns (bytes32[] memory combination)
613     {
614         combination = new bytes32[](first.length + second.length);
615 
616         for (uint i = 0; i < first.length; i++) {
617             combination[i] = first[i];
618         }
619 
620         for (uint j = 0; j < second.length; j++) {
621             combination[first.length + j] = second[j];
622         }
623     }
624 
625     /* ========== PUBLIC FUNCTIONS ========== */
626 
627     // Note: this function is public not external in order for it to be overridden and invoked via super in subclasses
628     function resolverAddressesRequired() public view returns (bytes32[] memory addresses) {}
629 
630     function rebuildCache() public {
631         bytes32[] memory requiredAddresses = resolverAddressesRequired();
632         // The resolver must call this function whenver it updates its state
633         for (uint i = 0; i < requiredAddresses.length; i++) {
634             bytes32 name = requiredAddresses[i];
635             // Note: can only be invoked once the resolver has all the targets needed added
636             address destination =
637                 resolver.requireAndGetAddress(name, string(abi.encodePacked("Resolver missing target: ", name)));
638             addressCache[name] = destination;
639             emit CacheUpdated(name, destination);
640         }
641     }
642 
643     /* ========== VIEWS ========== */
644 
645     function isResolverCached() external view returns (bool) {
646         bytes32[] memory requiredAddresses = resolverAddressesRequired();
647         for (uint i = 0; i < requiredAddresses.length; i++) {
648             bytes32 name = requiredAddresses[i];
649             // false if our cache is invalid or if the resolver doesn't have the required address
650             if (resolver.getAddress(name) != addressCache[name] || addressCache[name] == address(0)) {
651                 return false;
652             }
653         }
654 
655         return true;
656     }
657 
658     /* ========== INTERNAL FUNCTIONS ========== */
659 
660     function requireAndGetAddress(bytes32 name) internal view returns (address) {
661         address _foundAddress = addressCache[name];
662         require(_foundAddress != address(0), string(abi.encodePacked("Missing address: ", name)));
663         return _foundAddress;
664     }
665 
666     /* ========== EVENTS ========== */
667 
668     event CacheUpdated(bytes32 name, address destination);
669 }
670 
671 
672 // https://docs.synthetix.io/contracts/source/interfaces/iflexiblestorage
673 interface IFlexibleStorage {
674     // Views
675     function getUIntValue(bytes32 contractName, bytes32 record) external view returns (uint);
676 
677     function getUIntValues(bytes32 contractName, bytes32[] calldata records) external view returns (uint[] memory);
678 
679     function getIntValue(bytes32 contractName, bytes32 record) external view returns (int);
680 
681     function getIntValues(bytes32 contractName, bytes32[] calldata records) external view returns (int[] memory);
682 
683     function getAddressValue(bytes32 contractName, bytes32 record) external view returns (address);
684 
685     function getAddressValues(bytes32 contractName, bytes32[] calldata records) external view returns (address[] memory);
686 
687     function getBoolValue(bytes32 contractName, bytes32 record) external view returns (bool);
688 
689     function getBoolValues(bytes32 contractName, bytes32[] calldata records) external view returns (bool[] memory);
690 
691     function getBytes32Value(bytes32 contractName, bytes32 record) external view returns (bytes32);
692 
693     function getBytes32Values(bytes32 contractName, bytes32[] calldata records) external view returns (bytes32[] memory);
694 
695     // Mutative functions
696     function deleteUIntValue(bytes32 contractName, bytes32 record) external;
697 
698     function deleteIntValue(bytes32 contractName, bytes32 record) external;
699 
700     function deleteAddressValue(bytes32 contractName, bytes32 record) external;
701 
702     function deleteBoolValue(bytes32 contractName, bytes32 record) external;
703 
704     function deleteBytes32Value(bytes32 contractName, bytes32 record) external;
705 
706     function setUIntValue(
707         bytes32 contractName,
708         bytes32 record,
709         uint value
710     ) external;
711 
712     function setUIntValues(
713         bytes32 contractName,
714         bytes32[] calldata records,
715         uint[] calldata values
716     ) external;
717 
718     function setIntValue(
719         bytes32 contractName,
720         bytes32 record,
721         int value
722     ) external;
723 
724     function setIntValues(
725         bytes32 contractName,
726         bytes32[] calldata records,
727         int[] calldata values
728     ) external;
729 
730     function setAddressValue(
731         bytes32 contractName,
732         bytes32 record,
733         address value
734     ) external;
735 
736     function setAddressValues(
737         bytes32 contractName,
738         bytes32[] calldata records,
739         address[] calldata values
740     ) external;
741 
742     function setBoolValue(
743         bytes32 contractName,
744         bytes32 record,
745         bool value
746     ) external;
747 
748     function setBoolValues(
749         bytes32 contractName,
750         bytes32[] calldata records,
751         bool[] calldata values
752     ) external;
753 
754     function setBytes32Value(
755         bytes32 contractName,
756         bytes32 record,
757         bytes32 value
758     ) external;
759 
760     function setBytes32Values(
761         bytes32 contractName,
762         bytes32[] calldata records,
763         bytes32[] calldata values
764     ) external;
765 }
766 
767 
768 // Internal references
769 
770 
771 // https://docs.synthetix.io/contracts/source/contracts/mixinsystemsettings
772 contract MixinSystemSettings is MixinResolver {
773     bytes32 internal constant SETTING_CONTRACT_NAME = "SystemSettings";
774 
775     bytes32 internal constant SETTING_WAITING_PERIOD_SECS = "waitingPeriodSecs";
776     bytes32 internal constant SETTING_PRICE_DEVIATION_THRESHOLD_FACTOR = "priceDeviationThresholdFactor";
777     bytes32 internal constant SETTING_ISSUANCE_RATIO = "issuanceRatio";
778     bytes32 internal constant SETTING_FEE_PERIOD_DURATION = "feePeriodDuration";
779     bytes32 internal constant SETTING_TARGET_THRESHOLD = "targetThreshold";
780     bytes32 internal constant SETTING_LIQUIDATION_DELAY = "liquidationDelay";
781     bytes32 internal constant SETTING_LIQUIDATION_RATIO = "liquidationRatio";
782     bytes32 internal constant SETTING_LIQUIDATION_PENALTY = "liquidationPenalty";
783     bytes32 internal constant SETTING_RATE_STALE_PERIOD = "rateStalePeriod";
784     bytes32 internal constant SETTING_EXCHANGE_FEE_RATE = "exchangeFeeRate";
785     bytes32 internal constant SETTING_MINIMUM_STAKE_TIME = "minimumStakeTime";
786     bytes32 internal constant SETTING_AGGREGATOR_WARNING_FLAGS = "aggregatorWarningFlags";
787     bytes32 internal constant SETTING_TRADING_REWARDS_ENABLED = "tradingRewardsEnabled";
788     bytes32 internal constant SETTING_DEBT_SNAPSHOT_STALE_TIME = "debtSnapshotStaleTime";
789     bytes32 internal constant SETTING_CROSS_DOMAIN_DEPOSIT_GAS_LIMIT = "crossDomainDepositGasLimit";
790     bytes32 internal constant SETTING_CROSS_DOMAIN_ESCROW_GAS_LIMIT = "crossDomainEscrowGasLimit";
791     bytes32 internal constant SETTING_CROSS_DOMAIN_REWARD_GAS_LIMIT = "crossDomainRewardGasLimit";
792     bytes32 internal constant SETTING_CROSS_DOMAIN_WITHDRAWAL_GAS_LIMIT = "crossDomainWithdrawalGasLimit";
793     bytes32 internal constant SETTING_ETHER_WRAPPER_MAX_ETH = "etherWrapperMaxETH";
794     bytes32 internal constant SETTING_ETHER_WRAPPER_MINT_FEE_RATE = "etherWrapperMintFeeRate";
795     bytes32 internal constant SETTING_ETHER_WRAPPER_BURN_FEE_RATE = "etherWrapperBurnFeeRate";
796     bytes32 internal constant SETTING_WRAPPER_MAX_TOKEN_AMOUNT = "wrapperMaxTokens";
797     bytes32 internal constant SETTING_WRAPPER_MINT_FEE_RATE = "wrapperMintFeeRate";
798     bytes32 internal constant SETTING_WRAPPER_BURN_FEE_RATE = "wrapperBurnFeeRate";
799     bytes32 internal constant SETTING_MIN_CRATIO = "minCratio";
800     bytes32 internal constant SETTING_NEW_COLLATERAL_MANAGER = "newCollateralManager";
801     bytes32 internal constant SETTING_INTERACTION_DELAY = "interactionDelay";
802     bytes32 internal constant SETTING_COLLAPSE_FEE_RATE = "collapseFeeRate";
803     bytes32 internal constant SETTING_ATOMIC_MAX_VOLUME_PER_BLOCK = "atomicMaxVolumePerBlock";
804     bytes32 internal constant SETTING_ATOMIC_TWAP_WINDOW = "atomicTwapWindow";
805     bytes32 internal constant SETTING_ATOMIC_EQUIVALENT_FOR_DEX_PRICING = "atomicEquivalentForDexPricing";
806     bytes32 internal constant SETTING_ATOMIC_EXCHANGE_FEE_RATE = "atomicExchangeFeeRate";
807     bytes32 internal constant SETTING_ATOMIC_PRICE_BUFFER = "atomicPriceBuffer";
808     bytes32 internal constant SETTING_ATOMIC_VOLATILITY_CONSIDERATION_WINDOW = "atomicVolConsiderationWindow";
809     bytes32 internal constant SETTING_ATOMIC_VOLATILITY_UPDATE_THRESHOLD = "atomicVolUpdateThreshold";
810 
811     bytes32 internal constant CONTRACT_FLEXIBLESTORAGE = "FlexibleStorage";
812 
813     enum CrossDomainMessageGasLimits {Deposit, Escrow, Reward, Withdrawal}
814 
815     constructor(address _resolver) internal MixinResolver(_resolver) {}
816 
817     function resolverAddressesRequired() public view returns (bytes32[] memory addresses) {
818         addresses = new bytes32[](1);
819         addresses[0] = CONTRACT_FLEXIBLESTORAGE;
820     }
821 
822     function flexibleStorage() internal view returns (IFlexibleStorage) {
823         return IFlexibleStorage(requireAndGetAddress(CONTRACT_FLEXIBLESTORAGE));
824     }
825 
826     function _getGasLimitSetting(CrossDomainMessageGasLimits gasLimitType) internal pure returns (bytes32) {
827         if (gasLimitType == CrossDomainMessageGasLimits.Deposit) {
828             return SETTING_CROSS_DOMAIN_DEPOSIT_GAS_LIMIT;
829         } else if (gasLimitType == CrossDomainMessageGasLimits.Escrow) {
830             return SETTING_CROSS_DOMAIN_ESCROW_GAS_LIMIT;
831         } else if (gasLimitType == CrossDomainMessageGasLimits.Reward) {
832             return SETTING_CROSS_DOMAIN_REWARD_GAS_LIMIT;
833         } else if (gasLimitType == CrossDomainMessageGasLimits.Withdrawal) {
834             return SETTING_CROSS_DOMAIN_WITHDRAWAL_GAS_LIMIT;
835         } else {
836             revert("Unknown gas limit type");
837         }
838     }
839 
840     function getCrossDomainMessageGasLimit(CrossDomainMessageGasLimits gasLimitType) internal view returns (uint) {
841         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, _getGasLimitSetting(gasLimitType));
842     }
843 
844     function getTradingRewardsEnabled() internal view returns (bool) {
845         return flexibleStorage().getBoolValue(SETTING_CONTRACT_NAME, SETTING_TRADING_REWARDS_ENABLED);
846     }
847 
848     function getWaitingPeriodSecs() internal view returns (uint) {
849         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_WAITING_PERIOD_SECS);
850     }
851 
852     function getPriceDeviationThresholdFactor() internal view returns (uint) {
853         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_PRICE_DEVIATION_THRESHOLD_FACTOR);
854     }
855 
856     function getIssuanceRatio() internal view returns (uint) {
857         // lookup on flexible storage directly for gas savings (rather than via SystemSettings)
858         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_ISSUANCE_RATIO);
859     }
860 
861     function getFeePeriodDuration() internal view returns (uint) {
862         // lookup on flexible storage directly for gas savings (rather than via SystemSettings)
863         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_FEE_PERIOD_DURATION);
864     }
865 
866     function getTargetThreshold() internal view returns (uint) {
867         // lookup on flexible storage directly for gas savings (rather than via SystemSettings)
868         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_TARGET_THRESHOLD);
869     }
870 
871     function getLiquidationDelay() internal view returns (uint) {
872         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_LIQUIDATION_DELAY);
873     }
874 
875     function getLiquidationRatio() internal view returns (uint) {
876         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_LIQUIDATION_RATIO);
877     }
878 
879     function getLiquidationPenalty() internal view returns (uint) {
880         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_LIQUIDATION_PENALTY);
881     }
882 
883     function getRateStalePeriod() internal view returns (uint) {
884         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_RATE_STALE_PERIOD);
885     }
886 
887     function getExchangeFeeRate(bytes32 currencyKey) internal view returns (uint) {
888         return
889             flexibleStorage().getUIntValue(
890                 SETTING_CONTRACT_NAME,
891                 keccak256(abi.encodePacked(SETTING_EXCHANGE_FEE_RATE, currencyKey))
892             );
893     }
894 
895     function getMinimumStakeTime() internal view returns (uint) {
896         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_MINIMUM_STAKE_TIME);
897     }
898 
899     function getAggregatorWarningFlags() internal view returns (address) {
900         return flexibleStorage().getAddressValue(SETTING_CONTRACT_NAME, SETTING_AGGREGATOR_WARNING_FLAGS);
901     }
902 
903     function getDebtSnapshotStaleTime() internal view returns (uint) {
904         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_DEBT_SNAPSHOT_STALE_TIME);
905     }
906 
907     function getEtherWrapperMaxETH() internal view returns (uint) {
908         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_ETHER_WRAPPER_MAX_ETH);
909     }
910 
911     function getEtherWrapperMintFeeRate() internal view returns (uint) {
912         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_ETHER_WRAPPER_MINT_FEE_RATE);
913     }
914 
915     function getEtherWrapperBurnFeeRate() internal view returns (uint) {
916         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_ETHER_WRAPPER_BURN_FEE_RATE);
917     }
918 
919     function getWrapperMaxTokenAmount(address wrapper) internal view returns (uint) {
920         return
921             flexibleStorage().getUIntValue(
922                 SETTING_CONTRACT_NAME,
923                 keccak256(abi.encodePacked(SETTING_WRAPPER_MAX_TOKEN_AMOUNT, wrapper))
924             );
925     }
926 
927     function getWrapperMintFeeRate(address wrapper) internal view returns (int) {
928         return
929             flexibleStorage().getIntValue(
930                 SETTING_CONTRACT_NAME,
931                 keccak256(abi.encodePacked(SETTING_WRAPPER_MINT_FEE_RATE, wrapper))
932             );
933     }
934 
935     function getWrapperBurnFeeRate(address wrapper) internal view returns (int) {
936         return
937             flexibleStorage().getIntValue(
938                 SETTING_CONTRACT_NAME,
939                 keccak256(abi.encodePacked(SETTING_WRAPPER_BURN_FEE_RATE, wrapper))
940             );
941     }
942 
943     function getMinCratio(address collateral) internal view returns (uint) {
944         return
945             flexibleStorage().getUIntValue(
946                 SETTING_CONTRACT_NAME,
947                 keccak256(abi.encodePacked(SETTING_MIN_CRATIO, collateral))
948             );
949     }
950 
951     function getNewCollateralManager(address collateral) internal view returns (address) {
952         return
953             flexibleStorage().getAddressValue(
954                 SETTING_CONTRACT_NAME,
955                 keccak256(abi.encodePacked(SETTING_NEW_COLLATERAL_MANAGER, collateral))
956             );
957     }
958 
959     function getInteractionDelay(address collateral) internal view returns (uint) {
960         return
961             flexibleStorage().getUIntValue(
962                 SETTING_CONTRACT_NAME,
963                 keccak256(abi.encodePacked(SETTING_INTERACTION_DELAY, collateral))
964             );
965     }
966 
967     function getCollapseFeeRate(address collateral) internal view returns (uint) {
968         return
969             flexibleStorage().getUIntValue(
970                 SETTING_CONTRACT_NAME,
971                 keccak256(abi.encodePacked(SETTING_COLLAPSE_FEE_RATE, collateral))
972             );
973     }
974 
975     function getAtomicMaxVolumePerBlock() internal view returns (uint) {
976         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_ATOMIC_MAX_VOLUME_PER_BLOCK);
977     }
978 
979     function getAtomicTwapWindow() internal view returns (uint) {
980         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_ATOMIC_TWAP_WINDOW);
981     }
982 
983     function getAtomicEquivalentForDexPricing(bytes32 currencyKey) internal view returns (address) {
984         return
985             flexibleStorage().getAddressValue(
986                 SETTING_CONTRACT_NAME,
987                 keccak256(abi.encodePacked(SETTING_ATOMIC_EQUIVALENT_FOR_DEX_PRICING, currencyKey))
988             );
989     }
990 
991     function getAtomicExchangeFeeRate(bytes32 currencyKey) internal view returns (uint) {
992         return
993             flexibleStorage().getUIntValue(
994                 SETTING_CONTRACT_NAME,
995                 keccak256(abi.encodePacked(SETTING_ATOMIC_EXCHANGE_FEE_RATE, currencyKey))
996             );
997     }
998 
999     function getAtomicPriceBuffer(bytes32 currencyKey) internal view returns (uint) {
1000         return
1001             flexibleStorage().getUIntValue(
1002                 SETTING_CONTRACT_NAME,
1003                 keccak256(abi.encodePacked(SETTING_ATOMIC_PRICE_BUFFER, currencyKey))
1004             );
1005     }
1006 
1007     function getAtomicVolatilityConsiderationWindow(bytes32 currencyKey) internal view returns (uint) {
1008         return
1009             flexibleStorage().getUIntValue(
1010                 SETTING_CONTRACT_NAME,
1011                 keccak256(abi.encodePacked(SETTING_ATOMIC_VOLATILITY_CONSIDERATION_WINDOW, currencyKey))
1012             );
1013     }
1014 
1015     function getAtomicVolatilityUpdateThreshold(bytes32 currencyKey) internal view returns (uint) {
1016         return
1017             flexibleStorage().getUIntValue(
1018                 SETTING_CONTRACT_NAME,
1019                 keccak256(abi.encodePacked(SETTING_ATOMIC_VOLATILITY_UPDATE_THRESHOLD, currencyKey))
1020             );
1021     }
1022 }
1023 
1024 
1025 interface IDebtCache {
1026     // Views
1027 
1028     function cachedDebt() external view returns (uint);
1029 
1030     function cachedSynthDebt(bytes32 currencyKey) external view returns (uint);
1031 
1032     function cacheTimestamp() external view returns (uint);
1033 
1034     function cacheInvalid() external view returns (bool);
1035 
1036     function cacheStale() external view returns (bool);
1037 
1038     function currentSynthDebts(bytes32[] calldata currencyKeys)
1039         external
1040         view
1041         returns (
1042             uint[] memory debtValues,
1043             uint excludedDebt,
1044             bool anyRateIsInvalid
1045         );
1046 
1047     function cachedSynthDebts(bytes32[] calldata currencyKeys) external view returns (uint[] memory debtValues);
1048 
1049     function totalNonSnxBackedDebt() external view returns (uint excludedDebt, bool isInvalid);
1050 
1051     function currentDebt() external view returns (uint debt, bool anyRateIsInvalid);
1052 
1053     function cacheInfo()
1054         external
1055         view
1056         returns (
1057             uint debt,
1058             uint timestamp,
1059             bool isInvalid,
1060             bool isStale
1061         );
1062 
1063     // Mutative functions
1064 
1065     function updateCachedSynthDebts(bytes32[] calldata currencyKeys) external;
1066 
1067     function updateCachedSynthDebtWithRate(bytes32 currencyKey, uint currencyRate) external;
1068 
1069     function updateCachedSynthDebtsWithRates(bytes32[] calldata currencyKeys, uint[] calldata currencyRates) external;
1070 
1071     function updateDebtCacheValidity(bool currentlyInvalid) external;
1072 
1073     function purgeCachedSynthDebt(bytes32 currencyKey) external;
1074 
1075     function takeDebtSnapshot() external;
1076 
1077     function recordExcludedDebtChange(bytes32 currencyKey, int256 delta) external;
1078 
1079     function updateCachedsUSDDebt(int amount) external;
1080 }
1081 
1082 
1083 interface IVirtualSynth {
1084     // Views
1085     function balanceOfUnderlying(address account) external view returns (uint);
1086 
1087     function rate() external view returns (uint);
1088 
1089     function readyToSettle() external view returns (bool);
1090 
1091     function secsLeftInWaitingPeriod() external view returns (uint);
1092 
1093     function settled() external view returns (bool);
1094 
1095     function synth() external view returns (ISynth);
1096 
1097     // Mutative functions
1098     function settle(address account) external;
1099 }
1100 
1101 
1102 // https://docs.synthetix.io/contracts/source/interfaces/iexchanger
1103 interface IExchanger {
1104     // Views
1105     function calculateAmountAfterSettlement(
1106         address from,
1107         bytes32 currencyKey,
1108         uint amount,
1109         uint refunded
1110     ) external view returns (uint amountAfterSettlement);
1111 
1112     function isSynthRateInvalid(bytes32 currencyKey) external view returns (bool);
1113 
1114     function maxSecsLeftInWaitingPeriod(address account, bytes32 currencyKey) external view returns (uint);
1115 
1116     function settlementOwing(address account, bytes32 currencyKey)
1117         external
1118         view
1119         returns (
1120             uint reclaimAmount,
1121             uint rebateAmount,
1122             uint numEntries
1123         );
1124 
1125     function hasWaitingPeriodOrSettlementOwing(address account, bytes32 currencyKey) external view returns (bool);
1126 
1127     function feeRateForExchange(bytes32 sourceCurrencyKey, bytes32 destinationCurrencyKey)
1128         external
1129         view
1130         returns (uint exchangeFeeRate);
1131 
1132     function getAmountsForExchange(
1133         uint sourceAmount,
1134         bytes32 sourceCurrencyKey,
1135         bytes32 destinationCurrencyKey
1136     )
1137         external
1138         view
1139         returns (
1140             uint amountReceived,
1141             uint fee,
1142             uint exchangeFeeRate
1143         );
1144 
1145     function priceDeviationThresholdFactor() external view returns (uint);
1146 
1147     function waitingPeriodSecs() external view returns (uint);
1148 
1149     // Mutative functions
1150     function exchange(
1151         address exchangeForAddress,
1152         address from,
1153         bytes32 sourceCurrencyKey,
1154         uint sourceAmount,
1155         bytes32 destinationCurrencyKey,
1156         address destinationAddress,
1157         bool virtualSynth,
1158         address rewardAddress,
1159         bytes32 trackingCode
1160     ) external returns (uint amountReceived, IVirtualSynth vSynth);
1161 
1162     function exchangeAtomically(
1163         address from,
1164         bytes32 sourceCurrencyKey,
1165         uint sourceAmount,
1166         bytes32 destinationCurrencyKey,
1167         address destinationAddress,
1168         bytes32 trackingCode
1169     ) external returns (uint amountReceived);
1170 
1171     function settle(address from, bytes32 currencyKey)
1172         external
1173         returns (
1174             uint reclaimed,
1175             uint refunded,
1176             uint numEntries
1177         );
1178 
1179     function resetLastExchangeRate(bytes32[] calldata currencyKeys) external;
1180 
1181     function suspendSynthWithInvalidRate(bytes32 currencyKey) external;
1182 }
1183 
1184 
1185 // https://docs.synthetix.io/contracts/source/interfaces/iexchangerates
1186 interface IExchangeRates {
1187     // Structs
1188     struct RateAndUpdatedTime {
1189         uint216 rate;
1190         uint40 time;
1191     }
1192 
1193     // Views
1194     function aggregators(bytes32 currencyKey) external view returns (address);
1195 
1196     function aggregatorWarningFlags() external view returns (address);
1197 
1198     function anyRateIsInvalid(bytes32[] calldata currencyKeys) external view returns (bool);
1199 
1200     function currentRoundForRate(bytes32 currencyKey) external view returns (uint);
1201 
1202     function currenciesUsingAggregator(address aggregator) external view returns (bytes32[] memory);
1203 
1204     function effectiveValue(
1205         bytes32 sourceCurrencyKey,
1206         uint sourceAmount,
1207         bytes32 destinationCurrencyKey
1208     ) external view returns (uint value);
1209 
1210     function effectiveValueAndRates(
1211         bytes32 sourceCurrencyKey,
1212         uint sourceAmount,
1213         bytes32 destinationCurrencyKey
1214     )
1215         external
1216         view
1217         returns (
1218             uint value,
1219             uint sourceRate,
1220             uint destinationRate
1221         );
1222 
1223     function effectiveAtomicValueAndRates(
1224         bytes32 sourceCurrencyKey,
1225         uint sourceAmount,
1226         bytes32 destinationCurrencyKey
1227     )
1228         external
1229         view
1230         returns (
1231             uint value,
1232             uint systemValue,
1233             uint systemSourceRate,
1234             uint systemDestinationRate
1235         );
1236 
1237     function effectiveValueAtRound(
1238         bytes32 sourceCurrencyKey,
1239         uint sourceAmount,
1240         bytes32 destinationCurrencyKey,
1241         uint roundIdForSrc,
1242         uint roundIdForDest
1243     ) external view returns (uint value);
1244 
1245     function getCurrentRoundId(bytes32 currencyKey) external view returns (uint);
1246 
1247     function getLastRoundIdBeforeElapsedSecs(
1248         bytes32 currencyKey,
1249         uint startingRoundId,
1250         uint startingTimestamp,
1251         uint timediff
1252     ) external view returns (uint);
1253 
1254     function lastRateUpdateTimes(bytes32 currencyKey) external view returns (uint256);
1255 
1256     function oracle() external view returns (address);
1257 
1258     function rateAndTimestampAtRound(bytes32 currencyKey, uint roundId) external view returns (uint rate, uint time);
1259 
1260     function rateAndUpdatedTime(bytes32 currencyKey) external view returns (uint rate, uint time);
1261 
1262     function rateAndInvalid(bytes32 currencyKey) external view returns (uint rate, bool isInvalid);
1263 
1264     function rateForCurrency(bytes32 currencyKey) external view returns (uint);
1265 
1266     function rateIsFlagged(bytes32 currencyKey) external view returns (bool);
1267 
1268     function rateIsInvalid(bytes32 currencyKey) external view returns (bool);
1269 
1270     function rateIsStale(bytes32 currencyKey) external view returns (bool);
1271 
1272     function rateStalePeriod() external view returns (uint);
1273 
1274     function ratesAndUpdatedTimeForCurrencyLastNRounds(bytes32 currencyKey, uint numRounds)
1275         external
1276         view
1277         returns (uint[] memory rates, uint[] memory times);
1278 
1279     function ratesAndInvalidForCurrencies(bytes32[] calldata currencyKeys)
1280         external
1281         view
1282         returns (uint[] memory rates, bool anyRateInvalid);
1283 
1284     function ratesForCurrencies(bytes32[] calldata currencyKeys) external view returns (uint[] memory);
1285 
1286     function synthTooVolatileForAtomicExchange(bytes32 currencyKey) external view returns (bool);
1287 }
1288 
1289 
1290 // https://docs.synthetix.io/contracts/source/interfaces/isystemstatus
1291 interface ISystemStatus {
1292     struct Status {
1293         bool canSuspend;
1294         bool canResume;
1295     }
1296 
1297     struct Suspension {
1298         bool suspended;
1299         // reason is an integer code,
1300         // 0 => no reason, 1 => upgrading, 2+ => defined by system usage
1301         uint248 reason;
1302     }
1303 
1304     // Views
1305     function accessControl(bytes32 section, address account) external view returns (bool canSuspend, bool canResume);
1306 
1307     function requireSystemActive() external view;
1308 
1309     function requireIssuanceActive() external view;
1310 
1311     function requireExchangeActive() external view;
1312 
1313     function requireExchangeBetweenSynthsAllowed(bytes32 sourceCurrencyKey, bytes32 destinationCurrencyKey) external view;
1314 
1315     function requireSynthActive(bytes32 currencyKey) external view;
1316 
1317     function requireSynthsActive(bytes32 sourceCurrencyKey, bytes32 destinationCurrencyKey) external view;
1318 
1319     function systemSuspension() external view returns (bool suspended, uint248 reason);
1320 
1321     function issuanceSuspension() external view returns (bool suspended, uint248 reason);
1322 
1323     function exchangeSuspension() external view returns (bool suspended, uint248 reason);
1324 
1325     function synthExchangeSuspension(bytes32 currencyKey) external view returns (bool suspended, uint248 reason);
1326 
1327     function synthSuspension(bytes32 currencyKey) external view returns (bool suspended, uint248 reason);
1328 
1329     function getSynthExchangeSuspensions(bytes32[] calldata synths)
1330         external
1331         view
1332         returns (bool[] memory exchangeSuspensions, uint256[] memory reasons);
1333 
1334     function getSynthSuspensions(bytes32[] calldata synths)
1335         external
1336         view
1337         returns (bool[] memory suspensions, uint256[] memory reasons);
1338 
1339     // Restricted functions
1340     function suspendSynth(bytes32 currencyKey, uint256 reason) external;
1341 
1342     function updateAccessControl(
1343         bytes32 section,
1344         address account,
1345         bool canSuspend,
1346         bool canResume
1347     ) external;
1348 }
1349 
1350 
1351 // https://docs.synthetix.io/contracts/source/interfaces/ierc20
1352 interface IERC20 {
1353     // ERC20 Optional Views
1354     function name() external view returns (string memory);
1355 
1356     function symbol() external view returns (string memory);
1357 
1358     function decimals() external view returns (uint8);
1359 
1360     // Views
1361     function totalSupply() external view returns (uint);
1362 
1363     function balanceOf(address owner) external view returns (uint);
1364 
1365     function allowance(address owner, address spender) external view returns (uint);
1366 
1367     // Mutative functions
1368     function transfer(address to, uint value) external returns (bool);
1369 
1370     function approve(address spender, uint value) external returns (bool);
1371 
1372     function transferFrom(
1373         address from,
1374         address to,
1375         uint value
1376     ) external returns (bool);
1377 
1378     // Events
1379     event Transfer(address indexed from, address indexed to, uint value);
1380 
1381     event Approval(address indexed owner, address indexed spender, uint value);
1382 }
1383 
1384 
1385 interface ICollateralManager {
1386     // Manager information
1387     function hasCollateral(address collateral) external view returns (bool);
1388 
1389     function isSynthManaged(bytes32 currencyKey) external view returns (bool);
1390 
1391     // State information
1392     function long(bytes32 synth) external view returns (uint amount);
1393 
1394     function short(bytes32 synth) external view returns (uint amount);
1395 
1396     function totalLong() external view returns (uint susdValue, bool anyRateIsInvalid);
1397 
1398     function totalShort() external view returns (uint susdValue, bool anyRateIsInvalid);
1399 
1400     function getBorrowRate() external view returns (uint borrowRate, bool anyRateIsInvalid);
1401 
1402     function getShortRate(bytes32 synth) external view returns (uint shortRate, bool rateIsInvalid);
1403 
1404     function getRatesAndTime(uint index)
1405         external
1406         view
1407         returns (
1408             uint entryRate,
1409             uint lastRate,
1410             uint lastUpdated,
1411             uint newIndex
1412         );
1413 
1414     function getShortRatesAndTime(bytes32 currency, uint index)
1415         external
1416         view
1417         returns (
1418             uint entryRate,
1419             uint lastRate,
1420             uint lastUpdated,
1421             uint newIndex
1422         );
1423 
1424     function exceedsDebtLimit(uint amount, bytes32 currency) external view returns (bool canIssue, bool anyRateIsInvalid);
1425 
1426     function areSynthsAndCurrenciesSet(bytes32[] calldata requiredSynthNamesInResolver, bytes32[] calldata synthKeys)
1427         external
1428         view
1429         returns (bool);
1430 
1431     function areShortableSynthsSet(bytes32[] calldata requiredSynthNamesInResolver, bytes32[] calldata synthKeys)
1432         external
1433         view
1434         returns (bool);
1435 
1436     // Loans
1437     function getNewLoanId() external returns (uint id);
1438 
1439     // Manager mutative
1440     function addCollaterals(address[] calldata collaterals) external;
1441 
1442     function removeCollaterals(address[] calldata collaterals) external;
1443 
1444     function addSynths(bytes32[] calldata synthNamesInResolver, bytes32[] calldata synthKeys) external;
1445 
1446     function removeSynths(bytes32[] calldata synths, bytes32[] calldata synthKeys) external;
1447 
1448     function addShortableSynths(bytes32[] calldata requiredSynthNamesInResolver, bytes32[] calldata synthKeys) external;
1449 
1450     function removeShortableSynths(bytes32[] calldata synths) external;
1451 
1452     // State mutative
1453 
1454     function incrementLongs(bytes32 synth, uint amount) external;
1455 
1456     function decrementLongs(bytes32 synth, uint amount) external;
1457 
1458     function incrementShorts(bytes32 synth, uint amount) external;
1459 
1460     function decrementShorts(bytes32 synth, uint amount) external;
1461 
1462     function accrueInterest(
1463         uint interestIndex,
1464         bytes32 currency,
1465         bool isShort
1466     ) external returns (uint difference, uint index);
1467 
1468     function updateBorrowRatesCollateral(uint rate) external;
1469 
1470     function updateShortRatesCollateral(bytes32 currency, uint rate) external;
1471 }
1472 
1473 
1474 interface IWETH {
1475     // ERC20 Optional Views
1476     function name() external view returns (string memory);
1477 
1478     function symbol() external view returns (string memory);
1479 
1480     function decimals() external view returns (uint8);
1481 
1482     // Views
1483     function totalSupply() external view returns (uint);
1484 
1485     function balanceOf(address owner) external view returns (uint);
1486 
1487     function allowance(address owner, address spender) external view returns (uint);
1488 
1489     // Mutative functions
1490     function transfer(address to, uint value) external returns (bool);
1491 
1492     function approve(address spender, uint value) external returns (bool);
1493 
1494     function transferFrom(
1495         address from,
1496         address to,
1497         uint value
1498     ) external returns (bool);
1499 
1500     // WETH-specific functions.
1501     function deposit() external payable;
1502 
1503     function withdraw(uint amount) external;
1504 
1505     // Events
1506     event Transfer(address indexed from, address indexed to, uint value);
1507     event Approval(address indexed owner, address indexed spender, uint value);
1508     event Deposit(address indexed to, uint amount);
1509     event Withdrawal(address indexed to, uint amount);
1510 }
1511 
1512 
1513 // https://docs.synthetix.io/contracts/source/interfaces/ietherwrapper
1514 contract IEtherWrapper {
1515     function mint(uint amount) external;
1516 
1517     function burn(uint amount) external;
1518 
1519     function distributeFees() external;
1520 
1521     function capacity() external view returns (uint);
1522 
1523     function getReserves() external view returns (uint);
1524 
1525     function totalIssuedSynths() external view returns (uint);
1526 
1527     function calculateMintFee(uint amount) public view returns (uint);
1528 
1529     function calculateBurnFee(uint amount) public view returns (uint);
1530 
1531     function maxETH() public view returns (uint256);
1532 
1533     function mintFeeRate() public view returns (uint256);
1534 
1535     function burnFeeRate() public view returns (uint256);
1536 
1537     function weth() public view returns (IWETH);
1538 }
1539 
1540 
1541 // https://docs.synthetix.io/contracts/source/interfaces/iwrapperfactory
1542 interface IWrapperFactory {
1543     function isWrapper(address possibleWrapper) external view returns (bool);
1544 
1545     function createWrapper(
1546         IERC20 token,
1547         bytes32 currencyKey,
1548         bytes32 synthContractName
1549     ) external returns (address);
1550 
1551     function distributeFees() external;
1552 }
1553 
1554 
1555 // Inheritance
1556 
1557 
1558 // Libraries
1559 
1560 
1561 // Internal references
1562 
1563 
1564 //
1565 // The debt cache (SIP-91) caches the global debt and the debt of each synth in the system.
1566 // Debt is denominated by the synth supply multiplied by its current exchange rate.
1567 //
1568 // The cache can be invalidated when an exchange rate changes, and thereafter must be
1569 // updated by performing a debt snapshot, which recomputes the global debt sum using
1570 // current synth supplies and exchange rates. This is performed usually by a snapshot keeper.
1571 //
1572 // Some synths are backed by non-SNX collateral, such as sETH being backed by ETH
1573 // held in the EtherWrapper (SIP-112). This debt is called "excluded debt" and is
1574 // excluded from the global debt in `_cachedDebt`.
1575 //
1576 // https://docs.synthetix.io/contracts/source/contracts/debtcache
1577 contract BaseDebtCache is Owned, MixinSystemSettings, IDebtCache {
1578     using SafeMath for uint;
1579     using SafeDecimalMath for uint;
1580 
1581     uint internal _cachedDebt;
1582     mapping(bytes32 => uint) internal _cachedSynthDebt;
1583     mapping(bytes32 => uint) internal _excludedIssuedDebt;
1584     uint internal _cacheTimestamp;
1585     bool internal _cacheInvalid = true;
1586 
1587     /* ========== ENCODED NAMES ========== */
1588 
1589     bytes32 internal constant sUSD = "sUSD";
1590     bytes32 internal constant sETH = "sETH";
1591 
1592     /* ========== ADDRESS RESOLVER CONFIGURATION ========== */
1593 
1594     bytes32 private constant CONTRACT_ISSUER = "Issuer";
1595     bytes32 private constant CONTRACT_EXCHANGER = "Exchanger";
1596     bytes32 private constant CONTRACT_EXRATES = "ExchangeRates";
1597     bytes32 private constant CONTRACT_SYSTEMSTATUS = "SystemStatus";
1598     bytes32 private constant CONTRACT_COLLATERALMANAGER = "CollateralManager";
1599     bytes32 private constant CONTRACT_ETHER_WRAPPER = "EtherWrapper";
1600     bytes32 private constant CONTRACT_WRAPPER_FACTORY = "WrapperFactory";
1601 
1602     constructor(address _owner, address _resolver) public Owned(_owner) MixinSystemSettings(_resolver) {}
1603 
1604     /* ========== VIEWS ========== */
1605 
1606     function resolverAddressesRequired() public view returns (bytes32[] memory addresses) {
1607         bytes32[] memory existingAddresses = MixinSystemSettings.resolverAddressesRequired();
1608         bytes32[] memory newAddresses = new bytes32[](7);
1609         newAddresses[0] = CONTRACT_ISSUER;
1610         newAddresses[1] = CONTRACT_EXCHANGER;
1611         newAddresses[2] = CONTRACT_EXRATES;
1612         newAddresses[3] = CONTRACT_SYSTEMSTATUS;
1613         newAddresses[4] = CONTRACT_COLLATERALMANAGER;
1614         newAddresses[5] = CONTRACT_WRAPPER_FACTORY;
1615         newAddresses[6] = CONTRACT_ETHER_WRAPPER;
1616         addresses = combineArrays(existingAddresses, newAddresses);
1617     }
1618 
1619     function issuer() internal view returns (IIssuer) {
1620         return IIssuer(requireAndGetAddress(CONTRACT_ISSUER));
1621     }
1622 
1623     function exchanger() internal view returns (IExchanger) {
1624         return IExchanger(requireAndGetAddress(CONTRACT_EXCHANGER));
1625     }
1626 
1627     function exchangeRates() internal view returns (IExchangeRates) {
1628         return IExchangeRates(requireAndGetAddress(CONTRACT_EXRATES));
1629     }
1630 
1631     function systemStatus() internal view returns (ISystemStatus) {
1632         return ISystemStatus(requireAndGetAddress(CONTRACT_SYSTEMSTATUS));
1633     }
1634 
1635     function collateralManager() internal view returns (ICollateralManager) {
1636         return ICollateralManager(requireAndGetAddress(CONTRACT_COLLATERALMANAGER));
1637     }
1638 
1639     function etherWrapper() internal view returns (IEtherWrapper) {
1640         return IEtherWrapper(requireAndGetAddress(CONTRACT_ETHER_WRAPPER));
1641     }
1642 
1643     function wrapperFactory() internal view returns (IWrapperFactory) {
1644         return IWrapperFactory(requireAndGetAddress(CONTRACT_WRAPPER_FACTORY));
1645     }
1646 
1647     function debtSnapshotStaleTime() external view returns (uint) {
1648         return getDebtSnapshotStaleTime();
1649     }
1650 
1651     function cachedDebt() external view returns (uint) {
1652         return _cachedDebt;
1653     }
1654 
1655     function cachedSynthDebt(bytes32 currencyKey) external view returns (uint) {
1656         return _cachedSynthDebt[currencyKey];
1657     }
1658 
1659     function cacheTimestamp() external view returns (uint) {
1660         return _cacheTimestamp;
1661     }
1662 
1663     function cacheInvalid() external view returns (bool) {
1664         return _cacheInvalid;
1665     }
1666 
1667     function _cacheStale(uint timestamp) internal view returns (bool) {
1668         // Note a 0 timestamp means that the cache is uninitialised.
1669         // We'll keep the check explicitly in case the stale time is
1670         // ever set to something higher than the current unix time (e.g. to turn off staleness).
1671         return getDebtSnapshotStaleTime() < block.timestamp - timestamp || timestamp == 0;
1672     }
1673 
1674     function cacheStale() external view returns (bool) {
1675         return _cacheStale(_cacheTimestamp);
1676     }
1677 
1678     function _issuedSynthValues(bytes32[] memory currencyKeys, uint[] memory rates)
1679         internal
1680         view
1681         returns (uint[] memory values)
1682     {
1683         uint numValues = currencyKeys.length;
1684         values = new uint[](numValues);
1685         ISynth[] memory synths = issuer().getSynths(currencyKeys);
1686 
1687         for (uint i = 0; i < numValues; i++) {
1688             address synthAddress = address(synths[i]);
1689             require(synthAddress != address(0), "Synth does not exist");
1690             uint supply = IERC20(synthAddress).totalSupply();
1691             values[i] = supply.multiplyDecimalRound(rates[i]);
1692         }
1693 
1694         return (values);
1695     }
1696 
1697     function _currentSynthDebts(bytes32[] memory currencyKeys)
1698         internal
1699         view
1700         returns (
1701             uint[] memory snxIssuedDebts,
1702             uint _excludedDebt,
1703             bool anyRateIsInvalid
1704         )
1705     {
1706         (uint[] memory rates, bool isInvalid) = exchangeRates().ratesAndInvalidForCurrencies(currencyKeys);
1707         uint[] memory values = _issuedSynthValues(currencyKeys, rates);
1708         (uint excludedDebt, bool isAnyNonSnxDebtRateInvalid) = _totalNonSnxBackedDebt(currencyKeys, rates, isInvalid);
1709 
1710         return (values, excludedDebt, isAnyNonSnxDebtRateInvalid);
1711     }
1712 
1713     function currentSynthDebts(bytes32[] calldata currencyKeys)
1714         external
1715         view
1716         returns (
1717             uint[] memory debtValues,
1718             uint excludedDebt,
1719             bool anyRateIsInvalid
1720         )
1721     {
1722         return _currentSynthDebts(currencyKeys);
1723     }
1724 
1725     function _cachedSynthDebts(bytes32[] memory currencyKeys) internal view returns (uint[] memory) {
1726         uint numKeys = currencyKeys.length;
1727         uint[] memory debts = new uint[](numKeys);
1728         for (uint i = 0; i < numKeys; i++) {
1729             debts[i] = _cachedSynthDebt[currencyKeys[i]];
1730         }
1731         return debts;
1732     }
1733 
1734     function cachedSynthDebts(bytes32[] calldata currencyKeys) external view returns (uint[] memory snxIssuedDebts) {
1735         return _cachedSynthDebts(currencyKeys);
1736     }
1737 
1738     function _excludedIssuedDebts(bytes32[] memory currencyKeys) internal view returns (uint[] memory) {
1739         uint numKeys = currencyKeys.length;
1740         uint[] memory debts = new uint[](numKeys);
1741         for (uint i = 0; i < numKeys; i++) {
1742             debts[i] = _excludedIssuedDebt[currencyKeys[i]];
1743         }
1744         return debts;
1745     }
1746 
1747     function excludedIssuedDebts(bytes32[] calldata currencyKeys) external view returns (uint[] memory excludedDebts) {
1748         return _excludedIssuedDebts(currencyKeys);
1749     }
1750 
1751     // Returns the total sUSD debt backed by non-SNX collateral.
1752     function totalNonSnxBackedDebt() external view returns (uint excludedDebt, bool isInvalid) {
1753         bytes32[] memory currencyKeys = issuer().availableCurrencyKeys();
1754         (uint[] memory rates, bool ratesAreInvalid) = exchangeRates().ratesAndInvalidForCurrencies(currencyKeys);
1755 
1756         return _totalNonSnxBackedDebt(currencyKeys, rates, ratesAreInvalid);
1757     }
1758 
1759     function _totalNonSnxBackedDebt(
1760         bytes32[] memory currencyKeys,
1761         uint[] memory rates,
1762         bool ratesAreInvalid
1763     ) internal view returns (uint excludedDebt, bool isInvalid) {
1764         // Calculate excluded debt.
1765         // 1. MultiCollateral long debt + short debt.
1766         (uint longValue, bool anyTotalLongRateIsInvalid) = collateralManager().totalLong();
1767         (uint shortValue, bool anyTotalShortRateIsInvalid) = collateralManager().totalShort();
1768         isInvalid = ratesAreInvalid || anyTotalLongRateIsInvalid || anyTotalShortRateIsInvalid;
1769         excludedDebt = longValue.add(shortValue);
1770 
1771         // 2. EtherWrapper.
1772         // Subtract sETH and sUSD issued by EtherWrapper.
1773         excludedDebt = excludedDebt.add(etherWrapper().totalIssuedSynths());
1774 
1775         // 3. WrapperFactory.
1776         // Get the debt issued by the Wrappers.
1777         for (uint i = 0; i < currencyKeys.length; i++) {
1778             excludedDebt = excludedDebt.add(_excludedIssuedDebt[currencyKeys[i]].multiplyDecimalRound(rates[i]));
1779         }
1780 
1781         return (excludedDebt, isInvalid);
1782     }
1783 
1784     function _currentDebt() internal view returns (uint debt, bool anyRateIsInvalid) {
1785         bytes32[] memory currencyKeys = issuer().availableCurrencyKeys();
1786         (uint[] memory rates, bool isInvalid) = exchangeRates().ratesAndInvalidForCurrencies(currencyKeys);
1787 
1788         // Sum all issued synth values based on their supply.
1789         uint[] memory values = _issuedSynthValues(currencyKeys, rates);
1790         (uint excludedDebt, bool isAnyNonSnxDebtRateInvalid) = _totalNonSnxBackedDebt(currencyKeys, rates, isInvalid);
1791 
1792         uint numValues = values.length;
1793         uint total;
1794         for (uint i; i < numValues; i++) {
1795             total = total.add(values[i]);
1796         }
1797         total = total < excludedDebt ? 0 : total.sub(excludedDebt);
1798 
1799         return (total, isAnyNonSnxDebtRateInvalid);
1800     }
1801 
1802     function currentDebt() external view returns (uint debt, bool anyRateIsInvalid) {
1803         return _currentDebt();
1804     }
1805 
1806     function cacheInfo()
1807         external
1808         view
1809         returns (
1810             uint debt,
1811             uint timestamp,
1812             bool isInvalid,
1813             bool isStale
1814         )
1815     {
1816         uint time = _cacheTimestamp;
1817         return (_cachedDebt, time, _cacheInvalid, _cacheStale(time));
1818     }
1819 
1820     /* ========== MUTATIVE FUNCTIONS ========== */
1821 
1822     // Stub out all mutative functions as no-ops;
1823     // since they do nothing, there are no restrictions
1824 
1825     function updateCachedSynthDebts(bytes32[] calldata currencyKeys) external {}
1826 
1827     function updateCachedSynthDebtWithRate(bytes32 currencyKey, uint currencyRate) external {}
1828 
1829     function updateCachedSynthDebtsWithRates(bytes32[] calldata currencyKeys, uint[] calldata currencyRates) external {}
1830 
1831     function updateDebtCacheValidity(bool currentlyInvalid) external {}
1832 
1833     function purgeCachedSynthDebt(bytes32 currencyKey) external {}
1834 
1835     function takeDebtSnapshot() external {}
1836 
1837     function recordExcludedDebtChange(bytes32 currencyKey, int256 delta) external {}
1838 
1839     /* ========== MODIFIERS ========== */
1840 
1841     function _requireSystemActiveIfNotOwner() internal view {
1842         if (msg.sender != owner) {
1843             systemStatus().requireSystemActive();
1844         }
1845     }
1846 
1847     modifier requireSystemActiveIfNotOwner() {
1848         _requireSystemActiveIfNotOwner();
1849         _;
1850     }
1851 
1852     function _onlyIssuer() internal view {
1853         require(msg.sender == address(issuer()), "Sender is not Issuer");
1854     }
1855 
1856     modifier onlyIssuer() {
1857         _onlyIssuer();
1858         _;
1859     }
1860 
1861     function _onlyIssuerOrExchanger() internal view {
1862         require(msg.sender == address(issuer()) || msg.sender == address(exchanger()), "Sender is not Issuer or Exchanger");
1863     }
1864 
1865     modifier onlyIssuerOrExchanger() {
1866         _onlyIssuerOrExchanger();
1867         _;
1868     }
1869 
1870     function _onlyDebtIssuer() internal view {
1871         bool isWrapper = wrapperFactory().isWrapper(msg.sender);
1872 
1873         // owner included for debugging and fixing in emergency situation
1874         bool isOwner = msg.sender == owner;
1875 
1876         require(isOwner || isWrapper, "Only debt issuers may call this");
1877     }
1878 
1879     modifier onlyDebtIssuer() {
1880         _onlyDebtIssuer();
1881         _;
1882     }
1883 }
1884 
1885 
1886 // Libraries
1887 
1888 
1889 // Inheritance
1890 
1891 
1892 // https://docs.synthetix.io/contracts/source/contracts/debtcache
1893 contract DebtCache is BaseDebtCache {
1894     using SafeDecimalMath for uint;
1895 
1896     bytes32 public constant CONTRACT_NAME = "DebtCache";
1897 
1898     constructor(address _owner, address _resolver) public BaseDebtCache(_owner, _resolver) {}
1899 
1900     bytes32 internal constant EXCLUDED_DEBT_KEY = "EXCLUDED_DEBT";
1901 
1902     /* ========== MUTATIVE FUNCTIONS ========== */
1903 
1904     // This function exists in case a synth is ever somehow removed without its snapshot being updated.
1905     function purgeCachedSynthDebt(bytes32 currencyKey) external onlyOwner {
1906         require(issuer().synths(currencyKey) == ISynth(0), "Synth exists");
1907         delete _cachedSynthDebt[currencyKey];
1908     }
1909 
1910     function takeDebtSnapshot() external requireSystemActiveIfNotOwner {
1911         bytes32[] memory currencyKeys = issuer().availableCurrencyKeys();
1912         (uint[] memory values, uint excludedDebt, bool isInvalid) = _currentSynthDebts(currencyKeys);
1913 
1914         uint numValues = values.length;
1915         uint snxCollateralDebt;
1916         for (uint i; i < numValues; i++) {
1917             uint value = values[i];
1918             snxCollateralDebt = snxCollateralDebt.add(value);
1919             _cachedSynthDebt[currencyKeys[i]] = value;
1920         }
1921         _cachedSynthDebt[EXCLUDED_DEBT_KEY] = excludedDebt;
1922         uint newDebt = snxCollateralDebt.floorsub(excludedDebt);
1923         _cachedDebt = newDebt;
1924         _cacheTimestamp = block.timestamp;
1925         emit DebtCacheUpdated(newDebt);
1926         emit DebtCacheSnapshotTaken(block.timestamp);
1927 
1928         // (in)validate the cache if necessary
1929         _updateDebtCacheValidity(isInvalid);
1930     }
1931 
1932     function updateCachedSynthDebts(bytes32[] calldata currencyKeys) external requireSystemActiveIfNotOwner {
1933         (uint[] memory rates, bool anyRateInvalid) = exchangeRates().ratesAndInvalidForCurrencies(currencyKeys);
1934         _updateCachedSynthDebtsWithRates(currencyKeys, rates, anyRateInvalid);
1935     }
1936 
1937     function updateCachedSynthDebtWithRate(bytes32 currencyKey, uint currencyRate) external onlyIssuer {
1938         bytes32[] memory synthKeyArray = new bytes32[](1);
1939         synthKeyArray[0] = currencyKey;
1940         uint[] memory synthRateArray = new uint[](1);
1941         synthRateArray[0] = currencyRate;
1942         _updateCachedSynthDebtsWithRates(synthKeyArray, synthRateArray, false);
1943     }
1944 
1945     function updateCachedSynthDebtsWithRates(bytes32[] calldata currencyKeys, uint[] calldata currencyRates)
1946         external
1947         onlyIssuerOrExchanger
1948     {
1949         _updateCachedSynthDebtsWithRates(currencyKeys, currencyRates, false);
1950     }
1951 
1952     function updateDebtCacheValidity(bool currentlyInvalid) external onlyIssuer {
1953         _updateDebtCacheValidity(currentlyInvalid);
1954     }
1955 
1956     function recordExcludedDebtChange(bytes32 currencyKey, int256 delta) external onlyDebtIssuer {
1957         int256 newExcludedDebt = int256(_excludedIssuedDebt[currencyKey]) + delta;
1958 
1959         require(newExcludedDebt >= 0, "Excluded debt cannot become negative");
1960 
1961         _excludedIssuedDebt[currencyKey] = uint(newExcludedDebt);
1962     }
1963 
1964     function updateCachedsUSDDebt(int amount) external onlyIssuer {
1965         uint delta = SafeDecimalMath.abs(amount);
1966         if (amount > 0) {
1967             _cachedSynthDebt[sUSD] = _cachedSynthDebt[sUSD].add(delta);
1968             _cachedDebt = _cachedDebt.add(delta);
1969         } else {
1970             _cachedSynthDebt[sUSD] = _cachedSynthDebt[sUSD].sub(delta);
1971             _cachedDebt = _cachedDebt.sub(delta);
1972         }
1973 
1974         emit DebtCacheUpdated(_cachedDebt);
1975     }
1976 
1977     /* ========== INTERNAL FUNCTIONS ========== */
1978 
1979     function _updateDebtCacheValidity(bool currentlyInvalid) internal {
1980         if (_cacheInvalid != currentlyInvalid) {
1981             _cacheInvalid = currentlyInvalid;
1982             emit DebtCacheValidityChanged(currentlyInvalid);
1983         }
1984     }
1985 
1986     // Updated the global debt according to a rate/supply change in a subset of issued synths.
1987     function _updateCachedSynthDebtsWithRates(
1988         bytes32[] memory currencyKeys,
1989         uint[] memory currentRates,
1990         bool anyRateIsInvalid
1991     ) internal {
1992         uint numKeys = currencyKeys.length;
1993         require(numKeys == currentRates.length, "Input array lengths differ");
1994 
1995         // Compute the cached and current debt sum for the subset of synths provided.
1996         uint cachedSum;
1997         uint currentSum;
1998         uint[] memory currentValues = _issuedSynthValues(currencyKeys, currentRates);
1999 
2000         for (uint i = 0; i < numKeys; i++) {
2001             bytes32 key = currencyKeys[i];
2002             uint currentSynthDebt = currentValues[i];
2003 
2004             cachedSum = cachedSum.add(_cachedSynthDebt[key]);
2005             currentSum = currentSum.add(currentSynthDebt);
2006 
2007             _cachedSynthDebt[key] = currentSynthDebt;
2008         }
2009 
2010         // Apply the debt update.
2011         if (cachedSum != currentSum) {
2012             uint debt = _cachedDebt;
2013             // apply the delta between the cachedSum and currentSum
2014             // add currentSum before sub cachedSum to prevent overflow as cachedSum > debt for large amount of excluded debt
2015             debt = debt.add(currentSum).sub(cachedSum);
2016             _cachedDebt = debt;
2017             emit DebtCacheUpdated(debt);
2018         }
2019 
2020         // Invalidate the cache if necessary
2021         if (anyRateIsInvalid) {
2022             _updateDebtCacheValidity(anyRateIsInvalid);
2023         }
2024     }
2025 
2026     /* ========== EVENTS ========== */
2027 
2028     event DebtCacheUpdated(uint cachedDebt);
2029     event DebtCacheSnapshotTaken(uint timestamp);
2030     event DebtCacheValidityChanged(bool indexed isInvalid);
2031 }
2032 
2033     