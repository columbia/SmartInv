1 // SPDX-License-Identifier: MIT
2 /*
3     _   ___ ___    ___                     _   _            
4    /_\ |_ _/ __|  / _ \ _ __  ___ _ _ __ _| |_(_)_ _____ ___
5   / _ \ | | (__  | (_) | '_ \/ -_) '_/ _` |  _| \ V / -_|_-<
6  /_/ \_\___\___|  \___/| .__/\___|_| \__,_|\__|_|\_/\___/__/
7                        |_|                                  
8                   By Devko.dev#7286
9 */
10 
11 // File: @openzeppelin/contracts/utils/Strings.sol
12 
13 
14 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
15 
16 pragma solidity ^0.8.0;
17 
18 /**
19  * @dev String operations.
20  */
21 library Strings {
22     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
23     uint8 private constant _ADDRESS_LENGTH = 20;
24 
25     /**
26      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
27      */
28     function toString(uint256 value) internal pure returns (string memory) {
29         // Inspired by OraclizeAPI's implementation - MIT licence
30         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
31 
32         if (value == 0) {
33             return "0";
34         }
35         uint256 temp = value;
36         uint256 digits;
37         while (temp != 0) {
38             digits++;
39             temp /= 10;
40         }
41         bytes memory buffer = new bytes(digits);
42         while (value != 0) {
43             digits -= 1;
44             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
45             value /= 10;
46         }
47         return string(buffer);
48     }
49 
50     /**
51      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
52      */
53     function toHexString(uint256 value) internal pure returns (string memory) {
54         if (value == 0) {
55             return "0x00";
56         }
57         uint256 temp = value;
58         uint256 length = 0;
59         while (temp != 0) {
60             length++;
61             temp >>= 8;
62         }
63         return toHexString(value, length);
64     }
65 
66     /**
67      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
68      */
69     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
70         bytes memory buffer = new bytes(2 * length + 2);
71         buffer[0] = "0";
72         buffer[1] = "x";
73         for (uint256 i = 2 * length + 1; i > 1; --i) {
74             buffer[i] = _HEX_SYMBOLS[value & 0xf];
75             value >>= 4;
76         }
77         require(value == 0, "Strings: hex length insufficient");
78         return string(buffer);
79     }
80 
81     /**
82      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
83      */
84     function toHexString(address addr) internal pure returns (string memory) {
85         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
86     }
87 }
88 
89 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
90 
91 
92 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/ECDSA.sol)
93 
94 pragma solidity ^0.8.0;
95 
96 
97 /**
98  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
99  *
100  * These functions can be used to verify that a message was signed by the holder
101  * of the private keys of a given address.
102  */
103 library ECDSA {
104     enum RecoverError {
105         NoError,
106         InvalidSignature,
107         InvalidSignatureLength,
108         InvalidSignatureS,
109         InvalidSignatureV
110     }
111 
112     function _throwError(RecoverError error) private pure {
113         if (error == RecoverError.NoError) {
114             return; // no error: do nothing
115         } else if (error == RecoverError.InvalidSignature) {
116             revert("ECDSA: invalid signature");
117         } else if (error == RecoverError.InvalidSignatureLength) {
118             revert("ECDSA: invalid signature length");
119         } else if (error == RecoverError.InvalidSignatureS) {
120             revert("ECDSA: invalid signature 's' value");
121         } else if (error == RecoverError.InvalidSignatureV) {
122             revert("ECDSA: invalid signature 'v' value");
123         }
124     }
125 
126     /**
127      * @dev Returns the address that signed a hashed message (`hash`) with
128      * `signature` or error string. This address can then be used for verification purposes.
129      *
130      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
131      * this function rejects them by requiring the `s` value to be in the lower
132      * half order, and the `v` value to be either 27 or 28.
133      *
134      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
135      * verification to be secure: it is possible to craft signatures that
136      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
137      * this is by receiving a hash of the original message (which may otherwise
138      * be too long), and then calling {toEthSignedMessageHash} on it.
139      *
140      * Documentation for signature generation:
141      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
142      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
143      *
144      * _Available since v4.3._
145      */
146     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
147         // Check the signature length
148         // - case 65: r,s,v signature (standard)
149         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
150         if (signature.length == 65) {
151             bytes32 r;
152             bytes32 s;
153             uint8 v;
154             // ecrecover takes the signature parameters, and the only way to get them
155             // currently is to use assembly.
156             /// @solidity memory-safe-assembly
157             assembly {
158                 r := mload(add(signature, 0x20))
159                 s := mload(add(signature, 0x40))
160                 v := byte(0, mload(add(signature, 0x60)))
161             }
162             return tryRecover(hash, v, r, s);
163         } else if (signature.length == 64) {
164             bytes32 r;
165             bytes32 vs;
166             // ecrecover takes the signature parameters, and the only way to get them
167             // currently is to use assembly.
168             /// @solidity memory-safe-assembly
169             assembly {
170                 r := mload(add(signature, 0x20))
171                 vs := mload(add(signature, 0x40))
172             }
173             return tryRecover(hash, r, vs);
174         } else {
175             return (address(0), RecoverError.InvalidSignatureLength);
176         }
177     }
178 
179     /**
180      * @dev Returns the address that signed a hashed message (`hash`) with
181      * `signature`. This address can then be used for verification purposes.
182      *
183      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
184      * this function rejects them by requiring the `s` value to be in the lower
185      * half order, and the `v` value to be either 27 or 28.
186      *
187      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
188      * verification to be secure: it is possible to craft signatures that
189      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
190      * this is by receiving a hash of the original message (which may otherwise
191      * be too long), and then calling {toEthSignedMessageHash} on it.
192      */
193     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
194         (address recovered, RecoverError error) = tryRecover(hash, signature);
195         _throwError(error);
196         return recovered;
197     }
198 
199     /**
200      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
201      *
202      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
203      *
204      * _Available since v4.3._
205      */
206     function tryRecover(
207         bytes32 hash,
208         bytes32 r,
209         bytes32 vs
210     ) internal pure returns (address, RecoverError) {
211         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
212         uint8 v = uint8((uint256(vs) >> 255) + 27);
213         return tryRecover(hash, v, r, s);
214     }
215 
216     /**
217      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
218      *
219      * _Available since v4.2._
220      */
221     function recover(
222         bytes32 hash,
223         bytes32 r,
224         bytes32 vs
225     ) internal pure returns (address) {
226         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
227         _throwError(error);
228         return recovered;
229     }
230 
231     /**
232      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
233      * `r` and `s` signature fields separately.
234      *
235      * _Available since v4.3._
236      */
237     function tryRecover(
238         bytes32 hash,
239         uint8 v,
240         bytes32 r,
241         bytes32 s
242     ) internal pure returns (address, RecoverError) {
243         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
244         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
245         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
246         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
247         //
248         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
249         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
250         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
251         // these malleable signatures as well.
252         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
253             return (address(0), RecoverError.InvalidSignatureS);
254         }
255         if (v != 27 && v != 28) {
256             return (address(0), RecoverError.InvalidSignatureV);
257         }
258 
259         // If the signature is valid (and not malleable), return the signer address
260         address signer = ecrecover(hash, v, r, s);
261         if (signer == address(0)) {
262             return (address(0), RecoverError.InvalidSignature);
263         }
264 
265         return (signer, RecoverError.NoError);
266     }
267 
268     /**
269      * @dev Overload of {ECDSA-recover} that receives the `v`,
270      * `r` and `s` signature fields separately.
271      */
272     function recover(
273         bytes32 hash,
274         uint8 v,
275         bytes32 r,
276         bytes32 s
277     ) internal pure returns (address) {
278         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
279         _throwError(error);
280         return recovered;
281     }
282 
283     /**
284      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
285      * produces hash corresponding to the one signed with the
286      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
287      * JSON-RPC method as part of EIP-191.
288      *
289      * See {recover}.
290      */
291     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
292         // 32 is the length in bytes of hash,
293         // enforced by the type signature above
294         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
295     }
296 
297     /**
298      * @dev Returns an Ethereum Signed Message, created from `s`. This
299      * produces hash corresponding to the one signed with the
300      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
301      * JSON-RPC method as part of EIP-191.
302      *
303      * See {recover}.
304      */
305     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
306         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
307     }
308 
309     /**
310      * @dev Returns an Ethereum Signed Typed Data, created from a
311      * `domainSeparator` and a `structHash`. This produces hash corresponding
312      * to the one signed with the
313      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
314      * JSON-RPC method as part of EIP-712.
315      *
316      * See {recover}.
317      */
318     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
319         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
320     }
321 }
322 
323 // File: @openzeppelin/contracts/utils/Address.sol
324 
325 
326 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
327 
328 pragma solidity ^0.8.1;
329 
330 /**
331  * @dev Collection of functions related to the address type
332  */
333 library Address {
334     /**
335      * @dev Returns true if `account` is a contract.
336      *
337      * [IMPORTANT]
338      * ====
339      * It is unsafe to assume that an address for which this function returns
340      * false is an externally-owned account (EOA) and not a contract.
341      *
342      * Among others, `isContract` will return false for the following
343      * types of addresses:
344      *
345      *  - an externally-owned account
346      *  - a contract in construction
347      *  - an address where a contract will be created
348      *  - an address where a contract lived, but was destroyed
349      * ====
350      *
351      * [IMPORTANT]
352      * ====
353      * You shouldn't rely on `isContract` to protect against flash loan attacks!
354      *
355      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
356      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
357      * constructor.
358      * ====
359      */
360     function isContract(address account) internal view returns (bool) {
361         // This method relies on extcodesize/address.code.length, which returns 0
362         // for contracts in construction, since the code is only stored at the end
363         // of the constructor execution.
364 
365         return account.code.length > 0;
366     }
367 
368     /**
369      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
370      * `recipient`, forwarding all available gas and reverting on errors.
371      *
372      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
373      * of certain opcodes, possibly making contracts go over the 2300 gas limit
374      * imposed by `transfer`, making them unable to receive funds via
375      * `transfer`. {sendValue} removes this limitation.
376      *
377      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
378      *
379      * IMPORTANT: because control is transferred to `recipient`, care must be
380      * taken to not create reentrancy vulnerabilities. Consider using
381      * {ReentrancyGuard} or the
382      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
383      */
384     function sendValue(address payable recipient, uint256 amount) internal {
385         require(address(this).balance >= amount, "Address: insufficient balance");
386 
387         (bool success, ) = recipient.call{value: amount}("");
388         require(success, "Address: unable to send value, recipient may have reverted");
389     }
390 
391     /**
392      * @dev Performs a Solidity function call using a low level `call`. A
393      * plain `call` is an unsafe replacement for a function call: use this
394      * function instead.
395      *
396      * If `target` reverts with a revert reason, it is bubbled up by this
397      * function (like regular Solidity function calls).
398      *
399      * Returns the raw returned data. To convert to the expected return value,
400      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
401      *
402      * Requirements:
403      *
404      * - `target` must be a contract.
405      * - calling `target` with `data` must not revert.
406      *
407      * _Available since v3.1._
408      */
409     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
410         return functionCall(target, data, "Address: low-level call failed");
411     }
412 
413     /**
414      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
415      * `errorMessage` as a fallback revert reason when `target` reverts.
416      *
417      * _Available since v3.1._
418      */
419     function functionCall(
420         address target,
421         bytes memory data,
422         string memory errorMessage
423     ) internal returns (bytes memory) {
424         return functionCallWithValue(target, data, 0, errorMessage);
425     }
426 
427     /**
428      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
429      * but also transferring `value` wei to `target`.
430      *
431      * Requirements:
432      *
433      * - the calling contract must have an ETH balance of at least `value`.
434      * - the called Solidity function must be `payable`.
435      *
436      * _Available since v3.1._
437      */
438     function functionCallWithValue(
439         address target,
440         bytes memory data,
441         uint256 value
442     ) internal returns (bytes memory) {
443         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
444     }
445 
446     /**
447      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
448      * with `errorMessage` as a fallback revert reason when `target` reverts.
449      *
450      * _Available since v3.1._
451      */
452     function functionCallWithValue(
453         address target,
454         bytes memory data,
455         uint256 value,
456         string memory errorMessage
457     ) internal returns (bytes memory) {
458         require(address(this).balance >= value, "Address: insufficient balance for call");
459         require(isContract(target), "Address: call to non-contract");
460 
461         (bool success, bytes memory returndata) = target.call{value: value}(data);
462         return verifyCallResult(success, returndata, errorMessage);
463     }
464 
465     /**
466      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
467      * but performing a static call.
468      *
469      * _Available since v3.3._
470      */
471     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
472         return functionStaticCall(target, data, "Address: low-level static call failed");
473     }
474 
475     /**
476      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
477      * but performing a static call.
478      *
479      * _Available since v3.3._
480      */
481     function functionStaticCall(
482         address target,
483         bytes memory data,
484         string memory errorMessage
485     ) internal view returns (bytes memory) {
486         require(isContract(target), "Address: static call to non-contract");
487 
488         (bool success, bytes memory returndata) = target.staticcall(data);
489         return verifyCallResult(success, returndata, errorMessage);
490     }
491 
492     /**
493      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
494      * but performing a delegate call.
495      *
496      * _Available since v3.4._
497      */
498     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
499         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
500     }
501 
502     /**
503      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
504      * but performing a delegate call.
505      *
506      * _Available since v3.4._
507      */
508     function functionDelegateCall(
509         address target,
510         bytes memory data,
511         string memory errorMessage
512     ) internal returns (bytes memory) {
513         require(isContract(target), "Address: delegate call to non-contract");
514 
515         (bool success, bytes memory returndata) = target.delegatecall(data);
516         return verifyCallResult(success, returndata, errorMessage);
517     }
518 
519     /**
520      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
521      * revert reason using the provided one.
522      *
523      * _Available since v4.3._
524      */
525     function verifyCallResult(
526         bool success,
527         bytes memory returndata,
528         string memory errorMessage
529     ) internal pure returns (bytes memory) {
530         if (success) {
531             return returndata;
532         } else {
533             // Look for revert reason and bubble it up if present
534             if (returndata.length > 0) {
535                 // The easiest way to bubble the revert reason is using memory via assembly
536                 /// @solidity memory-safe-assembly
537                 assembly {
538                     let returndata_size := mload(returndata)
539                     revert(add(32, returndata), returndata_size)
540                 }
541             } else {
542                 revert(errorMessage);
543             }
544         }
545     }
546 }
547 
548 // File: @openzeppelin/contracts/utils/Context.sol
549 
550 
551 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
552 
553 pragma solidity ^0.8.0;
554 
555 /**
556  * @dev Provides information about the current execution context, including the
557  * sender of the transaction and its data. While these are generally available
558  * via msg.sender and msg.data, they should not be accessed in such a direct
559  * manner, since when dealing with meta-transactions the account sending and
560  * paying for execution may not be the actual sender (as far as an application
561  * is concerned).
562  *
563  * This contract is only required for intermediate, library-like contracts.
564  */
565 abstract contract Context {
566     function _msgSender() internal view virtual returns (address) {
567         return msg.sender;
568     }
569 
570     function _msgData() internal view virtual returns (bytes calldata) {
571         return msg.data;
572     }
573 }
574 
575 // File: @openzeppelin/contracts/access/Ownable.sol
576 
577 
578 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
579 
580 pragma solidity ^0.8.0;
581 
582 
583 /**
584  * @dev Contract module which provides a basic access control mechanism, where
585  * there is an account (an owner) that can be granted exclusive access to
586  * specific functions.
587  *
588  * By default, the owner account will be the one that deploys the contract. This
589  * can later be changed with {transferOwnership}.
590  *
591  * This module is used through inheritance. It will make available the modifier
592  * `onlyOwner`, which can be applied to your functions to restrict their use to
593  * the owner.
594  */
595 abstract contract Ownable is Context {
596     address private _owner;
597 
598     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
599 
600     /**
601      * @dev Initializes the contract setting the deployer as the initial owner.
602      */
603     constructor() {
604         _transferOwnership(_msgSender());
605     }
606 
607     /**
608      * @dev Throws if called by any account other than the owner.
609      */
610     modifier onlyOwner() {
611         _checkOwner();
612         _;
613     }
614 
615     /**
616      * @dev Returns the address of the current owner.
617      */
618     function owner() public view virtual returns (address) {
619         return _owner;
620     }
621 
622     /**
623      * @dev Throws if the sender is not the owner.
624      */
625     function _checkOwner() internal view virtual {
626         require(owner() == _msgSender(), "Ownable: caller is not the owner");
627     }
628 
629     /**
630      * @dev Leaves the contract without owner. It will not be possible to call
631      * `onlyOwner` functions anymore. Can only be called by the current owner.
632      *
633      * NOTE: Renouncing ownership will leave the contract without an owner,
634      * thereby removing any functionality that is only available to the owner.
635      */
636     function renounceOwnership() public virtual onlyOwner {
637         _transferOwnership(address(0));
638     }
639 
640     /**
641      * @dev Transfers ownership of the contract to a new account (`newOwner`).
642      * Can only be called by the current owner.
643      */
644     function transferOwnership(address newOwner) public virtual onlyOwner {
645         require(newOwner != address(0), "Ownable: new owner is the zero address");
646         _transferOwnership(newOwner);
647     }
648 
649     /**
650      * @dev Transfers ownership of the contract to a new account (`newOwner`).
651      * Internal function without access restriction.
652      */
653     function _transferOwnership(address newOwner) internal virtual {
654         address oldOwner = _owner;
655         _owner = newOwner;
656         emit OwnershipTransferred(oldOwner, newOwner);
657     }
658 }
659 
660 // File: erc721a/contracts/IERC721A.sol
661 
662 
663 // ERC721A Contracts v4.2.0
664 // Creator: Chiru Labs
665 
666 pragma solidity ^0.8.4;
667 
668 /**
669  * @dev Interface of ERC721A.
670  */
671 interface IERC721A {
672     /**
673      * The caller must own the token or be an approved operator.
674      */
675     error ApprovalCallerNotOwnerNorApproved();
676 
677     /**
678      * The token does not exist.
679      */
680     error ApprovalQueryForNonexistentToken();
681 
682     /**
683      * The caller cannot approve to their own address.
684      */
685     error ApproveToCaller();
686 
687     /**
688      * Cannot query the balance for the zero address.
689      */
690     error BalanceQueryForZeroAddress();
691 
692     /**
693      * Cannot mint to the zero address.
694      */
695     error MintToZeroAddress();
696 
697     /**
698      * The quantity of tokens minted must be more than zero.
699      */
700     error MintZeroQuantity();
701 
702     /**
703      * The token does not exist.
704      */
705     error OwnerQueryForNonexistentToken();
706 
707     /**
708      * The caller must own the token or be an approved operator.
709      */
710     error TransferCallerNotOwnerNorApproved();
711 
712     /**
713      * The token must be owned by `from`.
714      */
715     error TransferFromIncorrectOwner();
716 
717     /**
718      * Cannot safely transfer to a contract that does not implement the
719      * ERC721Receiver interface.
720      */
721     error TransferToNonERC721ReceiverImplementer();
722 
723     /**
724      * Cannot transfer to the zero address.
725      */
726     error TransferToZeroAddress();
727 
728     /**
729      * The token does not exist.
730      */
731     error URIQueryForNonexistentToken();
732 
733     /**
734      * The `quantity` minted with ERC2309 exceeds the safety limit.
735      */
736     error MintERC2309QuantityExceedsLimit();
737 
738     /**
739      * The `extraData` cannot be set on an unintialized ownership slot.
740      */
741     error OwnershipNotInitializedForExtraData();
742 
743     // =============================================================
744     //                            STRUCTS
745     // =============================================================
746 
747     struct TokenOwnership {
748         // The address of the owner.
749         address addr;
750         // Stores the start time of ownership with minimal overhead for tokenomics.
751         uint64 startTimestamp;
752         // Whether the token has been burned.
753         bool burned;
754         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
755         uint24 extraData;
756     }
757 
758     // =============================================================
759     //                         TOKEN COUNTERS
760     // =============================================================
761 
762     /**
763      * @dev Returns the total number of tokens in existence.
764      * Burned tokens will reduce the count.
765      * To get the total number of tokens minted, please see {_totalMinted}.
766      */
767     function totalSupply() external view returns (uint256);
768 
769     // =============================================================
770     //                            IERC165
771     // =============================================================
772 
773     /**
774      * @dev Returns true if this contract implements the interface defined by
775      * `interfaceId`. See the corresponding
776      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
777      * to learn more about how these ids are created.
778      *
779      * This function call must use less than 30000 gas.
780      */
781     function supportsInterface(bytes4 interfaceId) external view returns (bool);
782 
783     // =============================================================
784     //                            IERC721
785     // =============================================================
786 
787     /**
788      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
789      */
790     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
791 
792     /**
793      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
794      */
795     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
796 
797     /**
798      * @dev Emitted when `owner` enables or disables
799      * (`approved`) `operator` to manage all of its assets.
800      */
801     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
802 
803     /**
804      * @dev Returns the number of tokens in `owner`'s account.
805      */
806     function balanceOf(address owner) external view returns (uint256 balance);
807 
808     /**
809      * @dev Returns the owner of the `tokenId` token.
810      *
811      * Requirements:
812      *
813      * - `tokenId` must exist.
814      */
815     function ownerOf(uint256 tokenId) external view returns (address owner);
816 
817     /**
818      * @dev Safely transfers `tokenId` token from `from` to `to`,
819      * checking first that contract recipients are aware of the ERC721 protocol
820      * to prevent tokens from being forever locked.
821      *
822      * Requirements:
823      *
824      * - `from` cannot be the zero address.
825      * - `to` cannot be the zero address.
826      * - `tokenId` token must exist and be owned by `from`.
827      * - If the caller is not `from`, it must be have been allowed to move
828      * this token by either {approve} or {setApprovalForAll}.
829      * - If `to` refers to a smart contract, it must implement
830      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
831      *
832      * Emits a {Transfer} event.
833      */
834     function safeTransferFrom(
835         address from,
836         address to,
837         uint256 tokenId,
838         bytes calldata data
839     ) external;
840 
841     /**
842      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
843      */
844     function safeTransferFrom(
845         address from,
846         address to,
847         uint256 tokenId
848     ) external;
849 
850     /**
851      * @dev Transfers `tokenId` from `from` to `to`.
852      *
853      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
854      * whenever possible.
855      *
856      * Requirements:
857      *
858      * - `from` cannot be the zero address.
859      * - `to` cannot be the zero address.
860      * - `tokenId` token must be owned by `from`.
861      * - If the caller is not `from`, it must be approved to move this token
862      * by either {approve} or {setApprovalForAll}.
863      *
864      * Emits a {Transfer} event.
865      */
866     function transferFrom(
867         address from,
868         address to,
869         uint256 tokenId
870     ) external;
871 
872     /**
873      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
874      * The approval is cleared when the token is transferred.
875      *
876      * Only a single account can be approved at a time, so approving the
877      * zero address clears previous approvals.
878      *
879      * Requirements:
880      *
881      * - The caller must own the token or be an approved operator.
882      * - `tokenId` must exist.
883      *
884      * Emits an {Approval} event.
885      */
886     function approve(address to, uint256 tokenId) external;
887 
888     /**
889      * @dev Approve or remove `operator` as an operator for the caller.
890      * Operators can call {transferFrom} or {safeTransferFrom}
891      * for any token owned by the caller.
892      *
893      * Requirements:
894      *
895      * - The `operator` cannot be the caller.
896      *
897      * Emits an {ApprovalForAll} event.
898      */
899     function setApprovalForAll(address operator, bool _approved) external;
900 
901     /**
902      * @dev Returns the account approved for `tokenId` token.
903      *
904      * Requirements:
905      *
906      * - `tokenId` must exist.
907      */
908     function getApproved(uint256 tokenId) external view returns (address operator);
909 
910     /**
911      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
912      *
913      * See {setApprovalForAll}.
914      */
915     function isApprovedForAll(address owner, address operator) external view returns (bool);
916 
917     // =============================================================
918     //                        IERC721Metadata
919     // =============================================================
920 
921     /**
922      * @dev Returns the token collection name.
923      */
924     function name() external view returns (string memory);
925 
926     /**
927      * @dev Returns the token collection symbol.
928      */
929     function symbol() external view returns (string memory);
930 
931     /**
932      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
933      */
934     function tokenURI(uint256 tokenId) external view returns (string memory);
935 
936     // =============================================================
937     //                           IERC2309
938     // =============================================================
939 
940     /**
941      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
942      * (inclusive) is transferred from `from` to `to`, as defined in the
943      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
944      *
945      * See {_mintERC2309} for more details.
946      */
947     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
948 }
949 
950 // File: erc721a/contracts/ERC721A.sol
951 
952 
953 // ERC721A Contracts v4.2.0
954 // Creator: Chiru Labs
955 
956 pragma solidity ^0.8.4;
957 
958 
959 /**
960  * @dev Interface of ERC721 token receiver.
961  */
962 interface ERC721A__IERC721Receiver {
963     function onERC721Received(
964         address operator,
965         address from,
966         uint256 tokenId,
967         bytes calldata data
968     ) external returns (bytes4);
969 }
970 
971 /**
972  * @title ERC721A
973  *
974  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
975  * Non-Fungible Token Standard, including the Metadata extension.
976  * Optimized for lower gas during batch mints.
977  *
978  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
979  * starting from `_startTokenId()`.
980  *
981  * Assumptions:
982  *
983  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
984  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
985  */
986 contract ERC721A is IERC721A {
987     // Reference type for token approval.
988     struct TokenApprovalRef {
989         address value;
990     }
991 
992     // =============================================================
993     //                           CONSTANTS
994     // =============================================================
995 
996     // Mask of an entry in packed address data.
997     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
998 
999     // The bit position of `numberMinted` in packed address data.
1000     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1001 
1002     // The bit position of `numberBurned` in packed address data.
1003     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1004 
1005     // The bit position of `aux` in packed address data.
1006     uint256 private constant _BITPOS_AUX = 192;
1007 
1008     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1009     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1010 
1011     // The bit position of `startTimestamp` in packed ownership.
1012     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1013 
1014     // The bit mask of the `burned` bit in packed ownership.
1015     uint256 private constant _BITMASK_BURNED = 1 << 224;
1016 
1017     // The bit position of the `nextInitialized` bit in packed ownership.
1018     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1019 
1020     // The bit mask of the `nextInitialized` bit in packed ownership.
1021     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1022 
1023     // The bit position of `extraData` in packed ownership.
1024     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1025 
1026     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1027     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1028 
1029     // The mask of the lower 160 bits for addresses.
1030     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1031 
1032     // The maximum `quantity` that can be minted with {_mintERC2309}.
1033     // This limit is to prevent overflows on the address data entries.
1034     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1035     // is required to cause an overflow, which is unrealistic.
1036     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1037 
1038     // The `Transfer` event signature is given by:
1039     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1040     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1041         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1042 
1043     // =============================================================
1044     //                            STORAGE
1045     // =============================================================
1046 
1047     // The next token ID to be minted.
1048     uint256 private _currentIndex;
1049 
1050     // The number of tokens burned.
1051     uint256 private _burnCounter;
1052 
1053     // Token name
1054     string private _name;
1055 
1056     // Token symbol
1057     string private _symbol;
1058 
1059     // Mapping from token ID to ownership details
1060     // An empty struct value does not necessarily mean the token is unowned.
1061     // See {_packedOwnershipOf} implementation for details.
1062     //
1063     // Bits Layout:
1064     // - [0..159]   `addr`
1065     // - [160..223] `startTimestamp`
1066     // - [224]      `burned`
1067     // - [225]      `nextInitialized`
1068     // - [232..255] `extraData`
1069     mapping(uint256 => uint256) private _packedOwnerships;
1070 
1071     // Mapping owner address to address data.
1072     //
1073     // Bits Layout:
1074     // - [0..63]    `balance`
1075     // - [64..127]  `numberMinted`
1076     // - [128..191] `numberBurned`
1077     // - [192..255] `aux`
1078     mapping(address => uint256) private _packedAddressData;
1079 
1080     // Mapping from token ID to approved address.
1081     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1082 
1083     // Mapping from owner to operator approvals
1084     mapping(address => mapping(address => bool)) private _operatorApprovals;
1085 
1086     // =============================================================
1087     //                          CONSTRUCTOR
1088     // =============================================================
1089 
1090     constructor(string memory name_, string memory symbol_) {
1091         _name = name_;
1092         _symbol = symbol_;
1093         _currentIndex = _startTokenId();
1094     }
1095 
1096     // =============================================================
1097     //                   TOKEN COUNTING OPERATIONS
1098     // =============================================================
1099 
1100     /**
1101      * @dev Returns the starting token ID.
1102      * To change the starting token ID, please override this function.
1103      */
1104     function _startTokenId() internal view virtual returns (uint256) {
1105         return 0;
1106     }
1107 
1108     /**
1109      * @dev Returns the next token ID to be minted.
1110      */
1111     function _nextTokenId() internal view virtual returns (uint256) {
1112         return _currentIndex;
1113     }
1114 
1115     /**
1116      * @dev Returns the total number of tokens in existence.
1117      * Burned tokens will reduce the count.
1118      * To get the total number of tokens minted, please see {_totalMinted}.
1119      */
1120     function totalSupply() public view virtual override returns (uint256) {
1121         // Counter underflow is impossible as _burnCounter cannot be incremented
1122         // more than `_currentIndex - _startTokenId()` times.
1123         unchecked {
1124             return _currentIndex - _burnCounter - _startTokenId();
1125         }
1126     }
1127 
1128     /**
1129      * @dev Returns the total amount of tokens minted in the contract.
1130      */
1131     function _totalMinted() internal view virtual returns (uint256) {
1132         // Counter underflow is impossible as `_currentIndex` does not decrement,
1133         // and it is initialized to `_startTokenId()`.
1134         unchecked {
1135             return _currentIndex - _startTokenId();
1136         }
1137     }
1138 
1139     /**
1140      * @dev Returns the total number of tokens burned.
1141      */
1142     function _totalBurned() internal view virtual returns (uint256) {
1143         return _burnCounter;
1144     }
1145 
1146     // =============================================================
1147     //                    ADDRESS DATA OPERATIONS
1148     // =============================================================
1149 
1150     /**
1151      * @dev Returns the number of tokens in `owner`'s account.
1152      */
1153     function balanceOf(address owner) public view virtual override returns (uint256) {
1154         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1155         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1156     }
1157 
1158     /**
1159      * Returns the number of tokens minted by `owner`.
1160      */
1161     function _numberMinted(address owner) internal view returns (uint256) {
1162         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1163     }
1164 
1165     /**
1166      * Returns the number of tokens burned by or on behalf of `owner`.
1167      */
1168     function _numberBurned(address owner) internal view returns (uint256) {
1169         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1170     }
1171 
1172     /**
1173      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1174      */
1175     function _getAux(address owner) internal view returns (uint64) {
1176         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1177     }
1178 
1179     /**
1180      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1181      * If there are multiple variables, please pack them into a uint64.
1182      */
1183     function _setAux(address owner, uint64 aux) internal virtual {
1184         uint256 packed = _packedAddressData[owner];
1185         uint256 auxCasted;
1186         // Cast `aux` with assembly to avoid redundant masking.
1187         assembly {
1188             auxCasted := aux
1189         }
1190         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1191         _packedAddressData[owner] = packed;
1192     }
1193 
1194     // =============================================================
1195     //                            IERC165
1196     // =============================================================
1197 
1198     /**
1199      * @dev Returns true if this contract implements the interface defined by
1200      * `interfaceId`. See the corresponding
1201      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1202      * to learn more about how these ids are created.
1203      *
1204      * This function call must use less than 30000 gas.
1205      */
1206     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1207         // The interface IDs are constants representing the first 4 bytes
1208         // of the XOR of all function selectors in the interface.
1209         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1210         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1211         return
1212             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1213             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1214             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1215     }
1216 
1217     // =============================================================
1218     //                        IERC721Metadata
1219     // =============================================================
1220 
1221     /**
1222      * @dev Returns the token collection name.
1223      */
1224     function name() public view virtual override returns (string memory) {
1225         return _name;
1226     }
1227 
1228     /**
1229      * @dev Returns the token collection symbol.
1230      */
1231     function symbol() public view virtual override returns (string memory) {
1232         return _symbol;
1233     }
1234 
1235     /**
1236      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1237      */
1238     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1239         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1240 
1241         string memory baseURI = _baseURI();
1242         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1243     }
1244 
1245     /**
1246      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1247      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1248      * by default, it can be overridden in child contracts.
1249      */
1250     function _baseURI() internal view virtual returns (string memory) {
1251         return '';
1252     }
1253 
1254     // =============================================================
1255     //                     OWNERSHIPS OPERATIONS
1256     // =============================================================
1257 
1258     /**
1259      * @dev Returns the owner of the `tokenId` token.
1260      *
1261      * Requirements:
1262      *
1263      * - `tokenId` must exist.
1264      */
1265     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1266         return address(uint160(_packedOwnershipOf(tokenId)));
1267     }
1268 
1269     /**
1270      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1271      * It gradually moves to O(1) as tokens get transferred around over time.
1272      */
1273     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1274         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1275     }
1276 
1277     /**
1278      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1279      */
1280     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1281         return _unpackedOwnership(_packedOwnerships[index]);
1282     }
1283 
1284     /**
1285      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1286      */
1287     function _initializeOwnershipAt(uint256 index) internal virtual {
1288         if (_packedOwnerships[index] == 0) {
1289             _packedOwnerships[index] = _packedOwnershipOf(index);
1290         }
1291     }
1292 
1293     /**
1294      * Returns the packed ownership data of `tokenId`.
1295      */
1296     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1297         uint256 curr = tokenId;
1298 
1299         unchecked {
1300             if (_startTokenId() <= curr)
1301                 if (curr < _currentIndex) {
1302                     uint256 packed = _packedOwnerships[curr];
1303                     // If not burned.
1304                     if (packed & _BITMASK_BURNED == 0) {
1305                         // Invariant:
1306                         // There will always be an initialized ownership slot
1307                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1308                         // before an unintialized ownership slot
1309                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1310                         // Hence, `curr` will not underflow.
1311                         //
1312                         // We can directly compare the packed value.
1313                         // If the address is zero, packed will be zero.
1314                         while (packed == 0) {
1315                             packed = _packedOwnerships[--curr];
1316                         }
1317                         return packed;
1318                     }
1319                 }
1320         }
1321         revert OwnerQueryForNonexistentToken();
1322     }
1323 
1324     /**
1325      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1326      */
1327     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1328         ownership.addr = address(uint160(packed));
1329         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1330         ownership.burned = packed & _BITMASK_BURNED != 0;
1331         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1332     }
1333 
1334     /**
1335      * @dev Packs ownership data into a single uint256.
1336      */
1337     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1338         assembly {
1339             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1340             owner := and(owner, _BITMASK_ADDRESS)
1341             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1342             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1343         }
1344     }
1345 
1346     /**
1347      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1348      */
1349     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1350         // For branchless setting of the `nextInitialized` flag.
1351         assembly {
1352             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1353             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1354         }
1355     }
1356 
1357     // =============================================================
1358     //                      APPROVAL OPERATIONS
1359     // =============================================================
1360 
1361     /**
1362      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1363      * The approval is cleared when the token is transferred.
1364      *
1365      * Only a single account can be approved at a time, so approving the
1366      * zero address clears previous approvals.
1367      *
1368      * Requirements:
1369      *
1370      * - The caller must own the token or be an approved operator.
1371      * - `tokenId` must exist.
1372      *
1373      * Emits an {Approval} event.
1374      */
1375     function approve(address to, uint256 tokenId) public virtual override {
1376         address owner = ownerOf(tokenId);
1377 
1378         if (_msgSenderERC721A() != owner)
1379             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1380                 revert ApprovalCallerNotOwnerNorApproved();
1381             }
1382 
1383         _tokenApprovals[tokenId].value = to;
1384         emit Approval(owner, to, tokenId);
1385     }
1386 
1387     /**
1388      * @dev Returns the account approved for `tokenId` token.
1389      *
1390      * Requirements:
1391      *
1392      * - `tokenId` must exist.
1393      */
1394     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1395         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1396 
1397         return _tokenApprovals[tokenId].value;
1398     }
1399 
1400     /**
1401      * @dev Approve or remove `operator` as an operator for the caller.
1402      * Operators can call {transferFrom} or {safeTransferFrom}
1403      * for any token owned by the caller.
1404      *
1405      * Requirements:
1406      *
1407      * - The `operator` cannot be the caller.
1408      *
1409      * Emits an {ApprovalForAll} event.
1410      */
1411     function setApprovalForAll(address operator, bool approved) public virtual override {
1412         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1413 
1414         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1415         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1416     }
1417 
1418     /**
1419      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1420      *
1421      * See {setApprovalForAll}.
1422      */
1423     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1424         return _operatorApprovals[owner][operator];
1425     }
1426 
1427     /**
1428      * @dev Returns whether `tokenId` exists.
1429      *
1430      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1431      *
1432      * Tokens start existing when they are minted. See {_mint}.
1433      */
1434     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1435         return
1436             _startTokenId() <= tokenId &&
1437             tokenId < _currentIndex && // If within bounds,
1438             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1439     }
1440 
1441     /**
1442      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1443      */
1444     function _isSenderApprovedOrOwner(
1445         address approvedAddress,
1446         address owner,
1447         address msgSender
1448     ) private pure returns (bool result) {
1449         assembly {
1450             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1451             owner := and(owner, _BITMASK_ADDRESS)
1452             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1453             msgSender := and(msgSender, _BITMASK_ADDRESS)
1454             // `msgSender == owner || msgSender == approvedAddress`.
1455             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1456         }
1457     }
1458 
1459     /**
1460      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1461      */
1462     function _getApprovedSlotAndAddress(uint256 tokenId)
1463         private
1464         view
1465         returns (uint256 approvedAddressSlot, address approvedAddress)
1466     {
1467         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1468         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1469         assembly {
1470             approvedAddressSlot := tokenApproval.slot
1471             approvedAddress := sload(approvedAddressSlot)
1472         }
1473     }
1474 
1475     // =============================================================
1476     //                      TRANSFER OPERATIONS
1477     // =============================================================
1478 
1479     /**
1480      * @dev Transfers `tokenId` from `from` to `to`.
1481      *
1482      * Requirements:
1483      *
1484      * - `from` cannot be the zero address.
1485      * - `to` cannot be the zero address.
1486      * - `tokenId` token must be owned by `from`.
1487      * - If the caller is not `from`, it must be approved to move this token
1488      * by either {approve} or {setApprovalForAll}.
1489      *
1490      * Emits a {Transfer} event.
1491      */
1492     function transferFrom(
1493         address from,
1494         address to,
1495         uint256 tokenId
1496     ) public virtual override {
1497         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1498 
1499         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1500 
1501         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1502 
1503         // The nested ifs save around 20+ gas over a compound boolean condition.
1504         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1505             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1506 
1507         if (to == address(0)) revert TransferToZeroAddress();
1508 
1509         _beforeTokenTransfers(from, to, tokenId, 1);
1510 
1511         // Clear approvals from the previous owner.
1512         assembly {
1513             if approvedAddress {
1514                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1515                 sstore(approvedAddressSlot, 0)
1516             }
1517         }
1518 
1519         // Underflow of the sender's balance is impossible because we check for
1520         // ownership above and the recipient's balance can't realistically overflow.
1521         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1522         unchecked {
1523             // We can directly increment and decrement the balances.
1524             --_packedAddressData[from]; // Updates: `balance -= 1`.
1525             ++_packedAddressData[to]; // Updates: `balance += 1`.
1526 
1527             // Updates:
1528             // - `address` to the next owner.
1529             // - `startTimestamp` to the timestamp of transfering.
1530             // - `burned` to `false`.
1531             // - `nextInitialized` to `true`.
1532             _packedOwnerships[tokenId] = _packOwnershipData(
1533                 to,
1534                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1535             );
1536 
1537             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1538             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1539                 uint256 nextTokenId = tokenId + 1;
1540                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1541                 if (_packedOwnerships[nextTokenId] == 0) {
1542                     // If the next slot is within bounds.
1543                     if (nextTokenId != _currentIndex) {
1544                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1545                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1546                     }
1547                 }
1548             }
1549         }
1550 
1551         emit Transfer(from, to, tokenId);
1552         _afterTokenTransfers(from, to, tokenId, 1);
1553     }
1554 
1555     /**
1556      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1557      */
1558     function safeTransferFrom(
1559         address from,
1560         address to,
1561         uint256 tokenId
1562     ) public virtual override {
1563         safeTransferFrom(from, to, tokenId, '');
1564     }
1565 
1566     /**
1567      * @dev Safely transfers `tokenId` token from `from` to `to`.
1568      *
1569      * Requirements:
1570      *
1571      * - `from` cannot be the zero address.
1572      * - `to` cannot be the zero address.
1573      * - `tokenId` token must exist and be owned by `from`.
1574      * - If the caller is not `from`, it must be approved to move this token
1575      * by either {approve} or {setApprovalForAll}.
1576      * - If `to` refers to a smart contract, it must implement
1577      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1578      *
1579      * Emits a {Transfer} event.
1580      */
1581     function safeTransferFrom(
1582         address from,
1583         address to,
1584         uint256 tokenId,
1585         bytes memory _data
1586     ) public virtual override {
1587         transferFrom(from, to, tokenId);
1588         if (to.code.length != 0)
1589             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1590                 revert TransferToNonERC721ReceiverImplementer();
1591             }
1592     }
1593 
1594     /**
1595      * @dev Hook that is called before a set of serially-ordered token IDs
1596      * are about to be transferred. This includes minting.
1597      * And also called before burning one token.
1598      *
1599      * `startTokenId` - the first token ID to be transferred.
1600      * `quantity` - the amount to be transferred.
1601      *
1602      * Calling conditions:
1603      *
1604      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1605      * transferred to `to`.
1606      * - When `from` is zero, `tokenId` will be minted for `to`.
1607      * - When `to` is zero, `tokenId` will be burned by `from`.
1608      * - `from` and `to` are never both zero.
1609      */
1610     function _beforeTokenTransfers(
1611         address from,
1612         address to,
1613         uint256 startTokenId,
1614         uint256 quantity
1615     ) internal virtual {}
1616 
1617     /**
1618      * @dev Hook that is called after a set of serially-ordered token IDs
1619      * have been transferred. This includes minting.
1620      * And also called after one token has been burned.
1621      *
1622      * `startTokenId` - the first token ID to be transferred.
1623      * `quantity` - the amount to be transferred.
1624      *
1625      * Calling conditions:
1626      *
1627      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1628      * transferred to `to`.
1629      * - When `from` is zero, `tokenId` has been minted for `to`.
1630      * - When `to` is zero, `tokenId` has been burned by `from`.
1631      * - `from` and `to` are never both zero.
1632      */
1633     function _afterTokenTransfers(
1634         address from,
1635         address to,
1636         uint256 startTokenId,
1637         uint256 quantity
1638     ) internal virtual {}
1639 
1640     /**
1641      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1642      *
1643      * `from` - Previous owner of the given token ID.
1644      * `to` - Target address that will receive the token.
1645      * `tokenId` - Token ID to be transferred.
1646      * `_data` - Optional data to send along with the call.
1647      *
1648      * Returns whether the call correctly returned the expected magic value.
1649      */
1650     function _checkContractOnERC721Received(
1651         address from,
1652         address to,
1653         uint256 tokenId,
1654         bytes memory _data
1655     ) private returns (bool) {
1656         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1657             bytes4 retval
1658         ) {
1659             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1660         } catch (bytes memory reason) {
1661             if (reason.length == 0) {
1662                 revert TransferToNonERC721ReceiverImplementer();
1663             } else {
1664                 assembly {
1665                     revert(add(32, reason), mload(reason))
1666                 }
1667             }
1668         }
1669     }
1670 
1671     // =============================================================
1672     //                        MINT OPERATIONS
1673     // =============================================================
1674 
1675     /**
1676      * @dev Mints `quantity` tokens and transfers them to `to`.
1677      *
1678      * Requirements:
1679      *
1680      * - `to` cannot be the zero address.
1681      * - `quantity` must be greater than 0.
1682      *
1683      * Emits a {Transfer} event for each mint.
1684      */
1685     function _mint(address to, uint256 quantity) internal virtual {
1686         uint256 startTokenId = _currentIndex;
1687         if (quantity == 0) revert MintZeroQuantity();
1688 
1689         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1690 
1691         // Overflows are incredibly unrealistic.
1692         // `balance` and `numberMinted` have a maximum limit of 2**64.
1693         // `tokenId` has a maximum limit of 2**256.
1694         unchecked {
1695             // Updates:
1696             // - `balance += quantity`.
1697             // - `numberMinted += quantity`.
1698             //
1699             // We can directly add to the `balance` and `numberMinted`.
1700             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1701 
1702             // Updates:
1703             // - `address` to the owner.
1704             // - `startTimestamp` to the timestamp of minting.
1705             // - `burned` to `false`.
1706             // - `nextInitialized` to `quantity == 1`.
1707             _packedOwnerships[startTokenId] = _packOwnershipData(
1708                 to,
1709                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1710             );
1711 
1712             uint256 toMasked;
1713             uint256 end = startTokenId + quantity;
1714 
1715             // Use assembly to loop and emit the `Transfer` event for gas savings.
1716             assembly {
1717                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1718                 toMasked := and(to, _BITMASK_ADDRESS)
1719                 // Emit the `Transfer` event.
1720                 log4(
1721                     0, // Start of data (0, since no data).
1722                     0, // End of data (0, since no data).
1723                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1724                     0, // `address(0)`.
1725                     toMasked, // `to`.
1726                     startTokenId // `tokenId`.
1727                 )
1728 
1729                 for {
1730                     let tokenId := add(startTokenId, 1)
1731                 } iszero(eq(tokenId, end)) {
1732                     tokenId := add(tokenId, 1)
1733                 } {
1734                     // Emit the `Transfer` event. Similar to above.
1735                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1736                 }
1737             }
1738             if (toMasked == 0) revert MintToZeroAddress();
1739 
1740             _currentIndex = end;
1741         }
1742         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1743     }
1744 
1745     /**
1746      * @dev Mints `quantity` tokens and transfers them to `to`.
1747      *
1748      * This function is intended for efficient minting only during contract creation.
1749      *
1750      * It emits only one {ConsecutiveTransfer} as defined in
1751      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1752      * instead of a sequence of {Transfer} event(s).
1753      *
1754      * Calling this function outside of contract creation WILL make your contract
1755      * non-compliant with the ERC721 standard.
1756      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1757      * {ConsecutiveTransfer} event is only permissible during contract creation.
1758      *
1759      * Requirements:
1760      *
1761      * - `to` cannot be the zero address.
1762      * - `quantity` must be greater than 0.
1763      *
1764      * Emits a {ConsecutiveTransfer} event.
1765      */
1766     function _mintERC2309(address to, uint256 quantity) internal virtual {
1767         uint256 startTokenId = _currentIndex;
1768         if (to == address(0)) revert MintToZeroAddress();
1769         if (quantity == 0) revert MintZeroQuantity();
1770         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1771 
1772         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1773 
1774         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1775         unchecked {
1776             // Updates:
1777             // - `balance += quantity`.
1778             // - `numberMinted += quantity`.
1779             //
1780             // We can directly add to the `balance` and `numberMinted`.
1781             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1782 
1783             // Updates:
1784             // - `address` to the owner.
1785             // - `startTimestamp` to the timestamp of minting.
1786             // - `burned` to `false`.
1787             // - `nextInitialized` to `quantity == 1`.
1788             _packedOwnerships[startTokenId] = _packOwnershipData(
1789                 to,
1790                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1791             );
1792 
1793             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1794 
1795             _currentIndex = startTokenId + quantity;
1796         }
1797         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1798     }
1799 
1800     /**
1801      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1802      *
1803      * Requirements:
1804      *
1805      * - If `to` refers to a smart contract, it must implement
1806      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1807      * - `quantity` must be greater than 0.
1808      *
1809      * See {_mint}.
1810      *
1811      * Emits a {Transfer} event for each mint.
1812      */
1813     function _safeMint(
1814         address to,
1815         uint256 quantity,
1816         bytes memory _data
1817     ) internal virtual {
1818         _mint(to, quantity);
1819 
1820         unchecked {
1821             if (to.code.length != 0) {
1822                 uint256 end = _currentIndex;
1823                 uint256 index = end - quantity;
1824                 do {
1825                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1826                         revert TransferToNonERC721ReceiverImplementer();
1827                     }
1828                 } while (index < end);
1829                 // Reentrancy protection.
1830                 if (_currentIndex != end) revert();
1831             }
1832         }
1833     }
1834 
1835     /**
1836      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1837      */
1838     function _safeMint(address to, uint256 quantity) internal virtual {
1839         _safeMint(to, quantity, '');
1840     }
1841 
1842     // =============================================================
1843     //                        BURN OPERATIONS
1844     // =============================================================
1845 
1846     /**
1847      * @dev Equivalent to `_burn(tokenId, false)`.
1848      */
1849     function _burn(uint256 tokenId) internal virtual {
1850         _burn(tokenId, false);
1851     }
1852 
1853     /**
1854      * @dev Destroys `tokenId`.
1855      * The approval is cleared when the token is burned.
1856      *
1857      * Requirements:
1858      *
1859      * - `tokenId` must exist.
1860      *
1861      * Emits a {Transfer} event.
1862      */
1863     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1864         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1865 
1866         address from = address(uint160(prevOwnershipPacked));
1867 
1868         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1869 
1870         if (approvalCheck) {
1871             // The nested ifs save around 20+ gas over a compound boolean condition.
1872             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1873                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1874         }
1875 
1876         _beforeTokenTransfers(from, address(0), tokenId, 1);
1877 
1878         // Clear approvals from the previous owner.
1879         assembly {
1880             if approvedAddress {
1881                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1882                 sstore(approvedAddressSlot, 0)
1883             }
1884         }
1885 
1886         // Underflow of the sender's balance is impossible because we check for
1887         // ownership above and the recipient's balance can't realistically overflow.
1888         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1889         unchecked {
1890             // Updates:
1891             // - `balance -= 1`.
1892             // - `numberBurned += 1`.
1893             //
1894             // We can directly decrement the balance, and increment the number burned.
1895             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1896             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1897 
1898             // Updates:
1899             // - `address` to the last owner.
1900             // - `startTimestamp` to the timestamp of burning.
1901             // - `burned` to `true`.
1902             // - `nextInitialized` to `true`.
1903             _packedOwnerships[tokenId] = _packOwnershipData(
1904                 from,
1905                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1906             );
1907 
1908             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1909             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1910                 uint256 nextTokenId = tokenId + 1;
1911                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1912                 if (_packedOwnerships[nextTokenId] == 0) {
1913                     // If the next slot is within bounds.
1914                     if (nextTokenId != _currentIndex) {
1915                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1916                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1917                     }
1918                 }
1919             }
1920         }
1921 
1922         emit Transfer(from, address(0), tokenId);
1923         _afterTokenTransfers(from, address(0), tokenId, 1);
1924 
1925         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1926         unchecked {
1927             _burnCounter++;
1928         }
1929     }
1930 
1931     // =============================================================
1932     //                     EXTRA DATA OPERATIONS
1933     // =============================================================
1934 
1935     /**
1936      * @dev Directly sets the extra data for the ownership data `index`.
1937      */
1938     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1939         uint256 packed = _packedOwnerships[index];
1940         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1941         uint256 extraDataCasted;
1942         // Cast `extraData` with assembly to avoid redundant masking.
1943         assembly {
1944             extraDataCasted := extraData
1945         }
1946         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1947         _packedOwnerships[index] = packed;
1948     }
1949 
1950     /**
1951      * @dev Called during each token transfer to set the 24bit `extraData` field.
1952      * Intended to be overridden by the cosumer contract.
1953      *
1954      * `previousExtraData` - the value of `extraData` before transfer.
1955      *
1956      * Calling conditions:
1957      *
1958      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1959      * transferred to `to`.
1960      * - When `from` is zero, `tokenId` will be minted for `to`.
1961      * - When `to` is zero, `tokenId` will be burned by `from`.
1962      * - `from` and `to` are never both zero.
1963      */
1964     function _extraData(
1965         address from,
1966         address to,
1967         uint24 previousExtraData
1968     ) internal view virtual returns (uint24) {}
1969 
1970     /**
1971      * @dev Returns the next extra data for the packed ownership data.
1972      * The returned result is shifted into position.
1973      */
1974     function _nextExtraData(
1975         address from,
1976         address to,
1977         uint256 prevOwnershipPacked
1978     ) private view returns (uint256) {
1979         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1980         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1981     }
1982 
1983     // =============================================================
1984     //                       OTHER OPERATIONS
1985     // =============================================================
1986 
1987     /**
1988      * @dev Returns the message sender (defaults to `msg.sender`).
1989      *
1990      * If you are writing GSN compatible contracts, you need to override this function.
1991      */
1992     function _msgSenderERC721A() internal view virtual returns (address) {
1993         return msg.sender;
1994     }
1995 
1996     /**
1997      * @dev Converts a uint256 to its ASCII string decimal representation.
1998      */
1999     function _toString(uint256 value) internal pure virtual returns (string memory ptr) {
2000         assembly {
2001             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
2002             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
2003             // We will need 1 32-byte word to store the length,
2004             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
2005             ptr := add(mload(0x40), 128)
2006             // Update the free memory pointer to allocate.
2007             mstore(0x40, ptr)
2008 
2009             // Cache the end of the memory to calculate the length later.
2010             let end := ptr
2011 
2012             // We write the string from the rightmost digit to the leftmost digit.
2013             // The following is essentially a do-while loop that also handles the zero case.
2014             // Costs a bit more than early returning for the zero case,
2015             // but cheaper in terms of deployment and overall runtime costs.
2016             for {
2017                 // Initialize and perform the first pass without check.
2018                 let temp := value
2019                 // Move the pointer 1 byte leftwards to point to an empty character slot.
2020                 ptr := sub(ptr, 1)
2021                 // Write the character to the pointer.
2022                 // The ASCII index of the '0' character is 48.
2023                 mstore8(ptr, add(48, mod(temp, 10)))
2024                 temp := div(temp, 10)
2025             } temp {
2026                 // Keep dividing `temp` until zero.
2027                 temp := div(temp, 10)
2028             } {
2029                 // Body of the for loop.
2030                 ptr := sub(ptr, 1)
2031                 mstore8(ptr, add(48, mod(temp, 10)))
2032             }
2033 
2034             let length := sub(end, ptr)
2035             // Move the pointer 32 bytes leftwards to make room for the length.
2036             ptr := sub(ptr, 32)
2037             // Store the length.
2038             mstore(ptr, length)
2039         }
2040     }
2041 }
2042 
2043 // File: contract.sol
2044 
2045 pragma solidity ^0.8.7;
2046 
2047 contract AIC_Operatives is ERC721A, Ownable {
2048     using Strings for uint256;
2049     using ECDSA for bytes32;
2050 
2051     string private baseURI = "https://gateway.pinata.cloud/ipfs/QmTp8nte7JnvQmxbESdLk3qhcCL5NViqZijKDXigdrxrvd/";
2052     string public privateSigWord = "AIC_GEN2_PRIVATE";
2053     uint256 public maxSaleSupply = 5486;
2054     uint256 public maxTeamSupply = 514;
2055     uint256 public privatePrice = 0.09 ether;
2056     uint256 public publicPrice = 0.11 ether;
2057     uint256 public maxMintsPerTx = 5;
2058     uint256 public mintedCounter;
2059     uint256 public teamMintedCounter;
2060     address public privateSigner = 0x89E331970dba855A8E5d86371C4c47bCf60aa4F5;
2061     bool public publicLive;
2062     bool public privateLive;
2063 
2064     mapping(address => uint256) public privateMinters;
2065 
2066     constructor() ERC721A("Operatives", "AICO") {}
2067 
2068     function _startTokenId() internal view virtual override(ERC721A) returns (uint256) {
2069         return 1;
2070     }
2071 
2072     modifier notContract() {
2073         require(
2074             (!_isContract(msg.sender)) && (msg.sender == tx.origin),
2075             "contract not allowed"
2076         );
2077         _;
2078     }
2079 
2080     function _isContract(address addr) internal view returns (bool) {
2081         uint256 size;
2082         assembly {
2083             size := extcodesize(addr)
2084         }
2085         return size > 0;
2086     }
2087 
2088     function matchAddresSigner(bytes memory signature, uint256 maxMints) private view returns (bool) {
2089         bytes32 hash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", keccak256(abi.encodePacked(msg.sender, privateSigWord, maxMints))));
2090         return privateSigner == hash.recover(signature);
2091     }
2092 
2093     function mint(uint256 tokenQuantity) external payable notContract {
2094         require(publicLive, "MINT_CLOSED");
2095         require(mintedCounter + tokenQuantity <= maxSaleSupply, "EXCEED_SALE_SUPPLY");
2096         require(tokenQuantity <= maxMintsPerTx, "EXCEED_PER_TX");
2097         require(publicPrice * tokenQuantity <= msg.value, "INSUFFICIENT_ETH");
2098 
2099         mintedCounter +=tokenQuantity;
2100         _mint(msg.sender, tokenQuantity);
2101     }
2102 
2103     function privateMint(uint256 tokenQuantity, bytes memory signature, uint256 maxMints) external payable notContract {
2104         require(privateLive, "MINT_CLOSED");
2105         require(mintedCounter + tokenQuantity <= maxSaleSupply, "EXCEED_SALE_SUPPLY");
2106         require(matchAddresSigner(signature, maxMints), "INVALID_SIGNATURE");
2107         require(privateMinters[msg.sender] + tokenQuantity <= maxMints, "EXCEED_PER_WALLET");
2108         require(privatePrice * tokenQuantity <= msg.value, "INSUFFICIENT_ETH");
2109 
2110         mintedCounter +=tokenQuantity;
2111         privateMinters[msg.sender] = privateMinters[msg.sender] + tokenQuantity;
2112         _mint(msg.sender, tokenQuantity);
2113     }
2114 
2115     function tokenURI(uint256 tokenId) public view override(ERC721A) returns (string memory) {
2116         require(_exists(tokenId), "Cannot query non-existent token");
2117         return string(abi.encodePacked(baseURI, tokenId.toString()));
2118     }
2119 
2120     function _baseURI() internal view virtual override returns (string memory) {
2121         return baseURI;
2122     }
2123 
2124     function gift(address[] calldata receivers) external onlyOwner {
2125         require(teamMintedCounter + receivers.length <= maxTeamSupply, "EXCEED_TEAM_SUPPLY");
2126         
2127         teamMintedCounter += receivers.length;
2128         for (uint256 i = 0; i < receivers.length; i++) {
2129             _mint(receivers[i], 1);
2130         }
2131     }
2132 
2133     function founderMint(uint256 tokenQuantity) external onlyOwner {
2134         require(teamMintedCounter + tokenQuantity <= maxTeamSupply, "EXCEED_TEAM_SUPPLY");
2135 
2136         teamMintedCounter += tokenQuantity;
2137         _mint(msg.sender, tokenQuantity);
2138     }
2139 
2140     function togglePublicStatus() external onlyOwner {
2141         publicLive = !publicLive;
2142     }
2143 
2144     function togglePrivateStatus() external onlyOwner {
2145         privateLive = !privateLive;
2146     }
2147 
2148     function setPublicPrice(uint256 newPrice) external onlyOwner {
2149         publicPrice = newPrice;
2150     }
2151 
2152     function setPrivatePrice(uint256 newPrice) external onlyOwner {
2153         privatePrice = newPrice;
2154     }
2155 
2156     function setMax(uint256 newCount) external onlyOwner {
2157         maxSaleSupply = newCount;
2158     }
2159 
2160     function setTeamMax(uint256 newCount) external onlyOwner {
2161         maxTeamSupply = newCount;
2162     }
2163 
2164     function setMaxPerTx(uint256 newCount) external onlyOwner {
2165         maxMintsPerTx = newCount;
2166     }
2167 
2168     function setSigner(address newAddress) external onlyOwner {
2169         privateSigner = newAddress;
2170     }
2171 
2172     function setBaseURI(string calldata newBaseURI) external onlyOwner {
2173         baseURI = newBaseURI;
2174     }
2175 
2176     function withdraw() external onlyOwner {
2177         uint256 currentBalance = address(this).balance;
2178         Address.sendValue(payable(0x00000040f69B8E3382734491cBAA241B6a863AB3), (currentBalance * 10) / 100);
2179         Address.sendValue(payable(0x773DAaCda9E4d7C7955BCef1fbF807D318501F44), (currentBalance * 10) / 100);
2180         Address.sendValue(payable(0x4c35286d99b5879c45538Da5f59588A601359e34), (currentBalance * 10) / 100);
2181         Address.sendValue(payable(0x3A7D619d3ED6Fb04799642f88BD3dFab63af0a83), (currentBalance * 10) / 100);
2182         Address.sendValue(payable(0xbF6c44be5AC250B30726E9405d4fD80Bd16A1ae2), (currentBalance * 8) / 100);
2183         Address.sendValue(payable(0x4D214C5Ea3ddE7E416e128E71a6A547E645e5d9b), (currentBalance * 6) / 100);
2184         Address.sendValue(payable(0xa642830cCe2e2741BB654B479DC1Dc33E910ae55), (currentBalance * 85) / 1000);
2185         Address.sendValue(payable(0xCa7987Dc570540F6045759e4207eDad2D4f04F82), (currentBalance * 85) / 1000);
2186         Address.sendValue(payable(0x3FD45f7fc6da24A360E75aFF9DE577ab5fbdcfE7), address(this).balance);    
2187     }
2188 
2189     receive() external payable {}
2190 }