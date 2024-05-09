1 //SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.1;
3 /**
4  * @dev Collection of functions related to the address type
5  */
6 library Address {
7     /**
8      * @dev Returns true if `account` is a contract.
9      *
10      * [IMPORTANT]
11      * ====
12      * It is unsafe to assume that an address for which this function returns
13      * false is an externally-owned account (EOA) and not a contract.
14      *
15      * Among others, `isContract` will return false for the following
16      * types of addresses:
17      *
18      *  - an externally-owned account
19      *  - a contract in construction
20      *  - an address where a contract will be created
21      *  - an address where a contract lived, but was destroyed
22      * ====
23      *
24      * [IMPORTANT]
25      * ====
26      * You shouldn't rely on `isContract` to protect against flash loan attacks!
27      *
28      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
29      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
30      * constructor.
31      * ====
32      */
33     function isContract(address account) internal view returns (bool) {
34         // This method relies on extcodesize/address.code.length, which returns 0
35         // for contracts in construction, since the code is only stored at the end
36         // of the constructor execution.
37         return account.code.length > 0;
38     }
39     /**
40      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
41      * `recipient`, forwarding all available gas and reverting on errors.
42      *
43      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
44      * of certain opcodes, possibly making contracts go over the 2300 gas limit
45      * imposed by `transfer`, making them unable to receive funds via
46      * `transfer`. {sendValue} removes this limitation.
47      *
48      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
49      *
50      * IMPORTANT: because control is transferred to `recipient`, care must be
51      * taken to not create reentrancy vulnerabilities. Consider using
52      * {ReentrancyGuard} or the
53      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
54      */
55     function sendValue(address payable recipient, uint256 amount) internal {
56         require(
57             address(this).balance >= amount,
58             "Address: insufficient balance"
59         );
60         (bool success, ) = recipient.call{value: amount}("");
61         require(
62             success,
63             "Address: unable to send value, recipient may have reverted"
64         );
65     }
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
84     function functionCall(address target, bytes memory data)
85         internal
86         returns (bytes memory)
87     {
88         return functionCall(target, data, "Address: low-level call failed");
89     }
90     /**
91      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
92      * `errorMessage` as a fallback revert reason when `target` reverts.
93      *
94      * _Available since v3.1._
95      */
96     function functionCall(
97         address target,
98         bytes memory data,
99         string memory errorMessage
100     ) internal returns (bytes memory) {
101         return functionCallWithValue(target, data, 0, errorMessage);
102     }
103     /**
104      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
105      * but also transferring `value` wei to `target`.
106      *
107      * Requirements:
108      *
109      * - the calling contract must have an ETH balance of at least `value`.
110      * - the called Solidity function must be `payable`.
111      *
112      * _Available since v3.1._
113      */
114     function functionCallWithValue(
115         address target,
116         bytes memory data,
117         uint256 value
118     ) internal returns (bytes memory) {
119         return
120             functionCallWithValue(
121                 target,
122                 data,
123                 value,
124                 "Address: low-level call with value failed"
125             );
126     }
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
139         require(
140             address(this).balance >= value,
141             "Address: insufficient balance for call"
142         );
143         require(isContract(target), "Address: call to non-contract");
144         (bool success, bytes memory returndata) = target.call{value: value}(
145             data
146         );
147         return verifyCallResult(success, returndata, errorMessage);
148     }
149     /**
150      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
151      * but performing a static call.
152      *
153      * _Available since v3.3._
154      */
155     function functionStaticCall(address target, bytes memory data)
156         internal
157         view
158         returns (bytes memory)
159     {
160         return
161             functionStaticCall(
162                 target,
163                 data,
164                 "Address: low-level static call failed"
165             );
166     }
167     /**
168      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
169      * but performing a static call.
170      *
171      * _Available since v3.3._
172      */
173     function functionStaticCall(
174         address target,
175         bytes memory data,
176         string memory errorMessage
177     ) internal view returns (bytes memory) {
178         require(isContract(target), "Address: static call to non-contract");
179         (bool success, bytes memory returndata) = target.staticcall(data);
180         return verifyCallResult(success, returndata, errorMessage);
181     }
182     /**
183      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
184      * but performing a delegate call.
185      *
186      * _Available since v3.4._
187      */
188     function functionDelegateCall(address target, bytes memory data)
189         internal
190         returns (bytes memory)
191     {
192         return
193             functionDelegateCall(
194                 target,
195                 data,
196                 "Address: low-level delegate call failed"
197             );
198     }
199     /**
200      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
201      * but performing a delegate call.
202      *
203      * _Available since v3.4._
204      */
205     function functionDelegateCall(
206         address target,
207         bytes memory data,
208         string memory errorMessage
209     ) internal returns (bytes memory) {
210         require(isContract(target), "Address: delegate call to non-contract");
211         (bool success, bytes memory returndata) = target.delegatecall(data);
212         return verifyCallResult(success, returndata, errorMessage);
213     }
214     /**
215      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
216      * revert reason using the provided one.
217      *
218      * _Available since v4.3._
219      */
220     function verifyCallResult(
221         bool success,
222         bytes memory returndata,
223         string memory errorMessage
224     ) internal pure returns (bytes memory) {
225         if (success) {
226             return returndata;
227         } else {
228             // Look for revert reason and bubble it up if present
229             if (returndata.length > 0) {
230                 // The easiest way to bubble the revert reason is using memory via assembly
231                 /// @solidity memory-safe-assembly
232                 assembly {
233                     let returndata_size := mload(returndata)
234                     revert(add(32, returndata), returndata_size)
235                 }
236             } else {
237                 revert(errorMessage);
238             }
239         }
240     }
241 }
242 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
243 pragma solidity ^0.8.0;
244 /**
245  * @title ERC721 token receiver interface
246  * @dev Interface for any contract that wants to support safeTransfers
247  * from ERC721 asset contracts.
248  */
249 interface IERC721Receiver {
250     /**
251      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
252      * by `operator` from `from`, this function is called.
253      *
254      * It must return its Solidity selector to confirm the token transfer.
255      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
256      *
257      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
258      */
259     function onERC721Received(
260         address operator,
261         address from,
262         uint256 tokenId,
263         bytes calldata data
264     ) external returns (bytes4);
265 }
266 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
267 pragma solidity ^0.8.0;
268 /**
269  * @dev String operations.
270  */
271 library Strings {
272     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
273     uint8 private constant _ADDRESS_LENGTH = 20;
274     /**
275      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
276      */
277     function toString(uint256 value) internal pure returns (string memory) {
278         // Inspired by OraclizeAPI's implementation - MIT licence
279         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
280         if (value == 0) {
281             return "0";
282         }
283         uint256 temp = value;
284         uint256 digits;
285         while (temp != 0) {
286             digits++;
287             temp /= 10;
288         }
289         bytes memory buffer = new bytes(digits);
290         while (value != 0) {
291             digits -= 1;
292             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
293             value /= 10;
294         }
295         return string(buffer);
296     }
297     /**
298      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
299      */
300     function toHexString(uint256 value) internal pure returns (string memory) {
301         if (value == 0) {
302             return "0x00";
303         }
304         uint256 temp = value;
305         uint256 length = 0;
306         while (temp != 0) {
307             length++;
308             temp >>= 8;
309         }
310         return toHexString(value, length);
311     }
312     /**
313      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
314      */
315     function toHexString(uint256 value, uint256 length)
316         internal
317         pure
318         returns (string memory)
319     {
320         bytes memory buffer = new bytes(2 * length + 2);
321         buffer[0] = "0";
322         buffer[1] = "x";
323         for (uint256 i = 2 * length + 1; i > 1; --i) {
324             buffer[i] = _HEX_SYMBOLS[value & 0xf];
325             value >>= 4;
326         }
327         require(value == 0, "Strings: hex length insufficient");
328         return string(buffer);
329     }
330     /**
331      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
332      */
333     function toHexString(address addr) internal pure returns (string memory) {
334         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
335     }
336 }
337 pragma solidity ^0.8.7;
338 abstract contract MerkleProof {
339     bytes32 internal _wlMerkleRoot;
340     bytes32 internal _wlPMerkleRoot;
341     function _setWlMerkleRoot(bytes32 merkleRoot_) internal virtual {
342         _wlMerkleRoot = merkleRoot_;
343     }
344     function isWhitelisted(
345         address address_,
346         uint256 wlCount,
347         bytes32[] memory proof_
348     ) public view returns (bool) {
349         bytes32 _leaf = keccak256(abi.encodePacked(address_, wlCount));
350         for (uint256 i = 0; i < proof_.length; i++) {
351             _leaf = _leaf < proof_[i]
352                 ? keccak256(abi.encodePacked(_leaf, proof_[i]))
353                 : keccak256(abi.encodePacked(proof_[i], _leaf));
354         }
355         return _leaf == _wlMerkleRoot;
356     }
357     // WL
358     function _setPWlMerkleRoot(bytes32 merkleRoot_) internal virtual {
359         _wlPMerkleRoot = merkleRoot_;
360     }
361     function isPWhitelisted(address address_, bytes32[] memory proof_)
362         public
363         view
364         returns (bool)
365     {
366         bytes32 _leaf = keccak256(abi.encodePacked(address_));
367         for (uint256 i = 0; i < proof_.length; i++) {
368             _leaf = _leaf < proof_[i]
369                 ? keccak256(abi.encodePacked(_leaf, proof_[i]))
370                 : keccak256(abi.encodePacked(proof_[i], _leaf));
371         }
372         return _leaf == _wlPMerkleRoot;
373     }
374 }
375 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Base64.sol)
376 pragma solidity ^0.8.0;
377 /**
378  * @dev Provides a set of functions to operate with Base64 strings.
379  *
380  * _Available since v4.5._
381  */
382 library Base64 {
383     /**
384      * @dev Base64 Encoding/Decoding Table
385      */
386     string internal constant _TABLE =
387         "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
388     /**
389      * @dev Converts a `bytes` to its Bytes64 `string` representation.
390      */
391     function encode(bytes memory data) internal pure returns (string memory) {
392         /**
393          * Inspired by Brecht Devos (Brechtpd) implementation - MIT licence
394          * https://github.com/Brechtpd/base64/blob/e78d9fd951e7b0977ddca77d92dc85183770daf4/base64.sol
395          */
396         if (data.length == 0) return "";
397         // Loads the table into memory
398         string memory table = _TABLE;
399         // Encoding takes 3 bytes chunks of binary data from `bytes` data parameter
400         // and split into 4 numbers of 6 bits.
401         // The final Base64 length should be `bytes` data length multiplied by 4/3 rounded up
402         // - `data.length + 2`  -> Round up
403         // - `/ 3`              -> Number of 3-bytes chunks
404         // - `4 *`              -> 4 characters for each chunk
405         string memory result = new string(4 * ((data.length + 2) / 3));
406         /// @solidity memory-safe-assembly
407         assembly {
408             // Prepare the lookup table (skip the first "length" byte)
409             let tablePtr := add(table, 1)
410             // Prepare result pointer, jump over length
411             let resultPtr := add(result, 32)
412             // Run over the input, 3 bytes at a time
413             for {
414                 let dataPtr := data
415                 let endPtr := add(data, mload(data))
416             } lt(dataPtr, endPtr) {
417             } {
418                 // Advance 3 bytes
419                 dataPtr := add(dataPtr, 3)
420                 let input := mload(dataPtr)
421                 // To write each character, shift the 3 bytes (18 bits) chunk
422                 // 4 times in blocks of 6 bits for each character (18, 12, 6, 0)
423                 // and apply logical AND with 0x3F which is the number of
424                 // the previous character in the ASCII table prior to the Base64 Table
425                 // The result is then added to the table to get the character to write,
426                 // and finally write it in the result pointer but with a left shift
427                 // of 256 (1 byte) - 8 (1 ASCII char) = 248 bits
428                 mstore8(
429                     resultPtr,
430                     mload(add(tablePtr, and(shr(18, input), 0x3F)))
431                 )
432                 resultPtr := add(resultPtr, 1) // Advance
433                 mstore8(
434                     resultPtr,
435                     mload(add(tablePtr, and(shr(12, input), 0x3F)))
436                 )
437                 resultPtr := add(resultPtr, 1) // Advance
438                 mstore8(
439                     resultPtr,
440                     mload(add(tablePtr, and(shr(6, input), 0x3F)))
441                 )
442                 resultPtr := add(resultPtr, 1) // Advance
443                 mstore8(resultPtr, mload(add(tablePtr, and(input, 0x3F))))
444                 resultPtr := add(resultPtr, 1) // Advance
445             }
446             // When data `bytes` is not exactly 3 bytes long
447             // it is padded with `=` characters at the end
448             switch mod(mload(data), 3)
449             case 1 {
450                 mstore8(sub(resultPtr, 1), 0x3d)
451                 mstore8(sub(resultPtr, 2), 0x3d)
452             }
453             case 2 {
454                 mstore8(sub(resultPtr, 1), 0x3d)
455             }
456         }
457         return result;
458     }
459 }
460 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
461 pragma solidity ^0.8.0;
462 /**
463  * @dev Interface of the ERC165 standard, as defined in the
464  * https://eips.ethereum.org/EIPS/eip-165[EIP].
465  *
466  * Implementers can declare support of contract interfaces, which can then be
467  * queried by others ({ERC165Checker}).
468  *
469  * For an implementation, see {ERC165}.
470  */
471 interface IERC165 {
472     /**
473      * @dev Returns true if this contract implements the interface defined by
474      * `interfaceId`. See the corresponding
475      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
476      * to learn more about how these ids are created.
477      *
478      * This function call must use less than 30 000 gas.
479      */
480     function supportsInterface(bytes4 interfaceId) external view returns (bool);
481 }
482 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
483 pragma solidity ^0.8.0;
484 /**
485  * @dev Required interface of an ERC721 compliant contract.
486  */
487 interface IERC721 is IERC165 {
488     /**
489      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
490      */
491     event Transfer(
492         address indexed from,
493         address indexed to,
494         uint256 indexed tokenId
495     );
496     /**
497      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
498      */
499     event Approval(
500         address indexed owner,
501         address indexed approved,
502         uint256 indexed tokenId
503     );
504     /**
505      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
506      */
507     event ApprovalForAll(
508         address indexed owner,
509         address indexed operator,
510         bool approved
511     );
512     /**
513      * @dev Returns the number of tokens in ``owner``'s account.
514      */
515     function balanceOf(address owner) external view returns (uint256 balance);
516     /**
517      * @dev Returns the owner of the `tokenId` token.
518      *
519      * Requirements:
520      *
521      * - `tokenId` must exist.
522      */
523     function ownerOf(uint256 tokenId) external view returns (address owner);
524     /**
525      * @dev Safely transfers `tokenId` token from `from` to `to`.
526      *
527      * Requirements:
528      *
529      * - `from` cannot be the zero address.
530      * - `to` cannot be the zero address.
531      * - `tokenId` token must exist and be owned by `from`.
532      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
533      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
534      *
535      * Emits a {Transfer} event.
536      */
537     function safeTransferFrom(
538         address from,
539         address to,
540         uint256 tokenId,
541         bytes calldata data
542     ) external;
543     /**
544      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
545      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
546      *
547      * Requirements:
548      *
549      * - `from` cannot be the zero address.
550      * - `to` cannot be the zero address.
551      * - `tokenId` token must exist and be owned by `from`.
552      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
553      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
554      *
555      * Emits a {Transfer} event.
556      */
557     function safeTransferFrom(
558         address from,
559         address to,
560         uint256 tokenId
561     ) external;
562     /**
563      * @dev Transfers `tokenId` token from `from` to `to`.
564      *
565      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
566      *
567      * Requirements:
568      *
569      * - `from` cannot be the zero address.
570      * - `to` cannot be the zero address.
571      * - `tokenId` token must be owned by `from`.
572      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
573      *
574      * Emits a {Transfer} event.
575      */
576     function transferFrom(
577         address from,
578         address to,
579         uint256 tokenId
580     ) external;
581     /**
582      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
583      * The approval is cleared when the token is transferred.
584      *
585      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
586      *
587      * Requirements:
588      *
589      * - The caller must own the token or be an approved operator.
590      * - `tokenId` must exist.
591      *
592      * Emits an {Approval} event.
593      */
594     function approve(address to, uint256 tokenId) external;
595     /**
596      * @dev Approve or remove `operator` as an operator for the caller.
597      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
598      *
599      * Requirements:
600      *
601      * - The `operator` cannot be the caller.
602      *
603      * Emits an {ApprovalForAll} event.
604      */
605     function setApprovalForAll(address operator, bool _approved) external;
606     /**
607      * @dev Returns the account approved for `tokenId` token.
608      *
609      * Requirements:
610      *
611      * - `tokenId` must exist.
612      */
613     function getApproved(uint256 tokenId)
614         external
615         view
616         returns (address operator);
617     /**
618      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
619      *
620      * See {setApprovalForAll}
621      */
622     function isApprovedForAll(address owner, address operator)
623         external
624         view
625         returns (bool);
626 }
627 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
628 pragma solidity ^0.8.0;
629 /**
630  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
631  * @dev See https://eips.ethereum.org/EIPS/eip-721
632  */
633 interface IERC721Metadata is IERC721 {
634     /**
635      * @dev Returns the token collection name.
636      */
637     function name() external view returns (string memory);
638     /**
639      * @dev Returns the token collection symbol.
640      */
641     function symbol() external view returns (string memory);
642     /**
643      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
644      */
645     function tokenURI(uint256 tokenId) external view returns (string memory);
646 }
647 // ERC721A Contracts v3.3.0
648 // Creator: Chiru Labs
649 pragma solidity ^0.8.4;
650 /**
651  * @dev Interface of an ERC721A compliant contract.
652  */
653 interface IERC721A is IERC721, IERC721Metadata {
654     /**
655      * The caller must own the token or be an approved operator.
656      */
657     error ApprovalCallerNotOwnerNorApproved();
658     /**
659      * The token does not exist.
660      */
661     error ApprovalQueryForNonexistentToken();
662     /**
663      * The caller cannot approve to their own address.
664      */
665     error ApproveToCaller();
666     /**
667      * The caller cannot approve to the current owner.
668      */
669     error ApprovalToCurrentOwner();
670     /**
671      * Cannot query the balance for the zero address.
672      */
673     error BalanceQueryForZeroAddress();
674     /**
675      * Cannot mint to the zero address.
676      */
677     error MintToZeroAddress();
678     /**
679      * The quantity of tokens minted must be more than zero.
680      */
681     error MintZeroQuantity();
682     /**
683      * The token does not exist.
684      */
685     error OwnerQueryForNonexistentToken();
686     /**
687      * The caller must own the token or be an approved operator.
688      */
689     error TransferCallerNotOwnerNorApproved();
690     /**
691      * The token must be owned by `from`.
692      */
693     error TransferFromIncorrectOwner();
694     /**
695      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
696      */
697     error TransferToNonERC721ReceiverImplementer();
698     /**
699      * Cannot transfer to the zero address.
700      */
701     error TransferToZeroAddress();
702     /**
703      * The token does not exist.
704      */
705     error URIQueryForNonexistentToken();
706     // Compiler will pack this into a single 256bit word.
707     struct TokenOwnership {
708         // The address of the owner.
709         address addr;
710         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
711         uint64 startTimestamp;
712         // Whether the token has been burned.
713         bool burned;
714     }
715     // Compiler will pack this into a single 256bit word.
716     struct AddressData {
717         // Realistically, 2**64-1 is more than enough.
718         uint64 balance;
719         // Keeps track of mint count with minimal overhead for tokenomics.
720         uint64 numberMinted;
721         // Keeps track of burn count with minimal overhead for tokenomics.
722         uint64 numberBurned;
723         // For miscellaneous variable(s) pertaining to the address
724         // (e.g. number of whitelist mint slots used).
725         // If there are multiple variables, please pack them into a uint64.
726         uint64 aux;
727     }
728     /**
729      * @dev Returns the total amount of tokens stored by the contract.
730      *
731      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
732      */
733     function totalSupply() external view returns (uint256);
734 }
735 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
736 pragma solidity ^0.8.0;
737 /**
738  * @dev Implementation of the {IERC165} interface.
739  *
740  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
741  * for the additional interface id that will be supported. For example:
742  *
743  * ```solidity
744  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
745  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
746  * }
747  * ```
748  *
749  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
750  */
751 abstract contract ERC165 is IERC165 {
752     /**
753      * @dev See {IERC165-supportsInterface}.
754      */
755     function supportsInterface(bytes4 interfaceId)
756         public
757         view
758         virtual
759         override
760         returns (bool)
761     {
762         return interfaceId == type(IERC165).interfaceId;
763     }
764 }
765 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
766 pragma solidity ^0.8.0;
767 /**
768  * @dev Interface for the NFT Royalty Standard.
769  *
770  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
771  * support for royalty payments across all NFT marketplaces and ecosystem participants.
772  *
773  * _Available since v4.5._
774  */
775 interface IERC2981 is IERC165 {
776     /**
777      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
778      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
779      */
780     function royaltyInfo(uint256 tokenId, uint256 salePrice)
781         external
782         view
783         returns (address receiver, uint256 royaltyAmount);
784 }
785 // OpenZeppelin Contracts (last updated v4.7.0) (token/common/ERC2981.sol)
786 pragma solidity ^0.8.0;
787 /**
788  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
789  *
790  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
791  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
792  *
793  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
794  * fee is specified in basis points by default.
795  *
796  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
797  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
798  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
799  *
800  * _Available since v4.5._
801  */
802 abstract contract ERC2981 is IERC2981, ERC165 {
803     struct RoyaltyInfo {
804         address receiver;
805         uint96 royaltyFraction;
806     }
807     RoyaltyInfo private _defaultRoyaltyInfo;
808     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
809     /**
810      * @dev See {IERC165-supportsInterface}.
811      */
812     function supportsInterface(bytes4 interfaceId)
813         public
814         view
815         virtual
816         override(IERC165, ERC165)
817         returns (bool)
818     {
819         return
820             interfaceId == type(IERC2981).interfaceId ||
821             super.supportsInterface(interfaceId);
822     }
823     /**
824      * @inheritdoc IERC2981
825      */
826     function royaltyInfo(uint256 _tokenId, uint256 _salePrice)
827         public
828         view
829         virtual
830         override
831         returns (address, uint256)
832     {
833         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
834         if (royalty.receiver == address(0)) {
835             royalty = _defaultRoyaltyInfo;
836         }
837         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) /
838             _feeDenominator();
839         return (royalty.receiver, royaltyAmount);
840     }
841     /**
842      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
843      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
844      * override.
845      */
846     function _feeDenominator() internal pure virtual returns (uint96) {
847         return 10000;
848     }
849     /**
850      * @dev Sets the royalty information that all ids in this contract will default to.
851      *
852      * Requirements:
853      *
854      * - `receiver` cannot be the zero address.
855      * - `feeNumerator` cannot be greater than the fee denominator.
856      */
857     function _setDefaultRoyalty(address receiver, uint96 feeNumerator)
858         internal
859         virtual
860     {
861         require(
862             feeNumerator <= _feeDenominator(),
863             "ERC2981: royalty fee will exceed salePrice"
864         );
865         require(receiver != address(0), "ERC2981: invalid receiver");
866         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
867     }
868     /**
869      * @dev Removes default royalty information.
870      */
871     function _deleteDefaultRoyalty() internal virtual {
872         delete _defaultRoyaltyInfo;
873     }
874     /**
875      * @dev Sets the royalty information for a specific token id, overriding the global default.
876      *
877      * Requirements:
878      *
879      * - `receiver` cannot be the zero address.
880      * - `feeNumerator` cannot be greater than the fee denominator.
881      */
882     function _setTokenRoyalty(
883         uint256 tokenId,
884         address receiver,
885         uint96 feeNumerator
886     ) internal virtual {
887         require(
888             feeNumerator <= _feeDenominator(),
889             "ERC2981: royalty fee will exceed salePrice"
890         );
891         require(receiver != address(0), "ERC2981: Invalid parameters");
892         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
893     }
894     /**
895      * @dev Resets royalty information for the token id back to the global default.
896      */
897     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
898         delete _tokenRoyaltyInfo[tokenId];
899     }
900 }
901 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
902 pragma solidity ^0.8.0;
903 /**
904  * @dev Contract module that helps prevent reentrant calls to a function.
905  *
906  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
907  * available, which can be applied to functions to make sure there are no nested
908  * (reentrant) calls to them.
909  *
910  * Note that because there is a single `nonReentrant` guard, functions marked as
911  * `nonReentrant` may not call one another. This can be worked around by making
912  * those functions `private`, and then adding `external` `nonReentrant` entry
913  * points to them.
914  *
915  * TIP: If you would like to learn more about reentrancy and alternative ways
916  * to protect against it, check out our blog post
917  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
918  */
919 abstract contract ReentrancyGuard {
920     // Booleans are more expensive than uint256 or any type that takes up a full
921     // word because each write operation emits an extra SLOAD to first read the
922     // slot's contents, replace the bits taken up by the boolean, and then write
923     // back. This is the compiler's defense against contract upgrades and
924     // pointer aliasing, and it cannot be disabled.
925     // The values being non-zero value makes deployment a bit more expensive,
926     // but in exchange the refund on every call to nonReentrant will be lower in
927     // amount. Since refunds are capped to a percentage of the total
928     // transaction's gas, it is best to keep them low in cases like this one, to
929     // increase the likelihood of the full refund coming into effect.
930     uint256 private constant _NOT_ENTERED = 1;
931     uint256 private constant _ENTERED = 2;
932     uint256 private _status;
933     constructor() {
934         _status = _NOT_ENTERED;
935     }
936     /**
937      * @dev Prevents a contract from calling itself, directly or indirectly.
938      * Calling a `nonReentrant` function from another `nonReentrant`
939      * function is not supported. It is possible to prevent this from happening
940      * by making the `nonReentrant` function external, and making it call a
941      * `private` function that does the actual work.
942      */
943     modifier nonReentrant() {
944         // On the first call to nonReentrant, _notEntered will be true
945         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
946         // Any calls to nonReentrant after this point will fail
947         _status = _ENTERED;
948         _;
949         // By storing the original value once again, a refund is triggered (see
950         // https://eips.ethereum.org/EIPS/eip-2200)
951         _status = _NOT_ENTERED;
952     }
953 }
954 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
955 pragma solidity ^0.8.0;
956 /**
957  * @dev Provides information about the current execution context, including the
958  * sender of the transaction and its data. While these are generally available
959  * via msg.sender and msg.data, they should not be accessed in such a direct
960  * manner, since when dealing with meta-transactions the account sending and
961  * paying for execution may not be the actual sender (as far as an application
962  * is concerned).
963  *
964  * This contract is only required for intermediate, library-like contracts.
965  */
966 abstract contract Context {
967     function _msgSender() internal view virtual returns (address) {
968         return msg.sender;
969     }
970     function _msgData() internal view virtual returns (bytes calldata) {
971         return msg.data;
972     }
973 }
974 // ERC721A Contracts v3.3.0
975 // Creator: Chiru Labs
976 pragma solidity ^0.8.4;
977 /**
978  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
979  * the Metadata extension. Built to optimize for lower gas during batch mints.
980  *
981  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
982  *
983  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
984  *
985  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
986  */
987 contract ERC721A is Context, ERC165, IERC721A {
988     using Address for address;
989     using Strings for uint256;
990     // The tokenId of the next token to be minted.
991     uint256 internal _currentIndex;
992     // The number of tokens burned.
993     uint256 internal _burnCounter;
994     // Token name
995     string private _name;
996     // Token symbol
997     string private _symbol;
998     // Mapping from token ID to ownership details
999     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
1000     mapping(uint256 => TokenOwnership) internal _ownerships;
1001     // Mapping owner address to address data
1002     mapping(address => AddressData) private _addressData;
1003     // Mapping from token ID to approved address
1004     mapping(uint256 => address) private _tokenApprovals;
1005     // Mapping from owner to operator approvals
1006     mapping(address => mapping(address => bool)) private _operatorApprovals;
1007     constructor(string memory name_, string memory symbol_) {
1008         _name = name_;
1009         _symbol = symbol_;
1010         _currentIndex = _startTokenId();
1011     }
1012     /**
1013      * To change the starting tokenId, please override this function.
1014      */
1015     function _startTokenId() internal view virtual returns (uint256) {
1016         return 0;
1017     }
1018     /**
1019      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
1020      */
1021     function totalSupply() public view override returns (uint256) {
1022         // Counter underflow is impossible as _burnCounter cannot be incremented
1023         // more than _currentIndex - _startTokenId() times
1024         unchecked {
1025             return _currentIndex - _burnCounter - _startTokenId();
1026         }
1027     }
1028     /**
1029      * Returns the total amount of tokens minted in the contract.
1030      */
1031     function _totalMinted() internal view returns (uint256) {
1032         // Counter underflow is impossible as _currentIndex does not decrement,
1033         // and it is initialized to _startTokenId()
1034         unchecked {
1035             return _currentIndex - _startTokenId();
1036         }
1037     }
1038     /**
1039      * @dev See {IERC165-supportsInterface}.
1040      */
1041     function supportsInterface(bytes4 interfaceId)
1042         public
1043         view
1044         virtual
1045         override(ERC165, IERC165)
1046         returns (bool)
1047     {
1048         return
1049             interfaceId == type(IERC721).interfaceId ||
1050             interfaceId == type(IERC721Metadata).interfaceId ||
1051             super.supportsInterface(interfaceId);
1052     }
1053     /**
1054      * @dev See {IERC721-balanceOf}.
1055      */
1056     function balanceOf(address owner) public view override returns (uint256) {
1057         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1058         return uint256(_addressData[owner].balance);
1059     }
1060     /**
1061      * Returns the number of tokens minted by `owner`.
1062      */
1063     function _numberMinted(address owner) internal view returns (uint256) {
1064         return uint256(_addressData[owner].numberMinted);
1065     }
1066     /**
1067      * Returns the number of tokens burned by or on behalf of `owner`.
1068      */
1069     function _numberBurned(address owner) internal view returns (uint256) {
1070         return uint256(_addressData[owner].numberBurned);
1071     }
1072     /**
1073      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1074      */
1075     function _getAux(address owner) internal view returns (uint64) {
1076         return _addressData[owner].aux;
1077     }
1078     /**
1079      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1080      * If there are multiple variables, please pack them into a uint64.
1081      */
1082     function _setAux(address owner, uint64 aux) internal {
1083         _addressData[owner].aux = aux;
1084     }
1085     /**
1086      * Gas spent here starts off proportional to the maximum mint batch size.
1087      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1088      */
1089     function _ownershipOf(uint256 tokenId)
1090         internal
1091         view
1092         returns (TokenOwnership memory)
1093     {
1094         uint256 curr = tokenId;
1095         unchecked {
1096             if (_startTokenId() <= curr)
1097                 if (curr < _currentIndex) {
1098                     TokenOwnership memory ownership = _ownerships[curr];
1099                     if (!ownership.burned) {
1100                         if (ownership.addr != address(0)) {
1101                             return ownership;
1102                         }
1103                         // Invariant:
1104                         // There will always be an ownership that has an address and is not burned
1105                         // before an ownership that does not have an address and is not burned.
1106                         // Hence, curr will not underflow.
1107                         while (true) {
1108                             curr--;
1109                             ownership = _ownerships[curr];
1110                             if (ownership.addr != address(0)) {
1111                                 return ownership;
1112                             }
1113                         }
1114                     }
1115                 }
1116         }
1117         revert OwnerQueryForNonexistentToken();
1118     }
1119     /**
1120      * @dev See {IERC721-ownerOf}.
1121      */
1122     function ownerOf(uint256 tokenId) public view override returns (address) {
1123         return _ownershipOf(tokenId).addr;
1124     }
1125     /**
1126      * @dev See {IERC721Metadata-name}.
1127      */
1128     function name() public view virtual override returns (string memory) {
1129         return _name;
1130     }
1131     /**
1132      * @dev See {IERC721Metadata-symbol}.
1133      */
1134     function symbol() public view virtual override returns (string memory) {
1135         return _symbol;
1136     }
1137     /**
1138      * @dev See {IERC721Metadata-tokenURI}.
1139      */
1140     function tokenURI(uint256 tokenId)
1141         public
1142         view
1143         virtual
1144         override
1145         returns (string memory)
1146     {
1147         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1148         string memory baseURI = _baseURI();
1149         return
1150             bytes(baseURI).length != 0
1151                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
1152                 : "";
1153     }
1154     /**
1155      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1156      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1157      * by default, can be overriden in child contracts.
1158      */
1159     function _baseURI() internal view virtual returns (string memory) {
1160         return "";
1161     }
1162     /**
1163      * @dev See {IERC721-approve}.
1164      */
1165     function approve(address to, uint256 tokenId) public virtual override {
1166         address owner = ERC721A.ownerOf(tokenId);
1167         if (to == owner) revert ApprovalToCurrentOwner();
1168         if (_msgSender() != owner)
1169             if (!isApprovedForAll(owner, _msgSender())) {
1170                 revert ApprovalCallerNotOwnerNorApproved();
1171             }
1172         _approve(to, tokenId, owner);
1173     }
1174     /**
1175      * @dev See {IERC721-getApproved}.
1176      */
1177     function getApproved(uint256 tokenId)
1178         public
1179         view
1180         override
1181         returns (address)
1182     {
1183         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1184         return _tokenApprovals[tokenId];
1185     }
1186     /**
1187      * @dev See {IERC721-setApprovalForAll}.
1188      */
1189     function setApprovalForAll(address operator, bool approved)
1190         public
1191         virtual
1192         override
1193     {
1194         if (operator == _msgSender()) revert ApproveToCaller();
1195         _operatorApprovals[_msgSender()][operator] = approved;
1196         emit ApprovalForAll(_msgSender(), operator, approved);
1197     }
1198     /**
1199      * @dev See {IERC721-isApprovedForAll}.
1200      */
1201     function isApprovedForAll(address owner, address operator)
1202         public
1203         view
1204         virtual
1205         override
1206         returns (bool)
1207     {
1208         return _operatorApprovals[owner][operator];
1209     }
1210     /**
1211      * @dev See {IERC721-transferFrom}.
1212      */
1213     function transferFrom(
1214         address from,
1215         address to,
1216         uint256 tokenId
1217     ) public virtual override {
1218         _transfer(from, to, tokenId);
1219     }
1220     /**
1221      * @dev See {IERC721-safeTransferFrom}.
1222      */
1223     function safeTransferFrom(
1224         address from,
1225         address to,
1226         uint256 tokenId
1227     ) public virtual override {
1228         safeTransferFrom(from, to, tokenId, "");
1229     }
1230     /**
1231      * @dev See {IERC721-safeTransferFrom}.
1232      */
1233     function safeTransferFrom(
1234         address from,
1235         address to,
1236         uint256 tokenId,
1237         bytes memory _data
1238     ) public virtual override {
1239         _transfer(from, to, tokenId);
1240         if (to.isContract())
1241             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1242                 revert TransferToNonERC721ReceiverImplementer();
1243             }
1244     }
1245     /**
1246      * @dev Returns whether `tokenId` exists.
1247      *
1248      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1249      *
1250      * Tokens start existing when they are minted (`_mint`),
1251      */
1252     function _exists(uint256 tokenId) internal view returns (bool) {
1253         return
1254             _startTokenId() <= tokenId &&
1255             tokenId < _currentIndex &&
1256             !_ownerships[tokenId].burned;
1257     }
1258     /**
1259      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1260      */
1261     function _safeMint(address to, uint256 quantity) internal {
1262         _safeMint(to, quantity, "");
1263     }
1264     /**
1265      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1266      *
1267      * Requirements:
1268      *
1269      * - If `to` refers to a smart contract, it must implement
1270      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1271      * - `quantity` must be greater than 0.
1272      *
1273      * Emits a {Transfer} event.
1274      */
1275     function _safeMint(
1276         address to,
1277         uint256 quantity,
1278         bytes memory _data
1279     ) internal {
1280         uint256 startTokenId = _currentIndex;
1281         if (to == address(0)) revert MintToZeroAddress();
1282         if (quantity == 0) revert MintZeroQuantity();
1283         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1284         // Overflows are incredibly unrealistic.
1285         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1286         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1287         unchecked {
1288             _addressData[to].balance += uint64(quantity);
1289             _addressData[to].numberMinted += uint64(quantity);
1290             _ownerships[startTokenId].addr = to;
1291             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1292             uint256 updatedIndex = startTokenId;
1293             uint256 end = updatedIndex + quantity;
1294             if (to.isContract()) {
1295                 do {
1296                     emit Transfer(address(0), to, updatedIndex);
1297                     if (
1298                         !_checkContractOnERC721Received(
1299                             address(0),
1300                             to,
1301                             updatedIndex++,
1302                             _data
1303                         )
1304                     ) {
1305                         revert TransferToNonERC721ReceiverImplementer();
1306                     }
1307                 } while (updatedIndex < end);
1308                 // Reentrancy protection
1309                 if (_currentIndex != startTokenId) revert();
1310             } else {
1311                 do {
1312                     emit Transfer(address(0), to, updatedIndex++);
1313                 } while (updatedIndex < end);
1314             }
1315             _currentIndex = updatedIndex;
1316         }
1317         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1318     }
1319     /**
1320      * @dev Mints `quantity` tokens and transfers them to `to`.
1321      *
1322      * Requirements:
1323      *
1324      * - `to` cannot be the zero address.
1325      * - `quantity` must be greater than 0.
1326      *
1327      * Emits a {Transfer} event.
1328      */
1329     function _mint(address to, uint256 quantity) internal {
1330         uint256 startTokenId = _currentIndex;
1331         if (to == address(0)) revert MintToZeroAddress();
1332         if (quantity == 0) revert MintZeroQuantity();
1333         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1334         // Overflows are incredibly unrealistic.
1335         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1336         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1337         unchecked {
1338             _addressData[to].balance += uint64(quantity);
1339             _addressData[to].numberMinted += uint64(quantity);
1340             _ownerships[startTokenId].addr = to;
1341             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1342             uint256 updatedIndex = startTokenId;
1343             uint256 end = updatedIndex + quantity;
1344             do {
1345                 emit Transfer(address(0), to, updatedIndex++);
1346             } while (updatedIndex < end);
1347             _currentIndex = updatedIndex;
1348         }
1349         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1350     }
1351     /**
1352      * @dev Transfers `tokenId` from `from` to `to`.
1353      *
1354      * Requirements:
1355      *
1356      * - `to` cannot be the zero address.
1357      * - `tokenId` token must be owned by `from`.
1358      *
1359      * Emits a {Transfer} event.
1360      */
1361     function _transfer(
1362         address from,
1363         address to,
1364         uint256 tokenId
1365     ) private {
1366         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1367         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1368         bool isApprovedOrOwner = (_msgSender() == from ||
1369             isApprovedForAll(from, _msgSender()) ||
1370             getApproved(tokenId) == _msgSender());
1371         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1372         if (to == address(0)) revert TransferToZeroAddress();
1373         _beforeTokenTransfers(from, to, tokenId, 1);
1374         // Clear approvals from the previous owner
1375         _approve(address(0), tokenId, from);
1376         // Underflow of the sender's balance is impossible because we check for
1377         // ownership above and the recipient's balance can't realistically overflow.
1378         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1379         unchecked {
1380             _addressData[from].balance -= 1;
1381             _addressData[to].balance += 1;
1382             TokenOwnership storage currSlot = _ownerships[tokenId];
1383             currSlot.addr = to;
1384             currSlot.startTimestamp = uint64(block.timestamp);
1385             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1386             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1387             uint256 nextTokenId = tokenId + 1;
1388             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1389             if (nextSlot.addr == address(0)) {
1390                 // This will suffice for checking _exists(nextTokenId),
1391                 // as a burned slot cannot contain the zero address.
1392                 if (nextTokenId != _currentIndex) {
1393                     nextSlot.addr = from;
1394                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1395                 }
1396             }
1397         }
1398         emit Transfer(from, to, tokenId);
1399         _afterTokenTransfers(from, to, tokenId, 1);
1400     }
1401     /**
1402      * @dev Equivalent to `_burn(tokenId, false)`.
1403      */
1404     function _burn(uint256 tokenId) internal virtual {
1405         _burn(tokenId, false);
1406     }
1407     /**
1408      * @dev Destroys `tokenId`.
1409      * The approval is cleared when the token is burned.
1410      *
1411      * Requirements:
1412      *
1413      * - `tokenId` must exist.
1414      *
1415      * Emits a {Transfer} event.
1416      */
1417     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1418         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1419         address from = prevOwnership.addr;
1420         if (approvalCheck) {
1421             bool isApprovedOrOwner = (_msgSender() == from ||
1422                 isApprovedForAll(from, _msgSender()) ||
1423                 getApproved(tokenId) == _msgSender());
1424             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1425         }
1426         _beforeTokenTransfers(from, address(0), tokenId, 1);
1427         // Clear approvals from the previous owner
1428         _approve(address(0), tokenId, from);
1429         // Underflow of the sender's balance is impossible because we check for
1430         // ownership above and the recipient's balance can't realistically overflow.
1431         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1432         unchecked {
1433             AddressData storage addressData = _addressData[from];
1434             addressData.balance -= 1;
1435             addressData.numberBurned += 1;
1436             // Keep track of who burned the token, and the timestamp of burning.
1437             TokenOwnership storage currSlot = _ownerships[tokenId];
1438             currSlot.addr = from;
1439             currSlot.startTimestamp = uint64(block.timestamp);
1440             currSlot.burned = true;
1441             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1442             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1443             uint256 nextTokenId = tokenId + 1;
1444             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1445             if (nextSlot.addr == address(0)) {
1446                 // This will suffice for checking _exists(nextTokenId),
1447                 // as a burned slot cannot contain the zero address.
1448                 if (nextTokenId != _currentIndex) {
1449                     nextSlot.addr = from;
1450                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1451                 }
1452             }
1453         }
1454         emit Transfer(from, address(0), tokenId);
1455         _afterTokenTransfers(from, address(0), tokenId, 1);
1456         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1457         unchecked {
1458             _burnCounter++;
1459         }
1460     }
1461     /**
1462      * @dev Approve `to` to operate on `tokenId`
1463      *
1464      * Emits a {Approval} event.
1465      */
1466     function _approve(
1467         address to,
1468         uint256 tokenId,
1469         address owner
1470     ) private {
1471         _tokenApprovals[tokenId] = to;
1472         emit Approval(owner, to, tokenId);
1473     }
1474     /**
1475      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1476      *
1477      * @param from address representing the previous owner of the given token ID
1478      * @param to target address that will receive the tokens
1479      * @param tokenId uint256 ID of the token to be transferred
1480      * @param _data bytes optional data to send along with the call
1481      * @return bool whether the call correctly returned the expected magic value
1482      */
1483     function _checkContractOnERC721Received(
1484         address from,
1485         address to,
1486         uint256 tokenId,
1487         bytes memory _data
1488     ) private returns (bool) {
1489         try
1490             IERC721Receiver(to).onERC721Received(
1491                 _msgSender(),
1492                 from,
1493                 tokenId,
1494                 _data
1495             )
1496         returns (bytes4 retval) {
1497             return retval == IERC721Receiver(to).onERC721Received.selector;
1498         } catch (bytes memory reason) {
1499             if (reason.length == 0) {
1500                 revert TransferToNonERC721ReceiverImplementer();
1501             } else {
1502                 assembly {
1503                     revert(add(32, reason), mload(reason))
1504                 }
1505             }
1506         }
1507     }
1508     /**
1509      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1510      * And also called before burning one token.
1511      *
1512      * startTokenId - the first token id to be transferred
1513      * quantity - the amount to be transferred
1514      *
1515      * Calling conditions:
1516      *
1517      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1518      * transferred to `to`.
1519      * - When `from` is zero, `tokenId` will be minted for `to`.
1520      * - When `to` is zero, `tokenId` will be burned by `from`.
1521      * - `from` and `to` are never both zero.
1522      */
1523     function _beforeTokenTransfers(
1524         address from,
1525         address to,
1526         uint256 startTokenId,
1527         uint256 quantity
1528     ) internal virtual {}
1529     /**
1530      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1531      * minting.
1532      * And also called after one token has been burned.
1533      *
1534      * startTokenId - the first token id to be transferred
1535      * quantity - the amount to be transferred
1536      *
1537      * Calling conditions:
1538      *
1539      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1540      * transferred to `to`.
1541      * - When `from` is zero, `tokenId` has been minted for `to`.
1542      * - When `to` is zero, `tokenId` has been burned by `from`.
1543      * - `from` and `to` are never both zero.
1544      */
1545     function _afterTokenTransfers(
1546         address from,
1547         address to,
1548         uint256 startTokenId,
1549         uint256 quantity
1550     ) internal virtual {}
1551 }
1552 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1553 pragma solidity ^0.8.0;
1554 /**
1555  * @dev Contract module which provides a basic access control mechanism, where
1556  * there is an account (an owner) that can be granted exclusive access to
1557  * specific functions.
1558  *
1559  * By default, the owner account will be the one that deploys the contract. This
1560  * can later be changed with {transferOwnership}.
1561  *
1562  * This module is used through inheritance. It will make available the modifier
1563  * `onlyOperator`, which can be applied to your functions to restrict their use to
1564  * the owner.
1565  */
1566 abstract contract Ownable is Context {
1567     address private _owner;
1568     event OwnershipTransferred(
1569         address indexed previousOwner,
1570         address indexed newOwner
1571     );
1572     /**
1573      * @dev Initializes the contract setting the deployer as the initial owner.
1574      */
1575     constructor() {
1576         _transferOwnership(_msgSender());
1577     }
1578     /**
1579      * @dev Throws if called by any account other than the owner.
1580      */
1581     modifier onlyOwner() {
1582         _checkOwner();
1583         _;
1584     }
1585     /**
1586      * @dev Returns the address of the current owner.
1587      */
1588     function owner() public view virtual returns (address) {
1589         return _owner;
1590     }
1591     /**
1592      * @dev Throws if the sender is not the owner.
1593      */
1594     function _checkOwner() internal view virtual {
1595         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1596     }
1597     /**
1598      * @dev Leaves the contract without owner. It will not be possible to call
1599      * `onlyOwner` functions anymore. Can only be called by the current owner.
1600      *
1601      * NOTE: Renouncing ownership will leave the contract without an owner,
1602      * thereby removing any functionality that is only available to the owner.
1603      */
1604     function renounceOwnership() public virtual onlyOwner {
1605         _transferOwnership(address(0));
1606     }
1607     /**
1608      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1609      * Can only be called by the current owner.
1610      */
1611     function transferOwnership(address newOwner) public virtual onlyOwner {
1612         require(
1613             newOwner != address(0),
1614             "Ownable: new owner is the zero address"
1615         );
1616         _transferOwnership(newOwner);
1617     }
1618     /**
1619      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1620      * Internal function without access restriction.
1621      */
1622     function _transferOwnership(address newOwner) internal virtual {
1623         address oldOwner = _owner;
1624         _owner = newOwner;
1625         emit OwnershipTransferred(oldOwner, newOwner);
1626     }
1627 }
1628 pragma solidity ^0.8.9;
1629 abstract contract Operable is Context {
1630     mapping(address => bool) _operators;
1631     modifier onlyOperator() {
1632         _checkOperatorRole(_msgSender());
1633         _;
1634     }
1635     function isOperator(address _operator) public view returns (bool) {
1636         return _operators[_operator];
1637     }
1638     function _grantOperatorRole(address _candidate) internal {
1639         require(
1640             !_operators[_candidate],
1641             string(
1642                 abi.encodePacked(
1643                     "account ",
1644                     Strings.toHexString(uint160(_msgSender()), 20),
1645                     " is already has an operator role"
1646                 )
1647             )
1648         );
1649         _operators[_candidate] = true;
1650     }
1651     function _revokeOperatorRole(address _candidate) internal {
1652         _checkOperatorRole(_candidate);
1653         delete _operators[_candidate];
1654     }
1655     function _checkOperatorRole(address _operator) internal view {
1656         require(
1657             _operators[_operator],
1658             string(
1659                 abi.encodePacked(
1660                     "account ",
1661                     Strings.toHexString(uint160(_msgSender()), 20),
1662                     " is not an operator"
1663                 )
1664             )
1665         );
1666     }
1667 }
1668 pragma solidity ^0.8.13;
1669 interface IOperatorFilterRegistry {
1670     function isOperatorAllowed(address registrant, address operator)
1671         external
1672         view
1673         returns (bool);
1674     function register(address registrant) external;
1675     function registerAndSubscribe(address registrant, address subscription)
1676         external;
1677     function registerAndCopyEntries(
1678         address registrant,
1679         address registrantToCopy
1680     ) external;
1681     function unregister(address addr) external;
1682     function updateOperator(
1683         address registrant,
1684         address operator,
1685         bool filtered
1686     ) external;
1687     function updateOperators(
1688         address registrant,
1689         address[] calldata operators,
1690         bool filtered
1691     ) external;
1692     function updateCodeHash(
1693         address registrant,
1694         bytes32 codehash,
1695         bool filtered
1696     ) external;
1697     function updateCodeHashes(
1698         address registrant,
1699         bytes32[] calldata codeHashes,
1700         bool filtered
1701     ) external;
1702     function subscribe(address registrant, address registrantToSubscribe)
1703         external;
1704     function unsubscribe(address registrant, bool copyExistingEntries) external;
1705     function subscriptionOf(address addr) external returns (address registrant);
1706     function subscribers(address registrant)
1707         external
1708         returns (address[] memory);
1709     function subscriberAt(address registrant, uint256 index)
1710         external
1711         returns (address);
1712     function copyEntriesOf(address registrant, address registrantToCopy)
1713         external;
1714     function isOperatorFiltered(address registrant, address operator)
1715         external
1716         returns (bool);
1717     function isCodeHashOfFiltered(address registrant, address operatorWithCode)
1718         external
1719         returns (bool);
1720     function isCodeHashFiltered(address registrant, bytes32 codeHash)
1721         external
1722         returns (bool);
1723     function filteredOperators(address addr)
1724         external
1725         returns (address[] memory);
1726     function filteredCodeHashes(address addr)
1727         external
1728         returns (bytes32[] memory);
1729     function filteredOperatorAt(address registrant, uint256 index)
1730         external
1731         returns (address);
1732     function filteredCodeHashAt(address registrant, uint256 index)
1733         external
1734         returns (bytes32);
1735     function isRegistered(address addr) external returns (bool);
1736     function codeHashOf(address addr) external returns (bytes32);
1737 }
1738 pragma solidity ^0.8.13;
1739 /**
1740  * @title  OperatorFilterer
1741  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
1742  *         registrant's entries in the OperatorFilterRegistry.
1743  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
1744  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
1745  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
1746  */
1747 abstract contract OperatorFilterer {
1748     error OperatorNotAllowed(address operator);
1749     bool public operatorFilteringEnabled = true;
1750     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
1751         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1752     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1753         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1754         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1755         // order for the modifier to filter addresses.
1756         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1757             if (subscribe) {
1758                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(
1759                     address(this),
1760                     subscriptionOrRegistrantToCopy
1761                 );
1762             } else {
1763                 if (subscriptionOrRegistrantToCopy != address(0)) {
1764                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(
1765                         address(this),
1766                         subscriptionOrRegistrantToCopy
1767                     );
1768                 } else {
1769                     OPERATOR_FILTER_REGISTRY.register(address(this));
1770                 }
1771             }
1772         }
1773     }
1774     modifier onlyAllowedOperator(address from) virtual {
1775         // Check registry code length to facilitate testing in environments without a deployed registry.
1776         if (
1777             address(OPERATOR_FILTER_REGISTRY).code.length > 0 &&
1778             operatorFilteringEnabled
1779         ) {
1780             // Allow spending tokens from addresses with balance
1781             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1782             // from an EOA.
1783             if (from == msg.sender) {
1784                 _;
1785                 return;
1786             }
1787             if (
1788                 !OPERATOR_FILTER_REGISTRY.isOperatorAllowed(
1789                     address(this),
1790                     msg.sender
1791                 )
1792             ) {
1793                 revert OperatorNotAllowed(msg.sender);
1794             }
1795         }
1796         _;
1797     }
1798     modifier onlyAllowedOperatorApproval(address operator) virtual {
1799         // Check registry code length to facilitate testing in environments without a deployed registry.
1800         if (
1801             address(OPERATOR_FILTER_REGISTRY).code.length > 0 &&
1802             operatorFilteringEnabled
1803         ) {
1804             if (
1805                 !OPERATOR_FILTER_REGISTRY.isOperatorAllowed(
1806                     address(this),
1807                     operator
1808                 )
1809             ) {
1810                 revert OperatorNotAllowed(operator);
1811             }
1812         }
1813         _;
1814     }
1815 }
1816 pragma solidity ^0.8.13;
1817 /**
1818  * @title  DefaultOperatorFilterer
1819  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
1820  */
1821 abstract contract DefaultOperatorFilterer is OperatorFilterer {
1822     address constant DEFAULT_SUBSCRIPTION =
1823         address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1824     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1825 }
1826 interface IERC721ANSK is IERC721A {
1827     function tokenURI(uint256 _tokenId) external view returns (string memory);
1828     function walletOfOwner(address _address)
1829         external
1830         view
1831         returns (uint256[] memory);
1832 }
1833 pragma solidity ^0.8.7;
1834 /*
1835 ┏━━┳━━┳━━┳━┳━━┳┳━┳━┳┓┏━━┳━━┳━┳┳┳━┳━━┓
1836 ┃━━╋┓┏┫┏┓┃╋┣┓┏┫┃╋┃┃┃┃┗┓┏┻┃┃┫┏┫┏┫┳┻┓┏┛
1837 ┣━━┃┃┃┃┣┫┃┓┫┃┣┫┃┏┫┃┃┃╋┃┃┏┃┃┫┗┫┗┫┻┓┃┃
1838 ┗━━┛┗┛┗┛┗┻┻┛┗┻━┻┛┗┻━┛╋┗┛┗━━┻━┻┻┻━┛┗┛
1839 STARTJPN Ticket
1840 */
1841 contract StartTicket is
1842     Ownable,
1843     ERC721A,
1844     ReentrancyGuard,
1845     MerkleProof,
1846     ERC2981,
1847     DefaultOperatorFilterer,
1848     Operable
1849 {
1850     //Project Settings
1851     uint256 public wlMintPrice = 0.0 ether;
1852     uint256 public psMintPrice = 0.003 ether;
1853     uint256 public maxMintsPerWL = 1;
1854     uint256 public maxMintsPerPS = 1;
1855     uint256 public maxSupply = 50000;
1856     uint256 public mintable = 5000;
1857     address payable internal _withdrawWallet;
1858     uint256 public maxReq = 50000;
1859     uint256 public maxQues = 50000;
1860     uint256 public phaseNum = 1;
1861     uint256 public phaseNumQ = 1;
1862     uint256 public nowCount;
1863     uint256 public nowCountQues;
1864     uint256 public phaseRequire = 1;
1865     address public baseAddress;
1866     IERC721ANSK baseContract;
1867     //URI
1868     string internal hiddenURI;
1869     string internal _baseTokenURI;
1870     string public _baseExtension = ".json";
1871     //flags
1872     bool public isWlSaleEnabled;
1873     bool public isPublicSaleEnabled;
1874     bool public isPublicMPSaleEnabled;
1875     bool public isPublicBOSaleEnabled;
1876     bool public revealed = false;
1877     bool public burnWriteEnable = false;
1878     bool public burnWriteRemoveEnable = false;
1879     bool public burnWriteQEnable = false;
1880     bool public requireBaseHold = false;
1881     address public deployer;
1882     //mint records.
1883     mapping(address => uint256) internal _wlMinted;
1884     mapping(address => uint256) internal _psMinted;
1885     uint256[] public _requests;
1886     mapping(address => uint256) internal _requestsAddress;
1887     mapping(uint256 => uint256) internal _requestedId;
1888     uint256[] public _quests;
1889     address[] public _questsAddress;
1890     mapping(uint256 => uint256) public questRequire;
1891     mapping(uint256 => uint256) public requestRequire;
1892     mapping(uint256 => uint256) public questMax;
1893     mapping(uint256 => mapping(uint256 => uint256)) public questHistory;
1894     constructor(
1895         address _royaltyReceiver,
1896         uint96 _royaltyFraction,
1897         address _contractAddress
1898     ) ERC721A("STARTJPN Ticket", "STK") {
1899         deployer = msg.sender;
1900         baseAddress = _contractAddress;
1901         // _withdrawWallet = payable(deployer);
1902         _grantOperatorRole(msg.sender);
1903         _setDefaultRoyalty(_royaltyReceiver, _royaltyFraction);
1904         baseContract = IERC721ANSK(_contractAddress);
1905     }
1906     function setBaseContract(address _contractAddress) public onlyOperator {
1907         baseContract = IERC721ANSK(_contractAddress);
1908         baseAddress = _contractAddress;
1909     }
1910     //start from 1.adjust.
1911     function _startTokenId() internal view virtual override returns (uint256) {
1912         return 1;
1913     }
1914     //set Default Royalty._feeNumerator 500 = 5% Royalty
1915     function setDefaultRoyalty(address _receiver, uint96 _feeNumerator)
1916         external
1917         virtual
1918         onlyOperator
1919     {
1920         _setDefaultRoyalty(_receiver, _feeNumerator);
1921     }
1922     //for ERC2981
1923     function supportsInterface(bytes4 interfaceId)
1924         public
1925         view
1926         virtual
1927         override(ERC721A, ERC2981)
1928         returns (bool)
1929     {
1930         return super.supportsInterface(interfaceId);
1931     }
1932     //for ERC2981 Opensea
1933     function contractURI() external view virtual returns (string memory) {
1934         return _formatContractURI();
1935     }
1936     //make contractURI
1937     function _formatContractURI() internal view returns (string memory) {
1938         (address receiver, uint256 royaltyFraction) = royaltyInfo(
1939             0,
1940             _feeDenominator()
1941         ); //tokenid=0
1942         return
1943             string(
1944                 abi.encodePacked(
1945                     "data:application/json;base64,",
1946                     Base64.encode(
1947                         bytes(
1948                             abi.encodePacked(
1949                                 '{"seller_fee_basis_points":',
1950                                 Strings.toString(royaltyFraction),
1951                                 ', "fee_recipient":"',
1952                                 Strings.toHexString(
1953                                     uint256(uint160(receiver)),
1954                                     20
1955                                 ),
1956                                 '"}'
1957                             )
1958                         )
1959                     )
1960                 )
1961             );
1962     }
1963     //set owner's wallet.withdraw to this wallet.only owner.
1964     function setWithdrawWallet(address _owner) external virtual onlyOperator {
1965         _withdrawWallet = payable(_owner);
1966     }
1967     function setDeployer(address _deployer) external virtual onlyOperator {
1968         deployer = _deployer;
1969     }
1970     //set maxSupply.only owner.
1971     function setMaxSupply(uint256 _maxSupply) external virtual onlyOperator {
1972         require(totalSupply() <= _maxSupply, "Lower than _currentIndex.");
1973         maxSupply = _maxSupply;
1974     }
1975     //set mintable.only owner.
1976     function setMintable(uint256 _mintable) external virtual onlyOperator {
1977         require(totalSupply() <= _mintable, "Lower than _currentIndex.");
1978         mintable = _mintable;
1979     }
1980     // SET PRICES.
1981     function setWlPrice(uint256 newPrice) external virtual onlyOperator {
1982         wlMintPrice = newPrice;
1983     }
1984     function setPsPrice(uint256 newPrice) external virtual onlyOperator {
1985         psMintPrice = newPrice;
1986     }
1987     //set reveal.only owner.
1988     function setReveal(bool newRevealStatus) external virtual onlyOperator {
1989         revealed = newRevealStatus;
1990     }
1991     //return _isRevealed()
1992     function _isRevealed() internal view virtual returns (bool) {
1993         return revealed;
1994     }
1995     // GET MINTED COUNT.
1996     function wlMinted(address _address)
1997         external
1998         view
1999         virtual
2000         returns (uint256)
2001     {
2002         return _wlMinted[_address];
2003     }
2004     function psMinted(address _address)
2005         external
2006         view
2007         virtual
2008         returns (uint256)
2009     {
2010         return _psMinted[_address];
2011     }
2012     // SET MAX MINTS.
2013     function setWlMaxMints(uint256 _max) external virtual onlyOperator {
2014         maxMintsPerWL = _max;
2015     }
2016     function setPsMaxMints(uint256 _max) external virtual onlyOperator {
2017         maxMintsPerPS = _max;
2018     }
2019     // SET SALES ENABLE.
2020     function setWhitelistSaleEnable(bool bool_) external virtual onlyOperator {
2021         isWlSaleEnabled = bool_;
2022     }
2023     function setPublicSaleEnable(bool bool_) external virtual onlyOperator {
2024         isPublicSaleEnabled = bool_;
2025     }
2026     function setPublicMPSaleEnable(bool bool_) external virtual onlyOperator {
2027         isPublicMPSaleEnabled = bool_;
2028     }
2029     function setPublicBOSaleEnable(bool bool_) external virtual onlyOperator {
2030         isPublicBOSaleEnabled = bool_;
2031     }
2032     // SET MERKLE ROOT.
2033     function setWlMerkleRoot(bytes32 merkleRoot_)
2034         external
2035         virtual
2036         onlyOperator
2037     {
2038         _setWlMerkleRoot(merkleRoot_);
2039     }
2040         // SET MERKLE ROOT.
2041     function setPWlMerkleRoot(bytes32 merkleRoot_)
2042         external
2043         virtual
2044         onlyOperator
2045     {
2046         _setPWlMerkleRoot(merkleRoot_);
2047     }
2048     //set HiddenBaseURI.only owner.
2049     function setHiddenURI(string memory uri_) external virtual onlyOperator {
2050         hiddenURI = uri_;
2051     }
2052     //return _currentIndex
2053     function getCurrentIndex() external view virtual returns (uint256) {
2054         return _currentIndex;
2055     }
2056     //set BaseURI at after reveal. only owner.
2057     function setBaseURI(string memory uri_) external virtual onlyOperator {
2058         _baseTokenURI = uri_;
2059     }
2060     function setBaseExtension(string memory _newBaseExtension)
2061         external
2062         onlyOperator
2063     {
2064         _baseExtension = _newBaseExtension;
2065     }
2066     //retuen BaseURI.internal.
2067     function _currentBaseURI() internal view returns (string memory) {
2068         return _baseTokenURI;
2069     }
2070     function tokenURI(uint256 _tokenId)
2071         public
2072         view
2073         virtual
2074         override
2075         returns (string memory)
2076     {
2077         require(_exists(_tokenId), "URI query for nonexistent token");
2078         if (_isRevealed()) {
2079             return
2080                 string(
2081                     abi.encodePacked(
2082                         _currentBaseURI(),
2083                         Strings.toString(_tokenId),
2084                         _baseExtension
2085                     )
2086                 );
2087         }
2088         return hiddenURI;
2089     }
2090     //owner mint.transfer to _address.only owner.
2091     function ownerMint(uint256 _amount, address _address)
2092         external
2093         virtual
2094         onlyOperator
2095     {
2096         require((_amount + totalSupply()) <= (maxSupply), "No more NFTs");
2097         _safeMint(_address, _amount);
2098     }
2099     //WL mint.
2100     function whitelistMint(
2101         uint256 _amount,
2102         uint256 wlcount,
2103         bytes32[] memory proof_
2104     ) external payable virtual nonReentrant {
2105         require(isWlSaleEnabled, "whitelistMint is Paused");
2106         require(
2107             isWhitelisted(msg.sender, wlcount, proof_),
2108             "You are not whitelisted!"
2109         );
2110         require(wlcount > 0, "You have no WL!");
2111         require(wlcount >= _amount, "whitelistMint: Over max mints per wallet");
2112         require(
2113             wlcount >= _wlMinted[msg.sender] + _amount,
2114             "You have no whitelistMint left"
2115         );
2116         // require(msg.value == wlMintPrice * _amount, "ETH value is not correct");
2117         require((_amount + totalSupply()) <= (mintable), "No more NFTs");
2118         require((_amount + totalSupply()) <= (maxSupply), "No more NFTs");
2119         _wlMinted[msg.sender] += _amount;
2120         _safeMint(msg.sender, _amount);
2121     }
2122     //Public mint.
2123     function publicMint(uint256 _amount) external payable virtual nonReentrant {
2124         require(isPublicSaleEnabled, "publicMint is Paused");
2125         require(
2126             maxMintsPerPS >= _amount,
2127             "publicMint: Over max mints per wallet"
2128         );
2129         require(
2130             maxMintsPerPS >= _psMinted[msg.sender] + _amount,
2131             "You have no publicMint left"
2132         );
2133         require(msg.value == psMintPrice * _amount, "ETH value is not correct");
2134         require((_amount + totalSupply()) <= (mintable), "No more NFTs");
2135         require((_amount + totalSupply()) <= (maxSupply), "No more NFTs");
2136         _psMinted[msg.sender] += _amount;
2137         _safeMint(msg.sender, _amount);
2138     }
2139     //Public mint.
2140     function publicMintMP(uint256 _amount, bytes32[] memory proof_)
2141         external
2142         payable
2143         virtual
2144         nonReentrant
2145     {
2146         require(isPublicMPSaleEnabled, "publicMPMint is Paused");
2147         require(isPWhitelisted(msg.sender, proof_), "You are not whitelisted!");
2148         require(
2149             maxMintsPerPS >= _amount,
2150             "publicMint: Over max mints per wallet"
2151         );
2152         require(
2153             maxMintsPerPS >= _psMinted[msg.sender] + _amount,
2154             "You have no publicMint left"
2155         );
2156         require(msg.value == psMintPrice * _amount, "ETH value is not correct");
2157         require((_amount + totalSupply()) <= (mintable), "No more NFTs");
2158         require((_amount + totalSupply()) <= (maxSupply), "No more NFTs");
2159         _psMinted[msg.sender] += _amount;
2160         _safeMint(msg.sender, _amount);
2161     }
2162     //Public mint.
2163     function publicMintBO(uint256 _amount)
2164         external
2165         payable
2166         virtual
2167         nonReentrant
2168     {
2169         require(isPublicBOSaleEnabled, "publicBOMint is Paused");
2170         require(
2171             0 <= baseContract.balanceOf(msg.sender),
2172             "you not have Base NFT"
2173         );
2174         require(
2175             maxMintsPerPS >= _amount,
2176             "publicMint: Over max mints per wallet"
2177         );
2178         require(
2179             maxMintsPerPS >= _psMinted[msg.sender] + _amount,
2180             "You have no publicMint left"
2181         );
2182         require(msg.value == psMintPrice * _amount, "ETH value is not correct");
2183         require((_amount + totalSupply()) <= (mintable), "No more NFTs");
2184         require((_amount + totalSupply()) <= (maxSupply), "No more NFTs");
2185         _psMinted[msg.sender] += _amount;
2186         _safeMint(msg.sender, _amount);
2187     }
2188     //burn
2189     function burn(uint256 tokenId) external virtual {
2190         _burn(tokenId, true);
2191     }
2192     //widraw ETH from this contract.only owner.
2193     function withdraw() external payable virtual onlyOperator nonReentrant {
2194         // This will payout the owner 100% of the contract balance.
2195         // Do not remove this otherwise you will not be able to withdraw the funds.
2196         // =============================================================================
2197         bool os;
2198         if (_withdrawWallet != address(0)) {
2199             //if _withdrawWallet has.
2200             (os, ) = payable(_withdrawWallet).call{
2201                 value: address(this).balance
2202             }("");
2203         } else {
2204             (os, ) = payable(owner()).call{value: address(this).balance}("");
2205         }
2206         require(os);
2207         // =============================================================================
2208     }
2209     //return wallet owned tokenids.
2210     function walletOfOwner(address _address)
2211         external
2212         view
2213         virtual
2214         returns (uint256[] memory)
2215     {
2216         uint256 ownerTokenCount = balanceOf(_address);
2217         uint256[] memory tokenIds = new uint256[](ownerTokenCount);
2218         //search from all tonkenid. so spend high gas values.attention.
2219         uint256 tokenindex = 0;
2220         for (uint256 i = _startTokenId(); i < _currentIndex; i++) {
2221             if (_address == this.tryOwnerOf(i)) tokenIds[tokenindex++] = i;
2222         }
2223         return tokenIds;
2224     }
2225     //return wallet owned tokenids.
2226     function walletOfOwnerBase(address _address)
2227         external
2228         view
2229         virtual
2230         returns (uint256[] memory)
2231     {
2232         return baseContract.walletOfOwner(_address);
2233     }
2234     function tokenURIBase(uint256 _tokenId)
2235         public
2236         view
2237         virtual
2238         returns (string memory)
2239     {
2240         return baseContract.tokenURI(_tokenId);
2241     }
2242     function balanceOfBase(address owner) public view returns (uint256) {
2243         return baseContract.balanceOf(owner);
2244     }
2245     //return wallet owned tokenids.
2246     function walletOfOwnerByIndex(address _address, uint256 _index)
2247         external
2248         view
2249         virtual
2250         returns (uint256)
2251     {
2252         uint256 tokenId;
2253         //search from all tonkenid. so spend high gas values.attention.
2254         uint256 tokenindex = 0;
2255         for (uint256 i = _startTokenId(); i < _currentIndex; i++) {
2256             if (_address == this.tryOwnerOf(i)) {
2257                 tokenId = i;
2258                 if (_index == tokenindex) {
2259                     break;
2260                 }
2261                 tokenindex++;
2262             }
2263         }
2264         return tokenId;
2265     }
2266     //try catch vaersion ownerOf. support burned tokenid.
2267     function tryOwnerOf(uint256 tokenId)
2268         external
2269         view
2270         virtual
2271         returns (address)
2272     {
2273         try this.ownerOf(tokenId) returns (address _address) {
2274             return (_address);
2275         } catch {
2276             return (address(0)); //return 0x0 if error.
2277         }
2278     }
2279     //set setBurnWriteEnable.only owner.
2280     function setBurnWriteEnable(bool _newbwStatus)
2281         external
2282         virtual
2283         onlyOperator
2284     {
2285         burnWriteEnable = _newbwStatus;
2286     }
2287     //set setBurnWriteRemoveEnable.only owner.
2288     function setBurnWriteRemoveEnable(bool _newbwStatus)
2289         external
2290         virtual
2291         onlyOperator
2292     {
2293         burnWriteRemoveEnable = _newbwStatus;
2294     }
2295     //set setBurnWriteEnable.only owner.
2296     function setBurnWriteQEnable(bool _newbwStatus)
2297         external
2298         virtual
2299         onlyOperator
2300     {
2301         burnWriteQEnable = _newbwStatus;
2302     }
2303     //set nowNum.only owner.
2304     function resetPhase() external virtual onlyOperator {
2305         delete _requests;
2306         nowCount = 0;
2307         phaseNum++;
2308     }
2309     //set nowNum.only owner.
2310     function setMaxReq(uint256 _maxReq) external virtual onlyOperator {
2311         maxReq = _maxReq;
2312     }
2313     //burn.and.write
2314     function burnWrite(uint256 _tokenId, uint256 _burnId)
2315         external
2316         virtual
2317         nonReentrant
2318     {
2319         require(burnWriteEnable, "burnWrite is disabled");
2320         require(
2321             msg.sender == baseContract.ownerOf(_tokenId),
2322             "you are not owner.Base"
2323         );
2324         require(msg.sender == ownerOf(_burnId), "you are not owner.Ticket");
2325         require(
2326             _requestedId[_tokenId] != phaseNum ||
2327                 _requestsAddress[msg.sender] != phaseNum,
2328             "you have writed in past."
2329         );
2330         // require(balanceOf(msg.sender) > 0,"you not have ticket.");
2331         require(maxReq > nowCount, "phase exeed.");
2332         _setRequest(_tokenId);
2333         _burn(_burnId, true);
2334     }
2335     //burn.and.write
2336     function burnWriteMulti(uint256 _tokenId, uint256[] memory _burnIds)
2337         external
2338         virtual
2339         nonReentrant
2340     {
2341         require(burnWriteEnable, "burnWrite is disabled");
2342         require(
2343             msg.sender == baseContract.ownerOf(_tokenId),
2344             "you are not owner.Base"
2345         );
2346         require(
2347             _burnIds.length <= balanceOf(msg.sender),
2348             "you not have amount"
2349         );
2350         require(hasToken(msg.sender, _burnIds), "you not have tokens");
2351         require(
2352             _requestedId[_tokenId] != phaseNum ||
2353                 _requestsAddress[msg.sender] != phaseNum,
2354             "you have writed in past."
2355         );
2356         require(
2357             phaseRequire == _burnIds.length ||
2358                 ((phaseRequire == 0 || phaseRequire == 1) &&
2359                     _burnIds.length == 1),
2360             "quantity is wrong"
2361         );
2362         require(maxReq > nowCount, "phase exeed.");
2363         _setRequest(_tokenId);
2364         multiBurn(msg.sender, _burnIds);
2365     }
2366     //burn.and.write
2367     function burnRemoveWrite(uint256 _tokenId) external virtual nonReentrant {
2368         require(burnWriteRemoveEnable, "burnWriteRemove is disabled");
2369         require(
2370             msg.sender == baseContract.ownerOf(_tokenId),
2371             "you are not owner.Base"
2372         );
2373         _removeRequest(_tokenId);
2374     }
2375     function _setRequest(uint256 _tokenId) internal virtual {
2376         _requests.push(_tokenId);
2377         _requestsAddress[msg.sender] = phaseNum;
2378         _requestedId[_tokenId] = phaseNum;
2379         nowCount++;
2380     }
2381     function _removeRequest(uint256 _tokenId) internal virtual {
2382         for (uint256 i = 0; i < _requests.length; i++) {
2383             if (_tokenId == _requests[i]) {
2384                 delete _requests[i];
2385                 break;
2386             }
2387         }
2388     }
2389     function _getRequest() external view virtual returns (uint256[] memory) {
2390         return _requests;
2391     }
2392     //set nowNum.only owner.
2393     function resetPhaseQues() external virtual onlyOperator {
2394         delete _quests;
2395         delete _questsAddress;
2396         nowCountQues = 0;
2397         phaseNumQ++;
2398     }
2399     //set nowNum.only owner.
2400     function setMaxQues(uint256 _maxQues) external virtual onlyOperator {
2401         maxQues = _maxQues;
2402     }
2403     //set setMaxQuesByUnit.only owner.
2404     function setQuestMaxByUnit(uint256 _quesId, uint256 _maxQues)
2405         external
2406         virtual
2407         onlyOperator
2408     {
2409         questMax[_quesId] = _maxQues;
2410     }
2411     //set nowNum.only owner.
2412     function setQuestRequire(uint256 _questId, uint256 _quantity)
2413         external
2414         virtual
2415         onlyOperator
2416     {
2417         questRequire[_questId] = _quantity;
2418     }
2419     //set nowNum.only owner.
2420     function setRequestRequire(uint256 _requestId, uint256 _quantity)
2421         external
2422         virtual
2423         onlyOperator
2424     {
2425         requestRequire[_requestId] = _quantity;
2426     }
2427     //burn.and.write
2428     function burnWriteQues(uint256 _quesId, uint256 burnId)
2429         external
2430         virtual
2431         nonReentrant
2432     {
2433         require(burnWriteQEnable, "burnWriteQ is disabled");
2434         require(msg.sender == ownerOf(burnId), "you are not owner");
2435         require(maxQues > nowCountQues, "phase exeed.");
2436         require(
2437             questMax[_quesId] > questHistory[phaseNumQ][_quesId] ||
2438                 questMax[_quesId] == 0,
2439             "ques exeed."
2440         );
2441         require(
2442             requireBaseHold == false || 0 <= baseContract.balanceOf(msg.sender),
2443             "you not have Base NFT"
2444         );
2445         require(
2446             questRequire[_quesId] == 0 || questRequire[_quesId] == 1,
2447             "quantity is wrong"
2448         );
2449         _setQuest(_quesId);
2450         _burn(burnId, true);
2451     }
2452     //burn.and.write
2453     function burnWriteMultiQues(uint256 _quesId, uint256[] memory _burnIds)
2454         external
2455         virtual
2456         nonReentrant
2457     {
2458         require(burnWriteQEnable, "burnWriteQ is disabled");
2459         require(maxQues > nowCountQues, "phase exeed.");
2460         require(
2461             _burnIds.length <= balanceOf(msg.sender),
2462             "you not have amount"
2463         );
2464         require(
2465             questMax[_quesId] > questHistory[phaseNumQ][_quesId] ||
2466                 questMax[_quesId] == 0,
2467             "ques exeed."
2468         );
2469         require(
2470             requireBaseHold == false || 0 <= baseContract.balanceOf(msg.sender),
2471             "you not have Base NFT"
2472         );
2473         require(hasToken(msg.sender, _burnIds), "you not have tokens");
2474         require(
2475             questRequire[_quesId] == _burnIds.length ||
2476                 ((questRequire[_quesId] == 0 || questRequire[_quesId] == 1) &&
2477                     _burnIds.length == 1),
2478             "quantity is wrong"
2479         );
2480         _setQuest(_quesId);
2481         multiBurn(msg.sender, _burnIds);
2482     }
2483     function hasToken(address _address, uint256[] memory _tokenIds)
2484         public
2485         view
2486         returns (bool)
2487     {
2488         bool has = true;
2489         for (uint256 i = 0; i < _tokenIds.length; i++) {
2490             if (_address != this.tryOwnerOf(_tokenIds[i])) {
2491                 has = false;
2492                 break;
2493             }
2494         }
2495         return has;
2496     }
2497     //multi.burn
2498     function multiBurn(address _address, uint256[] memory _burnIds)
2499         internal
2500         virtual
2501     {
2502         //search from all tonkenid. so spend high gas values.attention.
2503         uint256 countBurn = 0;
2504         for (uint256 i = 0; i < _burnIds.length; i++) {
2505             if (_address == this.tryOwnerOf(_burnIds[i])) {
2506                 _burn(_burnIds[i], true);
2507                 countBurn++;
2508             }
2509         }
2510     }
2511     function _setQuest(uint256 _quesId) internal virtual {
2512         _quests.push(_quesId);
2513         _questsAddress.push(msg.sender);
2514         questHistory[phaseNumQ][_quesId]++;
2515         nowCountQues++;
2516     }
2517     function _getQuest() external view virtual returns (uint256[] memory) {
2518         return _quests;
2519     }
2520     function _getQuestAddress()
2521         external
2522         view
2523         virtual
2524         returns (address[] memory)
2525     {
2526         return _questsAddress;
2527     }
2528     //return wallet owned questIds.
2529     function walletOfQuests(address _address)
2530         external
2531         view
2532         virtual
2533         returns (uint256[] memory)
2534     {
2535         uint256 countindex = 0;
2536         for (uint256 i = 0; i < _questsAddress.length; i++) {
2537             if (_address == _questsAddress[i]) countindex++;
2538         }
2539         uint256[] memory questIds = new uint256[](countindex);
2540         uint256 questIndex = 0;
2541         for (uint256 i = 0; i < _questsAddress.length; i++) {
2542             if (_address == _questsAddress[i])
2543                 questIds[questIndex++] = _quests[i];
2544         }
2545         return questIds;
2546     }
2547     //return wallet owned questIds.
2548     function addressByQuest(uint256 _quesId)
2549         external
2550         view
2551         virtual
2552         returns (address[] memory)
2553     {
2554         uint256 countindex = 0;
2555         for (uint256 i = 0; i < _quests.length; i++) {
2556             if (_quesId == _quests[i]) countindex++;
2557         }
2558         address[] memory addressesOfId = new address[](countindex);
2559         uint256 questIndex = 0;
2560         for (uint256 i = 0; i < _quests.length; i++) {
2561             if (_quesId == _quests[i])
2562                 addressesOfId[questIndex++] = _questsAddress[i];
2563         }
2564         return addressesOfId;
2565     }
2566     /**
2567      * @notice Set the state of the OpenSea operator filter
2568      * @param value Flag indicating if the operator filter should be applied to transfers and approvals
2569      */
2570     function setOperatorFilteringEnabled(bool value) external onlyOperator {
2571         operatorFilteringEnabled = value;
2572     }
2573     function setApprovalForAll(address operator, bool approved)
2574         public
2575         override
2576         onlyAllowedOperatorApproval(operator)
2577     {
2578         super.setApprovalForAll(operator, approved);
2579     }
2580     function approve(address operator, uint256 tokenId)
2581         public
2582         override
2583         onlyAllowedOperatorApproval(operator)
2584     {
2585         super.approve(operator, tokenId);
2586     }
2587     function transferFrom(
2588         address from,
2589         address to,
2590         uint256 tokenId
2591     ) public override onlyAllowedOperator(from) {
2592         super.transferFrom(from, to, tokenId);
2593     }
2594     function safeTransferFrom(
2595         address from,
2596         address to,
2597         uint256 tokenId
2598     ) public override onlyAllowedOperator(from) {
2599         super.safeTransferFrom(from, to, tokenId);
2600     }
2601     function safeTransferFrom(
2602         address from,
2603         address to,
2604         uint256 tokenId,
2605         bytes memory data
2606     ) public override onlyAllowedOperator(from) {
2607         super.safeTransferFrom(from, to, tokenId, data);
2608     }
2609     /**
2610         @dev Operable Role
2611      */
2612     function grantOperatorRole(address _candidate) external onlyOwner {
2613         _grantOperatorRole(_candidate);
2614     }
2615     function revokeOperatorRole(address _candidate) external onlyOwner {
2616         _revokeOperatorRole(_candidate);
2617     }
2618 }
2619 //CODE.BY.FRICKLIK