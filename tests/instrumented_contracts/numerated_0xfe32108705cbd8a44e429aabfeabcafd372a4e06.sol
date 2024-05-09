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
74 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/ECDSA.sol)
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
191         bytes32 s;
192         uint8 v;
193         assembly {
194             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
195             v := add(shr(255, vs), 27)
196         }
197         return tryRecover(hash, v, r, s);
198     }
199 
200     /**
201      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
202      *
203      * _Available since v4.2._
204      */
205     function recover(
206         bytes32 hash,
207         bytes32 r,
208         bytes32 vs
209     ) internal pure returns (address) {
210         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
211         _throwError(error);
212         return recovered;
213     }
214 
215     /**
216      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
217      * `r` and `s` signature fields separately.
218      *
219      * _Available since v4.3._
220      */
221     function tryRecover(
222         bytes32 hash,
223         uint8 v,
224         bytes32 r,
225         bytes32 s
226     ) internal pure returns (address, RecoverError) {
227         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
228         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
229         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
230         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
231         //
232         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
233         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
234         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
235         // these malleable signatures as well.
236         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
237             return (address(0), RecoverError.InvalidSignatureS);
238         }
239         if (v != 27 && v != 28) {
240             return (address(0), RecoverError.InvalidSignatureV);
241         }
242 
243         // If the signature is valid (and not malleable), return the signer address
244         address signer = ecrecover(hash, v, r, s);
245         if (signer == address(0)) {
246             return (address(0), RecoverError.InvalidSignature);
247         }
248 
249         return (signer, RecoverError.NoError);
250     }
251 
252     /**
253      * @dev Overload of {ECDSA-recover} that receives the `v`,
254      * `r` and `s` signature fields separately.
255      */
256     function recover(
257         bytes32 hash,
258         uint8 v,
259         bytes32 r,
260         bytes32 s
261     ) internal pure returns (address) {
262         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
263         _throwError(error);
264         return recovered;
265     }
266 
267     /**
268      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
269      * produces hash corresponding to the one signed with the
270      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
271      * JSON-RPC method as part of EIP-191.
272      *
273      * See {recover}.
274      */
275     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
276         // 32 is the length in bytes of hash,
277         // enforced by the type signature above
278         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
279     }
280 
281     /**
282      * @dev Returns an Ethereum Signed Message, created from `s`. This
283      * produces hash corresponding to the one signed with the
284      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
285      * JSON-RPC method as part of EIP-191.
286      *
287      * See {recover}.
288      */
289     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
290         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
291     }
292 
293     /**
294      * @dev Returns an Ethereum Signed Typed Data, created from a
295      * `domainSeparator` and a `structHash`. This produces hash corresponding
296      * to the one signed with the
297      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
298      * JSON-RPC method as part of EIP-712.
299      *
300      * See {recover}.
301      */
302     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
303         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
304     }
305 }
306 
307 // File: @openzeppelin/contracts/utils/Address.sol
308 
309 
310 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
311 
312 pragma solidity ^0.8.0;
313 
314 /**
315  * @dev Collection of functions related to the address type
316  */
317 library Address {
318     /**
319      * @dev Returns true if `account` is a contract.
320      *
321      * [IMPORTANT]
322      * ====
323      * It is unsafe to assume that an address for which this function returns
324      * false is an externally-owned account (EOA) and not a contract.
325      *
326      * Among others, `isContract` will return false for the following
327      * types of addresses:
328      *
329      *  - an externally-owned account
330      *  - a contract in construction
331      *  - an address where a contract will be created
332      *  - an address where a contract lived, but was destroyed
333      * ====
334      */
335     function isContract(address account) internal view returns (bool) {
336         // This method relies on extcodesize, which returns 0 for contracts in
337         // construction, since the code is only stored at the end of the
338         // constructor execution.
339 
340         uint256 size;
341         assembly {
342             size := extcodesize(account)
343         }
344         return size > 0;
345     }
346 
347     /**
348      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
349      * `recipient`, forwarding all available gas and reverting on errors.
350      *
351      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
352      * of certain opcodes, possibly making contracts go over the 2300 gas limit
353      * imposed by `transfer`, making them unable to receive funds via
354      * `transfer`. {sendValue} removes this limitation.
355      *
356      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
357      *
358      * IMPORTANT: because control is transferred to `recipient`, care must be
359      * taken to not create reentrancy vulnerabilities. Consider using
360      * {ReentrancyGuard} or the
361      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
362      */
363     function sendValue(address payable recipient, uint256 amount) internal {
364         require(address(this).balance >= amount, "Address: insufficient balance");
365 
366         (bool success, ) = recipient.call{value: amount}("");
367         require(success, "Address: unable to send value, recipient may have reverted");
368     }
369 
370     /**
371      * @dev Performs a Solidity function call using a low level `call`. A
372      * plain `call` is an unsafe replacement for a function call: use this
373      * function instead.
374      *
375      * If `target` reverts with a revert reason, it is bubbled up by this
376      * function (like regular Solidity function calls).
377      *
378      * Returns the raw returned data. To convert to the expected return value,
379      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
380      *
381      * Requirements:
382      *
383      * - `target` must be a contract.
384      * - calling `target` with `data` must not revert.
385      *
386      * _Available since v3.1._
387      */
388     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
389         return functionCall(target, data, "Address: low-level call failed");
390     }
391 
392     /**
393      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
394      * `errorMessage` as a fallback revert reason when `target` reverts.
395      *
396      * _Available since v3.1._
397      */
398     function functionCall(
399         address target,
400         bytes memory data,
401         string memory errorMessage
402     ) internal returns (bytes memory) {
403         return functionCallWithValue(target, data, 0, errorMessage);
404     }
405 
406     /**
407      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
408      * but also transferring `value` wei to `target`.
409      *
410      * Requirements:
411      *
412      * - the calling contract must have an ETH balance of at least `value`.
413      * - the called Solidity function must be `payable`.
414      *
415      * _Available since v3.1._
416      */
417     function functionCallWithValue(
418         address target,
419         bytes memory data,
420         uint256 value
421     ) internal returns (bytes memory) {
422         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
423     }
424 
425     /**
426      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
427      * with `errorMessage` as a fallback revert reason when `target` reverts.
428      *
429      * _Available since v3.1._
430      */
431     function functionCallWithValue(
432         address target,
433         bytes memory data,
434         uint256 value,
435         string memory errorMessage
436     ) internal returns (bytes memory) {
437         require(address(this).balance >= value, "Address: insufficient balance for call");
438         require(isContract(target), "Address: call to non-contract");
439 
440         (bool success, bytes memory returndata) = target.call{value: value}(data);
441         return verifyCallResult(success, returndata, errorMessage);
442     }
443 
444     /**
445      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
446      * but performing a static call.
447      *
448      * _Available since v3.3._
449      */
450     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
451         return functionStaticCall(target, data, "Address: low-level static call failed");
452     }
453 
454     /**
455      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
456      * but performing a static call.
457      *
458      * _Available since v3.3._
459      */
460     function functionStaticCall(
461         address target,
462         bytes memory data,
463         string memory errorMessage
464     ) internal view returns (bytes memory) {
465         require(isContract(target), "Address: static call to non-contract");
466 
467         (bool success, bytes memory returndata) = target.staticcall(data);
468         return verifyCallResult(success, returndata, errorMessage);
469     }
470 
471     /**
472      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
473      * but performing a delegate call.
474      *
475      * _Available since v3.4._
476      */
477     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
478         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
479     }
480 
481     /**
482      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
483      * but performing a delegate call.
484      *
485      * _Available since v3.4._
486      */
487     function functionDelegateCall(
488         address target,
489         bytes memory data,
490         string memory errorMessage
491     ) internal returns (bytes memory) {
492         require(isContract(target), "Address: delegate call to non-contract");
493 
494         (bool success, bytes memory returndata) = target.delegatecall(data);
495         return verifyCallResult(success, returndata, errorMessage);
496     }
497 
498     /**
499      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
500      * revert reason using the provided one.
501      *
502      * _Available since v4.3._
503      */
504     function verifyCallResult(
505         bool success,
506         bytes memory returndata,
507         string memory errorMessage
508     ) internal pure returns (bytes memory) {
509         if (success) {
510             return returndata;
511         } else {
512             // Look for revert reason and bubble it up if present
513             if (returndata.length > 0) {
514                 // The easiest way to bubble the revert reason is using memory via assembly
515 
516                 assembly {
517                     let returndata_size := mload(returndata)
518                     revert(add(32, returndata), returndata_size)
519                 }
520             } else {
521                 revert(errorMessage);
522             }
523         }
524     }
525 }
526 
527 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
528 
529 
530 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
531 
532 pragma solidity ^0.8.0;
533 
534 /**
535  * @title ERC721 token receiver interface
536  * @dev Interface for any contract that wants to support safeTransfers
537  * from ERC721 asset contracts.
538  */
539 interface IERC721Receiver {
540     /**
541      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
542      * by `operator` from `from`, this function is called.
543      *
544      * It must return its Solidity selector to confirm the token transfer.
545      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
546      *
547      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
548      */
549     function onERC721Received(
550         address operator,
551         address from,
552         uint256 tokenId,
553         bytes calldata data
554     ) external returns (bytes4);
555 }
556 
557 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
558 
559 
560 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
561 
562 pragma solidity ^0.8.0;
563 
564 /**
565  * @dev Interface of the ERC165 standard, as defined in the
566  * https://eips.ethereum.org/EIPS/eip-165[EIP].
567  *
568  * Implementers can declare support of contract interfaces, which can then be
569  * queried by others ({ERC165Checker}).
570  *
571  * For an implementation, see {ERC165}.
572  */
573 interface IERC165 {
574     /**
575      * @dev Returns true if this contract implements the interface defined by
576      * `interfaceId`. See the corresponding
577      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
578      * to learn more about how these ids are created.
579      *
580      * This function call must use less than 30 000 gas.
581      */
582     function supportsInterface(bytes4 interfaceId) external view returns (bool);
583 }
584 
585 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
586 
587 
588 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
589 
590 pragma solidity ^0.8.0;
591 
592 
593 /**
594  * @dev Implementation of the {IERC165} interface.
595  *
596  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
597  * for the additional interface id that will be supported. For example:
598  *
599  * ```solidity
600  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
601  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
602  * }
603  * ```
604  *
605  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
606  */
607 abstract contract ERC165 is IERC165 {
608     /**
609      * @dev See {IERC165-supportsInterface}.
610      */
611     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
612         return interfaceId == type(IERC165).interfaceId;
613     }
614 }
615 
616 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
617 
618 
619 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
620 
621 pragma solidity ^0.8.0;
622 
623 
624 /**
625  * @dev Required interface of an ERC721 compliant contract.
626  */
627 interface IERC721 is IERC165 {
628     /**
629      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
630      */
631     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
632 
633     /**
634      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
635      */
636     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
637 
638     /**
639      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
640      */
641     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
642 
643     /**
644      * @dev Returns the number of tokens in ``owner``'s account.
645      */
646     function balanceOf(address owner) external view returns (uint256 balance);
647 
648     /**
649      * @dev Returns the owner of the `tokenId` token.
650      *
651      * Requirements:
652      *
653      * - `tokenId` must exist.
654      */
655     function ownerOf(uint256 tokenId) external view returns (address owner);
656 
657     /**
658      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
659      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
660      *
661      * Requirements:
662      *
663      * - `from` cannot be the zero address.
664      * - `to` cannot be the zero address.
665      * - `tokenId` token must exist and be owned by `from`.
666      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
667      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
668      *
669      * Emits a {Transfer} event.
670      */
671     function safeTransferFrom(
672         address from,
673         address to,
674         uint256 tokenId
675     ) external;
676 
677     /**
678      * @dev Transfers `tokenId` token from `from` to `to`.
679      *
680      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
681      *
682      * Requirements:
683      *
684      * - `from` cannot be the zero address.
685      * - `to` cannot be the zero address.
686      * - `tokenId` token must be owned by `from`.
687      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
688      *
689      * Emits a {Transfer} event.
690      */
691     function transferFrom(
692         address from,
693         address to,
694         uint256 tokenId
695     ) external;
696 
697     /**
698      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
699      * The approval is cleared when the token is transferred.
700      *
701      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
702      *
703      * Requirements:
704      *
705      * - The caller must own the token or be an approved operator.
706      * - `tokenId` must exist.
707      *
708      * Emits an {Approval} event.
709      */
710     function approve(address to, uint256 tokenId) external;
711 
712     /**
713      * @dev Returns the account approved for `tokenId` token.
714      *
715      * Requirements:
716      *
717      * - `tokenId` must exist.
718      */
719     function getApproved(uint256 tokenId) external view returns (address operator);
720 
721     /**
722      * @dev Approve or remove `operator` as an operator for the caller.
723      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
724      *
725      * Requirements:
726      *
727      * - The `operator` cannot be the caller.
728      *
729      * Emits an {ApprovalForAll} event.
730      */
731     function setApprovalForAll(address operator, bool _approved) external;
732 
733     /**
734      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
735      *
736      * See {setApprovalForAll}
737      */
738     function isApprovedForAll(address owner, address operator) external view returns (bool);
739 
740     /**
741      * @dev Safely transfers `tokenId` token from `from` to `to`.
742      *
743      * Requirements:
744      *
745      * - `from` cannot be the zero address.
746      * - `to` cannot be the zero address.
747      * - `tokenId` token must exist and be owned by `from`.
748      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
749      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
750      *
751      * Emits a {Transfer} event.
752      */
753     function safeTransferFrom(
754         address from,
755         address to,
756         uint256 tokenId,
757         bytes calldata data
758     ) external;
759 }
760 
761 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
762 
763 
764 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
765 
766 pragma solidity ^0.8.0;
767 
768 
769 /**
770  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
771  * @dev See https://eips.ethereum.org/EIPS/eip-721
772  */
773 interface IERC721Enumerable is IERC721 {
774     /**
775      * @dev Returns the total amount of tokens stored by the contract.
776      */
777     function totalSupply() external view returns (uint256);
778 
779     /**
780      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
781      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
782      */
783     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
784 
785     /**
786      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
787      * Use along with {totalSupply} to enumerate all tokens.
788      */
789     function tokenByIndex(uint256 index) external view returns (uint256);
790 }
791 
792 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
793 
794 
795 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
796 
797 pragma solidity ^0.8.0;
798 
799 
800 /**
801  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
802  * @dev See https://eips.ethereum.org/EIPS/eip-721
803  */
804 interface IERC721Metadata is IERC721 {
805     /**
806      * @dev Returns the token collection name.
807      */
808     function name() external view returns (string memory);
809 
810     /**
811      * @dev Returns the token collection symbol.
812      */
813     function symbol() external view returns (string memory);
814 
815     /**
816      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
817      */
818     function tokenURI(uint256 tokenId) external view returns (string memory);
819 }
820 
821 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
822 
823 
824 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
825 
826 pragma solidity ^0.8.0;
827 
828 // CAUTION
829 // This version of SafeMath should only be used with Solidity 0.8 or later,
830 // because it relies on the compiler's built in overflow checks.
831 
832 /**
833  * @dev Wrappers over Solidity's arithmetic operations.
834  *
835  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
836  * now has built in overflow checking.
837  */
838 library SafeMath {
839     /**
840      * @dev Returns the addition of two unsigned integers, with an overflow flag.
841      *
842      * _Available since v3.4._
843      */
844     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
845         unchecked {
846             uint256 c = a + b;
847             if (c < a) return (false, 0);
848             return (true, c);
849         }
850     }
851 
852     /**
853      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
854      *
855      * _Available since v3.4._
856      */
857     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
858         unchecked {
859             if (b > a) return (false, 0);
860             return (true, a - b);
861         }
862     }
863 
864     /**
865      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
866      *
867      * _Available since v3.4._
868      */
869     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
870         unchecked {
871             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
872             // benefit is lost if 'b' is also tested.
873             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
874             if (a == 0) return (true, 0);
875             uint256 c = a * b;
876             if (c / a != b) return (false, 0);
877             return (true, c);
878         }
879     }
880 
881     /**
882      * @dev Returns the division of two unsigned integers, with a division by zero flag.
883      *
884      * _Available since v3.4._
885      */
886     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
887         unchecked {
888             if (b == 0) return (false, 0);
889             return (true, a / b);
890         }
891     }
892 
893     /**
894      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
895      *
896      * _Available since v3.4._
897      */
898     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
899         unchecked {
900             if (b == 0) return (false, 0);
901             return (true, a % b);
902         }
903     }
904 
905     /**
906      * @dev Returns the addition of two unsigned integers, reverting on
907      * overflow.
908      *
909      * Counterpart to Solidity's `+` operator.
910      *
911      * Requirements:
912      *
913      * - Addition cannot overflow.
914      */
915     function add(uint256 a, uint256 b) internal pure returns (uint256) {
916         return a + b;
917     }
918 
919     /**
920      * @dev Returns the subtraction of two unsigned integers, reverting on
921      * overflow (when the result is negative).
922      *
923      * Counterpart to Solidity's `-` operator.
924      *
925      * Requirements:
926      *
927      * - Subtraction cannot overflow.
928      */
929     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
930         return a - b;
931     }
932 
933     /**
934      * @dev Returns the multiplication of two unsigned integers, reverting on
935      * overflow.
936      *
937      * Counterpart to Solidity's `*` operator.
938      *
939      * Requirements:
940      *
941      * - Multiplication cannot overflow.
942      */
943     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
944         return a * b;
945     }
946 
947     /**
948      * @dev Returns the integer division of two unsigned integers, reverting on
949      * division by zero. The result is rounded towards zero.
950      *
951      * Counterpart to Solidity's `/` operator.
952      *
953      * Requirements:
954      *
955      * - The divisor cannot be zero.
956      */
957     function div(uint256 a, uint256 b) internal pure returns (uint256) {
958         return a / b;
959     }
960 
961     /**
962      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
963      * reverting when dividing by zero.
964      *
965      * Counterpart to Solidity's `%` operator. This function uses a `revert`
966      * opcode (which leaves remaining gas untouched) while Solidity uses an
967      * invalid opcode to revert (consuming all remaining gas).
968      *
969      * Requirements:
970      *
971      * - The divisor cannot be zero.
972      */
973     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
974         return a % b;
975     }
976 
977     /**
978      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
979      * overflow (when the result is negative).
980      *
981      * CAUTION: This function is deprecated because it requires allocating memory for the error
982      * message unnecessarily. For custom revert reasons use {trySub}.
983      *
984      * Counterpart to Solidity's `-` operator.
985      *
986      * Requirements:
987      *
988      * - Subtraction cannot overflow.
989      */
990     function sub(
991         uint256 a,
992         uint256 b,
993         string memory errorMessage
994     ) internal pure returns (uint256) {
995         unchecked {
996             require(b <= a, errorMessage);
997             return a - b;
998         }
999     }
1000 
1001     /**
1002      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1003      * division by zero. The result is rounded towards zero.
1004      *
1005      * Counterpart to Solidity's `/` operator. Note: this function uses a
1006      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1007      * uses an invalid opcode to revert (consuming all remaining gas).
1008      *
1009      * Requirements:
1010      *
1011      * - The divisor cannot be zero.
1012      */
1013     function div(
1014         uint256 a,
1015         uint256 b,
1016         string memory errorMessage
1017     ) internal pure returns (uint256) {
1018         unchecked {
1019             require(b > 0, errorMessage);
1020             return a / b;
1021         }
1022     }
1023 
1024     /**
1025      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1026      * reverting with custom message when dividing by zero.
1027      *
1028      * CAUTION: This function is deprecated because it requires allocating memory for the error
1029      * message unnecessarily. For custom revert reasons use {tryMod}.
1030      *
1031      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1032      * opcode (which leaves remaining gas untouched) while Solidity uses an
1033      * invalid opcode to revert (consuming all remaining gas).
1034      *
1035      * Requirements:
1036      *
1037      * - The divisor cannot be zero.
1038      */
1039     function mod(
1040         uint256 a,
1041         uint256 b,
1042         string memory errorMessage
1043     ) internal pure returns (uint256) {
1044         unchecked {
1045             require(b > 0, errorMessage);
1046             return a % b;
1047         }
1048     }
1049 }
1050 
1051 // File: @openzeppelin/contracts/utils/Context.sol
1052 
1053 
1054 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1055 
1056 pragma solidity ^0.8.0;
1057 
1058 /**
1059  * @dev Provides information about the current execution context, including the
1060  * sender of the transaction and its data. While these are generally available
1061  * via msg.sender and msg.data, they should not be accessed in such a direct
1062  * manner, since when dealing with meta-transactions the account sending and
1063  * paying for execution may not be the actual sender (as far as an application
1064  * is concerned).
1065  *
1066  * This contract is only required for intermediate, library-like contracts.
1067  */
1068 abstract contract Context {
1069     function _msgSender() internal view virtual returns (address) {
1070         return msg.sender;
1071     }
1072 
1073     function _msgData() internal view virtual returns (bytes calldata) {
1074         return msg.data;
1075     }
1076 }
1077 
1078 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1079 
1080 
1081 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
1082 
1083 pragma solidity ^0.8.0;
1084 
1085 
1086 
1087 
1088 
1089 
1090 
1091 
1092 /**
1093  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1094  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1095  * {ERC721Enumerable}.
1096  */
1097 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1098     using Address for address;
1099     using Strings for uint256;
1100 
1101     // Token name
1102     string private _name;
1103 
1104     // Token symbol
1105     string private _symbol;
1106 
1107     // Mapping from token ID to owner address
1108     mapping(uint256 => address) private _owners;
1109 
1110     // Mapping owner address to token count
1111     mapping(address => uint256) private _balances;
1112 
1113     // Mapping from token ID to approved address
1114     mapping(uint256 => address) private _tokenApprovals;
1115 
1116     // Mapping from owner to operator approvals
1117     mapping(address => mapping(address => bool)) private _operatorApprovals;
1118 
1119     /**
1120      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1121      */
1122     constructor(string memory name_, string memory symbol_) {
1123         _name = name_;
1124         _symbol = symbol_;
1125     }
1126 
1127     /**
1128      * @dev See {IERC165-supportsInterface}.
1129      */
1130     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1131         return
1132             interfaceId == type(IERC721).interfaceId ||
1133             interfaceId == type(IERC721Metadata).interfaceId ||
1134             super.supportsInterface(interfaceId);
1135     }
1136 
1137     /**
1138      * @dev See {IERC721-balanceOf}.
1139      */
1140     function balanceOf(address owner) public view virtual override returns (uint256) {
1141         require(owner != address(0), "ERC721: balance query for the zero address");
1142         return _balances[owner];
1143     }
1144 
1145     /**
1146      * @dev See {IERC721-ownerOf}.
1147      */
1148     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1149         address owner = _owners[tokenId];
1150         require(owner != address(0), "ERC721: owner query for nonexistent token");
1151         return owner;
1152     }
1153 
1154     /**
1155      * @dev See {IERC721Metadata-name}.
1156      */
1157     function name() public view virtual override returns (string memory) {
1158         return _name;
1159     }
1160 
1161     /**
1162      * @dev See {IERC721Metadata-symbol}.
1163      */
1164     function symbol() public view virtual override returns (string memory) {
1165         return _symbol;
1166     }
1167 
1168     /**
1169      * @dev See {IERC721Metadata-tokenURI}.
1170      */
1171     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1172         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1173 
1174         string memory baseURI = _baseURI();
1175         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1176     }
1177 
1178     /**
1179      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1180      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1181      * by default, can be overriden in child contracts.
1182      */
1183     function _baseURI() internal view virtual returns (string memory) {
1184         return "";
1185     }
1186 
1187     /**
1188      * @dev See {IERC721-approve}.
1189      */
1190     function approve(address to, uint256 tokenId) public virtual override {
1191         address owner = ERC721.ownerOf(tokenId);
1192         require(to != owner, "ERC721: approval to current owner");
1193 
1194         require(
1195             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1196             "ERC721: approve caller is not owner nor approved for all"
1197         );
1198 
1199         _approve(to, tokenId);
1200     }
1201 
1202     /**
1203      * @dev See {IERC721-getApproved}.
1204      */
1205     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1206         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1207 
1208         return _tokenApprovals[tokenId];
1209     }
1210 
1211     /**
1212      * @dev See {IERC721-setApprovalForAll}.
1213      */
1214     function setApprovalForAll(address operator, bool approved) public virtual override {
1215         _setApprovalForAll(_msgSender(), operator, approved);
1216     }
1217 
1218     /**
1219      * @dev See {IERC721-isApprovedForAll}.
1220      */
1221     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1222         return _operatorApprovals[owner][operator];
1223     }
1224 
1225     /**
1226      * @dev See {IERC721-transferFrom}.
1227      */
1228     function transferFrom(
1229         address from,
1230         address to,
1231         uint256 tokenId
1232     ) public virtual override {
1233         //solhint-disable-next-line max-line-length
1234         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1235 
1236         _transfer(from, to, tokenId);
1237     }
1238 
1239     /**
1240      * @dev See {IERC721-safeTransferFrom}.
1241      */
1242     function safeTransferFrom(
1243         address from,
1244         address to,
1245         uint256 tokenId
1246     ) public virtual override {
1247         safeTransferFrom(from, to, tokenId, "");
1248     }
1249 
1250     /**
1251      * @dev See {IERC721-safeTransferFrom}.
1252      */
1253     function safeTransferFrom(
1254         address from,
1255         address to,
1256         uint256 tokenId,
1257         bytes memory _data
1258     ) public virtual override {
1259         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1260         _safeTransfer(from, to, tokenId, _data);
1261     }
1262 
1263     /**
1264      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1265      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1266      *
1267      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1268      *
1269      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1270      * implement alternative mechanisms to perform token transfer, such as signature-based.
1271      *
1272      * Requirements:
1273      *
1274      * - `from` cannot be the zero address.
1275      * - `to` cannot be the zero address.
1276      * - `tokenId` token must exist and be owned by `from`.
1277      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1278      *
1279      * Emits a {Transfer} event.
1280      */
1281     function _safeTransfer(
1282         address from,
1283         address to,
1284         uint256 tokenId,
1285         bytes memory _data
1286     ) internal virtual {
1287         _transfer(from, to, tokenId);
1288         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1289     }
1290 
1291     /**
1292      * @dev Returns whether `tokenId` exists.
1293      *
1294      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1295      *
1296      * Tokens start existing when they are minted (`_mint`),
1297      * and stop existing when they are burned (`_burn`).
1298      */
1299     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1300         return _owners[tokenId] != address(0);
1301     }
1302 
1303     /**
1304      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1305      *
1306      * Requirements:
1307      *
1308      * - `tokenId` must exist.
1309      */
1310     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1311         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1312         address owner = ERC721.ownerOf(tokenId);
1313         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1314     }
1315 
1316     /**
1317      * @dev Safely mints `tokenId` and transfers it to `to`.
1318      *
1319      * Requirements:
1320      *
1321      * - `tokenId` must not exist.
1322      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1323      *
1324      * Emits a {Transfer} event.
1325      */
1326     function _safeMint(address to, uint256 tokenId) internal virtual {
1327         _safeMint(to, tokenId, "");
1328     }
1329 
1330     /**
1331      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1332      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1333      */
1334     function _safeMint(
1335         address to,
1336         uint256 tokenId,
1337         bytes memory _data
1338     ) internal virtual {
1339         _mint(to, tokenId);
1340         require(
1341             _checkOnERC721Received(address(0), to, tokenId, _data),
1342             "ERC721: transfer to non ERC721Receiver implementer"
1343         );
1344     }
1345 
1346     /**
1347      * @dev Mints `tokenId` and transfers it to `to`.
1348      *
1349      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1350      *
1351      * Requirements:
1352      *
1353      * - `tokenId` must not exist.
1354      * - `to` cannot be the zero address.
1355      *
1356      * Emits a {Transfer} event.
1357      */
1358     function _mint(address to, uint256 tokenId) internal virtual {
1359         require(to != address(0), "ERC721: mint to the zero address");
1360         require(!_exists(tokenId), "ERC721: token already minted");
1361 
1362         _beforeTokenTransfer(address(0), to, tokenId);
1363 
1364         _balances[to] += 1;
1365         _owners[tokenId] = to;
1366 
1367         emit Transfer(address(0), to, tokenId);
1368     }
1369 
1370     /**
1371      * @dev Destroys `tokenId`.
1372      * The approval is cleared when the token is burned.
1373      *
1374      * Requirements:
1375      *
1376      * - `tokenId` must exist.
1377      *
1378      * Emits a {Transfer} event.
1379      */
1380     function _burn(uint256 tokenId) internal virtual {
1381         address owner = ERC721.ownerOf(tokenId);
1382 
1383         _beforeTokenTransfer(owner, address(0), tokenId);
1384 
1385         // Clear approvals
1386         _approve(address(0), tokenId);
1387 
1388         _balances[owner] -= 1;
1389         delete _owners[tokenId];
1390 
1391         emit Transfer(owner, address(0), tokenId);
1392     }
1393 
1394     /**
1395      * @dev Transfers `tokenId` from `from` to `to`.
1396      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1397      *
1398      * Requirements:
1399      *
1400      * - `to` cannot be the zero address.
1401      * - `tokenId` token must be owned by `from`.
1402      *
1403      * Emits a {Transfer} event.
1404      */
1405     function _transfer(
1406         address from,
1407         address to,
1408         uint256 tokenId
1409     ) internal virtual {
1410         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1411         require(to != address(0), "ERC721: transfer to the zero address");
1412 
1413         _beforeTokenTransfer(from, to, tokenId);
1414 
1415         // Clear approvals from the previous owner
1416         _approve(address(0), tokenId);
1417 
1418         _balances[from] -= 1;
1419         _balances[to] += 1;
1420         _owners[tokenId] = to;
1421 
1422         emit Transfer(from, to, tokenId);
1423     }
1424 
1425     /**
1426      * @dev Approve `to` to operate on `tokenId`
1427      *
1428      * Emits a {Approval} event.
1429      */
1430     function _approve(address to, uint256 tokenId) internal virtual {
1431         _tokenApprovals[tokenId] = to;
1432         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1433     }
1434 
1435     /**
1436      * @dev Approve `operator` to operate on all of `owner` tokens
1437      *
1438      * Emits a {ApprovalForAll} event.
1439      */
1440     function _setApprovalForAll(
1441         address owner,
1442         address operator,
1443         bool approved
1444     ) internal virtual {
1445         require(owner != operator, "ERC721: approve to caller");
1446         _operatorApprovals[owner][operator] = approved;
1447         emit ApprovalForAll(owner, operator, approved);
1448     }
1449 
1450     /**
1451      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1452      * The call is not executed if the target address is not a contract.
1453      *
1454      * @param from address representing the previous owner of the given token ID
1455      * @param to target address that will receive the tokens
1456      * @param tokenId uint256 ID of the token to be transferred
1457      * @param _data bytes optional data to send along with the call
1458      * @return bool whether the call correctly returned the expected magic value
1459      */
1460     function _checkOnERC721Received(
1461         address from,
1462         address to,
1463         uint256 tokenId,
1464         bytes memory _data
1465     ) private returns (bool) {
1466         if (to.isContract()) {
1467             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1468                 return retval == IERC721Receiver.onERC721Received.selector;
1469             } catch (bytes memory reason) {
1470                 if (reason.length == 0) {
1471                     revert("ERC721: transfer to non ERC721Receiver implementer");
1472                 } else {
1473                     assembly {
1474                         revert(add(32, reason), mload(reason))
1475                     }
1476                 }
1477             }
1478         } else {
1479             return true;
1480         }
1481     }
1482 
1483     /**
1484      * @dev Hook that is called before any token transfer. This includes minting
1485      * and burning.
1486      *
1487      * Calling conditions:
1488      *
1489      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1490      * transferred to `to`.
1491      * - When `from` is zero, `tokenId` will be minted for `to`.
1492      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1493      * - `from` and `to` are never both zero.
1494      *
1495      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1496      */
1497     function _beforeTokenTransfer(
1498         address from,
1499         address to,
1500         uint256 tokenId
1501     ) internal virtual {}
1502 }
1503 
1504 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1505 
1506 
1507 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1508 
1509 pragma solidity ^0.8.0;
1510 
1511 
1512 
1513 /**
1514  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1515  * enumerability of all the token ids in the contract as well as all token ids owned by each
1516  * account.
1517  */
1518 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1519     // Mapping from owner to list of owned token IDs
1520     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1521 
1522     // Mapping from token ID to index of the owner tokens list
1523     mapping(uint256 => uint256) private _ownedTokensIndex;
1524 
1525     // Array with all token ids, used for enumeration
1526     uint256[] private _allTokens;
1527 
1528     // Mapping from token id to position in the allTokens array
1529     mapping(uint256 => uint256) private _allTokensIndex;
1530 
1531     /**
1532      * @dev See {IERC165-supportsInterface}.
1533      */
1534     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1535         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1536     }
1537 
1538     /**
1539      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1540      */
1541     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1542         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1543         return _ownedTokens[owner][index];
1544     }
1545 
1546     /**
1547      * @dev See {IERC721Enumerable-totalSupply}.
1548      */
1549     function totalSupply() public view virtual override returns (uint256) {
1550         return _allTokens.length;
1551     }
1552 
1553     /**
1554      * @dev See {IERC721Enumerable-tokenByIndex}.
1555      */
1556     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1557         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1558         return _allTokens[index];
1559     }
1560 
1561     /**
1562      * @dev Hook that is called before any token transfer. This includes minting
1563      * and burning.
1564      *
1565      * Calling conditions:
1566      *
1567      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1568      * transferred to `to`.
1569      * - When `from` is zero, `tokenId` will be minted for `to`.
1570      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1571      * - `from` cannot be the zero address.
1572      * - `to` cannot be the zero address.
1573      *
1574      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1575      */
1576     function _beforeTokenTransfer(
1577         address from,
1578         address to,
1579         uint256 tokenId
1580     ) internal virtual override {
1581         super._beforeTokenTransfer(from, to, tokenId);
1582 
1583         if (from == address(0)) {
1584             _addTokenToAllTokensEnumeration(tokenId);
1585         } else if (from != to) {
1586             _removeTokenFromOwnerEnumeration(from, tokenId);
1587         }
1588         if (to == address(0)) {
1589             _removeTokenFromAllTokensEnumeration(tokenId);
1590         } else if (to != from) {
1591             _addTokenToOwnerEnumeration(to, tokenId);
1592         }
1593     }
1594 
1595     /**
1596      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1597      * @param to address representing the new owner of the given token ID
1598      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1599      */
1600     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1601         uint256 length = ERC721.balanceOf(to);
1602         _ownedTokens[to][length] = tokenId;
1603         _ownedTokensIndex[tokenId] = length;
1604     }
1605 
1606     /**
1607      * @dev Private function to add a token to this extension's token tracking data structures.
1608      * @param tokenId uint256 ID of the token to be added to the tokens list
1609      */
1610     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1611         _allTokensIndex[tokenId] = _allTokens.length;
1612         _allTokens.push(tokenId);
1613     }
1614 
1615     /**
1616      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1617      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1618      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1619      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1620      * @param from address representing the previous owner of the given token ID
1621      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1622      */
1623     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1624         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1625         // then delete the last slot (swap and pop).
1626 
1627         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1628         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1629 
1630         // When the token to delete is the last token, the swap operation is unnecessary
1631         if (tokenIndex != lastTokenIndex) {
1632             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1633 
1634             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1635             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1636         }
1637 
1638         // This also deletes the contents at the last position of the array
1639         delete _ownedTokensIndex[tokenId];
1640         delete _ownedTokens[from][lastTokenIndex];
1641     }
1642 
1643     /**
1644      * @dev Private function to remove a token from this extension's token tracking data structures.
1645      * This has O(1) time complexity, but alters the order of the _allTokens array.
1646      * @param tokenId uint256 ID of the token to be removed from the tokens list
1647      */
1648     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1649         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1650         // then delete the last slot (swap and pop).
1651 
1652         uint256 lastTokenIndex = _allTokens.length - 1;
1653         uint256 tokenIndex = _allTokensIndex[tokenId];
1654 
1655         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1656         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1657         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1658         uint256 lastTokenId = _allTokens[lastTokenIndex];
1659 
1660         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1661         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1662 
1663         // This also deletes the contents at the last position of the array
1664         delete _allTokensIndex[tokenId];
1665         _allTokens.pop();
1666     }
1667 }
1668 
1669 // File: @openzeppelin/contracts/access/Ownable.sol
1670 
1671 
1672 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1673 
1674 pragma solidity ^0.8.0;
1675 
1676 
1677 /**
1678  * @dev Contract module which provides a basic access control mechanism, where
1679  * there is an account (an owner) that can be granted exclusive access to
1680  * specific functions.
1681  *
1682  * By default, the owner account will be the one that deploys the contract. This
1683  * can later be changed with {transferOwnership}.
1684  *
1685  * This module is used through inheritance. It will make available the modifier
1686  * `onlyOwner`, which can be applied to your functions to restrict their use to
1687  * the owner.
1688  */
1689 abstract contract Ownable is Context {
1690     address private _owner;
1691 
1692     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1693 
1694     /**
1695      * @dev Initializes the contract setting the deployer as the initial owner.
1696      */
1697     constructor() {
1698         _transferOwnership(_msgSender());
1699     }
1700 
1701     /**
1702      * @dev Returns the address of the current owner.
1703      */
1704     function owner() public view virtual returns (address) {
1705         return _owner;
1706     }
1707 
1708     /**
1709      * @dev Throws if called by any account other than the owner.
1710      */
1711     modifier onlyOwner() {
1712         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1713         _;
1714     }
1715 
1716     /**
1717      * @dev Leaves the contract without owner. It will not be possible to call
1718      * `onlyOwner` functions anymore. Can only be called by the current owner.
1719      *
1720      * NOTE: Renouncing ownership will leave the contract without an owner,
1721      * thereby removing any functionality that is only available to the owner.
1722      */
1723     function renounceOwnership() public virtual onlyOwner {
1724         _transferOwnership(address(0));
1725     }
1726 
1727     /**
1728      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1729      * Can only be called by the current owner.
1730      */
1731     function transferOwnership(address newOwner) public virtual onlyOwner {
1732         require(newOwner != address(0), "Ownable: new owner is the zero address");
1733         _transferOwnership(newOwner);
1734     }
1735 
1736     /**
1737      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1738      * Internal function without access restriction.
1739      */
1740     function _transferOwnership(address newOwner) internal virtual {
1741         address oldOwner = _owner;
1742         _owner = newOwner;
1743         emit OwnershipTransferred(oldOwner, newOwner);
1744     }
1745 }
1746 
1747 // File: NekoZamurai.sol
1748 
1749 
1750     //Contract based on [https://docs.openzeppelin.com/contracts/3.x/erc721](https://docs.openzeppelin.com/contracts/3.x/erc721)
1751     pragma solidity ^0.8.0;
1752 
1753     /*
1754     ╔═╗ ╔╗╔═══╗╔╗╔═╗╔═══╗    ╔════╗╔═══╗╔═╗╔═╗╔╗ ╔╗╔═══╗╔═══╗╔══╗
1755     ║║╚╗║║║╔══╝║║║╔╝║╔═╗║    ╚══╗ ║║╔═╗║║║╚╝║║║║ ║║║╔═╗║║╔═╗║╚╣╠╝
1756     ║╔╗╚╝║║╚══╗║╚╝╝ ║║ ║║      ╔╝╔╝║║ ║║║╔╗╔╗║║║ ║║║╚═╝║║║ ║║ ║║ 
1757     ║║╚╗║║║╔══╝║╔╗║ ║║ ║║     ╔╝╔╝ ║╚═╝║║║║║║║║║ ║║║╔╗╔╝║╚═╝║ ║║ 
1758     ║║ ║║║║╚══╗║║║╚╗║╚═╝║    ╔╝ ╚═╗║╔═╗║║║║║║║║╚═╝║║║║╚╗║╔═╗║╔╣╠╗
1759     ╚╝ ╚═╝╚═══╝╚╝╚═╝╚═══╝    ╚════╝╚╝ ╚╝╚╝╚╝╚╝╚═══╝╚╝╚═╝╚╝ ╚╝╚══╝
1760 
1761     Contract made with ❤️ by NekoZamurai
1762 
1763     Socials:
1764     Opensea: TBA
1765     Twitter: https://twitter.com/NekoZamuraiNFT
1766     Website: https://nekozamurai.io/
1767     */
1768 
1769 
1770 
1771 
1772 
1773 
1774     contract NekoZamurai is ERC721Enumerable, Ownable {
1775         using Strings for uint256;
1776         using SafeMath for uint256;
1777         using ECDSA for bytes32;
1778 
1779         // Constant variables
1780         // ------------------------------------------------------------------------
1781         uint public constant publicSupply = 5217;
1782         uint public constant presaleSupply = 2560;
1783         uint public constant maxSupply = presaleSupply + publicSupply;
1784         uint public constant cost = 0.14 ether;
1785         uint public constant maxMintPerTx = 5;
1786         
1787         // Mapping variables
1788         // ------------------------------------------------------------------------
1789         mapping(address => bool) public presalerList;
1790         mapping(address => uint256) public presalerListPurchases;
1791         mapping(address => uint256) public publicListPurchases;
1792         
1793         // Public variables
1794         // ------------------------------------------------------------------------
1795         uint256 public publicAmountMinted;
1796         uint256 public presalePurchaseLimit = 1;
1797         uint256 public publicPurchaseLimit = 5;
1798         uint256 public reservedAmountMinted;
1799 
1800         // URI variables
1801         // ------------------------------------------------------------------------
1802         string private contractURI;
1803         string private baseTokenURI = "";
1804 
1805         // Deployer address
1806         // ------------------------------------------------------------------------
1807         address public constant creatorAddress = 0x8707db291A13d9585b9Bc8e2289F64EbB6f5B672;
1808         address private signerAddress = 0x8707db291A13d9585b9Bc8e2289F64EbB6f5B672; // tbd
1809 
1810         bool public saleLive;
1811         bool public presaleLive;
1812         bool public revealed = false;
1813         bool public metadataLock;
1814 
1815         // Constructor
1816         // ------------------------------------------------------------------------
1817         constructor(string memory unrevealedBaseURI) ERC721("NekoZamurai", "NEKO") {
1818             setBaseURI(unrevealedBaseURI);
1819             // setBaseURI("ipfs://QmXTsae772LDETthjkCNR4pPrEWShJ9UbuP7gCKWi26XV6/"); // testing purposes
1820         }
1821         
1822         modifier notLocked {
1823             require(!metadataLock, "Contract metadata methods are locked");
1824             _;
1825         }
1826 
1827         // Mint function
1828         // ------------------------------------------------------------------------
1829         function mintPublic(uint256 mintQuantity) external payable {
1830             require(saleLive, "Sale closed");
1831             require(!presaleLive, "Only available for presale");
1832             require(totalSupply() < maxSupply, "Out of stock");
1833             require(publicAmountMinted + mintQuantity <= publicSupply, "Out of public stock");
1834             require(publicListPurchases[msg.sender] + mintQuantity <= publicPurchaseLimit, "Public mint limit exceeded");
1835             require(mintQuantity <= maxMintPerTx, "Exceeded mint limit");
1836             require(cost * mintQuantity <= msg.value, "Insufficient funds"); 
1837             
1838             for(uint256 i = 1; i <= mintQuantity; i++) {
1839                 publicAmountMinted++;
1840                 publicListPurchases[msg.sender]++;
1841                 _safeMint(msg.sender, totalSupply() + 1);
1842             }
1843         }
1844 
1845         // Presale mint function
1846         // ------------------------------------------------------------------------
1847         function mintPresale(uint256 mintQuantity) external payable {
1848             uint256 callSupply = totalSupply();
1849 
1850             require(!saleLive && presaleLive, "Presale closed");
1851             require(presalerList[msg.sender], "Not on presale list");   
1852             require(callSupply < maxSupply, "Out of stock");
1853             require(publicAmountMinted + mintQuantity <= publicSupply, "Out of public stock");
1854             require(presalerListPurchases[msg.sender] + mintQuantity <= presalePurchaseLimit, "Presale mint limit exceeded");
1855             require(cost * mintQuantity <= msg.value, "Insufficient funds");
1856             
1857             presalerListPurchases[msg.sender] += mintQuantity;
1858             publicAmountMinted += mintQuantity;
1859 
1860             for (uint256 i = 0; i < mintQuantity; i++) {
1861                 _safeMint(msg.sender, callSupply + 1);
1862             }
1863         }
1864         
1865 
1866         // Reserved mint function
1867         // ------------------------------------------------------------------------
1868         function mintReserved(uint256 mintQuantity) external onlyOwner {
1869             require(saleLive, "Sale closed");
1870             require(totalSupply() < maxSupply, "Out of stock");
1871             require(reservedAmountMinted + mintQuantity <= presaleSupply, "Out of reserved stock");
1872             
1873             for(uint256 i = 1; i <= mintQuantity; i++) {
1874                 reservedAmountMinted++;
1875                 _safeMint(msg.sender, totalSupply() + 1);
1876             }
1877             
1878         }
1879         
1880         // Get cost amount
1881         // ------------------------------------------------------------------------
1882         function getCost(uint256 _count) public pure returns (uint256) {
1883             return cost.mul(_count);
1884         }
1885         
1886         // Get hash transaction
1887         // ------------------------------------------------------------------------
1888         function hashTransaction(address sender, uint256 qty, string memory nonce) public pure returns(bytes32) {
1889             bytes32 hash = keccak256(abi.encodePacked(
1890             "\x19Ethereum Signed Message:\n32",
1891             keccak256(abi.encodePacked(sender, qty, nonce)))
1892             );
1893             
1894             return hash;
1895         }
1896         
1897         // Get match from address signer
1898         // ------------------------------------------------------------------------
1899         function matchAddressSigner(bytes32 hash, bytes memory signature) private view returns(bool) {
1900             return signerAddress == hash.recover(signature);
1901         }
1902 
1903         //  Get total supply leftover amount
1904         // ------------------------------------------------------------------------
1905         function getUnsoldRemaining() external view returns (uint256) {
1906             return maxSupply - totalSupply();
1907         }
1908         
1909         // Get contract URI
1910         // ------------------------------------------------------------------------
1911         function getContractURI() public view returns (string memory) {
1912             return contractURI;
1913         }
1914         
1915         // Get base token URI
1916         // ------------------------------------------------------------------------
1917         function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1918             require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1919 
1920             if (!revealed) {
1921                 return baseTokenURI;
1922             }
1923             
1924             return bytes(baseTokenURI).length > 0 ? string(abi.encodePacked(baseTokenURI, tokenId.toString(), ".json")): "";
1925         }
1926         
1927         // Owner functions
1928         // Toggle reveal function (True by default)
1929         // ------------------------------------------------------------------------
1930         function reveal() public onlyOwner {
1931             revealed = true;
1932         }
1933         
1934         // Togle lock metadata function (True by default)
1935         // ------------------------------------------------------------------------
1936         function lockMetadata() external onlyOwner {
1937             metadataLock = true;
1938         }
1939         
1940         // Toggle presale (False by default)
1941         // ------------------------------------------------------------------------
1942         function togglePresale() external onlyOwner {
1943             presaleLive = !presaleLive;
1944         }
1945         
1946         // Toggle sale (False by default)
1947         // ------------------------------------------------------------------------
1948         function toggleSale() external onlyOwner {
1949             saleLive = !saleLive;
1950         }
1951         
1952         // Add address to presael list
1953         // ------------------------------------------------------------------------
1954         function addToPresaleList(address[] calldata entries) external onlyOwner {
1955             for(uint256 i = 0; i < entries.length; i++) {
1956                 address entry = entries[i];
1957                 require(entry != address(0), "Null address");
1958                 require(!presalerList[entry], "Duplicate entry");
1959 
1960                 presalerList[entry] = true;
1961             }   
1962         }
1963 
1964         // Remove address from presale list
1965         // ------------------------------------------------------------------------
1966         function removeFromPresaleList(address[] calldata entries) external onlyOwner {
1967             for(uint256 i = 0; i < entries.length; i++) {
1968                 address entry = entries[i];
1969                 require(entry != address(0), "Null address");
1970                 
1971                 presalerList[entry] = false;
1972             }
1973         }
1974 
1975         // Approve signer address
1976         // ------------------------------------------------------------------------
1977         function setSignerAddress(address addr) external onlyOwner {
1978             signerAddress = addr;
1979         }
1980         
1981         // Set contract URI
1982         // ------------------------------------------------------------------------
1983         function setContractURI(string calldata URI) external onlyOwner notLocked {
1984             contractURI = URI;
1985         }
1986         
1987         // Set base URI
1988         // ------------------------------------------------------------------------
1989         function setBaseURI(string memory baseURI) public onlyOwner notLocked {
1990             baseTokenURI = baseURI;
1991         }
1992         
1993         // Withdrawal function
1994         // ------------------------------------------------------------------------
1995         function withdraw() external onlyOwner {
1996             uint256 balance = address(this).balance;
1997             require(balance > 0);
1998             (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
1999             require(success);
2000         }
2001         
2002     }