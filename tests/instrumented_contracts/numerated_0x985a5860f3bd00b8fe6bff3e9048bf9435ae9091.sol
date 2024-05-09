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
460 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
461 
462 
463 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
464 
465 pragma solidity ^0.8.0;
466 
467 
468 /**
469  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
470  * @dev See https://eips.ethereum.org/EIPS/eip-721
471  */
472 interface IERC721Metadata is IERC721 {
473     /**
474      * @dev Returns the token collection name.
475      */
476     function name() external view returns (string memory);
477 
478     /**
479      * @dev Returns the token collection symbol.
480      */
481     function symbol() external view returns (string memory);
482 
483     /**
484      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
485      */
486     function tokenURI(uint256 tokenId) external view returns (string memory);
487 }
488 
489 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
490 
491 
492 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
493 
494 pragma solidity ^0.8.0;
495 
496 /**
497  * @dev Contract module that helps prevent reentrant calls to a function.
498  *
499  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
500  * available, which can be applied to functions to make sure there are no nested
501  * (reentrant) calls to them.
502  *
503  * Note that because there is a single `nonReentrant` guard, functions marked as
504  * `nonReentrant` may not call one another. This can be worked around by making
505  * those functions `private`, and then adding `external` `nonReentrant` entry
506  * points to them.
507  *
508  * TIP: If you would like to learn more about reentrancy and alternative ways
509  * to protect against it, check out our blog post
510  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
511  */
512 abstract contract ReentrancyGuard {
513     // Booleans are more expensive than uint256 or any type that takes up a full
514     // word because each write operation emits an extra SLOAD to first read the
515     // slot's contents, replace the bits taken up by the boolean, and then write
516     // back. This is the compiler's defense against contract upgrades and
517     // pointer aliasing, and it cannot be disabled.
518 
519     // The values being non-zero value makes deployment a bit more expensive,
520     // but in exchange the refund on every call to nonReentrant will be lower in
521     // amount. Since refunds are capped to a percentage of the total
522     // transaction's gas, it is best to keep them low in cases like this one, to
523     // increase the likelihood of the full refund coming into effect.
524     uint256 private constant _NOT_ENTERED = 1;
525     uint256 private constant _ENTERED = 2;
526 
527     uint256 private _status;
528 
529     constructor() {
530         _status = _NOT_ENTERED;
531     }
532 
533     /**
534      * @dev Prevents a contract from calling itself, directly or indirectly.
535      * Calling a `nonReentrant` function from another `nonReentrant`
536      * function is not supported. It is possible to prevent this from happening
537      * by making the `nonReentrant` function external, and making it call a
538      * `private` function that does the actual work.
539      */
540     modifier nonReentrant() {
541         // On the first call to nonReentrant, _notEntered will be true
542         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
543 
544         // Any calls to nonReentrant after this point will fail
545         _status = _ENTERED;
546 
547         _;
548 
549         // By storing the original value once again, a refund is triggered (see
550         // https://eips.ethereum.org/EIPS/eip-2200)
551         _status = _NOT_ENTERED;
552     }
553 }
554 
555 // File: @openzeppelin/contracts/utils/Strings.sol
556 
557 
558 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
559 
560 pragma solidity ^0.8.0;
561 
562 /**
563  * @dev String operations.
564  */
565 library Strings {
566     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
567     uint8 private constant _ADDRESS_LENGTH = 20;
568 
569     /**
570      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
571      */
572     function toString(uint256 value) internal pure returns (string memory) {
573         // Inspired by OraclizeAPI's implementation - MIT licence
574         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
575 
576         if (value == 0) {
577             return "0";
578         }
579         uint256 temp = value;
580         uint256 digits;
581         while (temp != 0) {
582             digits++;
583             temp /= 10;
584         }
585         bytes memory buffer = new bytes(digits);
586         while (value != 0) {
587             digits -= 1;
588             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
589             value /= 10;
590         }
591         return string(buffer);
592     }
593 
594     /**
595      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
596      */
597     function toHexString(uint256 value) internal pure returns (string memory) {
598         if (value == 0) {
599             return "0x00";
600         }
601         uint256 temp = value;
602         uint256 length = 0;
603         while (temp != 0) {
604             length++;
605             temp >>= 8;
606         }
607         return toHexString(value, length);
608     }
609 
610     /**
611      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
612      */
613     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
614         bytes memory buffer = new bytes(2 * length + 2);
615         buffer[0] = "0";
616         buffer[1] = "x";
617         for (uint256 i = 2 * length + 1; i > 1; --i) {
618             buffer[i] = _HEX_SYMBOLS[value & 0xf];
619             value >>= 4;
620         }
621         require(value == 0, "Strings: hex length insufficient");
622         return string(buffer);
623     }
624 
625     /**
626      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
627      */
628     function toHexString(address addr) internal pure returns (string memory) {
629         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
630     }
631 }
632 
633 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
634 
635 
636 // OpenZeppelin Contracts (last updated v4.7.3) (utils/cryptography/ECDSA.sol)
637 
638 pragma solidity ^0.8.0;
639 
640 
641 /**
642  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
643  *
644  * These functions can be used to verify that a message was signed by the holder
645  * of the private keys of a given address.
646  */
647 library ECDSA {
648     enum RecoverError {
649         NoError,
650         InvalidSignature,
651         InvalidSignatureLength,
652         InvalidSignatureS,
653         InvalidSignatureV
654     }
655 
656     function _throwError(RecoverError error) private pure {
657         if (error == RecoverError.NoError) {
658             return; // no error: do nothing
659         } else if (error == RecoverError.InvalidSignature) {
660             revert("ECDSA: invalid signature");
661         } else if (error == RecoverError.InvalidSignatureLength) {
662             revert("ECDSA: invalid signature length");
663         } else if (error == RecoverError.InvalidSignatureS) {
664             revert("ECDSA: invalid signature 's' value");
665         } else if (error == RecoverError.InvalidSignatureV) {
666             revert("ECDSA: invalid signature 'v' value");
667         }
668     }
669 
670     /**
671      * @dev Returns the address that signed a hashed message (`hash`) with
672      * `signature` or error string. This address can then be used for verification purposes.
673      *
674      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
675      * this function rejects them by requiring the `s` value to be in the lower
676      * half order, and the `v` value to be either 27 or 28.
677      *
678      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
679      * verification to be secure: it is possible to craft signatures that
680      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
681      * this is by receiving a hash of the original message (which may otherwise
682      * be too long), and then calling {toEthSignedMessageHash} on it.
683      *
684      * Documentation for signature generation:
685      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
686      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
687      *
688      * _Available since v4.3._
689      */
690     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
691         if (signature.length == 65) {
692             bytes32 r;
693             bytes32 s;
694             uint8 v;
695             // ecrecover takes the signature parameters, and the only way to get them
696             // currently is to use assembly.
697             /// @solidity memory-safe-assembly
698             assembly {
699                 r := mload(add(signature, 0x20))
700                 s := mload(add(signature, 0x40))
701                 v := byte(0, mload(add(signature, 0x60)))
702             }
703             return tryRecover(hash, v, r, s);
704         } else {
705             return (address(0), RecoverError.InvalidSignatureLength);
706         }
707     }
708 
709     /**
710      * @dev Returns the address that signed a hashed message (`hash`) with
711      * `signature`. This address can then be used for verification purposes.
712      *
713      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
714      * this function rejects them by requiring the `s` value to be in the lower
715      * half order, and the `v` value to be either 27 or 28.
716      *
717      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
718      * verification to be secure: it is possible to craft signatures that
719      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
720      * this is by receiving a hash of the original message (which may otherwise
721      * be too long), and then calling {toEthSignedMessageHash} on it.
722      */
723     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
724         (address recovered, RecoverError error) = tryRecover(hash, signature);
725         _throwError(error);
726         return recovered;
727     }
728 
729     /**
730      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
731      *
732      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
733      *
734      * _Available since v4.3._
735      */
736     function tryRecover(
737         bytes32 hash,
738         bytes32 r,
739         bytes32 vs
740     ) internal pure returns (address, RecoverError) {
741         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
742         uint8 v = uint8((uint256(vs) >> 255) + 27);
743         return tryRecover(hash, v, r, s);
744     }
745 
746     /**
747      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
748      *
749      * _Available since v4.2._
750      */
751     function recover(
752         bytes32 hash,
753         bytes32 r,
754         bytes32 vs
755     ) internal pure returns (address) {
756         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
757         _throwError(error);
758         return recovered;
759     }
760 
761     /**
762      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
763      * `r` and `s` signature fields separately.
764      *
765      * _Available since v4.3._
766      */
767     function tryRecover(
768         bytes32 hash,
769         uint8 v,
770         bytes32 r,
771         bytes32 s
772     ) internal pure returns (address, RecoverError) {
773         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
774         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
775         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
776         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
777         //
778         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
779         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
780         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
781         // these malleable signatures as well.
782         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
783             return (address(0), RecoverError.InvalidSignatureS);
784         }
785         if (v != 27 && v != 28) {
786             return (address(0), RecoverError.InvalidSignatureV);
787         }
788 
789         // If the signature is valid (and not malleable), return the signer address
790         address signer = ecrecover(hash, v, r, s);
791         if (signer == address(0)) {
792             return (address(0), RecoverError.InvalidSignature);
793         }
794 
795         return (signer, RecoverError.NoError);
796     }
797 
798     /**
799      * @dev Overload of {ECDSA-recover} that receives the `v`,
800      * `r` and `s` signature fields separately.
801      */
802     function recover(
803         bytes32 hash,
804         uint8 v,
805         bytes32 r,
806         bytes32 s
807     ) internal pure returns (address) {
808         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
809         _throwError(error);
810         return recovered;
811     }
812 
813     /**
814      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
815      * produces hash corresponding to the one signed with the
816      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
817      * JSON-RPC method as part of EIP-191.
818      *
819      * See {recover}.
820      */
821     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
822         // 32 is the length in bytes of hash,
823         // enforced by the type signature above
824         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
825     }
826 
827     /**
828      * @dev Returns an Ethereum Signed Message, created from `s`. This
829      * produces hash corresponding to the one signed with the
830      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
831      * JSON-RPC method as part of EIP-191.
832      *
833      * See {recover}.
834      */
835     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
836         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
837     }
838 
839     /**
840      * @dev Returns an Ethereum Signed Typed Data, created from a
841      * `domainSeparator` and a `structHash`. This produces hash corresponding
842      * to the one signed with the
843      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
844      * JSON-RPC method as part of EIP-712.
845      *
846      * See {recover}.
847      */
848     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
849         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
850     }
851 }
852 
853 // File: @openzeppelin/contracts/utils/Context.sol
854 
855 
856 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
857 
858 pragma solidity ^0.8.0;
859 
860 /**
861  * @dev Provides information about the current execution context, including the
862  * sender of the transaction and its data. While these are generally available
863  * via msg.sender and msg.data, they should not be accessed in such a direct
864  * manner, since when dealing with meta-transactions the account sending and
865  * paying for execution may not be the actual sender (as far as an application
866  * is concerned).
867  *
868  * This contract is only required for intermediate, library-like contracts.
869  */
870 abstract contract Context {
871     function _msgSender() internal view virtual returns (address) {
872         return msg.sender;
873     }
874 
875     function _msgData() internal view virtual returns (bytes calldata) {
876         return msg.data;
877     }
878 }
879 
880 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
881 
882 
883 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
884 
885 pragma solidity ^0.8.0;
886 
887 
888 
889 
890 
891 
892 
893 
894 /**
895  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
896  * the Metadata extension, but not including the Enumerable extension, which is available separately as
897  * {ERC721Enumerable}.
898  */
899 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
900     using Address for address;
901     using Strings for uint256;
902 
903     // Token name
904     string private _name;
905 
906     // Token symbol
907     string private _symbol;
908 
909     // Mapping from token ID to owner address
910     mapping(uint256 => address) private _owners;
911 
912     // Mapping owner address to token count
913     mapping(address => uint256) private _balances;
914 
915     // Mapping from token ID to approved address
916     mapping(uint256 => address) private _tokenApprovals;
917 
918     // Mapping from owner to operator approvals
919     mapping(address => mapping(address => bool)) private _operatorApprovals;
920 
921     /**
922      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
923      */
924     constructor(string memory name_, string memory symbol_) {
925         _name = name_;
926         _symbol = symbol_;
927     }
928 
929     /**
930      * @dev See {IERC165-supportsInterface}.
931      */
932     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
933         return
934             interfaceId == type(IERC721).interfaceId ||
935             interfaceId == type(IERC721Metadata).interfaceId ||
936             super.supportsInterface(interfaceId);
937     }
938 
939     /**
940      * @dev See {IERC721-balanceOf}.
941      */
942     function balanceOf(address owner) public view virtual override returns (uint256) {
943         require(owner != address(0), "ERC721: address zero is not a valid owner");
944         return _balances[owner];
945     }
946 
947     /**
948      * @dev See {IERC721-ownerOf}.
949      */
950     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
951         address owner = _owners[tokenId];
952         require(owner != address(0), "ERC721: invalid token ID");
953         return owner;
954     }
955 
956     /**
957      * @dev See {IERC721Metadata-name}.
958      */
959     function name() public view virtual override returns (string memory) {
960         return _name;
961     }
962 
963     /**
964      * @dev See {IERC721Metadata-symbol}.
965      */
966     function symbol() public view virtual override returns (string memory) {
967         return _symbol;
968     }
969 
970     /**
971      * @dev See {IERC721Metadata-tokenURI}.
972      */
973     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
974         _requireMinted(tokenId);
975 
976         string memory baseURI = _baseURI();
977         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
978     }
979 
980     /**
981      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
982      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
983      * by default, can be overridden in child contracts.
984      */
985     function _baseURI() internal view virtual returns (string memory) {
986         return "";
987     }
988 
989     /**
990      * @dev See {IERC721-approve}.
991      */
992     function approve(address to, uint256 tokenId) public virtual override {
993         address owner = ERC721.ownerOf(tokenId);
994         require(to != owner, "ERC721: approval to current owner");
995 
996         require(
997             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
998             "ERC721: approve caller is not token owner nor approved for all"
999         );
1000 
1001         _approve(to, tokenId);
1002     }
1003 
1004     /**
1005      * @dev See {IERC721-getApproved}.
1006      */
1007     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1008         _requireMinted(tokenId);
1009 
1010         return _tokenApprovals[tokenId];
1011     }
1012 
1013     /**
1014      * @dev See {IERC721-setApprovalForAll}.
1015      */
1016     function setApprovalForAll(address operator, bool approved) public virtual override {
1017         _setApprovalForAll(_msgSender(), operator, approved);
1018     }
1019 
1020     /**
1021      * @dev See {IERC721-isApprovedForAll}.
1022      */
1023     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1024         return _operatorApprovals[owner][operator];
1025     }
1026 
1027     /**
1028      * @dev See {IERC721-transferFrom}.
1029      */
1030     function transferFrom(
1031         address from,
1032         address to,
1033         uint256 tokenId
1034     ) public virtual override {
1035         //solhint-disable-next-line max-line-length
1036         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
1037 
1038         _transfer(from, to, tokenId);
1039     }
1040 
1041     /**
1042      * @dev See {IERC721-safeTransferFrom}.
1043      */
1044     function safeTransferFrom(
1045         address from,
1046         address to,
1047         uint256 tokenId
1048     ) public virtual override {
1049         safeTransferFrom(from, to, tokenId, "");
1050     }
1051 
1052     /**
1053      * @dev See {IERC721-safeTransferFrom}.
1054      */
1055     function safeTransferFrom(
1056         address from,
1057         address to,
1058         uint256 tokenId,
1059         bytes memory data
1060     ) public virtual override {
1061         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
1062         _safeTransfer(from, to, tokenId, data);
1063     }
1064 
1065     /**
1066      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1067      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1068      *
1069      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1070      *
1071      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1072      * implement alternative mechanisms to perform token transfer, such as signature-based.
1073      *
1074      * Requirements:
1075      *
1076      * - `from` cannot be the zero address.
1077      * - `to` cannot be the zero address.
1078      * - `tokenId` token must exist and be owned by `from`.
1079      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1080      *
1081      * Emits a {Transfer} event.
1082      */
1083     function _safeTransfer(
1084         address from,
1085         address to,
1086         uint256 tokenId,
1087         bytes memory data
1088     ) internal virtual {
1089         _transfer(from, to, tokenId);
1090         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1091     }
1092 
1093     /**
1094      * @dev Returns whether `tokenId` exists.
1095      *
1096      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1097      *
1098      * Tokens start existing when they are minted (`_mint`),
1099      * and stop existing when they are burned (`_burn`).
1100      */
1101     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1102         return _owners[tokenId] != address(0);
1103     }
1104 
1105     /**
1106      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1107      *
1108      * Requirements:
1109      *
1110      * - `tokenId` must exist.
1111      */
1112     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1113         address owner = ERC721.ownerOf(tokenId);
1114         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1115     }
1116 
1117     /**
1118      * @dev Safely mints `tokenId` and transfers it to `to`.
1119      *
1120      * Requirements:
1121      *
1122      * - `tokenId` must not exist.
1123      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1124      *
1125      * Emits a {Transfer} event.
1126      */
1127     function _safeMint(address to, uint256 tokenId) internal virtual {
1128         _safeMint(to, tokenId, "");
1129     }
1130 
1131     /**
1132      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1133      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1134      */
1135     function _safeMint(
1136         address to,
1137         uint256 tokenId,
1138         bytes memory data
1139     ) internal virtual {
1140         _mint(to, tokenId);
1141         require(
1142             _checkOnERC721Received(address(0), to, tokenId, data),
1143             "ERC721: transfer to non ERC721Receiver implementer"
1144         );
1145     }
1146 
1147     /**
1148      * @dev Mints `tokenId` and transfers it to `to`.
1149      *
1150      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1151      *
1152      * Requirements:
1153      *
1154      * - `tokenId` must not exist.
1155      * - `to` cannot be the zero address.
1156      *
1157      * Emits a {Transfer} event.
1158      */
1159     function _mint(address to, uint256 tokenId) internal virtual {
1160         require(to != address(0), "ERC721: mint to the zero address");
1161         require(!_exists(tokenId), "ERC721: token already minted");
1162 
1163         _beforeTokenTransfer(address(0), to, tokenId);
1164 
1165         _balances[to] += 1;
1166         _owners[tokenId] = to;
1167 
1168         emit Transfer(address(0), to, tokenId);
1169 
1170         _afterTokenTransfer(address(0), to, tokenId);
1171     }
1172 
1173     /**
1174      * @dev Destroys `tokenId`.
1175      * The approval is cleared when the token is burned.
1176      *
1177      * Requirements:
1178      *
1179      * - `tokenId` must exist.
1180      *
1181      * Emits a {Transfer} event.
1182      */
1183     function _burn(uint256 tokenId) internal virtual {
1184         address owner = ERC721.ownerOf(tokenId);
1185 
1186         _beforeTokenTransfer(owner, address(0), tokenId);
1187 
1188         // Clear approvals
1189         _approve(address(0), tokenId);
1190 
1191         _balances[owner] -= 1;
1192         delete _owners[tokenId];
1193 
1194         emit Transfer(owner, address(0), tokenId);
1195 
1196         _afterTokenTransfer(owner, address(0), tokenId);
1197     }
1198 
1199     /**
1200      * @dev Transfers `tokenId` from `from` to `to`.
1201      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1202      *
1203      * Requirements:
1204      *
1205      * - `to` cannot be the zero address.
1206      * - `tokenId` token must be owned by `from`.
1207      *
1208      * Emits a {Transfer} event.
1209      */
1210     function _transfer(
1211         address from,
1212         address to,
1213         uint256 tokenId
1214     ) internal virtual {
1215         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1216         require(to != address(0), "ERC721: transfer to the zero address");
1217 
1218         _beforeTokenTransfer(from, to, tokenId);
1219 
1220         // Clear approvals from the previous owner
1221         _approve(address(0), tokenId);
1222 
1223         _balances[from] -= 1;
1224         _balances[to] += 1;
1225         _owners[tokenId] = to;
1226 
1227         emit Transfer(from, to, tokenId);
1228 
1229         _afterTokenTransfer(from, to, tokenId);
1230     }
1231 
1232     /**
1233      * @dev Approve `to` to operate on `tokenId`
1234      *
1235      * Emits an {Approval} event.
1236      */
1237     function _approve(address to, uint256 tokenId) internal virtual {
1238         _tokenApprovals[tokenId] = to;
1239         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1240     }
1241 
1242     /**
1243      * @dev Approve `operator` to operate on all of `owner` tokens
1244      *
1245      * Emits an {ApprovalForAll} event.
1246      */
1247     function _setApprovalForAll(
1248         address owner,
1249         address operator,
1250         bool approved
1251     ) internal virtual {
1252         require(owner != operator, "ERC721: approve to caller");
1253         _operatorApprovals[owner][operator] = approved;
1254         emit ApprovalForAll(owner, operator, approved);
1255     }
1256 
1257     /**
1258      * @dev Reverts if the `tokenId` has not been minted yet.
1259      */
1260     function _requireMinted(uint256 tokenId) internal view virtual {
1261         require(_exists(tokenId), "ERC721: invalid token ID");
1262     }
1263 
1264     /**
1265      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1266      * The call is not executed if the target address is not a contract.
1267      *
1268      * @param from address representing the previous owner of the given token ID
1269      * @param to target address that will receive the tokens
1270      * @param tokenId uint256 ID of the token to be transferred
1271      * @param data bytes optional data to send along with the call
1272      * @return bool whether the call correctly returned the expected magic value
1273      */
1274     function _checkOnERC721Received(
1275         address from,
1276         address to,
1277         uint256 tokenId,
1278         bytes memory data
1279     ) private returns (bool) {
1280         if (to.isContract()) {
1281             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1282                 return retval == IERC721Receiver.onERC721Received.selector;
1283             } catch (bytes memory reason) {
1284                 if (reason.length == 0) {
1285                     revert("ERC721: transfer to non ERC721Receiver implementer");
1286                 } else {
1287                     /// @solidity memory-safe-assembly
1288                     assembly {
1289                         revert(add(32, reason), mload(reason))
1290                     }
1291                 }
1292             }
1293         } else {
1294             return true;
1295         }
1296     }
1297 
1298     /**
1299      * @dev Hook that is called before any token transfer. This includes minting
1300      * and burning.
1301      *
1302      * Calling conditions:
1303      *
1304      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1305      * transferred to `to`.
1306      * - When `from` is zero, `tokenId` will be minted for `to`.
1307      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1308      * - `from` and `to` are never both zero.
1309      *
1310      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1311      */
1312     function _beforeTokenTransfer(
1313         address from,
1314         address to,
1315         uint256 tokenId
1316     ) internal virtual {}
1317 
1318     /**
1319      * @dev Hook that is called after any transfer of tokens. This includes
1320      * minting and burning.
1321      *
1322      * Calling conditions:
1323      *
1324      * - when `from` and `to` are both non-zero.
1325      * - `from` and `to` are never both zero.
1326      *
1327      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1328      */
1329     function _afterTokenTransfer(
1330         address from,
1331         address to,
1332         uint256 tokenId
1333     ) internal virtual {}
1334 }
1335 
1336 // File: @openzeppelin/contracts/access/Ownable.sol
1337 
1338 
1339 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1340 
1341 pragma solidity ^0.8.0;
1342 
1343 
1344 /**
1345  * @dev Contract module which provides a basic access control mechanism, where
1346  * there is an account (an owner) that can be granted exclusive access to
1347  * specific functions.
1348  *
1349  * By default, the owner account will be the one that deploys the contract. This
1350  * can later be changed with {transferOwnership}.
1351  *
1352  * This module is used through inheritance. It will make available the modifier
1353  * `onlyOwner`, which can be applied to your functions to restrict their use to
1354  * the owner.
1355  */
1356 abstract contract Ownable is Context {
1357     address private _owner;
1358 
1359     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1360 
1361     /**
1362      * @dev Initializes the contract setting the deployer as the initial owner.
1363      */
1364     constructor() {
1365         _transferOwnership(_msgSender());
1366     }
1367 
1368     /**
1369      * @dev Throws if called by any account other than the owner.
1370      */
1371     modifier onlyOwner() {
1372         _checkOwner();
1373         _;
1374     }
1375 
1376     /**
1377      * @dev Returns the address of the current owner.
1378      */
1379     function owner() public view virtual returns (address) {
1380         return _owner;
1381     }
1382 
1383     /**
1384      * @dev Throws if the sender is not the owner.
1385      */
1386     function _checkOwner() internal view virtual {
1387         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1388     }
1389 
1390     /**
1391      * @dev Leaves the contract without owner. It will not be possible to call
1392      * `onlyOwner` functions anymore. Can only be called by the current owner.
1393      *
1394      * NOTE: Renouncing ownership will leave the contract without an owner,
1395      * thereby removing any functionality that is only available to the owner.
1396      */
1397     function renounceOwnership() public virtual onlyOwner {
1398         _transferOwnership(address(0));
1399     }
1400 
1401     /**
1402      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1403      * Can only be called by the current owner.
1404      */
1405     function transferOwnership(address newOwner) public virtual onlyOwner {
1406         require(newOwner != address(0), "Ownable: new owner is the zero address");
1407         _transferOwnership(newOwner);
1408     }
1409 
1410     /**
1411      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1412      * Internal function without access restriction.
1413      */
1414     function _transferOwnership(address newOwner) internal virtual {
1415         address oldOwner = _owner;
1416         _owner = newOwner;
1417         emit OwnershipTransferred(oldOwner, newOwner);
1418     }
1419 }
1420 
1421 // File: contracts/RichieStacking.sol
1422 
1423 //SPDX-License-Identifier: MIT
1424 pragma solidity ^0.8.7;
1425 
1426 
1427 
1428 
1429 
1430 contract RagsToRichieStaking is Ownable, ReentrancyGuard {
1431 
1432     struct Stack {
1433         address owner;
1434         uint card;
1435         uint richie;
1436     }
1437     
1438     mapping (uint => Stack) Stacked;
1439 
1440     // Address collection NFT
1441     ERC721 private collectionRichie;
1442 
1443     // Address collection NFT
1444     ERC721 private collectionRichieBank;
1445 
1446     // Staking is paused
1447     bool private isPaused;
1448 
1449     // Total NFT staked
1450     uint public totalStacked;
1451 
1452     constructor(ERC721 _collectionRichie, ERC721 _collectionRichieBank) {
1453         collectionRichie = _collectionRichie;
1454         collectionRichieBank = _collectionRichieBank;
1455     }
1456 
1457     /*
1458     * Function to register staker
1459     * @params _tokenId
1460     */
1461     function stack(uint  _richie, uint  _richieBank) external nonReentrant {
1462         require(isPaused == false, "Staking paused");
1463         require(collectionRichie.ownerOf(_richie) == msg.sender, "Not the owner");
1464         require(collectionRichieBank.ownerOf(_richieBank) == msg.sender, "Not the owner");
1465         require(Stacked[_richie].owner == address(0), "This token is already staked");
1466 
1467         collectionRichie.transferFrom(msg.sender, address(this), _richie);
1468         collectionRichieBank.transferFrom(msg.sender, address(this), _richieBank);
1469 
1470         Stacked[_richie].richie = _richie;
1471         Stacked[_richie].card = _richieBank;
1472         Stacked[_richie].owner = msg.sender;
1473 
1474         totalStacked += 1;
1475     }
1476 
1477     /*
1478     * Function to withraw NFT
1479     * @params _owner
1480     * @params _tokenId
1481     */
1482     function unStack(uint _richie) external nonReentrant {
1483         require(isPaused == false, "Staking paused");
1484         require(Stacked[_richie].owner == msg.sender, "Not the owner");
1485 
1486         // Transfert NFT to the owner
1487         collectionRichie.transferFrom(address(this), msg.sender, _richie);
1488         collectionRichieBank.transferFrom(address(this), msg.sender, Stacked[_richie].card);
1489 
1490         // Unstack from staking
1491         Stacked[_richie].richie = 0;
1492         Stacked[_richie].card = 0;
1493         Stacked[_richie].owner = address(0);
1494         totalStacked -= 1;
1495     }
1496 
1497     /*
1498     * Function to get richie by index
1499     * @params _richie
1500     */
1501     function getRichieOf(uint _richie) public view returns (Stack memory){
1502         return Stacked[_richie];
1503     }
1504 
1505     /*
1506     * Function to set the richie collection
1507     * @params _richie
1508     * @params _destination
1509     */
1510     function setCollectionRichie(ERC721 _collectionRichie) onlyOwner external {
1511         collectionRichie = _collectionRichie;
1512     }
1513 
1514     /*
1515     * Function to set the richie bank collection
1516     * @params _richie
1517     * @params _destination
1518     */
1519     function setCollectionRichieBank(ERC721 _collectionRichieBank) onlyOwner external {
1520         collectionRichieBank = _collectionRichieBank;
1521     }
1522 
1523     /*
1524     * Function to adjust stacking
1525     * @params _richie
1526     * @params _destination
1527     */
1528     function updateStacking(uint _index, uint _richie, uint _card, address _owner) onlyOwner external {
1529         Stacked[_index].richie = _richie;
1530         Stacked[_index].card = _card;
1531         Stacked[_index].owner = _owner;
1532     }
1533 
1534     /*
1535     * Function to transfer back a richie
1536     * @params _richie
1537     * @params _destination
1538     */
1539     function transferRichie(uint _richie, address _destination) onlyOwner external {
1540         collectionRichie.transferFrom(address(this), _destination, _richie);
1541     }
1542 
1543     /*
1544     * Function to transfer back a richie bank
1545     * @params _richieBank
1546     * @params _destination
1547     */
1548     function transferRichieBank(uint _richieBank, address _destination) onlyOwner external {
1549         collectionRichieBank.transferFrom(address(this), _destination, _richieBank);
1550     }
1551 
1552     // Functions admin
1553 
1554     /*
1555     * Function to pause staking
1556     * @params _isActive
1557     */
1558     function pauseStaking(bool _isActive) onlyOwner external {
1559         isPaused = _isActive;
1560     }
1561 
1562 }