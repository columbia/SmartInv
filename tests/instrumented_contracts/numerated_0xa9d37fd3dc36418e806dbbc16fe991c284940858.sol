1 pragma solidity 0.4.24;
2 pragma experimental ABIEncoderV2;
3 // File: contracts/src/shared/interfaces/CollateralizerInterface.sol
4 
5 
6 
7 
8 contract CollateralizerInterface {
9 
10 	function unpackCollateralParametersFromBytes(
11 		bytes32 parameters
12 	) public pure returns (uint, uint, uint);
13 
14 }
15 
16 // File: contracts/src/shared/interfaces/DebtKernelInterface.sol
17 
18 
19 
20 contract DebtKernelInterface {
21 
22 	enum Errors {
23 		// Debt has been already been issued
24 		DEBT_ISSUED,
25 		// Order has already expired
26 		ORDER_EXPIRED,
27 		// Debt issuance associated with order has been cancelled
28 		ISSUANCE_CANCELLED,
29 		// Order has been cancelled
30 		ORDER_CANCELLED,
31 		// Order parameters specify amount of creditor / debtor fees
32 		// that is not equivalent to the amount of underwriter / relayer fees
33 		ORDER_INVALID_INSUFFICIENT_OR_EXCESSIVE_FEES,
34 		// Order parameters specify insufficient principal amount for
35 		// debtor to at least be able to meet his fees
36 		ORDER_INVALID_INSUFFICIENT_PRINCIPAL,
37 		// Order parameters specify non zero fee for an unspecified recipient
38 		ORDER_INVALID_UNSPECIFIED_FEE_RECIPIENT,
39 		// Order signatures are mismatched / malformed
40 		ORDER_INVALID_NON_CONSENSUAL,
41 		// Insufficient balance or allowance for principal token transfer
42 		CREDITOR_BALANCE_OR_ALLOWANCE_INSUFFICIENT
43 	}
44 
45 	// solhint-disable-next-line var-name-mixedcase
46 	address public TOKEN_TRANSFER_PROXY;
47 	bytes32 constant public NULL_ISSUANCE_HASH = bytes32(0);
48 
49 	/* NOTE(kayvon): Currently, the `view` keyword does not actually enforce the
50 	static nature of the method; this will change in the future, but for now, in
51 	order to prevent reentrancy we'll need to arbitrarily set an upper bound on
52 	the gas limit allotted for certain method calls. */
53 	uint16 constant public EXTERNAL_QUERY_GAS_LIMIT = 8000;
54 
55 	mapping (bytes32 => bool) public issuanceCancelled;
56 	mapping (bytes32 => bool) public debtOrderCancelled;
57 
58 	event LogDebtOrderFilled(
59 		bytes32 indexed _agreementId,
60 		uint _principal,
61 		address _principalToken,
62 		address indexed _underwriter,
63 		uint _underwriterFee,
64 		address indexed _relayer,
65 		uint _relayerFee
66 	);
67 
68 	event LogIssuanceCancelled(
69 		bytes32 indexed _agreementId,
70 		address indexed _cancelledBy
71 	);
72 
73 	event LogDebtOrderCancelled(
74 		bytes32 indexed _debtOrderHash,
75 		address indexed _cancelledBy
76 	);
77 
78 	event LogError(
79 		uint8 indexed _errorId,
80 		bytes32 indexed _orderHash
81 	);
82 
83 	struct Issuance {
84 		address version;
85 		address debtor;
86 		address underwriter;
87 		uint underwriterRiskRating;
88 		address termsContract;
89 		bytes32 termsContractParameters;
90 		uint salt;
91 		bytes32 agreementId;
92 	}
93 
94 	struct DebtOrder {
95 		Issuance issuance;
96 		uint underwriterFee;
97 		uint relayerFee;
98 		uint principalAmount;
99 		address principalToken;
100 		uint creditorFee;
101 		uint debtorFee;
102 		address relayer;
103 		uint expirationTimestampInSec;
104 		bytes32 debtOrderHash;
105 	}
106 
107     function fillDebtOrder(
108         address creditor,
109         address[6] orderAddresses,
110         uint[8] orderValues,
111         bytes32[1] orderBytes32,
112         uint8[3] signaturesV,
113         bytes32[3] signaturesR,
114         bytes32[3] signaturesS
115     )
116         public
117         returns (bytes32 _agreementId);
118 
119 }
120 
121 // File: contracts/src/shared/interfaces/DebtTokenInterface.sol
122 
123 
124 
125 contract DebtTokenInterface {
126 
127     function transfer(address _to, uint _tokenId) public;
128 
129     function exists(uint256 _tokenId) public view returns (bool);
130 
131 }
132 
133 // File: contracts/src/shared/interfaces/TokenTransferProxyInterface.sol
134 
135 
136 
137 contract TokenTransferProxyInterface {}
138 
139 // File: contracts/src/shared/interfaces/ContractRegistryInterface.sol
140 
141 
142 
143 
144 
145 
146 
147 contract ContractRegistryInterface {
148 
149     CollateralizerInterface public collateralizer;
150     DebtKernelInterface public debtKernel;
151     DebtTokenInterface public debtToken;
152     TokenTransferProxyInterface public tokenTransferProxy;
153 
154     function ContractRegistryInterface(
155         address _collateralizer,
156         address _debtKernel,
157         address _debtToken,
158         address _tokenTransferProxy
159     )
160         public
161     {
162         collateralizer = CollateralizerInterface(_collateralizer);
163         debtKernel = DebtKernelInterface(_debtKernel);
164         debtToken = DebtTokenInterface(_debtToken);
165         tokenTransferProxy = TokenTransferProxyInterface(_tokenTransferProxy);
166     }
167 
168 }
169 
170 // File: zeppelin-solidity/contracts/math/SafeMath.sol
171 
172 /**
173  * @title SafeMath
174  * @dev Math operations with safety checks that throw on error
175  */
176 library SafeMath {
177 
178   /**
179   * @dev Multiplies two numbers, throws on overflow.
180   */
181   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
182     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
183     // benefit is lost if 'b' is also tested.
184     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
185     if (_a == 0) {
186       return 0;
187     }
188 
189     c = _a * _b;
190     assert(c / _a == _b);
191     return c;
192   }
193 
194   /**
195   * @dev Integer division of two numbers, truncating the quotient.
196   */
197   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
198     // assert(_b > 0); // Solidity automatically throws when dividing by 0
199     // uint256 c = _a / _b;
200     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
201     return _a / _b;
202   }
203 
204   /**
205   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
206   */
207   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
208     assert(_b <= _a);
209     return _a - _b;
210   }
211 
212   /**
213   * @dev Adds two numbers, throws on overflow.
214   */
215   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
216     c = _a + _b;
217     assert(c >= _a);
218     return c;
219   }
220 }
221 
222 // File: contracts/src/shared/libraries/SignaturesLibrary.sol
223 
224 
225 
226 
227 contract SignaturesLibrary {
228 	bytes constant internal PREFIX = "\x19Ethereum Signed Message:\n32";
229 
230 	struct ECDSASignature {
231 		uint8 v;
232 		bytes32 r;
233 		bytes32 s;
234 	}
235 
236 	function isValidSignature(
237 		address signer,
238 		bytes32 hash,
239 		ECDSASignature signature
240 	)
241 		public
242 		pure
243 		returns (bool valid)
244 	{
245 		bytes32 prefixedHash = keccak256(PREFIX, hash);
246 		return ecrecover(prefixedHash, signature.v, signature.r, signature.s) == signer;
247 	}
248 }
249 
250 // File: contracts/src/shared/libraries/OrderLibrary.sol
251 
252 
253 
254 
255 contract OrderLibrary {
256 	struct DebtOrder {
257 		address kernelVersion;
258 		address issuanceVersion;
259 		uint principalAmount;
260 		address principalToken;
261 		uint collateralAmount;
262 		address collateralToken;
263 		address debtor;
264 		uint debtorFee;
265 		address creditor;
266 		uint creditorFee;
267 		address relayer;
268 		uint relayerFee;
269 		address underwriter;
270 		uint underwriterFee;
271 		uint underwriterRiskRating;
272 		address termsContract;
273 		bytes32 termsContractParameters;
274 		uint expirationTimestampInSec;
275 		uint salt;
276 		SignaturesLibrary.ECDSASignature debtorSignature;
277 		SignaturesLibrary.ECDSASignature creditorSignature;
278 		SignaturesLibrary.ECDSASignature underwriterSignature;
279 	}
280 
281 	function unpackDebtOrder(DebtOrder memory order)
282 		public
283 		pure
284 		returns (
285 	        address[6] orderAddresses,
286 	        uint[8] orderValues,
287 	        bytes32[1] orderBytes32,
288 	        uint8[3] signaturesV,
289 	        bytes32[3] signaturesR,
290 	        bytes32[3] signaturesS
291 		)
292 	{
293 		return (
294 			[order.issuanceVersion, order.debtor, order.underwriter, order.termsContract, order.principalToken, order.relayer],
295             [order.underwriterRiskRating, order.salt, order.principalAmount, order.underwriterFee, order.relayerFee, order.creditorFee, order.debtorFee, order.expirationTimestampInSec],
296 			[order.termsContractParameters],
297             [order.debtorSignature.v, order.creditorSignature.v, order.underwriterSignature.v],
298 			[order.debtorSignature.r, order.creditorSignature.r, order.underwriterSignature.r],
299 			[order.debtorSignature.s, order.creditorSignature.s, order.underwriterSignature.s]
300 		);
301 	}
302 }
303 
304 // File: contracts/src/CreditorDrivenLoans/DecisionEngines/libraries/LTVDecisionEngineTypes.sol
305 
306 
307 
308 
309 
310 
311 contract LTVDecisionEngineTypes
312 {
313 	// The parameters used during the consent and decision evaluations.
314 	struct Params {
315 		address creditor;
316 		// The values and signature for the creditor commitment hash.
317 		CreditorCommitment creditorCommitment;
318 		// Price feed data.
319 		Price principalPrice;
320 		Price collateralPrice;
321 		// A DebtOrderData is required to confirm parity with the submitted order.
322 		OrderLibrary.DebtOrder order;
323 	}
324 
325 	struct Price {
326 		uint value;
327 		uint timestamp;
328 		address tokenAddress;
329 		SignaturesLibrary.ECDSASignature signature;
330 	}
331 
332 	struct CreditorCommitment {
333 		CommitmentValues values;
334 		SignaturesLibrary.ECDSASignature signature;
335 	}
336 
337 	struct CommitmentValues {
338 		uint maxLTV;
339 		address priceFeedOperator;
340 	}
341 
342 	struct SimpleInterestParameters {
343 		uint principalTokenIndex;
344 		uint principalAmount;
345         uint interestRate;
346         uint amortizationUnitType;
347         uint termLengthInAmortizationUnits;
348 	}
349 
350 	struct CollateralParameters {
351 		uint collateralTokenIndex;
352 		uint collateralAmount;
353 		uint gracePeriodInDays;
354 	}
355 }
356 
357 // File: contracts/src/shared/interfaces/TermsContractInterface.sol
358 
359 
360 
361 
362 contract TermsContractInterface {
363 
364 	function registerTermStart(
365         bytes32 agreementId,
366         address debtor
367     ) public returns (bool _success);
368 
369 	function registerRepayment(
370         bytes32 agreementId,
371         address payer,
372         address beneficiary,
373         uint256 unitsOfRepayment,
374         address tokenAddress
375     ) public returns (bool _success);
376 
377 	function getExpectedRepaymentValue(
378         bytes32 agreementId,
379         uint256 timestamp
380     ) public view returns (uint256);
381 
382 	function getValueRepaidToDate(
383         bytes32 agreementId
384     ) public view returns (uint256);
385 
386 	function getTermEndTimestamp(
387         bytes32 _agreementId
388     ) public view returns (uint);
389 
390 }
391 
392 // File: contracts/src/shared/interfaces/SimpleInterestTermsContractInterface.sol
393 
394 
395 
396 
397 contract SimpleInterestTermsContractInterface is TermsContractInterface {
398 
399     function unpackParametersFromBytes(
400         bytes32 parameters
401     ) public pure returns (
402         uint _principalTokenIndex,
403         uint _principalAmount,
404         uint _interestRate,
405         uint _amortizationUnitType,
406         uint _termLengthInAmortizationUnits
407     );
408 
409 }
410 
411 // File: contracts/src/CreditorDrivenLoans/DecisionEngines/LTVDecisionEngine.sol
412 
413 
414 
415 // External dependencies
416 
417 
418 // Libraries
419 
420 
421 
422 
423 // Interfaces
424 
425 
426 
427 
428 contract LTVDecisionEngine is LTVDecisionEngineTypes, SignaturesLibrary, OrderLibrary
429 {
430 	using SafeMath for uint;
431 
432 	uint public constant PRECISION = 4;
433 
434 	uint public constant MAX_PRICE_TTL_IN_SECONDS = 600;
435 
436 	ContractRegistryInterface public contractRegistry;
437 
438 	function LTVDecisionEngine(address _contractRegistry) public {
439         contractRegistry = ContractRegistryInterface(_contractRegistry);
440     }
441 
442 	function evaluateConsent(Params params, bytes32 commitmentHash)
443 		public view returns (bool)
444 	{
445 		// Checks that the given creditor values were signed by the creditor.
446 		if (!isValidSignature(
447 			params.creditor,
448 			commitmentHash,
449 			params.creditorCommitment.signature
450 		)) {
451 			// We return early if the creditor values were not signed correctly.
452 			return false;
453 		}
454 
455 		// Checks that the given price feed data was signed by the price feed operator.
456 		return (
457 			verifyPrices(
458 				params.creditorCommitment.values.priceFeedOperator,
459 				params.principalPrice,
460 				params.collateralPrice
461 			)
462 		);
463 	}
464 
465 	// Returns true if the creditor-initiated order has not expired, and the LTV is below the max.
466 	function evaluateDecision(Params memory params)
467 		public view returns (bool _success)
468 	{
469 		LTVDecisionEngineTypes.Price memory principalTokenPrice = params.principalPrice;
470 		LTVDecisionEngineTypes.Price memory collateralTokenPrice = params.collateralPrice;
471 
472 		uint maxLTV = params.creditorCommitment.values.maxLTV;
473 		OrderLibrary.DebtOrder memory order = params.order;
474 
475 		uint collateralValue = collateralTokenPrice.value;
476 
477 		if (isExpired(order.expirationTimestampInSec)) {
478 			return false;
479 		}
480 
481 		if (order.collateralAmount == 0 || collateralValue == 0) {
482 			return false;
483 		}
484 
485 		uint ltv = computeLTV(
486 			principalTokenPrice.value,
487 			collateralTokenPrice.value,
488 			order.principalAmount,
489 			order.collateralAmount
490 		);
491 
492 		uint maxLTVWithPrecision = maxLTV.mul(10 ** (PRECISION.sub(2)));
493 
494 		return ltv <= maxLTVWithPrecision;
495 	}
496 
497 	function hashCreditorCommitmentForOrder(CommitmentValues commitmentValues, OrderLibrary.DebtOrder order)
498 	public view returns (bytes32)
499 	{
500 		bytes32 termsContractCommitmentHash =
501 			getTermsContractCommitmentHash(order.termsContract, order.termsContractParameters);
502 
503 		return keccak256(
504 			// order values
505 			order.creditor,
506 			order.kernelVersion,
507 			order.issuanceVersion,
508 			order.termsContract,
509 			order.principalToken,
510 			order.salt,
511 			order.principalAmount,
512 			order.creditorFee,
513 			order.expirationTimestampInSec,
514 			// commitment values
515 			commitmentValues.maxLTV,
516 			commitmentValues.priceFeedOperator,
517 			// hashed terms contract commitments
518 			termsContractCommitmentHash
519 		);
520 	}
521 
522 	function getTermsContractCommitmentHash(
523 		address termsContract,
524 		bytes32 termsContractParameters
525 	) public view returns (bytes32) {
526 		SimpleInterestParameters memory simpleInterestParameters =
527 			unpackSimpleInterestParameters(termsContract, termsContractParameters);
528 
529 		CollateralParameters memory collateralParameters =
530 			unpackCollateralParameters(termsContractParameters);
531 
532 		return keccak256(
533 			// unpacked termsContractParameters
534 			simpleInterestParameters.principalTokenIndex,
535 			simpleInterestParameters.principalAmount,
536 			simpleInterestParameters.interestRate,
537 			simpleInterestParameters.amortizationUnitType,
538 			simpleInterestParameters.termLengthInAmortizationUnits,
539 			collateralParameters.collateralTokenIndex,
540 			collateralParameters.gracePeriodInDays
541 		);
542 	}
543 
544 	function unpackSimpleInterestParameters(
545 		address termsContract,
546 		bytes32 termsContractParameters
547 	)
548 		public pure returns (SimpleInterestParameters)
549 	{
550 		// use simple interest terms contract interface to unpack simple interest terms
551 		SimpleInterestTermsContractInterface simpleInterestTermsContract = SimpleInterestTermsContractInterface(termsContract);
552 
553 		var (principalTokenIndex, principalAmount, interestRate, amortizationUnitType, termLengthInAmortizationUnits) =
554 			simpleInterestTermsContract.unpackParametersFromBytes(termsContractParameters);
555 
556 		return SimpleInterestParameters({
557 			principalTokenIndex: principalTokenIndex,
558 			principalAmount: principalAmount,
559 			interestRate: interestRate,
560 			amortizationUnitType: amortizationUnitType,
561 			termLengthInAmortizationUnits: termLengthInAmortizationUnits
562 		});
563 	}
564 
565 	function unpackCollateralParameters(
566 		bytes32 termsContractParameters
567 	)
568 		public view returns (CollateralParameters)
569 	{
570 		CollateralizerInterface collateralizer = CollateralizerInterface(contractRegistry.collateralizer());
571 
572 		var (collateralTokenIndex, collateralAmount, gracePeriodInDays) =
573 			collateralizer.unpackCollateralParametersFromBytes(termsContractParameters);
574 
575 		return CollateralParameters({
576 			collateralTokenIndex: collateralTokenIndex,
577 			collateralAmount: collateralAmount,
578 			gracePeriodInDays: gracePeriodInDays
579 		});
580 	}
581 
582 	function verifyPrices(
583 		address priceFeedOperator,
584 		LTVDecisionEngineTypes.Price principalPrice,
585 		LTVDecisionEngineTypes.Price collateralPrice
586 	)
587 		internal view returns (bool)
588 	{
589 		uint minPriceTimestamp = block.timestamp - MAX_PRICE_TTL_IN_SECONDS;
590 
591 		if (principalPrice.timestamp < minPriceTimestamp ||
592 			collateralPrice.timestamp < minPriceTimestamp) {
593 			return false;
594 		}
595 
596 		bytes32 principalPriceHash = keccak256(
597 			principalPrice.value,
598 			principalPrice.tokenAddress,
599 			principalPrice.timestamp
600 		);
601 
602 		bytes32 collateralPriceHash = keccak256(
603 			collateralPrice.value,
604 			collateralPrice.tokenAddress,
605 			collateralPrice.timestamp
606 		);
607 
608 		bool principalPriceValid = isValidSignature(
609 			priceFeedOperator,
610 			principalPriceHash,
611 			principalPrice.signature
612 		);
613 
614 		// We return early if the principal price information was not signed correctly.
615 		if (!principalPriceValid) {
616 			return false;
617 		}
618 
619 		return isValidSignature(
620 			priceFeedOperator,
621 			collateralPriceHash,
622 			collateralPrice.signature
623 		);
624 	}
625 
626 	function computeLTV(
627 		uint principalTokenPrice,
628 		uint collateralTokenPrice,
629 		uint principalAmount,
630 		uint collateralAmount
631 	)
632 		internal constant returns (uint)
633 	{
634 		uint principalValue = principalTokenPrice.mul(principalAmount).mul(10 ** PRECISION);
635 		uint collateralValue = collateralTokenPrice.mul(collateralAmount);
636 
637 		return principalValue.div(collateralValue);
638 	}
639 
640 	function isExpired(uint expirationTimestampInSec)
641 		internal view returns (bool expired)
642 	{
643 		return expirationTimestampInSec < block.timestamp;
644 	}
645 }
646 
647 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
648 
649 /**
650  * @title ERC20Basic
651  * @dev Simpler version of ERC20 interface
652  * See https://github.com/ethereum/EIPs/issues/179
653  */
654 contract ERC20Basic {
655   function totalSupply() public view returns (uint256);
656   function balanceOf(address _who) public view returns (uint256);
657   function transfer(address _to, uint256 _value) public returns (bool);
658   event Transfer(address indexed from, address indexed to, uint256 value);
659 }
660 
661 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
662 
663 /**
664  * @title ERC20 interface
665  * @dev see https://github.com/ethereum/EIPs/issues/20
666  */
667 contract ERC20 is ERC20Basic {
668   function allowance(address _owner, address _spender)
669     public view returns (uint256);
670 
671   function transferFrom(address _from, address _to, uint256 _value)
672     public returns (bool);
673 
674   function approve(address _spender, uint256 _value) public returns (bool);
675   event Approval(
676     address indexed owner,
677     address indexed spender,
678     uint256 value
679   );
680 }
681 
682 // File: contracts/src/CreditorDrivenLoans/libraries/CreditorProxyErrors.sol
683 
684 contract CreditorProxyErrors {
685     enum Errors {
686             DEBT_OFFER_CANCELLED,
687             DEBT_OFFER_ALREADY_FILLED,
688             DEBT_OFFER_NON_CONSENSUAL,
689             CREDITOR_BALANCE_OR_ALLOWANCE_INSUFFICIENT,
690             DEBT_OFFER_CRITERIA_NOT_MET
691         }
692 
693     event CreditorProxyError(
694         uint8 indexed _errorId,
695         address indexed _creditor,
696         bytes32 indexed _creditorCommitmentHash
697     );
698 }
699 
700 // File: contracts/src/CreditorDrivenLoans/libraries/CreditorProxyEvents.sol
701 
702 
703 
704 contract CreditorProxyEvents {
705 
706     event DebtOfferCancelled(
707         address indexed _creditor,
708         bytes32 indexed _creditorCommitmentHash
709     );
710 
711     event DebtOfferFilled(
712         address indexed _creditor,
713         bytes32 indexed _creditorCommitmentHash,
714         bytes32 indexed _agreementId
715     );
716 }
717 
718 // File: contracts/src/CreditorDrivenLoans/interfaces/CreditorProxyCoreInterface.sol
719 
720 
721 
722 
723 
724 
725 contract CreditorProxyCoreInterface is CreditorProxyErrors, CreditorProxyEvents { }
726 
727 // File: contracts/src/CreditorDrivenLoans/CreditorProxyCore.sol
728 
729 
730 
731 // External libraries
732 
733 // Internal interfaces
734 
735 // Shared interfaces
736 
737 
738 
739 contract CreditorProxyCore is CreditorProxyCoreInterface {
740 
741 	uint16 constant public EXTERNAL_QUERY_GAS_LIMIT = 8000;
742 
743 	ContractRegistryInterface public contractRegistry;
744 
745 	/**
746 	 * Helper function for transferring a specified amount of tokens between two parties.
747 	 */
748 	function transferTokensFrom(
749 		address _token,
750 		address _from,
751 		address _to,
752 		uint _amount
753 	)
754 		internal
755 		returns (bool _success)
756 	{
757 		return ERC20(_token).transferFrom(_from, _to, _amount);
758 	}
759 
760 	/**
761      * Helper function for querying this contract's allowance for transferring the given token.
762      */
763 	function getAllowance(
764 		address token,
765 		address owner,
766 		address granter
767 	)
768 		internal
769 		view
770 	returns (uint _allowance)
771 	{
772 		// Limit gas to prevent reentrancy.
773 		return ERC20(token).allowance.gas(EXTERNAL_QUERY_GAS_LIMIT)(
774 			owner,
775 			granter
776 		);
777 	}
778 }
779 
780 // File: contracts/src/CreditorDrivenLoans/LTVCreditorProxy.sol
781 
782 
783 
784 // Internal interfaces
785 
786 // Internal mixins
787 
788 
789 
790 
791 contract LTVCreditorProxy is CreditorProxyCore, LTVDecisionEngine {
792 
793 	mapping (bytes32 => bool) public debtOfferCancelled;
794 	mapping (bytes32 => bool) public debtOfferFilled;
795 
796 	bytes32 constant internal NULL_ISSUANCE_HASH = bytes32(0);
797 
798 	function LTVCreditorProxy(address _contractRegistry) LTVDecisionEngine(_contractRegistry)
799 		public
800 	{
801 		contractRegistry = ContractRegistryInterface(_contractRegistry);
802 	}
803 
804 	function fillDebtOffer(LTVDecisionEngineTypes.Params params)
805 		public returns (bytes32 agreementId)
806 	{
807 		OrderLibrary.DebtOrder memory order = params.order;
808 		CommitmentValues memory commitmentValues = params.creditorCommitment.values;
809 
810 		bytes32 creditorCommitmentHash = hashCreditorCommitmentForOrder(commitmentValues, order);
811 
812 		if (!evaluateConsent(params, creditorCommitmentHash)) {
813 			emit CreditorProxyError(uint8(Errors.DEBT_OFFER_NON_CONSENSUAL), order.creditor, creditorCommitmentHash);
814 			return NULL_ISSUANCE_HASH;
815 		}
816 
817 		if (debtOfferFilled[creditorCommitmentHash]) {
818 			emit CreditorProxyError(uint8(Errors.DEBT_OFFER_ALREADY_FILLED), order.creditor, creditorCommitmentHash);
819 			return NULL_ISSUANCE_HASH;
820 		}
821 
822 		if (debtOfferCancelled[creditorCommitmentHash]) {
823 			emit CreditorProxyError(uint8(Errors.DEBT_OFFER_CANCELLED), order.creditor, creditorCommitmentHash);
824 			return NULL_ISSUANCE_HASH;
825 		}
826 
827 		if (!evaluateDecision(params)) {
828 			emit CreditorProxyError(
829 				uint8(Errors.DEBT_OFFER_CRITERIA_NOT_MET),
830 				order.creditor,
831 				creditorCommitmentHash
832 			);
833 			return NULL_ISSUANCE_HASH;
834 		}
835 
836 		address principalToken = order.principalToken;
837 
838 		// The allowance that the token transfer proxy has for this contract's tokens.
839 		uint tokenTransferAllowance = getAllowance(
840 			principalToken,
841 			address(this),
842 			contractRegistry.tokenTransferProxy()
843 		);
844 
845 		uint totalCreditorPayment = order.principalAmount.add(order.creditorFee);
846 
847 		// Ensure the token transfer proxy can transfer tokens from the creditor proxy
848 		if (tokenTransferAllowance < totalCreditorPayment) {
849 			require(setTokenTransferAllowance(principalToken, totalCreditorPayment));
850 		}
851 
852 		// Transfer principal from creditor to CreditorProxy
853 		if (totalCreditorPayment > 0) {
854 			require(
855 				transferTokensFrom(
856 					principalToken,
857 					order.creditor,
858 					address(this),
859 					totalCreditorPayment
860 				)
861 			);
862 		}
863 
864 		agreementId = sendOrderToKernel(order);
865 
866 		require(agreementId != NULL_ISSUANCE_HASH);
867 
868 		debtOfferFilled[creditorCommitmentHash] = true;
869 
870 		contractRegistry.debtToken().transfer(order.creditor, uint256(agreementId));
871 
872 		emit DebtOfferFilled(order.creditor, creditorCommitmentHash, agreementId);
873 
874 		return agreementId;
875 	}
876 
877 	function sendOrderToKernel(DebtOrder memory order) internal returns (bytes32 id)
878 	{
879 		address[6] memory orderAddresses;
880 		uint[8] memory orderValues;
881 		bytes32[1] memory orderBytes32;
882 		uint8[3] memory signaturesV;
883 		bytes32[3] memory signaturesR;
884 		bytes32[3] memory signaturesS;
885 
886 		(orderAddresses, orderValues, orderBytes32, signaturesV, signaturesR, signaturesS) = unpackDebtOrder(order);
887 
888 		return contractRegistry.debtKernel().fillDebtOrder(
889 			address(this),
890 			orderAddresses,
891 			orderValues,
892 			orderBytes32,
893 			signaturesV,
894 			signaturesR,
895 			signaturesS
896 		);
897 	}
898 
899 	function cancelDebtOffer(LTVDecisionEngineTypes.Params params) public returns (bool) {
900 		LTVDecisionEngineTypes.CommitmentValues memory commitmentValues = params.creditorCommitment.values;
901 		OrderLibrary.DebtOrder memory order = params.order;
902 
903 		// sender must be the creditor.
904 		require(msg.sender == order.creditor);
905 
906 		bytes32 creditorCommitmentHash = hashCreditorCommitmentForOrder(commitmentValues, order);
907 
908 		// debt offer must not already be filled.
909 		require(!debtOfferFilled[creditorCommitmentHash]);
910 
911 		debtOfferCancelled[creditorCommitmentHash] = true;
912 
913 		emit DebtOfferCancelled(order.creditor, creditorCommitmentHash);
914 
915 		return true;
916 	}
917 
918 	/**
919      * Helper function for approving this address' allowance to Dharma's token transfer proxy.
920      */
921 	function setTokenTransferAllowance(
922 		address token,
923 		uint amount
924 	)
925 		internal
926 		returns (bool _success)
927 	{
928 		return ERC20(token).approve(
929 			address(contractRegistry.tokenTransferProxy()),
930 			amount
931 		);
932 	}
933 }