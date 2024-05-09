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
520 // File: Yoblins Contracts/IReverseRegistrar.sol
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
555 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
556 
557 pragma solidity ^0.8.0;
558 
559 /**
560  * @dev String operations.
561  */
562 library Strings {
563     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
564 
565     /**
566      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
567      */
568     function toString(uint256 value) internal pure returns (string memory) {
569         // Inspired by OraclizeAPI's implementation - MIT licence
570         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
571 
572         if (value == 0) {
573             return "0";
574         }
575         uint256 temp = value;
576         uint256 digits;
577         while (temp != 0) {
578             digits++;
579             temp /= 10;
580         }
581         bytes memory buffer = new bytes(digits);
582         while (value != 0) {
583             digits -= 1;
584             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
585             value /= 10;
586         }
587         return string(buffer);
588     }
589 
590     /**
591      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
592      */
593     function toHexString(uint256 value) internal pure returns (string memory) {
594         if (value == 0) {
595             return "0x00";
596         }
597         uint256 temp = value;
598         uint256 length = 0;
599         while (temp != 0) {
600             length++;
601             temp >>= 8;
602         }
603         return toHexString(value, length);
604     }
605 
606     /**
607      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
608      */
609     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
610         bytes memory buffer = new bytes(2 * length + 2);
611         buffer[0] = "0";
612         buffer[1] = "x";
613         for (uint256 i = 2 * length + 1; i > 1; --i) {
614             buffer[i] = _HEX_SYMBOLS[value & 0xf];
615             value >>= 4;
616         }
617         require(value == 0, "Strings: hex length insufficient");
618         return string(buffer);
619     }
620 }
621 
622 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
623 
624 
625 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/ECDSA.sol)
626 
627 pragma solidity ^0.8.0;
628 
629 
630 /**
631  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
632  *
633  * These functions can be used to verify that a message was signed by the holder
634  * of the private keys of a given address.
635  */
636 library ECDSA {
637     enum RecoverError {
638         NoError,
639         InvalidSignature,
640         InvalidSignatureLength,
641         InvalidSignatureS,
642         InvalidSignatureV
643     }
644 
645     function _throwError(RecoverError error) private pure {
646         if (error == RecoverError.NoError) {
647             return; // no error: do nothing
648         } else if (error == RecoverError.InvalidSignature) {
649             revert("ECDSA: invalid signature");
650         } else if (error == RecoverError.InvalidSignatureLength) {
651             revert("ECDSA: invalid signature length");
652         } else if (error == RecoverError.InvalidSignatureS) {
653             revert("ECDSA: invalid signature 's' value");
654         } else if (error == RecoverError.InvalidSignatureV) {
655             revert("ECDSA: invalid signature 'v' value");
656         }
657     }
658 
659     /**
660      * @dev Returns the address that signed a hashed message (`hash`) with
661      * `signature` or error string. This address can then be used for verification purposes.
662      *
663      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
664      * this function rejects them by requiring the `s` value to be in the lower
665      * half order, and the `v` value to be either 27 or 28.
666      *
667      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
668      * verification to be secure: it is possible to craft signatures that
669      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
670      * this is by receiving a hash of the original message (which may otherwise
671      * be too long), and then calling {toEthSignedMessageHash} on it.
672      *
673      * Documentation for signature generation:
674      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
675      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
676      *
677      * _Available since v4.3._
678      */
679     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
680         // Check the signature length
681         // - case 65: r,s,v signature (standard)
682         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
683         if (signature.length == 65) {
684             bytes32 r;
685             bytes32 s;
686             uint8 v;
687             // ecrecover takes the signature parameters, and the only way to get them
688             // currently is to use assembly.
689             assembly {
690                 r := mload(add(signature, 0x20))
691                 s := mload(add(signature, 0x40))
692                 v := byte(0, mload(add(signature, 0x60)))
693             }
694             return tryRecover(hash, v, r, s);
695         } else if (signature.length == 64) {
696             bytes32 r;
697             bytes32 vs;
698             // ecrecover takes the signature parameters, and the only way to get them
699             // currently is to use assembly.
700             assembly {
701                 r := mload(add(signature, 0x20))
702                 vs := mload(add(signature, 0x40))
703             }
704             return tryRecover(hash, r, vs);
705         } else {
706             return (address(0), RecoverError.InvalidSignatureLength);
707         }
708     }
709 
710     /**
711      * @dev Returns the address that signed a hashed message (`hash`) with
712      * `signature`. This address can then be used for verification purposes.
713      *
714      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
715      * this function rejects them by requiring the `s` value to be in the lower
716      * half order, and the `v` value to be either 27 or 28.
717      *
718      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
719      * verification to be secure: it is possible to craft signatures that
720      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
721      * this is by receiving a hash of the original message (which may otherwise
722      * be too long), and then calling {toEthSignedMessageHash} on it.
723      */
724     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
725         (address recovered, RecoverError error) = tryRecover(hash, signature);
726         _throwError(error);
727         return recovered;
728     }
729 
730     /**
731      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
732      *
733      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
734      *
735      * _Available since v4.3._
736      */
737     function tryRecover(
738         bytes32 hash,
739         bytes32 r,
740         bytes32 vs
741     ) internal pure returns (address, RecoverError) {
742         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
743         uint8 v = uint8((uint256(vs) >> 255) + 27);
744         return tryRecover(hash, v, r, s);
745     }
746 
747     /**
748      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
749      *
750      * _Available since v4.2._
751      */
752     function recover(
753         bytes32 hash,
754         bytes32 r,
755         bytes32 vs
756     ) internal pure returns (address) {
757         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
758         _throwError(error);
759         return recovered;
760     }
761 
762     /**
763      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
764      * `r` and `s` signature fields separately.
765      *
766      * _Available since v4.3._
767      */
768     function tryRecover(
769         bytes32 hash,
770         uint8 v,
771         bytes32 r,
772         bytes32 s
773     ) internal pure returns (address, RecoverError) {
774         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
775         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
776         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
777         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
778         //
779         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
780         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
781         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
782         // these malleable signatures as well.
783         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
784             return (address(0), RecoverError.InvalidSignatureS);
785         }
786         if (v != 27 && v != 28) {
787             return (address(0), RecoverError.InvalidSignatureV);
788         }
789 
790         // If the signature is valid (and not malleable), return the signer address
791         address signer = ecrecover(hash, v, r, s);
792         if (signer == address(0)) {
793             return (address(0), RecoverError.InvalidSignature);
794         }
795 
796         return (signer, RecoverError.NoError);
797     }
798 
799     /**
800      * @dev Overload of {ECDSA-recover} that receives the `v`,
801      * `r` and `s` signature fields separately.
802      */
803     function recover(
804         bytes32 hash,
805         uint8 v,
806         bytes32 r,
807         bytes32 s
808     ) internal pure returns (address) {
809         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
810         _throwError(error);
811         return recovered;
812     }
813 
814     /**
815      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
816      * produces hash corresponding to the one signed with the
817      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
818      * JSON-RPC method as part of EIP-191.
819      *
820      * See {recover}.
821      */
822     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
823         // 32 is the length in bytes of hash,
824         // enforced by the type signature above
825         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
826     }
827 
828     /**
829      * @dev Returns an Ethereum Signed Message, created from `s`. This
830      * produces hash corresponding to the one signed with the
831      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
832      * JSON-RPC method as part of EIP-191.
833      *
834      * See {recover}.
835      */
836     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
837         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
838     }
839 
840     /**
841      * @dev Returns an Ethereum Signed Typed Data, created from a
842      * `domainSeparator` and a `structHash`. This produces hash corresponding
843      * to the one signed with the
844      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
845      * JSON-RPC method as part of EIP-712.
846      *
847      * See {recover}.
848      */
849     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
850         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
851     }
852 }
853 
854 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
855 
856 
857 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
858 
859 pragma solidity ^0.8.0;
860 
861 /**
862  * @dev Interface of the ERC20 standard as defined in the EIP.
863  */
864 interface IERC20 {
865     /**
866      * @dev Emitted when `value` tokens are moved from one account (`from`) to
867      * another (`to`).
868      *
869      * Note that `value` may be zero.
870      */
871     event Transfer(address indexed from, address indexed to, uint256 value);
872 
873     /**
874      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
875      * a call to {approve}. `value` is the new allowance.
876      */
877     event Approval(address indexed owner, address indexed spender, uint256 value);
878 
879     /**
880      * @dev Returns the amount of tokens in existence.
881      */
882     function totalSupply() external view returns (uint256);
883 
884     /**
885      * @dev Returns the amount of tokens owned by `account`.
886      */
887     function balanceOf(address account) external view returns (uint256);
888 
889     /**
890      * @dev Moves `amount` tokens from the caller's account to `to`.
891      *
892      * Returns a boolean value indicating whether the operation succeeded.
893      *
894      * Emits a {Transfer} event.
895      */
896     function transfer(address to, uint256 amount) external returns (bool);
897 
898     /**
899      * @dev Returns the remaining number of tokens that `spender` will be
900      * allowed to spend on behalf of `owner` through {transferFrom}. This is
901      * zero by default.
902      *
903      * This value changes when {approve} or {transferFrom} are called.
904      */
905     function allowance(address owner, address spender) external view returns (uint256);
906 
907     /**
908      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
909      *
910      * Returns a boolean value indicating whether the operation succeeded.
911      *
912      * IMPORTANT: Beware that changing an allowance with this method brings the risk
913      * that someone may use both the old and the new allowance by unfortunate
914      * transaction ordering. One possible solution to mitigate this race
915      * condition is to first reduce the spender's allowance to 0 and set the
916      * desired value afterwards:
917      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
918      *
919      * Emits an {Approval} event.
920      */
921     function approve(address spender, uint256 amount) external returns (bool);
922 
923     /**
924      * @dev Moves `amount` tokens from `from` to `to` using the
925      * allowance mechanism. `amount` is then deducted from the caller's
926      * allowance.
927      *
928      * Returns a boolean value indicating whether the operation succeeded.
929      *
930      * Emits a {Transfer} event.
931      */
932     function transferFrom(
933         address from,
934         address to,
935         uint256 amount
936     ) external returns (bool);
937 }
938 
939 // File: @openzeppelin/contracts/utils/Context.sol
940 
941 
942 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
943 
944 pragma solidity ^0.8.0;
945 
946 /**
947  * @dev Provides information about the current execution context, including the
948  * sender of the transaction and its data. While these are generally available
949  * via msg.sender and msg.data, they should not be accessed in such a direct
950  * manner, since when dealing with meta-transactions the account sending and
951  * paying for execution may not be the actual sender (as far as an application
952  * is concerned).
953  *
954  * This contract is only required for intermediate, library-like contracts.
955  */
956 abstract contract Context {
957     function _msgSender() internal view virtual returns (address) {
958         return msg.sender;
959     }
960 
961     function _msgData() internal view virtual returns (bytes calldata) {
962         return msg.data;
963     }
964 }
965 
966 // File: Yoblins Contracts/ERC721.sol
967 
968 
969 // Creator: Chiru Labs
970 
971 pragma solidity ^0.8.10;
972 
973 
974 
975 
976 
977 
978 
979 
980 
981 /**
982  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
983  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
984  *
985  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
986  *
987  * Does not support burning tokens to address(0).
988  */
989 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
990     using Address for address;
991     using Strings for uint256;
992 
993     struct TokenOwnership {
994         address addr;
995         uint64 startTimestamp;
996     }
997 
998     struct AddressData {
999         uint128 balance;
1000         uint128 numberMinted;
1001     }
1002 
1003     uint256 private currentIndex = 0;
1004 
1005     uint256 internal immutable maxBatchSize;
1006 
1007     // Token name
1008     string private _name;
1009 
1010     // Token symbol
1011     string private _symbol;
1012 
1013     // Base URI
1014     string private _baseURI;
1015 
1016     // Mapping from token ID to ownership details
1017     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1018     mapping(uint256 => TokenOwnership) private _ownerships;
1019 
1020     // Mapping owner address to address data
1021     mapping(address => AddressData) private _addressData;
1022 
1023     // Mapping from token ID to approved address
1024     mapping(uint256 => address) private _tokenApprovals;
1025 
1026     // Mapping from owner to operator approvals
1027     mapping(address => mapping(address => bool)) private _operatorApprovals;
1028 
1029     /**
1030      * @dev
1031      * `maxBatchSize` refers to how much a minter can mint at a time.
1032      */
1033     constructor(
1034         string memory name_,
1035         string memory symbol_,
1036         uint256 maxBatchSize_
1037     ) {
1038         require(maxBatchSize_ > 0, "b");
1039         _name = name_;
1040         _symbol = symbol_;
1041         maxBatchSize = maxBatchSize_;
1042     }
1043 
1044     /**
1045      * @dev See {IERC721Enumerable-totalSupply}.
1046      */
1047     function totalSupply() public view override returns (uint256) {
1048         return currentIndex;
1049     }
1050 
1051     /**
1052      * @dev See {IERC721Enumerable-tokenByIndex}.
1053      */
1054     function tokenByIndex(uint256 index) public view override returns (uint256) {
1055         require(index < totalSupply(), "g");
1056         return index;
1057     }
1058 
1059     /**
1060      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1061      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1062      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1063      */
1064     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1065         require(index < balanceOf(owner), "b");
1066         uint256 numMintedSoFar = totalSupply();
1067         uint256 tokenIdsIdx = 0;
1068         address currOwnershipAddr = address(0);
1069         for (uint256 i = 0; i < numMintedSoFar; i++) {
1070             TokenOwnership memory ownership = _ownerships[i];
1071             if (ownership.addr != address(0)) {
1072                 currOwnershipAddr = ownership.addr;
1073             }
1074             if (currOwnershipAddr == owner) {
1075                 if (tokenIdsIdx == index) {
1076                     return i;
1077                 }
1078                 tokenIdsIdx++;
1079             }
1080         }
1081         revert("u");
1082     }
1083 
1084     /**
1085      * @dev See {IERC165-supportsInterface}.
1086      */
1087     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1088         return
1089             interfaceId == type(IERC721).interfaceId ||
1090             interfaceId == type(IERC721Metadata).interfaceId ||
1091             interfaceId == type(IERC721Enumerable).interfaceId ||
1092             super.supportsInterface(interfaceId);
1093     }
1094 
1095     /**
1096      * @dev See {IERC721-balanceOf}.
1097      */
1098     function balanceOf(address owner) public view override returns (uint256) {
1099         require(owner != address(0), "0");
1100         return uint256(_addressData[owner].balance);
1101     }
1102 
1103     function _numberMinted(address owner) internal view returns (uint256) {
1104         require(owner != address(0), "0");
1105         return uint256(_addressData[owner].numberMinted);
1106     }
1107 
1108     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1109         require(_exists(tokenId), "t");
1110 
1111         uint256 lowestTokenToCheck;
1112         if (tokenId >= maxBatchSize) {
1113             lowestTokenToCheck = tokenId - maxBatchSize + 1;
1114         }
1115 
1116         for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
1117             TokenOwnership memory ownership = _ownerships[curr];
1118             if (ownership.addr != address(0)) {
1119                 return ownership;
1120             }
1121         }
1122 
1123         revert("o");
1124     }
1125 
1126     /**
1127      * @dev See {IERC721-ownerOf}.
1128      */
1129     function ownerOf(uint256 tokenId) public view override returns (address) {
1130         return ownershipOf(tokenId).addr;
1131     }
1132 
1133     /**
1134      * @dev See {IERC721Metadata-name}.
1135      */
1136     function name() public view virtual override returns (string memory) {
1137         return _name;
1138     }
1139 
1140     /**
1141      * @dev See {IERC721Metadata-symbol}.
1142      */
1143     function symbol() public view virtual override returns (string memory) {
1144         return _symbol;
1145     }
1146 
1147     /**
1148      * @dev See {IERC721Metadata-tokenURI}.
1149      */
1150     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1151         require(_exists(tokenId), "z");
1152 
1153         return bytes(_baseURI).length > 0 ? string(abi.encodePacked(_baseURI, tokenId.toString())) : "";
1154     }
1155 
1156     /**
1157      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1158      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1159      * by default, can be overriden in child contracts.
1160      */
1161     function baseURI() public view virtual returns (string memory) {
1162         return _baseURI;
1163     }
1164 
1165     /**
1166      * @dev Internal function to set the base URI for all token IDs. It is
1167      * automatically added as a prefix to the value returned in {tokenURI},
1168      * or to the token ID if {tokenURI} is empty.
1169      */
1170     function _setBaseURI(string memory baseURI_) internal virtual {
1171         _baseURI = baseURI_;
1172     }
1173 
1174 
1175 
1176     /**
1177      * @dev See {IERC721-approve}.
1178      */
1179     function approve(address to, uint256 tokenId) public override {
1180         address owner = ERC721.ownerOf(tokenId);
1181         require(to != owner, "o");
1182 
1183         require(
1184             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1185             "a"
1186         );
1187 
1188         _approve(to, tokenId, owner);
1189     }
1190 
1191     /**
1192      * @dev See {IERC721-getApproved}.
1193      */
1194     function getApproved(uint256 tokenId) public view override returns (address) {
1195         require(_exists(tokenId), "a");
1196 
1197         return _tokenApprovals[tokenId];
1198     }
1199 
1200     /**
1201      * @dev See {IERC721-setApprovalForAll}.
1202      */
1203     function setApprovalForAll(address operator, bool approved) public override {
1204         require(operator != _msgSender(), "a");
1205 
1206         _operatorApprovals[_msgSender()][operator] = approved;
1207         emit ApprovalForAll(_msgSender(), operator, approved);
1208     }
1209 
1210     /**
1211      * @dev See {IERC721-isApprovedForAll}.
1212      */
1213     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1214         return _operatorApprovals[owner][operator];
1215     }
1216 
1217     /**
1218      * @dev See {IERC721-transferFrom}.
1219      */
1220     function transferFrom(
1221         address from,
1222         address to,
1223         uint256 tokenId
1224     ) public override {
1225         _transfer(from, to, tokenId);
1226     }
1227 
1228     /**
1229      * @dev See {IERC721-safeTransferFrom}.
1230      */
1231     function safeTransferFrom(
1232         address from,
1233         address to,
1234         uint256 tokenId
1235     ) public override {
1236         safeTransferFrom(from, to, tokenId, "");
1237     }
1238 
1239     /**
1240      * @dev See {IERC721-safeTransferFrom}.
1241      */
1242     function safeTransferFrom(
1243         address from,
1244         address to,
1245         uint256 tokenId,
1246         bytes memory _data
1247     ) public override {
1248         _transfer(from, to, tokenId);
1249         require(
1250             _checkOnERC721Received(from, to, tokenId, _data),
1251             "z"
1252         );
1253     }
1254 
1255     /**
1256      * @dev Returns whether `tokenId` exists.
1257      *
1258      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1259      *
1260      * Tokens start existing when they are minted (`_mint`),
1261      */
1262     function _exists(uint256 tokenId) internal view returns (bool) {
1263         return tokenId < currentIndex;
1264     }
1265 
1266     function _safeMint(address to, uint256 quantity) internal {
1267         _safeMint(to, quantity, "");
1268     }
1269 
1270     /**
1271      * @dev Mints `quantity` tokens and transfers them to `to`.
1272      *
1273      * Requirements:
1274      *
1275      * - `to` cannot be the zero address.
1276      * - `quantity` cannot be larger than the max batch size.
1277      *
1278      * Emits a {Transfer} event.
1279      */
1280     function _safeMint(
1281         address to,
1282         uint256 quantity,
1283         bytes memory _data
1284     ) internal {
1285         uint256 startTokenId = currentIndex;
1286         require(to != address(0), "0");
1287         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1288         require(!_exists(startTokenId), "a");
1289         require(quantity <= maxBatchSize, "m");
1290 
1291         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1292 
1293         AddressData memory addressData = _addressData[to];
1294         _addressData[to] = AddressData(
1295             addressData.balance + uint128(quantity),
1296             addressData.numberMinted + uint128(quantity)
1297         );
1298         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1299 
1300         uint256 updatedIndex = startTokenId;
1301 
1302         for (uint256 i = 0; i < quantity; i++) {
1303             emit Transfer(address(0), to, updatedIndex);
1304             require(
1305                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
1306                 "z"
1307             );
1308             updatedIndex++;
1309         }
1310 
1311         currentIndex = updatedIndex;
1312         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1313     }
1314 
1315     /**
1316      * @dev Transfers `tokenId` from `from` to `to`.
1317      *
1318      * Requirements:
1319      *
1320      * - `to` cannot be the zero address.
1321      * - `tokenId` token must be owned by `from`.
1322      *
1323      * Emits a {Transfer} event.
1324      */
1325     function _transfer(
1326         address from,
1327         address to,
1328         uint256 tokenId
1329     ) private {
1330         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1331 
1332         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1333             getApproved(tokenId) == _msgSender() ||
1334             isApprovedForAll(prevOwnership.addr, _msgSender()));
1335 
1336         require(isApprovedOrOwner, "a");
1337 
1338         require(prevOwnership.addr == from, "o");
1339         require(to != address(0), "0");
1340 
1341         _beforeTokenTransfers(from, to, tokenId, 1);
1342 
1343         // Clear approvals from the previous owner
1344         _approve(address(0), tokenId, prevOwnership.addr);
1345 
1346         _addressData[from].balance -= 1;
1347         _addressData[to].balance += 1;
1348         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1349 
1350         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1351         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1352         uint256 nextTokenId = tokenId + 1;
1353         if (_ownerships[nextTokenId].addr == address(0)) {
1354             if (_exists(nextTokenId)) {
1355                 _ownerships[nextTokenId] = TokenOwnership(prevOwnership.addr, prevOwnership.startTimestamp);
1356             }
1357         }
1358 
1359         emit Transfer(from, to, tokenId);
1360         _afterTokenTransfers(from, to, tokenId, 1);
1361     }
1362 
1363     /**
1364      * @dev Approve `to` to operate on `tokenId`
1365      *
1366      * Emits a {Approval} event.
1367      */
1368     function _approve(
1369         address to,
1370         uint256 tokenId,
1371         address owner
1372     ) private {
1373         _tokenApprovals[tokenId] = to;
1374         emit Approval(owner, to, tokenId);
1375     }
1376 
1377     uint256 public nextOwnerToExplicitlySet = 0;
1378 
1379     /**
1380      * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1381      */
1382     function _setOwnersExplicit(uint256 quantity) internal {
1383         uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1384         require(quantity > 0, "q");
1385         uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1386         if (endIndex > currentIndex - 1) {
1387             endIndex = currentIndex - 1;
1388         }
1389         // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1390         require(_exists(endIndex), "n");
1391         for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1392             if (_ownerships[i].addr == address(0)) {
1393                 TokenOwnership memory ownership = ownershipOf(i);
1394                 _ownerships[i] = TokenOwnership(ownership.addr, ownership.startTimestamp);
1395             }
1396         }
1397         nextOwnerToExplicitlySet = endIndex + 1;
1398     }
1399 
1400     /**
1401      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1402      * The call is not executed if the target address is not a contract.
1403      *
1404      * @param from address representing the previous owner of the given token ID
1405      * @param to target address that will receive the tokens
1406      * @param tokenId uint256 ID of the token to be transferred
1407      * @param _data bytes optional data to send along with the call
1408      * @return bool whether the call correctly returned the expected magic value
1409      */
1410     function _checkOnERC721Received(
1411         address from,
1412         address to,
1413         uint256 tokenId,
1414         bytes memory _data
1415     ) private returns (bool) {
1416         if (to.isContract()) {
1417             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1418                 return retval == IERC721Receiver(to).onERC721Received.selector;
1419             } catch (bytes memory reason) {
1420                 if (reason.length == 0) {
1421                     revert("z");
1422                 } else {
1423                     assembly {
1424                         revert(add(32, reason), mload(reason))
1425                     }
1426                 }
1427             }
1428         } else {
1429             return true;
1430         }
1431     }
1432 
1433     /**
1434      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1435      *
1436      * startTokenId - the first token id to be transferred
1437      * quantity - the amount to be transferred
1438      *
1439      * Calling conditions:
1440      *
1441      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1442      * transferred to `to`.
1443      * - When `from` is zero, `tokenId` will be minted for `to`.
1444      */
1445     function _beforeTokenTransfers(
1446         address from,
1447         address to,
1448         uint256 startTokenId,
1449         uint256 quantity
1450     ) internal virtual {}
1451 
1452     /**
1453      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1454      * minting.
1455      *
1456      * startTokenId - the first token id to be transferred
1457      * quantity - the amount to be transferred
1458      *
1459      * Calling conditions:
1460      *
1461      * - when `from` and `to` are both non-zero.
1462      * - `from` and `to` are never both zero.
1463      */
1464     function _afterTokenTransfers(
1465         address from,
1466         address to,
1467         uint256 startTokenId,
1468         uint256 quantity
1469     ) internal virtual {}
1470 }
1471 // File: @openzeppelin/contracts/access/Ownable.sol
1472 
1473 
1474 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1475 
1476 pragma solidity ^0.8.0;
1477 
1478 
1479 /**
1480  * @dev Contract module which provides a basic access control mechanism, where
1481  * there is an account (an owner) that can be granted exclusive access to
1482  * specific functions.
1483  *
1484  * By default, the owner account will be the one that deploys the contract. This
1485  * can later be changed with {transferOwnership}.
1486  *
1487  * This module is used through inheritance. It will make available the modifier
1488  * `onlyOwner`, which can be applied to your functions to restrict their use to
1489  * the owner.
1490  */
1491 abstract contract Ownable is Context {
1492     address private _owner;
1493 
1494     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1495 
1496     /**
1497      * @dev Initializes the contract setting the deployer as the initial owner.
1498      */
1499     constructor() {
1500         _transferOwnership(_msgSender());
1501     }
1502 
1503     /**
1504      * @dev Returns the address of the current owner.
1505      */
1506     function owner() public view virtual returns (address) {
1507         return _owner;
1508     }
1509 
1510     /**
1511      * @dev Throws if called by any account other than the owner.
1512      */
1513     modifier onlyOwner() {
1514         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1515         _;
1516     }
1517 
1518     /**
1519      * @dev Leaves the contract without owner. It will not be possible to call
1520      * `onlyOwner` functions anymore. Can only be called by the current owner.
1521      *
1522      * NOTE: Renouncing ownership will leave the contract without an owner,
1523      * thereby removing any functionality that is only available to the owner.
1524      */
1525     function renounceOwnership() public virtual onlyOwner {
1526         _transferOwnership(address(0));
1527     }
1528 
1529     /**
1530      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1531      * Can only be called by the current owner.
1532      */
1533     function transferOwnership(address newOwner) public virtual onlyOwner {
1534         require(newOwner != address(0), "Ownable: new owner is the zero address");
1535         _transferOwnership(newOwner);
1536     }
1537 
1538     /**
1539      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1540      * Internal function without access restriction.
1541      */
1542     function _transferOwnership(address newOwner) internal virtual {
1543         address oldOwner = _owner;
1544         _owner = newOwner;
1545         emit OwnershipTransferred(oldOwner, newOwner);
1546     }
1547 }
1548 
1549 // File: Yoblins Contracts/MasterchefMasatoshiJuniorX.sol
1550 
1551 
1552 pragma solidity ^0.8.10;
1553 
1554 
1555 
1556 
1557 
1558 
1559 /**
1560  * @title MasterchefMasatoshi
1561  * NFT + DAO = NEW META
1562  * Vitalik, remove contract size limit pls
1563  */
1564 contract Yoblins is ERC721, Ownable {
1565   using ECDSA for bytes32;
1566   string public PROVENANCE;
1567   bool provenanceSet;
1568 
1569   uint256 public mintPrice;
1570   uint256 public maxPossibleSupply;
1571   uint256 public allowListMintPrice;
1572   uint256 public maxAllowedMints;
1573 
1574   address public immutable currency;
1575   address immutable wrappedNativeCoinAddress;
1576 
1577   address private signerAddress;
1578   bool public paused;
1579 
1580   address immutable ENSReverseRegistrar = 0x084b1c3C81545d370f3634392De611CaaBFf8148;
1581 
1582   enum MintStatus {
1583     PreMint,
1584     AllowList,
1585     Public,
1586     Finished
1587   }
1588 
1589   MintStatus public mintStatus = MintStatus.PreMint;
1590 
1591   mapping (address => uint256) totalMintsPerAddress;
1592 
1593   constructor(
1594       string memory _name,
1595       string memory _symbol,
1596       uint256 _maxPossibleSupply,
1597       uint256 _mintPrice,
1598       uint256 _allowListMintPrice,
1599       uint256 _maxAllowedMints,
1600       address _signerAddress,
1601       address _currency,
1602       address _wrappedNativeCoinAddress
1603   ) ERC721(_name, _symbol, _maxAllowedMints) {
1604     maxPossibleSupply = _maxPossibleSupply;
1605     mintPrice = _mintPrice;
1606     allowListMintPrice = _allowListMintPrice;
1607     maxAllowedMints = _maxAllowedMints;
1608     signerAddress = _signerAddress;
1609     currency = _currency;
1610     wrappedNativeCoinAddress = _wrappedNativeCoinAddress;
1611   }
1612 
1613   function flipPaused() external onlyOwner {
1614     paused = !paused;
1615   }
1616 
1617   function preMint(uint amount) public onlyOwner {
1618     require(mintStatus == MintStatus.PreMint, "s");
1619     require(totalSupply() + amount <= maxPossibleSupply, "m");  
1620     _safeMint(msg.sender, amount);
1621   }
1622 
1623   function setProvenanceHash(string memory provenanceHash) public onlyOwner {
1624     require(!provenanceSet);
1625     PROVENANCE = provenanceHash;
1626     provenanceSet = true;
1627   }
1628 
1629   function setBaseURI(string memory baseURI) public onlyOwner {
1630     _setBaseURI(baseURI);
1631   }
1632   
1633   function changeMintStatus(MintStatus _status) external onlyOwner {
1634     require(_status != MintStatus.PreMint);
1635     mintStatus = _status;
1636   }
1637 
1638   function mintAllowList(
1639     bytes32 messageHash,
1640     bytes calldata signature,
1641     uint amount
1642   ) public payable {
1643     require(mintStatus == MintStatus.AllowList && !paused, "s");
1644     require(totalSupply() + amount <= maxPossibleSupply, "m");
1645     require(hashMessage(msg.sender, address(this)) == messageHash, "i");
1646     require(verifyAddressSigner(messageHash, signature), "f");
1647     require(totalMintsPerAddress[msg.sender] + amount <= maxAllowedMints, "l");
1648 
1649     if (currency == wrappedNativeCoinAddress) {
1650       require(allowListMintPrice * amount <= msg.value, "a");
1651     } else {
1652       IERC20 _currency = IERC20(currency);
1653       _currency.transferFrom(msg.sender, address(this), amount * allowListMintPrice);
1654     }
1655 
1656     totalMintsPerAddress[msg.sender] = totalMintsPerAddress[msg.sender] + amount;
1657     _safeMint(msg.sender, amount);
1658   }
1659 
1660   function mintPublic(uint amount) public payable {
1661     require(mintStatus == MintStatus.Public && !paused, "s");
1662     require(totalSupply() + amount <= maxPossibleSupply, "m");
1663     require(totalMintsPerAddress[msg.sender] + amount <= maxAllowedMints, "l");
1664 
1665     if (currency == wrappedNativeCoinAddress) {
1666       require(mintPrice * amount <= msg.value, "a");
1667     } else {
1668       IERC20 _currency = IERC20(currency);
1669       _currency.transferFrom(msg.sender, address(this), amount * mintPrice);
1670     }
1671 
1672     totalMintsPerAddress[msg.sender] = totalMintsPerAddress[msg.sender] + amount;
1673     _safeMint(msg.sender, amount);
1674 
1675     if (totalSupply() == maxPossibleSupply) {
1676       mintStatus = MintStatus.Finished;
1677     }
1678   }
1679 
1680   function addReverseENSRecord(string memory name) external onlyOwner{
1681     IReverseRegistrar(ENSReverseRegistrar).setName(name);
1682   }
1683 
1684   receive() external payable {
1685     mintPublic(msg.value / mintPrice);
1686   }
1687 
1688   function verifyAddressSigner(bytes32 messageHash, bytes memory signature) private view returns (bool) {
1689     return signerAddress == messageHash.toEthSignedMessageHash().recover(signature);
1690   }
1691 
1692   function hashMessage(address sender, address thisContract) public pure returns (bytes32) {
1693     return keccak256(abi.encodePacked(sender, thisContract));
1694   }
1695 
1696   function withdraw() external onlyOwner() {
1697     uint balance = address(this).balance;
1698     payable(msg.sender).transfer(balance);
1699   }
1700 
1701   function withdrawTokens(address tokenAddress) external onlyOwner() {
1702     IERC20(tokenAddress).transfer(msg.sender, IERC20(tokenAddress).balanceOf(address(this)));
1703   }
1704 }