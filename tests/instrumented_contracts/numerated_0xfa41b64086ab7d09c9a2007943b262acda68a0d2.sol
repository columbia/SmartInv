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
318 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
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
385      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
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
520 // File: @openzeppelin/contracts/utils/Strings.sol
521 
522 
523 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
524 
525 pragma solidity ^0.8.0;
526 
527 /**
528  * @dev String operations.
529  */
530 library Strings {
531     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
532 
533     /**
534      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
535      */
536     function toString(uint256 value) internal pure returns (string memory) {
537         // Inspired by OraclizeAPI's implementation - MIT licence
538         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
539 
540         if (value == 0) {
541             return "0";
542         }
543         uint256 temp = value;
544         uint256 digits;
545         while (temp != 0) {
546             digits++;
547             temp /= 10;
548         }
549         bytes memory buffer = new bytes(digits);
550         while (value != 0) {
551             digits -= 1;
552             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
553             value /= 10;
554         }
555         return string(buffer);
556     }
557 
558     /**
559      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
560      */
561     function toHexString(uint256 value) internal pure returns (string memory) {
562         if (value == 0) {
563             return "0x00";
564         }
565         uint256 temp = value;
566         uint256 length = 0;
567         while (temp != 0) {
568             length++;
569             temp >>= 8;
570         }
571         return toHexString(value, length);
572     }
573 
574     /**
575      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
576      */
577     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
578         bytes memory buffer = new bytes(2 * length + 2);
579         buffer[0] = "0";
580         buffer[1] = "x";
581         for (uint256 i = 2 * length + 1; i > 1; --i) {
582             buffer[i] = _HEX_SYMBOLS[value & 0xf];
583             value >>= 4;
584         }
585         require(value == 0, "Strings: hex length insufficient");
586         return string(buffer);
587     }
588 }
589 
590 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
591 
592 
593 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/ECDSA.sol)
594 
595 pragma solidity ^0.8.0;
596 
597 
598 /**
599  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
600  *
601  * These functions can be used to verify that a message was signed by the holder
602  * of the private keys of a given address.
603  */
604 library ECDSA {
605     enum RecoverError {
606         NoError,
607         InvalidSignature,
608         InvalidSignatureLength,
609         InvalidSignatureS,
610         InvalidSignatureV
611     }
612 
613     function _throwError(RecoverError error) private pure {
614         if (error == RecoverError.NoError) {
615             return; // no error: do nothing
616         } else if (error == RecoverError.InvalidSignature) {
617             revert("ECDSA: invalid signature");
618         } else if (error == RecoverError.InvalidSignatureLength) {
619             revert("ECDSA: invalid signature length");
620         } else if (error == RecoverError.InvalidSignatureS) {
621             revert("ECDSA: invalid signature 's' value");
622         } else if (error == RecoverError.InvalidSignatureV) {
623             revert("ECDSA: invalid signature 'v' value");
624         }
625     }
626 
627     /**
628      * @dev Returns the address that signed a hashed message (`hash`) with
629      * `signature` or error string. This address can then be used for verification purposes.
630      *
631      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
632      * this function rejects them by requiring the `s` value to be in the lower
633      * half order, and the `v` value to be either 27 or 28.
634      *
635      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
636      * verification to be secure: it is possible to craft signatures that
637      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
638      * this is by receiving a hash of the original message (which may otherwise
639      * be too long), and then calling {toEthSignedMessageHash} on it.
640      *
641      * Documentation for signature generation:
642      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
643      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
644      *
645      * _Available since v4.3._
646      */
647     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
648         // Check the signature length
649         // - case 65: r,s,v signature (standard)
650         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
651         if (signature.length == 65) {
652             bytes32 r;
653             bytes32 s;
654             uint8 v;
655             // ecrecover takes the signature parameters, and the only way to get them
656             // currently is to use assembly.
657             assembly {
658                 r := mload(add(signature, 0x20))
659                 s := mload(add(signature, 0x40))
660                 v := byte(0, mload(add(signature, 0x60)))
661             }
662             return tryRecover(hash, v, r, s);
663         } else if (signature.length == 64) {
664             bytes32 r;
665             bytes32 vs;
666             // ecrecover takes the signature parameters, and the only way to get them
667             // currently is to use assembly.
668             assembly {
669                 r := mload(add(signature, 0x20))
670                 vs := mload(add(signature, 0x40))
671             }
672             return tryRecover(hash, r, vs);
673         } else {
674             return (address(0), RecoverError.InvalidSignatureLength);
675         }
676     }
677 
678     /**
679      * @dev Returns the address that signed a hashed message (`hash`) with
680      * `signature`. This address can then be used for verification purposes.
681      *
682      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
683      * this function rejects them by requiring the `s` value to be in the lower
684      * half order, and the `v` value to be either 27 or 28.
685      *
686      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
687      * verification to be secure: it is possible to craft signatures that
688      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
689      * this is by receiving a hash of the original message (which may otherwise
690      * be too long), and then calling {toEthSignedMessageHash} on it.
691      */
692     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
693         (address recovered, RecoverError error) = tryRecover(hash, signature);
694         _throwError(error);
695         return recovered;
696     }
697 
698     /**
699      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
700      *
701      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
702      *
703      * _Available since v4.3._
704      */
705     function tryRecover(
706         bytes32 hash,
707         bytes32 r,
708         bytes32 vs
709     ) internal pure returns (address, RecoverError) {
710         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
711         uint8 v = uint8((uint256(vs) >> 255) + 27);
712         return tryRecover(hash, v, r, s);
713     }
714 
715     /**
716      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
717      *
718      * _Available since v4.2._
719      */
720     function recover(
721         bytes32 hash,
722         bytes32 r,
723         bytes32 vs
724     ) internal pure returns (address) {
725         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
726         _throwError(error);
727         return recovered;
728     }
729 
730     /**
731      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
732      * `r` and `s` signature fields separately.
733      *
734      * _Available since v4.3._
735      */
736     function tryRecover(
737         bytes32 hash,
738         uint8 v,
739         bytes32 r,
740         bytes32 s
741     ) internal pure returns (address, RecoverError) {
742         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
743         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
744         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
745         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
746         //
747         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
748         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
749         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
750         // these malleable signatures as well.
751         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
752             return (address(0), RecoverError.InvalidSignatureS);
753         }
754         if (v != 27 && v != 28) {
755             return (address(0), RecoverError.InvalidSignatureV);
756         }
757 
758         // If the signature is valid (and not malleable), return the signer address
759         address signer = ecrecover(hash, v, r, s);
760         if (signer == address(0)) {
761             return (address(0), RecoverError.InvalidSignature);
762         }
763 
764         return (signer, RecoverError.NoError);
765     }
766 
767     /**
768      * @dev Overload of {ECDSA-recover} that receives the `v`,
769      * `r` and `s` signature fields separately.
770      */
771     function recover(
772         bytes32 hash,
773         uint8 v,
774         bytes32 r,
775         bytes32 s
776     ) internal pure returns (address) {
777         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
778         _throwError(error);
779         return recovered;
780     }
781 
782     /**
783      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
784      * produces hash corresponding to the one signed with the
785      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
786      * JSON-RPC method as part of EIP-191.
787      *
788      * See {recover}.
789      */
790     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
791         // 32 is the length in bytes of hash,
792         // enforced by the type signature above
793         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
794     }
795 
796     /**
797      * @dev Returns an Ethereum Signed Message, created from `s`. This
798      * produces hash corresponding to the one signed with the
799      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
800      * JSON-RPC method as part of EIP-191.
801      *
802      * See {recover}.
803      */
804     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
805         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
806     }
807 
808     /**
809      * @dev Returns an Ethereum Signed Typed Data, created from a
810      * `domainSeparator` and a `structHash`. This produces hash corresponding
811      * to the one signed with the
812      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
813      * JSON-RPC method as part of EIP-712.
814      *
815      * See {recover}.
816      */
817     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
818         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
819     }
820 }
821 
822 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
823 
824 
825 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
826 
827 pragma solidity ^0.8.0;
828 
829 /**
830  * @dev Contract module that helps prevent reentrant calls to a function.
831  *
832  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
833  * available, which can be applied to functions to make sure there are no nested
834  * (reentrant) calls to them.
835  *
836  * Note that because there is a single `nonReentrant` guard, functions marked as
837  * `nonReentrant` may not call one another. This can be worked around by making
838  * those functions `private`, and then adding `external` `nonReentrant` entry
839  * points to them.
840  *
841  * TIP: If you would like to learn more about reentrancy and alternative ways
842  * to protect against it, check out our blog post
843  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
844  */
845 abstract contract ReentrancyGuard {
846     // Booleans are more expensive than uint256 or any type that takes up a full
847     // word because each write operation emits an extra SLOAD to first read the
848     // slot's contents, replace the bits taken up by the boolean, and then write
849     // back. This is the compiler's defense against contract upgrades and
850     // pointer aliasing, and it cannot be disabled.
851 
852     // The values being non-zero value makes deployment a bit more expensive,
853     // but in exchange the refund on every call to nonReentrant will be lower in
854     // amount. Since refunds are capped to a percentage of the total
855     // transaction's gas, it is best to keep them low in cases like this one, to
856     // increase the likelihood of the full refund coming into effect.
857     uint256 private constant _NOT_ENTERED = 1;
858     uint256 private constant _ENTERED = 2;
859 
860     uint256 private _status;
861 
862     constructor() {
863         _status = _NOT_ENTERED;
864     }
865 
866     /**
867      * @dev Prevents a contract from calling itself, directly or indirectly.
868      * Calling a `nonReentrant` function from another `nonReentrant`
869      * function is not supported. It is possible to prevent this from happening
870      * by making the `nonReentrant` function external, and making it call a
871      * `private` function that does the actual work.
872      */
873     modifier nonReentrant() {
874         // On the first call to nonReentrant, _notEntered will be true
875         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
876 
877         // Any calls to nonReentrant after this point will fail
878         _status = _ENTERED;
879 
880         _;
881 
882         // By storing the original value once again, a refund is triggered (see
883         // https://eips.ethereum.org/EIPS/eip-2200)
884         _status = _NOT_ENTERED;
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
915 // File: ERC721A.sol
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
940     Context,
941     ERC165,
942     IERC721,
943     IERC721Metadata,
944     IERC721Enumerable
945 {
946     using Address for address;
947     using Strings for uint256;
948 
949     struct TokenOwnership {
950         address addr;
951         uint64 startTimestamp;
952     }
953 
954     struct AddressData {
955         uint128 balance;
956         uint128 numberMinted;
957     }
958 
959     uint256 private currentIndex = 1;
960 
961     uint256 internal immutable collectionSize;
962     uint256 internal immutable maxBatchSize;
963 
964     // Token name
965     string private _name;
966 
967     // Token symbol
968     string private _symbol;
969 
970     // Mapping from token ID to ownership details
971     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
972     mapping(uint256 => TokenOwnership) private _ownerships;
973 
974     // Mapping owner address to address data
975     mapping(address => AddressData) private _addressData;
976 
977     // Mapping from token ID to approved address
978     mapping(uint256 => address) private _tokenApprovals;
979 
980     // Mapping from owner to operator approvals
981     mapping(address => mapping(address => bool)) private _operatorApprovals;
982 
983     /**
984      * @dev
985      * `maxBatchSize` refers to how much a minter can mint at a time.
986      * `collectionSize_` refers to how many tokens are in the collection.
987      */
988     constructor(
989         string memory name_,
990         string memory symbol_,
991         uint256 maxBatchSize_,
992         uint256 collectionSize_
993     ) {
994         require(
995             collectionSize_ > 0,
996             "ERC721A: collection must have a nonzero supply"
997         );
998         require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
999         _name = name_;
1000         _symbol = symbol_;
1001         maxBatchSize = maxBatchSize_;
1002         collectionSize = collectionSize_;
1003     }
1004 
1005     /**
1006      * @dev See {IERC721Enumerable-totalSupply}.
1007      */
1008     function totalSupply() public view override returns (uint256) {
1009         return currentIndex - 1;
1010     }
1011 
1012     /**
1013      * @dev See {IERC721Enumerable-tokenByIndex}.
1014      */
1015     function tokenByIndex(uint256 index)
1016         public
1017         view
1018         override
1019         returns (uint256)
1020     {
1021         require(index < totalSupply(), "ERC721A: global index out of bounds");
1022         return index;
1023     }
1024 
1025     /**
1026      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1027      * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1028      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1029      */
1030     function tokenOfOwnerByIndex(address owner, uint256 index)
1031         public
1032         view
1033         override
1034         returns (uint256)
1035     {
1036         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1037         uint256 numMintedSoFar = totalSupply();
1038         uint256 tokenIdsIdx = 0;
1039         address currOwnershipAddr = address(0);
1040         for (uint256 i = 0; i < numMintedSoFar; i++) {
1041             TokenOwnership memory ownership = _ownerships[i];
1042             if (ownership.addr != address(0)) {
1043                 currOwnershipAddr = ownership.addr;
1044             }
1045             if (currOwnershipAddr == owner) {
1046                 if (tokenIdsIdx == index) {
1047                     return i;
1048                 }
1049                 tokenIdsIdx++;
1050             }
1051         }
1052         revert("ERC721A: unable to get token of owner by index");
1053     }
1054 
1055     /**
1056      * @dev See {IERC165-supportsInterface}.
1057      */
1058     function supportsInterface(bytes4 interfaceId)
1059         public
1060         view
1061         virtual
1062         override(ERC165, IERC165)
1063         returns (bool)
1064     {
1065         return
1066             interfaceId == type(IERC721).interfaceId ||
1067             interfaceId == type(IERC721Metadata).interfaceId ||
1068             interfaceId == type(IERC721Enumerable).interfaceId ||
1069             super.supportsInterface(interfaceId);
1070     }
1071 
1072     /**
1073      * @dev See {IERC721-balanceOf}.
1074      */
1075     function balanceOf(address owner) public view override returns (uint256) {
1076         require(
1077             owner != address(0),
1078             "ERC721A: balance query for the zero address"
1079         );
1080         return uint256(_addressData[owner].balance);
1081     }
1082 
1083     function _numberMinted(address owner) internal view returns (uint256) {
1084         require(
1085             owner != address(0),
1086             "ERC721A: number minted query for the zero address"
1087         );
1088         return uint256(_addressData[owner].numberMinted);
1089     }
1090 
1091     function ownershipOf(uint256 tokenId)
1092         internal
1093         view
1094         returns (TokenOwnership memory)
1095     {
1096         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1097 
1098         uint256 lowestTokenToCheck;
1099         if (tokenId >= maxBatchSize) {
1100             lowestTokenToCheck = tokenId - maxBatchSize + 1;
1101         }
1102 
1103         for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
1104             TokenOwnership memory ownership = _ownerships[curr];
1105             if (ownership.addr != address(0)) {
1106                 return ownership;
1107             }
1108         }
1109 
1110         revert("ERC721A: unable to determine the owner of token");
1111     }
1112 
1113     /**
1114      * @dev See {IERC721-ownerOf}.
1115      */
1116     function ownerOf(uint256 tokenId) public view override returns (address) {
1117         return ownershipOf(tokenId).addr;
1118     }
1119 
1120     /**
1121      * @dev See {IERC721Metadata-name}.
1122      */
1123     function name() public view virtual override returns (string memory) {
1124         return _name;
1125     }
1126 
1127     /**
1128      * @dev See {IERC721Metadata-symbol}.
1129      */
1130     function symbol() public view virtual override returns (string memory) {
1131         return _symbol;
1132     }
1133 
1134     /**
1135      * @dev See {IERC721Metadata-tokenURI}.
1136      */
1137     function tokenURI(uint256 tokenId)
1138         public
1139         view
1140         virtual
1141         override
1142         returns (string memory)
1143     {
1144         require(
1145             _exists(tokenId),
1146             "ERC721Metadata: URI query for nonexistent token"
1147         );
1148 
1149         string memory baseURI = _baseURI();
1150         return
1151             bytes(baseURI).length > 0
1152                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
1153                 : "";
1154     }
1155 
1156     /**
1157      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1158      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1159      * by default, can be overriden in child contracts.
1160      */
1161     function _baseURI() internal view virtual returns (string memory) {
1162         return "";
1163     }
1164 
1165     /**
1166      * @dev See {IERC721-approve}.
1167      */
1168     function approve(address to, uint256 tokenId) public override {
1169         address owner = ERC721A.ownerOf(tokenId);
1170         require(to != owner, "ERC721A: approval to current owner");
1171 
1172         require(
1173             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1174             "ERC721A: approve caller is not owner nor approved for all"
1175         );
1176 
1177         _approve(to, tokenId, owner);
1178     }
1179 
1180     /**
1181      * @dev See {IERC721-getApproved}.
1182      */
1183     function getApproved(uint256 tokenId)
1184         public
1185         view
1186         override
1187         returns (address)
1188     {
1189         require(
1190             _exists(tokenId),
1191             "ERC721A: approved query for nonexistent token"
1192         );
1193 
1194         return _tokenApprovals[tokenId];
1195     }
1196 
1197     /**
1198      * @dev See {IERC721-setApprovalForAll}.
1199      */
1200     function setApprovalForAll(address operator, bool approved)
1201         public
1202         override
1203     {
1204         require(operator != _msgSender(), "ERC721A: approve to caller");
1205 
1206         _operatorApprovals[_msgSender()][operator] = approved;
1207         emit ApprovalForAll(_msgSender(), operator, approved);
1208     }
1209 
1210     /**
1211      * @dev See {IERC721-isApprovedForAll}.
1212      */
1213     function isApprovedForAll(address owner, address operator)
1214         public
1215         view
1216         virtual
1217         override
1218         returns (bool)
1219     {
1220         return _operatorApprovals[owner][operator];
1221     }
1222 
1223     /**
1224      * @dev See {IERC721-transferFrom}.
1225      */
1226     function transferFrom(
1227         address from,
1228         address to,
1229         uint256 tokenId
1230     ) public override {
1231         _transfer(from, to, tokenId);
1232     }
1233 
1234     /**
1235      * @dev See {IERC721-safeTransferFrom}.
1236      */
1237     function safeTransferFrom(
1238         address from,
1239         address to,
1240         uint256 tokenId
1241     ) public override {
1242         safeTransferFrom(from, to, tokenId, "");
1243     }
1244 
1245     /**
1246      * @dev See {IERC721-safeTransferFrom}.
1247      */
1248     function safeTransferFrom(
1249         address from,
1250         address to,
1251         uint256 tokenId,
1252         bytes memory _data
1253     ) public override {
1254         _transfer(from, to, tokenId);
1255         require(
1256             _checkOnERC721Received(from, to, tokenId, _data),
1257             "ERC721A: transfer to non ERC721Receiver implementer"
1258         );
1259     }
1260 
1261     /**
1262      * @dev Returns whether `tokenId` exists.
1263      *
1264      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1265      *
1266      * Tokens start existing when they are minted (`_mint`),
1267      */
1268     function _exists(uint256 tokenId) internal view returns (bool) {
1269         return tokenId < currentIndex && tokenId > 0;
1270     }
1271 
1272     function _safeMint(address to, uint256 quantity) internal {
1273         _safeMint(to, quantity, "");
1274     }
1275 
1276     /**
1277      * @dev Mints `quantity` tokens and transfers them to `to`.
1278      *
1279      * Requirements:
1280      *
1281      * - there must be `quantity` tokens remaining unminted in the total collection.
1282      * - `to` cannot be the zero address.
1283      * - `quantity` cannot be larger than the max batch size.
1284      *
1285      * Emits a {Transfer} event.
1286      */
1287     function _safeMint(
1288         address to,
1289         uint256 quantity,
1290         bytes memory _data
1291     ) internal {
1292         uint256 startTokenId = currentIndex;
1293         require(to != address(0), "ERC721A: mint to the zero address");
1294         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1295         require(!_exists(startTokenId), "ERC721A: token already minted");
1296         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1297 
1298         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1299 
1300         AddressData memory addressData = _addressData[to];
1301         _addressData[to] = AddressData(
1302             addressData.balance + uint128(quantity),
1303             addressData.numberMinted + uint128(quantity)
1304         );
1305         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1306 
1307         uint256 updatedIndex = startTokenId;
1308 
1309         for (uint256 i = 0; i < quantity; i++) {
1310             emit Transfer(address(0), to, updatedIndex);
1311             require(
1312                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
1313                 "ERC721A: transfer to non ERC721Receiver implementer"
1314             );
1315             updatedIndex++;
1316         }
1317 
1318         currentIndex = updatedIndex;
1319         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1320     }
1321 
1322     /**
1323      * @dev Transfers `tokenId` from `from` to `to`.
1324      *
1325      * Requirements:
1326      *
1327      * - `to` cannot be the zero address.
1328      * - `tokenId` token must be owned by `from`.
1329      *
1330      * Emits a {Transfer} event.
1331      */
1332     function _transfer(
1333         address from,
1334         address to,
1335         uint256 tokenId
1336     ) private {
1337         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1338 
1339         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1340             getApproved(tokenId) == _msgSender() ||
1341             isApprovedForAll(prevOwnership.addr, _msgSender()));
1342 
1343         require(
1344             isApprovedOrOwner,
1345             "ERC721A: transfer caller is not owner nor approved"
1346         );
1347 
1348         require(
1349             prevOwnership.addr == from,
1350             "ERC721A: transfer from incorrect owner"
1351         );
1352         require(to != address(0), "ERC721A: transfer to the zero address");
1353 
1354         _beforeTokenTransfers(from, to, tokenId, 1);
1355 
1356         // Clear approvals from the previous owner
1357         _approve(address(0), tokenId, prevOwnership.addr);
1358 
1359         _addressData[from].balance -= 1;
1360         _addressData[to].balance += 1;
1361         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1362 
1363         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1364         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1365         uint256 nextTokenId = tokenId + 1;
1366         if (_ownerships[nextTokenId].addr == address(0)) {
1367             if (_exists(nextTokenId)) {
1368                 _ownerships[nextTokenId] = TokenOwnership(
1369                     prevOwnership.addr,
1370                     prevOwnership.startTimestamp
1371                 );
1372             }
1373         }
1374 
1375         emit Transfer(from, to, tokenId);
1376         _afterTokenTransfers(from, to, tokenId, 1);
1377     }
1378 
1379     /**
1380      * @dev Approve `to` to operate on `tokenId`
1381      *
1382      * Emits a {Approval} event.
1383      */
1384     function _approve(
1385         address to,
1386         uint256 tokenId,
1387         address owner
1388     ) private {
1389         _tokenApprovals[tokenId] = to;
1390         emit Approval(owner, to, tokenId);
1391     }
1392 
1393     uint256 public nextOwnerToExplicitlySet = 0;
1394 
1395     /**
1396      * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1397      */
1398     function _setOwnersExplicit(uint256 quantity) internal {
1399         uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1400         require(quantity > 0, "quantity must be nonzero");
1401         uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1402         if (endIndex > collectionSize - 1) {
1403             endIndex = collectionSize - 1;
1404         }
1405         // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1406         require(_exists(endIndex), "not enough minted yet for this cleanup");
1407         for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1408             if (_ownerships[i].addr == address(0)) {
1409                 TokenOwnership memory ownership = ownershipOf(i);
1410                 _ownerships[i] = TokenOwnership(
1411                     ownership.addr,
1412                     ownership.startTimestamp
1413                 );
1414             }
1415         }
1416         nextOwnerToExplicitlySet = endIndex + 1;
1417     }
1418 
1419     /**
1420      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1421      * The call is not executed if the target address is not a contract.
1422      *
1423      * @param from address representing the previous owner of the given token ID
1424      * @param to target address that will receive the tokens
1425      * @param tokenId uint256 ID of the token to be transferred
1426      * @param _data bytes optional data to send along with the call
1427      * @return bool whether the call correctly returned the expected magic value
1428      */
1429     function _checkOnERC721Received(
1430         address from,
1431         address to,
1432         uint256 tokenId,
1433         bytes memory _data
1434     ) private returns (bool) {
1435         if (to.isContract()) {
1436             try
1437                 IERC721Receiver(to).onERC721Received(
1438                     _msgSender(),
1439                     from,
1440                     tokenId,
1441                     _data
1442                 )
1443             returns (bytes4 retval) {
1444                 return retval == IERC721Receiver(to).onERC721Received.selector;
1445             } catch (bytes memory reason) {
1446                 if (reason.length == 0) {
1447                     revert(
1448                         "ERC721A: transfer to non ERC721Receiver implementer"
1449                     );
1450                 } else {
1451                     assembly {
1452                         revert(add(32, reason), mload(reason))
1453                     }
1454                 }
1455             }
1456         } else {
1457             return true;
1458         }
1459     }
1460 
1461     /**
1462      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1463      *
1464      * startTokenId - the first token id to be transferred
1465      * quantity - the amount to be transferred
1466      *
1467      * Calling conditions:
1468      *
1469      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1470      * transferred to `to`.
1471      * - When `from` is zero, `tokenId` will be minted for `to`.
1472      */
1473     function _beforeTokenTransfers(
1474         address from,
1475         address to,
1476         uint256 startTokenId,
1477         uint256 quantity
1478     ) internal virtual {}
1479 
1480     /**
1481      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1482      * minting.
1483      *
1484      * startTokenId - the first token id to be transferred
1485      * quantity - the amount to be transferred
1486      *
1487      * Calling conditions:
1488      *
1489      * - when `from` and `to` are both non-zero.
1490      * - `from` and `to` are never both zero.
1491      */
1492     function _afterTokenTransfers(
1493         address from,
1494         address to,
1495         uint256 startTokenId,
1496         uint256 quantity
1497     ) internal virtual {}
1498 }
1499 // File: @openzeppelin/contracts/access/Ownable.sol
1500 
1501 
1502 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1503 
1504 pragma solidity ^0.8.0;
1505 
1506 
1507 /**
1508  * @dev Contract module which provides a basic access control mechanism, where
1509  * there is an account (an owner) that can be granted exclusive access to
1510  * specific functions.
1511  *
1512  * By default, the owner account will be the one that deploys the contract. This
1513  * can later be changed with {transferOwnership}.
1514  *
1515  * This module is used through inheritance. It will make available the modifier
1516  * `onlyOwner`, which can be applied to your functions to restrict their use to
1517  * the owner.
1518  */
1519 abstract contract Ownable is Context {
1520     address private _owner;
1521 
1522     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1523 
1524     /**
1525      * @dev Initializes the contract setting the deployer as the initial owner.
1526      */
1527     constructor() {
1528         _transferOwnership(_msgSender());
1529     }
1530 
1531     /**
1532      * @dev Returns the address of the current owner.
1533      */
1534     function owner() public view virtual returns (address) {
1535         return _owner;
1536     }
1537 
1538     /**
1539      * @dev Throws if called by any account other than the owner.
1540      */
1541     modifier onlyOwner() {
1542         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1543         _;
1544     }
1545 
1546     /**
1547      * @dev Leaves the contract without owner. It will not be possible to call
1548      * `onlyOwner` functions anymore. Can only be called by the current owner.
1549      *
1550      * NOTE: Renouncing ownership will leave the contract without an owner,
1551      * thereby removing any functionality that is only available to the owner.
1552      */
1553     function renounceOwnership() public virtual onlyOwner {
1554         _transferOwnership(address(0));
1555     }
1556 
1557     /**
1558      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1559      * Can only be called by the current owner.
1560      */
1561     function transferOwnership(address newOwner) public virtual onlyOwner {
1562         require(newOwner != address(0), "Ownable: new owner is the zero address");
1563         _transferOwnership(newOwner);
1564     }
1565 
1566     /**
1567      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1568      * Internal function without access restriction.
1569      */
1570     function _transferOwnership(address newOwner) internal virtual {
1571         address oldOwner = _owner;
1572         _owner = newOwner;
1573         emit OwnershipTransferred(oldOwner, newOwner);
1574     }
1575 }
1576 
1577 // File: TheClinic.sol
1578 
1579 
1580 
1581 pragma solidity ^0.8.0;
1582 
1583 
1584 
1585 
1586 
1587 contract TheClinic is Ownable, ERC721A, ReentrancyGuard {
1588     using ECDSA for bytes32;
1589 
1590     uint256 public constant MAX_SUPPLY = 10000;
1591 
1592     uint256 public walletLimit = 15;
1593     uint256 public itemPrice = 0.06 ether;
1594     //0->not started | 1-> presale | 2-> public sale
1595     uint256 public saleStatus;
1596 
1597     string private _baseTokenURI;
1598 
1599     address public wallet1 = 0xDF9832024eB878241Fc324CC041C848466e27841;
1600 
1601     mapping(address => mapping(uint256 => uint256)) public walletMintedBySale;
1602     mapping(address => bool) public trustedSigner;
1603 
1604     modifier whenPublicSaleActive() {
1605         require(saleStatus == 2, "Public sale is not active");
1606         _;
1607     }
1608 
1609     modifier whenPreSaleActive() {
1610         require(saleStatus == 1, "Pre sale is not active");
1611         _;
1612     }
1613 
1614     modifier callerIsUser() {
1615         require(tx.origin == _msgSender(), "The caller is another contract");
1616         _;
1617     }
1618 
1619     modifier checkPrice(uint256 _howMany) {
1620         require(
1621             itemPrice * _howMany <= msg.value,
1622             "Ether value sent is not correct"
1623         );
1624         _;
1625     }
1626 
1627     constructor()
1628         ERC721A("The Iconic Miss Crypto Clinic", "Clinic", 100, MAX_SUPPLY)
1629     {
1630         trustedSigner[_msgSender()] = true;
1631     }
1632 
1633     function setTrustedSigner(address _wallet, bool _status)
1634         external
1635         onlyOwner
1636     {
1637         trustedSigner[_wallet] = _status;
1638     }
1639 
1640     function forAirdrop(address[] memory _to, uint256[] memory _count)
1641         external
1642         onlyOwner
1643     {
1644         uint256 _length = _to.length;
1645         for (uint256 i = 0; i < _length; i++) {
1646             giveaway(_to[i], _count[i]);
1647         }
1648     }
1649 
1650     function giveaway(address _to, uint256 _howMany) public onlyOwner {
1651         require(_to != address(0), "Zero address");
1652         _beforeMint(_howMany);
1653         _safeMint(_to, _howMany);
1654     }
1655 
1656     function _beforeMint(uint256 _howMany) private view {
1657         require(_howMany > 0, "Must mint at least one");
1658         uint256 supply = totalSupply();
1659         require(
1660             supply + _howMany <= MAX_SUPPLY,
1661             "Minting would exceed max supply"
1662         );
1663     }
1664 
1665     function whitelistMint(
1666         uint256 _howMany,
1667         uint256 _timestamp,
1668         bytes memory _signature
1669     )
1670         external
1671         payable
1672         nonReentrant
1673         whenPreSaleActive
1674         callerIsUser
1675         checkPrice(_howMany)
1676     {
1677         _isValid(_msgSender(), _howMany, _timestamp, _signature);
1678         _beforeMint(_howMany);
1679         require(
1680             walletMintedBySale[_msgSender()][1] + _howMany <= walletLimit,
1681             "Wallet limit exceeds"
1682         );
1683         walletMintedBySale[_msgSender()][1] += _howMany;
1684         _safeMint(_msgSender(), _howMany);
1685         _withdraw();
1686     }
1687 
1688     function saleMint(uint256 _howMany)
1689         external
1690         payable
1691         nonReentrant
1692         whenPublicSaleActive
1693         callerIsUser
1694         checkPrice(_howMany)
1695     {
1696         _beforeMint(_howMany);
1697         require(
1698             walletMintedBySale[_msgSender()][2] + _howMany <= walletLimit,
1699             "Wallet limit exceeds"
1700         );
1701         walletMintedBySale[_msgSender()][2] += _howMany;
1702         _safeMint(_msgSender(), _howMany);
1703         _withdraw();
1704     }
1705 
1706     function _isValid(
1707         address _wallet,
1708         uint256 _count,
1709         uint256 _timestamp,
1710         bytes memory _signature
1711     ) internal view {
1712         address signerOwner = signatureWallet(
1713             _wallet,
1714             _count,
1715             _timestamp,
1716             _signature
1717         );
1718         require(trustedSigner[signerOwner], "Not authorized to mint");
1719     }
1720 
1721     function signatureWallet(
1722         address _wallet,
1723         uint256 _count,
1724         uint256 _timestamp,
1725         bytes memory _signature
1726     ) public view returns (address) {
1727         bytes32 message = keccak256(
1728             abi.encode(address(this), _wallet, _count, _timestamp)
1729         );
1730         bytes32 ethSignedMessageHash = message.toEthSignedMessageHash();
1731         return ECDSA.recover(ethSignedMessageHash, _signature);
1732     }
1733 
1734     function startPublicSale() external onlyOwner {
1735         require(saleStatus != 2, "Public sale has already begun");
1736         saleStatus = 2;
1737     }
1738 
1739     function pausePublicSale() external onlyOwner whenPublicSaleActive {
1740         saleStatus = 0;
1741     }
1742 
1743     function startPreSale() external onlyOwner {
1744         require(saleStatus != 1, "Pre sale has already begun");
1745         saleStatus = 1;
1746     }
1747 
1748     function pausePreSale() external onlyOwner whenPreSaleActive {
1749         saleStatus = 0;
1750     }
1751 
1752     function _baseURI() internal view virtual override returns (string memory) {
1753         return _baseTokenURI;
1754     }
1755 
1756     function setBaseURI(string calldata baseURI) external onlyOwner {
1757         _baseTokenURI = baseURI;
1758     }
1759 
1760     // list all the tokens ids of a wallet
1761     function tokensOfOwner(address _owner)
1762         external
1763         view
1764         returns (uint256[] memory)
1765     {
1766         uint256 tokenCount = balanceOf(_owner);
1767         if (tokenCount == 0) {
1768             // Return an empty array
1769             return new uint256[](0);
1770         } else {
1771             uint256[] memory result = new uint256[](tokenCount);
1772             uint256 index;
1773             for (index = 0; index < tokenCount; index++) {
1774                 result[index] = tokenOfOwnerByIndex(_owner, index);
1775             }
1776             return result;
1777         }
1778     }
1779 
1780     function updateWallets(address _wallet1) external onlyOwner {
1781         wallet1 = _wallet1;
1782     }
1783 
1784     function withdrawMoney() external onlyOwner nonReentrant {
1785         _withdraw();
1786     }
1787 
1788     function _withdraw() internal {
1789         uint256 bal = accountBalance();
1790         (bool success1, ) = wallet1.call{value: bal}("");
1791         require(success1, "Transfer failed.");
1792     }
1793 
1794     receive() external payable {
1795         _withdraw();
1796     }
1797 
1798     function accountBalance() public view returns (uint256) {
1799         return address(this).balance;
1800     }
1801 
1802     function setPrice(uint256 _newPrice) external onlyOwner {
1803         itemPrice = _newPrice;
1804     }
1805 
1806     function modifyWalletLimit(uint256 _walletLimit) external onlyOwner {
1807         walletLimit = _walletLimit;
1808     }
1809 
1810     function setOwnersExplicit(uint256 quantity)
1811         external
1812         onlyOwner
1813         nonReentrant
1814     {
1815         _setOwnersExplicit(quantity);
1816     }
1817 
1818     function numberMinted(address owner) public view returns (uint256) {
1819         return _numberMinted(owner);
1820     }
1821 
1822     function exists(uint256 _tokenId) external view returns (bool) {
1823         return _exists(_tokenId);
1824     }
1825 
1826     function getOwnershipData(uint256 tokenId)
1827         external
1828         view
1829         returns (TokenOwnership memory)
1830     {
1831         return ownershipOf(tokenId);
1832     }
1833 }