1 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.0 (security/ReentrancyGuard.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Contract module that helps prevent reentrant calls to a function.
10  *
11  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
12  * available, which can be applied to functions to make sure there are no nested
13  * (reentrant) calls to them.
14  *
15  * Note that because there is a single `nonReentrant` guard, functions marked as
16  * `nonReentrant` may not call one another. This can be worked around by making
17  * those functions `private`, and then adding `external` `nonReentrant` entry
18  * points to them.
19  *
20  * TIP: If you would like to learn more about reentrancy and alternative ways
21  * to protect against it, check out our blog post
22  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
23  */
24 abstract contract ReentrancyGuard {
25     // Booleans are more expensive than uint256 or any type that takes up a full
26     // word because each write operation emits an extra SLOAD to first read the
27     // slot's contents, replace the bits taken up by the boolean, and then write
28     // back. This is the compiler's defense against contract upgrades and
29     // pointer aliasing, and it cannot be disabled.
30 
31     // The values being non-zero value makes deployment a bit more expensive,
32     // but in exchange the refund on every call to nonReentrant will be lower in
33     // amount. Since refunds are capped to a percentage of the total
34     // transaction's gas, it is best to keep them low in cases like this one, to
35     // increase the likelihood of the full refund coming into effect.
36     uint256 private constant _NOT_ENTERED = 1;
37     uint256 private constant _ENTERED = 2;
38 
39     uint256 private _status;
40 
41     constructor() {
42         _status = _NOT_ENTERED;
43     }
44 
45     /**
46      * @dev Prevents a contract from calling itself, directly or indirectly.
47      * Calling a `nonReentrant` function from another `nonReentrant`
48      * function is not supported. It is possible to prevent this from happening
49      * by making the `nonReentrant` function external, and making it call a
50      * `private` function that does the actual work.
51      */
52     modifier nonReentrant() {
53         // On the first call to nonReentrant, _notEntered will be true
54         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
55 
56         // Any calls to nonReentrant after this point will fail
57         _status = _ENTERED;
58 
59         _;
60 
61         // By storing the original value once again, a refund is triggered (see
62         // https://eips.ethereum.org/EIPS/eip-2200)
63         _status = _NOT_ENTERED;
64     }
65 }
66 
67 // File: @openzeppelin/contracts/utils/Strings.sol
68 
69 
70 // OpenZeppelin Contracts v4.4.0 (utils/Strings.sol)
71 
72 pragma solidity ^0.8.0;
73 
74 /**
75  * @dev String operations.
76  */
77 library Strings {
78     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
79 
80     /**
81      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
82      */
83     function toString(uint256 value) internal pure returns (string memory) {
84         // Inspired by OraclizeAPI's implementation - MIT licence
85         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
86 
87         if (value == 0) {
88             return "0";
89         }
90         uint256 temp = value;
91         uint256 digits;
92         while (temp != 0) {
93             digits++;
94             temp /= 10;
95         }
96         bytes memory buffer = new bytes(digits);
97         while (value != 0) {
98             digits -= 1;
99             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
100             value /= 10;
101         }
102         return string(buffer);
103     }
104 
105     /**
106      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
107      */
108     function toHexString(uint256 value) internal pure returns (string memory) {
109         if (value == 0) {
110             return "0x00";
111         }
112         uint256 temp = value;
113         uint256 length = 0;
114         while (temp != 0) {
115             length++;
116             temp >>= 8;
117         }
118         return toHexString(value, length);
119     }
120 
121     /**
122      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
123      */
124     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
125         bytes memory buffer = new bytes(2 * length + 2);
126         buffer[0] = "0";
127         buffer[1] = "x";
128         for (uint256 i = 2 * length + 1; i > 1; --i) {
129             buffer[i] = _HEX_SYMBOLS[value & 0xf];
130             value >>= 4;
131         }
132         require(value == 0, "Strings: hex length insufficient");
133         return string(buffer);
134     }
135 }
136 
137 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
138 
139 
140 // OpenZeppelin Contracts v4.4.0 (utils/cryptography/ECDSA.sol)
141 
142 pragma solidity ^0.8.0;
143 
144 
145 /**
146  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
147  *
148  * These functions can be used to verify that a message was signed by the holder
149  * of the private keys of a given address.
150  */
151 library ECDSA {
152     enum RecoverError {
153         NoError,
154         InvalidSignature,
155         InvalidSignatureLength,
156         InvalidSignatureS,
157         InvalidSignatureV
158     }
159 
160     function _throwError(RecoverError error) private pure {
161         if (error == RecoverError.NoError) {
162             return; // no error: do nothing
163         } else if (error == RecoverError.InvalidSignature) {
164             revert("ECDSA: invalid signature");
165         } else if (error == RecoverError.InvalidSignatureLength) {
166             revert("ECDSA: invalid signature length");
167         } else if (error == RecoverError.InvalidSignatureS) {
168             revert("ECDSA: invalid signature 's' value");
169         } else if (error == RecoverError.InvalidSignatureV) {
170             revert("ECDSA: invalid signature 'v' value");
171         }
172     }
173 
174     /**
175      * @dev Returns the address that signed a hashed message (`hash`) with
176      * `signature` or error string. This address can then be used for verification purposes.
177      *
178      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
179      * this function rejects them by requiring the `s` value to be in the lower
180      * half order, and the `v` value to be either 27 or 28.
181      *
182      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
183      * verification to be secure: it is possible to craft signatures that
184      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
185      * this is by receiving a hash of the original message (which may otherwise
186      * be too long), and then calling {toEthSignedMessageHash} on it.
187      *
188      * Documentation for signature generation:
189      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
190      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
191      *
192      * _Available since v4.3._
193      */
194     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
195         // Check the signature length
196         // - case 65: r,s,v signature (standard)
197         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
198         if (signature.length == 65) {
199             bytes32 r;
200             bytes32 s;
201             uint8 v;
202             // ecrecover takes the signature parameters, and the only way to get them
203             // currently is to use assembly.
204             assembly {
205                 r := mload(add(signature, 0x20))
206                 s := mload(add(signature, 0x40))
207                 v := byte(0, mload(add(signature, 0x60)))
208             }
209             return tryRecover(hash, v, r, s);
210         } else if (signature.length == 64) {
211             bytes32 r;
212             bytes32 vs;
213             // ecrecover takes the signature parameters, and the only way to get them
214             // currently is to use assembly.
215             assembly {
216                 r := mload(add(signature, 0x20))
217                 vs := mload(add(signature, 0x40))
218             }
219             return tryRecover(hash, r, vs);
220         } else {
221             return (address(0), RecoverError.InvalidSignatureLength);
222         }
223     }
224 
225     /**
226      * @dev Returns the address that signed a hashed message (`hash`) with
227      * `signature`. This address can then be used for verification purposes.
228      *
229      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
230      * this function rejects them by requiring the `s` value to be in the lower
231      * half order, and the `v` value to be either 27 or 28.
232      *
233      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
234      * verification to be secure: it is possible to craft signatures that
235      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
236      * this is by receiving a hash of the original message (which may otherwise
237      * be too long), and then calling {toEthSignedMessageHash} on it.
238      */
239     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
240         (address recovered, RecoverError error) = tryRecover(hash, signature);
241         _throwError(error);
242         return recovered;
243     }
244 
245     /**
246      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
247      *
248      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
249      *
250      * _Available since v4.3._
251      */
252     function tryRecover(
253         bytes32 hash,
254         bytes32 r,
255         bytes32 vs
256     ) internal pure returns (address, RecoverError) {
257         bytes32 s;
258         uint8 v;
259         assembly {
260             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
261             v := add(shr(255, vs), 27)
262         }
263         return tryRecover(hash, v, r, s);
264     }
265 
266     /**
267      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
268      *
269      * _Available since v4.2._
270      */
271     function recover(
272         bytes32 hash,
273         bytes32 r,
274         bytes32 vs
275     ) internal pure returns (address) {
276         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
277         _throwError(error);
278         return recovered;
279     }
280 
281     /**
282      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
283      * `r` and `s` signature fields separately.
284      *
285      * _Available since v4.3._
286      */
287     function tryRecover(
288         bytes32 hash,
289         uint8 v,
290         bytes32 r,
291         bytes32 s
292     ) internal pure returns (address, RecoverError) {
293         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
294         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
295         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
296         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
297         //
298         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
299         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
300         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
301         // these malleable signatures as well.
302         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
303             return (address(0), RecoverError.InvalidSignatureS);
304         }
305         if (v != 27 && v != 28) {
306             return (address(0), RecoverError.InvalidSignatureV);
307         }
308 
309         // If the signature is valid (and not malleable), return the signer address
310         address signer = ecrecover(hash, v, r, s);
311         if (signer == address(0)) {
312             return (address(0), RecoverError.InvalidSignature);
313         }
314 
315         return (signer, RecoverError.NoError);
316     }
317 
318     /**
319      * @dev Overload of {ECDSA-recover} that receives the `v`,
320      * `r` and `s` signature fields separately.
321      */
322     function recover(
323         bytes32 hash,
324         uint8 v,
325         bytes32 r,
326         bytes32 s
327     ) internal pure returns (address) {
328         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
329         _throwError(error);
330         return recovered;
331     }
332 
333     /**
334      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
335      * produces hash corresponding to the one signed with the
336      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
337      * JSON-RPC method as part of EIP-191.
338      *
339      * See {recover}.
340      */
341     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
342         // 32 is the length in bytes of hash,
343         // enforced by the type signature above
344         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
345     }
346 
347     /**
348      * @dev Returns an Ethereum Signed Message, created from `s`. This
349      * produces hash corresponding to the one signed with the
350      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
351      * JSON-RPC method as part of EIP-191.
352      *
353      * See {recover}.
354      */
355     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
356         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
357     }
358 
359     /**
360      * @dev Returns an Ethereum Signed Typed Data, created from a
361      * `domainSeparator` and a `structHash`. This produces hash corresponding
362      * to the one signed with the
363      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
364      * JSON-RPC method as part of EIP-712.
365      *
366      * See {recover}.
367      */
368     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
369         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
370     }
371 }
372 
373 // File: @openzeppelin/contracts/utils/Address.sol
374 
375 
376 // OpenZeppelin Contracts v4.4.0 (utils/Address.sol)
377 
378 pragma solidity ^0.8.0;
379 
380 /**
381  * @dev Collection of functions related to the address type
382  */
383 library Address {
384     /**
385      * @dev Returns true if `account` is a contract.
386      *
387      * [IMPORTANT]
388      * ====
389      * It is unsafe to assume that an address for which this function returns
390      * false is an externally-owned account (EOA) and not a contract.
391      *
392      * Among others, `isContract` will return false for the following
393      * types of addresses:
394      *
395      *  - an externally-owned account
396      *  - a contract in construction
397      *  - an address where a contract will be created
398      *  - an address where a contract lived, but was destroyed
399      * ====
400      */
401     function isContract(address account) internal view returns (bool) {
402         // This method relies on extcodesize, which returns 0 for contracts in
403         // construction, since the code is only stored at the end of the
404         // constructor execution.
405 
406         uint256 size;
407         assembly {
408             size := extcodesize(account)
409         }
410         return size > 0;
411     }
412 
413     /**
414      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
415      * `recipient`, forwarding all available gas and reverting on errors.
416      *
417      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
418      * of certain opcodes, possibly making contracts go over the 2300 gas limit
419      * imposed by `transfer`, making them unable to receive funds via
420      * `transfer`. {sendValue} removes this limitation.
421      *
422      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
423      *
424      * IMPORTANT: because control is transferred to `recipient`, care must be
425      * taken to not create reentrancy vulnerabilities. Consider using
426      * {ReentrancyGuard} or the
427      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
428      */
429     function sendValue(address payable recipient, uint256 amount) internal {
430         require(address(this).balance >= amount, "Address: insufficient balance");
431 
432         (bool success, ) = recipient.call{value: amount}("");
433         require(success, "Address: unable to send value, recipient may have reverted");
434     }
435 
436     /**
437      * @dev Performs a Solidity function call using a low level `call`. A
438      * plain `call` is an unsafe replacement for a function call: use this
439      * function instead.
440      *
441      * If `target` reverts with a revert reason, it is bubbled up by this
442      * function (like regular Solidity function calls).
443      *
444      * Returns the raw returned data. To convert to the expected return value,
445      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
446      *
447      * Requirements:
448      *
449      * - `target` must be a contract.
450      * - calling `target` with `data` must not revert.
451      *
452      * _Available since v3.1._
453      */
454     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
455         return functionCall(target, data, "Address: low-level call failed");
456     }
457 
458     /**
459      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
460      * `errorMessage` as a fallback revert reason when `target` reverts.
461      *
462      * _Available since v3.1._
463      */
464     function functionCall(
465         address target,
466         bytes memory data,
467         string memory errorMessage
468     ) internal returns (bytes memory) {
469         return functionCallWithValue(target, data, 0, errorMessage);
470     }
471 
472     /**
473      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
474      * but also transferring `value` wei to `target`.
475      *
476      * Requirements:
477      *
478      * - the calling contract must have an ETH balance of at least `value`.
479      * - the called Solidity function must be `payable`.
480      *
481      * _Available since v3.1._
482      */
483     function functionCallWithValue(
484         address target,
485         bytes memory data,
486         uint256 value
487     ) internal returns (bytes memory) {
488         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
489     }
490 
491     /**
492      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
493      * with `errorMessage` as a fallback revert reason when `target` reverts.
494      *
495      * _Available since v3.1._
496      */
497     function functionCallWithValue(
498         address target,
499         bytes memory data,
500         uint256 value,
501         string memory errorMessage
502     ) internal returns (bytes memory) {
503         require(address(this).balance >= value, "Address: insufficient balance for call");
504         require(isContract(target), "Address: call to non-contract");
505 
506         (bool success, bytes memory returndata) = target.call{value: value}(data);
507         return verifyCallResult(success, returndata, errorMessage);
508     }
509 
510     /**
511      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
512      * but performing a static call.
513      *
514      * _Available since v3.3._
515      */
516     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
517         return functionStaticCall(target, data, "Address: low-level static call failed");
518     }
519 
520     /**
521      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
522      * but performing a static call.
523      *
524      * _Available since v3.3._
525      */
526     function functionStaticCall(
527         address target,
528         bytes memory data,
529         string memory errorMessage
530     ) internal view returns (bytes memory) {
531         require(isContract(target), "Address: static call to non-contract");
532 
533         (bool success, bytes memory returndata) = target.staticcall(data);
534         return verifyCallResult(success, returndata, errorMessage);
535     }
536 
537     /**
538      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
539      * but performing a delegate call.
540      *
541      * _Available since v3.4._
542      */
543     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
544         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
545     }
546 
547     /**
548      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
549      * but performing a delegate call.
550      *
551      * _Available since v3.4._
552      */
553     function functionDelegateCall(
554         address target,
555         bytes memory data,
556         string memory errorMessage
557     ) internal returns (bytes memory) {
558         require(isContract(target), "Address: delegate call to non-contract");
559 
560         (bool success, bytes memory returndata) = target.delegatecall(data);
561         return verifyCallResult(success, returndata, errorMessage);
562     }
563 
564     /**
565      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
566      * revert reason using the provided one.
567      *
568      * _Available since v4.3._
569      */
570     function verifyCallResult(
571         bool success,
572         bytes memory returndata,
573         string memory errorMessage
574     ) internal pure returns (bytes memory) {
575         if (success) {
576             return returndata;
577         } else {
578             // Look for revert reason and bubble it up if present
579             if (returndata.length > 0) {
580                 // The easiest way to bubble the revert reason is using memory via assembly
581 
582                 assembly {
583                     let returndata_size := mload(returndata)
584                     revert(add(32, returndata), returndata_size)
585                 }
586             } else {
587                 revert(errorMessage);
588             }
589         }
590     }
591 }
592 
593 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
594 
595 
596 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721Receiver.sol)
597 
598 pragma solidity ^0.8.0;
599 
600 /**
601  * @title ERC721 token receiver interface
602  * @dev Interface for any contract that wants to support safeTransfers
603  * from ERC721 asset contracts.
604  */
605 interface IERC721Receiver {
606     /**
607      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
608      * by `operator` from `from`, this function is called.
609      *
610      * It must return its Solidity selector to confirm the token transfer.
611      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
612      *
613      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
614      */
615     function onERC721Received(
616         address operator,
617         address from,
618         uint256 tokenId,
619         bytes calldata data
620     ) external returns (bytes4);
621 }
622 
623 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
624 
625 
626 // OpenZeppelin Contracts v4.4.0 (utils/introspection/IERC165.sol)
627 
628 pragma solidity ^0.8.0;
629 
630 /**
631  * @dev Interface of the ERC165 standard, as defined in the
632  * https://eips.ethereum.org/EIPS/eip-165[EIP].
633  *
634  * Implementers can declare support of contract interfaces, which can then be
635  * queried by others ({ERC165Checker}).
636  *
637  * For an implementation, see {ERC165}.
638  */
639 interface IERC165 {
640     /**
641      * @dev Returns true if this contract implements the interface defined by
642      * `interfaceId`. See the corresponding
643      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
644      * to learn more about how these ids are created.
645      *
646      * This function call must use less than 30 000 gas.
647      */
648     function supportsInterface(bytes4 interfaceId) external view returns (bool);
649 }
650 
651 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
652 
653 
654 // OpenZeppelin Contracts v4.4.0 (utils/introspection/ERC165.sol)
655 
656 pragma solidity ^0.8.0;
657 
658 
659 /**
660  * @dev Implementation of the {IERC165} interface.
661  *
662  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
663  * for the additional interface id that will be supported. For example:
664  *
665  * ```solidity
666  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
667  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
668  * }
669  * ```
670  *
671  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
672  */
673 abstract contract ERC165 is IERC165 {
674     /**
675      * @dev See {IERC165-supportsInterface}.
676      */
677     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
678         return interfaceId == type(IERC165).interfaceId;
679     }
680 }
681 
682 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
683 
684 
685 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721.sol)
686 
687 pragma solidity ^0.8.0;
688 
689 
690 /**
691  * @dev Required interface of an ERC721 compliant contract.
692  */
693 interface IERC721 is IERC165 {
694     /**
695      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
696      */
697     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
698 
699     /**
700      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
701      */
702     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
703 
704     /**
705      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
706      */
707     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
708 
709     /**
710      * @dev Returns the number of tokens in ``owner``'s account.
711      */
712     function balanceOf(address owner) external view returns (uint256 balance);
713 
714     /**
715      * @dev Returns the owner of the `tokenId` token.
716      *
717      * Requirements:
718      *
719      * - `tokenId` must exist.
720      */
721     function ownerOf(uint256 tokenId) external view returns (address owner);
722 
723     /**
724      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
725      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
726      *
727      * Requirements:
728      *
729      * - `from` cannot be the zero address.
730      * - `to` cannot be the zero address.
731      * - `tokenId` token must exist and be owned by `from`.
732      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
733      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
734      *
735      * Emits a {Transfer} event.
736      */
737     function safeTransferFrom(
738         address from,
739         address to,
740         uint256 tokenId
741     ) external;
742 
743     /**
744      * @dev Transfers `tokenId` token from `from` to `to`.
745      *
746      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
747      *
748      * Requirements:
749      *
750      * - `from` cannot be the zero address.
751      * - `to` cannot be the zero address.
752      * - `tokenId` token must be owned by `from`.
753      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
754      *
755      * Emits a {Transfer} event.
756      */
757     function transferFrom(
758         address from,
759         address to,
760         uint256 tokenId
761     ) external;
762 
763     /**
764      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
765      * The approval is cleared when the token is transferred.
766      *
767      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
768      *
769      * Requirements:
770      *
771      * - The caller must own the token or be an approved operator.
772      * - `tokenId` must exist.
773      *
774      * Emits an {Approval} event.
775      */
776     function approve(address to, uint256 tokenId) external;
777 
778     /**
779      * @dev Returns the account approved for `tokenId` token.
780      *
781      * Requirements:
782      *
783      * - `tokenId` must exist.
784      */
785     function getApproved(uint256 tokenId) external view returns (address operator);
786 
787     /**
788      * @dev Approve or remove `operator` as an operator for the caller.
789      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
790      *
791      * Requirements:
792      *
793      * - The `operator` cannot be the caller.
794      *
795      * Emits an {ApprovalForAll} event.
796      */
797     function setApprovalForAll(address operator, bool _approved) external;
798 
799     /**
800      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
801      *
802      * See {setApprovalForAll}
803      */
804     function isApprovedForAll(address owner, address operator) external view returns (bool);
805 
806     /**
807      * @dev Safely transfers `tokenId` token from `from` to `to`.
808      *
809      * Requirements:
810      *
811      * - `from` cannot be the zero address.
812      * - `to` cannot be the zero address.
813      * - `tokenId` token must exist and be owned by `from`.
814      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
815      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
816      *
817      * Emits a {Transfer} event.
818      */
819     function safeTransferFrom(
820         address from,
821         address to,
822         uint256 tokenId,
823         bytes calldata data
824     ) external;
825 }
826 
827 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
828 
829 
830 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Metadata.sol)
831 
832 pragma solidity ^0.8.0;
833 
834 
835 /**
836  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
837  * @dev See https://eips.ethereum.org/EIPS/eip-721
838  */
839 interface IERC721Metadata is IERC721 {
840     /**
841      * @dev Returns the token collection name.
842      */
843     function name() external view returns (string memory);
844 
845     /**
846      * @dev Returns the token collection symbol.
847      */
848     function symbol() external view returns (string memory);
849 
850     /**
851      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
852      */
853     function tokenURI(uint256 tokenId) external view returns (string memory);
854 }
855 
856 // File: @openzeppelin/contracts/utils/Context.sol
857 
858 
859 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
860 
861 pragma solidity ^0.8.0;
862 
863 /**
864  * @dev Provides information about the current execution context, including the
865  * sender of the transaction and its data. While these are generally available
866  * via msg.sender and msg.data, they should not be accessed in such a direct
867  * manner, since when dealing with meta-transactions the account sending and
868  * paying for execution may not be the actual sender (as far as an application
869  * is concerned).
870  *
871  * This contract is only required for intermediate, library-like contracts.
872  */
873 abstract contract Context {
874     function _msgSender() internal view virtual returns (address) {
875         return msg.sender;
876     }
877 
878     function _msgData() internal view virtual returns (bytes calldata) {
879         return msg.data;
880     }
881 }
882 
883 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
884 
885 
886 // OpenZeppelin Contracts v4.4.0 (token/ERC721/ERC721.sol)
887 
888 pragma solidity ^0.8.0;
889 
890 
891 
892 
893 
894 
895 
896 
897 /**
898  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
899  * the Metadata extension, but not including the Enumerable extension, which is available separately as
900  * {ERC721Enumerable}.
901  */
902 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
903     using Address for address;
904     using Strings for uint256;
905 
906     // Token name
907     string private _name;
908 
909     // Token symbol
910     string private _symbol;
911 
912     // Mapping from token ID to owner address
913     mapping(uint256 => address) private _owners;
914 
915     // Mapping owner address to token count
916     mapping(address => uint256) private _balances;
917 
918     // Mapping from token ID to approved address
919     mapping(uint256 => address) private _tokenApprovals;
920 
921     // Mapping from owner to operator approvals
922     mapping(address => mapping(address => bool)) private _operatorApprovals;
923 
924     /**
925      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
926      */
927     constructor(string memory name_, string memory symbol_) {
928         _name = name_;
929         _symbol = symbol_;
930     }
931 
932     /**
933      * @dev See {IERC165-supportsInterface}.
934      */
935     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
936         return
937             interfaceId == type(IERC721).interfaceId ||
938             interfaceId == type(IERC721Metadata).interfaceId ||
939             super.supportsInterface(interfaceId);
940     }
941 
942     /**
943      * @dev See {IERC721-balanceOf}.
944      */
945     function balanceOf(address owner) public view virtual override returns (uint256) {
946         require(owner != address(0), "ERC721: balance query for the zero address");
947         return _balances[owner];
948     }
949 
950     /**
951      * @dev See {IERC721-ownerOf}.
952      */
953     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
954         address owner = _owners[tokenId];
955         require(owner != address(0), "ERC721: owner query for nonexistent token");
956         return owner;
957     }
958 
959     /**
960      * @dev See {IERC721Metadata-name}.
961      */
962     function name() public view virtual override returns (string memory) {
963         return _name;
964     }
965 
966     /**
967      * @dev See {IERC721Metadata-symbol}.
968      */
969     function symbol() public view virtual override returns (string memory) {
970         return _symbol;
971     }
972 
973     /**
974      * @dev See {IERC721Metadata-tokenURI}.
975      */
976     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
977         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
978 
979         string memory baseURI = _baseURI();
980         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
981     }
982 
983     /**
984      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
985      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
986      * by default, can be overriden in child contracts.
987      */
988     function _baseURI() internal view virtual returns (string memory) {
989         return "";
990     }
991 
992     /**
993      * @dev See {IERC721-approve}.
994      */
995     function approve(address to, uint256 tokenId) public virtual override {
996         address owner = ERC721.ownerOf(tokenId);
997         require(to != owner, "ERC721: approval to current owner");
998 
999         require(
1000             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1001             "ERC721: approve caller is not owner nor approved for all"
1002         );
1003 
1004         _approve(to, tokenId);
1005     }
1006 
1007     /**
1008      * @dev See {IERC721-getApproved}.
1009      */
1010     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1011         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1012 
1013         return _tokenApprovals[tokenId];
1014     }
1015 
1016     /**
1017      * @dev See {IERC721-setApprovalForAll}.
1018      */
1019     function setApprovalForAll(address operator, bool approved) public virtual override {
1020         _setApprovalForAll(_msgSender(), operator, approved);
1021     }
1022 
1023     /**
1024      * @dev See {IERC721-isApprovedForAll}.
1025      */
1026     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1027         return _operatorApprovals[owner][operator];
1028     }
1029 
1030     /**
1031      * @dev See {IERC721-transferFrom}.
1032      */
1033     function transferFrom(
1034         address from,
1035         address to,
1036         uint256 tokenId
1037     ) public virtual override {
1038         //solhint-disable-next-line max-line-length
1039         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1040 
1041         _transfer(from, to, tokenId);
1042     }
1043 
1044     /**
1045      * @dev See {IERC721-safeTransferFrom}.
1046      */
1047     function safeTransferFrom(
1048         address from,
1049         address to,
1050         uint256 tokenId
1051     ) public virtual override {
1052         safeTransferFrom(from, to, tokenId, "");
1053     }
1054 
1055     /**
1056      * @dev See {IERC721-safeTransferFrom}.
1057      */
1058     function safeTransferFrom(
1059         address from,
1060         address to,
1061         uint256 tokenId,
1062         bytes memory _data
1063     ) public virtual override {
1064         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1065         _safeTransfer(from, to, tokenId, _data);
1066     }
1067 
1068     /**
1069      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1070      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1071      *
1072      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1073      *
1074      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1075      * implement alternative mechanisms to perform token transfer, such as signature-based.
1076      *
1077      * Requirements:
1078      *
1079      * - `from` cannot be the zero address.
1080      * - `to` cannot be the zero address.
1081      * - `tokenId` token must exist and be owned by `from`.
1082      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1083      *
1084      * Emits a {Transfer} event.
1085      */
1086     function _safeTransfer(
1087         address from,
1088         address to,
1089         uint256 tokenId,
1090         bytes memory _data
1091     ) internal virtual {
1092         _transfer(from, to, tokenId);
1093         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1094     }
1095 
1096     /**
1097      * @dev Returns whether `tokenId` exists.
1098      *
1099      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1100      *
1101      * Tokens start existing when they are minted (`_mint`),
1102      * and stop existing when they are burned (`_burn`).
1103      */
1104     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1105         return _owners[tokenId] != address(0);
1106     }
1107 
1108     /**
1109      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1110      *
1111      * Requirements:
1112      *
1113      * - `tokenId` must exist.
1114      */
1115     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1116         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1117         address owner = ERC721.ownerOf(tokenId);
1118         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1119     }
1120 
1121     /**
1122      * @dev Safely mints `tokenId` and transfers it to `to`.
1123      *
1124      * Requirements:
1125      *
1126      * - `tokenId` must not exist.
1127      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1128      *
1129      * Emits a {Transfer} event.
1130      */
1131     function _safeMint(address to, uint256 tokenId) internal virtual {
1132         _safeMint(to, tokenId, "");
1133     }
1134 
1135     /**
1136      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1137      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1138      */
1139     function _safeMint(
1140         address to,
1141         uint256 tokenId,
1142         bytes memory _data
1143     ) internal virtual {
1144         _mint(to, tokenId);
1145         require(
1146             _checkOnERC721Received(address(0), to, tokenId, _data),
1147             "ERC721: transfer to non ERC721Receiver implementer"
1148         );
1149     }
1150 
1151     /**
1152      * @dev Mints `tokenId` and transfers it to `to`.
1153      *
1154      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1155      *
1156      * Requirements:
1157      *
1158      * - `tokenId` must not exist.
1159      * - `to` cannot be the zero address.
1160      *
1161      * Emits a {Transfer} event.
1162      */
1163     function _mint(address to, uint256 tokenId) internal virtual {
1164         require(to != address(0), "ERC721: mint to the zero address");
1165         require(!_exists(tokenId), "ERC721: token already minted");
1166 
1167         _beforeTokenTransfer(address(0), to, tokenId);
1168 
1169         _balances[to] += 1;
1170         _owners[tokenId] = to;
1171 
1172         emit Transfer(address(0), to, tokenId);
1173     }
1174 
1175     /**
1176      * @dev Destroys `tokenId`.
1177      * The approval is cleared when the token is burned.
1178      *
1179      * Requirements:
1180      *
1181      * - `tokenId` must exist.
1182      *
1183      * Emits a {Transfer} event.
1184      */
1185     function _burn(uint256 tokenId) internal virtual {
1186         address owner = ERC721.ownerOf(tokenId);
1187 
1188         _beforeTokenTransfer(owner, address(0), tokenId);
1189 
1190         // Clear approvals
1191         _approve(address(0), tokenId);
1192 
1193         _balances[owner] -= 1;
1194         delete _owners[tokenId];
1195 
1196         emit Transfer(owner, address(0), tokenId);
1197     }
1198 
1199     /**
1200      * @dev Transfers `tokenId` from `from` to `to`.
1201      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1202      *
1203      * Requirements:
1204      *
1205      * - `to` cannot be the zero address.
1206      * - `tokenId` token must be owned by `from`.
1207      *
1208      * Emits a {Transfer} event.
1209      */
1210     function _transfer(
1211         address from,
1212         address to,
1213         uint256 tokenId
1214     ) internal virtual {
1215         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1216         require(to != address(0), "ERC721: transfer to the zero address");
1217 
1218         _beforeTokenTransfer(from, to, tokenId);
1219 
1220         // Clear approvals from the previous owner
1221         _approve(address(0), tokenId);
1222 
1223         _balances[from] -= 1;
1224         _balances[to] += 1;
1225         _owners[tokenId] = to;
1226 
1227         emit Transfer(from, to, tokenId);
1228     }
1229 
1230     /**
1231      * @dev Approve `to` to operate on `tokenId`
1232      *
1233      * Emits a {Approval} event.
1234      */
1235     function _approve(address to, uint256 tokenId) internal virtual {
1236         _tokenApprovals[tokenId] = to;
1237         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1238     }
1239 
1240     /**
1241      * @dev Approve `operator` to operate on all of `owner` tokens
1242      *
1243      * Emits a {ApprovalForAll} event.
1244      */
1245     function _setApprovalForAll(
1246         address owner,
1247         address operator,
1248         bool approved
1249     ) internal virtual {
1250         require(owner != operator, "ERC721: approve to caller");
1251         _operatorApprovals[owner][operator] = approved;
1252         emit ApprovalForAll(owner, operator, approved);
1253     }
1254 
1255     /**
1256      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1257      * The call is not executed if the target address is not a contract.
1258      *
1259      * @param from address representing the previous owner of the given token ID
1260      * @param to target address that will receive the tokens
1261      * @param tokenId uint256 ID of the token to be transferred
1262      * @param _data bytes optional data to send along with the call
1263      * @return bool whether the call correctly returned the expected magic value
1264      */
1265     function _checkOnERC721Received(
1266         address from,
1267         address to,
1268         uint256 tokenId,
1269         bytes memory _data
1270     ) private returns (bool) {
1271         if (to.isContract()) {
1272             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1273                 return retval == IERC721Receiver.onERC721Received.selector;
1274             } catch (bytes memory reason) {
1275                 if (reason.length == 0) {
1276                     revert("ERC721: transfer to non ERC721Receiver implementer");
1277                 } else {
1278                     assembly {
1279                         revert(add(32, reason), mload(reason))
1280                     }
1281                 }
1282             }
1283         } else {
1284             return true;
1285         }
1286     }
1287 
1288     /**
1289      * @dev Hook that is called before any token transfer. This includes minting
1290      * and burning.
1291      *
1292      * Calling conditions:
1293      *
1294      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1295      * transferred to `to`.
1296      * - When `from` is zero, `tokenId` will be minted for `to`.
1297      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1298      * - `from` and `to` are never both zero.
1299      *
1300      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1301      */
1302     function _beforeTokenTransfer(
1303         address from,
1304         address to,
1305         uint256 tokenId
1306     ) internal virtual {}
1307 }
1308 
1309 // File: @openzeppelin/contracts/access/Ownable.sol
1310 
1311 
1312 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
1313 
1314 pragma solidity ^0.8.0;
1315 
1316 
1317 /**
1318  * @dev Contract module which provides a basic access control mechanism, where
1319  * there is an account (an owner) that can be granted exclusive access to
1320  * specific functions.
1321  *
1322  * By default, the owner account will be the one that deploys the contract. This
1323  * can later be changed with {transferOwnership}.
1324  *
1325  * This module is used through inheritance. It will make available the modifier
1326  * `onlyOwner`, which can be applied to your functions to restrict their use to
1327  * the owner.
1328  */
1329 abstract contract Ownable is Context {
1330     address private _owner;
1331 
1332     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1333 
1334     /**
1335      * @dev Initializes the contract setting the deployer as the initial owner.
1336      */
1337     constructor() {
1338         _transferOwnership(_msgSender());
1339     }
1340 
1341     /**
1342      * @dev Returns the address of the current owner.
1343      */
1344     function owner() public view virtual returns (address) {
1345         return _owner;
1346     }
1347 
1348     /**
1349      * @dev Throws if called by any account other than the owner.
1350      */
1351     modifier onlyOwner() {
1352         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1353         _;
1354     }
1355 
1356     /**
1357      * @dev Leaves the contract without owner. It will not be possible to call
1358      * `onlyOwner` functions anymore. Can only be called by the current owner.
1359      *
1360      * NOTE: Renouncing ownership will leave the contract without an owner,
1361      * thereby removing any functionality that is only available to the owner.
1362      */
1363     function renounceOwnership() public virtual onlyOwner {
1364         _transferOwnership(address(0));
1365     }
1366 
1367     /**
1368      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1369      * Can only be called by the current owner.
1370      */
1371     function transferOwnership(address newOwner) public virtual onlyOwner {
1372         require(newOwner != address(0), "Ownable: new owner is the zero address");
1373         _transferOwnership(newOwner);
1374     }
1375 
1376     /**
1377      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1378      * Internal function without access restriction.
1379      */
1380     function _transferOwnership(address newOwner) internal virtual {
1381         address oldOwner = _owner;
1382         _owner = newOwner;
1383         emit OwnershipTransferred(oldOwner, newOwner);
1384     }
1385 }
1386 
1387 // File: Wizard.sol
1388 
1389 
1390 pragma solidity 0.8.0;
1391 
1392 
1393 
1394 
1395 
1396 contract IWizardStaking {
1397     function autoStake(address from, uint256 tokenId) external {}
1398 }
1399 
1400 contract Wizard is Ownable, ERC721, ReentrancyGuard {
1401     using ECDSA for bytes32;
1402 
1403     uint256 public constant AST_PRICE = 0.060 ether;
1404     uint256 public constant NFT_PRICE = 0.065 ether;
1405     uint256 public constant NFT_LIMIT = 10000;
1406     uint256 public constant NFT_GIFTS = 100;
1407 
1408     uint256 public totalSupply = 0;
1409     uint256 public preSaleMax = 5;
1410     uint256 public pubSaleMax = 10;
1411 
1412     bool public preSaleOn = false;
1413     bool public pubSaleOn = false;
1414 
1415     address public signer;
1416 
1417     string public baseURI = "";
1418 
1419     mapping(address => uint256) public preSaleCount;
1420 
1421     constructor(string memory _initURI, address _initSigner)
1422         ERC721("Wizard Treasure Collective", "WTC")
1423     {
1424         baseURI = _initURI;
1425         signer = _initSigner;
1426     }
1427 
1428     function mint(uint256 _amount, address[] memory _autoStake)
1429         external
1430         payable
1431         nonReentrant
1432     {
1433         require(pubSaleOn == true, "SALE_NOT_STARTED");
1434         require(_amount <= pubSaleMax, "SALE_MAX_REACHED");
1435         _mint(_amount, _autoStake);
1436     }
1437 
1438     function mintPresale(
1439         uint256 _amount,
1440         bytes32 _hash,
1441         bytes memory _sig,
1442         address[] memory _autoStake
1443     ) external payable nonReentrant {
1444         require(preSaleOn == true, "PRESALE_NOT_STARTED");
1445         require(_checkSignature(_hash, _sig), "SIG_CHECK_FAILED");
1446         require(
1447             _hashTransaction(_msgSender(), _amount) == _hash,
1448             "HASH_CHECK_FAILED"
1449         );
1450         require(
1451             preSaleCount[_msgSender()] + _amount <= preSaleMax,
1452             "PRESALE_MAX_REACHED"
1453         );
1454         _mint(_amount, _autoStake);
1455         preSaleCount[_msgSender()] += _amount;
1456     }
1457 
1458     function _mint(uint256 _amount, address[] memory _autoStake) private {
1459         require(_autoStake.length <= _amount, "AMOUNT_AUTOSTAKE_MISMATCH");
1460         require(totalSupply + _amount <= NFT_LIMIT - NFT_GIFTS, "NFT_LIMIT_REACHED");
1461         require(
1462             msg.value ==
1463                 (NFT_PRICE * (_amount - _autoStake.length)) +
1464                     (AST_PRICE * _autoStake.length),
1465             "INCORRECT_VALUE"
1466         );
1467         for (uint256 i = 0; i < _amount; i++) {
1468             uint256 tokenId = totalSupply;
1469             _safeMint(_msgSender(), tokenId);
1470             if (_autoStake.length > i) {
1471                 require(
1472                     _autoStake[i] != address(0),
1473                     "INVALID_AUTOSTAKE_ADDRESS"
1474                 );
1475                 safeTransferFrom(_msgSender(), _autoStake[i], tokenId);
1476                 IWizardStaking(_autoStake[i]).autoStake(_msgSender(), tokenId);
1477             }
1478             totalSupply++;
1479         }
1480     }
1481 
1482     function gift(address[] memory _to) external onlyOwner nonReentrant {
1483         require(totalSupply + _to.length <= NFT_LIMIT, "NFT_LIMIT_REACHED");
1484         for(uint256 i = 0; i < _to.length; i++) {
1485             _safeMint(_msgSender(), totalSupply);
1486             totalSupply++;
1487         }
1488     }
1489 
1490     function tokensOfOwner(address _owner)
1491         public
1492         view
1493         returns (uint256[] memory)
1494     {
1495         uint256 _tokenCount = balanceOf(_owner);
1496         uint256[] memory _tokenIds = new uint256[](_tokenCount);
1497         uint256 _tokenIndex = 0;
1498         for (uint256 i = 0; i < totalSupply; i++) {
1499             if (ownerOf(i) == _owner) {
1500                 _tokenIds[_tokenIndex] = i;
1501                 _tokenIndex++;
1502             }
1503         }
1504         return _tokenIds;
1505     }
1506 
1507     function tokensOfOwnerByIndex(address _owner, uint256 _index)
1508         public
1509         view
1510         returns (uint256)
1511     {
1512         return tokensOfOwner(_owner)[_index];
1513     }
1514 
1515     function _checkSignature(bytes32 _hash, bytes memory _sig)
1516         private
1517         view
1518         returns (bool)
1519     {
1520         (address _addr, ) = ECDSA.toEthSignedMessageHash(_hash).tryRecover(
1521             _sig
1522         );
1523         return _addr == signer;
1524     }
1525 
1526     function _hashTransaction(address _sender, uint256 _amount)
1527         private
1528         pure
1529         returns (bytes32)
1530     {
1531         return keccak256(abi.encodePacked(_sender, _amount));
1532     }
1533 
1534     function withdraw() public payable onlyOwner {
1535         address ADDR_DAO = 0x62a25a9429d033E31328195c179351BD76A3F866;
1536         address ADDR_TEAM1 = 0x889C3EF9972Fb7c12F8e5339fFee49bFA0847f5A;
1537         address ADDR_TEAM2 = 0x96054f1141d31b59B36aA48689d56F669708d83A;
1538 
1539         uint256 _balance = address(this).balance;
1540         (bool daoSuccess, ) = payable(ADDR_DAO).call{
1541             value: (_balance * 50) / 100
1542         }("");
1543         require(daoSuccess, "DAO Transfer Failed");
1544         (bool team1Success, ) = payable(ADDR_TEAM1).call{
1545             value: (_balance * 165) / 1000
1546         }("");
1547         require(team1Success, "Team 1 Transfer Failed");
1548         (bool team2Success, ) = payable(ADDR_TEAM2).call{
1549             value: (_balance * 165) / 1000
1550         }("");
1551         require(team2Success, "Team 2 Transfer Failed");
1552         (bool ownerSuccess, ) = payable(_msgSender()).call{
1553             value: address(this).balance
1554         }("");
1555         require(ownerSuccess, "Owner Transfer Failed");
1556     }
1557 
1558     function togglePreSale() public onlyOwner {
1559         preSaleOn = !preSaleOn;
1560     }
1561 
1562     function togglePubSale() public onlyOwner {
1563         pubSaleOn = !pubSaleOn;
1564     }
1565 
1566     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1567         baseURI = _newBaseURI;
1568     }
1569 
1570     function _baseURI() internal view virtual override returns (string memory) {
1571         return baseURI;
1572     }
1573 
1574     function contractURI() public view returns (string memory) {
1575         return string(abi.encodePacked(baseURI, "contract"));
1576     }
1577 }