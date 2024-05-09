1 // Sources flattened with hardhat v2.9.3 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.6.0
4 
5 // SPDX-License-Identifier: MIT
6 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Interface of the ERC165 standard, as defined in the
12  * https://eips.ethereum.org/EIPS/eip-165[EIP].
13  *
14  * Implementers can declare support of contract interfaces, which can then be
15  * queried by others ({ERC165Checker}).
16  *
17  * For an implementation, see {ERC165}.
18  */
19 interface IERC165 {
20     /**
21      * @dev Returns true if this contract implements the interface defined by
22      * `interfaceId`. See the corresponding
23      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
24      * to learn more about how these ids are created.
25      *
26      * This function call must use less than 30 000 gas.
27      */
28     function supportsInterface(bytes4 interfaceId) external view returns (bool);
29 }
30 
31 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.6.0
32 
33 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
34 
35 pragma solidity ^0.8.0;
36 
37 /**
38  * @dev Required interface of an ERC721 compliant contract.
39  */
40 interface IERC721 is IERC165 {
41     /**
42      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
43      */
44     event Transfer(
45         address indexed from,
46         address indexed to,
47         uint256 indexed tokenId
48     );
49 
50     /**
51      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
52      */
53     event Approval(
54         address indexed owner,
55         address indexed approved,
56         uint256 indexed tokenId
57     );
58 
59     /**
60      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
61      */
62     event ApprovalForAll(
63         address indexed owner,
64         address indexed operator,
65         bool approved
66     );
67 
68     /**
69      * @dev Returns the number of tokens in ``owner``'s account.
70      */
71     function balanceOf(address owner) external view returns (uint256 balance);
72 
73     /**
74      * @dev Returns the owner of the `tokenId` token.
75      *
76      * Requirements:
77      *
78      * - `tokenId` must exist.
79      */
80     function ownerOf(uint256 tokenId) external view returns (address owner);
81 
82     /**
83      * @dev Safely transfers `tokenId` token from `from` to `to`.
84      *
85      * Requirements:
86      *
87      * - `from` cannot be the zero address.
88      * - `to` cannot be the zero address.
89      * - `tokenId` token must exist and be owned by `from`.
90      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
91      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
92      *
93      * Emits a {Transfer} event.
94      */
95     function safeTransferFrom(
96         address from,
97         address to,
98         uint256 tokenId,
99         bytes calldata data
100     ) external;
101 
102     /**
103      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
104      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
105      *
106      * Requirements:
107      *
108      * - `from` cannot be the zero address.
109      * - `to` cannot be the zero address.
110      * - `tokenId` token must exist and be owned by `from`.
111      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
112      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
113      *
114      * Emits a {Transfer} event.
115      */
116     function safeTransferFrom(
117         address from,
118         address to,
119         uint256 tokenId
120     ) external;
121 
122     /**
123      * @dev Transfers `tokenId` token from `from` to `to`.
124      *
125      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
126      *
127      * Requirements:
128      *
129      * - `from` cannot be the zero address.
130      * - `to` cannot be the zero address.
131      * - `tokenId` token must be owned by `from`.
132      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
133      *
134      * Emits a {Transfer} event.
135      */
136     function transferFrom(
137         address from,
138         address to,
139         uint256 tokenId
140     ) external;
141 
142     /**
143      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
144      * The approval is cleared when the token is transferred.
145      *
146      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
147      *
148      * Requirements:
149      *
150      * - The caller must own the token or be an approved operator.
151      * - `tokenId` must exist.
152      *
153      * Emits an {Approval} event.
154      */
155     function approve(address to, uint256 tokenId) external;
156 
157     /**
158      * @dev Approve or remove `operator` as an operator for the caller.
159      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
160      *
161      * Requirements:
162      *
163      * - The `operator` cannot be the caller.
164      *
165      * Emits an {ApprovalForAll} event.
166      */
167     function setApprovalForAll(address operator, bool _approved) external;
168 
169     /**
170      * @dev Returns the account approved for `tokenId` token.
171      *
172      * Requirements:
173      *
174      * - `tokenId` must exist.
175      */
176     function getApproved(uint256 tokenId)
177         external
178         view
179         returns (address operator);
180 
181     /**
182      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
183      *
184      * See {setApprovalForAll}
185      */
186     function isApprovedForAll(address owner, address operator)
187         external
188         view
189         returns (bool);
190 }
191 
192 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.6.0
193 
194 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
195 
196 pragma solidity ^0.8.0;
197 
198 /**
199  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
200  * @dev See https://eips.ethereum.org/EIPS/eip-721
201  */
202 interface IERC721Metadata is IERC721 {
203     /**
204      * @dev Returns the token collection name.
205      */
206     function name() external view returns (string memory);
207 
208     /**
209      * @dev Returns the token collection symbol.
210      */
211     function symbol() external view returns (string memory);
212 
213     /**
214      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
215      */
216     function tokenURI(uint256 tokenId) external view returns (string memory);
217 }
218 
219 // File contracts/ERC721A/IERC721A.sol
220 
221 // ERC721A Contracts v3.3.0
222 // Creator: Chiru Labs
223 
224 pragma solidity ^0.8.4;
225 
226 /**
227  * @dev Interface of an ERC721A compliant contract.
228  */
229 interface IERC721A is IERC721, IERC721Metadata {
230     /**
231      * The caller must own the token or be an approved operator.
232      */
233     error ApprovalCallerNotOwnerNorApproved();
234 
235     /**
236      * The token does not exist.
237      */
238     error ApprovalQueryForNonexistentToken();
239 
240     /**
241      * The caller cannot approve to their own address.
242      */
243     error ApproveToCaller();
244 
245     /**
246      * The caller cannot approve to the current owner.
247      */
248     error ApprovalToCurrentOwner();
249 
250     /**
251      * Cannot query the balance for the zero address.
252      */
253     error BalanceQueryForZeroAddress();
254 
255     /**
256      * Cannot mint to the zero address.
257      */
258     error MintToZeroAddress();
259 
260     /**
261      * The quantity of tokens minted must be more than zero.
262      */
263     error MintZeroQuantity();
264 
265     /**
266      * The token does not exist.
267      */
268     error OwnerQueryForNonexistentToken();
269 
270     /**
271      * The caller must own the token or be an approved operator.
272      */
273     error TransferCallerNotOwnerNorApproved();
274 
275     /**
276      * The token must be owned by `from`.
277      */
278     error TransferFromIncorrectOwner();
279 
280     /**
281      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
282      */
283     error TransferToNonERC721ReceiverImplementer();
284 
285     /**
286      * Cannot transfer to the zero address.
287      */
288     error TransferToZeroAddress();
289 
290     /**
291      * The token does not exist.
292      */
293     error URIQueryForNonexistentToken();
294 
295     // Compiler will pack this into a single 256bit word.
296     struct TokenOwnership {
297         // The address of the owner.
298         address addr;
299         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
300         uint64 startTimestamp;
301         // Whether the token has been burned.
302         bool burned;
303     }
304 
305     // Compiler will pack this into a single 256bit word.
306     struct AddressData {
307         // Realistically, 2**64-1 is more than enough.
308         uint64 balance;
309         // Keeps track of mint count with minimal overhead for tokenomics.
310         uint64 numberMinted;
311         // Keeps track of burn count with minimal overhead for tokenomics.
312         uint64 numberBurned;
313         // For miscellaneous variable(s) pertaining to the address
314         // (e.g. number of whitelist mint slots used).
315         // If there are multiple variables, please pack them into a uint64.
316         uint64 aux;
317     }
318 
319     /**
320      * @dev Returns the total amount of tokens stored by the contract.
321      *
322      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
323      */
324     function totalSupply() external view returns (uint256);
325 }
326 
327 // File contracts/ERC721A/IERC721AQueryable.sol
328 
329 // ERC721A Contracts v3.3.0
330 // Creator: Chiru Labs
331 
332 pragma solidity ^0.8.4;
333 
334 /**
335  * @dev Interface of an ERC721AQueryable compliant contract.
336  */
337 interface IERC721AQueryable is IERC721A {
338     /**
339      * Invalid query range (`start` >= `stop`).
340      */
341     error InvalidQueryRange();
342 
343     /**
344      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
345      *
346      * If the `tokenId` is out of bounds:
347      *   - `addr` = `address(0)`
348      *   - `startTimestamp` = `0`
349      *   - `burned` = `false`
350      *
351      * If the `tokenId` is burned:
352      *   - `addr` = `<Address of owner before token was burned>`
353      *   - `startTimestamp` = `<Timestamp when token was burned>`
354      *   - `burned = `true`
355      *
356      * Otherwise:
357      *   - `addr` = `<Address of owner>`
358      *   - `startTimestamp` = `<Timestamp of start of ownership>`
359      *   - `burned = `false`
360      */
361     function explicitOwnershipOf(uint256 tokenId)
362         external
363         view
364         returns (TokenOwnership memory);
365 
366     /**
367      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
368      * See {ERC721AQueryable-explicitOwnershipOf}
369      */
370     function explicitOwnershipsOf(uint256[] memory tokenIds)
371         external
372         view
373         returns (TokenOwnership[] memory);
374 
375     /**
376      * @dev Returns an array of token IDs owned by `owner`,
377      * in the range [`start`, `stop`)
378      * (i.e. `start <= tokenId < stop`).
379      *
380      * This function allows for tokens to be queried if the collection
381      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
382      *
383      * Requirements:
384      *
385      * - `start` < `stop`
386      */
387     function tokensOfOwnerIn(
388         address owner,
389         uint256 start,
390         uint256 stop
391     ) external view returns (uint256[] memory);
392 
393     /**
394      * @dev Returns an array of token IDs owned by `owner`.
395      *
396      * This function scans the ownership mapping and is O(totalSupply) in complexity.
397      * It is meant to be called off-chain.
398      *
399      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
400      * multiple smaller scans if the collection is large enough to cause
401      * an out-of-gas error (10K pfp collections should be fine).
402      */
403     function tokensOfOwner(address owner)
404         external
405         view
406         returns (uint256[] memory);
407 }
408 
409 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.6.0
410 
411 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
412 
413 pragma solidity ^0.8.0;
414 
415 /**
416  * @title ERC721 token receiver interface
417  * @dev Interface for any contract that wants to support safeTransfers
418  * from ERC721 asset contracts.
419  */
420 interface IERC721Receiver {
421     /**
422      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
423      * by `operator` from `from`, this function is called.
424      *
425      * It must return its Solidity selector to confirm the token transfer.
426      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
427      *
428      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
429      */
430     function onERC721Received(
431         address operator,
432         address from,
433         uint256 tokenId,
434         bytes calldata data
435     ) external returns (bytes4);
436 }
437 
438 // File @openzeppelin/contracts/utils/Address.sol@v4.6.0
439 
440 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
441 
442 pragma solidity ^0.8.1;
443 
444 /**
445  * @dev Collection of functions related to the address type
446  */
447 library Address {
448     /**
449      * @dev Returns true if `account` is a contract.
450      *
451      * [IMPORTANT]
452      * ====
453      * It is unsafe to assume that an address for which this function returns
454      * false is an externally-owned account (EOA) and not a contract.
455      *
456      * Among others, `isContract` will return false for the following
457      * types of addresses:
458      *
459      *  - an externally-owned account
460      *  - a contract in construction
461      *  - an address where a contract will be created
462      *  - an address where a contract lived, but was destroyed
463      * ====
464      *
465      * [IMPORTANT]
466      * ====
467      * You shouldn't rely on `isContract` to protect against flash loan attacks!
468      *
469      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
470      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
471      * constructor.
472      * ====
473      */
474     function isContract(address account) internal view returns (bool) {
475         // This method relies on extcodesize/address.code.length, which returns 0
476         // for contracts in construction, since the code is only stored at the end
477         // of the constructor execution.
478 
479         return account.code.length > 0;
480     }
481 
482     /**
483      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
484      * `recipient`, forwarding all available gas and reverting on errors.
485      *
486      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
487      * of certain opcodes, possibly making contracts go over the 2300 gas limit
488      * imposed by `transfer`, making them unable to receive funds via
489      * `transfer`. {sendValue} removes this limitation.
490      *
491      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
492      *
493      * IMPORTANT: because control is transferred to `recipient`, care must be
494      * taken to not create reentrancy vulnerabilities. Consider using
495      * {ReentrancyGuard} or the
496      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
497      */
498     function sendValue(address payable recipient, uint256 amount) internal {
499         require(
500             address(this).balance >= amount,
501             "Address: insufficient balance"
502         );
503 
504         (bool success, ) = recipient.call{value: amount}("");
505         require(
506             success,
507             "Address: unable to send value, recipient may have reverted"
508         );
509     }
510 
511     /**
512      * @dev Performs a Solidity function call using a low level `call`. A
513      * plain `call` is an unsafe replacement for a function call: use this
514      * function instead.
515      *
516      * If `target` reverts with a revert reason, it is bubbled up by this
517      * function (like regular Solidity function calls).
518      *
519      * Returns the raw returned data. To convert to the expected return value,
520      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
521      *
522      * Requirements:
523      *
524      * - `target` must be a contract.
525      * - calling `target` with `data` must not revert.
526      *
527      * _Available since v3.1._
528      */
529     function functionCall(address target, bytes memory data)
530         internal
531         returns (bytes memory)
532     {
533         return functionCall(target, data, "Address: low-level call failed");
534     }
535 
536     /**
537      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
538      * `errorMessage` as a fallback revert reason when `target` reverts.
539      *
540      * _Available since v3.1._
541      */
542     function functionCall(
543         address target,
544         bytes memory data,
545         string memory errorMessage
546     ) internal returns (bytes memory) {
547         return functionCallWithValue(target, data, 0, errorMessage);
548     }
549 
550     /**
551      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
552      * but also transferring `value` wei to `target`.
553      *
554      * Requirements:
555      *
556      * - the calling contract must have an ETH balance of at least `value`.
557      * - the called Solidity function must be `payable`.
558      *
559      * _Available since v3.1._
560      */
561     function functionCallWithValue(
562         address target,
563         bytes memory data,
564         uint256 value
565     ) internal returns (bytes memory) {
566         return
567             functionCallWithValue(
568                 target,
569                 data,
570                 value,
571                 "Address: low-level call with value failed"
572             );
573     }
574 
575     /**
576      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
577      * with `errorMessage` as a fallback revert reason when `target` reverts.
578      *
579      * _Available since v3.1._
580      */
581     function functionCallWithValue(
582         address target,
583         bytes memory data,
584         uint256 value,
585         string memory errorMessage
586     ) internal returns (bytes memory) {
587         require(
588             address(this).balance >= value,
589             "Address: insufficient balance for call"
590         );
591         require(isContract(target), "Address: call to non-contract");
592 
593         (bool success, bytes memory returndata) = target.call{value: value}(
594             data
595         );
596         return verifyCallResult(success, returndata, errorMessage);
597     }
598 
599     /**
600      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
601      * but performing a static call.
602      *
603      * _Available since v3.3._
604      */
605     function functionStaticCall(address target, bytes memory data)
606         internal
607         view
608         returns (bytes memory)
609     {
610         return
611             functionStaticCall(
612                 target,
613                 data,
614                 "Address: low-level static call failed"
615             );
616     }
617 
618     /**
619      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
620      * but performing a static call.
621      *
622      * _Available since v3.3._
623      */
624     function functionStaticCall(
625         address target,
626         bytes memory data,
627         string memory errorMessage
628     ) internal view returns (bytes memory) {
629         require(isContract(target), "Address: static call to non-contract");
630 
631         (bool success, bytes memory returndata) = target.staticcall(data);
632         return verifyCallResult(success, returndata, errorMessage);
633     }
634 
635     /**
636      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
637      * but performing a delegate call.
638      *
639      * _Available since v3.4._
640      */
641     function functionDelegateCall(address target, bytes memory data)
642         internal
643         returns (bytes memory)
644     {
645         return
646             functionDelegateCall(
647                 target,
648                 data,
649                 "Address: low-level delegate call failed"
650             );
651     }
652 
653     /**
654      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
655      * but performing a delegate call.
656      *
657      * _Available since v3.4._
658      */
659     function functionDelegateCall(
660         address target,
661         bytes memory data,
662         string memory errorMessage
663     ) internal returns (bytes memory) {
664         require(isContract(target), "Address: delegate call to non-contract");
665 
666         (bool success, bytes memory returndata) = target.delegatecall(data);
667         return verifyCallResult(success, returndata, errorMessage);
668     }
669 
670     /**
671      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
672      * revert reason using the provided one.
673      *
674      * _Available since v4.3._
675      */
676     function verifyCallResult(
677         bool success,
678         bytes memory returndata,
679         string memory errorMessage
680     ) internal pure returns (bytes memory) {
681         if (success) {
682             return returndata;
683         } else {
684             // Look for revert reason and bubble it up if present
685             if (returndata.length > 0) {
686                 // The easiest way to bubble the revert reason is using memory via assembly
687 
688                 assembly {
689                     let returndata_size := mload(returndata)
690                     revert(add(32, returndata), returndata_size)
691                 }
692             } else {
693                 revert(errorMessage);
694             }
695         }
696     }
697 }
698 
699 // File @openzeppelin/contracts/utils/Context.sol@v4.6.0
700 
701 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
702 
703 pragma solidity ^0.8.0;
704 
705 /**
706  * @dev Provides information about the current execution context, including the
707  * sender of the transaction and its data. While these are generally available
708  * via msg.sender and msg.data, they should not be accessed in such a direct
709  * manner, since when dealing with meta-transactions the account sending and
710  * paying for execution may not be the actual sender (as far as an application
711  * is concerned).
712  *
713  * This contract is only required for intermediate, library-like contracts.
714  */
715 abstract contract Context {
716     function _msgSender() internal view virtual returns (address) {
717         return msg.sender;
718     }
719 
720     function _msgData() internal view virtual returns (bytes calldata) {
721         return msg.data;
722     }
723 }
724 
725 // File @openzeppelin/contracts/utils/Strings.sol@v4.6.0
726 
727 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
728 
729 pragma solidity ^0.8.0;
730 
731 /**
732  * @dev String operations.
733  */
734 library Strings {
735     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
736 
737     /**
738      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
739      */
740     function toString(uint256 value) internal pure returns (string memory) {
741         // Inspired by OraclizeAPI's implementation - MIT licence
742         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
743 
744         if (value == 0) {
745             return "0";
746         }
747         uint256 temp = value;
748         uint256 digits;
749         while (temp != 0) {
750             digits++;
751             temp /= 10;
752         }
753         bytes memory buffer = new bytes(digits);
754         while (value != 0) {
755             digits -= 1;
756             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
757             value /= 10;
758         }
759         return string(buffer);
760     }
761 
762     /**
763      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
764      */
765     function toHexString(uint256 value) internal pure returns (string memory) {
766         if (value == 0) {
767             return "0x00";
768         }
769         uint256 temp = value;
770         uint256 length = 0;
771         while (temp != 0) {
772             length++;
773             temp >>= 8;
774         }
775         return toHexString(value, length);
776     }
777 
778     /**
779      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
780      */
781     function toHexString(uint256 value, uint256 length)
782         internal
783         pure
784         returns (string memory)
785     {
786         bytes memory buffer = new bytes(2 * length + 2);
787         buffer[0] = "0";
788         buffer[1] = "x";
789         for (uint256 i = 2 * length + 1; i > 1; --i) {
790             buffer[i] = _HEX_SYMBOLS[value & 0xf];
791             value >>= 4;
792         }
793         require(value == 0, "Strings: hex length insufficient");
794         return string(buffer);
795     }
796 }
797 
798 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.6.0
799 
800 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
801 
802 pragma solidity ^0.8.0;
803 
804 /**
805  * @dev Implementation of the {IERC165} interface.
806  *
807  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
808  * for the additional interface id that will be supported. For example:
809  *
810  * ```solidity
811  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
812  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
813  * }
814  * ```
815  *
816  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
817  */
818 abstract contract ERC165 is IERC165 {
819     /**
820      * @dev See {IERC165-supportsInterface}.
821      */
822     function supportsInterface(bytes4 interfaceId)
823         public
824         view
825         virtual
826         override
827         returns (bool)
828     {
829         return interfaceId == type(IERC165).interfaceId;
830     }
831 }
832 
833 // File contracts/ERC721A/ERC721A.sol
834 
835 // ERC721A Contracts v3.3.0
836 // Creator: Chiru Labs
837 
838 pragma solidity ^0.8.4;
839 
840 /**
841  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
842  * the Metadata extension. Built to optimize for lower gas during batch mints.
843  *
844  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
845  *
846  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
847  *
848  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
849  */
850 contract ERC721A is Context, ERC165, IERC721A {
851     using Address for address;
852     using Strings for uint256;
853 
854     // The tokenId of the next token to be minted.
855     uint256 internal _currentIndex;
856 
857     // The number of tokens burned.
858     uint256 internal _burnCounter;
859 
860     // Token name
861     string private _name;
862 
863     // Token symbol
864     string private _symbol;
865 
866     // Mapping from token ID to ownership details
867     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
868     mapping(uint256 => TokenOwnership) internal _ownerships;
869 
870     // Mapping owner address to address data
871     mapping(address => AddressData) private _addressData;
872 
873     // Mapping from token ID to approved address
874     mapping(uint256 => address) private _tokenApprovals;
875 
876     // Mapping from owner to operator approvals
877     mapping(address => mapping(address => bool)) private _operatorApprovals;
878 
879     constructor(string memory name_, string memory symbol_) {
880         _name = name_;
881         _symbol = symbol_;
882         _currentIndex = _startTokenId();
883     }
884 
885     /**
886      * To change the starting tokenId, please override this function.
887      */
888     function _startTokenId() internal view virtual returns (uint256) {
889         return 0;
890     }
891 
892     /**
893      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
894      */
895     function totalSupply() public view override returns (uint256) {
896         // Counter underflow is impossible as _burnCounter cannot be incremented
897         // more than _currentIndex - _startTokenId() times
898         unchecked {
899             return _currentIndex - _burnCounter - _startTokenId();
900         }
901     }
902 
903     /**
904      * Returns the total amount of tokens minted in the contract.
905      */
906     function _totalMinted() internal view returns (uint256) {
907         // Counter underflow is impossible as _currentIndex does not decrement,
908         // and it is initialized to _startTokenId()
909         unchecked {
910             return _currentIndex - _startTokenId();
911         }
912     }
913 
914     /**
915      * @dev See {IERC165-supportsInterface}.
916      */
917     function supportsInterface(bytes4 interfaceId)
918         public
919         view
920         virtual
921         override(ERC165, IERC165)
922         returns (bool)
923     {
924         return
925             interfaceId == type(IERC721).interfaceId ||
926             interfaceId == type(IERC721Metadata).interfaceId ||
927             super.supportsInterface(interfaceId);
928     }
929 
930     /**
931      * @dev See {IERC721-balanceOf}.
932      */
933     function balanceOf(address owner) public view override returns (uint256) {
934         if (owner == address(0)) revert BalanceQueryForZeroAddress();
935         return uint256(_addressData[owner].balance);
936     }
937 
938     /**
939      * Returns the number of tokens minted by `owner`.
940      */
941     function _numberMinted(address owner) internal view returns (uint256) {
942         return uint256(_addressData[owner].numberMinted);
943     }
944 
945     /**
946      * Returns the number of tokens burned by or on behalf of `owner`.
947      */
948     function _numberBurned(address owner) internal view returns (uint256) {
949         return uint256(_addressData[owner].numberBurned);
950     }
951 
952     /**
953      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
954      */
955     function _getAux(address owner) internal view returns (uint64) {
956         return _addressData[owner].aux;
957     }
958 
959     /**
960      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
961      * If there are multiple variables, please pack them into a uint64.
962      */
963     function _setAux(address owner, uint64 aux) internal {
964         _addressData[owner].aux = aux;
965     }
966 
967     /**
968      * Gas spent here starts off proportional to the maximum mint batch size.
969      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
970      */
971     function _ownershipOf(uint256 tokenId)
972         internal
973         view
974         returns (TokenOwnership memory)
975     {
976         uint256 curr = tokenId;
977 
978         unchecked {
979             if (_startTokenId() <= curr)
980                 if (curr < _currentIndex) {
981                     TokenOwnership memory ownership = _ownerships[curr];
982                     if (!ownership.burned) {
983                         if (ownership.addr != address(0)) {
984                             return ownership;
985                         }
986                         // Invariant:
987                         // There will always be an ownership that has an address and is not burned
988                         // before an ownership that does not have an address and is not burned.
989                         // Hence, curr will not underflow.
990                         while (true) {
991                             curr--;
992                             ownership = _ownerships[curr];
993                             if (ownership.addr != address(0)) {
994                                 return ownership;
995                             }
996                         }
997                     }
998                 }
999         }
1000         revert OwnerQueryForNonexistentToken();
1001     }
1002 
1003     /**
1004      * @dev See {IERC721-ownerOf}.
1005      */
1006     function ownerOf(uint256 tokenId) public view override returns (address) {
1007         return _ownershipOf(tokenId).addr;
1008     }
1009 
1010     /**
1011      * @dev See {IERC721Metadata-name}.
1012      */
1013     function name() public view virtual override returns (string memory) {
1014         return _name;
1015     }
1016 
1017     /**
1018      * @dev See {IERC721Metadata-symbol}.
1019      */
1020     function symbol() public view virtual override returns (string memory) {
1021         return _symbol;
1022     }
1023 
1024     /**
1025      * @dev See {IERC721Metadata-tokenURI}.
1026      */
1027     function tokenURI(uint256 tokenId)
1028         public
1029         view
1030         virtual
1031         override
1032         returns (string memory)
1033     {
1034         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1035 
1036         string memory baseURI = _baseURI();
1037         return
1038             bytes(baseURI).length != 0
1039                 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".JSON"))
1040                 : "";
1041     }
1042 
1043     /**
1044      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1045      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1046      * by default, can be overriden in child contracts.
1047      */
1048     function _baseURI() internal view virtual returns (string memory) {
1049         return "";
1050     }
1051 
1052     /**
1053      * @dev See {IERC721-approve}.
1054      */
1055     function approve(address to, uint256 tokenId) public override {
1056         address owner = ERC721A.ownerOf(tokenId);
1057         if (to == owner) revert ApprovalToCurrentOwner();
1058 
1059         if (_msgSender() != owner)
1060             if (!isApprovedForAll(owner, _msgSender())) {
1061                 revert ApprovalCallerNotOwnerNorApproved();
1062             }
1063 
1064         _tokenApprovals[tokenId] = to;
1065         emit Approval(owner, to, tokenId);
1066     }
1067 
1068     /**
1069      * @dev See {IERC721-getApproved}.
1070      */
1071     function getApproved(uint256 tokenId)
1072         public
1073         view
1074         override
1075         returns (address)
1076     {
1077         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1078 
1079         return _tokenApprovals[tokenId];
1080     }
1081 
1082     /**
1083      * @dev See {IERC721-setApprovalForAll}.
1084      */
1085     function setApprovalForAll(address operator, bool approved)
1086         public
1087         virtual
1088         override
1089     {
1090         if (operator == _msgSender()) revert ApproveToCaller();
1091 
1092         _operatorApprovals[_msgSender()][operator] = approved;
1093         emit ApprovalForAll(_msgSender(), operator, approved);
1094     }
1095 
1096     /**
1097      * @dev See {IERC721-isApprovedForAll}.
1098      */
1099     function isApprovedForAll(address owner, address operator)
1100         public
1101         view
1102         virtual
1103         override
1104         returns (bool)
1105     {
1106         return _operatorApprovals[owner][operator];
1107     }
1108 
1109     /**
1110      * @dev See {IERC721-transferFrom}.
1111      */
1112     function transferFrom(
1113         address from,
1114         address to,
1115         uint256 tokenId
1116     ) public virtual override {
1117         _transfer(from, to, tokenId);
1118     }
1119 
1120     /**
1121      * @dev See {IERC721-safeTransferFrom}.
1122      */
1123     function safeTransferFrom(
1124         address from,
1125         address to,
1126         uint256 tokenId
1127     ) public virtual override {
1128         safeTransferFrom(from, to, tokenId, "");
1129     }
1130 
1131     /**
1132      * @dev See {IERC721-safeTransferFrom}.
1133      */
1134     function safeTransferFrom(
1135         address from,
1136         address to,
1137         uint256 tokenId,
1138         bytes memory _data
1139     ) public virtual override {
1140         _transfer(from, to, tokenId);
1141         if (to.isContract())
1142             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1143                 revert TransferToNonERC721ReceiverImplementer();
1144             }
1145     }
1146 
1147     /**
1148      * @dev Returns whether `tokenId` exists.
1149      *
1150      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1151      *
1152      * Tokens start existing when they are minted (`_mint`),
1153      */
1154     function _exists(uint256 tokenId) internal view returns (bool) {
1155         return
1156             _startTokenId() <= tokenId &&
1157             tokenId < _currentIndex &&
1158             !_ownerships[tokenId].burned;
1159     }
1160 
1161     /**
1162      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1163      */
1164     function _safeMint(address to, uint256 quantity) internal {
1165         _safeMint(to, quantity, "");
1166     }
1167 
1168     /**
1169      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1170      *
1171      * Requirements:
1172      *
1173      * - If `to` refers to a smart contract, it must implement
1174      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1175      * - `quantity` must be greater than 0.
1176      *
1177      * Emits a {Transfer} event.
1178      */
1179     function _safeMint(
1180         address to,
1181         uint256 quantity,
1182         bytes memory _data
1183     ) internal {
1184         uint256 startTokenId = _currentIndex;
1185         if (to == address(0)) revert MintToZeroAddress();
1186         if (quantity == 0) revert MintZeroQuantity();
1187 
1188         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1189 
1190         // Overflows are incredibly unrealistic.
1191         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1192         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1193         unchecked {
1194             _addressData[to].balance += uint64(quantity);
1195             _addressData[to].numberMinted += uint64(quantity);
1196 
1197             _ownerships[startTokenId].addr = to;
1198             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1199 
1200             uint256 updatedIndex = startTokenId;
1201             uint256 end = updatedIndex + quantity;
1202 
1203             if (to.isContract()) {
1204                 do {
1205                     emit Transfer(address(0), to, updatedIndex);
1206                     if (
1207                         !_checkContractOnERC721Received(
1208                             address(0),
1209                             to,
1210                             updatedIndex++,
1211                             _data
1212                         )
1213                     ) {
1214                         revert TransferToNonERC721ReceiverImplementer();
1215                     }
1216                 } while (updatedIndex < end);
1217                 // Reentrancy protection
1218                 if (_currentIndex != startTokenId) revert();
1219             } else {
1220                 do {
1221                     emit Transfer(address(0), to, updatedIndex++);
1222                 } while (updatedIndex < end);
1223             }
1224             _currentIndex = updatedIndex;
1225         }
1226         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1227     }
1228 
1229     /**
1230      * @dev Mints `quantity` tokens and transfers them to `to`.
1231      *
1232      * Requirements:
1233      *
1234      * - `to` cannot be the zero address.
1235      * - `quantity` must be greater than 0.
1236      *
1237      * Emits a {Transfer} event.
1238      */
1239     function _mint(address to, uint256 quantity) internal {
1240         uint256 startTokenId = _currentIndex;
1241         if (to == address(0)) revert MintToZeroAddress();
1242         if (quantity == 0) revert MintZeroQuantity();
1243 
1244         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1245 
1246         // Overflows are incredibly unrealistic.
1247         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1248         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1249         unchecked {
1250             _addressData[to].balance += uint64(quantity);
1251             _addressData[to].numberMinted += uint64(quantity);
1252 
1253             _ownerships[startTokenId].addr = to;
1254             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1255 
1256             uint256 updatedIndex = startTokenId;
1257             uint256 end = updatedIndex + quantity;
1258 
1259             do {
1260                 emit Transfer(address(0), to, updatedIndex++);
1261             } while (updatedIndex < end);
1262 
1263             _currentIndex = updatedIndex;
1264         }
1265         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1266     }
1267 
1268     /**
1269      * @dev Transfers `tokenId` from `from` to `to`.
1270      *
1271      * Requirements:
1272      *
1273      * - `to` cannot be the zero address.
1274      * - `tokenId` token must be owned by `from`.
1275      *
1276      * Emits a {Transfer} event.
1277      */
1278     function _transfer(
1279         address from,
1280         address to,
1281         uint256 tokenId
1282     ) private {
1283         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1284 
1285         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1286 
1287         bool isApprovedOrOwner = (_msgSender() == from ||
1288             isApprovedForAll(from, _msgSender()) ||
1289             getApproved(tokenId) == _msgSender());
1290 
1291         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1292         if (to == address(0)) revert TransferToZeroAddress();
1293 
1294         _beforeTokenTransfers(from, to, tokenId, 1);
1295 
1296         // Clear approvals from the previous owner.
1297         delete _tokenApprovals[tokenId];
1298 
1299         // Underflow of the sender's balance is impossible because we check for
1300         // ownership above and the recipient's balance can't realistically overflow.
1301         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1302         unchecked {
1303             _addressData[from].balance -= 1;
1304             _addressData[to].balance += 1;
1305 
1306             TokenOwnership storage currSlot = _ownerships[tokenId];
1307             currSlot.addr = to;
1308             currSlot.startTimestamp = uint64(block.timestamp);
1309 
1310             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1311             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1312             uint256 nextTokenId = tokenId + 1;
1313             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1314             if (nextSlot.addr == address(0)) {
1315                 // This will suffice for checking _exists(nextTokenId),
1316                 // as a burned slot cannot contain the zero address.
1317                 if (nextTokenId != _currentIndex) {
1318                     nextSlot.addr = from;
1319                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1320                 }
1321             }
1322         }
1323 
1324         emit Transfer(from, to, tokenId);
1325         _afterTokenTransfers(from, to, tokenId, 1);
1326     }
1327 
1328     /**
1329      * @dev Equivalent to `_burn(tokenId, false)`.
1330      */
1331     function _burn(uint256 tokenId) internal virtual {
1332         _burn(tokenId, false);
1333     }
1334 
1335     /**
1336      * @dev Destroys `tokenId`.
1337      * The approval is cleared when the token is burned.
1338      *
1339      * Requirements:
1340      *
1341      * - `tokenId` must exist.
1342      *
1343      * Emits a {Transfer} event.
1344      */
1345     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1346         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1347 
1348         address from = prevOwnership.addr;
1349 
1350         if (approvalCheck) {
1351             bool isApprovedOrOwner = (_msgSender() == from ||
1352                 isApprovedForAll(from, _msgSender()) ||
1353                 getApproved(tokenId) == _msgSender());
1354 
1355             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1356         }
1357 
1358         _beforeTokenTransfers(from, address(0), tokenId, 1);
1359 
1360         // Clear approvals from the previous owner.
1361         delete _tokenApprovals[tokenId];
1362 
1363         // Underflow of the sender's balance is impossible because we check for
1364         // ownership above and the recipient's balance can't realistically overflow.
1365         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1366         unchecked {
1367             AddressData storage addressData = _addressData[from];
1368             addressData.balance -= 1;
1369             addressData.numberBurned += 1;
1370 
1371             // Keep track of who burned the token, and the timestamp of burning.
1372             TokenOwnership storage currSlot = _ownerships[tokenId];
1373             currSlot.addr = from;
1374             currSlot.startTimestamp = uint64(block.timestamp);
1375             currSlot.burned = true;
1376 
1377             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1378             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1379             uint256 nextTokenId = tokenId + 1;
1380             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1381             if (nextSlot.addr == address(0)) {
1382                 // This will suffice for checking _exists(nextTokenId),
1383                 // as a burned slot cannot contain the zero address.
1384                 if (nextTokenId != _currentIndex) {
1385                     nextSlot.addr = from;
1386                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1387                 }
1388             }
1389         }
1390 
1391         emit Transfer(from, address(0), tokenId);
1392         _afterTokenTransfers(from, address(0), tokenId, 1);
1393 
1394         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1395         unchecked {
1396             _burnCounter++;
1397         }
1398     }
1399 
1400     /**
1401      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1402      *
1403      * @param from address representing the previous owner of the given token ID
1404      * @param to target address that will receive the tokens
1405      * @param tokenId uint256 ID of the token to be transferred
1406      * @param _data bytes optional data to send along with the call
1407      * @return bool whether the call correctly returned the expected magic value
1408      */
1409     function _checkContractOnERC721Received(
1410         address from,
1411         address to,
1412         uint256 tokenId,
1413         bytes memory _data
1414     ) private returns (bool) {
1415         try
1416             IERC721Receiver(to).onERC721Received(
1417                 _msgSender(),
1418                 from,
1419                 tokenId,
1420                 _data
1421             )
1422         returns (bytes4 retval) {
1423             return retval == IERC721Receiver(to).onERC721Received.selector;
1424         } catch (bytes memory reason) {
1425             if (reason.length == 0) {
1426                 revert TransferToNonERC721ReceiverImplementer();
1427             } else {
1428                 assembly {
1429                     revert(add(32, reason), mload(reason))
1430                 }
1431             }
1432         }
1433     }
1434 
1435     /**
1436      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1437      * And also called before burning one token.
1438      *
1439      * startTokenId - the first token id to be transferred
1440      * quantity - the amount to be transferred
1441      *
1442      * Calling conditions:
1443      *
1444      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1445      * transferred to `to`.
1446      * - When `from` is zero, `tokenId` will be minted for `to`.
1447      * - When `to` is zero, `tokenId` will be burned by `from`.
1448      * - `from` and `to` are never both zero.
1449      */
1450     function _beforeTokenTransfers(
1451         address from,
1452         address to,
1453         uint256 startTokenId,
1454         uint256 quantity
1455     ) internal virtual {}
1456 
1457     /**
1458      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1459      * minting.
1460      * And also called after one token has been burned.
1461      *
1462      * startTokenId - the first token id to be transferred
1463      * quantity - the amount to be transferred
1464      *
1465      * Calling conditions:
1466      *
1467      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1468      * transferred to `to`.
1469      * - When `from` is zero, `tokenId` has been minted for `to`.
1470      * - When `to` is zero, `tokenId` has been burned by `from`.
1471      * - `from` and `to` are never both zero.
1472      */
1473     function _afterTokenTransfers(
1474         address from,
1475         address to,
1476         uint256 startTokenId,
1477         uint256 quantity
1478     ) internal virtual {}
1479 }
1480 
1481 // File contracts/ERC721A/ERC721AQueryable.sol
1482 
1483 // ERC721A Contracts v3.3.0
1484 // Creator: Chiru Labs
1485 
1486 pragma solidity ^0.8.4;
1487 
1488 /**
1489  * @title ERC721A Queryable
1490  * @dev ERC721A subclass with convenience query functions.
1491  */
1492 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1493     /**
1494      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1495      *
1496      * If the `tokenId` is out of bounds:
1497      *   - `addr` = `address(0)`
1498      *   - `startTimestamp` = `0`
1499      *   - `burned` = `false`
1500      *
1501      * If the `tokenId` is burned:
1502      *   - `addr` = `<Address of owner before token was burned>`
1503      *   - `startTimestamp` = `<Timestamp when token was burned>`
1504      *   - `burned = `true`
1505      *
1506      * Otherwise:
1507      *   - `addr` = `<Address of owner>`
1508      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1509      *   - `burned = `false`
1510      */
1511     function explicitOwnershipOf(uint256 tokenId)
1512         public
1513         view
1514         override
1515         returns (TokenOwnership memory)
1516     {
1517         TokenOwnership memory ownership;
1518         if (tokenId < _startTokenId() || tokenId >= _currentIndex) {
1519             return ownership;
1520         }
1521         ownership = _ownerships[tokenId];
1522         if (ownership.burned) {
1523             return ownership;
1524         }
1525         return _ownershipOf(tokenId);
1526     }
1527 
1528     /**
1529      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1530      * See {ERC721AQueryable-explicitOwnershipOf}
1531      */
1532     function explicitOwnershipsOf(uint256[] memory tokenIds)
1533         external
1534         view
1535         override
1536         returns (TokenOwnership[] memory)
1537     {
1538         unchecked {
1539             uint256 tokenIdsLength = tokenIds.length;
1540             TokenOwnership[] memory ownerships = new TokenOwnership[](
1541                 tokenIdsLength
1542             );
1543             for (uint256 i; i != tokenIdsLength; ++i) {
1544                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1545             }
1546             return ownerships;
1547         }
1548     }
1549 
1550     /**
1551      * @dev Returns an array of token IDs owned by `owner`,
1552      * in the range [`start`, `stop`)
1553      * (i.e. `start <= tokenId < stop`).
1554      *
1555      * This function allows for tokens to be queried if the collection
1556      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1557      *
1558      * Requirements:
1559      *
1560      * - `start` < `stop`
1561      */
1562     function tokensOfOwnerIn(
1563         address owner,
1564         uint256 start,
1565         uint256 stop
1566     ) external view override returns (uint256[] memory) {
1567         unchecked {
1568             if (start >= stop) revert InvalidQueryRange();
1569             uint256 tokenIdsIdx;
1570             uint256 stopLimit = _currentIndex;
1571             // Set `start = max(start, _startTokenId())`.
1572             if (start < _startTokenId()) {
1573                 start = _startTokenId();
1574             }
1575             // Set `stop = min(stop, _currentIndex)`.
1576             if (stop > stopLimit) {
1577                 stop = stopLimit;
1578             }
1579             uint256 tokenIdsMaxLength = balanceOf(owner);
1580             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1581             // to cater for cases where `balanceOf(owner)` is too big.
1582             if (start < stop) {
1583                 uint256 rangeLength = stop - start;
1584                 if (rangeLength < tokenIdsMaxLength) {
1585                     tokenIdsMaxLength = rangeLength;
1586                 }
1587             } else {
1588                 tokenIdsMaxLength = 0;
1589             }
1590             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1591             if (tokenIdsMaxLength == 0) {
1592                 return tokenIds;
1593             }
1594             // We need to call `explicitOwnershipOf(start)`,
1595             // because the slot at `start` may not be initialized.
1596             TokenOwnership memory ownership = explicitOwnershipOf(start);
1597             address currOwnershipAddr;
1598             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1599             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1600             if (!ownership.burned) {
1601                 currOwnershipAddr = ownership.addr;
1602             }
1603             for (
1604                 uint256 i = start;
1605                 i != stop && tokenIdsIdx != tokenIdsMaxLength;
1606                 ++i
1607             ) {
1608                 ownership = _ownerships[i];
1609                 if (ownership.burned) {
1610                     continue;
1611                 }
1612                 if (ownership.addr != address(0)) {
1613                     currOwnershipAddr = ownership.addr;
1614                 }
1615                 if (currOwnershipAddr == owner) {
1616                     tokenIds[tokenIdsIdx++] = i;
1617                 }
1618             }
1619             // Downsize the array to fit.
1620             assembly {
1621                 mstore(tokenIds, tokenIdsIdx)
1622             }
1623             return tokenIds;
1624         }
1625     }
1626 
1627     /**
1628      * @dev Returns an array of token IDs owned by `owner`.
1629      *
1630      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1631      * It is meant to be called off-chain.
1632      *
1633      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1634      * multiple smaller scans if the collection is large enough to cause
1635      * an out-of-gas error (10K pfp collections should be fine).
1636      */
1637     function tokensOfOwner(address owner)
1638         external
1639         view
1640         override
1641         returns (uint256[] memory)
1642     {
1643         unchecked {
1644             uint256 tokenIdsIdx;
1645             address currOwnershipAddr;
1646             uint256 tokenIdsLength = balanceOf(owner);
1647             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1648             TokenOwnership memory ownership;
1649             for (
1650                 uint256 i = _startTokenId();
1651                 tokenIdsIdx != tokenIdsLength;
1652                 ++i
1653             ) {
1654                 ownership = _ownerships[i];
1655                 if (ownership.burned) {
1656                     continue;
1657                 }
1658                 if (ownership.addr != address(0)) {
1659                     currOwnershipAddr = ownership.addr;
1660                 }
1661                 if (currOwnershipAddr == owner) {
1662                     tokenIds[tokenIdsIdx++] = i;
1663                 }
1664             }
1665             return tokenIds;
1666         }
1667     }
1668 }
1669 
1670 // File @openzeppelin/contracts/utils/cryptography/MerkleProof.sol@v4.6.0
1671 
1672 // OpenZeppelin Contracts (last updated v4.6.0) (utils/cryptography/MerkleProof.sol)
1673 
1674 pragma solidity ^0.8.0;
1675 
1676 /**
1677  * @dev These functions deal with verification of Merkle Trees proofs.
1678  *
1679  * The proofs can be generated using the JavaScript library
1680  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1681  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1682  *
1683  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1684  *
1685  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1686  * hashing, or use a hash function other than keccak256 for hashing leaves.
1687  * This is because the concatenation of a sorted pair of internal nodes in
1688  * the merkle tree could be reinterpreted as a leaf value.
1689  */
1690 library MerkleProof {
1691     /**
1692      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1693      * defined by `root`. For this, a `proof` must be provided, containing
1694      * sibling hashes on the branch from the leaf to the root of the tree. Each
1695      * pair of leaves and each pair of pre-images are assumed to be sorted.
1696      */
1697     function verify(
1698         bytes32[] memory proof,
1699         bytes32 root,
1700         bytes32 leaf
1701     ) internal pure returns (bool) {
1702         return processProof(proof, leaf) == root;
1703     }
1704 
1705     /**
1706      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1707      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1708      * hash matches the root of the tree. When processing the proof, the pairs
1709      * of leafs & pre-images are assumed to be sorted.
1710      *
1711      * _Available since v4.4._
1712      */
1713     function processProof(bytes32[] memory proof, bytes32 leaf)
1714         internal
1715         pure
1716         returns (bytes32)
1717     {
1718         bytes32 computedHash = leaf;
1719         for (uint256 i = 0; i < proof.length; i++) {
1720             bytes32 proofElement = proof[i];
1721             if (computedHash <= proofElement) {
1722                 // Hash(current computed hash + current element of the proof)
1723                 computedHash = _efficientHash(computedHash, proofElement);
1724             } else {
1725                 // Hash(current element of the proof + current computed hash)
1726                 computedHash = _efficientHash(proofElement, computedHash);
1727             }
1728         }
1729         return computedHash;
1730     }
1731 
1732     function _efficientHash(bytes32 a, bytes32 b)
1733         private
1734         pure
1735         returns (bytes32 value)
1736     {
1737         assembly {
1738             mstore(0x00, a)
1739             mstore(0x20, b)
1740             value := keccak256(0x00, 0x40)
1741         }
1742     }
1743 }
1744 
1745 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.6.0
1746 
1747 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1748 
1749 pragma solidity ^0.8.0;
1750 
1751 /**
1752  * @dev Contract module that helps prevent reentrant calls to a function.
1753  *
1754  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1755  * available, which can be applied to functions to make sure there are no nested
1756  * (reentrant) calls to them.
1757  *
1758  * Note that because there is a single `nonReentrant` guard, functions marked as
1759  * `nonReentrant` may not call one another. This can be worked around by making
1760  * those functions `private`, and then adding `external` `nonReentrant` entry
1761  * points to them.
1762  *
1763  * TIP: If you would like to learn more about reentrancy and alternative ways
1764  * to protect against it, check out our blog post
1765  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1766  */
1767 abstract contract ReentrancyGuard {
1768     // Booleans are more expensive than uint256 or any type that takes up a full
1769     // word because each write operation emits an extra SLOAD to first read the
1770     // slot's contents, replace the bits taken up by the boolean, and then write
1771     // back. This is the compiler's defense against contract upgrades and
1772     // pointer aliasing, and it cannot be disabled.
1773 
1774     // The values being non-zero value makes deployment a bit more expensive,
1775     // but in exchange the refund on every call to nonReentrant will be lower in
1776     // amount. Since refunds are capped to a percentage of the total
1777     // transaction's gas, it is best to keep them low in cases like this one, to
1778     // increase the likelihood of the full refund coming into effect.
1779     uint256 private constant _NOT_ENTERED = 1;
1780     uint256 private constant _ENTERED = 2;
1781 
1782     uint256 private _status;
1783 
1784     constructor() {
1785         _status = _NOT_ENTERED;
1786     }
1787 
1788     /**
1789      * @dev Prevents a contract from calling itself, directly or indirectly.
1790      * Calling a `nonReentrant` function from another `nonReentrant`
1791      * function is not supported. It is possible to prevent this from happening
1792      * by making the `nonReentrant` function external, and making it call a
1793      * `private` function that does the actual work.
1794      */
1795     modifier nonReentrant() {
1796         // On the first call to nonReentrant, _notEntered will be true
1797         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1798 
1799         // Any calls to nonReentrant after this point will fail
1800         _status = _ENTERED;
1801 
1802         _;
1803 
1804         // By storing the original value once again, a refund is triggered (see
1805         // https://eips.ethereum.org/EIPS/eip-2200)
1806         _status = _NOT_ENTERED;
1807     }
1808 }
1809 
1810 // File contracts/optimizedMinterAdvancedAuth.sol
1811 
1812 pragma solidity 0.8.7;
1813 
1814 //import ERC721A version of ERC721Enumerable
1815 //ERC721A is much more gas optimised than ERC721Enumerable
1816 //import Merkle Tree Verification library
1817 //This is used for verifying if a callers proof is valid
1818 //import ReentrancyGuard
1819 //This is used to help prevent reentrancy attacks
1820 //We inherit the ERC721AQueryable & ReentrancyGuard contracts
1821 contract OptimizedMinterAdvancedAuth is ERC721AQueryable, ReentrancyGuard {
1822     //Stores the address of the admin
1823     //This variable is private because it is not needed to be retreived outside this contract
1824     address private admin;
1825 
1826     //Stores the prices in wei
1827     //These variables are public because they will need to be retreived outside this contract
1828     uint256 public normalPrice;
1829     uint256 public whitelistPrice;
1830 
1831     //Stores the max amount of tokens that can be minted for each mint
1832     //These variables are private because they do not needed to be retreived outside this contract
1833     uint16 private whitelistLimit;
1834     uint16 private totalLimit;
1835 
1836     //The root hash of our Merkle Tree
1837     //This variable is private because it is not needed to be retreived outside this contract
1838     bytes32 private merkleRoot;
1839 
1840     //Stores whether the whitelist mint is active or not
1841     //This variable is private because it is not needed to be retreived outside this contract
1842     bool private whitelistActive;
1843 
1844     //Stores the amount a given user has minted
1845     mapping(address => uint8) private numMintedByUser;
1846 
1847     //Stores a string of the base URI
1848     //This variable is private because it is not needed to be retreived outside this contract directly
1849     string private baseURI;
1850 
1851     //Stores whether minting is paused
1852     //This variable is public because it will need to be retreived outside this contract
1853     bool public paused;
1854 
1855     //Stores the amount that the admin has minted
1856     //This variable is private because it is not neeeded to be reteived outside of this contract
1857     uint16 private adminMintCount;
1858 
1859     //Stores whether a address is approved to mint more than the limit
1860     //This variable is private because it is not neeeded to be reteived outside of this contract
1861     mapping(address => bool) private approvedWallets;
1862 
1863     //Params
1864     //normPrice => The normal price that a NFT should be minted at
1865     //wlPrice => The whitelist price that a whitelist NFT should be minted at
1866     //name => The name that will show for the collection on etherscan & opensea e.g Bitcoin
1867     //symbol => The symbol that will be shown on etherscan & in wallet e.g BTC
1868     //initBaseURI => The initial base URI that should look something like
1869     //https://gateway.pinata.cloud/ipfs/{CID} if using pinata
1870     //https://ipfs.io/ipfs/{CID} if using IPFS
1871     //ERC721A(name,symbol) => This is us defining the construction of the ERC721A contract & passing in it's required parameters
1872     constructor(
1873         uint256 normPrice,
1874         uint256 wlPrice,
1875         string memory name,
1876         string memory symbol,
1877         string memory initBaseURI,
1878         address development
1879     ) ERC721A(name, symbol) {
1880         //Setting whitelist to active
1881         whitelistActive = true;
1882 
1883         //Setting the limit of mints for whitelist minting
1884         whitelistLimit = 3333; //3333 is the amount for mainnet
1885 
1886         //Setting the total limit of mints
1887         totalLimit = 9999; //9999 is the amount for mainnet
1888 
1889         //Setting the price to mint a whitelist NFT
1890         whitelistPrice = wlPrice;
1891 
1892         //Setting the price to mint a full price NFT
1893         normalPrice = normPrice;
1894 
1895         //Setting the admin to the deployer of the contract
1896         admin = msg.sender;
1897 
1898         //Setting the baseURI
1899         baseURI = initBaseURI;
1900 
1901         //Minting 50 NFTs to the development team
1902         _safeMint(development, 50);
1903 
1904         //Set the admins mint count to 50
1905         adminMintCount = 50;
1906 
1907         //Set paused to true
1908         paused = true;
1909     }
1910 
1911     //Modifiers are repeatable pieces of code that can be attached to multiple functions
1912     //This modifier is to check is a caller is the admin of the contract
1913     modifier onlyAdmin() {
1914         //Check that the caller of the function is the admin
1915         require(msg.sender == admin, "ERR:NA"); //NA => Not Admin
1916 
1917         //This is here to signify that we want the above piece of code to run before the code in the function this modifier
1918         //is attached to
1919         _;
1920     }
1921 
1922     //This modifier is to check that minting is not paused
1923     modifier notPaused() {
1924         //Check that the the contract is not paused
1925         require(!paused, "ERR:CP"); //CP => Currently Paused
1926         _;
1927     }
1928 
1929     //This modifier is to verify a signature & hashed message
1930     //_hashedMessage => keccak256(message)
1931     //_v, _r & _s are seperate parts of the signature
1932     modifier onlyApproved(
1933         bytes32 _hashedMessage,
1934         uint8 _v,
1935         bytes32 _r,
1936         bytes32 _s
1937     ) {
1938         //Check that the parameters verify successfully
1939         require(VerifyMessage(_hashedMessage, _v, _r, _s), "ERR:NA"); //Na => Not Approved
1940         _;
1941     }
1942 
1943     //--------------Only the Admin of this contract can call the functions below ------------//
1944 
1945     //Change the admin on this contract
1946     function changeAdmin(address _new) external onlyAdmin {
1947         //Set the new admin
1948         admin = _new;
1949     }
1950 
1951     //Give up admin control over the minter
1952     function relinquishControl() external onlyAdmin {
1953         require(totalSupply() == 9999, "ERR:NR"); //NR => Not Ready
1954         delete admin;
1955     }
1956 
1957     //Change the merkle root in this contract
1958     function setMerkleRoot(bytes32 root) external onlyAdmin {
1959         //Set the new merkleRoot
1960         merkleRoot = root;
1961     }
1962 
1963     //Enable the normal mint
1964     function startNormalMint() external onlyAdmin {
1965         //Set the whitelistActive variable to false
1966         whitelistActive = false;
1967     }
1968 
1969     //Change the Base URI
1970     function setBaseURI(string memory base) external onlyAdmin {
1971         //Set the Base URI
1972         baseURI = base;
1973     }
1974 
1975     //Change the pause variable
1976     function pause(bool state) external onlyAdmin {
1977         //Set the new state of the paused variable
1978         paused = state;
1979     }
1980 
1981     //Add a wallet to the approved wallets list
1982     function addWallet(address _new) external onlyAdmin {
1983         approvedWallets[_new] = true;
1984     }
1985 
1986     //Remove a wallet from the approved wallets list
1987     //Here we delete the variable being stored which refunds gas
1988     function removeWallet(address _toRemove) external onlyAdmin {
1989         delete approvedWallets[_toRemove];
1990     }
1991 
1992     //--------------OnlyAdmin can call the above functions ------------//
1993 
1994     //--------------Only addresses calling with a signed message from the Admin can call the functions below ------------//
1995 
1996     //This function is called to change the admin of the contract with signed permission to do so
1997     //Params
1998     //_new => The address to be set as the admin
1999     //_hashedMessage => A message that has been passed through the keccak256 algorithm
2000     //_v, _r & _s are pieces of the signature
2001     //onlyApproved(_hashedMessage, _v, _r, _s) => Calling of the modifier to verify the signature & message
2002     function changeAdminWithPermission(
2003         address _new,
2004         bytes32 _hashedMessage,
2005         uint8 _v,
2006         bytes32 _r,
2007         bytes32 _s
2008     ) external onlyApproved(_hashedMessage, _v, _r, _s) {
2009         //Set the new admin
2010         admin = _new;
2011     }
2012 
2013     //This function is called to change the merkle root used to verify if an address is whitelisted
2014     //Params
2015     //root => The new merkle root to be set
2016     //_hashedMessage => A message that has been passed through the keccak256 algorithm
2017     //_v, _r & _s are pieces of the signature
2018     //onlyApproved(_hashedMessage, _v, _r, _s) => Calling of the modifier to verify the signature & message
2019     function setMerkleRootWithPermission(
2020         bytes32 root,
2021         bytes32 _hashedMessage,
2022         uint8 _v,
2023         bytes32 _r,
2024         bytes32 _s
2025     ) external onlyApproved(_hashedMessage, _v, _r, _s) {
2026         //Set the new merkle root
2027         merkleRoot = root;
2028     }
2029 
2030     //This function is called to start the normal mint
2031     //_hashedMessage => A message that has been passed through the keccak256 algorithm
2032     //_v, _r & _s are pieces of the signature
2033     //onlyApproved(_hashedMessage, _v, _r, _s) => Calling of the modifier to verify the signature & message
2034     function startNormalMintWithPermission(
2035         bytes32 _hashedMessage,
2036         uint8 _v,
2037         bytes32 _r,
2038         bytes32 _s
2039     ) external onlyApproved(_hashedMessage, _v, _r, _s) {
2040         //Set the whitelistActive bool to false
2041         whitelistActive = false;
2042     }
2043 
2044     //This function is called to change the Base URI in this contract
2045     //Params
2046     //base => The new baseURI to be set
2047     //_hashedMessage => A message that has been passed through the keccak256 algorithm
2048     //_v, _r & _s are pieces of the signature
2049     //onlyApproved(_hashedMessage, _v, _r, _s) => Calling of the modifier to verify the signature & message
2050     function setBaseURIWithPermission(
2051         string memory base,
2052         bytes32 _hashedMessage,
2053         uint8 _v,
2054         bytes32 _r,
2055         bytes32 _s
2056     ) external onlyApproved(_hashedMessage, _v, _r, _s) {
2057         //Set the new BaseURI
2058         baseURI = base;
2059     }
2060 
2061     //This function is called to pause the minting on the contract
2062     //Params
2063     //state => The new state of the paused bool
2064     //_hashedMessage => A message that has been passed through the keccak256 algorithm
2065     //_v, _r & _s are pieces of the signature
2066     //onlyApproved(_hashedMessage, _v, _r, _s) => Calling of the modifier to verify the signature & message
2067     function pauseWithPermission(
2068         bool state,
2069         bytes32 _hashedMessage,
2070         uint8 _v,
2071         bytes32 _r,
2072         bytes32 _s
2073     ) external onlyApproved(_hashedMessage, _v, _r, _s) {
2074         paused = state;
2075     }
2076 
2077     //--------------Only addresses calling with a signed message from the Admin can call the functions above ------------//
2078 
2079     //This function is called internally
2080     //This function is called to verify if a signature was used to sign a given message
2081     //Params
2082     //_hashedMessage => A message that has been passed through the keccak256 algorithm
2083     //_v, _r & _s are pieces of the signature
2084     //returns(bool) => Returns true or false whether the signature is verified or not
2085     function VerifyMessage(
2086         bytes32 _hashedMessage,
2087         uint8 _v,
2088         bytes32 _r,
2089         bytes32 _s
2090     ) internal view returns (bool) {
2091         //Check that the message does equal the keccak256 hash of the msg.senders address
2092         require(_hashedMessage == keccak256(abi.encode(msg.sender)), "ERR:WM"); // WM -> Wrong Message
2093 
2094         //Define a string to be prefixed to the hashed message
2095         bytes memory prefix = "\x19Ethereum Signed Message:\n32";
2096 
2097         //Combine the prefix & hashedMessage
2098         bytes32 prefixedHashMessage = keccak256(
2099             abi.encodePacked(prefix, _hashedMessage)
2100         );
2101 
2102         //Retrieve the signing address of the message
2103         address signer = ecrecover(prefixedHashMessage, _v, _r, _s);
2104 
2105         //Require that the signer is the admin of the contract, return bool accordingly
2106         return (signer == admin) ? true : false;
2107     }
2108 
2109     //This function is called to check that a merkle proof is a valid merkle proof
2110     //Param: _merkleProof => An array of bytes32 that represent the "proof" that the address is on the merkle tree
2111     //returns(bool) => The bool saying whether the proof is verified or not
2112     function checkValidity(bytes32[] calldata _merkleProof)
2113         public
2114         view
2115         returns (bool)
2116     {
2117         //Generate the leaf that would be on the merkle tree
2118         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
2119 
2120         //Check that the return of calling the MerkleProof libraries verify function with the given paramaters returns true
2121         require(
2122             MerkleProof.verify(_merkleProof, merkleRoot, leaf),
2123             "ERR:IP" // IP -> incorrect proof
2124         );
2125 
2126         //Return true
2127         return true;
2128     }
2129 
2130     //This function is called to mint a whitelist NFT for whitelist Price
2131     //Params
2132     //amount => The amount of NFTs to be minted
2133     //_merkleProof => An array of bytes2 that represents the "proof" that the address is on the merkletree
2134     //Ether will be sent with this function call so it is marked payable
2135     //nonReentrant => This function can not be accessed multiple times in a single transaction
2136     //notPaused => This function can only be called when minting is not paused
2137     function whitelistMint(uint8 amount, bytes32[] calldata _merkleProof)
2138         external
2139         payable
2140         nonReentrant
2141         notPaused
2142     {
2143         //If the msg.sender is not the admin or an approved wallet
2144         if (msg.sender != admin || approvedWallets[msg.sender]) {
2145             //Check that the amount is notlarger than 3
2146             require(amount <= 3, "ERR:SA"); //SA -> Sent Amount
2147 
2148             //Check that the msg.sender is not trying to mint more than 9 NFTs total
2149             require(numMintedByUser[msg.sender] + amount <= 9, "ERR:MA"); //MA -> mint amount
2150         }
2151 
2152         //Check if the whitelist minting is currently active
2153         require(whitelistActive, "ERR:NA"); //NA => Not Active
2154 
2155         //Check the validity of the proof
2156         require(checkValidity(_merkleProof), "ERR:WP"); //WL -> whitelist proof
2157 
2158         //Check that the amount + totalSupply is not larger than the whitelist Limit - 3333
2159         require(amount + totalSupply() <= whitelistLimit, "ERR:WL"); //WL -> whitelist limit
2160 
2161         //If the caller is not the admin
2162         if (msg.sender != admin) {
2163             //Calculate the total cost
2164             uint256 amountDue = amount * whitelistPrice;
2165 
2166             //Check that the value sent is exactly the amount * whitelist price
2167             require(msg.value == amountDue, "ERR:WF"); //WF -> Wrong Funds
2168 
2169             //Send the funds to admin wallet
2170             (bool success, ) = admin.call{value: amountDue}("");
2171 
2172             //Check that the funds were transferred correctly
2173             require(success, "ERR:PA"); // PA -> Paying Admin
2174         } else {
2175             //If the caller is the admin
2176 
2177             //Check that the total amount of mints the admin has made plus the amount
2178             //requested to be minted is less than or equal to 1111
2179             require(adminMintCount + amount <= 1111, "ERR:AM"); //AM => admin Minting
2180 
2181             //Increase the amount that the admin has minted by amount
2182             adminMintCount += amount;
2183         }
2184 
2185         //Mint the amount of NFTs to the caller
2186         _safeMint(msg.sender, uint256(amount));
2187     }
2188 
2189     function mint(uint8 amount) external payable nonReentrant notPaused {
2190         //If the msg.sender is not the admin or an approved wallet
2191         if (msg.sender != admin || approvedWallets[msg.sender]) {
2192             //Check that the amount is notlarger than 3
2193             require(amount <= 3, "ERR:SA"); //SA -> Sent Amount
2194 
2195             //Check that the msg.sender is not trying to mint more than 9 NFTs total
2196             require(numMintedByUser[msg.sender] + amount <= 9, "ERR:MA"); //MA -> mint amount
2197         }
2198 
2199         //Check that the whitelist is not active
2200         require(!whitelistActive, "ERR:WA"); //WA => Whitelist Active
2201 
2202         //Check that the totalSupply + amount does not exceed the total mint limit
2203         require(amount + totalSupply() <= totalLimit, "ERR:TL"); //TL - total limit
2204 
2205         //If the caller is not the admin
2206         if (msg.sender != admin) {
2207             //Calculate the total cost
2208             uint256 amountDue = amount * normalPrice;
2209 
2210             //Check that the value sent is exactly the amount * normal price
2211             require(msg.value == amountDue, "ERR:NF"); //NF -> not enough funds
2212 
2213             //Send funds to admin wallet
2214             (bool success, ) = admin.call{value: amountDue}("");
2215 
2216             //Check that the funds were transferred correctly
2217             require(success, "ERR:PA"); // PA -> Paying Admin
2218         } else {
2219             //If the caller is the admin
2220 
2221             //Check that the total amount of mints the admin has made plus the amount
2222             //requested to be minted is less than or equal to 1111
2223             require(adminMintCount + amount <= 1111, "ERR:AM"); //AM => admin Minting
2224 
2225             //Increase the amount that the admin has minted by amount
2226             adminMintCount += amount;
2227         }
2228 
2229         //Mint the amount for the caller
2230         _safeMint(msg.sender, uint256(amount));
2231     }
2232 
2233     //This function is a function in the ERC721A inherited contract
2234     //We override it so we can set a custom variable
2235     function _baseURI() internal view virtual override returns (string memory) {
2236         return baseURI; //put baseURI in here
2237     }
2238 }