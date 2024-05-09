1 // SPDX-License-Identifier: GPL-3.0
2 
3 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
4 
5 
6 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Contract module that helps prevent reentrant calls to a function.
12  *
13  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
14  * available, which can be applied to functions to make sure there are no nested
15  * (reentrant) calls to them.
16  *
17  * Note that because there is a single `nonReentrant` guard, functions marked as
18  * `nonReentrant` may not call one another. This can be worked around by making
19  * those functions `private`, and then adding `external` `nonReentrant` entry
20  * points to them.
21  *
22  * TIP: If you would like to learn more about reentrancy and alternative ways
23  * to protect against it, check out our blog post
24  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
25  */
26 abstract contract ReentrancyGuard {
27     // Booleans are more expensive than uint256 or any type that takes up a full
28     // word because each write operation emits an extra SLOAD to first read the
29     // slot's contents, replace the bits taken up by the boolean, and then write
30     // back. This is the compiler's defense against contract upgrades and
31     // pointer aliasing, and it cannot be disabled.
32 
33     // The values being non-zero value makes deployment a bit more expensive,
34     // but in exchange the refund on every call to nonReentrant will be lower in
35     // amount. Since refunds are capped to a percentage of the total
36     // transaction's gas, it is best to keep them low in cases like this one, to
37     // increase the likelihood of the full refund coming into effect.
38     uint256 private constant _NOT_ENTERED = 1;
39     uint256 private constant _ENTERED = 2;
40 
41     uint256 private _status;
42 
43     constructor() {
44         _status = _NOT_ENTERED;
45     }
46 
47     /**
48      * @dev Prevents a contract from calling itself, directly or indirectly.
49      * Calling a `nonReentrant` function from another `nonReentrant`
50      * function is not supported. It is possible to prevent this from happening
51      * by making the `nonReentrant` function external, and making it call a
52      * `private` function that does the actual work.
53      */
54     modifier nonReentrant() {
55         // On the first call to nonReentrant, _notEntered will be true
56         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
57 
58         // Any calls to nonReentrant after this point will fail
59         _status = _ENTERED;
60 
61         _;
62 
63         // By storing the original value once again, a refund is triggered (see
64         // https://eips.ethereum.org/EIPS/eip-2200)
65         _status = _NOT_ENTERED;
66     }
67 }
68 
69 // File: @openzeppelin/contracts/utils/Strings.sol
70 
71 
72 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
73 
74 pragma solidity ^0.8.0;
75 
76 /**
77  * @dev String operations.
78  */
79 library Strings {
80     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
81     uint8 private constant _ADDRESS_LENGTH = 20;
82 
83     /**
84      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
85      */
86     function toString(uint256 value) internal pure returns (string memory) {
87         // Inspired by OraclizeAPI's implementation - MIT licence
88         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
89 
90         if (value == 0) {
91             return "0";
92         }
93         uint256 temp = value;
94         uint256 digits;
95         while (temp != 0) {
96             digits++;
97             temp /= 10;
98         }
99         bytes memory buffer = new bytes(digits);
100         while (value != 0) {
101             digits -= 1;
102             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
103             value /= 10;
104         }
105         return string(buffer);
106     }
107 
108     /**
109      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
110      */
111     function toHexString(uint256 value) internal pure returns (string memory) {
112         if (value == 0) {
113             return "0x00";
114         }
115         uint256 temp = value;
116         uint256 length = 0;
117         while (temp != 0) {
118             length++;
119             temp >>= 8;
120         }
121         return toHexString(value, length);
122     }
123 
124     /**
125      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
126      */
127     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
128         bytes memory buffer = new bytes(2 * length + 2);
129         buffer[0] = "0";
130         buffer[1] = "x";
131         for (uint256 i = 2 * length + 1; i > 1; --i) {
132             buffer[i] = _HEX_SYMBOLS[value & 0xf];
133             value >>= 4;
134         }
135         require(value == 0, "Strings: hex length insufficient");
136         return string(buffer);
137     }
138 
139     /**
140      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
141      */
142     function toHexString(address addr) internal pure returns (string memory) {
143         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
144     }
145 }
146 
147 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
148 
149 
150 // OpenZeppelin Contracts (last updated v4.7.3) (utils/cryptography/ECDSA.sol)
151 
152 pragma solidity ^0.8.0;
153 
154 
155 /**
156  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
157  *
158  * These functions can be used to verify that a message was signed by the holder
159  * of the private keys of a given address.
160  */
161 library ECDSA {
162     enum RecoverError {
163         NoError,
164         InvalidSignature,
165         InvalidSignatureLength,
166         InvalidSignatureS,
167         InvalidSignatureV
168     }
169 
170     function _throwError(RecoverError error) private pure {
171         if (error == RecoverError.NoError) {
172             return; // no error: do nothing
173         } else if (error == RecoverError.InvalidSignature) {
174             revert("ECDSA: invalid signature");
175         } else if (error == RecoverError.InvalidSignatureLength) {
176             revert("ECDSA: invalid signature length");
177         } else if (error == RecoverError.InvalidSignatureS) {
178             revert("ECDSA: invalid signature 's' value");
179         } else if (error == RecoverError.InvalidSignatureV) {
180             revert("ECDSA: invalid signature 'v' value");
181         }
182     }
183 
184     /**
185      * @dev Returns the address that signed a hashed message (`hash`) with
186      * `signature` or error string. This address can then be used for verification purposes.
187      *
188      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
189      * this function rejects them by requiring the `s` value to be in the lower
190      * half order, and the `v` value to be either 27 or 28.
191      *
192      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
193      * verification to be secure: it is possible to craft signatures that
194      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
195      * this is by receiving a hash of the original message (which may otherwise
196      * be too long), and then calling {toEthSignedMessageHash} on it.
197      *
198      * Documentation for signature generation:
199      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
200      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
201      *
202      * _Available since v4.3._
203      */
204     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
205         if (signature.length == 65) {
206             bytes32 r;
207             bytes32 s;
208             uint8 v;
209             // ecrecover takes the signature parameters, and the only way to get them
210             // currently is to use assembly.
211             /// @solidity memory-safe-assembly
212             assembly {
213                 r := mload(add(signature, 0x20))
214                 s := mload(add(signature, 0x40))
215                 v := byte(0, mload(add(signature, 0x60)))
216             }
217             return tryRecover(hash, v, r, s);
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
397 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
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
427      * @dev Throws if called by any account other than the owner.
428      */
429     modifier onlyOwner() {
430         _checkOwner();
431         _;
432     }
433 
434     /**
435      * @dev Returns the address of the current owner.
436      */
437     function owner() public view virtual returns (address) {
438         return _owner;
439     }
440 
441     /**
442      * @dev Throws if the sender is not the owner.
443      */
444     function _checkOwner() internal view virtual {
445         require(owner() == _msgSender(), "Ownable: caller is not the owner");
446     }
447 
448     /**
449      * @dev Leaves the contract without owner. It will not be possible to call
450      * `onlyOwner` functions anymore. Can only be called by the current owner.
451      *
452      * NOTE: Renouncing ownership will leave the contract without an owner,
453      * thereby removing any functionality that is only available to the owner.
454      */
455     function renounceOwnership() public virtual onlyOwner {
456         _transferOwnership(address(0));
457     }
458 
459     /**
460      * @dev Transfers ownership of the contract to a new account (`newOwner`).
461      * Can only be called by the current owner.
462      */
463     function transferOwnership(address newOwner) public virtual onlyOwner {
464         require(newOwner != address(0), "Ownable: new owner is the zero address");
465         _transferOwnership(newOwner);
466     }
467 
468     /**
469      * @dev Transfers ownership of the contract to a new account (`newOwner`).
470      * Internal function without access restriction.
471      */
472     function _transferOwnership(address newOwner) internal virtual {
473         address oldOwner = _owner;
474         _owner = newOwner;
475         emit OwnershipTransferred(oldOwner, newOwner);
476     }
477 }
478 
479 // File: @openzeppelin/contracts/utils/Address.sol
480 
481 
482 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
483 
484 pragma solidity ^0.8.1;
485 
486 /**
487  * @dev Collection of functions related to the address type
488  */
489 library Address {
490     /**
491      * @dev Returns true if `account` is a contract.
492      *
493      * [IMPORTANT]
494      * ====
495      * It is unsafe to assume that an address for which this function returns
496      * false is an externally-owned account (EOA) and not a contract.
497      *
498      * Among others, `isContract` will return false for the following
499      * types of addresses:
500      *
501      *  - an externally-owned account
502      *  - a contract in construction
503      *  - an address where a contract will be created
504      *  - an address where a contract lived, but was destroyed
505      * ====
506      *
507      * [IMPORTANT]
508      * ====
509      * You shouldn't rely on `isContract` to protect against flash loan attacks!
510      *
511      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
512      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
513      * constructor.
514      * ====
515      */
516     function isContract(address account) internal view returns (bool) {
517         // This method relies on extcodesize/address.code.length, which returns 0
518         // for contracts in construction, since the code is only stored at the end
519         // of the constructor execution.
520 
521         return account.code.length > 0;
522     }
523 
524     /**
525      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
526      * `recipient`, forwarding all available gas and reverting on errors.
527      *
528      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
529      * of certain opcodes, possibly making contracts go over the 2300 gas limit
530      * imposed by `transfer`, making them unable to receive funds via
531      * `transfer`. {sendValue} removes this limitation.
532      *
533      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
534      *
535      * IMPORTANT: because control is transferred to `recipient`, care must be
536      * taken to not create reentrancy vulnerabilities. Consider using
537      * {ReentrancyGuard} or the
538      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
539      */
540     function sendValue(address payable recipient, uint256 amount) internal {
541         require(address(this).balance >= amount, "Address: insufficient balance");
542 
543         (bool success, ) = recipient.call{value: amount}("");
544         require(success, "Address: unable to send value, recipient may have reverted");
545     }
546 
547     /**
548      * @dev Performs a Solidity function call using a low level `call`. A
549      * plain `call` is an unsafe replacement for a function call: use this
550      * function instead.
551      *
552      * If `target` reverts with a revert reason, it is bubbled up by this
553      * function (like regular Solidity function calls).
554      *
555      * Returns the raw returned data. To convert to the expected return value,
556      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
557      *
558      * Requirements:
559      *
560      * - `target` must be a contract.
561      * - calling `target` with `data` must not revert.
562      *
563      * _Available since v3.1._
564      */
565     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
566         return functionCall(target, data, "Address: low-level call failed");
567     }
568 
569     /**
570      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
571      * `errorMessage` as a fallback revert reason when `target` reverts.
572      *
573      * _Available since v3.1._
574      */
575     function functionCall(
576         address target,
577         bytes memory data,
578         string memory errorMessage
579     ) internal returns (bytes memory) {
580         return functionCallWithValue(target, data, 0, errorMessage);
581     }
582 
583     /**
584      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
585      * but also transferring `value` wei to `target`.
586      *
587      * Requirements:
588      *
589      * - the calling contract must have an ETH balance of at least `value`.
590      * - the called Solidity function must be `payable`.
591      *
592      * _Available since v3.1._
593      */
594     function functionCallWithValue(
595         address target,
596         bytes memory data,
597         uint256 value
598     ) internal returns (bytes memory) {
599         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
600     }
601 
602     /**
603      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
604      * with `errorMessage` as a fallback revert reason when `target` reverts.
605      *
606      * _Available since v3.1._
607      */
608     function functionCallWithValue(
609         address target,
610         bytes memory data,
611         uint256 value,
612         string memory errorMessage
613     ) internal returns (bytes memory) {
614         require(address(this).balance >= value, "Address: insufficient balance for call");
615         require(isContract(target), "Address: call to non-contract");
616 
617         (bool success, bytes memory returndata) = target.call{value: value}(data);
618         return verifyCallResult(success, returndata, errorMessage);
619     }
620 
621     /**
622      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
623      * but performing a static call.
624      *
625      * _Available since v3.3._
626      */
627     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
628         return functionStaticCall(target, data, "Address: low-level static call failed");
629     }
630 
631     /**
632      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
633      * but performing a static call.
634      *
635      * _Available since v3.3._
636      */
637     function functionStaticCall(
638         address target,
639         bytes memory data,
640         string memory errorMessage
641     ) internal view returns (bytes memory) {
642         require(isContract(target), "Address: static call to non-contract");
643 
644         (bool success, bytes memory returndata) = target.staticcall(data);
645         return verifyCallResult(success, returndata, errorMessage);
646     }
647 
648     /**
649      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
650      * but performing a delegate call.
651      *
652      * _Available since v3.4._
653      */
654     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
655         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
656     }
657 
658     /**
659      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
660      * but performing a delegate call.
661      *
662      * _Available since v3.4._
663      */
664     function functionDelegateCall(
665         address target,
666         bytes memory data,
667         string memory errorMessage
668     ) internal returns (bytes memory) {
669         require(isContract(target), "Address: delegate call to non-contract");
670 
671         (bool success, bytes memory returndata) = target.delegatecall(data);
672         return verifyCallResult(success, returndata, errorMessage);
673     }
674 
675     /**
676      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
677      * revert reason using the provided one.
678      *
679      * _Available since v4.3._
680      */
681     function verifyCallResult(
682         bool success,
683         bytes memory returndata,
684         string memory errorMessage
685     ) internal pure returns (bytes memory) {
686         if (success) {
687             return returndata;
688         } else {
689             // Look for revert reason and bubble it up if present
690             if (returndata.length > 0) {
691                 // The easiest way to bubble the revert reason is using memory via assembly
692                 /// @solidity memory-safe-assembly
693                 assembly {
694                     let returndata_size := mload(returndata)
695                     revert(add(32, returndata), returndata_size)
696                 }
697             } else {
698                 revert(errorMessage);
699             }
700         }
701     }
702 }
703 
704 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
705 
706 
707 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
708 
709 pragma solidity ^0.8.0;
710 
711 /**
712  * @title ERC721 token receiver interface
713  * @dev Interface for any contract that wants to support safeTransfers
714  * from ERC721 asset contracts.
715  */
716 interface IERC721Receiver {
717     /**
718      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
719      * by `operator` from `from`, this function is called.
720      *
721      * It must return its Solidity selector to confirm the token transfer.
722      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
723      *
724      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
725      */
726     function onERC721Received(
727         address operator,
728         address from,
729         uint256 tokenId,
730         bytes calldata data
731     ) external returns (bytes4);
732 }
733 
734 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
735 
736 
737 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
738 
739 pragma solidity ^0.8.0;
740 
741 /**
742  * @dev Interface of the ERC165 standard, as defined in the
743  * https://eips.ethereum.org/EIPS/eip-165[EIP].
744  *
745  * Implementers can declare support of contract interfaces, which can then be
746  * queried by others ({ERC165Checker}).
747  *
748  * For an implementation, see {ERC165}.
749  */
750 interface IERC165 {
751     /**
752      * @dev Returns true if this contract implements the interface defined by
753      * `interfaceId`. See the corresponding
754      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
755      * to learn more about how these ids are created.
756      *
757      * This function call must use less than 30 000 gas.
758      */
759     function supportsInterface(bytes4 interfaceId) external view returns (bool);
760 }
761 
762 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
763 
764 
765 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
766 
767 pragma solidity ^0.8.0;
768 
769 
770 /**
771  * @dev Implementation of the {IERC165} interface.
772  *
773  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
774  * for the additional interface id that will be supported. For example:
775  *
776  * ```solidity
777  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
778  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
779  * }
780  * ```
781  *
782  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
783  */
784 abstract contract ERC165 is IERC165 {
785     /**
786      * @dev See {IERC165-supportsInterface}.
787      */
788     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
789         return interfaceId == type(IERC165).interfaceId;
790     }
791 }
792 
793 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
794 
795 
796 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
797 
798 pragma solidity ^0.8.0;
799 
800 
801 /**
802  * @dev Required interface of an ERC721 compliant contract.
803  */
804 interface IERC721 is IERC165 {
805     /**
806      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
807      */
808     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
809 
810     /**
811      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
812      */
813     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
814 
815     /**
816      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
817      */
818     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
819 
820     /**
821      * @dev Returns the number of tokens in ``owner``'s account.
822      */
823     function balanceOf(address owner) external view returns (uint256 balance);
824 
825     /**
826      * @dev Returns the owner of the `tokenId` token.
827      *
828      * Requirements:
829      *
830      * - `tokenId` must exist.
831      */
832     function ownerOf(uint256 tokenId) external view returns (address owner);
833 
834     /**
835      * @dev Safely transfers `tokenId` token from `from` to `to`.
836      *
837      * Requirements:
838      *
839      * - `from` cannot be the zero address.
840      * - `to` cannot be the zero address.
841      * - `tokenId` token must exist and be owned by `from`.
842      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
843      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
844      *
845      * Emits a {Transfer} event.
846      */
847     function safeTransferFrom(
848         address from,
849         address to,
850         uint256 tokenId,
851         bytes calldata data
852     ) external;
853 
854     /**
855      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
856      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
857      *
858      * Requirements:
859      *
860      * - `from` cannot be the zero address.
861      * - `to` cannot be the zero address.
862      * - `tokenId` token must exist and be owned by `from`.
863      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
864      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
865      *
866      * Emits a {Transfer} event.
867      */
868     function safeTransferFrom(
869         address from,
870         address to,
871         uint256 tokenId
872     ) external;
873 
874     /**
875      * @dev Transfers `tokenId` token from `from` to `to`.
876      *
877      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
878      *
879      * Requirements:
880      *
881      * - `from` cannot be the zero address.
882      * - `to` cannot be the zero address.
883      * - `tokenId` token must be owned by `from`.
884      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
885      *
886      * Emits a {Transfer} event.
887      */
888     function transferFrom(
889         address from,
890         address to,
891         uint256 tokenId
892     ) external;
893 
894     /**
895      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
896      * The approval is cleared when the token is transferred.
897      *
898      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
899      *
900      * Requirements:
901      *
902      * - The caller must own the token or be an approved operator.
903      * - `tokenId` must exist.
904      *
905      * Emits an {Approval} event.
906      */
907     function approve(address to, uint256 tokenId) external;
908 
909     /**
910      * @dev Approve or remove `operator` as an operator for the caller.
911      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
912      *
913      * Requirements:
914      *
915      * - The `operator` cannot be the caller.
916      *
917      * Emits an {ApprovalForAll} event.
918      */
919     function setApprovalForAll(address operator, bool _approved) external;
920 
921     /**
922      * @dev Returns the account approved for `tokenId` token.
923      *
924      * Requirements:
925      *
926      * - `tokenId` must exist.
927      */
928     function getApproved(uint256 tokenId) external view returns (address operator);
929 
930     /**
931      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
932      *
933      * See {setApprovalForAll}
934      */
935     function isApprovedForAll(address owner, address operator) external view returns (bool);
936 }
937 
938 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
939 
940 
941 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
942 
943 pragma solidity ^0.8.0;
944 
945 
946 /**
947  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
948  * @dev See https://eips.ethereum.org/EIPS/eip-721
949  */
950 interface IERC721Enumerable is IERC721 {
951     /**
952      * @dev Returns the total amount of tokens stored by the contract.
953      */
954     function totalSupply() external view returns (uint256);
955 
956     /**
957      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
958      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
959      */
960     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
961 
962     /**
963      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
964      * Use along with {totalSupply} to enumerate all tokens.
965      */
966     function tokenByIndex(uint256 index) external view returns (uint256);
967 }
968 
969 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
970 
971 
972 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
973 
974 pragma solidity ^0.8.0;
975 
976 
977 /**
978  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
979  * @dev See https://eips.ethereum.org/EIPS/eip-721
980  */
981 interface IERC721Metadata is IERC721 {
982     /**
983      * @dev Returns the token collection name.
984      */
985     function name() external view returns (string memory);
986 
987     /**
988      * @dev Returns the token collection symbol.
989      */
990     function symbol() external view returns (string memory);
991 
992     /**
993      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
994      */
995     function tokenURI(uint256 tokenId) external view returns (string memory);
996 }
997 
998 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
999 
1000 
1001 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
1002 
1003 pragma solidity ^0.8.0;
1004 
1005 
1006 
1007 
1008 
1009 
1010 
1011 
1012 /**
1013  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1014  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1015  * {ERC721Enumerable}.
1016  */
1017 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1018     using Address for address;
1019     using Strings for uint256;
1020 
1021     // Token name
1022     string private _name;
1023 
1024     // Token symbol
1025     string private _symbol;
1026 
1027     // Mapping from token ID to owner address
1028     mapping(uint256 => address) private _owners;
1029 
1030     // Mapping owner address to token count
1031     mapping(address => uint256) private _balances;
1032 
1033     // Mapping from token ID to approved address
1034     mapping(uint256 => address) private _tokenApprovals;
1035 
1036     // Mapping from owner to operator approvals
1037     mapping(address => mapping(address => bool)) private _operatorApprovals;
1038 
1039     /**
1040      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1041      */
1042     constructor(string memory name_, string memory symbol_) {
1043         _name = name_;
1044         _symbol = symbol_;
1045     }
1046 
1047     /**
1048      * @dev See {IERC165-supportsInterface}.
1049      */
1050     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1051         return
1052             interfaceId == type(IERC721).interfaceId ||
1053             interfaceId == type(IERC721Metadata).interfaceId ||
1054             super.supportsInterface(interfaceId);
1055     }
1056 
1057     /**
1058      * @dev See {IERC721-balanceOf}.
1059      */
1060     function balanceOf(address owner) public view virtual override returns (uint256) {
1061         require(owner != address(0), "ERC721: address zero is not a valid owner");
1062         return _balances[owner];
1063     }
1064 
1065     /**
1066      * @dev See {IERC721-ownerOf}.
1067      */
1068     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1069         address owner = _owners[tokenId];
1070         require(owner != address(0), "ERC721: invalid token ID");
1071         return owner;
1072     }
1073 
1074     /**
1075      * @dev See {IERC721Metadata-name}.
1076      */
1077     function name() public view virtual override returns (string memory) {
1078         return _name;
1079     }
1080 
1081     /**
1082      * @dev See {IERC721Metadata-symbol}.
1083      */
1084     function symbol() public view virtual override returns (string memory) {
1085         return _symbol;
1086     }
1087 
1088     /**
1089      * @dev See {IERC721Metadata-tokenURI}.
1090      */
1091     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1092         _requireMinted(tokenId);
1093 
1094         string memory baseURI = _baseURI();
1095         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1096     }
1097 
1098     /**
1099      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1100      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1101      * by default, can be overridden in child contracts.
1102      */
1103     function _baseURI() internal view virtual returns (string memory) {
1104         return "";
1105     }
1106 
1107     /**
1108      * @dev See {IERC721-approve}.
1109      */
1110     function approve(address to, uint256 tokenId) public virtual override {
1111         address owner = ERC721.ownerOf(tokenId);
1112         require(to != owner, "ERC721: approval to current owner");
1113 
1114         require(
1115             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1116             "ERC721: approve caller is not token owner nor approved for all"
1117         );
1118 
1119         _approve(to, tokenId);
1120     }
1121 
1122     /**
1123      * @dev See {IERC721-getApproved}.
1124      */
1125     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1126         _requireMinted(tokenId);
1127 
1128         return _tokenApprovals[tokenId];
1129     }
1130 
1131     /**
1132      * @dev See {IERC721-setApprovalForAll}.
1133      */
1134     function setApprovalForAll(address operator, bool approved) public virtual override {
1135         _setApprovalForAll(_msgSender(), operator, approved);
1136     }
1137 
1138     /**
1139      * @dev See {IERC721-isApprovedForAll}.
1140      */
1141     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1142         return _operatorApprovals[owner][operator];
1143     }
1144 
1145     /**
1146      * @dev See {IERC721-transferFrom}.
1147      */
1148     function transferFrom(
1149         address from,
1150         address to,
1151         uint256 tokenId
1152     ) public virtual override {
1153         //solhint-disable-next-line max-line-length
1154         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
1155 
1156         _transfer(from, to, tokenId);
1157     }
1158 
1159     /**
1160      * @dev See {IERC721-safeTransferFrom}.
1161      */
1162     function safeTransferFrom(
1163         address from,
1164         address to,
1165         uint256 tokenId
1166     ) public virtual override {
1167         safeTransferFrom(from, to, tokenId, "");
1168     }
1169 
1170     /**
1171      * @dev See {IERC721-safeTransferFrom}.
1172      */
1173     function safeTransferFrom(
1174         address from,
1175         address to,
1176         uint256 tokenId,
1177         bytes memory data
1178     ) public virtual override {
1179         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
1180         _safeTransfer(from, to, tokenId, data);
1181     }
1182 
1183     /**
1184      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1185      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1186      *
1187      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1188      *
1189      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1190      * implement alternative mechanisms to perform token transfer, such as signature-based.
1191      *
1192      * Requirements:
1193      *
1194      * - `from` cannot be the zero address.
1195      * - `to` cannot be the zero address.
1196      * - `tokenId` token must exist and be owned by `from`.
1197      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1198      *
1199      * Emits a {Transfer} event.
1200      */
1201     function _safeTransfer(
1202         address from,
1203         address to,
1204         uint256 tokenId,
1205         bytes memory data
1206     ) internal virtual {
1207         _transfer(from, to, tokenId);
1208         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1209     }
1210 
1211     /**
1212      * @dev Returns whether `tokenId` exists.
1213      *
1214      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1215      *
1216      * Tokens start existing when they are minted (`_mint`),
1217      * and stop existing when they are burned (`_burn`).
1218      */
1219     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1220         return _owners[tokenId] != address(0);
1221     }
1222 
1223     /**
1224      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1225      *
1226      * Requirements:
1227      *
1228      * - `tokenId` must exist.
1229      */
1230     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1231         address owner = ERC721.ownerOf(tokenId);
1232         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1233     }
1234 
1235     /**
1236      * @dev Safely mints `tokenId` and transfers it to `to`.
1237      *
1238      * Requirements:
1239      *
1240      * - `tokenId` must not exist.
1241      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1242      *
1243      * Emits a {Transfer} event.
1244      */
1245     function _safeMint(address to, uint256 tokenId) internal virtual {
1246         _safeMint(to, tokenId, "");
1247     }
1248 
1249     /**
1250      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1251      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1252      */
1253     function _safeMint(
1254         address to,
1255         uint256 tokenId,
1256         bytes memory data
1257     ) internal virtual {
1258         _mint(to, tokenId);
1259         require(
1260             _checkOnERC721Received(address(0), to, tokenId, data),
1261             "ERC721: transfer to non ERC721Receiver implementer"
1262         );
1263     }
1264 
1265     /**
1266      * @dev Mints `tokenId` and transfers it to `to`.
1267      *
1268      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1269      *
1270      * Requirements:
1271      *
1272      * - `tokenId` must not exist.
1273      * - `to` cannot be the zero address.
1274      *
1275      * Emits a {Transfer} event.
1276      */
1277     function _mint(address to, uint256 tokenId) internal virtual {
1278         require(to != address(0), "ERC721: mint to the zero address");
1279         require(!_exists(tokenId), "ERC721: token already minted");
1280 
1281         _beforeTokenTransfer(address(0), to, tokenId);
1282 
1283         _balances[to] += 1;
1284         _owners[tokenId] = to;
1285 
1286         emit Transfer(address(0), to, tokenId);
1287 
1288         _afterTokenTransfer(address(0), to, tokenId);
1289     }
1290 
1291     /**
1292      * @dev Destroys `tokenId`.
1293      * The approval is cleared when the token is burned.
1294      *
1295      * Requirements:
1296      *
1297      * - `tokenId` must exist.
1298      *
1299      * Emits a {Transfer} event.
1300      */
1301     function _burn(uint256 tokenId) internal virtual {
1302         address owner = ERC721.ownerOf(tokenId);
1303 
1304         _beforeTokenTransfer(owner, address(0), tokenId);
1305 
1306         // Clear approvals
1307         _approve(address(0), tokenId);
1308 
1309         _balances[owner] -= 1;
1310         delete _owners[tokenId];
1311 
1312         emit Transfer(owner, address(0), tokenId);
1313 
1314         _afterTokenTransfer(owner, address(0), tokenId);
1315     }
1316 
1317     /**
1318      * @dev Transfers `tokenId` from `from` to `to`.
1319      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1320      *
1321      * Requirements:
1322      *
1323      * - `to` cannot be the zero address.
1324      * - `tokenId` token must be owned by `from`.
1325      *
1326      * Emits a {Transfer} event.
1327      */
1328     function _transfer(
1329         address from,
1330         address to,
1331         uint256 tokenId
1332     ) internal virtual {
1333         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1334         require(to != address(0), "ERC721: transfer to the zero address");
1335 
1336         _beforeTokenTransfer(from, to, tokenId);
1337 
1338         // Clear approvals from the previous owner
1339         _approve(address(0), tokenId);
1340 
1341         _balances[from] -= 1;
1342         _balances[to] += 1;
1343         _owners[tokenId] = to;
1344 
1345         emit Transfer(from, to, tokenId);
1346 
1347         _afterTokenTransfer(from, to, tokenId);
1348     }
1349 
1350     /**
1351      * @dev Approve `to` to operate on `tokenId`
1352      *
1353      * Emits an {Approval} event.
1354      */
1355     function _approve(address to, uint256 tokenId) internal virtual {
1356         _tokenApprovals[tokenId] = to;
1357         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1358     }
1359 
1360     /**
1361      * @dev Approve `operator` to operate on all of `owner` tokens
1362      *
1363      * Emits an {ApprovalForAll} event.
1364      */
1365     function _setApprovalForAll(
1366         address owner,
1367         address operator,
1368         bool approved
1369     ) internal virtual {
1370         require(owner != operator, "ERC721: approve to caller");
1371         _operatorApprovals[owner][operator] = approved;
1372         emit ApprovalForAll(owner, operator, approved);
1373     }
1374 
1375     /**
1376      * @dev Reverts if the `tokenId` has not been minted yet.
1377      */
1378     function _requireMinted(uint256 tokenId) internal view virtual {
1379         require(_exists(tokenId), "ERC721: invalid token ID");
1380     }
1381 
1382     /**
1383      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1384      * The call is not executed if the target address is not a contract.
1385      *
1386      * @param from address representing the previous owner of the given token ID
1387      * @param to target address that will receive the tokens
1388      * @param tokenId uint256 ID of the token to be transferred
1389      * @param data bytes optional data to send along with the call
1390      * @return bool whether the call correctly returned the expected magic value
1391      */
1392     function _checkOnERC721Received(
1393         address from,
1394         address to,
1395         uint256 tokenId,
1396         bytes memory data
1397     ) private returns (bool) {
1398         if (to.isContract()) {
1399             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1400                 return retval == IERC721Receiver.onERC721Received.selector;
1401             } catch (bytes memory reason) {
1402                 if (reason.length == 0) {
1403                     revert("ERC721: transfer to non ERC721Receiver implementer");
1404                 } else {
1405                     /// @solidity memory-safe-assembly
1406                     assembly {
1407                         revert(add(32, reason), mload(reason))
1408                     }
1409                 }
1410             }
1411         } else {
1412             return true;
1413         }
1414     }
1415 
1416     /**
1417      * @dev Hook that is called before any token transfer. This includes minting
1418      * and burning.
1419      *
1420      * Calling conditions:
1421      *
1422      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1423      * transferred to `to`.
1424      * - When `from` is zero, `tokenId` will be minted for `to`.
1425      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1426      * - `from` and `to` are never both zero.
1427      *
1428      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1429      */
1430     function _beforeTokenTransfer(
1431         address from,
1432         address to,
1433         uint256 tokenId
1434     ) internal virtual {}
1435 
1436     /**
1437      * @dev Hook that is called after any transfer of tokens. This includes
1438      * minting and burning.
1439      *
1440      * Calling conditions:
1441      *
1442      * - when `from` and `to` are both non-zero.
1443      * - `from` and `to` are never both zero.
1444      *
1445      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1446      */
1447     function _afterTokenTransfer(
1448         address from,
1449         address to,
1450         uint256 tokenId
1451     ) internal virtual {}
1452 }
1453 
1454 // File: erc721a.sol
1455 
1456 
1457 
1458 pragma solidity ^0.8.11;
1459 
1460 
1461 
1462 
1463 /**
1464  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1465  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1466  *
1467  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
1468  *
1469  * Does not support burning tokens to address(0).
1470  *
1471  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
1472  */
1473 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1474     using Address for address;
1475     using Strings for uint256;
1476 
1477     struct TokenOwnership {
1478         address addr;
1479         uint64 startTimestamp;
1480     }
1481 
1482     struct AddressData {
1483         uint128 balance;
1484         uint128 numberMinted;
1485     }
1486 
1487     uint256 internal currentIndex;
1488 
1489     // Token name
1490     string private _name;
1491 
1492     // Token symbol
1493     string private _symbol;
1494 
1495     // Mapping from token ID to ownership details
1496     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1497     mapping(uint256 => TokenOwnership) internal _ownerships;
1498 
1499     // Mapping owner address to address data
1500     mapping(address => AddressData) private _addressData;
1501 
1502     // Mapping from token ID to approved address
1503     mapping(uint256 => address) private _tokenApprovals;
1504 
1505     // Mapping from owner to operator approvals
1506     mapping(address => mapping(address => bool)) private _operatorApprovals;
1507 
1508     constructor(string memory name_, string memory symbol_) {
1509         _name = name_;
1510         _symbol = symbol_;
1511     }
1512 
1513     /**
1514      * @dev See {IERC721Enumerable-totalSupply}.
1515      */
1516     function totalSupply() public view override returns (uint256) {
1517         return currentIndex;
1518     }
1519 
1520     /**
1521      * @dev See {IERC721Enumerable-tokenByIndex}.
1522      */
1523     function tokenByIndex(uint256 index) public view override returns (uint256) {
1524         require(index < totalSupply(), "ERC721A: global index out of bounds");
1525         return index;
1526     }
1527 
1528     /**
1529      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1530      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1531      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1532      */
1533     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1534         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1535         uint256 numMintedSoFar = totalSupply();
1536         uint256 tokenIdsIdx;
1537         address currOwnershipAddr;
1538 
1539         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
1540         unchecked {
1541             for (uint256 i; i < numMintedSoFar; i++) {
1542                 TokenOwnership memory ownership = _ownerships[i];
1543                 if (ownership.addr != address(0)) {
1544                     currOwnershipAddr = ownership.addr;
1545                 }
1546                 if (currOwnershipAddr == owner) {
1547                     if (tokenIdsIdx == index) {
1548                         return i;
1549                     }
1550                     tokenIdsIdx++;
1551                 }
1552             }
1553         }
1554 
1555         revert("ERC721A: unable to get token of owner by index");
1556     }
1557 
1558     /**
1559      * @dev See {IERC165-supportsInterface}.
1560      */
1561     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1562         return
1563             interfaceId == type(IERC721).interfaceId ||
1564             interfaceId == type(IERC721Metadata).interfaceId ||
1565             interfaceId == type(IERC721Enumerable).interfaceId ||
1566             super.supportsInterface(interfaceId);
1567     }
1568 
1569     /**
1570      * @dev See {IERC721-balanceOf}.
1571      */
1572     function balanceOf(address owner) public view override returns (uint256) {
1573         require(owner != address(0), "ERC721A: balance query for the zero address");
1574         return uint256(_addressData[owner].balance);
1575     }
1576 
1577     function _numberMinted(address owner) internal view returns (uint256) {
1578         require(owner != address(0), "ERC721A: number minted query for the zero address");
1579         return uint256(_addressData[owner].numberMinted);
1580     }
1581 
1582     /**
1583      * Gas spent here starts off proportional to the maximum mint batch size.
1584      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1585      */
1586     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1587         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1588 
1589         unchecked {
1590             for (uint256 curr = tokenId; curr >= 0; curr--) {
1591                 TokenOwnership memory ownership = _ownerships[curr];
1592                 if (ownership.addr != address(0)) {
1593                     return ownership;
1594                 }
1595             }
1596         }
1597 
1598         revert("ERC721A: unable to determine the owner of token");
1599     }
1600 
1601     /**
1602      * @dev See {IERC721-ownerOf}.
1603      */
1604     function ownerOf(uint256 tokenId) public view override returns (address) {
1605         return ownershipOf(tokenId).addr;
1606     }
1607 
1608     /**
1609      * @dev See {IERC721Metadata-name}.
1610      */
1611     function name() public view virtual override returns (string memory) {
1612         return _name;
1613     }
1614 
1615     /**
1616      * @dev See {IERC721Metadata-symbol}.
1617      */
1618     function symbol() public view virtual override returns (string memory) {
1619         return _symbol;
1620     }
1621 
1622     /**
1623      * @dev See {IERC721Metadata-tokenURI}.
1624      */
1625     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1626         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1627 
1628         string memory baseURI = _baseURI();
1629         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1630     }
1631 
1632     /**
1633      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1634      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1635      * by default, can be overriden in child contracts.
1636      */
1637     function _baseURI() internal view virtual returns (string memory) {
1638         return "";
1639     }
1640 
1641     /**
1642      * @dev See {IERC721-approve}.
1643      */
1644     function approve(address to, uint256 tokenId) public override {
1645         address owner = ERC721A.ownerOf(tokenId);
1646         require(to != owner, "ERC721A: approval to current owner");
1647 
1648         require(
1649             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1650             "ERC721A: approve caller is not owner nor approved for all"
1651         );
1652 
1653         _approve(to, tokenId, owner);
1654     }
1655 
1656     /**
1657      * @dev See {IERC721-getApproved}.
1658      */
1659     function getApproved(uint256 tokenId) public view override returns (address) {
1660         require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1661 
1662         return _tokenApprovals[tokenId];
1663     }
1664 
1665     /**
1666      * @dev See {IERC721-setApprovalForAll}.
1667      */
1668     function setApprovalForAll(address operator, bool approved) public override {
1669         require(operator != _msgSender(), "ERC721A: approve to caller");
1670 
1671         _operatorApprovals[_msgSender()][operator] = approved;
1672         emit ApprovalForAll(_msgSender(), operator, approved);
1673     }
1674 
1675     /**
1676      * @dev See {IERC721-isApprovedForAll}.
1677      */
1678     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1679         return _operatorApprovals[owner][operator];
1680     }
1681 
1682     /**
1683      * @dev See {IERC721-transferFrom}.
1684      */
1685     function transferFrom(
1686         address from,
1687         address to,
1688         uint256 tokenId
1689     ) public virtual override {
1690         _transfer(from, to, tokenId);
1691     }
1692 
1693     /**
1694      * @dev See {IERC721-safeTransferFrom}.
1695      */
1696     function safeTransferFrom(
1697         address from,
1698         address to,
1699         uint256 tokenId
1700     ) public virtual override {
1701         safeTransferFrom(from, to, tokenId, "");
1702     }
1703 
1704     /**
1705      * @dev See {IERC721-safeTransferFrom}.
1706      */
1707     function safeTransferFrom(
1708         address from,
1709         address to,
1710         uint256 tokenId,
1711         bytes memory _data
1712     ) public override {
1713         _transfer(from, to, tokenId);
1714         require(
1715             _checkOnERC721Received(from, to, tokenId, _data),
1716             "ERC721A: transfer to non ERC721Receiver implementer"
1717         );
1718     }
1719 
1720     /**
1721      * @dev Returns whether `tokenId` exists.
1722      *
1723      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1724      *
1725      * Tokens start existing when they are minted (`_mint`),
1726      */
1727     function _exists(uint256 tokenId) internal view returns (bool) {
1728         return tokenId < currentIndex;
1729     }
1730 
1731     function _safeMint(address to, uint256 quantity) internal {
1732         _safeMint(to, quantity, "");
1733     }
1734 
1735     /**
1736      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1737      *
1738      * Requirements:
1739      *
1740      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1741      * - `quantity` must be greater than 0.
1742      *
1743      * Emits a {Transfer} event.
1744      */
1745     function _safeMint(
1746         address to,
1747         uint256 quantity,
1748         bytes memory _data
1749     ) internal {
1750         _mint(to, quantity, _data, true);
1751     }
1752 
1753     /**
1754      * @dev Mints `quantity` tokens and transfers them to `to`.
1755      *
1756      * Requirements:
1757      *
1758      * - `to` cannot be the zero address.
1759      * - `quantity` must be greater than 0.
1760      *
1761      * Emits a {Transfer} event.
1762      */
1763     function _mint(
1764         address to,
1765         uint256 quantity,
1766         bytes memory _data,
1767         bool safe
1768     ) internal {
1769         uint256 startTokenId = currentIndex;
1770         require(to != address(0), "ERC721A: mint to the zero address");
1771         require(quantity != 0, "ERC721A: quantity must be greater than 0");
1772 
1773         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1774 
1775         // Overflows are incredibly unrealistic.
1776         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1777         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1778         unchecked {
1779             _addressData[to].balance += uint128(quantity);
1780             _addressData[to].numberMinted += uint128(quantity);
1781 
1782             _ownerships[startTokenId].addr = to;
1783             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1784 
1785             uint256 updatedIndex = startTokenId;
1786 
1787             for (uint256 i; i < quantity; i++) {
1788                 emit Transfer(address(0), to, updatedIndex);
1789                 if (safe) {
1790                     require(
1791                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1792                         "ERC721A: transfer to non ERC721Receiver implementer"
1793                     );
1794                 }
1795 
1796                 updatedIndex++;
1797             }
1798 
1799             currentIndex = updatedIndex;
1800         }
1801 
1802         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1803     }
1804 
1805     /**
1806      * @dev Transfers `tokenId` from `from` to `to`.
1807      *
1808      * Requirements:
1809      *
1810      * - `to` cannot be the zero address.
1811      * - `tokenId` token must be owned by `from`.
1812      *
1813      * Emits a {Transfer} event.
1814      */
1815     function _transfer(
1816         address from,
1817         address to,
1818         uint256 tokenId
1819     ) private {
1820         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1821 
1822         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1823             getApproved(tokenId) == _msgSender() ||
1824             isApprovedForAll(prevOwnership.addr, _msgSender()));
1825 
1826         require(isApprovedOrOwner, "ERC721A: transfer caller is not owner nor approved");
1827 
1828         require(prevOwnership.addr == from, "ERC721A: transfer from incorrect owner");
1829         require(to != address(0), "ERC721A: transfer to the zero address");
1830 
1831         _beforeTokenTransfers(from, to, tokenId, 1);
1832 
1833         // Clear approvals from the previous owner
1834         _approve(address(0), tokenId, prevOwnership.addr);
1835 
1836         // Underflow of the sender's balance is impossible because we check for
1837         // ownership above and the recipient's balance can't realistically overflow.
1838         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1839         unchecked {
1840             _addressData[from].balance -= 1;
1841             _addressData[to].balance += 1;
1842 
1843             _ownerships[tokenId].addr = to;
1844             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1845 
1846             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1847             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1848             uint256 nextTokenId = tokenId + 1;
1849             if (_ownerships[nextTokenId].addr == address(0)) {
1850                 if (_exists(nextTokenId)) {
1851                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1852                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1853                 }
1854             }
1855         }
1856 
1857         emit Transfer(from, to, tokenId);
1858         _afterTokenTransfers(from, to, tokenId, 1);
1859     }
1860 
1861     /**
1862      * @dev Approve `to` to operate on `tokenId`
1863      *
1864      * Emits a {Approval} event.
1865      */
1866     function _approve(
1867         address to,
1868         uint256 tokenId,
1869         address owner
1870     ) private {
1871         _tokenApprovals[tokenId] = to;
1872         emit Approval(owner, to, tokenId);
1873     }
1874 
1875     /**
1876      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1877      * The call is not executed if the target address is not a contract.
1878      *
1879      * @param from address representing the previous owner of the given token ID
1880      * @param to target address that will receive the tokens
1881      * @param tokenId uint256 ID of the token to be transferred
1882      * @param _data bytes optional data to send along with the call
1883      * @return bool whether the call correctly returned the expected magic value
1884      */
1885     function _checkOnERC721Received(
1886         address from,
1887         address to,
1888         uint256 tokenId,
1889         bytes memory _data
1890     ) private returns (bool) {
1891         if (to.isContract()) {
1892             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1893                 return retval == IERC721Receiver(to).onERC721Received.selector;
1894             } catch (bytes memory reason) {
1895                 if (reason.length == 0) {
1896                     revert("ERC721A: transfer to non ERC721Receiver implementer");
1897                 } else {
1898                     assembly {
1899                         revert(add(32, reason), mload(reason))
1900                     }
1901                 }
1902             }
1903         } else {
1904             return true;
1905         }
1906     }
1907 
1908     /**
1909      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1910      *
1911      * startTokenId - the first token id to be transferred
1912      * quantity - the amount to be transferred
1913      *
1914      * Calling conditions:
1915      *
1916      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1917      * transferred to `to`.
1918      * - When `from` is zero, `tokenId` will be minted for `to`.
1919      */
1920     function _beforeTokenTransfers(
1921         address from,
1922         address to,
1923         uint256 startTokenId,
1924         uint256 quantity
1925     ) internal virtual {}
1926 
1927     /**
1928      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1929      * minting.
1930      *
1931      * startTokenId - the first token id to be transferred
1932      * quantity - the amount to be transferred
1933      *
1934      * Calling conditions:
1935      *
1936      * - when `from` and `to` are both non-zero.
1937      * - `from` and `to` are never both zero.
1938      */
1939     function _afterTokenTransfers(
1940         address from,
1941         address to,
1942         uint256 startTokenId,
1943         uint256 quantity
1944     ) internal virtual {}
1945 }
1946 // File: mutantbanana.sol
1947 
1948 
1949 
1950 pragma solidity ^0.8.11;
1951 
1952 
1953 
1954 
1955 
1956 
1957 
1958 contract MutantBanana is ERC721A, Ownable, ReentrancyGuard {
1959 
1960     using ECDSA for bytes32;
1961 
1962     address private      bananaAddress;
1963     string public        baseURI;
1964     uint public          nextOwnerToExplicitlySet;
1965     uint public          maxSupply = 300;
1966     bool public          mintEnabled;
1967 
1968     constructor(address _bananaAddress) ERC721A("Mutant Banana", "MUTANT BANANA"){
1969         bananaAddress = _bananaAddress;
1970     }
1971 
1972     function batchMutate(address to, uint[] memory bananas) external {
1973         require(mintEnabled, "mint disabled");
1974         require(bananas.length % 5 == 0, "must select multiples of 5 bananas");
1975         require(totalSupply() + (bananas.length / 5) < maxSupply + 1, "we're sold out!");
1976         for (uint i = 0; i < bananas.length; i++) {
1977             require(IERC721(bananaAddress).ownerOf(bananas[i]) == msg.sender , "must be owner of bananas");
1978         }
1979         for (uint i = 0; i < bananas.length; i++) {
1980             IERC721(bananaAddress).transferFrom(msg.sender, address(0xdead), bananas[i]);
1981         }
1982         _safeMint(to, bananas.length / 5);
1983     }
1984 
1985     function toggleMinting() external onlyOwner {
1986         mintEnabled = !mintEnabled;
1987     }
1988 
1989     function numberMinted(address owner) public view returns (uint256) {
1990         return _numberMinted(owner);
1991     }
1992 
1993     function setBaseURI(string calldata baseURI_) external onlyOwner {
1994         baseURI = baseURI_;
1995     }
1996 
1997     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1998         require(_exists(tokenId), "banana does not exist");
1999         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, Strings.toString(tokenId))) : "";
2000     }
2001 
2002     function _baseURI() internal view virtual override returns (string memory) {
2003         return baseURI;
2004     }
2005 
2006     function withdraw() external onlyOwner nonReentrant {
2007         (bool success, ) = msg.sender.call{value: address(this).balance}("");
2008         require(success, "transfer failed");
2009     }
2010 
2011     function setOwnersExplicit(uint256 quantity) external onlyOwner nonReentrant {
2012         _setOwnersExplicit(quantity);
2013     }
2014 
2015     function getOwnershipData(uint256 tokenId) external view returns (TokenOwnership memory) {
2016         return ownershipOf(tokenId);
2017     }
2018 
2019     /**
2020      * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
2021      */
2022     function _setOwnersExplicit(uint256 quantity) internal {
2023         require(quantity != 0, "quantity must be nonzero");
2024         require(currentIndex != 0, "no tokens minted yet");
2025         uint256 _nextOwnerToExplicitlySet = nextOwnerToExplicitlySet;
2026         require(_nextOwnerToExplicitlySet < currentIndex, "all ownerships have been set");
2027 
2028         // Index underflow is impossible.
2029         // Counter or index overflow is incredibly unrealistic.
2030         unchecked {
2031             uint256 endIndex = _nextOwnerToExplicitlySet + quantity - 1;
2032 
2033             // Set the end index to be the last token index
2034             if (endIndex + 1 > currentIndex) {
2035                 endIndex = currentIndex - 1;
2036             }
2037 
2038             for (uint256 i = _nextOwnerToExplicitlySet; i <= endIndex; i++) {
2039                 if (_ownerships[i].addr == address(0)) {
2040                     TokenOwnership memory ownership = ownershipOf(i);
2041                     _ownerships[i].addr = ownership.addr;
2042                     _ownerships[i].startTimestamp = ownership.startTimestamp;
2043                 }
2044             }
2045 
2046             nextOwnerToExplicitlySet = endIndex + 1;
2047         }
2048     }
2049 
2050 }