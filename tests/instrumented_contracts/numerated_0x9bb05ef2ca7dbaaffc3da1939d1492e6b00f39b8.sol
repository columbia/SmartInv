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
467     function totalIssuedSynths(bytes32 currencyKey, bool excludeEtherCollateral) external view returns (uint);
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
499     function liquidateDelinquentAccount(
500         address account,
501         uint susdAmount,
502         address liquidator
503     ) external returns (uint totalRedeemed, uint amountToLiquidate);
504 }
505 
506 
507 // Inheritance
508 
509 
510 // Internal references
511 
512 
513 // https://docs.synthetix.io/contracts/source/contracts/addressresolver
514 contract AddressResolver is Owned, IAddressResolver {
515     mapping(bytes32 => address) public repository;
516 
517     constructor(address _owner) public Owned(_owner) {}
518 
519     /* ========== RESTRICTED FUNCTIONS ========== */
520 
521     function importAddresses(bytes32[] calldata names, address[] calldata destinations) external onlyOwner {
522         require(names.length == destinations.length, "Input lengths must match");
523 
524         for (uint i = 0; i < names.length; i++) {
525             bytes32 name = names[i];
526             address destination = destinations[i];
527             repository[name] = destination;
528             emit AddressImported(name, destination);
529         }
530     }
531 
532     /* ========= PUBLIC FUNCTIONS ========== */
533 
534     function rebuildCaches(MixinResolver[] calldata destinations) external {
535         for (uint i = 0; i < destinations.length; i++) {
536             destinations[i].rebuildCache();
537         }
538     }
539 
540     /* ========== VIEWS ========== */
541 
542     function areAddressesImported(bytes32[] calldata names, address[] calldata destinations) external view returns (bool) {
543         for (uint i = 0; i < names.length; i++) {
544             if (repository[names[i]] != destinations[i]) {
545                 return false;
546             }
547         }
548         return true;
549     }
550 
551     function getAddress(bytes32 name) external view returns (address) {
552         return repository[name];
553     }
554 
555     function requireAndGetAddress(bytes32 name, string calldata reason) external view returns (address) {
556         address _foundAddress = repository[name];
557         require(_foundAddress != address(0), reason);
558         return _foundAddress;
559     }
560 
561     function getSynth(bytes32 key) external view returns (address) {
562         IIssuer issuer = IIssuer(repository["Issuer"]);
563         require(address(issuer) != address(0), "Cannot find Issuer address");
564         return address(issuer.synths(key));
565     }
566 
567     /* ========== EVENTS ========== */
568 
569     event AddressImported(bytes32 name, address destination);
570 }
571 
572 
573 // solhint-disable payable-fallback
574 
575 // https://docs.synthetix.io/contracts/source/contracts/readproxy
576 contract ReadProxy is Owned {
577     address public target;
578 
579     constructor(address _owner) public Owned(_owner) {}
580 
581     function setTarget(address _target) external onlyOwner {
582         target = _target;
583         emit TargetUpdated(target);
584     }
585 
586     function() external {
587         // The basics of a proxy read call
588         // Note that msg.sender in the underlying will always be the address of this contract.
589         assembly {
590             calldatacopy(0, 0, calldatasize)
591 
592             // Use of staticcall - this will revert if the underlying function mutates state
593             let result := staticcall(gas, sload(target_slot), 0, calldatasize, 0, 0)
594             returndatacopy(0, 0, returndatasize)
595 
596             if iszero(result) {
597                 revert(0, returndatasize)
598             }
599             return(0, returndatasize)
600         }
601     }
602 
603     event TargetUpdated(address newTarget);
604 }
605 
606 
607 // Inheritance
608 
609 
610 // Internal references
611 
612 
613 // https://docs.synthetix.io/contracts/source/contracts/mixinresolver
614 contract MixinResolver {
615     AddressResolver public resolver;
616 
617     mapping(bytes32 => address) private addressCache;
618 
619     constructor(address _resolver) internal {
620         resolver = AddressResolver(_resolver);
621     }
622 
623     /* ========== INTERNAL FUNCTIONS ========== */
624 
625     function combineArrays(bytes32[] memory first, bytes32[] memory second)
626         internal
627         pure
628         returns (bytes32[] memory combination)
629     {
630         combination = new bytes32[](first.length + second.length);
631 
632         for (uint i = 0; i < first.length; i++) {
633             combination[i] = first[i];
634         }
635 
636         for (uint j = 0; j < second.length; j++) {
637             combination[first.length + j] = second[j];
638         }
639     }
640 
641     /* ========== PUBLIC FUNCTIONS ========== */
642 
643     // Note: this function is public not external in order for it to be overridden and invoked via super in subclasses
644     function resolverAddressesRequired() public view returns (bytes32[] memory addresses) {}
645 
646     function rebuildCache() public {
647         bytes32[] memory requiredAddresses = resolverAddressesRequired();
648         // The resolver must call this function whenver it updates its state
649         for (uint i = 0; i < requiredAddresses.length; i++) {
650             bytes32 name = requiredAddresses[i];
651             // Note: can only be invoked once the resolver has all the targets needed added
652             address destination =
653                 resolver.requireAndGetAddress(name, string(abi.encodePacked("Resolver missing target: ", name)));
654             addressCache[name] = destination;
655             emit CacheUpdated(name, destination);
656         }
657     }
658 
659     /* ========== VIEWS ========== */
660 
661     function isResolverCached() external view returns (bool) {
662         bytes32[] memory requiredAddresses = resolverAddressesRequired();
663         for (uint i = 0; i < requiredAddresses.length; i++) {
664             bytes32 name = requiredAddresses[i];
665             // false if our cache is invalid or if the resolver doesn't have the required address
666             if (resolver.getAddress(name) != addressCache[name] || addressCache[name] == address(0)) {
667                 return false;
668             }
669         }
670 
671         return true;
672     }
673 
674     /* ========== INTERNAL FUNCTIONS ========== */
675 
676     function requireAndGetAddress(bytes32 name) internal view returns (address) {
677         address _foundAddress = addressCache[name];
678         require(_foundAddress != address(0), string(abi.encodePacked("Missing address: ", name)));
679         return _foundAddress;
680     }
681 
682     /* ========== EVENTS ========== */
683 
684     event CacheUpdated(bytes32 name, address destination);
685 }
686 
687 
688 // https://docs.synthetix.io/contracts/source/interfaces/iflexiblestorage
689 interface IFlexibleStorage {
690     // Views
691     function getUIntValue(bytes32 contractName, bytes32 record) external view returns (uint);
692 
693     function getUIntValues(bytes32 contractName, bytes32[] calldata records) external view returns (uint[] memory);
694 
695     function getIntValue(bytes32 contractName, bytes32 record) external view returns (int);
696 
697     function getIntValues(bytes32 contractName, bytes32[] calldata records) external view returns (int[] memory);
698 
699     function getAddressValue(bytes32 contractName, bytes32 record) external view returns (address);
700 
701     function getAddressValues(bytes32 contractName, bytes32[] calldata records) external view returns (address[] memory);
702 
703     function getBoolValue(bytes32 contractName, bytes32 record) external view returns (bool);
704 
705     function getBoolValues(bytes32 contractName, bytes32[] calldata records) external view returns (bool[] memory);
706 
707     function getBytes32Value(bytes32 contractName, bytes32 record) external view returns (bytes32);
708 
709     function getBytes32Values(bytes32 contractName, bytes32[] calldata records) external view returns (bytes32[] memory);
710 
711     // Mutative functions
712     function deleteUIntValue(bytes32 contractName, bytes32 record) external;
713 
714     function deleteIntValue(bytes32 contractName, bytes32 record) external;
715 
716     function deleteAddressValue(bytes32 contractName, bytes32 record) external;
717 
718     function deleteBoolValue(bytes32 contractName, bytes32 record) external;
719 
720     function deleteBytes32Value(bytes32 contractName, bytes32 record) external;
721 
722     function setUIntValue(
723         bytes32 contractName,
724         bytes32 record,
725         uint value
726     ) external;
727 
728     function setUIntValues(
729         bytes32 contractName,
730         bytes32[] calldata records,
731         uint[] calldata values
732     ) external;
733 
734     function setIntValue(
735         bytes32 contractName,
736         bytes32 record,
737         int value
738     ) external;
739 
740     function setIntValues(
741         bytes32 contractName,
742         bytes32[] calldata records,
743         int[] calldata values
744     ) external;
745 
746     function setAddressValue(
747         bytes32 contractName,
748         bytes32 record,
749         address value
750     ) external;
751 
752     function setAddressValues(
753         bytes32 contractName,
754         bytes32[] calldata records,
755         address[] calldata values
756     ) external;
757 
758     function setBoolValue(
759         bytes32 contractName,
760         bytes32 record,
761         bool value
762     ) external;
763 
764     function setBoolValues(
765         bytes32 contractName,
766         bytes32[] calldata records,
767         bool[] calldata values
768     ) external;
769 
770     function setBytes32Value(
771         bytes32 contractName,
772         bytes32 record,
773         bytes32 value
774     ) external;
775 
776     function setBytes32Values(
777         bytes32 contractName,
778         bytes32[] calldata records,
779         bytes32[] calldata values
780     ) external;
781 }
782 
783 
784 // Internal references
785 
786 
787 // https://docs.synthetix.io/contracts/source/contracts/mixinsystemsettings
788 contract MixinSystemSettings is MixinResolver {
789     bytes32 internal constant SETTING_CONTRACT_NAME = "SystemSettings";
790 
791     bytes32 internal constant SETTING_WAITING_PERIOD_SECS = "waitingPeriodSecs";
792     bytes32 internal constant SETTING_PRICE_DEVIATION_THRESHOLD_FACTOR = "priceDeviationThresholdFactor";
793     bytes32 internal constant SETTING_ISSUANCE_RATIO = "issuanceRatio";
794     bytes32 internal constant SETTING_FEE_PERIOD_DURATION = "feePeriodDuration";
795     bytes32 internal constant SETTING_TARGET_THRESHOLD = "targetThreshold";
796     bytes32 internal constant SETTING_LIQUIDATION_DELAY = "liquidationDelay";
797     bytes32 internal constant SETTING_LIQUIDATION_RATIO = "liquidationRatio";
798     bytes32 internal constant SETTING_LIQUIDATION_PENALTY = "liquidationPenalty";
799     bytes32 internal constant SETTING_RATE_STALE_PERIOD = "rateStalePeriod";
800     bytes32 internal constant SETTING_EXCHANGE_FEE_RATE = "exchangeFeeRate";
801     bytes32 internal constant SETTING_MINIMUM_STAKE_TIME = "minimumStakeTime";
802     bytes32 internal constant SETTING_AGGREGATOR_WARNING_FLAGS = "aggregatorWarningFlags";
803     bytes32 internal constant SETTING_TRADING_REWARDS_ENABLED = "tradingRewardsEnabled";
804     bytes32 internal constant SETTING_DEBT_SNAPSHOT_STALE_TIME = "debtSnapshotStaleTime";
805     bytes32 internal constant SETTING_CROSS_DOMAIN_DEPOSIT_GAS_LIMIT = "crossDomainDepositGasLimit";
806     bytes32 internal constant SETTING_CROSS_DOMAIN_ESCROW_GAS_LIMIT = "crossDomainEscrowGasLimit";
807     bytes32 internal constant SETTING_CROSS_DOMAIN_REWARD_GAS_LIMIT = "crossDomainRewardGasLimit";
808     bytes32 internal constant SETTING_CROSS_DOMAIN_WITHDRAWAL_GAS_LIMIT = "crossDomainWithdrawalGasLimit";
809     bytes32 internal constant SETTING_ETHER_WRAPPER_MAX_ETH = "etherWrapperMaxETH";
810     bytes32 internal constant SETTING_ETHER_WRAPPER_MINT_FEE_RATE = "etherWrapperMintFeeRate";
811     bytes32 internal constant SETTING_ETHER_WRAPPER_BURN_FEE_RATE = "etherWrapperBurnFeeRate";
812 
813     bytes32 internal constant CONTRACT_FLEXIBLESTORAGE = "FlexibleStorage";
814 
815     enum CrossDomainMessageGasLimits {Deposit, Escrow, Reward, Withdrawal}
816 
817     constructor(address _resolver) internal MixinResolver(_resolver) {}
818 
819     function resolverAddressesRequired() public view returns (bytes32[] memory addresses) {
820         addresses = new bytes32[](1);
821         addresses[0] = CONTRACT_FLEXIBLESTORAGE;
822     }
823 
824     function flexibleStorage() internal view returns (IFlexibleStorage) {
825         return IFlexibleStorage(requireAndGetAddress(CONTRACT_FLEXIBLESTORAGE));
826     }
827 
828     function _getGasLimitSetting(CrossDomainMessageGasLimits gasLimitType) internal pure returns (bytes32) {
829         if (gasLimitType == CrossDomainMessageGasLimits.Deposit) {
830             return SETTING_CROSS_DOMAIN_DEPOSIT_GAS_LIMIT;
831         } else if (gasLimitType == CrossDomainMessageGasLimits.Escrow) {
832             return SETTING_CROSS_DOMAIN_ESCROW_GAS_LIMIT;
833         } else if (gasLimitType == CrossDomainMessageGasLimits.Reward) {
834             return SETTING_CROSS_DOMAIN_REWARD_GAS_LIMIT;
835         } else if (gasLimitType == CrossDomainMessageGasLimits.Withdrawal) {
836             return SETTING_CROSS_DOMAIN_WITHDRAWAL_GAS_LIMIT;
837         } else {
838             revert("Unknown gas limit type");
839         }
840     }
841 
842     function getCrossDomainMessageGasLimit(CrossDomainMessageGasLimits gasLimitType) internal view returns (uint) {
843         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, _getGasLimitSetting(gasLimitType));
844     }
845 
846     function getTradingRewardsEnabled() internal view returns (bool) {
847         return flexibleStorage().getBoolValue(SETTING_CONTRACT_NAME, SETTING_TRADING_REWARDS_ENABLED);
848     }
849 
850     function getWaitingPeriodSecs() internal view returns (uint) {
851         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_WAITING_PERIOD_SECS);
852     }
853 
854     function getPriceDeviationThresholdFactor() internal view returns (uint) {
855         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_PRICE_DEVIATION_THRESHOLD_FACTOR);
856     }
857 
858     function getIssuanceRatio() internal view returns (uint) {
859         // lookup on flexible storage directly for gas savings (rather than via SystemSettings)
860         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_ISSUANCE_RATIO);
861     }
862 
863     function getFeePeriodDuration() internal view returns (uint) {
864         // lookup on flexible storage directly for gas savings (rather than via SystemSettings)
865         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_FEE_PERIOD_DURATION);
866     }
867 
868     function getTargetThreshold() internal view returns (uint) {
869         // lookup on flexible storage directly for gas savings (rather than via SystemSettings)
870         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_TARGET_THRESHOLD);
871     }
872 
873     function getLiquidationDelay() internal view returns (uint) {
874         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_LIQUIDATION_DELAY);
875     }
876 
877     function getLiquidationRatio() internal view returns (uint) {
878         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_LIQUIDATION_RATIO);
879     }
880 
881     function getLiquidationPenalty() internal view returns (uint) {
882         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_LIQUIDATION_PENALTY);
883     }
884 
885     function getRateStalePeriod() internal view returns (uint) {
886         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_RATE_STALE_PERIOD);
887     }
888 
889     function getExchangeFeeRate(bytes32 currencyKey) internal view returns (uint) {
890         return
891             flexibleStorage().getUIntValue(
892                 SETTING_CONTRACT_NAME,
893                 keccak256(abi.encodePacked(SETTING_EXCHANGE_FEE_RATE, currencyKey))
894             );
895     }
896 
897     function getMinimumStakeTime() internal view returns (uint) {
898         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_MINIMUM_STAKE_TIME);
899     }
900 
901     function getAggregatorWarningFlags() internal view returns (address) {
902         return flexibleStorage().getAddressValue(SETTING_CONTRACT_NAME, SETTING_AGGREGATOR_WARNING_FLAGS);
903     }
904 
905     function getDebtSnapshotStaleTime() internal view returns (uint) {
906         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_DEBT_SNAPSHOT_STALE_TIME);
907     }
908 
909     function getEtherWrapperMaxETH() internal view returns (uint) {
910         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_ETHER_WRAPPER_MAX_ETH);
911     }
912 
913     function getEtherWrapperMintFeeRate() internal view returns (uint) {
914         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_ETHER_WRAPPER_MINT_FEE_RATE);
915     }
916 
917     function getEtherWrapperBurnFeeRate() internal view returns (uint) {
918         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_ETHER_WRAPPER_BURN_FEE_RATE);
919     }
920 }
921 
922 
923 interface IDebtCache {
924     // Views
925 
926     function cachedDebt() external view returns (uint);
927 
928     function cachedSynthDebt(bytes32 currencyKey) external view returns (uint);
929 
930     function cacheTimestamp() external view returns (uint);
931 
932     function cacheInvalid() external view returns (bool);
933 
934     function cacheStale() external view returns (bool);
935 
936     function currentSynthDebts(bytes32[] calldata currencyKeys)
937         external
938         view
939         returns (
940             uint[] memory debtValues,
941             uint excludedDebt,
942             bool anyRateIsInvalid
943         );
944 
945     function cachedSynthDebts(bytes32[] calldata currencyKeys) external view returns (uint[] memory debtValues);
946 
947     function totalNonSnxBackedDebt() external view returns (uint excludedDebt, bool isInvalid);
948 
949     function currentDebt() external view returns (uint debt, bool anyRateIsInvalid);
950 
951     function cacheInfo()
952         external
953         view
954         returns (
955             uint debt,
956             uint timestamp,
957             bool isInvalid,
958             bool isStale
959         );
960 
961     // Mutative functions
962 
963     function updateCachedSynthDebts(bytes32[] calldata currencyKeys) external;
964 
965     function updateCachedSynthDebtWithRate(bytes32 currencyKey, uint currencyRate) external;
966 
967     function updateCachedSynthDebtsWithRates(bytes32[] calldata currencyKeys, uint[] calldata currencyRates) external;
968 
969     function updateDebtCacheValidity(bool currentlyInvalid) external;
970 
971     function purgeCachedSynthDebt(bytes32 currencyKey) external;
972 
973     function takeDebtSnapshot() external;
974 }
975 
976 
977 interface IVirtualSynth {
978     // Views
979     function balanceOfUnderlying(address account) external view returns (uint);
980 
981     function rate() external view returns (uint);
982 
983     function readyToSettle() external view returns (bool);
984 
985     function secsLeftInWaitingPeriod() external view returns (uint);
986 
987     function settled() external view returns (bool);
988 
989     function synth() external view returns (ISynth);
990 
991     // Mutative functions
992     function settle(address account) external;
993 }
994 
995 
996 // https://docs.synthetix.io/contracts/source/interfaces/iexchanger
997 interface IExchanger {
998     // Views
999     function calculateAmountAfterSettlement(
1000         address from,
1001         bytes32 currencyKey,
1002         uint amount,
1003         uint refunded
1004     ) external view returns (uint amountAfterSettlement);
1005 
1006     function isSynthRateInvalid(bytes32 currencyKey) external view returns (bool);
1007 
1008     function maxSecsLeftInWaitingPeriod(address account, bytes32 currencyKey) external view returns (uint);
1009 
1010     function settlementOwing(address account, bytes32 currencyKey)
1011         external
1012         view
1013         returns (
1014             uint reclaimAmount,
1015             uint rebateAmount,
1016             uint numEntries
1017         );
1018 
1019     function hasWaitingPeriodOrSettlementOwing(address account, bytes32 currencyKey) external view returns (bool);
1020 
1021     function feeRateForExchange(bytes32 sourceCurrencyKey, bytes32 destinationCurrencyKey)
1022         external
1023         view
1024         returns (uint exchangeFeeRate);
1025 
1026     function getAmountsForExchange(
1027         uint sourceAmount,
1028         bytes32 sourceCurrencyKey,
1029         bytes32 destinationCurrencyKey
1030     )
1031         external
1032         view
1033         returns (
1034             uint amountReceived,
1035             uint fee,
1036             uint exchangeFeeRate
1037         );
1038 
1039     function priceDeviationThresholdFactor() external view returns (uint);
1040 
1041     function waitingPeriodSecs() external view returns (uint);
1042 
1043     // Mutative functions
1044     function exchange(
1045         address from,
1046         bytes32 sourceCurrencyKey,
1047         uint sourceAmount,
1048         bytes32 destinationCurrencyKey,
1049         address destinationAddress
1050     ) external returns (uint amountReceived);
1051 
1052     function exchangeOnBehalf(
1053         address exchangeForAddress,
1054         address from,
1055         bytes32 sourceCurrencyKey,
1056         uint sourceAmount,
1057         bytes32 destinationCurrencyKey
1058     ) external returns (uint amountReceived);
1059 
1060     function exchangeWithTracking(
1061         address from,
1062         bytes32 sourceCurrencyKey,
1063         uint sourceAmount,
1064         bytes32 destinationCurrencyKey,
1065         address destinationAddress,
1066         address originator,
1067         bytes32 trackingCode
1068     ) external returns (uint amountReceived);
1069 
1070     function exchangeOnBehalfWithTracking(
1071         address exchangeForAddress,
1072         address from,
1073         bytes32 sourceCurrencyKey,
1074         uint sourceAmount,
1075         bytes32 destinationCurrencyKey,
1076         address originator,
1077         bytes32 trackingCode
1078     ) external returns (uint amountReceived);
1079 
1080     function exchangeWithVirtual(
1081         address from,
1082         bytes32 sourceCurrencyKey,
1083         uint sourceAmount,
1084         bytes32 destinationCurrencyKey,
1085         address destinationAddress,
1086         bytes32 trackingCode
1087     ) external returns (uint amountReceived, IVirtualSynth vSynth);
1088 
1089     function settle(address from, bytes32 currencyKey)
1090         external
1091         returns (
1092             uint reclaimed,
1093             uint refunded,
1094             uint numEntries
1095         );
1096 
1097     function setLastExchangeRateForSynth(bytes32 currencyKey, uint rate) external;
1098 
1099     function suspendSynthWithInvalidRate(bytes32 currencyKey) external;
1100 }
1101 
1102 
1103 // https://docs.synthetix.io/contracts/source/interfaces/iexchangerates
1104 interface IExchangeRates {
1105     // Structs
1106     struct RateAndUpdatedTime {
1107         uint216 rate;
1108         uint40 time;
1109     }
1110 
1111     struct InversePricing {
1112         uint entryPoint;
1113         uint upperLimit;
1114         uint lowerLimit;
1115         bool frozenAtUpperLimit;
1116         bool frozenAtLowerLimit;
1117     }
1118 
1119     // Views
1120     function aggregators(bytes32 currencyKey) external view returns (address);
1121 
1122     function aggregatorWarningFlags() external view returns (address);
1123 
1124     function anyRateIsInvalid(bytes32[] calldata currencyKeys) external view returns (bool);
1125 
1126     function canFreezeRate(bytes32 currencyKey) external view returns (bool);
1127 
1128     function currentRoundForRate(bytes32 currencyKey) external view returns (uint);
1129 
1130     function currenciesUsingAggregator(address aggregator) external view returns (bytes32[] memory);
1131 
1132     function effectiveValue(
1133         bytes32 sourceCurrencyKey,
1134         uint sourceAmount,
1135         bytes32 destinationCurrencyKey
1136     ) external view returns (uint value);
1137 
1138     function effectiveValueAndRates(
1139         bytes32 sourceCurrencyKey,
1140         uint sourceAmount,
1141         bytes32 destinationCurrencyKey
1142     )
1143         external
1144         view
1145         returns (
1146             uint value,
1147             uint sourceRate,
1148             uint destinationRate
1149         );
1150 
1151     function effectiveValueAtRound(
1152         bytes32 sourceCurrencyKey,
1153         uint sourceAmount,
1154         bytes32 destinationCurrencyKey,
1155         uint roundIdForSrc,
1156         uint roundIdForDest
1157     ) external view returns (uint value);
1158 
1159     function getCurrentRoundId(bytes32 currencyKey) external view returns (uint);
1160 
1161     function getLastRoundIdBeforeElapsedSecs(
1162         bytes32 currencyKey,
1163         uint startingRoundId,
1164         uint startingTimestamp,
1165         uint timediff
1166     ) external view returns (uint);
1167 
1168     function inversePricing(bytes32 currencyKey)
1169         external
1170         view
1171         returns (
1172             uint entryPoint,
1173             uint upperLimit,
1174             uint lowerLimit,
1175             bool frozenAtUpperLimit,
1176             bool frozenAtLowerLimit
1177         );
1178 
1179     function lastRateUpdateTimes(bytes32 currencyKey) external view returns (uint256);
1180 
1181     function oracle() external view returns (address);
1182 
1183     function rateAndTimestampAtRound(bytes32 currencyKey, uint roundId) external view returns (uint rate, uint time);
1184 
1185     function rateAndUpdatedTime(bytes32 currencyKey) external view returns (uint rate, uint time);
1186 
1187     function rateAndInvalid(bytes32 currencyKey) external view returns (uint rate, bool isInvalid);
1188 
1189     function rateForCurrency(bytes32 currencyKey) external view returns (uint);
1190 
1191     function rateIsFlagged(bytes32 currencyKey) external view returns (bool);
1192 
1193     function rateIsFrozen(bytes32 currencyKey) external view returns (bool);
1194 
1195     function rateIsInvalid(bytes32 currencyKey) external view returns (bool);
1196 
1197     function rateIsStale(bytes32 currencyKey) external view returns (bool);
1198 
1199     function rateStalePeriod() external view returns (uint);
1200 
1201     function ratesAndUpdatedTimeForCurrencyLastNRounds(bytes32 currencyKey, uint numRounds)
1202         external
1203         view
1204         returns (uint[] memory rates, uint[] memory times);
1205 
1206     function ratesAndInvalidForCurrencies(bytes32[] calldata currencyKeys)
1207         external
1208         view
1209         returns (uint[] memory rates, bool anyRateInvalid);
1210 
1211     function ratesForCurrencies(bytes32[] calldata currencyKeys) external view returns (uint[] memory);
1212 
1213     // Mutative functions
1214     function freezeRate(bytes32 currencyKey) external;
1215 }
1216 
1217 
1218 // https://docs.synthetix.io/contracts/source/interfaces/isystemstatus
1219 interface ISystemStatus {
1220     struct Status {
1221         bool canSuspend;
1222         bool canResume;
1223     }
1224 
1225     struct Suspension {
1226         bool suspended;
1227         // reason is an integer code,
1228         // 0 => no reason, 1 => upgrading, 2+ => defined by system usage
1229         uint248 reason;
1230     }
1231 
1232     // Views
1233     function accessControl(bytes32 section, address account) external view returns (bool canSuspend, bool canResume);
1234 
1235     function requireSystemActive() external view;
1236 
1237     function requireIssuanceActive() external view;
1238 
1239     function requireExchangeActive() external view;
1240 
1241     function requireExchangeBetweenSynthsAllowed(bytes32 sourceCurrencyKey, bytes32 destinationCurrencyKey) external view;
1242 
1243     function requireSynthActive(bytes32 currencyKey) external view;
1244 
1245     function requireSynthsActive(bytes32 sourceCurrencyKey, bytes32 destinationCurrencyKey) external view;
1246 
1247     function systemSuspension() external view returns (bool suspended, uint248 reason);
1248 
1249     function issuanceSuspension() external view returns (bool suspended, uint248 reason);
1250 
1251     function exchangeSuspension() external view returns (bool suspended, uint248 reason);
1252 
1253     function synthExchangeSuspension(bytes32 currencyKey) external view returns (bool suspended, uint248 reason);
1254 
1255     function synthSuspension(bytes32 currencyKey) external view returns (bool suspended, uint248 reason);
1256 
1257     function getSynthExchangeSuspensions(bytes32[] calldata synths)
1258         external
1259         view
1260         returns (bool[] memory exchangeSuspensions, uint256[] memory reasons);
1261 
1262     function getSynthSuspensions(bytes32[] calldata synths)
1263         external
1264         view
1265         returns (bool[] memory suspensions, uint256[] memory reasons);
1266 
1267     // Restricted functions
1268     function suspendSynth(bytes32 currencyKey, uint256 reason) external;
1269 
1270     function updateAccessControl(
1271         bytes32 section,
1272         address account,
1273         bool canSuspend,
1274         bool canResume
1275     ) external;
1276 }
1277 
1278 
1279 // https://docs.synthetix.io/contracts/source/interfaces/iethercollateral
1280 interface IEtherCollateral {
1281     // Views
1282     function totalIssuedSynths() external view returns (uint256);
1283 
1284     function totalLoansCreated() external view returns (uint256);
1285 
1286     function totalOpenLoanCount() external view returns (uint256);
1287 
1288     // Mutative functions
1289     function openLoan() external payable returns (uint256 loanID);
1290 
1291     function closeLoan(uint256 loanID) external;
1292 
1293     function liquidateUnclosedLoan(address _loanCreatorsAddress, uint256 _loanID) external;
1294 }
1295 
1296 
1297 // https://docs.synthetix.io/contracts/source/interfaces/iethercollateralsusd
1298 interface IEtherCollateralsUSD {
1299     // Views
1300     function totalIssuedSynths() external view returns (uint256);
1301 
1302     function totalLoansCreated() external view returns (uint256);
1303 
1304     function totalOpenLoanCount() external view returns (uint256);
1305 
1306     // Mutative functions
1307     function openLoan(uint256 _loanAmount) external payable returns (uint256 loanID);
1308 
1309     function closeLoan(uint256 loanID) external;
1310 
1311     function liquidateUnclosedLoan(address _loanCreatorsAddress, uint256 _loanID) external;
1312 
1313     function depositCollateral(address account, uint256 loanID) external payable;
1314 
1315     function withdrawCollateral(uint256 loanID, uint256 withdrawAmount) external;
1316 
1317     function repayLoan(
1318         address _loanCreatorsAddress,
1319         uint256 _loanID,
1320         uint256 _repayAmount
1321     ) external;
1322 }
1323 
1324 
1325 // https://docs.synthetix.io/contracts/source/interfaces/ierc20
1326 interface IERC20 {
1327     // ERC20 Optional Views
1328     function name() external view returns (string memory);
1329 
1330     function symbol() external view returns (string memory);
1331 
1332     function decimals() external view returns (uint8);
1333 
1334     // Views
1335     function totalSupply() external view returns (uint);
1336 
1337     function balanceOf(address owner) external view returns (uint);
1338 
1339     function allowance(address owner, address spender) external view returns (uint);
1340 
1341     // Mutative functions
1342     function transfer(address to, uint value) external returns (bool);
1343 
1344     function approve(address spender, uint value) external returns (bool);
1345 
1346     function transferFrom(
1347         address from,
1348         address to,
1349         uint value
1350     ) external returns (bool);
1351 
1352     // Events
1353     event Transfer(address indexed from, address indexed to, uint value);
1354 
1355     event Approval(address indexed owner, address indexed spender, uint value);
1356 }
1357 
1358 
1359 interface ICollateralManager {
1360     // Manager information
1361     function hasCollateral(address collateral) external view returns (bool);
1362 
1363     function isSynthManaged(bytes32 currencyKey) external view returns (bool);
1364 
1365     // State information
1366     function long(bytes32 synth) external view returns (uint amount);
1367 
1368     function short(bytes32 synth) external view returns (uint amount);
1369 
1370     function totalLong() external view returns (uint susdValue, bool anyRateIsInvalid);
1371 
1372     function totalShort() external view returns (uint susdValue, bool anyRateIsInvalid);
1373 
1374     function getBorrowRate() external view returns (uint borrowRate, bool anyRateIsInvalid);
1375 
1376     function getShortRate(bytes32 synth) external view returns (uint shortRate, bool rateIsInvalid);
1377 
1378     function getRatesAndTime(uint index)
1379         external
1380         view
1381         returns (
1382             uint entryRate,
1383             uint lastRate,
1384             uint lastUpdated,
1385             uint newIndex
1386         );
1387 
1388     function getShortRatesAndTime(bytes32 currency, uint index)
1389         external
1390         view
1391         returns (
1392             uint entryRate,
1393             uint lastRate,
1394             uint lastUpdated,
1395             uint newIndex
1396         );
1397 
1398     function exceedsDebtLimit(uint amount, bytes32 currency) external view returns (bool canIssue, bool anyRateIsInvalid);
1399 
1400     function areSynthsAndCurrenciesSet(bytes32[] calldata requiredSynthNamesInResolver, bytes32[] calldata synthKeys)
1401         external
1402         view
1403         returns (bool);
1404 
1405     function areShortableSynthsSet(bytes32[] calldata requiredSynthNamesInResolver, bytes32[] calldata synthKeys)
1406         external
1407         view
1408         returns (bool);
1409 
1410     // Loans
1411     function getNewLoanId() external returns (uint id);
1412 
1413     // Manager mutative
1414     function addCollaterals(address[] calldata collaterals) external;
1415 
1416     function removeCollaterals(address[] calldata collaterals) external;
1417 
1418     function addSynths(bytes32[] calldata synthNamesInResolver, bytes32[] calldata synthKeys) external;
1419 
1420     function removeSynths(bytes32[] calldata synths, bytes32[] calldata synthKeys) external;
1421 
1422     function addShortableSynths(bytes32[2][] calldata requiredSynthAndInverseNamesInResolver, bytes32[] calldata synthKeys)
1423         external;
1424 
1425     function removeShortableSynths(bytes32[] calldata synths) external;
1426 
1427     // State mutative
1428     function updateBorrowRates(uint rate) external;
1429 
1430     function updateShortRates(bytes32 currency, uint rate) external;
1431 
1432     function incrementLongs(bytes32 synth, uint amount) external;
1433 
1434     function decrementLongs(bytes32 synth, uint amount) external;
1435 
1436     function incrementShorts(bytes32 synth, uint amount) external;
1437 
1438     function decrementShorts(bytes32 synth, uint amount) external;
1439 }
1440 
1441 
1442 interface IWETH {
1443     // ERC20 Optional Views
1444     function name() external view returns (string memory);
1445 
1446     function symbol() external view returns (string memory);
1447 
1448     function decimals() external view returns (uint8);
1449 
1450     // Views
1451     function totalSupply() external view returns (uint);
1452 
1453     function balanceOf(address owner) external view returns (uint);
1454 
1455     function allowance(address owner, address spender) external view returns (uint);
1456 
1457     // Mutative functions
1458     function transfer(address to, uint value) external returns (bool);
1459 
1460     function approve(address spender, uint value) external returns (bool);
1461 
1462     function transferFrom(
1463         address from,
1464         address to,
1465         uint value
1466     ) external returns (bool);
1467 
1468     // WETH-specific functions.
1469     function deposit() external payable;
1470 
1471     function withdraw(uint amount) external;
1472 
1473     // Events
1474     event Transfer(address indexed from, address indexed to, uint value);
1475     event Approval(address indexed owner, address indexed spender, uint value);
1476     event Deposit(address indexed to, uint amount);
1477     event Withdrawal(address indexed to, uint amount);
1478 }
1479 
1480 
1481 // https://docs.synthetix.io/contracts/source/interfaces/ietherwrapper
1482 contract IEtherWrapper {
1483     function mint(uint amount) external;
1484 
1485     function burn(uint amount) external;
1486 
1487     function distributeFees() external;
1488 
1489     function capacity() external view returns (uint);
1490 
1491     function getReserves() external view returns (uint);
1492 
1493     function totalIssuedSynths() external view returns (uint);
1494 
1495     function calculateMintFee(uint amount) public view returns (uint);
1496 
1497     function calculateBurnFee(uint amount) public view returns (uint);
1498 
1499     function maxETH() public view returns (uint256);
1500 
1501     function mintFeeRate() public view returns (uint256);
1502 
1503     function burnFeeRate() public view returns (uint256);
1504 
1505     function weth() public view returns (IWETH);
1506 }
1507 
1508 
1509 // Inheritance
1510 
1511 
1512 // Libraries
1513 
1514 
1515 // Internal references
1516 
1517 
1518 // https://docs.synthetix.io/contracts/source/contracts/debtcache
1519 contract BaseDebtCache is Owned, MixinSystemSettings, IDebtCache {
1520     using SafeMath for uint;
1521     using SafeDecimalMath for uint;
1522 
1523     uint internal _cachedDebt;
1524     mapping(bytes32 => uint) internal _cachedSynthDebt;
1525     uint internal _cacheTimestamp;
1526     bool internal _cacheInvalid = true;
1527 
1528     /* ========== ENCODED NAMES ========== */
1529 
1530     bytes32 internal constant sUSD = "sUSD";
1531     bytes32 internal constant sETH = "sETH";
1532 
1533     /* ========== ADDRESS RESOLVER CONFIGURATION ========== */
1534 
1535     bytes32 private constant CONTRACT_ISSUER = "Issuer";
1536     bytes32 private constant CONTRACT_EXCHANGER = "Exchanger";
1537     bytes32 private constant CONTRACT_EXRATES = "ExchangeRates";
1538     bytes32 private constant CONTRACT_SYSTEMSTATUS = "SystemStatus";
1539     bytes32 private constant CONTRACT_ETHERCOLLATERAL = "EtherCollateral";
1540     bytes32 private constant CONTRACT_ETHERCOLLATERAL_SUSD = "EtherCollateralsUSD";
1541     bytes32 private constant CONTRACT_COLLATERALMANAGER = "CollateralManager";
1542     bytes32 private constant CONTRACT_ETHER_WRAPPER = "EtherWrapper";
1543 
1544     constructor(address _owner, address _resolver) public Owned(_owner) MixinSystemSettings(_resolver) {}
1545 
1546     /* ========== VIEWS ========== */
1547 
1548     function resolverAddressesRequired() public view returns (bytes32[] memory addresses) {
1549         bytes32[] memory existingAddresses = MixinSystemSettings.resolverAddressesRequired();
1550         bytes32[] memory newAddresses = new bytes32[](8);
1551         newAddresses[0] = CONTRACT_ISSUER;
1552         newAddresses[1] = CONTRACT_EXCHANGER;
1553         newAddresses[2] = CONTRACT_EXRATES;
1554         newAddresses[3] = CONTRACT_SYSTEMSTATUS;
1555         newAddresses[4] = CONTRACT_ETHERCOLLATERAL;
1556         newAddresses[5] = CONTRACT_ETHERCOLLATERAL_SUSD;
1557         newAddresses[6] = CONTRACT_COLLATERALMANAGER;
1558         newAddresses[7] = CONTRACT_ETHER_WRAPPER;
1559         addresses = combineArrays(existingAddresses, newAddresses);
1560     }
1561 
1562     function issuer() internal view returns (IIssuer) {
1563         return IIssuer(requireAndGetAddress(CONTRACT_ISSUER));
1564     }
1565 
1566     function exchanger() internal view returns (IExchanger) {
1567         return IExchanger(requireAndGetAddress(CONTRACT_EXCHANGER));
1568     }
1569 
1570     function exchangeRates() internal view returns (IExchangeRates) {
1571         return IExchangeRates(requireAndGetAddress(CONTRACT_EXRATES));
1572     }
1573 
1574     function systemStatus() internal view returns (ISystemStatus) {
1575         return ISystemStatus(requireAndGetAddress(CONTRACT_SYSTEMSTATUS));
1576     }
1577 
1578     function etherCollateral() internal view returns (IEtherCollateral) {
1579         return IEtherCollateral(requireAndGetAddress(CONTRACT_ETHERCOLLATERAL));
1580     }
1581 
1582     function etherCollateralsUSD() internal view returns (IEtherCollateralsUSD) {
1583         return IEtherCollateralsUSD(requireAndGetAddress(CONTRACT_ETHERCOLLATERAL_SUSD));
1584     }
1585 
1586     function collateralManager() internal view returns (ICollateralManager) {
1587         return ICollateralManager(requireAndGetAddress(CONTRACT_COLLATERALMANAGER));
1588     }
1589 
1590     function etherWrapper() internal view returns (IEtherWrapper) {
1591         return IEtherWrapper(requireAndGetAddress(CONTRACT_ETHER_WRAPPER));
1592     }
1593 
1594     function debtSnapshotStaleTime() external view returns (uint) {
1595         return getDebtSnapshotStaleTime();
1596     }
1597 
1598     function cachedDebt() external view returns (uint) {
1599         return _cachedDebt;
1600     }
1601 
1602     function cachedSynthDebt(bytes32 currencyKey) external view returns (uint) {
1603         return _cachedSynthDebt[currencyKey];
1604     }
1605 
1606     function cacheTimestamp() external view returns (uint) {
1607         return _cacheTimestamp;
1608     }
1609 
1610     function cacheInvalid() external view returns (bool) {
1611         return _cacheInvalid;
1612     }
1613 
1614     function _cacheStale(uint timestamp) internal view returns (bool) {
1615         // Note a 0 timestamp means that the cache is uninitialised.
1616         // We'll keep the check explicitly in case the stale time is
1617         // ever set to something higher than the current unix time (e.g. to turn off staleness).
1618         return getDebtSnapshotStaleTime() < block.timestamp - timestamp || timestamp == 0;
1619     }
1620 
1621     function cacheStale() external view returns (bool) {
1622         return _cacheStale(_cacheTimestamp);
1623     }
1624 
1625     function _issuedSynthValues(bytes32[] memory currencyKeys, uint[] memory rates)
1626         internal
1627         view
1628         returns (uint[] memory values)
1629     {
1630         uint numValues = currencyKeys.length;
1631         values = new uint[](numValues);
1632         ISynth[] memory synths = issuer().getSynths(currencyKeys);
1633 
1634         for (uint i = 0; i < numValues; i++) {
1635             address synthAddress = address(synths[i]);
1636             require(synthAddress != address(0), "Synth does not exist");
1637             uint supply = IERC20(synthAddress).totalSupply();
1638             values[i] = supply.multiplyDecimalRound(rates[i]);
1639         }
1640 
1641         return (values);
1642     }
1643 
1644     function _currentSynthDebts(bytes32[] memory currencyKeys)
1645         internal
1646         view
1647         returns (
1648             uint[] memory snxIssuedDebts,
1649             uint _excludedDebt,
1650             bool anyRateIsInvalid
1651         )
1652     {
1653         (uint[] memory rates, bool isInvalid) = exchangeRates().ratesAndInvalidForCurrencies(currencyKeys);
1654         uint[] memory values = _issuedSynthValues(currencyKeys, rates);
1655         (uint excludedDebt, bool isAnyNonSnxDebtRateInvalid) = _totalNonSnxBackedDebt();
1656         return (values, excludedDebt, isInvalid || isAnyNonSnxDebtRateInvalid);
1657     }
1658 
1659     function currentSynthDebts(bytes32[] calldata currencyKeys)
1660         external
1661         view
1662         returns (
1663             uint[] memory debtValues,
1664             uint excludedDebt,
1665             bool anyRateIsInvalid
1666         )
1667     {
1668         return _currentSynthDebts(currencyKeys);
1669     }
1670 
1671     function _cachedSynthDebts(bytes32[] memory currencyKeys) internal view returns (uint[] memory) {
1672         uint numKeys = currencyKeys.length;
1673         uint[] memory debts = new uint[](numKeys);
1674         for (uint i = 0; i < numKeys; i++) {
1675             debts[i] = _cachedSynthDebt[currencyKeys[i]];
1676         }
1677         return debts;
1678     }
1679 
1680     function cachedSynthDebts(bytes32[] calldata currencyKeys) external view returns (uint[] memory snxIssuedDebts) {
1681         return _cachedSynthDebts(currencyKeys);
1682     }
1683 
1684     // Returns the total sUSD debt backed by non-SNX collateral.
1685     function totalNonSnxBackedDebt() external view returns (uint excludedDebt, bool isInvalid) {
1686         return _totalNonSnxBackedDebt();
1687     }
1688 
1689     function _totalNonSnxBackedDebt() internal view returns (uint excludedDebt, bool isInvalid) {
1690         // Calculate excluded debt.
1691         // 1. Ether Collateral.
1692         excludedDebt = excludedDebt.add(etherCollateralsUSD().totalIssuedSynths()); // Ether-backed sUSD
1693 
1694         uint etherCollateralTotalIssuedSynths = etherCollateral().totalIssuedSynths();
1695         // We check the supply > 0 as on L2, we may not yet have up-to-date rates for sETH.
1696         if (etherCollateralTotalIssuedSynths > 0) {
1697             (uint sETHRate, bool sETHRateIsInvalid) = exchangeRates().rateAndInvalid(sETH);
1698             isInvalid = isInvalid || sETHRateIsInvalid;
1699             excludedDebt = excludedDebt.add(etherCollateralTotalIssuedSynths.multiplyDecimalRound(sETHRate)); // Ether-backed sETH
1700         }
1701 
1702         // 2. MultiCollateral long debt + short debt.
1703         (uint longValue, bool anyTotalLongRateIsInvalid) = collateralManager().totalLong();
1704         (uint shortValue, bool anyTotalShortRateIsInvalid) = collateralManager().totalShort();
1705         isInvalid = isInvalid || anyTotalLongRateIsInvalid || anyTotalShortRateIsInvalid;
1706         excludedDebt = excludedDebt.add(longValue).add(shortValue);
1707 
1708         // 3. EtherWrapper.
1709         // Subtract sETH and sUSD issued by EtherWrapper.
1710         excludedDebt = excludedDebt.add(etherWrapper().totalIssuedSynths());
1711 
1712         return (excludedDebt, isInvalid);
1713     }
1714 
1715     function _currentDebt() internal view returns (uint debt, bool anyRateIsInvalid) {
1716         bytes32[] memory currencyKeys = issuer().availableCurrencyKeys();
1717         (uint[] memory rates, bool isInvalid) = exchangeRates().ratesAndInvalidForCurrencies(currencyKeys);
1718 
1719         // Sum all issued synth values based on their supply.
1720         uint[] memory values = _issuedSynthValues(currencyKeys, rates);
1721         (uint excludedDebt, bool isAnyNonSnxDebtRateInvalid) = _totalNonSnxBackedDebt();
1722 
1723         uint numValues = values.length;
1724         uint total;
1725         for (uint i; i < numValues; i++) {
1726             total = total.add(values[i]);
1727         }
1728         total = total < excludedDebt ? 0 : total.sub(excludedDebt);
1729 
1730         return (total, isInvalid || isAnyNonSnxDebtRateInvalid);
1731     }
1732 
1733     function currentDebt() external view returns (uint debt, bool anyRateIsInvalid) {
1734         return _currentDebt();
1735     }
1736 
1737     function cacheInfo()
1738         external
1739         view
1740         returns (
1741             uint debt,
1742             uint timestamp,
1743             bool isInvalid,
1744             bool isStale
1745         )
1746     {
1747         uint time = _cacheTimestamp;
1748         return (_cachedDebt, time, _cacheInvalid, _cacheStale(time));
1749     }
1750 
1751     /* ========== MUTATIVE FUNCTIONS ========== */
1752 
1753     // Stub out all mutative functions as no-ops;
1754     // since they do nothing, there are no restrictions
1755 
1756     function updateCachedSynthDebts(bytes32[] calldata currencyKeys) external {}
1757 
1758     function updateCachedSynthDebtWithRate(bytes32 currencyKey, uint currencyRate) external {}
1759 
1760     function updateCachedSynthDebtsWithRates(bytes32[] calldata currencyKeys, uint[] calldata currencyRates) external {}
1761 
1762     function updateDebtCacheValidity(bool currentlyInvalid) external {}
1763 
1764     function purgeCachedSynthDebt(bytes32 currencyKey) external {}
1765 
1766     function takeDebtSnapshot() external {}
1767 
1768     /* ========== MODIFIERS ========== */
1769 
1770     function _requireSystemActiveIfNotOwner() internal view {
1771         if (msg.sender != owner) {
1772             systemStatus().requireSystemActive();
1773         }
1774     }
1775 
1776     modifier requireSystemActiveIfNotOwner() {
1777         _requireSystemActiveIfNotOwner();
1778         _;
1779     }
1780 
1781     function _onlyIssuer() internal view {
1782         require(msg.sender == address(issuer()), "Sender is not Issuer");
1783     }
1784 
1785     modifier onlyIssuer() {
1786         _onlyIssuer();
1787         _;
1788     }
1789 
1790     function _onlyIssuerOrExchanger() internal view {
1791         require(msg.sender == address(issuer()) || msg.sender == address(exchanger()), "Sender is not Issuer or Exchanger");
1792     }
1793 
1794     modifier onlyIssuerOrExchanger() {
1795         _onlyIssuerOrExchanger();
1796         _;
1797     }
1798 }
1799 
1800 
1801 // Libraries
1802 
1803 
1804 // Inheritance
1805 
1806 
1807 // https://docs.synthetix.io/contracts/source/contracts/debtcache
1808 contract DebtCache is BaseDebtCache {
1809     using SafeDecimalMath for uint;
1810 
1811     constructor(address _owner, address _resolver) public BaseDebtCache(_owner, _resolver) {}
1812 
1813     bytes32 internal constant EXCLUDED_DEBT_KEY = "EXCLUDED_DEBT";
1814 
1815     /* ========== MUTATIVE FUNCTIONS ========== */
1816 
1817     // This function exists in case a synth is ever somehow removed without its snapshot being updated.
1818     function purgeCachedSynthDebt(bytes32 currencyKey) external onlyOwner {
1819         require(issuer().synths(currencyKey) == ISynth(0), "Synth exists");
1820         delete _cachedSynthDebt[currencyKey];
1821     }
1822 
1823     function takeDebtSnapshot() external requireSystemActiveIfNotOwner {
1824         bytes32[] memory currencyKeys = issuer().availableCurrencyKeys();
1825         (uint[] memory values, uint excludedDebt, bool isInvalid) = _currentSynthDebts(currencyKeys);
1826 
1827         uint numValues = values.length;
1828         uint snxCollateralDebt;
1829         for (uint i; i < numValues; i++) {
1830             uint value = values[i];
1831             snxCollateralDebt = snxCollateralDebt.add(value);
1832             _cachedSynthDebt[currencyKeys[i]] = value;
1833         }
1834         _cachedSynthDebt[EXCLUDED_DEBT_KEY] = excludedDebt;
1835         _cachedDebt = snxCollateralDebt.floorsub(excludedDebt);
1836         _cacheTimestamp = block.timestamp;
1837         emit DebtCacheUpdated(snxCollateralDebt);
1838         emit DebtCacheSnapshotTaken(block.timestamp);
1839 
1840         // (in)validate the cache if necessary
1841         _updateDebtCacheValidity(isInvalid);
1842     }
1843 
1844     function updateCachedSynthDebts(bytes32[] calldata currencyKeys) external requireSystemActiveIfNotOwner {
1845         (uint[] memory rates, bool anyRateInvalid) = exchangeRates().ratesAndInvalidForCurrencies(currencyKeys);
1846         _updateCachedSynthDebtsWithRates(currencyKeys, rates, anyRateInvalid, false);
1847     }
1848 
1849     function updateCachedSynthDebtWithRate(bytes32 currencyKey, uint currencyRate) external onlyIssuer {
1850         bytes32[] memory synthKeyArray = new bytes32[](1);
1851         synthKeyArray[0] = currencyKey;
1852         uint[] memory synthRateArray = new uint[](1);
1853         synthRateArray[0] = currencyRate;
1854         _updateCachedSynthDebtsWithRates(synthKeyArray, synthRateArray, false, false);
1855     }
1856 
1857     function updateCachedSynthDebtsWithRates(bytes32[] calldata currencyKeys, uint[] calldata currencyRates)
1858         external
1859         onlyIssuerOrExchanger
1860     {
1861         _updateCachedSynthDebtsWithRates(currencyKeys, currencyRates, false, false);
1862     }
1863 
1864     function updateDebtCacheValidity(bool currentlyInvalid) external onlyIssuer {
1865         _updateDebtCacheValidity(currentlyInvalid);
1866     }
1867 
1868     /* ========== INTERNAL FUNCTIONS ========== */
1869 
1870     function _updateDebtCacheValidity(bool currentlyInvalid) internal {
1871         if (_cacheInvalid != currentlyInvalid) {
1872             _cacheInvalid = currentlyInvalid;
1873             emit DebtCacheValidityChanged(currentlyInvalid);
1874         }
1875     }
1876 
1877     function _updateCachedSynthDebtsWithRates(
1878         bytes32[] memory currencyKeys,
1879         uint[] memory currentRates,
1880         bool anyRateIsInvalid,
1881         bool recomputeExcludedDebt
1882     ) internal {
1883         uint numKeys = currencyKeys.length;
1884         require(numKeys == currentRates.length, "Input array lengths differ");
1885 
1886         // Update the cached values for each synth, saving the sums as we go.
1887         uint cachedSum;
1888         uint currentSum;
1889         uint excludedDebtSum = _cachedSynthDebt[EXCLUDED_DEBT_KEY];
1890         uint[] memory currentValues = _issuedSynthValues(currencyKeys, currentRates);
1891 
1892         for (uint i = 0; i < numKeys; i++) {
1893             bytes32 key = currencyKeys[i];
1894             uint currentSynthDebt = currentValues[i];
1895             cachedSum = cachedSum.add(_cachedSynthDebt[key]);
1896             currentSum = currentSum.add(currentSynthDebt);
1897             _cachedSynthDebt[key] = currentSynthDebt;
1898         }
1899 
1900         // Always update the cached value of the excluded debt -- it's computed anyway.
1901         if (recomputeExcludedDebt) {
1902             (uint excludedDebt, bool anyNonSnxDebtRateIsInvalid) = _totalNonSnxBackedDebt();
1903             anyRateIsInvalid = anyRateIsInvalid || anyNonSnxDebtRateIsInvalid;
1904             excludedDebtSum = excludedDebt;
1905         }
1906 
1907         cachedSum = cachedSum.floorsub(_cachedSynthDebt[EXCLUDED_DEBT_KEY]);
1908         currentSum = currentSum.floorsub(excludedDebtSum);
1909         _cachedSynthDebt[EXCLUDED_DEBT_KEY] = excludedDebtSum;
1910 
1911         // Compute the difference and apply it to the snapshot
1912         if (cachedSum != currentSum) {
1913             uint debt = _cachedDebt;
1914             // This requirement should never fail, as the total debt snapshot is the sum of the individual synth
1915             // debt snapshots.
1916             require(cachedSum <= debt, "Cached synth sum exceeds total debt");
1917             debt = debt.sub(cachedSum).add(currentSum);
1918             _cachedDebt = debt;
1919             emit DebtCacheUpdated(debt);
1920         }
1921 
1922         // A partial update can invalidate the debt cache, but a full snapshot must be performed in order
1923         // to re-validate it.
1924         if (anyRateIsInvalid) {
1925             _updateDebtCacheValidity(anyRateIsInvalid);
1926         }
1927     }
1928 
1929     /* ========== EVENTS ========== */
1930 
1931     event DebtCacheUpdated(uint cachedDebt);
1932     event DebtCacheSnapshotTaken(uint timestamp);
1933     event DebtCacheValidityChanged(bool indexed isInvalid);
1934 }
1935 
1936     