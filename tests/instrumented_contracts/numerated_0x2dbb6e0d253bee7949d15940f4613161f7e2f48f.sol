1 // SPDX-License-Identifier: GPL-3.0
2 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
3 
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Interface of the ERC165 standard, as defined in the
11  * https://eips.ethereum.org/EIPS/eip-165[EIP].
12  *
13  * Implementers can declare support of contract interfaces, which can then be
14  * queried by others ({ERC165Checker}).
15  *
16  * For an implementation, see {ERC165}.
17  */
18 interface IERC165 {
19     /**
20      * @dev Returns true if this contract implements the interface defined by
21      * `interfaceId`. See the corresponding
22      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
23      * to learn more about how these ids are created.
24      *
25      * This function call must use less than 30 000 gas.
26      */
27     function supportsInterface(bytes4 interfaceId) external view returns (bool);
28 }
29 
30 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
31 
32 
33 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
34 
35 pragma solidity ^0.8.0;
36 
37 
38 /**
39  * @dev Required interface of an ERC721 compliant contract.
40  */
41 interface IERC721 is IERC165 {
42     /**
43      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
44      */
45     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
46 
47     /**
48      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
49      */
50     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
51 
52     /**
53      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
54      */
55     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
56 
57     /**
58      * @dev Returns the number of tokens in ``owner``'s account.
59      */
60     function balanceOf(address owner) external view returns (uint256 balance);
61 
62     /**
63      * @dev Returns the owner of the `tokenId` token.
64      *
65      * Requirements:
66      *
67      * - `tokenId` must exist.
68      */
69     function ownerOf(uint256 tokenId) external view returns (address owner);
70 
71     /**
72      * @dev Safely transfers `tokenId` token from `from` to `to`.
73      *
74      * Requirements:
75      *
76      * - `from` cannot be the zero address.
77      * - `to` cannot be the zero address.
78      * - `tokenId` token must exist and be owned by `from`.
79      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
80      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
81      *
82      * Emits a {Transfer} event.
83      */
84     function safeTransferFrom(
85         address from,
86         address to,
87         uint256 tokenId,
88         bytes calldata data
89     ) external;
90 
91     /**
92      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
93      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
94      *
95      * Requirements:
96      *
97      * - `from` cannot be the zero address.
98      * - `to` cannot be the zero address.
99      * - `tokenId` token must exist and be owned by `from`.
100      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
101      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
102      *
103      * Emits a {Transfer} event.
104      */
105     function safeTransferFrom(
106         address from,
107         address to,
108         uint256 tokenId
109     ) external;
110 
111     /**
112      * @dev Transfers `tokenId` token from `from` to `to`.
113      *
114      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
115      *
116      * Requirements:
117      *
118      * - `from` cannot be the zero address.
119      * - `to` cannot be the zero address.
120      * - `tokenId` token must be owned by `from`.
121      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
122      *
123      * Emits a {Transfer} event.
124      */
125     function transferFrom(
126         address from,
127         address to,
128         uint256 tokenId
129     ) external;
130 
131     /**
132      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
133      * The approval is cleared when the token is transferred.
134      *
135      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
136      *
137      * Requirements:
138      *
139      * - The caller must own the token or be an approved operator.
140      * - `tokenId` must exist.
141      *
142      * Emits an {Approval} event.
143      */
144     function approve(address to, uint256 tokenId) external;
145 
146     /**
147      * @dev Approve or remove `operator` as an operator for the caller.
148      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
149      *
150      * Requirements:
151      *
152      * - The `operator` cannot be the caller.
153      *
154      * Emits an {ApprovalForAll} event.
155      */
156     function setApprovalForAll(address operator, bool _approved) external;
157 
158     /**
159      * @dev Returns the account approved for `tokenId` token.
160      *
161      * Requirements:
162      *
163      * - `tokenId` must exist.
164      */
165     function getApproved(uint256 tokenId) external view returns (address operator);
166 
167     /**
168      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
169      *
170      * See {setApprovalForAll}
171      */
172     function isApprovedForAll(address owner, address operator) external view returns (bool);
173 }
174 
175 // File: contracts/IStakedBeasts.sol
176 
177 
178 pragma solidity ^0.8.4;
179 
180 
181 interface IStakedBEAST is IERC721 {
182     function mint(address to, uint256 tokenId) external;
183     function batchMint(address[] memory to, uint256[] memory tokenIds) external;
184     function burn(uint256 tokenId) external;
185     function batchBurn(uint256[] memory tokenIds) external;
186 }
187 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
188 
189 
190 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
191 
192 pragma solidity ^0.8.0;
193 
194 /**
195  * @dev Interface of the ERC20 standard as defined in the EIP.
196  */
197 interface IERC20 {
198     /**
199      * @dev Emitted when `value` tokens are moved from one account (`from`) to
200      * another (`to`).
201      *
202      * Note that `value` may be zero.
203      */
204     event Transfer(address indexed from, address indexed to, uint256 value);
205 
206     /**
207      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
208      * a call to {approve}. `value` is the new allowance.
209      */
210     event Approval(address indexed owner, address indexed spender, uint256 value);
211 
212     /**
213      * @dev Returns the amount of tokens in existence.
214      */
215     function totalSupply() external view returns (uint256);
216 
217     /**
218      * @dev Returns the amount of tokens owned by `account`.
219      */
220     function balanceOf(address account) external view returns (uint256);
221 
222     /**
223      * @dev Moves `amount` tokens from the caller's account to `to`.
224      *
225      * Returns a boolean value indicating whether the operation succeeded.
226      *
227      * Emits a {Transfer} event.
228      */
229     function transfer(address to, uint256 amount) external returns (bool);
230 
231     /**
232      * @dev Returns the remaining number of tokens that `spender` will be
233      * allowed to spend on behalf of `owner` through {transferFrom}. This is
234      * zero by default.
235      *
236      * This value changes when {approve} or {transferFrom} are called.
237      */
238     function allowance(address owner, address spender) external view returns (uint256);
239 
240     /**
241      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
242      *
243      * Returns a boolean value indicating whether the operation succeeded.
244      *
245      * IMPORTANT: Beware that changing an allowance with this method brings the risk
246      * that someone may use both the old and the new allowance by unfortunate
247      * transaction ordering. One possible solution to mitigate this race
248      * condition is to first reduce the spender's allowance to 0 and set the
249      * desired value afterwards:
250      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
251      *
252      * Emits an {Approval} event.
253      */
254     function approve(address spender, uint256 amount) external returns (bool);
255 
256     /**
257      * @dev Moves `amount` tokens from `from` to `to` using the
258      * allowance mechanism. `amount` is then deducted from the caller's
259      * allowance.
260      *
261      * Returns a boolean value indicating whether the operation succeeded.
262      *
263      * Emits a {Transfer} event.
264      */
265     function transferFrom(
266         address from,
267         address to,
268         uint256 amount
269     ) external returns (bool);
270 }
271 
272 // File: contracts/IHowl.sol
273 
274 
275 pragma solidity ^0.8.4;
276 
277 
278 interface IHowl is IERC20 {
279     function mint(address to, uint256 amount) external;
280 
281     function burn(uint256 amount) external;
282 
283     function burnFrom(address operator, uint256 amount) external;
284 }
285 // File: contracts/IERC721A.sol
286 
287 
288 // ERC721A Contracts v4.1.0
289 // Creator: Chiru Labs
290 
291 pragma solidity ^0.8.4;
292 
293 /**
294  * @dev Interface of an ERC721A compliant contract.
295  */
296 interface IERC721A {
297     /**
298      * The caller must own the token or be an approved operator.
299      */
300     error ApprovalCallerNotOwnerNorApproved();
301 
302     /**
303      * The token does not exist.
304      */
305     error ApprovalQueryForNonexistentToken();
306 
307     /**
308      * The caller cannot approve to their own address.
309      */
310     error ApproveToCaller();
311 
312     /**
313      * Cannot query the balance for the zero address.
314      */
315     error BalanceQueryForZeroAddress();
316 
317     /**
318      * Cannot mint to the zero address.
319      */
320     error MintToZeroAddress();
321 
322     /**
323      * The quantity of tokens minted must be more than zero.
324      */
325     error MintZeroQuantity();
326 
327     /**
328      * The token does not exist.
329      */
330     error OwnerQueryForNonexistentToken();
331 
332     /**
333      * The caller must own the token or be an approved operator.
334      */
335     error TransferCallerNotOwnerNorApproved();
336 
337     /**
338      * The token must be owned by `from`.
339      */
340     error TransferFromIncorrectOwner();
341 
342     /**
343      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
344      */
345     error TransferToNonERC721ReceiverImplementer();
346 
347     /**
348      * Cannot transfer to the zero address.
349      */
350     error TransferToZeroAddress();
351 
352     /**
353      * The token does not exist.
354      */
355     error URIQueryForNonexistentToken();
356 
357     /**
358      * The `quantity` minted with ERC2309 exceeds the safety limit.
359      */
360     error MintERC2309QuantityExceedsLimit();
361 
362     /**
363      * The `extraData` cannot be set on an unintialized ownership slot.
364      */
365     error OwnershipNotInitializedForExtraData();
366 
367     struct TokenOwnership {
368         // The address of the owner.
369         address addr;
370         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
371         uint64 startTimestamp;
372         // Whether the token has been burned.
373         bool burned;
374         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
375         uint24 extraData;
376     }
377 
378     /**
379      * @dev Returns the total amount of tokens stored by the contract.
380      *
381      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
382      */
383     function totalSupply() external view returns (uint256);
384 
385     // ==============================
386     //            IERC165
387     // ==============================
388 
389     /**
390      * @dev Returns true if this contract implements the interface defined by
391      * `interfaceId`. See the corresponding
392      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
393      * to learn more about how these ids are created.
394      *
395      * This function call must use less than 30 000 gas.
396      */
397     function supportsInterface(bytes4 interfaceId) external view returns (bool);
398 
399     // ==============================
400     //            IERC721
401     // ==============================
402 
403     /**
404      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
405      */
406     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
407 
408     /**
409      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
410      */
411     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
412 
413     /**
414      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
415      */
416     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
417 
418     /**
419      * @dev Returns the number of tokens in ``owner``'s account.
420      */
421     function balanceOf(address owner) external view returns (uint256 balance);
422 
423     /**
424      * @dev Returns the owner of the `tokenId` token.
425      *
426      * Requirements:
427      *
428      * - `tokenId` must exist.
429      */
430     function ownerOf(uint256 tokenId) external view returns (address owner);
431 
432     /**
433      * @dev Safely transfers `tokenId` token from `from` to `to`.
434      *
435      * Requirements:
436      *
437      * - `from` cannot be the zero address.
438      * - `to` cannot be the zero address.
439      * - `tokenId` token must exist and be owned by `from`.
440      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
441      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
442      *
443      * Emits a {Transfer} event.
444      */
445     function safeTransferFrom(
446         address from,
447         address to,
448         uint256 tokenId,
449         bytes calldata data
450     ) external;
451 
452     /**
453      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
454      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
455      *
456      * Requirements:
457      *
458      * - `from` cannot be the zero address.
459      * - `to` cannot be the zero address.
460      * - `tokenId` token must exist and be owned by `from`.
461      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
462      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
463      *
464      * Emits a {Transfer} event.
465      */
466     function safeTransferFrom(
467         address from,
468         address to,
469         uint256 tokenId
470     ) external;
471 
472     /**
473      * @dev Transfers `tokenId` token from `from` to `to`.
474      *
475      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
476      *
477      * Requirements:
478      *
479      * - `from` cannot be the zero address.
480      * - `to` cannot be the zero address.
481      * - `tokenId` token must be owned by `from`.
482      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
483      *
484      * Emits a {Transfer} event.
485      */
486     function transferFrom(
487         address from,
488         address to,
489         uint256 tokenId
490     ) external;
491 
492     /**
493      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
494      * The approval is cleared when the token is transferred.
495      *
496      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
497      *
498      * Requirements:
499      *
500      * - The caller must own the token or be an approved operator.
501      * - `tokenId` must exist.
502      *
503      * Emits an {Approval} event.
504      */
505     function approve(address to, uint256 tokenId) external;
506 
507     /**
508      * @dev Approve or remove `operator` as an operator for the caller.
509      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
510      *
511      * Requirements:
512      *
513      * - The `operator` cannot be the caller.
514      *
515      * Emits an {ApprovalForAll} event.
516      */
517     function setApprovalForAll(address operator, bool _approved) external;
518 
519     /**
520      * @dev Returns the account approved for `tokenId` token.
521      *
522      * Requirements:
523      *
524      * - `tokenId` must exist.
525      */
526     function getApproved(uint256 tokenId) external view returns (address operator);
527 
528     /**
529      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
530      *
531      * See {setApprovalForAll}
532      */
533     function isApprovedForAll(address owner, address operator) external view returns (bool);
534 
535     // ==============================
536     //        IERC721Metadata
537     // ==============================
538 
539     /**
540      * @dev Returns the token collection name.
541      */
542     function name() external view returns (string memory);
543 
544     /**
545      * @dev Returns the token collection symbol.
546      */
547     function symbol() external view returns (string memory);
548 
549     /**
550      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
551      */
552     function tokenURI(uint256 tokenId) external view returns (string memory);
553 
554     // ==============================
555     //            IERC2309
556     // ==============================
557 
558     /**
559      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
560      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
561      */
562     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
563 }
564 // File: @openzeppelin/contracts/utils/Counters.sol
565 
566 
567 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
568 
569 pragma solidity ^0.8.0;
570 
571 /**
572  * @title Counters
573  * @author Matt Condon (@shrugs)
574  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
575  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
576  *
577  * Include with `using Counters for Counters.Counter;`
578  */
579 library Counters {
580     struct Counter {
581         // This variable should never be directly accessed by users of the library: interactions must be restricted to
582         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
583         // this feature: see https://github.com/ethereum/solidity/issues/4637
584         uint256 _value; // default: 0
585     }
586 
587     function current(Counter storage counter) internal view returns (uint256) {
588         return counter._value;
589     }
590 
591     function increment(Counter storage counter) internal {
592         unchecked {
593             counter._value += 1;
594         }
595     }
596 
597     function decrement(Counter storage counter) internal {
598         uint256 value = counter._value;
599         require(value > 0, "Counter: decrement overflow");
600         unchecked {
601             counter._value = value - 1;
602         }
603     }
604 
605     function reset(Counter storage counter) internal {
606         counter._value = 0;
607     }
608 }
609 
610 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
611 
612 
613 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
614 
615 pragma solidity ^0.8.0;
616 
617 /**
618  * @dev Contract module that helps prevent reentrant calls to a function.
619  *
620  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
621  * available, which can be applied to functions to make sure there are no nested
622  * (reentrant) calls to them.
623  *
624  * Note that because there is a single `nonReentrant` guard, functions marked as
625  * `nonReentrant` may not call one another. This can be worked around by making
626  * those functions `private`, and then adding `external` `nonReentrant` entry
627  * points to them.
628  *
629  * TIP: If you would like to learn more about reentrancy and alternative ways
630  * to protect against it, check out our blog post
631  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
632  */
633 abstract contract ReentrancyGuard {
634     // Booleans are more expensive than uint256 or any type that takes up a full
635     // word because each write operation emits an extra SLOAD to first read the
636     // slot's contents, replace the bits taken up by the boolean, and then write
637     // back. This is the compiler's defense against contract upgrades and
638     // pointer aliasing, and it cannot be disabled.
639 
640     // The values being non-zero value makes deployment a bit more expensive,
641     // but in exchange the refund on every call to nonReentrant will be lower in
642     // amount. Since refunds are capped to a percentage of the total
643     // transaction's gas, it is best to keep them low in cases like this one, to
644     // increase the likelihood of the full refund coming into effect.
645     uint256 private constant _NOT_ENTERED = 1;
646     uint256 private constant _ENTERED = 2;
647 
648     uint256 private _status;
649 
650     constructor() {
651         _status = _NOT_ENTERED;
652     }
653 
654     /**
655      * @dev Prevents a contract from calling itself, directly or indirectly.
656      * Calling a `nonReentrant` function from another `nonReentrant`
657      * function is not supported. It is possible to prevent this from happening
658      * by making the `nonReentrant` function external, and making it call a
659      * `private` function that does the actual work.
660      */
661     modifier nonReentrant() {
662         // On the first call to nonReentrant, _notEntered will be true
663         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
664 
665         // Any calls to nonReentrant after this point will fail
666         _status = _ENTERED;
667 
668         _;
669 
670         // By storing the original value once again, a refund is triggered (see
671         // https://eips.ethereum.org/EIPS/eip-2200)
672         _status = _NOT_ENTERED;
673     }
674 }
675 
676 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
677 
678 
679 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
680 
681 pragma solidity ^0.8.0;
682 
683 /**
684  * @title ERC721 token receiver interface
685  * @dev Interface for any contract that wants to support safeTransfers
686  * from ERC721 asset contracts.
687  */
688 interface IERC721Receiver {
689     /**
690      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
691      * by `operator` from `from`, this function is called.
692      *
693      * It must return its Solidity selector to confirm the token transfer.
694      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
695      *
696      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
697      */
698     function onERC721Received(
699         address operator,
700         address from,
701         uint256 tokenId,
702         bytes calldata data
703     ) external returns (bytes4);
704 }
705 
706 // File: @openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol
707 
708 
709 // OpenZeppelin Contracts v4.4.1 (token/ERC721/utils/ERC721Holder.sol)
710 
711 pragma solidity ^0.8.0;
712 
713 
714 /**
715  * @dev Implementation of the {IERC721Receiver} interface.
716  *
717  * Accepts all token transfers.
718  * Make sure the contract is able to use its token with {IERC721-safeTransferFrom}, {IERC721-approve} or {IERC721-setApprovalForAll}.
719  */
720 contract ERC721Holder is IERC721Receiver {
721     /**
722      * @dev See {IERC721Receiver-onERC721Received}.
723      *
724      * Always returns `IERC721Receiver.onERC721Received.selector`.
725      */
726     function onERC721Received(
727         address,
728         address,
729         uint256,
730         bytes memory
731     ) public virtual override returns (bytes4) {
732         return this.onERC721Received.selector;
733     }
734 }
735 
736 // File: @openzeppelin/contracts/utils/Context.sol
737 
738 
739 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
740 
741 pragma solidity ^0.8.0;
742 
743 /**
744  * @dev Provides information about the current execution context, including the
745  * sender of the transaction and its data. While these are generally available
746  * via msg.sender and msg.data, they should not be accessed in such a direct
747  * manner, since when dealing with meta-transactions the account sending and
748  * paying for execution may not be the actual sender (as far as an application
749  * is concerned).
750  *
751  * This contract is only required for intermediate, library-like contracts.
752  */
753 abstract contract Context {
754     function _msgSender() internal view virtual returns (address) {
755         return msg.sender;
756     }
757 
758     function _msgData() internal view virtual returns (bytes calldata) {
759         return msg.data;
760     }
761 }
762 
763 // File: @openzeppelin/contracts/access/Ownable.sol
764 
765 
766 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
767 
768 pragma solidity ^0.8.0;
769 
770 
771 /**
772  * @dev Contract module which provides a basic access control mechanism, where
773  * there is an account (an owner) that can be granted exclusive access to
774  * specific functions.
775  *
776  * By default, the owner account will be the one that deploys the contract. This
777  * can later be changed with {transferOwnership}.
778  *
779  * This module is used through inheritance. It will make available the modifier
780  * `onlyOwner`, which can be applied to your functions to restrict their use to
781  * the owner.
782  */
783 abstract contract Ownable is Context {
784     address private _owner;
785 
786     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
787 
788     /**
789      * @dev Initializes the contract setting the deployer as the initial owner.
790      */
791     constructor() {
792         _transferOwnership(_msgSender());
793     }
794 
795     /**
796      * @dev Throws if called by any account other than the owner.
797      */
798     modifier onlyOwner() {
799         _checkOwner();
800         _;
801     }
802 
803     /**
804      * @dev Returns the address of the current owner.
805      */
806     function owner() public view virtual returns (address) {
807         return _owner;
808     }
809 
810     /**
811      * @dev Throws if the sender is not the owner.
812      */
813     function _checkOwner() internal view virtual {
814         require(owner() == _msgSender(), "Ownable: caller is not the owner");
815     }
816 
817     /**
818      * @dev Leaves the contract without owner. It will not be possible to call
819      * `onlyOwner` functions anymore. Can only be called by the current owner.
820      *
821      * NOTE: Renouncing ownership will leave the contract without an owner,
822      * thereby removing any functionality that is only available to the owner.
823      */
824     function renounceOwnership() public virtual onlyOwner {
825         _transferOwnership(address(0));
826     }
827 
828     /**
829      * @dev Transfers ownership of the contract to a new account (`newOwner`).
830      * Can only be called by the current owner.
831      */
832     function transferOwnership(address newOwner) public virtual onlyOwner {
833         require(newOwner != address(0), "Ownable: new owner is the zero address");
834         _transferOwnership(newOwner);
835     }
836 
837     /**
838      * @dev Transfers ownership of the contract to a new account (`newOwner`).
839      * Internal function without access restriction.
840      */
841     function _transferOwnership(address newOwner) internal virtual {
842         address oldOwner = _owner;
843         _owner = newOwner;
844         emit OwnershipTransferred(oldOwner, newOwner);
845     }
846 }
847 
848 // File: contracts/StakeBeasts.sol
849 
850 
851 
852 pragma solidity ^0.8.4;
853 
854 
855 
856 
857 
858 
859 
860 
861 contract StakeBEASTS is ERC721Holder, ReentrancyGuard, Ownable {
862     using Counters for Counters.Counter;
863 
864     // Contracts
865     IERC721A public BEASTS;
866     IHowl public Howl;
867     IStakedBEAST public StakedBeasts;
868 
869     // Yield
870     uint256 public yieldStartTime = 0;
871     uint256 public yieldEndTime = 0;
872     uint256 public yieldRate = 100 ether;
873 
874     // Events
875     event Staked(address indexed owner, uint256 indexed tokenId);
876     event Unstaked(address indexed owner, uint256 indexed tokenId);
877 
878     // State
879     bool isPaused = false;
880     Counters.Counter public totalSupply;
881     mapping(uint256 => address) public stakedTokenOwner;
882     mapping(uint256 => uint256) public stakingTime;
883 
884     // Modifiers
885     modifier callerIsUser() {
886         require(tx.origin == msg.sender, "The caller is another contract");
887         _;
888     }
889 
890     // Public/External Functions
891     function stakeBeasts(uint256[] calldata tokenIds_) external callerIsUser() nonReentrant() {
892         require(!isPaused, "Contract is paused!");
893         for (uint256 i = 0; i < tokenIds_.length; i++) {
894             uint id = tokenIds_[i];
895             require(msg.sender == BEASTS.ownerOf(id), "You do not own this token!");
896 
897             BEASTS.transferFrom(msg.sender, address(this), id);
898             StakedBeasts.mint(msg.sender, id);
899 
900             stakedTokenOwner[id] = msg.sender;
901             stakingTime[id] = block.timestamp;
902 
903             emit Staked(msg.sender, id);
904         }
905     }   
906 
907     function unstakeBeasts(uint256[] calldata tokenIds_) external callerIsUser() nonReentrant() {
908         require(!isPaused, "Contract is paused!");
909         uint256 claimableTokens = 0;
910         for (uint256 i = 0; i < tokenIds_.length; i++) {
911             uint id = tokenIds_[i];
912             require(msg.sender == stakedTokenOwner[id], "You do not own this token!");
913 
914             StakedBeasts.burn(id);
915             BEASTS.transferFrom(address(this), msg.sender, id);
916             stakedTokenOwner[id] = address(0);
917 
918             claimableTokens += _getClaimableTokens(id);
919             stakingTime[id] = 0;
920 
921             emit Unstaked(msg.sender, id);
922         }
923         
924         _claim(claimableTokens);
925     }
926 
927     function claim(uint256[] calldata tokenIds_) external callerIsUser() nonReentrant() {
928         uint256 claimableTokens;
929         for (uint256 i = 0; i < tokenIds_.length; i++) {
930             uint id = tokenIds_[i];
931             require(msg.sender == stakedTokenOwner[id], "You do not own this token!");
932             claimableTokens += _getClaimableTokens(tokenIds_[i]);
933             stakingTime[id] = block.timestamp;
934         }
935         
936         _claim(claimableTokens);
937     }
938 
939     // Internal Functions
940     function _claim(uint256 claimableTokens) internal {
941         Howl.mint(msg.sender, claimableTokens);
942     }
943 
944     function _getClaimableTokens(uint256 tokenId_) internal view returns (uint256) {
945         uint256 _timestamp = stakingTime[tokenId_];
946         if (_timestamp == 0 || _timestamp > yieldEndTime || _timestamp < yieldStartTime) 
947             return 0;
948 
949         uint256 _timeCurrentOrEnded = yieldEndTime > block.timestamp ? 
950             block.timestamp : yieldEndTime;
951         uint256 _timeElapsed = _timeCurrentOrEnded - _timestamp;
952 
953         return (_timeElapsed * yieldRate) / 1 days;
954     }
955 
956     function _getClaimableTokensBatch(uint256[] memory tokenIds_) internal view returns (uint256) {
957         uint256 _pendingTokens;
958         for (uint256 i = 0; i < tokenIds_.length; i++) {
959             _pendingTokens += _getClaimableTokens(tokenIds_[i]);
960         }
961         return _pendingTokens;
962     }
963 
964     // Views
965     function ownerOf(uint256 tokenId_) public view returns (address) {
966         return stakedTokenOwner[tokenId_];
967     }
968 
969     function balanceOf(address address_) public view returns (uint256) {
970         uint256 _balance;
971         uint256 total = totalSupply.current();
972         for (uint256 i = 1; i <= total + 1; i++) {
973             if (stakedTokenOwner[i] == address_) { _balance++; }
974         }
975         return _balance;
976     }
977 
978     function getClaimableTokens(uint256 tokenId_) public view returns (uint256) {
979         return _getClaimableTokens(tokenId_);
980     }
981 
982     function getClaimableTokensBatch(uint256[] calldata tokenIds_) public view returns (uint256) {
983         return _getClaimableTokensBatch(tokenIds_);
984     }
985 
986     function getClaimableTokensOfAddress(address address_) public view returns (uint256) {
987         uint256[] memory _tokensOfAddress = walletOfOwner(address_);
988         return _getClaimableTokensBatch(_tokensOfAddress);
989     }
990     
991     function walletOfOwner(address address_) public virtual view returns (uint256[] memory) {
992         uint256 balance = StakedBeasts.balanceOf(address_);
993         uint256[] memory _tokens = new uint256[](balance);
994         uint256 _index;
995         for (uint256 i = 1; i < BEASTS.totalSupply(); i++) {
996             if (stakedTokenOwner[i] == address_) { 
997                 _tokens[_index] = i; _index++; 
998             }
999         }
1000         return _tokens;
1001     }
1002 
1003     //ADMIN
1004     function setBeastsContract(IERC721A address_) external onlyOwner {
1005         BEASTS = address_;
1006     }
1007 
1008     function setTokenContract(IHowl address_) external onlyOwner {
1009         Howl = address_;
1010     }
1011 
1012     function setStakedBeastsContract(IStakedBEAST address_) external onlyOwner {
1013         StakedBeasts = address_;
1014     }
1015 
1016     function setYieldTime(uint256 startTime, uint256 endTime) external onlyOwner {
1017         yieldStartTime = startTime;
1018         yieldEndTime = endTime;
1019     }
1020 
1021     function setYieldRate(uint256 rate) external onlyOwner {
1022         yieldRate = rate;
1023     }
1024 
1025     function setPaused(bool paused) external onlyOwner{
1026         isPaused = paused;
1027     }
1028 }