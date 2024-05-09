1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/Address.sol
4 
5 
6 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
7 
8 pragma solidity ^0.8.1;
9 
10 /**
11  * @dev Collection of functions related to the address type
12  */
13 library Address {
14     /**
15      * @dev Returns true if `account` is a contract.
16      *
17      * [IMPORTANT]
18      * ====
19      * It is unsafe to assume that an address for which this function returns
20      * false is an externally-owned account (EOA) and not a contract.
21      *
22      * Among others, `isContract` will return false for the following
23      * types of addresses:
24      *
25      *  - an externally-owned account
26      *  - a contract in construction
27      *  - an address where a contract will be created
28      *  - an address where a contract lived, but was destroyed
29      * ====
30      *
31      * [IMPORTANT]
32      * ====
33      * You shouldn't rely on `isContract` to protect against flash loan attacks!
34      *
35      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
36      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
37      * constructor.
38      * ====
39      */
40     function isContract(address account) internal view returns (bool) {
41         // This method relies on extcodesize/address.code.length, which returns 0
42         // for contracts in construction, since the code is only stored at the end
43         // of the constructor execution.
44 
45         return account.code.length > 0;
46     }
47 
48     /**
49      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
50      * `recipient`, forwarding all available gas and reverting on errors.
51      *
52      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
53      * of certain opcodes, possibly making contracts go over the 2300 gas limit
54      * imposed by `transfer`, making them unable to receive funds via
55      * `transfer`. {sendValue} removes this limitation.
56      *
57      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
58      *
59      * IMPORTANT: because control is transferred to `recipient`, care must be
60      * taken to not create reentrancy vulnerabilities. Consider using
61      * {ReentrancyGuard} or the
62      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
63      */
64     function sendValue(address payable recipient, uint256 amount) internal {
65         require(address(this).balance >= amount, "Address: insufficient balance");
66 
67         (bool success, ) = recipient.call{value: amount}("");
68         require(success, "Address: unable to send value, recipient may have reverted");
69     }
70 
71     /**
72      * @dev Performs a Solidity function call using a low level `call`. A
73      * plain `call` is an unsafe replacement for a function call: use this
74      * function instead.
75      *
76      * If `target` reverts with a revert reason, it is bubbled up by this
77      * function (like regular Solidity function calls).
78      *
79      * Returns the raw returned data. To convert to the expected return value,
80      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
81      *
82      * Requirements:
83      *
84      * - `target` must be a contract.
85      * - calling `target` with `data` must not revert.
86      *
87      * _Available since v3.1._
88      */
89     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
90         return functionCall(target, data, "Address: low-level call failed");
91     }
92 
93     /**
94      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
95      * `errorMessage` as a fallback revert reason when `target` reverts.
96      *
97      * _Available since v3.1._
98      */
99     function functionCall(
100         address target,
101         bytes memory data,
102         string memory errorMessage
103     ) internal returns (bytes memory) {
104         return functionCallWithValue(target, data, 0, errorMessage);
105     }
106 
107     /**
108      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
109      * but also transferring `value` wei to `target`.
110      *
111      * Requirements:
112      *
113      * - the calling contract must have an ETH balance of at least `value`.
114      * - the called Solidity function must be `payable`.
115      *
116      * _Available since v3.1._
117      */
118     function functionCallWithValue(
119         address target,
120         bytes memory data,
121         uint256 value
122     ) internal returns (bytes memory) {
123         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
124     }
125 
126     /**
127      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
128      * with `errorMessage` as a fallback revert reason when `target` reverts.
129      *
130      * _Available since v3.1._
131      */
132     function functionCallWithValue(
133         address target,
134         bytes memory data,
135         uint256 value,
136         string memory errorMessage
137     ) internal returns (bytes memory) {
138         require(address(this).balance >= value, "Address: insufficient balance for call");
139         require(isContract(target), "Address: call to non-contract");
140 
141         (bool success, bytes memory returndata) = target.call{value: value}(data);
142         return verifyCallResult(success, returndata, errorMessage);
143     }
144 
145     /**
146      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
147      * but performing a static call.
148      *
149      * _Available since v3.3._
150      */
151     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
152         return functionStaticCall(target, data, "Address: low-level static call failed");
153     }
154 
155     /**
156      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
157      * but performing a static call.
158      *
159      * _Available since v3.3._
160      */
161     function functionStaticCall(
162         address target,
163         bytes memory data,
164         string memory errorMessage
165     ) internal view returns (bytes memory) {
166         require(isContract(target), "Address: static call to non-contract");
167 
168         (bool success, bytes memory returndata) = target.staticcall(data);
169         return verifyCallResult(success, returndata, errorMessage);
170     }
171 
172     /**
173      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
174      * but performing a delegate call.
175      *
176      * _Available since v3.4._
177      */
178     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
179         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
180     }
181 
182     /**
183      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
184      * but performing a delegate call.
185      *
186      * _Available since v3.4._
187      */
188     function functionDelegateCall(
189         address target,
190         bytes memory data,
191         string memory errorMessage
192     ) internal returns (bytes memory) {
193         require(isContract(target), "Address: delegate call to non-contract");
194 
195         (bool success, bytes memory returndata) = target.delegatecall(data);
196         return verifyCallResult(success, returndata, errorMessage);
197     }
198 
199     /**
200      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
201      * revert reason using the provided one.
202      *
203      * _Available since v4.3._
204      */
205     function verifyCallResult(
206         bool success,
207         bytes memory returndata,
208         string memory errorMessage
209     ) internal pure returns (bytes memory) {
210         if (success) {
211             return returndata;
212         } else {
213             // Look for revert reason and bubble it up if present
214             if (returndata.length > 0) {
215                 // The easiest way to bubble the revert reason is using memory via assembly
216                 /// @solidity memory-safe-assembly
217                 assembly {
218                     let returndata_size := mload(returndata)
219                     revert(add(32, returndata), returndata_size)
220                 }
221             } else {
222                 revert(errorMessage);
223             }
224         }
225     }
226 }
227 
228 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
229 
230 
231 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
232 
233 pragma solidity ^0.8.0;
234 
235 /**
236  * @title ERC721 token receiver interface
237  * @dev Interface for any contract that wants to support safeTransfers
238  * from ERC721 asset contracts.
239  */
240 interface IERC721Receiver {
241     /**
242      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
243      * by `operator` from `from`, this function is called.
244      *
245      * It must return its Solidity selector to confirm the token transfer.
246      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
247      *
248      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
249      */
250     function onERC721Received(
251         address operator,
252         address from,
253         uint256 tokenId,
254         bytes calldata data
255     ) external returns (bytes4);
256 }
257 
258 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
259 
260 
261 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
262 
263 pragma solidity ^0.8.0;
264 
265 /**
266  * @dev Interface of the ERC165 standard, as defined in the
267  * https://eips.ethereum.org/EIPS/eip-165[EIP].
268  *
269  * Implementers can declare support of contract interfaces, which can then be
270  * queried by others ({ERC165Checker}).
271  *
272  * For an implementation, see {ERC165}.
273  */
274 interface IERC165 {
275     /**
276      * @dev Returns true if this contract implements the interface defined by
277      * `interfaceId`. See the corresponding
278      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
279      * to learn more about how these ids are created.
280      *
281      * This function call must use less than 30 000 gas.
282      */
283     function supportsInterface(bytes4 interfaceId) external view returns (bool);
284 }
285 
286 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
287 
288 
289 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
290 
291 pragma solidity ^0.8.0;
292 
293 
294 /**
295  * @dev Implementation of the {IERC165} interface.
296  *
297  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
298  * for the additional interface id that will be supported. For example:
299  *
300  * ```solidity
301  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
302  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
303  * }
304  * ```
305  *
306  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
307  */
308 abstract contract ERC165 is IERC165 {
309     /**
310      * @dev See {IERC165-supportsInterface}.
311      */
312     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
313         return interfaceId == type(IERC165).interfaceId;
314     }
315 }
316 
317 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
318 
319 
320 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
321 
322 pragma solidity ^0.8.0;
323 
324 
325 /**
326  * @dev Required interface of an ERC721 compliant contract.
327  */
328 interface IERC721 is IERC165 {
329     /**
330      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
331      */
332     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
333 
334     /**
335      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
336      */
337     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
338 
339     /**
340      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
341      */
342     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
343 
344     /**
345      * @dev Returns the number of tokens in ``owner``'s account.
346      */
347     function balanceOf(address owner) external view returns (uint256 balance);
348 
349     /**
350      * @dev Returns the owner of the `tokenId` token.
351      *
352      * Requirements:
353      *
354      * - `tokenId` must exist.
355      */
356     function ownerOf(uint256 tokenId) external view returns (address owner);
357 
358     /**
359      * @dev Safely transfers `tokenId` token from `from` to `to`.
360      *
361      * Requirements:
362      *
363      * - `from` cannot be the zero address.
364      * - `to` cannot be the zero address.
365      * - `tokenId` token must exist and be owned by `from`.
366      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
367      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
368      *
369      * Emits a {Transfer} event.
370      */
371     function safeTransferFrom(
372         address from,
373         address to,
374         uint256 tokenId,
375         bytes calldata data
376     ) external;
377 
378     /**
379      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
380      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
381      *
382      * Requirements:
383      *
384      * - `from` cannot be the zero address.
385      * - `to` cannot be the zero address.
386      * - `tokenId` token must exist and be owned by `from`.
387      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
388      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
389      *
390      * Emits a {Transfer} event.
391      */
392     function safeTransferFrom(
393         address from,
394         address to,
395         uint256 tokenId
396     ) external;
397 
398     /**
399      * @dev Transfers `tokenId` token from `from` to `to`.
400      *
401      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
402      *
403      * Requirements:
404      *
405      * - `from` cannot be the zero address.
406      * - `to` cannot be the zero address.
407      * - `tokenId` token must be owned by `from`.
408      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
409      *
410      * Emits a {Transfer} event.
411      */
412     function transferFrom(
413         address from,
414         address to,
415         uint256 tokenId
416     ) external;
417 
418     /**
419      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
420      * The approval is cleared when the token is transferred.
421      *
422      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
423      *
424      * Requirements:
425      *
426      * - The caller must own the token or be an approved operator.
427      * - `tokenId` must exist.
428      *
429      * Emits an {Approval} event.
430      */
431     function approve(address to, uint256 tokenId) external;
432 
433     /**
434      * @dev Approve or remove `operator` as an operator for the caller.
435      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
436      *
437      * Requirements:
438      *
439      * - The `operator` cannot be the caller.
440      *
441      * Emits an {ApprovalForAll} event.
442      */
443     function setApprovalForAll(address operator, bool _approved) external;
444 
445     /**
446      * @dev Returns the account approved for `tokenId` token.
447      *
448      * Requirements:
449      *
450      * - `tokenId` must exist.
451      */
452     function getApproved(uint256 tokenId) external view returns (address operator);
453 
454     /**
455      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
456      *
457      * See {setApprovalForAll}
458      */
459     function isApprovedForAll(address owner, address operator) external view returns (bool);
460 }
461 
462 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
463 
464 
465 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
466 
467 pragma solidity ^0.8.0;
468 
469 
470 /**
471  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
472  * @dev See https://eips.ethereum.org/EIPS/eip-721
473  */
474 interface IERC721Enumerable is IERC721 {
475     /**
476      * @dev Returns the total amount of tokens stored by the contract.
477      */
478     function totalSupply() external view returns (uint256);
479 
480     /**
481      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
482      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
483      */
484     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
485 
486     /**
487      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
488      * Use along with {totalSupply} to enumerate all tokens.
489      */
490     function tokenByIndex(uint256 index) external view returns (uint256);
491 }
492 
493 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
494 
495 
496 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
497 
498 pragma solidity ^0.8.0;
499 
500 
501 /**
502  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
503  * @dev See https://eips.ethereum.org/EIPS/eip-721
504  */
505 interface IERC721Metadata is IERC721 {
506     /**
507      * @dev Returns the token collection name.
508      */
509     function name() external view returns (string memory);
510 
511     /**
512      * @dev Returns the token collection symbol.
513      */
514     function symbol() external view returns (string memory);
515 
516     /**
517      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
518      */
519     function tokenURI(uint256 tokenId) external view returns (string memory);
520 }
521 
522 // File: @openzeppelin/contracts/utils/Strings.sol
523 
524 
525 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
526 
527 pragma solidity ^0.8.0;
528 
529 /**
530  * @dev String operations.
531  */
532 library Strings {
533     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
534     uint8 private constant _ADDRESS_LENGTH = 20;
535 
536     /**
537      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
538      */
539     function toString(uint256 value) internal pure returns (string memory) {
540         // Inspired by OraclizeAPI's implementation - MIT licence
541         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
542 
543         if (value == 0) {
544             return "0";
545         }
546         uint256 temp = value;
547         uint256 digits;
548         while (temp != 0) {
549             digits++;
550             temp /= 10;
551         }
552         bytes memory buffer = new bytes(digits);
553         while (value != 0) {
554             digits -= 1;
555             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
556             value /= 10;
557         }
558         return string(buffer);
559     }
560 
561     /**
562      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
563      */
564     function toHexString(uint256 value) internal pure returns (string memory) {
565         if (value == 0) {
566             return "0x00";
567         }
568         uint256 temp = value;
569         uint256 length = 0;
570         while (temp != 0) {
571             length++;
572             temp >>= 8;
573         }
574         return toHexString(value, length);
575     }
576 
577     /**
578      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
579      */
580     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
581         bytes memory buffer = new bytes(2 * length + 2);
582         buffer[0] = "0";
583         buffer[1] = "x";
584         for (uint256 i = 2 * length + 1; i > 1; --i) {
585             buffer[i] = _HEX_SYMBOLS[value & 0xf];
586             value >>= 4;
587         }
588         require(value == 0, "Strings: hex length insufficient");
589         return string(buffer);
590     }
591 
592     /**
593      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
594      */
595     function toHexString(address addr) internal pure returns (string memory) {
596         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
597     }
598 }
599 
600 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
601 
602 
603 // OpenZeppelin Contracts (last updated v4.7.3) (utils/cryptography/ECDSA.sol)
604 
605 pragma solidity ^0.8.0;
606 
607 
608 /**
609  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
610  *
611  * These functions can be used to verify that a message was signed by the holder
612  * of the private keys of a given address.
613  */
614 library ECDSA {
615     enum RecoverError {
616         NoError,
617         InvalidSignature,
618         InvalidSignatureLength,
619         InvalidSignatureS,
620         InvalidSignatureV
621     }
622 
623     function _throwError(RecoverError error) private pure {
624         if (error == RecoverError.NoError) {
625             return; // no error: do nothing
626         } else if (error == RecoverError.InvalidSignature) {
627             revert("ECDSA: invalid signature");
628         } else if (error == RecoverError.InvalidSignatureLength) {
629             revert("ECDSA: invalid signature length");
630         } else if (error == RecoverError.InvalidSignatureS) {
631             revert("ECDSA: invalid signature 's' value");
632         } else if (error == RecoverError.InvalidSignatureV) {
633             revert("ECDSA: invalid signature 'v' value");
634         }
635     }
636 
637     /**
638      * @dev Returns the address that signed a hashed message (`hash`) with
639      * `signature` or error string. This address can then be used for verification purposes.
640      *
641      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
642      * this function rejects them by requiring the `s` value to be in the lower
643      * half order, and the `v` value to be either 27 or 28.
644      *
645      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
646      * verification to be secure: it is possible to craft signatures that
647      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
648      * this is by receiving a hash of the original message (which may otherwise
649      * be too long), and then calling {toEthSignedMessageHash} on it.
650      *
651      * Documentation for signature generation:
652      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
653      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
654      *
655      * _Available since v4.3._
656      */
657     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
658         if (signature.length == 65) {
659             bytes32 r;
660             bytes32 s;
661             uint8 v;
662             // ecrecover takes the signature parameters, and the only way to get them
663             // currently is to use assembly.
664             /// @solidity memory-safe-assembly
665             assembly {
666                 r := mload(add(signature, 0x20))
667                 s := mload(add(signature, 0x40))
668                 v := byte(0, mload(add(signature, 0x60)))
669             }
670             return tryRecover(hash, v, r, s);
671         } else {
672             return (address(0), RecoverError.InvalidSignatureLength);
673         }
674     }
675 
676     /**
677      * @dev Returns the address that signed a hashed message (`hash`) with
678      * `signature`. This address can then be used for verification purposes.
679      *
680      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
681      * this function rejects them by requiring the `s` value to be in the lower
682      * half order, and the `v` value to be either 27 or 28.
683      *
684      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
685      * verification to be secure: it is possible to craft signatures that
686      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
687      * this is by receiving a hash of the original message (which may otherwise
688      * be too long), and then calling {toEthSignedMessageHash} on it.
689      */
690     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
691         (address recovered, RecoverError error) = tryRecover(hash, signature);
692         _throwError(error);
693         return recovered;
694     }
695 
696     /**
697      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
698      *
699      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
700      *
701      * _Available since v4.3._
702      */
703     function tryRecover(
704         bytes32 hash,
705         bytes32 r,
706         bytes32 vs
707     ) internal pure returns (address, RecoverError) {
708         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
709         uint8 v = uint8((uint256(vs) >> 255) + 27);
710         return tryRecover(hash, v, r, s);
711     }
712 
713     /**
714      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
715      *
716      * _Available since v4.2._
717      */
718     function recover(
719         bytes32 hash,
720         bytes32 r,
721         bytes32 vs
722     ) internal pure returns (address) {
723         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
724         _throwError(error);
725         return recovered;
726     }
727 
728     /**
729      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
730      * `r` and `s` signature fields separately.
731      *
732      * _Available since v4.3._
733      */
734     function tryRecover(
735         bytes32 hash,
736         uint8 v,
737         bytes32 r,
738         bytes32 s
739     ) internal pure returns (address, RecoverError) {
740         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
741         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
742         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
743         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
744         //
745         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
746         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
747         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
748         // these malleable signatures as well.
749         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
750             return (address(0), RecoverError.InvalidSignatureS);
751         }
752         if (v != 27 && v != 28) {
753             return (address(0), RecoverError.InvalidSignatureV);
754         }
755 
756         // If the signature is valid (and not malleable), return the signer address
757         address signer = ecrecover(hash, v, r, s);
758         if (signer == address(0)) {
759             return (address(0), RecoverError.InvalidSignature);
760         }
761 
762         return (signer, RecoverError.NoError);
763     }
764 
765     /**
766      * @dev Overload of {ECDSA-recover} that receives the `v`,
767      * `r` and `s` signature fields separately.
768      */
769     function recover(
770         bytes32 hash,
771         uint8 v,
772         bytes32 r,
773         bytes32 s
774     ) internal pure returns (address) {
775         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
776         _throwError(error);
777         return recovered;
778     }
779 
780     /**
781      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
782      * produces hash corresponding to the one signed with the
783      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
784      * JSON-RPC method as part of EIP-191.
785      *
786      * See {recover}.
787      */
788     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
789         // 32 is the length in bytes of hash,
790         // enforced by the type signature above
791         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
792     }
793 
794     /**
795      * @dev Returns an Ethereum Signed Message, created from `s`. This
796      * produces hash corresponding to the one signed with the
797      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
798      * JSON-RPC method as part of EIP-191.
799      *
800      * See {recover}.
801      */
802     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
803         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
804     }
805 
806     /**
807      * @dev Returns an Ethereum Signed Typed Data, created from a
808      * `domainSeparator` and a `structHash`. This produces hash corresponding
809      * to the one signed with the
810      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
811      * JSON-RPC method as part of EIP-712.
812      *
813      * See {recover}.
814      */
815     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
816         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
817     }
818 }
819 
820 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
821 
822 
823 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
824 
825 pragma solidity ^0.8.0;
826 
827 /**
828  * @dev Contract module that helps prevent reentrant calls to a function.
829  *
830  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
831  * available, which can be applied to functions to make sure there are no nested
832  * (reentrant) calls to them.
833  *
834  * Note that because there is a single `nonReentrant` guard, functions marked as
835  * `nonReentrant` may not call one another. This can be worked around by making
836  * those functions `private`, and then adding `external` `nonReentrant` entry
837  * points to them.
838  *
839  * TIP: If you would like to learn more about reentrancy and alternative ways
840  * to protect against it, check out our blog post
841  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
842  */
843 abstract contract ReentrancyGuard {
844     // Booleans are more expensive than uint256 or any type that takes up a full
845     // word because each write operation emits an extra SLOAD to first read the
846     // slot's contents, replace the bits taken up by the boolean, and then write
847     // back. This is the compiler's defense against contract upgrades and
848     // pointer aliasing, and it cannot be disabled.
849 
850     // The values being non-zero value makes deployment a bit more expensive,
851     // but in exchange the refund on every call to nonReentrant will be lower in
852     // amount. Since refunds are capped to a percentage of the total
853     // transaction's gas, it is best to keep them low in cases like this one, to
854     // increase the likelihood of the full refund coming into effect.
855     uint256 private constant _NOT_ENTERED = 1;
856     uint256 private constant _ENTERED = 2;
857 
858     uint256 private _status;
859 
860     constructor() {
861         _status = _NOT_ENTERED;
862     }
863 
864     /**
865      * @dev Prevents a contract from calling itself, directly or indirectly.
866      * Calling a `nonReentrant` function from another `nonReentrant`
867      * function is not supported. It is possible to prevent this from happening
868      * by making the `nonReentrant` function external, and making it call a
869      * `private` function that does the actual work.
870      */
871     modifier nonReentrant() {
872         // On the first call to nonReentrant, _notEntered will be true
873         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
874 
875         // Any calls to nonReentrant after this point will fail
876         _status = _ENTERED;
877 
878         _;
879 
880         // By storing the original value once again, a refund is triggered (see
881         // https://eips.ethereum.org/EIPS/eip-2200)
882         _status = _NOT_ENTERED;
883     }
884 }
885 
886 // File: @openzeppelin/contracts/utils/Context.sol
887 
888 
889 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
890 
891 pragma solidity ^0.8.0;
892 
893 /**
894  * @dev Provides information about the current execution context, including the
895  * sender of the transaction and its data. While these are generally available
896  * via msg.sender and msg.data, they should not be accessed in such a direct
897  * manner, since when dealing with meta-transactions the account sending and
898  * paying for execution may not be the actual sender (as far as an application
899  * is concerned).
900  *
901  * This contract is only required for intermediate, library-like contracts.
902  */
903 abstract contract Context {
904     function _msgSender() internal view virtual returns (address) {
905         return msg.sender;
906     }
907 
908     function _msgData() internal view virtual returns (bytes calldata) {
909         return msg.data;
910     }
911 }
912 
913 // File: contracts/ERC721A.sol
914 
915 
916 
917 pragma solidity ^0.8.7;
918 
919 
920 
921 
922 
923 
924 
925 
926 
927 /**
928  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
929  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
930  *
931  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
932  *
933  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
934  *
935  * Does not support burning tokens to address(0).
936  */
937 contract ERC721A is
938 Context,
939 ERC165,
940 IERC721,
941 IERC721Metadata,
942 IERC721Enumerable
943 {
944     using Address for address;
945     using Strings for uint256;
946 
947     struct TokenOwnership {
948         address addr;
949         uint64 startTimestamp;
950     }
951 
952     struct AddressData {
953         uint128 balance;
954         uint128 numberMinted;
955     }
956 
957     uint256 private currentIndex;
958 
959     uint256 internal immutable collectionSize;
960     uint256 internal immutable maxBatchSize;
961 
962     // Token name
963     string private _name;
964 
965     // Token symbol
966     string private _symbol;
967 
968     // Mapping from token ID to ownership details
969     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
970     mapping(uint256 => TokenOwnership) private _ownerships;
971 
972     // Mapping owner address to address data
973     mapping(address => AddressData) private _addressData;
974 
975     // Mapping from token ID to approved address
976     mapping(uint256 => address) private _tokenApprovals;
977 
978     // Mapping from owner to operator approvals
979     mapping(address => mapping(address => bool)) private _operatorApprovals;
980 
981     /**
982      * @dev
983      * `maxBatchSize` refers to how much a minter can mint at a time.
984      * `collectionSize_` refers to how many tokens are in the collection.
985      */
986     constructor(
987         string memory name_,
988         string memory symbol_,
989         uint256 maxBatchSize_,
990         uint256 collectionSize_
991     ) {
992         require(
993             collectionSize_ > 0,
994             "ERC721A: collection must have a nonzero supply"
995         );
996         require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
997         _name = name_;
998         _symbol = symbol_;
999         maxBatchSize = maxBatchSize_;
1000         collectionSize = collectionSize_;
1001         currentIndex  = _startTokenId();
1002     }
1003 
1004     function _startTokenId() internal view virtual returns (uint256) {
1005         return 0;
1006     }
1007 
1008     /**
1009      * @dev See {IERC721Enumerable-totalSupply}.
1010      */
1011     function totalSupply() public view override returns (uint256) {
1012         return currentIndex - _startTokenId();
1013     }
1014 
1015     /**
1016      * @dev See {IERC721Enumerable-tokenByIndex}.
1017      */
1018     function tokenByIndex(uint256 index)
1019     public
1020     view
1021     override
1022     returns (uint256)
1023     {
1024         require(index < totalSupply(), "ERC721A: global index out of bounds");
1025         return index;
1026     }
1027 
1028     /**
1029      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1030      * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1031      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1032      */
1033     function tokenOfOwnerByIndex(address owner, uint256 index)
1034     public
1035     view
1036     override
1037     returns (uint256)
1038     {
1039         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1040         uint256 numMintedSoFar = totalSupply();
1041         uint256 tokenIdsIdx = 0;
1042         address currOwnershipAddr = address(0);
1043         for (uint256 i = 0; i < numMintedSoFar; i++) {
1044             TokenOwnership memory ownership = _ownerships[i];
1045             if (ownership.addr != address(0)) {
1046                 currOwnershipAddr = ownership.addr;
1047             }
1048             if (currOwnershipAddr == owner) {
1049                 if (tokenIdsIdx == index) {
1050                     return i;
1051                 }
1052                 tokenIdsIdx++;
1053             }
1054         }
1055         revert("ERC721A: unable to get token of owner by index");
1056     }
1057 
1058     /**
1059      * @dev See {IERC165-supportsInterface}.
1060      */
1061     function supportsInterface(bytes4 interfaceId)
1062     public
1063     view
1064     virtual
1065     override(ERC165, IERC165)
1066     returns (bool)
1067     {
1068         return
1069         interfaceId == type(IERC721).interfaceId ||
1070     interfaceId == type(IERC721Metadata).interfaceId ||
1071     interfaceId == type(IERC721Enumerable).interfaceId ||
1072     super.supportsInterface(interfaceId);
1073     }
1074 
1075     /**
1076      * @dev See {IERC721-balanceOf}.
1077      */
1078     function balanceOf(address owner) public view override returns (uint256) {
1079         require(
1080             owner != address(0),
1081             "ERC721A: balance query for the zero address"
1082         );
1083         return uint256(_addressData[owner].balance);
1084     }
1085 
1086     function _numberMinted(address owner) internal view returns (uint256) {
1087         require(
1088             owner != address(0),
1089             "ERC721A: number minted query for the zero address"
1090         );
1091         return uint256(_addressData[owner].numberMinted);
1092     }
1093 
1094     function ownershipOf(uint256 tokenId)
1095     internal
1096     view
1097     returns (TokenOwnership memory)
1098     {
1099         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1100 
1101         uint256 lowestTokenToCheck;
1102         if (tokenId >= maxBatchSize) {
1103             lowestTokenToCheck = tokenId - maxBatchSize + 1;
1104         }
1105 
1106         for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
1107             TokenOwnership memory ownership = _ownerships[curr];
1108             if (ownership.addr != address(0)) {
1109                 return ownership;
1110             }
1111         }
1112 
1113         revert("ERC721A: unable to determine the owner of token");
1114     }
1115 
1116     /**
1117      * @dev See {IERC721-ownerOf}.
1118      */
1119     function ownerOf(uint256 tokenId) public view override returns (address) {
1120         return ownershipOf(tokenId).addr;
1121     }
1122 
1123     /**
1124      * @dev See {IERC721Metadata-name}.
1125      */
1126     function name() public view virtual override returns (string memory) {
1127         return _name;
1128     }
1129 
1130     /**
1131      * @dev See {IERC721Metadata-symbol}.
1132      */
1133     function symbol() public view virtual override returns (string memory) {
1134         return _symbol;
1135     }
1136 
1137     /**
1138      * @dev See {IERC721Metadata-tokenURI}.
1139      */
1140     function tokenURI(uint256 tokenId)
1141     public
1142     view
1143     virtual
1144     override
1145     returns (string memory)
1146     {
1147         require(
1148             _exists(tokenId),
1149             "ERC721Metadata: URI query for nonexistent token"
1150         );
1151 
1152         string memory baseURI = _baseURI();
1153         return
1154         bytes(baseURI).length > 0
1155         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1156         : "";
1157     }
1158 
1159     /**
1160      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1161      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1162      * by default, can be overriden in child contracts.
1163      */
1164     function _baseURI() internal view virtual returns (string memory) {
1165         return "";
1166     }
1167 
1168     /**
1169      * @dev See {IERC721-approve}.
1170      */
1171     function approve(address to, uint256 tokenId) public override {
1172         address owner = ERC721A.ownerOf(tokenId);
1173         require(to != owner, "ERC721A: approval to current owner");
1174 
1175         require(
1176             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1177             "ERC721A: approve caller is not owner nor approved for all"
1178         );
1179 
1180         _approve(to, tokenId, owner);
1181     }
1182 
1183     /**
1184      * @dev See {IERC721-getApproved}.
1185      */
1186     function getApproved(uint256 tokenId)
1187     public
1188     view
1189     override
1190     returns (address)
1191     {
1192         require(
1193             _exists(tokenId),
1194             "ERC721A: approved query for nonexistent token"
1195         );
1196 
1197         return _tokenApprovals[tokenId];
1198     }
1199 
1200     /**
1201      * @dev See {IERC721-setApprovalForAll}.
1202      */
1203     function setApprovalForAll(address operator, bool approved)
1204     public
1205     override
1206     {
1207         require(operator != _msgSender(), "ERC721A: approve to caller");
1208 
1209         _operatorApprovals[_msgSender()][operator] = approved;
1210         emit ApprovalForAll(_msgSender(), operator, approved);
1211     }
1212 
1213     /**
1214      * @dev See {IERC721-isApprovedForAll}.
1215      */
1216     function isApprovedForAll(address owner, address operator)
1217     public
1218     view
1219     virtual
1220     override
1221     returns (bool)
1222     {
1223         return _operatorApprovals[owner][operator];
1224     }
1225 
1226     /**
1227      * @dev See {IERC721-transferFrom}.
1228      */
1229     function transferFrom(
1230         address from,
1231         address to,
1232         uint256 tokenId
1233     ) public override {
1234         _transfer(from, to, tokenId);
1235     }
1236 
1237     /**
1238      * @dev See {IERC721-safeTransferFrom}.
1239      */
1240     function safeTransferFrom(
1241         address from,
1242         address to,
1243         uint256 tokenId
1244     ) public override {
1245         safeTransferFrom(from, to, tokenId, "");
1246     }
1247 
1248     /**
1249      * @dev See {IERC721-safeTransferFrom}.
1250      */
1251     function safeTransferFrom(
1252         address from,
1253         address to,
1254         uint256 tokenId,
1255         bytes memory _data
1256     ) public override {
1257         _transfer(from, to, tokenId);
1258         require(
1259             _checkOnERC721Received(from, to, tokenId, _data),
1260             "ERC721A: transfer to non ERC721Receiver implementer"
1261         );
1262     }
1263 
1264     /**
1265      * @dev Returns whether `tokenId` exists.
1266      *
1267      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1268      *
1269      * Tokens start existing when they are minted (`_mint`),
1270      */
1271     function _exists(uint256 tokenId) internal view returns (bool) {
1272         return tokenId < currentIndex;
1273     }
1274 
1275     function _safeMint(address to, uint256 quantity) internal {
1276         _safeMint(to, quantity, "");
1277     }
1278 
1279     /**
1280      * @dev Mints `quantity` tokens and transfers them to `to`.
1281      *
1282      * Requirements:
1283      *
1284      * - there must be `quantity` tokens remaining unminted in the total collection.
1285      * - `to` cannot be the zero address.
1286      * - `quantity` cannot be larger than the max batch size.
1287      *
1288      * Emits a {Transfer} event.
1289      */
1290     function _safeMint(
1291         address to,
1292         uint256 quantity,
1293         bytes memory _data
1294     ) internal {
1295         uint256 startTokenId = currentIndex;
1296         require(to != address(0), "ERC721A: mint to the zero address");
1297         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1298         require(!_exists(startTokenId), "ERC721A: token already minted");
1299         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1300 
1301         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1302 
1303         AddressData memory addressData = _addressData[to];
1304         _addressData[to] = AddressData(
1305             addressData.balance + uint128(quantity),
1306             addressData.numberMinted + uint128(quantity)
1307         );
1308         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1309 
1310         uint256 updatedIndex = startTokenId;
1311 
1312         for (uint256 i = 0; i < quantity; i++) {
1313             emit Transfer(address(0), to, updatedIndex);
1314             require(
1315                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
1316                 "ERC721A: transfer to non ERC721Receiver implementer"
1317             );
1318             updatedIndex++;
1319         }
1320 
1321         currentIndex = updatedIndex;
1322         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1323     }
1324 
1325     /**
1326      * @dev Transfers `tokenId` from `from` to `to`.
1327      *
1328      * Requirements:
1329      *
1330      * - `to` cannot be the zero address.
1331      * - `tokenId` token must be owned by `from`.
1332      *
1333      * Emits a {Transfer} event.
1334      */
1335     function _transfer(
1336         address from,
1337         address to,
1338         uint256 tokenId
1339     ) private {
1340         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1341 
1342         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1343         getApproved(tokenId) == _msgSender() ||
1344         isApprovedForAll(prevOwnership.addr, _msgSender()));
1345 
1346         require(
1347             isApprovedOrOwner,
1348             "ERC721A: transfer caller is not owner nor approved"
1349         );
1350 
1351         require(
1352             prevOwnership.addr == from,
1353             "ERC721A: transfer from incorrect owner"
1354         );
1355         require(to != address(0), "ERC721A: transfer to the zero address");
1356 
1357         _beforeTokenTransfers(from, to, tokenId, 1);
1358 
1359         // Clear approvals from the previous owner
1360         _approve(address(0), tokenId, prevOwnership.addr);
1361 
1362         _addressData[from].balance -= 1;
1363         _addressData[to].balance += 1;
1364         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1365 
1366         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1367         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1368         uint256 nextTokenId = tokenId + 1;
1369         if (_ownerships[nextTokenId].addr == address(0)) {
1370             if (_exists(nextTokenId)) {
1371                 _ownerships[nextTokenId] = TokenOwnership(
1372                     prevOwnership.addr,
1373                     prevOwnership.startTimestamp
1374                 );
1375             }
1376         }
1377 
1378         emit Transfer(from, to, tokenId);
1379         _afterTokenTransfers(from, to, tokenId, 1);
1380     }
1381 
1382     /**
1383      * @dev Approve `to` to operate on `tokenId`
1384      *
1385      * Emits a {Approval} event.
1386      */
1387     function _approve(
1388         address to,
1389         uint256 tokenId,
1390         address owner
1391     ) private {
1392         _tokenApprovals[tokenId] = to;
1393         emit Approval(owner, to, tokenId);
1394     }
1395 
1396     uint256 public nextOwnerToExplicitlySet = 0;
1397 
1398     /**
1399      * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1400      */
1401     function _setOwnersExplicit(uint256 quantity) internal {
1402         uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1403         require(quantity > 0, "quantity must be nonzero");
1404         uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1405         if (endIndex > collectionSize - 1) {
1406             endIndex = collectionSize - 1;
1407         }
1408         // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1409         require(_exists(endIndex), "not enough minted yet for this cleanup");
1410         for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1411             if (_ownerships[i].addr == address(0)) {
1412                 TokenOwnership memory ownership = ownershipOf(i);
1413                 _ownerships[i] = TokenOwnership(
1414                     ownership.addr,
1415                     ownership.startTimestamp
1416                 );
1417             }
1418         }
1419         nextOwnerToExplicitlySet = endIndex + 1;
1420     }
1421 
1422     /**
1423      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1424      * The call is not executed if the target address is not a contract.
1425      *
1426      * @param from address representing the previous owner of the given token ID
1427      * @param to target address that will receive the tokens
1428      * @param tokenId uint256 ID of the token to be transferred
1429      * @param _data bytes optional data to send along with the call
1430      * @return bool whether the call correctly returned the expected magic value
1431      */
1432     function _checkOnERC721Received(
1433         address from,
1434         address to,
1435         uint256 tokenId,
1436         bytes memory _data
1437     ) private returns (bool) {
1438         if (to.isContract()) {
1439             try
1440             IERC721Receiver(to).onERC721Received(
1441                 _msgSender(),
1442                 from,
1443                 tokenId,
1444                 _data
1445             )
1446             returns (bytes4 retval) {
1447                 return retval == IERC721Receiver(to).onERC721Received.selector;
1448             } catch (bytes memory reason) {
1449                 if (reason.length == 0) {
1450                     revert(
1451                     "ERC721A: transfer to non ERC721Receiver implementer"
1452                     );
1453                 } else {
1454                     assembly {
1455                         revert(add(32, reason), mload(reason))
1456                     }
1457                 }
1458             }
1459         } else {
1460             return true;
1461         }
1462     }
1463 
1464     /**
1465      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1466      *
1467      * startTokenId - the first token id to be transferred
1468      * quantity - the amount to be transferred
1469      *
1470      * Calling conditions:
1471      *
1472      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1473      * transferred to `to`.
1474      * - When `from` is zero, `tokenId` will be minted for `to`.
1475      */
1476     function _beforeTokenTransfers(
1477         address from,
1478         address to,
1479         uint256 startTokenId,
1480         uint256 quantity
1481     ) internal virtual {}
1482 
1483     /**
1484      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1485      * minting.
1486      *
1487      * startTokenId - the first token id to be transferred
1488      * quantity - the amount to be transferred
1489      *
1490      * Calling conditions:
1491      *
1492      * - when `from` and `to` are both non-zero.
1493      * - `from` and `to` are never both zero.
1494      */
1495     function _afterTokenTransfers(
1496         address from,
1497         address to,
1498         uint256 startTokenId,
1499         uint256 quantity
1500     ) internal virtual {}
1501 }
1502 // File: @openzeppelin/contracts/access/Ownable.sol
1503 
1504 
1505 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1506 
1507 pragma solidity ^0.8.0;
1508 
1509 
1510 /**
1511  * @dev Contract module which provides a basic access control mechanism, where
1512  * there is an account (an owner) that can be granted exclusive access to
1513  * specific functions.
1514  *
1515  * By default, the owner account will be the one that deploys the contract. This
1516  * can later be changed with {transferOwnership}.
1517  *
1518  * This module is used through inheritance. It will make available the modifier
1519  * `onlyOwner`, which can be applied to your functions to restrict their use to
1520  * the owner.
1521  */
1522 abstract contract Ownable is Context {
1523     address private _owner;
1524 
1525     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1526 
1527     /**
1528      * @dev Initializes the contract setting the deployer as the initial owner.
1529      */
1530     constructor() {
1531         _transferOwnership(_msgSender());
1532     }
1533 
1534     /**
1535      * @dev Throws if called by any account other than the owner.
1536      */
1537     modifier onlyOwner() {
1538         _checkOwner();
1539         _;
1540     }
1541 
1542     /**
1543      * @dev Returns the address of the current owner.
1544      */
1545     function owner() public view virtual returns (address) {
1546         return _owner;
1547     }
1548 
1549     /**
1550      * @dev Throws if the sender is not the owner.
1551      */
1552     function _checkOwner() internal view virtual {
1553         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1554     }
1555 
1556     /**
1557      * @dev Leaves the contract without owner. It will not be possible to call
1558      * `onlyOwner` functions anymore. Can only be called by the current owner.
1559      *
1560      * NOTE: Renouncing ownership will leave the contract without an owner,
1561      * thereby removing any functionality that is only available to the owner.
1562      */
1563     function renounceOwnership() public virtual onlyOwner {
1564         _transferOwnership(address(0));
1565     }
1566 
1567     /**
1568      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1569      * Can only be called by the current owner.
1570      */
1571     function transferOwnership(address newOwner) public virtual onlyOwner {
1572         require(newOwner != address(0), "Ownable: new owner is the zero address");
1573         _transferOwnership(newOwner);
1574     }
1575 
1576     /**
1577      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1578      * Internal function without access restriction.
1579      */
1580     function _transferOwnership(address newOwner) internal virtual {
1581         address oldOwner = _owner;
1582         _owner = newOwner;
1583         emit OwnershipTransferred(oldOwner, newOwner);
1584     }
1585 }
1586 
1587 // File: contracts/TheApeLaw.sol
1588 
1589 
1590 pragma solidity ^0.8.7;
1591 
1592 
1593 
1594 
1595 
1596 contract TheApeLaw is ERC721A, Ownable, ReentrancyGuard {
1597     using ECDSA for bytes32;
1598 
1599     enum Status {
1600         Pending,
1601         PublicSale,
1602         Finished
1603     }
1604 
1605     Status public status;
1606     string public baseURI;
1607 
1608     uint256 public PRICE = 0.005 * 10**18;
1609 
1610     mapping(address => uint256) public freeMinted;
1611 
1612     uint256 public tokensReserved;
1613     uint256 public immutable reserveAmount;
1614     uint256 public immutable maxPerMint;
1615 
1616     string private _contractMetadataURI =
1617         "https://bafkreifh4qswna7lf7pf66xvhp5hs5uts5s4jmtxoqh7lff2jsvyglaa6y.ipfs.nftstorage.link/";
1618 
1619     event Minted(address minter, uint256 amount);
1620     event StatusChanged(Status status);
1621     event BaseURIChanged(string newBaseURI);
1622     event ReservedToken(address minter, address recipient, uint256 amount);
1623     event PriceChange(uint256 price);
1624     event Withdrawed(address addr, uint amount);
1625 
1626     constructor() ERC721A("The Ape Law", "TAL", 3, 225) {
1627         baseURI = "https://nftstorage.link/ipfs/bafybeifrpta6zdapdrjlfguwnqgytxuxuddyuti2237ausfyoep2l3isu4";
1628         maxPerMint = 3;
1629         reserveAmount = 30;
1630         status = Status.Pending;
1631     }
1632 
1633     function reserve(address recipient, uint256 amount) external onlyOwner {
1634         require(recipient != address(0), "Zero address");
1635         require(amount > 0, "Invalid mint amount!");
1636         require(
1637             totalSupply() + amount <= collectionSize,
1638             "Max supply exceeded"
1639         );
1640 
1641         require(
1642             tokensReserved + amount <= reserveAmount,
1643             "Max reserve amount exceeded"
1644         );
1645       
1646         uint256 numChunks = amount / maxPerMint;
1647         for (uint256 i = 0; i < numChunks; i++) {
1648             _safeMint(recipient, maxPerMint);
1649         }
1650         tokensReserved += amount;
1651         emit ReservedToken(msg.sender, recipient, amount);
1652     }
1653 
1654     function mint(uint256 amount) external payable {
1655         require(status == Status.PublicSale, "Public sale is not active.");
1656         require(
1657             tx.origin == msg.sender,
1658             "Contract is not allowed to mint."
1659         );
1660 
1661         require(amount > 0, "Invalid mint amount!");
1662 
1663         require(amount <= maxPerMint, "Exceeds the single maximum limit.");
1664 
1665         require(
1666             totalSupply() + amount + reserveAmount - tokensReserved <=
1667                 collectionSize,
1668             "Max supply exceeded."
1669         );
1670 
1671         uint256 totalPrice;
1672 
1673         if (freeMinted[msg.sender] == 0) {
1674             freeMinted[msg.sender] = 1;
1675             totalPrice = (amount - 1) * PRICE;
1676         } else {
1677             totalPrice = amount * PRICE;
1678         }
1679 
1680         _safeMint(msg.sender, amount);
1681         refundIfOver(totalPrice);
1682 
1683         emit Minted(msg.sender, amount);
1684     }
1685 
1686     function withdraw() external nonReentrant onlyOwner {
1687         require(address(this).balance > 0, "Insufficient balance");
1688         Address.sendValue(payable(owner()), address(this).balance);
1689         emit Withdrawed(owner(), address(this).balance);
1690     }
1691 
1692     function contractURI() public view returns (string memory) {
1693         return _contractMetadataURI;
1694     }
1695 
1696     function setContractMetadataURI(string calldata newContractMetadataUri)
1697         public
1698         onlyOwner
1699     {
1700         _contractMetadataURI = newContractMetadataUri;
1701     }
1702 
1703     function setBaseURI(string calldata newBaseURI) external onlyOwner {
1704         baseURI = newBaseURI;
1705         emit BaseURIChanged(newBaseURI);
1706     }
1707 
1708     function setPrice(uint256 newPrice) external onlyOwner {
1709         PRICE = newPrice;
1710         emit PriceChange(newPrice);
1711     }
1712 
1713     function setStatus(Status _status) external onlyOwner {
1714         status = _status;
1715         emit StatusChanged(_status);
1716     }
1717 
1718     function setOwnersExplicit(uint256 quantity)
1719         external
1720         onlyOwner
1721         nonReentrant
1722     {
1723         _setOwnersExplicit(quantity);
1724     }
1725 
1726     function maxSupply() external view returns (uint256) {
1727         return collectionSize;
1728     }
1729 
1730     function getOwnershipData(uint256 tokenId)
1731         external
1732         view
1733         returns (TokenOwnership memory)
1734     {
1735         return ownershipOf(tokenId);
1736     }
1737 
1738     function refundIfOver(uint256 price) private {
1739         require(msg.value >= price, "Need to send more ETH.");
1740         if (msg.value > price) {
1741             payable(msg.sender).transfer(msg.value - price);
1742         }
1743     }
1744 
1745     function _baseURI() internal view override returns (string memory) {
1746         return baseURI;
1747     }
1748 
1749     // start from 1
1750     function _startTokenId() internal pure override returns (uint256) {
1751         return 1;
1752     }
1753 }