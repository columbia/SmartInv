1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/Address.sol
3 
4 
5 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
6 
7 pragma solidity ^0.8.1;
8 
9 /**
10  * @dev Collection of functions related to the address type
11  */
12 library Address {
13     /**
14      * @dev Returns true if `account` is a contract.
15      *
16      * [IMPORTANT]
17      * ====
18      * It is unsafe to assume that an address for which this function returns
19      * false is an externally-owned account (EOA) and not a contract.
20      *
21      * Among others, `isContract` will return false for the following
22      * types of addresses:
23      *
24      *  - an externally-owned account
25      *  - a contract in construction
26      *  - an address where a contract will be created
27      *  - an address where a contract lived, but was destroyed
28      * ====
29      *
30      * [IMPORTANT]
31      * ====
32      * You shouldn't rely on `isContract` to protect against flash loan attacks!
33      *
34      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
35      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
36      * constructor.
37      * ====
38      */
39     function isContract(address account) internal view returns (bool) {
40         // This method relies on extcodesize/address.code.length, which returns 0
41         // for contracts in construction, since the code is only stored at the end
42         // of the constructor execution.
43 
44         return account.code.length > 0;
45     }
46 
47     /**
48      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
49      * `recipient`, forwarding all available gas and reverting on errors.
50      *
51      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
52      * of certain opcodes, possibly making contracts go over the 2300 gas limit
53      * imposed by `transfer`, making them unable to receive funds via
54      * `transfer`. {sendValue} removes this limitation.
55      *
56      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
57      *
58      * IMPORTANT: because control is transferred to `recipient`, care must be
59      * taken to not create reentrancy vulnerabilities. Consider using
60      * {ReentrancyGuard} or the
61      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
62      */
63     function sendValue(address payable recipient, uint256 amount) internal {
64         require(address(this).balance >= amount, "Address: insufficient balance");
65 
66         (bool success, ) = recipient.call{value: amount}("");
67         require(success, "Address: unable to send value, recipient may have reverted");
68     }
69 
70     /**
71      * @dev Performs a Solidity function call using a low level `call`. A
72      * plain `call` is an unsafe replacement for a function call: use this
73      * function instead.
74      *
75      * If `target` reverts with a revert reason, it is bubbled up by this
76      * function (like regular Solidity function calls).
77      *
78      * Returns the raw returned data. To convert to the expected return value,
79      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
80      *
81      * Requirements:
82      *
83      * - `target` must be a contract.
84      * - calling `target` with `data` must not revert.
85      *
86      * _Available since v3.1._
87      */
88     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
89         return functionCall(target, data, "Address: low-level call failed");
90     }
91 
92     /**
93      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
94      * `errorMessage` as a fallback revert reason when `target` reverts.
95      *
96      * _Available since v3.1._
97      */
98     function functionCall(
99         address target,
100         bytes memory data,
101         string memory errorMessage
102     ) internal returns (bytes memory) {
103         return functionCallWithValue(target, data, 0, errorMessage);
104     }
105 
106     /**
107      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
108      * but also transferring `value` wei to `target`.
109      *
110      * Requirements:
111      *
112      * - the calling contract must have an ETH balance of at least `value`.
113      * - the called Solidity function must be `payable`.
114      *
115      * _Available since v3.1._
116      */
117     function functionCallWithValue(
118         address target,
119         bytes memory data,
120         uint256 value
121     ) internal returns (bytes memory) {
122         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
123     }
124 
125     /**
126      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
127      * with `errorMessage` as a fallback revert reason when `target` reverts.
128      *
129      * _Available since v3.1._
130      */
131     function functionCallWithValue(
132         address target,
133         bytes memory data,
134         uint256 value,
135         string memory errorMessage
136     ) internal returns (bytes memory) {
137         require(address(this).balance >= value, "Address: insufficient balance for call");
138         require(isContract(target), "Address: call to non-contract");
139 
140         (bool success, bytes memory returndata) = target.call{value: value}(data);
141         return verifyCallResult(success, returndata, errorMessage);
142     }
143 
144     /**
145      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
146      * but performing a static call.
147      *
148      * _Available since v3.3._
149      */
150     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
151         return functionStaticCall(target, data, "Address: low-level static call failed");
152     }
153 
154     /**
155      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
156      * but performing a static call.
157      *
158      * _Available since v3.3._
159      */
160     function functionStaticCall(
161         address target,
162         bytes memory data,
163         string memory errorMessage
164     ) internal view returns (bytes memory) {
165         require(isContract(target), "Address: static call to non-contract");
166 
167         (bool success, bytes memory returndata) = target.staticcall(data);
168         return verifyCallResult(success, returndata, errorMessage);
169     }
170 
171     /**
172      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
173      * but performing a delegate call.
174      *
175      * _Available since v3.4._
176      */
177     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
178         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
179     }
180 
181     /**
182      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
183      * but performing a delegate call.
184      *
185      * _Available since v3.4._
186      */
187     function functionDelegateCall(
188         address target,
189         bytes memory data,
190         string memory errorMessage
191     ) internal returns (bytes memory) {
192         require(isContract(target), "Address: delegate call to non-contract");
193 
194         (bool success, bytes memory returndata) = target.delegatecall(data);
195         return verifyCallResult(success, returndata, errorMessage);
196     }
197 
198     /**
199      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
200      * revert reason using the provided one.
201      *
202      * _Available since v4.3._
203      */
204     function verifyCallResult(
205         bool success,
206         bytes memory returndata,
207         string memory errorMessage
208     ) internal pure returns (bytes memory) {
209         if (success) {
210             return returndata;
211         } else {
212             // Look for revert reason and bubble it up if present
213             if (returndata.length > 0) {
214                 // The easiest way to bubble the revert reason is using memory via assembly
215 
216                 assembly {
217                     let returndata_size := mload(returndata)
218                     revert(add(32, returndata), returndata_size)
219                 }
220             } else {
221                 revert(errorMessage);
222             }
223         }
224     }
225 }
226 
227 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
228 
229 
230 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
231 
232 pragma solidity ^0.8.0;
233 
234 /**
235  * @dev Interface of the ERC165 standard, as defined in the
236  * https://eips.ethereum.org/EIPS/eip-165[EIP].
237  *
238  * Implementers can declare support of contract interfaces, which can then be
239  * queried by others ({ERC165Checker}).
240  *
241  * For an implementation, see {ERC165}.
242  */
243 interface IERC165 {
244     /**
245      * @dev Returns true if this contract implements the interface defined by
246      * `interfaceId`. See the corresponding
247      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
248      * to learn more about how these ids are created.
249      *
250      * This function call must use less than 30 000 gas.
251      */
252     function supportsInterface(bytes4 interfaceId) external view returns (bool);
253 }
254 
255 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
256 
257 
258 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
259 
260 pragma solidity ^0.8.0;
261 
262 
263 /**
264  * @dev Implementation of the {IERC165} interface.
265  *
266  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
267  * for the additional interface id that will be supported. For example:
268  *
269  * ```solidity
270  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
271  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
272  * }
273  * ```
274  *
275  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
276  */
277 abstract contract ERC165 is IERC165 {
278     /**
279      * @dev See {IERC165-supportsInterface}.
280      */
281     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
282         return interfaceId == type(IERC165).interfaceId;
283     }
284 }
285 
286 // File: @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol
287 
288 
289 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC1155/IERC1155Receiver.sol)
290 
291 pragma solidity ^0.8.0;
292 
293 
294 /**
295  * @dev _Available since v3.1._
296  */
297 interface IERC1155Receiver is IERC165 {
298     /**
299      * @dev Handles the receipt of a single ERC1155 token type. This function is
300      * called at the end of a `safeTransferFrom` after the balance has been updated.
301      *
302      * NOTE: To accept the transfer, this must return
303      * `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
304      * (i.e. 0xf23a6e61, or its own function selector).
305      *
306      * @param operator The address which initiated the transfer (i.e. msg.sender)
307      * @param from The address which previously owned the token
308      * @param id The ID of the token being transferred
309      * @param value The amount of tokens being transferred
310      * @param data Additional data with no specified format
311      * @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
312      */
313     function onERC1155Received(
314         address operator,
315         address from,
316         uint256 id,
317         uint256 value,
318         bytes calldata data
319     ) external returns (bytes4);
320 
321     /**
322      * @dev Handles the receipt of a multiple ERC1155 token types. This function
323      * is called at the end of a `safeBatchTransferFrom` after the balances have
324      * been updated.
325      *
326      * NOTE: To accept the transfer(s), this must return
327      * `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
328      * (i.e. 0xbc197c81, or its own function selector).
329      *
330      * @param operator The address which initiated the batch transfer (i.e. msg.sender)
331      * @param from The address which previously owned the token
332      * @param ids An array containing ids of each token being transferred (order and length must match values array)
333      * @param values An array containing amounts of each token being transferred (order and length must match ids array)
334      * @param data Additional data with no specified format
335      * @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
336      */
337     function onERC1155BatchReceived(
338         address operator,
339         address from,
340         uint256[] calldata ids,
341         uint256[] calldata values,
342         bytes calldata data
343     ) external returns (bytes4);
344 }
345 
346 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
347 
348 
349 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/IERC1155.sol)
350 
351 pragma solidity ^0.8.0;
352 
353 
354 /**
355  * @dev Required interface of an ERC1155 compliant contract, as defined in the
356  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
357  *
358  * _Available since v3.1._
359  */
360 interface IERC1155 is IERC165 {
361     /**
362      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
363      */
364     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
365 
366     /**
367      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
368      * transfers.
369      */
370     event TransferBatch(
371         address indexed operator,
372         address indexed from,
373         address indexed to,
374         uint256[] ids,
375         uint256[] values
376     );
377 
378     /**
379      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
380      * `approved`.
381      */
382     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
383 
384     /**
385      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
386      *
387      * If an {URI} event was emitted for `id`, the standard
388      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
389      * returned by {IERC1155MetadataURI-uri}.
390      */
391     event URI(string value, uint256 indexed id);
392 
393     /**
394      * @dev Returns the amount of tokens of token type `id` owned by `account`.
395      *
396      * Requirements:
397      *
398      * - `account` cannot be the zero address.
399      */
400     function balanceOf(address account, uint256 id) external view returns (uint256);
401 
402     /**
403      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
404      *
405      * Requirements:
406      *
407      * - `accounts` and `ids` must have the same length.
408      */
409     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
410         external
411         view
412         returns (uint256[] memory);
413 
414     /**
415      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
416      *
417      * Emits an {ApprovalForAll} event.
418      *
419      * Requirements:
420      *
421      * - `operator` cannot be the caller.
422      */
423     function setApprovalForAll(address operator, bool approved) external;
424 
425     /**
426      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
427      *
428      * See {setApprovalForAll}.
429      */
430     function isApprovedForAll(address account, address operator) external view returns (bool);
431 
432     /**
433      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
434      *
435      * Emits a {TransferSingle} event.
436      *
437      * Requirements:
438      *
439      * - `to` cannot be the zero address.
440      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
441      * - `from` must have a balance of tokens of type `id` of at least `amount`.
442      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
443      * acceptance magic value.
444      */
445     function safeTransferFrom(
446         address from,
447         address to,
448         uint256 id,
449         uint256 amount,
450         bytes calldata data
451     ) external;
452 
453     /**
454      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
455      *
456      * Emits a {TransferBatch} event.
457      *
458      * Requirements:
459      *
460      * - `ids` and `amounts` must have the same length.
461      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
462      * acceptance magic value.
463      */
464     function safeBatchTransferFrom(
465         address from,
466         address to,
467         uint256[] calldata ids,
468         uint256[] calldata amounts,
469         bytes calldata data
470     ) external;
471 }
472 
473 // File: @openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol
474 
475 
476 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/IERC1155MetadataURI.sol)
477 
478 pragma solidity ^0.8.0;
479 
480 
481 /**
482  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
483  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
484  *
485  * _Available since v3.1._
486  */
487 interface IERC1155MetadataURI is IERC1155 {
488     /**
489      * @dev Returns the URI for token type `id`.
490      *
491      * If the `\{id\}` substring is present in the URI, it must be replaced by
492      * clients with the actual token type ID.
493      */
494     function uri(uint256 id) external view returns (string memory);
495 }
496 
497 // File: @openzeppelin/contracts/utils/Strings.sol
498 
499 
500 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
501 
502 pragma solidity ^0.8.0;
503 
504 /**
505  * @dev String operations.
506  */
507 library Strings {
508     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
509 
510     /**
511      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
512      */
513     function toString(uint256 value) internal pure returns (string memory) {
514         // Inspired by OraclizeAPI's implementation - MIT licence
515         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
516 
517         if (value == 0) {
518             return "0";
519         }
520         uint256 temp = value;
521         uint256 digits;
522         while (temp != 0) {
523             digits++;
524             temp /= 10;
525         }
526         bytes memory buffer = new bytes(digits);
527         while (value != 0) {
528             digits -= 1;
529             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
530             value /= 10;
531         }
532         return string(buffer);
533     }
534 
535     /**
536      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
537      */
538     function toHexString(uint256 value) internal pure returns (string memory) {
539         if (value == 0) {
540             return "0x00";
541         }
542         uint256 temp = value;
543         uint256 length = 0;
544         while (temp != 0) {
545             length++;
546             temp >>= 8;
547         }
548         return toHexString(value, length);
549     }
550 
551     /**
552      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
553      */
554     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
555         bytes memory buffer = new bytes(2 * length + 2);
556         buffer[0] = "0";
557         buffer[1] = "x";
558         for (uint256 i = 2 * length + 1; i > 1; --i) {
559             buffer[i] = _HEX_SYMBOLS[value & 0xf];
560             value >>= 4;
561         }
562         require(value == 0, "Strings: hex length insufficient");
563         return string(buffer);
564     }
565 }
566 
567 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
568 
569 
570 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/ECDSA.sol)
571 
572 pragma solidity ^0.8.0;
573 
574 
575 /**
576  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
577  *
578  * These functions can be used to verify that a message was signed by the holder
579  * of the private keys of a given address.
580  */
581 library ECDSA {
582     enum RecoverError {
583         NoError,
584         InvalidSignature,
585         InvalidSignatureLength,
586         InvalidSignatureS,
587         InvalidSignatureV
588     }
589 
590     function _throwError(RecoverError error) private pure {
591         if (error == RecoverError.NoError) {
592             return; // no error: do nothing
593         } else if (error == RecoverError.InvalidSignature) {
594             revert("ECDSA: invalid signature");
595         } else if (error == RecoverError.InvalidSignatureLength) {
596             revert("ECDSA: invalid signature length");
597         } else if (error == RecoverError.InvalidSignatureS) {
598             revert("ECDSA: invalid signature 's' value");
599         } else if (error == RecoverError.InvalidSignatureV) {
600             revert("ECDSA: invalid signature 'v' value");
601         }
602     }
603 
604     /**
605      * @dev Returns the address that signed a hashed message (`hash`) with
606      * `signature` or error string. This address can then be used for verification purposes.
607      *
608      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
609      * this function rejects them by requiring the `s` value to be in the lower
610      * half order, and the `v` value to be either 27 or 28.
611      *
612      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
613      * verification to be secure: it is possible to craft signatures that
614      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
615      * this is by receiving a hash of the original message (which may otherwise
616      * be too long), and then calling {toEthSignedMessageHash} on it.
617      *
618      * Documentation for signature generation:
619      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
620      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
621      *
622      * _Available since v4.3._
623      */
624     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
625         // Check the signature length
626         // - case 65: r,s,v signature (standard)
627         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
628         if (signature.length == 65) {
629             bytes32 r;
630             bytes32 s;
631             uint8 v;
632             // ecrecover takes the signature parameters, and the only way to get them
633             // currently is to use assembly.
634             assembly {
635                 r := mload(add(signature, 0x20))
636                 s := mload(add(signature, 0x40))
637                 v := byte(0, mload(add(signature, 0x60)))
638             }
639             return tryRecover(hash, v, r, s);
640         } else if (signature.length == 64) {
641             bytes32 r;
642             bytes32 vs;
643             // ecrecover takes the signature parameters, and the only way to get them
644             // currently is to use assembly.
645             assembly {
646                 r := mload(add(signature, 0x20))
647                 vs := mload(add(signature, 0x40))
648             }
649             return tryRecover(hash, r, vs);
650         } else {
651             return (address(0), RecoverError.InvalidSignatureLength);
652         }
653     }
654 
655     /**
656      * @dev Returns the address that signed a hashed message (`hash`) with
657      * `signature`. This address can then be used for verification purposes.
658      *
659      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
660      * this function rejects them by requiring the `s` value to be in the lower
661      * half order, and the `v` value to be either 27 or 28.
662      *
663      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
664      * verification to be secure: it is possible to craft signatures that
665      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
666      * this is by receiving a hash of the original message (which may otherwise
667      * be too long), and then calling {toEthSignedMessageHash} on it.
668      */
669     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
670         (address recovered, RecoverError error) = tryRecover(hash, signature);
671         _throwError(error);
672         return recovered;
673     }
674 
675     /**
676      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
677      *
678      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
679      *
680      * _Available since v4.3._
681      */
682     function tryRecover(
683         bytes32 hash,
684         bytes32 r,
685         bytes32 vs
686     ) internal pure returns (address, RecoverError) {
687         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
688         uint8 v = uint8((uint256(vs) >> 255) + 27);
689         return tryRecover(hash, v, r, s);
690     }
691 
692     /**
693      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
694      *
695      * _Available since v4.2._
696      */
697     function recover(
698         bytes32 hash,
699         bytes32 r,
700         bytes32 vs
701     ) internal pure returns (address) {
702         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
703         _throwError(error);
704         return recovered;
705     }
706 
707     /**
708      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
709      * `r` and `s` signature fields separately.
710      *
711      * _Available since v4.3._
712      */
713     function tryRecover(
714         bytes32 hash,
715         uint8 v,
716         bytes32 r,
717         bytes32 s
718     ) internal pure returns (address, RecoverError) {
719         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
720         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
721         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
722         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
723         //
724         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
725         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
726         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
727         // these malleable signatures as well.
728         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
729             return (address(0), RecoverError.InvalidSignatureS);
730         }
731         if (v != 27 && v != 28) {
732             return (address(0), RecoverError.InvalidSignatureV);
733         }
734 
735         // If the signature is valid (and not malleable), return the signer address
736         address signer = ecrecover(hash, v, r, s);
737         if (signer == address(0)) {
738             return (address(0), RecoverError.InvalidSignature);
739         }
740 
741         return (signer, RecoverError.NoError);
742     }
743 
744     /**
745      * @dev Overload of {ECDSA-recover} that receives the `v`,
746      * `r` and `s` signature fields separately.
747      */
748     function recover(
749         bytes32 hash,
750         uint8 v,
751         bytes32 r,
752         bytes32 s
753     ) internal pure returns (address) {
754         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
755         _throwError(error);
756         return recovered;
757     }
758 
759     /**
760      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
761      * produces hash corresponding to the one signed with the
762      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
763      * JSON-RPC method as part of EIP-191.
764      *
765      * See {recover}.
766      */
767     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
768         // 32 is the length in bytes of hash,
769         // enforced by the type signature above
770         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
771     }
772 
773     /**
774      * @dev Returns an Ethereum Signed Message, created from `s`. This
775      * produces hash corresponding to the one signed with the
776      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
777      * JSON-RPC method as part of EIP-191.
778      *
779      * See {recover}.
780      */
781     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
782         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
783     }
784 
785     /**
786      * @dev Returns an Ethereum Signed Typed Data, created from a
787      * `domainSeparator` and a `structHash`. This produces hash corresponding
788      * to the one signed with the
789      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
790      * JSON-RPC method as part of EIP-712.
791      *
792      * See {recover}.
793      */
794     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
795         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
796     }
797 }
798 
799 // File: @openzeppelin/contracts/utils/Context.sol
800 
801 
802 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
803 
804 pragma solidity ^0.8.0;
805 
806 /**
807  * @dev Provides information about the current execution context, including the
808  * sender of the transaction and its data. While these are generally available
809  * via msg.sender and msg.data, they should not be accessed in such a direct
810  * manner, since when dealing with meta-transactions the account sending and
811  * paying for execution may not be the actual sender (as far as an application
812  * is concerned).
813  *
814  * This contract is only required for intermediate, library-like contracts.
815  */
816 abstract contract Context {
817     function _msgSender() internal view virtual returns (address) {
818         return msg.sender;
819     }
820 
821     function _msgData() internal view virtual returns (bytes calldata) {
822         return msg.data;
823     }
824 }
825 
826 // File: @openzeppelin/contracts/access/Ownable.sol
827 
828 
829 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
830 
831 pragma solidity ^0.8.0;
832 
833 
834 /**
835  * @dev Contract module which provides a basic access control mechanism, where
836  * there is an account (an owner) that can be granted exclusive access to
837  * specific functions.
838  *
839  * By default, the owner account will be the one that deploys the contract. This
840  * can later be changed with {transferOwnership}.
841  *
842  * This module is used through inheritance. It will make available the modifier
843  * `onlyOwner`, which can be applied to your functions to restrict their use to
844  * the owner.
845  */
846 abstract contract Ownable is Context {
847     address private _owner;
848 
849     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
850 
851     /**
852      * @dev Initializes the contract setting the deployer as the initial owner.
853      */
854     constructor() {
855         _transferOwnership(_msgSender());
856     }
857 
858     /**
859      * @dev Returns the address of the current owner.
860      */
861     function owner() public view virtual returns (address) {
862         return _owner;
863     }
864 
865     /**
866      * @dev Throws if called by any account other than the owner.
867      */
868     modifier onlyOwner() {
869         require(owner() == _msgSender(), "Ownable: caller is not the owner");
870         _;
871     }
872 
873     /**
874      * @dev Leaves the contract without owner. It will not be possible to call
875      * `onlyOwner` functions anymore. Can only be called by the current owner.
876      *
877      * NOTE: Renouncing ownership will leave the contract without an owner,
878      * thereby removing any functionality that is only available to the owner.
879      */
880     function renounceOwnership() public virtual onlyOwner {
881         _transferOwnership(address(0));
882     }
883 
884     /**
885      * @dev Transfers ownership of the contract to a new account (`newOwner`).
886      * Can only be called by the current owner.
887      */
888     function transferOwnership(address newOwner) public virtual onlyOwner {
889         require(newOwner != address(0), "Ownable: new owner is the zero address");
890         _transferOwnership(newOwner);
891     }
892 
893     /**
894      * @dev Transfers ownership of the contract to a new account (`newOwner`).
895      * Internal function without access restriction.
896      */
897     function _transferOwnership(address newOwner) internal virtual {
898         address oldOwner = _owner;
899         _owner = newOwner;
900         emit OwnershipTransferred(oldOwner, newOwner);
901     }
902 }
903 
904 // File: OwnableTokenAccessControl.sol
905 
906 
907 
908 pragma solidity ^0.8.0;
909 
910 
911 /// @title OwnableTokenAccessControl
912 /// @notice Basic access control for utility tokens 
913 /// @author ponky
914 contract OwnableTokenAccessControl is Ownable {
915     /// @dev Keeps track of how many accounts have been granted each type of access
916     uint96 private _accessCounts;
917 
918     mapping (address => uint256) private _accessFlags;
919 
920     /// @dev Access types
921     enum Access { Mint, Burn, Transfer, Claim }
922 
923     /// @dev Emitted when `account` is granted `access`.
924     event AccessGranted(bytes32 indexed access, address indexed account);
925 
926     /// @dev Emitted when `account` is revoked `access`.
927     event AccessRevoked(bytes32 indexed access, address indexed account);
928 
929     /// @dev Helper constants for fitting each access index into _accessCounts
930     uint constant private _AC_BASE          = 4;
931     uint constant private _AC_MASK_BITSIZE  = 1 << _AC_BASE;
932     uint constant private _AC_DISABLED      = (1 << (_AC_MASK_BITSIZE - 1));
933     uint constant private _AC_MASK_COUNT    = _AC_DISABLED - 1;
934 
935     /// @dev Convert the string `access` to an uint
936     function _accessToIndex(bytes32 access) internal pure virtual returns (uint index) {
937         if (access == 'MINT')       {return uint(Access.Mint);}
938         if (access == 'BURN')       {return uint(Access.Burn);}
939         if (access == 'TRANSFER')   {return uint(Access.Transfer);}
940         if (access == 'CLAIM')      {return uint(Access.Claim);}
941         revert("Access type does not exist");
942     }
943 
944     function _hasAccess(Access access, address account) internal view returns (bool) {
945         return (_accessFlags[account] & (1 << uint(access))) != 0;
946     }
947 
948     function hasAccess(bytes32 access, address account) public view returns (bool) {
949         uint256 flag = 1 << _accessToIndex(access);        
950         return (_accessFlags[account] & flag) != 0;
951     }
952 
953     function grantAccess(bytes32 access, address account) external onlyOwner {
954         require(account.code.length > 0, "Can only grant access to a contract");
955 
956         uint index = _accessToIndex(access);
957         uint256 flags = _accessFlags[account];
958         uint256 newFlags = flags | (1 << index);
959         require(flags != newFlags, "Account already has access");
960         _accessFlags[account] = newFlags;
961 
962         uint shift = index << _AC_BASE;
963         uint256 accessCount = _accessCounts >> shift;
964         require((accessCount & _AC_DISABLED) == 0, "Granting this access is permanently disabled");
965         require((accessCount & _AC_MASK_COUNT) < _AC_MASK_COUNT, "Access limit reached");
966         unchecked {
967             _accessCounts += uint96(1 << shift);
968         }
969         emit AccessGranted(access, account);
970     }
971 
972     function revokeAccess(bytes32 access, address account) external onlyOwner {
973         uint index = _accessToIndex(access);
974         uint256 flags = _accessFlags[account];
975         uint256 newFlags = flags & ~(1 << index);
976         require(flags != newFlags, "Account does not have access");
977         _accessFlags[account] = newFlags;
978 
979         uint shift = index << _AC_BASE;
980         unchecked {
981             _accessCounts -= uint96(1 << shift);
982         }
983 
984         emit AccessRevoked(access, account);
985     }
986 
987     /// @dev Returns the number of contracts that have `access`.
988     function countOfAccess(bytes32 access) external view returns (uint256 accessCount) {
989         uint index = _accessToIndex(access);
990 
991         uint shift = index << _AC_BASE;
992         accessCount = (_accessCounts >> shift) & _AC_MASK_COUNT;
993     }
994 
995     /// @dev `access` can still be revoked but not granted
996     function permanentlyDisableGrantingAccess(bytes32 access) external onlyOwner {
997         uint index = _accessToIndex(access);
998         
999         uint shift = index << _AC_BASE;
1000         uint256 flag = _AC_DISABLED << shift;
1001         uint256 accessCounts = _accessCounts;
1002         require((accessCounts & flag) == 0, "Granting this access is already disabled");
1003         _accessCounts = uint96(accessCounts | flag);
1004     }
1005 }
1006 
1007 // File: ERC1155.sol
1008 
1009 
1010 // Adapted from OpenZeppelin Contracts v4.4.1 (token/ERC1155/ERC1155.sol)
1011 
1012 pragma solidity ^0.8.0;
1013 
1014 
1015 
1016 
1017 
1018 
1019 
1020 
1021 /**
1022  * @dev Extended implementation of the basic standard multi-token.
1023  * See https://eips.ethereum.org/EIPS/eip-1155
1024  * Originally based on code by OpenZeppelin: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC1155/ERC1155.sol
1025  * and Enjin: https://github.com/enjin/erc-1155
1026  *
1027  * _Available since v3.1._
1028  *
1029  */
1030 
1031 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI, OwnableTokenAccessControl {
1032     using Address for address;
1033 
1034     // Mapping from token ID to account balances
1035     mapping(uint256 => mapping(address => uint256)) private _balances;
1036 
1037     enum Approval {
1038         Unknown,
1039         NotApproved,
1040         Approved
1041     }
1042 
1043     // Mapping from account to operator approvals
1044     mapping(address => mapping(address => Approval)) private _operatorApprovals;
1045 
1046 
1047     constructor() {
1048 
1049     }
1050 
1051     /**
1052      * @dev See {IERC165-supportsInterface}.
1053      */
1054     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1055         return
1056             interfaceId == type(IERC1155).interfaceId ||
1057             interfaceId == type(IERC1155MetadataURI).interfaceId ||
1058             super.supportsInterface(interfaceId);
1059     }
1060 
1061     /**
1062      * @dev See {IERC1155MetadataURI-uri}.
1063      *
1064      * This implementation returns the same URI for *all* token types. It relies
1065      * on the token type ID substitution mechanism
1066      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1067      *
1068      * Clients calling this function must replace the `\{id\}` substring with the
1069      * actual token type ID.
1070      */
1071     function uri(uint256) public view virtual override returns (string memory) {
1072         return "";
1073     }
1074 
1075     /**
1076      * @dev See {IERC1155-balanceOf}.
1077      *
1078      * Requirements:
1079      *
1080      * - `account` cannot be the zero address.
1081      */
1082     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
1083         require(account != address(0), "ERC1155: balance query for the zero address");
1084         return _balances[id][account];
1085     }
1086 
1087     /**
1088      * @dev See {IERC1155-balanceOfBatch}.
1089      *
1090      * Requirements:
1091      *
1092      * - `accounts` and `ids` must have the same length.
1093      */
1094     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
1095         public
1096         view
1097         virtual
1098         override
1099         returns (uint256[] memory)
1100     {
1101         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
1102 
1103         uint256[] memory batchBalances = new uint256[](accounts.length);
1104 
1105         for (uint256 i = 0; i < accounts.length; ++i) {
1106             batchBalances[i] = balanceOf(accounts[i], ids[i]);
1107         }
1108 
1109         return batchBalances;
1110     }
1111 
1112     /**
1113      *
1114      * Requirements:
1115      *
1116      * - `account` cannot be the zero address.
1117      */
1118     function balanceOfBatchIds(address account, uint256[] memory ids)
1119         public
1120         view
1121         virtual
1122         returns (uint256[] memory)
1123     {
1124         require(account != address(0), "ERC1155: balance query for the zero address");
1125 
1126         uint256[] memory batchBalances = new uint256[](ids.length);
1127 
1128         for (uint256 i = 0; i < ids.length; ++i) {
1129             batchBalances[i] = _balances[ids[i]][account];
1130         }
1131 
1132         return batchBalances;
1133     }
1134 
1135     /**
1136      * @dev See {IERC1155-setApprovalForAll}.
1137      */
1138     function setApprovalForAll(address operator, bool approved) public virtual override {
1139         _setApprovalForAll(_msgSender(), operator, approved);
1140     }
1141 
1142     /**
1143      * @dev See {IERC1155-isApprovedForAll}.
1144      */
1145     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
1146         return _operatorApprovals[account][operator] == Approval.Approved;
1147     }
1148 
1149     /**
1150      * @dev See {IERC1155-safeTransferFrom}.
1151      */
1152     function safeTransferFrom(
1153         address from,
1154         address to,
1155         uint256 id,
1156         uint256 amount,
1157         bytes memory data
1158     ) public virtual override {
1159         require(
1160             from == _msgSender() || _isApprovedForAllOrHasAccess(from, _msgSender(), Access.Transfer),
1161             "ERC1155: caller is not owner nor approved"
1162         );
1163         _safeTransferFrom(from, to, id, amount, data);
1164     }
1165 
1166     /**
1167      * @dev See {IERC1155-safeBatchTransferFrom}.
1168      */
1169     function safeBatchTransferFrom(
1170         address from,
1171         address to,
1172         uint256[] memory ids,
1173         uint256[] memory amounts,
1174         bytes memory data
1175     ) public virtual override {
1176         require(
1177             from == _msgSender() || _isApprovedForAllOrHasAccess(from, _msgSender(), Access.Transfer),
1178             "ERC1155: transfer caller is not owner nor approved"
1179         );
1180         _safeBatchTransferFrom(from, to, ids, amounts, data);
1181     }
1182 
1183     /**
1184      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
1185      *
1186      * Emits a {TransferSingle} event.
1187      *
1188      * Requirements:
1189      *
1190      * - `to` cannot be the zero address.
1191      * - `from` must have a balance of tokens of type `id` of at least `amount`.
1192      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1193      * acceptance magic value.
1194      */
1195     function _safeTransferFrom(
1196         address from,
1197         address to,
1198         uint256 id,
1199         uint256 amount,
1200         bytes memory data
1201     ) internal virtual {
1202         require(to != address(0), "ERC1155: transfer to the zero address");
1203 
1204         address operator = _msgSender();
1205 
1206         uint256 fromBalance = _balances[id][from];
1207         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
1208         unchecked {
1209             _balances[id][from] = fromBalance - amount;
1210         }
1211         _balances[id][to] += amount;
1212 
1213         emit TransferSingle(operator, from, to, id, amount);
1214 
1215         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
1216     }
1217 
1218     /**
1219      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
1220      *
1221      * Emits a {TransferBatch} event.
1222      *
1223      * Requirements:
1224      *
1225      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1226      * acceptance magic value.
1227      */
1228     function _safeBatchTransferFrom(
1229         address from,
1230         address to,
1231         uint256[] memory ids,
1232         uint256[] memory amounts,
1233         bytes memory data
1234     ) internal virtual {
1235         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1236         require(to != address(0), "ERC1155: transfer to the zero address");
1237 
1238         address operator = _msgSender();
1239 
1240         for (uint256 i = 0; i < ids.length; ++i) {
1241             uint256 id = ids[i];
1242             uint256 amount = amounts[i];
1243 
1244             uint256 fromBalance = _balances[id][from];
1245             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
1246             unchecked {
1247                 _balances[id][from] = fromBalance - amount;
1248             }
1249             _balances[id][to] += amount;
1250         }
1251 
1252         emit TransferBatch(operator, from, to, ids, amounts);
1253 
1254         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
1255     }
1256 
1257 
1258     
1259 
1260     /**
1261      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
1262      *
1263      * Emits a {TransferSingle} event.
1264      *
1265      * Requirements:
1266      *
1267      * - `to` cannot be the zero address.
1268      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1269      * acceptance magic value.
1270      */
1271     function _safeMint(
1272         address to,
1273         uint256 id,
1274         uint256 amount,
1275         bytes memory data
1276     ) internal virtual {
1277         require(to != address(0), "ERC1155: mint to the zero address");
1278 
1279         address operator = _msgSender();
1280 
1281         _balances[id][to] += amount;
1282         emit TransferSingle(operator, address(0), to, id, amount);
1283 
1284         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
1285     }
1286 
1287     /**
1288      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeMint}.
1289      *
1290      * Requirements:
1291      *
1292      * - `ids` and `amounts` must have the same length.
1293      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1294      * acceptance magic value.
1295      */
1296     function _safeMintBatch(
1297         address to,
1298         uint256[] memory ids,
1299         uint256[] memory amounts,
1300         bytes memory data
1301     ) internal virtual {
1302         require(to != address(0), "ERC1155: mint to the zero address");
1303         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1304 
1305         address operator = _msgSender();
1306 
1307         for (uint256 i = 0; i < ids.length; i++) {
1308             _balances[ids[i]][to] += amounts[i];
1309         }
1310 
1311         emit TransferBatch(operator, address(0), to, ids, amounts);
1312 
1313         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
1314     }
1315 
1316 
1317 
1318     function burn(
1319         address account,
1320         uint256 id,
1321         uint256 amount
1322     ) external {
1323         require(
1324             account == _msgSender() || _isApprovedForAllOrHasAccess(account, _msgSender(), Access.Burn),
1325             "ERC1155: caller is not owner nor approved"
1326         );
1327 
1328         _burn(account, id, amount);
1329     }
1330 
1331     function burnBatch(
1332         address account,
1333         uint256[] memory ids,
1334         uint256[] memory amounts
1335     ) external {
1336         require(
1337             account == _msgSender() || _isApprovedForAllOrHasAccess(account, _msgSender(), Access.Burn),
1338             "ERC1155: caller is not owner nor approved"
1339         );
1340 
1341         _burnBatch(account, ids, amounts);
1342     }
1343 
1344     /**
1345      * @dev Destroys `amount` tokens of token type `id` from `from`
1346      *
1347      * Requirements:
1348      *
1349      * - `from` cannot be the zero address.
1350      * - `from` must have at least `amount` tokens of token type `id`.
1351      */
1352     function _burn(
1353         address from,
1354         uint256 id,
1355         uint256 amount
1356     ) internal virtual {
1357         require(from != address(0), "ERC1155: burn from the zero address");
1358 
1359         address operator = _msgSender();
1360 
1361         uint256 fromBalance = _balances[id][from];
1362         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1363         unchecked {
1364             _balances[id][from] = fromBalance - amount;
1365         }
1366 
1367         emit TransferSingle(operator, from, address(0), id, amount);
1368     }
1369 
1370     /**
1371      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
1372      *
1373      * Requirements:
1374      *
1375      * - `ids` and `amounts` must have the same length.
1376      */
1377     function _burnBatch(
1378         address from,
1379         uint256[] memory ids,
1380         uint256[] memory amounts
1381     ) internal virtual {
1382         require(from != address(0), "ERC1155: burn from the zero address");
1383         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1384 
1385         address operator = _msgSender();
1386 
1387         for (uint256 i = 0; i < ids.length; i++) {
1388             uint256 id = ids[i];
1389             uint256 amount = amounts[i];
1390 
1391             uint256 fromBalance = _balances[id][from];
1392             require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1393             unchecked {
1394                 _balances[id][from] = fromBalance - amount;
1395             }
1396         }
1397 
1398         emit TransferBatch(operator, from, address(0), ids, amounts);
1399     }
1400 
1401 
1402     function _isApprovedForAllOrHasAccess(
1403         address account,
1404         address operator,
1405         Access access
1406     ) internal virtual returns (bool) {
1407         Approval aproval = _operatorApprovals[account][operator];
1408         if (aproval == Approval.Approved) {
1409             return true;
1410         }
1411         if (aproval == Approval.NotApproved) {
1412             return false;
1413         }
1414 
1415         return _hasAccess(access, operator);
1416     }
1417 
1418     /**
1419      * @dev Approve `operator` to operate on all of `owner` tokens
1420      *
1421      * Emits a {ApprovalForAll} event.
1422      */
1423     function _setApprovalForAll(
1424         address owner,
1425         address operator,
1426         bool approved
1427     ) internal virtual {
1428         require(owner != operator, "ERC1155: setting approval status for self");
1429         _operatorApprovals[owner][operator] = approved ? Approval.Approved : Approval.NotApproved;
1430         emit ApprovalForAll(owner, operator, approved);
1431     }
1432 
1433 
1434     function _doSafeTransferAcceptanceCheck(
1435         address operator,
1436         address from,
1437         address to,
1438         uint256 id,
1439         uint256 amount,
1440         bytes memory data
1441     ) private {
1442         if (to.isContract()) {
1443             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
1444                 if (response != IERC1155Receiver.onERC1155Received.selector) {
1445                     revert("ERC1155: ERC1155Receiver rejected tokens");
1446                 }
1447             } catch Error(string memory reason) {
1448                 revert(reason);
1449             } catch {
1450                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1451             }
1452         }
1453     }
1454 
1455     function _doSafeBatchTransferAcceptanceCheck(
1456         address operator,
1457         address from,
1458         address to,
1459         uint256[] memory ids,
1460         uint256[] memory amounts,
1461         bytes memory data
1462     ) private {
1463         if (to.isContract()) {
1464             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
1465                 bytes4 response
1466             ) {
1467                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
1468                     revert("ERC1155: ERC1155Receiver rejected tokens");
1469                 }
1470             } catch Error(string memory reason) {
1471                 revert(reason);
1472             } catch {
1473                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1474             }
1475         }
1476     }
1477 }
1478 
1479 // File: Traits.sol
1480 
1481 
1482 pragma solidity =0.8.13;
1483 
1484 
1485 
1486 contract Traits is ERC1155 {
1487     constructor() ERC1155() {}
1488 
1489     string private _uriBase;
1490     string private _extension;
1491 
1492     function name() public pure returns (string memory) {
1493         return "TestTraits";
1494     }
1495 
1496     function symbol() public pure returns (string memory) {
1497         return "TRAIT";
1498     }
1499 
1500     function setURI(string memory uriBase) public onlyOwner {
1501         _uriBase = uriBase;
1502     }
1503 
1504     function setURIExtension(string memory extension) public onlyOwner {
1505         _extension = extension;
1506     }
1507 
1508     function uri(uint256 tokenId) override public view returns (string memory) {
1509         return string(abi.encodePacked(_uriBase, Strings.toString(tokenId), _extension));
1510     }
1511 
1512     function mint(address to, uint256 id, uint256 amount) external {
1513         require(_hasAccess(Access.Mint, _msgSender()), "Not allowed to mint");
1514         _safeMint(to, id, amount, "");
1515     }
1516 
1517     function mintBatch(address to, uint256[] memory ids, uint256[] memory amounts) external {
1518         require(_hasAccess(Access.Mint, _msgSender()), "Not allowed to mint");
1519         _safeMintBatch(to, ids, amounts, "");
1520     }
1521 }
1522 
1523 // File: TraitsMint.sol
1524 
1525 
1526 pragma solidity =0.8.13;
1527 
1528 
1529 
1530 
1531 contract TraitsMint is Ownable {
1532     address private _signerAddress;
1533     bool public isClaimingEnabled;
1534     mapping(address => bool) private _claimers;
1535     mapping(address => mapping(uint256 => uint256)) private _nonces;
1536 
1537     address private immutable _traitsContract;
1538 
1539     constructor(address traitsContract) {
1540         _traitsContract = traitsContract;
1541     }
1542 
1543     modifier canClaim() {
1544         require(isClaimingEnabled, "Claiming is disabled");
1545         _;
1546     }
1547 
1548     function claimMultiple(uint256[] calldata ids, uint256[] calldata amounts, address account, uint256[] calldata nonces, uint256 deadlineTimestamp, bytes32 signatureR, bytes32 signatureVS) external canClaim {
1549         require(msg.sender == account || _claimers[msg.sender], "Not allowed to claim");
1550         require(deadlineTimestamp == 0 || deadlineTimestamp > block.timestamp, "Deadline to claim has passed");
1551 
1552         {
1553             bytes32 hash = keccak256(abi.encode(ids, amounts, account, nonces, deadlineTimestamp));
1554             require(_signerAddress == ECDSA.recover(hash,  signatureR,  signatureVS), "Invalid signature");
1555         }
1556 
1557         unchecked {
1558             uint256 length = nonces.length;
1559             require(length > 0, "nonces array is empty");
1560             uint256 nonceIndex = nonces[0];
1561             uint256 mask = 1 << (nonceIndex & 0xff);
1562             nonceIndex >>= 8;            
1563             for (uint256 i=1; i<length; ++i) {
1564                 uint256 nonce = nonces[i];
1565                 uint256 i_nonceIndex = nonce >> 8;
1566                 if (i_nonceIndex != nonceIndex) {
1567                     uint256 noncePacked = _nonces[account][nonceIndex];
1568                     require((noncePacked & mask) == 0, "Already claimed");
1569                     _nonces[account][nonceIndex] = noncePacked | mask;
1570 
1571                     nonceIndex = i_nonceIndex;
1572                     mask = 0;
1573                 }
1574                 mask |= (1 << (nonce & 0xff));
1575             }
1576             
1577             {
1578                 uint256 noncePacked = _nonces[account][nonceIndex];
1579                 require((noncePacked & mask) == 0, "Already claimed");
1580                 _nonces[account][nonceIndex] = noncePacked | mask;
1581             }
1582         }
1583         
1584         Traits(_traitsContract).mintBatch(account, ids, amounts);
1585     }
1586 
1587     function claim(uint256[] calldata ids, uint256[] calldata amounts, address account, uint256 nonce, uint256 deadlineTimestamp, bytes32 signatureR, bytes32 signatureVS) external canClaim {
1588         require(msg.sender == account || _claimers[msg.sender], "Not allowed to claim");
1589         require(deadlineTimestamp == 0 || deadlineTimestamp > block.timestamp, "Deadline to claim has passed");
1590 
1591         {
1592             bytes32 hash = keccak256(abi.encode(ids, amounts, account, nonce, deadlineTimestamp));
1593             require(_signerAddress == ECDSA.recover(hash,  signatureR,  signatureVS), "Invalid signature");
1594         }
1595         
1596         uint256 nonceIndex = nonce >> 8;
1597         uint256 noncePacked = _nonces[account][nonceIndex];
1598         uint256 noncePackedNew = noncePacked | (1 << (nonce & 0xff));
1599         require(noncePacked != noncePackedNew, "Already claimed");
1600         _nonces[account][nonceIndex] = noncePackedNew;
1601         
1602         Traits(_traitsContract).mintBatch(account, ids, amounts);
1603     }
1604 
1605 
1606     function isNonceClaimed(address account, uint256 nonce) external view returns(bool) {
1607         uint256 nonceIndex = nonce >> 8;
1608         return (_nonces[account][nonceIndex] & (1 << (nonce & 0xff))) != 0;
1609     }
1610 
1611     function areNoncesClaimed(address account, uint256[] calldata nonces) external view returns(bool[] memory) {
1612         uint256 length = nonces.length;
1613         bool[] memory results = new bool[](length);
1614         unchecked {
1615             for (uint256 i=0; i<length; ++i) {
1616                 uint256 nonce = nonces[i];
1617                 uint256 nonceIndex = nonce >> 8;
1618                 results[i] = (_nonces[account][nonceIndex] & (1 << (nonce & 0xff))) != 0;
1619             }
1620         }
1621         return results;
1622     }
1623 
1624 
1625 
1626     function setSignerAddress(address signerAddress) external onlyOwner {
1627         _signerAddress = signerAddress;
1628     }
1629 
1630     function setClaimer(address claimer, bool enabled) external onlyOwner {
1631         require(claimer != address(0), "Invalid claimer");
1632         _claimers[claimer] = enabled;
1633     }
1634 
1635     function setClaimingEnabled(bool enabled) external onlyOwner {
1636         isClaimingEnabled = enabled;
1637     }
1638 }