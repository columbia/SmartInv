1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 address constant CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS = 0x000000000000AAeB6D7670E522A718067333cd4E;
5 address constant CANONICAL_CORI_SUBSCRIPTION = 0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6;
6 
7 // File: https://github.com/ProjectOpenSea/operator-filter-registry/blob/main/src/IOperatorFilterRegistry.sol
8 
9 
10 interface IOperatorFilterRegistry {
11     /**
12      * @notice Returns true if operator is not filtered for a given token, either by address or codeHash. Also returns
13      *         true if supplied registrant address is not registered.
14      */
15     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
16 
17     /**
18      * @notice Registers an address with the registry. May be called by address itself or by EIP-173 owner.
19      */
20     function register(address registrant) external;
21 
22     /**
23      * @notice Registers an address with the registry and "subscribes" to another address's filtered operators and codeHashes.
24      */
25     function registerAndSubscribe(address registrant, address subscription) external;
26 
27     /**
28      * @notice Registers an address with the registry and copies the filtered operators and codeHashes from another
29      *         address without subscribing.
30      */
31     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
32 
33     /**
34      * @notice Unregisters an address with the registry and removes its subscription. May be called by address itself or by EIP-173 owner.
35      *         Note that this does not remove any filtered addresses or codeHashes.
36      *         Also note that any subscriptions to this registrant will still be active and follow the existing filtered addresses and codehashes.
37      */
38     function unregister(address addr) external;
39 
40     /**
41      * @notice Update an operator address for a registered address - when filtered is true, the operator is filtered.
42      */
43     function updateOperator(address registrant, address operator, bool filtered) external;
44 
45     /**
46      * @notice Update multiple operators for a registered address - when filtered is true, the operators will be filtered. Reverts on duplicates.
47      */
48     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
49 
50     /**
51      * @notice Update a codeHash for a registered address - when filtered is true, the codeHash is filtered.
52      */
53     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
54 
55     /**
56      * @notice Update multiple codeHashes for a registered address - when filtered is true, the codeHashes will be filtered. Reverts on duplicates.
57      */
58     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
59 
60     /**
61      * @notice Subscribe an address to another registrant's filtered operators and codeHashes. Will remove previous
62      *         subscription if present.
63      *         Note that accounts with subscriptions may go on to subscribe to other accounts - in this case,
64      *         subscriptions will not be forwarded. Instead the former subscription's existing entries will still be
65      *         used.
66      */
67     function subscribe(address registrant, address registrantToSubscribe) external;
68 
69     /**
70      * @notice Unsubscribe an address from its current subscribed registrant, and optionally copy its filtered operators and codeHashes.
71      */
72     function unsubscribe(address registrant, bool copyExistingEntries) external;
73 
74     /**
75      * @notice Get the subscription address of a given registrant, if any.
76      */
77     function subscriptionOf(address addr) external returns (address registrant);
78 
79     /**
80      * @notice Get the set of addresses subscribed to a given registrant.
81      *         Note that order is not guaranteed as updates are made.
82      */
83     function subscribers(address registrant) external returns (address[] memory);
84 
85     /**
86      * @notice Get the subscriber at a given index in the set of addresses subscribed to a given registrant.
87      *         Note that order is not guaranteed as updates are made.
88      */
89     function subscriberAt(address registrant, uint256 index) external returns (address);
90 
91     /**
92      * @notice Copy filtered operators and codeHashes from a different registrantToCopy to addr.
93      */
94     function copyEntriesOf(address registrant, address registrantToCopy) external;
95 
96     /**
97      * @notice Returns true if operator is filtered by a given address or its subscription.
98      */
99     function isOperatorFiltered(address registrant, address operator) external returns (bool);
100 
101     /**
102      * @notice Returns true if the hash of an address's code is filtered by a given address or its subscription.
103      */
104     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
105 
106     /**
107      * @notice Returns true if a codeHash is filtered by a given address or its subscription.
108      */
109     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
110 
111     /**
112      * @notice Returns a list of filtered operators for a given address or its subscription.
113      */
114     function filteredOperators(address addr) external returns (address[] memory);
115 
116     /**
117      * @notice Returns the set of filtered codeHashes for a given address or its subscription.
118      *         Note that order is not guaranteed as updates are made.
119      */
120     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
121 
122     /**
123      * @notice Returns the filtered operator at the given index of the set of filtered operators for a given address or
124      *         its subscription.
125      *         Note that order is not guaranteed as updates are made.
126      */
127     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
128 
129     /**
130      * @notice Returns the filtered codeHash at the given index of the list of filtered codeHashes for a given address or
131      *         its subscription.
132      *         Note that order is not guaranteed as updates are made.
133      */
134     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
135 
136     /**
137      * @notice Returns true if an address has registered
138      */
139     function isRegistered(address addr) external returns (bool);
140 
141     /**
142      * @dev Convenience method to compute the code hash of an arbitrary contract
143      */
144     function codeHashOf(address addr) external returns (bytes32);
145 }
146 
147 // File: https://github.com/ProjectOpenSea/operator-filter-registry/blob/main/src/OperatorFilterer.sol
148 
149 
150 pragma solidity ^0.8.13;
151 
152 
153 /**
154  * @title  OperatorFilterer
155  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
156  *         registrant's entries in the OperatorFilterRegistry.
157  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
158  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
159  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
160  *         Please note that if your token contract does not provide an owner with EIP-173, it must provide
161  *         administration methods on the contract itself to interact with the registry otherwise the subscription
162  *         will be locked to the options set during construction.
163  */
164 
165 abstract contract OperatorFilterer {
166     /// @dev Emitted when an operator is not allowed.
167     error OperatorNotAllowed(address operator);
168 
169     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
170         IOperatorFilterRegistry(CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS);
171 
172     /// @dev The constructor that is called when the contract is being deployed.
173     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
174         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
175         // will not revert, but the contract will need to be registered with the registry once it is deployed in
176         // order for the modifier to filter addresses.
177         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
178             if (subscribe) {
179                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
180             } else {
181                 if (subscriptionOrRegistrantToCopy != address(0)) {
182                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
183                 } else {
184                     OPERATOR_FILTER_REGISTRY.register(address(this));
185                 }
186             }
187         }
188     }
189 
190     /**
191      * @dev A helper function to check if an operator is allowed.
192      */
193     modifier onlyAllowedOperator(address from) virtual {
194         // Allow spending tokens from addresses with balance
195         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
196         // from an EOA.
197         if (from != msg.sender) {
198             _checkFilterOperator(msg.sender);
199         }
200         _;
201     }
202 
203     /**
204      * @dev A helper function to check if an operator approval is allowed.
205      */
206     modifier onlyAllowedOperatorApproval(address operator) virtual {
207         _checkFilterOperator(operator);
208         _;
209     }
210 
211     /**
212      * @dev A helper function to check if an operator is allowed.
213      */
214     function _checkFilterOperator(address operator) internal view virtual {
215         // Check registry code length to facilitate testing in environments without a deployed registry.
216         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
217             // under normal circumstances, this function will revert rather than return false, but inheriting contracts
218             // may specify their own OperatorFilterRegistry implementations, which may behave differently
219             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
220                 revert OperatorNotAllowed(operator);
221             }
222         }
223     }
224 }
225 
226 // File: https://github.com/ProjectOpenSea/operator-filter-registry/blob/main/src/DefaultOperatorFilterer.sol
227 
228 
229 pragma solidity ^0.8.13;
230 
231 
232 /**
233  * @title  DefaultOperatorFilterer
234  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
235  * @dev    Please note that if your token contract does not provide an owner with EIP-173, it must provide
236  *         administration methods on the contract itself to interact with the registry otherwise the subscription
237  *         will be locked to the options set during construction.
238  */
239 
240 abstract contract DefaultOperatorFilterer is OperatorFilterer {
241     /// @dev The constructor that is called when the contract is being deployed.
242     constructor() OperatorFilterer(CANONICAL_CORI_SUBSCRIPTION, true) {}
243 }
244 
245 // File: wagmidefenseDrop/utils/ReentrancyGuard.sol
246 
247 
248 pragma solidity >=0.8.0;
249 
250 /// @notice Gas optimized reentrancy protection for smart contracts.
251 /// @author Solmate (https://github.com/transmissions11/solmate/blob/main/src/utils/ReentrancyGuard.sol)
252 /// @author Modified from OpenZeppelin (https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/security/ReentrancyGuard.sol)
253 abstract contract ReentrancyGuard {
254     uint256 private locked = 1;
255 
256     modifier nonReentrant() virtual {
257         require(locked == 1, "REENTRANCY");
258 
259         locked = 2;
260 
261         _;
262 
263         locked = 1;
264     }
265 }
266 // File: wagmidefenseDrop/lib/SeaDropStructs.sol
267 
268 
269 pragma solidity 0.8.17;
270 
271 /**
272  * @notice A struct defining public drop data.
273  *         Designed to fit efficiently in one storage slot.
274  * 
275  * @param mintPrice                The mint price per token. (Up to 1.2m
276  *                                 of native token, e.g. ETH, MATIC)
277  * @param startTime                The start time, ensure this is not zero.
278  * @param endTIme                  The end time, ensure this is not zero.
279  * @param maxTotalMintableByWallet Maximum total number of mints a user is
280  *                                 allowed. (The limit for this field is
281  *                                 2^16 - 1)
282  * @param feeBps                   Fee out of 10_000 basis points to be
283  *                                 collected.
284  * @param restrictFeeRecipients    If false, allow any fee recipient;
285  *                                 if true, check fee recipient is allowed.
286  */
287 struct PublicDrop {
288     uint80 mintPrice; // 80/256 bits
289     uint48 startTime; // 128/256 bits
290     uint48 endTime; // 176/256 bits
291     uint16 maxTotalMintableByWallet; // 224/256 bits
292     uint16 feeBps; // 240/256 bits
293     bool restrictFeeRecipients; // 248/256 bits
294 }
295 
296 /**
297  * @notice A struct defining token gated drop stage data.
298  *         Designed to fit efficiently in one storage slot.
299  * 
300  * @param mintPrice                The mint price per token. (Up to 1.2m 
301  *                                 of native token, e.g.: ETH, MATIC)
302  * @param maxTotalMintableByWallet Maximum total number of mints a user is
303  *                                 allowed. (The limit for this field is
304  *                                 2^16 - 1)
305  * @param startTime                The start time, ensure this is not zero.
306  * @param endTime                  The end time, ensure this is not zero.
307  * @param dropStageIndex           The drop stage index to emit with the event
308  *                                 for analytical purposes. This should be 
309  *                                 non-zero since the public mint emits
310  *                                 with index zero.
311  * @param maxTokenSupplyForStage   The limit of token supply this stage can
312  *                                 mint within. (The limit for this field is
313  *                                 2^16 - 1)
314  * @param feeBps                   Fee out of 10_000 basis points to be
315  *                                 collected.
316  * @param restrictFeeRecipients    If false, allow any fee recipient;
317  *                                 if true, check fee recipient is allowed.
318  */
319 struct TokenGatedDropStage {
320     uint80 mintPrice; // 80/256 bits
321     uint16 maxTotalMintableByWallet; // 96/256 bits
322     uint48 startTime; // 144/256 bits
323     uint48 endTime; // 192/256 bits
324     uint8 dropStageIndex; // non-zero. 200/256 bits
325     uint32 maxTokenSupplyForStage; // 232/256 bits
326     uint16 feeBps; // 248/256 bits
327     bool restrictFeeRecipients; // 256/256 bits
328 }
329 
330 /**
331  * @notice A struct defining mint params for an allow list.
332  *         An allow list leaf will be composed of `msg.sender` and
333  *         the following params.
334  * 
335  *         Note: Since feeBps is encoded in the leaf, backend should ensure
336  *         that feeBps is acceptable before generating a proof.
337  * 
338  * @param mintPrice                The mint price per token.
339  * @param maxTotalMintableByWallet Maximum total number of mints a user is
340  *                                 allowed.
341  * @param startTime                The start time, ensure this is not zero.
342  * @param endTime                  The end time, ensure this is not zero.
343  * @param dropStageIndex           The drop stage index to emit with the event
344  *                                 for analytical purposes. This should be
345  *                                 non-zero since the public mint emits with
346  *                                 index zero.
347  * @param maxTokenSupplyForStage   The limit of token supply this stage can
348  *                                 mint within.
349  * @param feeBps                   Fee out of 10_000 basis points to be
350  *                                 collected.
351  * @param restrictFeeRecipients    If false, allow any fee recipient;
352  *                                 if true, check fee recipient is allowed.
353  */
354 struct MintParams {
355     uint256 mintPrice; 
356     uint256 maxTotalMintableByWallet;
357     uint256 startTime;
358     uint256 endTime;
359     uint256 dropStageIndex; // non-zero
360     uint256 maxTokenSupplyForStage;
361     uint256 feeBps;
362     bool restrictFeeRecipients;
363 }
364 
365 /**
366  * @notice A struct defining token gated mint params.
367  * 
368  * @param allowedNftToken    The allowed nft token contract address.
369  * @param allowedNftTokenIds The token ids to redeem.
370  */
371 struct TokenGatedMintParams {
372     address allowedNftToken;
373     uint256[] allowedNftTokenIds;
374 }
375 
376 /**
377  * @notice A struct defining allow list data (for minting an allow list).
378  * 
379  * @param merkleRoot    The merkle root for the allow list.
380  * @param publicKeyURIs If the allowListURI is encrypted, a list of URIs
381  *                      pointing to the public keys. Empty if unencrypted.
382  * @param allowListURI  The URI for the allow list.
383  */
384 struct AllowListData {
385     bytes32 merkleRoot;
386     string[] publicKeyURIs;
387     string allowListURI;
388 }
389 
390 /**
391  * @notice A struct defining minimum and maximum parameters to validate for 
392  *         signed mints, to minimize negative effects of a compromised signer.
393  *
394  * @param minMintPrice                The minimum mint price allowed.
395  * @param maxMaxTotalMintableByWallet The maximum total number of mints allowed
396  *                                    by a wallet.
397  * @param minStartTime                The minimum start time allowed.
398  * @param maxEndTime                  The maximum end time allowed.
399  * @param maxMaxTokenSupplyForStage   The maximum token supply allowed.
400  * @param minFeeBps                   The minimum fee allowed.
401  * @param maxFeeBps                   The maximum fee allowed.
402  */
403 struct SignedMintValidationParams {
404     uint80 minMintPrice; // 80/256 bits
405     uint24 maxMaxTotalMintableByWallet; // 104/256 bits
406     uint40 minStartTime; // 144/256 bits
407     uint40 maxEndTime; // 184/256 bits
408     uint40 maxMaxTokenSupplyForStage; // 224/256 bits
409     uint16 minFeeBps; // 240/256 bits
410     uint16 maxFeeBps; // 256/256 bits
411 }
412 // File: wagmidefenseDrop/lib/ERC721SeaDropStructsErrorsAndEvents.sol
413 
414 
415 
416 interface ERC721SeaDropStructsErrorsAndEvents {
417   /**
418    * @notice Revert with an error if mint exceeds the max supply.
419    */
420   error MintQuantityExceedsMaxSupply(uint256 total, uint256 maxSupply);
421 
422   /**
423    * @notice Revert with an error if the number of token gated 
424    *         allowedNftTokens doesn't match the length of supplied
425    *         drop stages.
426    */
427   error TokenGatedMismatch();
428 
429   /**
430    *  @notice Revert with an error if the number of signers doesn't match
431    *          the length of supplied signedMintValidationParams
432    */
433   error SignersMismatch();
434 
435   /**
436    * @notice An event to signify that a SeaDrop token contract was deployed.
437    */
438   event SeaDropTokenDeployed();
439 
440   /**
441    * @notice A struct to configure multiple contract options at a time.
442    */
443   struct MultiConfigureStruct {
444     uint256 maxSupply;
445     string baseURI;
446     string contractURI;
447     address seaDropImpl;
448     PublicDrop publicDrop;
449     string dropURI;
450     AllowListData allowListData;
451     address creatorPayoutAddress;
452     bytes32 provenanceHash;
453 
454     address[] allowedFeeRecipients;
455     address[] disallowedFeeRecipients;
456 
457     address[] allowedPayers;
458     address[] disallowedPayers;
459 
460     // Token-gated
461     address[] tokenGatedAllowedNftTokens;
462     TokenGatedDropStage[] tokenGatedDropStages;
463     address[] disallowedTokenGatedAllowedNftTokens;
464 
465     // Server-signed
466     address[] signers;
467     SignedMintValidationParams[] signedMintValidationParams;
468     address[] disallowedSigners;
469   }
470 }
471 // File: wagmidefenseDrop/lib/SeaDropErrorsAndEvents.sol
472 
473 
474 pragma solidity 0.8.17;
475 
476 
477 interface SeaDropErrorsAndEvents {
478     /**
479      * @dev Revert with an error if the drop stage is not active.
480      */
481     error NotActive(
482         uint256 currentTimestamp,
483         uint256 startTimestamp,
484         uint256 endTimestamp
485     );
486 
487     /**
488      * @dev Revert with an error if the mint quantity is zero.
489      */
490     error MintQuantityCannotBeZero();
491 
492     /**
493      * @dev Revert with an error if the mint quantity exceeds the max allowed
494      *      to be minted per wallet.
495      */
496     error MintQuantityExceedsMaxMintedPerWallet(uint256 total, uint256 allowed);
497 
498     /**
499      * @dev Revert with an error if the mint quantity exceeds the max token
500      *      supply.
501      */
502     error MintQuantityExceedsMaxSupply(uint256 total, uint256 maxSupply);
503 
504     /**
505      * @dev Revert with an error if the mint quantity exceeds the max token
506      *      supply for the stage.
507      *      Note: The `maxTokenSupplyForStage` for public mint is
508      *      always `type(uint).max`.
509      */
510     error MintQuantityExceedsMaxTokenSupplyForStage(
511         uint256 total, 
512         uint256 maxTokenSupplyForStage
513     );
514     
515     /**
516      * @dev Revert if the fee recipient is the zero address.
517      */
518     error FeeRecipientCannotBeZeroAddress();
519 
520     /**
521      * @dev Revert if the fee recipient is not already included.
522      */
523     error FeeRecipientNotPresent();
524 
525     /**
526      * @dev Revert if the fee basis points is greater than 10_000.
527      */
528     error InvalidFeeBps(uint256 feeBps);
529 
530     /**
531      * @dev Revert if the fee recipient is already included.
532      */
533     error DuplicateFeeRecipient();
534 
535     /**
536      * @dev Revert if the fee recipient is restricted and not allowed.
537      */
538     error FeeRecipientNotAllowed();
539 
540     /**
541      * @dev Revert if the creator payout address is the zero address.
542      */
543     error CreatorPayoutAddressCannotBeZeroAddress();
544 
545     /**
546      * @dev Revert with an error if the received payment is incorrect.
547      */
548     error IncorrectPayment(uint256 got, uint256 want);
549 
550     /**
551      * @dev Revert with an error if the allow list proof is invalid.
552      */
553     error InvalidProof();
554 
555     /**
556      * @dev Revert if a supplied signer address is the zero address.
557      */
558     error SignerCannotBeZeroAddress();
559 
560     /**
561      * @dev Revert with an error if signer's signature is invalid.
562      */
563     error InvalidSignature(address recoveredSigner);
564 
565     /**
566      * @dev Revert with an error if a signer is not included in
567      *      the enumeration when removing.
568      */
569     error SignerNotPresent();
570 
571     /**
572      * @dev Revert with an error if a payer is not included in
573      *      the enumeration when removing.
574      */
575     error PayerNotPresent();
576 
577     /**
578      * @dev Revert with an error if a payer is already included in mapping
579      *      when adding.
580      *      Note: only applies when adding a single payer, as duplicates in
581      *      enumeration can be removed with updatePayer.
582      */
583     error DuplicatePayer();
584 
585     /**
586      * @dev Revert with an error if the payer is not allowed. The minter must
587      *      pay for their own mint.
588      */
589     error PayerNotAllowed();
590 
591     /**
592      * @dev Revert if a supplied payer address is the zero address.
593      */
594     error PayerCannotBeZeroAddress();
595 
596     /**
597      * @dev Revert with an error if the sender does not
598      *      match the INonFungibleSeaDropToken interface.
599      */
600     error OnlyINonFungibleSeaDropToken(address sender);
601 
602     /**
603      * @dev Revert with an error if the sender of a token gated supplied
604      *      drop stage redeem is not the owner of the token.
605      */
606     error TokenGatedNotTokenOwner(
607         address nftContract,
608         address allowedNftToken,
609         uint256 allowedNftTokenId
610     );
611 
612     /**
613      * @dev Revert with an error if the token id has already been used to
614      *      redeem a token gated drop stage.
615      */
616     error TokenGatedTokenIdAlreadyRedeemed(
617         address nftContract,
618         address allowedNftToken,
619         uint256 allowedNftTokenId
620     );
621 
622     /**
623      * @dev Revert with an error if an empty TokenGatedDropStage is provided
624      *      for an already-empty TokenGatedDropStage.
625      */
626      error TokenGatedDropStageNotPresent();
627 
628     /**
629      * @dev Revert with an error if an allowedNftToken is set to
630      *      the zero address.
631      */
632      error TokenGatedDropAllowedNftTokenCannotBeZeroAddress();
633 
634     /**
635      * @dev Revert with an error if an allowedNftToken is set to
636      *      the drop token itself.
637      */
638      error TokenGatedDropAllowedNftTokenCannotBeDropToken();
639 
640 
641     /**
642      * @dev Revert with an error if supplied signed mint price is less than
643      *      the minimum specified.
644      */
645     error InvalidSignedMintPrice(uint256 got, uint256 minimum);
646 
647     /**
648      * @dev Revert with an error if supplied signed maxTotalMintableByWallet
649      *      is greater than the maximum specified.
650      */
651     error InvalidSignedMaxTotalMintableByWallet(uint256 got, uint256 maximum);
652 
653     /**
654      * @dev Revert with an error if supplied signed start time is less than
655      *      the minimum specified.
656      */
657     error InvalidSignedStartTime(uint256 got, uint256 minimum);
658     
659     /**
660      * @dev Revert with an error if supplied signed end time is greater than
661      *      the maximum specified.
662      */
663     error InvalidSignedEndTime(uint256 got, uint256 maximum);
664 
665     /**
666      * @dev Revert with an error if supplied signed maxTokenSupplyForStage
667      *      is greater than the maximum specified.
668      */
669      error InvalidSignedMaxTokenSupplyForStage(uint256 got, uint256 maximum);
670     
671      /**
672      * @dev Revert with an error if supplied signed feeBps is greater than
673      *      the maximum specified, or less than the minimum.
674      */
675     error InvalidSignedFeeBps(uint256 got, uint256 minimumOrMaximum);
676 
677     /**
678      * @dev Revert with an error if signed mint did not specify to restrict
679      *      fee recipients.
680      */
681     error SignedMintsMustRestrictFeeRecipients();
682 
683     /**
684      * @dev Revert with an error if a signature for a signed mint has already
685      *      been used.
686      */
687     error SignatureAlreadyUsed();
688 
689     /**
690      * @dev An event with details of a SeaDrop mint, for analytical purposes.
691      * 
692      * @param nftContract    The nft contract.
693      * @param minter         The mint recipient.
694      * @param feeRecipient   The fee recipient.
695      * @param payer          The address who payed for the tx.
696      * @param quantityMinted The number of tokens minted.
697      * @param unitMintPrice  The amount paid for each token.
698      * @param feeBps         The fee out of 10_000 basis points collected.
699      * @param dropStageIndex The drop stage index. Items minted
700      *                       through mintPublic() have
701      *                       dropStageIndex of 0.
702      */
703     event SeaDropMint(
704         address indexed nftContract,
705         address indexed minter,
706         address indexed feeRecipient,
707         address payer,
708         uint256 quantityMinted,
709         uint256 unitMintPrice,
710         uint256 feeBps,
711         uint256 dropStageIndex
712     );
713 
714     /**
715      * @dev An event with updated public drop data for an nft contract.
716      */
717     event PublicDropUpdated(
718         address indexed nftContract,
719         PublicDrop publicDrop
720     );
721 
722     /**
723      * @dev An event with updated token gated drop stage data
724      *      for an nft contract.
725      */
726     event TokenGatedDropStageUpdated(
727         address indexed nftContract,
728         address indexed allowedNftToken,
729         TokenGatedDropStage dropStage
730     );
731 
732     /**
733      * @dev An event with updated allow list data for an nft contract.
734      * 
735      * @param nftContract        The nft contract.
736      * @param previousMerkleRoot The previous allow list merkle root.
737      * @param newMerkleRoot      The new allow list merkle root.
738      * @param publicKeyURI       If the allow list is encrypted, the public key
739      *                           URIs that can decrypt the list.
740      *                           Empty if unencrypted.
741      * @param allowListURI       The URI for the allow list.
742      */
743     event AllowListUpdated(
744         address indexed nftContract,
745         bytes32 indexed previousMerkleRoot,
746         bytes32 indexed newMerkleRoot,
747         string[] publicKeyURI,
748         string allowListURI
749     );
750 
751     /**
752      * @dev An event with updated drop URI for an nft contract.
753      */
754     event DropURIUpdated(address indexed nftContract, string newDropURI);
755 
756     /**
757      * @dev An event with the updated creator payout address for an nft
758      *      contract.
759      */
760     event CreatorPayoutAddressUpdated(
761         address indexed nftContract,
762         address indexed newPayoutAddress
763     );
764 
765     /**
766      * @dev An event with the updated allowed fee recipient for an nft
767      *      contract.
768      */
769     event AllowedFeeRecipientUpdated(
770         address indexed nftContract,
771         address indexed feeRecipient,
772         bool indexed allowed
773     );
774 
775     /**
776      * @dev An event with the updated validation parameters for server-side
777      *      signers.
778      */
779     event SignedMintValidationParamsUpdated(
780         address indexed nftContract,
781         address indexed signer,
782         SignedMintValidationParams signedMintValidationParams
783     );   
784 
785     /**
786      * @dev An event with the updated payer for an nft contract.
787      */
788     event PayerUpdated(
789         address indexed nftContract,
790         address indexed payer,
791         bool indexed allowed
792     );
793 }
794 // File: wagmidefenseDrop/interfaces/ISeaDrop.sol
795 
796 
797 
798 interface ISeaDrop is SeaDropErrorsAndEvents {
799     /**
800      * @notice Mint a public drop.
801      *
802      * @param nftContract      The nft contract to mint.
803      * @param feeRecipient     The fee recipient.
804      * @param minterIfNotPayer The mint recipient if different than the payer.
805      * @param quantity         The number of tokens to mint.
806      */
807     function mintPublic(
808         address nftContract,
809         address feeRecipient,
810         address minterIfNotPayer,
811         uint256 quantity
812     ) external payable;
813 
814     /**
815      * @notice Mint from an allow list.
816      *
817      * @param nftContract      The nft contract to mint.
818      * @param feeRecipient     The fee recipient.
819      * @param minterIfNotPayer The mint recipient if different than the payer.
820      * @param quantity         The number of tokens to mint.
821      * @param mintParams       The mint parameters.
822      * @param proof            The proof for the leaf of the allow list.
823      */
824     function mintAllowList(
825         address nftContract,
826         address feeRecipient,
827         address minterIfNotPayer,
828         uint256 quantity,
829         MintParams calldata mintParams,
830         bytes32[] calldata proof
831     ) external payable;
832 
833     /**
834      * @notice Mint with a server-side signature.
835      *         Note that a signature can only be used once.
836      *
837      * @param nftContract      The nft contract to mint.
838      * @param feeRecipient     The fee recipient.
839      * @param minterIfNotPayer The mint recipient if different than the payer.
840      * @param quantity         The number of tokens to mint.
841      * @param mintParams       The mint parameters.
842      * @param salt             The sale for the signed mint.
843      * @param signature        The server-side signature, must be an allowed
844      *                         signer.
845      */
846     function mintSigned(
847         address nftContract,
848         address feeRecipient,
849         address minterIfNotPayer,
850         uint256 quantity,
851         MintParams calldata mintParams,
852         uint256 salt,
853         bytes calldata signature
854     ) external payable;
855 
856     /**
857      * @notice Mint as an allowed token holder.
858      *         This will mark the token id as redeemed and will revert if the
859      *         same token id is attempted to be redeemed twice.
860      *
861      * @param nftContract      The nft contract to mint.
862      * @param feeRecipient     The fee recipient.
863      * @param minterIfNotPayer The mint recipient if different than the payer.
864      * @param mintParams       The token gated mint params.
865      */
866     function mintAllowedTokenHolder(
867         address nftContract,
868         address feeRecipient,
869         address minterIfNotPayer,
870         TokenGatedMintParams calldata mintParams
871     ) external payable;
872 
873     /**
874      * @notice Emits an event to notify update of the drop URI.
875      *
876      *         This method assume msg.sender is an nft contract and its
877      *         ERC165 interface id matches INonFungibleSeaDropToken.
878      *
879      *         Note: Be sure only authorized users can call this from
880      *         token contracts that implement INonFungibleSeaDropToken.
881      *
882      * @param dropURI The new drop URI.
883      */
884     function updateDropURI(string calldata dropURI) external;
885 
886     /**
887      * @notice Updates the public drop data for the nft contract
888      *         and emits an event.
889      *
890      *         This method assume msg.sender is an nft contract and its
891      *         ERC165 interface id matches INonFungibleSeaDropToken.
892      *
893      *         Note: Be sure only authorized users can call this from
894      *         token contracts that implement INonFungibleSeaDropToken.
895      *
896      * @param publicDrop The public drop data.
897      */
898     function updatePublicDrop(PublicDrop calldata publicDrop) external;
899 
900     /**
901      * @notice Updates the allow list merkle root for the nft contract
902      *         and emits an event.
903      *
904      *         This method assume msg.sender is an nft contract and its
905      *         ERC165 interface id matches INonFungibleSeaDropToken.
906      *
907      *         Note: Be sure only authorized users can call this from
908      *         token contracts that implement INonFungibleSeaDropToken.
909      *
910      * @param allowListData The allow list data.
911      */
912     function updateAllowList(AllowListData calldata allowListData) external;
913 
914     /**
915      * @notice Updates the token gated drop stage for the nft contract
916      *         and emits an event.
917      *
918      *         This method assume msg.sender is an nft contract and its
919      *         ERC165 interface id matches INonFungibleSeaDropToken.
920      *
921      *         Note: Be sure only authorized users can call this from
922      *         token contracts that implement INonFungibleSeaDropToken.
923      *
924      *         Note: If two INonFungibleSeaDropToken tokens are doing
925      *         simultaneous token gated drop promotions for each other,
926      *         they can be minted by the same actor until
927      *         `maxTokenSupplyForStage` is reached. Please ensure the
928      *         `allowedNftToken` is not running an active drop during
929      *         the `dropStage` time period.
930      *
931      * @param allowedNftToken The token gated nft token.
932      * @param dropStage       The token gated drop stage data.
933      */
934     function updateTokenGatedDrop(
935         address allowedNftToken,
936         TokenGatedDropStage calldata dropStage
937     ) external;
938 
939     /**
940      * @notice Updates the creator payout address and emits an event.
941      *
942      *         This method assume msg.sender is an nft contract and its
943      *         ERC165 interface id matches INonFungibleSeaDropToken.
944      *
945      *         Note: Be sure only authorized users can call this from
946      *         token contracts that implement INonFungibleSeaDropToken.
947      *
948      * @param payoutAddress The creator payout address.
949      */
950     function updateCreatorPayoutAddress(address payoutAddress) external;
951 
952     /**
953      * @notice Updates the allowed fee recipient and emits an event.
954      *
955      *         This method assume msg.sender is an nft contract and its
956      *         ERC165 interface id matches INonFungibleSeaDropToken.
957      *
958      *         Note: Be sure only authorized users can call this from
959      *         token contracts that implement INonFungibleSeaDropToken.
960      *
961      * @param feeRecipient The fee recipient.
962      * @param allowed      If the fee recipient is allowed.
963      */
964     function updateAllowedFeeRecipient(address feeRecipient, bool allowed)
965         external;
966 
967     /**
968      * @notice Updates the allowed server-side signers and emits an event.
969      *
970      *         This method assume msg.sender is an nft contract and its
971      *         ERC165 interface id matches INonFungibleSeaDropToken.
972      *
973      *         Note: Be sure only authorized users can call this from
974      *         token contracts that implement INonFungibleSeaDropToken.
975      *
976      * @param signer                     The signer to update.
977      * @param signedMintValidationParams Minimum and maximum parameters
978      *                                   to enforce for signed mints.
979      */
980     function updateSignedMintValidationParams(
981         address signer,
982         SignedMintValidationParams calldata signedMintValidationParams
983     ) external;
984 
985     /**
986      * @notice Updates the allowed payer and emits an event.
987      *
988      *         This method assume msg.sender is an nft contract and its
989      *         ERC165 interface id matches INonFungibleSeaDropToken.
990      *
991      *         Note: Be sure only authorized users can call this from
992      *         token contracts that implement INonFungibleSeaDropToken.
993      *
994      * @param payer   The payer to add or remove.
995      * @param allowed Whether to add or remove the payer.
996      */
997     function updatePayer(address payer, bool allowed) external;
998 
999     /**
1000      * @notice Returns the public drop data for the nft contract.
1001      *
1002      * @param nftContract The nft contract.
1003      */
1004     function getPublicDrop(address nftContract)
1005         external
1006         view
1007         returns (PublicDrop memory);
1008 
1009     /**
1010      * @notice Returns the creator payout address for the nft contract.
1011      *
1012      * @param nftContract The nft contract.
1013      */
1014     function getCreatorPayoutAddress(address nftContract)
1015         external
1016         view
1017         returns (address);
1018 
1019     /**
1020      * @notice Returns the allow list merkle root for the nft contract.
1021      *
1022      * @param nftContract The nft contract.
1023      */
1024     function getAllowListMerkleRoot(address nftContract)
1025         external
1026         view
1027         returns (bytes32);
1028 
1029     /**
1030      * @notice Returns if the specified fee recipient is allowed
1031      *         for the nft contract.
1032      *
1033      * @param nftContract  The nft contract.
1034      * @param feeRecipient The fee recipient.
1035      */
1036     function getFeeRecipientIsAllowed(address nftContract, address feeRecipient)
1037         external
1038         view
1039         returns (bool);
1040 
1041     /**
1042      * @notice Returns an enumeration of allowed fee recipients for an
1043      *         nft contract when fee recipients are enforced
1044      *
1045      * @param nftContract The nft contract.
1046      */
1047     function getAllowedFeeRecipients(address nftContract)
1048         external
1049         view
1050         returns (address[] memory);
1051 
1052     /**
1053      * @notice Returns the server-side signers for the nft contract.
1054      *
1055      * @param nftContract The nft contract.
1056      */
1057     function getSigners(address nftContract)
1058         external
1059         view
1060         returns (address[] memory);
1061 
1062     /**
1063      * @notice Returns the struct of SignedMintValidationParams for a signer.
1064      *
1065      * @param nftContract The nft contract.
1066      * @param signer      The signer.
1067      */
1068     function getSignedMintValidationParams(address nftContract, address signer)
1069         external
1070         view
1071         returns (SignedMintValidationParams memory);
1072 
1073     /**
1074      * @notice Returns the payers for the nft contract.
1075      *
1076      * @param nftContract The nft contract.
1077      */
1078     function getPayers(address nftContract)
1079         external
1080         view
1081         returns (address[] memory);
1082 
1083     /**
1084      * @notice Returns if the specified payer is allowed
1085      *         for the nft contract.
1086      *
1087      * @param nftContract The nft contract.
1088      * @param payer       The payer.
1089      */
1090     function getPayerIsAllowed(address nftContract, address payer)
1091         external
1092         view
1093         returns (bool);
1094 
1095     /**
1096      * @notice Returns the allowed token gated drop tokens for the nft contract.
1097      *
1098      * @param nftContract The nft contract.
1099      */
1100     function getTokenGatedAllowedTokens(address nftContract)
1101         external
1102         view
1103         returns (address[] memory);
1104 
1105     /**
1106      * @notice Returns the token gated drop data for the nft contract
1107      *         and token gated nft.
1108      *
1109      * @param nftContract     The nft contract.
1110      * @param allowedNftToken The token gated nft token.
1111      */
1112     function getTokenGatedDrop(address nftContract, address allowedNftToken)
1113         external
1114         view
1115         returns (TokenGatedDropStage memory);
1116 
1117     /**
1118      * @notice Returns whether the token id for a token gated drop has been
1119      *         redeemed.
1120      *
1121      * @param nftContract       The nft contract.
1122      * @param allowedNftToken   The token gated nft token.
1123      * @param allowedNftTokenId The token gated nft token id to check.
1124      */
1125     function getAllowedNftTokenIdIsRedeemed(
1126         address nftContract,
1127         address allowedNftToken,
1128         uint256 allowedNftTokenId
1129     ) external view returns (bool);
1130 }
1131 // File: wagmidefenseDrop/utility-contracts/ConstructorInitializable.sol
1132 
1133 
1134 pragma solidity >=0.8.4;
1135 
1136 /**
1137  * @author emo.eth
1138  * @notice Abstract smart contract that provides an onlyUninitialized modifier which only allows calling when
1139  *         from within a constructor of some sort, whether directly instantiating an inherting contract,
1140  *         or when delegatecalling from a proxy
1141  */
1142 abstract contract ConstructorInitializable {
1143     error AlreadyInitialized();
1144 
1145     modifier onlyConstructor() {
1146         if (address(this).code.length != 0) {
1147             revert AlreadyInitialized();
1148         }
1149         _;
1150     }
1151 }
1152 // File: wagmidefenseDrop/utility-contracts/TwoStepOwnable.sol
1153 
1154 
1155 pragma solidity >=0.8.4;
1156 
1157 
1158 /**
1159 @notice A two-step extension of Ownable, where the new owner must claim ownership of the contract after owner initiates transfer
1160 Owner can cancel the transfer at any point before the new owner claims ownership.
1161 Helpful in guarding against transferring ownership to an address that is unable to act as the Owner.
1162 */
1163 abstract contract TwoStepOwnable is ConstructorInitializable {
1164     address private _owner;
1165 
1166     event OwnershipTransferred(
1167         address indexed previousOwner,
1168         address indexed newOwner
1169     );
1170 
1171     address internal potentialOwner;
1172 
1173     event PotentialOwnerUpdated(address newPotentialAdministrator);
1174 
1175     error NewOwnerIsZeroAddress();
1176     error NotNextOwner();
1177     error OnlyOwner();
1178 
1179     modifier onlyOwner() {
1180         _checkOwner();
1181         _;
1182     }
1183 
1184     constructor() {
1185         _initialize();
1186     }
1187 
1188     function _initialize() private onlyConstructor {
1189         _transferOwnership(msg.sender);
1190     }
1191 
1192     ///@notice Initiate ownership transfer to newPotentialOwner. Note: new owner will have to manually acceptOwnership
1193     ///@param newPotentialOwner address of potential new owner
1194     function transferOwnership(address newPotentialOwner)
1195         public
1196         virtual
1197         onlyOwner
1198     {
1199         if (newPotentialOwner == address(0)) {
1200             revert NewOwnerIsZeroAddress();
1201         }
1202         potentialOwner = newPotentialOwner;
1203         emit PotentialOwnerUpdated(newPotentialOwner);
1204     }
1205 
1206     ///@notice Claim ownership of smart contract, after the current owner has initiated the process with transferOwnership
1207     function acceptOwnership() public virtual {
1208         address _potentialOwner = potentialOwner;
1209         if (msg.sender != _potentialOwner) {
1210             revert NotNextOwner();
1211         }
1212         delete potentialOwner;
1213         emit PotentialOwnerUpdated(address(0));
1214         _transferOwnership(_potentialOwner);
1215     }
1216 
1217     ///@notice cancel ownership transfer
1218     function cancelOwnershipTransfer() public virtual onlyOwner {
1219         delete potentialOwner;
1220         emit PotentialOwnerUpdated(address(0));
1221     }
1222 
1223     function owner() public view virtual returns (address) {
1224         return _owner;
1225     }
1226 
1227     /**
1228      * @dev Throws if the sender is not the owner.
1229      */
1230     function _checkOwner() internal view virtual {
1231         if (_owner != msg.sender) {
1232             revert OnlyOwner();
1233         }
1234     }
1235 
1236     /**
1237      * @dev Leaves the contract without owner. It will not be possible to call
1238      * `onlyOwner` functions anymore. Can only be called by the current owner.
1239      *
1240      * NOTE: Renouncing ownership will leave the contract without an owner,
1241      * thereby removing any functionality that is only available to the owner.
1242      */
1243     function renounceOwnership() public virtual onlyOwner {
1244         _transferOwnership(address(0));
1245     }
1246 
1247     /**
1248      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1249      * Internal function without access restriction.
1250      */
1251     function _transferOwnership(address newOwner) internal virtual {
1252         address oldOwner = _owner;
1253         _owner = newOwner;
1254         emit OwnershipTransferred(oldOwner, newOwner);
1255     }
1256 }
1257 // File: wagmidefenseDrop/ERC721A/IERC721A.sol
1258 
1259 
1260 // ERC721A Contracts v4.2.2
1261 // Creator: Chiru Labs
1262 
1263 pragma solidity ^0.8.4;
1264 
1265 /**
1266  * @dev Interface of ERC721A.
1267  */
1268 interface IERC721A {
1269     /**
1270      * The caller must own the token or be an approved operator.
1271      */
1272     error ApprovalCallerNotOwnerNorApproved();
1273 
1274     /**
1275      * The token does not exist.
1276      */
1277     error ApprovalQueryForNonexistentToken();
1278 
1279     /**
1280      * Cannot query the balance for the zero address.
1281      */
1282     error BalanceQueryForZeroAddress();
1283 
1284     /**
1285      * Cannot mint to the zero address.
1286      */
1287     error MintToZeroAddress();
1288 
1289     /**
1290      * The quantity of tokens minted must be more than zero.
1291      */
1292     error MintZeroQuantity();
1293 
1294     /**
1295      * The token does not exist.
1296      */
1297     error OwnerQueryForNonexistentToken();
1298 
1299     /**
1300      * The caller must own the token or be an approved operator.
1301      */
1302     error TransferCallerNotOwnerNorApproved();
1303 
1304     /**
1305      * The token must be owned by `from`.
1306      */
1307     error TransferFromIncorrectOwner();
1308 
1309     /**
1310      * Cannot safely transfer to a contract that does not implement the
1311      * ERC721Receiver interface.
1312      */
1313     error TransferToNonERC721ReceiverImplementer();
1314 
1315     /**
1316      * Cannot transfer to the zero address.
1317      */
1318     error TransferToZeroAddress();
1319 
1320     /**
1321      * The token does not exist.
1322      */
1323     error URIQueryForNonexistentToken();
1324 
1325     /**
1326      * The `quantity` minted with ERC2309 exceeds the safety limit.
1327      */
1328     error MintERC2309QuantityExceedsLimit();
1329 
1330     /**
1331      * The `extraData` cannot be set on an unintialized ownership slot.
1332      */
1333     error OwnershipNotInitializedForExtraData();
1334 
1335     // =============================================================
1336     //                            STRUCTS
1337     // =============================================================
1338 
1339     struct TokenOwnership {
1340         // The address of the owner.
1341         address addr;
1342         // Stores the start time of ownership with minimal overhead for tokenomics.
1343         uint64 startTimestamp;
1344         // Whether the token has been burned.
1345         bool burned;
1346         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
1347         uint24 extraData;
1348     }
1349 
1350     // =============================================================
1351     //                         TOKEN COUNTERS
1352     // =============================================================
1353 
1354     /**
1355      * @dev Returns the total number of tokens in existence.
1356      * Burned tokens will reduce the count.
1357      * To get the total number of tokens minted, please see {_totalMinted}.
1358      */
1359     function totalSupply() external view returns (uint256);
1360 
1361     // =============================================================
1362     //                            IERC165
1363     // =============================================================
1364 
1365     /**
1366      * @dev Returns true if this contract implements the interface defined by
1367      * `interfaceId`. See the corresponding
1368      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1369      * to learn more about how these ids are created.
1370      *
1371      * This function call must use less than 30000 gas.
1372      */
1373     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1374 
1375     // =============================================================
1376     //                            IERC721
1377     // =============================================================
1378 
1379     /**
1380      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1381      */
1382     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1383 
1384     /**
1385      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1386      */
1387     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1388 
1389     /**
1390      * @dev Emitted when `owner` enables or disables
1391      * (`approved`) `operator` to manage all of its assets.
1392      */
1393     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1394 
1395     /**
1396      * @dev Returns the number of tokens in `owner`'s account.
1397      */
1398     function balanceOf(address owner) external view returns (uint256 balance);
1399 
1400     /**
1401      * @dev Returns the owner of the `tokenId` token.
1402      *
1403      * Requirements:
1404      *
1405      * - `tokenId` must exist.
1406      */
1407     function ownerOf(uint256 tokenId) external view returns (address owner);
1408 
1409     /**
1410      * @dev Safely transfers `tokenId` token from `from` to `to`,
1411      * checking first that contract recipients are aware of the ERC721 protocol
1412      * to prevent tokens from being forever locked.
1413      *
1414      * Requirements:
1415      *
1416      * - `from` cannot be the zero address.
1417      * - `to` cannot be the zero address.
1418      * - `tokenId` token must exist and be owned by `from`.
1419      * - If the caller is not `from`, it must be have been allowed to move
1420      * this token by either {approve} or {setApprovalForAll}.
1421      * - If `to` refers to a smart contract, it must implement
1422      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1423      *
1424      * Emits a {Transfer} event.
1425      */
1426     function safeTransferFrom(
1427         address from,
1428         address to,
1429         uint256 tokenId,
1430         bytes calldata data
1431     ) external;
1432 
1433     /**
1434      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1435      */
1436     function safeTransferFrom(
1437         address from,
1438         address to,
1439         uint256 tokenId
1440     ) external;
1441 
1442     /**
1443      * @dev Transfers `tokenId` from `from` to `to`.
1444      *
1445      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
1446      * whenever possible.
1447      *
1448      * Requirements:
1449      *
1450      * - `from` cannot be the zero address.
1451      * - `to` cannot be the zero address.
1452      * - `tokenId` token must be owned by `from`.
1453      * - If the caller is not `from`, it must be approved to move this token
1454      * by either {approve} or {setApprovalForAll}.
1455      *
1456      * Emits a {Transfer} event.
1457      */
1458     function transferFrom(
1459         address from,
1460         address to,
1461         uint256 tokenId
1462     ) external;
1463 
1464     /**
1465      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1466      * The approval is cleared when the token is transferred.
1467      *
1468      * Only a single account can be approved at a time, so approving the
1469      * zero address clears previous approvals.
1470      *
1471      * Requirements:
1472      *
1473      * - The caller must own the token or be an approved operator.
1474      * - `tokenId` must exist.
1475      *
1476      * Emits an {Approval} event.
1477      */
1478     function approve(address to, uint256 tokenId) external;
1479 
1480     /**
1481      * @dev Approve or remove `operator` as an operator for the caller.
1482      * Operators can call {transferFrom} or {safeTransferFrom}
1483      * for any token owned by the caller.
1484      *
1485      * Requirements:
1486      *
1487      * - The `operator` cannot be the caller.
1488      *
1489      * Emits an {ApprovalForAll} event.
1490      */
1491     function setApprovalForAll(address operator, bool _approved) external;
1492 
1493     /**
1494      * @dev Returns the account approved for `tokenId` token.
1495      *
1496      * Requirements:
1497      *
1498      * - `tokenId` must exist.
1499      */
1500     function getApproved(uint256 tokenId) external view returns (address operator);
1501 
1502     /**
1503      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1504      *
1505      * See {setApprovalForAll}.
1506      */
1507     function isApprovedForAll(address owner, address operator) external view returns (bool);
1508 
1509     // =============================================================
1510     //                        IERC721Metadata
1511     // =============================================================
1512 
1513     /**
1514      * @dev Returns the token collection name.
1515      */
1516     function name() external view returns (string memory);
1517 
1518     /**
1519      * @dev Returns the token collection symbol.
1520      */
1521     function symbol() external view returns (string memory);
1522 
1523     /**
1524      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1525      */
1526     function tokenURI(uint256 tokenId) external view returns (string memory);
1527 
1528     // =============================================================
1529     //                           IERC2309
1530     // =============================================================
1531 
1532     /**
1533      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
1534      * (inclusive) is transferred from `from` to `to`, as defined in the
1535      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
1536      *
1537      * See {_mintERC2309} for more details.
1538      */
1539     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
1540 }
1541 // File: wagmidefenseDrop/ERC721A/ERC721A.sol
1542 
1543 
1544 // ERC721A Contracts v4.2.2
1545 // Creator: Chiru Labs
1546 
1547 pragma solidity ^0.8.4;
1548 
1549 
1550 /**
1551  * @dev Interface of ERC721 token receiver.
1552  */
1553 interface ERC721A__IERC721Receiver {
1554     function onERC721Received(
1555         address operator,
1556         address from,
1557         uint256 tokenId,
1558         bytes calldata data
1559     ) external returns (bytes4);
1560 }
1561 
1562 /**
1563  * @title ERC721A
1564  *
1565  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
1566  * Non-Fungible Token Standard, including the Metadata extension.
1567  * Optimized for lower gas during batch mints.
1568  *
1569  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
1570  * starting from `_startTokenId()`.
1571  *
1572  * Assumptions:
1573  *
1574  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1575  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
1576  */
1577 contract ERC721A is IERC721A {
1578     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
1579     struct TokenApprovalRef {
1580         address value;
1581     }
1582 
1583     // =============================================================
1584     //                           CONSTANTS
1585     // =============================================================
1586 
1587     // Mask of an entry in packed address data.
1588     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1589 
1590     // The bit position of `numberMinted` in packed address data.
1591     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1592 
1593     // The bit position of `numberBurned` in packed address data.
1594     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1595 
1596     // The bit position of `aux` in packed address data.
1597     uint256 private constant _BITPOS_AUX = 192;
1598 
1599     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1600     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1601 
1602     // The bit position of `startTimestamp` in packed ownership.
1603     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1604 
1605     // The bit mask of the `burned` bit in packed ownership.
1606     uint256 private constant _BITMASK_BURNED = 1 << 224;
1607 
1608     // The bit position of the `nextInitialized` bit in packed ownership.
1609     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1610 
1611     // The bit mask of the `nextInitialized` bit in packed ownership.
1612     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1613 
1614     // The bit position of `extraData` in packed ownership.
1615     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1616 
1617     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1618     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1619 
1620     // The mask of the lower 160 bits for addresses.
1621     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1622 
1623     // The maximum `quantity` that can be minted with {_mintERC2309}.
1624     // This limit is to prevent overflows on the address data entries.
1625     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1626     // is required to cause an overflow, which is unrealistic.
1627     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1628 
1629     // The `Transfer` event signature is given by:
1630     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1631     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1632         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1633 
1634     // =============================================================
1635     //                            STORAGE
1636     // =============================================================
1637 
1638     // The next token ID to be minted.
1639     uint256 private _currentIndex;
1640 
1641     // The number of tokens burned.
1642     uint256 private _burnCounter;
1643 
1644     // Token name
1645     string private _name;
1646 
1647     // Token symbol
1648     string private _symbol;
1649 
1650     // Mapping from token ID to ownership details
1651     // An empty struct value does not necessarily mean the token is unowned.
1652     // See {_packedOwnershipOf} implementation for details.
1653     //
1654     // Bits Layout:
1655     // - [0..159]   `addr`
1656     // - [160..223] `startTimestamp`
1657     // - [224]      `burned`
1658     // - [225]      `nextInitialized`
1659     // - [232..255] `extraData`
1660     mapping(uint256 => uint256) private _packedOwnerships;
1661 
1662     // Mapping owner address to address data.
1663     //
1664     // Bits Layout:
1665     // - [0..63]    `balance`
1666     // - [64..127]  `numberMinted`
1667     // - [128..191] `numberBurned`
1668     // - [192..255] `aux`
1669     mapping(address => uint256) private _packedAddressData;
1670 
1671     // Mapping from token ID to approved address.
1672     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1673 
1674     // Mapping from owner to operator approvals
1675     mapping(address => mapping(address => bool)) private _operatorApprovals;
1676 
1677     // =============================================================
1678     //                          CONSTRUCTOR
1679     // =============================================================
1680 
1681     constructor(string memory name_, string memory symbol_) {
1682         _name = name_;
1683         _symbol = symbol_;
1684         _currentIndex = _startTokenId();
1685     }
1686 
1687     // =============================================================
1688     //                   TOKEN COUNTING OPERATIONS
1689     // =============================================================
1690 
1691     /**
1692      * @dev Returns the starting token ID.
1693      * To change the starting token ID, please override this function.
1694      */
1695     function _startTokenId() internal view virtual returns (uint256) {
1696         return 0;
1697     }
1698 
1699     /**
1700      * @dev Returns the next token ID to be minted.
1701      */
1702     function _nextTokenId() internal view virtual returns (uint256) {
1703         return _currentIndex;
1704     }
1705 
1706     /**
1707      * @dev Returns the total number of tokens in existence.
1708      * Burned tokens will reduce the count.
1709      * To get the total number of tokens minted, please see {_totalMinted}.
1710      */
1711     function totalSupply() public view virtual override returns (uint256) {
1712         // Counter underflow is impossible as _burnCounter cannot be incremented
1713         // more than `_currentIndex - _startTokenId()` times.
1714         unchecked {
1715             return _currentIndex - _burnCounter - _startTokenId();
1716         }
1717     }
1718 
1719     /**
1720      * @dev Returns the total amount of tokens minted in the contract.
1721      */
1722     function _totalMinted() internal view virtual returns (uint256) {
1723         // Counter underflow is impossible as `_currentIndex` does not decrement,
1724         // and it is initialized to `_startTokenId()`.
1725         unchecked {
1726             return _currentIndex - _startTokenId();
1727         }
1728     }
1729 
1730     /**
1731      * @dev Returns the total number of tokens burned.
1732      */
1733     function _totalBurned() internal view virtual returns (uint256) {
1734         return _burnCounter;
1735     }
1736 
1737     // =============================================================
1738     //                    ADDRESS DATA OPERATIONS
1739     // =============================================================
1740 
1741     /**
1742      * @dev Returns the number of tokens in `owner`'s account.
1743      */
1744     function balanceOf(address owner) public view virtual override returns (uint256) {
1745         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1746         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1747     }
1748 
1749     /**
1750      * Returns the number of tokens minted by `owner`.
1751      */
1752     function _numberMinted(address owner) internal view returns (uint256) {
1753         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1754     }
1755 
1756     /**
1757      * Returns the number of tokens burned by or on behalf of `owner`.
1758      */
1759     function _numberBurned(address owner) internal view returns (uint256) {
1760         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1761     }
1762 
1763     /**
1764      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1765      */
1766     function _getAux(address owner) internal view returns (uint64) {
1767         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1768     }
1769 
1770     /**
1771      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1772      * If there are multiple variables, please pack them into a uint64.
1773      */
1774     function _setAux(address owner, uint64 aux) internal virtual {
1775         uint256 packed = _packedAddressData[owner];
1776         uint256 auxCasted;
1777         // Cast `aux` with assembly to avoid redundant masking.
1778         assembly {
1779             auxCasted := aux
1780         }
1781         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1782         _packedAddressData[owner] = packed;
1783     }
1784 
1785     // =============================================================
1786     //                            IERC165
1787     // =============================================================
1788 
1789     /**
1790      * @dev Returns true if this contract implements the interface defined by
1791      * `interfaceId`. See the corresponding
1792      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1793      * to learn more about how these ids are created.
1794      *
1795      * This function call must use less than 30000 gas.
1796      */
1797     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1798         // The interface IDs are constants representing the first 4 bytes
1799         // of the XOR of all function selectors in the interface.
1800         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1801         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1802         return
1803             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1804             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1805             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1806     }
1807 
1808     // =============================================================
1809     //                        IERC721Metadata
1810     // =============================================================
1811 
1812     /**
1813      * @dev Returns the token collection name.
1814      */
1815     function name() public view virtual override returns (string memory) {
1816         return _name;
1817     }
1818 
1819     /**
1820      * @dev Returns the token collection symbol.
1821      */
1822     function symbol() public view virtual override returns (string memory) {
1823         return _symbol;
1824     }
1825 
1826     /**
1827      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1828      */
1829     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1830         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1831 
1832         string memory baseURI = _baseURI();
1833         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1834     }
1835 
1836     /**
1837      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1838      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1839      * by default, it can be overridden in child contracts.
1840      */
1841     function _baseURI() internal view virtual returns (string memory) {
1842         return '';
1843     }
1844 
1845     // =============================================================
1846     //                     OWNERSHIPS OPERATIONS
1847     // =============================================================
1848 
1849     /**
1850      * @dev Returns the owner of the `tokenId` token.
1851      *
1852      * Requirements:
1853      *
1854      * - `tokenId` must exist.
1855      */
1856     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1857         return address(uint160(_packedOwnershipOf(tokenId)));
1858     }
1859 
1860     /**
1861      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1862      * It gradually moves to O(1) as tokens get transferred around over time.
1863      */
1864     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1865         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1866     }
1867 
1868     /**
1869      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1870      */
1871     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1872         return _unpackedOwnership(_packedOwnerships[index]);
1873     }
1874 
1875     /**
1876      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1877      */
1878     function _initializeOwnershipAt(uint256 index) internal virtual {
1879         if (_packedOwnerships[index] == 0) {
1880             _packedOwnerships[index] = _packedOwnershipOf(index);
1881         }
1882     }
1883 
1884     /**
1885      * Returns the packed ownership data of `tokenId`.
1886      */
1887     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1888         uint256 curr = tokenId;
1889 
1890         unchecked {
1891             if (_startTokenId() <= curr)
1892                 if (curr < _currentIndex) {
1893                     uint256 packed = _packedOwnerships[curr];
1894                     // If not burned.
1895                     if (packed & _BITMASK_BURNED == 0) {
1896                         // Invariant:
1897                         // There will always be an initialized ownership slot
1898                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1899                         // before an unintialized ownership slot
1900                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1901                         // Hence, `curr` will not underflow.
1902                         //
1903                         // We can directly compare the packed value.
1904                         // If the address is zero, packed will be zero.
1905                         while (packed == 0) {
1906                             packed = _packedOwnerships[--curr];
1907                         }
1908                         return packed;
1909                     }
1910                 }
1911         }
1912         revert OwnerQueryForNonexistentToken();
1913     }
1914 
1915     /**
1916      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1917      */
1918     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1919         ownership.addr = address(uint160(packed));
1920         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1921         ownership.burned = packed & _BITMASK_BURNED != 0;
1922         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1923     }
1924 
1925     /**
1926      * @dev Packs ownership data into a single uint256.
1927      */
1928     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1929         assembly {
1930             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1931             owner := and(owner, _BITMASK_ADDRESS)
1932             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1933             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1934         }
1935     }
1936 
1937     /**
1938      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1939      */
1940     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1941         // For branchless setting of the `nextInitialized` flag.
1942         assembly {
1943             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1944             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1945         }
1946     }
1947 
1948     // =============================================================
1949     //                      APPROVAL OPERATIONS
1950     // =============================================================
1951 
1952     /**
1953      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1954      * The approval is cleared when the token is transferred.
1955      *
1956      * Only a single account can be approved at a time, so approving the
1957      * zero address clears previous approvals.
1958      *
1959      * Requirements:
1960      *
1961      * - The caller must own the token or be an approved operator.
1962      * - `tokenId` must exist.
1963      *
1964      * Emits an {Approval} event.
1965      */
1966     function approve(address to, uint256 tokenId) public virtual override {
1967         address owner = ownerOf(tokenId);
1968 
1969         if (_msgSenderERC721A() != owner)
1970             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1971                 revert ApprovalCallerNotOwnerNorApproved();
1972             }
1973 
1974         _tokenApprovals[tokenId].value = to;
1975         emit Approval(owner, to, tokenId);
1976     }
1977 
1978     /**
1979      * @dev Returns the account approved for `tokenId` token.
1980      *
1981      * Requirements:
1982      *
1983      * - `tokenId` must exist.
1984      */
1985     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1986         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1987 
1988         return _tokenApprovals[tokenId].value;
1989     }
1990 
1991     /**
1992      * @dev Approve or remove `operator` as an operator for the caller.
1993      * Operators can call {transferFrom} or {safeTransferFrom}
1994      * for any token owned by the caller.
1995      *
1996      * Requirements:
1997      *
1998      * - The `operator` cannot be the caller.
1999      *
2000      * Emits an {ApprovalForAll} event.
2001      */
2002     function setApprovalForAll(address operator, bool approved) public virtual override {
2003         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
2004         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
2005     }
2006 
2007     /**
2008      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
2009      *
2010      * See {setApprovalForAll}.
2011      */
2012     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
2013         return _operatorApprovals[owner][operator];
2014     }
2015 
2016     /**
2017      * @dev Returns whether `tokenId` exists.
2018      *
2019      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2020      *
2021      * Tokens start existing when they are minted. See {_mint}.
2022      */
2023     function _exists(uint256 tokenId) internal view virtual returns (bool) {
2024         return
2025             _startTokenId() <= tokenId &&
2026             tokenId < _currentIndex && // If within bounds,
2027             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
2028     }
2029 
2030     /**
2031      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
2032      */
2033     function _isSenderApprovedOrOwner(
2034         address approvedAddress,
2035         address owner,
2036         address msgSender
2037     ) private pure returns (bool result) {
2038         assembly {
2039             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
2040             owner := and(owner, _BITMASK_ADDRESS)
2041             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
2042             msgSender := and(msgSender, _BITMASK_ADDRESS)
2043             // `msgSender == owner || msgSender == approvedAddress`.
2044             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
2045         }
2046     }
2047 
2048     /**
2049      * @dev Returns the storage slot and value for the approved address of `tokenId`.
2050      */
2051     function _getApprovedSlotAndAddress(uint256 tokenId)
2052         private
2053         view
2054         returns (uint256 approvedAddressSlot, address approvedAddress)
2055     {
2056         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
2057         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
2058         assembly {
2059             approvedAddressSlot := tokenApproval.slot
2060             approvedAddress := sload(approvedAddressSlot)
2061         }
2062     }
2063 
2064     // =============================================================
2065     //                      TRANSFER OPERATIONS
2066     // =============================================================
2067 
2068     /**
2069      * @dev Transfers `tokenId` from `from` to `to`.
2070      *
2071      * Requirements:
2072      *
2073      * - `from` cannot be the zero address.
2074      * - `to` cannot be the zero address.
2075      * - `tokenId` token must be owned by `from`.
2076      * - If the caller is not `from`, it must be approved to move this token
2077      * by either {approve} or {setApprovalForAll}.
2078      *
2079      * Emits a {Transfer} event.
2080      */
2081     function transferFrom(
2082         address from,
2083         address to,
2084         uint256 tokenId
2085     ) public virtual override {
2086         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2087 
2088         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
2089 
2090         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2091 
2092         // The nested ifs save around 20+ gas over a compound boolean condition.
2093         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2094             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2095 
2096         if (to == address(0)) revert TransferToZeroAddress();
2097 
2098         _beforeTokenTransfers(from, to, tokenId, 1);
2099 
2100         // Clear approvals from the previous owner.
2101         assembly {
2102             if approvedAddress {
2103                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2104                 sstore(approvedAddressSlot, 0)
2105             }
2106         }
2107 
2108         // Underflow of the sender's balance is impossible because we check for
2109         // ownership above and the recipient's balance can't realistically overflow.
2110         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2111         unchecked {
2112             // We can directly increment and decrement the balances.
2113             --_packedAddressData[from]; // Updates: `balance -= 1`.
2114             ++_packedAddressData[to]; // Updates: `balance += 1`.
2115 
2116             // Updates:
2117             // - `address` to the next owner.
2118             // - `startTimestamp` to the timestamp of transfering.
2119             // - `burned` to `false`.
2120             // - `nextInitialized` to `true`.
2121             _packedOwnerships[tokenId] = _packOwnershipData(
2122                 to,
2123                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
2124             );
2125 
2126             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2127             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2128                 uint256 nextTokenId = tokenId + 1;
2129                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2130                 if (_packedOwnerships[nextTokenId] == 0) {
2131                     // If the next slot is within bounds.
2132                     if (nextTokenId != _currentIndex) {
2133                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2134                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2135                     }
2136                 }
2137             }
2138         }
2139 
2140         emit Transfer(from, to, tokenId);
2141         _afterTokenTransfers(from, to, tokenId, 1);
2142     }
2143 
2144     /**
2145      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
2146      */
2147     function safeTransferFrom(
2148         address from,
2149         address to,
2150         uint256 tokenId
2151     ) public virtual override {
2152         safeTransferFrom(from, to, tokenId, '');
2153     }
2154 
2155     /**
2156      * @dev Safely transfers `tokenId` token from `from` to `to`.
2157      *
2158      * Requirements:
2159      *
2160      * - `from` cannot be the zero address.
2161      * - `to` cannot be the zero address.
2162      * - `tokenId` token must exist and be owned by `from`.
2163      * - If the caller is not `from`, it must be approved to move this token
2164      * by either {approve} or {setApprovalForAll}.
2165      * - If `to` refers to a smart contract, it must implement
2166      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2167      *
2168      * Emits a {Transfer} event.
2169      */
2170     function safeTransferFrom(
2171         address from,
2172         address to,
2173         uint256 tokenId,
2174         bytes memory _data
2175     ) public virtual override {
2176         transferFrom(from, to, tokenId);
2177         if (to.code.length != 0)
2178             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
2179                 revert TransferToNonERC721ReceiverImplementer();
2180             }
2181     }
2182 
2183     /**
2184      * @dev Hook that is called before a set of serially-ordered token IDs
2185      * are about to be transferred. This includes minting.
2186      * And also called before burning one token.
2187      *
2188      * `startTokenId` - the first token ID to be transferred.
2189      * `quantity` - the amount to be transferred.
2190      *
2191      * Calling conditions:
2192      *
2193      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2194      * transferred to `to`.
2195      * - When `from` is zero, `tokenId` will be minted for `to`.
2196      * - When `to` is zero, `tokenId` will be burned by `from`.
2197      * - `from` and `to` are never both zero.
2198      */
2199     function _beforeTokenTransfers(
2200         address from,
2201         address to,
2202         uint256 startTokenId,
2203         uint256 quantity
2204     ) internal virtual {}
2205 
2206     /**
2207      * @dev Hook that is called after a set of serially-ordered token IDs
2208      * have been transferred. This includes minting.
2209      * And also called after one token has been burned.
2210      *
2211      * `startTokenId` - the first token ID to be transferred.
2212      * `quantity` - the amount to be transferred.
2213      *
2214      * Calling conditions:
2215      *
2216      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
2217      * transferred to `to`.
2218      * - When `from` is zero, `tokenId` has been minted for `to`.
2219      * - When `to` is zero, `tokenId` has been burned by `from`.
2220      * - `from` and `to` are never both zero.
2221      */
2222     function _afterTokenTransfers(
2223         address from,
2224         address to,
2225         uint256 startTokenId,
2226         uint256 quantity
2227     ) internal virtual {}
2228 
2229     /**
2230      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
2231      *
2232      * `from` - Previous owner of the given token ID.
2233      * `to` - Target address that will receive the token.
2234      * `tokenId` - Token ID to be transferred.
2235      * `_data` - Optional data to send along with the call.
2236      *
2237      * Returns whether the call correctly returned the expected magic value.
2238      */
2239     function _checkContractOnERC721Received(
2240         address from,
2241         address to,
2242         uint256 tokenId,
2243         bytes memory _data
2244     ) private returns (bool) {
2245         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
2246             bytes4 retval
2247         ) {
2248             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
2249         } catch (bytes memory reason) {
2250             if (reason.length == 0) {
2251                 revert TransferToNonERC721ReceiverImplementer();
2252             } else {
2253                 assembly {
2254                     revert(add(32, reason), mload(reason))
2255                 }
2256             }
2257         }
2258     }
2259 
2260     // =============================================================
2261     //                        MINT OPERATIONS
2262     // =============================================================
2263 
2264     /**
2265      * @dev Mints `quantity` tokens and transfers them to `to`.
2266      *
2267      * Requirements:
2268      *
2269      * - `to` cannot be the zero address.
2270      * - `quantity` must be greater than 0.
2271      *
2272      * Emits a {Transfer} event for each mint.
2273      */
2274     function _mint(address to, uint256 quantity) internal virtual {
2275         uint256 startTokenId = _currentIndex;
2276         if (quantity == 0) revert MintZeroQuantity();
2277 
2278         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2279 
2280         // Overflows are incredibly unrealistic.
2281         // `balance` and `numberMinted` have a maximum limit of 2**64.
2282         // `tokenId` has a maximum limit of 2**256.
2283         unchecked {
2284             // Updates:
2285             // - `balance += quantity`.
2286             // - `numberMinted += quantity`.
2287             //
2288             // We can directly add to the `balance` and `numberMinted`.
2289             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2290 
2291             // Updates:
2292             // - `address` to the owner.
2293             // - `startTimestamp` to the timestamp of minting.
2294             // - `burned` to `false`.
2295             // - `nextInitialized` to `quantity == 1`.
2296             _packedOwnerships[startTokenId] = _packOwnershipData(
2297                 to,
2298                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2299             );
2300 
2301             uint256 toMasked;
2302             uint256 end = startTokenId + quantity;
2303 
2304             // Use assembly to loop and emit the `Transfer` event for gas savings.
2305             // The duplicated `log4` removes an extra check and reduces stack juggling.
2306             // The assembly, together with the surrounding Solidity code, have been
2307             // delicately arranged to nudge the compiler into producing optimized opcodes.
2308             assembly {
2309                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
2310                 toMasked := and(to, _BITMASK_ADDRESS)
2311                 // Emit the `Transfer` event.
2312                 log4(
2313                     0, // Start of data (0, since no data).
2314                     0, // End of data (0, since no data).
2315                     _TRANSFER_EVENT_SIGNATURE, // Signature.
2316                     0, // `address(0)`.
2317                     toMasked, // `to`.
2318                     startTokenId // `tokenId`.
2319                 )
2320 
2321                 // The `iszero(eq(,))` check ensures that large values of `quantity`
2322                 // that overflows uint256 will make the loop run out of gas.
2323                 // The compiler will optimize the `iszero` away for performance.
2324                 for {
2325                     let tokenId := add(startTokenId, 1)
2326                 } iszero(eq(tokenId, end)) {
2327                     tokenId := add(tokenId, 1)
2328                 } {
2329                     // Emit the `Transfer` event. Similar to above.
2330                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
2331                 }
2332             }
2333             if (toMasked == 0) revert MintToZeroAddress();
2334 
2335             _currentIndex = end;
2336         }
2337         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2338     }
2339 
2340     /**
2341      * @dev Mints `quantity` tokens and transfers them to `to`.
2342      *
2343      * This function is intended for efficient minting only during contract creation.
2344      *
2345      * It emits only one {ConsecutiveTransfer} as defined in
2346      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
2347      * instead of a sequence of {Transfer} event(s).
2348      *
2349      * Calling this function outside of contract creation WILL make your contract
2350      * non-compliant with the ERC721 standard.
2351      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
2352      * {ConsecutiveTransfer} event is only permissible during contract creation.
2353      *
2354      * Requirements:
2355      *
2356      * - `to` cannot be the zero address.
2357      * - `quantity` must be greater than 0.
2358      *
2359      * Emits a {ConsecutiveTransfer} event.
2360      */
2361     function _mintERC2309(address to, uint256 quantity) internal virtual {
2362         uint256 startTokenId = _currentIndex;
2363         if (to == address(0)) revert MintToZeroAddress();
2364         if (quantity == 0) revert MintZeroQuantity();
2365         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
2366 
2367         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2368 
2369         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
2370         unchecked {
2371             // Updates:
2372             // - `balance += quantity`.
2373             // - `numberMinted += quantity`.
2374             //
2375             // We can directly add to the `balance` and `numberMinted`.
2376             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2377 
2378             // Updates:
2379             // - `address` to the owner.
2380             // - `startTimestamp` to the timestamp of minting.
2381             // - `burned` to `false`.
2382             // - `nextInitialized` to `quantity == 1`.
2383             _packedOwnerships[startTokenId] = _packOwnershipData(
2384                 to,
2385                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2386             );
2387 
2388             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
2389 
2390             _currentIndex = startTokenId + quantity;
2391         }
2392         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2393     }
2394 
2395     /**
2396      * @dev Safely mints `quantity` tokens and transfers them to `to`.
2397      *
2398      * Requirements:
2399      *
2400      * - If `to` refers to a smart contract, it must implement
2401      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
2402      * - `quantity` must be greater than 0.
2403      *
2404      * See {_mint}.
2405      *
2406      * Emits a {Transfer} event for each mint.
2407      */
2408     function _safeMint(
2409         address to,
2410         uint256 quantity,
2411         bytes memory _data
2412     ) internal virtual {
2413         _mint(to, quantity);
2414 
2415         unchecked {
2416             if (to.code.length != 0) {
2417                 uint256 end = _currentIndex;
2418                 uint256 index = end - quantity;
2419                 do {
2420                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
2421                         revert TransferToNonERC721ReceiverImplementer();
2422                     }
2423                 } while (index < end);
2424                 // Reentrancy protection.
2425                 if (_currentIndex != end) revert();
2426             }
2427         }
2428     }
2429 
2430     /**
2431      * @dev Equivalent to `_safeMint(to, quantity, '')`.
2432      */
2433     function _safeMint(address to, uint256 quantity) internal virtual {
2434         _safeMint(to, quantity, '');
2435     }
2436 
2437     // =============================================================
2438     //                        BURN OPERATIONS
2439     // =============================================================
2440 
2441     /**
2442      * @dev Equivalent to `_burn(tokenId, false)`.
2443      */
2444     function _burn(uint256 tokenId) internal virtual {
2445         _burn(tokenId, false);
2446     }
2447 
2448     /**
2449      * @dev Destroys `tokenId`.
2450      * The approval is cleared when the token is burned.
2451      *
2452      * Requirements:
2453      *
2454      * - `tokenId` must exist.
2455      *
2456      * Emits a {Transfer} event.
2457      */
2458     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2459         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2460 
2461         address from = address(uint160(prevOwnershipPacked));
2462 
2463         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2464 
2465         if (approvalCheck) {
2466             // The nested ifs save around 20+ gas over a compound boolean condition.
2467             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2468                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2469         }
2470 
2471         _beforeTokenTransfers(from, address(0), tokenId, 1);
2472 
2473         // Clear approvals from the previous owner.
2474         assembly {
2475             if approvedAddress {
2476                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2477                 sstore(approvedAddressSlot, 0)
2478             }
2479         }
2480 
2481         // Underflow of the sender's balance is impossible because we check for
2482         // ownership above and the recipient's balance can't realistically overflow.
2483         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2484         unchecked {
2485             // Updates:
2486             // - `balance -= 1`.
2487             // - `numberBurned += 1`.
2488             //
2489             // We can directly decrement the balance, and increment the number burned.
2490             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
2491             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
2492 
2493             // Updates:
2494             // - `address` to the last owner.
2495             // - `startTimestamp` to the timestamp of burning.
2496             // - `burned` to `true`.
2497             // - `nextInitialized` to `true`.
2498             _packedOwnerships[tokenId] = _packOwnershipData(
2499                 from,
2500                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
2501             );
2502 
2503             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2504             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2505                 uint256 nextTokenId = tokenId + 1;
2506                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2507                 if (_packedOwnerships[nextTokenId] == 0) {
2508                     // If the next slot is within bounds.
2509                     if (nextTokenId != _currentIndex) {
2510                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2511                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2512                     }
2513                 }
2514             }
2515         }
2516 
2517         emit Transfer(from, address(0), tokenId);
2518         _afterTokenTransfers(from, address(0), tokenId, 1);
2519 
2520         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2521         unchecked {
2522             _burnCounter++;
2523         }
2524     }
2525 
2526     // =============================================================
2527     //                     EXTRA DATA OPERATIONS
2528     // =============================================================
2529 
2530     /**
2531      * @dev Directly sets the extra data for the ownership data `index`.
2532      */
2533     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
2534         uint256 packed = _packedOwnerships[index];
2535         if (packed == 0) revert OwnershipNotInitializedForExtraData();
2536         uint256 extraDataCasted;
2537         // Cast `extraData` with assembly to avoid redundant masking.
2538         assembly {
2539             extraDataCasted := extraData
2540         }
2541         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
2542         _packedOwnerships[index] = packed;
2543     }
2544 
2545     /**
2546      * @dev Called during each token transfer to set the 24bit `extraData` field.
2547      * Intended to be overridden by the cosumer contract.
2548      *
2549      * `previousExtraData` - the value of `extraData` before transfer.
2550      *
2551      * Calling conditions:
2552      *
2553      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2554      * transferred to `to`.
2555      * - When `from` is zero, `tokenId` will be minted for `to`.
2556      * - When `to` is zero, `tokenId` will be burned by `from`.
2557      * - `from` and `to` are never both zero.
2558      */
2559     function _extraData(
2560         address from,
2561         address to,
2562         uint24 previousExtraData
2563     ) internal view virtual returns (uint24) {}
2564 
2565     /**
2566      * @dev Returns the next extra data for the packed ownership data.
2567      * The returned result is shifted into position.
2568      */
2569     function _nextExtraData(
2570         address from,
2571         address to,
2572         uint256 prevOwnershipPacked
2573     ) private view returns (uint256) {
2574         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
2575         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
2576     }
2577 
2578     // =============================================================
2579     //                       OTHER OPERATIONS
2580     // =============================================================
2581 
2582     /**
2583      * @dev Returns the message sender (defaults to `msg.sender`).
2584      *
2585      * If you are writing GSN compatible contracts, you need to override this function.
2586      */
2587     function _msgSenderERC721A() internal view virtual returns (address) {
2588         return msg.sender;
2589     }
2590 
2591     /**
2592      * @dev Converts a uint256 to its ASCII string decimal representation.
2593      */
2594     function _toString(uint256 value) internal pure virtual returns (string memory str) {
2595         assembly {
2596             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
2597             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
2598             // We will need 1 word for the trailing zeros padding, 1 word for the length,
2599             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
2600             let m := add(mload(0x40), 0xa0)
2601             // Update the free memory pointer to allocate.
2602             mstore(0x40, m)
2603             // Assign the `str` to the end.
2604             str := sub(m, 0x20)
2605             // Zeroize the slot after the string.
2606             mstore(str, 0)
2607 
2608             // Cache the end of the memory to calculate the length later.
2609             let end := str
2610 
2611             // We write the string from rightmost digit to leftmost digit.
2612             // The following is essentially a do-while loop that also handles the zero case.
2613             // prettier-ignore
2614             for { let temp := value } 1 {} {
2615                 str := sub(str, 1)
2616                 // Write the character to the pointer.
2617                 // The ASCII index of the '0' character is 48.
2618                 mstore8(str, add(48, mod(temp, 10)))
2619                 // Keep dividing `temp` until zero.
2620                 temp := div(temp, 10)
2621                 // prettier-ignore
2622                 if iszero(temp) { break }
2623             }
2624 
2625             let length := sub(end, str)
2626             // Move the pointer 32 bytes leftwards to make room for the length.
2627             str := sub(str, 0x20)
2628             // Store the length.
2629             mstore(str, length)
2630         }
2631     }
2632 }
2633 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
2634 
2635 
2636 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
2637 
2638 pragma solidity ^0.8.0;
2639 
2640 /**
2641  * @dev Interface of the ERC165 standard, as defined in the
2642  * https://eips.ethereum.org/EIPS/eip-165[EIP].
2643  *
2644  * Implementers can declare support of contract interfaces, which can then be
2645  * queried by others ({ERC165Checker}).
2646  *
2647  * For an implementation, see {ERC165}.
2648  */
2649 interface IERC165 {
2650     /**
2651      * @dev Returns true if this contract implements the interface defined by
2652      * `interfaceId`. See the corresponding
2653      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
2654      * to learn more about how these ids are created.
2655      *
2656      * This function call must use less than 30 000 gas.
2657      */
2658     function supportsInterface(bytes4 interfaceId) external view returns (bool);
2659 }
2660 
2661 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
2662 
2663 
2664 // OpenZeppelin Contracts (last updated v4.9.0) (interfaces/IERC2981.sol)
2665 
2666 pragma solidity ^0.8.0;
2667 
2668 
2669 /**
2670  * @dev Interface for the NFT Royalty Standard.
2671  *
2672  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
2673  * support for royalty payments across all NFT marketplaces and ecosystem participants.
2674  *
2675  * _Available since v4.5._
2676  */
2677 interface IERC2981 is IERC165 {
2678     /**
2679      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
2680      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
2681      */
2682     function royaltyInfo(
2683         uint256 tokenId,
2684         uint256 salePrice
2685     ) external view returns (address receiver, uint256 royaltyAmount);
2686 }
2687 
2688 // File: wagmidefenseDrop/interfaces/ISeaDropTokenContractMetadata.sol
2689 
2690 
2691 pragma solidity 0.8.17;
2692 
2693 
2694 interface ISeaDropTokenContractMetadata is IERC2981 {
2695     /**
2696      * @notice Throw if the max supply exceeds uint64, a limit
2697      *         due to the storage of bit-packed variables in ERC721A.
2698      */
2699     error CannotExceedMaxSupplyOfUint64(uint256 newMaxSupply);
2700 
2701     /**
2702      * @dev Revert with an error when attempting to set the provenance
2703      *      hash after the mint has started.
2704      */
2705     error ProvenanceHashCannotBeSetAfterMintStarted();
2706 
2707     /**
2708      * @dev Revert if the royalty basis points is greater than 10_000.
2709      */
2710     error InvalidRoyaltyBasisPoints(uint256 basisPoints);
2711 
2712     /**
2713      * @dev Revert if the royalty address is being set to the zero address.
2714      */
2715     error RoyaltyAddressCannotBeZeroAddress();
2716 
2717     /**
2718      * @dev Emit an event for token metadata reveals/updates,
2719      *      according to EIP-4906.
2720      *
2721      * @param _fromTokenId The start token id.
2722      * @param _toTokenId   The end token id.
2723      */
2724     event BatchMetadataUpdate(uint256 _fromTokenId, uint256 _toTokenId);
2725 
2726     /**
2727      * @dev Emit an event when the URI for the collection-level metadata
2728      *      is updated.
2729      */
2730     event ContractURIUpdated(string newContractURI);
2731 
2732     /**
2733      * @dev Emit an event when the max token supply is updated.
2734      */
2735     event MaxSupplyUpdated(uint256 newMaxSupply);
2736 
2737     /**
2738      * @dev Emit an event with the previous and new provenance hash after
2739      *      being updated.
2740      */
2741     event ProvenanceHashUpdated(bytes32 previousHash, bytes32 newHash);
2742 
2743     /**
2744      * @dev Emit an event when the royalties info is updated.
2745      */
2746     event RoyaltyInfoUpdated(address receiver, uint256 bps);
2747 
2748     /**
2749      * @notice A struct defining royalty info for the contract.
2750      */
2751     struct RoyaltyInfo {
2752         address royaltyAddress;
2753         uint96 royaltyBps;
2754     }
2755 
2756     /**
2757      * @notice Sets the base URI for the token metadata and emits an event.
2758      *
2759      * @param tokenURI The new base URI to set.
2760      */
2761     function setBaseURI(string calldata tokenURI) external;
2762 
2763     /**
2764      * @notice Sets the contract URI for contract metadata.
2765      *
2766      * @param newContractURI The new contract URI.
2767      */
2768     function setContractURI(string calldata newContractURI) external;
2769 
2770     /**
2771      * @notice Sets the max supply and emits an event.
2772      *
2773      * @param newMaxSupply The new max supply to set.
2774      */
2775     function setMaxSupply(uint256 newMaxSupply) external;
2776 
2777     /**
2778      * @notice Sets the provenance hash and emits an event.
2779      *
2780      *         The provenance hash is used for random reveals, which
2781      *         is a hash of the ordered metadata to show it has not been
2782      *         modified after mint started.
2783      *
2784      *         This function will revert after the first item has been minted.
2785      *
2786      * @param newProvenanceHash The new provenance hash to set.
2787      */
2788     function setProvenanceHash(bytes32 newProvenanceHash) external;
2789 
2790     /**
2791      * @notice Sets the address and basis points for royalties.
2792      *
2793      * @param newInfo The struct to configure royalties.
2794      */
2795     function setRoyaltyInfo(RoyaltyInfo calldata newInfo) external;
2796 
2797     /**
2798      * @notice Returns the base URI for token metadata.
2799      */
2800     function baseURI() external view returns (string memory);
2801 
2802     /**
2803      * @notice Returns the contract URI.
2804      */
2805     function contractURI() external view returns (string memory);
2806 
2807     /**
2808      * @notice Returns the max token supply.
2809      */
2810     function maxSupply() external view returns (uint256);
2811 
2812     /**
2813      * @notice Returns the provenance hash.
2814      *         The provenance hash is used for random reveals, which
2815      *         is a hash of the ordered metadata to show it is unmodified
2816      *         after mint has started.
2817      */
2818     function provenanceHash() external view returns (bytes32);
2819 
2820     /**
2821      * @notice Returns the address that receives royalties.
2822      */
2823     function royaltyAddress() external view returns (address);
2824 
2825     /**
2826      * @notice Returns the royalty basis points out of 10_000.
2827      */
2828     function royaltyBasisPoints() external view returns (uint256);
2829 }
2830 // File: wagmidefenseDrop/interfaces/INonFungibleSeaDropToken.sol
2831 
2832 
2833 interface INonFungibleSeaDropToken is ISeaDropTokenContractMetadata {
2834     /**
2835      * @dev Revert with an error if a contract is not an allowed
2836      *      SeaDrop address.
2837      */
2838     error OnlyAllowedSeaDrop();
2839 
2840     /**
2841      * @dev Emit an event when allowed SeaDrop contracts are updated.
2842      */
2843     event AllowedSeaDropUpdated(address[] allowedSeaDrop);
2844 
2845     /**
2846      * @notice Update the allowed SeaDrop contracts.
2847      *         Only the owner or administrator can use this function.
2848      *
2849      * @param allowedSeaDrop The allowed SeaDrop addresses.
2850      */
2851     function updateAllowedSeaDrop(address[] calldata allowedSeaDrop) external;
2852 
2853     /**
2854      * @notice Mint tokens, restricted to the SeaDrop contract.
2855      *
2856      * @dev    NOTE: If a token registers itself with multiple SeaDrop
2857      *         contracts, the implementation of this function should guard
2858      *         against reentrancy. If the implementing token uses
2859      *         _safeMint(), or a feeRecipient with a malicious receive() hook
2860      *         is specified, the token or fee recipients may be able to execute
2861      *         another mint in the same transaction via a separate SeaDrop
2862      *         contract.
2863      *         This is dangerous if an implementing token does not correctly
2864      *         update the minterNumMinted and currentTotalSupply values before
2865      *         transferring minted tokens, as SeaDrop references these values
2866      *         to enforce token limits on a per-wallet and per-stage basis.
2867      *
2868      * @param minter   The address to mint to.
2869      * @param quantity The number of tokens to mint.
2870      */
2871     function mintSeaDrop(address minter, uint256 quantity) external;
2872 
2873     /**
2874      * @notice Returns a set of mint stats for the address.
2875      *         This assists SeaDrop in enforcing maxSupply,
2876      *         maxTotalMintableByWallet, and maxTokenSupplyForStage checks.
2877      *
2878      * @dev    NOTE: Implementing contracts should always update these numbers
2879      *         before transferring any tokens with _safeMint() to mitigate
2880      *         consequences of malicious onERC721Received() hooks.
2881      *
2882      * @param minter The minter address.
2883      */
2884     function getMintStats(address minter)
2885         external
2886         view
2887         returns (
2888             uint256 minterNumMinted,
2889             uint256 currentTotalSupply,
2890             uint256 maxSupply
2891         );
2892 
2893     /**
2894      * @notice Update the public drop data for this nft contract on SeaDrop.
2895      *         Only the owner or administrator can use this function.
2896      *
2897      *         The administrator can only update `feeBps`.
2898      *
2899      * @param seaDropImpl The allowed SeaDrop contract.
2900      * @param publicDrop  The public drop data.
2901      */
2902     function updatePublicDrop(
2903         address seaDropImpl,
2904         PublicDrop calldata publicDrop
2905     ) external;
2906 
2907     /**
2908      * @notice Update the allow list data for this nft contract on SeaDrop.
2909      *         Only the owner or administrator can use this function.
2910      *
2911      * @param seaDropImpl   The allowed SeaDrop contract.
2912      * @param allowListData The allow list data.
2913      */
2914     function updateAllowList(
2915         address seaDropImpl,
2916         AllowListData calldata allowListData
2917     ) external;
2918 
2919     /**
2920      * @notice Update the token gated drop stage data for this nft contract
2921      *         on SeaDrop.
2922      *         Only the owner or administrator can use this function.
2923      *
2924      *         The administrator, when present, must first set `feeBps`.
2925      *
2926      *         Note: If two INonFungibleSeaDropToken tokens are doing
2927      *         simultaneous token gated drop promotions for each other,
2928      *         they can be minted by the same actor until
2929      *         `maxTokenSupplyForStage` is reached. Please ensure the
2930      *         `allowedNftToken` is not running an active drop during the
2931      *         `dropStage` time period.
2932      *
2933      *
2934      * @param seaDropImpl     The allowed SeaDrop contract.
2935      * @param allowedNftToken The allowed nft token.
2936      * @param dropStage       The token gated drop stage data.
2937      */
2938     function updateTokenGatedDrop(
2939         address seaDropImpl,
2940         address allowedNftToken,
2941         TokenGatedDropStage calldata dropStage
2942     ) external;
2943 
2944     /**
2945      * @notice Update the drop URI for this nft contract on SeaDrop.
2946      *         Only the owner or administrator can use this function.
2947      *
2948      * @param seaDropImpl The allowed SeaDrop contract.
2949      * @param dropURI     The new drop URI.
2950      */
2951     function updateDropURI(address seaDropImpl, string calldata dropURI)
2952         external;
2953 
2954     /**
2955      * @notice Update the creator payout address for this nft contract on
2956      *         SeaDrop.
2957      *         Only the owner can set the creator payout address.
2958      *
2959      * @param seaDropImpl   The allowed SeaDrop contract.
2960      * @param payoutAddress The new payout address.
2961      */
2962     function updateCreatorPayoutAddress(
2963         address seaDropImpl,
2964         address payoutAddress
2965     ) external;
2966 
2967     /**
2968      * @notice Update the allowed fee recipient for this nft contract
2969      *         on SeaDrop.
2970      *         Only the administrator can set the allowed fee recipient.
2971      *
2972      * @param seaDropImpl  The allowed SeaDrop contract.
2973      * @param feeRecipient The new fee recipient.
2974      */
2975     function updateAllowedFeeRecipient(
2976         address seaDropImpl,
2977         address feeRecipient,
2978         bool allowed
2979     ) external;
2980 
2981     /**
2982      * @notice Update the server-side signers for this nft contract
2983      *         on SeaDrop.
2984      *         Only the owner or administrator can use this function.
2985      *
2986      * @param seaDropImpl                The allowed SeaDrop contract.
2987      * @param signer                     The signer to update.
2988      * @param signedMintValidationParams Minimum and maximum parameters
2989      *                                   to enforce for signed mints.
2990      */
2991     function updateSignedMintValidationParams(
2992         address seaDropImpl,
2993         address signer,
2994         SignedMintValidationParams memory signedMintValidationParams
2995     ) external;
2996 
2997     /**
2998      * @notice Update the allowed payers for this nft contract on SeaDrop.
2999      *         Only the owner or administrator can use this function.
3000      *
3001      * @param seaDropImpl The allowed SeaDrop contract.
3002      * @param payer       The payer to update.
3003      * @param allowed     Whether the payer is allowed.
3004      */
3005     function updatePayer(
3006         address seaDropImpl,
3007         address payer,
3008         bool allowed
3009     ) external;
3010 }
3011 // File: wagmidefenseDrop/ERC721ContractMetadata.sol
3012 
3013 
3014 
3015 /**
3016  * @title  ERC721ContractMetadata
3017  * @author James Wenzel (emo.eth)
3018  * @author Ryan Ghods (ralxz.eth)
3019  * @author Stephan Min (stephanm.eth)
3020  * @notice ERC721ContractMetadata is a token contract that extends ERC721A
3021  *         with additional metadata and ownership capabilities.
3022  */
3023 contract ERC721ContractMetadata is
3024     ERC721A,
3025     TwoStepOwnable,
3026     ISeaDropTokenContractMetadata
3027 {
3028     /// @notice Track the max supply.
3029     uint256 _maxSupply;
3030 
3031     /// @notice Track the base URI for token metadata.
3032     string _tokenBaseURI;
3033 
3034     /// @notice Track the contract URI for contract metadata.
3035     string _contractURI;
3036 
3037     /// @notice Track the provenance hash for guaranteeing metadata order
3038     ///         for random reveals.
3039     bytes32 _provenanceHash;
3040 
3041     /// @notice Track the royalty info: address to receive royalties, and
3042     ///         royalty basis points.
3043     RoyaltyInfo _royaltyInfo;
3044 
3045     /**
3046      * @dev Reverts if the sender is not the owner or the contract itself.
3047      *      This function is inlined instead of being a modifier
3048      *      to save contract space from being inlined N times.
3049      */
3050     function _onlyOwnerOrSelf() internal view {
3051         if (
3052             _cast(msg.sender == owner()) | _cast(msg.sender == address(this)) ==
3053             0
3054         ) {
3055             revert OnlyOwner();
3056         }
3057     }
3058 
3059     /**
3060      * @notice Deploy the token contract with its name and symbol.
3061      */
3062     constructor(string memory name, string memory symbol)
3063         ERC721A(name, symbol)
3064     {}
3065 
3066     /**
3067      * @notice Sets the base URI for the token metadata and emits an event.
3068      *
3069      * @param newBaseURI The new base URI to set.
3070      */
3071     function setBaseURI(string calldata newBaseURI) external override {
3072         // Ensure the sender is only the owner or contract itself.
3073         _onlyOwnerOrSelf();
3074 
3075         // Set the new base URI.
3076         _tokenBaseURI = newBaseURI;
3077 
3078         // Emit an event with the update.
3079         if (totalSupply() != 0) {
3080             emit BatchMetadataUpdate(1, _nextTokenId() - 1);
3081         }
3082     }
3083 
3084     /**
3085      * @notice Sets the contract URI for contract metadata.
3086      *
3087      * @param newContractURI The new contract URI.
3088      */
3089     function setContractURI(string calldata newContractURI) external override {
3090         // Ensure the sender is only the owner or contract itself.
3091         _onlyOwnerOrSelf();
3092 
3093         // Set the new contract URI.
3094         _contractURI = newContractURI;
3095 
3096         // Emit an event with the update.
3097         emit ContractURIUpdated(newContractURI);
3098     }
3099 
3100     /**
3101      * @notice Emit an event notifying metadata updates for
3102      *         a range of token ids, according to EIP-4906.
3103      *
3104      * @param fromTokenId The start token id.
3105      * @param toTokenId   The end token id.
3106      */
3107     function emitBatchMetadataUpdate(uint256 fromTokenId, uint256 toTokenId)
3108         external
3109     {
3110         // Ensure the sender is only the owner or contract itself.
3111         _onlyOwnerOrSelf();
3112 
3113         // Emit an event with the update.
3114         emit BatchMetadataUpdate(fromTokenId, toTokenId);
3115     }
3116 
3117     /**
3118      * @notice Sets the max token supply and emits an event.
3119      *
3120      * @param newMaxSupply The new max supply to set.
3121      */
3122     function setMaxSupply(uint256 newMaxSupply) external {
3123         // Ensure the sender is only the owner or contract itself.
3124         _onlyOwnerOrSelf();
3125 
3126         // Ensure the max supply does not exceed the maximum value of uint64.
3127         if (newMaxSupply > 2**64 - 1) {
3128             revert CannotExceedMaxSupplyOfUint64(newMaxSupply);
3129         }
3130 
3131         // Set the new max supply.
3132         _maxSupply = newMaxSupply;
3133 
3134         // Emit an event with the update.
3135         emit MaxSupplyUpdated(newMaxSupply);
3136     }
3137 
3138     /**
3139      * @notice Sets the provenance hash and emits an event.
3140      *
3141      *         The provenance hash is used for random reveals, which
3142      *         is a hash of the ordered metadata to show it has not been
3143      *         modified after mint started.
3144      *
3145      *         This function will revert after the first item has been minted.
3146      *
3147      * @param newProvenanceHash The new provenance hash to set.
3148      */
3149     function setProvenanceHash(bytes32 newProvenanceHash) external {
3150         // Ensure the sender is only the owner or contract itself.
3151         _onlyOwnerOrSelf();
3152 
3153         // Revert if any items have been minted.
3154         if (_totalMinted() > 0) {
3155             revert ProvenanceHashCannotBeSetAfterMintStarted();
3156         }
3157 
3158         // Keep track of the old provenance hash for emitting with the event.
3159         bytes32 oldProvenanceHash = _provenanceHash;
3160 
3161         // Set the new provenance hash.
3162         _provenanceHash = newProvenanceHash;
3163 
3164         // Emit an event with the update.
3165         emit ProvenanceHashUpdated(oldProvenanceHash, newProvenanceHash);
3166     }
3167 
3168     /**
3169      * @notice Sets the address and basis points for royalties.
3170      *
3171      * @param newInfo The struct to configure royalties.
3172      */
3173     function setRoyaltyInfo(RoyaltyInfo calldata newInfo) external {
3174         // Ensure the sender is only the owner or contract itself.
3175         _onlyOwnerOrSelf();
3176 
3177         // Revert if the new royalty address is the zero address.
3178         if (newInfo.royaltyAddress == address(0)) {
3179             revert RoyaltyAddressCannotBeZeroAddress();
3180         }
3181 
3182         // Revert if the new basis points is greater than 10_000.
3183         if (newInfo.royaltyBps > 10_000) {
3184             revert InvalidRoyaltyBasisPoints(newInfo.royaltyBps);
3185         }
3186 
3187         // Set the new royalty info.
3188         _royaltyInfo = newInfo;
3189 
3190         // Emit an event with the updated params.
3191         emit RoyaltyInfoUpdated(newInfo.royaltyAddress, newInfo.royaltyBps);
3192     }
3193 
3194     /**
3195      * @notice Returns the base URI for token metadata.
3196      */
3197     function baseURI() external view override returns (string memory) {
3198         return _baseURI();
3199     }
3200 
3201     /**
3202      * @notice Returns the base URI for the contract, which ERC721A uses
3203      *         to return tokenURI.
3204      */
3205     function _baseURI() internal view virtual override returns (string memory) {
3206         return _tokenBaseURI;
3207     }
3208 
3209     /**
3210      * @notice Returns the contract URI for contract metadata.
3211      */
3212     function contractURI() external view override returns (string memory) {
3213         return _contractURI;
3214     }
3215 
3216     /**
3217      * @notice Returns the max token supply.
3218      */
3219     function maxSupply() public view returns (uint256) {
3220         return _maxSupply;
3221     }
3222 
3223     /**
3224      * @notice Returns the provenance hash.
3225      *         The provenance hash is used for random reveals, which
3226      *         is a hash of the ordered metadata to show it is unmodified
3227      *         after mint has started.
3228      */
3229     function provenanceHash() external view override returns (bytes32) {
3230         return _provenanceHash;
3231     }
3232 
3233     /**
3234      * @notice Returns the address that receives royalties.
3235      */
3236     function royaltyAddress() external view returns (address) {
3237         return _royaltyInfo.royaltyAddress;
3238     }
3239 
3240     /**
3241      * @notice Returns the royalty basis points out of 10_000.
3242      */
3243     function royaltyBasisPoints() external view returns (uint256) {
3244         return _royaltyInfo.royaltyBps;
3245     }
3246 
3247     /**
3248      * @notice Called with the sale price to determine how much royalty
3249      *         is owed and to whom.
3250      *
3251      * @ param  _tokenId     The NFT asset queried for royalty information.
3252      * @param  _salePrice    The sale price of the NFT asset specified by
3253      *                       _tokenId.
3254      *
3255      * @return receiver      Address of who should be sent the royalty payment.
3256      * @return royaltyAmount The royalty payment amount for _salePrice.
3257      */
3258     function royaltyInfo(
3259         uint256, /* _tokenId */
3260         uint256 _salePrice
3261     ) external view returns (address receiver, uint256 royaltyAmount) {
3262         // Put the royalty info on the stack for more efficient access.
3263         RoyaltyInfo storage info = _royaltyInfo;
3264 
3265         // Set the royalty amount to the sale price times the royalty basis
3266         // points divided by 10_000.
3267         royaltyAmount = (_salePrice * info.royaltyBps) / 10_000;
3268 
3269         // Set the receiver of the royalty.
3270         receiver = info.royaltyAddress;
3271     }
3272 
3273     /**
3274      * @notice Returns whether the interface is supported.
3275      *
3276      * @param interfaceId The interface id to check against.
3277      */
3278     function supportsInterface(bytes4 interfaceId)
3279         public
3280         view
3281         virtual
3282         override(IERC165, ERC721A)
3283         returns (bool)
3284     {
3285         return
3286             interfaceId == type(IERC2981).interfaceId ||
3287             interfaceId == 0x49064906 || // ERC-4906
3288             super.supportsInterface(interfaceId);
3289     }
3290 
3291     /**
3292      * @dev Internal pure function to cast a `bool` value to a `uint256` value.
3293      *
3294      * @param b The `bool` value to cast.
3295      *
3296      * @return u The `uint256` value.
3297      */
3298     function _cast(bool b) internal pure returns (uint256 u) {
3299         assembly {
3300             u := b
3301         }
3302     }
3303 }
3304 // File: wagmidefenseDrop/ERC721SeaDrop.sol
3305 
3306 
3307 
3308 /**
3309  * @title  ERC721SeaDrop
3310  * @author James Wenzel (emo.eth)
3311  * @author Ryan Ghods (ralxz.eth)
3312  * @author Stephan Min (stephanm.eth)
3313  * @author Michael Cohen (notmichael.eth)
3314  * @notice ERC721SeaDrop is a token contract that contains methods
3315  *         to properly interact with SeaDrop.
3316  */
3317 contract ERC721SeaDrop is
3318     ERC721ContractMetadata,
3319     INonFungibleSeaDropToken,
3320     ERC721SeaDropStructsErrorsAndEvents,
3321     ReentrancyGuard,
3322     DefaultOperatorFilterer
3323 {
3324     /// @notice Track the allowed SeaDrop addresses.
3325     mapping(address => bool) internal _allowedSeaDrop;
3326 
3327     /// @notice Track the enumerated allowed SeaDrop addresses.
3328     address[] internal _enumeratedAllowedSeaDrop;
3329 
3330     /**
3331      * @dev Reverts if not an allowed SeaDrop contract.
3332      *      This function is inlined instead of being a modifier
3333      *      to save contract space from being inlined N times.
3334      *
3335      * @param seaDrop The SeaDrop address to check if allowed.
3336      */
3337     function _onlyAllowedSeaDrop(address seaDrop) internal view {
3338         if (_allowedSeaDrop[seaDrop] != true) {
3339             revert OnlyAllowedSeaDrop();
3340         }
3341     }
3342 
3343     /**
3344      * @notice Deploy the token contract with its name, symbol,
3345      *         and allowed SeaDrop addresses.
3346      */
3347     constructor(
3348         string memory name,
3349         string memory symbol,
3350         address[] memory allowedSeaDrop
3351     ) ERC721ContractMetadata(name, symbol) {
3352         // Put the length on the stack for more efficient access.
3353         uint256 allowedSeaDropLength = allowedSeaDrop.length;
3354 
3355         // Set the mapping for allowed SeaDrop contracts.
3356         for (uint256 i = 0; i < allowedSeaDropLength; ) {
3357             _allowedSeaDrop[allowedSeaDrop[i]] = true;
3358             unchecked {
3359                 ++i;
3360             }
3361         }
3362 
3363         // Set the enumeration.
3364         _enumeratedAllowedSeaDrop = allowedSeaDrop;
3365 
3366         // Emit an event noting the contract deployment.
3367         emit SeaDropTokenDeployed();
3368     }
3369 
3370     /**
3371      * @notice Update the allowed SeaDrop contracts.
3372      *         Only the owner or administrator can use this function.
3373      *
3374      * @param allowedSeaDrop The allowed SeaDrop addresses.
3375      */
3376     function updateAllowedSeaDrop(address[] calldata allowedSeaDrop)
3377         external
3378         virtual
3379         override
3380         onlyOwner
3381     {
3382         _updateAllowedSeaDrop(allowedSeaDrop);
3383     }
3384 
3385     /**
3386      * @notice Internal function to update the allowed SeaDrop contracts.
3387      *
3388      * @param allowedSeaDrop The allowed SeaDrop addresses.
3389      */
3390     function _updateAllowedSeaDrop(address[] calldata allowedSeaDrop) internal {
3391         // Put the length on the stack for more efficient access.
3392         uint256 enumeratedAllowedSeaDropLength = _enumeratedAllowedSeaDrop
3393             .length;
3394         uint256 allowedSeaDropLength = allowedSeaDrop.length;
3395 
3396         // Reset the old mapping.
3397         for (uint256 i = 0; i < enumeratedAllowedSeaDropLength; ) {
3398             _allowedSeaDrop[_enumeratedAllowedSeaDrop[i]] = false;
3399             unchecked {
3400                 ++i;
3401             }
3402         }
3403 
3404         // Set the new mapping for allowed SeaDrop contracts.
3405         for (uint256 i = 0; i < allowedSeaDropLength; ) {
3406             _allowedSeaDrop[allowedSeaDrop[i]] = true;
3407             unchecked {
3408                 ++i;
3409             }
3410         }
3411 
3412         // Set the enumeration.
3413         _enumeratedAllowedSeaDrop = allowedSeaDrop;
3414 
3415         // Emit an event for the update.
3416         emit AllowedSeaDropUpdated(allowedSeaDrop);
3417     }
3418 
3419     /**
3420      * @dev Overrides the `_startTokenId` function from ERC721A
3421      *      to start at token id `1`.
3422      *
3423      *      This is to avoid future possible problems since `0` is usually
3424      *      used to signal values that have not been set or have been removed.
3425      */
3426     function _startTokenId() internal view virtual override returns (uint256) {
3427         return 1;
3428     }
3429 
3430     /**
3431      * @dev Overrides the `tokenURI()` function from ERC721A
3432      *      to return just the base URI if it is implied to not be a directory.
3433      *
3434      *      This is to help with ERC721 contracts in which the same token URI
3435      *      is desired for each token, such as when the tokenURI is 'unrevealed'.
3436      */
3437     function tokenURI(uint256 tokenId)
3438         public
3439         view
3440         virtual
3441         override
3442         returns (string memory)
3443     {
3444         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
3445 
3446         string memory baseURI = _baseURI();
3447 
3448         // Exit early if the baseURI is empty.
3449         if (bytes(baseURI).length == 0) {
3450             return "";
3451         }
3452 
3453         // Check if the last character in baseURI is a slash.
3454         if (bytes(baseURI)[bytes(baseURI).length - 1] != bytes("/")[0]) {
3455             return baseURI;
3456         }
3457 
3458         return string(abi.encodePacked(baseURI, _toString(tokenId)));
3459     }
3460 
3461     /**
3462      * @notice Mint tokens, restricted to the SeaDrop contract.
3463      *
3464      * @dev    NOTE: If a token registers itself with multiple SeaDrop
3465      *         contracts, the implementation of this function should guard
3466      *         against reentrancy. If the implementing token uses
3467      *         _safeMint(), or a feeRecipient with a malicious receive() hook
3468      *         is specified, the token or fee recipients may be able to execute
3469      *         another mint in the same transaction via a separate SeaDrop
3470      *         contract.
3471      *         This is dangerous if an implementing token does not correctly
3472      *         update the minterNumMinted and currentTotalSupply values before
3473      *         transferring minted tokens, as SeaDrop references these values
3474      *         to enforce token limits on a per-wallet and per-stage basis.
3475      *
3476      *         ERC721A tracks these values automatically, but this note and
3477      *         nonReentrant modifier are left here to encourage best-practices
3478      *         when referencing this contract.
3479      *
3480      * @param minter   The address to mint to.
3481      * @param quantity The number of tokens to mint.
3482      */
3483     function mintSeaDrop(address minter, uint256 quantity)
3484         external
3485         virtual
3486         override
3487         nonReentrant
3488     {
3489         // Ensure the SeaDrop is allowed.
3490         _onlyAllowedSeaDrop(msg.sender);
3491 
3492         // Extra safety check to ensure the max supply is not exceeded.
3493         if (_totalMinted() + quantity > maxSupply()) {
3494             revert MintQuantityExceedsMaxSupply(
3495                 _totalMinted() + quantity,
3496                 maxSupply()
3497             );
3498         }
3499 
3500         // Mint the quantity of tokens to the minter.
3501         _safeMint(minter, quantity);
3502     }
3503 
3504     /**
3505      * @notice Update the public drop data for this nft contract on SeaDrop.
3506      *         Only the owner can use this function.
3507      *
3508      * @param seaDropImpl The allowed SeaDrop contract.
3509      * @param publicDrop  The public drop data.
3510      */
3511     function updatePublicDrop(
3512         address seaDropImpl,
3513         PublicDrop calldata publicDrop
3514     ) external virtual override {
3515         // Ensure the sender is only the owner or contract itself.
3516         _onlyOwnerOrSelf();
3517 
3518         // Ensure the SeaDrop is allowed.
3519         _onlyAllowedSeaDrop(seaDropImpl);
3520 
3521         // Update the public drop data on SeaDrop.
3522         ISeaDrop(seaDropImpl).updatePublicDrop(publicDrop);
3523     }
3524 
3525     /**
3526      * @notice Update the allow list data for this nft contract on SeaDrop.
3527      *         Only the owner can use this function.
3528      *
3529      * @param seaDropImpl   The allowed SeaDrop contract.
3530      * @param allowListData The allow list data.
3531      */
3532     function updateAllowList(
3533         address seaDropImpl,
3534         AllowListData calldata allowListData
3535     ) external virtual override {
3536         // Ensure the sender is only the owner or contract itself.
3537         _onlyOwnerOrSelf();
3538 
3539         // Ensure the SeaDrop is allowed.
3540         _onlyAllowedSeaDrop(seaDropImpl);
3541 
3542         // Update the allow list on SeaDrop.
3543         ISeaDrop(seaDropImpl).updateAllowList(allowListData);
3544     }
3545 
3546     /**
3547      * @notice Update the token gated drop stage data for this nft contract
3548      *         on SeaDrop.
3549      *         Only the owner can use this function.
3550      *
3551      *         Note: If two INonFungibleSeaDropToken tokens are doing
3552      *         simultaneous token gated drop promotions for each other,
3553      *         they can be minted by the same actor until
3554      *         `maxTokenSupplyForStage` is reached. Please ensure the
3555      *         `allowedNftToken` is not running an active drop during the
3556      *         `dropStage` time period.
3557      *
3558      * @param seaDropImpl     The allowed SeaDrop contract.
3559      * @param allowedNftToken The allowed nft token.
3560      * @param dropStage       The token gated drop stage data.
3561      */
3562     function updateTokenGatedDrop(
3563         address seaDropImpl,
3564         address allowedNftToken,
3565         TokenGatedDropStage calldata dropStage
3566     ) external virtual override {
3567         // Ensure the sender is only the owner or contract itself.
3568         _onlyOwnerOrSelf();
3569 
3570         // Ensure the SeaDrop is allowed.
3571         _onlyAllowedSeaDrop(seaDropImpl);
3572 
3573         // Update the token gated drop stage.
3574         ISeaDrop(seaDropImpl).updateTokenGatedDrop(allowedNftToken, dropStage);
3575     }
3576 
3577     /**
3578      * @notice Update the drop URI for this nft contract on SeaDrop.
3579      *         Only the owner can use this function.
3580      *
3581      * @param seaDropImpl The allowed SeaDrop contract.
3582      * @param dropURI     The new drop URI.
3583      */
3584     function updateDropURI(address seaDropImpl, string calldata dropURI)
3585         external
3586         virtual
3587         override
3588     {
3589         // Ensure the sender is only the owner or contract itself.
3590         _onlyOwnerOrSelf();
3591 
3592         // Ensure the SeaDrop is allowed.
3593         _onlyAllowedSeaDrop(seaDropImpl);
3594 
3595         // Update the drop URI.
3596         ISeaDrop(seaDropImpl).updateDropURI(dropURI);
3597     }
3598 
3599     /**
3600      * @notice Update the creator payout address for this nft contract on
3601      *         SeaDrop.
3602      *         Only the owner can set the creator payout address.
3603      *
3604      * @param seaDropImpl   The allowed SeaDrop contract.
3605      * @param payoutAddress The new payout address.
3606      */
3607     function updateCreatorPayoutAddress(
3608         address seaDropImpl,
3609         address payoutAddress
3610     ) external {
3611         // Ensure the sender is only the owner or contract itself.
3612         _onlyOwnerOrSelf();
3613 
3614         // Ensure the SeaDrop is allowed.
3615         _onlyAllowedSeaDrop(seaDropImpl);
3616 
3617         // Update the creator payout address.
3618         ISeaDrop(seaDropImpl).updateCreatorPayoutAddress(payoutAddress);
3619     }
3620 
3621     /**
3622      * @notice Update the allowed fee recipient for this nft contract
3623      *         on SeaDrop.
3624      *         Only the owner can set the allowed fee recipient.
3625      *
3626      * @param seaDropImpl  The allowed SeaDrop contract.
3627      * @param feeRecipient The new fee recipient.
3628      * @param allowed      If the fee recipient is allowed.
3629      */
3630     function updateAllowedFeeRecipient(
3631         address seaDropImpl,
3632         address feeRecipient,
3633         bool allowed
3634     ) external virtual {
3635         // Ensure the sender is only the owner or contract itself.
3636         _onlyOwnerOrSelf();
3637 
3638         // Ensure the SeaDrop is allowed.
3639         _onlyAllowedSeaDrop(seaDropImpl);
3640 
3641         // Update the allowed fee recipient.
3642         ISeaDrop(seaDropImpl).updateAllowedFeeRecipient(feeRecipient, allowed);
3643     }
3644 
3645     /**
3646      * @notice Update the server-side signers for this nft contract
3647      *         on SeaDrop.
3648      *         Only the owner can use this function.
3649      *
3650      * @param seaDropImpl                The allowed SeaDrop contract.
3651      * @param signer                     The signer to update.
3652      * @param signedMintValidationParams Minimum and maximum parameters to
3653      *                                   enforce for signed mints.
3654      */
3655     function updateSignedMintValidationParams(
3656         address seaDropImpl,
3657         address signer,
3658         SignedMintValidationParams memory signedMintValidationParams
3659     ) external virtual override {
3660         // Ensure the sender is only the owner or contract itself.
3661         _onlyOwnerOrSelf();
3662 
3663         // Ensure the SeaDrop is allowed.
3664         _onlyAllowedSeaDrop(seaDropImpl);
3665 
3666         // Update the signer.
3667         ISeaDrop(seaDropImpl).updateSignedMintValidationParams(
3668             signer,
3669             signedMintValidationParams
3670         );
3671     }
3672 
3673     /**
3674      * @notice Update the allowed payers for this nft contract on SeaDrop.
3675      *         Only the owner can use this function.
3676      *
3677      * @param seaDropImpl The allowed SeaDrop contract.
3678      * @param payer       The payer to update.
3679      * @param allowed     Whether the payer is allowed.
3680      */
3681     function updatePayer(
3682         address seaDropImpl,
3683         address payer,
3684         bool allowed
3685     ) external virtual override {
3686         // Ensure the sender is only the owner or contract itself.
3687         _onlyOwnerOrSelf();
3688 
3689         // Ensure the SeaDrop is allowed.
3690         _onlyAllowedSeaDrop(seaDropImpl);
3691 
3692         // Update the payer.
3693         ISeaDrop(seaDropImpl).updatePayer(payer, allowed);
3694     }
3695 
3696     /**
3697      * @notice Returns a set of mint stats for the address.
3698      *         This assists SeaDrop in enforcing maxSupply,
3699      *         maxTotalMintableByWallet, and maxTokenSupplyForStage checks.
3700      *
3701      * @dev    NOTE: Implementing contracts should always update these numbers
3702      *         before transferring any tokens with _safeMint() to mitigate
3703      *         consequences of malicious onERC721Received() hooks.
3704      *
3705      * @param minter The minter address.
3706      */
3707     function getMintStats(address minter)
3708         external
3709         view
3710         override
3711         returns (
3712             uint256 minterNumMinted,
3713             uint256 currentTotalSupply,
3714             uint256 maxSupply
3715         )
3716     {
3717         minterNumMinted = _numberMinted(minter);
3718         currentTotalSupply = _totalMinted();
3719         maxSupply = _maxSupply;
3720     }
3721 
3722     /**
3723      * @notice Returns whether the interface is supported.
3724      *
3725      * @param interfaceId The interface id to check against.
3726      */
3727     function supportsInterface(bytes4 interfaceId)
3728         public
3729         view
3730         virtual
3731         override(IERC165, ERC721ContractMetadata)
3732         returns (bool)
3733     {
3734         return
3735             interfaceId == type(INonFungibleSeaDropToken).interfaceId ||
3736             interfaceId == type(ISeaDropTokenContractMetadata).interfaceId ||
3737             // ERC721ContractMetadata returns supportsInterface true for
3738             //     EIP-2981
3739             // ERC721A returns supportsInterface true for
3740             //     ERC165, ERC721, ERC721Metadata
3741             super.supportsInterface(interfaceId);
3742     }
3743 
3744     /**
3745      * @dev Approve or remove `operator` as an operator for the caller.
3746      * Operators can call {transferFrom} or {safeTransferFrom}
3747      * for any token owned by the caller.
3748      *
3749      * Requirements:
3750      *
3751      * - The `operator` cannot be the caller.
3752      * - The `operator` must be allowed.
3753      *
3754      * Emits an {ApprovalForAll} event.
3755      */
3756     function setApprovalForAll(address operator, bool approved)
3757         public
3758         override
3759         onlyAllowedOperatorApproval(operator)
3760     {
3761         super.setApprovalForAll(operator, approved);
3762     }
3763 
3764     /**
3765      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
3766      * The approval is cleared when the token is transferred.
3767      *
3768      * Only a single account can be approved at a time, so approving the
3769      * zero address clears previous approvals.
3770      *
3771      * Requirements:
3772      *
3773      * - The caller must own the token or be an approved operator.
3774      * - `tokenId` must exist.
3775      * - The `operator` mut be allowed.
3776      *
3777      * Emits an {Approval} event.
3778      */
3779     function approve(address operator, uint256 tokenId)
3780         public
3781         override
3782         onlyAllowedOperatorApproval(operator)
3783     {
3784         super.approve(operator, tokenId);
3785     }
3786 
3787     /**
3788      * @dev Transfers `tokenId` from `from` to `to`.
3789      *
3790      * Requirements:
3791      *
3792      * - `from` cannot be the zero address.
3793      * - `to` cannot be the zero address.
3794      * - `tokenId` token must be owned by `from`.
3795      * - If the caller is not `from`, it must be approved to move this token
3796      * by either {approve} or {setApprovalForAll}.
3797      * - The operator must be allowed.
3798      *
3799      * Emits a {Transfer} event.
3800      */
3801     function transferFrom(
3802         address from,
3803         address to,
3804         uint256 tokenId
3805     ) public override onlyAllowedOperator(from) {
3806         super.transferFrom(from, to, tokenId);
3807     }
3808 
3809     /**
3810      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
3811      */
3812     function safeTransferFrom(
3813         address from,
3814         address to,
3815         uint256 tokenId
3816     ) public override onlyAllowedOperator(from) {
3817         super.safeTransferFrom(from, to, tokenId);
3818     }
3819 
3820     /**
3821      * @dev Safely transfers `tokenId` token from `from` to `to`.
3822      *
3823      * Requirements:
3824      *
3825      * - `from` cannot be the zero address.
3826      * - `to` cannot be the zero address.
3827      * - `tokenId` token must exist and be owned by `from`.
3828      * - If the caller is not `from`, it must be approved to move this token
3829      * by either {approve} or {setApprovalForAll}.
3830      * - If `to` refers to a smart contract, it must implement
3831      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
3832      * - The operator must be allowed.
3833      *
3834      * Emits a {Transfer} event.
3835      */
3836     function safeTransferFrom(
3837         address from,
3838         address to,
3839         uint256 tokenId,
3840         bytes memory data
3841     ) public override onlyAllowedOperator(from) {
3842         super.safeTransferFrom(from, to, tokenId, data);
3843     }
3844 
3845     /**
3846      * @notice Configure multiple properties at a time.
3847      *
3848      *         Note: The individual configure methods should be used
3849      *         to unset or reset any properties to zero, as this method
3850      *         will ignore zero-value properties in the config struct.
3851      *
3852      * @param config The configuration struct.
3853      */
3854     function multiConfigure(MultiConfigureStruct calldata config)
3855         external
3856         onlyOwner
3857     {
3858         if (config.maxSupply > 0) {
3859             this.setMaxSupply(config.maxSupply);
3860         }
3861         if (bytes(config.baseURI).length != 0) {
3862             this.setBaseURI(config.baseURI);
3863         }
3864         if (bytes(config.contractURI).length != 0) {
3865             this.setContractURI(config.contractURI);
3866         }
3867         if (
3868             _cast(config.publicDrop.startTime != 0) |
3869                 _cast(config.publicDrop.endTime != 0) ==
3870             1
3871         ) {
3872             this.updatePublicDrop(config.seaDropImpl, config.publicDrop);
3873         }
3874         if (bytes(config.dropURI).length != 0) {
3875             this.updateDropURI(config.seaDropImpl, config.dropURI);
3876         }
3877         if (config.allowListData.merkleRoot != bytes32(0)) {
3878             this.updateAllowList(config.seaDropImpl, config.allowListData);
3879         }
3880         if (config.creatorPayoutAddress != address(0)) {
3881             this.updateCreatorPayoutAddress(
3882                 config.seaDropImpl,
3883                 config.creatorPayoutAddress
3884             );
3885         }
3886         if (config.provenanceHash != bytes32(0)) {
3887             this.setProvenanceHash(config.provenanceHash);
3888         }
3889         if (config.allowedFeeRecipients.length > 0) {
3890             for (uint256 i = 0; i < config.allowedFeeRecipients.length; ) {
3891                 this.updateAllowedFeeRecipient(
3892                     config.seaDropImpl,
3893                     config.allowedFeeRecipients[i],
3894                     true
3895                 );
3896                 unchecked {
3897                     ++i;
3898                 }
3899             }
3900         }
3901         if (config.disallowedFeeRecipients.length > 0) {
3902             for (uint256 i = 0; i < config.disallowedFeeRecipients.length; ) {
3903                 this.updateAllowedFeeRecipient(
3904                     config.seaDropImpl,
3905                     config.disallowedFeeRecipients[i],
3906                     false
3907                 );
3908                 unchecked {
3909                     ++i;
3910                 }
3911             }
3912         }
3913         if (config.allowedPayers.length > 0) {
3914             for (uint256 i = 0; i < config.allowedPayers.length; ) {
3915                 this.updatePayer(
3916                     config.seaDropImpl,
3917                     config.allowedPayers[i],
3918                     true
3919                 );
3920                 unchecked {
3921                     ++i;
3922                 }
3923             }
3924         }
3925         if (config.disallowedPayers.length > 0) {
3926             for (uint256 i = 0; i < config.disallowedPayers.length; ) {
3927                 this.updatePayer(
3928                     config.seaDropImpl,
3929                     config.disallowedPayers[i],
3930                     false
3931                 );
3932                 unchecked {
3933                     ++i;
3934                 }
3935             }
3936         }
3937         if (config.tokenGatedDropStages.length > 0) {
3938             if (
3939                 config.tokenGatedDropStages.length !=
3940                 config.tokenGatedAllowedNftTokens.length
3941             ) {
3942                 revert TokenGatedMismatch();
3943             }
3944             for (uint256 i = 0; i < config.tokenGatedDropStages.length; ) {
3945                 this.updateTokenGatedDrop(
3946                     config.seaDropImpl,
3947                     config.tokenGatedAllowedNftTokens[i],
3948                     config.tokenGatedDropStages[i]
3949                 );
3950                 unchecked {
3951                     ++i;
3952                 }
3953             }
3954         }
3955         if (config.disallowedTokenGatedAllowedNftTokens.length > 0) {
3956             for (
3957                 uint256 i = 0;
3958                 i < config.disallowedTokenGatedAllowedNftTokens.length;
3959 
3960             ) {
3961                 TokenGatedDropStage memory emptyStage;
3962                 this.updateTokenGatedDrop(
3963                     config.seaDropImpl,
3964                     config.disallowedTokenGatedAllowedNftTokens[i],
3965                     emptyStage
3966                 );
3967                 unchecked {
3968                     ++i;
3969                 }
3970             }
3971         }
3972         if (config.signedMintValidationParams.length > 0) {
3973             if (
3974                 config.signedMintValidationParams.length !=
3975                 config.signers.length
3976             ) {
3977                 revert SignersMismatch();
3978             }
3979             for (
3980                 uint256 i = 0;
3981                 i < config.signedMintValidationParams.length;
3982 
3983             ) {
3984                 this.updateSignedMintValidationParams(
3985                     config.seaDropImpl,
3986                     config.signers[i],
3987                     config.signedMintValidationParams[i]
3988                 );
3989                 unchecked {
3990                     ++i;
3991                 }
3992             }
3993         }
3994         if (config.disallowedSigners.length > 0) {
3995             for (uint256 i = 0; i < config.disallowedSigners.length; ) {
3996                 SignedMintValidationParams memory emptyParams;
3997                 this.updateSignedMintValidationParams(
3998                     config.seaDropImpl,
3999                     config.disallowedSigners[i],
4000                     emptyParams
4001                 );
4002                 unchecked {
4003                     ++i;
4004                 }
4005             }
4006         }
4007     }
4008 }
4009 // File: wagmidefenseDrop/ERC721SeaDropBurnable.sol
4010 
4011 
4012 pragma solidity 0.8.17;
4013 
4014 
4015 /**
4016  * @title  ERC721SeaDropBurnable
4017  * @author James Wenzel (emo.eth)
4018  * @author Ryan Ghods (ralxz.eth)
4019  * @author Stephan Min (stephanm.eth)
4020  * @author Michael Cohen (notmichael.eth)
4021  * @notice ERC721SeaDropBurnable is a token contract that extends
4022  *         ERC721SeaDrop to additionally provide a burn function.
4023  */
4024 contract WagmiDefense is ERC721SeaDrop {
4025     /**
4026      * @notice Deploy the token contract with its name, symbol,
4027      *         and allowed SeaDrop addresses.
4028      */
4029     constructor(
4030         string memory name,
4031         string memory symbol,
4032         address[] memory allowedSeaDrop
4033     ) ERC721SeaDrop(name, symbol, allowedSeaDrop) {}
4034 
4035     /**
4036      * @notice Burns `tokenId`. The caller must own `tokenId` or be an
4037      *         approved operator.
4038      *
4039      * @param tokenId The token id to burn.
4040      */
4041     // solhint-disable-next-line comprehensive-interface
4042     function burn(uint256 tokenId) external {
4043         _burn(tokenId, true);
4044     }
4045 }