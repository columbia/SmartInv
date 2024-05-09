1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/Address.sol
4 
5 
6 /*
7 
8 __________.__              .__     __      ______________________________    _________
9 \______   \__|__  ___ ____ |  |   /  \    /  \____    /\______   \______ \  /   _____/
10  |     ___/  \  \/  // __ \|  |   \   \/\/   / /     /  |       _/|    |  \ \_____  \ 
11  |    |   |  |>    <\  ___/|  |__  \        / /     /_  |    |   \|    `   \/        \
12  |____|   |__/__/\_ \\___  >____/   \__/\  / /_______ \ |____|_  /_______  /_______  /
13                    \/    \/              \/          \/        \/        \/        \/ 
14 
15 */
16 
17 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
18 
19 pragma solidity ^0.8.1;
20 
21 /**
22  * @dev Collection of functions related to the address type
23  */
24 library Address {
25     /**
26      * @dev Returns true if `account` is a contract.
27      *
28      * [IMPORTANT]
29      * ====
30      * It is unsafe to assume that an address for which this function returns
31      * false is an externally-owned account (EOA) and not a contract.
32      *
33      * Among others, `isContract` will return false for the following
34      * types of addresses:
35      *
36      *  - an externally-owned account
37      *  - a contract in construction
38      *  - an address where a contract will be created
39      *  - an address where a contract lived, but was destroyed
40      * ====
41      *
42      * [IMPORTANT]
43      * ====
44      * You shouldn't rely on `isContract` to protect against flash loan attacks!
45      *
46      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
47      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
48      * constructor.
49      * ====
50      */
51     function isContract(address account) internal view returns (bool) {
52         // This method relies on extcodesize/address.code.length, which returns 0
53         // for contracts in construction, since the code is only stored at the end
54         // of the constructor execution.
55 
56         return account.code.length > 0;
57     }
58 
59     /**
60      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
61      * `recipient`, forwarding all available gas and reverting on errors.
62      *
63      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
64      * of certain opcodes, possibly making contracts go over the 2300 gas limit
65      * imposed by `transfer`, making them unable to receive funds via
66      * `transfer`. {sendValue} removes this limitation.
67      *
68      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
69      *
70      * IMPORTANT: because control is transferred to `recipient`, care must be
71      * taken to not create reentrancy vulnerabilities. Consider using
72      * {ReentrancyGuard} or the
73      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
74      */
75     function sendValue(address payable recipient, uint256 amount) internal {
76         require(address(this).balance >= amount, "Address: insufficient balance");
77 
78         (bool success, ) = recipient.call{value: amount}("");
79         require(success, "Address: unable to send value, recipient may have reverted");
80     }
81 
82     /**
83      * @dev Performs a Solidity function call using a low level `call`. A
84      * plain `call` is an unsafe replacement for a function call: use this
85      * function instead.
86      *
87      * If `target` reverts with a revert reason, it is bubbled up by this
88      * function (like regular Solidity function calls).
89      *
90      * Returns the raw returned data. To convert to the expected return value,
91      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
92      *
93      * Requirements:
94      *
95      * - `target` must be a contract.
96      * - calling `target` with `data` must not revert.
97      *
98      * _Available since v3.1._
99      */
100     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
101         return functionCall(target, data, "Address: low-level call failed");
102     }
103 
104     /**
105      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
106      * `errorMessage` as a fallback revert reason when `target` reverts.
107      *
108      * _Available since v3.1._
109      */
110     function functionCall(
111         address target,
112         bytes memory data,
113         string memory errorMessage
114     ) internal returns (bytes memory) {
115         return functionCallWithValue(target, data, 0, errorMessage);
116     }
117 
118     /**
119      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
120      * but also transferring `value` wei to `target`.
121      *
122      * Requirements:
123      *
124      * - the calling contract must have an ETH balance of at least `value`.
125      * - the called Solidity function must be `payable`.
126      *
127      * _Available since v3.1._
128      */
129     function functionCallWithValue(
130         address target,
131         bytes memory data,
132         uint256 value
133     ) internal returns (bytes memory) {
134         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
135     }
136 
137     /**
138      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
139      * with `errorMessage` as a fallback revert reason when `target` reverts.
140      *
141      * _Available since v3.1._
142      */
143     function functionCallWithValue(
144         address target,
145         bytes memory data,
146         uint256 value,
147         string memory errorMessage
148     ) internal returns (bytes memory) {
149         require(address(this).balance >= value, "Address: insufficient balance for call");
150         require(isContract(target), "Address: call to non-contract");
151 
152         (bool success, bytes memory returndata) = target.call{value: value}(data);
153         return verifyCallResult(success, returndata, errorMessage);
154     }
155 
156     /**
157      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
158      * but performing a static call.
159      *
160      * _Available since v3.3._
161      */
162     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
163         return functionStaticCall(target, data, "Address: low-level static call failed");
164     }
165 
166     /**
167      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
168      * but performing a static call.
169      *
170      * _Available since v3.3._
171      */
172     function functionStaticCall(
173         address target,
174         bytes memory data,
175         string memory errorMessage
176     ) internal view returns (bytes memory) {
177         require(isContract(target), "Address: static call to non-contract");
178 
179         (bool success, bytes memory returndata) = target.staticcall(data);
180         return verifyCallResult(success, returndata, errorMessage);
181     }
182 
183     /**
184      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
185      * but performing a delegate call.
186      *
187      * _Available since v3.4._
188      */
189     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
190         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
191     }
192 
193     /**
194      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
195      * but performing a delegate call.
196      *
197      * _Available since v3.4._
198      */
199     function functionDelegateCall(
200         address target,
201         bytes memory data,
202         string memory errorMessage
203     ) internal returns (bytes memory) {
204         require(isContract(target), "Address: delegate call to non-contract");
205 
206         (bool success, bytes memory returndata) = target.delegatecall(data);
207         return verifyCallResult(success, returndata, errorMessage);
208     }
209 
210     /**
211      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
212      * revert reason using the provided one.
213      *
214      * _Available since v4.3._
215      */
216     function verifyCallResult(
217         bool success,
218         bytes memory returndata,
219         string memory errorMessage
220     ) internal pure returns (bytes memory) {
221         if (success) {
222             return returndata;
223         } else {
224             // Look for revert reason and bubble it up if present
225             if (returndata.length > 0) {
226                 // The easiest way to bubble the revert reason is using memory via assembly
227 
228                 assembly {
229                     let returndata_size := mload(returndata)
230                     revert(add(32, returndata), returndata_size)
231                 }
232             } else {
233                 revert(errorMessage);
234             }
235         }
236     }
237 }
238 
239 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
240 
241 
242 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
243 
244 pragma solidity ^0.8.0;
245 
246 /**
247  * @title ERC721 token receiver interface
248  * @dev Interface for any contract that wants to support safeTransfers
249  * from ERC721 asset contracts.
250  */
251 interface IERC721Receiver {
252     /**
253      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
254      * by `operator` from `from`, this function is called.
255      *
256      * It must return its Solidity selector to confirm the token transfer.
257      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
258      *
259      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
260      */
261     function onERC721Received(
262         address operator,
263         address from,
264         uint256 tokenId,
265         bytes calldata data
266     ) external returns (bytes4);
267 }
268 
269 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
270 
271 
272 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
273 
274 pragma solidity ^0.8.0;
275 
276 /**
277  * @dev Interface of the ERC165 standard, as defined in the
278  * https://eips.ethereum.org/EIPS/eip-165[EIP].
279  *
280  * Implementers can declare support of contract interfaces, which can then be
281  * queried by others ({ERC165Checker}).
282  *
283  * For an implementation, see {ERC165}.
284  */
285 interface IERC165 {
286     /**
287      * @dev Returns true if this contract implements the interface defined by
288      * `interfaceId`. See the corresponding
289      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
290      * to learn more about how these ids are created.
291      *
292      * This function call must use less than 30 000 gas.
293      */
294     function supportsInterface(bytes4 interfaceId) external view returns (bool);
295 }
296 
297 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
298 
299 
300 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
301 
302 pragma solidity ^0.8.0;
303 
304 
305 /**
306  * @dev Implementation of the {IERC165} interface.
307  *
308  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
309  * for the additional interface id that will be supported. For example:
310  *
311  * ```solidity
312  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
313  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
314  * }
315  * ```
316  *
317  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
318  */
319 abstract contract ERC165 is IERC165 {
320     /**
321      * @dev See {IERC165-supportsInterface}.
322      */
323     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
324         return interfaceId == type(IERC165).interfaceId;
325     }
326 }
327 
328 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
329 
330 
331 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
332 
333 pragma solidity ^0.8.0;
334 
335 
336 /**
337  * @dev Required interface of an ERC721 compliant contract.
338  */
339 interface IERC721 is IERC165 {
340     /**
341      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
342      */
343     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
344 
345     /**
346      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
347      */
348     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
349 
350     /**
351      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
352      */
353     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
354 
355     /**
356      * @dev Returns the number of tokens in ``owner``'s account.
357      */
358     function balanceOf(address owner) external view returns (uint256 balance);
359 
360     /**
361      * @dev Returns the owner of the `tokenId` token.
362      *
363      * Requirements:
364      *
365      * - `tokenId` must exist.
366      */
367     function ownerOf(uint256 tokenId) external view returns (address owner);
368 
369     /**
370      * @dev Safely transfers `tokenId` token from `from` to `to`.
371      *
372      * Requirements:
373      *
374      * - `from` cannot be the zero address.
375      * - `to` cannot be the zero address.
376      * - `tokenId` token must exist and be owned by `from`.
377      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
378      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
379      *
380      * Emits a {Transfer} event.
381      */
382     function safeTransferFrom(
383         address from,
384         address to,
385         uint256 tokenId,
386         bytes calldata data
387     ) external;
388 
389     /**
390      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
391      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
392      *
393      * Requirements:
394      *
395      * - `from` cannot be the zero address.
396      * - `to` cannot be the zero address.
397      * - `tokenId` token must exist and be owned by `from`.
398      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
399      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
400      *
401      * Emits a {Transfer} event.
402      */
403     function safeTransferFrom(
404         address from,
405         address to,
406         uint256 tokenId
407     ) external;
408 
409     /**
410      * @dev Transfers `tokenId` token from `from` to `to`.
411      *
412      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
413      *
414      * Requirements:
415      *
416      * - `from` cannot be the zero address.
417      * - `to` cannot be the zero address.
418      * - `tokenId` token must be owned by `from`.
419      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
420      *
421      * Emits a {Transfer} event.
422      */
423     function transferFrom(
424         address from,
425         address to,
426         uint256 tokenId
427     ) external;
428 
429     /**
430      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
431      * The approval is cleared when the token is transferred.
432      *
433      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
434      *
435      * Requirements:
436      *
437      * - The caller must own the token or be an approved operator.
438      * - `tokenId` must exist.
439      *
440      * Emits an {Approval} event.
441      */
442     function approve(address to, uint256 tokenId) external;
443 
444     /**
445      * @dev Approve or remove `operator` as an operator for the caller.
446      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
447      *
448      * Requirements:
449      *
450      * - The `operator` cannot be the caller.
451      *
452      * Emits an {ApprovalForAll} event.
453      */
454     function setApprovalForAll(address operator, bool _approved) external;
455 
456     /**
457      * @dev Returns the account approved for `tokenId` token.
458      *
459      * Requirements:
460      *
461      * - `tokenId` must exist.
462      */
463     function getApproved(uint256 tokenId) external view returns (address operator);
464 
465     /**
466      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
467      *
468      * See {setApprovalForAll}
469      */
470     function isApprovedForAll(address owner, address operator) external view returns (bool);
471 }
472 
473 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
474 
475 
476 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
477 
478 pragma solidity ^0.8.0;
479 
480 
481 /**
482  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
483  * @dev See https://eips.ethereum.org/EIPS/eip-721
484  */
485 interface IERC721Enumerable is IERC721 {
486     /**
487      * @dev Returns the total amount of tokens stored by the contract.
488      */
489     function totalSupply() external view returns (uint256);
490 
491     /**
492      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
493      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
494      */
495     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
496 
497     /**
498      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
499      * Use along with {totalSupply} to enumerate all tokens.
500      */
501     function tokenByIndex(uint256 index) external view returns (uint256);
502 }
503 
504 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
505 
506 
507 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
508 
509 pragma solidity ^0.8.0;
510 
511 
512 /**
513  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
514  * @dev See https://eips.ethereum.org/EIPS/eip-721
515  */
516 interface IERC721Metadata is IERC721 {
517     /**
518      * @dev Returns the token collection name.
519      */
520     function name() external view returns (string memory);
521 
522     /**
523      * @dev Returns the token collection symbol.
524      */
525     function symbol() external view returns (string memory);
526 
527     /**
528      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
529      */
530     function tokenURI(uint256 tokenId) external view returns (string memory);
531 }
532 
533 // File: @openzeppelin/contracts/utils/Strings.sol
534 
535 
536 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
537 
538 pragma solidity ^0.8.0;
539 
540 /**
541  * @dev String operations.
542  */
543 library Strings {
544     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
545 
546     /**
547      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
548      */
549     function toString(uint256 value) internal pure returns (string memory) {
550         // Inspired by OraclizeAPI's implementation - MIT licence
551         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
552 
553         if (value == 0) {
554             return "0";
555         }
556         uint256 temp = value;
557         uint256 digits;
558         while (temp != 0) {
559             digits++;
560             temp /= 10;
561         }
562         bytes memory buffer = new bytes(digits);
563         while (value != 0) {
564             digits -= 1;
565             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
566             value /= 10;
567         }
568         return string(buffer);
569     }
570 
571     /**
572      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
573      */
574     function toHexString(uint256 value) internal pure returns (string memory) {
575         if (value == 0) {
576             return "0x00";
577         }
578         uint256 temp = value;
579         uint256 length = 0;
580         while (temp != 0) {
581             length++;
582             temp >>= 8;
583         }
584         return toHexString(value, length);
585     }
586 
587     /**
588      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
589      */
590     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
591         bytes memory buffer = new bytes(2 * length + 2);
592         buffer[0] = "0";
593         buffer[1] = "x";
594         for (uint256 i = 2 * length + 1; i > 1; --i) {
595             buffer[i] = _HEX_SYMBOLS[value & 0xf];
596             value >>= 4;
597         }
598         require(value == 0, "Strings: hex length insufficient");
599         return string(buffer);
600     }
601 }
602 
603 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
604 
605 
606 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/ECDSA.sol)
607 
608 pragma solidity ^0.8.0;
609 
610 
611 /**
612  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
613  *
614  * These functions can be used to verify that a message was signed by the holder
615  * of the private keys of a given address.
616  */
617 library ECDSA {
618     enum RecoverError {
619         NoError,
620         InvalidSignature,
621         InvalidSignatureLength,
622         InvalidSignatureS,
623         InvalidSignatureV
624     }
625 
626     function _throwError(RecoverError error) private pure {
627         if (error == RecoverError.NoError) {
628             return; // no error: do nothing
629         } else if (error == RecoverError.InvalidSignature) {
630             revert("ECDSA: invalid signature");
631         } else if (error == RecoverError.InvalidSignatureLength) {
632             revert("ECDSA: invalid signature length");
633         } else if (error == RecoverError.InvalidSignatureS) {
634             revert("ECDSA: invalid signature 's' value");
635         } else if (error == RecoverError.InvalidSignatureV) {
636             revert("ECDSA: invalid signature 'v' value");
637         }
638     }
639 
640     /**
641      * @dev Returns the address that signed a hashed message (`hash`) with
642      * `signature` or error string. This address can then be used for verification purposes.
643      *
644      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
645      * this function rejects them by requiring the `s` value to be in the lower
646      * half order, and the `v` value to be either 27 or 28.
647      *
648      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
649      * verification to be secure: it is possible to craft signatures that
650      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
651      * this is by receiving a hash of the original message (which may otherwise
652      * be too long), and then calling {toEthSignedMessageHash} on it.
653      *
654      * Documentation for signature generation:
655      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
656      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
657      *
658      * _Available since v4.3._
659      */
660     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
661         // Check the signature length
662         // - case 65: r,s,v signature (standard)
663         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
664         if (signature.length == 65) {
665             bytes32 r;
666             bytes32 s;
667             uint8 v;
668             // ecrecover takes the signature parameters, and the only way to get them
669             // currently is to use assembly.
670             assembly {
671                 r := mload(add(signature, 0x20))
672                 s := mload(add(signature, 0x40))
673                 v := byte(0, mload(add(signature, 0x60)))
674             }
675             return tryRecover(hash, v, r, s);
676         } else if (signature.length == 64) {
677             bytes32 r;
678             bytes32 vs;
679             // ecrecover takes the signature parameters, and the only way to get them
680             // currently is to use assembly.
681             assembly {
682                 r := mload(add(signature, 0x20))
683                 vs := mload(add(signature, 0x40))
684             }
685             return tryRecover(hash, r, vs);
686         } else {
687             return (address(0), RecoverError.InvalidSignatureLength);
688         }
689     }
690 
691     /**
692      * @dev Returns the address that signed a hashed message (`hash`) with
693      * `signature`. This address can then be used for verification purposes.
694      *
695      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
696      * this function rejects them by requiring the `s` value to be in the lower
697      * half order, and the `v` value to be either 27 or 28.
698      *
699      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
700      * verification to be secure: it is possible to craft signatures that
701      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
702      * this is by receiving a hash of the original message (which may otherwise
703      * be too long), and then calling {toEthSignedMessageHash} on it.
704      */
705     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
706         (address recovered, RecoverError error) = tryRecover(hash, signature);
707         _throwError(error);
708         return recovered;
709     }
710 
711     /**
712      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
713      *
714      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
715      *
716      * _Available since v4.3._
717      */
718     function tryRecover(
719         bytes32 hash,
720         bytes32 r,
721         bytes32 vs
722     ) internal pure returns (address, RecoverError) {
723         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
724         uint8 v = uint8((uint256(vs) >> 255) + 27);
725         return tryRecover(hash, v, r, s);
726     }
727 
728     /**
729      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
730      *
731      * _Available since v4.2._
732      */
733     function recover(
734         bytes32 hash,
735         bytes32 r,
736         bytes32 vs
737     ) internal pure returns (address) {
738         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
739         _throwError(error);
740         return recovered;
741     }
742 
743     /**
744      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
745      * `r` and `s` signature fields separately.
746      *
747      * _Available since v4.3._
748      */
749     function tryRecover(
750         bytes32 hash,
751         uint8 v,
752         bytes32 r,
753         bytes32 s
754     ) internal pure returns (address, RecoverError) {
755         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
756         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
757         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
758         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
759         //
760         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
761         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
762         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
763         // these malleable signatures as well.
764         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
765             return (address(0), RecoverError.InvalidSignatureS);
766         }
767         if (v != 27 && v != 28) {
768             return (address(0), RecoverError.InvalidSignatureV);
769         }
770 
771         // If the signature is valid (and not malleable), return the signer address
772         address signer = ecrecover(hash, v, r, s);
773         if (signer == address(0)) {
774             return (address(0), RecoverError.InvalidSignature);
775         }
776 
777         return (signer, RecoverError.NoError);
778     }
779 
780     /**
781      * @dev Overload of {ECDSA-recover} that receives the `v`,
782      * `r` and `s` signature fields separately.
783      */
784     function recover(
785         bytes32 hash,
786         uint8 v,
787         bytes32 r,
788         bytes32 s
789     ) internal pure returns (address) {
790         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
791         _throwError(error);
792         return recovered;
793     }
794 
795     /**
796      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
797      * produces hash corresponding to the one signed with the
798      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
799      * JSON-RPC method as part of EIP-191.
800      *
801      * See {recover}.
802      */
803     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
804         // 32 is the length in bytes of hash,
805         // enforced by the type signature above
806         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
807     }
808 
809     /**
810      * @dev Returns an Ethereum Signed Message, created from `s`. This
811      * produces hash corresponding to the one signed with the
812      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
813      * JSON-RPC method as part of EIP-191.
814      *
815      * See {recover}.
816      */
817     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
818         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
819     }
820 
821     /**
822      * @dev Returns an Ethereum Signed Typed Data, created from a
823      * `domainSeparator` and a `structHash`. This produces hash corresponding
824      * to the one signed with the
825      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
826      * JSON-RPC method as part of EIP-712.
827      *
828      * See {recover}.
829      */
830     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
831         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
832     }
833 }
834 
835 // File: @openzeppelin/contracts/utils/Context.sol
836 
837 
838 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
839 
840 pragma solidity ^0.8.0;
841 
842 /**
843  * @dev Provides information about the current execution context, including the
844  * sender of the transaction and its data. While these are generally available
845  * via msg.sender and msg.data, they should not be accessed in such a direct
846  * manner, since when dealing with meta-transactions the account sending and
847  * paying for execution may not be the actual sender (as far as an application
848  * is concerned).
849  *
850  * This contract is only required for intermediate, library-like contracts.
851  */
852 abstract contract Context {
853     function _msgSender() internal view virtual returns (address) {
854         return msg.sender;
855     }
856 
857     function _msgData() internal view virtual returns (bytes calldata) {
858         return msg.data;
859     }
860 }
861 
862 // File: contracts/ERC721A.sol
863 
864 
865 // Creator: Chiru Labs
866 
867 pragma solidity ^0.8.4;
868 
869 
870 
871 
872 
873 
874 
875 
876 
877 error ApprovalCallerNotOwnerNorApproved();
878 error ApprovalQueryForNonexistentToken();
879 error ApproveToCaller();
880 error ApprovalToCurrentOwner();
881 error BalanceQueryForZeroAddress();
882 error MintToZeroAddress();
883 error MintZeroQuantity();
884 error OwnerQueryForNonexistentToken();
885 error TransferCallerNotOwnerNorApproved();
886 error TransferFromIncorrectOwner();
887 error TransferToNonERC721ReceiverImplementer();
888 error TransferToZeroAddress();
889 error URIQueryForNonexistentToken();
890 
891 /**
892  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
893  * the Metadata extension. Built to optimize for lower gas during batch mints.
894  *
895  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
896  *
897  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
898  *
899  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
900  */
901 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
902     using Address for address;
903     using Strings for uint256;
904 
905     // Compiler will pack this into a single 256bit word.
906     struct TokenOwnership {
907         // The address of the owner.
908         address addr;
909         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
910         uint64 startTimestamp;
911         // Whether the token has been burned.
912         bool burned;
913     }
914 
915     // Compiler will pack this into a single 256bit word.
916     struct AddressData {
917         // Realistically, 2**64-1 is more than enough.
918         uint64 balance;
919         // Keeps track of mint count with minimal overhead for tokenomics.
920         uint64 numberMinted;
921         // Keeps track of burn count with minimal overhead for tokenomics.
922         uint64 numberBurned;
923         // For miscellaneous variable(s) pertaining to the address
924         // (e.g. number of whitelist mint slots used).
925         // If there are multiple variables, please pack them into a uint64.
926         uint64 aux;
927     }
928 
929     // The tokenId of the next token to be minted.
930     uint256 internal _currentIndex;
931 
932     // The number of tokens burned.
933     uint256 internal _burnCounter;
934 
935     // Token name
936     string private _name;
937 
938     // Token symbol
939     string private _symbol;
940 
941     // Mapping from token ID to ownership details
942     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
943     mapping(uint256 => TokenOwnership) internal _ownerships;
944 
945     // Mapping owner address to address data
946     mapping(address => AddressData) private _addressData;
947 
948     // Mapping from token ID to approved address
949     mapping(uint256 => address) private _tokenApprovals;
950 
951     // Mapping from owner to operator approvals
952     mapping(address => mapping(address => bool)) private _operatorApprovals;
953 
954     constructor(string memory name_, string memory symbol_) {
955         _name = name_;
956         _symbol = symbol_;
957         _currentIndex = _startTokenId();
958     }
959 
960     /**
961      * To change the starting tokenId, please override this function.
962      */
963     function _startTokenId() internal view virtual returns (uint256) {
964         return 0;
965     }
966 
967     /**
968      * @dev See {IERC721Enumerable-totalSupply}.
969      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
970      */
971     function totalSupply() public view returns (uint256) {
972         // Counter underflow is impossible as _burnCounter cannot be incremented
973         // more than _currentIndex - _startTokenId() times
974         unchecked {
975             return _currentIndex - _burnCounter - _startTokenId();
976         }
977     }
978 
979     /**
980      * Returns the total amount of tokens minted in the contract.
981      */
982     function _totalMinted() internal view returns (uint256) {
983         // Counter underflow is impossible as _currentIndex does not decrement,
984         // and it is initialized to _startTokenId()
985         unchecked {
986             return _currentIndex - _startTokenId();
987         }
988     }
989 
990     /**
991      * @dev See {IERC165-supportsInterface}.
992      */
993     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
994         return
995             interfaceId == type(IERC721).interfaceId ||
996             interfaceId == type(IERC721Metadata).interfaceId ||
997             super.supportsInterface(interfaceId);
998     }
999 
1000     /**
1001      * @dev See {IERC721-balanceOf}.
1002      */
1003     function balanceOf(address owner) public view override returns (uint256) {
1004         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1005         return uint256(_addressData[owner].balance);
1006     }
1007 
1008     /**
1009      * Returns the number of tokens minted by `owner`.
1010      */
1011     function _numberMinted(address owner) internal view returns (uint256) {
1012         return uint256(_addressData[owner].numberMinted);
1013     }
1014 
1015     /**
1016      * Returns the number of tokens burned by or on behalf of `owner`.
1017      */
1018     function _numberBurned(address owner) internal view returns (uint256) {
1019         return uint256(_addressData[owner].numberBurned);
1020     }
1021 
1022     /**
1023      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1024      */
1025     function _getAux(address owner) internal view returns (uint64) {
1026         return _addressData[owner].aux;
1027     }
1028 
1029     /**
1030      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1031      * If there are multiple variables, please pack them into a uint64.
1032      */
1033     function _setAux(address owner, uint64 aux) internal {
1034         _addressData[owner].aux = aux;
1035     }
1036 
1037     /**
1038      * Gas spent here starts off proportional to the maximum mint batch size.
1039      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1040      */
1041     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1042         uint256 curr = tokenId;
1043 
1044         unchecked {
1045             if (_startTokenId() <= curr && curr < _currentIndex) {
1046                 TokenOwnership memory ownership = _ownerships[curr];
1047                 if (!ownership.burned) {
1048                     if (ownership.addr != address(0)) {
1049                         return ownership;
1050                     }
1051                     // Invariant:
1052                     // There will always be an ownership that has an address and is not burned
1053                     // before an ownership that does not have an address and is not burned.
1054                     // Hence, curr will not underflow.
1055                     while (true) {
1056                         curr--;
1057                         ownership = _ownerships[curr];
1058                         if (ownership.addr != address(0)) {
1059                             return ownership;
1060                         }
1061                     }
1062                 }
1063             }
1064         }
1065         revert OwnerQueryForNonexistentToken();
1066     }
1067 
1068     /**
1069      * @dev See {IERC721-ownerOf}.
1070      */
1071     function ownerOf(uint256 tokenId) public view override returns (address) {
1072         return _ownershipOf(tokenId).addr;
1073     }
1074 
1075     /**
1076      * @dev See {IERC721Metadata-name}.
1077      */
1078     function name() public view virtual override returns (string memory) {
1079         return _name;
1080     }
1081 
1082     /**
1083      * @dev See {IERC721Metadata-symbol}.
1084      */
1085     function symbol() public view virtual override returns (string memory) {
1086         return _symbol;
1087     }
1088 
1089     /**
1090      * @dev See {IERC721Metadata-tokenURI}.
1091      */
1092     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1093         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1094 
1095         string memory baseURI = _baseURI();
1096         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1097     }
1098 
1099     /**
1100      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1101      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1102      * by default, can be overriden in child contracts.
1103      */
1104     function _baseURI() internal view virtual returns (string memory) {
1105         return '';
1106     }
1107 
1108     /**
1109      * @dev See {IERC721-approve}.
1110      */
1111     function approve(address to, uint256 tokenId) public override {
1112         address owner = ERC721A.ownerOf(tokenId);
1113         if (to == owner) revert ApprovalToCurrentOwner();
1114 
1115         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1116             revert ApprovalCallerNotOwnerNorApproved();
1117         }
1118 
1119         _approve(to, tokenId, owner);
1120     }
1121 
1122     /**
1123      * @dev See {IERC721-getApproved}.
1124      */
1125     function getApproved(uint256 tokenId) public view override returns (address) {
1126         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1127 
1128         return _tokenApprovals[tokenId];
1129     }
1130 
1131     /**
1132      * @dev See {IERC721-setApprovalForAll}.
1133      */
1134     function setApprovalForAll(address operator, bool approved) public virtual override {
1135         if (operator == _msgSender()) revert ApproveToCaller();
1136 
1137         _operatorApprovals[_msgSender()][operator] = approved;
1138         emit ApprovalForAll(_msgSender(), operator, approved);
1139     }
1140 
1141     /**
1142      * @dev See {IERC721-isApprovedForAll}.
1143      */
1144     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1145         return _operatorApprovals[owner][operator];
1146     }
1147 
1148     /**
1149      * @dev See {IERC721-transferFrom}.
1150      */
1151     function transferFrom(
1152         address from,
1153         address to,
1154         uint256 tokenId
1155     ) public virtual override {
1156         _transfer(from, to, tokenId);
1157     }
1158 
1159     /**
1160      * @dev See {IERC721-safeTransferFrom}.
1161      */
1162     function safeTransferFrom(
1163         address from,
1164         address to,
1165         uint256 tokenId
1166     ) public virtual override {
1167         safeTransferFrom(from, to, tokenId, '');
1168     }
1169 
1170     /**
1171      * @dev See {IERC721-safeTransferFrom}.
1172      */
1173     function safeTransferFrom(
1174         address from,
1175         address to,
1176         uint256 tokenId,
1177         bytes memory _data
1178     ) public virtual override {
1179         _transfer(from, to, tokenId);
1180         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1181             revert TransferToNonERC721ReceiverImplementer();
1182         }
1183     }
1184 
1185     /**
1186      * @dev Returns whether `tokenId` exists.
1187      *
1188      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1189      *
1190      * Tokens start existing when they are minted (`_mint`),
1191      */
1192     function _exists(uint256 tokenId) internal view returns (bool) {
1193         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1194             !_ownerships[tokenId].burned;
1195     }
1196 
1197     function _safeMint(address to, uint256 quantity) internal {
1198         _safeMint(to, quantity, '');
1199     }
1200 
1201     /**
1202      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1203      *
1204      * Requirements:
1205      *
1206      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1207      * - `quantity` must be greater than 0.
1208      *
1209      * Emits a {Transfer} event.
1210      */
1211     function _safeMint(
1212         address to,
1213         uint256 quantity,
1214         bytes memory _data
1215     ) internal {
1216         _mint(to, quantity, _data, true);
1217     }
1218 
1219     /**
1220      * @dev Mints `quantity` tokens and transfers them to `to`.
1221      *
1222      * Requirements:
1223      *
1224      * - `to` cannot be the zero address.
1225      * - `quantity` must be greater than 0.
1226      *
1227      * Emits a {Transfer} event.
1228      */
1229     function _mint(
1230         address to,
1231         uint256 quantity,
1232         bytes memory _data,
1233         bool safe
1234     ) internal {
1235         uint256 startTokenId = _currentIndex;
1236         if (to == address(0)) revert MintToZeroAddress();
1237         if (quantity == 0) revert MintZeroQuantity();
1238 
1239         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1240 
1241         // Overflows are incredibly unrealistic.
1242         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1243         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1244         unchecked {
1245             _addressData[to].balance += uint64(quantity);
1246             _addressData[to].numberMinted += uint64(quantity);
1247 
1248             _ownerships[startTokenId].addr = to;
1249             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1250 
1251             uint256 updatedIndex = startTokenId;
1252             uint256 end = updatedIndex + quantity;
1253 
1254             if (safe && to.isContract()) {
1255                 do {
1256                     emit Transfer(address(0), to, updatedIndex);
1257                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1258                         revert TransferToNonERC721ReceiverImplementer();
1259                     }
1260                 } while (updatedIndex != end);
1261                 // Reentrancy protection
1262                 if (_currentIndex != startTokenId) revert();
1263             } else {
1264                 do {
1265                     emit Transfer(address(0), to, updatedIndex++);
1266                 } while (updatedIndex != end);
1267             }
1268             _currentIndex = updatedIndex;
1269         }
1270         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1271     }
1272 
1273     /**
1274      * @dev Transfers `tokenId` from `from` to `to`.
1275      *
1276      * Requirements:
1277      *
1278      * - `to` cannot be the zero address.
1279      * - `tokenId` token must be owned by `from`.
1280      *
1281      * Emits a {Transfer} event.
1282      */
1283     function _transfer(
1284         address from,
1285         address to,
1286         uint256 tokenId
1287     ) private {
1288         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1289 
1290         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1291 
1292         bool isApprovedOrOwner = (_msgSender() == from ||
1293             isApprovedForAll(from, _msgSender()) ||
1294             getApproved(tokenId) == _msgSender());
1295 
1296         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1297         if (to == address(0)) revert TransferToZeroAddress();
1298 
1299         _beforeTokenTransfers(from, to, tokenId, 1);
1300 
1301         // Clear approvals from the previous owner
1302         _approve(address(0), tokenId, from);
1303 
1304         // Underflow of the sender's balance is impossible because we check for
1305         // ownership above and the recipient's balance can't realistically overflow.
1306         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1307         unchecked {
1308             _addressData[from].balance -= 1;
1309             _addressData[to].balance += 1;
1310 
1311             TokenOwnership storage currSlot = _ownerships[tokenId];
1312             currSlot.addr = to;
1313             currSlot.startTimestamp = uint64(block.timestamp);
1314 
1315             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1316             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1317             uint256 nextTokenId = tokenId + 1;
1318             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1319             if (nextSlot.addr == address(0)) {
1320                 // This will suffice for checking _exists(nextTokenId),
1321                 // as a burned slot cannot contain the zero address.
1322                 if (nextTokenId != _currentIndex) {
1323                     nextSlot.addr = from;
1324                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1325                 }
1326             }
1327         }
1328 
1329         emit Transfer(from, to, tokenId);
1330         _afterTokenTransfers(from, to, tokenId, 1);
1331     }
1332 
1333     /**
1334      * @dev This is equivalent to _burn(tokenId, false)
1335      */
1336     function _burn(uint256 tokenId) internal virtual {
1337         _burn(tokenId, false);
1338     }
1339 
1340     /**
1341      * @dev Destroys `tokenId`.
1342      * The approval is cleared when the token is burned.
1343      *
1344      * Requirements:
1345      *
1346      * - `tokenId` must exist.
1347      *
1348      * Emits a {Transfer} event.
1349      */
1350     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1351         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1352 
1353         address from = prevOwnership.addr;
1354 
1355         if (approvalCheck) {
1356             bool isApprovedOrOwner = (_msgSender() == from ||
1357                 isApprovedForAll(from, _msgSender()) ||
1358                 getApproved(tokenId) == _msgSender());
1359 
1360             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1361         }
1362 
1363         _beforeTokenTransfers(from, address(0), tokenId, 1);
1364 
1365         // Clear approvals from the previous owner
1366         _approve(address(0), tokenId, from);
1367 
1368         // Underflow of the sender's balance is impossible because we check for
1369         // ownership above and the recipient's balance can't realistically overflow.
1370         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1371         unchecked {
1372             AddressData storage addressData = _addressData[from];
1373             addressData.balance -= 1;
1374             addressData.numberBurned += 1;
1375 
1376             // Keep track of who burned the token, and the timestamp of burning.
1377             TokenOwnership storage currSlot = _ownerships[tokenId];
1378             currSlot.addr = from;
1379             currSlot.startTimestamp = uint64(block.timestamp);
1380             currSlot.burned = true;
1381 
1382             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1383             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1384             uint256 nextTokenId = tokenId + 1;
1385             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1386             if (nextSlot.addr == address(0)) {
1387                 // This will suffice for checking _exists(nextTokenId),
1388                 // as a burned slot cannot contain the zero address.
1389                 if (nextTokenId != _currentIndex) {
1390                     nextSlot.addr = from;
1391                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1392                 }
1393             }
1394         }
1395 
1396         emit Transfer(from, address(0), tokenId);
1397         _afterTokenTransfers(from, address(0), tokenId, 1);
1398 
1399         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1400         unchecked {
1401             _burnCounter++;
1402         }
1403     }
1404 
1405     /**
1406      * @dev Approve `to` to operate on `tokenId`
1407      *
1408      * Emits a {Approval} event.
1409      */
1410     function _approve(
1411         address to,
1412         uint256 tokenId,
1413         address owner
1414     ) private {
1415         _tokenApprovals[tokenId] = to;
1416         emit Approval(owner, to, tokenId);
1417     }
1418 
1419     /**
1420      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1421      *
1422      * @param from address representing the previous owner of the given token ID
1423      * @param to target address that will receive the tokens
1424      * @param tokenId uint256 ID of the token to be transferred
1425      * @param _data bytes optional data to send along with the call
1426      * @return bool whether the call correctly returned the expected magic value
1427      */
1428     function _checkContractOnERC721Received(
1429         address from,
1430         address to,
1431         uint256 tokenId,
1432         bytes memory _data
1433     ) private returns (bool) {
1434         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1435             return retval == IERC721Receiver(to).onERC721Received.selector;
1436         } catch (bytes memory reason) {
1437             if (reason.length == 0) {
1438                 revert TransferToNonERC721ReceiverImplementer();
1439             } else {
1440                 assembly {
1441                     revert(add(32, reason), mload(reason))
1442                 }
1443             }
1444         }
1445     }
1446 
1447     /**
1448      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1449      * And also called before burning one token.
1450      *
1451      * startTokenId - the first token id to be transferred
1452      * quantity - the amount to be transferred
1453      *
1454      * Calling conditions:
1455      *
1456      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1457      * transferred to `to`.
1458      * - When `from` is zero, `tokenId` will be minted for `to`.
1459      * - When `to` is zero, `tokenId` will be burned by `from`.
1460      * - `from` and `to` are never both zero.
1461      */
1462     function _beforeTokenTransfers(
1463         address from,
1464         address to,
1465         uint256 startTokenId,
1466         uint256 quantity
1467     ) internal virtual {}
1468 
1469     /**
1470      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1471      * minting.
1472      * And also called after one token has been burned.
1473      *
1474      * startTokenId - the first token id to be transferred
1475      * quantity - the amount to be transferred
1476      *
1477      * Calling conditions:
1478      *
1479      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1480      * transferred to `to`.
1481      * - When `from` is zero, `tokenId` has been minted for `to`.
1482      * - When `to` is zero, `tokenId` has been burned by `from`.
1483      * - `from` and `to` are never both zero.
1484      */
1485     function _afterTokenTransfers(
1486         address from,
1487         address to,
1488         uint256 startTokenId,
1489         uint256 quantity
1490     ) internal virtual {}
1491 }
1492 // File: @openzeppelin/contracts/access/Ownable.sol
1493 
1494 
1495 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1496 
1497 pragma solidity ^0.8.0;
1498 
1499 
1500 /**
1501  * @dev Contract module which provides a basic access control mechanism, where
1502  * there is an account (an owner) that can be granted exclusive access to
1503  * specific functions.
1504  *
1505  * By default, the owner account will be the one that deploys the contract. This
1506  * can later be changed with {transferOwnership}.
1507  *
1508  * This module is used through inheritance. It will make available the modifier
1509  * `onlyOwner`, which can be applied to your functions to restrict their use to
1510  * the owner.
1511  */
1512 abstract contract Ownable is Context {
1513     address private _owner;
1514 
1515     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1516 
1517     /**
1518      * @dev Initializes the contract setting the deployer as the initial owner.
1519      */
1520     constructor() {
1521         _transferOwnership(_msgSender());
1522     }
1523 
1524     /**
1525      * @dev Returns the address of the current owner.
1526      */
1527     function owner() public view virtual returns (address) {
1528         return _owner;
1529     }
1530 
1531     /**
1532      * @dev Throws if called by any account other than the owner.
1533      */
1534     modifier onlyOwner() {
1535         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1536         _;
1537     }
1538 
1539     /**
1540      * @dev Leaves the contract without owner. It will not be possible to call
1541      * `onlyOwner` functions anymore. Can only be called by the current owner.
1542      *
1543      * NOTE: Renouncing ownership will leave the contract without an owner,
1544      * thereby removing any functionality that is only available to the owner.
1545      */
1546     function renounceOwnership() public virtual onlyOwner {
1547         _transferOwnership(address(0));
1548     }
1549 
1550     /**
1551      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1552      * Can only be called by the current owner.
1553      */
1554     function transferOwnership(address newOwner) public virtual onlyOwner {
1555         require(newOwner != address(0), "Ownable: new owner is the zero address");
1556         _transferOwnership(newOwner);
1557     }
1558 
1559     /**
1560      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1561      * Internal function without access restriction.
1562      */
1563     function _transferOwnership(address newOwner) internal virtual {
1564         address oldOwner = _owner;
1565         _owner = newOwner;
1566         emit OwnershipTransferred(oldOwner, newOwner);
1567     }
1568 }
1569 
1570 // File: contracts/knightsoftheroundtable.sol
1571 
1572 /*
1573 
1574 
1575 __________.__              .__     __      ______________________________    _________
1576 \______   \__|__  ___ ____ |  |   /  \    /  \____    /\______   \______ \  /   _____/
1577  |     ___/  \  \/  // __ \|  |   \   \/\/   / /     /  |       _/|    |  \ \_____  \ 
1578  |    |   |  |>    <\  ___/|  |__  \        / /     /_  |    |   \|    `   \/        \
1579  |____|   |__/__/\_ \\___  >____/   \__/\  / /_______ \ |____|_  /_______  /_______  /
1580                    \/    \/              \/          \/        \/        \/        \/ 
1581 
1582 */
1583 
1584 pragma solidity ^0.8.9;
1585 
1586 
1587 
1588 
1589 contract PixelWZRDS is ERC721A, Ownable {
1590     using ECDSA for bytes32;
1591     using Strings for uint256;
1592 
1593     address private constant TEAM_ADDRESS = 0x1f1238c14db58Beac45c4A3efe86BE86eF74C661;
1594 
1595     uint256 public constant TOTAL_MAX_SUPPLY = 10000;
1596     uint256 public constant TOTAL_FREE_SUPPLY = 10000; 
1597     uint256 public constant TEAM_CLAIM_AMOUNT = 50;
1598 
1599 
1600     uint256 public  MAX_FREE_MINT_PER_WALLET = 2;
1601     uint256 public  MAX_PUBLIC_PER_TX = 20;
1602 
1603     
1604 
1605     uint256 public token_price = 0.005 ether;
1606     bool public publicSaleActive;
1607     bool public freeMintActive;
1608     bool public claimed = false;
1609     uint256 public freeMintCount;
1610 
1611     mapping(address => uint256) public freeMintClaimed;
1612 
1613     string private _baseTokenURI;
1614 
1615 
1616     constructor() ERC721A("Pixel WZRDS", "PZRDS") {
1617         _safeMint(msg.sender, 10);
1618     }
1619 
1620     modifier callerIsUser() {
1621         require(tx.origin == msg.sender, "The caller is another contract");
1622         _;
1623     }
1624 
1625     modifier underMaxSupply(uint256 _quantity) {
1626         require(
1627             _totalMinted() + _quantity <= TOTAL_MAX_SUPPLY,
1628             "Purchase would exceed max supply"
1629         );
1630 
1631         _;
1632     }
1633 
1634     modifier validateFreeMintStatus(uint256 _quantity) {
1635         require(freeMintActive, "free claim is not active");
1636         require(freeMintCount + _quantity <= TOTAL_FREE_SUPPLY, "Purchase would exceed max supply of free mints");
1637         require(freeMintClaimed[msg.sender] + _quantity <= MAX_FREE_MINT_PER_WALLET, "wallet has exceeded free mint amount");
1638         _;
1639     }
1640 
1641     
1642 
1643     modifier validatePublicStatus(uint256 _quantity) {
1644         require(publicSaleActive, "public sale is not active");
1645         require(msg.value >= token_price * _quantity, "Need to send more ETH.");
1646         require(_quantity > 0 && _quantity <= MAX_PUBLIC_PER_TX, "Invalid mint amount.");
1647         _;
1648     }
1649 
1650 
1651     function freeMint(uint256 _quantity) 
1652         external 
1653         callerIsUser 
1654         validateFreeMintStatus(_quantity)
1655         underMaxSupply(_quantity)
1656     {
1657         freeMintClaimed[msg.sender] += _quantity;
1658         freeMintCount += _quantity;
1659 
1660         _mint(msg.sender, _quantity, "", false);
1661     }
1662 
1663     function mint(uint256 _quantity)
1664         external
1665         payable
1666         callerIsUser
1667         validatePublicStatus(_quantity)
1668         underMaxSupply(_quantity)
1669     {
1670         _mint(msg.sender, _quantity, "", false);
1671     }
1672 
1673     function _baseURI() internal view virtual override returns (string memory) {
1674         return _baseTokenURI;
1675     }
1676 
1677     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1678         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1679 
1680         string memory baseURI = _baseURI();
1681         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : '';
1682     }
1683 
1684     function numberMinted(address owner) public view returns (uint256) {
1685         return _numberMinted(owner);
1686     }
1687 
1688     function ownerMint(uint256 _numberToMint)
1689         external
1690         onlyOwner
1691         underMaxSupply(_numberToMint)
1692     {
1693         _mint(msg.sender, _numberToMint, "", false);
1694     }
1695 
1696       function teamClaim() external onlyOwner {
1697         require(!claimed, "Team already claimed");
1698         // claim
1699         _safeMint(TEAM_ADDRESS, TEAM_CLAIM_AMOUNT);
1700         claimed = true;
1701   }
1702 
1703     function ownerMintToAddress(address _recipient, uint256 _numberToMint)
1704         external
1705         onlyOwner
1706         underMaxSupply(_numberToMint)
1707     {
1708         _mint(_recipient, _numberToMint, "", false);
1709     }
1710 
1711     function setFreeMintCount(uint256 _count) external onlyOwner {
1712         freeMintCount = _count;
1713     }
1714 
1715     function setMaxFreePerWallet(uint256 _num) external onlyOwner {
1716         require(_num >= 0, "Num must be greater than zero");
1717         MAX_FREE_MINT_PER_WALLET = _num;
1718     } 
1719     
1720     function setMaxPerTxn(uint256 _num) external onlyOwner {
1721         require(_num >= 0, "Num must be greater than zero");
1722         MAX_PUBLIC_PER_TX = _num;
1723     } 
1724 
1725 
1726     function setTokenPrice(uint256 newPrice) external onlyOwner {
1727         require(newPrice >= 0, "Token price must be greater than zero");
1728         token_price = newPrice;
1729     }
1730 
1731     function setBaseURI(string calldata baseURI) external onlyOwner {
1732         _baseTokenURI = baseURI;
1733     }
1734 
1735     function withdrawFunds() external onlyOwner {
1736         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1737         require(success, "Transfer failed.");
1738     }
1739 
1740     function withdrawFundsToAddress(address _address, uint256 amount) external onlyOwner {
1741         (bool success, ) =_address.call{value: amount}("");
1742         require(success, "Transfer failed.");
1743     }
1744     
1745     function flipFreeMintActive() external onlyOwner {
1746         freeMintActive = !freeMintActive;
1747     }
1748 
1749     function flipPublicSaleActive() external onlyOwner {
1750         publicSaleActive = !publicSaleActive;
1751     }
1752 
1753 }