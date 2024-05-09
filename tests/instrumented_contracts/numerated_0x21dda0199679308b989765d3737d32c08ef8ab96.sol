1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
3 
4 
5 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev These functions deal with verification of Merkle Trees proofs.
11  *
12  * The proofs can be generated using the JavaScript library
13  * https://github.com/miguelmota/merkletreejs[merkletreejs].
14  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
15  *
16  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
17  */
18 library MerkleProof {
19     /**
20      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
21      * defined by `root`. For this, a `proof` must be provided, containing
22      * sibling hashes on the branch from the leaf to the root of the tree. Each
23      * pair of leaves and each pair of pre-images are assumed to be sorted.
24      */
25     function verify(
26         bytes32[] memory proof,
27         bytes32 root,
28         bytes32 leaf
29     ) internal pure returns (bool) {
30         return processProof(proof, leaf) == root;
31     }
32 
33     /**
34      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
35      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
36      * hash matches the root of the tree. When processing the proof, the pairs
37      * of leafs & pre-images are assumed to be sorted.
38      *
39      * _Available since v4.4._
40      */
41     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
42         bytes32 computedHash = leaf;
43         for (uint256 i = 0; i < proof.length; i++) {
44             bytes32 proofElement = proof[i];
45             if (computedHash <= proofElement) {
46                 // Hash(current computed hash + current element of the proof)
47                 computedHash = _efficientHash(computedHash, proofElement);
48             } else {
49                 // Hash(current element of the proof + current computed hash)
50                 computedHash = _efficientHash(proofElement, computedHash);
51             }
52         }
53         return computedHash;
54     }
55 
56     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
57         assembly {
58             mstore(0x00, a)
59             mstore(0x20, b)
60             value := keccak256(0x00, 0x40)
61         }
62     }
63 }
64 
65 // File: @openzeppelin/contracts/utils/Strings.sol
66 
67 
68 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
69 
70 pragma solidity ^0.8.0;
71 
72 /**
73  * @dev String operations.
74  */
75 library Strings {
76     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
77 
78     /**
79      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
80      */
81     function toString(uint256 value) internal pure returns (string memory) {
82         // Inspired by OraclizeAPI's implementation - MIT licence
83         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
84 
85         if (value == 0) {
86             return "0";
87         }
88         uint256 temp = value;
89         uint256 digits;
90         while (temp != 0) {
91             digits++;
92             temp /= 10;
93         }
94         bytes memory buffer = new bytes(digits);
95         while (value != 0) {
96             digits -= 1;
97             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
98             value /= 10;
99         }
100         return string(buffer);
101     }
102 
103     /**
104      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
105      */
106     function toHexString(uint256 value) internal pure returns (string memory) {
107         if (value == 0) {
108             return "0x00";
109         }
110         uint256 temp = value;
111         uint256 length = 0;
112         while (temp != 0) {
113             length++;
114             temp >>= 8;
115         }
116         return toHexString(value, length);
117     }
118 
119     /**
120      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
121      */
122     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
123         bytes memory buffer = new bytes(2 * length + 2);
124         buffer[0] = "0";
125         buffer[1] = "x";
126         for (uint256 i = 2 * length + 1; i > 1; --i) {
127             buffer[i] = _HEX_SYMBOLS[value & 0xf];
128             value >>= 4;
129         }
130         require(value == 0, "Strings: hex length insufficient");
131         return string(buffer);
132     }
133 }
134 
135 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
136 
137 
138 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/ECDSA.sol)
139 
140 pragma solidity ^0.8.0;
141 
142 
143 /**
144  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
145  *
146  * These functions can be used to verify that a message was signed by the holder
147  * of the private keys of a given address.
148  */
149 library ECDSA {
150     enum RecoverError {
151         NoError,
152         InvalidSignature,
153         InvalidSignatureLength,
154         InvalidSignatureS,
155         InvalidSignatureV
156     }
157 
158     function _throwError(RecoverError error) private pure {
159         if (error == RecoverError.NoError) {
160             return; // no error: do nothing
161         } else if (error == RecoverError.InvalidSignature) {
162             revert("ECDSA: invalid signature");
163         } else if (error == RecoverError.InvalidSignatureLength) {
164             revert("ECDSA: invalid signature length");
165         } else if (error == RecoverError.InvalidSignatureS) {
166             revert("ECDSA: invalid signature 's' value");
167         } else if (error == RecoverError.InvalidSignatureV) {
168             revert("ECDSA: invalid signature 'v' value");
169         }
170     }
171 
172     /**
173      * @dev Returns the address that signed a hashed message (`hash`) with
174      * `signature` or error string. This address can then be used for verification purposes.
175      *
176      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
177      * this function rejects them by requiring the `s` value to be in the lower
178      * half order, and the `v` value to be either 27 or 28.
179      *
180      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
181      * verification to be secure: it is possible to craft signatures that
182      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
183      * this is by receiving a hash of the original message (which may otherwise
184      * be too long), and then calling {toEthSignedMessageHash} on it.
185      *
186      * Documentation for signature generation:
187      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
188      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
189      *
190      * _Available since v4.3._
191      */
192     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
193         // Check the signature length
194         // - case 65: r,s,v signature (standard)
195         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
196         if (signature.length == 65) {
197             bytes32 r;
198             bytes32 s;
199             uint8 v;
200             // ecrecover takes the signature parameters, and the only way to get them
201             // currently is to use assembly.
202             assembly {
203                 r := mload(add(signature, 0x20))
204                 s := mload(add(signature, 0x40))
205                 v := byte(0, mload(add(signature, 0x60)))
206             }
207             return tryRecover(hash, v, r, s);
208         } else if (signature.length == 64) {
209             bytes32 r;
210             bytes32 vs;
211             // ecrecover takes the signature parameters, and the only way to get them
212             // currently is to use assembly.
213             assembly {
214                 r := mload(add(signature, 0x20))
215                 vs := mload(add(signature, 0x40))
216             }
217             return tryRecover(hash, r, vs);
218         } else {
219             return (address(0), RecoverError.InvalidSignatureLength);
220         }
221     }
222 
223     /**
224      * @dev Returns the address that signed a hashed message (`hash`) with
225      * `signature`. This address can then be used for verification purposes.
226      *
227      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
228      * this function rejects them by requiring the `s` value to be in the lower
229      * half order, and the `v` value to be either 27 or 28.
230      *
231      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
232      * verification to be secure: it is possible to craft signatures that
233      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
234      * this is by receiving a hash of the original message (which may otherwise
235      * be too long), and then calling {toEthSignedMessageHash} on it.
236      */
237     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
238         (address recovered, RecoverError error) = tryRecover(hash, signature);
239         _throwError(error);
240         return recovered;
241     }
242 
243     /**
244      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
245      *
246      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
247      *
248      * _Available since v4.3._
249      */
250     function tryRecover(
251         bytes32 hash,
252         bytes32 r,
253         bytes32 vs
254     ) internal pure returns (address, RecoverError) {
255         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
256         uint8 v = uint8((uint256(vs) >> 255) + 27);
257         return tryRecover(hash, v, r, s);
258     }
259 
260     /**
261      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
262      *
263      * _Available since v4.2._
264      */
265     function recover(
266         bytes32 hash,
267         bytes32 r,
268         bytes32 vs
269     ) internal pure returns (address) {
270         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
271         _throwError(error);
272         return recovered;
273     }
274 
275     /**
276      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
277      * `r` and `s` signature fields separately.
278      *
279      * _Available since v4.3._
280      */
281     function tryRecover(
282         bytes32 hash,
283         uint8 v,
284         bytes32 r,
285         bytes32 s
286     ) internal pure returns (address, RecoverError) {
287         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
288         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
289         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
290         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
291         //
292         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
293         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
294         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
295         // these malleable signatures as well.
296         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
297             return (address(0), RecoverError.InvalidSignatureS);
298         }
299         if (v != 27 && v != 28) {
300             return (address(0), RecoverError.InvalidSignatureV);
301         }
302 
303         // If the signature is valid (and not malleable), return the signer address
304         address signer = ecrecover(hash, v, r, s);
305         if (signer == address(0)) {
306             return (address(0), RecoverError.InvalidSignature);
307         }
308 
309         return (signer, RecoverError.NoError);
310     }
311 
312     /**
313      * @dev Overload of {ECDSA-recover} that receives the `v`,
314      * `r` and `s` signature fields separately.
315      */
316     function recover(
317         bytes32 hash,
318         uint8 v,
319         bytes32 r,
320         bytes32 s
321     ) internal pure returns (address) {
322         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
323         _throwError(error);
324         return recovered;
325     }
326 
327     /**
328      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
329      * produces hash corresponding to the one signed with the
330      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
331      * JSON-RPC method as part of EIP-191.
332      *
333      * See {recover}.
334      */
335     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
336         // 32 is the length in bytes of hash,
337         // enforced by the type signature above
338         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
339     }
340 
341     /**
342      * @dev Returns an Ethereum Signed Message, created from `s`. This
343      * produces hash corresponding to the one signed with the
344      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
345      * JSON-RPC method as part of EIP-191.
346      *
347      * See {recover}.
348      */
349     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
350         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
351     }
352 
353     /**
354      * @dev Returns an Ethereum Signed Typed Data, created from a
355      * `domainSeparator` and a `structHash`. This produces hash corresponding
356      * to the one signed with the
357      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
358      * JSON-RPC method as part of EIP-712.
359      *
360      * See {recover}.
361      */
362     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
363         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
364     }
365 }
366 
367 // File: @openzeppelin/contracts/utils/Context.sol
368 
369 
370 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
371 
372 pragma solidity ^0.8.0;
373 
374 /**
375  * @dev Provides information about the current execution context, including the
376  * sender of the transaction and its data. While these are generally available
377  * via msg.sender and msg.data, they should not be accessed in such a direct
378  * manner, since when dealing with meta-transactions the account sending and
379  * paying for execution may not be the actual sender (as far as an application
380  * is concerned).
381  *
382  * This contract is only required for intermediate, library-like contracts.
383  */
384 abstract contract Context {
385     function _msgSender() internal view virtual returns (address) {
386         return msg.sender;
387     }
388 
389     function _msgData() internal view virtual returns (bytes calldata) {
390         return msg.data;
391     }
392 }
393 
394 // File: @openzeppelin/contracts/access/Ownable.sol
395 
396 
397 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
398 
399 pragma solidity ^0.8.0;
400 
401 
402 /**
403  * @dev Contract module which provides a basic access control mechanism, where
404  * there is an account (an owner) that can be granted exclusive access to
405  * specific functions.
406  *
407  * By default, the owner account will be the one that deploys the contract. This
408  * can later be changed with {transferOwnership}.
409  *
410  * This module is used through inheritance. It will make available the modifier
411  * `onlyOwner`, which can be applied to your functions to restrict their use to
412  * the owner.
413  */
414 abstract contract Ownable is Context {
415     address private _owner;
416 
417     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
418 
419     /**
420      * @dev Initializes the contract setting the deployer as the initial owner.
421      */
422     constructor() {
423         _transferOwnership(_msgSender());
424     }
425 
426     /**
427      * @dev Returns the address of the current owner.
428      */
429     function owner() public view virtual returns (address) {
430         return _owner;
431     }
432 
433     /**
434      * @dev Throws if called by any account other than the owner.
435      */
436     modifier onlyOwner() {
437         require(owner() == _msgSender(), "Ownable: caller is not the owner");
438         _;
439     }
440 
441     /**
442      * @dev Leaves the contract without owner. It will not be possible to call
443      * `onlyOwner` functions anymore. Can only be called by the current owner.
444      *
445      * NOTE: Renouncing ownership will leave the contract without an owner,
446      * thereby removing any functionality that is only available to the owner.
447      */
448     function renounceOwnership() public virtual onlyOwner {
449         _transferOwnership(address(0));
450     }
451 
452     /**
453      * @dev Transfers ownership of the contract to a new account (`newOwner`).
454      * Can only be called by the current owner.
455      */
456     function transferOwnership(address newOwner) public virtual onlyOwner {
457         require(newOwner != address(0), "Ownable: new owner is the zero address");
458         _transferOwnership(newOwner);
459     }
460 
461     /**
462      * @dev Transfers ownership of the contract to a new account (`newOwner`).
463      * Internal function without access restriction.
464      */
465     function _transferOwnership(address newOwner) internal virtual {
466         address oldOwner = _owner;
467         _owner = newOwner;
468         emit OwnershipTransferred(oldOwner, newOwner);
469     }
470 }
471 
472 // File: @openzeppelin/contracts/utils/Address.sol
473 
474 
475 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
476 
477 pragma solidity ^0.8.1;
478 
479 /**
480  * @dev Collection of functions related to the address type
481  */
482 library Address {
483     /**
484      * @dev Returns true if `account` is a contract.
485      *
486      * [IMPORTANT]
487      * ====
488      * It is unsafe to assume that an address for which this function returns
489      * false is an externally-owned account (EOA) and not a contract.
490      *
491      * Among others, `isContract` will return false for the following
492      * types of addresses:
493      *
494      *  - an externally-owned account
495      *  - a contract in construction
496      *  - an address where a contract will be created
497      *  - an address where a contract lived, but was destroyed
498      * ====
499      *
500      * [IMPORTANT]
501      * ====
502      * You shouldn't rely on `isContract` to protect against flash loan attacks!
503      *
504      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
505      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
506      * constructor.
507      * ====
508      */
509     function isContract(address account) internal view returns (bool) {
510         // This method relies on extcodesize/address.code.length, which returns 0
511         // for contracts in construction, since the code is only stored at the end
512         // of the constructor execution.
513 
514         return account.code.length > 0;
515     }
516 
517     /**
518      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
519      * `recipient`, forwarding all available gas and reverting on errors.
520      *
521      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
522      * of certain opcodes, possibly making contracts go over the 2300 gas limit
523      * imposed by `transfer`, making them unable to receive funds via
524      * `transfer`. {sendValue} removes this limitation.
525      *
526      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
527      *
528      * IMPORTANT: because control is transferred to `recipient`, care must be
529      * taken to not create reentrancy vulnerabilities. Consider using
530      * {ReentrancyGuard} or the
531      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
532      */
533     function sendValue(address payable recipient, uint256 amount) internal {
534         require(address(this).balance >= amount, "Address: insufficient balance");
535 
536         (bool success, ) = recipient.call{value: amount}("");
537         require(success, "Address: unable to send value, recipient may have reverted");
538     }
539 
540     /**
541      * @dev Performs a Solidity function call using a low level `call`. A
542      * plain `call` is an unsafe replacement for a function call: use this
543      * function instead.
544      *
545      * If `target` reverts with a revert reason, it is bubbled up by this
546      * function (like regular Solidity function calls).
547      *
548      * Returns the raw returned data. To convert to the expected return value,
549      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
550      *
551      * Requirements:
552      *
553      * - `target` must be a contract.
554      * - calling `target` with `data` must not revert.
555      *
556      * _Available since v3.1._
557      */
558     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
559         return functionCall(target, data, "Address: low-level call failed");
560     }
561 
562     /**
563      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
564      * `errorMessage` as a fallback revert reason when `target` reverts.
565      *
566      * _Available since v3.1._
567      */
568     function functionCall(
569         address target,
570         bytes memory data,
571         string memory errorMessage
572     ) internal returns (bytes memory) {
573         return functionCallWithValue(target, data, 0, errorMessage);
574     }
575 
576     /**
577      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
578      * but also transferring `value` wei to `target`.
579      *
580      * Requirements:
581      *
582      * - the calling contract must have an ETH balance of at least `value`.
583      * - the called Solidity function must be `payable`.
584      *
585      * _Available since v3.1._
586      */
587     function functionCallWithValue(
588         address target,
589         bytes memory data,
590         uint256 value
591     ) internal returns (bytes memory) {
592         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
593     }
594 
595     /**
596      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
597      * with `errorMessage` as a fallback revert reason when `target` reverts.
598      *
599      * _Available since v3.1._
600      */
601     function functionCallWithValue(
602         address target,
603         bytes memory data,
604         uint256 value,
605         string memory errorMessage
606     ) internal returns (bytes memory) {
607         require(address(this).balance >= value, "Address: insufficient balance for call");
608         require(isContract(target), "Address: call to non-contract");
609 
610         (bool success, bytes memory returndata) = target.call{value: value}(data);
611         return verifyCallResult(success, returndata, errorMessage);
612     }
613 
614     /**
615      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
616      * but performing a static call.
617      *
618      * _Available since v3.3._
619      */
620     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
621         return functionStaticCall(target, data, "Address: low-level static call failed");
622     }
623 
624     /**
625      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
626      * but performing a static call.
627      *
628      * _Available since v3.3._
629      */
630     function functionStaticCall(
631         address target,
632         bytes memory data,
633         string memory errorMessage
634     ) internal view returns (bytes memory) {
635         require(isContract(target), "Address: static call to non-contract");
636 
637         (bool success, bytes memory returndata) = target.staticcall(data);
638         return verifyCallResult(success, returndata, errorMessage);
639     }
640 
641     /**
642      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
643      * but performing a delegate call.
644      *
645      * _Available since v3.4._
646      */
647     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
648         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
649     }
650 
651     /**
652      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
653      * but performing a delegate call.
654      *
655      * _Available since v3.4._
656      */
657     function functionDelegateCall(
658         address target,
659         bytes memory data,
660         string memory errorMessage
661     ) internal returns (bytes memory) {
662         require(isContract(target), "Address: delegate call to non-contract");
663 
664         (bool success, bytes memory returndata) = target.delegatecall(data);
665         return verifyCallResult(success, returndata, errorMessage);
666     }
667 
668     /**
669      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
670      * revert reason using the provided one.
671      *
672      * _Available since v4.3._
673      */
674     function verifyCallResult(
675         bool success,
676         bytes memory returndata,
677         string memory errorMessage
678     ) internal pure returns (bytes memory) {
679         if (success) {
680             return returndata;
681         } else {
682             // Look for revert reason and bubble it up if present
683             if (returndata.length > 0) {
684                 // The easiest way to bubble the revert reason is using memory via assembly
685 
686                 assembly {
687                     let returndata_size := mload(returndata)
688                     revert(add(32, returndata), returndata_size)
689                 }
690             } else {
691                 revert(errorMessage);
692             }
693         }
694     }
695 }
696 
697 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
698 
699 
700 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
701 
702 pragma solidity ^0.8.0;
703 
704 /**
705  * @title ERC721 token receiver interface
706  * @dev Interface for any contract that wants to support safeTransfers
707  * from ERC721 asset contracts.
708  */
709 interface IERC721Receiver {
710     /**
711      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
712      * by `operator` from `from`, this function is called.
713      *
714      * It must return its Solidity selector to confirm the token transfer.
715      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
716      *
717      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
718      */
719     function onERC721Received(
720         address operator,
721         address from,
722         uint256 tokenId,
723         bytes calldata data
724     ) external returns (bytes4);
725 }
726 
727 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
728 
729 
730 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
731 
732 pragma solidity ^0.8.0;
733 
734 /**
735  * @dev Interface of the ERC165 standard, as defined in the
736  * https://eips.ethereum.org/EIPS/eip-165[EIP].
737  *
738  * Implementers can declare support of contract interfaces, which can then be
739  * queried by others ({ERC165Checker}).
740  *
741  * For an implementation, see {ERC165}.
742  */
743 interface IERC165 {
744     /**
745      * @dev Returns true if this contract implements the interface defined by
746      * `interfaceId`. See the corresponding
747      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
748      * to learn more about how these ids are created.
749      *
750      * This function call must use less than 30 000 gas.
751      */
752     function supportsInterface(bytes4 interfaceId) external view returns (bool);
753 }
754 
755 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
756 
757 
758 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
759 
760 pragma solidity ^0.8.0;
761 
762 
763 /**
764  * @dev Implementation of the {IERC165} interface.
765  *
766  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
767  * for the additional interface id that will be supported. For example:
768  *
769  * ```solidity
770  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
771  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
772  * }
773  * ```
774  *
775  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
776  */
777 abstract contract ERC165 is IERC165 {
778     /**
779      * @dev See {IERC165-supportsInterface}.
780      */
781     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
782         return interfaceId == type(IERC165).interfaceId;
783     }
784 }
785 
786 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
787 
788 
789 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
790 
791 pragma solidity ^0.8.0;
792 
793 
794 /**
795  * @dev Required interface of an ERC721 compliant contract.
796  */
797 interface IERC721 is IERC165 {
798     /**
799      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
800      */
801     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
802 
803     /**
804      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
805      */
806     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
807 
808     /**
809      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
810      */
811     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
812 
813     /**
814      * @dev Returns the number of tokens in ``owner``'s account.
815      */
816     function balanceOf(address owner) external view returns (uint256 balance);
817 
818     /**
819      * @dev Returns the owner of the `tokenId` token.
820      *
821      * Requirements:
822      *
823      * - `tokenId` must exist.
824      */
825     function ownerOf(uint256 tokenId) external view returns (address owner);
826 
827     /**
828      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
829      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
830      *
831      * Requirements:
832      *
833      * - `from` cannot be the zero address.
834      * - `to` cannot be the zero address.
835      * - `tokenId` token must exist and be owned by `from`.
836      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
837      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
838      *
839      * Emits a {Transfer} event.
840      */
841     function safeTransferFrom(
842         address from,
843         address to,
844         uint256 tokenId
845     ) external;
846 
847     /**
848      * @dev Transfers `tokenId` token from `from` to `to`.
849      *
850      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
851      *
852      * Requirements:
853      *
854      * - `from` cannot be the zero address.
855      * - `to` cannot be the zero address.
856      * - `tokenId` token must be owned by `from`.
857      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
858      *
859      * Emits a {Transfer} event.
860      */
861     function transferFrom(
862         address from,
863         address to,
864         uint256 tokenId
865     ) external;
866 
867     /**
868      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
869      * The approval is cleared when the token is transferred.
870      *
871      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
872      *
873      * Requirements:
874      *
875      * - The caller must own the token or be an approved operator.
876      * - `tokenId` must exist.
877      *
878      * Emits an {Approval} event.
879      */
880     function approve(address to, uint256 tokenId) external;
881 
882     /**
883      * @dev Returns the account approved for `tokenId` token.
884      *
885      * Requirements:
886      *
887      * - `tokenId` must exist.
888      */
889     function getApproved(uint256 tokenId) external view returns (address operator);
890 
891     /**
892      * @dev Approve or remove `operator` as an operator for the caller.
893      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
894      *
895      * Requirements:
896      *
897      * - The `operator` cannot be the caller.
898      *
899      * Emits an {ApprovalForAll} event.
900      */
901     function setApprovalForAll(address operator, bool _approved) external;
902 
903     /**
904      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
905      *
906      * See {setApprovalForAll}
907      */
908     function isApprovedForAll(address owner, address operator) external view returns (bool);
909 
910     /**
911      * @dev Safely transfers `tokenId` token from `from` to `to`.
912      *
913      * Requirements:
914      *
915      * - `from` cannot be the zero address.
916      * - `to` cannot be the zero address.
917      * - `tokenId` token must exist and be owned by `from`.
918      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
919      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
920      *
921      * Emits a {Transfer} event.
922      */
923     function safeTransferFrom(
924         address from,
925         address to,
926         uint256 tokenId,
927         bytes calldata data
928     ) external;
929 }
930 
931 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
932 
933 
934 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
935 
936 pragma solidity ^0.8.0;
937 
938 
939 /**
940  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
941  * @dev See https://eips.ethereum.org/EIPS/eip-721
942  */
943 interface IERC721Enumerable is IERC721 {
944     /**
945      * @dev Returns the total amount of tokens stored by the contract.
946      */
947     function totalSupply() external view returns (uint256);
948 
949     /**
950      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
951      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
952      */
953     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
954 
955     /**
956      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
957      * Use along with {totalSupply} to enumerate all tokens.
958      */
959     function tokenByIndex(uint256 index) external view returns (uint256);
960 }
961 
962 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
963 
964 
965 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
966 
967 pragma solidity ^0.8.0;
968 
969 
970 /**
971  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
972  * @dev See https://eips.ethereum.org/EIPS/eip-721
973  */
974 interface IERC721Metadata is IERC721 {
975     /**
976      * @dev Returns the token collection name.
977      */
978     function name() external view returns (string memory);
979 
980     /**
981      * @dev Returns the token collection symbol.
982      */
983     function symbol() external view returns (string memory);
984 
985     /**
986      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
987      */
988     function tokenURI(uint256 tokenId) external view returns (string memory);
989 }
990 
991 // File: erc721a/contracts/ERC721A.sol
992 
993 
994 // Creator: Chiru Labs
995 
996 pragma solidity ^0.8.4;
997 
998 
999 
1000 
1001 
1002 
1003 
1004 
1005 
1006 error ApprovalCallerNotOwnerNorApproved();
1007 error ApprovalQueryForNonexistentToken();
1008 error ApproveToCaller();
1009 error ApprovalToCurrentOwner();
1010 error BalanceQueryForZeroAddress();
1011 error MintedQueryForZeroAddress();
1012 error BurnedQueryForZeroAddress();
1013 error MintToZeroAddress();
1014 error MintZeroQuantity();
1015 error OwnerIndexOutOfBounds();
1016 error OwnerQueryForNonexistentToken();
1017 error TokenIndexOutOfBounds();
1018 error TransferCallerNotOwnerNorApproved();
1019 error TransferFromIncorrectOwner();
1020 error TransferToNonERC721ReceiverImplementer();
1021 error TransferToZeroAddress();
1022 error URIQueryForNonexistentToken();
1023 
1024 /**
1025  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1026  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1027  *
1028  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
1029  *
1030  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1031  *
1032  * Assumes that the maximum token id cannot exceed 2**128 - 1 (max value of uint128).
1033  */
1034 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1035     using Address for address;
1036     using Strings for uint256;
1037 
1038     // Compiler will pack this into a single 256bit word.
1039     struct TokenOwnership {
1040         // The address of the owner.
1041         address addr;
1042         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
1043         uint64 startTimestamp;
1044         // Whether the token has been burned.
1045         bool burned;
1046     }
1047 
1048     // Compiler will pack this into a single 256bit word.
1049     struct AddressData {
1050         // Realistically, 2**64-1 is more than enough.
1051         uint64 balance;
1052         // Keeps track of mint count with minimal overhead for tokenomics.
1053         uint64 numberMinted;
1054         // Keeps track of burn count with minimal overhead for tokenomics.
1055         uint64 numberBurned;
1056     }
1057 
1058     // Compiler will pack the following 
1059     // _currentIndex and _burnCounter into a single 256bit word.
1060     
1061     // The tokenId of the next token to be minted.
1062     uint128 internal _currentIndex;
1063 
1064     // The number of tokens burned.
1065     uint128 internal _burnCounter;
1066 
1067     // Token name
1068     string private _name;
1069 
1070     // Token symbol
1071     string private _symbol;
1072 
1073     // Mapping from token ID to ownership details
1074     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1075     mapping(uint256 => TokenOwnership) internal _ownerships;
1076 
1077     // Mapping owner address to address data
1078     mapping(address => AddressData) private _addressData;
1079 
1080     // Mapping from token ID to approved address
1081     mapping(uint256 => address) private _tokenApprovals;
1082 
1083     // Mapping from owner to operator approvals
1084     mapping(address => mapping(address => bool)) private _operatorApprovals;
1085 
1086     constructor(string memory name_, string memory symbol_) {
1087         _name = name_;
1088         _symbol = symbol_;
1089     }
1090 
1091     /**
1092      * @dev See {IERC721Enumerable-totalSupply}.
1093      */
1094     function totalSupply() public view override returns (uint256) {
1095         // Counter underflow is impossible as _burnCounter cannot be incremented
1096         // more than _currentIndex times
1097         unchecked {
1098             return _currentIndex - _burnCounter;    
1099         }
1100     }
1101 
1102     /**
1103      * @dev See {IERC721Enumerable-tokenByIndex}.
1104      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1105      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1106      */
1107     function tokenByIndex(uint256 index) public view override returns (uint256) {
1108         uint256 numMintedSoFar = _currentIndex;
1109         uint256 tokenIdsIdx;
1110 
1111         // Counter overflow is impossible as the loop breaks when
1112         // uint256 i is equal to another uint256 numMintedSoFar.
1113         unchecked {
1114             for (uint256 i; i < numMintedSoFar; i++) {
1115                 TokenOwnership memory ownership = _ownerships[i];
1116                 if (!ownership.burned) {
1117                     if (tokenIdsIdx == index) {
1118                         return i;
1119                     }
1120                     tokenIdsIdx++;
1121                 }
1122             }
1123         }
1124         revert TokenIndexOutOfBounds();
1125     }
1126 
1127     /**
1128      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1129      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1130      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1131      */
1132     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1133         if (index >= balanceOf(owner)) revert OwnerIndexOutOfBounds();
1134         uint256 numMintedSoFar = _currentIndex;
1135         uint256 tokenIdsIdx;
1136         address currOwnershipAddr;
1137 
1138         // Counter overflow is impossible as the loop breaks when
1139         // uint256 i is equal to another uint256 numMintedSoFar.
1140         unchecked {
1141             for (uint256 i; i < numMintedSoFar; i++) {
1142                 TokenOwnership memory ownership = _ownerships[i];
1143                 if (ownership.burned) {
1144                     continue;
1145                 }
1146                 if (ownership.addr != address(0)) {
1147                     currOwnershipAddr = ownership.addr;
1148                 }
1149                 if (currOwnershipAddr == owner) {
1150                     if (tokenIdsIdx == index) {
1151                         return i;
1152                     }
1153                     tokenIdsIdx++;
1154                 }
1155             }
1156         }
1157 
1158         // Execution should never reach this point.
1159         revert();
1160     }
1161 
1162     /**
1163      * @dev See {IERC165-supportsInterface}.
1164      */
1165     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1166         return
1167             interfaceId == type(IERC721).interfaceId ||
1168             interfaceId == type(IERC721Metadata).interfaceId ||
1169             interfaceId == type(IERC721Enumerable).interfaceId ||
1170             super.supportsInterface(interfaceId);
1171     }
1172 
1173     /**
1174      * @dev See {IERC721-balanceOf}.
1175      */
1176     function balanceOf(address owner) public view override returns (uint256) {
1177         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1178         return uint256(_addressData[owner].balance);
1179     }
1180 
1181     function _numberMinted(address owner) internal view returns (uint256) {
1182         if (owner == address(0)) revert MintedQueryForZeroAddress();
1183         return uint256(_addressData[owner].numberMinted);
1184     }
1185 
1186     function _numberBurned(address owner) internal view returns (uint256) {
1187         if (owner == address(0)) revert BurnedQueryForZeroAddress();
1188         return uint256(_addressData[owner].numberBurned);
1189     }
1190 
1191     /**
1192      * Gas spent here starts off proportional to the maximum mint batch size.
1193      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1194      */
1195     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1196         uint256 curr = tokenId;
1197 
1198         unchecked {
1199             if (curr < _currentIndex) {
1200                 TokenOwnership memory ownership = _ownerships[curr];
1201                 if (!ownership.burned) {
1202                     if (ownership.addr != address(0)) {
1203                         return ownership;
1204                     }
1205                     // Invariant: 
1206                     // There will always be an ownership that has an address and is not burned 
1207                     // before an ownership that does not have an address and is not burned.
1208                     // Hence, curr will not underflow.
1209                     while (true) {
1210                         curr--;
1211                         ownership = _ownerships[curr];
1212                         if (ownership.addr != address(0)) {
1213                             return ownership;
1214                         }
1215                     }
1216                 }
1217             }
1218         }
1219         revert OwnerQueryForNonexistentToken();
1220     }
1221 
1222     /**
1223      * @dev See {IERC721-ownerOf}.
1224      */
1225     function ownerOf(uint256 tokenId) public view override returns (address) {
1226         return ownershipOf(tokenId).addr;
1227     }
1228 
1229     /**
1230      * @dev See {IERC721Metadata-name}.
1231      */
1232     function name() public view virtual override returns (string memory) {
1233         return _name;
1234     }
1235 
1236     /**
1237      * @dev See {IERC721Metadata-symbol}.
1238      */
1239     function symbol() public view virtual override returns (string memory) {
1240         return _symbol;
1241     }
1242 
1243     /**
1244      * @dev See {IERC721Metadata-tokenURI}.
1245      */
1246     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1247         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1248 
1249         string memory baseURI = _baseURI();
1250         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1251     }
1252 
1253     /**
1254      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1255      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1256      * by default, can be overriden in child contracts.
1257      */
1258     function _baseURI() internal view virtual returns (string memory) {
1259         return '';
1260     }
1261 
1262     /**
1263      * @dev See {IERC721-approve}.
1264      */
1265     function approve(address to, uint256 tokenId) public override {
1266         address owner = ERC721A.ownerOf(tokenId);
1267         if (to == owner) revert ApprovalToCurrentOwner();
1268 
1269         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1270             revert ApprovalCallerNotOwnerNorApproved();
1271         }
1272 
1273         _approve(to, tokenId, owner);
1274     }
1275 
1276     /**
1277      * @dev See {IERC721-getApproved}.
1278      */
1279     function getApproved(uint256 tokenId) public view override returns (address) {
1280         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1281 
1282         return _tokenApprovals[tokenId];
1283     }
1284 
1285     /**
1286      * @dev See {IERC721-setApprovalForAll}.
1287      */
1288     function setApprovalForAll(address operator, bool approved) public override {
1289         if (operator == _msgSender()) revert ApproveToCaller();
1290 
1291         _operatorApprovals[_msgSender()][operator] = approved;
1292         emit ApprovalForAll(_msgSender(), operator, approved);
1293     }
1294 
1295     /**
1296      * @dev See {IERC721-isApprovedForAll}.
1297      */
1298     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1299         return _operatorApprovals[owner][operator];
1300     }
1301 
1302     /**
1303      * @dev See {IERC721-transferFrom}.
1304      */
1305     function transferFrom(
1306         address from,
1307         address to,
1308         uint256 tokenId
1309     ) public virtual override {
1310         _transfer(from, to, tokenId);
1311     }
1312 
1313     /**
1314      * @dev See {IERC721-safeTransferFrom}.
1315      */
1316     function safeTransferFrom(
1317         address from,
1318         address to,
1319         uint256 tokenId
1320     ) public virtual override {
1321         safeTransferFrom(from, to, tokenId, '');
1322     }
1323 
1324     /**
1325      * @dev See {IERC721-safeTransferFrom}.
1326      */
1327     function safeTransferFrom(
1328         address from,
1329         address to,
1330         uint256 tokenId,
1331         bytes memory _data
1332     ) public virtual override {
1333         _transfer(from, to, tokenId);
1334         if (!_checkOnERC721Received(from, to, tokenId, _data)) {
1335             revert TransferToNonERC721ReceiverImplementer();
1336         }
1337     }
1338 
1339     /**
1340      * @dev Returns whether `tokenId` exists.
1341      *
1342      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1343      *
1344      * Tokens start existing when they are minted (`_mint`),
1345      */
1346     function _exists(uint256 tokenId) internal view returns (bool) {
1347         return tokenId < _currentIndex && !_ownerships[tokenId].burned;
1348     }
1349 
1350     function _safeMint(address to, uint256 quantity) internal {
1351         _safeMint(to, quantity, '');
1352     }
1353 
1354     /**
1355      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1356      *
1357      * Requirements:
1358      *
1359      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1360      * - `quantity` must be greater than 0.
1361      *
1362      * Emits a {Transfer} event.
1363      */
1364     function _safeMint(
1365         address to,
1366         uint256 quantity,
1367         bytes memory _data
1368     ) internal {
1369         _mint(to, quantity, _data, true);
1370     }
1371 
1372     /**
1373      * @dev Mints `quantity` tokens and transfers them to `to`.
1374      *
1375      * Requirements:
1376      *
1377      * - `to` cannot be the zero address.
1378      * - `quantity` must be greater than 0.
1379      *
1380      * Emits a {Transfer} event.
1381      */
1382     function _mint(
1383         address to,
1384         uint256 quantity,
1385         bytes memory _data,
1386         bool safe
1387     ) internal {
1388         uint256 startTokenId = _currentIndex;
1389         if (to == address(0)) revert MintToZeroAddress();
1390         if (quantity == 0) revert MintZeroQuantity();
1391 
1392         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1393 
1394         // Overflows are incredibly unrealistic.
1395         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1396         // updatedIndex overflows if _currentIndex + quantity > 3.4e38 (2**128) - 1
1397         unchecked {
1398             _addressData[to].balance += uint64(quantity);
1399             _addressData[to].numberMinted += uint64(quantity);
1400 
1401             _ownerships[startTokenId].addr = to;
1402             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1403 
1404             uint256 updatedIndex = startTokenId;
1405 
1406             for (uint256 i; i < quantity; i++) {
1407                 emit Transfer(address(0), to, updatedIndex);
1408                 if (safe && !_checkOnERC721Received(address(0), to, updatedIndex, _data)) {
1409                     revert TransferToNonERC721ReceiverImplementer();
1410                 }
1411                 updatedIndex++;
1412             }
1413 
1414             _currentIndex = uint128(updatedIndex);
1415         }
1416         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1417     }
1418 
1419     /**
1420      * @dev Transfers `tokenId` from `from` to `to`.
1421      *
1422      * Requirements:
1423      *
1424      * - `to` cannot be the zero address.
1425      * - `tokenId` token must be owned by `from`.
1426      *
1427      * Emits a {Transfer} event.
1428      */
1429     function _transfer(
1430         address from,
1431         address to,
1432         uint256 tokenId
1433     ) private {
1434         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1435 
1436         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1437             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1438             getApproved(tokenId) == _msgSender());
1439 
1440         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1441         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1442         if (to == address(0)) revert TransferToZeroAddress();
1443 
1444         _beforeTokenTransfers(from, to, tokenId, 1);
1445 
1446         // Clear approvals from the previous owner
1447         _approve(address(0), tokenId, prevOwnership.addr);
1448 
1449         // Underflow of the sender's balance is impossible because we check for
1450         // ownership above and the recipient's balance can't realistically overflow.
1451         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**128.
1452         unchecked {
1453             _addressData[from].balance -= 1;
1454             _addressData[to].balance += 1;
1455 
1456             _ownerships[tokenId].addr = to;
1457             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1458 
1459             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1460             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1461             uint256 nextTokenId = tokenId + 1;
1462             if (_ownerships[nextTokenId].addr == address(0)) {
1463                 // This will suffice for checking _exists(nextTokenId),
1464                 // as a burned slot cannot contain the zero address.
1465                 if (nextTokenId < _currentIndex) {
1466                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1467                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1468                 }
1469             }
1470         }
1471 
1472         emit Transfer(from, to, tokenId);
1473         _afterTokenTransfers(from, to, tokenId, 1);
1474     }
1475 
1476     /**
1477      * @dev Destroys `tokenId`.
1478      * The approval is cleared when the token is burned.
1479      *
1480      * Requirements:
1481      *
1482      * - `tokenId` must exist.
1483      *
1484      * Emits a {Transfer} event.
1485      */
1486     function _burn(uint256 tokenId) internal virtual {
1487         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1488 
1489         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1490 
1491         // Clear approvals from the previous owner
1492         _approve(address(0), tokenId, prevOwnership.addr);
1493 
1494         // Underflow of the sender's balance is impossible because we check for
1495         // ownership above and the recipient's balance can't realistically overflow.
1496         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**128.
1497         unchecked {
1498             _addressData[prevOwnership.addr].balance -= 1;
1499             _addressData[prevOwnership.addr].numberBurned += 1;
1500 
1501             // Keep track of who burned the token, and the timestamp of burning.
1502             _ownerships[tokenId].addr = prevOwnership.addr;
1503             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1504             _ownerships[tokenId].burned = true;
1505 
1506             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1507             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1508             uint256 nextTokenId = tokenId + 1;
1509             if (_ownerships[nextTokenId].addr == address(0)) {
1510                 // This will suffice for checking _exists(nextTokenId),
1511                 // as a burned slot cannot contain the zero address.
1512                 if (nextTokenId < _currentIndex) {
1513                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1514                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1515                 }
1516             }
1517         }
1518 
1519         emit Transfer(prevOwnership.addr, address(0), tokenId);
1520         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1521 
1522         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1523         unchecked { 
1524             _burnCounter++;
1525         }
1526     }
1527 
1528     /**
1529      * @dev Approve `to` to operate on `tokenId`
1530      *
1531      * Emits a {Approval} event.
1532      */
1533     function _approve(
1534         address to,
1535         uint256 tokenId,
1536         address owner
1537     ) private {
1538         _tokenApprovals[tokenId] = to;
1539         emit Approval(owner, to, tokenId);
1540     }
1541 
1542     /**
1543      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1544      * The call is not executed if the target address is not a contract.
1545      *
1546      * @param from address representing the previous owner of the given token ID
1547      * @param to target address that will receive the tokens
1548      * @param tokenId uint256 ID of the token to be transferred
1549      * @param _data bytes optional data to send along with the call
1550      * @return bool whether the call correctly returned the expected magic value
1551      */
1552     function _checkOnERC721Received(
1553         address from,
1554         address to,
1555         uint256 tokenId,
1556         bytes memory _data
1557     ) private returns (bool) {
1558         if (to.isContract()) {
1559             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1560                 return retval == IERC721Receiver(to).onERC721Received.selector;
1561             } catch (bytes memory reason) {
1562                 if (reason.length == 0) {
1563                     revert TransferToNonERC721ReceiverImplementer();
1564                 } else {
1565                     assembly {
1566                         revert(add(32, reason), mload(reason))
1567                     }
1568                 }
1569             }
1570         } else {
1571             return true;
1572         }
1573     }
1574 
1575     /**
1576      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1577      * And also called before burning one token.
1578      *
1579      * startTokenId - the first token id to be transferred
1580      * quantity - the amount to be transferred
1581      *
1582      * Calling conditions:
1583      *
1584      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1585      * transferred to `to`.
1586      * - When `from` is zero, `tokenId` will be minted for `to`.
1587      * - When `to` is zero, `tokenId` will be burned by `from`.
1588      * - `from` and `to` are never both zero.
1589      */
1590     function _beforeTokenTransfers(
1591         address from,
1592         address to,
1593         uint256 startTokenId,
1594         uint256 quantity
1595     ) internal virtual {}
1596 
1597     /**
1598      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1599      * minting.
1600      * And also called after one token has been burned.
1601      *
1602      * startTokenId - the first token id to be transferred
1603      * quantity - the amount to be transferred
1604      *
1605      * Calling conditions:
1606      *
1607      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1608      * transferred to `to`.
1609      * - When `from` is zero, `tokenId` has been minted for `to`.
1610      * - When `to` is zero, `tokenId` has been burned by `from`.
1611      * - `from` and `to` are never both zero.
1612      */
1613     function _afterTokenTransfers(
1614         address from,
1615         address to,
1616         uint256 startTokenId,
1617         uint256 quantity
1618     ) internal virtual {}
1619 }
1620 
1621 // File: contracts/contract.sol
1622 
1623 
1624 
1625 pragma solidity ^0.8.12;
1626 
1627 
1628 
1629 
1630 
1631 contract GraffitiBears is ERC721A, Ownable {
1632     using Strings for uint256;
1633 
1634     uint256 public constant RESERVED_TOKENS = 199;
1635     uint256 public constant FOR_SALE_TOKENS = 9999 - RESERVED_TOKENS;
1636     address public constant RESERVED_TOKENS_ADDRESS = 0x4b0f06669e762f872e3D96509437e13427a886da;
1637 
1638     uint256 public tokenPricePresale = 0.08 ether;
1639     uint256 public tokenPricePublicSale = 0.12 ether;
1640 
1641     uint256 public maxTokensPerTransaction = 10;
1642     uint256 public maxTokensPerAddress = 12;
1643     uint256 public maxTokensPerAddressOG = 4;
1644     uint256 public maxTokensPerAddressMember = 3;
1645 
1646     uint256 public presaleTotalLimit = 1200;
1647 
1648     bytes32 public whitelistRootOG = 0xc15a2afef7d407c51263a8c3e8fb7196f3ea213b938e06d8547e01fc6e18dca0;
1649     bytes32 public whitelistRootMember;
1650 
1651     string public tokenBaseURI = "ipfs://QmXPvLEw1KbSCcrLTsGBYC4YsgeLs3z8A9TRRz5zktwtJ5/";
1652 
1653     bool public hasPresaleStarted = false;
1654     bool public hasPublicSaleStarted = false;
1655 
1656     uint256 public soldAmount = 0;
1657     mapping(address => uint256) public purchased;
1658 
1659     constructor() ERC721A("GraffitiBears", "BEARS") {
1660         _safeMint(RESERVED_TOKENS_ADDRESS, RESERVED_TOKENS);
1661     }
1662 
1663     function setPresaleStarted(bool val) external onlyOwner {
1664         hasPresaleStarted = val;
1665     }
1666 
1667     function setPublicSaleStarted(bool val) external onlyOwner {
1668         hasPublicSaleStarted = val;
1669     }
1670 
1671     function setTokenPricePresale(uint256 val) external onlyOwner {
1672         tokenPricePresale = val;
1673     }
1674     
1675     function setTokenPricePublicSale(uint256 val) external onlyOwner {
1676         tokenPricePublicSale = val;
1677     }
1678 
1679     function setMaxTokensPerTransaction(uint256 val) external onlyOwner {
1680         maxTokensPerTransaction = val;
1681     }
1682 
1683     function setMaxTokensPerAddress(uint256 val) external onlyOwner {
1684         maxTokensPerAddress = val;
1685     }
1686 
1687     function setMaxTokensPerAddressOG(uint256 val) external onlyOwner {
1688         maxTokensPerAddressOG = val;
1689     }
1690     
1691     function setMaxTokensPerAddressMember(uint256 val) external onlyOwner {
1692         maxTokensPerAddressMember = val;
1693     }
1694 
1695     function setPresaleTotalLimit(uint256 val) external onlyOwner {
1696         presaleTotalLimit = val;
1697     }
1698 
1699     function setWhitelistRootOG(bytes32 val) external onlyOwner {
1700         whitelistRootOG = val;
1701     }
1702 
1703     function setWhitelistRootMember(bytes32 val) external onlyOwner {
1704         whitelistRootMember = val;
1705     }
1706 
1707     function tokenPrice() public view returns (uint256) {
1708         if (hasPublicSaleStarted) {
1709             return tokenPricePublicSale;
1710         }
1711         return tokenPricePresale;
1712     }
1713 
1714     function getMaxTokensForPhase(address target, bytes32[] memory proof) public view returns (uint256) {
1715         bytes32 leaf = keccak256(abi.encodePacked(target));
1716 
1717         if (!hasPresaleStarted) {
1718             return 0;
1719         }
1720 
1721         if (hasPublicSaleStarted) {
1722             return maxTokensPerAddress;
1723         }
1724 
1725         if (MerkleProof.verify(proof, whitelistRootOG, leaf)) {
1726             return maxTokensPerAddressOG;
1727         }
1728         
1729         if (MerkleProof.verify(proof, whitelistRootMember, leaf)) {
1730             return maxTokensPerAddressMember;
1731         }
1732 
1733         return 0;
1734     }
1735 
1736     function getMaxTokensAllowed(address target, bytes32[] memory proof) public view returns (uint256) {
1737         uint256 maxAllowedTokens = getMaxTokensForPhase(target, proof);
1738 
1739         uint256 purchasedTokens = purchased[target];
1740         if (purchasedTokens >= maxAllowedTokens) {
1741             return 0;
1742         }
1743         uint256 maxTokensAllowedForAddress = maxAllowedTokens - purchasedTokens;
1744         maxAllowedTokens = min(maxAllowedTokens, maxTokensAllowedForAddress);
1745 
1746         if (!hasPublicSaleStarted) {
1747             if (soldAmount >= presaleTotalLimit) {
1748                 return 0;
1749             }
1750             uint256 presaleTokensLeft = presaleTotalLimit - soldAmount;
1751             maxAllowedTokens = min(maxAllowedTokens, presaleTokensLeft);
1752         }
1753 
1754         if (soldAmount >= FOR_SALE_TOKENS) {
1755             return 0;
1756         }
1757         uint256 publicSaleTokensLeft = FOR_SALE_TOKENS - soldAmount;
1758         maxAllowedTokens = min(maxAllowedTokens, publicSaleTokensLeft);
1759 
1760         return min(maxAllowedTokens, maxTokensPerTransaction);
1761     }
1762 
1763     function getContractInfo(address target, bytes32[] memory proof) external view returns (
1764         bool _hasPresaleStarted,
1765         bool _hasPublicSaleStarted,
1766         uint256 _maxTokensAllowed,
1767         uint256 _tokenPrice,
1768         uint256 _soldAmount,
1769         uint256 _purchasedAmount,
1770         uint256 _presaleTotalLimit,
1771         bytes32 _whitelistRootOG,
1772         bytes32 _whitelistRootMember
1773     ) {
1774         _hasPresaleStarted = hasPresaleStarted;
1775         _hasPublicSaleStarted = hasPublicSaleStarted;
1776         _maxTokensAllowed = getMaxTokensAllowed(target, proof);
1777         _tokenPrice = tokenPrice();
1778         _soldAmount = soldAmount;
1779         _purchasedAmount = purchased[target];
1780         _presaleTotalLimit = presaleTotalLimit;
1781         _whitelistRootOG = whitelistRootOG;
1782         _whitelistRootMember = whitelistRootMember;
1783     }
1784 
1785     function mint(uint256 amount, bytes32[] memory proof) external payable {
1786         require(hasPresaleStarted, "Cannot mint before presale");
1787         require(msg.value >= tokenPrice() * amount, "Incorrect ETH sent");
1788         require(amount <= getMaxTokensAllowed(msg.sender, proof), "Cannot mint more than the max allowed tokens");
1789 
1790         _safeMint(msg.sender, amount);
1791         purchased[msg.sender] += amount;
1792         soldAmount += amount;
1793     }
1794 
1795     function _baseURI() internal view override(ERC721A) returns (string memory) {
1796         return tokenBaseURI;
1797     }
1798    
1799     function setBaseURI(string calldata URI) external onlyOwner {
1800         tokenBaseURI = URI;
1801     }
1802 
1803     function withdraw() external onlyOwner {
1804         require(payable(msg.sender).send(address(this).balance));
1805     }
1806     
1807     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1808         return a < b ? a : b;
1809     }
1810 }