1 // File: @openzeppelin/contracts/utils/Base64.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Base64.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Provides a set of functions to operate with Base64 strings.
10  *
11  * _Available since v4.5._
12  */
13 library Base64 {
14     /**
15      * @dev Base64 Encoding/Decoding Table
16      */
17     string internal constant _TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
18 
19     /**
20      * @dev Converts a `bytes` to its Bytes64 `string` representation.
21      */
22     function encode(bytes memory data) internal pure returns (string memory) {
23         /**
24          * Inspired by Brecht Devos (Brechtpd) implementation - MIT licence
25          * https://github.com/Brechtpd/base64/blob/e78d9fd951e7b0977ddca77d92dc85183770daf4/base64.sol
26          */
27         if (data.length == 0) return "";
28 
29         // Loads the table into memory
30         string memory table = _TABLE;
31 
32         // Encoding takes 3 bytes chunks of binary data from `bytes` data parameter
33         // and split into 4 numbers of 6 bits.
34         // The final Base64 length should be `bytes` data length multiplied by 4/3 rounded up
35         // - `data.length + 2`  -> Round up
36         // - `/ 3`              -> Number of 3-bytes chunks
37         // - `4 *`              -> 4 characters for each chunk
38         string memory result = new string(4 * ((data.length + 2) / 3));
39 
40         /// @solidity memory-safe-assembly
41         assembly {
42             // Prepare the lookup table (skip the first "length" byte)
43             let tablePtr := add(table, 1)
44 
45             // Prepare result pointer, jump over length
46             let resultPtr := add(result, 32)
47 
48             // Run over the input, 3 bytes at a time
49             for {
50                 let dataPtr := data
51                 let endPtr := add(data, mload(data))
52             } lt(dataPtr, endPtr) {
53 
54             } {
55                 // Advance 3 bytes
56                 dataPtr := add(dataPtr, 3)
57                 let input := mload(dataPtr)
58 
59                 // To write each character, shift the 3 bytes (18 bits) chunk
60                 // 4 times in blocks of 6 bits for each character (18, 12, 6, 0)
61                 // and apply logical AND with 0x3F which is the number of
62                 // the previous character in the ASCII table prior to the Base64 Table
63                 // The result is then added to the table to get the character to write,
64                 // and finally write it in the result pointer but with a left shift
65                 // of 256 (1 byte) - 8 (1 ASCII char) = 248 bits
66 
67                 mstore8(resultPtr, mload(add(tablePtr, and(shr(18, input), 0x3F))))
68                 resultPtr := add(resultPtr, 1) // Advance
69 
70                 mstore8(resultPtr, mload(add(tablePtr, and(shr(12, input), 0x3F))))
71                 resultPtr := add(resultPtr, 1) // Advance
72 
73                 mstore8(resultPtr, mload(add(tablePtr, and(shr(6, input), 0x3F))))
74                 resultPtr := add(resultPtr, 1) // Advance
75 
76                 mstore8(resultPtr, mload(add(tablePtr, and(input, 0x3F))))
77                 resultPtr := add(resultPtr, 1) // Advance
78             }
79 
80             // When data `bytes` is not exactly 3 bytes long
81             // it is padded with `=` characters at the end
82             switch mod(mload(data), 3)
83             case 1 {
84                 mstore8(sub(resultPtr, 1), 0x3d)
85                 mstore8(sub(resultPtr, 2), 0x3d)
86             }
87             case 2 {
88                 mstore8(sub(resultPtr, 1), 0x3d)
89             }
90         }
91 
92         return result;
93     }
94 }
95 
96 // File: @openzeppelin/contracts/utils/Strings.sol
97 
98 
99 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
100 
101 pragma solidity ^0.8.0;
102 
103 /**
104  * @dev String operations.
105  */
106 library Strings {
107     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
108     uint8 private constant _ADDRESS_LENGTH = 20;
109 
110     /**
111      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
112      */
113     function toString(uint256 value) internal pure returns (string memory) {
114         // Inspired by OraclizeAPI's implementation - MIT licence
115         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
116 
117         if (value == 0) {
118             return "0";
119         }
120         uint256 temp = value;
121         uint256 digits;
122         while (temp != 0) {
123             digits++;
124             temp /= 10;
125         }
126         bytes memory buffer = new bytes(digits);
127         while (value != 0) {
128             digits -= 1;
129             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
130             value /= 10;
131         }
132         return string(buffer);
133     }
134 
135     /**
136      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
137      */
138     function toHexString(uint256 value) internal pure returns (string memory) {
139         if (value == 0) {
140             return "0x00";
141         }
142         uint256 temp = value;
143         uint256 length = 0;
144         while (temp != 0) {
145             length++;
146             temp >>= 8;
147         }
148         return toHexString(value, length);
149     }
150 
151     /**
152      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
153      */
154     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
155         bytes memory buffer = new bytes(2 * length + 2);
156         buffer[0] = "0";
157         buffer[1] = "x";
158         for (uint256 i = 2 * length + 1; i > 1; --i) {
159             buffer[i] = _HEX_SYMBOLS[value & 0xf];
160             value >>= 4;
161         }
162         require(value == 0, "Strings: hex length insufficient");
163         return string(buffer);
164     }
165 
166     /**
167      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
168      */
169     function toHexString(address addr) internal pure returns (string memory) {
170         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
171     }
172 }
173 
174 // File: @openzeppelin/contracts/utils/Context.sol
175 
176 
177 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
178 
179 pragma solidity ^0.8.0;
180 
181 /**
182  * @dev Provides information about the current execution context, including the
183  * sender of the transaction and its data. While these are generally available
184  * via msg.sender and msg.data, they should not be accessed in such a direct
185  * manner, since when dealing with meta-transactions the account sending and
186  * paying for execution may not be the actual sender (as far as an application
187  * is concerned).
188  *
189  * This contract is only required for intermediate, library-like contracts.
190  */
191 abstract contract Context {
192     function _msgSender() internal view virtual returns (address) {
193         return msg.sender;
194     }
195 
196     function _msgData() internal view virtual returns (bytes calldata) {
197         return msg.data;
198     }
199 }
200 
201 // File: @openzeppelin/contracts/utils/Address.sol
202 
203 
204 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
205 
206 pragma solidity ^0.8.1;
207 
208 /**
209  * @dev Collection of functions related to the address type
210  */
211 library Address {
212     /**
213      * @dev Returns true if `account` is a contract.
214      *
215      * [IMPORTANT]
216      * ====
217      * It is unsafe to assume that an address for which this function returns
218      * false is an externally-owned account (EOA) and not a contract.
219      *
220      * Among others, `isContract` will return false for the following
221      * types of addresses:
222      *
223      *  - an externally-owned account
224      *  - a contract in construction
225      *  - an address where a contract will be created
226      *  - an address where a contract lived, but was destroyed
227      * ====
228      *
229      * [IMPORTANT]
230      * ====
231      * You shouldn't rely on `isContract` to protect against flash loan attacks!
232      *
233      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
234      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
235      * constructor.
236      * ====
237      */
238     function isContract(address account) internal view returns (bool) {
239         // This method relies on extcodesize/address.code.length, which returns 0
240         // for contracts in construction, since the code is only stored at the end
241         // of the constructor execution.
242 
243         return account.code.length > 0;
244     }
245 
246     /**
247      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
248      * `recipient`, forwarding all available gas and reverting on errors.
249      *
250      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
251      * of certain opcodes, possibly making contracts go over the 2300 gas limit
252      * imposed by `transfer`, making them unable to receive funds via
253      * `transfer`. {sendValue} removes this limitation.
254      *
255      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
256      *
257      * IMPORTANT: because control is transferred to `recipient`, care must be
258      * taken to not create reentrancy vulnerabilities. Consider using
259      * {ReentrancyGuard} or the
260      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
261      */
262     function sendValue(address payable recipient, uint256 amount) internal {
263         require(address(this).balance >= amount, "Address: insufficient balance");
264 
265         (bool success, ) = recipient.call{value: amount}("");
266         require(success, "Address: unable to send value, recipient may have reverted");
267     }
268 
269     /**
270      * @dev Performs a Solidity function call using a low level `call`. A
271      * plain `call` is an unsafe replacement for a function call: use this
272      * function instead.
273      *
274      * If `target` reverts with a revert reason, it is bubbled up by this
275      * function (like regular Solidity function calls).
276      *
277      * Returns the raw returned data. To convert to the expected return value,
278      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
279      *
280      * Requirements:
281      *
282      * - `target` must be a contract.
283      * - calling `target` with `data` must not revert.
284      *
285      * _Available since v3.1._
286      */
287     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
288         return functionCall(target, data, "Address: low-level call failed");
289     }
290 
291     /**
292      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
293      * `errorMessage` as a fallback revert reason when `target` reverts.
294      *
295      * _Available since v3.1._
296      */
297     function functionCall(
298         address target,
299         bytes memory data,
300         string memory errorMessage
301     ) internal returns (bytes memory) {
302         return functionCallWithValue(target, data, 0, errorMessage);
303     }
304 
305     /**
306      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
307      * but also transferring `value` wei to `target`.
308      *
309      * Requirements:
310      *
311      * - the calling contract must have an ETH balance of at least `value`.
312      * - the called Solidity function must be `payable`.
313      *
314      * _Available since v3.1._
315      */
316     function functionCallWithValue(
317         address target,
318         bytes memory data,
319         uint256 value
320     ) internal returns (bytes memory) {
321         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
322     }
323 
324     /**
325      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
326      * with `errorMessage` as a fallback revert reason when `target` reverts.
327      *
328      * _Available since v3.1._
329      */
330     function functionCallWithValue(
331         address target,
332         bytes memory data,
333         uint256 value,
334         string memory errorMessage
335     ) internal returns (bytes memory) {
336         require(address(this).balance >= value, "Address: insufficient balance for call");
337         require(isContract(target), "Address: call to non-contract");
338 
339         (bool success, bytes memory returndata) = target.call{value: value}(data);
340         return verifyCallResult(success, returndata, errorMessage);
341     }
342 
343     /**
344      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
345      * but performing a static call.
346      *
347      * _Available since v3.3._
348      */
349     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
350         return functionStaticCall(target, data, "Address: low-level static call failed");
351     }
352 
353     /**
354      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
355      * but performing a static call.
356      *
357      * _Available since v3.3._
358      */
359     function functionStaticCall(
360         address target,
361         bytes memory data,
362         string memory errorMessage
363     ) internal view returns (bytes memory) {
364         require(isContract(target), "Address: static call to non-contract");
365 
366         (bool success, bytes memory returndata) = target.staticcall(data);
367         return verifyCallResult(success, returndata, errorMessage);
368     }
369 
370     /**
371      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
372      * but performing a delegate call.
373      *
374      * _Available since v3.4._
375      */
376     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
377         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
378     }
379 
380     /**
381      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
382      * but performing a delegate call.
383      *
384      * _Available since v3.4._
385      */
386     function functionDelegateCall(
387         address target,
388         bytes memory data,
389         string memory errorMessage
390     ) internal returns (bytes memory) {
391         require(isContract(target), "Address: delegate call to non-contract");
392 
393         (bool success, bytes memory returndata) = target.delegatecall(data);
394         return verifyCallResult(success, returndata, errorMessage);
395     }
396 
397     /**
398      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
399      * revert reason using the provided one.
400      *
401      * _Available since v4.3._
402      */
403     function verifyCallResult(
404         bool success,
405         bytes memory returndata,
406         string memory errorMessage
407     ) internal pure returns (bytes memory) {
408         if (success) {
409             return returndata;
410         } else {
411             // Look for revert reason and bubble it up if present
412             if (returndata.length > 0) {
413                 // The easiest way to bubble the revert reason is using memory via assembly
414                 /// @solidity memory-safe-assembly
415                 assembly {
416                     let returndata_size := mload(returndata)
417                     revert(add(32, returndata), returndata_size)
418                 }
419             } else {
420                 revert(errorMessage);
421             }
422         }
423     }
424 }
425 
426 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
427 
428 
429 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
430 
431 pragma solidity ^0.8.0;
432 
433 /**
434  * @title ERC721 token receiver interface
435  * @dev Interface for any contract that wants to support safeTransfers
436  * from ERC721 asset contracts.
437  */
438 interface IERC721Receiver {
439     /**
440      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
441      * by `operator` from `from`, this function is called.
442      *
443      * It must return its Solidity selector to confirm the token transfer.
444      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
445      *
446      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
447      */
448     function onERC721Received(
449         address operator,
450         address from,
451         uint256 tokenId,
452         bytes calldata data
453     ) external returns (bytes4);
454 }
455 
456 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
457 
458 
459 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
460 
461 pragma solidity ^0.8.0;
462 
463 /**
464  * @dev Interface of the ERC165 standard, as defined in the
465  * https://eips.ethereum.org/EIPS/eip-165[EIP].
466  *
467  * Implementers can declare support of contract interfaces, which can then be
468  * queried by others ({ERC165Checker}).
469  *
470  * For an implementation, see {ERC165}.
471  */
472 interface IERC165 {
473     /**
474      * @dev Returns true if this contract implements the interface defined by
475      * `interfaceId`. See the corresponding
476      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
477      * to learn more about how these ids are created.
478      *
479      * This function call must use less than 30 000 gas.
480      */
481     function supportsInterface(bytes4 interfaceId) external view returns (bool);
482 }
483 
484 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
485 
486 
487 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
488 
489 pragma solidity ^0.8.0;
490 
491 
492 /**
493  * @dev Implementation of the {IERC165} interface.
494  *
495  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
496  * for the additional interface id that will be supported. For example:
497  *
498  * ```solidity
499  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
500  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
501  * }
502  * ```
503  *
504  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
505  */
506 abstract contract ERC165 is IERC165 {
507     /**
508      * @dev See {IERC165-supportsInterface}.
509      */
510     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
511         return interfaceId == type(IERC165).interfaceId;
512     }
513 }
514 
515 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
516 
517 
518 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
519 
520 pragma solidity ^0.8.0;
521 
522 
523 /**
524  * @dev Required interface of an ERC721 compliant contract.
525  */
526 interface IERC721 is IERC165 {
527     /**
528      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
529      */
530     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
531 
532     /**
533      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
534      */
535     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
536 
537     /**
538      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
539      */
540     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
541 
542     /**
543      * @dev Returns the number of tokens in ``owner``'s account.
544      */
545     function balanceOf(address owner) external view returns (uint256 balance);
546 
547     /**
548      * @dev Returns the owner of the `tokenId` token.
549      *
550      * Requirements:
551      *
552      * - `tokenId` must exist.
553      */
554     function ownerOf(uint256 tokenId) external view returns (address owner);
555 
556     /**
557      * @dev Safely transfers `tokenId` token from `from` to `to`.
558      *
559      * Requirements:
560      *
561      * - `from` cannot be the zero address.
562      * - `to` cannot be the zero address.
563      * - `tokenId` token must exist and be owned by `from`.
564      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
565      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
566      *
567      * Emits a {Transfer} event.
568      */
569     function safeTransferFrom(
570         address from,
571         address to,
572         uint256 tokenId,
573         bytes calldata data
574     ) external;
575 
576     /**
577      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
578      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
579      *
580      * Requirements:
581      *
582      * - `from` cannot be the zero address.
583      * - `to` cannot be the zero address.
584      * - `tokenId` token must exist and be owned by `from`.
585      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
586      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
587      *
588      * Emits a {Transfer} event.
589      */
590     function safeTransferFrom(
591         address from,
592         address to,
593         uint256 tokenId
594     ) external;
595 
596     /**
597      * @dev Transfers `tokenId` token from `from` to `to`.
598      *
599      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
600      *
601      * Requirements:
602      *
603      * - `from` cannot be the zero address.
604      * - `to` cannot be the zero address.
605      * - `tokenId` token must be owned by `from`.
606      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
607      *
608      * Emits a {Transfer} event.
609      */
610     function transferFrom(
611         address from,
612         address to,
613         uint256 tokenId
614     ) external;
615 
616     /**
617      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
618      * The approval is cleared when the token is transferred.
619      *
620      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
621      *
622      * Requirements:
623      *
624      * - The caller must own the token or be an approved operator.
625      * - `tokenId` must exist.
626      *
627      * Emits an {Approval} event.
628      */
629     function approve(address to, uint256 tokenId) external;
630 
631     /**
632      * @dev Approve or remove `operator` as an operator for the caller.
633      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
634      *
635      * Requirements:
636      *
637      * - The `operator` cannot be the caller.
638      *
639      * Emits an {ApprovalForAll} event.
640      */
641     function setApprovalForAll(address operator, bool _approved) external;
642 
643     /**
644      * @dev Returns the account approved for `tokenId` token.
645      *
646      * Requirements:
647      *
648      * - `tokenId` must exist.
649      */
650     function getApproved(uint256 tokenId) external view returns (address operator);
651 
652     /**
653      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
654      *
655      * See {setApprovalForAll}
656      */
657     function isApprovedForAll(address owner, address operator) external view returns (bool);
658 }
659 
660 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
661 
662 
663 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
664 
665 pragma solidity ^0.8.0;
666 
667 
668 /**
669  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
670  * @dev See https://eips.ethereum.org/EIPS/eip-721
671  */
672 interface IERC721Metadata is IERC721 {
673     /**
674      * @dev Returns the token collection name.
675      */
676     function name() external view returns (string memory);
677 
678     /**
679      * @dev Returns the token collection symbol.
680      */
681     function symbol() external view returns (string memory);
682 
683     /**
684      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
685      */
686     function tokenURI(uint256 tokenId) external view returns (string memory);
687 }
688 
689 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
690 
691 
692 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
693 
694 pragma solidity ^0.8.0;
695 
696 
697 
698 
699 
700 
701 
702 
703 /**
704  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
705  * the Metadata extension, but not including the Enumerable extension, which is available separately as
706  * {ERC721Enumerable}.
707  */
708 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
709     using Address for address;
710     using Strings for uint256;
711 
712     // Token name
713     string private _name;
714 
715     // Token symbol
716     string private _symbol;
717 
718     // Mapping from token ID to owner address
719     mapping(uint256 => address) private _owners;
720 
721     // Mapping owner address to token count
722     mapping(address => uint256) private _balances;
723 
724     // Mapping from token ID to approved address
725     mapping(uint256 => address) private _tokenApprovals;
726 
727     // Mapping from owner to operator approvals
728     mapping(address => mapping(address => bool)) private _operatorApprovals;
729 
730     /**
731      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
732      */
733     constructor(string memory name_, string memory symbol_) {
734         _name = name_;
735         _symbol = symbol_;
736     }
737 
738     /**
739      * @dev See {IERC165-supportsInterface}.
740      */
741     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
742         return
743             interfaceId == type(IERC721).interfaceId ||
744             interfaceId == type(IERC721Metadata).interfaceId ||
745             super.supportsInterface(interfaceId);
746     }
747 
748     /**
749      * @dev See {IERC721-balanceOf}.
750      */
751     function balanceOf(address owner) public view virtual override returns (uint256) {
752         require(owner != address(0), "ERC721: address zero is not a valid owner");
753         return _balances[owner];
754     }
755 
756     /**
757      * @dev See {IERC721-ownerOf}.
758      */
759     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
760         address owner = _owners[tokenId];
761         require(owner != address(0), "ERC721: invalid token ID");
762         return owner;
763     }
764 
765     /**
766      * @dev See {IERC721Metadata-name}.
767      */
768     function name() public view virtual override returns (string memory) {
769         return _name;
770     }
771 
772     /**
773      * @dev See {IERC721Metadata-symbol}.
774      */
775     function symbol() public view virtual override returns (string memory) {
776         return _symbol;
777     }
778 
779     /**
780      * @dev See {IERC721Metadata-tokenURI}.
781      */
782     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
783         _requireMinted(tokenId);
784 
785         string memory baseURI = _baseURI();
786         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
787     }
788 
789     /**
790      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
791      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
792      * by default, can be overridden in child contracts.
793      */
794     function _baseURI() internal view virtual returns (string memory) {
795         return "";
796     }
797 
798     /**
799      * @dev See {IERC721-approve}.
800      */
801     function approve(address to, uint256 tokenId) public virtual override {
802         address owner = ERC721.ownerOf(tokenId);
803         require(to != owner, "ERC721: approval to current owner");
804 
805         require(
806             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
807             "ERC721: approve caller is not token owner nor approved for all"
808         );
809 
810         _approve(to, tokenId);
811     }
812 
813     /**
814      * @dev See {IERC721-getApproved}.
815      */
816     function getApproved(uint256 tokenId) public view virtual override returns (address) {
817         _requireMinted(tokenId);
818 
819         return _tokenApprovals[tokenId];
820     }
821 
822     /**
823      * @dev See {IERC721-setApprovalForAll}.
824      */
825     function setApprovalForAll(address operator, bool approved) public virtual override {
826         _setApprovalForAll(_msgSender(), operator, approved);
827     }
828 
829     /**
830      * @dev See {IERC721-isApprovedForAll}.
831      */
832     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
833         return _operatorApprovals[owner][operator];
834     }
835 
836     /**
837      * @dev See {IERC721-transferFrom}.
838      */
839     function transferFrom(
840         address from,
841         address to,
842         uint256 tokenId
843     ) public virtual override {
844         //solhint-disable-next-line max-line-length
845         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
846 
847         _transfer(from, to, tokenId);
848     }
849 
850     /**
851      * @dev See {IERC721-safeTransferFrom}.
852      */
853     function safeTransferFrom(
854         address from,
855         address to,
856         uint256 tokenId
857     ) public virtual override {
858         safeTransferFrom(from, to, tokenId, "");
859     }
860 
861     /**
862      * @dev See {IERC721-safeTransferFrom}.
863      */
864     function safeTransferFrom(
865         address from,
866         address to,
867         uint256 tokenId,
868         bytes memory data
869     ) public virtual override {
870         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
871         _safeTransfer(from, to, tokenId, data);
872     }
873 
874     /**
875      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
876      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
877      *
878      * `data` is additional data, it has no specified format and it is sent in call to `to`.
879      *
880      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
881      * implement alternative mechanisms to perform token transfer, such as signature-based.
882      *
883      * Requirements:
884      *
885      * - `from` cannot be the zero address.
886      * - `to` cannot be the zero address.
887      * - `tokenId` token must exist and be owned by `from`.
888      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
889      *
890      * Emits a {Transfer} event.
891      */
892     function _safeTransfer(
893         address from,
894         address to,
895         uint256 tokenId,
896         bytes memory data
897     ) internal virtual {
898         _transfer(from, to, tokenId);
899         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
900     }
901 
902     /**
903      * @dev Returns whether `tokenId` exists.
904      *
905      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
906      *
907      * Tokens start existing when they are minted (`_mint`),
908      * and stop existing when they are burned (`_burn`).
909      */
910     function _exists(uint256 tokenId) internal view virtual returns (bool) {
911         return _owners[tokenId] != address(0);
912     }
913 
914     /**
915      * @dev Returns whether `spender` is allowed to manage `tokenId`.
916      *
917      * Requirements:
918      *
919      * - `tokenId` must exist.
920      */
921     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
922         address owner = ERC721.ownerOf(tokenId);
923         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
924     }
925 
926     /**
927      * @dev Safely mints `tokenId` and transfers it to `to`.
928      *
929      * Requirements:
930      *
931      * - `tokenId` must not exist.
932      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
933      *
934      * Emits a {Transfer} event.
935      */
936     function _safeMint(address to, uint256 tokenId) internal virtual {
937         _safeMint(to, tokenId, "");
938     }
939 
940     /**
941      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
942      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
943      */
944     function _safeMint(
945         address to,
946         uint256 tokenId,
947         bytes memory data
948     ) internal virtual {
949         _mint(to, tokenId);
950         require(
951             _checkOnERC721Received(address(0), to, tokenId, data),
952             "ERC721: transfer to non ERC721Receiver implementer"
953         );
954     }
955 
956     /**
957      * @dev Mints `tokenId` and transfers it to `to`.
958      *
959      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
960      *
961      * Requirements:
962      *
963      * - `tokenId` must not exist.
964      * - `to` cannot be the zero address.
965      *
966      * Emits a {Transfer} event.
967      */
968     function _mint(address to, uint256 tokenId) internal virtual {
969         require(to != address(0), "ERC721: mint to the zero address");
970         require(!_exists(tokenId), "ERC721: token already minted");
971 
972         _beforeTokenTransfer(address(0), to, tokenId);
973 
974         _balances[to] += 1;
975         _owners[tokenId] = to;
976 
977         emit Transfer(address(0), to, tokenId);
978 
979         _afterTokenTransfer(address(0), to, tokenId);
980     }
981 
982     /**
983      * @dev Destroys `tokenId`.
984      * The approval is cleared when the token is burned.
985      *
986      * Requirements:
987      *
988      * - `tokenId` must exist.
989      *
990      * Emits a {Transfer} event.
991      */
992     function _burn(uint256 tokenId) internal virtual {
993         address owner = ERC721.ownerOf(tokenId);
994 
995         _beforeTokenTransfer(owner, address(0), tokenId);
996 
997         // Clear approvals
998         _approve(address(0), tokenId);
999 
1000         _balances[owner] -= 1;
1001         delete _owners[tokenId];
1002 
1003         emit Transfer(owner, address(0), tokenId);
1004 
1005         _afterTokenTransfer(owner, address(0), tokenId);
1006     }
1007 
1008     /**
1009      * @dev Transfers `tokenId` from `from` to `to`.
1010      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1011      *
1012      * Requirements:
1013      *
1014      * - `to` cannot be the zero address.
1015      * - `tokenId` token must be owned by `from`.
1016      *
1017      * Emits a {Transfer} event.
1018      */
1019     function _transfer(
1020         address from,
1021         address to,
1022         uint256 tokenId
1023     ) internal virtual {
1024         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1025         require(to != address(0), "ERC721: transfer to the zero address");
1026 
1027         _beforeTokenTransfer(from, to, tokenId);
1028 
1029         // Clear approvals from the previous owner
1030         _approve(address(0), tokenId);
1031 
1032         _balances[from] -= 1;
1033         _balances[to] += 1;
1034         _owners[tokenId] = to;
1035 
1036         emit Transfer(from, to, tokenId);
1037 
1038         _afterTokenTransfer(from, to, tokenId);
1039     }
1040 
1041     /**
1042      * @dev Approve `to` to operate on `tokenId`
1043      *
1044      * Emits an {Approval} event.
1045      */
1046     function _approve(address to, uint256 tokenId) internal virtual {
1047         _tokenApprovals[tokenId] = to;
1048         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1049     }
1050 
1051     /**
1052      * @dev Approve `operator` to operate on all of `owner` tokens
1053      *
1054      * Emits an {ApprovalForAll} event.
1055      */
1056     function _setApprovalForAll(
1057         address owner,
1058         address operator,
1059         bool approved
1060     ) internal virtual {
1061         require(owner != operator, "ERC721: approve to caller");
1062         _operatorApprovals[owner][operator] = approved;
1063         emit ApprovalForAll(owner, operator, approved);
1064     }
1065 
1066     /**
1067      * @dev Reverts if the `tokenId` has not been minted yet.
1068      */
1069     function _requireMinted(uint256 tokenId) internal view virtual {
1070         require(_exists(tokenId), "ERC721: invalid token ID");
1071     }
1072 
1073     /**
1074      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1075      * The call is not executed if the target address is not a contract.
1076      *
1077      * @param from address representing the previous owner of the given token ID
1078      * @param to target address that will receive the tokens
1079      * @param tokenId uint256 ID of the token to be transferred
1080      * @param data bytes optional data to send along with the call
1081      * @return bool whether the call correctly returned the expected magic value
1082      */
1083     function _checkOnERC721Received(
1084         address from,
1085         address to,
1086         uint256 tokenId,
1087         bytes memory data
1088     ) private returns (bool) {
1089         if (to.isContract()) {
1090             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1091                 return retval == IERC721Receiver.onERC721Received.selector;
1092             } catch (bytes memory reason) {
1093                 if (reason.length == 0) {
1094                     revert("ERC721: transfer to non ERC721Receiver implementer");
1095                 } else {
1096                     /// @solidity memory-safe-assembly
1097                     assembly {
1098                         revert(add(32, reason), mload(reason))
1099                     }
1100                 }
1101             }
1102         } else {
1103             return true;
1104         }
1105     }
1106 
1107     /**
1108      * @dev Hook that is called before any token transfer. This includes minting
1109      * and burning.
1110      *
1111      * Calling conditions:
1112      *
1113      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1114      * transferred to `to`.
1115      * - When `from` is zero, `tokenId` will be minted for `to`.
1116      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1117      * - `from` and `to` are never both zero.
1118      *
1119      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1120      */
1121     function _beforeTokenTransfer(
1122         address from,
1123         address to,
1124         uint256 tokenId
1125     ) internal virtual {}
1126 
1127     /**
1128      * @dev Hook that is called after any transfer of tokens. This includes
1129      * minting and burning.
1130      *
1131      * Calling conditions:
1132      *
1133      * - when `from` and `to` are both non-zero.
1134      * - `from` and `to` are never both zero.
1135      *
1136      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1137      */
1138     function _afterTokenTransfer(
1139         address from,
1140         address to,
1141         uint256 tokenId
1142     ) internal virtual {}
1143 }
1144 
1145 // File: contracts/Story.sol
1146 
1147 
1148 
1149 pragma solidity 0.8.17;
1150 
1151 
1152 
1153 
1154 interface ICharacter
1155 {
1156     function getStrength(uint256 tokenId) external view returns (string memory);
1157     function getDexterity(uint256 tokenId) external view returns (string memory);
1158     function getIntelligence(uint256 tokenId) external view returns (string memory);
1159     function getVitality(uint256 tokenId) external view returns (string memory);
1160     function getLuck(uint256 tokenId) external view returns (string memory);
1161     function getFaith(uint256 tokenId) external view returns (string memory);
1162     function getProfession(uint256 tokenId) external view returns (string memory);
1163     function getRace(uint256 tokenId) external view returns (string memory);
1164 }
1165 
1166 interface ILootBag
1167 {
1168     function getWeapon(uint256 tokenId) external view returns (string memory);
1169     function getChest(uint256 tokenId) external view returns (string memory);
1170     function getHead(uint256 tokenId) external view returns (string memory);
1171     function getWaist(uint256 tokenId) external view returns (string memory);
1172     function getFoot(uint256 tokenId) external view returns (string memory);
1173     function getHand(uint256 tokenId) external view returns (string memory);
1174     function getNeck(uint256 tokenId) external view returns (string memory);
1175     function getRing(uint256 tokenId) external view returns (string memory);
1176 }
1177 
1178 contract Stories is ERC721
1179 {
1180     address constant CHAR_CONTRACT_ADDRESS = 0x7403AC30DE7309a0bF019cdA8EeC034a5507cbB3;
1181     address constant LOOT_CONTRACT_ADDRESS = 0xFF9C1b15B16263C61d017ee9F65C50e4AE0113D7; 
1182     
1183     uint256 public totalSupply;
1184 
1185     struct Character
1186     {
1187         uint256 id;  /* 8001 to 12000 */
1188         uint256 bag; /* 1 to 7777 */
1189     }
1190 
1191     struct Adventure
1192     {
1193         Character hero;
1194         Character villain;
1195     }
1196 
1197     mapping(uint256 => Adventure) private _adventures;
1198     
1199     function tokenURI(uint256 tokenId) override public view returns (string memory output) 
1200     {
1201         Character memory hero = _adventures[tokenId].hero;
1202         Character memory villain = _adventures[tokenId].villain;
1203         
1204         string[18] memory parts;
1205         
1206         _introduction(hero, villain, parts);
1207         uint256 outcome = _battle(hero, villain, parts);
1208         _ending(hero, villain, parts, outcome);
1209        
1210         parts[17] = '</svg>';
1211         
1212         string memory svg;
1213         svg = string(abi.encodePacked(svg, parts[0],parts[1],parts[2],parts[3],parts[4],parts[5]));
1214         svg = string(abi.encodePacked(svg, parts[6],parts[7],parts[8],parts[9],parts[10],parts[11]));
1215         svg = string(abi.encodePacked(svg, parts[12],parts[13],parts[14],parts[15],parts[16],parts[17]));
1216         
1217         string memory strOutcome;
1218      
1219         if (outcome == 2) strOutcome = "Victory";
1220         else if (outcome == 1) strOutcome = "Defeat";
1221         else strOutcome = "Tie";
1222         
1223         bytes memory attributes = 
1224             abi.encodePacked(
1225                 "[{\"trait_type\":\"Location\",\"value\":\"",_getLocation(hero),"\"},{\"trait_type\":\"Outcome\",\"value\":\"",strOutcome,"\"}]");
1226         
1227         string memory description = "1001 onchain stories. Storytelling NFT project.";
1228         string memory json = 
1229             Base64.encode(
1230                 abi.encodePacked(
1231                     "{\"name\": \"Story #", Strings.toString(tokenId), 
1232                     "\", \"description\": \"", 
1233                     description,
1234                     "\", \"image\": \"data:image/svg+xml;base64,", 
1235                     Base64.encode(bytes(svg)), 
1236                     "\", \"attributes\":", 
1237                     attributes,
1238                     "}"));
1239         
1240         output = string(abi.encodePacked('data:application/json;base64,', json));
1241     }
1242 
1243     function _introduction(Character memory player, Character memory enemy, string[18] memory parts) private view
1244     {
1245         AdventureTemplate.introduction(parts, _getRace(player), _getRace(enemy), _getLocation(player));
1246     }
1247     
1248     function _battle(Character memory player, Character memory enemy, string[18] memory parts) private view returns (uint256 outcome)
1249     {
1250         outcome = 0;
1251 
1252         uint256 offset = 4;
1253         
1254         uint256 playerHP = _getVitality(player);
1255         uint256 enemyHP = _getVitality(enemy);
1256         
1257         uint256 playerMaxDamage = _getMaxDamage(player);
1258         uint256 enemyMaxDamage = _getMaxDamage(enemy);
1259         
1260         for (uint256 i = 0; i < 6; ++i)
1261         {
1262             bool survived = true;
1263             
1264             if (Utils.random(string(abi.encodePacked(player.id, 'attack', i))) % 2 == 0)
1265             {
1266                 uint256 damage = Utils.random(string(abi.encodePacked(player.id, 'playerdamage', i))) % playerMaxDamage;
1267                 
1268                 if (damage < enemyHP)
1269                 {
1270                     enemyHP -= damage;
1271                 }
1272                 else
1273                 {
1274                     outcome = 2;
1275                     survived = false;
1276                 }
1277                 
1278                 offset = _playerAttack(player, enemy, parts, offset, damage, survived);
1279             }
1280             else
1281             {
1282                 uint256 damage = Utils.random(string(abi.encodePacked(player.id, 'enemydamage', i))) % enemyMaxDamage;
1283                 
1284                 if (damage < playerHP)
1285                 {
1286                     playerHP -= damage;
1287                 }
1288                 else
1289                 {
1290                     outcome = 1;
1291                     survived = false;
1292                 }
1293                 
1294                 offset = _enemyAttack(enemy, parts, offset, damage, survived);
1295             }
1296         
1297             if (!survived) break;
1298         }
1299     }
1300     
1301     function _ending(Character memory player, Character memory enemy, string[18] memory parts, uint256 outcome) private view
1302     {
1303         AdventureTemplate.ending(parts, player.id, _getRace(enemy), outcome);
1304     }
1305     
1306     function _playerAttack(Character memory player, Character memory enemy, string[18] memory parts, uint256 initialOffset, uint256 damage, bool survived) private view returns (uint256 offset)
1307     {
1308         offset = AdventureTemplate.playerAttack(parts, _getWeapon(player), _getRace(enemy), initialOffset, damage, survived);
1309     }
1310     
1311     function _enemyAttack(Character memory enemy, string[18] memory parts, uint256 initialOffset, uint256 damage, bool survived) private view returns (uint256 offset)
1312     {
1313         offset = AdventureTemplate.enemyAttack(parts, _getRace(enemy), _getWeapon(enemy), initialOffset, damage, survived);
1314     }
1315         
1316     function _getWeapon(Character memory character) private view returns (string memory name)
1317     {
1318         string memory fullWeaponName = ILootBag(LOOT_CONTRACT_ADDRESS).getWeapon(character.bag);
1319         
1320         return LootParser.getWeaponName(fullWeaponName);
1321     }
1322     
1323     function _getRace(Character memory character) private view returns (string memory race)
1324     {
1325         string memory fullRace = ICharacter(CHAR_CONTRACT_ADDRESS).getRace(character.id);
1326         
1327         race = LootParser.getRace(fullRace);        
1328     }
1329 
1330     function _getLocation(Character memory character) private pure returns (string memory location)
1331     {
1332         uint256 rnd = Utils.random(string(abi.encodePacked(character.id, 'location'))) % 10000;
1333         
1334         if (rnd < 2000)
1335         {
1336             location = "a cave";
1337         }
1338         else if (rnd < 4000)
1339         {
1340             location = "a forest";
1341         }
1342         else if (rnd < 6000)
1343         {
1344             location = "a desert";
1345         }
1346         else if (rnd < 8000)
1347         {
1348             location = "mines";
1349         }
1350         else if (rnd < 9000)
1351         {
1352             location = "the Dark Forest";
1353         }
1354         else if (rnd < 9500)
1355         {
1356             location = "the Magic Meadow";
1357         }
1358         else if (rnd < 9750)
1359         {
1360             location = "a dungeon";
1361         }
1362         else if (rnd < 9875)
1363         {
1364             location = "an abandoned fortress";   
1365         }
1366         else if (rnd < 9940)
1367         {
1368             location = "a prison";
1369         }
1370         else if (rnd < 9990)
1371         {
1372             location = "the Witch Tower";
1373         }
1374         else
1375         {
1376             location = "the Dark Castle";
1377         }
1378         
1379     }
1380     
1381     function _getVitality(Character memory character) private view returns (uint256 vitality)
1382     {
1383         string memory strValue = ICharacter(CHAR_CONTRACT_ADDRESS).getVitality(character.id);
1384         vitality = _getIntValue(bytes(strValue), bytes("Vitality ").length);
1385     }
1386 
1387     function _getMaxDamage(Character memory character) private view returns (uint256 damage)
1388     {
1389         string memory strValue = ICharacter(CHAR_CONTRACT_ADDRESS).getStrength(character.id);
1390         damage = _getIntValue(bytes(strValue), bytes("Strength ").length);
1391     }
1392     
1393     function _getIntValue(bytes memory bStr, uint256 baseLen) private pure returns (uint256 value)
1394     {
1395         if (bStr.length - baseLen > 2) return 10;
1396         
1397         value = LootParser.parseInt(bStr[baseLen]);
1398     }
1399 
1400     function mint() public 
1401     {
1402         require(totalSupply < 1001, "I don't know any more stories");
1403 
1404         totalSupply += 1;
1405 
1406         uint256 hseed = uint256(keccak256(abi.encodePacked([1, totalSupply, block.number])));
1407         uint256 vseed = uint256(keccak256(abi.encodePacked([2, totalSupply, block.number])));
1408     
1409         uint hid = 1 + (hseed % 7777);
1410         uint hbid = 8001 + (hseed % 4000);
1411 
1412         uint vid = 1 + (vseed % 7777);
1413         uint vbid = 8001 + (vseed % 4000);
1414 
1415         _adventures[totalSupply] = Adventure({
1416             hero: Character({id: hid, bag: hbid}),
1417             villain: Character({id: vid, bag: vbid})
1418         });
1419 
1420         _mint(msg.sender, totalSupply);
1421     }
1422     
1423     constructor() ERC721("One Thousand and One Story", "1001") 
1424     {
1425         for (uint i = 0; i < 10; i++)
1426         {
1427             mint();
1428         }
1429     }
1430 }
1431 
1432 library Utils
1433 {
1434     function random(string memory input) internal pure returns (uint256) 
1435     {
1436         return uint256(keccak256(abi.encodePacked(input)));
1437     }  
1438 }
1439 
1440 library AdventureTemplate
1441 {
1442     function introduction(string[18] memory parts, string memory playerRace, string memory enemyRace, string memory location) internal pure
1443     {
1444         parts[ 0] = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350"><style>.base { fill: white; font-family: serif; font-size: 14px; }</style><rect width="100%" height="100%" fill="black" />';
1445         parts[ 1] = string(abi.encodePacked('<text x="10" y="20" class="base">Player: ', playerRace, '</text>'));
1446         parts[ 2] = string(abi.encodePacked('<text x="10" y="40" class="base">You entered ', location, '</text>'));
1447         parts[ 3] = string(abi.encodePacked('<text x="10" y="60" class="base">You ran into an angry ', enemyRace, '</text>'));
1448     }
1449     
1450     function ending(string[18] memory parts, uint256 playerId, string memory enemyRace, uint256 outcome) internal pure
1451     {
1452         string memory finale;
1453         
1454         if (outcome == 2)
1455         {
1456             finale = "Glorious victory!";
1457         }
1458         else if (outcome == 1)
1459         {
1460             finale = "The hero is defeated but not forgotten";
1461         }
1462         else
1463         {
1464             if (Utils.random(string(abi.encodePacked(playerId, "tied"))) % 2 == 0)
1465             {
1466                 finale = "You run away with your tail between your legs";
1467             }
1468             else
1469             {
1470                 finale = string(abi.encodePacked(enemyRace, ' retreats. The way is clear.'));
1471             }
1472         }
1473         
1474         parts[16] = string(abi.encodePacked('<text x="10" y="320" class="base">', finale, '</text>'));
1475     }
1476     
1477     function playerAttack(string[18] memory parts, string memory weapon, string memory enemy,  uint256 initialOffset, uint256 damage, bool survived) internal pure returns (uint256 offset)
1478     {
1479         offset = initialOffset;
1480         string memory finale = survived ? "but survived" : "and fell dead";
1481         
1482         parts[offset] = string(abi.encodePacked('<text x="10" y="', Strings.toString(offset * 20),'" class="base">You attack the ', enemy,' with your ', weapon, '</text>'));
1483         offset += 1;
1484         parts[offset] = string(abi.encodePacked('<text x="10" y="', Strings.toString(offset * 20),'" class="base">', enemy, ' took ', Strings.toString(damage), ' damage ', finale, '</text>'));
1485         offset += 1;
1486     }
1487     
1488     function enemyAttack(string[18] memory parts, string memory enemy, string memory weapon, uint256 initialOffset, uint256 damage, bool survived) internal pure returns (uint256 offset)
1489     {
1490         offset = initialOffset;
1491         string memory finale = survived ? "but survived" : "and fell dead";
1492         
1493         parts[offset] = string(abi.encodePacked('<text x="10" y="', Strings.toString(offset * 20),'" class="base">', enemy,' attacks you with the ', weapon, '</text>'));
1494         offset += 1;
1495         parts[offset] = string(abi.encodePacked('<text x="10" y="', Strings.toString(offset * 20),'" class="base">You took ', Strings.toString(damage), ' damage ', finale, '</text>'));
1496         offset += 1;
1497     }
1498 }
1499 
1500 library LootParser 
1501 {
1502     function compareStrings(string memory a, string memory b) internal pure returns (bool) 
1503     {
1504         if (bytes(a).length != bytes(b).length) 
1505         {
1506             return false;
1507         } 
1508         else 
1509         {
1510             return keccak256(abi.encodePacked(a)) == keccak256(abi.encodePacked(b));
1511         }
1512     }
1513     
1514     function parseInt(bytes1 b1) internal pure returns (uint256 value)
1515     {
1516         if (b1 == bytes("1")[0]) return 1;
1517         if (b1 == bytes("2")[0]) return 2;
1518         if (b1 == bytes("3")[0]) return 3;
1519         if (b1 == bytes("4")[0]) return 4;
1520         if (b1 == bytes("5")[0]) return 5;
1521         if (b1 == bytes("6")[0]) return 6;
1522         if (b1 == bytes("7")[0]) return 7;
1523         if (b1 == bytes("8")[0]) return 8;
1524         if (b1 == bytes("9")[0]) return 9;
1525         
1526         require(false, "Shouldn't be here");
1527     }
1528     
1529     function getRace(string memory fullRace) internal pure returns (string memory race)
1530     {
1531         bytes memory bStr = bytes(fullRace);
1532         bytes memory space = bytes(" ");
1533         
1534         for (uint i = 0; i < bStr.length; ++i)
1535         {
1536             if (bStr[i] == space[0]) break;
1537                 
1538             race = string(abi.encodePacked(race, bStr[i]));
1539         }
1540     }
1541     
1542     function getWeaponName(string memory fullWeaponName) internal pure returns (string memory name)
1543     {
1544         bytes memory bStr = bytes(fullWeaponName);
1545         bytes memory quote = bytes('"');
1546         bytes memory space = bytes(" ");
1547         
1548         uint256 startingIndex;
1549         bool hasName;
1550         
1551         if (bStr[0] == quote[0])
1552         {
1553             hasName = true;
1554             startingIndex = 1;
1555         }
1556         
1557         bool firstPart = true;
1558         string memory part;
1559         
1560         for (uint i = startingIndex; i < bStr.length; ++i)
1561         {
1562             if (hasName)
1563             {
1564                 if (bStr[i] == quote[0])
1565                 {
1566                     hasName = false;
1567                 }
1568                 continue;
1569             }
1570             
1571             if (bStr[i] == space[0])
1572             {
1573                 if (compareStrings(part, "of"))
1574                     return name;
1575                 
1576                 if (firstPart)
1577                 {
1578                     name = part;
1579                 }
1580                 else
1581                 {
1582                     name = string(abi.encodePacked(name, " ", part));
1583                 }
1584                 part = "";
1585             }
1586             else
1587             {
1588                 part = string(abi.encodePacked(part, bStr[i]));
1589             }
1590         }
1591         
1592         name = string(abi.encodePacked(name, " ", part));
1593     }
1594 }