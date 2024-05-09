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
1367 // File: contracts/NaftyDolls/NaftyDolls.sol
1368 
1369 //SPDX-License-Identifier: UNLICENSED
1370 
1371 pragma solidity ^0.8.0;
1372 
1373 
1374 
1375 
1376 
1377 contract NaftyDolls is ERC721, Ownable {
1378     using Strings for uint256;
1379     using ECDSA for bytes32;
1380 
1381     uint256 public MAX_PRESALE = 1000;
1382     uint256 public MAX_FREE = 1696;
1383     uint256 public maxSupply = 6969;
1384 
1385     uint256 public currentSupply = 0;
1386     uint256 public maxPerWallet = 5;
1387 
1388     uint256 public salePrice = 0.025 ether;
1389     uint256 public presalePrice = 0.02 ether;
1390 
1391     uint256 public presaleCount;
1392 
1393     uint256 public freeMinted;
1394 
1395     //Placeholders
1396     address private presaleAddress = address(0x0d9555EEa2835eE438219374dd97F0Cbe51bf0bc);
1397     address private freeAddress = address(0x642D7B2F8CaC6b7DA136D1fe8C2C912EEF32564c);
1398     address private wallet = address(0x9C86fC37EB0054f38D29C44Ba374E6e712e40F9f);
1399 
1400     string private baseURI;
1401     string private notRevealedUri = "ipfs://QmYSLyMYTPKjgavj4ZkxP8U8epdDP6mwKypg5S5UFi7it7";
1402 
1403     bool public revealed = false;
1404     bool public baseLocked = false;
1405     bool public marketOpened = false;
1406     bool public freeMintOpened = false;
1407 
1408     enum WorkflowStatus {
1409         Before,
1410         Presale,
1411         Sale,
1412         Paused,
1413         Reveal
1414     }
1415 
1416     WorkflowStatus public workflow;
1417 
1418     mapping(address => uint256) public freeMintAccess;
1419     mapping(address => uint256) public presaleMintLog;
1420     mapping(address => uint256) public freeMintLog;
1421 
1422     constructor()
1423         ERC721("NaftyDolls", "DOLLS")
1424     {
1425         transferOwnership(msg.sender);
1426         workflow = WorkflowStatus.Before;
1427 
1428         initFree();
1429     }
1430 
1431     function setApprovalForAll(address operator, bool approved) public virtual override {
1432         require(marketOpened, 'The sale of NFTs on the marketplaces has not been opened yet.');
1433         _setApprovalForAll(_msgSender(), operator, approved);
1434     }
1435 
1436     function approve(address to, uint256 tokenId) public virtual override {
1437         require(marketOpened, 'The sale of NFTs on the marketplaces has not been opened yet.');
1438         address owner = ERC721.ownerOf(tokenId);
1439         require(to != owner, "ERC721: approval to current owner");
1440 
1441         require(
1442             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1443             "ERC721: approve caller is not owner nor approved for all"
1444         );
1445 
1446         _approve(to, tokenId);
1447     }
1448 
1449     function withdraw() public onlyOwner {
1450         uint256 _balance = address( this ).balance;
1451         
1452         payable( wallet ).transfer( _balance );
1453     }
1454 
1455     //GETTERS
1456     function getSaleStatus() public view returns (WorkflowStatus) {
1457         return workflow;
1458     }
1459 
1460     function totalSupply() public view returns (uint256) {
1461         return currentSupply;
1462     }
1463 
1464     function getFreeMintAmount( address _acc ) public view returns (uint256) {
1465         return freeMintAccess[ _acc ];
1466     }
1467 
1468     function getFreeMintLog( address _acc ) public view returns (uint256) {
1469         return freeMintLog[ _acc ];
1470     }
1471 
1472     function validateSignature( address _addr, bytes memory _s ) internal view returns (bool){
1473         bytes32 messageHash = keccak256(
1474             abi.encodePacked( address(this), msg.sender)
1475         );
1476 
1477         address signer = messageHash.toEthSignedMessageHash().recover(_s);
1478 
1479         if( _addr == signer ) {
1480             return true;
1481         } else {
1482             return false;
1483         }
1484     }
1485 
1486     //Batch minting
1487     function mintBatch(
1488         address to,
1489         uint256 baseId,
1490         uint256 number
1491     ) internal {
1492 
1493         for (uint256 i = 0; i < number; i++) {
1494             _safeMint(to, baseId + i);
1495         }
1496 
1497     }
1498 
1499     /**
1500         Claims tokens for free paying only gas fees
1501      */
1502     function freeMint(uint256 _amount, bytes calldata signature) external {
1503         //Free mint check
1504         require( 
1505             freeMintOpened, 
1506             "Free mint is not opened yet." 
1507         );
1508 
1509         //Check free mint signature
1510         require(
1511             validateSignature(
1512                 freeAddress,
1513                 signature
1514             ),
1515             "SIGNATURE_VALIDATION_FAILED"
1516         );
1517 
1518         uint256 supply = currentSupply;
1519         uint256 allowedAmount = 1;
1520 
1521         if( freeMintAccess[ msg.sender ] > 0 ) {
1522             allowedAmount = freeMintAccess[ msg.sender ];
1523         } 
1524 
1525         require( 
1526             freeMintLog[ msg.sender ] + _amount <= allowedAmount, 
1527             "You dont have permision to free mint that amount." 
1528         );
1529 
1530         require(
1531             supply + _amount <= maxSupply,
1532             "NaftyDolls: Mint too large, exceeding the maxSupply"
1533         );
1534 
1535         require(
1536             freeMinted + _amount <= MAX_FREE,
1537             "NaftyDolls: Mint too large, exceeding the free mint amount"
1538         );
1539 
1540 
1541         freeMintLog[ msg.sender ] += _amount;
1542         freeMinted += _amount;
1543         currentSupply += _amount;
1544 
1545         mintBatch(msg.sender, supply, _amount);
1546     }
1547 
1548 
1549     function presaleMint(
1550         uint256 amount,
1551         bytes calldata signature
1552     ) external payable {
1553         
1554         require(
1555             workflow == WorkflowStatus.Presale,
1556             "NaftyDolls: Presale is not currently active."
1557         );
1558 
1559         require(
1560             validateSignature(
1561                 presaleAddress,
1562                 signature
1563             ),
1564             "SIGNATURE_VALIDATION_FAILED"
1565         );
1566 
1567         require(amount > 0, "You must mint at least one token");
1568 
1569         //Max per wallet check
1570         require(
1571             presaleMintLog[ msg.sender ] + amount <= maxPerWallet,
1572             "NaftyDolls: You have exceeded the max per wallet amount!"
1573         );
1574 
1575         //Price check
1576         require(
1577             msg.value >= presalePrice * amount,
1578             "NaftyDolls: Insuficient ETH amount sent."
1579         );
1580         
1581         require(
1582             presaleCount + amount <= MAX_PRESALE,
1583             "NaftyDolls: Selected amount exceeds the max presale supply"
1584         );
1585 
1586         presaleCount += amount;
1587         currentSupply += amount;
1588         presaleMintLog[ msg.sender ] += amount;
1589 
1590         mintBatch(msg.sender, currentSupply - amount, amount);
1591     }
1592 
1593     function publicSaleMint(uint256 amount) external payable {
1594         require( amount > 0, "You must mint at least one NFT.");
1595         
1596         uint256 supply = currentSupply;
1597 
1598         require( supply < maxSupply, "NaftyDolls: Sold out!" );
1599         require( supply + amount <= maxSupply, "NaftyDolls: Selected amount exceeds the max supply.");
1600 
1601         require(
1602             workflow == WorkflowStatus.Sale,
1603             "NaftyDolls: Public sale has not active."
1604         );
1605 
1606         require(
1607             msg.value >= salePrice * amount,
1608             "NaftyDolls: Insuficient ETH amount sent."
1609         );
1610 
1611         currentSupply += amount;
1612 
1613         mintBatch(msg.sender, supply, amount);
1614     }
1615 
1616     function forceMint(uint256 number, address receiver) external onlyOwner {
1617         uint256 supply = currentSupply;
1618 
1619         require(
1620             supply + number <= maxSupply,
1621             "NaftyDolls: You can't mint more than max supply"
1622         );
1623 
1624         currentSupply += number;
1625 
1626         mintBatch( receiver, supply, number);
1627     }
1628 
1629     function ownerMint(uint256 number) external onlyOwner {
1630         uint256 supply = currentSupply;
1631 
1632         require(
1633             supply + number <= maxSupply,
1634             "NaftyDolls: You can't mint more than max supply"
1635         );
1636 
1637         currentSupply += number;
1638 
1639         mintBatch(msg.sender, supply, number);
1640     }
1641 
1642     function airdrop(address[] calldata addresses) external onlyOwner {
1643         uint256 supply = currentSupply;
1644         require(
1645             supply + addresses.length <= maxSupply,
1646             "NaftyDolls: You can't mint more than max supply"
1647         );
1648 
1649         currentSupply += addresses.length;
1650 
1651         for (uint256 i = 0; i < addresses.length; i++) {
1652             _safeMint(addresses[i], supply + i);
1653         }
1654     }
1655 
1656     function setUpBefore() external onlyOwner {
1657         workflow = WorkflowStatus.Before;
1658     }
1659 
1660     function setUpPresale() external onlyOwner {
1661         workflow = WorkflowStatus.Presale;
1662     }
1663 
1664     function setUpSale() external onlyOwner {
1665         workflow = WorkflowStatus.Sale;
1666     }
1667 
1668     function pauseSale() external onlyOwner {
1669         workflow = WorkflowStatus.Paused;
1670     }
1671 
1672     function setMaxPerWallet( uint256 _amount ) external onlyOwner {
1673         maxPerWallet = _amount;
1674     }
1675 
1676     function setMaxPresale( uint256 _amount ) external onlyOwner {
1677         MAX_PRESALE = _amount;
1678     }
1679 
1680     function setMaxFree( uint256 _amount ) external onlyOwner {
1681         MAX_FREE = _amount;
1682     }
1683 
1684     function openFreeMint() public onlyOwner {
1685         freeMintOpened = true;
1686     }
1687     
1688     function stopFreeMint() public onlyOwner {
1689         freeMintOpened = false;
1690     }
1691 
1692     function reveal() public onlyOwner {
1693         revealed = true;
1694     }
1695 
1696     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1697         notRevealedUri = _notRevealedURI;
1698     }
1699 
1700     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1701         require( baseLocked == false, "Base URI change has been disabled permanently");
1702 
1703         baseURI = _newBaseURI;
1704     }
1705 
1706     function setPresaleAddress(address _newAddress) public onlyOwner {
1707         require(_newAddress != address(0), "CAN'T PUT 0 ADDRESS");
1708         presaleAddress = _newAddress;
1709     }
1710 
1711     function setWallet(address _newWallet) public onlyOwner {
1712         wallet = _newWallet;
1713     }
1714 
1715     function setSalePrice(uint256 _newPrice) public onlyOwner {
1716         salePrice = _newPrice;
1717     }
1718     
1719     function setPresalePrice(uint256 _newPrice) public onlyOwner {
1720         presalePrice = _newPrice;
1721     }
1722     
1723     function setFreeMintAccess(address _acc, uint256 _am ) public onlyOwner {
1724         freeMintAccess[ _acc ] = _am;
1725     }
1726 
1727     //Lock base security - your nfts can never be changed.
1728     function lockBase() public onlyOwner {
1729         baseLocked = true;
1730     }
1731 
1732     //Once opened, it can not be closed again
1733     function openMarket() public onlyOwner {
1734         marketOpened = true;
1735     }
1736 
1737     // FACTORY
1738     function tokenURI(uint256 tokenId)
1739         public
1740         view
1741         override(ERC721)
1742         returns (string memory)
1743     {
1744         if (revealed == false) {
1745             return notRevealedUri;
1746         }
1747 
1748         string memory currentBaseURI = baseURI;
1749         return
1750             bytes(currentBaseURI).length > 0
1751                 ? string(abi.encodePacked(currentBaseURI, tokenId.toString(),'.json'))
1752                 : "";
1753     }
1754 
1755     function initFree() internal {
1756         freeMintAccess[ address(0x9C86fC37EB0054f38D29C44Ba374E6e712e40F9f) ] = 168;
1757         freeMintAccess[ address(0x49c72c829B2aa1Ae2526fAEE29461E6cb7Efe0E6) ] = 102;
1758         freeMintAccess[ address(0x522dC68b2fd2da341d1d25595101E27118B232bD) ] = 73;
1759         freeMintAccess[ address(0xA21f8534E9521C02981a0956106d6074abE9c60f) ] = 61;
1760         freeMintAccess[ address(0xbF1aE3F91EC24B5Da2d85F2bD95a9E2a0F632d47) ] = 48;
1761         freeMintAccess[ address(0x0Cb7Dbc3837Ce16661BeC77e1Db239AAA6d4F0b4) ] = 40;
1762         freeMintAccess[ address(0xa7B463a13EF0657F0ab7b6DD03A923563e503Aea) ] = 39;
1763         freeMintAccess[ address(0x6E84a7EB0c34A757652A2474f4D2c73e288347c3) ] = 35;
1764         freeMintAccess[ address(0x883AB33f8270015102afeCBD03872458b12bf9c5) ] = 29;
1765         freeMintAccess[ address(0xb41e212b047f7A8e3961d52001ADE9413f7D0C70) ] = 24;
1766         freeMintAccess[ address(0x666e1b05Bf965b09B6D598C26Fa2Bdc27C5d3f4f) ] = 21;
1767         freeMintAccess[ address(0x0C319880d4296207b82F463B979b4923E5F9AD07) ] = 20;
1768         freeMintAccess[ address(0x86E453d8c94bc0ADC4f4B05b2b4E451e17Be8abe) ] = 20;
1769         freeMintAccess[ address(0xb0e41D26Cc795Da7220e3FBaaa0c92E6Baf65db2) ] = 20;
1770         freeMintAccess[ address(0xfB72c1a0500E18D757f722d1F71191503e937f1F) ] = 20;
1771         freeMintAccess[ address(0x1A18A57567EB571E29F14F7ae59c6fFEf2398157) ] = 13;
1772         freeMintAccess[ address(0xFaeFb5433b70f5D0857cc7f65b32eeae0316aBcb) ] = 12;
1773         freeMintAccess[ address(0x0Df8bFD2628A4b90cf8967167D0bd0F1E9969D55) ] = 11;
1774         freeMintAccess[ address(0x40E3c1262445fc6A5A8AEF06610dc44F7532c291) ] = 11;
1775         freeMintAccess[ address(0xC23e1145356A9dd3aa6Af8d7766281984ec24B76) ] = 11;
1776         freeMintAccess[ address(0x0e279033eA931f98908cc52E1ABFCa60118CAeBA) ] = 10;
1777         freeMintAccess[ address(0x9E75aa8Da215804fa82c8C6b5F24bBb7fF069541) ] = 10;
1778         freeMintAccess[ address(0x396EB23e3C593F0cD705fBA2Fb6F75c66CaAAd7a) ] = 9;
1779         freeMintAccess[ address(0x06a91aEcF753fF023033FFc6afD79904Dc6Dd22f) ] = 8;
1780         freeMintAccess[ address(0x617011B79F0761DD82Acc026F796650f5e767e84) ] = 8;
1781         freeMintAccess[ address(0x6571cb1fc92d71238aE992271D4Fca16e950a40A) ] = 8;
1782         freeMintAccess[ address(0xa2681553681a6A317F33BdCA233C510e7E9A94fC) ] = 8;
1783         freeMintAccess[ address(0xC6Ac567b250b986acAE49A842Dad7865dA4be3a0) ] = 8;
1784         freeMintAccess[ address(0xe78ec69BF9f6546fB7167f9F04B8B561e41456B3) ] = 8;
1785         freeMintAccess[ address(0x25840805c7B742488f2E5566398C99d0c39A373B) ] = 7;
1786         freeMintAccess[ address(0xA5f83912B9A8B0a6ac0DDbd24c68F88954E4C414) ] = 7;
1787         freeMintAccess[ address(0xAdBe5D005Dde820018e66D76E1295596C08E46B6) ] = 7;
1788         freeMintAccess[ address(0xbff3041A372573f65557CB58239f945b61021ee2) ] = 7;
1789         freeMintAccess[ address(0xF73931eF77Cb25dE6A06dAB426e592ED96eFe6b0) ] = 7;
1790         freeMintAccess[ address(0x1F23E7b50677C921663AA4e0c9964229fd144Df6) ] = 6;
1791         freeMintAccess[ address(0x9Aa9851eB948F1aE54388df486D45EE96fB90079) ] = 6;
1792         freeMintAccess[ address(0xD0BB6e64e1C6dEbADD41298E0fF39676630F03a8) ] = 6;
1793         freeMintAccess[ address(0x029AdC78D419072Ab70EC984C7b677BE51b0e121) ] = 5;
1794         freeMintAccess[ address(0x0fd24D3737831DcE1bbf70bEA0c66d7652e7e9Fd) ] = 5;
1795         freeMintAccess[ address(0x11eFD8579B24e49F0ff2c14Be23241045c8f7C01) ] = 5;
1796         freeMintAccess[ address(0x29425A1f1172628450c2d915317a5e2A2Ae9e8D8) ] = 5;
1797         freeMintAccess[ address(0x31B9A8347e5086B2D9C4bcA33B46CDcb04914fb1) ] = 5;
1798         freeMintAccess[ address(0x41C3BD08f55a1279C3c596449eB42e00A2E86823) ] = 5;
1799         freeMintAccess[ address(0x4e0D6e9081EEA4B76489EE135387bD99AA5e808E) ] = 5;
1800         freeMintAccess[ address(0x85EB1C61734d92d915cb54296E85473e35603ecF) ] = 5;
1801         freeMintAccess[ address(0x89EFf4ACa6aEC1e93E48DcCAF9098aD09E8A11F9) ] = 5;
1802         freeMintAccess[ address(0x8Eb0a8aa228148690313FBAfA4A7805aB304F9ce) ] = 5;
1803         freeMintAccess[ address(0xa953Ca657Eea71E5d6591B62551026E0CD6733c8) ] = 5;
1804         freeMintAccess[ address(0xB1F8D4D0eD25282A96B9D407944d69c9a988C2Ed) ] = 5;
1805         freeMintAccess[ address(0xb3caedA9DED7930a5485F6a36326B789C33c6c1e) ] = 5;
1806         freeMintAccess[ address(0xBBDCEDCC7cDac2F336d5F8f2C31cf35a29b5e4f7) ] = 5;
1807         freeMintAccess[ address(0xbfdA5CAEbFaA57871a14611F8d182d51e144C699) ] = 5;
1808         freeMintAccess[ address(0xc3C0465798ce9071513E21Ef244df6AD5f1B2eAB) ] = 5;
1809         freeMintAccess[ address(0xC53A22e8c57B7d1fecf9ec90973ea9B4C887b507) ] = 5;
1810         freeMintAccess[ address(0xCFF9Dd2C80140A8c72B9d6A04fb68A8A845c46e5) ] = 5;
1811         freeMintAccess[ address(0xE0F6Bb10e17Ae2fEcD114d43603482fcEa5A9654) ] = 9;
1812         freeMintAccess[ address(0xEa0bC5d9E7e7209Db6d154589EcB5A9eC834789B) ] = 5;
1813         freeMintAccess[ address(0xEbdE91900cC5D8B21e54Cf22200bC0BcfF797A3f) ] = 5;
1814         freeMintAccess[ address(0xfcEDD0aF38ee1F6D868Ee15ec3407A7ea4fBbDc0) ] = 5;
1815         freeMintAccess[ address(0x0783FD17d11589b59Ef7837803Bfb046c025C5Af) ] = 4;
1816         freeMintAccess[ address(0x11CfD3FAA2c11DE05B03D2bAA8720Ed650FDcfFF) ] = 4;
1817         freeMintAccess[ address(0x237f5828F189a57B0c41c260faD26fB3AabcBdB3) ] = 4;
1818         freeMintAccess[ address(0x2b2aAA6777Bd6BB6F3d0DDA951e8cd72382850A9) ] = 4;
1819         freeMintAccess[ address(0x3817Ee9AAe5Fe0260294B32D7feE557A12CaDf20) ] = 4;
1820         freeMintAccess[ address(0x55A2F801dC8C599510ffb87818dB0d5110dca971) ] = 4;
1821         freeMintAccess[ address(0x55f82Ab0Db89Fa58259fD08cf53Ab49a513d94B9) ] = 4;
1822         freeMintAccess[ address(0x611769a86D9AF4ECc50D96F62D5638F7b9a2C8b0) ] = 4;
1823         freeMintAccess[ address(0x773823a2122dC67422D80dE9F7171ed735073c99) ] = 4;
1824         freeMintAccess[ address(0x7B34328fCee7412409b2d2154b30A69603D4B1b3) ] = 4;
1825         freeMintAccess[ address(0x858dcFf3A742Ece5BF9AE20D7b1785d71097ED13) ] = 4;
1826         freeMintAccess[ address(0x9B767B0F52E63ED2CF964E7AC6f560090A90dAfB) ] = 4;
1827         freeMintAccess[ address(0xa6A7b9c9395AF131414b9d2a8500F3A9bEe4b666) ] = 4;
1828         freeMintAccess[ address(0xC28ADD98Fe22898B95267766D728bB604a9f84A4) ] = 4;
1829         freeMintAccess[ address(0xCB4DB3f102F0F505a4D545f8be593364B1c66A3C) ] = 4;
1830         freeMintAccess[ address(0xDc72374CE12BB418Aad6D6ccE5c18bE8A542D6a8) ] = 4;
1831         freeMintAccess[ address(0xE0687e41123fC40797136F4cdBC199DB6f25A807) ] = 4;
1832         freeMintAccess[ address(0x00E101ffd6eF0217fdA6d5226e5a213E216b332b) ] = 3;
1833         freeMintAccess[ address(0x02098bf554A48707579FcB28182D42947c013cfA) ] = 3;
1834         freeMintAccess[ address(0x0668f77dD7AA869AaDA6aA79bC2066B04402f33D) ] = 3;
1835         freeMintAccess[ address(0x278868be49d73284e6415d68b8583211eE96ce1F) ] = 3;
1836         freeMintAccess[ address(0x2b617e50120131172cb4f83B003C2B9870181a4b) ] = 3;
1837         freeMintAccess[ address(0x2bD89Adf988609Ba5bB91CDc4250230dDC3D9dA7) ] = 3;
1838         freeMintAccess[ address(0x2f8fb999B325FCb5182Df1a2d94801B8C8C09800) ] = 3;
1839         freeMintAccess[ address(0x316A35eBc7bFb945aB84E8BF6167585602306192) ] = 3;
1840         freeMintAccess[ address(0x34e5f6E7b84345d81d86Ae1afc213528b1F8FDA8) ] = 3;
1841         freeMintAccess[ address(0x34EDC7ab60f6cBD2005Ac07C543e19CA48B23b30) ] = 3;
1842         freeMintAccess[ address(0x39b2B1D665f018f3eE2e46947f41A83f4806e159) ] = 3;
1843         freeMintAccess[ address(0x426709Ab969F9901654942af0eAd1966Ad111a9D) ] = 3;
1844         freeMintAccess[ address(0x44539fbBC413c07b133d310f7713d354F3D55f0a) ] = 3;
1845         freeMintAccess[ address(0x5a1726eC746a9c63bB699AF5d9e8eAa0007567Ed) ] = 3;
1846         freeMintAccess[ address(0x5c8aD9343c76CCE594cB3B663410DD2fa1aC0e78) ] = 3;
1847         freeMintAccess[ address(0x62E45D439547602F36e0879fa66600b9EdD196B0) ] = 3;
1848         freeMintAccess[ address(0x642aB18dEbdf0A516083097b056489029D607530) ] = 3;
1849         freeMintAccess[ address(0x69e69571d0d07EdBEde6c43849e8d877573eE6bf) ] = 3;
1850         freeMintAccess[ address(0x6a4e2bC8529c43Bc02e7007762eBA16fe5bDBd6F) ] = 3;
1851         freeMintAccess[ address(0x6B6f0B36Ae5B19f9D0c1BD62DFF3E0bEDaA0C039) ] = 3;
1852         freeMintAccess[ address(0x76cAD91850548726F41FABedDA8119fd133ae2d9) ] = 3;
1853         freeMintAccess[ address(0x7C922CDC663367ed2ba6E84c074385121AA79291) ] = 3;
1854         freeMintAccess[ address(0x7D259bb55d3481aD0b3A39FaDd9bAf1e1E66FbB7) ] = 3;
1855         freeMintAccess[ address(0x81fA49241483A6eFB50E540b1185ED54Aa7fb5E4) ] = 3;
1856         freeMintAccess[ address(0x88acF47cdF0030F7E52e82C49606E0B7078D5E6A) ] = 3;
1857         freeMintAccess[ address(0x936c80387b8ba716FbB0Ea889BE3C37C45Dd255B) ] = 3;
1858         freeMintAccess[ address(0x9CA6103A2c7Ca4028aC7ff7163D58fFDad6aa5A1) ] = 3;
1859         freeMintAccess[ address(0x9f873b00048CbF31004968579D8beE032A509F7b) ] = 3;
1860         freeMintAccess[ address(0xA0F9Ae81cD597A889BA519f20e06C5dE63162146) ] = 3;
1861         freeMintAccess[ address(0xA9Eaa007aAE4924D650c50381b278841Ee4d4e01) ] = 3;
1862         freeMintAccess[ address(0xad1f11c7c621e628E47E164A87d97D5A048Cb2E5) ] = 3;
1863         freeMintAccess[ address(0xAeA9E80d59831660814A98109102bA1DD7A3DB0b) ] = 3;
1864         freeMintAccess[ address(0xB320cd14bCf767d2Be6831686fFf2AB8DF5B68A5) ] = 3;
1865         freeMintAccess[ address(0xB50b39a360D664D2b9e48404A0C7a64Af6eE2714) ] = 3;
1866         freeMintAccess[ address(0xB82f8752410eFb54aAeBAE73EDae3e763e95FF53) ] = 3;
1867         freeMintAccess[ address(0xc91D7378ADfF02593f5d67991C6B9721d3Bc244d) ] = 3;
1868         freeMintAccess[ address(0xcb6dBC850121BffbF43B6A9DF3C609FC8F42a111) ] = 3;
1869         freeMintAccess[ address(0xcBaECfE19E1CCb9B48eC729Ffd82AC1a0F7112eD) ] = 3;
1870         freeMintAccess[ address(0xcFEF2A369dBdFF9Ae1E632013E34ea33285969d6) ] = 3;
1871         freeMintAccess[ address(0xD0c4ADd4eD42b02443CEF35Ab64B670b8D81f5bC) ] = 3;
1872         freeMintAccess[ address(0xE15F465a129e9B7E26fC1E4e71a13D118c10cE33) ] = 3;
1873         freeMintAccess[ address(0xe4458edE9a736AEc5dB456d04B3386313a29dC46) ] = 3;
1874         freeMintAccess[ address(0xF6a7629CB1DB16B4F12DFa73085d794483771514) ] = 3;
1875         freeMintAccess[ address(0x00651B9E2924f1a5B63F6460832ab211E5829190) ] = 2;
1876         freeMintAccess[ address(0x01F3a298eb502dB16E298e31CF5Ae8974Fc2de12) ] = 2;
1877         freeMintAccess[ address(0x0360beFfdc22278fd5198e2608f5759EB9B40be4) ] = 2;
1878         freeMintAccess[ address(0x05635698333c7bD541E20d212B201d8f464D286a) ] = 2;
1879         freeMintAccess[ address(0x063972361f92495B2A3d91614B6E18711e8C765D) ] = 2;
1880         freeMintAccess[ address(0x08c85509e3B4bC0b08eB39D7acC06A1D9CDE7B1F) ] = 2;
1881         freeMintAccess[ address(0x0Eb1e0118CCc4E329c9e88efF8c2f6AD14325309) ] = 2;
1882         freeMintAccess[ address(0x142E4B0C91aD69Da00b89e01Bef41f66dE8DA45c) ] = 2;
1883         freeMintAccess[ address(0x14D4c369B7792EE9A1BeaDa5eb8D25555aD246BF) ] = 2;
1884         freeMintAccess[ address(0x18A5862eC62C95B3b370aEdAF40e8971dfAAF7E4) ] = 2;
1885         freeMintAccess[ address(0x1Ee67146295bEB4F64ED72BBb00d00C455D75003) ] = 2;
1886         freeMintAccess[ address(0x1FB7e0cA57d8a22dCc3a8A8FCeB7827eFe7AaBFc) ] = 2;
1887         freeMintAccess[ address(0x203073d988EA2f651f7363CC4468Ae8076BaF84D) ] = 2;
1888         freeMintAccess[ address(0x2110A3BC29CAb77062540fe613952994665406d5) ] = 2;
1889         freeMintAccess[ address(0x21AE1e7524c340709D5734185a89fEb1040a4393) ] = 2;
1890         freeMintAccess[ address(0x242263064cEB2Be99A376C990A52110F6472d879) ] = 2;
1891         freeMintAccess[ address(0x285bB8B9B7331e78B6aAcAd72Ae62a61Db2EAAb2) ] = 2;
1892         freeMintAccess[ address(0x297EA7fa152614C6e65E0c177A8F8c5A52BA2F14) ] = 2;
1893         freeMintAccess[ address(0x2Af6D6ec3a49443d71729f184C3Df65b827411D9) ] = 2;
1894         freeMintAccess[ address(0x2e16ee698B05BDFc0125DD0de5C8913004F5E5c3) ] = 2;
1895         freeMintAccess[ address(0x3172d85857E1ae86F4Fdb6e3143C0b4529e71084) ] = 2;
1896         freeMintAccess[ address(0x323A4e8BD47c9cF0275A31D8a23c8Bbc23367Fcc) ] = 2;
1897         freeMintAccess[ address(0x3364906e33d47B3770A0Db4C6f81824f1881c63a) ] = 2;
1898         freeMintAccess[ address(0x356f221097C5FEB632BB23A9E52eaE8C8a5Fe54B) ] = 2;
1899         freeMintAccess[ address(0x35C663401DC5B007974fcDcc3317596d1378b910) ] = 2;
1900         freeMintAccess[ address(0x35f12c7c6Ad9f23CC0D9Adc2D0f2E7254B03169F) ] = 2;
1901         freeMintAccess[ address(0x35F8aAFEd6658e4A85Eb7431761B4E82E0275d4B) ] = 2;
1902         freeMintAccess[ address(0x383cf70da21bbF077320B1398dFda88f48B7e80F) ] = 2;
1903         freeMintAccess[ address(0x3fA4682DfdC0768f338C4Ac6FADb20379Cf9d3e2) ] = 2;
1904         freeMintAccess[ address(0x4441FD519053AC38601358dC51EF91f672AF1bB9) ] = 2;
1905         freeMintAccess[ address(0x4537628215a44154ea1f9C33c544B3329721E9a6) ] = 2;
1906         freeMintAccess[ address(0x4a9b4cea73531Ebbe64922639683574104e72E4E) ] = 2;
1907         freeMintAccess[ address(0x4b427cC127371621b82a89a02301ef5ee45EA1ED) ] = 2;
1908         freeMintAccess[ address(0x4B71b5420e68Ff460A8154C311cD94aE12222300) ] = 2;
1909         freeMintAccess[ address(0x4Ce304754Bbd6Bfe8643ebba72Cf494ccb089d8e) ] = 2;
1910         freeMintAccess[ address(0x51D0eAA18e9dc6b236a14521a1462bd202894913) ] = 2;
1911         freeMintAccess[ address(0x5226060F20bD813d4fCdc9E3344e493959726648) ] = 2;
1912         freeMintAccess[ address(0x541a62d184c8A00AaaCA48fAd3ad5f1E2ABD1B6C) ] = 2;
1913         freeMintAccess[ address(0x56bF222b0e3a78ad594DB4CcD851706BCCb35eC7) ] = 2;
1914         freeMintAccess[ address(0x56E48cad4419A8a27DE6444f5839d85bCdBAfA27) ] = 2;
1915         freeMintAccess[ address(0x578E141720128EAFFf1261815C85cDFEd438b1Cd) ] = 2;
1916         freeMintAccess[ address(0x59D7F9858a959fD555BF4E81646EE425aAdFE8CE) ] = 2;
1917         freeMintAccess[ address(0x5B50AD735b4B70a764861478545AF6e2CE1Aaafe) ] = 2;
1918         freeMintAccess[ address(0x5c6141CeF1e7eee4778358E4485146fA3d503959) ] = 2;
1919         freeMintAccess[ address(0x5Db8AD9A84AeEAe718C8B225737B2c3C78BdcA59) ] = 2;
1920         freeMintAccess[ address(0x60Fc4A8Db5447EcF020c803464f2aDf5E9647C66) ] = 2;
1921         freeMintAccess[ address(0x612800D4Fc2ea61d24564c9d921a3018647B3d7c) ] = 2;
1922         freeMintAccess[ address(0x64026c16426F07D8B43c1fd37C133EBF7B92dEB4) ] = 2;
1923         freeMintAccess[ address(0x64D479a9326552bCea6F9284ca627CE6F18B5a28) ] = 2;
1924         freeMintAccess[ address(0x64fC6C7CAd57482844f239D9910336a03E6Ce831) ] = 2;
1925         freeMintAccess[ address(0x65EE7980da550072805A12d158Bf14406572F6A8) ] = 2;
1926         freeMintAccess[ address(0x68B7eA5BAB27c42be609AC02505E1120CEd72A7d) ] = 2;
1927         freeMintAccess[ address(0x690ae2e0adf1d939d0Dc9EB757ffC5AcA5a16d00) ] = 2;
1928         freeMintAccess[ address(0x6b37Cc92c7653D4c33d144Cb8284c48a02968fd2) ] = 2;
1929         freeMintAccess[ address(0x6d22E1F7060D78C753A4498C2d48fE71643Fa1d6) ] = 2;
1930         freeMintAccess[ address(0x705AB1Ff5205216e3d49B53223B56A5E159e7835) ] = 2;
1931         freeMintAccess[ address(0x70C01b34BC0B8963FD747100430aeD647F4dDcdC) ] = 2;
1932         freeMintAccess[ address(0x77AEeA17E3e367A0966a8b8BE8eC912797F4A929) ] = 2;
1933         freeMintAccess[ address(0x7E7CfF0bE2A2baD0e5e879Ff17eD9B615dFe3Ab4) ] = 2;
1934         freeMintAccess[ address(0x80C56dE765ebDFBB5b2992337B1F247C7F728dFC) ] = 2;
1935         freeMintAccess[ address(0x816F81C3fA8368CDB1EaaD755ca50c62fdA9b60D) ] = 2;
1936         freeMintAccess[ address(0x8205EB5Ed2D325e6381f62e4c0e6537F5B968bD5) ] = 2;
1937         freeMintAccess[ address(0x821fD4c8f28B47619811A7825540A7B0049B0f66) ] = 2;
1938         freeMintAccess[ address(0x8364E59631d012EaD8a4DB965df4f174DA05A260) ] = 2;
1939         freeMintAccess[ address(0x848573085b783511a47850f7C0475F3224a0fc2D) ] = 2;
1940         freeMintAccess[ address(0x866241207F759B646Dad2C9416d55045aE55Bc0B) ] = 2;
1941         freeMintAccess[ address(0x8b835e35838448a8A29Be15E926D99E9FB040822) ] = 2;
1942         freeMintAccess[ address(0x8Dc047Ce563680D2553a95Cb357EE321c164aFe0) ] = 2;
1943         freeMintAccess[ address(0x95631A17dd0F4D19eb90Cc6A0a7e330C987a5139) ] = 2;
1944         freeMintAccess[ address(0x986eAa8d5a0EC0a0f0433BBB249D15E5430CF550) ] = 2;
1945         freeMintAccess[ address(0x990450d56c41ef5e7d818E0453c2f813FEb9448A) ] = 2;
1946         freeMintAccess[ address(0x996d25fc973756cA9a177510C28afa18BEf27499) ] = 2;
1947         freeMintAccess[ address(0x9EC02aAE4653bd59aC2cE64A135c22Ade5c1856A) ] = 2;
1948         freeMintAccess[ address(0xA22F59899BFa6D3d24a0b488fBD830f6B922e1dA) ] = 2;
1949         freeMintAccess[ address(0xa6B59f2d1409B2240c4a7A02B2d27d8b15Bd2248) ] = 2;
1950         freeMintAccess[ address(0xa8f6deDCAe4D391Eaa009CB6f848bB31fDB47D02) ] = 2;
1951         freeMintAccess[ address(0xa91A55e5EfEB84Ce3d7f0Eac207B175f4c1940Ca) ] = 2;
1952         freeMintAccess[ address(0xb4C69Cf41894F7c372f349C35F0477511881bDEF) ] = 2;
1953         freeMintAccess[ address(0xB631f4eA32A8876ae37ee475C6912e94AB853694) ] = 2;
1954         freeMintAccess[ address(0xB7c6020f4A7B4ef1b4a621E48B5bA0284f2BEee1) ] = 2;
1955         freeMintAccess[ address(0xBc48d0cb0f85434186b83263dcBbA6bfE79CAa10) ] = 2;
1956         freeMintAccess[ address(0xbC4afF27c74e76e4639993679e243f80f8F455fc) ] = 2;
1957         freeMintAccess[ address(0xBd03118971755fC60e769C05067061ebf97064ba) ] = 2;
1958         freeMintAccess[ address(0xBF7FD93Fe70Fd6126c6f06DfBCe4EcA9Ac09e050) ] = 2;
1959         freeMintAccess[ address(0xC5301285da585125B1dc8CCCedD1de1845b68c0F) ] = 2;
1960         freeMintAccess[ address(0xC58BD7961088bC22Bb26232b7973973322E272f5) ] = 2;
1961         freeMintAccess[ address(0xC7fbAda2D0596377B748a73428749874BD037c39) ] = 2;
1962         freeMintAccess[ address(0xCbC0A5724626618EA59dfcc1923f16FB370E602b) ] = 2;
1963         freeMintAccess[ address(0xCf81AfD911E4c86fe1c3396776eDAa4972c4033c) ] = 2;
1964         freeMintAccess[ address(0xd10C4a705bB5eDA3498EC9a1eBFf1fDBfE265352) ] = 2;
1965         freeMintAccess[ address(0xda51c29BA453229eb2A606AB771800E341EDE8c8) ] = 2;
1966         freeMintAccess[ address(0xdEe435A6d24bed1c5391515417692239f3d5951f) ] = 2;
1967         freeMintAccess[ address(0xdFDBca65041662139e87555646967B5aBb628c5c) ] = 2;
1968         freeMintAccess[ address(0xe324C2f2524c0a7288866F9D132d5b43ef038349) ] = 2;
1969         freeMintAccess[ address(0xe3b29c5794Ac8C9c7c9fdE346209d1927A1E7B33) ] = 2;
1970         freeMintAccess[ address(0xE8eb3Ab24b9770a9A7ab9e245D21F4D6F607c651) ] = 2;
1971         freeMintAccess[ address(0xea6A7C8064e528205f36b1971CDAcf114762e1Ee) ] = 2;
1972         freeMintAccess[ address(0xeB96B4217DA1221054F9f40d47191a2CD900285c) ] = 2;
1973         freeMintAccess[ address(0xeD176ef200Ac42bDdDB95983815265b8063fcA48) ] = 2;
1974         freeMintAccess[ address(0xeE4B71C36d17b1c70E438F8204907C5e068229cc) ] = 2;
1975         freeMintAccess[ address(0xEeA5F603558a2b700291511B030fF1F5edFb1287) ] = 2;
1976         freeMintAccess[ address(0xf208A854d8dd608Ad95644e7ca3A59a31aAcDE9E) ] = 2;
1977         freeMintAccess[ address(0xF27f990990803513D65710c6615664Ed8F6830b8) ] = 2;
1978         freeMintAccess[ address(0xff4Ca96eD50cd35e165Ac65a56b3524BBD30BfE1) ] = 2;
1979     }
1980 
1981 }