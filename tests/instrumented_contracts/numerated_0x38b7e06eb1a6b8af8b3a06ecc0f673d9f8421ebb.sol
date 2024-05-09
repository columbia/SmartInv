1 // SPDX-License-Identifier: MIT
2 
3 // OpenZeppelin Contracts v4.4.0 (utils/Counters.sol)
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @title Counters
9  * @author Matt Condon (@shrugs)
10  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
11  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
12  *
13  * Include with `using Counters for Counters.Counter;`
14  */
15 library Counters {
16     struct Counter {
17         // This variable should never be directly accessed by users of the library: interactions must be restricted to
18         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
19         // this feature: see https://github.com/ethereum/solidity/issues/4637
20         uint256 _value; // default: 0
21     }
22 
23     function current(Counter storage counter) internal view returns (uint256) {
24         return counter._value;
25     }
26 
27     function increment(Counter storage counter) internal {
28         unchecked {
29             counter._value += 1;
30         }
31     }
32 
33     function decrement(Counter storage counter) internal {
34         uint256 value = counter._value;
35         require(value > 0, "Counter: decrement overflow");
36         unchecked {
37             counter._value = value - 1;
38         }
39     }
40 
41     function reset(Counter storage counter) internal {
42         counter._value = 0;
43     }
44 }
45 
46 
47 
48 // OpenZeppelin Contracts v4.4.0 (utils/Strings.sol)
49 
50 pragma solidity ^0.8.0;
51 
52 /**
53  * @dev String operations.
54  */
55 library Strings {
56     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
57 
58     /**
59      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
60      */
61     function toString(uint256 value) internal pure returns (string memory) {
62         // Inspired by OraclizeAPI's implementation - MIT licence
63         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
64 
65         if (value == 0) {
66             return "0";
67         }
68         uint256 temp = value;
69         uint256 digits;
70         while (temp != 0) {
71             digits++;
72             temp /= 10;
73         }
74         bytes memory buffer = new bytes(digits);
75         while (value != 0) {
76             digits -= 1;
77             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
78             value /= 10;
79         }
80         return string(buffer);
81     }
82 
83     /**
84      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
85      */
86     function toHexString(uint256 value) internal pure returns (string memory) {
87         if (value == 0) {
88             return "0x00";
89         }
90         uint256 temp = value;
91         uint256 length = 0;
92         while (temp != 0) {
93             length++;
94             temp >>= 8;
95         }
96         return toHexString(value, length);
97     }
98 
99     /**
100      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
101      */
102     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
103         bytes memory buffer = new bytes(2 * length + 2);
104         buffer[0] = "0";
105         buffer[1] = "x";
106         for (uint256 i = 2 * length + 1; i > 1; --i) {
107             buffer[i] = _HEX_SYMBOLS[value & 0xf];
108             value >>= 4;
109         }
110         require(value == 0, "Strings: hex length insufficient");
111         return string(buffer);
112     }
113 }
114 
115 
116 
117 // OpenZeppelin Contracts v4.4.0 (utils/cryptography/ECDSA.sol)
118 
119 pragma solidity ^0.8.0;
120 
121 /**
122  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
123  *
124  * These functions can be used to verify that a message was signed by the holder
125  * of the private keys of a given address.
126  */
127 library ECDSA {
128     enum RecoverError {
129         NoError,
130         InvalidSignature,
131         InvalidSignatureLength,
132         InvalidSignatureS,
133         InvalidSignatureV
134     }
135 
136     function _throwError(RecoverError error) private pure {
137         if (error == RecoverError.NoError) {
138             return; // no error: do nothing
139         } else if (error == RecoverError.InvalidSignature) {
140             revert("ECDSA: invalid signature");
141         } else if (error == RecoverError.InvalidSignatureLength) {
142             revert("ECDSA: invalid signature length");
143         } else if (error == RecoverError.InvalidSignatureS) {
144             revert("ECDSA: invalid signature 's' value");
145         } else if (error == RecoverError.InvalidSignatureV) {
146             revert("ECDSA: invalid signature 'v' value");
147         }
148     }
149 
150     /**
151      * @dev Returns the address that signed a hashed message (`hash`) with
152      * `signature` or error string. This address can then be used for verification purposes.
153      *
154      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
155      * this function rejects them by requiring the `s` value to be in the lower
156      * half order, and the `v` value to be either 27 or 28.
157      *
158      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
159      * verification to be secure: it is possible to craft signatures that
160      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
161      * this is by receiving a hash of the original message (which may otherwise
162      * be too long), and then calling {toEthSignedMessageHash} on it.
163      *
164      * Documentation for signature generation:
165      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
166      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
167      *
168      * _Available since v4.3._
169      */
170     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
171         // Check the signature length
172         // - case 65: r,s,v signature (standard)
173         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
174         if (signature.length == 65) {
175             bytes32 r;
176             bytes32 s;
177             uint8 v;
178             // ecrecover takes the signature parameters, and the only way to get them
179             // currently is to use assembly.
180             assembly {
181                 r := mload(add(signature, 0x20))
182                 s := mload(add(signature, 0x40))
183                 v := byte(0, mload(add(signature, 0x60)))
184             }
185             return tryRecover(hash, v, r, s);
186         } else if (signature.length == 64) {
187             bytes32 r;
188             bytes32 vs;
189             // ecrecover takes the signature parameters, and the only way to get them
190             // currently is to use assembly.
191             assembly {
192                 r := mload(add(signature, 0x20))
193                 vs := mload(add(signature, 0x40))
194             }
195             return tryRecover(hash, r, vs);
196         } else {
197             return (address(0), RecoverError.InvalidSignatureLength);
198         }
199     }
200 
201     /**
202      * @dev Returns the address that signed a hashed message (`hash`) with
203      * `signature`. This address can then be used for verification purposes.
204      *
205      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
206      * this function rejects them by requiring the `s` value to be in the lower
207      * half order, and the `v` value to be either 27 or 28.
208      *
209      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
210      * verification to be secure: it is possible to craft signatures that
211      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
212      * this is by receiving a hash of the original message (which may otherwise
213      * be too long), and then calling {toEthSignedMessageHash} on it.
214      */
215     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
216         (address recovered, RecoverError error) = tryRecover(hash, signature);
217         _throwError(error);
218         return recovered;
219     }
220 
221     /**
222      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
223      *
224      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
225      *
226      * _Available since v4.3._
227      */
228     function tryRecover(
229         bytes32 hash,
230         bytes32 r,
231         bytes32 vs
232     ) internal pure returns (address, RecoverError) {
233         bytes32 s;
234         uint8 v;
235         assembly {
236             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
237             v := add(shr(255, vs), 27)
238         }
239         return tryRecover(hash, v, r, s);
240     }
241 
242     /**
243      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
244      *
245      * _Available since v4.2._
246      */
247     function recover(
248         bytes32 hash,
249         bytes32 r,
250         bytes32 vs
251     ) internal pure returns (address) {
252         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
253         _throwError(error);
254         return recovered;
255     }
256 
257     /**
258      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
259      * `r` and `s` signature fields separately.
260      *
261      * _Available since v4.3._
262      */
263     function tryRecover(
264         bytes32 hash,
265         uint8 v,
266         bytes32 r,
267         bytes32 s
268     ) internal pure returns (address, RecoverError) {
269         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
270         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
271         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
272         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
273         //
274         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
275         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
276         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
277         // these malleable signatures as well.
278         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
279             return (address(0), RecoverError.InvalidSignatureS);
280         }
281         if (v != 27 && v != 28) {
282             return (address(0), RecoverError.InvalidSignatureV);
283         }
284 
285         // If the signature is valid (and not malleable), return the signer address
286         address signer = ecrecover(hash, v, r, s);
287         if (signer == address(0)) {
288             return (address(0), RecoverError.InvalidSignature);
289         }
290 
291         return (signer, RecoverError.NoError);
292     }
293 
294     /**
295      * @dev Overload of {ECDSA-recover} that receives the `v`,
296      * `r` and `s` signature fields separately.
297      */
298     function recover(
299         bytes32 hash,
300         uint8 v,
301         bytes32 r,
302         bytes32 s
303     ) internal pure returns (address) {
304         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
305         _throwError(error);
306         return recovered;
307     }
308 
309     /**
310      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
311      * produces hash corresponding to the one signed with the
312      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
313      * JSON-RPC method as part of EIP-191.
314      *
315      * See {recover}.
316      */
317     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
318         // 32 is the length in bytes of hash,
319         // enforced by the type signature above
320         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
321     }
322 
323     /**
324      * @dev Returns an Ethereum Signed Message, created from `s`. This
325      * produces hash corresponding to the one signed with the
326      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
327      * JSON-RPC method as part of EIP-191.
328      *
329      * See {recover}.
330      */
331     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
332         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
333     }
334 
335     /**
336      * @dev Returns an Ethereum Signed Typed Data, created from a
337      * `domainSeparator` and a `structHash`. This produces hash corresponding
338      * to the one signed with the
339      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
340      * JSON-RPC method as part of EIP-712.
341      *
342      * See {recover}.
343      */
344     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
345         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
346     }
347 }
348 
349 
350 
351 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
352 
353 pragma solidity ^0.8.0;
354 
355 /**
356  * @dev Provides information about the current execution context, including the
357  * sender of the transaction and its data. While these are generally available
358  * via msg.sender and msg.data, they should not be accessed in such a direct
359  * manner, since when dealing with meta-transactions the account sending and
360  * paying for execution may not be the actual sender (as far as an application
361  * is concerned).
362  *
363  * This contract is only required for intermediate, library-like contracts.
364  */
365 abstract contract Context {
366     function _msgSender() internal view virtual returns (address) {
367         return msg.sender;
368     }
369 
370     function _msgData() internal view virtual returns (bytes calldata) {
371         return msg.data;
372     }
373 }
374 
375 
376 
377 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
378 
379 pragma solidity ^0.8.0;
380 
381 /**
382  * @dev Contract module which provides a basic access control mechanism, where
383  * there is an account (an owner) that can be granted exclusive access to
384  * specific functions.
385  *
386  * By default, the owner account will be the one that deploys the contract. This
387  * can later be changed with {transferOwnership}.
388  *
389  * This module is used through inheritance. It will make available the modifier
390  * `onlyOwner`, which can be applied to your functions to restrict their use to
391  * the owner.
392  */
393 abstract contract Ownable is Context {
394     address private _owner;
395 
396     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
397 
398     /**
399      * @dev Initializes the contract setting the deployer as the initial owner.
400      */
401     constructor() {
402         _transferOwnership(_msgSender());
403     }
404 
405     /**
406      * @dev Returns the address of the current owner.
407      */
408     function owner() public view virtual returns (address) {
409         return _owner;
410     }
411 
412     /**
413      * @dev Throws if called by any account other than the owner.
414      */
415     modifier onlyOwner() {
416         require(owner() == _msgSender(), "Ownable: caller is not the owner");
417         _;
418     }
419 
420     /**
421      * @dev Leaves the contract without owner. It will not be possible to call
422      * `onlyOwner` functions anymore. Can only be called by the current owner.
423      *
424      * NOTE: Renouncing ownership will leave the contract without an owner,
425      * thereby removing any functionality that is only available to the owner.
426      */
427     function renounceOwnership() public virtual onlyOwner {
428         _transferOwnership(address(0));
429     }
430 
431     /**
432      * @dev Transfers ownership of the contract to a new account (`newOwner`).
433      * Can only be called by the current owner.
434      */
435     function transferOwnership(address newOwner) public virtual onlyOwner {
436         require(newOwner != address(0), "Ownable: new owner is the zero address");
437         _transferOwnership(newOwner);
438     }
439 
440     /**
441      * @dev Transfers ownership of the contract to a new account (`newOwner`).
442      * Internal function without access restriction.
443      */
444     function _transferOwnership(address newOwner) internal virtual {
445         address oldOwner = _owner;
446         _owner = newOwner;
447         emit OwnershipTransferred(oldOwner, newOwner);
448     }
449 }
450 
451 
452 
453 // OpenZeppelin Contracts v4.4.0 (utils/Address.sol)
454 
455 pragma solidity ^0.8.0;
456 
457 /**
458  * @dev Collection of functions related to the address type
459  */
460 library Address {
461     /**
462      * @dev Returns true if `account` is a contract.
463      *
464      * [IMPORTANT]
465      * ====
466      * It is unsafe to assume that an address for which this function returns
467      * false is an externally-owned account (EOA) and not a contract.
468      *
469      * Among others, `isContract` will return false for the following
470      * types of addresses:
471      *
472      *  - an externally-owned account
473      *  - a contract in construction
474      *  - an address where a contract will be created
475      *  - an address where a contract lived, but was destroyed
476      * ====
477      */
478     function isContract(address account) internal view returns (bool) {
479         // This method relies on extcodesize, which returns 0 for contracts in
480         // construction, since the code is only stored at the end of the
481         // constructor execution.
482 
483         uint256 size;
484         assembly {
485             size := extcodesize(account)
486         }
487         return size > 0;
488     }
489 
490     /**
491      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
492      * `recipient`, forwarding all available gas and reverting on errors.
493      *
494      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
495      * of certain opcodes, possibly making contracts go over the 2300 gas limit
496      * imposed by `transfer`, making them unable to receive funds via
497      * `transfer`. {sendValue} removes this limitation.
498      *
499      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
500      *
501      * IMPORTANT: because control is transferred to `recipient`, care must be
502      * taken to not create reentrancy vulnerabilities. Consider using
503      * {ReentrancyGuard} or the
504      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
505      */
506     function sendValue(address payable recipient, uint256 amount) internal {
507         require(address(this).balance >= amount, "Address: insufficient balance");
508 
509         (bool success, ) = recipient.call{value: amount}("");
510         require(success, "Address: unable to send value, recipient may have reverted");
511     }
512 
513     /**
514      * @dev Performs a Solidity function call using a low level `call`. A
515      * plain `call` is an unsafe replacement for a function call: use this
516      * function instead.
517      *
518      * If `target` reverts with a revert reason, it is bubbled up by this
519      * function (like regular Solidity function calls).
520      *
521      * Returns the raw returned data. To convert to the expected return value,
522      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
523      *
524      * Requirements:
525      *
526      * - `target` must be a contract.
527      * - calling `target` with `data` must not revert.
528      *
529      * _Available since v3.1._
530      */
531     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
532         return functionCall(target, data, "Address: low-level call failed");
533     }
534 
535     /**
536      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
537      * `errorMessage` as a fallback revert reason when `target` reverts.
538      *
539      * _Available since v3.1._
540      */
541     function functionCall(
542         address target,
543         bytes memory data,
544         string memory errorMessage
545     ) internal returns (bytes memory) {
546         return functionCallWithValue(target, data, 0, errorMessage);
547     }
548 
549     /**
550      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
551      * but also transferring `value` wei to `target`.
552      *
553      * Requirements:
554      *
555      * - the calling contract must have an ETH balance of at least `value`.
556      * - the called Solidity function must be `payable`.
557      *
558      * _Available since v3.1._
559      */
560     function functionCallWithValue(
561         address target,
562         bytes memory data,
563         uint256 value
564     ) internal returns (bytes memory) {
565         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
566     }
567 
568     /**
569      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
570      * with `errorMessage` as a fallback revert reason when `target` reverts.
571      *
572      * _Available since v3.1._
573      */
574     function functionCallWithValue(
575         address target,
576         bytes memory data,
577         uint256 value,
578         string memory errorMessage
579     ) internal returns (bytes memory) {
580         require(address(this).balance >= value, "Address: insufficient balance for call");
581         require(isContract(target), "Address: call to non-contract");
582 
583         (bool success, bytes memory returndata) = target.call{value: value}(data);
584         return verifyCallResult(success, returndata, errorMessage);
585     }
586 
587     /**
588      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
589      * but performing a static call.
590      *
591      * _Available since v3.3._
592      */
593     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
594         return functionStaticCall(target, data, "Address: low-level static call failed");
595     }
596 
597     /**
598      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
599      * but performing a static call.
600      *
601      * _Available since v3.3._
602      */
603     function functionStaticCall(
604         address target,
605         bytes memory data,
606         string memory errorMessage
607     ) internal view returns (bytes memory) {
608         require(isContract(target), "Address: static call to non-contract");
609 
610         (bool success, bytes memory returndata) = target.staticcall(data);
611         return verifyCallResult(success, returndata, errorMessage);
612     }
613 
614     /**
615      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
616      * but performing a delegate call.
617      *
618      * _Available since v3.4._
619      */
620     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
621         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
622     }
623 
624     /**
625      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
626      * but performing a delegate call.
627      *
628      * _Available since v3.4._
629      */
630     function functionDelegateCall(
631         address target,
632         bytes memory data,
633         string memory errorMessage
634     ) internal returns (bytes memory) {
635         require(isContract(target), "Address: delegate call to non-contract");
636 
637         (bool success, bytes memory returndata) = target.delegatecall(data);
638         return verifyCallResult(success, returndata, errorMessage);
639     }
640 
641     /**
642      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
643      * revert reason using the provided one.
644      *
645      * _Available since v4.3._
646      */
647     function verifyCallResult(
648         bool success,
649         bytes memory returndata,
650         string memory errorMessage
651     ) internal pure returns (bytes memory) {
652         if (success) {
653             return returndata;
654         } else {
655             // Look for revert reason and bubble it up if present
656             if (returndata.length > 0) {
657                 // The easiest way to bubble the revert reason is using memory via assembly
658 
659                 assembly {
660                     let returndata_size := mload(returndata)
661                     revert(add(32, returndata), returndata_size)
662                 }
663             } else {
664                 revert(errorMessage);
665             }
666         }
667     }
668 }
669 
670 
671 
672 // OpenZeppelin Contracts v4.4.0 (utils/introspection/IERC165.sol)
673 
674 pragma solidity ^0.8.0;
675 
676 /**
677  * @dev Interface of the ERC165 standard, as defined in the
678  * https://eips.ethereum.org/EIPS/eip-165[EIP].
679  *
680  * Implementers can declare support of contract interfaces, which can then be
681  * queried by others ({ERC165Checker}).
682  *
683  * For an implementation, see {ERC165}.
684  */
685 interface IERC165 {
686     /**
687      * @dev Returns true if this contract implements the interface defined by
688      * `interfaceId`. See the corresponding
689      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
690      * to learn more about how these ids are created.
691      *
692      * This function call must use less than 30 000 gas.
693      */
694     function supportsInterface(bytes4 interfaceId) external view returns (bool);
695 }
696 
697 
698 
699 // OpenZeppelin Contracts v4.4.0 (utils/introspection/ERC165.sol)
700 
701 pragma solidity ^0.8.0;
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
726 
727 
728 // OpenZeppelin Contracts v4.4.0 (token/ERC1155/IERC1155Receiver.sol)
729 
730 pragma solidity ^0.8.0;
731 
732 /**
733  * @dev _Available since v3.1._
734  */
735 interface IERC1155Receiver is IERC165 {
736     /**
737         @dev Handles the receipt of a single ERC1155 token type. This function is
738         called at the end of a `safeTransferFrom` after the balance has been updated.
739         To accept the transfer, this must return
740         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
741         (i.e. 0xf23a6e61, or its own function selector).
742         @param operator The address which initiated the transfer (i.e. msg.sender)
743         @param from The address which previously owned the token
744         @param id The ID of the token being transferred
745         @param value The amount of tokens being transferred
746         @param data Additional data with no specified format
747         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
748     */
749     function onERC1155Received(
750         address operator,
751         address from,
752         uint256 id,
753         uint256 value,
754         bytes calldata data
755     ) external returns (bytes4);
756 
757     /**
758         @dev Handles the receipt of a multiple ERC1155 token types. This function
759         is called at the end of a `safeBatchTransferFrom` after the balances have
760         been updated. To accept the transfer(s), this must return
761         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
762         (i.e. 0xbc197c81, or its own function selector).
763         @param operator The address which initiated the batch transfer (i.e. msg.sender)
764         @param from The address which previously owned the token
765         @param ids An array containing ids of each token being transferred (order and length must match values array)
766         @param values An array containing amounts of each token being transferred (order and length must match ids array)
767         @param data Additional data with no specified format
768         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
769     */
770     function onERC1155BatchReceived(
771         address operator,
772         address from,
773         uint256[] calldata ids,
774         uint256[] calldata values,
775         bytes calldata data
776     ) external returns (bytes4);
777 }
778 
779 
780 
781 // OpenZeppelin Contracts v4.4.0 (token/ERC1155/IERC1155.sol)
782 
783 pragma solidity ^0.8.0;
784 
785 /**
786  * @dev Required interface of an ERC1155 compliant contract, as defined in the
787  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
788  *
789  * _Available since v3.1._
790  */
791 interface IERC1155 is IERC165 {
792     /**
793      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
794      */
795     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
796 
797     /**
798      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
799      * transfers.
800      */
801     event TransferBatch(
802         address indexed operator,
803         address indexed from,
804         address indexed to,
805         uint256[] ids,
806         uint256[] values
807     );
808 
809     /**
810      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
811      * `approved`.
812      */
813     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
814 
815     /**
816      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
817      *
818      * If an {URI} event was emitted for `id`, the standard
819      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
820      * returned by {IERC1155MetadataURI-uri}.
821      */
822     event URI(string value, uint256 indexed id);
823 
824     /**
825      * @dev Returns the amount of tokens of token type `id` owned by `account`.
826      *
827      * Requirements:
828      *
829      * - `account` cannot be the zero address.
830      */
831     function balanceOf(address account, uint256 id) external view returns (uint256);
832 
833     /**
834      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
835      *
836      * Requirements:
837      *
838      * - `accounts` and `ids` must have the same length.
839      */
840     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
841         external
842         view
843         returns (uint256[] memory);
844 
845     /**
846      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
847      *
848      * Emits an {ApprovalForAll} event.
849      *
850      * Requirements:
851      *
852      * - `operator` cannot be the caller.
853      */
854     function setApprovalForAll(address operator, bool approved) external;
855 
856     /**
857      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
858      *
859      * See {setApprovalForAll}.
860      */
861     function isApprovedForAll(address account, address operator) external view returns (bool);
862 
863     /**
864      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
865      *
866      * Emits a {TransferSingle} event.
867      *
868      * Requirements:
869      *
870      * - `to` cannot be the zero address.
871      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
872      * - `from` must have a balance of tokens of type `id` of at least `amount`.
873      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
874      * acceptance magic value.
875      */
876     function safeTransferFrom(
877         address from,
878         address to,
879         uint256 id,
880         uint256 amount,
881         bytes calldata data
882     ) external;
883 
884     /**
885      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
886      *
887      * Emits a {TransferBatch} event.
888      *
889      * Requirements:
890      *
891      * - `ids` and `amounts` must have the same length.
892      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
893      * acceptance magic value.
894      */
895     function safeBatchTransferFrom(
896         address from,
897         address to,
898         uint256[] calldata ids,
899         uint256[] calldata amounts,
900         bytes calldata data
901     ) external;
902 }
903 
904 
905 
906 // OpenZeppelin Contracts v4.4.0 (token/ERC1155/extensions/IERC1155MetadataURI.sol)
907 
908 pragma solidity ^0.8.0;
909 
910 /**
911  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
912  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
913  *
914  * _Available since v3.1._
915  */
916 interface IERC1155MetadataURI is IERC1155 {
917     /**
918      * @dev Returns the URI for token type `id`.
919      *
920      * If the `\{id\}` substring is present in the URI, it must be replaced by
921      * clients with the actual token type ID.
922      */
923     function uri(uint256 id) external view returns (string memory);
924 }
925 
926 // OpenZeppelin Contracts v4.4.0 (token/ERC1155/ERC1155.sol)
927 
928 pragma solidity ^0.8.0;
929 
930 /**
931  * @dev Implementation of the basic standard multi-token.
932  * See https://eips.ethereum.org/EIPS/eip-1155
933  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
934  *
935  * _Available since v3.1._
936  */
937 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
938     using Address for address;
939 
940     // Mapping from token ID to account balances
941     mapping(uint256 => mapping(address => uint256)) private _balances;
942 
943     // Mapping from account to operator approvals
944     mapping(address => mapping(address => bool)) private _operatorApprovals;
945 
946     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
947     string private _uri;
948 
949     /**
950      * @dev See {_setURI}.
951      */
952     constructor(string memory uri_) {
953         _setURI(uri_);
954     }
955 
956     /**
957      * @dev See {IERC165-supportsInterface}.
958      */
959     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
960         return
961             interfaceId == type(IERC1155).interfaceId ||
962             interfaceId == type(IERC1155MetadataURI).interfaceId ||
963             super.supportsInterface(interfaceId);
964     }
965 
966     /**
967      * @dev See {IERC1155MetadataURI-uri}.
968      *
969      * This implementation returns the same URI for *all* token types. It relies
970      * on the token type ID substitution mechanism
971      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
972      *
973      * Clients calling this function must replace the `\{id\}` substring with the
974      * actual token type ID.
975      */
976     function uri(uint256) public view virtual override returns (string memory) {
977         return _uri;
978     }
979 
980     /**
981      * @dev See {IERC1155-balanceOf}.
982      *
983      * Requirements:
984      *
985      * - `account` cannot be the zero address.
986      */
987     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
988         require(account != address(0), "ERC1155: balance query for the zero address");
989         return _balances[id][account];
990     }
991 
992     /**
993      * @dev See {IERC1155-balanceOfBatch}.
994      *
995      * Requirements:
996      *
997      * - `accounts` and `ids` must have the same length.
998      */
999     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
1000         public
1001         view
1002         virtual
1003         override
1004         returns (uint256[] memory)
1005     {
1006         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
1007 
1008         uint256[] memory batchBalances = new uint256[](accounts.length);
1009 
1010         for (uint256 i = 0; i < accounts.length; ++i) {
1011             batchBalances[i] = balanceOf(accounts[i], ids[i]);
1012         }
1013 
1014         return batchBalances;
1015     }
1016 
1017     /**
1018      * @dev See {IERC1155-setApprovalForAll}.
1019      */
1020     function setApprovalForAll(address operator, bool approved) public virtual override {
1021         _setApprovalForAll(_msgSender(), operator, approved);
1022     }
1023 
1024     /**
1025      * @dev See {IERC1155-isApprovedForAll}.
1026      */
1027     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
1028         return _operatorApprovals[account][operator];
1029     }
1030 
1031     /**
1032      * @dev See {IERC1155-safeTransferFrom}.
1033      */
1034     function safeTransferFrom(
1035         address from,
1036         address to,
1037         uint256 id,
1038         uint256 amount,
1039         bytes memory data
1040     ) public virtual override {
1041         require(
1042             from == _msgSender() || isApprovedForAll(from, _msgSender()),
1043             "ERC1155: caller is not owner nor approved"
1044         );
1045         _safeTransferFrom(from, to, id, amount, data);
1046     }
1047 
1048     /**
1049      * @dev See {IERC1155-safeBatchTransferFrom}.
1050      */
1051     function safeBatchTransferFrom(
1052         address from,
1053         address to,
1054         uint256[] memory ids,
1055         uint256[] memory amounts,
1056         bytes memory data
1057     ) public virtual override {
1058         require(
1059             from == _msgSender() || isApprovedForAll(from, _msgSender()),
1060             "ERC1155: transfer caller is not owner nor approved"
1061         );
1062         _safeBatchTransferFrom(from, to, ids, amounts, data);
1063     }
1064 
1065     /**
1066      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
1067      *
1068      * Emits a {TransferSingle} event.
1069      *
1070      * Requirements:
1071      *
1072      * - `to` cannot be the zero address.
1073      * - `from` must have a balance of tokens of type `id` of at least `amount`.
1074      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1075      * acceptance magic value.
1076      */
1077     function _safeTransferFrom(
1078         address from,
1079         address to,
1080         uint256 id,
1081         uint256 amount,
1082         bytes memory data
1083     ) internal virtual {
1084         require(to != address(0), "ERC1155: transfer to the zero address");
1085 
1086         address operator = _msgSender();
1087 
1088         _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
1089 
1090         uint256 fromBalance = _balances[id][from];
1091         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
1092         unchecked {
1093             _balances[id][from] = fromBalance - amount;
1094         }
1095         _balances[id][to] += amount;
1096 
1097         emit TransferSingle(operator, from, to, id, amount);
1098 
1099         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
1100     }
1101 
1102     /**
1103      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
1104      *
1105      * Emits a {TransferBatch} event.
1106      *
1107      * Requirements:
1108      *
1109      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1110      * acceptance magic value.
1111      */
1112     function _safeBatchTransferFrom(
1113         address from,
1114         address to,
1115         uint256[] memory ids,
1116         uint256[] memory amounts,
1117         bytes memory data
1118     ) internal virtual {
1119         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1120         require(to != address(0), "ERC1155: transfer to the zero address");
1121 
1122         address operator = _msgSender();
1123 
1124         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
1125 
1126         for (uint256 i = 0; i < ids.length; ++i) {
1127             uint256 id = ids[i];
1128             uint256 amount = amounts[i];
1129 
1130             uint256 fromBalance = _balances[id][from];
1131             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
1132             unchecked {
1133                 _balances[id][from] = fromBalance - amount;
1134             }
1135             _balances[id][to] += amount;
1136         }
1137 
1138         emit TransferBatch(operator, from, to, ids, amounts);
1139 
1140         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
1141     }
1142 
1143     /**
1144      * @dev Sets a new URI for all token types, by relying on the token type ID
1145      * substitution mechanism
1146      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1147      *
1148      * By this mechanism, any occurrence of the `\{id\}` substring in either the
1149      * URI or any of the amounts in the JSON file at said URI will be replaced by
1150      * clients with the token type ID.
1151      *
1152      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
1153      * interpreted by clients as
1154      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
1155      * for token type ID 0x4cce0.
1156      *
1157      * See {uri}.
1158      *
1159      * Because these URIs cannot be meaningfully represented by the {URI} event,
1160      * this function emits no events.
1161      */
1162     function _setURI(string memory newuri) internal virtual {
1163         _uri = newuri;
1164     }
1165 
1166     /**
1167      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
1168      *
1169      * Emits a {TransferSingle} event.
1170      *
1171      * Requirements:
1172      *
1173      * - `to` cannot be the zero address.
1174      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1175      * acceptance magic value.
1176      */
1177     function _mint(
1178         address to,
1179         uint256 id,
1180         uint256 amount,
1181         bytes memory data
1182     ) internal virtual {
1183         require(to != address(0), "ERC1155: mint to the zero address");
1184 
1185         address operator = _msgSender();
1186 
1187         _beforeTokenTransfer(operator, address(0), to, _asSingletonArray(id), _asSingletonArray(amount), data);
1188 
1189         _balances[id][to] += amount;
1190         emit TransferSingle(operator, address(0), to, id, amount);
1191 
1192         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
1193     }
1194 
1195     /**
1196      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
1197      *
1198      * Requirements:
1199      *
1200      * - `ids` and `amounts` must have the same length.
1201      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1202      * acceptance magic value.
1203      */
1204     function _mintBatch(
1205         address to,
1206         uint256[] memory ids,
1207         uint256[] memory amounts,
1208         bytes memory data
1209     ) internal virtual {
1210         require(to != address(0), "ERC1155: mint to the zero address");
1211         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1212 
1213         address operator = _msgSender();
1214 
1215         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1216 
1217         for (uint256 i = 0; i < ids.length; i++) {
1218             _balances[ids[i]][to] += amounts[i];
1219         }
1220 
1221         emit TransferBatch(operator, address(0), to, ids, amounts);
1222 
1223         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
1224     }
1225 
1226     /**
1227      * @dev Destroys `amount` tokens of token type `id` from `from`
1228      *
1229      * Requirements:
1230      *
1231      * - `from` cannot be the zero address.
1232      * - `from` must have at least `amount` tokens of token type `id`.
1233      */
1234     function _burn(
1235         address from,
1236         uint256 id,
1237         uint256 amount
1238     ) internal virtual {
1239         require(from != address(0), "ERC1155: burn from the zero address");
1240 
1241         address operator = _msgSender();
1242 
1243         _beforeTokenTransfer(operator, from, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");
1244 
1245         uint256 fromBalance = _balances[id][from];
1246         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1247         unchecked {
1248             _balances[id][from] = fromBalance - amount;
1249         }
1250 
1251         emit TransferSingle(operator, from, address(0), id, amount);
1252     }
1253 
1254     /**
1255      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
1256      *
1257      * Requirements:
1258      *
1259      * - `ids` and `amounts` must have the same length.
1260      */
1261     function _burnBatch(
1262         address from,
1263         uint256[] memory ids,
1264         uint256[] memory amounts
1265     ) internal virtual {
1266         require(from != address(0), "ERC1155: burn from the zero address");
1267         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1268 
1269         address operator = _msgSender();
1270 
1271         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1272 
1273         for (uint256 i = 0; i < ids.length; i++) {
1274             uint256 id = ids[i];
1275             uint256 amount = amounts[i];
1276 
1277             uint256 fromBalance = _balances[id][from];
1278             require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1279             unchecked {
1280                 _balances[id][from] = fromBalance - amount;
1281             }
1282         }
1283 
1284         emit TransferBatch(operator, from, address(0), ids, amounts);
1285     }
1286 
1287     /**
1288      * @dev Approve `operator` to operate on all of `owner` tokens
1289      *
1290      * Emits a {ApprovalForAll} event.
1291      */
1292     function _setApprovalForAll(
1293         address owner,
1294         address operator,
1295         bool approved
1296     ) internal virtual {
1297         require(owner != operator, "ERC1155: setting approval status for self");
1298         _operatorApprovals[owner][operator] = approved;
1299         emit ApprovalForAll(owner, operator, approved);
1300     }
1301 
1302     /**
1303      * @dev Hook that is called before any token transfer. This includes minting
1304      * and burning, as well as batched variants.
1305      *
1306      * The same hook is called on both single and batched variants. For single
1307      * transfers, the length of the `id` and `amount` arrays will be 1.
1308      *
1309      * Calling conditions (for each `id` and `amount` pair):
1310      *
1311      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1312      * of token type `id` will be  transferred to `to`.
1313      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1314      * for `to`.
1315      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1316      * will be burned.
1317      * - `from` and `to` are never both zero.
1318      * - `ids` and `amounts` have the same, non-zero length.
1319      *
1320      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1321      */
1322     function _beforeTokenTransfer(
1323         address operator,
1324         address from,
1325         address to,
1326         uint256[] memory ids,
1327         uint256[] memory amounts,
1328         bytes memory data
1329     ) internal virtual {}
1330 
1331     function _doSafeTransferAcceptanceCheck(
1332         address operator,
1333         address from,
1334         address to,
1335         uint256 id,
1336         uint256 amount,
1337         bytes memory data
1338     ) private {
1339         if (to.isContract()) {
1340             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
1341                 if (response != IERC1155Receiver.onERC1155Received.selector) {
1342                     revert("ERC1155: ERC1155Receiver rejected tokens");
1343                 }
1344             } catch Error(string memory reason) {
1345                 revert(reason);
1346             } catch {
1347                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1348             }
1349         }
1350     }
1351 
1352     function _doSafeBatchTransferAcceptanceCheck(
1353         address operator,
1354         address from,
1355         address to,
1356         uint256[] memory ids,
1357         uint256[] memory amounts,
1358         bytes memory data
1359     ) private {
1360         if (to.isContract()) {
1361             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
1362                 bytes4 response
1363             ) {
1364                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
1365                     revert("ERC1155: ERC1155Receiver rejected tokens");
1366                 }
1367             } catch Error(string memory reason) {
1368                 revert(reason);
1369             } catch {
1370                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1371             }
1372         }
1373     }
1374 
1375     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1376         uint256[] memory array = new uint256[](1);
1377         array[0] = element;
1378 
1379         return array;
1380     }
1381 }
1382 
1383 pragma solidity ^0.8.0;
1384 
1385 /*
1386 
1387   █████╗ ███████╗██╗ █████╗ ███╗   ██╗
1388  ██╔══██╗██╔════╝██║██╔══██╗████╗  ██║
1389  ╚█████╔╝███████╗██║███████║██╔██╗ ██║
1390  ██╔══██╗╚════██║██║██╔══██║██║╚██╗██║
1391  ╚█████╔╝███████║██║██║  ██║██║ ╚████║
1392   ╚════╝ ╚══════╝╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝
1393          By Devko.dev#7286                                    
1394 */
1395 
1396 contract VIP_8SIAN_GOLD_PASS is ERC1155, Ownable  {
1397     using ECDSA for bytes32;
1398     using Counters for Counters.Counter;
1399     
1400     Counters.Counter public TOKENS_MINTED;
1401     uint256 constant MAX_TOKENS = 888;
1402     uint256 constant OG_PASS_ID = 0;
1403     uint256 constant PASS_ID = 1;
1404     uint256 constant TOKEN_PRICE = 0.088 ether;
1405     string private constant SIG_WORD = "8SIAN_PRESALE";
1406     address private SIGNER_ADDRESS = 0xebC4C5905E8813BB556636aDEbCbBb0822a84e14;
1407     mapping(address => bool) public buyersList;
1408     bool public presaleLive;
1409     bool public saleLive;
1410 
1411     constructor() ERC1155("https://gateway.pinata.cloud/ipfs/QmNTZ5CfcVVrNzRwar83qWq63SpTNbqgnhJwL1f5mFS5R4/{id}") {}
1412 
1413     function matchAddresSigner(bytes memory signature) private view returns(bool) {
1414          bytes32 hash = keccak256(abi.encodePacked(
1415             "\x19Ethereum Signed Message:\n32",
1416             keccak256(abi.encodePacked(msg.sender, SIG_WORD)))
1417           );
1418         return SIGNER_ADDRESS == hash.recover(signature);
1419     }
1420 
1421     function togglePresaleStatus() external onlyOwner {
1422         presaleLive = !presaleLive;
1423     }
1424 
1425     function toggleSaleStatus() external onlyOwner {
1426         saleLive = !saleLive;
1427     }
1428 
1429     function airdropOG(address[] calldata receivers) external onlyOwner {
1430         require(TOKENS_MINTED.current() + receivers.length <= MAX_TOKENS, "EXCEED_MAX_TOKENS");
1431         for (uint256 i = 0; i < receivers.length; i++) {
1432             TOKENS_MINTED.increment();
1433             _mint(receivers[i], OG_PASS_ID, 1 ,"");
1434         }
1435     }
1436 
1437     function airdrop(address[] calldata receivers) external onlyOwner {
1438         require(TOKENS_MINTED.current() + receivers.length <= MAX_TOKENS, "EXCEED_MAX_TOKENS");
1439         for (uint256 i = 0; i < receivers.length; i++) {
1440              TOKENS_MINTED.increment();
1441             _mint(receivers[i], PASS_ID, 1 ,"");
1442         }
1443     }
1444 
1445     function presale(bytes memory signature) external payable {
1446         require(presaleLive, "PRESALE_IS_NOT_ACTIVE");
1447         require(TOKENS_MINTED.current() + 1 <= MAX_TOKENS, "EXCEED_MAX_TOKENS");
1448         require(TOKEN_PRICE <= msg.value, "INSUFFICIENT_ETH");
1449         require(matchAddresSigner(signature), "DIRECT_MINT_DISALLOWED");
1450         require(!buyersList[msg.sender], "ALREADY_MINTED");
1451         buyersList[msg.sender] = true;
1452         TOKENS_MINTED.increment();
1453         _mint(msg.sender, OG_PASS_ID, 1, "");
1454     }
1455 
1456     function buy() external payable {
1457         require(saleLive, "SALE_IS_NOT_ACTIVE");
1458         require(TOKENS_MINTED.current() + 1 <= MAX_TOKENS, "EXCEED_MAX_TOKENS");
1459         require(TOKEN_PRICE <= msg.value, "INSUFFICIENT_ETH");
1460         TOKENS_MINTED.increment();
1461         _mint(msg.sender, PASS_ID, 1, "");  
1462     }
1463     
1464     function withdraw() external {
1465          uint256 currentBalance = address(this).balance;
1466          payable(0xc640E8B617F71E32f4c664Ea30921dAbF7870144).transfer(currentBalance * 210 / 1000);
1467          payable(0xe72441A43Ed985a9E3D43c11a7FcE93Dd282FF03).transfer(currentBalance * 200 / 1000);
1468          payable(0x683E1164Cf26875710737c77fBbE9AF8abCcd0AD).transfer(currentBalance * 165 / 1000);
1469          payable(0xb53b491e917Eefe9c4d713870B9a08D630670245).transfer(currentBalance * 150 / 1000);
1470          payable(0x11111F01570EeAA3e5a2Fd51f4A2f127661B9834).transfer(currentBalance * 80 / 1000);
1471          payable(0xE9D0BD5520af8c9ad20e12801315117dE9958149).transfer(currentBalance * 50 / 1000);
1472          payable(0x9178bCf3A4C25B9A321EDFE7360fA587f7bD10fd).transfer(currentBalance * 50 / 1000);
1473          payable(0x15A294789F34F91b03ec8a005fd27b13005f302e).transfer(currentBalance * 50 / 1000);
1474          payable(0xeD9C842645D9a2Bb66d4EAC77857768071384447).transfer(currentBalance * 25 / 1000);
1475          payable(0xe574a394e6BB6543e7726A7925f12bec531bdc7D).transfer(currentBalance * 10 / 1000);
1476          payable(0xc0F030eac8b588817f8dA16b9a2CDCcc6451B25c).transfer(address(this).balance);
1477     }
1478     
1479     receive() external payable {}
1480 }