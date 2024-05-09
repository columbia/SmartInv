1 // File: closedsea/OperatorFilterer.sol
2 
3 
4 pragma solidity ^0.8.4;
5 
6 /// @notice Optimized and flexible operator filterer to abide to OpenSea's
7 /// mandatory on-chain royalty enforcement in order for new collections to
8 /// receive royalties.
9 /// For more information, see:
10 /// See: https://github.com/ProjectOpenSea/operator-filter-registry
11 abstract contract OperatorFilterer {
12     /// @dev The default OpenSea operator blocklist subscription.
13     address internal constant _DEFAULT_SUBSCRIPTION = 0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6;
14 
15     /// @dev The OpenSea operator filter registry.
16     address internal constant _OPERATOR_FILTER_REGISTRY = 0x000000000000AAeB6D7670E522A718067333cd4E;
17 
18     /// @dev Registers the current contract to OpenSea's operator filter,
19     /// and subscribe to the default OpenSea operator blocklist.
20     /// Note: Will not revert nor update existing settings for repeated registration.
21     function _registerForOperatorFiltering() internal virtual {
22         _registerForOperatorFiltering(_DEFAULT_SUBSCRIPTION, true);
23     }
24 
25     /// @dev Registers the current contract to OpenSea's operator filter.
26     /// Note: Will not revert nor update existing settings for repeated registration.
27     function _registerForOperatorFiltering(address subscriptionOrRegistrantToCopy, bool subscribe)
28         internal
29         virtual
30     {
31         /// @solidity memory-safe-assembly
32         assembly {
33             let functionSelector := 0x7d3e3dbe // `registerAndSubscribe(address,address)`.
34 
35             // Clean the upper 96 bits of `subscriptionOrRegistrantToCopy` in case they are dirty.
36             subscriptionOrRegistrantToCopy := shr(96, shl(96, subscriptionOrRegistrantToCopy))
37 
38             for {} iszero(subscribe) {} {
39                 if iszero(subscriptionOrRegistrantToCopy) {
40                     functionSelector := 0x4420e486 // `register(address)`.
41                     break
42                 }
43                 functionSelector := 0xa0af2903 // `registerAndCopyEntries(address,address)`.
44                 break
45             }
46             // Store the function selector.
47             mstore(0x00, shl(224, functionSelector))
48             // Store the `address(this)`.
49             mstore(0x04, address())
50             // Store the `subscriptionOrRegistrantToCopy`.
51             mstore(0x24, subscriptionOrRegistrantToCopy)
52             // Register into the registry.
53             if iszero(call(gas(), _OPERATOR_FILTER_REGISTRY, 0, 0x00, 0x44, 0x00, 0x04)) {
54                 // If the function selector has not been overwritten,
55                 // it is an out-of-gas error.
56                 if eq(shr(224, mload(0x00)), functionSelector) {
57                     // To prevent gas under-estimation.
58                     revert(0, 0)
59                 }
60             }
61             // Restore the part of the free memory pointer that was overwritten,
62             // which is guaranteed to be zero, because of Solidity's memory size limits.
63             mstore(0x24, 0)
64         }
65     }
66 
67     /// @dev Modifier to guard a function and revert if the caller is a blocked operator.
68     modifier onlyAllowedOperator(address from) virtual {
69         if (from != msg.sender) {
70             if (!_isPriorityOperator(msg.sender)) {
71                 if (_operatorFilteringEnabled()) _revertIfBlocked(msg.sender);
72             }
73         }
74         _;
75     }
76 
77     /// @dev Modifier to guard a function from approving a blocked operator..
78     modifier onlyAllowedOperatorApproval(address operator) virtual {
79         if (!_isPriorityOperator(operator)) {
80             if (_operatorFilteringEnabled()) _revertIfBlocked(operator);
81         }
82         _;
83     }
84 
85     /// @dev Helper function that reverts if the `operator` is blocked by the registry.
86     function _revertIfBlocked(address operator) private view {
87         /// @solidity memory-safe-assembly
88         assembly {
89             // Store the function selector of `isOperatorAllowed(address,address)`,
90             // shifted left by 6 bytes, which is enough for 8tb of memory.
91             // We waste 6-3 = 3 bytes to save on 6 runtime gas (PUSH1 0x224 SHL).
92             mstore(0x00, 0xc6171134001122334455)
93             // Store the `address(this)`.
94             mstore(0x1a, address())
95             // Store the `operator`.
96             mstore(0x3a, operator)
97 
98             // `isOperatorAllowed` always returns true if it does not revert.
99             if iszero(staticcall(gas(), _OPERATOR_FILTER_REGISTRY, 0x16, 0x44, 0x00, 0x00)) {
100                 // Bubble up the revert if the staticcall reverts.
101                 returndatacopy(0x00, 0x00, returndatasize())
102                 revert(0x00, returndatasize())
103             }
104 
105             // We'll skip checking if `from` is inside the blacklist.
106             // Even though that can block transferring out of wrapper contracts,
107             // we don't want tokens to be stuck.
108 
109             // Restore the part of the free memory pointer that was overwritten,
110             // which is guaranteed to be zero, if less than 8tb of memory is used.
111             mstore(0x3a, 0)
112         }
113     }
114 
115     /// @dev For deriving contracts to override, so that operator filtering
116     /// can be turned on / off.
117     /// Returns true by default.
118     function _operatorFilteringEnabled() internal view virtual returns (bool) {
119         return true;
120     }
121 
122     /// @dev For deriving contracts to override, so that preferred marketplaces can
123     /// skip operator filtering, helping users save gas.
124     /// Returns false for all inputs by default.
125     function _isPriorityOperator(address) internal view virtual returns (bool) {
126         return false;
127     }
128 }
129 
130 // File: solady/auth/Ownable.sol
131 
132 
133 pragma solidity ^0.8.4;
134 
135 /// @notice Simple single owner authorization mixin.
136 /// @author Solady (https://github.com/vectorized/solady/blob/main/src/auth/Ownable.sol)
137 /// @dev While the ownable portion follows [EIP-173](https://eips.ethereum.org/EIPS/eip-173)
138 /// for compatibility, the nomenclature for the 2-step ownership handover
139 /// may be unique to this codebase.
140 abstract contract Ownable {
141     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
142     /*                       CUSTOM ERRORS                        */
143     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
144 
145     /// @dev The caller is not authorized to call the function.
146     error Unauthorized();
147 
148     /// @dev The `newOwner` cannot be the zero address.
149     error NewOwnerIsZeroAddress();
150 
151     /// @dev The `pendingOwner` does not have a valid handover request.
152     error NoHandoverRequest();
153 
154     /// @dev `bytes4(keccak256(bytes("Unauthorized()")))`.
155     uint256 private constant _UNAUTHORIZED_ERROR_SELECTOR = 0x82b42900;
156 
157     /// @dev `bytes4(keccak256(bytes("NewOwnerIsZeroAddress()")))`.
158     uint256 private constant _NEW_OWNER_IS_ZERO_ADDRESS_ERROR_SELECTOR = 0x7448fbae;
159 
160     /// @dev `bytes4(keccak256(bytes("NoHandoverRequest()")))`.
161     uint256 private constant _NO_HANDOVER_REQUEST_ERROR_SELECTOR = 0x6f5e8818;
162 
163     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
164     /*                           EVENTS                           */
165     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
166 
167     /// @dev The ownership is transferred from `oldOwner` to `newOwner`.
168     /// This event is intentionally kept the same as OpenZeppelin's Ownable to be
169     /// compatible with indexers and [EIP-173](https://eips.ethereum.org/EIPS/eip-173),
170     /// despite it not being as lightweight as a single argument event.
171     event OwnershipTransferred(address indexed oldOwner, address indexed newOwner);
172 
173     /// @dev An ownership handover to `pendingOwner` has been requested.
174     event OwnershipHandoverRequested(address indexed pendingOwner);
175 
176     /// @dev The ownership handover to `pendingOwner` has been canceled.
177     event OwnershipHandoverCanceled(address indexed pendingOwner);
178 
179     /// @dev `keccak256(bytes("OwnershipTransferred(address,address)"))`.
180     uint256 private constant _OWNERSHIP_TRANSFERRED_EVENT_SIGNATURE =
181         0x8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e0;
182 
183     /// @dev `keccak256(bytes("OwnershipHandoverRequested(address)"))`.
184     uint256 private constant _OWNERSHIP_HANDOVER_REQUESTED_EVENT_SIGNATURE =
185         0xdbf36a107da19e49527a7176a1babf963b4b0ff8cde35ee35d6cd8f1f9ac7e1d;
186 
187     /// @dev `keccak256(bytes("OwnershipHandoverCanceled(address)"))`.
188     uint256 private constant _OWNERSHIP_HANDOVER_CANCELED_EVENT_SIGNATURE =
189         0xfa7b8eab7da67f412cc9575ed43464468f9bfbae89d1675917346ca6d8fe3c92;
190 
191     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
192     /*                          STORAGE                           */
193     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
194 
195     /// @dev The owner slot is given by: `not(_OWNER_SLOT_NOT)`.
196     /// It is intentionally choosen to be a high value
197     /// to avoid collision with lower slots.
198     /// The choice of manual storage layout is to enable compatibility
199     /// with both regular and upgradeable contracts.
200     uint256 private constant _OWNER_SLOT_NOT = 0x8b78c6d8;
201 
202     /// The ownership handover slot of `newOwner` is given by:
203     /// ```
204     ///     mstore(0x00, or(shl(96, user), _HANDOVER_SLOT_SEED))
205     ///     let handoverSlot := keccak256(0x00, 0x20)
206     /// ```
207     /// It stores the expiry timestamp of the two-step ownership handover.
208     uint256 private constant _HANDOVER_SLOT_SEED = 0x389a75e1;
209 
210     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
211     /*                     INTERNAL FUNCTIONS                     */
212     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
213 
214     /// @dev Initializes the owner directly without authorization guard.
215     /// This function must be called upon initialization,
216     /// regardless of whether the contract is upgradeable or not.
217     /// This is to enable generalization to both regular and upgradeable contracts,
218     /// and to save gas in case the initial owner is not the caller.
219     /// For performance reasons, this function will not check if there
220     /// is an existing owner.
221     function _initializeOwner(address newOwner) internal virtual {
222         /// @solidity memory-safe-assembly
223         assembly {
224             // Clean the upper 96 bits.
225             newOwner := shr(96, shl(96, newOwner))
226             // Store the new value.
227             sstore(not(_OWNER_SLOT_NOT), newOwner)
228             // Emit the {OwnershipTransferred} event.
229             log3(0, 0, _OWNERSHIP_TRANSFERRED_EVENT_SIGNATURE, 0, newOwner)
230         }
231     }
232 
233     /// @dev Sets the owner directly without authorization guard.
234     function _setOwner(address newOwner) internal virtual {
235         /// @solidity memory-safe-assembly
236         assembly {
237             let ownerSlot := not(_OWNER_SLOT_NOT)
238             // Clean the upper 96 bits.
239             newOwner := shr(96, shl(96, newOwner))
240             // Emit the {OwnershipTransferred} event.
241             log3(0, 0, _OWNERSHIP_TRANSFERRED_EVENT_SIGNATURE, sload(ownerSlot), newOwner)
242             // Store the new value.
243             sstore(ownerSlot, newOwner)
244         }
245     }
246 
247     /// @dev Throws if the sender is not the owner.
248     function _checkOwner() internal view virtual {
249         /// @solidity memory-safe-assembly
250         assembly {
251             // If the caller is not the stored owner, revert.
252             if iszero(eq(caller(), sload(not(_OWNER_SLOT_NOT)))) {
253                 mstore(0x00, _UNAUTHORIZED_ERROR_SELECTOR)
254                 revert(0x1c, 0x04)
255             }
256         }
257     }
258 
259     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
260     /*                  PUBLIC UPDATE FUNCTIONS                   */
261     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
262 
263     /// @dev Allows the owner to transfer the ownership to `newOwner`.
264     function transferOwnership(address newOwner) public payable virtual onlyOwner {
265         if (newOwner == address(0)) revert NewOwnerIsZeroAddress();
266         _setOwner(newOwner);
267     }
268 
269     /// @dev Allows the owner to renounce their ownership.
270     function renounceOwnership() public payable virtual onlyOwner {
271         _setOwner(address(0));
272     }
273 
274     /// @dev Request a two-step ownership handover to the caller.
275     /// The request will be automatically expire in 48 hours (172800 seconds) by default.
276     function requestOwnershipHandover() public payable virtual {
277         unchecked {
278             uint256 expires = block.timestamp + ownershipHandoverValidFor();
279             /// @solidity memory-safe-assembly
280             assembly {
281                 // Compute and set the handover slot to 1.
282                 mstore(0x0c, _HANDOVER_SLOT_SEED)
283                 mstore(0x00, caller())
284                 sstore(keccak256(0x0c, 0x20), expires)
285                 // Emit the {OwnershipHandoverRequested} event.
286                 log2(0, 0, _OWNERSHIP_HANDOVER_REQUESTED_EVENT_SIGNATURE, caller())
287             }
288         }
289     }
290 
291     /// @dev Cancels the two-step ownership handover to the caller, if any.
292     function cancelOwnershipHandover() public payable virtual {
293         /// @solidity memory-safe-assembly
294         assembly {
295             // Compute and set the handover slot to 0.
296             mstore(0x0c, _HANDOVER_SLOT_SEED)
297             mstore(0x00, caller())
298             sstore(keccak256(0x0c, 0x20), 0)
299             // Emit the {OwnershipHandoverCanceled} event.
300             log2(0, 0, _OWNERSHIP_HANDOVER_CANCELED_EVENT_SIGNATURE, caller())
301         }
302     }
303 
304     /// @dev Allows the owner to complete the two-step ownership handover to `pendingOwner`.
305     /// Reverts if there is no existing ownership handover requested by `pendingOwner`.
306     function completeOwnershipHandover(address pendingOwner) public payable virtual onlyOwner {
307         /// @solidity memory-safe-assembly
308         assembly {
309             // Compute and set the handover slot to 0.
310             mstore(0x0c, _HANDOVER_SLOT_SEED)
311             mstore(0x00, pendingOwner)
312             let handoverSlot := keccak256(0x0c, 0x20)
313             // If the handover does not exist, or has expired.
314             if gt(timestamp(), sload(handoverSlot)) {
315                 mstore(0x00, _NO_HANDOVER_REQUEST_ERROR_SELECTOR)
316                 revert(0x1c, 0x04)
317             }
318             // Set the handover slot to 0.
319             sstore(handoverSlot, 0)
320             // Clean the upper 96 bits.
321             let newOwner := shr(96, mload(0x0c))
322             // Emit the {OwnershipTransferred} event.
323             log3(0, 0, _OWNERSHIP_TRANSFERRED_EVENT_SIGNATURE, caller(), newOwner)
324             // Store the new value.
325             sstore(not(_OWNER_SLOT_NOT), newOwner)
326         }
327     }
328 
329     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
330     /*                   PUBLIC READ FUNCTIONS                    */
331     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
332 
333     /// @dev Returns the owner of the contract.
334     function owner() public view virtual returns (address result) {
335         /// @solidity memory-safe-assembly
336         assembly {
337             result := sload(not(_OWNER_SLOT_NOT))
338         }
339     }
340 
341     /// @dev Returns the expiry timestamp for the two-step ownership handover to `pendingOwner`.
342     function ownershipHandoverExpiresAt(address pendingOwner)
343         public
344         view
345         virtual
346         returns (uint256 result)
347     {
348         /// @solidity memory-safe-assembly
349         assembly {
350             // Compute the handover slot.
351             mstore(0x0c, _HANDOVER_SLOT_SEED)
352             mstore(0x00, pendingOwner)
353             // Load the handover slot.
354             result := sload(keccak256(0x0c, 0x20))
355         }
356     }
357 
358     /// @dev Returns how long a two-step ownership handover is valid for in seconds.
359     function ownershipHandoverValidFor() public view virtual returns (uint64) {
360         return 48 * 3600;
361     }
362 
363     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
364     /*                         MODIFIERS                          */
365     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
366 
367     /// @dev Marks a function as only callable by the owner.
368     modifier onlyOwner() virtual {
369         _checkOwner();
370         _;
371     }
372 }
373 
374 // File: erc721a/contracts/IERC721A.sol
375 
376 
377 // ERC721A Contracts v4.2.3
378 // Creator: Chiru Labs
379 
380 pragma solidity ^0.8.4;
381 
382 /**
383  * @dev Interface of ERC721A.
384  */
385 interface IERC721A {
386     /**
387      * The caller must own the token or be an approved operator.
388      */
389     error ApprovalCallerNotOwnerNorApproved();
390 
391     /**
392      * The token does not exist.
393      */
394     error ApprovalQueryForNonexistentToken();
395 
396     /**
397      * Cannot query the balance for the zero address.
398      */
399     error BalanceQueryForZeroAddress();
400 
401     /**
402      * Cannot mint to the zero address.
403      */
404     error MintToZeroAddress();
405 
406     /**
407      * The quantity of tokens minted must be more than zero.
408      */
409     error MintZeroQuantity();
410 
411     /**
412      * The token does not exist.
413      */
414     error OwnerQueryForNonexistentToken();
415 
416     /**
417      * The caller must own the token or be an approved operator.
418      */
419     error TransferCallerNotOwnerNorApproved();
420 
421     /**
422      * The token must be owned by `from`.
423      */
424     error TransferFromIncorrectOwner();
425 
426     /**
427      * Cannot safely transfer to a contract that does not implement the
428      * ERC721Receiver interface.
429      */
430     error TransferToNonERC721ReceiverImplementer();
431 
432     /**
433      * Cannot transfer to the zero address.
434      */
435     error TransferToZeroAddress();
436 
437     /**
438      * The token does not exist.
439      */
440     error URIQueryForNonexistentToken();
441 
442     /**
443      * The `quantity` minted with ERC2309 exceeds the safety limit.
444      */
445     error MintERC2309QuantityExceedsLimit();
446 
447     /**
448      * The `extraData` cannot be set on an unintialized ownership slot.
449      */
450     error OwnershipNotInitializedForExtraData();
451 
452     // =============================================================
453     //                            STRUCTS
454     // =============================================================
455 
456     struct TokenOwnership {
457         // The address of the owner.
458         address addr;
459         // Stores the start time of ownership with minimal overhead for tokenomics.
460         uint64 startTimestamp;
461         // Whether the token has been burned.
462         bool burned;
463         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
464         uint24 extraData;
465     }
466 
467     // =============================================================
468     //                         TOKEN COUNTERS
469     // =============================================================
470 
471     /**
472      * @dev Returns the total number of tokens in existence.
473      * Burned tokens will reduce the count.
474      * To get the total number of tokens minted, please see {_totalMinted}.
475      */
476     function totalSupply() external view returns (uint256);
477 
478     // =============================================================
479     //                            IERC165
480     // =============================================================
481 
482     /**
483      * @dev Returns true if this contract implements the interface defined by
484      * `interfaceId`. See the corresponding
485      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
486      * to learn more about how these ids are created.
487      *
488      * This function call must use less than 30000 gas.
489      */
490     function supportsInterface(bytes4 interfaceId) external view returns (bool);
491 
492     // =============================================================
493     //                            IERC721
494     // =============================================================
495 
496     /**
497      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
498      */
499     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
500 
501     /**
502      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
503      */
504     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
505 
506     /**
507      * @dev Emitted when `owner` enables or disables
508      * (`approved`) `operator` to manage all of its assets.
509      */
510     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
511 
512     /**
513      * @dev Returns the number of tokens in `owner`'s account.
514      */
515     function balanceOf(address owner) external view returns (uint256 balance);
516 
517     /**
518      * @dev Returns the owner of the `tokenId` token.
519      *
520      * Requirements:
521      *
522      * - `tokenId` must exist.
523      */
524     function ownerOf(uint256 tokenId) external view returns (address owner);
525 
526     /**
527      * @dev Safely transfers `tokenId` token from `from` to `to`,
528      * checking first that contract recipients are aware of the ERC721 protocol
529      * to prevent tokens from being forever locked.
530      *
531      * Requirements:
532      *
533      * - `from` cannot be the zero address.
534      * - `to` cannot be the zero address.
535      * - `tokenId` token must exist and be owned by `from`.
536      * - If the caller is not `from`, it must be have been allowed to move
537      * this token by either {approve} or {setApprovalForAll}.
538      * - If `to` refers to a smart contract, it must implement
539      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
540      *
541      * Emits a {Transfer} event.
542      */
543     function safeTransferFrom(
544         address from,
545         address to,
546         uint256 tokenId,
547         bytes calldata data
548     ) external payable;
549 
550     /**
551      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
552      */
553     function safeTransferFrom(
554         address from,
555         address to,
556         uint256 tokenId
557     ) external payable;
558 
559     /**
560      * @dev Transfers `tokenId` from `from` to `to`.
561      *
562      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
563      * whenever possible.
564      *
565      * Requirements:
566      *
567      * - `from` cannot be the zero address.
568      * - `to` cannot be the zero address.
569      * - `tokenId` token must be owned by `from`.
570      * - If the caller is not `from`, it must be approved to move this token
571      * by either {approve} or {setApprovalForAll}.
572      *
573      * Emits a {Transfer} event.
574      */
575     function transferFrom(
576         address from,
577         address to,
578         uint256 tokenId
579     ) external payable;
580 
581     /**
582      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
583      * The approval is cleared when the token is transferred.
584      *
585      * Only a single account can be approved at a time, so approving the
586      * zero address clears previous approvals.
587      *
588      * Requirements:
589      *
590      * - The caller must own the token or be an approved operator.
591      * - `tokenId` must exist.
592      *
593      * Emits an {Approval} event.
594      */
595     function approve(address to, uint256 tokenId) external payable;
596 
597     /**
598      * @dev Approve or remove `operator` as an operator for the caller.
599      * Operators can call {transferFrom} or {safeTransferFrom}
600      * for any token owned by the caller.
601      *
602      * Requirements:
603      *
604      * - The `operator` cannot be the caller.
605      *
606      * Emits an {ApprovalForAll} event.
607      */
608     function setApprovalForAll(address operator, bool _approved) external;
609 
610     /**
611      * @dev Returns the account approved for `tokenId` token.
612      *
613      * Requirements:
614      *
615      * - `tokenId` must exist.
616      */
617     function getApproved(uint256 tokenId) external view returns (address operator);
618 
619     /**
620      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
621      *
622      * See {setApprovalForAll}.
623      */
624     function isApprovedForAll(address owner, address operator) external view returns (bool);
625 
626     // =============================================================
627     //                        IERC721Metadata
628     // =============================================================
629 
630     /**
631      * @dev Returns the token collection name.
632      */
633     function name() external view returns (string memory);
634 
635     /**
636      * @dev Returns the token collection symbol.
637      */
638     function symbol() external view returns (string memory);
639 
640     /**
641      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
642      */
643     function tokenURI(uint256 tokenId) external view returns (string memory);
644 
645     // =============================================================
646     //                           IERC2309
647     // =============================================================
648 
649     /**
650      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
651      * (inclusive) is transferred from `from` to `to`, as defined in the
652      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
653      *
654      * See {_mintERC2309} for more details.
655      */
656     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
657 }
658 
659 // File: erc721a/contracts/extensions/IERC721AQueryable.sol
660 
661 
662 // ERC721A Contracts v4.2.3
663 // Creator: Chiru Labs
664 
665 pragma solidity ^0.8.4;
666 
667 
668 /**
669  * @dev Interface of ERC721AQueryable.
670  */
671 interface IERC721AQueryable is IERC721A {
672     /**
673      * Invalid query range (`start` >= `stop`).
674      */
675     error InvalidQueryRange();
676 
677     /**
678      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
679      *
680      * If the `tokenId` is out of bounds:
681      *
682      * - `addr = address(0)`
683      * - `startTimestamp = 0`
684      * - `burned = false`
685      * - `extraData = 0`
686      *
687      * If the `tokenId` is burned:
688      *
689      * - `addr = <Address of owner before token was burned>`
690      * - `startTimestamp = <Timestamp when token was burned>`
691      * - `burned = true`
692      * - `extraData = <Extra data when token was burned>`
693      *
694      * Otherwise:
695      *
696      * - `addr = <Address of owner>`
697      * - `startTimestamp = <Timestamp of start of ownership>`
698      * - `burned = false`
699      * - `extraData = <Extra data at start of ownership>`
700      */
701     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
702 
703     /**
704      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
705      * See {ERC721AQueryable-explicitOwnershipOf}
706      */
707     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
708 
709     /**
710      * @dev Returns an array of token IDs owned by `owner`,
711      * in the range [`start`, `stop`)
712      * (i.e. `start <= tokenId < stop`).
713      *
714      * This function allows for tokens to be queried if the collection
715      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
716      *
717      * Requirements:
718      *
719      * - `start < stop`
720      */
721     function tokensOfOwnerIn(
722         address owner,
723         uint256 start,
724         uint256 stop
725     ) external view returns (uint256[] memory);
726 
727     /**
728      * @dev Returns an array of token IDs owned by `owner`.
729      *
730      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
731      * It is meant to be called off-chain.
732      *
733      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
734      * multiple smaller scans if the collection is large enough to cause
735      * an out-of-gas error (10K collections should be fine).
736      */
737     function tokensOfOwner(address owner) external view returns (uint256[] memory);
738 }
739 
740 // File: erc721a/contracts/extensions/IERC721ABurnable.sol
741 
742 
743 // ERC721A Contracts v4.2.3
744 // Creator: Chiru Labs
745 
746 pragma solidity ^0.8.4;
747 
748 
749 /**
750  * @dev Interface of ERC721ABurnable.
751  */
752 interface IERC721ABurnable is IERC721A {
753     /**
754      * @dev Burns `tokenId`. See {ERC721A-_burn}.
755      *
756      * Requirements:
757      *
758      * - The caller must own `tokenId` or be an approved operator.
759      */
760     function burn(uint256 tokenId) external;
761 }
762 
763 // File: erc721a/contracts/ERC721A.sol
764 
765 
766 // ERC721A Contracts v4.2.3
767 // Creator: Chiru Labs
768 
769 pragma solidity ^0.8.4;
770 
771 
772 /**
773  * @dev Interface of ERC721 token receiver.
774  */
775 interface ERC721A__IERC721Receiver {
776     function onERC721Received(
777         address operator,
778         address from,
779         uint256 tokenId,
780         bytes calldata data
781     ) external returns (bytes4);
782 }
783 
784 /**
785  * @title ERC721A
786  *
787  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
788  * Non-Fungible Token Standard, including the Metadata extension.
789  * Optimized for lower gas during batch mints.
790  *
791  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
792  * starting from `_startTokenId()`.
793  *
794  * Assumptions:
795  *
796  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
797  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
798  */
799 contract ERC721A is IERC721A {
800     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
801     struct TokenApprovalRef {
802         address value;
803     }
804 
805     // =============================================================
806     //                           CONSTANTS
807     // =============================================================
808 
809     // Mask of an entry in packed address data.
810     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
811 
812     // The bit position of `numberMinted` in packed address data.
813     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
814 
815     // The bit position of `numberBurned` in packed address data.
816     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
817 
818     // The bit position of `aux` in packed address data.
819     uint256 private constant _BITPOS_AUX = 192;
820 
821     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
822     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
823 
824     // The bit position of `startTimestamp` in packed ownership.
825     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
826 
827     // The bit mask of the `burned` bit in packed ownership.
828     uint256 private constant _BITMASK_BURNED = 1 << 224;
829 
830     // The bit position of the `nextInitialized` bit in packed ownership.
831     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
832 
833     // The bit mask of the `nextInitialized` bit in packed ownership.
834     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
835 
836     // The bit position of `extraData` in packed ownership.
837     uint256 private constant _BITPOS_EXTRA_DATA = 232;
838 
839     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
840     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
841 
842     // The mask of the lower 160 bits for addresses.
843     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
844 
845     // The maximum `quantity` that can be minted with {_mintERC2309}.
846     // This limit is to prevent overflows on the address data entries.
847     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
848     // is required to cause an overflow, which is unrealistic.
849     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
850 
851     // The `Transfer` event signature is given by:
852     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
853     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
854         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
855 
856     // =============================================================
857     //                            STORAGE
858     // =============================================================
859 
860     // The next token ID to be minted.
861     uint256 private _currentIndex;
862 
863     // The number of tokens burned.
864     uint256 private _burnCounter;
865 
866     // Token name
867     string private _name;
868 
869     // Token symbol
870     string private _symbol;
871 
872     // Mapping from token ID to ownership details
873     // An empty struct value does not necessarily mean the token is unowned.
874     // See {_packedOwnershipOf} implementation for details.
875     //
876     // Bits Layout:
877     // - [0..159]   `addr`
878     // - [160..223] `startTimestamp`
879     // - [224]      `burned`
880     // - [225]      `nextInitialized`
881     // - [232..255] `extraData`
882     mapping(uint256 => uint256) private _packedOwnerships;
883 
884     // Mapping owner address to address data.
885     //
886     // Bits Layout:
887     // - [0..63]    `balance`
888     // - [64..127]  `numberMinted`
889     // - [128..191] `numberBurned`
890     // - [192..255] `aux`
891     mapping(address => uint256) private _packedAddressData;
892 
893     // Mapping from token ID to approved address.
894     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
895 
896     // Mapping from owner to operator approvals
897     mapping(address => mapping(address => bool)) private _operatorApprovals;
898 
899     // =============================================================
900     //                          CONSTRUCTOR
901     // =============================================================
902 
903     constructor(string memory name_, string memory symbol_) {
904         _name = name_;
905         _symbol = symbol_;
906         _currentIndex = _startTokenId();
907     }
908 
909     // =============================================================
910     //                   TOKEN COUNTING OPERATIONS
911     // =============================================================
912 
913     /**
914      * @dev Returns the starting token ID.
915      * To change the starting token ID, please override this function.
916      */
917     function _startTokenId() internal view virtual returns (uint256) {
918         return 0;
919     }
920 
921     /**
922      * @dev Returns the next token ID to be minted.
923      */
924     function _nextTokenId() internal view virtual returns (uint256) {
925         return _currentIndex;
926     }
927 
928     /**
929      * @dev Returns the total number of tokens in existence.
930      * Burned tokens will reduce the count.
931      * To get the total number of tokens minted, please see {_totalMinted}.
932      */
933     function totalSupply() public view virtual override returns (uint256) {
934         // Counter underflow is impossible as _burnCounter cannot be incremented
935         // more than `_currentIndex - _startTokenId()` times.
936         unchecked {
937             return _currentIndex - _burnCounter - _startTokenId();
938         }
939     }
940 
941     /**
942      * @dev Returns the total amount of tokens minted in the contract.
943      */
944     function _totalMinted() internal view virtual returns (uint256) {
945         // Counter underflow is impossible as `_currentIndex` does not decrement,
946         // and it is initialized to `_startTokenId()`.
947         unchecked {
948             return _currentIndex - _startTokenId();
949         }
950     }
951 
952     /**
953      * @dev Returns the total number of tokens burned.
954      */
955     function _totalBurned() internal view virtual returns (uint256) {
956         return _burnCounter;
957     }
958 
959     // =============================================================
960     //                    ADDRESS DATA OPERATIONS
961     // =============================================================
962 
963     /**
964      * @dev Returns the number of tokens in `owner`'s account.
965      */
966     function balanceOf(address owner) public view virtual override returns (uint256) {
967         if (owner == address(0)) revert BalanceQueryForZeroAddress();
968         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
969     }
970 
971     /**
972      * Returns the number of tokens minted by `owner`.
973      */
974     function _numberMinted(address owner) internal view returns (uint256) {
975         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
976     }
977 
978     /**
979      * Returns the number of tokens burned by or on behalf of `owner`.
980      */
981     function _numberBurned(address owner) internal view returns (uint256) {
982         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
983     }
984 
985     /**
986      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
987      */
988     function _getAux(address owner) internal view returns (uint64) {
989         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
990     }
991 
992     /**
993      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
994      * If there are multiple variables, please pack them into a uint64.
995      */
996     function _setAux(address owner, uint64 aux) internal virtual {
997         uint256 packed = _packedAddressData[owner];
998         uint256 auxCasted;
999         // Cast `aux` with assembly to avoid redundant masking.
1000         assembly {
1001             auxCasted := aux
1002         }
1003         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1004         _packedAddressData[owner] = packed;
1005     }
1006 
1007     // =============================================================
1008     //                            IERC165
1009     // =============================================================
1010 
1011     /**
1012      * @dev Returns true if this contract implements the interface defined by
1013      * `interfaceId`. See the corresponding
1014      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1015      * to learn more about how these ids are created.
1016      *
1017      * This function call must use less than 30000 gas.
1018      */
1019     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1020         // The interface IDs are constants representing the first 4 bytes
1021         // of the XOR of all function selectors in the interface.
1022         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1023         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1024         return
1025             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1026             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1027             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1028     }
1029 
1030     // =============================================================
1031     //                        IERC721Metadata
1032     // =============================================================
1033 
1034     /**
1035      * @dev Returns the token collection name.
1036      */
1037     function name() public view virtual override returns (string memory) {
1038         return _name;
1039     }
1040 
1041     /**
1042      * @dev Returns the token collection symbol.
1043      */
1044     function symbol() public view virtual override returns (string memory) {
1045         return _symbol;
1046     }
1047 
1048     /**
1049      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1050      */
1051     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1052         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1053 
1054         string memory baseURI = _baseURI();
1055         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1056     }
1057 
1058     /**
1059      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1060      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1061      * by default, it can be overridden in child contracts.
1062      */
1063     function _baseURI() internal view virtual returns (string memory) {
1064         return '';
1065     }
1066 
1067     // =============================================================
1068     //                     OWNERSHIPS OPERATIONS
1069     // =============================================================
1070 
1071     /**
1072      * @dev Returns the owner of the `tokenId` token.
1073      *
1074      * Requirements:
1075      *
1076      * - `tokenId` must exist.
1077      */
1078     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1079         return address(uint160(_packedOwnershipOf(tokenId)));
1080     }
1081 
1082     /**
1083      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1084      * It gradually moves to O(1) as tokens get transferred around over time.
1085      */
1086     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1087         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1088     }
1089 
1090     /**
1091      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1092      */
1093     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1094         return _unpackedOwnership(_packedOwnerships[index]);
1095     }
1096 
1097     /**
1098      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1099      */
1100     function _initializeOwnershipAt(uint256 index) internal virtual {
1101         if (_packedOwnerships[index] == 0) {
1102             _packedOwnerships[index] = _packedOwnershipOf(index);
1103         }
1104     }
1105 
1106     /**
1107      * Returns the packed ownership data of `tokenId`.
1108      */
1109     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256 packed) {
1110         if (_startTokenId() <= tokenId) {
1111             packed = _packedOwnerships[tokenId];
1112             // If not burned.
1113             if (packed & _BITMASK_BURNED == 0) {
1114                 // If the data at the starting slot does not exist, start the scan.
1115                 if (packed == 0) {
1116                     if (tokenId >= _currentIndex) revert OwnerQueryForNonexistentToken();
1117                     // Invariant:
1118                     // There will always be an initialized ownership slot
1119                     // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1120                     // before an unintialized ownership slot
1121                     // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1122                     // Hence, `tokenId` will not underflow.
1123                     //
1124                     // We can directly compare the packed value.
1125                     // If the address is zero, packed will be zero.
1126                     for (;;) {
1127                         unchecked {
1128                             packed = _packedOwnerships[--tokenId];
1129                         }
1130                         if (packed == 0) continue;
1131                         return packed;
1132                     }
1133                 }
1134                 // Otherwise, the data exists and is not burned. We can skip the scan.
1135                 // This is possible because we have already achieved the target condition.
1136                 // This saves 2143 gas on transfers of initialized tokens.
1137                 return packed;
1138             }
1139         }
1140         revert OwnerQueryForNonexistentToken();
1141     }
1142 
1143     /**
1144      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1145      */
1146     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1147         ownership.addr = address(uint160(packed));
1148         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1149         ownership.burned = packed & _BITMASK_BURNED != 0;
1150         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1151     }
1152 
1153     /**
1154      * @dev Packs ownership data into a single uint256.
1155      */
1156     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1157         assembly {
1158             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1159             owner := and(owner, _BITMASK_ADDRESS)
1160             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1161             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1162         }
1163     }
1164 
1165     /**
1166      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1167      */
1168     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1169         // For branchless setting of the `nextInitialized` flag.
1170         assembly {
1171             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1172             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1173         }
1174     }
1175 
1176     // =============================================================
1177     //                      APPROVAL OPERATIONS
1178     // =============================================================
1179 
1180     /**
1181      * @dev Gives permission to `to` to transfer `tokenId` token to another account. See {ERC721A-_approve}.
1182      *
1183      * Requirements:
1184      *
1185      * - The caller must own the token or be an approved operator.
1186      */
1187     function approve(address to, uint256 tokenId) public payable virtual override {
1188         _approve(to, tokenId, true);
1189     }
1190 
1191     /**
1192      * @dev Returns the account approved for `tokenId` token.
1193      *
1194      * Requirements:
1195      *
1196      * - `tokenId` must exist.
1197      */
1198     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1199         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1200 
1201         return _tokenApprovals[tokenId].value;
1202     }
1203 
1204     /**
1205      * @dev Approve or remove `operator` as an operator for the caller.
1206      * Operators can call {transferFrom} or {safeTransferFrom}
1207      * for any token owned by the caller.
1208      *
1209      * Requirements:
1210      *
1211      * - The `operator` cannot be the caller.
1212      *
1213      * Emits an {ApprovalForAll} event.
1214      */
1215     function setApprovalForAll(address operator, bool approved) public virtual override {
1216         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1217         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1218     }
1219 
1220     /**
1221      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1222      *
1223      * See {setApprovalForAll}.
1224      */
1225     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1226         return _operatorApprovals[owner][operator];
1227     }
1228 
1229     /**
1230      * @dev Returns whether `tokenId` exists.
1231      *
1232      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1233      *
1234      * Tokens start existing when they are minted. See {_mint}.
1235      */
1236     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1237         return
1238             _startTokenId() <= tokenId &&
1239             tokenId < _currentIndex && // If within bounds,
1240             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1241     }
1242 
1243     /**
1244      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1245      */
1246     function _isSenderApprovedOrOwner(
1247         address approvedAddress,
1248         address owner,
1249         address msgSender
1250     ) private pure returns (bool result) {
1251         assembly {
1252             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1253             owner := and(owner, _BITMASK_ADDRESS)
1254             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1255             msgSender := and(msgSender, _BITMASK_ADDRESS)
1256             // `msgSender == owner || msgSender == approvedAddress`.
1257             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1258         }
1259     }
1260 
1261     /**
1262      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1263      */
1264     function _getApprovedSlotAndAddress(uint256 tokenId)
1265         private
1266         view
1267         returns (uint256 approvedAddressSlot, address approvedAddress)
1268     {
1269         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1270         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1271         assembly {
1272             approvedAddressSlot := tokenApproval.slot
1273             approvedAddress := sload(approvedAddressSlot)
1274         }
1275     }
1276 
1277     // =============================================================
1278     //                      TRANSFER OPERATIONS
1279     // =============================================================
1280 
1281     /**
1282      * @dev Transfers `tokenId` from `from` to `to`.
1283      *
1284      * Requirements:
1285      *
1286      * - `from` cannot be the zero address.
1287      * - `to` cannot be the zero address.
1288      * - `tokenId` token must be owned by `from`.
1289      * - If the caller is not `from`, it must be approved to move this token
1290      * by either {approve} or {setApprovalForAll}.
1291      *
1292      * Emits a {Transfer} event.
1293      */
1294     function transferFrom(
1295         address from,
1296         address to,
1297         uint256 tokenId
1298     ) public payable virtual override {
1299         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1300 
1301         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1302 
1303         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1304 
1305         // The nested ifs save around 20+ gas over a compound boolean condition.
1306         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1307             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1308 
1309         if (to == address(0)) revert TransferToZeroAddress();
1310 
1311         _beforeTokenTransfers(from, to, tokenId, 1);
1312 
1313         // Clear approvals from the previous owner.
1314         assembly {
1315             if approvedAddress {
1316                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1317                 sstore(approvedAddressSlot, 0)
1318             }
1319         }
1320 
1321         // Underflow of the sender's balance is impossible because we check for
1322         // ownership above and the recipient's balance can't realistically overflow.
1323         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1324         unchecked {
1325             // We can directly increment and decrement the balances.
1326             --_packedAddressData[from]; // Updates: `balance -= 1`.
1327             ++_packedAddressData[to]; // Updates: `balance += 1`.
1328 
1329             // Updates:
1330             // - `address` to the next owner.
1331             // - `startTimestamp` to the timestamp of transfering.
1332             // - `burned` to `false`.
1333             // - `nextInitialized` to `true`.
1334             _packedOwnerships[tokenId] = _packOwnershipData(
1335                 to,
1336                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1337             );
1338 
1339             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1340             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1341                 uint256 nextTokenId = tokenId + 1;
1342                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1343                 if (_packedOwnerships[nextTokenId] == 0) {
1344                     // If the next slot is within bounds.
1345                     if (nextTokenId != _currentIndex) {
1346                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1347                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1348                     }
1349                 }
1350             }
1351         }
1352 
1353         emit Transfer(from, to, tokenId);
1354         _afterTokenTransfers(from, to, tokenId, 1);
1355     }
1356 
1357     /**
1358      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1359      */
1360     function safeTransferFrom(
1361         address from,
1362         address to,
1363         uint256 tokenId
1364     ) public payable virtual override {
1365         safeTransferFrom(from, to, tokenId, '');
1366     }
1367 
1368     /**
1369      * @dev Safely transfers `tokenId` token from `from` to `to`.
1370      *
1371      * Requirements:
1372      *
1373      * - `from` cannot be the zero address.
1374      * - `to` cannot be the zero address.
1375      * - `tokenId` token must exist and be owned by `from`.
1376      * - If the caller is not `from`, it must be approved to move this token
1377      * by either {approve} or {setApprovalForAll}.
1378      * - If `to` refers to a smart contract, it must implement
1379      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1380      *
1381      * Emits a {Transfer} event.
1382      */
1383     function safeTransferFrom(
1384         address from,
1385         address to,
1386         uint256 tokenId,
1387         bytes memory _data
1388     ) public payable virtual override {
1389         transferFrom(from, to, tokenId);
1390         if (to.code.length != 0)
1391             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1392                 revert TransferToNonERC721ReceiverImplementer();
1393             }
1394     }
1395 
1396     /**
1397      * @dev Hook that is called before a set of serially-ordered token IDs
1398      * are about to be transferred. This includes minting.
1399      * And also called before burning one token.
1400      *
1401      * `startTokenId` - the first token ID to be transferred.
1402      * `quantity` - the amount to be transferred.
1403      *
1404      * Calling conditions:
1405      *
1406      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1407      * transferred to `to`.
1408      * - When `from` is zero, `tokenId` will be minted for `to`.
1409      * - When `to` is zero, `tokenId` will be burned by `from`.
1410      * - `from` and `to` are never both zero.
1411      */
1412     function _beforeTokenTransfers(
1413         address from,
1414         address to,
1415         uint256 startTokenId,
1416         uint256 quantity
1417     ) internal virtual {}
1418 
1419     /**
1420      * @dev Hook that is called after a set of serially-ordered token IDs
1421      * have been transferred. This includes minting.
1422      * And also called after one token has been burned.
1423      *
1424      * `startTokenId` - the first token ID to be transferred.
1425      * `quantity` - the amount to be transferred.
1426      *
1427      * Calling conditions:
1428      *
1429      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1430      * transferred to `to`.
1431      * - When `from` is zero, `tokenId` has been minted for `to`.
1432      * - When `to` is zero, `tokenId` has been burned by `from`.
1433      * - `from` and `to` are never both zero.
1434      */
1435     function _afterTokenTransfers(
1436         address from,
1437         address to,
1438         uint256 startTokenId,
1439         uint256 quantity
1440     ) internal virtual {}
1441 
1442     /**
1443      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1444      *
1445      * `from` - Previous owner of the given token ID.
1446      * `to` - Target address that will receive the token.
1447      * `tokenId` - Token ID to be transferred.
1448      * `_data` - Optional data to send along with the call.
1449      *
1450      * Returns whether the call correctly returned the expected magic value.
1451      */
1452     function _checkContractOnERC721Received(
1453         address from,
1454         address to,
1455         uint256 tokenId,
1456         bytes memory _data
1457     ) private returns (bool) {
1458         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1459             bytes4 retval
1460         ) {
1461             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1462         } catch (bytes memory reason) {
1463             if (reason.length == 0) {
1464                 revert TransferToNonERC721ReceiverImplementer();
1465             } else {
1466                 assembly {
1467                     revert(add(32, reason), mload(reason))
1468                 }
1469             }
1470         }
1471     }
1472 
1473     // =============================================================
1474     //                        MINT OPERATIONS
1475     // =============================================================
1476 
1477     /**
1478      * @dev Mints `quantity` tokens and transfers them to `to`.
1479      *
1480      * Requirements:
1481      *
1482      * - `to` cannot be the zero address.
1483      * - `quantity` must be greater than 0.
1484      *
1485      * Emits a {Transfer} event for each mint.
1486      */
1487     function _mint(address to, uint256 quantity) internal virtual {
1488         uint256 startTokenId = _currentIndex;
1489         if (quantity == 0) revert MintZeroQuantity();
1490 
1491         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1492 
1493         // Overflows are incredibly unrealistic.
1494         // `balance` and `numberMinted` have a maximum limit of 2**64.
1495         // `tokenId` has a maximum limit of 2**256.
1496         unchecked {
1497             // Updates:
1498             // - `balance += quantity`.
1499             // - `numberMinted += quantity`.
1500             //
1501             // We can directly add to the `balance` and `numberMinted`.
1502             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1503 
1504             // Updates:
1505             // - `address` to the owner.
1506             // - `startTimestamp` to the timestamp of minting.
1507             // - `burned` to `false`.
1508             // - `nextInitialized` to `quantity == 1`.
1509             _packedOwnerships[startTokenId] = _packOwnershipData(
1510                 to,
1511                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1512             );
1513 
1514             uint256 toMasked;
1515             uint256 end = startTokenId + quantity;
1516 
1517             // Use assembly to loop and emit the `Transfer` event for gas savings.
1518             // The duplicated `log4` removes an extra check and reduces stack juggling.
1519             // The assembly, together with the surrounding Solidity code, have been
1520             // delicately arranged to nudge the compiler into producing optimized opcodes.
1521             assembly {
1522                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1523                 toMasked := and(to, _BITMASK_ADDRESS)
1524                 // Emit the `Transfer` event.
1525                 log4(
1526                     0, // Start of data (0, since no data).
1527                     0, // End of data (0, since no data).
1528                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1529                     0, // `address(0)`.
1530                     toMasked, // `to`.
1531                     startTokenId // `tokenId`.
1532                 )
1533 
1534                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1535                 // that overflows uint256 will make the loop run out of gas.
1536                 // The compiler will optimize the `iszero` away for performance.
1537                 for {
1538                     let tokenId := add(startTokenId, 1)
1539                 } iszero(eq(tokenId, end)) {
1540                     tokenId := add(tokenId, 1)
1541                 } {
1542                     // Emit the `Transfer` event. Similar to above.
1543                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1544                 }
1545             }
1546             if (toMasked == 0) revert MintToZeroAddress();
1547 
1548             _currentIndex = end;
1549         }
1550         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1551     }
1552 
1553     /**
1554      * @dev Mints `quantity` tokens and transfers them to `to`.
1555      *
1556      * This function is intended for efficient minting only during contract creation.
1557      *
1558      * It emits only one {ConsecutiveTransfer} as defined in
1559      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1560      * instead of a sequence of {Transfer} event(s).
1561      *
1562      * Calling this function outside of contract creation WILL make your contract
1563      * non-compliant with the ERC721 standard.
1564      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1565      * {ConsecutiveTransfer} event is only permissible during contract creation.
1566      *
1567      * Requirements:
1568      *
1569      * - `to` cannot be the zero address.
1570      * - `quantity` must be greater than 0.
1571      *
1572      * Emits a {ConsecutiveTransfer} event.
1573      */
1574     function _mintERC2309(address to, uint256 quantity) internal virtual {
1575         uint256 startTokenId = _currentIndex;
1576         if (to == address(0)) revert MintToZeroAddress();
1577         if (quantity == 0) revert MintZeroQuantity();
1578         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1579 
1580         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1581 
1582         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1583         unchecked {
1584             // Updates:
1585             // - `balance += quantity`.
1586             // - `numberMinted += quantity`.
1587             //
1588             // We can directly add to the `balance` and `numberMinted`.
1589             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1590 
1591             // Updates:
1592             // - `address` to the owner.
1593             // - `startTimestamp` to the timestamp of minting.
1594             // - `burned` to `false`.
1595             // - `nextInitialized` to `quantity == 1`.
1596             _packedOwnerships[startTokenId] = _packOwnershipData(
1597                 to,
1598                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1599             );
1600 
1601             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1602 
1603             _currentIndex = startTokenId + quantity;
1604         }
1605         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1606     }
1607 
1608     /**
1609      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1610      *
1611      * Requirements:
1612      *
1613      * - If `to` refers to a smart contract, it must implement
1614      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1615      * - `quantity` must be greater than 0.
1616      *
1617      * See {_mint}.
1618      *
1619      * Emits a {Transfer} event for each mint.
1620      */
1621     function _safeMint(
1622         address to,
1623         uint256 quantity,
1624         bytes memory _data
1625     ) internal virtual {
1626         _mint(to, quantity);
1627 
1628         unchecked {
1629             if (to.code.length != 0) {
1630                 uint256 end = _currentIndex;
1631                 uint256 index = end - quantity;
1632                 do {
1633                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1634                         revert TransferToNonERC721ReceiverImplementer();
1635                     }
1636                 } while (index < end);
1637                 // Reentrancy protection.
1638                 if (_currentIndex != end) revert();
1639             }
1640         }
1641     }
1642 
1643     /**
1644      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1645      */
1646     function _safeMint(address to, uint256 quantity) internal virtual {
1647         _safeMint(to, quantity, '');
1648     }
1649 
1650     // =============================================================
1651     //                       APPROVAL OPERATIONS
1652     // =============================================================
1653 
1654     /**
1655      * @dev Equivalent to `_approve(to, tokenId, false)`.
1656      */
1657     function _approve(address to, uint256 tokenId) internal virtual {
1658         _approve(to, tokenId, false);
1659     }
1660 
1661     /**
1662      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1663      * The approval is cleared when the token is transferred.
1664      *
1665      * Only a single account can be approved at a time, so approving the
1666      * zero address clears previous approvals.
1667      *
1668      * Requirements:
1669      *
1670      * - `tokenId` must exist.
1671      *
1672      * Emits an {Approval} event.
1673      */
1674     function _approve(
1675         address to,
1676         uint256 tokenId,
1677         bool approvalCheck
1678     ) internal virtual {
1679         address owner = ownerOf(tokenId);
1680 
1681         if (approvalCheck)
1682             if (_msgSenderERC721A() != owner)
1683                 if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1684                     revert ApprovalCallerNotOwnerNorApproved();
1685                 }
1686 
1687         _tokenApprovals[tokenId].value = to;
1688         emit Approval(owner, to, tokenId);
1689     }
1690 
1691     // =============================================================
1692     //                        BURN OPERATIONS
1693     // =============================================================
1694 
1695     /**
1696      * @dev Equivalent to `_burn(tokenId, false)`.
1697      */
1698     function _burn(uint256 tokenId) internal virtual {
1699         _burn(tokenId, false);
1700     }
1701 
1702     /**
1703      * @dev Destroys `tokenId`.
1704      * The approval is cleared when the token is burned.
1705      *
1706      * Requirements:
1707      *
1708      * - `tokenId` must exist.
1709      *
1710      * Emits a {Transfer} event.
1711      */
1712     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1713         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1714 
1715         address from = address(uint160(prevOwnershipPacked));
1716 
1717         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1718 
1719         if (approvalCheck) {
1720             // The nested ifs save around 20+ gas over a compound boolean condition.
1721             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1722                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1723         }
1724 
1725         _beforeTokenTransfers(from, address(0), tokenId, 1);
1726 
1727         // Clear approvals from the previous owner.
1728         assembly {
1729             if approvedAddress {
1730                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1731                 sstore(approvedAddressSlot, 0)
1732             }
1733         }
1734 
1735         // Underflow of the sender's balance is impossible because we check for
1736         // ownership above and the recipient's balance can't realistically overflow.
1737         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1738         unchecked {
1739             // Updates:
1740             // - `balance -= 1`.
1741             // - `numberBurned += 1`.
1742             //
1743             // We can directly decrement the balance, and increment the number burned.
1744             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1745             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1746 
1747             // Updates:
1748             // - `address` to the last owner.
1749             // - `startTimestamp` to the timestamp of burning.
1750             // - `burned` to `true`.
1751             // - `nextInitialized` to `true`.
1752             _packedOwnerships[tokenId] = _packOwnershipData(
1753                 from,
1754                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1755             );
1756 
1757             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1758             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1759                 uint256 nextTokenId = tokenId + 1;
1760                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1761                 if (_packedOwnerships[nextTokenId] == 0) {
1762                     // If the next slot is within bounds.
1763                     if (nextTokenId != _currentIndex) {
1764                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1765                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1766                     }
1767                 }
1768             }
1769         }
1770 
1771         emit Transfer(from, address(0), tokenId);
1772         _afterTokenTransfers(from, address(0), tokenId, 1);
1773 
1774         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1775         unchecked {
1776             _burnCounter++;
1777         }
1778     }
1779 
1780     // =============================================================
1781     //                     EXTRA DATA OPERATIONS
1782     // =============================================================
1783 
1784     /**
1785      * @dev Directly sets the extra data for the ownership data `index`.
1786      */
1787     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1788         uint256 packed = _packedOwnerships[index];
1789         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1790         uint256 extraDataCasted;
1791         // Cast `extraData` with assembly to avoid redundant masking.
1792         assembly {
1793             extraDataCasted := extraData
1794         }
1795         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1796         _packedOwnerships[index] = packed;
1797     }
1798 
1799     /**
1800      * @dev Called during each token transfer to set the 24bit `extraData` field.
1801      * Intended to be overridden by the cosumer contract.
1802      *
1803      * `previousExtraData` - the value of `extraData` before transfer.
1804      *
1805      * Calling conditions:
1806      *
1807      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1808      * transferred to `to`.
1809      * - When `from` is zero, `tokenId` will be minted for `to`.
1810      * - When `to` is zero, `tokenId` will be burned by `from`.
1811      * - `from` and `to` are never both zero.
1812      */
1813     function _extraData(
1814         address from,
1815         address to,
1816         uint24 previousExtraData
1817     ) internal view virtual returns (uint24) {}
1818 
1819     /**
1820      * @dev Returns the next extra data for the packed ownership data.
1821      * The returned result is shifted into position.
1822      */
1823     function _nextExtraData(
1824         address from,
1825         address to,
1826         uint256 prevOwnershipPacked
1827     ) private view returns (uint256) {
1828         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1829         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1830     }
1831 
1832     // =============================================================
1833     //                       OTHER OPERATIONS
1834     // =============================================================
1835 
1836     /**
1837      * @dev Returns the message sender (defaults to `msg.sender`).
1838      *
1839      * If you are writing GSN compatible contracts, you need to override this function.
1840      */
1841     function _msgSenderERC721A() internal view virtual returns (address) {
1842         return msg.sender;
1843     }
1844 
1845     /**
1846      * @dev Converts a uint256 to its ASCII string decimal representation.
1847      */
1848     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1849         assembly {
1850             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1851             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1852             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1853             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1854             let m := add(mload(0x40), 0xa0)
1855             // Update the free memory pointer to allocate.
1856             mstore(0x40, m)
1857             // Assign the `str` to the end.
1858             str := sub(m, 0x20)
1859             // Zeroize the slot after the string.
1860             mstore(str, 0)
1861 
1862             // Cache the end of the memory to calculate the length later.
1863             let end := str
1864 
1865             // We write the string from rightmost digit to leftmost digit.
1866             // The following is essentially a do-while loop that also handles the zero case.
1867             // prettier-ignore
1868             for { let temp := value } 1 {} {
1869                 str := sub(str, 1)
1870                 // Write the character to the pointer.
1871                 // The ASCII index of the '0' character is 48.
1872                 mstore8(str, add(48, mod(temp, 10)))
1873                 // Keep dividing `temp` until zero.
1874                 temp := div(temp, 10)
1875                 // prettier-ignore
1876                 if iszero(temp) { break }
1877             }
1878 
1879             let length := sub(end, str)
1880             // Move the pointer 32 bytes leftwards to make room for the length.
1881             str := sub(str, 0x20)
1882             // Store the length.
1883             mstore(str, length)
1884         }
1885     }
1886 }
1887 
1888 // File: erc721a/contracts/extensions/ERC721AQueryable.sol
1889 
1890 
1891 // ERC721A Contracts v4.2.3
1892 // Creator: Chiru Labs
1893 
1894 pragma solidity ^0.8.4;
1895 
1896 
1897 
1898 /**
1899  * @title ERC721AQueryable.
1900  *
1901  * @dev ERC721A subclass with convenience query functions.
1902  */
1903 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1904     /**
1905      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1906      *
1907      * If the `tokenId` is out of bounds:
1908      *
1909      * - `addr = address(0)`
1910      * - `startTimestamp = 0`
1911      * - `burned = false`
1912      * - `extraData = 0`
1913      *
1914      * If the `tokenId` is burned:
1915      *
1916      * - `addr = <Address of owner before token was burned>`
1917      * - `startTimestamp = <Timestamp when token was burned>`
1918      * - `burned = true`
1919      * - `extraData = <Extra data when token was burned>`
1920      *
1921      * Otherwise:
1922      *
1923      * - `addr = <Address of owner>`
1924      * - `startTimestamp = <Timestamp of start of ownership>`
1925      * - `burned = false`
1926      * - `extraData = <Extra data at start of ownership>`
1927      */
1928     function explicitOwnershipOf(uint256 tokenId) public view virtual override returns (TokenOwnership memory) {
1929         TokenOwnership memory ownership;
1930         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
1931             return ownership;
1932         }
1933         ownership = _ownershipAt(tokenId);
1934         if (ownership.burned) {
1935             return ownership;
1936         }
1937         return _ownershipOf(tokenId);
1938     }
1939 
1940     /**
1941      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1942      * See {ERC721AQueryable-explicitOwnershipOf}
1943      */
1944     function explicitOwnershipsOf(uint256[] calldata tokenIds)
1945         external
1946         view
1947         virtual
1948         override
1949         returns (TokenOwnership[] memory)
1950     {
1951         unchecked {
1952             uint256 tokenIdsLength = tokenIds.length;
1953             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1954             for (uint256 i; i != tokenIdsLength; ++i) {
1955                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1956             }
1957             return ownerships;
1958         }
1959     }
1960 
1961     /**
1962      * @dev Returns an array of token IDs owned by `owner`,
1963      * in the range [`start`, `stop`)
1964      * (i.e. `start <= tokenId < stop`).
1965      *
1966      * This function allows for tokens to be queried if the collection
1967      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1968      *
1969      * Requirements:
1970      *
1971      * - `start < stop`
1972      */
1973     function tokensOfOwnerIn(
1974         address owner,
1975         uint256 start,
1976         uint256 stop
1977     ) external view virtual override returns (uint256[] memory) {
1978         unchecked {
1979             if (start >= stop) revert InvalidQueryRange();
1980             uint256 tokenIdsIdx;
1981             uint256 stopLimit = _nextTokenId();
1982             // Set `start = max(start, _startTokenId())`.
1983             if (start < _startTokenId()) {
1984                 start = _startTokenId();
1985             }
1986             // Set `stop = min(stop, stopLimit)`.
1987             if (stop > stopLimit) {
1988                 stop = stopLimit;
1989             }
1990             uint256 tokenIdsMaxLength = balanceOf(owner);
1991             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1992             // to cater for cases where `balanceOf(owner)` is too big.
1993             if (start < stop) {
1994                 uint256 rangeLength = stop - start;
1995                 if (rangeLength < tokenIdsMaxLength) {
1996                     tokenIdsMaxLength = rangeLength;
1997                 }
1998             } else {
1999                 tokenIdsMaxLength = 0;
2000             }
2001             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
2002             if (tokenIdsMaxLength == 0) {
2003                 return tokenIds;
2004             }
2005             // We need to call `explicitOwnershipOf(start)`,
2006             // because the slot at `start` may not be initialized.
2007             TokenOwnership memory ownership = explicitOwnershipOf(start);
2008             address currOwnershipAddr;
2009             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
2010             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
2011             if (!ownership.burned) {
2012                 currOwnershipAddr = ownership.addr;
2013             }
2014             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
2015                 ownership = _ownershipAt(i);
2016                 if (ownership.burned) {
2017                     continue;
2018                 }
2019                 if (ownership.addr != address(0)) {
2020                     currOwnershipAddr = ownership.addr;
2021                 }
2022                 if (currOwnershipAddr == owner) {
2023                     tokenIds[tokenIdsIdx++] = i;
2024                 }
2025             }
2026             // Downsize the array to fit.
2027             assembly {
2028                 mstore(tokenIds, tokenIdsIdx)
2029             }
2030             return tokenIds;
2031         }
2032     }
2033 
2034     /**
2035      * @dev Returns an array of token IDs owned by `owner`.
2036      *
2037      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
2038      * It is meant to be called off-chain.
2039      *
2040      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
2041      * multiple smaller scans if the collection is large enough to cause
2042      * an out-of-gas error (10K collections should be fine).
2043      */
2044     function tokensOfOwner(address owner) external view virtual override returns (uint256[] memory) {
2045         unchecked {
2046             uint256 tokenIdsIdx;
2047             address currOwnershipAddr;
2048             uint256 tokenIdsLength = balanceOf(owner);
2049             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
2050             TokenOwnership memory ownership;
2051             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
2052                 ownership = _ownershipAt(i);
2053                 if (ownership.burned) {
2054                     continue;
2055                 }
2056                 if (ownership.addr != address(0)) {
2057                     currOwnershipAddr = ownership.addr;
2058                 }
2059                 if (currOwnershipAddr == owner) {
2060                     tokenIds[tokenIdsIdx++] = i;
2061                 }
2062             }
2063             return tokenIds;
2064         }
2065     }
2066 }
2067 
2068 // File: erc721a/contracts/extensions/ERC721ABurnable.sol
2069 
2070 
2071 // ERC721A Contracts v4.2.3
2072 // Creator: Chiru Labs
2073 
2074 pragma solidity ^0.8.4;
2075 
2076 
2077 
2078 /**
2079  * @title ERC721ABurnable.
2080  *
2081  * @dev ERC721A token that can be irreversibly burned (destroyed).
2082  */
2083 abstract contract ERC721ABurnable is ERC721A, IERC721ABurnable {
2084     /**
2085      * @dev Burns `tokenId`. See {ERC721A-_burn}.
2086      *
2087      * Requirements:
2088      *
2089      * - The caller must own `tokenId` or be an approved operator.
2090      */
2091     function burn(uint256 tokenId) public virtual override {
2092         _burn(tokenId, true);
2093     }
2094 }
2095 
2096 // File: @openzeppelin/contracts/utils/math/Math.sol
2097 
2098 
2099 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
2100 
2101 pragma solidity ^0.8.0;
2102 
2103 /**
2104  * @dev Standard math utilities missing in the Solidity language.
2105  */
2106 library Math {
2107     enum Rounding {
2108         Down, // Toward negative infinity
2109         Up, // Toward infinity
2110         Zero // Toward zero
2111     }
2112 
2113     /**
2114      * @dev Returns the largest of two numbers.
2115      */
2116     function max(uint256 a, uint256 b) internal pure returns (uint256) {
2117         return a > b ? a : b;
2118     }
2119 
2120     /**
2121      * @dev Returns the smallest of two numbers.
2122      */
2123     function min(uint256 a, uint256 b) internal pure returns (uint256) {
2124         return a < b ? a : b;
2125     }
2126 
2127     /**
2128      * @dev Returns the average of two numbers. The result is rounded towards
2129      * zero.
2130      */
2131     function average(uint256 a, uint256 b) internal pure returns (uint256) {
2132         // (a + b) / 2 can overflow.
2133         return (a & b) + (a ^ b) / 2;
2134     }
2135 
2136     /**
2137      * @dev Returns the ceiling of the division of two numbers.
2138      *
2139      * This differs from standard division with `/` in that it rounds up instead
2140      * of rounding down.
2141      */
2142     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
2143         // (a + b - 1) / b can overflow on addition, so we distribute.
2144         return a == 0 ? 0 : (a - 1) / b + 1;
2145     }
2146 
2147     /**
2148      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
2149      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
2150      * with further edits by Uniswap Labs also under MIT license.
2151      */
2152     function mulDiv(
2153         uint256 x,
2154         uint256 y,
2155         uint256 denominator
2156     ) internal pure returns (uint256 result) {
2157         unchecked {
2158             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
2159             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
2160             // variables such that product = prod1 * 2^256 + prod0.
2161             uint256 prod0; // Least significant 256 bits of the product
2162             uint256 prod1; // Most significant 256 bits of the product
2163             assembly {
2164                 let mm := mulmod(x, y, not(0))
2165                 prod0 := mul(x, y)
2166                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
2167             }
2168 
2169             // Handle non-overflow cases, 256 by 256 division.
2170             if (prod1 == 0) {
2171                 return prod0 / denominator;
2172             }
2173 
2174             // Make sure the result is less than 2^256. Also prevents denominator == 0.
2175             require(denominator > prod1);
2176 
2177             ///////////////////////////////////////////////
2178             // 512 by 256 division.
2179             ///////////////////////////////////////////////
2180 
2181             // Make division exact by subtracting the remainder from [prod1 prod0].
2182             uint256 remainder;
2183             assembly {
2184                 // Compute remainder using mulmod.
2185                 remainder := mulmod(x, y, denominator)
2186 
2187                 // Subtract 256 bit number from 512 bit number.
2188                 prod1 := sub(prod1, gt(remainder, prod0))
2189                 prod0 := sub(prod0, remainder)
2190             }
2191 
2192             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
2193             // See https://cs.stackexchange.com/q/138556/92363.
2194 
2195             // Does not overflow because the denominator cannot be zero at this stage in the function.
2196             uint256 twos = denominator & (~denominator + 1);
2197             assembly {
2198                 // Divide denominator by twos.
2199                 denominator := div(denominator, twos)
2200 
2201                 // Divide [prod1 prod0] by twos.
2202                 prod0 := div(prod0, twos)
2203 
2204                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
2205                 twos := add(div(sub(0, twos), twos), 1)
2206             }
2207 
2208             // Shift in bits from prod1 into prod0.
2209             prod0 |= prod1 * twos;
2210 
2211             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
2212             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
2213             // four bits. That is, denominator * inv = 1 mod 2^4.
2214             uint256 inverse = (3 * denominator) ^ 2;
2215 
2216             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
2217             // in modular arithmetic, doubling the correct bits in each step.
2218             inverse *= 2 - denominator * inverse; // inverse mod 2^8
2219             inverse *= 2 - denominator * inverse; // inverse mod 2^16
2220             inverse *= 2 - denominator * inverse; // inverse mod 2^32
2221             inverse *= 2 - denominator * inverse; // inverse mod 2^64
2222             inverse *= 2 - denominator * inverse; // inverse mod 2^128
2223             inverse *= 2 - denominator * inverse; // inverse mod 2^256
2224 
2225             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
2226             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
2227             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
2228             // is no longer required.
2229             result = prod0 * inverse;
2230             return result;
2231         }
2232     }
2233 
2234     /**
2235      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
2236      */
2237     function mulDiv(
2238         uint256 x,
2239         uint256 y,
2240         uint256 denominator,
2241         Rounding rounding
2242     ) internal pure returns (uint256) {
2243         uint256 result = mulDiv(x, y, denominator);
2244         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
2245             result += 1;
2246         }
2247         return result;
2248     }
2249 
2250     /**
2251      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
2252      *
2253      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
2254      */
2255     function sqrt(uint256 a) internal pure returns (uint256) {
2256         if (a == 0) {
2257             return 0;
2258         }
2259 
2260         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
2261         //
2262         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
2263         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
2264         //
2265         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
2266         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
2267         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
2268         //
2269         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
2270         uint256 result = 1 << (log2(a) >> 1);
2271 
2272         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
2273         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
2274         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
2275         // into the expected uint128 result.
2276         unchecked {
2277             result = (result + a / result) >> 1;
2278             result = (result + a / result) >> 1;
2279             result = (result + a / result) >> 1;
2280             result = (result + a / result) >> 1;
2281             result = (result + a / result) >> 1;
2282             result = (result + a / result) >> 1;
2283             result = (result + a / result) >> 1;
2284             return min(result, a / result);
2285         }
2286     }
2287 
2288     /**
2289      * @notice Calculates sqrt(a), following the selected rounding direction.
2290      */
2291     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
2292         unchecked {
2293             uint256 result = sqrt(a);
2294             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
2295         }
2296     }
2297 
2298     /**
2299      * @dev Return the log in base 2, rounded down, of a positive value.
2300      * Returns 0 if given 0.
2301      */
2302     function log2(uint256 value) internal pure returns (uint256) {
2303         uint256 result = 0;
2304         unchecked {
2305             if (value >> 128 > 0) {
2306                 value >>= 128;
2307                 result += 128;
2308             }
2309             if (value >> 64 > 0) {
2310                 value >>= 64;
2311                 result += 64;
2312             }
2313             if (value >> 32 > 0) {
2314                 value >>= 32;
2315                 result += 32;
2316             }
2317             if (value >> 16 > 0) {
2318                 value >>= 16;
2319                 result += 16;
2320             }
2321             if (value >> 8 > 0) {
2322                 value >>= 8;
2323                 result += 8;
2324             }
2325             if (value >> 4 > 0) {
2326                 value >>= 4;
2327                 result += 4;
2328             }
2329             if (value >> 2 > 0) {
2330                 value >>= 2;
2331                 result += 2;
2332             }
2333             if (value >> 1 > 0) {
2334                 result += 1;
2335             }
2336         }
2337         return result;
2338     }
2339 
2340     /**
2341      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
2342      * Returns 0 if given 0.
2343      */
2344     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
2345         unchecked {
2346             uint256 result = log2(value);
2347             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
2348         }
2349     }
2350 
2351     /**
2352      * @dev Return the log in base 10, rounded down, of a positive value.
2353      * Returns 0 if given 0.
2354      */
2355     function log10(uint256 value) internal pure returns (uint256) {
2356         uint256 result = 0;
2357         unchecked {
2358             if (value >= 10**64) {
2359                 value /= 10**64;
2360                 result += 64;
2361             }
2362             if (value >= 10**32) {
2363                 value /= 10**32;
2364                 result += 32;
2365             }
2366             if (value >= 10**16) {
2367                 value /= 10**16;
2368                 result += 16;
2369             }
2370             if (value >= 10**8) {
2371                 value /= 10**8;
2372                 result += 8;
2373             }
2374             if (value >= 10**4) {
2375                 value /= 10**4;
2376                 result += 4;
2377             }
2378             if (value >= 10**2) {
2379                 value /= 10**2;
2380                 result += 2;
2381             }
2382             if (value >= 10**1) {
2383                 result += 1;
2384             }
2385         }
2386         return result;
2387     }
2388 
2389     /**
2390      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
2391      * Returns 0 if given 0.
2392      */
2393     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
2394         unchecked {
2395             uint256 result = log10(value);
2396             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
2397         }
2398     }
2399 
2400     /**
2401      * @dev Return the log in base 256, rounded down, of a positive value.
2402      * Returns 0 if given 0.
2403      *
2404      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
2405      */
2406     function log256(uint256 value) internal pure returns (uint256) {
2407         uint256 result = 0;
2408         unchecked {
2409             if (value >> 128 > 0) {
2410                 value >>= 128;
2411                 result += 16;
2412             }
2413             if (value >> 64 > 0) {
2414                 value >>= 64;
2415                 result += 8;
2416             }
2417             if (value >> 32 > 0) {
2418                 value >>= 32;
2419                 result += 4;
2420             }
2421             if (value >> 16 > 0) {
2422                 value >>= 16;
2423                 result += 2;
2424             }
2425             if (value >> 8 > 0) {
2426                 result += 1;
2427             }
2428         }
2429         return result;
2430     }
2431 
2432     /**
2433      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
2434      * Returns 0 if given 0.
2435      */
2436     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
2437         unchecked {
2438             uint256 result = log256(value);
2439             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
2440         }
2441     }
2442 }
2443 
2444 // File: @openzeppelin/contracts/utils/Strings.sol
2445 
2446 
2447 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
2448 
2449 pragma solidity ^0.8.0;
2450 
2451 
2452 /**
2453  * @dev String operations.
2454  */
2455 library Strings {
2456     bytes16 private constant _SYMBOLS = "0123456789abcdef";
2457     uint8 private constant _ADDRESS_LENGTH = 20;
2458 
2459     /**
2460      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
2461      */
2462     function toString(uint256 value) internal pure returns (string memory) {
2463         unchecked {
2464             uint256 length = Math.log10(value) + 1;
2465             string memory buffer = new string(length);
2466             uint256 ptr;
2467             /// @solidity memory-safe-assembly
2468             assembly {
2469                 ptr := add(buffer, add(32, length))
2470             }
2471             while (true) {
2472                 ptr--;
2473                 /// @solidity memory-safe-assembly
2474                 assembly {
2475                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
2476                 }
2477                 value /= 10;
2478                 if (value == 0) break;
2479             }
2480             return buffer;
2481         }
2482     }
2483 
2484     /**
2485      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
2486      */
2487     function toHexString(uint256 value) internal pure returns (string memory) {
2488         unchecked {
2489             return toHexString(value, Math.log256(value) + 1);
2490         }
2491     }
2492 
2493     /**
2494      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
2495      */
2496     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
2497         bytes memory buffer = new bytes(2 * length + 2);
2498         buffer[0] = "0";
2499         buffer[1] = "x";
2500         for (uint256 i = 2 * length + 1; i > 1; --i) {
2501             buffer[i] = _SYMBOLS[value & 0xf];
2502             value >>= 4;
2503         }
2504         require(value == 0, "Strings: hex length insufficient");
2505         return string(buffer);
2506     }
2507 
2508     /**
2509      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
2510      */
2511     function toHexString(address addr) internal pure returns (string memory) {
2512         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
2513     }
2514 }
2515 
2516 // File: @openzeppelin/contracts/utils/Context.sol
2517 
2518 
2519 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
2520 
2521 pragma solidity ^0.8.0;
2522 
2523 /**
2524  * @dev Provides information about the current execution context, including the
2525  * sender of the transaction and its data. While these are generally available
2526  * via msg.sender and msg.data, they should not be accessed in such a direct
2527  * manner, since when dealing with meta-transactions the account sending and
2528  * paying for execution may not be the actual sender (as far as an application
2529  * is concerned).
2530  *
2531  * This contract is only required for intermediate, library-like contracts.
2532  */
2533 abstract contract Context {
2534     function _msgSender() internal view virtual returns (address) {
2535         return msg.sender;
2536     }
2537 
2538     function _msgData() internal view virtual returns (bytes calldata) {
2539         return msg.data;
2540     }
2541 }
2542 
2543 // File: @openzeppelin/contracts/utils/Address.sol
2544 
2545 
2546 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
2547 
2548 pragma solidity ^0.8.1;
2549 
2550 /**
2551  * @dev Collection of functions related to the address type
2552  */
2553 library Address {
2554     /**
2555      * @dev Returns true if `account` is a contract.
2556      *
2557      * [IMPORTANT]
2558      * ====
2559      * It is unsafe to assume that an address for which this function returns
2560      * false is an externally-owned account (EOA) and not a contract.
2561      *
2562      * Among others, `isContract` will return false for the following
2563      * types of addresses:
2564      *
2565      *  - an externally-owned account
2566      *  - a contract in construction
2567      *  - an address where a contract will be created
2568      *  - an address where a contract lived, but was destroyed
2569      * ====
2570      *
2571      * [IMPORTANT]
2572      * ====
2573      * You shouldn't rely on `isContract` to protect against flash loan attacks!
2574      *
2575      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
2576      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
2577      * constructor.
2578      * ====
2579      */
2580     function isContract(address account) internal view returns (bool) {
2581         // This method relies on extcodesize/address.code.length, which returns 0
2582         // for contracts in construction, since the code is only stored at the end
2583         // of the constructor execution.
2584 
2585         return account.code.length > 0;
2586     }
2587 
2588     /**
2589      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
2590      * `recipient`, forwarding all available gas and reverting on errors.
2591      *
2592      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
2593      * of certain opcodes, possibly making contracts go over the 2300 gas limit
2594      * imposed by `transfer`, making them unable to receive funds via
2595      * `transfer`. {sendValue} removes this limitation.
2596      *
2597      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
2598      *
2599      * IMPORTANT: because control is transferred to `recipient`, care must be
2600      * taken to not create reentrancy vulnerabilities. Consider using
2601      * {ReentrancyGuard} or the
2602      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
2603      */
2604     function sendValue(address payable recipient, uint256 amount) internal {
2605         require(address(this).balance >= amount, "Address: insufficient balance");
2606 
2607         (bool success, ) = recipient.call{value: amount}("");
2608         require(success, "Address: unable to send value, recipient may have reverted");
2609     }
2610 
2611     /**
2612      * @dev Performs a Solidity function call using a low level `call`. A
2613      * plain `call` is an unsafe replacement for a function call: use this
2614      * function instead.
2615      *
2616      * If `target` reverts with a revert reason, it is bubbled up by this
2617      * function (like regular Solidity function calls).
2618      *
2619      * Returns the raw returned data. To convert to the expected return value,
2620      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
2621      *
2622      * Requirements:
2623      *
2624      * - `target` must be a contract.
2625      * - calling `target` with `data` must not revert.
2626      *
2627      * _Available since v3.1._
2628      */
2629     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
2630         return functionCall(target, data, "Address: low-level call failed");
2631     }
2632 
2633     /**
2634      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
2635      * `errorMessage` as a fallback revert reason when `target` reverts.
2636      *
2637      * _Available since v3.1._
2638      */
2639     function functionCall(
2640         address target,
2641         bytes memory data,
2642         string memory errorMessage
2643     ) internal returns (bytes memory) {
2644         return functionCallWithValue(target, data, 0, errorMessage);
2645     }
2646 
2647     /**
2648      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
2649      * but also transferring `value` wei to `target`.
2650      *
2651      * Requirements:
2652      *
2653      * - the calling contract must have an ETH balance of at least `value`.
2654      * - the called Solidity function must be `payable`.
2655      *
2656      * _Available since v3.1._
2657      */
2658     function functionCallWithValue(
2659         address target,
2660         bytes memory data,
2661         uint256 value
2662     ) internal returns (bytes memory) {
2663         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
2664     }
2665 
2666     /**
2667      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
2668      * with `errorMessage` as a fallback revert reason when `target` reverts.
2669      *
2670      * _Available since v3.1._
2671      */
2672     function functionCallWithValue(
2673         address target,
2674         bytes memory data,
2675         uint256 value,
2676         string memory errorMessage
2677     ) internal returns (bytes memory) {
2678         require(address(this).balance >= value, "Address: insufficient balance for call");
2679         require(isContract(target), "Address: call to non-contract");
2680 
2681         (bool success, bytes memory returndata) = target.call{value: value}(data);
2682         return verifyCallResult(success, returndata, errorMessage);
2683     }
2684 
2685     /**
2686      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
2687      * but performing a static call.
2688      *
2689      * _Available since v3.3._
2690      */
2691     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
2692         return functionStaticCall(target, data, "Address: low-level static call failed");
2693     }
2694 
2695     /**
2696      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
2697      * but performing a static call.
2698      *
2699      * _Available since v3.3._
2700      */
2701     function functionStaticCall(
2702         address target,
2703         bytes memory data,
2704         string memory errorMessage
2705     ) internal view returns (bytes memory) {
2706         require(isContract(target), "Address: static call to non-contract");
2707 
2708         (bool success, bytes memory returndata) = target.staticcall(data);
2709         return verifyCallResult(success, returndata, errorMessage);
2710     }
2711 
2712     /**
2713      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
2714      * but performing a delegate call.
2715      *
2716      * _Available since v3.4._
2717      */
2718     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
2719         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
2720     }
2721 
2722     /**
2723      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
2724      * but performing a delegate call.
2725      *
2726      * _Available since v3.4._
2727      */
2728     function functionDelegateCall(
2729         address target,
2730         bytes memory data,
2731         string memory errorMessage
2732     ) internal returns (bytes memory) {
2733         require(isContract(target), "Address: delegate call to non-contract");
2734 
2735         (bool success, bytes memory returndata) = target.delegatecall(data);
2736         return verifyCallResult(success, returndata, errorMessage);
2737     }
2738 
2739     /**
2740      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
2741      * revert reason using the provided one.
2742      *
2743      * _Available since v4.3._
2744      */
2745     function verifyCallResult(
2746         bool success,
2747         bytes memory returndata,
2748         string memory errorMessage
2749     ) internal pure returns (bytes memory) {
2750         if (success) {
2751             return returndata;
2752         } else {
2753             // Look for revert reason and bubble it up if present
2754             if (returndata.length > 0) {
2755                 // The easiest way to bubble the revert reason is using memory via assembly
2756                 /// @solidity memory-safe-assembly
2757                 assembly {
2758                     let returndata_size := mload(returndata)
2759                     revert(add(32, returndata), returndata_size)
2760                 }
2761             } else {
2762                 revert(errorMessage);
2763             }
2764         }
2765     }
2766 }
2767 
2768 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
2769 
2770 
2771 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
2772 
2773 pragma solidity ^0.8.0;
2774 
2775 /**
2776  * @title ERC721 token receiver interface
2777  * @dev Interface for any contract that wants to support safeTransfers
2778  * from ERC721 asset contracts.
2779  */
2780 interface IERC721Receiver {
2781     /**
2782      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
2783      * by `operator` from `from`, this function is called.
2784      *
2785      * It must return its Solidity selector to confirm the token transfer.
2786      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
2787      *
2788      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
2789      */
2790     function onERC721Received(
2791         address operator,
2792         address from,
2793         uint256 tokenId,
2794         bytes calldata data
2795     ) external returns (bytes4);
2796 }
2797 
2798 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
2799 
2800 
2801 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
2802 
2803 pragma solidity ^0.8.0;
2804 
2805 /**
2806  * @dev Interface of the ERC165 standard, as defined in the
2807  * https://eips.ethereum.org/EIPS/eip-165[EIP].
2808  *
2809  * Implementers can declare support of contract interfaces, which can then be
2810  * queried by others ({ERC165Checker}).
2811  *
2812  * For an implementation, see {ERC165}.
2813  */
2814 interface IERC165 {
2815     /**
2816      * @dev Returns true if this contract implements the interface defined by
2817      * `interfaceId`. See the corresponding
2818      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
2819      * to learn more about how these ids are created.
2820      *
2821      * This function call must use less than 30 000 gas.
2822      */
2823     function supportsInterface(bytes4 interfaceId) external view returns (bool);
2824 }
2825 
2826 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
2827 
2828 
2829 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
2830 
2831 pragma solidity ^0.8.0;
2832 
2833 
2834 /**
2835  * @dev Interface for the NFT Royalty Standard.
2836  *
2837  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
2838  * support for royalty payments across all NFT marketplaces and ecosystem participants.
2839  *
2840  * _Available since v4.5._
2841  */
2842 interface IERC2981 is IERC165 {
2843     /**
2844      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
2845      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
2846      */
2847     function royaltyInfo(uint256 tokenId, uint256 salePrice)
2848         external
2849         view
2850         returns (address receiver, uint256 royaltyAmount);
2851 }
2852 
2853 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
2854 
2855 
2856 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
2857 
2858 pragma solidity ^0.8.0;
2859 
2860 
2861 /**
2862  * @dev Implementation of the {IERC165} interface.
2863  *
2864  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
2865  * for the additional interface id that will be supported. For example:
2866  *
2867  * ```solidity
2868  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
2869  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
2870  * }
2871  * ```
2872  *
2873  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
2874  */
2875 abstract contract ERC165 is IERC165 {
2876     /**
2877      * @dev See {IERC165-supportsInterface}.
2878      */
2879     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
2880         return interfaceId == type(IERC165).interfaceId;
2881     }
2882 }
2883 
2884 // File: @openzeppelin/contracts/token/common/ERC2981.sol
2885 
2886 
2887 // OpenZeppelin Contracts (last updated v4.7.0) (token/common/ERC2981.sol)
2888 
2889 pragma solidity ^0.8.0;
2890 
2891 
2892 
2893 /**
2894  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
2895  *
2896  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
2897  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
2898  *
2899  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
2900  * fee is specified in basis points by default.
2901  *
2902  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
2903  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
2904  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
2905  *
2906  * _Available since v4.5._
2907  */
2908 abstract contract ERC2981 is IERC2981, ERC165 {
2909     struct RoyaltyInfo {
2910         address receiver;
2911         uint96 royaltyFraction;
2912     }
2913 
2914     RoyaltyInfo private _defaultRoyaltyInfo;
2915     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
2916 
2917     /**
2918      * @dev See {IERC165-supportsInterface}.
2919      */
2920     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
2921         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
2922     }
2923 
2924     /**
2925      * @inheritdoc IERC2981
2926      */
2927     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
2928         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
2929 
2930         if (royalty.receiver == address(0)) {
2931             royalty = _defaultRoyaltyInfo;
2932         }
2933 
2934         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
2935 
2936         return (royalty.receiver, royaltyAmount);
2937     }
2938 
2939     /**
2940      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
2941      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
2942      * override.
2943      */
2944     function _feeDenominator() internal pure virtual returns (uint96) {
2945         return 10000;
2946     }
2947 
2948     /**
2949      * @dev Sets the royalty information that all ids in this contract will default to.
2950      *
2951      * Requirements:
2952      *
2953      * - `receiver` cannot be the zero address.
2954      * - `feeNumerator` cannot be greater than the fee denominator.
2955      */
2956     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
2957         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
2958         require(receiver != address(0), "ERC2981: invalid receiver");
2959 
2960         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
2961     }
2962 
2963     /**
2964      * @dev Removes default royalty information.
2965      */
2966     function _deleteDefaultRoyalty() internal virtual {
2967         delete _defaultRoyaltyInfo;
2968     }
2969 
2970     /**
2971      * @dev Sets the royalty information for a specific token id, overriding the global default.
2972      *
2973      * Requirements:
2974      *
2975      * - `receiver` cannot be the zero address.
2976      * - `feeNumerator` cannot be greater than the fee denominator.
2977      */
2978     function _setTokenRoyalty(
2979         uint256 tokenId,
2980         address receiver,
2981         uint96 feeNumerator
2982     ) internal virtual {
2983         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
2984         require(receiver != address(0), "ERC2981: Invalid parameters");
2985 
2986         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
2987     }
2988 
2989     /**
2990      * @dev Resets royalty information for the token id back to the global default.
2991      */
2992     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
2993         delete _tokenRoyaltyInfo[tokenId];
2994     }
2995 }
2996 
2997 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
2998 
2999 
3000 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)
3001 
3002 pragma solidity ^0.8.0;
3003 
3004 
3005 /**
3006  * @dev Required interface of an ERC721 compliant contract.
3007  */
3008 interface IERC721 is IERC165 {
3009     /**
3010      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
3011      */
3012     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
3013 
3014     /**
3015      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
3016      */
3017     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
3018 
3019     /**
3020      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
3021      */
3022     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
3023 
3024     /**
3025      * @dev Returns the number of tokens in ``owner``'s account.
3026      */
3027     function balanceOf(address owner) external view returns (uint256 balance);
3028 
3029     /**
3030      * @dev Returns the owner of the `tokenId` token.
3031      *
3032      * Requirements:
3033      *
3034      * - `tokenId` must exist.
3035      */
3036     function ownerOf(uint256 tokenId) external view returns (address owner);
3037 
3038     /**
3039      * @dev Safely transfers `tokenId` token from `from` to `to`.
3040      *
3041      * Requirements:
3042      *
3043      * - `from` cannot be the zero address.
3044      * - `to` cannot be the zero address.
3045      * - `tokenId` token must exist and be owned by `from`.
3046      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
3047      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
3048      *
3049      * Emits a {Transfer} event.
3050      */
3051     function safeTransferFrom(
3052         address from,
3053         address to,
3054         uint256 tokenId,
3055         bytes calldata data
3056     ) external;
3057 
3058     /**
3059      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
3060      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
3061      *
3062      * Requirements:
3063      *
3064      * - `from` cannot be the zero address.
3065      * - `to` cannot be the zero address.
3066      * - `tokenId` token must exist and be owned by `from`.
3067      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
3068      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
3069      *
3070      * Emits a {Transfer} event.
3071      */
3072     function safeTransferFrom(
3073         address from,
3074         address to,
3075         uint256 tokenId
3076     ) external;
3077 
3078     /**
3079      * @dev Transfers `tokenId` token from `from` to `to`.
3080      *
3081      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
3082      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
3083      * understand this adds an external call which potentially creates a reentrancy vulnerability.
3084      *
3085      * Requirements:
3086      *
3087      * - `from` cannot be the zero address.
3088      * - `to` cannot be the zero address.
3089      * - `tokenId` token must be owned by `from`.
3090      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
3091      *
3092      * Emits a {Transfer} event.
3093      */
3094     function transferFrom(
3095         address from,
3096         address to,
3097         uint256 tokenId
3098     ) external;
3099 
3100     /**
3101      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
3102      * The approval is cleared when the token is transferred.
3103      *
3104      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
3105      *
3106      * Requirements:
3107      *
3108      * - The caller must own the token or be an approved operator.
3109      * - `tokenId` must exist.
3110      *
3111      * Emits an {Approval} event.
3112      */
3113     function approve(address to, uint256 tokenId) external;
3114 
3115     /**
3116      * @dev Approve or remove `operator` as an operator for the caller.
3117      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
3118      *
3119      * Requirements:
3120      *
3121      * - The `operator` cannot be the caller.
3122      *
3123      * Emits an {ApprovalForAll} event.
3124      */
3125     function setApprovalForAll(address operator, bool _approved) external;
3126 
3127     /**
3128      * @dev Returns the account approved for `tokenId` token.
3129      *
3130      * Requirements:
3131      *
3132      * - `tokenId` must exist.
3133      */
3134     function getApproved(uint256 tokenId) external view returns (address operator);
3135 
3136     /**
3137      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
3138      *
3139      * See {setApprovalForAll}
3140      */
3141     function isApprovedForAll(address owner, address operator) external view returns (bool);
3142 }
3143 
3144 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
3145 
3146 
3147 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
3148 
3149 pragma solidity ^0.8.0;
3150 
3151 
3152 /**
3153  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
3154  * @dev See https://eips.ethereum.org/EIPS/eip-721
3155  */
3156 interface IERC721Enumerable is IERC721 {
3157     /**
3158      * @dev Returns the total amount of tokens stored by the contract.
3159      */
3160     function totalSupply() external view returns (uint256);
3161 
3162     /**
3163      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
3164      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
3165      */
3166     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
3167 
3168     /**
3169      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
3170      * Use along with {totalSupply} to enumerate all tokens.
3171      */
3172     function tokenByIndex(uint256 index) external view returns (uint256);
3173 }
3174 
3175 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
3176 
3177 
3178 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
3179 
3180 pragma solidity ^0.8.0;
3181 
3182 
3183 /**
3184  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
3185  * @dev See https://eips.ethereum.org/EIPS/eip-721
3186  */
3187 interface IERC721Metadata is IERC721 {
3188     /**
3189      * @dev Returns the token collection name.
3190      */
3191     function name() external view returns (string memory);
3192 
3193     /**
3194      * @dev Returns the token collection symbol.
3195      */
3196     function symbol() external view returns (string memory);
3197 
3198     /**
3199      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
3200      */
3201     function tokenURI(uint256 tokenId) external view returns (string memory);
3202 }
3203 
3204 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
3205 
3206 
3207 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/ERC721.sol)
3208 
3209 pragma solidity ^0.8.0;
3210 
3211 
3212 
3213 
3214 
3215 
3216 
3217 
3218 /**
3219  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
3220  * the Metadata extension, but not including the Enumerable extension, which is available separately as
3221  * {ERC721Enumerable}.
3222  */
3223 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
3224     using Address for address;
3225     using Strings for uint256;
3226 
3227     // Token name
3228     string private _name;
3229 
3230     // Token symbol
3231     string private _symbol;
3232 
3233     // Mapping from token ID to owner address
3234     mapping(uint256 => address) private _owners;
3235 
3236     // Mapping owner address to token count
3237     mapping(address => uint256) private _balances;
3238 
3239     // Mapping from token ID to approved address
3240     mapping(uint256 => address) private _tokenApprovals;
3241 
3242     // Mapping from owner to operator approvals
3243     mapping(address => mapping(address => bool)) private _operatorApprovals;
3244 
3245     /**
3246      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
3247      */
3248     constructor(string memory name_, string memory symbol_) {
3249         _name = name_;
3250         _symbol = symbol_;
3251     }
3252 
3253     /**
3254      * @dev See {IERC165-supportsInterface}.
3255      */
3256     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
3257         return
3258             interfaceId == type(IERC721).interfaceId ||
3259             interfaceId == type(IERC721Metadata).interfaceId ||
3260             super.supportsInterface(interfaceId);
3261     }
3262 
3263     /**
3264      * @dev See {IERC721-balanceOf}.
3265      */
3266     function balanceOf(address owner) public view virtual override returns (uint256) {
3267         require(owner != address(0), "ERC721: address zero is not a valid owner");
3268         return _balances[owner];
3269     }
3270 
3271     /**
3272      * @dev See {IERC721-ownerOf}.
3273      */
3274     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
3275         address owner = _ownerOf(tokenId);
3276         require(owner != address(0), "ERC721: invalid token ID");
3277         return owner;
3278     }
3279 
3280     /**
3281      * @dev See {IERC721Metadata-name}.
3282      */
3283     function name() public view virtual override returns (string memory) {
3284         return _name;
3285     }
3286 
3287     /**
3288      * @dev See {IERC721Metadata-symbol}.
3289      */
3290     function symbol() public view virtual override returns (string memory) {
3291         return _symbol;
3292     }
3293 
3294     /**
3295      * @dev See {IERC721Metadata-tokenURI}.
3296      */
3297     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
3298         _requireMinted(tokenId);
3299 
3300         string memory baseURI = _baseURI();
3301         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
3302     }
3303 
3304     /**
3305      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
3306      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
3307      * by default, can be overridden in child contracts.
3308      */
3309     function _baseURI() internal view virtual returns (string memory) {
3310         return "";
3311     }
3312 
3313     /**
3314      * @dev See {IERC721-approve}.
3315      */
3316     function approve(address to, uint256 tokenId) public virtual override {
3317         address owner = ERC721.ownerOf(tokenId);
3318         require(to != owner, "ERC721: approval to current owner");
3319 
3320         require(
3321             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
3322             "ERC721: approve caller is not token owner or approved for all"
3323         );
3324 
3325         _approve(to, tokenId);
3326     }
3327 
3328     /**
3329      * @dev See {IERC721-getApproved}.
3330      */
3331     function getApproved(uint256 tokenId) public view virtual override returns (address) {
3332         _requireMinted(tokenId);
3333 
3334         return _tokenApprovals[tokenId];
3335     }
3336 
3337     /**
3338      * @dev See {IERC721-setApprovalForAll}.
3339      */
3340     function setApprovalForAll(address operator, bool approved) public virtual override {
3341         _setApprovalForAll(_msgSender(), operator, approved);
3342     }
3343 
3344     /**
3345      * @dev See {IERC721-isApprovedForAll}.
3346      */
3347     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
3348         return _operatorApprovals[owner][operator];
3349     }
3350 
3351     /**
3352      * @dev See {IERC721-transferFrom}.
3353      */
3354     function transferFrom(
3355         address from,
3356         address to,
3357         uint256 tokenId
3358     ) public virtual override {
3359         //solhint-disable-next-line max-line-length
3360         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
3361 
3362         _transfer(from, to, tokenId);
3363     }
3364 
3365     /**
3366      * @dev See {IERC721-safeTransferFrom}.
3367      */
3368     function safeTransferFrom(
3369         address from,
3370         address to,
3371         uint256 tokenId
3372     ) public virtual override {
3373         safeTransferFrom(from, to, tokenId, "");
3374     }
3375 
3376     /**
3377      * @dev See {IERC721-safeTransferFrom}.
3378      */
3379     function safeTransferFrom(
3380         address from,
3381         address to,
3382         uint256 tokenId,
3383         bytes memory data
3384     ) public virtual override {
3385         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
3386         _safeTransfer(from, to, tokenId, data);
3387     }
3388 
3389     /**
3390      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
3391      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
3392      *
3393      * `data` is additional data, it has no specified format and it is sent in call to `to`.
3394      *
3395      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
3396      * implement alternative mechanisms to perform token transfer, such as signature-based.
3397      *
3398      * Requirements:
3399      *
3400      * - `from` cannot be the zero address.
3401      * - `to` cannot be the zero address.
3402      * - `tokenId` token must exist and be owned by `from`.
3403      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
3404      *
3405      * Emits a {Transfer} event.
3406      */
3407     function _safeTransfer(
3408         address from,
3409         address to,
3410         uint256 tokenId,
3411         bytes memory data
3412     ) internal virtual {
3413         _transfer(from, to, tokenId);
3414         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
3415     }
3416 
3417     /**
3418      * @dev Returns the owner of the `tokenId`. Does NOT revert if token doesn't exist
3419      */
3420     function _ownerOf(uint256 tokenId) internal view virtual returns (address) {
3421         return _owners[tokenId];
3422     }
3423 
3424     /**
3425      * @dev Returns whether `tokenId` exists.
3426      *
3427      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
3428      *
3429      * Tokens start existing when they are minted (`_mint`),
3430      * and stop existing when they are burned (`_burn`).
3431      */
3432     function _exists(uint256 tokenId) internal view virtual returns (bool) {
3433         return _ownerOf(tokenId) != address(0);
3434     }
3435 
3436     /**
3437      * @dev Returns whether `spender` is allowed to manage `tokenId`.
3438      *
3439      * Requirements:
3440      *
3441      * - `tokenId` must exist.
3442      */
3443     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
3444         address owner = ERC721.ownerOf(tokenId);
3445         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
3446     }
3447 
3448     /**
3449      * @dev Safely mints `tokenId` and transfers it to `to`.
3450      *
3451      * Requirements:
3452      *
3453      * - `tokenId` must not exist.
3454      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
3455      *
3456      * Emits a {Transfer} event.
3457      */
3458     function _safeMint(address to, uint256 tokenId) internal virtual {
3459         _safeMint(to, tokenId, "");
3460     }
3461 
3462     /**
3463      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
3464      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
3465      */
3466     function _safeMint(
3467         address to,
3468         uint256 tokenId,
3469         bytes memory data
3470     ) internal virtual {
3471         _mint(to, tokenId);
3472         require(
3473             _checkOnERC721Received(address(0), to, tokenId, data),
3474             "ERC721: transfer to non ERC721Receiver implementer"
3475         );
3476     }
3477 
3478     /**
3479      * @dev Mints `tokenId` and transfers it to `to`.
3480      *
3481      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
3482      *
3483      * Requirements:
3484      *
3485      * - `tokenId` must not exist.
3486      * - `to` cannot be the zero address.
3487      *
3488      * Emits a {Transfer} event.
3489      */
3490     function _mint(address to, uint256 tokenId) internal virtual {
3491         require(to != address(0), "ERC721: mint to the zero address");
3492         require(!_exists(tokenId), "ERC721: token already minted");
3493 
3494         _beforeTokenTransfer(address(0), to, tokenId, 1);
3495 
3496         // Check that tokenId was not minted by `_beforeTokenTransfer` hook
3497         require(!_exists(tokenId), "ERC721: token already minted");
3498 
3499         unchecked {
3500             // Will not overflow unless all 2**256 token ids are minted to the same owner.
3501             // Given that tokens are minted one by one, it is impossible in practice that
3502             // this ever happens. Might change if we allow batch minting.
3503             // The ERC fails to describe this case.
3504             _balances[to] += 1;
3505         }
3506 
3507         _owners[tokenId] = to;
3508 
3509         emit Transfer(address(0), to, tokenId);
3510 
3511         _afterTokenTransfer(address(0), to, tokenId, 1);
3512     }
3513 
3514     /**
3515      * @dev Destroys `tokenId`.
3516      * The approval is cleared when the token is burned.
3517      * This is an internal function that does not check if the sender is authorized to operate on the token.
3518      *
3519      * Requirements:
3520      *
3521      * - `tokenId` must exist.
3522      *
3523      * Emits a {Transfer} event.
3524      */
3525     function _burn(uint256 tokenId) internal virtual {
3526         address owner = ERC721.ownerOf(tokenId);
3527 
3528         _beforeTokenTransfer(owner, address(0), tokenId, 1);
3529 
3530         // Update ownership in case tokenId was transferred by `_beforeTokenTransfer` hook
3531         owner = ERC721.ownerOf(tokenId);
3532 
3533         // Clear approvals
3534         delete _tokenApprovals[tokenId];
3535 
3536         unchecked {
3537             // Cannot overflow, as that would require more tokens to be burned/transferred
3538             // out than the owner initially received through minting and transferring in.
3539             _balances[owner] -= 1;
3540         }
3541         delete _owners[tokenId];
3542 
3543         emit Transfer(owner, address(0), tokenId);
3544 
3545         _afterTokenTransfer(owner, address(0), tokenId, 1);
3546     }
3547 
3548     /**
3549      * @dev Transfers `tokenId` from `from` to `to`.
3550      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
3551      *
3552      * Requirements:
3553      *
3554      * - `to` cannot be the zero address.
3555      * - `tokenId` token must be owned by `from`.
3556      *
3557      * Emits a {Transfer} event.
3558      */
3559     function _transfer(
3560         address from,
3561         address to,
3562         uint256 tokenId
3563     ) internal virtual {
3564         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
3565         require(to != address(0), "ERC721: transfer to the zero address");
3566 
3567         _beforeTokenTransfer(from, to, tokenId, 1);
3568 
3569         // Check that tokenId was not transferred by `_beforeTokenTransfer` hook
3570         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
3571 
3572         // Clear approvals from the previous owner
3573         delete _tokenApprovals[tokenId];
3574 
3575         unchecked {
3576             // `_balances[from]` cannot overflow for the same reason as described in `_burn`:
3577             // `from`'s balance is the number of token held, which is at least one before the current
3578             // transfer.
3579             // `_balances[to]` could overflow in the conditions described in `_mint`. That would require
3580             // all 2**256 token ids to be minted, which in practice is impossible.
3581             _balances[from] -= 1;
3582             _balances[to] += 1;
3583         }
3584         _owners[tokenId] = to;
3585 
3586         emit Transfer(from, to, tokenId);
3587 
3588         _afterTokenTransfer(from, to, tokenId, 1);
3589     }
3590 
3591     /**
3592      * @dev Approve `to` to operate on `tokenId`
3593      *
3594      * Emits an {Approval} event.
3595      */
3596     function _approve(address to, uint256 tokenId) internal virtual {
3597         _tokenApprovals[tokenId] = to;
3598         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
3599     }
3600 
3601     /**
3602      * @dev Approve `operator` to operate on all of `owner` tokens
3603      *
3604      * Emits an {ApprovalForAll} event.
3605      */
3606     function _setApprovalForAll(
3607         address owner,
3608         address operator,
3609         bool approved
3610     ) internal virtual {
3611         require(owner != operator, "ERC721: approve to caller");
3612         _operatorApprovals[owner][operator] = approved;
3613         emit ApprovalForAll(owner, operator, approved);
3614     }
3615 
3616     /**
3617      * @dev Reverts if the `tokenId` has not been minted yet.
3618      */
3619     function _requireMinted(uint256 tokenId) internal view virtual {
3620         require(_exists(tokenId), "ERC721: invalid token ID");
3621     }
3622 
3623     /**
3624      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
3625      * The call is not executed if the target address is not a contract.
3626      *
3627      * @param from address representing the previous owner of the given token ID
3628      * @param to target address that will receive the tokens
3629      * @param tokenId uint256 ID of the token to be transferred
3630      * @param data bytes optional data to send along with the call
3631      * @return bool whether the call correctly returned the expected magic value
3632      */
3633     function _checkOnERC721Received(
3634         address from,
3635         address to,
3636         uint256 tokenId,
3637         bytes memory data
3638     ) private returns (bool) {
3639         if (to.isContract()) {
3640             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
3641                 return retval == IERC721Receiver.onERC721Received.selector;
3642             } catch (bytes memory reason) {
3643                 if (reason.length == 0) {
3644                     revert("ERC721: transfer to non ERC721Receiver implementer");
3645                 } else {
3646                     /// @solidity memory-safe-assembly
3647                     assembly {
3648                         revert(add(32, reason), mload(reason))
3649                     }
3650                 }
3651             }
3652         } else {
3653             return true;
3654         }
3655     }
3656 
3657     /**
3658      * @dev Hook that is called before any token transfer. This includes minting and burning. If {ERC721Consecutive} is
3659      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
3660      *
3661      * Calling conditions:
3662      *
3663      * - When `from` and `to` are both non-zero, ``from``'s tokens will be transferred to `to`.
3664      * - When `from` is zero, the tokens will be minted for `to`.
3665      * - When `to` is zero, ``from``'s tokens will be burned.
3666      * - `from` and `to` are never both zero.
3667      * - `batchSize` is non-zero.
3668      *
3669      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
3670      */
3671     function _beforeTokenTransfer(
3672         address from,
3673         address to,
3674         uint256, /* firstTokenId */
3675         uint256 batchSize
3676     ) internal virtual {
3677         if (batchSize > 1) {
3678             if (from != address(0)) {
3679                 _balances[from] -= batchSize;
3680             }
3681             if (to != address(0)) {
3682                 _balances[to] += batchSize;
3683             }
3684         }
3685     }
3686 
3687     /**
3688      * @dev Hook that is called after any token transfer. This includes minting and burning. If {ERC721Consecutive} is
3689      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
3690      *
3691      * Calling conditions:
3692      *
3693      * - When `from` and `to` are both non-zero, ``from``'s tokens were transferred to `to`.
3694      * - When `from` is zero, the tokens were minted for `to`.
3695      * - When `to` is zero, ``from``'s tokens were burned.
3696      * - `from` and `to` are never both zero.
3697      * - `batchSize` is non-zero.
3698      *
3699      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
3700      */
3701     function _afterTokenTransfer(
3702         address from,
3703         address to,
3704         uint256 firstTokenId,
3705         uint256 batchSize
3706     ) internal virtual {}
3707 }
3708 
3709 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
3710 
3711 
3712 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/extensions/ERC721Enumerable.sol)
3713 
3714 pragma solidity ^0.8.0;
3715 
3716 
3717 
3718 /**
3719  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
3720  * enumerability of all the token ids in the contract as well as all token ids owned by each
3721  * account.
3722  */
3723 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
3724     // Mapping from owner to list of owned token IDs
3725     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
3726 
3727     // Mapping from token ID to index of the owner tokens list
3728     mapping(uint256 => uint256) private _ownedTokensIndex;
3729 
3730     // Array with all token ids, used for enumeration
3731     uint256[] private _allTokens;
3732 
3733     // Mapping from token id to position in the allTokens array
3734     mapping(uint256 => uint256) private _allTokensIndex;
3735 
3736     /**
3737      * @dev See {IERC165-supportsInterface}.
3738      */
3739     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
3740         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
3741     }
3742 
3743     /**
3744      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
3745      */
3746     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
3747         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
3748         return _ownedTokens[owner][index];
3749     }
3750 
3751     /**
3752      * @dev See {IERC721Enumerable-totalSupply}.
3753      */
3754     function totalSupply() public view virtual override returns (uint256) {
3755         return _allTokens.length;
3756     }
3757 
3758     /**
3759      * @dev See {IERC721Enumerable-tokenByIndex}.
3760      */
3761     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
3762         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
3763         return _allTokens[index];
3764     }
3765 
3766     /**
3767      * @dev See {ERC721-_beforeTokenTransfer}.
3768      */
3769     function _beforeTokenTransfer(
3770         address from,
3771         address to,
3772         uint256 firstTokenId,
3773         uint256 batchSize
3774     ) internal virtual override {
3775         super._beforeTokenTransfer(from, to, firstTokenId, batchSize);
3776 
3777         if (batchSize > 1) {
3778             // Will only trigger during construction. Batch transferring (minting) is not available afterwards.
3779             revert("ERC721Enumerable: consecutive transfers not supported");
3780         }
3781 
3782         uint256 tokenId = firstTokenId;
3783 
3784         if (from == address(0)) {
3785             _addTokenToAllTokensEnumeration(tokenId);
3786         } else if (from != to) {
3787             _removeTokenFromOwnerEnumeration(from, tokenId);
3788         }
3789         if (to == address(0)) {
3790             _removeTokenFromAllTokensEnumeration(tokenId);
3791         } else if (to != from) {
3792             _addTokenToOwnerEnumeration(to, tokenId);
3793         }
3794     }
3795 
3796     /**
3797      * @dev Private function to add a token to this extension's ownership-tracking data structures.
3798      * @param to address representing the new owner of the given token ID
3799      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
3800      */
3801     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
3802         uint256 length = ERC721.balanceOf(to);
3803         _ownedTokens[to][length] = tokenId;
3804         _ownedTokensIndex[tokenId] = length;
3805     }
3806 
3807     /**
3808      * @dev Private function to add a token to this extension's token tracking data structures.
3809      * @param tokenId uint256 ID of the token to be added to the tokens list
3810      */
3811     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
3812         _allTokensIndex[tokenId] = _allTokens.length;
3813         _allTokens.push(tokenId);
3814     }
3815 
3816     /**
3817      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
3818      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
3819      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
3820      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
3821      * @param from address representing the previous owner of the given token ID
3822      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
3823      */
3824     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
3825         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
3826         // then delete the last slot (swap and pop).
3827 
3828         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
3829         uint256 tokenIndex = _ownedTokensIndex[tokenId];
3830 
3831         // When the token to delete is the last token, the swap operation is unnecessary
3832         if (tokenIndex != lastTokenIndex) {
3833             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
3834 
3835             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
3836             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
3837         }
3838 
3839         // This also deletes the contents at the last position of the array
3840         delete _ownedTokensIndex[tokenId];
3841         delete _ownedTokens[from][lastTokenIndex];
3842     }
3843 
3844     /**
3845      * @dev Private function to remove a token from this extension's token tracking data structures.
3846      * This has O(1) time complexity, but alters the order of the _allTokens array.
3847      * @param tokenId uint256 ID of the token to be removed from the tokens list
3848      */
3849     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
3850         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
3851         // then delete the last slot (swap and pop).
3852 
3853         uint256 lastTokenIndex = _allTokens.length - 1;
3854         uint256 tokenIndex = _allTokensIndex[tokenId];
3855 
3856         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
3857         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
3858         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
3859         uint256 lastTokenId = _allTokens[lastTokenIndex];
3860 
3861         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
3862         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
3863 
3864         // This also deletes the contents at the last position of the array
3865         delete _allTokensIndex[tokenId];
3866         _allTokens.pop();
3867     }
3868 }
3869 
3870 // File: miladystation2/miladystationA.sol
3871 
3872 
3873 pragma solidity ^0.8.17;
3874 
3875 /*⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
3876 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣾⣿⣷⣶⣤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
3877 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⠿⣿⣿⣿⣿⣿⣿⣶⣤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
3878 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣠⣤⣴⣶⣾⣿⣷⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠙⠻⢿⣿⣿⣿⣿⣷⣦⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀
3879 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠻⢿⣿⣿⣿⣿⣦⡀⠀⠀⠀⠀⠀⠀
3880 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣾⣿⣿⣿⣿⣿⡿⠿⠟⠛⠉⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠻⣿⣿⣿⣆⠀⠀⠀⠀⠀
3881 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿⣿⡿⠟⠋⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⣿⣿⣧⠀⠀⠀⠀
3882 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣿⣿⣿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢻⣿⣇⠀⠀⠀
3883 ⠀⠀⠀⠀⠀⠀⠀⣠⣾⣿⣿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣴⣶⣿⣿⣿⣿⣿⣿⣿⣶⣤⡀⠀⠙⠋⠀⠀⠀
3884 ⠀⠀⠀⠀⠀⣠⣾⣿⣿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣤⣾⠟⢋⣥⣤⠀⣶⣶⣶⣦⣤⣌⣉⠛⠀⠀⠀⠀⠀⠀
3885 ⠀⠀⠀⠀⣴⣿⣿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠋⢁⣴⣿⣿⡿⠀⣿⣿⣿⣿⣿⣿⣿⣷⡄⠀⠀⠀⠀⠀
3886 ⠀⠀⠀⣼⣿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣤⣤⣶⣶⣾⣿⣿⣿⣿⣷⣶⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣿⣿⣿⠁⠀⠀⢹⣿⣿⣿⣿⣿⣿⢻⣿⡄⠀⠀⠀⠀
3887 ⠀⠀⠀⠛⠋⠀⠀⠀⠀⠀⠀⠀⢀⣤⣾⣿⠿⠛⣛⣉⣉⣀⣀⡀⠀⠀⠀⠀⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⣿⣿⣿⣿⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⢸⣿⣿⡄⠀⠀⠀
3888 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣾⡿⢋⣩⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⣶⣦⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⣿⣿⣿⣿⣦⣀⣀⣴⣿⣿⣿⣿⣿⡿⢸⣿⢿⣷⡀⠀⠀
3889 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣡⣄⠀⠋⠁⠀⠈⠹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⣿⡟⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⢸⡿⠀⠛⠃⠀⠀
3890 ⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿⣿⣧⡀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠛⠛⠃⢹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠁⠈⠁⠀⠀⠀⠀⠀
3891 ⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿⣿⢿⣿⣿⣿⣷⣦⣤⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣶⣶⠀⠈⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠀⣿⠇⠀⠀⠀⠀⠀
3892 ⠀⠀⠀⠀⠀⢠⣿⣿⣿⠟⠉⠀⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢿⣿⠀⠀⢹⣿⣿⣿⣿⣿⣿⣿⣿⣿⠁⢸⣿⠀⠀⠀⠀⠀⠀
3893 ⠀⠀⠀⠀⠀⣼⣿⡟⠁⣠⣦⠀⠘⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠉⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⡆⠀⠀⢻⣿⣿⣿⣿⣿⣿⣿⠏⠀⣸⡏⠀⠀⠀⠀⠀⠀
3894 ⠀⠀⠀⠀⠀⣿⡏⠀⠀⣿⣿⡀⠀⠘⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠀⢹⣿⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣿⣇⠀⠀⠀⠙⢿⣿⣿⡿⠟⠁⠀⣸⡿⠁⠀⠀⠀⠀⠀⠀
3895 ⠀⠀⠀⠀⢸⣿⠁⠀⠀⢸⣿⣇⠀⠀⠘⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠁⠀⢀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⢿⣦⡀⠀⠀⠀⠈⠉⠀⠀⠀⣼⡿⠁⠀⠀⠀⠀⠀⠀⠀
3896 ⠀⠀⠀⠀⠈⠁⠀⠀⠀⠀⢿⣿⡄⠀⠀⠈⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠁⠀⠀⣼⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢿⣷⣦⣄⣀⠀⠀⢀⡈⠙⠁⠀⠀⠀⠀⠀⠀⠀⠀
3897 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢻⣿⣆⠀⠀⠀⠉⠛⠿⢿⣿⣿⠿⠛⠁⠀⠀⠀⣠⣿⣿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠿⣿⣿⣷⣿⣯⣤⣶⠄⠀⠀⠀⠀⠀⠀⠀
3898 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⣿⣷⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠉⠙⠛⠋⠁⠀⠀⠀⠀⠀⠀⠀
3899 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⢿⣷⣤⣀⠀⠀⠀⠀⠀⠀⠀⠺⣿⣿⡿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
3900 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠛⢻⣿⣶⣤⣤⣤⣶⣷⣤⠈⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
3901 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⢿⣿⣿⣿⣿⡿⠿⠛⠋⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
3902 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
3903 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
3904 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
3905 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⠶⢤⣄⣀⣀⣤⠶⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
3906 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
3907 ::::    ::::  ::::::::::: :::            :::     :::::::::  :::   :::  ::::::::  :::::::::::     :::     ::::::::::: :::::::::::  ::::::::  ::::    ::: 
3908 +:+:+: :+:+:+     :+:     :+:          :+: :+:   :+:    :+: :+:   :+: :+:    :+:     :+:       :+: :+:       :+:         :+:     :+:    :+: :+:+:   :+: 
3909 +:+ +:+:+ +:+     +:+     +:+         +:+   +:+  +:+    +:+  +:+ +:+  +:+            +:+      +:+   +:+      +:+         +:+     +:+    +:+ :+:+:+  +:+ 
3910 +#+  +:+  +#+     +#+     +#+        +#++:++#++: +#+    +:+   +#++:   +#++:++#++     +#+     +#++:++#++:     +#+         +#+     +#+    +:+ +#+ +:+ +#+ 
3911 +#+       +#+     +#+     +#+        +#+     +#+ +#+    +#+    +#+           +#+     +#+     +#+     +#+     +#+         +#+     +#+    +#+ +#+  +#+#+# 
3912 #+#       #+#     #+#     #+#        #+#     #+# #+#    #+#    #+#    #+#    #+#     #+#     #+#     #+#     #+#         #+#     #+#    #+# #+#   #+#+# 
3913 ###       ### ########### ########## ###     ### #########     ###     ########      ###     ###     ###     ###     ###########  ########  ###    #### ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
3914 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
3915 */
3916 
3917 
3918 
3919 
3920 
3921 
3922 
3923 
3924 
3925 
3926 contract MiladyStationUpgraded is ERC721A, ERC721AQueryable, ERC721ABurnable, OperatorFilterer, Ownable, ERC2981 {
3927 
3928     uint public constant s_maxMiladyPurchase = 30;
3929     uint256 public constant s_MAXMILADYSTATIONS = 1212;
3930     uint256 public constant s_miladystationOG = 362;
3931 
3932     string public MILADYSTATION_PROVENANCE = '';
3933     string public IPFSURI = '';
3934 
3935     bool public s_saleIsActive = false;
3936     bool public operatorFilteringEnabled;
3937 
3938     IERC721Enumerable milady = IERC721Enumerable(0x5Af0D9827E0c53E4799BB226655A1de152A425a5);
3939 
3940     IERC721Enumerable ghiblady = IERC721Enumerable(0x186E74aD45bF81fb3712e9657560f8f6361cbBef);
3941     IERC721Enumerable pixelady = IERC721Enumerable(0x8Fc0D90f2C45a5e7f94904075c952e0943CFCCfd);
3942     IERC721Enumerable cig = IERC721Enumerable(0xEEd41d06AE195CA8f5CaCACE4cd691EE75F0683f);
3943     
3944     mapping(address => bool) public whitelistOneMint;
3945     mapping(address => bool) public miladyMinted;
3946 
3947     constructor() ERC721A("MiladyStation", "MS") {
3948         _registerForOperatorFiltering();
3949         operatorFilteringEnabled = true;
3950 
3951         // Set royalty receiver to the contract creator,
3952         // at 5% (default denominator is 10000).
3953         _setDefaultRoyalty(msg.sender, 500);
3954         _initializeOwner(msg.sender);
3955     }
3956 
3957     function setProvenanceHash(string memory provenanceHash) public onlyOwner {
3958         MILADYSTATION_PROVENANCE = provenanceHash;
3959     }
3960 
3961     function setBaseURI(string memory baseURI) public onlyOwner {
3962         IPFSURI = baseURI;
3963     }
3964 
3965     function _baseURI() internal view virtual override(ERC721A) returns (string memory) {
3966         return IPFSURI;
3967     }
3968 
3969     // the following functions are overrides for creator fee opensea default operator stuff
3970 
3971      function setApprovalForAll(address operator, bool approved)
3972         public
3973         override (IERC721A, ERC721A)
3974         onlyAllowedOperatorApproval(operator)
3975     {
3976         super.setApprovalForAll(operator, approved);
3977     }
3978 
3979     function approve(address operator, uint256 tokenId)
3980         public
3981         payable
3982         override (IERC721A, ERC721A)
3983         onlyAllowedOperatorApproval(operator)
3984     {
3985         super.approve(operator, tokenId);
3986     }
3987 
3988     function transferFrom(address from, address to, uint256 tokenId)
3989         public
3990         payable
3991         override (IERC721A, ERC721A)
3992         onlyAllowedOperator(from)
3993     {
3994         super.transferFrom(from, to, tokenId);
3995     }
3996 
3997     function safeTransferFrom(address from, address to, uint256 tokenId)
3998         public
3999         payable
4000         override (IERC721A, ERC721A)
4001         onlyAllowedOperator(from)
4002     {
4003         super.safeTransferFrom(from, to, tokenId);
4004     }
4005 
4006     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
4007         public
4008         payable
4009         override (IERC721A, ERC721A)
4010         onlyAllowedOperator(from)
4011     {
4012         super.safeTransferFrom(from, to, tokenId, data);
4013     }
4014 
4015     function supportsInterface(bytes4 interfaceId)
4016         public
4017         view
4018         virtual
4019         override (IERC721A, ERC721A, ERC2981)
4020         returns (bool)
4021     {
4022         // Supports the following `interfaceId`s:
4023         // - IERC165: 0x01ffc9a7
4024         // - IERC721: 0x80ac58cd
4025         // - IERC721Metadata: 0x5b5e139f
4026         // - IERC2981: 0x2a55205a
4027         return ERC721A.supportsInterface(interfaceId) || ERC2981.supportsInterface(interfaceId);
4028     }
4029 
4030     function setDefaultRoyalty(address receiver, uint96 feeNumerator) public onlyOwner {
4031         _setDefaultRoyalty(receiver, feeNumerator);
4032     }
4033 
4034     function setOperatorFilteringEnabled(bool value) public onlyOwner {
4035         operatorFilteringEnabled = value;
4036     }
4037 
4038     function _operatorFilteringEnabled() internal view override returns (bool) {
4039         return operatorFilteringEnabled;
4040     }
4041 
4042     function _isPriorityOperator(address operator) internal pure override returns (bool) {
4043         // OpenSea Seaport Conduit:
4044         // https://etherscan.io/address/0x1E0049783F008A0085193E00003D00cd54003c71
4045         // https://goerli.etherscan.io/address/0x1E0049783F008A0085193E00003D00cd54003c71
4046         return operator == address(0x1E0049783F008A0085193E00003D00cd54003c71);
4047     }
4048     
4049     function withdraw() public onlyOwner {
4050         uint balance = address(this).balance;
4051         payable(msg.sender).transfer(balance);
4052     }
4053 
4054     // Milady check
4055     function miladyHolderCheck(address holder) public view returns (uint256) {
4056         uint256 tokenNum = 0;
4057         try milady.balanceOf(holder) returns (uint256 miladyHolderIndex) {
4058             // First token owned by user
4059             tokenNum = miladyHolderIndex;
4060         } catch (bytes memory) {
4061             // No tokens owned by user
4062         }
4063         return tokenNum;
4064     }
4065     
4066     //Friend check
4067     function miladyFriendCheck(address holder) public view returns (uint256) {
4068         //fake token number
4069         uint256 tokenNum = 0;
4070         try ghiblady.balanceOf(holder) returns (uint256 miladyGhibIndex) {
4071             // First token owned by user
4072             tokenNum += miladyGhibIndex;
4073         } catch (bytes memory) {
4074             // No tokens owned by user
4075         }
4076         try pixelady.balanceOf(holder) returns (uint256 miladyPixIndex) {
4077             // First token owned by user
4078             tokenNum += miladyPixIndex;
4079         } catch (bytes memory) {
4080             // No tokens owned by user
4081         }
4082         try cig.balanceOf(holder) returns (uint256 miladyCigIndex) {
4083             // First token owned by user
4084             tokenNum += miladyCigIndex;
4085         } catch (bytes memory) {
4086             // No tokens owned by user
4087         }
4088         return tokenNum;
4089     }
4090 
4091     // secret free mint
4092 
4093     function editWhitelistOne(address[] memory array) public onlyOwner {
4094         for(uint256 i = 0; i < array.length; i++) {
4095             address addressElement = array[i];
4096             whitelistOneMint[addressElement] = true;
4097         }
4098     }
4099 
4100     function reserveMintMiladyStations(address target) public onlyOwner {
4101         require(totalSupply() == 0, "the time for this has passed.");
4102         uint256 numberOfTokens = s_miladystationOG;
4103         _mint(target, numberOfTokens);
4104     }
4105 
4106     function reserveMintMiladys() public {
4107         uint256 miladys = miladyHolderCheck(msg.sender);
4108         if (miladys > 0 && !miladyMinted[msg.sender]){
4109             miladyMinted[msg.sender] = true;
4110             _safeMint(msg.sender,1);
4111         } else {
4112             require(false, "Nice try buster, miladys only");
4113         }
4114     }
4115 
4116     function reserveMintWhitelist() public {
4117         if (msg.sender == owner()){
4118             _safeMint(msg.sender, 10);
4119             _safeMint(msg.sender, 10);
4120             _safeMint(msg.sender, 10);
4121         } else if (whitelistOneMint[msg.sender]){
4122             whitelistOneMint[msg.sender] = false;
4123             _safeMint(msg.sender, 2);
4124         } else {
4125             require(false, "Nice try buster, not on the list");
4126         }
4127     }
4128     
4129     function flipSaleState() public onlyOwner {
4130         s_saleIsActive = !s_saleIsActive;
4131     }
4132 
4133     function mintMiladys(uint256 numberOfTokens) public payable {
4134         require(s_saleIsActive, "Sale must be active to mint Miladys");
4135         require(numberOfTokens <= 30, "Can only mint up to 30 tokens at a time");
4136         require(totalSupply() + numberOfTokens < 1212, "Purchase would exceed max supply of Miladys");
4137         require(miladyHolderCheck(msg.sender) > 0, "wait but you don't have a milady.. ");
4138         //leaving in miladyholder check for posterity
4139 
4140         uint256 miladyPrice;
4141 
4142         //Prices defined 12/3/22
4143 
4144         //Mint for Miladys
4145         if (numberOfTokens == 30) {
4146             miladyPrice = 2000000000000000; // 0.002 ETH 
4147             require(miladyPrice*(numberOfTokens) <= msg.value, "Ether value sent is not correct");
4148         } else if (numberOfTokens >= 15) {
4149             miladyPrice = 3000000000000000; // 0.003 ETH 
4150             require(miladyPrice*(numberOfTokens) <= msg.value, "Ether value sent is not correct");
4151         } else if (numberOfTokens >= 5) {
4152             miladyPrice = 4000000000000000; // 0.004 ETH 
4153             require(miladyPrice*(numberOfTokens) <= msg.value, "Ether value sent is not correct");
4154         } else {
4155             miladyPrice = 5000000000000000; // 0.005 ETH should be 6 dollars
4156             require(miladyPrice*(numberOfTokens) <= msg.value, "Ether value sent is not correct");
4157         }
4158         //mint in batches of 8 to save gas on transfers
4159         if(numberOfTokens % 8 == 0){
4160             for(uint i = 0; i < numberOfTokens/8; i++) {
4161                 _mint(msg.sender,8);
4162             }
4163         } else {
4164             for(uint i = 0; i < numberOfTokens/8; i++) {
4165                 _mint(msg.sender,8);
4166             }
4167             _mint(msg.sender,numberOfTokens%8);
4168         }
4169     }
4170 
4171     function mintFriends(uint256 numberOfTokens) public payable {
4172         require(s_saleIsActive, "Sale must be active to mint MiladyStations");
4173         require(numberOfTokens <= 30, "Can only mint up to 30 tokens at a time");
4174         require(totalSupply() + numberOfTokens < 1212, "Purchase would exceed max supply of MiladyStations");
4175         // require(miladyFriendCheck(msg.sender) > 0, "pick up a ghib, pixel or cig for friend price.");
4176         //no friend check to save gas. exploitable, but really everyone is friend so is ok
4177         uint256 miladyPrice;
4178 
4179         //Mint for Friend of Milady
4180         //Ghiblady, Pixelady, Cigawrette Honorable Mentions: Miaura, Sonora, Milaidy
4181         if (numberOfTokens == 30) {
4182             miladyPrice = 6000000000000000; // 0.006 ETH
4183             require(miladyPrice*(numberOfTokens) <= msg.value, "Ether value sent is not correct");
4184         } else if (numberOfTokens >= 15) {
4185             miladyPrice = 7000000000000000; // 0.007 ETH
4186             require(miladyPrice*(numberOfTokens) <= msg.value, "Ether value sent is not correct");
4187         } else if (numberOfTokens >= 5) {
4188             miladyPrice = 8000000000000000; // 0.008 ETH
4189             require(miladyPrice*(numberOfTokens) <= msg.value, "Ether value sent is not correct");
4190         } else {
4191             miladyPrice = 9000000000000000; // 0.009 ETH should be 11 dollars
4192             require(miladyPrice*(numberOfTokens) <= msg.value, "Ether value sent is not correct");
4193         }
4194         //mint in batches of 8 to save gas on transfers
4195         if(numberOfTokens % 8 == 0){
4196             for(uint i = 0; i < numberOfTokens/8; i++) {
4197                 _mint(msg.sender,8);
4198             }
4199         } else {
4200             for(uint i = 0; i < numberOfTokens/8; i++) {
4201                 _mint(msg.sender,8);
4202             }
4203             _mint(msg.sender,numberOfTokens%8);
4204         }
4205     }
4206 
4207     function mintNew(uint256 numberOfTokens) public payable {
4208         require(s_saleIsActive, "Sale must be active to mint MiladyStations");
4209         require(numberOfTokens <= 30, "Can only mint up to 30 tokens at a time");
4210         require(totalSupply() + numberOfTokens < 1212, "Purchase would exceed max supply of MiladyStations");
4211         uint256 miladyPrice;
4212 
4213         if (numberOfTokens == 30) {
4214             miladyPrice = 9000000000000000; /// 0.009 ETH
4215             require(miladyPrice*(numberOfTokens) <= msg.value, "Ether value sent is not correct");
4216         } else if (numberOfTokens >= 15) {
4217             miladyPrice = 10000000000000000; // 0.010 ETH
4218             require(miladyPrice*(numberOfTokens) <= msg.value, "Ether value sent is not correct");
4219         } else if (numberOfTokens >= 5) {
4220             miladyPrice = 11000000000000000; // 0.011 ETH
4221             require(miladyPrice*(numberOfTokens) <= msg.value, "Ether value sent is not correct");
4222         } else {
4223             miladyPrice = 12000000000000000; // 0.012 ETH should be 15 dollars
4224             require(miladyPrice*(numberOfTokens) <= msg.value, "Ether value sent is not correct");
4225         }
4226         //mint in batches of 8 to save gas on erc721A transferFrom
4227         if(numberOfTokens % 8 == 0){
4228             for(uint i = 0; i < numberOfTokens/8; i++) {
4229                 _mint(msg.sender,8);
4230             }
4231         } else {
4232             for(uint i = 0; i < numberOfTokens/8; i++) {
4233                 _mint(msg.sender,8);
4234             }
4235             _mint(msg.sender,numberOfTokens%8);
4236         }
4237     }
4238 }