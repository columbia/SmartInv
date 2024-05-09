1 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
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
70 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
71 
72 pragma solidity ^0.8.0;
73 
74 /**
75  * @dev String operations.
76  */
77 library Strings {
78     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
79     uint8 private constant _ADDRESS_LENGTH = 20;
80 
81     /**
82      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
83      */
84     function toString(uint256 value) internal pure returns (string memory) {
85         // Inspired by OraclizeAPI's implementation - MIT licence
86         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
87 
88         if (value == 0) {
89             return "0";
90         }
91         uint256 temp = value;
92         uint256 digits;
93         while (temp != 0) {
94             digits++;
95             temp /= 10;
96         }
97         bytes memory buffer = new bytes(digits);
98         while (value != 0) {
99             digits -= 1;
100             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
101             value /= 10;
102         }
103         return string(buffer);
104     }
105 
106     /**
107      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
108      */
109     function toHexString(uint256 value) internal pure returns (string memory) {
110         if (value == 0) {
111             return "0x00";
112         }
113         uint256 temp = value;
114         uint256 length = 0;
115         while (temp != 0) {
116             length++;
117             temp >>= 8;
118         }
119         return toHexString(value, length);
120     }
121 
122     /**
123      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
124      */
125     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
126         bytes memory buffer = new bytes(2 * length + 2);
127         buffer[0] = "0";
128         buffer[1] = "x";
129         for (uint256 i = 2 * length + 1; i > 1; --i) {
130             buffer[i] = _HEX_SYMBOLS[value & 0xf];
131             value >>= 4;
132         }
133         require(value == 0, "Strings: hex length insufficient");
134         return string(buffer);
135     }
136 
137     /**
138      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
139      */
140     function toHexString(address addr) internal pure returns (string memory) {
141         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
142     }
143 }
144 
145 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
146 
147 
148 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/ECDSA.sol)
149 
150 pragma solidity ^0.8.0;
151 
152 
153 /**
154  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
155  *
156  * These functions can be used to verify that a message was signed by the holder
157  * of the private keys of a given address.
158  */
159 library ECDSA {
160     enum RecoverError {
161         NoError,
162         InvalidSignature,
163         InvalidSignatureLength,
164         InvalidSignatureS,
165         InvalidSignatureV
166     }
167 
168     function _throwError(RecoverError error) private pure {
169         if (error == RecoverError.NoError) {
170             return; // no error: do nothing
171         } else if (error == RecoverError.InvalidSignature) {
172             revert("ECDSA: invalid signature");
173         } else if (error == RecoverError.InvalidSignatureLength) {
174             revert("ECDSA: invalid signature length");
175         } else if (error == RecoverError.InvalidSignatureS) {
176             revert("ECDSA: invalid signature 's' value");
177         } else if (error == RecoverError.InvalidSignatureV) {
178             revert("ECDSA: invalid signature 'v' value");
179         }
180     }
181 
182     /**
183      * @dev Returns the address that signed a hashed message (`hash`) with
184      * `signature` or error string. This address can then be used for verification purposes.
185      *
186      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
187      * this function rejects them by requiring the `s` value to be in the lower
188      * half order, and the `v` value to be either 27 or 28.
189      *
190      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
191      * verification to be secure: it is possible to craft signatures that
192      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
193      * this is by receiving a hash of the original message (which may otherwise
194      * be too long), and then calling {toEthSignedMessageHash} on it.
195      *
196      * Documentation for signature generation:
197      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
198      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
199      *
200      * _Available since v4.3._
201      */
202     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
203         // Check the signature length
204         // - case 65: r,s,v signature (standard)
205         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
206         if (signature.length == 65) {
207             bytes32 r;
208             bytes32 s;
209             uint8 v;
210             // ecrecover takes the signature parameters, and the only way to get them
211             // currently is to use assembly.
212             /// @solidity memory-safe-assembly
213             assembly {
214                 r := mload(add(signature, 0x20))
215                 s := mload(add(signature, 0x40))
216                 v := byte(0, mload(add(signature, 0x60)))
217             }
218             return tryRecover(hash, v, r, s);
219         } else if (signature.length == 64) {
220             bytes32 r;
221             bytes32 vs;
222             // ecrecover takes the signature parameters, and the only way to get them
223             // currently is to use assembly.
224             /// @solidity memory-safe-assembly
225             assembly {
226                 r := mload(add(signature, 0x20))
227                 vs := mload(add(signature, 0x40))
228             }
229             return tryRecover(hash, r, vs);
230         } else {
231             return (address(0), RecoverError.InvalidSignatureLength);
232         }
233     }
234 
235     /**
236      * @dev Returns the address that signed a hashed message (`hash`) with
237      * `signature`. This address can then be used for verification purposes.
238      *
239      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
240      * this function rejects them by requiring the `s` value to be in the lower
241      * half order, and the `v` value to be either 27 or 28.
242      *
243      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
244      * verification to be secure: it is possible to craft signatures that
245      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
246      * this is by receiving a hash of the original message (which may otherwise
247      * be too long), and then calling {toEthSignedMessageHash} on it.
248      */
249     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
250         (address recovered, RecoverError error) = tryRecover(hash, signature);
251         _throwError(error);
252         return recovered;
253     }
254 
255     /**
256      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
257      *
258      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
259      *
260      * _Available since v4.3._
261      */
262     function tryRecover(
263         bytes32 hash,
264         bytes32 r,
265         bytes32 vs
266     ) internal pure returns (address, RecoverError) {
267         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
268         uint8 v = uint8((uint256(vs) >> 255) + 27);
269         return tryRecover(hash, v, r, s);
270     }
271 
272     /**
273      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
274      *
275      * _Available since v4.2._
276      */
277     function recover(
278         bytes32 hash,
279         bytes32 r,
280         bytes32 vs
281     ) internal pure returns (address) {
282         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
283         _throwError(error);
284         return recovered;
285     }
286 
287     /**
288      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
289      * `r` and `s` signature fields separately.
290      *
291      * _Available since v4.3._
292      */
293     function tryRecover(
294         bytes32 hash,
295         uint8 v,
296         bytes32 r,
297         bytes32 s
298     ) internal pure returns (address, RecoverError) {
299         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
300         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
301         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
302         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
303         //
304         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
305         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
306         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
307         // these malleable signatures as well.
308         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
309             return (address(0), RecoverError.InvalidSignatureS);
310         }
311         if (v != 27 && v != 28) {
312             return (address(0), RecoverError.InvalidSignatureV);
313         }
314 
315         // If the signature is valid (and not malleable), return the signer address
316         address signer = ecrecover(hash, v, r, s);
317         if (signer == address(0)) {
318             return (address(0), RecoverError.InvalidSignature);
319         }
320 
321         return (signer, RecoverError.NoError);
322     }
323 
324     /**
325      * @dev Overload of {ECDSA-recover} that receives the `v`,
326      * `r` and `s` signature fields separately.
327      */
328     function recover(
329         bytes32 hash,
330         uint8 v,
331         bytes32 r,
332         bytes32 s
333     ) internal pure returns (address) {
334         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
335         _throwError(error);
336         return recovered;
337     }
338 
339     /**
340      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
341      * produces hash corresponding to the one signed with the
342      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
343      * JSON-RPC method as part of EIP-191.
344      *
345      * See {recover}.
346      */
347     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
348         // 32 is the length in bytes of hash,
349         // enforced by the type signature above
350         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
351     }
352 
353     /**
354      * @dev Returns an Ethereum Signed Message, created from `s`. This
355      * produces hash corresponding to the one signed with the
356      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
357      * JSON-RPC method as part of EIP-191.
358      *
359      * See {recover}.
360      */
361     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
362         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
363     }
364 
365     /**
366      * @dev Returns an Ethereum Signed Typed Data, created from a
367      * `domainSeparator` and a `structHash`. This produces hash corresponding
368      * to the one signed with the
369      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
370      * JSON-RPC method as part of EIP-712.
371      *
372      * See {recover}.
373      */
374     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
375         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
376     }
377 }
378 
379 // File: @openzeppelin/contracts/utils/Context.sol
380 
381 
382 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
383 
384 pragma solidity ^0.8.0;
385 
386 /**
387  * @dev Provides information about the current execution context, including the
388  * sender of the transaction and its data. While these are generally available
389  * via msg.sender and msg.data, they should not be accessed in such a direct
390  * manner, since when dealing with meta-transactions the account sending and
391  * paying for execution may not be the actual sender (as far as an application
392  * is concerned).
393  *
394  * This contract is only required for intermediate, library-like contracts.
395  */
396 abstract contract Context {
397     function _msgSender() internal view virtual returns (address) {
398         return msg.sender;
399     }
400 
401     function _msgData() internal view virtual returns (bytes calldata) {
402         return msg.data;
403     }
404 }
405 
406 // File: @openzeppelin/contracts/access/Ownable.sol
407 
408 
409 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
410 
411 pragma solidity ^0.8.0;
412 
413 
414 /**
415  * @dev Contract module which provides a basic access control mechanism, where
416  * there is an account (an owner) that can be granted exclusive access to
417  * specific functions.
418  *
419  * By default, the owner account will be the one that deploys the contract. This
420  * can later be changed with {transferOwnership}.
421  *
422  * This module is used through inheritance. It will make available the modifier
423  * `onlyOwner`, which can be applied to your functions to restrict their use to
424  * the owner.
425  */
426 abstract contract Ownable is Context {
427     address private _owner;
428 
429     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
430 
431     /**
432      * @dev Initializes the contract setting the deployer as the initial owner.
433      */
434     constructor() {
435         _transferOwnership(_msgSender());
436     }
437 
438     /**
439      * @dev Throws if called by any account other than the owner.
440      */
441     modifier onlyOwner() {
442         _checkOwner();
443         _;
444     }
445 
446     /**
447      * @dev Returns the address of the current owner.
448      */
449     function owner() public view virtual returns (address) {
450         return _owner;
451     }
452 
453     /**
454      * @dev Throws if the sender is not the owner.
455      */
456     function _checkOwner() internal view virtual {
457         require(owner() == _msgSender(), "Ownable: caller is not the owner");
458     }
459 
460     /**
461      * @dev Leaves the contract without owner. It will not be possible to call
462      * `onlyOwner` functions anymore. Can only be called by the current owner.
463      *
464      * NOTE: Renouncing ownership will leave the contract without an owner,
465      * thereby removing any functionality that is only available to the owner.
466      */
467     function renounceOwnership() public virtual onlyOwner {
468         _transferOwnership(address(0));
469     }
470 
471     /**
472      * @dev Transfers ownership of the contract to a new account (`newOwner`).
473      * Can only be called by the current owner.
474      */
475     function transferOwnership(address newOwner) public virtual onlyOwner {
476         require(newOwner != address(0), "Ownable: new owner is the zero address");
477         _transferOwnership(newOwner);
478     }
479 
480     /**
481      * @dev Transfers ownership of the contract to a new account (`newOwner`).
482      * Internal function without access restriction.
483      */
484     function _transferOwnership(address newOwner) internal virtual {
485         address oldOwner = _owner;
486         _owner = newOwner;
487         emit OwnershipTransferred(oldOwner, newOwner);
488     }
489 }
490 
491 // File: @openzeppelin/contracts/utils/Address.sol
492 
493 
494 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
495 
496 pragma solidity ^0.8.1;
497 
498 /**
499  * @dev Collection of functions related to the address type
500  */
501 library Address {
502     /**
503      * @dev Returns true if `account` is a contract.
504      *
505      * [IMPORTANT]
506      * ====
507      * It is unsafe to assume that an address for which this function returns
508      * false is an externally-owned account (EOA) and not a contract.
509      *
510      * Among others, `isContract` will return false for the following
511      * types of addresses:
512      *
513      *  - an externally-owned account
514      *  - a contract in construction
515      *  - an address where a contract will be created
516      *  - an address where a contract lived, but was destroyed
517      * ====
518      *
519      * [IMPORTANT]
520      * ====
521      * You shouldn't rely on `isContract` to protect against flash loan attacks!
522      *
523      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
524      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
525      * constructor.
526      * ====
527      */
528     function isContract(address account) internal view returns (bool) {
529         // This method relies on extcodesize/address.code.length, which returns 0
530         // for contracts in construction, since the code is only stored at the end
531         // of the constructor execution.
532 
533         return account.code.length > 0;
534     }
535 
536     /**
537      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
538      * `recipient`, forwarding all available gas and reverting on errors.
539      *
540      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
541      * of certain opcodes, possibly making contracts go over the 2300 gas limit
542      * imposed by `transfer`, making them unable to receive funds via
543      * `transfer`. {sendValue} removes this limitation.
544      *
545      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
546      *
547      * IMPORTANT: because control is transferred to `recipient`, care must be
548      * taken to not create reentrancy vulnerabilities. Consider using
549      * {ReentrancyGuard} or the
550      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
551      */
552     function sendValue(address payable recipient, uint256 amount) internal {
553         require(address(this).balance >= amount, "Address: insufficient balance");
554 
555         (bool success, ) = recipient.call{value: amount}("");
556         require(success, "Address: unable to send value, recipient may have reverted");
557     }
558 
559     /**
560      * @dev Performs a Solidity function call using a low level `call`. A
561      * plain `call` is an unsafe replacement for a function call: use this
562      * function instead.
563      *
564      * If `target` reverts with a revert reason, it is bubbled up by this
565      * function (like regular Solidity function calls).
566      *
567      * Returns the raw returned data. To convert to the expected return value,
568      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
569      *
570      * Requirements:
571      *
572      * - `target` must be a contract.
573      * - calling `target` with `data` must not revert.
574      *
575      * _Available since v3.1._
576      */
577     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
578         return functionCall(target, data, "Address: low-level call failed");
579     }
580 
581     /**
582      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
583      * `errorMessage` as a fallback revert reason when `target` reverts.
584      *
585      * _Available since v3.1._
586      */
587     function functionCall(
588         address target,
589         bytes memory data,
590         string memory errorMessage
591     ) internal returns (bytes memory) {
592         return functionCallWithValue(target, data, 0, errorMessage);
593     }
594 
595     /**
596      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
597      * but also transferring `value` wei to `target`.
598      *
599      * Requirements:
600      *
601      * - the calling contract must have an ETH balance of at least `value`.
602      * - the called Solidity function must be `payable`.
603      *
604      * _Available since v3.1._
605      */
606     function functionCallWithValue(
607         address target,
608         bytes memory data,
609         uint256 value
610     ) internal returns (bytes memory) {
611         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
612     }
613 
614     /**
615      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
616      * with `errorMessage` as a fallback revert reason when `target` reverts.
617      *
618      * _Available since v3.1._
619      */
620     function functionCallWithValue(
621         address target,
622         bytes memory data,
623         uint256 value,
624         string memory errorMessage
625     ) internal returns (bytes memory) {
626         require(address(this).balance >= value, "Address: insufficient balance for call");
627         require(isContract(target), "Address: call to non-contract");
628 
629         (bool success, bytes memory returndata) = target.call{value: value}(data);
630         return verifyCallResult(success, returndata, errorMessage);
631     }
632 
633     /**
634      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
635      * but performing a static call.
636      *
637      * _Available since v3.3._
638      */
639     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
640         return functionStaticCall(target, data, "Address: low-level static call failed");
641     }
642 
643     /**
644      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
645      * but performing a static call.
646      *
647      * _Available since v3.3._
648      */
649     function functionStaticCall(
650         address target,
651         bytes memory data,
652         string memory errorMessage
653     ) internal view returns (bytes memory) {
654         require(isContract(target), "Address: static call to non-contract");
655 
656         (bool success, bytes memory returndata) = target.staticcall(data);
657         return verifyCallResult(success, returndata, errorMessage);
658     }
659 
660     /**
661      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
662      * but performing a delegate call.
663      *
664      * _Available since v3.4._
665      */
666     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
667         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
668     }
669 
670     /**
671      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
672      * but performing a delegate call.
673      *
674      * _Available since v3.4._
675      */
676     function functionDelegateCall(
677         address target,
678         bytes memory data,
679         string memory errorMessage
680     ) internal returns (bytes memory) {
681         require(isContract(target), "Address: delegate call to non-contract");
682 
683         (bool success, bytes memory returndata) = target.delegatecall(data);
684         return verifyCallResult(success, returndata, errorMessage);
685     }
686 
687     /**
688      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
689      * revert reason using the provided one.
690      *
691      * _Available since v4.3._
692      */
693     function verifyCallResult(
694         bool success,
695         bytes memory returndata,
696         string memory errorMessage
697     ) internal pure returns (bytes memory) {
698         if (success) {
699             return returndata;
700         } else {
701             // Look for revert reason and bubble it up if present
702             if (returndata.length > 0) {
703                 // The easiest way to bubble the revert reason is using memory via assembly
704                 /// @solidity memory-safe-assembly
705                 assembly {
706                     let returndata_size := mload(returndata)
707                     revert(add(32, returndata), returndata_size)
708                 }
709             } else {
710                 revert(errorMessage);
711             }
712         }
713     }
714 }
715 
716 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
717 
718 
719 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
720 
721 pragma solidity ^0.8.0;
722 
723 /**
724  * @title ERC721 token receiver interface
725  * @dev Interface for any contract that wants to support safeTransfers
726  * from ERC721 asset contracts.
727  */
728 interface IERC721Receiver {
729     /**
730      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
731      * by `operator` from `from`, this function is called.
732      *
733      * It must return its Solidity selector to confirm the token transfer.
734      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
735      *
736      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
737      */
738     function onERC721Received(
739         address operator,
740         address from,
741         uint256 tokenId,
742         bytes calldata data
743     ) external returns (bytes4);
744 }
745 
746 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
747 
748 
749 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
750 
751 pragma solidity ^0.8.0;
752 
753 /**
754  * @dev Interface of the ERC165 standard, as defined in the
755  * https://eips.ethereum.org/EIPS/eip-165[EIP].
756  *
757  * Implementers can declare support of contract interfaces, which can then be
758  * queried by others ({ERC165Checker}).
759  *
760  * For an implementation, see {ERC165}.
761  */
762 interface IERC165 {
763     /**
764      * @dev Returns true if this contract implements the interface defined by
765      * `interfaceId`. See the corresponding
766      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
767      * to learn more about how these ids are created.
768      *
769      * This function call must use less than 30 000 gas.
770      */
771     function supportsInterface(bytes4 interfaceId) external view returns (bool);
772 }
773 
774 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
775 
776 
777 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
778 
779 pragma solidity ^0.8.0;
780 
781 
782 /**
783  * @dev Implementation of the {IERC165} interface.
784  *
785  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
786  * for the additional interface id that will be supported. For example:
787  *
788  * ```solidity
789  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
790  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
791  * }
792  * ```
793  *
794  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
795  */
796 abstract contract ERC165 is IERC165 {
797     /**
798      * @dev See {IERC165-supportsInterface}.
799      */
800     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
801         return interfaceId == type(IERC165).interfaceId;
802     }
803 }
804 
805 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
806 
807 
808 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
809 
810 pragma solidity ^0.8.0;
811 
812 
813 /**
814  * @dev Required interface of an ERC721 compliant contract.
815  */
816 interface IERC721 is IERC165 {
817     /**
818      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
819      */
820     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
821 
822     /**
823      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
824      */
825     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
826 
827     /**
828      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
829      */
830     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
831 
832     /**
833      * @dev Returns the number of tokens in ``owner``'s account.
834      */
835     function balanceOf(address owner) external view returns (uint256 balance);
836 
837     /**
838      * @dev Returns the owner of the `tokenId` token.
839      *
840      * Requirements:
841      *
842      * - `tokenId` must exist.
843      */
844     function ownerOf(uint256 tokenId) external view returns (address owner);
845 
846     /**
847      * @dev Safely transfers `tokenId` token from `from` to `to`.
848      *
849      * Requirements:
850      *
851      * - `from` cannot be the zero address.
852      * - `to` cannot be the zero address.
853      * - `tokenId` token must exist and be owned by `from`.
854      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
855      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
856      *
857      * Emits a {Transfer} event.
858      */
859     function safeTransferFrom(
860         address from,
861         address to,
862         uint256 tokenId,
863         bytes calldata data
864     ) external;
865 
866     /**
867      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
868      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
869      *
870      * Requirements:
871      *
872      * - `from` cannot be the zero address.
873      * - `to` cannot be the zero address.
874      * - `tokenId` token must exist and be owned by `from`.
875      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
876      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
877      *
878      * Emits a {Transfer} event.
879      */
880     function safeTransferFrom(
881         address from,
882         address to,
883         uint256 tokenId
884     ) external;
885 
886     /**
887      * @dev Transfers `tokenId` token from `from` to `to`.
888      *
889      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
890      *
891      * Requirements:
892      *
893      * - `from` cannot be the zero address.
894      * - `to` cannot be the zero address.
895      * - `tokenId` token must be owned by `from`.
896      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
897      *
898      * Emits a {Transfer} event.
899      */
900     function transferFrom(
901         address from,
902         address to,
903         uint256 tokenId
904     ) external;
905 
906     /**
907      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
908      * The approval is cleared when the token is transferred.
909      *
910      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
911      *
912      * Requirements:
913      *
914      * - The caller must own the token or be an approved operator.
915      * - `tokenId` must exist.
916      *
917      * Emits an {Approval} event.
918      */
919     function approve(address to, uint256 tokenId) external;
920 
921     /**
922      * @dev Approve or remove `operator` as an operator for the caller.
923      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
924      *
925      * Requirements:
926      *
927      * - The `operator` cannot be the caller.
928      *
929      * Emits an {ApprovalForAll} event.
930      */
931     function setApprovalForAll(address operator, bool _approved) external;
932 
933     /**
934      * @dev Returns the account approved for `tokenId` token.
935      *
936      * Requirements:
937      *
938      * - `tokenId` must exist.
939      */
940     function getApproved(uint256 tokenId) external view returns (address operator);
941 
942     /**
943      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
944      *
945      * See {setApprovalForAll}
946      */
947     function isApprovedForAll(address owner, address operator) external view returns (bool);
948 }
949 
950 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
951 
952 
953 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
954 
955 pragma solidity ^0.8.0;
956 
957 
958 /**
959  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
960  * @dev See https://eips.ethereum.org/EIPS/eip-721
961  */
962 interface IERC721Enumerable is IERC721 {
963     /**
964      * @dev Returns the total amount of tokens stored by the contract.
965      */
966     function totalSupply() external view returns (uint256);
967 
968     /**
969      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
970      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
971      */
972     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
973 
974     /**
975      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
976      * Use along with {totalSupply} to enumerate all tokens.
977      */
978     function tokenByIndex(uint256 index) external view returns (uint256);
979 }
980 
981 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
982 
983 
984 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
985 
986 pragma solidity ^0.8.0;
987 
988 
989 /**
990  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
991  * @dev See https://eips.ethereum.org/EIPS/eip-721
992  */
993 interface IERC721Metadata is IERC721 {
994     /**
995      * @dev Returns the token collection name.
996      */
997     function name() external view returns (string memory);
998 
999     /**
1000      * @dev Returns the token collection symbol.
1001      */
1002     function symbol() external view returns (string memory);
1003 
1004     /**
1005      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1006      */
1007     function tokenURI(uint256 tokenId) external view returns (string memory);
1008 }
1009 
1010 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1011 
1012 
1013 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
1014 
1015 pragma solidity ^0.8.0;
1016 
1017 
1018 
1019 
1020 
1021 
1022 
1023 
1024 /**
1025  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1026  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1027  * {ERC721Enumerable}.
1028  */
1029 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1030     using Address for address;
1031     using Strings for uint256;
1032 
1033     // Token name
1034     string private _name;
1035 
1036     // Token symbol
1037     string private _symbol;
1038 
1039     // Mapping from token ID to owner address
1040     mapping(uint256 => address) private _owners;
1041 
1042     // Mapping owner address to token count
1043     mapping(address => uint256) private _balances;
1044 
1045     // Mapping from token ID to approved address
1046     mapping(uint256 => address) private _tokenApprovals;
1047 
1048     // Mapping from owner to operator approvals
1049     mapping(address => mapping(address => bool)) private _operatorApprovals;
1050 
1051     /**
1052      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1053      */
1054     constructor(string memory name_, string memory symbol_) {
1055         _name = name_;
1056         _symbol = symbol_;
1057     }
1058 
1059     /**
1060      * @dev See {IERC165-supportsInterface}.
1061      */
1062     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1063         return
1064             interfaceId == type(IERC721).interfaceId ||
1065             interfaceId == type(IERC721Metadata).interfaceId ||
1066             super.supportsInterface(interfaceId);
1067     }
1068 
1069     /**
1070      * @dev See {IERC721-balanceOf}.
1071      */
1072     function balanceOf(address owner) public view virtual override returns (uint256) {
1073         require(owner != address(0), "ERC721: address zero is not a valid owner");
1074         return _balances[owner];
1075     }
1076 
1077     /**
1078      * @dev See {IERC721-ownerOf}.
1079      */
1080     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1081         address owner = _owners[tokenId];
1082         require(owner != address(0), "ERC721: invalid token ID");
1083         return owner;
1084     }
1085 
1086     /**
1087      * @dev See {IERC721Metadata-name}.
1088      */
1089     function name() public view virtual override returns (string memory) {
1090         return _name;
1091     }
1092 
1093     /**
1094      * @dev See {IERC721Metadata-symbol}.
1095      */
1096     function symbol() public view virtual override returns (string memory) {
1097         return _symbol;
1098     }
1099 
1100     /**
1101      * @dev See {IERC721Metadata-tokenURI}.
1102      */
1103     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1104         _requireMinted(tokenId);
1105 
1106         string memory baseURI = _baseURI();
1107         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1108     }
1109 
1110     /**
1111      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1112      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1113      * by default, can be overridden in child contracts.
1114      */
1115     function _baseURI() internal view virtual returns (string memory) {
1116         return "";
1117     }
1118 
1119     /**
1120      * @dev See {IERC721-approve}.
1121      */
1122     function approve(address to, uint256 tokenId) public virtual override {
1123         address owner = ERC721.ownerOf(tokenId);
1124         require(to != owner, "ERC721: approval to current owner");
1125 
1126         require(
1127             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1128             "ERC721: approve caller is not token owner nor approved for all"
1129         );
1130 
1131         _approve(to, tokenId);
1132     }
1133 
1134     /**
1135      * @dev See {IERC721-getApproved}.
1136      */
1137     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1138         _requireMinted(tokenId);
1139 
1140         return _tokenApprovals[tokenId];
1141     }
1142 
1143     /**
1144      * @dev See {IERC721-setApprovalForAll}.
1145      */
1146     function setApprovalForAll(address operator, bool approved) public virtual override {
1147         _setApprovalForAll(_msgSender(), operator, approved);
1148     }
1149 
1150     /**
1151      * @dev See {IERC721-isApprovedForAll}.
1152      */
1153     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1154         return _operatorApprovals[owner][operator];
1155     }
1156 
1157     /**
1158      * @dev See {IERC721-transferFrom}.
1159      */
1160     function transferFrom(
1161         address from,
1162         address to,
1163         uint256 tokenId
1164     ) public virtual override {
1165         //solhint-disable-next-line max-line-length
1166         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
1167 
1168         _transfer(from, to, tokenId);
1169     }
1170 
1171     /**
1172      * @dev See {IERC721-safeTransferFrom}.
1173      */
1174     function safeTransferFrom(
1175         address from,
1176         address to,
1177         uint256 tokenId
1178     ) public virtual override {
1179         safeTransferFrom(from, to, tokenId, "");
1180     }
1181 
1182     /**
1183      * @dev See {IERC721-safeTransferFrom}.
1184      */
1185     function safeTransferFrom(
1186         address from,
1187         address to,
1188         uint256 tokenId,
1189         bytes memory data
1190     ) public virtual override {
1191         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
1192         _safeTransfer(from, to, tokenId, data);
1193     }
1194 
1195     /**
1196      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1197      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1198      *
1199      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1200      *
1201      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1202      * implement alternative mechanisms to perform token transfer, such as signature-based.
1203      *
1204      * Requirements:
1205      *
1206      * - `from` cannot be the zero address.
1207      * - `to` cannot be the zero address.
1208      * - `tokenId` token must exist and be owned by `from`.
1209      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1210      *
1211      * Emits a {Transfer} event.
1212      */
1213     function _safeTransfer(
1214         address from,
1215         address to,
1216         uint256 tokenId,
1217         bytes memory data
1218     ) internal virtual {
1219         _transfer(from, to, tokenId);
1220         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1221     }
1222 
1223     /**
1224      * @dev Returns whether `tokenId` exists.
1225      *
1226      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1227      *
1228      * Tokens start existing when they are minted (`_mint`),
1229      * and stop existing when they are burned (`_burn`).
1230      */
1231     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1232         return _owners[tokenId] != address(0);
1233     }
1234 
1235     /**
1236      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1237      *
1238      * Requirements:
1239      *
1240      * - `tokenId` must exist.
1241      */
1242     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1243         address owner = ERC721.ownerOf(tokenId);
1244         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1245     }
1246 
1247     /**
1248      * @dev Safely mints `tokenId` and transfers it to `to`.
1249      *
1250      * Requirements:
1251      *
1252      * - `tokenId` must not exist.
1253      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1254      *
1255      * Emits a {Transfer} event.
1256      */
1257     function _safeMint(address to, uint256 tokenId) internal virtual {
1258         _safeMint(to, tokenId, "");
1259     }
1260 
1261     /**
1262      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1263      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1264      */
1265     function _safeMint(
1266         address to,
1267         uint256 tokenId,
1268         bytes memory data
1269     ) internal virtual {
1270         _mint(to, tokenId);
1271         require(
1272             _checkOnERC721Received(address(0), to, tokenId, data),
1273             "ERC721: transfer to non ERC721Receiver implementer"
1274         );
1275     }
1276 
1277     /**
1278      * @dev Mints `tokenId` and transfers it to `to`.
1279      *
1280      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1281      *
1282      * Requirements:
1283      *
1284      * - `tokenId` must not exist.
1285      * - `to` cannot be the zero address.
1286      *
1287      * Emits a {Transfer} event.
1288      */
1289     function _mint(address to, uint256 tokenId) internal virtual {
1290         require(to != address(0), "ERC721: mint to the zero address");
1291         require(!_exists(tokenId), "ERC721: token already minted");
1292 
1293         _beforeTokenTransfer(address(0), to, tokenId);
1294 
1295         _balances[to] += 1;
1296         _owners[tokenId] = to;
1297 
1298         emit Transfer(address(0), to, tokenId);
1299 
1300         _afterTokenTransfer(address(0), to, tokenId);
1301     }
1302 
1303     /**
1304      * @dev Destroys `tokenId`.
1305      * The approval is cleared when the token is burned.
1306      *
1307      * Requirements:
1308      *
1309      * - `tokenId` must exist.
1310      *
1311      * Emits a {Transfer} event.
1312      */
1313     function _burn(uint256 tokenId) internal virtual {
1314         address owner = ERC721.ownerOf(tokenId);
1315 
1316         _beforeTokenTransfer(owner, address(0), tokenId);
1317 
1318         // Clear approvals
1319         _approve(address(0), tokenId);
1320 
1321         _balances[owner] -= 1;
1322         delete _owners[tokenId];
1323 
1324         emit Transfer(owner, address(0), tokenId);
1325 
1326         _afterTokenTransfer(owner, address(0), tokenId);
1327     }
1328 
1329     /**
1330      * @dev Transfers `tokenId` from `from` to `to`.
1331      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1332      *
1333      * Requirements:
1334      *
1335      * - `to` cannot be the zero address.
1336      * - `tokenId` token must be owned by `from`.
1337      *
1338      * Emits a {Transfer} event.
1339      */
1340     function _transfer(
1341         address from,
1342         address to,
1343         uint256 tokenId
1344     ) internal virtual {
1345         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1346         require(to != address(0), "ERC721: transfer to the zero address");
1347 
1348         _beforeTokenTransfer(from, to, tokenId);
1349 
1350         // Clear approvals from the previous owner
1351         _approve(address(0), tokenId);
1352 
1353         _balances[from] -= 1;
1354         _balances[to] += 1;
1355         _owners[tokenId] = to;
1356 
1357         emit Transfer(from, to, tokenId);
1358 
1359         _afterTokenTransfer(from, to, tokenId);
1360     }
1361 
1362     /**
1363      * @dev Approve `to` to operate on `tokenId`
1364      *
1365      * Emits an {Approval} event.
1366      */
1367     function _approve(address to, uint256 tokenId) internal virtual {
1368         _tokenApprovals[tokenId] = to;
1369         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1370     }
1371 
1372     /**
1373      * @dev Approve `operator` to operate on all of `owner` tokens
1374      *
1375      * Emits an {ApprovalForAll} event.
1376      */
1377     function _setApprovalForAll(
1378         address owner,
1379         address operator,
1380         bool approved
1381     ) internal virtual {
1382         require(owner != operator, "ERC721: approve to caller");
1383         _operatorApprovals[owner][operator] = approved;
1384         emit ApprovalForAll(owner, operator, approved);
1385     }
1386 
1387     /**
1388      * @dev Reverts if the `tokenId` has not been minted yet.
1389      */
1390     function _requireMinted(uint256 tokenId) internal view virtual {
1391         require(_exists(tokenId), "ERC721: invalid token ID");
1392     }
1393 
1394     /**
1395      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1396      * The call is not executed if the target address is not a contract.
1397      *
1398      * @param from address representing the previous owner of the given token ID
1399      * @param to target address that will receive the tokens
1400      * @param tokenId uint256 ID of the token to be transferred
1401      * @param data bytes optional data to send along with the call
1402      * @return bool whether the call correctly returned the expected magic value
1403      */
1404     function _checkOnERC721Received(
1405         address from,
1406         address to,
1407         uint256 tokenId,
1408         bytes memory data
1409     ) private returns (bool) {
1410         if (to.isContract()) {
1411             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1412                 return retval == IERC721Receiver.onERC721Received.selector;
1413             } catch (bytes memory reason) {
1414                 if (reason.length == 0) {
1415                     revert("ERC721: transfer to non ERC721Receiver implementer");
1416                 } else {
1417                     /// @solidity memory-safe-assembly
1418                     assembly {
1419                         revert(add(32, reason), mload(reason))
1420                     }
1421                 }
1422             }
1423         } else {
1424             return true;
1425         }
1426     }
1427 
1428     /**
1429      * @dev Hook that is called before any token transfer. This includes minting
1430      * and burning.
1431      *
1432      * Calling conditions:
1433      *
1434      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1435      * transferred to `to`.
1436      * - When `from` is zero, `tokenId` will be minted for `to`.
1437      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1438      * - `from` and `to` are never both zero.
1439      *
1440      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1441      */
1442     function _beforeTokenTransfer(
1443         address from,
1444         address to,
1445         uint256 tokenId
1446     ) internal virtual {}
1447 
1448     /**
1449      * @dev Hook that is called after any transfer of tokens. This includes
1450      * minting and burning.
1451      *
1452      * Calling conditions:
1453      *
1454      * - when `from` and `to` are both non-zero.
1455      * - `from` and `to` are never both zero.
1456      *
1457      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1458      */
1459     function _afterTokenTransfer(
1460         address from,
1461         address to,
1462         uint256 tokenId
1463     ) internal virtual {}
1464 }
1465 
1466 // File: contracts/erc721a.sol
1467 
1468 pragma solidity ^0.8.11;
1469 
1470 
1471 
1472 
1473 /**
1474  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1475  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1476  *
1477  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
1478  *
1479  * Does not support burning tokens to address(0).
1480  *
1481  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
1482  */
1483 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1484     using Address for address;
1485     using Strings for uint256;
1486 
1487     struct TokenOwnership {
1488         address addr;
1489         uint64 startTimestamp;
1490     }
1491 
1492     struct AddressData {
1493         uint128 balance;
1494         uint128 numberMinted;
1495     }
1496 
1497     uint256 internal currentIndex;
1498 
1499     // Token name
1500     string private _name;
1501 
1502     // Token symbol
1503     string private _symbol;
1504 
1505     // Mapping from token ID to ownership details
1506     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1507     mapping(uint256 => TokenOwnership) internal _ownerships;
1508 
1509     // Mapping owner address to address data
1510     mapping(address => AddressData) private _addressData;
1511 
1512     // Mapping from token ID to approved address
1513     mapping(uint256 => address) private _tokenApprovals;
1514 
1515     // Mapping from owner to operator approvals
1516     mapping(address => mapping(address => bool)) private _operatorApprovals;
1517 
1518     constructor(string memory name_, string memory symbol_) {
1519         _name = name_;
1520         _symbol = symbol_;
1521     }
1522 
1523     /**
1524      * @dev See {IERC721Enumerable-totalSupply}.
1525      */
1526     function totalSupply() public view override returns (uint256) {
1527         return currentIndex;
1528     }
1529 
1530     /**
1531      * @dev See {IERC721Enumerable-tokenByIndex}.
1532      */
1533     function tokenByIndex(uint256 index) public view override returns (uint256) {
1534         require(index < totalSupply(), "ERC721A: global index out of bounds");
1535         return index;
1536     }
1537 
1538     /**
1539      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1540      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1541      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1542      */
1543     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1544         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1545         uint256 numMintedSoFar = totalSupply();
1546         uint256 tokenIdsIdx;
1547         address currOwnershipAddr;
1548 
1549         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
1550         unchecked {
1551             for (uint256 i; i < numMintedSoFar; i++) {
1552                 TokenOwnership memory ownership = _ownerships[i];
1553                 if (ownership.addr != address(0)) {
1554                     currOwnershipAddr = ownership.addr;
1555                 }
1556                 if (currOwnershipAddr == owner) {
1557                     if (tokenIdsIdx == index) {
1558                         return i;
1559                     }
1560                     tokenIdsIdx++;
1561                 }
1562             }
1563         }
1564 
1565         revert("ERC721A: unable to get token of owner by index");
1566     }
1567 
1568     /**
1569      * @dev See {IERC165-supportsInterface}.
1570      */
1571     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1572         return
1573             interfaceId == type(IERC721).interfaceId ||
1574             interfaceId == type(IERC721Metadata).interfaceId ||
1575             interfaceId == type(IERC721Enumerable).interfaceId ||
1576             super.supportsInterface(interfaceId);
1577     }
1578 
1579     /**
1580      * @dev See {IERC721-balanceOf}.
1581      */
1582     function balanceOf(address owner) public view override returns (uint256) {
1583         require(owner != address(0), "ERC721A: balance query for the zero address");
1584         return uint256(_addressData[owner].balance);
1585     }
1586 
1587     function _numberMinted(address owner) internal view returns (uint256) {
1588         require(owner != address(0), "ERC721A: number minted query for the zero address");
1589         return uint256(_addressData[owner].numberMinted);
1590     }
1591 
1592     /**
1593      * Gas spent here starts off proportional to the maximum mint batch size.
1594      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1595      */
1596     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1597         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1598 
1599         unchecked {
1600             for (uint256 curr = tokenId; curr >= 0; curr--) {
1601                 TokenOwnership memory ownership = _ownerships[curr];
1602                 if (ownership.addr != address(0)) {
1603                     return ownership;
1604                 }
1605             }
1606         }
1607 
1608         revert("ERC721A: unable to determine the owner of token");
1609     }
1610 
1611     /**
1612      * @dev See {IERC721-ownerOf}.
1613      */
1614     function ownerOf(uint256 tokenId) public view override returns (address) {
1615         return ownershipOf(tokenId).addr;
1616     }
1617 
1618     /**
1619      * @dev See {IERC721Metadata-name}.
1620      */
1621     function name() public view virtual override returns (string memory) {
1622         return _name;
1623     }
1624 
1625     /**
1626      * @dev See {IERC721Metadata-symbol}.
1627      */
1628     function symbol() public view virtual override returns (string memory) {
1629         return _symbol;
1630     }
1631 
1632     /**
1633      * @dev See {IERC721Metadata-tokenURI}.
1634      */
1635     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1636         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1637 
1638         string memory baseURI = _baseURI();
1639         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1640     }
1641 
1642     /**
1643      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1644      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1645      * by default, can be overriden in child contracts.
1646      */
1647     function _baseURI() internal view virtual returns (string memory) {
1648         return "";
1649     }
1650 
1651     /**
1652      * @dev See {IERC721-approve}.
1653      */
1654     function approve(address to, uint256 tokenId) public override {
1655         address owner = ERC721A.ownerOf(tokenId);
1656         require(to != owner, "ERC721A: approval to current owner");
1657 
1658         require(
1659             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1660             "ERC721A: approve caller is not owner nor approved for all"
1661         );
1662 
1663         _approve(to, tokenId, owner);
1664     }
1665 
1666     /**
1667      * @dev See {IERC721-getApproved}.
1668      */
1669     function getApproved(uint256 tokenId) public view override returns (address) {
1670         require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1671 
1672         return _tokenApprovals[tokenId];
1673     }
1674 
1675     /**
1676      * @dev See {IERC721-setApprovalForAll}.
1677      */
1678     function setApprovalForAll(address operator, bool approved) public override {
1679         require(operator != _msgSender(), "ERC721A: approve to caller");
1680 
1681         _operatorApprovals[_msgSender()][operator] = approved;
1682         emit ApprovalForAll(_msgSender(), operator, approved);
1683     }
1684 
1685     /**
1686      * @dev See {IERC721-isApprovedForAll}.
1687      */
1688     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1689         return _operatorApprovals[owner][operator];
1690     }
1691 
1692     /**
1693      * @dev See {IERC721-transferFrom}.
1694      */
1695     function transferFrom(
1696         address from,
1697         address to,
1698         uint256 tokenId
1699     ) public virtual override {
1700         _transfer(from, to, tokenId);
1701     }
1702 
1703     /**
1704      * @dev See {IERC721-safeTransferFrom}.
1705      */
1706     function safeTransferFrom(
1707         address from,
1708         address to,
1709         uint256 tokenId
1710     ) public virtual override {
1711         safeTransferFrom(from, to, tokenId, "");
1712     }
1713 
1714     /**
1715      * @dev See {IERC721-safeTransferFrom}.
1716      */
1717     function safeTransferFrom(
1718         address from,
1719         address to,
1720         uint256 tokenId,
1721         bytes memory _data
1722     ) public override {
1723         _transfer(from, to, tokenId);
1724         require(
1725             _checkOnERC721Received(from, to, tokenId, _data),
1726             "ERC721A: transfer to non ERC721Receiver implementer"
1727         );
1728     }
1729 
1730     /**
1731      * @dev Returns whether `tokenId` exists.
1732      *
1733      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1734      *
1735      * Tokens start existing when they are minted (`_mint`),
1736      */
1737     function _exists(uint256 tokenId) internal view returns (bool) {
1738         return tokenId < currentIndex;
1739     }
1740 
1741     function _safeMint(address to, uint256 quantity) internal {
1742         _safeMint(to, quantity, "");
1743     }
1744 
1745     /**
1746      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1747      *
1748      * Requirements:
1749      *
1750      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1751      * - `quantity` must be greater than 0.
1752      *
1753      * Emits a {Transfer} event.
1754      */
1755     function _safeMint(
1756         address to,
1757         uint256 quantity,
1758         bytes memory _data
1759     ) internal {
1760         _mint(to, quantity, _data, true);
1761     }
1762 
1763     /**
1764      * @dev Mints `quantity` tokens and transfers them to `to`.
1765      *
1766      * Requirements:
1767      *
1768      * - `to` cannot be the zero address.
1769      * - `quantity` must be greater than 0.
1770      *
1771      * Emits a {Transfer} event.
1772      */
1773     function _mint(
1774         address to,
1775         uint256 quantity,
1776         bytes memory _data,
1777         bool safe
1778     ) internal {
1779         uint256 startTokenId = currentIndex;
1780         require(to != address(0), "ERC721A: mint to the zero address");
1781         require(quantity != 0, "ERC721A: quantity must be greater than 0");
1782 
1783         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1784 
1785         // Overflows are incredibly unrealistic.
1786         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1787         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1788         unchecked {
1789             _addressData[to].balance += uint128(quantity);
1790             _addressData[to].numberMinted += uint128(quantity);
1791 
1792             _ownerships[startTokenId].addr = to;
1793             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1794 
1795             uint256 updatedIndex = startTokenId;
1796 
1797             for (uint256 i; i < quantity; i++) {
1798                 emit Transfer(address(0), to, updatedIndex);
1799                 if (safe) {
1800                     require(
1801                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1802                         "ERC721A: transfer to non ERC721Receiver implementer"
1803                     );
1804                 }
1805 
1806                 updatedIndex++;
1807             }
1808 
1809             currentIndex = updatedIndex;
1810         }
1811 
1812         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1813     }
1814 
1815     /**
1816      * @dev Transfers `tokenId` from `from` to `to`.
1817      *
1818      * Requirements:
1819      *
1820      * - `to` cannot be the zero address.
1821      * - `tokenId` token must be owned by `from`.
1822      *
1823      * Emits a {Transfer} event.
1824      */
1825     function _transfer(
1826         address from,
1827         address to,
1828         uint256 tokenId
1829     ) private {
1830         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1831 
1832         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1833             getApproved(tokenId) == _msgSender() ||
1834             isApprovedForAll(prevOwnership.addr, _msgSender()));
1835 
1836         require(isApprovedOrOwner, "ERC721A: transfer caller is not owner nor approved");
1837 
1838         require(prevOwnership.addr == from, "ERC721A: transfer from incorrect owner");
1839         require(to != address(0), "ERC721A: transfer to the zero address");
1840 
1841         _beforeTokenTransfers(from, to, tokenId, 1);
1842 
1843         // Clear approvals from the previous owner
1844         _approve(address(0), tokenId, prevOwnership.addr);
1845 
1846         // Underflow of the sender's balance is impossible because we check for
1847         // ownership above and the recipient's balance can't realistically overflow.
1848         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1849         unchecked {
1850             _addressData[from].balance -= 1;
1851             _addressData[to].balance += 1;
1852 
1853             _ownerships[tokenId].addr = to;
1854             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1855 
1856             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1857             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1858             uint256 nextTokenId = tokenId + 1;
1859             if (_ownerships[nextTokenId].addr == address(0)) {
1860                 if (_exists(nextTokenId)) {
1861                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1862                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1863                 }
1864             }
1865         }
1866 
1867         emit Transfer(from, to, tokenId);
1868         _afterTokenTransfers(from, to, tokenId, 1);
1869     }
1870 
1871     /**
1872      * @dev Approve `to` to operate on `tokenId`
1873      *
1874      * Emits a {Approval} event.
1875      */
1876     function _approve(
1877         address to,
1878         uint256 tokenId,
1879         address owner
1880     ) private {
1881         _tokenApprovals[tokenId] = to;
1882         emit Approval(owner, to, tokenId);
1883     }
1884 
1885     /**
1886      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1887      * The call is not executed if the target address is not a contract.
1888      *
1889      * @param from address representing the previous owner of the given token ID
1890      * @param to target address that will receive the tokens
1891      * @param tokenId uint256 ID of the token to be transferred
1892      * @param _data bytes optional data to send along with the call
1893      * @return bool whether the call correctly returned the expected magic value
1894      */
1895     function _checkOnERC721Received(
1896         address from,
1897         address to,
1898         uint256 tokenId,
1899         bytes memory _data
1900     ) private returns (bool) {
1901         if (to.isContract()) {
1902             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1903                 return retval == IERC721Receiver(to).onERC721Received.selector;
1904             } catch (bytes memory reason) {
1905                 if (reason.length == 0) {
1906                     revert("ERC721A: transfer to non ERC721Receiver implementer");
1907                 } else {
1908                     assembly {
1909                         revert(add(32, reason), mload(reason))
1910                     }
1911                 }
1912             }
1913         } else {
1914             return true;
1915         }
1916     }
1917 
1918     /**
1919      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1920      *
1921      * startTokenId - the first token id to be transferred
1922      * quantity - the amount to be transferred
1923      *
1924      * Calling conditions:
1925      *
1926      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1927      * transferred to `to`.
1928      * - When `from` is zero, `tokenId` will be minted for `to`.
1929      */
1930     function _beforeTokenTransfers(
1931         address from,
1932         address to,
1933         uint256 startTokenId,
1934         uint256 quantity
1935     ) internal virtual {}
1936 
1937     /**
1938      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1939      * minting.
1940      *
1941      * startTokenId - the first token id to be transferred
1942      * quantity - the amount to be transferred
1943      *
1944      * Calling conditions:
1945      *
1946      * - when `from` and `to` are both non-zero.
1947      * - `from` and `to` are never both zero.
1948      */
1949     function _afterTokenTransfers(
1950         address from,
1951         address to,
1952         uint256 startTokenId,
1953         uint256 quantity
1954     ) internal virtual {}
1955 }
1956 // File: contracts/banana.sol
1957 
1958 pragma solidity ^0.8.11;
1959 
1960 
1961 
1962 
1963 
1964 
1965 
1966 contract Banana is ERC721A, Ownable, ReentrancyGuard {
1967 
1968     using ECDSA for bytes32;
1969 
1970     address private      systemAddress;
1971     address private      kongAddress;
1972     string public        hiddenURI;
1973     string public        baseURI;
1974     uint public          price             = 0.08 ether;
1975     uint public          maxPerWallet      = 2;
1976     uint public          teamSupply        = 0;
1977     uint public          whitelistSupply   = 1000;
1978     uint public          kongSupply        = 2000;
1979     uint public          maxSupply         = 3000;
1980     uint public          mintType          = 2; // 1 - team, 2 - whitelist, 3 - kong owners, 4 - public
1981     uint public          mintedKong        = 0;
1982     uint public          nextOwnerToExplicitlySet;
1983     bool public          mintEnabled;
1984     bool public          revealed;
1985 
1986     mapping(string => bool) public _usedNonces;
1987     mapping(address => uint256[]) public _kongOwners;
1988     mapping(uint256 => bool) public _redeemedKongIds;
1989 
1990     constructor(address _kongAddress, address _systemAddress) ERC721A("Banana", "BANANA"){
1991         kongAddress = _kongAddress;
1992         systemAddress = _systemAddress;
1993     }
1994 
1995     function teamMint(address to, uint256 numberOfTokens) external onlyOwner {
1996         require(mintEnabled, "mint disabled");
1997         require(mintType == 1, "team minting is not allowed");
1998         require(totalSupply() + numberOfTokens < teamSupply + 1, "team supply is sold out!");
1999         
2000         _safeMint(to, numberOfTokens);
2001     }
2002 
2003     function whitelistMint(address to, uint256 numberOfTokens, string memory nonce, bytes32 hash, bytes memory signature) external payable {
2004         uint cost = price;
2005         require(mintEnabled, "mint disabled");
2006         require(mintType == 2, "whitelist minting is not allowed");
2007         require(totalSupply() + numberOfTokens < teamSupply + whitelistSupply + 1, "whitelist supply is sold out!");
2008         require(numberMinted(msg.sender) + numberOfTokens <= maxPerWallet, "too many per wallet");
2009         require(msg.value >= numberOfTokens * cost, "ether is not enough");
2010         // signature verification
2011         require(matchSigner(hash, signature), "please mint through website");
2012         require(!_usedNonces[nonce], "hash reused");
2013         require(hashTransaction(msg.sender, numberOfTokens, nonce) == hash, "hash failed"); 
2014 
2015         _usedNonces[nonce] = true;
2016         _safeMint(to, numberOfTokens);
2017     }
2018 
2019     function kongMint(address to) external {
2020         require(mintEnabled, "mint disabled");
2021         require(mintType == 3, "kong minting is not allowed");
2022 
2023         uint toMint = 0;
2024  
2025         if(_kongOwners[msg.sender].length > 0) {
2026             uint kongsOwned = _kongOwners[msg.sender].length; // we check their kongs
2027             for (uint i = 0; i < kongsOwned; i++) {
2028                 uint256 tokenId = _kongOwners[msg.sender][i];
2029                 if (!_redeemedKongIds[tokenId]) { 
2030                     toMint++;
2031                     _redeemedKongIds[tokenId] = true;
2032                 }
2033             }
2034             mintedKong = mintedKong + toMint;
2035         } else {
2036             require(IERC721(kongAddress).balanceOf(msg.sender) > 0, "only supreme kong owners are able to mint");
2037             uint kongsOwned = IERC721(kongAddress).balanceOf(msg.sender); // we check their kongs
2038             for (uint i = 0; i < kongsOwned; i++) {
2039                 uint256 tokenId = IERC721Enumerable(kongAddress).tokenOfOwnerByIndex(msg.sender, i);
2040                 if (!_redeemedKongIds[tokenId]) { 
2041                     toMint++;
2042                     _redeemedKongIds[tokenId] = true;
2043                 }
2044             }
2045             mintedKong = mintedKong + toMint;
2046         }
2047 
2048         require(toMint > 0, "no redeemable kongs");
2049         _safeMint(to, toMint);
2050     }
2051 
2052     function publicMint(address to, uint256 numberOfTokens) external payable {
2053         uint cost = price;
2054         require(mintEnabled, "mint disabled");
2055         require(mintType == 4, "public minting is not allowed");
2056         require(totalSupply() + numberOfTokens < maxSupply + 1, "we're sold out!");
2057         require(numberMinted(msg.sender) + numberOfTokens <= maxPerWallet, "too many per wallet");
2058         require(msg.value >= numberOfTokens * cost, "ether is not enough");
2059 
2060         _safeMint(to, numberOfTokens);
2061     }
2062 
2063     function toggleMinting() external onlyOwner {
2064         mintEnabled = !mintEnabled;
2065     }
2066 
2067     function toggleRevealed() external onlyOwner {
2068         revealed = !revealed;
2069     }
2070 
2071     function kongOwnedAmount(address owner) public view returns (uint256) {
2072         uint kongsOwned = _kongOwners[owner].length; // we check their kongs
2073         uint kongsOwnedByContract = IERC721(kongAddress).balanceOf(owner); // we check their kongs
2074         uint toMint = 0;
2075         if(kongsOwned > 0){
2076             for (uint i = 0; i < kongsOwned; i++) {
2077                 uint256 tokenId = _kongOwners[owner][i];
2078                 if (!_redeemedKongIds[tokenId]) { 
2079                     toMint++;
2080                 }
2081             }
2082         }
2083         if(kongsOwnedByContract > 0){
2084             for (uint i = 0; i < kongsOwnedByContract; i++) {
2085                 uint256 tokenId = IERC721Enumerable(kongAddress).tokenOfOwnerByIndex(owner, i);
2086                 if (!_redeemedKongIds[tokenId]) { 
2087                     toMint++;
2088                 }
2089             }
2090         }
2091 
2092         return toMint;
2093     }
2094 
2095     function numberMinted(address owner) public view returns (uint256) {
2096         return _numberMinted(owner);
2097     }
2098 
2099     function addKongOwner(address owner, uint[] memory tokenIds) external onlyOwner {
2100         _kongOwners[owner] = tokenIds;
2101     }
2102 
2103     function setHiddenURI(string calldata hiddenURI_) external onlyOwner {
2104         hiddenURI = hiddenURI_;
2105     }
2106 
2107     function setBaseURI(string calldata baseURI_) external onlyOwner {
2108         baseURI = baseURI_;
2109     }
2110 
2111     function tokenURI(uint256 tokenId) public view override returns (string memory) {
2112         require(_exists(tokenId), "banana does not exist");
2113 
2114         if (revealed) {
2115             return baseURI;
2116         }
2117         return hiddenURI;
2118     }
2119 
2120     function setPrice(uint256 price_) external onlyOwner {
2121         price = price_;
2122     }
2123 
2124     function setMaxPerWallet(uint256 maxPerWallet_) external onlyOwner {
2125         maxPerWallet = maxPerWallet_;
2126     }
2127 
2128     function setMintType(uint256 mintType_) external onlyOwner {
2129         mintType = mintType_;
2130     }
2131 
2132     function _baseURI() internal view virtual override returns (string memory) {
2133         return baseURI;
2134     }
2135 
2136     function _kongOwnersLength() external view returns (uint) {
2137         return _kongOwners[msg.sender].length;
2138     }
2139 
2140     function withdraw() external onlyOwner nonReentrant {
2141         (bool success, ) = msg.sender.call{value: address(this).balance}("");
2142         require(success, "transfer failed");
2143     }
2144 
2145     function setOwnersExplicit(uint256 quantity) external onlyOwner nonReentrant {
2146         _setOwnersExplicit(quantity);
2147     }
2148 
2149     function getOwnershipData(uint256 tokenId) external view returns (TokenOwnership memory) {
2150         return ownershipOf(tokenId);
2151     }
2152 
2153     function matchSigner(bytes32 hash, bytes memory signature) public view returns (bool) {
2154         return systemAddress == hash.toEthSignedMessageHash().recover(signature);
2155     }
2156 
2157     function hashTransaction(
2158     address sender,
2159     uint256 amount,
2160     string memory nonce
2161     ) public view returns (bytes32) {
2162     
2163         bytes32 hash = keccak256(
2164         abi.encodePacked(sender, amount, nonce, address(this))
2165         );
2166 
2167         return hash;
2168     }
2169 
2170     /**
2171      * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
2172      */
2173     function _setOwnersExplicit(uint256 quantity) internal {
2174         require(quantity != 0, "quantity must be nonzero");
2175         require(currentIndex != 0, "no tokens minted yet");
2176         uint256 _nextOwnerToExplicitlySet = nextOwnerToExplicitlySet;
2177         require(_nextOwnerToExplicitlySet < currentIndex, "all ownerships have been set");
2178 
2179         // Index underflow is impossible.
2180         // Counter or index overflow is incredibly unrealistic.
2181         unchecked {
2182             uint256 endIndex = _nextOwnerToExplicitlySet + quantity - 1;
2183 
2184             // Set the end index to be the last token index
2185             if (endIndex + 1 > currentIndex) {
2186                 endIndex = currentIndex - 1;
2187             }
2188 
2189             for (uint256 i = _nextOwnerToExplicitlySet; i <= endIndex; i++) {
2190                 if (_ownerships[i].addr == address(0)) {
2191                     TokenOwnership memory ownership = ownershipOf(i);
2192                     _ownerships[i].addr = ownership.addr;
2193                     _ownerships[i].startTimestamp = ownership.startTimestamp;
2194                 }
2195             }
2196 
2197             nextOwnerToExplicitlySet = endIndex + 1;
2198         }
2199     }
2200 }