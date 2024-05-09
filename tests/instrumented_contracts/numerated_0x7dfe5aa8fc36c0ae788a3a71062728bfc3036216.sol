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
120 interface ISynthetix {
121     // Views
122     function availableCurrencyKeys() external view returns (bytes32[] memory);
123 
124     function availableSynthCount() external view returns (uint);
125 
126     function collateral(address account) external view returns (uint);
127 
128     function collateralisationRatio(address issuer) external view returns (uint);
129 
130     function debtBalanceOf(address issuer, bytes32 currencyKey) external view returns (uint);
131 
132     function debtBalanceOfAndTotalDebt(address issuer, bytes32 currencyKey)
133         external
134         view
135         returns (uint debtBalance, uint totalSystemValue);
136 
137     function isWaitingPeriod(bytes32 currencyKey) external view returns (bool);
138 
139     function maxIssuableSynths(address issuer) external view returns (uint maxIssuable);
140 
141     function remainingIssuableSynths(address issuer)
142         external
143         view
144         returns (
145             uint maxIssuable,
146             uint alreadyIssued,
147             uint totalSystemDebt
148         );
149 
150     function synths(bytes32 currencyKey) external view returns (ISynth);
151 
152     function synthsByAddress(address synthAddress) external view returns (bytes32);
153 
154     function totalIssuedSynths(bytes32 currencyKey) external view returns (uint);
155 
156     function totalIssuedSynthsExcludeEtherCollateral(bytes32 currencyKey) external view returns (uint);
157 
158     function transferableSynthetix(address account) external view returns (uint);
159 
160     // Mutative Functions
161     function burnSynths(uint amount) external;
162 
163     function burnSynthsOnBehalf(address burnForAddress, uint amount) external;
164 
165     function burnSynthsToTarget() external;
166 
167     function burnSynthsToTargetOnBehalf(address burnForAddress) external;
168 
169     function exchange(
170         bytes32 sourceCurrencyKey,
171         uint sourceAmount,
172         bytes32 destinationCurrencyKey
173     ) external returns (uint amountReceived);
174 
175     function exchangeOnBehalf(
176         address exchangeForAddress,
177         bytes32 sourceCurrencyKey,
178         uint sourceAmount,
179         bytes32 destinationCurrencyKey
180     ) external returns (uint amountReceived);
181 
182     function issueMaxSynths() external;
183 
184     function issueMaxSynthsOnBehalf(address issueForAddress) external;
185 
186     function issueSynths(uint amount) external;
187 
188     function issueSynthsOnBehalf(address issueForAddress, uint amount) external;
189 
190     function mint() external returns (bool);
191 
192     function settle(bytes32 currencyKey)
193         external
194         returns (
195             uint reclaimed,
196             uint refunded,
197             uint numEntries
198         );
199 
200     function liquidateDelinquentAccount(address account, uint susdAmount) external returns (bool);
201 }
202 
203 
204 // Inheritance
205 
206 
207 // https://docs.synthetix.io/contracts/AddressResolver
208 contract AddressResolver is Owned, IAddressResolver {
209     mapping(bytes32 => address) public repository;
210 
211     constructor(address _owner) public Owned(_owner) {}
212 
213     /* ========== MUTATIVE FUNCTIONS ========== */
214 
215     function importAddresses(bytes32[] calldata names, address[] calldata destinations) external onlyOwner {
216         require(names.length == destinations.length, "Input lengths must match");
217 
218         for (uint i = 0; i < names.length; i++) {
219             repository[names[i]] = destinations[i];
220         }
221     }
222 
223     /* ========== VIEWS ========== */
224 
225     function getAddress(bytes32 name) external view returns (address) {
226         return repository[name];
227     }
228 
229     function requireAndGetAddress(bytes32 name, string calldata reason) external view returns (address) {
230         address _foundAddress = repository[name];
231         require(_foundAddress != address(0), reason);
232         return _foundAddress;
233     }
234 
235     function getSynth(bytes32 key) external view returns (address) {
236         ISynthetix synthetix = ISynthetix(repository["Synthetix"]);
237         require(address(synthetix) != address(0), "Cannot find Synthetix address");
238         return address(synthetix.synths(key));
239     }
240 }
241 
242 
243 // Inheritance
244 
245 
246 // Internal references
247 
248 
249 // https://docs.synthetix.io/contracts/MixinResolver
250 contract MixinResolver is Owned {
251     AddressResolver public resolver;
252 
253     mapping(bytes32 => address) private addressCache;
254 
255     bytes32[] public resolverAddressesRequired;
256 
257     uint public constant MAX_ADDRESSES_FROM_RESOLVER = 24;
258 
259     constructor(address _resolver, bytes32[MAX_ADDRESSES_FROM_RESOLVER] memory _addressesToCache) internal {
260         // This contract is abstract, and thus cannot be instantiated directly
261         require(owner != address(0), "Owner must be set");
262 
263         for (uint i = 0; i < _addressesToCache.length; i++) {
264             if (_addressesToCache[i] != bytes32(0)) {
265                 resolverAddressesRequired.push(_addressesToCache[i]);
266             } else {
267                 // End early once an empty item is found - assumes there are no empty slots in
268                 // _addressesToCache
269                 break;
270             }
271         }
272         resolver = AddressResolver(_resolver);
273         // Do not sync the cache as addresses may not be in the resolver yet
274     }
275 
276     /* ========== SETTERS ========== */
277     function setResolverAndSyncCache(AddressResolver _resolver) external onlyOwner {
278         resolver = _resolver;
279 
280         for (uint i = 0; i < resolverAddressesRequired.length; i++) {
281             bytes32 name = resolverAddressesRequired[i];
282             // Note: can only be invoked once the resolver has all the targets needed added
283             addressCache[name] = resolver.requireAndGetAddress(name, "Resolver missing target");
284         }
285     }
286 
287     /* ========== VIEWS ========== */
288 
289     function requireAndGetAddress(bytes32 name, string memory reason) internal view returns (address) {
290         address _foundAddress = addressCache[name];
291         require(_foundAddress != address(0), reason);
292         return _foundAddress;
293     }
294 
295     // Note: this could be made external in a utility contract if addressCache was made public
296     // (used for deployment)
297     function isResolverCached(AddressResolver _resolver) external view returns (bool) {
298         if (resolver != _resolver) {
299             return false;
300         }
301 
302         // otherwise, check everything
303         for (uint i = 0; i < resolverAddressesRequired.length; i++) {
304             bytes32 name = resolverAddressesRequired[i];
305             // false if our cache is invalid or if the resolver doesn't have the required address
306             if (resolver.getAddress(name) != addressCache[name] || addressCache[name] == address(0)) {
307                 return false;
308             }
309         }
310 
311         return true;
312     }
313 
314     // Note: can be made external into a utility contract (used for deployment)
315     function getResolverAddressesRequired()
316         external
317         view
318         returns (bytes32[MAX_ADDRESSES_FROM_RESOLVER] memory addressesRequired)
319     {
320         for (uint i = 0; i < resolverAddressesRequired.length; i++) {
321             addressesRequired[i] = resolverAddressesRequired[i];
322         }
323     }
324 
325     /* ========== INTERNAL FUNCTIONS ========== */
326     function appendToAddressCache(bytes32 name) internal {
327         resolverAddressesRequired.push(name);
328         require(resolverAddressesRequired.length < MAX_ADDRESSES_FROM_RESOLVER, "Max resolver cache size met");
329         // Because this is designed to be called internally in constructors, we don't
330         // check the address exists already in the resolver
331         addressCache[name] = resolver.getAddress(name);
332     }
333 }
334 
335 
336 interface IExchanger {
337     // Views
338     function calculateAmountAfterSettlement(
339         address from,
340         bytes32 currencyKey,
341         uint amount,
342         uint refunded
343     ) external view returns (uint amountAfterSettlement);
344 
345     function maxSecsLeftInWaitingPeriod(address account, bytes32 currencyKey) external view returns (uint);
346 
347     function settlementOwing(address account, bytes32 currencyKey)
348         external
349         view
350         returns (
351             uint reclaimAmount,
352             uint rebateAmount,
353             uint numEntries
354         );
355 
356     function hasWaitingPeriodOrSettlementOwing(address account, bytes32 currencyKey) external view returns (bool);
357 
358     function feeRateForExchange(bytes32 sourceCurrencyKey, bytes32 destinationCurrencyKey)
359         external
360         view
361         returns (uint exchangeFeeRate);
362 
363     function getAmountsForExchange(
364         uint sourceAmount,
365         bytes32 sourceCurrencyKey,
366         bytes32 destinationCurrencyKey
367     )
368         external
369         view
370         returns (
371             uint amountReceived,
372             uint fee,
373             uint exchangeFeeRate
374         );
375 
376     // Mutative functions
377     function exchange(
378         address from,
379         bytes32 sourceCurrencyKey,
380         uint sourceAmount,
381         bytes32 destinationCurrencyKey,
382         address destinationAddress
383     ) external returns (uint amountReceived);
384 
385     function exchangeOnBehalf(
386         address exchangeForAddress,
387         address from,
388         bytes32 sourceCurrencyKey,
389         uint sourceAmount,
390         bytes32 destinationCurrencyKey
391     ) external returns (uint amountReceived);
392 
393     function settle(address from, bytes32 currencyKey)
394         external
395         returns (
396             uint reclaimed,
397             uint refunded,
398             uint numEntries
399         );
400 }
401 
402 
403 /**
404  * @dev Wrappers over Solidity's arithmetic operations with added overflow
405  * checks.
406  *
407  * Arithmetic operations in Solidity wrap on overflow. This can easily result
408  * in bugs, because programmers usually assume that an overflow raises an
409  * error, which is the standard behavior in high level programming languages.
410  * `SafeMath` restores this intuition by reverting the transaction when an
411  * operation overflows.
412  *
413  * Using this library instead of the unchecked operations eliminates an entire
414  * class of bugs, so it's recommended to use it always.
415  */
416 library SafeMath {
417     /**
418      * @dev Returns the addition of two unsigned integers, reverting on
419      * overflow.
420      *
421      * Counterpart to Solidity's `+` operator.
422      *
423      * Requirements:
424      * - Addition cannot overflow.
425      */
426     function add(uint256 a, uint256 b) internal pure returns (uint256) {
427         uint256 c = a + b;
428         require(c >= a, "SafeMath: addition overflow");
429 
430         return c;
431     }
432 
433     /**
434      * @dev Returns the subtraction of two unsigned integers, reverting on
435      * overflow (when the result is negative).
436      *
437      * Counterpart to Solidity's `-` operator.
438      *
439      * Requirements:
440      * - Subtraction cannot overflow.
441      */
442     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
443         require(b <= a, "SafeMath: subtraction overflow");
444         uint256 c = a - b;
445 
446         return c;
447     }
448 
449     /**
450      * @dev Returns the multiplication of two unsigned integers, reverting on
451      * overflow.
452      *
453      * Counterpart to Solidity's `*` operator.
454      *
455      * Requirements:
456      * - Multiplication cannot overflow.
457      */
458     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
459         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
460         // benefit is lost if 'b' is also tested.
461         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
462         if (a == 0) {
463             return 0;
464         }
465 
466         uint256 c = a * b;
467         require(c / a == b, "SafeMath: multiplication overflow");
468 
469         return c;
470     }
471 
472     /**
473      * @dev Returns the integer division of two unsigned integers. Reverts on
474      * division by zero. The result is rounded towards zero.
475      *
476      * Counterpart to Solidity's `/` operator. Note: this function uses a
477      * `revert` opcode (which leaves remaining gas untouched) while Solidity
478      * uses an invalid opcode to revert (consuming all remaining gas).
479      *
480      * Requirements:
481      * - The divisor cannot be zero.
482      */
483     function div(uint256 a, uint256 b) internal pure returns (uint256) {
484         // Solidity only automatically asserts when dividing by 0
485         require(b > 0, "SafeMath: division by zero");
486         uint256 c = a / b;
487         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
488 
489         return c;
490     }
491 
492     /**
493      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
494      * Reverts when dividing by zero.
495      *
496      * Counterpart to Solidity's `%` operator. This function uses a `revert`
497      * opcode (which leaves remaining gas untouched) while Solidity uses an
498      * invalid opcode to revert (consuming all remaining gas).
499      *
500      * Requirements:
501      * - The divisor cannot be zero.
502      */
503     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
504         require(b != 0, "SafeMath: modulo by zero");
505         return a % b;
506     }
507 }
508 
509 
510 // Libraries
511 
512 
513 // https://docs.synthetix.io/contracts/SafeDecimalMath
514 library SafeDecimalMath {
515     using SafeMath for uint;
516 
517     /* Number of decimal places in the representations. */
518     uint8 public constant decimals = 18;
519     uint8 public constant highPrecisionDecimals = 27;
520 
521     /* The number representing 1.0. */
522     uint public constant UNIT = 10**uint(decimals);
523 
524     /* The number representing 1.0 for higher fidelity numbers. */
525     uint public constant PRECISE_UNIT = 10**uint(highPrecisionDecimals);
526     uint private constant UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR = 10**uint(highPrecisionDecimals - decimals);
527 
528     /**
529      * @return Provides an interface to UNIT.
530      */
531     function unit() external pure returns (uint) {
532         return UNIT;
533     }
534 
535     /**
536      * @return Provides an interface to PRECISE_UNIT.
537      */
538     function preciseUnit() external pure returns (uint) {
539         return PRECISE_UNIT;
540     }
541 
542     /**
543      * @return The result of multiplying x and y, interpreting the operands as fixed-point
544      * decimals.
545      *
546      * @dev A unit factor is divided out after the product of x and y is evaluated,
547      * so that product must be less than 2**256. As this is an integer division,
548      * the internal division always rounds down. This helps save on gas. Rounding
549      * is more expensive on gas.
550      */
551     function multiplyDecimal(uint x, uint y) internal pure returns (uint) {
552         /* Divide by UNIT to remove the extra factor introduced by the product. */
553         return x.mul(y) / UNIT;
554     }
555 
556     /**
557      * @return The result of safely multiplying x and y, interpreting the operands
558      * as fixed-point decimals of the specified precision unit.
559      *
560      * @dev The operands should be in the form of a the specified unit factor which will be
561      * divided out after the product of x and y is evaluated, so that product must be
562      * less than 2**256.
563      *
564      * Unlike multiplyDecimal, this function rounds the result to the nearest increment.
565      * Rounding is useful when you need to retain fidelity for small decimal numbers
566      * (eg. small fractions or percentages).
567      */
568     function _multiplyDecimalRound(
569         uint x,
570         uint y,
571         uint precisionUnit
572     ) private pure returns (uint) {
573         /* Divide by UNIT to remove the extra factor introduced by the product. */
574         uint quotientTimesTen = x.mul(y) / (precisionUnit / 10);
575 
576         if (quotientTimesTen % 10 >= 5) {
577             quotientTimesTen += 10;
578         }
579 
580         return quotientTimesTen / 10;
581     }
582 
583     /**
584      * @return The result of safely multiplying x and y, interpreting the operands
585      * as fixed-point decimals of a precise unit.
586      *
587      * @dev The operands should be in the precise unit factor which will be
588      * divided out after the product of x and y is evaluated, so that product must be
589      * less than 2**256.
590      *
591      * Unlike multiplyDecimal, this function rounds the result to the nearest increment.
592      * Rounding is useful when you need to retain fidelity for small decimal numbers
593      * (eg. small fractions or percentages).
594      */
595     function multiplyDecimalRoundPrecise(uint x, uint y) internal pure returns (uint) {
596         return _multiplyDecimalRound(x, y, PRECISE_UNIT);
597     }
598 
599     /**
600      * @return The result of safely multiplying x and y, interpreting the operands
601      * as fixed-point decimals of a standard unit.
602      *
603      * @dev The operands should be in the standard unit factor which will be
604      * divided out after the product of x and y is evaluated, so that product must be
605      * less than 2**256.
606      *
607      * Unlike multiplyDecimal, this function rounds the result to the nearest increment.
608      * Rounding is useful when you need to retain fidelity for small decimal numbers
609      * (eg. small fractions or percentages).
610      */
611     function multiplyDecimalRound(uint x, uint y) internal pure returns (uint) {
612         return _multiplyDecimalRound(x, y, UNIT);
613     }
614 
615     /**
616      * @return The result of safely dividing x and y. The return value is a high
617      * precision decimal.
618      *
619      * @dev y is divided after the product of x and the standard precision unit
620      * is evaluated, so the product of x and UNIT must be less than 2**256. As
621      * this is an integer division, the result is always rounded down.
622      * This helps save on gas. Rounding is more expensive on gas.
623      */
624     function divideDecimal(uint x, uint y) internal pure returns (uint) {
625         /* Reintroduce the UNIT factor that will be divided out by y. */
626         return x.mul(UNIT).div(y);
627     }
628 
629     /**
630      * @return The result of safely dividing x and y. The return value is as a rounded
631      * decimal in the precision unit specified in the parameter.
632      *
633      * @dev y is divided after the product of x and the specified precision unit
634      * is evaluated, so the product of x and the specified precision unit must
635      * be less than 2**256. The result is rounded to the nearest increment.
636      */
637     function _divideDecimalRound(
638         uint x,
639         uint y,
640         uint precisionUnit
641     ) private pure returns (uint) {
642         uint resultTimesTen = x.mul(precisionUnit * 10).div(y);
643 
644         if (resultTimesTen % 10 >= 5) {
645             resultTimesTen += 10;
646         }
647 
648         return resultTimesTen / 10;
649     }
650 
651     /**
652      * @return The result of safely dividing x and y. The return value is as a rounded
653      * standard precision decimal.
654      *
655      * @dev y is divided after the product of x and the standard precision unit
656      * is evaluated, so the product of x and the standard precision unit must
657      * be less than 2**256. The result is rounded to the nearest increment.
658      */
659     function divideDecimalRound(uint x, uint y) internal pure returns (uint) {
660         return _divideDecimalRound(x, y, UNIT);
661     }
662 
663     /**
664      * @return The result of safely dividing x and y. The return value is as a rounded
665      * high precision decimal.
666      *
667      * @dev y is divided after the product of x and the high precision unit
668      * is evaluated, so the product of x and the high precision unit must
669      * be less than 2**256. The result is rounded to the nearest increment.
670      */
671     function divideDecimalRoundPrecise(uint x, uint y) internal pure returns (uint) {
672         return _divideDecimalRound(x, y, PRECISE_UNIT);
673     }
674 
675     /**
676      * @dev Convert a standard decimal representation to a high precision one.
677      */
678     function decimalToPreciseDecimal(uint i) internal pure returns (uint) {
679         return i.mul(UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR);
680     }
681 
682     /**
683      * @dev Convert a high precision decimal to a standard decimal representation.
684      */
685     function preciseDecimalToDecimal(uint i) internal pure returns (uint) {
686         uint quotientTimesTen = i / (UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR / 10);
687 
688         if (quotientTimesTen % 10 >= 5) {
689             quotientTimesTen += 10;
690         }
691 
692         return quotientTimesTen / 10;
693     }
694 }
695 
696 
697 interface IERC20 {
698     // ERC20 Optional Views
699     function name() external view returns (string memory);
700 
701     function symbol() external view returns (string memory);
702 
703     function decimals() external view returns (uint8);
704 
705     // Views
706     function totalSupply() external view returns (uint);
707 
708     function balanceOf(address owner) external view returns (uint);
709 
710     function allowance(address owner, address spender) external view returns (uint);
711 
712     // Mutative functions
713     function transfer(address to, uint value) external returns (bool);
714 
715     function approve(address spender, uint value) external returns (bool);
716 
717     function transferFrom(
718         address from,
719         address to,
720         uint value
721     ) external returns (bool);
722 
723     // Events
724     event Transfer(address indexed from, address indexed to, uint value);
725 
726     event Approval(address indexed owner, address indexed spender, uint value);
727 }
728 
729 
730 interface ISystemStatus {
731     // Views
732     function requireSystemActive() external view;
733 
734     function requireIssuanceActive() external view;
735 
736     function requireExchangeActive() external view;
737 
738     function requireSynthActive(bytes32 currencyKey) external view;
739 
740     function requireSynthsActive(bytes32 sourceCurrencyKey, bytes32 destinationCurrencyKey) external view;
741 }
742 
743 
744 interface IExchangeState {
745     // Views
746     function getLengthOfEntries(address account, bytes32 currencyKey) external view returns (uint);
747 
748     function getEntryAt(
749         address account,
750         bytes32 currencyKey,
751         uint index
752     )
753         external
754         view
755         returns (
756             bytes32 src,
757             uint amount,
758             bytes32 dest,
759             uint amountReceived,
760             uint exchangeFeeRate,
761             uint timestamp,
762             uint roundIdForSrc,
763             uint roundIdForDest
764         );
765 
766     function getMaxTimestamp(address account, bytes32 currencyKey) external view returns (uint);
767 
768     // Mutative functions
769     function appendExchangeEntry(
770         address account,
771         bytes32 src,
772         uint amount,
773         bytes32 dest,
774         uint amountReceived,
775         uint exchangeFeeRate,
776         uint timestamp,
777         uint roundIdForSrc,
778         uint roundIdForDest
779     ) external;
780 
781     function removeEntries(address account, bytes32 currencyKey) external;
782 }
783 
784 
785 interface IExchangeRates {
786     // Views
787     function aggregators(bytes32 currencyKey) external view returns (address);
788 
789     function anyRateIsStale(bytes32[] calldata currencyKeys) external view returns (bool);
790 
791     function currentRoundForRate(bytes32 currencyKey) external view returns (uint);
792 
793     function effectiveValue(
794         bytes32 sourceCurrencyKey,
795         uint sourceAmount,
796         bytes32 destinationCurrencyKey
797     ) external view returns (uint);
798 
799     function effectiveValueAtRound(
800         bytes32 sourceCurrencyKey,
801         uint sourceAmount,
802         bytes32 destinationCurrencyKey,
803         uint roundIdForSrc,
804         uint roundIdForDest
805     ) external view returns (uint);
806 
807     function getCurrentRoundId(bytes32 currencyKey) external view returns (uint);
808 
809     function getLastRoundIdBeforeElapsedSecs(
810         bytes32 currencyKey,
811         uint startingRoundId,
812         uint startingTimestamp,
813         uint timediff
814     ) external view returns (uint);
815 
816     function inversePricing(bytes32 currencyKey)
817         external
818         view
819         returns (
820             uint entryPoint,
821             uint upperLimit,
822             uint lowerLimit,
823             bool frozen
824         );
825 
826     function lastRateUpdateTimes(bytes32 currencyKey) external view returns (uint256);
827 
828     function oracle() external view returns (address);
829 
830     function rateAndTimestampAtRound(bytes32 currencyKey, uint roundId) external view returns (uint rate, uint time);
831 
832     function rateForCurrency(bytes32 currencyKey) external view returns (uint);
833 
834     function rateIsFrozen(bytes32 currencyKey) external view returns (bool);
835 
836     function rateIsStale(bytes32 currencyKey) external view returns (bool);
837 
838     function ratesAndStaleForCurrencies(bytes32[] calldata currencyKeys) external view returns (uint[] memory, bool);
839 
840     function ratesForCurrencies(bytes32[] calldata currencyKeys) external view returns (uint[] memory);
841 
842     function rateStalePeriod() external view returns (uint);
843 }
844 
845 
846 interface IFeePool {
847     // Views
848     function getExchangeFeeRateForSynth(bytes32 synthKey) external view returns (uint);
849 
850     // solhint-disable-next-line func-name-mixedcase
851     function FEE_ADDRESS() external view returns (address);
852 
853     function feesAvailable(address account) external view returns (uint, uint);
854 
855     function isFeesClaimable(address account) external view returns (bool);
856 
857     function totalFeesAvailable() external view returns (uint);
858 
859     function totalRewardsAvailable() external view returns (uint);
860 
861     // Mutative Functions
862     function claimFees() external returns (bool);
863 
864     function claimOnBehalf(address claimingForAddress) external returns (bool);
865 
866     function closeCurrentFeePeriod() external;
867 
868     // Restricted: used internally to Synthetix
869     function appendAccountIssuanceRecord(
870         address account,
871         uint lockedAmount,
872         uint debtEntryIndex
873     ) external;
874 
875     function recordFeePaid(uint sUSDAmount) external;
876 
877     function setRewardsToDistribute(uint amount) external;
878 }
879 
880 
881 interface IDelegateApprovals {
882     // Views
883     function canBurnFor(address authoriser, address delegate) external view returns (bool);
884 
885     function canIssueFor(address authoriser, address delegate) external view returns (bool);
886 
887     function canClaimFor(address authoriser, address delegate) external view returns (bool);
888 
889     function canExchangeFor(address authoriser, address delegate) external view returns (bool);
890 
891     // Mutative
892     function approveAllDelegatePowers(address delegate) external;
893 
894     function removeAllDelegatePowers(address delegate) external;
895 
896     function approveBurnOnBehalf(address delegate) external;
897 
898     function removeBurnOnBehalf(address delegate) external;
899 
900     function approveIssueOnBehalf(address delegate) external;
901 
902     function removeIssueOnBehalf(address delegate) external;
903 
904     function approveClaimOnBehalf(address delegate) external;
905 
906     function removeClaimOnBehalf(address delegate) external;
907 
908     function approveExchangeOnBehalf(address delegate) external;
909 
910     function removeExchangeOnBehalf(address delegate) external;
911 }
912 
913 
914 // Inheritance
915 
916 
917 // Libraries
918 
919 
920 // Internal references
921 
922 
923 // Used to have strongly-typed access to internal mutative functions in Synthetix
924 interface ISynthetixInternal {
925     function emitSynthExchange(
926         address account,
927         bytes32 fromCurrencyKey,
928         uint fromAmount,
929         bytes32 toCurrencyKey,
930         uint toAmount,
931         address toAddress
932     ) external;
933 
934     function emitExchangeReclaim(
935         address account,
936         bytes32 currencyKey,
937         uint amount
938     ) external;
939 
940     function emitExchangeRebate(
941         address account,
942         bytes32 currencyKey,
943         uint amount
944     ) external;
945 }
946 
947 
948 // https://docs.synthetix.io/contracts/Exchanger
949 contract Exchanger is Owned, MixinResolver, IExchanger {
950     using SafeMath for uint;
951     using SafeDecimalMath for uint;
952 
953     bytes32 private constant sUSD = "sUSD";
954 
955     uint public waitingPeriodSecs;
956 
957     /* ========== ADDRESS RESOLVER CONFIGURATION ========== */
958 
959     bytes32 private constant CONTRACT_SYSTEMSTATUS = "SystemStatus";
960     bytes32 private constant CONTRACT_EXCHANGESTATE = "ExchangeState";
961     bytes32 private constant CONTRACT_EXRATES = "ExchangeRates";
962     bytes32 private constant CONTRACT_SYNTHETIX = "Synthetix";
963     bytes32 private constant CONTRACT_FEEPOOL = "FeePool";
964     bytes32 private constant CONTRACT_DELEGATEAPPROVALS = "DelegateApprovals";
965 
966     bytes32[24] private addressesToCache = [
967         CONTRACT_SYSTEMSTATUS,
968         CONTRACT_EXCHANGESTATE,
969         CONTRACT_EXRATES,
970         CONTRACT_SYNTHETIX,
971         CONTRACT_FEEPOOL,
972         CONTRACT_DELEGATEAPPROVALS
973     ];
974 
975     constructor(address _owner, address _resolver) public Owned(_owner) MixinResolver(_resolver, addressesToCache) {
976         waitingPeriodSecs = 3 minutes;
977     }
978 
979     /* ========== VIEWS ========== */
980 
981     function systemStatus() internal view returns (ISystemStatus) {
982         return ISystemStatus(requireAndGetAddress(CONTRACT_SYSTEMSTATUS, "Missing SystemStatus address"));
983     }
984 
985     function exchangeState() internal view returns (IExchangeState) {
986         return IExchangeState(requireAndGetAddress(CONTRACT_EXCHANGESTATE, "Missing ExchangeState address"));
987     }
988 
989     function exchangeRates() internal view returns (IExchangeRates) {
990         return IExchangeRates(requireAndGetAddress(CONTRACT_EXRATES, "Missing ExchangeRates address"));
991     }
992 
993     function synthetix() internal view returns (ISynthetix) {
994         return ISynthetix(requireAndGetAddress(CONTRACT_SYNTHETIX, "Missing Synthetix address"));
995     }
996 
997     function feePool() internal view returns (IFeePool) {
998         return IFeePool(requireAndGetAddress(CONTRACT_FEEPOOL, "Missing FeePool address"));
999     }
1000 
1001     function delegateApprovals() internal view returns (IDelegateApprovals) {
1002         return IDelegateApprovals(requireAndGetAddress(CONTRACT_DELEGATEAPPROVALS, "Missing DelegateApprovals address"));
1003     }
1004 
1005     function maxSecsLeftInWaitingPeriod(address account, bytes32 currencyKey) public view returns (uint) {
1006         return secsLeftInWaitingPeriodForExchange(exchangeState().getMaxTimestamp(account, currencyKey));
1007     }
1008 
1009     function settlementOwing(address account, bytes32 currencyKey)
1010         public
1011         view
1012         returns (
1013             uint reclaimAmount,
1014             uint rebateAmount,
1015             uint numEntries
1016         )
1017     {
1018         // Need to sum up all reclaim and rebate amounts for the user and the currency key
1019         numEntries = exchangeState().getLengthOfEntries(account, currencyKey);
1020 
1021         // For each unsettled exchange
1022         for (uint i = 0; i < numEntries; i++) {
1023             // fetch the entry from storage
1024             (bytes32 src, uint amount, bytes32 dest, uint amountReceived, uint exchangeFeeRate, , , ) = exchangeState()
1025                 .getEntryAt(account, currencyKey, i);
1026 
1027             // determine the last round ids for src and dest pairs when period ended or latest if not over
1028             (uint srcRoundIdAtPeriodEnd, uint destRoundIdAtPeriodEnd) = getRoundIdsAtPeriodEnd(account, currencyKey, i);
1029 
1030             // given these round ids, determine what effective value they should have received
1031             uint destinationAmount = exchangeRates().effectiveValueAtRound(
1032                 src,
1033                 amount,
1034                 dest,
1035                 srcRoundIdAtPeriodEnd,
1036                 destRoundIdAtPeriodEnd
1037             );
1038 
1039             // and deduct the fee from this amount using the exchangeFeeRate from storage
1040             uint amountShouldHaveReceived = _getAmountReceivedForExchange(destinationAmount, exchangeFeeRate);
1041 
1042             if (amountReceived > amountShouldHaveReceived) {
1043                 // if they received more than they should have, add to the reclaim tally
1044                 reclaimAmount = reclaimAmount.add(amountReceived.sub(amountShouldHaveReceived));
1045             } else if (amountShouldHaveReceived > amountReceived) {
1046                 // if less, add to the rebate tally
1047                 rebateAmount = rebateAmount.add(amountShouldHaveReceived.sub(amountReceived));
1048             }
1049         }
1050 
1051         return (reclaimAmount, rebateAmount, numEntries);
1052     }
1053 
1054     function hasWaitingPeriodOrSettlementOwing(address account, bytes32 currencyKey) external view returns (bool) {
1055         if (maxSecsLeftInWaitingPeriod(account, currencyKey) != 0) {
1056             return true;
1057         }
1058 
1059         (uint reclaimAmount, , ) = settlementOwing(account, currencyKey);
1060 
1061         return reclaimAmount > 0;
1062     }
1063 
1064     /* ========== SETTERS ========== */
1065 
1066     function setWaitingPeriodSecs(uint _waitingPeriodSecs) external onlyOwner {
1067         waitingPeriodSecs = _waitingPeriodSecs;
1068     }
1069 
1070     function calculateAmountAfterSettlement(
1071         address from,
1072         bytes32 currencyKey,
1073         uint amount,
1074         uint refunded
1075     ) public view returns (uint amountAfterSettlement) {
1076         amountAfterSettlement = amount;
1077 
1078         // balance of a synth will show an amount after settlement
1079         uint balanceOfSourceAfterSettlement = IERC20(address(synthetix().synths(currencyKey))).balanceOf(from);
1080 
1081         // when there isn't enough supply (either due to reclamation settlement or because the number is too high)
1082         if (amountAfterSettlement > balanceOfSourceAfterSettlement) {
1083             // then the amount to exchange is reduced to their remaining supply
1084             amountAfterSettlement = balanceOfSourceAfterSettlement;
1085         }
1086 
1087         if (refunded > 0) {
1088             amountAfterSettlement = amountAfterSettlement.add(refunded);
1089         }
1090     }
1091 
1092     /* ========== MUTATIVE FUNCTIONS ========== */
1093     function exchange(
1094         address from,
1095         bytes32 sourceCurrencyKey,
1096         uint sourceAmount,
1097         bytes32 destinationCurrencyKey,
1098         address destinationAddress
1099     ) external onlySynthetixorSynth returns (uint amountReceived) {
1100         amountReceived = _exchange(from, sourceCurrencyKey, sourceAmount, destinationCurrencyKey, destinationAddress);
1101     }
1102 
1103     function exchangeOnBehalf(
1104         address exchangeForAddress,
1105         address from,
1106         bytes32 sourceCurrencyKey,
1107         uint sourceAmount,
1108         bytes32 destinationCurrencyKey
1109     ) external onlySynthetixorSynth returns (uint amountReceived) {
1110         require(delegateApprovals().canExchangeFor(exchangeForAddress, from), "Not approved to act on behalf");
1111         amountReceived = _exchange(
1112             exchangeForAddress,
1113             sourceCurrencyKey,
1114             sourceAmount,
1115             destinationCurrencyKey,
1116             exchangeForAddress
1117         );
1118     }
1119 
1120     function _exchange(
1121         address from,
1122         bytes32 sourceCurrencyKey,
1123         uint sourceAmount,
1124         bytes32 destinationCurrencyKey,
1125         address destinationAddress
1126     )
1127         internal
1128         returns (
1129             // Note: We don't need to insist on non-stale rates because effectiveValue will do it for us.
1130             uint amountReceived
1131         )
1132     {
1133         require(sourceCurrencyKey != destinationCurrencyKey, "Can't be same synth");
1134         require(sourceAmount > 0, "Zero amount");
1135 
1136         (, uint refunded, uint numEntriesSettled) = _internalSettle(from, sourceCurrencyKey);
1137 
1138         uint sourceAmountAfterSettlement = sourceAmount;
1139 
1140         // when settlement was required
1141         if (numEntriesSettled > 0) {
1142             // ensure the sourceAmount takes this into account
1143             sourceAmountAfterSettlement = calculateAmountAfterSettlement(from, sourceCurrencyKey, sourceAmount, refunded);
1144 
1145             // If, after settlement the user has no balance left (highly unlikely), then return to prevent
1146             // emitting events of 0 and don't revert so as to ensure the settlement queue is emptied
1147             if (sourceAmountAfterSettlement == 0) {
1148                 return 0;
1149             }
1150         }
1151 
1152         // Note: We don't need to check their balance as the burn() below will do a safe subtraction which requires
1153         // the subtraction to not overflow, which would happen if their balance is not sufficient.
1154 
1155         // Burn the source amount
1156         synthetix().synths(sourceCurrencyKey).burn(from, sourceAmountAfterSettlement);
1157 
1158         uint fee;
1159         uint exchangeFeeRate;
1160 
1161         (amountReceived, fee, exchangeFeeRate) = _getAmountsForExchangeMinusFees(
1162             sourceAmountAfterSettlement,
1163             sourceCurrencyKey,
1164             destinationCurrencyKey
1165         );
1166 
1167         // Issue their new synths
1168         synthetix().synths(destinationCurrencyKey).issue(destinationAddress, amountReceived);
1169 
1170         // Remit the fee if required
1171         if (fee > 0) {
1172             remitFee(exchangeRates(), synthetix(), fee, destinationCurrencyKey);
1173         }
1174 
1175         // Nothing changes as far as issuance data goes because the total value in the system hasn't changed.
1176 
1177         // Let the DApps know there was a Synth exchange
1178         ISynthetixInternal(address(synthetix())).emitSynthExchange(
1179             from,
1180             sourceCurrencyKey,
1181             sourceAmountAfterSettlement,
1182             destinationCurrencyKey,
1183             amountReceived,
1184             destinationAddress
1185         );
1186 
1187         // persist the exchange information for the dest key
1188         appendExchange(
1189             destinationAddress,
1190             sourceCurrencyKey,
1191             sourceAmountAfterSettlement,
1192             destinationCurrencyKey,
1193             amountReceived,
1194             exchangeFeeRate
1195         );
1196     }
1197 
1198     function settle(address from, bytes32 currencyKey)
1199         external
1200         returns (
1201             uint reclaimed,
1202             uint refunded,
1203             uint numEntriesSettled
1204         )
1205     {
1206         // Note: this function can be called by anyone on behalf of anyone else
1207 
1208         systemStatus().requireExchangeActive();
1209 
1210         systemStatus().requireSynthActive(currencyKey);
1211 
1212         return _internalSettle(from, currencyKey);
1213     }
1214 
1215     /* ========== INTERNAL FUNCTIONS ========== */
1216 
1217     function remitFee(
1218         IExchangeRates _exRates,
1219         ISynthetix _synthetix,
1220         uint fee,
1221         bytes32 currencyKey
1222     ) internal {
1223         // Remit the fee in sUSDs
1224         uint usdFeeAmount = _exRates.effectiveValue(currencyKey, fee, sUSD);
1225         _synthetix.synths(sUSD).issue(feePool().FEE_ADDRESS(), usdFeeAmount);
1226         // Tell the fee pool about this.
1227         feePool().recordFeePaid(usdFeeAmount);
1228     }
1229 
1230     function _internalSettle(address from, bytes32 currencyKey)
1231         internal
1232         returns (
1233             uint reclaimed,
1234             uint refunded,
1235             uint numEntriesSettled
1236         )
1237     {
1238         require(maxSecsLeftInWaitingPeriod(from, currencyKey) == 0, "Cannot settle during waiting period");
1239 
1240         (uint reclaimAmount, uint rebateAmount, uint entries) = settlementOwing(from, currencyKey);
1241 
1242         if (reclaimAmount > rebateAmount) {
1243             reclaimed = reclaimAmount.sub(rebateAmount);
1244             reclaim(from, currencyKey, reclaimed);
1245         } else if (rebateAmount > reclaimAmount) {
1246             refunded = rebateAmount.sub(reclaimAmount);
1247             refund(from, currencyKey, refunded);
1248         }
1249 
1250         numEntriesSettled = entries;
1251 
1252         // Now remove all entries, even if no reclaim and no rebate
1253         exchangeState().removeEntries(from, currencyKey);
1254     }
1255 
1256     function reclaim(
1257         address from,
1258         bytes32 currencyKey,
1259         uint amount
1260     ) internal {
1261         // burn amount from user
1262         synthetix().synths(currencyKey).burn(from, amount);
1263         ISynthetixInternal(address(synthetix())).emitExchangeReclaim(from, currencyKey, amount);
1264     }
1265 
1266     function refund(
1267         address from,
1268         bytes32 currencyKey,
1269         uint amount
1270     ) internal {
1271         // issue amount to user
1272         synthetix().synths(currencyKey).issue(from, amount);
1273         ISynthetixInternal(address(synthetix())).emitExchangeRebate(from, currencyKey, amount);
1274     }
1275 
1276     function secsLeftInWaitingPeriodForExchange(uint timestamp) internal view returns (uint) {
1277         if (timestamp == 0 || now >= timestamp.add(waitingPeriodSecs)) {
1278             return 0;
1279         }
1280 
1281         return timestamp.add(waitingPeriodSecs).sub(now);
1282     }
1283 
1284     function feeRateForExchange(bytes32 sourceCurrencyKey, bytes32 destinationCurrencyKey)
1285         external
1286         view
1287         returns (uint exchangeFeeRate)
1288     {
1289         exchangeFeeRate = _feeRateForExchange(sourceCurrencyKey, destinationCurrencyKey);
1290     }
1291 
1292     function _feeRateForExchange(
1293         bytes32, // API for source in case pricing model evolves to include source rate /* sourceCurrencyKey */
1294         bytes32 destinationCurrencyKey
1295     ) internal view returns (uint exchangeFeeRate) {
1296         exchangeFeeRate = feePool().getExchangeFeeRateForSynth(destinationCurrencyKey);
1297     }
1298 
1299     function getAmountsForExchange(
1300         uint sourceAmount,
1301         bytes32 sourceCurrencyKey,
1302         bytes32 destinationCurrencyKey
1303     )
1304         external
1305         view
1306         returns (
1307             uint amountReceived,
1308             uint fee,
1309             uint exchangeFeeRate
1310         )
1311     {
1312         (amountReceived, fee, exchangeFeeRate) = _getAmountsForExchangeMinusFees(
1313             sourceAmount,
1314             sourceCurrencyKey,
1315             destinationCurrencyKey
1316         );
1317     }
1318 
1319     function _getAmountsForExchangeMinusFees(
1320         uint sourceAmount,
1321         bytes32 sourceCurrencyKey,
1322         bytes32 destinationCurrencyKey
1323     )
1324         internal
1325         view
1326         returns (
1327             uint amountReceived,
1328             uint fee,
1329             uint exchangeFeeRate
1330         )
1331     {
1332         uint destinationAmount = exchangeRates().effectiveValue(sourceCurrencyKey, sourceAmount, destinationCurrencyKey);
1333         exchangeFeeRate = _feeRateForExchange(sourceCurrencyKey, destinationCurrencyKey);
1334         amountReceived = _getAmountReceivedForExchange(destinationAmount, exchangeFeeRate);
1335         fee = destinationAmount.sub(amountReceived);
1336     }
1337 
1338     function _getAmountReceivedForExchange(uint destinationAmount, uint exchangeFeeRate)
1339         internal
1340         pure
1341         returns (uint amountReceived)
1342     {
1343         amountReceived = destinationAmount.multiplyDecimal(SafeDecimalMath.unit().sub(exchangeFeeRate));
1344     }
1345 
1346     function appendExchange(
1347         address account,
1348         bytes32 src,
1349         uint amount,
1350         bytes32 dest,
1351         uint amountReceived,
1352         uint exchangeFeeRate
1353     ) internal {
1354         IExchangeRates exRates = exchangeRates();
1355         uint roundIdForSrc = exRates.getCurrentRoundId(src);
1356         uint roundIdForDest = exRates.getCurrentRoundId(dest);
1357         exchangeState().appendExchangeEntry(
1358             account,
1359             src,
1360             amount,
1361             dest,
1362             amountReceived,
1363             exchangeFeeRate,
1364             now,
1365             roundIdForSrc,
1366             roundIdForDest
1367         );
1368     }
1369 
1370     function getRoundIdsAtPeriodEnd(
1371         address account,
1372         bytes32 currencyKey,
1373         uint index
1374     ) internal view returns (uint srcRoundIdAtPeriodEnd, uint destRoundIdAtPeriodEnd) {
1375         (bytes32 src, , bytes32 dest, , , uint timestamp, uint roundIdForSrc, uint roundIdForDest) = exchangeState()
1376             .getEntryAt(account, currencyKey, index);
1377 
1378         IExchangeRates exRates = exchangeRates();
1379         srcRoundIdAtPeriodEnd = exRates.getLastRoundIdBeforeElapsedSecs(src, roundIdForSrc, timestamp, waitingPeriodSecs);
1380         destRoundIdAtPeriodEnd = exRates.getLastRoundIdBeforeElapsedSecs(dest, roundIdForDest, timestamp, waitingPeriodSecs);
1381     }
1382 
1383     // ========== MODIFIERS ==========
1384 
1385     modifier onlySynthetixorSynth() {
1386         ISynthetix _synthetix = synthetix();
1387         require(
1388             msg.sender == address(_synthetix) || _synthetix.synthsByAddress(msg.sender) != bytes32(0),
1389             "Exchanger: Only synthetix or a synth contract can perform this action"
1390         );
1391         _;
1392     }
1393 }
1394 
1395 
1396     