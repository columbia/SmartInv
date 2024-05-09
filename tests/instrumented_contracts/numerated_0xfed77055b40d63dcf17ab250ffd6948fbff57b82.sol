1 /*
2    ____            __   __        __   _
3   / __/__ __ ___  / /_ / /  ___  / /_ (_)__ __
4  _\ \ / // // _ \/ __// _ \/ -_)/ __// / \ \ /
5 /___/ \_, //_//_/\__//_//_/\__/ \__//_/ /_\_\
6      /___/
7 
8 * Synthetix: EtherCollateralsUSD.sol
9 *
10 * Latest source (may be newer): https://github.com/Synthetixio/synthetix/blob/master/contracts/EtherCollateralsUSD.sol
11 * Docs: https://docs.synthetix.io/contracts/EtherCollateralsUSD
12 *
13 * Contract Dependencies: 
14 *	- IAddressResolver
15 *	- IEtherCollateralsUSD
16 *	- MixinResolver
17 *	- Owned
18 *	- Pausable
19 *	- ReentrancyGuard
20 * Libraries: 
21 *	- SafeDecimalMath
22 *	- SafeMath
23 *
24 * MIT License
25 * ===========
26 *
27 * Copyright (c) 2020 Synthetix
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
49 pragma solidity ^0.5.16;
50 
51 
52 // https://docs.synthetix.io/contracts/Owned
53 contract Owned {
54     address public owner;
55     address public nominatedOwner;
56 
57     constructor(address _owner) public {
58         require(_owner != address(0), "Owner address cannot be 0");
59         owner = _owner;
60         emit OwnerChanged(address(0), _owner);
61     }
62 
63     function nominateNewOwner(address _owner) external onlyOwner {
64         nominatedOwner = _owner;
65         emit OwnerNominated(_owner);
66     }
67 
68     function acceptOwnership() external {
69         require(msg.sender == nominatedOwner, "You must be nominated before you can accept ownership");
70         emit OwnerChanged(owner, nominatedOwner);
71         owner = nominatedOwner;
72         nominatedOwner = address(0);
73     }
74 
75     modifier onlyOwner {
76         _onlyOwner();
77         _;
78     }
79 
80     function _onlyOwner() private view {
81         require(msg.sender == owner, "Only the contract owner may perform this action");
82     }
83 
84     event OwnerNominated(address newOwner);
85     event OwnerChanged(address oldOwner, address newOwner);
86 }
87 
88 
89 // Inheritance
90 
91 
92 // https://docs.synthetix.io/contracts/Pausable
93 contract Pausable is Owned {
94     uint public lastPauseTime;
95     bool public paused;
96 
97     constructor() internal {
98         // This contract is abstract, and thus cannot be instantiated directly
99         require(owner != address(0), "Owner must be set");
100         // Paused will be false, and lastPauseTime will be 0 upon initialisation
101     }
102 
103     /**
104      * @notice Change the paused state of the contract
105      * @dev Only the contract owner may call this.
106      */
107     function setPaused(bool _paused) external onlyOwner {
108         // Ensure we're actually changing the state before we do anything
109         if (_paused == paused) {
110             return;
111         }
112 
113         // Set our paused state.
114         paused = _paused;
115 
116         // If applicable, set the last pause time.
117         if (paused) {
118             lastPauseTime = now;
119         }
120 
121         // Let everyone know that our pause state has changed.
122         emit PauseChanged(paused);
123     }
124 
125     event PauseChanged(bool isPaused);
126 
127     modifier notPaused {
128         require(!paused, "This action cannot be performed while the contract is paused");
129         _;
130     }
131 }
132 
133 
134 /**
135  * @dev Contract module that helps prevent reentrant calls to a function.
136  *
137  * Inheriting from `ReentrancyGuard` will make the `nonReentrant` modifier
138  * available, which can be aplied to functions to make sure there are no nested
139  * (reentrant) calls to them.
140  *
141  * Note that because there is a single `nonReentrant` guard, functions marked as
142  * `nonReentrant` may not call one another. This can be worked around by making
143  * those functions `private`, and then adding `external` `nonReentrant` entry
144  * points to them.
145  */
146 contract ReentrancyGuard {
147     /// @dev counter to allow mutex lock with only one SSTORE operation
148     uint256 private _guardCounter;
149 
150     constructor () internal {
151         // The counter starts at one to prevent changing it from zero to a non-zero
152         // value, which is a more expensive operation.
153         _guardCounter = 1;
154     }
155 
156     /**
157      * @dev Prevents a contract from calling itself, directly or indirectly.
158      * Calling a `nonReentrant` function from another `nonReentrant`
159      * function is not supported. It is possible to prevent this from happening
160      * by making the `nonReentrant` function external, and make it call a
161      * `private` function that does the actual work.
162      */
163     modifier nonReentrant() {
164         _guardCounter += 1;
165         uint256 localCounter = _guardCounter;
166         _;
167         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
168     }
169 }
170 
171 
172 interface IAddressResolver {
173     function getAddress(bytes32 name) external view returns (address);
174 
175     function getSynth(bytes32 key) external view returns (address);
176 
177     function requireAndGetAddress(bytes32 name, string calldata reason) external view returns (address);
178 }
179 
180 
181 interface ISynth {
182     // Views
183     function currencyKey() external view returns (bytes32);
184 
185     function transferableSynths(address account) external view returns (uint);
186 
187     // Mutative functions
188     function transferAndSettle(address to, uint value) external returns (bool);
189 
190     function transferFromAndSettle(
191         address from,
192         address to,
193         uint value
194     ) external returns (bool);
195 
196     // Restricted: used internally to Synthetix
197     function burn(address account, uint amount) external;
198 
199     function issue(address account, uint amount) external;
200 }
201 
202 
203 interface IIssuer {
204     // Views
205     function anySynthOrSNXRateIsInvalid() external view returns (bool anyRateInvalid);
206 
207     function availableCurrencyKeys() external view returns (bytes32[] memory);
208 
209     function availableSynthCount() external view returns (uint);
210 
211     function availableSynths(uint index) external view returns (ISynth);
212 
213     function canBurnSynths(address account) external view returns (bool);
214 
215     function collateral(address account) external view returns (uint);
216 
217     function collateralisationRatio(address issuer) external view returns (uint);
218 
219     function collateralisationRatioAndAnyRatesInvalid(address _issuer)
220         external
221         view
222         returns (uint cratio, bool anyRateIsInvalid);
223 
224     function debtBalanceOf(address issuer, bytes32 currencyKey) external view returns (uint debtBalance);
225 
226     function issuanceRatio() external view returns (uint);
227 
228     function lastIssueEvent(address account) external view returns (uint);
229 
230     function maxIssuableSynths(address issuer) external view returns (uint maxIssuable);
231 
232     function minimumStakeTime() external view returns (uint);
233 
234     function remainingIssuableSynths(address issuer)
235         external
236         view
237         returns (
238             uint maxIssuable,
239             uint alreadyIssued,
240             uint totalSystemDebt
241         );
242 
243     function synths(bytes32 currencyKey) external view returns (ISynth);
244 
245     function synthsByAddress(address synthAddress) external view returns (bytes32);
246 
247     function totalIssuedSynths(bytes32 currencyKey, bool excludeEtherCollateral) external view returns (uint);
248 
249     function transferableSynthetixAndAnyRateIsInvalid(address account, uint balance)
250         external
251         view
252         returns (uint transferable, bool anyRateIsInvalid);
253 
254     // Restricted: used internally to Synthetix
255     function issueSynths(address from, uint amount) external;
256 
257     function issueSynthsOnBehalf(
258         address issueFor,
259         address from,
260         uint amount
261     ) external;
262 
263     function issueMaxSynths(address from) external;
264 
265     function issueMaxSynthsOnBehalf(address issueFor, address from) external;
266 
267     function burnSynths(address from, uint amount) external;
268 
269     function burnSynthsOnBehalf(
270         address burnForAddress,
271         address from,
272         uint amount
273     ) external;
274 
275     function burnSynthsToTarget(address from) external;
276 
277     function burnSynthsToTargetOnBehalf(address burnForAddress, address from) external;
278 
279     function liquidateDelinquentAccount(
280         address account,
281         uint susdAmount,
282         address liquidator
283     ) external returns (uint totalRedeemed, uint amountToLiquidate);
284 }
285 
286 
287 // Inheritance
288 
289 
290 // https://docs.synthetix.io/contracts/AddressResolver
291 contract AddressResolver is Owned, IAddressResolver {
292     mapping(bytes32 => address) public repository;
293 
294     constructor(address _owner) public Owned(_owner) {}
295 
296     /* ========== MUTATIVE FUNCTIONS ========== */
297 
298     function importAddresses(bytes32[] calldata names, address[] calldata destinations) external onlyOwner {
299         require(names.length == destinations.length, "Input lengths must match");
300 
301         for (uint i = 0; i < names.length; i++) {
302             repository[names[i]] = destinations[i];
303         }
304     }
305 
306     /* ========== VIEWS ========== */
307 
308     function getAddress(bytes32 name) external view returns (address) {
309         return repository[name];
310     }
311 
312     function requireAndGetAddress(bytes32 name, string calldata reason) external view returns (address) {
313         address _foundAddress = repository[name];
314         require(_foundAddress != address(0), reason);
315         return _foundAddress;
316     }
317 
318     function getSynth(bytes32 key) external view returns (address) {
319         IIssuer issuer = IIssuer(repository["Issuer"]);
320         require(address(issuer) != address(0), "Cannot find Issuer address");
321         return address(issuer.synths(key));
322     }
323 }
324 
325 
326 // Inheritance
327 
328 
329 // Internal references
330 
331 
332 // https://docs.synthetix.io/contracts/MixinResolver
333 contract MixinResolver is Owned {
334     AddressResolver public resolver;
335 
336     mapping(bytes32 => address) private addressCache;
337 
338     bytes32[] public resolverAddressesRequired;
339 
340     uint public constant MAX_ADDRESSES_FROM_RESOLVER = 24;
341 
342     constructor(address _resolver, bytes32[MAX_ADDRESSES_FROM_RESOLVER] memory _addressesToCache) internal {
343         // This contract is abstract, and thus cannot be instantiated directly
344         require(owner != address(0), "Owner must be set");
345 
346         for (uint i = 0; i < _addressesToCache.length; i++) {
347             if (_addressesToCache[i] != bytes32(0)) {
348                 resolverAddressesRequired.push(_addressesToCache[i]);
349             } else {
350                 // End early once an empty item is found - assumes there are no empty slots in
351                 // _addressesToCache
352                 break;
353             }
354         }
355         resolver = AddressResolver(_resolver);
356         // Do not sync the cache as addresses may not be in the resolver yet
357     }
358 
359     /* ========== SETTERS ========== */
360     function setResolverAndSyncCache(AddressResolver _resolver) external onlyOwner {
361         resolver = _resolver;
362 
363         for (uint i = 0; i < resolverAddressesRequired.length; i++) {
364             bytes32 name = resolverAddressesRequired[i];
365             // Note: can only be invoked once the resolver has all the targets needed added
366             addressCache[name] = resolver.requireAndGetAddress(name, "Resolver missing target");
367         }
368     }
369 
370     /* ========== VIEWS ========== */
371 
372     function requireAndGetAddress(bytes32 name, string memory reason) internal view returns (address) {
373         address _foundAddress = addressCache[name];
374         require(_foundAddress != address(0), reason);
375         return _foundAddress;
376     }
377 
378     // Note: this could be made external in a utility contract if addressCache was made public
379     // (used for deployment)
380     function isResolverCached(AddressResolver _resolver) external view returns (bool) {
381         if (resolver != _resolver) {
382             return false;
383         }
384 
385         // otherwise, check everything
386         for (uint i = 0; i < resolverAddressesRequired.length; i++) {
387             bytes32 name = resolverAddressesRequired[i];
388             // false if our cache is invalid or if the resolver doesn't have the required address
389             if (resolver.getAddress(name) != addressCache[name] || addressCache[name] == address(0)) {
390                 return false;
391             }
392         }
393 
394         return true;
395     }
396 
397     // Note: can be made external into a utility contract (used for deployment)
398     function getResolverAddressesRequired()
399         external
400         view
401         returns (bytes32[MAX_ADDRESSES_FROM_RESOLVER] memory addressesRequired)
402     {
403         for (uint i = 0; i < resolverAddressesRequired.length; i++) {
404             addressesRequired[i] = resolverAddressesRequired[i];
405         }
406     }
407 
408     /* ========== INTERNAL FUNCTIONS ========== */
409     function appendToAddressCache(bytes32 name) internal {
410         resolverAddressesRequired.push(name);
411         require(resolverAddressesRequired.length < MAX_ADDRESSES_FROM_RESOLVER, "Max resolver cache size met");
412         // Because this is designed to be called internally in constructors, we don't
413         // check the address exists already in the resolver
414         addressCache[name] = resolver.getAddress(name);
415     }
416 }
417 
418 
419 interface IEtherCollateralsUSD {
420     // Views
421     function totalIssuedSynths() external view returns (uint256);
422 
423     function totalLoansCreated() external view returns (uint256);
424 
425     function totalOpenLoanCount() external view returns (uint256);
426 
427     // Mutative functions
428     function openLoan(uint256 _loanAmount) external payable returns (uint256 loanID);
429 
430     function closeLoan(uint256 loanID) external;
431 
432     function liquidateUnclosedLoan(address _loanCreatorsAddress, uint256 _loanID) external;
433 
434     function depositCollateral(address account, uint256 loanID) external payable;
435 
436     function withdrawCollateral(uint256 loanID, uint256 withdrawAmount) external;
437 
438     function repayLoan(
439         address _loanCreatorsAddress,
440         uint256 _loanID,
441         uint256 _repayAmount
442     ) external;
443 }
444 
445 
446 /**
447  * @dev Wrappers over Solidity's arithmetic operations with added overflow
448  * checks.
449  *
450  * Arithmetic operations in Solidity wrap on overflow. This can easily result
451  * in bugs, because programmers usually assume that an overflow raises an
452  * error, which is the standard behavior in high level programming languages.
453  * `SafeMath` restores this intuition by reverting the transaction when an
454  * operation overflows.
455  *
456  * Using this library instead of the unchecked operations eliminates an entire
457  * class of bugs, so it's recommended to use it always.
458  */
459 library SafeMath {
460     /**
461      * @dev Returns the addition of two unsigned integers, reverting on
462      * overflow.
463      *
464      * Counterpart to Solidity's `+` operator.
465      *
466      * Requirements:
467      * - Addition cannot overflow.
468      */
469     function add(uint256 a, uint256 b) internal pure returns (uint256) {
470         uint256 c = a + b;
471         require(c >= a, "SafeMath: addition overflow");
472 
473         return c;
474     }
475 
476     /**
477      * @dev Returns the subtraction of two unsigned integers, reverting on
478      * overflow (when the result is negative).
479      *
480      * Counterpart to Solidity's `-` operator.
481      *
482      * Requirements:
483      * - Subtraction cannot overflow.
484      */
485     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
486         require(b <= a, "SafeMath: subtraction overflow");
487         uint256 c = a - b;
488 
489         return c;
490     }
491 
492     /**
493      * @dev Returns the multiplication of two unsigned integers, reverting on
494      * overflow.
495      *
496      * Counterpart to Solidity's `*` operator.
497      *
498      * Requirements:
499      * - Multiplication cannot overflow.
500      */
501     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
502         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
503         // benefit is lost if 'b' is also tested.
504         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
505         if (a == 0) {
506             return 0;
507         }
508 
509         uint256 c = a * b;
510         require(c / a == b, "SafeMath: multiplication overflow");
511 
512         return c;
513     }
514 
515     /**
516      * @dev Returns the integer division of two unsigned integers. Reverts on
517      * division by zero. The result is rounded towards zero.
518      *
519      * Counterpart to Solidity's `/` operator. Note: this function uses a
520      * `revert` opcode (which leaves remaining gas untouched) while Solidity
521      * uses an invalid opcode to revert (consuming all remaining gas).
522      *
523      * Requirements:
524      * - The divisor cannot be zero.
525      */
526     function div(uint256 a, uint256 b) internal pure returns (uint256) {
527         // Solidity only automatically asserts when dividing by 0
528         require(b > 0, "SafeMath: division by zero");
529         uint256 c = a / b;
530         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
531 
532         return c;
533     }
534 
535     /**
536      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
537      * Reverts when dividing by zero.
538      *
539      * Counterpart to Solidity's `%` operator. This function uses a `revert`
540      * opcode (which leaves remaining gas untouched) while Solidity uses an
541      * invalid opcode to revert (consuming all remaining gas).
542      *
543      * Requirements:
544      * - The divisor cannot be zero.
545      */
546     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
547         require(b != 0, "SafeMath: modulo by zero");
548         return a % b;
549     }
550 }
551 
552 
553 // Libraries
554 
555 
556 // https://docs.synthetix.io/contracts/SafeDecimalMath
557 library SafeDecimalMath {
558     using SafeMath for uint;
559 
560     /* Number of decimal places in the representations. */
561     uint8 public constant decimals = 18;
562     uint8 public constant highPrecisionDecimals = 27;
563 
564     /* The number representing 1.0. */
565     uint public constant UNIT = 10**uint(decimals);
566 
567     /* The number representing 1.0 for higher fidelity numbers. */
568     uint public constant PRECISE_UNIT = 10**uint(highPrecisionDecimals);
569     uint private constant UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR = 10**uint(highPrecisionDecimals - decimals);
570 
571     /**
572      * @return Provides an interface to UNIT.
573      */
574     function unit() external pure returns (uint) {
575         return UNIT;
576     }
577 
578     /**
579      * @return Provides an interface to PRECISE_UNIT.
580      */
581     function preciseUnit() external pure returns (uint) {
582         return PRECISE_UNIT;
583     }
584 
585     /**
586      * @return The result of multiplying x and y, interpreting the operands as fixed-point
587      * decimals.
588      *
589      * @dev A unit factor is divided out after the product of x and y is evaluated,
590      * so that product must be less than 2**256. As this is an integer division,
591      * the internal division always rounds down. This helps save on gas. Rounding
592      * is more expensive on gas.
593      */
594     function multiplyDecimal(uint x, uint y) internal pure returns (uint) {
595         /* Divide by UNIT to remove the extra factor introduced by the product. */
596         return x.mul(y) / UNIT;
597     }
598 
599     /**
600      * @return The result of safely multiplying x and y, interpreting the operands
601      * as fixed-point decimals of the specified precision unit.
602      *
603      * @dev The operands should be in the form of a the specified unit factor which will be
604      * divided out after the product of x and y is evaluated, so that product must be
605      * less than 2**256.
606      *
607      * Unlike multiplyDecimal, this function rounds the result to the nearest increment.
608      * Rounding is useful when you need to retain fidelity for small decimal numbers
609      * (eg. small fractions or percentages).
610      */
611     function _multiplyDecimalRound(
612         uint x,
613         uint y,
614         uint precisionUnit
615     ) private pure returns (uint) {
616         /* Divide by UNIT to remove the extra factor introduced by the product. */
617         uint quotientTimesTen = x.mul(y) / (precisionUnit / 10);
618 
619         if (quotientTimesTen % 10 >= 5) {
620             quotientTimesTen += 10;
621         }
622 
623         return quotientTimesTen / 10;
624     }
625 
626     /**
627      * @return The result of safely multiplying x and y, interpreting the operands
628      * as fixed-point decimals of a precise unit.
629      *
630      * @dev The operands should be in the precise unit factor which will be
631      * divided out after the product of x and y is evaluated, so that product must be
632      * less than 2**256.
633      *
634      * Unlike multiplyDecimal, this function rounds the result to the nearest increment.
635      * Rounding is useful when you need to retain fidelity for small decimal numbers
636      * (eg. small fractions or percentages).
637      */
638     function multiplyDecimalRoundPrecise(uint x, uint y) internal pure returns (uint) {
639         return _multiplyDecimalRound(x, y, PRECISE_UNIT);
640     }
641 
642     /**
643      * @return The result of safely multiplying x and y, interpreting the operands
644      * as fixed-point decimals of a standard unit.
645      *
646      * @dev The operands should be in the standard unit factor which will be
647      * divided out after the product of x and y is evaluated, so that product must be
648      * less than 2**256.
649      *
650      * Unlike multiplyDecimal, this function rounds the result to the nearest increment.
651      * Rounding is useful when you need to retain fidelity for small decimal numbers
652      * (eg. small fractions or percentages).
653      */
654     function multiplyDecimalRound(uint x, uint y) internal pure returns (uint) {
655         return _multiplyDecimalRound(x, y, UNIT);
656     }
657 
658     /**
659      * @return The result of safely dividing x and y. The return value is a high
660      * precision decimal.
661      *
662      * @dev y is divided after the product of x and the standard precision unit
663      * is evaluated, so the product of x and UNIT must be less than 2**256. As
664      * this is an integer division, the result is always rounded down.
665      * This helps save on gas. Rounding is more expensive on gas.
666      */
667     function divideDecimal(uint x, uint y) internal pure returns (uint) {
668         /* Reintroduce the UNIT factor that will be divided out by y. */
669         return x.mul(UNIT).div(y);
670     }
671 
672     /**
673      * @return The result of safely dividing x and y. The return value is as a rounded
674      * decimal in the precision unit specified in the parameter.
675      *
676      * @dev y is divided after the product of x and the specified precision unit
677      * is evaluated, so the product of x and the specified precision unit must
678      * be less than 2**256. The result is rounded to the nearest increment.
679      */
680     function _divideDecimalRound(
681         uint x,
682         uint y,
683         uint precisionUnit
684     ) private pure returns (uint) {
685         uint resultTimesTen = x.mul(precisionUnit * 10).div(y);
686 
687         if (resultTimesTen % 10 >= 5) {
688             resultTimesTen += 10;
689         }
690 
691         return resultTimesTen / 10;
692     }
693 
694     /**
695      * @return The result of safely dividing x and y. The return value is as a rounded
696      * standard precision decimal.
697      *
698      * @dev y is divided after the product of x and the standard precision unit
699      * is evaluated, so the product of x and the standard precision unit must
700      * be less than 2**256. The result is rounded to the nearest increment.
701      */
702     function divideDecimalRound(uint x, uint y) internal pure returns (uint) {
703         return _divideDecimalRound(x, y, UNIT);
704     }
705 
706     /**
707      * @return The result of safely dividing x and y. The return value is as a rounded
708      * high precision decimal.
709      *
710      * @dev y is divided after the product of x and the high precision unit
711      * is evaluated, so the product of x and the high precision unit must
712      * be less than 2**256. The result is rounded to the nearest increment.
713      */
714     function divideDecimalRoundPrecise(uint x, uint y) internal pure returns (uint) {
715         return _divideDecimalRound(x, y, PRECISE_UNIT);
716     }
717 
718     /**
719      * @dev Convert a standard decimal representation to a high precision one.
720      */
721     function decimalToPreciseDecimal(uint i) internal pure returns (uint) {
722         return i.mul(UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR);
723     }
724 
725     /**
726      * @dev Convert a high precision decimal to a standard decimal representation.
727      */
728     function preciseDecimalToDecimal(uint i) internal pure returns (uint) {
729         uint quotientTimesTen = i / (UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR / 10);
730 
731         if (quotientTimesTen % 10 >= 5) {
732             quotientTimesTen += 10;
733         }
734 
735         return quotientTimesTen / 10;
736     }
737 }
738 
739 
740 interface ISystemStatus {
741     struct Status {
742         bool canSuspend;
743         bool canResume;
744     }
745 
746     struct Suspension {
747         bool suspended;
748         // reason is an integer code,
749         // 0 => no reason, 1 => upgrading, 2+ => defined by system usage
750         uint248 reason;
751     }
752 
753     // Views
754     function accessControl(bytes32 section, address account) external view returns (bool canSuspend, bool canResume);
755 
756     function requireSystemActive() external view;
757 
758     function requireIssuanceActive() external view;
759 
760     function requireExchangeActive() external view;
761 
762     function requireSynthActive(bytes32 currencyKey) external view;
763 
764     function requireSynthsActive(bytes32 sourceCurrencyKey, bytes32 destinationCurrencyKey) external view;
765 
766     function synthSuspension(bytes32 currencyKey) external view returns (bool suspended, uint248 reason);
767 
768     // Restricted functions
769     function suspendSynth(bytes32 currencyKey, uint256 reason) external;
770 
771     function updateAccessControl(
772         bytes32 section,
773         address account,
774         bool canSuspend,
775         bool canResume
776     ) external;
777 }
778 
779 
780 interface IFeePool {
781     // Views
782 
783     // solhint-disable-next-line func-name-mixedcase
784     function FEE_ADDRESS() external view returns (address);
785 
786     function feesAvailable(address account) external view returns (uint, uint);
787 
788     function feePeriodDuration() external view returns (uint);
789 
790     function isFeesClaimable(address account) external view returns (bool);
791 
792     function targetThreshold() external view returns (uint);
793 
794     function totalFeesAvailable() external view returns (uint);
795 
796     function totalRewardsAvailable() external view returns (uint);
797 
798     // Mutative Functions
799     function claimFees() external returns (bool);
800 
801     function claimOnBehalf(address claimingForAddress) external returns (bool);
802 
803     function closeCurrentFeePeriod() external;
804 
805     // Restricted: used internally to Synthetix
806     function appendAccountIssuanceRecord(
807         address account,
808         uint lockedAmount,
809         uint debtEntryIndex
810     ) external;
811 
812     function recordFeePaid(uint sUSDAmount) external;
813 
814     function setRewardsToDistribute(uint amount) external;
815 }
816 
817 
818 interface IERC20 {
819     // ERC20 Optional Views
820     function name() external view returns (string memory);
821 
822     function symbol() external view returns (string memory);
823 
824     function decimals() external view returns (uint8);
825 
826     // Views
827     function totalSupply() external view returns (uint);
828 
829     function balanceOf(address owner) external view returns (uint);
830 
831     function allowance(address owner, address spender) external view returns (uint);
832 
833     // Mutative functions
834     function transfer(address to, uint value) external returns (bool);
835 
836     function approve(address spender, uint value) external returns (bool);
837 
838     function transferFrom(
839         address from,
840         address to,
841         uint value
842     ) external returns (bool);
843 
844     // Events
845     event Transfer(address indexed from, address indexed to, uint value);
846 
847     event Approval(address indexed owner, address indexed spender, uint value);
848 }
849 
850 
851 // https://docs.synthetix.io/contracts/source/interfaces/IExchangeRates
852 interface IExchangeRates {
853     // Structs
854     struct RateAndUpdatedTime {
855         uint216 rate;
856         uint40 time;
857     }
858 
859     struct InversePricing {
860         uint entryPoint;
861         uint upperLimit;
862         uint lowerLimit;
863         bool frozenAtUpperLimit;
864         bool frozenAtLowerLimit;
865     }
866 
867     // Views
868     function aggregators(bytes32 currencyKey) external view returns (address);
869 
870     function aggregatorWarningFlags() external view returns (address);
871 
872     function anyRateIsInvalid(bytes32[] calldata currencyKeys) external view returns (bool);
873 
874     function canFreezeRate(bytes32 currencyKey) external view returns (bool);
875 
876     function currentRoundForRate(bytes32 currencyKey) external view returns (uint);
877 
878     function currenciesUsingAggregator(address aggregator) external view returns (bytes32[] memory);
879 
880     function effectiveValue(
881         bytes32 sourceCurrencyKey,
882         uint sourceAmount,
883         bytes32 destinationCurrencyKey
884     ) external view returns (uint value);
885 
886     function effectiveValueAndRates(
887         bytes32 sourceCurrencyKey,
888         uint sourceAmount,
889         bytes32 destinationCurrencyKey
890     )
891         external
892         view
893         returns (
894             uint value,
895             uint sourceRate,
896             uint destinationRate
897         );
898 
899     function effectiveValueAtRound(
900         bytes32 sourceCurrencyKey,
901         uint sourceAmount,
902         bytes32 destinationCurrencyKey,
903         uint roundIdForSrc,
904         uint roundIdForDest
905     ) external view returns (uint value);
906 
907     function getCurrentRoundId(bytes32 currencyKey) external view returns (uint);
908 
909     function getLastRoundIdBeforeElapsedSecs(
910         bytes32 currencyKey,
911         uint startingRoundId,
912         uint startingTimestamp,
913         uint timediff
914     ) external view returns (uint);
915 
916     function inversePricing(bytes32 currencyKey)
917         external
918         view
919         returns (
920             uint entryPoint,
921             uint upperLimit,
922             uint lowerLimit,
923             bool frozenAtUpperLimit,
924             bool frozenAtLowerLimit
925         );
926 
927     function lastRateUpdateTimes(bytes32 currencyKey) external view returns (uint256);
928 
929     function oracle() external view returns (address);
930 
931     function rateAndTimestampAtRound(bytes32 currencyKey, uint roundId) external view returns (uint rate, uint time);
932 
933     function rateAndUpdatedTime(bytes32 currencyKey) external view returns (uint rate, uint time);
934 
935     function rateForCurrency(bytes32 currencyKey) external view returns (uint);
936 
937     function rateIsFlagged(bytes32 currencyKey) external view returns (bool);
938 
939     function rateIsFrozen(bytes32 currencyKey) external view returns (bool);
940 
941     function rateIsInvalid(bytes32 currencyKey) external view returns (bool);
942 
943     function rateIsStale(bytes32 currencyKey) external view returns (bool);
944 
945     function rateStalePeriod() external view returns (uint);
946 
947     function ratesAndUpdatedTimeForCurrencyLastNRounds(bytes32 currencyKey, uint numRounds)
948         external
949         view
950         returns (uint[] memory rates, uint[] memory times);
951 
952     function ratesAndInvalidForCurrencies(bytes32[] calldata currencyKeys)
953         external
954         view
955         returns (uint[] memory rates, bool anyRateInvalid);
956 
957     function ratesForCurrencies(bytes32[] calldata currencyKeys) external view returns (uint[] memory);
958 
959     // Mutative functions
960     function freezeRate(bytes32 currencyKey) external;
961 }
962 
963 
964 // Inheritance
965 
966 
967 // Libraries
968 
969 
970 // Internal references
971 
972 
973 // ETH Collateral v0.3 (sUSD)
974 // https://docs.synthetix.io/contracts/EtherCollateralsUSD
975 contract EtherCollateralsUSD is Owned, Pausable, ReentrancyGuard, MixinResolver, IEtherCollateralsUSD {
976     using SafeMath for uint256;
977     using SafeDecimalMath for uint256;
978 
979     bytes32 internal constant ETH = "ETH";
980 
981     // ========== CONSTANTS ==========
982     uint256 internal constant ONE_THOUSAND = 1e18 * 1000;
983     uint256 internal constant ONE_HUNDRED = 1e18 * 100;
984 
985     uint256 internal constant SECONDS_IN_A_YEAR = 31536000; // Common Year
986 
987     // Where fees are pooled in sUSD.
988     address internal constant FEE_ADDRESS = 0xfeEFEEfeefEeFeefEEFEEfEeFeefEEFeeFEEFEeF;
989 
990     uint256 internal constant ACCOUNT_LOAN_LIMIT_CAP = 1000;
991     bytes32 private constant sUSD = "sUSD";
992     bytes32 public constant COLLATERAL = "ETH";
993 
994     // ========== SETTER STATE VARIABLES ==========
995 
996     // The ratio of Collateral to synths issued
997     uint256 public collateralizationRatio = SafeDecimalMath.unit() * 150;
998 
999     // If updated, all outstanding loans will pay this interest rate in on closure of the loan. Default 5%
1000     uint256 public interestRate = (5 * SafeDecimalMath.unit()) / 100;
1001     uint256 public interestPerSecond = interestRate.div(SECONDS_IN_A_YEAR);
1002 
1003     // Minting fee for issuing the synths. Default 50 bips.
1004     uint256 public issueFeeRate = (5 * SafeDecimalMath.unit()) / 1000;
1005 
1006     // Maximum amount of sUSD that can be issued by the EtherCollateral contract. Default 10MM
1007     uint256 public issueLimit = SafeDecimalMath.unit() * 10000000;
1008 
1009     // Minimum amount of ETH to create loan preventing griefing and gas consumption. Min 1ETH
1010     uint256 public minLoanCollateralSize = SafeDecimalMath.unit() * 1;
1011 
1012     // Maximum number of loans an account can create
1013     uint256 public accountLoanLimit = 50;
1014 
1015     // If true then any wallet addres can close a loan not just the loan creator.
1016     bool public loanLiquidationOpen = false;
1017 
1018     // Time when remaining loans can be liquidated
1019     uint256 public liquidationDeadline;
1020 
1021     // Liquidation ratio when loans can be liquidated
1022     uint256 public liquidationRatio = (150 * SafeDecimalMath.unit()) / 100; // 1.5 ratio
1023 
1024     // Liquidation penalty when loans are liquidated. default 10%
1025     uint256 public liquidationPenalty = SafeDecimalMath.unit() / 10;
1026 
1027     // ========== STATE VARIABLES ==========
1028 
1029     // The total number of synths issued by the collateral in this contract
1030     uint256 public totalIssuedSynths;
1031 
1032     // Total number of loans ever created
1033     uint256 public totalLoansCreated;
1034 
1035     // Total number of open loans
1036     uint256 public totalOpenLoanCount;
1037 
1038     // Synth loan storage struct
1039     struct SynthLoanStruct {
1040         //  Acccount that created the loan
1041         address payable account;
1042         //  Amount (in collateral token ) that they deposited
1043         uint256 collateralAmount;
1044         //  Amount (in synths) that they issued to borrow
1045         uint256 loanAmount;
1046         // Minting Fee
1047         uint256 mintingFee;
1048         // When the loan was created
1049         uint256 timeCreated;
1050         // ID for the loan
1051         uint256 loanID;
1052         // When the loan was paidback (closed)
1053         uint256 timeClosed;
1054         // Applicable Interest rate
1055         uint256 loanInterestRate;
1056         // interest amounts accrued
1057         uint256 accruedInterest;
1058         // last timestamp interest amounts accrued
1059         uint40 lastInterestAccrued;
1060     }
1061 
1062     // Users Loans by address
1063     mapping(address => SynthLoanStruct[]) public accountsSynthLoans;
1064 
1065     // Account Open Loan Counter
1066     mapping(address => uint256) public accountOpenLoanCounter;
1067 
1068     /* ========== ADDRESS RESOLVER CONFIGURATION ========== */
1069 
1070     bytes32 private constant CONTRACT_SYSTEMSTATUS = "SystemStatus";
1071     bytes32 private constant CONTRACT_SYNTHSUSD = "SynthsUSD";
1072     bytes32 private constant CONTRACT_EXRATES = "ExchangeRates";
1073     bytes32 private constant CONTRACT_FEEPOOL = "FeePool";
1074 
1075     bytes32[24] private addressesToCache = [CONTRACT_SYSTEMSTATUS, CONTRACT_SYNTHSUSD, CONTRACT_EXRATES, CONTRACT_FEEPOOL];
1076 
1077     // ========== CONSTRUCTOR ==========
1078     constructor(address _owner, address _resolver)
1079         public
1080         Owned(_owner)
1081         Pausable()
1082         MixinResolver(_resolver, addressesToCache)
1083     {
1084         liquidationDeadline = block.timestamp + 92 days; // Time before loans can be open for liquidation to end the trial contract
1085     }
1086 
1087     // ========== SETTERS ==========
1088 
1089     function setCollateralizationRatio(uint256 ratio) external onlyOwner {
1090         require(ratio <= ONE_THOUSAND, "Too high");
1091         require(ratio >= ONE_HUNDRED, "Too low");
1092         collateralizationRatio = ratio;
1093         emit CollateralizationRatioUpdated(ratio);
1094     }
1095 
1096     function setInterestRate(uint256 _interestRate) external onlyOwner {
1097         require(_interestRate > SECONDS_IN_A_YEAR, "Interest rate cannot be less that the SECONDS_IN_A_YEAR");
1098         require(_interestRate <= SafeDecimalMath.unit(), "Interest cannot be more than 100% APR");
1099         interestRate = _interestRate;
1100         interestPerSecond = _interestRate.div(SECONDS_IN_A_YEAR);
1101         emit InterestRateUpdated(interestRate);
1102     }
1103 
1104     function setIssueFeeRate(uint256 _issueFeeRate) external onlyOwner {
1105         issueFeeRate = _issueFeeRate;
1106         emit IssueFeeRateUpdated(issueFeeRate);
1107     }
1108 
1109     function setIssueLimit(uint256 _issueLimit) external onlyOwner {
1110         issueLimit = _issueLimit;
1111         emit IssueLimitUpdated(issueLimit);
1112     }
1113 
1114     function setMinLoanCollateralSize(uint256 _minLoanCollateralSize) external onlyOwner {
1115         minLoanCollateralSize = _minLoanCollateralSize;
1116         emit MinLoanCollateralSizeUpdated(minLoanCollateralSize);
1117     }
1118 
1119     function setAccountLoanLimit(uint256 _loanLimit) external onlyOwner {
1120         require(_loanLimit < ACCOUNT_LOAN_LIMIT_CAP, "Owner cannot set higher than ACCOUNT_LOAN_LIMIT_CAP");
1121         accountLoanLimit = _loanLimit;
1122         emit AccountLoanLimitUpdated(accountLoanLimit);
1123     }
1124 
1125     function setLoanLiquidationOpen(bool _loanLiquidationOpen) external onlyOwner {
1126         require(block.timestamp > liquidationDeadline, "Before liquidation deadline");
1127         loanLiquidationOpen = _loanLiquidationOpen;
1128         emit LoanLiquidationOpenUpdated(loanLiquidationOpen);
1129     }
1130 
1131     function setLiquidationRatio(uint256 _liquidationRatio) external onlyOwner {
1132         require(_liquidationRatio > SafeDecimalMath.unit(), "Ratio less than 100%");
1133         liquidationRatio = _liquidationRatio;
1134         emit LiquidationRatioUpdated(liquidationRatio);
1135     }
1136 
1137     // ========== PUBLIC VIEWS ==========
1138 
1139     function getContractInfo()
1140         external
1141         view
1142         returns (
1143             uint256 _collateralizationRatio,
1144             uint256 _issuanceRatio,
1145             uint256 _interestRate,
1146             uint256 _interestPerSecond,
1147             uint256 _issueFeeRate,
1148             uint256 _issueLimit,
1149             uint256 _minLoanCollateralSize,
1150             uint256 _totalIssuedSynths,
1151             uint256 _totalLoansCreated,
1152             uint256 _totalOpenLoanCount,
1153             uint256 _ethBalance,
1154             uint256 _liquidationDeadline,
1155             bool _loanLiquidationOpen
1156         )
1157     {
1158         _collateralizationRatio = collateralizationRatio;
1159         _issuanceRatio = issuanceRatio();
1160         _interestRate = interestRate;
1161         _interestPerSecond = interestPerSecond;
1162         _issueFeeRate = issueFeeRate;
1163         _issueLimit = issueLimit;
1164         _minLoanCollateralSize = minLoanCollateralSize;
1165         _totalIssuedSynths = totalIssuedSynths;
1166         _totalLoansCreated = totalLoansCreated;
1167         _totalOpenLoanCount = totalOpenLoanCount;
1168         _ethBalance = address(this).balance;
1169         _liquidationDeadline = liquidationDeadline;
1170         _loanLiquidationOpen = loanLiquidationOpen;
1171     }
1172 
1173     // returns value of 100 / collateralizationRatio.
1174     // e.g. 100/150 = 0.6666666667
1175     function issuanceRatio() public view returns (uint256) {
1176         // this rounds so you get slightly more rather than slightly less
1177         return ONE_HUNDRED.divideDecimalRound(collateralizationRatio);
1178     }
1179 
1180     function loanAmountFromCollateral(uint256 collateralAmount) public view returns (uint256) {
1181         // a fraction more is issued due to rounding
1182         return collateralAmount.multiplyDecimal(issuanceRatio()).multiplyDecimal(exchangeRates().rateForCurrency(ETH));
1183     }
1184 
1185     function collateralAmountForLoan(uint256 loanAmount) external view returns (uint256) {
1186         return
1187             loanAmount
1188                 .multiplyDecimal(collateralizationRatio.divideDecimalRound(exchangeRates().rateForCurrency(ETH)))
1189                 .divideDecimalRound(ONE_HUNDRED);
1190     }
1191 
1192     // compound accrued interest with remaining loanAmount * (now - lastTimestampInterestPaid)
1193     function currentInterestOnLoan(address _account, uint256 _loanID) external view returns (uint256) {
1194         // Get the loan from storage
1195         SynthLoanStruct memory synthLoan = _getLoanFromStorage(_account, _loanID);
1196         uint256 currentInterest = accruedInterestOnLoan(
1197             synthLoan.loanAmount.add(synthLoan.accruedInterest),
1198             _timeSinceInterestAccrual(synthLoan)
1199         );
1200         return synthLoan.accruedInterest.add(currentInterest);
1201     }
1202 
1203     function accruedInterestOnLoan(uint256 _loanAmount, uint256 _seconds) public view returns (uint256 interestAmount) {
1204         // Simple interest calculated per second
1205         // Interest = Principal * rate * time
1206         interestAmount = _loanAmount.multiplyDecimalRound(interestPerSecond.mul(_seconds));
1207     }
1208 
1209     function totalFeesOnLoan(address _account, uint256 _loanID)
1210         external
1211         view
1212         returns (uint256 interestAmount, uint256 mintingFee)
1213     {
1214         SynthLoanStruct memory synthLoan = _getLoanFromStorage(_account, _loanID);
1215         uint256 loanAmountWithAccruedInterest = synthLoan.loanAmount.add(synthLoan.accruedInterest);
1216         interestAmount = synthLoan.accruedInterest.add(
1217             accruedInterestOnLoan(loanAmountWithAccruedInterest, _timeSinceInterestAccrual(synthLoan))
1218         );
1219         mintingFee = synthLoan.mintingFee;
1220     }
1221 
1222     function getMintingFee(address _account, uint256 _loanID) external view returns (uint256) {
1223         // Get the loan from storage
1224         SynthLoanStruct memory synthLoan = _getLoanFromStorage(_account, _loanID);
1225         return synthLoan.mintingFee;
1226     }
1227 
1228     /**
1229      * r = target issuance ratio
1230      * D = debt balance
1231      * V = Collateral
1232      * P = liquidation penalty
1233      * Calculates amount of synths = (D - V * r) / (1 - (1 + P) * r)
1234      */
1235     function calculateAmountToLiquidate(uint debtBalance, uint collateral) public view returns (uint) {
1236         uint unit = SafeDecimalMath.unit();
1237         uint ratio = liquidationRatio;
1238 
1239         uint dividend = debtBalance.sub(collateral.divideDecimal(ratio));
1240         uint divisor = unit.sub(unit.add(liquidationPenalty).divideDecimal(ratio));
1241 
1242         return dividend.divideDecimal(divisor);
1243     }
1244 
1245     function openLoanIDsByAccount(address _account) external view returns (uint256[] memory) {
1246         SynthLoanStruct[] memory synthLoans = accountsSynthLoans[_account];
1247 
1248         uint256[] memory _openLoanIDs = new uint256[](synthLoans.length);
1249         uint256 _counter = 0;
1250 
1251         for (uint256 i = 0; i < synthLoans.length; i++) {
1252             if (synthLoans[i].timeClosed == 0) {
1253                 _openLoanIDs[_counter] = synthLoans[i].loanID;
1254                 _counter++;
1255             }
1256         }
1257         // Create the fixed size array to return
1258         uint256[] memory _result = new uint256[](_counter);
1259 
1260         // Copy loanIDs from dynamic array to fixed array
1261         for (uint256 j = 0; j < _counter; j++) {
1262             _result[j] = _openLoanIDs[j];
1263         }
1264         // Return an array with list of open Loan IDs
1265         return _result;
1266     }
1267 
1268     function getLoan(address _account, uint256 _loanID)
1269         external
1270         view
1271         returns (
1272             address account,
1273             uint256 collateralAmount,
1274             uint256 loanAmount,
1275             uint256 timeCreated,
1276             uint256 loanID,
1277             uint256 timeClosed,
1278             uint256 accruedInterest,
1279             uint256 totalFees
1280         )
1281     {
1282         SynthLoanStruct memory synthLoan = _getLoanFromStorage(_account, _loanID);
1283         account = synthLoan.account;
1284         collateralAmount = synthLoan.collateralAmount;
1285         loanAmount = synthLoan.loanAmount;
1286         timeCreated = synthLoan.timeCreated;
1287         loanID = synthLoan.loanID;
1288         timeClosed = synthLoan.timeClosed;
1289         accruedInterest = synthLoan.accruedInterest.add(
1290             accruedInterestOnLoan(synthLoan.loanAmount.add(synthLoan.accruedInterest), _timeSinceInterestAccrual(synthLoan))
1291         );
1292         totalFees = accruedInterest.add(synthLoan.mintingFee);
1293     }
1294 
1295     function getLoanCollateralRatio(address _account, uint256 _loanID) external view returns (uint256 loanCollateralRatio) {
1296         // Get the loan from storage
1297         SynthLoanStruct memory synthLoan = _getLoanFromStorage(_account, _loanID);
1298 
1299         (loanCollateralRatio, , ) = _loanCollateralRatio(synthLoan);
1300     }
1301 
1302     function _loanCollateralRatio(SynthLoanStruct memory _loan)
1303         internal
1304         view
1305         returns (
1306             uint256 loanCollateralRatio,
1307             uint256 collateralValue,
1308             uint256 interestAmount
1309         )
1310     {
1311         // Any interest accrued prior is rolled up into loan amount
1312         uint256 loanAmountWithAccruedInterest = _loan.loanAmount.add(_loan.accruedInterest);
1313 
1314         interestAmount = accruedInterestOnLoan(loanAmountWithAccruedInterest, _timeSinceInterestAccrual(_loan));
1315 
1316         collateralValue = _loan.collateralAmount.multiplyDecimal(exchangeRates().rateForCurrency(COLLATERAL));
1317 
1318         loanCollateralRatio = collateralValue.divideDecimal(loanAmountWithAccruedInterest.add(interestAmount));
1319     }
1320 
1321     function timeSinceInterestAccrualOnLoan(address _account, uint256 _loanID) external view returns (uint256) {
1322         // Get the loan from storage
1323         SynthLoanStruct memory synthLoan = _getLoanFromStorage(_account, _loanID);
1324 
1325         return _timeSinceInterestAccrual(synthLoan);
1326     }
1327 
1328     // ========== PUBLIC FUNCTIONS ==========
1329 
1330     function openLoan(uint256 _loanAmount)
1331         external
1332         payable
1333         notPaused
1334         nonReentrant
1335         ETHRateNotInvalid
1336         returns (uint256 loanID)
1337     {
1338         systemStatus().requireIssuanceActive();
1339 
1340         // Require ETH sent to be greater than minLoanCollateralSize
1341         require(
1342             msg.value >= minLoanCollateralSize,
1343             "Not enough ETH to create this loan. Please see the minLoanCollateralSize"
1344         );
1345 
1346         // Require loanLiquidationOpen to be false or we are in liquidation phase
1347         require(loanLiquidationOpen == false, "Loans are now being liquidated");
1348 
1349         // Each account is limited to creating 50 (accountLoanLimit) loans
1350         require(accountsSynthLoans[msg.sender].length < accountLoanLimit, "Each account is limited to 50 loans");
1351 
1352         // Calculate issuance amount based on issuance ratio
1353         uint256 maxLoanAmount = loanAmountFromCollateral(msg.value);
1354 
1355         // Require requested _loanAmount to be less than maxLoanAmount
1356         // Issuance ratio caps collateral to loan value at 150%
1357         require(_loanAmount <= maxLoanAmount, "Loan amount exceeds max borrowing power");
1358 
1359         uint256 mintingFee = _calculateMintingFee(_loanAmount);
1360         uint256 loanAmountMinusFee = _loanAmount.sub(mintingFee);
1361 
1362         // Require sUSD loan to mint does not exceed cap
1363         require(totalIssuedSynths.add(_loanAmount) <= issueLimit, "Loan Amount exceeds the supply cap.");
1364 
1365         // Get a Loan ID
1366         loanID = _incrementTotalLoansCounter();
1367 
1368         // Create Loan storage object
1369         SynthLoanStruct memory synthLoan = SynthLoanStruct({
1370             account: msg.sender,
1371             collateralAmount: msg.value,
1372             loanAmount: _loanAmount,
1373             mintingFee: mintingFee,
1374             timeCreated: block.timestamp,
1375             loanID: loanID,
1376             timeClosed: 0,
1377             loanInterestRate: interestRate,
1378             accruedInterest: 0,
1379             lastInterestAccrued: 0
1380         });
1381 
1382         // Fee distribution. Mint the sUSD fees into the FeePool and record fees paid
1383         if (mintingFee > 0) {
1384             synthsUSD().issue(FEE_ADDRESS, mintingFee);
1385             feePool().recordFeePaid(mintingFee);
1386         }
1387 
1388         // Record loan in mapping to account in an array of the accounts open loans
1389         accountsSynthLoans[msg.sender].push(synthLoan);
1390 
1391         // Increment totalIssuedSynths
1392         totalIssuedSynths = totalIssuedSynths.add(_loanAmount);
1393 
1394         // Issue the synth (less fee)
1395         synthsUSD().issue(msg.sender, loanAmountMinusFee);
1396 
1397         // Tell the Dapps a loan was created
1398         emit LoanCreated(msg.sender, loanID, _loanAmount);
1399     }
1400 
1401     function closeLoan(uint256 loanID) external nonReentrant ETHRateNotInvalid {
1402         _closeLoan(msg.sender, loanID, false);
1403     }
1404 
1405     // Add ETH collateral to an open loan
1406     function depositCollateral(address account, uint256 loanID) external payable notPaused {
1407         require(msg.value > 0, "Deposit amount must be greater than 0");
1408 
1409         systemStatus().requireIssuanceActive();
1410 
1411         // Require loanLiquidationOpen to be false or we are in liquidation phase
1412         require(loanLiquidationOpen == false, "Loans are now being liquidated");
1413 
1414         // Get the loan from storage
1415         SynthLoanStruct memory synthLoan = _getLoanFromStorage(account, loanID);
1416 
1417         // Check loan exists and is open
1418         _checkLoanIsOpen(synthLoan);
1419 
1420         uint256 totalCollateral = synthLoan.collateralAmount.add(msg.value);
1421 
1422         _updateLoanCollateral(synthLoan, totalCollateral);
1423 
1424         // Tell the Dapps collateral was added to loan
1425         emit CollateralDeposited(account, loanID, msg.value, totalCollateral);
1426     }
1427 
1428     // Withdraw ETH collateral from an open loan
1429     function withdrawCollateral(uint256 loanID, uint256 withdrawAmount) external notPaused nonReentrant ETHRateNotInvalid {
1430         require(withdrawAmount > 0, "Amount to withdraw must be greater than 0");
1431 
1432         systemStatus().requireIssuanceActive();
1433 
1434         // Require loanLiquidationOpen to be false or we are in liquidation phase
1435         require(loanLiquidationOpen == false, "Loans are now being liquidated");
1436 
1437         // Get the loan from storage
1438         SynthLoanStruct memory synthLoan = _getLoanFromStorage(msg.sender, loanID);
1439 
1440         // Check loan exists and is open
1441         _checkLoanIsOpen(synthLoan);
1442 
1443         uint256 collateralAfter = synthLoan.collateralAmount.sub(withdrawAmount);
1444 
1445         SynthLoanStruct memory loanAfter = _updateLoanCollateral(synthLoan, collateralAfter);
1446 
1447         // require collateral ratio after to be above the liquidation ratio
1448         (uint256 collateralRatioAfter, , ) = _loanCollateralRatio(loanAfter);
1449 
1450         require(collateralRatioAfter > liquidationRatio, "Collateral ratio below liquidation after withdraw");
1451 
1452         // transfer ETH to msg.sender
1453         msg.sender.transfer(withdrawAmount);
1454 
1455         // Tell the Dapps collateral was added to loan
1456         emit CollateralWithdrawn(msg.sender, loanID, withdrawAmount, loanAfter.collateralAmount);
1457     }
1458 
1459     function repayLoan(
1460         address _loanCreatorsAddress,
1461         uint256 _loanID,
1462         uint256 _repayAmount
1463     ) external ETHRateNotInvalid {
1464         systemStatus().requireSystemActive();
1465 
1466         // check msg.sender has sufficient sUSD to pay
1467         require(IERC20(address(synthsUSD())).balanceOf(msg.sender) >= _repayAmount, "Not enough sUSD balance");
1468 
1469         SynthLoanStruct memory synthLoan = _getLoanFromStorage(_loanCreatorsAddress, _loanID);
1470 
1471         // Check loan exists and is open
1472         _checkLoanIsOpen(synthLoan);
1473 
1474         // Any interest accrued prior is rolled up into loan amount
1475         uint256 loanAmountWithAccruedInterest = synthLoan.loanAmount.add(synthLoan.accruedInterest);
1476         uint256 interestAmount = accruedInterestOnLoan(loanAmountWithAccruedInterest, _timeSinceInterestAccrual(synthLoan));
1477 
1478         // repay any accrued interests first
1479         // and repay principal loan amount with remaining amounts
1480         uint256 accruedInterest = synthLoan.accruedInterest.add(interestAmount);
1481 
1482         (
1483             uint256 interestPaid,
1484             uint256 loanAmountPaid,
1485             uint256 accruedInterestAfter,
1486             uint256 loanAmountAfter
1487         ) = _splitInterestLoanPayment(_repayAmount, accruedInterest, synthLoan.loanAmount);
1488 
1489         // burn sUSD from msg.sender for repaid amount
1490         synthsUSD().burn(msg.sender, _repayAmount);
1491 
1492         // Send interest paid to fee pool and record loan amount paid
1493         _processInterestAndLoanPayment(interestPaid, loanAmountPaid);
1494 
1495         // update loan with new total loan amount, record accrued interests
1496         _updateLoan(synthLoan, loanAmountAfter, accruedInterestAfter, block.timestamp);
1497 
1498         emit LoanRepaid(_loanCreatorsAddress, _loanID, _repayAmount, loanAmountAfter);
1499     }
1500 
1501     // Liquidate loans at or below issuance ratio
1502     function liquidateLoan(
1503         address _loanCreatorsAddress,
1504         uint256 _loanID,
1505         uint256 _debtToCover
1506     ) external nonReentrant ETHRateNotInvalid {
1507         systemStatus().requireSystemActive();
1508 
1509         // check msg.sender (liquidator's wallet) has sufficient sUSD
1510         require(IERC20(address(synthsUSD())).balanceOf(msg.sender) >= _debtToCover, "Not enough sUSD balance");
1511 
1512         SynthLoanStruct memory synthLoan = _getLoanFromStorage(_loanCreatorsAddress, _loanID);
1513 
1514         // Check loan exists and is open
1515         _checkLoanIsOpen(synthLoan);
1516 
1517         (uint256 collateralRatio, uint256 collateralValue, uint256 interestAmount) = _loanCollateralRatio(synthLoan);
1518 
1519         require(collateralRatio < liquidationRatio, "Collateral ratio above liquidation ratio");
1520 
1521         // calculate amount to liquidate to fix ratio including accrued interest
1522         uint256 liquidationAmount = calculateAmountToLiquidate(
1523             synthLoan.loanAmount.add(synthLoan.accruedInterest).add(interestAmount),
1524             collateralValue
1525         );
1526 
1527         // cap debt to liquidate
1528         uint256 amountToLiquidate = liquidationAmount < _debtToCover ? liquidationAmount : _debtToCover;
1529 
1530         // burn sUSD from msg.sender for amount to liquidate
1531         synthsUSD().burn(msg.sender, amountToLiquidate);
1532 
1533         (uint256 interestPaid, uint256 loanAmountPaid, uint256 accruedInterestAfter, ) = _splitInterestLoanPayment(
1534             amountToLiquidate,
1535             synthLoan.accruedInterest.add(interestAmount),
1536             synthLoan.loanAmount
1537         );
1538 
1539         // Send interests paid to fee pool and record loan amount paid
1540         _processInterestAndLoanPayment(interestPaid, loanAmountPaid);
1541 
1542         // Collateral value to redeem
1543         uint256 collateralRedeemed = exchangeRates().effectiveValue(sUSD, amountToLiquidate, COLLATERAL);
1544 
1545         // Add penalty
1546         uint256 totalCollateralLiquidated = collateralRedeemed.multiplyDecimal(
1547             SafeDecimalMath.unit().add(liquidationPenalty)
1548         );
1549 
1550         // update remaining loanAmount less amount paid and update accrued interests less interest paid
1551         _updateLoan(synthLoan, synthLoan.loanAmount.sub(loanAmountPaid), accruedInterestAfter, block.timestamp);
1552 
1553         // update remaining collateral on loan
1554         _updateLoanCollateral(synthLoan, synthLoan.collateralAmount.sub(totalCollateralLiquidated));
1555 
1556         // Send liquidated ETH collateral to msg.sender
1557         msg.sender.transfer(totalCollateralLiquidated);
1558 
1559         // emit loan liquidation event
1560         emit LoanPartiallyLiquidated(
1561             _loanCreatorsAddress,
1562             _loanID,
1563             msg.sender,
1564             amountToLiquidate,
1565             totalCollateralLiquidated
1566         );
1567     }
1568 
1569     function _splitInterestLoanPayment(
1570         uint256 _paymentAmount,
1571         uint256 _accruedInterest,
1572         uint256 _loanAmount
1573     )
1574         internal
1575         pure
1576         returns (
1577             uint256 interestPaid,
1578             uint256 loanAmountPaid,
1579             uint256 accruedInterestAfter,
1580             uint256 loanAmountAfter
1581         )
1582     {
1583         uint256 remainingPayment = _paymentAmount;
1584 
1585         // repay any accrued interests first
1586         accruedInterestAfter = _accruedInterest;
1587         if (remainingPayment > 0 && _accruedInterest > 0) {
1588             // Max repay is the accruedInterest amount
1589             interestPaid = remainingPayment > _accruedInterest ? _accruedInterest : remainingPayment;
1590             accruedInterestAfter = accruedInterestAfter.sub(interestPaid);
1591             remainingPayment = remainingPayment.sub(interestPaid);
1592         }
1593 
1594         // Remaining amounts - pay down loan amount
1595         loanAmountAfter = _loanAmount;
1596         if (remainingPayment > 0) {
1597             loanAmountAfter = loanAmountAfter.sub(remainingPayment);
1598             loanAmountPaid = remainingPayment;
1599         }
1600     }
1601 
1602     function _processInterestAndLoanPayment(uint256 interestPaid, uint256 loanAmountPaid) internal {
1603         // Fee distribution. Mint the sUSD fees into the FeePool and record fees paid
1604         if (interestPaid > 0) {
1605             synthsUSD().issue(FEE_ADDRESS, interestPaid);
1606             feePool().recordFeePaid(interestPaid);
1607         }
1608 
1609         // Decrement totalIssuedSynths
1610         if (loanAmountPaid > 0) {
1611             totalIssuedSynths = totalIssuedSynths.sub(loanAmountPaid);
1612         }
1613     }
1614 
1615     // Liquidation of an open loan available for anyone
1616     function liquidateUnclosedLoan(address _loanCreatorsAddress, uint256 _loanID) external nonReentrant ETHRateNotInvalid {
1617         require(loanLiquidationOpen, "Liquidation is not open");
1618         // Close the creators loan and send collateral to the closer.
1619         _closeLoan(_loanCreatorsAddress, _loanID, true);
1620         // Tell the Dapps this loan was liquidated
1621         emit LoanLiquidated(_loanCreatorsAddress, _loanID, msg.sender);
1622     }
1623 
1624     // ========== PRIVATE FUNCTIONS ==========
1625 
1626     function _closeLoan(
1627         address account,
1628         uint256 loanID,
1629         bool liquidation
1630     ) private {
1631         systemStatus().requireIssuanceActive();
1632 
1633         // Get the loan from storage
1634         SynthLoanStruct memory synthLoan = _getLoanFromStorage(account, loanID);
1635 
1636         // Check loan exists and is open
1637         _checkLoanIsOpen(synthLoan);
1638 
1639         // Calculate and deduct accrued interest (5%) for fee pool
1640         // Accrued interests (captured in loanAmount) + new interests
1641         uint256 interestAmount = accruedInterestOnLoan(
1642             synthLoan.loanAmount.add(synthLoan.accruedInterest),
1643             _timeSinceInterestAccrual(synthLoan)
1644         );
1645         uint256 repayAmount = synthLoan.loanAmount.add(interestAmount);
1646 
1647         uint256 totalAccruedInterest = synthLoan.accruedInterest.add(interestAmount);
1648 
1649         require(
1650             IERC20(address(synthsUSD())).balanceOf(msg.sender) >= repayAmount,
1651             "You do not have the required Synth balance to close this loan."
1652         );
1653 
1654         // Record loan as closed
1655         _recordLoanClosure(synthLoan);
1656 
1657         // Decrement totalIssuedSynths
1658         // subtract the accrued interest from the loanAmount
1659         totalIssuedSynths = totalIssuedSynths.sub(synthLoan.loanAmount.sub(synthLoan.accruedInterest));
1660 
1661         // Burn all Synths issued for the loan + the fees
1662         synthsUSD().burn(msg.sender, repayAmount);
1663 
1664         // Fee distribution. Mint the sUSD fees into the FeePool and record fees paid
1665         synthsUSD().issue(FEE_ADDRESS, totalAccruedInterest);
1666         feePool().recordFeePaid(totalAccruedInterest);
1667 
1668         uint256 remainingCollateral = synthLoan.collateralAmount;
1669 
1670         if (liquidation) {
1671             // Send liquidator redeemed collateral + 10% penalty
1672             uint256 collateralRedeemed = exchangeRates().effectiveValue(sUSD, repayAmount, COLLATERAL);
1673 
1674             // add penalty
1675             uint256 totalCollateralLiquidated = collateralRedeemed.multiplyDecimal(
1676                 SafeDecimalMath.unit().add(liquidationPenalty)
1677             );
1678 
1679             // ensure remaining ETH collateral sufficient to cover collateral liquidated
1680             // will revert if the liquidated collateral + penalty is more than remaining collateral
1681             remainingCollateral = remainingCollateral.sub(totalCollateralLiquidated);
1682 
1683             // Send liquidator CollateralLiquidated
1684             msg.sender.transfer(totalCollateralLiquidated);
1685         }
1686 
1687         // Send remaining collateral to loan creator
1688         synthLoan.account.transfer(remainingCollateral);
1689 
1690         // Tell the Dapps
1691         emit LoanClosed(account, loanID, totalAccruedInterest);
1692     }
1693 
1694     function _getLoanFromStorage(address account, uint256 loanID) private view returns (SynthLoanStruct memory) {
1695         SynthLoanStruct[] memory synthLoans = accountsSynthLoans[account];
1696         for (uint256 i = 0; i < synthLoans.length; i++) {
1697             if (synthLoans[i].loanID == loanID) {
1698                 return synthLoans[i];
1699             }
1700         }
1701     }
1702 
1703     function _updateLoan(
1704         SynthLoanStruct memory _synthLoan,
1705         uint256 _newLoanAmount,
1706         uint256 _newAccruedInterest,
1707         uint256 _lastInterestAccrued
1708     ) private {
1709         // Get storage pointer to the accounts array of loans
1710         SynthLoanStruct[] storage synthLoans = accountsSynthLoans[_synthLoan.account];
1711         for (uint256 i = 0; i < synthLoans.length; i++) {
1712             if (synthLoans[i].loanID == _synthLoan.loanID) {
1713                 synthLoans[i].loanAmount = _newLoanAmount;
1714                 synthLoans[i].accruedInterest = _newAccruedInterest;
1715                 synthLoans[i].lastInterestAccrued = uint40(_lastInterestAccrued);
1716             }
1717         }
1718     }
1719 
1720     function _updateLoanCollateral(SynthLoanStruct memory _synthLoan, uint256 _newCollateralAmount)
1721         private
1722         returns (SynthLoanStruct memory)
1723     {
1724         // Get storage pointer to the accounts array of loans
1725         SynthLoanStruct[] storage synthLoans = accountsSynthLoans[_synthLoan.account];
1726         for (uint256 i = 0; i < synthLoans.length; i++) {
1727             if (synthLoans[i].loanID == _synthLoan.loanID) {
1728                 synthLoans[i].collateralAmount = _newCollateralAmount;
1729                 return synthLoans[i];
1730             }
1731         }
1732     }
1733 
1734     function _recordLoanClosure(SynthLoanStruct memory synthLoan) private {
1735         // Get storage pointer to the accounts array of loans
1736         SynthLoanStruct[] storage synthLoans = accountsSynthLoans[synthLoan.account];
1737         for (uint256 i = 0; i < synthLoans.length; i++) {
1738             if (synthLoans[i].loanID == synthLoan.loanID) {
1739                 // Record the time the loan was closed
1740                 synthLoans[i].timeClosed = block.timestamp;
1741             }
1742         }
1743 
1744         // Reduce Total Open Loans Count
1745         totalOpenLoanCount = totalOpenLoanCount.sub(1);
1746     }
1747 
1748     function _incrementTotalLoansCounter() private returns (uint256) {
1749         // Increase the total Open loan count
1750         totalOpenLoanCount = totalOpenLoanCount.add(1);
1751         // Increase the total Loans Created count
1752         totalLoansCreated = totalLoansCreated.add(1);
1753         // Return total count to be used as a unique ID.
1754         return totalLoansCreated;
1755     }
1756 
1757     function _calculateMintingFee(uint256 _loanAmount) private view returns (uint256 mintingFee) {
1758         mintingFee = _loanAmount.multiplyDecimalRound(issueFeeRate);
1759     }
1760 
1761     function _timeSinceInterestAccrual(SynthLoanStruct memory _synthLoan) private view returns (uint256 timeSinceAccrual) {
1762         // The last interest accrued timestamp for the loan
1763         // If lastInterestAccrued timestamp is not set (0), use loan timeCreated
1764         uint256 lastInterestAccrual = _synthLoan.lastInterestAccrued > 0
1765             ? uint256(_synthLoan.lastInterestAccrued)
1766             : _synthLoan.timeCreated;
1767 
1768         // diff between last interested accrued and now
1769         // use loan's timeClosed if loan is closed
1770         timeSinceAccrual = _synthLoan.timeClosed > 0
1771             ? _synthLoan.timeClosed.sub(lastInterestAccrual)
1772             : block.timestamp.sub(lastInterestAccrual);
1773     }
1774 
1775     function _checkLoanIsOpen(SynthLoanStruct memory _synthLoan) internal pure {
1776         require(_synthLoan.loanID > 0, "Loan does not exist");
1777         require(_synthLoan.timeClosed == 0, "Loan already closed");
1778     }
1779 
1780     /* ========== INTERNAL VIEWS ========== */
1781 
1782     function systemStatus() internal view returns (ISystemStatus) {
1783         return ISystemStatus(requireAndGetAddress(CONTRACT_SYSTEMSTATUS, "Missing SystemStatus address"));
1784     }
1785 
1786     function synthsUSD() internal view returns (ISynth) {
1787         return ISynth(requireAndGetAddress(CONTRACT_SYNTHSUSD, "Missing SynthsUSD address"));
1788     }
1789 
1790     function exchangeRates() internal view returns (IExchangeRates) {
1791         return IExchangeRates(requireAndGetAddress(CONTRACT_EXRATES, "Missing ExchangeRates address"));
1792     }
1793 
1794     function feePool() internal view returns (IFeePool) {
1795         return IFeePool(requireAndGetAddress(CONTRACT_FEEPOOL, "Missing FeePool address"));
1796     }
1797 
1798     /* ========== MODIFIERS ========== */
1799 
1800     modifier ETHRateNotInvalid() {
1801         require(!exchangeRates().rateIsInvalid(COLLATERAL), "Blocked as ETH rate is invalid");
1802         _;
1803     }
1804 
1805     // ========== EVENTS ==========
1806 
1807     event CollateralizationRatioUpdated(uint256 ratio);
1808     event LiquidationRatioUpdated(uint256 ratio);
1809     event InterestRateUpdated(uint256 interestRate);
1810     event IssueFeeRateUpdated(uint256 issueFeeRate);
1811     event IssueLimitUpdated(uint256 issueLimit);
1812     event MinLoanCollateralSizeUpdated(uint256 minLoanCollateralSize);
1813     event AccountLoanLimitUpdated(uint256 loanLimit);
1814     event LoanLiquidationOpenUpdated(bool loanLiquidationOpen);
1815     event LoanCreated(address indexed account, uint256 loanID, uint256 amount);
1816     event LoanClosed(address indexed account, uint256 loanID, uint256 feesPaid);
1817     event LoanLiquidated(address indexed account, uint256 loanID, address liquidator);
1818     event LoanPartiallyLiquidated(
1819         address indexed account,
1820         uint256 loanID,
1821         address liquidator,
1822         uint256 liquidatedAmount,
1823         uint256 liquidatedCollateral
1824     );
1825     event CollateralDeposited(address indexed account, uint256 loanID, uint256 collateralAmount, uint256 collateralAfter);
1826     event CollateralWithdrawn(address indexed account, uint256 loanID, uint256 amountWithdrawn, uint256 collateralAfter);
1827     event LoanRepaid(address indexed account, uint256 loanID, uint256 repaidAmount, uint256 newLoanAmount);
1828 }
1829 
1830     