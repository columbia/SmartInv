1 // SPDX-License-Identifier: MIT
2 /*
3    ___   ____  ____   _      __ __      ____   ____  ____   ___   _____
4   /  _] /    ||    \ | |    |  |  |    |    \ |    ||    \ |   \ / ___/
5  /  [_ |  o  ||  D  )| |    |  |  |    |  o  ) |  | |  D  )|    (   \_ 
6 |    _]|     ||    / | |___ |  ~  |    |     | |  | |    / |  D  \__  |
7 |   [_ |  _  ||    \ |     ||___, |    |  O  | |  | |    \ |     /  \ |
8 |     ||  |  ||  .  \|     ||     |    |     | |  | |  .  \|     \    |
9 |_____||__|__||__|\_||_____||____/     |_____||____||__|\_||_____|\___|
10                                                                        
11                       by Devko.dev#7286
12 */
13 // File: @openzeppelin/contracts/utils/Strings.sol
14 
15 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
16 
17 pragma solidity ^0.8.0;
18 
19 /**
20  * @dev String operations.
21  */
22 library Strings {
23     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
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
69     function toHexString(uint256 value, uint256 length)
70         internal
71         pure
72         returns (string memory)
73     {
74         bytes memory buffer = new bytes(2 * length + 2);
75         buffer[0] = "0";
76         buffer[1] = "x";
77         for (uint256 i = 2 * length + 1; i > 1; --i) {
78             buffer[i] = _HEX_SYMBOLS[value & 0xf];
79             value >>= 4;
80         }
81         require(value == 0, "Strings: hex length insufficient");
82         return string(buffer);
83     }
84 }
85 
86 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
87 
88 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/ECDSA.sol)
89 
90 pragma solidity ^0.8.0;
91 
92 /**
93  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
94  *
95  * These functions can be used to verify that a message was signed by the holder
96  * of the private keys of a given address.
97  */
98 library ECDSA {
99     enum RecoverError {
100         NoError,
101         InvalidSignature,
102         InvalidSignatureLength,
103         InvalidSignatureS,
104         InvalidSignatureV
105     }
106 
107     function _throwError(RecoverError error) private pure {
108         if (error == RecoverError.NoError) {
109             return; // no error: do nothing
110         } else if (error == RecoverError.InvalidSignature) {
111             revert("ECDSA: invalid signature");
112         } else if (error == RecoverError.InvalidSignatureLength) {
113             revert("ECDSA: invalid signature length");
114         } else if (error == RecoverError.InvalidSignatureS) {
115             revert("ECDSA: invalid signature 's' value");
116         } else if (error == RecoverError.InvalidSignatureV) {
117             revert("ECDSA: invalid signature 'v' value");
118         }
119     }
120 
121     /**
122      * @dev Returns the address that signed a hashed message (`hash`) with
123      * `signature` or error string. This address can then be used for verification purposes.
124      *
125      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
126      * this function rejects them by requiring the `s` value to be in the lower
127      * half order, and the `v` value to be either 27 or 28.
128      *
129      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
130      * verification to be secure: it is possible to craft signatures that
131      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
132      * this is by receiving a hash of the original message (which may otherwise
133      * be too long), and then calling {toEthSignedMessageHash} on it.
134      *
135      * Documentation for signature generation:
136      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
137      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
138      *
139      * _Available since v4.3._
140      */
141     function tryRecover(bytes32 hash, bytes memory signature)
142         internal
143         pure
144         returns (address, RecoverError)
145     {
146         // Check the signature length
147         // - case 65: r,s,v signature (standard)
148         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
149         if (signature.length == 65) {
150             bytes32 r;
151             bytes32 s;
152             uint8 v;
153             // ecrecover takes the signature parameters, and the only way to get them
154             // currently is to use assembly.
155             assembly {
156                 r := mload(add(signature, 0x20))
157                 s := mload(add(signature, 0x40))
158                 v := byte(0, mload(add(signature, 0x60)))
159             }
160             return tryRecover(hash, v, r, s);
161         } else if (signature.length == 64) {
162             bytes32 r;
163             bytes32 vs;
164             // ecrecover takes the signature parameters, and the only way to get them
165             // currently is to use assembly.
166             assembly {
167                 r := mload(add(signature, 0x20))
168                 vs := mload(add(signature, 0x40))
169             }
170             return tryRecover(hash, r, vs);
171         } else {
172             return (address(0), RecoverError.InvalidSignatureLength);
173         }
174     }
175 
176     /**
177      * @dev Returns the address that signed a hashed message (`hash`) with
178      * `signature`. This address can then be used for verification purposes.
179      *
180      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
181      * this function rejects them by requiring the `s` value to be in the lower
182      * half order, and the `v` value to be either 27 or 28.
183      *
184      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
185      * verification to be secure: it is possible to craft signatures that
186      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
187      * this is by receiving a hash of the original message (which may otherwise
188      * be too long), and then calling {toEthSignedMessageHash} on it.
189      */
190     function recover(bytes32 hash, bytes memory signature)
191         internal
192         pure
193         returns (address)
194     {
195         (address recovered, RecoverError error) = tryRecover(hash, signature);
196         _throwError(error);
197         return recovered;
198     }
199 
200     /**
201      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
202      *
203      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
204      *
205      * _Available since v4.3._
206      */
207     function tryRecover(
208         bytes32 hash,
209         bytes32 r,
210         bytes32 vs
211     ) internal pure returns (address, RecoverError) {
212         bytes32 s = vs &
213             bytes32(
214                 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
215             );
216         uint8 v = uint8((uint256(vs) >> 255) + 27);
217         return tryRecover(hash, v, r, s);
218     }
219 
220     /**
221      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
222      *
223      * _Available since v4.2._
224      */
225     function recover(
226         bytes32 hash,
227         bytes32 r,
228         bytes32 vs
229     ) internal pure returns (address) {
230         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
231         _throwError(error);
232         return recovered;
233     }
234 
235     /**
236      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
237      * `r` and `s` signature fields separately.
238      *
239      * _Available since v4.3._
240      */
241     function tryRecover(
242         bytes32 hash,
243         uint8 v,
244         bytes32 r,
245         bytes32 s
246     ) internal pure returns (address, RecoverError) {
247         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
248         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
249         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
250         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
251         //
252         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
253         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
254         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
255         // these malleable signatures as well.
256         if (
257             uint256(s) >
258             0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0
259         ) {
260             return (address(0), RecoverError.InvalidSignatureS);
261         }
262         if (v != 27 && v != 28) {
263             return (address(0), RecoverError.InvalidSignatureV);
264         }
265 
266         // If the signature is valid (and not malleable), return the signer address
267         address signer = ecrecover(hash, v, r, s);
268         if (signer == address(0)) {
269             return (address(0), RecoverError.InvalidSignature);
270         }
271 
272         return (signer, RecoverError.NoError);
273     }
274 
275     /**
276      * @dev Overload of {ECDSA-recover} that receives the `v`,
277      * `r` and `s` signature fields separately.
278      */
279     function recover(
280         bytes32 hash,
281         uint8 v,
282         bytes32 r,
283         bytes32 s
284     ) internal pure returns (address) {
285         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
286         _throwError(error);
287         return recovered;
288     }
289 
290     /**
291      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
292      * produces hash corresponding to the one signed with the
293      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
294      * JSON-RPC method as part of EIP-191.
295      *
296      * See {recover}.
297      */
298     function toEthSignedMessageHash(bytes32 hash)
299         internal
300         pure
301         returns (bytes32)
302     {
303         // 32 is the length in bytes of hash,
304         // enforced by the type signature above
305         return
306             keccak256(
307                 abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)
308             );
309     }
310 
311     /**
312      * @dev Returns an Ethereum Signed Message, created from `s`. This
313      * produces hash corresponding to the one signed with the
314      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
315      * JSON-RPC method as part of EIP-191.
316      *
317      * See {recover}.
318      */
319     function toEthSignedMessageHash(bytes memory s)
320         internal
321         pure
322         returns (bytes32)
323     {
324         return
325             keccak256(
326                 abi.encodePacked(
327                     "\x19Ethereum Signed Message:\n",
328                     Strings.toString(s.length),
329                     s
330                 )
331             );
332     }
333 
334     /**
335      * @dev Returns an Ethereum Signed Typed Data, created from a
336      * `domainSeparator` and a `structHash`. This produces hash corresponding
337      * to the one signed with the
338      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
339      * JSON-RPC method as part of EIP-712.
340      *
341      * See {recover}.
342      */
343     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash)
344         internal
345         pure
346         returns (bytes32)
347     {
348         return
349             keccak256(
350                 abi.encodePacked("\x19\x01", domainSeparator, structHash)
351             );
352     }
353 }
354 
355 // File: @openzeppelin/contracts/utils/Context.sol
356 
357 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
358 
359 pragma solidity ^0.8.0;
360 
361 /**
362  * @dev Provides information about the current execution context, including the
363  * sender of the transaction and its data. While these are generally available
364  * via msg.sender and msg.data, they should not be accessed in such a direct
365  * manner, since when dealing with meta-transactions the account sending and
366  * paying for execution may not be the actual sender (as far as an application
367  * is concerned).
368  *
369  * This contract is only required for intermediate, library-like contracts.
370  */
371 abstract contract Context {
372     function _msgSender() internal view virtual returns (address) {
373         return msg.sender;
374     }
375 
376     function _msgData() internal view virtual returns (bytes calldata) {
377         return msg.data;
378     }
379 }
380 
381 // File: @openzeppelin/contracts/access/Ownable.sol
382 
383 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
384 
385 pragma solidity ^0.8.0;
386 
387 /**
388  * @dev Contract module which provides a basic access control mechanism, where
389  * there is an account (an owner) that can be granted exclusive access to
390  * specific functions.
391  *
392  * By default, the owner account will be the one that deploys the contract. This
393  * can later be changed with {transferOwnership}.
394  *
395  * This module is used through inheritance. It will make available the modifier
396  * `onlyOwner`, which can be applied to your functions to restrict their use to
397  * the owner.
398  */
399 abstract contract Ownable is Context {
400     address private _owner;
401 
402     event OwnershipTransferred(
403         address indexed previousOwner,
404         address indexed newOwner
405     );
406 
407     /**
408      * @dev Initializes the contract setting the deployer as the initial owner.
409      */
410     constructor() {
411         _transferOwnership(_msgSender());
412     }
413 
414     /**
415      * @dev Returns the address of the current owner.
416      */
417     function owner() public view virtual returns (address) {
418         return _owner;
419     }
420 
421     /**
422      * @dev Throws if called by any account other than the owner.
423      */
424     modifier onlyOwner() {
425         require(owner() == _msgSender(), "Ownable: caller is not the owner");
426         _;
427     }
428 
429     /**
430      * @dev Leaves the contract without owner. It will not be possible to call
431      * `onlyOwner` functions anymore. Can only be called by the current owner.
432      *
433      * NOTE: Renouncing ownership will leave the contract without an owner,
434      * thereby removing any functionality that is only available to the owner.
435      */
436     function renounceOwnership() public virtual onlyOwner {
437         _transferOwnership(address(0));
438     }
439 
440     /**
441      * @dev Transfers ownership of the contract to a new account (`newOwner`).
442      * Can only be called by the current owner.
443      */
444     function transferOwnership(address newOwner) public virtual onlyOwner {
445         require(
446             newOwner != address(0),
447             "Ownable: new owner is the zero address"
448         );
449         _transferOwnership(newOwner);
450     }
451 
452     /**
453      * @dev Transfers ownership of the contract to a new account (`newOwner`).
454      * Internal function without access restriction.
455      */
456     function _transferOwnership(address newOwner) internal virtual {
457         address oldOwner = _owner;
458         _owner = newOwner;
459         emit OwnershipTransferred(oldOwner, newOwner);
460     }
461 }
462 
463 // File: @openzeppelin/contracts/utils/Address.sol
464 
465 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
466 
467 pragma solidity ^0.8.1;
468 
469 /**
470  * @dev Collection of functions related to the address type
471  */
472 library Address {
473     /**
474      * @dev Returns true if `account` is a contract.
475      *
476      * [IMPORTANT]
477      * ====
478      * It is unsafe to assume that an address for which this function returns
479      * false is an externally-owned account (EOA) and not a contract.
480      *
481      * Among others, `isContract` will return false for the following
482      * types of addresses:
483      *
484      *  - an externally-owned account
485      *  - a contract in construction
486      *  - an address where a contract will be created
487      *  - an address where a contract lived, but was destroyed
488      * ====
489      *
490      * [IMPORTANT]
491      * ====
492      * You shouldn't rely on `isContract` to protect against flash loan attacks!
493      *
494      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
495      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
496      * constructor.
497      * ====
498      */
499     function isContract(address account) internal view returns (bool) {
500         // This method relies on extcodesize/address.code.length, which returns 0
501         // for contracts in construction, since the code is only stored at the end
502         // of the constructor execution.
503 
504         return account.code.length > 0;
505     }
506 
507     /**
508      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
509      * `recipient`, forwarding all available gas and reverting on errors.
510      *
511      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
512      * of certain opcodes, possibly making contracts go over the 2300 gas limit
513      * imposed by `transfer`, making them unable to receive funds via
514      * `transfer`. {sendValue} removes this limitation.
515      *
516      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
517      *
518      * IMPORTANT: because control is transferred to `recipient`, care must be
519      * taken to not create reentrancy vulnerabilities. Consider using
520      * {ReentrancyGuard} or the
521      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
522      */
523     function sendValue(address payable recipient, uint256 amount) internal {
524         require(
525             address(this).balance >= amount,
526             "Address: insufficient balance"
527         );
528 
529         (bool success, ) = recipient.call{value: amount}("");
530         require(
531             success,
532             "Address: unable to send value, recipient may have reverted"
533         );
534     }
535 
536     /**
537      * @dev Performs a Solidity function call using a low level `call`. A
538      * plain `call` is an unsafe replacement for a function call: use this
539      * function instead.
540      *
541      * If `target` reverts with a revert reason, it is bubbled up by this
542      * function (like regular Solidity function calls).
543      *
544      * Returns the raw returned data. To convert to the expected return value,
545      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
546      *
547      * Requirements:
548      *
549      * - `target` must be a contract.
550      * - calling `target` with `data` must not revert.
551      *
552      * _Available since v3.1._
553      */
554     function functionCall(address target, bytes memory data)
555         internal
556         returns (bytes memory)
557     {
558         return functionCall(target, data, "Address: low-level call failed");
559     }
560 
561     /**
562      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
563      * `errorMessage` as a fallback revert reason when `target` reverts.
564      *
565      * _Available since v3.1._
566      */
567     function functionCall(
568         address target,
569         bytes memory data,
570         string memory errorMessage
571     ) internal returns (bytes memory) {
572         return functionCallWithValue(target, data, 0, errorMessage);
573     }
574 
575     /**
576      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
577      * but also transferring `value` wei to `target`.
578      *
579      * Requirements:
580      *
581      * - the calling contract must have an ETH balance of at least `value`.
582      * - the called Solidity function must be `payable`.
583      *
584      * _Available since v3.1._
585      */
586     function functionCallWithValue(
587         address target,
588         bytes memory data,
589         uint256 value
590     ) internal returns (bytes memory) {
591         return
592             functionCallWithValue(
593                 target,
594                 data,
595                 value,
596                 "Address: low-level call with value failed"
597             );
598     }
599 
600     /**
601      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
602      * with `errorMessage` as a fallback revert reason when `target` reverts.
603      *
604      * _Available since v3.1._
605      */
606     function functionCallWithValue(
607         address target,
608         bytes memory data,
609         uint256 value,
610         string memory errorMessage
611     ) internal returns (bytes memory) {
612         require(
613             address(this).balance >= value,
614             "Address: insufficient balance for call"
615         );
616         require(isContract(target), "Address: call to non-contract");
617 
618         (bool success, bytes memory returndata) = target.call{value: value}(
619             data
620         );
621         return verifyCallResult(success, returndata, errorMessage);
622     }
623 
624     /**
625      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
626      * but performing a static call.
627      *
628      * _Available since v3.3._
629      */
630     function functionStaticCall(address target, bytes memory data)
631         internal
632         view
633         returns (bytes memory)
634     {
635         return
636             functionStaticCall(
637                 target,
638                 data,
639                 "Address: low-level static call failed"
640             );
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
666     function functionDelegateCall(address target, bytes memory data)
667         internal
668         returns (bytes memory)
669     {
670         return
671             functionDelegateCall(
672                 target,
673                 data,
674                 "Address: low-level delegate call failed"
675             );
676     }
677 
678     /**
679      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
680      * but performing a delegate call.
681      *
682      * _Available since v3.4._
683      */
684     function functionDelegateCall(
685         address target,
686         bytes memory data,
687         string memory errorMessage
688     ) internal returns (bytes memory) {
689         require(isContract(target), "Address: delegate call to non-contract");
690 
691         (bool success, bytes memory returndata) = target.delegatecall(data);
692         return verifyCallResult(success, returndata, errorMessage);
693     }
694 
695     /**
696      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
697      * revert reason using the provided one.
698      *
699      * _Available since v4.3._
700      */
701     function verifyCallResult(
702         bool success,
703         bytes memory returndata,
704         string memory errorMessage
705     ) internal pure returns (bytes memory) {
706         if (success) {
707             return returndata;
708         } else {
709             // Look for revert reason and bubble it up if present
710             if (returndata.length > 0) {
711                 // The easiest way to bubble the revert reason is using memory via assembly
712 
713                 assembly {
714                     let returndata_size := mload(returndata)
715                     revert(add(32, returndata), returndata_size)
716                 }
717             } else {
718                 revert(errorMessage);
719             }
720         }
721     }
722 }
723 
724 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
725 
726 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
727 
728 pragma solidity ^0.8.0;
729 
730 /**
731  * @title ERC721 token receiver interface
732  * @dev Interface for any contract that wants to support safeTransfers
733  * from ERC721 asset contracts.
734  */
735 interface IERC721Receiver {
736     /**
737      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
738      * by `operator` from `from`, this function is called.
739      *
740      * It must return its Solidity selector to confirm the token transfer.
741      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
742      *
743      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
744      */
745     function onERC721Received(
746         address operator,
747         address from,
748         uint256 tokenId,
749         bytes calldata data
750     ) external returns (bytes4);
751 }
752 
753 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
754 
755 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
756 
757 pragma solidity ^0.8.0;
758 
759 /**
760  * @dev Interface of the ERC165 standard, as defined in the
761  * https://eips.ethereum.org/EIPS/eip-165[EIP].
762  *
763  * Implementers can declare support of contract interfaces, which can then be
764  * queried by others ({ERC165Checker}).
765  *
766  * For an implementation, see {ERC165}.
767  */
768 interface IERC165 {
769     /**
770      * @dev Returns true if this contract implements the interface defined by
771      * `interfaceId`. See the corresponding
772      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
773      * to learn more about how these ids are created.
774      *
775      * This function call must use less than 30 000 gas.
776      */
777     function supportsInterface(bytes4 interfaceId) external view returns (bool);
778 }
779 
780 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
781 
782 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
783 
784 pragma solidity ^0.8.0;
785 
786 /**
787  * @dev Implementation of the {IERC165} interface.
788  *
789  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
790  * for the additional interface id that will be supported. For example:
791  *
792  * ```solidity
793  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
794  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
795  * }
796  * ```
797  *
798  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
799  */
800 abstract contract ERC165 is IERC165 {
801     /**
802      * @dev See {IERC165-supportsInterface}.
803      */
804     function supportsInterface(bytes4 interfaceId)
805         public
806         view
807         virtual
808         override
809         returns (bool)
810     {
811         return interfaceId == type(IERC165).interfaceId;
812     }
813 }
814 
815 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
816 
817 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
818 
819 pragma solidity ^0.8.0;
820 
821 /**
822  * @dev Required interface of an ERC721 compliant contract.
823  */
824 interface IERC721 is IERC165 {
825     /**
826      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
827      */
828     event Transfer(
829         address indexed from,
830         address indexed to,
831         uint256 indexed tokenId
832     );
833 
834     /**
835      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
836      */
837     event Approval(
838         address indexed owner,
839         address indexed approved,
840         uint256 indexed tokenId
841     );
842 
843     /**
844      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
845      */
846     event ApprovalForAll(
847         address indexed owner,
848         address indexed operator,
849         bool approved
850     );
851 
852     /**
853      * @dev Returns the number of tokens in ``owner``'s account.
854      */
855     function balanceOf(address owner) external view returns (uint256 balance);
856 
857     /**
858      * @dev Returns the owner of the `tokenId` token.
859      *
860      * Requirements:
861      *
862      * - `tokenId` must exist.
863      */
864     function ownerOf(uint256 tokenId) external view returns (address owner);
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
875      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
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
922      * @dev Returns the account approved for `tokenId` token.
923      *
924      * Requirements:
925      *
926      * - `tokenId` must exist.
927      */
928     function getApproved(uint256 tokenId)
929         external
930         view
931         returns (address operator);
932 
933     /**
934      * @dev Approve or remove `operator` as an operator for the caller.
935      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
936      *
937      * Requirements:
938      *
939      * - The `operator` cannot be the caller.
940      *
941      * Emits an {ApprovalForAll} event.
942      */
943     function setApprovalForAll(address operator, bool _approved) external;
944 
945     /**
946      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
947      *
948      * See {setApprovalForAll}
949      */
950     function isApprovedForAll(address owner, address operator)
951         external
952         view
953         returns (bool);
954 
955     /**
956      * @dev Safely transfers `tokenId` token from `from` to `to`.
957      *
958      * Requirements:
959      *
960      * - `from` cannot be the zero address.
961      * - `to` cannot be the zero address.
962      * - `tokenId` token must exist and be owned by `from`.
963      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
964      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
965      *
966      * Emits a {Transfer} event.
967      */
968     function safeTransferFrom(
969         address from,
970         address to,
971         uint256 tokenId,
972         bytes calldata data
973     ) external;
974 }
975 
976 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
977 
978 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
979 
980 pragma solidity ^0.8.0;
981 
982 /**
983  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
984  * @dev See https://eips.ethereum.org/EIPS/eip-721
985  */
986 interface IERC721Metadata is IERC721 {
987     /**
988      * @dev Returns the token collection name.
989      */
990     function name() external view returns (string memory);
991 
992     /**
993      * @dev Returns the token collection symbol.
994      */
995     function symbol() external view returns (string memory);
996 
997     /**
998      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
999      */
1000     function tokenURI(uint256 tokenId) external view returns (string memory);
1001 }
1002 
1003 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1004 
1005 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
1006 
1007 pragma solidity ^0.8.0;
1008 
1009 /**
1010  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1011  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1012  * {ERC721Enumerable}.
1013  */
1014 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1015     using Address for address;
1016     using Strings for uint256;
1017 
1018     // Token name
1019     string private _name;
1020 
1021     // Token symbol
1022     string private _symbol;
1023 
1024     // Mapping from token ID to owner address
1025     mapping(uint256 => address) private _owners;
1026 
1027     // Mapping owner address to token count
1028     mapping(address => uint256) private _balances;
1029 
1030     // Mapping from token ID to approved address
1031     mapping(uint256 => address) private _tokenApprovals;
1032 
1033     // Mapping from owner to operator approvals
1034     mapping(address => mapping(address => bool)) private _operatorApprovals;
1035 
1036     /**
1037      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1038      */
1039     constructor(string memory name_, string memory symbol_) {
1040         _name = name_;
1041         _symbol = symbol_;
1042     }
1043 
1044     /**
1045      * @dev See {IERC165-supportsInterface}.
1046      */
1047     function supportsInterface(bytes4 interfaceId)
1048         public
1049         view
1050         virtual
1051         override(ERC165, IERC165)
1052         returns (bool)
1053     {
1054         return
1055             interfaceId == type(IERC721).interfaceId ||
1056             interfaceId == type(IERC721Metadata).interfaceId ||
1057             super.supportsInterface(interfaceId);
1058     }
1059 
1060     /**
1061      * @dev See {IERC721-balanceOf}.
1062      */
1063     function balanceOf(address owner)
1064         public
1065         view
1066         virtual
1067         override
1068         returns (uint256)
1069     {
1070         require(
1071             owner != address(0),
1072             "ERC721: balance query for the zero address"
1073         );
1074         return _balances[owner];
1075     }
1076 
1077     /**
1078      * @dev See {IERC721-ownerOf}.
1079      */
1080     function ownerOf(uint256 tokenId)
1081         public
1082         view
1083         virtual
1084         override
1085         returns (address)
1086     {
1087         address owner = _owners[tokenId];
1088         require(
1089             owner != address(0),
1090             "ERC721: owner query for nonexistent token"
1091         );
1092         return owner;
1093     }
1094 
1095     /**
1096      * @dev See {IERC721Metadata-name}.
1097      */
1098     function name() public view virtual override returns (string memory) {
1099         return _name;
1100     }
1101 
1102     /**
1103      * @dev See {IERC721Metadata-symbol}.
1104      */
1105     function symbol() public view virtual override returns (string memory) {
1106         return _symbol;
1107     }
1108 
1109     /**
1110      * @dev See {IERC721Metadata-tokenURI}.
1111      */
1112     function tokenURI(uint256 tokenId)
1113         public
1114         view
1115         virtual
1116         override
1117         returns (string memory)
1118     {
1119         require(
1120             _exists(tokenId),
1121             "ERC721Metadata: URI query for nonexistent token"
1122         );
1123 
1124         string memory baseURI = _baseURI();
1125         return
1126             bytes(baseURI).length > 0
1127                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
1128                 : "";
1129     }
1130 
1131     /**
1132      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1133      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1134      * by default, can be overriden in child contracts.
1135      */
1136     function _baseURI() internal view virtual returns (string memory) {
1137         return "";
1138     }
1139 
1140     /**
1141      * @dev See {IERC721-approve}.
1142      */
1143     function approve(address to, uint256 tokenId) public virtual override {
1144         address owner = ERC721.ownerOf(tokenId);
1145         require(to != owner, "ERC721: approval to current owner");
1146 
1147         require(
1148             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1149             "ERC721: approve caller is not owner nor approved for all"
1150         );
1151 
1152         _approve(to, tokenId);
1153     }
1154 
1155     /**
1156      * @dev See {IERC721-getApproved}.
1157      */
1158     function getApproved(uint256 tokenId)
1159         public
1160         view
1161         virtual
1162         override
1163         returns (address)
1164     {
1165         require(
1166             _exists(tokenId),
1167             "ERC721: approved query for nonexistent token"
1168         );
1169 
1170         return _tokenApprovals[tokenId];
1171     }
1172 
1173     /**
1174      * @dev See {IERC721-setApprovalForAll}.
1175      */
1176     function setApprovalForAll(address operator, bool approved)
1177         public
1178         virtual
1179         override
1180     {
1181         _setApprovalForAll(_msgSender(), operator, approved);
1182     }
1183 
1184     /**
1185      * @dev See {IERC721-isApprovedForAll}.
1186      */
1187     function isApprovedForAll(address owner, address operator)
1188         public
1189         view
1190         virtual
1191         override
1192         returns (bool)
1193     {
1194         return _operatorApprovals[owner][operator];
1195     }
1196 
1197     /**
1198      * @dev See {IERC721-transferFrom}.
1199      */
1200     function transferFrom(
1201         address from,
1202         address to,
1203         uint256 tokenId
1204     ) public virtual override {
1205         //solhint-disable-next-line max-line-length
1206         require(
1207             _isApprovedOrOwner(_msgSender(), tokenId),
1208             "ERC721: transfer caller is not owner nor approved"
1209         );
1210 
1211         _transfer(from, to, tokenId);
1212     }
1213 
1214     /**
1215      * @dev See {IERC721-safeTransferFrom}.
1216      */
1217     function safeTransferFrom(
1218         address from,
1219         address to,
1220         uint256 tokenId
1221     ) public virtual override {
1222         safeTransferFrom(from, to, tokenId, "");
1223     }
1224 
1225     /**
1226      * @dev See {IERC721-safeTransferFrom}.
1227      */
1228     function safeTransferFrom(
1229         address from,
1230         address to,
1231         uint256 tokenId,
1232         bytes memory _data
1233     ) public virtual override {
1234         require(
1235             _isApprovedOrOwner(_msgSender(), tokenId),
1236             "ERC721: transfer caller is not owner nor approved"
1237         );
1238         _safeTransfer(from, to, tokenId, _data);
1239     }
1240 
1241     /**
1242      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1243      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1244      *
1245      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1246      *
1247      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1248      * implement alternative mechanisms to perform token transfer, such as signature-based.
1249      *
1250      * Requirements:
1251      *
1252      * - `from` cannot be the zero address.
1253      * - `to` cannot be the zero address.
1254      * - `tokenId` token must exist and be owned by `from`.
1255      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1256      *
1257      * Emits a {Transfer} event.
1258      */
1259     function _safeTransfer(
1260         address from,
1261         address to,
1262         uint256 tokenId,
1263         bytes memory _data
1264     ) internal virtual {
1265         _transfer(from, to, tokenId);
1266         require(
1267             _checkOnERC721Received(from, to, tokenId, _data),
1268             "ERC721: transfer to non ERC721Receiver implementer"
1269         );
1270     }
1271 
1272     /**
1273      * @dev Returns whether `tokenId` exists.
1274      *
1275      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1276      *
1277      * Tokens start existing when they are minted (`_mint`),
1278      * and stop existing when they are burned (`_burn`).
1279      */
1280     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1281         return _owners[tokenId] != address(0);
1282     }
1283 
1284     /**
1285      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1286      *
1287      * Requirements:
1288      *
1289      * - `tokenId` must exist.
1290      */
1291     function _isApprovedOrOwner(address spender, uint256 tokenId)
1292         internal
1293         view
1294         virtual
1295         returns (bool)
1296     {
1297         require(
1298             _exists(tokenId),
1299             "ERC721: operator query for nonexistent token"
1300         );
1301         address owner = ERC721.ownerOf(tokenId);
1302         return (spender == owner ||
1303             getApproved(tokenId) == spender ||
1304             isApprovedForAll(owner, spender));
1305     }
1306 
1307     /**
1308      * @dev Safely mints `tokenId` and transfers it to `to`.
1309      *
1310      * Requirements:
1311      *
1312      * - `tokenId` must not exist.
1313      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1314      *
1315      * Emits a {Transfer} event.
1316      */
1317     function _safeMint(address to, uint256 tokenId) internal virtual {
1318         _safeMint(to, tokenId, "");
1319     }
1320 
1321     /**
1322      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1323      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1324      */
1325     function _safeMint(
1326         address to,
1327         uint256 tokenId,
1328         bytes memory _data
1329     ) internal virtual {
1330         _mint(to, tokenId);
1331         require(
1332             _checkOnERC721Received(address(0), to, tokenId, _data),
1333             "ERC721: transfer to non ERC721Receiver implementer"
1334         );
1335     }
1336 
1337     /**
1338      * @dev Mints `tokenId` and transfers it to `to`.
1339      *
1340      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1341      *
1342      * Requirements:
1343      *
1344      * - `tokenId` must not exist.
1345      * - `to` cannot be the zero address.
1346      *
1347      * Emits a {Transfer} event.
1348      */
1349     function _mint(address to, uint256 tokenId) internal virtual {
1350         require(to != address(0), "ERC721: mint to the zero address");
1351         require(!_exists(tokenId), "ERC721: token already minted");
1352 
1353         _beforeTokenTransfer(address(0), to, tokenId);
1354 
1355         _balances[to] += 1;
1356         _owners[tokenId] = to;
1357 
1358         emit Transfer(address(0), to, tokenId);
1359 
1360         _afterTokenTransfer(address(0), to, tokenId);
1361     }
1362 
1363     /**
1364      * @dev Destroys `tokenId`.
1365      * The approval is cleared when the token is burned.
1366      *
1367      * Requirements:
1368      *
1369      * - `tokenId` must exist.
1370      *
1371      * Emits a {Transfer} event.
1372      */
1373     function _burn(uint256 tokenId) internal virtual {
1374         address owner = ERC721.ownerOf(tokenId);
1375 
1376         _beforeTokenTransfer(owner, address(0), tokenId);
1377 
1378         // Clear approvals
1379         _approve(address(0), tokenId);
1380 
1381         _balances[owner] -= 1;
1382         delete _owners[tokenId];
1383 
1384         emit Transfer(owner, address(0), tokenId);
1385 
1386         _afterTokenTransfer(owner, address(0), tokenId);
1387     }
1388 
1389     /**
1390      * @dev Transfers `tokenId` from `from` to `to`.
1391      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1392      *
1393      * Requirements:
1394      *
1395      * - `to` cannot be the zero address.
1396      * - `tokenId` token must be owned by `from`.
1397      *
1398      * Emits a {Transfer} event.
1399      */
1400     function _transfer(
1401         address from,
1402         address to,
1403         uint256 tokenId
1404     ) internal virtual {
1405         require(
1406             ERC721.ownerOf(tokenId) == from,
1407             "ERC721: transfer from incorrect owner"
1408         );
1409         require(to != address(0), "ERC721: transfer to the zero address");
1410 
1411         _beforeTokenTransfer(from, to, tokenId);
1412 
1413         // Clear approvals from the previous owner
1414         _approve(address(0), tokenId);
1415 
1416         _balances[from] -= 1;
1417         _balances[to] += 1;
1418         _owners[tokenId] = to;
1419 
1420         emit Transfer(from, to, tokenId);
1421 
1422         _afterTokenTransfer(from, to, tokenId);
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
1467             try
1468                 IERC721Receiver(to).onERC721Received(
1469                     _msgSender(),
1470                     from,
1471                     tokenId,
1472                     _data
1473                 )
1474             returns (bytes4 retval) {
1475                 return retval == IERC721Receiver.onERC721Received.selector;
1476             } catch (bytes memory reason) {
1477                 if (reason.length == 0) {
1478                     revert(
1479                         "ERC721: transfer to non ERC721Receiver implementer"
1480                     );
1481                 } else {
1482                     assembly {
1483                         revert(add(32, reason), mload(reason))
1484                     }
1485                 }
1486             }
1487         } else {
1488             return true;
1489         }
1490     }
1491 
1492     /**
1493      * @dev Hook that is called before any token transfer. This includes minting
1494      * and burning.
1495      *
1496      * Calling conditions:
1497      *
1498      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1499      * transferred to `to`.
1500      * - When `from` is zero, `tokenId` will be minted for `to`.
1501      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1502      * - `from` and `to` are never both zero.
1503      *
1504      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1505      */
1506     function _beforeTokenTransfer(
1507         address from,
1508         address to,
1509         uint256 tokenId
1510     ) internal virtual {}
1511 
1512     /**
1513      * @dev Hook that is called after any transfer of tokens. This includes
1514      * minting and burning.
1515      *
1516      * Calling conditions:
1517      *
1518      * - when `from` and `to` are both non-zero.
1519      * - `from` and `to` are never both zero.
1520      *
1521      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1522      */
1523     function _afterTokenTransfer(
1524         address from,
1525         address to,
1526         uint256 tokenId
1527     ) internal virtual {}
1528 }
1529 
1530 // File: contract.sol
1531 
1532 pragma solidity ^0.8.4;
1533 
1534 interface IStaking {
1535     function mint(address _to, uint256 _amount) external;
1536 }
1537 
1538 contract EarlyBirds is ERC721, Ownable {
1539     string public _tokenBaseURI = "https://gateway.pinata.cloud/ipfs/QmRYr3DRPeoJAxELGSZWnZ2haKZZDqFKgXrLkxV4ry4QLD/";
1540     uint256 public EBG_MAX = 1400;
1541     uint256 public _tokensMinted;
1542     uint256 public _price = 0.1 ether;
1543     bool public OG_live;
1544     bool public PR_live;
1545     address private _signer = 0xA3fF44F69d770A203fF148D0069C0D9CFb85bd65;
1546     string private constant _sigWord = "EARLY_BIRDS_SC";
1547     mapping(address => bool) public OG_MINT_LIST;
1548     mapping(address => bool) public PR_MINT_LIST;
1549 
1550     bool public stakingLive;
1551     IStaking public StakingContract;
1552     uint256 public earningRate = 0.00005787037 ether;
1553     mapping(uint256 => uint256) public tokensLastClaimTime;
1554 
1555     using Strings for uint256;
1556     using ECDSA for bytes32;
1557 
1558     constructor() ERC721("Early Birds", "EBG") {
1559         for (uint256 index = 1401; index <= 1420; index++) {
1560             tokensLastClaimTime[index] = block.timestamp;
1561             _safeMint(msg.sender, index);
1562         }
1563     }
1564 
1565     modifier notContract() {
1566         require((!_isContract(msg.sender)) && (msg.sender == tx.origin), "contract not allowed");
1567         _;
1568     }
1569 
1570     function _isContract(address addr) internal view returns (bool) {
1571         uint256 size;
1572         assembly {
1573             size := extcodesize(addr)
1574         }
1575         return size > 0;
1576     }
1577 
1578     function matchAddresSigner(bytes memory signature, string memory whitelistingType) private view returns (bool) {
1579         bytes32 hash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", keccak256(abi.encodePacked(msg.sender, _sigWord, whitelistingType))));
1580         return _signer == hash.recover(signature);
1581     }
1582 
1583     function OG_Mint(bytes memory signature) external payable notContract {
1584         require(OG_live, "MINT_CLOSED");
1585         require(matchAddresSigner(signature, "OG"), "DIRECT_MINT_DISALLOWED");
1586         require(!OG_MINT_LIST[msg.sender], "EXCEED_ALLOWED");
1587         require(_tokensMinted + 1 <= EBG_MAX, "EXCEED_MAX");
1588         require(_price <= msg.value, "INSUFFICIENT_ETH");
1589 
1590         tokensLastClaimTime[_tokensMinted] = block.timestamp;
1591         OG_MINT_LIST[msg.sender] = true;
1592         _tokensMinted++;
1593         _safeMint(msg.sender, _tokensMinted);
1594     }
1595 
1596     function PR_Mint(bytes memory signature) external payable notContract {
1597         require(PR_live, "MINT_CLOSED");
1598         require(matchAddresSigner(signature, "PR"), "DIRECT_MINT_DISALLOWED");
1599         require(!PR_MINT_LIST[msg.sender], "EXCEED_ALLOWED");
1600         require(_tokensMinted + 1 <= EBG_MAX, "EXCEED_MAX");
1601         require(_price <= msg.value, "INSUFFICIENT_ETH");
1602 
1603         tokensLastClaimTime[_tokensMinted] = block.timestamp;
1604         PR_MINT_LIST[msg.sender] = true;
1605         _tokensMinted++;
1606         _safeMint(msg.sender, _tokensMinted);
1607     }
1608 
1609     function toggleOGMint() external onlyOwner {
1610         OG_live = !OG_live;
1611     }
1612 
1613     function togglePR() external onlyOwner {
1614         PR_live = !PR_live;
1615     }
1616 
1617     function toggleStaking() external onlyOwner {
1618         stakingLive = !stakingLive;
1619     }
1620 
1621     function setBaseURI(string calldata baseURI) external onlyOwner {
1622         _tokenBaseURI = baseURI;
1623     }
1624 
1625     function setSigner(address newAddress) external onlyOwner {
1626         _signer = newAddress;
1627     }
1628 
1629     function totalSupply() public view returns (uint256) {
1630         return _tokensMinted + 20;
1631     }
1632 
1633     function withdraw() external onlyOwner {
1634         uint256 currentBalance = address(this).balance;
1635         payable(0x57977C4D220984edE1190396EEBE3B6bc7045Ef5).transfer((currentBalance * 20) / 100);
1636         payable(0x83fdd985926c8AbE6958005AedEE2247528fFAEd).transfer((currentBalance * 20) / 100);
1637         payable(0x11111F01570EeAA3e5a2Fd51f4A2f127661B9834).transfer((currentBalance * 12) / 100);
1638         payable(0xE8cC8049d434b6d10e89cd084584D65Ba1a2ac08).transfer(address(this).balance);
1639     }
1640 
1641     function tokenURI(uint256 tokenId) public view override(ERC721) returns (string memory) {
1642         require(_exists(tokenId), "Cannot query non-existent token");
1643         return string(abi.encodePacked(_tokenBaseURI, tokenId.toString()));
1644     }
1645 
1646     function tokensOwnedBy(address owner) public view returns (uint256[] memory) {
1647         uint256[] memory tokensList = new uint256[](this.balanceOf(owner));
1648         uint256 currentIndex;
1649         for (uint256 index = 1; index <= _tokensMinted; index++) {
1650             if (this.ownerOf(index) == owner) {
1651                 tokensList[currentIndex++] = uint256(index);
1652             }
1653         }
1654         return tokensList;
1655     }
1656 
1657     // STAKING
1658     function claimRewardsByIds(uint256[] calldata tokenIds) external notContract {
1659         require(stakingLive, "STAKING_CLOSED");
1660         uint256 totalRewards;
1661 
1662         for (uint256 index = 0; index < tokenIds.length; index++) {
1663             if (this.ownerOf(tokenIds[index]) == msg.sender) {
1664                 totalRewards = totalRewards + earningRate * (block.timestamp - (tokensLastClaimTime[tokenIds[index]]));
1665                 tokensLastClaimTime[tokenIds[index]] = block.timestamp;
1666             }
1667         }
1668         StakingContract.mint(msg.sender, totalRewards);
1669     }
1670 
1671     function currentRewardsForIds(uint256[] calldata tokenIds) external view returns (uint256) {
1672         uint256 totalRewards = 0;
1673         for (uint256 index = 0; index < tokenIds.length; index++) {
1674             if (block.timestamp - tokensLastClaimTime[tokenIds[index]] > 0) {
1675                 totalRewards = totalRewards + (earningRate * (block.timestamp - (tokensLastClaimTime[tokenIds[index]])));
1676             }
1677         }
1678         return totalRewards;
1679     }
1680 
1681     function setEarningRate(uint256 rate) external onlyOwner {
1682         earningRate = rate;
1683     }
1684 
1685     function setStakingContract(address contractAddress) external onlyOwner {
1686         StakingContract = IStaking(contractAddress);
1687     }
1688 
1689     receive() external payable {}
1690 }