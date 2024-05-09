1 // SPDX-License-Identifier: GPL-3.0
2 
3 
4 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
5 pragma solidity ^0.8.0;
6 /**
7  * @dev Interface of the ERC165 standard, as defined in the
8  * https://eips.ethereum.org/EIPS/eip-165[EIP].
9  *
10  * Implementers can declare support of contract interfaces, which can then be
11  * queried by others ({ERC165Checker}).
12  *
13  * For an implementation, see {ERC165}.
14  */
15 interface IERC165 {
16     /**
17      * @dev Returns true if this contract implements the interface defined by
18      * `interfaceId`. See the corresponding
19      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
20      * to learn more about how these ids are created.
21      *
22      * This function call must use less than 30 000 gas.
23      */
24     function supportsInterface(bytes4 interfaceId) external view returns (bool);
25 }
26 
27 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
28 pragma solidity ^0.8.0;
29 /**
30  * @dev Required interface of an ERC721 compliant contract.
31  */
32 interface IERC721 is IERC165 {
33     /**
34      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
35      */
36     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
37 
38     /**
39      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
40      */
41     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
42 
43     /**
44      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
45      */
46     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
47 
48     /**
49      * @dev Returns the number of tokens in ``owner``'s account.
50      */
51     function balanceOf(address owner) external view returns (uint256 balance);
52 
53     /**
54      * @dev Returns the owner of the `tokenId` token.
55      *
56      * Requirements:
57      *
58      * - `tokenId` must exist.
59      */
60     function ownerOf(uint256 tokenId) external view returns (address owner);
61 
62     /**
63      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
64      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
65      *
66      * Requirements:
67      *
68      * - `from` cannot be the zero address.
69      * - `to` cannot be the zero address.
70      * - `tokenId` token must exist and be owned by `from`.
71      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
72      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
73      *
74      * Emits a {Transfer} event.
75      */
76     function safeTransferFrom(
77         address from,
78         address to,
79         uint256 tokenId
80     ) external;
81 
82     /**
83      * @dev Transfers `tokenId` token from `from` to `to`.
84      *
85      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
86      *
87      * Requirements:
88      *
89      * - `from` cannot be the zero address.
90      * - `to` cannot be the zero address.
91      * - `tokenId` token must be owned by `from`.
92      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
93      *
94      * Emits a {Transfer} event.
95      */
96     function transferFrom(
97         address from,
98         address to,
99         uint256 tokenId
100     ) external;
101 
102     /**
103      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
104      * The approval is cleared when the token is transferred.
105      *
106      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
107      *
108      * Requirements:
109      *
110      * - The caller must own the token or be an approved operator.
111      * - `tokenId` must exist.
112      *
113      * Emits an {Approval} event.
114      */
115     function approve(address to, uint256 tokenId) external;
116 
117     /**
118      * @dev Returns the account approved for `tokenId` token.
119      *
120      * Requirements:
121      *
122      * - `tokenId` must exist.
123      */
124     function getApproved(uint256 tokenId) external view returns (address operator);
125 
126     /**
127      * @dev Approve or remove `operator` as an operator for the caller.
128      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
129      *
130      * Requirements:
131      *
132      * - The `operator` cannot be the caller.
133      *
134      * Emits an {ApprovalForAll} event.
135      */
136     function setApprovalForAll(address operator, bool _approved) external;
137 
138     /**
139      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
140      *
141      * See {setApprovalForAll}
142      */
143     function isApprovedForAll(address owner, address operator) external view returns (bool);
144 
145     /**
146      * @dev Safely transfers `tokenId` token from `from` to `to`.
147      *
148      * Requirements:
149      *
150      * - `from` cannot be the zero address.
151      * - `to` cannot be the zero address.
152      * - `tokenId` token must exist and be owned by `from`.
153      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
154      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
155      *
156      * Emits a {Transfer} event.
157      */
158     function safeTransferFrom(
159         address from,
160         address to,
161         uint256 tokenId,
162         bytes calldata data
163     ) external;
164 }
165 
166 
167 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
168 pragma solidity ^0.8.0;
169 /**
170  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
171  * @dev See https://eips.ethereum.org/EIPS/eip-721
172  */
173 interface IERC721Enumerable is IERC721 {
174     /**
175      * @dev Returns the total amount of tokens stored by the contract.
176      */
177     function totalSupply() external view returns (uint256);
178 
179     /**
180      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
181      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
182      */
183     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
184 
185     /**
186      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
187      * Use along with {totalSupply} to enumerate all tokens.
188      */
189     function tokenByIndex(uint256 index) external view returns (uint256);
190 }
191 
192 
193 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
194 pragma solidity ^0.8.0;
195 /**
196  * @dev Implementation of the {IERC165} interface.
197  *
198  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
199  * for the additional interface id that will be supported. For example:
200  *
201  * ```solidity
202  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
203  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
204  * }
205  * ```
206  *
207  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
208  */
209 abstract contract ERC165 is IERC165 {
210     /**
211      * @dev See {IERC165-supportsInterface}.
212      */
213     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
214         return interfaceId == type(IERC165).interfaceId;
215     }
216 }
217 
218 // File: @openzeppelin/contracts/utils/Strings.sol
219 
220 
221 
222 pragma solidity ^0.8.0;
223 
224 /**
225  * @dev String operations.
226  */
227 library Strings {
228     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
229 
230     /**
231      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
232      */
233     function toString(uint256 value) internal pure returns (string memory) {
234         // Inspired by OraclizeAPI's implementation - MIT licence
235         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
236 
237         if (value == 0) {
238             return "0";
239         }
240         uint256 temp = value;
241         uint256 digits;
242         while (temp != 0) {
243             digits++;
244             temp /= 10;
245         }
246         bytes memory buffer = new bytes(digits);
247         while (value != 0) {
248             digits -= 1;
249             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
250             value /= 10;
251         }
252         return string(buffer);
253     }
254 
255     /**
256      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
257      */
258     function toHexString(uint256 value) internal pure returns (string memory) {
259         if (value == 0) {
260             return "0x00";
261         }
262         uint256 temp = value;
263         uint256 length = 0;
264         while (temp != 0) {
265             length++;
266             temp >>= 8;
267         }
268         return toHexString(value, length);
269     }
270 
271     /**
272      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
273      */
274     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
275         bytes memory buffer = new bytes(2 * length + 2);
276         buffer[0] = "0";
277         buffer[1] = "x";
278         for (uint256 i = 2 * length + 1; i > 1; --i) {
279             buffer[i] = _HEX_SYMBOLS[value & 0xf];
280             value >>= 4;
281         }
282         require(value == 0, "Strings: hex length insufficient");
283         return string(buffer);
284     }
285 }
286 
287 // File @openzeppelin/contracts/utils/cryptography/ECDSA.sol@v4.4.2
288 
289 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/ECDSA.sol)
290 
291 pragma solidity ^0.8.0;
292 
293 /**
294  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
295  *
296  * These functions can be used to verify that a message was signed by the holder
297  * of the private keys of a given address.
298  */
299 library ECDSA {
300     enum RecoverError {
301         NoError,
302         InvalidSignature,
303         InvalidSignatureLength,
304         InvalidSignatureS,
305         InvalidSignatureV
306     }
307 
308     function _throwError(RecoverError error) private pure {
309         if (error == RecoverError.NoError) {
310             return; // no error: do nothing
311         } else if (error == RecoverError.InvalidSignature) {
312             revert("ECDSA: invalid signature");
313         } else if (error == RecoverError.InvalidSignatureLength) {
314             revert("ECDSA: invalid signature length");
315         } else if (error == RecoverError.InvalidSignatureS) {
316             revert("ECDSA: invalid signature 's' value");
317         } else if (error == RecoverError.InvalidSignatureV) {
318             revert("ECDSA: invalid signature 'v' value");
319         }
320     }
321 
322     /**
323      * @dev Returns the address that signed a hashed message (`hash`) with
324      * `signature` or error string. This address can then be used for verification purposes.
325      *
326      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
327      * this function rejects them by requiring the `s` value to be in the lower
328      * half order, and the `v` value to be either 27 or 28.
329      *
330      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
331      * verification to be secure: it is possible to craft signatures that
332      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
333      * this is by receiving a hash of the original message (which may otherwise
334      * be too long), and then calling {toEthSignedMessageHash} on it.
335      *
336      * Documentation for signature generation:
337      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
338      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
339      *
340      * _Available since v4.3._
341      */
342     function tryRecover(bytes32 hash, bytes memory signature)
343         internal
344         pure
345         returns (address, RecoverError)
346     {
347         // Check the signature length
348         // - case 65: r,s,v signature (standard)
349         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
350         if (signature.length == 65) {
351             bytes32 r;
352             bytes32 s;
353             uint8 v;
354             // ecrecover takes the signature parameters, and the only way to get them
355             // currently is to use assembly.
356             assembly {
357                 r := mload(add(signature, 0x20))
358                 s := mload(add(signature, 0x40))
359                 v := byte(0, mload(add(signature, 0x60)))
360             }
361             return tryRecover(hash, v, r, s);
362         } else if (signature.length == 64) {
363             bytes32 r;
364             bytes32 vs;
365             // ecrecover takes the signature parameters, and the only way to get them
366             // currently is to use assembly.
367             assembly {
368                 r := mload(add(signature, 0x20))
369                 vs := mload(add(signature, 0x40))
370             }
371             return tryRecover(hash, r, vs);
372         } else {
373             return (address(0), RecoverError.InvalidSignatureLength);
374         }
375     }
376 
377     /**
378      * @dev Returns the address that signed a hashed message (`hash`) with
379      * `signature`. This address can then be used for verification purposes.
380      *
381      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
382      * this function rejects them by requiring the `s` value to be in the lower
383      * half order, and the `v` value to be either 27 or 28.
384      *
385      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
386      * verification to be secure: it is possible to craft signatures that
387      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
388      * this is by receiving a hash of the original message (which may otherwise
389      * be too long), and then calling {toEthSignedMessageHash} on it.
390      */
391     function recover(bytes32 hash, bytes memory signature)
392         internal
393         pure
394         returns (address)
395     {
396         (address recovered, RecoverError error) = tryRecover(hash, signature);
397         _throwError(error);
398         return recovered;
399     }
400 
401     /**
402      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
403      *
404      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
405      *
406      * _Available since v4.3._
407      */
408     function tryRecover(
409         bytes32 hash,
410         bytes32 r,
411         bytes32 vs
412     ) internal pure returns (address, RecoverError) {
413         bytes32 s;
414         uint8 v;
415         assembly {
416             s := and(
417                 vs,
418                 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
419             )
420             v := add(shr(255, vs), 27)
421         }
422         return tryRecover(hash, v, r, s);
423     }
424 
425     /**
426      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
427      *
428      * _Available since v4.2._
429      */
430     function recover(
431         bytes32 hash,
432         bytes32 r,
433         bytes32 vs
434     ) internal pure returns (address) {
435         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
436         _throwError(error);
437         return recovered;
438     }
439 
440     /**
441      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
442      * `r` and `s` signature fields separately.
443      *
444      * _Available since v4.3._
445      */
446     function tryRecover(
447         bytes32 hash,
448         uint8 v,
449         bytes32 r,
450         bytes32 s
451     ) internal pure returns (address, RecoverError) {
452         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
453         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
454         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
455         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
456         //
457         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
458         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
459         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
460         // these malleable signatures as well.
461         if (
462             uint256(s) >
463             0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0
464         ) {
465             return (address(0), RecoverError.InvalidSignatureS);
466         }
467         if (v != 27 && v != 28) {
468             return (address(0), RecoverError.InvalidSignatureV);
469         }
470 
471         // If the signature is valid (and not malleable), return the signer address
472         address signer = ecrecover(hash, v, r, s);
473         if (signer == address(0)) {
474             return (address(0), RecoverError.InvalidSignature);
475         }
476 
477         return (signer, RecoverError.NoError);
478     }
479 
480     /**
481      * @dev Overload of {ECDSA-recover} that receives the `v`,
482      * `r` and `s` signature fields separately.
483      */
484     function recover(
485         bytes32 hash,
486         uint8 v,
487         bytes32 r,
488         bytes32 s
489     ) internal pure returns (address) {
490         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
491         _throwError(error);
492         return recovered;
493     }
494 
495     /**
496      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
497      * produces hash corresponding to the one signed with the
498      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
499      * JSON-RPC method as part of EIP-191.
500      *
501      * See {recover}.
502      */
503     function toEthSignedMessageHash(bytes32 hash)
504         internal
505         pure
506         returns (bytes32)
507     {
508         // 32 is the length in bytes of hash,
509         // enforced by the type signature above
510         return
511             keccak256(
512                 abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)
513             );
514     }
515 
516     /**
517      * @dev Returns an Ethereum Signed Message, created from `s`. This
518      * produces hash corresponding to the one signed with the
519      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
520      * JSON-RPC method as part of EIP-191.
521      *
522      * See {recover}.
523      */
524     function toEthSignedMessageHash(bytes memory s)
525         internal
526         pure
527         returns (bytes32)
528     {
529         return
530             keccak256(
531                 abi.encodePacked(
532                     "\x19Ethereum Signed Message:\n",
533                     Strings.toString(s.length),
534                     s
535                 )
536             );
537     }
538 
539     /**
540      * @dev Returns an Ethereum Signed Typed Data, created from a
541      * `domainSeparator` and a `structHash`. This produces hash corresponding
542      * to the one signed with the
543      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
544      * JSON-RPC method as part of EIP-712.
545      *
546      * See {recover}.
547      */
548     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash)
549         internal
550         pure
551         returns (bytes32)
552     {
553         return
554             keccak256(
555                 abi.encodePacked("\x19\x01", domainSeparator, structHash)
556             );
557     }
558 }
559 
560 // File: @openzeppelin/contracts/utils/Address.sol
561 
562 
563 
564 pragma solidity ^0.8.0;
565 
566 /**
567  * @dev Collection of functions related to the address type
568  */
569 library Address {
570     /**
571      * @dev Returns true if `account` is a contract.
572      *
573      * [IMPORTANT]
574      * ====
575      * It is unsafe to assume that an address for which this function returns
576      * false is an externally-owned account (EOA) and not a contract.
577      *
578      * Among others, `isContract` will return false for the following
579      * types of addresses:
580      *
581      *  - an externally-owned account
582      *  - a contract in construction
583      *  - an address where a contract will be created
584      *  - an address where a contract lived, but was destroyed
585      * ====
586      */
587     function isContract(address account) internal view returns (bool) {
588         // This method relies on extcodesize, which returns 0 for contracts in
589         // construction, since the code is only stored at the end of the
590         // constructor execution.
591 
592         uint256 size;
593         assembly {
594             size := extcodesize(account)
595         }
596         return size > 0;
597     }
598 
599     /**
600      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
601      * `recipient`, forwarding all available gas and reverting on errors.
602      *
603      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
604      * of certain opcodes, possibly making contracts go over the 2300 gas limit
605      * imposed by `transfer`, making them unable to receive funds via
606      * `transfer`. {sendValue} removes this limitation.
607      *
608      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
609      *
610      * IMPORTANT: because control is transferred to `recipient`, care must be
611      * taken to not create reentrancy vulnerabilities. Consider using
612      * {ReentrancyGuard} or the
613      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
614      */
615     function sendValue(address payable recipient, uint256 amount) internal {
616         require(address(this).balance >= amount, "Address: insufficient balance");
617 
618         (bool success, ) = recipient.call{value: amount}("");
619         require(success, "Address: unable to send value, recipient may have reverted");
620     }
621 
622     /**
623      * @dev Performs a Solidity function call using a low level `call`. A
624      * plain `call` is an unsafe replacement for a function call: use this
625      * function instead.
626      *
627      * If `target` reverts with a revert reason, it is bubbled up by this
628      * function (like regular Solidity function calls).
629      *
630      * Returns the raw returned data. To convert to the expected return value,
631      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
632      *
633      * Requirements:
634      *
635      * - `target` must be a contract.
636      * - calling `target` with `data` must not revert.
637      *
638      * _Available since v3.1._
639      */
640     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
641         return functionCall(target, data, "Address: low-level call failed");
642     }
643 
644     /**
645      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
646      * `errorMessage` as a fallback revert reason when `target` reverts.
647      *
648      * _Available since v3.1._
649      */
650     function functionCall(
651         address target,
652         bytes memory data,
653         string memory errorMessage
654     ) internal returns (bytes memory) {
655         return functionCallWithValue(target, data, 0, errorMessage);
656     }
657 
658     /**
659      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
660      * but also transferring `value` wei to `target`.
661      *
662      * Requirements:
663      *
664      * - the calling contract must have an ETH balance of at least `value`.
665      * - the called Solidity function must be `payable`.
666      *
667      * _Available since v3.1._
668      */
669     function functionCallWithValue(
670         address target,
671         bytes memory data,
672         uint256 value
673     ) internal returns (bytes memory) {
674         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
675     }
676 
677     /**
678      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
679      * with `errorMessage` as a fallback revert reason when `target` reverts.
680      *
681      * _Available since v3.1._
682      */
683     function functionCallWithValue(
684         address target,
685         bytes memory data,
686         uint256 value,
687         string memory errorMessage
688     ) internal returns (bytes memory) {
689         require(address(this).balance >= value, "Address: insufficient balance for call");
690         require(isContract(target), "Address: call to non-contract");
691 
692         (bool success, bytes memory returndata) = target.call{value: value}(data);
693         return verifyCallResult(success, returndata, errorMessage);
694     }
695 
696     /**
697      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
698      * but performing a static call.
699      *
700      * _Available since v3.3._
701      */
702     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
703         return functionStaticCall(target, data, "Address: low-level static call failed");
704     }
705 
706     /**
707      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
708      * but performing a static call.
709      *
710      * _Available since v3.3._
711      */
712     function functionStaticCall(
713         address target,
714         bytes memory data,
715         string memory errorMessage
716     ) internal view returns (bytes memory) {
717         require(isContract(target), "Address: static call to non-contract");
718 
719         (bool success, bytes memory returndata) = target.staticcall(data);
720         return verifyCallResult(success, returndata, errorMessage);
721     }
722 
723     /**
724      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
725      * but performing a delegate call.
726      *
727      * _Available since v3.4._
728      */
729     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
730         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
731     }
732 
733     /**
734      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
735      * but performing a delegate call.
736      *
737      * _Available since v3.4._
738      */
739     function functionDelegateCall(
740         address target,
741         bytes memory data,
742         string memory errorMessage
743     ) internal returns (bytes memory) {
744         require(isContract(target), "Address: delegate call to non-contract");
745 
746         (bool success, bytes memory returndata) = target.delegatecall(data);
747         return verifyCallResult(success, returndata, errorMessage);
748     }
749 
750     /**
751      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
752      * revert reason using the provided one.
753      *
754      * _Available since v4.3._
755      */
756     function verifyCallResult(
757         bool success,
758         bytes memory returndata,
759         string memory errorMessage
760     ) internal pure returns (bytes memory) {
761         if (success) {
762             return returndata;
763         } else {
764             // Look for revert reason and bubble it up if present
765             if (returndata.length > 0) {
766                 // The easiest way to bubble the revert reason is using memory via assembly
767 
768                 assembly {
769                     let returndata_size := mload(returndata)
770                     revert(add(32, returndata), returndata_size)
771                 }
772             } else {
773                 revert(errorMessage);
774             }
775         }
776     }
777 }
778 
779 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
780 
781 
782 
783 pragma solidity ^0.8.0;
784 
785 
786 /**
787  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
788  * @dev See https://eips.ethereum.org/EIPS/eip-721
789  */
790 interface IERC721Metadata is IERC721 {
791     /**
792      * @dev Returns the token collection name.
793      */
794     function name() external view returns (string memory);
795 
796     /**
797      * @dev Returns the token collection symbol.
798      */
799     function symbol() external view returns (string memory);
800 
801     /**
802      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
803      */
804     function tokenURI(uint256 tokenId) external view returns (string memory);
805 }
806 
807 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
808 
809 
810 
811 pragma solidity ^0.8.0;
812 
813 /**
814  * @title ERC721 token receiver interface
815  * @dev Interface for any contract that wants to support safeTransfers
816  * from ERC721 asset contracts.
817  */
818 interface IERC721Receiver {
819     /**
820      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
821      * by `operator` from `from`, this function is called.
822      *
823      * It must return its Solidity selector to confirm the token transfer.
824      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
825      *
826      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
827      */
828     function onERC721Received(
829         address operator,
830         address from,
831         uint256 tokenId,
832         bytes calldata data
833     ) external returns (bytes4);
834 }
835 
836 // File: @openzeppelin/contracts/utils/Context.sol
837 pragma solidity ^0.8.0;
838 /**
839  * @dev Provides information about the current execution context, including the
840  * sender of the transaction and its data. While these are generally available
841  * via msg.sender and msg.data, they should not be accessed in such a direct
842  * manner, since when dealing with meta-transactions the account sending and
843  * paying for execution may not be the actual sender (as far as an application
844  * is concerned).
845  *
846  * This contract is only required for intermediate, library-like contracts.
847  */
848 abstract contract Context {
849     function _msgSender() internal view virtual returns (address) {
850         return msg.sender;
851     }
852 
853     function _msgData() internal view virtual returns (bytes calldata) {
854         return msg.data;
855     }
856 }
857 
858 
859 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
860 pragma solidity ^0.8.0;
861 /**
862  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
863  * the Metadata extension, but not including the Enumerable extension, which is available separately as
864  * {ERC721Enumerable}.
865  */
866 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
867     using Address for address;
868     using Strings for uint256;
869 
870     // Token name
871     string private _name;
872 
873     // Token symbol
874     string private _symbol;
875 
876     // Mapping from token ID to owner address
877     mapping(uint256 => address) private _owners;
878 
879     // Mapping owner address to token count
880     mapping(address => uint256) private _balances;
881 
882     // Mapping from token ID to approved address
883     mapping(uint256 => address) private _tokenApprovals;
884 
885     // Mapping from owner to operator approvals
886     mapping(address => mapping(address => bool)) private _operatorApprovals;
887 
888     /**
889      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
890      */
891     constructor(string memory name_, string memory symbol_) {
892         _name = name_;
893         _symbol = symbol_;
894     }
895 
896     /**
897      * @dev See {IERC165-supportsInterface}.
898      */
899     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
900         return
901             interfaceId == type(IERC721).interfaceId ||
902             interfaceId == type(IERC721Metadata).interfaceId ||
903             super.supportsInterface(interfaceId);
904     }
905 
906     /**
907      * @dev See {IERC721-balanceOf}.
908      */
909     function balanceOf(address owner) public view virtual override returns (uint256) {
910         require(owner != address(0), "ERC721: balance query for the zero address");
911         return _balances[owner];
912     }
913 
914     /**
915      * @dev See {IERC721-ownerOf}.
916      */
917     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
918         address owner = _owners[tokenId];
919         require(owner != address(0), "ERC721: owner query for nonexistent token");
920         return owner;
921     }
922 
923     /**
924      * @dev See {IERC721Metadata-name}.
925      */
926     function name() public view virtual override returns (string memory) {
927         return _name;
928     }
929 
930     /**
931      * @dev See {IERC721Metadata-symbol}.
932      */
933     function symbol() public view virtual override returns (string memory) {
934         return _symbol;
935     }
936 
937     /**
938      * @dev See {IERC721Metadata-tokenURI}.
939      */
940     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
941         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
942 
943         string memory baseURI = _baseURI();
944         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
945     }
946 
947     /**
948      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
949      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
950      * by default, can be overriden in child contracts.
951      */
952     function _baseURI() internal view virtual returns (string memory) {
953         return "";
954     }
955 
956     /**
957      * @dev See {IERC721-approve}.
958      */
959     function approve(address to, uint256 tokenId) public virtual override {
960         address owner = ERC721.ownerOf(tokenId);
961         require(to != owner, "ERC721: approval to current owner");
962 
963         require(
964             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
965             "ERC721: approve caller is not owner nor approved for all"
966         );
967 
968         _approve(to, tokenId);
969     }
970 
971     /**
972      * @dev See {IERC721-getApproved}.
973      */
974     function getApproved(uint256 tokenId) public view virtual override returns (address) {
975         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
976 
977         return _tokenApprovals[tokenId];
978     }
979 
980     /**
981      * @dev See {IERC721-setApprovalForAll}.
982      */
983     function setApprovalForAll(address operator, bool approved) public virtual override {
984         require(operator != _msgSender(), "ERC721: approve to caller");
985 
986         _operatorApprovals[_msgSender()][operator] = approved;
987         emit ApprovalForAll(_msgSender(), operator, approved);
988     }
989 
990     /**
991      * @dev See {IERC721-isApprovedForAll}.
992      */
993     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
994         return _operatorApprovals[owner][operator];
995     }
996 
997     /**
998      * @dev See {IERC721-transferFrom}.
999      */
1000     function transferFrom(
1001         address from,
1002         address to,
1003         uint256 tokenId
1004     ) public virtual override {
1005         //solhint-disable-next-line max-line-length
1006         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1007 
1008         _transfer(from, to, tokenId);
1009     }
1010 
1011     /**
1012      * @dev See {IERC721-safeTransferFrom}.
1013      */
1014     function safeTransferFrom(
1015         address from,
1016         address to,
1017         uint256 tokenId
1018     ) public virtual override {
1019         safeTransferFrom(from, to, tokenId, "");
1020     }
1021 
1022     /**
1023      * @dev See {IERC721-safeTransferFrom}.
1024      */
1025     function safeTransferFrom(
1026         address from,
1027         address to,
1028         uint256 tokenId,
1029         bytes memory _data
1030     ) public virtual override {
1031         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1032         _safeTransfer(from, to, tokenId, _data);
1033     }
1034 
1035     /**
1036      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1037      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1038      *
1039      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1040      *
1041      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1042      * implement alternative mechanisms to perform token transfer, such as signature-based.
1043      *
1044      * Requirements:
1045      *
1046      * - `from` cannot be the zero address.
1047      * - `to` cannot be the zero address.
1048      * - `tokenId` token must exist and be owned by `from`.
1049      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1050      *
1051      * Emits a {Transfer} event.
1052      */
1053     function _safeTransfer(
1054         address from,
1055         address to,
1056         uint256 tokenId,
1057         bytes memory _data
1058     ) internal virtual {
1059         _transfer(from, to, tokenId);
1060         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1061     }
1062 
1063     /**
1064      * @dev Returns whether `tokenId` exists.
1065      *
1066      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1067      *
1068      * Tokens start existing when they are minted (`_mint`),
1069      * and stop existing when they are burned (`_burn`).
1070      */
1071     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1072         return _owners[tokenId] != address(0);
1073     }
1074 
1075     /**
1076      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1077      *
1078      * Requirements:
1079      *
1080      * - `tokenId` must exist.
1081      */
1082     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1083         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1084         address owner = ERC721.ownerOf(tokenId);
1085         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1086     }
1087 
1088     /**
1089      * @dev Safely mints `tokenId` and transfers it to `to`.
1090      *
1091      * Requirements:
1092      *
1093      * - `tokenId` must not exist.
1094      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1095      *
1096      * Emits a {Transfer} event.
1097      */
1098     function _safeMint(address to, uint256 tokenId) internal virtual {
1099         _safeMint(to, tokenId, "");
1100     }
1101 
1102     /**
1103      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1104      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1105      */
1106     function _safeMint(
1107         address to,
1108         uint256 tokenId,
1109         bytes memory _data
1110     ) internal virtual {
1111         _mint(to, tokenId);
1112         require(
1113             _checkOnERC721Received(address(0), to, tokenId, _data),
1114             "ERC721: transfer to non ERC721Receiver implementer"
1115         );
1116     }
1117 
1118     /**
1119      * @dev Mints `tokenId` and transfers it to `to`.
1120      *
1121      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1122      *
1123      * Requirements:
1124      *
1125      * - `tokenId` must not exist.
1126      * - `to` cannot be the zero address.
1127      *
1128      * Emits a {Transfer} event.
1129      */
1130     function _mint(address to, uint256 tokenId) internal virtual {
1131         require(to != address(0), "ERC721: mint to the zero address");
1132         require(!_exists(tokenId), "ERC721: token already minted");
1133 
1134         _beforeTokenTransfer(address(0), to, tokenId);
1135 
1136         _balances[to] += 1;
1137         _owners[tokenId] = to;
1138 
1139         emit Transfer(address(0), to, tokenId);
1140     }
1141 
1142     /**
1143      * @dev Destroys `tokenId`.
1144      * The approval is cleared when the token is burned.
1145      *
1146      * Requirements:
1147      *
1148      * - `tokenId` must exist.
1149      *
1150      * Emits a {Transfer} event.
1151      */
1152     function _burn(uint256 tokenId) internal virtual {
1153         address owner = ERC721.ownerOf(tokenId);
1154 
1155         _beforeTokenTransfer(owner, address(0), tokenId);
1156 
1157         // Clear approvals
1158         _approve(address(0), tokenId);
1159 
1160         _balances[owner] -= 1;
1161         delete _owners[tokenId];
1162 
1163         emit Transfer(owner, address(0), tokenId);
1164     }
1165 
1166     /**
1167      * @dev Transfers `tokenId` from `from` to `to`.
1168      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1169      *
1170      * Requirements:
1171      *
1172      * - `to` cannot be the zero address.
1173      * - `tokenId` token must be owned by `from`.
1174      *
1175      * Emits a {Transfer} event.
1176      */
1177     function _transfer(
1178         address from,
1179         address to,
1180         uint256 tokenId
1181     ) internal virtual {
1182         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1183         require(to != address(0), "ERC721: transfer to the zero address");
1184 
1185         _beforeTokenTransfer(from, to, tokenId);
1186 
1187         // Clear approvals from the previous owner
1188         _approve(address(0), tokenId);
1189 
1190         _balances[from] -= 1;
1191         _balances[to] += 1;
1192         _owners[tokenId] = to;
1193 
1194         emit Transfer(from, to, tokenId);
1195     }
1196 
1197     /**
1198      * @dev Approve `to` to operate on `tokenId`
1199      *
1200      * Emits a {Approval} event.
1201      */
1202     function _approve(address to, uint256 tokenId) internal virtual {
1203         _tokenApprovals[tokenId] = to;
1204         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1205     }
1206 
1207     /**
1208      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1209      * The call is not executed if the target address is not a contract.
1210      *
1211      * @param from address representing the previous owner of the given token ID
1212      * @param to target address that will receive the tokens
1213      * @param tokenId uint256 ID of the token to be transferred
1214      * @param _data bytes optional data to send along with the call
1215      * @return bool whether the call correctly returned the expected magic value
1216      */
1217     function _checkOnERC721Received(
1218         address from,
1219         address to,
1220         uint256 tokenId,
1221         bytes memory _data
1222     ) private returns (bool) {
1223         if (to.isContract()) {
1224             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1225                 return retval == IERC721Receiver.onERC721Received.selector;
1226             } catch (bytes memory reason) {
1227                 if (reason.length == 0) {
1228                     revert("ERC721: transfer to non ERC721Receiver implementer");
1229                 } else {
1230                     assembly {
1231                         revert(add(32, reason), mload(reason))
1232                     }
1233                 }
1234             }
1235         } else {
1236             return true;
1237         }
1238     }
1239 
1240     /**
1241      * @dev Hook that is called before any token transfer. This includes minting
1242      * and burning.
1243      *
1244      * Calling conditions:
1245      *
1246      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1247      * transferred to `to`.
1248      * - When `from` is zero, `tokenId` will be minted for `to`.
1249      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1250      * - `from` and `to` are never both zero.
1251      *
1252      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1253      */
1254     function _beforeTokenTransfer(
1255         address from,
1256         address to,
1257         uint256 tokenId
1258     ) internal virtual {}
1259 }
1260 
1261 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1262 
1263 
1264 
1265 pragma solidity ^0.8.0;
1266 
1267 
1268 
1269 /**
1270  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1271  * enumerability of all the token ids in the contract as well as all token ids owned by each
1272  * account.
1273  */
1274 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1275     // Mapping from owner to list of owned token IDs
1276     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1277 
1278     // Mapping from token ID to index of the owner tokens list
1279     mapping(uint256 => uint256) private _ownedTokensIndex;
1280 
1281     // Array with all token ids, used for enumeration
1282     uint256[] private _allTokens;
1283 
1284     // Mapping from token id to position in the allTokens array
1285     mapping(uint256 => uint256) private _allTokensIndex;
1286 
1287     /**
1288      * @dev See {IERC165-supportsInterface}.
1289      */
1290     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1291         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1292     }
1293 
1294     /**
1295      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1296      */
1297     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1298         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1299         return _ownedTokens[owner][index];
1300     }
1301 
1302     /**
1303      * @dev See {IERC721Enumerable-totalSupply}.
1304      */
1305     function totalSupply() public view virtual override returns (uint256) {
1306         return _allTokens.length;
1307     }
1308 
1309     /**
1310      * @dev See {IERC721Enumerable-tokenByIndex}.
1311      */
1312     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1313         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1314         return _allTokens[index];
1315     }
1316 
1317     /**
1318      * @dev Hook that is called before any token transfer. This includes minting
1319      * and burning.
1320      *
1321      * Calling conditions:
1322      *
1323      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1324      * transferred to `to`.
1325      * - When `from` is zero, `tokenId` will be minted for `to`.
1326      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1327      * - `from` cannot be the zero address.
1328      * - `to` cannot be the zero address.
1329      *
1330      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1331      */
1332     function _beforeTokenTransfer(
1333         address from,
1334         address to,
1335         uint256 tokenId
1336     ) internal virtual override {
1337         super._beforeTokenTransfer(from, to, tokenId);
1338 
1339         if (from == address(0)) {
1340             _addTokenToAllTokensEnumeration(tokenId);
1341         } else if (from != to) {
1342             _removeTokenFromOwnerEnumeration(from, tokenId);
1343         }
1344         if (to == address(0)) {
1345             _removeTokenFromAllTokensEnumeration(tokenId);
1346         } else if (to != from) {
1347             _addTokenToOwnerEnumeration(to, tokenId);
1348         }
1349     }
1350 
1351     /**
1352      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1353      * @param to address representing the new owner of the given token ID
1354      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1355      */
1356     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1357         uint256 length = ERC721.balanceOf(to);
1358         _ownedTokens[to][length] = tokenId;
1359         _ownedTokensIndex[tokenId] = length;
1360     }
1361 
1362     /**
1363      * @dev Private function to add a token to this extension's token tracking data structures.
1364      * @param tokenId uint256 ID of the token to be added to the tokens list
1365      */
1366     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1367         _allTokensIndex[tokenId] = _allTokens.length;
1368         _allTokens.push(tokenId);
1369     }
1370 
1371     /**
1372      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1373      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1374      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1375      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1376      * @param from address representing the previous owner of the given token ID
1377      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1378      */
1379     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1380         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1381         // then delete the last slot (swap and pop).
1382 
1383         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1384         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1385 
1386         // When the token to delete is the last token, the swap operation is unnecessary
1387         if (tokenIndex != lastTokenIndex) {
1388             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1389 
1390             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1391             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1392         }
1393 
1394         // This also deletes the contents at the last position of the array
1395         delete _ownedTokensIndex[tokenId];
1396         delete _ownedTokens[from][lastTokenIndex];
1397     }
1398 
1399     /**
1400      * @dev Private function to remove a token from this extension's token tracking data structures.
1401      * This has O(1) time complexity, but alters the order of the _allTokens array.
1402      * @param tokenId uint256 ID of the token to be removed from the tokens list
1403      */
1404     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1405         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1406         // then delete the last slot (swap and pop).
1407 
1408         uint256 lastTokenIndex = _allTokens.length - 1;
1409         uint256 tokenIndex = _allTokensIndex[tokenId];
1410 
1411         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1412         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1413         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1414         uint256 lastTokenId = _allTokens[lastTokenIndex];
1415 
1416         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1417         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1418 
1419         // This also deletes the contents at the last position of the array
1420         delete _allTokensIndex[tokenId];
1421         _allTokens.pop();
1422     }
1423 }
1424 
1425 
1426 // File: @openzeppelin/contracts/access/Ownable.sol
1427 pragma solidity ^0.8.0;
1428 /**
1429  * @dev Contract module which provides a basic access control mechanism, where
1430  * there is an account (an owner) that can be granted exclusive access to
1431  * specific functions.
1432  *
1433  * By default, the owner account will be the one that deploys the contract. This
1434  * can later be changed with {transferOwnership}.
1435  *
1436  * This module is used through inheritance. It will make available the modifier
1437  * `onlyOwner`, which can be applied to your functions to restrict their use to
1438  * the owner.
1439  */
1440 abstract contract Ownable is Context {
1441     address private _owner;
1442 
1443     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1444 
1445     /**
1446      * @dev Initializes the contract setting the deployer as the initial owner.
1447      */
1448     constructor() {
1449         _setOwner(_msgSender());
1450     }
1451 
1452     /**
1453      * @dev Returns the address of the current owner.
1454      */
1455     function owner() public view virtual returns (address) {
1456         return _owner;
1457     }
1458 
1459     /**
1460      * @dev Throws if called by any account other than the owner.
1461      */
1462     modifier onlyOwner() {
1463         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1464         _;
1465     }
1466 
1467     /**
1468      * @dev Leaves the contract without owner. It will not be possible to call
1469      * `onlyOwner` functions anymore. Can only be called by the current owner.
1470      *
1471      * NOTE: Renouncing ownership will leave the contract without an owner,
1472      * thereby removing any functionality that is only available to the owner.
1473      */
1474     function renounceOwnership() public virtual onlyOwner {
1475         _setOwner(address(0));
1476     }
1477 
1478     /**
1479      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1480      * Can only be called by the current owner.
1481      */
1482     function transferOwnership(address newOwner) public virtual onlyOwner {
1483         require(newOwner != address(0), "Ownable: new owner is the zero address");
1484         _setOwner(newOwner);
1485     }
1486 
1487     function _setOwner(address newOwner) private {
1488         address oldOwner = _owner;
1489         _owner = newOwner;
1490         emit OwnershipTransferred(oldOwner, newOwner);
1491     }
1492 }
1493 
1494 
1495 pragma solidity >=0.7.0 <0.9.0;
1496 
1497 contract AstroArmadillos is ERC721Enumerable, Ownable {
1498   using Strings for uint256;
1499   using ECDSA for bytes32;
1500 
1501   uint256 public cost = 0 ether;
1502   uint256 public maxSupply = 1024;
1503   uint256 public maxMintAmount = 2;
1504   uint256 public nftPerAddressLimit = 2;
1505   bool public paused = true;
1506   bool public revealed = false;
1507   bool public onlyWhitelisted = true;
1508   mapping(address => uint256) public addressMintedBalance;
1509   address wl_manager = 0xA8ba5dF4009add3b8E9FdfccBb225EE3e15De275;
1510   string public baseURI = "https://astroarmadillos.mypinata.cloud/ipfs/QmNp6ytsmB9ww3bZH6MCsjv9GAHeE5vtA8LcBCDupAtkEr";
1511   string public baseExtension = ".json";
1512   string public notRevealedUri = "https://astroarmadillos.mypinata.cloud/ipfs/QmNp6ytsmB9ww3bZH6MCsjv9GAHeE5vtA8LcBCDupAtkEr";
1513 
1514   constructor() ERC721("Astro Armadillos", "Xingu") {}
1515 
1516     function _baseURI() internal view virtual override returns (string memory) {
1517         return baseURI;
1518     }
1519 
1520     function mint(uint256 _mintAmount) public payable {
1521         require(!paused, "the contract is paused");
1522         require(onlyWhitelisted == false, "Public mint is not started, please use whitelist mint.");
1523         uint256 supply = totalSupply();
1524         require(_mintAmount > 0, "need to mint at least 1 NFT");
1525         require(_mintAmount <= maxMintAmount, "max mint amount per session exceeded");
1526         require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
1527         uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1528         require(ownerMintedCount + _mintAmount <= nftPerAddressLimit, "max NFT per address exceeded");
1529         require(msg.value >= cost * _mintAmount, "insufficient funds");
1530 
1531         for (uint256 i = 1; i <= _mintAmount; i++) {
1532             addressMintedBalance[msg.sender]++;
1533             _safeMint(msg.sender, supply + i);
1534         }
1535     }
1536 
1537     function whitelistMint(uint256 _mintAmount, bytes memory _signature) public payable {
1538         require(!paused, "the contract is paused");
1539         require(onlyWhitelisted, "Whitelist Mint not active");
1540         uint256 supply = totalSupply();
1541         require(_mintAmount > 0, "need to mint at least 1 NFT");
1542         require(_mintAmount <= maxMintAmount, "max mint amount per session exceeded");
1543         require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
1544         require(isOnWhitelist(_signature), "user is not whitelisted");
1545         uint256 ownerMintedCount = addressMintedBalance[msg.sender]; 
1546         require(ownerMintedCount + _mintAmount <= nftPerAddressLimit, "max NFT per address exceeded");
1547         require(msg.value >= cost * _mintAmount, "insufficient funds");
1548 
1549         for (uint256 i = 1; i <= _mintAmount; i++) {
1550             addressMintedBalance[msg.sender]++;
1551             _safeMint(msg.sender, supply + i);
1552         }
1553     }
1554 
1555     function isOnWhitelist(bytes memory _signature)
1556         public
1557         view
1558         returns (bool)
1559     {
1560         bytes32 messagehash = keccak256(
1561             abi.encodePacked(address(this), msg.sender)
1562         );
1563         address signer = messagehash.toEthSignedMessageHash().recover(
1564             _signature
1565         );
1566 
1567         if (wl_manager == signer) {
1568             return true;
1569         } else {
1570             return false;
1571         }
1572     }
1573 
1574   function walletOfOwner(address _owner)
1575     public
1576     view
1577     returns (uint256[] memory)
1578   {
1579     uint256 ownerTokenCount = balanceOf(_owner);
1580     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1581     for (uint256 i; i < ownerTokenCount; i++) {
1582       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1583     }
1584     return tokenIds;
1585   }
1586 
1587   function tokenURI(uint256 tokenId)
1588     public
1589     view
1590     virtual
1591     override
1592     returns (string memory)
1593   {
1594     require(
1595       _exists(tokenId),
1596       "ERC721Metadata: URI query for nonexistent token"
1597     );
1598 
1599     if(revealed == false) {
1600         return notRevealedUri;
1601     }
1602 
1603     string memory currentBaseURI = _baseURI();
1604     return bytes(currentBaseURI).length > 0
1605         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1606         : "";
1607   }
1608 
1609   function reveal() public onlyOwner {
1610       revealed = true;
1611   }
1612 
1613   function setNftPerAddressLimit(uint256 _limit) public onlyOwner {
1614     nftPerAddressLimit = _limit;
1615   }
1616 
1617   function setCost(uint256 _newCost) public onlyOwner {
1618     cost = _newCost;
1619   }
1620 
1621   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1622     maxMintAmount = _newmaxMintAmount;
1623   }
1624 
1625   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1626     baseURI = _newBaseURI;
1627   }
1628 
1629   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1630     baseExtension = _newBaseExtension;
1631   }
1632 
1633   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1634     notRevealedUri = _notRevealedURI;
1635   }
1636 
1637   function pause(bool _state) public onlyOwner {
1638     paused = _state;
1639   }
1640 
1641   function setOnlyWhitelisted(bool _state) public onlyOwner {
1642     onlyWhitelisted = _state;
1643   }
1644 
1645   function withdraw() public payable onlyOwner {
1646 
1647     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1648     require(os);
1649   }
1650 }