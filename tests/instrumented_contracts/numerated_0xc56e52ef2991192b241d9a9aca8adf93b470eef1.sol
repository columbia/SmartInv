1 // Sources flattened with hardhat v2.9.3 https://hardhat.org
2 
3 // File contracts/tankies.sol
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2022-04-09
7 */
8 
9 // Sources flattened with hardhat v2.9.3 https://hardhat.org
10 
11 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.5.0
12 
13 
14 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
15 
16 pragma solidity ^0.8.0;
17 
18 /**
19  * @dev Interface of the ERC165 standard, as defined in the
20  * https://eips.ethereum.org/EIPS/eip-165[EIP].
21  *
22  * Implementers can declare support of contract interfaces, which can then be
23  * queried by others ({ERC165Checker}).
24  *
25  * For an implementation, see {ERC165}.
26  */
27 interface IERC165 {
28     /**
29      * @dev Returns true if this contract implements the interface defined by
30      * `interfaceId`. See the corresponding
31      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
32      * to learn more about how these ids are created.
33      *
34      * This function call must use less than 30 000 gas.
35      */
36     function supportsInterface(bytes4 interfaceId) external view returns (bool);
37 }
38 
39 
40 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.5.0
41 
42 interface IERC721A {
43     /**
44      * The caller must own the token or be an approved operator.
45      */
46     error ApprovalCallerNotOwnerNorApproved();
47 
48     /**
49      * The token does not exist.
50      */
51     error ApprovalQueryForNonexistentToken();
52 
53     /**
54      * The caller cannot approve to their own address.
55      */
56     error ApproveToCaller();
57 
58     /**
59      * The caller cannot approve to the current owner.
60      */
61     error ApprovalToCurrentOwner();
62 
63     /**
64      * Cannot query the balance for the zero address.
65      */
66     error BalanceQueryForZeroAddress();
67 
68     /**
69      * Cannot mint to the zero address.
70      */
71     error MintToZeroAddress();
72 
73     /**
74      * The quantity of tokens minted must be more than zero.
75      */
76     error MintZeroQuantity();
77 
78     /**
79      * The token does not exist.
80      */
81     error OwnerQueryForNonexistentToken();
82 
83     /**
84      * The caller must own the token or be an approved operator.
85      */
86     error TransferCallerNotOwnerNorApproved();
87 
88     /**
89      * The token must be owned by `from`.
90      */
91     error TransferFromIncorrectOwner();
92 
93     /**
94      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
95      */
96     error TransferToNonERC721ReceiverImplementer();
97 
98     /**
99      * Cannot transfer to the zero address.
100      */
101     error TransferToZeroAddress();
102 
103     /**
104      * The token does not exist.
105      */
106     error URIQueryForNonexistentToken();
107 
108     struct TokenOwnership {
109         // The address of the owner.
110         address addr;
111         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
112         uint64 startTimestamp;
113         // Whether the token has been burned.
114         bool burned;
115     }
116 
117     /**
118      * @dev Returns the total amount of tokens stored by the contract.
119      *
120      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
121      */
122     function totalSupply() external view returns (uint256);
123 
124     // ==============================
125     //            IERC165
126     // ==============================
127 
128     /**
129      * @dev Returns true if this contract implements the interface defined by
130      * `interfaceId`. See the corresponding
131      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
132      * to learn more about how these ids are created.
133      *
134      * This function call must use less than 30 000 gas.
135      */
136     function supportsInterface(bytes4 interfaceId) external view returns (bool);
137 
138     // ==============================
139     //            IERC721
140     // ==============================
141 
142     /**
143      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
144      */
145     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
146 
147     /**
148      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
149      */
150     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
151 
152     /**
153      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
154      */
155     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
156 
157     /**
158      * @dev Returns the number of tokens in ``owner``'s account.
159      */
160     function balanceOf(address owner) external view returns (uint256 balance);
161 
162     /**
163      * @dev Returns the owner of the `tokenId` token.
164      *
165      * Requirements:
166      *
167      * - `tokenId` must exist.
168      */
169     function ownerOf(uint256 tokenId) external view returns (address owner);
170 
171     /**
172      * @dev Safely transfers `tokenId` token from `from` to `to`.
173      *
174      * Requirements:
175      *
176      * - `from` cannot be the zero address.
177      * - `to` cannot be the zero address.
178      * - `tokenId` token must exist and be owned by `from`.
179      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
180      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
181      *
182      * Emits a {Transfer} event.
183      */
184     function safeTransferFrom(
185         address from,
186         address to,
187         uint256 tokenId,
188         bytes calldata data
189     ) external;
190 
191     /**
192      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
193      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
194      *
195      * Requirements:
196      *
197      * - `from` cannot be the zero address.
198      * - `to` cannot be the zero address.
199      * - `tokenId` token must exist and be owned by `from`.
200      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
201      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
202      *
203      * Emits a {Transfer} event.
204      */
205     function safeTransferFrom(
206         address from,
207         address to,
208         uint256 tokenId
209     ) external;
210 
211     /**
212      * @dev Transfers `tokenId` token from `from` to `to`.
213      *
214      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
215      *
216      * Requirements:
217      *
218      * - `from` cannot be the zero address.
219      * - `to` cannot be the zero address.
220      * - `tokenId` token must be owned by `from`.
221      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
222      *
223      * Emits a {Transfer} event.
224      */
225     function transferFrom(
226         address from,
227         address to,
228         uint256 tokenId
229     ) external;
230 
231     /**
232      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
233      * The approval is cleared when the token is transferred.
234      *
235      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
236      *
237      * Requirements:
238      *
239      * - The caller must own the token or be an approved operator.
240      * - `tokenId` must exist.
241      *
242      * Emits an {Approval} event.
243      */
244     function approve(address to, uint256 tokenId) external;
245 
246     /**
247      * @dev Approve or remove `operator` as an operator for the caller.
248      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
249      *
250      * Requirements:
251      *
252      * - The `operator` cannot be the caller.
253      *
254      * Emits an {ApprovalForAll} event.
255      */
256     function setApprovalForAll(address operator, bool _approved) external;
257 
258     /**
259      * @dev Returns the account approved for `tokenId` token.
260      *
261      * Requirements:
262      *
263      * - `tokenId` must exist.
264      */
265     function getApproved(uint256 tokenId) external view returns (address operator);
266 
267     /**
268      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
269      *
270      * See {setApprovalForAll}
271      */
272     function isApprovedForAll(address owner, address operator) external view returns (bool);
273 
274     // ==============================
275     //        IERC721Metadata
276     // ==============================
277 
278     /**
279      * @dev Returns the token collection name.
280      */
281     function name() external view returns (string memory);
282 
283     /**
284      * @dev Returns the token collection symbol.
285      */
286     function symbol() external view returns (string memory);
287 
288     /**
289      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
290      */
291     function tokenURI(uint256 tokenId) external view returns (string memory);
292 }
293 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
294 
295 pragma solidity ^0.8.0;
296 
297 /**
298  * @dev Required interface of an ERC721 compliant contract.
299  */
300 interface IERC721 is IERC165 {
301     /**
302      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
303      */
304     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
305 
306     /**
307      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
308      */
309     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
310 
311     /**
312      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
313      */
314     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
315 
316     /**
317      * @dev Returns the number of tokens in ``owner``'s account.
318      */
319     function balanceOf(address owner) external view returns (uint256 balance);
320 
321     /**
322      * @dev Returns the owner of the `tokenId` token.
323      *
324      * Requirements:
325      *
326      * - `tokenId` must exist.
327      */
328     function ownerOf(uint256 tokenId) external view returns (address owner);
329 
330     /**
331      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
332      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
333      *
334      * Requirements:
335      *
336      * - `from` cannot be the zero address.
337      * - `to` cannot be the zero address.
338      * - `tokenId` token must exist and be owned by `from`.
339      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
340      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
341      *
342      * Emits a {Transfer} event.
343      */
344     function safeTransferFrom(
345         address from,
346         address to,
347         uint256 tokenId
348     ) external;
349 
350     /**
351      * @dev Transfers `tokenId` token from `from` to `to`.
352      *
353      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
354      *
355      * Requirements:
356      *
357      * - `from` cannot be the zero address.
358      * - `to` cannot be the zero address.
359      * - `tokenId` token must be owned by `from`.
360      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
361      *
362      * Emits a {Transfer} event.
363      */
364     function transferFrom(
365         address from,
366         address to,
367         uint256 tokenId
368     ) external;
369 
370     /**
371      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
372      * The approval is cleared when the token is transferred.
373      *
374      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
375      *
376      * Requirements:
377      *
378      * - The caller must own the token or be an approved operator.
379      * - `tokenId` must exist.
380      *
381      * Emits an {Approval} event.
382      */
383     function approve(address to, uint256 tokenId) external;
384 
385     /**
386      * @dev Returns the account approved for `tokenId` token.
387      *
388      * Requirements:
389      *
390      * - `tokenId` must exist.
391      */
392     function getApproved(uint256 tokenId) external view returns (address operator);
393 
394     /**
395      * @dev Approve or remove `operator` as an operator for the caller.
396      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
397      *
398      * Requirements:
399      *
400      * - The `operator` cannot be the caller.
401      *
402      * Emits an {ApprovalForAll} event.
403      */
404     function setApprovalForAll(address operator, bool _approved) external;
405 
406     /**
407      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
408      *
409      * See {setApprovalForAll}
410      */
411     function isApprovedForAll(address owner, address operator) external view returns (bool);
412 
413     /**
414      * @dev Safely transfers `tokenId` token from `from` to `to`.
415      *
416      * Requirements:
417      *
418      * - `from` cannot be the zero address.
419      * - `to` cannot be the zero address.
420      * - `tokenId` token must exist and be owned by `from`.
421      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
422      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
423      *
424      * Emits a {Transfer} event.
425      */
426     function safeTransferFrom(
427         address from,
428         address to,
429         uint256 tokenId,
430         bytes calldata data
431     ) external;
432 }
433 
434 
435 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.5.0
436 
437 
438 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
439 
440 pragma solidity ^0.8.0;
441 
442 /**
443  * @title ERC721 token receiver interface
444  * @dev Interface for any contract that wants to support safeTransfers
445  * from ERC721 asset contracts.
446  */
447 interface IERC721Receiver {
448     /**
449      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
450      * by `operator` from `from`, this function is called.
451      *
452      * It must return its Solidity selector to confirm the token transfer.
453      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
454      *
455      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
456      */
457     function onERC721Received(
458         address operator,
459         address from,
460         uint256 tokenId,
461         bytes calldata data
462     ) external returns (bytes4);
463 }
464 
465 
466 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.5.0
467 
468 
469 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
470 
471 pragma solidity ^0.8.0;
472 
473 /**
474  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
475  * @dev See https://eips.ethereum.org/EIPS/eip-721
476  */
477 interface IERC721Metadata is IERC721 {
478     /**
479      * @dev Returns the token collection name.
480      */
481     function name() external view returns (string memory);
482 
483     /**
484      * @dev Returns the token collection symbol.
485      */
486     function symbol() external view returns (string memory);
487 
488     /**
489      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
490      */
491     function tokenURI(uint256 tokenId) external view returns (string memory);
492 }
493 
494 
495 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.5.0
496 
497 
498 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
499 
500 pragma solidity ^0.8.0;
501 
502 /**
503  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
504  * @dev See https://eips.ethereum.org/EIPS/eip-721
505  */
506 interface IERC721Enumerable is IERC721 {
507     /**
508      * @dev Returns the total amount of tokens stored by the contract.
509      */
510     function totalSupply() external view returns (uint256);
511 
512     /**
513      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
514      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
515      */
516     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
517 
518     /**
519      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
520      * Use along with {totalSupply} to enumerate all tokens.
521      */
522     function tokenByIndex(uint256 index) external view returns (uint256);
523 }
524 
525 
526 
527 
528 // File @openzeppelin/contracts/utils/Address.sol@v4.5.0
529 
530 
531 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
532 
533 pragma solidity ^0.8.1;
534 
535 /**
536  * @dev Collection of functions related to the address type
537  */
538 library Address {
539     /**
540      * @dev Returns true if `account` is a contract.
541      *
542      * [IMPORTANT]
543      * ====
544      * It is unsafe to assume that an address for which this function returns
545      * false is an externally-owned account (EOA) and not a contract.
546      *
547      * Among others, `isContract` will return false for the following
548      * types of addresses:
549      *
550      *  - an externally-owned account
551      *  - a contract in construction
552      *  - an address where a contract will be created
553      *  - an address where a contract lived, but was destroyed
554      * ====
555      *
556      * [IMPORTANT]
557      * ====
558      * You shouldn't rely on `isContract` to protect against flash loan attacks!
559      *
560      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
561      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
562      * constructor.
563      * ====
564      */
565     function isContract(address account) internal view returns (bool) {
566         // This method relies on extcodesize/address.code.length, which returns 0
567         // for contracts in construction, since the code is only stored at the end
568         // of the constructor execution.
569 
570         return account.code.length > 0;
571     }
572 
573     /**
574      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
575      * `recipient`, forwarding all available gas and reverting on errors.
576      *
577      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
578      * of certain opcodes, possibly making contracts go over the 2300 gas limit
579      * imposed by `transfer`, making them unable to receive funds via
580      * `transfer`. {sendValue} removes this limitation.
581      *
582      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
583      *
584      * IMPORTANT: because control is transferred to `recipient`, care must be
585      * taken to not create reentrancy vulnerabilities. Consider using
586      * {ReentrancyGuard} or the
587      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
588      */
589     function sendValue(address payable recipient, uint256 amount) internal {
590         require(address(this).balance >= amount, "Address: insufficient balance");
591 
592         (bool success, ) = recipient.call{value: amount}("");
593         require(success, "Address: unable to send value, recipient may have reverted");
594     }
595 
596     /**
597      * @dev Performs a Solidity function call using a low level `call`. A
598      * plain `call` is an unsafe replacement for a function call: use this
599      * function instead.
600      *
601      * If `target` reverts with a revert reason, it is bubbled up by this
602      * function (like regular Solidity function calls).
603      *
604      * Returns the raw returned data. To convert to the expected return value,
605      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
606      *
607      * Requirements:
608      *
609      * - `target` must be a contract.
610      * - calling `target` with `data` must not revert.
611      *
612      * _Available since v3.1._
613      */
614     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
615         return functionCall(target, data, "Address: low-level call failed");
616     }
617 
618     /**
619      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
620      * `errorMessage` as a fallback revert reason when `target` reverts.
621      *
622      * _Available since v3.1._
623      */
624     function functionCall(
625         address target,
626         bytes memory data,
627         string memory errorMessage
628     ) internal returns (bytes memory) {
629         return functionCallWithValue(target, data, 0, errorMessage);
630     }
631 
632     /**
633      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
634      * but also transferring `value` wei to `target`.
635      *
636      * Requirements:
637      *
638      * - the calling contract must have an ETH balance of at least `value`.
639      * - the called Solidity function must be `payable`.
640      *
641      * _Available since v3.1._
642      */
643     function functionCallWithValue(
644         address target,
645         bytes memory data,
646         uint256 value
647     ) internal returns (bytes memory) {
648         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
649     }
650 
651     /**
652      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
653      * with `errorMessage` as a fallback revert reason when `target` reverts.
654      *
655      * _Available since v3.1._
656      */
657     function functionCallWithValue(
658         address target,
659         bytes memory data,
660         uint256 value,
661         string memory errorMessage
662     ) internal returns (bytes memory) {
663         require(address(this).balance >= value, "Address: insufficient balance for call");
664         require(isContract(target), "Address: call to non-contract");
665 
666         (bool success, bytes memory returndata) = target.call{value: value}(data);
667         return verifyCallResult(success, returndata, errorMessage);
668     }
669 
670     /**
671      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
672      * but performing a static call.
673      *
674      * _Available since v3.3._
675      */
676     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
677         return functionStaticCall(target, data, "Address: low-level static call failed");
678     }
679 
680     /**
681      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
682      * but performing a static call.
683      *
684      * _Available since v3.3._
685      */
686     function functionStaticCall(
687         address target,
688         bytes memory data,
689         string memory errorMessage
690     ) internal view returns (bytes memory) {
691         require(isContract(target), "Address: static call to non-contract");
692 
693         (bool success, bytes memory returndata) = target.staticcall(data);
694         return verifyCallResult(success, returndata, errorMessage);
695     }
696 
697     /**
698      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
699      * but performing a delegate call.
700      *
701      * _Available since v3.4._
702      */
703     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
704         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
705     }
706 
707     /**
708      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
709      * but performing a delegate call.
710      *
711      * _Available since v3.4._
712      */
713     function functionDelegateCall(
714         address target,
715         bytes memory data,
716         string memory errorMessage
717     ) internal returns (bytes memory) {
718         require(isContract(target), "Address: delegate call to non-contract");
719 
720         (bool success, bytes memory returndata) = target.delegatecall(data);
721         return verifyCallResult(success, returndata, errorMessage);
722     }
723 
724     /**
725      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
726      * revert reason using the provided one.
727      *
728      * _Available since v4.3._
729      */
730     function verifyCallResult(
731         bool success,
732         bytes memory returndata,
733         string memory errorMessage
734     ) internal pure returns (bytes memory) {
735         if (success) {
736             return returndata;
737         } else {
738             // Look for revert reason and bubble it up if present
739             if (returndata.length > 0) {
740                 // The easiest way to bubble the revert reason is using memory via assembly
741 
742                 assembly {
743                     let returndata_size := mload(returndata)
744                     revert(add(32, returndata), returndata_size)
745                 }
746             } else {
747                 revert(errorMessage);
748             }
749         }
750     }
751 }
752 
753 
754 // File @openzeppelin/contracts/utils/Context.sol@v4.5.0
755 
756 
757 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
758 
759 pragma solidity ^0.8.0;
760 
761 /**
762  * @dev Provides information about the current execution context, including the
763  * sender of the transaction and its data. While these are generally available
764  * via msg.sender and msg.data, they should not be accessed in such a direct
765  * manner, since when dealing with meta-transactions the account sending and
766  * paying for execution may not be the actual sender (as far as an application
767  * is concerned).
768  *
769  * This contract is only required for intermediate, library-like contracts.
770  */
771 abstract contract Context {
772     function _msgSender() internal view virtual returns (address) {
773         return msg.sender;
774     }
775 
776     function _msgData() internal view virtual returns (bytes calldata) {
777         return msg.data;
778     }
779 }
780 
781 
782 // File @openzeppelin/contracts/utils/Strings.sol@v4.5.0
783 
784 
785 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
786 
787 pragma solidity ^0.8.0;
788 
789 /**
790  * @dev String operations.
791  */
792 library Strings {
793     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
794 
795     /**
796      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
797      */
798     function toString(uint256 value) internal pure returns (string memory) {
799         // Inspired by OraclizeAPI's implementation - MIT licence
800         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
801 
802         if (value == 0) {
803             return "0";
804         }
805         uint256 temp = value;
806         uint256 digits;
807         while (temp != 0) {
808             digits++;
809             temp /= 10;
810         }
811         bytes memory buffer = new bytes(digits);
812         while (value != 0) {
813             digits -= 1;
814             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
815             value /= 10;
816         }
817         return string(buffer);
818     }
819 
820     /**
821      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
822      */
823     function toHexString(uint256 value) internal pure returns (string memory) {
824         if (value == 0) {
825             return "0x00";
826         }
827         uint256 temp = value;
828         uint256 length = 0;
829         while (temp != 0) {
830             length++;
831             temp >>= 8;
832         }
833         return toHexString(value, length);
834     }
835 
836     /**
837      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
838      */
839     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
840         bytes memory buffer = new bytes(2 * length + 2);
841         buffer[0] = "0";
842         buffer[1] = "x";
843         for (uint256 i = 2 * length + 1; i > 1; --i) {
844             buffer[i] = _HEX_SYMBOLS[value & 0xf];
845             value >>= 4;
846         }
847         require(value == 0, "Strings: hex length insufficient");
848         return string(buffer);
849     }
850 }
851 
852 
853 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.5.0
854 
855 
856 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
857 
858 pragma solidity ^0.8.0;
859 
860 /**
861  * @dev Implementation of the {IERC165} interface.
862  *
863  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
864  * for the additional interface id that will be supported. For example:
865  *
866  * ```solidity
867  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
868  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
869  * }
870  * ```
871  *
872  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
873  */
874 abstract contract ERC165 is IERC165 {
875     /**
876      * @dev See {IERC165-supportsInterface}.
877      */
878     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
879         return interfaceId == type(IERC165).interfaceId;
880     }
881 }
882 
883 
884 // File @openzeppelin/contracts/access/Ownable.sol@v4.5.0
885 
886 
887 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
888 
889 pragma solidity ^0.8.0;
890 
891 /**
892  * @dev Contract module which provides a basic access control mechanism, where
893  * there is an account (an owner) that can be granted exclusive access to
894  * specific functions.
895  *
896  * By default, the owner account will be the one that deploys the contract. This
897  * can later be changed with {transferOwnership}.
898  *
899  * This module is used through inheritance. It will make available the modifier
900  * `onlyOwner`, which can be applied to your functions to restrict their use to
901  * the owner.
902  */
903 abstract contract Ownable is Context {
904     address private _owner;
905 
906     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
907 
908     /**
909      * @dev Initializes the contract setting the deployer as the initial owner.
910      */
911     constructor() {
912         _transferOwnership(_msgSender());
913     }
914 
915     /**
916      * @dev Returns the address of the current owner.
917      */
918     function owner() public view virtual returns (address) {
919         return _owner;
920     }
921 
922     /**
923      * @dev Throws if called by any account other than the owner.
924      */
925     modifier onlyOwner() {
926         require(owner() == _msgSender(), "Ownable: caller is not the owner");
927         _;
928     }
929 
930     /**
931      * @dev Leaves the contract without owner. It will not be possible to call
932      * `onlyOwner` functions anymore. Can only be called by the current owner.
933      *
934      * NOTE: Renouncing ownership will leave the contract without an owner,
935      * thereby removing any functionality that is only available to the owner.
936      */
937     function renounceOwnership() public virtual onlyOwner {
938         _transferOwnership(address(0));
939     }
940 
941     /**
942      * @dev Transfers ownership of the contract to a new account (`newOwner`).
943      * Can only be called by the current owner.
944      */
945     function transferOwnership(address newOwner) public virtual onlyOwner {
946         require(newOwner != address(0), "Ownable: new owner is the zero address");
947         _transferOwnership(newOwner);
948     }
949 
950     /**
951      * @dev Transfers ownership of the contract to a new account (`newOwner`).
952      * Internal function without access restriction.
953      */
954     function _transferOwnership(address newOwner) internal virtual {
955         address oldOwner = _owner;
956         _owner = newOwner;
957         emit OwnershipTransferred(oldOwner, newOwner);
958     }
959 }
960 
961 
962 // File @openzeppelin/contracts/utils/cryptography/MerkleProof.sol@v4.5.0
963 
964 
965 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
966 
967 pragma solidity ^0.8.0;
968 
969 /**
970  * @dev These functions deal with verification of Merkle Trees proofs.
971  *
972  * The proofs can be generated using the JavaScript library
973  * https://github.com/miguelmota/merkletreejs[merkletreejs].
974  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
975  *
976  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
977  */
978 library MerkleProof {
979     /**
980      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
981      * defined by `root`. For this, a `proof` must be provided, containing
982      * sibling hashes on the branch from the leaf to the root of the tree. Each
983      * pair of leaves and each pair of pre-images are assumed to be sorted.
984      */
985     function verify(
986         bytes32[] memory proof,
987         bytes32 root,
988         bytes32 leaf
989     ) internal pure returns (bool) {
990         return processProof(proof, leaf) == root;
991     }
992 
993     /**
994      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
995      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
996      * hash matches the root of the tree. When processing the proof, the pairs
997      * of leafs & pre-images are assumed to be sorted.
998      *
999      * _Available since v4.4._
1000      */
1001     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1002         bytes32 computedHash = leaf;
1003         for (uint256 i = 0; i < proof.length; i++) {
1004             bytes32 proofElement = proof[i];
1005             if (computedHash <= proofElement) {
1006                 // Hash(current computed hash + current element of the proof)
1007                 computedHash = _efficientHash(computedHash, proofElement);
1008             } else {
1009                 // Hash(current element of the proof + current computed hash)
1010                 computedHash = _efficientHash(proofElement, computedHash);
1011             }
1012         }
1013         return computedHash;
1014     }
1015 
1016     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1017         assembly {
1018             mstore(0x00, a)
1019             mstore(0x20, b)
1020             value := keccak256(0x00, 0x40)
1021         }
1022     }
1023 }
1024 
1025 
1026 // File contracts/tankies.sol
1027 
1028 pragma solidity ^0.8.4;
1029 
1030 
1031 
1032 
1033 
1034 
1035 
1036 
1037 error ApprovalCallerNotOwnerNorApproved();
1038 error ApprovalQueryForNonexistentToken();
1039 error ApproveToCaller();
1040 error ApprovalToCurrentOwner();
1041 error BalanceQueryForZeroAddress();
1042 error MintedQueryForZeroAddress();
1043 error BurnedQueryForZeroAddress();
1044 error MintToZeroAddress();
1045 error MintZeroQuantity();
1046 error OwnerIndexOutOfBounds();
1047 error OwnerQueryForNonexistentToken();
1048 error TokenIndexOutOfBounds();
1049 error TransferCallerNotOwnerNorApproved();
1050 error TransferFromIncorrectOwner();
1051 error TransferToNonERC721ReceiverImplementer();
1052 error TransferToZeroAddress();
1053 error URIQueryForNonexistentToken();
1054 
1055 /**
1056  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1057  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1058  *
1059  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
1060  *
1061  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1062  *
1063  * Assumes that the maximum token id cannot exceed 2**128 - 1 (max value of uint128).
1064  */
1065 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1066     using Address for address;
1067     using Strings for uint256;
1068 
1069     // Compiler will pack this into a single 256bit word.
1070     struct TokenOwnership {
1071         // The address of the owner.
1072         address addr;
1073         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
1074         uint64 startTimestamp;
1075         // Whether the token has been burned.
1076         bool burned;
1077     }
1078 
1079     // Compiler will pack this into a single 256bit word.
1080     struct AddressData {
1081         // Realistically, 2**64-1 is more than enough.
1082         uint64 balance;
1083         // Keeps track of mint count with minimal overhead for tokenomics.
1084         uint64 numberMinted;
1085         // Keeps track of burn count with minimal overhead for tokenomics.
1086         uint64 numberBurned;
1087     }
1088 
1089     // Compiler will pack the following 
1090     // _currentIndex and _burnCounter into a single 256bit word.
1091     
1092     // The tokenId of the next token to be minted.
1093     uint128 internal _currentIndex;
1094 
1095     // The number of tokens burned.
1096     uint128 internal _burnCounter;
1097 
1098     // Token name
1099     string private _name;
1100 
1101     // Token symbol
1102     string private _symbol;
1103 
1104     // Mapping from token ID to ownership details
1105     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1106     mapping(uint256 => TokenOwnership) internal _ownerships;
1107 
1108     // Mapping owner address to address data
1109     mapping(address => AddressData) private _addressData;
1110 
1111     // Mapping from token ID to approved address
1112     mapping(uint256 => address) private _tokenApprovals;
1113 
1114     // Mapping from owner to operator approvals
1115     mapping(address => mapping(address => bool)) private _operatorApprovals;
1116 
1117     constructor(string memory name_, string memory symbol_) {
1118         _name = name_;
1119         _symbol = symbol_;
1120     }
1121 
1122     /**
1123      * @dev See {IERC721Enumerable-totalSupply}.
1124      */
1125     function totalSupply() public view override returns (uint256) {
1126         // Counter underflow is impossible as _burnCounter cannot be incremented
1127         // more than _currentIndex times
1128         unchecked {
1129             return _currentIndex - _burnCounter;    
1130         }
1131     }
1132 
1133     /**
1134      * @dev See {IERC721Enumerable-tokenByIndex}.
1135      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1136      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1137      */
1138     function tokenByIndex(uint256 index) public view override returns (uint256) {
1139         uint256 numMintedSoFar = _currentIndex;
1140         uint256 tokenIdsIdx;
1141 
1142         // Counter overflow is impossible as the loop breaks when
1143         // uint256 i is equal to another uint256 numMintedSoFar.
1144         unchecked {
1145             for (uint256 i; i < numMintedSoFar; i++) {
1146                 TokenOwnership memory ownership = _ownerships[i];
1147                 if (!ownership.burned) {
1148                     if (tokenIdsIdx == index) {
1149                         return i;
1150                     }
1151                     tokenIdsIdx++;
1152                 }
1153             }
1154         }
1155         revert TokenIndexOutOfBounds();
1156     }
1157 
1158     /**
1159      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1160      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1161      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1162      */
1163     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1164         if (index >= balanceOf(owner)) revert OwnerIndexOutOfBounds();
1165         uint256 numMintedSoFar = _currentIndex;
1166         uint256 tokenIdsIdx;
1167         address currOwnershipAddr;
1168 
1169         // Counter overflow is impossible as the loop breaks when
1170         // uint256 i is equal to another uint256 numMintedSoFar.
1171         unchecked {
1172             for (uint256 i; i < numMintedSoFar; i++) {
1173                 TokenOwnership memory ownership = _ownerships[i];
1174                 if (ownership.burned) {
1175                     continue;
1176                 }
1177                 if (ownership.addr != address(0)) {
1178                     currOwnershipAddr = ownership.addr;
1179                 }
1180                 if (currOwnershipAddr == owner) {
1181                     if (tokenIdsIdx == index) {
1182                         return i;
1183                     }
1184                     tokenIdsIdx++;
1185                 }
1186             }
1187         }
1188 
1189         // Execution should never reach this point.
1190         revert();
1191     }
1192 
1193     /**
1194      * @dev See {IERC165-supportsInterface}.
1195      */
1196     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1197         return
1198             interfaceId == type(IERC721).interfaceId ||
1199             interfaceId == type(IERC721Metadata).interfaceId ||
1200             interfaceId == type(IERC721Enumerable).interfaceId ||
1201             super.supportsInterface(interfaceId);
1202     }
1203 
1204     /**
1205      * @dev See {IERC721-balanceOf}.
1206      */
1207     function balanceOf(address owner) public view override returns (uint256) {
1208         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1209         return uint256(_addressData[owner].balance);
1210     }
1211 
1212     function _numberMinted(address owner) internal view returns (uint256) {
1213         if (owner == address(0)) revert MintedQueryForZeroAddress();
1214         return uint256(_addressData[owner].numberMinted);
1215     }
1216 
1217     function _numberBurned(address owner) internal view returns (uint256) {
1218         if (owner == address(0)) revert BurnedQueryForZeroAddress();
1219         return uint256(_addressData[owner].numberBurned);
1220     }
1221 
1222     /**
1223      * Gas spent here starts off proportional to the maximum mint batch size.
1224      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1225      */
1226     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1227         uint256 curr = tokenId;
1228 
1229         unchecked {
1230             if (curr < _currentIndex) {
1231                 TokenOwnership memory ownership = _ownerships[curr];
1232                 if (!ownership.burned) {
1233                     if (ownership.addr != address(0)) {
1234                         return ownership;
1235                     }
1236                     // Invariant: 
1237                     // There will always be an ownership that has an address and is not burned 
1238                     // before an ownership that does not have an address and is not burned.
1239                     // Hence, curr will not underflow.
1240                     while (true) {
1241                         curr--;
1242                         ownership = _ownerships[curr];
1243                         if (ownership.addr != address(0)) {
1244                             return ownership;
1245                         }
1246                     }
1247                 }
1248             }
1249         }
1250         revert OwnerQueryForNonexistentToken();
1251     }
1252 
1253     /**
1254      * @dev See {IERC721-ownerOf}.
1255      */
1256     function ownerOf(uint256 tokenId) public view override returns (address) {
1257         return ownershipOf(tokenId).addr;
1258     }
1259 
1260     /**
1261      * @dev See {IERC721Metadata-name}.
1262      */
1263     function name() public view virtual override returns (string memory) {
1264         return _name;
1265     }
1266 
1267     /**
1268      * @dev See {IERC721Metadata-symbol}.
1269      */
1270     function symbol() public view virtual override returns (string memory) {
1271         return _symbol;
1272     }
1273 
1274     /**
1275      * @dev See {IERC721Metadata-tokenURI}.
1276      */
1277     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1278         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1279 
1280         string memory baseURI = _baseURI();
1281         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1282     }
1283 
1284     /**
1285      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1286      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1287      * by default, can be overriden in child contracts.
1288      */
1289     function _baseURI() internal view virtual returns (string memory) {
1290         return '';
1291     }
1292 
1293     /**
1294      * @dev See {IERC721-approve}.
1295      */
1296     function approve(address to, uint256 tokenId) public override {
1297         address owner = ERC721A.ownerOf(tokenId);
1298         if (to == owner) revert ApprovalToCurrentOwner();
1299 
1300         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1301             revert ApprovalCallerNotOwnerNorApproved();
1302         }
1303 
1304         _approve(to, tokenId, owner);
1305     }
1306 
1307     /**
1308      * @dev See {IERC721-getApproved}.
1309      */
1310     function getApproved(uint256 tokenId) public view override returns (address) {
1311         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1312 
1313         return _tokenApprovals[tokenId];
1314     }
1315 
1316     /**
1317      * @dev See {IERC721-setApprovalForAll}.
1318      */
1319     function setApprovalForAll(address operator, bool approved) public override {
1320         if (operator == _msgSender()) revert ApproveToCaller();
1321 
1322         _operatorApprovals[_msgSender()][operator] = approved;
1323         emit ApprovalForAll(_msgSender(), operator, approved);
1324     }
1325 
1326     /**
1327      * @dev See {IERC721-isApprovedForAll}.
1328      */
1329     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1330         return _operatorApprovals[owner][operator];
1331     }
1332 
1333     /**
1334      * @dev See {IERC721-transferFrom}.
1335      */
1336     function transferFrom(
1337         address from,
1338         address to,
1339         uint256 tokenId
1340     ) public virtual override {
1341         _transfer(from, to, tokenId);
1342     }
1343 
1344     /**
1345      * @dev See {IERC721-safeTransferFrom}.
1346      */
1347     function safeTransferFrom(
1348         address from,
1349         address to,
1350         uint256 tokenId
1351     ) public virtual override {
1352         safeTransferFrom(from, to, tokenId, '');
1353     }
1354 
1355     /**
1356      * @dev See {IERC721-safeTransferFrom}.
1357      */
1358     function safeTransferFrom(
1359         address from,
1360         address to,
1361         uint256 tokenId,
1362         bytes memory _data
1363     ) public virtual override {
1364         _transfer(from, to, tokenId);
1365         if (!_checkOnERC721Received(from, to, tokenId, _data)) {
1366             revert TransferToNonERC721ReceiverImplementer();
1367         }
1368     }
1369 
1370     /**
1371      * @dev Returns whether `tokenId` exists.
1372      *
1373      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1374      *
1375      * Tokens start existing when they are minted (`_mint`),
1376      */
1377     function _exists(uint256 tokenId) internal view returns (bool) {
1378         return tokenId < _currentIndex && !_ownerships[tokenId].burned;
1379     }
1380 
1381     function _safeMint(address to, uint256 quantity) internal {
1382         _safeMint(to, quantity, '');
1383     }
1384 
1385     /**
1386      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1387      *
1388      * Requirements:
1389      *
1390      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1391      * - `quantity` must be greater than 0.
1392      *
1393      * Emits a {Transfer} event.
1394      */
1395     function _safeMint(
1396         address to,
1397         uint256 quantity,
1398         bytes memory _data
1399     ) internal {
1400         _mint(to, quantity, _data, true);
1401     }
1402 
1403     /**
1404      * @dev Mints `quantity` tokens and transfers them to `to`.
1405      *
1406      * Requirements:
1407      *
1408      * - `to` cannot be the zero address.
1409      * - `quantity` must be greater than 0.
1410      *
1411      * Emits a {Transfer} event.
1412      */
1413     function _mint(
1414         address to,
1415         uint256 quantity,
1416         bytes memory _data,
1417         bool safe
1418     ) internal {
1419         uint256 startTokenId = _currentIndex;
1420         if (to == address(0)) revert MintToZeroAddress();
1421         if (quantity == 0) revert MintZeroQuantity();
1422 
1423         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1424 
1425         // Overflows are incredibly unrealistic.
1426         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1427         // updatedIndex overflows if _currentIndex + quantity > 3.4e38 (2**128) - 1
1428         unchecked {
1429             _addressData[to].balance += uint64(quantity);
1430             _addressData[to].numberMinted += uint64(quantity);
1431 
1432             _ownerships[startTokenId].addr = to;
1433             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1434 
1435             uint256 updatedIndex = startTokenId;
1436 
1437             for (uint256 i; i < quantity; i++) {
1438                 emit Transfer(address(0), to, updatedIndex);
1439                 if (safe && !_checkOnERC721Received(address(0), to, updatedIndex, _data)) {
1440                     revert TransferToNonERC721ReceiverImplementer();
1441                 }
1442                 updatedIndex++;
1443             }
1444 
1445             _currentIndex = uint128(updatedIndex);
1446         }
1447         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1448     }
1449 
1450     /**
1451      * @dev Transfers `tokenId` from `from` to `to`.
1452      *
1453      * Requirements:
1454      *
1455      * - `to` cannot be the zero address.
1456      * - `tokenId` token must be owned by `from`.
1457      *
1458      * Emits a {Transfer} event.
1459      */
1460     function _transfer(
1461         address from,
1462         address to,
1463         uint256 tokenId
1464     ) private {
1465         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1466 
1467         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1468             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1469             getApproved(tokenId) == _msgSender());
1470 
1471         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1472         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1473         if (to == address(0)) revert TransferToZeroAddress();
1474 
1475         _beforeTokenTransfers(from, to, tokenId, 1);
1476 
1477         // Clear approvals from the previous owner
1478         _approve(address(0), tokenId, prevOwnership.addr);
1479 
1480         // Underflow of the sender's balance is impossible because we check for
1481         // ownership above and the recipient's balance can't realistically overflow.
1482         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**128.
1483         unchecked {
1484             _addressData[from].balance -= 1;
1485             _addressData[to].balance += 1;
1486 
1487             _ownerships[tokenId].addr = to;
1488             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1489 
1490             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1491             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1492             uint256 nextTokenId = tokenId + 1;
1493             if (_ownerships[nextTokenId].addr == address(0)) {
1494                 // This will suffice for checking _exists(nextTokenId),
1495                 // as a burned slot cannot contain the zero address.
1496                 if (nextTokenId < _currentIndex) {
1497                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1498                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1499                 }
1500             }
1501         }
1502 
1503         emit Transfer(from, to, tokenId);
1504         _afterTokenTransfers(from, to, tokenId, 1);
1505     }
1506 
1507     /**
1508      * @dev Destroys `tokenId`.
1509      * The approval is cleared when the token is burned.
1510      *
1511      * Requirements:
1512      *
1513      * - `tokenId` must exist.
1514      *
1515      * Emits a {Transfer} event.
1516      */
1517     function _burn(uint256 tokenId) internal virtual {
1518         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1519 
1520         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1521 
1522         // Clear approvals from the previous owner
1523         _approve(address(0), tokenId, prevOwnership.addr);
1524 
1525         // Underflow of the sender's balance is impossible because we check for
1526         // ownership above and the recipient's balance can't realistically overflow.
1527         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**128.
1528         unchecked {
1529             _addressData[prevOwnership.addr].balance -= 1;
1530             _addressData[prevOwnership.addr].numberBurned += 1;
1531 
1532             // Keep track of who burned the token, and the timestamp of burning.
1533             _ownerships[tokenId].addr = prevOwnership.addr;
1534             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1535             _ownerships[tokenId].burned = true;
1536 
1537             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1538             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1539             uint256 nextTokenId = tokenId + 1;
1540             if (_ownerships[nextTokenId].addr == address(0)) {
1541                 // This will suffice for checking _exists(nextTokenId),
1542                 // as a burned slot cannot contain the zero address.
1543                 if (nextTokenId < _currentIndex) {
1544                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1545                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1546                 }
1547             }
1548         }
1549 
1550         emit Transfer(prevOwnership.addr, address(0), tokenId);
1551         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1552 
1553         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1554         unchecked { 
1555             _burnCounter++;
1556         }
1557     }
1558 
1559     /**
1560      * @dev Approve `to` to operate on `tokenId`
1561      *
1562      * Emits a {Approval} event.
1563      */
1564     function _approve(
1565         address to,
1566         uint256 tokenId,
1567         address owner
1568     ) private {
1569         _tokenApprovals[tokenId] = to;
1570         emit Approval(owner, to, tokenId);
1571     }
1572 
1573     /**
1574      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1575      * The call is not executed if the target address is not a contract.
1576      *
1577      * @param from address representing the previous owner of the given token ID
1578      * @param to target address that will receive the tokens
1579      * @param tokenId uint256 ID of the token to be transferred
1580      * @param _data bytes optional data to send along with the call
1581      * @return bool whether the call correctly returned the expected magic value
1582      */
1583     function _checkOnERC721Received(
1584         address from,
1585         address to,
1586         uint256 tokenId,
1587         bytes memory _data
1588     ) private returns (bool) {
1589         if (to.isContract()) {
1590             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1591                 return retval == IERC721Receiver(to).onERC721Received.selector;
1592             } catch (bytes memory reason) {
1593                 if (reason.length == 0) {
1594                     revert TransferToNonERC721ReceiverImplementer();
1595                 } else {
1596                     assembly {
1597                         revert(add(32, reason), mload(reason))
1598                     }
1599                 }
1600             }
1601         } else {
1602             return true;
1603         }
1604     }
1605 
1606     /**
1607      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1608      * And also called before burning one token.
1609      *
1610      * startTokenId - the first token id to be transferred
1611      * quantity - the amount to be transferred
1612      *
1613      * Calling conditions:
1614      *
1615      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1616      * transferred to `to`.
1617      * - When `from` is zero, `tokenId` will be minted for `to`.
1618      * - When `to` is zero, `tokenId` will be burned by `from`.
1619      * - `from` and `to` are never both zero.
1620      */
1621     function _beforeTokenTransfers(
1622         address from,
1623         address to,
1624         uint256 startTokenId,
1625         uint256 quantity
1626     ) internal virtual {}
1627 
1628     /**
1629      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1630      * minting.
1631      * And also called after one token has been burned.
1632      *
1633      * startTokenId - the first token id to be transferred
1634      * quantity - the amount to be transferred
1635      *
1636      * Calling conditions:
1637      *
1638      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1639      * transferred to `to`.
1640      * - When `from` is zero, `tokenId` has been minted for `to`.
1641      * - When `to` is zero, `tokenId` has been burned by `from`.
1642      * - `from` and `to` are never both zero.
1643      */
1644     function _afterTokenTransfers(
1645         address from,
1646         address to,
1647         uint256 startTokenId,
1648         uint256 quantity
1649     ) internal virtual {}
1650 }
1651 
1652 
1653 /**
1654  * @dev These functions deal with verification of Merkle Trees proofs.
1655  *
1656  * The proofs can be generated using the JavaScript library
1657  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1658  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1659  *
1660  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1661  */
1662 
1663 // SPDX-License-Identifier: MIT
1664 // Creator: Tankies
1665 
1666 
1667 library Counters {
1668     struct Counter {
1669         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1670         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1671         // this feature: see https://github.com/ethereum/solidity/issues/4637
1672         uint256 _value; // default: 0
1673     }
1674 
1675     function current(Counter storage counter) internal view returns (uint256) {
1676         return counter._value;
1677     }
1678 
1679     function increment(Counter storage counter) internal {
1680         unchecked {
1681             counter._value += 1;
1682         }
1683     }
1684 
1685     function decrement(Counter storage counter) internal {
1686         uint256 value = counter._value;
1687         require(value > 0, "Counter: decrement overflow");
1688         unchecked {
1689             counter._value = value - 1;
1690         }
1691     }
1692 
1693     function reset(Counter storage counter) internal {
1694         counter._value = 0;
1695     }
1696 }
1697 
1698 contract TANKIES_EVOLVE is ERC721A, Ownable {
1699     using Counters for Counters.Counter;
1700     using Strings for uint256;
1701 
1702     Counters.Counter private _tokenIds;
1703     bool private _presaleActive = false;
1704     bool private _saleActive = false;
1705     bool private _saleForHolders = false;
1706     string public _prefixURI;
1707     string public _baseExtension;
1708     
1709     uint256 public  _price = 0;
1710     uint256 private  _maxPresaleMint = 1;
1711     uint256 private  _maxMint = 2;
1712                             
1713     uint256 private  _maxTokens = 1111;
1714   
1715     mapping (address => uint256) private _presaleMints;
1716     mapping (address => uint256) private _saleMints;
1717 
1718     address private constant communityWallet = 0xa5b80FEc68E8ffa3C7f3bDc21e019eBC4aAb8E73;
1719     //address constant tankiesV1 = 0xC5666DD4a435745B38c7a67cF5211a4D918E779F;
1720     address constant tankiesV1 = 0xC5666DD4a435745B38c7a67cF5211a4D918E779F;
1721 
1722     bytes32 private merkleRoot = 0x4a43387ab437e9fed4492137223387dbd6af36c5b7a00ee193527c04e1ef8697;
1723 
1724     constructor() ERC721A("TANKIES EVOLVE", "TANKIES EVOLVE") {}
1725 
1726     modifier callerIsUser() {
1727     require(tx.origin == msg.sender, "The caller is another contract");
1728     _;
1729   }
1730 
1731     modifier hasCorrectAmount(uint256 _wei, uint256 _quantity) {
1732         require(_wei >= _price * _quantity, "Insufficent funds");
1733         _;
1734     }
1735 
1736     modifier withinMaximumSupply(uint256 _quantity) {
1737         require(totalSupply() + _quantity <= _maxTokens, "Surpasses supply");
1738         _;
1739     }
1740 
1741     function airdrop(address[] memory addrs) public onlyOwner {
1742         for (uint256 i = 0; i < addrs.length; i++) {
1743             _tokenIds.increment();
1744            _mintItem(addrs[i], 1);
1745         }
1746     }
1747 
1748     function increaseTokenID(uint256 newID) public onlyOwner {
1749         uint256 currentID = _tokenIds.current();
1750         require(newID > currentID, "New ID must be greater than current ID");
1751         uint256 diff = newID - currentID;
1752         for(uint256 i = 1;i<diff;i++) {
1753             _tokenIds.increment();
1754         }
1755     }
1756 
1757     function _baseURI() internal view override returns (string memory) {
1758         return _prefixURI;
1759     }
1760 
1761     function setBaseURI(string memory _uri) public onlyOwner {
1762         _prefixURI = _uri;
1763     }
1764 
1765     function baseExtension() internal view returns (string memory) {
1766         return _baseExtension;
1767     }
1768 
1769     function setBaseExtension(string memory _ext) public onlyOwner {
1770         _baseExtension = _ext;
1771     }
1772 
1773      function setMerkleRoot(bytes32 _root) public onlyOwner {
1774         merkleRoot = _root;
1775     }
1776 
1777     function preSaleActive() public view returns (bool) {
1778         return _presaleActive;
1779     }
1780 
1781     function saleActive() public view returns (bool) {
1782         return _saleActive;
1783     }
1784 
1785     function saleForHolders() public view returns (bool) {
1786         return _saleForHolders;
1787     }
1788 
1789     function isHolder(address addr) public view returns (bool) {
1790         IERC721A token = IERC721A(tankiesV1);
1791         if(token.balanceOf(addr) >=1) {
1792             return true;
1793         } else {
1794             return false;
1795         }
1796     }
1797 
1798     function resetSaleMintsForAddrs(address[] memory addrs) public onlyOwner {
1799         for (uint256 i = 0; i < addrs.length; i++) {
1800             _saleMints[addrs[i]] = 0;
1801         }
1802     }
1803 
1804     function togglePreSale() public onlyOwner {
1805         _presaleActive = !_presaleActive;
1806     }
1807 
1808     function toggleSale() public onlyOwner {
1809         _saleActive = !_saleActive;
1810     }
1811 
1812     function toggleSaleForHolders() public onlyOwner {
1813         _saleForHolders = !_saleForHolders;
1814     }
1815    
1816     
1817      function updateMaxTokens(uint256 newMax) public onlyOwner {
1818         _maxTokens = newMax;
1819     }
1820 
1821     function updateMaxMint(uint256 newMax) public onlyOwner {
1822         _maxMint = newMax;
1823     }
1824 
1825     function updateMaxPresaleMint(uint256 newMax) public onlyOwner {
1826         _maxPresaleMint = newMax;
1827     }
1828 
1829     function updatePrice(uint256 newPrice) public onlyOwner {
1830         _price = newPrice;
1831     }
1832     
1833     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1834         require(_exists(tokenId),"ERC721AMetadata: URI query for nonexistent token");
1835         string memory currentBaseURI = _baseURI();
1836         tokenId.toString();
1837         return bytes(currentBaseURI).length > 0 ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), _baseExtension)) : "";
1838     }
1839 
1840     function mintForHolders(uint256 _quantity)
1841         public
1842         payable
1843         callerIsUser
1844     {
1845         require(
1846             _quantity > 0 &&
1847                 _saleMints[msg.sender] + _quantity <=
1848                 _maxMint,
1849             "Minting above public limit"
1850         );
1851         require(_saleForHolders);
1852         IERC721A token = IERC721A(tankiesV1);
1853         require(token.balanceOf(msg.sender) >= 1, "You don't own Tankie V1");
1854         uint256 totalMinted = _tokenIds.current();
1855         require(totalMinted + _quantity <= _maxTokens);
1856         require(_saleMints[msg.sender] + _quantity <= _maxMint);
1857         _saleMints[msg.sender] += _quantity;
1858         //_safeMint(msg.sender, _quantity);
1859         _mintItem(msg.sender, _quantity);
1860        
1861     }
1862 
1863 
1864      function mintItems(uint256 _quantity)
1865         public
1866         payable
1867         callerIsUser
1868     {
1869         require(
1870             _quantity > 0 &&
1871                 _saleMints[msg.sender] + _quantity <=
1872                 _maxMint,
1873             "Minting above public limit"
1874         );
1875         require(_saleActive);
1876         uint256 totalMinted = _tokenIds.current();
1877         require(totalMinted + _quantity <= _maxTokens);
1878         require(_saleMints[msg.sender] + _quantity <= _maxMint);
1879         _saleMints[msg.sender] += _quantity;
1880         //_safeMint(msg.sender, _quantity);
1881         _mintItem(msg.sender, _quantity);
1882        
1883     }
1884     
1885     function _mintItem(address to, uint256 _quantity) internal returns (uint256) {
1886         _tokenIds.increment();
1887         uint256 id = _tokenIds.current();
1888         _safeMint(to, _quantity);
1889         return id;
1890     }
1891 
1892     function withdraw() external onlyOwner {
1893         require(address(this).balance > 0);
1894         uint256 balance = address(this).balance;
1895         payable(address(0x8dc4A512A2b4B7948586BE58aAB877a877Fc4064)).transfer(balance * 285 / 1000);
1896         payable(address(0x25022Fe34893eA7A18f2D370A5fF96688350B906)).transfer(balance * 285 / 1000);
1897         payable(address(0x761aCE530C38Fb1B4A7f8e8826eb98a44c7d2075)).transfer(balance * 30 / 1000);
1898 
1899         payable(address(0x3639874A416ae2EDb1017198Ad7A97e35929C1B5)).transfer(balance * 133 / 1000);
1900         payable(address(0xbcB37767904eE41b0bDE505e767f786dA4bfD19a)).transfer(balance * 133 / 1000);
1901         payable(address(0x53D5c01D7529AD5dFc1a424fEC698fe7Ae9C4fb0)).transfer(balance * 133 / 1000);
1902         
1903     }
1904 
1905 }