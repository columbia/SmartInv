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
520 // File: Templates/includes/IReverseRegistrar.sol
521 
522 
523 
524 pragma solidity >=0.8.4;
525 
526 interface IReverseRegistrar {
527     function setDefaultResolver(address resolver) external;
528 
529     function claim(address owner) external returns (bytes32);
530 
531     function claimForAddr(
532         address addr,
533         address owner,
534         address resolver
535     ) external returns (bytes32);
536 
537     function claimWithResolver(address owner, address resolver)
538         external
539         returns (bytes32);
540 
541     function setName(string memory name) external returns (bytes32);
542 
543     function setNameForAddr(
544         address addr,
545         address owner,
546         address resolver,
547         string memory name
548     ) external returns (bytes32);
549 
550     function node(address addr) external pure returns (bytes32);
551 }
552 // File: @openzeppelin/contracts/utils/Strings.sol
553 
554 
555 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
556 
557 pragma solidity ^0.8.0;
558 
559 /**
560  * @dev String operations.
561  */
562 library Strings {
563     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
564     uint8 private constant _ADDRESS_LENGTH = 20;
565 
566     /**
567      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
568      */
569     function toString(uint256 value) internal pure returns (string memory) {
570         // Inspired by OraclizeAPI's implementation - MIT licence
571         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
572 
573         if (value == 0) {
574             return "0";
575         }
576         uint256 temp = value;
577         uint256 digits;
578         while (temp != 0) {
579             digits++;
580             temp /= 10;
581         }
582         bytes memory buffer = new bytes(digits);
583         while (value != 0) {
584             digits -= 1;
585             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
586             value /= 10;
587         }
588         return string(buffer);
589     }
590 
591     /**
592      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
593      */
594     function toHexString(uint256 value) internal pure returns (string memory) {
595         if (value == 0) {
596             return "0x00";
597         }
598         uint256 temp = value;
599         uint256 length = 0;
600         while (temp != 0) {
601             length++;
602             temp >>= 8;
603         }
604         return toHexString(value, length);
605     }
606 
607     /**
608      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
609      */
610     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
611         bytes memory buffer = new bytes(2 * length + 2);
612         buffer[0] = "0";
613         buffer[1] = "x";
614         for (uint256 i = 2 * length + 1; i > 1; --i) {
615             buffer[i] = _HEX_SYMBOLS[value & 0xf];
616             value >>= 4;
617         }
618         require(value == 0, "Strings: hex length insufficient");
619         return string(buffer);
620     }
621 
622     /**
623      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
624      */
625     function toHexString(address addr) internal pure returns (string memory) {
626         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
627     }
628 }
629 
630 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
631 
632 
633 // OpenZeppelin Contracts (last updated v4.7.3) (utils/cryptography/ECDSA.sol)
634 
635 pragma solidity ^0.8.0;
636 
637 
638 /**
639  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
640  *
641  * These functions can be used to verify that a message was signed by the holder
642  * of the private keys of a given address.
643  */
644 library ECDSA {
645     enum RecoverError {
646         NoError,
647         InvalidSignature,
648         InvalidSignatureLength,
649         InvalidSignatureS,
650         InvalidSignatureV
651     }
652 
653     function _throwError(RecoverError error) private pure {
654         if (error == RecoverError.NoError) {
655             return; // no error: do nothing
656         } else if (error == RecoverError.InvalidSignature) {
657             revert("ECDSA: invalid signature");
658         } else if (error == RecoverError.InvalidSignatureLength) {
659             revert("ECDSA: invalid signature length");
660         } else if (error == RecoverError.InvalidSignatureS) {
661             revert("ECDSA: invalid signature 's' value");
662         } else if (error == RecoverError.InvalidSignatureV) {
663             revert("ECDSA: invalid signature 'v' value");
664         }
665     }
666 
667     /**
668      * @dev Returns the address that signed a hashed message (`hash`) with
669      * `signature` or error string. This address can then be used for verification purposes.
670      *
671      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
672      * this function rejects them by requiring the `s` value to be in the lower
673      * half order, and the `v` value to be either 27 or 28.
674      *
675      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
676      * verification to be secure: it is possible to craft signatures that
677      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
678      * this is by receiving a hash of the original message (which may otherwise
679      * be too long), and then calling {toEthSignedMessageHash} on it.
680      *
681      * Documentation for signature generation:
682      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
683      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
684      *
685      * _Available since v4.3._
686      */
687     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
688         if (signature.length == 65) {
689             bytes32 r;
690             bytes32 s;
691             uint8 v;
692             // ecrecover takes the signature parameters, and the only way to get them
693             // currently is to use assembly.
694             /// @solidity memory-safe-assembly
695             assembly {
696                 r := mload(add(signature, 0x20))
697                 s := mload(add(signature, 0x40))
698                 v := byte(0, mload(add(signature, 0x60)))
699             }
700             return tryRecover(hash, v, r, s);
701         } else {
702             return (address(0), RecoverError.InvalidSignatureLength);
703         }
704     }
705 
706     /**
707      * @dev Returns the address that signed a hashed message (`hash`) with
708      * `signature`. This address can then be used for verification purposes.
709      *
710      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
711      * this function rejects them by requiring the `s` value to be in the lower
712      * half order, and the `v` value to be either 27 or 28.
713      *
714      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
715      * verification to be secure: it is possible to craft signatures that
716      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
717      * this is by receiving a hash of the original message (which may otherwise
718      * be too long), and then calling {toEthSignedMessageHash} on it.
719      */
720     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
721         (address recovered, RecoverError error) = tryRecover(hash, signature);
722         _throwError(error);
723         return recovered;
724     }
725 
726     /**
727      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
728      *
729      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
730      *
731      * _Available since v4.3._
732      */
733     function tryRecover(
734         bytes32 hash,
735         bytes32 r,
736         bytes32 vs
737     ) internal pure returns (address, RecoverError) {
738         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
739         uint8 v = uint8((uint256(vs) >> 255) + 27);
740         return tryRecover(hash, v, r, s);
741     }
742 
743     /**
744      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
745      *
746      * _Available since v4.2._
747      */
748     function recover(
749         bytes32 hash,
750         bytes32 r,
751         bytes32 vs
752     ) internal pure returns (address) {
753         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
754         _throwError(error);
755         return recovered;
756     }
757 
758     /**
759      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
760      * `r` and `s` signature fields separately.
761      *
762      * _Available since v4.3._
763      */
764     function tryRecover(
765         bytes32 hash,
766         uint8 v,
767         bytes32 r,
768         bytes32 s
769     ) internal pure returns (address, RecoverError) {
770         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
771         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
772         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
773         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
774         //
775         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
776         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
777         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
778         // these malleable signatures as well.
779         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
780             return (address(0), RecoverError.InvalidSignatureS);
781         }
782         if (v != 27 && v != 28) {
783             return (address(0), RecoverError.InvalidSignatureV);
784         }
785 
786         // If the signature is valid (and not malleable), return the signer address
787         address signer = ecrecover(hash, v, r, s);
788         if (signer == address(0)) {
789             return (address(0), RecoverError.InvalidSignature);
790         }
791 
792         return (signer, RecoverError.NoError);
793     }
794 
795     /**
796      * @dev Overload of {ECDSA-recover} that receives the `v`,
797      * `r` and `s` signature fields separately.
798      */
799     function recover(
800         bytes32 hash,
801         uint8 v,
802         bytes32 r,
803         bytes32 s
804     ) internal pure returns (address) {
805         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
806         _throwError(error);
807         return recovered;
808     }
809 
810     /**
811      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
812      * produces hash corresponding to the one signed with the
813      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
814      * JSON-RPC method as part of EIP-191.
815      *
816      * See {recover}.
817      */
818     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
819         // 32 is the length in bytes of hash,
820         // enforced by the type signature above
821         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
822     }
823 
824     /**
825      * @dev Returns an Ethereum Signed Message, created from `s`. This
826      * produces hash corresponding to the one signed with the
827      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
828      * JSON-RPC method as part of EIP-191.
829      *
830      * See {recover}.
831      */
832     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
833         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
834     }
835 
836     /**
837      * @dev Returns an Ethereum Signed Typed Data, created from a
838      * `domainSeparator` and a `structHash`. This produces hash corresponding
839      * to the one signed with the
840      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
841      * JSON-RPC method as part of EIP-712.
842      *
843      * See {recover}.
844      */
845     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
846         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
847     }
848 }
849 
850 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
851 
852 
853 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
854 
855 pragma solidity ^0.8.0;
856 
857 /**
858  * @dev Interface of the ERC20 standard as defined in the EIP.
859  */
860 interface IERC20 {
861     /**
862      * @dev Emitted when `value` tokens are moved from one account (`from`) to
863      * another (`to`).
864      *
865      * Note that `value` may be zero.
866      */
867     event Transfer(address indexed from, address indexed to, uint256 value);
868 
869     /**
870      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
871      * a call to {approve}. `value` is the new allowance.
872      */
873     event Approval(address indexed owner, address indexed spender, uint256 value);
874 
875     /**
876      * @dev Returns the amount of tokens in existence.
877      */
878     function totalSupply() external view returns (uint256);
879 
880     /**
881      * @dev Returns the amount of tokens owned by `account`.
882      */
883     function balanceOf(address account) external view returns (uint256);
884 
885     /**
886      * @dev Moves `amount` tokens from the caller's account to `to`.
887      *
888      * Returns a boolean value indicating whether the operation succeeded.
889      *
890      * Emits a {Transfer} event.
891      */
892     function transfer(address to, uint256 amount) external returns (bool);
893 
894     /**
895      * @dev Returns the remaining number of tokens that `spender` will be
896      * allowed to spend on behalf of `owner` through {transferFrom}. This is
897      * zero by default.
898      *
899      * This value changes when {approve} or {transferFrom} are called.
900      */
901     function allowance(address owner, address spender) external view returns (uint256);
902 
903     /**
904      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
905      *
906      * Returns a boolean value indicating whether the operation succeeded.
907      *
908      * IMPORTANT: Beware that changing an allowance with this method brings the risk
909      * that someone may use both the old and the new allowance by unfortunate
910      * transaction ordering. One possible solution to mitigate this race
911      * condition is to first reduce the spender's allowance to 0 and set the
912      * desired value afterwards:
913      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
914      *
915      * Emits an {Approval} event.
916      */
917     function approve(address spender, uint256 amount) external returns (bool);
918 
919     /**
920      * @dev Moves `amount` tokens from `from` to `to` using the
921      * allowance mechanism. `amount` is then deducted from the caller's
922      * allowance.
923      *
924      * Returns a boolean value indicating whether the operation succeeded.
925      *
926      * Emits a {Transfer} event.
927      */
928     function transferFrom(
929         address from,
930         address to,
931         uint256 amount
932     ) external returns (bool);
933 }
934 
935 // File: @openzeppelin/contracts/utils/Context.sol
936 
937 
938 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
939 
940 pragma solidity ^0.8.0;
941 
942 /**
943  * @dev Provides information about the current execution context, including the
944  * sender of the transaction and its data. While these are generally available
945  * via msg.sender and msg.data, they should not be accessed in such a direct
946  * manner, since when dealing with meta-transactions the account sending and
947  * paying for execution may not be the actual sender (as far as an application
948  * is concerned).
949  *
950  * This contract is only required for intermediate, library-like contracts.
951  */
952 abstract contract Context {
953     function _msgSender() internal view virtual returns (address) {
954         return msg.sender;
955     }
956 
957     function _msgData() internal view virtual returns (bytes calldata) {
958         return msg.data;
959     }
960 }
961 
962 // File: Templates/includes/ERC721.sol
963 
964 
965 // Creator: Chiru Labs
966 
967 pragma solidity ^0.8.10;
968 
969 
970 
971 
972 
973 
974 
975 
976 
977 /**
978  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
979  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
980  *
981  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
982  *
983  * Does not support burning tokens to address(0).
984  */
985 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
986     using Address for address;
987     using Strings for uint256;
988 
989     struct TokenOwnership {
990         address addr;
991         uint64 startTimestamp;
992     }
993 
994     struct AddressData {
995         uint128 balance;
996         uint128 numberMinted;
997     }
998 
999     uint256 private currentIndex = 0;
1000 
1001     uint256 internal immutable maxBatchSize;
1002 
1003     // Token name
1004     string private _name;
1005 
1006     // Token symbol
1007     string private _symbol;
1008 
1009     // Base URI
1010     string private _baseURI;
1011 
1012     // Mapping from token ID to ownership details
1013     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1014     mapping(uint256 => TokenOwnership) private _ownerships;
1015 
1016     // Mapping owner address to address data
1017     mapping(address => AddressData) private _addressData;
1018 
1019     // Mapping from token ID to approved address
1020     mapping(uint256 => address) private _tokenApprovals;
1021 
1022     // Mapping from owner to operator approvals
1023     mapping(address => mapping(address => bool)) private _operatorApprovals;
1024 
1025     /**
1026      * @dev
1027      * `maxBatchSize` refers to how much a minter can mint at a time.
1028      */
1029     constructor(
1030         string memory name_,
1031         string memory symbol_,
1032         uint256 maxBatchSize_
1033     ) {
1034         require(maxBatchSize_ > 0, "b");
1035         _name = name_;
1036         _symbol = symbol_;
1037         maxBatchSize = maxBatchSize_;
1038     }
1039 
1040     /**
1041      * @dev See {IERC721Enumerable-totalSupply}.
1042      */
1043     function totalSupply() public view override returns (uint256) {
1044         return currentIndex;
1045     }
1046 
1047     /**
1048      * @dev See {IERC721Enumerable-tokenByIndex}.
1049      */
1050     function tokenByIndex(uint256 index) public view override returns (uint256) {
1051         require(index < totalSupply(), "g");
1052         return index;
1053     }
1054 
1055     /**
1056      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1057      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1058      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1059      */
1060     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1061         require(index < balanceOf(owner), "b");
1062         uint256 numMintedSoFar = totalSupply();
1063         uint256 tokenIdsIdx = 0;
1064         address currOwnershipAddr = address(0);
1065         for (uint256 i = 0; i < numMintedSoFar; i++) {
1066             TokenOwnership memory ownership = _ownerships[i];
1067             if (ownership.addr != address(0)) {
1068                 currOwnershipAddr = ownership.addr;
1069             }
1070             if (currOwnershipAddr == owner) {
1071                 if (tokenIdsIdx == index) {
1072                     return i;
1073                 }
1074                 tokenIdsIdx++;
1075             }
1076         }
1077         revert("u");
1078     }
1079 
1080     /**
1081      * @dev See {IERC165-supportsInterface}.
1082      */
1083     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1084         return
1085             interfaceId == type(IERC721).interfaceId ||
1086             interfaceId == type(IERC721Metadata).interfaceId ||
1087             interfaceId == type(IERC721Enumerable).interfaceId ||
1088             super.supportsInterface(interfaceId);
1089     }
1090 
1091     /**
1092      * @dev See {IERC721-balanceOf}.
1093      */
1094     function balanceOf(address owner) public view override returns (uint256) {
1095         require(owner != address(0), "0");
1096         return uint256(_addressData[owner].balance);
1097     }
1098 
1099     function _numberMinted(address owner) internal view returns (uint256) {
1100         require(owner != address(0), "0");
1101         return uint256(_addressData[owner].numberMinted);
1102     }
1103 
1104     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1105         require(_exists(tokenId), "t");
1106 
1107         uint256 lowestTokenToCheck;
1108         if (tokenId >= maxBatchSize) {
1109             lowestTokenToCheck = tokenId - maxBatchSize + 1;
1110         }
1111 
1112         for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
1113             TokenOwnership memory ownership = _ownerships[curr];
1114             if (ownership.addr != address(0)) {
1115                 return ownership;
1116             }
1117         }
1118 
1119         revert("o");
1120     }
1121 
1122     /**
1123      * @dev See {IERC721-ownerOf}.
1124      */
1125     function ownerOf(uint256 tokenId) public view override returns (address) {
1126         return ownershipOf(tokenId).addr;
1127     }
1128 
1129     /**
1130      * @dev See {IERC721Metadata-name}.
1131      */
1132     function name() public view virtual override returns (string memory) {
1133         return _name;
1134     }
1135 
1136     /**
1137      * @dev See {IERC721Metadata-symbol}.
1138      */
1139     function symbol() public view virtual override returns (string memory) {
1140         return _symbol;
1141     }
1142 
1143     /**
1144      * @dev See {IERC721Metadata-tokenURI}.
1145      */
1146     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1147         require(_exists(tokenId), "z");
1148 
1149         return bytes(_baseURI).length > 0 ? string(abi.encodePacked(_baseURI, tokenId.toString())) : "";
1150     }
1151 
1152     /**
1153      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1154      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1155      * by default, can be overriden in child contracts.
1156      */
1157     function baseURI() public view virtual returns (string memory) {
1158         return _baseURI;
1159     }
1160 
1161     /**
1162      * @dev Internal function to set the base URI for all token IDs. It is
1163      * automatically added as a prefix to the value returned in {tokenURI},
1164      * or to the token ID if {tokenURI} is empty.
1165      */
1166     function _setBaseURI(string memory baseURI_) internal virtual {
1167         _baseURI = baseURI_;
1168     }
1169 
1170 
1171 
1172     /**
1173      * @dev See {IERC721-approve}.
1174      */
1175     function approve(address to, uint256 tokenId) public override {
1176         address owner = ERC721.ownerOf(tokenId);
1177         require(to != owner, "o");
1178 
1179         require(
1180             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1181             "a"
1182         );
1183 
1184         _approve(to, tokenId, owner);
1185     }
1186 
1187     /**
1188      * @dev See {IERC721-getApproved}.
1189      */
1190     function getApproved(uint256 tokenId) public view override returns (address) {
1191         require(_exists(tokenId), "a");
1192 
1193         return _tokenApprovals[tokenId];
1194     }
1195 
1196     /**
1197      * @dev See {IERC721-setApprovalForAll}.
1198      */
1199     function setApprovalForAll(address operator, bool approved) public override {
1200         require(operator != _msgSender(), "a");
1201 
1202         _operatorApprovals[_msgSender()][operator] = approved;
1203         emit ApprovalForAll(_msgSender(), operator, approved);
1204     }
1205 
1206     /**
1207      * @dev See {IERC721-isApprovedForAll}.
1208      */
1209     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1210         return _operatorApprovals[owner][operator];
1211     }
1212 
1213     /**
1214      * @dev See {IERC721-transferFrom}.
1215      */
1216     function transferFrom(
1217         address from,
1218         address to,
1219         uint256 tokenId
1220     ) public override {
1221         _transfer(from, to, tokenId);
1222     }
1223 
1224     /**
1225      * @dev See {IERC721-safeTransferFrom}.
1226      */
1227     function safeTransferFrom(
1228         address from,
1229         address to,
1230         uint256 tokenId
1231     ) public override {
1232         safeTransferFrom(from, to, tokenId, "");
1233     }
1234 
1235     /**
1236      * @dev See {IERC721-safeTransferFrom}.
1237      */
1238     function safeTransferFrom(
1239         address from,
1240         address to,
1241         uint256 tokenId,
1242         bytes memory _data
1243     ) public override {
1244         _transfer(from, to, tokenId);
1245         require(
1246             _checkOnERC721Received(from, to, tokenId, _data),
1247             "z"
1248         );
1249     }
1250 
1251     /**
1252      * @dev Returns whether `tokenId` exists.
1253      *
1254      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1255      *
1256      * Tokens start existing when they are minted (`_mint`),
1257      */
1258     function _exists(uint256 tokenId) internal view returns (bool) {
1259         return tokenId < currentIndex;
1260     }
1261 
1262     function _safeMint(address to, uint256 quantity) internal {
1263         _safeMint(to, quantity, "");
1264     }
1265 
1266     /**
1267      * @dev Mints `quantity` tokens and transfers them to `to`.
1268      *
1269      * Requirements:
1270      *
1271      * - `to` cannot be the zero address.
1272      * - `quantity` cannot be larger than the max batch size.
1273      *
1274      * Emits a {Transfer} event.
1275      */
1276     function _safeMint(
1277         address to,
1278         uint256 quantity,
1279         bytes memory _data
1280     ) internal {
1281         uint256 startTokenId = currentIndex;
1282         require(to != address(0), "0");
1283         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1284         require(!_exists(startTokenId), "a");
1285         require(quantity <= maxBatchSize, "m");
1286 
1287         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1288 
1289         AddressData memory addressData = _addressData[to];
1290         _addressData[to] = AddressData(
1291             addressData.balance + uint128(quantity),
1292             addressData.numberMinted + uint128(quantity)
1293         );
1294         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1295 
1296         uint256 updatedIndex = startTokenId;
1297 
1298         for (uint256 i = 0; i < quantity; i++) {
1299             emit Transfer(address(0), to, updatedIndex);
1300             require(
1301                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
1302                 "z"
1303             );
1304             updatedIndex++;
1305         }
1306 
1307         currentIndex = updatedIndex;
1308         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1309     }
1310 
1311     /**
1312      * @dev Transfers `tokenId` from `from` to `to`.
1313      *
1314      * Requirements:
1315      *
1316      * - `to` cannot be the zero address.
1317      * - `tokenId` token must be owned by `from`.
1318      *
1319      * Emits a {Transfer} event.
1320      */
1321     function _transfer(
1322         address from,
1323         address to,
1324         uint256 tokenId
1325     ) private {
1326         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1327 
1328         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1329             getApproved(tokenId) == _msgSender() ||
1330             isApprovedForAll(prevOwnership.addr, _msgSender()));
1331 
1332         require(isApprovedOrOwner, "a");
1333 
1334         require(prevOwnership.addr == from, "o");
1335         require(to != address(0), "0");
1336 
1337         _beforeTokenTransfers(from, to, tokenId, 1);
1338 
1339         // Clear approvals from the previous owner
1340         _approve(address(0), tokenId, prevOwnership.addr);
1341 
1342         _addressData[from].balance -= 1;
1343         _addressData[to].balance += 1;
1344         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1345 
1346         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1347         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1348         uint256 nextTokenId = tokenId + 1;
1349         if (_ownerships[nextTokenId].addr == address(0)) {
1350             if (_exists(nextTokenId)) {
1351                 _ownerships[nextTokenId] = TokenOwnership(prevOwnership.addr, prevOwnership.startTimestamp);
1352             }
1353         }
1354 
1355         emit Transfer(from, to, tokenId);
1356         _afterTokenTransfers(from, to, tokenId, 1);
1357     }
1358 
1359     /**
1360      * @dev Approve `to` to operate on `tokenId`
1361      *
1362      * Emits a {Approval} event.
1363      */
1364     function _approve(
1365         address to,
1366         uint256 tokenId,
1367         address owner
1368     ) private {
1369         _tokenApprovals[tokenId] = to;
1370         emit Approval(owner, to, tokenId);
1371     }
1372 
1373     uint256 public nextOwnerToExplicitlySet = 0;
1374 
1375     /**
1376      * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1377      */
1378     function _setOwnersExplicit(uint256 quantity) internal {
1379         uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1380         require(quantity > 0, "q");
1381         uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1382         if (endIndex > currentIndex - 1) {
1383             endIndex = currentIndex - 1;
1384         }
1385         // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1386         require(_exists(endIndex), "n");
1387         for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1388             if (_ownerships[i].addr == address(0)) {
1389                 TokenOwnership memory ownership = ownershipOf(i);
1390                 _ownerships[i] = TokenOwnership(ownership.addr, ownership.startTimestamp);
1391             }
1392         }
1393         nextOwnerToExplicitlySet = endIndex + 1;
1394     }
1395 
1396     /**
1397      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1398      * The call is not executed if the target address is not a contract.
1399      *
1400      * @param from address representing the previous owner of the given token ID
1401      * @param to target address that will receive the tokens
1402      * @param tokenId uint256 ID of the token to be transferred
1403      * @param _data bytes optional data to send along with the call
1404      * @return bool whether the call correctly returned the expected magic value
1405      */
1406     function _checkOnERC721Received(
1407         address from,
1408         address to,
1409         uint256 tokenId,
1410         bytes memory _data
1411     ) private returns (bool) {
1412         if (to.isContract()) {
1413             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1414                 return retval == IERC721Receiver(to).onERC721Received.selector;
1415             } catch (bytes memory reason) {
1416                 if (reason.length == 0) {
1417                     revert("z");
1418                 } else {
1419                     assembly {
1420                         revert(add(32, reason), mload(reason))
1421                     }
1422                 }
1423             }
1424         } else {
1425             return true;
1426         }
1427     }
1428 
1429     /**
1430      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1431      *
1432      * startTokenId - the first token id to be transferred
1433      * quantity - the amount to be transferred
1434      *
1435      * Calling conditions:
1436      *
1437      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1438      * transferred to `to`.
1439      * - When `from` is zero, `tokenId` will be minted for `to`.
1440      */
1441     function _beforeTokenTransfers(
1442         address from,
1443         address to,
1444         uint256 startTokenId,
1445         uint256 quantity
1446     ) internal virtual {}
1447 
1448     /**
1449      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1450      * minting.
1451      *
1452      * startTokenId - the first token id to be transferred
1453      * quantity - the amount to be transferred
1454      *
1455      * Calling conditions:
1456      *
1457      * - when `from` and `to` are both non-zero.
1458      * - `from` and `to` are never both zero.
1459      */
1460     function _afterTokenTransfers(
1461         address from,
1462         address to,
1463         uint256 startTokenId,
1464         uint256 quantity
1465     ) internal virtual {}
1466 }
1467 // File: @openzeppelin/contracts/access/Ownable.sol
1468 
1469 
1470 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1471 
1472 pragma solidity ^0.8.0;
1473 
1474 
1475 /**
1476  * @dev Contract module which provides a basic access control mechanism, where
1477  * there is an account (an owner) that can be granted exclusive access to
1478  * specific functions.
1479  *
1480  * By default, the owner account will be the one that deploys the contract. This
1481  * can later be changed with {transferOwnership}.
1482  *
1483  * This module is used through inheritance. It will make available the modifier
1484  * `onlyOwner`, which can be applied to your functions to restrict their use to
1485  * the owner.
1486  */
1487 abstract contract Ownable is Context {
1488     address private _owner;
1489 
1490     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1491 
1492     /**
1493      * @dev Initializes the contract setting the deployer as the initial owner.
1494      */
1495     constructor() {
1496         _transferOwnership(_msgSender());
1497     }
1498 
1499     /**
1500      * @dev Throws if called by any account other than the owner.
1501      */
1502     modifier onlyOwner() {
1503         _checkOwner();
1504         _;
1505     }
1506 
1507     /**
1508      * @dev Returns the address of the current owner.
1509      */
1510     function owner() public view virtual returns (address) {
1511         return _owner;
1512     }
1513 
1514     /**
1515      * @dev Throws if the sender is not the owner.
1516      */
1517     function _checkOwner() internal view virtual {
1518         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1519     }
1520 
1521     /**
1522      * @dev Leaves the contract without owner. It will not be possible to call
1523      * `onlyOwner` functions anymore. Can only be called by the current owner.
1524      *
1525      * NOTE: Renouncing ownership will leave the contract without an owner,
1526      * thereby removing any functionality that is only available to the owner.
1527      */
1528     function renounceOwnership() public virtual onlyOwner {
1529         _transferOwnership(address(0));
1530     }
1531 
1532     /**
1533      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1534      * Can only be called by the current owner.
1535      */
1536     function transferOwnership(address newOwner) public virtual onlyOwner {
1537         require(newOwner != address(0), "Ownable: new owner is the zero address");
1538         _transferOwnership(newOwner);
1539     }
1540 
1541     /**
1542      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1543      * Internal function without access restriction.
1544      */
1545     function _transferOwnership(address newOwner) internal virtual {
1546         address oldOwner = _owner;
1547         _owner = newOwner;
1548         emit OwnershipTransferred(oldOwner, newOwner);
1549     }
1550 }
1551 
1552 // File: Templates/HyperJellyz.sol
1553 
1554 
1555 /*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1556 @@@@@@@@@@@@@@@@@@@@@@@@@@@@.........................@@@@@@@@@@@@@@@@@@@@@@@@@@@
1557 @@@@@@@@@@@@@@@@@@@@@@.....................................@@@@@@@@@@@@@@@@@@@@@
1558 @@@@@@@@@@@@@@@@@@.............................................@@@@@@@@@@@@@@@@@
1559 @@@@@@@@@@@@@@@...................................................@@@@@@@@@@@@@@
1560 @@@@@@@@@@@@.........................@@@@@@..........................@@@@@@@@@@@
1561 @@@@@@@@@@.....................@@@@@@@@@@@@@@@@@@......................@@@@@@@@@
1562 @@@@@@@@....................@@@@@@@@@@@@@@@@@@@@@@@@.....................@@@@@@@
1563 @@@@@@....................@@@@@@@@@@@@@@@@@@@@@@@@@@@@.....................@@@@@
1564 @@@@@...................@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@....................@@@@
1565 @@@@....................@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@....................@@@
1566 @@@....................@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@.....................@@
1567 @@.....................@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@.....................@
1568 @@.....................@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@.....................@
1569 @......................@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@.....................@
1570 @......................@@@..#@@@@@@@@@@@@@@@@@@@@@@@,..@@@.....................@
1571 @......................@@@.....@@@@@@@@@@@@@@@@@@@.....@@@.....................@
1572 @......................@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@.....................@
1573 @......................@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@.....................@
1574 @@..................@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@..............@
1575 @@............@@@@@@@@..(@@@@@@@@@@@@@@@@@@@@@@.@@@@@@@@@@@....................@
1576 @@@...................@@@@@@@@@@@@@@@@@@@@@.@@@..@@@@@@@@@@@@.................@@
1577 @@@@................@@....@@@@@@...@@@@@.@@.@@...@@@@@@@@..@@@...............@@@
1578 @@@@@...................@@@...@@..@@@@@@.@@.@@..@@.@@...@...@@@.............@@@@
1579 @@@@@@.................@@@...@@...@@..@@....@@..@@..@@..@@...@@............@@@@@
1580 @@@@@@@@...............@@@.......@@@..@@.......@@@..........@@@..........@@@@@@@
1581 @@@@@@@@@@.............@@@........%...@@........@@(....................@@@@@@@@@
1582 @@@@@@@@@@@@.....................................@@..................@@@@@@@@@@@
1583 @@@@@@@@@@@@@@@...................................................@@@@@@@@@@@@@@
1584 @@@@@@@@@@@@@@@@@@.............................................@@@@@@@@@@@@@@@@@
1585 @@@@@@@@@@@@@@@@@@@@@@.....................................@@@@@@@@@@@@@@@@@@@@@
1586 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*/
1587 pragma solidity ^0.8.10;
1588 
1589 
1590 
1591 
1592 
1593 
1594 /**
1595  * @title MasterchefMasatoshi
1596  * NFT + DAO = NEW META
1597  * Vitalik, remove contract size limit pls
1598  */
1599 contract MasterchefMasatoshi is ERC721, Ownable {
1600   using ECDSA for bytes32;
1601   string public PROVENANCE;
1602   bool provenanceSet;
1603 
1604   uint256 public mintPrice;
1605   uint256 public maxPossibleSupply;
1606   uint256 public allowListMintPrice;
1607   uint256 public maxAllowedMints;
1608 
1609   address public immutable currency;
1610   address immutable wrappedNativeCoinAddress;
1611 
1612   address private signerAddress;
1613   bool public paused;
1614 
1615   address immutable ENSReverseRegistrar = 0x084b1c3C81545d370f3634392De611CaaBFf8148;
1616 
1617   enum MintStatus {
1618     PreMint,
1619     AllowList,
1620     Public,
1621     Finished
1622   }
1623 
1624   MintStatus public mintStatus = MintStatus.PreMint;
1625 
1626   mapping (address => uint256) totalMintsPerAddress;
1627 
1628   constructor(
1629       string memory _name,
1630       string memory _symbol,
1631       uint256 _maxPossibleSupply,
1632       uint256 _mintPrice,
1633       uint256 _allowListMintPrice,
1634       uint256 _maxAllowedMints,
1635       address _signerAddress,
1636       address _currency,
1637       address _wrappedNativeCoinAddress
1638   ) ERC721(_name, _symbol, _maxAllowedMints) {
1639     maxPossibleSupply = _maxPossibleSupply;
1640     mintPrice = _mintPrice;
1641     allowListMintPrice = _allowListMintPrice;
1642     maxAllowedMints = _maxAllowedMints;
1643     signerAddress = _signerAddress;
1644     currency = _currency;
1645     wrappedNativeCoinAddress = _wrappedNativeCoinAddress;
1646   }
1647 
1648   function flipPaused() external onlyOwner {
1649     paused = !paused;
1650   }
1651 
1652   function preMint(uint amount) public onlyOwner {
1653     require(mintStatus == MintStatus.PreMint, "s");
1654     require(totalSupply() + amount <= maxPossibleSupply, "m");  
1655     _safeMint(msg.sender, amount);
1656   }
1657 
1658   function setProvenanceHash(string memory provenanceHash) public onlyOwner {
1659     require(!provenanceSet);
1660     PROVENANCE = provenanceHash;
1661     provenanceSet = true;
1662   }
1663 
1664   function setBaseURI(string memory baseURI) public onlyOwner {
1665     _setBaseURI(baseURI);
1666   }
1667   
1668   function changeMintStatus(MintStatus _status) external onlyOwner {
1669     require(_status != MintStatus.PreMint);
1670     mintStatus = _status;
1671   }
1672 
1673   function mintAllowList(
1674     bytes32 messageHash,
1675     bytes calldata signature,
1676     uint amount
1677   ) public payable {
1678     require(mintStatus == MintStatus.AllowList && !paused, "s");
1679     require(totalSupply() + amount <= maxPossibleSupply, "m");
1680     require(hashMessage(msg.sender, address(this)) == messageHash, "i");
1681     require(verifyAddressSigner(messageHash, signature), "f");
1682     require(totalMintsPerAddress[msg.sender] + amount <= maxAllowedMints, "l");
1683 
1684     if (currency == wrappedNativeCoinAddress) {
1685       require(allowListMintPrice * amount <= msg.value, "a");
1686     } else {
1687       IERC20 _currency = IERC20(currency);
1688       _currency.transferFrom(msg.sender, address(this), amount * allowListMintPrice);
1689     }
1690 
1691     totalMintsPerAddress[msg.sender] = totalMintsPerAddress[msg.sender] + amount;
1692     _safeMint(msg.sender, amount);
1693   }
1694 
1695   function mintPublic(uint amount) public payable {
1696     require(mintStatus == MintStatus.Public && !paused, "s");
1697     require(totalSupply() + amount <= maxPossibleSupply, "m");
1698     require(totalMintsPerAddress[msg.sender] + amount <= maxAllowedMints, "l");
1699 
1700     if (currency == wrappedNativeCoinAddress) {
1701       require(mintPrice * amount <= msg.value, "a");
1702     } else {
1703       IERC20 _currency = IERC20(currency);
1704       _currency.transferFrom(msg.sender, address(this), amount * mintPrice);
1705     }
1706 
1707     totalMintsPerAddress[msg.sender] = totalMintsPerAddress[msg.sender] + amount;
1708     _safeMint(msg.sender, amount);
1709 
1710     if (totalSupply() == maxPossibleSupply) {
1711       mintStatus = MintStatus.Finished;
1712     }
1713   }
1714 
1715   function addReverseENSRecord(string memory name) external onlyOwner{
1716     IReverseRegistrar(ENSReverseRegistrar).setName(name);
1717   }
1718 
1719   receive() external payable {
1720     mintPublic(msg.value / mintPrice);
1721   }
1722 
1723   function verifyAddressSigner(bytes32 messageHash, bytes memory signature) private view returns (bool) {
1724     return signerAddress == messageHash.toEthSignedMessageHash().recover(signature);
1725   }
1726 
1727   function hashMessage(address sender, address thisContract) public pure returns (bytes32) {
1728     return keccak256(abi.encodePacked(sender, thisContract));
1729   }
1730 
1731   function withdraw() external onlyOwner() {
1732     uint balance = address(this).balance;
1733     payable(msg.sender).transfer(balance);
1734   }
1735 
1736   function withdrawTokens(address tokenAddress) external onlyOwner() {
1737     IERC20(tokenAddress).transfer(msg.sender, IERC20(tokenAddress).balanceOf(address(this)));
1738   }
1739 }
1740 
1741 // The High Table