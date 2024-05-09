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
70 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
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
140 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/ECDSA.sol)
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
257         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
258         uint8 v = uint8((uint256(vs) >> 255) + 27);
259         return tryRecover(hash, v, r, s);
260     }
261 
262     /**
263      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
264      *
265      * _Available since v4.2._
266      */
267     function recover(
268         bytes32 hash,
269         bytes32 r,
270         bytes32 vs
271     ) internal pure returns (address) {
272         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
273         _throwError(error);
274         return recovered;
275     }
276 
277     /**
278      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
279      * `r` and `s` signature fields separately.
280      *
281      * _Available since v4.3._
282      */
283     function tryRecover(
284         bytes32 hash,
285         uint8 v,
286         bytes32 r,
287         bytes32 s
288     ) internal pure returns (address, RecoverError) {
289         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
290         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
291         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
292         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
293         //
294         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
295         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
296         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
297         // these malleable signatures as well.
298         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
299             return (address(0), RecoverError.InvalidSignatureS);
300         }
301         if (v != 27 && v != 28) {
302             return (address(0), RecoverError.InvalidSignatureV);
303         }
304 
305         // If the signature is valid (and not malleable), return the signer address
306         address signer = ecrecover(hash, v, r, s);
307         if (signer == address(0)) {
308             return (address(0), RecoverError.InvalidSignature);
309         }
310 
311         return (signer, RecoverError.NoError);
312     }
313 
314     /**
315      * @dev Overload of {ECDSA-recover} that receives the `v`,
316      * `r` and `s` signature fields separately.
317      */
318     function recover(
319         bytes32 hash,
320         uint8 v,
321         bytes32 r,
322         bytes32 s
323     ) internal pure returns (address) {
324         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
325         _throwError(error);
326         return recovered;
327     }
328 
329     /**
330      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
331      * produces hash corresponding to the one signed with the
332      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
333      * JSON-RPC method as part of EIP-191.
334      *
335      * See {recover}.
336      */
337     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
338         // 32 is the length in bytes of hash,
339         // enforced by the type signature above
340         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
341     }
342 
343     /**
344      * @dev Returns an Ethereum Signed Message, created from `s`. This
345      * produces hash corresponding to the one signed with the
346      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
347      * JSON-RPC method as part of EIP-191.
348      *
349      * See {recover}.
350      */
351     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
352         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
353     }
354 
355     /**
356      * @dev Returns an Ethereum Signed Typed Data, created from a
357      * `domainSeparator` and a `structHash`. This produces hash corresponding
358      * to the one signed with the
359      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
360      * JSON-RPC method as part of EIP-712.
361      *
362      * See {recover}.
363      */
364     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
365         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
366     }
367 }
368 
369 // File: @openzeppelin/contracts/utils/Context.sol
370 
371 
372 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
373 
374 pragma solidity ^0.8.0;
375 
376 /**
377  * @dev Provides information about the current execution context, including the
378  * sender of the transaction and its data. While these are generally available
379  * via msg.sender and msg.data, they should not be accessed in such a direct
380  * manner, since when dealing with meta-transactions the account sending and
381  * paying for execution may not be the actual sender (as far as an application
382  * is concerned).
383  *
384  * This contract is only required for intermediate, library-like contracts.
385  */
386 abstract contract Context {
387     function _msgSender() internal view virtual returns (address) {
388         return msg.sender;
389     }
390 
391     function _msgData() internal view virtual returns (bytes calldata) {
392         return msg.data;
393     }
394 }
395 
396 // File: @openzeppelin/contracts/access/Ownable.sol
397 
398 
399 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
400 
401 pragma solidity ^0.8.0;
402 
403 
404 /**
405  * @dev Contract module which provides a basic access control mechanism, where
406  * there is an account (an owner) that can be granted exclusive access to
407  * specific functions.
408  *
409  * By default, the owner account will be the one that deploys the contract. This
410  * can later be changed with {transferOwnership}.
411  *
412  * This module is used through inheritance. It will make available the modifier
413  * `onlyOwner`, which can be applied to your functions to restrict their use to
414  * the owner.
415  */
416 abstract contract Ownable is Context {
417     address private _owner;
418 
419     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
420 
421     /**
422      * @dev Initializes the contract setting the deployer as the initial owner.
423      */
424     constructor() {
425         _transferOwnership(_msgSender());
426     }
427 
428     /**
429      * @dev Returns the address of the current owner.
430      */
431     function owner() public view virtual returns (address) {
432         return _owner;
433     }
434 
435     /**
436      * @dev Throws if called by any account other than the owner.
437      */
438     modifier onlyOwner() {
439         require(owner() == _msgSender(), "Ownable: caller is not the owner");
440         _;
441     }
442 
443     /**
444      * @dev Leaves the contract without owner. It will not be possible to call
445      * `onlyOwner` functions anymore. Can only be called by the current owner.
446      *
447      * NOTE: Renouncing ownership will leave the contract without an owner,
448      * thereby removing any functionality that is only available to the owner.
449      */
450     function renounceOwnership() public virtual onlyOwner {
451         _transferOwnership(address(0));
452     }
453 
454     /**
455      * @dev Transfers ownership of the contract to a new account (`newOwner`).
456      * Can only be called by the current owner.
457      */
458     function transferOwnership(address newOwner) public virtual onlyOwner {
459         require(newOwner != address(0), "Ownable: new owner is the zero address");
460         _transferOwnership(newOwner);
461     }
462 
463     /**
464      * @dev Transfers ownership of the contract to a new account (`newOwner`).
465      * Internal function without access restriction.
466      */
467     function _transferOwnership(address newOwner) internal virtual {
468         address oldOwner = _owner;
469         _owner = newOwner;
470         emit OwnershipTransferred(oldOwner, newOwner);
471     }
472 }
473 
474 // File: @openzeppelin/contracts/utils/Address.sol
475 
476 
477 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
478 
479 pragma solidity ^0.8.1;
480 
481 /**
482  * @dev Collection of functions related to the address type
483  */
484 library Address {
485     /**
486      * @dev Returns true if `account` is a contract.
487      *
488      * [IMPORTANT]
489      * ====
490      * It is unsafe to assume that an address for which this function returns
491      * false is an externally-owned account (EOA) and not a contract.
492      *
493      * Among others, `isContract` will return false for the following
494      * types of addresses:
495      *
496      *  - an externally-owned account
497      *  - a contract in construction
498      *  - an address where a contract will be created
499      *  - an address where a contract lived, but was destroyed
500      * ====
501      *
502      * [IMPORTANT]
503      * ====
504      * You shouldn't rely on `isContract` to protect against flash loan attacks!
505      *
506      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
507      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
508      * constructor.
509      * ====
510      */
511     function isContract(address account) internal view returns (bool) {
512         // This method relies on extcodesize/address.code.length, which returns 0
513         // for contracts in construction, since the code is only stored at the end
514         // of the constructor execution.
515 
516         return account.code.length > 0;
517     }
518 
519     /**
520      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
521      * `recipient`, forwarding all available gas and reverting on errors.
522      *
523      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
524      * of certain opcodes, possibly making contracts go over the 2300 gas limit
525      * imposed by `transfer`, making them unable to receive funds via
526      * `transfer`. {sendValue} removes this limitation.
527      *
528      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
529      *
530      * IMPORTANT: because control is transferred to `recipient`, care must be
531      * taken to not create reentrancy vulnerabilities. Consider using
532      * {ReentrancyGuard} or the
533      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
534      */
535     function sendValue(address payable recipient, uint256 amount) internal {
536         require(address(this).balance >= amount, "Address: insufficient balance");
537 
538         (bool success, ) = recipient.call{value: amount}("");
539         require(success, "Address: unable to send value, recipient may have reverted");
540     }
541 
542     /**
543      * @dev Performs a Solidity function call using a low level `call`. A
544      * plain `call` is an unsafe replacement for a function call: use this
545      * function instead.
546      *
547      * If `target` reverts with a revert reason, it is bubbled up by this
548      * function (like regular Solidity function calls).
549      *
550      * Returns the raw returned data. To convert to the expected return value,
551      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
552      *
553      * Requirements:
554      *
555      * - `target` must be a contract.
556      * - calling `target` with `data` must not revert.
557      *
558      * _Available since v3.1._
559      */
560     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
561         return functionCall(target, data, "Address: low-level call failed");
562     }
563 
564     /**
565      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
566      * `errorMessage` as a fallback revert reason when `target` reverts.
567      *
568      * _Available since v3.1._
569      */
570     function functionCall(
571         address target,
572         bytes memory data,
573         string memory errorMessage
574     ) internal returns (bytes memory) {
575         return functionCallWithValue(target, data, 0, errorMessage);
576     }
577 
578     /**
579      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
580      * but also transferring `value` wei to `target`.
581      *
582      * Requirements:
583      *
584      * - the calling contract must have an ETH balance of at least `value`.
585      * - the called Solidity function must be `payable`.
586      *
587      * _Available since v3.1._
588      */
589     function functionCallWithValue(
590         address target,
591         bytes memory data,
592         uint256 value
593     ) internal returns (bytes memory) {
594         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
595     }
596 
597     /**
598      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
599      * with `errorMessage` as a fallback revert reason when `target` reverts.
600      *
601      * _Available since v3.1._
602      */
603     function functionCallWithValue(
604         address target,
605         bytes memory data,
606         uint256 value,
607         string memory errorMessage
608     ) internal returns (bytes memory) {
609         require(address(this).balance >= value, "Address: insufficient balance for call");
610         require(isContract(target), "Address: call to non-contract");
611 
612         (bool success, bytes memory returndata) = target.call{value: value}(data);
613         return verifyCallResult(success, returndata, errorMessage);
614     }
615 
616     /**
617      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
618      * but performing a static call.
619      *
620      * _Available since v3.3._
621      */
622     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
623         return functionStaticCall(target, data, "Address: low-level static call failed");
624     }
625 
626     /**
627      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
628      * but performing a static call.
629      *
630      * _Available since v3.3._
631      */
632     function functionStaticCall(
633         address target,
634         bytes memory data,
635         string memory errorMessage
636     ) internal view returns (bytes memory) {
637         require(isContract(target), "Address: static call to non-contract");
638 
639         (bool success, bytes memory returndata) = target.staticcall(data);
640         return verifyCallResult(success, returndata, errorMessage);
641     }
642 
643     /**
644      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
645      * but performing a delegate call.
646      *
647      * _Available since v3.4._
648      */
649     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
650         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
651     }
652 
653     /**
654      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
655      * but performing a delegate call.
656      *
657      * _Available since v3.4._
658      */
659     function functionDelegateCall(
660         address target,
661         bytes memory data,
662         string memory errorMessage
663     ) internal returns (bytes memory) {
664         require(isContract(target), "Address: delegate call to non-contract");
665 
666         (bool success, bytes memory returndata) = target.delegatecall(data);
667         return verifyCallResult(success, returndata, errorMessage);
668     }
669 
670     /**
671      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
672      * revert reason using the provided one.
673      *
674      * _Available since v4.3._
675      */
676     function verifyCallResult(
677         bool success,
678         bytes memory returndata,
679         string memory errorMessage
680     ) internal pure returns (bytes memory) {
681         if (success) {
682             return returndata;
683         } else {
684             // Look for revert reason and bubble it up if present
685             if (returndata.length > 0) {
686                 // The easiest way to bubble the revert reason is using memory via assembly
687 
688                 assembly {
689                     let returndata_size := mload(returndata)
690                     revert(add(32, returndata), returndata_size)
691                 }
692             } else {
693                 revert(errorMessage);
694             }
695         }
696     }
697 }
698 
699 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
700 
701 
702 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
703 
704 pragma solidity ^0.8.0;
705 
706 /**
707  * @title ERC721 token receiver interface
708  * @dev Interface for any contract that wants to support safeTransfers
709  * from ERC721 asset contracts.
710  */
711 interface IERC721Receiver {
712     /**
713      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
714      * by `operator` from `from`, this function is called.
715      *
716      * It must return its Solidity selector to confirm the token transfer.
717      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
718      *
719      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
720      */
721     function onERC721Received(
722         address operator,
723         address from,
724         uint256 tokenId,
725         bytes calldata data
726     ) external returns (bytes4);
727 }
728 
729 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
730 
731 
732 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
733 
734 pragma solidity ^0.8.0;
735 
736 /**
737  * @dev Interface of the ERC165 standard, as defined in the
738  * https://eips.ethereum.org/EIPS/eip-165[EIP].
739  *
740  * Implementers can declare support of contract interfaces, which can then be
741  * queried by others ({ERC165Checker}).
742  *
743  * For an implementation, see {ERC165}.
744  */
745 interface IERC165 {
746     /**
747      * @dev Returns true if this contract implements the interface defined by
748      * `interfaceId`. See the corresponding
749      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
750      * to learn more about how these ids are created.
751      *
752      * This function call must use less than 30 000 gas.
753      */
754     function supportsInterface(bytes4 interfaceId) external view returns (bool);
755 }
756 
757 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
758 
759 
760 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
761 
762 pragma solidity ^0.8.0;
763 
764 
765 /**
766  * @dev Implementation of the {IERC165} interface.
767  *
768  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
769  * for the additional interface id that will be supported. For example:
770  *
771  * ```solidity
772  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
773  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
774  * }
775  * ```
776  *
777  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
778  */
779 abstract contract ERC165 is IERC165 {
780     /**
781      * @dev See {IERC165-supportsInterface}.
782      */
783     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
784         return interfaceId == type(IERC165).interfaceId;
785     }
786 }
787 
788 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
789 
790 
791 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
792 
793 pragma solidity ^0.8.0;
794 
795 
796 /**
797  * @dev Required interface of an ERC721 compliant contract.
798  */
799 interface IERC721 is IERC165 {
800     /**
801      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
802      */
803     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
804 
805     /**
806      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
807      */
808     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
809 
810     /**
811      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
812      */
813     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
814 
815     /**
816      * @dev Returns the number of tokens in ``owner``'s account.
817      */
818     function balanceOf(address owner) external view returns (uint256 balance);
819 
820     /**
821      * @dev Returns the owner of the `tokenId` token.
822      *
823      * Requirements:
824      *
825      * - `tokenId` must exist.
826      */
827     function ownerOf(uint256 tokenId) external view returns (address owner);
828 
829     /**
830      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
831      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
832      *
833      * Requirements:
834      *
835      * - `from` cannot be the zero address.
836      * - `to` cannot be the zero address.
837      * - `tokenId` token must exist and be owned by `from`.
838      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
839      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
840      *
841      * Emits a {Transfer} event.
842      */
843     function safeTransferFrom(
844         address from,
845         address to,
846         uint256 tokenId
847     ) external;
848 
849     /**
850      * @dev Transfers `tokenId` token from `from` to `to`.
851      *
852      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
853      *
854      * Requirements:
855      *
856      * - `from` cannot be the zero address.
857      * - `to` cannot be the zero address.
858      * - `tokenId` token must be owned by `from`.
859      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
860      *
861      * Emits a {Transfer} event.
862      */
863     function transferFrom(
864         address from,
865         address to,
866         uint256 tokenId
867     ) external;
868 
869     /**
870      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
871      * The approval is cleared when the token is transferred.
872      *
873      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
874      *
875      * Requirements:
876      *
877      * - The caller must own the token or be an approved operator.
878      * - `tokenId` must exist.
879      *
880      * Emits an {Approval} event.
881      */
882     function approve(address to, uint256 tokenId) external;
883 
884     /**
885      * @dev Returns the account approved for `tokenId` token.
886      *
887      * Requirements:
888      *
889      * - `tokenId` must exist.
890      */
891     function getApproved(uint256 tokenId) external view returns (address operator);
892 
893     /**
894      * @dev Approve or remove `operator` as an operator for the caller.
895      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
896      *
897      * Requirements:
898      *
899      * - The `operator` cannot be the caller.
900      *
901      * Emits an {ApprovalForAll} event.
902      */
903     function setApprovalForAll(address operator, bool _approved) external;
904 
905     /**
906      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
907      *
908      * See {setApprovalForAll}
909      */
910     function isApprovedForAll(address owner, address operator) external view returns (bool);
911 
912     /**
913      * @dev Safely transfers `tokenId` token from `from` to `to`.
914      *
915      * Requirements:
916      *
917      * - `from` cannot be the zero address.
918      * - `to` cannot be the zero address.
919      * - `tokenId` token must exist and be owned by `from`.
920      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
921      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
922      *
923      * Emits a {Transfer} event.
924      */
925     function safeTransferFrom(
926         address from,
927         address to,
928         uint256 tokenId,
929         bytes calldata data
930     ) external;
931 }
932 
933 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
934 
935 
936 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
937 
938 pragma solidity ^0.8.0;
939 
940 
941 /**
942  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
943  * @dev See https://eips.ethereum.org/EIPS/eip-721
944  */
945 interface IERC721Enumerable is IERC721 {
946     /**
947      * @dev Returns the total amount of tokens stored by the contract.
948      */
949     function totalSupply() external view returns (uint256);
950 
951     /**
952      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
953      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
954      */
955     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
956 
957     /**
958      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
959      * Use along with {totalSupply} to enumerate all tokens.
960      */
961     function tokenByIndex(uint256 index) external view returns (uint256);
962 }
963 
964 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
965 
966 
967 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
968 
969 pragma solidity ^0.8.0;
970 
971 
972 /**
973  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
974  * @dev See https://eips.ethereum.org/EIPS/eip-721
975  */
976 interface IERC721Metadata is IERC721 {
977     /**
978      * @dev Returns the token collection name.
979      */
980     function name() external view returns (string memory);
981 
982     /**
983      * @dev Returns the token collection symbol.
984      */
985     function symbol() external view returns (string memory);
986 
987     /**
988      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
989      */
990     function tokenURI(uint256 tokenId) external view returns (string memory);
991 }
992 
993 // File: erc721a/contracts/ERC721A.sol
994 
995 
996 // Creator: Chiru Labs
997 
998 pragma solidity ^0.8.4;
999 
1000 
1001 
1002 
1003 
1004 
1005 
1006 
1007 
1008 error ApprovalCallerNotOwnerNorApproved();
1009 error ApprovalQueryForNonexistentToken();
1010 error ApproveToCaller();
1011 error ApprovalToCurrentOwner();
1012 error BalanceQueryForZeroAddress();
1013 error MintedQueryForZeroAddress();
1014 error BurnedQueryForZeroAddress();
1015 error MintToZeroAddress();
1016 error MintZeroQuantity();
1017 error OwnerIndexOutOfBounds();
1018 error OwnerQueryForNonexistentToken();
1019 error TokenIndexOutOfBounds();
1020 error TransferCallerNotOwnerNorApproved();
1021 error TransferFromIncorrectOwner();
1022 error TransferToNonERC721ReceiverImplementer();
1023 error TransferToZeroAddress();
1024 error URIQueryForNonexistentToken();
1025 
1026 /**
1027  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1028  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1029  *
1030  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
1031  *
1032  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1033  *
1034  * Assumes that the maximum token id cannot exceed 2**128 - 1 (max value of uint128).
1035  */
1036 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1037     using Address for address;
1038     using Strings for uint256;
1039 
1040     // Compiler will pack this into a single 256bit word.
1041     struct TokenOwnership {
1042         // The address of the owner.
1043         address addr;
1044         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
1045         uint64 startTimestamp;
1046         // Whether the token has been burned.
1047         bool burned;
1048     }
1049 
1050     // Compiler will pack this into a single 256bit word.
1051     struct AddressData {
1052         // Realistically, 2**64-1 is more than enough.
1053         uint64 balance;
1054         // Keeps track of mint count with minimal overhead for tokenomics.
1055         uint64 numberMinted;
1056         // Keeps track of burn count with minimal overhead for tokenomics.
1057         uint64 numberBurned;
1058     }
1059 
1060     // Compiler will pack the following 
1061     // _currentIndex and _burnCounter into a single 256bit word.
1062     
1063     // The tokenId of the next token to be minted.
1064     uint128 internal _currentIndex;
1065 
1066     // The number of tokens burned.
1067     uint128 internal _burnCounter;
1068 
1069     // Token name
1070     string private _name;
1071 
1072     // Token symbol
1073     string private _symbol;
1074 
1075     // Mapping from token ID to ownership details
1076     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1077     mapping(uint256 => TokenOwnership) internal _ownerships;
1078 
1079     // Mapping owner address to address data
1080     mapping(address => AddressData) private _addressData;
1081 
1082     // Mapping from token ID to approved address
1083     mapping(uint256 => address) private _tokenApprovals;
1084 
1085     // Mapping from owner to operator approvals
1086     mapping(address => mapping(address => bool)) private _operatorApprovals;
1087 
1088     constructor(string memory name_, string memory symbol_) {
1089         _name = name_;
1090         _symbol = symbol_;
1091     }
1092 
1093     /**
1094      * @dev See {IERC721Enumerable-totalSupply}.
1095      */
1096     function totalSupply() public view override returns (uint256) {
1097         // Counter underflow is impossible as _burnCounter cannot be incremented
1098         // more than _currentIndex times
1099         unchecked {
1100             return _currentIndex - _burnCounter;    
1101         }
1102     }
1103 
1104     /**
1105      * @dev See {IERC721Enumerable-tokenByIndex}.
1106      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1107      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1108      */
1109     function tokenByIndex(uint256 index) public view override returns (uint256) {
1110         uint256 numMintedSoFar = _currentIndex;
1111         uint256 tokenIdsIdx;
1112 
1113         // Counter overflow is impossible as the loop breaks when
1114         // uint256 i is equal to another uint256 numMintedSoFar.
1115         unchecked {
1116             for (uint256 i; i < numMintedSoFar; i++) {
1117                 TokenOwnership memory ownership = _ownerships[i];
1118                 if (!ownership.burned) {
1119                     if (tokenIdsIdx == index) {
1120                         return i;
1121                     }
1122                     tokenIdsIdx++;
1123                 }
1124             }
1125         }
1126         revert TokenIndexOutOfBounds();
1127     }
1128 
1129     /**
1130      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1131      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1132      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1133      */
1134     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1135         if (index >= balanceOf(owner)) revert OwnerIndexOutOfBounds();
1136         uint256 numMintedSoFar = _currentIndex;
1137         uint256 tokenIdsIdx;
1138         address currOwnershipAddr;
1139 
1140         // Counter overflow is impossible as the loop breaks when
1141         // uint256 i is equal to another uint256 numMintedSoFar.
1142         unchecked {
1143             for (uint256 i; i < numMintedSoFar; i++) {
1144                 TokenOwnership memory ownership = _ownerships[i];
1145                 if (ownership.burned) {
1146                     continue;
1147                 }
1148                 if (ownership.addr != address(0)) {
1149                     currOwnershipAddr = ownership.addr;
1150                 }
1151                 if (currOwnershipAddr == owner) {
1152                     if (tokenIdsIdx == index) {
1153                         return i;
1154                     }
1155                     tokenIdsIdx++;
1156                 }
1157             }
1158         }
1159 
1160         // Execution should never reach this point.
1161         revert();
1162     }
1163 
1164     /**
1165      * @dev See {IERC165-supportsInterface}.
1166      */
1167     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1168         return
1169             interfaceId == type(IERC721).interfaceId ||
1170             interfaceId == type(IERC721Metadata).interfaceId ||
1171             interfaceId == type(IERC721Enumerable).interfaceId ||
1172             super.supportsInterface(interfaceId);
1173     }
1174 
1175     /**
1176      * @dev See {IERC721-balanceOf}.
1177      */
1178     function balanceOf(address owner) public view override returns (uint256) {
1179         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1180         return uint256(_addressData[owner].balance);
1181     }
1182 
1183     function _numberMinted(address owner) internal view returns (uint256) {
1184         if (owner == address(0)) revert MintedQueryForZeroAddress();
1185         return uint256(_addressData[owner].numberMinted);
1186     }
1187 
1188     function _numberBurned(address owner) internal view returns (uint256) {
1189         if (owner == address(0)) revert BurnedQueryForZeroAddress();
1190         return uint256(_addressData[owner].numberBurned);
1191     }
1192 
1193     /**
1194      * Gas spent here starts off proportional to the maximum mint batch size.
1195      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1196      */
1197     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1198         uint256 curr = tokenId;
1199 
1200         unchecked {
1201             if (curr < _currentIndex) {
1202                 TokenOwnership memory ownership = _ownerships[curr];
1203                 if (!ownership.burned) {
1204                     if (ownership.addr != address(0)) {
1205                         return ownership;
1206                     }
1207                     // Invariant: 
1208                     // There will always be an ownership that has an address and is not burned 
1209                     // before an ownership that does not have an address and is not burned.
1210                     // Hence, curr will not underflow.
1211                     while (true) {
1212                         curr--;
1213                         ownership = _ownerships[curr];
1214                         if (ownership.addr != address(0)) {
1215                             return ownership;
1216                         }
1217                     }
1218                 }
1219             }
1220         }
1221         revert OwnerQueryForNonexistentToken();
1222     }
1223 
1224     /**
1225      * @dev See {IERC721-ownerOf}.
1226      */
1227     function ownerOf(uint256 tokenId) public view override returns (address) {
1228         return ownershipOf(tokenId).addr;
1229     }
1230 
1231     /**
1232      * @dev See {IERC721Metadata-name}.
1233      */
1234     function name() public view virtual override returns (string memory) {
1235         return _name;
1236     }
1237 
1238     /**
1239      * @dev See {IERC721Metadata-symbol}.
1240      */
1241     function symbol() public view virtual override returns (string memory) {
1242         return _symbol;
1243     }
1244 
1245     /**
1246      * @dev See {IERC721Metadata-tokenURI}.
1247      */
1248     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1249         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1250 
1251         string memory baseURI = _baseURI();
1252         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1253     }
1254 
1255     /**
1256      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1257      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1258      * by default, can be overriden in child contracts.
1259      */
1260     function _baseURI() internal view virtual returns (string memory) {
1261         return '';
1262     }
1263 
1264     /**
1265      * @dev See {IERC721-approve}.
1266      */
1267     function approve(address to, uint256 tokenId) public override {
1268         address owner = ERC721A.ownerOf(tokenId);
1269         if (to == owner) revert ApprovalToCurrentOwner();
1270 
1271         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1272             revert ApprovalCallerNotOwnerNorApproved();
1273         }
1274 
1275         _approve(to, tokenId, owner);
1276     }
1277 
1278     /**
1279      * @dev See {IERC721-getApproved}.
1280      */
1281     function getApproved(uint256 tokenId) public view override returns (address) {
1282         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1283 
1284         return _tokenApprovals[tokenId];
1285     }
1286 
1287     /**
1288      * @dev See {IERC721-setApprovalForAll}.
1289      */
1290     function setApprovalForAll(address operator, bool approved) public override {
1291         if (operator == _msgSender()) revert ApproveToCaller();
1292 
1293         _operatorApprovals[_msgSender()][operator] = approved;
1294         emit ApprovalForAll(_msgSender(), operator, approved);
1295     }
1296 
1297     /**
1298      * @dev See {IERC721-isApprovedForAll}.
1299      */
1300     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1301         return _operatorApprovals[owner][operator];
1302     }
1303 
1304     /**
1305      * @dev See {IERC721-transferFrom}.
1306      */
1307     function transferFrom(
1308         address from,
1309         address to,
1310         uint256 tokenId
1311     ) public virtual override {
1312         _transfer(from, to, tokenId);
1313     }
1314 
1315     /**
1316      * @dev See {IERC721-safeTransferFrom}.
1317      */
1318     function safeTransferFrom(
1319         address from,
1320         address to,
1321         uint256 tokenId
1322     ) public virtual override {
1323         safeTransferFrom(from, to, tokenId, '');
1324     }
1325 
1326     /**
1327      * @dev See {IERC721-safeTransferFrom}.
1328      */
1329     function safeTransferFrom(
1330         address from,
1331         address to,
1332         uint256 tokenId,
1333         bytes memory _data
1334     ) public virtual override {
1335         _transfer(from, to, tokenId);
1336         if (!_checkOnERC721Received(from, to, tokenId, _data)) {
1337             revert TransferToNonERC721ReceiverImplementer();
1338         }
1339     }
1340 
1341     /**
1342      * @dev Returns whether `tokenId` exists.
1343      *
1344      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1345      *
1346      * Tokens start existing when they are minted (`_mint`),
1347      */
1348     function _exists(uint256 tokenId) internal view returns (bool) {
1349         return tokenId < _currentIndex && !_ownerships[tokenId].burned;
1350     }
1351 
1352     function _safeMint(address to, uint256 quantity) internal {
1353         _safeMint(to, quantity, '');
1354     }
1355 
1356     /**
1357      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1358      *
1359      * Requirements:
1360      *
1361      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1362      * - `quantity` must be greater than 0.
1363      *
1364      * Emits a {Transfer} event.
1365      */
1366     function _safeMint(
1367         address to,
1368         uint256 quantity,
1369         bytes memory _data
1370     ) internal {
1371         _mint(to, quantity, _data, true);
1372     }
1373 
1374     /**
1375      * @dev Mints `quantity` tokens and transfers them to `to`.
1376      *
1377      * Requirements:
1378      *
1379      * - `to` cannot be the zero address.
1380      * - `quantity` must be greater than 0.
1381      *
1382      * Emits a {Transfer} event.
1383      */
1384     function _mint(
1385         address to,
1386         uint256 quantity,
1387         bytes memory _data,
1388         bool safe
1389     ) internal {
1390         uint256 startTokenId = _currentIndex;
1391         if (to == address(0)) revert MintToZeroAddress();
1392         if (quantity == 0) revert MintZeroQuantity();
1393 
1394         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1395 
1396         // Overflows are incredibly unrealistic.
1397         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1398         // updatedIndex overflows if _currentIndex + quantity > 3.4e38 (2**128) - 1
1399         unchecked {
1400             _addressData[to].balance += uint64(quantity);
1401             _addressData[to].numberMinted += uint64(quantity);
1402 
1403             _ownerships[startTokenId].addr = to;
1404             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1405 
1406             uint256 updatedIndex = startTokenId;
1407 
1408             for (uint256 i; i < quantity; i++) {
1409                 emit Transfer(address(0), to, updatedIndex);
1410                 if (safe && !_checkOnERC721Received(address(0), to, updatedIndex, _data)) {
1411                     revert TransferToNonERC721ReceiverImplementer();
1412                 }
1413                 updatedIndex++;
1414             }
1415 
1416             _currentIndex = uint128(updatedIndex);
1417         }
1418         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1419     }
1420 
1421     /**
1422      * @dev Transfers `tokenId` from `from` to `to`.
1423      *
1424      * Requirements:
1425      *
1426      * - `to` cannot be the zero address.
1427      * - `tokenId` token must be owned by `from`.
1428      *
1429      * Emits a {Transfer} event.
1430      */
1431     function _transfer(
1432         address from,
1433         address to,
1434         uint256 tokenId
1435     ) private {
1436         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1437 
1438         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1439             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1440             getApproved(tokenId) == _msgSender());
1441 
1442         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1443         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1444         if (to == address(0)) revert TransferToZeroAddress();
1445 
1446         _beforeTokenTransfers(from, to, tokenId, 1);
1447 
1448         // Clear approvals from the previous owner
1449         _approve(address(0), tokenId, prevOwnership.addr);
1450 
1451         // Underflow of the sender's balance is impossible because we check for
1452         // ownership above and the recipient's balance can't realistically overflow.
1453         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**128.
1454         unchecked {
1455             _addressData[from].balance -= 1;
1456             _addressData[to].balance += 1;
1457 
1458             _ownerships[tokenId].addr = to;
1459             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1460 
1461             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1462             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1463             uint256 nextTokenId = tokenId + 1;
1464             if (_ownerships[nextTokenId].addr == address(0)) {
1465                 // This will suffice for checking _exists(nextTokenId),
1466                 // as a burned slot cannot contain the zero address.
1467                 if (nextTokenId < _currentIndex) {
1468                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1469                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1470                 }
1471             }
1472         }
1473 
1474         emit Transfer(from, to, tokenId);
1475         _afterTokenTransfers(from, to, tokenId, 1);
1476     }
1477 
1478     /**
1479      * @dev Destroys `tokenId`.
1480      * The approval is cleared when the token is burned.
1481      *
1482      * Requirements:
1483      *
1484      * - `tokenId` must exist.
1485      *
1486      * Emits a {Transfer} event.
1487      */
1488     function _burn(uint256 tokenId) internal virtual {
1489         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1490 
1491         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1492 
1493         // Clear approvals from the previous owner
1494         _approve(address(0), tokenId, prevOwnership.addr);
1495 
1496         // Underflow of the sender's balance is impossible because we check for
1497         // ownership above and the recipient's balance can't realistically overflow.
1498         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**128.
1499         unchecked {
1500             _addressData[prevOwnership.addr].balance -= 1;
1501             _addressData[prevOwnership.addr].numberBurned += 1;
1502 
1503             // Keep track of who burned the token, and the timestamp of burning.
1504             _ownerships[tokenId].addr = prevOwnership.addr;
1505             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1506             _ownerships[tokenId].burned = true;
1507 
1508             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1509             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1510             uint256 nextTokenId = tokenId + 1;
1511             if (_ownerships[nextTokenId].addr == address(0)) {
1512                 // This will suffice for checking _exists(nextTokenId),
1513                 // as a burned slot cannot contain the zero address.
1514                 if (nextTokenId < _currentIndex) {
1515                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1516                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1517                 }
1518             }
1519         }
1520 
1521         emit Transfer(prevOwnership.addr, address(0), tokenId);
1522         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1523 
1524         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1525         unchecked { 
1526             _burnCounter++;
1527         }
1528     }
1529 
1530     /**
1531      * @dev Approve `to` to operate on `tokenId`
1532      *
1533      * Emits a {Approval} event.
1534      */
1535     function _approve(
1536         address to,
1537         uint256 tokenId,
1538         address owner
1539     ) private {
1540         _tokenApprovals[tokenId] = to;
1541         emit Approval(owner, to, tokenId);
1542     }
1543 
1544     /**
1545      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1546      * The call is not executed if the target address is not a contract.
1547      *
1548      * @param from address representing the previous owner of the given token ID
1549      * @param to target address that will receive the tokens
1550      * @param tokenId uint256 ID of the token to be transferred
1551      * @param _data bytes optional data to send along with the call
1552      * @return bool whether the call correctly returned the expected magic value
1553      */
1554     function _checkOnERC721Received(
1555         address from,
1556         address to,
1557         uint256 tokenId,
1558         bytes memory _data
1559     ) private returns (bool) {
1560         if (to.isContract()) {
1561             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1562                 return retval == IERC721Receiver(to).onERC721Received.selector;
1563             } catch (bytes memory reason) {
1564                 if (reason.length == 0) {
1565                     revert TransferToNonERC721ReceiverImplementer();
1566                 } else {
1567                     assembly {
1568                         revert(add(32, reason), mload(reason))
1569                     }
1570                 }
1571             }
1572         } else {
1573             return true;
1574         }
1575     }
1576 
1577     /**
1578      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1579      * And also called before burning one token.
1580      *
1581      * startTokenId - the first token id to be transferred
1582      * quantity - the amount to be transferred
1583      *
1584      * Calling conditions:
1585      *
1586      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1587      * transferred to `to`.
1588      * - When `from` is zero, `tokenId` will be minted for `to`.
1589      * - When `to` is zero, `tokenId` will be burned by `from`.
1590      * - `from` and `to` are never both zero.
1591      */
1592     function _beforeTokenTransfers(
1593         address from,
1594         address to,
1595         uint256 startTokenId,
1596         uint256 quantity
1597     ) internal virtual {}
1598 
1599     /**
1600      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1601      * minting.
1602      * And also called after one token has been burned.
1603      *
1604      * startTokenId - the first token id to be transferred
1605      * quantity - the amount to be transferred
1606      *
1607      * Calling conditions:
1608      *
1609      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1610      * transferred to `to`.
1611      * - When `from` is zero, `tokenId` has been minted for `to`.
1612      * - When `to` is zero, `tokenId` has been burned by `from`.
1613      * - `from` and `to` are never both zero.
1614      */
1615     function _afterTokenTransfers(
1616         address from,
1617         address to,
1618         uint256 startTokenId,
1619         uint256 quantity
1620     ) internal virtual {}
1621 }
1622 
1623 // File: contracts/Shizuka.sol
1624 
1625 /**
1626 * SPDX-License-Identifier: UNLICENSED
1627 *
1628 *   ______________  _____               ______
1629 *   __  ___/___  /_ ___(_)__________  _____  /________ _
1630 *   _____ \ __  __ \__  / ___  /_  / / /__  //_/_  __ `/
1631 *   ____/ / _  / / /_  /  __  /_/ /_/ / _  ,<   / /_/ /
1632 *   /____/  /_/ /_/ /_/   _____/\__,_/  /_/|_|  \__,_/
1633 *
1634 *                 -- Shizuka NFT --
1635 *
1636 *   @author hemlock_dev@
1637 *   @date   Feb 2022
1638 *
1639 *   Used for minting Shizuka NFT, based on the ERC721A standard
1640 *   Coded with ♥ in rainy Vancouver, BC
1641 */
1642 pragma solidity 0.8.4;
1643 
1644 
1645 
1646 
1647 
1648 
1649 contract Shizuka is Ownable, ERC721A, ReentrancyGuard {
1650 
1651     uint256 public immutable maxBatchSize;
1652     uint256 public immutable amountForDevs;
1653     uint256 public immutable collectionSize;
1654 
1655     struct SaleConfig {
1656         uint32 allowlistSaleStartTime;
1657         uint32 publicSaleStartTime;
1658         uint32 mintEndTime;
1659         uint64 mintPrice;
1660         uint32 publicSaleKey;
1661     }
1662 
1663     SaleConfig public saleConfig;
1664 
1665     mapping(address => uint256) public _allowlistClaimed;
1666 
1667     constructor(
1668         uint256 maxBatchSize_,
1669         uint256 collectionSize_,
1670         uint256 amountForDevs_,
1671         uint32 publicSaleKey_,
1672         uint64 mintPriceWei_,
1673         uint32 allowlistSaleStartTime_,
1674         uint32 publicSaleStartTime_,
1675         uint32 mintEndTime_
1676     ) ERC721A("Shizuka", "SHIZ") {
1677         maxBatchSize = maxBatchSize_;
1678         collectionSize = collectionSize_;
1679         require(amountForDevs_ <= collectionSize_, "CollectionSizeTooSmall");
1680         amountForDevs = amountForDevs_;
1681         saleConfig = SaleConfig(
1682             allowlistSaleStartTime_,
1683             publicSaleStartTime_,
1684             mintEndTime_,
1685             mintPriceWei_,
1686             publicSaleKey_
1687         );
1688     }
1689 
1690     modifier callerIsUser() {
1691         require(tx.origin == msg.sender, "CallerIsAnotherContract");
1692         _;
1693     }
1694 
1695     function allowlistMint(bytes32 hash, bytes calldata signature, uint256 quantity, uint256 whitelistLimit)
1696     external
1697     payable
1698     nonReentrant
1699     callerIsUser
1700     {
1701         require(_verify(hash, signature), "InvalidSignature");
1702         require(_hashRegisterForAllowlistWithAmount(msg.sender, whitelistLimit) == hash, "InvalidHash");
1703         require(_allowlistClaimed[msg.sender] + quantity <= whitelistLimit, "MintAmountGreaterThanAllowed");
1704 
1705         SaleConfig memory config = saleConfig;
1706         uint256 allowlistPrice = uint256(config.mintPrice);
1707         uint256 allowlistSaleStartTime = uint256(config.allowlistSaleStartTime);
1708         uint256 saleEndTime = uint256(config.mintEndTime);
1709         require(isAllowlistSaleOn(allowlistSaleStartTime, saleEndTime), "AllowlistSaleOffline");
1710 
1711         _allowlistClaimed[msg.sender] += quantity;
1712         _validateMint(allowlistPrice, quantity);
1713         _safeMint(msg.sender, quantity);
1714     }
1715 
1716     function _hashRegisterForAllowlistWithAmount(address _address, uint256 amount) internal pure returns (bytes32) {
1717         return keccak256(abi.encodePacked(amount, _address));
1718     }
1719 
1720     function _verify(bytes32 hash, bytes memory signature) internal view returns (bool) {
1721         return (_recover(hash, signature) == owner());
1722     }
1723 
1724     function _recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1725         bytes32 messageDigest = keccak256(abi.encodePacked(
1726                 "\x19Ethereum Signed Message:\n32",
1727                 hash
1728         ));
1729         return ECDSA.recover(messageDigest, signature);
1730     }
1731 
1732     function publicSaleMint(uint256 quantity, uint256 callerPublicSaleKey)
1733     external
1734     payable
1735     nonReentrant
1736     callerIsUser
1737     {
1738         SaleConfig memory config = saleConfig;
1739         uint256 publicSaleKey = uint256(config.publicSaleKey);
1740         uint256 publicPrice = uint256(config.mintPrice);
1741         uint256 publicSaleStartTime = uint256(config.publicSaleStartTime);
1742         uint256 publicSaleEndTime = uint256(config.mintEndTime);
1743 
1744         require(publicSaleKey == callerPublicSaleKey, "BadPublicKey");
1745         require(isPublicSaleOn(publicSaleKey, publicSaleStartTime, publicSaleEndTime), "PublicSaleOffline");
1746 
1747         _validateMint(publicPrice, quantity);
1748         _safeMint(msg.sender, quantity);
1749     }
1750 
1751     function _validateMint(uint256 price, uint256 quantity) private {
1752         require(msg.value >= (price * quantity), "NotEnoughEth");
1753         require(quantity <= maxBatchSize, "MintAmountGreaterThanAllowed");
1754         require(totalSupply() + quantity <= collectionSize, "MaxSupplyReached");
1755     }
1756 
1757     function isPublicSaleOn(
1758         uint256 publicSaleKey,
1759         uint256 publicSaleStartTime,
1760         uint256 mintEndTime
1761     ) public view returns (bool) {
1762         return
1763         publicSaleKey != 0 &&
1764         block.timestamp >= publicSaleStartTime &&
1765         block.timestamp < mintEndTime;
1766     }
1767 
1768     function isAllowlistSaleOn(
1769         uint256 allowlistSaleStartTime,
1770         uint256 mintEndTime
1771     ) public view returns (bool) {
1772         return
1773         block.timestamp >= allowlistSaleStartTime &&
1774         block.timestamp < mintEndTime;
1775     }
1776 
1777     function setAllowlistSaleStartTime(uint32 timestamp) external onlyOwner {
1778         saleConfig.allowlistSaleStartTime = timestamp;
1779     }
1780 
1781     function setPublicSaleStartTime(uint32 timestamp) external onlyOwner {
1782         saleConfig.publicSaleStartTime = timestamp;
1783     }
1784 
1785     function setPublicSaleKey(uint32 key) external onlyOwner {
1786         saleConfig.publicSaleKey = key;
1787     }
1788 
1789     function setMintEndTime(uint32 timestamp) external onlyOwner {
1790         saleConfig.mintEndTime = timestamp;
1791     }
1792 
1793     function setMintPrice(uint64 price) external onlyOwner {
1794         saleConfig.mintPrice = price;
1795     }
1796 
1797     function devMint(uint256 quantity) external onlyOwner {
1798         require(totalSupply() + quantity <= collectionSize, "MaxSupplyReached");
1799         require(numberMinted(msg.sender) + quantity <= amountForDevs, "MaxDevMintReached");
1800         uint256 numChunks = quantity / maxBatchSize;
1801         for (uint256 i = 0; i < numChunks; i++) {
1802             _safeMint(msg.sender, maxBatchSize);
1803         }
1804     }
1805 
1806     // Used for reveal : set base uri to ipfs link
1807     string private _baseTokenURI;
1808 
1809     function _baseURI() internal view virtual override returns (string memory) {
1810         return _baseTokenURI;
1811     }
1812 
1813     function setBaseURI(string calldata baseURI) external onlyOwner {
1814         _baseTokenURI = baseURI;
1815     }
1816 
1817     function withdrawMoney() external onlyOwner {
1818         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1819         require(success, "TransactionFailure");
1820     }
1821 
1822     function numberMinted(address owner) public view returns (uint256) {
1823         return _numberMinted(owner);
1824     }
1825 
1826     function getOwnershipData(uint256 tokenId)
1827     external
1828     view
1829     returns (TokenOwnership memory)
1830     {
1831         return ownershipOf(tokenId);
1832     }
1833 }