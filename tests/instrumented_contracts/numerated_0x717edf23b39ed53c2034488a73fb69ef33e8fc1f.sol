1 //SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.1;
4 
5 /**
6  * @dev Collection of functions related to the address type
7  */
8 library Address {
9     /**
10      * @dev Returns true if `account` is a contract.
11      *
12      * [IMPORTANT]
13      * ====
14      * It is unsafe to assume that an address for which this function returns
15      * false is an externally-owned account (EOA) and not a contract.
16      *
17      * Among others, `isContract` will return false for the following
18      * types of addresses:
19      *
20      *  - an externally-owned account
21      *  - a contract in construction
22      *  - an address where a contract will be created
23      *  - an address where a contract lived, but was destroyed
24      * ====
25      *
26      * [IMPORTANT]
27      * ====
28      * You shouldn't rely on `isContract` to protect against flash loan attacks!
29      *
30      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
31      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
32      * constructor.
33      * ====
34      */
35     function isContract(address account) internal view returns (bool) {
36         // This method relies on extcodesize/address.code.length, which returns 0
37         // for contracts in construction, since the code is only stored at the end
38         // of the constructor execution.
39 
40         return account.code.length > 0;
41     }
42 
43     /**
44      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
45      * `recipient`, forwarding all available gas and reverting on errors.
46      *
47      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
48      * of certain opcodes, possibly making contracts go over the 2300 gas limit
49      * imposed by `transfer`, making them unable to receive funds via
50      * `transfer`. {sendValue} removes this limitation.
51      *
52      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
53      *
54      * IMPORTANT: because control is transferred to `recipient`, care must be
55      * taken to not create reentrancy vulnerabilities. Consider using
56      * {ReentrancyGuard} or the
57      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
58      */
59     function sendValue(address payable recipient, uint256 amount) internal {
60         require(address(this).balance >= amount, "Address: insufficient balance");
61 
62         (bool success, ) = recipient.call{value: amount}("");
63         require(success, "Address: unable to send value, recipient may have reverted");
64     }
65 
66     /**
67      * @dev Performs a Solidity function call using a low level `call`. A
68      * plain `call` is an unsafe replacement for a function call: use this
69      * function instead.
70      *
71      * If `target` reverts with a revert reason, it is bubbled up by this
72      * function (like regular Solidity function calls).
73      *
74      * Returns the raw returned data. To convert to the expected return value,
75      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
76      *
77      * Requirements:
78      *
79      * - `target` must be a contract.
80      * - calling `target` with `data` must not revert.
81      *
82      * _Available since v3.1._
83      */
84     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
85         return functionCall(target, data, "Address: low-level call failed");
86     }
87 
88     /**
89      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
90      * `errorMessage` as a fallback revert reason when `target` reverts.
91      *
92      * _Available since v3.1._
93      */
94     function functionCall(
95         address target,
96         bytes memory data,
97         string memory errorMessage
98     ) internal returns (bytes memory) {
99         return functionCallWithValue(target, data, 0, errorMessage);
100     }
101 
102     /**
103      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
104      * but also transferring `value` wei to `target`.
105      *
106      * Requirements:
107      *
108      * - the calling contract must have an ETH balance of at least `value`.
109      * - the called Solidity function must be `payable`.
110      *
111      * _Available since v3.1._
112      */
113     function functionCallWithValue(
114         address target,
115         bytes memory data,
116         uint256 value
117     ) internal returns (bytes memory) {
118         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
119     }
120 
121     /**
122      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
123      * with `errorMessage` as a fallback revert reason when `target` reverts.
124      *
125      * _Available since v3.1._
126      */
127     function functionCallWithValue(
128         address target,
129         bytes memory data,
130         uint256 value,
131         string memory errorMessage
132     ) internal returns (bytes memory) {
133         require(address(this).balance >= value, "Address: insufficient balance for call");
134         require(isContract(target), "Address: call to non-contract");
135 
136         (bool success, bytes memory returndata) = target.call{value: value}(data);
137         return verifyCallResult(success, returndata, errorMessage);
138     }
139 
140     /**
141      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
142      * but performing a static call.
143      *
144      * _Available since v3.3._
145      */
146     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
147         return functionStaticCall(target, data, "Address: low-level static call failed");
148     }
149 
150     /**
151      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
152      * but performing a static call.
153      *
154      * _Available since v3.3._
155      */
156     function functionStaticCall(
157         address target,
158         bytes memory data,
159         string memory errorMessage
160     ) internal view returns (bytes memory) {
161         require(isContract(target), "Address: static call to non-contract");
162 
163         (bool success, bytes memory returndata) = target.staticcall(data);
164         return verifyCallResult(success, returndata, errorMessage);
165     }
166 
167     /**
168      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
169      * but performing a delegate call.
170      *
171      * _Available since v3.4._
172      */
173     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
174         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
175     }
176 
177     /**
178      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
179      * but performing a delegate call.
180      *
181      * _Available since v3.4._
182      */
183     function functionDelegateCall(
184         address target,
185         bytes memory data,
186         string memory errorMessage
187     ) internal returns (bytes memory) {
188         require(isContract(target), "Address: delegate call to non-contract");
189 
190         (bool success, bytes memory returndata) = target.delegatecall(data);
191         return verifyCallResult(success, returndata, errorMessage);
192     }
193 
194     /**
195      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
196      * revert reason using the provided one.
197      *
198      * _Available since v4.3._
199      */
200     function verifyCallResult(
201         bool success,
202         bytes memory returndata,
203         string memory errorMessage
204     ) internal pure returns (bytes memory) {
205         if (success) {
206             return returndata;
207         } else {
208             // Look for revert reason and bubble it up if present
209             if (returndata.length > 0) {
210                 // The easiest way to bubble the revert reason is using memory via assembly
211                 /// @solidity memory-safe-assembly
212                 assembly {
213                     let returndata_size := mload(returndata)
214                     revert(add(32, returndata), returndata_size)
215                 }
216             } else {
217                 revert(errorMessage);
218             }
219         }
220     }
221 }
222 
223 
224 
225 
226 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
227 
228 pragma solidity ^0.8.0;
229 
230 /**
231  * @title ERC721 token receiver interface
232  * @dev Interface for any contract that wants to support safeTransfers
233  * from ERC721 asset contracts.
234  */
235 interface IERC721Receiver {
236     /**
237      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
238      * by `operator` from `from`, this function is called.
239      *
240      * It must return its Solidity selector to confirm the token transfer.
241      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
242      *
243      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
244      */
245     function onERC721Received(
246         address operator,
247         address from,
248         uint256 tokenId,
249         bytes calldata data
250     ) external returns (bytes4);
251 }
252 
253 
254 
255 
256 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
257 
258 pragma solidity ^0.8.0;
259 
260 /**
261  * @dev String operations.
262  */
263 library Strings {
264     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
265     uint8 private constant _ADDRESS_LENGTH = 20;
266 
267     /**
268      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
269      */
270     function toString(uint256 value) internal pure returns (string memory) {
271         // Inspired by OraclizeAPI's implementation - MIT licence
272         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
273 
274         if (value == 0) {
275             return "0";
276         }
277         uint256 temp = value;
278         uint256 digits;
279         while (temp != 0) {
280             digits++;
281             temp /= 10;
282         }
283         bytes memory buffer = new bytes(digits);
284         while (value != 0) {
285             digits -= 1;
286             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
287             value /= 10;
288         }
289         return string(buffer);
290     }
291 
292     /**
293      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
294      */
295     function toHexString(uint256 value) internal pure returns (string memory) {
296         if (value == 0) {
297             return "0x00";
298         }
299         uint256 temp = value;
300         uint256 length = 0;
301         while (temp != 0) {
302             length++;
303             temp >>= 8;
304         }
305         return toHexString(value, length);
306     }
307 
308     /**
309      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
310      */
311     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
312         bytes memory buffer = new bytes(2 * length + 2);
313         buffer[0] = "0";
314         buffer[1] = "x";
315         for (uint256 i = 2 * length + 1; i > 1; --i) {
316             buffer[i] = _HEX_SYMBOLS[value & 0xf];
317             value >>= 4;
318         }
319         require(value == 0, "Strings: hex length insufficient");
320         return string(buffer);
321     }
322 
323     /**
324      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
325      */
326     function toHexString(address addr) internal pure returns (string memory) {
327         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
328     }
329 }
330 
331 
332 
333 pragma solidity ^0.8.7;
334 
335 
336 abstract contract MerkleProof {
337     bytes32 internal _wlMerkleRoot;
338 
339     // Free Mint
340     function _setwlMerkleRoot(bytes32 merkleRoot_) internal virtual {
341         _wlMerkleRoot = merkleRoot_;
342     }
343 
344     function isWhitelisted(address address_, uint256 wlCount, bytes32[] memory proof_) public view returns (bool) {
345         bytes32 _leaf = keccak256(abi.encodePacked(address_, wlCount));
346         for (uint256 i = 0; i < proof_.length; i++) {
347             _leaf = _leaf < proof_[i] ? keccak256(abi.encodePacked(_leaf, proof_[i])) : keccak256(abi.encodePacked(proof_[i], _leaf));
348         }
349         return _leaf == _wlMerkleRoot;
350     }
351 }
352 
353 
354 
355 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Base64.sol)
356 
357 pragma solidity ^0.8.0;
358 
359 /**
360  * @dev Provides a set of functions to operate with Base64 strings.
361  *
362  * _Available since v4.5._
363  */
364 library Base64 {
365     /**
366      * @dev Base64 Encoding/Decoding Table
367      */
368     string internal constant _TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
369 
370     /**
371      * @dev Converts a `bytes` to its Bytes64 `string` representation.
372      */
373     function encode(bytes memory data) internal pure returns (string memory) {
374         /**
375          * Inspired by Brecht Devos (Brechtpd) implementation - MIT licence
376          * https://github.com/Brechtpd/base64/blob/e78d9fd951e7b0977ddca77d92dc85183770daf4/base64.sol
377          */
378         if (data.length == 0) return "";
379 
380         // Loads the table into memory
381         string memory table = _TABLE;
382 
383         // Encoding takes 3 bytes chunks of binary data from `bytes` data parameter
384         // and split into 4 numbers of 6 bits.
385         // The final Base64 length should be `bytes` data length multiplied by 4/3 rounded up
386         // - `data.length + 2`  -> Round up
387         // - `/ 3`              -> Number of 3-bytes chunks
388         // - `4 *`              -> 4 characters for each chunk
389         string memory result = new string(4 * ((data.length + 2) / 3));
390 
391         /// @solidity memory-safe-assembly
392         assembly {
393             // Prepare the lookup table (skip the first "length" byte)
394             let tablePtr := add(table, 1)
395 
396             // Prepare result pointer, jump over length
397             let resultPtr := add(result, 32)
398 
399             // Run over the input, 3 bytes at a time
400             for {
401                 let dataPtr := data
402                 let endPtr := add(data, mload(data))
403             } lt(dataPtr, endPtr) {
404 
405             } {
406                 // Advance 3 bytes
407                 dataPtr := add(dataPtr, 3)
408                 let input := mload(dataPtr)
409 
410                 // To write each character, shift the 3 bytes (18 bits) chunk
411                 // 4 times in blocks of 6 bits for each character (18, 12, 6, 0)
412                 // and apply logical AND with 0x3F which is the number of
413                 // the previous character in the ASCII table prior to the Base64 Table
414                 // The result is then added to the table to get the character to write,
415                 // and finally write it in the result pointer but with a left shift
416                 // of 256 (1 byte) - 8 (1 ASCII char) = 248 bits
417 
418                 mstore8(resultPtr, mload(add(tablePtr, and(shr(18, input), 0x3F))))
419                 resultPtr := add(resultPtr, 1) // Advance
420 
421                 mstore8(resultPtr, mload(add(tablePtr, and(shr(12, input), 0x3F))))
422                 resultPtr := add(resultPtr, 1) // Advance
423 
424                 mstore8(resultPtr, mload(add(tablePtr, and(shr(6, input), 0x3F))))
425                 resultPtr := add(resultPtr, 1) // Advance
426 
427                 mstore8(resultPtr, mload(add(tablePtr, and(input, 0x3F))))
428                 resultPtr := add(resultPtr, 1) // Advance
429             }
430 
431             // When data `bytes` is not exactly 3 bytes long
432             // it is padded with `=` characters at the end
433             switch mod(mload(data), 3)
434             case 1 {
435                 mstore8(sub(resultPtr, 1), 0x3d)
436                 mstore8(sub(resultPtr, 2), 0x3d)
437             }
438             case 2 {
439                 mstore8(sub(resultPtr, 1), 0x3d)
440             }
441         }
442 
443         return result;
444     }
445 }
446 
447 
448 
449 
450 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
451 
452 pragma solidity ^0.8.0;
453 
454 /**
455  * @dev Interface of the ERC165 standard, as defined in the
456  * https://eips.ethereum.org/EIPS/eip-165[EIP].
457  *
458  * Implementers can declare support of contract interfaces, which can then be
459  * queried by others ({ERC165Checker}).
460  *
461  * For an implementation, see {ERC165}.
462  */
463 interface IERC165 {
464     /**
465      * @dev Returns true if this contract implements the interface defined by
466      * `interfaceId`. See the corresponding
467      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
468      * to learn more about how these ids are created.
469      *
470      * This function call must use less than 30 000 gas.
471      */
472     function supportsInterface(bytes4 interfaceId) external view returns (bool);
473 }
474 
475 
476 
477 
478 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
479 
480 pragma solidity ^0.8.0;
481 
482 
483 /**
484  * @dev Required interface of an ERC721 compliant contract.
485  */
486 interface IERC721 is IERC165 {
487     /**
488      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
489      */
490     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
491 
492     /**
493      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
494      */
495     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
496 
497     /**
498      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
499      */
500     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
501 
502     /**
503      * @dev Returns the number of tokens in ``owner``'s account.
504      */
505     function balanceOf(address owner) external view returns (uint256 balance);
506 
507     /**
508      * @dev Returns the owner of the `tokenId` token.
509      *
510      * Requirements:
511      *
512      * - `tokenId` must exist.
513      */
514     function ownerOf(uint256 tokenId) external view returns (address owner);
515 
516     /**
517      * @dev Safely transfers `tokenId` token from `from` to `to`.
518      *
519      * Requirements:
520      *
521      * - `from` cannot be the zero address.
522      * - `to` cannot be the zero address.
523      * - `tokenId` token must exist and be owned by `from`.
524      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
525      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
526      *
527      * Emits a {Transfer} event.
528      */
529     function safeTransferFrom(
530         address from,
531         address to,
532         uint256 tokenId,
533         bytes calldata data
534     ) external;
535 
536     /**
537      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
538      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
539      *
540      * Requirements:
541      *
542      * - `from` cannot be the zero address.
543      * - `to` cannot be the zero address.
544      * - `tokenId` token must exist and be owned by `from`.
545      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
546      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
547      *
548      * Emits a {Transfer} event.
549      */
550     function safeTransferFrom(
551         address from,
552         address to,
553         uint256 tokenId
554     ) external;
555 
556     /**
557      * @dev Transfers `tokenId` token from `from` to `to`.
558      *
559      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
560      *
561      * Requirements:
562      *
563      * - `from` cannot be the zero address.
564      * - `to` cannot be the zero address.
565      * - `tokenId` token must be owned by `from`.
566      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
567      *
568      * Emits a {Transfer} event.
569      */
570     function transferFrom(
571         address from,
572         address to,
573         uint256 tokenId
574     ) external;
575 
576     /**
577      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
578      * The approval is cleared when the token is transferred.
579      *
580      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
581      *
582      * Requirements:
583      *
584      * - The caller must own the token or be an approved operator.
585      * - `tokenId` must exist.
586      *
587      * Emits an {Approval} event.
588      */
589     function approve(address to, uint256 tokenId) external;
590 
591     /**
592      * @dev Approve or remove `operator` as an operator for the caller.
593      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
594      *
595      * Requirements:
596      *
597      * - The `operator` cannot be the caller.
598      *
599      * Emits an {ApprovalForAll} event.
600      */
601     function setApprovalForAll(address operator, bool _approved) external;
602 
603     /**
604      * @dev Returns the account approved for `tokenId` token.
605      *
606      * Requirements:
607      *
608      * - `tokenId` must exist.
609      */
610     function getApproved(uint256 tokenId) external view returns (address operator);
611 
612     /**
613      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
614      *
615      * See {setApprovalForAll}
616      */
617     function isApprovedForAll(address owner, address operator) external view returns (bool);
618 }
619 
620 
621 
622 
623 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
624 
625 pragma solidity ^0.8.0;
626 
627 
628 /**
629  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
630  * @dev See https://eips.ethereum.org/EIPS/eip-721
631  */
632 interface IERC721Metadata is IERC721 {
633     /**
634      * @dev Returns the token collection name.
635      */
636     function name() external view returns (string memory);
637 
638     /**
639      * @dev Returns the token collection symbol.
640      */
641     function symbol() external view returns (string memory);
642 
643     /**
644      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
645      */
646     function tokenURI(uint256 tokenId) external view returns (string memory);
647 }
648 
649 
650 
651 
652 // ERC721A Contracts v3.3.0
653 // Creator: Chiru Labs
654 
655 pragma solidity ^0.8.4;
656 
657 
658 
659 /**
660  * @dev Interface of an ERC721A compliant contract.
661  */
662 interface IERC721A is IERC721, IERC721Metadata {
663     /**
664      * The caller must own the token or be an approved operator.
665      */
666     error ApprovalCallerNotOwnerNorApproved();
667 
668     /**
669      * The token does not exist.
670      */
671     error ApprovalQueryForNonexistentToken();
672 
673     /**
674      * The caller cannot approve to their own address.
675      */
676     error ApproveToCaller();
677 
678     /**
679      * The caller cannot approve to the current owner.
680      */
681     error ApprovalToCurrentOwner();
682 
683     /**
684      * Cannot query the balance for the zero address.
685      */
686     error BalanceQueryForZeroAddress();
687 
688     /**
689      * Cannot mint to the zero address.
690      */
691     error MintToZeroAddress();
692 
693     /**
694      * The quantity of tokens minted must be more than zero.
695      */
696     error MintZeroQuantity();
697 
698     /**
699      * The token does not exist.
700      */
701     error OwnerQueryForNonexistentToken();
702 
703     /**
704      * The caller must own the token or be an approved operator.
705      */
706     error TransferCallerNotOwnerNorApproved();
707 
708     /**
709      * The token must be owned by `from`.
710      */
711     error TransferFromIncorrectOwner();
712 
713     /**
714      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
715      */
716     error TransferToNonERC721ReceiverImplementer();
717 
718     /**
719      * Cannot transfer to the zero address.
720      */
721     error TransferToZeroAddress();
722 
723     /**
724      * The token does not exist.
725      */
726     error URIQueryForNonexistentToken();
727 
728     // Compiler will pack this into a single 256bit word.
729     struct TokenOwnership {
730         // The address of the owner.
731         address addr;
732         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
733         uint64 startTimestamp;
734         // Whether the token has been burned.
735         bool burned;
736     }
737 
738     // Compiler will pack this into a single 256bit word.
739     struct AddressData {
740         // Realistically, 2**64-1 is more than enough.
741         uint64 balance;
742         // Keeps track of mint count with minimal overhead for tokenomics.
743         uint64 numberMinted;
744         // Keeps track of burn count with minimal overhead for tokenomics.
745         uint64 numberBurned;
746         // For miscellaneous variable(s) pertaining to the address
747         // (e.g. number of whitelist mint slots used).
748         // If there are multiple variables, please pack them into a uint64.
749         uint64 aux;
750     }
751 
752     /**
753      * @dev Returns the total amount of tokens stored by the contract.
754      * 
755      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
756      */
757     function totalSupply() external view returns (uint256);
758 }
759 
760 
761 
762 
763 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
764 
765 pragma solidity ^0.8.0;
766 
767 
768 /**
769  * @dev Implementation of the {IERC165} interface.
770  *
771  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
772  * for the additional interface id that will be supported. For example:
773  *
774  * ```solidity
775  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
776  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
777  * }
778  * ```
779  *
780  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
781  */
782 abstract contract ERC165 is IERC165 {
783     /**
784      * @dev See {IERC165-supportsInterface}.
785      */
786     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
787         return interfaceId == type(IERC165).interfaceId;
788     }
789 }
790 
791 
792 
793 
794 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
795 
796 pragma solidity ^0.8.0;
797 
798 
799 /**
800  * @dev Interface for the NFT Royalty Standard.
801  *
802  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
803  * support for royalty payments across all NFT marketplaces and ecosystem participants.
804  *
805  * _Available since v4.5._
806  */
807 interface IERC2981 is IERC165 {
808     /**
809      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
810      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
811      */
812     function royaltyInfo(uint256 tokenId, uint256 salePrice)
813         external
814         view
815         returns (address receiver, uint256 royaltyAmount);
816 }
817 
818 
819 
820 
821 // OpenZeppelin Contracts (last updated v4.7.0) (token/common/ERC2981.sol)
822 
823 pragma solidity ^0.8.0;
824 
825 
826 
827 /**
828  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
829  *
830  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
831  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
832  *
833  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
834  * fee is specified in basis points by default.
835  *
836  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
837  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
838  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
839  *
840  * _Available since v4.5._
841  */
842 abstract contract ERC2981 is IERC2981, ERC165 {
843     struct RoyaltyInfo {
844         address receiver;
845         uint96 royaltyFraction;
846     }
847 
848     RoyaltyInfo private _defaultRoyaltyInfo;
849     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
850 
851     /**
852      * @dev See {IERC165-supportsInterface}.
853      */
854     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
855         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
856     }
857 
858     /**
859      * @inheritdoc IERC2981
860      */
861     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
862         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
863 
864         if (royalty.receiver == address(0)) {
865             royalty = _defaultRoyaltyInfo;
866         }
867 
868         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
869 
870         return (royalty.receiver, royaltyAmount);
871     }
872 
873     /**
874      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
875      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
876      * override.
877      */
878     function _feeDenominator() internal pure virtual returns (uint96) {
879         return 10000;
880     }
881 
882     /**
883      * @dev Sets the royalty information that all ids in this contract will default to.
884      *
885      * Requirements:
886      *
887      * - `receiver` cannot be the zero address.
888      * - `feeNumerator` cannot be greater than the fee denominator.
889      */
890     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
891         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
892         require(receiver != address(0), "ERC2981: invalid receiver");
893 
894         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
895     }
896 
897     /**
898      * @dev Removes default royalty information.
899      */
900     function _deleteDefaultRoyalty() internal virtual {
901         delete _defaultRoyaltyInfo;
902     }
903 
904     /**
905      * @dev Sets the royalty information for a specific token id, overriding the global default.
906      *
907      * Requirements:
908      *
909      * - `receiver` cannot be the zero address.
910      * - `feeNumerator` cannot be greater than the fee denominator.
911      */
912     function _setTokenRoyalty(
913         uint256 tokenId,
914         address receiver,
915         uint96 feeNumerator
916     ) internal virtual {
917         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
918         require(receiver != address(0), "ERC2981: Invalid parameters");
919 
920         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
921     }
922 
923     /**
924      * @dev Resets royalty information for the token id back to the global default.
925      */
926     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
927         delete _tokenRoyaltyInfo[tokenId];
928     }
929 }
930 
931 
932 
933 
934 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
935 
936 pragma solidity ^0.8.0;
937 
938 /**
939  * @dev Contract module that helps prevent reentrant calls to a function.
940  *
941  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
942  * available, which can be applied to functions to make sure there are no nested
943  * (reentrant) calls to them.
944  *
945  * Note that because there is a single `nonReentrant` guard, functions marked as
946  * `nonReentrant` may not call one another. This can be worked around by making
947  * those functions `private`, and then adding `external` `nonReentrant` entry
948  * points to them.
949  *
950  * TIP: If you would like to learn more about reentrancy and alternative ways
951  * to protect against it, check out our blog post
952  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
953  */
954 abstract contract ReentrancyGuard {
955     // Booleans are more expensive than uint256 or any type that takes up a full
956     // word because each write operation emits an extra SLOAD to first read the
957     // slot's contents, replace the bits taken up by the boolean, and then write
958     // back. This is the compiler's defense against contract upgrades and
959     // pointer aliasing, and it cannot be disabled.
960 
961     // The values being non-zero value makes deployment a bit more expensive,
962     // but in exchange the refund on every call to nonReentrant will be lower in
963     // amount. Since refunds are capped to a percentage of the total
964     // transaction's gas, it is best to keep them low in cases like this one, to
965     // increase the likelihood of the full refund coming into effect.
966     uint256 private constant _NOT_ENTERED = 1;
967     uint256 private constant _ENTERED = 2;
968 
969     uint256 private _status;
970 
971     constructor() {
972         _status = _NOT_ENTERED;
973     }
974 
975     /**
976      * @dev Prevents a contract from calling itself, directly or indirectly.
977      * Calling a `nonReentrant` function from another `nonReentrant`
978      * function is not supported. It is possible to prevent this from happening
979      * by making the `nonReentrant` function external, and making it call a
980      * `private` function that does the actual work.
981      */
982     modifier nonReentrant() {
983         // On the first call to nonReentrant, _notEntered will be true
984         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
985 
986         // Any calls to nonReentrant after this point will fail
987         _status = _ENTERED;
988 
989         _;
990 
991         // By storing the original value once again, a refund is triggered (see
992         // https://eips.ethereum.org/EIPS/eip-2200)
993         _status = _NOT_ENTERED;
994     }
995 }
996 
997 
998 
999 
1000 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1001 
1002 pragma solidity ^0.8.0;
1003 
1004 /**
1005  * @dev Provides information about the current execution context, including the
1006  * sender of the transaction and its data. While these are generally available
1007  * via msg.sender and msg.data, they should not be accessed in such a direct
1008  * manner, since when dealing with meta-transactions the account sending and
1009  * paying for execution may not be the actual sender (as far as an application
1010  * is concerned).
1011  *
1012  * This contract is only required for intermediate, library-like contracts.
1013  */
1014 abstract contract Context {
1015     function _msgSender() internal view virtual returns (address) {
1016         return msg.sender;
1017     }
1018 
1019     function _msgData() internal view virtual returns (bytes calldata) {
1020         return msg.data;
1021     }
1022 }
1023 
1024 
1025 
1026 
1027 // ERC721A Contracts v3.3.0
1028 // Creator: Chiru Labs
1029 
1030 pragma solidity ^0.8.4;
1031 
1032 
1033 
1034 
1035 
1036 
1037 
1038 /**
1039  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1040  * the Metadata extension. Built to optimize for lower gas during batch mints.
1041  *
1042  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1043  *
1044  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1045  *
1046  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
1047  */
1048 contract ERC721A is Context, ERC165, IERC721A {
1049     using Address for address;
1050     using Strings for uint256;
1051 
1052     // The tokenId of the next token to be minted.
1053     uint256 internal _currentIndex;
1054 
1055     // The number of tokens burned.
1056     uint256 internal _burnCounter;
1057 
1058     // Token name
1059     string private _name;
1060 
1061     // Token symbol
1062     string private _symbol;
1063 
1064     // Mapping from token ID to ownership details
1065     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
1066     mapping(uint256 => TokenOwnership) internal _ownerships;
1067 
1068     // Mapping owner address to address data
1069     mapping(address => AddressData) private _addressData;
1070 
1071     // Mapping from token ID to approved address
1072     mapping(uint256 => address) private _tokenApprovals;
1073 
1074     // Mapping from owner to operator approvals
1075     mapping(address => mapping(address => bool)) private _operatorApprovals;
1076 
1077     constructor(string memory name_, string memory symbol_) {
1078         _name = name_;
1079         _symbol = symbol_;
1080         _currentIndex = _startTokenId();
1081     }
1082 
1083     /**
1084      * To change the starting tokenId, please override this function.
1085      */
1086     function _startTokenId() internal view virtual returns (uint256) {
1087         return 0;
1088     }
1089 
1090     /**
1091      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
1092      */
1093     function totalSupply() public view override returns (uint256) {
1094         // Counter underflow is impossible as _burnCounter cannot be incremented
1095         // more than _currentIndex - _startTokenId() times
1096         unchecked {
1097             return _currentIndex - _burnCounter - _startTokenId();
1098         }
1099     }
1100 
1101     /**
1102      * Returns the total amount of tokens minted in the contract.
1103      */
1104     function _totalMinted() internal view returns (uint256) {
1105         // Counter underflow is impossible as _currentIndex does not decrement,
1106         // and it is initialized to _startTokenId()
1107         unchecked {
1108             return _currentIndex - _startTokenId();
1109         }
1110     }
1111 
1112     /**
1113      * @dev See {IERC165-supportsInterface}.
1114      */
1115     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1116         return
1117             interfaceId == type(IERC721).interfaceId ||
1118             interfaceId == type(IERC721Metadata).interfaceId ||
1119             super.supportsInterface(interfaceId);
1120     }
1121 
1122     /**
1123      * @dev See {IERC721-balanceOf}.
1124      */
1125     function balanceOf(address owner) public view override returns (uint256) {
1126         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1127         return uint256(_addressData[owner].balance);
1128     }
1129 
1130     /**
1131      * Returns the number of tokens minted by `owner`.
1132      */
1133     function _numberMinted(address owner) internal view returns (uint256) {
1134         return uint256(_addressData[owner].numberMinted);
1135     }
1136 
1137     /**
1138      * Returns the number of tokens burned by or on behalf of `owner`.
1139      */
1140     function _numberBurned(address owner) internal view returns (uint256) {
1141         return uint256(_addressData[owner].numberBurned);
1142     }
1143 
1144     /**
1145      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1146      */
1147     function _getAux(address owner) internal view returns (uint64) {
1148         return _addressData[owner].aux;
1149     }
1150 
1151     /**
1152      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1153      * If there are multiple variables, please pack them into a uint64.
1154      */
1155     function _setAux(address owner, uint64 aux) internal {
1156         _addressData[owner].aux = aux;
1157     }
1158 
1159     /**
1160      * Gas spent here starts off proportional to the maximum mint batch size.
1161      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1162      */
1163     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1164         uint256 curr = tokenId;
1165 
1166         unchecked {
1167             if (_startTokenId() <= curr) if (curr < _currentIndex) {
1168                 TokenOwnership memory ownership = _ownerships[curr];
1169                 if (!ownership.burned) {
1170                     if (ownership.addr != address(0)) {
1171                         return ownership;
1172                     }
1173                     // Invariant:
1174                     // There will always be an ownership that has an address and is not burned
1175                     // before an ownership that does not have an address and is not burned.
1176                     // Hence, curr will not underflow.
1177                     while (true) {
1178                         curr--;
1179                         ownership = _ownerships[curr];
1180                         if (ownership.addr != address(0)) {
1181                             return ownership;
1182                         }
1183                     }
1184                 }
1185             }
1186         }
1187         revert OwnerQueryForNonexistentToken();
1188     }
1189 
1190     /**
1191      * @dev See {IERC721-ownerOf}.
1192      */
1193     function ownerOf(uint256 tokenId) public view override returns (address) {
1194         return _ownershipOf(tokenId).addr;
1195     }
1196 
1197     /**
1198      * @dev See {IERC721Metadata-name}.
1199      */
1200     function name() public view virtual override returns (string memory) {
1201         return _name;
1202     }
1203 
1204     /**
1205      * @dev See {IERC721Metadata-symbol}.
1206      */
1207     function symbol() public view virtual override returns (string memory) {
1208         return _symbol;
1209     }
1210 
1211     /**
1212      * @dev See {IERC721Metadata-tokenURI}.
1213      */
1214     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1215         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1216 
1217         string memory baseURI = _baseURI();
1218         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1219     }
1220 
1221     /**
1222      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1223      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1224      * by default, can be overriden in child contracts.
1225      */
1226     function _baseURI() internal view virtual returns (string memory) {
1227         return '';
1228     }
1229 
1230     /**
1231      * @dev See {IERC721-approve}.
1232      */
1233     function approve(address to, uint256 tokenId) public virtual override {
1234         address owner = ERC721A.ownerOf(tokenId);
1235         if (to == owner) revert ApprovalToCurrentOwner();
1236 
1237         if (_msgSender() != owner) if(!isApprovedForAll(owner, _msgSender())) {
1238             revert ApprovalCallerNotOwnerNorApproved();
1239         }
1240 
1241         _approve(to, tokenId, owner);
1242     }
1243 
1244     /**
1245      * @dev See {IERC721-getApproved}.
1246      */
1247     function getApproved(uint256 tokenId) public view override returns (address) {
1248         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1249 
1250         return _tokenApprovals[tokenId];
1251     }
1252 
1253     /**
1254      * @dev See {IERC721-setApprovalForAll}.
1255      */
1256     function setApprovalForAll(address operator, bool approved) public virtual override {
1257         if (operator == _msgSender()) revert ApproveToCaller();
1258 
1259         _operatorApprovals[_msgSender()][operator] = approved;
1260         emit ApprovalForAll(_msgSender(), operator, approved);
1261     }
1262 
1263     /**
1264      * @dev See {IERC721-isApprovedForAll}.
1265      */
1266     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1267         return _operatorApprovals[owner][operator];
1268     }
1269 
1270     /**
1271      * @dev See {IERC721-transferFrom}.
1272      */
1273     function transferFrom(
1274         address from,
1275         address to,
1276         uint256 tokenId
1277     ) public virtual override {
1278         _transfer(from, to, tokenId);
1279     }
1280 
1281     /**
1282      * @dev See {IERC721-safeTransferFrom}.
1283      */
1284     function safeTransferFrom(
1285         address from,
1286         address to,
1287         uint256 tokenId
1288     ) public virtual override {
1289         safeTransferFrom(from, to, tokenId, '');
1290     }
1291 
1292     /**
1293      * @dev See {IERC721-safeTransferFrom}.
1294      */
1295     function safeTransferFrom(
1296         address from,
1297         address to,
1298         uint256 tokenId,
1299         bytes memory _data
1300     ) public virtual override {
1301         _transfer(from, to, tokenId);
1302         if (to.isContract()) if(!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1303             revert TransferToNonERC721ReceiverImplementer();
1304         }
1305     }
1306 
1307     /**
1308      * @dev Returns whether `tokenId` exists.
1309      *
1310      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1311      *
1312      * Tokens start existing when they are minted (`_mint`),
1313      */
1314     function _exists(uint256 tokenId) internal view returns (bool) {
1315         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1316     }
1317 
1318     /**
1319      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1320      */
1321     function _safeMint(address to, uint256 quantity) internal {
1322         _safeMint(to, quantity, '');
1323     }
1324 
1325     /**
1326      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1327      *
1328      * Requirements:
1329      *
1330      * - If `to` refers to a smart contract, it must implement
1331      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1332      * - `quantity` must be greater than 0.
1333      *
1334      * Emits a {Transfer} event.
1335      */
1336     function _safeMint(
1337         address to,
1338         uint256 quantity,
1339         bytes memory _data
1340     ) internal {
1341         uint256 startTokenId = _currentIndex;
1342         if (to == address(0)) revert MintToZeroAddress();
1343         if (quantity == 0) revert MintZeroQuantity();
1344 
1345         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1346 
1347         // Overflows are incredibly unrealistic.
1348         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1349         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1350         unchecked {
1351             _addressData[to].balance += uint64(quantity);
1352             _addressData[to].numberMinted += uint64(quantity);
1353 
1354             _ownerships[startTokenId].addr = to;
1355             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1356 
1357             uint256 updatedIndex = startTokenId;
1358             uint256 end = updatedIndex + quantity;
1359 
1360             if (to.isContract()) {
1361                 do {
1362                     emit Transfer(address(0), to, updatedIndex);
1363                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1364                         revert TransferToNonERC721ReceiverImplementer();
1365                     }
1366                 } while (updatedIndex < end);
1367                 // Reentrancy protection
1368                 if (_currentIndex != startTokenId) revert();
1369             } else {
1370                 do {
1371                     emit Transfer(address(0), to, updatedIndex++);
1372                 } while (updatedIndex < end);
1373             }
1374             _currentIndex = updatedIndex;
1375         }
1376         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1377     }
1378 
1379     /**
1380      * @dev Mints `quantity` tokens and transfers them to `to`.
1381      *
1382      * Requirements:
1383      *
1384      * - `to` cannot be the zero address.
1385      * - `quantity` must be greater than 0.
1386      *
1387      * Emits a {Transfer} event.
1388      */
1389     function _mint(address to, uint256 quantity) internal {
1390         uint256 startTokenId = _currentIndex;
1391         if (to == address(0)) revert MintToZeroAddress();
1392         if (quantity == 0) revert MintZeroQuantity();
1393 
1394         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1395 
1396         // Overflows are incredibly unrealistic.
1397         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1398         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1399         unchecked {
1400             _addressData[to].balance += uint64(quantity);
1401             _addressData[to].numberMinted += uint64(quantity);
1402 
1403             _ownerships[startTokenId].addr = to;
1404             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1405 
1406             uint256 updatedIndex = startTokenId;
1407             uint256 end = updatedIndex + quantity;
1408 
1409             do {
1410                 emit Transfer(address(0), to, updatedIndex++);
1411             } while (updatedIndex < end);
1412 
1413             _currentIndex = updatedIndex;
1414         }
1415         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1416     }
1417 
1418     /**
1419      * @dev Transfers `tokenId` from `from` to `to`.
1420      *
1421      * Requirements:
1422      *
1423      * - `to` cannot be the zero address.
1424      * - `tokenId` token must be owned by `from`.
1425      *
1426      * Emits a {Transfer} event.
1427      */
1428     function _transfer(
1429         address from,
1430         address to,
1431         uint256 tokenId
1432     ) private {
1433         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1434 
1435         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1436 
1437         bool isApprovedOrOwner = (_msgSender() == from ||
1438             isApprovedForAll(from, _msgSender()) ||
1439             getApproved(tokenId) == _msgSender());
1440 
1441         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1442         if (to == address(0)) revert TransferToZeroAddress();
1443 
1444         _beforeTokenTransfers(from, to, tokenId, 1);
1445 
1446         // Clear approvals from the previous owner
1447         _approve(address(0), tokenId, from);
1448 
1449         // Underflow of the sender's balance is impossible because we check for
1450         // ownership above and the recipient's balance can't realistically overflow.
1451         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1452         unchecked {
1453             _addressData[from].balance -= 1;
1454             _addressData[to].balance += 1;
1455 
1456             TokenOwnership storage currSlot = _ownerships[tokenId];
1457             currSlot.addr = to;
1458             currSlot.startTimestamp = uint64(block.timestamp);
1459 
1460             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1461             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1462             uint256 nextTokenId = tokenId + 1;
1463             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1464             if (nextSlot.addr == address(0)) {
1465                 // This will suffice for checking _exists(nextTokenId),
1466                 // as a burned slot cannot contain the zero address.
1467                 if (nextTokenId != _currentIndex) {
1468                     nextSlot.addr = from;
1469                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1470                 }
1471             }
1472         }
1473 
1474         emit Transfer(from, to, tokenId);
1475         _afterTokenTransfers(from, to, tokenId, 1);
1476     }
1477 
1478     /**
1479      * @dev Equivalent to `_burn(tokenId, false)`.
1480      */
1481     function _burn(uint256 tokenId) internal virtual {
1482         _burn(tokenId, false);
1483     }
1484 
1485     /**
1486      * @dev Destroys `tokenId`.
1487      * The approval is cleared when the token is burned.
1488      *
1489      * Requirements:
1490      *
1491      * - `tokenId` must exist.
1492      *
1493      * Emits a {Transfer} event.
1494      */
1495     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1496         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1497 
1498         address from = prevOwnership.addr;
1499 
1500         if (approvalCheck) {
1501             bool isApprovedOrOwner = (_msgSender() == from ||
1502                 isApprovedForAll(from, _msgSender()) ||
1503                 getApproved(tokenId) == _msgSender());
1504 
1505             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1506         }
1507 
1508         _beforeTokenTransfers(from, address(0), tokenId, 1);
1509 
1510         // Clear approvals from the previous owner
1511         _approve(address(0), tokenId, from);
1512 
1513         // Underflow of the sender's balance is impossible because we check for
1514         // ownership above and the recipient's balance can't realistically overflow.
1515         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1516         unchecked {
1517             AddressData storage addressData = _addressData[from];
1518             addressData.balance -= 1;
1519             addressData.numberBurned += 1;
1520 
1521             // Keep track of who burned the token, and the timestamp of burning.
1522             TokenOwnership storage currSlot = _ownerships[tokenId];
1523             currSlot.addr = from;
1524             currSlot.startTimestamp = uint64(block.timestamp);
1525             currSlot.burned = true;
1526 
1527             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1528             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1529             uint256 nextTokenId = tokenId + 1;
1530             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1531             if (nextSlot.addr == address(0)) {
1532                 // This will suffice for checking _exists(nextTokenId),
1533                 // as a burned slot cannot contain the zero address.
1534                 if (nextTokenId != _currentIndex) {
1535                     nextSlot.addr = from;
1536                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1537                 }
1538             }
1539         }
1540 
1541         emit Transfer(from, address(0), tokenId);
1542         _afterTokenTransfers(from, address(0), tokenId, 1);
1543 
1544         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1545         unchecked {
1546             _burnCounter++;
1547         }
1548     }
1549 
1550     /**
1551      * @dev Approve `to` to operate on `tokenId`
1552      *
1553      * Emits a {Approval} event.
1554      */
1555     function _approve(
1556         address to,
1557         uint256 tokenId,
1558         address owner
1559     ) private {
1560         _tokenApprovals[tokenId] = to;
1561         emit Approval(owner, to, tokenId);
1562     }
1563 
1564     /**
1565      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1566      *
1567      * @param from address representing the previous owner of the given token ID
1568      * @param to target address that will receive the tokens
1569      * @param tokenId uint256 ID of the token to be transferred
1570      * @param _data bytes optional data to send along with the call
1571      * @return bool whether the call correctly returned the expected magic value
1572      */
1573     function _checkContractOnERC721Received(
1574         address from,
1575         address to,
1576         uint256 tokenId,
1577         bytes memory _data
1578     ) private returns (bool) {
1579         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1580             return retval == IERC721Receiver(to).onERC721Received.selector;
1581         } catch (bytes memory reason) {
1582             if (reason.length == 0) {
1583                 revert TransferToNonERC721ReceiverImplementer();
1584             } else {
1585                 assembly {
1586                     revert(add(32, reason), mload(reason))
1587                 }
1588             }
1589         }
1590     }
1591 
1592     /**
1593      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1594      * And also called before burning one token.
1595      *
1596      * startTokenId - the first token id to be transferred
1597      * quantity - the amount to be transferred
1598      *
1599      * Calling conditions:
1600      *
1601      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1602      * transferred to `to`.
1603      * - When `from` is zero, `tokenId` will be minted for `to`.
1604      * - When `to` is zero, `tokenId` will be burned by `from`.
1605      * - `from` and `to` are never both zero.
1606      */
1607     function _beforeTokenTransfers(
1608         address from,
1609         address to,
1610         uint256 startTokenId,
1611         uint256 quantity
1612     ) internal virtual {}
1613 
1614     /**
1615      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1616      * minting.
1617      * And also called after one token has been burned.
1618      *
1619      * startTokenId - the first token id to be transferred
1620      * quantity - the amount to be transferred
1621      *
1622      * Calling conditions:
1623      *
1624      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1625      * transferred to `to`.
1626      * - When `from` is zero, `tokenId` has been minted for `to`.
1627      * - When `to` is zero, `tokenId` has been burned by `from`.
1628      * - `from` and `to` are never both zero.
1629      */
1630     function _afterTokenTransfers(
1631         address from,
1632         address to,
1633         uint256 startTokenId,
1634         uint256 quantity
1635     ) internal virtual {}
1636 }
1637 
1638 
1639 
1640 
1641 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1642 
1643 pragma solidity ^0.8.0;
1644 
1645 
1646 /**
1647  * @dev Contract module which provides a basic access control mechanism, where
1648  * there is an account (an owner) that can be granted exclusive access to
1649  * specific functions.
1650  *
1651  * By default, the owner account will be the one that deploys the contract. This
1652  * can later be changed with {transferOwnership}.
1653  *
1654  * This module is used through inheritance. It will make available the modifier
1655  * `onlyOperator`, which can be applied to your functions to restrict their use to
1656  * the owner.
1657  */
1658 abstract contract Ownable is Context {
1659     address private _owner;
1660 
1661     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1662 
1663     /**
1664      * @dev Initializes the contract setting the deployer as the initial owner.
1665      */
1666     constructor() {
1667         _transferOwnership(_msgSender());
1668     }
1669 
1670     /**
1671      * @dev Throws if called by any account other than the owner.
1672      */
1673     modifier onlyOwner() {
1674         _checkOwner();
1675         _;
1676     }
1677 
1678     /**
1679      * @dev Returns the address of the current owner.
1680      */
1681     function owner() public view virtual returns (address) {
1682         return _owner;
1683     }
1684 
1685     /**
1686      * @dev Throws if the sender is not the owner.
1687      */
1688     function _checkOwner() internal view virtual {
1689         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1690     }
1691 
1692     /**
1693      * @dev Leaves the contract without owner. It will not be possible to call
1694      * `onlyOwner` functions anymore. Can only be called by the current owner.
1695      *
1696      * NOTE: Renouncing ownership will leave the contract without an owner,
1697      * thereby removing any functionality that is only available to the owner.
1698      */
1699     function renounceOwnership() public virtual onlyOwner {
1700         _transferOwnership(address(0));
1701     }
1702 
1703     /**
1704      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1705      * Can only be called by the current owner.
1706      */
1707     function transferOwnership(address newOwner) public virtual onlyOwner {
1708         require(newOwner != address(0), "Ownable: new owner is the zero address");
1709         _transferOwnership(newOwner);
1710     }
1711 
1712     /**
1713      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1714      * Internal function without access restriction.
1715      */
1716     function _transferOwnership(address newOwner) internal virtual {
1717         address oldOwner = _owner;
1718         _owner = newOwner;
1719         emit OwnershipTransferred(oldOwner, newOwner);
1720     }
1721 }
1722 
1723 
1724 pragma solidity ^0.8.9;
1725 
1726 abstract contract Operable is Context {
1727     mapping(address => bool) _operators;
1728 
1729     modifier onlyOperator() {
1730         _checkOperatorRole(_msgSender());
1731         _;
1732     }
1733 
1734     function isOperator(address _operator) public view returns (bool) {
1735         return _operators[_operator];
1736     }
1737 
1738     function _grantOperatorRole(address _candidate) internal {
1739         require(
1740             !_operators[_candidate],
1741             string(
1742                 abi.encodePacked(
1743                     "account ",
1744                     Strings.toHexString(uint160(_msgSender()), 20),
1745                     " is already has an operator role"
1746                 )
1747             )
1748         );
1749         _operators[_candidate] = true;
1750     }
1751 
1752     function _revokeOperatorRole(address _candidate) internal {
1753         _checkOperatorRole(_candidate);
1754         delete _operators[_candidate];
1755     }
1756 
1757     function _checkOperatorRole(address _operator) internal view {
1758         require(
1759             _operators[_operator],
1760             string(
1761                 abi.encodePacked(
1762                     "account ",
1763                     Strings.toHexString(uint160(_msgSender()), 20),
1764                     " is not an operator"
1765                 )
1766             )
1767         );
1768     }
1769 }
1770 
1771 pragma solidity ^0.8.13;
1772 
1773 interface IOperatorFilterRegistry {
1774     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1775     function register(address registrant) external;
1776     function registerAndSubscribe(address registrant, address subscription) external;
1777     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1778     function unregister(address addr) external;
1779     function updateOperator(address registrant, address operator, bool filtered) external;
1780     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1781     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1782     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1783     function subscribe(address registrant, address registrantToSubscribe) external;
1784     function unsubscribe(address registrant, bool copyExistingEntries) external;
1785     function subscriptionOf(address addr) external returns (address registrant);
1786     function subscribers(address registrant) external returns (address[] memory);
1787     function subscriberAt(address registrant, uint256 index) external returns (address);
1788     function copyEntriesOf(address registrant, address registrantToCopy) external;
1789     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1790     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1791     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1792     function filteredOperators(address addr) external returns (address[] memory);
1793     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1794     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1795     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1796     function isRegistered(address addr) external returns (bool);
1797     function codeHashOf(address addr) external returns (bytes32);
1798 }
1799 
1800 pragma solidity ^0.8.13;
1801 
1802 
1803 /**
1804  * @title  OperatorFilterer
1805  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
1806  *         registrant's entries in the OperatorFilterRegistry.
1807  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
1808  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
1809  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
1810  */
1811 abstract contract OperatorFilterer {
1812     error OperatorNotAllowed(address operator);
1813     bool public operatorFilteringEnabled = true;
1814 
1815     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
1816         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1817 
1818     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1819         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1820         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1821         // order for the modifier to filter addresses.
1822         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1823             if (subscribe) {
1824                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1825             } else {
1826                 if (subscriptionOrRegistrantToCopy != address(0)) {
1827                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1828                 } else {
1829                     OPERATOR_FILTER_REGISTRY.register(address(this));
1830                 }
1831             }
1832         }
1833     }
1834 
1835     modifier onlyAllowedOperator(address from) virtual {
1836         // Check registry code length to facilitate testing in environments without a deployed registry.
1837         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0 && operatorFilteringEnabled) {
1838             // Allow spending tokens from addresses with balance
1839             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1840             // from an EOA.
1841             if (from == msg.sender) {
1842                 _;
1843                 return;
1844             }
1845             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), msg.sender)) {
1846                 revert OperatorNotAllowed(msg.sender);
1847             }
1848         }
1849         _;
1850     }
1851 
1852     modifier onlyAllowedOperatorApproval(address operator) virtual {
1853         // Check registry code length to facilitate testing in environments without a deployed registry.
1854         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0 && operatorFilteringEnabled) {
1855             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
1856                 revert OperatorNotAllowed(operator);
1857             }
1858         }
1859         _;
1860     }
1861 }
1862 
1863 
1864 pragma solidity ^0.8.13;
1865 /**
1866  * @title  DefaultOperatorFilterer
1867  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
1868  */
1869 abstract contract DefaultOperatorFilterer is OperatorFilterer {
1870     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1871 
1872     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1873 }
1874 
1875 
1876 
1877 pragma solidity ^0.8.7;
1878 /*
1879 ╭━╮╱╭┳━━━┳━━━━┳━━━┳━━━┳╮╱╱╭━━━┳━━━╮╭━━━┳━━━┳━━━┳━━━╮
1880 ┃┃╰╮┃┃╭━━┫╭╮╭╮┃╭━╮┃╭━╮┃┃╱╱┃╭━╮┃╭━╮┃┃╭━╮┃╭━╮┃╭━╮┃╭━╮┃
1881 ┃╭╮╰╯┃╰━━╋╯┃┃╰┫┃╱╰┫┃╱┃┃┃╱╱┃┃╱┃┃╰━╯┃┃╰━╯┃┃╱┃┃╰━━┫╰━━╮
1882 ┃┃╰╮┃┃╭━━╯╱┃┃╱┃┃╱╭┫┃╱┃┃┃╱╭┫┃╱┃┃╭╮╭╯┃╭━━┫╰━╯┣━━╮┣━━╮┃
1883 ┃┃╱┃┃┃┃╱╱╱╱┃┃╱┃╰━╯┃╰━╯┃╰━╯┃╰━╯┃┃┃╰╮┃┃╱╱┃╭━╮┃╰━╯┃╰━╯┃
1884 ╰╯╱╰━┻╯╱╱╱╱╰╯╱╰━━━┻━━━┻━━━┻━━━┻╯╰━╯╰╯╱╱╰╯╱╰┻━━━┻━━━╯
1885 */
1886 contract NFTCOLORPASS is Ownable, ERC721A, ReentrancyGuard, MerkleProof, ERC2981, DefaultOperatorFilterer, Operable {
1887   //Project Settings
1888   uint256 public psMintPrice = 0.2 ether;
1889   uint256 public maxSupply = 500;
1890   address payable internal _withdrawWallet;
1891   uint256 public maxMintsPerPS = 1;
1892   uint256 public maxMintsPerPSMint = 1;
1893 
1894   //URI
1895   string internal hiddenURI;
1896   string internal _baseTokenURI;
1897   string public _baseExtension = ".json";
1898 
1899   //flags
1900   bool public isWlSaleEnabled;
1901   bool public isPublicSaleEnabled;
1902   bool public revealed = false;
1903   address public deployer;
1904 
1905   //mint records.
1906   mapping(address => uint256) internal _wlMinted;
1907   mapping(address => uint256) internal _psMinted;
1908   
1909   constructor (
1910     address _royaltyReceiver,
1911     uint96 _royaltyFraction
1912   ) ERC721A ("NFTCOLOR PASS","NCP") {
1913     deployer = msg.sender;
1914     _withdrawWallet = payable(deployer);
1915     _grantOperatorRole(msg.sender);
1916     _setDefaultRoyalty(_royaltyReceiver,_royaltyFraction);
1917   }
1918   //start from 1.adjust.
1919   function _startTokenId() internal view virtual override returns (uint256) {
1920         return 1;
1921   }
1922   //set Default Royalty._feeNumerator 500 = 5% Royalty
1923   function setDefaultRoyalty(address _receiver, uint96 _feeNumerator) external virtual onlyOperator {
1924       _setDefaultRoyalty(_receiver, _feeNumerator);
1925   }
1926   //for ERC2981
1927   function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721A, ERC2981) returns (bool) {
1928     return super.supportsInterface(interfaceId);
1929   }
1930   //for ERC2981 Opensea
1931   function contractURI() external view virtual returns (string memory) {
1932         return _formatContractURI();
1933   }
1934   //make contractURI
1935   function _formatContractURI() internal view returns (string memory) {
1936     (address receiver, uint256 royaltyFraction) = royaltyInfo(0,_feeDenominator());//tokenid=0
1937     return string(
1938       abi.encodePacked(
1939         "data:application/json;base64,",
1940         Base64.encode(
1941           bytes(
1942             abi.encodePacked(
1943                 '{"seller_fee_basis_points":', Strings.toString(royaltyFraction),
1944                 ', "fee_recipient":"', Strings.toHexString(uint256(uint160(receiver)), 20), '"}'
1945             )
1946           )
1947         )
1948       )
1949     );
1950   }
1951 
1952   //set owner's wallet.withdraw to this wallet.only owner.
1953   function setWithdrawWallet(address _owner) external virtual onlyOperator {
1954     _withdrawWallet = payable(_owner);
1955   }
1956 
1957   function setDeployer(address _deployer) external virtual onlyOperator {
1958     deployer = _deployer;
1959   }
1960 
1961   //set maxSupply.only owner.
1962   function setMaxSupply(uint256 _maxSupply) external virtual onlyOperator {
1963     require(totalSupply() <= _maxSupply, "Lower than _currentIndex.");
1964     maxSupply = _maxSupply;
1965   }
1966 
1967   function setPsPrice(uint256 newPrice) external virtual onlyOperator {
1968     psMintPrice = newPrice;
1969   }
1970 
1971   //set reveal.only owner.
1972   function setReveal(bool newRevealStatus) external virtual onlyOperator {
1973     revealed = newRevealStatus;
1974   }
1975   //return _isRevealed()
1976   function _isRevealed() internal view virtual returns (bool){
1977     return revealed;
1978   }
1979 
1980   // GET MINTED COUNT.
1981   function wlMinted(address _address) external view virtual returns (uint256){
1982     return _wlMinted[_address];
1983   }
1984   function psMinted(address _address) external view virtual returns (uint256){
1985     return _psMinted[_address];
1986   }
1987 
1988   function setPsMaxMints(uint256 _max) external virtual onlyOperator {
1989     maxMintsPerPS = _max;
1990   }
1991 
1992   function setMaxMintsPerPSMint(uint256 _max) external virtual onlyOperator {
1993     maxMintsPerPSMint = _max;
1994   }
1995 
1996   // SET SALES ENABLE.
1997   function setWhitelistSaleEnable(bool bool_) external virtual onlyOperator {
1998     isWlSaleEnabled = bool_;
1999   }
2000   function setPublicSaleEnable(bool bool_) external virtual onlyOperator {
2001     isPublicSaleEnabled = bool_;
2002   }
2003 
2004   // SET MERKLE ROOT.
2005   function setWlMerkleRoot(bytes32 merkleRoot_) external virtual onlyOperator {
2006     _setwlMerkleRoot(merkleRoot_);
2007   }
2008 
2009   //set HiddenBaseURI.only owner.
2010   function setHiddenURI(string memory uri_) external virtual onlyOperator {
2011     hiddenURI = uri_;
2012   }
2013 
2014   //return _currentIndex
2015   function getCurrentIndex() external view virtual returns (uint256){
2016     return _currentIndex;
2017   }
2018 
2019   //set BaseURI at after reveal. only owner.
2020   function setBaseURI(string memory uri_) external virtual onlyOperator {
2021     _baseTokenURI = uri_;
2022   }
2023 
2024 
2025   function setBaseExtension(string memory _newBaseExtension) external onlyOperator
2026   {
2027     _baseExtension = _newBaseExtension;
2028   }
2029 
2030   //retuen BaseURI.internal.
2031   function _currentBaseURI() internal view returns (string memory){
2032     return _baseTokenURI;
2033   }
2034 
2035 
2036   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
2037     require(_exists(_tokenId), "URI query for nonexistent token");
2038     if(_isRevealed()){
2039         return string(abi.encodePacked(_currentBaseURI(), Strings.toString(_tokenId), _baseExtension));
2040     }
2041     return hiddenURI;
2042   }
2043 
2044   //owner mint.transfer to _address.only owner.
2045   function ownerMint(uint256 _amount, address _address) external virtual onlyOperator { 
2046     require((_amount + totalSupply()) <= (maxSupply), "No more NFTs");
2047     _safeMint(_address, _amount);
2048   }
2049 
2050 
2051   //WL mint.
2052   function whitelistMint(uint256 _amount, uint256 wlcount, bytes32[] memory proof_) external payable virtual nonReentrant {
2053     require(isWlSaleEnabled, "whitelistMint is Paused");
2054     require(isWhitelisted(msg.sender, wlcount, proof_), "You are not whitelisted!");
2055     require(wlcount > 0, "You have no WL!");
2056     require(wlcount >= _amount, "whitelistMint: Over max mints per wallet");
2057     require(wlcount >= _wlMinted[msg.sender] + _amount, "You have no whitelistMint left");
2058     require((_amount + totalSupply()) <= (maxSupply), "No more NFTs");
2059     _wlMinted[msg.sender] += _amount;
2060     _safeMint(msg.sender, _amount);
2061   }
2062   
2063   //Public mint.
2064   function publicMint(uint256 _amount) external payable virtual nonReentrant {
2065     require(isPublicSaleEnabled, "publicMint is Paused");
2066     require(maxMintsPerPSMint >= _amount, "publicMint: Over max mints per one time.");
2067     require(maxMintsPerPS >= _amount, "publicMint: Over max mints per wallet");
2068     require(maxMintsPerPS >= _psMinted[msg.sender] + _amount, "You have no publicMint left");
2069     require(msg.value == psMintPrice * _amount, "ETH value is not correct");
2070     require((_amount + totalSupply()) <= (maxSupply), "No more NFTs");
2071     _psMinted[msg.sender] += _amount;
2072     _safeMint(msg.sender, _amount);
2073   }
2074 
2075   //burn
2076   function burn(uint256 tokenId) external virtual {
2077     _burn(tokenId, true);
2078   }
2079 
2080   //widraw ETH from this contract.only owner. 
2081   function withdraw() external payable virtual onlyOperator nonReentrant{
2082     // This will payout the owner 100% of the contract balance.
2083     // Do not remove this otherwise you will not be able to withdraw the funds.
2084     // =============================================================================
2085     bool os;
2086     if(_withdrawWallet != address(0)){//if _withdrawWallet has.
2087       (os, ) = payable(_withdrawWallet).call{value: address(this).balance}("");
2088     }else{
2089       (os, ) = payable(owner()).call{value: address(this).balance}("");
2090     }
2091     require(os);
2092     // =============================================================================
2093   }
2094 
2095 
2096   //return wallet owned tokenids.
2097   function walletOfOwner(address _address) external view virtual returns (uint256[] memory) {
2098     uint256 ownerTokenCount = balanceOf(_address);
2099     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
2100     //search from all tonkenid. so spend high gas values.attention.
2101     uint256 tokenindex = 0;
2102     for (uint256 i = _startTokenId(); i < _currentIndex; i++) {
2103       if(_address == this.tryOwnerOf(i)) tokenIds[tokenindex++] = i;
2104     }
2105     return tokenIds;
2106   }
2107 
2108   //try catch vaersion ownerOf. support burned tokenid.
2109   function tryOwnerOf(uint256 tokenId) external view  virtual returns (address) {
2110     try this.ownerOf(tokenId) returns (address _address) {
2111       return(_address);
2112     } catch {
2113         return (address(0));//return 0x0 if error.
2114     }
2115   }
2116 
2117     /**
2118      * @notice Set the state of the OpenSea operator filter
2119      * @param value Flag indicating if the operator filter should be applied to transfers and approvals
2120      */
2121     function setOperatorFilteringEnabled(bool value) external onlyOperator {
2122         operatorFilteringEnabled = value;
2123     }
2124 
2125     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
2126         super.setApprovalForAll(operator, approved);
2127     }
2128 
2129     function approve(address operator, uint256 tokenId) public override onlyAllowedOperatorApproval(operator) {
2130         super.approve(operator, tokenId);
2131     }
2132 
2133     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
2134         super.transferFrom(from, to, tokenId);
2135     }
2136 
2137     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
2138         super.safeTransferFrom(from, to, tokenId);
2139     }
2140 
2141     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
2142         public
2143         override
2144         onlyAllowedOperator(from)
2145     {
2146         super.safeTransferFrom(from, to, tokenId, data);
2147     }
2148 
2149     /**
2150         @dev Operable Role
2151      */
2152     function grantOperatorRole(address _candidate) external onlyOwner {
2153         _grantOperatorRole(_candidate);
2154     }
2155 
2156     function revokeOperatorRole(address _candidate) external onlyOwner {
2157         _revokeOperatorRole(_candidate);
2158     }
2159 }
2160 //CODE.BY.FRICKLIK