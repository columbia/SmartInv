1 pragma solidity ^0.8.0;
2 
3 /**
4  * @title ERC721 token receiver interface
5  * @dev Interface for any contract that wants to support safeTransfers
6  * from ERC721 asset contracts.
7  */
8 interface IERC721Receiver {
9     /**
10      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
11      * by `operator` from `from`, this function is called.
12      *
13      * It must return its Solidity selector to confirm the token transfer.
14      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
15      *
16      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
17      */
18     function onERC721Received(
19         address operator,
20         address from,
21         uint256 tokenId,
22         bytes calldata data
23     ) external returns (bytes4);
24 }
25 
26 
27 // File @openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol@v4.8.0
28 
29 // OpenZeppelin Contracts v4.4.1 (token/ERC721/utils/ERC721Holder.sol)
30 
31 pragma solidity ^0.8.0;
32 
33 /**
34  * @dev Implementation of the {IERC721Receiver} interface.
35  *
36  * Accepts all token transfers.
37  * Make sure the contract is able to use its token with {IERC721-safeTransferFrom}, {IERC721-approve} or {IERC721-setApprovalForAll}.
38  */
39 contract ERC721Holder is IERC721Receiver {
40     /**
41      * @dev See {IERC721Receiver-onERC721Received}.
42      *
43      * Always returns `IERC721Receiver.onERC721Received.selector`.
44      */
45     function onERC721Received(
46         address,
47         address,
48         uint256,
49         bytes memory
50     ) public virtual override returns (bytes4) {
51         return this.onERC721Received.selector;
52     }
53 }
54 
55 
56 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.8.0
57 
58 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
59 
60 pragma solidity ^0.8.0;
61 
62 /**
63  * @dev Interface of the ERC165 standard, as defined in the
64  * https://eips.ethereum.org/EIPS/eip-165[EIP].
65  *
66  * Implementers can declare support of contract interfaces, which can then be
67  * queried by others ({ERC165Checker}).
68  *
69  * For an implementation, see {ERC165}.
70  */
71 interface IERC165 {
72     /**
73      * @dev Returns true if this contract implements the interface defined by
74      * `interfaceId`. See the corresponding
75      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
76      * to learn more about how these ids are created.
77      *
78      * This function call must use less than 30 000 gas.
79      */
80     function supportsInterface(bytes4 interfaceId) external view returns (bool);
81 }
82 
83 
84 // File @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol@v4.8.0
85 
86 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC1155/IERC1155Receiver.sol)
87 
88 pragma solidity ^0.8.0;
89 
90 /**
91  * @dev _Available since v3.1._
92  */
93 interface IERC1155Receiver is IERC165 {
94     /**
95      * @dev Handles the receipt of a single ERC1155 token type. This function is
96      * called at the end of a `safeTransferFrom` after the balance has been updated.
97      *
98      * NOTE: To accept the transfer, this must return
99      * `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
100      * (i.e. 0xf23a6e61, or its own function selector).
101      *
102      * @param operator The address which initiated the transfer (i.e. msg.sender)
103      * @param from The address which previously owned the token
104      * @param id The ID of the token being transferred
105      * @param value The amount of tokens being transferred
106      * @param data Additional data with no specified format
107      * @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
108      */
109     function onERC1155Received(
110         address operator,
111         address from,
112         uint256 id,
113         uint256 value,
114         bytes calldata data
115     ) external returns (bytes4);
116 
117     /**
118      * @dev Handles the receipt of a multiple ERC1155 token types. This function
119      * is called at the end of a `safeBatchTransferFrom` after the balances have
120      * been updated.
121      *
122      * NOTE: To accept the transfer(s), this must return
123      * `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
124      * (i.e. 0xbc197c81, or its own function selector).
125      *
126      * @param operator The address which initiated the batch transfer (i.e. msg.sender)
127      * @param from The address which previously owned the token
128      * @param ids An array containing ids of each token being transferred (order and length must match values array)
129      * @param values An array containing amounts of each token being transferred (order and length must match ids array)
130      * @param data Additional data with no specified format
131      * @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
132      */
133     function onERC1155BatchReceived(
134         address operator,
135         address from,
136         uint256[] calldata ids,
137         uint256[] calldata values,
138         bytes calldata data
139     ) external returns (bytes4);
140 }
141 
142 
143 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.8.0
144 
145 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
146 
147 pragma solidity ^0.8.0;
148 
149 /**
150  * @dev Implementation of the {IERC165} interface.
151  *
152  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
153  * for the additional interface id that will be supported. For example:
154  *
155  * ```solidity
156  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
157  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
158  * }
159  * ```
160  *
161  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
162  */
163 abstract contract ERC165 is IERC165 {
164     /**
165      * @dev See {IERC165-supportsInterface}.
166      */
167     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
168         return interfaceId == type(IERC165).interfaceId;
169     }
170 }
171 
172 
173 // File @openzeppelin/contracts/token/ERC1155/utils/ERC1155Receiver.sol@v4.8.0
174 
175 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/utils/ERC1155Receiver.sol)
176 
177 pragma solidity ^0.8.0;
178 
179 
180 /**
181  * @dev _Available since v3.1._
182  */
183 abstract contract ERC1155Receiver is ERC165, IERC1155Receiver {
184     /**
185      * @dev See {IERC165-supportsInterface}.
186      */
187     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
188         return interfaceId == type(IERC1155Receiver).interfaceId || super.supportsInterface(interfaceId);
189     }
190 }
191 
192 
193 // File @openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol@v4.8.0
194 
195 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC1155/utils/ERC1155Holder.sol)
196 
197 pragma solidity ^0.8.0;
198 
199 /**
200  * Simple implementation of `ERC1155Receiver` that will allow a contract to hold ERC1155 tokens.
201  *
202  * IMPORTANT: When inheriting this contract, you must include a way to use the received tokens, otherwise they will be
203  * stuck.
204  *
205  * @dev _Available since v3.1._
206  */
207 contract ERC1155Holder is ERC1155Receiver {
208     function onERC1155Received(
209         address,
210         address,
211         uint256,
212         uint256,
213         bytes memory
214     ) public virtual override returns (bytes4) {
215         return this.onERC1155Received.selector;
216     }
217 
218     function onERC1155BatchReceived(
219         address,
220         address,
221         uint256[] memory,
222         uint256[] memory,
223         bytes memory
224     ) public virtual override returns (bytes4) {
225         return this.onERC1155BatchReceived.selector;
226     }
227 }
228 
229 
230 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.8.0
231 
232 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)
233 
234 pragma solidity ^0.8.0;
235 
236 /**
237  * @dev Required interface of an ERC721 compliant contract.
238  */
239 interface IERC721 is IERC165 {
240     /**
241      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
242      */
243     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
244 
245     /**
246      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
247      */
248     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
249 
250     /**
251      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
252      */
253     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
254 
255     /**
256      * @dev Returns the number of tokens in ``owner``'s account.
257      */
258     function balanceOf(address owner) external view returns (uint256 balance);
259 
260     /**
261      * @dev Returns the owner of the `tokenId` token.
262      *
263      * Requirements:
264      *
265      * - `tokenId` must exist.
266      */
267     function ownerOf(uint256 tokenId) external view returns (address owner);
268 
269     /**
270      * @dev Safely transfers `tokenId` token from `from` to `to`.
271      *
272      * Requirements:
273      *
274      * - `from` cannot be the zero address.
275      * - `to` cannot be the zero address.
276      * - `tokenId` token must exist and be owned by `from`.
277      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
278      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
279      *
280      * Emits a {Transfer} event.
281      */
282     function safeTransferFrom(
283         address from,
284         address to,
285         uint256 tokenId,
286         bytes calldata data
287     ) external;
288 
289     /**
290      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
291      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
292      *
293      * Requirements:
294      *
295      * - `from` cannot be the zero address.
296      * - `to` cannot be the zero address.
297      * - `tokenId` token must exist and be owned by `from`.
298      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
299      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
300      *
301      * Emits a {Transfer} event.
302      */
303     function safeTransferFrom(
304         address from,
305         address to,
306         uint256 tokenId
307     ) external;
308 
309     /**
310      * @dev Transfers `tokenId` token from `from` to `to`.
311      *
312      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
313      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
314      * understand this adds an external call which potentially creates a reentrancy vulnerability.
315      *
316      * Requirements:
317      *
318      * - `from` cannot be the zero address.
319      * - `to` cannot be the zero address.
320      * - `tokenId` token must be owned by `from`.
321      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
322      *
323      * Emits a {Transfer} event.
324      */
325     function transferFrom(
326         address from,
327         address to,
328         uint256 tokenId
329     ) external;
330 
331     /**
332      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
333      * The approval is cleared when the token is transferred.
334      *
335      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
336      *
337      * Requirements:
338      *
339      * - The caller must own the token or be an approved operator.
340      * - `tokenId` must exist.
341      *
342      * Emits an {Approval} event.
343      */
344     function approve(address to, uint256 tokenId) external;
345 
346     /**
347      * @dev Approve or remove `operator` as an operator for the caller.
348      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
349      *
350      * Requirements:
351      *
352      * - The `operator` cannot be the caller.
353      *
354      * Emits an {ApprovalForAll} event.
355      */
356     function setApprovalForAll(address operator, bool _approved) external;
357 
358     /**
359      * @dev Returns the account approved for `tokenId` token.
360      *
361      * Requirements:
362      *
363      * - `tokenId` must exist.
364      */
365     function getApproved(uint256 tokenId) external view returns (address operator);
366 
367     /**
368      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
369      *
370      * See {setApprovalForAll}
371      */
372     function isApprovedForAll(address owner, address operator) external view returns (bool);
373 }
374 
375 
376 // File @openzeppelin/contracts/token/ERC1155/IERC1155.sol@v4.8.0
377 
378 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/IERC1155.sol)
379 
380 pragma solidity ^0.8.0;
381 
382 /**
383  * @dev Required interface of an ERC1155 compliant contract, as defined in the
384  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
385  *
386  * _Available since v3.1._
387  */
388 interface IERC1155 is IERC165 {
389     /**
390      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
391      */
392     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
393 
394     /**
395      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
396      * transfers.
397      */
398     event TransferBatch(
399         address indexed operator,
400         address indexed from,
401         address indexed to,
402         uint256[] ids,
403         uint256[] values
404     );
405 
406     /**
407      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
408      * `approved`.
409      */
410     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
411 
412     /**
413      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
414      *
415      * If an {URI} event was emitted for `id`, the standard
416      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
417      * returned by {IERC1155MetadataURI-uri}.
418      */
419     event URI(string value, uint256 indexed id);
420 
421     /**
422      * @dev Returns the amount of tokens of token type `id` owned by `account`.
423      *
424      * Requirements:
425      *
426      * - `account` cannot be the zero address.
427      */
428     function balanceOf(address account, uint256 id) external view returns (uint256);
429 
430     /**
431      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
432      *
433      * Requirements:
434      *
435      * - `accounts` and `ids` must have the same length.
436      */
437     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
438         external
439         view
440         returns (uint256[] memory);
441 
442     /**
443      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
444      *
445      * Emits an {ApprovalForAll} event.
446      *
447      * Requirements:
448      *
449      * - `operator` cannot be the caller.
450      */
451     function setApprovalForAll(address operator, bool approved) external;
452 
453     /**
454      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
455      *
456      * See {setApprovalForAll}.
457      */
458     function isApprovedForAll(address account, address operator) external view returns (bool);
459 
460     /**
461      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
462      *
463      * Emits a {TransferSingle} event.
464      *
465      * Requirements:
466      *
467      * - `to` cannot be the zero address.
468      * - If the caller is not `from`, it must have been approved to spend ``from``'s tokens via {setApprovalForAll}.
469      * - `from` must have a balance of tokens of type `id` of at least `amount`.
470      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
471      * acceptance magic value.
472      */
473     function safeTransferFrom(
474         address from,
475         address to,
476         uint256 id,
477         uint256 amount,
478         bytes calldata data
479     ) external;
480 
481     /**
482      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
483      *
484      * Emits a {TransferBatch} event.
485      *
486      * Requirements:
487      *
488      * - `ids` and `amounts` must have the same length.
489      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
490      * acceptance magic value.
491      */
492     function safeBatchTransferFrom(
493         address from,
494         address to,
495         uint256[] calldata ids,
496         uint256[] calldata amounts,
497         bytes calldata data
498     ) external;
499 }
500 
501 
502 // File @openzeppelin/contracts/utils/Context.sol@v4.8.0
503 
504 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
505 
506 pragma solidity ^0.8.0;
507 
508 /**
509  * @dev Provides information about the current execution context, including the
510  * sender of the transaction and its data. While these are generally available
511  * via msg.sender and msg.data, they should not be accessed in such a direct
512  * manner, since when dealing with meta-transactions the account sending and
513  * paying for execution may not be the actual sender (as far as an application
514  * is concerned).
515  *
516  * This contract is only required for intermediate, library-like contracts.
517  */
518 abstract contract Context {
519     function _msgSender() internal view virtual returns (address) {
520         return msg.sender;
521     }
522 
523     function _msgData() internal view virtual returns (bytes calldata) {
524         return msg.data;
525     }
526 }
527 
528 
529 // File @openzeppelin/contracts/security/Pausable.sol@v4.8.0
530 
531 // OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)
532 
533 pragma solidity ^0.8.0;
534 
535 /**
536  * @dev Contract module which allows children to implement an emergency stop
537  * mechanism that can be triggered by an authorized account.
538  *
539  * This module is used through inheritance. It will make available the
540  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
541  * the functions of your contract. Note that they will not be pausable by
542  * simply including this module, only once the modifiers are put in place.
543  */
544 abstract contract Pausable is Context {
545     /**
546      * @dev Emitted when the pause is triggered by `account`.
547      */
548     event Paused(address account);
549 
550     /**
551      * @dev Emitted when the pause is lifted by `account`.
552      */
553     event Unpaused(address account);
554 
555     bool private _paused;
556 
557     /**
558      * @dev Initializes the contract in unpaused state.
559      */
560     constructor() {
561         _paused = false;
562     }
563 
564     /**
565      * @dev Modifier to make a function callable only when the contract is not paused.
566      *
567      * Requirements:
568      *
569      * - The contract must not be paused.
570      */
571     modifier whenNotPaused() {
572         _requireNotPaused();
573         _;
574     }
575 
576     /**
577      * @dev Modifier to make a function callable only when the contract is paused.
578      *
579      * Requirements:
580      *
581      * - The contract must be paused.
582      */
583     modifier whenPaused() {
584         _requirePaused();
585         _;
586     }
587 
588     /**
589      * @dev Returns true if the contract is paused, and false otherwise.
590      */
591     function paused() public view virtual returns (bool) {
592         return _paused;
593     }
594 
595     /**
596      * @dev Throws if the contract is paused.
597      */
598     function _requireNotPaused() internal view virtual {
599         require(!paused(), "Pausable: paused");
600     }
601 
602     /**
603      * @dev Throws if the contract is not paused.
604      */
605     function _requirePaused() internal view virtual {
606         require(paused(), "Pausable: not paused");
607     }
608 
609     /**
610      * @dev Triggers stopped state.
611      *
612      * Requirements:
613      *
614      * - The contract must not be paused.
615      */
616     function _pause() internal virtual whenNotPaused {
617         _paused = true;
618         emit Paused(_msgSender());
619     }
620 
621     /**
622      * @dev Returns to normal state.
623      *
624      * Requirements:
625      *
626      * - The contract must be paused.
627      */
628     function _unpause() internal virtual whenPaused {
629         _paused = false;
630         emit Unpaused(_msgSender());
631     }
632 }
633 
634 
635 // File @openzeppelin/contracts/access/Ownable.sol@v4.8.0
636 
637 // SPDX-License-Identifier: MIT
638 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
639 
640 pragma solidity ^0.8.0;
641 
642 /**
643  * @dev Contract module which provides a basic access control mechanism, where
644  * there is an account (an owner) that can be granted exclusive access to
645  * specific functions.
646  *
647  * By default, the owner account will be the one that deploys the contract. This
648  * can later be changed with {transferOwnership}.
649  *
650  * This module is used through inheritance. It will make available the modifier
651  * `onlyOwner`, which can be applied to your functions to restrict their use to
652  * the owner.
653  */
654 abstract contract Ownable is Context {
655     address private _owner;
656 
657     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
658 
659     /**
660      * @dev Initializes the contract setting the deployer as the initial owner.
661      */
662     constructor() {
663         _transferOwnership(_msgSender());
664     }
665 
666     /**
667      * @dev Throws if called by any account other than the owner.
668      */
669     modifier onlyOwner() {
670         _checkOwner();
671         _;
672     }
673 
674     /**
675      * @dev Returns the address of the current owner.
676      */
677     function owner() public view virtual returns (address) {
678         return _owner;
679     }
680 
681     /**
682      * @dev Throws if the sender is not the owner.
683      */
684     function _checkOwner() internal view virtual {
685         require(owner() == _msgSender(), "Ownable: caller is not the owner");
686     }
687 
688     /**
689      * @dev Leaves the contract without owner. It will not be possible to call
690      * `onlyOwner` functions anymore. Can only be called by the current owner.
691      *
692      * NOTE: Renouncing ownership will leave the contract without an owner,
693      * thereby removing any functionality that is only available to the owner.
694      */
695     function renounceOwnership() public virtual onlyOwner {
696         _transferOwnership(address(0));
697     }
698 
699     /**
700      * @dev Transfers ownership of the contract to a new account (`newOwner`).
701      * Can only be called by the current owner.
702      */
703     function transferOwnership(address newOwner) public virtual onlyOwner {
704         require(newOwner != address(0), "Ownable: new owner is the zero address");
705         _transferOwnership(newOwner);
706     }
707 
708     /**
709      * @dev Transfers ownership of the contract to a new account (`newOwner`).
710      * Internal function without access restriction.
711      */
712     function _transferOwnership(address newOwner) internal virtual {
713         address oldOwner = _owner;
714         _owner = newOwner;
715         emit OwnershipTransferred(oldOwner, newOwner);
716     }
717 }
718 
719 
720 // File contracts/Test.sol
721 
722 /*
723  $$$$$$\ $$$$$$\ $$$$$$$\ $$\ $$\ $$$$$$\ $$$$$$$$\ $$$$$$$$\ $$$$$$\ $$\ $$\ $$$$$$$$\ $$$$$$$$\ $$$$$$$$\ $$$$$$$$\ $$$$$$\ 
724 $$ __$$\ $$ __$$\ $$ __$$\ $$ | $$ |$$ __$$\\__$$ __|$$ _____|$$ __$$\ $$$\ $$ |$$ _____|\__$$ __|$$ _____|$$ _____|$$ __$$\ 
725 $$ / \__|$$ / $$ |$$ | $$ | $$ | $$ |$$ / $$ | $$ | $$ | $$ / \__| $$$$\ $$ |$$ | $$ | $$ | $$ | $$ / \__|
726 $$ |$$$$\ $$ | $$ |$$ | $$ | $$$$$$$$ |$$$$$$$$ | $$ | $$$$$\ \$$$$$$\ $$ $$\$$ |$$$$$\ $$ | $$$$$\ $$$$$\ \$$$$$$\ 
727 $$ |\_$$ |$$ | $$ |$$ | $$ | $$ __$$ |$$ __$$ | $$ | $$ __| \____$$\ $$ \$$$$ |$$ __| $$ | $$ __| $$ __| \____$$\ 
728 $$ | $$ |$$ | $$ |$$ | $$ | $$ | $$ |$$ | $$ | $$ | $$ | $$\ $$ | $$ |\$$$ |$$ | $$ | $$ | $$ | $$\ $$ |
729 \$$$$$$ | $$$$$$ |$$$$$$$ | $$ | $$ |$$ | $$ | $$ | $$$$$$$$\ \$$$$$$ | $$ | \$$ |$$ | $$ | $$$$$$$$\ $$$$$$$$\ \$$$$$$ |
730  \______/ \______/ \_______/ \__| \__|\__| \__| \__| \________| \______/ \__| \__|\__| \__| \________|\________| \______/ 
731  
732 */
733 
734 pragma solidity ^0.8.9;
735 contract GHNEcosystemSwapper is Ownable, Pausable, ERC721Holder, ERC1155Holder {
736     enum SwapState {
737         Proposed, //0
738         Canceled, //1
739         Completed //2
740     }
741 
742     struct Swap {
743         uint256 swapId;
744         address initiator;
745         address[] initiatorNftAddresses;
746         uint256[] initiatorNftIds;
747         uint256[] initiatorNftAmounts;
748         address[] initiatorNftAddressesWant;
749         uint256[] initiatorNftIdsWant;
750         uint256[] initiatorNftAmountsWant;
751         address receiver;
752         uint256 state;
753     }
754 
755     Swap[] public swaps;
756 
757     mapping(address => uint256[]) public userSwaps;
758     address private GHN = 0xE6d48bF4ee912235398b96E16Db6F310c21e82CB;
759     address private SRBNNO = 0x50BEfFd8A0808314d3cc81B3cbF7f1AFA3A6B56c;
760     address private AHC = 0x9370045CE37F381500ac7D6802513bb89871e076;
761     address private DVDA = 0xC084a29DD0C9436568435938B1C6c5af4F5C035f;
762     address private RTBNNO = 0x0912DAD1db4643368B029166AF217B8A9818dB15;
763     address private MGHN = 0x8BdfD304d22c9F02d542b59aa9b91236C21Dfd82;
764 
765     modifier onlyInitiator(uint256 _swapId) {
766         require(
767             msg.sender == swaps[_swapId].initiator,
768             "Caller is not swap initiator."
769         );
770         _;
771     }
772 
773     modifier onlyReceiver(uint256 _swapId) {
774         require(
775             msg.sender == swaps[_swapId].receiver,
776             "Caller is not swap receiver."
777         );
778         _;
779     }
780 
781     // Propose swap
782     function proposeSwap(
783         address _receiver,
784         address[] memory nftAddresses,
785         uint256[] memory nftIds,
786         uint256[] memory nftAmounts,
787         address[] memory nftAddressesWant,
788         uint256[] memory nftIdsWant,
789         uint256[] memory nftAmountsWant
790     ) public whenNotPaused {
791         require(
792             msg.sender != _receiver,
793             "Requestor can't be the same as receiver."
794         );
795         require(
796             nftAddresses.length == nftIds.length,
797             "NFT and ID arrays have to be same length"
798         );
799         require(
800             nftAddresses.length == nftAmounts.length,
801             "NFT and AMOUNT arrays have to be same length"
802         );
803         require(
804             nftAddressesWant.length == nftIdsWant.length,
805             "NFT and ID WANT arrays have to be same length"
806         );
807         require(
808             nftAddressesWant.length == nftAmountsWant.length,
809             "NFT and AMOUNT WANT arrays have to be same length"
810         );
811 
812         for (uint256 i = 0; i < nftAddresses.length; i++) {
813             require(
814                 nftAddresses[i] == GHN ||
815                     nftAddresses[i] == SRBNNO ||
816                     nftAddresses[i] == AHC ||
817                     nftAddresses[i] == DVDA ||
818                     nftAddresses[i] == RTBNNO ||
819                     nftAddresses[i] == MGHN,
820                 "Not GodHatesNFTees Ecosystem."
821             );
822         }
823         for (uint256 i = 0; i < nftAddressesWant.length; i++) {
824             require(
825                 nftAddresses[i] == GHN ||
826                     nftAddresses[i] == SRBNNO ||
827                     nftAddresses[i] == AHC ||
828                     nftAddresses[i] == DVDA ||
829                     nftAddresses[i] == RTBNNO ||
830                     nftAddresses[i] == MGHN,
831                 "Not GodHatesNFTees Ecosystem."
832             );
833         }
834 
835         uint256 Id = swaps.length;
836         safeMultipleTransfersFrom(
837             msg.sender,
838             address(this),
839             nftAddresses,
840             nftIds,
841             nftAmounts
842         );
843 
844         swaps.push(
845             Swap({
846                 swapId: Id,
847                 initiator: msg.sender,
848                 initiatorNftAddresses: nftAddresses,
849                 initiatorNftIds: nftIds,
850                 initiatorNftAmounts: nftAmounts,
851                 initiatorNftAddressesWant: nftAddressesWant,
852                 initiatorNftIdsWant: nftIdsWant,
853                 initiatorNftAmountsWant: nftAmountsWant,
854                 receiver: _receiver,
855                 state: uint256(SwapState.Proposed)
856             })
857         );
858 
859         // Add Swaps of users
860         userSwaps[msg.sender].push(Id);
861         userSwaps[_receiver].push(Id);
862     }
863 
864     // Confirm transaction
865 
866     function acceptSwap(uint256 _swapId)
867         public
868         whenNotPaused
869         onlyReceiver(_swapId)
870     {
871         require(
872             (swaps[_swapId].initiatorNftAddresses.length != 0),
873             "Can't accept swap. Initiator didn't create swap."
874         );
875         // transfer NFTs from Receiver to initiator
876         safeMultipleTransfersFrom(
877             swaps[_swapId].receiver,
878             swaps[_swapId].initiator,
879             swaps[_swapId].initiatorNftAddressesWant,
880             swaps[_swapId].initiatorNftIdsWant,
881             swaps[_swapId].initiatorNftAmountsWant
882         );
883 
884         // transfer NFTs from smart contract to second user
885         safeMultipleTransfersFrom(
886             address(this),
887             swaps[_swapId].receiver,
888             swaps[_swapId].initiatorNftAddresses,
889             swaps[_swapId].initiatorNftIds,
890             swaps[_swapId].initiatorNftAmounts
891         );
892         Swap storage swap = swaps[_swapId];
893         swap.state = uint256(SwapState.Completed);
894     }
895 
896     // Cancel Swap
897     function cancelSwap(uint256 _swapId)
898         public
899         whenNotPaused
900         onlyInitiator(_swapId)
901     {
902         Swap storage swap = swaps[_swapId];
903         require(
904             swap.state == uint256(SwapState.Proposed),
905             "This transaction was already Canceled or Completed"
906         );
907         require(msg.sender == swap.initiator, "Need requestor to revoke");
908         safeMultipleTransfersFrom(
909             address(this),
910             swaps[_swapId].initiator,
911             swaps[_swapId].initiatorNftAddresses,
912             swaps[_swapId].initiatorNftIds,
913             swaps[_swapId].initiatorNftAmounts
914         );
915         swap.state = uint256(SwapState.Canceled);
916     }
917 
918     // Get Swaps of users
919     function getUserSwaps(address usersAddress)
920         public
921         view
922         returns (uint256[] memory)
923     {
924         return userSwaps[usersAddress];
925     }
926 
927     // Get all Swaps count
928     function getAllSwapsCount() public view returns (uint256) {
929         return swaps.length;
930     }
931 
932     // Get Swaps data
933     function getSwapsData(uint256 _swapId)
934         public
935         view
936         returns (
937             uint256 swapId,
938             address initiator,
939             address receiver,
940             address[] memory initiatorNftAddresses,
941             uint256[] memory initiatorNftIds,
942             uint256[] memory initiatorNftAmounts,
943             address[] memory initiatorNftAddressesWant,
944             uint256[] memory initiatorNftIdsWant,
945             uint256[] memory initiatorNftAmountsWant,
946             uint256 state
947         )
948     {
949         Swap storage swap = swaps[_swapId];
950 
951         return (
952             swap.swapId,
953             swap.initiator,
954             swap.receiver,
955             swap.initiatorNftAddresses,
956             swap.initiatorNftIds,
957             swap.initiatorNftAmounts,
958             swap.initiatorNftAddressesWant,
959             swap.initiatorNftIdsWant,
960             swap.initiatorNftAmountsWant,
961             swap.state
962         );
963     }
964 
965     // Pause Contract
966     function pause() public onlyOwner {
967         _pause();
968     }
969 
970     function unpause() public onlyOwner {
971         _unpause();
972     }
973 
974     function safeMultipleTransfersFrom(
975         address from,
976         address to,
977         address[] memory nftAddresses,
978         uint256[] memory nftIds,
979         uint256[] memory nftAmounts
980     ) internal virtual {
981         for (uint256 i = 0; i < nftIds.length; i++) {
982             safeTransferFrom(
983                 from,
984                 to,
985                 nftAddresses[i],
986                 nftIds[i],
987                 nftAmounts[i],
988                 ""
989             );
990         }
991     }
992 
993     function safeTransferFrom(
994         address from,
995         address to,
996         address tokenAddress,
997         uint256 tokenId,
998         uint256 tokenAmount,
999         bytes memory _data
1000     ) internal virtual {
1001         if (tokenAmount == 0) {
1002             IERC721(tokenAddress).safeTransferFrom(from, to, tokenId, _data);
1003         } else {
1004             IERC1155(tokenAddress).safeTransferFrom(
1005                 from,
1006                 to,
1007                 tokenId,
1008                 tokenAmount,
1009                 _data
1010             );
1011         }
1012     }
1013 }