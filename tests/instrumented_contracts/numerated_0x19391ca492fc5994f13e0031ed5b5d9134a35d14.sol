1 // File: @openzeppelin/contracts/utils/Counters.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @title Counters
10  * @author Matt Condon (@shrugs)
11  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
12  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
13  *
14  * Include with `using Counters for Counters.Counter;`
15  */
16 library Counters {
17     struct Counter {
18         // This variable should never be directly accessed by users of the library: interactions must be restricted to
19         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
20         // this feature: see https://github.com/ethereum/solidity/issues/4637
21         uint256 _value; // default: 0
22     }
23 
24     function current(Counter storage counter) internal view returns (uint256) {
25         return counter._value;
26     }
27 
28     function increment(Counter storage counter) internal {
29         unchecked {
30             counter._value += 1;
31         }
32     }
33 
34     function decrement(Counter storage counter) internal {
35         uint256 value = counter._value;
36         require(value > 0, "Counter: decrement overflow");
37         unchecked {
38             counter._value = value - 1;
39         }
40     }
41 
42     function reset(Counter storage counter) internal {
43         counter._value = 0;
44     }
45 }
46 
47 // File: @openzeppelin/contracts/utils/Address.sol
48 
49 
50 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
51 
52 pragma solidity ^0.8.1;
53 
54 /**
55  * @dev Collection of functions related to the address type
56  */
57 library Address {
58     /**
59      * @dev Returns true if `account` is a contract.
60      *
61      * [IMPORTANT]
62      * ====
63      * It is unsafe to assume that an address for which this function returns
64      * false is an externally-owned account (EOA) and not a contract.
65      *
66      * Among others, `isContract` will return false for the following
67      * types of addresses:
68      *
69      *  - an externally-owned account
70      *  - a contract in construction
71      *  - an address where a contract will be created
72      *  - an address where a contract lived, but was destroyed
73      * ====
74      *
75      * [IMPORTANT]
76      * ====
77      * You shouldn't rely on `isContract` to protect against flash loan attacks!
78      *
79      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
80      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
81      * constructor.
82      * ====
83      */
84     function isContract(address account) internal view returns (bool) {
85         // This method relies on extcodesize/address.code.length, which returns 0
86         // for contracts in construction, since the code is only stored at the end
87         // of the constructor execution.
88 
89         return account.code.length > 0;
90     }
91 
92     /**
93      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
94      * `recipient`, forwarding all available gas and reverting on errors.
95      *
96      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
97      * of certain opcodes, possibly making contracts go over the 2300 gas limit
98      * imposed by `transfer`, making them unable to receive funds via
99      * `transfer`. {sendValue} removes this limitation.
100      *
101      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
102      *
103      * IMPORTANT: because control is transferred to `recipient`, care must be
104      * taken to not create reentrancy vulnerabilities. Consider using
105      * {ReentrancyGuard} or the
106      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
107      */
108     function sendValue(address payable recipient, uint256 amount) internal {
109         require(address(this).balance >= amount, "Address: insufficient balance");
110 
111         (bool success, ) = recipient.call{value: amount}("");
112         require(success, "Address: unable to send value, recipient may have reverted");
113     }
114 
115     /**
116      * @dev Performs a Solidity function call using a low level `call`. A
117      * plain `call` is an unsafe replacement for a function call: use this
118      * function instead.
119      *
120      * If `target` reverts with a revert reason, it is bubbled up by this
121      * function (like regular Solidity function calls).
122      *
123      * Returns the raw returned data. To convert to the expected return value,
124      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
125      *
126      * Requirements:
127      *
128      * - `target` must be a contract.
129      * - calling `target` with `data` must not revert.
130      *
131      * _Available since v3.1._
132      */
133     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
134         return functionCall(target, data, "Address: low-level call failed");
135     }
136 
137     /**
138      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
139      * `errorMessage` as a fallback revert reason when `target` reverts.
140      *
141      * _Available since v3.1._
142      */
143     function functionCall(
144         address target,
145         bytes memory data,
146         string memory errorMessage
147     ) internal returns (bytes memory) {
148         return functionCallWithValue(target, data, 0, errorMessage);
149     }
150 
151     /**
152      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
153      * but also transferring `value` wei to `target`.
154      *
155      * Requirements:
156      *
157      * - the calling contract must have an ETH balance of at least `value`.
158      * - the called Solidity function must be `payable`.
159      *
160      * _Available since v3.1._
161      */
162     function functionCallWithValue(
163         address target,
164         bytes memory data,
165         uint256 value
166     ) internal returns (bytes memory) {
167         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
168     }
169 
170     /**
171      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
172      * with `errorMessage` as a fallback revert reason when `target` reverts.
173      *
174      * _Available since v3.1._
175      */
176     function functionCallWithValue(
177         address target,
178         bytes memory data,
179         uint256 value,
180         string memory errorMessage
181     ) internal returns (bytes memory) {
182         require(address(this).balance >= value, "Address: insufficient balance for call");
183         require(isContract(target), "Address: call to non-contract");
184 
185         (bool success, bytes memory returndata) = target.call{value: value}(data);
186         return verifyCallResult(success, returndata, errorMessage);
187     }
188 
189     /**
190      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
191      * but performing a static call.
192      *
193      * _Available since v3.3._
194      */
195     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
196         return functionStaticCall(target, data, "Address: low-level static call failed");
197     }
198 
199     /**
200      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
201      * but performing a static call.
202      *
203      * _Available since v3.3._
204      */
205     function functionStaticCall(
206         address target,
207         bytes memory data,
208         string memory errorMessage
209     ) internal view returns (bytes memory) {
210         require(isContract(target), "Address: static call to non-contract");
211 
212         (bool success, bytes memory returndata) = target.staticcall(data);
213         return verifyCallResult(success, returndata, errorMessage);
214     }
215 
216     /**
217      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
218      * but performing a delegate call.
219      *
220      * _Available since v3.4._
221      */
222     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
223         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
224     }
225 
226     /**
227      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
228      * but performing a delegate call.
229      *
230      * _Available since v3.4._
231      */
232     function functionDelegateCall(
233         address target,
234         bytes memory data,
235         string memory errorMessage
236     ) internal returns (bytes memory) {
237         require(isContract(target), "Address: delegate call to non-contract");
238 
239         (bool success, bytes memory returndata) = target.delegatecall(data);
240         return verifyCallResult(success, returndata, errorMessage);
241     }
242 
243     /**
244      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
245      * revert reason using the provided one.
246      *
247      * _Available since v4.3._
248      */
249     function verifyCallResult(
250         bool success,
251         bytes memory returndata,
252         string memory errorMessage
253     ) internal pure returns (bytes memory) {
254         if (success) {
255             return returndata;
256         } else {
257             // Look for revert reason and bubble it up if present
258             if (returndata.length > 0) {
259                 // The easiest way to bubble the revert reason is using memory via assembly
260                 /// @solidity memory-safe-assembly
261                 assembly {
262                     let returndata_size := mload(returndata)
263                     revert(add(32, returndata), returndata_size)
264                 }
265             } else {
266                 revert(errorMessage);
267             }
268         }
269     }
270 }
271 
272 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
273 
274 
275 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
276 
277 pragma solidity ^0.8.0;
278 
279 /**
280  * @title ERC721 token receiver interface
281  * @dev Interface for any contract that wants to support safeTransfers
282  * from ERC721 asset contracts.
283  */
284 interface IERC721Receiver {
285     /**
286      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
287      * by `operator` from `from`, this function is called.
288      *
289      * It must return its Solidity selector to confirm the token transfer.
290      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
291      *
292      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
293      */
294     function onERC721Received(
295         address operator,
296         address from,
297         uint256 tokenId,
298         bytes calldata data
299     ) external returns (bytes4);
300 }
301 
302 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
303 
304 
305 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
306 
307 pragma solidity ^0.8.0;
308 
309 /**
310  * @dev Interface of the ERC165 standard, as defined in the
311  * https://eips.ethereum.org/EIPS/eip-165[EIP].
312  *
313  * Implementers can declare support of contract interfaces, which can then be
314  * queried by others ({ERC165Checker}).
315  *
316  * For an implementation, see {ERC165}.
317  */
318 interface IERC165 {
319     /**
320      * @dev Returns true if this contract implements the interface defined by
321      * `interfaceId`. See the corresponding
322      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
323      * to learn more about how these ids are created.
324      *
325      * This function call must use less than 30 000 gas.
326      */
327     function supportsInterface(bytes4 interfaceId) external view returns (bool);
328 }
329 
330 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
331 
332 
333 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
334 
335 pragma solidity ^0.8.0;
336 
337 
338 /**
339  * @dev Required interface of an ERC721 compliant contract.
340  */
341 interface IERC721 is IERC165 {
342     /**
343      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
344      */
345     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
346 
347     /**
348      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
349      */
350     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
351 
352     /**
353      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
354      */
355     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
356 
357     /**
358      * @dev Returns the number of tokens in ``owner``'s account.
359      */
360     function balanceOf(address owner) external view returns (uint256 balance);
361 
362     /**
363      * @dev Returns the owner of the `tokenId` token.
364      *
365      * Requirements:
366      *
367      * - `tokenId` must exist.
368      */
369     function ownerOf(uint256 tokenId) external view returns (address owner);
370 
371     /**
372      * @dev Safely transfers `tokenId` token from `from` to `to`.
373      *
374      * Requirements:
375      *
376      * - `from` cannot be the zero address.
377      * - `to` cannot be the zero address.
378      * - `tokenId` token must exist and be owned by `from`.
379      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
380      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
381      *
382      * Emits a {Transfer} event.
383      */
384     function safeTransferFrom(
385         address from,
386         address to,
387         uint256 tokenId,
388         bytes calldata data
389     ) external;
390 
391     /**
392      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
393      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
394      *
395      * Requirements:
396      *
397      * - `from` cannot be the zero address.
398      * - `to` cannot be the zero address.
399      * - `tokenId` token must exist and be owned by `from`.
400      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
401      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
402      *
403      * Emits a {Transfer} event.
404      */
405     function safeTransferFrom(
406         address from,
407         address to,
408         uint256 tokenId
409     ) external;
410 
411     /**
412      * @dev Transfers `tokenId` token from `from` to `to`.
413      *
414      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
415      *
416      * Requirements:
417      *
418      * - `from` cannot be the zero address.
419      * - `to` cannot be the zero address.
420      * - `tokenId` token must be owned by `from`.
421      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
422      *
423      * Emits a {Transfer} event.
424      */
425     function transferFrom(
426         address from,
427         address to,
428         uint256 tokenId
429     ) external;
430 
431     /**
432      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
433      * The approval is cleared when the token is transferred.
434      *
435      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
436      *
437      * Requirements:
438      *
439      * - The caller must own the token or be an approved operator.
440      * - `tokenId` must exist.
441      *
442      * Emits an {Approval} event.
443      */
444     function approve(address to, uint256 tokenId) external;
445 
446     /**
447      * @dev Approve or remove `operator` as an operator for the caller.
448      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
449      *
450      * Requirements:
451      *
452      * - The `operator` cannot be the caller.
453      *
454      * Emits an {ApprovalForAll} event.
455      */
456     function setApprovalForAll(address operator, bool _approved) external;
457 
458     /**
459      * @dev Returns the account approved for `tokenId` token.
460      *
461      * Requirements:
462      *
463      * - `tokenId` must exist.
464      */
465     function getApproved(uint256 tokenId) external view returns (address operator);
466 
467     /**
468      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
469      *
470      * See {setApprovalForAll}
471      */
472     function isApprovedForAll(address owner, address operator) external view returns (bool);
473 }
474 
475 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
476 
477 
478 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
479 
480 pragma solidity ^0.8.0;
481 
482 
483 /**
484  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
485  * @dev See https://eips.ethereum.org/EIPS/eip-721
486  */
487 interface IERC721Metadata is IERC721 {
488     /**
489      * @dev Returns the token collection name.
490      */
491     function name() external view returns (string memory);
492 
493     /**
494      * @dev Returns the token collection symbol.
495      */
496     function symbol() external view returns (string memory);
497 
498     /**
499      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
500      */
501     function tokenURI(uint256 tokenId) external view returns (string memory);
502 }
503 
504 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
505 
506 
507 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
508 
509 pragma solidity ^0.8.0;
510 
511 
512 /**
513  * @dev Implementation of the {IERC165} interface.
514  *
515  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
516  * for the additional interface id that will be supported. For example:
517  *
518  * ```solidity
519  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
520  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
521  * }
522  * ```
523  *
524  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
525  */
526 abstract contract ERC165 is IERC165 {
527     /**
528      * @dev See {IERC165-supportsInterface}.
529      */
530     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
531         return interfaceId == type(IERC165).interfaceId;
532     }
533 }
534 
535 // File: @openzeppelin/contracts/utils/Strings.sol
536 
537 
538 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
539 
540 pragma solidity ^0.8.0;
541 
542 /**
543  * @dev String operations.
544  */
545 library Strings {
546     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
547     uint8 private constant _ADDRESS_LENGTH = 20;
548 
549     /**
550      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
551      */
552     function toString(uint256 value) internal pure returns (string memory) {
553         // Inspired by OraclizeAPI's implementation - MIT licence
554         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
555 
556         if (value == 0) {
557             return "0";
558         }
559         uint256 temp = value;
560         uint256 digits;
561         while (temp != 0) {
562             digits++;
563             temp /= 10;
564         }
565         bytes memory buffer = new bytes(digits);
566         while (value != 0) {
567             digits -= 1;
568             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
569             value /= 10;
570         }
571         return string(buffer);
572     }
573 
574     /**
575      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
576      */
577     function toHexString(uint256 value) internal pure returns (string memory) {
578         if (value == 0) {
579             return "0x00";
580         }
581         uint256 temp = value;
582         uint256 length = 0;
583         while (temp != 0) {
584             length++;
585             temp >>= 8;
586         }
587         return toHexString(value, length);
588     }
589 
590     /**
591      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
592      */
593     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
594         bytes memory buffer = new bytes(2 * length + 2);
595         buffer[0] = "0";
596         buffer[1] = "x";
597         for (uint256 i = 2 * length + 1; i > 1; --i) {
598             buffer[i] = _HEX_SYMBOLS[value & 0xf];
599             value >>= 4;
600         }
601         require(value == 0, "Strings: hex length insufficient");
602         return string(buffer);
603     }
604 
605     /**
606      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
607      */
608     function toHexString(address addr) internal pure returns (string memory) {
609         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
610     }
611 }
612 
613 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
614 
615 
616 // OpenZeppelin Contracts (last updated v4.7.3) (utils/cryptography/ECDSA.sol)
617 
618 pragma solidity ^0.8.0;
619 
620 
621 /**
622  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
623  *
624  * These functions can be used to verify that a message was signed by the holder
625  * of the private keys of a given address.
626  */
627 library ECDSA {
628     enum RecoverError {
629         NoError,
630         InvalidSignature,
631         InvalidSignatureLength,
632         InvalidSignatureS,
633         InvalidSignatureV
634     }
635 
636     function _throwError(RecoverError error) private pure {
637         if (error == RecoverError.NoError) {
638             return; // no error: do nothing
639         } else if (error == RecoverError.InvalidSignature) {
640             revert("ECDSA: invalid signature");
641         } else if (error == RecoverError.InvalidSignatureLength) {
642             revert("ECDSA: invalid signature length");
643         } else if (error == RecoverError.InvalidSignatureS) {
644             revert("ECDSA: invalid signature 's' value");
645         } else if (error == RecoverError.InvalidSignatureV) {
646             revert("ECDSA: invalid signature 'v' value");
647         }
648     }
649 
650     /**
651      * @dev Returns the address that signed a hashed message (`hash`) with
652      * `signature` or error string. This address can then be used for verification purposes.
653      *
654      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
655      * this function rejects them by requiring the `s` value to be in the lower
656      * half order, and the `v` value to be either 27 or 28.
657      *
658      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
659      * verification to be secure: it is possible to craft signatures that
660      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
661      * this is by receiving a hash of the original message (which may otherwise
662      * be too long), and then calling {toEthSignedMessageHash} on it.
663      *
664      * Documentation for signature generation:
665      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
666      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
667      *
668      * _Available since v4.3._
669      */
670     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
671         if (signature.length == 65) {
672             bytes32 r;
673             bytes32 s;
674             uint8 v;
675             // ecrecover takes the signature parameters, and the only way to get them
676             // currently is to use assembly.
677             /// @solidity memory-safe-assembly
678             assembly {
679                 r := mload(add(signature, 0x20))
680                 s := mload(add(signature, 0x40))
681                 v := byte(0, mload(add(signature, 0x60)))
682             }
683             return tryRecover(hash, v, r, s);
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
860 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
861 
862 
863 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
864 
865 pragma solidity ^0.8.0;
866 
867 
868 
869 
870 
871 
872 
873 
874 /**
875  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
876  * the Metadata extension, but not including the Enumerable extension, which is available separately as
877  * {ERC721Enumerable}.
878  */
879 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
880     using Address for address;
881     using Strings for uint256;
882 
883     // Token name
884     string private _name;
885 
886     // Token symbol
887     string private _symbol;
888 
889     // Mapping from token ID to owner address
890     mapping(uint256 => address) private _owners;
891 
892     // Mapping owner address to token count
893     mapping(address => uint256) private _balances;
894 
895     // Mapping from token ID to approved address
896     mapping(uint256 => address) private _tokenApprovals;
897 
898     // Mapping from owner to operator approvals
899     mapping(address => mapping(address => bool)) private _operatorApprovals;
900 
901     /**
902      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
903      */
904     constructor(string memory name_, string memory symbol_) {
905         _name = name_;
906         _symbol = symbol_;
907     }
908 
909     /**
910      * @dev See {IERC165-supportsInterface}.
911      */
912     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
913         return
914             interfaceId == type(IERC721).interfaceId ||
915             interfaceId == type(IERC721Metadata).interfaceId ||
916             super.supportsInterface(interfaceId);
917     }
918 
919     /**
920      * @dev See {IERC721-balanceOf}.
921      */
922     function balanceOf(address owner) public view virtual override returns (uint256) {
923         require(owner != address(0), "ERC721: address zero is not a valid owner");
924         return _balances[owner];
925     }
926 
927     /**
928      * @dev See {IERC721-ownerOf}.
929      */
930     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
931         address owner = _owners[tokenId];
932         require(owner != address(0), "ERC721: invalid token ID");
933         return owner;
934     }
935 
936     /**
937      * @dev See {IERC721Metadata-name}.
938      */
939     function name() public view virtual override returns (string memory) {
940         return _name;
941     }
942 
943     /**
944      * @dev See {IERC721Metadata-symbol}.
945      */
946     function symbol() public view virtual override returns (string memory) {
947         return _symbol;
948     }
949 
950     /**
951      * @dev See {IERC721Metadata-tokenURI}.
952      */
953     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
954         _requireMinted(tokenId);
955 
956         string memory baseURI = _baseURI();
957         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
958     }
959 
960     /**
961      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
962      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
963      * by default, can be overridden in child contracts.
964      */
965     function _baseURI() internal view virtual returns (string memory) {
966         return "";
967     }
968 
969     /**
970      * @dev See {IERC721-approve}.
971      */
972     function approve(address to, uint256 tokenId) public virtual override {
973         address owner = ERC721.ownerOf(tokenId);
974         require(to != owner, "ERC721: approval to current owner");
975 
976         require(
977             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
978             "ERC721: approve caller is not token owner nor approved for all"
979         );
980 
981         _approve(to, tokenId);
982     }
983 
984     /**
985      * @dev See {IERC721-getApproved}.
986      */
987     function getApproved(uint256 tokenId) public view virtual override returns (address) {
988         _requireMinted(tokenId);
989 
990         return _tokenApprovals[tokenId];
991     }
992 
993     /**
994      * @dev See {IERC721-setApprovalForAll}.
995      */
996     function setApprovalForAll(address operator, bool approved) public virtual override {
997         _setApprovalForAll(_msgSender(), operator, approved);
998     }
999 
1000     /**
1001      * @dev See {IERC721-isApprovedForAll}.
1002      */
1003     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1004         return _operatorApprovals[owner][operator];
1005     }
1006 
1007     /**
1008      * @dev See {IERC721-transferFrom}.
1009      */
1010     function transferFrom(
1011         address from,
1012         address to,
1013         uint256 tokenId
1014     ) public virtual override {
1015         //solhint-disable-next-line max-line-length
1016         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
1017 
1018         _transfer(from, to, tokenId);
1019     }
1020 
1021     /**
1022      * @dev See {IERC721-safeTransferFrom}.
1023      */
1024     function safeTransferFrom(
1025         address from,
1026         address to,
1027         uint256 tokenId
1028     ) public virtual override {
1029         safeTransferFrom(from, to, tokenId, "");
1030     }
1031 
1032     /**
1033      * @dev See {IERC721-safeTransferFrom}.
1034      */
1035     function safeTransferFrom(
1036         address from,
1037         address to,
1038         uint256 tokenId,
1039         bytes memory data
1040     ) public virtual override {
1041         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
1042         _safeTransfer(from, to, tokenId, data);
1043     }
1044 
1045     /**
1046      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1047      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1048      *
1049      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1050      *
1051      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1052      * implement alternative mechanisms to perform token transfer, such as signature-based.
1053      *
1054      * Requirements:
1055      *
1056      * - `from` cannot be the zero address.
1057      * - `to` cannot be the zero address.
1058      * - `tokenId` token must exist and be owned by `from`.
1059      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1060      *
1061      * Emits a {Transfer} event.
1062      */
1063     function _safeTransfer(
1064         address from,
1065         address to,
1066         uint256 tokenId,
1067         bytes memory data
1068     ) internal virtual {
1069         _transfer(from, to, tokenId);
1070         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1071     }
1072 
1073     /**
1074      * @dev Returns whether `tokenId` exists.
1075      *
1076      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1077      *
1078      * Tokens start existing when they are minted (`_mint`),
1079      * and stop existing when they are burned (`_burn`).
1080      */
1081     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1082         return _owners[tokenId] != address(0);
1083     }
1084 
1085     /**
1086      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1087      *
1088      * Requirements:
1089      *
1090      * - `tokenId` must exist.
1091      */
1092     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1093         address owner = ERC721.ownerOf(tokenId);
1094         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1095     }
1096 
1097     /**
1098      * @dev Safely mints `tokenId` and transfers it to `to`.
1099      *
1100      * Requirements:
1101      *
1102      * - `tokenId` must not exist.
1103      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1104      *
1105      * Emits a {Transfer} event.
1106      */
1107     function _safeMint(address to, uint256 tokenId) internal virtual {
1108         _safeMint(to, tokenId, "");
1109     }
1110 
1111     /**
1112      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1113      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1114      */
1115     function _safeMint(
1116         address to,
1117         uint256 tokenId,
1118         bytes memory data
1119     ) internal virtual {
1120         _mint(to, tokenId);
1121         require(
1122             _checkOnERC721Received(address(0), to, tokenId, data),
1123             "ERC721: transfer to non ERC721Receiver implementer"
1124         );
1125     }
1126 
1127     /**
1128      * @dev Mints `tokenId` and transfers it to `to`.
1129      *
1130      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1131      *
1132      * Requirements:
1133      *
1134      * - `tokenId` must not exist.
1135      * - `to` cannot be the zero address.
1136      *
1137      * Emits a {Transfer} event.
1138      */
1139     function _mint(address to, uint256 tokenId) internal virtual {
1140         require(to != address(0), "ERC721: mint to the zero address");
1141         require(!_exists(tokenId), "ERC721: token already minted");
1142 
1143         _beforeTokenTransfer(address(0), to, tokenId);
1144 
1145         _balances[to] += 1;
1146         _owners[tokenId] = to;
1147 
1148         emit Transfer(address(0), to, tokenId);
1149 
1150         _afterTokenTransfer(address(0), to, tokenId);
1151     }
1152 
1153     /**
1154      * @dev Destroys `tokenId`.
1155      * The approval is cleared when the token is burned.
1156      *
1157      * Requirements:
1158      *
1159      * - `tokenId` must exist.
1160      *
1161      * Emits a {Transfer} event.
1162      */
1163     function _burn(uint256 tokenId) internal virtual {
1164         address owner = ERC721.ownerOf(tokenId);
1165 
1166         _beforeTokenTransfer(owner, address(0), tokenId);
1167 
1168         // Clear approvals
1169         _approve(address(0), tokenId);
1170 
1171         _balances[owner] -= 1;
1172         delete _owners[tokenId];
1173 
1174         emit Transfer(owner, address(0), tokenId);
1175 
1176         _afterTokenTransfer(owner, address(0), tokenId);
1177     }
1178 
1179     /**
1180      * @dev Transfers `tokenId` from `from` to `to`.
1181      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1182      *
1183      * Requirements:
1184      *
1185      * - `to` cannot be the zero address.
1186      * - `tokenId` token must be owned by `from`.
1187      *
1188      * Emits a {Transfer} event.
1189      */
1190     function _transfer(
1191         address from,
1192         address to,
1193         uint256 tokenId
1194     ) internal virtual {
1195         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1196         require(to != address(0), "ERC721: transfer to the zero address");
1197 
1198         _beforeTokenTransfer(from, to, tokenId);
1199 
1200         // Clear approvals from the previous owner
1201         _approve(address(0), tokenId);
1202 
1203         _balances[from] -= 1;
1204         _balances[to] += 1;
1205         _owners[tokenId] = to;
1206 
1207         emit Transfer(from, to, tokenId);
1208 
1209         _afterTokenTransfer(from, to, tokenId);
1210     }
1211 
1212     /**
1213      * @dev Approve `to` to operate on `tokenId`
1214      *
1215      * Emits an {Approval} event.
1216      */
1217     function _approve(address to, uint256 tokenId) internal virtual {
1218         _tokenApprovals[tokenId] = to;
1219         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1220     }
1221 
1222     /**
1223      * @dev Approve `operator` to operate on all of `owner` tokens
1224      *
1225      * Emits an {ApprovalForAll} event.
1226      */
1227     function _setApprovalForAll(
1228         address owner,
1229         address operator,
1230         bool approved
1231     ) internal virtual {
1232         require(owner != operator, "ERC721: approve to caller");
1233         _operatorApprovals[owner][operator] = approved;
1234         emit ApprovalForAll(owner, operator, approved);
1235     }
1236 
1237     /**
1238      * @dev Reverts if the `tokenId` has not been minted yet.
1239      */
1240     function _requireMinted(uint256 tokenId) internal view virtual {
1241         require(_exists(tokenId), "ERC721: invalid token ID");
1242     }
1243 
1244     /**
1245      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1246      * The call is not executed if the target address is not a contract.
1247      *
1248      * @param from address representing the previous owner of the given token ID
1249      * @param to target address that will receive the tokens
1250      * @param tokenId uint256 ID of the token to be transferred
1251      * @param data bytes optional data to send along with the call
1252      * @return bool whether the call correctly returned the expected magic value
1253      */
1254     function _checkOnERC721Received(
1255         address from,
1256         address to,
1257         uint256 tokenId,
1258         bytes memory data
1259     ) private returns (bool) {
1260         if (to.isContract()) {
1261             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1262                 return retval == IERC721Receiver.onERC721Received.selector;
1263             } catch (bytes memory reason) {
1264                 if (reason.length == 0) {
1265                     revert("ERC721: transfer to non ERC721Receiver implementer");
1266                 } else {
1267                     /// @solidity memory-safe-assembly
1268                     assembly {
1269                         revert(add(32, reason), mload(reason))
1270                     }
1271                 }
1272             }
1273         } else {
1274             return true;
1275         }
1276     }
1277 
1278     /**
1279      * @dev Hook that is called before any token transfer. This includes minting
1280      * and burning.
1281      *
1282      * Calling conditions:
1283      *
1284      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1285      * transferred to `to`.
1286      * - When `from` is zero, `tokenId` will be minted for `to`.
1287      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1288      * - `from` and `to` are never both zero.
1289      *
1290      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1291      */
1292     function _beforeTokenTransfer(
1293         address from,
1294         address to,
1295         uint256 tokenId
1296     ) internal virtual {}
1297 
1298     /**
1299      * @dev Hook that is called after any transfer of tokens. This includes
1300      * minting and burning.
1301      *
1302      * Calling conditions:
1303      *
1304      * - when `from` and `to` are both non-zero.
1305      * - `from` and `to` are never both zero.
1306      *
1307      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1308      */
1309     function _afterTokenTransfer(
1310         address from,
1311         address to,
1312         uint256 tokenId
1313     ) internal virtual {}
1314 }
1315 
1316 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol
1317 
1318 
1319 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/extensions/ERC721URIStorage.sol)
1320 
1321 pragma solidity ^0.8.0;
1322 
1323 
1324 /**
1325  * @dev ERC721 token with storage based token URI management.
1326  */
1327 abstract contract ERC721URIStorage is ERC721 {
1328     using Strings for uint256;
1329 
1330     // Optional mapping for token URIs
1331     mapping(uint256 => string) private _tokenURIs;
1332 
1333     /**
1334      * @dev See {IERC721Metadata-tokenURI}.
1335      */
1336     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1337         _requireMinted(tokenId);
1338 
1339         string memory _tokenURI = _tokenURIs[tokenId];
1340         string memory base = _baseURI();
1341 
1342         // If there is no base URI, return the token URI.
1343         if (bytes(base).length == 0) {
1344             return _tokenURI;
1345         }
1346         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1347         if (bytes(_tokenURI).length > 0) {
1348             return string(abi.encodePacked(base, _tokenURI));
1349         }
1350 
1351         return super.tokenURI(tokenId);
1352     }
1353 
1354     /**
1355      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1356      *
1357      * Requirements:
1358      *
1359      * - `tokenId` must exist.
1360      */
1361     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1362         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
1363         _tokenURIs[tokenId] = _tokenURI;
1364     }
1365 
1366     /**
1367      * @dev See {ERC721-_burn}. This override additionally checks to see if a
1368      * token-specific URI was set for the token, and if so, it deletes the token URI from
1369      * the storage mapping.
1370      */
1371     function _burn(uint256 tokenId) internal virtual override {
1372         super._burn(tokenId);
1373 
1374         if (bytes(_tokenURIs[tokenId]).length != 0) {
1375             delete _tokenURIs[tokenId];
1376         }
1377     }
1378 }
1379 
1380 // File: @openzeppelin/contracts/access/IAccessControl.sol
1381 
1382 
1383 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
1384 
1385 pragma solidity ^0.8.0;
1386 
1387 /**
1388  * @dev External interface of AccessControl declared to support ERC165 detection.
1389  */
1390 interface IAccessControl {
1391     /**
1392      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
1393      *
1394      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
1395      * {RoleAdminChanged} not being emitted signaling this.
1396      *
1397      * _Available since v3.1._
1398      */
1399     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
1400 
1401     /**
1402      * @dev Emitted when `account` is granted `role`.
1403      *
1404      * `sender` is the account that originated the contract call, an admin role
1405      * bearer except when using {AccessControl-_setupRole}.
1406      */
1407     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
1408 
1409     /**
1410      * @dev Emitted when `account` is revoked `role`.
1411      *
1412      * `sender` is the account that originated the contract call:
1413      *   - if using `revokeRole`, it is the admin role bearer
1414      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
1415      */
1416     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
1417 
1418     /**
1419      * @dev Returns `true` if `account` has been granted `role`.
1420      */
1421     function hasRole(bytes32 role, address account) external view returns (bool);
1422 
1423     /**
1424      * @dev Returns the admin role that controls `role`. See {grantRole} and
1425      * {revokeRole}.
1426      *
1427      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
1428      */
1429     function getRoleAdmin(bytes32 role) external view returns (bytes32);
1430 
1431     /**
1432      * @dev Grants `role` to `account`.
1433      *
1434      * If `account` had not been already granted `role`, emits a {RoleGranted}
1435      * event.
1436      *
1437      * Requirements:
1438      *
1439      * - the caller must have ``role``'s admin role.
1440      */
1441     function grantRole(bytes32 role, address account) external;
1442 
1443     /**
1444      * @dev Revokes `role` from `account`.
1445      *
1446      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1447      *
1448      * Requirements:
1449      *
1450      * - the caller must have ``role``'s admin role.
1451      */
1452     function revokeRole(bytes32 role, address account) external;
1453 
1454     /**
1455      * @dev Revokes `role` from the calling account.
1456      *
1457      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1458      * purpose is to provide a mechanism for accounts to lose their privileges
1459      * if they are compromised (such as when a trusted device is misplaced).
1460      *
1461      * If the calling account had been granted `role`, emits a {RoleRevoked}
1462      * event.
1463      *
1464      * Requirements:
1465      *
1466      * - the caller must be `account`.
1467      */
1468     function renounceRole(bytes32 role, address account) external;
1469 }
1470 
1471 // File: @openzeppelin/contracts/access/AccessControl.sol
1472 
1473 
1474 // OpenZeppelin Contracts (last updated v4.7.0) (access/AccessControl.sol)
1475 
1476 pragma solidity ^0.8.0;
1477 
1478 
1479 
1480 
1481 
1482 /**
1483  * @dev Contract module that allows children to implement role-based access
1484  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
1485  * members except through off-chain means by accessing the contract event logs. Some
1486  * applications may benefit from on-chain enumerability, for those cases see
1487  * {AccessControlEnumerable}.
1488  *
1489  * Roles are referred to by their `bytes32` identifier. These should be exposed
1490  * in the external API and be unique. The best way to achieve this is by
1491  * using `public constant` hash digests:
1492  *
1493  * ```
1494  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1495  * ```
1496  *
1497  * Roles can be used to represent a set of permissions. To restrict access to a
1498  * function call, use {hasRole}:
1499  *
1500  * ```
1501  * function foo() public {
1502  *     require(hasRole(MY_ROLE, msg.sender));
1503  *     ...
1504  * }
1505  * ```
1506  *
1507  * Roles can be granted and revoked dynamically via the {grantRole} and
1508  * {revokeRole} functions. Each role has an associated admin role, and only
1509  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1510  *
1511  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1512  * that only accounts with this role will be able to grant or revoke other
1513  * roles. More complex role relationships can be created by using
1514  * {_setRoleAdmin}.
1515  *
1516  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1517  * grant and revoke this role. Extra precautions should be taken to secure
1518  * accounts that have been granted it.
1519  */
1520 abstract contract AccessControl is Context, IAccessControl, ERC165 {
1521     struct RoleData {
1522         mapping(address => bool) members;
1523         bytes32 adminRole;
1524     }
1525 
1526     mapping(bytes32 => RoleData) private _roles;
1527 
1528     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1529 
1530     /**
1531      * @dev Modifier that checks that an account has a specific role. Reverts
1532      * with a standardized message including the required role.
1533      *
1534      * The format of the revert reason is given by the following regular expression:
1535      *
1536      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1537      *
1538      * _Available since v4.1._
1539      */
1540     modifier onlyRole(bytes32 role) {
1541         _checkRole(role);
1542         _;
1543     }
1544 
1545     /**
1546      * @dev See {IERC165-supportsInterface}.
1547      */
1548     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1549         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
1550     }
1551 
1552     /**
1553      * @dev Returns `true` if `account` has been granted `role`.
1554      */
1555     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
1556         return _roles[role].members[account];
1557     }
1558 
1559     /**
1560      * @dev Revert with a standard message if `_msgSender()` is missing `role`.
1561      * Overriding this function changes the behavior of the {onlyRole} modifier.
1562      *
1563      * Format of the revert message is described in {_checkRole}.
1564      *
1565      * _Available since v4.6._
1566      */
1567     function _checkRole(bytes32 role) internal view virtual {
1568         _checkRole(role, _msgSender());
1569     }
1570 
1571     /**
1572      * @dev Revert with a standard message if `account` is missing `role`.
1573      *
1574      * The format of the revert reason is given by the following regular expression:
1575      *
1576      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1577      */
1578     function _checkRole(bytes32 role, address account) internal view virtual {
1579         if (!hasRole(role, account)) {
1580             revert(
1581                 string(
1582                     abi.encodePacked(
1583                         "AccessControl: account ",
1584                         Strings.toHexString(uint160(account), 20),
1585                         " is missing role ",
1586                         Strings.toHexString(uint256(role), 32)
1587                     )
1588                 )
1589             );
1590         }
1591     }
1592 
1593     /**
1594      * @dev Returns the admin role that controls `role`. See {grantRole} and
1595      * {revokeRole}.
1596      *
1597      * To change a role's admin, use {_setRoleAdmin}.
1598      */
1599     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
1600         return _roles[role].adminRole;
1601     }
1602 
1603     /**
1604      * @dev Grants `role` to `account`.
1605      *
1606      * If `account` had not been already granted `role`, emits a {RoleGranted}
1607      * event.
1608      *
1609      * Requirements:
1610      *
1611      * - the caller must have ``role``'s admin role.
1612      *
1613      * May emit a {RoleGranted} event.
1614      */
1615     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1616         _grantRole(role, account);
1617     }
1618 
1619     /**
1620      * @dev Revokes `role` from `account`.
1621      *
1622      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1623      *
1624      * Requirements:
1625      *
1626      * - the caller must have ``role``'s admin role.
1627      *
1628      * May emit a {RoleRevoked} event.
1629      */
1630     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1631         _revokeRole(role, account);
1632     }
1633 
1634     /**
1635      * @dev Revokes `role` from the calling account.
1636      *
1637      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1638      * purpose is to provide a mechanism for accounts to lose their privileges
1639      * if they are compromised (such as when a trusted device is misplaced).
1640      *
1641      * If the calling account had been revoked `role`, emits a {RoleRevoked}
1642      * event.
1643      *
1644      * Requirements:
1645      *
1646      * - the caller must be `account`.
1647      *
1648      * May emit a {RoleRevoked} event.
1649      */
1650     function renounceRole(bytes32 role, address account) public virtual override {
1651         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1652 
1653         _revokeRole(role, account);
1654     }
1655 
1656     /**
1657      * @dev Grants `role` to `account`.
1658      *
1659      * If `account` had not been already granted `role`, emits a {RoleGranted}
1660      * event. Note that unlike {grantRole}, this function doesn't perform any
1661      * checks on the calling account.
1662      *
1663      * May emit a {RoleGranted} event.
1664      *
1665      * [WARNING]
1666      * ====
1667      * This function should only be called from the constructor when setting
1668      * up the initial roles for the system.
1669      *
1670      * Using this function in any other way is effectively circumventing the admin
1671      * system imposed by {AccessControl}.
1672      * ====
1673      *
1674      * NOTE: This function is deprecated in favor of {_grantRole}.
1675      */
1676     function _setupRole(bytes32 role, address account) internal virtual {
1677         _grantRole(role, account);
1678     }
1679 
1680     /**
1681      * @dev Sets `adminRole` as ``role``'s admin role.
1682      *
1683      * Emits a {RoleAdminChanged} event.
1684      */
1685     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1686         bytes32 previousAdminRole = getRoleAdmin(role);
1687         _roles[role].adminRole = adminRole;
1688         emit RoleAdminChanged(role, previousAdminRole, adminRole);
1689     }
1690 
1691     /**
1692      * @dev Grants `role` to `account`.
1693      *
1694      * Internal function without access restriction.
1695      *
1696      * May emit a {RoleGranted} event.
1697      */
1698     function _grantRole(bytes32 role, address account) internal virtual {
1699         if (!hasRole(role, account)) {
1700             _roles[role].members[account] = true;
1701             emit RoleGranted(role, account, _msgSender());
1702         }
1703     }
1704 
1705     /**
1706      * @dev Revokes `role` from `account`.
1707      *
1708      * Internal function without access restriction.
1709      *
1710      * May emit a {RoleRevoked} event.
1711      */
1712     function _revokeRole(bytes32 role, address account) internal virtual {
1713         if (hasRole(role, account)) {
1714             _roles[role].members[account] = false;
1715             emit RoleRevoked(role, account, _msgSender());
1716         }
1717     }
1718 }
1719 
1720 // File: contracts/WineGrower.sol
1721 
1722 
1723 pragma solidity ^0.8.17;
1724 
1725 
1726 
1727 
1728 
1729 
1730 contract WineGrower is ERC721URIStorage, AccessControl  {
1731     using Counters for Counters.Counter;
1732     Counters.Counter private _tokenIdCounter;
1733 
1734     // role allows to generate a signature to mint a NFT
1735     bytes32 public constant SIGNER_ROLE = keccak256("SIGNER_ROLE");
1736     // role allows to modify base URI (used during in the moment of minting) and url to any already minted NFT
1737     bytes32 public constant URLCHANGER_ROLE = keccak256("URLCHANGER_ROLE");
1738 
1739     // minted token ID (not a quantity) per address. User can mint and transafer NFT, this mapping stores the id of minted NFT
1740     mapping(address => uint256) private _mintedByAddress;
1741 
1742     // extra protection to control the usage of the same urls
1743     mapping (bytes32 => bool) private _usedMetadata;
1744     // allowed NFT for each address
1745     uint256 public constant maxSupply = 999;
1746 
1747 
1748     constructor() ERC721("Society of the Winegrower", "SOTW") {
1749         _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
1750         _grantRole(SIGNER_ROLE, msg.sender);
1751         _grantRole(URLCHANGER_ROLE, msg.sender);
1752     }
1753 
1754     /**
1755      * @notice  Overrides metadata url for the certain tokenID. Allowed for user with a role 'URLCHANGER_ROLE'
1756      */
1757     function updateMetadata(uint256 _tokenId, string calldata _tokenURI) external onlyRole(URLCHANGER_ROLE) {
1758         _setTokenURI(_tokenId, _tokenURI);
1759     }
1760 
1761     /**
1762      * @notice  Overrides metadata url for the certain tokenID. Allowed if the user address is a part of signature
1763      */
1764     function updateMetadata_signature(uint256 _tokenId, string calldata _tokenURI, bytes memory _signature) external {
1765         // signature is made up : {msg.sender, tokenId, tokenURL}
1766         address recoveredSigner = _recoverSigner(keccak256(abi.encodePacked(msg.sender, _tokenId, _tokenURI)), _signature);
1767         // recovered signer should have the SIGNER_ROLE role
1768         require(recoveredSigner!=address(0) && hasRole(SIGNER_ROLE, recoveredSigner),"invalid signature");
1769         _setTokenURI(_tokenId, _tokenURI);
1770     }
1771 
1772     function _recoverSigner(bytes32 _messageHash, bytes memory _signature) private pure returns (address) {
1773         // reject if signature is invalid
1774         require(_signature.length == 65, "invalid signature length!");
1775         // append prefix, because on the backend libary appends it to generate a signature
1776         bytes32 ethSignedMessageHash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", _messageHash));
1777         // split signature
1778         bytes32 r; bytes32 s; uint8 v;
1779         assembly {
1780             r := mload(add(_signature, 32))
1781             s := mload(add(_signature, 64))
1782             v := byte(0, mload(add(_signature, 96)))
1783         }
1784 
1785         return ecrecover(ethSignedMessageHash, v, r, s);
1786     }
1787 
1788     /**
1789      * @notice Mint of the NFT, private method. Method allows to assign the owner of the NFT
1790      */
1791     function _mintNFT(address _to, string calldata _tokenURI, bytes memory _signature) private {
1792         // reject if minting is for contract address
1793         require(_to.code.length == 0, "address is a contract");
1794         require(bytes(_tokenURI).length > 0, "empty token uri");
1795         require(_mintedByAddress[_to] == 0, "user already minted");   
1796         // from 1 to 999
1797         require(_tokenIdCounter.current() + 1 <= maxSupply, "exceeding the max supply");
1798         // extra protection of sending the same url
1799         bytes32 _hashURL = keccak256(abi.encodePacked(_tokenURI));
1800         require(!_usedMetadata[_hashURL], "token uri already used"); 
1801         // recovery a signature.  signature is made up : {user, _tokenURI}
1802         address recoveredSigner = _recoverSigner(keccak256(abi.encodePacked(_to, _tokenURI)), _signature);
1803         // recovered signer should have the SIGNER_ROLE role
1804         require (recoveredSigner!=address(0) && hasRole(SIGNER_ROLE, recoveredSigner),"invalid signature");
1805         _usedMetadata[_hashURL] = true;
1806         // increment tokenId
1807         _tokenIdCounter.increment();
1808         uint256 tokenId = _tokenIdCounter.current(); 
1809         _mintedByAddress[_to] = tokenId;
1810         _safeMint(_to, tokenId);
1811         _setTokenURI(tokenId, _tokenURI);
1812 
1813     } 
1814 
1815     /**
1816      * @notice Allows to mint the NFTs if caller was authorized  (given signature).
1817      * Given NFT id is encoded into signature. If id is already used or user has minted any NFT, then transaction is declined
1818      */
1819     function mint(string calldata _tokenURL, bytes memory _signature) public  {
1820         _mintNFT(msg.sender, _tokenURL, _signature);
1821     }
1822 
1823     /**
1824      *  @notice Allows to mint the NFTs if specified user (who becomes an owner) was authorized (given signature).
1825      *  Given NFT id is encoded into signature. If id is already used or user has minted any NFT, then transaction is declined
1826      */
1827     function mintTo(address _to, string calldata _tokenURL, bytes memory _signature) public  {
1828         _mintNFT(_to, _tokenURL, _signature);
1829     }
1830 
1831     /**
1832      * @notice Returns minted NFT ID per address
1833      */
1834     function mintedByAddress(address user) public view virtual returns (uint256) {
1835         return _mintedByAddress[user];
1836     }
1837     /**
1838      * @notice total number of minted NFTs
1839      */
1840     function totalSupply() public view returns (uint256) {
1841         return _tokenIdCounter.current();
1842     }
1843 
1844     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, AccessControl) returns (bool) {
1845         return super.supportsInterface(interfaceId);
1846     }               
1847 }