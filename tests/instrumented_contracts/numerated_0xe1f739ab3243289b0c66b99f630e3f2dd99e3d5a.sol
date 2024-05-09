1 // SPDX-License-Identifier: Unlicensed
2 
3 // File: @openzeppelin/contracts/utils/Counters.sol
4 
5 
6 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @title Counters
12  * @author Matt Condon (@shrugs)
13  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
14  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
15  *
16  * Include with `using Counters for Counters.Counter;`
17  */
18 library Counters {
19     struct Counter {
20         // This variable should never be directly accessed by users of the library: interactions must be restricted to
21         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
22         // this feature: see https://github.com/ethereum/solidity/issues/4637
23         uint256 _value; // default: 0
24     }
25 
26     function current(Counter storage counter) internal view returns (uint256) {
27         return counter._value;
28     }
29 
30     function increment(Counter storage counter) internal {
31         unchecked {
32             counter._value += 1;
33         }
34     }
35 
36     function decrement(Counter storage counter) internal {
37         uint256 value = counter._value;
38         require(value > 0, "Counter: decrement overflow");
39         unchecked {
40             counter._value = value - 1;
41         }
42     }
43 
44     function reset(Counter storage counter) internal {
45         counter._value = 0;
46     }
47 }
48 
49 // File: @openzeppelin/contracts/utils/Strings.sol
50 
51 
52 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
53 
54 pragma solidity ^0.8.0;
55 
56 /**
57  * @dev String operations.
58  */
59 library Strings {
60     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
61 
62     /**
63      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
64      */
65     function toString(uint256 value) internal pure returns (string memory) {
66         // Inspired by OraclizeAPI's implementation - MIT licence
67         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
68 
69         if (value == 0) {
70             return "0";
71         }
72         uint256 temp = value;
73         uint256 digits;
74         while (temp != 0) {
75             digits++;
76             temp /= 10;
77         }
78         bytes memory buffer = new bytes(digits);
79         while (value != 0) {
80             digits -= 1;
81             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
82             value /= 10;
83         }
84         return string(buffer);
85     }
86 
87     /**
88      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
89      */
90     function toHexString(uint256 value) internal pure returns (string memory) {
91         if (value == 0) {
92             return "0x00";
93         }
94         uint256 temp = value;
95         uint256 length = 0;
96         while (temp != 0) {
97             length++;
98             temp >>= 8;
99         }
100         return toHexString(value, length);
101     }
102 
103     /**
104      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
105      */
106     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
107         bytes memory buffer = new bytes(2 * length + 2);
108         buffer[0] = "0";
109         buffer[1] = "x";
110         for (uint256 i = 2 * length + 1; i > 1; --i) {
111             buffer[i] = _HEX_SYMBOLS[value & 0xf];
112             value >>= 4;
113         }
114         require(value == 0, "Strings: hex length insufficient");
115         return string(buffer);
116     }
117 }
118 
119 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
120 
121 
122 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/ECDSA.sol)
123 
124 pragma solidity ^0.8.0;
125 
126 
127 /**
128  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
129  *
130  * These functions can be used to verify that a message was signed by the holder
131  * of the private keys of a given address.
132  */
133 library ECDSA {
134     enum RecoverError {
135         NoError,
136         InvalidSignature,
137         InvalidSignatureLength,
138         InvalidSignatureS,
139         InvalidSignatureV
140     }
141 
142     function _throwError(RecoverError error) private pure {
143         if (error == RecoverError.NoError) {
144             return; // no error: do nothing
145         } else if (error == RecoverError.InvalidSignature) {
146             revert("ECDSA: invalid signature");
147         } else if (error == RecoverError.InvalidSignatureLength) {
148             revert("ECDSA: invalid signature length");
149         } else if (error == RecoverError.InvalidSignatureS) {
150             revert("ECDSA: invalid signature 's' value");
151         } else if (error == RecoverError.InvalidSignatureV) {
152             revert("ECDSA: invalid signature 'v' value");
153         }
154     }
155 
156     /**
157      * @dev Returns the address that signed a hashed message (`hash`) with
158      * `signature` or error string. This address can then be used for verification purposes.
159      *
160      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
161      * this function rejects them by requiring the `s` value to be in the lower
162      * half order, and the `v` value to be either 27 or 28.
163      *
164      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
165      * verification to be secure: it is possible to craft signatures that
166      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
167      * this is by receiving a hash of the original message (which may otherwise
168      * be too long), and then calling {toEthSignedMessageHash} on it.
169      *
170      * Documentation for signature generation:
171      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
172      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
173      *
174      * _Available since v4.3._
175      */
176     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
177         // Check the signature length
178         // - case 65: r,s,v signature (standard)
179         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
180         if (signature.length == 65) {
181             bytes32 r;
182             bytes32 s;
183             uint8 v;
184             // ecrecover takes the signature parameters, and the only way to get them
185             // currently is to use assembly.
186             assembly {
187                 r := mload(add(signature, 0x20))
188                 s := mload(add(signature, 0x40))
189                 v := byte(0, mload(add(signature, 0x60)))
190             }
191             return tryRecover(hash, v, r, s);
192         } else if (signature.length == 64) {
193             bytes32 r;
194             bytes32 vs;
195             // ecrecover takes the signature parameters, and the only way to get them
196             // currently is to use assembly.
197             assembly {
198                 r := mload(add(signature, 0x20))
199                 vs := mload(add(signature, 0x40))
200             }
201             return tryRecover(hash, r, vs);
202         } else {
203             return (address(0), RecoverError.InvalidSignatureLength);
204         }
205     }
206 
207     /**
208      * @dev Returns the address that signed a hashed message (`hash`) with
209      * `signature`. This address can then be used for verification purposes.
210      *
211      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
212      * this function rejects them by requiring the `s` value to be in the lower
213      * half order, and the `v` value to be either 27 or 28.
214      *
215      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
216      * verification to be secure: it is possible to craft signatures that
217      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
218      * this is by receiving a hash of the original message (which may otherwise
219      * be too long), and then calling {toEthSignedMessageHash} on it.
220      */
221     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
222         (address recovered, RecoverError error) = tryRecover(hash, signature);
223         _throwError(error);
224         return recovered;
225     }
226 
227     /**
228      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
229      *
230      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
231      *
232      * _Available since v4.3._
233      */
234     function tryRecover(
235         bytes32 hash,
236         bytes32 r,
237         bytes32 vs
238     ) internal pure returns (address, RecoverError) {
239         bytes32 s;
240         uint8 v;
241         assembly {
242             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
243             v := add(shr(255, vs), 27)
244         }
245         return tryRecover(hash, v, r, s);
246     }
247 
248     /**
249      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
250      *
251      * _Available since v4.2._
252      */
253     function recover(
254         bytes32 hash,
255         bytes32 r,
256         bytes32 vs
257     ) internal pure returns (address) {
258         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
259         _throwError(error);
260         return recovered;
261     }
262 
263     /**
264      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
265      * `r` and `s` signature fields separately.
266      *
267      * _Available since v4.3._
268      */
269     function tryRecover(
270         bytes32 hash,
271         uint8 v,
272         bytes32 r,
273         bytes32 s
274     ) internal pure returns (address, RecoverError) {
275         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
276         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
277         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
278         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
279         //
280         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
281         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
282         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
283         // these malleable signatures as well.
284         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
285             return (address(0), RecoverError.InvalidSignatureS);
286         }
287         if (v != 27 && v != 28) {
288             return (address(0), RecoverError.InvalidSignatureV);
289         }
290 
291         // If the signature is valid (and not malleable), return the signer address
292         address signer = ecrecover(hash, v, r, s);
293         if (signer == address(0)) {
294             return (address(0), RecoverError.InvalidSignature);
295         }
296 
297         return (signer, RecoverError.NoError);
298     }
299 
300     /**
301      * @dev Overload of {ECDSA-recover} that receives the `v`,
302      * `r` and `s` signature fields separately.
303      */
304     function recover(
305         bytes32 hash,
306         uint8 v,
307         bytes32 r,
308         bytes32 s
309     ) internal pure returns (address) {
310         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
311         _throwError(error);
312         return recovered;
313     }
314 
315     /**
316      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
317      * produces hash corresponding to the one signed with the
318      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
319      * JSON-RPC method as part of EIP-191.
320      *
321      * See {recover}.
322      */
323     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
324         // 32 is the length in bytes of hash,
325         // enforced by the type signature above
326         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
327     }
328 
329     /**
330      * @dev Returns an Ethereum Signed Message, created from `s`. This
331      * produces hash corresponding to the one signed with the
332      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
333      * JSON-RPC method as part of EIP-191.
334      *
335      * See {recover}.
336      */
337     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
338         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
339     }
340 
341     /**
342      * @dev Returns an Ethereum Signed Typed Data, created from a
343      * `domainSeparator` and a `structHash`. This produces hash corresponding
344      * to the one signed with the
345      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
346      * JSON-RPC method as part of EIP-712.
347      *
348      * See {recover}.
349      */
350     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
351         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
352     }
353 }
354 
355 // File: @openzeppelin/contracts/utils/Context.sol
356 
357 
358 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
359 
360 pragma solidity ^0.8.0;
361 
362 /**
363  * @dev Provides information about the current execution context, including the
364  * sender of the transaction and its data. While these are generally available
365  * via msg.sender and msg.data, they should not be accessed in such a direct
366  * manner, since when dealing with meta-transactions the account sending and
367  * paying for execution may not be the actual sender (as far as an application
368  * is concerned).
369  *
370  * This contract is only required for intermediate, library-like contracts.
371  */
372 abstract contract Context {
373     function _msgSender() internal view virtual returns (address) {
374         return msg.sender;
375     }
376 
377     function _msgData() internal view virtual returns (bytes calldata) {
378         return msg.data;
379     }
380 }
381 
382 // File: @openzeppelin/contracts/access/Ownable.sol
383 
384 
385 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
386 
387 pragma solidity ^0.8.0;
388 
389 
390 /**
391  * @dev Contract module which provides a basic access control mechanism, where
392  * there is an account (an owner) that can be granted exclusive access to
393  * specific functions.
394  *
395  * By default, the owner account will be the one that deploys the contract. This
396  * can later be changed with {transferOwnership}.
397  *
398  * This module is used through inheritance. It will make available the modifier
399  * `onlyOwner`, which can be applied to your functions to restrict their use to
400  * the owner.
401  */
402 abstract contract Ownable is Context {
403     address private _owner;
404 
405     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
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
445         require(newOwner != address(0), "Ownable: new owner is the zero address");
446         _transferOwnership(newOwner);
447     }
448 
449     /**
450      * @dev Transfers ownership of the contract to a new account (`newOwner`).
451      * Internal function without access restriction.
452      */
453     function _transferOwnership(address newOwner) internal virtual {
454         address oldOwner = _owner;
455         _owner = newOwner;
456         emit OwnershipTransferred(oldOwner, newOwner);
457     }
458 }
459 
460 // File: @openzeppelin/contracts/utils/Address.sol
461 
462 
463 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
464 
465 pragma solidity ^0.8.0;
466 
467 /**
468  * @dev Collection of functions related to the address type
469  */
470 library Address {
471     /**
472      * @dev Returns true if `account` is a contract.
473      *
474      * [IMPORTANT]
475      * ====
476      * It is unsafe to assume that an address for which this function returns
477      * false is an externally-owned account (EOA) and not a contract.
478      *
479      * Among others, `isContract` will return false for the following
480      * types of addresses:
481      *
482      *  - an externally-owned account
483      *  - a contract in construction
484      *  - an address where a contract will be created
485      *  - an address where a contract lived, but was destroyed
486      * ====
487      */
488     function isContract(address account) internal view returns (bool) {
489         // This method relies on extcodesize, which returns 0 for contracts in
490         // construction, since the code is only stored at the end of the
491         // constructor execution.
492 
493         uint256 size;
494         assembly {
495             size := extcodesize(account)
496         }
497         return size > 0;
498     }
499 
500     /**
501      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
502      * `recipient`, forwarding all available gas and reverting on errors.
503      *
504      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
505      * of certain opcodes, possibly making contracts go over the 2300 gas limit
506      * imposed by `transfer`, making them unable to receive funds via
507      * `transfer`. {sendValue} removes this limitation.
508      *
509      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
510      *
511      * IMPORTANT: because control is transferred to `recipient`, care must be
512      * taken to not create reentrancy vulnerabilities. Consider using
513      * {ReentrancyGuard} or the
514      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
515      */
516     function sendValue(address payable recipient, uint256 amount) internal {
517         require(address(this).balance >= amount, "Address: insufficient balance");
518 
519         (bool success, ) = recipient.call{value: amount}("");
520         require(success, "Address: unable to send value, recipient may have reverted");
521     }
522 
523     /**
524      * @dev Performs a Solidity function call using a low level `call`. A
525      * plain `call` is an unsafe replacement for a function call: use this
526      * function instead.
527      *
528      * If `target` reverts with a revert reason, it is bubbled up by this
529      * function (like regular Solidity function calls).
530      *
531      * Returns the raw returned data. To convert to the expected return value,
532      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
533      *
534      * Requirements:
535      *
536      * - `target` must be a contract.
537      * - calling `target` with `data` must not revert.
538      *
539      * _Available since v3.1._
540      */
541     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
542         return functionCall(target, data, "Address: low-level call failed");
543     }
544 
545     /**
546      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
547      * `errorMessage` as a fallback revert reason when `target` reverts.
548      *
549      * _Available since v3.1._
550      */
551     function functionCall(
552         address target,
553         bytes memory data,
554         string memory errorMessage
555     ) internal returns (bytes memory) {
556         return functionCallWithValue(target, data, 0, errorMessage);
557     }
558 
559     /**
560      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
561      * but also transferring `value` wei to `target`.
562      *
563      * Requirements:
564      *
565      * - the calling contract must have an ETH balance of at least `value`.
566      * - the called Solidity function must be `payable`.
567      *
568      * _Available since v3.1._
569      */
570     function functionCallWithValue(
571         address target,
572         bytes memory data,
573         uint256 value
574     ) internal returns (bytes memory) {
575         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
576     }
577 
578     /**
579      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
580      * with `errorMessage` as a fallback revert reason when `target` reverts.
581      *
582      * _Available since v3.1._
583      */
584     function functionCallWithValue(
585         address target,
586         bytes memory data,
587         uint256 value,
588         string memory errorMessage
589     ) internal returns (bytes memory) {
590         require(address(this).balance >= value, "Address: insufficient balance for call");
591         require(isContract(target), "Address: call to non-contract");
592 
593         (bool success, bytes memory returndata) = target.call{value: value}(data);
594         return verifyCallResult(success, returndata, errorMessage);
595     }
596 
597     /**
598      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
599      * but performing a static call.
600      *
601      * _Available since v3.3._
602      */
603     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
604         return functionStaticCall(target, data, "Address: low-level static call failed");
605     }
606 
607     /**
608      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
609      * but performing a static call.
610      *
611      * _Available since v3.3._
612      */
613     function functionStaticCall(
614         address target,
615         bytes memory data,
616         string memory errorMessage
617     ) internal view returns (bytes memory) {
618         require(isContract(target), "Address: static call to non-contract");
619 
620         (bool success, bytes memory returndata) = target.staticcall(data);
621         return verifyCallResult(success, returndata, errorMessage);
622     }
623 
624     /**
625      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
626      * but performing a delegate call.
627      *
628      * _Available since v3.4._
629      */
630     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
631         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
632     }
633 
634     /**
635      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
636      * but performing a delegate call.
637      *
638      * _Available since v3.4._
639      */
640     function functionDelegateCall(
641         address target,
642         bytes memory data,
643         string memory errorMessage
644     ) internal returns (bytes memory) {
645         require(isContract(target), "Address: delegate call to non-contract");
646 
647         (bool success, bytes memory returndata) = target.delegatecall(data);
648         return verifyCallResult(success, returndata, errorMessage);
649     }
650 
651     /**
652      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
653      * revert reason using the provided one.
654      *
655      * _Available since v4.3._
656      */
657     function verifyCallResult(
658         bool success,
659         bytes memory returndata,
660         string memory errorMessage
661     ) internal pure returns (bytes memory) {
662         if (success) {
663             return returndata;
664         } else {
665             // Look for revert reason and bubble it up if present
666             if (returndata.length > 0) {
667                 // The easiest way to bubble the revert reason is using memory via assembly
668 
669                 assembly {
670                     let returndata_size := mload(returndata)
671                     revert(add(32, returndata), returndata_size)
672                 }
673             } else {
674                 revert(errorMessage);
675             }
676         }
677     }
678 }
679 
680 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
681 
682 
683 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
684 
685 pragma solidity ^0.8.0;
686 
687 /**
688  * @title ERC721 token receiver interface
689  * @dev Interface for any contract that wants to support safeTransfers
690  * from ERC721 asset contracts.
691  */
692 interface IERC721Receiver {
693     /**
694      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
695      * by `operator` from `from`, this function is called.
696      *
697      * It must return its Solidity selector to confirm the token transfer.
698      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
699      *
700      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
701      */
702     function onERC721Received(
703         address operator,
704         address from,
705         uint256 tokenId,
706         bytes calldata data
707     ) external returns (bytes4);
708 }
709 
710 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
711 
712 
713 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
714 
715 pragma solidity ^0.8.0;
716 
717 /**
718  * @dev Interface of the ERC165 standard, as defined in the
719  * https://eips.ethereum.org/EIPS/eip-165[EIP].
720  *
721  * Implementers can declare support of contract interfaces, which can then be
722  * queried by others ({ERC165Checker}).
723  *
724  * For an implementation, see {ERC165}.
725  */
726 interface IERC165 {
727     /**
728      * @dev Returns true if this contract implements the interface defined by
729      * `interfaceId`. See the corresponding
730      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
731      * to learn more about how these ids are created.
732      *
733      * This function call must use less than 30 000 gas.
734      */
735     function supportsInterface(bytes4 interfaceId) external view returns (bool);
736 }
737 
738 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
739 
740 
741 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
742 
743 pragma solidity ^0.8.0;
744 
745 
746 /**
747  * @dev Implementation of the {IERC165} interface.
748  *
749  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
750  * for the additional interface id that will be supported. For example:
751  *
752  * ```solidity
753  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
754  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
755  * }
756  * ```
757  *
758  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
759  */
760 abstract contract ERC165 is IERC165 {
761     /**
762      * @dev See {IERC165-supportsInterface}.
763      */
764     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
765         return interfaceId == type(IERC165).interfaceId;
766     }
767 }
768 
769 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
770 
771 
772 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
773 
774 pragma solidity ^0.8.0;
775 
776 
777 /**
778  * @dev Required interface of an ERC721 compliant contract.
779  */
780 interface IERC721 is IERC165 {
781     /**
782      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
783      */
784     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
785 
786     /**
787      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
788      */
789     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
790 
791     /**
792      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
793      */
794     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
795 
796     /**
797      * @dev Returns the number of tokens in ``owner``'s account.
798      */
799     function balanceOf(address owner) external view returns (uint256 balance);
800 
801     /**
802      * @dev Returns the owner of the `tokenId` token.
803      *
804      * Requirements:
805      *
806      * - `tokenId` must exist.
807      */
808     function ownerOf(uint256 tokenId) external view returns (address owner);
809 
810     /**
811      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
812      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
813      *
814      * Requirements:
815      *
816      * - `from` cannot be the zero address.
817      * - `to` cannot be the zero address.
818      * - `tokenId` token must exist and be owned by `from`.
819      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
820      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
821      *
822      * Emits a {Transfer} event.
823      */
824     function safeTransferFrom(
825         address from,
826         address to,
827         uint256 tokenId
828     ) external;
829 
830     /**
831      * @dev Transfers `tokenId` token from `from` to `to`.
832      *
833      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
834      *
835      * Requirements:
836      *
837      * - `from` cannot be the zero address.
838      * - `to` cannot be the zero address.
839      * - `tokenId` token must be owned by `from`.
840      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
841      *
842      * Emits a {Transfer} event.
843      */
844     function transferFrom(
845         address from,
846         address to,
847         uint256 tokenId
848     ) external;
849 
850     /**
851      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
852      * The approval is cleared when the token is transferred.
853      *
854      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
855      *
856      * Requirements:
857      *
858      * - The caller must own the token or be an approved operator.
859      * - `tokenId` must exist.
860      *
861      * Emits an {Approval} event.
862      */
863     function approve(address to, uint256 tokenId) external;
864 
865     /**
866      * @dev Returns the account approved for `tokenId` token.
867      *
868      * Requirements:
869      *
870      * - `tokenId` must exist.
871      */
872     function getApproved(uint256 tokenId) external view returns (address operator);
873 
874     /**
875      * @dev Approve or remove `operator` as an operator for the caller.
876      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
877      *
878      * Requirements:
879      *
880      * - The `operator` cannot be the caller.
881      *
882      * Emits an {ApprovalForAll} event.
883      */
884     function setApprovalForAll(address operator, bool _approved) external;
885 
886     /**
887      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
888      *
889      * See {setApprovalForAll}
890      */
891     function isApprovedForAll(address owner, address operator) external view returns (bool);
892 
893     /**
894      * @dev Safely transfers `tokenId` token from `from` to `to`.
895      *
896      * Requirements:
897      *
898      * - `from` cannot be the zero address.
899      * - `to` cannot be the zero address.
900      * - `tokenId` token must exist and be owned by `from`.
901      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
902      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
903      *
904      * Emits a {Transfer} event.
905      */
906     function safeTransferFrom(
907         address from,
908         address to,
909         uint256 tokenId,
910         bytes calldata data
911     ) external;
912 }
913 
914 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
915 
916 
917 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
918 
919 pragma solidity ^0.8.0;
920 
921 
922 /**
923  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
924  * @dev See https://eips.ethereum.org/EIPS/eip-721
925  */
926 interface IERC721Metadata is IERC721 {
927     /**
928      * @dev Returns the token collection name.
929      */
930     function name() external view returns (string memory);
931 
932     /**
933      * @dev Returns the token collection symbol.
934      */
935     function symbol() external view returns (string memory);
936 
937     /**
938      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
939      */
940     function tokenURI(uint256 tokenId) external view returns (string memory);
941 }
942 
943 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
944 
945 
946 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
947 
948 pragma solidity ^0.8.0;
949 
950 
951 
952 
953 
954 
955 
956 
957 /**
958  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
959  * the Metadata extension, but not including the Enumerable extension, which is available separately as
960  * {ERC721Enumerable}.
961  */
962 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
963     using Address for address;
964     using Strings for uint256;
965 
966     // Token name
967     string private _name;
968 
969     // Token symbol
970     string private _symbol;
971 
972     // Mapping from token ID to owner address
973     mapping(uint256 => address) private _owners;
974 
975     // Mapping owner address to token count
976     mapping(address => uint256) private _balances;
977 
978     // Mapping from token ID to approved address
979     mapping(uint256 => address) private _tokenApprovals;
980 
981     // Mapping from owner to operator approvals
982     mapping(address => mapping(address => bool)) private _operatorApprovals;
983 
984     /**
985      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
986      */
987     constructor(string memory name_, string memory symbol_) {
988         _name = name_;
989         _symbol = symbol_;
990     }
991 
992     /**
993      * @dev See {IERC165-supportsInterface}.
994      */
995     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
996         return
997             interfaceId == type(IERC721).interfaceId ||
998             interfaceId == type(IERC721Metadata).interfaceId ||
999             super.supportsInterface(interfaceId);
1000     }
1001 
1002     /**
1003      * @dev See {IERC721-balanceOf}.
1004      */
1005     function balanceOf(address owner) public view virtual override returns (uint256) {
1006         require(owner != address(0), "ERC721: balance query for the zero address");
1007         return _balances[owner];
1008     }
1009 
1010     /**
1011      * @dev See {IERC721-ownerOf}.
1012      */
1013     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1014         address owner = _owners[tokenId];
1015         require(owner != address(0), "ERC721: owner query for nonexistent token");
1016         return owner;
1017     }
1018 
1019     /**
1020      * @dev See {IERC721Metadata-name}.
1021      */
1022     function name() public view virtual override returns (string memory) {
1023         return _name;
1024     }
1025 
1026     /**
1027      * @dev See {IERC721Metadata-symbol}.
1028      */
1029     function symbol() public view virtual override returns (string memory) {
1030         return _symbol;
1031     }
1032 
1033     /**
1034      * @dev See {IERC721Metadata-tokenURI}.
1035      */
1036     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1037         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1038 
1039         string memory baseURI = _baseURI();
1040         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1041     }
1042 
1043     /**
1044      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1045      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1046      * by default, can be overriden in child contracts.
1047      */
1048     function _baseURI() internal view virtual returns (string memory) {
1049         return "";
1050     }
1051 
1052     /**
1053      * @dev See {IERC721-approve}.
1054      */
1055     function approve(address to, uint256 tokenId) public virtual override {
1056         address owner = ERC721.ownerOf(tokenId);
1057         require(to != owner, "ERC721: approval to current owner");
1058 
1059         require(
1060             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1061             "ERC721: approve caller is not owner nor approved for all"
1062         );
1063 
1064         _approve(to, tokenId);
1065     }
1066 
1067     /**
1068      * @dev See {IERC721-getApproved}.
1069      */
1070     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1071         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1072 
1073         return _tokenApprovals[tokenId];
1074     }
1075 
1076     /**
1077      * @dev See {IERC721-setApprovalForAll}.
1078      */
1079     function setApprovalForAll(address operator, bool approved) public virtual override {
1080         _setApprovalForAll(_msgSender(), operator, approved);
1081     }
1082 
1083     /**
1084      * @dev See {IERC721-isApprovedForAll}.
1085      */
1086     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1087         return _operatorApprovals[owner][operator];
1088     }
1089 
1090     /**
1091      * @dev See {IERC721-transferFrom}.
1092      */
1093     function transferFrom(
1094         address from,
1095         address to,
1096         uint256 tokenId
1097     ) public virtual override {
1098         //solhint-disable-next-line max-line-length
1099         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1100 
1101         _transfer(from, to, tokenId);
1102     }
1103 
1104     /**
1105      * @dev See {IERC721-safeTransferFrom}.
1106      */
1107     function safeTransferFrom(
1108         address from,
1109         address to,
1110         uint256 tokenId
1111     ) public virtual override {
1112         safeTransferFrom(from, to, tokenId, "");
1113     }
1114 
1115     /**
1116      * @dev See {IERC721-safeTransferFrom}.
1117      */
1118     function safeTransferFrom(
1119         address from,
1120         address to,
1121         uint256 tokenId,
1122         bytes memory _data
1123     ) public virtual override {
1124         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1125         _safeTransfer(from, to, tokenId, _data);
1126     }
1127 
1128     /**
1129      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1130      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1131      *
1132      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1133      *
1134      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1135      * implement alternative mechanisms to perform token transfer, such as signature-based.
1136      *
1137      * Requirements:
1138      *
1139      * - `from` cannot be the zero address.
1140      * - `to` cannot be the zero address.
1141      * - `tokenId` token must exist and be owned by `from`.
1142      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1143      *
1144      * Emits a {Transfer} event.
1145      */
1146     function _safeTransfer(
1147         address from,
1148         address to,
1149         uint256 tokenId,
1150         bytes memory _data
1151     ) internal virtual {
1152         _transfer(from, to, tokenId);
1153         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1154     }
1155 
1156     /**
1157      * @dev Returns whether `tokenId` exists.
1158      *
1159      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1160      *
1161      * Tokens start existing when they are minted (`_mint`),
1162      * and stop existing when they are burned (`_burn`).
1163      */
1164     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1165         return _owners[tokenId] != address(0);
1166     }
1167 
1168     /**
1169      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1170      *
1171      * Requirements:
1172      *
1173      * - `tokenId` must exist.
1174      */
1175     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1176         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1177         address owner = ERC721.ownerOf(tokenId);
1178         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1179     }
1180 
1181     /**
1182      * @dev Safely mints `tokenId` and transfers it to `to`.
1183      *
1184      * Requirements:
1185      *
1186      * - `tokenId` must not exist.
1187      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1188      *
1189      * Emits a {Transfer} event.
1190      */
1191     function _safeMint(address to, uint256 tokenId) internal virtual {
1192         _safeMint(to, tokenId, "");
1193     }
1194 
1195     /**
1196      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1197      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1198      */
1199     function _safeMint(
1200         address to,
1201         uint256 tokenId,
1202         bytes memory _data
1203     ) internal virtual {
1204         _mint(to, tokenId);
1205         require(
1206             _checkOnERC721Received(address(0), to, tokenId, _data),
1207             "ERC721: transfer to non ERC721Receiver implementer"
1208         );
1209     }
1210 
1211     /**
1212      * @dev Mints `tokenId` and transfers it to `to`.
1213      *
1214      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1215      *
1216      * Requirements:
1217      *
1218      * - `tokenId` must not exist.
1219      * - `to` cannot be the zero address.
1220      *
1221      * Emits a {Transfer} event.
1222      */
1223     function _mint(address to, uint256 tokenId) internal virtual {
1224         require(to != address(0), "ERC721: mint to the zero address");
1225         require(!_exists(tokenId), "ERC721: token already minted");
1226 
1227         _beforeTokenTransfer(address(0), to, tokenId);
1228 
1229         _balances[to] += 1;
1230         _owners[tokenId] = to;
1231 
1232         emit Transfer(address(0), to, tokenId);
1233     }
1234 
1235     /**
1236      * @dev Destroys `tokenId`.
1237      * The approval is cleared when the token is burned.
1238      *
1239      * Requirements:
1240      *
1241      * - `tokenId` must exist.
1242      *
1243      * Emits a {Transfer} event.
1244      */
1245     function _burn(uint256 tokenId) internal virtual {
1246         address owner = ERC721.ownerOf(tokenId);
1247 
1248         _beforeTokenTransfer(owner, address(0), tokenId);
1249 
1250         // Clear approvals
1251         _approve(address(0), tokenId);
1252 
1253         _balances[owner] -= 1;
1254         delete _owners[tokenId];
1255 
1256         emit Transfer(owner, address(0), tokenId);
1257     }
1258 
1259     /**
1260      * @dev Transfers `tokenId` from `from` to `to`.
1261      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1262      *
1263      * Requirements:
1264      *
1265      * - `to` cannot be the zero address.
1266      * - `tokenId` token must be owned by `from`.
1267      *
1268      * Emits a {Transfer} event.
1269      */
1270     function _transfer(
1271         address from,
1272         address to,
1273         uint256 tokenId
1274     ) internal virtual {
1275         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1276         require(to != address(0), "ERC721: transfer to the zero address");
1277 
1278         _beforeTokenTransfer(from, to, tokenId);
1279 
1280         // Clear approvals from the previous owner
1281         _approve(address(0), tokenId);
1282 
1283         _balances[from] -= 1;
1284         _balances[to] += 1;
1285         _owners[tokenId] = to;
1286 
1287         emit Transfer(from, to, tokenId);
1288     }
1289 
1290     /**
1291      * @dev Approve `to` to operate on `tokenId`
1292      *
1293      * Emits a {Approval} event.
1294      */
1295     function _approve(address to, uint256 tokenId) internal virtual {
1296         _tokenApprovals[tokenId] = to;
1297         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1298     }
1299 
1300     /**
1301      * @dev Approve `operator` to operate on all of `owner` tokens
1302      *
1303      * Emits a {ApprovalForAll} event.
1304      */
1305     function _setApprovalForAll(
1306         address owner,
1307         address operator,
1308         bool approved
1309     ) internal virtual {
1310         require(owner != operator, "ERC721: approve to caller");
1311         _operatorApprovals[owner][operator] = approved;
1312         emit ApprovalForAll(owner, operator, approved);
1313     }
1314 
1315     /**
1316      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1317      * The call is not executed if the target address is not a contract.
1318      *
1319      * @param from address representing the previous owner of the given token ID
1320      * @param to target address that will receive the tokens
1321      * @param tokenId uint256 ID of the token to be transferred
1322      * @param _data bytes optional data to send along with the call
1323      * @return bool whether the call correctly returned the expected magic value
1324      */
1325     function _checkOnERC721Received(
1326         address from,
1327         address to,
1328         uint256 tokenId,
1329         bytes memory _data
1330     ) private returns (bool) {
1331         if (to.isContract()) {
1332             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1333                 return retval == IERC721Receiver.onERC721Received.selector;
1334             } catch (bytes memory reason) {
1335                 if (reason.length == 0) {
1336                     revert("ERC721: transfer to non ERC721Receiver implementer");
1337                 } else {
1338                     assembly {
1339                         revert(add(32, reason), mload(reason))
1340                     }
1341                 }
1342             }
1343         } else {
1344             return true;
1345         }
1346     }
1347 
1348     /**
1349      * @dev Hook that is called before any token transfer. This includes minting
1350      * and burning.
1351      *
1352      * Calling conditions:
1353      *
1354      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1355      * transferred to `to`.
1356      * - When `from` is zero, `tokenId` will be minted for `to`.
1357      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1358      * - `from` and `to` are never both zero.
1359      *
1360      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1361      */
1362     function _beforeTokenTransfer(
1363         address from,
1364         address to,
1365         uint256 tokenId
1366     ) internal virtual {}
1367 }
1368 
1369 // File: CryptoDocs.sol
1370 
1371 
1372 
1373 pragma solidity ^0.8.0;
1374 
1375 
1376 
1377 
1378 
1379 
1380 contract CryptoDocs is ERC721, Ownable {
1381   
1382   using ECDSA for bytes32;
1383   using Strings for uint256;
1384   using  Counters for Counters.Counter;
1385 
1386   Counters.Counter private supply;
1387 
1388   string private baseURI;
1389   string private baseExtension;
1390   string private RevealedUri;
1391   address[] private Twallets;
1392   uint256 public presaleCost = 0.1 ether;
1393   uint256 public cost = 0.15 ether;
1394   uint256 public maxSupply = 10000;
1395   uint256 public prSupply = 1000;
1396   uint256 public maxMintable = maxSupply-prSupply;
1397   uint256 public maxMintAmountPerTx = 5;
1398   bool public paused = true;
1399   bool public revealed = false;
1400   bool public presaleActive = true; 
1401   mapping(address => uint256) public addressMintedBalance;
1402   address public signerAddress = 0x7E4723A50108AC20CBE09cD9F656bd065f5B42c8; 
1403 
1404   constructor(
1405     string memory _name,
1406     string memory _symbol,
1407     string memory _initBaseURI,
1408     string memory _initRevealedUri
1409   ) ERC721(_name, _symbol) {
1410     setBaseURI(_initBaseURI);
1411     setRevealedURI(_initRevealedUri);
1412   }
1413 
1414   function _baseURI() internal view virtual override returns (string memory) {
1415     return baseURI;
1416   }
1417 
1418   
1419   modifier mintCompliance(uint256 _mintAmount) {
1420     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1421     require(supply.current() + _mintAmount <= maxMintable, "This tx would exceed max supply");
1422     _;
1423   }
1424 
1425   function totalSupply() public view returns (uint256) {
1426     return supply.current();
1427   }
1428 
1429 
1430   // Mint-Presale and Public
1431 
1432   function premint(uint256 _mintAmount, bytes calldata _signature) public payable mintCompliance(_mintAmount) {
1433     require(!paused, "the contract is paused");
1434     require(presaleActive, "Presale is not Active!");
1435     require(msg.value == presaleCost * _mintAmount, "Balance too low");
1436     require(_verify(_signature), "bad signature");
1437         
1438     
1439         _mintLoop(msg.sender, _mintAmount);
1440     }
1441 
1442   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) { 
1443     require(!paused, "the contract is paused");
1444     require(!presaleActive, "Presale is still active");
1445     require(msg.value == cost * _mintAmount, "Balance too low");
1446         
1447         _mintLoop(msg.sender, _mintAmount);
1448   
1449     }
1450     
1451 
1452   function _hash(address _address) internal view returns (bytes32) {
1453         return keccak256(abi.encode(address(this),_address)).toEthSignedMessageHash();
1454   }
1455 
1456   function _verify( bytes memory signature) internal view returns (bool) {
1457         return (_hash(msg.sender).recover(signature) == signerAddress);
1458   }
1459 
1460    function mintForPRAddress(uint256 _mintAmount, address _receiver) public onlyOwner {
1461         require(supply.current() + _mintAmount <= maxSupply);
1462         _mintLoop(_receiver, _mintAmount);
1463     }
1464 
1465 
1466    function walletOfOwner(address _owner)
1467     public
1468     view
1469     returns (uint256[] memory)
1470   {
1471     uint256 ownerTokenCount = balanceOf(_owner);
1472     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1473     uint256 currentTokenId = 1;
1474     uint256 ownedTokenIndex = 0;
1475 
1476     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1477       address currentTokenOwner = ownerOf(currentTokenId);
1478 
1479       if (currentTokenOwner == _owner) {
1480         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1481 
1482         ownedTokenIndex++;
1483       }
1484 
1485       currentTokenId++;
1486     }
1487 
1488     return ownedTokenIds;
1489   }
1490 
1491   function tokenURI(uint256 tokenId)
1492     public
1493     view
1494     virtual
1495     override
1496     returns (string memory)
1497     {
1498     require(
1499       _exists(tokenId),
1500       "ERC721Metadata: URI query for nonexistent token"
1501     );
1502     
1503     if(revealed == false) {
1504         return RevealedUri;
1505     }
1506 
1507     string memory currentBaseURI = _baseURI();
1508     return bytes(currentBaseURI).length > 0
1509         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1510         : "";
1511     }
1512 
1513 
1514   //owner commands only
1515   function reveal() public onlyOwner {
1516       revealed = true;
1517   }
1518 
1519   function setSignerAddress(address signer) external onlyOwner {
1520         signerAddress = signer;
1521   }
1522   
1523   function setpresaleCost(uint256 _newpreCost) public onlyOwner {
1524     presaleCost = _newpreCost;
1525   }
1526 
1527   function setPublicCost(uint256 _newCost) public onlyOwner {
1528     cost = _newCost;
1529   }
1530 
1531   function setmaxMintAmount(uint256 _newmaxMintAmountPerTx) public onlyOwner {
1532     maxMintAmountPerTx = _newmaxMintAmountPerTx;
1533   }
1534 
1535   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1536     baseURI = _newBaseURI;
1537   }
1538 
1539   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1540     baseExtension = _newBaseExtension;
1541   }
1542   
1543   function setRevealedURI(string memory _RevealedURI) public onlyOwner {
1544     RevealedUri = _RevealedURI;
1545   }
1546 
1547   function pause(bool _state) public onlyOwner {
1548     paused = _state;
1549   }
1550 
1551   function setpreSale(bool _state) public onlyOwner {
1552     presaleActive = _state;
1553   }
1554   
1555   function setTwallets(address[] calldata _devwallets) public onlyOwner {
1556       delete Twallets;
1557       Twallets = _devwallets;
1558   }
1559 
1560   function getBalance() public view onlyOwner returns (uint256) {
1561         return address(this).balance;
1562     }
1563 
1564   function withdraw() public onlyOwner {
1565         payable(msg.sender).transfer(address(this).balance);
1566     }
1567  
1568   function withdrawl1() public payable onlyOwner {
1569     // Do the splits here!
1570 
1571     uint256 withdrawalBalance = address(this).balance;
1572 
1573     (bool hs, ) = payable(Twallets[0]).call{value:  withdrawalBalance * 6200 / 10000}("");
1574     require(hs);
1575     (bool bs, ) = payable(Twallets[1]).call{value:  withdrawalBalance * 1200 / 10000}("");
1576     require(bs);
1577     (bool cs, ) = payable(Twallets[2]).call{value:  withdrawalBalance * 500 / 10000}("");
1578     require(cs);
1579     (bool es, ) = payable(Twallets[3]).call{value:  withdrawalBalance * 300 / 10000}("");
1580     require(es);
1581     (bool ds, ) = payable(Twallets[4]).call{value:  withdrawalBalance * 300 / 10000}("");
1582     require(ds);
1583     (bool ss, ) = payable(Twallets[5]).call{value:  withdrawalBalance * 300 / 10000}("");
1584     require(ss);
1585     (bool qs, ) = payable(Twallets[6]).call{value:  withdrawalBalance * 250 / 10000}("");
1586     require(qs);
1587     (bool zs, ) = payable(Twallets[7]).call{value:  withdrawalBalance * 200 / 10000}("");
1588     require(zs);
1589     (bool ps, ) = payable(Twallets[8]).call{value:  withdrawalBalance * 100 / 10000}("");
1590     require(ps);
1591     (bool ts, ) = payable(Twallets[9]).call{value:  withdrawalBalance * 100 / 10000}("");
1592     require(ts);
1593     (bool ys, ) = payable(Twallets[10]).call{value:  withdrawalBalance * 100 / 10000}("");
1594     require(ys);
1595     (bool ws, ) = payable(Twallets[11]).call{value:  withdrawalBalance * 25 / 10000}("");
1596     require(ws);
1597     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1598     require(os);
1599   }
1600 
1601    function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1602     for (uint256 i = 0; i < _mintAmount; i++) {
1603       supply.increment();
1604       _safeMint(_receiver, supply.current());
1605     }
1606   }
1607 }