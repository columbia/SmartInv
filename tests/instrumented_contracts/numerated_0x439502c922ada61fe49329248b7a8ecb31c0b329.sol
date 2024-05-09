1 /*
2    ____            __   __        __   _
3   / __/__ __ ___  / /_ / /  ___  / /_ (_)__ __
4  _\ \ / // // _ \/ __// _ \/ -_)/ __// / \ \ /
5 /___/ \_, //_//_/\__//_//_/\__/ \__//_/ /_\_\
6      /___/
7 
8 * Synthetix: Exchanger.sol
9 *
10 * Latest source (may be newer): https://github.com/Synthetixio/synthetix/blob/master/contracts/Exchanger.sol
11 * Docs: https://docs.synthetix.io/contracts/Exchanger
12 *
13 * Contract Dependencies: 
14 *	- IAddressResolver
15 *	- IExchanger
16 *	- MixinResolver
17 *	- Owned
18 * Libraries: 
19 *	- SafeDecimalMath
20 *	- SafeMath
21 *
22 * MIT License
23 * ===========
24 *
25 * Copyright (c) 2020 Synthetix
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
45 /* ===============================================
46 * Flattened with Solidifier by Coinage
47 * 
48 * https://solidifier.coina.ge
49 * ===============================================
50 */
51 
52 
53 pragma solidity ^0.5.16;
54 
55 
56 // https://docs.synthetix.io/contracts/Owned
57 contract Owned {
58     address public owner;
59     address public nominatedOwner;
60 
61     constructor(address _owner) public {
62         require(_owner != address(0), "Owner address cannot be 0");
63         owner = _owner;
64         emit OwnerChanged(address(0), _owner);
65     }
66 
67     function nominateNewOwner(address _owner) external onlyOwner {
68         nominatedOwner = _owner;
69         emit OwnerNominated(_owner);
70     }
71 
72     function acceptOwnership() external {
73         require(msg.sender == nominatedOwner, "You must be nominated before you can accept ownership");
74         emit OwnerChanged(owner, nominatedOwner);
75         owner = nominatedOwner;
76         nominatedOwner = address(0);
77     }
78 
79     modifier onlyOwner {
80         require(msg.sender == owner, "Only the contract owner may perform this action");
81         _;
82     }
83 
84     event OwnerNominated(address newOwner);
85     event OwnerChanged(address oldOwner, address newOwner);
86 }
87 
88 
89 interface IAddressResolver {
90     function getAddress(bytes32 name) external view returns (address);
91 
92     function getSynth(bytes32 key) external view returns (address);
93 
94     function requireAndGetAddress(bytes32 name, string calldata reason) external view returns (address);
95 }
96 
97 
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
120 interface IIssuer {
121     // Views
122     function anySynthOrSNXRateIsStale() external view returns (bool anyRateStale);
123 
124     function availableCurrencyKeys() external view returns (bytes32[] memory);
125 
126     function availableSynthCount() external view returns (uint);
127 
128     function availableSynths(uint index) external view returns (ISynth);
129 
130     function canBurnSynths(address account) external view returns (bool);
131 
132     function collateral(address account) external view returns (uint);
133 
134     function collateralisationRatio(address issuer) external view returns (uint);
135 
136     function collateralisationRatioAndAnyRatesStale(address _issuer)
137         external
138         view
139         returns (uint cratio, bool anyRateIsStale);
140 
141     function debtBalanceOf(address issuer, bytes32 currencyKey) external view returns (uint debtBalance);
142 
143     function lastIssueEvent(address account) external view returns (uint);
144 
145     function maxIssuableSynths(address issuer) external view returns (uint maxIssuable);
146 
147     function remainingIssuableSynths(address issuer)
148         external
149         view
150         returns (
151             uint maxIssuable,
152             uint alreadyIssued,
153             uint totalSystemDebt
154         );
155 
156     function synths(bytes32 currencyKey) external view returns (ISynth);
157 
158     function synthsByAddress(address synthAddress) external view returns (bytes32);
159 
160     function totalIssuedSynths(bytes32 currencyKey, bool excludeEtherCollateral) external view returns (uint);
161 
162     function transferableSynthetixAndAnyRateIsStale(address account, uint balance)
163         external
164         view
165         returns (uint transferable, bool anyRateIsStale);
166 
167     // Restricted: used internally to Synthetix
168     function issueSynths(address from, uint amount) external;
169 
170     function issueSynthsOnBehalf(
171         address issueFor,
172         address from,
173         uint amount
174     ) external;
175 
176     function issueMaxSynths(address from) external;
177 
178     function issueMaxSynthsOnBehalf(address issueFor, address from) external;
179 
180     function burnSynths(address from, uint amount) external;
181 
182     function burnSynthsOnBehalf(
183         address burnForAddress,
184         address from,
185         uint amount
186     ) external;
187 
188     function burnSynthsToTarget(address from) external;
189 
190     function burnSynthsToTargetOnBehalf(address burnForAddress, address from) external;
191 
192     function liquidateDelinquentAccount(address account, uint susdAmount, address liquidator) external returns (uint totalRedeemed, uint amountToLiquidate);
193 }
194 
195 
196 // Inheritance
197 
198 
199 // https://docs.synthetix.io/contracts/AddressResolver
200 contract AddressResolver is Owned, IAddressResolver {
201     mapping(bytes32 => address) public repository;
202 
203     constructor(address _owner) public Owned(_owner) {}
204 
205     /* ========== MUTATIVE FUNCTIONS ========== */
206 
207     function importAddresses(bytes32[] calldata names, address[] calldata destinations) external onlyOwner {
208         require(names.length == destinations.length, "Input lengths must match");
209 
210         for (uint i = 0; i < names.length; i++) {
211             repository[names[i]] = destinations[i];
212         }
213     }
214 
215     /* ========== VIEWS ========== */
216 
217     function getAddress(bytes32 name) external view returns (address) {
218         return repository[name];
219     }
220 
221     function requireAndGetAddress(bytes32 name, string calldata reason) external view returns (address) {
222         address _foundAddress = repository[name];
223         require(_foundAddress != address(0), reason);
224         return _foundAddress;
225     }
226 
227     function getSynth(bytes32 key) external view returns (address) {
228         IIssuer issuer = IIssuer(repository["Issuer"]);
229         require(address(issuer) != address(0), "Cannot find Issuer address");
230         return address(issuer.synths(key));
231     }
232 }
233 
234 
235 // Inheritance
236 
237 
238 // Internal references
239 
240 
241 // https://docs.synthetix.io/contracts/MixinResolver
242 contract MixinResolver is Owned {
243     AddressResolver public resolver;
244 
245     mapping(bytes32 => address) private addressCache;
246 
247     bytes32[] public resolverAddressesRequired;
248 
249     uint public constant MAX_ADDRESSES_FROM_RESOLVER = 24;
250 
251     constructor(address _resolver, bytes32[MAX_ADDRESSES_FROM_RESOLVER] memory _addressesToCache) internal {
252         // This contract is abstract, and thus cannot be instantiated directly
253         require(owner != address(0), "Owner must be set");
254 
255         for (uint i = 0; i < _addressesToCache.length; i++) {
256             if (_addressesToCache[i] != bytes32(0)) {
257                 resolverAddressesRequired.push(_addressesToCache[i]);
258             } else {
259                 // End early once an empty item is found - assumes there are no empty slots in
260                 // _addressesToCache
261                 break;
262             }
263         }
264         resolver = AddressResolver(_resolver);
265         // Do not sync the cache as addresses may not be in the resolver yet
266     }
267 
268     /* ========== SETTERS ========== */
269     function setResolverAndSyncCache(AddressResolver _resolver) external onlyOwner {
270         resolver = _resolver;
271 
272         for (uint i = 0; i < resolverAddressesRequired.length; i++) {
273             bytes32 name = resolverAddressesRequired[i];
274             // Note: can only be invoked once the resolver has all the targets needed added
275             addressCache[name] = resolver.requireAndGetAddress(name, "Resolver missing target");
276         }
277     }
278 
279     /* ========== VIEWS ========== */
280 
281     function requireAndGetAddress(bytes32 name, string memory reason) internal view returns (address) {
282         address _foundAddress = addressCache[name];
283         require(_foundAddress != address(0), reason);
284         return _foundAddress;
285     }
286 
287     // Note: this could be made external in a utility contract if addressCache was made public
288     // (used for deployment)
289     function isResolverCached(AddressResolver _resolver) external view returns (bool) {
290         if (resolver != _resolver) {
291             return false;
292         }
293 
294         // otherwise, check everything
295         for (uint i = 0; i < resolverAddressesRequired.length; i++) {
296             bytes32 name = resolverAddressesRequired[i];
297             // false if our cache is invalid or if the resolver doesn't have the required address
298             if (resolver.getAddress(name) != addressCache[name] || addressCache[name] == address(0)) {
299                 return false;
300             }
301         }
302 
303         return true;
304     }
305 
306     // Note: can be made external into a utility contract (used for deployment)
307     function getResolverAddressesRequired()
308         external
309         view
310         returns (bytes32[MAX_ADDRESSES_FROM_RESOLVER] memory addressesRequired)
311     {
312         for (uint i = 0; i < resolverAddressesRequired.length; i++) {
313             addressesRequired[i] = resolverAddressesRequired[i];
314         }
315     }
316 
317     /* ========== INTERNAL FUNCTIONS ========== */
318     function appendToAddressCache(bytes32 name) internal {
319         resolverAddressesRequired.push(name);
320         require(resolverAddressesRequired.length < MAX_ADDRESSES_FROM_RESOLVER, "Max resolver cache size met");
321         // Because this is designed to be called internally in constructors, we don't
322         // check the address exists already in the resolver
323         addressCache[name] = resolver.getAddress(name);
324     }
325 }
326 
327 
328 interface IExchanger {
329     // Views
330     function calculateAmountAfterSettlement(
331         address from,
332         bytes32 currencyKey,
333         uint amount,
334         uint refunded
335     ) external view returns (uint amountAfterSettlement);
336 
337     function isSynthRateInvalid(bytes32 currencyKey) external view returns (bool);
338 
339     function maxSecsLeftInWaitingPeriod(address account, bytes32 currencyKey) external view returns (uint);
340 
341     function settlementOwing(address account, bytes32 currencyKey)
342         external
343         view
344         returns (
345             uint reclaimAmount,
346             uint rebateAmount,
347             uint numEntries
348         );
349 
350     function hasWaitingPeriodOrSettlementOwing(address account, bytes32 currencyKey) external view returns (bool);
351 
352     function feeRateForExchange(bytes32 sourceCurrencyKey, bytes32 destinationCurrencyKey)
353         external
354         view
355         returns (uint exchangeFeeRate);
356 
357     function getAmountsForExchange(
358         uint sourceAmount,
359         bytes32 sourceCurrencyKey,
360         bytes32 destinationCurrencyKey
361     )
362         external
363         view
364         returns (
365             uint amountReceived,
366             uint fee,
367             uint exchangeFeeRate
368         );
369 
370     // Mutative functions
371     function exchange(
372         address from,
373         bytes32 sourceCurrencyKey,
374         uint sourceAmount,
375         bytes32 destinationCurrencyKey,
376         address destinationAddress
377     ) external returns (uint amountReceived);
378 
379     function exchangeOnBehalf(
380         address exchangeForAddress,
381         address from,
382         bytes32 sourceCurrencyKey,
383         uint sourceAmount,
384         bytes32 destinationCurrencyKey
385     ) external returns (uint amountReceived);
386 
387     function settle(address from, bytes32 currencyKey)
388         external
389         returns (
390             uint reclaimed,
391             uint refunded,
392             uint numEntries
393         );
394 
395     function suspendSynthWithInvalidRate(bytes32 currencyKey) external;
396 }
397 
398 
399 /**
400  * @dev Wrappers over Solidity's arithmetic operations with added overflow
401  * checks.
402  *
403  * Arithmetic operations in Solidity wrap on overflow. This can easily result
404  * in bugs, because programmers usually assume that an overflow raises an
405  * error, which is the standard behavior in high level programming languages.
406  * `SafeMath` restores this intuition by reverting the transaction when an
407  * operation overflows.
408  *
409  * Using this library instead of the unchecked operations eliminates an entire
410  * class of bugs, so it's recommended to use it always.
411  */
412 library SafeMath {
413     /**
414      * @dev Returns the addition of two unsigned integers, reverting on
415      * overflow.
416      *
417      * Counterpart to Solidity's `+` operator.
418      *
419      * Requirements:
420      * - Addition cannot overflow.
421      */
422     function add(uint256 a, uint256 b) internal pure returns (uint256) {
423         uint256 c = a + b;
424         require(c >= a, "SafeMath: addition overflow");
425 
426         return c;
427     }
428 
429     /**
430      * @dev Returns the subtraction of two unsigned integers, reverting on
431      * overflow (when the result is negative).
432      *
433      * Counterpart to Solidity's `-` operator.
434      *
435      * Requirements:
436      * - Subtraction cannot overflow.
437      */
438     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
439         require(b <= a, "SafeMath: subtraction overflow");
440         uint256 c = a - b;
441 
442         return c;
443     }
444 
445     /**
446      * @dev Returns the multiplication of two unsigned integers, reverting on
447      * overflow.
448      *
449      * Counterpart to Solidity's `*` operator.
450      *
451      * Requirements:
452      * - Multiplication cannot overflow.
453      */
454     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
455         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
456         // benefit is lost if 'b' is also tested.
457         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
458         if (a == 0) {
459             return 0;
460         }
461 
462         uint256 c = a * b;
463         require(c / a == b, "SafeMath: multiplication overflow");
464 
465         return c;
466     }
467 
468     /**
469      * @dev Returns the integer division of two unsigned integers. Reverts on
470      * division by zero. The result is rounded towards zero.
471      *
472      * Counterpart to Solidity's `/` operator. Note: this function uses a
473      * `revert` opcode (which leaves remaining gas untouched) while Solidity
474      * uses an invalid opcode to revert (consuming all remaining gas).
475      *
476      * Requirements:
477      * - The divisor cannot be zero.
478      */
479     function div(uint256 a, uint256 b) internal pure returns (uint256) {
480         // Solidity only automatically asserts when dividing by 0
481         require(b > 0, "SafeMath: division by zero");
482         uint256 c = a / b;
483         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
484 
485         return c;
486     }
487 
488     /**
489      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
490      * Reverts when dividing by zero.
491      *
492      * Counterpart to Solidity's `%` operator. This function uses a `revert`
493      * opcode (which leaves remaining gas untouched) while Solidity uses an
494      * invalid opcode to revert (consuming all remaining gas).
495      *
496      * Requirements:
497      * - The divisor cannot be zero.
498      */
499     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
500         require(b != 0, "SafeMath: modulo by zero");
501         return a % b;
502     }
503 }
504 
505 
506 // Libraries
507 
508 
509 // https://docs.synthetix.io/contracts/SafeDecimalMath
510 library SafeDecimalMath {
511     using SafeMath for uint;
512 
513     /* Number of decimal places in the representations. */
514     uint8 public constant decimals = 18;
515     uint8 public constant highPrecisionDecimals = 27;
516 
517     /* The number representing 1.0. */
518     uint public constant UNIT = 10**uint(decimals);
519 
520     /* The number representing 1.0 for higher fidelity numbers. */
521     uint public constant PRECISE_UNIT = 10**uint(highPrecisionDecimals);
522     uint private constant UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR = 10**uint(highPrecisionDecimals - decimals);
523 
524     /**
525      * @return Provides an interface to UNIT.
526      */
527     function unit() external pure returns (uint) {
528         return UNIT;
529     }
530 
531     /**
532      * @return Provides an interface to PRECISE_UNIT.
533      */
534     function preciseUnit() external pure returns (uint) {
535         return PRECISE_UNIT;
536     }
537 
538     /**
539      * @return The result of multiplying x and y, interpreting the operands as fixed-point
540      * decimals.
541      *
542      * @dev A unit factor is divided out after the product of x and y is evaluated,
543      * so that product must be less than 2**256. As this is an integer division,
544      * the internal division always rounds down. This helps save on gas. Rounding
545      * is more expensive on gas.
546      */
547     function multiplyDecimal(uint x, uint y) internal pure returns (uint) {
548         /* Divide by UNIT to remove the extra factor introduced by the product. */
549         return x.mul(y) / UNIT;
550     }
551 
552     /**
553      * @return The result of safely multiplying x and y, interpreting the operands
554      * as fixed-point decimals of the specified precision unit.
555      *
556      * @dev The operands should be in the form of a the specified unit factor which will be
557      * divided out after the product of x and y is evaluated, so that product must be
558      * less than 2**256.
559      *
560      * Unlike multiplyDecimal, this function rounds the result to the nearest increment.
561      * Rounding is useful when you need to retain fidelity for small decimal numbers
562      * (eg. small fractions or percentages).
563      */
564     function _multiplyDecimalRound(
565         uint x,
566         uint y,
567         uint precisionUnit
568     ) private pure returns (uint) {
569         /* Divide by UNIT to remove the extra factor introduced by the product. */
570         uint quotientTimesTen = x.mul(y) / (precisionUnit / 10);
571 
572         if (quotientTimesTen % 10 >= 5) {
573             quotientTimesTen += 10;
574         }
575 
576         return quotientTimesTen / 10;
577     }
578 
579     /**
580      * @return The result of safely multiplying x and y, interpreting the operands
581      * as fixed-point decimals of a precise unit.
582      *
583      * @dev The operands should be in the precise unit factor which will be
584      * divided out after the product of x and y is evaluated, so that product must be
585      * less than 2**256.
586      *
587      * Unlike multiplyDecimal, this function rounds the result to the nearest increment.
588      * Rounding is useful when you need to retain fidelity for small decimal numbers
589      * (eg. small fractions or percentages).
590      */
591     function multiplyDecimalRoundPrecise(uint x, uint y) internal pure returns (uint) {
592         return _multiplyDecimalRound(x, y, PRECISE_UNIT);
593     }
594 
595     /**
596      * @return The result of safely multiplying x and y, interpreting the operands
597      * as fixed-point decimals of a standard unit.
598      *
599      * @dev The operands should be in the standard unit factor which will be
600      * divided out after the product of x and y is evaluated, so that product must be
601      * less than 2**256.
602      *
603      * Unlike multiplyDecimal, this function rounds the result to the nearest increment.
604      * Rounding is useful when you need to retain fidelity for small decimal numbers
605      * (eg. small fractions or percentages).
606      */
607     function multiplyDecimalRound(uint x, uint y) internal pure returns (uint) {
608         return _multiplyDecimalRound(x, y, UNIT);
609     }
610 
611     /**
612      * @return The result of safely dividing x and y. The return value is a high
613      * precision decimal.
614      *
615      * @dev y is divided after the product of x and the standard precision unit
616      * is evaluated, so the product of x and UNIT must be less than 2**256. As
617      * this is an integer division, the result is always rounded down.
618      * This helps save on gas. Rounding is more expensive on gas.
619      */
620     function divideDecimal(uint x, uint y) internal pure returns (uint) {
621         /* Reintroduce the UNIT factor that will be divided out by y. */
622         return x.mul(UNIT).div(y);
623     }
624 
625     /**
626      * @return The result of safely dividing x and y. The return value is as a rounded
627      * decimal in the precision unit specified in the parameter.
628      *
629      * @dev y is divided after the product of x and the specified precision unit
630      * is evaluated, so the product of x and the specified precision unit must
631      * be less than 2**256. The result is rounded to the nearest increment.
632      */
633     function _divideDecimalRound(
634         uint x,
635         uint y,
636         uint precisionUnit
637     ) private pure returns (uint) {
638         uint resultTimesTen = x.mul(precisionUnit * 10).div(y);
639 
640         if (resultTimesTen % 10 >= 5) {
641             resultTimesTen += 10;
642         }
643 
644         return resultTimesTen / 10;
645     }
646 
647     /**
648      * @return The result of safely dividing x and y. The return value is as a rounded
649      * standard precision decimal.
650      *
651      * @dev y is divided after the product of x and the standard precision unit
652      * is evaluated, so the product of x and the standard precision unit must
653      * be less than 2**256. The result is rounded to the nearest increment.
654      */
655     function divideDecimalRound(uint x, uint y) internal pure returns (uint) {
656         return _divideDecimalRound(x, y, UNIT);
657     }
658 
659     /**
660      * @return The result of safely dividing x and y. The return value is as a rounded
661      * high precision decimal.
662      *
663      * @dev y is divided after the product of x and the high precision unit
664      * is evaluated, so the product of x and the high precision unit must
665      * be less than 2**256. The result is rounded to the nearest increment.
666      */
667     function divideDecimalRoundPrecise(uint x, uint y) internal pure returns (uint) {
668         return _divideDecimalRound(x, y, PRECISE_UNIT);
669     }
670 
671     /**
672      * @dev Convert a standard decimal representation to a high precision one.
673      */
674     function decimalToPreciseDecimal(uint i) internal pure returns (uint) {
675         return i.mul(UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR);
676     }
677 
678     /**
679      * @dev Convert a high precision decimal to a standard decimal representation.
680      */
681     function preciseDecimalToDecimal(uint i) internal pure returns (uint) {
682         uint quotientTimesTen = i / (UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR / 10);
683 
684         if (quotientTimesTen % 10 >= 5) {
685             quotientTimesTen += 10;
686         }
687 
688         return quotientTimesTen / 10;
689     }
690 }
691 
692 
693 interface IERC20 {
694     // ERC20 Optional Views
695     function name() external view returns (string memory);
696 
697     function symbol() external view returns (string memory);
698 
699     function decimals() external view returns (uint8);
700 
701     // Views
702     function totalSupply() external view returns (uint);
703 
704     function balanceOf(address owner) external view returns (uint);
705 
706     function allowance(address owner, address spender) external view returns (uint);
707 
708     // Mutative functions
709     function transfer(address to, uint value) external returns (bool);
710 
711     function approve(address spender, uint value) external returns (bool);
712 
713     function transferFrom(
714         address from,
715         address to,
716         uint value
717     ) external returns (bool);
718 
719     // Events
720     event Transfer(address indexed from, address indexed to, uint value);
721 
722     event Approval(address indexed owner, address indexed spender, uint value);
723 }
724 
725 
726 interface ISystemStatus {
727     struct Status {
728         bool canSuspend;
729         bool canResume;
730     }
731 
732     struct Suspension {
733         bool suspended;
734         // reason is an integer code,
735         // 0 => no reason, 1 => upgrading, 2+ => defined by system usage
736         uint248 reason;
737     }
738 
739     // Views
740     function accessControl(bytes32 section, address account) external view returns (bool canSuspend, bool canResume);
741 
742     function requireSystemActive() external view;
743 
744     function requireIssuanceActive() external view;
745 
746     function requireExchangeActive() external view;
747 
748     function requireSynthActive(bytes32 currencyKey) external view;
749 
750     function requireSynthsActive(bytes32 sourceCurrencyKey, bytes32 destinationCurrencyKey) external view;
751 
752     function synthSuspension(bytes32 currencyKey) external view returns (bool suspended, uint248 reason);
753 
754     // Restricted functions
755     function suspendSynth(bytes32 currencyKey, uint256 reason) external;
756 
757     function updateAccessControl(
758         bytes32 section,
759         address account,
760         bool canSuspend,
761         bool canResume
762     ) external;
763 }
764 
765 
766 interface IExchangeState {
767     // Views
768     struct ExchangeEntry {
769         bytes32 src;
770         uint amount;
771         bytes32 dest;
772         uint amountReceived;
773         uint exchangeFeeRate;
774         uint timestamp;
775         uint roundIdForSrc;
776         uint roundIdForDest;
777     }
778 
779     function getLengthOfEntries(address account, bytes32 currencyKey) external view returns (uint);
780 
781     function getEntryAt(
782         address account,
783         bytes32 currencyKey,
784         uint index
785     )
786         external
787         view
788         returns (
789             bytes32 src,
790             uint amount,
791             bytes32 dest,
792             uint amountReceived,
793             uint exchangeFeeRate,
794             uint timestamp,
795             uint roundIdForSrc,
796             uint roundIdForDest
797         );
798 
799     function getMaxTimestamp(address account, bytes32 currencyKey) external view returns (uint);
800 
801     // Mutative functions
802     function appendExchangeEntry(
803         address account,
804         bytes32 src,
805         uint amount,
806         bytes32 dest,
807         uint amountReceived,
808         uint exchangeFeeRate,
809         uint timestamp,
810         uint roundIdForSrc,
811         uint roundIdForDest
812     ) external;
813 
814     function removeEntries(address account, bytes32 currencyKey) external;
815 }
816 
817 
818 // https://docs.synthetix.io/contracts/source/interfaces/IExchangeRates
819 interface IExchangeRates {
820     // Views
821     function aggregators(bytes32 currencyKey) external view returns (address);
822 
823     function anyRateIsStale(bytes32[] calldata currencyKeys) external view returns (bool);
824 
825     function currentRoundForRate(bytes32 currencyKey) external view returns (uint);
826 
827     function effectiveValue(
828         bytes32 sourceCurrencyKey,
829         uint sourceAmount,
830         bytes32 destinationCurrencyKey
831     ) external view returns (uint value);
832 
833     function effectiveValueAndRates(
834         bytes32 sourceCurrencyKey,
835         uint sourceAmount,
836         bytes32 destinationCurrencyKey
837     )
838         external
839         view
840         returns (
841             uint value,
842             uint sourceRate,
843             uint destinationRate
844         );
845 
846     function effectiveValueAtRound(
847         bytes32 sourceCurrencyKey,
848         uint sourceAmount,
849         bytes32 destinationCurrencyKey,
850         uint roundIdForSrc,
851         uint roundIdForDest
852     ) external view returns (uint value);
853 
854     function getCurrentRoundId(bytes32 currencyKey) external view returns (uint);
855 
856     function getLastRoundIdBeforeElapsedSecs(
857         bytes32 currencyKey,
858         uint startingRoundId,
859         uint startingTimestamp,
860         uint timediff
861     ) external view returns (uint);
862 
863     function inversePricing(bytes32 currencyKey)
864         external
865         view
866         returns (
867             uint entryPoint,
868             uint upperLimit,
869             uint lowerLimit,
870             bool frozen
871         );
872 
873     function lastRateUpdateTimes(bytes32 currencyKey) external view returns (uint256);
874 
875     function oracle() external view returns (address);
876 
877     function rateAndTimestampAtRound(bytes32 currencyKey, uint roundId) external view returns (uint rate, uint time);
878 
879     function rateAndUpdatedTime(bytes32 currencyKey) external view returns (uint rate, uint time);
880 
881     function rateForCurrency(bytes32 currencyKey) external view returns (uint);
882 
883     function rateIsFrozen(bytes32 currencyKey) external view returns (bool);
884 
885     function rateIsStale(bytes32 currencyKey) external view returns (bool);
886 
887     function rateStalePeriod() external view returns (uint);
888 
889     function ratesAndUpdatedTimeForCurrencyLastNRounds(bytes32 currencyKey, uint numRounds)
890         external
891         view
892         returns (uint[] memory rates, uint[] memory times);
893 
894     function ratesAndStaleForCurrencies(bytes32[] calldata currencyKeys) external view returns (uint[] memory, bool);
895 
896     function ratesForCurrencies(bytes32[] calldata currencyKeys) external view returns (uint[] memory);
897 }
898 
899 
900 interface ISynthetix {
901     // Views
902     function anySynthOrSNXRateIsStale() external view returns (bool anyRateStale);
903 
904     function availableCurrencyKeys() external view returns (bytes32[] memory);
905 
906     function availableSynthCount() external view returns (uint);
907 
908     function availableSynths(uint index) external view returns (ISynth);
909 
910     function collateral(address account) external view returns (uint);
911 
912     function collateralisationRatio(address issuer) external view returns (uint);
913 
914     function debtBalanceOf(address issuer, bytes32 currencyKey) external view returns (uint);
915 
916     function isWaitingPeriod(bytes32 currencyKey) external view returns (bool);
917 
918     function maxIssuableSynths(address issuer) external view returns (uint maxIssuable);
919 
920     function remainingIssuableSynths(address issuer)
921         external
922         view
923         returns (
924             uint maxIssuable,
925             uint alreadyIssued,
926             uint totalSystemDebt
927         );
928 
929     function synths(bytes32 currencyKey) external view returns (ISynth);
930 
931     function synthsByAddress(address synthAddress) external view returns (bytes32);
932 
933     function totalIssuedSynths(bytes32 currencyKey) external view returns (uint);
934 
935     function totalIssuedSynthsExcludeEtherCollateral(bytes32 currencyKey) external view returns (uint);
936 
937     function transferableSynthetix(address account) external view returns (uint transferable);
938 
939     // Mutative Functions
940     function burnSynths(uint amount) external;
941 
942     function burnSynthsOnBehalf(address burnForAddress, uint amount) external;
943 
944     function burnSynthsToTarget() external;
945 
946     function burnSynthsToTargetOnBehalf(address burnForAddress) external;
947 
948     function exchange(
949         bytes32 sourceCurrencyKey,
950         uint sourceAmount,
951         bytes32 destinationCurrencyKey
952     ) external returns (uint amountReceived);
953 
954     function exchangeOnBehalf(
955         address exchangeForAddress,
956         bytes32 sourceCurrencyKey,
957         uint sourceAmount,
958         bytes32 destinationCurrencyKey
959     ) external returns (uint amountReceived);
960 
961     function issueMaxSynths() external;
962 
963     function issueMaxSynthsOnBehalf(address issueForAddress) external;
964 
965     function issueSynths(uint amount) external;
966 
967     function issueSynthsOnBehalf(address issueForAddress, uint amount) external;
968 
969     function mint() external returns (bool);
970 
971     function settle(bytes32 currencyKey)
972         external
973         returns (
974             uint reclaimed,
975             uint refunded,
976             uint numEntries
977         );
978 
979     function liquidateDelinquentAccount(address account, uint susdAmount) external returns (bool);
980 }
981 
982 
983 interface IFeePool {
984     // Views
985     function getExchangeFeeRateForSynth(bytes32 synthKey) external view returns (uint);
986 
987     // solhint-disable-next-line func-name-mixedcase
988     function FEE_ADDRESS() external view returns (address);
989 
990     function feesAvailable(address account) external view returns (uint, uint);
991 
992     function isFeesClaimable(address account) external view returns (bool);
993 
994     function totalFeesAvailable() external view returns (uint);
995 
996     function totalRewardsAvailable() external view returns (uint);
997 
998     // Mutative Functions
999     function claimFees() external returns (bool);
1000 
1001     function claimOnBehalf(address claimingForAddress) external returns (bool);
1002 
1003     function closeCurrentFeePeriod() external;
1004 
1005     // Restricted: used internally to Synthetix
1006     function appendAccountIssuanceRecord(
1007         address account,
1008         uint lockedAmount,
1009         uint debtEntryIndex
1010     ) external;
1011 
1012     function recordFeePaid(uint sUSDAmount) external;
1013 
1014     function setRewardsToDistribute(uint amount) external;
1015 }
1016 
1017 
1018 interface IDelegateApprovals {
1019     // Views
1020     function canBurnFor(address authoriser, address delegate) external view returns (bool);
1021 
1022     function canIssueFor(address authoriser, address delegate) external view returns (bool);
1023 
1024     function canClaimFor(address authoriser, address delegate) external view returns (bool);
1025 
1026     function canExchangeFor(address authoriser, address delegate) external view returns (bool);
1027 
1028     // Mutative
1029     function approveAllDelegatePowers(address delegate) external;
1030 
1031     function removeAllDelegatePowers(address delegate) external;
1032 
1033     function approveBurnOnBehalf(address delegate) external;
1034 
1035     function removeBurnOnBehalf(address delegate) external;
1036 
1037     function approveIssueOnBehalf(address delegate) external;
1038 
1039     function removeIssueOnBehalf(address delegate) external;
1040 
1041     function approveClaimOnBehalf(address delegate) external;
1042 
1043     function removeClaimOnBehalf(address delegate) external;
1044 
1045     function approveExchangeOnBehalf(address delegate) external;
1046 
1047     function removeExchangeOnBehalf(address delegate) external;
1048 }
1049 
1050 
1051 // Inheritance
1052 
1053 
1054 // Libraries
1055 
1056 
1057 // Internal references
1058 
1059 
1060 // Used to have strongly-typed access to internal mutative functions in Synthetix
1061 interface ISynthetixInternal {
1062     function emitSynthExchange(
1063         address account,
1064         bytes32 fromCurrencyKey,
1065         uint fromAmount,
1066         bytes32 toCurrencyKey,
1067         uint toAmount,
1068         address toAddress
1069     ) external;
1070 
1071     function emitExchangeReclaim(
1072         address account,
1073         bytes32 currencyKey,
1074         uint amount
1075     ) external;
1076 
1077     function emitExchangeRebate(
1078         address account,
1079         bytes32 currencyKey,
1080         uint amount
1081     ) external;
1082 }
1083 
1084 
1085 // https://docs.synthetix.io/contracts/Exchanger
1086 contract Exchanger is Owned, MixinResolver, IExchanger {
1087     using SafeMath for uint;
1088     using SafeDecimalMath for uint;
1089 
1090     struct ExchangeEntrySettlement {
1091         bytes32 src;
1092         uint amount;
1093         bytes32 dest;
1094         uint reclaim;
1095         uint rebate;
1096         uint srcRoundIdAtPeriodEnd;
1097         uint destRoundIdAtPeriodEnd;
1098         uint timestamp;
1099     }
1100 
1101     bytes32 private constant sUSD = "sUSD";
1102 
1103     // SIP-65: Decentralized circuit breaker
1104     uint public constant CIRCUIT_BREAKER_SUSPENSION_REASON = 65;
1105 
1106     uint public waitingPeriodSecs;
1107 
1108     // The factor amount expressed in decimal format
1109     // E.g. 3e18 = factor 3, meaning movement up to 3x and above or down to 1/3x and below
1110     uint public priceDeviationThresholdFactor;
1111 
1112     mapping(bytes32 => uint) public lastExchangeRate;
1113 
1114     /* ========== ADDRESS RESOLVER CONFIGURATION ========== */
1115 
1116     bytes32 private constant CONTRACT_SYSTEMSTATUS = "SystemStatus";
1117     bytes32 private constant CONTRACT_EXCHANGESTATE = "ExchangeState";
1118     bytes32 private constant CONTRACT_EXRATES = "ExchangeRates";
1119     bytes32 private constant CONTRACT_SYNTHETIX = "Synthetix";
1120     bytes32 private constant CONTRACT_FEEPOOL = "FeePool";
1121     bytes32 private constant CONTRACT_DELEGATEAPPROVALS = "DelegateApprovals";
1122     bytes32 private constant CONTRACT_ISSUER = "Issuer";
1123 
1124     bytes32[24] private addressesToCache = [
1125         CONTRACT_SYSTEMSTATUS,
1126         CONTRACT_EXCHANGESTATE,
1127         CONTRACT_EXRATES,
1128         CONTRACT_SYNTHETIX,
1129         CONTRACT_FEEPOOL,
1130         CONTRACT_DELEGATEAPPROVALS,
1131         CONTRACT_ISSUER
1132     ];
1133 
1134     constructor(address _owner, address _resolver) public Owned(_owner) MixinResolver(_resolver, addressesToCache) {
1135         waitingPeriodSecs = 3 minutes;
1136         priceDeviationThresholdFactor = SafeDecimalMath.unit().mul(3); // 3e18 (factor of 3) default
1137     }
1138 
1139     /* ========== VIEWS ========== */
1140 
1141     function systemStatus() internal view returns (ISystemStatus) {
1142         return ISystemStatus(requireAndGetAddress(CONTRACT_SYSTEMSTATUS, "Missing SystemStatus address"));
1143     }
1144 
1145     function exchangeState() internal view returns (IExchangeState) {
1146         return IExchangeState(requireAndGetAddress(CONTRACT_EXCHANGESTATE, "Missing ExchangeState address"));
1147     }
1148 
1149     function exchangeRates() internal view returns (IExchangeRates) {
1150         return IExchangeRates(requireAndGetAddress(CONTRACT_EXRATES, "Missing ExchangeRates address"));
1151     }
1152 
1153     function synthetix() internal view returns (ISynthetix) {
1154         return ISynthetix(requireAndGetAddress(CONTRACT_SYNTHETIX, "Missing Synthetix address"));
1155     }
1156 
1157     function feePool() internal view returns (IFeePool) {
1158         return IFeePool(requireAndGetAddress(CONTRACT_FEEPOOL, "Missing FeePool address"));
1159     }
1160 
1161     function delegateApprovals() internal view returns (IDelegateApprovals) {
1162         return IDelegateApprovals(requireAndGetAddress(CONTRACT_DELEGATEAPPROVALS, "Missing DelegateApprovals address"));
1163     }
1164 
1165     function issuer() internal view returns (IIssuer) {
1166         return IIssuer(requireAndGetAddress(CONTRACT_ISSUER, "Missing Issuer address"));
1167     }
1168 
1169     function maxSecsLeftInWaitingPeriod(address account, bytes32 currencyKey) public view returns (uint) {
1170         return secsLeftInWaitingPeriodForExchange(exchangeState().getMaxTimestamp(account, currencyKey));
1171     }
1172 
1173     function settlementOwing(address account, bytes32 currencyKey)
1174         public
1175         view
1176         returns (
1177             uint reclaimAmount,
1178             uint rebateAmount,
1179             uint numEntries
1180         )
1181     {
1182         (reclaimAmount, rebateAmount, numEntries, ) = _settlementOwing(account, currencyKey);
1183     }
1184 
1185     // Internal function to emit events for each individual rebate and reclaim entry
1186     function _settlementOwing(address account, bytes32 currencyKey)
1187         internal
1188         view
1189         returns (
1190             uint reclaimAmount,
1191             uint rebateAmount,
1192             uint numEntries,
1193             ExchangeEntrySettlement[] memory
1194         )
1195     {
1196         // Need to sum up all reclaim and rebate amounts for the user and the currency key
1197         numEntries = exchangeState().getLengthOfEntries(account, currencyKey);
1198 
1199         // For each unsettled exchange
1200         ExchangeEntrySettlement[] memory settlements = new ExchangeEntrySettlement[](numEntries);
1201         for (uint i = 0; i < numEntries; i++) {
1202             uint reclaim;
1203             uint rebate;
1204             // fetch the entry from storage
1205             IExchangeState.ExchangeEntry memory exchangeEntry = _getExchangeEntry(account, currencyKey, i);
1206 
1207             // determine the last round ids for src and dest pairs when period ended or latest if not over
1208             (uint srcRoundIdAtPeriodEnd, uint destRoundIdAtPeriodEnd) = getRoundIdsAtPeriodEnd(account, currencyKey, i);
1209 
1210             // given these round ids, determine what effective value they should have received
1211             uint destinationAmount = exchangeRates().effectiveValueAtRound(
1212                 exchangeEntry.src,
1213                 exchangeEntry.amount,
1214                 exchangeEntry.dest,
1215                 srcRoundIdAtPeriodEnd,
1216                 destRoundIdAtPeriodEnd
1217             );
1218 
1219             // and deduct the fee from this amount using the exchangeFeeRate from storage
1220             uint amountShouldHaveReceived = _getAmountReceivedForExchange(destinationAmount, exchangeEntry.exchangeFeeRate);
1221 
1222             // SIP-65 settlements where the amount at end of waiting period is beyond the threshold, then
1223             // settle with no reclaim or rebate
1224             if (!_isDeviationAboveThreshold(exchangeEntry.amountReceived, amountShouldHaveReceived)) {
1225                 if (exchangeEntry.amountReceived > amountShouldHaveReceived) {
1226                     // if they received more than they should have, add to the reclaim tally
1227                     reclaim = exchangeEntry.amountReceived.sub(amountShouldHaveReceived);
1228                     reclaimAmount = reclaimAmount.add(reclaim);
1229                 } else if (amountShouldHaveReceived > exchangeEntry.amountReceived) {
1230                     // if less, add to the rebate tally
1231                     rebate = amountShouldHaveReceived.sub(exchangeEntry.amountReceived);
1232                     rebateAmount = rebateAmount.add(rebate);
1233                 }
1234             }
1235 
1236             settlements[i] = ExchangeEntrySettlement({
1237                 src: exchangeEntry.src,
1238                 amount: exchangeEntry.amount,
1239                 dest: exchangeEntry.dest,
1240                 reclaim: reclaim,
1241                 rebate: rebate,
1242                 srcRoundIdAtPeriodEnd: srcRoundIdAtPeriodEnd,
1243                 destRoundIdAtPeriodEnd: destRoundIdAtPeriodEnd,
1244                 timestamp: exchangeEntry.timestamp
1245             });
1246         }
1247 
1248         return (reclaimAmount, rebateAmount, numEntries, settlements);
1249     }
1250 
1251     function _getExchangeEntry(
1252         address account,
1253         bytes32 currencyKey,
1254         uint index
1255     ) internal view returns (IExchangeState.ExchangeEntry memory) {
1256         (
1257             bytes32 src,
1258             uint amount,
1259             bytes32 dest,
1260             uint amountReceived,
1261             uint exchangeFeeRate,
1262             uint timestamp,
1263             uint roundIdForSrc,
1264             uint roundIdForDest
1265         ) = exchangeState().getEntryAt(account, currencyKey, index);
1266 
1267         return
1268             IExchangeState.ExchangeEntry({
1269                 src: src,
1270                 amount: amount,
1271                 dest: dest,
1272                 amountReceived: amountReceived,
1273                 exchangeFeeRate: exchangeFeeRate,
1274                 timestamp: timestamp,
1275                 roundIdForSrc: roundIdForSrc,
1276                 roundIdForDest: roundIdForDest
1277             });
1278     }
1279 
1280     function hasWaitingPeriodOrSettlementOwing(address account, bytes32 currencyKey) external view returns (bool) {
1281         if (maxSecsLeftInWaitingPeriod(account, currencyKey) != 0) {
1282             return true;
1283         }
1284 
1285         (uint reclaimAmount, , , ) = _settlementOwing(account, currencyKey);
1286 
1287         return reclaimAmount > 0;
1288     }
1289 
1290     /* ========== SETTERS ========== */
1291 
1292     function setWaitingPeriodSecs(uint _waitingPeriodSecs) external onlyOwner {
1293         waitingPeriodSecs = _waitingPeriodSecs;
1294         emit WaitingPeriodSecsUpdated(waitingPeriodSecs);
1295     }
1296 
1297     function setPriceDeviationThresholdFactor(uint _priceDeviationThresholdFactor) external onlyOwner {
1298         priceDeviationThresholdFactor = _priceDeviationThresholdFactor;
1299         emit PriceDeviationThresholdUpdated(priceDeviationThresholdFactor);
1300     }
1301 
1302     function calculateAmountAfterSettlement(
1303         address from,
1304         bytes32 currencyKey,
1305         uint amount,
1306         uint refunded
1307     ) public view returns (uint amountAfterSettlement) {
1308         amountAfterSettlement = amount;
1309 
1310         // balance of a synth will show an amount after settlement
1311         uint balanceOfSourceAfterSettlement = IERC20(address(issuer().synths(currencyKey))).balanceOf(from);
1312 
1313         // when there isn't enough supply (either due to reclamation settlement or because the number is too high)
1314         if (amountAfterSettlement > balanceOfSourceAfterSettlement) {
1315             // then the amount to exchange is reduced to their remaining supply
1316             amountAfterSettlement = balanceOfSourceAfterSettlement;
1317         }
1318 
1319         if (refunded > 0) {
1320             amountAfterSettlement = amountAfterSettlement.add(refunded);
1321         }
1322     }
1323 
1324     function isSynthRateInvalid(bytes32 currencyKey) external view returns (bool) {
1325         return _isSynthRateInvalid(currencyKey, exchangeRates().rateForCurrency(currencyKey));
1326     }
1327 
1328     /* ========== MUTATIVE FUNCTIONS ========== */
1329     function exchange(
1330         address from,
1331         bytes32 sourceCurrencyKey,
1332         uint sourceAmount,
1333         bytes32 destinationCurrencyKey,
1334         address destinationAddress
1335     ) external onlySynthetixorSynth returns (uint amountReceived) {
1336         amountReceived = _exchange(from, sourceCurrencyKey, sourceAmount, destinationCurrencyKey, destinationAddress);
1337     }
1338 
1339     function exchangeOnBehalf(
1340         address exchangeForAddress,
1341         address from,
1342         bytes32 sourceCurrencyKey,
1343         uint sourceAmount,
1344         bytes32 destinationCurrencyKey
1345     ) external onlySynthetixorSynth returns (uint amountReceived) {
1346         require(delegateApprovals().canExchangeFor(exchangeForAddress, from), "Not approved to act on behalf");
1347         amountReceived = _exchange(
1348             exchangeForAddress,
1349             sourceCurrencyKey,
1350             sourceAmount,
1351             destinationCurrencyKey,
1352             exchangeForAddress
1353         );
1354     }
1355 
1356     function _exchange(
1357         address from,
1358         bytes32 sourceCurrencyKey,
1359         uint sourceAmount,
1360         bytes32 destinationCurrencyKey,
1361         address destinationAddress
1362     ) internal returns (uint amountReceived) {
1363         _ensureCanExchange(sourceCurrencyKey, sourceAmount, destinationCurrencyKey);
1364 
1365         (, uint refunded, uint numEntriesSettled) = _internalSettle(from, sourceCurrencyKey);
1366 
1367         uint sourceAmountAfterSettlement = sourceAmount;
1368 
1369         // when settlement was required
1370         if (numEntriesSettled > 0) {
1371             // ensure the sourceAmount takes this into account
1372             sourceAmountAfterSettlement = calculateAmountAfterSettlement(from, sourceCurrencyKey, sourceAmount, refunded);
1373 
1374             // If, after settlement the user has no balance left (highly unlikely), then return to prevent
1375             // emitting events of 0 and don't revert so as to ensure the settlement queue is emptied
1376             if (sourceAmountAfterSettlement == 0) {
1377                 return 0;
1378             }
1379         }
1380 
1381         uint fee;
1382         uint exchangeFeeRate;
1383         uint sourceRate;
1384         uint destinationRate;
1385 
1386         (amountReceived, fee, exchangeFeeRate, sourceRate, destinationRate) = _getAmountsForExchangeMinusFees(
1387             sourceAmountAfterSettlement,
1388             sourceCurrencyKey,
1389             destinationCurrencyKey
1390         );
1391 
1392         // SIP-65: Decentralized Circuit Breaker
1393         if (_isSynthRateInvalid(sourceCurrencyKey, sourceRate)) {
1394             systemStatus().suspendSynth(sourceCurrencyKey, CIRCUIT_BREAKER_SUSPENSION_REASON);
1395             return 0;
1396         } else {
1397             lastExchangeRate[sourceCurrencyKey] = sourceRate;
1398         }
1399 
1400         if (_isSynthRateInvalid(destinationCurrencyKey, destinationRate)) {
1401             systemStatus().suspendSynth(destinationCurrencyKey, CIRCUIT_BREAKER_SUSPENSION_REASON);
1402             return 0;
1403         } else {
1404             lastExchangeRate[destinationCurrencyKey] = destinationRate;
1405         }
1406 
1407         // Note: We don't need to check their balance as the burn() below will do a safe subtraction which requires
1408         // the subtraction to not overflow, which would happen if their balance is not sufficient.
1409 
1410         // Burn the source amount
1411         issuer().synths(sourceCurrencyKey).burn(from, sourceAmountAfterSettlement);
1412 
1413         // Issue their new synths
1414         issuer().synths(destinationCurrencyKey).issue(destinationAddress, amountReceived);
1415 
1416         // Remit the fee if required
1417         if (fee > 0) {
1418             remitFee(fee, destinationCurrencyKey);
1419         }
1420 
1421         // Nothing changes as far as issuance data goes because the total value in the system hasn't changed.
1422 
1423         // Let the DApps know there was a Synth exchange
1424         ISynthetixInternal(address(synthetix())).emitSynthExchange(
1425             from,
1426             sourceCurrencyKey,
1427             sourceAmountAfterSettlement,
1428             destinationCurrencyKey,
1429             amountReceived,
1430             destinationAddress
1431         );
1432 
1433         // persist the exchange information for the dest key
1434         appendExchange(
1435             destinationAddress,
1436             sourceCurrencyKey,
1437             sourceAmountAfterSettlement,
1438             destinationCurrencyKey,
1439             amountReceived,
1440             exchangeFeeRate
1441         );
1442     }
1443 
1444     // Note: this function can intentionally be called by anyone on behalf of anyone else (the caller just pays the gas)
1445     function settle(address from, bytes32 currencyKey)
1446         external
1447         returns (
1448             uint reclaimed,
1449             uint refunded,
1450             uint numEntriesSettled
1451         )
1452     {
1453         systemStatus().requireSynthActive(currencyKey);
1454         return _internalSettle(from, currencyKey);
1455     }
1456 
1457     function suspendSynthWithInvalidRate(bytes32 currencyKey) external {
1458         systemStatus().requireSystemActive();
1459         require(issuer().synths(currencyKey) != ISynth(0), "No such synth");
1460         require(_isSynthRateInvalid(currencyKey, exchangeRates().rateForCurrency(currencyKey)), "Synth price is valid");
1461         systemStatus().suspendSynth(currencyKey, CIRCUIT_BREAKER_SUSPENSION_REASON);
1462     }
1463 
1464     /* ========== INTERNAL FUNCTIONS ========== */
1465     function _ensureCanExchange(
1466         bytes32 sourceCurrencyKey,
1467         uint sourceAmount,
1468         bytes32 destinationCurrencyKey
1469     ) internal view {
1470         require(sourceCurrencyKey != destinationCurrencyKey, "Can't be same synth");
1471         require(sourceAmount > 0, "Zero amount");
1472 
1473         bytes32[] memory synthKeys = new bytes32[](2);
1474         synthKeys[0] = sourceCurrencyKey;
1475         synthKeys[1] = destinationCurrencyKey;
1476         require(!exchangeRates().anyRateIsStale(synthKeys), "Src/dest rate stale or not found");
1477     }
1478 
1479     function _isSynthRateInvalid(bytes32 currencyKey, uint currentRate) internal view returns (bool) {
1480         if (currentRate == 0) {
1481             return true;
1482         }
1483 
1484         uint lastRateFromExchange = lastExchangeRate[currencyKey];
1485 
1486         if (lastRateFromExchange > 0) {
1487             return _isDeviationAboveThreshold(lastRateFromExchange, currentRate);
1488         }
1489 
1490         // if no last exchange for this synth, then we need to look up last 3 rates (+1 for current rate)
1491         (uint[] memory rates, ) = exchangeRates().ratesAndUpdatedTimeForCurrencyLastNRounds(currencyKey, 4);
1492 
1493         // start at index 1 to ignore current rate
1494         for (uint i = 1; i < rates.length; i++) {
1495             // ignore any empty rates in the past (otherwise we will never be able to get validity)
1496             if (rates[i] > 0 && _isDeviationAboveThreshold(rates[i], currentRate)) {
1497                 return true;
1498             }
1499         }
1500 
1501         return false;
1502     }
1503 
1504     function _isDeviationAboveThreshold(uint base, uint comparison) internal view returns (bool) {
1505         if (base == 0 || comparison == 0) {
1506             return true;
1507         }
1508 
1509         uint factor;
1510         if (comparison > base) {
1511             factor = comparison.divideDecimal(base);
1512         } else {
1513             factor = base.divideDecimal(comparison);
1514         }
1515         return factor >= priceDeviationThresholdFactor;
1516     }
1517 
1518     function remitFee(uint fee, bytes32 currencyKey) internal {
1519         // Remit the fee in sUSDs
1520         uint usdFeeAmount = exchangeRates().effectiveValue(currencyKey, fee, sUSD);
1521         issuer().synths(sUSD).issue(feePool().FEE_ADDRESS(), usdFeeAmount);
1522         // Tell the fee pool about this.
1523         feePool().recordFeePaid(usdFeeAmount);
1524     }
1525 
1526     function _internalSettle(address from, bytes32 currencyKey)
1527         internal
1528         returns (
1529             uint reclaimed,
1530             uint refunded,
1531             uint numEntriesSettled
1532         )
1533     {
1534         require(maxSecsLeftInWaitingPeriod(from, currencyKey) == 0, "Cannot settle during waiting period");
1535 
1536         (
1537             uint reclaimAmount,
1538             uint rebateAmount,
1539             uint entries,
1540             ExchangeEntrySettlement[] memory settlements
1541         ) = _settlementOwing(from, currencyKey);
1542 
1543         if (reclaimAmount > rebateAmount) {
1544             reclaimed = reclaimAmount.sub(rebateAmount);
1545             reclaim(from, currencyKey, reclaimed);
1546         } else if (rebateAmount > reclaimAmount) {
1547             refunded = rebateAmount.sub(reclaimAmount);
1548             refund(from, currencyKey, refunded);
1549         }
1550 
1551         // emit settlement event for each settled exchange entry
1552         for (uint i = 0; i < settlements.length; i++) {
1553             emit ExchangeEntrySettled(
1554                 from,
1555                 settlements[i].src,
1556                 settlements[i].amount,
1557                 settlements[i].dest,
1558                 settlements[i].reclaim,
1559                 settlements[i].rebate,
1560                 settlements[i].srcRoundIdAtPeriodEnd,
1561                 settlements[i].destRoundIdAtPeriodEnd,
1562                 settlements[i].timestamp
1563             );
1564         }
1565 
1566         numEntriesSettled = entries;
1567 
1568         // Now remove all entries, even if no reclaim and no rebate
1569         exchangeState().removeEntries(from, currencyKey);
1570     }
1571 
1572     function reclaim(
1573         address from,
1574         bytes32 currencyKey,
1575         uint amount
1576     ) internal {
1577         // burn amount from user
1578         issuer().synths(currencyKey).burn(from, amount);
1579         ISynthetixInternal(address(synthetix())).emitExchangeReclaim(from, currencyKey, amount);
1580     }
1581 
1582     function refund(
1583         address from,
1584         bytes32 currencyKey,
1585         uint amount
1586     ) internal {
1587         // issue amount to user
1588         issuer().synths(currencyKey).issue(from, amount);
1589         ISynthetixInternal(address(synthetix())).emitExchangeRebate(from, currencyKey, amount);
1590     }
1591 
1592     function secsLeftInWaitingPeriodForExchange(uint timestamp) internal view returns (uint) {
1593         if (timestamp == 0 || now >= timestamp.add(waitingPeriodSecs)) {
1594             return 0;
1595         }
1596 
1597         return timestamp.add(waitingPeriodSecs).sub(now);
1598     }
1599 
1600     function feeRateForExchange(bytes32 sourceCurrencyKey, bytes32 destinationCurrencyKey)
1601         external
1602         view
1603         returns (uint exchangeFeeRate)
1604     {
1605         exchangeFeeRate = _feeRateForExchange(sourceCurrencyKey, destinationCurrencyKey);
1606     }
1607 
1608     function _feeRateForExchange(
1609         bytes32, // API for source in case pricing model evolves to include source rate /* sourceCurrencyKey */
1610         bytes32 destinationCurrencyKey
1611     ) internal view returns (uint exchangeFeeRate) {
1612         exchangeFeeRate = feePool().getExchangeFeeRateForSynth(destinationCurrencyKey);
1613     }
1614 
1615     function getAmountsForExchange(
1616         uint sourceAmount,
1617         bytes32 sourceCurrencyKey,
1618         bytes32 destinationCurrencyKey
1619     )
1620         external
1621         view
1622         returns (
1623             uint amountReceived,
1624             uint fee,
1625             uint exchangeFeeRate
1626         )
1627     {
1628         (amountReceived, fee, exchangeFeeRate, , ) = _getAmountsForExchangeMinusFees(
1629             sourceAmount,
1630             sourceCurrencyKey,
1631             destinationCurrencyKey
1632         );
1633     }
1634 
1635     function _getAmountsForExchangeMinusFees(
1636         uint sourceAmount,
1637         bytes32 sourceCurrencyKey,
1638         bytes32 destinationCurrencyKey
1639     )
1640         internal
1641         view
1642         returns (
1643             uint amountReceived,
1644             uint fee,
1645             uint exchangeFeeRate,
1646             uint sourceRate,
1647             uint destinationRate
1648         )
1649     {
1650         uint destinationAmount;
1651         (destinationAmount, sourceRate, destinationRate) = exchangeRates().effectiveValueAndRates(
1652             sourceCurrencyKey,
1653             sourceAmount,
1654             destinationCurrencyKey
1655         );
1656         exchangeFeeRate = _feeRateForExchange(sourceCurrencyKey, destinationCurrencyKey);
1657         amountReceived = _getAmountReceivedForExchange(destinationAmount, exchangeFeeRate);
1658         fee = destinationAmount.sub(amountReceived);
1659     }
1660 
1661     function _getAmountReceivedForExchange(uint destinationAmount, uint exchangeFeeRate)
1662         internal
1663         pure
1664         returns (uint amountReceived)
1665     {
1666         amountReceived = destinationAmount.multiplyDecimal(SafeDecimalMath.unit().sub(exchangeFeeRate));
1667     }
1668 
1669     function appendExchange(
1670         address account,
1671         bytes32 src,
1672         uint amount,
1673         bytes32 dest,
1674         uint amountReceived,
1675         uint exchangeFeeRate
1676     ) internal {
1677         IExchangeRates exRates = exchangeRates();
1678         uint roundIdForSrc = exRates.getCurrentRoundId(src);
1679         uint roundIdForDest = exRates.getCurrentRoundId(dest);
1680         exchangeState().appendExchangeEntry(
1681             account,
1682             src,
1683             amount,
1684             dest,
1685             amountReceived,
1686             exchangeFeeRate,
1687             now,
1688             roundIdForSrc,
1689             roundIdForDest
1690         );
1691 
1692         emit ExchangeEntryAppended(
1693             account,
1694             src,
1695             amount,
1696             dest,
1697             amountReceived,
1698             exchangeFeeRate,
1699             roundIdForSrc,
1700             roundIdForDest
1701         );
1702     }
1703 
1704     function getRoundIdsAtPeriodEnd(
1705         address account,
1706         bytes32 currencyKey,
1707         uint index
1708     ) internal view returns (uint srcRoundIdAtPeriodEnd, uint destRoundIdAtPeriodEnd) {
1709         (bytes32 src, , bytes32 dest, , , uint timestamp, uint roundIdForSrc, uint roundIdForDest) = exchangeState()
1710             .getEntryAt(account, currencyKey, index);
1711 
1712         IExchangeRates exRates = exchangeRates();
1713         srcRoundIdAtPeriodEnd = exRates.getLastRoundIdBeforeElapsedSecs(src, roundIdForSrc, timestamp, waitingPeriodSecs);
1714         destRoundIdAtPeriodEnd = exRates.getLastRoundIdBeforeElapsedSecs(dest, roundIdForDest, timestamp, waitingPeriodSecs);
1715     }
1716 
1717     // ========== MODIFIERS ==========
1718 
1719     modifier onlySynthetixorSynth() {
1720         ISynthetix _synthetix = synthetix();
1721         require(
1722             msg.sender == address(_synthetix) || _synthetix.synthsByAddress(msg.sender) != bytes32(0),
1723             "Exchanger: Only synthetix or a synth contract can perform this action"
1724         );
1725         _;
1726     }
1727 
1728     // ========== EVENTS ==========
1729     event PriceDeviationThresholdUpdated(uint threshold);
1730     event WaitingPeriodSecsUpdated(uint waitingPeriodSecs);
1731 
1732     event ExchangeEntryAppended(
1733         address indexed account,
1734         bytes32 src,
1735         uint256 amount,
1736         bytes32 dest,
1737         uint256 amountReceived,
1738         uint256 exchangeFeeRate,
1739         uint256 roundIdForSrc,
1740         uint256 roundIdForDest
1741     );
1742 
1743     event ExchangeEntrySettled(
1744         address indexed from,
1745         bytes32 src,
1746         uint256 amount,
1747         bytes32 dest,
1748         uint256 reclaim,
1749         uint256 rebate,
1750         uint256 srcRoundIdAtPeriodEnd,
1751         uint256 destRoundIdAtPeriodEnd,
1752         uint256 exchangeTimestamp
1753     );
1754 }
1755 
1756 
1757     