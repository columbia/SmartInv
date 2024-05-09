1 // SPDX-License-Identifier: MIT
2 // Created by You and @0xmonas
3 
4 // File: @openzeppelin/contracts/utils/Address.sol
5 
6 
7 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
8 
9 pragma solidity ^0.8.1;
10 
11 /**
12  * @dev Collection of functions related to the address type
13  */
14 library Address {
15     /**
16      * @dev Returns true if `account` is a contract.
17      *
18      * [IMPORTANT]
19      * ====
20      * It is unsafe to assume that an address for which this function returns
21      * false is an externally-owned account (EOA) and not a contract.
22      *
23      * Among others, `isContract` will return false for the following
24      * types of addresses:
25      *
26      *  - an externally-owned account
27      *  - a contract in construction
28      *  - an address where a contract will be created
29      *  - an address where a contract lived, but was destroyed
30      * ====
31      *
32      * [IMPORTANT]
33      * ====
34      * You shouldn't rely on `isContract` to protect against flash loan attacks!
35      *
36      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
37      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
38      * constructor.
39      * ====
40      */
41     function isContract(address account) internal view returns (bool) {
42         // This method relies on extcodesize/address.code.length, which returns 0
43         // for contracts in construction, since the code is only stored at the end
44         // of the constructor execution.
45 
46         return account.code.length > 0;
47     }
48 
49     /**
50      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
51      * `recipient`, forwarding all available gas and reverting on errors.
52      *
53      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
54      * of certain opcodes, possibly making contracts go over the 2300 gas limit
55      * imposed by `transfer`, making them unable to receive funds via
56      * `transfer`. {sendValue} removes this limitation.
57      *
58      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
59      *
60      * IMPORTANT: because control is transferred to `recipient`, care must be
61      * taken to not create reentrancy vulnerabilities. Consider using
62      * {ReentrancyGuard} or the
63      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
64      */
65     function sendValue(address payable recipient, uint256 amount) internal {
66         require(address(this).balance >= amount, "Address: insufficient balance");
67 
68         (bool success, ) = recipient.call{value: amount}("");
69         require(success, "Address: unable to send value, recipient may have reverted");
70     }
71 
72     /**
73      * @dev Performs a Solidity function call using a low level `call`. A
74      * plain `call` is an unsafe replacement for a function call: use this
75      * function instead.
76      *
77      * If `target` reverts with a revert reason, it is bubbled up by this
78      * function (like regular Solidity function calls).
79      *
80      * Returns the raw returned data. To convert to the expected return value,
81      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
82      *
83      * Requirements:
84      *
85      * - `target` must be a contract.
86      * - calling `target` with `data` must not revert.
87      *
88      * _Available since v3.1._
89      */
90     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
91         return functionCall(target, data, "Address: low-level call failed");
92     }
93 
94     /**
95      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
96      * `errorMessage` as a fallback revert reason when `target` reverts.
97      *
98      * _Available since v3.1._
99      */
100     function functionCall(
101         address target,
102         bytes memory data,
103         string memory errorMessage
104     ) internal returns (bytes memory) {
105         return functionCallWithValue(target, data, 0, errorMessage);
106     }
107 
108     /**
109      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
110      * but also transferring `value` wei to `target`.
111      *
112      * Requirements:
113      *
114      * - the calling contract must have an ETH balance of at least `value`.
115      * - the called Solidity function must be `payable`.
116      *
117      * _Available since v3.1._
118      */
119     function functionCallWithValue(
120         address target,
121         bytes memory data,
122         uint256 value
123     ) internal returns (bytes memory) {
124         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
125     }
126 
127     /**
128      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
129      * with `errorMessage` as a fallback revert reason when `target` reverts.
130      *
131      * _Available since v3.1._
132      */
133     function functionCallWithValue(
134         address target,
135         bytes memory data,
136         uint256 value,
137         string memory errorMessage
138     ) internal returns (bytes memory) {
139         require(address(this).balance >= value, "Address: insufficient balance for call");
140         require(isContract(target), "Address: call to non-contract");
141 
142         (bool success, bytes memory returndata) = target.call{value: value}(data);
143         return verifyCallResult(success, returndata, errorMessage);
144     }
145 
146     /**
147      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
148      * but performing a static call.
149      *
150      * _Available since v3.3._
151      */
152     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
153         return functionStaticCall(target, data, "Address: low-level static call failed");
154     }
155 
156     /**
157      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
158      * but performing a static call.
159      *
160      * _Available since v3.3._
161      */
162     function functionStaticCall(
163         address target,
164         bytes memory data,
165         string memory errorMessage
166     ) internal view returns (bytes memory) {
167         require(isContract(target), "Address: static call to non-contract");
168 
169         (bool success, bytes memory returndata) = target.staticcall(data);
170         return verifyCallResult(success, returndata, errorMessage);
171     }
172 
173     /**
174      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
175      * but performing a delegate call.
176      *
177      * _Available since v3.4._
178      */
179     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
180         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
181     }
182 
183     /**
184      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
185      * but performing a delegate call.
186      *
187      * _Available since v3.4._
188      */
189     function functionDelegateCall(
190         address target,
191         bytes memory data,
192         string memory errorMessage
193     ) internal returns (bytes memory) {
194         require(isContract(target), "Address: delegate call to non-contract");
195 
196         (bool success, bytes memory returndata) = target.delegatecall(data);
197         return verifyCallResult(success, returndata, errorMessage);
198     }
199 
200     /**
201      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
202      * revert reason using the provided one.
203      *
204      * _Available since v4.3._
205      */
206     function verifyCallResult(
207         bool success,
208         bytes memory returndata,
209         string memory errorMessage
210     ) internal pure returns (bytes memory) {
211         if (success) {
212             return returndata;
213         } else {
214             // Look for revert reason and bubble it up if present
215             if (returndata.length > 0) {
216                 // The easiest way to bubble the revert reason is using memory via assembly
217                 /// @solidity memory-safe-assembly
218                 assembly {
219                     let returndata_size := mload(returndata)
220                     revert(add(32, returndata), returndata_size)
221                 }
222             } else {
223                 revert(errorMessage);
224             }
225         }
226     }
227 }
228 
229 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
230 
231 
232 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
233 
234 pragma solidity ^0.8.0;
235 
236 /**
237  * @title ERC721 token receiver interface
238  * @dev Interface for any contract that wants to support safeTransfers
239  * from ERC721 asset contracts.
240  */
241 interface IERC721Receiver {
242     /**
243      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
244      * by `operator` from `from`, this function is called.
245      *
246      * It must return its Solidity selector to confirm the token transfer.
247      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
248      *
249      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
250      */
251     function onERC721Received(
252         address operator,
253         address from,
254         uint256 tokenId,
255         bytes calldata data
256     ) external returns (bytes4);
257 }
258 
259 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
260 
261 
262 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
263 
264 pragma solidity ^0.8.0;
265 
266 /**
267  * @dev Interface of the ERC165 standard, as defined in the
268  * https://eips.ethereum.org/EIPS/eip-165[EIP].
269  *
270  * Implementers can declare support of contract interfaces, which can then be
271  * queried by others ({ERC165Checker}).
272  *
273  * For an implementation, see {ERC165}.
274  */
275 interface IERC165 {
276     /**
277      * @dev Returns true if this contract implements the interface defined by
278      * `interfaceId`. See the corresponding
279      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
280      * to learn more about how these ids are created.
281      *
282      * This function call must use less than 30 000 gas.
283      */
284     function supportsInterface(bytes4 interfaceId) external view returns (bool);
285 }
286 
287 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
288 
289 
290 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
291 
292 pragma solidity ^0.8.0;
293 
294 
295 /**
296  * @dev Implementation of the {IERC165} interface.
297  *
298  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
299  * for the additional interface id that will be supported. For example:
300  *
301  * ```solidity
302  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
303  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
304  * }
305  * ```
306  *
307  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
308  */
309 abstract contract ERC165 is IERC165 {
310     /**
311      * @dev See {IERC165-supportsInterface}.
312      */
313     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
314         return interfaceId == type(IERC165).interfaceId;
315     }
316 }
317 
318 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
319 
320 
321 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
322 
323 pragma solidity ^0.8.0;
324 
325 
326 /**
327  * @dev Required interface of an ERC721 compliant contract.
328  */
329 interface IERC721 is IERC165 {
330     /**
331      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
332      */
333     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
334 
335     /**
336      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
337      */
338     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
339 
340     /**
341      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
342      */
343     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
344 
345     /**
346      * @dev Returns the number of tokens in ``owner``'s account.
347      */
348     function balanceOf(address owner) external view returns (uint256 balance);
349 
350     /**
351      * @dev Returns the owner of the `tokenId` token.
352      *
353      * Requirements:
354      *
355      * - `tokenId` must exist.
356      */
357     function ownerOf(uint256 tokenId) external view returns (address owner);
358 
359     /**
360      * @dev Safely transfers `tokenId` token from `from` to `to`.
361      *
362      * Requirements:
363      *
364      * - `from` cannot be the zero address.
365      * - `to` cannot be the zero address.
366      * - `tokenId` token must exist and be owned by `from`.
367      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
368      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
369      *
370      * Emits a {Transfer} event.
371      */
372     function safeTransferFrom(
373         address from,
374         address to,
375         uint256 tokenId,
376         bytes calldata data
377     ) external;
378 
379     /**
380      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
381      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
382      *
383      * Requirements:
384      *
385      * - `from` cannot be the zero address.
386      * - `to` cannot be the zero address.
387      * - `tokenId` token must exist and be owned by `from`.
388      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
389      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
390      *
391      * Emits a {Transfer} event.
392      */
393     function safeTransferFrom(
394         address from,
395         address to,
396         uint256 tokenId
397     ) external;
398 
399     /**
400      * @dev Transfers `tokenId` token from `from` to `to`.
401      *
402      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
403      *
404      * Requirements:
405      *
406      * - `from` cannot be the zero address.
407      * - `to` cannot be the zero address.
408      * - `tokenId` token must be owned by `from`.
409      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
410      *
411      * Emits a {Transfer} event.
412      */
413     function transferFrom(
414         address from,
415         address to,
416         uint256 tokenId
417     ) external;
418 
419     /**
420      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
421      * The approval is cleared when the token is transferred.
422      *
423      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
424      *
425      * Requirements:
426      *
427      * - The caller must own the token or be an approved operator.
428      * - `tokenId` must exist.
429      *
430      * Emits an {Approval} event.
431      */
432     function approve(address to, uint256 tokenId) external;
433 
434     /**
435      * @dev Approve or remove `operator` as an operator for the caller.
436      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
437      *
438      * Requirements:
439      *
440      * - The `operator` cannot be the caller.
441      *
442      * Emits an {ApprovalForAll} event.
443      */
444     function setApprovalForAll(address operator, bool _approved) external;
445 
446     /**
447      * @dev Returns the account approved for `tokenId` token.
448      *
449      * Requirements:
450      *
451      * - `tokenId` must exist.
452      */
453     function getApproved(uint256 tokenId) external view returns (address operator);
454 
455     /**
456      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
457      *
458      * See {setApprovalForAll}
459      */
460     function isApprovedForAll(address owner, address operator) external view returns (bool);
461 }
462 
463 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
464 
465 
466 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
467 
468 pragma solidity ^0.8.0;
469 
470 
471 /**
472  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
473  * @dev See https://eips.ethereum.org/EIPS/eip-721
474  */
475 interface IERC721Enumerable is IERC721 {
476     /**
477      * @dev Returns the total amount of tokens stored by the contract.
478      */
479     function totalSupply() external view returns (uint256);
480 
481     /**
482      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
483      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
484      */
485     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
486 
487     /**
488      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
489      * Use along with {totalSupply} to enumerate all tokens.
490      */
491     function tokenByIndex(uint256 index) external view returns (uint256);
492 }
493 
494 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
495 
496 
497 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
498 
499 pragma solidity ^0.8.0;
500 
501 
502 /**
503  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
504  * @dev See https://eips.ethereum.org/EIPS/eip-721
505  */
506 interface IERC721Metadata is IERC721 {
507     /**
508      * @dev Returns the token collection name.
509      */
510     function name() external view returns (string memory);
511 
512     /**
513      * @dev Returns the token collection symbol.
514      */
515     function symbol() external view returns (string memory);
516 
517     /**
518      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
519      */
520     function tokenURI(uint256 tokenId) external view returns (string memory);
521 }
522 
523 // File: https://github.com/0xmonas/onechain/blob/main/master/contracts/Base64.sol
524 
525 
526 pragma solidity ^0.8.0;
527 
528 /// @title Base64
529 /// @author Brecht Devos - <brecht@loopring.org>
530 /// @notice Provides a function for encoding some bytes in base64
531 library Base64 {
532     string internal constant TABLE =
533         "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
534 
535     function encode(bytes memory data) internal pure returns (bytes memory) {
536         if (data.length == 0) return "";
537 
538         // load the table into memory
539         string memory table = TABLE;
540 
541         // multiply by 4/3 rounded up
542         uint256 encodedLen = 4 * ((data.length + 2) / 3);
543 
544         // add some extra buffer at the end required for the writing
545         bytes memory result = new bytes(encodedLen + 32);
546 
547         assembly {
548             // set the actual output length
549             mstore(result, encodedLen)
550 
551             // prepare the lookup table
552             let tablePtr := add(table, 1)
553 
554             // input ptr
555             let dataPtr := data
556             let endPtr := add(dataPtr, mload(data))
557 
558             // result ptr, jump over length
559             let resultPtr := add(result, 32)
560 
561             // run over the input, 3 bytes at a time
562             for {
563 
564             } lt(dataPtr, endPtr) {
565 
566             } {
567                 dataPtr := add(dataPtr, 3)
568 
569                 // read 3 bytes
570                 let input := mload(dataPtr)
571 
572                 // write 4 characters
573                 mstore(
574                     resultPtr,
575                     shl(248, mload(add(tablePtr, and(shr(18, input), 0x3F))))
576                 )
577                 resultPtr := add(resultPtr, 1)
578                 mstore(
579                     resultPtr,
580                     shl(248, mload(add(tablePtr, and(shr(12, input), 0x3F))))
581                 )
582                 resultPtr := add(resultPtr, 1)
583                 mstore(
584                     resultPtr,
585                     shl(248, mload(add(tablePtr, and(shr(6, input), 0x3F))))
586                 )
587                 resultPtr := add(resultPtr, 1)
588                 mstore(
589                     resultPtr,
590                     shl(248, mload(add(tablePtr, and(input, 0x3F))))
591                 )
592                 resultPtr := add(resultPtr, 1)
593             }
594 
595             // padding with '='
596             switch mod(mload(data), 3)
597             case 1 {
598                 mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
599             }
600             case 2 {
601                 mstore(sub(resultPtr, 1), shl(248, 0x3d))
602             }
603         }
604 
605         return result;
606     }
607 }
608 
609 // File: @openzeppelin/contracts/utils/Strings.sol
610 
611 
612 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
613 
614 pragma solidity ^0.8.0;
615 
616 /**
617  * @dev String operations.
618  */
619 library Strings {
620     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
621     uint8 private constant _ADDRESS_LENGTH = 20;
622 
623     /**
624      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
625      */
626     function toString(uint256 value) internal pure returns (string memory) {
627         // Inspired by OraclizeAPI's implementation - MIT licence
628         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
629 
630         if (value == 0) {
631             return "0";
632         }
633         uint256 temp = value;
634         uint256 digits;
635         while (temp != 0) {
636             digits++;
637             temp /= 10;
638         }
639         bytes memory buffer = new bytes(digits);
640         while (value != 0) {
641             digits -= 1;
642             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
643             value /= 10;
644         }
645         return string(buffer);
646     }
647 
648     /**
649      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
650      */
651     function toHexString(uint256 value) internal pure returns (string memory) {
652         if (value == 0) {
653             return "0x00";
654         }
655         uint256 temp = value;
656         uint256 length = 0;
657         while (temp != 0) {
658             length++;
659             temp >>= 8;
660         }
661         return toHexString(value, length);
662     }
663 
664     /**
665      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
666      */
667     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
668         bytes memory buffer = new bytes(2 * length + 2);
669         buffer[0] = "0";
670         buffer[1] = "x";
671         for (uint256 i = 2 * length + 1; i > 1; --i) {
672             buffer[i] = _HEX_SYMBOLS[value & 0xf];
673             value >>= 4;
674         }
675         require(value == 0, "Strings: hex length insufficient");
676         return string(buffer);
677     }
678 
679     /**
680      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
681      */
682     function toHexString(address addr) internal pure returns (string memory) {
683         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
684     }
685 }
686 
687 // File: @openzeppelin/contracts/utils/Context.sol
688 
689 
690 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
691 
692 pragma solidity ^0.8.0;
693 
694 /**
695  * @dev Provides information about the current execution context, including the
696  * sender of the transaction and its data. While these are generally available
697  * via msg.sender and msg.data, they should not be accessed in such a direct
698  * manner, since when dealing with meta-transactions the account sending and
699  * paying for execution may not be the actual sender (as far as an application
700  * is concerned).
701  *
702  * This contract is only required for intermediate, library-like contracts.
703  */
704 abstract contract Context {
705     function _msgSender() internal view virtual returns (address) {
706         return msg.sender;
707     }
708 
709     function _msgData() internal view virtual returns (bytes calldata) {
710         return msg.data;
711     }
712 }
713 
714 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
715 
716 
717 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
718 
719 pragma solidity ^0.8.0;
720 
721 
722 
723 
724 
725 
726 
727 
728 /**
729  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
730  * the Metadata extension, but not including the Enumerable extension, which is available separately as
731  * {ERC721Enumerable}.
732  */
733 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
734     using Address for address;
735     using Strings for uint256;
736 
737     // Token name
738     string private _name;
739 
740     // Token symbol
741     string private _symbol;
742 
743     // Mapping from token ID to owner address
744     mapping(uint256 => address) private _owners;
745 
746     // Mapping owner address to token count
747     mapping(address => uint256) private _balances;
748 
749     // Mapping from token ID to approved address
750     mapping(uint256 => address) private _tokenApprovals;
751 
752     // Mapping from owner to operator approvals
753     mapping(address => mapping(address => bool)) private _operatorApprovals;
754 
755     /**
756      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
757      */
758     constructor(string memory name_, string memory symbol_) {
759         _name = name_;
760         _symbol = symbol_;
761     }
762 
763     /**
764      * @dev See {IERC165-supportsInterface}.
765      */
766     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
767         return
768             interfaceId == type(IERC721).interfaceId ||
769             interfaceId == type(IERC721Metadata).interfaceId ||
770             super.supportsInterface(interfaceId);
771     }
772 
773     /**
774      * @dev See {IERC721-balanceOf}.
775      */
776     function balanceOf(address owner) public view virtual override returns (uint256) {
777         require(owner != address(0), "ERC721: address zero is not a valid owner");
778         return _balances[owner];
779     }
780 
781     /**
782      * @dev See {IERC721-ownerOf}.
783      */
784     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
785         address owner = _owners[tokenId];
786         require(owner != address(0), "ERC721: invalid token ID");
787         return owner;
788     }
789 
790     /**
791      * @dev See {IERC721Metadata-name}.
792      */
793     function name() public view virtual override returns (string memory) {
794         return _name;
795     }
796 
797     /**
798      * @dev See {IERC721Metadata-symbol}.
799      */
800     function symbol() public view virtual override returns (string memory) {
801         return _symbol;
802     }
803 
804     /**
805      * @dev See {IERC721Metadata-tokenURI}.
806      */
807     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
808         _requireMinted(tokenId);
809 
810         string memory baseURI = _baseURI();
811         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
812     }
813 
814     /**
815      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
816      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
817      * by default, can be overridden in child contracts.
818      */
819     function _baseURI() internal view virtual returns (string memory) {
820         return "";
821     }
822 
823     /**
824      * @dev See {IERC721-approve}.
825      */
826     function approve(address to, uint256 tokenId) public virtual override {
827         address owner = ERC721.ownerOf(tokenId);
828         require(to != owner, "ERC721: approval to current owner");
829 
830         require(
831             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
832             "ERC721: approve caller is not token owner nor approved for all"
833         );
834 
835         _approve(to, tokenId);
836     }
837 
838     /**
839      * @dev See {IERC721-getApproved}.
840      */
841     function getApproved(uint256 tokenId) public view virtual override returns (address) {
842         _requireMinted(tokenId);
843 
844         return _tokenApprovals[tokenId];
845     }
846 
847     /**
848      * @dev See {IERC721-setApprovalForAll}.
849      */
850     function setApprovalForAll(address operator, bool approved) public virtual override {
851         _setApprovalForAll(_msgSender(), operator, approved);
852     }
853 
854     /**
855      * @dev See {IERC721-isApprovedForAll}.
856      */
857     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
858         return _operatorApprovals[owner][operator];
859     }
860 
861     /**
862      * @dev See {IERC721-transferFrom}.
863      */
864     function transferFrom(
865         address from,
866         address to,
867         uint256 tokenId
868     ) public virtual override {
869         //solhint-disable-next-line max-line-length
870         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
871 
872         _transfer(from, to, tokenId);
873     }
874 
875     /**
876      * @dev See {IERC721-safeTransferFrom}.
877      */
878     function safeTransferFrom(
879         address from,
880         address to,
881         uint256 tokenId
882     ) public virtual override {
883         safeTransferFrom(from, to, tokenId, "");
884     }
885 
886     /**
887      * @dev See {IERC721-safeTransferFrom}.
888      */
889     function safeTransferFrom(
890         address from,
891         address to,
892         uint256 tokenId,
893         bytes memory data
894     ) public virtual override {
895         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
896         _safeTransfer(from, to, tokenId, data);
897     }
898 
899     /**
900      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
901      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
902      *
903      * `data` is additional data, it has no specified format and it is sent in call to `to`.
904      *
905      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
906      * implement alternative mechanisms to perform token transfer, such as signature-based.
907      *
908      * Requirements:
909      *
910      * - `from` cannot be the zero address.
911      * - `to` cannot be the zero address.
912      * - `tokenId` token must exist and be owned by `from`.
913      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
914      *
915      * Emits a {Transfer} event.
916      */
917     function _safeTransfer(
918         address from,
919         address to,
920         uint256 tokenId,
921         bytes memory data
922     ) internal virtual {
923         _transfer(from, to, tokenId);
924         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
925     }
926 
927     /**
928      * @dev Returns whether `tokenId` exists.
929      *
930      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
931      *
932      * Tokens start existing when they are minted (`_mint`),
933      * and stop existing when they are burned (`_burn`).
934      */
935     function _exists(uint256 tokenId) internal view virtual returns (bool) {
936         return _owners[tokenId] != address(0);
937     }
938 
939     /**
940      * @dev Returns whether `spender` is allowed to manage `tokenId`.
941      *
942      * Requirements:
943      *
944      * - `tokenId` must exist.
945      */
946     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
947         address owner = ERC721.ownerOf(tokenId);
948         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
949     }
950 
951     /**
952      * @dev Safely mints `tokenId` and transfers it to `to`.
953      *
954      * Requirements:
955      *
956      * - `tokenId` must not exist.
957      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
958      *
959      * Emits a {Transfer} event.
960      */
961     function _safeMint(address to, uint256 tokenId) internal virtual {
962         _safeMint(to, tokenId, "");
963     }
964 
965     /**
966      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
967      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
968      */
969     function _safeMint(
970         address to,
971         uint256 tokenId,
972         bytes memory data
973     ) internal virtual {
974         _mint(to, tokenId);
975         require(
976             _checkOnERC721Received(address(0), to, tokenId, data),
977             "ERC721: transfer to non ERC721Receiver implementer"
978         );
979     }
980 
981     /**
982      * @dev Mints `tokenId` and transfers it to `to`.
983      *
984      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
985      *
986      * Requirements:
987      *
988      * - `tokenId` must not exist.
989      * - `to` cannot be the zero address.
990      *
991      * Emits a {Transfer} event.
992      */
993     function _mint(address to, uint256 tokenId) internal virtual {
994         require(to != address(0), "ERC721: mint to the zero address");
995         require(!_exists(tokenId), "ERC721: token already minted");
996 
997         _beforeTokenTransfer(address(0), to, tokenId);
998 
999         _balances[to] += 1;
1000         _owners[tokenId] = to;
1001 
1002         emit Transfer(address(0), to, tokenId);
1003 
1004         _afterTokenTransfer(address(0), to, tokenId);
1005     }
1006 
1007     /**
1008      * @dev Destroys `tokenId`.
1009      * The approval is cleared when the token is burned.
1010      *
1011      * Requirements:
1012      *
1013      * - `tokenId` must exist.
1014      *
1015      * Emits a {Transfer} event.
1016      */
1017     function _burn(uint256 tokenId) internal virtual {
1018         address owner = ERC721.ownerOf(tokenId);
1019 
1020         _beforeTokenTransfer(owner, address(0), tokenId);
1021 
1022         // Clear approvals
1023         _approve(address(0), tokenId);
1024 
1025         _balances[owner] -= 1;
1026         delete _owners[tokenId];
1027 
1028         emit Transfer(owner, address(0), tokenId);
1029 
1030         _afterTokenTransfer(owner, address(0), tokenId);
1031     }
1032 
1033     /**
1034      * @dev Transfers `tokenId` from `from` to `to`.
1035      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1036      *
1037      * Requirements:
1038      *
1039      * - `to` cannot be the zero address.
1040      * - `tokenId` token must be owned by `from`.
1041      *
1042      * Emits a {Transfer} event.
1043      */
1044     function _transfer(
1045         address from,
1046         address to,
1047         uint256 tokenId
1048     ) internal virtual {
1049         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1050         require(to != address(0), "ERC721: transfer to the zero address");
1051 
1052         _beforeTokenTransfer(from, to, tokenId);
1053 
1054         // Clear approvals from the previous owner
1055         _approve(address(0), tokenId);
1056 
1057         _balances[from] -= 1;
1058         _balances[to] += 1;
1059         _owners[tokenId] = to;
1060 
1061         emit Transfer(from, to, tokenId);
1062 
1063         _afterTokenTransfer(from, to, tokenId);
1064     }
1065 
1066     /**
1067      * @dev Approve `to` to operate on `tokenId`
1068      *
1069      * Emits an {Approval} event.
1070      */
1071     function _approve(address to, uint256 tokenId) internal virtual {
1072         _tokenApprovals[tokenId] = to;
1073         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1074     }
1075 
1076     /**
1077      * @dev Approve `operator` to operate on all of `owner` tokens
1078      *
1079      * Emits an {ApprovalForAll} event.
1080      */
1081     function _setApprovalForAll(
1082         address owner,
1083         address operator,
1084         bool approved
1085     ) internal virtual {
1086         require(owner != operator, "ERC721: approve to caller");
1087         _operatorApprovals[owner][operator] = approved;
1088         emit ApprovalForAll(owner, operator, approved);
1089     }
1090 
1091     /**
1092      * @dev Reverts if the `tokenId` has not been minted yet.
1093      */
1094     function _requireMinted(uint256 tokenId) internal view virtual {
1095         require(_exists(tokenId), "ERC721: invalid token ID");
1096     }
1097 
1098     /**
1099      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1100      * The call is not executed if the target address is not a contract.
1101      *
1102      * @param from address representing the previous owner of the given token ID
1103      * @param to target address that will receive the tokens
1104      * @param tokenId uint256 ID of the token to be transferred
1105      * @param data bytes optional data to send along with the call
1106      * @return bool whether the call correctly returned the expected magic value
1107      */
1108     function _checkOnERC721Received(
1109         address from,
1110         address to,
1111         uint256 tokenId,
1112         bytes memory data
1113     ) private returns (bool) {
1114         if (to.isContract()) {
1115             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1116                 return retval == IERC721Receiver.onERC721Received.selector;
1117             } catch (bytes memory reason) {
1118                 if (reason.length == 0) {
1119                     revert("ERC721: transfer to non ERC721Receiver implementer");
1120                 } else {
1121                     /// @solidity memory-safe-assembly
1122                     assembly {
1123                         revert(add(32, reason), mload(reason))
1124                     }
1125                 }
1126             }
1127         } else {
1128             return true;
1129         }
1130     }
1131 
1132     /**
1133      * @dev Hook that is called before any token transfer. This includes minting
1134      * and burning.
1135      *
1136      * Calling conditions:
1137      *
1138      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1139      * transferred to `to`.
1140      * - When `from` is zero, `tokenId` will be minted for `to`.
1141      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1142      * - `from` and `to` are never both zero.
1143      *
1144      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1145      */
1146     function _beforeTokenTransfer(
1147         address from,
1148         address to,
1149         uint256 tokenId
1150     ) internal virtual {}
1151 
1152     /**
1153      * @dev Hook that is called after any transfer of tokens. This includes
1154      * minting and burning.
1155      *
1156      * Calling conditions:
1157      *
1158      * - when `from` and `to` are both non-zero.
1159      * - `from` and `to` are never both zero.
1160      *
1161      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1162      */
1163     function _afterTokenTransfer(
1164         address from,
1165         address to,
1166         uint256 tokenId
1167     ) internal virtual {}
1168 }
1169 
1170 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1171 
1172 
1173 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1174 
1175 pragma solidity ^0.8.0;
1176 
1177 
1178 
1179 /**
1180  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1181  * enumerability of all the token ids in the contract as well as all token ids owned by each
1182  * account.
1183  */
1184 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1185     // Mapping from owner to list of owned token IDs
1186     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1187 
1188     // Mapping from token ID to index of the owner tokens list
1189     mapping(uint256 => uint256) private _ownedTokensIndex;
1190 
1191     // Array with all token ids, used for enumeration
1192     uint256[] private _allTokens;
1193 
1194     // Mapping from token id to position in the allTokens array
1195     mapping(uint256 => uint256) private _allTokensIndex;
1196 
1197     /**
1198      * @dev See {IERC165-supportsInterface}.
1199      */
1200     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1201         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1202     }
1203 
1204     /**
1205      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1206      */
1207     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1208         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1209         return _ownedTokens[owner][index];
1210     }
1211 
1212     /**
1213      * @dev See {IERC721Enumerable-totalSupply}.
1214      */
1215     function totalSupply() public view virtual override returns (uint256) {
1216         return _allTokens.length;
1217     }
1218 
1219     /**
1220      * @dev See {IERC721Enumerable-tokenByIndex}.
1221      */
1222     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1223         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1224         return _allTokens[index];
1225     }
1226 
1227     /**
1228      * @dev Hook that is called before any token transfer. This includes minting
1229      * and burning.
1230      *
1231      * Calling conditions:
1232      *
1233      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1234      * transferred to `to`.
1235      * - When `from` is zero, `tokenId` will be minted for `to`.
1236      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1237      * - `from` cannot be the zero address.
1238      * - `to` cannot be the zero address.
1239      *
1240      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1241      */
1242     function _beforeTokenTransfer(
1243         address from,
1244         address to,
1245         uint256 tokenId
1246     ) internal virtual override {
1247         super._beforeTokenTransfer(from, to, tokenId);
1248 
1249         if (from == address(0)) {
1250             _addTokenToAllTokensEnumeration(tokenId);
1251         } else if (from != to) {
1252             _removeTokenFromOwnerEnumeration(from, tokenId);
1253         }
1254         if (to == address(0)) {
1255             _removeTokenFromAllTokensEnumeration(tokenId);
1256         } else if (to != from) {
1257             _addTokenToOwnerEnumeration(to, tokenId);
1258         }
1259     }
1260 
1261     /**
1262      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1263      * @param to address representing the new owner of the given token ID
1264      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1265      */
1266     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1267         uint256 length = ERC721.balanceOf(to);
1268         _ownedTokens[to][length] = tokenId;
1269         _ownedTokensIndex[tokenId] = length;
1270     }
1271 
1272     /**
1273      * @dev Private function to add a token to this extension's token tracking data structures.
1274      * @param tokenId uint256 ID of the token to be added to the tokens list
1275      */
1276     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1277         _allTokensIndex[tokenId] = _allTokens.length;
1278         _allTokens.push(tokenId);
1279     }
1280 
1281     /**
1282      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1283      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1284      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1285      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1286      * @param from address representing the previous owner of the given token ID
1287      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1288      */
1289     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1290         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1291         // then delete the last slot (swap and pop).
1292 
1293         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1294         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1295 
1296         // When the token to delete is the last token, the swap operation is unnecessary
1297         if (tokenIndex != lastTokenIndex) {
1298             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1299 
1300             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1301             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1302         }
1303 
1304         // This also deletes the contents at the last position of the array
1305         delete _ownedTokensIndex[tokenId];
1306         delete _ownedTokens[from][lastTokenIndex];
1307     }
1308 
1309     /**
1310      * @dev Private function to remove a token from this extension's token tracking data structures.
1311      * This has O(1) time complexity, but alters the order of the _allTokens array.
1312      * @param tokenId uint256 ID of the token to be removed from the tokens list
1313      */
1314     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1315         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1316         // then delete the last slot (swap and pop).
1317 
1318         uint256 lastTokenIndex = _allTokens.length - 1;
1319         uint256 tokenIndex = _allTokensIndex[tokenId];
1320 
1321         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1322         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1323         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1324         uint256 lastTokenId = _allTokens[lastTokenIndex];
1325 
1326         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1327         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1328 
1329         // This also deletes the contents at the last position of the array
1330         delete _allTokensIndex[tokenId];
1331         _allTokens.pop();
1332     }
1333 }
1334 
1335 // File: @openzeppelin/contracts/access/Ownable.sol
1336 
1337 
1338 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1339 
1340 pragma solidity ^0.8.0;
1341 
1342 
1343 /**
1344  * @dev Contract module which provides a basic access control mechanism, where
1345  * there is an account (an owner) that can be granted exclusive access to
1346  * specific functions.
1347  *
1348  * By default, the owner account will be the one that deploys the contract. This
1349  * can later be changed with {transferOwnership}.
1350  *
1351  * This module is used through inheritance. It will make available the modifier
1352  * `onlyOwner`, which can be applied to your functions to restrict their use to
1353  * the owner.
1354  */
1355 abstract contract Ownable is Context {
1356     address private _owner;
1357 
1358     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1359 
1360     /**
1361      * @dev Initializes the contract setting the deployer as the initial owner.
1362      */
1363     constructor() {
1364         _transferOwnership(_msgSender());
1365     }
1366 
1367     /**
1368      * @dev Throws if called by any account other than the owner.
1369      */
1370     modifier onlyOwner() {
1371         _checkOwner();
1372         _;
1373     }
1374 
1375     /**
1376      * @dev Returns the address of the current owner.
1377      */
1378     function owner() public view virtual returns (address) {
1379         return _owner;
1380     }
1381 
1382     /**
1383      * @dev Throws if the sender is not the owner.
1384      */
1385     function _checkOwner() internal view virtual {
1386         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1387     }
1388 
1389     /**
1390      * @dev Leaves the contract without owner. It will not be possible to call
1391      * `onlyOwner` functions anymore. Can only be called by the current owner.
1392      *
1393      * NOTE: Renouncing ownership will leave the contract without an owner,
1394      * thereby removing any functionality that is only available to the owner.
1395      */
1396     function renounceOwnership() public virtual onlyOwner {
1397         _transferOwnership(address(0));
1398     }
1399 
1400     /**
1401      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1402      * Can only be called by the current owner.
1403      */
1404     function transferOwnership(address newOwner) public virtual onlyOwner {
1405         require(newOwner != address(0), "Ownable: new owner is the zero address");
1406         _transferOwnership(newOwner);
1407     }
1408 
1409     /**
1410      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1411      * Internal function without access restriction.
1412      */
1413     function _transferOwnership(address newOwner) internal virtual {
1414         address oldOwner = _owner;
1415         _owner = newOwner;
1416         emit OwnershipTransferred(oldOwner, newOwner);
1417     }
1418 }
1419 
1420 // File: @openzeppelin/contracts/utils/Counters.sol
1421 
1422 
1423 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
1424 
1425 pragma solidity ^0.8.0;
1426 
1427 /**
1428  * @title Counters
1429  * @author Matt Condon (@shrugs)
1430  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1431  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1432  *
1433  * Include with `using Counters for Counters.Counter;`
1434  */
1435 library Counters {
1436     struct Counter {
1437         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1438         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1439         // this feature: see https://github.com/ethereum/solidity/issues/4637
1440         uint256 _value; // default: 0
1441     }
1442 
1443     function current(Counter storage counter) internal view returns (uint256) {
1444         return counter._value;
1445     }
1446 
1447     function increment(Counter storage counter) internal {
1448         unchecked {
1449             counter._value += 1;
1450         }
1451     }
1452 
1453     function decrement(Counter storage counter) internal {
1454         uint256 value = counter._value;
1455         require(value > 0, "Counter: decrement overflow");
1456         unchecked {
1457             counter._value = value - 1;
1458         }
1459     }
1460 
1461     function reset(Counter storage counter) internal {
1462         counter._value = 0;
1463     }
1464 }
1465 
1466 // File: prompt.sol
1467 
1468 
1469 // Author: @0xmonas
1470 
1471 
1472 
1473 
1474 
1475 
1476 
1477 pragma solidity >=0.8.0 <0.9.0;
1478 
1479 
1480 contract Prompter is ERC721Enumerable, Ownable {
1481     error MaxNfts();
1482 
1483 
1484     using Strings for uint256;
1485     mapping(uint256 => string) private wordsToTokenId;
1486     uint private fee = 0.01 ether;
1487     uint256 minted = 0;
1488     mapping (string => bool) public  newString;
1489 
1490     
1491         string text;
1492     
1493 
1494     constructor() ERC721("Prompter", "TPC") {}
1495 
1496     function mint(string memory _Prompt) public payable {
1497         require(bytes(_Prompt).length <= 421, "MAX LENGTH 421 // Only base64 characters");
1498         if( newString[_Prompt] == true) {
1499         revert(); 
1500         }
1501         uint256 supply = totalSupply();
1502         if(supply + 1 > 1000) {
1503         revert MaxNfts();
1504       }
1505        newString[_Prompt] = true;
1506 
1507 
1508 
1509         if (msg.sender != owner()) {
1510             require(msg.value >= fee, string(abi.encodePacked("Missing fee of ", fee.toString(), " wei")));
1511         }
1512 
1513         wordsToTokenId[supply + 1] = _Prompt;
1514         _safeMint(msg.sender, supply + 1);
1515         minted += 1;
1516         
1517     }
1518 
1519 
1520     function buildImage(string memory _Prompt) private pure returns (bytes memory) {
1521         return
1522             Base64.encode(
1523                 abi.encodePacked(
1524                     '<svg width="500" height="500" xmlns="http://www.w3.org/2000/svg"', " xmlns:xlink='http://www.w3.org/1999/xlink'>",
1525                     '<rect height="100%" width="100%" y="0" x="0" fill="#0c0c0c"/>',
1526                     '<defs>',
1527                     '<path id="path1" d="M7.55,33.94H484M7.55,67.38H484M7.3,100.83H483.74M7.44,134.24H483.88M7.44,167.67H483.88M7.44,201.11H483.88M7.18,234.54H483.62M7.74,267.97H484.19M7.74,301.41H484.19M7.49,334.86H483.92M7.63,368.27H484.07M7.63,401.7H484.07M7.63,435.14H484.07M7.37,468.57H483.8"></path>',
1528                     '</defs>',
1529                      '<use xlink:href="#path1" />',
1530                      '<text font-size="26.47px" fill="whitesmoke" font-family="Courier New">',
1531                      '<textPath xlink:href="#path1">', _Prompt,'</textPath>',"</text>"
1532                      "</svg>"
1533                 )
1534             );
1535     }
1536 
1537     function tokenURI(uint256 _tokenId)
1538         public
1539         view
1540         virtual
1541         override
1542         returns (string memory)
1543     {
1544         require(
1545             _exists(_tokenId),
1546             "ERC721Metadata: URI query for nonexistent token"
1547         );
1548 
1549         bytes memory title = abi.encodePacked("Prompt #", _tokenId.toString());
1550         
1551         string memory tokenWord = wordsToTokenId[_tokenId];
1552         return
1553             string(
1554                 bytes.concat(
1555                     "data:application/json;base64,",
1556                     Base64.encode(
1557                         abi.encodePacked(
1558                             "{"
1559                                 '"name":"', title, '",'
1560                                 '"description":"\'', bytes(tokenWord), '\' Prompter is a collection by You and Monas.  ",'
1561                                 '"image":"data:image/svg+xml;base64,', buildImage(tokenWord), '"'
1562                             "}"
1563                         )
1564                     )
1565                 )
1566             );
1567     }
1568 
1569     function getFee() public view returns (uint) {
1570         return fee;
1571     }
1572 
1573     function setFee(uint _newFee) public onlyOwner {
1574         fee = _newFee;
1575     }
1576 
1577     function withdraw() public payable onlyOwner {
1578     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1579     require(os);
1580   }
1581 }