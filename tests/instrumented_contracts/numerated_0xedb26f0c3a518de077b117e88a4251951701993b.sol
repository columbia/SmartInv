1 /**
2 
3 ██████╗ ██████╗ ███████╗ █████╗ ███╗   ███╗██╗███╗   ██╗
4 ██╔══██╗██╔══██╗██╔════╝██╔══██╗████╗ ████║██║████╗  ██║
5 ██║  ██║██████╔╝█████╗  ███████║██╔████╔██║██║██╔██╗ ██║
6 ██║  ██║██╔══██╗██╔══╝  ██╔══██║██║╚██╔╝██║██║██║╚██╗██║
7 ██████╔╝██║  ██║███████╗██║  ██║██║ ╚═╝ ██║██║██║ ╚████║
8 ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝╚═╝  ╚═══╝
9 
10 ██████╗ ██╗██╗   ██╗███████╗██████╗ ███████╗
11 ██╔══██╗██║██║   ██║██╔════╝██╔══██╗██╔════╝
12 ██║  ██║██║██║   ██║█████╗  ██████╔╝███████╗
13 ██║  ██║██║╚██╗ ██╔╝██╔══╝  ██╔══██╗╚════██║
14 ██████╔╝██║ ╚████╔╝ ███████╗██║  ██║███████║
15 ╚═════╝ ╚═╝  ╚═══╝  ╚══════╝╚═╝  ╚═╝╚══════╝
16 
17 ██████╗ ██████╗  ██████╗      ██╗███████╗ ██████╗████████╗
18 ██╔══██╗██╔══██╗██╔═══██╗     ██║██╔════╝██╔════╝╚══██╔══╝
19 ██████╔╝██████╔╝██║   ██║     ██║█████╗  ██║        ██║
20 ██╔═══╝ ██╔══██╗██║   ██║██   ██║██╔══╝  ██║        ██║
21 ██║     ██║  ██║╚██████╔╝╚█████╔╝███████╗╚██████╗   ██║
22 ╚═╝     ╚═╝  ╚═╝ ╚═════╝  ╚════╝ ╚══════╝ ╚═════╝   ╚═╝
23 
24 */
25 
26 //SPDX-License-Identifier: MIT
27 
28 // File: @openzeppelin/contracts/utils/Address.sol
29 
30 
31 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
32 
33 pragma solidity ^0.8.1;
34 
35 /**
36  * @dev Collection of functions related to the address type
37  */
38 library Address {
39     /**
40      * @dev Returns true if `account` is a contract.
41      *
42      * [IMPORTANT]
43      * ====
44      * It is unsafe to assume that an address for which this function returns
45      * false is an externally-owned account (EOA) and not a contract.
46      *
47      * Among others, `isContract` will return false for the following
48      * types of addresses:
49      *
50      *  - an externally-owned account
51      *  - a contract in construction
52      *  - an address where a contract will be created
53      *  - an address where a contract lived, but was destroyed
54      * ====
55      *
56      * [IMPORTANT]
57      * ====
58      * You shouldn't rely on `isContract` to protect against flash loan attacks!
59      *
60      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
61      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
62      * constructor.
63      * ====
64      */
65     function isContract(address account) internal view returns (bool) {
66         // This method relies on extcodesize/address.code.length, which returns 0
67         // for contracts in construction, since the code is only stored at the end
68         // of the constructor execution.
69 
70         return account.code.length > 0;
71     }
72 
73     /**
74      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
75      * `recipient`, forwarding all available gas and reverting on errors.
76      *
77      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
78      * of certain opcodes, possibly making contracts go over the 2300 gas limit
79      * imposed by `transfer`, making them unable to receive funds via
80      * `transfer`. {sendValue} removes this limitation.
81      *
82      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
83      *
84      * IMPORTANT: because control is transferred to `recipient`, care must be
85      * taken to not create reentrancy vulnerabilities. Consider using
86      * {ReentrancyGuard} or the
87      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
88      */
89     function sendValue(address payable recipient, uint256 amount) internal {
90         require(address(this).balance >= amount, "Address: insufficient balance");
91 
92         (bool success, ) = recipient.call{value: amount}("");
93         require(success, "Address: unable to send value, recipient may have reverted");
94     }
95 
96     /**
97      * @dev Performs a Solidity function call using a low level `call`. A
98      * plain `call` is an unsafe replacement for a function call: use this
99      * function instead.
100      *
101      * If `target` reverts with a revert reason, it is bubbled up by this
102      * function (like regular Solidity function calls).
103      *
104      * Returns the raw returned data. To convert to the expected return value,
105      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
106      *
107      * Requirements:
108      *
109      * - `target` must be a contract.
110      * - calling `target` with `data` must not revert.
111      *
112      * _Available since v3.1._
113      */
114     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
115         return functionCall(target, data, "Address: low-level call failed");
116     }
117 
118     /**
119      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
120      * `errorMessage` as a fallback revert reason when `target` reverts.
121      *
122      * _Available since v3.1._
123      */
124     function functionCall(
125         address target,
126         bytes memory data,
127         string memory errorMessage
128     ) internal returns (bytes memory) {
129         return functionCallWithValue(target, data, 0, errorMessage);
130     }
131 
132     /**
133      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
134      * but also transferring `value` wei to `target`.
135      *
136      * Requirements:
137      *
138      * - the calling contract must have an ETH balance of at least `value`.
139      * - the called Solidity function must be `payable`.
140      *
141      * _Available since v3.1._
142      */
143     function functionCallWithValue(
144         address target,
145         bytes memory data,
146         uint256 value
147     ) internal returns (bytes memory) {
148         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
149     }
150 
151     /**
152      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
153      * with `errorMessage` as a fallback revert reason when `target` reverts.
154      *
155      * _Available since v3.1._
156      */
157     function functionCallWithValue(
158         address target,
159         bytes memory data,
160         uint256 value,
161         string memory errorMessage
162     ) internal returns (bytes memory) {
163         require(address(this).balance >= value, "Address: insufficient balance for call");
164         require(isContract(target), "Address: call to non-contract");
165 
166         (bool success, bytes memory returndata) = target.call{value: value}(data);
167         return verifyCallResult(success, returndata, errorMessage);
168     }
169 
170     /**
171      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
172      * but performing a static call.
173      *
174      * _Available since v3.3._
175      */
176     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
177         return functionStaticCall(target, data, "Address: low-level static call failed");
178     }
179 
180     /**
181      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
182      * but performing a static call.
183      *
184      * _Available since v3.3._
185      */
186     function functionStaticCall(
187         address target,
188         bytes memory data,
189         string memory errorMessage
190     ) internal view returns (bytes memory) {
191         require(isContract(target), "Address: static call to non-contract");
192 
193         (bool success, bytes memory returndata) = target.staticcall(data);
194         return verifyCallResult(success, returndata, errorMessage);
195     }
196 
197     /**
198      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
199      * but performing a delegate call.
200      *
201      * _Available since v3.4._
202      */
203     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
204         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
205     }
206 
207     /**
208      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
209      * but performing a delegate call.
210      *
211      * _Available since v3.4._
212      */
213     function functionDelegateCall(
214         address target,
215         bytes memory data,
216         string memory errorMessage
217     ) internal returns (bytes memory) {
218         require(isContract(target), "Address: delegate call to non-contract");
219 
220         (bool success, bytes memory returndata) = target.delegatecall(data);
221         return verifyCallResult(success, returndata, errorMessage);
222     }
223 
224     /**
225      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
226      * revert reason using the provided one.
227      *
228      * _Available since v4.3._
229      */
230     function verifyCallResult(
231         bool success,
232         bytes memory returndata,
233         string memory errorMessage
234     ) internal pure returns (bytes memory) {
235         if (success) {
236             return returndata;
237         } else {
238             // Look for revert reason and bubble it up if present
239             if (returndata.length > 0) {
240                 // The easiest way to bubble the revert reason is using memory via assembly
241                 /// @solidity memory-safe-assembly
242                 assembly {
243                     let returndata_size := mload(returndata)
244                     revert(add(32, returndata), returndata_size)
245                 }
246             } else {
247                 revert(errorMessage);
248             }
249         }
250     }
251 }
252 
253 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
254 
255 
256 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
257 
258 pragma solidity ^0.8.0;
259 
260 /**
261  * @title ERC721 token receiver interface
262  * @dev Interface for any contract that wants to support safeTransfers
263  * from ERC721 asset contracts.
264  */
265 interface IERC721Receiver {
266     /**
267      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
268      * by `operator` from `from`, this function is called.
269      *
270      * It must return its Solidity selector to confirm the token transfer.
271      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
272      *
273      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
274      */
275     function onERC721Received(
276         address operator,
277         address from,
278         uint256 tokenId,
279         bytes calldata data
280     ) external returns (bytes4);
281 }
282 
283 // File: contracts/MerkleProof.sol
284 
285 pragma solidity ^0.8.7;
286 
287 abstract contract MerkleProof {
288     bytes32 internal _merkleRoot;
289     function _setMerkleRoot(bytes32 merkleRoot_) internal virtual {
290         _merkleRoot = merkleRoot_;
291     }
292     function isWhitelisted(address address_, bytes32[] memory proof_) public view returns (bool) {
293         bytes32 _leaf = keccak256(abi.encodePacked(address_));
294         for (uint256 i = 0; i < proof_.length; i++) {
295             _leaf = _leaf < proof_[i] ? keccak256(abi.encodePacked(_leaf, proof_[i])) : keccak256(abi.encodePacked(proof_[i], _leaf));
296         }
297         return _leaf == _merkleRoot;
298     }
299 }
300 // File: @openzeppelin/contracts/utils/Strings.sol
301 
302 
303 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
304 
305 pragma solidity ^0.8.0;
306 
307 /**
308  * @dev String operations.
309  */
310 library Strings {
311     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
312     uint8 private constant _ADDRESS_LENGTH = 20;
313 
314     /**
315      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
316      */
317     function toString(uint256 value) internal pure returns (string memory) {
318         // Inspired by OraclizeAPI's implementation - MIT licence
319         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
320 
321         if (value == 0) {
322             return "0";
323         }
324         uint256 temp = value;
325         uint256 digits;
326         while (temp != 0) {
327             digits++;
328             temp /= 10;
329         }
330         bytes memory buffer = new bytes(digits);
331         while (value != 0) {
332             digits -= 1;
333             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
334             value /= 10;
335         }
336         return string(buffer);
337     }
338 
339     /**
340      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
341      */
342     function toHexString(uint256 value) internal pure returns (string memory) {
343         if (value == 0) {
344             return "0x00";
345         }
346         uint256 temp = value;
347         uint256 length = 0;
348         while (temp != 0) {
349             length++;
350             temp >>= 8;
351         }
352         return toHexString(value, length);
353     }
354 
355     /**
356      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
357      */
358     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
359         bytes memory buffer = new bytes(2 * length + 2);
360         buffer[0] = "0";
361         buffer[1] = "x";
362         for (uint256 i = 2 * length + 1; i > 1; --i) {
363             buffer[i] = _HEX_SYMBOLS[value & 0xf];
364             value >>= 4;
365         }
366         require(value == 0, "Strings: hex length insufficient");
367         return string(buffer);
368     }
369 
370     /**
371      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
372      */
373     function toHexString(address addr) internal pure returns (string memory) {
374         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
375     }
376 }
377 
378 // File: @openzeppelin/contracts/utils/Base64.sol
379 
380 
381 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Base64.sol)
382 
383 pragma solidity ^0.8.0;
384 
385 /**
386  * @dev Provides a set of functions to operate with Base64 strings.
387  *
388  * _Available since v4.5._
389  */
390 library Base64 {
391     /**
392      * @dev Base64 Encoding/Decoding Table
393      */
394     string internal constant _TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
395 
396     /**
397      * @dev Converts a `bytes` to its Bytes64 `string` representation.
398      */
399     function encode(bytes memory data) internal pure returns (string memory) {
400         /**
401          * Inspired by Brecht Devos (Brechtpd) implementation - MIT licence
402          * https://github.com/Brechtpd/base64/blob/e78d9fd951e7b0977ddca77d92dc85183770daf4/base64.sol
403          */
404         if (data.length == 0) return "";
405 
406         // Loads the table into memory
407         string memory table = _TABLE;
408 
409         // Encoding takes 3 bytes chunks of binary data from `bytes` data parameter
410         // and split into 4 numbers of 6 bits.
411         // The final Base64 length should be `bytes` data length multiplied by 4/3 rounded up
412         // - `data.length + 2`  -> Round up
413         // - `/ 3`              -> Number of 3-bytes chunks
414         // - `4 *`              -> 4 characters for each chunk
415         string memory result = new string(4 * ((data.length + 2) / 3));
416 
417         /// @solidity memory-safe-assembly
418         assembly {
419             // Prepare the lookup table (skip the first "length" byte)
420             let tablePtr := add(table, 1)
421 
422             // Prepare result pointer, jump over length
423             let resultPtr := add(result, 32)
424 
425             // Run over the input, 3 bytes at a time
426             for {
427                 let dataPtr := data
428                 let endPtr := add(data, mload(data))
429             } lt(dataPtr, endPtr) {
430 
431             } {
432                 // Advance 3 bytes
433                 dataPtr := add(dataPtr, 3)
434                 let input := mload(dataPtr)
435 
436                 // To write each character, shift the 3 bytes (18 bits) chunk
437                 // 4 times in blocks of 6 bits for each character (18, 12, 6, 0)
438                 // and apply logical AND with 0x3F which is the number of
439                 // the previous character in the ASCII table prior to the Base64 Table
440                 // The result is then added to the table to get the character to write,
441                 // and finally write it in the result pointer but with a left shift
442                 // of 256 (1 byte) - 8 (1 ASCII char) = 248 bits
443 
444                 mstore8(resultPtr, mload(add(tablePtr, and(shr(18, input), 0x3F))))
445                 resultPtr := add(resultPtr, 1) // Advance
446 
447                 mstore8(resultPtr, mload(add(tablePtr, and(shr(12, input), 0x3F))))
448                 resultPtr := add(resultPtr, 1) // Advance
449 
450                 mstore8(resultPtr, mload(add(tablePtr, and(shr(6, input), 0x3F))))
451                 resultPtr := add(resultPtr, 1) // Advance
452 
453                 mstore8(resultPtr, mload(add(tablePtr, and(input, 0x3F))))
454                 resultPtr := add(resultPtr, 1) // Advance
455             }
456 
457             // When data `bytes` is not exactly 3 bytes long
458             // it is padded with `=` characters at the end
459             switch mod(mload(data), 3)
460             case 1 {
461                 mstore8(sub(resultPtr, 1), 0x3d)
462                 mstore8(sub(resultPtr, 2), 0x3d)
463             }
464             case 2 {
465                 mstore8(sub(resultPtr, 1), 0x3d)
466             }
467         }
468 
469         return result;
470     }
471 }
472 
473 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
474 
475 
476 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
477 
478 pragma solidity ^0.8.0;
479 
480 /**
481  * @dev Interface of the ERC165 standard, as defined in the
482  * https://eips.ethereum.org/EIPS/eip-165[EIP].
483  *
484  * Implementers can declare support of contract interfaces, which can then be
485  * queried by others ({ERC165Checker}).
486  *
487  * For an implementation, see {ERC165}.
488  */
489 interface IERC165 {
490     /**
491      * @dev Returns true if this contract implements the interface defined by
492      * `interfaceId`. See the corresponding
493      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
494      * to learn more about how these ids are created.
495      *
496      * This function call must use less than 30 000 gas.
497      */
498     function supportsInterface(bytes4 interfaceId) external view returns (bool);
499 }
500 
501 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
502 
503 
504 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
505 
506 pragma solidity ^0.8.0;
507 
508 
509 /**
510  * @dev Required interface of an ERC721 compliant contract.
511  */
512 interface IERC721 is IERC165 {
513     /**
514      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
515      */
516     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
517 
518     /**
519      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
520      */
521     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
522 
523     /**
524      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
525      */
526     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
527 
528     /**
529      * @dev Returns the number of tokens in ``owner``'s account.
530      */
531     function balanceOf(address owner) external view returns (uint256 balance);
532 
533     /**
534      * @dev Returns the owner of the `tokenId` token.
535      *
536      * Requirements:
537      *
538      * - `tokenId` must exist.
539      */
540     function ownerOf(uint256 tokenId) external view returns (address owner);
541 
542     /**
543      * @dev Safely transfers `tokenId` token from `from` to `to`.
544      *
545      * Requirements:
546      *
547      * - `from` cannot be the zero address.
548      * - `to` cannot be the zero address.
549      * - `tokenId` token must exist and be owned by `from`.
550      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
551      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
552      *
553      * Emits a {Transfer} event.
554      */
555     function safeTransferFrom(
556         address from,
557         address to,
558         uint256 tokenId,
559         bytes calldata data
560     ) external;
561 
562     /**
563      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
564      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
565      *
566      * Requirements:
567      *
568      * - `from` cannot be the zero address.
569      * - `to` cannot be the zero address.
570      * - `tokenId` token must exist and be owned by `from`.
571      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
572      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
573      *
574      * Emits a {Transfer} event.
575      */
576     function safeTransferFrom(
577         address from,
578         address to,
579         uint256 tokenId
580     ) external;
581 
582     /**
583      * @dev Transfers `tokenId` token from `from` to `to`.
584      *
585      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
586      *
587      * Requirements:
588      *
589      * - `from` cannot be the zero address.
590      * - `to` cannot be the zero address.
591      * - `tokenId` token must be owned by `from`.
592      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
593      *
594      * Emits a {Transfer} event.
595      */
596     function transferFrom(
597         address from,
598         address to,
599         uint256 tokenId
600     ) external;
601 
602     /**
603      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
604      * The approval is cleared when the token is transferred.
605      *
606      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
607      *
608      * Requirements:
609      *
610      * - The caller must own the token or be an approved operator.
611      * - `tokenId` must exist.
612      *
613      * Emits an {Approval} event.
614      */
615     function approve(address to, uint256 tokenId) external;
616 
617     /**
618      * @dev Approve or remove `operator` as an operator for the caller.
619      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
620      *
621      * Requirements:
622      *
623      * - The `operator` cannot be the caller.
624      *
625      * Emits an {ApprovalForAll} event.
626      */
627     function setApprovalForAll(address operator, bool _approved) external;
628 
629     /**
630      * @dev Returns the account approved for `tokenId` token.
631      *
632      * Requirements:
633      *
634      * - `tokenId` must exist.
635      */
636     function getApproved(uint256 tokenId) external view returns (address operator);
637 
638     /**
639      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
640      *
641      * See {setApprovalForAll}
642      */
643     function isApprovedForAll(address owner, address operator) external view returns (bool);
644 }
645 
646 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
647 
648 
649 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
650 
651 pragma solidity ^0.8.0;
652 
653 
654 /**
655  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
656  * @dev See https://eips.ethereum.org/EIPS/eip-721
657  */
658 interface IERC721Metadata is IERC721 {
659     /**
660      * @dev Returns the token collection name.
661      */
662     function name() external view returns (string memory);
663 
664     /**
665      * @dev Returns the token collection symbol.
666      */
667     function symbol() external view returns (string memory);
668 
669     /**
670      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
671      */
672     function tokenURI(uint256 tokenId) external view returns (string memory);
673 }
674 
675 // File: contracts/erc721a/IERC721A.sol
676 
677 
678 // ERC721A Contracts v3.3.0
679 // Creator: Chiru Labs
680 
681 pragma solidity ^0.8.4;
682 
683 
684 
685 /**
686  * @dev Interface of an ERC721A compliant contract.
687  */
688 interface IERC721A is IERC721, IERC721Metadata {
689     /**
690      * The caller must own the token or be an approved operator.
691      */
692     error ApprovalCallerNotOwnerNorApproved();
693 
694     /**
695      * The token does not exist.
696      */
697     error ApprovalQueryForNonexistentToken();
698 
699     /**
700      * The caller cannot approve to their own address.
701      */
702     error ApproveToCaller();
703 
704     /**
705      * The caller cannot approve to the current owner.
706      */
707     error ApprovalToCurrentOwner();
708 
709     /**
710      * Cannot query the balance for the zero address.
711      */
712     error BalanceQueryForZeroAddress();
713 
714     /**
715      * Cannot mint to the zero address.
716      */
717     error MintToZeroAddress();
718 
719     /**
720      * The quantity of tokens minted must be more than zero.
721      */
722     error MintZeroQuantity();
723 
724     /**
725      * The token does not exist.
726      */
727     error OwnerQueryForNonexistentToken();
728 
729     /**
730      * The caller must own the token or be an approved operator.
731      */
732     error TransferCallerNotOwnerNorApproved();
733 
734     /**
735      * The token must be owned by `from`.
736      */
737     error TransferFromIncorrectOwner();
738 
739     /**
740      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
741      */
742     error TransferToNonERC721ReceiverImplementer();
743 
744     /**
745      * Cannot transfer to the zero address.
746      */
747     error TransferToZeroAddress();
748 
749     /**
750      * The token does not exist.
751      */
752     error URIQueryForNonexistentToken();
753 
754     // Compiler will pack this into a single 256bit word.
755     struct TokenOwnership {
756         // The address of the owner.
757         address addr;
758         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
759         uint64 startTimestamp;
760         // Whether the token has been burned.
761         bool burned;
762     }
763 
764     // Compiler will pack this into a single 256bit word.
765     struct AddressData {
766         // Realistically, 2**64-1 is more than enough.
767         uint64 balance;
768         // Keeps track of mint count with minimal overhead for tokenomics.
769         uint64 numberMinted;
770         // Keeps track of burn count with minimal overhead for tokenomics.
771         uint64 numberBurned;
772         // For miscellaneous variable(s) pertaining to the address
773         // (e.g. number of whitelist mint slots used).
774         // If there are multiple variables, please pack them into a uint64.
775         uint64 aux;
776     }
777 
778     /**
779      * @dev Returns the total amount of tokens stored by the contract.
780      * 
781      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
782      */
783     function totalSupply() external view returns (uint256);
784 }
785 
786 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
787 
788 
789 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
790 
791 pragma solidity ^0.8.0;
792 
793 
794 /**
795  * @dev Implementation of the {IERC165} interface.
796  *
797  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
798  * for the additional interface id that will be supported. For example:
799  *
800  * ```solidity
801  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
802  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
803  * }
804  * ```
805  *
806  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
807  */
808 abstract contract ERC165 is IERC165 {
809     /**
810      * @dev See {IERC165-supportsInterface}.
811      */
812     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
813         return interfaceId == type(IERC165).interfaceId;
814     }
815 }
816 
817 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
818 
819 
820 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
821 
822 pragma solidity ^0.8.0;
823 
824 
825 /**
826  * @dev Interface for the NFT Royalty Standard.
827  *
828  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
829  * support for royalty payments across all NFT marketplaces and ecosystem participants.
830  *
831  * _Available since v4.5._
832  */
833 interface IERC2981 is IERC165 {
834     /**
835      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
836      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
837      */
838     function royaltyInfo(uint256 tokenId, uint256 salePrice)
839         external
840         view
841         returns (address receiver, uint256 royaltyAmount);
842 }
843 
844 // File: @openzeppelin/contracts/token/common/ERC2981.sol
845 
846 
847 // OpenZeppelin Contracts (last updated v4.7.0) (token/common/ERC2981.sol)
848 
849 pragma solidity ^0.8.0;
850 
851 
852 
853 /**
854  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
855  *
856  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
857  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
858  *
859  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
860  * fee is specified in basis points by default.
861  *
862  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
863  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
864  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
865  *
866  * _Available since v4.5._
867  */
868 abstract contract ERC2981 is IERC2981, ERC165 {
869     struct RoyaltyInfo {
870         address receiver;
871         uint96 royaltyFraction;
872     }
873 
874     RoyaltyInfo private _defaultRoyaltyInfo;
875     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
876 
877     /**
878      * @dev See {IERC165-supportsInterface}.
879      */
880     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
881         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
882     }
883 
884     /**
885      * @inheritdoc IERC2981
886      */
887     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
888         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
889 
890         if (royalty.receiver == address(0)) {
891             royalty = _defaultRoyaltyInfo;
892         }
893 
894         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
895 
896         return (royalty.receiver, royaltyAmount);
897     }
898 
899     /**
900      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
901      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
902      * override.
903      */
904     function _feeDenominator() internal pure virtual returns (uint96) {
905         return 10000;
906     }
907 
908     /**
909      * @dev Sets the royalty information that all ids in this contract will default to.
910      *
911      * Requirements:
912      *
913      * - `receiver` cannot be the zero address.
914      * - `feeNumerator` cannot be greater than the fee denominator.
915      */
916     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
917         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
918         require(receiver != address(0), "ERC2981: invalid receiver");
919 
920         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
921     }
922 
923     /**
924      * @dev Removes default royalty information.
925      */
926     function _deleteDefaultRoyalty() internal virtual {
927         delete _defaultRoyaltyInfo;
928     }
929 
930     /**
931      * @dev Sets the royalty information for a specific token id, overriding the global default.
932      *
933      * Requirements:
934      *
935      * - `receiver` cannot be the zero address.
936      * - `feeNumerator` cannot be greater than the fee denominator.
937      */
938     function _setTokenRoyalty(
939         uint256 tokenId,
940         address receiver,
941         uint96 feeNumerator
942     ) internal virtual {
943         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
944         require(receiver != address(0), "ERC2981: Invalid parameters");
945 
946         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
947     }
948 
949     /**
950      * @dev Resets royalty information for the token id back to the global default.
951      */
952     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
953         delete _tokenRoyaltyInfo[tokenId];
954     }
955 }
956 
957 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
958 
959 
960 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
961 
962 pragma solidity ^0.8.0;
963 
964 /**
965  * @dev Contract module that helps prevent reentrant calls to a function.
966  *
967  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
968  * available, which can be applied to functions to make sure there are no nested
969  * (reentrant) calls to them.
970  *
971  * Note that because there is a single `nonReentrant` guard, functions marked as
972  * `nonReentrant` may not call one another. This can be worked around by making
973  * those functions `private`, and then adding `external` `nonReentrant` entry
974  * points to them.
975  *
976  * TIP: If you would like to learn more about reentrancy and alternative ways
977  * to protect against it, check out our blog post
978  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
979  */
980 abstract contract ReentrancyGuard {
981     // Booleans are more expensive than uint256 or any type that takes up a full
982     // word because each write operation emits an extra SLOAD to first read the
983     // slot's contents, replace the bits taken up by the boolean, and then write
984     // back. This is the compiler's defense against contract upgrades and
985     // pointer aliasing, and it cannot be disabled.
986 
987     // The values being non-zero value makes deployment a bit more expensive,
988     // but in exchange the refund on every call to nonReentrant will be lower in
989     // amount. Since refunds are capped to a percentage of the total
990     // transaction's gas, it is best to keep them low in cases like this one, to
991     // increase the likelihood of the full refund coming into effect.
992     uint256 private constant _NOT_ENTERED = 1;
993     uint256 private constant _ENTERED = 2;
994 
995     uint256 private _status;
996 
997     constructor() {
998         _status = _NOT_ENTERED;
999     }
1000 
1001     /**
1002      * @dev Prevents a contract from calling itself, directly or indirectly.
1003      * Calling a `nonReentrant` function from another `nonReentrant`
1004      * function is not supported. It is possible to prevent this from happening
1005      * by making the `nonReentrant` function external, and making it call a
1006      * `private` function that does the actual work.
1007      */
1008     modifier nonReentrant() {
1009         // On the first call to nonReentrant, _notEntered will be true
1010         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1011 
1012         // Any calls to nonReentrant after this point will fail
1013         _status = _ENTERED;
1014 
1015         _;
1016 
1017         // By storing the original value once again, a refund is triggered (see
1018         // https://eips.ethereum.org/EIPS/eip-2200)
1019         _status = _NOT_ENTERED;
1020     }
1021 }
1022 
1023 // File: @openzeppelin/contracts/utils/Context.sol
1024 
1025 
1026 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1027 
1028 pragma solidity ^0.8.0;
1029 
1030 /**
1031  * @dev Provides information about the current execution context, including the
1032  * sender of the transaction and its data. While these are generally available
1033  * via msg.sender and msg.data, they should not be accessed in such a direct
1034  * manner, since when dealing with meta-transactions the account sending and
1035  * paying for execution may not be the actual sender (as far as an application
1036  * is concerned).
1037  *
1038  * This contract is only required for intermediate, library-like contracts.
1039  */
1040 abstract contract Context {
1041     function _msgSender() internal view virtual returns (address) {
1042         return msg.sender;
1043     }
1044 
1045     function _msgData() internal view virtual returns (bytes calldata) {
1046         return msg.data;
1047     }
1048 }
1049 
1050 // File: contracts/erc721a/ERC721A.sol
1051 
1052 
1053 // ERC721A Contracts v3.3.0
1054 // Creator: Chiru Labs
1055 
1056 pragma solidity ^0.8.4;
1057 
1058 
1059 
1060 
1061 
1062 
1063 
1064 /**
1065  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1066  * the Metadata extension. Built to optimize for lower gas during batch mints.
1067  *
1068  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1069  *
1070  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1071  *
1072  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
1073  */
1074 contract ERC721A is Context, ERC165, IERC721A {
1075     using Address for address;
1076     using Strings for uint256;
1077 
1078     // The tokenId of the next token to be minted.
1079     uint256 internal _currentIndex;
1080 
1081     // The number of tokens burned.
1082     uint256 internal _burnCounter;
1083 
1084     // Token name
1085     string private _name;
1086 
1087     // Token symbol
1088     string private _symbol;
1089 
1090     // Mapping from token ID to ownership details
1091     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
1092     mapping(uint256 => TokenOwnership) internal _ownerships;
1093 
1094     // Mapping owner address to address data
1095     mapping(address => AddressData) private _addressData;
1096 
1097     // Mapping from token ID to approved address
1098     mapping(uint256 => address) private _tokenApprovals;
1099 
1100     // Mapping from owner to operator approvals
1101     mapping(address => mapping(address => bool)) private _operatorApprovals;
1102 
1103     constructor(string memory name_, string memory symbol_) {
1104         _name = name_;
1105         _symbol = symbol_;
1106         _currentIndex = _startTokenId();
1107     }
1108 
1109     /**
1110      * To change the starting tokenId, please override this function.
1111      */
1112     function _startTokenId() internal view virtual returns (uint256) {
1113         return 0;
1114     }
1115 
1116     /**
1117      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
1118      */
1119     function totalSupply() public view override returns (uint256) {
1120         // Counter underflow is impossible as _burnCounter cannot be incremented
1121         // more than _currentIndex - _startTokenId() times
1122         unchecked {
1123             return _currentIndex - _burnCounter - _startTokenId();
1124         }
1125     }
1126 
1127     /**
1128      * Returns the total amount of tokens minted in the contract.
1129      */
1130     function _totalMinted() internal view returns (uint256) {
1131         // Counter underflow is impossible as _currentIndex does not decrement,
1132         // and it is initialized to _startTokenId()
1133         unchecked {
1134             return _currentIndex - _startTokenId();
1135         }
1136     }
1137 
1138     /**
1139      * @dev See {IERC165-supportsInterface}.
1140      */
1141     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1142         return
1143             interfaceId == type(IERC721).interfaceId ||
1144             interfaceId == type(IERC721Metadata).interfaceId ||
1145             super.supportsInterface(interfaceId);
1146     }
1147 
1148     /**
1149      * @dev See {IERC721-balanceOf}.
1150      */
1151     function balanceOf(address owner) public view override returns (uint256) {
1152         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1153         return uint256(_addressData[owner].balance);
1154     }
1155 
1156     /**
1157      * Returns the number of tokens minted by `owner`.
1158      */
1159     function _numberMinted(address owner) internal view returns (uint256) {
1160         return uint256(_addressData[owner].numberMinted);
1161     }
1162 
1163     /**
1164      * Returns the number of tokens burned by or on behalf of `owner`.
1165      */
1166     function _numberBurned(address owner) internal view returns (uint256) {
1167         return uint256(_addressData[owner].numberBurned);
1168     }
1169 
1170     /**
1171      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1172      */
1173     function _getAux(address owner) internal view returns (uint64) {
1174         return _addressData[owner].aux;
1175     }
1176 
1177     /**
1178      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1179      * If there are multiple variables, please pack them into a uint64.
1180      */
1181     function _setAux(address owner, uint64 aux) internal {
1182         _addressData[owner].aux = aux;
1183     }
1184 
1185     /**
1186      * Gas spent here starts off proportional to the maximum mint batch size.
1187      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1188      */
1189     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1190         uint256 curr = tokenId;
1191 
1192         unchecked {
1193             if (_startTokenId() <= curr) if (curr < _currentIndex) {
1194                 TokenOwnership memory ownership = _ownerships[curr];
1195                 if (!ownership.burned) {
1196                     if (ownership.addr != address(0)) {
1197                         return ownership;
1198                     }
1199                     // Invariant:
1200                     // There will always be an ownership that has an address and is not burned
1201                     // before an ownership that does not have an address and is not burned.
1202                     // Hence, curr will not underflow.
1203                     while (true) {
1204                         curr--;
1205                         ownership = _ownerships[curr];
1206                         if (ownership.addr != address(0)) {
1207                             return ownership;
1208                         }
1209                     }
1210                 }
1211             }
1212         }
1213         revert OwnerQueryForNonexistentToken();
1214     }
1215 
1216     /**
1217      * @dev See {IERC721-ownerOf}.
1218      */
1219     function ownerOf(uint256 tokenId) public view override returns (address) {
1220         return _ownershipOf(tokenId).addr;
1221     }
1222 
1223     /**
1224      * @dev See {IERC721Metadata-name}.
1225      */
1226     function name() public view virtual override returns (string memory) {
1227         return _name;
1228     }
1229 
1230     /**
1231      * @dev See {IERC721Metadata-symbol}.
1232      */
1233     function symbol() public view virtual override returns (string memory) {
1234         return _symbol;
1235     }
1236 
1237     /**
1238      * @dev See {IERC721Metadata-tokenURI}.
1239      */
1240     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1241         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1242 
1243         string memory baseURI = _baseURI();
1244         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1245     }
1246 
1247     /**
1248      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1249      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1250      * by default, can be overriden in child contracts.
1251      */
1252     function _baseURI() internal view virtual returns (string memory) {
1253         return '';
1254     }
1255 
1256     /**
1257      * @dev See {IERC721-approve}.
1258      */
1259     function approve(address to, uint256 tokenId) public override {
1260         address owner = ERC721A.ownerOf(tokenId);
1261         if (to == owner) revert ApprovalToCurrentOwner();
1262 
1263         if (_msgSender() != owner) if(!isApprovedForAll(owner, _msgSender())) {
1264             revert ApprovalCallerNotOwnerNorApproved();
1265         }
1266 
1267         _approve(to, tokenId, owner);
1268     }
1269 
1270     /**
1271      * @dev See {IERC721-getApproved}.
1272      */
1273     function getApproved(uint256 tokenId) public view override returns (address) {
1274         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1275 
1276         return _tokenApprovals[tokenId];
1277     }
1278 
1279     /**
1280      * @dev See {IERC721-setApprovalForAll}.
1281      */
1282     function setApprovalForAll(address operator, bool approved) public virtual override {
1283         if (operator == _msgSender()) revert ApproveToCaller();
1284 
1285         _operatorApprovals[_msgSender()][operator] = approved;
1286         emit ApprovalForAll(_msgSender(), operator, approved);
1287     }
1288 
1289     /**
1290      * @dev See {IERC721-isApprovedForAll}.
1291      */
1292     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1293         return _operatorApprovals[owner][operator];
1294     }
1295 
1296     /**
1297      * @dev See {IERC721-transferFrom}.
1298      */
1299     function transferFrom(
1300         address from,
1301         address to,
1302         uint256 tokenId
1303     ) public virtual override {
1304         _transfer(from, to, tokenId);
1305     }
1306 
1307     /**
1308      * @dev See {IERC721-safeTransferFrom}.
1309      */
1310     function safeTransferFrom(
1311         address from,
1312         address to,
1313         uint256 tokenId
1314     ) public virtual override {
1315         safeTransferFrom(from, to, tokenId, '');
1316     }
1317 
1318     /**
1319      * @dev See {IERC721-safeTransferFrom}.
1320      */
1321     function safeTransferFrom(
1322         address from,
1323         address to,
1324         uint256 tokenId,
1325         bytes memory _data
1326     ) public virtual override {
1327         _transfer(from, to, tokenId);
1328         if (to.isContract()) if(!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1329             revert TransferToNonERC721ReceiverImplementer();
1330         }
1331     }
1332 
1333     /**
1334      * @dev Returns whether `tokenId` exists.
1335      *
1336      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1337      *
1338      * Tokens start existing when they are minted (`_mint`),
1339      */
1340     function _exists(uint256 tokenId) internal view returns (bool) {
1341         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1342     }
1343 
1344     /**
1345      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1346      */
1347     function _safeMint(address to, uint256 quantity) internal {
1348         _safeMint(to, quantity, '');
1349     }
1350 
1351     /**
1352      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1353      *
1354      * Requirements:
1355      *
1356      * - If `to` refers to a smart contract, it must implement
1357      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1358      * - `quantity` must be greater than 0.
1359      *
1360      * Emits a {Transfer} event.
1361      */
1362     function _safeMint(
1363         address to,
1364         uint256 quantity,
1365         bytes memory _data
1366     ) internal {
1367         uint256 startTokenId = _currentIndex;
1368         if (to == address(0)) revert MintToZeroAddress();
1369         if (quantity == 0) revert MintZeroQuantity();
1370 
1371         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1372 
1373         // Overflows are incredibly unrealistic.
1374         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1375         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1376         unchecked {
1377             _addressData[to].balance += uint64(quantity);
1378             _addressData[to].numberMinted += uint64(quantity);
1379 
1380             _ownerships[startTokenId].addr = to;
1381             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1382 
1383             uint256 updatedIndex = startTokenId;
1384             uint256 end = updatedIndex + quantity;
1385 
1386             if (to.isContract()) {
1387                 do {
1388                     emit Transfer(address(0), to, updatedIndex);
1389                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1390                         revert TransferToNonERC721ReceiverImplementer();
1391                     }
1392                 } while (updatedIndex < end);
1393                 // Reentrancy protection
1394                 if (_currentIndex != startTokenId) revert();
1395             } else {
1396                 do {
1397                     emit Transfer(address(0), to, updatedIndex++);
1398                 } while (updatedIndex < end);
1399             }
1400             _currentIndex = updatedIndex;
1401         }
1402         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1403     }
1404 
1405     /**
1406      * @dev Mints `quantity` tokens and transfers them to `to`.
1407      *
1408      * Requirements:
1409      *
1410      * - `to` cannot be the zero address.
1411      * - `quantity` must be greater than 0.
1412      *
1413      * Emits a {Transfer} event.
1414      */
1415     function _mint(address to, uint256 quantity) internal {
1416         uint256 startTokenId = _currentIndex;
1417         if (to == address(0)) revert MintToZeroAddress();
1418         if (quantity == 0) revert MintZeroQuantity();
1419 
1420         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1421 
1422         // Overflows are incredibly unrealistic.
1423         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1424         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1425         unchecked {
1426             _addressData[to].balance += uint64(quantity);
1427             _addressData[to].numberMinted += uint64(quantity);
1428 
1429             _ownerships[startTokenId].addr = to;
1430             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1431 
1432             uint256 updatedIndex = startTokenId;
1433             uint256 end = updatedIndex + quantity;
1434 
1435             do {
1436                 emit Transfer(address(0), to, updatedIndex++);
1437             } while (updatedIndex < end);
1438 
1439             _currentIndex = updatedIndex;
1440         }
1441         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1442     }
1443 
1444     /**
1445      * @dev Transfers `tokenId` from `from` to `to`.
1446      *
1447      * Requirements:
1448      *
1449      * - `to` cannot be the zero address.
1450      * - `tokenId` token must be owned by `from`.
1451      *
1452      * Emits a {Transfer} event.
1453      */
1454     function _transfer(
1455         address from,
1456         address to,
1457         uint256 tokenId
1458     ) private {
1459         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1460 
1461         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1462 
1463         bool isApprovedOrOwner = (_msgSender() == from ||
1464             isApprovedForAll(from, _msgSender()) ||
1465             getApproved(tokenId) == _msgSender());
1466 
1467         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1468         if (to == address(0)) revert TransferToZeroAddress();
1469 
1470         _beforeTokenTransfers(from, to, tokenId, 1);
1471 
1472         // Clear approvals from the previous owner
1473         _approve(address(0), tokenId, from);
1474 
1475         // Underflow of the sender's balance is impossible because we check for
1476         // ownership above and the recipient's balance can't realistically overflow.
1477         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1478         unchecked {
1479             _addressData[from].balance -= 1;
1480             _addressData[to].balance += 1;
1481 
1482             TokenOwnership storage currSlot = _ownerships[tokenId];
1483             currSlot.addr = to;
1484             currSlot.startTimestamp = uint64(block.timestamp);
1485 
1486             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1487             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1488             uint256 nextTokenId = tokenId + 1;
1489             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1490             if (nextSlot.addr == address(0)) {
1491                 // This will suffice for checking _exists(nextTokenId),
1492                 // as a burned slot cannot contain the zero address.
1493                 if (nextTokenId != _currentIndex) {
1494                     nextSlot.addr = from;
1495                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1496                 }
1497             }
1498         }
1499 
1500         emit Transfer(from, to, tokenId);
1501         _afterTokenTransfers(from, to, tokenId, 1);
1502     }
1503 
1504     /**
1505      * @dev Equivalent to `_burn(tokenId, false)`.
1506      */
1507     function _burn(uint256 tokenId) internal virtual {
1508         _burn(tokenId, false);
1509     }
1510 
1511     /**
1512      * @dev Destroys `tokenId`.
1513      * The approval is cleared when the token is burned.
1514      *
1515      * Requirements:
1516      *
1517      * - `tokenId` must exist.
1518      *
1519      * Emits a {Transfer} event.
1520      */
1521     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1522         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1523 
1524         address from = prevOwnership.addr;
1525 
1526         if (approvalCheck) {
1527             bool isApprovedOrOwner = (_msgSender() == from ||
1528                 isApprovedForAll(from, _msgSender()) ||
1529                 getApproved(tokenId) == _msgSender());
1530 
1531             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1532         }
1533 
1534         _beforeTokenTransfers(from, address(0), tokenId, 1);
1535 
1536         // Clear approvals from the previous owner
1537         _approve(address(0), tokenId, from);
1538 
1539         // Underflow of the sender's balance is impossible because we check for
1540         // ownership above and the recipient's balance can't realistically overflow.
1541         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1542         unchecked {
1543             AddressData storage addressData = _addressData[from];
1544             addressData.balance -= 1;
1545             addressData.numberBurned += 1;
1546 
1547             // Keep track of who burned the token, and the timestamp of burning.
1548             TokenOwnership storage currSlot = _ownerships[tokenId];
1549             currSlot.addr = from;
1550             currSlot.startTimestamp = uint64(block.timestamp);
1551             currSlot.burned = true;
1552 
1553             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1554             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1555             uint256 nextTokenId = tokenId + 1;
1556             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1557             if (nextSlot.addr == address(0)) {
1558                 // This will suffice for checking _exists(nextTokenId),
1559                 // as a burned slot cannot contain the zero address.
1560                 if (nextTokenId != _currentIndex) {
1561                     nextSlot.addr = from;
1562                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1563                 }
1564             }
1565         }
1566 
1567         emit Transfer(from, address(0), tokenId);
1568         _afterTokenTransfers(from, address(0), tokenId, 1);
1569 
1570         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1571         unchecked {
1572             _burnCounter++;
1573         }
1574     }
1575 
1576     /**
1577      * @dev Approve `to` to operate on `tokenId`
1578      *
1579      * Emits a {Approval} event.
1580      */
1581     function _approve(
1582         address to,
1583         uint256 tokenId,
1584         address owner
1585     ) private {
1586         _tokenApprovals[tokenId] = to;
1587         emit Approval(owner, to, tokenId);
1588     }
1589 
1590     /**
1591      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1592      *
1593      * @param from address representing the previous owner of the given token ID
1594      * @param to target address that will receive the tokens
1595      * @param tokenId uint256 ID of the token to be transferred
1596      * @param _data bytes optional data to send along with the call
1597      * @return bool whether the call correctly returned the expected magic value
1598      */
1599     function _checkContractOnERC721Received(
1600         address from,
1601         address to,
1602         uint256 tokenId,
1603         bytes memory _data
1604     ) private returns (bool) {
1605         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1606             return retval == IERC721Receiver(to).onERC721Received.selector;
1607         } catch (bytes memory reason) {
1608             if (reason.length == 0) {
1609                 revert TransferToNonERC721ReceiverImplementer();
1610             } else {
1611                 assembly {
1612                     revert(add(32, reason), mload(reason))
1613                 }
1614             }
1615         }
1616     }
1617 
1618     /**
1619      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1620      * And also called before burning one token.
1621      *
1622      * startTokenId - the first token id to be transferred
1623      * quantity - the amount to be transferred
1624      *
1625      * Calling conditions:
1626      *
1627      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1628      * transferred to `to`.
1629      * - When `from` is zero, `tokenId` will be minted for `to`.
1630      * - When `to` is zero, `tokenId` will be burned by `from`.
1631      * - `from` and `to` are never both zero.
1632      */
1633     function _beforeTokenTransfers(
1634         address from,
1635         address to,
1636         uint256 startTokenId,
1637         uint256 quantity
1638     ) internal virtual {}
1639 
1640     /**
1641      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1642      * minting.
1643      * And also called after one token has been burned.
1644      *
1645      * startTokenId - the first token id to be transferred
1646      * quantity - the amount to be transferred
1647      *
1648      * Calling conditions:
1649      *
1650      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1651      * transferred to `to`.
1652      * - When `from` is zero, `tokenId` has been minted for `to`.
1653      * - When `to` is zero, `tokenId` has been burned by `from`.
1654      * - `from` and `to` are never both zero.
1655      */
1656     function _afterTokenTransfers(
1657         address from,
1658         address to,
1659         uint256 startTokenId,
1660         uint256 quantity
1661     ) internal virtual {}
1662 }
1663 
1664 // File: @openzeppelin/contracts/access/Ownable.sol
1665 
1666 
1667 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1668 
1669 pragma solidity ^0.8.0;
1670 
1671 
1672 /**
1673  * @dev Contract module which provides a basic access control mechanism, where
1674  * there is an account (an owner) that can be granted exclusive access to
1675  * specific functions.
1676  *
1677  * By default, the owner account will be the one that deploys the contract. This
1678  * can later be changed with {transferOwnership}.
1679  *
1680  * This module is used through inheritance. It will make available the modifier
1681  * `onlyOwner`, which can be applied to your functions to restrict their use to
1682  * the owner.
1683  */
1684 abstract contract Ownable is Context {
1685     address private _owner;
1686 
1687     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1688 
1689     /**
1690      * @dev Initializes the contract setting the deployer as the initial owner.
1691      */
1692     constructor() {
1693         _transferOwnership(_msgSender());
1694     }
1695 
1696     /**
1697      * @dev Throws if called by any account other than the owner.
1698      */
1699     modifier onlyOwner() {
1700         _checkOwner();
1701         _;
1702     }
1703 
1704     /**
1705      * @dev Returns the address of the current owner.
1706      */
1707     function owner() public view virtual returns (address) {
1708         return _owner;
1709     }
1710 
1711     /**
1712      * @dev Throws if the sender is not the owner.
1713      */
1714     function _checkOwner() internal view virtual {
1715         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1716     }
1717 
1718     /**
1719      * @dev Leaves the contract without owner. It will not be possible to call
1720      * `onlyOwner` functions anymore. Can only be called by the current owner.
1721      *
1722      * NOTE: Renouncing ownership will leave the contract without an owner,
1723      * thereby removing any functionality that is only available to the owner.
1724      */
1725     function renounceOwnership() public virtual onlyOwner {
1726         _transferOwnership(address(0));
1727     }
1728 
1729     /**
1730      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1731      * Can only be called by the current owner.
1732      */
1733     function transferOwnership(address newOwner) public virtual onlyOwner {
1734         require(newOwner != address(0), "Ownable: new owner is the zero address");
1735         _transferOwnership(newOwner);
1736     }
1737 
1738     /**
1739      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1740      * Internal function without access restriction.
1741      */
1742     function _transferOwnership(address newOwner) internal virtual {
1743         address oldOwner = _owner;
1744         _owner = newOwner;
1745         emit OwnershipTransferred(oldOwner, newOwner);
1746     }
1747 }
1748 
1749 // File: contracts/DDPERC721A.sol
1750 
1751 pragma solidity ^0.8.7;
1752 
1753 
1754 
1755 
1756 
1757 
1758 
1759 
1760 contract DDPERC721A is Ownable, ERC721A, ReentrancyGuard, MerkleProof, ERC2981{
1761 
1762   //Project Settings
1763   uint256 public wlMintPrice;//wl.price.
1764   uint256 public psMintPrice;//publicSale. price.
1765   uint256 public maxMintsPerWL;//wl.max mint num per wallet.
1766   uint256 public maxMintsPerPS;//publicSale.max mint num per wallet.
1767   uint256 public maxSupply;//max supply
1768   address payable internal _withdrawWallet;//withdraw wallet
1769 
1770   //URI
1771   string internal _revealUri;
1772   string public _baseExtension = ".json";
1773   string internal _baseTokenURI;
1774   //flags
1775   bool public isWlEnabled;//WL enable.
1776   bool public isPsEnabled;//PublicSale enable.
1777   bool internal _isRevealed;//reveal enable.
1778   //mint records.
1779   mapping(address => uint256) internal  _wlMinted;//wl.mint num by wallet.
1780   mapping(address => uint256) internal _psMinted;//PublicSale.mint num by wallet.
1781 
1782   constructor (
1783       string memory _name,
1784       string memory _symbol
1785   ) ERC721A (_name,_symbol) {
1786   }
1787   //start from 1.djust for bueno.
1788   function _startTokenId() internal view virtual override returns (uint256) {
1789         return 1;
1790   }
1791   //set Default Royalty._feeNumerator 500 = 5% Royalty
1792   function setDefaultRoyalty(address _receiver, uint96 _feeNumerator) external virtual onlyOwner {
1793       _setDefaultRoyalty(_receiver, _feeNumerator);
1794   }
1795   //for ERC2981
1796   function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721A, ERC2981) returns (bool) {
1797     return super.supportsInterface(interfaceId);
1798   }
1799   //for ERC2981 Opensea
1800   function contractURI() external view virtual returns (string memory) {
1801         return _formatContractURI();
1802   }
1803   //make contractURI
1804   function _formatContractURI() internal view returns (string memory) {
1805     (address receiver, uint256 royaltyFraction) = royaltyInfo(0,_feeDenominator());//tokenid=0
1806     return string(
1807       abi.encodePacked(
1808         "data:application/json;base64,",
1809         Base64.encode(
1810           bytes(
1811             abi.encodePacked(
1812                 '{"seller_fee_basis_points":', Strings.toString(royaltyFraction),
1813                 ', "fee_recipient":"', Strings.toHexString(uint256(uint160(receiver)), 20), '"}'
1814             )
1815           )
1816         )
1817       )
1818     );
1819   }
1820   //set owner's wallet.withdraw to this wallet.only owner.
1821   function setWithdrawWallet(address _owner) external virtual onlyOwner {
1822     _withdrawWallet = payable(_owner);
1823   }
1824 
1825   //set maxSupply.only owner.
1826   function setMaxSupply(uint256 _maxSupply) external virtual onlyOwner {
1827     require(totalSupply() <= _maxSupply, "Lower than _currentIndex.");
1828     maxSupply = _maxSupply;
1829   }
1830   //set wl price.only owner.
1831   function setWlPrice(uint256 newPrice) external virtual onlyOwner {
1832     wlMintPrice = newPrice;
1833   }
1834   //set public Sale price.only owner.
1835   function setPsPrice(uint256 newPrice) external virtual onlyOwner {
1836     psMintPrice = newPrice;
1837   }
1838   //set reveal.only owner.
1839   function setReveal(bool bool_) external virtual onlyOwner {
1840     _isRevealed = bool_;
1841   }
1842   //retuen _isRevealed.
1843   function isRevealed() external view virtual returns (bool){
1844     return _isRevealed;
1845   }
1846   //retuen _wlMinted
1847   function wlMinted(address _address) external view virtual returns (uint256){
1848     return _wlMinted[_address];
1849   }
1850   //retuen _psMinted
1851   function psMinted(address _address) external view virtual returns (uint256){
1852     return _psMinted[_address];
1853   }
1854 
1855   //set wl's max mint num.only owner.
1856   function setWlMaxMints(uint256 _max) external virtual onlyOwner {
1857     maxMintsPerWL = _max;
1858   }
1859   //set PublicSale's max mint num.only owner.
1860   function setPsMaxMints(uint256 _max) external virtual onlyOwner {
1861     maxMintsPerPS = _max;
1862   }
1863     
1864   //set WLsale.only owner.
1865   function setWhitelistSale(bool bool_) external virtual onlyOwner {
1866     isWlEnabled = bool_;
1867   }
1868 
1869   //set Publicsale.only owner.
1870   function setPublicSale(bool bool_) external virtual onlyOwner {
1871     isPsEnabled = bool_;
1872   }
1873 
1874   //set MerkleRoot.only owner.
1875   function setMerkleRoot(bytes32 merkleRoot_) external virtual onlyOwner {
1876     _setMerkleRoot(merkleRoot_);
1877   }
1878 
1879   //set HiddenBaseURI.only owner.
1880   function setHiddenBaseURI(string memory uri_) external virtual onlyOwner {
1881     _revealUri = uri_;
1882   }
1883 
1884   //return _currentIndex
1885   function getCurrentIndex() external view virtual returns (uint256){
1886     return _currentIndex;
1887   }
1888 
1889   //set BaseURI at after reveal. only owner.
1890   function setBaseURI(string memory uri_) external virtual onlyOwner {
1891     _baseTokenURI = uri_;
1892   }
1893 
1894   function setBaseExtension(string memory _newBaseExtension) external onlyOwner
1895   {
1896     _baseExtension = _newBaseExtension;
1897   }
1898 
1899   //retuen BaseURI.internal.
1900   function _currentBaseURI() internal view returns (string memory){
1901     return _baseTokenURI;
1902   }
1903 
1904   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1905     require(_exists(_tokenId), "URI query for nonexistent token");
1906     if(_isRevealed == false) {
1907     return _revealUri;
1908     }
1909     return string(abi.encodePacked(_currentBaseURI(), Strings.toString(_tokenId), _baseExtension));
1910   }
1911 
1912   //owner mint.transfer to _address.only owner.
1913   function ownerMint(uint256 _amount, address _address) external virtual onlyOwner { 
1914     require((_amount + totalSupply()) <= (maxSupply), "No more NFTs");
1915 
1916     _safeMint(_address, _amount);
1917   }
1918 
1919   //WL mint.
1920   function whitelistMint(uint256 _amount, bytes32[] memory proof_) external payable virtual nonReentrant {
1921     require(isWlEnabled, "whitelistMint is Paused");
1922     require(isWhitelisted(msg.sender, proof_), "You are not whitelisted!");
1923     require(maxMintsPerWL >= _amount, "whitelistMint: Over max mints per wallet");
1924     require(maxMintsPerWL >= _wlMinted[msg.sender] + _amount, "You have no whitelistMint left");
1925     require(msg.value == wlMintPrice * _amount, "ETH value is not correct");
1926     require((_amount + totalSupply()) <= (maxSupply), "No more NFTs");
1927 
1928     _wlMinted[msg.sender] += _amount;
1929     _safeMint(msg.sender, _amount);
1930   }
1931   
1932   //Public mint.
1933   function publicMint(uint256 _amount) external payable virtual nonReentrant {
1934     require(isPsEnabled, "publicMint is Paused");
1935     require(maxMintsPerPS >= _amount, "publicMint: Over max mints per wallet");
1936     require(maxMintsPerPS >= _psMinted[msg.sender] + _amount, "You have no publicMint left");
1937     require(msg.value == psMintPrice * _amount, "ETH value is not correct");
1938     require((_amount + totalSupply()) <= (maxSupply), "No more NFTs");
1939       
1940     _psMinted[msg.sender] += _amount;
1941     _safeMint(msg.sender, _amount);
1942   }
1943   //burn
1944   function burn(uint256 tokenId) external virtual {
1945     _burn(tokenId, true);
1946   }
1947 
1948   //widraw ETH from this contract.only owner. 
1949   function withdraw() external payable virtual onlyOwner nonReentrant{
1950     // This will payout the owner 100% of the contract balance.
1951     // Do not remove this otherwise you will not be able to withdraw the funds.
1952     // =============================================================================
1953     bool os;
1954     if(_withdrawWallet != address(0)){//if _withdrawWallet has.
1955       (os, ) = payable(_withdrawWallet).call{value: address(this).balance}("");
1956     }else{
1957       (os, ) = payable(owner()).call{value: address(this).balance}("");
1958     }
1959     require(os);
1960     // =============================================================================
1961   }
1962   //return wallet owned tokenids.
1963   function walletOfOwner(address _address) external view virtual returns (uint256[] memory) {
1964     uint256 ownerTokenCount = balanceOf(_address);
1965     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1966     //search from all tonkenid. so spend high gas values.attention.
1967     uint256 tokenindex = 0;
1968     for (uint256 i = _startTokenId(); i < _currentIndex; i++) {
1969       if(_address == this.tryOwnerOf(i)) tokenIds[tokenindex++] = i;
1970     }
1971     return tokenIds;
1972   }
1973   //try catch vaersion ownerOf. I have a error at burned tokenid.so need to try catch.  only external.
1974   function tryOwnerOf(uint256 tokenId) external view  virtual returns (address) {
1975     try this.ownerOf(tokenId) returns (address _address) {
1976       return(_address);
1977     } catch {
1978         return (address(0));//return 0x0 if error.
1979     }
1980   }
1981 }