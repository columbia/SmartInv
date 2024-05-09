1 // File: @openzeppelin/contracts/utils/Address.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
5 
6 pragma solidity ^0.8.1;
7 
8 /**
9  * @dev Collection of functions related to the address type
10  */
11 library Address {
12     /**
13      * @dev Returns true if `account` is a contract.
14      *
15      * [IMPORTANT]
16      * ====
17      * It is unsafe to assume that an address for which this function returns
18      * false is an externally-owned account (EOA) and not a contract.
19      *
20      * Among others, `isContract` will return false for the following
21      * types of addresses:
22      *
23      *  - an externally-owned account
24      *  - a contract in construction
25      *  - an address where a contract will be created
26      *  - an address where a contract lived, but was destroyed
27      * ====
28      *
29      * [IMPORTANT]
30      * ====
31      * You shouldn't rely on `isContract` to protect against flash loan attacks!
32      *
33      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
34      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
35      * constructor.
36      * ====
37      */
38     function isContract(address account) internal view returns (bool) {
39         // This method relies on extcodesize/address.code.length, which returns 0
40         // for contracts in construction, since the code is only stored at the end
41         // of the constructor execution.
42 
43         return account.code.length > 0;
44     }
45 
46     /**
47      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
48      * `recipient`, forwarding all available gas and reverting on errors.
49      *
50      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
51      * of certain opcodes, possibly making contracts go over the 2300 gas limit
52      * imposed by `transfer`, making them unable to receive funds via
53      * `transfer`. {sendValue} removes this limitation.
54      *
55      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
56      *
57      * IMPORTANT: because control is transferred to `recipient`, care must be
58      * taken to not create reentrancy vulnerabilities. Consider using
59      * {ReentrancyGuard} or the
60      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
61      */
62     function sendValue(address payable recipient, uint256 amount) internal {
63         require(address(this).balance >= amount, "Address: insufficient balance");
64 
65         (bool success, ) = recipient.call{value: amount}("");
66         require(success, "Address: unable to send value, recipient may have reverted");
67     }
68 
69     /**
70      * @dev Performs a Solidity function call using a low level `call`. A
71      * plain `call` is an unsafe replacement for a function call: use this
72      * function instead.
73      *
74      * If `target` reverts with a revert reason, it is bubbled up by this
75      * function (like regular Solidity function calls).
76      *
77      * Returns the raw returned data. To convert to the expected return value,
78      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
79      *
80      * Requirements:
81      *
82      * - `target` must be a contract.
83      * - calling `target` with `data` must not revert.
84      *
85      * _Available since v3.1._
86      */
87     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
88         return functionCall(target, data, "Address: low-level call failed");
89     }
90 
91     /**
92      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
93      * `errorMessage` as a fallback revert reason when `target` reverts.
94      *
95      * _Available since v3.1._
96      */
97     function functionCall(
98         address target,
99         bytes memory data,
100         string memory errorMessage
101     ) internal returns (bytes memory) {
102         return functionCallWithValue(target, data, 0, errorMessage);
103     }
104 
105     /**
106      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
107      * but also transferring `value` wei to `target`.
108      *
109      * Requirements:
110      *
111      * - the calling contract must have an ETH balance of at least `value`.
112      * - the called Solidity function must be `payable`.
113      *
114      * _Available since v3.1._
115      */
116     function functionCallWithValue(
117         address target,
118         bytes memory data,
119         uint256 value
120     ) internal returns (bytes memory) {
121         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
122     }
123 
124     /**
125      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
126      * with `errorMessage` as a fallback revert reason when `target` reverts.
127      *
128      * _Available since v3.1._
129      */
130     function functionCallWithValue(
131         address target,
132         bytes memory data,
133         uint256 value,
134         string memory errorMessage
135     ) internal returns (bytes memory) {
136         require(address(this).balance >= value, "Address: insufficient balance for call");
137         require(isContract(target), "Address: call to non-contract");
138 
139         (bool success, bytes memory returndata) = target.call{value: value}(data);
140         return verifyCallResult(success, returndata, errorMessage);
141     }
142 
143     /**
144      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
145      * but performing a static call.
146      *
147      * _Available since v3.3._
148      */
149     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
150         return functionStaticCall(target, data, "Address: low-level static call failed");
151     }
152 
153     /**
154      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
155      * but performing a static call.
156      *
157      * _Available since v3.3._
158      */
159     function functionStaticCall(
160         address target,
161         bytes memory data,
162         string memory errorMessage
163     ) internal view returns (bytes memory) {
164         require(isContract(target), "Address: static call to non-contract");
165 
166         (bool success, bytes memory returndata) = target.staticcall(data);
167         return verifyCallResult(success, returndata, errorMessage);
168     }
169 
170     /**
171      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
172      * but performing a delegate call.
173      *
174      * _Available since v3.4._
175      */
176     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
177         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
178     }
179 
180     /**
181      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
182      * but performing a delegate call.
183      *
184      * _Available since v3.4._
185      */
186     function functionDelegateCall(
187         address target,
188         bytes memory data,
189         string memory errorMessage
190     ) internal returns (bytes memory) {
191         require(isContract(target), "Address: delegate call to non-contract");
192 
193         (bool success, bytes memory returndata) = target.delegatecall(data);
194         return verifyCallResult(success, returndata, errorMessage);
195     }
196 
197     /**
198      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
199      * revert reason using the provided one.
200      *
201      * _Available since v4.3._
202      */
203     function verifyCallResult(
204         bool success,
205         bytes memory returndata,
206         string memory errorMessage
207     ) internal pure returns (bytes memory) {
208         if (success) {
209             return returndata;
210         } else {
211             // Look for revert reason and bubble it up if present
212             if (returndata.length > 0) {
213                 // The easiest way to bubble the revert reason is using memory via assembly
214                 /// @solidity memory-safe-assembly
215                 assembly {
216                     let returndata_size := mload(returndata)
217                     revert(add(32, returndata), returndata_size)
218                 }
219             } else {
220                 revert(errorMessage);
221             }
222         }
223     }
224 }
225 
226 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
227 
228 
229 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
230 
231 pragma solidity ^0.8.0;
232 
233 /**
234  * @title ERC721 token receiver interface
235  * @dev Interface for any contract that wants to support safeTransfers
236  * from ERC721 asset contracts.
237  */
238 interface IERC721Receiver {
239     /**
240      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
241      * by `operator` from `from`, this function is called.
242      *
243      * It must return its Solidity selector to confirm the token transfer.
244      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
245      *
246      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
247      */
248     function onERC721Received(
249         address operator,
250         address from,
251         uint256 tokenId,
252         bytes calldata data
253     ) external returns (bytes4);
254 }
255 
256 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
257 
258 
259 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
260 
261 pragma solidity ^0.8.0;
262 
263 /**
264  * @dev Interface of the ERC165 standard, as defined in the
265  * https://eips.ethereum.org/EIPS/eip-165[EIP].
266  *
267  * Implementers can declare support of contract interfaces, which can then be
268  * queried by others ({ERC165Checker}).
269  *
270  * For an implementation, see {ERC165}.
271  */
272 interface IERC165 {
273     /**
274      * @dev Returns true if this contract implements the interface defined by
275      * `interfaceId`. See the corresponding
276      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
277      * to learn more about how these ids are created.
278      *
279      * This function call must use less than 30 000 gas.
280      */
281     function supportsInterface(bytes4 interfaceId) external view returns (bool);
282 }
283 
284 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
285 
286 
287 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
288 
289 pragma solidity ^0.8.0;
290 
291 
292 /**
293  * @dev Implementation of the {IERC165} interface.
294  *
295  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
296  * for the additional interface id that will be supported. For example:
297  *
298  * ```solidity
299  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
300  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
301  * }
302  * ```
303  *
304  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
305  */
306 abstract contract ERC165 is IERC165 {
307     /**
308      * @dev See {IERC165-supportsInterface}.
309      */
310     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
311         return interfaceId == type(IERC165).interfaceId;
312     }
313 }
314 
315 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
316 
317 
318 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
319 
320 pragma solidity ^0.8.0;
321 
322 
323 /**
324  * @dev Required interface of an ERC721 compliant contract.
325  */
326 interface IERC721 is IERC165 {
327     /**
328      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
329      */
330     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
331 
332     /**
333      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
334      */
335     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
336 
337     /**
338      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
339      */
340     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
341 
342     /**
343      * @dev Returns the number of tokens in ``owner``'s account.
344      */
345     function balanceOf(address owner) external view returns (uint256 balance);
346 
347     /**
348      * @dev Returns the owner of the `tokenId` token.
349      *
350      * Requirements:
351      *
352      * - `tokenId` must exist.
353      */
354     function ownerOf(uint256 tokenId) external view returns (address owner);
355 
356     /**
357      * @dev Safely transfers `tokenId` token from `from` to `to`.
358      *
359      * Requirements:
360      *
361      * - `from` cannot be the zero address.
362      * - `to` cannot be the zero address.
363      * - `tokenId` token must exist and be owned by `from`.
364      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
365      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
366      *
367      * Emits a {Transfer} event.
368      */
369     function safeTransferFrom(
370         address from,
371         address to,
372         uint256 tokenId,
373         bytes calldata data
374     ) external;
375 
376     /**
377      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
378      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
379      *
380      * Requirements:
381      *
382      * - `from` cannot be the zero address.
383      * - `to` cannot be the zero address.
384      * - `tokenId` token must exist and be owned by `from`.
385      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
386      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
387      *
388      * Emits a {Transfer} event.
389      */
390     function safeTransferFrom(
391         address from,
392         address to,
393         uint256 tokenId
394     ) external;
395 
396     /**
397      * @dev Transfers `tokenId` token from `from` to `to`.
398      *
399      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
400      *
401      * Requirements:
402      *
403      * - `from` cannot be the zero address.
404      * - `to` cannot be the zero address.
405      * - `tokenId` token must be owned by `from`.
406      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
407      *
408      * Emits a {Transfer} event.
409      */
410     function transferFrom(
411         address from,
412         address to,
413         uint256 tokenId
414     ) external;
415 
416     /**
417      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
418      * The approval is cleared when the token is transferred.
419      *
420      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
421      *
422      * Requirements:
423      *
424      * - The caller must own the token or be an approved operator.
425      * - `tokenId` must exist.
426      *
427      * Emits an {Approval} event.
428      */
429     function approve(address to, uint256 tokenId) external;
430 
431     /**
432      * @dev Approve or remove `operator` as an operator for the caller.
433      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
434      *
435      * Requirements:
436      *
437      * - The `operator` cannot be the caller.
438      *
439      * Emits an {ApprovalForAll} event.
440      */
441     function setApprovalForAll(address operator, bool _approved) external;
442 
443     /**
444      * @dev Returns the account approved for `tokenId` token.
445      *
446      * Requirements:
447      *
448      * - `tokenId` must exist.
449      */
450     function getApproved(uint256 tokenId) external view returns (address operator);
451 
452     /**
453      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
454      *
455      * See {setApprovalForAll}
456      */
457     function isApprovedForAll(address owner, address operator) external view returns (bool);
458 }
459 
460 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
461 
462 
463 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
464 
465 pragma solidity ^0.8.0;
466 
467 
468 /**
469  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
470  * @dev See https://eips.ethereum.org/EIPS/eip-721
471  */
472 interface IERC721Enumerable is IERC721 {
473     /**
474      * @dev Returns the total amount of tokens stored by the contract.
475      */
476     function totalSupply() external view returns (uint256);
477 
478     /**
479      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
480      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
481      */
482     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
483 
484     /**
485      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
486      * Use along with {totalSupply} to enumerate all tokens.
487      */
488     function tokenByIndex(uint256 index) external view returns (uint256);
489 }
490 
491 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
492 
493 
494 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
495 
496 pragma solidity ^0.8.0;
497 
498 
499 /**
500  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
501  * @dev See https://eips.ethereum.org/EIPS/eip-721
502  */
503 interface IERC721Metadata is IERC721 {
504     /**
505      * @dev Returns the token collection name.
506      */
507     function name() external view returns (string memory);
508 
509     /**
510      * @dev Returns the token collection symbol.
511      */
512     function symbol() external view returns (string memory);
513 
514     /**
515      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
516      */
517     function tokenURI(uint256 tokenId) external view returns (string memory);
518 }
519 
520 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
521 
522 
523 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
524 
525 pragma solidity ^0.8.0;
526 
527 /**
528  * @dev Contract module that helps prevent reentrant calls to a function.
529  *
530  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
531  * available, which can be applied to functions to make sure there are no nested
532  * (reentrant) calls to them.
533  *
534  * Note that because there is a single `nonReentrant` guard, functions marked as
535  * `nonReentrant` may not call one another. This can be worked around by making
536  * those functions `private`, and then adding `external` `nonReentrant` entry
537  * points to them.
538  *
539  * TIP: If you would like to learn more about reentrancy and alternative ways
540  * to protect against it, check out our blog post
541  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
542  */
543 abstract contract ReentrancyGuard {
544     // Booleans are more expensive than uint256 or any type that takes up a full
545     // word because each write operation emits an extra SLOAD to first read the
546     // slot's contents, replace the bits taken up by the boolean, and then write
547     // back. This is the compiler's defense against contract upgrades and
548     // pointer aliasing, and it cannot be disabled.
549 
550     // The values being non-zero value makes deployment a bit more expensive,
551     // but in exchange the refund on every call to nonReentrant will be lower in
552     // amount. Since refunds are capped to a percentage of the total
553     // transaction's gas, it is best to keep them low in cases like this one, to
554     // increase the likelihood of the full refund coming into effect.
555     uint256 private constant _NOT_ENTERED = 1;
556     uint256 private constant _ENTERED = 2;
557 
558     uint256 private _status;
559 
560     constructor() {
561         _status = _NOT_ENTERED;
562     }
563 
564     /**
565      * @dev Prevents a contract from calling itself, directly or indirectly.
566      * Calling a `nonReentrant` function from another `nonReentrant`
567      * function is not supported. It is possible to prevent this from happening
568      * by making the `nonReentrant` function external, and making it call a
569      * `private` function that does the actual work.
570      */
571     modifier nonReentrant() {
572         // On the first call to nonReentrant, _notEntered will be true
573         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
574 
575         // Any calls to nonReentrant after this point will fail
576         _status = _ENTERED;
577 
578         _;
579 
580         // By storing the original value once again, a refund is triggered (see
581         // https://eips.ethereum.org/EIPS/eip-2200)
582         _status = _NOT_ENTERED;
583     }
584 }
585 
586 // File: @openzeppelin/contracts/utils/Strings.sol
587 
588 
589 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
590 
591 pragma solidity ^0.8.0;
592 
593 /**
594  * @dev String operations.
595  */
596 library Strings {
597     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
598     uint8 private constant _ADDRESS_LENGTH = 20;
599 
600     /**
601      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
602      */
603     function toString(uint256 value) internal pure returns (string memory) {
604         // Inspired by OraclizeAPI's implementation - MIT licence
605         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
606 
607         if (value == 0) {
608             return "0";
609         }
610         uint256 temp = value;
611         uint256 digits;
612         while (temp != 0) {
613             digits++;
614             temp /= 10;
615         }
616         bytes memory buffer = new bytes(digits);
617         while (value != 0) {
618             digits -= 1;
619             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
620             value /= 10;
621         }
622         return string(buffer);
623     }
624 
625     /**
626      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
627      */
628     function toHexString(uint256 value) internal pure returns (string memory) {
629         if (value == 0) {
630             return "0x00";
631         }
632         uint256 temp = value;
633         uint256 length = 0;
634         while (temp != 0) {
635             length++;
636             temp >>= 8;
637         }
638         return toHexString(value, length);
639     }
640 
641     /**
642      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
643      */
644     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
645         bytes memory buffer = new bytes(2 * length + 2);
646         buffer[0] = "0";
647         buffer[1] = "x";
648         for (uint256 i = 2 * length + 1; i > 1; --i) {
649             buffer[i] = _HEX_SYMBOLS[value & 0xf];
650             value >>= 4;
651         }
652         require(value == 0, "Strings: hex length insufficient");
653         return string(buffer);
654     }
655 
656     /**
657      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
658      */
659     function toHexString(address addr) internal pure returns (string memory) {
660         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
661     }
662 }
663 
664 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
665 
666 
667 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/ECDSA.sol)
668 
669 pragma solidity ^0.8.0;
670 
671 
672 /**
673  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
674  *
675  * These functions can be used to verify that a message was signed by the holder
676  * of the private keys of a given address.
677  */
678 library ECDSA {
679     enum RecoverError {
680         NoError,
681         InvalidSignature,
682         InvalidSignatureLength,
683         InvalidSignatureS,
684         InvalidSignatureV
685     }
686 
687     function _throwError(RecoverError error) private pure {
688         if (error == RecoverError.NoError) {
689             return; // no error: do nothing
690         } else if (error == RecoverError.InvalidSignature) {
691             revert("ECDSA: invalid signature");
692         } else if (error == RecoverError.InvalidSignatureLength) {
693             revert("ECDSA: invalid signature length");
694         } else if (error == RecoverError.InvalidSignatureS) {
695             revert("ECDSA: invalid signature 's' value");
696         } else if (error == RecoverError.InvalidSignatureV) {
697             revert("ECDSA: invalid signature 'v' value");
698         }
699     }
700 
701     /**
702      * @dev Returns the address that signed a hashed message (`hash`) with
703      * `signature` or error string. This address can then be used for verification purposes.
704      *
705      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
706      * this function rejects them by requiring the `s` value to be in the lower
707      * half order, and the `v` value to be either 27 or 28.
708      *
709      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
710      * verification to be secure: it is possible to craft signatures that
711      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
712      * this is by receiving a hash of the original message (which may otherwise
713      * be too long), and then calling {toEthSignedMessageHash} on it.
714      *
715      * Documentation for signature generation:
716      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
717      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
718      *
719      * _Available since v4.3._
720      */
721     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
722         // Check the signature length
723         // - case 65: r,s,v signature (standard)
724         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
725         if (signature.length == 65) {
726             bytes32 r;
727             bytes32 s;
728             uint8 v;
729             // ecrecover takes the signature parameters, and the only way to get them
730             // currently is to use assembly.
731             /// @solidity memory-safe-assembly
732             assembly {
733                 r := mload(add(signature, 0x20))
734                 s := mload(add(signature, 0x40))
735                 v := byte(0, mload(add(signature, 0x60)))
736             }
737             return tryRecover(hash, v, r, s);
738         } else if (signature.length == 64) {
739             bytes32 r;
740             bytes32 vs;
741             // ecrecover takes the signature parameters, and the only way to get them
742             // currently is to use assembly.
743             /// @solidity memory-safe-assembly
744             assembly {
745                 r := mload(add(signature, 0x20))
746                 vs := mload(add(signature, 0x40))
747             }
748             return tryRecover(hash, r, vs);
749         } else {
750             return (address(0), RecoverError.InvalidSignatureLength);
751         }
752     }
753 
754     /**
755      * @dev Returns the address that signed a hashed message (`hash`) with
756      * `signature`. This address can then be used for verification purposes.
757      *
758      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
759      * this function rejects them by requiring the `s` value to be in the lower
760      * half order, and the `v` value to be either 27 or 28.
761      *
762      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
763      * verification to be secure: it is possible to craft signatures that
764      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
765      * this is by receiving a hash of the original message (which may otherwise
766      * be too long), and then calling {toEthSignedMessageHash} on it.
767      */
768     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
769         (address recovered, RecoverError error) = tryRecover(hash, signature);
770         _throwError(error);
771         return recovered;
772     }
773 
774     /**
775      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
776      *
777      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
778      *
779      * _Available since v4.3._
780      */
781     function tryRecover(
782         bytes32 hash,
783         bytes32 r,
784         bytes32 vs
785     ) internal pure returns (address, RecoverError) {
786         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
787         uint8 v = uint8((uint256(vs) >> 255) + 27);
788         return tryRecover(hash, v, r, s);
789     }
790 
791     /**
792      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
793      *
794      * _Available since v4.2._
795      */
796     function recover(
797         bytes32 hash,
798         bytes32 r,
799         bytes32 vs
800     ) internal pure returns (address) {
801         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
802         _throwError(error);
803         return recovered;
804     }
805 
806     /**
807      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
808      * `r` and `s` signature fields separately.
809      *
810      * _Available since v4.3._
811      */
812     function tryRecover(
813         bytes32 hash,
814         uint8 v,
815         bytes32 r,
816         bytes32 s
817     ) internal pure returns (address, RecoverError) {
818         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
819         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
820         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
821         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
822         //
823         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
824         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
825         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
826         // these malleable signatures as well.
827         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
828             return (address(0), RecoverError.InvalidSignatureS);
829         }
830         if (v != 27 && v != 28) {
831             return (address(0), RecoverError.InvalidSignatureV);
832         }
833 
834         // If the signature is valid (and not malleable), return the signer address
835         address signer = ecrecover(hash, v, r, s);
836         if (signer == address(0)) {
837             return (address(0), RecoverError.InvalidSignature);
838         }
839 
840         return (signer, RecoverError.NoError);
841     }
842 
843     /**
844      * @dev Overload of {ECDSA-recover} that receives the `v`,
845      * `r` and `s` signature fields separately.
846      */
847     function recover(
848         bytes32 hash,
849         uint8 v,
850         bytes32 r,
851         bytes32 s
852     ) internal pure returns (address) {
853         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
854         _throwError(error);
855         return recovered;
856     }
857 
858     /**
859      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
860      * produces hash corresponding to the one signed with the
861      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
862      * JSON-RPC method as part of EIP-191.
863      *
864      * See {recover}.
865      */
866     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
867         // 32 is the length in bytes of hash,
868         // enforced by the type signature above
869         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
870     }
871 
872     /**
873      * @dev Returns an Ethereum Signed Message, created from `s`. This
874      * produces hash corresponding to the one signed with the
875      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
876      * JSON-RPC method as part of EIP-191.
877      *
878      * See {recover}.
879      */
880     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
881         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
882     }
883 
884     /**
885      * @dev Returns an Ethereum Signed Typed Data, created from a
886      * `domainSeparator` and a `structHash`. This produces hash corresponding
887      * to the one signed with the
888      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
889      * JSON-RPC method as part of EIP-712.
890      *
891      * See {recover}.
892      */
893     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
894         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
895     }
896 }
897 
898 // File: @openzeppelin/contracts/utils/Context.sol
899 
900 
901 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
902 
903 pragma solidity ^0.8.0;
904 
905 /**
906  * @dev Provides information about the current execution context, including the
907  * sender of the transaction and its data. While these are generally available
908  * via msg.sender and msg.data, they should not be accessed in such a direct
909  * manner, since when dealing with meta-transactions the account sending and
910  * paying for execution may not be the actual sender (as far as an application
911  * is concerned).
912  *
913  * This contract is only required for intermediate, library-like contracts.
914  */
915 abstract contract Context {
916     function _msgSender() internal view virtual returns (address) {
917         return msg.sender;
918     }
919 
920     function _msgData() internal view virtual returns (bytes calldata) {
921         return msg.data;
922     }
923 }
924 
925 // File: contracts/ERC721A.sol
926 
927 
928 
929 pragma solidity ^0.8.0;
930 
931 
932 
933 
934 
935 
936 
937 
938 
939 /**
940  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
941  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
942  *
943  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
944  *
945  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
946  *
947  * Does not support burning tokens to address(0).
948  */
949 contract ERC721A is
950 Context,
951 ERC165,
952 IERC721,
953 IERC721Metadata,
954 IERC721Enumerable
955 {
956     using Address for address;
957     using Strings for uint256;
958 
959     struct TokenOwnership {
960         address addr;
961         uint64 startTimestamp;
962     }
963 
964     struct AddressData {
965         uint128 balance;
966         uint128 numberMinted;
967     }
968 
969     uint256 private currentIndex = 0;
970 
971     uint256 internal immutable collectionSize;
972     uint256 internal immutable maxBatchSize;
973 
974     // Token name
975     string private _name;
976 
977     // Token symbol
978     string private _symbol;
979 
980     // Mapping from token ID to ownership details
981     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
982     mapping(uint256 => TokenOwnership) private _ownerships;
983 
984     // Mapping owner address to address data
985     mapping(address => AddressData) private _addressData;
986 
987     // Mapping from token ID to approved address
988     mapping(uint256 => address) private _tokenApprovals;
989 
990     // Mapping from owner to operator approvals
991     mapping(address => mapping(address => bool)) private _operatorApprovals;
992 
993     /**
994      * @dev
995    * `maxBatchSize` refers to how much a minter can mint at a time.
996    * `collectionSize_` refers to how many tokens are in the collection.
997    */
998     constructor(
999         string memory name_,
1000         string memory symbol_,
1001         uint256 maxBatchSize_,
1002         uint256 collectionSize_
1003     ) {
1004         require(
1005             collectionSize_ > 0,
1006             "ERC721A: collection must have a nonzero supply"
1007         );
1008         require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1009         _name = name_;
1010         _symbol = symbol_;
1011         maxBatchSize = maxBatchSize_;
1012         collectionSize = collectionSize_;
1013     }
1014 
1015     /**
1016      * @dev See {IERC721Enumerable-totalSupply}.
1017    */
1018     function totalSupply() public view override returns (uint256) {
1019         return currentIndex;
1020     }
1021 
1022     /**
1023      * @dev See {IERC721Enumerable-tokenByIndex}.
1024    */
1025     function tokenByIndex(uint256 index) public view override returns (uint256) {
1026         require(index < totalSupply(), "ERC721A: global index out of bounds");
1027         return index;
1028     }
1029 
1030     /**
1031      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1032    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1033    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1034    */
1035     function tokenOfOwnerByIndex(address owner, uint256 index)
1036     public
1037     view
1038     override
1039     returns (uint256)
1040     {
1041         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1042         uint256 numMintedSoFar = totalSupply();
1043         uint256 tokenIdsIdx = 0;
1044         address currOwnershipAddr = address(0);
1045         for (uint256 i = 0; i < numMintedSoFar; i++) {
1046             TokenOwnership memory ownership = _ownerships[i];
1047             if (ownership.addr != address(0)) {
1048                 currOwnershipAddr = ownership.addr;
1049             }
1050             if (currOwnershipAddr == owner) {
1051                 if (tokenIdsIdx == index) {
1052                     return i;
1053                 }
1054                 tokenIdsIdx++;
1055             }
1056         }
1057         revert("ERC721A: unable to get token of owner by index");
1058     }
1059 
1060     /**
1061      * @dev See {IERC165-supportsInterface}.
1062    */
1063     function supportsInterface(bytes4 interfaceId)
1064     public
1065     view
1066     virtual
1067     override(ERC165, IERC165)
1068     returns (bool)
1069     {
1070         return
1071         interfaceId == type(IERC721).interfaceId ||
1072         interfaceId == type(IERC721Metadata).interfaceId ||
1073         interfaceId == type(IERC721Enumerable).interfaceId ||
1074         super.supportsInterface(interfaceId);
1075     }
1076 
1077     /**
1078      * @dev See {IERC721-balanceOf}.
1079    */
1080     function balanceOf(address owner) public view override returns (uint256) {
1081         require(owner != address(0), "ERC721A: balance query for the zero address");
1082         return uint256(_addressData[owner].balance);
1083     }
1084 
1085     function _numberMinted(address owner) internal view returns (uint256) {
1086         require(
1087             owner != address(0),
1088             "ERC721A: number minted query for the zero address"
1089         );
1090         return uint256(_addressData[owner].numberMinted);
1091     }
1092 
1093     function ownershipOf(uint256 tokenId)
1094     internal
1095     view
1096     returns (TokenOwnership memory)
1097     {
1098         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1099 
1100         uint256 lowestTokenToCheck;
1101         if (tokenId >= maxBatchSize) {
1102             lowestTokenToCheck = tokenId - maxBatchSize + 1;
1103         }
1104 
1105         for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
1106             TokenOwnership memory ownership = _ownerships[curr];
1107             if (ownership.addr != address(0)) {
1108                 return ownership;
1109             }
1110         }
1111 
1112         revert("ERC721A: unable to determine the owner of token");
1113     }
1114 
1115     /**
1116      * @dev See {IERC721-ownerOf}.
1117    */
1118     function ownerOf(uint256 tokenId) public view override returns (address) {
1119         return ownershipOf(tokenId).addr;
1120     }
1121 
1122     /**
1123      * @dev See {IERC721Metadata-name}.
1124    */
1125     function name() public view virtual override returns (string memory) {
1126         return _name;
1127     }
1128 
1129     /**
1130      * @dev See {IERC721Metadata-symbol}.
1131    */
1132     function symbol() public view virtual override returns (string memory) {
1133         return _symbol;
1134     }
1135 
1136     /**
1137      * @dev See {IERC721Metadata-tokenURI}.
1138    */
1139     function tokenURI(uint256 tokenId)
1140     public
1141     view
1142     virtual
1143     override
1144     returns (string memory)
1145     {
1146         require(
1147             _exists(tokenId),
1148             "ERC721Metadata: URI query for nonexistent token"
1149         );
1150 
1151         string memory baseURI = _baseURI();
1152         return
1153         bytes(baseURI).length > 0
1154         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1155         : "";
1156     }
1157 
1158     /**
1159      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1160    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1161    * by default, can be overriden in child contracts.
1162    */
1163     function _baseURI() internal view virtual returns (string memory) {
1164         return "";
1165     }
1166 
1167     /**
1168      * @dev See {IERC721-approve}.
1169    */
1170     function approve(address to, uint256 tokenId) public override {
1171         address owner = ERC721A.ownerOf(tokenId);
1172         require(to != owner, "ERC721A: approval to current owner");
1173 
1174         require(
1175             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1176             "ERC721A: approve caller is not owner nor approved for all"
1177         );
1178 
1179         _approve(to, tokenId, owner);
1180     }
1181 
1182     /**
1183      * @dev See {IERC721-getApproved}.
1184    */
1185     function getApproved(uint256 tokenId) public view override returns (address) {
1186         require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1187 
1188         return _tokenApprovals[tokenId];
1189     }
1190 
1191     /**
1192      * @dev See {IERC721-setApprovalForAll}.
1193    */
1194     function setApprovalForAll(address operator, bool approved) public override {
1195         require(operator != _msgSender(), "ERC721A: approve to caller");
1196 
1197         _operatorApprovals[_msgSender()][operator] = approved;
1198         emit ApprovalForAll(_msgSender(), operator, approved);
1199     }
1200 
1201     /**
1202      * @dev See {IERC721-isApprovedForAll}.
1203    */
1204     function isApprovedForAll(address owner, address operator)
1205     public
1206     view
1207     virtual
1208     override
1209     returns (bool)
1210     {
1211         return _operatorApprovals[owner][operator];
1212     }
1213 
1214     /**
1215      * @dev See {IERC721-transferFrom}.
1216    */
1217     function transferFrom(
1218         address from,
1219         address to,
1220         uint256 tokenId
1221     ) public override {
1222         _transfer(from, to, tokenId);
1223     }
1224 
1225     /**
1226      * @dev See {IERC721-safeTransferFrom}.
1227    */
1228     function safeTransferFrom(
1229         address from,
1230         address to,
1231         uint256 tokenId
1232     ) public override {
1233         safeTransferFrom(from, to, tokenId, "");
1234     }
1235 
1236     /**
1237      * @dev See {IERC721-safeTransferFrom}.
1238    */
1239     function safeTransferFrom(
1240         address from,
1241         address to,
1242         uint256 tokenId,
1243         bytes memory _data
1244     ) public override {
1245         _transfer(from, to, tokenId);
1246         require(
1247             _checkOnERC721Received(from, to, tokenId, _data),
1248             "ERC721A: transfer to non ERC721Receiver implementer"
1249         );
1250     }
1251 
1252     /**
1253      * @dev Returns whether `tokenId` exists.
1254    *
1255    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1256    *
1257    * Tokens start existing when they are minted (`_mint`),
1258    */
1259     function _exists(uint256 tokenId) internal view returns (bool) {
1260         return tokenId < currentIndex;
1261     }
1262 
1263     function _safeMint(address to, uint256 quantity) internal {
1264         _safeMint(to, quantity, "");
1265     }
1266 
1267     /**
1268      * @dev Mints `quantity` tokens and transfers them to `to`.
1269    *
1270    * Requirements:
1271    *
1272    * - there must be `quantity` tokens remaining unminted in the total collection.
1273    * - `to` cannot be the zero address.
1274    * - `quantity` cannot be larger than the max batch size.
1275    *
1276    * Emits a {Transfer} event.
1277    */
1278     function _safeMint(
1279         address to,
1280         uint256 quantity,
1281         bytes memory _data
1282     ) internal {
1283         uint256 startTokenId = currentIndex;
1284         require(to != address(0), "ERC721A: mint to the zero address");
1285         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1286         require(!_exists(startTokenId), "ERC721A: token already minted");
1287         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1288 
1289         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1290 
1291         AddressData memory addressData = _addressData[to];
1292         _addressData[to] = AddressData(
1293             addressData.balance + uint128(quantity),
1294             addressData.numberMinted + uint128(quantity)
1295         );
1296         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1297 
1298         uint256 updatedIndex = startTokenId;
1299 
1300         for (uint256 i = 0; i < quantity; i++) {
1301             emit Transfer(address(0), to, updatedIndex);
1302             require(
1303                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
1304                 "ERC721A: transfer to non ERC721Receiver implementer"
1305             );
1306             updatedIndex++;
1307         }
1308 
1309         currentIndex = updatedIndex;
1310         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1311     }
1312 
1313     /**
1314      * @dev Transfers `tokenId` from `from` to `to`.
1315    *
1316    * Requirements:
1317    *
1318    * - `to` cannot be the zero address.
1319    * - `tokenId` token must be owned by `from`.
1320    *
1321    * Emits a {Transfer} event.
1322    */
1323     function _transfer(
1324         address from,
1325         address to,
1326         uint256 tokenId
1327     ) private {
1328         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1329 
1330         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1331         getApproved(tokenId) == _msgSender() ||
1332         isApprovedForAll(prevOwnership.addr, _msgSender()));
1333 
1334         require(
1335             isApprovedOrOwner,
1336             "ERC721A: transfer caller is not owner nor approved"
1337         );
1338 
1339         require(
1340             prevOwnership.addr == from,
1341             "ERC721A: transfer from incorrect owner"
1342         );
1343         require(to != address(0), "ERC721A: transfer to the zero address");
1344 
1345         _beforeTokenTransfers(from, to, tokenId, 1);
1346 
1347         // Clear approvals from the previous owner
1348         _approve(address(0), tokenId, prevOwnership.addr);
1349 
1350         _addressData[from].balance -= 1;
1351         _addressData[to].balance += 1;
1352         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1353 
1354         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1355         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1356         uint256 nextTokenId = tokenId + 1;
1357         if (_ownerships[nextTokenId].addr == address(0)) {
1358             if (_exists(nextTokenId)) {
1359                 _ownerships[nextTokenId] = TokenOwnership(
1360                     prevOwnership.addr,
1361                     prevOwnership.startTimestamp
1362                 );
1363             }
1364         }
1365 
1366         emit Transfer(from, to, tokenId);
1367         _afterTokenTransfers(from, to, tokenId, 1);
1368     }
1369 
1370     /**
1371      * @dev Approve `to` to operate on `tokenId`
1372    *
1373    * Emits a {Approval} event.
1374    */
1375     function _approve(
1376         address to,
1377         uint256 tokenId,
1378         address owner
1379     ) private {
1380         _tokenApprovals[tokenId] = to;
1381         emit Approval(owner, to, tokenId);
1382     }
1383 
1384     uint256 public nextOwnerToExplicitlySet = 0;
1385 
1386     /**
1387      * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1388    */
1389     function _setOwnersExplicit(uint256 quantity) internal {
1390         uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1391         require(quantity > 0, "quantity must be nonzero");
1392         uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1393         if (endIndex > collectionSize - 1) {
1394             endIndex = collectionSize - 1;
1395         }
1396         // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1397         require(_exists(endIndex), "not enough minted yet for this cleanup");
1398         for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1399             if (_ownerships[i].addr == address(0)) {
1400                 TokenOwnership memory ownership = ownershipOf(i);
1401                 _ownerships[i] = TokenOwnership(
1402                     ownership.addr,
1403                     ownership.startTimestamp
1404                 );
1405             }
1406         }
1407         nextOwnerToExplicitlySet = endIndex + 1;
1408     }
1409 
1410     /**
1411      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1412    * The call is not executed if the target address is not a contract.
1413    *
1414    * @param from address representing the previous owner of the given token ID
1415    * @param to target address that will receive the tokens
1416    * @param tokenId uint256 ID of the token to be transferred
1417    * @param _data bytes optional data to send along with the call
1418    * @return bool whether the call correctly returned the expected magic value
1419    */
1420     function _checkOnERC721Received(
1421         address from,
1422         address to,
1423         uint256 tokenId,
1424         bytes memory _data
1425     ) private returns (bool) {
1426         if (to.isContract()) {
1427             try
1428             IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1429             returns (bytes4 retval) {
1430                 return retval == IERC721Receiver(to).onERC721Received.selector;
1431             } catch (bytes memory reason) {
1432                 if (reason.length == 0) {
1433                     revert("ERC721A: transfer to non ERC721Receiver implementer");
1434                 } else {
1435                     assembly {
1436                         revert(add(32, reason), mload(reason))
1437                     }
1438                 }
1439             }
1440         } else {
1441             return true;
1442         }
1443     }
1444 
1445     /**
1446      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1447    *
1448    * startTokenId - the first token id to be transferred
1449    * quantity - the amount to be transferred
1450    *
1451    * Calling conditions:
1452    *
1453    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1454    * transferred to `to`.
1455    * - When `from` is zero, `tokenId` will be minted for `to`.
1456    */
1457     function _beforeTokenTransfers(
1458         address from,
1459         address to,
1460         uint256 startTokenId,
1461         uint256 quantity
1462     ) internal virtual {}
1463 
1464     /**
1465      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1466    * minting.
1467    *
1468    * startTokenId - the first token id to be transferred
1469    * quantity - the amount to be transferred
1470    *
1471    * Calling conditions:
1472    *
1473    * - when `from` and `to` are both non-zero.
1474    * - `from` and `to` are never both zero.
1475    */
1476     function _afterTokenTransfers(
1477         address from,
1478         address to,
1479         uint256 startTokenId,
1480         uint256 quantity
1481     ) internal virtual {}
1482 }
1483 // File: @openzeppelin/contracts/access/Ownable.sol
1484 
1485 
1486 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1487 
1488 pragma solidity ^0.8.0;
1489 
1490 
1491 /**
1492  * @dev Contract module which provides a basic access control mechanism, where
1493  * there is an account (an owner) that can be granted exclusive access to
1494  * specific functions.
1495  *
1496  * By default, the owner account will be the one that deploys the contract. This
1497  * can later be changed with {transferOwnership}.
1498  *
1499  * This module is used through inheritance. It will make available the modifier
1500  * `onlyOwner`, which can be applied to your functions to restrict their use to
1501  * the owner.
1502  */
1503 abstract contract Ownable is Context {
1504     address private _owner;
1505 
1506     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1507 
1508     /**
1509      * @dev Initializes the contract setting the deployer as the initial owner.
1510      */
1511     constructor() {
1512         _transferOwnership(_msgSender());
1513     }
1514 
1515     /**
1516      * @dev Throws if called by any account other than the owner.
1517      */
1518     modifier onlyOwner() {
1519         _checkOwner();
1520         _;
1521     }
1522 
1523     /**
1524      * @dev Returns the address of the current owner.
1525      */
1526     function owner() public view virtual returns (address) {
1527         return _owner;
1528     }
1529 
1530     /**
1531      * @dev Throws if the sender is not the owner.
1532      */
1533     function _checkOwner() internal view virtual {
1534         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1535     }
1536 
1537     /**
1538      * @dev Leaves the contract without owner. It will not be possible to call
1539      * `onlyOwner` functions anymore. Can only be called by the current owner.
1540      *
1541      * NOTE: Renouncing ownership will leave the contract without an owner,
1542      * thereby removing any functionality that is only available to the owner.
1543      */
1544     function renounceOwnership() public virtual onlyOwner {
1545         _transferOwnership(address(0));
1546     }
1547 
1548     /**
1549      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1550      * Can only be called by the current owner.
1551      */
1552     function transferOwnership(address newOwner) public virtual onlyOwner {
1553         require(newOwner != address(0), "Ownable: new owner is the zero address");
1554         _transferOwnership(newOwner);
1555     }
1556 
1557     /**
1558      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1559      * Internal function without access restriction.
1560      */
1561     function _transferOwnership(address newOwner) internal virtual {
1562         address oldOwner = _owner;
1563         _owner = newOwner;
1564         emit OwnershipTransferred(oldOwner, newOwner);
1565     }
1566 }
1567 
1568 // File: contracts/LastHopium.sol
1569 
1570 
1571 
1572 pragma solidity ^0.8.0;
1573 
1574 //import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
1575 
1576 
1577 
1578 
1579 
1580 interface IStaking {
1581     function addTokensToStake(address account, uint16[] calldata tokenIds) external;
1582 }
1583 
1584 contract LastHopium is ERC721A, Ownable, ReentrancyGuard {
1585     using Strings for uint256;
1586     using Strings for uint16;
1587     using ECDSA for bytes32;
1588 
1589     string  public baseURI;
1590 
1591     mapping(uint16 => uint8) public distributionMinted; // 3 - gold, 2 - silver, 1 - bronze
1592     uint8 constant private GOLD = 3;
1593     uint8 constant private SILVER = 2;
1594     uint8 constant private BRONZE = 1;
1595     mapping(address => uint16) public addressMinted; // store minted per wallet. This is to avoid balanceOf as user may got via other transfers like P2P or OS
1596 
1597     uint256 public privateSalePrice = 0.2 ether;
1598     uint16 constant public MAX_SUPPLY = 5000;
1599     uint16 constant public _300SilverSupply = 1500; // private sale max supply for the whitelisted address
1600     uint16 public _300Minted = 0;
1601 
1602     uint16 public bronzeMinted = 0;
1603     uint16 constant public totalBronzeSupply = 3000;
1604     uint16 constant public privateBronzeSupply = 3000;
1605     uint256 public bronzePrice = 0.22 ether;
1606 
1607     uint16 public silverMinted = 0;
1608     uint16 constant public totalSilverSupply = 1500;
1609     uint256 public silverPrice = 0.33 ether;
1610 
1611     uint16 public goldMinted = 0;
1612     uint16 constant public totalGoldSupply = 500;
1613     uint256 public goldPrice = 0.55 ether;
1614 
1615     uint16 public mint_per_tx_private = 1;
1616     uint16 public max_per_wallet_private = 2;
1617 
1618     uint16 public mint_per_tx = 5;
1619     uint16 public max_per_wallet = 5;
1620 
1621     bool public publicSale = true; // state of public minting
1622     bool public privateSale = true; // state of private(whitelisted access) sale
1623     bool public pause = false; // pause or resume general minting
1624 
1625     address public _300SilverSigner; //silver
1626     address public bronzeSigner;
1627     address public goldSigner;
1628 
1629     event LastMinted(address _minter, uint tokenId);
1630 
1631     IStaking public staking;
1632 
1633     constructor() ERC721A("Last Hopium", "LH", 50, MAX_SUPPLY) {}
1634 
1635     // if contract minting is paused
1636     modifier whenNotPaused() {
1637         require(pause == false, "Minting is paused");
1638         _;
1639     }
1640 
1641     modifier whenNotPausedPublic() {
1642         require(publicSale == true, "Public Minting is paused");
1643         _;
1644     }
1645 
1646     modifier whenNotPausedPrivate() {
1647         require(privateSale == true, "Private Minting is paused");
1648         _;
1649     }
1650 
1651     function _baseURI() internal view virtual override returns (string memory) {
1652         return baseURI;
1653     }
1654 
1655     function mintBronze(uint16 _mintAmount, bool _stake) external payable whenNotPaused whenNotPausedPublic{
1656         require(bronzeMinted + _mintAmount <= totalBronzeSupply, "Purchase would exceed max supply of Bronze");
1657         bronzeMinted++;
1658         mintX(_mintAmount, bronzePrice, _stake, BRONZE);
1659     }
1660 
1661     function mintSilver(uint16 _mintAmount, bool _stake) external payable whenNotPaused whenNotPausedPublic {
1662         require(silverMinted + _mintAmount <= totalSilverSupply, "Purchase would exceed max supply of Silver");
1663         silverMinted++;
1664         mintX(_mintAmount, silverPrice, _stake, SILVER);
1665     }
1666 
1667     function mintGold(uint16 _mintAmount, bool _stake) external payable whenNotPaused whenNotPausedPublic{
1668         require(goldMinted + _mintAmount <= totalGoldSupply, "Purchase would exceed max supply of Gold");
1669         goldMinted++;
1670         mintX(_mintAmount, goldPrice, _stake, GOLD);
1671     }
1672 
1673     function mintX(uint16 _mintAmount, uint price, bool _stake, uint8 distribution) private {
1674         require(totalSupply() + _mintAmount <= MAX_SUPPLY, "Purchase would exceed max supply of NFT");
1675         require(addressMinted[msg.sender] + _mintAmount <= max_per_wallet, "Exceed max per wallet");
1676         require(_mintAmount > 0, "Amount to mint can not be 0");
1677         require(_mintAmount <= mint_per_tx, "Maximum mint amount exceeded");
1678 
1679         if (msg.sender != owner()) {
1680             require(msg.value == price * _mintAmount, "Amount sent less than the currentPrice");
1681         }
1682 
1683         uint16[] memory tokenIds = _stake ? new uint16[](_mintAmount) : new uint16[](0);
1684 
1685         addressMinted[msg.sender] += _mintAmount;
1686 
1687         uint supply =  uint16(totalSupply());
1688         if (_stake) {
1689             _safeMint(address(staking), _mintAmount);
1690         } else {
1691             _safeMint(msg.sender, _mintAmount);
1692         }
1693 
1694         for (uint8 i = 0; i < _mintAmount; i++) {
1695             uint16 tokenId = uint16(supply + i);
1696             distributionMinted[tokenId] = distribution;
1697             if (_stake) {
1698                 tokenIds[i] = tokenId;
1699             }
1700         }
1701         if (_stake) {
1702             staking.addTokensToStake(msg.sender, tokenIds);
1703         }
1704 
1705     }
1706 
1707     function privateMintSilver_300(uint16 _mintAmount, bytes memory signature, bool _stake) external payable whenNotPaused whenNotPausedPrivate {
1708         address recover = recoverSignerAddress(msg.sender, signature);
1709         require(recover == _300SilverSigner, "Address not whitelisted for this sale distribution");
1710         require(_300Minted + _mintAmount <= _300SilverSupply, "Purchase would exceed max supply of 300 Roles");
1711         silverMinted++;
1712         _300Minted++;
1713         require(msg.value == privateSalePrice * _mintAmount, "Amount sent less than the currentPrice");
1714         _mintPrivate(_mintAmount, _stake, SILVER);
1715     }
1716 
1717     function privateMintBronze(uint16 _mintAmount, bytes memory signature, bool _stake) external payable whenNotPaused whenNotPausedPrivate {
1718         address recover = recoverSignerAddress(msg.sender, signature);
1719         require(recover == bronzeSigner, "Address not whitelisted for this sale distribution");
1720         require(bronzeMinted + _mintAmount <= privateBronzeSupply, "Purchase would exceed max supply of this distribution");
1721         require(msg.value == privateSalePrice * _mintAmount, "Amount sent less than the currentPrice");
1722         bronzeMinted++;
1723         _mintPrivate(_mintAmount, _stake, BRONZE);
1724     }
1725 
1726     function privateMintGold(uint16 _mintAmount, bytes memory signature, bool _stake) external payable whenNotPaused whenNotPausedPrivate {
1727         address recover = recoverSignerAddress(msg.sender, signature);
1728         require(recover == goldSigner, "Address not whitelisted for this sale distribution");
1729         require(goldMinted + _mintAmount <= totalGoldSupply, "Purchase would exceed max supply of this distribution");
1730         require(msg.value == goldPrice * _mintAmount, "Amount sent less than the currentPrice");
1731         goldMinted++;
1732         _mintPrivate(_mintAmount, _stake, GOLD);
1733     }
1734 
1735     function _mintPrivate(uint16 _mintAmount, bool _stake, uint8 distribution) private {
1736 
1737         require(totalSupply() + _mintAmount <= MAX_SUPPLY, "Purchase would exceed max supply of NFT");
1738         require(addressMinted[msg.sender] + _mintAmount <= max_per_wallet_private, "Purchase would exceed max per wallet");
1739         require(_mintAmount > 0, "Amount to mint can not be 0");
1740         require(_mintAmount <= mint_per_tx_private, "Maximum mint amount exceeded");
1741 
1742         uint16[] memory tokenIds = _stake ? new uint16[](_mintAmount) : new uint16[](0);
1743 
1744         uint supply =  uint16(totalSupply());
1745         if (_stake) {
1746             _safeMint(address(staking), _mintAmount);
1747         } else {
1748             _safeMint(msg.sender, _mintAmount);
1749         }
1750 
1751         for (uint8 i = 0; i < _mintAmount; i++) {
1752             uint16 tokenId = uint16(supply + i);
1753             distributionMinted[tokenId] = distribution;
1754             if (_stake) {
1755                 tokenIds[i] = tokenId;
1756             }
1757         }
1758         if (_stake) {
1759             staking.addTokensToStake(msg.sender, tokenIds);
1760         }
1761 
1762         emit LastMinted(msg.sender, totalSupply());
1763 
1764     }
1765 
1766 // TODO: Recalculate base on distribution
1767     function ownerMint(uint16 _mintAmount, uint8 _distribution, bool _stake) external onlyOwner {
1768 
1769         require(totalSupply() + _mintAmount <= MAX_SUPPLY, "Purchase would exceed max supply of NFT");
1770         require(_mintAmount > 0, "Amount to mint can not be 0");
1771         require(_distribution >= BRONZE && _distribution <= GOLD, 'Distribution can only be one of bronze, silver, Gold');
1772 
1773         uint16[] memory tokenIds = _stake ? new uint16[](_mintAmount) : new uint16[](0);
1774         if(_distribution == GOLD){
1775             require(goldMinted + _mintAmount < totalGoldSupply, "mint would exceed max gold supply");
1776             goldMinted += _mintAmount;
1777         }else if(_distribution == SILVER){
1778             require(silverMinted + _mintAmount < totalSilverSupply, "mint would exceed max silver supply");
1779             silverMinted += _mintAmount;
1780         }else {
1781             require(bronzeMinted + _mintAmount < totalBronzeSupply, "mint would exceed max bronze supply");
1782             bronzeMinted += _mintAmount;
1783         }
1784 
1785         uint supply =  uint16(totalSupply());
1786         if (_stake) {
1787             _safeMint(address(staking), _mintAmount);
1788         } else {
1789             _safeMint(msg.sender, _mintAmount);
1790         }
1791 
1792         for (uint8 i = 0; i < _mintAmount; i++) {
1793             uint16 tokenId = uint16(supply + i);
1794             distributionMinted[tokenId] = _distribution;
1795             if (_stake) {
1796                 tokenIds[i] = tokenId;
1797             }
1798         }
1799         if (_stake) {
1800             staking.addTokensToStake(msg.sender, tokenIds);
1801         }
1802         emit LastMinted(msg.sender, totalSupply());
1803 
1804     }
1805 
1806     function tokenURI(uint256 tokenId)
1807         public
1808         view
1809         virtual
1810         override
1811         returns (string memory)
1812     {
1813         require(
1814             _exists(tokenId),
1815             "ERC721Metadata: tokenURI queried for nonexistent token"
1816         );
1817         string memory currentBaseURI = _baseURI();
1818         return
1819             bytes(currentBaseURI).length > 0
1820                 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json"))
1821                 : "";
1822     }
1823 
1824     //
1825     function hashTransaction(address minter) private pure returns (bytes32) {
1826         bytes32 argsHash = keccak256(abi.encodePacked(minter));
1827         return
1828             keccak256(
1829                 abi.encodePacked("\x19Ethereum Signed Message:\n32", argsHash)
1830             );
1831     }
1832 
1833     // recovers signature of signer to verify if whitelisted for presale 
1834     function recoverSignerAddress(address minter, bytes memory signature)
1835         private
1836         pure
1837         returns (address)
1838     {
1839         bytes32 hash = hashTransaction(minter);
1840         return hash.recover(signature);
1841     }
1842 
1843     // Access control
1844     function setSigner(address __300SilverSigner, address _bronzeSigner, address _goldSigner) public onlyOwner {
1845         require(address(__300SilverSigner) != address(0x0), "Address can not be 0x0");
1846         _300SilverSigner = __300SilverSigner;
1847         bronzeSigner = _bronzeSigner;
1848         goldSigner = _goldSigner;
1849     }
1850 
1851     // Sets the staking contract function 
1852     function setContracts(address _staking) external onlyOwner {
1853         require(address(_staking) != address(0x0), "Address can not be 0x0");
1854         staking = IStaking(_staking);
1855     }
1856 
1857     // Sets price 
1858     function setPrices(uint256 _bronzePrice, uint256 _silverPrice, uint256 _goldPrice) public onlyOwner {
1859         bronzePrice = _bronzePrice;
1860         silverPrice = _silverPrice;
1861         goldPrice = _goldPrice;
1862     }
1863 
1864     // Sets price 
1865     function setPrivateSalePrice(uint256 _price) public onlyOwner {
1866         privateSalePrice = _price;
1867     }
1868 
1869     //Sets maximum no of token that can be minted per transaction
1870     function setMaxMintPerTx(uint16 _mint_per_tx) public onlyOwner {
1871         mint_per_tx = _mint_per_tx;
1872     }
1873 
1874     // Sets max token that can be minted per wallet 
1875     function setMaxMintPerWallet(uint16 _max_per_wallet) public onlyOwner {
1876         max_per_wallet = _max_per_wallet;
1877     }
1878 
1879 
1880     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1881         baseURI = _newBaseURI;
1882     }
1883 
1884     function setPause(bool _state) public onlyOwner {
1885         pause = _state;
1886     }
1887 
1888     function setPublicSale(bool _state) public onlyOwner {
1889         publicSale = _state;
1890     }
1891 
1892     function setPrivateSale(bool _state) public onlyOwner {
1893         privateSale = _state;
1894     }
1895 
1896     // // one time configuration of some parameter in other to save gas on multiple call
1897     function configure(
1898         uint16 _mint_per_tx,
1899         uint16 _max_per_wallet,
1900         uint16 _mint_per_tx_private,
1901         uint16 _max_per_wallet_private,
1902         uint256 _privateSalePrice,
1903         uint256 _goldPrice,
1904         uint256 _silverPrice,
1905         uint256 _bronzePrice
1906     ) public onlyOwner {
1907         mint_per_tx = _mint_per_tx;
1908         max_per_wallet = _max_per_wallet;
1909         mint_per_tx_private = _mint_per_tx_private;
1910         max_per_wallet_private = _max_per_wallet_private;
1911         privateSalePrice = _privateSalePrice;
1912         goldPrice = _goldPrice;
1913         silverPrice = _silverPrice;
1914         bronzePrice = _bronzePrice;
1915     }
1916 
1917     // withdral all eth paid to contract into owners account
1918     function withdraw() public payable onlyOwner {
1919         (bool success, ) = address(msg.sender).call{
1920             value: address(this).balance
1921         }("");
1922         require(success, "Unable to withdraw balance");
1923     }
1924 }