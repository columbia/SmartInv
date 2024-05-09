1 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Contract module that helps prevent reentrant calls to a function.
10  *
11  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
12  * available, which can be applied to functions to make sure there are no nested
13  * (reentrant) calls to them.
14  *
15  * Note that because there is a single `nonReentrant` guard, functions marked as
16  * `nonReentrant` may not call one another. This can be worked around by making
17  * those functions `private`, and then adding `external` `nonReentrant` entry
18  * points to them.
19  *
20  * TIP: If you would like to learn more about reentrancy and alternative ways
21  * to protect against it, check out our blog post
22  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
23  */
24 abstract contract ReentrancyGuard {
25     // Booleans are more expensive than uint256 or any type that takes up a full
26     // word because each write operation emits an extra SLOAD to first read the
27     // slot's contents, replace the bits taken up by the boolean, and then write
28     // back. This is the compiler's defense against contract upgrades and
29     // pointer aliasing, and it cannot be disabled.
30 
31     // The values being non-zero value makes deployment a bit more expensive,
32     // but in exchange the refund on every call to nonReentrant will be lower in
33     // amount. Since refunds are capped to a percentage of the total
34     // transaction's gas, it is best to keep them low in cases like this one, to
35     // increase the likelihood of the full refund coming into effect.
36     uint256 private constant _NOT_ENTERED = 1;
37     uint256 private constant _ENTERED = 2;
38 
39     uint256 private _status;
40 
41     constructor() {
42         _status = _NOT_ENTERED;
43     }
44 
45     /**
46      * @dev Prevents a contract from calling itself, directly or indirectly.
47      * Calling a `nonReentrant` function from another `nonReentrant`
48      * function is not supported. It is possible to prevent this from happening
49      * by making the `nonReentrant` function external, and making it call a
50      * `private` function that does the actual work.
51      */
52     modifier nonReentrant() {
53         // On the first call to nonReentrant, _notEntered will be true
54         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
55 
56         // Any calls to nonReentrant after this point will fail
57         _status = _ENTERED;
58 
59         _;
60 
61         // By storing the original value once again, a refund is triggered (see
62         // https://eips.ethereum.org/EIPS/eip-2200)
63         _status = _NOT_ENTERED;
64     }
65 }
66 
67 // File: @openzeppelin/contracts/utils/Strings.sol
68 
69 
70 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
71 
72 pragma solidity ^0.8.0;
73 
74 /**
75  * @dev String operations.
76  */
77 library Strings {
78     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
79 
80     /**
81      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
82      */
83     function toString(uint256 value) internal pure returns (string memory) {
84         // Inspired by OraclizeAPI's implementation - MIT licence
85         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
86 
87         if (value == 0) {
88             return "0";
89         }
90         uint256 temp = value;
91         uint256 digits;
92         while (temp != 0) {
93             digits++;
94             temp /= 10;
95         }
96         bytes memory buffer = new bytes(digits);
97         while (value != 0) {
98             digits -= 1;
99             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
100             value /= 10;
101         }
102         return string(buffer);
103     }
104 
105     /**
106      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
107      */
108     function toHexString(uint256 value) internal pure returns (string memory) {
109         if (value == 0) {
110             return "0x00";
111         }
112         uint256 temp = value;
113         uint256 length = 0;
114         while (temp != 0) {
115             length++;
116             temp >>= 8;
117         }
118         return toHexString(value, length);
119     }
120 
121     /**
122      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
123      */
124     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
125         bytes memory buffer = new bytes(2 * length + 2);
126         buffer[0] = "0";
127         buffer[1] = "x";
128         for (uint256 i = 2 * length + 1; i > 1; --i) {
129             buffer[i] = _HEX_SYMBOLS[value & 0xf];
130             value >>= 4;
131         }
132         require(value == 0, "Strings: hex length insufficient");
133         return string(buffer);
134     }
135 }
136 
137 // File: @openzeppelin/contracts/utils/Address.sol
138 
139 
140 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
141 
142 pragma solidity ^0.8.1;
143 
144 /**
145  * @dev Collection of functions related to the address type
146  */
147 library Address {
148     /**
149      * @dev Returns true if `account` is a contract.
150      *
151      * [IMPORTANT]
152      * ====
153      * It is unsafe to assume that an address for which this function returns
154      * false is an externally-owned account (EOA) and not a contract.
155      *
156      * Among others, `isContract` will return false for the following
157      * types of addresses:
158      *
159      *  - an externally-owned account
160      *  - a contract in construction
161      *  - an address where a contract will be created
162      *  - an address where a contract lived, but was destroyed
163      * ====
164      *
165      * [IMPORTANT]
166      * ====
167      * You shouldn't rely on `isContract` to protect against flash loan attacks!
168      *
169      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
170      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
171      * constructor.
172      * ====
173      */
174     function isContract(address account) internal view returns (bool) {
175         // This method relies on extcodesize/address.code.length, which returns 0
176         // for contracts in construction, since the code is only stored at the end
177         // of the constructor execution.
178 
179         return account.code.length > 0;
180     }
181 
182     /**
183      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
184      * `recipient`, forwarding all available gas and reverting on errors.
185      *
186      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
187      * of certain opcodes, possibly making contracts go over the 2300 gas limit
188      * imposed by `transfer`, making them unable to receive funds via
189      * `transfer`. {sendValue} removes this limitation.
190      *
191      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
192      *
193      * IMPORTANT: because control is transferred to `recipient`, care must be
194      * taken to not create reentrancy vulnerabilities. Consider using
195      * {ReentrancyGuard} or the
196      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
197      */
198     function sendValue(address payable recipient, uint256 amount) internal {
199         require(address(this).balance >= amount, "Address: insufficient balance");
200 
201         (bool success, ) = recipient.call{value: amount}("");
202         require(success, "Address: unable to send value, recipient may have reverted");
203     }
204 
205     /**
206      * @dev Performs a Solidity function call using a low level `call`. A
207      * plain `call` is an unsafe replacement for a function call: use this
208      * function instead.
209      *
210      * If `target` reverts with a revert reason, it is bubbled up by this
211      * function (like regular Solidity function calls).
212      *
213      * Returns the raw returned data. To convert to the expected return value,
214      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
215      *
216      * Requirements:
217      *
218      * - `target` must be a contract.
219      * - calling `target` with `data` must not revert.
220      *
221      * _Available since v3.1._
222      */
223     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
224         return functionCall(target, data, "Address: low-level call failed");
225     }
226 
227     /**
228      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
229      * `errorMessage` as a fallback revert reason when `target` reverts.
230      *
231      * _Available since v3.1._
232      */
233     function functionCall(
234         address target,
235         bytes memory data,
236         string memory errorMessage
237     ) internal returns (bytes memory) {
238         return functionCallWithValue(target, data, 0, errorMessage);
239     }
240 
241     /**
242      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
243      * but also transferring `value` wei to `target`.
244      *
245      * Requirements:
246      *
247      * - the calling contract must have an ETH balance of at least `value`.
248      * - the called Solidity function must be `payable`.
249      *
250      * _Available since v3.1._
251      */
252     function functionCallWithValue(
253         address target,
254         bytes memory data,
255         uint256 value
256     ) internal returns (bytes memory) {
257         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
258     }
259 
260     /**
261      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
262      * with `errorMessage` as a fallback revert reason when `target` reverts.
263      *
264      * _Available since v3.1._
265      */
266     function functionCallWithValue(
267         address target,
268         bytes memory data,
269         uint256 value,
270         string memory errorMessage
271     ) internal returns (bytes memory) {
272         require(address(this).balance >= value, "Address: insufficient balance for call");
273         require(isContract(target), "Address: call to non-contract");
274 
275         (bool success, bytes memory returndata) = target.call{value: value}(data);
276         return verifyCallResult(success, returndata, errorMessage);
277     }
278 
279     /**
280      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
281      * but performing a static call.
282      *
283      * _Available since v3.3._
284      */
285     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
286         return functionStaticCall(target, data, "Address: low-level static call failed");
287     }
288 
289     /**
290      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
291      * but performing a static call.
292      *
293      * _Available since v3.3._
294      */
295     function functionStaticCall(
296         address target,
297         bytes memory data,
298         string memory errorMessage
299     ) internal view returns (bytes memory) {
300         require(isContract(target), "Address: static call to non-contract");
301 
302         (bool success, bytes memory returndata) = target.staticcall(data);
303         return verifyCallResult(success, returndata, errorMessage);
304     }
305 
306     /**
307      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
308      * but performing a delegate call.
309      *
310      * _Available since v3.4._
311      */
312     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
313         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
314     }
315 
316     /**
317      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
318      * but performing a delegate call.
319      *
320      * _Available since v3.4._
321      */
322     function functionDelegateCall(
323         address target,
324         bytes memory data,
325         string memory errorMessage
326     ) internal returns (bytes memory) {
327         require(isContract(target), "Address: delegate call to non-contract");
328 
329         (bool success, bytes memory returndata) = target.delegatecall(data);
330         return verifyCallResult(success, returndata, errorMessage);
331     }
332 
333     /**
334      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
335      * revert reason using the provided one.
336      *
337      * _Available since v4.3._
338      */
339     function verifyCallResult(
340         bool success,
341         bytes memory returndata,
342         string memory errorMessage
343     ) internal pure returns (bytes memory) {
344         if (success) {
345             return returndata;
346         } else {
347             // Look for revert reason and bubble it up if present
348             if (returndata.length > 0) {
349                 // The easiest way to bubble the revert reason is using memory via assembly
350 
351                 assembly {
352                     let returndata_size := mload(returndata)
353                     revert(add(32, returndata), returndata_size)
354                 }
355             } else {
356                 revert(errorMessage);
357             }
358         }
359     }
360 }
361 
362 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
363 
364 
365 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
366 
367 pragma solidity ^0.8.0;
368 
369 /**
370  * @title ERC721 token receiver interface
371  * @dev Interface for any contract that wants to support safeTransfers
372  * from ERC721 asset contracts.
373  */
374 interface IERC721Receiver {
375     /**
376      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
377      * by `operator` from `from`, this function is called.
378      *
379      * It must return its Solidity selector to confirm the token transfer.
380      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
381      *
382      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
383      */
384     function onERC721Received(
385         address operator,
386         address from,
387         uint256 tokenId,
388         bytes calldata data
389     ) external returns (bytes4);
390 }
391 
392 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
393 
394 
395 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
396 
397 pragma solidity ^0.8.0;
398 
399 /**
400  * @dev Interface of the ERC165 standard, as defined in the
401  * https://eips.ethereum.org/EIPS/eip-165[EIP].
402  *
403  * Implementers can declare support of contract interfaces, which can then be
404  * queried by others ({ERC165Checker}).
405  *
406  * For an implementation, see {ERC165}.
407  */
408 interface IERC165 {
409     /**
410      * @dev Returns true if this contract implements the interface defined by
411      * `interfaceId`. See the corresponding
412      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
413      * to learn more about how these ids are created.
414      *
415      * This function call must use less than 30 000 gas.
416      */
417     function supportsInterface(bytes4 interfaceId) external view returns (bool);
418 }
419 
420 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
421 
422 
423 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/IERC1155.sol)
424 
425 pragma solidity ^0.8.0;
426 
427 
428 /**
429  * @dev Required interface of an ERC1155 compliant contract, as defined in the
430  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
431  *
432  * _Available since v3.1._
433  */
434 interface IERC1155 is IERC165 {
435     /**
436      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
437      */
438     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
439 
440     /**
441      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
442      * transfers.
443      */
444     event TransferBatch(
445         address indexed operator,
446         address indexed from,
447         address indexed to,
448         uint256[] ids,
449         uint256[] values
450     );
451 
452     /**
453      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
454      * `approved`.
455      */
456     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
457 
458     /**
459      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
460      *
461      * If an {URI} event was emitted for `id`, the standard
462      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
463      * returned by {IERC1155MetadataURI-uri}.
464      */
465     event URI(string value, uint256 indexed id);
466 
467     /**
468      * @dev Returns the amount of tokens of token type `id` owned by `account`.
469      *
470      * Requirements:
471      *
472      * - `account` cannot be the zero address.
473      */
474     function balanceOf(address account, uint256 id) external view returns (uint256);
475 
476     /**
477      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
478      *
479      * Requirements:
480      *
481      * - `accounts` and `ids` must have the same length.
482      */
483     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
484         external
485         view
486         returns (uint256[] memory);
487 
488     /**
489      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
490      *
491      * Emits an {ApprovalForAll} event.
492      *
493      * Requirements:
494      *
495      * - `operator` cannot be the caller.
496      */
497     function setApprovalForAll(address operator, bool approved) external;
498 
499     /**
500      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
501      *
502      * See {setApprovalForAll}.
503      */
504     function isApprovedForAll(address account, address operator) external view returns (bool);
505 
506     /**
507      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
508      *
509      * Emits a {TransferSingle} event.
510      *
511      * Requirements:
512      *
513      * - `to` cannot be the zero address.
514      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
515      * - `from` must have a balance of tokens of type `id` of at least `amount`.
516      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
517      * acceptance magic value.
518      */
519     function safeTransferFrom(
520         address from,
521         address to,
522         uint256 id,
523         uint256 amount,
524         bytes calldata data
525     ) external;
526 
527     /**
528      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
529      *
530      * Emits a {TransferBatch} event.
531      *
532      * Requirements:
533      *
534      * - `ids` and `amounts` must have the same length.
535      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
536      * acceptance magic value.
537      */
538     function safeBatchTransferFrom(
539         address from,
540         address to,
541         uint256[] calldata ids,
542         uint256[] calldata amounts,
543         bytes calldata data
544     ) external;
545 }
546 
547 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
548 
549 
550 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
551 
552 pragma solidity ^0.8.0;
553 
554 
555 /**
556  * @dev Implementation of the {IERC165} interface.
557  *
558  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
559  * for the additional interface id that will be supported. For example:
560  *
561  * ```solidity
562  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
563  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
564  * }
565  * ```
566  *
567  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
568  */
569 abstract contract ERC165 is IERC165 {
570     /**
571      * @dev See {IERC165-supportsInterface}.
572      */
573     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
574         return interfaceId == type(IERC165).interfaceId;
575     }
576 }
577 
578 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
579 
580 
581 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
582 
583 pragma solidity ^0.8.0;
584 
585 
586 /**
587  * @dev Required interface of an ERC721 compliant contract.
588  */
589 interface IERC721 is IERC165 {
590     /**
591      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
592      */
593     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
594 
595     /**
596      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
597      */
598     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
599 
600     /**
601      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
602      */
603     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
604 
605     /**
606      * @dev Returns the number of tokens in ``owner``'s account.
607      */
608     function balanceOf(address owner) external view returns (uint256 balance);
609 
610     /**
611      * @dev Returns the owner of the `tokenId` token.
612      *
613      * Requirements:
614      *
615      * - `tokenId` must exist.
616      */
617     function ownerOf(uint256 tokenId) external view returns (address owner);
618 
619     /**
620      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
621      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
622      *
623      * Requirements:
624      *
625      * - `from` cannot be the zero address.
626      * - `to` cannot be the zero address.
627      * - `tokenId` token must exist and be owned by `from`.
628      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
629      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
630      *
631      * Emits a {Transfer} event.
632      */
633     function safeTransferFrom(
634         address from,
635         address to,
636         uint256 tokenId
637     ) external;
638 
639     /**
640      * @dev Transfers `tokenId` token from `from` to `to`.
641      *
642      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
643      *
644      * Requirements:
645      *
646      * - `from` cannot be the zero address.
647      * - `to` cannot be the zero address.
648      * - `tokenId` token must be owned by `from`.
649      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
650      *
651      * Emits a {Transfer} event.
652      */
653     function transferFrom(
654         address from,
655         address to,
656         uint256 tokenId
657     ) external;
658 
659     /**
660      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
661      * The approval is cleared when the token is transferred.
662      *
663      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
664      *
665      * Requirements:
666      *
667      * - The caller must own the token or be an approved operator.
668      * - `tokenId` must exist.
669      *
670      * Emits an {Approval} event.
671      */
672     function approve(address to, uint256 tokenId) external;
673 
674     /**
675      * @dev Returns the account approved for `tokenId` token.
676      *
677      * Requirements:
678      *
679      * - `tokenId` must exist.
680      */
681     function getApproved(uint256 tokenId) external view returns (address operator);
682 
683     /**
684      * @dev Approve or remove `operator` as an operator for the caller.
685      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
686      *
687      * Requirements:
688      *
689      * - The `operator` cannot be the caller.
690      *
691      * Emits an {ApprovalForAll} event.
692      */
693     function setApprovalForAll(address operator, bool _approved) external;
694 
695     /**
696      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
697      *
698      * See {setApprovalForAll}
699      */
700     function isApprovedForAll(address owner, address operator) external view returns (bool);
701 
702     /**
703      * @dev Safely transfers `tokenId` token from `from` to `to`.
704      *
705      * Requirements:
706      *
707      * - `from` cannot be the zero address.
708      * - `to` cannot be the zero address.
709      * - `tokenId` token must exist and be owned by `from`.
710      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
711      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
712      *
713      * Emits a {Transfer} event.
714      */
715     function safeTransferFrom(
716         address from,
717         address to,
718         uint256 tokenId,
719         bytes calldata data
720     ) external;
721 }
722 
723 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
724 
725 
726 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
727 
728 pragma solidity ^0.8.0;
729 
730 
731 /**
732  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
733  * @dev See https://eips.ethereum.org/EIPS/eip-721
734  */
735 interface IERC721Enumerable is IERC721 {
736     /**
737      * @dev Returns the total amount of tokens stored by the contract.
738      */
739     function totalSupply() external view returns (uint256);
740 
741     /**
742      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
743      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
744      */
745     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
746 
747     /**
748      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
749      * Use along with {totalSupply} to enumerate all tokens.
750      */
751     function tokenByIndex(uint256 index) external view returns (uint256);
752 }
753 
754 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
755 
756 
757 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
758 
759 pragma solidity ^0.8.0;
760 
761 
762 /**
763  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
764  * @dev See https://eips.ethereum.org/EIPS/eip-721
765  */
766 interface IERC721Metadata is IERC721 {
767     /**
768      * @dev Returns the token collection name.
769      */
770     function name() external view returns (string memory);
771 
772     /**
773      * @dev Returns the token collection symbol.
774      */
775     function symbol() external view returns (string memory);
776 
777     /**
778      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
779      */
780     function tokenURI(uint256 tokenId) external view returns (string memory);
781 }
782 
783 // File: @openzeppelin/contracts/utils/Context.sol
784 
785 
786 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
787 
788 pragma solidity ^0.8.0;
789 
790 /**
791  * @dev Provides information about the current execution context, including the
792  * sender of the transaction and its data. While these are generally available
793  * via msg.sender and msg.data, they should not be accessed in such a direct
794  * manner, since when dealing with meta-transactions the account sending and
795  * paying for execution may not be the actual sender (as far as an application
796  * is concerned).
797  *
798  * This contract is only required for intermediate, library-like contracts.
799  */
800 abstract contract Context {
801     function _msgSender() internal view virtual returns (address) {
802         return msg.sender;
803     }
804 
805     function _msgData() internal view virtual returns (bytes calldata) {
806         return msg.data;
807     }
808 }
809 
810 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
811 
812 
813 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
814 
815 pragma solidity ^0.8.0;
816 
817 
818 
819 
820 
821 
822 
823 
824 /**
825  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
826  * the Metadata extension, but not including the Enumerable extension, which is available separately as
827  * {ERC721Enumerable}.
828  */
829 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
830     using Address for address;
831     using Strings for uint256;
832 
833     // Token name
834     string private _name;
835 
836     // Token symbol
837     string private _symbol;
838 
839     // Mapping from token ID to owner address
840     mapping(uint256 => address) private _owners;
841 
842     // Mapping owner address to token count
843     mapping(address => uint256) private _balances;
844 
845     // Mapping from token ID to approved address
846     mapping(uint256 => address) private _tokenApprovals;
847 
848     // Mapping from owner to operator approvals
849     mapping(address => mapping(address => bool)) private _operatorApprovals;
850 
851     /**
852      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
853      */
854     constructor(string memory name_, string memory symbol_) {
855         _name = name_;
856         _symbol = symbol_;
857     }
858 
859     /**
860      * @dev See {IERC165-supportsInterface}.
861      */
862     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
863         return
864             interfaceId == type(IERC721).interfaceId ||
865             interfaceId == type(IERC721Metadata).interfaceId ||
866             super.supportsInterface(interfaceId);
867     }
868 
869     /**
870      * @dev See {IERC721-balanceOf}.
871      */
872     function balanceOf(address owner) public view virtual override returns (uint256) {
873         require(owner != address(0), "ERC721: balance query for the zero address");
874         return _balances[owner];
875     }
876 
877     /**
878      * @dev See {IERC721-ownerOf}.
879      */
880     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
881         address owner = _owners[tokenId];
882         require(owner != address(0), "ERC721: owner query for nonexistent token");
883         return owner;
884     }
885 
886     /**
887      * @dev See {IERC721Metadata-name}.
888      */
889     function name() public view virtual override returns (string memory) {
890         return _name;
891     }
892 
893     /**
894      * @dev See {IERC721Metadata-symbol}.
895      */
896     function symbol() public view virtual override returns (string memory) {
897         return _symbol;
898     }
899 
900     /**
901      * @dev See {IERC721Metadata-tokenURI}.
902      */
903     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
904         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
905 
906         string memory baseURI = _baseURI();
907         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
908     }
909 
910     /**
911      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
912      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
913      * by default, can be overriden in child contracts.
914      */
915     function _baseURI() internal view virtual returns (string memory) {
916         return "";
917     }
918 
919     /**
920      * @dev See {IERC721-approve}.
921      */
922     function approve(address to, uint256 tokenId) public virtual override {
923         address owner = ERC721.ownerOf(tokenId);
924         require(to != owner, "ERC721: approval to current owner");
925 
926         require(
927             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
928             "ERC721: approve caller is not owner nor approved for all"
929         );
930 
931         _approve(to, tokenId);
932     }
933 
934     /**
935      * @dev See {IERC721-getApproved}.
936      */
937     function getApproved(uint256 tokenId) public view virtual override returns (address) {
938         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
939 
940         return _tokenApprovals[tokenId];
941     }
942 
943     /**
944      * @dev See {IERC721-setApprovalForAll}.
945      */
946     function setApprovalForAll(address operator, bool approved) public virtual override {
947         _setApprovalForAll(_msgSender(), operator, approved);
948     }
949 
950     /**
951      * @dev See {IERC721-isApprovedForAll}.
952      */
953     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
954         return _operatorApprovals[owner][operator];
955     }
956 
957     /**
958      * @dev See {IERC721-transferFrom}.
959      */
960     function transferFrom(
961         address from,
962         address to,
963         uint256 tokenId
964     ) public virtual override {
965         //solhint-disable-next-line max-line-length
966         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
967 
968         _transfer(from, to, tokenId);
969     }
970 
971     /**
972      * @dev See {IERC721-safeTransferFrom}.
973      */
974     function safeTransferFrom(
975         address from,
976         address to,
977         uint256 tokenId
978     ) public virtual override {
979         safeTransferFrom(from, to, tokenId, "");
980     }
981 
982     /**
983      * @dev See {IERC721-safeTransferFrom}.
984      */
985     function safeTransferFrom(
986         address from,
987         address to,
988         uint256 tokenId,
989         bytes memory _data
990     ) public virtual override {
991         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
992         _safeTransfer(from, to, tokenId, _data);
993     }
994 
995     /**
996      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
997      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
998      *
999      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1000      *
1001      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1002      * implement alternative mechanisms to perform token transfer, such as signature-based.
1003      *
1004      * Requirements:
1005      *
1006      * - `from` cannot be the zero address.
1007      * - `to` cannot be the zero address.
1008      * - `tokenId` token must exist and be owned by `from`.
1009      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1010      *
1011      * Emits a {Transfer} event.
1012      */
1013     function _safeTransfer(
1014         address from,
1015         address to,
1016         uint256 tokenId,
1017         bytes memory _data
1018     ) internal virtual {
1019         _transfer(from, to, tokenId);
1020         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1021     }
1022 
1023     /**
1024      * @dev Returns whether `tokenId` exists.
1025      *
1026      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1027      *
1028      * Tokens start existing when they are minted (`_mint`),
1029      * and stop existing when they are burned (`_burn`).
1030      */
1031     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1032         return _owners[tokenId] != address(0);
1033     }
1034 
1035     /**
1036      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1037      *
1038      * Requirements:
1039      *
1040      * - `tokenId` must exist.
1041      */
1042     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1043         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1044         address owner = ERC721.ownerOf(tokenId);
1045         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1046     }
1047 
1048     /**
1049      * @dev Safely mints `tokenId` and transfers it to `to`.
1050      *
1051      * Requirements:
1052      *
1053      * - `tokenId` must not exist.
1054      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1055      *
1056      * Emits a {Transfer} event.
1057      */
1058     function _safeMint(address to, uint256 tokenId) internal virtual {
1059         _safeMint(to, tokenId, "");
1060     }
1061 
1062     /**
1063      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1064      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1065      */
1066     function _safeMint(
1067         address to,
1068         uint256 tokenId,
1069         bytes memory _data
1070     ) internal virtual {
1071         _mint(to, tokenId);
1072         require(
1073             _checkOnERC721Received(address(0), to, tokenId, _data),
1074             "ERC721: transfer to non ERC721Receiver implementer"
1075         );
1076     }
1077 
1078     /**
1079      * @dev Mints `tokenId` and transfers it to `to`.
1080      *
1081      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1082      *
1083      * Requirements:
1084      *
1085      * - `tokenId` must not exist.
1086      * - `to` cannot be the zero address.
1087      *
1088      * Emits a {Transfer} event.
1089      */
1090     function _mint(address to, uint256 tokenId) internal virtual {
1091         require(to != address(0), "ERC721: mint to the zero address");
1092         require(!_exists(tokenId), "ERC721: token already minted");
1093 
1094         _beforeTokenTransfer(address(0), to, tokenId);
1095 
1096         _balances[to] += 1;
1097         _owners[tokenId] = to;
1098 
1099         emit Transfer(address(0), to, tokenId);
1100 
1101         _afterTokenTransfer(address(0), to, tokenId);
1102     }
1103 
1104     /**
1105      * @dev Destroys `tokenId`.
1106      * The approval is cleared when the token is burned.
1107      *
1108      * Requirements:
1109      *
1110      * - `tokenId` must exist.
1111      *
1112      * Emits a {Transfer} event.
1113      */
1114     function _burn(uint256 tokenId) internal virtual {
1115         address owner = ERC721.ownerOf(tokenId);
1116 
1117         _beforeTokenTransfer(owner, address(0), tokenId);
1118 
1119         // Clear approvals
1120         _approve(address(0), tokenId);
1121 
1122         _balances[owner] -= 1;
1123         delete _owners[tokenId];
1124 
1125         emit Transfer(owner, address(0), tokenId);
1126 
1127         _afterTokenTransfer(owner, address(0), tokenId);
1128     }
1129 
1130     /**
1131      * @dev Transfers `tokenId` from `from` to `to`.
1132      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1133      *
1134      * Requirements:
1135      *
1136      * - `to` cannot be the zero address.
1137      * - `tokenId` token must be owned by `from`.
1138      *
1139      * Emits a {Transfer} event.
1140      */
1141     function _transfer(
1142         address from,
1143         address to,
1144         uint256 tokenId
1145     ) internal virtual {
1146         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1147         require(to != address(0), "ERC721: transfer to the zero address");
1148 
1149         _beforeTokenTransfer(from, to, tokenId);
1150 
1151         // Clear approvals from the previous owner
1152         _approve(address(0), tokenId);
1153 
1154         _balances[from] -= 1;
1155         _balances[to] += 1;
1156         _owners[tokenId] = to;
1157 
1158         emit Transfer(from, to, tokenId);
1159 
1160         _afterTokenTransfer(from, to, tokenId);
1161     }
1162 
1163     /**
1164      * @dev Approve `to` to operate on `tokenId`
1165      *
1166      * Emits a {Approval} event.
1167      */
1168     function _approve(address to, uint256 tokenId) internal virtual {
1169         _tokenApprovals[tokenId] = to;
1170         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1171     }
1172 
1173     /**
1174      * @dev Approve `operator` to operate on all of `owner` tokens
1175      *
1176      * Emits a {ApprovalForAll} event.
1177      */
1178     function _setApprovalForAll(
1179         address owner,
1180         address operator,
1181         bool approved
1182     ) internal virtual {
1183         require(owner != operator, "ERC721: approve to caller");
1184         _operatorApprovals[owner][operator] = approved;
1185         emit ApprovalForAll(owner, operator, approved);
1186     }
1187 
1188     /**
1189      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1190      * The call is not executed if the target address is not a contract.
1191      *
1192      * @param from address representing the previous owner of the given token ID
1193      * @param to target address that will receive the tokens
1194      * @param tokenId uint256 ID of the token to be transferred
1195      * @param _data bytes optional data to send along with the call
1196      * @return bool whether the call correctly returned the expected magic value
1197      */
1198     function _checkOnERC721Received(
1199         address from,
1200         address to,
1201         uint256 tokenId,
1202         bytes memory _data
1203     ) private returns (bool) {
1204         if (to.isContract()) {
1205             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1206                 return retval == IERC721Receiver.onERC721Received.selector;
1207             } catch (bytes memory reason) {
1208                 if (reason.length == 0) {
1209                     revert("ERC721: transfer to non ERC721Receiver implementer");
1210                 } else {
1211                     assembly {
1212                         revert(add(32, reason), mload(reason))
1213                     }
1214                 }
1215             }
1216         } else {
1217             return true;
1218         }
1219     }
1220 
1221     /**
1222      * @dev Hook that is called before any token transfer. This includes minting
1223      * and burning.
1224      *
1225      * Calling conditions:
1226      *
1227      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1228      * transferred to `to`.
1229      * - When `from` is zero, `tokenId` will be minted for `to`.
1230      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1231      * - `from` and `to` are never both zero.
1232      *
1233      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1234      */
1235     function _beforeTokenTransfer(
1236         address from,
1237         address to,
1238         uint256 tokenId
1239     ) internal virtual {}
1240 
1241     /**
1242      * @dev Hook that is called after any transfer of tokens. This includes
1243      * minting and burning.
1244      *
1245      * Calling conditions:
1246      *
1247      * - when `from` and `to` are both non-zero.
1248      * - `from` and `to` are never both zero.
1249      *
1250      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1251      */
1252     function _afterTokenTransfer(
1253         address from,
1254         address to,
1255         uint256 tokenId
1256     ) internal virtual {}
1257 }
1258 
1259 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1260 
1261 
1262 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1263 
1264 pragma solidity ^0.8.0;
1265 
1266 
1267 
1268 /**
1269  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1270  * enumerability of all the token ids in the contract as well as all token ids owned by each
1271  * account.
1272  */
1273 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1274     // Mapping from owner to list of owned token IDs
1275     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1276 
1277     // Mapping from token ID to index of the owner tokens list
1278     mapping(uint256 => uint256) private _ownedTokensIndex;
1279 
1280     // Array with all token ids, used for enumeration
1281     uint256[] private _allTokens;
1282 
1283     // Mapping from token id to position in the allTokens array
1284     mapping(uint256 => uint256) private _allTokensIndex;
1285 
1286     /**
1287      * @dev See {IERC165-supportsInterface}.
1288      */
1289     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1290         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1291     }
1292 
1293     /**
1294      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1295      */
1296     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1297         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1298         return _ownedTokens[owner][index];
1299     }
1300 
1301     /**
1302      * @dev See {IERC721Enumerable-totalSupply}.
1303      */
1304     function totalSupply() public view virtual override returns (uint256) {
1305         return _allTokens.length;
1306     }
1307 
1308     /**
1309      * @dev See {IERC721Enumerable-tokenByIndex}.
1310      */
1311     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1312         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1313         return _allTokens[index];
1314     }
1315 
1316     /**
1317      * @dev Hook that is called before any token transfer. This includes minting
1318      * and burning.
1319      *
1320      * Calling conditions:
1321      *
1322      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1323      * transferred to `to`.
1324      * - When `from` is zero, `tokenId` will be minted for `to`.
1325      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1326      * - `from` cannot be the zero address.
1327      * - `to` cannot be the zero address.
1328      *
1329      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1330      */
1331     function _beforeTokenTransfer(
1332         address from,
1333         address to,
1334         uint256 tokenId
1335     ) internal virtual override {
1336         super._beforeTokenTransfer(from, to, tokenId);
1337 
1338         if (from == address(0)) {
1339             _addTokenToAllTokensEnumeration(tokenId);
1340         } else if (from != to) {
1341             _removeTokenFromOwnerEnumeration(from, tokenId);
1342         }
1343         if (to == address(0)) {
1344             _removeTokenFromAllTokensEnumeration(tokenId);
1345         } else if (to != from) {
1346             _addTokenToOwnerEnumeration(to, tokenId);
1347         }
1348     }
1349 
1350     /**
1351      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1352      * @param to address representing the new owner of the given token ID
1353      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1354      */
1355     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1356         uint256 length = ERC721.balanceOf(to);
1357         _ownedTokens[to][length] = tokenId;
1358         _ownedTokensIndex[tokenId] = length;
1359     }
1360 
1361     /**
1362      * @dev Private function to add a token to this extension's token tracking data structures.
1363      * @param tokenId uint256 ID of the token to be added to the tokens list
1364      */
1365     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1366         _allTokensIndex[tokenId] = _allTokens.length;
1367         _allTokens.push(tokenId);
1368     }
1369 
1370     /**
1371      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1372      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1373      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1374      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1375      * @param from address representing the previous owner of the given token ID
1376      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1377      */
1378     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1379         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1380         // then delete the last slot (swap and pop).
1381 
1382         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1383         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1384 
1385         // When the token to delete is the last token, the swap operation is unnecessary
1386         if (tokenIndex != lastTokenIndex) {
1387             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1388 
1389             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1390             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1391         }
1392 
1393         // This also deletes the contents at the last position of the array
1394         delete _ownedTokensIndex[tokenId];
1395         delete _ownedTokens[from][lastTokenIndex];
1396     }
1397 
1398     /**
1399      * @dev Private function to remove a token from this extension's token tracking data structures.
1400      * This has O(1) time complexity, but alters the order of the _allTokens array.
1401      * @param tokenId uint256 ID of the token to be removed from the tokens list
1402      */
1403     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1404         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1405         // then delete the last slot (swap and pop).
1406 
1407         uint256 lastTokenIndex = _allTokens.length - 1;
1408         uint256 tokenIndex = _allTokensIndex[tokenId];
1409 
1410         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1411         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1412         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1413         uint256 lastTokenId = _allTokens[lastTokenIndex];
1414 
1415         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1416         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1417 
1418         // This also deletes the contents at the last position of the array
1419         delete _allTokensIndex[tokenId];
1420         _allTokens.pop();
1421     }
1422 }
1423 
1424 // File: @openzeppelin/contracts/access/Ownable.sol
1425 
1426 
1427 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1428 
1429 pragma solidity ^0.8.0;
1430 
1431 
1432 /**
1433  * @dev Contract module which provides a basic access control mechanism, where
1434  * there is an account (an owner) that can be granted exclusive access to
1435  * specific functions.
1436  *
1437  * By default, the owner account will be the one that deploys the contract. This
1438  * can later be changed with {transferOwnership}.
1439  *
1440  * This module is used through inheritance. It will make available the modifier
1441  * `onlyOwner`, which can be applied to your functions to restrict their use to
1442  * the owner.
1443  */
1444 abstract contract Ownable is Context {
1445     address private _owner;
1446 
1447     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1448 
1449     /**
1450      * @dev Initializes the contract setting the deployer as the initial owner.
1451      */
1452     constructor() {
1453         _transferOwnership(_msgSender());
1454     }
1455 
1456     /**
1457      * @dev Returns the address of the current owner.
1458      */
1459     function owner() public view virtual returns (address) {
1460         return _owner;
1461     }
1462 
1463     /**
1464      * @dev Throws if called by any account other than the owner.
1465      */
1466     modifier onlyOwner() {
1467         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1468         _;
1469     }
1470 
1471     /**
1472      * @dev Leaves the contract without owner. It will not be possible to call
1473      * `onlyOwner` functions anymore. Can only be called by the current owner.
1474      *
1475      * NOTE: Renouncing ownership will leave the contract without an owner,
1476      * thereby removing any functionality that is only available to the owner.
1477      */
1478     function renounceOwnership() public virtual onlyOwner {
1479         _transferOwnership(address(0));
1480     }
1481 
1482     /**
1483      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1484      * Can only be called by the current owner.
1485      */
1486     function transferOwnership(address newOwner) public virtual onlyOwner {
1487         require(newOwner != address(0), "Ownable: new owner is the zero address");
1488         _transferOwnership(newOwner);
1489     }
1490 
1491     /**
1492      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1493      * Internal function without access restriction.
1494      */
1495     function _transferOwnership(address newOwner) internal virtual {
1496         address oldOwner = _owner;
1497         _owner = newOwner;
1498         emit OwnershipTransferred(oldOwner, newOwner);
1499     }
1500 }
1501 
1502 // File: Genesis.sol
1503 
1504 //SPDX-License-Identifier: MIT
1505 pragma solidity ^0.8.0;
1506 
1507 
1508 
1509 
1510 // import "./interfaces/IERC1155Interface.sol";
1511 
1512 contract Genesis is ERC721Enumerable, Ownable, ReentrancyGuard {
1513     /// @dev token id tracker
1514     uint256 public tokenIdTracker;
1515 
1516     /// baseTokenURI
1517     string public baseTokenURI;
1518 
1519     address public immutable nftOwner =
1520         0xfEb8F9609c677dC57731B1e940fE2ad8faa6b169;
1521 
1522     address public oldGenesis;
1523 
1524     
1525     event Claim(uint256[] tokenIds);
1526     uint[] public tokenToOpenseaMap;
1527 
1528     event SetBaseTokenURI(string baseTokenURI);
1529 
1530     constructor(
1531         string memory _name,
1532         string memory _symbol,
1533         string memory _baseURI,
1534         address _oldGenesis,
1535         uint[] memory tokens
1536     ) ERC721(_name, _symbol) {
1537         setBaseURI(_baseURI);
1538         setOldGenesis(_oldGenesis);
1539         tokenToOpenseaMap = tokens;
1540     }
1541 
1542     /**
1543      * @dev Claim NFT
1544      */
1545     function claim(uint256[] memory _tokenIds) external nonReentrant {
1546         require(_tokenIds.length != 0, "genesis : invalid tokenId length");
1547 
1548         for (uint256 i = 0; i < _tokenIds.length; i++) {
1549             uint256 tokenId = _tokenIds[i];
1550 
1551             require(tokenId != 0, "genesis : invalid tokenId");
1552 
1553             uint256 count = IERC1155(oldGenesis).balanceOf(msg.sender, tokenToOpenseaMap[tokenId-1]);
1554 
1555             require(count > 0, "genesis : sender is not owner");
1556 
1557             IERC1155(oldGenesis).safeTransferFrom(msg.sender, nftOwner, tokenToOpenseaMap[tokenId-1], 1, "");
1558 
1559             _safeMint(msg.sender,tokenId);
1560             // super._safeTransfer(nftOwner, msg.sender, tokenId, "");
1561         }
1562 
1563         emit Claim(_tokenIds);
1564     }
1565 
1566     /**
1567      * @dev Get `baseTokenURI`
1568      * Overrided
1569      */
1570     function _baseURI() internal view virtual override returns (string memory) {
1571         return baseTokenURI;
1572     }
1573 
1574     /**
1575      * @dev Set `baseTokenURI`
1576      */
1577     function setBaseURI(string memory baseURI) public onlyOwner {
1578         require(bytes(baseURI).length > 0, "genesis : base URI invalid");
1579         baseTokenURI = baseURI;
1580 
1581         emit SetBaseTokenURI(baseURI);
1582     }
1583 
1584     function editOpenseaToken(uint index,uint token) external onlyOwner{
1585         tokenToOpenseaMap[index] = token;
1586     }
1587 
1588     function setOldGenesis(address _oldGenesis) public onlyOwner {
1589         oldGenesis = _oldGenesis;
1590     }
1591 }