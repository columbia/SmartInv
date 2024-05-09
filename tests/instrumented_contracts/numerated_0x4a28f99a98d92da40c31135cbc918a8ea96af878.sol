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
1015 error AuxQueryForZeroAddress();
1016 error MintToZeroAddress();
1017 error MintZeroQuantity();
1018 error OwnerIndexOutOfBounds();
1019 error OwnerQueryForNonexistentToken();
1020 error TokenIndexOutOfBounds();
1021 error TransferCallerNotOwnerNorApproved();
1022 error TransferFromIncorrectOwner();
1023 error TransferToNonERC721ReceiverImplementer();
1024 error TransferToZeroAddress();
1025 error URIQueryForNonexistentToken();
1026 
1027 /**
1028  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1029  * the Metadata extension. Built to optimize for lower gas during batch mints.
1030  *
1031  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1032  *
1033  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1034  *
1035  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
1036  */
1037 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
1038     using Address for address;
1039     using Strings for uint256;
1040 
1041     // Compiler will pack this into a single 256bit word.
1042     struct TokenOwnership {
1043         // The address of the owner.
1044         address addr;
1045         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
1046         uint64 startTimestamp;
1047         // Whether the token has been burned.
1048         bool burned;
1049     }
1050 
1051     // Compiler will pack this into a single 256bit word.
1052     struct AddressData {
1053         // Realistically, 2**64-1 is more than enough.
1054         uint64 balance;
1055         // Keeps track of mint count with minimal overhead for tokenomics.
1056         uint64 numberMinted;
1057         // Keeps track of burn count with minimal overhead for tokenomics.
1058         uint64 numberBurned;
1059         // For miscellaneous variable(s) pertaining to the address
1060         // (e.g. number of whitelist mint slots used).
1061         // If there are multiple variables, please pack them into a uint64.
1062         uint64 aux;
1063     }
1064 
1065     // The tokenId of the next token to be minted.
1066     uint256 internal _currentIndex;
1067 
1068     // The number of tokens burned.
1069     uint256 internal _burnCounter;
1070 
1071     // Token name
1072     string private _name;
1073 
1074     // Token symbol
1075     string private _symbol;
1076 
1077     // Mapping from token ID to ownership details
1078     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1079     mapping(uint256 => TokenOwnership) internal _ownerships;
1080 
1081     // Mapping owner address to address data
1082     mapping(address => AddressData) private _addressData;
1083 
1084     // Mapping from token ID to approved address
1085     mapping(uint256 => address) private _tokenApprovals;
1086 
1087     // Mapping from owner to operator approvals
1088     mapping(address => mapping(address => bool)) private _operatorApprovals;
1089 
1090     constructor(string memory name_, string memory symbol_) {
1091         _name = name_;
1092         _symbol = symbol_;
1093         _currentIndex = _startTokenId();
1094     }
1095 
1096     /**
1097      * To change the starting tokenId, please override this function.
1098      */
1099     function _startTokenId() internal view virtual returns (uint256) {
1100         return 0;
1101     }
1102 
1103     /**
1104      * @dev See {IERC721Enumerable-totalSupply}.
1105      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
1106      */
1107     function totalSupply() public view returns (uint256) {
1108         // Counter underflow is impossible as _burnCounter cannot be incremented
1109         // more than _currentIndex - _startTokenId() times
1110         unchecked {
1111             return _currentIndex - _burnCounter - _startTokenId();
1112         }
1113     }
1114 
1115     /**
1116      * Returns the total amount of tokens minted in the contract.
1117      */
1118     function _totalMinted() internal view returns (uint256) {
1119         // Counter underflow is impossible as _currentIndex does not decrement,
1120         // and it is initialized to _startTokenId()
1121         unchecked {
1122             return _currentIndex - _startTokenId();
1123         }
1124     }
1125 
1126     /**
1127      * @dev See {IERC165-supportsInterface}.
1128      */
1129     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1130         return
1131             interfaceId == type(IERC721).interfaceId ||
1132             interfaceId == type(IERC721Metadata).interfaceId ||
1133             super.supportsInterface(interfaceId);
1134     }
1135 
1136     /**
1137      * @dev See {IERC721-balanceOf}.
1138      */
1139     function balanceOf(address owner) public view override returns (uint256) {
1140         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1141         return uint256(_addressData[owner].balance);
1142     }
1143 
1144     /**
1145      * Returns the number of tokens minted by `owner`.
1146      */
1147     function _numberMinted(address owner) internal view returns (uint256) {
1148         if (owner == address(0)) revert MintedQueryForZeroAddress();
1149         return uint256(_addressData[owner].numberMinted);
1150     }
1151 
1152     /**
1153      * Returns the number of tokens burned by or on behalf of `owner`.
1154      */
1155     function _numberBurned(address owner) internal view returns (uint256) {
1156         if (owner == address(0)) revert BurnedQueryForZeroAddress();
1157         return uint256(_addressData[owner].numberBurned);
1158     }
1159 
1160     /**
1161      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1162      */
1163     function _getAux(address owner) internal view returns (uint64) {
1164         if (owner == address(0)) revert AuxQueryForZeroAddress();
1165         return _addressData[owner].aux;
1166     }
1167 
1168     /**
1169      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1170      * If there are multiple variables, please pack them into a uint64.
1171      */
1172     function _setAux(address owner, uint64 aux) internal {
1173         if (owner == address(0)) revert AuxQueryForZeroAddress();
1174         _addressData[owner].aux = aux;
1175     }
1176 
1177     /**
1178      * Gas spent here starts off proportional to the maximum mint batch size.
1179      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1180      */
1181     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1182         uint256 curr = tokenId;
1183 
1184         unchecked {
1185             if (_startTokenId() <= curr && curr < _currentIndex) {
1186                 TokenOwnership memory ownership = _ownerships[curr];
1187                 if (!ownership.burned) {
1188                     if (ownership.addr != address(0)) {
1189                         return ownership;
1190                     }
1191                     // Invariant:
1192                     // There will always be an ownership that has an address and is not burned
1193                     // before an ownership that does not have an address and is not burned.
1194                     // Hence, curr will not underflow.
1195                     while (true) {
1196                         curr--;
1197                         ownership = _ownerships[curr];
1198                         if (ownership.addr != address(0)) {
1199                             return ownership;
1200                         }
1201                     }
1202                 }
1203             }
1204         }
1205         revert OwnerQueryForNonexistentToken();
1206     }
1207 
1208     /**
1209      * @dev See {IERC721-ownerOf}.
1210      */
1211     function ownerOf(uint256 tokenId) public view override returns (address) {
1212         return ownershipOf(tokenId).addr;
1213     }
1214 
1215     /**
1216      * @dev See {IERC721Metadata-name}.
1217      */
1218     function name() public view virtual override returns (string memory) {
1219         return _name;
1220     }
1221 
1222     /**
1223      * @dev See {IERC721Metadata-symbol}.
1224      */
1225     function symbol() public view virtual override returns (string memory) {
1226         return _symbol;
1227     }
1228 
1229     /**
1230      * @dev See {IERC721Metadata-tokenURI}.
1231      */
1232     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1233         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1234 
1235         string memory baseURI = _baseURI();
1236         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1237     }
1238 
1239     /**
1240      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1241      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1242      * by default, can be overriden in child contracts.
1243      */
1244     function _baseURI() internal view virtual returns (string memory) {
1245         return '';
1246     }
1247 
1248     /**
1249      * @dev See {IERC721-approve}.
1250      */
1251     function approve(address to, uint256 tokenId) public override {
1252         address owner = ERC721A.ownerOf(tokenId);
1253         if (to == owner) revert ApprovalToCurrentOwner();
1254 
1255         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1256             revert ApprovalCallerNotOwnerNorApproved();
1257         }
1258 
1259         _approve(to, tokenId, owner);
1260     }
1261 
1262     /**
1263      * @dev See {IERC721-getApproved}.
1264      */
1265     function getApproved(uint256 tokenId) public view override returns (address) {
1266         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1267 
1268         return _tokenApprovals[tokenId];
1269     }
1270 
1271     /**
1272      * @dev See {IERC721-setApprovalForAll}.
1273      */
1274     function setApprovalForAll(address operator, bool approved) public override {
1275         if (operator == _msgSender()) revert ApproveToCaller();
1276 
1277         _operatorApprovals[_msgSender()][operator] = approved;
1278         emit ApprovalForAll(_msgSender(), operator, approved);
1279     }
1280 
1281     /**
1282      * @dev See {IERC721-isApprovedForAll}.
1283      */
1284     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1285         return _operatorApprovals[owner][operator];
1286     }
1287 
1288     /**
1289      * @dev See {IERC721-transferFrom}.
1290      */
1291     function transferFrom(
1292         address from,
1293         address to,
1294         uint256 tokenId
1295     ) public virtual override {
1296         _transfer(from, to, tokenId);
1297     }
1298 
1299     /**
1300      * @dev See {IERC721-safeTransferFrom}.
1301      */
1302     function safeTransferFrom(
1303         address from,
1304         address to,
1305         uint256 tokenId
1306     ) public virtual override {
1307         safeTransferFrom(from, to, tokenId, '');
1308     }
1309 
1310     /**
1311      * @dev See {IERC721-safeTransferFrom}.
1312      */
1313     function safeTransferFrom(
1314         address from,
1315         address to,
1316         uint256 tokenId,
1317         bytes memory _data
1318     ) public virtual override {
1319         _transfer(from, to, tokenId);
1320         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1321             revert TransferToNonERC721ReceiverImplementer();
1322         }
1323     }
1324 
1325     /**
1326      * @dev Returns whether `tokenId` exists.
1327      *
1328      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1329      *
1330      * Tokens start existing when they are minted (`_mint`),
1331      */
1332     function _exists(uint256 tokenId) internal view returns (bool) {
1333         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1334             !_ownerships[tokenId].burned;
1335     }
1336 
1337     function _safeMint(address to, uint256 quantity) internal {
1338         _safeMint(to, quantity, '');
1339     }
1340 
1341     /**
1342      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1343      *
1344      * Requirements:
1345      *
1346      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1347      * - `quantity` must be greater than 0.
1348      *
1349      * Emits a {Transfer} event.
1350      */
1351     function _safeMint(
1352         address to,
1353         uint256 quantity,
1354         bytes memory _data
1355     ) internal {
1356         _mint(to, quantity, _data, true);
1357     }
1358 
1359     /**
1360      * @dev Mints `quantity` tokens and transfers them to `to`.
1361      *
1362      * Requirements:
1363      *
1364      * - `to` cannot be the zero address.
1365      * - `quantity` must be greater than 0.
1366      *
1367      * Emits a {Transfer} event.
1368      */
1369     function _mint(
1370         address to,
1371         uint256 quantity,
1372         bytes memory _data,
1373         bool safe
1374     ) internal {
1375         uint256 startTokenId = _currentIndex;
1376         if (to == address(0)) revert MintToZeroAddress();
1377         if (quantity == 0) revert MintZeroQuantity();
1378 
1379         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1380 
1381         // Overflows are incredibly unrealistic.
1382         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1383         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1384         unchecked {
1385             _addressData[to].balance += uint64(quantity);
1386             _addressData[to].numberMinted += uint64(quantity);
1387 
1388             _ownerships[startTokenId].addr = to;
1389             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1390 
1391             uint256 updatedIndex = startTokenId;
1392             uint256 end = updatedIndex + quantity;
1393 
1394             if (safe && to.isContract()) {
1395                 do {
1396                     emit Transfer(address(0), to, updatedIndex);
1397                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1398                         revert TransferToNonERC721ReceiverImplementer();
1399                     }
1400                 } while (updatedIndex != end);
1401                 // Reentrancy protection
1402                 if (_currentIndex != startTokenId) revert();
1403             } else {
1404                 do {
1405                     emit Transfer(address(0), to, updatedIndex++);
1406                 } while (updatedIndex != end);
1407             }
1408             _currentIndex = updatedIndex;
1409         }
1410         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1411     }
1412 
1413     /**
1414      * @dev Transfers `tokenId` from `from` to `to`.
1415      *
1416      * Requirements:
1417      *
1418      * - `to` cannot be the zero address.
1419      * - `tokenId` token must be owned by `from`.
1420      *
1421      * Emits a {Transfer} event.
1422      */
1423     function _transfer(
1424         address from,
1425         address to,
1426         uint256 tokenId
1427     ) private {
1428         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1429 
1430         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1431             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1432             getApproved(tokenId) == _msgSender());
1433 
1434         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1435         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1436         if (to == address(0)) revert TransferToZeroAddress();
1437 
1438         _beforeTokenTransfers(from, to, tokenId, 1);
1439 
1440         // Clear approvals from the previous owner
1441         _approve(address(0), tokenId, prevOwnership.addr);
1442 
1443         // Underflow of the sender's balance is impossible because we check for
1444         // ownership above and the recipient's balance can't realistically overflow.
1445         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1446         unchecked {
1447             _addressData[from].balance -= 1;
1448             _addressData[to].balance += 1;
1449 
1450             _ownerships[tokenId].addr = to;
1451             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1452 
1453             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1454             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1455             uint256 nextTokenId = tokenId + 1;
1456             if (_ownerships[nextTokenId].addr == address(0)) {
1457                 // This will suffice for checking _exists(nextTokenId),
1458                 // as a burned slot cannot contain the zero address.
1459                 if (nextTokenId < _currentIndex) {
1460                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1461                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1462                 }
1463             }
1464         }
1465 
1466         emit Transfer(from, to, tokenId);
1467         _afterTokenTransfers(from, to, tokenId, 1);
1468     }
1469 
1470     /**
1471      * @dev Destroys `tokenId`.
1472      * The approval is cleared when the token is burned.
1473      *
1474      * Requirements:
1475      *
1476      * - `tokenId` must exist.
1477      *
1478      * Emits a {Transfer} event.
1479      */
1480     function _burn(uint256 tokenId) internal virtual {
1481         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1482 
1483         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1484 
1485         // Clear approvals from the previous owner
1486         _approve(address(0), tokenId, prevOwnership.addr);
1487 
1488         // Underflow of the sender's balance is impossible because we check for
1489         // ownership above and the recipient's balance can't realistically overflow.
1490         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1491         unchecked {
1492             _addressData[prevOwnership.addr].balance -= 1;
1493             _addressData[prevOwnership.addr].numberBurned += 1;
1494 
1495             // Keep track of who burned the token, and the timestamp of burning.
1496             _ownerships[tokenId].addr = prevOwnership.addr;
1497             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1498             _ownerships[tokenId].burned = true;
1499 
1500             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1501             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1502             uint256 nextTokenId = tokenId + 1;
1503             if (_ownerships[nextTokenId].addr == address(0)) {
1504                 // This will suffice for checking _exists(nextTokenId),
1505                 // as a burned slot cannot contain the zero address.
1506                 if (nextTokenId < _currentIndex) {
1507                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1508                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1509                 }
1510             }
1511         }
1512 
1513         emit Transfer(prevOwnership.addr, address(0), tokenId);
1514         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1515 
1516         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1517         unchecked {
1518             _burnCounter++;
1519         }
1520     }
1521 
1522     /**
1523      * @dev Approve `to` to operate on `tokenId`
1524      *
1525      * Emits a {Approval} event.
1526      */
1527     function _approve(
1528         address to,
1529         uint256 tokenId,
1530         address owner
1531     ) private {
1532         _tokenApprovals[tokenId] = to;
1533         emit Approval(owner, to, tokenId);
1534     }
1535 
1536     /**
1537      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1538      *
1539      * @param from address representing the previous owner of the given token ID
1540      * @param to target address that will receive the tokens
1541      * @param tokenId uint256 ID of the token to be transferred
1542      * @param _data bytes optional data to send along with the call
1543      * @return bool whether the call correctly returned the expected magic value
1544      */
1545     function _checkContractOnERC721Received(
1546         address from,
1547         address to,
1548         uint256 tokenId,
1549         bytes memory _data
1550     ) private returns (bool) {
1551         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1552             return retval == IERC721Receiver(to).onERC721Received.selector;
1553         } catch (bytes memory reason) {
1554             if (reason.length == 0) {
1555                 revert TransferToNonERC721ReceiverImplementer();
1556             } else {
1557                 assembly {
1558                     revert(add(32, reason), mload(reason))
1559                 }
1560             }
1561         }
1562     }
1563 
1564     /**
1565      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1566      * And also called before burning one token.
1567      *
1568      * startTokenId - the first token id to be transferred
1569      * quantity - the amount to be transferred
1570      *
1571      * Calling conditions:
1572      *
1573      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1574      * transferred to `to`.
1575      * - When `from` is zero, `tokenId` will be minted for `to`.
1576      * - When `to` is zero, `tokenId` will be burned by `from`.
1577      * - `from` and `to` are never both zero.
1578      */
1579     function _beforeTokenTransfers(
1580         address from,
1581         address to,
1582         uint256 startTokenId,
1583         uint256 quantity
1584     ) internal virtual {}
1585 
1586     /**
1587      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1588      * minting.
1589      * And also called after one token has been burned.
1590      *
1591      * startTokenId - the first token id to be transferred
1592      * quantity - the amount to be transferred
1593      *
1594      * Calling conditions:
1595      *
1596      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1597      * transferred to `to`.
1598      * - When `from` is zero, `tokenId` has been minted for `to`.
1599      * - When `to` is zero, `tokenId` has been burned by `from`.
1600      * - `from` and `to` are never both zero.
1601      */
1602     function _afterTokenTransfers(
1603         address from,
1604         address to,
1605         uint256 startTokenId,
1606         uint256 quantity
1607     ) internal virtual {}
1608 }
1609 
1610 // File: contracts/DopeHeadsNFT.sol
1611 
1612 
1613 
1614 pragma solidity ^0.8.4;
1615 
1616 
1617 
1618 
1619 
1620 
1621 contract RewardDistributor is Ownable {
1622   address[] public investors;
1623   uint256[] public investorAmounts;
1624 
1625   receive() payable external {
1626   }
1627 
1628   function setInvestors(address[] calldata _investors) external onlyOwner {
1629     delete investors;
1630     investors = _investors;
1631   }
1632 
1633   function setInvestorAmounts(uint32[] calldata _amounts) external onlyOwner {
1634     require(
1635       _amounts.length == investors.length,
1636       "The numbers doesn't match with the investors"
1637     );
1638 
1639     uint256 sum = 0;
1640     for (uint256 i = 0; i < _amounts.length; i++) {
1641       sum += _amounts[i];
1642     }
1643     require(sum == 10000, "The sum of the numbers must be 10000");
1644 
1645     delete investorAmounts;
1646     investorAmounts = _amounts;
1647   }
1648 
1649   function withdraw() public onlyOwner {
1650     require(investorAmounts.length > 0, "No investors specified");
1651 
1652     uint256 bal = address(this).balance;
1653 
1654     for (uint256 i = 0; i < investors.length; i++) {
1655       if (investorAmounts[i] > 0) {
1656         Address.sendValue(payable(investors[i]), bal * investorAmounts[i] / 10000);
1657       }
1658     }
1659   }
1660 }
1661 
1662 contract Whitelist is Ownable {
1663     using ECDSA for bytes32;
1664     address signer1;
1665     address signer2;
1666 
1667     function setSigners(address _signer1, address _signer2) external onlyOwner {
1668         signer1 = _signer1;
1669         signer2 = _signer2;
1670     }
1671 
1672     function getRecoverAddress(bytes calldata signature) internal view returns (address) {
1673         bytes32 hash = keccak256(abi.encodePacked(this, msg.sender));
1674         hash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1675         return hash.recover(signature);
1676     }
1677 
1678     modifier onlyWhitelist1(bytes calldata signature) {
1679         require(signer1 != address (0), "Signer 1 Not Set");
1680         require(getRecoverAddress(signature) == signer1, "Not Whitelisted 1");
1681         _;
1682     }
1683 
1684     modifier onlyWhitelist2(bytes calldata signature) {
1685         require(signer2 != address (0), "Signer 2 Not Set");
1686         require(getRecoverAddress(signature) == signer2, "Not Whitelisted 2");
1687         _;
1688     }
1689 }
1690 
1691 contract DopeHeadsNFT is ERC721A("DopeHeadsNFT", "DH4L"), Whitelist, RewardDistributor {
1692   using Strings for uint;
1693 
1694   uint public price = 0.15 ether;
1695   uint public priceWL1 = 0.1 ether;
1696   uint public priceWL2 = 0.125 ether;
1697 
1698   uint public limitPerAddress = 5;
1699 
1700   uint private _currentId = 0;
1701 
1702   uint immutable public LOCK_7d = 7 days;
1703   uint immutable public LOCK_6mo = 183 days;
1704   uint immutable public LOCK_12mo = 365 days;
1705 
1706   uint public maxSupply = 10000;
1707 
1708   mapping(uint=>uint) private _tokenUnlockTime;
1709   mapping(address=>uint) public addressMints;
1710 
1711   string public unrevealedURI;
1712   string public baseURI;
1713   string public baseExtension;
1714 
1715   bool public saleOpen;
1716   bool public saleWLOpen;
1717 
1718   struct MintData {
1719     address to;
1720     uint amount1;
1721     uint amount2;
1722     uint amount3;
1723   }
1724 
1725   function setPrices(uint _price, uint _priceWL1, uint _priceWL2) external onlyOwner {
1726     price = _price;
1727     priceWL1 = _priceWL1;
1728     priceWL2 = _priceWL2;
1729   }
1730 
1731   function setUnrevealedURI(string memory _uri) external onlyOwner {
1732     unrevealedURI = _uri;
1733   }
1734 
1735   function setBaseURI(string memory _uri) external onlyOwner {
1736     baseURI = _uri;
1737   }
1738 
1739   function setBaseExtension(string memory _ext) external onlyOwner {
1740     baseExtension = _ext;
1741   }
1742 
1743   function startSale() external onlyOwner {
1744     saleOpen = true;
1745   }
1746 
1747   function endSale() external onlyOwner {
1748     saleOpen = false;
1749   }
1750 
1751   function startWLSale() external onlyOwner {
1752     saleWLOpen = true;
1753   }
1754 
1755   function endWLSale() external onlyOwner {
1756     saleWLOpen = false;
1757   }
1758 
1759   function _startTokenId() internal pure override returns (uint256) {
1760     return 1;
1761   }
1762 
1763   function tokenUnlockTime(uint tokenId) public view returns (uint) {
1764     require (_exists(tokenId), "Nonexistent token ID");
1765 
1766     uint id = tokenId;
1767     while (_tokenUnlockTime[id] == 0 && id < _currentId) {
1768       id++;
1769     }
1770 
1771     return _tokenUnlockTime[id];
1772   }
1773 
1774   function _mint(address to, uint amount1, uint amount2, uint amount3) internal {
1775 
1776     uint totalMint = amount1 + amount2 + amount3;
1777 
1778     require (totalMint >= 1 && totalMint <= 5, "Invalid mint amount");
1779     require(addressMints[to] + totalMint <= limitPerAddress, "You can't have more than 5");
1780 
1781     require (_currentId + totalMint <= maxSupply, "You cannot mint any more");
1782 
1783     _safeMint(to, totalMint);
1784 
1785     addressMints[to] += totalMint;
1786 
1787     if (amount1 > 0) {
1788       _currentId += amount1;
1789       _tokenUnlockTime[_currentId] = block.timestamp + LOCK_7d;
1790     }
1791 
1792     if (amount2 > 0) {
1793       _currentId += amount2;
1794       _tokenUnlockTime[_currentId] = block.timestamp + LOCK_6mo;
1795     }
1796 
1797     if (amount3 > 0) {
1798       _currentId += amount3;
1799       _tokenUnlockTime[_currentId] = block.timestamp + LOCK_12mo;
1800     }
1801   }
1802 
1803   function mint(uint amount1, uint amount2, uint amount3) external payable {
1804     uint totalCost = (amount1 + amount2 + amount3) * price;
1805     require(msg.value >= totalCost, "Insufficient payment");
1806     require (saleOpen, "Sale is not open");
1807 
1808     _mint(msg.sender, amount1, amount2, amount3);
1809 
1810     if (msg.value > totalCost) {
1811       Address.sendValue(payable(msg.sender), msg.value - totalCost);
1812     }
1813   }
1814 
1815   function mintWL1(uint amount1, uint amount2, uint amount3, bytes calldata sign) external payable onlyWhitelist1(sign) {
1816     uint totalCost = (amount1 + amount2 + amount3) * priceWL1;
1817     require(msg.value >= totalCost, "Insufficient payment");
1818     require (saleWLOpen, "Whitelist sale is not open");
1819 
1820     _mint(msg.sender, amount1, amount2, amount3);
1821 
1822     if (msg.value > totalCost) {
1823       Address.sendValue(payable(msg.sender), msg.value - totalCost);
1824     }
1825   }
1826 
1827   function mintWL2(uint amount1, uint amount2, uint amount3, bytes calldata sign) external payable onlyWhitelist2(sign) {
1828     uint totalCost = (amount1 + amount2 + amount3) * priceWL2;
1829     require(msg.value >= totalCost, "Insufficient payment");
1830     require (saleWLOpen, "Whitelist sale is not open");
1831 
1832     _mint(msg.sender, amount1, amount2, amount3);
1833 
1834     if (msg.value > totalCost) {
1835       Address.sendValue(payable(msg.sender), msg.value - totalCost);
1836     }
1837   }
1838 
1839   function mintAirdrop(MintData[] memory _data) external onlyOwner {
1840     uint i = 0;
1841     for (i = 0; i < _data.length; i+=1) {
1842       _mint(_data[i].to, _data[i].amount1, _data[i].amount2, _data[i].amount3);
1843     }
1844   }
1845 
1846   function tokenURI(uint tokenId) public view override returns (string memory) {
1847     require (_exists(tokenId), "Nonexistent token ID");
1848 
1849     if (block.timestamp < tokenUnlockTime(tokenId)) {
1850       return unrevealedURI;
1851     }
1852 
1853     return string(abi.encodePacked(baseURI, tokenId.toString(), baseExtension));
1854   }
1855 
1856   function burn(uint tokenId) external {
1857     require (ownerOf(tokenId) == msg.sender, "You are not the token owner");
1858 
1859     _burn(tokenId);
1860   }
1861 
1862   function walletOfOwner(address _owner)
1863     public
1864     view
1865     returns (uint256[] memory)
1866   {
1867     uint256 ownerTokenCount = balanceOf(_owner);
1868     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1869     uint256 currentTokenId = _startTokenId();
1870     uint256 ownedTokenIndex = 0;
1871     address latestOwnerAddress;
1872 
1873     while (
1874       ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply
1875     ) {
1876       TokenOwnership memory ownership = _ownerships[currentTokenId];
1877 
1878       if (!ownership.burned && ownership.addr != address(0)) {
1879         latestOwnerAddress = ownership.addr;
1880       }
1881 
1882       if (latestOwnerAddress == _owner) {
1883         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1884 
1885         ownedTokenIndex++;
1886       }
1887 
1888       currentTokenId++;
1889     }
1890 
1891     return ownedTokenIds;
1892   }
1893 }