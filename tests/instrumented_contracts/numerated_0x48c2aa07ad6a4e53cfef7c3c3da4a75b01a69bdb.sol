1 // File: @openzeppelin/contracts/utils/Address.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
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
214 
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
229 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
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
246      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
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
318 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
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
357      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
358      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
359      *
360      * Requirements:
361      *
362      * - `from` cannot be the zero address.
363      * - `to` cannot be the zero address.
364      * - `tokenId` token must exist and be owned by `from`.
365      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
366      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
367      *
368      * Emits a {Transfer} event.
369      */
370     function safeTransferFrom(
371         address from,
372         address to,
373         uint256 tokenId
374     ) external;
375 
376     /**
377      * @dev Transfers `tokenId` token from `from` to `to`.
378      *
379      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
380      *
381      * Requirements:
382      *
383      * - `from` cannot be the zero address.
384      * - `to` cannot be the zero address.
385      * - `tokenId` token must be owned by `from`.
386      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
387      *
388      * Emits a {Transfer} event.
389      */
390     function transferFrom(
391         address from,
392         address to,
393         uint256 tokenId
394     ) external;
395 
396     /**
397      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
398      * The approval is cleared when the token is transferred.
399      *
400      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
401      *
402      * Requirements:
403      *
404      * - The caller must own the token or be an approved operator.
405      * - `tokenId` must exist.
406      *
407      * Emits an {Approval} event.
408      */
409     function approve(address to, uint256 tokenId) external;
410 
411     /**
412      * @dev Returns the account approved for `tokenId` token.
413      *
414      * Requirements:
415      *
416      * - `tokenId` must exist.
417      */
418     function getApproved(uint256 tokenId) external view returns (address operator);
419 
420     /**
421      * @dev Approve or remove `operator` as an operator for the caller.
422      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
423      *
424      * Requirements:
425      *
426      * - The `operator` cannot be the caller.
427      *
428      * Emits an {ApprovalForAll} event.
429      */
430     function setApprovalForAll(address operator, bool _approved) external;
431 
432     /**
433      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
434      *
435      * See {setApprovalForAll}
436      */
437     function isApprovedForAll(address owner, address operator) external view returns (bool);
438 
439     /**
440      * @dev Safely transfers `tokenId` token from `from` to `to`.
441      *
442      * Requirements:
443      *
444      * - `from` cannot be the zero address.
445      * - `to` cannot be the zero address.
446      * - `tokenId` token must exist and be owned by `from`.
447      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
448      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
449      *
450      * Emits a {Transfer} event.
451      */
452     function safeTransferFrom(
453         address from,
454         address to,
455         uint256 tokenId,
456         bytes calldata data
457     ) external;
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
589 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
590 
591 pragma solidity ^0.8.0;
592 
593 /**
594  * @dev String operations.
595  */
596 library Strings {
597     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
598 
599     /**
600      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
601      */
602     function toString(uint256 value) internal pure returns (string memory) {
603         // Inspired by OraclizeAPI's implementation - MIT licence
604         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
605 
606         if (value == 0) {
607             return "0";
608         }
609         uint256 temp = value;
610         uint256 digits;
611         while (temp != 0) {
612             digits++;
613             temp /= 10;
614         }
615         bytes memory buffer = new bytes(digits);
616         while (value != 0) {
617             digits -= 1;
618             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
619             value /= 10;
620         }
621         return string(buffer);
622     }
623 
624     /**
625      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
626      */
627     function toHexString(uint256 value) internal pure returns (string memory) {
628         if (value == 0) {
629             return "0x00";
630         }
631         uint256 temp = value;
632         uint256 length = 0;
633         while (temp != 0) {
634             length++;
635             temp >>= 8;
636         }
637         return toHexString(value, length);
638     }
639 
640     /**
641      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
642      */
643     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
644         bytes memory buffer = new bytes(2 * length + 2);
645         buffer[0] = "0";
646         buffer[1] = "x";
647         for (uint256 i = 2 * length + 1; i > 1; --i) {
648             buffer[i] = _HEX_SYMBOLS[value & 0xf];
649             value >>= 4;
650         }
651         require(value == 0, "Strings: hex length insufficient");
652         return string(buffer);
653     }
654 }
655 
656 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
657 
658 
659 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/ECDSA.sol)
660 
661 pragma solidity ^0.8.0;
662 
663 
664 /**
665  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
666  *
667  * These functions can be used to verify that a message was signed by the holder
668  * of the private keys of a given address.
669  */
670 library ECDSA {
671     enum RecoverError {
672         NoError,
673         InvalidSignature,
674         InvalidSignatureLength,
675         InvalidSignatureS,
676         InvalidSignatureV
677     }
678 
679     function _throwError(RecoverError error) private pure {
680         if (error == RecoverError.NoError) {
681             return; // no error: do nothing
682         } else if (error == RecoverError.InvalidSignature) {
683             revert("ECDSA: invalid signature");
684         } else if (error == RecoverError.InvalidSignatureLength) {
685             revert("ECDSA: invalid signature length");
686         } else if (error == RecoverError.InvalidSignatureS) {
687             revert("ECDSA: invalid signature 's' value");
688         } else if (error == RecoverError.InvalidSignatureV) {
689             revert("ECDSA: invalid signature 'v' value");
690         }
691     }
692 
693     /**
694      * @dev Returns the address that signed a hashed message (`hash`) with
695      * `signature` or error string. This address can then be used for verification purposes.
696      *
697      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
698      * this function rejects them by requiring the `s` value to be in the lower
699      * half order, and the `v` value to be either 27 or 28.
700      *
701      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
702      * verification to be secure: it is possible to craft signatures that
703      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
704      * this is by receiving a hash of the original message (which may otherwise
705      * be too long), and then calling {toEthSignedMessageHash} on it.
706      *
707      * Documentation for signature generation:
708      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
709      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
710      *
711      * _Available since v4.3._
712      */
713     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
714         // Check the signature length
715         // - case 65: r,s,v signature (standard)
716         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
717         if (signature.length == 65) {
718             bytes32 r;
719             bytes32 s;
720             uint8 v;
721             // ecrecover takes the signature parameters, and the only way to get them
722             // currently is to use assembly.
723             assembly {
724                 r := mload(add(signature, 0x20))
725                 s := mload(add(signature, 0x40))
726                 v := byte(0, mload(add(signature, 0x60)))
727             }
728             return tryRecover(hash, v, r, s);
729         } else if (signature.length == 64) {
730             bytes32 r;
731             bytes32 vs;
732             // ecrecover takes the signature parameters, and the only way to get them
733             // currently is to use assembly.
734             assembly {
735                 r := mload(add(signature, 0x20))
736                 vs := mload(add(signature, 0x40))
737             }
738             return tryRecover(hash, r, vs);
739         } else {
740             return (address(0), RecoverError.InvalidSignatureLength);
741         }
742     }
743 
744     /**
745      * @dev Returns the address that signed a hashed message (`hash`) with
746      * `signature`. This address can then be used for verification purposes.
747      *
748      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
749      * this function rejects them by requiring the `s` value to be in the lower
750      * half order, and the `v` value to be either 27 or 28.
751      *
752      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
753      * verification to be secure: it is possible to craft signatures that
754      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
755      * this is by receiving a hash of the original message (which may otherwise
756      * be too long), and then calling {toEthSignedMessageHash} on it.
757      */
758     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
759         (address recovered, RecoverError error) = tryRecover(hash, signature);
760         _throwError(error);
761         return recovered;
762     }
763 
764     /**
765      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
766      *
767      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
768      *
769      * _Available since v4.3._
770      */
771     function tryRecover(
772         bytes32 hash,
773         bytes32 r,
774         bytes32 vs
775     ) internal pure returns (address, RecoverError) {
776         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
777         uint8 v = uint8((uint256(vs) >> 255) + 27);
778         return tryRecover(hash, v, r, s);
779     }
780 
781     /**
782      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
783      *
784      * _Available since v4.2._
785      */
786     function recover(
787         bytes32 hash,
788         bytes32 r,
789         bytes32 vs
790     ) internal pure returns (address) {
791         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
792         _throwError(error);
793         return recovered;
794     }
795 
796     /**
797      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
798      * `r` and `s` signature fields separately.
799      *
800      * _Available since v4.3._
801      */
802     function tryRecover(
803         bytes32 hash,
804         uint8 v,
805         bytes32 r,
806         bytes32 s
807     ) internal pure returns (address, RecoverError) {
808         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
809         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
810         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
811         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
812         //
813         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
814         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
815         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
816         // these malleable signatures as well.
817         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
818             return (address(0), RecoverError.InvalidSignatureS);
819         }
820         if (v != 27 && v != 28) {
821             return (address(0), RecoverError.InvalidSignatureV);
822         }
823 
824         // If the signature is valid (and not malleable), return the signer address
825         address signer = ecrecover(hash, v, r, s);
826         if (signer == address(0)) {
827             return (address(0), RecoverError.InvalidSignature);
828         }
829 
830         return (signer, RecoverError.NoError);
831     }
832 
833     /**
834      * @dev Overload of {ECDSA-recover} that receives the `v`,
835      * `r` and `s` signature fields separately.
836      */
837     function recover(
838         bytes32 hash,
839         uint8 v,
840         bytes32 r,
841         bytes32 s
842     ) internal pure returns (address) {
843         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
844         _throwError(error);
845         return recovered;
846     }
847 
848     /**
849      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
850      * produces hash corresponding to the one signed with the
851      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
852      * JSON-RPC method as part of EIP-191.
853      *
854      * See {recover}.
855      */
856     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
857         // 32 is the length in bytes of hash,
858         // enforced by the type signature above
859         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
860     }
861 
862     /**
863      * @dev Returns an Ethereum Signed Message, created from `s`. This
864      * produces hash corresponding to the one signed with the
865      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
866      * JSON-RPC method as part of EIP-191.
867      *
868      * See {recover}.
869      */
870     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
871         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
872     }
873 
874     /**
875      * @dev Returns an Ethereum Signed Typed Data, created from a
876      * `domainSeparator` and a `structHash`. This produces hash corresponding
877      * to the one signed with the
878      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
879      * JSON-RPC method as part of EIP-712.
880      *
881      * See {recover}.
882      */
883     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
884         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
885     }
886 }
887 
888 // File: @openzeppelin/contracts/utils/Context.sol
889 
890 
891 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
892 
893 pragma solidity ^0.8.0;
894 
895 /**
896  * @dev Provides information about the current execution context, including the
897  * sender of the transaction and its data. While these are generally available
898  * via msg.sender and msg.data, they should not be accessed in such a direct
899  * manner, since when dealing with meta-transactions the account sending and
900  * paying for execution may not be the actual sender (as far as an application
901  * is concerned).
902  *
903  * This contract is only required for intermediate, library-like contracts.
904  */
905 abstract contract Context {
906     function _msgSender() internal view virtual returns (address) {
907         return msg.sender;
908     }
909 
910     function _msgData() internal view virtual returns (bytes calldata) {
911         return msg.data;
912     }
913 }
914 
915 // File: contracts/ERC721A.sol
916 
917 
918 
919 pragma solidity ^0.8.0;
920 
921 
922 
923 
924 
925 
926 
927 
928 
929 /**
930  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
931  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
932  *
933  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
934  *
935  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
936  *
937  * Does not support burning tokens to address(0).
938  */
939 contract ERC721A is
940   Context,
941   ERC165,
942   IERC721,
943   IERC721Metadata,
944   IERC721Enumerable
945 {
946   using Address for address;
947   using Strings for uint256;
948 
949   struct TokenOwnership {
950     address addr;
951     uint64 startTimestamp;
952   }
953 
954   struct AddressData {
955     uint128 balance;
956     uint128 numberMinted;
957   }
958 
959   uint256 private currentIndex = 0;
960 
961   uint256 internal immutable collectionSize;
962   uint256 internal immutable maxBatchSize;
963 
964   // Token name
965   string private _name;
966 
967   // Token symbol
968   string private _symbol;
969 
970   // Mapping from token ID to ownership details
971   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
972   mapping(uint256 => TokenOwnership) private _ownerships;
973 
974   // Mapping owner address to address data
975   mapping(address => AddressData) private _addressData;
976 
977   // Mapping from token ID to approved address
978   mapping(uint256 => address) private _tokenApprovals;
979 
980   // Mapping from owner to operator approvals
981   mapping(address => mapping(address => bool)) private _operatorApprovals;
982 
983   /**
984    * @dev
985    * `maxBatchSize` refers to how much a minter can mint at a time.
986    * `collectionSize_` refers to how many tokens are in the collection.
987    */
988   constructor(
989     string memory name_,
990     string memory symbol_,
991     uint256 maxBatchSize_,
992     uint256 collectionSize_
993   ) {
994     require(
995       collectionSize_ > 0,
996       "ERC721A: collection must have a nonzero supply"
997     );
998     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
999     _name = name_;
1000     _symbol = symbol_;
1001     maxBatchSize = maxBatchSize_;
1002     collectionSize = collectionSize_;
1003   }
1004 
1005   /**
1006    * @dev See {IERC721Enumerable-totalSupply}.
1007    */
1008   function totalSupply() public view override returns (uint256) {
1009     return currentIndex;
1010   }
1011 
1012   /**
1013    * @dev See {IERC721Enumerable-tokenByIndex}.
1014    */
1015   function tokenByIndex(uint256 index) public view override returns (uint256) {
1016     require(index < totalSupply(), "ERC721A: global index out of bounds");
1017     return index;
1018   }
1019 
1020   /**
1021    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1022    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1023    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1024    */
1025   function tokenOfOwnerByIndex(address owner, uint256 index)
1026     public
1027     view
1028     override
1029     returns (uint256)
1030   {
1031     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1032     uint256 numMintedSoFar = totalSupply();
1033     uint256 tokenIdsIdx = 0;
1034     address currOwnershipAddr = address(0);
1035     for (uint256 i = 0; i < numMintedSoFar; i++) {
1036       TokenOwnership memory ownership = _ownerships[i];
1037       if (ownership.addr != address(0)) {
1038         currOwnershipAddr = ownership.addr;
1039       }
1040       if (currOwnershipAddr == owner) {
1041         if (tokenIdsIdx == index) {
1042           return i;
1043         }
1044         tokenIdsIdx++;
1045       }
1046     }
1047     revert("ERC721A: unable to get token of owner by index");
1048   }
1049 
1050   /**
1051    * @dev See {IERC165-supportsInterface}.
1052    */
1053   function supportsInterface(bytes4 interfaceId)
1054     public
1055     view
1056     virtual
1057     override(ERC165, IERC165)
1058     returns (bool)
1059   {
1060     return
1061       interfaceId == type(IERC721).interfaceId ||
1062       interfaceId == type(IERC721Metadata).interfaceId ||
1063       interfaceId == type(IERC721Enumerable).interfaceId ||
1064       super.supportsInterface(interfaceId);
1065   }
1066 
1067   /**
1068    * @dev See {IERC721-balanceOf}.
1069    */
1070   function balanceOf(address owner) public view override returns (uint256) {
1071     require(owner != address(0), "ERC721A: balance query for the zero address");
1072     return uint256(_addressData[owner].balance);
1073   }
1074 
1075   function _numberMinted(address owner) internal view returns (uint256) {
1076     require(
1077       owner != address(0),
1078       "ERC721A: number minted query for the zero address"
1079     );
1080     return uint256(_addressData[owner].numberMinted);
1081   }
1082 
1083   function ownershipOf(uint256 tokenId)
1084     internal
1085     view
1086     returns (TokenOwnership memory)
1087   {
1088     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1089 
1090     uint256 lowestTokenToCheck;
1091     if (tokenId >= maxBatchSize) {
1092       lowestTokenToCheck = tokenId - maxBatchSize + 1;
1093     }
1094 
1095     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
1096       TokenOwnership memory ownership = _ownerships[curr];
1097       if (ownership.addr != address(0)) {
1098         return ownership;
1099       }
1100     }
1101 
1102     revert("ERC721A: unable to determine the owner of token");
1103   }
1104 
1105   /**
1106    * @dev See {IERC721-ownerOf}.
1107    */
1108   function ownerOf(uint256 tokenId) public view override returns (address) {
1109     return ownershipOf(tokenId).addr;
1110   }
1111 
1112   /**
1113    * @dev See {IERC721Metadata-name}.
1114    */
1115   function name() public view virtual override returns (string memory) {
1116     return _name;
1117   }
1118 
1119   /**
1120    * @dev See {IERC721Metadata-symbol}.
1121    */
1122   function symbol() public view virtual override returns (string memory) {
1123     return _symbol;
1124   }
1125 
1126   /**
1127    * @dev See {IERC721Metadata-tokenURI}.
1128    */
1129   function tokenURI(uint256 tokenId)
1130     public
1131     view
1132     virtual
1133     override
1134     returns (string memory)
1135   {
1136     require(
1137       _exists(tokenId),
1138       "ERC721Metadata: URI query for nonexistent token"
1139     );
1140 
1141     string memory baseURI = _baseURI();
1142     return
1143       bytes(baseURI).length > 0
1144         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1145         : "";
1146   }
1147 
1148   /**
1149    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1150    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1151    * by default, can be overriden in child contracts.
1152    */
1153   function _baseURI() internal view virtual returns (string memory) {
1154     return "";
1155   }
1156 
1157   /**
1158    * @dev See {IERC721-approve}.
1159    */
1160   function approve(address to, uint256 tokenId) public override {
1161     address owner = ERC721A.ownerOf(tokenId);
1162     require(to != owner, "ERC721A: approval to current owner");
1163 
1164     require(
1165       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1166       "ERC721A: approve caller is not owner nor approved for all"
1167     );
1168 
1169     _approve(to, tokenId, owner);
1170   }
1171 
1172   /**
1173    * @dev See {IERC721-getApproved}.
1174    */
1175   function getApproved(uint256 tokenId) public view override returns (address) {
1176     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1177 
1178     return _tokenApprovals[tokenId];
1179   }
1180 
1181   /**
1182    * @dev See {IERC721-setApprovalForAll}.
1183    */
1184   function setApprovalForAll(address operator, bool approved) public override {
1185     require(operator != _msgSender(), "ERC721A: approve to caller");
1186 
1187     _operatorApprovals[_msgSender()][operator] = approved;
1188     emit ApprovalForAll(_msgSender(), operator, approved);
1189   }
1190 
1191   /**
1192    * @dev See {IERC721-isApprovedForAll}.
1193    */
1194   function isApprovedForAll(address owner, address operator)
1195     public
1196     view
1197     virtual
1198     override
1199     returns (bool)
1200   {
1201     return _operatorApprovals[owner][operator];
1202   }
1203 
1204   /**
1205    * @dev See {IERC721-transferFrom}.
1206    */
1207   function transferFrom(
1208     address from,
1209     address to,
1210     uint256 tokenId
1211   ) public override {
1212     _transfer(from, to, tokenId);
1213   }
1214 
1215   /**
1216    * @dev See {IERC721-safeTransferFrom}.
1217    */
1218   function safeTransferFrom(
1219     address from,
1220     address to,
1221     uint256 tokenId
1222   ) public override {
1223     safeTransferFrom(from, to, tokenId, "");
1224   }
1225 
1226   /**
1227    * @dev See {IERC721-safeTransferFrom}.
1228    */
1229   function safeTransferFrom(
1230     address from,
1231     address to,
1232     uint256 tokenId,
1233     bytes memory _data
1234   ) public override {
1235     _transfer(from, to, tokenId);
1236     require(
1237       _checkOnERC721Received(from, to, tokenId, _data),
1238       "ERC721A: transfer to non ERC721Receiver implementer"
1239     );
1240   }
1241 
1242   /**
1243    * @dev Returns whether `tokenId` exists.
1244    *
1245    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1246    *
1247    * Tokens start existing when they are minted (`_mint`),
1248    */
1249   function _exists(uint256 tokenId) internal view returns (bool) {
1250     return tokenId < currentIndex;
1251   }
1252 
1253   function _safeMint(address to, uint256 quantity) internal {
1254     _safeMint(to, quantity, "");
1255   }
1256 
1257   /**
1258    * @dev Mints `quantity` tokens and transfers them to `to`.
1259    *
1260    * Requirements:
1261    *
1262    * - there must be `quantity` tokens remaining unminted in the total collection.
1263    * - `to` cannot be the zero address.
1264    * - `quantity` cannot be larger than the max batch size.
1265    *
1266    * Emits a {Transfer} event.
1267    */
1268   function _safeMint(
1269     address to,
1270     uint256 quantity,
1271     bytes memory _data
1272   ) internal {
1273     uint256 startTokenId = currentIndex;
1274     require(to != address(0), "ERC721A: mint to the zero address");
1275     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1276     require(!_exists(startTokenId), "ERC721A: token already minted");
1277     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1278 
1279     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1280 
1281     AddressData memory addressData = _addressData[to];
1282     _addressData[to] = AddressData(
1283       addressData.balance + uint128(quantity),
1284       addressData.numberMinted + uint128(quantity)
1285     );
1286     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1287 
1288     uint256 updatedIndex = startTokenId;
1289 
1290     for (uint256 i = 0; i < quantity; i++) {
1291       emit Transfer(address(0), to, updatedIndex);
1292       require(
1293         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1294         "ERC721A: transfer to non ERC721Receiver implementer"
1295       );
1296       updatedIndex++;
1297     }
1298 
1299     currentIndex = updatedIndex;
1300     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1301   }
1302 
1303   /**
1304    * @dev Transfers `tokenId` from `from` to `to`.
1305    *
1306    * Requirements:
1307    *
1308    * - `to` cannot be the zero address.
1309    * - `tokenId` token must be owned by `from`.
1310    *
1311    * Emits a {Transfer} event.
1312    */
1313   function _transfer(
1314     address from,
1315     address to,
1316     uint256 tokenId
1317   ) private {
1318     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1319 
1320     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1321       getApproved(tokenId) == _msgSender() ||
1322       isApprovedForAll(prevOwnership.addr, _msgSender()));
1323 
1324     require(
1325       isApprovedOrOwner,
1326       "ERC721A: transfer caller is not owner nor approved"
1327     );
1328 
1329     require(
1330       prevOwnership.addr == from,
1331       "ERC721A: transfer from incorrect owner"
1332     );
1333     require(to != address(0), "ERC721A: transfer to the zero address");
1334 
1335     _beforeTokenTransfers(from, to, tokenId, 1);
1336 
1337     // Clear approvals from the previous owner
1338     _approve(address(0), tokenId, prevOwnership.addr);
1339 
1340     _addressData[from].balance -= 1;
1341     _addressData[to].balance += 1;
1342     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1343 
1344     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1345     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1346     uint256 nextTokenId = tokenId + 1;
1347     if (_ownerships[nextTokenId].addr == address(0)) {
1348       if (_exists(nextTokenId)) {
1349         _ownerships[nextTokenId] = TokenOwnership(
1350           prevOwnership.addr,
1351           prevOwnership.startTimestamp
1352         );
1353       }
1354     }
1355 
1356     emit Transfer(from, to, tokenId);
1357     _afterTokenTransfers(from, to, tokenId, 1);
1358   }
1359 
1360   /**
1361    * @dev Approve `to` to operate on `tokenId`
1362    *
1363    * Emits a {Approval} event.
1364    */
1365   function _approve(
1366     address to,
1367     uint256 tokenId,
1368     address owner
1369   ) private {
1370     _tokenApprovals[tokenId] = to;
1371     emit Approval(owner, to, tokenId);
1372   }
1373 
1374   uint256 public nextOwnerToExplicitlySet = 0;
1375 
1376   /**
1377    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1378    */
1379   function _setOwnersExplicit(uint256 quantity) internal {
1380     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1381     require(quantity > 0, "quantity must be nonzero");
1382     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1383     if (endIndex > collectionSize - 1) {
1384       endIndex = collectionSize - 1;
1385     }
1386     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1387     require(_exists(endIndex), "not enough minted yet for this cleanup");
1388     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1389       if (_ownerships[i].addr == address(0)) {
1390         TokenOwnership memory ownership = ownershipOf(i);
1391         _ownerships[i] = TokenOwnership(
1392           ownership.addr,
1393           ownership.startTimestamp
1394         );
1395       }
1396     }
1397     nextOwnerToExplicitlySet = endIndex + 1;
1398   }
1399 
1400   /**
1401    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1402    * The call is not executed if the target address is not a contract.
1403    *
1404    * @param from address representing the previous owner of the given token ID
1405    * @param to target address that will receive the tokens
1406    * @param tokenId uint256 ID of the token to be transferred
1407    * @param _data bytes optional data to send along with the call
1408    * @return bool whether the call correctly returned the expected magic value
1409    */
1410   function _checkOnERC721Received(
1411     address from,
1412     address to,
1413     uint256 tokenId,
1414     bytes memory _data
1415   ) private returns (bool) {
1416     if (to.isContract()) {
1417       try
1418         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1419       returns (bytes4 retval) {
1420         return retval == IERC721Receiver(to).onERC721Received.selector;
1421       } catch (bytes memory reason) {
1422         if (reason.length == 0) {
1423           revert("ERC721A: transfer to non ERC721Receiver implementer");
1424         } else {
1425           assembly {
1426             revert(add(32, reason), mload(reason))
1427           }
1428         }
1429       }
1430     } else {
1431       return true;
1432     }
1433   }
1434 
1435   /**
1436    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1437    *
1438    * startTokenId - the first token id to be transferred
1439    * quantity - the amount to be transferred
1440    *
1441    * Calling conditions:
1442    *
1443    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1444    * transferred to `to`.
1445    * - When `from` is zero, `tokenId` will be minted for `to`.
1446    */
1447   function _beforeTokenTransfers(
1448     address from,
1449     address to,
1450     uint256 startTokenId,
1451     uint256 quantity
1452   ) internal virtual {}
1453 
1454   /**
1455    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1456    * minting.
1457    *
1458    * startTokenId - the first token id to be transferred
1459    * quantity - the amount to be transferred
1460    *
1461    * Calling conditions:
1462    *
1463    * - when `from` and `to` are both non-zero.
1464    * - `from` and `to` are never both zero.
1465    */
1466   function _afterTokenTransfers(
1467     address from,
1468     address to,
1469     uint256 startTokenId,
1470     uint256 quantity
1471   ) internal virtual {}
1472 }
1473 // File: @openzeppelin/contracts/access/Ownable.sol
1474 
1475 
1476 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1477 
1478 pragma solidity ^0.8.0;
1479 
1480 
1481 /**
1482  * @dev Contract module which provides a basic access control mechanism, where
1483  * there is an account (an owner) that can be granted exclusive access to
1484  * specific functions.
1485  *
1486  * By default, the owner account will be the one that deploys the contract. This
1487  * can later be changed with {transferOwnership}.
1488  *
1489  * This module is used through inheritance. It will make available the modifier
1490  * `onlyOwner`, which can be applied to your functions to restrict their use to
1491  * the owner.
1492  */
1493 abstract contract Ownable is Context {
1494     address private _owner;
1495 
1496     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1497 
1498     /**
1499      * @dev Initializes the contract setting the deployer as the initial owner.
1500      */
1501     constructor() {
1502         _transferOwnership(_msgSender());
1503     }
1504 
1505     /**
1506      * @dev Returns the address of the current owner.
1507      */
1508     function owner() public view virtual returns (address) {
1509         return _owner;
1510     }
1511 
1512     /**
1513      * @dev Throws if called by any account other than the owner.
1514      */
1515     modifier onlyOwner() {
1516         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1517         _;
1518     }
1519 
1520     /**
1521      * @dev Leaves the contract without owner. It will not be possible to call
1522      * `onlyOwner` functions anymore. Can only be called by the current owner.
1523      *
1524      * NOTE: Renouncing ownership will leave the contract without an owner,
1525      * thereby removing any functionality that is only available to the owner.
1526      */
1527     function renounceOwnership() public virtual onlyOwner {
1528         _transferOwnership(address(0));
1529     }
1530 
1531     /**
1532      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1533      * Can only be called by the current owner.
1534      */
1535     function transferOwnership(address newOwner) public virtual onlyOwner {
1536         require(newOwner != address(0), "Ownable: new owner is the zero address");
1537         _transferOwnership(newOwner);
1538     }
1539 
1540     /**
1541      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1542      * Internal function without access restriction.
1543      */
1544     function _transferOwnership(address newOwner) internal virtual {
1545         address oldOwner = _owner;
1546         _owner = newOwner;
1547         emit OwnershipTransferred(oldOwner, newOwner);
1548     }
1549 }
1550 
1551 // File: contracts/BoredDickButt.sol
1552 
1553 
1554 
1555 pragma solidity ^0.8.0;
1556 
1557 
1558 
1559 
1560 
1561 contract BoredDickButt is Ownable, ERC721A, ReentrancyGuard {
1562     using Strings for uint256;
1563     using ECDSA for bytes32;
1564 
1565     string public baseURI = "ipfs://QmaN85GEkAGWxqMEqEDdV1Wn8frzdJ99cyBssd9zWAkxxx/";
1566     uint256 public cost = 0.042 ether;
1567     uint16 public maxSupply = 6969;
1568     uint public maxMintPerTx = 5;
1569     bool public publicSale = false;
1570     bool public privateSale = false;
1571     address public signer1; // CryptoDickButt Signer
1572     address public signer2; // Other whitelist signer
1573     mapping(address => bool) public cbdClaimed;
1574 
1575     address constant private _2 = 0x7c007c8dA1b2c984fC9562cf71ccA71381C1542D;
1576     address constant private _2b = 0x4e25eF40a532148D3eeef157dea5B903eD9d2029;
1577     address constant private _3 = 0xe42c23f113a4Bd5190fABA54b38aB1a7f7248629;
1578     address constant private _4 = 0xB2533a92960803f0a641dd72290Ba38399Cec459;
1579     address constant private _5 = 0xC1Bf8D192C2130C106429D73ba26172113F2B9FC;
1580     address constant private _9 = 0xd480C1E4738B7570bfbE809610338eFCD0D0C1F3;
1581     address constant private _10 = 0x7049871039097E61b1Ae827e77aBb1C9a0B14061;
1582     address constant private _15 = 0x709bF4aC7ED6Bb2F9d60b1215d983496AB68efbc;
1583     address constant private _50 = 0xF14d484b29A8aC040FEb489aFADB4b972422B4E9;
1584     
1585 
1586 
1587     constructor() ERC721A ("Bored Dick Butt", "BDB", 20, maxSupply){}
1588 
1589     function _baseURI() internal view virtual override returns (string memory){
1590         return baseURI;
1591     }
1592 
1593     function mint(uint _mintAmount) external payable {
1594         require(publicSale, "Minting currently on hold");
1595         require(totalSupply() + _mintAmount <= maxSupply, "Purchase would exceed max supply of NFT");
1596         require(_mintAmount <= maxMintPerTx, "Maximum mint amount exceeded");
1597         mintX(_mintAmount);
1598     }
1599 
1600     function privateSaleMint(uint _mintAmount, bytes memory signature) external payable {
1601         require(privateSale, "Private sale is not currently running");
1602         require(totalSupply() + _mintAmount <= maxSupply, "Purchase would exceed max supply of private sale");
1603         require(_mintAmount <= maxMintPerTx, "Purchase would exceed max mint per transaction");
1604 
1605         address recover = recoverSignerAddress(msg.sender, signature);
1606 
1607         if (recover == signer1) {
1608             mintXCDB(_mintAmount);
1609         }else if (recover == signer2) {
1610             mintX(_mintAmount);
1611         }else{
1612             revert("You are not whitelisted for this mint");
1613         }
1614 
1615     }
1616 
1617     function mintXCDB(uint _mintAmount) private {
1618         require(_mintAmount > 0, "Amount to mint can not be 0");
1619         // if(cbdClaimed[msg.sender] == true)
1620         bool claimed = cbdClaimed[msg.sender];
1621         if(!claimed){
1622             cbdClaimed[msg.sender] = true;
1623         }
1624         require(msg.value >= cost * _mintAmount, "Amount sent less than the cost of minting NFT(s)");
1625         if(claimed){
1626             _safeMint(msg.sender, _mintAmount);
1627         }else{
1628             _safeMint(msg.sender, _mintAmount+1);
1629         }
1630     }
1631         
1632     function mintX(uint _mintAmount) private {
1633         require(_mintAmount > 0, "Amount to mint can not be 0");
1634         if (msg.sender != owner()) {
1635             require(msg.value >= cost * _mintAmount, "Amount sent less than the cost of minting NFT(s)");
1636         }
1637         _safeMint(msg.sender, _mintAmount);
1638     }
1639 
1640     function walletOfOwner(address _owner) public view returns (uint256[] memory){
1641         uint256 ownerTokenCount = balanceOf(_owner);
1642         uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1643         for (uint256 i; i < ownerTokenCount; i++) {
1644             tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1645         }
1646         return tokenIds;
1647     }
1648 
1649     function tokenURI(uint256 tokenId) public view virtual override returns (string memory){
1650 
1651         require(_exists(tokenId), "ERC721Metadata: tokenURI queried for nonexistent token");
1652         string memory currentBaseURI = _baseURI();
1653         return bytes(currentBaseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : "";
1654     }
1655 
1656     //
1657     function hashTransaction(address minter) private pure returns (bytes32) {
1658         bytes32 argsHash = keccak256(abi.encodePacked(minter));
1659         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", argsHash));
1660     }
1661 
1662     function recoverSignerAddress(address minter, bytes memory signature) private pure returns (address) {
1663         bytes32 hash = hashTransaction(minter);
1664         return hash.recover(signature);
1665     }
1666 
1667 
1668     // Access control
1669 
1670     function devMint(uint _mintAmount) external onlyOwner() {
1671         require(totalSupply() + _mintAmount <= maxSupply, "Purchase would exceed max supply of NFT");
1672         mintX(_mintAmount);
1673     }
1674 
1675     function setSigner(address _signer) public onlyOwner() {
1676         signer1 = _signer;
1677     }
1678 
1679     function setSigner2(address _signer) public onlyOwner() {
1680         signer2 = _signer;
1681     }
1682 
1683     function setCost(uint256 _cost) public onlyOwner() {
1684         cost = _cost;
1685     }
1686 
1687     function setMaxMintPerT(uint256 _maxMintPerTx) public onlyOwner() {
1688         maxMintPerTx = _maxMintPerTx;
1689     }
1690 
1691     function setBaseURI(string memory _newBaseURI) public onlyOwner() {
1692         baseURI = _newBaseURI;
1693     }
1694 
1695     function togglePublicSale() public onlyOwner() {
1696         publicSale = !publicSale;
1697     }
1698 
1699     function togglePrivateSale() public onlyOwner() {
1700         privateSale = !privateSale;
1701     }
1702 
1703     function configure(bool _publicSale, bool _privateSale, uint256 _maxMintPerTx,
1704         address _signer1, address _signer2) public onlyOwner() {
1705         publicSale = _publicSale;
1706         privateSale = _privateSale;
1707         maxMintPerTx = _maxMintPerTx;
1708         signer1 = _signer1;
1709         signer2 = _signer2;
1710     }
1711 
1712     function withdraw() public payable onlyOwner() {
1713 
1714         uint balance = address(this).balance;
1715         uint _2pct = (balance * 2) / 100;
1716         uint _3pct = (balance * 3) / 100;
1717         uint _4pct = (balance * 4) / 100;
1718         uint _5pct = (balance * 5) / 100;
1719         uint _9pct = (balance * 9) / 100;
1720         uint _10pct = (balance * 10) / 100;
1721         uint _15pct = (balance * 15) / 100;
1722         uint _50pct = (balance * 50) / 100;
1723         payable(_2).transfer(_2pct);
1724         payable(_2b).transfer(_2pct);
1725         payable(_3).transfer(_3pct);
1726         payable(_4).transfer(_4pct);
1727         payable(_5).transfer(_5pct);
1728         payable(_9).transfer(_9pct);
1729         payable(_10).transfer(_10pct);
1730         payable(_15).transfer(_15pct);
1731 
1732         payable(_50).transfer(_50pct);
1733 
1734 
1735 //        payable(_50).transfer(balance - _2pct - _2pct - _3pct - _4pct - _5pct - _9pct - _10pct - _15pct);
1736     
1737     }
1738 
1739 }