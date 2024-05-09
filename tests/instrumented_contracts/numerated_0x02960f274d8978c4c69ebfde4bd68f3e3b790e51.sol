1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/Address.sol
4 
5 /*
6 __________                         .___ ___________     ___.   .__            ____  __.      .__       .__     __          
7 \______   \ ____  __ __  ____    __| _/ \__    ___/____ \_ |__ |  |   ____   |    |/ _| ____ |__| ____ |  |___/  |_  ______
8  |       _//  _ \|  |  \/    \  / __ |    |    |  \__  \ | __ \|  | _/ __ \  |      <  /    \|  |/ ___\|  |  \   __\/  ___/
9  |    |   (  <_> )  |  /   |  \/ /_/ |    |    |   / __ \| \_\ \  |_\  ___/  |    |  \|   |  \  / /_/  >   Y  \  |  \___ \ 
10  |____|_  /\____/|____/|___|  /\____ |    |____|  (____  /___  /____/\___  > |____|__ \___|  /__\___  /|___|  /__| /____  >
11         \/                  \/      \/                 \/    \/          \/          \/    \/  /_____/      \/          \/                                                        
12 
13 */
14 
15 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
16 
17 pragma solidity ^0.8.1;
18 
19 /**
20  * @dev Collection of functions related to the address type
21  */
22 library Address {
23     /**
24      * @dev Returns true if `account` is a contract.
25      *
26      * [IMPORTANT]
27      * ====
28      * It is unsafe to assume that an address for which this function returns
29      * false is an externally-owned account (EOA) and not a contract.
30      *
31      * Among others, `isContract` will return false for the following
32      * types of addresses:
33      *
34      *  - an externally-owned account
35      *  - a contract in construction
36      *  - an address where a contract will be created
37      *  - an address where a contract lived, but was destroyed
38      * ====
39      *
40      * [IMPORTANT]
41      * ====
42      * You shouldn't rely on `isContract` to protect against flash loan attacks!
43      *
44      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
45      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
46      * constructor.
47      * ====
48      */
49     function isContract(address account) internal view returns (bool) {
50         // This method relies on extcodesize/address.code.length, which returns 0
51         // for contracts in construction, since the code is only stored at the end
52         // of the constructor execution.
53 
54         return account.code.length > 0;
55     }
56 
57     /**
58      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
59      * `recipient`, forwarding all available gas and reverting on errors.
60      *
61      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
62      * of certain opcodes, possibly making contracts go over the 2300 gas limit
63      * imposed by `transfer`, making them unable to receive funds via
64      * `transfer`. {sendValue} removes this limitation.
65      *
66      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
67      *
68      * IMPORTANT: because control is transferred to `recipient`, care must be
69      * taken to not create reentrancy vulnerabilities. Consider using
70      * {ReentrancyGuard} or the
71      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
72      */
73     function sendValue(address payable recipient, uint256 amount) internal {
74         require(address(this).balance >= amount, "Address: insufficient balance");
75 
76         (bool success, ) = recipient.call{value: amount}("");
77         require(success, "Address: unable to send value, recipient may have reverted");
78     }
79 
80     /**
81      * @dev Performs a Solidity function call using a low level `call`. A
82      * plain `call` is an unsafe replacement for a function call: use this
83      * function instead.
84      *
85      * If `target` reverts with a revert reason, it is bubbled up by this
86      * function (like regular Solidity function calls).
87      *
88      * Returns the raw returned data. To convert to the expected return value,
89      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
90      *
91      * Requirements:
92      *
93      * - `target` must be a contract.
94      * - calling `target` with `data` must not revert.
95      *
96      * _Available since v3.1._
97      */
98     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
99         return functionCall(target, data, "Address: low-level call failed");
100     }
101 
102     /**
103      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
104      * `errorMessage` as a fallback revert reason when `target` reverts.
105      *
106      * _Available since v3.1._
107      */
108     function functionCall(
109         address target,
110         bytes memory data,
111         string memory errorMessage
112     ) internal returns (bytes memory) {
113         return functionCallWithValue(target, data, 0, errorMessage);
114     }
115 
116     /**
117      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
118      * but also transferring `value` wei to `target`.
119      *
120      * Requirements:
121      *
122      * - the calling contract must have an ETH balance of at least `value`.
123      * - the called Solidity function must be `payable`.
124      *
125      * _Available since v3.1._
126      */
127     function functionCallWithValue(
128         address target,
129         bytes memory data,
130         uint256 value
131     ) internal returns (bytes memory) {
132         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
133     }
134 
135     /**
136      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
137      * with `errorMessage` as a fallback revert reason when `target` reverts.
138      *
139      * _Available since v3.1._
140      */
141     function functionCallWithValue(
142         address target,
143         bytes memory data,
144         uint256 value,
145         string memory errorMessage
146     ) internal returns (bytes memory) {
147         require(address(this).balance >= value, "Address: insufficient balance for call");
148         require(isContract(target), "Address: call to non-contract");
149 
150         (bool success, bytes memory returndata) = target.call{value: value}(data);
151         return verifyCallResult(success, returndata, errorMessage);
152     }
153 
154     /**
155      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
156      * but performing a static call.
157      *
158      * _Available since v3.3._
159      */
160     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
161         return functionStaticCall(target, data, "Address: low-level static call failed");
162     }
163 
164     /**
165      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
166      * but performing a static call.
167      *
168      * _Available since v3.3._
169      */
170     function functionStaticCall(
171         address target,
172         bytes memory data,
173         string memory errorMessage
174     ) internal view returns (bytes memory) {
175         require(isContract(target), "Address: static call to non-contract");
176 
177         (bool success, bytes memory returndata) = target.staticcall(data);
178         return verifyCallResult(success, returndata, errorMessage);
179     }
180 
181     /**
182      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
183      * but performing a delegate call.
184      *
185      * _Available since v3.4._
186      */
187     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
188         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
189     }
190 
191     /**
192      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
193      * but performing a delegate call.
194      *
195      * _Available since v3.4._
196      */
197     function functionDelegateCall(
198         address target,
199         bytes memory data,
200         string memory errorMessage
201     ) internal returns (bytes memory) {
202         require(isContract(target), "Address: delegate call to non-contract");
203 
204         (bool success, bytes memory returndata) = target.delegatecall(data);
205         return verifyCallResult(success, returndata, errorMessage);
206     }
207 
208     /**
209      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
210      * revert reason using the provided one.
211      *
212      * _Available since v4.3._
213      */
214     function verifyCallResult(
215         bool success,
216         bytes memory returndata,
217         string memory errorMessage
218     ) internal pure returns (bytes memory) {
219         if (success) {
220             return returndata;
221         } else {
222             // Look for revert reason and bubble it up if present
223             if (returndata.length > 0) {
224                 // The easiest way to bubble the revert reason is using memory via assembly
225 
226                 assembly {
227                     let returndata_size := mload(returndata)
228                     revert(add(32, returndata), returndata_size)
229                 }
230             } else {
231                 revert(errorMessage);
232             }
233         }
234     }
235 }
236 
237 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
238 
239 
240 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
241 
242 pragma solidity ^0.8.0;
243 
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
266 
267 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
268 
269 
270 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
271 
272 pragma solidity ^0.8.0;
273 
274 /**
275  * @dev Interface of the ERC165 standard, as defined in the
276  * https://eips.ethereum.org/EIPS/eip-165[EIP].
277  *
278  * Implementers can declare support of contract interfaces, which can then be
279  * queried by others ({ERC165Checker}).
280  *
281  * For an implementation, see {ERC165}.
282  */
283 interface IERC165 {
284     /**
285      * @dev Returns true if this contract implements the interface defined by
286      * `interfaceId`. See the corresponding
287      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
288      * to learn more about how these ids are created.
289      *
290      * This function call must use less than 30 000 gas.
291      */
292     function supportsInterface(bytes4 interfaceId) external view returns (bool);
293 }
294 
295 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
296 
297 
298 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
299 
300 pragma solidity ^0.8.0;
301 
302 
303 /**
304  * @dev Implementation of the {IERC165} interface.
305  *
306  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
307  * for the additional interface id that will be supported. For example:
308  *
309  * ```solidity
310  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
311  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
312  * }
313  * ```
314  *
315  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
316  */
317 abstract contract ERC165 is IERC165 {
318     /**
319      * @dev See {IERC165-supportsInterface}.
320      */
321     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
322         return interfaceId == type(IERC165).interfaceId;
323     }
324 }
325 
326 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
327 
328 
329 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
330 
331 pragma solidity ^0.8.0;
332 
333 
334 /**
335  * @dev Required interface of an ERC721 compliant contract.
336  */
337 interface IERC721 is IERC165 {
338     /**
339      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
340      */
341     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
342 
343     /**
344      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
345      */
346     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
347 
348     /**
349      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
350      */
351     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
352 
353     /**
354      * @dev Returns the number of tokens in ``owner``'s account.
355      */
356     function balanceOf(address owner) external view returns (uint256 balance);
357 
358     /**
359      * @dev Returns the owner of the `tokenId` token.
360      *
361      * Requirements:
362      *
363      * - `tokenId` must exist.
364      */
365     function ownerOf(uint256 tokenId) external view returns (address owner);
366 
367     /**
368      * @dev Safely transfers `tokenId` token from `from` to `to`.
369      *
370      * Requirements:
371      *
372      * - `from` cannot be the zero address.
373      * - `to` cannot be the zero address.
374      * - `tokenId` token must exist and be owned by `from`.
375      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
376      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
377      *
378      * Emits a {Transfer} event.
379      */
380     function safeTransferFrom(
381         address from,
382         address to,
383         uint256 tokenId,
384         bytes calldata data
385     ) external;
386 
387     /**
388      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
389      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
390      *
391      * Requirements:
392      *
393      * - `from` cannot be the zero address.
394      * - `to` cannot be the zero address.
395      * - `tokenId` token must exist and be owned by `from`.
396      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
397      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
398      *
399      * Emits a {Transfer} event.
400      */
401     function safeTransferFrom(
402         address from,
403         address to,
404         uint256 tokenId
405     ) external;
406 
407     /**
408      * @dev Transfers `tokenId` token from `from` to `to`.
409      *
410      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
411      *
412      * Requirements:
413      *
414      * - `from` cannot be the zero address.
415      * - `to` cannot be the zero address.
416      * - `tokenId` token must be owned by `from`.
417      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
418      *
419      * Emits a {Transfer} event.
420      */
421     function transferFrom(
422         address from,
423         address to,
424         uint256 tokenId
425     ) external;
426 
427     /**
428      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
429      * The approval is cleared when the token is transferred.
430      *
431      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
432      *
433      * Requirements:
434      *
435      * - The caller must own the token or be an approved operator.
436      * - `tokenId` must exist.
437      *
438      * Emits an {Approval} event.
439      */
440     function approve(address to, uint256 tokenId) external;
441 
442     /**
443      * @dev Approve or remove `operator` as an operator for the caller.
444      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
445      *
446      * Requirements:
447      *
448      * - The `operator` cannot be the caller.
449      *
450      * Emits an {ApprovalForAll} event.
451      */
452     function setApprovalForAll(address operator, bool _approved) external;
453 
454     /**
455      * @dev Returns the account approved for `tokenId` token.
456      *
457      * Requirements:
458      *
459      * - `tokenId` must exist.
460      */
461     function getApproved(uint256 tokenId) external view returns (address operator);
462 
463     /**
464      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
465      *
466      * See {setApprovalForAll}
467      */
468     function isApprovedForAll(address owner, address operator) external view returns (bool);
469 }
470 
471 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
472 
473 
474 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
475 
476 pragma solidity ^0.8.0;
477 
478 
479 /**
480  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
481  * @dev See https://eips.ethereum.org/EIPS/eip-721
482  */
483 interface IERC721Enumerable is IERC721 {
484     /**
485      * @dev Returns the total amount of tokens stored by the contract.
486      */
487     function totalSupply() external view returns (uint256);
488 
489     /**
490      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
491      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
492      */
493     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
494 
495     /**
496      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
497      * Use along with {totalSupply} to enumerate all tokens.
498      */
499     function tokenByIndex(uint256 index) external view returns (uint256);
500 }
501 
502 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
503 
504 
505 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
506 
507 pragma solidity ^0.8.0;
508 
509 
510 /**
511  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
512  * @dev See https://eips.ethereum.org/EIPS/eip-721
513  */
514 interface IERC721Metadata is IERC721 {
515     /**
516      * @dev Returns the token collection name.
517      */
518     function name() external view returns (string memory);
519 
520     /**
521      * @dev Returns the token collection symbol.
522      */
523     function symbol() external view returns (string memory);
524 
525     /**
526      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
527      */
528     function tokenURI(uint256 tokenId) external view returns (string memory);
529 }
530 
531 // File: @openzeppelin/contracts/utils/Strings.sol
532 
533 
534 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
535 
536 pragma solidity ^0.8.0;
537 
538 /**
539  * @dev String operations.
540  */
541 library Strings {
542     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
543 
544     /**
545      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
546      */
547     function toString(uint256 value) internal pure returns (string memory) {
548         // Inspired by OraclizeAPI's implementation - MIT licence
549         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
550 
551         if (value == 0) {
552             return "0";
553         }
554         uint256 temp = value;
555         uint256 digits;
556         while (temp != 0) {
557             digits++;
558             temp /= 10;
559         }
560         bytes memory buffer = new bytes(digits);
561         while (value != 0) {
562             digits -= 1;
563             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
564             value /= 10;
565         }
566         return string(buffer);
567     }
568 
569     /**
570      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
571      */
572     function toHexString(uint256 value) internal pure returns (string memory) {
573         if (value == 0) {
574             return "0x00";
575         }
576         uint256 temp = value;
577         uint256 length = 0;
578         while (temp != 0) {
579             length++;
580             temp >>= 8;
581         }
582         return toHexString(value, length);
583     }
584 
585     /**
586      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
587      */
588     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
589         bytes memory buffer = new bytes(2 * length + 2);
590         buffer[0] = "0";
591         buffer[1] = "x";
592         for (uint256 i = 2 * length + 1; i > 1; --i) {
593             buffer[i] = _HEX_SYMBOLS[value & 0xf];
594             value >>= 4;
595         }
596         require(value == 0, "Strings: hex length insufficient");
597         return string(buffer);
598     }
599 }
600 
601 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
602 
603 
604 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/ECDSA.sol)
605 
606 pragma solidity ^0.8.0;
607 
608 
609 /**
610  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
611  *
612  * These functions can be used to verify that a message was signed by the holder
613  * of the private keys of a given address.
614  */
615 library ECDSA {
616     enum RecoverError {
617         NoError,
618         InvalidSignature,
619         InvalidSignatureLength,
620         InvalidSignatureS,
621         InvalidSignatureV
622     }
623 
624     function _throwError(RecoverError error) private pure {
625         if (error == RecoverError.NoError) {
626             return; // no error: do nothing
627         } else if (error == RecoverError.InvalidSignature) {
628             revert("ECDSA: invalid signature");
629         } else if (error == RecoverError.InvalidSignatureLength) {
630             revert("ECDSA: invalid signature length");
631         } else if (error == RecoverError.InvalidSignatureS) {
632             revert("ECDSA: invalid signature 's' value");
633         } else if (error == RecoverError.InvalidSignatureV) {
634             revert("ECDSA: invalid signature 'v' value");
635         }
636     }
637 
638     /**
639      * @dev Returns the address that signed a hashed message (`hash`) with
640      * `signature` or error string. This address can then be used for verification purposes.
641      *
642      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
643      * this function rejects them by requiring the `s` value to be in the lower
644      * half order, and the `v` value to be either 27 or 28.
645      *
646      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
647      * verification to be secure: it is possible to craft signatures that
648      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
649      * this is by receiving a hash of the original message (which may otherwise
650      * be too long), and then calling {toEthSignedMessageHash} on it.
651      *
652      * Documentation for signature generation:
653      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
654      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
655      *
656      * _Available since v4.3._
657      */
658     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
659         // Check the signature length
660         // - case 65: r,s,v signature (standard)
661         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
662         if (signature.length == 65) {
663             bytes32 r;
664             bytes32 s;
665             uint8 v;
666             // ecrecover takes the signature parameters, and the only way to get them
667             // currently is to use assembly.
668             assembly {
669                 r := mload(add(signature, 0x20))
670                 s := mload(add(signature, 0x40))
671                 v := byte(0, mload(add(signature, 0x60)))
672             }
673             return tryRecover(hash, v, r, s);
674         } else if (signature.length == 64) {
675             bytes32 r;
676             bytes32 vs;
677             // ecrecover takes the signature parameters, and the only way to get them
678             // currently is to use assembly.
679             assembly {
680                 r := mload(add(signature, 0x20))
681                 vs := mload(add(signature, 0x40))
682             }
683             return tryRecover(hash, r, vs);
684         } else {
685             return (address(0), RecoverError.InvalidSignatureLength);
686         }
687     }
688 
689     /**
690      * @dev Returns the address that signed a hashed message (`hash`) with
691      * `signature`. This address can then be used for verification purposes.
692      *
693      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
694      * this function rejects them by requiring the `s` value to be in the lower
695      * half order, and the `v` value to be either 27 or 28.
696      *
697      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
698      * verification to be secure: it is possible to craft signatures that
699      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
700      * this is by receiving a hash of the original message (which may otherwise
701      * be too long), and then calling {toEthSignedMessageHash} on it.
702      */
703     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
704         (address recovered, RecoverError error) = tryRecover(hash, signature);
705         _throwError(error);
706         return recovered;
707     }
708 
709     /**
710      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
711      *
712      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
713      *
714      * _Available since v4.3._
715      */
716     function tryRecover(
717         bytes32 hash,
718         bytes32 r,
719         bytes32 vs
720     ) internal pure returns (address, RecoverError) {
721         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
722         uint8 v = uint8((uint256(vs) >> 255) + 27);
723         return tryRecover(hash, v, r, s);
724     }
725 
726     /**
727      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
728      *
729      * _Available since v4.2._
730      */
731     function recover(
732         bytes32 hash,
733         bytes32 r,
734         bytes32 vs
735     ) internal pure returns (address) {
736         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
737         _throwError(error);
738         return recovered;
739     }
740 
741     /**
742      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
743      * `r` and `s` signature fields separately.
744      *
745      * _Available since v4.3._
746      */
747     function tryRecover(
748         bytes32 hash,
749         uint8 v,
750         bytes32 r,
751         bytes32 s
752     ) internal pure returns (address, RecoverError) {
753         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
754         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
755         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
756         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
757         //
758         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
759         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
760         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
761         // these malleable signatures as well.
762         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
763             return (address(0), RecoverError.InvalidSignatureS);
764         }
765         if (v != 27 && v != 28) {
766             return (address(0), RecoverError.InvalidSignatureV);
767         }
768 
769         // If the signature is valid (and not malleable), return the signer address
770         address signer = ecrecover(hash, v, r, s);
771         if (signer == address(0)) {
772             return (address(0), RecoverError.InvalidSignature);
773         }
774 
775         return (signer, RecoverError.NoError);
776     }
777 
778     /**
779      * @dev Overload of {ECDSA-recover} that receives the `v`,
780      * `r` and `s` signature fields separately.
781      */
782     function recover(
783         bytes32 hash,
784         uint8 v,
785         bytes32 r,
786         bytes32 s
787     ) internal pure returns (address) {
788         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
789         _throwError(error);
790         return recovered;
791     }
792 
793     /**
794      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
795      * produces hash corresponding to the one signed with the
796      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
797      * JSON-RPC method as part of EIP-191.
798      *
799      * See {recover}.
800      */
801     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
802         // 32 is the length in bytes of hash,
803         // enforced by the type signature above
804         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
805     }
806 
807     /**
808      * @dev Returns an Ethereum Signed Message, created from `s`. This
809      * produces hash corresponding to the one signed with the
810      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
811      * JSON-RPC method as part of EIP-191.
812      *
813      * See {recover}.
814      */
815     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
816         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
817     }
818 
819     /**
820      * @dev Returns an Ethereum Signed Typed Data, created from a
821      * `domainSeparator` and a `structHash`. This produces hash corresponding
822      * to the one signed with the
823      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
824      * JSON-RPC method as part of EIP-712.
825      *
826      * See {recover}.
827      */
828     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
829         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
830     }
831 }
832 
833 // File: @openzeppelin/contracts/utils/Context.sol
834 
835 
836 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
837 
838 pragma solidity ^0.8.0;
839 
840 /**
841  * @dev Provides information about the current execution context, including the
842  * sender of the transaction and its data. While these are generally available
843  * via msg.sender and msg.data, they should not be accessed in such a direct
844  * manner, since when dealing with meta-transactions the account sending and
845  * paying for execution may not be the actual sender (as far as an application
846  * is concerned).
847  *
848  * This contract is only required for intermediate, library-like contracts.
849  */
850 abstract contract Context {
851     function _msgSender() internal view virtual returns (address) {
852         return msg.sender;
853     }
854 
855     function _msgData() internal view virtual returns (bytes calldata) {
856         return msg.data;
857     }
858 }
859 
860 // File: contracts/ERC721A.sol
861 
862 
863 // Creator: Chiru Labs
864 
865 pragma solidity ^0.8.4;
866 
867 
868 
869 
870 
871 
872 
873 
874 
875 error ApprovalCallerNotOwnerNorApproved();
876 error ApprovalQueryForNonexistentToken();
877 error ApproveToCaller();
878 error ApprovalToCurrentOwner();
879 error BalanceQueryForZeroAddress();
880 error MintToZeroAddress();
881 error MintZeroQuantity();
882 error OwnerQueryForNonexistentToken();
883 error TransferCallerNotOwnerNorApproved();
884 error TransferFromIncorrectOwner();
885 error TransferToNonERC721ReceiverImplementer();
886 error TransferToZeroAddress();
887 error URIQueryForNonexistentToken();
888 
889 /**
890  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
891  * the Metadata extension. Built to optimize for lower gas during batch mints.
892  *
893  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
894  *
895  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
896  *
897  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
898  */
899 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
900     using Address for address;
901     using Strings for uint256;
902 
903     // Compiler will pack this into a single 256bit word.
904     struct TokenOwnership {
905         // The address of the owner.
906         address addr;
907         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
908         uint64 startTimestamp;
909         // Whether the token has been burned.
910         bool burned;
911     }
912 
913     // Compiler will pack this into a single 256bit word.
914     struct AddressData {
915         // Realistically, 2**64-1 is more than enough.
916         uint64 balance;
917         // Keeps track of mint count with minimal overhead for tokenomics.
918         uint64 numberMinted;
919         // Keeps track of burn count with minimal overhead for tokenomics.
920         uint64 numberBurned;
921         // For miscellaneous variable(s) pertaining to the address
922         // (e.g. number of whitelist mint slots used).
923         // If there are multiple variables, please pack them into a uint64.
924         uint64 aux;
925     }
926 
927     // The tokenId of the next token to be minted.
928     uint256 internal _currentIndex;
929 
930     // The number of tokens burned.
931     uint256 internal _burnCounter;
932 
933     // Token name
934     string private _name;
935 
936     // Token symbol
937     string private _symbol;
938 
939     // Mapping from token ID to ownership details
940     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
941     mapping(uint256 => TokenOwnership) internal _ownerships;
942 
943     // Mapping owner address to address data
944     mapping(address => AddressData) private _addressData;
945 
946     // Mapping from token ID to approved address
947     mapping(uint256 => address) private _tokenApprovals;
948 
949     // Mapping from owner to operator approvals
950     mapping(address => mapping(address => bool)) private _operatorApprovals;
951 
952     constructor(string memory name_, string memory symbol_) {
953         _name = name_;
954         _symbol = symbol_;
955         _currentIndex = _startTokenId();
956     }
957 
958     /**
959      * To change the starting tokenId, please override this function.
960      */
961     function _startTokenId() internal view virtual returns (uint256) {
962         return 0;
963     }
964 
965     /**
966      * @dev See {IERC721Enumerable-totalSupply}.
967      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
968      */
969     function totalSupply() public view returns (uint256) {
970         // Counter underflow is impossible as _burnCounter cannot be incremented
971         // more than _currentIndex - _startTokenId() times
972         unchecked {
973             return _currentIndex - _burnCounter - _startTokenId();
974         }
975     }
976 
977     /**
978      * Returns the total amount of tokens minted in the contract.
979      */
980     function _totalMinted() internal view returns (uint256) {
981         // Counter underflow is impossible as _currentIndex does not decrement,
982         // and it is initialized to _startTokenId()
983         unchecked {
984             return _currentIndex - _startTokenId();
985         }
986     }
987 
988     /**
989      * @dev See {IERC165-supportsInterface}.
990      */
991     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
992         return
993             interfaceId == type(IERC721).interfaceId ||
994             interfaceId == type(IERC721Metadata).interfaceId ||
995             super.supportsInterface(interfaceId);
996     }
997 
998     /**
999      * @dev See {IERC721-balanceOf}.
1000      */
1001     function balanceOf(address owner) public view override returns (uint256) {
1002         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1003         return uint256(_addressData[owner].balance);
1004     }
1005 
1006     /**
1007      * Returns the number of tokens minted by `owner`.
1008      */
1009     function _numberMinted(address owner) internal view returns (uint256) {
1010         return uint256(_addressData[owner].numberMinted);
1011     }
1012 
1013     /**
1014      * Returns the number of tokens burned by or on behalf of `owner`.
1015      */
1016     function _numberBurned(address owner) internal view returns (uint256) {
1017         return uint256(_addressData[owner].numberBurned);
1018     }
1019 
1020     /**
1021      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1022      */
1023     function _getAux(address owner) internal view returns (uint64) {
1024         return _addressData[owner].aux;
1025     }
1026 
1027     /**
1028      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1029      * If there are multiple variables, please pack them into a uint64.
1030      */
1031     function _setAux(address owner, uint64 aux) internal {
1032         _addressData[owner].aux = aux;
1033     }
1034 
1035     /**
1036      * Gas spent here starts off proportional to the maximum mint batch size.
1037      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1038      */
1039     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1040         uint256 curr = tokenId;
1041 
1042         unchecked {
1043             if (_startTokenId() <= curr && curr < _currentIndex) {
1044                 TokenOwnership memory ownership = _ownerships[curr];
1045                 if (!ownership.burned) {
1046                     if (ownership.addr != address(0)) {
1047                         return ownership;
1048                     }
1049                     // Invariant:
1050                     // There will always be an ownership that has an address and is not burned
1051                     // before an ownership that does not have an address and is not burned.
1052                     // Hence, curr will not underflow.
1053                     while (true) {
1054                         curr--;
1055                         ownership = _ownerships[curr];
1056                         if (ownership.addr != address(0)) {
1057                             return ownership;
1058                         }
1059                     }
1060                 }
1061             }
1062         }
1063         revert OwnerQueryForNonexistentToken();
1064     }
1065 
1066     /**
1067      * @dev See {IERC721-ownerOf}.
1068      */
1069     function ownerOf(uint256 tokenId) public view override returns (address) {
1070         return _ownershipOf(tokenId).addr;
1071     }
1072 
1073     /**
1074      * @dev See {IERC721Metadata-name}.
1075      */
1076     function name() public view virtual override returns (string memory) {
1077         return _name;
1078     }
1079 
1080     /**
1081      * @dev See {IERC721Metadata-symbol}.
1082      */
1083     function symbol() public view virtual override returns (string memory) {
1084         return _symbol;
1085     }
1086 
1087     /**
1088      * @dev See {IERC721Metadata-tokenURI}.
1089      */
1090     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1091         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1092 
1093         string memory baseURI = _baseURI();
1094         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1095     }
1096 
1097     /**
1098      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1099      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1100      * by default, can be overriden in child contracts.
1101      */
1102     function _baseURI() internal view virtual returns (string memory) {
1103         return '';
1104     }
1105 
1106     /**
1107      * @dev See {IERC721-approve}.
1108      */
1109     function approve(address to, uint256 tokenId) public override {
1110         address owner = ERC721A.ownerOf(tokenId);
1111         if (to == owner) revert ApprovalToCurrentOwner();
1112 
1113         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1114             revert ApprovalCallerNotOwnerNorApproved();
1115         }
1116 
1117         _approve(to, tokenId, owner);
1118     }
1119 
1120     /**
1121      * @dev See {IERC721-getApproved}.
1122      */
1123     function getApproved(uint256 tokenId) public view override returns (address) {
1124         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1125 
1126         return _tokenApprovals[tokenId];
1127     }
1128 
1129     /**
1130      * @dev See {IERC721-setApprovalForAll}.
1131      */
1132     function setApprovalForAll(address operator, bool approved) public virtual override {
1133         if (operator == _msgSender()) revert ApproveToCaller();
1134 
1135         _operatorApprovals[_msgSender()][operator] = approved;
1136         emit ApprovalForAll(_msgSender(), operator, approved);
1137     }
1138 
1139     /**
1140      * @dev See {IERC721-isApprovedForAll}.
1141      */
1142     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1143         return _operatorApprovals[owner][operator];
1144     }
1145 
1146     /**
1147      * @dev See {IERC721-transferFrom}.
1148      */
1149     function transferFrom(
1150         address from,
1151         address to,
1152         uint256 tokenId
1153     ) public virtual override {
1154         _transfer(from, to, tokenId);
1155     }
1156 
1157     /**
1158      * @dev See {IERC721-safeTransferFrom}.
1159      */
1160     function safeTransferFrom(
1161         address from,
1162         address to,
1163         uint256 tokenId
1164     ) public virtual override {
1165         safeTransferFrom(from, to, tokenId, '');
1166     }
1167 
1168     /**
1169      * @dev See {IERC721-safeTransferFrom}.
1170      */
1171     function safeTransferFrom(
1172         address from,
1173         address to,
1174         uint256 tokenId,
1175         bytes memory _data
1176     ) public virtual override {
1177         _transfer(from, to, tokenId);
1178         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1179             revert TransferToNonERC721ReceiverImplementer();
1180         }
1181     }
1182 
1183     /**
1184      * @dev Returns whether `tokenId` exists.
1185      *
1186      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1187      *
1188      * Tokens start existing when they are minted (`_mint`),
1189      */
1190     function _exists(uint256 tokenId) internal view returns (bool) {
1191         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1192             !_ownerships[tokenId].burned;
1193     }
1194 
1195     function _safeMint(address to, uint256 quantity) internal {
1196         _safeMint(to, quantity, '');
1197     }
1198 
1199     /**
1200      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1201      *
1202      * Requirements:
1203      *
1204      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1205      * - `quantity` must be greater than 0.
1206      *
1207      * Emits a {Transfer} event.
1208      */
1209     function _safeMint(
1210         address to,
1211         uint256 quantity,
1212         bytes memory _data
1213     ) internal {
1214         _mint(to, quantity, _data, true);
1215     }
1216 
1217     /**
1218      * @dev Mints `quantity` tokens and transfers them to `to`.
1219      *
1220      * Requirements:
1221      *
1222      * - `to` cannot be the zero address.
1223      * - `quantity` must be greater than 0.
1224      *
1225      * Emits a {Transfer} event.
1226      */
1227     function _mint(
1228         address to,
1229         uint256 quantity,
1230         bytes memory _data,
1231         bool safe
1232     ) internal {
1233         uint256 startTokenId = _currentIndex;
1234         if (to == address(0)) revert MintToZeroAddress();
1235         if (quantity == 0) revert MintZeroQuantity();
1236 
1237         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1238 
1239         // Overflows are incredibly unrealistic.
1240         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1241         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1242         unchecked {
1243             _addressData[to].balance += uint64(quantity);
1244             _addressData[to].numberMinted += uint64(quantity);
1245 
1246             _ownerships[startTokenId].addr = to;
1247             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1248 
1249             uint256 updatedIndex = startTokenId;
1250             uint256 end = updatedIndex + quantity;
1251 
1252             if (safe && to.isContract()) {
1253                 do {
1254                     emit Transfer(address(0), to, updatedIndex);
1255                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1256                         revert TransferToNonERC721ReceiverImplementer();
1257                     }
1258                 } while (updatedIndex != end);
1259                 // Reentrancy protection
1260                 if (_currentIndex != startTokenId) revert();
1261             } else {
1262                 do {
1263                     emit Transfer(address(0), to, updatedIndex++);
1264                 } while (updatedIndex != end);
1265             }
1266             _currentIndex = updatedIndex;
1267         }
1268         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1269     }
1270 
1271     /**
1272      * @dev Transfers `tokenId` from `from` to `to`.
1273      *
1274      * Requirements:
1275      *
1276      * - `to` cannot be the zero address.
1277      * - `tokenId` token must be owned by `from`.
1278      *
1279      * Emits a {Transfer} event.
1280      */
1281     function _transfer(
1282         address from,
1283         address to,
1284         uint256 tokenId
1285     ) private {
1286         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1287 
1288         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1289 
1290         bool isApprovedOrOwner = (_msgSender() == from ||
1291             isApprovedForAll(from, _msgSender()) ||
1292             getApproved(tokenId) == _msgSender());
1293 
1294         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1295         if (to == address(0)) revert TransferToZeroAddress();
1296 
1297         _beforeTokenTransfers(from, to, tokenId, 1);
1298 
1299         // Clear approvals from the previous owner
1300         _approve(address(0), tokenId, from);
1301 
1302         // Underflow of the sender's balance is impossible because we check for
1303         // ownership above and the recipient's balance can't realistically overflow.
1304         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1305         unchecked {
1306             _addressData[from].balance -= 1;
1307             _addressData[to].balance += 1;
1308 
1309             TokenOwnership storage currSlot = _ownerships[tokenId];
1310             currSlot.addr = to;
1311             currSlot.startTimestamp = uint64(block.timestamp);
1312 
1313             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1314             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1315             uint256 nextTokenId = tokenId + 1;
1316             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1317             if (nextSlot.addr == address(0)) {
1318                 // This will suffice for checking _exists(nextTokenId),
1319                 // as a burned slot cannot contain the zero address.
1320                 if (nextTokenId != _currentIndex) {
1321                     nextSlot.addr = from;
1322                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1323                 }
1324             }
1325         }
1326 
1327         emit Transfer(from, to, tokenId);
1328         _afterTokenTransfers(from, to, tokenId, 1);
1329     }
1330 
1331     /**
1332      * @dev This is equivalent to _burn(tokenId, false)
1333      */
1334     function _burn(uint256 tokenId) internal virtual {
1335         _burn(tokenId, false);
1336     }
1337 
1338     /**
1339      * @dev Destroys `tokenId`.
1340      * The approval is cleared when the token is burned.
1341      *
1342      * Requirements:
1343      *
1344      * - `tokenId` must exist.
1345      *
1346      * Emits a {Transfer} event.
1347      */
1348     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1349         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1350 
1351         address from = prevOwnership.addr;
1352 
1353         if (approvalCheck) {
1354             bool isApprovedOrOwner = (_msgSender() == from ||
1355                 isApprovedForAll(from, _msgSender()) ||
1356                 getApproved(tokenId) == _msgSender());
1357 
1358             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1359         }
1360 
1361         _beforeTokenTransfers(from, address(0), tokenId, 1);
1362 
1363         // Clear approvals from the previous owner
1364         _approve(address(0), tokenId, from);
1365 
1366         // Underflow of the sender's balance is impossible because we check for
1367         // ownership above and the recipient's balance can't realistically overflow.
1368         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1369         unchecked {
1370             AddressData storage addressData = _addressData[from];
1371             addressData.balance -= 1;
1372             addressData.numberBurned += 1;
1373 
1374             // Keep track of who burned the token, and the timestamp of burning.
1375             TokenOwnership storage currSlot = _ownerships[tokenId];
1376             currSlot.addr = from;
1377             currSlot.startTimestamp = uint64(block.timestamp);
1378             currSlot.burned = true;
1379 
1380             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1381             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1382             uint256 nextTokenId = tokenId + 1;
1383             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1384             if (nextSlot.addr == address(0)) {
1385                 // This will suffice for checking _exists(nextTokenId),
1386                 // as a burned slot cannot contain the zero address.
1387                 if (nextTokenId != _currentIndex) {
1388                     nextSlot.addr = from;
1389                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1390                 }
1391             }
1392         }
1393 
1394         emit Transfer(from, address(0), tokenId);
1395         _afterTokenTransfers(from, address(0), tokenId, 1);
1396 
1397         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1398         unchecked {
1399             _burnCounter++;
1400         }
1401     }
1402 
1403     /**
1404      * @dev Approve `to` to operate on `tokenId`
1405      *
1406      * Emits a {Approval} event.
1407      */
1408     function _approve(
1409         address to,
1410         uint256 tokenId,
1411         address owner
1412     ) private {
1413         _tokenApprovals[tokenId] = to;
1414         emit Approval(owner, to, tokenId);
1415     }
1416 
1417     /**
1418      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1419      *
1420      * @param from address representing the previous owner of the given token ID
1421      * @param to target address that will receive the tokens
1422      * @param tokenId uint256 ID of the token to be transferred
1423      * @param _data bytes optional data to send along with the call
1424      * @return bool whether the call correctly returned the expected magic value
1425      */
1426     function _checkContractOnERC721Received(
1427         address from,
1428         address to,
1429         uint256 tokenId,
1430         bytes memory _data
1431     ) private returns (bool) {
1432         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1433             return retval == IERC721Receiver(to).onERC721Received.selector;
1434         } catch (bytes memory reason) {
1435             if (reason.length == 0) {
1436                 revert TransferToNonERC721ReceiverImplementer();
1437             } else {
1438                 assembly {
1439                     revert(add(32, reason), mload(reason))
1440                 }
1441             }
1442         }
1443     }
1444 
1445     /**
1446      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1447      * And also called before burning one token.
1448      *
1449      * startTokenId - the first token id to be transferred
1450      * quantity - the amount to be transferred
1451      *
1452      * Calling conditions:
1453      *
1454      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1455      * transferred to `to`.
1456      * - When `from` is zero, `tokenId` will be minted for `to`.
1457      * - When `to` is zero, `tokenId` will be burned by `from`.
1458      * - `from` and `to` are never both zero.
1459      */
1460     function _beforeTokenTransfers(
1461         address from,
1462         address to,
1463         uint256 startTokenId,
1464         uint256 quantity
1465     ) internal virtual {}
1466 
1467     /**
1468      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1469      * minting.
1470      * And also called after one token has been burned.
1471      *
1472      * startTokenId - the first token id to be transferred
1473      * quantity - the amount to be transferred
1474      *
1475      * Calling conditions:
1476      *
1477      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1478      * transferred to `to`.
1479      * - When `from` is zero, `tokenId` has been minted for `to`.
1480      * - When `to` is zero, `tokenId` has been burned by `from`.
1481      * - `from` and `to` are never both zero.
1482      */
1483     function _afterTokenTransfers(
1484         address from,
1485         address to,
1486         uint256 startTokenId,
1487         uint256 quantity
1488     ) internal virtual {}
1489 }
1490 // File: @openzeppelin/contracts/access/Ownable.sol
1491 
1492 
1493 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1494 
1495 pragma solidity ^0.8.0;
1496 
1497 
1498 /**
1499  * @dev Contract module which provides a basic access control mechanism, where
1500  * there is an account (an owner) that can be granted exclusive access to
1501  * specific functions.
1502  *
1503  * By default, the owner account will be the one that deploys the contract. This
1504  * can later be changed with {transferOwnership}.
1505  *
1506  * This module is used through inheritance. It will make available the modifier
1507  * `onlyOwner`, which can be applied to your functions to restrict their use to
1508  * the owner.
1509  */
1510 abstract contract Ownable is Context {
1511     address private _owner;
1512 
1513     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1514 
1515     /**
1516      * @dev Initializes the contract setting the deployer as the initial owner.
1517      */
1518     constructor() {
1519         _transferOwnership(_msgSender());
1520     }
1521 
1522     /**
1523      * @dev Returns the address of the current owner.
1524      */
1525     function owner() public view virtual returns (address) {
1526         return _owner;
1527     }
1528 
1529     /**
1530      * @dev Throws if called by any account other than the owner.
1531      */
1532     modifier onlyOwner() {
1533         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1534         _;
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
1568 // File: contracts/knightsoftheroundtable.sol
1569 
1570 
1571 pragma solidity ^0.8.9;
1572 
1573 
1574 
1575 
1576 /*
1577 __________                         .___ ___________     ___.   .__            ____  __.      .__       .__     __          
1578 \______   \ ____  __ __  ____    __| _/ \__    ___/____ \_ |__ |  |   ____   |    |/ _| ____ |__| ____ |  |___/  |_  ______
1579  |       _//  _ \|  |  \/    \  / __ |    |    |  \__  \ | __ \|  | _/ __ \  |      <  /    \|  |/ ___\|  |  \   __\/  ___/
1580  |    |   (  <_> )  |  /   |  \/ /_/ |    |    |   / __ \| \_\ \  |_\  ___/  |    |  \|   |  \  / /_/  >   Y  \  |  \___ \ 
1581  |____|_  /\____/|____/|___|  /\____ |    |____|  (____  /___  /____/\___  > |____|__ \___|  /__\___  /|___|  /__| /____  >
1582         \/                  \/      \/                 \/    \/          \/          \/    \/  /_____/      \/          \/                                                        
1583 
1584 */
1585 contract RoundTableKnights is ERC721A, Ownable {
1586     using ECDSA for bytes32;
1587     using Strings for uint256;
1588 
1589     address private constant TEAM_ADDRESS = 0x6Eb878d1b6cEe5Fb44F935250598F6080b7B9c33;
1590 
1591     uint256 public constant TOTAL_MAX_SUPPLY = 7777;
1592     uint256 public constant TOTAL_FREE_SUPPLY = 7777; 
1593     uint256 public constant MAX_FREE_MINT_PER_WALLET = 1;
1594     uint256 public constant MAX_PUBLIC_PER_TX = 10;
1595     uint256 public constant MAX_PUBLIC_MINT_PER_WALLET = 20;
1596 
1597     uint256 public constant TEAM_CLAIM_AMOUNT = 30;
1598     
1599 
1600     uint256 public token_price = 0.003 ether;
1601     bool public publicSaleActive;
1602     bool public freeMintActive;
1603     bool public claimed = false;
1604     uint256 public freeMintCount;
1605 
1606     mapping(address => uint256) public freeMintClaimed;
1607 
1608     string private _baseTokenURI;
1609 
1610 
1611     constructor() ERC721A("Round Table Knights", "RTK") {
1612         _safeMint(msg.sender, 10);
1613     }
1614 
1615     modifier callerIsUser() {
1616         require(tx.origin == msg.sender, "The caller is another contract");
1617         _;
1618     }
1619 
1620     modifier underMaxSupply(uint256 _quantity) {
1621         require(
1622             _totalMinted() + _quantity <= TOTAL_MAX_SUPPLY,
1623             "Purchase would exceed max supply"
1624         );
1625 
1626         _;
1627     }
1628 
1629     modifier validateFreeMintStatus() {
1630         require(freeMintActive, "free claim is not active");
1631         require(freeMintCount + 1 <= TOTAL_FREE_SUPPLY, "Purchase would exceed max supply of free mints");
1632         require(freeMintClaimed[msg.sender] == 0, "wallet has already free minted");
1633         
1634         _;
1635     }
1636 
1637     modifier validatePublicStatus(uint256 _quantity) {
1638         require(publicSaleActive, "public sale is not active");
1639         require(msg.value >= token_price * _quantity, "Need to send more ETH.");
1640         require(_quantity > 0 && _quantity <= MAX_PUBLIC_PER_TX, "Invalid mint amount.");
1641         require(
1642             _numberMinted(msg.sender) + _quantity <= MAX_PUBLIC_MINT_PER_WALLET,
1643             "This purchase would exceed maximum allocation for public mints for this wallet"
1644         );
1645 
1646         _;
1647     }
1648 
1649     function freeMint() 
1650         external 
1651         callerIsUser 
1652         validateFreeMintStatus
1653         underMaxSupply(1)
1654     {
1655         freeMintClaimed[msg.sender] = 1;
1656         freeMintCount++;
1657 
1658         _mint(msg.sender, 1, "", false);
1659     }
1660 
1661     function mint(uint256 _quantity)
1662         external
1663         payable
1664         callerIsUser
1665         validatePublicStatus(_quantity)
1666         underMaxSupply(_quantity)
1667     {
1668         _mint(msg.sender, _quantity, "", false);
1669     }
1670 
1671     function _baseURI() internal view virtual override returns (string memory) {
1672         return _baseTokenURI;
1673     }
1674 
1675     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1676         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1677 
1678         string memory baseURI = _baseURI();
1679         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : '';
1680     }
1681 
1682     function numberMinted(address owner) public view returns (uint256) {
1683         return _numberMinted(owner);
1684     }
1685 
1686     function ownerMint(uint256 _numberToMint)
1687         external
1688         onlyOwner
1689         underMaxSupply(_numberToMint)
1690     {
1691         _mint(msg.sender, _numberToMint, "", false);
1692     }
1693 
1694       function teamClaim() external onlyOwner {
1695         require(!claimed, "Team already claimed");
1696         // claim
1697         _safeMint(TEAM_ADDRESS, TEAM_CLAIM_AMOUNT);
1698         claimed = true;
1699   }
1700 
1701     function ownerMintToAddress(address _recipient, uint256 _numberToMint)
1702         external
1703         onlyOwner
1704         underMaxSupply(_numberToMint)
1705     {
1706         _mint(_recipient, _numberToMint, "", false);
1707     }
1708 
1709     function setFreeMintCount(uint256 _count) external onlyOwner {
1710         freeMintCount = _count;
1711     }
1712 
1713     function setTokenPrice(uint256 newPrice) external onlyOwner {
1714         require(newPrice >= 0, "Token price must be greater than zero");
1715         token_price = newPrice;
1716     }
1717 
1718     function setBaseURI(string calldata baseURI) external onlyOwner {
1719         _baseTokenURI = baseURI;
1720     }
1721 
1722     function withdrawFunds() external onlyOwner {
1723         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1724         require(success, "Transfer failed.");
1725     }
1726 
1727     function withdrawFundsToAddress(address _address, uint256 amount) external onlyOwner {
1728         (bool success, ) =_address.call{value: amount}("");
1729         require(success, "Transfer failed.");
1730     }
1731     
1732     function flipFreeMintActive() external onlyOwner {
1733         freeMintActive = !freeMintActive;
1734     }
1735 
1736     function flipPublicSaleActive() external onlyOwner {
1737         publicSaleActive = !publicSaleActive;
1738     }
1739 
1740 }