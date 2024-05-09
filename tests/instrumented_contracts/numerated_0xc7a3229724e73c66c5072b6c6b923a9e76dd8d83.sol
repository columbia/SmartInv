1 // File: @openzeppelin/contracts/utils/Strings.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev String operations.
10  */
11 library Strings {
12     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
13 
14     /**
15      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
16      */
17     function toString(uint256 value) internal pure returns (string memory) {
18         // Inspired by OraclizeAPI's implementation - MIT licence
19         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
20 
21         if (value == 0) {
22             return "0";
23         }
24         uint256 temp = value;
25         uint256 digits;
26         while (temp != 0) {
27             digits++;
28             temp /= 10;
29         }
30         bytes memory buffer = new bytes(digits);
31         while (value != 0) {
32             digits -= 1;
33             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
34             value /= 10;
35         }
36         return string(buffer);
37     }
38 
39     /**
40      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
41      */
42     function toHexString(uint256 value) internal pure returns (string memory) {
43         if (value == 0) {
44             return "0x00";
45         }
46         uint256 temp = value;
47         uint256 length = 0;
48         while (temp != 0) {
49             length++;
50             temp >>= 8;
51         }
52         return toHexString(value, length);
53     }
54 
55     /**
56      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
57      */
58     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
59         bytes memory buffer = new bytes(2 * length + 2);
60         buffer[0] = "0";
61         buffer[1] = "x";
62         for (uint256 i = 2 * length + 1; i > 1; --i) {
63             buffer[i] = _HEX_SYMBOLS[value & 0xf];
64             value >>= 4;
65         }
66         require(value == 0, "Strings: hex length insufficient");
67         return string(buffer);
68     }
69 }
70 
71 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
72 
73 
74 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/ECDSA.sol)
75 
76 pragma solidity ^0.8.0;
77 
78 
79 /**
80  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
81  *
82  * These functions can be used to verify that a message was signed by the holder
83  * of the private keys of a given address.
84  */
85 library ECDSA {
86     enum RecoverError {
87         NoError,
88         InvalidSignature,
89         InvalidSignatureLength,
90         InvalidSignatureS,
91         InvalidSignatureV
92     }
93 
94     function _throwError(RecoverError error) private pure {
95         if (error == RecoverError.NoError) {
96             return; // no error: do nothing
97         } else if (error == RecoverError.InvalidSignature) {
98             revert("ECDSA: invalid signature");
99         } else if (error == RecoverError.InvalidSignatureLength) {
100             revert("ECDSA: invalid signature length");
101         } else if (error == RecoverError.InvalidSignatureS) {
102             revert("ECDSA: invalid signature 's' value");
103         } else if (error == RecoverError.InvalidSignatureV) {
104             revert("ECDSA: invalid signature 'v' value");
105         }
106     }
107 
108     /**
109      * @dev Returns the address that signed a hashed message (`hash`) with
110      * `signature` or error string. This address can then be used for verification purposes.
111      *
112      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
113      * this function rejects them by requiring the `s` value to be in the lower
114      * half order, and the `v` value to be either 27 or 28.
115      *
116      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
117      * verification to be secure: it is possible to craft signatures that
118      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
119      * this is by receiving a hash of the original message (which may otherwise
120      * be too long), and then calling {toEthSignedMessageHash} on it.
121      *
122      * Documentation for signature generation:
123      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
124      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
125      *
126      * _Available since v4.3._
127      */
128     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
129         // Check the signature length
130         // - case 65: r,s,v signature (standard)
131         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
132         if (signature.length == 65) {
133             bytes32 r;
134             bytes32 s;
135             uint8 v;
136             // ecrecover takes the signature parameters, and the only way to get them
137             // currently is to use assembly.
138             assembly {
139                 r := mload(add(signature, 0x20))
140                 s := mload(add(signature, 0x40))
141                 v := byte(0, mload(add(signature, 0x60)))
142             }
143             return tryRecover(hash, v, r, s);
144         } else if (signature.length == 64) {
145             bytes32 r;
146             bytes32 vs;
147             // ecrecover takes the signature parameters, and the only way to get them
148             // currently is to use assembly.
149             assembly {
150                 r := mload(add(signature, 0x20))
151                 vs := mload(add(signature, 0x40))
152             }
153             return tryRecover(hash, r, vs);
154         } else {
155             return (address(0), RecoverError.InvalidSignatureLength);
156         }
157     }
158 
159     /**
160      * @dev Returns the address that signed a hashed message (`hash`) with
161      * `signature`. This address can then be used for verification purposes.
162      *
163      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
164      * this function rejects them by requiring the `s` value to be in the lower
165      * half order, and the `v` value to be either 27 or 28.
166      *
167      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
168      * verification to be secure: it is possible to craft signatures that
169      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
170      * this is by receiving a hash of the original message (which may otherwise
171      * be too long), and then calling {toEthSignedMessageHash} on it.
172      */
173     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
174         (address recovered, RecoverError error) = tryRecover(hash, signature);
175         _throwError(error);
176         return recovered;
177     }
178 
179     /**
180      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
181      *
182      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
183      *
184      * _Available since v4.3._
185      */
186     function tryRecover(
187         bytes32 hash,
188         bytes32 r,
189         bytes32 vs
190     ) internal pure returns (address, RecoverError) {
191         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
192         uint8 v = uint8((uint256(vs) >> 255) + 27);
193         return tryRecover(hash, v, r, s);
194     }
195 
196     /**
197      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
198      *
199      * _Available since v4.2._
200      */
201     function recover(
202         bytes32 hash,
203         bytes32 r,
204         bytes32 vs
205     ) internal pure returns (address) {
206         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
207         _throwError(error);
208         return recovered;
209     }
210 
211     /**
212      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
213      * `r` and `s` signature fields separately.
214      *
215      * _Available since v4.3._
216      */
217     function tryRecover(
218         bytes32 hash,
219         uint8 v,
220         bytes32 r,
221         bytes32 s
222     ) internal pure returns (address, RecoverError) {
223         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
224         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
225         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
226         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
227         //
228         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
229         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
230         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
231         // these malleable signatures as well.
232         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
233             return (address(0), RecoverError.InvalidSignatureS);
234         }
235         if (v != 27 && v != 28) {
236             return (address(0), RecoverError.InvalidSignatureV);
237         }
238 
239         // If the signature is valid (and not malleable), return the signer address
240         address signer = ecrecover(hash, v, r, s);
241         if (signer == address(0)) {
242             return (address(0), RecoverError.InvalidSignature);
243         }
244 
245         return (signer, RecoverError.NoError);
246     }
247 
248     /**
249      * @dev Overload of {ECDSA-recover} that receives the `v`,
250      * `r` and `s` signature fields separately.
251      */
252     function recover(
253         bytes32 hash,
254         uint8 v,
255         bytes32 r,
256         bytes32 s
257     ) internal pure returns (address) {
258         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
259         _throwError(error);
260         return recovered;
261     }
262 
263     /**
264      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
265      * produces hash corresponding to the one signed with the
266      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
267      * JSON-RPC method as part of EIP-191.
268      *
269      * See {recover}.
270      */
271     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
272         // 32 is the length in bytes of hash,
273         // enforced by the type signature above
274         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
275     }
276 
277     /**
278      * @dev Returns an Ethereum Signed Message, created from `s`. This
279      * produces hash corresponding to the one signed with the
280      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
281      * JSON-RPC method as part of EIP-191.
282      *
283      * See {recover}.
284      */
285     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
286         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
287     }
288 
289     /**
290      * @dev Returns an Ethereum Signed Typed Data, created from a
291      * `domainSeparator` and a `structHash`. This produces hash corresponding
292      * to the one signed with the
293      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
294      * JSON-RPC method as part of EIP-712.
295      *
296      * See {recover}.
297      */
298     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
299         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
300     }
301 }
302 
303 // File: @openzeppelin/contracts/utils/Address.sol
304 
305 
306 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
307 
308 pragma solidity ^0.8.1;
309 
310 /**
311  * @dev Collection of functions related to the address type
312  */
313 library Address {
314     /**
315      * @dev Returns true if `account` is a contract.
316      *
317      * [IMPORTANT]
318      * ====
319      * It is unsafe to assume that an address for which this function returns
320      * false is an externally-owned account (EOA) and not a contract.
321      *
322      * Among others, `isContract` will return false for the following
323      * types of addresses:
324      *
325      *  - an externally-owned account
326      *  - a contract in construction
327      *  - an address where a contract will be created
328      *  - an address where a contract lived, but was destroyed
329      * ====
330      *
331      * [IMPORTANT]
332      * ====
333      * You shouldn't rely on `isContract` to protect against flash loan attacks!
334      *
335      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
336      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
337      * constructor.
338      * ====
339      */
340     function isContract(address account) internal view returns (bool) {
341         // This method relies on extcodesize/address.code.length, which returns 0
342         // for contracts in construction, since the code is only stored at the end
343         // of the constructor execution.
344 
345         return account.code.length > 0;
346     }
347 
348     /**
349      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
350      * `recipient`, forwarding all available gas and reverting on errors.
351      *
352      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
353      * of certain opcodes, possibly making contracts go over the 2300 gas limit
354      * imposed by `transfer`, making them unable to receive funds via
355      * `transfer`. {sendValue} removes this limitation.
356      *
357      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
358      *
359      * IMPORTANT: because control is transferred to `recipient`, care must be
360      * taken to not create reentrancy vulnerabilities. Consider using
361      * {ReentrancyGuard} or the
362      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
363      */
364     function sendValue(address payable recipient, uint256 amount) internal {
365         require(address(this).balance >= amount, "Address: insufficient balance");
366 
367         (bool success, ) = recipient.call{value: amount}("");
368         require(success, "Address: unable to send value, recipient may have reverted");
369     }
370 
371     /**
372      * @dev Performs a Solidity function call using a low level `call`. A
373      * plain `call` is an unsafe replacement for a function call: use this
374      * function instead.
375      *
376      * If `target` reverts with a revert reason, it is bubbled up by this
377      * function (like regular Solidity function calls).
378      *
379      * Returns the raw returned data. To convert to the expected return value,
380      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
381      *
382      * Requirements:
383      *
384      * - `target` must be a contract.
385      * - calling `target` with `data` must not revert.
386      *
387      * _Available since v3.1._
388      */
389     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
390         return functionCall(target, data, "Address: low-level call failed");
391     }
392 
393     /**
394      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
395      * `errorMessage` as a fallback revert reason when `target` reverts.
396      *
397      * _Available since v3.1._
398      */
399     function functionCall(
400         address target,
401         bytes memory data,
402         string memory errorMessage
403     ) internal returns (bytes memory) {
404         return functionCallWithValue(target, data, 0, errorMessage);
405     }
406 
407     /**
408      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
409      * but also transferring `value` wei to `target`.
410      *
411      * Requirements:
412      *
413      * - the calling contract must have an ETH balance of at least `value`.
414      * - the called Solidity function must be `payable`.
415      *
416      * _Available since v3.1._
417      */
418     function functionCallWithValue(
419         address target,
420         bytes memory data,
421         uint256 value
422     ) internal returns (bytes memory) {
423         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
424     }
425 
426     /**
427      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
428      * with `errorMessage` as a fallback revert reason when `target` reverts.
429      *
430      * _Available since v3.1._
431      */
432     function functionCallWithValue(
433         address target,
434         bytes memory data,
435         uint256 value,
436         string memory errorMessage
437     ) internal returns (bytes memory) {
438         require(address(this).balance >= value, "Address: insufficient balance for call");
439         require(isContract(target), "Address: call to non-contract");
440 
441         (bool success, bytes memory returndata) = target.call{value: value}(data);
442         return verifyCallResult(success, returndata, errorMessage);
443     }
444 
445     /**
446      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
447      * but performing a static call.
448      *
449      * _Available since v3.3._
450      */
451     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
452         return functionStaticCall(target, data, "Address: low-level static call failed");
453     }
454 
455     /**
456      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
457      * but performing a static call.
458      *
459      * _Available since v3.3._
460      */
461     function functionStaticCall(
462         address target,
463         bytes memory data,
464         string memory errorMessage
465     ) internal view returns (bytes memory) {
466         require(isContract(target), "Address: static call to non-contract");
467 
468         (bool success, bytes memory returndata) = target.staticcall(data);
469         return verifyCallResult(success, returndata, errorMessage);
470     }
471 
472     /**
473      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
474      * but performing a delegate call.
475      *
476      * _Available since v3.4._
477      */
478     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
479         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
480     }
481 
482     /**
483      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
484      * but performing a delegate call.
485      *
486      * _Available since v3.4._
487      */
488     function functionDelegateCall(
489         address target,
490         bytes memory data,
491         string memory errorMessage
492     ) internal returns (bytes memory) {
493         require(isContract(target), "Address: delegate call to non-contract");
494 
495         (bool success, bytes memory returndata) = target.delegatecall(data);
496         return verifyCallResult(success, returndata, errorMessage);
497     }
498 
499     /**
500      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
501      * revert reason using the provided one.
502      *
503      * _Available since v4.3._
504      */
505     function verifyCallResult(
506         bool success,
507         bytes memory returndata,
508         string memory errorMessage
509     ) internal pure returns (bytes memory) {
510         if (success) {
511             return returndata;
512         } else {
513             // Look for revert reason and bubble it up if present
514             if (returndata.length > 0) {
515                 // The easiest way to bubble the revert reason is using memory via assembly
516 
517                 assembly {
518                     let returndata_size := mload(returndata)
519                     revert(add(32, returndata), returndata_size)
520                 }
521             } else {
522                 revert(errorMessage);
523             }
524         }
525     }
526 }
527 
528 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
529 
530 
531 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
532 
533 pragma solidity ^0.8.0;
534 
535 /**
536  * @title ERC721 token receiver interface
537  * @dev Interface for any contract that wants to support safeTransfers
538  * from ERC721 asset contracts.
539  */
540 interface IERC721Receiver {
541     /**
542      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
543      * by `operator` from `from`, this function is called.
544      *
545      * It must return its Solidity selector to confirm the token transfer.
546      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
547      *
548      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
549      */
550     function onERC721Received(
551         address operator,
552         address from,
553         uint256 tokenId,
554         bytes calldata data
555     ) external returns (bytes4);
556 }
557 
558 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
559 
560 
561 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
562 
563 pragma solidity ^0.8.0;
564 
565 /**
566  * @dev Interface of the ERC165 standard, as defined in the
567  * https://eips.ethereum.org/EIPS/eip-165[EIP].
568  *
569  * Implementers can declare support of contract interfaces, which can then be
570  * queried by others ({ERC165Checker}).
571  *
572  * For an implementation, see {ERC165}.
573  */
574 interface IERC165 {
575     /**
576      * @dev Returns true if this contract implements the interface defined by
577      * `interfaceId`. See the corresponding
578      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
579      * to learn more about how these ids are created.
580      *
581      * This function call must use less than 30 000 gas.
582      */
583     function supportsInterface(bytes4 interfaceId) external view returns (bool);
584 }
585 
586 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
587 
588 
589 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
590 
591 pragma solidity ^0.8.0;
592 
593 
594 /**
595  * @dev Implementation of the {IERC165} interface.
596  *
597  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
598  * for the additional interface id that will be supported. For example:
599  *
600  * ```solidity
601  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
602  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
603  * }
604  * ```
605  *
606  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
607  */
608 abstract contract ERC165 is IERC165 {
609     /**
610      * @dev See {IERC165-supportsInterface}.
611      */
612     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
613         return interfaceId == type(IERC165).interfaceId;
614     }
615 }
616 
617 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
618 
619 
620 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
621 
622 pragma solidity ^0.8.0;
623 
624 
625 /**
626  * @dev Required interface of an ERC721 compliant contract.
627  */
628 interface IERC721 is IERC165 {
629     /**
630      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
631      */
632     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
633 
634     /**
635      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
636      */
637     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
638 
639     /**
640      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
641      */
642     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
643 
644     /**
645      * @dev Returns the number of tokens in ``owner``'s account.
646      */
647     function balanceOf(address owner) external view returns (uint256 balance);
648 
649     /**
650      * @dev Returns the owner of the `tokenId` token.
651      *
652      * Requirements:
653      *
654      * - `tokenId` must exist.
655      */
656     function ownerOf(uint256 tokenId) external view returns (address owner);
657 
658     /**
659      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
660      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
661      *
662      * Requirements:
663      *
664      * - `from` cannot be the zero address.
665      * - `to` cannot be the zero address.
666      * - `tokenId` token must exist and be owned by `from`.
667      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
668      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
669      *
670      * Emits a {Transfer} event.
671      */
672     function safeTransferFrom(
673         address from,
674         address to,
675         uint256 tokenId
676     ) external;
677 
678     /**
679      * @dev Transfers `tokenId` token from `from` to `to`.
680      *
681      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
682      *
683      * Requirements:
684      *
685      * - `from` cannot be the zero address.
686      * - `to` cannot be the zero address.
687      * - `tokenId` token must be owned by `from`.
688      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
689      *
690      * Emits a {Transfer} event.
691      */
692     function transferFrom(
693         address from,
694         address to,
695         uint256 tokenId
696     ) external;
697 
698     /**
699      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
700      * The approval is cleared when the token is transferred.
701      *
702      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
703      *
704      * Requirements:
705      *
706      * - The caller must own the token or be an approved operator.
707      * - `tokenId` must exist.
708      *
709      * Emits an {Approval} event.
710      */
711     function approve(address to, uint256 tokenId) external;
712 
713     /**
714      * @dev Returns the account approved for `tokenId` token.
715      *
716      * Requirements:
717      *
718      * - `tokenId` must exist.
719      */
720     function getApproved(uint256 tokenId) external view returns (address operator);
721 
722     /**
723      * @dev Approve or remove `operator` as an operator for the caller.
724      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
725      *
726      * Requirements:
727      *
728      * - The `operator` cannot be the caller.
729      *
730      * Emits an {ApprovalForAll} event.
731      */
732     function setApprovalForAll(address operator, bool _approved) external;
733 
734     /**
735      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
736      *
737      * See {setApprovalForAll}
738      */
739     function isApprovedForAll(address owner, address operator) external view returns (bool);
740 
741     /**
742      * @dev Safely transfers `tokenId` token from `from` to `to`.
743      *
744      * Requirements:
745      *
746      * - `from` cannot be the zero address.
747      * - `to` cannot be the zero address.
748      * - `tokenId` token must exist and be owned by `from`.
749      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
750      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
751      *
752      * Emits a {Transfer} event.
753      */
754     function safeTransferFrom(
755         address from,
756         address to,
757         uint256 tokenId,
758         bytes calldata data
759     ) external;
760 }
761 
762 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
763 
764 
765 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
766 
767 pragma solidity ^0.8.0;
768 
769 
770 /**
771  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
772  * @dev See https://eips.ethereum.org/EIPS/eip-721
773  */
774 interface IERC721Enumerable is IERC721 {
775     /**
776      * @dev Returns the total amount of tokens stored by the contract.
777      */
778     function totalSupply() external view returns (uint256);
779 
780     /**
781      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
782      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
783      */
784     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
785 
786     /**
787      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
788      * Use along with {totalSupply} to enumerate all tokens.
789      */
790     function tokenByIndex(uint256 index) external view returns (uint256);
791 }
792 
793 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
794 
795 
796 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
797 
798 pragma solidity ^0.8.0;
799 
800 
801 /**
802  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
803  * @dev See https://eips.ethereum.org/EIPS/eip-721
804  */
805 interface IERC721Metadata is IERC721 {
806     /**
807      * @dev Returns the token collection name.
808      */
809     function name() external view returns (string memory);
810 
811     /**
812      * @dev Returns the token collection symbol.
813      */
814     function symbol() external view returns (string memory);
815 
816     /**
817      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
818      */
819     function tokenURI(uint256 tokenId) external view returns (string memory);
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
915 // File: erc721a/contracts/ERC721A.sol
916 
917 
918 // Creator: Chiru Labs
919 
920 pragma solidity ^0.8.4;
921 
922 
923 
924 
925 
926 
927 
928 
929 
930 error ApprovalCallerNotOwnerNorApproved();
931 error ApprovalQueryForNonexistentToken();
932 error ApproveToCaller();
933 error ApprovalToCurrentOwner();
934 error BalanceQueryForZeroAddress();
935 error MintedQueryForZeroAddress();
936 error BurnedQueryForZeroAddress();
937 error AuxQueryForZeroAddress();
938 error MintToZeroAddress();
939 error MintZeroQuantity();
940 error OwnerIndexOutOfBounds();
941 error OwnerQueryForNonexistentToken();
942 error TokenIndexOutOfBounds();
943 error TransferCallerNotOwnerNorApproved();
944 error TransferFromIncorrectOwner();
945 error TransferToNonERC721ReceiverImplementer();
946 error TransferToZeroAddress();
947 error URIQueryForNonexistentToken();
948 
949 /**
950  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
951  * the Metadata extension. Built to optimize for lower gas during batch mints.
952  *
953  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
954  *
955  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
956  *
957  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
958  */
959 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
960     using Address for address;
961     using Strings for uint256;
962 
963     // Compiler will pack this into a single 256bit word.
964     struct TokenOwnership {
965         // The address of the owner.
966         address addr;
967         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
968         uint64 startTimestamp;
969         // Whether the token has been burned.
970         bool burned;
971     }
972 
973     // Compiler will pack this into a single 256bit word.
974     struct AddressData {
975         // Realistically, 2**64-1 is more than enough.
976         uint64 balance;
977         // Keeps track of mint count with minimal overhead for tokenomics.
978         uint64 numberMinted;
979         // Keeps track of burn count with minimal overhead for tokenomics.
980         uint64 numberBurned;
981         // For miscellaneous variable(s) pertaining to the address
982         // (e.g. number of whitelist mint slots used).
983         // If there are multiple variables, please pack them into a uint64.
984         uint64 aux;
985     }
986 
987     // The tokenId of the next token to be minted.
988     uint256 internal _currentIndex;
989 
990     // The number of tokens burned.
991     uint256 internal _burnCounter;
992 
993     // Token name
994     string private _name;
995 
996     // Token symbol
997     string private _symbol;
998 
999     // Mapping from token ID to ownership details
1000     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1001     mapping(uint256 => TokenOwnership) internal _ownerships;
1002 
1003     // Mapping owner address to address data
1004     mapping(address => AddressData) private _addressData;
1005 
1006     // Mapping from token ID to approved address
1007     mapping(uint256 => address) private _tokenApprovals;
1008 
1009     // Mapping from owner to operator approvals
1010     mapping(address => mapping(address => bool)) private _operatorApprovals;
1011 
1012     constructor(string memory name_, string memory symbol_) {
1013         _name = name_;
1014         _symbol = symbol_;
1015         _currentIndex = _startTokenId();
1016     }
1017 
1018     /**
1019      * To change the starting tokenId, please override this function.
1020      */
1021     function _startTokenId() internal view virtual returns (uint256) {
1022         return 0;
1023     }
1024 
1025     /**
1026      * @dev See {IERC721Enumerable-totalSupply}.
1027      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
1028      */
1029     function totalSupply() public view returns (uint256) {
1030         // Counter underflow is impossible as _burnCounter cannot be incremented
1031         // more than _currentIndex - _startTokenId() times
1032         unchecked {
1033             return _currentIndex - _burnCounter - _startTokenId();
1034         }
1035     }
1036 
1037     /**
1038      * Returns the total amount of tokens minted in the contract.
1039      */
1040     function _totalMinted() internal view returns (uint256) {
1041         // Counter underflow is impossible as _currentIndex does not decrement,
1042         // and it is initialized to _startTokenId()
1043         unchecked {
1044             return _currentIndex - _startTokenId();
1045         }
1046     }
1047 
1048     /**
1049      * @dev See {IERC165-supportsInterface}.
1050      */
1051     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1052         return
1053             interfaceId == type(IERC721).interfaceId ||
1054             interfaceId == type(IERC721Metadata).interfaceId ||
1055             super.supportsInterface(interfaceId);
1056     }
1057 
1058     /**
1059      * @dev See {IERC721-balanceOf}.
1060      */
1061     function balanceOf(address owner) public view override returns (uint256) {
1062         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1063         return uint256(_addressData[owner].balance);
1064     }
1065 
1066     /**
1067      * Returns the number of tokens minted by `owner`.
1068      */
1069     function _numberMinted(address owner) internal view returns (uint256) {
1070         if (owner == address(0)) revert MintedQueryForZeroAddress();
1071         return uint256(_addressData[owner].numberMinted);
1072     }
1073 
1074     /**
1075      * Returns the number of tokens burned by or on behalf of `owner`.
1076      */
1077     function _numberBurned(address owner) internal view returns (uint256) {
1078         if (owner == address(0)) revert BurnedQueryForZeroAddress();
1079         return uint256(_addressData[owner].numberBurned);
1080     }
1081 
1082     /**
1083      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1084      */
1085     function _getAux(address owner) internal view returns (uint64) {
1086         if (owner == address(0)) revert AuxQueryForZeroAddress();
1087         return _addressData[owner].aux;
1088     }
1089 
1090     /**
1091      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1092      * If there are multiple variables, please pack them into a uint64.
1093      */
1094     function _setAux(address owner, uint64 aux) internal {
1095         if (owner == address(0)) revert AuxQueryForZeroAddress();
1096         _addressData[owner].aux = aux;
1097     }
1098 
1099     /**
1100      * Gas spent here starts off proportional to the maximum mint batch size.
1101      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1102      */
1103     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1104         uint256 curr = tokenId;
1105 
1106         unchecked {
1107             if (_startTokenId() <= curr && curr < _currentIndex) {
1108                 TokenOwnership memory ownership = _ownerships[curr];
1109                 if (!ownership.burned) {
1110                     if (ownership.addr != address(0)) {
1111                         return ownership;
1112                     }
1113                     // Invariant:
1114                     // There will always be an ownership that has an address and is not burned
1115                     // before an ownership that does not have an address and is not burned.
1116                     // Hence, curr will not underflow.
1117                     while (true) {
1118                         curr--;
1119                         ownership = _ownerships[curr];
1120                         if (ownership.addr != address(0)) {
1121                             return ownership;
1122                         }
1123                     }
1124                 }
1125             }
1126         }
1127         revert OwnerQueryForNonexistentToken();
1128     }
1129 
1130     /**
1131      * @dev See {IERC721-ownerOf}.
1132      */
1133     function ownerOf(uint256 tokenId) public view override returns (address) {
1134         return ownershipOf(tokenId).addr;
1135     }
1136 
1137     /**
1138      * @dev See {IERC721Metadata-name}.
1139      */
1140     function name() public view virtual override returns (string memory) {
1141         return _name;
1142     }
1143 
1144     /**
1145      * @dev See {IERC721Metadata-symbol}.
1146      */
1147     function symbol() public view virtual override returns (string memory) {
1148         return _symbol;
1149     }
1150 
1151     /**
1152      * @dev See {IERC721Metadata-tokenURI}.
1153      */
1154     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1155         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1156 
1157         string memory baseURI = _baseURI();
1158         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1159     }
1160 
1161     /**
1162      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1163      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1164      * by default, can be overriden in child contracts.
1165      */
1166     function _baseURI() internal view virtual returns (string memory) {
1167         return '';
1168     }
1169 
1170     /**
1171      * @dev See {IERC721-approve}.
1172      */
1173     function approve(address to, uint256 tokenId) public override {
1174         address owner = ERC721A.ownerOf(tokenId);
1175         if (to == owner) revert ApprovalToCurrentOwner();
1176 
1177         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1178             revert ApprovalCallerNotOwnerNorApproved();
1179         }
1180 
1181         _approve(to, tokenId, owner);
1182     }
1183 
1184     /**
1185      * @dev See {IERC721-getApproved}.
1186      */
1187     function getApproved(uint256 tokenId) public view override returns (address) {
1188         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1189 
1190         return _tokenApprovals[tokenId];
1191     }
1192 
1193     /**
1194      * @dev See {IERC721-setApprovalForAll}.
1195      */
1196     function setApprovalForAll(address operator, bool approved) public override {
1197         if (operator == _msgSender()) revert ApproveToCaller();
1198 
1199         _operatorApprovals[_msgSender()][operator] = approved;
1200         emit ApprovalForAll(_msgSender(), operator, approved);
1201     }
1202 
1203     /**
1204      * @dev See {IERC721-isApprovedForAll}.
1205      */
1206     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1207         return _operatorApprovals[owner][operator];
1208     }
1209 
1210     /**
1211      * @dev See {IERC721-transferFrom}.
1212      */
1213     function transferFrom(
1214         address from,
1215         address to,
1216         uint256 tokenId
1217     ) public virtual override {
1218         _transfer(from, to, tokenId);
1219     }
1220 
1221     /**
1222      * @dev See {IERC721-safeTransferFrom}.
1223      */
1224     function safeTransferFrom(
1225         address from,
1226         address to,
1227         uint256 tokenId
1228     ) public virtual override {
1229         safeTransferFrom(from, to, tokenId, '');
1230     }
1231 
1232     /**
1233      * @dev See {IERC721-safeTransferFrom}.
1234      */
1235     function safeTransferFrom(
1236         address from,
1237         address to,
1238         uint256 tokenId,
1239         bytes memory _data
1240     ) public virtual override {
1241         _transfer(from, to, tokenId);
1242         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1243             revert TransferToNonERC721ReceiverImplementer();
1244         }
1245     }
1246 
1247     /**
1248      * @dev Returns whether `tokenId` exists.
1249      *
1250      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1251      *
1252      * Tokens start existing when they are minted (`_mint`),
1253      */
1254     function _exists(uint256 tokenId) internal view returns (bool) {
1255         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1256             !_ownerships[tokenId].burned;
1257     }
1258 
1259     function _safeMint(address to, uint256 quantity) internal {
1260         _safeMint(to, quantity, '');
1261     }
1262 
1263     /**
1264      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1265      *
1266      * Requirements:
1267      *
1268      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1269      * - `quantity` must be greater than 0.
1270      *
1271      * Emits a {Transfer} event.
1272      */
1273     function _safeMint(
1274         address to,
1275         uint256 quantity,
1276         bytes memory _data
1277     ) internal {
1278         _mint(to, quantity, _data, true);
1279     }
1280 
1281     /**
1282      * @dev Mints `quantity` tokens and transfers them to `to`.
1283      *
1284      * Requirements:
1285      *
1286      * - `to` cannot be the zero address.
1287      * - `quantity` must be greater than 0.
1288      *
1289      * Emits a {Transfer} event.
1290      */
1291     function _mint(
1292         address to,
1293         uint256 quantity,
1294         bytes memory _data,
1295         bool safe
1296     ) internal {
1297         uint256 startTokenId = _currentIndex;
1298         if (to == address(0)) revert MintToZeroAddress();
1299         if (quantity == 0) revert MintZeroQuantity();
1300 
1301         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1302 
1303         // Overflows are incredibly unrealistic.
1304         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1305         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1306         unchecked {
1307             _addressData[to].balance += uint64(quantity);
1308             _addressData[to].numberMinted += uint64(quantity);
1309 
1310             _ownerships[startTokenId].addr = to;
1311             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1312 
1313             uint256 updatedIndex = startTokenId;
1314             uint256 end = updatedIndex + quantity;
1315 
1316             if (safe && to.isContract()) {
1317                 do {
1318                     emit Transfer(address(0), to, updatedIndex);
1319                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1320                         revert TransferToNonERC721ReceiverImplementer();
1321                     }
1322                 } while (updatedIndex != end);
1323                 // Reentrancy protection
1324                 if (_currentIndex != startTokenId) revert();
1325             } else {
1326                 do {
1327                     emit Transfer(address(0), to, updatedIndex++);
1328                 } while (updatedIndex != end);
1329             }
1330             _currentIndex = updatedIndex;
1331         }
1332         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1333     }
1334 
1335     /**
1336      * @dev Transfers `tokenId` from `from` to `to`.
1337      *
1338      * Requirements:
1339      *
1340      * - `to` cannot be the zero address.
1341      * - `tokenId` token must be owned by `from`.
1342      *
1343      * Emits a {Transfer} event.
1344      */
1345     function _transfer(
1346         address from,
1347         address to,
1348         uint256 tokenId
1349     ) private {
1350         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1351 
1352         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1353             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1354             getApproved(tokenId) == _msgSender());
1355 
1356         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1357         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1358         if (to == address(0)) revert TransferToZeroAddress();
1359 
1360         _beforeTokenTransfers(from, to, tokenId, 1);
1361 
1362         // Clear approvals from the previous owner
1363         _approve(address(0), tokenId, prevOwnership.addr);
1364 
1365         // Underflow of the sender's balance is impossible because we check for
1366         // ownership above and the recipient's balance can't realistically overflow.
1367         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1368         unchecked {
1369             _addressData[from].balance -= 1;
1370             _addressData[to].balance += 1;
1371 
1372             _ownerships[tokenId].addr = to;
1373             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1374 
1375             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1376             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1377             uint256 nextTokenId = tokenId + 1;
1378             if (_ownerships[nextTokenId].addr == address(0)) {
1379                 // This will suffice for checking _exists(nextTokenId),
1380                 // as a burned slot cannot contain the zero address.
1381                 if (nextTokenId < _currentIndex) {
1382                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1383                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1384                 }
1385             }
1386         }
1387 
1388         emit Transfer(from, to, tokenId);
1389         _afterTokenTransfers(from, to, tokenId, 1);
1390     }
1391 
1392     /**
1393      * @dev Destroys `tokenId`.
1394      * The approval is cleared when the token is burned.
1395      *
1396      * Requirements:
1397      *
1398      * - `tokenId` must exist.
1399      *
1400      * Emits a {Transfer} event.
1401      */
1402     function _burn(uint256 tokenId) internal virtual {
1403         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1404 
1405         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1406 
1407         // Clear approvals from the previous owner
1408         _approve(address(0), tokenId, prevOwnership.addr);
1409 
1410         // Underflow of the sender's balance is impossible because we check for
1411         // ownership above and the recipient's balance can't realistically overflow.
1412         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1413         unchecked {
1414             _addressData[prevOwnership.addr].balance -= 1;
1415             _addressData[prevOwnership.addr].numberBurned += 1;
1416 
1417             // Keep track of who burned the token, and the timestamp of burning.
1418             _ownerships[tokenId].addr = prevOwnership.addr;
1419             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1420             _ownerships[tokenId].burned = true;
1421 
1422             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1423             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1424             uint256 nextTokenId = tokenId + 1;
1425             if (_ownerships[nextTokenId].addr == address(0)) {
1426                 // This will suffice for checking _exists(nextTokenId),
1427                 // as a burned slot cannot contain the zero address.
1428                 if (nextTokenId < _currentIndex) {
1429                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1430                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1431                 }
1432             }
1433         }
1434 
1435         emit Transfer(prevOwnership.addr, address(0), tokenId);
1436         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1437 
1438         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1439         unchecked {
1440             _burnCounter++;
1441         }
1442     }
1443 
1444     /**
1445      * @dev Approve `to` to operate on `tokenId`
1446      *
1447      * Emits a {Approval} event.
1448      */
1449     function _approve(
1450         address to,
1451         uint256 tokenId,
1452         address owner
1453     ) private {
1454         _tokenApprovals[tokenId] = to;
1455         emit Approval(owner, to, tokenId);
1456     }
1457 
1458     /**
1459      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1460      *
1461      * @param from address representing the previous owner of the given token ID
1462      * @param to target address that will receive the tokens
1463      * @param tokenId uint256 ID of the token to be transferred
1464      * @param _data bytes optional data to send along with the call
1465      * @return bool whether the call correctly returned the expected magic value
1466      */
1467     function _checkContractOnERC721Received(
1468         address from,
1469         address to,
1470         uint256 tokenId,
1471         bytes memory _data
1472     ) private returns (bool) {
1473         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1474             return retval == IERC721Receiver(to).onERC721Received.selector;
1475         } catch (bytes memory reason) {
1476             if (reason.length == 0) {
1477                 revert TransferToNonERC721ReceiverImplementer();
1478             } else {
1479                 assembly {
1480                     revert(add(32, reason), mload(reason))
1481                 }
1482             }
1483         }
1484     }
1485 
1486     /**
1487      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1488      * And also called before burning one token.
1489      *
1490      * startTokenId - the first token id to be transferred
1491      * quantity - the amount to be transferred
1492      *
1493      * Calling conditions:
1494      *
1495      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1496      * transferred to `to`.
1497      * - When `from` is zero, `tokenId` will be minted for `to`.
1498      * - When `to` is zero, `tokenId` will be burned by `from`.
1499      * - `from` and `to` are never both zero.
1500      */
1501     function _beforeTokenTransfers(
1502         address from,
1503         address to,
1504         uint256 startTokenId,
1505         uint256 quantity
1506     ) internal virtual {}
1507 
1508     /**
1509      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1510      * minting.
1511      * And also called after one token has been burned.
1512      *
1513      * startTokenId - the first token id to be transferred
1514      * quantity - the amount to be transferred
1515      *
1516      * Calling conditions:
1517      *
1518      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1519      * transferred to `to`.
1520      * - When `from` is zero, `tokenId` has been minted for `to`.
1521      * - When `to` is zero, `tokenId` has been burned by `from`.
1522      * - `from` and `to` are never both zero.
1523      */
1524     function _afterTokenTransfers(
1525         address from,
1526         address to,
1527         uint256 startTokenId,
1528         uint256 quantity
1529     ) internal virtual {}
1530 }
1531 
1532 // File: @openzeppelin/contracts/access/Ownable.sol
1533 
1534 
1535 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1536 
1537 pragma solidity ^0.8.0;
1538 
1539 
1540 /**
1541  * @dev Contract module which provides a basic access control mechanism, where
1542  * there is an account (an owner) that can be granted exclusive access to
1543  * specific functions.
1544  *
1545  * By default, the owner account will be the one that deploys the contract. This
1546  * can later be changed with {transferOwnership}.
1547  *
1548  * This module is used through inheritance. It will make available the modifier
1549  * `onlyOwner`, which can be applied to your functions to restrict their use to
1550  * the owner.
1551  */
1552 abstract contract Ownable is Context {
1553     address private _owner;
1554 
1555     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1556 
1557     /**
1558      * @dev Initializes the contract setting the deployer as the initial owner.
1559      */
1560     constructor() {
1561         _transferOwnership(_msgSender());
1562     }
1563 
1564     /**
1565      * @dev Returns the address of the current owner.
1566      */
1567     function owner() public view virtual returns (address) {
1568         return _owner;
1569     }
1570 
1571     /**
1572      * @dev Throws if called by any account other than the owner.
1573      */
1574     modifier onlyOwner() {
1575         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1576         _;
1577     }
1578 
1579     /**
1580      * @dev Leaves the contract without owner. It will not be possible to call
1581      * `onlyOwner` functions anymore. Can only be called by the current owner.
1582      *
1583      * NOTE: Renouncing ownership will leave the contract without an owner,
1584      * thereby removing any functionality that is only available to the owner.
1585      */
1586     function renounceOwnership() public virtual onlyOwner {
1587         _transferOwnership(address(0));
1588     }
1589 
1590     /**
1591      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1592      * Can only be called by the current owner.
1593      */
1594     function transferOwnership(address newOwner) public virtual onlyOwner {
1595         require(newOwner != address(0), "Ownable: new owner is the zero address");
1596         _transferOwnership(newOwner);
1597     }
1598 
1599     /**
1600      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1601      * Internal function without access restriction.
1602      */
1603     function _transferOwnership(address newOwner) internal virtual {
1604         address oldOwner = _owner;
1605         _owner = newOwner;
1606         emit OwnershipTransferred(oldOwner, newOwner);
1607     }
1608 }
1609 
1610 // File: contracts/Tao.sol
1611 
1612 
1613 pragma solidity ^0.8.4;
1614 
1615 
1616 
1617 
1618 
1619 contract Tao is ERC721A, Ownable, ReentrancyGuard {
1620     using Strings for uint256;
1621     struct Identity {
1622         bytes32 r;
1623         bytes32 s;
1624         uint8 v;
1625     }
1626     enum IdentityType {
1627         SuperOG,
1628         OG,
1629         FreeMintWL,
1630         PreSaleWL
1631     }
1632     enum Status {
1633         Pending,
1634         FreeMint,
1635         PreSaleMint,
1636         PublicSale,
1637         Finished
1638     }
1639     Status public status;
1640     address private _Signer;
1641     address private _publicSigner;
1642     string public _baseTokenURI;
1643     uint256 public immutable maxSupply;
1644     uint8 public  MAX_SUPEROG_FREEMINTS_PER_ADDRESS = 3;
1645     uint8 public  MAX_OG_FREEMINTS_PER_ADDRESS = 2;
1646     uint8 public  MAX_WL_FREEMINTS_PER_ADDRESS = 1;
1647     uint8 public  MAX_PRESALEWL_MINTS_PER_ADDRESS = 2;
1648     uint8 public  MAX_PUBLICSALE_MINTS_PER_ADDRESS = 3;
1649     uint256 public FreeMintSupply = 1088;
1650     uint256 public PreSaleSupply = 3000;
1651     uint256 public PublicSaleSupply = 1800;
1652     uint256 public FreeMinted = 0;
1653     uint256 public PreSaleMinted = 0;
1654     uint256 public PublicSaleMinted = 0;
1655     uint256 public constant PRICEPRESALE = 0.0266 ether;
1656     uint256 public constant PRICEPUBILCSALE = 0.0388 ether;
1657 
1658     event StatusChanged(Status status);
1659 
1660     //publicMinted
1661     mapping (address => uint256) public PublicMinted;
1662 
1663     constructor(
1664         uint256 _maxSupply,
1665         address  Signer,
1666         address PublicSigner
1667     ) ERC721A ("Tao","TAO") {
1668         maxSupply = _maxSupply;
1669         _Signer = Signer;
1670         _publicSigner = PublicSigner;
1671     }
1672 
1673     modifier callerIsUser() {
1674         require(tx.origin == msg.sender, "The caller is another contract");
1675          _;
1676      }
1677     modifier FreeMint(uint256 num) {
1678          require(status == Status.FreeMint, "FreeMint not Started");
1679          require(FreeMinted + num <= FreeMintSupply, "FreeMint Supply Exceeded");
1680          require(totalSupply() + num <= maxSupply, "Exceeds Total Supply");
1681          _;
1682     }
1683    
1684     function _FreeMintSuperOG(uint256 quantity, Identity memory identity) external callerIsUser FreeMint(quantity) {
1685         require(numberMinted(msg.sender) + quantity <= MAX_SUPEROG_FREEMINTS_PER_ADDRESS, "Max mint amount per wallet exceeded.");
1686         bytes32 digest = keccak256(abi.encode(IdentityType.SuperOG, msg.sender));
1687         require(_isVerifiedIdentity(digest, identity), "address is not allowlisted");
1688         _safeMint(msg.sender, quantity);
1689         FreeMinted += quantity;
1690     }
1691 
1692     function _FreeMintOG(uint256 quantity, Identity memory identity) external callerIsUser FreeMint(quantity) {
1693         require(numberMinted(msg.sender) + quantity <= MAX_OG_FREEMINTS_PER_ADDRESS, "Max mint amount per wallet exceeded.");
1694         bytes32 digest = keccak256(abi.encode(IdentityType.OG, msg.sender));
1695         require(_isVerifiedIdentity(digest, identity), "address is not allowlisted");
1696         _safeMint(msg.sender, quantity);
1697         FreeMinted += quantity;
1698     }
1699 
1700     function _FreeMintWL(uint256 quantity, Identity memory identity) external callerIsUser FreeMint(quantity) {
1701         require(numberMinted(msg.sender) + quantity <= MAX_WL_FREEMINTS_PER_ADDRESS, "Max mint amount per wallet exceeded.");
1702         bytes32 digest = keccak256(abi.encode(IdentityType.FreeMintWL, msg.sender));
1703         require(_isVerifiedIdentity(digest, identity), "address is not allowlisted");
1704         _safeMint(msg.sender, quantity);
1705         FreeMinted += quantity;
1706     }
1707     
1708     function _PreSaleMint(uint256 quantity, Identity memory identity) external payable callerIsUser {
1709         require(status == Status.PreSaleMint, "PreSaleMint not started");
1710         require(msg.value >= PRICEPRESALE * quantity, "need more eth");
1711         require(numberMinted(msg.sender) + quantity <= MAX_PRESALEWL_MINTS_PER_ADDRESS, "Max mint amount per wallet exceeded.");
1712         require(PreSaleMinted + quantity <= PreSaleSupply, "PreSaleSupply Exceeded");
1713         require(totalSupply() + quantity <= maxSupply, "Exceeds total supply");
1714         bytes32 digest = keccak256(abi.encode(IdentityType.PreSaleWL, msg.sender));
1715         require(_isVerifiedIdentity(digest, identity), "address is not allowlisted");
1716          _safeMint(msg.sender, quantity);
1717         PreSaleMinted += quantity;
1718     }
1719 
1720     function _PublicSaleMint(uint256 quantity, bytes32 hash, bytes memory signature) external payable callerIsUser {
1721         require(status == Status.PublicSale, "PublicSale not started");
1722         require(PublicSaleMinted + quantity <= PublicSaleSupply, "PublicSaleSupply Exceeded");
1723         require(PublicMinted[msg.sender] + quantity <= MAX_PUBLICSALE_MINTS_PER_ADDRESS, "Max mint amount per wallet exceeded");
1724         require(msg.value >= PRICEPUBILCSALE * quantity, "need more eth");
1725         require(recoverSigner(hash, signature) == _publicSigner, "This address is not allowed");
1726         require(totalSupply() + quantity <= maxSupply, "Exceeds total supply");
1727          _safeMint(msg.sender, quantity);
1728         PublicSaleMinted += quantity;
1729         PublicMinted[msg.sender] += quantity;
1730     }
1731     
1732     function _isVerifiedIdentity(bytes32 digest, Identity memory identity) internal view returns(bool) {
1733         address signer = ecrecover(digest, identity.v, identity.r, identity.s);
1734         require(signer != address(0), "ECDSA: invalid signature");
1735         return signer == _Signer;
1736     }
1737     
1738     function recoverSigner(bytes32 hash, bytes memory signature) internal pure returns(address) {
1739         bytes32 messageDigest = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1740         return ECDSA.recover(messageDigest, signature);
1741     }
1742     
1743     function _setStatus(Status _status) external onlyOwner {
1744         status = _status;
1745         emit StatusChanged(status);
1746     }
1747     
1748     function numberMinted(address owner) public view returns(uint256) {
1749         return _numberMinted(owner);
1750     }
1751 
1752     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1753             return string(abi.encodePacked(
1754                 _baseTokenURI, 
1755                 tokenId.toString(),
1756                 ".json"
1757                 ));
1758     }
1759 
1760     function setBaseTokenURI(string memory baseTokenURI) public onlyOwner {
1761         _baseTokenURI = baseTokenURI;
1762     }
1763 
1764     function getStatus() public view returns(Status) {
1765         return status;
1766     }
1767 
1768     function devMint(uint256 quantity) external onlyOwner {
1769         require(status == Status.Finished);
1770         require(totalSupply() + quantity <= maxSupply);
1771          _safeMint(msg.sender, quantity);
1772     }
1773 
1774     function withdrawMoney() external onlyOwner nonReentrant {
1775         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1776         require(success, "Transfer failed.");
1777     }
1778 
1779 }