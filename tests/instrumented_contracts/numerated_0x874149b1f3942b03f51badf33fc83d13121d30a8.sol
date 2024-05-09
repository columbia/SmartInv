1 // File: GG/IERC721A.sol
2 
3 
4 // ERC721A Contracts v4.1.0
5 // Creator: Chiru Labs
6 
7 pragma solidity ^0.8.4;
8 
9 /**
10  * @dev Interface of an ERC721A compliant contract.
11  */
12 interface IERC721A {
13     /**
14      * The caller must own the token or be an approved operator.
15      */
16     error ApprovalCallerNotOwnerNorApproved();
17 
18     /**
19      * The token does not exist.
20      */
21     error ApprovalQueryForNonexistentToken();
22 
23     /**
24      * The caller cannot approve to their own address.
25      */
26     error ApproveToCaller();
27 
28     /**
29      * Cannot query the balance for the zero address.
30      */
31     error BalanceQueryForZeroAddress();
32 
33     /**
34      * Cannot mint to the zero address.
35      */
36     error MintToZeroAddress();
37 
38     /**
39      * The quantity of tokens minted must be more than zero.
40      */
41     error MintZeroQuantity();
42 
43     /**
44      * The token does not exist.
45      */
46     error OwnerQueryForNonexistentToken();
47 
48     /**
49      * The caller must own the token or be an approved operator.
50      */
51     error TransferCallerNotOwnerNorApproved();
52 
53     /**
54      * The token must be owned by `from`.
55      */
56     error TransferFromIncorrectOwner();
57 
58     /**
59      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
60      */
61     error TransferToNonERC721ReceiverImplementer();
62 
63     /**
64      * Cannot transfer to the zero address.
65      */
66     error TransferToZeroAddress();
67 
68     /**
69      * The token does not exist.
70      */
71     error URIQueryForNonexistentToken();
72 
73     /**
74      * The `quantity` minted with ERC2309 exceeds the safety limit.
75      */
76     error MintERC2309QuantityExceedsLimit();
77 
78     /**
79      * The `extraData` cannot be set on an unintialized ownership slot.
80      */
81     error OwnershipNotInitializedForExtraData();
82 
83     struct TokenOwnership {
84         // The address of the owner.
85         address addr;
86         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
87         uint64 startTimestamp;
88         // Whether the token has been burned.
89         bool burned;
90         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
91         uint24 extraData;
92     }
93 
94     /**
95      * @dev Returns the total amount of tokens stored by the contract.
96      *
97      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
98      */
99     function totalSupply() external view returns (uint256);
100 
101     // ==============================
102     //            IERC165
103     // ==============================
104 
105     /**
106      * @dev Returns true if this contract implements the interface defined by
107      * `interfaceId`. See the corresponding
108      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
109      * to learn more about how these ids are created.
110      *
111      * This function call must use less than 30 000 gas.
112      */
113     function supportsInterface(bytes4 interfaceId) external view returns (bool);
114 
115     // ==============================
116     //            IERC721
117     // ==============================
118 
119     /**
120      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
121      */
122     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
123 
124     /**
125      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
126      */
127     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
128 
129     /**
130      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
131      */
132     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
133 
134     /**
135      * @dev Returns the number of tokens in ``owner``'s account.
136      */
137     function balanceOf(address owner) external view returns (uint256 balance);
138 
139     /**
140      * @dev Returns the owner of the `tokenId` token.
141      *
142      * Requirements:
143      *
144      * - `tokenId` must exist.
145      */
146     function ownerOf(uint256 tokenId) external view returns (address owner);
147 
148     /**
149      * @dev Safely transfers `tokenId` token from `from` to `to`.
150      *
151      * Requirements:
152      *
153      * - `from` cannot be the zero address.
154      * - `to` cannot be the zero address.
155      * - `tokenId` token must exist and be owned by `from`.
156      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
157      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
158      *
159      * Emits a {Transfer} event.
160      */
161     function safeTransferFrom(
162         address from,
163         address to,
164         uint256 tokenId,
165         bytes calldata data
166     ) external;
167 
168     /**
169      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
170      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
171      *
172      * Requirements:
173      *
174      * - `from` cannot be the zero address.
175      * - `to` cannot be the zero address.
176      * - `tokenId` token must exist and be owned by `from`.
177      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
178      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
179      *
180      * Emits a {Transfer} event.
181      */
182     function safeTransferFrom(
183         address from,
184         address to,
185         uint256 tokenId
186     ) external;
187 
188     /**
189      * @dev Transfers `tokenId` token from `from` to `to`.
190      *
191      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
192      *
193      * Requirements:
194      *
195      * - `from` cannot be the zero address.
196      * - `to` cannot be the zero address.
197      * - `tokenId` token must be owned by `from`.
198      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
199      *
200      * Emits a {Transfer} event.
201      */
202     function transferFrom(
203         address from,
204         address to,
205         uint256 tokenId
206     ) external;
207 
208     /**
209      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
210      * The approval is cleared when the token is transferred.
211      *
212      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
213      *
214      * Requirements:
215      *
216      * - The caller must own the token or be an approved operator.
217      * - `tokenId` must exist.
218      *
219      * Emits an {Approval} event.
220      */
221     function approve(address to, uint256 tokenId) external;
222 
223     /**
224      * @dev Approve or remove `operator` as an operator for the caller.
225      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
226      *
227      * Requirements:
228      *
229      * - The `operator` cannot be the caller.
230      *
231      * Emits an {ApprovalForAll} event.
232      */
233     function setApprovalForAll(address operator, bool _approved) external;
234 
235     /**
236      * @dev Returns the account approved for `tokenId` token.
237      *
238      * Requirements:
239      *
240      * - `tokenId` must exist.
241      */
242     function getApproved(uint256 tokenId) external view returns (address operator);
243 
244     /**
245      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
246      *
247      * See {setApprovalForAll}
248      */
249     function isApprovedForAll(address owner, address operator) external view returns (bool);
250 
251     // ==============================
252     //        IERC721Metadata
253     // ==============================
254 
255     /**
256      * @dev Returns the token collection name.
257      */
258     function name() external view returns (string memory);
259 
260     /**
261      * @dev Returns the token collection symbol.
262      */
263     function symbol() external view returns (string memory);
264 
265     /**
266      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
267      */
268     function tokenURI(uint256 tokenId) external view returns (string memory);
269 
270     // ==============================
271     //            IERC2309
272     // ==============================
273 
274     /**
275      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
276      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
277      */
278     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
279 }
280 // File: @openzeppelin/contracts/utils/Strings.sol
281 
282 
283 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
284 
285 pragma solidity ^0.8.0;
286 
287 /**
288  * @dev String operations.
289  */
290 library Strings {
291     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
292 
293     /**
294      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
295      */
296     function toString(uint256 value) internal pure returns (string memory) {
297         // Inspired by OraclizeAPI's implementation - MIT licence
298         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
299 
300         if (value == 0) {
301             return "0";
302         }
303         uint256 temp = value;
304         uint256 digits;
305         while (temp != 0) {
306             digits++;
307             temp /= 10;
308         }
309         bytes memory buffer = new bytes(digits);
310         while (value != 0) {
311             digits -= 1;
312             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
313             value /= 10;
314         }
315         return string(buffer);
316     }
317 
318     /**
319      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
320      */
321     function toHexString(uint256 value) internal pure returns (string memory) {
322         if (value == 0) {
323             return "0x00";
324         }
325         uint256 temp = value;
326         uint256 length = 0;
327         while (temp != 0) {
328             length++;
329             temp >>= 8;
330         }
331         return toHexString(value, length);
332     }
333 
334     /**
335      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
336      */
337     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
338         bytes memory buffer = new bytes(2 * length + 2);
339         buffer[0] = "0";
340         buffer[1] = "x";
341         for (uint256 i = 2 * length + 1; i > 1; --i) {
342             buffer[i] = _HEX_SYMBOLS[value & 0xf];
343             value >>= 4;
344         }
345         require(value == 0, "Strings: hex length insufficient");
346         return string(buffer);
347     }
348 }
349 
350 // File: @openzeppelin/contracts/utils/Address.sol
351 
352 
353 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
354 
355 pragma solidity ^0.8.1;
356 
357 /**
358  * @dev Collection of functions related to the address type
359  */
360 library Address {
361     /**
362      * @dev Returns true if `account` is a contract.
363      *
364      * [IMPORTANT]
365      * ====
366      * It is unsafe to assume that an address for which this function returns
367      * false is an externally-owned account (EOA) and not a contract.
368      *
369      * Among others, `isContract` will return false for the following
370      * types of addresses:
371      *
372      *  - an externally-owned account
373      *  - a contract in construction
374      *  - an address where a contract will be created
375      *  - an address where a contract lived, but was destroyed
376      * ====
377      *
378      * [IMPORTANT]
379      * ====
380      * You shouldn't rely on `isContract` to protect against flash loan attacks!
381      *
382      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
383      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
384      * constructor.
385      * ====
386      */
387     function isContract(address account) internal view returns (bool) {
388         // This method relies on extcodesize/address.code.length, which returns 0
389         // for contracts in construction, since the code is only stored at the end
390         // of the constructor execution.
391 
392         return account.code.length > 0;
393     }
394 
395     /**
396      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
397      * `recipient`, forwarding all available gas and reverting on errors.
398      *
399      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
400      * of certain opcodes, possibly making contracts go over the 2300 gas limit
401      * imposed by `transfer`, making them unable to receive funds via
402      * `transfer`. {sendValue} removes this limitation.
403      *
404      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
405      *
406      * IMPORTANT: because control is transferred to `recipient`, care must be
407      * taken to not create reentrancy vulnerabilities. Consider using
408      * {ReentrancyGuard} or the
409      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
410      */
411     function sendValue(address payable recipient, uint256 amount) internal {
412         require(address(this).balance >= amount, "Address: insufficient balance");
413 
414         (bool success, ) = recipient.call{value: amount}("");
415         require(success, "Address: unable to send value, recipient may have reverted");
416     }
417 
418     /**
419      * @dev Performs a Solidity function call using a low level `call`. A
420      * plain `call` is an unsafe replacement for a function call: use this
421      * function instead.
422      *
423      * If `target` reverts with a revert reason, it is bubbled up by this
424      * function (like regular Solidity function calls).
425      *
426      * Returns the raw returned data. To convert to the expected return value,
427      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
428      *
429      * Requirements:
430      *
431      * - `target` must be a contract.
432      * - calling `target` with `data` must not revert.
433      *
434      * _Available since v3.1._
435      */
436     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
437         return functionCall(target, data, "Address: low-level call failed");
438     }
439 
440     /**
441      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
442      * `errorMessage` as a fallback revert reason when `target` reverts.
443      *
444      * _Available since v3.1._
445      */
446     function functionCall(
447         address target,
448         bytes memory data,
449         string memory errorMessage
450     ) internal returns (bytes memory) {
451         return functionCallWithValue(target, data, 0, errorMessage);
452     }
453 
454     /**
455      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
456      * but also transferring `value` wei to `target`.
457      *
458      * Requirements:
459      *
460      * - the calling contract must have an ETH balance of at least `value`.
461      * - the called Solidity function must be `payable`.
462      *
463      * _Available since v3.1._
464      */
465     function functionCallWithValue(
466         address target,
467         bytes memory data,
468         uint256 value
469     ) internal returns (bytes memory) {
470         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
471     }
472 
473     /**
474      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
475      * with `errorMessage` as a fallback revert reason when `target` reverts.
476      *
477      * _Available since v3.1._
478      */
479     function functionCallWithValue(
480         address target,
481         bytes memory data,
482         uint256 value,
483         string memory errorMessage
484     ) internal returns (bytes memory) {
485         require(address(this).balance >= value, "Address: insufficient balance for call");
486         require(isContract(target), "Address: call to non-contract");
487 
488         (bool success, bytes memory returndata) = target.call{value: value}(data);
489         return verifyCallResult(success, returndata, errorMessage);
490     }
491 
492     /**
493      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
494      * but performing a static call.
495      *
496      * _Available since v3.3._
497      */
498     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
499         return functionStaticCall(target, data, "Address: low-level static call failed");
500     }
501 
502     /**
503      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
504      * but performing a static call.
505      *
506      * _Available since v3.3._
507      */
508     function functionStaticCall(
509         address target,
510         bytes memory data,
511         string memory errorMessage
512     ) internal view returns (bytes memory) {
513         require(isContract(target), "Address: static call to non-contract");
514 
515         (bool success, bytes memory returndata) = target.staticcall(data);
516         return verifyCallResult(success, returndata, errorMessage);
517     }
518 
519     /**
520      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
521      * but performing a delegate call.
522      *
523      * _Available since v3.4._
524      */
525     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
526         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
527     }
528 
529     /**
530      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
531      * but performing a delegate call.
532      *
533      * _Available since v3.4._
534      */
535     function functionDelegateCall(
536         address target,
537         bytes memory data,
538         string memory errorMessage
539     ) internal returns (bytes memory) {
540         require(isContract(target), "Address: delegate call to non-contract");
541 
542         (bool success, bytes memory returndata) = target.delegatecall(data);
543         return verifyCallResult(success, returndata, errorMessage);
544     }
545 
546     /**
547      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
548      * revert reason using the provided one.
549      *
550      * _Available since v4.3._
551      */
552     function verifyCallResult(
553         bool success,
554         bytes memory returndata,
555         string memory errorMessage
556     ) internal pure returns (bytes memory) {
557         if (success) {
558             return returndata;
559         } else {
560             // Look for revert reason and bubble it up if present
561             if (returndata.length > 0) {
562                 // The easiest way to bubble the revert reason is using memory via assembly
563 
564                 assembly {
565                     let returndata_size := mload(returndata)
566                     revert(add(32, returndata), returndata_size)
567                 }
568             } else {
569                 revert(errorMessage);
570             }
571         }
572     }
573 }
574 
575 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
576 
577 
578 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
579 
580 pragma solidity ^0.8.0;
581 
582 /**
583  * @title ERC721 token receiver interface
584  * @dev Interface for any contract that wants to support safeTransfers
585  * from ERC721 asset contracts.
586  */
587 interface IERC721Receiver {
588     /**
589      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
590      * by `operator` from `from`, this function is called.
591      *
592      * It must return its Solidity selector to confirm the token transfer.
593      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
594      *
595      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
596      */
597     function onERC721Received(
598         address operator,
599         address from,
600         uint256 tokenId,
601         bytes calldata data
602     ) external returns (bytes4);
603 }
604 
605 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
606 
607 
608 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
609 
610 pragma solidity ^0.8.0;
611 
612 /**
613  * @dev Interface of the ERC165 standard, as defined in the
614  * https://eips.ethereum.org/EIPS/eip-165[EIP].
615  *
616  * Implementers can declare support of contract interfaces, which can then be
617  * queried by others ({ERC165Checker}).
618  *
619  * For an implementation, see {ERC165}.
620  */
621 interface IERC165 {
622     /**
623      * @dev Returns true if this contract implements the interface defined by
624      * `interfaceId`. See the corresponding
625      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
626      * to learn more about how these ids are created.
627      *
628      * This function call must use less than 30 000 gas.
629      */
630     function supportsInterface(bytes4 interfaceId) external view returns (bool);
631 }
632 
633 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
634 
635 
636 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
637 
638 pragma solidity ^0.8.0;
639 
640 
641 /**
642  * @dev Implementation of the {IERC165} interface.
643  *
644  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
645  * for the additional interface id that will be supported. For example:
646  *
647  * ```solidity
648  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
649  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
650  * }
651  * ```
652  *
653  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
654  */
655 abstract contract ERC165 is IERC165 {
656     /**
657      * @dev See {IERC165-supportsInterface}.
658      */
659     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
660         return interfaceId == type(IERC165).interfaceId;
661     }
662 }
663 
664 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
665 
666 
667 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
668 
669 pragma solidity ^0.8.0;
670 
671 
672 /**
673  * @dev Required interface of an ERC721 compliant contract.
674  */
675 interface IERC721 is IERC165 {
676     /**
677      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
678      */
679     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
680 
681     /**
682      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
683      */
684     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
685 
686     /**
687      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
688      */
689     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
690 
691     /**
692      * @dev Returns the number of tokens in ``owner``'s account.
693      */
694     function balanceOf(address owner) external view returns (uint256 balance);
695 
696     /**
697      * @dev Returns the owner of the `tokenId` token.
698      *
699      * Requirements:
700      *
701      * - `tokenId` must exist.
702      */
703     function ownerOf(uint256 tokenId) external view returns (address owner);
704 
705     /**
706      * @dev Safely transfers `tokenId` token from `from` to `to`.
707      *
708      * Requirements:
709      *
710      * - `from` cannot be the zero address.
711      * - `to` cannot be the zero address.
712      * - `tokenId` token must exist and be owned by `from`.
713      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
714      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
715      *
716      * Emits a {Transfer} event.
717      */
718     function safeTransferFrom(
719         address from,
720         address to,
721         uint256 tokenId,
722         bytes calldata data
723     ) external;
724 
725     /**
726      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
727      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
728      *
729      * Requirements:
730      *
731      * - `from` cannot be the zero address.
732      * - `to` cannot be the zero address.
733      * - `tokenId` token must exist and be owned by `from`.
734      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
735      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
736      *
737      * Emits a {Transfer} event.
738      */
739     function safeTransferFrom(
740         address from,
741         address to,
742         uint256 tokenId
743     ) external;
744 
745     /**
746      * @dev Transfers `tokenId` token from `from` to `to`.
747      *
748      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
749      *
750      * Requirements:
751      *
752      * - `from` cannot be the zero address.
753      * - `to` cannot be the zero address.
754      * - `tokenId` token must be owned by `from`.
755      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
756      *
757      * Emits a {Transfer} event.
758      */
759     function transferFrom(
760         address from,
761         address to,
762         uint256 tokenId
763     ) external;
764 
765     /**
766      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
767      * The approval is cleared when the token is transferred.
768      *
769      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
770      *
771      * Requirements:
772      *
773      * - The caller must own the token or be an approved operator.
774      * - `tokenId` must exist.
775      *
776      * Emits an {Approval} event.
777      */
778     function approve(address to, uint256 tokenId) external;
779 
780     /**
781      * @dev Approve or remove `operator` as an operator for the caller.
782      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
783      *
784      * Requirements:
785      *
786      * - The `operator` cannot be the caller.
787      *
788      * Emits an {ApprovalForAll} event.
789      */
790     function setApprovalForAll(address operator, bool _approved) external;
791 
792     /**
793      * @dev Returns the account approved for `tokenId` token.
794      *
795      * Requirements:
796      *
797      * - `tokenId` must exist.
798      */
799     function getApproved(uint256 tokenId) external view returns (address operator);
800 
801     /**
802      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
803      *
804      * See {setApprovalForAll}
805      */
806     function isApprovedForAll(address owner, address operator) external view returns (bool);
807 }
808 
809 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
810 
811 
812 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
813 
814 pragma solidity ^0.8.0;
815 
816 
817 /**
818  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
819  * @dev See https://eips.ethereum.org/EIPS/eip-721
820  */
821 interface IERC721Enumerable is IERC721 {
822     /**
823      * @dev Returns the total amount of tokens stored by the contract.
824      */
825     function totalSupply() external view returns (uint256);
826 
827     /**
828      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
829      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
830      */
831     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
832 
833     /**
834      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
835      * Use along with {totalSupply} to enumerate all tokens.
836      */
837     function tokenByIndex(uint256 index) external view returns (uint256);
838 }
839 
840 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
841 
842 
843 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
844 
845 pragma solidity ^0.8.0;
846 
847 
848 /**
849  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
850  * @dev See https://eips.ethereum.org/EIPS/eip-721
851  */
852 interface IERC721Metadata is IERC721 {
853     /**
854      * @dev Returns the token collection name.
855      */
856     function name() external view returns (string memory);
857 
858     /**
859      * @dev Returns the token collection symbol.
860      */
861     function symbol() external view returns (string memory);
862 
863     /**
864      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
865      */
866     function tokenURI(uint256 tokenId) external view returns (string memory);
867 }
868 
869 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
870 
871 
872 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
873 
874 pragma solidity ^0.8.0;
875 
876 /**
877  * @dev Contract module that helps prevent reentrant calls to a function.
878  *
879  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
880  * available, which can be applied to functions to make sure there are no nested
881  * (reentrant) calls to them.
882  *
883  * Note that because there is a single `nonReentrant` guard, functions marked as
884  * `nonReentrant` may not call one another. This can be worked around by making
885  * those functions `private`, and then adding `external` `nonReentrant` entry
886  * points to them.
887  *
888  * TIP: If you would like to learn more about reentrancy and alternative ways
889  * to protect against it, check out our blog post
890  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
891  */
892 abstract contract ReentrancyGuard {
893     // Booleans are more expensive than uint256 or any type that takes up a full
894     // word because each write operation emits an extra SLOAD to first read the
895     // slot's contents, replace the bits taken up by the boolean, and then write
896     // back. This is the compiler's defense against contract upgrades and
897     // pointer aliasing, and it cannot be disabled.
898 
899     // The values being non-zero value makes deployment a bit more expensive,
900     // but in exchange the refund on every call to nonReentrant will be lower in
901     // amount. Since refunds are capped to a percentage of the total
902     // transaction's gas, it is best to keep them low in cases like this one, to
903     // increase the likelihood of the full refund coming into effect.
904     uint256 private constant _NOT_ENTERED = 1;
905     uint256 private constant _ENTERED = 2;
906 
907     uint256 private _status;
908 
909     constructor() {
910         _status = _NOT_ENTERED;
911     }
912 
913     /**
914      * @dev Prevents a contract from calling itself, directly or indirectly.
915      * Calling a `nonReentrant` function from another `nonReentrant`
916      * function is not supported. It is possible to prevent this from happening
917      * by making the `nonReentrant` function external, and making it call a
918      * `private` function that does the actual work.
919      */
920     modifier nonReentrant() {
921         // On the first call to nonReentrant, _notEntered will be true
922         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
923 
924         // Any calls to nonReentrant after this point will fail
925         _status = _ENTERED;
926 
927         _;
928 
929         // By storing the original value once again, a refund is triggered (see
930         // https://eips.ethereum.org/EIPS/eip-2200)
931         _status = _NOT_ENTERED;
932     }
933 }
934 
935 // File: @openzeppelin/contracts/utils/Context.sol
936 
937 
938 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
939 
940 pragma solidity ^0.8.0;
941 
942 /**
943  * @dev Provides information about the current execution context, including the
944  * sender of the transaction and its data. While these are generally available
945  * via msg.sender and msg.data, they should not be accessed in such a direct
946  * manner, since when dealing with meta-transactions the account sending and
947  * paying for execution may not be the actual sender (as far as an application
948  * is concerned).
949  *
950  * This contract is only required for intermediate, library-like contracts.
951  */
952 abstract contract Context {
953     function _msgSender() internal view virtual returns (address) {
954         return msg.sender;
955     }
956 
957     function _msgData() internal view virtual returns (bytes calldata) {
958         return msg.data;
959     }
960 }
961 
962 // File: GG/ERC721A.sol
963 
964 
965 
966 pragma solidity ^0.8.0;
967 
968 
969 
970 
971 
972 
973 
974 
975 
976 /**
977  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
978  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
979  *
980  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
981  *
982  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
983  *
984  * Does not support burning tokens to address(0).
985  */
986 contract ERC721A is
987   Context,
988   ERC165,
989   IERC721,
990   IERC721Metadata,
991   IERC721Enumerable
992 {
993   using Address for address;
994   using Strings for uint256;
995 
996   struct TokenOwnership {
997     address addr;
998     uint64 startTimestamp;
999   }
1000 
1001   uint256 private currentIndex = 1;
1002 
1003   uint256 internal immutable collectionSize;
1004   uint256 internal immutable maxBatchSize;
1005 
1006   // Token name
1007   string private _name;
1008 
1009   // Token symbol
1010   string private _symbol;
1011 
1012   // Mapping from token ID to ownership details
1013   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1014   mapping(uint256 => TokenOwnership) private _ownerships;
1015 
1016   // Mapping owner address to address data
1017   mapping(address => uint128) private _balance;
1018 
1019   // Mapping from token ID to approved address
1020   mapping(uint256 => address) private _tokenApprovals;
1021 
1022   // Mapping from owner to operator approvals
1023   mapping(address => mapping(address => bool)) private _operatorApprovals;
1024 
1025   /**
1026    * @dev
1027    * `maxBatchSize` refers to how much a minter can mint at a time.
1028    * `collectionSize_` refers to how many tokens are in the collection.
1029    */
1030   constructor(
1031     string memory name_,
1032     string memory symbol_,
1033     uint256 maxBatchSize_,
1034     uint256 collectionSize_
1035   ) {
1036     require(
1037       collectionSize_ > 0,
1038       "ERC721A: collection must have a nonzero supply"
1039     );
1040     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1041     _name = name_;
1042     _symbol = symbol_;
1043     maxBatchSize = maxBatchSize_;
1044     collectionSize = collectionSize_;
1045   }
1046 
1047   /**
1048    * @dev See {IERC721Enumerable-totalSupply}.
1049    */
1050   function totalSupply() public view override returns (uint256) {
1051     return currentIndex-1;
1052   }
1053 
1054   /**
1055    * @dev See {IERC721Enumerable-tokenByIndex}.
1056    */
1057   function tokenByIndex(uint256 index) public view override returns (uint256) {
1058     require(index < totalSupply(), "ERC721A: global index out of bounds");
1059     return index;
1060   }
1061 
1062   /**
1063    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1064    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1065    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1066    */
1067   function tokenOfOwnerByIndex(address owner, uint256 index)
1068     public
1069     view
1070     override
1071     returns (uint256)
1072   {
1073     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1074     uint256 numMintedSoFar = totalSupply();
1075     uint256 tokenIdsIdx = 0;
1076     address currOwnershipAddr = address(0);
1077     for (uint256 i = 0; i < numMintedSoFar; i++) {
1078       TokenOwnership memory ownership = _ownerships[i];
1079       if (ownership.addr != address(0)) {
1080         currOwnershipAddr = ownership.addr;
1081       }
1082       if (currOwnershipAddr == owner) {
1083         if (tokenIdsIdx == index) {
1084           return i;
1085         }
1086         tokenIdsIdx++;
1087       }
1088     }
1089     revert("ERC721A: unable to get token of owner by index");
1090   }
1091 
1092   /**
1093    * @dev See {IERC165-supportsInterface}.
1094    */
1095   function supportsInterface(bytes4 interfaceId)
1096     public
1097     view
1098     virtual
1099     override(ERC165, IERC165)
1100     returns (bool)
1101   {
1102     return
1103       interfaceId == type(IERC721).interfaceId ||
1104       interfaceId == type(IERC721Metadata).interfaceId ||
1105       interfaceId == type(IERC721Enumerable).interfaceId ||
1106       super.supportsInterface(interfaceId);
1107   }
1108 
1109   /**
1110    * @dev See {IERC721-balanceOf}.
1111    */
1112   function balanceOf(address owner) public view override returns (uint256) {
1113     require(owner != address(0), "ERC721A: balance query for the zero address");
1114     return uint256(_balance[owner]);
1115   }
1116 
1117   function ownershipOf(uint256 tokenId)
1118     internal
1119     view
1120     returns (TokenOwnership memory)
1121   {
1122     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1123 
1124     uint256 lowestTokenToCheck;
1125     if (tokenId >= maxBatchSize) {
1126       lowestTokenToCheck = tokenId - maxBatchSize + 1;
1127     }
1128 
1129     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
1130       TokenOwnership memory ownership = _ownerships[curr];
1131       if (ownership.addr != address(0)) {
1132         return ownership;
1133       }
1134     }
1135 
1136     revert("ERC721A: unable to determine the owner of token");
1137   }
1138 
1139   /**
1140    * @dev See {IERC721-ownerOf}.
1141    */
1142   function ownerOf(uint256 tokenId) public view override returns (address) {
1143     return ownershipOf(tokenId).addr;
1144   }
1145 
1146   /**
1147    * @dev See {IERC721Metadata-name}.
1148    */
1149   function name() public view virtual override returns (string memory) {
1150     return _name;
1151   }
1152 
1153   /**
1154    * @dev See {IERC721Metadata-symbol}.
1155    */
1156   function symbol() public view virtual override returns (string memory) {
1157     return _symbol;
1158   }
1159 
1160   /**
1161    * @dev See {IERC721Metadata-tokenURI}.
1162    */
1163   function tokenURI(uint256 tokenId)
1164     public
1165     view
1166     virtual
1167     override
1168     returns (string memory)
1169   {
1170     require(
1171       _exists(tokenId),
1172       "ERC721Metadata: URI query for nonexistent token"
1173     );
1174 
1175     string memory baseURI = _baseURI();
1176     return
1177       bytes(baseURI).length > 0
1178         ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json"))
1179         : "";
1180   }
1181 
1182   /**
1183    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1184    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1185    * by default, can be overriden in child contracts.
1186    */
1187   function _baseURI() internal view virtual returns (string memory) {
1188     return "";
1189   }
1190 
1191   /**
1192    * @dev See {IERC721-approve}.
1193    */
1194   function approve(address to, uint256 tokenId) public override {
1195     address owner = ERC721A.ownerOf(tokenId);
1196     require(to != owner, "ERC721A: approval to current owner");
1197 
1198     require(
1199       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1200       "ERC721A: approve caller is not owner nor approved for all"
1201     );
1202 
1203     _approve(to, tokenId, owner);
1204   }
1205 
1206   /**
1207    * @dev See {IERC721-getApproved}.
1208    */
1209   function getApproved(uint256 tokenId) public view override returns (address) {
1210     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1211 
1212     return _tokenApprovals[tokenId];
1213   }
1214 
1215   /**
1216    * @dev See {IERC721-setApprovalForAll}.
1217    */
1218   function setApprovalForAll(address operator, bool approved) public override {
1219     require(operator != _msgSender(), "ERC721A: approve to caller");
1220 
1221     _operatorApprovals[_msgSender()][operator] = approved;
1222     emit ApprovalForAll(_msgSender(), operator, approved);
1223   }
1224 
1225   /**
1226    * @dev See {IERC721-isApprovedForAll}.
1227    */
1228   function isApprovedForAll(address owner, address operator)
1229     public
1230     view
1231     virtual
1232     override
1233     returns (bool)
1234   {
1235     return _operatorApprovals[owner][operator];
1236   }
1237 
1238   /**
1239    * @dev See {IERC721-transferFrom}.
1240    */
1241   function transferFrom(
1242     address from,
1243     address to,
1244     uint256 tokenId
1245   ) public override {
1246     _transfer(from, to, tokenId);
1247   }
1248 
1249   /**
1250    * @dev See {IERC721-safeTransferFrom}.
1251    */
1252   function safeTransferFrom(
1253     address from,
1254     address to,
1255     uint256 tokenId
1256   ) public override {
1257     safeTransferFrom(from, to, tokenId, "");
1258   }
1259 
1260   /**
1261    * @dev See {IERC721-safeTransferFrom}.
1262    */
1263   function safeTransferFrom(
1264     address from,
1265     address to,
1266     uint256 tokenId,
1267     bytes memory _data
1268   ) public override {
1269     _transfer(from, to, tokenId);
1270     require(
1271       _checkOnERC721Received(from, to, tokenId, _data),
1272       "ERC721A: transfer to non ERC721Receiver implementer"
1273     );
1274   }
1275 
1276   /**
1277    * @dev Returns whether `tokenId` exists.
1278    *
1279    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1280    *
1281    * Tokens start existing when they are minted (`_mint`),
1282    */
1283   function _exists(uint256 tokenId) internal view returns (bool) {
1284     return tokenId < currentIndex;
1285   }
1286 
1287   function _safeMint(address to, uint256 quantity) internal {
1288     _safeMint(to, quantity, "");
1289   }
1290 
1291   /**
1292    * @dev Mints `quantity` tokens and transfers them to `to`.
1293    *
1294    * Requirements:
1295    *
1296    * - there must be `quantity` tokens remaining unminted in the total collection.
1297    * - `to` cannot be the zero address.
1298    * - `quantity` cannot be larger than the max batch size.
1299    *
1300    * Emits a {Transfer} event.
1301    */
1302   function _safeMint(
1303     address to,
1304     uint256 quantity,
1305     bytes memory _data
1306   ) internal {
1307     uint256 startTokenId = currentIndex;
1308     require(to != address(0), "ERC721A: mint to the zero address");
1309     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1310     require(!_exists(startTokenId), "ERC721A: token already minted");
1311     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1312 
1313     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1314 
1315     _balance[to] += uint128(quantity);
1316     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1317 
1318     uint256 updatedIndex = startTokenId;
1319 
1320     for (uint256 i = 0; i < quantity; i++) {
1321       emit Transfer(address(0), to, updatedIndex);
1322       require(
1323         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1324         "ERC721A: transfer to non ERC721Receiver implementer"
1325       );
1326       updatedIndex++;
1327     }
1328 
1329     currentIndex = updatedIndex;
1330     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1331   }
1332 
1333   /**
1334    * @dev Transfers `tokenId` from `from` to `to`.
1335    *
1336    * Requirements:
1337    *
1338    * - `to` cannot be the zero address.
1339    * - `tokenId` token must be owned by `from`.
1340    *
1341    * Emits a {Transfer} event.
1342    */
1343   function _transfer(
1344     address from,
1345     address to,
1346     uint256 tokenId
1347   ) private {
1348     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1349 
1350     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1351       getApproved(tokenId) == _msgSender() ||
1352       isApprovedForAll(prevOwnership.addr, _msgSender()));
1353 
1354     require(
1355       isApprovedOrOwner,
1356       "ERC721A: transfer caller is not owner nor approved"
1357     );
1358 
1359     require(
1360       prevOwnership.addr == from,
1361       "ERC721A: transfer from incorrect owner"
1362     );
1363     require(to != address(0), "ERC721A: transfer to the zero address");
1364 
1365     _beforeTokenTransfers(from, to, tokenId, 1);
1366 
1367     // Clear approvals from the previous owner
1368     _approve(address(0), tokenId, prevOwnership.addr);
1369 
1370     _balance[from] -= 1;
1371     _balance[to] += 1;
1372     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1373 
1374     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1375     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1376     uint256 nextTokenId = tokenId + 1;
1377     if (_ownerships[nextTokenId].addr == address(0)) {
1378       if (_exists(nextTokenId)) {
1379         _ownerships[nextTokenId] = TokenOwnership(
1380           prevOwnership.addr,
1381           prevOwnership.startTimestamp
1382         );
1383       }
1384     }
1385 
1386     emit Transfer(from, to, tokenId);
1387     _afterTokenTransfers(from, to, tokenId, 1);
1388   }
1389 
1390   /**
1391    * @dev Approve `to` to operate on `tokenId`
1392    *
1393    * Emits a {Approval} event.
1394    */
1395   function _approve(
1396     address to,
1397     uint256 tokenId,
1398     address owner
1399   ) private {
1400     _tokenApprovals[tokenId] = to;
1401     emit Approval(owner, to, tokenId);
1402   }
1403 
1404   uint256 public nextOwnerToExplicitlySet = 0;
1405 
1406   /**
1407    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1408    */
1409   function _setOwnersExplicit(uint256 quantity) internal {
1410     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1411     require(quantity > 0, "quantity must be nonzero");
1412     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1413     if (endIndex > collectionSize - 1) {
1414       endIndex = collectionSize - 1;
1415     }
1416     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1417     require(_exists(endIndex), "not enough minted yet for this cleanup");
1418     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1419       if (_ownerships[i].addr == address(0)) {
1420         TokenOwnership memory ownership = ownershipOf(i);
1421         _ownerships[i] = TokenOwnership(
1422           ownership.addr,
1423           ownership.startTimestamp
1424         );
1425       }
1426     }
1427     nextOwnerToExplicitlySet = endIndex + 1;
1428   }
1429 
1430   /**
1431    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1432    * The call is not executed if the target address is not a contract.
1433    *
1434    * @param from address representing the previous owner of the given token ID
1435    * @param to target address that will receive the tokens
1436    * @param tokenId uint256 ID of the token to be transferred
1437    * @param _data bytes optional data to send along with the call
1438    * @return bool whether the call correctly returned the expected magic value
1439    */
1440   function _checkOnERC721Received(
1441     address from,
1442     address to,
1443     uint256 tokenId,
1444     bytes memory _data
1445   ) private returns (bool) {
1446     if (to.isContract()) {
1447       try
1448         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1449       returns (bytes4 retval) {
1450         return retval == IERC721Receiver(to).onERC721Received.selector;
1451       } catch (bytes memory reason) {
1452         if (reason.length == 0) {
1453           revert("ERC721A: transfer to non ERC721Receiver implementer");
1454         } else {
1455           assembly {
1456             revert(add(32, reason), mload(reason))
1457           }
1458         }
1459       }
1460     } else {
1461       return true;
1462     }
1463   }
1464 
1465   /**
1466    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1467    *
1468    * startTokenId - the first token id to be transferred
1469    * quantity - the amount to be transferred
1470    *
1471    * Calling conditions:
1472    *
1473    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1474    * transferred to `to`.
1475    * - When `from` is zero, `tokenId` will be minted for `to`.
1476    */
1477   function _beforeTokenTransfers(
1478     address from,
1479     address to,
1480     uint256 startTokenId,
1481     uint256 quantity
1482   ) internal virtual {}
1483 
1484   /**
1485    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1486    * minting.
1487    *
1488    * startTokenId - the first token id to be transferred
1489    * quantity - the amount to be transferred
1490    *
1491    * Calling conditions:
1492    *
1493    * - when `from` and `to` are both non-zero.
1494    * - `from` and `to` are never both zero.
1495    */
1496   function _afterTokenTransfers(
1497     address from,
1498     address to,
1499     uint256 startTokenId,
1500     uint256 quantity
1501   ) internal virtual {}
1502 }
1503 // File: @openzeppelin/contracts/access/Ownable.sol
1504 
1505 
1506 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1507 
1508 pragma solidity ^0.8.0;
1509 
1510 
1511 /**
1512  * @dev Contract module which provides a basic access control mechanism, where
1513  * there is an account (an owner) that can be granted exclusive access to
1514  * specific functions.
1515  *
1516  * By default, the owner account will be the one that deploys the contract. This
1517  * can later be changed with {transferOwnership}.
1518  *
1519  * This module is used through inheritance. It will make available the modifier
1520  * `onlyOwner`, which can be applied to your functions to restrict their use to
1521  * the owner.
1522  */
1523 abstract contract Ownable is Context {
1524     address private _owner;
1525 
1526     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1527 
1528     /**
1529      * @dev Initializes the contract setting the deployer as the initial owner.
1530      */
1531     constructor() {
1532         _transferOwnership(_msgSender());
1533     }
1534 
1535     /**
1536      * @dev Returns the address of the current owner.
1537      */
1538     function owner() public view virtual returns (address) {
1539         return _owner;
1540     }
1541 
1542     /**
1543      * @dev Throws if called by any account other than the owner.
1544      */
1545     modifier onlyOwner() {
1546         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1547         _;
1548     }
1549 
1550     /**
1551      * @dev Leaves the contract without owner. It will not be possible to call
1552      * `onlyOwner` functions anymore. Can only be called by the current owner.
1553      *
1554      * NOTE: Renouncing ownership will leave the contract without an owner,
1555      * thereby removing any functionality that is only available to the owner.
1556      */
1557     function renounceOwnership() public virtual onlyOwner {
1558         _transferOwnership(address(0));
1559     }
1560 
1561     /**
1562      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1563      * Can only be called by the current owner.
1564      */
1565     function transferOwnership(address newOwner) public virtual onlyOwner {
1566         require(newOwner != address(0), "Ownable: new owner is the zero address");
1567         _transferOwnership(newOwner);
1568     }
1569 
1570     /**
1571      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1572      * Internal function without access restriction.
1573      */
1574     function _transferOwnership(address newOwner) internal virtual {
1575         address oldOwner = _owner;
1576         _owner = newOwner;
1577         emit OwnershipTransferred(oldOwner, newOwner);
1578     }
1579 }
1580 
1581 // File: GG/GoblinGirls.sol
1582 
1583 
1584 
1585 pragma solidity ^0.8.0;
1586 
1587 
1588 
1589 
1590 
1591 
1592 contract GG is Ownable, ERC721A, ReentrancyGuard {
1593     string _baseUri = "ipfs://Qmd4pK5w6jZmNmKwbXjBfud7Lm7zvckm8AcGanFGJHL5gM/";
1594     mapping(address => bool) whitelisted;
1595     mapping(address => uint256) public purchased;
1596     uint256 maxFree;
1597 
1598     uint256 public tokenPrice;
1599     bool public hasSaleStarted = false;
1600 
1601     IERC721A public goblinTown = IERC721A(0xbCe3781ae7Ca1a5e050Bd9C4c77369867eBc307e);
1602 
1603     constructor() ERC721A("Goblin Girls", "GG", 30, 10000) {
1604         maxFree = 2;
1605         tokenPrice = 0.01 ether;
1606     }
1607 
1608     function reserve(address[] calldata to, uint256[] calldata quantity) external onlyOwner {
1609         for(uint256 i=0;i<to.length;i++) {
1610             require(quantity[i] + totalSupply() <= collectionSize, "GG: Not enough tokens left for minting");
1611             _safeMint(to[i], quantity[i]);
1612         }
1613     }
1614 
1615     function mint(uint256 quantity) external payable {
1616         require(hasSaleStarted, "GG: Cannot mint before sale has started");
1617         require(quantity + totalSupply() <= collectionSize, "GG: Total supply exceeded");
1618         require(purchased[msg.sender] + quantity <= 30, "GG: Can not purchase more than 30");
1619 
1620         if(purchased[msg.sender] >= 2) require(msg.value >= tokenPrice * quantity, "GG: Incorrect ETH");
1621         else {
1622             if(quantity > (maxFree - purchased[msg.sender])) {
1623                 uint256 amountPaid = quantity - maxFree + purchased[msg.sender];
1624                 require(msg.value >= tokenPrice * amountPaid,"GG: Incorrect ETH");
1625             }
1626         }
1627         purchased[msg.sender] += quantity;
1628         _safeMint(msg.sender, quantity);
1629     }
1630 
1631     function _baseURI() internal view override returns (string memory) {
1632         return _baseUri;
1633     }
1634 
1635     function setBaseURI(string memory newBaseURI) external onlyOwner {
1636         _baseUri = newBaseURI;
1637     }
1638 
1639     function flipSaleState() external onlyOwner {
1640         hasSaleStarted = !hasSaleStarted;
1641     }
1642 
1643     function setPrice(uint256 newPrice) external onlyOwner {
1644         tokenPrice = newPrice;
1645     }
1646 
1647     function setMaxFree(uint256 newMax) external onlyOwner {
1648         maxFree = newMax;
1649     }
1650     
1651     function amountPurchased(address add) external view returns(uint256){
1652         return purchased[add];
1653     }
1654 
1655     function withdrawAll() external onlyOwner {
1656         require(payable(msg.sender).send(address(this).balance));
1657     }
1658 }