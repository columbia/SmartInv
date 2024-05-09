1 // File: @openzeppelin/contracts/utils/Counters.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @title Counters
10  * @author Matt Condon (@shrugs)
11  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
12  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
13  *
14  * Include with `using Counters for Counters.Counter;`
15  */
16 library Counters {
17     struct Counter {
18         // This variable should never be directly accessed by users of the library: interactions must be restricted to
19         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
20         // this feature: see https://github.com/ethereum/solidity/issues/4637
21         uint256 _value; // default: 0
22     }
23 
24     function current(Counter storage counter) internal view returns (uint256) {
25         return counter._value;
26     }
27 
28     function increment(Counter storage counter) internal {
29         unchecked {
30             counter._value += 1;
31         }
32     }
33 
34     function decrement(Counter storage counter) internal {
35         uint256 value = counter._value;
36         require(value > 0, "Counter: decrement overflow");
37         unchecked {
38             counter._value = value - 1;
39         }
40     }
41 
42     function reset(Counter storage counter) internal {
43         counter._value = 0;
44     }
45 }
46 
47 // File: @openzeppelin/contracts/utils/Strings.sol
48 
49 
50 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
51 
52 pragma solidity ^0.8.0;
53 
54 /**
55  * @dev String operations.
56  */
57 library Strings {
58     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
59 
60     /**
61      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
62      */
63     function toString(uint256 value) internal pure returns (string memory) {
64         // Inspired by OraclizeAPI's implementation - MIT licence
65         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
66 
67         if (value == 0) {
68             return "0";
69         }
70         uint256 temp = value;
71         uint256 digits;
72         while (temp != 0) {
73             digits++;
74             temp /= 10;
75         }
76         bytes memory buffer = new bytes(digits);
77         while (value != 0) {
78             digits -= 1;
79             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
80             value /= 10;
81         }
82         return string(buffer);
83     }
84 
85     /**
86      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
87      */
88     function toHexString(uint256 value) internal pure returns (string memory) {
89         if (value == 0) {
90             return "0x00";
91         }
92         uint256 temp = value;
93         uint256 length = 0;
94         while (temp != 0) {
95             length++;
96             temp >>= 8;
97         }
98         return toHexString(value, length);
99     }
100 
101     /**
102      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
103      */
104     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
105         bytes memory buffer = new bytes(2 * length + 2);
106         buffer[0] = "0";
107         buffer[1] = "x";
108         for (uint256 i = 2 * length + 1; i > 1; --i) {
109             buffer[i] = _HEX_SYMBOLS[value & 0xf];
110             value >>= 4;
111         }
112         require(value == 0, "Strings: hex length insufficient");
113         return string(buffer);
114     }
115 }
116 
117 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
118 
119 
120 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/ECDSA.sol)
121 
122 pragma solidity ^0.8.0;
123 
124 
125 /**
126  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
127  *
128  * These functions can be used to verify that a message was signed by the holder
129  * of the private keys of a given address.
130  */
131 library ECDSA {
132     enum RecoverError {
133         NoError,
134         InvalidSignature,
135         InvalidSignatureLength,
136         InvalidSignatureS,
137         InvalidSignatureV
138     }
139 
140     function _throwError(RecoverError error) private pure {
141         if (error == RecoverError.NoError) {
142             return; // no error: do nothing
143         } else if (error == RecoverError.InvalidSignature) {
144             revert("ECDSA: invalid signature");
145         } else if (error == RecoverError.InvalidSignatureLength) {
146             revert("ECDSA: invalid signature length");
147         } else if (error == RecoverError.InvalidSignatureS) {
148             revert("ECDSA: invalid signature 's' value");
149         } else if (error == RecoverError.InvalidSignatureV) {
150             revert("ECDSA: invalid signature 'v' value");
151         }
152     }
153 
154     /**
155      * @dev Returns the address that signed a hashed message (`hash`) with
156      * `signature` or error string. This address can then be used for verification purposes.
157      *
158      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
159      * this function rejects them by requiring the `s` value to be in the lower
160      * half order, and the `v` value to be either 27 or 28.
161      *
162      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
163      * verification to be secure: it is possible to craft signatures that
164      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
165      * this is by receiving a hash of the original message (which may otherwise
166      * be too long), and then calling {toEthSignedMessageHash} on it.
167      *
168      * Documentation for signature generation:
169      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
170      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
171      *
172      * _Available since v4.3._
173      */
174     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
175         // Check the signature length
176         // - case 65: r,s,v signature (standard)
177         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
178         if (signature.length == 65) {
179             bytes32 r;
180             bytes32 s;
181             uint8 v;
182             // ecrecover takes the signature parameters, and the only way to get them
183             // currently is to use assembly.
184             assembly {
185                 r := mload(add(signature, 0x20))
186                 s := mload(add(signature, 0x40))
187                 v := byte(0, mload(add(signature, 0x60)))
188             }
189             return tryRecover(hash, v, r, s);
190         } else if (signature.length == 64) {
191             bytes32 r;
192             bytes32 vs;
193             // ecrecover takes the signature parameters, and the only way to get them
194             // currently is to use assembly.
195             assembly {
196                 r := mload(add(signature, 0x20))
197                 vs := mload(add(signature, 0x40))
198             }
199             return tryRecover(hash, r, vs);
200         } else {
201             return (address(0), RecoverError.InvalidSignatureLength);
202         }
203     }
204 
205     /**
206      * @dev Returns the address that signed a hashed message (`hash`) with
207      * `signature`. This address can then be used for verification purposes.
208      *
209      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
210      * this function rejects them by requiring the `s` value to be in the lower
211      * half order, and the `v` value to be either 27 or 28.
212      *
213      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
214      * verification to be secure: it is possible to craft signatures that
215      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
216      * this is by receiving a hash of the original message (which may otherwise
217      * be too long), and then calling {toEthSignedMessageHash} on it.
218      */
219     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
220         (address recovered, RecoverError error) = tryRecover(hash, signature);
221         _throwError(error);
222         return recovered;
223     }
224 
225     /**
226      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
227      *
228      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
229      *
230      * _Available since v4.3._
231      */
232     function tryRecover(
233         bytes32 hash,
234         bytes32 r,
235         bytes32 vs
236     ) internal pure returns (address, RecoverError) {
237         bytes32 s;
238         uint8 v;
239         assembly {
240             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
241             v := add(shr(255, vs), 27)
242         }
243         return tryRecover(hash, v, r, s);
244     }
245 
246     /**
247      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
248      *
249      * _Available since v4.2._
250      */
251     function recover(
252         bytes32 hash,
253         bytes32 r,
254         bytes32 vs
255     ) internal pure returns (address) {
256         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
257         _throwError(error);
258         return recovered;
259     }
260 
261     /**
262      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
263      * `r` and `s` signature fields separately.
264      *
265      * _Available since v4.3._
266      */
267     function tryRecover(
268         bytes32 hash,
269         uint8 v,
270         bytes32 r,
271         bytes32 s
272     ) internal pure returns (address, RecoverError) {
273         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
274         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
275         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
276         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
277         //
278         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
279         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
280         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
281         // these malleable signatures as well.
282         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
283             return (address(0), RecoverError.InvalidSignatureS);
284         }
285         if (v != 27 && v != 28) {
286             return (address(0), RecoverError.InvalidSignatureV);
287         }
288 
289         // If the signature is valid (and not malleable), return the signer address
290         address signer = ecrecover(hash, v, r, s);
291         if (signer == address(0)) {
292             return (address(0), RecoverError.InvalidSignature);
293         }
294 
295         return (signer, RecoverError.NoError);
296     }
297 
298     /**
299      * @dev Overload of {ECDSA-recover} that receives the `v`,
300      * `r` and `s` signature fields separately.
301      */
302     function recover(
303         bytes32 hash,
304         uint8 v,
305         bytes32 r,
306         bytes32 s
307     ) internal pure returns (address) {
308         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
309         _throwError(error);
310         return recovered;
311     }
312 
313     /**
314      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
315      * produces hash corresponding to the one signed with the
316      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
317      * JSON-RPC method as part of EIP-191.
318      *
319      * See {recover}.
320      */
321     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
322         // 32 is the length in bytes of hash,
323         // enforced by the type signature above
324         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
325     }
326 
327     /**
328      * @dev Returns an Ethereum Signed Message, created from `s`. This
329      * produces hash corresponding to the one signed with the
330      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
331      * JSON-RPC method as part of EIP-191.
332      *
333      * See {recover}.
334      */
335     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
336         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
337     }
338 
339     /**
340      * @dev Returns an Ethereum Signed Typed Data, created from a
341      * `domainSeparator` and a `structHash`. This produces hash corresponding
342      * to the one signed with the
343      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
344      * JSON-RPC method as part of EIP-712.
345      *
346      * See {recover}.
347      */
348     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
349         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
350     }
351 }
352 
353 // File: @openzeppelin/contracts/utils/Context.sol
354 
355 
356 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
357 
358 pragma solidity ^0.8.0;
359 
360 /**
361  * @dev Provides information about the current execution context, including the
362  * sender of the transaction and its data. While these are generally available
363  * via msg.sender and msg.data, they should not be accessed in such a direct
364  * manner, since when dealing with meta-transactions the account sending and
365  * paying for execution may not be the actual sender (as far as an application
366  * is concerned).
367  *
368  * This contract is only required for intermediate, library-like contracts.
369  */
370 abstract contract Context {
371     function _msgSender() internal view virtual returns (address) {
372         return msg.sender;
373     }
374 
375     function _msgData() internal view virtual returns (bytes calldata) {
376         return msg.data;
377     }
378 }
379 
380 // File: @openzeppelin/contracts/access/Ownable.sol
381 
382 
383 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
384 
385 pragma solidity ^0.8.0;
386 
387 
388 /**
389  * @dev Contract module which provides a basic access control mechanism, where
390  * there is an account (an owner) that can be granted exclusive access to
391  * specific functions.
392  *
393  * By default, the owner account will be the one that deploys the contract. This
394  * can later be changed with {transferOwnership}.
395  *
396  * This module is used through inheritance. It will make available the modifier
397  * `onlyOwner`, which can be applied to your functions to restrict their use to
398  * the owner.
399  */
400 abstract contract Ownable is Context {
401     address private _owner;
402 
403     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
404 
405     /**
406      * @dev Initializes the contract setting the deployer as the initial owner.
407      */
408     constructor() {
409         _transferOwnership(_msgSender());
410     }
411 
412     /**
413      * @dev Returns the address of the current owner.
414      */
415     function owner() public view virtual returns (address) {
416         return _owner;
417     }
418 
419     /**
420      * @dev Throws if called by any account other than the owner.
421      */
422     modifier onlyOwner() {
423         require(owner() == _msgSender(), "Ownable: caller is not the owner");
424         _;
425     }
426 
427     /**
428      * @dev Leaves the contract without owner. It will not be possible to call
429      * `onlyOwner` functions anymore. Can only be called by the current owner.
430      *
431      * NOTE: Renouncing ownership will leave the contract without an owner,
432      * thereby removing any functionality that is only available to the owner.
433      */
434     function renounceOwnership() public virtual onlyOwner {
435         _transferOwnership(address(0));
436     }
437 
438     /**
439      * @dev Transfers ownership of the contract to a new account (`newOwner`).
440      * Can only be called by the current owner.
441      */
442     function transferOwnership(address newOwner) public virtual onlyOwner {
443         require(newOwner != address(0), "Ownable: new owner is the zero address");
444         _transferOwnership(newOwner);
445     }
446 
447     /**
448      * @dev Transfers ownership of the contract to a new account (`newOwner`).
449      * Internal function without access restriction.
450      */
451     function _transferOwnership(address newOwner) internal virtual {
452         address oldOwner = _owner;
453         _owner = newOwner;
454         emit OwnershipTransferred(oldOwner, newOwner);
455     }
456 }
457 
458 // File: @openzeppelin/contracts/utils/Address.sol
459 
460 
461 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
462 
463 pragma solidity ^0.8.0;
464 
465 /**
466  * @dev Collection of functions related to the address type
467  */
468 library Address {
469     /**
470      * @dev Returns true if `account` is a contract.
471      *
472      * [IMPORTANT]
473      * ====
474      * It is unsafe to assume that an address for which this function returns
475      * false is an externally-owned account (EOA) and not a contract.
476      *
477      * Among others, `isContract` will return false for the following
478      * types of addresses:
479      *
480      *  - an externally-owned account
481      *  - a contract in construction
482      *  - an address where a contract will be created
483      *  - an address where a contract lived, but was destroyed
484      * ====
485      */
486     function isContract(address account) internal view returns (bool) {
487         // This method relies on extcodesize, which returns 0 for contracts in
488         // construction, since the code is only stored at the end of the
489         // constructor execution.
490 
491         uint256 size;
492         assembly {
493             size := extcodesize(account)
494         }
495         return size > 0;
496     }
497 
498     /**
499      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
500      * `recipient`, forwarding all available gas and reverting on errors.
501      *
502      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
503      * of certain opcodes, possibly making contracts go over the 2300 gas limit
504      * imposed by `transfer`, making them unable to receive funds via
505      * `transfer`. {sendValue} removes this limitation.
506      *
507      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
508      *
509      * IMPORTANT: because control is transferred to `recipient`, care must be
510      * taken to not create reentrancy vulnerabilities. Consider using
511      * {ReentrancyGuard} or the
512      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
513      */
514     function sendValue(address payable recipient, uint256 amount) internal {
515         require(address(this).balance >= amount, "Address: insufficient balance");
516 
517         (bool success, ) = recipient.call{value: amount}("");
518         require(success, "Address: unable to send value, recipient may have reverted");
519     }
520 
521     /**
522      * @dev Performs a Solidity function call using a low level `call`. A
523      * plain `call` is an unsafe replacement for a function call: use this
524      * function instead.
525      *
526      * If `target` reverts with a revert reason, it is bubbled up by this
527      * function (like regular Solidity function calls).
528      *
529      * Returns the raw returned data. To convert to the expected return value,
530      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
531      *
532      * Requirements:
533      *
534      * - `target` must be a contract.
535      * - calling `target` with `data` must not revert.
536      *
537      * _Available since v3.1._
538      */
539     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
540         return functionCall(target, data, "Address: low-level call failed");
541     }
542 
543     /**
544      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
545      * `errorMessage` as a fallback revert reason when `target` reverts.
546      *
547      * _Available since v3.1._
548      */
549     function functionCall(
550         address target,
551         bytes memory data,
552         string memory errorMessage
553     ) internal returns (bytes memory) {
554         return functionCallWithValue(target, data, 0, errorMessage);
555     }
556 
557     /**
558      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
559      * but also transferring `value` wei to `target`.
560      *
561      * Requirements:
562      *
563      * - the calling contract must have an ETH balance of at least `value`.
564      * - the called Solidity function must be `payable`.
565      *
566      * _Available since v3.1._
567      */
568     function functionCallWithValue(
569         address target,
570         bytes memory data,
571         uint256 value
572     ) internal returns (bytes memory) {
573         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
574     }
575 
576     /**
577      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
578      * with `errorMessage` as a fallback revert reason when `target` reverts.
579      *
580      * _Available since v3.1._
581      */
582     function functionCallWithValue(
583         address target,
584         bytes memory data,
585         uint256 value,
586         string memory errorMessage
587     ) internal returns (bytes memory) {
588         require(address(this).balance >= value, "Address: insufficient balance for call");
589         require(isContract(target), "Address: call to non-contract");
590 
591         (bool success, bytes memory returndata) = target.call{value: value}(data);
592         return verifyCallResult(success, returndata, errorMessage);
593     }
594 
595     /**
596      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
597      * but performing a static call.
598      *
599      * _Available since v3.3._
600      */
601     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
602         return functionStaticCall(target, data, "Address: low-level static call failed");
603     }
604 
605     /**
606      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
607      * but performing a static call.
608      *
609      * _Available since v3.3._
610      */
611     function functionStaticCall(
612         address target,
613         bytes memory data,
614         string memory errorMessage
615     ) internal view returns (bytes memory) {
616         require(isContract(target), "Address: static call to non-contract");
617 
618         (bool success, bytes memory returndata) = target.staticcall(data);
619         return verifyCallResult(success, returndata, errorMessage);
620     }
621 
622     /**
623      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
624      * but performing a delegate call.
625      *
626      * _Available since v3.4._
627      */
628     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
629         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
630     }
631 
632     /**
633      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
634      * but performing a delegate call.
635      *
636      * _Available since v3.4._
637      */
638     function functionDelegateCall(
639         address target,
640         bytes memory data,
641         string memory errorMessage
642     ) internal returns (bytes memory) {
643         require(isContract(target), "Address: delegate call to non-contract");
644 
645         (bool success, bytes memory returndata) = target.delegatecall(data);
646         return verifyCallResult(success, returndata, errorMessage);
647     }
648 
649     /**
650      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
651      * revert reason using the provided one.
652      *
653      * _Available since v4.3._
654      */
655     function verifyCallResult(
656         bool success,
657         bytes memory returndata,
658         string memory errorMessage
659     ) internal pure returns (bytes memory) {
660         if (success) {
661             return returndata;
662         } else {
663             // Look for revert reason and bubble it up if present
664             if (returndata.length > 0) {
665                 // The easiest way to bubble the revert reason is using memory via assembly
666 
667                 assembly {
668                     let returndata_size := mload(returndata)
669                     revert(add(32, returndata), returndata_size)
670                 }
671             } else {
672                 revert(errorMessage);
673             }
674         }
675     }
676 }
677 
678 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
679 
680 
681 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
682 
683 pragma solidity ^0.8.0;
684 
685 /**
686  * @title ERC721 token receiver interface
687  * @dev Interface for any contract that wants to support safeTransfers
688  * from ERC721 asset contracts.
689  */
690 interface IERC721Receiver {
691     /**
692      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
693      * by `operator` from `from`, this function is called.
694      *
695      * It must return its Solidity selector to confirm the token transfer.
696      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
697      *
698      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
699      */
700     function onERC721Received(
701         address operator,
702         address from,
703         uint256 tokenId,
704         bytes calldata data
705     ) external returns (bytes4);
706 }
707 
708 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
709 
710 
711 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
712 
713 pragma solidity ^0.8.0;
714 
715 /**
716  * @dev Interface of the ERC165 standard, as defined in the
717  * https://eips.ethereum.org/EIPS/eip-165[EIP].
718  *
719  * Implementers can declare support of contract interfaces, which can then be
720  * queried by others ({ERC165Checker}).
721  *
722  * For an implementation, see {ERC165}.
723  */
724 interface IERC165 {
725     /**
726      * @dev Returns true if this contract implements the interface defined by
727      * `interfaceId`. See the corresponding
728      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
729      * to learn more about how these ids are created.
730      *
731      * This function call must use less than 30 000 gas.
732      */
733     function supportsInterface(bytes4 interfaceId) external view returns (bool);
734 }
735 
736 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
737 
738 
739 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
740 
741 pragma solidity ^0.8.0;
742 
743 
744 /**
745  * @dev Implementation of the {IERC165} interface.
746  *
747  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
748  * for the additional interface id that will be supported. For example:
749  *
750  * ```solidity
751  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
752  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
753  * }
754  * ```
755  *
756  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
757  */
758 abstract contract ERC165 is IERC165 {
759     /**
760      * @dev See {IERC165-supportsInterface}.
761      */
762     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
763         return interfaceId == type(IERC165).interfaceId;
764     }
765 }
766 
767 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
768 
769 
770 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
771 
772 pragma solidity ^0.8.0;
773 
774 
775 /**
776  * @dev Required interface of an ERC721 compliant contract.
777  */
778 interface IERC721 is IERC165 {
779     /**
780      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
781      */
782     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
783 
784     /**
785      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
786      */
787     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
788 
789     /**
790      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
791      */
792     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
793 
794     /**
795      * @dev Returns the number of tokens in ``owner``'s account.
796      */
797     function balanceOf(address owner) external view returns (uint256 balance);
798 
799     /**
800      * @dev Returns the owner of the `tokenId` token.
801      *
802      * Requirements:
803      *
804      * - `tokenId` must exist.
805      */
806     function ownerOf(uint256 tokenId) external view returns (address owner);
807 
808     /**
809      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
810      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
811      *
812      * Requirements:
813      *
814      * - `from` cannot be the zero address.
815      * - `to` cannot be the zero address.
816      * - `tokenId` token must exist and be owned by `from`.
817      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
818      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
819      *
820      * Emits a {Transfer} event.
821      */
822     function safeTransferFrom(
823         address from,
824         address to,
825         uint256 tokenId
826     ) external;
827 
828     /**
829      * @dev Transfers `tokenId` token from `from` to `to`.
830      *
831      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
832      *
833      * Requirements:
834      *
835      * - `from` cannot be the zero address.
836      * - `to` cannot be the zero address.
837      * - `tokenId` token must be owned by `from`.
838      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
839      *
840      * Emits a {Transfer} event.
841      */
842     function transferFrom(
843         address from,
844         address to,
845         uint256 tokenId
846     ) external;
847 
848     /**
849      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
850      * The approval is cleared when the token is transferred.
851      *
852      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
853      *
854      * Requirements:
855      *
856      * - The caller must own the token or be an approved operator.
857      * - `tokenId` must exist.
858      *
859      * Emits an {Approval} event.
860      */
861     function approve(address to, uint256 tokenId) external;
862 
863     /**
864      * @dev Returns the account approved for `tokenId` token.
865      *
866      * Requirements:
867      *
868      * - `tokenId` must exist.
869      */
870     function getApproved(uint256 tokenId) external view returns (address operator);
871 
872     /**
873      * @dev Approve or remove `operator` as an operator for the caller.
874      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
875      *
876      * Requirements:
877      *
878      * - The `operator` cannot be the caller.
879      *
880      * Emits an {ApprovalForAll} event.
881      */
882     function setApprovalForAll(address operator, bool _approved) external;
883 
884     /**
885      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
886      *
887      * See {setApprovalForAll}
888      */
889     function isApprovedForAll(address owner, address operator) external view returns (bool);
890 
891     /**
892      * @dev Safely transfers `tokenId` token from `from` to `to`.
893      *
894      * Requirements:
895      *
896      * - `from` cannot be the zero address.
897      * - `to` cannot be the zero address.
898      * - `tokenId` token must exist and be owned by `from`.
899      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
900      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
901      *
902      * Emits a {Transfer} event.
903      */
904     function safeTransferFrom(
905         address from,
906         address to,
907         uint256 tokenId,
908         bytes calldata data
909     ) external;
910 }
911 
912 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
913 
914 
915 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
916 
917 pragma solidity ^0.8.0;
918 
919 
920 /**
921  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
922  * @dev See https://eips.ethereum.org/EIPS/eip-721
923  */
924 interface IERC721Metadata is IERC721 {
925     /**
926      * @dev Returns the token collection name.
927      */
928     function name() external view returns (string memory);
929 
930     /**
931      * @dev Returns the token collection symbol.
932      */
933     function symbol() external view returns (string memory);
934 
935     /**
936      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
937      */
938     function tokenURI(uint256 tokenId) external view returns (string memory);
939 }
940 
941 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
942 
943 
944 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
945 
946 pragma solidity ^0.8.0;
947 
948 
949 
950 
951 
952 
953 
954 
955 /**
956  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
957  * the Metadata extension, but not including the Enumerable extension, which is available separately as
958  * {ERC721Enumerable}.
959  */
960 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
961     using Address for address;
962     using Strings for uint256;
963 
964     // Token name
965     string private _name;
966 
967     // Token symbol
968     string private _symbol;
969 
970     // Mapping from token ID to owner address
971     mapping(uint256 => address) private _owners;
972 
973     // Mapping owner address to token count
974     mapping(address => uint256) private _balances;
975 
976     // Mapping from token ID to approved address
977     mapping(uint256 => address) private _tokenApprovals;
978 
979     // Mapping from owner to operator approvals
980     mapping(address => mapping(address => bool)) private _operatorApprovals;
981 
982     /**
983      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
984      */
985     constructor(string memory name_, string memory symbol_) {
986         _name = name_;
987         _symbol = symbol_;
988     }
989 
990     /**
991      * @dev See {IERC165-supportsInterface}.
992      */
993     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
994         return
995             interfaceId == type(IERC721).interfaceId ||
996             interfaceId == type(IERC721Metadata).interfaceId ||
997             super.supportsInterface(interfaceId);
998     }
999 
1000     /**
1001      * @dev See {IERC721-balanceOf}.
1002      */
1003     function balanceOf(address owner) public view virtual override returns (uint256) {
1004         require(owner != address(0), "ERC721: balance query for the zero address");
1005         return _balances[owner];
1006     }
1007 
1008     /**
1009      * @dev See {IERC721-ownerOf}.
1010      */
1011     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1012         address owner = _owners[tokenId];
1013         require(owner != address(0), "ERC721: owner query for nonexistent token");
1014         return owner;
1015     }
1016 
1017     /**
1018      * @dev See {IERC721Metadata-name}.
1019      */
1020     function name() public view virtual override returns (string memory) {
1021         return _name;
1022     }
1023 
1024     /**
1025      * @dev See {IERC721Metadata-symbol}.
1026      */
1027     function symbol() public view virtual override returns (string memory) {
1028         return _symbol;
1029     }
1030 
1031     /**
1032      * @dev See {IERC721Metadata-tokenURI}.
1033      */
1034     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1035         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1036 
1037         string memory baseURI = _baseURI();
1038         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1039     }
1040 
1041     /**
1042      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1043      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1044      * by default, can be overriden in child contracts.
1045      */
1046     function _baseURI() internal view virtual returns (string memory) {
1047         return "";
1048     }
1049 
1050     /**
1051      * @dev See {IERC721-approve}.
1052      */
1053     function approve(address to, uint256 tokenId) public virtual override {
1054         address owner = ERC721.ownerOf(tokenId);
1055         require(to != owner, "ERC721: approval to current owner");
1056 
1057         require(
1058             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1059             "ERC721: approve caller is not owner nor approved for all"
1060         );
1061 
1062         _approve(to, tokenId);
1063     }
1064 
1065     /**
1066      * @dev See {IERC721-getApproved}.
1067      */
1068     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1069         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1070 
1071         return _tokenApprovals[tokenId];
1072     }
1073 
1074     /**
1075      * @dev See {IERC721-setApprovalForAll}.
1076      */
1077     function setApprovalForAll(address operator, bool approved) public virtual override {
1078         _setApprovalForAll(_msgSender(), operator, approved);
1079     }
1080 
1081     /**
1082      * @dev See {IERC721-isApprovedForAll}.
1083      */
1084     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1085         return _operatorApprovals[owner][operator];
1086     }
1087 
1088     /**
1089      * @dev See {IERC721-transferFrom}.
1090      */
1091     function transferFrom(
1092         address from,
1093         address to,
1094         uint256 tokenId
1095     ) public virtual override {
1096         //solhint-disable-next-line max-line-length
1097         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1098 
1099         _transfer(from, to, tokenId);
1100     }
1101 
1102     /**
1103      * @dev See {IERC721-safeTransferFrom}.
1104      */
1105     function safeTransferFrom(
1106         address from,
1107         address to,
1108         uint256 tokenId
1109     ) public virtual override {
1110         safeTransferFrom(from, to, tokenId, "");
1111     }
1112 
1113     /**
1114      * @dev See {IERC721-safeTransferFrom}.
1115      */
1116     function safeTransferFrom(
1117         address from,
1118         address to,
1119         uint256 tokenId,
1120         bytes memory _data
1121     ) public virtual override {
1122         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1123         _safeTransfer(from, to, tokenId, _data);
1124     }
1125 
1126     /**
1127      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1128      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1129      *
1130      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1131      *
1132      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1133      * implement alternative mechanisms to perform token transfer, such as signature-based.
1134      *
1135      * Requirements:
1136      *
1137      * - `from` cannot be the zero address.
1138      * - `to` cannot be the zero address.
1139      * - `tokenId` token must exist and be owned by `from`.
1140      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1141      *
1142      * Emits a {Transfer} event.
1143      */
1144     function _safeTransfer(
1145         address from,
1146         address to,
1147         uint256 tokenId,
1148         bytes memory _data
1149     ) internal virtual {
1150         _transfer(from, to, tokenId);
1151         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1152     }
1153 
1154     /**
1155      * @dev Returns whether `tokenId` exists.
1156      *
1157      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1158      *
1159      * Tokens start existing when they are minted (`_mint`),
1160      * and stop existing when they are burned (`_burn`).
1161      */
1162     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1163         return _owners[tokenId] != address(0);
1164     }
1165 
1166     /**
1167      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1168      *
1169      * Requirements:
1170      *
1171      * - `tokenId` must exist.
1172      */
1173     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1174         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1175         address owner = ERC721.ownerOf(tokenId);
1176         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1177     }
1178 
1179     /**
1180      * @dev Safely mints `tokenId` and transfers it to `to`.
1181      *
1182      * Requirements:
1183      *
1184      * - `tokenId` must not exist.
1185      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1186      *
1187      * Emits a {Transfer} event.
1188      */
1189     function _safeMint(address to, uint256 tokenId) internal virtual {
1190         _safeMint(to, tokenId, "");
1191     }
1192 
1193     /**
1194      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1195      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1196      */
1197     function _safeMint(
1198         address to,
1199         uint256 tokenId,
1200         bytes memory _data
1201     ) internal virtual {
1202         _mint(to, tokenId);
1203         require(
1204             _checkOnERC721Received(address(0), to, tokenId, _data),
1205             "ERC721: transfer to non ERC721Receiver implementer"
1206         );
1207     }
1208 
1209     /**
1210      * @dev Mints `tokenId` and transfers it to `to`.
1211      *
1212      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1213      *
1214      * Requirements:
1215      *
1216      * - `tokenId` must not exist.
1217      * - `to` cannot be the zero address.
1218      *
1219      * Emits a {Transfer} event.
1220      */
1221     function _mint(address to, uint256 tokenId) internal virtual {
1222         require(to != address(0), "ERC721: mint to the zero address");
1223         require(!_exists(tokenId), "ERC721: token already minted");
1224 
1225         _beforeTokenTransfer(address(0), to, tokenId);
1226 
1227         _balances[to] += 1;
1228         _owners[tokenId] = to;
1229 
1230         emit Transfer(address(0), to, tokenId);
1231     }
1232 
1233     /**
1234      * @dev Destroys `tokenId`.
1235      * The approval is cleared when the token is burned.
1236      *
1237      * Requirements:
1238      *
1239      * - `tokenId` must exist.
1240      *
1241      * Emits a {Transfer} event.
1242      */
1243     function _burn(uint256 tokenId) internal virtual {
1244         address owner = ERC721.ownerOf(tokenId);
1245 
1246         _beforeTokenTransfer(owner, address(0), tokenId);
1247 
1248         // Clear approvals
1249         _approve(address(0), tokenId);
1250 
1251         _balances[owner] -= 1;
1252         delete _owners[tokenId];
1253 
1254         emit Transfer(owner, address(0), tokenId);
1255     }
1256 
1257     /**
1258      * @dev Transfers `tokenId` from `from` to `to`.
1259      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1260      *
1261      * Requirements:
1262      *
1263      * - `to` cannot be the zero address.
1264      * - `tokenId` token must be owned by `from`.
1265      *
1266      * Emits a {Transfer} event.
1267      */
1268     function _transfer(
1269         address from,
1270         address to,
1271         uint256 tokenId
1272     ) internal virtual {
1273         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1274         require(to != address(0), "ERC721: transfer to the zero address");
1275 
1276         _beforeTokenTransfer(from, to, tokenId);
1277 
1278         // Clear approvals from the previous owner
1279         _approve(address(0), tokenId);
1280 
1281         _balances[from] -= 1;
1282         _balances[to] += 1;
1283         _owners[tokenId] = to;
1284 
1285         emit Transfer(from, to, tokenId);
1286     }
1287 
1288     /**
1289      * @dev Approve `to` to operate on `tokenId`
1290      *
1291      * Emits a {Approval} event.
1292      */
1293     function _approve(address to, uint256 tokenId) internal virtual {
1294         _tokenApprovals[tokenId] = to;
1295         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1296     }
1297 
1298     /**
1299      * @dev Approve `operator` to operate on all of `owner` tokens
1300      *
1301      * Emits a {ApprovalForAll} event.
1302      */
1303     function _setApprovalForAll(
1304         address owner,
1305         address operator,
1306         bool approved
1307     ) internal virtual {
1308         require(owner != operator, "ERC721: approve to caller");
1309         _operatorApprovals[owner][operator] = approved;
1310         emit ApprovalForAll(owner, operator, approved);
1311     }
1312 
1313     /**
1314      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1315      * The call is not executed if the target address is not a contract.
1316      *
1317      * @param from address representing the previous owner of the given token ID
1318      * @param to target address that will receive the tokens
1319      * @param tokenId uint256 ID of the token to be transferred
1320      * @param _data bytes optional data to send along with the call
1321      * @return bool whether the call correctly returned the expected magic value
1322      */
1323     function _checkOnERC721Received(
1324         address from,
1325         address to,
1326         uint256 tokenId,
1327         bytes memory _data
1328     ) private returns (bool) {
1329         if (to.isContract()) {
1330             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1331                 return retval == IERC721Receiver.onERC721Received.selector;
1332             } catch (bytes memory reason) {
1333                 if (reason.length == 0) {
1334                     revert("ERC721: transfer to non ERC721Receiver implementer");
1335                 } else {
1336                     assembly {
1337                         revert(add(32, reason), mload(reason))
1338                     }
1339                 }
1340             }
1341         } else {
1342             return true;
1343         }
1344     }
1345 
1346     /**
1347      * @dev Hook that is called before any token transfer. This includes minting
1348      * and burning.
1349      *
1350      * Calling conditions:
1351      *
1352      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1353      * transferred to `to`.
1354      * - When `from` is zero, `tokenId` will be minted for `to`.
1355      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1356      * - `from` and `to` are never both zero.
1357      *
1358      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1359      */
1360     function _beforeTokenTransfer(
1361         address from,
1362         address to,
1363         uint256 tokenId
1364     ) internal virtual {}
1365 }
1366 
1367 // File: contracts/BBC_Mint.sol
1368 
1369 
1370 
1371 //  ______                        _
1372 // (____  \                      | |
1373 //  ____)  ) ___   ____ _____  __| |
1374 // |  __  ( / _ \ / ___) ___ |/ _  |
1375 // | |__)  ) |_| | |   | ____( (_| |
1376 // |______/ \___/|_|   |_____)\____|
1377 
1378 //  ______                    _        ___
1379 // (____  \                  | |      / __)             _
1380 //  ____)  ) ____ _____ _____| |  _ _| |__ _____  ___ _| |_
1381 // |  __  ( / ___) ___ (____ | |_/ |_   __|____ |/___|_   _)
1382 // | |__)  ) |   | ____/ ___ |  _ (  | |  / ___ |___ | | |_
1383 // |______/|_|   |_____)_____|_| \_) |_|  \_____(___/   \__)
1384 
1385 //  _______ _        _
1386 // (_______) |      | |
1387 //  _      | | _   _| |__
1388 // | |     | || | | |  _ \
1389 // | |_____| || |_| | |_) )
1390 //  \______)\_)____/|____/
1391 
1392 
1393 pragma solidity 0.8.7;
1394 
1395 
1396 
1397 
1398 
1399 contract BoredBreakfastClub is ERC721, Ownable {
1400     using Strings for uint256;
1401     using Counters for Counters.Counter;
1402     Counters.Counter private _nextTokenId;
1403     Counters.Counter private _nextReservationId;
1404 
1405     address private _signerAddress;
1406     address payable public bbc_address;
1407 
1408     bool public isSaleActive = false;
1409     bool public locked;
1410 
1411     string public _tokenBaseURI;
1412     string public _contractURI;
1413 
1414     uint256 public RESERVED = 100;
1415     uint256 public PUBLIC = 9900;
1416     uint256 public MAX_TOKENS = RESERVED + PUBLIC;
1417     uint256 public PRICE = 0.08 ether;
1418     uint256 public MAX_PER_MINT = 3;
1419 
1420     mapping(string => bool) public _usedNonce;
1421 
1422     event Redeemed(address ownerOfToken, uint256 quantity, uint256 totalSupply);
1423 
1424     constructor(string memory name, string memory symbol, address _bbc_address)
1425     ERC721(name, symbol) {
1426         _nextTokenId.increment();
1427         _nextReservationId.increment();
1428         bbc_address = payable(_bbc_address);
1429     }
1430 
1431     modifier notLocked {
1432         require(!locked, "Contract metadata methods are locked");
1433         _;
1434     }
1435 
1436     function redeemReserved(address _receiver, uint256 quantity) external onlyOwner
1437     {
1438         require(totalReserved() + quantity <= RESERVED, "RESERVATIONS_ARE_CLOSED");
1439         for(uint256 i = 0; i < quantity; i++) {
1440             _nextTokenId.increment();
1441             _nextReservationId.increment();
1442             _safeMint(_receiver, totalSupply());
1443         }
1444         emit Redeemed(_receiver, quantity, totalSupply());
1445     }
1446 
1447     function redeem(uint256 quantity, string calldata nonce, bytes calldata signature)
1448     external payable
1449     {
1450         require(isSaleActive, "BREAKFAST_HAS_NOT_STARTED");
1451         require(quantity <= MAX_PER_MINT, "DON'T_BE_GREEDY_WITH_THE_BACON");
1452         require(!_usedNonce[nonce], "BREAKFAST_TICKET_USED");
1453         require(totalSupply() + quantity <= MAX_TOKENS, "BREAKFAST_HAS_BEEN_SERVED");
1454         require(_verify(_hash(msg.sender, quantity, nonce), signature), "INVALID_SIGNATURE");
1455         require(PRICE * quantity <= msg.value, "INSUFFICIENT_ETH");
1456 
1457         _usedNonce[nonce] = true;
1458         for(uint256 i = 0; i < quantity; i++) {
1459             _nextTokenId.increment();
1460             _safeMint(msg.sender, totalSupply());
1461         }
1462         emit Redeemed(msg.sender, quantity, totalSupply());
1463     }
1464 
1465     function _hash(address account, uint256 quantity, string calldata nonce)
1466     private pure returns (bytes32)
1467     {
1468         return ECDSA.toEthSignedMessageHash(keccak256(abi.encodePacked(quantity, account, nonce)));
1469     }
1470 
1471     function _verify(bytes32 digest, bytes calldata signature)
1472     private view returns (bool)
1473     {
1474         return _signerAddress == ECDSA.recover(digest, signature);
1475     }
1476 
1477     // Setters
1478     function setSaleActive() external onlyOwner {
1479         isSaleActive = !isSaleActive;
1480     }
1481 
1482     function setSignerAddress(address _signer) external onlyOwner {
1483         _signerAddress = _signer;
1484     }
1485 
1486     function setMaxTokenQty(uint256 _token_qty) external onlyOwner {
1487         MAX_PER_MINT = _token_qty;
1488     }
1489 
1490     function setMintPrice(uint256 _mint_price) external onlyOwner {
1491         PRICE = _mint_price;
1492     }
1493 
1494     function setContractURI(string calldata _uri) external onlyOwner {
1495         _contractURI = _uri;
1496     }
1497 
1498     function setTokenBaseURI(string calldata _uri) external onlyOwner notLocked {
1499         _tokenBaseURI = _uri;
1500     }
1501 
1502     function totalSupply() public view returns (uint256) {
1503         return _nextTokenId.current() - 1;
1504     }
1505 
1506     function totalReserved() public view returns (uint256) {
1507         return _nextReservationId.current() - 1;
1508     }
1509 
1510     // Metadata
1511     function contractURI() public view returns (string memory) {
1512         return _contractURI;
1513     }
1514 
1515     function tokenURI(uint256 tokenId) public view override(ERC721) returns (string memory) {
1516         require(_exists(tokenId), "Cannot query non-existent token");
1517 
1518         return string(abi.encodePacked(_tokenBaseURI, tokenId.toString()));
1519     }
1520 
1521     // Administrative
1522     function withdraw() external onlyOwner {
1523         uint256 balance = address(this).balance;
1524         (bool success, ) = bbc_address.call{value: balance}("");
1525         require(success, "Failed to send Ether");
1526     }
1527 }