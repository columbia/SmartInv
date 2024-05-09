1 // File: Solady/src/auth/Ownable.sol
2 
3 
4 pragma solidity ^0.8.4;
5 
6 /// @notice Simple single owner authorization mixin.
7 /// @author Solady (https://github.com/vectorized/solady/blob/main/src/auth/Ownable.sol)
8 /// @dev While the ownable portion follows [EIP-173](https://eips.ethereum.org/EIPS/eip-173)
9 /// for compatibility, the nomenclature for the 2-step ownership handover
10 /// may be unique to this codebase.
11 abstract contract Ownable {
12     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
13     /*                       CUSTOM ERRORS                        */
14     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
15 
16     /// @dev The caller is not authorized to call the function.
17     error Unauthorized();
18 
19     /// @dev The `newOwner` cannot be the zero address.
20     error NewOwnerIsZeroAddress();
21 
22     /// @dev The `pendingOwner` does not have a valid handover request.
23     error NoHandoverRequest();
24 
25     /// @dev `bytes4(keccak256(bytes("Unauthorized()")))`.
26     uint256 private constant _UNAUTHORIZED_ERROR_SELECTOR = 0x82b42900;
27 
28     /// @dev `bytes4(keccak256(bytes("NewOwnerIsZeroAddress()")))`.
29     uint256 private constant _NEW_OWNER_IS_ZERO_ADDRESS_ERROR_SELECTOR = 0x7448fbae;
30 
31     /// @dev `bytes4(keccak256(bytes("NoHandoverRequest()")))`.
32     uint256 private constant _NO_HANDOVER_REQUEST_ERROR_SELECTOR = 0x6f5e8818;
33 
34     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
35     /*                           EVENTS                           */
36     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
37 
38     /// @dev The ownership is transferred from `oldOwner` to `newOwner`.
39     /// This event is intentionally kept the same as OpenZeppelin's Ownable to be
40     /// compatible with indexers and [EIP-173](https://eips.ethereum.org/EIPS/eip-173),
41     /// despite it not being as lightweight as a single argument event.
42     event OwnershipTransferred(address indexed oldOwner, address indexed newOwner);
43 
44     /// @dev An ownership handover to `pendingOwner` has been requested.
45     event OwnershipHandoverRequested(address indexed pendingOwner);
46 
47     /// @dev The ownership handover to `pendingOwner` has been canceled.
48     event OwnershipHandoverCanceled(address indexed pendingOwner);
49 
50     /// @dev `keccak256(bytes("OwnershipTransferred(address,address)"))`.
51     uint256 private constant _OWNERSHIP_TRANSFERRED_EVENT_SIGNATURE =
52         0x8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e0;
53 
54     /// @dev `keccak256(bytes("OwnershipHandoverRequested(address)"))`.
55     uint256 private constant _OWNERSHIP_HANDOVER_REQUESTED_EVENT_SIGNATURE =
56         0xdbf36a107da19e49527a7176a1babf963b4b0ff8cde35ee35d6cd8f1f9ac7e1d;
57 
58     /// @dev `keccak256(bytes("OwnershipHandoverCanceled(address)"))`.
59     uint256 private constant _OWNERSHIP_HANDOVER_CANCELED_EVENT_SIGNATURE =
60         0xfa7b8eab7da67f412cc9575ed43464468f9bfbae89d1675917346ca6d8fe3c92;
61 
62     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
63     /*                          STORAGE                           */
64     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
65 
66     /// @dev The owner slot is given by: `not(_OWNER_SLOT_NOT)`.
67     /// It is intentionally choosen to be a high value
68     /// to avoid collision with lower slots.
69     /// The choice of manual storage layout is to enable compatibility
70     /// with both regular and upgradeable contracts.
71     uint256 private constant _OWNER_SLOT_NOT = 0x8b78c6d8;
72 
73     /// The ownership handover slot of `newOwner` is given by:
74     /// ```
75     ///     mstore(0x00, or(shl(96, user), _HANDOVER_SLOT_SEED))
76     ///     let handoverSlot := keccak256(0x00, 0x20)
77     /// ```
78     /// It stores the expiry timestamp of the two-step ownership handover.
79     uint256 private constant _HANDOVER_SLOT_SEED = 0x389a75e1;
80 
81     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
82     /*                     INTERNAL FUNCTIONS                     */
83     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
84 
85     /// @dev Initializes the owner directly without authorization guard.
86     /// This function must be called upon initialization,
87     /// regardless of whether the contract is upgradeable or not.
88     /// This is to enable generalization to both regular and upgradeable contracts,
89     /// and to save gas in case the initial owner is not the caller.
90     /// For performance reasons, this function will not check if there
91     /// is an existing owner.
92     function _initializeOwner(address newOwner) internal virtual {
93         /// @solidity memory-safe-assembly
94         assembly {
95             // Clean the upper 96 bits.
96             newOwner := shr(96, shl(96, newOwner))
97             // Store the new value.
98             sstore(not(_OWNER_SLOT_NOT), newOwner)
99             // Emit the {OwnershipTransferred} event.
100             log3(0, 0, _OWNERSHIP_TRANSFERRED_EVENT_SIGNATURE, 0, newOwner)
101         }
102     }
103 
104     /// @dev Sets the owner directly without authorization guard.
105     function _setOwner(address newOwner) internal virtual {
106         /// @solidity memory-safe-assembly
107         assembly {
108             let ownerSlot := not(_OWNER_SLOT_NOT)
109             // Clean the upper 96 bits.
110             newOwner := shr(96, shl(96, newOwner))
111             // Emit the {OwnershipTransferred} event.
112             log3(0, 0, _OWNERSHIP_TRANSFERRED_EVENT_SIGNATURE, sload(ownerSlot), newOwner)
113             // Store the new value.
114             sstore(ownerSlot, newOwner)
115         }
116     }
117 
118     /// @dev Throws if the sender is not the owner.
119     function _checkOwner() internal view virtual {
120         /// @solidity memory-safe-assembly
121         assembly {
122             // If the caller is not the stored owner, revert.
123             if iszero(eq(caller(), sload(not(_OWNER_SLOT_NOT)))) {
124                 mstore(0x00, _UNAUTHORIZED_ERROR_SELECTOR)
125                 revert(0x1c, 0x04)
126             }
127         }
128     }
129 
130     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
131     /*                  PUBLIC UPDATE FUNCTIONS                   */
132     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
133 
134     /// @dev Allows the owner to transfer the ownership to `newOwner`.
135     function transferOwnership(address newOwner) public payable virtual onlyOwner {
136         if (newOwner == address(0)) revert NewOwnerIsZeroAddress();
137         _setOwner(newOwner);
138     }
139 
140     /// @dev Allows the owner to renounce their ownership.
141     function renounceOwnership() public payable virtual onlyOwner {
142         _setOwner(address(0));
143     }
144 
145     /// @dev Request a two-step ownership handover to the caller.
146     /// The request will be automatically expire in 48 hours (172800 seconds) by default.
147     function requestOwnershipHandover() public payable virtual {
148         unchecked {
149             uint256 expires = block.timestamp + ownershipHandoverValidFor();
150             /// @solidity memory-safe-assembly
151             assembly {
152                 // Compute and set the handover slot to 1.
153                 mstore(0x0c, _HANDOVER_SLOT_SEED)
154                 mstore(0x00, caller())
155                 sstore(keccak256(0x0c, 0x20), expires)
156                 // Emit the {OwnershipHandoverRequested} event.
157                 log2(0, 0, _OWNERSHIP_HANDOVER_REQUESTED_EVENT_SIGNATURE, caller())
158             }
159         }
160     }
161 
162     /// @dev Cancels the two-step ownership handover to the caller, if any.
163     function cancelOwnershipHandover() public payable virtual {
164         /// @solidity memory-safe-assembly
165         assembly {
166             // Compute and set the handover slot to 0.
167             mstore(0x0c, _HANDOVER_SLOT_SEED)
168             mstore(0x00, caller())
169             sstore(keccak256(0x0c, 0x20), 0)
170             // Emit the {OwnershipHandoverCanceled} event.
171             log2(0, 0, _OWNERSHIP_HANDOVER_CANCELED_EVENT_SIGNATURE, caller())
172         }
173     }
174 
175     /// @dev Allows the owner to complete the two-step ownership handover to `pendingOwner`.
176     /// Reverts if there is no existing ownership handover requested by `pendingOwner`.
177     function completeOwnershipHandover(address pendingOwner) public payable virtual onlyOwner {
178         /// @solidity memory-safe-assembly
179         assembly {
180             // Compute and set the handover slot to 0.
181             mstore(0x0c, _HANDOVER_SLOT_SEED)
182             mstore(0x00, pendingOwner)
183             let handoverSlot := keccak256(0x0c, 0x20)
184             // If the handover does not exist, or has expired.
185             if gt(timestamp(), sload(handoverSlot)) {
186                 mstore(0x00, _NO_HANDOVER_REQUEST_ERROR_SELECTOR)
187                 revert(0x1c, 0x04)
188             }
189             // Set the handover slot to 0.
190             sstore(handoverSlot, 0)
191             // Clean the upper 96 bits.
192             let newOwner := shr(96, mload(0x0c))
193             // Emit the {OwnershipTransferred} event.
194             log3(0, 0, _OWNERSHIP_TRANSFERRED_EVENT_SIGNATURE, caller(), newOwner)
195             // Store the new value.
196             sstore(not(_OWNER_SLOT_NOT), newOwner)
197         }
198     }
199 
200     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
201     /*                   PUBLIC READ FUNCTIONS                    */
202     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
203 
204     /// @dev Returns the owner of the contract.
205     function owner() public view virtual returns (address result) {
206         /// @solidity memory-safe-assembly
207         assembly {
208             result := sload(not(_OWNER_SLOT_NOT))
209         }
210     }
211 
212     /// @dev Returns the expiry timestamp for the two-step ownership handover to `pendingOwner`.
213     function ownershipHandoverExpiresAt(address pendingOwner)
214         public
215         view
216         virtual
217         returns (uint256 result)
218     {
219         /// @solidity memory-safe-assembly
220         assembly {
221             // Compute the handover slot.
222             mstore(0x0c, _HANDOVER_SLOT_SEED)
223             mstore(0x00, pendingOwner)
224             // Load the handover slot.
225             result := sload(keccak256(0x0c, 0x20))
226         }
227     }
228 
229     /// @dev Returns how long a two-step ownership handover is valid for in seconds.
230     function ownershipHandoverValidFor() public view virtual returns (uint64) {
231         return 48 * 3600;
232     }
233 
234     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
235     /*                         MODIFIERS                          */
236     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
237 
238     /// @dev Marks a function as only callable by the owner.
239     modifier onlyOwner() virtual {
240         _checkOwner();
241         _;
242     }
243 }
244 
245 // File: erc721a/contracts/IERC721A.sol
246 
247 
248 // ERC721A Contracts v4.2.3
249 // Creator: Chiru Labs
250 
251 pragma solidity ^0.8.4;
252 
253 /**
254  * @dev Interface of ERC721A.
255  */
256 interface IERC721A {
257     /**
258      * The caller must own the token or be an approved operator.
259      */
260     error ApprovalCallerNotOwnerNorApproved();
261 
262     /**
263      * The token does not exist.
264      */
265     error ApprovalQueryForNonexistentToken();
266 
267     /**
268      * Cannot query the balance for the zero address.
269      */
270     error BalanceQueryForZeroAddress();
271 
272     /**
273      * Cannot mint to the zero address.
274      */
275     error MintToZeroAddress();
276 
277     /**
278      * The quantity of tokens minted must be more than zero.
279      */
280     error MintZeroQuantity();
281 
282     /**
283      * The token does not exist.
284      */
285     error OwnerQueryForNonexistentToken();
286 
287     /**
288      * The caller must own the token or be an approved operator.
289      */
290     error TransferCallerNotOwnerNorApproved();
291 
292     /**
293      * The token must be owned by `from`.
294      */
295     error TransferFromIncorrectOwner();
296 
297     /**
298      * Cannot safely transfer to a contract that does not implement the
299      * ERC721Receiver interface.
300      */
301     error TransferToNonERC721ReceiverImplementer();
302 
303     /**
304      * Cannot transfer to the zero address.
305      */
306     error TransferToZeroAddress();
307 
308     /**
309      * The token does not exist.
310      */
311     error URIQueryForNonexistentToken();
312 
313     /**
314      * The `quantity` minted with ERC2309 exceeds the safety limit.
315      */
316     error MintERC2309QuantityExceedsLimit();
317 
318     /**
319      * The `extraData` cannot be set on an unintialized ownership slot.
320      */
321     error OwnershipNotInitializedForExtraData();
322 
323     // =============================================================
324     //                            STRUCTS
325     // =============================================================
326 
327     struct TokenOwnership {
328         // The address of the owner.
329         address addr;
330         // Stores the start time of ownership with minimal overhead for tokenomics.
331         uint64 startTimestamp;
332         // Whether the token has been burned.
333         bool burned;
334         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
335         uint24 extraData;
336     }
337 
338     // =============================================================
339     //                         TOKEN COUNTERS
340     // =============================================================
341 
342     /**
343      * @dev Returns the total number of tokens in existence.
344      * Burned tokens will reduce the count.
345      * To get the total number of tokens minted, please see {_totalMinted}.
346      */
347     function totalSupply() external view returns (uint256);
348 
349     // =============================================================
350     //                            IERC165
351     // =============================================================
352 
353     /**
354      * @dev Returns true if this contract implements the interface defined by
355      * `interfaceId`. See the corresponding
356      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
357      * to learn more about how these ids are created.
358      *
359      * This function call must use less than 30000 gas.
360      */
361     function supportsInterface(bytes4 interfaceId) external view returns (bool);
362 
363     // =============================================================
364     //                            IERC721
365     // =============================================================
366 
367     /**
368      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
369      */
370     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
371 
372     /**
373      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
374      */
375     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
376 
377     /**
378      * @dev Emitted when `owner` enables or disables
379      * (`approved`) `operator` to manage all of its assets.
380      */
381     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
382 
383     /**
384      * @dev Returns the number of tokens in `owner`'s account.
385      */
386     function balanceOf(address owner) external view returns (uint256 balance);
387 
388     /**
389      * @dev Returns the owner of the `tokenId` token.
390      *
391      * Requirements:
392      *
393      * - `tokenId` must exist.
394      */
395     function ownerOf(uint256 tokenId) external view returns (address owner);
396 
397     /**
398      * @dev Safely transfers `tokenId` token from `from` to `to`,
399      * checking first that contract recipients are aware of the ERC721 protocol
400      * to prevent tokens from being forever locked.
401      *
402      * Requirements:
403      *
404      * - `from` cannot be the zero address.
405      * - `to` cannot be the zero address.
406      * - `tokenId` token must exist and be owned by `from`.
407      * - If the caller is not `from`, it must be have been allowed to move
408      * this token by either {approve} or {setApprovalForAll}.
409      * - If `to` refers to a smart contract, it must implement
410      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
411      *
412      * Emits a {Transfer} event.
413      */
414     function safeTransferFrom(
415         address from,
416         address to,
417         uint256 tokenId,
418         bytes calldata data
419     ) external payable;
420 
421     /**
422      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
423      */
424     function safeTransferFrom(
425         address from,
426         address to,
427         uint256 tokenId
428     ) external payable;
429 
430     /**
431      * @dev Transfers `tokenId` from `from` to `to`.
432      *
433      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
434      * whenever possible.
435      *
436      * Requirements:
437      *
438      * - `from` cannot be the zero address.
439      * - `to` cannot be the zero address.
440      * - `tokenId` token must be owned by `from`.
441      * - If the caller is not `from`, it must be approved to move this token
442      * by either {approve} or {setApprovalForAll}.
443      *
444      * Emits a {Transfer} event.
445      */
446     function transferFrom(
447         address from,
448         address to,
449         uint256 tokenId
450     ) external payable;
451 
452     /**
453      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
454      * The approval is cleared when the token is transferred.
455      *
456      * Only a single account can be approved at a time, so approving the
457      * zero address clears previous approvals.
458      *
459      * Requirements:
460      *
461      * - The caller must own the token or be an approved operator.
462      * - `tokenId` must exist.
463      *
464      * Emits an {Approval} event.
465      */
466     function approve(address to, uint256 tokenId) external payable;
467 
468     /**
469      * @dev Approve or remove `operator` as an operator for the caller.
470      * Operators can call {transferFrom} or {safeTransferFrom}
471      * for any token owned by the caller.
472      *
473      * Requirements:
474      *
475      * - The `operator` cannot be the caller.
476      *
477      * Emits an {ApprovalForAll} event.
478      */
479     function setApprovalForAll(address operator, bool _approved) external;
480 
481     /**
482      * @dev Returns the account approved for `tokenId` token.
483      *
484      * Requirements:
485      *
486      * - `tokenId` must exist.
487      */
488     function getApproved(uint256 tokenId) external view returns (address operator);
489 
490     /**
491      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
492      *
493      * See {setApprovalForAll}.
494      */
495     function isApprovedForAll(address owner, address operator) external view returns (bool);
496 
497     // =============================================================
498     //                        IERC721Metadata
499     // =============================================================
500 
501     /**
502      * @dev Returns the token collection name.
503      */
504     function name() external view returns (string memory);
505 
506     /**
507      * @dev Returns the token collection symbol.
508      */
509     function symbol() external view returns (string memory);
510 
511     /**
512      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
513      */
514     function tokenURI(uint256 tokenId) external view returns (string memory);
515 
516     // =============================================================
517     //                           IERC2309
518     // =============================================================
519 
520     /**
521      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
522      * (inclusive) is transferred from `from` to `to`, as defined in the
523      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
524      *
525      * See {_mintERC2309} for more details.
526      */
527     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
528 }
529 
530 // File: erc721a/contracts/extensions/IERC721AQueryable.sol
531 
532 
533 // ERC721A Contracts v4.2.3
534 // Creator: Chiru Labs
535 
536 pragma solidity ^0.8.4;
537 
538 
539 /**
540  * @dev Interface of ERC721AQueryable.
541  */
542 interface IERC721AQueryable is IERC721A {
543     /**
544      * Invalid query range (`start` >= `stop`).
545      */
546     error InvalidQueryRange();
547 
548     /**
549      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
550      *
551      * If the `tokenId` is out of bounds:
552      *
553      * - `addr = address(0)`
554      * - `startTimestamp = 0`
555      * - `burned = false`
556      * - `extraData = 0`
557      *
558      * If the `tokenId` is burned:
559      *
560      * - `addr = <Address of owner before token was burned>`
561      * - `startTimestamp = <Timestamp when token was burned>`
562      * - `burned = true`
563      * - `extraData = <Extra data when token was burned>`
564      *
565      * Otherwise:
566      *
567      * - `addr = <Address of owner>`
568      * - `startTimestamp = <Timestamp of start of ownership>`
569      * - `burned = false`
570      * - `extraData = <Extra data at start of ownership>`
571      */
572     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
573 
574     /**
575      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
576      * See {ERC721AQueryable-explicitOwnershipOf}
577      */
578     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
579 
580     /**
581      * @dev Returns an array of token IDs owned by `owner`,
582      * in the range [`start`, `stop`)
583      * (i.e. `start <= tokenId < stop`).
584      *
585      * This function allows for tokens to be queried if the collection
586      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
587      *
588      * Requirements:
589      *
590      * - `start < stop`
591      */
592     function tokensOfOwnerIn(
593         address owner,
594         uint256 start,
595         uint256 stop
596     ) external view returns (uint256[] memory);
597 
598     /**
599      * @dev Returns an array of token IDs owned by `owner`.
600      *
601      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
602      * It is meant to be called off-chain.
603      *
604      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
605      * multiple smaller scans if the collection is large enough to cause
606      * an out-of-gas error (10K collections should be fine).
607      */
608     function tokensOfOwner(address owner) external view returns (uint256[] memory);
609 }
610 
611 // File: erc721a/contracts/extensions/IERC721ABurnable.sol
612 
613 
614 // ERC721A Contracts v4.2.3
615 // Creator: Chiru Labs
616 
617 pragma solidity ^0.8.4;
618 
619 
620 /**
621  * @dev Interface of ERC721ABurnable.
622  */
623 interface IERC721ABurnable is IERC721A {
624     /**
625      * @dev Burns `tokenId`. See {ERC721A-_burn}.
626      *
627      * Requirements:
628      *
629      * - The caller must own `tokenId` or be an approved operator.
630      */
631     function burn(uint256 tokenId) external;
632 }
633 
634 // File: erc721a/contracts/ERC721A.sol
635 
636 
637 // ERC721A Contracts v4.2.3
638 // Creator: Chiru Labs
639 
640 pragma solidity ^0.8.4;
641 
642 
643 /**
644  * @dev Interface of ERC721 token receiver.
645  */
646 interface ERC721A__IERC721Receiver {
647     function onERC721Received(
648         address operator,
649         address from,
650         uint256 tokenId,
651         bytes calldata data
652     ) external returns (bytes4);
653 }
654 
655 /**
656  * @title ERC721A
657  *
658  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
659  * Non-Fungible Token Standard, including the Metadata extension.
660  * Optimized for lower gas during batch mints.
661  *
662  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
663  * starting from `_startTokenId()`.
664  *
665  * Assumptions:
666  *
667  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
668  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
669  */
670 contract ERC721A is IERC721A {
671     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
672     struct TokenApprovalRef {
673         address value;
674     }
675 
676     // =============================================================
677     //                           CONSTANTS
678     // =============================================================
679 
680     // Mask of an entry in packed address data.
681     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
682 
683     // The bit position of `numberMinted` in packed address data.
684     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
685 
686     // The bit position of `numberBurned` in packed address data.
687     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
688 
689     // The bit position of `aux` in packed address data.
690     uint256 private constant _BITPOS_AUX = 192;
691 
692     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
693     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
694 
695     // The bit position of `startTimestamp` in packed ownership.
696     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
697 
698     // The bit mask of the `burned` bit in packed ownership.
699     uint256 private constant _BITMASK_BURNED = 1 << 224;
700 
701     // The bit position of the `nextInitialized` bit in packed ownership.
702     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
703 
704     // The bit mask of the `nextInitialized` bit in packed ownership.
705     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
706 
707     // The bit position of `extraData` in packed ownership.
708     uint256 private constant _BITPOS_EXTRA_DATA = 232;
709 
710     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
711     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
712 
713     // The mask of the lower 160 bits for addresses.
714     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
715 
716     // The maximum `quantity` that can be minted with {_mintERC2309}.
717     // This limit is to prevent overflows on the address data entries.
718     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
719     // is required to cause an overflow, which is unrealistic.
720     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
721 
722     // The `Transfer` event signature is given by:
723     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
724     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
725         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
726 
727     // =============================================================
728     //                            STORAGE
729     // =============================================================
730 
731     // The next token ID to be minted.
732     uint256 private _currentIndex;
733 
734     // The number of tokens burned.
735     uint256 private _burnCounter;
736 
737     // Token name
738     string private _name;
739 
740     // Token symbol
741     string private _symbol;
742 
743     // Mapping from token ID to ownership details
744     // An empty struct value does not necessarily mean the token is unowned.
745     // See {_packedOwnershipOf} implementation for details.
746     //
747     // Bits Layout:
748     // - [0..159]   `addr`
749     // - [160..223] `startTimestamp`
750     // - [224]      `burned`
751     // - [225]      `nextInitialized`
752     // - [232..255] `extraData`
753     mapping(uint256 => uint256) private _packedOwnerships;
754 
755     // Mapping owner address to address data.
756     //
757     // Bits Layout:
758     // - [0..63]    `balance`
759     // - [64..127]  `numberMinted`
760     // - [128..191] `numberBurned`
761     // - [192..255] `aux`
762     mapping(address => uint256) private _packedAddressData;
763 
764     // Mapping from token ID to approved address.
765     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
766 
767     // Mapping from owner to operator approvals
768     mapping(address => mapping(address => bool)) private _operatorApprovals;
769 
770     // =============================================================
771     //                          CONSTRUCTOR
772     // =============================================================
773 
774     constructor(string memory name_, string memory symbol_) {
775         _name = name_;
776         _symbol = symbol_;
777         _currentIndex = _startTokenId();
778     }
779 
780     // =============================================================
781     //                   TOKEN COUNTING OPERATIONS
782     // =============================================================
783 
784     /**
785      * @dev Returns the starting token ID.
786      * To change the starting token ID, please override this function.
787      */
788     function _startTokenId() internal view virtual returns (uint256) {
789         return 0;
790     }
791 
792     /**
793      * @dev Returns the next token ID to be minted.
794      */
795     function _nextTokenId() internal view virtual returns (uint256) {
796         return _currentIndex;
797     }
798 
799     /**
800      * @dev Returns the total number of tokens in existence.
801      * Burned tokens will reduce the count.
802      * To get the total number of tokens minted, please see {_totalMinted}.
803      */
804     function totalSupply() public view virtual override returns (uint256) {
805         // Counter underflow is impossible as _burnCounter cannot be incremented
806         // more than `_currentIndex - _startTokenId()` times.
807         unchecked {
808             return _currentIndex - _burnCounter - _startTokenId();
809         }
810     }
811 
812     /**
813      * @dev Returns the total amount of tokens minted in the contract.
814      */
815     function _totalMinted() internal view virtual returns (uint256) {
816         // Counter underflow is impossible as `_currentIndex` does not decrement,
817         // and it is initialized to `_startTokenId()`.
818         unchecked {
819             return _currentIndex - _startTokenId();
820         }
821     }
822 
823     /**
824      * @dev Returns the total number of tokens burned.
825      */
826     function _totalBurned() internal view virtual returns (uint256) {
827         return _burnCounter;
828     }
829 
830     // =============================================================
831     //                    ADDRESS DATA OPERATIONS
832     // =============================================================
833 
834     /**
835      * @dev Returns the number of tokens in `owner`'s account.
836      */
837     function balanceOf(address owner) public view virtual override returns (uint256) {
838         if (owner == address(0)) revert BalanceQueryForZeroAddress();
839         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
840     }
841 
842     /**
843      * Returns the number of tokens minted by `owner`.
844      */
845     function _numberMinted(address owner) internal view returns (uint256) {
846         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
847     }
848 
849     /**
850      * Returns the number of tokens burned by or on behalf of `owner`.
851      */
852     function _numberBurned(address owner) internal view returns (uint256) {
853         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
854     }
855 
856     /**
857      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
858      */
859     function _getAux(address owner) internal view returns (uint64) {
860         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
861     }
862 
863     /**
864      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
865      * If there are multiple variables, please pack them into a uint64.
866      */
867     function _setAux(address owner, uint64 aux) internal virtual {
868         uint256 packed = _packedAddressData[owner];
869         uint256 auxCasted;
870         // Cast `aux` with assembly to avoid redundant masking.
871         assembly {
872             auxCasted := aux
873         }
874         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
875         _packedAddressData[owner] = packed;
876     }
877 
878     // =============================================================
879     //                            IERC165
880     // =============================================================
881 
882     /**
883      * @dev Returns true if this contract implements the interface defined by
884      * `interfaceId`. See the corresponding
885      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
886      * to learn more about how these ids are created.
887      *
888      * This function call must use less than 30000 gas.
889      */
890     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
891         // The interface IDs are constants representing the first 4 bytes
892         // of the XOR of all function selectors in the interface.
893         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
894         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
895         return
896             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
897             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
898             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
899     }
900 
901     // =============================================================
902     //                        IERC721Metadata
903     // =============================================================
904 
905     /**
906      * @dev Returns the token collection name.
907      */
908     function name() public view virtual override returns (string memory) {
909         return _name;
910     }
911 
912     /**
913      * @dev Returns the token collection symbol.
914      */
915     function symbol() public view virtual override returns (string memory) {
916         return _symbol;
917     }
918 
919     /**
920      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
921      */
922     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
923         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
924 
925         string memory baseURI = _baseURI();
926         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
927     }
928 
929     /**
930      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
931      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
932      * by default, it can be overridden in child contracts.
933      */
934     function _baseURI() internal view virtual returns (string memory) {
935         return '';
936     }
937 
938     // =============================================================
939     //                     OWNERSHIPS OPERATIONS
940     // =============================================================
941 
942     /**
943      * @dev Returns the owner of the `tokenId` token.
944      *
945      * Requirements:
946      *
947      * - `tokenId` must exist.
948      */
949     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
950         return address(uint160(_packedOwnershipOf(tokenId)));
951     }
952 
953     /**
954      * @dev Gas spent here starts off proportional to the maximum mint batch size.
955      * It gradually moves to O(1) as tokens get transferred around over time.
956      */
957     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
958         return _unpackedOwnership(_packedOwnershipOf(tokenId));
959     }
960 
961     /**
962      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
963      */
964     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
965         return _unpackedOwnership(_packedOwnerships[index]);
966     }
967 
968     /**
969      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
970      */
971     function _initializeOwnershipAt(uint256 index) internal virtual {
972         if (_packedOwnerships[index] == 0) {
973             _packedOwnerships[index] = _packedOwnershipOf(index);
974         }
975     }
976 
977     /**
978      * Returns the packed ownership data of `tokenId`.
979      */
980     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
981         uint256 curr = tokenId;
982 
983         unchecked {
984             if (_startTokenId() <= curr)
985                 if (curr < _currentIndex) {
986                     uint256 packed = _packedOwnerships[curr];
987                     // If not burned.
988                     if (packed & _BITMASK_BURNED == 0) {
989                         // Invariant:
990                         // There will always be an initialized ownership slot
991                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
992                         // before an unintialized ownership slot
993                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
994                         // Hence, `curr` will not underflow.
995                         //
996                         // We can directly compare the packed value.
997                         // If the address is zero, packed will be zero.
998                         while (packed == 0) {
999                             packed = _packedOwnerships[--curr];
1000                         }
1001                         return packed;
1002                     }
1003                 }
1004         }
1005         revert OwnerQueryForNonexistentToken();
1006     }
1007 
1008     /**
1009      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1010      */
1011     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1012         ownership.addr = address(uint160(packed));
1013         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1014         ownership.burned = packed & _BITMASK_BURNED != 0;
1015         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1016     }
1017 
1018     /**
1019      * @dev Packs ownership data into a single uint256.
1020      */
1021     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1022         assembly {
1023             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1024             owner := and(owner, _BITMASK_ADDRESS)
1025             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1026             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1027         }
1028     }
1029 
1030     /**
1031      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1032      */
1033     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1034         // For branchless setting of the `nextInitialized` flag.
1035         assembly {
1036             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1037             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1038         }
1039     }
1040 
1041     // =============================================================
1042     //                      APPROVAL OPERATIONS
1043     // =============================================================
1044 
1045     /**
1046      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1047      * The approval is cleared when the token is transferred.
1048      *
1049      * Only a single account can be approved at a time, so approving the
1050      * zero address clears previous approvals.
1051      *
1052      * Requirements:
1053      *
1054      * - The caller must own the token or be an approved operator.
1055      * - `tokenId` must exist.
1056      *
1057      * Emits an {Approval} event.
1058      */
1059     function approve(address to, uint256 tokenId) public payable virtual override {
1060         address owner = ownerOf(tokenId);
1061 
1062         if (_msgSenderERC721A() != owner)
1063             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1064                 revert ApprovalCallerNotOwnerNorApproved();
1065             }
1066 
1067         _tokenApprovals[tokenId].value = to;
1068         emit Approval(owner, to, tokenId);
1069     }
1070 
1071     /**
1072      * @dev Returns the account approved for `tokenId` token.
1073      *
1074      * Requirements:
1075      *
1076      * - `tokenId` must exist.
1077      */
1078     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1079         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1080 
1081         return _tokenApprovals[tokenId].value;
1082     }
1083 
1084     /**
1085      * @dev Approve or remove `operator` as an operator for the caller.
1086      * Operators can call {transferFrom} or {safeTransferFrom}
1087      * for any token owned by the caller.
1088      *
1089      * Requirements:
1090      *
1091      * - The `operator` cannot be the caller.
1092      *
1093      * Emits an {ApprovalForAll} event.
1094      */
1095     function setApprovalForAll(address operator, bool approved) public virtual override {
1096         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1097         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1098     }
1099 
1100     /**
1101      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1102      *
1103      * See {setApprovalForAll}.
1104      */
1105     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1106         return _operatorApprovals[owner][operator];
1107     }
1108 
1109     /**
1110      * @dev Returns whether `tokenId` exists.
1111      *
1112      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1113      *
1114      * Tokens start existing when they are minted. See {_mint}.
1115      */
1116     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1117         return
1118             _startTokenId() <= tokenId &&
1119             tokenId < _currentIndex && // If within bounds,
1120             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1121     }
1122 
1123     /**
1124      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1125      */
1126     function _isSenderApprovedOrOwner(
1127         address approvedAddress,
1128         address owner,
1129         address msgSender
1130     ) private pure returns (bool result) {
1131         assembly {
1132             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1133             owner := and(owner, _BITMASK_ADDRESS)
1134             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1135             msgSender := and(msgSender, _BITMASK_ADDRESS)
1136             // `msgSender == owner || msgSender == approvedAddress`.
1137             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1138         }
1139     }
1140 
1141     /**
1142      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1143      */
1144     function _getApprovedSlotAndAddress(uint256 tokenId)
1145         private
1146         view
1147         returns (uint256 approvedAddressSlot, address approvedAddress)
1148     {
1149         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1150         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1151         assembly {
1152             approvedAddressSlot := tokenApproval.slot
1153             approvedAddress := sload(approvedAddressSlot)
1154         }
1155     }
1156 
1157     // =============================================================
1158     //                      TRANSFER OPERATIONS
1159     // =============================================================
1160 
1161     /**
1162      * @dev Transfers `tokenId` from `from` to `to`.
1163      *
1164      * Requirements:
1165      *
1166      * - `from` cannot be the zero address.
1167      * - `to` cannot be the zero address.
1168      * - `tokenId` token must be owned by `from`.
1169      * - If the caller is not `from`, it must be approved to move this token
1170      * by either {approve} or {setApprovalForAll}.
1171      *
1172      * Emits a {Transfer} event.
1173      */
1174     function transferFrom(
1175         address from,
1176         address to,
1177         uint256 tokenId
1178     ) public payable virtual override {
1179         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1180 
1181         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1182 
1183         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1184 
1185         // The nested ifs save around 20+ gas over a compound boolean condition.
1186         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1187             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1188 
1189         if (to == address(0)) revert TransferToZeroAddress();
1190 
1191         _beforeTokenTransfers(from, to, tokenId, 1);
1192 
1193         // Clear approvals from the previous owner.
1194         assembly {
1195             if approvedAddress {
1196                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1197                 sstore(approvedAddressSlot, 0)
1198             }
1199         }
1200 
1201         // Underflow of the sender's balance is impossible because we check for
1202         // ownership above and the recipient's balance can't realistically overflow.
1203         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1204         unchecked {
1205             // We can directly increment and decrement the balances.
1206             --_packedAddressData[from]; // Updates: `balance -= 1`.
1207             ++_packedAddressData[to]; // Updates: `balance += 1`.
1208 
1209             // Updates:
1210             // - `address` to the next owner.
1211             // - `startTimestamp` to the timestamp of transfering.
1212             // - `burned` to `false`.
1213             // - `nextInitialized` to `true`.
1214             _packedOwnerships[tokenId] = _packOwnershipData(
1215                 to,
1216                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1217             );
1218 
1219             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1220             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1221                 uint256 nextTokenId = tokenId + 1;
1222                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1223                 if (_packedOwnerships[nextTokenId] == 0) {
1224                     // If the next slot is within bounds.
1225                     if (nextTokenId != _currentIndex) {
1226                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1227                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1228                     }
1229                 }
1230             }
1231         }
1232 
1233         emit Transfer(from, to, tokenId);
1234         _afterTokenTransfers(from, to, tokenId, 1);
1235     }
1236 
1237     /**
1238      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1239      */
1240     function safeTransferFrom(
1241         address from,
1242         address to,
1243         uint256 tokenId
1244     ) public payable virtual override {
1245         safeTransferFrom(from, to, tokenId, '');
1246     }
1247 
1248     /**
1249      * @dev Safely transfers `tokenId` token from `from` to `to`.
1250      *
1251      * Requirements:
1252      *
1253      * - `from` cannot be the zero address.
1254      * - `to` cannot be the zero address.
1255      * - `tokenId` token must exist and be owned by `from`.
1256      * - If the caller is not `from`, it must be approved to move this token
1257      * by either {approve} or {setApprovalForAll}.
1258      * - If `to` refers to a smart contract, it must implement
1259      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1260      *
1261      * Emits a {Transfer} event.
1262      */
1263     function safeTransferFrom(
1264         address from,
1265         address to,
1266         uint256 tokenId,
1267         bytes memory _data
1268     ) public payable virtual override {
1269         transferFrom(from, to, tokenId);
1270         if (to.code.length != 0)
1271             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1272                 revert TransferToNonERC721ReceiverImplementer();
1273             }
1274     }
1275 
1276     /**
1277      * @dev Hook that is called before a set of serially-ordered token IDs
1278      * are about to be transferred. This includes minting.
1279      * And also called before burning one token.
1280      *
1281      * `startTokenId` - the first token ID to be transferred.
1282      * `quantity` - the amount to be transferred.
1283      *
1284      * Calling conditions:
1285      *
1286      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1287      * transferred to `to`.
1288      * - When `from` is zero, `tokenId` will be minted for `to`.
1289      * - When `to` is zero, `tokenId` will be burned by `from`.
1290      * - `from` and `to` are never both zero.
1291      */
1292     function _beforeTokenTransfers(
1293         address from,
1294         address to,
1295         uint256 startTokenId,
1296         uint256 quantity
1297     ) internal virtual {}
1298 
1299     /**
1300      * @dev Hook that is called after a set of serially-ordered token IDs
1301      * have been transferred. This includes minting.
1302      * And also called after one token has been burned.
1303      *
1304      * `startTokenId` - the first token ID to be transferred.
1305      * `quantity` - the amount to be transferred.
1306      *
1307      * Calling conditions:
1308      *
1309      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1310      * transferred to `to`.
1311      * - When `from` is zero, `tokenId` has been minted for `to`.
1312      * - When `to` is zero, `tokenId` has been burned by `from`.
1313      * - `from` and `to` are never both zero.
1314      */
1315     function _afterTokenTransfers(
1316         address from,
1317         address to,
1318         uint256 startTokenId,
1319         uint256 quantity
1320     ) internal virtual {}
1321 
1322     /**
1323      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1324      *
1325      * `from` - Previous owner of the given token ID.
1326      * `to` - Target address that will receive the token.
1327      * `tokenId` - Token ID to be transferred.
1328      * `_data` - Optional data to send along with the call.
1329      *
1330      * Returns whether the call correctly returned the expected magic value.
1331      */
1332     function _checkContractOnERC721Received(
1333         address from,
1334         address to,
1335         uint256 tokenId,
1336         bytes memory _data
1337     ) private returns (bool) {
1338         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1339             bytes4 retval
1340         ) {
1341             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1342         } catch (bytes memory reason) {
1343             if (reason.length == 0) {
1344                 revert TransferToNonERC721ReceiverImplementer();
1345             } else {
1346                 assembly {
1347                     revert(add(32, reason), mload(reason))
1348                 }
1349             }
1350         }
1351     }
1352 
1353     // =============================================================
1354     //                        MINT OPERATIONS
1355     // =============================================================
1356 
1357     /**
1358      * @dev Mints `quantity` tokens and transfers them to `to`.
1359      *
1360      * Requirements:
1361      *
1362      * - `to` cannot be the zero address.
1363      * - `quantity` must be greater than 0.
1364      *
1365      * Emits a {Transfer} event for each mint.
1366      */
1367     function _mint(address to, uint256 quantity) internal virtual {
1368         uint256 startTokenId = _currentIndex;
1369         if (quantity == 0) revert MintZeroQuantity();
1370 
1371         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1372 
1373         // Overflows are incredibly unrealistic.
1374         // `balance` and `numberMinted` have a maximum limit of 2**64.
1375         // `tokenId` has a maximum limit of 2**256.
1376         unchecked {
1377             // Updates:
1378             // - `balance += quantity`.
1379             // - `numberMinted += quantity`.
1380             //
1381             // We can directly add to the `balance` and `numberMinted`.
1382             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1383 
1384             // Updates:
1385             // - `address` to the owner.
1386             // - `startTimestamp` to the timestamp of minting.
1387             // - `burned` to `false`.
1388             // - `nextInitialized` to `quantity == 1`.
1389             _packedOwnerships[startTokenId] = _packOwnershipData(
1390                 to,
1391                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1392             );
1393 
1394             uint256 toMasked;
1395             uint256 end = startTokenId + quantity;
1396 
1397             // Use assembly to loop and emit the `Transfer` event for gas savings.
1398             // The duplicated `log4` removes an extra check and reduces stack juggling.
1399             // The assembly, together with the surrounding Solidity code, have been
1400             // delicately arranged to nudge the compiler into producing optimized opcodes.
1401             assembly {
1402                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1403                 toMasked := and(to, _BITMASK_ADDRESS)
1404                 // Emit the `Transfer` event.
1405                 log4(
1406                     0, // Start of data (0, since no data).
1407                     0, // End of data (0, since no data).
1408                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1409                     0, // `address(0)`.
1410                     toMasked, // `to`.
1411                     startTokenId // `tokenId`.
1412                 )
1413 
1414                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1415                 // that overflows uint256 will make the loop run out of gas.
1416                 // The compiler will optimize the `iszero` away for performance.
1417                 for {
1418                     let tokenId := add(startTokenId, 1)
1419                 } iszero(eq(tokenId, end)) {
1420                     tokenId := add(tokenId, 1)
1421                 } {
1422                     // Emit the `Transfer` event. Similar to above.
1423                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1424                 }
1425             }
1426             if (toMasked == 0) revert MintToZeroAddress();
1427 
1428             _currentIndex = end;
1429         }
1430         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1431     }
1432 
1433     /**
1434      * @dev Mints `quantity` tokens and transfers them to `to`.
1435      *
1436      * This function is intended for efficient minting only during contract creation.
1437      *
1438      * It emits only one {ConsecutiveTransfer} as defined in
1439      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1440      * instead of a sequence of {Transfer} event(s).
1441      *
1442      * Calling this function outside of contract creation WILL make your contract
1443      * non-compliant with the ERC721 standard.
1444      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1445      * {ConsecutiveTransfer} event is only permissible during contract creation.
1446      *
1447      * Requirements:
1448      *
1449      * - `to` cannot be the zero address.
1450      * - `quantity` must be greater than 0.
1451      *
1452      * Emits a {ConsecutiveTransfer} event.
1453      */
1454     function _mintERC2309(address to, uint256 quantity) internal virtual {
1455         uint256 startTokenId = _currentIndex;
1456         if (to == address(0)) revert MintToZeroAddress();
1457         if (quantity == 0) revert MintZeroQuantity();
1458         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1459 
1460         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1461 
1462         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1463         unchecked {
1464             // Updates:
1465             // - `balance += quantity`.
1466             // - `numberMinted += quantity`.
1467             //
1468             // We can directly add to the `balance` and `numberMinted`.
1469             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1470 
1471             // Updates:
1472             // - `address` to the owner.
1473             // - `startTimestamp` to the timestamp of minting.
1474             // - `burned` to `false`.
1475             // - `nextInitialized` to `quantity == 1`.
1476             _packedOwnerships[startTokenId] = _packOwnershipData(
1477                 to,
1478                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1479             );
1480 
1481             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1482 
1483             _currentIndex = startTokenId + quantity;
1484         }
1485         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1486     }
1487 
1488     /**
1489      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1490      *
1491      * Requirements:
1492      *
1493      * - If `to` refers to a smart contract, it must implement
1494      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1495      * - `quantity` must be greater than 0.
1496      *
1497      * See {_mint}.
1498      *
1499      * Emits a {Transfer} event for each mint.
1500      */
1501     function _safeMint(
1502         address to,
1503         uint256 quantity,
1504         bytes memory _data
1505     ) internal virtual {
1506         _mint(to, quantity);
1507 
1508         unchecked {
1509             if (to.code.length != 0) {
1510                 uint256 end = _currentIndex;
1511                 uint256 index = end - quantity;
1512                 do {
1513                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1514                         revert TransferToNonERC721ReceiverImplementer();
1515                     }
1516                 } while (index < end);
1517                 // Reentrancy protection.
1518                 if (_currentIndex != end) revert();
1519             }
1520         }
1521     }
1522 
1523     /**
1524      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1525      */
1526     function _safeMint(address to, uint256 quantity) internal virtual {
1527         _safeMint(to, quantity, '');
1528     }
1529 
1530     // =============================================================
1531     //                        BURN OPERATIONS
1532     // =============================================================
1533 
1534     /**
1535      * @dev Equivalent to `_burn(tokenId, false)`.
1536      */
1537     function _burn(uint256 tokenId) internal virtual {
1538         _burn(tokenId, false);
1539     }
1540 
1541     /**
1542      * @dev Destroys `tokenId`.
1543      * The approval is cleared when the token is burned.
1544      *
1545      * Requirements:
1546      *
1547      * - `tokenId` must exist.
1548      *
1549      * Emits a {Transfer} event.
1550      */
1551     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1552         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1553 
1554         address from = address(uint160(prevOwnershipPacked));
1555 
1556         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1557 
1558         if (approvalCheck) {
1559             // The nested ifs save around 20+ gas over a compound boolean condition.
1560             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1561                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1562         }
1563 
1564         _beforeTokenTransfers(from, address(0), tokenId, 1);
1565 
1566         // Clear approvals from the previous owner.
1567         assembly {
1568             if approvedAddress {
1569                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1570                 sstore(approvedAddressSlot, 0)
1571             }
1572         }
1573 
1574         // Underflow of the sender's balance is impossible because we check for
1575         // ownership above and the recipient's balance can't realistically overflow.
1576         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1577         unchecked {
1578             // Updates:
1579             // - `balance -= 1`.
1580             // - `numberBurned += 1`.
1581             //
1582             // We can directly decrement the balance, and increment the number burned.
1583             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1584             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1585 
1586             // Updates:
1587             // - `address` to the last owner.
1588             // - `startTimestamp` to the timestamp of burning.
1589             // - `burned` to `true`.
1590             // - `nextInitialized` to `true`.
1591             _packedOwnerships[tokenId] = _packOwnershipData(
1592                 from,
1593                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1594             );
1595 
1596             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1597             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1598                 uint256 nextTokenId = tokenId + 1;
1599                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1600                 if (_packedOwnerships[nextTokenId] == 0) {
1601                     // If the next slot is within bounds.
1602                     if (nextTokenId != _currentIndex) {
1603                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1604                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1605                     }
1606                 }
1607             }
1608         }
1609 
1610         emit Transfer(from, address(0), tokenId);
1611         _afterTokenTransfers(from, address(0), tokenId, 1);
1612 
1613         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1614         unchecked {
1615             _burnCounter++;
1616         }
1617     }
1618 
1619     // =============================================================
1620     //                     EXTRA DATA OPERATIONS
1621     // =============================================================
1622 
1623     /**
1624      * @dev Directly sets the extra data for the ownership data `index`.
1625      */
1626     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1627         uint256 packed = _packedOwnerships[index];
1628         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1629         uint256 extraDataCasted;
1630         // Cast `extraData` with assembly to avoid redundant masking.
1631         assembly {
1632             extraDataCasted := extraData
1633         }
1634         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1635         _packedOwnerships[index] = packed;
1636     }
1637 
1638     /**
1639      * @dev Called during each token transfer to set the 24bit `extraData` field.
1640      * Intended to be overridden by the cosumer contract.
1641      *
1642      * `previousExtraData` - the value of `extraData` before transfer.
1643      *
1644      * Calling conditions:
1645      *
1646      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1647      * transferred to `to`.
1648      * - When `from` is zero, `tokenId` will be minted for `to`.
1649      * - When `to` is zero, `tokenId` will be burned by `from`.
1650      * - `from` and `to` are never both zero.
1651      */
1652     function _extraData(
1653         address from,
1654         address to,
1655         uint24 previousExtraData
1656     ) internal view virtual returns (uint24) {}
1657 
1658     /**
1659      * @dev Returns the next extra data for the packed ownership data.
1660      * The returned result is shifted into position.
1661      */
1662     function _nextExtraData(
1663         address from,
1664         address to,
1665         uint256 prevOwnershipPacked
1666     ) private view returns (uint256) {
1667         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1668         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1669     }
1670 
1671     // =============================================================
1672     //                       OTHER OPERATIONS
1673     // =============================================================
1674 
1675     /**
1676      * @dev Returns the message sender (defaults to `msg.sender`).
1677      *
1678      * If you are writing GSN compatible contracts, you need to override this function.
1679      */
1680     function _msgSenderERC721A() internal view virtual returns (address) {
1681         return msg.sender;
1682     }
1683 
1684     /**
1685      * @dev Converts a uint256 to its ASCII string decimal representation.
1686      */
1687     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1688         assembly {
1689             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1690             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1691             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1692             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1693             let m := add(mload(0x40), 0xa0)
1694             // Update the free memory pointer to allocate.
1695             mstore(0x40, m)
1696             // Assign the `str` to the end.
1697             str := sub(m, 0x20)
1698             // Zeroize the slot after the string.
1699             mstore(str, 0)
1700 
1701             // Cache the end of the memory to calculate the length later.
1702             let end := str
1703 
1704             // We write the string from rightmost digit to leftmost digit.
1705             // The following is essentially a do-while loop that also handles the zero case.
1706             // prettier-ignore
1707             for { let temp := value } 1 {} {
1708                 str := sub(str, 1)
1709                 // Write the character to the pointer.
1710                 // The ASCII index of the '0' character is 48.
1711                 mstore8(str, add(48, mod(temp, 10)))
1712                 // Keep dividing `temp` until zero.
1713                 temp := div(temp, 10)
1714                 // prettier-ignore
1715                 if iszero(temp) { break }
1716             }
1717 
1718             let length := sub(end, str)
1719             // Move the pointer 32 bytes leftwards to make room for the length.
1720             str := sub(str, 0x20)
1721             // Store the length.
1722             mstore(str, length)
1723         }
1724     }
1725 }
1726 
1727 // File: erc721a/contracts/extensions/ERC721AQueryable.sol
1728 
1729 
1730 // ERC721A Contracts v4.2.3
1731 // Creator: Chiru Labs
1732 
1733 pragma solidity ^0.8.4;
1734 
1735 
1736 
1737 /**
1738  * @title ERC721AQueryable.
1739  *
1740  * @dev ERC721A subclass with convenience query functions.
1741  */
1742 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1743     /**
1744      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1745      *
1746      * If the `tokenId` is out of bounds:
1747      *
1748      * - `addr = address(0)`
1749      * - `startTimestamp = 0`
1750      * - `burned = false`
1751      * - `extraData = 0`
1752      *
1753      * If the `tokenId` is burned:
1754      *
1755      * - `addr = <Address of owner before token was burned>`
1756      * - `startTimestamp = <Timestamp when token was burned>`
1757      * - `burned = true`
1758      * - `extraData = <Extra data when token was burned>`
1759      *
1760      * Otherwise:
1761      *
1762      * - `addr = <Address of owner>`
1763      * - `startTimestamp = <Timestamp of start of ownership>`
1764      * - `burned = false`
1765      * - `extraData = <Extra data at start of ownership>`
1766      */
1767     function explicitOwnershipOf(uint256 tokenId) public view virtual override returns (TokenOwnership memory) {
1768         TokenOwnership memory ownership;
1769         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
1770             return ownership;
1771         }
1772         ownership = _ownershipAt(tokenId);
1773         if (ownership.burned) {
1774             return ownership;
1775         }
1776         return _ownershipOf(tokenId);
1777     }
1778 
1779     /**
1780      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1781      * See {ERC721AQueryable-explicitOwnershipOf}
1782      */
1783     function explicitOwnershipsOf(uint256[] calldata tokenIds)
1784         external
1785         view
1786         virtual
1787         override
1788         returns (TokenOwnership[] memory)
1789     {
1790         unchecked {
1791             uint256 tokenIdsLength = tokenIds.length;
1792             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1793             for (uint256 i; i != tokenIdsLength; ++i) {
1794                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1795             }
1796             return ownerships;
1797         }
1798     }
1799 
1800     /**
1801      * @dev Returns an array of token IDs owned by `owner`,
1802      * in the range [`start`, `stop`)
1803      * (i.e. `start <= tokenId < stop`).
1804      *
1805      * This function allows for tokens to be queried if the collection
1806      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1807      *
1808      * Requirements:
1809      *
1810      * - `start < stop`
1811      */
1812     function tokensOfOwnerIn(
1813         address owner,
1814         uint256 start,
1815         uint256 stop
1816     ) external view virtual override returns (uint256[] memory) {
1817         unchecked {
1818             if (start >= stop) revert InvalidQueryRange();
1819             uint256 tokenIdsIdx;
1820             uint256 stopLimit = _nextTokenId();
1821             // Set `start = max(start, _startTokenId())`.
1822             if (start < _startTokenId()) {
1823                 start = _startTokenId();
1824             }
1825             // Set `stop = min(stop, stopLimit)`.
1826             if (stop > stopLimit) {
1827                 stop = stopLimit;
1828             }
1829             uint256 tokenIdsMaxLength = balanceOf(owner);
1830             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1831             // to cater for cases where `balanceOf(owner)` is too big.
1832             if (start < stop) {
1833                 uint256 rangeLength = stop - start;
1834                 if (rangeLength < tokenIdsMaxLength) {
1835                     tokenIdsMaxLength = rangeLength;
1836                 }
1837             } else {
1838                 tokenIdsMaxLength = 0;
1839             }
1840             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1841             if (tokenIdsMaxLength == 0) {
1842                 return tokenIds;
1843             }
1844             // We need to call `explicitOwnershipOf(start)`,
1845             // because the slot at `start` may not be initialized.
1846             TokenOwnership memory ownership = explicitOwnershipOf(start);
1847             address currOwnershipAddr;
1848             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1849             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1850             if (!ownership.burned) {
1851                 currOwnershipAddr = ownership.addr;
1852             }
1853             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
1854                 ownership = _ownershipAt(i);
1855                 if (ownership.burned) {
1856                     continue;
1857                 }
1858                 if (ownership.addr != address(0)) {
1859                     currOwnershipAddr = ownership.addr;
1860                 }
1861                 if (currOwnershipAddr == owner) {
1862                     tokenIds[tokenIdsIdx++] = i;
1863                 }
1864             }
1865             // Downsize the array to fit.
1866             assembly {
1867                 mstore(tokenIds, tokenIdsIdx)
1868             }
1869             return tokenIds;
1870         }
1871     }
1872 
1873     /**
1874      * @dev Returns an array of token IDs owned by `owner`.
1875      *
1876      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
1877      * It is meant to be called off-chain.
1878      *
1879      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1880      * multiple smaller scans if the collection is large enough to cause
1881      * an out-of-gas error (10K collections should be fine).
1882      */
1883     function tokensOfOwner(address owner) external view virtual override returns (uint256[] memory) {
1884         unchecked {
1885             uint256 tokenIdsIdx;
1886             address currOwnershipAddr;
1887             uint256 tokenIdsLength = balanceOf(owner);
1888             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1889             TokenOwnership memory ownership;
1890             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
1891                 ownership = _ownershipAt(i);
1892                 if (ownership.burned) {
1893                     continue;
1894                 }
1895                 if (ownership.addr != address(0)) {
1896                     currOwnershipAddr = ownership.addr;
1897                 }
1898                 if (currOwnershipAddr == owner) {
1899                     tokenIds[tokenIdsIdx++] = i;
1900                 }
1901             }
1902             return tokenIds;
1903         }
1904     }
1905 }
1906 
1907 // File: erc721a/contracts/extensions/ERC721ABurnable.sol
1908 
1909 
1910 // ERC721A Contracts v4.2.3
1911 // Creator: Chiru Labs
1912 
1913 pragma solidity ^0.8.4;
1914 
1915 
1916 
1917 /**
1918  * @title ERC721ABurnable.
1919  *
1920  * @dev ERC721A token that can be irreversibly burned (destroyed).
1921  */
1922 abstract contract ERC721ABurnable is ERC721A, IERC721ABurnable {
1923     /**
1924      * @dev Burns `tokenId`. See {ERC721A-_burn}.
1925      *
1926      * Requirements:
1927      *
1928      * - The caller must own `tokenId` or be an approved operator.
1929      */
1930     function burn(uint256 tokenId) public virtual override {
1931         _burn(tokenId, true);
1932     }
1933 }
1934 
1935 // File: @openzeppelin/contracts/utils/math/Math.sol
1936 
1937 
1938 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
1939 
1940 pragma solidity ^0.8.0;
1941 
1942 /**
1943  * @dev Standard math utilities missing in the Solidity language.
1944  */
1945 library Math {
1946     enum Rounding {
1947         Down, // Toward negative infinity
1948         Up, // Toward infinity
1949         Zero // Toward zero
1950     }
1951 
1952     /**
1953      * @dev Returns the largest of two numbers.
1954      */
1955     function max(uint256 a, uint256 b) internal pure returns (uint256) {
1956         return a > b ? a : b;
1957     }
1958 
1959     /**
1960      * @dev Returns the smallest of two numbers.
1961      */
1962     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1963         return a < b ? a : b;
1964     }
1965 
1966     /**
1967      * @dev Returns the average of two numbers. The result is rounded towards
1968      * zero.
1969      */
1970     function average(uint256 a, uint256 b) internal pure returns (uint256) {
1971         // (a + b) / 2 can overflow.
1972         return (a & b) + (a ^ b) / 2;
1973     }
1974 
1975     /**
1976      * @dev Returns the ceiling of the division of two numbers.
1977      *
1978      * This differs from standard division with `/` in that it rounds up instead
1979      * of rounding down.
1980      */
1981     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
1982         // (a + b - 1) / b can overflow on addition, so we distribute.
1983         return a == 0 ? 0 : (a - 1) / b + 1;
1984     }
1985 
1986     /**
1987      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
1988      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
1989      * with further edits by Uniswap Labs also under MIT license.
1990      */
1991     function mulDiv(
1992         uint256 x,
1993         uint256 y,
1994         uint256 denominator
1995     ) internal pure returns (uint256 result) {
1996         unchecked {
1997             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
1998             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
1999             // variables such that product = prod1 * 2^256 + prod0.
2000             uint256 prod0; // Least significant 256 bits of the product
2001             uint256 prod1; // Most significant 256 bits of the product
2002             assembly {
2003                 let mm := mulmod(x, y, not(0))
2004                 prod0 := mul(x, y)
2005                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
2006             }
2007 
2008             // Handle non-overflow cases, 256 by 256 division.
2009             if (prod1 == 0) {
2010                 return prod0 / denominator;
2011             }
2012 
2013             // Make sure the result is less than 2^256. Also prevents denominator == 0.
2014             require(denominator > prod1);
2015 
2016             ///////////////////////////////////////////////
2017             // 512 by 256 division.
2018             ///////////////////////////////////////////////
2019 
2020             // Make division exact by subtracting the remainder from [prod1 prod0].
2021             uint256 remainder;
2022             assembly {
2023                 // Compute remainder using mulmod.
2024                 remainder := mulmod(x, y, denominator)
2025 
2026                 // Subtract 256 bit number from 512 bit number.
2027                 prod1 := sub(prod1, gt(remainder, prod0))
2028                 prod0 := sub(prod0, remainder)
2029             }
2030 
2031             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
2032             // See https://cs.stackexchange.com/q/138556/92363.
2033 
2034             // Does not overflow because the denominator cannot be zero at this stage in the function.
2035             uint256 twos = denominator & (~denominator + 1);
2036             assembly {
2037                 // Divide denominator by twos.
2038                 denominator := div(denominator, twos)
2039 
2040                 // Divide [prod1 prod0] by twos.
2041                 prod0 := div(prod0, twos)
2042 
2043                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
2044                 twos := add(div(sub(0, twos), twos), 1)
2045             }
2046 
2047             // Shift in bits from prod1 into prod0.
2048             prod0 |= prod1 * twos;
2049 
2050             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
2051             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
2052             // four bits. That is, denominator * inv = 1 mod 2^4.
2053             uint256 inverse = (3 * denominator) ^ 2;
2054 
2055             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
2056             // in modular arithmetic, doubling the correct bits in each step.
2057             inverse *= 2 - denominator * inverse; // inverse mod 2^8
2058             inverse *= 2 - denominator * inverse; // inverse mod 2^16
2059             inverse *= 2 - denominator * inverse; // inverse mod 2^32
2060             inverse *= 2 - denominator * inverse; // inverse mod 2^64
2061             inverse *= 2 - denominator * inverse; // inverse mod 2^128
2062             inverse *= 2 - denominator * inverse; // inverse mod 2^256
2063 
2064             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
2065             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
2066             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
2067             // is no longer required.
2068             result = prod0 * inverse;
2069             return result;
2070         }
2071     }
2072 
2073     /**
2074      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
2075      */
2076     function mulDiv(
2077         uint256 x,
2078         uint256 y,
2079         uint256 denominator,
2080         Rounding rounding
2081     ) internal pure returns (uint256) {
2082         uint256 result = mulDiv(x, y, denominator);
2083         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
2084             result += 1;
2085         }
2086         return result;
2087     }
2088 
2089     /**
2090      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
2091      *
2092      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
2093      */
2094     function sqrt(uint256 a) internal pure returns (uint256) {
2095         if (a == 0) {
2096             return 0;
2097         }
2098 
2099         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
2100         //
2101         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
2102         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
2103         //
2104         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
2105         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
2106         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
2107         //
2108         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
2109         uint256 result = 1 << (log2(a) >> 1);
2110 
2111         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
2112         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
2113         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
2114         // into the expected uint128 result.
2115         unchecked {
2116             result = (result + a / result) >> 1;
2117             result = (result + a / result) >> 1;
2118             result = (result + a / result) >> 1;
2119             result = (result + a / result) >> 1;
2120             result = (result + a / result) >> 1;
2121             result = (result + a / result) >> 1;
2122             result = (result + a / result) >> 1;
2123             return min(result, a / result);
2124         }
2125     }
2126 
2127     /**
2128      * @notice Calculates sqrt(a), following the selected rounding direction.
2129      */
2130     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
2131         unchecked {
2132             uint256 result = sqrt(a);
2133             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
2134         }
2135     }
2136 
2137     /**
2138      * @dev Return the log in base 2, rounded down, of a positive value.
2139      * Returns 0 if given 0.
2140      */
2141     function log2(uint256 value) internal pure returns (uint256) {
2142         uint256 result = 0;
2143         unchecked {
2144             if (value >> 128 > 0) {
2145                 value >>= 128;
2146                 result += 128;
2147             }
2148             if (value >> 64 > 0) {
2149                 value >>= 64;
2150                 result += 64;
2151             }
2152             if (value >> 32 > 0) {
2153                 value >>= 32;
2154                 result += 32;
2155             }
2156             if (value >> 16 > 0) {
2157                 value >>= 16;
2158                 result += 16;
2159             }
2160             if (value >> 8 > 0) {
2161                 value >>= 8;
2162                 result += 8;
2163             }
2164             if (value >> 4 > 0) {
2165                 value >>= 4;
2166                 result += 4;
2167             }
2168             if (value >> 2 > 0) {
2169                 value >>= 2;
2170                 result += 2;
2171             }
2172             if (value >> 1 > 0) {
2173                 result += 1;
2174             }
2175         }
2176         return result;
2177     }
2178 
2179     /**
2180      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
2181      * Returns 0 if given 0.
2182      */
2183     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
2184         unchecked {
2185             uint256 result = log2(value);
2186             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
2187         }
2188     }
2189 
2190     /**
2191      * @dev Return the log in base 10, rounded down, of a positive value.
2192      * Returns 0 if given 0.
2193      */
2194     function log10(uint256 value) internal pure returns (uint256) {
2195         uint256 result = 0;
2196         unchecked {
2197             if (value >= 10**64) {
2198                 value /= 10**64;
2199                 result += 64;
2200             }
2201             if (value >= 10**32) {
2202                 value /= 10**32;
2203                 result += 32;
2204             }
2205             if (value >= 10**16) {
2206                 value /= 10**16;
2207                 result += 16;
2208             }
2209             if (value >= 10**8) {
2210                 value /= 10**8;
2211                 result += 8;
2212             }
2213             if (value >= 10**4) {
2214                 value /= 10**4;
2215                 result += 4;
2216             }
2217             if (value >= 10**2) {
2218                 value /= 10**2;
2219                 result += 2;
2220             }
2221             if (value >= 10**1) {
2222                 result += 1;
2223             }
2224         }
2225         return result;
2226     }
2227 
2228     /**
2229      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
2230      * Returns 0 if given 0.
2231      */
2232     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
2233         unchecked {
2234             uint256 result = log10(value);
2235             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
2236         }
2237     }
2238 
2239     /**
2240      * @dev Return the log in base 256, rounded down, of a positive value.
2241      * Returns 0 if given 0.
2242      *
2243      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
2244      */
2245     function log256(uint256 value) internal pure returns (uint256) {
2246         uint256 result = 0;
2247         unchecked {
2248             if (value >> 128 > 0) {
2249                 value >>= 128;
2250                 result += 16;
2251             }
2252             if (value >> 64 > 0) {
2253                 value >>= 64;
2254                 result += 8;
2255             }
2256             if (value >> 32 > 0) {
2257                 value >>= 32;
2258                 result += 4;
2259             }
2260             if (value >> 16 > 0) {
2261                 value >>= 16;
2262                 result += 2;
2263             }
2264             if (value >> 8 > 0) {
2265                 result += 1;
2266             }
2267         }
2268         return result;
2269     }
2270 
2271     /**
2272      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
2273      * Returns 0 if given 0.
2274      */
2275     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
2276         unchecked {
2277             uint256 result = log256(value);
2278             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
2279         }
2280     }
2281 }
2282 
2283 // File: @openzeppelin/contracts/utils/Strings.sol
2284 
2285 
2286 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
2287 
2288 pragma solidity ^0.8.0;
2289 
2290 
2291 /**
2292  * @dev String operations.
2293  */
2294 library Strings {
2295     bytes16 private constant _SYMBOLS = "0123456789abcdef";
2296     uint8 private constant _ADDRESS_LENGTH = 20;
2297 
2298     /**
2299      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
2300      */
2301     function toString(uint256 value) internal pure returns (string memory) {
2302         unchecked {
2303             uint256 length = Math.log10(value) + 1;
2304             string memory buffer = new string(length);
2305             uint256 ptr;
2306             /// @solidity memory-safe-assembly
2307             assembly {
2308                 ptr := add(buffer, add(32, length))
2309             }
2310             while (true) {
2311                 ptr--;
2312                 /// @solidity memory-safe-assembly
2313                 assembly {
2314                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
2315                 }
2316                 value /= 10;
2317                 if (value == 0) break;
2318             }
2319             return buffer;
2320         }
2321     }
2322 
2323     /**
2324      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
2325      */
2326     function toHexString(uint256 value) internal pure returns (string memory) {
2327         unchecked {
2328             return toHexString(value, Math.log256(value) + 1);
2329         }
2330     }
2331 
2332     /**
2333      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
2334      */
2335     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
2336         bytes memory buffer = new bytes(2 * length + 2);
2337         buffer[0] = "0";
2338         buffer[1] = "x";
2339         for (uint256 i = 2 * length + 1; i > 1; --i) {
2340             buffer[i] = _SYMBOLS[value & 0xf];
2341             value >>= 4;
2342         }
2343         require(value == 0, "Strings: hex length insufficient");
2344         return string(buffer);
2345     }
2346 
2347     /**
2348      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
2349      */
2350     function toHexString(address addr) internal pure returns (string memory) {
2351         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
2352     }
2353 }
2354 
2355 // File: @openzeppelin/contracts/utils/Context.sol
2356 
2357 
2358 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
2359 
2360 pragma solidity ^0.8.0;
2361 
2362 /**
2363  * @dev Provides information about the current execution context, including the
2364  * sender of the transaction and its data. While these are generally available
2365  * via msg.sender and msg.data, they should not be accessed in such a direct
2366  * manner, since when dealing with meta-transactions the account sending and
2367  * paying for execution may not be the actual sender (as far as an application
2368  * is concerned).
2369  *
2370  * This contract is only required for intermediate, library-like contracts.
2371  */
2372 abstract contract Context {
2373     function _msgSender() internal view virtual returns (address) {
2374         return msg.sender;
2375     }
2376 
2377     function _msgData() internal view virtual returns (bytes calldata) {
2378         return msg.data;
2379     }
2380 }
2381 
2382 // File: @openzeppelin/contracts/utils/Address.sol
2383 
2384 
2385 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
2386 
2387 pragma solidity ^0.8.1;
2388 
2389 /**
2390  * @dev Collection of functions related to the address type
2391  */
2392 library Address {
2393     /**
2394      * @dev Returns true if `account` is a contract.
2395      *
2396      * [IMPORTANT]
2397      * ====
2398      * It is unsafe to assume that an address for which this function returns
2399      * false is an externally-owned account (EOA) and not a contract.
2400      *
2401      * Among others, `isContract` will return false for the following
2402      * types of addresses:
2403      *
2404      *  - an externally-owned account
2405      *  - a contract in construction
2406      *  - an address where a contract will be created
2407      *  - an address where a contract lived, but was destroyed
2408      * ====
2409      *
2410      * [IMPORTANT]
2411      * ====
2412      * You shouldn't rely on `isContract` to protect against flash loan attacks!
2413      *
2414      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
2415      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
2416      * constructor.
2417      * ====
2418      */
2419     function isContract(address account) internal view returns (bool) {
2420         // This method relies on extcodesize/address.code.length, which returns 0
2421         // for contracts in construction, since the code is only stored at the end
2422         // of the constructor execution.
2423 
2424         return account.code.length > 0;
2425     }
2426 
2427     /**
2428      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
2429      * `recipient`, forwarding all available gas and reverting on errors.
2430      *
2431      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
2432      * of certain opcodes, possibly making contracts go over the 2300 gas limit
2433      * imposed by `transfer`, making them unable to receive funds via
2434      * `transfer`. {sendValue} removes this limitation.
2435      *
2436      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
2437      *
2438      * IMPORTANT: because control is transferred to `recipient`, care must be
2439      * taken to not create reentrancy vulnerabilities. Consider using
2440      * {ReentrancyGuard} or the
2441      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
2442      */
2443     function sendValue(address payable recipient, uint256 amount) internal {
2444         require(address(this).balance >= amount, "Address: insufficient balance");
2445 
2446         (bool success, ) = recipient.call{value: amount}("");
2447         require(success, "Address: unable to send value, recipient may have reverted");
2448     }
2449 
2450     /**
2451      * @dev Performs a Solidity function call using a low level `call`. A
2452      * plain `call` is an unsafe replacement for a function call: use this
2453      * function instead.
2454      *
2455      * If `target` reverts with a revert reason, it is bubbled up by this
2456      * function (like regular Solidity function calls).
2457      *
2458      * Returns the raw returned data. To convert to the expected return value,
2459      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
2460      *
2461      * Requirements:
2462      *
2463      * - `target` must be a contract.
2464      * - calling `target` with `data` must not revert.
2465      *
2466      * _Available since v3.1._
2467      */
2468     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
2469         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
2470     }
2471 
2472     /**
2473      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
2474      * `errorMessage` as a fallback revert reason when `target` reverts.
2475      *
2476      * _Available since v3.1._
2477      */
2478     function functionCall(
2479         address target,
2480         bytes memory data,
2481         string memory errorMessage
2482     ) internal returns (bytes memory) {
2483         return functionCallWithValue(target, data, 0, errorMessage);
2484     }
2485 
2486     /**
2487      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
2488      * but also transferring `value` wei to `target`.
2489      *
2490      * Requirements:
2491      *
2492      * - the calling contract must have an ETH balance of at least `value`.
2493      * - the called Solidity function must be `payable`.
2494      *
2495      * _Available since v3.1._
2496      */
2497     function functionCallWithValue(
2498         address target,
2499         bytes memory data,
2500         uint256 value
2501     ) internal returns (bytes memory) {
2502         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
2503     }
2504 
2505     /**
2506      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
2507      * with `errorMessage` as a fallback revert reason when `target` reverts.
2508      *
2509      * _Available since v3.1._
2510      */
2511     function functionCallWithValue(
2512         address target,
2513         bytes memory data,
2514         uint256 value,
2515         string memory errorMessage
2516     ) internal returns (bytes memory) {
2517         require(address(this).balance >= value, "Address: insufficient balance for call");
2518         (bool success, bytes memory returndata) = target.call{value: value}(data);
2519         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
2520     }
2521 
2522     /**
2523      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
2524      * but performing a static call.
2525      *
2526      * _Available since v3.3._
2527      */
2528     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
2529         return functionStaticCall(target, data, "Address: low-level static call failed");
2530     }
2531 
2532     /**
2533      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
2534      * but performing a static call.
2535      *
2536      * _Available since v3.3._
2537      */
2538     function functionStaticCall(
2539         address target,
2540         bytes memory data,
2541         string memory errorMessage
2542     ) internal view returns (bytes memory) {
2543         (bool success, bytes memory returndata) = target.staticcall(data);
2544         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
2545     }
2546 
2547     /**
2548      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
2549      * but performing a delegate call.
2550      *
2551      * _Available since v3.4._
2552      */
2553     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
2554         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
2555     }
2556 
2557     /**
2558      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
2559      * but performing a delegate call.
2560      *
2561      * _Available since v3.4._
2562      */
2563     function functionDelegateCall(
2564         address target,
2565         bytes memory data,
2566         string memory errorMessage
2567     ) internal returns (bytes memory) {
2568         (bool success, bytes memory returndata) = target.delegatecall(data);
2569         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
2570     }
2571 
2572     /**
2573      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
2574      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
2575      *
2576      * _Available since v4.8._
2577      */
2578     function verifyCallResultFromTarget(
2579         address target,
2580         bool success,
2581         bytes memory returndata,
2582         string memory errorMessage
2583     ) internal view returns (bytes memory) {
2584         if (success) {
2585             if (returndata.length == 0) {
2586                 // only check isContract if the call was successful and the return data is empty
2587                 // otherwise we already know that it was a contract
2588                 require(isContract(target), "Address: call to non-contract");
2589             }
2590             return returndata;
2591         } else {
2592             _revert(returndata, errorMessage);
2593         }
2594     }
2595 
2596     /**
2597      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
2598      * revert reason or using the provided one.
2599      *
2600      * _Available since v4.3._
2601      */
2602     function verifyCallResult(
2603         bool success,
2604         bytes memory returndata,
2605         string memory errorMessage
2606     ) internal pure returns (bytes memory) {
2607         if (success) {
2608             return returndata;
2609         } else {
2610             _revert(returndata, errorMessage);
2611         }
2612     }
2613 
2614     function _revert(bytes memory returndata, string memory errorMessage) private pure {
2615         // Look for revert reason and bubble it up if present
2616         if (returndata.length > 0) {
2617             // The easiest way to bubble the revert reason is using memory via assembly
2618             /// @solidity memory-safe-assembly
2619             assembly {
2620                 let returndata_size := mload(returndata)
2621                 revert(add(32, returndata), returndata_size)
2622             }
2623         } else {
2624             revert(errorMessage);
2625         }
2626     }
2627 }
2628 
2629 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
2630 
2631 
2632 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
2633 
2634 pragma solidity ^0.8.0;
2635 
2636 /**
2637  * @title ERC721 token receiver interface
2638  * @dev Interface for any contract that wants to support safeTransfers
2639  * from ERC721 asset contracts.
2640  */
2641 interface IERC721Receiver {
2642     /**
2643      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
2644      * by `operator` from `from`, this function is called.
2645      *
2646      * It must return its Solidity selector to confirm the token transfer.
2647      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
2648      *
2649      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
2650      */
2651     function onERC721Received(
2652         address operator,
2653         address from,
2654         uint256 tokenId,
2655         bytes calldata data
2656     ) external returns (bytes4);
2657 }
2658 
2659 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
2660 
2661 
2662 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
2663 
2664 pragma solidity ^0.8.0;
2665 
2666 /**
2667  * @dev Interface of the ERC165 standard, as defined in the
2668  * https://eips.ethereum.org/EIPS/eip-165[EIP].
2669  *
2670  * Implementers can declare support of contract interfaces, which can then be
2671  * queried by others ({ERC165Checker}).
2672  *
2673  * For an implementation, see {ERC165}.
2674  */
2675 interface IERC165 {
2676     /**
2677      * @dev Returns true if this contract implements the interface defined by
2678      * `interfaceId`. See the corresponding
2679      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
2680      * to learn more about how these ids are created.
2681      *
2682      * This function call must use less than 30 000 gas.
2683      */
2684     function supportsInterface(bytes4 interfaceId) external view returns (bool);
2685 }
2686 
2687 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
2688 
2689 
2690 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
2691 
2692 pragma solidity ^0.8.0;
2693 
2694 
2695 /**
2696  * @dev Implementation of the {IERC165} interface.
2697  *
2698  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
2699  * for the additional interface id that will be supported. For example:
2700  *
2701  * ```solidity
2702  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
2703  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
2704  * }
2705  * ```
2706  *
2707  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
2708  */
2709 abstract contract ERC165 is IERC165 {
2710     /**
2711      * @dev See {IERC165-supportsInterface}.
2712      */
2713     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
2714         return interfaceId == type(IERC165).interfaceId;
2715     }
2716 }
2717 
2718 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
2719 
2720 
2721 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)
2722 
2723 pragma solidity ^0.8.0;
2724 
2725 
2726 /**
2727  * @dev Required interface of an ERC721 compliant contract.
2728  */
2729 interface IERC721 is IERC165 {
2730     /**
2731      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
2732      */
2733     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
2734 
2735     /**
2736      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
2737      */
2738     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
2739 
2740     /**
2741      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
2742      */
2743     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
2744 
2745     /**
2746      * @dev Returns the number of tokens in ``owner``'s account.
2747      */
2748     function balanceOf(address owner) external view returns (uint256 balance);
2749 
2750     /**
2751      * @dev Returns the owner of the `tokenId` token.
2752      *
2753      * Requirements:
2754      *
2755      * - `tokenId` must exist.
2756      */
2757     function ownerOf(uint256 tokenId) external view returns (address owner);
2758 
2759     /**
2760      * @dev Safely transfers `tokenId` token from `from` to `to`.
2761      *
2762      * Requirements:
2763      *
2764      * - `from` cannot be the zero address.
2765      * - `to` cannot be the zero address.
2766      * - `tokenId` token must exist and be owned by `from`.
2767      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
2768      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2769      *
2770      * Emits a {Transfer} event.
2771      */
2772     function safeTransferFrom(
2773         address from,
2774         address to,
2775         uint256 tokenId,
2776         bytes calldata data
2777     ) external;
2778 
2779     /**
2780      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
2781      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
2782      *
2783      * Requirements:
2784      *
2785      * - `from` cannot be the zero address.
2786      * - `to` cannot be the zero address.
2787      * - `tokenId` token must exist and be owned by `from`.
2788      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
2789      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2790      *
2791      * Emits a {Transfer} event.
2792      */
2793     function safeTransferFrom(
2794         address from,
2795         address to,
2796         uint256 tokenId
2797     ) external;
2798 
2799     /**
2800      * @dev Transfers `tokenId` token from `from` to `to`.
2801      *
2802      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
2803      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
2804      * understand this adds an external call which potentially creates a reentrancy vulnerability.
2805      *
2806      * Requirements:
2807      *
2808      * - `from` cannot be the zero address.
2809      * - `to` cannot be the zero address.
2810      * - `tokenId` token must be owned by `from`.
2811      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
2812      *
2813      * Emits a {Transfer} event.
2814      */
2815     function transferFrom(
2816         address from,
2817         address to,
2818         uint256 tokenId
2819     ) external;
2820 
2821     /**
2822      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
2823      * The approval is cleared when the token is transferred.
2824      *
2825      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
2826      *
2827      * Requirements:
2828      *
2829      * - The caller must own the token or be an approved operator.
2830      * - `tokenId` must exist.
2831      *
2832      * Emits an {Approval} event.
2833      */
2834     function approve(address to, uint256 tokenId) external;
2835 
2836     /**
2837      * @dev Approve or remove `operator` as an operator for the caller.
2838      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
2839      *
2840      * Requirements:
2841      *
2842      * - The `operator` cannot be the caller.
2843      *
2844      * Emits an {ApprovalForAll} event.
2845      */
2846     function setApprovalForAll(address operator, bool _approved) external;
2847 
2848     /**
2849      * @dev Returns the account approved for `tokenId` token.
2850      *
2851      * Requirements:
2852      *
2853      * - `tokenId` must exist.
2854      */
2855     function getApproved(uint256 tokenId) external view returns (address operator);
2856 
2857     /**
2858      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
2859      *
2860      * See {setApprovalForAll}
2861      */
2862     function isApprovedForAll(address owner, address operator) external view returns (bool);
2863 }
2864 
2865 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
2866 
2867 
2868 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
2869 
2870 pragma solidity ^0.8.0;
2871 
2872 
2873 /**
2874  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
2875  * @dev See https://eips.ethereum.org/EIPS/eip-721
2876  */
2877 interface IERC721Metadata is IERC721 {
2878     /**
2879      * @dev Returns the token collection name.
2880      */
2881     function name() external view returns (string memory);
2882 
2883     /**
2884      * @dev Returns the token collection symbol.
2885      */
2886     function symbol() external view returns (string memory);
2887 
2888     /**
2889      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
2890      */
2891     function tokenURI(uint256 tokenId) external view returns (string memory);
2892 }
2893 
2894 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
2895 
2896 
2897 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/ERC721.sol)
2898 
2899 pragma solidity ^0.8.0;
2900 
2901 
2902 
2903 
2904 
2905 
2906 
2907 
2908 /**
2909  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
2910  * the Metadata extension, but not including the Enumerable extension, which is available separately as
2911  * {ERC721Enumerable}.
2912  */
2913 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
2914     using Address for address;
2915     using Strings for uint256;
2916 
2917     // Token name
2918     string private _name;
2919 
2920     // Token symbol
2921     string private _symbol;
2922 
2923     // Mapping from token ID to owner address
2924     mapping(uint256 => address) private _owners;
2925 
2926     // Mapping owner address to token count
2927     mapping(address => uint256) private _balances;
2928 
2929     // Mapping from token ID to approved address
2930     mapping(uint256 => address) private _tokenApprovals;
2931 
2932     // Mapping from owner to operator approvals
2933     mapping(address => mapping(address => bool)) private _operatorApprovals;
2934 
2935     /**
2936      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
2937      */
2938     constructor(string memory name_, string memory symbol_) {
2939         _name = name_;
2940         _symbol = symbol_;
2941     }
2942 
2943     /**
2944      * @dev See {IERC165-supportsInterface}.
2945      */
2946     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
2947         return
2948             interfaceId == type(IERC721).interfaceId ||
2949             interfaceId == type(IERC721Metadata).interfaceId ||
2950             super.supportsInterface(interfaceId);
2951     }
2952 
2953     /**
2954      * @dev See {IERC721-balanceOf}.
2955      */
2956     function balanceOf(address owner) public view virtual override returns (uint256) {
2957         require(owner != address(0), "ERC721: address zero is not a valid owner");
2958         return _balances[owner];
2959     }
2960 
2961     /**
2962      * @dev See {IERC721-ownerOf}.
2963      */
2964     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
2965         address owner = _ownerOf(tokenId);
2966         require(owner != address(0), "ERC721: invalid token ID");
2967         return owner;
2968     }
2969 
2970     /**
2971      * @dev See {IERC721Metadata-name}.
2972      */
2973     function name() public view virtual override returns (string memory) {
2974         return _name;
2975     }
2976 
2977     /**
2978      * @dev See {IERC721Metadata-symbol}.
2979      */
2980     function symbol() public view virtual override returns (string memory) {
2981         return _symbol;
2982     }
2983 
2984     /**
2985      * @dev See {IERC721Metadata-tokenURI}.
2986      */
2987     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2988         _requireMinted(tokenId);
2989 
2990         string memory baseURI = _baseURI();
2991         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
2992     }
2993 
2994     /**
2995      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
2996      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
2997      * by default, can be overridden in child contracts.
2998      */
2999     function _baseURI() internal view virtual returns (string memory) {
3000         return "";
3001     }
3002 
3003     /**
3004      * @dev See {IERC721-approve}.
3005      */
3006     function approve(address to, uint256 tokenId) public virtual override {
3007         address owner = ERC721.ownerOf(tokenId);
3008         require(to != owner, "ERC721: approval to current owner");
3009 
3010         require(
3011             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
3012             "ERC721: approve caller is not token owner or approved for all"
3013         );
3014 
3015         _approve(to, tokenId);
3016     }
3017 
3018     /**
3019      * @dev See {IERC721-getApproved}.
3020      */
3021     function getApproved(uint256 tokenId) public view virtual override returns (address) {
3022         _requireMinted(tokenId);
3023 
3024         return _tokenApprovals[tokenId];
3025     }
3026 
3027     /**
3028      * @dev See {IERC721-setApprovalForAll}.
3029      */
3030     function setApprovalForAll(address operator, bool approved) public virtual override {
3031         _setApprovalForAll(_msgSender(), operator, approved);
3032     }
3033 
3034     /**
3035      * @dev See {IERC721-isApprovedForAll}.
3036      */
3037     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
3038         return _operatorApprovals[owner][operator];
3039     }
3040 
3041     /**
3042      * @dev See {IERC721-transferFrom}.
3043      */
3044     function transferFrom(
3045         address from,
3046         address to,
3047         uint256 tokenId
3048     ) public virtual override {
3049         //solhint-disable-next-line max-line-length
3050         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
3051 
3052         _transfer(from, to, tokenId);
3053     }
3054 
3055     /**
3056      * @dev See {IERC721-safeTransferFrom}.
3057      */
3058     function safeTransferFrom(
3059         address from,
3060         address to,
3061         uint256 tokenId
3062     ) public virtual override {
3063         safeTransferFrom(from, to, tokenId, "");
3064     }
3065 
3066     /**
3067      * @dev See {IERC721-safeTransferFrom}.
3068      */
3069     function safeTransferFrom(
3070         address from,
3071         address to,
3072         uint256 tokenId,
3073         bytes memory data
3074     ) public virtual override {
3075         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
3076         _safeTransfer(from, to, tokenId, data);
3077     }
3078 
3079     /**
3080      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
3081      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
3082      *
3083      * `data` is additional data, it has no specified format and it is sent in call to `to`.
3084      *
3085      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
3086      * implement alternative mechanisms to perform token transfer, such as signature-based.
3087      *
3088      * Requirements:
3089      *
3090      * - `from` cannot be the zero address.
3091      * - `to` cannot be the zero address.
3092      * - `tokenId` token must exist and be owned by `from`.
3093      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
3094      *
3095      * Emits a {Transfer} event.
3096      */
3097     function _safeTransfer(
3098         address from,
3099         address to,
3100         uint256 tokenId,
3101         bytes memory data
3102     ) internal virtual {
3103         _transfer(from, to, tokenId);
3104         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
3105     }
3106 
3107     /**
3108      * @dev Returns the owner of the `tokenId`. Does NOT revert if token doesn't exist
3109      */
3110     function _ownerOf(uint256 tokenId) internal view virtual returns (address) {
3111         return _owners[tokenId];
3112     }
3113 
3114     /**
3115      * @dev Returns whether `tokenId` exists.
3116      *
3117      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
3118      *
3119      * Tokens start existing when they are minted (`_mint`),
3120      * and stop existing when they are burned (`_burn`).
3121      */
3122     function _exists(uint256 tokenId) internal view virtual returns (bool) {
3123         return _ownerOf(tokenId) != address(0);
3124     }
3125 
3126     /**
3127      * @dev Returns whether `spender` is allowed to manage `tokenId`.
3128      *
3129      * Requirements:
3130      *
3131      * - `tokenId` must exist.
3132      */
3133     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
3134         address owner = ERC721.ownerOf(tokenId);
3135         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
3136     }
3137 
3138     /**
3139      * @dev Safely mints `tokenId` and transfers it to `to`.
3140      *
3141      * Requirements:
3142      *
3143      * - `tokenId` must not exist.
3144      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
3145      *
3146      * Emits a {Transfer} event.
3147      */
3148     function _safeMint(address to, uint256 tokenId) internal virtual {
3149         _safeMint(to, tokenId, "");
3150     }
3151 
3152     /**
3153      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
3154      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
3155      */
3156     function _safeMint(
3157         address to,
3158         uint256 tokenId,
3159         bytes memory data
3160     ) internal virtual {
3161         _mint(to, tokenId);
3162         require(
3163             _checkOnERC721Received(address(0), to, tokenId, data),
3164             "ERC721: transfer to non ERC721Receiver implementer"
3165         );
3166     }
3167 
3168     /**
3169      * @dev Mints `tokenId` and transfers it to `to`.
3170      *
3171      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
3172      *
3173      * Requirements:
3174      *
3175      * - `tokenId` must not exist.
3176      * - `to` cannot be the zero address.
3177      *
3178      * Emits a {Transfer} event.
3179      */
3180     function _mint(address to, uint256 tokenId) internal virtual {
3181         require(to != address(0), "ERC721: mint to the zero address");
3182         require(!_exists(tokenId), "ERC721: token already minted");
3183 
3184         _beforeTokenTransfer(address(0), to, tokenId, 1);
3185 
3186         // Check that tokenId was not minted by `_beforeTokenTransfer` hook
3187         require(!_exists(tokenId), "ERC721: token already minted");
3188 
3189         unchecked {
3190             // Will not overflow unless all 2**256 token ids are minted to the same owner.
3191             // Given that tokens are minted one by one, it is impossible in practice that
3192             // this ever happens. Might change if we allow batch minting.
3193             // The ERC fails to describe this case.
3194             _balances[to] += 1;
3195         }
3196 
3197         _owners[tokenId] = to;
3198 
3199         emit Transfer(address(0), to, tokenId);
3200 
3201         _afterTokenTransfer(address(0), to, tokenId, 1);
3202     }
3203 
3204     /**
3205      * @dev Destroys `tokenId`.
3206      * The approval is cleared when the token is burned.
3207      * This is an internal function that does not check if the sender is authorized to operate on the token.
3208      *
3209      * Requirements:
3210      *
3211      * - `tokenId` must exist.
3212      *
3213      * Emits a {Transfer} event.
3214      */
3215     function _burn(uint256 tokenId) internal virtual {
3216         address owner = ERC721.ownerOf(tokenId);
3217 
3218         _beforeTokenTransfer(owner, address(0), tokenId, 1);
3219 
3220         // Update ownership in case tokenId was transferred by `_beforeTokenTransfer` hook
3221         owner = ERC721.ownerOf(tokenId);
3222 
3223         // Clear approvals
3224         delete _tokenApprovals[tokenId];
3225 
3226         unchecked {
3227             // Cannot overflow, as that would require more tokens to be burned/transferred
3228             // out than the owner initially received through minting and transferring in.
3229             _balances[owner] -= 1;
3230         }
3231         delete _owners[tokenId];
3232 
3233         emit Transfer(owner, address(0), tokenId);
3234 
3235         _afterTokenTransfer(owner, address(0), tokenId, 1);
3236     }
3237 
3238     /**
3239      * @dev Transfers `tokenId` from `from` to `to`.
3240      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
3241      *
3242      * Requirements:
3243      *
3244      * - `to` cannot be the zero address.
3245      * - `tokenId` token must be owned by `from`.
3246      *
3247      * Emits a {Transfer} event.
3248      */
3249     function _transfer(
3250         address from,
3251         address to,
3252         uint256 tokenId
3253     ) internal virtual {
3254         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
3255         require(to != address(0), "ERC721: transfer to the zero address");
3256 
3257         _beforeTokenTransfer(from, to, tokenId, 1);
3258 
3259         // Check that tokenId was not transferred by `_beforeTokenTransfer` hook
3260         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
3261 
3262         // Clear approvals from the previous owner
3263         delete _tokenApprovals[tokenId];
3264 
3265         unchecked {
3266             // `_balances[from]` cannot overflow for the same reason as described in `_burn`:
3267             // `from`'s balance is the number of token held, which is at least one before the current
3268             // transfer.
3269             // `_balances[to]` could overflow in the conditions described in `_mint`. That would require
3270             // all 2**256 token ids to be minted, which in practice is impossible.
3271             _balances[from] -= 1;
3272             _balances[to] += 1;
3273         }
3274         _owners[tokenId] = to;
3275 
3276         emit Transfer(from, to, tokenId);
3277 
3278         _afterTokenTransfer(from, to, tokenId, 1);
3279     }
3280 
3281     /**
3282      * @dev Approve `to` to operate on `tokenId`
3283      *
3284      * Emits an {Approval} event.
3285      */
3286     function _approve(address to, uint256 tokenId) internal virtual {
3287         _tokenApprovals[tokenId] = to;
3288         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
3289     }
3290 
3291     /**
3292      * @dev Approve `operator` to operate on all of `owner` tokens
3293      *
3294      * Emits an {ApprovalForAll} event.
3295      */
3296     function _setApprovalForAll(
3297         address owner,
3298         address operator,
3299         bool approved
3300     ) internal virtual {
3301         require(owner != operator, "ERC721: approve to caller");
3302         _operatorApprovals[owner][operator] = approved;
3303         emit ApprovalForAll(owner, operator, approved);
3304     }
3305 
3306     /**
3307      * @dev Reverts if the `tokenId` has not been minted yet.
3308      */
3309     function _requireMinted(uint256 tokenId) internal view virtual {
3310         require(_exists(tokenId), "ERC721: invalid token ID");
3311     }
3312 
3313     /**
3314      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
3315      * The call is not executed if the target address is not a contract.
3316      *
3317      * @param from address representing the previous owner of the given token ID
3318      * @param to target address that will receive the tokens
3319      * @param tokenId uint256 ID of the token to be transferred
3320      * @param data bytes optional data to send along with the call
3321      * @return bool whether the call correctly returned the expected magic value
3322      */
3323     function _checkOnERC721Received(
3324         address from,
3325         address to,
3326         uint256 tokenId,
3327         bytes memory data
3328     ) private returns (bool) {
3329         if (to.isContract()) {
3330             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
3331                 return retval == IERC721Receiver.onERC721Received.selector;
3332             } catch (bytes memory reason) {
3333                 if (reason.length == 0) {
3334                     revert("ERC721: transfer to non ERC721Receiver implementer");
3335                 } else {
3336                     /// @solidity memory-safe-assembly
3337                     assembly {
3338                         revert(add(32, reason), mload(reason))
3339                     }
3340                 }
3341             }
3342         } else {
3343             return true;
3344         }
3345     }
3346 
3347     /**
3348      * @dev Hook that is called before any token transfer. This includes minting and burning. If {ERC721Consecutive} is
3349      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
3350      *
3351      * Calling conditions:
3352      *
3353      * - When `from` and `to` are both non-zero, ``from``'s tokens will be transferred to `to`.
3354      * - When `from` is zero, the tokens will be minted for `to`.
3355      * - When `to` is zero, ``from``'s tokens will be burned.
3356      * - `from` and `to` are never both zero.
3357      * - `batchSize` is non-zero.
3358      *
3359      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
3360      */
3361     function _beforeTokenTransfer(
3362         address from,
3363         address to,
3364         uint256, /* firstTokenId */
3365         uint256 batchSize
3366     ) internal virtual {
3367         if (batchSize > 1) {
3368             if (from != address(0)) {
3369                 _balances[from] -= batchSize;
3370             }
3371             if (to != address(0)) {
3372                 _balances[to] += batchSize;
3373             }
3374         }
3375     }
3376 
3377     /**
3378      * @dev Hook that is called after any token transfer. This includes minting and burning. If {ERC721Consecutive} is
3379      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
3380      *
3381      * Calling conditions:
3382      *
3383      * - When `from` and `to` are both non-zero, ``from``'s tokens were transferred to `to`.
3384      * - When `from` is zero, the tokens were minted for `to`.
3385      * - When `to` is zero, ``from``'s tokens were burned.
3386      * - `from` and `to` are never both zero.
3387      * - `batchSize` is non-zero.
3388      *
3389      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
3390      */
3391     function _afterTokenTransfer(
3392         address from,
3393         address to,
3394         uint256 firstTokenId,
3395         uint256 batchSize
3396     ) internal virtual {}
3397 }
3398 
3399 // File: miladycola/miladycola.sol
3400 
3401 
3402 pragma solidity ^0.8.17;
3403 
3404 /*⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
3405 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣾⣿⣷⣶⣤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
3406 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⠿⣿⣿⣿⣿⣿⣿⣶⣤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
3407 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣠⣤⣴⣶⣾⣿⣷⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠙⠻⢿⣿⣿⣿⣿⣷⣦⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀
3408 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠻⢿⣿⣿⣿⣿⣦⡀⠀⠀⠀⠀⠀⠀
3409 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣾⣿⣿⣿⣿⣿⡿⠿⠟⠛⠉⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠻⣿⣿⣿⣆⠀⠀⠀⠀⠀
3410 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿⣿⡿⠟⠋⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⣿⣿⣧⠀⠀⠀⠀
3411 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣿⣿⣿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢻⣿⣇⠀⠀⠀
3412 ⠀⠀⠀⠀⠀⠀⠀⣠⣾⣿⣿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣴⣶⣿⣿⣿⣿⣿⣿⣿⣶⣤⡀⠀⠙⠋⠀⠀⠀
3413 ⠀⠀⠀⠀⠀⣠⣾⣿⣿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣤⣾⠟⢋⣥⣤⠀⣶⣶⣶⣦⣤⣌⣉⠛⠀⠀⠀⠀⠀⠀
3414 ⠀⠀⠀⠀⣴⣿⣿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠋⢁⣴⣿⣿⡿⠀⣿⣿⣿⣿⣿⣿⣿⣷⡄⠀⠀⠀⠀⠀
3415 ⠀⠀⠀⣼⣿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣤⣤⣶⣶⣾⣿⣿⣿⣿⣷⣶⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣿⣿⣿⠁⠀⠀⢹⣿⣿⣿⣿⣿⣿⢻⣿⡄⠀⠀⠀⠀
3416 ⠀⠀⠀⠛⠋⠀⠀⠀⠀⠀⠀⠀⢀⣤⣾⣿⠿⠛⣛⣉⣉⣀⣀⡀⠀⠀⠀⠀⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⣿⣿⣿⣿⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⢸⣿⣿⡄⠀⠀⠀
3417 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣾⡿⢋⣩⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⣶⣦⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⣿⣿⣿⣿⣦⣀⣀⣴⣿⣿⣿⣿⣿⡿⢸⣿⢿⣷⡀⠀⠀
3418 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣡⣄⠀⠋⠁⠀⠈⠹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⣿⡟⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⢸⡿⠀⠛⠃⠀⠀
3419 ⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿⣿⣧⡀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠛⠛⠃⢹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠁⠈⠁⠀⠀⠀⠀⠀
3420 ⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿⣿⢿⣿⣿⣿⣷⣦⣤⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣶⣶⠀⠈⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠀⣿⠇⠀⠀⠀⠀⠀
3421 ⠀⠀⠀⠀⠀⢠⣿⣿⣿⠟⠉⠀⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢿⣿⠀⠀⢹⣿⣿⣿⣿⣿⣿⣿⣿⣿⠁⢸⣿⠀⠀⠀⠀⠀⠀
3422 ⠀⠀⠀⠀⠀⣼⣿⡟⠁⣠⣦⠀⠘⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠉⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⡆⠀⠀⢻⣿⣿⣿⣿⣿⣿⣿⠏⠀⣸⡏⠀⠀⠀⠀⠀⠀
3423 ⠀⠀⠀⠀⠀⣿⡏⠀⠀⣿⣿⡀⠀⠘⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠀⢹⣿⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣿⣇⠀⠀⠀⠙⢿⣿⣿⡿⠟⠁⠀⣸⡿⠁⠀⠀⠀⠀⠀⠀
3424 ⠀⠀⠀⠀⢸⣿⠁⠀⠀⢸⣿⣇⠀⠀⠘⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠁⠀⢀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⢿⣦⡀⠀⠀⠀⠈⠉⠀⠀⠀⣼⡿⠁⠀⠀⠀⠀⠀⠀⠀
3425 ⠀⠀⠀⠀⠈⠁⠀⠀⠀⠀⢿⣿⡄⠀⠀⠈⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠁⠀⠀⣼⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢿⣷⣦⣄⣀⠀⠀⢀⡈⠙⠁⠀⠀⠀⠀⠀⠀⠀⠀
3426 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢻⣿⣆⠀⠀⠀⠉⠛⠿⢿⣿⣿⠿⠛⠁⠀⠀⠀⣠⣿⣿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠿⣿⣿⣷⣿⣯⣤⣶⠄⠀⠀⠀⠀⠀⠀⠀
3427 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⣿⣷⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠉⠙⠛⠋⠁⠀⠀⠀⠀⠀⠀⠀
3428 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⢿⣷⣤⣀⠀⠀⠀⠀⠀⠀⠀⠺⣿⣿⡿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
3429 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠛⢻⣿⣶⣤⣤⣤⣶⣷⣤⠈⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
3430 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⢿⣿⣿⣿⣿⡿⠿⠛⠋⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
3431 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
3432 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
3433 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
3434 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⠶⢤⣄⣀⣀⣤⠶⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
3435 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
3436 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
3437 */
3438 
3439 
3440 
3441 
3442 
3443 
3444 contract MiladyCola is ERC721A, ERC721AQueryable, ERC721ABurnable, Ownable {
3445 
3446     uint256 public constant s_MAXMILADYCOLA = 10000;
3447 
3448     string public IPFSURI = '';
3449 
3450     bool public s_saleIsActive = false;
3451 
3452     address internal constant milady = 0x5Af0D9827E0c53E4799BB226655A1de152A425a5;
3453 
3454     address internal constant miladystation = 0xB24BaB1732D34cAD0A7C7035C3539aEC553bF3a0;
3455 
3456     address internal constant remilio = 0xD3D9ddd0CF0A5F0BFB8f7fcEAe075DF687eAEBaB;
3457 
3458     address internal constant miaura = 0x2fC722C1c77170A61F17962CC4D039692f033b43;
3459 
3460     address internal constant cig = 0xEEd41d06AE195CA8f5CaCACE4cd691EE75F0683f;
3461     
3462 
3463     uint256 public bottlePrice;
3464     uint256 public friendPrice;
3465     uint256 public bulkPrice;
3466 
3467     constructor() ERC721A("MiladyCola", "MC") {
3468         _initializeOwner(msg.sender);
3469         bottlePrice = 12500000000000000;
3470         friendPrice = 10000000000000000;
3471         bulkPrice = 11000000000000000;
3472     }
3473 
3474     function changePrice(uint256 bottle, uint256 friend, uint256 bulk) public onlyOwner {
3475         bottlePrice = bottle;
3476         friendPrice = friend;
3477         bulkPrice = bulk;
3478     }
3479 
3480     function setBaseURI(string memory baseURI) public onlyOwner {
3481         IPFSURI = baseURI;
3482     }
3483 
3484     function _baseURI() internal view virtual override(ERC721A) returns (string memory) {
3485         return IPFSURI;
3486     }
3487     
3488     function withdraw() public onlyOwner {
3489         uint balance = address(this).balance;
3490         payable(msg.sender).transfer(balance);
3491     }
3492 
3493     // MiladyCola Friend check for frontend
3494     function friendCheck(address holder) public view returns (uint256) {
3495         uint256 tokenNum;
3496         try ERC721(milady).balanceOf(holder) returns (uint256 miladyHolderIndex) {
3497             tokenNum = miladyHolderIndex;
3498         } catch (bytes memory) {
3499             // No tokens owned by user
3500         }
3501         try ERC721(remilio).balanceOf(holder) returns (uint256 index) {
3502             tokenNum = tokenNum + index;
3503         } catch (bytes memory) {
3504             // No tokens owned by user
3505         }
3506         try ERC721(miaura).balanceOf(holder) returns (uint256 index) {
3507             tokenNum = tokenNum + index;
3508         } catch (bytes memory) {
3509             // No tokens owned by user
3510         }
3511         try ERC721(cig).balanceOf(holder) returns (uint256 index) {
3512             tokenNum = tokenNum + index;
3513         } catch (bytes memory) {
3514             // No tokens owned by user
3515         }
3516         try ERC721(miladystation).balanceOf(holder) returns (uint256 index) {
3517             tokenNum = tokenNum + index;
3518         } catch (bytes memory) {
3519             // No tokens owned by user
3520         }
3521         return tokenNum;
3522     }
3523     
3524     
3525     function flipSaleState() public onlyOwner {
3526         s_saleIsActive = !s_saleIsActive;
3527     }
3528 
3529     modifier miladyFriends() {
3530         require(
3531             (ERC721(milady).balanceOf(msg.sender) > 0) ||
3532             (ERC721(remilio).balanceOf(msg.sender) > 0) ||
3533             (ERC721(miaura).balanceOf(msg.sender) > 0) ||
3534             (ERC721(cig).balanceOf(msg.sender) > 0) ||
3535             (ERC721(miladystation).balanceOf(msg.sender) > 0),
3536                       
3537             "You need at least one Milady friend"
3538         );
3539         _;
3540     }
3541 
3542     function mintNew(uint256 numberOfTokens) public payable {
3543         require(s_saleIsActive, "Sale must be active to mint");
3544         require(totalSupply() + numberOfTokens < s_MAXMILADYCOLA+1, "Purchase would exceed max supply");
3545         require(numberOfTokens < 48, "one 48 pack at a time");
3546         if (numberOfTokens < 10) {
3547             require(bottlePrice*(numberOfTokens) <= msg.value, "Ether value sent is not correct");
3548         } else {
3549             require(bulkPrice*(numberOfTokens) <= msg.value, "Ether value sent is not correct");
3550         }
3551         _safeMint(msg.sender, numberOfTokens);
3552     }
3553 
3554     function mintFriend(uint256 numberOfTokens) public payable miladyFriends {
3555         uint256 sup = totalSupply();
3556         require(s_saleIsActive, "Sale must be active to mint");
3557         require(sup + numberOfTokens < s_MAXMILADYCOLA+1, "Purchase would exceed max supply");
3558         require(numberOfTokens < 48, "one 48 pack at a time");
3559         require(friendPrice*(numberOfTokens) <= msg.value, "Ether value sent is not correct");
3560         if (sup < 349) {
3561             numberOfTokens = numberOfTokens + 1;
3562         }
3563         _safeMint(msg.sender, numberOfTokens);
3564     }
3565 
3566 }