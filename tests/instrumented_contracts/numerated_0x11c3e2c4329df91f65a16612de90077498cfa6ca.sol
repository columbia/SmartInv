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
24 **/
25 
26 //SPDX-License-Identifier: MIT
27 
28 
29 // File: @openzeppelin/contracts/utils/Address.sol
30 
31 
32 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
33 
34 pragma solidity ^0.8.1;
35 
36 /**
37  * @dev Collection of functions related to the address type
38  */
39 library Address {
40     /**
41      * @dev Returns true if `account` is a contract.
42      *
43      * [IMPORTANT]
44      * ====
45      * It is unsafe to assume that an address for which this function returns
46      * false is an externally-owned account (EOA) and not a contract.
47      *
48      * Among others, `isContract` will return false for the following
49      * types of addresses:
50      *
51      *  - an externally-owned account
52      *  - a contract in construction
53      *  - an address where a contract will be created
54      *  - an address where a contract lived, but was destroyed
55      * ====
56      *
57      * [IMPORTANT]
58      * ====
59      * You shouldn't rely on `isContract` to protect against flash loan attacks!
60      *
61      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
62      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
63      * constructor.
64      * ====
65      */
66     function isContract(address account) internal view returns (bool) {
67         // This method relies on extcodesize/address.code.length, which returns 0
68         // for contracts in construction, since the code is only stored at the end
69         // of the constructor execution.
70 
71         return account.code.length > 0;
72     }
73 
74     /**
75      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
76      * `recipient`, forwarding all available gas and reverting on errors.
77      *
78      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
79      * of certain opcodes, possibly making contracts go over the 2300 gas limit
80      * imposed by `transfer`, making them unable to receive funds via
81      * `transfer`. {sendValue} removes this limitation.
82      *
83      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
84      *
85      * IMPORTANT: because control is transferred to `recipient`, care must be
86      * taken to not create reentrancy vulnerabilities. Consider using
87      * {ReentrancyGuard} or the
88      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
89      */
90     function sendValue(address payable recipient, uint256 amount) internal {
91         require(address(this).balance >= amount, "Address: insufficient balance");
92 
93         (bool success, ) = recipient.call{value: amount}("");
94         require(success, "Address: unable to send value, recipient may have reverted");
95     }
96 
97     /**
98      * @dev Performs a Solidity function call using a low level `call`. A
99      * plain `call` is an unsafe replacement for a function call: use this
100      * function instead.
101      *
102      * If `target` reverts with a revert reason, it is bubbled up by this
103      * function (like regular Solidity function calls).
104      *
105      * Returns the raw returned data. To convert to the expected return value,
106      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
107      *
108      * Requirements:
109      *
110      * - `target` must be a contract.
111      * - calling `target` with `data` must not revert.
112      *
113      * _Available since v3.1._
114      */
115     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
116         return functionCall(target, data, "Address: low-level call failed");
117     }
118 
119     /**
120      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
121      * `errorMessage` as a fallback revert reason when `target` reverts.
122      *
123      * _Available since v3.1._
124      */
125     function functionCall(
126         address target,
127         bytes memory data,
128         string memory errorMessage
129     ) internal returns (bytes memory) {
130         return functionCallWithValue(target, data, 0, errorMessage);
131     }
132 
133     /**
134      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
135      * but also transferring `value` wei to `target`.
136      *
137      * Requirements:
138      *
139      * - the calling contract must have an ETH balance of at least `value`.
140      * - the called Solidity function must be `payable`.
141      *
142      * _Available since v3.1._
143      */
144     function functionCallWithValue(
145         address target,
146         bytes memory data,
147         uint256 value
148     ) internal returns (bytes memory) {
149         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
150     }
151 
152     /**
153      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
154      * with `errorMessage` as a fallback revert reason when `target` reverts.
155      *
156      * _Available since v3.1._
157      */
158     function functionCallWithValue(
159         address target,
160         bytes memory data,
161         uint256 value,
162         string memory errorMessage
163     ) internal returns (bytes memory) {
164         require(address(this).balance >= value, "Address: insufficient balance for call");
165         require(isContract(target), "Address: call to non-contract");
166 
167         (bool success, bytes memory returndata) = target.call{value: value}(data);
168         return verifyCallResult(success, returndata, errorMessage);
169     }
170 
171     /**
172      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
173      * but performing a static call.
174      *
175      * _Available since v3.3._
176      */
177     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
178         return functionStaticCall(target, data, "Address: low-level static call failed");
179     }
180 
181     /**
182      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
183      * but performing a static call.
184      *
185      * _Available since v3.3._
186      */
187     function functionStaticCall(
188         address target,
189         bytes memory data,
190         string memory errorMessage
191     ) internal view returns (bytes memory) {
192         require(isContract(target), "Address: static call to non-contract");
193 
194         (bool success, bytes memory returndata) = target.staticcall(data);
195         return verifyCallResult(success, returndata, errorMessage);
196     }
197 
198     /**
199      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
200      * but performing a delegate call.
201      *
202      * _Available since v3.4._
203      */
204     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
205         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
206     }
207 
208     /**
209      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
210      * but performing a delegate call.
211      *
212      * _Available since v3.4._
213      */
214     function functionDelegateCall(
215         address target,
216         bytes memory data,
217         string memory errorMessage
218     ) internal returns (bytes memory) {
219         require(isContract(target), "Address: delegate call to non-contract");
220 
221         (bool success, bytes memory returndata) = target.delegatecall(data);
222         return verifyCallResult(success, returndata, errorMessage);
223     }
224 
225     /**
226      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
227      * revert reason using the provided one.
228      *
229      * _Available since v4.3._
230      */
231     function verifyCallResult(
232         bool success,
233         bytes memory returndata,
234         string memory errorMessage
235     ) internal pure returns (bytes memory) {
236         if (success) {
237             return returndata;
238         } else {
239             // Look for revert reason and bubble it up if present
240             if (returndata.length > 0) {
241                 // The easiest way to bubble the revert reason is using memory via assembly
242                 /// @solidity memory-safe-assembly
243                 assembly {
244                     let returndata_size := mload(returndata)
245                     revert(add(32, returndata), returndata_size)
246                 }
247             } else {
248                 revert(errorMessage);
249             }
250         }
251     }
252 }
253 
254 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
255 
256 
257 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
258 
259 pragma solidity ^0.8.0;
260 
261 /**
262  * @title ERC721 token receiver interface
263  * @dev Interface for any contract that wants to support safeTransfers
264  * from ERC721 asset contracts.
265  */
266 interface IERC721Receiver {
267     /**
268      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
269      * by `operator` from `from`, this function is called.
270      *
271      * It must return its Solidity selector to confirm the token transfer.
272      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
273      *
274      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
275      */
276     function onERC721Received(
277         address operator,
278         address from,
279         uint256 tokenId,
280         bytes calldata data
281     ) external returns (bytes4);
282 }
283 
284 // File: @openzeppelin/contracts/utils/Strings.sol
285 
286 
287 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
288 
289 pragma solidity ^0.8.0;
290 
291 /**
292  * @dev String operations.
293  */
294 library Strings {
295     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
296     uint8 private constant _ADDRESS_LENGTH = 20;
297 
298     /**
299      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
300      */
301     function toString(uint256 value) internal pure returns (string memory) {
302         // Inspired by OraclizeAPI's implementation - MIT licence
303         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
304 
305         if (value == 0) {
306             return "0";
307         }
308         uint256 temp = value;
309         uint256 digits;
310         while (temp != 0) {
311             digits++;
312             temp /= 10;
313         }
314         bytes memory buffer = new bytes(digits);
315         while (value != 0) {
316             digits -= 1;
317             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
318             value /= 10;
319         }
320         return string(buffer);
321     }
322 
323     /**
324      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
325      */
326     function toHexString(uint256 value) internal pure returns (string memory) {
327         if (value == 0) {
328             return "0x00";
329         }
330         uint256 temp = value;
331         uint256 length = 0;
332         while (temp != 0) {
333             length++;
334             temp >>= 8;
335         }
336         return toHexString(value, length);
337     }
338 
339     /**
340      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
341      */
342     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
343         bytes memory buffer = new bytes(2 * length + 2);
344         buffer[0] = "0";
345         buffer[1] = "x";
346         for (uint256 i = 2 * length + 1; i > 1; --i) {
347             buffer[i] = _HEX_SYMBOLS[value & 0xf];
348             value >>= 4;
349         }
350         require(value == 0, "Strings: hex length insufficient");
351         return string(buffer);
352     }
353 
354     /**
355      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
356      */
357     function toHexString(address addr) internal pure returns (string memory) {
358         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
359     }
360 }
361 
362 // File: contracts/MerkleProof.sol
363 
364 pragma solidity ^0.8.7;
365 
366 
367 abstract contract MerkleProof {
368     bytes32 internal _vipMerkleRoot;
369     bytes32 internal _wlMerkleRoot;
370 
371     // Free Mint
372     function _setVipMerkleRoot(bytes32 merkleRoot_) internal virtual {
373         _vipMerkleRoot = merkleRoot_;
374     }
375 
376     function isValidVipCount(address address_, uint256 vipCount, bytes32[] memory proof_) public view returns (bool) {
377         bytes32 _leaf = keccak256(abi.encodePacked(address_, vipCount));
378         for (uint256 i = 0; i < proof_.length; i++) {
379             _leaf = _leaf < proof_[i] ? keccak256(abi.encodePacked(_leaf, proof_[i])) : keccak256(abi.encodePacked(proof_[i], _leaf));
380         }
381         return _leaf == _vipMerkleRoot;
382     }
383 
384     // WL
385     function _setWlMerkleRoot(bytes32 merkleRoot_) internal virtual {
386         _wlMerkleRoot = merkleRoot_;
387     }
388 
389     function isWhitelisted(address address_, bytes32[] memory proof_) public view returns (bool) {
390         bytes32 _leaf = keccak256(abi.encodePacked(address_));
391         for (uint256 i = 0; i < proof_.length; i++) {
392             _leaf = _leaf < proof_[i] ? keccak256(abi.encodePacked(_leaf, proof_[i])) : keccak256(abi.encodePacked(proof_[i], _leaf));
393         }
394         return _leaf == _wlMerkleRoot;
395     }
396 }
397 // File: @openzeppelin/contracts/utils/Base64.sol
398 
399 
400 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Base64.sol)
401 
402 pragma solidity ^0.8.0;
403 
404 /**
405  * @dev Provides a set of functions to operate with Base64 strings.
406  *
407  * _Available since v4.5._
408  */
409 library Base64 {
410     /**
411      * @dev Base64 Encoding/Decoding Table
412      */
413     string internal constant _TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
414 
415     /**
416      * @dev Converts a `bytes` to its Bytes64 `string` representation.
417      */
418     function encode(bytes memory data) internal pure returns (string memory) {
419         /**
420          * Inspired by Brecht Devos (Brechtpd) implementation - MIT licence
421          * https://github.com/Brechtpd/base64/blob/e78d9fd951e7b0977ddca77d92dc85183770daf4/base64.sol
422          */
423         if (data.length == 0) return "";
424 
425         // Loads the table into memory
426         string memory table = _TABLE;
427 
428         // Encoding takes 3 bytes chunks of binary data from `bytes` data parameter
429         // and split into 4 numbers of 6 bits.
430         // The final Base64 length should be `bytes` data length multiplied by 4/3 rounded up
431         // - `data.length + 2`  -> Round up
432         // - `/ 3`              -> Number of 3-bytes chunks
433         // - `4 *`              -> 4 characters for each chunk
434         string memory result = new string(4 * ((data.length + 2) / 3));
435 
436         /// @solidity memory-safe-assembly
437         assembly {
438             // Prepare the lookup table (skip the first "length" byte)
439             let tablePtr := add(table, 1)
440 
441             // Prepare result pointer, jump over length
442             let resultPtr := add(result, 32)
443 
444             // Run over the input, 3 bytes at a time
445             for {
446                 let dataPtr := data
447                 let endPtr := add(data, mload(data))
448             } lt(dataPtr, endPtr) {
449 
450             } {
451                 // Advance 3 bytes
452                 dataPtr := add(dataPtr, 3)
453                 let input := mload(dataPtr)
454 
455                 // To write each character, shift the 3 bytes (18 bits) chunk
456                 // 4 times in blocks of 6 bits for each character (18, 12, 6, 0)
457                 // and apply logical AND with 0x3F which is the number of
458                 // the previous character in the ASCII table prior to the Base64 Table
459                 // The result is then added to the table to get the character to write,
460                 // and finally write it in the result pointer but with a left shift
461                 // of 256 (1 byte) - 8 (1 ASCII char) = 248 bits
462 
463                 mstore8(resultPtr, mload(add(tablePtr, and(shr(18, input), 0x3F))))
464                 resultPtr := add(resultPtr, 1) // Advance
465 
466                 mstore8(resultPtr, mload(add(tablePtr, and(shr(12, input), 0x3F))))
467                 resultPtr := add(resultPtr, 1) // Advance
468 
469                 mstore8(resultPtr, mload(add(tablePtr, and(shr(6, input), 0x3F))))
470                 resultPtr := add(resultPtr, 1) // Advance
471 
472                 mstore8(resultPtr, mload(add(tablePtr, and(input, 0x3F))))
473                 resultPtr := add(resultPtr, 1) // Advance
474             }
475 
476             // When data `bytes` is not exactly 3 bytes long
477             // it is padded with `=` characters at the end
478             switch mod(mload(data), 3)
479             case 1 {
480                 mstore8(sub(resultPtr, 1), 0x3d)
481                 mstore8(sub(resultPtr, 2), 0x3d)
482             }
483             case 2 {
484                 mstore8(sub(resultPtr, 1), 0x3d)
485             }
486         }
487 
488         return result;
489     }
490 }
491 
492 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
493 
494 
495 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
496 
497 pragma solidity ^0.8.0;
498 
499 /**
500  * @dev Interface of the ERC165 standard, as defined in the
501  * https://eips.ethereum.org/EIPS/eip-165[EIP].
502  *
503  * Implementers can declare support of contract interfaces, which can then be
504  * queried by others ({ERC165Checker}).
505  *
506  * For an implementation, see {ERC165}.
507  */
508 interface IERC165 {
509     /**
510      * @dev Returns true if this contract implements the interface defined by
511      * `interfaceId`. See the corresponding
512      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
513      * to learn more about how these ids are created.
514      *
515      * This function call must use less than 30 000 gas.
516      */
517     function supportsInterface(bytes4 interfaceId) external view returns (bool);
518 }
519 
520 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
521 
522 
523 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
524 
525 pragma solidity ^0.8.0;
526 
527 
528 /**
529  * @dev Required interface of an ERC721 compliant contract.
530  */
531 interface IERC721 is IERC165 {
532     /**
533      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
534      */
535     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
536 
537     /**
538      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
539      */
540     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
541 
542     /**
543      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
544      */
545     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
546 
547     /**
548      * @dev Returns the number of tokens in ``owner``'s account.
549      */
550     function balanceOf(address owner) external view returns (uint256 balance);
551 
552     /**
553      * @dev Returns the owner of the `tokenId` token.
554      *
555      * Requirements:
556      *
557      * - `tokenId` must exist.
558      */
559     function ownerOf(uint256 tokenId) external view returns (address owner);
560 
561     /**
562      * @dev Safely transfers `tokenId` token from `from` to `to`.
563      *
564      * Requirements:
565      *
566      * - `from` cannot be the zero address.
567      * - `to` cannot be the zero address.
568      * - `tokenId` token must exist and be owned by `from`.
569      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
570      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
571      *
572      * Emits a {Transfer} event.
573      */
574     function safeTransferFrom(
575         address from,
576         address to,
577         uint256 tokenId,
578         bytes calldata data
579     ) external;
580 
581     /**
582      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
583      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
584      *
585      * Requirements:
586      *
587      * - `from` cannot be the zero address.
588      * - `to` cannot be the zero address.
589      * - `tokenId` token must exist and be owned by `from`.
590      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
591      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
592      *
593      * Emits a {Transfer} event.
594      */
595     function safeTransferFrom(
596         address from,
597         address to,
598         uint256 tokenId
599     ) external;
600 
601     /**
602      * @dev Transfers `tokenId` token from `from` to `to`.
603      *
604      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
605      *
606      * Requirements:
607      *
608      * - `from` cannot be the zero address.
609      * - `to` cannot be the zero address.
610      * - `tokenId` token must be owned by `from`.
611      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
612      *
613      * Emits a {Transfer} event.
614      */
615     function transferFrom(
616         address from,
617         address to,
618         uint256 tokenId
619     ) external;
620 
621     /**
622      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
623      * The approval is cleared when the token is transferred.
624      *
625      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
626      *
627      * Requirements:
628      *
629      * - The caller must own the token or be an approved operator.
630      * - `tokenId` must exist.
631      *
632      * Emits an {Approval} event.
633      */
634     function approve(address to, uint256 tokenId) external;
635 
636     /**
637      * @dev Approve or remove `operator` as an operator for the caller.
638      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
639      *
640      * Requirements:
641      *
642      * - The `operator` cannot be the caller.
643      *
644      * Emits an {ApprovalForAll} event.
645      */
646     function setApprovalForAll(address operator, bool _approved) external;
647 
648     /**
649      * @dev Returns the account approved for `tokenId` token.
650      *
651      * Requirements:
652      *
653      * - `tokenId` must exist.
654      */
655     function getApproved(uint256 tokenId) external view returns (address operator);
656 
657     /**
658      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
659      *
660      * See {setApprovalForAll}
661      */
662     function isApprovedForAll(address owner, address operator) external view returns (bool);
663 }
664 
665 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
666 
667 
668 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
669 
670 pragma solidity ^0.8.0;
671 
672 
673 /**
674  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
675  * @dev See https://eips.ethereum.org/EIPS/eip-721
676  */
677 interface IERC721Metadata is IERC721 {
678     /**
679      * @dev Returns the token collection name.
680      */
681     function name() external view returns (string memory);
682 
683     /**
684      * @dev Returns the token collection symbol.
685      */
686     function symbol() external view returns (string memory);
687 
688     /**
689      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
690      */
691     function tokenURI(uint256 tokenId) external view returns (string memory);
692 }
693 
694 // File: contracts/erc721a/IERC721A.sol
695 
696 
697 // ERC721A Contracts v3.3.0
698 // Creator: Chiru Labs
699 
700 pragma solidity ^0.8.4;
701 
702 
703 
704 /**
705  * @dev Interface of an ERC721A compliant contract.
706  */
707 interface IERC721A is IERC721, IERC721Metadata {
708     /**
709      * The caller must own the token or be an approved operator.
710      */
711     error ApprovalCallerNotOwnerNorApproved();
712 
713     /**
714      * The token does not exist.
715      */
716     error ApprovalQueryForNonexistentToken();
717 
718     /**
719      * The caller cannot approve to their own address.
720      */
721     error ApproveToCaller();
722 
723     /**
724      * The caller cannot approve to the current owner.
725      */
726     error ApprovalToCurrentOwner();
727 
728     /**
729      * Cannot query the balance for the zero address.
730      */
731     error BalanceQueryForZeroAddress();
732 
733     /**
734      * Cannot mint to the zero address.
735      */
736     error MintToZeroAddress();
737 
738     /**
739      * The quantity of tokens minted must be more than zero.
740      */
741     error MintZeroQuantity();
742 
743     /**
744      * The token does not exist.
745      */
746     error OwnerQueryForNonexistentToken();
747 
748     /**
749      * The caller must own the token or be an approved operator.
750      */
751     error TransferCallerNotOwnerNorApproved();
752 
753     /**
754      * The token must be owned by `from`.
755      */
756     error TransferFromIncorrectOwner();
757 
758     /**
759      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
760      */
761     error TransferToNonERC721ReceiverImplementer();
762 
763     /**
764      * Cannot transfer to the zero address.
765      */
766     error TransferToZeroAddress();
767 
768     /**
769      * The token does not exist.
770      */
771     error URIQueryForNonexistentToken();
772 
773     // Compiler will pack this into a single 256bit word.
774     struct TokenOwnership {
775         // The address of the owner.
776         address addr;
777         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
778         uint64 startTimestamp;
779         // Whether the token has been burned.
780         bool burned;
781     }
782 
783     // Compiler will pack this into a single 256bit word.
784     struct AddressData {
785         // Realistically, 2**64-1 is more than enough.
786         uint64 balance;
787         // Keeps track of mint count with minimal overhead for tokenomics.
788         uint64 numberMinted;
789         // Keeps track of burn count with minimal overhead for tokenomics.
790         uint64 numberBurned;
791         // For miscellaneous variable(s) pertaining to the address
792         // (e.g. number of whitelist mint slots used).
793         // If there are multiple variables, please pack them into a uint64.
794         uint64 aux;
795     }
796 
797     /**
798      * @dev Returns the total amount of tokens stored by the contract.
799      * 
800      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
801      */
802     function totalSupply() external view returns (uint256);
803 }
804 
805 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
806 
807 
808 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
809 
810 pragma solidity ^0.8.0;
811 
812 
813 /**
814  * @dev Implementation of the {IERC165} interface.
815  *
816  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
817  * for the additional interface id that will be supported. For example:
818  *
819  * ```solidity
820  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
821  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
822  * }
823  * ```
824  *
825  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
826  */
827 abstract contract ERC165 is IERC165 {
828     /**
829      * @dev See {IERC165-supportsInterface}.
830      */
831     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
832         return interfaceId == type(IERC165).interfaceId;
833     }
834 }
835 
836 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
837 
838 
839 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
840 
841 pragma solidity ^0.8.0;
842 
843 
844 /**
845  * @dev Interface for the NFT Royalty Standard.
846  *
847  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
848  * support for royalty payments across all NFT marketplaces and ecosystem participants.
849  *
850  * _Available since v4.5._
851  */
852 interface IERC2981 is IERC165 {
853     /**
854      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
855      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
856      */
857     function royaltyInfo(uint256 tokenId, uint256 salePrice)
858         external
859         view
860         returns (address receiver, uint256 royaltyAmount);
861 }
862 
863 // File: @openzeppelin/contracts/token/common/ERC2981.sol
864 
865 
866 // OpenZeppelin Contracts (last updated v4.7.0) (token/common/ERC2981.sol)
867 
868 pragma solidity ^0.8.0;
869 
870 
871 
872 /**
873  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
874  *
875  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
876  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
877  *
878  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
879  * fee is specified in basis points by default.
880  *
881  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
882  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
883  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
884  *
885  * _Available since v4.5._
886  */
887 abstract contract ERC2981 is IERC2981, ERC165 {
888     struct RoyaltyInfo {
889         address receiver;
890         uint96 royaltyFraction;
891     }
892 
893     RoyaltyInfo private _defaultRoyaltyInfo;
894     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
895 
896     /**
897      * @dev See {IERC165-supportsInterface}.
898      */
899     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
900         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
901     }
902 
903     /**
904      * @inheritdoc IERC2981
905      */
906     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
907         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
908 
909         if (royalty.receiver == address(0)) {
910             royalty = _defaultRoyaltyInfo;
911         }
912 
913         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
914 
915         return (royalty.receiver, royaltyAmount);
916     }
917 
918     /**
919      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
920      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
921      * override.
922      */
923     function _feeDenominator() internal pure virtual returns (uint96) {
924         return 10000;
925     }
926 
927     /**
928      * @dev Sets the royalty information that all ids in this contract will default to.
929      *
930      * Requirements:
931      *
932      * - `receiver` cannot be the zero address.
933      * - `feeNumerator` cannot be greater than the fee denominator.
934      */
935     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
936         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
937         require(receiver != address(0), "ERC2981: invalid receiver");
938 
939         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
940     }
941 
942     /**
943      * @dev Removes default royalty information.
944      */
945     function _deleteDefaultRoyalty() internal virtual {
946         delete _defaultRoyaltyInfo;
947     }
948 
949     /**
950      * @dev Sets the royalty information for a specific token id, overriding the global default.
951      *
952      * Requirements:
953      *
954      * - `receiver` cannot be the zero address.
955      * - `feeNumerator` cannot be greater than the fee denominator.
956      */
957     function _setTokenRoyalty(
958         uint256 tokenId,
959         address receiver,
960         uint96 feeNumerator
961     ) internal virtual {
962         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
963         require(receiver != address(0), "ERC2981: Invalid parameters");
964 
965         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
966     }
967 
968     /**
969      * @dev Resets royalty information for the token id back to the global default.
970      */
971     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
972         delete _tokenRoyaltyInfo[tokenId];
973     }
974 }
975 
976 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
977 
978 
979 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
980 
981 pragma solidity ^0.8.0;
982 
983 /**
984  * @dev Contract module that helps prevent reentrant calls to a function.
985  *
986  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
987  * available, which can be applied to functions to make sure there are no nested
988  * (reentrant) calls to them.
989  *
990  * Note that because there is a single `nonReentrant` guard, functions marked as
991  * `nonReentrant` may not call one another. This can be worked around by making
992  * those functions `private`, and then adding `external` `nonReentrant` entry
993  * points to them.
994  *
995  * TIP: If you would like to learn more about reentrancy and alternative ways
996  * to protect against it, check out our blog post
997  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
998  */
999 abstract contract ReentrancyGuard {
1000     // Booleans are more expensive than uint256 or any type that takes up a full
1001     // word because each write operation emits an extra SLOAD to first read the
1002     // slot's contents, replace the bits taken up by the boolean, and then write
1003     // back. This is the compiler's defense against contract upgrades and
1004     // pointer aliasing, and it cannot be disabled.
1005 
1006     // The values being non-zero value makes deployment a bit more expensive,
1007     // but in exchange the refund on every call to nonReentrant will be lower in
1008     // amount. Since refunds are capped to a percentage of the total
1009     // transaction's gas, it is best to keep them low in cases like this one, to
1010     // increase the likelihood of the full refund coming into effect.
1011     uint256 private constant _NOT_ENTERED = 1;
1012     uint256 private constant _ENTERED = 2;
1013 
1014     uint256 private _status;
1015 
1016     constructor() {
1017         _status = _NOT_ENTERED;
1018     }
1019 
1020     /**
1021      * @dev Prevents a contract from calling itself, directly or indirectly.
1022      * Calling a `nonReentrant` function from another `nonReentrant`
1023      * function is not supported. It is possible to prevent this from happening
1024      * by making the `nonReentrant` function external, and making it call a
1025      * `private` function that does the actual work.
1026      */
1027     modifier nonReentrant() {
1028         // On the first call to nonReentrant, _notEntered will be true
1029         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1030 
1031         // Any calls to nonReentrant after this point will fail
1032         _status = _ENTERED;
1033 
1034         _;
1035 
1036         // By storing the original value once again, a refund is triggered (see
1037         // https://eips.ethereum.org/EIPS/eip-2200)
1038         _status = _NOT_ENTERED;
1039     }
1040 }
1041 
1042 // File: @openzeppelin/contracts/utils/Context.sol
1043 
1044 
1045 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1046 
1047 pragma solidity ^0.8.0;
1048 
1049 /**
1050  * @dev Provides information about the current execution context, including the
1051  * sender of the transaction and its data. While these are generally available
1052  * via msg.sender and msg.data, they should not be accessed in such a direct
1053  * manner, since when dealing with meta-transactions the account sending and
1054  * paying for execution may not be the actual sender (as far as an application
1055  * is concerned).
1056  *
1057  * This contract is only required for intermediate, library-like contracts.
1058  */
1059 abstract contract Context {
1060     function _msgSender() internal view virtual returns (address) {
1061         return msg.sender;
1062     }
1063 
1064     function _msgData() internal view virtual returns (bytes calldata) {
1065         return msg.data;
1066     }
1067 }
1068 
1069 // File: contracts/erc721a/ERC721A.sol
1070 
1071 
1072 // ERC721A Contracts v3.3.0
1073 // Creator: Chiru Labs
1074 
1075 pragma solidity ^0.8.4;
1076 
1077 
1078 
1079 
1080 
1081 
1082 
1083 /**
1084  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1085  * the Metadata extension. Built to optimize for lower gas during batch mints.
1086  *
1087  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1088  *
1089  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1090  *
1091  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
1092  */
1093 contract ERC721A is Context, ERC165, IERC721A {
1094     using Address for address;
1095     using Strings for uint256;
1096 
1097     // The tokenId of the next token to be minted.
1098     uint256 internal _currentIndex;
1099 
1100     // The number of tokens burned.
1101     uint256 internal _burnCounter;
1102 
1103     // Token name
1104     string private _name;
1105 
1106     // Token symbol
1107     string private _symbol;
1108 
1109     // Mapping from token ID to ownership details
1110     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
1111     mapping(uint256 => TokenOwnership) internal _ownerships;
1112 
1113     // Mapping owner address to address data
1114     mapping(address => AddressData) private _addressData;
1115 
1116     // Mapping from token ID to approved address
1117     mapping(uint256 => address) private _tokenApprovals;
1118 
1119     // Mapping from owner to operator approvals
1120     mapping(address => mapping(address => bool)) private _operatorApprovals;
1121 
1122     constructor(string memory name_, string memory symbol_) {
1123         _name = name_;
1124         _symbol = symbol_;
1125         _currentIndex = _startTokenId();
1126     }
1127 
1128     /**
1129      * To change the starting tokenId, please override this function.
1130      */
1131     function _startTokenId() internal view virtual returns (uint256) {
1132         return 0;
1133     }
1134 
1135     /**
1136      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
1137      */
1138     function totalSupply() public view override returns (uint256) {
1139         // Counter underflow is impossible as _burnCounter cannot be incremented
1140         // more than _currentIndex - _startTokenId() times
1141         unchecked {
1142             return _currentIndex - _burnCounter - _startTokenId();
1143         }
1144     }
1145 
1146     /**
1147      * Returns the total amount of tokens minted in the contract.
1148      */
1149     function _totalMinted() internal view returns (uint256) {
1150         // Counter underflow is impossible as _currentIndex does not decrement,
1151         // and it is initialized to _startTokenId()
1152         unchecked {
1153             return _currentIndex - _startTokenId();
1154         }
1155     }
1156 
1157     /**
1158      * @dev See {IERC165-supportsInterface}.
1159      */
1160     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1161         return
1162             interfaceId == type(IERC721).interfaceId ||
1163             interfaceId == type(IERC721Metadata).interfaceId ||
1164             super.supportsInterface(interfaceId);
1165     }
1166 
1167     /**
1168      * @dev See {IERC721-balanceOf}.
1169      */
1170     function balanceOf(address owner) public view override returns (uint256) {
1171         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1172         return uint256(_addressData[owner].balance);
1173     }
1174 
1175     /**
1176      * Returns the number of tokens minted by `owner`.
1177      */
1178     function _numberMinted(address owner) internal view returns (uint256) {
1179         return uint256(_addressData[owner].numberMinted);
1180     }
1181 
1182     /**
1183      * Returns the number of tokens burned by or on behalf of `owner`.
1184      */
1185     function _numberBurned(address owner) internal view returns (uint256) {
1186         return uint256(_addressData[owner].numberBurned);
1187     }
1188 
1189     /**
1190      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1191      */
1192     function _getAux(address owner) internal view returns (uint64) {
1193         return _addressData[owner].aux;
1194     }
1195 
1196     /**
1197      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1198      * If there are multiple variables, please pack them into a uint64.
1199      */
1200     function _setAux(address owner, uint64 aux) internal {
1201         _addressData[owner].aux = aux;
1202     }
1203 
1204     /**
1205      * Gas spent here starts off proportional to the maximum mint batch size.
1206      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1207      */
1208     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1209         uint256 curr = tokenId;
1210 
1211         unchecked {
1212             if (_startTokenId() <= curr) if (curr < _currentIndex) {
1213                 TokenOwnership memory ownership = _ownerships[curr];
1214                 if (!ownership.burned) {
1215                     if (ownership.addr != address(0)) {
1216                         return ownership;
1217                     }
1218                     // Invariant:
1219                     // There will always be an ownership that has an address and is not burned
1220                     // before an ownership that does not have an address and is not burned.
1221                     // Hence, curr will not underflow.
1222                     while (true) {
1223                         curr--;
1224                         ownership = _ownerships[curr];
1225                         if (ownership.addr != address(0)) {
1226                             return ownership;
1227                         }
1228                     }
1229                 }
1230             }
1231         }
1232         revert OwnerQueryForNonexistentToken();
1233     }
1234 
1235     /**
1236      * @dev See {IERC721-ownerOf}.
1237      */
1238     function ownerOf(uint256 tokenId) public view override returns (address) {
1239         return _ownershipOf(tokenId).addr;
1240     }
1241 
1242     /**
1243      * @dev See {IERC721Metadata-name}.
1244      */
1245     function name() public view virtual override returns (string memory) {
1246         return _name;
1247     }
1248 
1249     /**
1250      * @dev See {IERC721Metadata-symbol}.
1251      */
1252     function symbol() public view virtual override returns (string memory) {
1253         return _symbol;
1254     }
1255 
1256     /**
1257      * @dev See {IERC721Metadata-tokenURI}.
1258      */
1259     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1260         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1261 
1262         string memory baseURI = _baseURI();
1263         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1264     }
1265 
1266     /**
1267      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1268      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1269      * by default, can be overriden in child contracts.
1270      */
1271     function _baseURI() internal view virtual returns (string memory) {
1272         return '';
1273     }
1274 
1275     /**
1276      * @dev See {IERC721-approve}.
1277      */
1278     function approve(address to, uint256 tokenId) public override {
1279         address owner = ERC721A.ownerOf(tokenId);
1280         if (to == owner) revert ApprovalToCurrentOwner();
1281 
1282         if (_msgSender() != owner) if(!isApprovedForAll(owner, _msgSender())) {
1283             revert ApprovalCallerNotOwnerNorApproved();
1284         }
1285 
1286         _approve(to, tokenId, owner);
1287     }
1288 
1289     /**
1290      * @dev See {IERC721-getApproved}.
1291      */
1292     function getApproved(uint256 tokenId) public view override returns (address) {
1293         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1294 
1295         return _tokenApprovals[tokenId];
1296     }
1297 
1298     /**
1299      * @dev See {IERC721-setApprovalForAll}.
1300      */
1301     function setApprovalForAll(address operator, bool approved) public virtual override {
1302         if (operator == _msgSender()) revert ApproveToCaller();
1303 
1304         _operatorApprovals[_msgSender()][operator] = approved;
1305         emit ApprovalForAll(_msgSender(), operator, approved);
1306     }
1307 
1308     /**
1309      * @dev See {IERC721-isApprovedForAll}.
1310      */
1311     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1312         return _operatorApprovals[owner][operator];
1313     }
1314 
1315     /**
1316      * @dev See {IERC721-transferFrom}.
1317      */
1318     function transferFrom(
1319         address from,
1320         address to,
1321         uint256 tokenId
1322     ) public virtual override {
1323         _transfer(from, to, tokenId);
1324     }
1325 
1326     /**
1327      * @dev See {IERC721-safeTransferFrom}.
1328      */
1329     function safeTransferFrom(
1330         address from,
1331         address to,
1332         uint256 tokenId
1333     ) public virtual override {
1334         safeTransferFrom(from, to, tokenId, '');
1335     }
1336 
1337     /**
1338      * @dev See {IERC721-safeTransferFrom}.
1339      */
1340     function safeTransferFrom(
1341         address from,
1342         address to,
1343         uint256 tokenId,
1344         bytes memory _data
1345     ) public virtual override {
1346         _transfer(from, to, tokenId);
1347         if (to.isContract()) if(!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1348             revert TransferToNonERC721ReceiverImplementer();
1349         }
1350     }
1351 
1352     /**
1353      * @dev Returns whether `tokenId` exists.
1354      *
1355      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1356      *
1357      * Tokens start existing when they are minted (`_mint`),
1358      */
1359     function _exists(uint256 tokenId) internal view returns (bool) {
1360         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1361     }
1362 
1363     /**
1364      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1365      */
1366     function _safeMint(address to, uint256 quantity) internal {
1367         _safeMint(to, quantity, '');
1368     }
1369 
1370     /**
1371      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1372      *
1373      * Requirements:
1374      *
1375      * - If `to` refers to a smart contract, it must implement
1376      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1377      * - `quantity` must be greater than 0.
1378      *
1379      * Emits a {Transfer} event.
1380      */
1381     function _safeMint(
1382         address to,
1383         uint256 quantity,
1384         bytes memory _data
1385     ) internal {
1386         uint256 startTokenId = _currentIndex;
1387         if (to == address(0)) revert MintToZeroAddress();
1388         if (quantity == 0) revert MintZeroQuantity();
1389 
1390         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1391 
1392         // Overflows are incredibly unrealistic.
1393         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1394         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1395         unchecked {
1396             _addressData[to].balance += uint64(quantity);
1397             _addressData[to].numberMinted += uint64(quantity);
1398 
1399             _ownerships[startTokenId].addr = to;
1400             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1401 
1402             uint256 updatedIndex = startTokenId;
1403             uint256 end = updatedIndex + quantity;
1404 
1405             if (to.isContract()) {
1406                 do {
1407                     emit Transfer(address(0), to, updatedIndex);
1408                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1409                         revert TransferToNonERC721ReceiverImplementer();
1410                     }
1411                 } while (updatedIndex < end);
1412                 // Reentrancy protection
1413                 if (_currentIndex != startTokenId) revert();
1414             } else {
1415                 do {
1416                     emit Transfer(address(0), to, updatedIndex++);
1417                 } while (updatedIndex < end);
1418             }
1419             _currentIndex = updatedIndex;
1420         }
1421         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1422     }
1423 
1424     /**
1425      * @dev Mints `quantity` tokens and transfers them to `to`.
1426      *
1427      * Requirements:
1428      *
1429      * - `to` cannot be the zero address.
1430      * - `quantity` must be greater than 0.
1431      *
1432      * Emits a {Transfer} event.
1433      */
1434     function _mint(address to, uint256 quantity) internal {
1435         uint256 startTokenId = _currentIndex;
1436         if (to == address(0)) revert MintToZeroAddress();
1437         if (quantity == 0) revert MintZeroQuantity();
1438 
1439         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1440 
1441         // Overflows are incredibly unrealistic.
1442         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1443         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1444         unchecked {
1445             _addressData[to].balance += uint64(quantity);
1446             _addressData[to].numberMinted += uint64(quantity);
1447 
1448             _ownerships[startTokenId].addr = to;
1449             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1450 
1451             uint256 updatedIndex = startTokenId;
1452             uint256 end = updatedIndex + quantity;
1453 
1454             do {
1455                 emit Transfer(address(0), to, updatedIndex++);
1456             } while (updatedIndex < end);
1457 
1458             _currentIndex = updatedIndex;
1459         }
1460         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1461     }
1462 
1463     /**
1464      * @dev Transfers `tokenId` from `from` to `to`.
1465      *
1466      * Requirements:
1467      *
1468      * - `to` cannot be the zero address.
1469      * - `tokenId` token must be owned by `from`.
1470      *
1471      * Emits a {Transfer} event.
1472      */
1473     function _transfer(
1474         address from,
1475         address to,
1476         uint256 tokenId
1477     ) private {
1478         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1479 
1480         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1481 
1482         bool isApprovedOrOwner = (_msgSender() == from ||
1483             isApprovedForAll(from, _msgSender()) ||
1484             getApproved(tokenId) == _msgSender());
1485 
1486         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1487         if (to == address(0)) revert TransferToZeroAddress();
1488 
1489         _beforeTokenTransfers(from, to, tokenId, 1);
1490 
1491         // Clear approvals from the previous owner
1492         _approve(address(0), tokenId, from);
1493 
1494         // Underflow of the sender's balance is impossible because we check for
1495         // ownership above and the recipient's balance can't realistically overflow.
1496         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1497         unchecked {
1498             _addressData[from].balance -= 1;
1499             _addressData[to].balance += 1;
1500 
1501             TokenOwnership storage currSlot = _ownerships[tokenId];
1502             currSlot.addr = to;
1503             currSlot.startTimestamp = uint64(block.timestamp);
1504 
1505             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1506             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1507             uint256 nextTokenId = tokenId + 1;
1508             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1509             if (nextSlot.addr == address(0)) {
1510                 // This will suffice for checking _exists(nextTokenId),
1511                 // as a burned slot cannot contain the zero address.
1512                 if (nextTokenId != _currentIndex) {
1513                     nextSlot.addr = from;
1514                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1515                 }
1516             }
1517         }
1518 
1519         emit Transfer(from, to, tokenId);
1520         _afterTokenTransfers(from, to, tokenId, 1);
1521     }
1522 
1523     /**
1524      * @dev Equivalent to `_burn(tokenId, false)`.
1525      */
1526     function _burn(uint256 tokenId) internal virtual {
1527         _burn(tokenId, false);
1528     }
1529 
1530     /**
1531      * @dev Destroys `tokenId`.
1532      * The approval is cleared when the token is burned.
1533      *
1534      * Requirements:
1535      *
1536      * - `tokenId` must exist.
1537      *
1538      * Emits a {Transfer} event.
1539      */
1540     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1541         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1542 
1543         address from = prevOwnership.addr;
1544 
1545         if (approvalCheck) {
1546             bool isApprovedOrOwner = (_msgSender() == from ||
1547                 isApprovedForAll(from, _msgSender()) ||
1548                 getApproved(tokenId) == _msgSender());
1549 
1550             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1551         }
1552 
1553         _beforeTokenTransfers(from, address(0), tokenId, 1);
1554 
1555         // Clear approvals from the previous owner
1556         _approve(address(0), tokenId, from);
1557 
1558         // Underflow of the sender's balance is impossible because we check for
1559         // ownership above and the recipient's balance can't realistically overflow.
1560         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1561         unchecked {
1562             AddressData storage addressData = _addressData[from];
1563             addressData.balance -= 1;
1564             addressData.numberBurned += 1;
1565 
1566             // Keep track of who burned the token, and the timestamp of burning.
1567             TokenOwnership storage currSlot = _ownerships[tokenId];
1568             currSlot.addr = from;
1569             currSlot.startTimestamp = uint64(block.timestamp);
1570             currSlot.burned = true;
1571 
1572             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1573             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1574             uint256 nextTokenId = tokenId + 1;
1575             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1576             if (nextSlot.addr == address(0)) {
1577                 // This will suffice for checking _exists(nextTokenId),
1578                 // as a burned slot cannot contain the zero address.
1579                 if (nextTokenId != _currentIndex) {
1580                     nextSlot.addr = from;
1581                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1582                 }
1583             }
1584         }
1585 
1586         emit Transfer(from, address(0), tokenId);
1587         _afterTokenTransfers(from, address(0), tokenId, 1);
1588 
1589         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1590         unchecked {
1591             _burnCounter++;
1592         }
1593     }
1594 
1595     /**
1596      * @dev Approve `to` to operate on `tokenId`
1597      *
1598      * Emits a {Approval} event.
1599      */
1600     function _approve(
1601         address to,
1602         uint256 tokenId,
1603         address owner
1604     ) private {
1605         _tokenApprovals[tokenId] = to;
1606         emit Approval(owner, to, tokenId);
1607     }
1608 
1609     /**
1610      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1611      *
1612      * @param from address representing the previous owner of the given token ID
1613      * @param to target address that will receive the tokens
1614      * @param tokenId uint256 ID of the token to be transferred
1615      * @param _data bytes optional data to send along with the call
1616      * @return bool whether the call correctly returned the expected magic value
1617      */
1618     function _checkContractOnERC721Received(
1619         address from,
1620         address to,
1621         uint256 tokenId,
1622         bytes memory _data
1623     ) private returns (bool) {
1624         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1625             return retval == IERC721Receiver(to).onERC721Received.selector;
1626         } catch (bytes memory reason) {
1627             if (reason.length == 0) {
1628                 revert TransferToNonERC721ReceiverImplementer();
1629             } else {
1630                 assembly {
1631                     revert(add(32, reason), mload(reason))
1632                 }
1633             }
1634         }
1635     }
1636 
1637     /**
1638      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1639      * And also called before burning one token.
1640      *
1641      * startTokenId - the first token id to be transferred
1642      * quantity - the amount to be transferred
1643      *
1644      * Calling conditions:
1645      *
1646      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1647      * transferred to `to`.
1648      * - When `from` is zero, `tokenId` will be minted for `to`.
1649      * - When `to` is zero, `tokenId` will be burned by `from`.
1650      * - `from` and `to` are never both zero.
1651      */
1652     function _beforeTokenTransfers(
1653         address from,
1654         address to,
1655         uint256 startTokenId,
1656         uint256 quantity
1657     ) internal virtual {}
1658 
1659     /**
1660      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1661      * minting.
1662      * And also called after one token has been burned.
1663      *
1664      * startTokenId - the first token id to be transferred
1665      * quantity - the amount to be transferred
1666      *
1667      * Calling conditions:
1668      *
1669      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1670      * transferred to `to`.
1671      * - When `from` is zero, `tokenId` has been minted for `to`.
1672      * - When `to` is zero, `tokenId` has been burned by `from`.
1673      * - `from` and `to` are never both zero.
1674      */
1675     function _afterTokenTransfers(
1676         address from,
1677         address to,
1678         uint256 startTokenId,
1679         uint256 quantity
1680     ) internal virtual {}
1681 }
1682 
1683 // File: @openzeppelin/contracts/access/Ownable.sol
1684 
1685 
1686 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1687 
1688 pragma solidity ^0.8.0;
1689 
1690 
1691 /**
1692  * @dev Contract module which provides a basic access control mechanism, where
1693  * there is an account (an owner) that can be granted exclusive access to
1694  * specific functions.
1695  *
1696  * By default, the owner account will be the one that deploys the contract. This
1697  * can later be changed with {transferOwnership}.
1698  *
1699  * This module is used through inheritance. It will make available the modifier
1700  * `onlyOwner`, which can be applied to your functions to restrict their use to
1701  * the owner.
1702  */
1703 abstract contract Ownable is Context {
1704     address private _owner;
1705 
1706     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1707 
1708     /**
1709      * @dev Initializes the contract setting the deployer as the initial owner.
1710      */
1711     constructor() {
1712         _transferOwnership(_msgSender());
1713     }
1714 
1715     /**
1716      * @dev Throws if called by any account other than the owner.
1717      */
1718     modifier onlyOwner() {
1719         _checkOwner();
1720         _;
1721     }
1722 
1723     /**
1724      * @dev Returns the address of the current owner.
1725      */
1726     function owner() public view virtual returns (address) {
1727         return _owner;
1728     }
1729 
1730     /**
1731      * @dev Throws if the sender is not the owner.
1732      */
1733     function _checkOwner() internal view virtual {
1734         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1735     }
1736 
1737     /**
1738      * @dev Leaves the contract without owner. It will not be possible to call
1739      * `onlyOwner` functions anymore. Can only be called by the current owner.
1740      *
1741      * NOTE: Renouncing ownership will leave the contract without an owner,
1742      * thereby removing any functionality that is only available to the owner.
1743      */
1744     function renounceOwnership() public virtual onlyOwner {
1745         _transferOwnership(address(0));
1746     }
1747 
1748     /**
1749      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1750      * Can only be called by the current owner.
1751      */
1752     function transferOwnership(address newOwner) public virtual onlyOwner {
1753         require(newOwner != address(0), "Ownable: new owner is the zero address");
1754         _transferOwnership(newOwner);
1755     }
1756 
1757     /**
1758      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1759      * Internal function without access restriction.
1760      */
1761     function _transferOwnership(address newOwner) internal virtual {
1762         address oldOwner = _owner;
1763         _owner = newOwner;
1764         emit OwnershipTransferred(oldOwner, newOwner);
1765     }
1766 }
1767 
1768 // File: contracts/DDPERC721A.sol
1769 
1770 pragma solidity ^0.8.7;
1771 
1772 
1773 
1774 
1775 
1776 
1777 
1778 
1779 contract DDPERC721A is Ownable, ERC721A, ReentrancyGuard, MerkleProof, ERC2981{
1780 
1781   //Project Settings
1782   uint256 public vipMintPrice;
1783   uint256 public wlMintPrice;
1784   uint256 public psMintPrice;
1785   uint256 public maxMintsPerVip;
1786   uint256 public maxMintsPerWL;
1787   uint256 public maxMintsPerPS;
1788   uint256 public maxSupply;
1789   address payable internal _withdrawWallet;
1790 
1791   //URI
1792   string[5] internal _revealUris;
1793   string public _baseExtension = ".json";
1794   string internal _baseTokenURI;
1795   //flags
1796   bool public isFreeMintEnabled;
1797   bool public isVipSaleEnabled;
1798   bool public isWlSaleEnabled;
1799   bool public isPablicSaleEnabled;
1800   bool internal _isRevealed;
1801   //mint records.
1802   mapping(address => uint256) internal _freeMinted;
1803   mapping(address => uint256) internal _vipMinted;
1804   mapping(address => uint256) internal _wlMinted;
1805   mapping(address => uint256) internal _psMinted;
1806 
1807   constructor (
1808       string memory _name,
1809       string memory _symbol
1810   ) ERC721A (_name,_symbol) {
1811   }
1812   //start from 1.djust for bueno.
1813   function _startTokenId() internal view virtual override returns (uint256) {
1814         return 1;
1815   }
1816   //set Default Royalty._feeNumerator 500 = 5% Royalty
1817   function setDefaultRoyalty(address _receiver, uint96 _feeNumerator) external virtual onlyOwner {
1818       _setDefaultRoyalty(_receiver, _feeNumerator);
1819   }
1820   //for ERC2981
1821   function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721A, ERC2981) returns (bool) {
1822     return super.supportsInterface(interfaceId);
1823   }
1824   //for ERC2981 Opensea
1825   function contractURI() external view virtual returns (string memory) {
1826         return _formatContractURI();
1827   }
1828   //make contractURI
1829   function _formatContractURI() internal view returns (string memory) {
1830     (address receiver, uint256 royaltyFraction) = royaltyInfo(0,_feeDenominator());//tokenid=0
1831     return string(
1832       abi.encodePacked(
1833         "data:application/json;base64,",
1834         Base64.encode(
1835           bytes(
1836             abi.encodePacked(
1837                 '{"seller_fee_basis_points":', Strings.toString(royaltyFraction),
1838                 ', "fee_recipient":"', Strings.toHexString(uint256(uint160(receiver)), 20), '"}'
1839             )
1840           )
1841         )
1842       )
1843     );
1844   }
1845   //set owner's wallet.withdraw to this wallet.only owner.
1846   function setWithdrawWallet(address _owner) external virtual onlyOwner {
1847     _withdrawWallet = payable(_owner);
1848   }
1849 
1850   //set maxSupply.only owner.
1851   function setMaxSupply(uint256 _maxSupply) external virtual onlyOwner {
1852     require(totalSupply() <= _maxSupply, "Lower than _currentIndex.");
1853     maxSupply = _maxSupply;
1854   }
1855 
1856   // SET PRICES.
1857   function setVipPrice(uint256 newPrice) external virtual onlyOwner {
1858     vipMintPrice = newPrice;
1859   }
1860   function setWlPrice(uint256 newPrice) external virtual onlyOwner {
1861     wlMintPrice = newPrice;
1862   }
1863   function setPsPrice(uint256 newPrice) external virtual onlyOwner {
1864     psMintPrice = newPrice;
1865   }
1866 
1867   //set reveal.only owner.
1868   function setReveal(bool bool_) external virtual onlyOwner {
1869     _isRevealed = bool_;
1870   }
1871   //retuen _isRevealed.
1872   function isRevealed() external view virtual returns (bool){
1873     return _isRevealed;
1874   }
1875 
1876   // GET MINTED COUNT.
1877   function freeMinted(address _address) external view virtual returns (uint256){
1878     return _freeMinted[_address];
1879   }
1880   function vipMinted(address _address) external view virtual returns (uint256){
1881     return _vipMinted[_address];
1882   }
1883   function wlMinted(address _address) external view virtual returns (uint256){
1884     return _wlMinted[_address];
1885   }
1886   function psMinted(address _address) external view virtual returns (uint256){
1887     return _psMinted[_address];
1888   }
1889 
1890   // SET MAX MINTS.
1891   function setVipMaxMints(uint256 _max) external virtual onlyOwner {
1892     maxMintsPerVip = _max;
1893   }
1894   function setWlMaxMints(uint256 _max) external virtual onlyOwner {
1895     maxMintsPerWL = _max;
1896   }
1897   function setPsMaxMints(uint256 _max) external virtual onlyOwner {
1898     maxMintsPerPS = _max;
1899   }
1900 
1901   // SET SALES ENABLE.
1902   function setFreeMintEnable(bool bool_) external virtual onlyOwner {
1903     isFreeMintEnabled = bool_;
1904   }
1905   function setVipSaleEnable(bool bool_) external virtual onlyOwner {
1906     isVipSaleEnabled = bool_;
1907   }
1908   function setWhitelistSaleEnable(bool bool_) external virtual onlyOwner {
1909     isWlSaleEnabled = bool_;
1910   }
1911   function setPublicSaleEnable(bool bool_) external virtual onlyOwner {
1912     isPablicSaleEnabled = bool_;
1913   }
1914 
1915   // SET MERKLE ROOT.
1916   function setVipMerkleRoot(bytes32 merkleRoot_) external virtual onlyOwner {
1917     _setVipMerkleRoot(merkleRoot_);
1918   }
1919   function setWlMerkleRoot(bytes32 merkleRoot_) external virtual onlyOwner {
1920     _setWlMerkleRoot(merkleRoot_);
1921   }
1922 
1923   //set HiddenBaseURI.only owner.
1924   function setHiddenURI(uint256 index, string memory uri_) external virtual onlyOwner {
1925     require(index < 6, "Invalid Index");
1926     _revealUris[index] = uri_;
1927   }
1928 
1929   //return _currentIndex
1930   function getCurrentIndex() external view virtual returns (uint256){
1931     return _currentIndex;
1932   }
1933 
1934   //set BaseURI at after reveal. only owner.
1935   function setBaseURI(string memory uri_) external virtual onlyOwner {
1936     _baseTokenURI = uri_;
1937   }
1938 
1939   function setBaseExtension(string memory _newBaseExtension) external onlyOwner
1940   {
1941     _baseExtension = _newBaseExtension;
1942   }
1943 
1944   //retuen BaseURI.internal.
1945   function _currentBaseURI() internal view returns (string memory){
1946     return _baseTokenURI;
1947   }
1948 
1949   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1950     require(_exists(_tokenId), "URI query for nonexistent token");
1951     if(_isRevealed == false) {
1952       return _revealUris[_tokenId % 5];
1953     }
1954     return string(abi.encodePacked(_currentBaseURI(), Strings.toString(_tokenId), _baseExtension));
1955   }
1956 
1957   //owner mint.transfer to _address.only owner.
1958   function ownerMint(uint256 _amount, address _address) external virtual onlyOwner { 
1959     require((_amount + totalSupply()) <= (maxSupply), "No more NFTs");
1960     _safeMint(_address, _amount);
1961   }
1962 
1963   //Free mint.
1964   function freeMint(uint256 _amount, uint256 vipCount, bytes32[] memory proof_) external virtual nonReentrant {
1965     require(isFreeMintEnabled, "Free Mint is Paused");
1966     require(isValidVipCount(msg.sender, vipCount, proof_), "Invalid Vip Count!");
1967     require(vipCount > 0, "You have no VIP!");
1968     require(vipCount >= _amount, "FreeMint: Over max mints per wallet");
1969     require(vipCount >= _freeMinted[msg.sender] + _amount, "You have no FreeMint left");
1970     require((_amount + totalSupply()) <= (maxSupply), "No more NFTs");
1971 
1972     _freeMinted[msg.sender] += _amount;
1973     _safeMint(msg.sender, _amount);
1974   }
1975 
1976   //Vip mint.
1977   function vipMint(uint256 _amount, uint256 vipCount, bytes32[] memory proof_) external payable virtual nonReentrant {
1978     require(isVipSaleEnabled, "Vip Sale is Paused");
1979     require(isValidVipCount(msg.sender, vipCount, proof_), "Invalid Vip Count!");
1980     require(vipCount > 0, "You have no VIP!");
1981     require(maxMintsPerVip >= _amount, "VipMint: Over max mints per wallet");
1982     require(maxMintsPerVip >= _vipMinted[msg.sender] + _amount, "You have no VipMint left");
1983     require(msg.value == vipMintPrice * _amount, "ETH value is not correct");
1984     require((_amount + totalSupply()) <= (maxSupply), "No more NFTs");
1985 
1986     _vipMinted[msg.sender] += _amount;
1987     _safeMint(msg.sender, _amount);
1988   }
1989 
1990   //WL mint.
1991   function whitelistMint(uint256 _amount, bytes32[] memory proof_) external payable virtual nonReentrant {
1992     require(isWlSaleEnabled, "whitelistMint is Paused");
1993     require(isWhitelisted(msg.sender, proof_), "You are not whitelisted!");
1994     require(maxMintsPerWL >= _amount, "whitelistMint: Over max mints per wallet");
1995     require(maxMintsPerWL >= _wlMinted[msg.sender] + _amount, "You have no whitelistMint left");
1996     require(msg.value == wlMintPrice * _amount, "ETH value is not correct");
1997     require((_amount + totalSupply()) <= (maxSupply), "No more NFTs");
1998 
1999     _wlMinted[msg.sender] += _amount;
2000     _safeMint(msg.sender, _amount);
2001   }
2002   
2003   //Public mint.
2004   function publicMint(uint256 _amount) external payable virtual nonReentrant {
2005     require(isPablicSaleEnabled, "publicMint is Paused");
2006     require(maxMintsPerPS >= _amount, "publicMint: Over max mints per wallet");
2007     require(maxMintsPerPS >= _psMinted[msg.sender] + _amount, "You have no publicMint left");
2008     require(msg.value == psMintPrice * _amount, "ETH value is not correct");
2009     require((_amount + totalSupply()) <= (maxSupply), "No more NFTs");
2010       
2011     _psMinted[msg.sender] += _amount;
2012     _safeMint(msg.sender, _amount);
2013   }
2014 
2015   //burn
2016   function burn(uint256 tokenId) external virtual {
2017     _burn(tokenId, true);
2018   }
2019 
2020   //widraw ETH from this contract.only owner. 
2021   function withdraw() external payable virtual onlyOwner nonReentrant{
2022     // This will payout the owner 100% of the contract balance.
2023     // Do not remove this otherwise you will not be able to withdraw the funds.
2024     // =============================================================================
2025     bool os;
2026     if(_withdrawWallet != address(0)){//if _withdrawWallet has.
2027       (os, ) = payable(_withdrawWallet).call{value: address(this).balance}("");
2028     }else{
2029       (os, ) = payable(owner()).call{value: address(this).balance}("");
2030     }
2031     require(os);
2032     // =============================================================================
2033   }
2034 
2035   //return wallet owned tokenids.
2036   function walletOfOwner(address _address) external view virtual returns (uint256[] memory) {
2037     uint256 ownerTokenCount = balanceOf(_address);
2038     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
2039     //search from all tonkenid. so spend high gas values.attention.
2040     uint256 tokenindex = 0;
2041     for (uint256 i = _startTokenId(); i < _currentIndex; i++) {
2042       if(_address == this.tryOwnerOf(i)) tokenIds[tokenindex++] = i;
2043     }
2044     return tokenIds;
2045   }
2046 
2047   //try catch vaersion ownerOf. I have a error at burned tokenid.so need to try catch.  only external.
2048   function tryOwnerOf(uint256 tokenId) external view  virtual returns (address) {
2049     try this.ownerOf(tokenId) returns (address _address) {
2050       return(_address);
2051     } catch {
2052         return (address(0));//return 0x0 if error.
2053     }
2054   }
2055 }