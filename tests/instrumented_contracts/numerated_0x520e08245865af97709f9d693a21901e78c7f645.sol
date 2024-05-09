1 // SPDX-License-Identifier: MIT
2 /*
3   _  __          _____ ____________ _   _ 
4  | |/ /    /\   |_   _|___  /  ____| \ | |
5  | ' /    /  \    | |    / /| |__  |  \| |
6  |  <    / /\ \   | |   / / |  __| | . ` |
7  | . \  / ____ \ _| |_ / /__| |____| |\  |
8  |_|\_\/_/    \_\_____/_____|______|_| \_|
9 
10            By Devko.dev#7286
11 */
12 // File: @openzeppelin/contracts/utils/Address.sol
13 
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
240 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
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
257      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
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
329 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
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
368      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
369      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
370      *
371      * Requirements:
372      *
373      * - `from` cannot be the zero address.
374      * - `to` cannot be the zero address.
375      * - `tokenId` token must exist and be owned by `from`.
376      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
377      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
378      *
379      * Emits a {Transfer} event.
380      */
381     function safeTransferFrom(
382         address from,
383         address to,
384         uint256 tokenId
385     ) external;
386 
387     /**
388      * @dev Transfers `tokenId` token from `from` to `to`.
389      *
390      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
391      *
392      * Requirements:
393      *
394      * - `from` cannot be the zero address.
395      * - `to` cannot be the zero address.
396      * - `tokenId` token must be owned by `from`.
397      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
398      *
399      * Emits a {Transfer} event.
400      */
401     function transferFrom(
402         address from,
403         address to,
404         uint256 tokenId
405     ) external;
406 
407     /**
408      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
409      * The approval is cleared when the token is transferred.
410      *
411      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
412      *
413      * Requirements:
414      *
415      * - The caller must own the token or be an approved operator.
416      * - `tokenId` must exist.
417      *
418      * Emits an {Approval} event.
419      */
420     function approve(address to, uint256 tokenId) external;
421 
422     /**
423      * @dev Returns the account approved for `tokenId` token.
424      *
425      * Requirements:
426      *
427      * - `tokenId` must exist.
428      */
429     function getApproved(uint256 tokenId) external view returns (address operator);
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
444      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
445      *
446      * See {setApprovalForAll}
447      */
448     function isApprovedForAll(address owner, address operator) external view returns (bool);
449 
450     /**
451      * @dev Safely transfers `tokenId` token from `from` to `to`.
452      *
453      * Requirements:
454      *
455      * - `from` cannot be the zero address.
456      * - `to` cannot be the zero address.
457      * - `tokenId` token must exist and be owned by `from`.
458      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
459      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
460      *
461      * Emits a {Transfer} event.
462      */
463     function safeTransferFrom(
464         address from,
465         address to,
466         uint256 tokenId,
467         bytes calldata data
468     ) external;
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
860 // File: erc721a/contracts/ERC721A.sol
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
880 error MintedQueryForZeroAddress();
881 error BurnedQueryForZeroAddress();
882 error AuxQueryForZeroAddress();
883 error MintToZeroAddress();
884 error MintZeroQuantity();
885 error OwnerIndexOutOfBounds();
886 error OwnerQueryForNonexistentToken();
887 error TokenIndexOutOfBounds();
888 error TransferCallerNotOwnerNorApproved();
889 error TransferFromIncorrectOwner();
890 error TransferToNonERC721ReceiverImplementer();
891 error TransferToZeroAddress();
892 error URIQueryForNonexistentToken();
893 
894 /**
895  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
896  * the Metadata extension. Built to optimize for lower gas during batch mints.
897  *
898  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
899  *
900  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
901  *
902  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
903  */
904 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
905     using Address for address;
906     using Strings for uint256;
907 
908     // Compiler will pack this into a single 256bit word.
909     struct TokenOwnership {
910         // The address of the owner.
911         address addr;
912         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
913         uint64 startTimestamp;
914         // Whether the token has been burned.
915         bool burned;
916     }
917 
918     // Compiler will pack this into a single 256bit word.
919     struct AddressData {
920         // Realistically, 2**64-1 is more than enough.
921         uint64 balance;
922         // Keeps track of mint count with minimal overhead for tokenomics.
923         uint64 numberMinted;
924         // Keeps track of burn count with minimal overhead for tokenomics.
925         uint64 numberBurned;
926         // For miscellaneous variable(s) pertaining to the address
927         // (e.g. number of whitelist mint slots used).
928         // If there are multiple variables, please pack them into a uint64.
929         uint64 aux;
930     }
931 
932     // The tokenId of the next token to be minted.
933     uint256 internal _currentIndex;
934 
935     // The number of tokens burned.
936     uint256 internal _burnCounter;
937 
938     // Token name
939     string private _name;
940 
941     // Token symbol
942     string private _symbol;
943 
944     // Mapping from token ID to ownership details
945     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
946     mapping(uint256 => TokenOwnership) internal _ownerships;
947 
948     // Mapping owner address to address data
949     mapping(address => AddressData) private _addressData;
950 
951     // Mapping from token ID to approved address
952     mapping(uint256 => address) private _tokenApprovals;
953 
954     // Mapping from owner to operator approvals
955     mapping(address => mapping(address => bool)) private _operatorApprovals;
956 
957     constructor(string memory name_, string memory symbol_) {
958         _name = name_;
959         _symbol = symbol_;
960         _currentIndex = _startTokenId();
961     }
962 
963     /**
964      * To change the starting tokenId, please override this function.
965      */
966     function _startTokenId() internal view virtual returns (uint256) {
967         return 0;
968     }
969 
970     /**
971      * @dev See {IERC721Enumerable-totalSupply}.
972      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
973      */
974     function totalSupply() public view returns (uint256) {
975         // Counter underflow is impossible as _burnCounter cannot be incremented
976         // more than _currentIndex - _startTokenId() times
977         unchecked {
978             return _currentIndex - _burnCounter - _startTokenId();
979         }
980     }
981 
982     /**
983      * Returns the total amount of tokens minted in the contract.
984      */
985     function _totalMinted() internal view returns (uint256) {
986         // Counter underflow is impossible as _currentIndex does not decrement,
987         // and it is initialized to _startTokenId()
988         unchecked {
989             return _currentIndex - _startTokenId();
990         }
991     }
992 
993     /**
994      * @dev See {IERC165-supportsInterface}.
995      */
996     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
997         return
998             interfaceId == type(IERC721).interfaceId ||
999             interfaceId == type(IERC721Metadata).interfaceId ||
1000             super.supportsInterface(interfaceId);
1001     }
1002 
1003     /**
1004      * @dev See {IERC721-balanceOf}.
1005      */
1006     function balanceOf(address owner) public view override returns (uint256) {
1007         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1008         return uint256(_addressData[owner].balance);
1009     }
1010 
1011     /**
1012      * Returns the number of tokens minted by `owner`.
1013      */
1014     function _numberMinted(address owner) internal view returns (uint256) {
1015         if (owner == address(0)) revert MintedQueryForZeroAddress();
1016         return uint256(_addressData[owner].numberMinted);
1017     }
1018 
1019     /**
1020      * Returns the number of tokens burned by or on behalf of `owner`.
1021      */
1022     function _numberBurned(address owner) internal view returns (uint256) {
1023         if (owner == address(0)) revert BurnedQueryForZeroAddress();
1024         return uint256(_addressData[owner].numberBurned);
1025     }
1026 
1027     /**
1028      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1029      */
1030     function _getAux(address owner) internal view returns (uint64) {
1031         if (owner == address(0)) revert AuxQueryForZeroAddress();
1032         return _addressData[owner].aux;
1033     }
1034 
1035     /**
1036      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1037      * If there are multiple variables, please pack them into a uint64.
1038      */
1039     function _setAux(address owner, uint64 aux) internal {
1040         if (owner == address(0)) revert AuxQueryForZeroAddress();
1041         _addressData[owner].aux = aux;
1042     }
1043 
1044     /**
1045      * Gas spent here starts off proportional to the maximum mint batch size.
1046      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1047      */
1048     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1049         uint256 curr = tokenId;
1050 
1051         unchecked {
1052             if (_startTokenId() <= curr && curr < _currentIndex) {
1053                 TokenOwnership memory ownership = _ownerships[curr];
1054                 if (!ownership.burned) {
1055                     if (ownership.addr != address(0)) {
1056                         return ownership;
1057                     }
1058                     // Invariant:
1059                     // There will always be an ownership that has an address and is not burned
1060                     // before an ownership that does not have an address and is not burned.
1061                     // Hence, curr will not underflow.
1062                     while (true) {
1063                         curr--;
1064                         ownership = _ownerships[curr];
1065                         if (ownership.addr != address(0)) {
1066                             return ownership;
1067                         }
1068                     }
1069                 }
1070             }
1071         }
1072         revert OwnerQueryForNonexistentToken();
1073     }
1074 
1075     /**
1076      * @dev See {IERC721-ownerOf}.
1077      */
1078     function ownerOf(uint256 tokenId) public view override returns (address) {
1079         return ownershipOf(tokenId).addr;
1080     }
1081 
1082     /**
1083      * @dev See {IERC721Metadata-name}.
1084      */
1085     function name() public view virtual override returns (string memory) {
1086         return _name;
1087     }
1088 
1089     /**
1090      * @dev See {IERC721Metadata-symbol}.
1091      */
1092     function symbol() public view virtual override returns (string memory) {
1093         return _symbol;
1094     }
1095 
1096     /**
1097      * @dev See {IERC721Metadata-tokenURI}.
1098      */
1099     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1100         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1101 
1102         string memory baseURI = _baseURI();
1103         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1104     }
1105 
1106     /**
1107      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1108      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1109      * by default, can be overriden in child contracts.
1110      */
1111     function _baseURI() internal view virtual returns (string memory) {
1112         return '';
1113     }
1114 
1115     /**
1116      * @dev See {IERC721-approve}.
1117      */
1118     function approve(address to, uint256 tokenId) public override {
1119         address owner = ERC721A.ownerOf(tokenId);
1120         if (to == owner) revert ApprovalToCurrentOwner();
1121 
1122         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1123             revert ApprovalCallerNotOwnerNorApproved();
1124         }
1125 
1126         _approve(to, tokenId, owner);
1127     }
1128 
1129     /**
1130      * @dev See {IERC721-getApproved}.
1131      */
1132     function getApproved(uint256 tokenId) public view override returns (address) {
1133         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1134 
1135         return _tokenApprovals[tokenId];
1136     }
1137 
1138     /**
1139      * @dev See {IERC721-setApprovalForAll}.
1140      */
1141     function setApprovalForAll(address operator, bool approved) public override {
1142         if (operator == _msgSender()) revert ApproveToCaller();
1143 
1144         _operatorApprovals[_msgSender()][operator] = approved;
1145         emit ApprovalForAll(_msgSender(), operator, approved);
1146     }
1147 
1148     /**
1149      * @dev See {IERC721-isApprovedForAll}.
1150      */
1151     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1152         return _operatorApprovals[owner][operator];
1153     }
1154 
1155     /**
1156      * @dev See {IERC721-transferFrom}.
1157      */
1158     function transferFrom(
1159         address from,
1160         address to,
1161         uint256 tokenId
1162     ) public virtual override {
1163         _transfer(from, to, tokenId);
1164     }
1165 
1166     /**
1167      * @dev See {IERC721-safeTransferFrom}.
1168      */
1169     function safeTransferFrom(
1170         address from,
1171         address to,
1172         uint256 tokenId
1173     ) public virtual override {
1174         safeTransferFrom(from, to, tokenId, '');
1175     }
1176 
1177     /**
1178      * @dev See {IERC721-safeTransferFrom}.
1179      */
1180     function safeTransferFrom(
1181         address from,
1182         address to,
1183         uint256 tokenId,
1184         bytes memory _data
1185     ) public virtual override {
1186         _transfer(from, to, tokenId);
1187         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1188             revert TransferToNonERC721ReceiverImplementer();
1189         }
1190     }
1191 
1192     /**
1193      * @dev Returns whether `tokenId` exists.
1194      *
1195      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1196      *
1197      * Tokens start existing when they are minted (`_mint`),
1198      */
1199     function _exists(uint256 tokenId) internal view returns (bool) {
1200         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1201             !_ownerships[tokenId].burned;
1202     }
1203 
1204     function _safeMint(address to, uint256 quantity) internal {
1205         _safeMint(to, quantity, '');
1206     }
1207 
1208     /**
1209      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1210      *
1211      * Requirements:
1212      *
1213      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1214      * - `quantity` must be greater than 0.
1215      *
1216      * Emits a {Transfer} event.
1217      */
1218     function _safeMint(
1219         address to,
1220         uint256 quantity,
1221         bytes memory _data
1222     ) internal {
1223         _mint(to, quantity, _data, true);
1224     }
1225 
1226     /**
1227      * @dev Mints `quantity` tokens and transfers them to `to`.
1228      *
1229      * Requirements:
1230      *
1231      * - `to` cannot be the zero address.
1232      * - `quantity` must be greater than 0.
1233      *
1234      * Emits a {Transfer} event.
1235      */
1236     function _mint(
1237         address to,
1238         uint256 quantity,
1239         bytes memory _data,
1240         bool safe
1241     ) internal {
1242         uint256 startTokenId = _currentIndex;
1243         if (to == address(0)) revert MintToZeroAddress();
1244         if (quantity == 0) revert MintZeroQuantity();
1245 
1246         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1247 
1248         // Overflows are incredibly unrealistic.
1249         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1250         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1251         unchecked {
1252             _addressData[to].balance += uint64(quantity);
1253             _addressData[to].numberMinted += uint64(quantity);
1254 
1255             _ownerships[startTokenId].addr = to;
1256             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1257 
1258             uint256 updatedIndex = startTokenId;
1259             uint256 end = updatedIndex + quantity;
1260 
1261             if (safe && to.isContract()) {
1262                 do {
1263                     emit Transfer(address(0), to, updatedIndex);
1264                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1265                         revert TransferToNonERC721ReceiverImplementer();
1266                     }
1267                 } while (updatedIndex != end);
1268                 // Reentrancy protection
1269                 if (_currentIndex != startTokenId) revert();
1270             } else {
1271                 do {
1272                     emit Transfer(address(0), to, updatedIndex++);
1273                 } while (updatedIndex != end);
1274             }
1275             _currentIndex = updatedIndex;
1276         }
1277         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1278     }
1279 
1280     /**
1281      * @dev Transfers `tokenId` from `from` to `to`.
1282      *
1283      * Requirements:
1284      *
1285      * - `to` cannot be the zero address.
1286      * - `tokenId` token must be owned by `from`.
1287      *
1288      * Emits a {Transfer} event.
1289      */
1290     function _transfer(
1291         address from,
1292         address to,
1293         uint256 tokenId
1294     ) private {
1295         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1296 
1297         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1298             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1299             getApproved(tokenId) == _msgSender());
1300 
1301         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1302         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1303         if (to == address(0)) revert TransferToZeroAddress();
1304 
1305         _beforeTokenTransfers(from, to, tokenId, 1);
1306 
1307         // Clear approvals from the previous owner
1308         _approve(address(0), tokenId, prevOwnership.addr);
1309 
1310         // Underflow of the sender's balance is impossible because we check for
1311         // ownership above and the recipient's balance can't realistically overflow.
1312         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1313         unchecked {
1314             _addressData[from].balance -= 1;
1315             _addressData[to].balance += 1;
1316 
1317             _ownerships[tokenId].addr = to;
1318             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1319 
1320             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1321             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1322             uint256 nextTokenId = tokenId + 1;
1323             if (_ownerships[nextTokenId].addr == address(0)) {
1324                 // This will suffice for checking _exists(nextTokenId),
1325                 // as a burned slot cannot contain the zero address.
1326                 if (nextTokenId < _currentIndex) {
1327                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1328                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1329                 }
1330             }
1331         }
1332 
1333         emit Transfer(from, to, tokenId);
1334         _afterTokenTransfers(from, to, tokenId, 1);
1335     }
1336 
1337     /**
1338      * @dev Destroys `tokenId`.
1339      * The approval is cleared when the token is burned.
1340      *
1341      * Requirements:
1342      *
1343      * - `tokenId` must exist.
1344      *
1345      * Emits a {Transfer} event.
1346      */
1347     function _burn(uint256 tokenId) internal virtual {
1348         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1349 
1350         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1351 
1352         // Clear approvals from the previous owner
1353         _approve(address(0), tokenId, prevOwnership.addr);
1354 
1355         // Underflow of the sender's balance is impossible because we check for
1356         // ownership above and the recipient's balance can't realistically overflow.
1357         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1358         unchecked {
1359             _addressData[prevOwnership.addr].balance -= 1;
1360             _addressData[prevOwnership.addr].numberBurned += 1;
1361 
1362             // Keep track of who burned the token, and the timestamp of burning.
1363             _ownerships[tokenId].addr = prevOwnership.addr;
1364             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1365             _ownerships[tokenId].burned = true;
1366 
1367             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1368             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1369             uint256 nextTokenId = tokenId + 1;
1370             if (_ownerships[nextTokenId].addr == address(0)) {
1371                 // This will suffice for checking _exists(nextTokenId),
1372                 // as a burned slot cannot contain the zero address.
1373                 if (nextTokenId < _currentIndex) {
1374                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1375                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1376                 }
1377             }
1378         }
1379 
1380         emit Transfer(prevOwnership.addr, address(0), tokenId);
1381         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1382 
1383         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1384         unchecked {
1385             _burnCounter++;
1386         }
1387     }
1388 
1389     /**
1390      * @dev Approve `to` to operate on `tokenId`
1391      *
1392      * Emits a {Approval} event.
1393      */
1394     function _approve(
1395         address to,
1396         uint256 tokenId,
1397         address owner
1398     ) private {
1399         _tokenApprovals[tokenId] = to;
1400         emit Approval(owner, to, tokenId);
1401     }
1402 
1403     /**
1404      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1405      *
1406      * @param from address representing the previous owner of the given token ID
1407      * @param to target address that will receive the tokens
1408      * @param tokenId uint256 ID of the token to be transferred
1409      * @param _data bytes optional data to send along with the call
1410      * @return bool whether the call correctly returned the expected magic value
1411      */
1412     function _checkContractOnERC721Received(
1413         address from,
1414         address to,
1415         uint256 tokenId,
1416         bytes memory _data
1417     ) private returns (bool) {
1418         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1419             return retval == IERC721Receiver(to).onERC721Received.selector;
1420         } catch (bytes memory reason) {
1421             if (reason.length == 0) {
1422                 revert TransferToNonERC721ReceiverImplementer();
1423             } else {
1424                 assembly {
1425                     revert(add(32, reason), mload(reason))
1426                 }
1427             }
1428         }
1429     }
1430 
1431     /**
1432      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1433      * And also called before burning one token.
1434      *
1435      * startTokenId - the first token id to be transferred
1436      * quantity - the amount to be transferred
1437      *
1438      * Calling conditions:
1439      *
1440      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1441      * transferred to `to`.
1442      * - When `from` is zero, `tokenId` will be minted for `to`.
1443      * - When `to` is zero, `tokenId` will be burned by `from`.
1444      * - `from` and `to` are never both zero.
1445      */
1446     function _beforeTokenTransfers(
1447         address from,
1448         address to,
1449         uint256 startTokenId,
1450         uint256 quantity
1451     ) internal virtual {}
1452 
1453     /**
1454      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1455      * minting.
1456      * And also called after one token has been burned.
1457      *
1458      * startTokenId - the first token id to be transferred
1459      * quantity - the amount to be transferred
1460      *
1461      * Calling conditions:
1462      *
1463      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1464      * transferred to `to`.
1465      * - When `from` is zero, `tokenId` has been minted for `to`.
1466      * - When `to` is zero, `tokenId` has been burned by `from`.
1467      * - `from` and `to` are never both zero.
1468      */
1469     function _afterTokenTransfers(
1470         address from,
1471         address to,
1472         uint256 startTokenId,
1473         uint256 quantity
1474     ) internal virtual {}
1475 }
1476 
1477 // File: @openzeppelin/contracts/access/Ownable.sol
1478 
1479 
1480 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1481 
1482 pragma solidity ^0.8.0;
1483 
1484 
1485 /**
1486  * @dev Contract module which provides a basic access control mechanism, where
1487  * there is an account (an owner) that can be granted exclusive access to
1488  * specific functions.
1489  *
1490  * By default, the owner account will be the one that deploys the contract. This
1491  * can later be changed with {transferOwnership}.
1492  *
1493  * This module is used through inheritance. It will make available the modifier
1494  * `onlyOwner`, which can be applied to your functions to restrict their use to
1495  * the owner.
1496  */
1497 abstract contract Ownable is Context {
1498     address private _owner;
1499 
1500     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1501 
1502     /**
1503      * @dev Initializes the contract setting the deployer as the initial owner.
1504      */
1505     constructor() {
1506         _transferOwnership(_msgSender());
1507     }
1508 
1509     /**
1510      * @dev Returns the address of the current owner.
1511      */
1512     function owner() public view virtual returns (address) {
1513         return _owner;
1514     }
1515 
1516     /**
1517      * @dev Throws if called by any account other than the owner.
1518      */
1519     modifier onlyOwner() {
1520         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1521         _;
1522     }
1523 
1524     /**
1525      * @dev Leaves the contract without owner. It will not be possible to call
1526      * `onlyOwner` functions anymore. Can only be called by the current owner.
1527      *
1528      * NOTE: Renouncing ownership will leave the contract without an owner,
1529      * thereby removing any functionality that is only available to the owner.
1530      */
1531     function renounceOwnership() public virtual onlyOwner {
1532         _transferOwnership(address(0));
1533     }
1534 
1535     /**
1536      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1537      * Can only be called by the current owner.
1538      */
1539     function transferOwnership(address newOwner) public virtual onlyOwner {
1540         require(newOwner != address(0), "Ownable: new owner is the zero address");
1541         _transferOwnership(newOwner);
1542     }
1543 
1544     /**
1545      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1546      * Internal function without access restriction.
1547      */
1548     function _transferOwnership(address newOwner) internal virtual {
1549         address oldOwner = _owner;
1550         _owner = newOwner;
1551         emit OwnershipTransferred(oldOwner, newOwner);
1552     }
1553 }
1554 
1555 // File: contract.sol
1556 
1557 
1558 pragma solidity ^0.8.4;
1559 
1560 
1561 
1562 
1563 contract Kaizen is Ownable, ERC721A {
1564     string private _tokenBaseURI = "https://api.kaizen-nft.com/api/token/";
1565     uint256 public KAI_MAX_CLAIM = 2000;
1566     uint256 public KAI_MAX_TEAM = 222;
1567     uint256 public claimTokensMinted;
1568     uint256 public teamTokensMinted;
1569     bool public publicLive;
1570     bool public privateLive;
1571     address private PRIVATE_SIGNER = 0x9cf3870d4FCeE7B7B740A5d2782cb266eabD23aC;
1572     string private constant SIG_WORD = "KAIZEN_PRIVATE";
1573     mapping(address => uint256) public PRIVATE_MINT_LIST;
1574     
1575     using Strings for uint256;
1576     using ECDSA for bytes32;
1577 
1578     constructor() ERC721A("Kaizen", "KAI") {}
1579 
1580     modifier callerIsUser() {
1581         require(tx.origin == msg.sender, "The caller is another contract");
1582         _;
1583     }
1584 
1585     function matchAddresSigner(bytes memory signature, uint256 allowedQuantity) private view returns (bool) {
1586         bytes32 hash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", keccak256(abi.encodePacked(msg.sender, SIG_WORD, allowedQuantity))));
1587         return PRIVATE_SIGNER == hash.recover(signature);
1588     }
1589 
1590     function gift(address[] calldata receivers) external onlyOwner {
1591         require(teamTokensMinted + receivers.length <= KAI_MAX_TEAM, "EXCEED_TEAM_MAX");
1592         teamTokensMinted = teamTokensMinted + receivers.length;
1593         for (uint256 i = 0; i < receivers.length; i++) {
1594             _safeMint(receivers[i], 1);
1595         }
1596     }
1597 
1598     function founderMint(uint256 tokenQuantity) external onlyOwner {
1599         require(teamTokensMinted + tokenQuantity <= KAI_MAX_TEAM, "EXCEED_TEAM_MAX");
1600         teamTokensMinted = teamTokensMinted + tokenQuantity;
1601         _safeMint(msg.sender, tokenQuantity);
1602     }
1603 
1604     function mint() external callerIsUser {
1605         require(publicLive, "MINT_CLOSED");
1606         require(claimTokensMinted + 1 <= KAI_MAX_CLAIM, "EXCEED_MAX");
1607         claimTokensMinted++;
1608         _safeMint(msg.sender, 1);
1609     }
1610 
1611     function privateMint(bytes memory signature, uint256 tokenQuantity, uint256 allowedQuantity) external callerIsUser {
1612         require(privateLive, "MINT_CLOSED");
1613         require(matchAddresSigner(signature, allowedQuantity), "DIRECT_MINT_DISALLOWED");
1614         require(PRIVATE_MINT_LIST[msg.sender] + tokenQuantity <= allowedQuantity, "EXCEED_ALLOWED");
1615         require(claimTokensMinted + tokenQuantity <= KAI_MAX_CLAIM, "EXCEED_MAX");
1616         PRIVATE_MINT_LIST[msg.sender] = PRIVATE_MINT_LIST[msg.sender] + tokenQuantity;
1617         claimTokensMinted = claimTokensMinted + tokenQuantity;
1618         _safeMint(msg.sender, tokenQuantity);
1619     }
1620 
1621     function togglePublicMintStatus() external onlyOwner {
1622         publicLive = !publicLive;
1623     }
1624 
1625     function togglePrivateStatus() external onlyOwner {
1626         privateLive = !privateLive;
1627     }
1628 
1629     function setTeamReserve(uint256 newCount) external onlyOwner {
1630         KAI_MAX_TEAM = newCount;
1631     }
1632     
1633     function setClaim(uint256 newCount) external onlyOwner {
1634         KAI_MAX_CLAIM = newCount;
1635     }
1636 
1637     function _baseURI() internal view virtual override returns (string memory) {
1638         return _tokenBaseURI;
1639     }
1640 
1641     function setBaseURI(string calldata baseURI) external onlyOwner {
1642         _tokenBaseURI = baseURI;
1643     }
1644 
1645     function tokenURI(uint256 tokenId) public view override(ERC721A) returns (string memory) {
1646         require(_exists(tokenId), "Cannot query non-existent token");
1647         return string(abi.encodePacked(_tokenBaseURI, tokenId.toString()));
1648     }
1649 
1650     function _startTokenId() internal view virtual override returns (uint256) {
1651         return 1;
1652     }
1653 }