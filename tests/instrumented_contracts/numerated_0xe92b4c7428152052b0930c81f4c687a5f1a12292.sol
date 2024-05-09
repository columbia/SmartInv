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
347 }
348 
349 
350 // https://docs.synthetix.io/contracts/source/contracts/owned
351 contract Owned {
352     address public owner;
353     address public nominatedOwner;
354 
355     constructor(address _owner) public {
356         require(_owner != address(0), "Owner address cannot be 0");
357         owner = _owner;
358         emit OwnerChanged(address(0), _owner);
359     }
360 
361     function nominateNewOwner(address _owner) external onlyOwner {
362         nominatedOwner = _owner;
363         emit OwnerNominated(_owner);
364     }
365 
366     function acceptOwnership() external {
367         require(msg.sender == nominatedOwner, "You must be nominated before you can accept ownership");
368         emit OwnerChanged(owner, nominatedOwner);
369         owner = nominatedOwner;
370         nominatedOwner = address(0);
371     }
372 
373     modifier onlyOwner {
374         _onlyOwner();
375         _;
376     }
377 
378     function _onlyOwner() private view {
379         require(msg.sender == owner, "Only the contract owner may perform this action");
380     }
381 
382     event OwnerNominated(address newOwner);
383     event OwnerChanged(address oldOwner, address newOwner);
384 }
385 
386 
387 // https://docs.synthetix.io/contracts/source/interfaces/iaddressresolver
388 interface IAddressResolver {
389     function getAddress(bytes32 name) external view returns (address);
390 
391     function getSynth(bytes32 key) external view returns (address);
392 
393     function requireAndGetAddress(bytes32 name, string calldata reason) external view returns (address);
394 }
395 
396 
397 // https://docs.synthetix.io/contracts/source/interfaces/isynth
398 interface ISynth {
399     // Views
400     function currencyKey() external view returns (bytes32);
401 
402     function transferableSynths(address account) external view returns (uint);
403 
404     // Mutative functions
405     function transferAndSettle(address to, uint value) external returns (bool);
406 
407     function transferFromAndSettle(
408         address from,
409         address to,
410         uint value
411     ) external returns (bool);
412 
413     // Restricted: used internally to Synthetix
414     function burn(address account, uint amount) external;
415 
416     function issue(address account, uint amount) external;
417 }
418 
419 
420 // https://docs.synthetix.io/contracts/source/interfaces/iissuer
421 interface IIssuer {
422     // Views
423     function anySynthOrSNXRateIsInvalid() external view returns (bool anyRateInvalid);
424 
425     function availableCurrencyKeys() external view returns (bytes32[] memory);
426 
427     function availableSynthCount() external view returns (uint);
428 
429     function availableSynths(uint index) external view returns (ISynth);
430 
431     function canBurnSynths(address account) external view returns (bool);
432 
433     function collateral(address account) external view returns (uint);
434 
435     function collateralisationRatio(address issuer) external view returns (uint);
436 
437     function collateralisationRatioAndAnyRatesInvalid(address _issuer)
438         external
439         view
440         returns (uint cratio, bool anyRateIsInvalid);
441 
442     function debtBalanceOf(address issuer, bytes32 currencyKey) external view returns (uint debtBalance);
443 
444     function issuanceRatio() external view returns (uint);
445 
446     function lastIssueEvent(address account) external view returns (uint);
447 
448     function maxIssuableSynths(address issuer) external view returns (uint maxIssuable);
449 
450     function minimumStakeTime() external view returns (uint);
451 
452     function remainingIssuableSynths(address issuer)
453         external
454         view
455         returns (
456             uint maxIssuable,
457             uint alreadyIssued,
458             uint totalSystemDebt
459         );
460 
461     function synths(bytes32 currencyKey) external view returns (ISynth);
462 
463     function getSynths(bytes32[] calldata currencyKeys) external view returns (ISynth[] memory);
464 
465     function synthsByAddress(address synthAddress) external view returns (bytes32);
466 
467     function totalIssuedSynths(bytes32 currencyKey, bool excludeOtherCollateral) external view returns (uint);
468 
469     function transferableSynthetixAndAnyRateIsInvalid(address account, uint balance)
470         external
471         view
472         returns (uint transferable, bool anyRateIsInvalid);
473 
474     // Restricted: used internally to Synthetix
475     function issueSynths(address from, uint amount) external;
476 
477     function issueSynthsOnBehalf(
478         address issueFor,
479         address from,
480         uint amount
481     ) external;
482 
483     function issueMaxSynths(address from) external;
484 
485     function issueMaxSynthsOnBehalf(address issueFor, address from) external;
486 
487     function burnSynths(address from, uint amount) external;
488 
489     function burnSynthsOnBehalf(
490         address burnForAddress,
491         address from,
492         uint amount
493     ) external;
494 
495     function burnSynthsToTarget(address from) external;
496 
497     function burnSynthsToTargetOnBehalf(address burnForAddress, address from) external;
498 
499     function burnForRedemption(
500         address deprecatedSynthProxy,
501         address account,
502         uint balance
503     ) external;
504 
505     function liquidateDelinquentAccount(
506         address account,
507         uint susdAmount,
508         address liquidator
509     ) external returns (uint totalRedeemed, uint amountToLiquidate);
510 }
511 
512 
513 // Inheritance
514 
515 
516 // Internal references
517 
518 
519 // https://docs.synthetix.io/contracts/source/contracts/addressresolver
520 contract AddressResolver is Owned, IAddressResolver {
521     mapping(bytes32 => address) public repository;
522 
523     constructor(address _owner) public Owned(_owner) {}
524 
525     /* ========== RESTRICTED FUNCTIONS ========== */
526 
527     function importAddresses(bytes32[] calldata names, address[] calldata destinations) external onlyOwner {
528         require(names.length == destinations.length, "Input lengths must match");
529 
530         for (uint i = 0; i < names.length; i++) {
531             bytes32 name = names[i];
532             address destination = destinations[i];
533             repository[name] = destination;
534             emit AddressImported(name, destination);
535         }
536     }
537 
538     /* ========= PUBLIC FUNCTIONS ========== */
539 
540     function rebuildCaches(MixinResolver[] calldata destinations) external {
541         for (uint i = 0; i < destinations.length; i++) {
542             destinations[i].rebuildCache();
543         }
544     }
545 
546     /* ========== VIEWS ========== */
547 
548     function areAddressesImported(bytes32[] calldata names, address[] calldata destinations) external view returns (bool) {
549         for (uint i = 0; i < names.length; i++) {
550             if (repository[names[i]] != destinations[i]) {
551                 return false;
552             }
553         }
554         return true;
555     }
556 
557     function getAddress(bytes32 name) external view returns (address) {
558         return repository[name];
559     }
560 
561     function requireAndGetAddress(bytes32 name, string calldata reason) external view returns (address) {
562         address _foundAddress = repository[name];
563         require(_foundAddress != address(0), reason);
564         return _foundAddress;
565     }
566 
567     function getSynth(bytes32 key) external view returns (address) {
568         IIssuer issuer = IIssuer(repository["Issuer"]);
569         require(address(issuer) != address(0), "Cannot find Issuer address");
570         return address(issuer.synths(key));
571     }
572 
573     /* ========== EVENTS ========== */
574 
575     event AddressImported(bytes32 name, address destination);
576 }
577 
578 
579 // Internal references
580 
581 
582 // https://docs.synthetix.io/contracts/source/contracts/mixinresolver
583 contract MixinResolver {
584     AddressResolver public resolver;
585 
586     mapping(bytes32 => address) private addressCache;
587 
588     constructor(address _resolver) internal {
589         resolver = AddressResolver(_resolver);
590     }
591 
592     /* ========== INTERNAL FUNCTIONS ========== */
593 
594     function combineArrays(bytes32[] memory first, bytes32[] memory second)
595         internal
596         pure
597         returns (bytes32[] memory combination)
598     {
599         combination = new bytes32[](first.length + second.length);
600 
601         for (uint i = 0; i < first.length; i++) {
602             combination[i] = first[i];
603         }
604 
605         for (uint j = 0; j < second.length; j++) {
606             combination[first.length + j] = second[j];
607         }
608     }
609 
610     /* ========== PUBLIC FUNCTIONS ========== */
611 
612     // Note: this function is public not external in order for it to be overridden and invoked via super in subclasses
613     function resolverAddressesRequired() public view returns (bytes32[] memory addresses) {}
614 
615     function rebuildCache() public {
616         bytes32[] memory requiredAddresses = resolverAddressesRequired();
617         // The resolver must call this function whenver it updates its state
618         for (uint i = 0; i < requiredAddresses.length; i++) {
619             bytes32 name = requiredAddresses[i];
620             // Note: can only be invoked once the resolver has all the targets needed added
621             address destination =
622                 resolver.requireAndGetAddress(name, string(abi.encodePacked("Resolver missing target: ", name)));
623             addressCache[name] = destination;
624             emit CacheUpdated(name, destination);
625         }
626     }
627 
628     /* ========== VIEWS ========== */
629 
630     function isResolverCached() external view returns (bool) {
631         bytes32[] memory requiredAddresses = resolverAddressesRequired();
632         for (uint i = 0; i < requiredAddresses.length; i++) {
633             bytes32 name = requiredAddresses[i];
634             // false if our cache is invalid or if the resolver doesn't have the required address
635             if (resolver.getAddress(name) != addressCache[name] || addressCache[name] == address(0)) {
636                 return false;
637             }
638         }
639 
640         return true;
641     }
642 
643     /* ========== INTERNAL FUNCTIONS ========== */
644 
645     function requireAndGetAddress(bytes32 name) internal view returns (address) {
646         address _foundAddress = addressCache[name];
647         require(_foundAddress != address(0), string(abi.encodePacked("Missing address: ", name)));
648         return _foundAddress;
649     }
650 
651     /* ========== EVENTS ========== */
652 
653     event CacheUpdated(bytes32 name, address destination);
654 }
655 
656 
657 // https://docs.synthetix.io/contracts/source/interfaces/iflexiblestorage
658 interface IFlexibleStorage {
659     // Views
660     function getUIntValue(bytes32 contractName, bytes32 record) external view returns (uint);
661 
662     function getUIntValues(bytes32 contractName, bytes32[] calldata records) external view returns (uint[] memory);
663 
664     function getIntValue(bytes32 contractName, bytes32 record) external view returns (int);
665 
666     function getIntValues(bytes32 contractName, bytes32[] calldata records) external view returns (int[] memory);
667 
668     function getAddressValue(bytes32 contractName, bytes32 record) external view returns (address);
669 
670     function getAddressValues(bytes32 contractName, bytes32[] calldata records) external view returns (address[] memory);
671 
672     function getBoolValue(bytes32 contractName, bytes32 record) external view returns (bool);
673 
674     function getBoolValues(bytes32 contractName, bytes32[] calldata records) external view returns (bool[] memory);
675 
676     function getBytes32Value(bytes32 contractName, bytes32 record) external view returns (bytes32);
677 
678     function getBytes32Values(bytes32 contractName, bytes32[] calldata records) external view returns (bytes32[] memory);
679 
680     // Mutative functions
681     function deleteUIntValue(bytes32 contractName, bytes32 record) external;
682 
683     function deleteIntValue(bytes32 contractName, bytes32 record) external;
684 
685     function deleteAddressValue(bytes32 contractName, bytes32 record) external;
686 
687     function deleteBoolValue(bytes32 contractName, bytes32 record) external;
688 
689     function deleteBytes32Value(bytes32 contractName, bytes32 record) external;
690 
691     function setUIntValue(
692         bytes32 contractName,
693         bytes32 record,
694         uint value
695     ) external;
696 
697     function setUIntValues(
698         bytes32 contractName,
699         bytes32[] calldata records,
700         uint[] calldata values
701     ) external;
702 
703     function setIntValue(
704         bytes32 contractName,
705         bytes32 record,
706         int value
707     ) external;
708 
709     function setIntValues(
710         bytes32 contractName,
711         bytes32[] calldata records,
712         int[] calldata values
713     ) external;
714 
715     function setAddressValue(
716         bytes32 contractName,
717         bytes32 record,
718         address value
719     ) external;
720 
721     function setAddressValues(
722         bytes32 contractName,
723         bytes32[] calldata records,
724         address[] calldata values
725     ) external;
726 
727     function setBoolValue(
728         bytes32 contractName,
729         bytes32 record,
730         bool value
731     ) external;
732 
733     function setBoolValues(
734         bytes32 contractName,
735         bytes32[] calldata records,
736         bool[] calldata values
737     ) external;
738 
739     function setBytes32Value(
740         bytes32 contractName,
741         bytes32 record,
742         bytes32 value
743     ) external;
744 
745     function setBytes32Values(
746         bytes32 contractName,
747         bytes32[] calldata records,
748         bytes32[] calldata values
749     ) external;
750 }
751 
752 
753 // Internal references
754 
755 
756 // https://docs.synthetix.io/contracts/source/contracts/mixinsystemsettings
757 contract MixinSystemSettings is MixinResolver {
758     bytes32 internal constant SETTING_CONTRACT_NAME = "SystemSettings";
759 
760     bytes32 internal constant SETTING_WAITING_PERIOD_SECS = "waitingPeriodSecs";
761     bytes32 internal constant SETTING_PRICE_DEVIATION_THRESHOLD_FACTOR = "priceDeviationThresholdFactor";
762     bytes32 internal constant SETTING_ISSUANCE_RATIO = "issuanceRatio";
763     bytes32 internal constant SETTING_FEE_PERIOD_DURATION = "feePeriodDuration";
764     bytes32 internal constant SETTING_TARGET_THRESHOLD = "targetThreshold";
765     bytes32 internal constant SETTING_LIQUIDATION_DELAY = "liquidationDelay";
766     bytes32 internal constant SETTING_LIQUIDATION_RATIO = "liquidationRatio";
767     bytes32 internal constant SETTING_LIQUIDATION_PENALTY = "liquidationPenalty";
768     bytes32 internal constant SETTING_RATE_STALE_PERIOD = "rateStalePeriod";
769     bytes32 internal constant SETTING_EXCHANGE_FEE_RATE = "exchangeFeeRate";
770     bytes32 internal constant SETTING_MINIMUM_STAKE_TIME = "minimumStakeTime";
771     bytes32 internal constant SETTING_AGGREGATOR_WARNING_FLAGS = "aggregatorWarningFlags";
772     bytes32 internal constant SETTING_TRADING_REWARDS_ENABLED = "tradingRewardsEnabled";
773     bytes32 internal constant SETTING_DEBT_SNAPSHOT_STALE_TIME = "debtSnapshotStaleTime";
774     bytes32 internal constant SETTING_CROSS_DOMAIN_DEPOSIT_GAS_LIMIT = "crossDomainDepositGasLimit";
775     bytes32 internal constant SETTING_CROSS_DOMAIN_ESCROW_GAS_LIMIT = "crossDomainEscrowGasLimit";
776     bytes32 internal constant SETTING_CROSS_DOMAIN_REWARD_GAS_LIMIT = "crossDomainRewardGasLimit";
777     bytes32 internal constant SETTING_CROSS_DOMAIN_WITHDRAWAL_GAS_LIMIT = "crossDomainWithdrawalGasLimit";
778     bytes32 internal constant SETTING_ETHER_WRAPPER_MAX_ETH = "etherWrapperMaxETH";
779     bytes32 internal constant SETTING_ETHER_WRAPPER_MINT_FEE_RATE = "etherWrapperMintFeeRate";
780     bytes32 internal constant SETTING_ETHER_WRAPPER_BURN_FEE_RATE = "etherWrapperBurnFeeRate";
781 
782     bytes32 internal constant CONTRACT_FLEXIBLESTORAGE = "FlexibleStorage";
783 
784     enum CrossDomainMessageGasLimits {Deposit, Escrow, Reward, Withdrawal}
785 
786     constructor(address _resolver) internal MixinResolver(_resolver) {}
787 
788     function resolverAddressesRequired() public view returns (bytes32[] memory addresses) {
789         addresses = new bytes32[](1);
790         addresses[0] = CONTRACT_FLEXIBLESTORAGE;
791     }
792 
793     function flexibleStorage() internal view returns (IFlexibleStorage) {
794         return IFlexibleStorage(requireAndGetAddress(CONTRACT_FLEXIBLESTORAGE));
795     }
796 
797     function _getGasLimitSetting(CrossDomainMessageGasLimits gasLimitType) internal pure returns (bytes32) {
798         if (gasLimitType == CrossDomainMessageGasLimits.Deposit) {
799             return SETTING_CROSS_DOMAIN_DEPOSIT_GAS_LIMIT;
800         } else if (gasLimitType == CrossDomainMessageGasLimits.Escrow) {
801             return SETTING_CROSS_DOMAIN_ESCROW_GAS_LIMIT;
802         } else if (gasLimitType == CrossDomainMessageGasLimits.Reward) {
803             return SETTING_CROSS_DOMAIN_REWARD_GAS_LIMIT;
804         } else if (gasLimitType == CrossDomainMessageGasLimits.Withdrawal) {
805             return SETTING_CROSS_DOMAIN_WITHDRAWAL_GAS_LIMIT;
806         } else {
807             revert("Unknown gas limit type");
808         }
809     }
810 
811     function getCrossDomainMessageGasLimit(CrossDomainMessageGasLimits gasLimitType) internal view returns (uint) {
812         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, _getGasLimitSetting(gasLimitType));
813     }
814 
815     function getTradingRewardsEnabled() internal view returns (bool) {
816         return flexibleStorage().getBoolValue(SETTING_CONTRACT_NAME, SETTING_TRADING_REWARDS_ENABLED);
817     }
818 
819     function getWaitingPeriodSecs() internal view returns (uint) {
820         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_WAITING_PERIOD_SECS);
821     }
822 
823     function getPriceDeviationThresholdFactor() internal view returns (uint) {
824         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_PRICE_DEVIATION_THRESHOLD_FACTOR);
825     }
826 
827     function getIssuanceRatio() internal view returns (uint) {
828         // lookup on flexible storage directly for gas savings (rather than via SystemSettings)
829         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_ISSUANCE_RATIO);
830     }
831 
832     function getFeePeriodDuration() internal view returns (uint) {
833         // lookup on flexible storage directly for gas savings (rather than via SystemSettings)
834         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_FEE_PERIOD_DURATION);
835     }
836 
837     function getTargetThreshold() internal view returns (uint) {
838         // lookup on flexible storage directly for gas savings (rather than via SystemSettings)
839         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_TARGET_THRESHOLD);
840     }
841 
842     function getLiquidationDelay() internal view returns (uint) {
843         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_LIQUIDATION_DELAY);
844     }
845 
846     function getLiquidationRatio() internal view returns (uint) {
847         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_LIQUIDATION_RATIO);
848     }
849 
850     function getLiquidationPenalty() internal view returns (uint) {
851         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_LIQUIDATION_PENALTY);
852     }
853 
854     function getRateStalePeriod() internal view returns (uint) {
855         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_RATE_STALE_PERIOD);
856     }
857 
858     function getExchangeFeeRate(bytes32 currencyKey) internal view returns (uint) {
859         return
860             flexibleStorage().getUIntValue(
861                 SETTING_CONTRACT_NAME,
862                 keccak256(abi.encodePacked(SETTING_EXCHANGE_FEE_RATE, currencyKey))
863             );
864     }
865 
866     function getMinimumStakeTime() internal view returns (uint) {
867         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_MINIMUM_STAKE_TIME);
868     }
869 
870     function getAggregatorWarningFlags() internal view returns (address) {
871         return flexibleStorage().getAddressValue(SETTING_CONTRACT_NAME, SETTING_AGGREGATOR_WARNING_FLAGS);
872     }
873 
874     function getDebtSnapshotStaleTime() internal view returns (uint) {
875         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_DEBT_SNAPSHOT_STALE_TIME);
876     }
877 
878     function getEtherWrapperMaxETH() internal view returns (uint) {
879         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_ETHER_WRAPPER_MAX_ETH);
880     }
881 
882     function getEtherWrapperMintFeeRate() internal view returns (uint) {
883         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_ETHER_WRAPPER_MINT_FEE_RATE);
884     }
885 
886     function getEtherWrapperBurnFeeRate() internal view returns (uint) {
887         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_ETHER_WRAPPER_BURN_FEE_RATE);
888     }
889 }
890 
891 
892 interface IDebtCache {
893     // Views
894 
895     function cachedDebt() external view returns (uint);
896 
897     function cachedSynthDebt(bytes32 currencyKey) external view returns (uint);
898 
899     function cacheTimestamp() external view returns (uint);
900 
901     function cacheInvalid() external view returns (bool);
902 
903     function cacheStale() external view returns (bool);
904 
905     function currentSynthDebts(bytes32[] calldata currencyKeys)
906         external
907         view
908         returns (
909             uint[] memory debtValues,
910             uint excludedDebt,
911             bool anyRateIsInvalid
912         );
913 
914     function cachedSynthDebts(bytes32[] calldata currencyKeys) external view returns (uint[] memory debtValues);
915 
916     function totalNonSnxBackedDebt() external view returns (uint excludedDebt, bool isInvalid);
917 
918     function currentDebt() external view returns (uint debt, bool anyRateIsInvalid);
919 
920     function cacheInfo()
921         external
922         view
923         returns (
924             uint debt,
925             uint timestamp,
926             bool isInvalid,
927             bool isStale
928         );
929 
930     // Mutative functions
931 
932     function updateCachedSynthDebts(bytes32[] calldata currencyKeys) external;
933 
934     function updateCachedSynthDebtWithRate(bytes32 currencyKey, uint currencyRate) external;
935 
936     function updateCachedSynthDebtsWithRates(bytes32[] calldata currencyKeys, uint[] calldata currencyRates) external;
937 
938     function updateDebtCacheValidity(bool currentlyInvalid) external;
939 
940     function purgeCachedSynthDebt(bytes32 currencyKey) external;
941 
942     function takeDebtSnapshot() external;
943 }
944 
945 
946 interface IVirtualSynth {
947     // Views
948     function balanceOfUnderlying(address account) external view returns (uint);
949 
950     function rate() external view returns (uint);
951 
952     function readyToSettle() external view returns (bool);
953 
954     function secsLeftInWaitingPeriod() external view returns (uint);
955 
956     function settled() external view returns (bool);
957 
958     function synth() external view returns (ISynth);
959 
960     // Mutative functions
961     function settle(address account) external;
962 }
963 
964 
965 // https://docs.synthetix.io/contracts/source/interfaces/iexchanger
966 interface IExchanger {
967     // Views
968     function calculateAmountAfterSettlement(
969         address from,
970         bytes32 currencyKey,
971         uint amount,
972         uint refunded
973     ) external view returns (uint amountAfterSettlement);
974 
975     function isSynthRateInvalid(bytes32 currencyKey) external view returns (bool);
976 
977     function maxSecsLeftInWaitingPeriod(address account, bytes32 currencyKey) external view returns (uint);
978 
979     function settlementOwing(address account, bytes32 currencyKey)
980         external
981         view
982         returns (
983             uint reclaimAmount,
984             uint rebateAmount,
985             uint numEntries
986         );
987 
988     function hasWaitingPeriodOrSettlementOwing(address account, bytes32 currencyKey) external view returns (bool);
989 
990     function feeRateForExchange(bytes32 sourceCurrencyKey, bytes32 destinationCurrencyKey)
991         external
992         view
993         returns (uint exchangeFeeRate);
994 
995     function getAmountsForExchange(
996         uint sourceAmount,
997         bytes32 sourceCurrencyKey,
998         bytes32 destinationCurrencyKey
999     )
1000         external
1001         view
1002         returns (
1003             uint amountReceived,
1004             uint fee,
1005             uint exchangeFeeRate
1006         );
1007 
1008     function priceDeviationThresholdFactor() external view returns (uint);
1009 
1010     function waitingPeriodSecs() external view returns (uint);
1011 
1012     // Mutative functions
1013     function exchange(
1014         address exchangeForAddress,
1015         address from,
1016         bytes32 sourceCurrencyKey,
1017         uint sourceAmount,
1018         bytes32 destinationCurrencyKey,
1019         address destinationAddress,
1020         bool virtualSynth,
1021         address rewardAddress,
1022         bytes32 trackingCode
1023     ) external returns (uint amountReceived, IVirtualSynth vSynth);
1024 
1025     function settle(address from, bytes32 currencyKey)
1026         external
1027         returns (
1028             uint reclaimed,
1029             uint refunded,
1030             uint numEntries
1031         );
1032 
1033     function setLastExchangeRateForSynth(bytes32 currencyKey, uint rate) external;
1034 
1035     function resetLastExchangeRate(bytes32[] calldata currencyKeys) external;
1036 
1037     function suspendSynthWithInvalidRate(bytes32 currencyKey) external;
1038 }
1039 
1040 
1041 // https://docs.synthetix.io/contracts/source/interfaces/iexchangerates
1042 interface IExchangeRates {
1043     // Structs
1044     struct RateAndUpdatedTime {
1045         uint216 rate;
1046         uint40 time;
1047     }
1048 
1049     struct InversePricing {
1050         uint entryPoint;
1051         uint upperLimit;
1052         uint lowerLimit;
1053         bool frozenAtUpperLimit;
1054         bool frozenAtLowerLimit;
1055     }
1056 
1057     // Views
1058     function aggregators(bytes32 currencyKey) external view returns (address);
1059 
1060     function aggregatorWarningFlags() external view returns (address);
1061 
1062     function anyRateIsInvalid(bytes32[] calldata currencyKeys) external view returns (bool);
1063 
1064     function canFreezeRate(bytes32 currencyKey) external view returns (bool);
1065 
1066     function currentRoundForRate(bytes32 currencyKey) external view returns (uint);
1067 
1068     function currenciesUsingAggregator(address aggregator) external view returns (bytes32[] memory);
1069 
1070     function effectiveValue(
1071         bytes32 sourceCurrencyKey,
1072         uint sourceAmount,
1073         bytes32 destinationCurrencyKey
1074     ) external view returns (uint value);
1075 
1076     function effectiveValueAndRates(
1077         bytes32 sourceCurrencyKey,
1078         uint sourceAmount,
1079         bytes32 destinationCurrencyKey
1080     )
1081         external
1082         view
1083         returns (
1084             uint value,
1085             uint sourceRate,
1086             uint destinationRate
1087         );
1088 
1089     function effectiveValueAtRound(
1090         bytes32 sourceCurrencyKey,
1091         uint sourceAmount,
1092         bytes32 destinationCurrencyKey,
1093         uint roundIdForSrc,
1094         uint roundIdForDest
1095     ) external view returns (uint value);
1096 
1097     function getCurrentRoundId(bytes32 currencyKey) external view returns (uint);
1098 
1099     function getLastRoundIdBeforeElapsedSecs(
1100         bytes32 currencyKey,
1101         uint startingRoundId,
1102         uint startingTimestamp,
1103         uint timediff
1104     ) external view returns (uint);
1105 
1106     function inversePricing(bytes32 currencyKey)
1107         external
1108         view
1109         returns (
1110             uint entryPoint,
1111             uint upperLimit,
1112             uint lowerLimit,
1113             bool frozenAtUpperLimit,
1114             bool frozenAtLowerLimit
1115         );
1116 
1117     function lastRateUpdateTimes(bytes32 currencyKey) external view returns (uint256);
1118 
1119     function oracle() external view returns (address);
1120 
1121     function rateAndTimestampAtRound(bytes32 currencyKey, uint roundId) external view returns (uint rate, uint time);
1122 
1123     function rateAndUpdatedTime(bytes32 currencyKey) external view returns (uint rate, uint time);
1124 
1125     function rateAndInvalid(bytes32 currencyKey) external view returns (uint rate, bool isInvalid);
1126 
1127     function rateForCurrency(bytes32 currencyKey) external view returns (uint);
1128 
1129     function rateIsFlagged(bytes32 currencyKey) external view returns (bool);
1130 
1131     function rateIsFrozen(bytes32 currencyKey) external view returns (bool);
1132 
1133     function rateIsInvalid(bytes32 currencyKey) external view returns (bool);
1134 
1135     function rateIsStale(bytes32 currencyKey) external view returns (bool);
1136 
1137     function rateStalePeriod() external view returns (uint);
1138 
1139     function ratesAndUpdatedTimeForCurrencyLastNRounds(bytes32 currencyKey, uint numRounds)
1140         external
1141         view
1142         returns (uint[] memory rates, uint[] memory times);
1143 
1144     function ratesAndInvalidForCurrencies(bytes32[] calldata currencyKeys)
1145         external
1146         view
1147         returns (uint[] memory rates, bool anyRateInvalid);
1148 
1149     function ratesForCurrencies(bytes32[] calldata currencyKeys) external view returns (uint[] memory);
1150 
1151     // Mutative functions
1152     function freezeRate(bytes32 currencyKey) external;
1153 }
1154 
1155 
1156 // https://docs.synthetix.io/contracts/source/interfaces/isystemstatus
1157 interface ISystemStatus {
1158     struct Status {
1159         bool canSuspend;
1160         bool canResume;
1161     }
1162 
1163     struct Suspension {
1164         bool suspended;
1165         // reason is an integer code,
1166         // 0 => no reason, 1 => upgrading, 2+ => defined by system usage
1167         uint248 reason;
1168     }
1169 
1170     // Views
1171     function accessControl(bytes32 section, address account) external view returns (bool canSuspend, bool canResume);
1172 
1173     function requireSystemActive() external view;
1174 
1175     function requireIssuanceActive() external view;
1176 
1177     function requireExchangeActive() external view;
1178 
1179     function requireExchangeBetweenSynthsAllowed(bytes32 sourceCurrencyKey, bytes32 destinationCurrencyKey) external view;
1180 
1181     function requireSynthActive(bytes32 currencyKey) external view;
1182 
1183     function requireSynthsActive(bytes32 sourceCurrencyKey, bytes32 destinationCurrencyKey) external view;
1184 
1185     function systemSuspension() external view returns (bool suspended, uint248 reason);
1186 
1187     function issuanceSuspension() external view returns (bool suspended, uint248 reason);
1188 
1189     function exchangeSuspension() external view returns (bool suspended, uint248 reason);
1190 
1191     function synthExchangeSuspension(bytes32 currencyKey) external view returns (bool suspended, uint248 reason);
1192 
1193     function synthSuspension(bytes32 currencyKey) external view returns (bool suspended, uint248 reason);
1194 
1195     function getSynthExchangeSuspensions(bytes32[] calldata synths)
1196         external
1197         view
1198         returns (bool[] memory exchangeSuspensions, uint256[] memory reasons);
1199 
1200     function getSynthSuspensions(bytes32[] calldata synths)
1201         external
1202         view
1203         returns (bool[] memory suspensions, uint256[] memory reasons);
1204 
1205     // Restricted functions
1206     function suspendSynth(bytes32 currencyKey, uint256 reason) external;
1207 
1208     function updateAccessControl(
1209         bytes32 section,
1210         address account,
1211         bool canSuspend,
1212         bool canResume
1213     ) external;
1214 }
1215 
1216 
1217 // https://docs.synthetix.io/contracts/source/interfaces/ierc20
1218 interface IERC20 {
1219     // ERC20 Optional Views
1220     function name() external view returns (string memory);
1221 
1222     function symbol() external view returns (string memory);
1223 
1224     function decimals() external view returns (uint8);
1225 
1226     // Views
1227     function totalSupply() external view returns (uint);
1228 
1229     function balanceOf(address owner) external view returns (uint);
1230 
1231     function allowance(address owner, address spender) external view returns (uint);
1232 
1233     // Mutative functions
1234     function transfer(address to, uint value) external returns (bool);
1235 
1236     function approve(address spender, uint value) external returns (bool);
1237 
1238     function transferFrom(
1239         address from,
1240         address to,
1241         uint value
1242     ) external returns (bool);
1243 
1244     // Events
1245     event Transfer(address indexed from, address indexed to, uint value);
1246 
1247     event Approval(address indexed owner, address indexed spender, uint value);
1248 }
1249 
1250 
1251 interface ICollateralManager {
1252     // Manager information
1253     function hasCollateral(address collateral) external view returns (bool);
1254 
1255     function isSynthManaged(bytes32 currencyKey) external view returns (bool);
1256 
1257     // State information
1258     function long(bytes32 synth) external view returns (uint amount);
1259 
1260     function short(bytes32 synth) external view returns (uint amount);
1261 
1262     function totalLong() external view returns (uint susdValue, bool anyRateIsInvalid);
1263 
1264     function totalShort() external view returns (uint susdValue, bool anyRateIsInvalid);
1265 
1266     function getBorrowRate() external view returns (uint borrowRate, bool anyRateIsInvalid);
1267 
1268     function getShortRate(bytes32 synth) external view returns (uint shortRate, bool rateIsInvalid);
1269 
1270     function getRatesAndTime(uint index)
1271         external
1272         view
1273         returns (
1274             uint entryRate,
1275             uint lastRate,
1276             uint lastUpdated,
1277             uint newIndex
1278         );
1279 
1280     function getShortRatesAndTime(bytes32 currency, uint index)
1281         external
1282         view
1283         returns (
1284             uint entryRate,
1285             uint lastRate,
1286             uint lastUpdated,
1287             uint newIndex
1288         );
1289 
1290     function exceedsDebtLimit(uint amount, bytes32 currency) external view returns (bool canIssue, bool anyRateIsInvalid);
1291 
1292     function areSynthsAndCurrenciesSet(bytes32[] calldata requiredSynthNamesInResolver, bytes32[] calldata synthKeys)
1293         external
1294         view
1295         returns (bool);
1296 
1297     function areShortableSynthsSet(bytes32[] calldata requiredSynthNamesInResolver, bytes32[] calldata synthKeys)
1298         external
1299         view
1300         returns (bool);
1301 
1302     // Loans
1303     function getNewLoanId() external returns (uint id);
1304 
1305     // Manager mutative
1306     function addCollaterals(address[] calldata collaterals) external;
1307 
1308     function removeCollaterals(address[] calldata collaterals) external;
1309 
1310     function addSynths(bytes32[] calldata synthNamesInResolver, bytes32[] calldata synthKeys) external;
1311 
1312     function removeSynths(bytes32[] calldata synths, bytes32[] calldata synthKeys) external;
1313 
1314     function addShortableSynths(bytes32[2][] calldata requiredSynthAndInverseNamesInResolver, bytes32[] calldata synthKeys)
1315         external;
1316 
1317     function removeShortableSynths(bytes32[] calldata synths) external;
1318 
1319     // State mutative
1320     function updateBorrowRates(uint rate) external;
1321 
1322     function updateShortRates(bytes32 currency, uint rate) external;
1323 
1324     function incrementLongs(bytes32 synth, uint amount) external;
1325 
1326     function decrementLongs(bytes32 synth, uint amount) external;
1327 
1328     function incrementShorts(bytes32 synth, uint amount) external;
1329 
1330     function decrementShorts(bytes32 synth, uint amount) external;
1331 }
1332 
1333 
1334 interface IWETH {
1335     // ERC20 Optional Views
1336     function name() external view returns (string memory);
1337 
1338     function symbol() external view returns (string memory);
1339 
1340     function decimals() external view returns (uint8);
1341 
1342     // Views
1343     function totalSupply() external view returns (uint);
1344 
1345     function balanceOf(address owner) external view returns (uint);
1346 
1347     function allowance(address owner, address spender) external view returns (uint);
1348 
1349     // Mutative functions
1350     function transfer(address to, uint value) external returns (bool);
1351 
1352     function approve(address spender, uint value) external returns (bool);
1353 
1354     function transferFrom(
1355         address from,
1356         address to,
1357         uint value
1358     ) external returns (bool);
1359 
1360     // WETH-specific functions.
1361     function deposit() external payable;
1362 
1363     function withdraw(uint amount) external;
1364 
1365     // Events
1366     event Transfer(address indexed from, address indexed to, uint value);
1367     event Approval(address indexed owner, address indexed spender, uint value);
1368     event Deposit(address indexed to, uint amount);
1369     event Withdrawal(address indexed to, uint amount);
1370 }
1371 
1372 
1373 // https://docs.synthetix.io/contracts/source/interfaces/ietherwrapper
1374 contract IEtherWrapper {
1375     function mint(uint amount) external;
1376 
1377     function burn(uint amount) external;
1378 
1379     function distributeFees() external;
1380 
1381     function capacity() external view returns (uint);
1382 
1383     function getReserves() external view returns (uint);
1384 
1385     function totalIssuedSynths() external view returns (uint);
1386 
1387     function calculateMintFee(uint amount) public view returns (uint);
1388 
1389     function calculateBurnFee(uint amount) public view returns (uint);
1390 
1391     function maxETH() public view returns (uint256);
1392 
1393     function mintFeeRate() public view returns (uint256);
1394 
1395     function burnFeeRate() public view returns (uint256);
1396 
1397     function weth() public view returns (IWETH);
1398 }
1399 
1400 
1401 // Inheritance
1402 
1403 
1404 // Libraries
1405 
1406 
1407 // Internal references
1408 
1409 
1410 // https://docs.synthetix.io/contracts/source/contracts/debtcache
1411 contract BaseDebtCache is Owned, MixinSystemSettings, IDebtCache {
1412     using SafeMath for uint;
1413     using SafeDecimalMath for uint;
1414 
1415     uint internal _cachedDebt;
1416     mapping(bytes32 => uint) internal _cachedSynthDebt;
1417     uint internal _cacheTimestamp;
1418     bool internal _cacheInvalid = true;
1419 
1420     /* ========== ENCODED NAMES ========== */
1421 
1422     bytes32 internal constant sUSD = "sUSD";
1423     bytes32 internal constant sETH = "sETH";
1424 
1425     /* ========== ADDRESS RESOLVER CONFIGURATION ========== */
1426 
1427     bytes32 private constant CONTRACT_ISSUER = "Issuer";
1428     bytes32 private constant CONTRACT_EXCHANGER = "Exchanger";
1429     bytes32 private constant CONTRACT_EXRATES = "ExchangeRates";
1430     bytes32 private constant CONTRACT_SYSTEMSTATUS = "SystemStatus";
1431     bytes32 private constant CONTRACT_COLLATERALMANAGER = "CollateralManager";
1432     bytes32 private constant CONTRACT_ETHER_WRAPPER = "EtherWrapper";
1433 
1434     constructor(address _owner, address _resolver) public Owned(_owner) MixinSystemSettings(_resolver) {}
1435 
1436     /* ========== VIEWS ========== */
1437 
1438     function resolverAddressesRequired() public view returns (bytes32[] memory addresses) {
1439         bytes32[] memory existingAddresses = MixinSystemSettings.resolverAddressesRequired();
1440         bytes32[] memory newAddresses = new bytes32[](6);
1441         newAddresses[0] = CONTRACT_ISSUER;
1442         newAddresses[1] = CONTRACT_EXCHANGER;
1443         newAddresses[2] = CONTRACT_EXRATES;
1444         newAddresses[3] = CONTRACT_SYSTEMSTATUS;
1445         newAddresses[4] = CONTRACT_COLLATERALMANAGER;
1446         newAddresses[5] = CONTRACT_ETHER_WRAPPER;
1447         addresses = combineArrays(existingAddresses, newAddresses);
1448     }
1449 
1450     function issuer() internal view returns (IIssuer) {
1451         return IIssuer(requireAndGetAddress(CONTRACT_ISSUER));
1452     }
1453 
1454     function exchanger() internal view returns (IExchanger) {
1455         return IExchanger(requireAndGetAddress(CONTRACT_EXCHANGER));
1456     }
1457 
1458     function exchangeRates() internal view returns (IExchangeRates) {
1459         return IExchangeRates(requireAndGetAddress(CONTRACT_EXRATES));
1460     }
1461 
1462     function systemStatus() internal view returns (ISystemStatus) {
1463         return ISystemStatus(requireAndGetAddress(CONTRACT_SYSTEMSTATUS));
1464     }
1465 
1466     function collateralManager() internal view returns (ICollateralManager) {
1467         return ICollateralManager(requireAndGetAddress(CONTRACT_COLLATERALMANAGER));
1468     }
1469 
1470     function etherWrapper() internal view returns (IEtherWrapper) {
1471         return IEtherWrapper(requireAndGetAddress(CONTRACT_ETHER_WRAPPER));
1472     }
1473 
1474     function debtSnapshotStaleTime() external view returns (uint) {
1475         return getDebtSnapshotStaleTime();
1476     }
1477 
1478     function cachedDebt() external view returns (uint) {
1479         return _cachedDebt;
1480     }
1481 
1482     function cachedSynthDebt(bytes32 currencyKey) external view returns (uint) {
1483         return _cachedSynthDebt[currencyKey];
1484     }
1485 
1486     function cacheTimestamp() external view returns (uint) {
1487         return _cacheTimestamp;
1488     }
1489 
1490     function cacheInvalid() external view returns (bool) {
1491         return _cacheInvalid;
1492     }
1493 
1494     function _cacheStale(uint timestamp) internal view returns (bool) {
1495         // Note a 0 timestamp means that the cache is uninitialised.
1496         // We'll keep the check explicitly in case the stale time is
1497         // ever set to something higher than the current unix time (e.g. to turn off staleness).
1498         return getDebtSnapshotStaleTime() < block.timestamp - timestamp || timestamp == 0;
1499     }
1500 
1501     function cacheStale() external view returns (bool) {
1502         return _cacheStale(_cacheTimestamp);
1503     }
1504 
1505     function _issuedSynthValues(bytes32[] memory currencyKeys, uint[] memory rates)
1506         internal
1507         view
1508         returns (uint[] memory values)
1509     {
1510         uint numValues = currencyKeys.length;
1511         values = new uint[](numValues);
1512         ISynth[] memory synths = issuer().getSynths(currencyKeys);
1513 
1514         for (uint i = 0; i < numValues; i++) {
1515             address synthAddress = address(synths[i]);
1516             require(synthAddress != address(0), "Synth does not exist");
1517             uint supply = IERC20(synthAddress).totalSupply();
1518             values[i] = supply.multiplyDecimalRound(rates[i]);
1519         }
1520 
1521         return (values);
1522     }
1523 
1524     function _currentSynthDebts(bytes32[] memory currencyKeys)
1525         internal
1526         view
1527         returns (
1528             uint[] memory snxIssuedDebts,
1529             uint _excludedDebt,
1530             bool anyRateIsInvalid
1531         )
1532     {
1533         (uint[] memory rates, bool isInvalid) = exchangeRates().ratesAndInvalidForCurrencies(currencyKeys);
1534         uint[] memory values = _issuedSynthValues(currencyKeys, rates);
1535         (uint excludedDebt, bool isAnyNonSnxDebtRateInvalid) = _totalNonSnxBackedDebt();
1536         return (values, excludedDebt, isInvalid || isAnyNonSnxDebtRateInvalid);
1537     }
1538 
1539     function currentSynthDebts(bytes32[] calldata currencyKeys)
1540         external
1541         view
1542         returns (
1543             uint[] memory debtValues,
1544             uint excludedDebt,
1545             bool anyRateIsInvalid
1546         )
1547     {
1548         return _currentSynthDebts(currencyKeys);
1549     }
1550 
1551     function _cachedSynthDebts(bytes32[] memory currencyKeys) internal view returns (uint[] memory) {
1552         uint numKeys = currencyKeys.length;
1553         uint[] memory debts = new uint[](numKeys);
1554         for (uint i = 0; i < numKeys; i++) {
1555             debts[i] = _cachedSynthDebt[currencyKeys[i]];
1556         }
1557         return debts;
1558     }
1559 
1560     function cachedSynthDebts(bytes32[] calldata currencyKeys) external view returns (uint[] memory snxIssuedDebts) {
1561         return _cachedSynthDebts(currencyKeys);
1562     }
1563 
1564     // Returns the total sUSD debt backed by non-SNX collateral.
1565     function totalNonSnxBackedDebt() external view returns (uint excludedDebt, bool isInvalid) {
1566         return _totalNonSnxBackedDebt();
1567     }
1568 
1569     function _totalNonSnxBackedDebt() internal view returns (uint excludedDebt, bool isInvalid) {
1570         // Calculate excluded debt.
1571         // 1. MultiCollateral long debt + short debt.
1572         (uint longValue, bool anyTotalLongRateIsInvalid) = collateralManager().totalLong();
1573         (uint shortValue, bool anyTotalShortRateIsInvalid) = collateralManager().totalShort();
1574         isInvalid = anyTotalLongRateIsInvalid || anyTotalShortRateIsInvalid;
1575         excludedDebt = longValue.add(shortValue);
1576 
1577         // 2. EtherWrapper.
1578         // Subtract sETH and sUSD issued by EtherWrapper.
1579         excludedDebt = excludedDebt.add(etherWrapper().totalIssuedSynths());
1580 
1581         return (excludedDebt, isInvalid);
1582     }
1583 
1584     function _currentDebt() internal view returns (uint debt, bool anyRateIsInvalid) {
1585         bytes32[] memory currencyKeys = issuer().availableCurrencyKeys();
1586         (uint[] memory rates, bool isInvalid) = exchangeRates().ratesAndInvalidForCurrencies(currencyKeys);
1587 
1588         // Sum all issued synth values based on their supply.
1589         uint[] memory values = _issuedSynthValues(currencyKeys, rates);
1590         (uint excludedDebt, bool isAnyNonSnxDebtRateInvalid) = _totalNonSnxBackedDebt();
1591 
1592         uint numValues = values.length;
1593         uint total;
1594         for (uint i; i < numValues; i++) {
1595             total = total.add(values[i]);
1596         }
1597         total = total < excludedDebt ? 0 : total.sub(excludedDebt);
1598 
1599         return (total, isInvalid || isAnyNonSnxDebtRateInvalid);
1600     }
1601 
1602     function currentDebt() external view returns (uint debt, bool anyRateIsInvalid) {
1603         return _currentDebt();
1604     }
1605 
1606     function cacheInfo()
1607         external
1608         view
1609         returns (
1610             uint debt,
1611             uint timestamp,
1612             bool isInvalid,
1613             bool isStale
1614         )
1615     {
1616         uint time = _cacheTimestamp;
1617         return (_cachedDebt, time, _cacheInvalid, _cacheStale(time));
1618     }
1619 
1620     /* ========== MUTATIVE FUNCTIONS ========== */
1621 
1622     // Stub out all mutative functions as no-ops;
1623     // since they do nothing, there are no restrictions
1624 
1625     function updateCachedSynthDebts(bytes32[] calldata currencyKeys) external {}
1626 
1627     function updateCachedSynthDebtWithRate(bytes32 currencyKey, uint currencyRate) external {}
1628 
1629     function updateCachedSynthDebtsWithRates(bytes32[] calldata currencyKeys, uint[] calldata currencyRates) external {}
1630 
1631     function updateDebtCacheValidity(bool currentlyInvalid) external {}
1632 
1633     function purgeCachedSynthDebt(bytes32 currencyKey) external {}
1634 
1635     function takeDebtSnapshot() external {}
1636 
1637     /* ========== MODIFIERS ========== */
1638 
1639     function _requireSystemActiveIfNotOwner() internal view {
1640         if (msg.sender != owner) {
1641             systemStatus().requireSystemActive();
1642         }
1643     }
1644 
1645     modifier requireSystemActiveIfNotOwner() {
1646         _requireSystemActiveIfNotOwner();
1647         _;
1648     }
1649 
1650     function _onlyIssuer() internal view {
1651         require(msg.sender == address(issuer()), "Sender is not Issuer");
1652     }
1653 
1654     modifier onlyIssuer() {
1655         _onlyIssuer();
1656         _;
1657     }
1658 
1659     function _onlyIssuerOrExchanger() internal view {
1660         require(msg.sender == address(issuer()) || msg.sender == address(exchanger()), "Sender is not Issuer or Exchanger");
1661     }
1662 
1663     modifier onlyIssuerOrExchanger() {
1664         _onlyIssuerOrExchanger();
1665         _;
1666     }
1667 }
1668 
1669 
1670 // Libraries
1671 
1672 
1673 // Inheritance
1674 
1675 
1676 // https://docs.synthetix.io/contracts/source/contracts/debtcache
1677 contract DebtCache is BaseDebtCache {
1678     using SafeDecimalMath for uint;
1679 
1680     bytes32 public constant CONTRACT_NAME = "DebtCache";
1681 
1682     constructor(address _owner, address _resolver) public BaseDebtCache(_owner, _resolver) {}
1683 
1684     bytes32 internal constant EXCLUDED_DEBT_KEY = "EXCLUDED_DEBT";
1685 
1686     /* ========== MUTATIVE FUNCTIONS ========== */
1687 
1688     // This function exists in case a synth is ever somehow removed without its snapshot being updated.
1689     function purgeCachedSynthDebt(bytes32 currencyKey) external onlyOwner {
1690         require(issuer().synths(currencyKey) == ISynth(0), "Synth exists");
1691         delete _cachedSynthDebt[currencyKey];
1692     }
1693 
1694     function takeDebtSnapshot() external requireSystemActiveIfNotOwner {
1695         bytes32[] memory currencyKeys = issuer().availableCurrencyKeys();
1696         (uint[] memory values, uint excludedDebt, bool isInvalid) = _currentSynthDebts(currencyKeys);
1697 
1698         uint numValues = values.length;
1699         uint snxCollateralDebt;
1700         for (uint i; i < numValues; i++) {
1701             uint value = values[i];
1702             snxCollateralDebt = snxCollateralDebt.add(value);
1703             _cachedSynthDebt[currencyKeys[i]] = value;
1704         }
1705         _cachedSynthDebt[EXCLUDED_DEBT_KEY] = excludedDebt;
1706         uint newDebt = snxCollateralDebt.floorsub(excludedDebt);
1707         _cachedDebt = newDebt;
1708         _cacheTimestamp = block.timestamp;
1709         emit DebtCacheUpdated(newDebt);
1710         emit DebtCacheSnapshotTaken(block.timestamp);
1711 
1712         // (in)validate the cache if necessary
1713         _updateDebtCacheValidity(isInvalid);
1714     }
1715 
1716     function updateCachedSynthDebts(bytes32[] calldata currencyKeys) external requireSystemActiveIfNotOwner {
1717         (uint[] memory rates, bool anyRateInvalid) = exchangeRates().ratesAndInvalidForCurrencies(currencyKeys);
1718         _updateCachedSynthDebtsWithRates(currencyKeys, rates, anyRateInvalid, false);
1719     }
1720 
1721     function updateCachedSynthDebtWithRate(bytes32 currencyKey, uint currencyRate) external onlyIssuer {
1722         bytes32[] memory synthKeyArray = new bytes32[](1);
1723         synthKeyArray[0] = currencyKey;
1724         uint[] memory synthRateArray = new uint[](1);
1725         synthRateArray[0] = currencyRate;
1726         _updateCachedSynthDebtsWithRates(synthKeyArray, synthRateArray, false, false);
1727     }
1728 
1729     function updateCachedSynthDebtsWithRates(bytes32[] calldata currencyKeys, uint[] calldata currencyRates)
1730         external
1731         onlyIssuerOrExchanger
1732     {
1733         _updateCachedSynthDebtsWithRates(currencyKeys, currencyRates, false, false);
1734     }
1735 
1736     function updateDebtCacheValidity(bool currentlyInvalid) external onlyIssuer {
1737         _updateDebtCacheValidity(currentlyInvalid);
1738     }
1739 
1740     /* ========== INTERNAL FUNCTIONS ========== */
1741 
1742     function _updateDebtCacheValidity(bool currentlyInvalid) internal {
1743         if (_cacheInvalid != currentlyInvalid) {
1744             _cacheInvalid = currentlyInvalid;
1745             emit DebtCacheValidityChanged(currentlyInvalid);
1746         }
1747     }
1748 
1749     function _updateCachedSynthDebtsWithRates(
1750         bytes32[] memory currencyKeys,
1751         uint[] memory currentRates,
1752         bool anyRateIsInvalid,
1753         bool recomputeExcludedDebt
1754     ) internal {
1755         uint numKeys = currencyKeys.length;
1756         require(numKeys == currentRates.length, "Input array lengths differ");
1757 
1758         // Update the cached values for each synth, saving the sums as we go.
1759         uint cachedSum;
1760         uint currentSum;
1761         uint excludedDebtSum = _cachedSynthDebt[EXCLUDED_DEBT_KEY];
1762         uint[] memory currentValues = _issuedSynthValues(currencyKeys, currentRates);
1763 
1764         for (uint i = 0; i < numKeys; i++) {
1765             bytes32 key = currencyKeys[i];
1766             uint currentSynthDebt = currentValues[i];
1767             cachedSum = cachedSum.add(_cachedSynthDebt[key]);
1768             currentSum = currentSum.add(currentSynthDebt);
1769             _cachedSynthDebt[key] = currentSynthDebt;
1770         }
1771 
1772         // Always update the cached value of the excluded debt -- it's computed anyway.
1773         if (recomputeExcludedDebt) {
1774             (uint excludedDebt, bool anyNonSnxDebtRateIsInvalid) = _totalNonSnxBackedDebt();
1775             anyRateIsInvalid = anyRateIsInvalid || anyNonSnxDebtRateIsInvalid;
1776             excludedDebtSum = excludedDebt;
1777         }
1778 
1779         cachedSum = cachedSum.floorsub(_cachedSynthDebt[EXCLUDED_DEBT_KEY]);
1780         currentSum = currentSum.floorsub(excludedDebtSum);
1781         _cachedSynthDebt[EXCLUDED_DEBT_KEY] = excludedDebtSum;
1782 
1783         // Compute the difference and apply it to the snapshot
1784         if (cachedSum != currentSum) {
1785             uint debt = _cachedDebt;
1786             // This requirement should never fail, as the total debt snapshot is the sum of the individual synth
1787             // debt snapshots.
1788             require(cachedSum <= debt, "Cached synth sum exceeds total debt");
1789             debt = debt.sub(cachedSum).add(currentSum);
1790             _cachedDebt = debt;
1791             emit DebtCacheUpdated(debt);
1792         }
1793 
1794         // A partial update can invalidate the debt cache, but a full snapshot must be performed in order
1795         // to re-validate it.
1796         if (anyRateIsInvalid) {
1797             _updateDebtCacheValidity(anyRateIsInvalid);
1798         }
1799     }
1800 
1801     /* ========== EVENTS ========== */
1802 
1803     event DebtCacheUpdated(uint cachedDebt);
1804     event DebtCacheSnapshotTaken(uint timestamp);
1805     event DebtCacheValidityChanged(bool indexed isInvalid);
1806 }
1807 
1808     