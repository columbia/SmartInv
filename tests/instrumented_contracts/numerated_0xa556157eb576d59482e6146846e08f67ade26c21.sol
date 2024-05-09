1 // SPDX-License-Identifier: MIT
2 /*
3  __          __     _____ _  _______ ______  _____ 
4  \ \        / /\   / ____| |/ /_   _|  ____|/ ____|
5   \ \  /\  / /  \ | |    | ' /  | | | |__  | (___  
6    \ \/  \/ / /\ \| |    |  <   | | |  __|  \___ \ 
7     \  /\  / ____ \ |____| . \ _| |_| |____ ____) |
8      \/  \/_/    \_\_____|_|\_\_____|______|_____/ 
9                                                    
10                 by Devko.dev#7286
11 */
12 // File: @openzeppelin/contracts/utils/Strings.sol
13 
14 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
15 
16 pragma solidity ^0.8.0;
17 
18 /**
19  * @dev String operations.
20  */
21 library Strings {
22     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
23 
24     /**
25      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
26      */
27     function toString(uint256 value) internal pure returns (string memory) {
28         // Inspired by OraclizeAPI's implementation - MIT licence
29         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
30 
31         if (value == 0) {
32             return "0";
33         }
34         uint256 temp = value;
35         uint256 digits;
36         while (temp != 0) {
37             digits++;
38             temp /= 10;
39         }
40         bytes memory buffer = new bytes(digits);
41         while (value != 0) {
42             digits -= 1;
43             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
44             value /= 10;
45         }
46         return string(buffer);
47     }
48 
49     /**
50      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
51      */
52     function toHexString(uint256 value) internal pure returns (string memory) {
53         if (value == 0) {
54             return "0x00";
55         }
56         uint256 temp = value;
57         uint256 length = 0;
58         while (temp != 0) {
59             length++;
60             temp >>= 8;
61         }
62         return toHexString(value, length);
63     }
64 
65     /**
66      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
67      */
68     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
69         bytes memory buffer = new bytes(2 * length + 2);
70         buffer[0] = "0";
71         buffer[1] = "x";
72         for (uint256 i = 2 * length + 1; i > 1; --i) {
73             buffer[i] = _HEX_SYMBOLS[value & 0xf];
74             value >>= 4;
75         }
76         require(value == 0, "Strings: hex length insufficient");
77         return string(buffer);
78     }
79 }
80 
81 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
82 
83 
84 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/ECDSA.sol)
85 
86 pragma solidity ^0.8.0;
87 
88 
89 /**
90  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
91  *
92  * These functions can be used to verify that a message was signed by the holder
93  * of the private keys of a given address.
94  */
95 library ECDSA {
96     enum RecoverError {
97         NoError,
98         InvalidSignature,
99         InvalidSignatureLength,
100         InvalidSignatureS,
101         InvalidSignatureV
102     }
103 
104     function _throwError(RecoverError error) private pure {
105         if (error == RecoverError.NoError) {
106             return; // no error: do nothing
107         } else if (error == RecoverError.InvalidSignature) {
108             revert("ECDSA: invalid signature");
109         } else if (error == RecoverError.InvalidSignatureLength) {
110             revert("ECDSA: invalid signature length");
111         } else if (error == RecoverError.InvalidSignatureS) {
112             revert("ECDSA: invalid signature 's' value");
113         } else if (error == RecoverError.InvalidSignatureV) {
114             revert("ECDSA: invalid signature 'v' value");
115         }
116     }
117 
118     /**
119      * @dev Returns the address that signed a hashed message (`hash`) with
120      * `signature` or error string. This address can then be used for verification purposes.
121      *
122      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
123      * this function rejects them by requiring the `s` value to be in the lower
124      * half order, and the `v` value to be either 27 or 28.
125      *
126      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
127      * verification to be secure: it is possible to craft signatures that
128      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
129      * this is by receiving a hash of the original message (which may otherwise
130      * be too long), and then calling {toEthSignedMessageHash} on it.
131      *
132      * Documentation for signature generation:
133      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
134      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
135      *
136      * _Available since v4.3._
137      */
138     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
139         // Check the signature length
140         // - case 65: r,s,v signature (standard)
141         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
142         if (signature.length == 65) {
143             bytes32 r;
144             bytes32 s;
145             uint8 v;
146             // ecrecover takes the signature parameters, and the only way to get them
147             // currently is to use assembly.
148             assembly {
149                 r := mload(add(signature, 0x20))
150                 s := mload(add(signature, 0x40))
151                 v := byte(0, mload(add(signature, 0x60)))
152             }
153             return tryRecover(hash, v, r, s);
154         } else if (signature.length == 64) {
155             bytes32 r;
156             bytes32 vs;
157             // ecrecover takes the signature parameters, and the only way to get them
158             // currently is to use assembly.
159             assembly {
160                 r := mload(add(signature, 0x20))
161                 vs := mload(add(signature, 0x40))
162             }
163             return tryRecover(hash, r, vs);
164         } else {
165             return (address(0), RecoverError.InvalidSignatureLength);
166         }
167     }
168 
169     /**
170      * @dev Returns the address that signed a hashed message (`hash`) with
171      * `signature`. This address can then be used for verification purposes.
172      *
173      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
174      * this function rejects them by requiring the `s` value to be in the lower
175      * half order, and the `v` value to be either 27 or 28.
176      *
177      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
178      * verification to be secure: it is possible to craft signatures that
179      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
180      * this is by receiving a hash of the original message (which may otherwise
181      * be too long), and then calling {toEthSignedMessageHash} on it.
182      */
183     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
184         (address recovered, RecoverError error) = tryRecover(hash, signature);
185         _throwError(error);
186         return recovered;
187     }
188 
189     /**
190      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
191      *
192      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
193      *
194      * _Available since v4.3._
195      */
196     function tryRecover(
197         bytes32 hash,
198         bytes32 r,
199         bytes32 vs
200     ) internal pure returns (address, RecoverError) {
201         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
202         uint8 v = uint8((uint256(vs) >> 255) + 27);
203         return tryRecover(hash, v, r, s);
204     }
205 
206     /**
207      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
208      *
209      * _Available since v4.2._
210      */
211     function recover(
212         bytes32 hash,
213         bytes32 r,
214         bytes32 vs
215     ) internal pure returns (address) {
216         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
217         _throwError(error);
218         return recovered;
219     }
220 
221     /**
222      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
223      * `r` and `s` signature fields separately.
224      *
225      * _Available since v4.3._
226      */
227     function tryRecover(
228         bytes32 hash,
229         uint8 v,
230         bytes32 r,
231         bytes32 s
232     ) internal pure returns (address, RecoverError) {
233         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
234         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
235         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
236         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
237         //
238         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
239         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
240         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
241         // these malleable signatures as well.
242         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
243             return (address(0), RecoverError.InvalidSignatureS);
244         }
245         if (v != 27 && v != 28) {
246             return (address(0), RecoverError.InvalidSignatureV);
247         }
248 
249         // If the signature is valid (and not malleable), return the signer address
250         address signer = ecrecover(hash, v, r, s);
251         if (signer == address(0)) {
252             return (address(0), RecoverError.InvalidSignature);
253         }
254 
255         return (signer, RecoverError.NoError);
256     }
257 
258     /**
259      * @dev Overload of {ECDSA-recover} that receives the `v`,
260      * `r` and `s` signature fields separately.
261      */
262     function recover(
263         bytes32 hash,
264         uint8 v,
265         bytes32 r,
266         bytes32 s
267     ) internal pure returns (address) {
268         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
269         _throwError(error);
270         return recovered;
271     }
272 
273     /**
274      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
275      * produces hash corresponding to the one signed with the
276      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
277      * JSON-RPC method as part of EIP-191.
278      *
279      * See {recover}.
280      */
281     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
282         // 32 is the length in bytes of hash,
283         // enforced by the type signature above
284         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
285     }
286 
287     /**
288      * @dev Returns an Ethereum Signed Message, created from `s`. This
289      * produces hash corresponding to the one signed with the
290      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
291      * JSON-RPC method as part of EIP-191.
292      *
293      * See {recover}.
294      */
295     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
296         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
297     }
298 
299     /**
300      * @dev Returns an Ethereum Signed Typed Data, created from a
301      * `domainSeparator` and a `structHash`. This produces hash corresponding
302      * to the one signed with the
303      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
304      * JSON-RPC method as part of EIP-712.
305      *
306      * See {recover}.
307      */
308     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
309         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
310     }
311 }
312 
313 // File: @openzeppelin/contracts/utils/Context.sol
314 
315 
316 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
317 
318 pragma solidity ^0.8.0;
319 
320 /**
321  * @dev Provides information about the current execution context, including the
322  * sender of the transaction and its data. While these are generally available
323  * via msg.sender and msg.data, they should not be accessed in such a direct
324  * manner, since when dealing with meta-transactions the account sending and
325  * paying for execution may not be the actual sender (as far as an application
326  * is concerned).
327  *
328  * This contract is only required for intermediate, library-like contracts.
329  */
330 abstract contract Context {
331     function _msgSender() internal view virtual returns (address) {
332         return msg.sender;
333     }
334 
335     function _msgData() internal view virtual returns (bytes calldata) {
336         return msg.data;
337     }
338 }
339 
340 // File: @openzeppelin/contracts/access/Ownable.sol
341 
342 
343 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
344 
345 pragma solidity ^0.8.0;
346 
347 
348 /**
349  * @dev Contract module which provides a basic access control mechanism, where
350  * there is an account (an owner) that can be granted exclusive access to
351  * specific functions.
352  *
353  * By default, the owner account will be the one that deploys the contract. This
354  * can later be changed with {transferOwnership}.
355  *
356  * This module is used through inheritance. It will make available the modifier
357  * `onlyOwner`, which can be applied to your functions to restrict their use to
358  * the owner.
359  */
360 abstract contract Ownable is Context {
361     address private _owner;
362 
363     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
364 
365     /**
366      * @dev Initializes the contract setting the deployer as the initial owner.
367      */
368     constructor() {
369         _transferOwnership(_msgSender());
370     }
371 
372     /**
373      * @dev Returns the address of the current owner.
374      */
375     function owner() public view virtual returns (address) {
376         return _owner;
377     }
378 
379     /**
380      * @dev Throws if called by any account other than the owner.
381      */
382     modifier onlyOwner() {
383         require(owner() == _msgSender(), "Ownable: caller is not the owner");
384         _;
385     }
386 
387     /**
388      * @dev Leaves the contract without owner. It will not be possible to call
389      * `onlyOwner` functions anymore. Can only be called by the current owner.
390      *
391      * NOTE: Renouncing ownership will leave the contract without an owner,
392      * thereby removing any functionality that is only available to the owner.
393      */
394     function renounceOwnership() public virtual onlyOwner {
395         _transferOwnership(address(0));
396     }
397 
398     /**
399      * @dev Transfers ownership of the contract to a new account (`newOwner`).
400      * Can only be called by the current owner.
401      */
402     function transferOwnership(address newOwner) public virtual onlyOwner {
403         require(newOwner != address(0), "Ownable: new owner is the zero address");
404         _transferOwnership(newOwner);
405     }
406 
407     /**
408      * @dev Transfers ownership of the contract to a new account (`newOwner`).
409      * Internal function without access restriction.
410      */
411     function _transferOwnership(address newOwner) internal virtual {
412         address oldOwner = _owner;
413         _owner = newOwner;
414         emit OwnershipTransferred(oldOwner, newOwner);
415     }
416 }
417 
418 // File: @openzeppelin/contracts/utils/Address.sol
419 
420 
421 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
422 
423 pragma solidity ^0.8.1;
424 
425 /**
426  * @dev Collection of functions related to the address type
427  */
428 library Address {
429     /**
430      * @dev Returns true if `account` is a contract.
431      *
432      * [IMPORTANT]
433      * ====
434      * It is unsafe to assume that an address for which this function returns
435      * false is an externally-owned account (EOA) and not a contract.
436      *
437      * Among others, `isContract` will return false for the following
438      * types of addresses:
439      *
440      *  - an externally-owned account
441      *  - a contract in construction
442      *  - an address where a contract will be created
443      *  - an address where a contract lived, but was destroyed
444      * ====
445      *
446      * [IMPORTANT]
447      * ====
448      * You shouldn't rely on `isContract` to protect against flash loan attacks!
449      *
450      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
451      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
452      * constructor.
453      * ====
454      */
455     function isContract(address account) internal view returns (bool) {
456         // This method relies on extcodesize/address.code.length, which returns 0
457         // for contracts in construction, since the code is only stored at the end
458         // of the constructor execution.
459 
460         return account.code.length > 0;
461     }
462 
463     /**
464      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
465      * `recipient`, forwarding all available gas and reverting on errors.
466      *
467      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
468      * of certain opcodes, possibly making contracts go over the 2300 gas limit
469      * imposed by `transfer`, making them unable to receive funds via
470      * `transfer`. {sendValue} removes this limitation.
471      *
472      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
473      *
474      * IMPORTANT: because control is transferred to `recipient`, care must be
475      * taken to not create reentrancy vulnerabilities. Consider using
476      * {ReentrancyGuard} or the
477      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
478      */
479     function sendValue(address payable recipient, uint256 amount) internal {
480         require(address(this).balance >= amount, "Address: insufficient balance");
481 
482         (bool success, ) = recipient.call{value: amount}("");
483         require(success, "Address: unable to send value, recipient may have reverted");
484     }
485 
486     /**
487      * @dev Performs a Solidity function call using a low level `call`. A
488      * plain `call` is an unsafe replacement for a function call: use this
489      * function instead.
490      *
491      * If `target` reverts with a revert reason, it is bubbled up by this
492      * function (like regular Solidity function calls).
493      *
494      * Returns the raw returned data. To convert to the expected return value,
495      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
496      *
497      * Requirements:
498      *
499      * - `target` must be a contract.
500      * - calling `target` with `data` must not revert.
501      *
502      * _Available since v3.1._
503      */
504     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
505         return functionCall(target, data, "Address: low-level call failed");
506     }
507 
508     /**
509      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
510      * `errorMessage` as a fallback revert reason when `target` reverts.
511      *
512      * _Available since v3.1._
513      */
514     function functionCall(
515         address target,
516         bytes memory data,
517         string memory errorMessage
518     ) internal returns (bytes memory) {
519         return functionCallWithValue(target, data, 0, errorMessage);
520     }
521 
522     /**
523      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
524      * but also transferring `value` wei to `target`.
525      *
526      * Requirements:
527      *
528      * - the calling contract must have an ETH balance of at least `value`.
529      * - the called Solidity function must be `payable`.
530      *
531      * _Available since v3.1._
532      */
533     function functionCallWithValue(
534         address target,
535         bytes memory data,
536         uint256 value
537     ) internal returns (bytes memory) {
538         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
539     }
540 
541     /**
542      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
543      * with `errorMessage` as a fallback revert reason when `target` reverts.
544      *
545      * _Available since v3.1._
546      */
547     function functionCallWithValue(
548         address target,
549         bytes memory data,
550         uint256 value,
551         string memory errorMessage
552     ) internal returns (bytes memory) {
553         require(address(this).balance >= value, "Address: insufficient balance for call");
554         require(isContract(target), "Address: call to non-contract");
555 
556         (bool success, bytes memory returndata) = target.call{value: value}(data);
557         return verifyCallResult(success, returndata, errorMessage);
558     }
559 
560     /**
561      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
562      * but performing a static call.
563      *
564      * _Available since v3.3._
565      */
566     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
567         return functionStaticCall(target, data, "Address: low-level static call failed");
568     }
569 
570     /**
571      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
572      * but performing a static call.
573      *
574      * _Available since v3.3._
575      */
576     function functionStaticCall(
577         address target,
578         bytes memory data,
579         string memory errorMessage
580     ) internal view returns (bytes memory) {
581         require(isContract(target), "Address: static call to non-contract");
582 
583         (bool success, bytes memory returndata) = target.staticcall(data);
584         return verifyCallResult(success, returndata, errorMessage);
585     }
586 
587     /**
588      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
589      * but performing a delegate call.
590      *
591      * _Available since v3.4._
592      */
593     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
594         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
595     }
596 
597     /**
598      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
599      * but performing a delegate call.
600      *
601      * _Available since v3.4._
602      */
603     function functionDelegateCall(
604         address target,
605         bytes memory data,
606         string memory errorMessage
607     ) internal returns (bytes memory) {
608         require(isContract(target), "Address: delegate call to non-contract");
609 
610         (bool success, bytes memory returndata) = target.delegatecall(data);
611         return verifyCallResult(success, returndata, errorMessage);
612     }
613 
614     /**
615      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
616      * revert reason using the provided one.
617      *
618      * _Available since v4.3._
619      */
620     function verifyCallResult(
621         bool success,
622         bytes memory returndata,
623         string memory errorMessage
624     ) internal pure returns (bytes memory) {
625         if (success) {
626             return returndata;
627         } else {
628             // Look for revert reason and bubble it up if present
629             if (returndata.length > 0) {
630                 // The easiest way to bubble the revert reason is using memory via assembly
631 
632                 assembly {
633                     let returndata_size := mload(returndata)
634                     revert(add(32, returndata), returndata_size)
635                 }
636             } else {
637                 revert(errorMessage);
638             }
639         }
640     }
641 }
642 
643 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
644 
645 
646 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
647 
648 pragma solidity ^0.8.0;
649 
650 /**
651  * @title ERC721 token receiver interface
652  * @dev Interface for any contract that wants to support safeTransfers
653  * from ERC721 asset contracts.
654  */
655 interface IERC721Receiver {
656     /**
657      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
658      * by `operator` from `from`, this function is called.
659      *
660      * It must return its Solidity selector to confirm the token transfer.
661      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
662      *
663      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
664      */
665     function onERC721Received(
666         address operator,
667         address from,
668         uint256 tokenId,
669         bytes calldata data
670     ) external returns (bytes4);
671 }
672 
673 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
674 
675 
676 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
677 
678 pragma solidity ^0.8.0;
679 
680 /**
681  * @dev Interface of the ERC165 standard, as defined in the
682  * https://eips.ethereum.org/EIPS/eip-165[EIP].
683  *
684  * Implementers can declare support of contract interfaces, which can then be
685  * queried by others ({ERC165Checker}).
686  *
687  * For an implementation, see {ERC165}.
688  */
689 interface IERC165 {
690     /**
691      * @dev Returns true if this contract implements the interface defined by
692      * `interfaceId`. See the corresponding
693      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
694      * to learn more about how these ids are created.
695      *
696      * This function call must use less than 30 000 gas.
697      */
698     function supportsInterface(bytes4 interfaceId) external view returns (bool);
699 }
700 
701 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
702 
703 
704 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
705 
706 pragma solidity ^0.8.0;
707 
708 
709 /**
710  * @dev Implementation of the {IERC165} interface.
711  *
712  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
713  * for the additional interface id that will be supported. For example:
714  *
715  * ```solidity
716  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
717  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
718  * }
719  * ```
720  *
721  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
722  */
723 abstract contract ERC165 is IERC165 {
724     /**
725      * @dev See {IERC165-supportsInterface}.
726      */
727     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
728         return interfaceId == type(IERC165).interfaceId;
729     }
730 }
731 
732 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
733 
734 
735 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
736 
737 pragma solidity ^0.8.0;
738 
739 
740 /**
741  * @dev Required interface of an ERC721 compliant contract.
742  */
743 interface IERC721 is IERC165 {
744     /**
745      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
746      */
747     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
748 
749     /**
750      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
751      */
752     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
753 
754     /**
755      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
756      */
757     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
758 
759     /**
760      * @dev Returns the number of tokens in ``owner``'s account.
761      */
762     function balanceOf(address owner) external view returns (uint256 balance);
763 
764     /**
765      * @dev Returns the owner of the `tokenId` token.
766      *
767      * Requirements:
768      *
769      * - `tokenId` must exist.
770      */
771     function ownerOf(uint256 tokenId) external view returns (address owner);
772 
773     /**
774      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
775      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
776      *
777      * Requirements:
778      *
779      * - `from` cannot be the zero address.
780      * - `to` cannot be the zero address.
781      * - `tokenId` token must exist and be owned by `from`.
782      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
783      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
784      *
785      * Emits a {Transfer} event.
786      */
787     function safeTransferFrom(
788         address from,
789         address to,
790         uint256 tokenId
791     ) external;
792 
793     /**
794      * @dev Transfers `tokenId` token from `from` to `to`.
795      *
796      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
797      *
798      * Requirements:
799      *
800      * - `from` cannot be the zero address.
801      * - `to` cannot be the zero address.
802      * - `tokenId` token must be owned by `from`.
803      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
804      *
805      * Emits a {Transfer} event.
806      */
807     function transferFrom(
808         address from,
809         address to,
810         uint256 tokenId
811     ) external;
812 
813     /**
814      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
815      * The approval is cleared when the token is transferred.
816      *
817      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
818      *
819      * Requirements:
820      *
821      * - The caller must own the token or be an approved operator.
822      * - `tokenId` must exist.
823      *
824      * Emits an {Approval} event.
825      */
826     function approve(address to, uint256 tokenId) external;
827 
828     /**
829      * @dev Returns the account approved for `tokenId` token.
830      *
831      * Requirements:
832      *
833      * - `tokenId` must exist.
834      */
835     function getApproved(uint256 tokenId) external view returns (address operator);
836 
837     /**
838      * @dev Approve or remove `operator` as an operator for the caller.
839      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
840      *
841      * Requirements:
842      *
843      * - The `operator` cannot be the caller.
844      *
845      * Emits an {ApprovalForAll} event.
846      */
847     function setApprovalForAll(address operator, bool _approved) external;
848 
849     /**
850      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
851      *
852      * See {setApprovalForAll}
853      */
854     function isApprovedForAll(address owner, address operator) external view returns (bool);
855 
856     /**
857      * @dev Safely transfers `tokenId` token from `from` to `to`.
858      *
859      * Requirements:
860      *
861      * - `from` cannot be the zero address.
862      * - `to` cannot be the zero address.
863      * - `tokenId` token must exist and be owned by `from`.
864      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
865      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
866      *
867      * Emits a {Transfer} event.
868      */
869     function safeTransferFrom(
870         address from,
871         address to,
872         uint256 tokenId,
873         bytes calldata data
874     ) external;
875 }
876 
877 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
878 
879 
880 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
881 
882 pragma solidity ^0.8.0;
883 
884 
885 /**
886  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
887  * @dev See https://eips.ethereum.org/EIPS/eip-721
888  */
889 interface IERC721Metadata is IERC721 {
890     /**
891      * @dev Returns the token collection name.
892      */
893     function name() external view returns (string memory);
894 
895     /**
896      * @dev Returns the token collection symbol.
897      */
898     function symbol() external view returns (string memory);
899 
900     /**
901      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
902      */
903     function tokenURI(uint256 tokenId) external view returns (string memory);
904 }
905 
906 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
907 
908 
909 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
910 
911 pragma solidity ^0.8.0;
912 
913 
914 
915 
916 
917 
918 
919 
920 /**
921  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
922  * the Metadata extension, but not including the Enumerable extension, which is available separately as
923  * {ERC721Enumerable}.
924  */
925 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
926     using Address for address;
927     using Strings for uint256;
928 
929     // Token name
930     string private _name;
931 
932     // Token symbol
933     string private _symbol;
934 
935     // Mapping from token ID to owner address
936     mapping(uint256 => address) private _owners;
937 
938     // Mapping owner address to token count
939     mapping(address => uint256) private _balances;
940 
941     // Mapping from token ID to approved address
942     mapping(uint256 => address) private _tokenApprovals;
943 
944     // Mapping from owner to operator approvals
945     mapping(address => mapping(address => bool)) private _operatorApprovals;
946 
947     /**
948      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
949      */
950     constructor(string memory name_, string memory symbol_) {
951         _name = name_;
952         _symbol = symbol_;
953     }
954 
955     /**
956      * @dev See {IERC165-supportsInterface}.
957      */
958     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
959         return
960             interfaceId == type(IERC721).interfaceId ||
961             interfaceId == type(IERC721Metadata).interfaceId ||
962             super.supportsInterface(interfaceId);
963     }
964 
965     /**
966      * @dev See {IERC721-balanceOf}.
967      */
968     function balanceOf(address owner) public view virtual override returns (uint256) {
969         require(owner != address(0), "ERC721: balance query for the zero address");
970         return _balances[owner];
971     }
972 
973     /**
974      * @dev See {IERC721-ownerOf}.
975      */
976     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
977         address owner = _owners[tokenId];
978         require(owner != address(0), "ERC721: owner query for nonexistent token");
979         return owner;
980     }
981 
982     /**
983      * @dev See {IERC721Metadata-name}.
984      */
985     function name() public view virtual override returns (string memory) {
986         return _name;
987     }
988 
989     /**
990      * @dev See {IERC721Metadata-symbol}.
991      */
992     function symbol() public view virtual override returns (string memory) {
993         return _symbol;
994     }
995 
996     /**
997      * @dev See {IERC721Metadata-tokenURI}.
998      */
999     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1000         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1001 
1002         string memory baseURI = _baseURI();
1003         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1004     }
1005 
1006     /**
1007      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1008      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1009      * by default, can be overriden in child contracts.
1010      */
1011     function _baseURI() internal view virtual returns (string memory) {
1012         return "";
1013     }
1014 
1015     /**
1016      * @dev See {IERC721-approve}.
1017      */
1018     function approve(address to, uint256 tokenId) public virtual override {
1019         address owner = ERC721.ownerOf(tokenId);
1020         require(to != owner, "ERC721: approval to current owner");
1021 
1022         require(
1023             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1024             "ERC721: approve caller is not owner nor approved for all"
1025         );
1026 
1027         _approve(to, tokenId);
1028     }
1029 
1030     /**
1031      * @dev See {IERC721-getApproved}.
1032      */
1033     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1034         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1035 
1036         return _tokenApprovals[tokenId];
1037     }
1038 
1039     /**
1040      * @dev See {IERC721-setApprovalForAll}.
1041      */
1042     function setApprovalForAll(address operator, bool approved) public virtual override {
1043         _setApprovalForAll(_msgSender(), operator, approved);
1044     }
1045 
1046     /**
1047      * @dev See {IERC721-isApprovedForAll}.
1048      */
1049     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1050         return _operatorApprovals[owner][operator];
1051     }
1052 
1053     /**
1054      * @dev See {IERC721-transferFrom}.
1055      */
1056     function transferFrom(
1057         address from,
1058         address to,
1059         uint256 tokenId
1060     ) public virtual override {
1061         //solhint-disable-next-line max-line-length
1062         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1063 
1064         _transfer(from, to, tokenId);
1065     }
1066 
1067     /**
1068      * @dev See {IERC721-safeTransferFrom}.
1069      */
1070     function safeTransferFrom(
1071         address from,
1072         address to,
1073         uint256 tokenId
1074     ) public virtual override {
1075         safeTransferFrom(from, to, tokenId, "");
1076     }
1077 
1078     /**
1079      * @dev See {IERC721-safeTransferFrom}.
1080      */
1081     function safeTransferFrom(
1082         address from,
1083         address to,
1084         uint256 tokenId,
1085         bytes memory _data
1086     ) public virtual override {
1087         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1088         _safeTransfer(from, to, tokenId, _data);
1089     }
1090 
1091     /**
1092      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1093      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1094      *
1095      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1096      *
1097      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1098      * implement alternative mechanisms to perform token transfer, such as signature-based.
1099      *
1100      * Requirements:
1101      *
1102      * - `from` cannot be the zero address.
1103      * - `to` cannot be the zero address.
1104      * - `tokenId` token must exist and be owned by `from`.
1105      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1106      *
1107      * Emits a {Transfer} event.
1108      */
1109     function _safeTransfer(
1110         address from,
1111         address to,
1112         uint256 tokenId,
1113         bytes memory _data
1114     ) internal virtual {
1115         _transfer(from, to, tokenId);
1116         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1117     }
1118 
1119     /**
1120      * @dev Returns whether `tokenId` exists.
1121      *
1122      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1123      *
1124      * Tokens start existing when they are minted (`_mint`),
1125      * and stop existing when they are burned (`_burn`).
1126      */
1127     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1128         return _owners[tokenId] != address(0);
1129     }
1130 
1131     /**
1132      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1133      *
1134      * Requirements:
1135      *
1136      * - `tokenId` must exist.
1137      */
1138     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1139         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1140         address owner = ERC721.ownerOf(tokenId);
1141         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1142     }
1143 
1144     /**
1145      * @dev Safely mints `tokenId` and transfers it to `to`.
1146      *
1147      * Requirements:
1148      *
1149      * - `tokenId` must not exist.
1150      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1151      *
1152      * Emits a {Transfer} event.
1153      */
1154     function _safeMint(address to, uint256 tokenId) internal virtual {
1155         _safeMint(to, tokenId, "");
1156     }
1157 
1158     /**
1159      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1160      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1161      */
1162     function _safeMint(
1163         address to,
1164         uint256 tokenId,
1165         bytes memory _data
1166     ) internal virtual {
1167         _mint(to, tokenId);
1168         require(
1169             _checkOnERC721Received(address(0), to, tokenId, _data),
1170             "ERC721: transfer to non ERC721Receiver implementer"
1171         );
1172     }
1173 
1174     /**
1175      * @dev Mints `tokenId` and transfers it to `to`.
1176      *
1177      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1178      *
1179      * Requirements:
1180      *
1181      * - `tokenId` must not exist.
1182      * - `to` cannot be the zero address.
1183      *
1184      * Emits a {Transfer} event.
1185      */
1186     function _mint(address to, uint256 tokenId) internal virtual {
1187         require(to != address(0), "ERC721: mint to the zero address");
1188         require(!_exists(tokenId), "ERC721: token already minted");
1189 
1190         _beforeTokenTransfer(address(0), to, tokenId);
1191 
1192         _balances[to] += 1;
1193         _owners[tokenId] = to;
1194 
1195         emit Transfer(address(0), to, tokenId);
1196 
1197         _afterTokenTransfer(address(0), to, tokenId);
1198     }
1199 
1200     /**
1201      * @dev Destroys `tokenId`.
1202      * The approval is cleared when the token is burned.
1203      *
1204      * Requirements:
1205      *
1206      * - `tokenId` must exist.
1207      *
1208      * Emits a {Transfer} event.
1209      */
1210     function _burn(uint256 tokenId) internal virtual {
1211         address owner = ERC721.ownerOf(tokenId);
1212 
1213         _beforeTokenTransfer(owner, address(0), tokenId);
1214 
1215         // Clear approvals
1216         _approve(address(0), tokenId);
1217 
1218         _balances[owner] -= 1;
1219         delete _owners[tokenId];
1220 
1221         emit Transfer(owner, address(0), tokenId);
1222 
1223         _afterTokenTransfer(owner, address(0), tokenId);
1224     }
1225 
1226     /**
1227      * @dev Transfers `tokenId` from `from` to `to`.
1228      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1229      *
1230      * Requirements:
1231      *
1232      * - `to` cannot be the zero address.
1233      * - `tokenId` token must be owned by `from`.
1234      *
1235      * Emits a {Transfer} event.
1236      */
1237     function _transfer(
1238         address from,
1239         address to,
1240         uint256 tokenId
1241     ) internal virtual {
1242         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1243         require(to != address(0), "ERC721: transfer to the zero address");
1244 
1245         _beforeTokenTransfer(from, to, tokenId);
1246 
1247         // Clear approvals from the previous owner
1248         _approve(address(0), tokenId);
1249 
1250         _balances[from] -= 1;
1251         _balances[to] += 1;
1252         _owners[tokenId] = to;
1253 
1254         emit Transfer(from, to, tokenId);
1255 
1256         _afterTokenTransfer(from, to, tokenId);
1257     }
1258 
1259     /**
1260      * @dev Approve `to` to operate on `tokenId`
1261      *
1262      * Emits a {Approval} event.
1263      */
1264     function _approve(address to, uint256 tokenId) internal virtual {
1265         _tokenApprovals[tokenId] = to;
1266         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1267     }
1268 
1269     /**
1270      * @dev Approve `operator` to operate on all of `owner` tokens
1271      *
1272      * Emits a {ApprovalForAll} event.
1273      */
1274     function _setApprovalForAll(
1275         address owner,
1276         address operator,
1277         bool approved
1278     ) internal virtual {
1279         require(owner != operator, "ERC721: approve to caller");
1280         _operatorApprovals[owner][operator] = approved;
1281         emit ApprovalForAll(owner, operator, approved);
1282     }
1283 
1284     /**
1285      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1286      * The call is not executed if the target address is not a contract.
1287      *
1288      * @param from address representing the previous owner of the given token ID
1289      * @param to target address that will receive the tokens
1290      * @param tokenId uint256 ID of the token to be transferred
1291      * @param _data bytes optional data to send along with the call
1292      * @return bool whether the call correctly returned the expected magic value
1293      */
1294     function _checkOnERC721Received(
1295         address from,
1296         address to,
1297         uint256 tokenId,
1298         bytes memory _data
1299     ) private returns (bool) {
1300         if (to.isContract()) {
1301             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1302                 return retval == IERC721Receiver.onERC721Received.selector;
1303             } catch (bytes memory reason) {
1304                 if (reason.length == 0) {
1305                     revert("ERC721: transfer to non ERC721Receiver implementer");
1306                 } else {
1307                     assembly {
1308                         revert(add(32, reason), mload(reason))
1309                     }
1310                 }
1311             }
1312         } else {
1313             return true;
1314         }
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
1327      * - `from` and `to` are never both zero.
1328      *
1329      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1330      */
1331     function _beforeTokenTransfer(
1332         address from,
1333         address to,
1334         uint256 tokenId
1335     ) internal virtual {}
1336 
1337     /**
1338      * @dev Hook that is called after any transfer of tokens. This includes
1339      * minting and burning.
1340      *
1341      * Calling conditions:
1342      *
1343      * - when `from` and `to` are both non-zero.
1344      * - `from` and `to` are never both zero.
1345      *
1346      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1347      */
1348     function _afterTokenTransfer(
1349         address from,
1350         address to,
1351         uint256 tokenId
1352     ) internal virtual {}
1353 }
1354 
1355 // File: contract.sol
1356 
1357 
1358 pragma solidity ^0.8.4;
1359 
1360 
1361 
1362 
1363 contract Wackies is ERC721, Ownable {
1364     string private _tokenBaseURI = "https://gateway.pinata.cloud/ipfs/QmPwUNyn42xPfvBEFqo4oqtrtJ4tK6kBb8K3k31U8t9Q5t/";
1365     uint256 public WACK_MAX = 2500;
1366     uint256 public _tokensMinted;
1367     uint256 public WL1_PRICE = 0.02 ether;
1368     uint256 public WL2_PRICE = 0.08 ether;
1369     uint256 public PUBLIC_PRICE = 0.08 ether;
1370 
1371     bool public publicLive;
1372     bool public whitelistedLive;
1373 
1374     address private _signer = 0x40A9e33f85a1F310f0b435760eDFA436F11fc21b;
1375     string private constant SIG_WORD = "WACK_SC_D";
1376 
1377     mapping(address => uint256) public WL1_MINT_LIST;
1378     mapping(address => bool) public WL2_MINT_LIST;
1379     mapping(address => bool) public PUBLIC_MINT_LIST;
1380 
1381     using Strings for uint256;
1382     using ECDSA for bytes32;
1383 
1384     constructor() ERC721("Wackies", "WACK") {}
1385 
1386     modifier callerIsUser() {
1387         require(tx.origin == msg.sender, "The caller is another contract");
1388         _;
1389     }
1390 
1391     function matchAddresSigner(bytes memory signature, string memory whitelistingType) private view returns (bool) {
1392         bytes32 hash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", keccak256(abi.encodePacked(msg.sender, SIG_WORD, whitelistingType))));
1393         return _signer == hash.recover(signature);
1394     }
1395 
1396     function gift(address[] calldata receivers) external onlyOwner {
1397         require(_tokensMinted + receivers.length <= WACK_MAX, "EXCEED_MAX");
1398         for (uint256 i = 0; i < receivers.length; i++) {
1399              _tokensMinted++;
1400             _safeMint(receivers[i], _tokensMinted);
1401         }
1402     }
1403 
1404     function founderMint(uint256 tokenQuantity) external onlyOwner {
1405         require(_tokensMinted + tokenQuantity <= WACK_MAX, "EXCEED_MAX");
1406         for (uint256 index = 0; index < tokenQuantity; index++) {
1407             _tokensMinted++;
1408             _safeMint(msg.sender, _tokensMinted);          
1409         }
1410     }
1411 
1412     function mint() payable external callerIsUser {
1413         require(publicLive, "MINT_CLOSED");
1414         require(_tokensMinted + 1 <= WACK_MAX, "EXCEED_MAX");
1415         require(!PUBLIC_MINT_LIST[msg.sender], "EXCEED_ALLOWED");
1416         require(PUBLIC_PRICE <= msg.value, "INSUFFICIENT_ETH");
1417         PUBLIC_MINT_LIST[msg.sender] = true;
1418         _tokensMinted++;
1419         _safeMint(msg.sender, _tokensMinted);
1420     }
1421 
1422     function whitelisted1Mint(uint256 tokenQuantity, bytes memory signature) payable external callerIsUser {
1423         require(whitelistedLive, "MINT_CLOSED");
1424         require(matchAddresSigner(signature, "type_1"), "DIRECT_MINT_DISALLOWED");
1425         require(WL1_MINT_LIST[msg.sender] + tokenQuantity <= 2, "EXCEED_ALLOWED");
1426         require(_tokensMinted + tokenQuantity <= WACK_MAX, "EXCEED_MAX");
1427         require(WL1_PRICE * tokenQuantity <= msg.value, "INSUFFICIENT_ETH");
1428 
1429         WL1_MINT_LIST[msg.sender] = WL1_MINT_LIST[msg.sender] + tokenQuantity;
1430         for (uint256 index = 1; index <= tokenQuantity; index++) {
1431         _tokensMinted++;
1432             _safeMint(msg.sender, _tokensMinted);
1433         }  
1434     }
1435 
1436     function whitelisted2Mint(bytes memory signature) payable external callerIsUser {
1437         require(whitelistedLive, "MINT_CLOSED");
1438         require(matchAddresSigner(signature, "type_2"), "DIRECT_MINT_DISALLOWED");
1439         require(!WL2_MINT_LIST[msg.sender], "EXCEED_ALLOWED");
1440         require(_tokensMinted + 1 <= WACK_MAX, "EXCEED_MAX");
1441         require(WL2_PRICE <= msg.value, "INSUFFICIENT_ETH");
1442 
1443         WL2_MINT_LIST[msg.sender] = true;
1444         _tokensMinted++;
1445         _safeMint(msg.sender, _tokensMinted);
1446     }
1447 
1448     function togglePublicMintStatus() external onlyOwner {
1449         publicLive = !publicLive;
1450     }
1451 
1452     function togglePrivateStatus() external onlyOwner {
1453         whitelistedLive = !whitelistedLive;
1454     }
1455 
1456     function setBaseURI(string calldata baseURI) external onlyOwner {
1457         _tokenBaseURI = baseURI;
1458     }
1459 
1460     function setSigner(address newAddress) external onlyOwner {
1461         _signer = newAddress;
1462     }
1463 
1464     function totalSupply() public view returns (uint256) {
1465         return _tokensMinted;
1466     }
1467 
1468     function withdraw() external onlyOwner {
1469         uint256 currentBalance = address(this).balance;
1470         payable(0xbB68F66f170F6093774dc96F9A1574DCC139ad01).transfer(currentBalance *  30 / 1000);
1471         payable(0x7889cD973b678995cb992862a2b486D9f4eB24Ae).transfer(currentBalance *  60 / 1000);
1472         payable(0x11111F01570EeAA3e5a2Fd51f4A2f127661B9834).transfer(currentBalance * 120 / 1000);
1473         payable(0x520D5d67c1c64fDCcEde0fcbF7a3E4648dFD4594).transfer(address(this).balance);
1474     }
1475     
1476     function tokenURI(uint256 tokenId) public view override(ERC721) returns (string memory) {
1477         require(_exists(tokenId), "Cannot query non-existent token");
1478         return string(abi.encodePacked(_tokenBaseURI, tokenId.toString()));
1479     }
1480 }