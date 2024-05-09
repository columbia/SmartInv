1 /**
2  *Submitted for verification at Etherscan.io on 2022-05-09
3 */
4 
5 // File: @openzeppelin/contracts/utils/Strings.sol
6 
7 
8 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
9 
10 pragma solidity ^0.8.0;
11 
12 /**
13  * @dev String operations.
14  */
15 library Strings {
16     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
17 
18     /**
19      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
20      */
21     function toString(uint256 value) internal pure returns (string memory) {
22         // Inspired by OraclizeAPI's implementation - MIT licence
23         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
24 
25         if (value == 0) {
26             return "0";
27         }
28         uint256 temp = value;
29         uint256 digits;
30         while (temp != 0) {
31             digits++;
32             temp /= 10;
33         }
34         bytes memory buffer = new bytes(digits);
35         while (value != 0) {
36             digits -= 1;
37             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
38             value /= 10;
39         }
40         return string(buffer);
41     }
42 
43     /**
44      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
45      */
46     function toHexString(uint256 value) internal pure returns (string memory) {
47         if (value == 0) {
48             return "0x00";
49         }
50         uint256 temp = value;
51         uint256 length = 0;
52         while (temp != 0) {
53             length++;
54             temp >>= 8;
55         }
56         return toHexString(value, length);
57     }
58 
59     /**
60      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
61      */
62     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
63         bytes memory buffer = new bytes(2 * length + 2);
64         buffer[0] = "0";
65         buffer[1] = "x";
66         for (uint256 i = 2 * length + 1; i > 1; --i) {
67             buffer[i] = _HEX_SYMBOLS[value & 0xf];
68             value >>= 4;
69         }
70         require(value == 0, "Strings: hex length insufficient");
71         return string(buffer);
72     }
73 }
74 
75 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
76 
77 
78 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/ECDSA.sol)
79 
80 pragma solidity ^0.8.0;
81 
82 
83 /**
84  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
85  *
86  * These functions can be used to verify that a message was signed by the holder
87  * of the private keys of a given address.
88  */
89 library ECDSA {
90     enum RecoverError {
91         NoError,
92         InvalidSignature,
93         InvalidSignatureLength,
94         InvalidSignatureS,
95         InvalidSignatureV
96     }
97 
98     function _throwError(RecoverError error) private pure {
99         if (error == RecoverError.NoError) {
100             return; // no error: do nothing
101         } else if (error == RecoverError.InvalidSignature) {
102             revert("ECDSA: invalid signature");
103         } else if (error == RecoverError.InvalidSignatureLength) {
104             revert("ECDSA: invalid signature length");
105         } else if (error == RecoverError.InvalidSignatureS) {
106             revert("ECDSA: invalid signature 's' value");
107         } else if (error == RecoverError.InvalidSignatureV) {
108             revert("ECDSA: invalid signature 'v' value");
109         }
110     }
111 
112     /**
113      * @dev Returns the address that signed a hashed message (`hash`) with
114      * `signature` or error string. This address can then be used for verification purposes.
115      *
116      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
117      * this function rejects them by requiring the `s` value to be in the lower
118      * half order, and the `v` value to be either 27 or 28.
119      *
120      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
121      * verification to be secure: it is possible to craft signatures that
122      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
123      * this is by receiving a hash of the original message (which may otherwise
124      * be too long), and then calling {toEthSignedMessageHash} on it.
125      *
126      * Documentation for signature generation:
127      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
128      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
129      *
130      * _Available since v4.3._
131      */
132     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
133         // Check the signature length
134         // - case 65: r,s,v signature (standard)
135         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
136         if (signature.length == 65) {
137             bytes32 r;
138             bytes32 s;
139             uint8 v;
140             // ecrecover takes the signature parameters, and the only way to get them
141             // currently is to use assembly.
142             assembly {
143                 r := mload(add(signature, 0x20))
144                 s := mload(add(signature, 0x40))
145                 v := byte(0, mload(add(signature, 0x60)))
146             }
147             return tryRecover(hash, v, r, s);
148         } else if (signature.length == 64) {
149             bytes32 r;
150             bytes32 vs;
151             // ecrecover takes the signature parameters, and the only way to get them
152             // currently is to use assembly.
153             assembly {
154                 r := mload(add(signature, 0x20))
155                 vs := mload(add(signature, 0x40))
156             }
157             return tryRecover(hash, r, vs);
158         } else {
159             return (address(0), RecoverError.InvalidSignatureLength);
160         }
161     }
162 
163     /**
164      * @dev Returns the address that signed a hashed message (`hash`) with
165      * `signature`. This address can then be used for verification purposes.
166      *
167      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
168      * this function rejects them by requiring the `s` value to be in the lower
169      * half order, and the `v` value to be either 27 or 28.
170      *
171      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
172      * verification to be secure: it is possible to craft signatures that
173      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
174      * this is by receiving a hash of the original message (which may otherwise
175      * be too long), and then calling {toEthSignedMessageHash} on it.
176      */
177     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
178         (address recovered, RecoverError error) = tryRecover(hash, signature);
179         _throwError(error);
180         return recovered;
181     }
182 
183     /**
184      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
185      *
186      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
187      *
188      * _Available since v4.3._
189      */
190     function tryRecover(
191         bytes32 hash,
192         bytes32 r,
193         bytes32 vs
194     ) internal pure returns (address, RecoverError) {
195         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
196         uint8 v = uint8((uint256(vs) >> 255) + 27);
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
307 // File: @openzeppelin/contracts/utils/Context.sol
308 
309 
310 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
311 
312 pragma solidity ^0.8.0;
313 
314 /**
315  * @dev Provides information about the current execution context, including the
316  * sender of the transaction and its data. While these are generally available
317  * via msg.sender and msg.data, they should not be accessed in such a direct
318  * manner, since when dealing with meta-transactions the account sending and
319  * paying for execution may not be the actual sender (as far as an application
320  * is concerned).
321  *
322  * This contract is only required for intermediate, library-like contracts.
323  */
324 abstract contract Context {
325     function _msgSender() internal view virtual returns (address) {
326         return msg.sender;
327     }
328 
329     function _msgData() internal view virtual returns (bytes calldata) {
330         return msg.data;
331     }
332 }
333 
334 // File: @openzeppelin/contracts/access/Ownable.sol
335 
336 
337 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
338 
339 pragma solidity ^0.8.0;
340 
341 
342 /**
343  * @dev Contract module which provides a basic access control mechanism, where
344  * there is an account (an owner) that can be granted exclusive access to
345  * specific functions.
346  *
347  * By default, the owner account will be the one that deploys the contract. This
348  * can later be changed with {transferOwnership}.
349  *
350  * This module is used through inheritance. It will make available the modifier
351  * `onlyOwner`, which can be applied to your functions to restrict their use to
352  * the owner.
353  */
354 abstract contract Ownable is Context {
355     address private _owner;
356 
357     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
358 
359     /**
360      * @dev Initializes the contract setting the deployer as the initial owner.
361      */
362     constructor() {
363         _transferOwnership(_msgSender());
364     }
365 
366     /**
367      * @dev Returns the address of the current owner.
368      */
369     function owner() public view virtual returns (address) {
370         return _owner;
371     }
372 
373     /**
374      * @dev Throws if called by any account other than the owner.
375      */
376     modifier onlyOwner() {
377         require(owner() == _msgSender(), "Ownable: caller is not the owner");
378         _;
379     }
380 
381     /**
382      * @dev Leaves the contract without owner. It will not be possible to call
383      * `onlyOwner` functions anymore. Can only be called by the current owner.
384      *
385      * NOTE: Renouncing ownership will leave the contract without an owner,
386      * thereby removing any functionality that is only available to the owner.
387      */
388     function renounceOwnership() public virtual onlyOwner {
389         _transferOwnership(address(0));
390     }
391 
392     /**
393      * @dev Transfers ownership of the contract to a new account (`newOwner`).
394      * Can only be called by the current owner.
395      */
396     function transferOwnership(address newOwner) public virtual onlyOwner {
397         require(newOwner != address(0), "Ownable: new owner is the zero address");
398         _transferOwnership(newOwner);
399     }
400 
401     /**
402      * @dev Transfers ownership of the contract to a new account (`newOwner`).
403      * Internal function without access restriction.
404      */
405     function _transferOwnership(address newOwner) internal virtual {
406         address oldOwner = _owner;
407         _owner = newOwner;
408         emit OwnershipTransferred(oldOwner, newOwner);
409     }
410 }
411 
412 // File: @openzeppelin/contracts/utils/Address.sol
413 
414 
415 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
416 
417 pragma solidity ^0.8.1;
418 
419 /**
420  * @dev Collection of functions related to the address type
421  */
422 library Address {
423     /**
424      * @dev Returns true if `account` is a contract.
425      *
426      * [IMPORTANT]
427      * ====
428      * It is unsafe to assume that an address for which this function returns
429      * false is an externally-owned account (EOA) and not a contract.
430      *
431      * Among others, `isContract` will return false for the following
432      * types of addresses:
433      *
434      *  - an externally-owned account
435      *  - a contract in construction
436      *  - an address where a contract will be created
437      *  - an address where a contract lived, but was destroyed
438      * ====
439      *
440      * [IMPORTANT]
441      * ====
442      * You shouldn't rely on `isContract` to protect against flash loan attacks!
443      *
444      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
445      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
446      * constructor.
447      * ====
448      */
449     function isContract(address account) internal view returns (bool) {
450         // This method relies on extcodesize/address.code.length, which returns 0
451         // for contracts in construction, since the code is only stored at the end
452         // of the constructor execution.
453 
454         return account.code.length > 0;
455     }
456 
457     /**
458      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
459      * `recipient`, forwarding all available gas and reverting on errors.
460      *
461      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
462      * of certain opcodes, possibly making contracts go over the 2300 gas limit
463      * imposed by `transfer`, making them unable to receive funds via
464      * `transfer`. {sendValue} removes this limitation.
465      *
466      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
467      *
468      * IMPORTANT: because control is transferred to `recipient`, care must be
469      * taken to not create reentrancy vulnerabilities. Consider using
470      * {ReentrancyGuard} or the
471      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
472      */
473     function sendValue(address payable recipient, uint256 amount) internal {
474         require(address(this).balance >= amount, "Address: insufficient balance");
475 
476         (bool success, ) = recipient.call{value: amount}("");
477         require(success, "Address: unable to send value, recipient may have reverted");
478     }
479 
480     /**
481      * @dev Performs a Solidity function call using a low level `call`. A
482      * plain `call` is an unsafe replacement for a function call: use this
483      * function instead.
484      *
485      * If `target` reverts with a revert reason, it is bubbled up by this
486      * function (like regular Solidity function calls).
487      *
488      * Returns the raw returned data. To convert to the expected return value,
489      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
490      *
491      * Requirements:
492      *
493      * - `target` must be a contract.
494      * - calling `target` with `data` must not revert.
495      *
496      * _Available since v3.1._
497      */
498     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
499         return functionCall(target, data, "Address: low-level call failed");
500     }
501 
502     /**
503      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
504      * `errorMessage` as a fallback revert reason when `target` reverts.
505      *
506      * _Available since v3.1._
507      */
508     function functionCall(
509         address target,
510         bytes memory data,
511         string memory errorMessage
512     ) internal returns (bytes memory) {
513         return functionCallWithValue(target, data, 0, errorMessage);
514     }
515 
516     /**
517      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
518      * but also transferring `value` wei to `target`.
519      *
520      * Requirements:
521      *
522      * - the calling contract must have an ETH balance of at least `value`.
523      * - the called Solidity function must be `payable`.
524      *
525      * _Available since v3.1._
526      */
527     function functionCallWithValue(
528         address target,
529         bytes memory data,
530         uint256 value
531     ) internal returns (bytes memory) {
532         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
533     }
534 
535     /**
536      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
537      * with `errorMessage` as a fallback revert reason when `target` reverts.
538      *
539      * _Available since v3.1._
540      */
541     function functionCallWithValue(
542         address target,
543         bytes memory data,
544         uint256 value,
545         string memory errorMessage
546     ) internal returns (bytes memory) {
547         require(address(this).balance >= value, "Address: insufficient balance for call");
548         require(isContract(target), "Address: call to non-contract");
549 
550         (bool success, bytes memory returndata) = target.call{value: value}(data);
551         return verifyCallResult(success, returndata, errorMessage);
552     }
553 
554     /**
555      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
556      * but performing a static call.
557      *
558      * _Available since v3.3._
559      */
560     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
561         return functionStaticCall(target, data, "Address: low-level static call failed");
562     }
563 
564     /**
565      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
566      * but performing a static call.
567      *
568      * _Available since v3.3._
569      */
570     function functionStaticCall(
571         address target,
572         bytes memory data,
573         string memory errorMessage
574     ) internal view returns (bytes memory) {
575         require(isContract(target), "Address: static call to non-contract");
576 
577         (bool success, bytes memory returndata) = target.staticcall(data);
578         return verifyCallResult(success, returndata, errorMessage);
579     }
580 
581     /**
582      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
583      * but performing a delegate call.
584      *
585      * _Available since v3.4._
586      */
587     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
588         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
589     }
590 
591     /**
592      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
593      * but performing a delegate call.
594      *
595      * _Available since v3.4._
596      */
597     function functionDelegateCall(
598         address target,
599         bytes memory data,
600         string memory errorMessage
601     ) internal returns (bytes memory) {
602         require(isContract(target), "Address: delegate call to non-contract");
603 
604         (bool success, bytes memory returndata) = target.delegatecall(data);
605         return verifyCallResult(success, returndata, errorMessage);
606     }
607 
608     /**
609      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
610      * revert reason using the provided one.
611      *
612      * _Available since v4.3._
613      */
614     function verifyCallResult(
615         bool success,
616         bytes memory returndata,
617         string memory errorMessage
618     ) internal pure returns (bytes memory) {
619         if (success) {
620             return returndata;
621         } else {
622             // Look for revert reason and bubble it up if present
623             if (returndata.length > 0) {
624                 // The easiest way to bubble the revert reason is using memory via assembly
625 
626                 assembly {
627                     let returndata_size := mload(returndata)
628                     revert(add(32, returndata), returndata_size)
629                 }
630             } else {
631                 revert(errorMessage);
632             }
633         }
634     }
635 }
636 
637 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
638 
639 
640 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
641 
642 pragma solidity ^0.8.0;
643 
644 /**
645  * @title ERC721 token receiver interface
646  * @dev Interface for any contract that wants to support safeTransfers
647  * from ERC721 asset contracts.
648  */
649 interface IERC721Receiver {
650     /**
651      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
652      * by `operator` from `from`, this function is called.
653      *
654      * It must return its Solidity selector to confirm the token transfer.
655      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
656      *
657      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
658      */
659     function onERC721Received(
660         address operator,
661         address from,
662         uint256 tokenId,
663         bytes calldata data
664     ) external returns (bytes4);
665 }
666 
667 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
668 
669 
670 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
671 
672 pragma solidity ^0.8.0;
673 
674 /**
675  * @dev Interface of the ERC165 standard, as defined in the
676  * https://eips.ethereum.org/EIPS/eip-165[EIP].
677  *
678  * Implementers can declare support of contract interfaces, which can then be
679  * queried by others ({ERC165Checker}).
680  *
681  * For an implementation, see {ERC165}.
682  */
683 interface IERC165 {
684     /**
685      * @dev Returns true if this contract implements the interface defined by
686      * `interfaceId`. See the corresponding
687      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
688      * to learn more about how these ids are created.
689      *
690      * This function call must use less than 30 000 gas.
691      */
692     function supportsInterface(bytes4 interfaceId) external view returns (bool);
693 }
694 
695 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
696 
697 
698 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
699 
700 pragma solidity ^0.8.0;
701 
702 
703 /**
704  * @dev Implementation of the {IERC165} interface.
705  *
706  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
707  * for the additional interface id that will be supported. For example:
708  *
709  * ```solidity
710  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
711  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
712  * }
713  * ```
714  *
715  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
716  */
717 abstract contract ERC165 is IERC165 {
718     /**
719      * @dev See {IERC165-supportsInterface}.
720      */
721     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
722         return interfaceId == type(IERC165).interfaceId;
723     }
724 }
725 
726 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
727 
728 
729 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
730 
731 pragma solidity ^0.8.0;
732 
733 
734 /**
735  * @dev Required interface of an ERC721 compliant contract.
736  */
737 interface IERC721 is IERC165 {
738     /**
739      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
740      */
741     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
742 
743     /**
744      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
745      */
746     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
747 
748     /**
749      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
750      */
751     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
752 
753     /**
754      * @dev Returns the number of tokens in ``owner``'s account.
755      */
756     function balanceOf(address owner) external view returns (uint256 balance);
757 
758     /**
759      * @dev Returns the owner of the `tokenId` token.
760      *
761      * Requirements:
762      *
763      * - `tokenId` must exist.
764      */
765     function ownerOf(uint256 tokenId) external view returns (address owner);
766 
767     /**
768      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
769      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
770      *
771      * Requirements:
772      *
773      * - `from` cannot be the zero address.
774      * - `to` cannot be the zero address.
775      * - `tokenId` token must exist and be owned by `from`.
776      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
777      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
778      *
779      * Emits a {Transfer} event.
780      */
781     function safeTransferFrom(
782         address from,
783         address to,
784         uint256 tokenId
785     ) external;
786 
787     /**
788      * @dev Transfers `tokenId` token from `from` to `to`.
789      *
790      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
791      *
792      * Requirements:
793      *
794      * - `from` cannot be the zero address.
795      * - `to` cannot be the zero address.
796      * - `tokenId` token must be owned by `from`.
797      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
798      *
799      * Emits a {Transfer} event.
800      */
801     function transferFrom(
802         address from,
803         address to,
804         uint256 tokenId
805     ) external;
806 
807     /**
808      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
809      * The approval is cleared when the token is transferred.
810      *
811      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
812      *
813      * Requirements:
814      *
815      * - The caller must own the token or be an approved operator.
816      * - `tokenId` must exist.
817      *
818      * Emits an {Approval} event.
819      */
820     function approve(address to, uint256 tokenId) external;
821 
822     /**
823      * @dev Returns the account approved for `tokenId` token.
824      *
825      * Requirements:
826      *
827      * - `tokenId` must exist.
828      */
829     function getApproved(uint256 tokenId) external view returns (address operator);
830 
831     /**
832      * @dev Approve or remove `operator` as an operator for the caller.
833      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
834      *
835      * Requirements:
836      *
837      * - The `operator` cannot be the caller.
838      *
839      * Emits an {ApprovalForAll} event.
840      */
841     function setApprovalForAll(address operator, bool _approved) external;
842 
843     /**
844      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
845      *
846      * See {setApprovalForAll}
847      */
848     function isApprovedForAll(address owner, address operator) external view returns (bool);
849 
850     /**
851      * @dev Safely transfers `tokenId` token from `from` to `to`.
852      *
853      * Requirements:
854      *
855      * - `from` cannot be the zero address.
856      * - `to` cannot be the zero address.
857      * - `tokenId` token must exist and be owned by `from`.
858      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
859      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
860      *
861      * Emits a {Transfer} event.
862      */
863     function safeTransferFrom(
864         address from,
865         address to,
866         uint256 tokenId,
867         bytes calldata data
868     ) external;
869 }
870 
871 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
872 
873 
874 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
875 
876 pragma solidity ^0.8.0;
877 
878 
879 /**
880  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
881  * @dev See https://eips.ethereum.org/EIPS/eip-721
882  */
883 interface IERC721Enumerable is IERC721 {
884     /**
885      * @dev Returns the total amount of tokens stored by the contract.
886      */
887     function totalSupply() external view returns (uint256);
888 
889     /**
890      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
891      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
892      */
893     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
894 
895     /**
896      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
897      * Use along with {totalSupply} to enumerate all tokens.
898      */
899     function tokenByIndex(uint256 index) external view returns (uint256);
900 }
901 
902 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
903 
904 
905 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
906 
907 pragma solidity ^0.8.0;
908 
909 
910 /**
911  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
912  * @dev See https://eips.ethereum.org/EIPS/eip-721
913  */
914 interface IERC721Metadata is IERC721 {
915     /**
916      * @dev Returns the token collection name.
917      */
918     function name() external view returns (string memory);
919 
920     /**
921      * @dev Returns the token collection symbol.
922      */
923     function symbol() external view returns (string memory);
924 
925     /**
926      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
927      */
928     function tokenURI(uint256 tokenId) external view returns (string memory);
929 }
930 
931 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
932 
933 
934 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
935 
936 pragma solidity ^0.8.0;
937 
938 
939 
940 
941 
942 
943 
944 
945 /**
946  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
947  * the Metadata extension, but not including the Enumerable extension, which is available separately as
948  * {ERC721Enumerable}.
949  */
950 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
951     using Address for address;
952     using Strings for uint256;
953 
954     // Token name
955     string private _name;
956 
957     // Token symbol
958     string private _symbol;
959 
960     // Mapping from token ID to owner address
961     mapping(uint256 => address) private _owners;
962 
963     // Mapping owner address to token count
964     mapping(address => uint256) private _balances;
965 
966     // Mapping from token ID to approved address
967     mapping(uint256 => address) private _tokenApprovals;
968 
969     // Mapping from owner to operator approvals
970     mapping(address => mapping(address => bool)) private _operatorApprovals;
971 
972     /**
973      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
974      */
975     constructor(string memory name_, string memory symbol_) {
976         _name = name_;
977         _symbol = symbol_;
978     }
979 
980     /**
981      * @dev See {IERC165-supportsInterface}.
982      */
983     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
984         return
985             interfaceId == type(IERC721).interfaceId ||
986             interfaceId == type(IERC721Metadata).interfaceId ||
987             super.supportsInterface(interfaceId);
988     }
989 
990     /**
991      * @dev See {IERC721-balanceOf}.
992      */
993     function balanceOf(address owner) public view virtual override returns (uint256) {
994         require(owner != address(0), "ERC721: balance query for the zero address");
995         return _balances[owner];
996     }
997 
998     /**
999      * @dev See {IERC721-ownerOf}.
1000      */
1001     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1002         address owner = _owners[tokenId];
1003         require(owner != address(0), "ERC721: owner query for nonexistent token");
1004         return owner;
1005     }
1006 
1007     /**
1008      * @dev See {IERC721Metadata-name}.
1009      */
1010     function name() public view virtual override returns (string memory) {
1011         return _name;
1012     }
1013 
1014     /**
1015      * @dev See {IERC721Metadata-symbol}.
1016      */
1017     function symbol() public view virtual override returns (string memory) {
1018         return _symbol;
1019     }
1020 
1021     /**
1022      * @dev See {IERC721Metadata-tokenURI}.
1023      */
1024     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1025         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1026 
1027         string memory baseURI = _baseURI();
1028         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1029     }
1030 
1031     /**
1032      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1033      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1034      * by default, can be overriden in child contracts.
1035      */
1036     function _baseURI() internal view virtual returns (string memory) {
1037         return "";
1038     }
1039 
1040     /**
1041      * @dev See {IERC721-approve}.
1042      */
1043     function approve(address to, uint256 tokenId) public virtual override {
1044         address owner = ERC721.ownerOf(tokenId);
1045         require(to != owner, "ERC721: approval to current owner");
1046 
1047         require(
1048             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1049             "ERC721: approve caller is not owner nor approved for all"
1050         );
1051 
1052         _approve(to, tokenId);
1053     }
1054 
1055     /**
1056      * @dev See {IERC721-getApproved}.
1057      */
1058     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1059         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1060 
1061         return _tokenApprovals[tokenId];
1062     }
1063 
1064     /**
1065      * @dev See {IERC721-setApprovalForAll}.
1066      */
1067     function setApprovalForAll(address operator, bool approved) public virtual override {
1068         _setApprovalForAll(_msgSender(), operator, approved);
1069     }
1070 
1071     /**
1072      * @dev See {IERC721-isApprovedForAll}.
1073      */
1074     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1075         return _operatorApprovals[owner][operator];
1076     }
1077 
1078     /**
1079      * @dev See {IERC721-transferFrom}.
1080      */
1081     function transferFrom(
1082         address from,
1083         address to,
1084         uint256 tokenId
1085     ) public virtual override {
1086         //solhint-disable-next-line max-line-length
1087         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1088 
1089         _transfer(from, to, tokenId);
1090     }
1091 
1092     /**
1093      * @dev See {IERC721-safeTransferFrom}.
1094      */
1095     function safeTransferFrom(
1096         address from,
1097         address to,
1098         uint256 tokenId
1099     ) public virtual override {
1100         safeTransferFrom(from, to, tokenId, "");
1101     }
1102 
1103     /**
1104      * @dev See {IERC721-safeTransferFrom}.
1105      */
1106     function safeTransferFrom(
1107         address from,
1108         address to,
1109         uint256 tokenId,
1110         bytes memory _data
1111     ) public virtual override {
1112         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1113         _safeTransfer(from, to, tokenId, _data);
1114     }
1115 
1116     /**
1117      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1118      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1119      *
1120      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1121      *
1122      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1123      * implement alternative mechanisms to perform token transfer, such as signature-based.
1124      *
1125      * Requirements:
1126      *
1127      * - `from` cannot be the zero address.
1128      * - `to` cannot be the zero address.
1129      * - `tokenId` token must exist and be owned by `from`.
1130      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1131      *
1132      * Emits a {Transfer} event.
1133      */
1134     function _safeTransfer(
1135         address from,
1136         address to,
1137         uint256 tokenId,
1138         bytes memory _data
1139     ) internal virtual {
1140         _transfer(from, to, tokenId);
1141         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1142     }
1143 
1144     /**
1145      * @dev Returns whether `tokenId` exists.
1146      *
1147      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1148      *
1149      * Tokens start existing when they are minted (`_mint`),
1150      * and stop existing when they are burned (`_burn`).
1151      */
1152     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1153         return _owners[tokenId] != address(0);
1154     }
1155 
1156     /**
1157      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1158      *
1159      * Requirements:
1160      *
1161      * - `tokenId` must exist.
1162      */
1163     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1164         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1165         address owner = ERC721.ownerOf(tokenId);
1166         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1167     }
1168 
1169     /**
1170      * @dev Safely mints `tokenId` and transfers it to `to`.
1171      *
1172      * Requirements:
1173      *
1174      * - `tokenId` must not exist.
1175      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1176      *
1177      * Emits a {Transfer} event.
1178      */
1179     function _safeMint(address to, uint256 tokenId) internal virtual {
1180         _safeMint(to, tokenId, "");
1181     }
1182 
1183     /**
1184      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1185      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1186      */
1187     function _safeMint(
1188         address to,
1189         uint256 tokenId,
1190         bytes memory _data
1191     ) internal virtual {
1192         _mint(to, tokenId);
1193         require(
1194             _checkOnERC721Received(address(0), to, tokenId, _data),
1195             "ERC721: transfer to non ERC721Receiver implementer"
1196         );
1197     }
1198 
1199     /**
1200      * @dev Mints `tokenId` and transfers it to `to`.
1201      *
1202      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1203      *
1204      * Requirements:
1205      *
1206      * - `tokenId` must not exist.
1207      * - `to` cannot be the zero address.
1208      *
1209      * Emits a {Transfer} event.
1210      */
1211     function _mint(address to, uint256 tokenId) internal virtual {
1212         require(to != address(0), "ERC721: mint to the zero address");
1213         require(!_exists(tokenId), "ERC721: token already minted");
1214 
1215         _beforeTokenTransfer(address(0), to, tokenId);
1216 
1217         _balances[to] += 1;
1218         _owners[tokenId] = to;
1219 
1220         emit Transfer(address(0), to, tokenId);
1221 
1222         _afterTokenTransfer(address(0), to, tokenId);
1223     }
1224 
1225     /**
1226      * @dev Destroys `tokenId`.
1227      * The approval is cleared when the token is burned.
1228      *
1229      * Requirements:
1230      *
1231      * - `tokenId` must exist.
1232      *
1233      * Emits a {Transfer} event.
1234      */
1235     function _burn(uint256 tokenId) internal virtual {
1236         address owner = ERC721.ownerOf(tokenId);
1237 
1238         _beforeTokenTransfer(owner, address(0), tokenId);
1239 
1240         // Clear approvals
1241         _approve(address(0), tokenId);
1242 
1243         _balances[owner] -= 1;
1244         delete _owners[tokenId];
1245 
1246         emit Transfer(owner, address(0), tokenId);
1247 
1248         _afterTokenTransfer(owner, address(0), tokenId);
1249     }
1250 
1251     /**
1252      * @dev Transfers `tokenId` from `from` to `to`.
1253      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1254      *
1255      * Requirements:
1256      *
1257      * - `to` cannot be the zero address.
1258      * - `tokenId` token must be owned by `from`.
1259      *
1260      * Emits a {Transfer} event.
1261      */
1262     function _transfer(
1263         address from,
1264         address to,
1265         uint256 tokenId
1266     ) internal virtual {
1267         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1268         require(to != address(0), "ERC721: transfer to the zero address");
1269 
1270         _beforeTokenTransfer(from, to, tokenId);
1271 
1272         // Clear approvals from the previous owner
1273         _approve(address(0), tokenId);
1274 
1275         _balances[from] -= 1;
1276         _balances[to] += 1;
1277         _owners[tokenId] = to;
1278 
1279         emit Transfer(from, to, tokenId);
1280 
1281         _afterTokenTransfer(from, to, tokenId);
1282     }
1283 
1284     /**
1285      * @dev Approve `to` to operate on `tokenId`
1286      *
1287      * Emits a {Approval} event.
1288      */
1289     function _approve(address to, uint256 tokenId) internal virtual {
1290         _tokenApprovals[tokenId] = to;
1291         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1292     }
1293 
1294     /**
1295      * @dev Approve `operator` to operate on all of `owner` tokens
1296      *
1297      * Emits a {ApprovalForAll} event.
1298      */
1299     function _setApprovalForAll(
1300         address owner,
1301         address operator,
1302         bool approved
1303     ) internal virtual {
1304         require(owner != operator, "ERC721: approve to caller");
1305         _operatorApprovals[owner][operator] = approved;
1306         emit ApprovalForAll(owner, operator, approved);
1307     }
1308 
1309     /**
1310      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1311      * The call is not executed if the target address is not a contract.
1312      *
1313      * @param from address representing the previous owner of the given token ID
1314      * @param to target address that will receive the tokens
1315      * @param tokenId uint256 ID of the token to be transferred
1316      * @param _data bytes optional data to send along with the call
1317      * @return bool whether the call correctly returned the expected magic value
1318      */
1319     function _checkOnERC721Received(
1320         address from,
1321         address to,
1322         uint256 tokenId,
1323         bytes memory _data
1324     ) private returns (bool) {
1325         if (to.isContract()) {
1326             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1327                 return retval == IERC721Receiver.onERC721Received.selector;
1328             } catch (bytes memory reason) {
1329                 if (reason.length == 0) {
1330                     revert("ERC721: transfer to non ERC721Receiver implementer");
1331                 } else {
1332                     assembly {
1333                         revert(add(32, reason), mload(reason))
1334                     }
1335                 }
1336             }
1337         } else {
1338             return true;
1339         }
1340     }
1341 
1342     /**
1343      * @dev Hook that is called before any token transfer. This includes minting
1344      * and burning.
1345      *
1346      * Calling conditions:
1347      *
1348      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1349      * transferred to `to`.
1350      * - When `from` is zero, `tokenId` will be minted for `to`.
1351      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1352      * - `from` and `to` are never both zero.
1353      *
1354      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1355      */
1356     function _beforeTokenTransfer(
1357         address from,
1358         address to,
1359         uint256 tokenId
1360     ) internal virtual {}
1361 
1362     /**
1363      * @dev Hook that is called after any transfer of tokens. This includes
1364      * minting and burning.
1365      *
1366      * Calling conditions:
1367      *
1368      * - when `from` and `to` are both non-zero.
1369      * - `from` and `to` are never both zero.
1370      *
1371      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1372      */
1373     function _afterTokenTransfer(
1374         address from,
1375         address to,
1376         uint256 tokenId
1377     ) internal virtual {}
1378 }
1379 
1380 pragma solidity ^0.8.4;
1381 
1382 interface ISomething {
1383   function ownerOf(uint256 tokenId) external returns (address);
1384 }
1385 
1386 contract ItsSomething is ERC721, Ownable {
1387   using ECDSA for bytes32;
1388 
1389   // Addresses
1390   address public _nothingNftAddress;
1391   address public _systemAddress = address(0);
1392 
1393   uint256 public _startingTokenId = 1;
1394 
1395   // Token mint values
1396   uint256 public constant MAX_TOKEN_SUPPLY = 8888;
1397  
1398   uint256 public _price = 0.0 ether;
1399 
1400  bool public _claimsPaused = true;
1401  string public _baseTokenURI;
1402 
1403   // Tracks if address has minted
1404   mapping(address => bool) public _minted;
1405 
1406   constructor() ERC721("SOMETHING", "OBJECT") {
1407 
1408   }
1409 
1410   function mintSomething(uint256[] memory tokenIds) external {
1411     require(msg.sender == tx.origin, "No bots allowed");
1412     require(!_claimsPaused, "Minting paused");
1413 
1414     ISomething something = ISomething(_nothingNftAddress);
1415 
1416     bool success;
1417     for (uint256 i; i < tokenIds.length; i++) {
1418       uint256 nothingId = tokenIds[i];
1419 
1420       if (something.ownerOf(nothingId) == msg.sender && !_exists(nothingId)) {
1421         _mint(msg.sender, nothingId);
1422         success = true;
1423       }
1424     }
1425   }
1426 
1427   /// @notice Minting pause
1428   /// @param val True or false
1429   function pauseClaim(bool val) external onlyOwner {
1430     _claimsPaused = val;
1431   }
1432 
1433   /// @notice Set baseURI
1434   /// @param baseURI URI of the IPFS image server
1435   function setBaseURI(string memory baseURI) external onlyOwner {
1436     _baseTokenURI = baseURI;
1437   }
1438 
1439   /// @notice Get uri of tokens
1440   /// @return string Uri
1441   function _baseURI() internal view virtual override returns (string memory) {
1442     return _baseTokenURI;
1443   }
1444 
1445   /// @notice Set the system address
1446   /// @param systemAddress Address to set as systemAddress
1447   function setSystemAddress(address systemAddress) external onlyOwner {
1448     _systemAddress = systemAddress;
1449   }
1450 
1451   /// @notice Set the Nothing NFT contract address
1452   /// @param nothingNftAddress Address of the nothing nft contract
1453   function setNothingNftAddress(address nothingNftAddress) external onlyOwner {
1454     _nothingNftAddress = nothingNftAddress;
1455   }
1456 
1457   /// @notice Verify hashed data
1458   /// param hash Hashed data bundle
1459   /// @param signature Signature to check hash against
1460   /// @return bool Is verified or not
1461   function _isValidSignature(bytes32 hash, bytes memory signature) internal view returns (bool) {
1462     require(_systemAddress != address(0), "Invalid system address");
1463     bytes32 signedHash = hash.toEthSignedMessageHash();
1464     return signedHash.recover(signature) == _systemAddress;
1465   }
1466 }